"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAAccessorTest subclass:#MADictionaryAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MADictionaryAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADictionaryAccessorTest methodsFor:'accessing'!

at: aKey ifAbsent: aBlock
	^ aKey = #value 
		ifTrue: [ value ]
		ifFalse: [ aBlock value ]
!

at: aKey put: aValue
	self assert: aKey = #value.
	^ value := aValue
! !

!MADictionaryAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass key: #value
!

actualClass
	^ MADictionaryAccessor
! !

!MADictionaryAccessorTest methodsFor:'testing'!

testKey
	self accessor key: #other.
	self assert: self accessor key = #other
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

!MADictionaryAccessorTest methodsFor:'testing-testing'!

testCanRead
	self assert: (self accessor canRead: self).
	self accessor key: #zork.
	self assert: (self accessor canRead: self)
!

testCanWrite
	self assert: (self accessor canWrite: self)
! !

!MADictionaryAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MADictionaryAccessorTest.st,v 1.1 2009-07-29 15:23:59 cg Exp $'
! !
