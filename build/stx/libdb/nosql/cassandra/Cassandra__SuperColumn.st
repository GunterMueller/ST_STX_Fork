"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#SuperColumn
	instanceVariableNames:'name columns'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!SuperColumn class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!SuperColumn methodsFor:'as yet uncategorized'!

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

!SuperColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__SuperColumn.st,v 1.3 2013-03-20 15:37:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__SuperColumn.st,v 1.3 2013-03-20 15:37:00 cg Exp $'
! !

