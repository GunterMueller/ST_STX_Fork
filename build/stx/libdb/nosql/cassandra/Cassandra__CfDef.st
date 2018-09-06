"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#CfDef
	instanceVariableNames:'keyspace name columnType comparatorType subcomparatorType comment
		readRepairChance columnMetadata gcGraceSeconds
		defaultValidationClass id minCompactionThreshold
		maxCompactionThreshold replicateOnWrite mergeShardsChance
		keyValidationClass keyAlias compactionStrategy
		compactionStrategyOptions compressionOptions bloomFilterFpChance'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!CfDef class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CfDef methodsFor:'as yet uncategorized'!

bloomFilterFpChance
    ^ bloomFilterFpChance
!

bloomFilterFpChance: aDouble
    bloomFilterFpChance := aDouble
!

columnMetadata
    ^ columnMetadata
!

columnMetadata: a
    columnMetadata := a
!

columnType
    ^ columnType
!

columnType: aString
    columnType := aString
!

comment
    ^ comment
!

comment: aString
    comment := aString
!

compactionStrategy
    ^ compactionStrategy
!

compactionStrategy: aString
    compactionStrategy := aString
!

compactionStrategyOptions
    ^ compactionStrategyOptions
!

compactionStrategyOptions: a
    compactionStrategyOptions := a
!

comparatorType
    ^ comparatorType
!

comparatorType: aString
    comparatorType := aString
!

compressionOptions
    ^ compressionOptions
!

compressionOptions: a
    compressionOptions := a
!

defaultValidationClass
    ^ defaultValidationClass
!

defaultValidationClass: aString
    defaultValidationClass := aString
!

gcGraceSeconds
    ^ gcGraceSeconds
!

gcGraceSeconds: anI32
    gcGraceSeconds := anI32
!

id
    ^ id
!

id: anI32
    id := anI32
!

keyAlias
    ^ keyAlias
!

keyAlias: aString
    keyAlias := aString
!

keyValidationClass
    ^ keyValidationClass
!

keyValidationClass: aString
    keyValidationClass := aString
!

keyspace
    ^ keyspace
!

keyspace: aString
    keyspace := aString
!

maxCompactionThreshold
    ^ maxCompactionThreshold
!

maxCompactionThreshold: anI32
    maxCompactionThreshold := anI32
!

mergeShardsChance
    ^ mergeShardsChance
!

mergeShardsChance: aDouble
    mergeShardsChance := aDouble
!

minCompactionThreshold
    ^ minCompactionThreshold
!

minCompactionThreshold: anI32
    minCompactionThreshold := anI32
!

name
    ^ name
!

name: aString
    name := aString
!

readRepairChance
    ^ readRepairChance
!

readRepairChance: aDouble
    readRepairChance := aDouble
!

replicateOnWrite
    ^ replicateOnWrite
!

replicateOnWrite: aBool
    replicateOnWrite := aBool
!

subcomparatorType
    ^ subcomparatorType
!

subcomparatorType: aString
    subcomparatorType := aString
! !

!CfDef class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CfDef.st,v 1.3 2013-03-20 15:36:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CfDef.st,v 1.3 2013-03-20 15:36:07 cg Exp $'
! !

