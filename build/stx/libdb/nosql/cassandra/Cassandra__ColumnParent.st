"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#ColumnParent
	instanceVariableNames:'columnFamily superColumn'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!ColumnParent class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!ColumnParent methodsFor:'as yet uncategorized'!

columnFamily
    ^ columnFamily
!

columnFamily: aString
    columnFamily := aString
!

superColumn
    ^ superColumn
!

superColumn: aString
    superColumn := aString
! !

!ColumnParent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnParent.st,v 1.3 2013-03-20 15:36:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnParent.st,v 1.3 2013-03-20 15:36:15 cg Exp $'
! !

