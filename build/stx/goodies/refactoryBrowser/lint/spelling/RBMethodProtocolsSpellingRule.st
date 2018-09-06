"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBMethodProtocolsSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBMethodProtocolsSpellingRule methodsFor:'accessing'!

name
	^ 'Method protocols'
!

resultClass
        ^ MultiEnvironment "/ RBMultiEnvironment
! !

!RBMethodProtocolsSpellingRule methodsFor:'running'!

checkClass: aContext 
	| organizer |
	organizer := aContext selectedClass organization.
	organizer categories do: [ :protocol |
		(self checkSelector: protocol) do: [ :each |
			(organizer listAtCategoryNamed: protocol) do: [ :selector | 
				result
					addSearchString: each;
					addClass: aContext selectedClass
					selector: selector into: protocol ] ] ]
! !

!RBMethodProtocolsSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMethodProtocolsSpellingRule.st,v 1.3 2013-08-21 00:09:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMethodProtocolsSpellingRule.st,v 1.3 2013-08-21 00:09:36 cg Exp $'
! !

