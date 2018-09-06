"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

PPDelegateParser subclass:#PPNonEmptyParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Parsers'
!

PPNonEmptyParser comment:'I return failure, if the delegate parser did not consumed any input.'
!


!PPNonEmptyParser methodsFor:'parsing'!

parseOn: aPPContext
	| position result |
	position := aPPContext position.
	result := parser parseOn: aPPContext.
	

	(((position == aPPContext position) and: [ aPPContext atEnd not ]) and: [ result isPetitFailure not ]) ifTrue: [ 
		^ PPFailure message: 'Epsilon parse not allowed' context: aPPContext at: position
	].
	^ result
! !

!PPNonEmptyParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

