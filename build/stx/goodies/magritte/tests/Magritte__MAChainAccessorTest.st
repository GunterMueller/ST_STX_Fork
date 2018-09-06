"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MADelegatorAccessorTest subclass:#MAChainAccessorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Accessor'
!


!MAChainAccessorTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAChainAccessorTest methodsFor:'private'!

accessorInstance
	^ self actualClass accessors: #( holder contents value )
!

actualClass
	^ MAChainAccessor
!

holder
	^ MAValueHolder on: self
! !

!MAChainAccessorTest methodsFor:'testing'!

testAccessor
	self accessor accessor: self.
	self assert: self accessor accessor = self
!

testAsAccessor
	super testAsAccessor.
	
	accessor := #(value) asAccessor.
	self assert: (accessor isKindOf: MASelectorAccessor).
	self assert: (accessor selector = #value).
	
	accessor := #(value contents) asAccessor.
	self assert: (accessor isKindOf: MAChainAccessor).
	self assert: (accessor next isKindOf: MASelectorAccessor).
	self assert: (accessor next selector = #value).
	self assert: (accessor accessor isKindOf: MASelectorAccessor).
	self assert: (accessor accessor selector = #contents)
!

testKind
	self assert: (self accessor class = MAChainAccessor).
	self assert: (self accessor next class = MASelectorAccessor).
	self assert: (self accessor accessor class = MAChainAccessor).
	self assert: (self accessor accessor next class = MASelectorAccessor).
	self assert: (self accessor accessor accessor class = MASelectorAccessor)
!

testNext
	| next |
	next := #foo asAccessor.
	self accessor next: next.
	self assert: self accessor next = next
!

testRead
	self value: 123.
	self assert: (self accessor read: self) = 123.

	self value: '12'.
	self assert: (self accessor read: self) = '12'
!

testSelector
	self assert: self accessor next selector = #holder.
	self assert: self accessor accessor next selector = #contents.
	self assert: self accessor accessor accessor selector = #value
!

testWrite
	self accessor write: 123 to: self.
	self assert: self value = 123.

	self accessor write: '123' to: self.
	self assert: self value = '123'
! !

!MAChainAccessorTest methodsFor:'testing-testing'!

testCanRead
	self assert: (self accessor canRead: self).
	self accessor accessor accessor readSelector: #zork.
	self deny: (self accessor canRead: self)
!

testCanWrite
	self assert: (self accessor canWrite: self).
	self accessor accessor accessor writeSelector: #zork.
	self deny: (self accessor canWrite: self)
! !

!MAChainAccessorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAChainAccessorTest.st,v 1.1 2009-07-29 15:20:45 cg Exp $'
! !
