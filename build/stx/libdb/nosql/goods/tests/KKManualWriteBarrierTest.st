"{ Package: 'stx:libdb/nosql/goods/tests' }"

TestCase subclass:#KKManualWriteBarrierTest
	instanceVariableNames:'barrier'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKManualWriteBarrierTest comment:''
!


!KKManualWriteBarrierTest methodsFor:'running'!

setUp
	super setUp.
	barrier := KKManualWriteBarrier new
!

testAdd
	| obj |
	obj := KKObjectForWBTest new.
	barrier add: obj.
	self assert: (barrier isTracking: obj).
	self assert: barrier dirtySet isEmpty
!

testChangeDetection
	| obj |
	obj := KKObjectForWBTest new.
	barrier add: obj.
	barrier add: KKObjectForWBTest new.
	barrier add:KKObjectForWBTest new.
	obj name: 'different'.
	self assert: barrier dirtySet size = 1.
	self assert: (barrier dirtySet includes: obj)
!

testClearDirtySet
	| obj |
	obj := KKObjectForWBTest new.
	barrier add: obj.
	barrier modified: obj.
	barrier clearDirtySet.
	self assert: barrier dirtySet isEmpty
!

testModified
	| obj |
	obj := KKObjectForWBTest new.
	barrier add: obj.
	barrier modified: obj.
	self assert: barrier dirtySet size = 1.
	self assert: (barrier dirtySet includes: obj)
! !

!KKManualWriteBarrierTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKManualWriteBarrierTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKManualWriteBarrierTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
! !
