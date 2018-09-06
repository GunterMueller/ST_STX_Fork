"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBBlockLintRule subclass:#RBDuplicatedCodeRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Experimental Rules'
!


!RBDuplicatedCodeRule class methodsFor:'testing'!

isVisible
        ^ (self name ~= #RBDuplicatedCodeRule) and:[self isBroken not]
!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( broken " does this do anything useful yet?")
! !

!RBDuplicatedCodeRule methodsFor:'accessing'!

group
        ^ 'Xperimental'
!

name
	^ 'Duplicated code'
!

rationale
	^ 'Code duplication is considered bad practice as it hinders maintenance and evolution of software.'
!

resultClass
	^ MultiEnvironment
! !

!RBDuplicatedCodeRule methodsFor:'private'!

addDuplication: aFirstMethod with: aSecondMethod in: anEnvironment
	anEnvironment
		addClass: aFirstMethod methodClass selector: aFirstMethod selector 
			into: aFirstMethod methodClass name , '>>' , aFirstMethod selector;
		addClass: aFirstMethod methodClass selector: aFirstMethod selector 
			into: aSecondMethod methodClass name , '>>' , aSecondMethod selector;
		addClass: aSecondMethod methodClass selector: aSecondMethod selector
			into: aFirstMethod methodClass name , '>>' , aFirstMethod selector;
		addClass: aSecondMethod methodClass selector: aSecondMethod selector
			into: aSecondMethod methodClass name , '>>' , aSecondMethod selector
! !

!RBDuplicatedCodeRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

