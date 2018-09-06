"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

CassandraError subclass:#InvalidRequestException
	instanceVariableNames:'why'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!InvalidRequestException class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!InvalidRequestException methodsFor:'as yet uncategorized'!

why
    ^ why
!

why: aString
    why := aString
! !

!InvalidRequestException class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__InvalidRequestException.st,v 1.4 2013-03-21 01:30:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__InvalidRequestException.st,v 1.4 2013-03-21 01:30:34 cg Exp $'
! !

