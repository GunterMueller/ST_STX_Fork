"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#Deletion
	instanceVariableNames:'timestamp superColumn predicate'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!Deletion class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!Deletion methodsFor:'as yet uncategorized'!

predicate
    ^ predicate
!

predicate: aSlicePredicate
    predicate := aSlicePredicate
!

superColumn
    ^ superColumn
!

superColumn: aString
    superColumn := aString
!

timestamp
    ^ timestamp
!

timestamp: anI64
    timestamp := anI64
! !

!Deletion class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__Deletion.st,v 1.3 2013-03-20 15:36:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__Deletion.st,v 1.3 2013-03-20 15:36:31 cg Exp $'
! !

