"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#IndexClause
	instanceVariableNames:'expressions startKey count'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!IndexClause class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!IndexClause methodsFor:'as yet uncategorized'!

count
    ^ count
!

count: anI32
    count := anI32
!

expressions
    ^ expressions
!

expressions: a
    expressions := a
!

startKey
    ^ startKey
!

startKey: aString
    startKey := aString
! !

!IndexClause class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__IndexClause.st,v 1.3 2013-03-20 15:36:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__IndexClause.st,v 1.3 2013-03-20 15:36:35 cg Exp $'
! !

