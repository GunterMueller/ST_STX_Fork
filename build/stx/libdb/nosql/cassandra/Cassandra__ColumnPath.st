"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#ColumnPath
	instanceVariableNames:'columnFamily superColumn column'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!ColumnPath class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!ColumnPath methodsFor:'as yet uncategorized'!

column
    ^ column
!

column: aString
    column := aString
!

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

!ColumnPath class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnPath.st,v 1.3 2013-03-20 15:36:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnPath.st,v 1.3 2013-03-20 15:36:17 cg Exp $'
! !

