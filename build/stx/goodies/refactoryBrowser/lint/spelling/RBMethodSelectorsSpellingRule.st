"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBMethodSelectorsSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBMethodSelectorsSpellingRule methodsFor:'accessing'!

name
	^ 'Method selectors'
! !

!RBMethodSelectorsSpellingRule methodsFor:'running'!

checkMethod: aContext 
	(self checkSelector: aContext selector) do: [ :each | 
		result
			addSearchString: each;
			addClass: aContext selectedClass selector: aContext selector ]
! !

!RBMethodSelectorsSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMethodSelectorsSpellingRule.st,v 1.3 2013-08-21 00:09:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMethodSelectorsSpellingRule.st,v 1.3 2013-08-21 00:09:38 cg Exp $'
! !

