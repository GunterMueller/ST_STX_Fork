"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPInputEnds
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Parsers'
!

!PPInputEnds methodsFor:'as yet unclassified'!

acceptsEpsilon
	^ true
!

exampleOn: aStream 
	aStream nextPutAll: '#End Of Input#'
!

isNullable 
	^ true
!

parseOn: aPPContext
	(aPPContext atEnd) ifFalse:
	[
		^ PPFailure message: 'end of input expected' context: aPPContext.
	].
	^ #inputEnds
! !

