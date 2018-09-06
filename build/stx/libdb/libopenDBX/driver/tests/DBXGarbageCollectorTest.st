"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXGarbageCollectorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXGarbageCollectorTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
! !

!DBXGarbageCollectorTest methodsFor:'tests'!

doConnectAndOpen
	"I override this method because I dont want the connection to be set in connectionsToRelease because in this case the GC wont remove them."
	| conn |
	conn := DBXConnection 
		platform: self platform
		settings: self settings.
	conn connect.
	conn open.
	^ conn
!

testGCDisconnection
	"I have to call garbageCollect because maybe there are previous
	connections that are inconsistence or maybe they just have references
	and because of this the GC doesn't clean them. We assume there aren't
	created new connections at the same time of running the test from
	elsewhere"
	| connectionInstancesSizeBeforeTest weakRegistrySizeBeforeTest |
	1
		to: 3
		do: [:i | Smalltalk garbageCollect].
	connectionInstancesSizeBeforeTest := DBXConnection allInstances size.
	weakRegistrySizeBeforeTest := OpenDBXDriverSmalltalkDialect current connectionsToGarbageCollect size.
	self doConnectAndOpen.
	1
		to: 3
		do: [:i | Smalltalk garbageCollect].
	
	self assert: DBXConnection allInstances size = connectionInstancesSizeBeforeTest.
	DBXBackend isAutomaticConnectionReleaseOnGC 
		ifTrue: [
			self assert: OpenDBXDriverSmalltalkDialect current connectionsToGarbageCollect notEmpty.] 
		ifFalse: [
			self assert: OpenDBXDriverSmalltalkDialect current connectionsToGarbageCollect isEmpty.] 
	
	
!

testManualAndGCDisconnection

	"I have to call garbageCollect because maybe there are previous connections that are inconsistence or maybe they 	just have references and because of this the GC doesn't clean them. We assume there aren't created new connections 	at the same time of running the test from elsewhere "
	
	| connectionInstancesSizeBeforeTest |
	1 to: 3 do: [ :i | Smalltalk garbageCollect ].
	connectionInstancesSizeBeforeTest := DBXConnection allInstances size.
		
	self doConnectAndDisconnect.
	1 to: 3 do: [ :i | Smalltalk garbageCollect ].
	self assert: DBXConnection allInstances size = connectionInstancesSizeBeforeTest.
! !

!DBXGarbageCollectorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXGarbageCollectorTest.st,v 1.2 2013-04-15 13:18:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXGarbageCollectorTest.st,v 1.2 2013-04-15 13:18:31 cg Exp $'
! !

