"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAObjectTest subclass:#MAAccessorTest
	instanceVariableNames:'accessor value'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MAAccessorTest class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAAccessorTest methodsFor:'accessing'!

accessor
	^ accessor
!

instance
	^ accessor
! !

!MAAccessorTest methodsFor:'accessing-model'!

value
	^ value
!

value: anObject
	value := anObject
! !

!MAAccessorTest methodsFor:'private'!

accessorInstance
	self subclassResponsibility
!

actualClass
	^ MAAccessor
! !

!MAAccessorTest methodsFor:'running'!

setUp
	super setUp.
	accessor := self accessorInstance
! !

!MAAccessorTest methodsFor:'testing'!

testRead
	self subclassResponsibility
!

testWrite
	self subclassResponsibility
! !

!MAAccessorTest methodsFor:'testing-identity'!

testAsAccessor
	self assert: self instance asAccessor = self instance.
	self assert: self instance asAccessor == self instance
!

testStore
	self assert: (self actualClass evaluatorClass
		evaluate: self accessor storeString)
			= self accessor
! !

!MAAccessorTest methodsFor:'testing-testing'!

testCanRead
	self subclassResponsibility
!

testCanWrite
	self subclassResponsibility
! !

!MAAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAAccessorTest.st,v 1.1 2009-07-29 15:20:02 cg Exp $'
! !
