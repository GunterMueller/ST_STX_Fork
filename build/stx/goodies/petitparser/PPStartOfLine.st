"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPStartOfLine
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!

!PPStartOfLine methodsFor:'parsing'!

parseOn: aPPContext
	(aPPContext isStartOfLine) ifTrue: [ 
		^ #startOfLine
	].
	^ PPFailure message: 'Start of line expected' context: aPPContext at: aPPContext position
! !

