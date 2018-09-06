"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

CassandraError subclass:#AuthenticationException
	instanceVariableNames:'why'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!AuthenticationException class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!AuthenticationException methodsFor:'as yet uncategorized'!

why
    ^ why
!

why: aString
    why := aString
! !

!AuthenticationException class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__AuthenticationException.st,v 1.4 2013-03-21 01:29:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__AuthenticationException.st,v 1.4 2013-03-21 01:29:08 cg Exp $'
! !

