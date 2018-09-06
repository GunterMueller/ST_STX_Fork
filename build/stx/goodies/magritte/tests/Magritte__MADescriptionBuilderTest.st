"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

TestCase subclass:#MADescriptionBuilderTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Utility'
!


!MADescriptionBuilderTest class methodsFor:'mock-descriptions'!

descriptionContainer
	^ super descriptionContainer label: 'mock'
!

descriptionContainer: aDescription
	^ aDescription propertyAt: #bar put: nil; yourself
!

descriptionContainerFoo: aDescription
	^ aDescription propertyAt: #foo put: nil; yourself
!

descriptionDescription
	^ MAToOneRelationDescription new label: 'foo'
!

descriptionDescription: aDescription
	^ aDescription propertyAt: #foo put: nil; yourself
!

descriptionDescriptionBar: aDescription
	^ aDescription propertyAt: #bar put: nil; yourself
!

descriptionDescriptionRec: aDescription
	^ aDescription reference: self description
! !

!MADescriptionBuilderTest methodsFor:'running'!

setUp
	super setUp.
	MADescriptionBuilder default flush
! !

!MADescriptionBuilderTest methodsFor:'testing'!

testContainer
	self assert: self description label = 'mock'.
	self assert: (self description hasProperty: #foo).
	self assert: (self description hasProperty: #bar)
!

testDescription
	self assert: self description size = 1.
	self assert: self description children first label = 'foo'.
	self assert: (self description children first hasProperty: #foo).
	self assert: (self description children first hasProperty: #bar)
!

testExtension
	| description |
	description := MAMockAddress new description
		detect: [ :each | each accessor selector = #place ].
	self assert: description isRequired.
	self assert: description isVisible not
!

testNilled
	| description |
	description := MAMockAddress new description.
	self assert: description size = 3
!

testRecursive
	self assert: self description children first reference = self description
! !

!MADescriptionBuilderTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MADescriptionBuilderTest.st,v 1.1 2009-07-29 15:19:14 cg Exp $'
! !
