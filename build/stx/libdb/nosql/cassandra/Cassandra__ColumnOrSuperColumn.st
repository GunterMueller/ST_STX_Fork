"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#ColumnOrSuperColumn
	instanceVariableNames:'column superColumn counterColumn counterSuperColumn'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!ColumnOrSuperColumn class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!ColumnOrSuperColumn methodsFor:'as yet uncategorized'!

column
    ^ column
!

column: aColumn
    column := aColumn
!

counterColumn
    ^ counterColumn
!

counterColumn: aCounterColumn
    counterColumn := aCounterColumn
!

counterSuperColumn
    ^ counterSuperColumn
!

counterSuperColumn: aCounterSuperColumn
    counterSuperColumn := aCounterSuperColumn
!

superColumn
    ^ superColumn
!

superColumn: aSuperColumn
    superColumn := aSuperColumn
! !

!ColumnOrSuperColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnOrSuperColumn.st,v 1.3 2013-03-20 15:36:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnOrSuperColumn.st,v 1.3 2013-03-20 15:36:13 cg Exp $'
! !

