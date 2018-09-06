"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPEpsilonParser subclass:#PPSentinel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!

PPSentinel class instanceVariableNames:'instance'

"
 No other class instance variables are inherited by this class.
"
!


!PPSentinel class methodsFor:'instance creation'!

instance
	^ instance ifNil: [ instance := self new ]
! !

!PPSentinel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPSentinel.st,v 1.2 2014-03-04 20:27:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPSentinel.st,v 1.2 2014-03-04 20:27:45 cg Exp $'
! !

