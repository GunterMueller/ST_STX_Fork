"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPRule subclass:#PPReplaceRule
	instanceVariableNames:'verificationBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPReplaceRule methodsFor:'initialization'!

initialize
	super initialize.
	verificationBlock := [ :parser | true ]
!

setVerificationBlock: aBlock
	verificationBlock := aBlock
! !

!PPReplaceRule methodsFor:'matching'!

canMatch: aParser 
	^ verificationBlock cull: aParser
! !

!PPReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPReplaceRule.st,v 1.2 2014-03-04 20:27:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPReplaceRule.st,v 1.2 2014-03-04 20:27:53 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

