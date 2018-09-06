"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAMementoTest subclass:#MAStraitMementoTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Memento'
!


!MAStraitMementoTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAStraitMementoTest methodsFor:'private'!

actualClass
	^ MAStraitMemento
! !

!MAStraitMementoTest methodsFor:'testing-actions'!

testCommit
	self write: self includedInstance.
	self assert: self value = self includedInstance.
	self assert: self read = self includedInstance.

	self memento commit.
	self assert: self value = self includedInstance.
	self assert: self read = self includedInstance
!

testReset
	self write: self includedInstance.
	self memento reset.
	self assert: self read = self includedInstance
!

testValidateRequired
! !

!MAStraitMementoTest methodsFor:'testing-basic'!

testRead
	self assert: self read = self defaultInstance.

	self value: self includedInstance.
	self assert: self read = self includedInstance.

	self value: self defaultInstance.
	self assert: self read = self defaultInstance
!

testWrite
	self write: self includedInstance.
	self assert: self value = self includedInstance.

	self write: self defaultInstance.
	self assert: self value = self defaultInstance.

	self write: self nullInstance.
	self assert: self value = self nullInstance
! !

!MAStraitMementoTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAStraitMementoTest.st,v 1.1 2009-07-29 15:22:05 cg Exp $'
! !
