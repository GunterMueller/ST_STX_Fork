"{ Package: 'stx:libdb/nosql/couchDB/tests' }"

TestCase subclass:#BaseCouchDBTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Tests-Unit'
!


!BaseCouchDBTest methodsFor:'helpers'!

fromJSON: jsonString
	^ (Json readFrom: (RWBinaryOrTextStream with: jsonString))
! !

!BaseCouchDBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/BaseCouchDBTest.st,v 1.1 2013-04-04 14:40:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/BaseCouchDBTest.st,v 1.1 2013-04-04 14:40:50 cg Exp $'
! !

