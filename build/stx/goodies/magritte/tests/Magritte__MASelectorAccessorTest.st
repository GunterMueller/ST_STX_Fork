"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAAccessorTest subclass:#MASelectorAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MASelectorAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MASelectorAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass selector: #value
!

actualClass
	^ MASelectorAccessor
! !

!MASelectorAccessorTest methodsFor:'testing'!

testRead
	self value: 123.
	self assert: (self accessor read: self) = 123.

	self value: '12'.
	self assert: (self accessor read: self) = '12'
!

testReadSelector
	self accessor readSelector: #contents.

	self assert: self accessor selector = #contents.
	self assert: self accessor readSelector = #contents.
	self assert: self accessor writeSelector = #value:
!

testSelector
	self accessor selector: #contents.

	self assert: self accessor selector = #contents.
	self assert: self accessor readSelector = #contents.
	self assert: self accessor writeSelector = #contents:
!

testWrite
	self accessor write: 123 to: self.
	self assert: self value = 123.

	self accessor write: '123' to: self.
	self assert: self value = '123'
!

testWriteSelector
	self accessor writeSelector: #contents:.

	self assert: self accessor selector = #value.
	self assert: self accessor readSelector = #value.
	self assert: self accessor writeSelector = #contents:
! !

!MASelectorAccessorTest methodsFor:'testing-identity'!

testAsAccessor
	super testAsAccessor.
	self assert: #value asAccessor = self instance.
	self deny: #value asAccessor == self instance
! !

!MASelectorAccessorTest methodsFor:'testing-testing'!

testCanRead
	self assert: (self accessor canRead: self).

	self accessor readSelector: #zork.
	self deny: (self accessor canRead: self).

	self accessor readSelector: nil.
	self deny: (self accessor canRead: self)
!

testCanWrite
	self assert: (self accessor canWrite: self).

	self accessor writeSelector: #zork:.
	self deny: (self accessor canWrite: self).

	self accessor writeSelector: nil.
	self deny: (self accessor canWrite: self)
! !

!MASelectorAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MASelectorAccessorTest.st,v 1.1 2009-07-29 15:22:56 cg Exp $'
! !
