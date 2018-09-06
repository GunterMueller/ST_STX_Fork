"{ Package: 'stx:libdb/libopenDBX/examples' }"

Object subclass:#DBXMagritteExample
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTalkExamples'
!


!DBXMagritteExample methodsFor:'as yet unclassified'!

buildConnection
	| platform settings connection |
	platform := DBXPostgresBackend new.
	settings := DBXConnectionSettings 
		host: 'localhost' 
		port: '5432' 
		database: 'sodbxtest' 
		userName: 'sodbxtest' 
		userPassword: 'sodbxtest'.
	^DBXConnection platform: platform settings: settings.
!

classesToBrowse
	 ^(PackageInfo named: 'DBXTalkExamples') classes select: [ :class | class name beginsWith: 'Dbxmple' ] 
!

createExampleTables
	"self new createExampleTables"
	"Postgres DBXConnection setting and open"
	| connection domainTables |
	connection := self buildConnection.
	connection connectAndOpen.
	
	"Witcher domain table creation "
	domainTables := (MagritteBuilderDomain new) getTables.
	domainTables do: [ :table | connection execute: table generateCreateTable ].	
	
	connection disconnect.
!

dropExampleTables
	"self new dropExampleTables"
	"Postgres DBXConnection setting and open"
	| platform settings connection domainTables tableToClass excepts descriptor |
	connection := self buildConnection.
	connection connectAndOpen.
	
	"Witcher domain table creation "
	domainTables := (MagritteBuilderDomain new ) getTables reverse.
	domainTables do: [ :table | [connection execute: table generateDropTable] on: Exception do: [] ].	
	
	connection disconnect.
!

generateModelFromTablesExample
	"self new generateModelFromTablesExample"
	"Postgres DBXConnection setting and open"
	| platform settings connection domainTables tableToClass excepts descriptor application |
	platform := DBXPostgresBackend new.
	settings := DBXConnectionSettings 
		host: 'localhost' 
		port: '5432' 
		database: 'sodbxtest' 
		userName: 'sodbxtest' 
		userPassword: 'sodbxtest'.
	connection := DBXConnection platform: platform settings: settings.
	connection connectAndOpen.
	
	"Witcher domain table creation "
	domainTables := connection tablesDescription select:[:table | table name beginsWith: 'dbx'  ].
	
	application := DBXApplication fromTables: domainTables defaultCategory: 'DBXTools-DescriptionsTests-BidirectionalDomain'.
	DBXMagritteClassBuilderVisitor new visit: application.
	DBXMagritteWriterVisitor new visit: application.
	connection disconnect.
!

useDescriptorSystemExample
	"self new useDescriptorSystemExample "
	"Postgres DBXConnection setting and open"
	| platform settings connection domainTables application session  login system  pets pet player|
	platform := DBXPostgresBackend new.
	settings := DBXConnectionSettings 
		host: 'localhost' 
		port: '5432' 
		database: 'sodbxtest' 
		userName: 'sodbxtest' 
		userPassword: 'sodbxtest'.
	connection := DBXConnection platform: platform settings: settings.
	connection connectAndOpen.
	
	"Witcher domain table creation "
	domainTables := connection tablesDescription select:[:table | table name beginsWith: 'dbx'  ].
	
	application := DBXApplication fromTables: domainTables defaultCategory: 'DBXTalkExamples-Discard'.
	DBXMagritteClassBuilderVisitor new mustBuildAccessors:true; visit: application.
	DBXMagritteWriterVisitor new visit: application.
	connection disconnect.
	
	" GLORP :D  "	
		
	login := (Login new)
			database: PostgreSQLPlatform new;
			username: 'sodbxtest';
			password: 'sodbxtest';
			connectString: '127.0.0.1:5432_sodbxtest'.
			
	system := DBXDescriptorSystem forApplication: application andPlatform: login database.
	
	session := system sessionForLogin: login.
	session accessor login.
	

	"Setting up data"
	
	
	player := Dbxplayer new  playerLevel: 10; playerName: 'Cacho' ; id: 1;yourself.
	pet := Dbxpet new petName: 'Belcha' ; id: 1; playerid:1; yourself.
	
	session transact:[
		session register: player.
		session register: pet.	
	].

	session reset.
	
	pets:= session readManyOf: Dbxpet.
	
	(session readManyOf: Dbxplayer) explore.
	"force to load the instances, because the proxy will not bring anything after the logout"
	pets explore.
	pets do: [ : each | each inspect ].
	
	
	session logout.
	



! !

!DBXMagritteExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXMagritteExample.st,v 1.1 2013-04-15 13:47:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXMagritteExample.st,v 1.1 2013-04-15 13:47:52 cg Exp $'
! !

