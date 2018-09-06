"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPReplaceRule subclass:#PPBlockReplaceRule
	instanceVariableNames:'replaceBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPBlockReplaceRule class methodsFor:'instance creation'!

searchFor: aSearchParser replaceWith: aReplaceBlock when: aVerificationBlock
	^ (self searchFor: aSearchParser) 
		setReplaceBlock: aReplaceBlock;
		setVerificationBlock: aVerificationBlock;
		yourself
! !

!PPBlockReplaceRule methodsFor:'initialization'!

setReplaceBlock: aBlock
	replaceBlock := aBlock
! !

!PPBlockReplaceRule methodsFor:'matching'!

foundMatchFor: aParser 
	^ replaceBlock cull: aParser
! !

!PPBlockReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPBlockReplaceRule.st,v 1.2 2014-03-04 20:27:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPBlockReplaceRule.st,v 1.2 2014-03-04 20:27:48 cg Exp $'
! !

