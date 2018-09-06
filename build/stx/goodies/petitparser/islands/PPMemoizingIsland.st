"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

PPIsland subclass:#PPMemoizingIsland
	instanceVariableNames:'rootParser memoizationDictionaries'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Parsers'
!

PPMemoizingIsland comment:'A PPMemoizingIsland is memoized version of PPIsland. Use this one, unless you don''t mind really bad performance. If the memoized version is not working flawlessly, its a bug!!Please see help of the PPIsland for how to use...Instance Variables	memoizationDictionaries:		<Object>	rootParser:		<Object>memoizationDictionaries	- memoization cacherootParser	- used for memoizing, once the root changes, flushes the caches'
!


!PPMemoizingIsland class methodsFor:'as yet unclassified'!

initialize 
	super initialize 
! !

!PPMemoizingIsland methodsFor:'accessing'!

island: anObject

	island ifNil: [
		super island: anObject.
	] ifNotNil: [
		self error: 'JK: I do not want to do this' .
	] 
! !

!PPMemoizingIsland methodsFor:'initialization'!

initialize 
	super initialize.

	memoizationDictionaries := IdentityDictionary new.
! !

!PPMemoizingIsland methodsFor:'memoization'!

memoizationDictionaryForContext: aPPContext
	^ memoizationDictionaries at: aPPContext ifAbsentPut: [IdentityDictionary new].
!

memoizeResult: result onContext: aPPContext position: pos
	| memento |
	
	memento := PPMemento new.
	memento contextMemento: aPPContext remember.
	memento result: result.
	
	(self memoizationDictionaryForContext: aPPContext) at: pos put: memento.
!

memoizedResult: aPPContext
	^ (self memoizationDictionaryForContext: aPPContext) at: (aPPContext position) ifAbsent: [ nil ].
	
! !

!PPMemoizingIsland methodsFor:'parsing'!

memoized
	"We have our own implementation of memoization"
	^ self
!

nonMemoized 
	^ PPIsland new
		island: self island;
		yourself
!

parseOn: aPPContext 
	|  memoizedResult parsingPosition retval |
	memoizedResult := self memoizedResult: aPPContext.
	memoizedResult ifNotNil: [ 
		aPPContext restore: memoizedResult contextMemento.
		^ memoizedResult result 
	].
	parsingPosition := aPPContext position.
	
	retval := super parseOn: aPPContext.

	(aPPContext waterPosition == aPPContext position) ifFalse: [ 
		self memoizeResult: retval onContext: aPPContext position: parsingPosition.
	].

	^ retval.

! !

!PPMemoizingIsland class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


PPMemoizingIsland initialize!
