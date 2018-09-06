"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBMethodNode subclass:#RBMetaMethodNode
	instanceVariableNames:'isList'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Parser-Obsolete'
!

RBMetaMethodNode comment:'BRMetaMethodNode is a BRMethodNode that will match other method nodes without their selectors being equal. 

Instance Variables:
	isList	<Boolean>	are we matching each keyword or matching all keywords together (e.g., `keyword1: would match a one argument method whereas `@keywords: would match 0 or more arguments)

'
!


!RBMetaMethodNode class methodsFor:'instance creation'!

new
    self halt:'this class is obsolete'.
    ^ super new.
! !

!RBMetaMethodNode methodsFor:'initialize-release'!

selectorParts: tokenCollection arguments: variableNodes 
        super selectorParts: tokenCollection arguments: variableNodes.
        isList := (tokenCollection first value at: 2) == ListCharacter
! !

!RBMetaMethodNode methodsFor:'matching'!

copyInContext: aDictionary 
        | selectors |
        selectors := self isSelectorList
                                ifTrue: [(aDictionary at: selectorParts first value) keywords]
                                ifFalse: [selectorParts collect: [:each | aDictionary at: each value]].
        ^(RBMethodNode new)
                selectorParts: (selectors collect: 
                                                [:each | 
                                                (each last == $: ifTrue: [RBKeywordToken] ifFalse: [RBIdentifierToken])
                                                        value: each
                                                        start: nil]);
                arguments: (self copyList: arguments inContext: aDictionary);
                body: (body copyInContext: aDictionary);
                source: (aDictionary at: '-source-');
                yourself
!

match: aNode inContext: aDictionary 
        aNode class == self matchingClass ifFalse: [^false].
        aDictionary at: '-source-' put: aNode source.
        self isSelectorList ifTrue: 
                        [^(aDictionary at: selectorParts first value ifAbsentPut: [aNode selectorString])
                                = aNode selectorString and: 
                                                [(aDictionary at: arguments first ifAbsentPut: [aNode arguments])
                                                        = aNode arguments and: [body match: aNode body inContext: aDictionary]]].
        ^(self matchArgumentsAgainst: aNode inContext: aDictionary)
                and: [body match: aNode body inContext: aDictionary]
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

!RBMetaMethodNode methodsFor:'private'!

matchingClass
        ^RBMethodNode
! !

!RBMetaMethodNode methodsFor:'testing'!

isSelectorList
	^isList
! !

!RBMetaMethodNode class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

