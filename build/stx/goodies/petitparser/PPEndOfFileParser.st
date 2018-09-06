"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPEndOfFileParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!

!PPEndOfFileParser methodsFor:'as yet unclassified'!

acceptsEpsilon
	^ true
!

exampleOn: aStream 
	aStream nextPutAll: #'end-of-input'
!

isNullable 
	^ true
!

nonEmpty
	"I know I am empty, but it does not count in my case, I represent virtual non-existent character"
	^ self
!

parseOn: aPPContext
	(aPPContext atEnd) ifFalse:
	[
		^ PPFailure message: 'end of input expected' context: aPPContext.
	].
	^ #'end-of-input'
! !

