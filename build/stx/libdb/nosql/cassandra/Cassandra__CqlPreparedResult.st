"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#CqlPreparedResult
	instanceVariableNames:'itemId count'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!CqlPreparedResult class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CqlPreparedResult methodsFor:'as yet uncategorized'!

count
    ^ count
!

count: anI32
    count := anI32
!

itemId
    ^ itemId
!

itemId: anI32
    itemId := anI32
! !

!CqlPreparedResult class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlPreparedResult.st,v 1.3 2013-03-20 15:36:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlPreparedResult.st,v 1.3 2013-03-20 15:36:25 cg Exp $'
! !

