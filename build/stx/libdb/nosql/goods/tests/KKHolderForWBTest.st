"{ Package: 'stx:libdb/nosql/goods/tests' }"

Object subclass:#KKHolderForWBTest
	instanceVariableNames:'value1 value2'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKHolderForWBTest comment:''
!


!KKHolderForWBTest methodsFor:'accessing'!

goodsHasChangeTracking
	^true
!

value1
	^ value1
!

value1: anObject
	value1 := anObject.
	self goodsChanged

!

value2
	^ value2
!

value2: anObject
	value2 := anObject.
	self goodsChanged
! !

!KKHolderForWBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKHolderForWBTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKHolderForWBTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
! !
