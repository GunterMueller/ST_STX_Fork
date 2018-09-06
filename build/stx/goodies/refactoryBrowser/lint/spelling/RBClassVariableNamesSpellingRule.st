"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBClassVariableNamesSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBClassVariableNamesSpellingRule methodsFor:'accessing'!

name
	^ 'Class variable names'
!

resultClass
        ^ ClassEnvironment "/ RBClassEnvironment
! !

!RBClassVariableNamesSpellingRule methodsFor:'running'!

checkClass: aContext 
	aContext selectedClass isMeta
		ifTrue: [ ^ self ].
	aContext selectedClass classVarNames do: [ :name |
		(self checkIdentifier: name) do: [ :each | 
			result
				addSearchString: each;
				addClass: aContext selectedClass ] ]
! !

!RBClassVariableNamesSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:09:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:09:10 cg Exp $'
! !

