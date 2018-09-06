"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAAccessorTest subclass:#MANullAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MANullAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MANullAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass new
!

actualClass
	^ MANullAccessor
! !

!MANullAccessorTest methodsFor:'testing'!

testRead
	self
		should: [ self accessor read: self ]
		raise: MAReadError
!

testWrite
	self
		should: [ self accessor write: 123 to: self ]
		raise: MAWriteError.
	self assert: self value isNil
! !

!MANullAccessorTest methodsFor:'testing-identity'!

testAsAccessor
	super testAsAccessor.
	self assert: (nil asAccessor isKindOf: self actualClass)
! !

!MANullAccessorTest methodsFor:'testing-testing'!

testCanRead
	self deny: (self accessor canRead: self)
!

testCanWrite
	self deny: (self accessor canWrite: nil)
! !

!MANullAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MANullAccessorTest.st,v 1.1 2009-07-29 15:23:28 cg Exp $'
! !
