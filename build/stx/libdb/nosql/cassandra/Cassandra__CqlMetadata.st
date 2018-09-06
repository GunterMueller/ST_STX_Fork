"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#CqlMetadata
	instanceVariableNames:'nameTypes valueTypes defaultNameType defaultValueType'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!CqlMetadata class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CqlMetadata methodsFor:'as yet uncategorized'!

defaultNameType
    ^ defaultNameType
!

defaultNameType: aString
    defaultNameType := aString
!

defaultValueType
    ^ defaultValueType
!

defaultValueType: aString
    defaultValueType := aString
!

nameTypes
    ^ nameTypes
!

nameTypes: a
    nameTypes := a
!

valueTypes
    ^ valueTypes
!

valueTypes: a
    valueTypes := a
! !

!CqlMetadata class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlMetadata.st,v 1.3 2013-03-20 15:36:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CqlMetadata.st,v 1.3 2013-03-20 15:36:23 cg Exp $'
! !

