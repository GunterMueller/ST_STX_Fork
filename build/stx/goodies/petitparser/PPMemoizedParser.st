"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPMemoizedParser
	instanceVariableNames:'buffer context hash'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPMemoizedParser methodsFor:'operations'!

memoized
	"Ther is no point in memoizing more than once."

	^ self
! !

!PPMemoizedParser methodsFor:'parsing'!

parseOn: aPPContext
	| memento contextMemento  aStream |
	"TODO: JK memoizing needs review!!"
	
	contextMemento := aPPContext remember.
	(hash == aPPContext hash)
		ifFalse: [ self reset: aPPContext ].
	memento := (buffer at: contextMemento ifAbsentPut: [ PPMemento new ]).
	
	memento contextMemento isNil
		ifTrue: [
			aStream := aPPContext stream.
			memento result: (aStream size - aStream position + 2 < memento count
				ifTrue: [ PPFailure message: 'overflow' context: aPPContext ]
				ifFalse: [ memento increment. parser parseOn: aPPContext ]).
			memento contextMemento: aPPContext remember ]
		ifFalse: [ context restore: memento contextMemento ].
	^ memento result.
!

reset: aPPContext
	hash := aPPContext hash.
	context := aPPContext.
	buffer := Dictionary new.
! !

!PPMemoizedParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPMemoizedParser.st,v 1.3 2012-05-04 21:58:48 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPMemoizedParser.st,v 1.3 2012-05-04 21:58:48 vrany Exp $'
!

version_SVN
    ^ '§Id: PPMemoizedParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

