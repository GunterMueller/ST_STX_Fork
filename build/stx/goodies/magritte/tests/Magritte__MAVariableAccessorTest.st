"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAAccessorTest subclass:#MAVariableAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MAVariableAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAVariableAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass name: 'value'
!

actualClass
	^ MAVariableAccessor
! !

!MAVariableAccessorTest methodsFor:'testing'!

testName
	self accessor name: 'other'.
	self assert: self accessor name = 'other'
!

testRead
	self value: 123.
	self assert: (self accessor read: self) = 123.

	self value: '12'.
	self assert: (self accessor read: self) = '12'
!

testWrite
	self accessor write: 123 to: self.
	self assert: self value = 123.

	self accessor write: '123' to: self.
	self assert: self value = '123'
! !

!MAVariableAccessorTest methodsFor:'testing-testing'!

testCanRead
	self assert: (self accessor canRead: self).

	self accessor name: 'zork'.
	self deny: (self accessor canRead: self)
!

testCanWrite
	self assert: (self accessor canWrite: self).

	self accessor name: 'zork'.
	self deny: (self accessor canWrite: self)
! !

!MAVariableAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAVariableAccessorTest.st,v 1.4 2014-09-23 20:29:32 vrany Exp $'
!

version_CVS
    ^ '$Path: stx/goodies/magritte/tests/Magritte__MAVariableAccessorTest.st, Version: 1.0, User: jv, Time: 2014-09-23T21:29:51.103$'
! !

