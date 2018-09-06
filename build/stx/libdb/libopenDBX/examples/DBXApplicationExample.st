"{ Package: 'stx:libdb/libopenDBX/examples' }"

Object subclass:#DBXApplicationExample
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTalkExamples'
!


!DBXApplicationExample methodsFor:'as yet unclassified'!

createApplication
	| platform settings connection app glorpDescriptor login session |

	"We create a database connection"
	platform := DBXPostgresBackend new.
	settings := DBXConnectionSettings 
		host: 'localhost' 
		port: '5432' 
		database: 'sodbxtest' 
		userName: 'sodbxtest' 
		userPassword: 'sodbxtest'.
	connection := DBXConnection platform: platform settings: settings.
	connection connectAndOpen.

	"We create the application from a database schema"
	
	app := DBXApplication fromSchema: 'myAppSchema' onConnection: connection named: 'MyApp'.
	app 
		writeClasses;
		writeMagritte.
		
	glorpDescriptor := app glorpDescriptorForPlatform: platform.
	
	"Now do some glorp!!"
	
	login := (Login new)
			database: PostgreSQLPlatform new;
			username: 'sodbxtest';
			password: 'sodbxtest';
			connectString: '127.0.0.1:5432_sodbxtest'.
	
	session := glorpDescriptor sessionForLogin: login.
	session accessor login.
	
	"Ta Da!!"
! !

!DBXApplicationExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXApplicationExample.st,v 1.1 2013-04-15 13:47:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/DBXApplicationExample.st,v 1.1 2013-04-15 13:47:37 cg Exp $'
! !

