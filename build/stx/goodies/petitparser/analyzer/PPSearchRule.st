"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPRule subclass:#PPSearchRule
	instanceVariableNames:'answerBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPSearchRule class methodsFor:'instance creation'!

searchFor: aParser thenDo: aBlock
	^ (self searchFor: aParser) setAnswerBlock: aBlock
! !

!PPSearchRule methodsFor:'initialization'!

setAnswerBlock: aBlock
	answerBlock := aBlock
! !

!PPSearchRule methodsFor:'matching'!

canMatch: aParser
	owner setAnswer: (answerBlock cull: aParser cull: owner answer).
	^ super canMatch: aParser
!

foundMatchFor: aParser 
	^ aParser
! !

!PPSearchRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPSearchRule.st,v 1.2 2014-03-04 20:27:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPSearchRule.st,v 1.2 2014-03-04 20:27:55 cg Exp $'
! !

