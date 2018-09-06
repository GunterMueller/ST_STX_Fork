"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBClassNamesSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBClassNamesSpellingRule methodsFor:'accessing'!

name
	^ 'Class names'
!

resultClass
        ^ ClassEnvironment "/ RBClassEnvironment
! !

!RBClassNamesSpellingRule methodsFor:'running'!

checkClass: aContext
	| name |
	aContext selectedClass isMeta 
		ifTrue: [ ^ self ].
	name := aContext selectedClass name.
	(self checkIdentifier: name) do: [ :each | 
		result
			addSearchString: each;
			addClass: aContext selectedClass;
			addClass: aContext selectedClass class ]
! !

!RBClassNamesSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassNamesSpellingRule.st,v 1.3 2013-08-21 00:09:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassNamesSpellingRule.st,v 1.3 2013-08-21 00:09:08 cg Exp $'
! !

