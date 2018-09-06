"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

TestCase subclass:#MADynamicObjectTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Utility'
!


!MADynamicObjectTest methodsFor:'testing'!

testCalculated
	| object dummy |
	object := [ Time millisecondClockValue ] asDynamicObject.
	dummy := object yourself.

	(Delay forMilliseconds: 2) wait.
	self assert: dummy < object yourself
!

testCollection
	| object |
	object := [ OrderedCollection with: 1 with: 2 ] asDynamicObject.
	self assert: object size = 2.
	self assert: object first = 1.
	self assert: object second = 2.

	object add: 3.
	self assert: object size = 2.
	self assert: object first = 1.
	self assert: object second = 2
!

testConstant
	| object |
	object := [ self ] asDynamicObject.
	self assert: object = self.

	object := [ 123 ] asDynamicObject.
	self assert: object = 123
!

testCopy
	| object first second |
	object := [ Time millisecondClockValue ] asDynamicObject copy.
	first := object yourself.
	(Delay forMilliseconds: 2) wait.
	second := object yourself.

	self assert: first < second
!

testCounter
	| object counter |
	counter := nil.
	object := [
		counter := counter isNil
			ifTrue: [ 1 ]
			ifFalse: [ counter := counter + 1 ] ]
		asDynamicObject.

	self assert: object = 1.
	self assert: object yourself = 2.
	self assert: object yourself yourself = 3
!

testDynamic
	| object collection |
	collection := nil.
	object := [
		collection isNil
			ifTrue: [ collection := OrderedCollection with: 1 with: 2 ]
			ifFalse: [ collection ] ]
		asDynamicObject.

	self assert: object size = 2.
	self assert: object first = 1.
	self assert: object second = 2.

	object add: 3.
	self assert: object size = 3.
	self assert: object first = 1.
	self assert: object second = 2.
	self assert: object third = 3
!

testNilOrNotNil
        | object |
        object := [ 1 ] asDynamicObject.
        self deny: object isNil.
        self assert: object notNil.

        object := [ nil ] asDynamicObject.
        self assert: object isNil.
        self deny: object notNil
! !

!MADynamicObjectTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MADynamicObjectTest.st,v 1.5 2014-09-24 08:11:41 vrany Exp $'
! !

