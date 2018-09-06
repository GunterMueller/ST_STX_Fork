"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#CounterColumn
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!CounterColumn class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CounterColumn methodsFor:'as yet uncategorized'!

name
    ^ name
!

name: aString
    name := aString
!

value
    ^ value
!

value: anI64
    value := anI64
! !

!CounterColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CounterColumn.st,v 1.3 2013-03-20 15:36:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CounterColumn.st,v 1.3 2013-03-20 15:36:19 cg Exp $'
! !

