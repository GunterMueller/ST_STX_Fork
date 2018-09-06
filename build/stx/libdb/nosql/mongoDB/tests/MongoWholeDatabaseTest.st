"{ Package: 'stx:libdb/nosql/mongoDB/tests' }"

MongoTest subclass:#MongoWholeDatabaseTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core-Tests'
!


!MongoWholeDatabaseTest methodsFor:'running'!

setUp
	root := Mongo default.
	root open.
	database := root databaseNamed: 'testWholeDatabase'.
	collection := database addCollection: 'testCollection'
!

tearDown
	database drop.
	root close
!

testBasics
	self assert: collection validate isOK
! !

!MongoWholeDatabaseTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/MongoWholeDatabaseTest.st,v 1.2 2013-04-04 22:25:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/MongoWholeDatabaseTest.st,v 1.2 2013-04-04 22:25:42 cg Exp $'
! !

