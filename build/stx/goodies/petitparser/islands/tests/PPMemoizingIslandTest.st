"{ Package: 'stx:goodies/petitparser/islands/tests' }"

"{ NameSpace: Smalltalk }"

PPIslandTest subclass:#PPMemoizingIslandTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Tests'
!

!PPMemoizingIslandTest class methodsFor:'as yet unclassified'!

shouldInheritSelectors 
	^ true.
! !

!PPMemoizingIslandTest methodsFor:'as yet unclassified'!

islandClass
	^ PPMemoizingIsland 
! !

!PPMemoizingIslandTest methodsFor:'testing'!

testMemo
	| parser  result1 result2 context input |
	
	parser := self island: ('class' asParser, self identifier, 'endclass' asParser).
	input := 'class Foo endclass' asPetitStream.
	
	context := PPContext new.
	
	result1 :=  parser parse: input withContext: context.
	result2 := parser parse: input withContext: context.
	self assert: (result1 == result2 ).
! !

