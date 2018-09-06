"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXMySQLFacility subclass:#DBXMySQL4Facility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXMySQL4Facility methodsFor:'as yet unclassified'!

createConnection
self connectionSettings: (DBXConnectionSettings
			host: '127.0.0.1'
			port: '3306'
			database: 'sodbxtest'
			userName: 'sodbxtest'
			userPassword: 'sodbxtest').
self platform: DBXMySQL4Backend new.


! !

!DBXMySQL4Facility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMySQL4Facility.st,v 1.2 2013-04-15 13:18:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMySQL4Facility.st,v 1.2 2013-04-15 13:18:42 cg Exp $'
! !

