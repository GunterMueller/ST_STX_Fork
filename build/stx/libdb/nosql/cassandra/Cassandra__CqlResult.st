"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#CqlResult
	instanceVariableNames:'type rows num schema'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!CqlResult class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CqlResult methodsFor:'as yet uncategorized'!

num
    ^ num
!

num: anI32
    num := anI32
!

rows
    ^ rows
!

rows: a
    rows := a
!

schema
    ^ schema
!

schema: aCqlMetadata
    schema := aCqlMetadata
!

type
    ^ type
!

type: aCqlResultType
    type := aCqlResultType
! !

!CqlResult class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlResult.st,v 1.3 2013-03-20 15:36:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlResult.st,v 1.3 2013-03-20 15:36:27 cg Exp $'
! !

