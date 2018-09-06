"{ Package: 'stx:libdb/nosql/mongoDB/tests' }"

TestCase subclass:#MongoTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core-Tests'
!


!MongoTestCase class methodsFor:'instance creation'!

new
	"Answer a newly created and initialized instance."

	^super new initialize
! !

!MongoTestCase methodsFor:'initialize-release'!

initialize
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	" *** Replace this comment with the appropriate initialization code *** "
	^self
! !

!MongoTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/MongoTestCase.st,v 1.2 2013-04-15 16:04:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/MongoTestCase.st,v 1.2 2013-04-15 16:04:00 cg Exp $'
! !

