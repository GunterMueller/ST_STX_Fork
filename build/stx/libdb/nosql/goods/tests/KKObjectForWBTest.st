"{ Package: 'stx:libdb/nosql/goods/tests' }"

Object subclass:#KKObjectForWBTest
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKObjectForWBTest comment:''
!


!KKObjectForWBTest methodsFor:'accessing'!

goodsHasChangeTracking
	^true
!

name
	^ name
!

name: anObject
	name := anObject.
	self goodsChanged
! !

!KKObjectForWBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKObjectForWBTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKObjectForWBTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
! !
