"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#SlicePredicate
	instanceVariableNames:'columnNames sliceRange'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!SlicePredicate class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!SlicePredicate methodsFor:'as yet uncategorized'!

columnNames
    ^ columnNames
!

columnNames: a
    columnNames := a
!

sliceRange
    ^ sliceRange
!

sliceRange: aSliceRange
    sliceRange := aSliceRange
! !

!SlicePredicate class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__SlicePredicate.st,v 1.3 2013-03-20 15:36:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__SlicePredicate.st,v 1.3 2013-03-20 15:36:56 cg Exp $'
! !

