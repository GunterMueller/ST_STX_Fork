"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#ColumnDef
	instanceVariableNames:'name validationClass indexType indexName indexOptions'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!ColumnDef class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!ColumnDef methodsFor:'as yet uncategorized'!

indexName
    ^ indexName
!

indexName: aString
    indexName := aString
!

indexOptions
    ^ indexOptions
!

indexOptions: a
    indexOptions := a
!

indexType
    ^ indexType
!

indexType: anIndexType
    indexType := anIndexType
!

name
    ^ name
!

name: aString
    name := aString
!

validationClass
    ^ validationClass
!

validationClass: aString
    validationClass := aString
! !

!ColumnDef class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnDef.st,v 1.3 2013-03-20 15:36:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__ColumnDef.st,v 1.3 2013-03-20 15:36:11 cg Exp $'
! !

