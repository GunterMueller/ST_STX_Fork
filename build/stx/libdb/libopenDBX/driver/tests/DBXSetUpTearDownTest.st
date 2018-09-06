"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXSetUpTearDownTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXSetUpTearDownTest methodsFor:'running'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
! !

!DBXSetUpTearDownTest methodsFor:'tests'!

testSetUpTearDOwn
! !

!DBXSetUpTearDownTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXSetUpTearDownTest.st,v 1.2 2013-04-15 13:18:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXSetUpTearDownTest.st,v 1.2 2013-04-15 13:18:36 cg Exp $'
! !

