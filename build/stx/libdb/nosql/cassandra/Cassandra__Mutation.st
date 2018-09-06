"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#Mutation
	instanceVariableNames:'columnOrSupercolumn deletion'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!Mutation class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!Mutation methodsFor:'as yet uncategorized'!

columnOrSupercolumn
    ^ columnOrSupercolumn
!

columnOrSupercolumn: aColumnOrSuperColumn
    columnOrSupercolumn := aColumnOrSuperColumn
!

deletion
    ^ deletion
!

deletion: aDeletion
    deletion := aDeletion
! !

!Mutation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__Mutation.st,v 1.3 2013-03-20 15:36:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__Mutation.st,v 1.3 2013-03-20 15:36:50 cg Exp $'
! !

