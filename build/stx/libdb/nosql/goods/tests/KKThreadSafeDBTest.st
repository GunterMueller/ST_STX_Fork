"{ Package: 'stx:libdb/nosql/goods/tests' }"

KKDBTest subclass:#KKThreadSafeDBTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKThreadSafeDBTest comment:''
!


!KKThreadSafeDBTest methodsFor:'running'!

setUp
	super setUp.
	connOne := self newConnection.
	connTwo := self newConnection.
	dbOne := KKThreadSafeDatabase connection: connOne.
	dbOne root: Dictionary new; commit.
	dbTwo := KKThreadSafeDatabase connection: connTwo.
! !

!KKThreadSafeDBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKThreadSafeDBTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKThreadSafeDBTest.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
! !
