"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXConnectionBadSettingsTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXConnectionBadSettingsTest methodsFor:'as yet unclassified'!

testConnectBadPassword
	"tests that we get an error when connecting with an invalid password"
	| settings |
	
	self doesCurrentBackendSupportsHosts ifFalse: [^ self].
	
	"we'll use the existing settings but change the password to some nonsense"
	settings := (self settings) copy.
	settings userPassword: '@:[]sdafasgnimang&*k'.
	
	"try to connect and open, this should raise an error"
	self 
		should: [ self doConnectAndOpenWithSettings: settings ]
		raise: DBXError.
	
! !

!DBXConnectionBadSettingsTest methodsFor:'tests'!

doConnectAndOpenWithSettings: settings 
	"as doConnectAndOpen but allows us to specify different settings"
	| conn |
	conn := DBXConnection 
		platform: self platform
		settings: settings.
	self addConnectionToRelease: conn.		
	conn connect.
	conn open.
	^ conn	
	
!

doesCurrentBackendSupportsHosts 
	^ (self platform class = DBXSqliteBackend) not
!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	

	
!

testConnectBadHost
	"tests that we get an error when connecting to a host that doesn't exist"
	| settings |
	
	self doesCurrentBackendSupportsHosts ifFalse: [^ self].
	
	"we'll use the existing settings but change the host to some nonsense"
	settings := (self settings) copy.
	settings host: '@:[]sdafasgnimang&*k'.
	
	"try to connect and open, this should raise an error"
	self 
		should: [ self doConnectAndOpenWithSettings: settings ]
		raise: DBXError.
!

testConnectBadUsername
	"tests that we get an error when connecting with a username that doesn't exist"
	| settings |
	
	self doesCurrentBackendSupportsHosts ifFalse: [^ self].
	
	"we'll use the existing settings but change the username to some nonsense"
	settings := (self settings) copy.
	settings userPassword: '@:[]sdafasgnimang&*k'.
	
	"try to connect and open, this should raise an error"
	self 
		should: [ self doConnectAndOpenWithSettings: settings ]
		raise: DBXError.
	
	
! !

!DBXConnectionBadSettingsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionBadSettingsTest.st,v 1.2 2013-04-15 13:18:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionBadSettingsTest.st,v 1.2 2013-04-15 13:18:01 cg Exp $'
! !

