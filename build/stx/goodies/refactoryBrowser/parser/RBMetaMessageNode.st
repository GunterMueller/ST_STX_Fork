"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBMessageNode subclass:#RBMetaMessageNode
	instanceVariableNames:'isList isCascadeList'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Parser-Obsolete'
!

RBMetaMessageNode comment:'BRMetaMessageNode is a BRMessageNode that will match other message nodes without their selectors being equal. 

Instance Variables:
	isList	<Boolean>	are we matching each keyword or matching all keywords together (e.g., `keyword1: would match a one argument method whereas `@keywords: would match 0 or more arguments)'
!


!RBMetaMessageNode class methodsFor:'instance creation'!

new
    self halt:'this class is obsolete'.
    ^ super new.
! !

!RBMetaMessageNode methodsFor:'initialize-release'!

receiver: aValueNode selectorParts: keywordTokens arguments: valueNodes 
        | message |
        super 
                receiver: aValueNode
                selectorParts: keywordTokens
                arguments: valueNodes.
        isCascadeList := isList := false.
        message := keywordTokens first value.
        2 to: message size
                do: 
                        [:i | 
                        | character |
                        character := message at: i.
                        character == ListCharacter 
                                ifTrue: [isList := true]
                                ifFalse: 
                                        [character == CascadeListCharacter 
                                                ifTrue: [isCascadeList := true]
                                                ifFalse: [^self]]]
! !

!RBMetaMessageNode methodsFor:'matching'!

copyInContext: aDictionary 
        | selectors |
        self isList ifTrue: [^aDictionary at: self].
        selectors := self isSelectorList 
                                ifTrue: [(aDictionary at: selectorParts first value) keywords]
                                ifFalse: [selectorParts collect: [:each | aDictionary at: each value]].
        ^(RBMessageNode new)
                receiver: (receiver copyInContext: aDictionary);
                selectorParts: (selectors collect: 
                                                [:each | 
                                                (each last == $: ifTrue: [RBKeywordToken] ifFalse: [RBIdentifierToken]) 
                                                        value: each
                                                        start: nil]);
                arguments: (self copyList: arguments inContext: aDictionary);
                yourself
!

match: aNode inContext: aDictionary 
        aNode class == self matchingClass ifFalse: [^false].
        (receiver match: aNode receiver inContext: aDictionary) ifFalse: [^false].
        self isSelectorList ifTrue: 
                        [^(aDictionary at: selectorParts first value ifAbsentPut: [aNode selector])
                                = aNode selector and: 
                                                [(aDictionary at: arguments first ifAbsentPut: [aNode arguments])
                                                        = aNode arguments]].
        ^self matchArgumentsAgainst: aNode inContext: aDictionary
!

matchArgumentsAgainst: aNode inContext: aDictionary 
	self arguments size == aNode arguments size ifFalse: [^false].
	(self matchSelectorAgainst: aNode inContext: aDictionary) 
		ifFalse: [^false].
	1 to: arguments size
		do: 
			[:i | 
			((arguments at: i) match: (aNode arguments at: i) inContext: aDictionary) 
				ifFalse: [^false]].
	^true
!

matchSelectorAgainst: aNode inContext: aDictionary 
	| keyword |
	1 to: selectorParts size
		do: 
			[:i | 
			keyword := selectorParts at: i.
			(aDictionary at: keyword value
				ifAbsentPut: 
					[keyword isMetaVariable 
						ifTrue: [(aNode selectorParts at: i) value]
						ifFalse: [keyword value]]) 
					= (aNode selectorParts at: i) value ifFalse: [^false]].
	^true
! !

!RBMetaMessageNode methodsFor:'private'!

matchingClass
        ^RBMessageNode
! !

!RBMetaMessageNode methodsFor:'testing-matching'!

isList
	^isCascadeList and: [parent notNil and: [parent isCascade]]
!

isSelectorList
	^isList
! !

!RBMetaMessageNode class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

