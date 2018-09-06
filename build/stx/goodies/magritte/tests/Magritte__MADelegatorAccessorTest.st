"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAAccessorTest subclass:#MADelegatorAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MADelegatorAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADelegatorAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass on: (MASelectorAccessor selector: #value)
!

actualClass
	^ MADelegatorAccessor
! !

!MADelegatorAccessorTest methodsFor:'testing'!

testRead
	self value: 123.
	self assert: (self accessor read: self) = 123.

	self value: '123'.
	self assert: (self accessor read: self) = '123'
!

testWrite
	self accessor write: 123 to: self.
	self assert: self value = 123.

	self accessor write: '123' to: self.
	self assert: self value = '123'
! !

!MADelegatorAccessorTest methodsFor:'testing-testing'!

testCanRead
	self assert: (self accessor canRead: self).

	self accessor next readSelector: #zork.
	self deny: (self accessor canRead: self)
!

testCanWrite
	self assert: (self accessor canWrite: self).

	self accessor next writeSelector: #zork:.
	self deny: (self accessor canWrite: self)
! !

!MADelegatorAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MADelegatorAccessorTest.st,v 1.1 2009-07-29 15:21:08 cg Exp $'
! !
