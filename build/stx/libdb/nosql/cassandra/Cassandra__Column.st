"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#Column
	instanceVariableNames:'name value timestamp ttl'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!Column class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!Column methodsFor:'as yet uncategorized'!

name
    ^ name
!

name: aString
    name := aString
!

timestamp
    ^ timestamp
!

timestamp: anI64
    timestamp := anI64
!

ttl
    ^ ttl
!

ttl: anI32
    ttl := anI32
!

value
    ^ value
!

value: aString
    value := aString
! !

!Column class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__Column.st,v 1.3 2013-03-20 15:36:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__Column.st,v 1.3 2013-03-20 15:36:09 cg Exp $'
! !

