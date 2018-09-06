"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXConnectionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXConnectionTest methodsFor:'running'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
! !

!DBXConnectionTest methodsFor:'tests'!

testCloseIncorrect
	| conn |
	conn := DBXConnection 
		platform: self platform
		settings: self settings.
		
	self addConnectionToRelease: conn.
	
	"I have not do a open so this should rise an error"
	self 
		should: [ conn close ]
		raise: DBXError.
	"The same if i Try to do a query"
	self 
		should: [ conn execute: 'SELECT * from student where id = 1' ]
		raise: DBXError.
	conn := self doConnectAndOpen.
	"The first time should work well"
	conn close.
	"now, as I have already done a close, this shoud rise an error"
	self 
		should: [ conn close ]
		raise: DBXError.
		
	conn disconnect.
!

testCloseWithoutOpen
	| conn |
	conn := DBXConnection 
				platform: self platform
				settings: self settings.
				
	self addConnectionToRelease: conn.		
	self should: [ conn close ] raise: DBXError.
!

testConnectAndOpen
	| conn |
	conn := self doConnectAndOpen.
	conn disconnect.
	^ conn
!

testConnectIncorrect
	| conn |
	conn := self doConnectAndOpen.

	"As I have already done a connect: it should raise an error"
	self 
		should: [ conn connect ]
		raise: DBXError.
		
	conn disconnect.
!

testConnectOpenCloseOpen
	| conn  |
	conn := self doConnectAndOpen.
	self assert: conn isOpen.
	conn close.
	self assert: conn isOpen not.
	conn open.
	self assert: conn isOpen.
	conn close.
	conn disconnect.
	
!

testConnectionWithCleanUp
	| conn  |
	conn := self doConnectAndOpen.
	conn cleanUp.
	conn disconnect.
	
!

testConnectionWithoutCleanUp
	| conn  |
	conn := self doConnectAndOpen.
	conn disconnect.
	
!

testDisconnectIncorrect
	| conn |
	conn := DBXConnection 
		platform: self platform
		settings: self settings.

	self addConnectionToRelease: conn.

	"I have not do a connect first so this shouldnt rise an error"
	self 
		shouldnt: [ conn disconnect ]
		raise: DBXError.
	conn := self doConnectAndOpen.
	"The first time should work well"
	conn disconnect.
	"now, as I have already done a disconnect, this shoudnt rise an error"
	self 
		shouldnt: [ conn disconnect ]
		raise: DBXError
!

testDisconnectWithoutConnect
	| conn | 
	conn := DBXConnection 
				platform: self platform
				settings: self settings.	
	
	self addConnectionToRelease: conn.	
	self shouldnt: [ conn disconnect ] raise: DBXError.
	
!

testManualDisconnection
	| conn conn2 |
	conn := self doConnect.
	conn disconnect.
	conn2 := self doConnectAndOpen.
	conn2 close.
	conn2 disconnect
!

testMultipleConnectionsPerThread
	| conn1 conn2 conn3 conn4 conn5|
	conn1 := self doConnectAndOpen.
	conn2 := self doConnectAndOpen.
	conn3 := self doConnectAndOpen.
	conn4 := self doConnectAndOpen.
	conn5 := self doConnectAndOpen.
	
	conn1 disconnect.
	conn2 disconnect.
	conn3 disconnect.
	conn4 disconnect.
	conn5 disconnect.
!

testOpenIncorrect
	| conn |
	conn := self doConnectAndOpen.

	"as I have already open the connection this should rise a DBXError"
	self 
		should: [ conn open ]
		raise: DBXError.
	self 
		should: [ conn open ]
		raise: DBXError.
	self 
		should: [ conn open ]
		raise: DBXError.
		
	conn disconnect.
!

testReOpen
	| conn connectionSettings |
	conn := self doConnectAndOpen.
	connectionSettings := self settings.
	"Actually I should test this with a different database, username and password. "
	conn reOpen: connectionSettings.
	conn close.
	conn disconnect.
	
!

testShutDownAndStartUp
	| conn  |
	conn := self doConnectAndOpen.
	self assert: conn isOpen.
	conn shutDown.
	self assert: conn isOpen not.
	conn startUp.
	self assert: conn isOpen not.
!

testShutDownDisconnection
	| conn  |
	conn := self doConnectAndOpen.
	conn shutDown.
	self assert: conn isOpen not
!

testShutDownManualDisconnection
	| conn  |
	conn := self doConnectAndDisconnect.
	self assert: conn isOpen not.
	conn shutDown.
	self assert: conn isOpen not
! !

!DBXConnectionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionTest.st,v 1.2 2013-04-15 13:18:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionTest.st,v 1.2 2013-04-15 13:18:19 cg Exp $'
! !

