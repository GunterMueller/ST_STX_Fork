"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPStartOfLogicalLineParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!

!PPStartOfLogicalLineParser methodsFor:'as yet unclassified'!

isBlank: character
	^ (character == Character space or: [character == Character tab])
!

parseOn: aPPContext
	aPPContext peek isAlphaNumeric ifFalse: [ 
		^ PPFailure message: 'Start of logical line expected' context: aPPContext 
	].

	aPPContext isStartOfLine ifTrue: [ ^ #startOfLogicalLine ].
	
	
	[ aPPContext position ~= 0 ] whileTrue: [  
		aPPContext back.
		(self isBlank: aPPContext peek) ifFalse: [ 
			^ PPFailure message: 'Start of logical line expected' context: aPPContext
		].
		aPPContext isStartOfLine ifTrue: [ ^ #startOfLogicalLine ].
	]
! !

