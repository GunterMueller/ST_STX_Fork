"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPStartOfLineParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPStartOfLineParser methodsFor:'parsing'!

parseOn: aPPContext
	(aPPContext isStartOfLine) ifTrue: [ 
		^ #startOfLine
	].
	^ PPFailure message: 'Start of line expected' context: aPPContext at: aPPContext position
! !

!PPStartOfLineParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

