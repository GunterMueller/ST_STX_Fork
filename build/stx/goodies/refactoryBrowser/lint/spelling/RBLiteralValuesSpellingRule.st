"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBLiteralValuesSpellingRule
	instanceVariableNames:'matcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBLiteralValuesSpellingRule methodsFor:'accessing'!

name
	^ 'Literal values'
! !

!RBLiteralValuesSpellingRule methodsFor:'initialization'!

initialize
        super initialize.
        matcher := ParseTreeSearcher "RBParseTreeSearcher" new.
        matcher 
                matches: '`#literal'
                do: [ :node :answer | self add: node value to: answer ]
! !

!RBLiteralValuesSpellingRule methodsFor:'private'!

add: aLiteral to: aCollection
	aLiteral isString
		ifTrue: [ aCollection add: aLiteral ]
		ifFalse: [ 
			aLiteral isArray
				ifTrue: [ aLiteral do: [ :each | self add: each to: aCollection ] ] ].
	^ aCollection
! !

!RBLiteralValuesSpellingRule methodsFor:'running'!

checkMethod: aContext 
        | literals |
        literals := matcher
                executeTree: aContext parseTree
                initialAnswer: Set new.
        literals do: [ :literal |
                (self checkLiteral: literal) do: [ :each |
                        result
                                addSearchString: each;
                                addClass: aContext selectedClass selector: aContext selector ] ]
! !

!RBLiteralValuesSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBLiteralValuesSpellingRule.st,v 1.4 2014-02-26 16:18:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBLiteralValuesSpellingRule.st,v 1.4 2014-02-26 16:18:29 cg Exp $'
! !

