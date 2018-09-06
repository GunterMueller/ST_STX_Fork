"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBInstanceVariableNamesSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBInstanceVariableNamesSpellingRule methodsFor:'accessing'!

name
	^ 'Instance variable names'
!

resultClass
        ^ ClassEnvironment "/ RBClassEnvironment
! !

!RBInstanceVariableNamesSpellingRule methodsFor:'running'!

checkClass: aContext
	aContext selectedClass instVarNames do: [ :name |
		(self checkIdentifier: name) do: [ :each | 
			result
				addSearchString: each;
				addClass: aContext selectedClass ] ]
! !

!RBInstanceVariableNamesSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBInstanceVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:09:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBInstanceVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:09:12 cg Exp $'
! !

