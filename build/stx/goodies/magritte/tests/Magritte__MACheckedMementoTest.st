"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MACachedMementoTest subclass:#MACheckedMementoTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Memento'
!


!MACheckedMementoTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MACheckedMementoTest methodsFor:'private'!

actualClass
	^ MACheckedMemento
! !

!MACheckedMementoTest methodsFor:'testing-accessing'!

testOriginal
	self assert: self memento original size = self description size
! !

!MACheckedMementoTest methodsFor:'testing-actions'!

testConflictCommit
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self deny: self memento hasConflict.

	self value: self otherInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self assert: self memento hasConflict.

	self memento commit.
	self assert: self read = self includedInstance.
	self assert: self value = self includedInstance.
	self deny: self memento hasChanged.
	self deny: self memento hasConflict
!

testConflictReset
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self deny: self memento hasConflict.

	self value: self otherInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self assert: self memento hasConflict.

	self memento reset.
	self assert: self read = self otherInstance.
	self assert: self value = self otherInstance.
	self deny: self memento hasChanged.
	self deny: self memento hasConflict
!

testValidateConflictCommit
	self write: self includedInstance.
	self shouldnt: [ self memento validate ] raise: MAValidationError.

	self value: self otherInstance.
	self should: [ self memento validate ] raise: MAValidationError.

	self memento commit.
	self shouldnt: [ self memento validate ] raise: MAValidationError
!

testValidateConflictReset
	self write: self includedInstance.
	self shouldnt: [ self memento validate ] raise: MAValidationError.

	self value: self otherInstance.
	self should: [ self memento validate ] raise: MAValidationError.

	self memento reset.
	self shouldnt: [ self memento validate ] raise: MAValidationError
! !

!MACheckedMementoTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MACheckedMementoTest.st,v 1.1 2009-07-29 15:17:40 cg Exp $'
! !
