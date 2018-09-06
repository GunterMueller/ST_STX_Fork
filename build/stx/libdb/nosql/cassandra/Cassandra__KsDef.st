"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#KsDef
	instanceVariableNames:'name strategyClass strategyOptions replicationFactor cfDefs
		durableWrites'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!KsDef class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!KsDef methodsFor:'as yet uncategorized'!

cfDefs
    ^ cfDefs
!

cfDefs: a
    cfDefs := a
!

durableWrites
    ^ durableWrites
!

durableWrites: aBool
    durableWrites := aBool
!

name
    ^ name
!

name: aString
    name := aString
!

replicationFactor
    ^ replicationFactor
!

replicationFactor: anI32
    replicationFactor := anI32
!

strategyClass
    ^ strategyClass
!

strategyClass: aString
    strategyClass := aString
!

strategyOptions
    ^ strategyOptions
!

strategyOptions: a
    strategyOptions := a
! !

!KsDef class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KsDef.st,v 1.3 2013-03-20 15:36:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KsDef.st,v 1.3 2013-03-20 15:36:48 cg Exp $'
! !

