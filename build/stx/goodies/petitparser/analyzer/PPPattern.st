"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPParser subclass:#PPPattern
	instanceVariableNames:'verificationBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPPattern class methodsFor:'instance creation'!

any
	"Matches all parsers."

	^ self on: [ :parser :context | true ]
!

class: aBehavior
	"Matches parsers that are of the class aBehavior."

	^ self on: [ :parser :context | parser class = aBehavior ]
!

kind: aBehavior
	"Matches parsers that are of the class aBehavior or one of its subclasses."

	^ self on: [ :parser :context | parser isKindOf: aBehavior ]
!

name: aString
	"Matches parsers with the name aString."

	^ self on: [ :parser :context | parser name = aString ]
!

new
	self error: 'Use an explicit constructur on ' , self name
!

on: aBlock
	"Matches parsers that satisfy an arbitrary condition in aBlock."

	^ self basicNew initializeOn: aBlock
! !

!PPPattern methodsFor:'comparing'!

= aParser
	^ self == aParser or: [ self name notNil and: [ self name = aParser name ] ]
!

hash
	^ self identityHash
! !

!PPPattern methodsFor:'initialization'!

initializeOn: aBlock
	verificationBlock := aBlock
! !

!PPPattern methodsFor:'matching'!

copyInContext: aDictionary seen: aSeenDictionary
	^ aDictionary at: self
!

match: aParser inContext: aDictionary seen: anIdentitySet
	(verificationBlock value: aParser value: aDictionary)
		ifFalse: [ ^ false ].
	^ (aDictionary at: self ifAbsentPut: [ aParser ])
		match: aParser inContext: aDictionary seen: anIdentitySet
! !

!PPPattern methodsFor:'parsing'!

parseOn: aStream
	"This is just a pattern used for matching. It should not be used in actual grammars."

	self shouldNotImplement
! !

!PPPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPPattern.st,v 1.2 2014-03-04 20:27:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPPattern.st,v 1.2 2014-03-04 20:27:49 cg Exp $'
! !

