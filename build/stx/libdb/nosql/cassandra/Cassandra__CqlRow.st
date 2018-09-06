"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#CqlRow
	instanceVariableNames:'key columns'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!CqlRow class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CqlRow methodsFor:'as yet uncategorized'!

columns
    ^ columns
!

columns: a
    columns := a
!

key
    ^ key
!

key: aString
    key := aString
! !

!CqlRow class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlRow.st,v 1.3 2013-03-20 15:36:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlRow.st,v 1.3 2013-03-20 15:36:29 cg Exp $'
! !

