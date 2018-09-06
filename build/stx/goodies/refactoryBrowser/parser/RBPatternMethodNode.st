"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBMethodNode subclass:#RBPatternMethodNode
	instanceVariableNames:'isList'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBPatternMethodNode comment:'BRMetaMethodNode is a BRMethodNode that will match other method nodes without their selectors being equal. 

Instance Variables:
	isList	<Boolean>	are we matching each keyword or matching all keywords together (e.g., `keyword1: would match a one argument method whereas `@keywords: would match 0 or more arguments)

'
!


!RBPatternMethodNode methodsFor:'initialize-release'!

selectorParts: tokenCollection arguments: variableNodes 
        super selectorParts: tokenCollection arguments: variableNodes.
        isList := (tokenCollection first value at: 2) == ListCharacter
! !

!RBPatternMethodNode methodsFor:'matching'!

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
        self isSelectorList ifTrue:[ 
            ^ ((aDictionary at: selectorParts first value ifAbsentPut: [aNode selector]) = aNode selector)
            and:[
                (arguments isEmptyOrNil
                        or:[ (aDictionary at: arguments first ifAbsentPut: [aNode arguments]) = aNode arguments ])
                and: [
                    body match: aNode body inContext: aDictionary ]]].
        ^(self matchArgumentsAgainst: aNode inContext: aDictionary)
                and: [body match: aNode body inContext: aDictionary]

    "Modified: / 05-07-2010 / 17:30:00 / cg"
!

matchArgumentsAgainst: aNode inContext: aDictionary 
        self arguments size == aNode arguments size ifFalse: [^false].
        (self matchSelectorAgainst: aNode inContext: aDictionary) 
                ifFalse: [^false].
        1 to: arguments size
                do: 
                        [:i |
                        "/ validate the rule against my uppercase (global-only) change
                        ((arguments at: i) isPatternNode and:[ (arguments at: i) isUppercase ]) ifTrue:[
                            self error:'invalid argument pattern variable (should not be uppercase'.
                        ].
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

!RBPatternMethodNode methodsFor:'private'!

matchingClass
	^RBMethodNode
! !

!RBPatternMethodNode methodsFor:'testing'!

isSelectorList
	^isList
! !

!RBPatternMethodNode methodsFor:'testing-matching'!

isPatternNode
	^true
! !

!RBPatternMethodNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBPatternMethodNode.st,v 1.7 2013-09-28 12:54:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBPatternMethodNode.st,v 1.7 2013-09-28 12:54:06 cg Exp $'
! !

