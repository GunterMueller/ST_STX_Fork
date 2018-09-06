"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPEndOfLineParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!

!PPEndOfLineParser methodsFor:'parsing'!

parseOn: aPPContext
	(aPPContext isEndOfLine) ifTrue: [ 
		^ #endOfLine
	].
	^ PPFailure message: 'End of line expected' context: aPPContext at: aPPContext position
! !

