"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#KeySlice
	instanceVariableNames:'key columns'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!KeySlice class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!KeySlice methodsFor:'as yet uncategorized'!

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

!KeySlice class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KeySlice.st,v 1.3 2013-03-20 15:36:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KeySlice.st,v 1.3 2013-03-20 15:36:46 cg Exp $'
! !

