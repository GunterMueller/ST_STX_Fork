"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

PPDelegateParser subclass:#PPWater
	instanceVariableNames:'waterToken context'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Parsers'
!


!PPWater class methodsFor:'as yet unclassified'!

on: parser
	^ self on: parser waterToken: #any asParser
!

on: parser waterToken: waterToken
	^ (super on: parser)
		waterToken: waterToken;
		yourself
! !

!PPWater methodsFor:'as yet unclassified'!

checkContext: aPPContext
	context == aPPContext ifFalse: [ 
		self reset: aPPContext
	]
!

children
	^ Array with: waterToken
!

initialize
	super initialize.
	waterToken := nil asParser.
	context := nil.
!

parseOn: aPPContext
	| waterPosition result |
	
	(aPPContext waterPosition == aPPContext position) ifFalse: [ 
		waterPosition := aPPContext waterPosition.
		aPPContext waterPosition: aPPContext position.

		"TODO: probably can be rewritten with test in the end!!"
		result := parser parseOn: aPPContext.
		[result isPetitFailure] whileFalse: [ 
			waterToken parseOn: aPPContext.
			aPPContext waterPosition: aPPContext position.
			result := parser parseOn: aPPContext.
		].
		
		aPPContext waterPosition: waterPosition.
	].

	^ #water
!

replace: child with: anotherChild
	child == waterToken  ifTrue: [ 
		waterToken := anotherChild.
	]
!

reset: aPPContext
	| waterObjects |
	
	context := aPPContext.

	waterObjects := aPPContext globalAt: #waterObjects ifAbsent: [ OrderedCollection new ].
	waterObjects add: #any asParser.
	waterToken := PPChoiceParser withAll: waterObjects.
!

waterToken: aPPParser
	^ waterToken := aPPParser
! !

!PPWater class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

