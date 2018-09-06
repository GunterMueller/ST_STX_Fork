"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAMementoTest subclass:#MACachedMementoTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Memento'
!


!MACachedMementoTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MACachedMementoTest methodsFor:'private'!

actualClass
	^ MACachedMemento
! !

!MACachedMementoTest methodsFor:'testing-accessing'!

testCache
	self assert: self memento cache size = self description size
! !

!MACachedMementoTest methodsFor:'testing-actions'!

testCommit
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self value = self nullInstance.
	self assert: self memento hasChanged.

	self memento commit.
	self assert: self read = self includedInstance.
	self assert: self value = self includedInstance.
	self deny: self memento hasChanged
!

testReset
	self value: self defaultInstance.
	self write: self includedInstance.
	self assert: self memento hasChanged.

	self memento reset.
	self assert: self read = self defaultInstance.
	self assert: self value = self defaultInstance.
	self deny: self memento hasChanged
! !

!MACachedMementoTest methodsFor:'testing-basic'!

testRead
	self assert: self read = self defaultInstance.

	self value: self includedInstance.
	self assert: self read = self defaultInstance
!

testWrite
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self value = self nullInstance.

	self write: self defaultInstance.
	self assert: self read = self defaultInstance.
	self assert: self value = self nullInstance
! !

!MACachedMementoTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MACachedMementoTest.st,v 1.1 2009-07-29 15:17:08 cg Exp $'
! !
