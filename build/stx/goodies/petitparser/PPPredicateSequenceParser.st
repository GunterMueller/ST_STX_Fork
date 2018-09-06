"{ Package: 'stx:goodies/petitparser' }"

PPPredicateParser subclass:#PPPredicateSequenceParser
	instanceVariableNames:'size'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPPredicateSequenceParser class methodsFor:'instance creation'!

on: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger 
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger
!

on: aBlock message: aString size: anInteger
	^ self on: aBlock message: aString negated: [ :each | (aBlock value: each) not ] message: 'no ' , aString size: anInteger 
! !


!PPPredicateSequenceParser methodsFor:'accessing'!

size
	"Answer the sequence size of the receiver."

	^ size
! !

!PPPredicateSequenceParser methodsFor:'initialization'!

initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString.
	size := anInteger 
! !

!PPPredicateSequenceParser methodsFor:'operators'!

negate
	"Answer a parser that is the negation of the receiving predicate parser."
	
	^ self class 
		on: negated message: negatedMessage
		negated: predicate message: predicateMessage
		size: size
! !

!PPPredicateSequenceParser methodsFor:'parsing'!

parseOn: aPPContext
	| memento result |
	memento := aPPContext remember.
	result := aPPContext stream next: size.
	(result size = size and: [ predicate value: result ])
		ifTrue: [ ^ result ].
	aPPContext restore: memento.
	^ PPFailure message: predicateMessage context: aPPContext
! !

!PPPredicateSequenceParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateSequenceParser.st,v 1.4 2014-03-04 14:33:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateSequenceParser.st,v 1.4 2014-03-04 14:33:22 cg Exp $'
!

version_SVN
    ^ '$Id: PPPredicateSequenceParser.st,v 1.4 2014-03-04 14:33:22 cg Exp $'
! !

