"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#CounterSuperColumn
	instanceVariableNames:'name columns'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!CounterSuperColumn class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CounterSuperColumn methodsFor:'as yet uncategorized'!

columns
    ^ columns
!

columns: a
    columns := a
!

name
    ^ name
!

name: aString
    name := aString
! !

!CounterSuperColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CounterSuperColumn.st,v 1.3 2013-03-20 15:36:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CounterSuperColumn.st,v 1.3 2013-03-20 15:36:21 cg Exp $'
! !

