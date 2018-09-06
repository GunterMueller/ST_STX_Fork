"{ Package: 'stx:libdb/nosql/goods/tests' }"

TestCase subclass:#KKAbstractDBTest
	instanceVariableNames:'dbOne dbTwo connOne connTwo'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!


!KKAbstractDBTest methodsFor:'running'!

newConnection
	^ KKConnection
		hostname: self dbHost
		port: self dbPort
!

setUp
	super setUp.
	connOne := self newConnection.
	connTwo := self newConnection.
	dbOne := KKDatabase connection: connOne.
	dbOne root: Dictionary new; commit.
	dbTwo := KKDatabase connection: connTwo.
!

tearDown
	super tearDown.
	[dbOne logout] on: Error do: [:ex | ].
	[dbTwo logout] on: Error do: [:ex | ].
	connOne := nil.
	connTwo := nil.
	dbOne := nil.
	dbTwo := nil.
! !

!KKAbstractDBTest methodsFor:'settings'!

dbHost
        ^ KKConnection defaultHost "/ 'localhost'
!

dbPort
        ^ KKConnection defaultPort "/ 2006
! !

!KKAbstractDBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKAbstractDBTest.st,v 1.3 2013-04-01 18:02:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKAbstractDBTest.st,v 1.3 2013-04-01 18:02:20 cg Exp $'
! !

