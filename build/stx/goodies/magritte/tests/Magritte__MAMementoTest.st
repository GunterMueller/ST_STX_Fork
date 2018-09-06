"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAObjectTest subclass:#MAMementoTest
	instanceVariableNames:'description memento value'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Memento'
!


!MAMementoTest class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAMementoTest methodsFor:'accessing'!

description
	^ description
!

descriptionValue
	^ self description children first
!

instance
	^ memento
!

memento
	^ memento
! !

!MAMementoTest methodsFor:'accessing-memento'!

read
	^ self memento readUsing: self descriptionValue
!

write: anObject
	self memento write: anObject using: self descriptionValue
! !

!MAMementoTest methodsFor:'accessing-model'!

value
	^ value
!

value: anObject
	value := anObject
! !

!MAMementoTest methodsFor:'private'!

actualClass
	^ MAMemento
!

defaultInstance
	^ 'Lukas Renggli'
!

descriptionInstance
	^ MAContainer with: (MAStringDescription new
			default: self defaultInstance;
			accessor: #value;
			yourself)
!

includedInstance
	^ 'Rene Magritte'
!

invalidInstance
	^ 31415
!

mementoInstance
	^ self actualClass model: self modelInstance
!

modelInstance
	^ self
!

nullInstance
	^ nil
!

otherInstance
	^ 'Ursula Freitag'
! !

!MAMementoTest methodsFor:'running'!

setUp
	super setUp.
	description := self descriptionInstance.
	memento := self mementoInstance
! !

!MAMementoTest methodsFor:'testing-accessing'!

testDescription
	self assert: self memento description = self description.
	self assert: self memento description = self descriptionInstance
!

testModel
	self assert: self memento model = self modelInstance
! !

!MAMementoTest methodsFor:'testing-actions'!

testCommit
	self subclassResponsibility
!

testReset
	self subclassResponsibility
!

testValidateIncluded
	self write: self includedInstance.
	self shouldnt: [ self memento validate ] raise: MAValidationError
!

testValidateInvalid
	self write: self invalidInstance.
	self should: [ self memento validate ] raise: MAValidationError
!

testValidateRequired
	self descriptionValue beRequired.

	self write: self nullInstance.
	self should: [ self memento validate ] raise: MAValidationError
! !

!MAMementoTest methodsFor:'testing-basic'!

testRead
	self subclassResponsibility
!

testWrite
	self subclassResponsibility
! !

!MAMementoTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAMementoTest.st,v 1.1 2009-07-29 15:16:54 cg Exp $'
! !
