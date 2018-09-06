"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAAccessorTest subclass:#MAPluggableAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MAPluggableAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAPluggableAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass
		read: [ :model | model value ]
		write: [ :model :object | model value: object ]
!

actualClass
	^ MAPluggableAccessor
! !

!MAPluggableAccessorTest methodsFor:'testing'!

testRead
	self value: 123.
	self assert: (self accessor read: self) = 123.

	self value: '12'.
	self assert: (self accessor read: self) = '12'
!

testReadBlock
	self accessor readBlock: [ :model |
		self assert: model = self. 123 ].
	self assert: (self accessor read: self) = 123
!

testWrite
	self accessor write: 123 to: self.
	self assert: self value = 123.

	self accessor write: '123' to: self.
	self assert: self value = '123'
!

testWriteBlock
	self accessor writeBlock: [ :model :object |
		self assert: model = self.
		self assert: object = 123 ].
	self accessor write: 123 to: self
! !

!MAPluggableAccessorTest methodsFor:'testing-identity'!

testStore
	"The class BlockContext is not serializeable, ignore this test."
! !

!MAPluggableAccessorTest methodsFor:'testing-testing'!

testCanRead
	self assert: (self instance canRead: self).
	self instance readBlock: nil.
	self deny: (self instance canRead: self)
!

testCanWrite
	self assert: (self instance canWrite: nil).
	self assert: (self instance canWrite: 123).
	self assert: (self instance canWrite: self).

	self instance writeBlock: nil.
	self deny: (self instance canWrite: nil).
	self deny: (self instance canWrite: 123).
	self deny: (self instance canWrite: self)
! !

!MAPluggableAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAPluggableAccessorTest.st,v 1.1 2009-07-29 15:16:24 cg Exp $'
! !
