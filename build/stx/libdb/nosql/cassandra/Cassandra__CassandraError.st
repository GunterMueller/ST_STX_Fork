"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Error subclass:#CassandraError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!


!CassandraError methodsFor:'accessing'!

description
    ^ self why
!

why
    ^ super description
! !

!CassandraError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CassandraError.st,v 1.1 2013-03-21 01:30:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CassandraError.st,v 1.1 2013-03-21 01:30:30 cg Exp $'
! !

