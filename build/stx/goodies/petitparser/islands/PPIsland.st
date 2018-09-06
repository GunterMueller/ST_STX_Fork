"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPIsland
	instanceVariableNames:'island afterWaterParser beforeWaterParser context
		afterWaterDelegate beforeWaterDelegate water'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Parsers'
!

PPIsland comment:'A PPIsland allows for imprecise parsing. One can create it on a parser p by calling: ''p island'' E.g.:p := x, a island, y              accepts following inputs:x.....a.....b xabyet fails on:x....a....cxbxacx..b....a....bThe input represented by dots is called water and water can appear before and after the island. Use it, if you don''t want to define all the grammar rules and you want to skip something.I am still an experiment, but if you know how to improve me, please contact Jan Kurs at: kurs@iam.unibe.chInstance Variables	afterWaterParser:		<Object>	awp:		<Object>	beforeWaterParser:		<Object>	bwp:		<Object>	context:		<Object>	island:		<Object>afterWaterParser	- xxxxxawp	- xxxxxbeforeWaterParser	- xxxxxbwp	- xxxxxcontext	- xxxxxisland	- xxxxx'
!

!PPIsland methodsFor:'accessing'!

children

	^ Array with: water with: island with: water
!

followSet: aPPContext

	^ aPPContext root followSets at: self.	
!

initialize 
	super initialize.
	water := #any asParser name: 'water'; yourself.
!

island

	^ island
!

island: anObject
	island := anObject.
!

nextSet: aPPContext

	^ aPPContext root nextSets at: self.
!

replace: parser with: anotherParser 
	super replace: parser with: anotherParser.
	
	(water == parser) ifTrue: [ water := anotherParser ].
	(island == parser) ifTrue: [ island := anotherParser ].
!

water
	^ water
!

water: aPPParser
	water := aPPParser
! !

!PPIsland methodsFor:'memoization'!

memoized 
	^ PPMemoizingIsland new
		island: self island;
		water: water;
		yourself
!

reset: aPPContext
	context := aPPContext.
	beforeWaterParser := nil.
	afterWaterParser := nil.
! !

!PPIsland methodsFor:'parsing'!

afterWaterParser: aPPContext
	context == aPPContext ifFalse: [ self reset: aPPContext ].

	afterWaterParser ifNil: [
		afterWaterParser := self createAfterWaterParser: aPPContext.
	].
	^ afterWaterParser
!

beforeWaterParser: aPPContext
	context == aPPContext ifFalse: [ self reset: aPPContext ].

	beforeWaterParser ifNil: [
		beforeWaterParser := self createBeforeWaterParser: aPPContext.
	].
	^ beforeWaterParser
!

createAfterWaterParser: aPPContext
	|  nextSet  p |

	nextSet := Set new.
	nextSet addAll: (self nextSet: aPPContext).
	nextSet add: PPInputEnds new.
	
	nextSet := nextSet collect: [ :e | PPNonEmptyParser on: e ].
	
	p := (PPChoiceParser withAll: nextSet) not.
	^ PPWater on: p waterToken: water
!

createBeforeWaterParser: aPPContext
	| nextSet p |
	nextSet := Set new.
	nextSet addAll: (self nextSet: aPPContext).
	nextSet add: PPInputEnds new.
	
	nextSet := nextSet collect: [:e | PPNonEmptyParser on: e].
	
	p := (PPChoiceParser withAll: nextSet) not, (PPNonEmptyParser on: island) not.
	^ PPWater on: p waterToken: water.
!

exampleOn: aStream
	aStream nextPutAll: '~~~~ '.
	island exampleOn: aStream .
	aStream nextPutAll:  ' ~~~~'.
!

parseAfterWater: aPPContext
	^ (self afterWaterParser: aPPContext) parseOn: aPPContext .
!

parseBeforeWater: aPPContext
	^ (self beforeWaterParser: aPPContext) parseOn: aPPContext.
!

parseOn: aPPContext 
	|  bwr awr result retval memento |

	memento := aPPContext remember.
	"Halt ifShiftPressed."
	
	bwr := self parseBeforeWater: aPPContext.
	bwr isPetitFailure ifTrue: 
	[
		self error: 'IMO should never happen'.
	].

	"JK: HACK ALERT, FIX!!"
	(aPPContext waterPosition == aPPContext position) ifTrue:[
		result := (PPNonEmptyParser on: island) parseOn: aPPContext.
	] ifFalse: [
		result := island parseOn: aPPContext.
	].
	

	result isPetitFailure ifTrue: [ 
		retval := PPFailure message: 'Island not found between ', memento position asString, ' and ', aPPContext position asString context: aPPContext.
		aPPContext restore: memento.
		^ retval
	].


	awr := self parseAfterWater: aPPContext.	
	awr isPetitFailure ifTrue: 
	[
		retval := PPFailure message: 'IMO should not happen :(' context: aPPContext.
		aPPContext restore: memento.
		^ retval.
	].

	retval := OrderedCollection with: bwr with: result with: awr.
	^ retval


!

waterToken
	| waterObjects |
	self halt: 'deprecated?'.
	waterObjects := self globalAt: #waterObjects ifAbsent: [ OrderedCollection new ].
	waterObjects add: #any asParser.
	^ PPChoiceParser withAll: waterObjects.
! !

!PPIsland methodsFor:'queries'!

acceptsEpsilon
	"JK: Hack alert?"
	"Let us suppose island is always nullable, it helps to sequences of islands"
	^ true
	"^ island isNullableOpenSet: (IdentitySet with: self)"
!

acceptsEpsilonOpenSet: set
	"JK: Hack alert?"
	^ true
"	^ island isNullableOpenSet: set"
!

name
	^ super name ifNil: [ 'an island '].
! !

