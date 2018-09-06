"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaTransition subclass:#PEGFsaPredicateTransition
	instanceVariableNames:'predicate'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaPredicateTransition methodsFor:'accessing'!

predicate
    ^ predicate
!

predicate: anObject
    predicate := anObject
! !

!PEGFsaPredicateTransition methodsFor:'comparing'!

equals: anotherTransition
    (super equals: anotherTransition) ifFalse: [ ^ false ].
    (predicate asString = anotherTransition predicate asString) ifFalse: [ ^ false ].

    ^ true
! !

!PEGFsaPredicateTransition methodsFor:'gt'!

gtName
    | gtName |
    gtName := self predicate asString.
    priority < 0 ifTrue: [ gtName := gtName, ',', priority asString ].
    ^ gtName
! !

!PEGFsaPredicateTransition methodsFor:'set operations'!

intersection: transition
    | intersection |
    intersection := Array new: 255 withAll: false.
    ^ intersection
! !

!PEGFsaPredicateTransition methodsFor:'testing'!

accepts: character
    self assert: character isCharacter.
    ^ self acceptsCodePoint: character codePoint
!

acceptsCodePoint: codePoint
    self assert: codePoint isInteger.
    ^ predicate value: codePoint
!

isCharacterTransition
    ^ false
!

isEOF
    ^ false
!

isParser
    self halt: 'delete me!!'.
    ^ false
!

isPredicateTransition
    ^ true
!

overlapsWith: transition
    ^ false
! !

