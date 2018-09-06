"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXQueryBaseTest subclass:#DBXQueryDDLTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXQueryDDLTest methodsFor:'as yet unclassified'!

testExecuteDDLScript
	| conn |
	conn := self doConnectAndOpen.
	conn executeDDLScript: 'DROP TABLE course;
		DROP TABLE signature;
		DROP TABLE student'.
		
	conn disconnect.
		
	"scriptsDDL := self facility scriptsDDL.
	fullScript := String new writeStream.
	scriptsDDL do: [ :script | fullScript nextPutAll: script ]."
	
! !

!DBXQueryDDLTest methodsFor:'running'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
	
! !

!DBXQueryDDLTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryDDLTest.st,v 1.2 2013-04-15 13:18:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryDDLTest.st,v 1.2 2013-04-15 13:18:02 cg Exp $'
! !

