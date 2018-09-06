"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXBaseTest
	instanceVariableNames:'facility connection connectionsToRelease'
	classVariableNames:'Facility'
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXBaseTest class methodsFor:'accessing'!

facility
	^ Facility
!

facility: anObject
	Facility := anObject
!

packageNamesUnderTest
	^ #('OpenDBX-Core')
!

resources
	^Array with: FacilityTestResource
! !

!DBXBaseTest methodsFor:'accessing'!

connectionsToRelease
	^ connectionsToRelease
!

facility
	^ facility
!

facility: anObject
	facility := anObject
!

platform
	^ facility platform
!

settings
	^ facility connectionSettings
! !

!DBXBaseTest methodsFor:'as yet unclassified'!

addConnectionToRelease: aConnection
	"We add the connection so that it can be disconnected in the tearDown if there was a problem and wasnt disconnected."
	self connectionsToRelease add: aConnection
!

doConnect
	| conn |
	conn := DBXConnection 
		platform: self platform
		settings: self settings.	
	conn connect.
	self addConnectionToRelease: conn.
	^conn
!

doConnectAndOpen
	| conn |
	conn := DBXConnection 
		platform: self platform
		settings: self settings.
	conn connect.
	conn open.
	self addConnectionToRelease: conn.
	^ conn
!

doDisconnect: aConnection 
	aConnection disconnect.
!

platformCall: aSelector
	self platformCall: aSelector withArguments: #()
!

platformCall: aSelector with: anObject
	self platformCall: aSelector withArguments: (Array with: anObject)
!

platformCall: aSelector withArguments: anArray
	| platformSelector |
	
	platformSelector := ('platform', 
		self facility platform backend capitalized, 
		aSelector capitalized) 
			asSymbol.
	(self class allSelectors includes: platformSelector)
		ifTrue: [ self perform: platformSelector withArguments: anArray ]
! !

!DBXBaseTest methodsFor:'helpers'!

doConnectAndDisconnect
	| conn |
	conn := self doConnectAndOpen.
	conn disconnect.
	^conn
! !

!DBXBaseTest methodsFor:'running'!

dropScript: aConnection 
	"Here we catch the errors because the first time the tests are run, if you didn't create the tables by hand before, you will have an error here (because de table doesn't exist') and it won't continue to the create statements."
	
	self facility scriptsDrops 
		do: [:script | [ aConnection execute: script ] 
			on: DBXError
			do: [ :e |  Transcript show: e.  ].]
	
!

releaseConnections
	self connectionsToRelease do:[ :aConn | aConn disconnect ].
	connectionsToRelease := nil.
!

runDDLSetUpScript: aConnection 
	"The database structure is the same for all tests and most of them will
	need to have the structure generated. So, this method do exactly that,"
	"Here we catch the errors because the first time the tests are run, if
	you didn't create the tables by hand before, you will have an error
	here (because de table doesn't exist') and it won't continue to the create
	statements."
	self dropScript: aConnection.
	"Now I create all tables, fks, indexes, and so on."
	self facility scriptsDDL
		do: [:script | aConnection execute: script]
!

runDDLTearDownScript: aConnection
	"Till now, nothing is done here"
!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
	self subclassResponsibility
!

setUp
	"The setUp of this DBXBaseTest lets the database clear to tests. It runs the
	DDL and the common DML script for testing. Then each subclass should
	inserter, delete or whatever it need"
	super setUp.
	"this should be done from outside"
	connectionsToRelease := OrderedCollection new. 
	facility := self class facility.
	connection := self doConnectAndOpen.
	self runDDLSetUpScript: connection.
	self runDMLSetUpScript: connection.
	connection disconnect.
!

tearDown
	"This method run a DDL script to free results and close the connection used in the setUp and in here"
	super tearDown.
	connection := self doConnectAndOpen.
	self runDDLTearDownScript: connection.
	self doDisconnect: connection.
	self releaseConnections.
	connection := nil.
! !

!DBXBaseTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXBaseTest.st,v 1.2 2013-04-15 13:18:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXBaseTest.st,v 1.2 2013-04-15 13:18:15 cg Exp $'
! !

