"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAAccessorTest subclass:#MAIdentityAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MAIdentityAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAIdentityAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass new
!

actualClass
	^ MAIdentityAccessor
! !

!MAIdentityAccessorTest methodsFor:'testing'!

testRead
	self assert: (self accessor read: 123) = 123
!

testWrite
	self
		should: [ self accessor write: 123 to: self ]
		raise: MAWriteError.
	self assert: self value isNil
! !

!MAIdentityAccessorTest methodsFor:'testing-testing'!

testCanRead
	self assert: (self accessor canRead: self)
!

testCanWrite
	self deny: (self accessor canWrite: self)
! !

!MAIdentityAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAIdentityAccessorTest.st,v 1.1 2009-07-29 15:22:48 cg Exp $'
! !
