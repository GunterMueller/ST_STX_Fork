"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBTemporaryVariableNamesSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBTemporaryVariableNamesSpellingRule methodsFor:'accessing'!

name
	^ 'Temporary variable names'
! !

!RBTemporaryVariableNamesSpellingRule methodsFor:'running'!

checkMethod: aContext
	aContext parseTree allTemporaryVariables do: [ :name | 
		(self checkIdentifier: name) do: [ :each |
			result
				addSearchString: each;
				addClass: aContext selectedClass selector: aContext selector ] ]
! !

!RBTemporaryVariableNamesSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBTemporaryVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:10:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBTemporaryVariableNamesSpellingRule.st,v 1.3 2013-08-21 00:10:13 cg Exp $'
! !

