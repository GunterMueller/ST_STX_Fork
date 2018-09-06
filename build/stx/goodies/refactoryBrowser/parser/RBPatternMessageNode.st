"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBMessageNode subclass:#RBPatternMessageNode
	instanceVariableNames:'isList isCascadeList'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBPatternMessageNode comment:'BRMetaMessageNode is a BRMessageNode that will match other message nodes without their selectors being equal. 

Instance Variables:
	isList	<Boolean>	are we matching each keyword or matching all keywords together (e.g., `keyword1: would match a one argument method whereas `@keywords: would match 0 or more arguments)'
!


!RBPatternMessageNode methodsFor:'accessing'!

sentMessages
	^(super sentMessages)
		remove: self selector ifAbsent: [];
		yourself
! !

!RBPatternMessageNode methodsFor:'enumeration'!

allNonPatternMessageNodesDo:aBlock
    "/ intentionally left blank

    "Created: / 16-11-2016 / 20:01:27 / cg"
!

variableNodesDo:aBlock
    "/ intentionally left blank

    "Created: / 16-11-2016 / 20:01:33 / cg"
! !

!RBPatternMessageNode methodsFor:'initialize-release'!

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

!RBPatternMessageNode methodsFor:'matching'!

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
        self isSelectorList ifTrue:[                    
            ^ (aDictionary at: selectorParts first value ifAbsentPut: [aNode selectorString])
                    = aNode selectorString
                        "/ cg: this is rubbish...
                        "/ and:[ aNode selector numArgs == arguments size
                        "/  and:[ arguments size == 0
                        "/       or:[ (aDictionary at: arguments first ifAbsentPut: [aNode arguments])
                        "/             = aNode arguments]]]].
            and:[ arguments size == 0 
                  or:[(aDictionary at: arguments first ifAbsentPut: [aNode arguments]) = aNode arguments]]
        ].
        ^self matchArgumentsAgainst: aNode inContext: aDictionary

    "Modified: / 18-11-2010 / 11:37:55 / cg"
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
					[keyword isPatternVariable 
						ifTrue: [(aNode selectorParts at: i) value]
						ifFalse: [keyword value]]) 
					= (aNode selectorParts at: i) value ifFalse: [^false]].
	^true
! !

!RBPatternMessageNode methodsFor:'private'!

matchingClass
	^RBMessageNode
! !

!RBPatternMessageNode methodsFor:'testing-matching'!

isList
	^isCascadeList and: [parent notNil and: [parent isCascade]]
!

isPatternNode
	^true
!

isSelectorList
	^isList
! !

!RBPatternMessageNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

