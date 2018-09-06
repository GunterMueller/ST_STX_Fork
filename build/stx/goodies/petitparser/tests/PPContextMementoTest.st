"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPContextMementoTest
	instanceVariableNames:'memento'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!


!PPContextMementoTest methodsFor:'accessing'!

memento
	^ PPContextMemento new
! !

!PPContextMementoTest methodsFor:'running'!

setUp
	super setUp.
	memento := self memento.
! !

!PPContextMementoTest methodsFor:'tests'!

testEquality
	| m1 m2  |
	m1 := self memento.
	m2 := self memento.
	
	self assert: m1 = m2.
	
	m1 propertyAt: #foo put: #bar.
	self assert: (m1 = m2) not.
	
	m2 propertyAt: #foo put: #bar.
	self assert: m1 = m2.
!

testEquality2
	| m1 m2  |
	m1 := self memento.
	m2 := self memento.
	
	self assert: m1 = m2.
	
	m1 propertyAt: #foo put: #bar.
	self assert: (m1 = m2) not.
	
	m2 propertyAt: #bar put: #foo.
	self assert: (m1 = m2) not.
!

testGetProperty
	
	| c retval retval2 |
	c := OrderedCollection new.
	
	memento propertyAt: #foo put: c.
	
	retval := memento propertyAt: #foo.
	self assert: retval size = c size.
	self assert: (retval == c) not.
	self assert: retval = c.
	
	c add: #element.
	self assert: (retval = c) not.

	retval2 := memento propertyAt: #foo.
	self assert: (retval = retval2).
	self assert: (retval == retval2) not.
	
	retval add: #element.
	self assert: (retval = retval2) not.
!

testKeysAndValuesDo
	|   |
	memento keysAndValuesDo: [ :key :value |
		self signalFailure: 'Should not be called'
	].
!

testKeysAndValuesDo2
	| c1 c2   |
	c1 := OrderedCollection new.
	c2 := OrderedCollection new.

	memento propertyAt: #foo put: c1.
	memento propertyAt: #bar put: c2.

	memento keysAndValuesDo: [ :key :value |
		self assert: (value == c1) not.
		self assert: (value == c2) not.
	].
!

testPutProperty
	| c retval  |
	c := OrderedCollection new.
	self assert: (memento hasProperty: #foo) not.
	self assert: (memento hasProperty: #bar) not.	
	
	self should: [ memento propertyAt: #foo ] raise: Error.
	self assert: (memento propertyAt: #foo ifAbsent: [ c ]) == c.
	
	retval := memento propertyAt: #foo ifAbsentPut: [ c ].
	self assert: retval size = c size.	
	self assert: (retval == c) not.
	self assert: retval = c.
	self assert: (memento hasProperty: #foo).
	
	retval := memento propertyAt: #bar put: c.
	self assert: retval size = c size.	
	self assert: (retval == c) not.
	self assert: retval = c.
	self assert: (memento hasProperty: #foo).	
! !

!PPContextMementoTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

