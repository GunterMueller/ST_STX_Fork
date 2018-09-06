"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#SliceRange
	instanceVariableNames:'start finish reversed count'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!SliceRange class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!SliceRange methodsFor:'as yet uncategorized'!

count
    ^ count
!

count: anI32
    count := anI32
!

finish
    ^ finish
!

finish: aString
    finish := aString
!

reversed
    ^ reversed
!

reversed: aBool
    reversed := aBool
!

start
    ^ start
!

start: aString
    start := aString
! !

!SliceRange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__SliceRange.st,v 1.3 2013-03-20 15:36:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__SliceRange.st,v 1.3 2013-03-20 15:36:58 cg Exp $'
! !

