"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

TestCase subclass:#MAObjectTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Core'
!


!MAObjectTest class methodsFor:'accessing'!

packageNamesUnderTest
	^ #('Magritte-Model')
! !

!MAObjectTest class methodsFor:'building'!

buildTestClassFor: aClass
	" self buildTestClassFor: MAObject "

	| thisName thisClass thisCategory parentClass |
	thisName := (aClass name , 'Test') asSymbol.
	(thisName beginsWith: 'MA')
		ifFalse: [ ^ self ].
	thisClass := MACompatibility classNamed: thisName.
	thisCategory := 'Magritte-Tests-' , (aClass category copyAfterLast: $-).
	parentClass := self = thisClass
		ifTrue: [ self superclass ]
		ifFalse: [ MACompatibility classNamed: (aClass superclass name , 'Test') asSymbol ].
	thisClass := parentClass
		subclass: thisName
		instanceVariableNames: (thisClass isNil
			ifFalse: [ thisClass instanceVariablesString ]
			ifTrue: [ String new ])
			classVariableNames: ''
			poolDictionaries: ''
			category: thisCategory.
	thisClass
		compile: 'actualClass
	^ ' , aClass name
		classified: #private.
	thisClass class
		compile: 'isAbstract
	^ ' , aClass isAbstract asString
		classified: #testing.
	aClass subclassesDo: [ :each | self buildTestClassFor: each ]
! !

!MAObjectTest class methodsFor:'testing'!

isAbstract
	^ true
!

shouldInheritSelectors
	^ true
! !

!MAObjectTest methodsFor:'accessing'!

instance
	self subclassResponsibility
! !

!MAObjectTest methodsFor:'private'!

actualClass
	^ MAObject
! !

!MAObjectTest methodsFor:'testing'!

testSanity
	"If this test case fails, there is something wrong with the setup of the test-case."

	self
		assert: self actualClass isAbstract not
		description: 'Unable to test abstract class.'.
	self
		assert: self instance class = self actualClass
		description: 'Invalid test instance.'
! !

!MAObjectTest methodsFor:'testing-comparing'!

testEqual
	self assert: self instance = self instance.
	self assert: self instance = self instance copy.
	self assert: self instance copy = self instance.

	self deny: self instance = 123.
	self deny: self instance = String new
!

testHash
	self assert: self instance hash isInteger.
	self assert: self instance hash = self instance hash.
	self assert: self instance hash = self instance copy hash
! !

!MAObjectTest methodsFor:'testing-copying'!

testCopy
	self assert: self instance = self instance copy.
	self deny: self instance == self instance copy
!

testCopyProperties
	self deny: self instance properties == self instance copy properties
! !

!MAObjectTest methodsFor:'testing-properties'!

testProperties
	self assert: self instance properties notNil.
	self instance instVarNamed: 'properties' put: nil.

	self instance propertyAt: #foo put: #bar.
	self instance instVarNamed: 'properties' put: nil.

	self instance propertyAt: #foo ifAbsent: [ nil ].
	self instance instVarNamed: 'properties' put: nil.

	self instance propertyAt: #foo ifAbsentPut: [ #bar ].
	self instance instVarNamed: 'properties' put: nil.

	self instance hasProperty: #foo.
	self instance instVarNamed: 'properties' put: nil
!

testPropertiesAt
	self assert: (self instance propertyAt: #foo put: 'bar') = 'bar'.
	self assert: (self instance propertyAt: #foo) = 'bar'.
	self should: [ self instance propertyAt: #bar ] raise: MAPropertyError
!

testPropertiesAtIfAbsent
	self assert: (self instance propertyAt: #foo put: 'bar') = 'bar'.
	self assert: (self instance propertyAt: #foo ifAbsent: [ 'baz' ]) = 'bar'.
	self assert: (self instance propertyAt: #bar ifAbsent: [ 'baz' ]) = 'baz'
!

testPropertiesAtIfAbsentPut
	self assert: (self instance propertyAt: #foo put: 'bar') = 'bar'.
	self assert: (self instance propertyAt: #foo ifAbsentPut: [ 'baz' ]) = 'bar'.
	self assert: (self instance propertyAt: #foo) = 'bar'.

	self assert: (self instance propertyAt: #bar ifAbsentPut: [ 'baz' ]) = 'baz'.
	self assert: (self instance propertyAt: #bar) = 'baz'
!

testPropertiesAtIfPresent
	self assert: (self instance propertyAt: #foo ifPresent: [ :value | self assert: false ]) isNil.
	self instance propertyAt: #foo put: 1.
	self assert: (self instance propertyAt: #foo ifPresent: [ :value | self assert: value = 1. 2 ]) = 2
!

testPropertiesAtPut
	self instance propertyAt: #foo put: 'bar'.
	self assert: (self instance propertyAt: #foo) = 'bar'.

	self instance propertyAt: #foo put: 'baz'.
	self assert: (self instance propertyAt: #foo) = 'baz'
!

testPropertiesHas
	self deny: (self instance hasProperty: #foo).
	self instance propertyAt: #foo put: 'bar'.
	self assert: (self instance hasProperty: #foo).
	self deny: (self instance hasProperty: #bar)
! !

!MAObjectTest methodsFor:'testing-testing'!

testIsDescription
	self deny: self instance isDescription
! !

!MAObjectTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAObjectTest.st,v 1.1 2009-07-29 15:19:55 cg Exp $'
! !
