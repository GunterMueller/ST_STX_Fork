"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#KeyCount
	instanceVariableNames:'key count'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!KeyCount class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!KeyCount methodsFor:'as yet uncategorized'!

count
    ^ count
!

count: anI32
    count := anI32
!

key
    ^ key
!

key: aString
    key := aString
! !

!KeyCount class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KeyCount.st,v 1.3 2013-03-20 15:36:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KeyCount.st,v 1.3 2013-03-20 15:36:41 cg Exp $'
! !

