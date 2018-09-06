"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

TClient subclass:#CassandraClient
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'TConstants'
	category:'DataBase-Cassandra-Generated'
!

!CassandraClient class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!CassandraClient methodsFor:'API'!

addKey: key columnParent: columnParent column: column consistencyLevel: consistencyLevel
    "key: string, columnParent: ColumnParent, column: CounterColumn, consistencyLevel: ConsistencyLevel"
    self sendAddKey: key columnParent: columnParent column: column consistencyLevel: consistencyLevel.
    ^ self recvAdd success 
!

batchMutateMutationMap: mutationMap consistencyLevel: consistencyLevel
    "mutationMap: , consistencyLevel: ConsistencyLevel"
    self sendBatchMutateMutationMap: mutationMap consistencyLevel: consistencyLevel.
    ^ self recvBatchMutate success 
!

describeClusterName
    ""
    self sendDescribeClusterName.
    ^ self recvDescribeClusterName success 
!

describeKeyspaceKeyspace: keyspace
    "keyspace: string"
    self sendDescribeKeyspaceKeyspace: keyspace.
    ^ self recvDescribeKeyspace success 
!

describeKeyspaces
    ""
    self sendDescribeKeyspaces.
    ^ self recvDescribeKeyspaces success 
!

describePartitioner
    ""
    self sendDescribePartitioner.
    ^ self recvDescribePartitioner success 
!

describeRingKeyspace: keyspace
    "keyspace: string"
    self sendDescribeRingKeyspace: keyspace.
    ^ self recvDescribeRing success 
!

describeSchemaVersions
    ""
    self sendDescribeSchemaVersions.
    ^ self recvDescribeSchemaVersions success 
!

describeSnitch
    ""
    self sendDescribeSnitch.
    ^ self recvDescribeSnitch success 
!

describeSplitsCfName: cfName startToken: startToken endToken: endToken keysPerSplit: keysPerSplit
    "cfName: string, startToken: string, endToken: string, keysPerSplit: i32"
    self sendDescribeSplitsCfName: cfName startToken: startToken endToken: endToken keysPerSplit: keysPerSplit.
    ^ self recvDescribeSplits success 
!

describeVersion
    ""

    self sendDescribeVersion.
    ^ self recvDescribeVersion success 
!

executeCqlQueryQuery: query compression: compression
    "query: string, compression: Compression"
    self sendExecuteCqlQueryQuery: query compression: compression.
    ^ self recvExecuteCqlQuery success 
!

executePreparedCqlQueryItemId: itemId values: values
    "itemId: i32, values: "
    self sendExecutePreparedCqlQueryItemId: itemId values: values.
    ^ self recvExecutePreparedCqlQuery success 
!

getCountKey: key columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel
    "key: string, columnParent: ColumnParent, predicate: SlicePredicate, consistencyLevel: ConsistencyLevel"
    self sendGetCountKey: key columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel.
    ^ self recvGetCount success 
!

getIndexedSlicesColumnParent: columnParent indexClause: indexClause columnPredicate: columnPredicate consistencyLevel: consistencyLevel
    "columnParent: ColumnParent, indexClause: IndexClause, columnPredicate: SlicePredicate, consistencyLevel: ConsistencyLevel"
    self sendGetIndexedSlicesColumnParent: columnParent indexClause: indexClause columnPredicate: columnPredicate consistencyLevel: consistencyLevel.
    ^ self recvGetIndexedSlices success 
!

getKey: key columnPath: columnPath consistencyLevel: consistencyLevel
    "key: string, columnPath: ColumnPath, consistencyLevel: ConsistencyLevel"
    self sendGetKey: key columnPath: columnPath consistencyLevel: consistencyLevel.
    ^ self recvGet success 
!

getRangeSlicesColumnParent: columnParent predicate: predicate range: range consistencyLevel: consistencyLevel
    "columnParent: ColumnParent, predicate: SlicePredicate, range: KeyRange, consistencyLevel: ConsistencyLevel"
    self sendGetRangeSlicesColumnParent: columnParent predicate: predicate range: range consistencyLevel: consistencyLevel.
    ^ self recvGetRangeSlices success 
!

getSliceKey: key columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel
    "key: string, columnParent: ColumnParent, predicate: SlicePredicate, consistencyLevel: ConsistencyLevel"
    self sendGetSliceKey: key columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel.
    ^ self recvGetSlice success 
!

insertKey: key columnParent: columnParent column: column consistencyLevel: consistencyLevel
    "key: string, columnParent: ColumnParent, column: Column, consistencyLevel: ConsistencyLevel"
    self sendInsertKey: key columnParent: columnParent column: column consistencyLevel: consistencyLevel.
    ^ self recvInsert success 
!

loginAuthRequest: authRequest
    "authRequest: AuthenticationRequest"
    self sendLoginAuthRequest: authRequest.
    ^ self recvLogin success 
!

multigetCountKeys: keys columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel
    "keys: , columnParent: ColumnParent, predicate: SlicePredicate, consistencyLevel: ConsistencyLevel"
    self sendMultigetCountKeys: keys columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel.
    ^ self recvMultigetCount success 
!

multigetSliceKeys: keys columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel
    "keys: , columnParent: ColumnParent, predicate: SlicePredicate, consistencyLevel: ConsistencyLevel"
    self sendMultigetSliceKeys: keys columnParent: columnParent predicate: predicate consistencyLevel: consistencyLevel.
    ^ self recvMultigetSlice success 
!

prepareCqlQueryQuery: query compression: compression
    "query: string, compression: Compression"
    self sendPrepareCqlQueryQuery: query compression: compression.
    ^ self recvPrepareCqlQuery success 
!

removeCounterKey: key path: path consistencyLevel: consistencyLevel
    "key: string, path: ColumnPath, consistencyLevel: ConsistencyLevel"
    self sendRemoveCounterKey: key path: path consistencyLevel: consistencyLevel.
    ^ self recvRemoveCounter success 
!

removeKey: key columnPath: columnPath timestamp: timestamp consistencyLevel: consistencyLevel
    "key: string, columnPath: ColumnPath, timestamp: i64, consistencyLevel: ConsistencyLevel"
    self sendRemoveKey: key columnPath: columnPath timestamp: timestamp consistencyLevel: consistencyLevel.
    ^ self recvRemove success 
!

setKeyspaceKeyspace: keyspace
    "keyspace: string"
    self sendSetKeyspaceKeyspace: keyspace.
    ^ self recvSetKeyspace success 
!

systemAddColumnFamilyCfDef: cfDef
    "cfDef: CfDef"
    self sendSystemAddColumnFamilyCfDef: cfDef.
    ^ self recvSystemAddColumnFamily success 
!

systemAddKeyspaceKsDef: ksDef
    "ksDef: KsDef"
    self sendSystemAddKeyspaceKsDef: ksDef.
    ^ self recvSystemAddKeyspace success 
!

systemDropColumnFamilyColumnFamily: columnFamily
    "columnFamily: string"
    self sendSystemDropColumnFamilyColumnFamily: columnFamily.
    ^ self recvSystemDropColumnFamily success 
!

systemDropKeyspaceKeyspace: keyspace
    "keyspace: string"
    self sendSystemDropKeyspaceKeyspace: keyspace.
    ^ self recvSystemDropKeyspace success 
!

systemUpdateColumnFamilyCfDef: cfDef
    "cfDef: CfDef"
    self sendSystemUpdateColumnFamilyCfDef: cfDef.
    ^ self recvSystemUpdateColumnFamily success 
!

systemUpdateKeyspaceKsDef: ksDef
    "ksDef: KsDef"
    self sendSystemUpdateKeyspaceKsDef: ksDef.
    ^ self recvSystemUpdateKeyspace success 
!

truncateCfname: cfname
    "cfname: string"
    self sendTruncateCfname: cfname.
    ^ self recvTruncate success 
! !

!CassandraClient methodsFor:'private-receive'!

recvAdd
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp273 temp272|

            temp272 := TResult new.
            iprot readStructBegin.
            [
                temp273 := iprot readFieldBegin.
                temp273 type = TTypeStop
            ] whileFalse:[
                |temp274|

                temp273 id = 0 ifTrue:[
                    temp274 := true.
                    temp272 success:iprot readVoid
                ].
                temp273 id = 1 ifTrue:[
                    temp274 := true.
                    temp272 
                        exception:[
                                |temp276 temp275|

                                temp275 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp276 := iprot readFieldBegin.
                                    temp276 type = TTypeStop
                                ] whileFalse:[
                                    |temp277|

                                    temp276 id = 1 ifTrue:[
                                        temp277 := true.
                                        temp275 why:iprot readString
                                    ].
                                    temp277 ifNil:[ iprot skip:temp276 type ]
                                ].
                                iprot readStructEnd.
                                temp275
                            ] value
                ].
                temp273 id = 2 ifTrue:[
                    temp274 := true.
                    temp272 
                        exception:[
                                |temp279 temp278|

                                temp278 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp279 := iprot readFieldBegin.
                                    temp279 type = TTypeStop
                                ] whileFalse:[
                                    |temp280|

                                    temp280 ifNil:[ iprot skip:temp279 type ]
                                ].
                                iprot readStructEnd.
                                temp278
                            ] value
                ].
                temp273 id = 3 ifTrue:[
                    temp274 := true.
                    temp272 
                        exception:[
                                |temp282 temp281|

                                temp281 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp282 := iprot readFieldBegin.
                                    temp282 type = TTypeStop
                                ] whileFalse:[
                                    |temp283|

                                    temp283 ifNil:[ iprot skip:temp282 type ]
                                ].
                                iprot readStructEnd.
                                temp281
                            ] value
                ].
                temp274 ifNil:[ iprot skip:temp273 type ]
            ].
            iprot readStructEnd.
            temp272
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvBatchMutate
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp317 temp316|

            temp316 := TResult new.
            iprot readStructBegin.
            [
                temp317 := iprot readFieldBegin.
                temp317 type = TTypeStop
            ] whileFalse:[
                |temp318|

                temp317 id = 0 ifTrue:[
                    temp318 := true.
                    temp316 success:iprot readVoid
                ].
                temp317 id = 1 ifTrue:[
                    temp318 := true.
                    temp316 
                        exception:[
                                |temp320 temp319|

                                temp319 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp320 := iprot readFieldBegin.
                                    temp320 type = TTypeStop
                                ] whileFalse:[
                                    |temp321|

                                    temp320 id = 1 ifTrue:[
                                        temp321 := true.
                                        temp319 why:iprot readString
                                    ].
                                    temp321 ifNil:[ iprot skip:temp320 type ]
                                ].
                                iprot readStructEnd.
                                temp319
                            ] value
                ].
                temp317 id = 2 ifTrue:[
                    temp318 := true.
                    temp316 
                        exception:[
                                |temp323 temp322|

                                temp322 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp323 := iprot readFieldBegin.
                                    temp323 type = TTypeStop
                                ] whileFalse:[
                                    |temp324|

                                    temp324 ifNil:[ iprot skip:temp323 type ]
                                ].
                                iprot readStructEnd.
                                temp322
                            ] value
                ].
                temp317 id = 3 ifTrue:[
                    temp318 := true.
                    temp316 
                        exception:[
                                |temp326 temp325|

                                temp325 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp326 := iprot readFieldBegin.
                                    temp326 type = TTypeStop
                                ] whileFalse:[
                                    |temp327|

                                    temp327 ifNil:[ iprot skip:temp326 type ]
                                ].
                                iprot readStructEnd.
                                temp325
                            ] value
                ].
                temp318 ifNil:[ iprot skip:temp317 type ]
            ].
            iprot readStructEnd.
            temp316
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeClusterName
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp380 temp379|

            temp379 := TResult new.
            iprot readStructBegin.
            [
                temp380 := iprot readFieldBegin.
                temp380 type = TTypeStop
            ] whileFalse:[
                |temp381|

                temp380 id = 0 ifTrue:[
                    temp381 := true.
                    temp379 success:iprot readString
                ].
                temp381 ifNil:[ iprot skip:temp380 type ]
            ].
            iprot readStructEnd.
            temp379
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeKeyspace
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp412 temp411|

            temp411 := TResult new.
            iprot readStructBegin.
            [
                temp412 := iprot readFieldBegin.
                temp412 type = TTypeStop
            ] whileFalse:[
                |temp413|

                temp412 id = 0 ifTrue:[
                    temp413 := true.
                    temp411 
                        success:[
                                |temp415 temp414|

                                temp414 := KsDef new.
                                iprot readStructBegin.
                                [
                                    temp415 := iprot readFieldBegin.
                                    temp415 type = TTypeStop
                                ] whileFalse:[
                                    |temp416|

                                    temp415 id = 1 ifTrue:[
                                        temp416 := true.
                                        temp414 name:iprot readString
                                    ].
                                    temp415 id = 2 ifTrue:[
                                        temp416 := true.
                                        temp414 strategyClass:iprot readString
                                    ].
                                    temp415 id = 3 ifTrue:[
                                        temp416 := true.
                                        temp414 
                                            strategyOptions:[
                                                    |temp417 temp418|

                                                    temp417 := iprot readMapBegin.
                                                    temp418 := Dictionary new.
                                                    temp417 size timesRepeat:[
                                                        temp418 at:iprot readString put:iprot readString
                                                    ].
                                                    iprot readMapEnd.
                                                    temp418
                                                ] value
                                    ].
                                    temp415 id = 4 ifTrue:[
                                        temp416 := true.
                                        temp414 replicationFactor:iprot readI32
                                    ].
                                    temp415 id = 5 ifTrue:[
                                        temp416 := true.
                                        temp414 
                                            cfDefs:[
                                                    |temp419 temp420|

                                                    temp419 := iprot readListBegin.
                                                    temp420 := OrderedCollection new.
                                                    temp419 size timesRepeat:[
                                                        temp420 
                                                            add:[
                                                                    |temp422 temp421|

                                                                    temp421 := CfDef new.
                                                                    iprot readStructBegin.
                                                                    [
                                                                        temp422 := iprot readFieldBegin.
                                                                        temp422 type = TTypeStop
                                                                    ] whileFalse:[
                                                                        |temp423|

                                                                        temp422 id = 1 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 keyspace:iprot readString
                                                                        ].
                                                                        temp422 id = 2 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 name:iprot readString
                                                                        ].
                                                                        temp422 id = 3 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 columnType:iprot readString
                                                                        ].
                                                                        temp422 id = 5 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 comparatorType:iprot readString
                                                                        ].
                                                                        temp422 id = 6 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 subcomparatorType:iprot readString
                                                                        ].
                                                                        temp422 id = 8 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 comment:iprot readString
                                                                        ].
                                                                        temp422 id = 12 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 readRepairChance:iprot readDouble
                                                                        ].
                                                                        temp422 id = 13 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 
                                                                                columnMetadata:[
                                                                                        |temp424 temp425|

                                                                                        temp424 := iprot readListBegin.
                                                                                        temp425 := OrderedCollection new.
                                                                                        temp424 size timesRepeat:[
                                                                                            temp425 
                                                                                                add:[
                                                                                                        |temp427 temp426|

                                                                                                        temp426 := ColumnDef new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp427 := iprot readFieldBegin.
                                                                                                            temp427 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp428|

                                                                                                            temp427 id = 1 ifTrue:[
                                                                                                                temp428 := true.
                                                                                                                temp426 name:iprot readString
                                                                                                            ].
                                                                                                            temp427 id = 2 ifTrue:[
                                                                                                                temp428 := true.
                                                                                                                temp426 validationClass:iprot readString
                                                                                                            ].
                                                                                                            temp427 id = 3 ifTrue:[
                                                                                                                temp428 := true.
                                                                                                                temp426 indexType:iprot readI32
                                                                                                            ].
                                                                                                            temp427 id = 4 ifTrue:[
                                                                                                                temp428 := true.
                                                                                                                temp426 indexName:iprot readString
                                                                                                            ].
                                                                                                            temp427 id = 5 ifTrue:[
                                                                                                                temp428 := true.
                                                                                                                temp426 
                                                                                                                    indexOptions:[
                                                                                                                            |temp429 temp430|

                                                                                                                            temp429 := iprot readMapBegin.
                                                                                                                            temp430 := Dictionary new.
                                                                                                                            temp429 size timesRepeat:[
                                                                                                                                temp430 at:iprot readString put:iprot readString
                                                                                                                            ].
                                                                                                                            iprot readMapEnd.
                                                                                                                            temp430
                                                                                                                        ] value
                                                                                                            ].
                                                                                                            temp428 ifNil:[ iprot skip:temp427 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp426
                                                                                                    ] value
                                                                                        ].
                                                                                        iprot readListEnd.
                                                                                        temp425
                                                                                    ] value
                                                                        ].
                                                                        temp422 id = 14 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 gcGraceSeconds:iprot readI32
                                                                        ].
                                                                        temp422 id = 15 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 defaultValidationClass:iprot readString
                                                                        ].
                                                                        temp422 id = 16 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 id:iprot readI32
                                                                        ].
                                                                        temp422 id = 17 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 minCompactionThreshold:iprot readI32
                                                                        ].
                                                                        temp422 id = 18 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 maxCompactionThreshold:iprot readI32
                                                                        ].
                                                                        temp422 id = 24 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 replicateOnWrite:iprot readBool
                                                                        ].
                                                                        temp422 id = 25 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 mergeShardsChance:iprot readDouble
                                                                        ].
                                                                        temp422 id = 26 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 keyValidationClass:iprot readString
                                                                        ].
                                                                        temp422 id = 28 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 keyAlias:iprot readString
                                                                        ].
                                                                        temp422 id = 29 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 compactionStrategy:iprot readString
                                                                        ].
                                                                        temp422 id = 30 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 
                                                                                compactionStrategyOptions:[
                                                                                        |temp431 temp432|

                                                                                        temp431 := iprot readMapBegin.
                                                                                        temp432 := Dictionary new.
                                                                                        temp431 size timesRepeat:[
                                                                                            temp432 at:iprot readString put:iprot readString
                                                                                        ].
                                                                                        iprot readMapEnd.
                                                                                        temp432
                                                                                    ] value
                                                                        ].
                                                                        temp422 id = 32 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 
                                                                                compressionOptions:[
                                                                                        |temp433 temp434|

                                                                                        temp433 := iprot readMapBegin.
                                                                                        temp434 := Dictionary new.
                                                                                        temp433 size timesRepeat:[
                                                                                            temp434 at:iprot readString put:iprot readString
                                                                                        ].
                                                                                        iprot readMapEnd.
                                                                                        temp434
                                                                                    ] value
                                                                        ].
                                                                        temp422 id = 33 ifTrue:[
                                                                            temp423 := true.
                                                                            temp421 bloomFilterFpChance:iprot readDouble
                                                                        ].
                                                                        temp423 ifNil:[ iprot skip:temp422 type ]
                                                                    ].
                                                                    iprot readStructEnd.
                                                                    temp421
                                                                ] value
                                                    ].
                                                    iprot readListEnd.
                                                    temp420
                                                ] value
                                    ].
                                    temp415 id = 6 ifTrue:[
                                        temp416 := true.
                                        temp414 durableWrites:iprot readBool
                                    ].
                                    temp416 ifNil:[ iprot skip:temp415 type ]
                                ].
                                iprot readStructEnd.
                                temp414
                            ] value
                ].
                temp412 id = 1 ifTrue:[
                    temp413 := true.
                    temp411 
                        exception:[
                                |temp436 temp435|

                                temp435 := NotFoundException new.
                                iprot readStructBegin.
                                [
                                    temp436 := iprot readFieldBegin.
                                    temp436 type = TTypeStop
                                ] whileFalse:[
                                    |temp437|

                                    temp437 ifNil:[ iprot skip:temp436 type ]
                                ].
                                iprot readStructEnd.
                                temp435
                            ] value
                ].
                temp412 id = 2 ifTrue:[
                    temp413 := true.
                    temp411 
                        exception:[
                                |temp439 temp438|

                                temp438 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp439 := iprot readFieldBegin.
                                    temp439 type = TTypeStop
                                ] whileFalse:[
                                    |temp440|

                                    temp439 id = 1 ifTrue:[
                                        temp440 := true.
                                        temp438 why:iprot readString
                                    ].
                                    temp440 ifNil:[ iprot skip:temp439 type ]
                                ].
                                iprot readStructEnd.
                                temp438
                            ] value
                ].
                temp413 ifNil:[ iprot skip:temp412 type ]
            ].
            iprot readStructEnd.
            temp411
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeKeyspaces
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp351 temp350|

            temp350 := TResult new.
            iprot readStructBegin.
            [
                temp351 := iprot readFieldBegin.
                temp351 type = TTypeStop
            ] whileFalse:[
                |temp352|

                temp351 id = 0 ifTrue:[
                    temp352 := true.
                    temp350 
                        success:[
                                |temp353 temp354|

                                temp353 := iprot readListBegin.
                                temp354 := OrderedCollection new.
                                temp353 size timesRepeat:[
                                    temp354 
                                        add:[
                                                |temp356 temp355|

                                                temp355 := KsDef new.
                                                iprot readStructBegin.
                                                [
                                                    temp356 := iprot readFieldBegin.
                                                    temp356 type = TTypeStop
                                                ] whileFalse:[
                                                    |temp357|

                                                    temp356 id = 1 ifTrue:[
                                                        temp357 := true.
                                                        temp355 name:iprot readString
                                                    ].
                                                    temp356 id = 2 ifTrue:[
                                                        temp357 := true.
                                                        temp355 strategyClass:iprot readString
                                                    ].
                                                    temp356 id = 3 ifTrue:[
                                                        temp357 := true.
                                                        temp355 
                                                            strategyOptions:[
                                                                    |temp358 temp359|

                                                                    temp358 := iprot readMapBegin.
                                                                    temp359 := Dictionary new.
                                                                    temp358 size timesRepeat:[
                                                                        temp359 at:iprot readString put:iprot readString
                                                                    ].
                                                                    iprot readMapEnd.
                                                                    temp359
                                                                ] value
                                                    ].
                                                    temp356 id = 4 ifTrue:[
                                                        temp357 := true.
                                                        temp355 replicationFactor:iprot readI32
                                                    ].
                                                    temp356 id = 5 ifTrue:[
                                                        temp357 := true.
                                                        temp355 
                                                            cfDefs:[
                                                                    |temp360 temp361|

                                                                    temp360 := iprot readListBegin.
                                                                    temp361 := OrderedCollection new.
                                                                    temp360 size timesRepeat:[
                                                                        temp361 
                                                                            add:[
                                                                                    |temp363 temp362|

                                                                                    temp362 := CfDef new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp363 := iprot readFieldBegin.
                                                                                        temp363 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp364|

                                                                                        temp363 id = 1 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 keyspace:iprot readString
                                                                                        ].
                                                                                        temp363 id = 2 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 name:iprot readString
                                                                                        ].
                                                                                        temp363 id = 3 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 columnType:iprot readString
                                                                                        ].
                                                                                        temp363 id = 5 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 comparatorType:iprot readString
                                                                                        ].
                                                                                        temp363 id = 6 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 subcomparatorType:iprot readString
                                                                                        ].
                                                                                        temp363 id = 8 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 comment:iprot readString
                                                                                        ].
                                                                                        temp363 id = 12 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 readRepairChance:iprot readDouble
                                                                                        ].
                                                                                        temp363 id = 13 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 
                                                                                                columnMetadata:[
                                                                                                        |temp365 temp366|

                                                                                                        temp365 := iprot readListBegin.
                                                                                                        temp366 := OrderedCollection new.
                                                                                                        temp365 size timesRepeat:[
                                                                                                            temp366 
                                                                                                                add:[
                                                                                                                        |temp368 temp367|

                                                                                                                        temp367 := ColumnDef new.
                                                                                                                        iprot readStructBegin.
                                                                                                                        [
                                                                                                                            temp368 := iprot readFieldBegin.
                                                                                                                            temp368 type = TTypeStop
                                                                                                                        ] whileFalse:[
                                                                                                                            |temp369|

                                                                                                                            temp368 id = 1 ifTrue:[
                                                                                                                                temp369 := true.
                                                                                                                                temp367 name:iprot readString
                                                                                                                            ].
                                                                                                                            temp368 id = 2 ifTrue:[
                                                                                                                                temp369 := true.
                                                                                                                                temp367 validationClass:iprot readString
                                                                                                                            ].
                                                                                                                            temp368 id = 3 ifTrue:[
                                                                                                                                temp369 := true.
                                                                                                                                temp367 indexType:iprot readI32
                                                                                                                            ].
                                                                                                                            temp368 id = 4 ifTrue:[
                                                                                                                                temp369 := true.
                                                                                                                                temp367 indexName:iprot readString
                                                                                                                            ].
                                                                                                                            temp368 id = 5 ifTrue:[
                                                                                                                                temp369 := true.
                                                                                                                                temp367 
                                                                                                                                    indexOptions:[
                                                                                                                                            |temp370 temp371|

                                                                                                                                            temp370 := iprot readMapBegin.
                                                                                                                                            temp371 := Dictionary new.
                                                                                                                                            temp370 size timesRepeat:[
                                                                                                                                                temp371 at:iprot readString put:iprot readString
                                                                                                                                            ].
                                                                                                                                            iprot readMapEnd.
                                                                                                                                            temp371
                                                                                                                                        ] value
                                                                                                                            ].
                                                                                                                            temp369 ifNil:[ iprot skip:temp368 type ]
                                                                                                                        ].
                                                                                                                        iprot readStructEnd.
                                                                                                                        temp367
                                                                                                                    ] value
                                                                                                        ].
                                                                                                        iprot readListEnd.
                                                                                                        temp366
                                                                                                    ] value
                                                                                        ].
                                                                                        temp363 id = 14 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 gcGraceSeconds:iprot readI32
                                                                                        ].
                                                                                        temp363 id = 15 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 defaultValidationClass:iprot readString
                                                                                        ].
                                                                                        temp363 id = 16 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 id:iprot readI32
                                                                                        ].
                                                                                        temp363 id = 17 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 minCompactionThreshold:iprot readI32
                                                                                        ].
                                                                                        temp363 id = 18 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 maxCompactionThreshold:iprot readI32
                                                                                        ].
                                                                                        temp363 id = 24 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 replicateOnWrite:iprot readBool
                                                                                        ].
                                                                                        temp363 id = 25 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 mergeShardsChance:iprot readDouble
                                                                                        ].
                                                                                        temp363 id = 26 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 keyValidationClass:iprot readString
                                                                                        ].
                                                                                        temp363 id = 28 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 keyAlias:iprot readString
                                                                                        ].
                                                                                        temp363 id = 29 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 compactionStrategy:iprot readString
                                                                                        ].
                                                                                        temp363 id = 30 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 
                                                                                                compactionStrategyOptions:[
                                                                                                        |temp372 temp373|

                                                                                                        temp372 := iprot readMapBegin.
                                                                                                        temp373 := Dictionary new.
                                                                                                        temp372 size timesRepeat:[
                                                                                                            temp373 at:iprot readString put:iprot readString
                                                                                                        ].
                                                                                                        iprot readMapEnd.
                                                                                                        temp373
                                                                                                    ] value
                                                                                        ].
                                                                                        temp363 id = 32 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 
                                                                                                compressionOptions:[
                                                                                                        |temp374 temp375|

                                                                                                        temp374 := iprot readMapBegin.
                                                                                                        temp375 := Dictionary new.
                                                                                                        temp374 size timesRepeat:[
                                                                                                            temp375 at:iprot readString put:iprot readString
                                                                                                        ].
                                                                                                        iprot readMapEnd.
                                                                                                        temp375
                                                                                                    ] value
                                                                                        ].
                                                                                        temp363 id = 33 ifTrue:[
                                                                                            temp364 := true.
                                                                                            temp362 bloomFilterFpChance:iprot readDouble
                                                                                        ].
                                                                                        temp364 ifNil:[ iprot skip:temp363 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp362
                                                                                ] value
                                                                    ].
                                                                    iprot readListEnd.
                                                                    temp361
                                                                ] value
                                                    ].
                                                    temp356 id = 6 ifTrue:[
                                                        temp357 := true.
                                                        temp355 durableWrites:iprot readBool
                                                    ].
                                                    temp357 ifNil:[ iprot skip:temp356 type ]
                                                ].
                                                iprot readStructEnd.
                                                temp355
                                            ] value
                                ].
                                iprot readListEnd.
                                temp354
                            ] value
                ].
                temp351 id = 1 ifTrue:[
                    temp352 := true.
                    temp350 
                        exception:[
                                |temp377 temp376|

                                temp376 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp377 := iprot readFieldBegin.
                                    temp377 type = TTypeStop
                                ] whileFalse:[
                                    |temp378|

                                    temp377 id = 1 ifTrue:[
                                        temp378 := true.
                                        temp376 why:iprot readString
                                    ].
                                    temp378 ifNil:[ iprot skip:temp377 type ]
                                ].
                                iprot readStructEnd.
                                temp376
                            ] value
                ].
                temp352 ifNil:[ iprot skip:temp351 type ]
            ].
            iprot readStructEnd.
            temp350
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribePartitioner
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp406 temp405|

            temp405 := TResult new.
            iprot readStructBegin.
            [
                temp406 := iprot readFieldBegin.
                temp406 type = TTypeStop
            ] whileFalse:[
                |temp407|

                temp406 id = 0 ifTrue:[
                    temp407 := true.
                    temp405 success:iprot readString
                ].
                temp407 ifNil:[ iprot skip:temp406 type ]
            ].
            iprot readStructEnd.
            temp405
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeRing
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp386 temp385|

            temp385 := TResult new.
            iprot readStructBegin.
            [
                temp386 := iprot readFieldBegin.
                temp386 type = TTypeStop
            ] whileFalse:[
                |temp387|

                temp386 id = 0 ifTrue:[
                    temp387 := true.
                    temp385 
                        success:[
                                |temp388 temp389|

                                temp388 := iprot readListBegin.
                                temp389 := OrderedCollection new.
                                temp388 size timesRepeat:[
                                    temp389 
                                        add:[
                                                |temp391 temp390|

                                                temp390 := TokenRange new.
                                                iprot readStructBegin.
                                                [
                                                    temp391 := iprot readFieldBegin.
                                                    temp391 type = TTypeStop
                                                ] whileFalse:[
                                                    |temp392|

                                                    temp391 id = 1 ifTrue:[
                                                        temp392 := true.
                                                        temp390 startToken:iprot readString
                                                    ].
                                                    temp391 id = 2 ifTrue:[
                                                        temp392 := true.
                                                        temp390 endToken:iprot readString
                                                    ].
                                                    temp391 id = 3 ifTrue:[
                                                        temp392 := true.
                                                        temp390 
                                                            endpoints:[
                                                                    |temp393 temp394|

                                                                    temp393 := iprot readListBegin.
                                                                    temp394 := OrderedCollection new.
                                                                    temp393 size timesRepeat:[
                                                                        temp394 add:iprot readString
                                                                    ].
                                                                    iprot readListEnd.
                                                                    temp394
                                                                ] value
                                                    ].
                                                    temp391 id = 4 ifTrue:[
                                                        temp392 := true.
                                                        temp390 
                                                            rpcEndpoints:[
                                                                    |temp395 temp396|

                                                                    temp395 := iprot readListBegin.
                                                                    temp396 := OrderedCollection new.
                                                                    temp395 size timesRepeat:[
                                                                        temp396 add:iprot readString
                                                                    ].
                                                                    iprot readListEnd.
                                                                    temp396
                                                                ] value
                                                    ].
                                                    temp391 id = 5 ifTrue:[
                                                        temp392 := true.
                                                        temp390 
                                                            endpointDetails:[
                                                                    |temp397 temp398|

                                                                    temp397 := iprot readListBegin.
                                                                    temp398 := OrderedCollection new.
                                                                    temp397 size timesRepeat:[
                                                                        temp398 
                                                                            add:[
                                                                                    |temp400 temp399|

                                                                                    temp399 := EndpointDetails new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp400 := iprot readFieldBegin.
                                                                                        temp400 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp401|

                                                                                        temp400 id = 1 ifTrue:[
                                                                                            temp401 := true.
                                                                                            temp399 host:iprot readString
                                                                                        ].
                                                                                        temp400 id = 2 ifTrue:[
                                                                                            temp401 := true.
                                                                                            temp399 datacenter:iprot readString
                                                                                        ].
                                                                                        temp400 id = 3 ifTrue:[
                                                                                            temp401 := true.
                                                                                            temp399 rack:iprot readString
                                                                                        ].
                                                                                        temp401 ifNil:[ iprot skip:temp400 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp399
                                                                                ] value
                                                                    ].
                                                                    iprot readListEnd.
                                                                    temp398
                                                                ] value
                                                    ].
                                                    temp392 ifNil:[ iprot skip:temp391 type ]
                                                ].
                                                iprot readStructEnd.
                                                temp390
                                            ] value
                                ].
                                iprot readListEnd.
                                temp389
                            ] value
                ].
                temp386 id = 1 ifTrue:[
                    temp387 := true.
                    temp385 
                        exception:[
                                |temp403 temp402|

                                temp402 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp403 := iprot readFieldBegin.
                                    temp403 type = TTypeStop
                                ] whileFalse:[
                                    |temp404|

                                    temp403 id = 1 ifTrue:[
                                        temp404 := true.
                                        temp402 why:iprot readString
                                    ].
                                    temp404 ifNil:[ iprot skip:temp403 type ]
                                ].
                                iprot readStructEnd.
                                temp402
                            ] value
                ].
                temp387 ifNil:[ iprot skip:temp386 type ]
            ].
            iprot readStructEnd.
            temp385
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeSchemaVersions
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp341 temp340|

            temp340 := TResult new.
            iprot readStructBegin.
            [
                temp341 := iprot readFieldBegin.
                temp341 type = TTypeStop
            ] whileFalse:[
                |temp342|

                temp341 id = 0 ifTrue:[
                    temp342 := true.
                    temp340 
                        success:[
                                |temp343 temp344|

                                temp343 := iprot readMapBegin.
                                temp344 := Dictionary new.
                                temp343 size timesRepeat:[
                                    temp344 at:iprot readString
                                        put:[
                                                |temp345 temp346|

                                                temp345 := iprot readListBegin.
                                                temp346 := OrderedCollection new.
                                                temp345 size timesRepeat:[
                                                    temp346 add:iprot readString
                                                ].
                                                iprot readListEnd.
                                                temp346
                                            ] value
                                ].
                                iprot readMapEnd.
                                temp344
                            ] value
                ].
                temp341 id = 1 ifTrue:[
                    temp342 := true.
                    temp340 
                        exception:[
                                |temp348 temp347|

                                temp347 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp348 := iprot readFieldBegin.
                                    temp348 type = TTypeStop
                                ] whileFalse:[
                                    |temp349|

                                    temp348 id = 1 ifTrue:[
                                        temp349 := true.
                                        temp347 why:iprot readString
                                    ].
                                    temp349 ifNil:[ iprot skip:temp348 type ]
                                ].
                                iprot readStructEnd.
                                temp347
                            ] value
                ].
                temp342 ifNil:[ iprot skip:temp341 type ]
            ].
            iprot readStructEnd.
            temp340
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeSnitch
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp409 temp408|

            temp408 := TResult new.
            iprot readStructBegin.
            [
                temp409 := iprot readFieldBegin.
                temp409 type = TTypeStop
            ] whileFalse:[
                |temp410|

                temp409 id = 0 ifTrue:[
                    temp410 := true.
                    temp408 success:iprot readString
                ].
                temp410 ifNil:[ iprot skip:temp409 type ]
            ].
            iprot readStructEnd.
            temp408
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeSplits
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp442 temp441|

            temp441 := TResult new.
            iprot readStructBegin.
            [
                temp442 := iprot readFieldBegin.
                temp442 type = TTypeStop
            ] whileFalse:[
                |temp443|

                temp442 id = 0 ifTrue:[
                    temp443 := true.
                    temp441 
                        success:[
                                |temp444 temp445|

                                temp444 := iprot readListBegin.
                                temp445 := OrderedCollection new.
                                temp444 size timesRepeat:[
                                    temp445 add:iprot readString
                                ].
                                iprot readListEnd.
                                temp445
                            ] value
                ].
                temp442 id = 1 ifTrue:[
                    temp443 := true.
                    temp441 
                        exception:[
                                |temp447 temp446|

                                temp446 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp447 := iprot readFieldBegin.
                                    temp447 type = TTypeStop
                                ] whileFalse:[
                                    |temp448|

                                    temp447 id = 1 ifTrue:[
                                        temp448 := true.
                                        temp446 why:iprot readString
                                    ].
                                    temp448 ifNil:[ iprot skip:temp447 type ]
                                ].
                                iprot readStructEnd.
                                temp446
                            ] value
                ].
                temp443 ifNil:[ iprot skip:temp442 type ]
            ].
            iprot readStructEnd.
            temp441
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvDescribeVersion
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp383 temp382|

            temp382 := TResult new.
            iprot readStructBegin.
            [
                temp383 := iprot readFieldBegin.
                temp383 type = TTypeStop
            ] whileFalse:[
                |temp384|

                temp383 id = 0 ifTrue:[
                    temp384 := true.
                    temp382 success:iprot readString
                ].
                temp384 ifNil:[ iprot skip:temp383 type ]
            ].
            iprot readStructEnd.
            temp382
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvExecuteCqlQuery
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp538 temp537|

            temp537 := TResult new.
            iprot readStructBegin.
            [
                temp538 := iprot readFieldBegin.
                temp538 type = TTypeStop
            ] whileFalse:[
                |temp539|

                temp538 id = 0 ifTrue:[
                    temp539 := true.
                    temp537 
                        success:[
                                |temp541 temp540|

                                temp540 := CqlResult new.
                                iprot readStructBegin.
                                [
                                    temp541 := iprot readFieldBegin.
                                    temp541 type = TTypeStop
                                ] whileFalse:[
                                    |temp542|

                                    temp541 id = 1 ifTrue:[
                                        temp542 := true.
                                        temp540 type:iprot readI32
                                    ].
                                    temp541 id = 2 ifTrue:[
                                        temp542 := true.
                                        temp540 
                                            rows:[
                                                    |temp543 temp544|

                                                    temp543 := iprot readListBegin.
                                                    temp544 := OrderedCollection new.
                                                    temp543 size timesRepeat:[
                                                        temp544 
                                                            add:[
                                                                    |temp546 temp545|

                                                                    temp545 := CqlRow new.
                                                                    iprot readStructBegin.
                                                                    [
                                                                        temp546 := iprot readFieldBegin.
                                                                        temp546 type = TTypeStop
                                                                    ] whileFalse:[
                                                                        |temp547|

                                                                        temp546 id = 1 ifTrue:[
                                                                            temp547 := true.
                                                                            temp545 key:iprot readString
                                                                        ].
                                                                        temp546 id = 2 ifTrue:[
                                                                            temp547 := true.
                                                                            temp545 
                                                                                columns:[
                                                                                        |temp548 temp549|

                                                                                        temp548 := iprot readListBegin.
                                                                                        temp549 := OrderedCollection new.
                                                                                        temp548 size timesRepeat:[
                                                                                            temp549 
                                                                                                add:[
                                                                                                        |temp551 temp550|

                                                                                                        temp550 := Column new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp551 := iprot readFieldBegin.
                                                                                                            temp551 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp552|

                                                                                                            temp551 id = 1 ifTrue:[
                                                                                                                temp552 := true.
                                                                                                                temp550 name:iprot readString
                                                                                                            ].
                                                                                                            temp551 id = 2 ifTrue:[
                                                                                                                temp552 := true.
                                                                                                                temp550 value:iprot readString
                                                                                                            ].
                                                                                                            temp551 id = 3 ifTrue:[
                                                                                                                temp552 := true.
                                                                                                                temp550 timestamp:iprot readI64
                                                                                                            ].
                                                                                                            temp551 id = 4 ifTrue:[
                                                                                                                temp552 := true.
                                                                                                                temp550 ttl:iprot readI32
                                                                                                            ].
                                                                                                            temp552 ifNil:[ iprot skip:temp551 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp550
                                                                                                    ] value
                                                                                        ].
                                                                                        iprot readListEnd.
                                                                                        temp549
                                                                                    ] value
                                                                        ].
                                                                        temp547 ifNil:[ iprot skip:temp546 type ]
                                                                    ].
                                                                    iprot readStructEnd.
                                                                    temp545
                                                                ] value
                                                    ].
                                                    iprot readListEnd.
                                                    temp544
                                                ] value
                                    ].
                                    temp541 id = 3 ifTrue:[
                                        temp542 := true.
                                        temp540 num:iprot readI32
                                    ].
                                    temp541 id = 4 ifTrue:[
                                        temp542 := true.
                                        temp540 
                                            schema:[
                                                    |temp554 temp553|

                                                    temp553 := CqlMetadata new.
                                                    iprot readStructBegin.
                                                    [
                                                        temp554 := iprot readFieldBegin.
                                                        temp554 type = TTypeStop
                                                    ] whileFalse:[
                                                        |temp555|

                                                        temp554 id = 1 ifTrue:[
                                                            temp555 := true.
                                                            temp553 
                                                                nameTypes:[
                                                                        |temp556 temp557|

                                                                        temp556 := iprot readMapBegin.
                                                                        temp557 := Dictionary new.
                                                                        temp556 size timesRepeat:[
                                                                            temp557 at:iprot readString put:iprot readString
                                                                        ].
                                                                        iprot readMapEnd.
                                                                        temp557
                                                                    ] value
                                                        ].
                                                        temp554 id = 2 ifTrue:[
                                                            temp555 := true.
                                                            temp553 
                                                                valueTypes:[
                                                                        |temp558 temp559|

                                                                        temp558 := iprot readMapBegin.
                                                                        temp559 := Dictionary new.
                                                                        temp558 size timesRepeat:[
                                                                            temp559 at:iprot readString put:iprot readString
                                                                        ].
                                                                        iprot readMapEnd.
                                                                        temp559
                                                                    ] value
                                                        ].
                                                        temp554 id = 3 ifTrue:[
                                                            temp555 := true.
                                                            temp553 defaultNameType:iprot readString
                                                        ].
                                                        temp554 id = 4 ifTrue:[
                                                            temp555 := true.
                                                            temp553 defaultValueType:iprot readString
                                                        ].
                                                        temp555 ifNil:[ iprot skip:temp554 type ]
                                                    ].
                                                    iprot readStructEnd.
                                                    temp553
                                                ] value
                                    ].
                                    temp542 ifNil:[ iprot skip:temp541 type ]
                                ].
                                iprot readStructEnd.
                                temp540
                            ] value
                ].
                temp538 id = 1 ifTrue:[
                    temp539 := true.
                    temp537 
                        exception:[
                                |temp561 temp560|

                                temp560 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp561 := iprot readFieldBegin.
                                    temp561 type = TTypeStop
                                ] whileFalse:[
                                    |temp562|

                                    temp561 id = 1 ifTrue:[
                                        temp562 := true.
                                        temp560 why:iprot readString
                                    ].
                                    temp562 ifNil:[ iprot skip:temp561 type ]
                                ].
                                iprot readStructEnd.
                                temp560
                            ] value
                ].
                temp538 id = 2 ifTrue:[
                    temp539 := true.
                    temp537 
                        exception:[
                                |temp564 temp563|

                                temp563 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp564 := iprot readFieldBegin.
                                    temp564 type = TTypeStop
                                ] whileFalse:[
                                    |temp565|

                                    temp565 ifNil:[ iprot skip:temp564 type ]
                                ].
                                iprot readStructEnd.
                                temp563
                            ] value
                ].
                temp538 id = 3 ifTrue:[
                    temp539 := true.
                    temp537 
                        exception:[
                                |temp567 temp566|

                                temp566 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp567 := iprot readFieldBegin.
                                    temp567 type = TTypeStop
                                ] whileFalse:[
                                    |temp568|

                                    temp568 ifNil:[ iprot skip:temp567 type ]
                                ].
                                iprot readStructEnd.
                                temp566
                            ] value
                ].
                temp538 id = 4 ifTrue:[
                    temp539 := true.
                    temp537 
                        exception:[
                                |temp570 temp569|

                                temp569 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp570 := iprot readFieldBegin.
                                    temp570 type = TTypeStop
                                ] whileFalse:[
                                    |temp571|

                                    temp571 ifNil:[ iprot skip:temp570 type ]
                                ].
                                iprot readStructEnd.
                                temp569
                            ] value
                ].
                temp539 ifNil:[ iprot skip:temp538 type ]
            ].
            iprot readStructEnd.
            temp537
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvExecutePreparedCqlQuery
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp583 temp582|

            temp582 := TResult new.
            iprot readStructBegin.
            [
                temp583 := iprot readFieldBegin.
                temp583 type = TTypeStop
            ] whileFalse:[
                |temp584|

                temp583 id = 0 ifTrue:[
                    temp584 := true.
                    temp582 
                        success:[
                                |temp586 temp585|

                                temp585 := CqlResult new.
                                iprot readStructBegin.
                                [
                                    temp586 := iprot readFieldBegin.
                                    temp586 type = TTypeStop
                                ] whileFalse:[
                                    |temp587|

                                    temp586 id = 1 ifTrue:[
                                        temp587 := true.
                                        temp585 type:iprot readI32
                                    ].
                                    temp586 id = 2 ifTrue:[
                                        temp587 := true.
                                        temp585 
                                            rows:[
                                                    |temp588 temp589|

                                                    temp588 := iprot readListBegin.
                                                    temp589 := OrderedCollection new.
                                                    temp588 size timesRepeat:[
                                                        temp589 
                                                            add:[
                                                                    |temp591 temp590|

                                                                    temp590 := CqlRow new.
                                                                    iprot readStructBegin.
                                                                    [
                                                                        temp591 := iprot readFieldBegin.
                                                                        temp591 type = TTypeStop
                                                                    ] whileFalse:[
                                                                        |temp592|

                                                                        temp591 id = 1 ifTrue:[
                                                                            temp592 := true.
                                                                            temp590 key:iprot readString
                                                                        ].
                                                                        temp591 id = 2 ifTrue:[
                                                                            temp592 := true.
                                                                            temp590 
                                                                                columns:[
                                                                                        |temp593 temp594|

                                                                                        temp593 := iprot readListBegin.
                                                                                        temp594 := OrderedCollection new.
                                                                                        temp593 size timesRepeat:[
                                                                                            temp594 
                                                                                                add:[
                                                                                                        |temp596 temp595|

                                                                                                        temp595 := Column new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp596 := iprot readFieldBegin.
                                                                                                            temp596 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp597|

                                                                                                            temp596 id = 1 ifTrue:[
                                                                                                                temp597 := true.
                                                                                                                temp595 name:iprot readString
                                                                                                            ].
                                                                                                            temp596 id = 2 ifTrue:[
                                                                                                                temp597 := true.
                                                                                                                temp595 value:iprot readString
                                                                                                            ].
                                                                                                            temp596 id = 3 ifTrue:[
                                                                                                                temp597 := true.
                                                                                                                temp595 timestamp:iprot readI64
                                                                                                            ].
                                                                                                            temp596 id = 4 ifTrue:[
                                                                                                                temp597 := true.
                                                                                                                temp595 ttl:iprot readI32
                                                                                                            ].
                                                                                                            temp597 ifNil:[ iprot skip:temp596 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp595
                                                                                                    ] value
                                                                                        ].
                                                                                        iprot readListEnd.
                                                                                        temp594
                                                                                    ] value
                                                                        ].
                                                                        temp592 ifNil:[ iprot skip:temp591 type ]
                                                                    ].
                                                                    iprot readStructEnd.
                                                                    temp590
                                                                ] value
                                                    ].
                                                    iprot readListEnd.
                                                    temp589
                                                ] value
                                    ].
                                    temp586 id = 3 ifTrue:[
                                        temp587 := true.
                                        temp585 num:iprot readI32
                                    ].
                                    temp586 id = 4 ifTrue:[
                                        temp587 := true.
                                        temp585 
                                            schema:[
                                                    |temp599 temp598|

                                                    temp598 := CqlMetadata new.
                                                    iprot readStructBegin.
                                                    [
                                                        temp599 := iprot readFieldBegin.
                                                        temp599 type = TTypeStop
                                                    ] whileFalse:[
                                                        |temp600|

                                                        temp599 id = 1 ifTrue:[
                                                            temp600 := true.
                                                            temp598 
                                                                nameTypes:[
                                                                        |temp601 temp602|

                                                                        temp601 := iprot readMapBegin.
                                                                        temp602 := Dictionary new.
                                                                        temp601 size timesRepeat:[
                                                                            temp602 at:iprot readString put:iprot readString
                                                                        ].
                                                                        iprot readMapEnd.
                                                                        temp602
                                                                    ] value
                                                        ].
                                                        temp599 id = 2 ifTrue:[
                                                            temp600 := true.
                                                            temp598 
                                                                valueTypes:[
                                                                        |temp603 temp604|

                                                                        temp603 := iprot readMapBegin.
                                                                        temp604 := Dictionary new.
                                                                        temp603 size timesRepeat:[
                                                                            temp604 at:iprot readString put:iprot readString
                                                                        ].
                                                                        iprot readMapEnd.
                                                                        temp604
                                                                    ] value
                                                        ].
                                                        temp599 id = 3 ifTrue:[
                                                            temp600 := true.
                                                            temp598 defaultNameType:iprot readString
                                                        ].
                                                        temp599 id = 4 ifTrue:[
                                                            temp600 := true.
                                                            temp598 defaultValueType:iprot readString
                                                        ].
                                                        temp600 ifNil:[ iprot skip:temp599 type ]
                                                    ].
                                                    iprot readStructEnd.
                                                    temp598
                                                ] value
                                    ].
                                    temp587 ifNil:[ iprot skip:temp586 type ]
                                ].
                                iprot readStructEnd.
                                temp585
                            ] value
                ].
                temp583 id = 1 ifTrue:[
                    temp584 := true.
                    temp582 
                        exception:[
                                |temp606 temp605|

                                temp605 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp606 := iprot readFieldBegin.
                                    temp606 type = TTypeStop
                                ] whileFalse:[
                                    |temp607|

                                    temp606 id = 1 ifTrue:[
                                        temp607 := true.
                                        temp605 why:iprot readString
                                    ].
                                    temp607 ifNil:[ iprot skip:temp606 type ]
                                ].
                                iprot readStructEnd.
                                temp605
                            ] value
                ].
                temp583 id = 2 ifTrue:[
                    temp584 := true.
                    temp582 
                        exception:[
                                |temp609 temp608|

                                temp608 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp609 := iprot readFieldBegin.
                                    temp609 type = TTypeStop
                                ] whileFalse:[
                                    |temp610|

                                    temp610 ifNil:[ iprot skip:temp609 type ]
                                ].
                                iprot readStructEnd.
                                temp608
                            ] value
                ].
                temp583 id = 3 ifTrue:[
                    temp584 := true.
                    temp582 
                        exception:[
                                |temp612 temp611|

                                temp611 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp612 := iprot readFieldBegin.
                                    temp612 type = TTypeStop
                                ] whileFalse:[
                                    |temp613|

                                    temp613 ifNil:[ iprot skip:temp612 type ]
                                ].
                                iprot readStructEnd.
                                temp611
                            ] value
                ].
                temp583 id = 4 ifTrue:[
                    temp584 := true.
                    temp582 
                        exception:[
                                |temp615 temp614|

                                temp614 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp615 := iprot readFieldBegin.
                                    temp615 type = TTypeStop
                                ] whileFalse:[
                                    |temp616|

                                    temp616 ifNil:[ iprot skip:temp615 type ]
                                ].
                                iprot readStructEnd.
                                temp614
                            ] value
                ].
                temp584 ifNil:[ iprot skip:temp583 type ]
            ].
            iprot readStructEnd.
            temp582
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvGet
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp18 temp17|

            temp17 := TResult new.
            iprot readStructBegin.
            [
                temp18 := iprot readFieldBegin.
                temp18 type = TTypeStop
            ] whileFalse:[
                |temp19|

                temp18 id = 0 ifTrue:[
                    temp19 := true.
                    temp17 
                        success:[
                                |temp21 temp20|

                                temp20 := ColumnOrSuperColumn new.
                                iprot readStructBegin.
                                [
                                    temp21 := iprot readFieldBegin.
                                    temp21 type = TTypeStop
                                ] whileFalse:[
                                    |temp22|

                                    temp21 id = 1 ifTrue:[
                                        temp22 := true.
                                        temp20 
                                            column:[
                                                    |temp24 temp23|

                                                    temp23 := Column new.
                                                    iprot readStructBegin.
                                                    [
                                                        temp24 := iprot readFieldBegin.
                                                        temp24 type = TTypeStop
                                                    ] whileFalse:[
                                                        |temp25|

                                                        temp24 id = 1 ifTrue:[
                                                            temp25 := true.
                                                            temp23 name:iprot readString
                                                        ].
                                                        temp24 id = 2 ifTrue:[
                                                            temp25 := true.
                                                            temp23 value:iprot readString
                                                        ].
                                                        temp24 id = 3 ifTrue:[
                                                            temp25 := true.
                                                            temp23 timestamp:iprot readI64
                                                        ].
                                                        temp24 id = 4 ifTrue:[
                                                            temp25 := true.
                                                            temp23 ttl:iprot readI32
                                                        ].
                                                        temp25 ifNil:[ iprot skip:temp24 type ]
                                                    ].
                                                    iprot readStructEnd.
                                                    temp23
                                                ] value
                                    ].
                                    temp21 id = 2 ifTrue:[
                                        temp22 := true.
                                        temp20 
                                            superColumn:[
                                                    |temp27 temp26|

                                                    temp26 := SuperColumn new.
                                                    iprot readStructBegin.
                                                    [
                                                        temp27 := iprot readFieldBegin.
                                                        temp27 type = TTypeStop
                                                    ] whileFalse:[
                                                        |temp28|

                                                        temp27 id = 1 ifTrue:[
                                                            temp28 := true.
                                                            temp26 name:iprot readString
                                                        ].
                                                        temp27 id = 2 ifTrue:[
                                                            temp28 := true.
                                                            temp26 
                                                                columns:[
                                                                        |temp29 temp30|

                                                                        temp29 := iprot readListBegin.
                                                                        temp30 := OrderedCollection new.
                                                                        temp29 size timesRepeat:[
                                                                            temp30 
                                                                                add:[
                                                                                        |temp32 temp31|

                                                                                        temp31 := Column new.
                                                                                        iprot readStructBegin.
                                                                                        [
                                                                                            temp32 := iprot readFieldBegin.
                                                                                            temp32 type = TTypeStop
                                                                                        ] whileFalse:[
                                                                                            |temp33|

                                                                                            temp32 id = 1 ifTrue:[
                                                                                                temp33 := true.
                                                                                                temp31 name:iprot readString
                                                                                            ].
                                                                                            temp32 id = 2 ifTrue:[
                                                                                                temp33 := true.
                                                                                                temp31 value:iprot readString
                                                                                            ].
                                                                                            temp32 id = 3 ifTrue:[
                                                                                                temp33 := true.
                                                                                                temp31 timestamp:iprot readI64
                                                                                            ].
                                                                                            temp32 id = 4 ifTrue:[
                                                                                                temp33 := true.
                                                                                                temp31 ttl:iprot readI32
                                                                                            ].
                                                                                            temp33 ifNil:[ iprot skip:temp32 type ]
                                                                                        ].
                                                                                        iprot readStructEnd.
                                                                                        temp31
                                                                                    ] value
                                                                        ].
                                                                        iprot readListEnd.
                                                                        temp30
                                                                    ] value
                                                        ].
                                                        temp28 ifNil:[ iprot skip:temp27 type ]
                                                    ].
                                                    iprot readStructEnd.
                                                    temp26
                                                ] value
                                    ].
                                    temp21 id = 3 ifTrue:[
                                        temp22 := true.
                                        temp20 
                                            counterColumn:[
                                                    |temp35 temp34|

                                                    temp34 := CounterColumn new.
                                                    iprot readStructBegin.
                                                    [
                                                        temp35 := iprot readFieldBegin.
                                                        temp35 type = TTypeStop
                                                    ] whileFalse:[
                                                        |temp36|

                                                        temp35 id = 1 ifTrue:[
                                                            temp36 := true.
                                                            temp34 name:iprot readString
                                                        ].
                                                        temp35 id = 2 ifTrue:[
                                                            temp36 := true.
                                                            temp34 value:iprot readI64
                                                        ].
                                                        temp36 ifNil:[ iprot skip:temp35 type ]
                                                    ].
                                                    iprot readStructEnd.
                                                    temp34
                                                ] value
                                    ].
                                    temp21 id = 4 ifTrue:[
                                        temp22 := true.
                                        temp20 
                                            counterSuperColumn:[
                                                    |temp38 temp37|

                                                    temp37 := CounterSuperColumn new.
                                                    iprot readStructBegin.
                                                    [
                                                        temp38 := iprot readFieldBegin.
                                                        temp38 type = TTypeStop
                                                    ] whileFalse:[
                                                        |temp39|

                                                        temp38 id = 1 ifTrue:[
                                                            temp39 := true.
                                                            temp37 name:iprot readString
                                                        ].
                                                        temp38 id = 2 ifTrue:[
                                                            temp39 := true.
                                                            temp37 
                                                                columns:[
                                                                        |temp40 temp41|

                                                                        temp40 := iprot readListBegin.
                                                                        temp41 := OrderedCollection new.
                                                                        temp40 size timesRepeat:[
                                                                            temp41 
                                                                                add:[
                                                                                        |temp43 temp42|

                                                                                        temp42 := CounterColumn new.
                                                                                        iprot readStructBegin.
                                                                                        [
                                                                                            temp43 := iprot readFieldBegin.
                                                                                            temp43 type = TTypeStop
                                                                                        ] whileFalse:[
                                                                                            |temp44|

                                                                                            temp43 id = 1 ifTrue:[
                                                                                                temp44 := true.
                                                                                                temp42 name:iprot readString
                                                                                            ].
                                                                                            temp43 id = 2 ifTrue:[
                                                                                                temp44 := true.
                                                                                                temp42 value:iprot readI64
                                                                                            ].
                                                                                            temp44 ifNil:[ iprot skip:temp43 type ]
                                                                                        ].
                                                                                        iprot readStructEnd.
                                                                                        temp42
                                                                                    ] value
                                                                        ].
                                                                        iprot readListEnd.
                                                                        temp41
                                                                    ] value
                                                        ].
                                                        temp39 ifNil:[ iprot skip:temp38 type ]
                                                    ].
                                                    iprot readStructEnd.
                                                    temp37
                                                ] value
                                    ].
                                    temp22 ifNil:[ iprot skip:temp21 type ]
                                ].
                                iprot readStructEnd.
                                temp20
                            ] value
                ].
                temp18 id = 1 ifTrue:[
                    temp19 := true.
                    temp17 
                        exception:[
                                |temp46 temp45|

                                temp45 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp46 := iprot readFieldBegin.
                                    temp46 type = TTypeStop
                                ] whileFalse:[
                                    |temp47|

                                    temp46 id = 1 ifTrue:[
                                        temp47 := true.
                                        temp45 why:iprot readString
                                    ].
                                    temp47 ifNil:[ iprot skip:temp46 type ]
                                ].
                                iprot readStructEnd.
                                temp45
                            ] value
                ].
                temp18 id = 2 ifTrue:[
                    temp19 := true.
                    temp17 
                        exception:[
                                |temp49 temp48|

                                temp48 := NotFoundException new.
                                iprot readStructBegin.
                                [
                                    temp49 := iprot readFieldBegin.
                                    temp49 type = TTypeStop
                                ] whileFalse:[
                                    |temp50|

                                    temp50 ifNil:[ iprot skip:temp49 type ]
                                ].
                                iprot readStructEnd.
                                temp48
                            ] value
                ].
                temp18 id = 3 ifTrue:[
                    temp19 := true.
                    temp17 
                        exception:[
                                |temp52 temp51|

                                temp51 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp52 := iprot readFieldBegin.
                                    temp52 type = TTypeStop
                                ] whileFalse:[
                                    |temp53|

                                    temp53 ifNil:[ iprot skip:temp52 type ]
                                ].
                                iprot readStructEnd.
                                temp51
                            ] value
                ].
                temp18 id = 4 ifTrue:[
                    temp19 := true.
                    temp17 
                        exception:[
                                |temp55 temp54|

                                temp54 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp55 := iprot readFieldBegin.
                                    temp55 type = TTypeStop
                                ] whileFalse:[
                                    |temp56|

                                    temp56 ifNil:[ iprot skip:temp55 type ]
                                ].
                                iprot readStructEnd.
                                temp54
                            ] value
                ].
                temp19 ifNil:[ iprot skip:temp18 type ]
            ].
            iprot readStructEnd.
            temp17
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvGetCount
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp99 temp98|

            temp98 := TResult new.
            iprot readStructBegin.
            [
                temp99 := iprot readFieldBegin.
                temp99 type = TTypeStop
            ] whileFalse:[
                |temp100|

                temp99 id = 0 ifTrue:[
                    temp100 := true.
                    temp98 success:iprot readI32
                ].
                temp99 id = 1 ifTrue:[
                    temp100 := true.
                    temp98 
                        exception:[
                                |temp102 temp101|

                                temp101 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp102 := iprot readFieldBegin.
                                    temp102 type = TTypeStop
                                ] whileFalse:[
                                    |temp103|

                                    temp102 id = 1 ifTrue:[
                                        temp103 := true.
                                        temp101 why:iprot readString
                                    ].
                                    temp103 ifNil:[ iprot skip:temp102 type ]
                                ].
                                iprot readStructEnd.
                                temp101
                            ] value
                ].
                temp99 id = 2 ifTrue:[
                    temp100 := true.
                    temp98 
                        exception:[
                                |temp105 temp104|

                                temp104 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp105 := iprot readFieldBegin.
                                    temp105 type = TTypeStop
                                ] whileFalse:[
                                    |temp106|

                                    temp106 ifNil:[ iprot skip:temp105 type ]
                                ].
                                iprot readStructEnd.
                                temp104
                            ] value
                ].
                temp99 id = 3 ifTrue:[
                    temp100 := true.
                    temp98 
                        exception:[
                                |temp108 temp107|

                                temp107 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp108 := iprot readFieldBegin.
                                    temp108 type = TTypeStop
                                ] whileFalse:[
                                    |temp109|

                                    temp109 ifNil:[ iprot skip:temp108 type ]
                                ].
                                iprot readStructEnd.
                                temp107
                            ] value
                ].
                temp100 ifNil:[ iprot skip:temp99 type ]
            ].
            iprot readStructEnd.
            temp98
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvGetIndexedSlices
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp217 temp216|

            temp216 := TResult new.
            iprot readStructBegin.
            [
                temp217 := iprot readFieldBegin.
                temp217 type = TTypeStop
            ] whileFalse:[
                |temp218|

                temp217 id = 0 ifTrue:[
                    temp218 := true.
                    temp216 
                        success:[
                                |temp219 temp220|

                                temp219 := iprot readListBegin.
                                temp220 := OrderedCollection new.
                                temp219 size timesRepeat:[
                                    temp220 
                                        add:[
                                                |temp222 temp221|

                                                temp221 := KeySlice new.
                                                iprot readStructBegin.
                                                [
                                                    temp222 := iprot readFieldBegin.
                                                    temp222 type = TTypeStop
                                                ] whileFalse:[
                                                    |temp223|

                                                    temp222 id = 1 ifTrue:[
                                                        temp223 := true.
                                                        temp221 key:iprot readString
                                                    ].
                                                    temp222 id = 2 ifTrue:[
                                                        temp223 := true.
                                                        temp221 
                                                            columns:[
                                                                    |temp224 temp225|

                                                                    temp224 := iprot readListBegin.
                                                                    temp225 := OrderedCollection new.
                                                                    temp224 size timesRepeat:[
                                                                        temp225 
                                                                            add:[
                                                                                    |temp227 temp226|

                                                                                    temp226 := ColumnOrSuperColumn new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp227 := iprot readFieldBegin.
                                                                                        temp227 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp228|

                                                                                        temp227 id = 1 ifTrue:[
                                                                                            temp228 := true.
                                                                                            temp226 
                                                                                                column:[
                                                                                                        |temp230 temp229|

                                                                                                        temp229 := Column new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp230 := iprot readFieldBegin.
                                                                                                            temp230 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp231|

                                                                                                            temp230 id = 1 ifTrue:[
                                                                                                                temp231 := true.
                                                                                                                temp229 name:iprot readString
                                                                                                            ].
                                                                                                            temp230 id = 2 ifTrue:[
                                                                                                                temp231 := true.
                                                                                                                temp229 value:iprot readString
                                                                                                            ].
                                                                                                            temp230 id = 3 ifTrue:[
                                                                                                                temp231 := true.
                                                                                                                temp229 timestamp:iprot readI64
                                                                                                            ].
                                                                                                            temp230 id = 4 ifTrue:[
                                                                                                                temp231 := true.
                                                                                                                temp229 ttl:iprot readI32
                                                                                                            ].
                                                                                                            temp231 ifNil:[ iprot skip:temp230 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp229
                                                                                                    ] value
                                                                                        ].
                                                                                        temp227 id = 2 ifTrue:[
                                                                                            temp228 := true.
                                                                                            temp226 
                                                                                                superColumn:[
                                                                                                        |temp233 temp232|

                                                                                                        temp232 := SuperColumn new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp233 := iprot readFieldBegin.
                                                                                                            temp233 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp234|

                                                                                                            temp233 id = 1 ifTrue:[
                                                                                                                temp234 := true.
                                                                                                                temp232 name:iprot readString
                                                                                                            ].
                                                                                                            temp233 id = 2 ifTrue:[
                                                                                                                temp234 := true.
                                                                                                                temp232 
                                                                                                                    columns:[
                                                                                                                            |temp235 temp236|

                                                                                                                            temp235 := iprot readListBegin.
                                                                                                                            temp236 := OrderedCollection new.
                                                                                                                            temp235 size timesRepeat:[
                                                                                                                                temp236 
                                                                                                                                    add:[
                                                                                                                                            |temp238 temp237|

                                                                                                                                            temp237 := Column new.
                                                                                                                                            iprot readStructBegin.
                                                                                                                                            [
                                                                                                                                                temp238 := iprot readFieldBegin.
                                                                                                                                                temp238 type = TTypeStop
                                                                                                                                            ] whileFalse:[
                                                                                                                                                |temp239|

                                                                                                                                                temp238 id = 1 ifTrue:[
                                                                                                                                                    temp239 := true.
                                                                                                                                                    temp237 name:iprot readString
                                                                                                                                                ].
                                                                                                                                                temp238 id = 2 ifTrue:[
                                                                                                                                                    temp239 := true.
                                                                                                                                                    temp237 value:iprot readString
                                                                                                                                                ].
                                                                                                                                                temp238 id = 3 ifTrue:[
                                                                                                                                                    temp239 := true.
                                                                                                                                                    temp237 timestamp:iprot readI64
                                                                                                                                                ].
                                                                                                                                                temp238 id = 4 ifTrue:[
                                                                                                                                                    temp239 := true.
                                                                                                                                                    temp237 ttl:iprot readI32
                                                                                                                                                ].
                                                                                                                                                temp239 ifNil:[ iprot skip:temp238 type ]
                                                                                                                                            ].
                                                                                                                                            iprot readStructEnd.
                                                                                                                                            temp237
                                                                                                                                        ] value
                                                                                                                            ].
                                                                                                                            iprot readListEnd.
                                                                                                                            temp236
                                                                                                                        ] value
                                                                                                            ].
                                                                                                            temp234 ifNil:[ iprot skip:temp233 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp232
                                                                                                    ] value
                                                                                        ].
                                                                                        temp227 id = 3 ifTrue:[
                                                                                            temp228 := true.
                                                                                            temp226 
                                                                                                counterColumn:[
                                                                                                        |temp241 temp240|

                                                                                                        temp240 := CounterColumn new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp241 := iprot readFieldBegin.
                                                                                                            temp241 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp242|

                                                                                                            temp241 id = 1 ifTrue:[
                                                                                                                temp242 := true.
                                                                                                                temp240 name:iprot readString
                                                                                                            ].
                                                                                                            temp241 id = 2 ifTrue:[
                                                                                                                temp242 := true.
                                                                                                                temp240 value:iprot readI64
                                                                                                            ].
                                                                                                            temp242 ifNil:[ iprot skip:temp241 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp240
                                                                                                    ] value
                                                                                        ].
                                                                                        temp227 id = 4 ifTrue:[
                                                                                            temp228 := true.
                                                                                            temp226 
                                                                                                counterSuperColumn:[
                                                                                                        |temp244 temp243|

                                                                                                        temp243 := CounterSuperColumn new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp244 := iprot readFieldBegin.
                                                                                                            temp244 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp245|

                                                                                                            temp244 id = 1 ifTrue:[
                                                                                                                temp245 := true.
                                                                                                                temp243 name:iprot readString
                                                                                                            ].
                                                                                                            temp244 id = 2 ifTrue:[
                                                                                                                temp245 := true.
                                                                                                                temp243 
                                                                                                                    columns:[
                                                                                                                            |temp246 temp247|

                                                                                                                            temp246 := iprot readListBegin.
                                                                                                                            temp247 := OrderedCollection new.
                                                                                                                            temp246 size timesRepeat:[
                                                                                                                                temp247 
                                                                                                                                    add:[
                                                                                                                                            |temp249 temp248|

                                                                                                                                            temp248 := CounterColumn new.
                                                                                                                                            iprot readStructBegin.
                                                                                                                                            [
                                                                                                                                                temp249 := iprot readFieldBegin.
                                                                                                                                                temp249 type = TTypeStop
                                                                                                                                            ] whileFalse:[
                                                                                                                                                |temp250|

                                                                                                                                                temp249 id = 1 ifTrue:[
                                                                                                                                                    temp250 := true.
                                                                                                                                                    temp248 name:iprot readString
                                                                                                                                                ].
                                                                                                                                                temp249 id = 2 ifTrue:[
                                                                                                                                                    temp250 := true.
                                                                                                                                                    temp248 value:iprot readI64
                                                                                                                                                ].
                                                                                                                                                temp250 ifNil:[ iprot skip:temp249 type ]
                                                                                                                                            ].
                                                                                                                                            iprot readStructEnd.
                                                                                                                                            temp248
                                                                                                                                        ] value
                                                                                                                            ].
                                                                                                                            iprot readListEnd.
                                                                                                                            temp247
                                                                                                                        ] value
                                                                                                            ].
                                                                                                            temp245 ifNil:[ iprot skip:temp244 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp243
                                                                                                    ] value
                                                                                        ].
                                                                                        temp228 ifNil:[ iprot skip:temp227 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp226
                                                                                ] value
                                                                    ].
                                                                    iprot readListEnd.
                                                                    temp225
                                                                ] value
                                                    ].
                                                    temp223 ifNil:[ iprot skip:temp222 type ]
                                                ].
                                                iprot readStructEnd.
                                                temp221
                                            ] value
                                ].
                                iprot readListEnd.
                                temp220
                            ] value
                ].
                temp217 id = 1 ifTrue:[
                    temp218 := true.
                    temp216 
                        exception:[
                                |temp252 temp251|

                                temp251 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp252 := iprot readFieldBegin.
                                    temp252 type = TTypeStop
                                ] whileFalse:[
                                    |temp253|

                                    temp252 id = 1 ifTrue:[
                                        temp253 := true.
                                        temp251 why:iprot readString
                                    ].
                                    temp253 ifNil:[ iprot skip:temp252 type ]
                                ].
                                iprot readStructEnd.
                                temp251
                            ] value
                ].
                temp217 id = 2 ifTrue:[
                    temp218 := true.
                    temp216 
                        exception:[
                                |temp255 temp254|

                                temp254 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp255 := iprot readFieldBegin.
                                    temp255 type = TTypeStop
                                ] whileFalse:[
                                    |temp256|

                                    temp256 ifNil:[ iprot skip:temp255 type ]
                                ].
                                iprot readStructEnd.
                                temp254
                            ] value
                ].
                temp217 id = 3 ifTrue:[
                    temp218 := true.
                    temp216 
                        exception:[
                                |temp258 temp257|

                                temp257 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp258 := iprot readFieldBegin.
                                    temp258 type = TTypeStop
                                ] whileFalse:[
                                    |temp259|

                                    temp259 ifNil:[ iprot skip:temp258 type ]
                                ].
                                iprot readStructEnd.
                                temp257
                            ] value
                ].
                temp218 ifNil:[ iprot skip:temp217 type ]
            ].
            iprot readStructEnd.
            temp216
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvGetRangeSlices
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp171 temp170|

            temp170 := TResult new.
            iprot readStructBegin.
            [
                temp171 := iprot readFieldBegin.
                temp171 type = TTypeStop
            ] whileFalse:[
                |temp172|

                temp171 id = 0 ifTrue:[
                    temp172 := true.
                    temp170 
                        success:[
                                |temp173 temp174|

                                temp173 := iprot readListBegin.
                                temp174 := OrderedCollection new.
                                temp173 size timesRepeat:[
                                    temp174 
                                        add:[
                                                |temp176 temp175|

                                                temp175 := KeySlice new.
                                                iprot readStructBegin.
                                                [
                                                    temp176 := iprot readFieldBegin.
                                                    temp176 type = TTypeStop
                                                ] whileFalse:[
                                                    |temp177|

                                                    temp176 id = 1 ifTrue:[
                                                        temp177 := true.
                                                        temp175 key:iprot readString
                                                    ].
                                                    temp176 id = 2 ifTrue:[
                                                        temp177 := true.
                                                        temp175 
                                                            columns:[
                                                                    |temp178 temp179|

                                                                    temp178 := iprot readListBegin.
                                                                    temp179 := OrderedCollection new.
                                                                    temp178 size timesRepeat:[
                                                                        temp179 
                                                                            add:[
                                                                                    |temp181 temp180|

                                                                                    temp180 := ColumnOrSuperColumn new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp181 := iprot readFieldBegin.
                                                                                        temp181 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp182|

                                                                                        temp181 id = 1 ifTrue:[
                                                                                            temp182 := true.
                                                                                            temp180 
                                                                                                column:[
                                                                                                        |temp184 temp183|

                                                                                                        temp183 := Column new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp184 := iprot readFieldBegin.
                                                                                                            temp184 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp185|

                                                                                                            temp184 id = 1 ifTrue:[
                                                                                                                temp185 := true.
                                                                                                                temp183 name:iprot readString
                                                                                                            ].
                                                                                                            temp184 id = 2 ifTrue:[
                                                                                                                temp185 := true.
                                                                                                                temp183 value:iprot readString
                                                                                                            ].
                                                                                                            temp184 id = 3 ifTrue:[
                                                                                                                temp185 := true.
                                                                                                                temp183 timestamp:iprot readI64
                                                                                                            ].
                                                                                                            temp184 id = 4 ifTrue:[
                                                                                                                temp185 := true.
                                                                                                                temp183 ttl:iprot readI32
                                                                                                            ].
                                                                                                            temp185 ifNil:[ iprot skip:temp184 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp183
                                                                                                    ] value
                                                                                        ].
                                                                                        temp181 id = 2 ifTrue:[
                                                                                            temp182 := true.
                                                                                            temp180 
                                                                                                superColumn:[
                                                                                                        |temp187 temp186|

                                                                                                        temp186 := SuperColumn new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp187 := iprot readFieldBegin.
                                                                                                            temp187 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp188|

                                                                                                            temp187 id = 1 ifTrue:[
                                                                                                                temp188 := true.
                                                                                                                temp186 name:iprot readString
                                                                                                            ].
                                                                                                            temp187 id = 2 ifTrue:[
                                                                                                                temp188 := true.
                                                                                                                temp186 
                                                                                                                    columns:[
                                                                                                                            |temp189 temp190|

                                                                                                                            temp189 := iprot readListBegin.
                                                                                                                            temp190 := OrderedCollection new.
                                                                                                                            temp189 size timesRepeat:[
                                                                                                                                temp190 
                                                                                                                                    add:[
                                                                                                                                            |temp192 temp191|

                                                                                                                                            temp191 := Column new.
                                                                                                                                            iprot readStructBegin.
                                                                                                                                            [
                                                                                                                                                temp192 := iprot readFieldBegin.
                                                                                                                                                temp192 type = TTypeStop
                                                                                                                                            ] whileFalse:[
                                                                                                                                                |temp193|

                                                                                                                                                temp192 id = 1 ifTrue:[
                                                                                                                                                    temp193 := true.
                                                                                                                                                    temp191 name:iprot readString
                                                                                                                                                ].
                                                                                                                                                temp192 id = 2 ifTrue:[
                                                                                                                                                    temp193 := true.
                                                                                                                                                    temp191 value:iprot readString
                                                                                                                                                ].
                                                                                                                                                temp192 id = 3 ifTrue:[
                                                                                                                                                    temp193 := true.
                                                                                                                                                    temp191 timestamp:iprot readI64
                                                                                                                                                ].
                                                                                                                                                temp192 id = 4 ifTrue:[
                                                                                                                                                    temp193 := true.
                                                                                                                                                    temp191 ttl:iprot readI32
                                                                                                                                                ].
                                                                                                                                                temp193 ifNil:[ iprot skip:temp192 type ]
                                                                                                                                            ].
                                                                                                                                            iprot readStructEnd.
                                                                                                                                            temp191
                                                                                                                                        ] value
                                                                                                                            ].
                                                                                                                            iprot readListEnd.
                                                                                                                            temp190
                                                                                                                        ] value
                                                                                                            ].
                                                                                                            temp188 ifNil:[ iprot skip:temp187 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp186
                                                                                                    ] value
                                                                                        ].
                                                                                        temp181 id = 3 ifTrue:[
                                                                                            temp182 := true.
                                                                                            temp180 
                                                                                                counterColumn:[
                                                                                                        |temp195 temp194|

                                                                                                        temp194 := CounterColumn new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp195 := iprot readFieldBegin.
                                                                                                            temp195 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp196|

                                                                                                            temp195 id = 1 ifTrue:[
                                                                                                                temp196 := true.
                                                                                                                temp194 name:iprot readString
                                                                                                            ].
                                                                                                            temp195 id = 2 ifTrue:[
                                                                                                                temp196 := true.
                                                                                                                temp194 value:iprot readI64
                                                                                                            ].
                                                                                                            temp196 ifNil:[ iprot skip:temp195 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp194
                                                                                                    ] value
                                                                                        ].
                                                                                        temp181 id = 4 ifTrue:[
                                                                                            temp182 := true.
                                                                                            temp180 
                                                                                                counterSuperColumn:[
                                                                                                        |temp198 temp197|

                                                                                                        temp197 := CounterSuperColumn new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp198 := iprot readFieldBegin.
                                                                                                            temp198 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp199|

                                                                                                            temp198 id = 1 ifTrue:[
                                                                                                                temp199 := true.
                                                                                                                temp197 name:iprot readString
                                                                                                            ].
                                                                                                            temp198 id = 2 ifTrue:[
                                                                                                                temp199 := true.
                                                                                                                temp197 
                                                                                                                    columns:[
                                                                                                                            |temp200 temp201|

                                                                                                                            temp200 := iprot readListBegin.
                                                                                                                            temp201 := OrderedCollection new.
                                                                                                                            temp200 size timesRepeat:[
                                                                                                                                temp201 
                                                                                                                                    add:[
                                                                                                                                            |temp203 temp202|

                                                                                                                                            temp202 := CounterColumn new.
                                                                                                                                            iprot readStructBegin.
                                                                                                                                            [
                                                                                                                                                temp203 := iprot readFieldBegin.
                                                                                                                                                temp203 type = TTypeStop
                                                                                                                                            ] whileFalse:[
                                                                                                                                                |temp204|

                                                                                                                                                temp203 id = 1 ifTrue:[
                                                                                                                                                    temp204 := true.
                                                                                                                                                    temp202 name:iprot readString
                                                                                                                                                ].
                                                                                                                                                temp203 id = 2 ifTrue:[
                                                                                                                                                    temp204 := true.
                                                                                                                                                    temp202 value:iprot readI64
                                                                                                                                                ].
                                                                                                                                                temp204 ifNil:[ iprot skip:temp203 type ]
                                                                                                                                            ].
                                                                                                                                            iprot readStructEnd.
                                                                                                                                            temp202
                                                                                                                                        ] value
                                                                                                                            ].
                                                                                                                            iprot readListEnd.
                                                                                                                            temp201
                                                                                                                        ] value
                                                                                                            ].
                                                                                                            temp199 ifNil:[ iprot skip:temp198 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp197
                                                                                                    ] value
                                                                                        ].
                                                                                        temp182 ifNil:[ iprot skip:temp181 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp180
                                                                                ] value
                                                                    ].
                                                                    iprot readListEnd.
                                                                    temp179
                                                                ] value
                                                    ].
                                                    temp177 ifNil:[ iprot skip:temp176 type ]
                                                ].
                                                iprot readStructEnd.
                                                temp175
                                            ] value
                                ].
                                iprot readListEnd.
                                temp174
                            ] value
                ].
                temp171 id = 1 ifTrue:[
                    temp172 := true.
                    temp170 
                        exception:[
                                |temp206 temp205|

                                temp205 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp206 := iprot readFieldBegin.
                                    temp206 type = TTypeStop
                                ] whileFalse:[
                                    |temp207|

                                    temp206 id = 1 ifTrue:[
                                        temp207 := true.
                                        temp205 why:iprot readString
                                    ].
                                    temp207 ifNil:[ iprot skip:temp206 type ]
                                ].
                                iprot readStructEnd.
                                temp205
                            ] value
                ].
                temp171 id = 2 ifTrue:[
                    temp172 := true.
                    temp170 
                        exception:[
                                |temp209 temp208|

                                temp208 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp209 := iprot readFieldBegin.
                                    temp209 type = TTypeStop
                                ] whileFalse:[
                                    |temp210|

                                    temp210 ifNil:[ iprot skip:temp209 type ]
                                ].
                                iprot readStructEnd.
                                temp208
                            ] value
                ].
                temp171 id = 3 ifTrue:[
                    temp172 := true.
                    temp170 
                        exception:[
                                |temp212 temp211|

                                temp211 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp212 := iprot readFieldBegin.
                                    temp212 type = TTypeStop
                                ] whileFalse:[
                                    |temp213|

                                    temp213 ifNil:[ iprot skip:temp212 type ]
                                ].
                                iprot readStructEnd.
                                temp211
                            ] value
                ].
                temp172 ifNil:[ iprot skip:temp171 type ]
            ].
            iprot readStructEnd.
            temp170
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvGetSlice
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp59 temp58|

            temp58 := TResult new.
            iprot readStructBegin.
            [
                temp59 := iprot readFieldBegin.
                temp59 type = TTypeStop
            ] whileFalse:[
                |temp60|

                temp59 id = 0 ifTrue:[
                    temp60 := true.
                    temp58 
                        success:[
                                |temp61 temp62|

                                temp61 := iprot readListBegin.
                                temp62 := OrderedCollection new.
                                temp61 size timesRepeat:[
                                    temp62 
                                        add:[
                                                |temp64 temp63|

                                                temp63 := ColumnOrSuperColumn new.
                                                iprot readStructBegin.
                                                [
                                                    temp64 := iprot readFieldBegin.
                                                    temp64 type = TTypeStop
                                                ] whileFalse:[
                                                    |temp65|

                                                    temp64 id = 1 ifTrue:[
                                                        temp65 := true.
                                                        temp63 
                                                            column:[
                                                                    |temp67 temp66|

                                                                    temp66 := Column new.
                                                                    iprot readStructBegin.
                                                                    [
                                                                        temp67 := iprot readFieldBegin.
                                                                        temp67 type = TTypeStop
                                                                    ] whileFalse:[
                                                                        |temp68|

                                                                        temp67 id = 1 ifTrue:[
                                                                            temp68 := true.
                                                                            temp66 name:iprot readString
                                                                        ].
                                                                        temp67 id = 2 ifTrue:[
                                                                            temp68 := true.
                                                                            temp66 value:iprot readString
                                                                        ].
                                                                        temp67 id = 3 ifTrue:[
                                                                            temp68 := true.
                                                                            temp66 timestamp:iprot readI64
                                                                        ].
                                                                        temp67 id = 4 ifTrue:[
                                                                            temp68 := true.
                                                                            temp66 ttl:iprot readI32
                                                                        ].
                                                                        temp68 ifNil:[ iprot skip:temp67 type ]
                                                                    ].
                                                                    iprot readStructEnd.
                                                                    temp66
                                                                ] value
                                                    ].
                                                    temp64 id = 2 ifTrue:[
                                                        temp65 := true.
                                                        temp63 
                                                            superColumn:[
                                                                    |temp70 temp69|

                                                                    temp69 := SuperColumn new.
                                                                    iprot readStructBegin.
                                                                    [
                                                                        temp70 := iprot readFieldBegin.
                                                                        temp70 type = TTypeStop
                                                                    ] whileFalse:[
                                                                        |temp71|

                                                                        temp70 id = 1 ifTrue:[
                                                                            temp71 := true.
                                                                            temp69 name:iprot readString
                                                                        ].
                                                                        temp70 id = 2 ifTrue:[
                                                                            temp71 := true.
                                                                            temp69 
                                                                                columns:[
                                                                                        |temp72 temp73|

                                                                                        temp72 := iprot readListBegin.
                                                                                        temp73 := OrderedCollection new.
                                                                                        temp72 size timesRepeat:[
                                                                                            temp73 
                                                                                                add:[
                                                                                                        |temp75 temp74|

                                                                                                        temp74 := Column new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp75 := iprot readFieldBegin.
                                                                                                            temp75 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp76|

                                                                                                            temp75 id = 1 ifTrue:[
                                                                                                                temp76 := true.
                                                                                                                temp74 name:iprot readString
                                                                                                            ].
                                                                                                            temp75 id = 2 ifTrue:[
                                                                                                                temp76 := true.
                                                                                                                temp74 value:iprot readString
                                                                                                            ].
                                                                                                            temp75 id = 3 ifTrue:[
                                                                                                                temp76 := true.
                                                                                                                temp74 timestamp:iprot readI64
                                                                                                            ].
                                                                                                            temp75 id = 4 ifTrue:[
                                                                                                                temp76 := true.
                                                                                                                temp74 ttl:iprot readI32
                                                                                                            ].
                                                                                                            temp76 ifNil:[ iprot skip:temp75 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp74
                                                                                                    ] value
                                                                                        ].
                                                                                        iprot readListEnd.
                                                                                        temp73
                                                                                    ] value
                                                                        ].
                                                                        temp71 ifNil:[ iprot skip:temp70 type ]
                                                                    ].
                                                                    iprot readStructEnd.
                                                                    temp69
                                                                ] value
                                                    ].
                                                    temp64 id = 3 ifTrue:[
                                                        temp65 := true.
                                                        temp63 
                                                            counterColumn:[
                                                                    |temp78 temp77|

                                                                    temp77 := CounterColumn new.
                                                                    iprot readStructBegin.
                                                                    [
                                                                        temp78 := iprot readFieldBegin.
                                                                        temp78 type = TTypeStop
                                                                    ] whileFalse:[
                                                                        |temp79|

                                                                        temp78 id = 1 ifTrue:[
                                                                            temp79 := true.
                                                                            temp77 name:iprot readString
                                                                        ].
                                                                        temp78 id = 2 ifTrue:[
                                                                            temp79 := true.
                                                                            temp77 value:iprot readI64
                                                                        ].
                                                                        temp79 ifNil:[ iprot skip:temp78 type ]
                                                                    ].
                                                                    iprot readStructEnd.
                                                                    temp77
                                                                ] value
                                                    ].
                                                    temp64 id = 4 ifTrue:[
                                                        temp65 := true.
                                                        temp63 
                                                            counterSuperColumn:[
                                                                    |temp81 temp80|

                                                                    temp80 := CounterSuperColumn new.
                                                                    iprot readStructBegin.
                                                                    [
                                                                        temp81 := iprot readFieldBegin.
                                                                        temp81 type = TTypeStop
                                                                    ] whileFalse:[
                                                                        |temp82|

                                                                        temp81 id = 1 ifTrue:[
                                                                            temp82 := true.
                                                                            temp80 name:iprot readString
                                                                        ].
                                                                        temp81 id = 2 ifTrue:[
                                                                            temp82 := true.
                                                                            temp80 
                                                                                columns:[
                                                                                        |temp83 temp84|

                                                                                        temp83 := iprot readListBegin.
                                                                                        temp84 := OrderedCollection new.
                                                                                        temp83 size timesRepeat:[
                                                                                            temp84 
                                                                                                add:[
                                                                                                        |temp86 temp85|

                                                                                                        temp85 := CounterColumn new.
                                                                                                        iprot readStructBegin.
                                                                                                        [
                                                                                                            temp86 := iprot readFieldBegin.
                                                                                                            temp86 type = TTypeStop
                                                                                                        ] whileFalse:[
                                                                                                            |temp87|

                                                                                                            temp86 id = 1 ifTrue:[
                                                                                                                temp87 := true.
                                                                                                                temp85 name:iprot readString
                                                                                                            ].
                                                                                                            temp86 id = 2 ifTrue:[
                                                                                                                temp87 := true.
                                                                                                                temp85 value:iprot readI64
                                                                                                            ].
                                                                                                            temp87 ifNil:[ iprot skip:temp86 type ]
                                                                                                        ].
                                                                                                        iprot readStructEnd.
                                                                                                        temp85
                                                                                                    ] value
                                                                                        ].
                                                                                        iprot readListEnd.
                                                                                        temp84
                                                                                    ] value
                                                                        ].
                                                                        temp82 ifNil:[ iprot skip:temp81 type ]
                                                                    ].
                                                                    iprot readStructEnd.
                                                                    temp80
                                                                ] value
                                                    ].
                                                    temp65 ifNil:[ iprot skip:temp64 type ]
                                                ].
                                                iprot readStructEnd.
                                                temp63
                                            ] value
                                ].
                                iprot readListEnd.
                                temp62
                            ] value
                ].
                temp59 id = 1 ifTrue:[
                    temp60 := true.
                    temp58 
                        exception:[
                                |temp89 temp88|

                                temp88 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp89 := iprot readFieldBegin.
                                    temp89 type = TTypeStop
                                ] whileFalse:[
                                    |temp90|

                                    temp89 id = 1 ifTrue:[
                                        temp90 := true.
                                        temp88 why:iprot readString
                                    ].
                                    temp90 ifNil:[ iprot skip:temp89 type ]
                                ].
                                iprot readStructEnd.
                                temp88
                            ] value
                ].
                temp59 id = 2 ifTrue:[
                    temp60 := true.
                    temp58 
                        exception:[
                                |temp92 temp91|

                                temp91 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp92 := iprot readFieldBegin.
                                    temp92 type = TTypeStop
                                ] whileFalse:[
                                    |temp93|

                                    temp93 ifNil:[ iprot skip:temp92 type ]
                                ].
                                iprot readStructEnd.
                                temp91
                            ] value
                ].
                temp59 id = 3 ifTrue:[
                    temp60 := true.
                    temp58 
                        exception:[
                                |temp95 temp94|

                                temp94 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp95 := iprot readFieldBegin.
                                    temp95 type = TTypeStop
                                ] whileFalse:[
                                    |temp96|

                                    temp96 ifNil:[ iprot skip:temp95 type ]
                                ].
                                iprot readStructEnd.
                                temp94
                            ] value
                ].
                temp60 ifNil:[ iprot skip:temp59 type ]
            ].
            iprot readStructEnd.
            temp58
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvInsert
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp261 temp260|

            temp260 := TResult new.
            iprot readStructBegin.
            [
                temp261 := iprot readFieldBegin.
                temp261 type = TTypeStop
            ] whileFalse:[
                |temp262|

                temp261 id = 0 ifTrue:[
                    temp262 := true.
                    temp260 success:iprot readVoid
                ].
                temp261 id = 1 ifTrue:[
                    temp262 := true.
                    temp260 
                        exception:[
                                |temp264 temp263|

                                temp263 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp264 := iprot readFieldBegin.
                                    temp264 type = TTypeStop
                                ] whileFalse:[
                                    |temp265|

                                    temp264 id = 1 ifTrue:[
                                        temp265 := true.
                                        temp263 why:iprot readString
                                    ].
                                    temp265 ifNil:[ iprot skip:temp264 type ]
                                ].
                                iprot readStructEnd.
                                temp263
                            ] value
                ].
                temp261 id = 2 ifTrue:[
                    temp262 := true.
                    temp260 
                        exception:[
                                |temp267 temp266|

                                temp266 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp267 := iprot readFieldBegin.
                                    temp267 type = TTypeStop
                                ] whileFalse:[
                                    |temp268|

                                    temp268 ifNil:[ iprot skip:temp267 type ]
                                ].
                                iprot readStructEnd.
                                temp266
                            ] value
                ].
                temp261 id = 3 ifTrue:[
                    temp262 := true.
                    temp260 
                        exception:[
                                |temp270 temp269|

                                temp269 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp270 := iprot readFieldBegin.
                                    temp270 type = TTypeStop
                                ] whileFalse:[
                                    |temp271|

                                    temp271 ifNil:[ iprot skip:temp270 type ]
                                ].
                                iprot readStructEnd.
                                temp269
                            ] value
                ].
                temp262 ifNil:[ iprot skip:temp261 type ]
            ].
            iprot readStructEnd.
            temp260
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvLogin
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp3 temp2|

            temp2 := TResult new.
            iprot readStructBegin.
            [
                temp3 := iprot readFieldBegin.
                temp3 type = TTypeStop
            ] whileFalse:[
                |temp4|

                temp3 id = 0 ifTrue:[
                    temp4 := true.
                    temp2 success:iprot readVoid
                ].
                temp3 id = 1 ifTrue:[
                    temp4 := true.
                    temp2 
                        exception:[
                                |temp6 temp5|

                                temp5 := AuthenticationException new.
                                iprot readStructBegin.
                                [
                                    temp6 := iprot readFieldBegin.
                                    temp6 type = TTypeStop
                                ] whileFalse:[
                                    |temp7|

                                    temp6 id = 1 ifTrue:[
                                        temp7 := true.
                                        temp5 why:iprot readString
                                    ].
                                    temp7 ifNil:[ iprot skip:temp6 type ]
                                ].
                                iprot readStructEnd.
                                temp5
                            ] value
                ].
                temp3 id = 2 ifTrue:[
                    temp4 := true.
                    temp2 
                        exception:[
                                |temp9 temp8|

                                temp8 := AuthorizationException new.
                                iprot readStructBegin.
                                [
                                    temp9 := iprot readFieldBegin.
                                    temp9 type = TTypeStop
                                ] whileFalse:[
                                    |temp10|

                                    temp9 id = 1 ifTrue:[
                                        temp10 := true.
                                        temp8 why:iprot readString
                                    ].
                                    temp10 ifNil:[ iprot skip:temp9 type ]
                                ].
                                iprot readStructEnd.
                                temp8
                            ] value
                ].
                temp4 ifNil:[ iprot skip:temp3 type ]
            ].
            iprot readStructEnd.
            temp2
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvMultigetCount
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp156 temp155|

            temp155 := TResult new.
            iprot readStructBegin.
            [
                temp156 := iprot readFieldBegin.
                temp156 type = TTypeStop
            ] whileFalse:[
                |temp157|

                temp156 id = 0 ifTrue:[
                    temp157 := true.
                    temp155 
                        success:[
                                |temp158 temp159|

                                temp158 := iprot readMapBegin.
                                temp159 := Dictionary new.
                                temp158 size timesRepeat:[
                                    temp159 at:iprot readString put:iprot readI32
                                ].
                                iprot readMapEnd.
                                temp159
                            ] value
                ].
                temp156 id = 1 ifTrue:[
                    temp157 := true.
                    temp155 
                        exception:[
                                |temp161 temp160|

                                temp160 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp161 := iprot readFieldBegin.
                                    temp161 type = TTypeStop
                                ] whileFalse:[
                                    |temp162|

                                    temp161 id = 1 ifTrue:[
                                        temp162 := true.
                                        temp160 why:iprot readString
                                    ].
                                    temp162 ifNil:[ iprot skip:temp161 type ]
                                ].
                                iprot readStructEnd.
                                temp160
                            ] value
                ].
                temp156 id = 2 ifTrue:[
                    temp157 := true.
                    temp155 
                        exception:[
                                |temp164 temp163|

                                temp163 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp164 := iprot readFieldBegin.
                                    temp164 type = TTypeStop
                                ] whileFalse:[
                                    |temp165|

                                    temp165 ifNil:[ iprot skip:temp164 type ]
                                ].
                                iprot readStructEnd.
                                temp163
                            ] value
                ].
                temp156 id = 3 ifTrue:[
                    temp157 := true.
                    temp155 
                        exception:[
                                |temp167 temp166|

                                temp166 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp167 := iprot readFieldBegin.
                                    temp167 type = TTypeStop
                                ] whileFalse:[
                                    |temp168|

                                    temp168 ifNil:[ iprot skip:temp167 type ]
                                ].
                                iprot readStructEnd.
                                temp166
                            ] value
                ].
                temp157 ifNil:[ iprot skip:temp156 type ]
            ].
            iprot readStructEnd.
            temp155
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvMultigetSlice
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp113 temp112|

            temp112 := TResult new.
            iprot readStructBegin.
            [
                temp113 := iprot readFieldBegin.
                temp113 type = TTypeStop
            ] whileFalse:[
                |temp114|

                temp113 id = 0 ifTrue:[
                    temp114 := true.
                    temp112 
                        success:[
                                |temp115 temp116|

                                temp115 := iprot readMapBegin.
                                temp116 := Dictionary new.
                                temp115 size timesRepeat:[
                                    temp116 at:iprot readString
                                        put:[
                                                |temp117 temp118|

                                                temp117 := iprot readListBegin.
                                                temp118 := OrderedCollection new.
                                                temp117 size timesRepeat:[
                                                    temp118 
                                                        add:[
                                                                |temp120 temp119|

                                                                temp119 := ColumnOrSuperColumn new.
                                                                iprot readStructBegin.
                                                                [
                                                                    temp120 := iprot readFieldBegin.
                                                                    temp120 type = TTypeStop
                                                                ] whileFalse:[
                                                                    |temp121|

                                                                    temp120 id = 1 ifTrue:[
                                                                        temp121 := true.
                                                                        temp119 
                                                                            column:[
                                                                                    |temp123 temp122|

                                                                                    temp122 := Column new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp123 := iprot readFieldBegin.
                                                                                        temp123 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp124|

                                                                                        temp123 id = 1 ifTrue:[
                                                                                            temp124 := true.
                                                                                            temp122 name:iprot readString
                                                                                        ].
                                                                                        temp123 id = 2 ifTrue:[
                                                                                            temp124 := true.
                                                                                            temp122 value:iprot readString
                                                                                        ].
                                                                                        temp123 id = 3 ifTrue:[
                                                                                            temp124 := true.
                                                                                            temp122 timestamp:iprot readI64
                                                                                        ].
                                                                                        temp123 id = 4 ifTrue:[
                                                                                            temp124 := true.
                                                                                            temp122 ttl:iprot readI32
                                                                                        ].
                                                                                        temp124 ifNil:[ iprot skip:temp123 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp122
                                                                                ] value
                                                                    ].
                                                                    temp120 id = 2 ifTrue:[
                                                                        temp121 := true.
                                                                        temp119 
                                                                            superColumn:[
                                                                                    |temp126 temp125|

                                                                                    temp125 := SuperColumn new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp126 := iprot readFieldBegin.
                                                                                        temp126 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp127|

                                                                                        temp126 id = 1 ifTrue:[
                                                                                            temp127 := true.
                                                                                            temp125 name:iprot readString
                                                                                        ].
                                                                                        temp126 id = 2 ifTrue:[
                                                                                            temp127 := true.
                                                                                            temp125 
                                                                                                columns:[
                                                                                                        |temp128 temp129|

                                                                                                        temp128 := iprot readListBegin.
                                                                                                        temp129 := OrderedCollection new.
                                                                                                        temp128 size timesRepeat:[
                                                                                                            temp129 
                                                                                                                add:[
                                                                                                                        |temp131 temp130|

                                                                                                                        temp130 := Column new.
                                                                                                                        iprot readStructBegin.
                                                                                                                        [
                                                                                                                            temp131 := iprot readFieldBegin.
                                                                                                                            temp131 type = TTypeStop
                                                                                                                        ] whileFalse:[
                                                                                                                            |temp132|

                                                                                                                            temp131 id = 1 ifTrue:[
                                                                                                                                temp132 := true.
                                                                                                                                temp130 name:iprot readString
                                                                                                                            ].
                                                                                                                            temp131 id = 2 ifTrue:[
                                                                                                                                temp132 := true.
                                                                                                                                temp130 value:iprot readString
                                                                                                                            ].
                                                                                                                            temp131 id = 3 ifTrue:[
                                                                                                                                temp132 := true.
                                                                                                                                temp130 timestamp:iprot readI64
                                                                                                                            ].
                                                                                                                            temp131 id = 4 ifTrue:[
                                                                                                                                temp132 := true.
                                                                                                                                temp130 ttl:iprot readI32
                                                                                                                            ].
                                                                                                                            temp132 ifNil:[ iprot skip:temp131 type ]
                                                                                                                        ].
                                                                                                                        iprot readStructEnd.
                                                                                                                        temp130
                                                                                                                    ] value
                                                                                                        ].
                                                                                                        iprot readListEnd.
                                                                                                        temp129
                                                                                                    ] value
                                                                                        ].
                                                                                        temp127 ifNil:[ iprot skip:temp126 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp125
                                                                                ] value
                                                                    ].
                                                                    temp120 id = 3 ifTrue:[
                                                                        temp121 := true.
                                                                        temp119 
                                                                            counterColumn:[
                                                                                    |temp134 temp133|

                                                                                    temp133 := CounterColumn new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp134 := iprot readFieldBegin.
                                                                                        temp134 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp135|

                                                                                        temp134 id = 1 ifTrue:[
                                                                                            temp135 := true.
                                                                                            temp133 name:iprot readString
                                                                                        ].
                                                                                        temp134 id = 2 ifTrue:[
                                                                                            temp135 := true.
                                                                                            temp133 value:iprot readI64
                                                                                        ].
                                                                                        temp135 ifNil:[ iprot skip:temp134 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp133
                                                                                ] value
                                                                    ].
                                                                    temp120 id = 4 ifTrue:[
                                                                        temp121 := true.
                                                                        temp119 
                                                                            counterSuperColumn:[
                                                                                    |temp137 temp136|

                                                                                    temp136 := CounterSuperColumn new.
                                                                                    iprot readStructBegin.
                                                                                    [
                                                                                        temp137 := iprot readFieldBegin.
                                                                                        temp137 type = TTypeStop
                                                                                    ] whileFalse:[
                                                                                        |temp138|

                                                                                        temp137 id = 1 ifTrue:[
                                                                                            temp138 := true.
                                                                                            temp136 name:iprot readString
                                                                                        ].
                                                                                        temp137 id = 2 ifTrue:[
                                                                                            temp138 := true.
                                                                                            temp136 
                                                                                                columns:[
                                                                                                        |temp139 temp140|

                                                                                                        temp139 := iprot readListBegin.
                                                                                                        temp140 := OrderedCollection new.
                                                                                                        temp139 size timesRepeat:[
                                                                                                            temp140 
                                                                                                                add:[
                                                                                                                        |temp142 temp141|

                                                                                                                        temp141 := CounterColumn new.
                                                                                                                        iprot readStructBegin.
                                                                                                                        [
                                                                                                                            temp142 := iprot readFieldBegin.
                                                                                                                            temp142 type = TTypeStop
                                                                                                                        ] whileFalse:[
                                                                                                                            |temp143|

                                                                                                                            temp142 id = 1 ifTrue:[
                                                                                                                                temp143 := true.
                                                                                                                                temp141 name:iprot readString
                                                                                                                            ].
                                                                                                                            temp142 id = 2 ifTrue:[
                                                                                                                                temp143 := true.
                                                                                                                                temp141 value:iprot readI64
                                                                                                                            ].
                                                                                                                            temp143 ifNil:[ iprot skip:temp142 type ]
                                                                                                                        ].
                                                                                                                        iprot readStructEnd.
                                                                                                                        temp141
                                                                                                                    ] value
                                                                                                        ].
                                                                                                        iprot readListEnd.
                                                                                                        temp140
                                                                                                    ] value
                                                                                        ].
                                                                                        temp138 ifNil:[ iprot skip:temp137 type ]
                                                                                    ].
                                                                                    iprot readStructEnd.
                                                                                    temp136
                                                                                ] value
                                                                    ].
                                                                    temp121 ifNil:[ iprot skip:temp120 type ]
                                                                ].
                                                                iprot readStructEnd.
                                                                temp119
                                                            ] value
                                                ].
                                                iprot readListEnd.
                                                temp118
                                            ] value
                                ].
                                iprot readMapEnd.
                                temp116
                            ] value
                ].
                temp113 id = 1 ifTrue:[
                    temp114 := true.
                    temp112 
                        exception:[
                                |temp145 temp144|

                                temp144 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp145 := iprot readFieldBegin.
                                    temp145 type = TTypeStop
                                ] whileFalse:[
                                    |temp146|

                                    temp145 id = 1 ifTrue:[
                                        temp146 := true.
                                        temp144 why:iprot readString
                                    ].
                                    temp146 ifNil:[ iprot skip:temp145 type ]
                                ].
                                iprot readStructEnd.
                                temp144
                            ] value
                ].
                temp113 id = 2 ifTrue:[
                    temp114 := true.
                    temp112 
                        exception:[
                                |temp148 temp147|

                                temp147 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp148 := iprot readFieldBegin.
                                    temp148 type = TTypeStop
                                ] whileFalse:[
                                    |temp149|

                                    temp149 ifNil:[ iprot skip:temp148 type ]
                                ].
                                iprot readStructEnd.
                                temp147
                            ] value
                ].
                temp113 id = 3 ifTrue:[
                    temp114 := true.
                    temp112 
                        exception:[
                                |temp151 temp150|

                                temp150 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp151 := iprot readFieldBegin.
                                    temp151 type = TTypeStop
                                ] whileFalse:[
                                    |temp152|

                                    temp152 ifNil:[ iprot skip:temp151 type ]
                                ].
                                iprot readStructEnd.
                                temp150
                            ] value
                ].
                temp114 ifNil:[ iprot skip:temp113 type ]
            ].
            iprot readStructEnd.
            temp112
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvPrepareCqlQuery
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp573 temp572|

            temp572 := TResult new.
            iprot readStructBegin.
            [
                temp573 := iprot readFieldBegin.
                temp573 type = TTypeStop
            ] whileFalse:[
                |temp574|

                temp573 id = 0 ifTrue:[
                    temp574 := true.
                    temp572 
                        success:[
                                |temp576 temp575|

                                temp575 := CqlPreparedResult new.
                                iprot readStructBegin.
                                [
                                    temp576 := iprot readFieldBegin.
                                    temp576 type = TTypeStop
                                ] whileFalse:[
                                    |temp577|

                                    temp576 id = 1 ifTrue:[
                                        temp577 := true.
                                        temp575 itemId:iprot readI32
                                    ].
                                    temp576 id = 2 ifTrue:[
                                        temp577 := true.
                                        temp575 count:iprot readI32
                                    ].
                                    temp577 ifNil:[ iprot skip:temp576 type ]
                                ].
                                iprot readStructEnd.
                                temp575
                            ] value
                ].
                temp573 id = 1 ifTrue:[
                    temp574 := true.
                    temp572 
                        exception:[
                                |temp579 temp578|

                                temp578 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp579 := iprot readFieldBegin.
                                    temp579 type = TTypeStop
                                ] whileFalse:[
                                    |temp580|

                                    temp579 id = 1 ifTrue:[
                                        temp580 := true.
                                        temp578 why:iprot readString
                                    ].
                                    temp580 ifNil:[ iprot skip:temp579 type ]
                                ].
                                iprot readStructEnd.
                                temp578
                            ] value
                ].
                temp574 ifNil:[ iprot skip:temp573 type ]
            ].
            iprot readStructEnd.
            temp572
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvRemove
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp285 temp284|

            temp284 := TResult new.
            iprot readStructBegin.
            [
                temp285 := iprot readFieldBegin.
                temp285 type = TTypeStop
            ] whileFalse:[
                |temp286|

                temp285 id = 0 ifTrue:[
                    temp286 := true.
                    temp284 success:iprot readVoid
                ].
                temp285 id = 1 ifTrue:[
                    temp286 := true.
                    temp284 
                        exception:[
                                |temp288 temp287|

                                temp287 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp288 := iprot readFieldBegin.
                                    temp288 type = TTypeStop
                                ] whileFalse:[
                                    |temp289|

                                    temp288 id = 1 ifTrue:[
                                        temp289 := true.
                                        temp287 why:iprot readString
                                    ].
                                    temp289 ifNil:[ iprot skip:temp288 type ]
                                ].
                                iprot readStructEnd.
                                temp287
                            ] value
                ].
                temp285 id = 2 ifTrue:[
                    temp286 := true.
                    temp284 
                        exception:[
                                |temp291 temp290|

                                temp290 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp291 := iprot readFieldBegin.
                                    temp291 type = TTypeStop
                                ] whileFalse:[
                                    |temp292|

                                    temp292 ifNil:[ iprot skip:temp291 type ]
                                ].
                                iprot readStructEnd.
                                temp290
                            ] value
                ].
                temp285 id = 3 ifTrue:[
                    temp286 := true.
                    temp284 
                        exception:[
                                |temp294 temp293|

                                temp293 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp294 := iprot readFieldBegin.
                                    temp294 type = TTypeStop
                                ] whileFalse:[
                                    |temp295|

                                    temp295 ifNil:[ iprot skip:temp294 type ]
                                ].
                                iprot readStructEnd.
                                temp293
                            ] value
                ].
                temp286 ifNil:[ iprot skip:temp285 type ]
            ].
            iprot readStructEnd.
            temp284
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvRemoveCounter
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp297 temp296|

            temp296 := TResult new.
            iprot readStructBegin.
            [
                temp297 := iprot readFieldBegin.
                temp297 type = TTypeStop
            ] whileFalse:[
                |temp298|

                temp297 id = 0 ifTrue:[
                    temp298 := true.
                    temp296 success:iprot readVoid
                ].
                temp297 id = 1 ifTrue:[
                    temp298 := true.
                    temp296 
                        exception:[
                                |temp300 temp299|

                                temp299 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp300 := iprot readFieldBegin.
                                    temp300 type = TTypeStop
                                ] whileFalse:[
                                    |temp301|

                                    temp300 id = 1 ifTrue:[
                                        temp301 := true.
                                        temp299 why:iprot readString
                                    ].
                                    temp301 ifNil:[ iprot skip:temp300 type ]
                                ].
                                iprot readStructEnd.
                                temp299
                            ] value
                ].
                temp297 id = 2 ifTrue:[
                    temp298 := true.
                    temp296 
                        exception:[
                                |temp303 temp302|

                                temp302 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp303 := iprot readFieldBegin.
                                    temp303 type = TTypeStop
                                ] whileFalse:[
                                    |temp304|

                                    temp304 ifNil:[ iprot skip:temp303 type ]
                                ].
                                iprot readStructEnd.
                                temp302
                            ] value
                ].
                temp297 id = 3 ifTrue:[
                    temp298 := true.
                    temp296 
                        exception:[
                                |temp306 temp305|

                                temp305 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp306 := iprot readFieldBegin.
                                    temp306 type = TTypeStop
                                ] whileFalse:[
                                    |temp307|

                                    temp307 ifNil:[ iprot skip:temp306 type ]
                                ].
                                iprot readStructEnd.
                                temp305
                            ] value
                ].
                temp298 ifNil:[ iprot skip:temp297 type ]
            ].
            iprot readStructEnd.
            temp296
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvSetKeyspace
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp12 temp11|

            temp11 := TResult new.
            iprot readStructBegin.
            [
                temp12 := iprot readFieldBegin.
                temp12 type = TTypeStop
            ] whileFalse:[
                |temp13|

                temp12 id = 0 ifTrue:[
                    temp13 := true.
                    temp11 success:iprot readVoid
                ].
                temp12 id = 1 ifTrue:[
                    temp13 := true.
                    temp11 
                        exception:[
                                |temp15 temp14|

                                temp14 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp15 := iprot readFieldBegin.
                                    temp15 type = TTypeStop
                                ] whileFalse:[
                                    |temp16|

                                    temp15 id = 1 ifTrue:[
                                        temp16 := true.
                                        temp14 why:iprot readString
                                    ].
                                    temp16 ifNil:[ iprot skip:temp15 type ]
                                ].
                                iprot readStructEnd.
                                temp14
                            ] value
                ].
                temp13 ifNil:[ iprot skip:temp12 type ]
            ].
            iprot readStructEnd.
            temp11
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvSystemAddColumnFamily
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp457 temp456|

            temp456 := TResult new.
            iprot readStructBegin.
            [
                temp457 := iprot readFieldBegin.
                temp457 type = TTypeStop
            ] whileFalse:[
                |temp458|

                temp457 id = 0 ifTrue:[
                    temp458 := true.
                    temp456 success:iprot readString
                ].
                temp457 id = 1 ifTrue:[
                    temp458 := true.
                    temp456 
                        exception:[
                                |temp460 temp459|

                                temp459 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp460 := iprot readFieldBegin.
                                    temp460 type = TTypeStop
                                ] whileFalse:[
                                    |temp461|

                                    temp460 id = 1 ifTrue:[
                                        temp461 := true.
                                        temp459 why:iprot readString
                                    ].
                                    temp461 ifNil:[ iprot skip:temp460 type ]
                                ].
                                iprot readStructEnd.
                                temp459
                            ] value
                ].
                temp457 id = 2 ifTrue:[
                    temp458 := true.
                    temp456 
                        exception:[
                                |temp463 temp462|

                                temp462 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp463 := iprot readFieldBegin.
                                    temp463 type = TTypeStop
                                ] whileFalse:[
                                    |temp464|

                                    temp464 ifNil:[ iprot skip:temp463 type ]
                                ].
                                iprot readStructEnd.
                                temp462
                            ] value
                ].
                temp458 ifNil:[ iprot skip:temp457 type ]
            ].
            iprot readStructEnd.
            temp456
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvSystemAddKeyspace
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp485 temp484|

            temp484 := TResult new.
            iprot readStructBegin.
            [
                temp485 := iprot readFieldBegin.
                temp485 type = TTypeStop
            ] whileFalse:[
                |temp486|

                temp485 id = 0 ifTrue:[
                    temp486 := true.
                    temp484 success:iprot readString
                ].
                temp485 id = 1 ifTrue:[
                    temp486 := true.
                    temp484 
                        exception:[
                                |temp488 temp487|

                                temp487 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp488 := iprot readFieldBegin.
                                    temp488 type = TTypeStop
                                ] whileFalse:[
                                    |temp489|

                                    temp488 id = 1 ifTrue:[
                                        temp489 := true.
                                        temp487 why:iprot readString
                                    ].
                                    temp489 ifNil:[ iprot skip:temp488 type ]
                                ].
                                iprot readStructEnd.
                                temp487
                            ] value
                ].
                temp485 id = 2 ifTrue:[
                    temp486 := true.
                    temp484 
                        exception:[
                                |temp491 temp490|

                                temp490 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp491 := iprot readFieldBegin.
                                    temp491 type = TTypeStop
                                ] whileFalse:[
                                    |temp492|

                                    temp492 ifNil:[ iprot skip:temp491 type ]
                                ].
                                iprot readStructEnd.
                                temp490
                            ] value
                ].
                temp486 ifNil:[ iprot skip:temp485 type ]
            ].
            iprot readStructEnd.
            temp484
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvSystemDropColumnFamily
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp466 temp465|

            temp465 := TResult new.
            iprot readStructBegin.
            [
                temp466 := iprot readFieldBegin.
                temp466 type = TTypeStop
            ] whileFalse:[
                |temp467|

                temp466 id = 0 ifTrue:[
                    temp467 := true.
                    temp465 success:iprot readString
                ].
                temp466 id = 1 ifTrue:[
                    temp467 := true.
                    temp465 
                        exception:[
                                |temp469 temp468|

                                temp468 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp469 := iprot readFieldBegin.
                                    temp469 type = TTypeStop
                                ] whileFalse:[
                                    |temp470|

                                    temp469 id = 1 ifTrue:[
                                        temp470 := true.
                                        temp468 why:iprot readString
                                    ].
                                    temp470 ifNil:[ iprot skip:temp469 type ]
                                ].
                                iprot readStructEnd.
                                temp468
                            ] value
                ].
                temp466 id = 2 ifTrue:[
                    temp467 := true.
                    temp465 
                        exception:[
                                |temp472 temp471|

                                temp471 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp472 := iprot readFieldBegin.
                                    temp472 type = TTypeStop
                                ] whileFalse:[
                                    |temp473|

                                    temp473 ifNil:[ iprot skip:temp472 type ]
                                ].
                                iprot readStructEnd.
                                temp471
                            ] value
                ].
                temp467 ifNil:[ iprot skip:temp466 type ]
            ].
            iprot readStructEnd.
            temp465
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvSystemDropKeyspace
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp494 temp493|

            temp493 := TResult new.
            iprot readStructBegin.
            [
                temp494 := iprot readFieldBegin.
                temp494 type = TTypeStop
            ] whileFalse:[
                |temp495|

                temp494 id = 0 ifTrue:[
                    temp495 := true.
                    temp493 success:iprot readString
                ].
                temp494 id = 1 ifTrue:[
                    temp495 := true.
                    temp493 
                        exception:[
                                |temp497 temp496|

                                temp496 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp497 := iprot readFieldBegin.
                                    temp497 type = TTypeStop
                                ] whileFalse:[
                                    |temp498|

                                    temp497 id = 1 ifTrue:[
                                        temp498 := true.
                                        temp496 why:iprot readString
                                    ].
                                    temp498 ifNil:[ iprot skip:temp497 type ]
                                ].
                                iprot readStructEnd.
                                temp496
                            ] value
                ].
                temp494 id = 2 ifTrue:[
                    temp495 := true.
                    temp493 
                        exception:[
                                |temp500 temp499|

                                temp499 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp500 := iprot readFieldBegin.
                                    temp500 type = TTypeStop
                                ] whileFalse:[
                                    |temp501|

                                    temp501 ifNil:[ iprot skip:temp500 type ]
                                ].
                                iprot readStructEnd.
                                temp499
                            ] value
                ].
                temp495 ifNil:[ iprot skip:temp494 type ]
            ].
            iprot readStructEnd.
            temp493
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvSystemUpdateColumnFamily
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp529 temp528|

            temp528 := TResult new.
            iprot readStructBegin.
            [
                temp529 := iprot readFieldBegin.
                temp529 type = TTypeStop
            ] whileFalse:[
                |temp530|

                temp529 id = 0 ifTrue:[
                    temp530 := true.
                    temp528 success:iprot readString
                ].
                temp529 id = 1 ifTrue:[
                    temp530 := true.
                    temp528 
                        exception:[
                                |temp532 temp531|

                                temp531 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp532 := iprot readFieldBegin.
                                    temp532 type = TTypeStop
                                ] whileFalse:[
                                    |temp533|

                                    temp532 id = 1 ifTrue:[
                                        temp533 := true.
                                        temp531 why:iprot readString
                                    ].
                                    temp533 ifNil:[ iprot skip:temp532 type ]
                                ].
                                iprot readStructEnd.
                                temp531
                            ] value
                ].
                temp529 id = 2 ifTrue:[
                    temp530 := true.
                    temp528 
                        exception:[
                                |temp535 temp534|

                                temp534 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp535 := iprot readFieldBegin.
                                    temp535 type = TTypeStop
                                ] whileFalse:[
                                    |temp536|

                                    temp536 ifNil:[ iprot skip:temp535 type ]
                                ].
                                iprot readStructEnd.
                                temp534
                            ] value
                ].
                temp530 ifNil:[ iprot skip:temp529 type ]
            ].
            iprot readStructEnd.
            temp528
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvSystemUpdateKeyspace
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp513 temp512|

            temp512 := TResult new.
            iprot readStructBegin.
            [
                temp513 := iprot readFieldBegin.
                temp513 type = TTypeStop
            ] whileFalse:[
                |temp514|

                temp513 id = 0 ifTrue:[
                    temp514 := true.
                    temp512 success:iprot readString
                ].
                temp513 id = 1 ifTrue:[
                    temp514 := true.
                    temp512 
                        exception:[
                                |temp516 temp515|

                                temp515 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp516 := iprot readFieldBegin.
                                    temp516 type = TTypeStop
                                ] whileFalse:[
                                    |temp517|

                                    temp516 id = 1 ifTrue:[
                                        temp517 := true.
                                        temp515 why:iprot readString
                                    ].
                                    temp517 ifNil:[ iprot skip:temp516 type ]
                                ].
                                iprot readStructEnd.
                                temp515
                            ] value
                ].
                temp513 id = 2 ifTrue:[
                    temp514 := true.
                    temp512 
                        exception:[
                                |temp519 temp518|

                                temp518 := SchemaDisagreementException new.
                                iprot readStructBegin.
                                [
                                    temp519 := iprot readFieldBegin.
                                    temp519 type = TTypeStop
                                ] whileFalse:[
                                    |temp520|

                                    temp520 ifNil:[ iprot skip:temp519 type ]
                                ].
                                iprot readStructEnd.
                                temp518
                            ] value
                ].
                temp514 ifNil:[ iprot skip:temp513 type ]
            ].
            iprot readStructEnd.
            temp512
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
!

recvTruncate
    |f msg res|

    msg := iprot readMessageBegin.
    self validateRemoteMessage:msg.
    res := [
            |temp329 temp328|

            temp328 := TResult new.
            iprot readStructBegin.
            [
                temp329 := iprot readFieldBegin.
                temp329 type = TTypeStop
            ] whileFalse:[
                |temp330|

                temp329 id = 0 ifTrue:[
                    temp330 := true.
                    temp328 success:iprot readVoid
                ].
                temp329 id = 1 ifTrue:[
                    temp330 := true.
                    temp328 
                        exception:[
                                |temp332 temp331|

                                temp331 := InvalidRequestException new.
                                iprot readStructBegin.
                                [
                                    temp332 := iprot readFieldBegin.
                                    temp332 type = TTypeStop
                                ] whileFalse:[
                                    |temp333|

                                    temp332 id = 1 ifTrue:[
                                        temp333 := true.
                                        temp331 why:iprot readString
                                    ].
                                    temp333 ifNil:[ iprot skip:temp332 type ]
                                ].
                                iprot readStructEnd.
                                temp331
                            ] value
                ].
                temp329 id = 2 ifTrue:[
                    temp330 := true.
                    temp328 
                        exception:[
                                |temp335 temp334|

                                temp334 := UnavailableException new.
                                iprot readStructBegin.
                                [
                                    temp335 := iprot readFieldBegin.
                                    temp335 type = TTypeStop
                                ] whileFalse:[
                                    |temp336|

                                    temp336 ifNil:[ iprot skip:temp335 type ]
                                ].
                                iprot readStructEnd.
                                temp334
                            ] value
                ].
                temp329 id = 3 ifTrue:[
                    temp330 := true.
                    temp328 
                        exception:[
                                |temp338 temp337|

                                temp337 := TimedOutException new.
                                iprot readStructBegin.
                                [
                                    temp338 := iprot readFieldBegin.
                                    temp338 type = TTypeStop
                                ] whileFalse:[
                                    |temp339|

                                    temp339 ifNil:[ iprot skip:temp338 type ]
                                ].
                                iprot readStructEnd.
                                temp337
                            ] value
                ].
                temp330 ifNil:[ iprot skip:temp329 type ]
            ].
            iprot readStructEnd.
            temp328
        ] value.
    iprot readMessageEnd.
    nil.
    res exception ifNotNil:[ res exception raiseSignal ].
    ^ res
! !

!CassandraClient methodsFor:'private-send'!

sendAddKey:key columnParent:columnParent column:column consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'add';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'Add_args').
    oprot writeFieldBegin:((TField new)
                name:'key';
                type:TTypeString;
                id:1).
    iprot writeString:key.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'column';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'CounterColumn').
        oprot writeFieldBegin:((TField new)
                    name:'name';
                    type:TTypeString;
                    id:1).
        iprot writeString:column name.
        oprot writeFieldEnd.
        oprot writeFieldBegin:((TField new)
                    name:'value';
                    type:TTypeI64;
                    id:2).
        iprot writeI64:column value asInteger.
        oprot writeFieldEnd.
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendBatchMutateMutationMap:mutationMap consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'batch_mutate';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'BatchMutate_args').
    oprot writeFieldBegin:((TField new)
                name:'mutationMap';
                type:TTypeMap;
                id:1).
    [
        oprot writeMapBegin:((TMap new)
                    keyType:TTypeString;
                    valueType:TTypeMap;
                    size:mutationMap size).
        mutationMap 
            keysAndValuesDo:[:temp308 :temp309 | 
                iprot writeString:temp308.
                [
                    oprot writeMapBegin:((TMap new)
                                keyType:TTypeString;
                                valueType:TTypeList;
                                size:temp309 size).
                    temp309 
                        keysAndValuesDo:[:temp310 :temp311 | 
                            iprot writeString:temp310.
                            [
                                oprot writeListBegin:((TList new)
                                            elemType:TTypeStruct;
                                            size:temp311 size).
                                temp311 do:[:temp312 | 
                                    [
                                        oprot writeStructBegin:(TStruct new name:'Mutation').
                                        temp312 columnOrSupercolumn 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'columnOrSupercolumn';
                                                            type:TTypeStruct;
                                                            id:1).
                                                [
                                                    oprot writeStructBegin:(TStruct new name:'ColumnOrSuperColumn').
                                                    temp312 columnOrSupercolumn column 
                                                        ifNotNil:[
                                                            oprot writeFieldBegin:((TField new)
                                                                        name:'column';
                                                                        type:TTypeStruct;
                                                                        id:1).
                                                            [
                                                                oprot writeStructBegin:(TStruct new name:'Column').
                                                                oprot writeFieldBegin:((TField new)
                                                                            name:'name';
                                                                            type:TTypeString;
                                                                            id:1).
                                                                iprot writeString:temp312 columnOrSupercolumn column name.
                                                                oprot writeFieldEnd.
                                                                temp312 columnOrSupercolumn column value 
                                                                    ifNotNil:[
                                                                        oprot writeFieldBegin:((TField new)
                                                                                    name:'value';
                                                                                    type:TTypeString;
                                                                                    id:2).
                                                                        iprot writeString:temp312 columnOrSupercolumn column value.
                                                                        oprot writeFieldEnd
                                                                    ].
                                                                temp312 columnOrSupercolumn column timestamp 
                                                                    ifNotNil:[
                                                                        oprot writeFieldBegin:((TField new)
                                                                                    name:'timestamp';
                                                                                    type:TTypeI64;
                                                                                    id:3).
                                                                        iprot writeI64:temp312 columnOrSupercolumn column timestamp asInteger.
                                                                        oprot writeFieldEnd
                                                                    ].
                                                                temp312 columnOrSupercolumn column ttl 
                                                                    ifNotNil:[
                                                                        oprot writeFieldBegin:((TField new)
                                                                                    name:'ttl';
                                                                                    type:TTypeI32;
                                                                                    id:4).
                                                                        iprot writeI32:temp312 columnOrSupercolumn column ttl asInteger.
                                                                        oprot writeFieldEnd
                                                                    ].
                                                                oprot
                                                                    writeFieldStop;
                                                                    writeStructEnd
                                                            ] value.
                                                            oprot writeFieldEnd
                                                        ].
                                                    temp312 columnOrSupercolumn superColumn 
                                                        ifNotNil:[
                                                            oprot writeFieldBegin:((TField new)
                                                                        name:'superColumn';
                                                                        type:TTypeStruct;
                                                                        id:2).
                                                            [
                                                                oprot writeStructBegin:(TStruct new name:'SuperColumn').
                                                                oprot writeFieldBegin:((TField new)
                                                                            name:'name';
                                                                            type:TTypeString;
                                                                            id:1).
                                                                iprot writeString:temp312 columnOrSupercolumn superColumn name.
                                                                oprot writeFieldEnd.
                                                                oprot writeFieldBegin:((TField new)
                                                                            name:'columns';
                                                                            type:TTypeList;
                                                                            id:2).
                                                                [
                                                                    oprot writeListBegin:((TList new)
                                                                                elemType:TTypeStruct;
                                                                                size:temp312 columnOrSupercolumn superColumn columns size).
                                                                    temp312 columnOrSupercolumn superColumn columns do:[:temp313 | 
                                                                        [
                                                                            oprot writeStructBegin:(TStruct new name:'Column').
                                                                            oprot writeFieldBegin:((TField new)
                                                                                        name:'name';
                                                                                        type:TTypeString;
                                                                                        id:1).
                                                                            iprot writeString:temp313 name.
                                                                            oprot writeFieldEnd.
                                                                            temp313 value 
                                                                                ifNotNil:[
                                                                                    oprot writeFieldBegin:((TField new)
                                                                                                name:'value';
                                                                                                type:TTypeString;
                                                                                                id:2).
                                                                                    iprot writeString:temp313 value.
                                                                                    oprot writeFieldEnd
                                                                                ].
                                                                            temp313 timestamp 
                                                                                ifNotNil:[
                                                                                    oprot writeFieldBegin:((TField new)
                                                                                                name:'timestamp';
                                                                                                type:TTypeI64;
                                                                                                id:3).
                                                                                    iprot writeI64:temp313 timestamp asInteger.
                                                                                    oprot writeFieldEnd
                                                                                ].
                                                                            temp313 ttl 
                                                                                ifNotNil:[
                                                                                    oprot writeFieldBegin:((TField new)
                                                                                                name:'ttl';
                                                                                                type:TTypeI32;
                                                                                                id:4).
                                                                                    iprot writeI32:temp313 ttl asInteger.
                                                                                    oprot writeFieldEnd
                                                                                ].
                                                                            oprot
                                                                                writeFieldStop;
                                                                                writeStructEnd
                                                                        ] value
                                                                    ].
                                                                    oprot writeListEnd
                                                                ] value.
                                                                oprot writeFieldEnd.
                                                                oprot
                                                                    writeFieldStop;
                                                                    writeStructEnd
                                                            ] value.
                                                            oprot writeFieldEnd
                                                        ].
                                                    temp312 columnOrSupercolumn counterColumn 
                                                        ifNotNil:[
                                                            oprot writeFieldBegin:((TField new)
                                                                        name:'counterColumn';
                                                                        type:TTypeStruct;
                                                                        id:3).
                                                            [
                                                                oprot writeStructBegin:(TStruct new name:'CounterColumn').
                                                                oprot writeFieldBegin:((TField new)
                                                                            name:'name';
                                                                            type:TTypeString;
                                                                            id:1).
                                                                iprot writeString:temp312 columnOrSupercolumn counterColumn name.
                                                                oprot writeFieldEnd.
                                                                oprot writeFieldBegin:((TField new)
                                                                            name:'value';
                                                                            type:TTypeI64;
                                                                            id:2).
                                                                iprot writeI64:temp312 columnOrSupercolumn counterColumn value asInteger.
                                                                oprot writeFieldEnd.
                                                                oprot
                                                                    writeFieldStop;
                                                                    writeStructEnd
                                                            ] value.
                                                            oprot writeFieldEnd
                                                        ].
                                                    temp312 columnOrSupercolumn counterSuperColumn 
                                                        ifNotNil:[
                                                            oprot writeFieldBegin:((TField new)
                                                                        name:'counterSuperColumn';
                                                                        type:TTypeStruct;
                                                                        id:4).
                                                            [
                                                                oprot writeStructBegin:(TStruct new name:'CounterSuperColumn').
                                                                oprot writeFieldBegin:((TField new)
                                                                            name:'name';
                                                                            type:TTypeString;
                                                                            id:1).
                                                                iprot writeString:temp312 columnOrSupercolumn counterSuperColumn name.
                                                                oprot writeFieldEnd.
                                                                oprot writeFieldBegin:((TField new)
                                                                            name:'columns';
                                                                            type:TTypeList;
                                                                            id:2).
                                                                [
                                                                    oprot writeListBegin:((TList new)
                                                                                elemType:TTypeStruct;
                                                                                size:temp312 columnOrSupercolumn counterSuperColumn columns size).
                                                                    temp312 columnOrSupercolumn counterSuperColumn columns do:[:temp314 | 
                                                                        [
                                                                            oprot writeStructBegin:(TStruct new name:'CounterColumn').
                                                                            oprot writeFieldBegin:((TField new)
                                                                                        name:'name';
                                                                                        type:TTypeString;
                                                                                        id:1).
                                                                            iprot writeString:temp314 name.
                                                                            oprot writeFieldEnd.
                                                                            oprot writeFieldBegin:((TField new)
                                                                                        name:'value';
                                                                                        type:TTypeI64;
                                                                                        id:2).
                                                                            iprot writeI64:temp314 value asInteger.
                                                                            oprot writeFieldEnd.
                                                                            oprot
                                                                                writeFieldStop;
                                                                                writeStructEnd
                                                                        ] value
                                                                    ].
                                                                    oprot writeListEnd
                                                                ] value.
                                                                oprot writeFieldEnd.
                                                                oprot
                                                                    writeFieldStop;
                                                                    writeStructEnd
                                                            ] value.
                                                            oprot writeFieldEnd
                                                        ].
                                                    oprot
                                                        writeFieldStop;
                                                        writeStructEnd
                                                ] value.
                                                oprot writeFieldEnd
                                            ].
                                        temp312 deletion 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'deletion';
                                                            type:TTypeStruct;
                                                            id:2).
                                                [
                                                    oprot writeStructBegin:(TStruct new name:'Deletion').
                                                    temp312 deletion timestamp 
                                                        ifNotNil:[
                                                            oprot writeFieldBegin:((TField new)
                                                                        name:'timestamp';
                                                                        type:TTypeI64;
                                                                        id:1).
                                                            iprot writeI64:temp312 deletion timestamp asInteger.
                                                            oprot writeFieldEnd
                                                        ].
                                                    temp312 deletion superColumn 
                                                        ifNotNil:[
                                                            oprot writeFieldBegin:((TField new)
                                                                        name:'superColumn';
                                                                        type:TTypeString;
                                                                        id:2).
                                                            iprot writeString:temp312 deletion superColumn.
                                                            oprot writeFieldEnd
                                                        ].
                                                    temp312 deletion predicate 
                                                        ifNotNil:[
                                                            oprot writeFieldBegin:((TField new)
                                                                        name:'predicate';
                                                                        type:TTypeStruct;
                                                                        id:3).
                                                            [
                                                                oprot writeStructBegin:(TStruct new name:'SlicePredicate').
                                                                temp312 deletion predicate columnNames 
                                                                    ifNotNil:[
                                                                        oprot writeFieldBegin:((TField new)
                                                                                    name:'columnNames';
                                                                                    type:TTypeList;
                                                                                    id:1).
                                                                        [
                                                                            oprot writeListBegin:((TList new)
                                                                                        elemType:TTypeString;
                                                                                        size:temp312 deletion predicate columnNames size).
                                                                            temp312 deletion predicate columnNames do:[:temp315 | 
                                                                                iprot writeString:temp315
                                                                            ].
                                                                            oprot writeListEnd
                                                                        ] value.
                                                                        oprot writeFieldEnd
                                                                    ].
                                                                temp312 deletion predicate sliceRange 
                                                                    ifNotNil:[
                                                                        oprot writeFieldBegin:((TField new)
                                                                                    name:'sliceRange';
                                                                                    type:TTypeStruct;
                                                                                    id:2).
                                                                        [
                                                                            oprot writeStructBegin:(TStruct new name:'SliceRange').
                                                                            oprot writeFieldBegin:((TField new)
                                                                                        name:'start';
                                                                                        type:TTypeString;
                                                                                        id:1).
                                                                            iprot writeString:temp312 deletion predicate sliceRange start.
                                                                            oprot writeFieldEnd.
                                                                            oprot writeFieldBegin:((TField new)
                                                                                        name:'finish';
                                                                                        type:TTypeString;
                                                                                        id:2).
                                                                            iprot writeString:temp312 deletion predicate sliceRange finish.
                                                                            oprot writeFieldEnd.
                                                                            oprot writeFieldBegin:((TField new)
                                                                                        name:'reversed';
                                                                                        type:TTypeBool;
                                                                                        id:3).
                                                                            iprot writeBool:temp312 deletion predicate sliceRange reversed.
                                                                            oprot writeFieldEnd.
                                                                            oprot writeFieldBegin:((TField new)
                                                                                        name:'count';
                                                                                        type:TTypeI32;
                                                                                        id:4).
                                                                            iprot writeI32:temp312 deletion predicate sliceRange count asInteger.
                                                                            oprot writeFieldEnd.
                                                                            oprot
                                                                                writeFieldStop;
                                                                                writeStructEnd
                                                                        ] value.
                                                                        oprot writeFieldEnd
                                                                    ].
                                                                oprot
                                                                    writeFieldStop;
                                                                    writeStructEnd
                                                            ] value.
                                                            oprot writeFieldEnd
                                                        ].
                                                    oprot
                                                        writeFieldStop;
                                                        writeStructEnd
                                                ] value.
                                                oprot writeFieldEnd
                                            ].
                                        oprot
                                            writeFieldStop;
                                            writeStructEnd
                                    ] value
                                ].
                                oprot writeListEnd
                            ] value
                        ].
                    oprot writeMapEnd
                ] value
            ].
        oprot writeMapEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:2).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendDescribeClusterName
    oprot writeMessageBegin:
      (TCallMessage new
        name: 'describe_cluster_name'; 
        seqid: self nextSeqid).
    oprot writeStructBegin: (TStruct new name: 'DescribeClusterName_args').
    oprot writeFieldStop; writeStructEnd; writeMessageEnd.
    oprot transport flush
!

sendDescribeKeyspaceKeyspace:keyspace 
    oprot writeMessageBegin:((TCallMessage new)
                name:'describe_keyspace';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'DescribeKeyspace_args').
    oprot writeFieldBegin:((TField new)
                name:'keyspace';
                type:TTypeString;
                id:1).
    iprot writeString:keyspace.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendDescribeKeyspaces
    oprot writeMessageBegin:
      (TCallMessage new
        name: 'describe_keyspaces'; 
        seqid: self nextSeqid).
    oprot writeStructBegin: (TStruct new name: 'DescribeKeyspaces_args').
    oprot writeFieldStop; writeStructEnd; writeMessageEnd.
    oprot transport flush
!

sendDescribePartitioner
    oprot writeMessageBegin:
      (TCallMessage new
        name: 'describe_partitioner'; 
        seqid: self nextSeqid).
    oprot writeStructBegin: (TStruct new name: 'DescribePartitioner_args').
    oprot writeFieldStop; writeStructEnd; writeMessageEnd.
    oprot transport flush
!

sendDescribeRingKeyspace:keyspace 
    oprot writeMessageBegin:((TCallMessage new)
                name:'describe_ring';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'DescribeRing_args').
    oprot writeFieldBegin:((TField new)
                name:'keyspace';
                type:TTypeString;
                id:1).
    iprot writeString:keyspace.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendDescribeSchemaVersions
    oprot writeMessageBegin:
      (TCallMessage new
        name: 'describe_schema_versions'; 
        seqid: self nextSeqid).
    oprot writeStructBegin: (TStruct new name: 'DescribeSchemaVersions_args').
    oprot writeFieldStop; writeStructEnd; writeMessageEnd.
    oprot transport flush
!

sendDescribeSnitch
    oprot writeMessageBegin:
      (TCallMessage new
        name: 'describe_snitch'; 
        seqid: self nextSeqid).
    oprot writeStructBegin: (TStruct new name: 'DescribeSnitch_args').
    oprot writeFieldStop; writeStructEnd; writeMessageEnd.
    oprot transport flush
!

sendDescribeSplitsCfName:cfName startToken:startToken endToken:endToken keysPerSplit:keysPerSplit 
    oprot writeMessageBegin:((TCallMessage new)
                name:'describe_splits';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'DescribeSplits_args').
    oprot writeFieldBegin:((TField new)
                name:'cfName';
                type:TTypeString;
                id:1).
    iprot writeString:cfName.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'startToken';
                type:TTypeString;
                id:2).
    iprot writeString:startToken.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'endToken';
                type:TTypeString;
                id:3).
    iprot writeString:endToken.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'keysPerSplit';
                type:TTypeI32;
                id:4).
    iprot writeI32:keysPerSplit asInteger.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendDescribeVersion
    oprot writeMessageBegin:
      (TCallMessage new
        name: 'describe_version'; 
        seqid: self nextSeqid).
    oprot writeStructBegin: (TStruct new name: 'DescribeVersion_args').
    oprot writeFieldStop; writeStructEnd; writeMessageEnd.
    oprot transport flush
!

sendExecuteCqlQueryQuery:query compression:compression 
    oprot writeMessageBegin:((TCallMessage new)
                name:'execute_cql_query';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'ExecuteCqlQuery_args').
    oprot writeFieldBegin:((TField new)
                name:'query';
                type:TTypeString;
                id:1).
    iprot writeString:query.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'compression';
                type:TTypeI32;
                id:2).
    iprot writeI32:compression.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendExecutePreparedCqlQueryItemId:itemId values:values 
    oprot writeMessageBegin:((TCallMessage new)
                name:'execute_prepared_cql_query';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'ExecutePreparedCqlQuery_args').
    oprot writeFieldBegin:((TField new)
                name:'itemId';
                type:TTypeI32;
                id:1).
    iprot writeI32:itemId asInteger.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'values';
                type:TTypeList;
                id:2).
    [
        oprot writeListBegin:((TList new)
                    elemType:TTypeString;
                    size:values size).
        values do:[:temp581 | 
            iprot writeString:temp581
        ].
        oprot writeListEnd
    ] value.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendGetCountKey:key columnParent:columnParent predicate:predicate consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'get_count';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'GetCount_args').
    oprot writeFieldBegin:((TField new)
                name:'key';
                type:TTypeString;
                id:1).
    iprot writeString:key.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'predicate';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'SlicePredicate').
        predicate columnNames 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnNames';
                            type:TTypeList;
                            id:1).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeString;
                                size:predicate columnNames size).
                    predicate columnNames do:[:temp97 | 
                        iprot writeString:temp97
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        predicate sliceRange 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'sliceRange';
                            type:TTypeStruct;
                            id:2).
                [
                    oprot writeStructBegin:(TStruct new name:'SliceRange').
                    oprot writeFieldBegin:((TField new)
                                name:'start';
                                type:TTypeString;
                                id:1).
                    iprot writeString:predicate sliceRange start.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'finish';
                                type:TTypeString;
                                id:2).
                    iprot writeString:predicate sliceRange finish.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'reversed';
                                type:TTypeBool;
                                id:3).
                    iprot writeBool:predicate sliceRange reversed.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'count';
                                type:TTypeI32;
                                id:4).
                    iprot writeI32:predicate sliceRange count asInteger.
                    oprot writeFieldEnd.
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendGetIndexedSlicesColumnParent:columnParent indexClause:indexClause columnPredicate:columnPredicate consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'get_indexed_slices';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'GetIndexedSlices_args').
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:1).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'indexClause';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'IndexClause').
        oprot writeFieldBegin:((TField new)
                    name:'expressions';
                    type:TTypeList;
                    id:1).
        [
            oprot writeListBegin:((TList new)
                        elemType:TTypeStruct;
                        size:indexClause expressions size).
            indexClause expressions do:[:temp214 | 
                [
                    oprot writeStructBegin:(TStruct new name:'IndexExpression').
                    oprot writeFieldBegin:((TField new)
                                name:'columnName';
                                type:TTypeString;
                                id:1).
                    iprot writeString:temp214 columnName.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'op';
                                type:TTypeI32;
                                id:2).
                    iprot writeI32:temp214 op.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'value';
                                type:TTypeString;
                                id:3).
                    iprot writeString:temp214 value.
                    oprot writeFieldEnd.
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value
            ].
            oprot writeListEnd
        ] value.
        oprot writeFieldEnd.
        oprot writeFieldBegin:((TField new)
                    name:'startKey';
                    type:TTypeString;
                    id:2).
        iprot writeString:indexClause startKey.
        oprot writeFieldEnd.
        oprot writeFieldBegin:((TField new)
                    name:'count';
                    type:TTypeI32;
                    id:3).
        iprot writeI32:indexClause count asInteger.
        oprot writeFieldEnd.
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnPredicate';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'SlicePredicate').
        columnPredicate columnNames 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnNames';
                            type:TTypeList;
                            id:1).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeString;
                                size:columnPredicate columnNames size).
                    columnPredicate columnNames do:[:temp215 | 
                        iprot writeString:temp215
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        columnPredicate sliceRange 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'sliceRange';
                            type:TTypeStruct;
                            id:2).
                [
                    oprot writeStructBegin:(TStruct new name:'SliceRange').
                    oprot writeFieldBegin:((TField new)
                                name:'start';
                                type:TTypeString;
                                id:1).
                    iprot writeString:columnPredicate sliceRange start.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'finish';
                                type:TTypeString;
                                id:2).
                    iprot writeString:columnPredicate sliceRange finish.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'reversed';
                                type:TTypeBool;
                                id:3).
                    iprot writeBool:columnPredicate sliceRange reversed.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'count';
                                type:TTypeI32;
                                id:4).
                    iprot writeI32:columnPredicate sliceRange count asInteger.
                    oprot writeFieldEnd.
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendGetKey:key columnPath:columnPath consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'get';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'Get_args').
    oprot writeFieldBegin:((TField new)
                name:'key';
                type:TTypeString;
                id:1).
    iprot writeString:key.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnPath';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnPath').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnPath columnFamily.
        oprot writeFieldEnd.
        columnPath superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnPath superColumn.
                oprot writeFieldEnd
            ].
        columnPath column 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'column';
                            type:TTypeString;
                            id:5).
                iprot writeString:columnPath column.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:3).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendGetRangeSlicesColumnParent:columnParent predicate:predicate range:range consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'get_range_slices';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'GetRangeSlices_args').
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:1).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'predicate';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'SlicePredicate').
        predicate columnNames 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnNames';
                            type:TTypeList;
                            id:1).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeString;
                                size:predicate columnNames size).
                    predicate columnNames do:[:temp169 | 
                        iprot writeString:temp169
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        predicate sliceRange 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'sliceRange';
                            type:TTypeStruct;
                            id:2).
                [
                    oprot writeStructBegin:(TStruct new name:'SliceRange').
                    oprot writeFieldBegin:((TField new)
                                name:'start';
                                type:TTypeString;
                                id:1).
                    iprot writeString:predicate sliceRange start.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'finish';
                                type:TTypeString;
                                id:2).
                    iprot writeString:predicate sliceRange finish.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'reversed';
                                type:TTypeBool;
                                id:3).
                    iprot writeBool:predicate sliceRange reversed.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'count';
                                type:TTypeI32;
                                id:4).
                    iprot writeI32:predicate sliceRange count asInteger.
                    oprot writeFieldEnd.
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'range';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'KeyRange').
        range startKey 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'startKey';
                            type:TTypeString;
                            id:1).
                iprot writeString:range startKey.
                oprot writeFieldEnd
            ].
        range endKey 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'endKey';
                            type:TTypeString;
                            id:2).
                iprot writeString:range endKey.
                oprot writeFieldEnd
            ].
        range startToken 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'startToken';
                            type:TTypeString;
                            id:3).
                iprot writeString:range startToken.
                oprot writeFieldEnd
            ].
        range endToken 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'endToken';
                            type:TTypeString;
                            id:4).
                iprot writeString:range endToken.
                oprot writeFieldEnd
            ].
        oprot writeFieldBegin:((TField new)
                    name:'count';
                    type:TTypeI32;
                    id:5).
        iprot writeI32:range count asInteger.
        oprot writeFieldEnd.
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendGetSliceKey:key columnParent:columnParent predicate:predicate consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'get_slice';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'GetSlice_args').
    oprot writeFieldBegin:((TField new)
                name:'key';
                type:TTypeString;
                id:1).
    iprot writeString:key.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'predicate';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'SlicePredicate').
        predicate columnNames 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnNames';
                            type:TTypeList;
                            id:1).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeString;
                                size:predicate columnNames size).
                    predicate columnNames do:[:temp57 | 
                        iprot writeString:temp57
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        predicate sliceRange 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'sliceRange';
                            type:TTypeStruct;
                            id:2).
                [
                    oprot writeStructBegin:(TStruct new name:'SliceRange').
                    oprot writeFieldBegin:((TField new)
                                name:'start';
                                type:TTypeString;
                                id:1).
                    iprot writeString:predicate sliceRange start.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'finish';
                                type:TTypeString;
                                id:2).
                    iprot writeString:predicate sliceRange finish.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'reversed';
                                type:TTypeBool;
                                id:3).
                    iprot writeBool:predicate sliceRange reversed.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'count';
                                type:TTypeI32;
                                id:4).
                    iprot writeI32:predicate sliceRange count asInteger.
                    oprot writeFieldEnd.
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendInsertKey:key columnParent:columnParent column:column consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'insert';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'Insert_args').
    oprot writeFieldBegin:((TField new)
                name:'key';
                type:TTypeString;
                id:1).
    iprot writeString:key.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'column';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'Column').
        oprot writeFieldBegin:((TField new)
                    name:'name';
                    type:TTypeString;
                    id:1).
        iprot writeString:column name.
        oprot writeFieldEnd.
        column value 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'value';
                            type:TTypeString;
                            id:2).
                iprot writeString:column value.
                oprot writeFieldEnd
            ].
        column timestamp 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'timestamp';
                            type:TTypeI64;
                            id:3).
                iprot writeI64:column timestamp asInteger.
                oprot writeFieldEnd
            ].
        column ttl 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'ttl';
                            type:TTypeI32;
                            id:4).
                iprot writeI32:column ttl asInteger.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendLoginAuthRequest:authRequest 
    oprot writeMessageBegin:((TCallMessage new)
                name:'login';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'Login_args').
    oprot writeFieldBegin:((TField new)
                name:'authRequest';
                type:TTypeStruct;
                id:1).
    [
        oprot writeStructBegin:(TStruct new name:'AuthenticationRequest').
        oprot writeFieldBegin:((TField new)
                    name:'credentials';
                    type:TTypeMap;
                    id:1).
        [
            oprot writeMapBegin:((TMap new)
                        keyType:TTypeString;
                        valueType:TTypeString;
                        size:authRequest credentials size).
            authRequest credentials 
                keysAndValuesDo:[:temp0 :temp1 | 
                    iprot writeString:temp0.
                    iprot writeString:temp1
                ].
            oprot writeMapEnd
        ] value.
        oprot writeFieldEnd.
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendMultigetCountKeys:keys columnParent:columnParent predicate:predicate consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'multiget_count';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'MultigetCount_args').
    oprot writeFieldBegin:((TField new)
                name:'keys';
                type:TTypeList;
                id:1).
    [
        oprot writeListBegin:((TList new)
                    elemType:TTypeString;
                    size:keys size).
        keys do:[:temp153 | 
            iprot writeString:temp153
        ].
        oprot writeListEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'predicate';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'SlicePredicate').
        predicate columnNames 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnNames';
                            type:TTypeList;
                            id:1).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeString;
                                size:predicate columnNames size).
                    predicate columnNames do:[:temp154 | 
                        iprot writeString:temp154
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        predicate sliceRange 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'sliceRange';
                            type:TTypeStruct;
                            id:2).
                [
                    oprot writeStructBegin:(TStruct new name:'SliceRange').
                    oprot writeFieldBegin:((TField new)
                                name:'start';
                                type:TTypeString;
                                id:1).
                    iprot writeString:predicate sliceRange start.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'finish';
                                type:TTypeString;
                                id:2).
                    iprot writeString:predicate sliceRange finish.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'reversed';
                                type:TTypeBool;
                                id:3).
                    iprot writeBool:predicate sliceRange reversed.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'count';
                                type:TTypeI32;
                                id:4).
                    iprot writeI32:predicate sliceRange count asInteger.
                    oprot writeFieldEnd.
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendMultigetSliceKeys:keys columnParent:columnParent predicate:predicate consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'multiget_slice';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'MultigetSlice_args').
    oprot writeFieldBegin:((TField new)
                name:'keys';
                type:TTypeList;
                id:1).
    [
        oprot writeListBegin:((TList new)
                    elemType:TTypeString;
                    size:keys size).
        keys do:[:temp110 | 
            iprot writeString:temp110
        ].
        oprot writeListEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnParent';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnParent').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnParent columnFamily.
        oprot writeFieldEnd.
        columnParent superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnParent superColumn.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'predicate';
                type:TTypeStruct;
                id:3).
    [
        oprot writeStructBegin:(TStruct new name:'SlicePredicate').
        predicate columnNames 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnNames';
                            type:TTypeList;
                            id:1).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeString;
                                size:predicate columnNames size).
                    predicate columnNames do:[:temp111 | 
                        iprot writeString:temp111
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        predicate sliceRange 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'sliceRange';
                            type:TTypeStruct;
                            id:2).
                [
                    oprot writeStructBegin:(TStruct new name:'SliceRange').
                    oprot writeFieldBegin:((TField new)
                                name:'start';
                                type:TTypeString;
                                id:1).
                    iprot writeString:predicate sliceRange start.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'finish';
                                type:TTypeString;
                                id:2).
                    iprot writeString:predicate sliceRange finish.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'reversed';
                                type:TTypeBool;
                                id:3).
                    iprot writeBool:predicate sliceRange reversed.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'count';
                                type:TTypeI32;
                                id:4).
                    iprot writeI32:predicate sliceRange count asInteger.
                    oprot writeFieldEnd.
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendPrepareCqlQueryQuery:query compression:compression 
    oprot writeMessageBegin:((TCallMessage new)
                name:'prepare_cql_query';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'PrepareCqlQuery_args').
    oprot writeFieldBegin:((TField new)
                name:'query';
                type:TTypeString;
                id:1).
    iprot writeString:query.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'compression';
                type:TTypeI32;
                id:2).
    iprot writeI32:compression.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendRemoveCounterKey:key path:path consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'remove_counter';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'RemoveCounter_args').
    oprot writeFieldBegin:((TField new)
                name:'key';
                type:TTypeString;
                id:1).
    iprot writeString:key.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'path';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnPath').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:path columnFamily.
        oprot writeFieldEnd.
        path superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:path superColumn.
                oprot writeFieldEnd
            ].
        path column 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'column';
                            type:TTypeString;
                            id:5).
                iprot writeString:path column.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:3).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendRemoveKey:key columnPath:columnPath timestamp:timestamp consistencyLevel:consistencyLevel 
    oprot writeMessageBegin:((TCallMessage new)
                name:'remove';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'Remove_args').
    oprot writeFieldBegin:((TField new)
                name:'key';
                type:TTypeString;
                id:1).
    iprot writeString:key.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'columnPath';
                type:TTypeStruct;
                id:2).
    [
        oprot writeStructBegin:(TStruct new name:'ColumnPath').
        oprot writeFieldBegin:((TField new)
                    name:'columnFamily';
                    type:TTypeString;
                    id:3).
        iprot writeString:columnPath columnFamily.
        oprot writeFieldEnd.
        columnPath superColumn 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'superColumn';
                            type:TTypeString;
                            id:4).
                iprot writeString:columnPath superColumn.
                oprot writeFieldEnd
            ].
        columnPath column 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'column';
                            type:TTypeString;
                            id:5).
                iprot writeString:columnPath column.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'timestamp';
                type:TTypeI64;
                id:3).
    iprot writeI64:timestamp asInteger.
    oprot writeFieldEnd.
    oprot writeFieldBegin:((TField new)
                name:'consistencyLevel';
                type:TTypeI32;
                id:4).
    iprot writeI32:consistencyLevel.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendSetKeyspaceKeyspace:keyspace 
    oprot writeMessageBegin:((TCallMessage new)
                name:'set_keyspace';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'SetKeyspace_args').
    oprot writeFieldBegin:((TField new)
                name:'keyspace';
                type:TTypeString;
                id:1).
    iprot writeString:keyspace.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendSystemAddColumnFamilyCfDef:cfDef 
    oprot writeMessageBegin:((TCallMessage new)
                name:'system_add_column_family';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'SystemAddColumnFamily_args').
    oprot writeFieldBegin:((TField new)
                name:'cfDef';
                type:TTypeStruct;
                id:1).
    [
        oprot writeStructBegin:(TStruct new name:'CfDef').
        oprot writeFieldBegin:((TField new)
                    name:'keyspace';
                    type:TTypeString;
                    id:1).
        iprot writeString:cfDef keyspace.
        oprot writeFieldEnd.
        oprot writeFieldBegin:((TField new)
                    name:'name';
                    type:TTypeString;
                    id:2).
        iprot writeString:cfDef name.
        oprot writeFieldEnd.
        cfDef columnType 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnType';
                            type:TTypeString;
                            id:3).
                iprot writeString:cfDef columnType.
                oprot writeFieldEnd
            ].
        cfDef comparatorType 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'comparatorType';
                            type:TTypeString;
                            id:5).
                iprot writeString:cfDef comparatorType.
                oprot writeFieldEnd
            ].
        cfDef subcomparatorType 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'subcomparatorType';
                            type:TTypeString;
                            id:6).
                iprot writeString:cfDef subcomparatorType.
                oprot writeFieldEnd
            ].
        cfDef comment 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'comment';
                            type:TTypeString;
                            id:8).
                iprot writeString:cfDef comment.
                oprot writeFieldEnd
            ].
        cfDef readRepairChance 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'readRepairChance';
                            type:TTypeDouble;
                            id:12).
                iprot writeDouble:cfDef readRepairChance asFloat.
                oprot writeFieldEnd
            ].
        cfDef columnMetadata 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnMetadata';
                            type:TTypeList;
                            id:13).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeStruct;
                                size:cfDef columnMetadata size).
                    cfDef columnMetadata do:[:temp449 | 
                        [
                            oprot writeStructBegin:(TStruct new name:'ColumnDef').
                            oprot writeFieldBegin:((TField new)
                                        name:'name';
                                        type:TTypeString;
                                        id:1).
                            iprot writeString:temp449 name.
                            oprot writeFieldEnd.
                            oprot writeFieldBegin:((TField new)
                                        name:'validationClass';
                                        type:TTypeString;
                                        id:2).
                            iprot writeString:temp449 validationClass.
                            oprot writeFieldEnd.
                            temp449 indexType 
                                ifNotNil:[
                                    oprot writeFieldBegin:((TField new)
                                                name:'indexType';
                                                type:TTypeI32;
                                                id:3).
                                    iprot writeI32:temp449 indexType.
                                    oprot writeFieldEnd
                                ].
                            temp449 indexName 
                                ifNotNil:[
                                    oprot writeFieldBegin:((TField new)
                                                name:'indexName';
                                                type:TTypeString;
                                                id:4).
                                    iprot writeString:temp449 indexName.
                                    oprot writeFieldEnd
                                ].
                            temp449 indexOptions 
                                ifNotNil:[
                                    oprot writeFieldBegin:((TField new)
                                                name:'indexOptions';
                                                type:TTypeMap;
                                                id:5).
                                    [
                                        oprot writeMapBegin:((TMap new)
                                                    keyType:TTypeString;
                                                    valueType:TTypeString;
                                                    size:temp449 indexOptions size).
                                        temp449 indexOptions 
                                            keysAndValuesDo:[:temp450 :temp451 | 
                                                iprot writeString:temp450.
                                                iprot writeString:temp451
                                            ].
                                        oprot writeMapEnd
                                    ] value.
                                    oprot writeFieldEnd
                                ].
                            oprot
                                writeFieldStop;
                                writeStructEnd
                        ] value
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        cfDef gcGraceSeconds 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'gcGraceSeconds';
                            type:TTypeI32;
                            id:14).
                iprot writeI32:cfDef gcGraceSeconds asInteger.
                oprot writeFieldEnd
            ].
        cfDef defaultValidationClass 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'defaultValidationClass';
                            type:TTypeString;
                            id:15).
                iprot writeString:cfDef defaultValidationClass.
                oprot writeFieldEnd
            ].
        cfDef id 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'id';
                            type:TTypeI32;
                            id:16).
                iprot writeI32:cfDef id asInteger.
                oprot writeFieldEnd
            ].
        cfDef minCompactionThreshold 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'minCompactionThreshold';
                            type:TTypeI32;
                            id:17).
                iprot writeI32:cfDef minCompactionThreshold asInteger.
                oprot writeFieldEnd
            ].
        cfDef maxCompactionThreshold 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'maxCompactionThreshold';
                            type:TTypeI32;
                            id:18).
                iprot writeI32:cfDef maxCompactionThreshold asInteger.
                oprot writeFieldEnd
            ].
        cfDef replicateOnWrite 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'replicateOnWrite';
                            type:TTypeBool;
                            id:24).
                iprot writeBool:cfDef replicateOnWrite.
                oprot writeFieldEnd
            ].
        cfDef mergeShardsChance 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'mergeShardsChance';
                            type:TTypeDouble;
                            id:25).
                iprot writeDouble:cfDef mergeShardsChance asFloat.
                oprot writeFieldEnd
            ].
        cfDef keyValidationClass 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'keyValidationClass';
                            type:TTypeString;
                            id:26).
                iprot writeString:cfDef keyValidationClass.
                oprot writeFieldEnd
            ].
        cfDef keyAlias 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'keyAlias';
                            type:TTypeString;
                            id:28).
                iprot writeString:cfDef keyAlias.
                oprot writeFieldEnd
            ].
        cfDef compactionStrategy 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'compactionStrategy';
                            type:TTypeString;
                            id:29).
                iprot writeString:cfDef compactionStrategy.
                oprot writeFieldEnd
            ].
        cfDef compactionStrategyOptions 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'compactionStrategyOptions';
                            type:TTypeMap;
                            id:30).
                [
                    oprot writeMapBegin:((TMap new)
                                keyType:TTypeString;
                                valueType:TTypeString;
                                size:cfDef compactionStrategyOptions size).
                    cfDef compactionStrategyOptions 
                        keysAndValuesDo:[:temp452 :temp453 | 
                            iprot writeString:temp452.
                            iprot writeString:temp453
                        ].
                    oprot writeMapEnd
                ] value.
                oprot writeFieldEnd
            ].
        cfDef compressionOptions 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'compressionOptions';
                            type:TTypeMap;
                            id:32).
                [
                    oprot writeMapBegin:((TMap new)
                                keyType:TTypeString;
                                valueType:TTypeString;
                                size:cfDef compressionOptions size).
                    cfDef compressionOptions 
                        keysAndValuesDo:[:temp454 :temp455 | 
                            iprot writeString:temp454.
                            iprot writeString:temp455
                        ].
                    oprot writeMapEnd
                ] value.
                oprot writeFieldEnd
            ].
        cfDef bloomFilterFpChance 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'bloomFilterFpChance';
                            type:TTypeDouble;
                            id:33).
                iprot writeDouble:cfDef bloomFilterFpChance asFloat.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendSystemAddKeyspaceKsDef:ksDef 
    oprot writeMessageBegin:((TCallMessage new)
                name:'system_add_keyspace';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'SystemAddKeyspace_args').
    oprot writeFieldBegin:((TField new)
                name:'ksDef';
                type:TTypeStruct;
                id:1).
    [
        oprot writeStructBegin:(TStruct new name:'KsDef').
        oprot writeFieldBegin:((TField new)
                    name:'name';
                    type:TTypeString;
                    id:1).
        iprot writeString:ksDef name.
        oprot writeFieldEnd.
        oprot writeFieldBegin:((TField new)
                    name:'strategyClass';
                    type:TTypeString;
                    id:2).
        iprot writeString:ksDef strategyClass.
        oprot writeFieldEnd.
        ksDef strategyOptions 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'strategyOptions';
                            type:TTypeMap;
                            id:3).
                [
                    oprot writeMapBegin:((TMap new)
                                keyType:TTypeString;
                                valueType:TTypeString;
                                size:ksDef strategyOptions size).
                    ksDef strategyOptions 
                        keysAndValuesDo:[:temp474 :temp475 | 
                            iprot writeString:temp474.
                            iprot writeString:temp475
                        ].
                    oprot writeMapEnd
                ] value.
                oprot writeFieldEnd
            ].
        ksDef replicationFactor 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'replicationFactor';
                            type:TTypeI32;
                            id:4).
                iprot writeI32:ksDef replicationFactor asInteger.
                oprot writeFieldEnd
            ].
        oprot writeFieldBegin:((TField new)
                    name:'cfDefs';
                    type:TTypeList;
                    id:5).
        [
            oprot writeListBegin:((TList new)
                        elemType:TTypeStruct;
                        size:ksDef cfDefs size).
            ksDef cfDefs do:[:temp476 | 
                [
                    oprot writeStructBegin:(TStruct new name:'CfDef').
                    oprot writeFieldBegin:((TField new)
                                name:'keyspace';
                                type:TTypeString;
                                id:1).
                    iprot writeString:temp476 keyspace.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'name';
                                type:TTypeString;
                                id:2).
                    iprot writeString:temp476 name.
                    oprot writeFieldEnd.
                    temp476 columnType 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'columnType';
                                        type:TTypeString;
                                        id:3).
                            iprot writeString:temp476 columnType.
                            oprot writeFieldEnd
                        ].
                    temp476 comparatorType 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'comparatorType';
                                        type:TTypeString;
                                        id:5).
                            iprot writeString:temp476 comparatorType.
                            oprot writeFieldEnd
                        ].
                    temp476 subcomparatorType 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'subcomparatorType';
                                        type:TTypeString;
                                        id:6).
                            iprot writeString:temp476 subcomparatorType.
                            oprot writeFieldEnd
                        ].
                    temp476 comment 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'comment';
                                        type:TTypeString;
                                        id:8).
                            iprot writeString:temp476 comment.
                            oprot writeFieldEnd
                        ].
                    temp476 readRepairChance 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'readRepairChance';
                                        type:TTypeDouble;
                                        id:12).
                            iprot writeDouble:temp476 readRepairChance asFloat.
                            oprot writeFieldEnd
                        ].
                    temp476 columnMetadata 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'columnMetadata';
                                        type:TTypeList;
                                        id:13).
                            [
                                oprot writeListBegin:((TList new)
                                            elemType:TTypeStruct;
                                            size:temp476 columnMetadata size).
                                temp476 columnMetadata do:[:temp477 | 
                                    [
                                        oprot writeStructBegin:(TStruct new name:'ColumnDef').
                                        oprot writeFieldBegin:((TField new)
                                                    name:'name';
                                                    type:TTypeString;
                                                    id:1).
                                        iprot writeString:temp477 name.
                                        oprot writeFieldEnd.
                                        oprot writeFieldBegin:((TField new)
                                                    name:'validationClass';
                                                    type:TTypeString;
                                                    id:2).
                                        iprot writeString:temp477 validationClass.
                                        oprot writeFieldEnd.
                                        temp477 indexType 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'indexType';
                                                            type:TTypeI32;
                                                            id:3).
                                                iprot writeI32:temp477 indexType.
                                                oprot writeFieldEnd
                                            ].
                                        temp477 indexName 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'indexName';
                                                            type:TTypeString;
                                                            id:4).
                                                iprot writeString:temp477 indexName.
                                                oprot writeFieldEnd
                                            ].
                                        temp477 indexOptions 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'indexOptions';
                                                            type:TTypeMap;
                                                            id:5).
                                                [
                                                    oprot writeMapBegin:((TMap new)
                                                                keyType:TTypeString;
                                                                valueType:TTypeString;
                                                                size:temp477 indexOptions size).
                                                    temp477 indexOptions 
                                                        keysAndValuesDo:[:temp478 :temp479 | 
                                                            iprot writeString:temp478.
                                                            iprot writeString:temp479
                                                        ].
                                                    oprot writeMapEnd
                                                ] value.
                                                oprot writeFieldEnd
                                            ].
                                        oprot
                                            writeFieldStop;
                                            writeStructEnd
                                    ] value
                                ].
                                oprot writeListEnd
                            ] value.
                            oprot writeFieldEnd
                        ].
                    temp476 gcGraceSeconds 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'gcGraceSeconds';
                                        type:TTypeI32;
                                        id:14).
                            iprot writeI32:temp476 gcGraceSeconds asInteger.
                            oprot writeFieldEnd
                        ].
                    temp476 defaultValidationClass 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'defaultValidationClass';
                                        type:TTypeString;
                                        id:15).
                            iprot writeString:temp476 defaultValidationClass.
                            oprot writeFieldEnd
                        ].
                    temp476 id 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'id';
                                        type:TTypeI32;
                                        id:16).
                            iprot writeI32:temp476 id asInteger.
                            oprot writeFieldEnd
                        ].
                    temp476 minCompactionThreshold 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'minCompactionThreshold';
                                        type:TTypeI32;
                                        id:17).
                            iprot writeI32:temp476 minCompactionThreshold asInteger.
                            oprot writeFieldEnd
                        ].
                    temp476 maxCompactionThreshold 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'maxCompactionThreshold';
                                        type:TTypeI32;
                                        id:18).
                            iprot writeI32:temp476 maxCompactionThreshold asInteger.
                            oprot writeFieldEnd
                        ].
                    temp476 replicateOnWrite 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'replicateOnWrite';
                                        type:TTypeBool;
                                        id:24).
                            iprot writeBool:temp476 replicateOnWrite.
                            oprot writeFieldEnd
                        ].
                    temp476 mergeShardsChance 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'mergeShardsChance';
                                        type:TTypeDouble;
                                        id:25).
                            iprot writeDouble:temp476 mergeShardsChance asFloat.
                            oprot writeFieldEnd
                        ].
                    temp476 keyValidationClass 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'keyValidationClass';
                                        type:TTypeString;
                                        id:26).
                            iprot writeString:temp476 keyValidationClass.
                            oprot writeFieldEnd
                        ].
                    temp476 keyAlias 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'keyAlias';
                                        type:TTypeString;
                                        id:28).
                            iprot writeString:temp476 keyAlias.
                            oprot writeFieldEnd
                        ].
                    temp476 compactionStrategy 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'compactionStrategy';
                                        type:TTypeString;
                                        id:29).
                            iprot writeString:temp476 compactionStrategy.
                            oprot writeFieldEnd
                        ].
                    temp476 compactionStrategyOptions 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'compactionStrategyOptions';
                                        type:TTypeMap;
                                        id:30).
                            [
                                oprot writeMapBegin:((TMap new)
                                            keyType:TTypeString;
                                            valueType:TTypeString;
                                            size:temp476 compactionStrategyOptions size).
                                temp476 compactionStrategyOptions 
                                    keysAndValuesDo:[:temp480 :temp481 | 
                                        iprot writeString:temp480.
                                        iprot writeString:temp481
                                    ].
                                oprot writeMapEnd
                            ] value.
                            oprot writeFieldEnd
                        ].
                    temp476 compressionOptions 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'compressionOptions';
                                        type:TTypeMap;
                                        id:32).
                            [
                                oprot writeMapBegin:((TMap new)
                                            keyType:TTypeString;
                                            valueType:TTypeString;
                                            size:temp476 compressionOptions size).
                                temp476 compressionOptions 
                                    keysAndValuesDo:[:temp482 :temp483 | 
                                        iprot writeString:temp482.
                                        iprot writeString:temp483
                                    ].
                                oprot writeMapEnd
                            ] value.
                            oprot writeFieldEnd
                        ].
                    temp476 bloomFilterFpChance 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'bloomFilterFpChance';
                                        type:TTypeDouble;
                                        id:33).
                            iprot writeDouble:temp476 bloomFilterFpChance asFloat.
                            oprot writeFieldEnd
                        ].
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value
            ].
            oprot writeListEnd
        ] value.
        oprot writeFieldEnd.
        ksDef durableWrites 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'durableWrites';
                            type:TTypeBool;
                            id:6).
                iprot writeBool:ksDef durableWrites.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendSystemDropColumnFamilyColumnFamily:columnFamily 
    oprot writeMessageBegin:((TCallMessage new)
                name:'system_drop_column_family';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'SystemDropColumnFamily_args').
    oprot writeFieldBegin:((TField new)
                name:'columnFamily';
                type:TTypeString;
                id:1).
    iprot writeString:columnFamily.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendSystemDropKeyspaceKeyspace:keyspace 
    oprot writeMessageBegin:((TCallMessage new)
                name:'system_drop_keyspace';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'SystemDropKeyspace_args').
    oprot writeFieldBegin:((TField new)
                name:'keyspace';
                type:TTypeString;
                id:1).
    iprot writeString:keyspace.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendSystemUpdateColumnFamilyCfDef:cfDef 
    oprot writeMessageBegin:((TCallMessage new)
                name:'system_update_column_family';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'SystemUpdateColumnFamily_args').
    oprot writeFieldBegin:((TField new)
                name:'cfDef';
                type:TTypeStruct;
                id:1).
    [
        oprot writeStructBegin:(TStruct new name:'CfDef').
        oprot writeFieldBegin:((TField new)
                    name:'keyspace';
                    type:TTypeString;
                    id:1).
        iprot writeString:cfDef keyspace.
        oprot writeFieldEnd.
        oprot writeFieldBegin:((TField new)
                    name:'name';
                    type:TTypeString;
                    id:2).
        iprot writeString:cfDef name.
        oprot writeFieldEnd.
        cfDef columnType 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnType';
                            type:TTypeString;
                            id:3).
                iprot writeString:cfDef columnType.
                oprot writeFieldEnd
            ].
        cfDef comparatorType 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'comparatorType';
                            type:TTypeString;
                            id:5).
                iprot writeString:cfDef comparatorType.
                oprot writeFieldEnd
            ].
        cfDef subcomparatorType 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'subcomparatorType';
                            type:TTypeString;
                            id:6).
                iprot writeString:cfDef subcomparatorType.
                oprot writeFieldEnd
            ].
        cfDef comment 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'comment';
                            type:TTypeString;
                            id:8).
                iprot writeString:cfDef comment.
                oprot writeFieldEnd
            ].
        cfDef readRepairChance 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'readRepairChance';
                            type:TTypeDouble;
                            id:12).
                iprot writeDouble:cfDef readRepairChance asFloat.
                oprot writeFieldEnd
            ].
        cfDef columnMetadata 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'columnMetadata';
                            type:TTypeList;
                            id:13).
                [
                    oprot writeListBegin:((TList new)
                                elemType:TTypeStruct;
                                size:cfDef columnMetadata size).
                    cfDef columnMetadata do:[:temp521 | 
                        [
                            oprot writeStructBegin:(TStruct new name:'ColumnDef').
                            oprot writeFieldBegin:((TField new)
                                        name:'name';
                                        type:TTypeString;
                                        id:1).
                            iprot writeString:temp521 name.
                            oprot writeFieldEnd.
                            oprot writeFieldBegin:((TField new)
                                        name:'validationClass';
                                        type:TTypeString;
                                        id:2).
                            iprot writeString:temp521 validationClass.
                            oprot writeFieldEnd.
                            temp521 indexType 
                                ifNotNil:[
                                    oprot writeFieldBegin:((TField new)
                                                name:'indexType';
                                                type:TTypeI32;
                                                id:3).
                                    iprot writeI32:temp521 indexType.
                                    oprot writeFieldEnd
                                ].
                            temp521 indexName 
                                ifNotNil:[
                                    oprot writeFieldBegin:((TField new)
                                                name:'indexName';
                                                type:TTypeString;
                                                id:4).
                                    iprot writeString:temp521 indexName.
                                    oprot writeFieldEnd
                                ].
                            temp521 indexOptions 
                                ifNotNil:[
                                    oprot writeFieldBegin:((TField new)
                                                name:'indexOptions';
                                                type:TTypeMap;
                                                id:5).
                                    [
                                        oprot writeMapBegin:((TMap new)
                                                    keyType:TTypeString;
                                                    valueType:TTypeString;
                                                    size:temp521 indexOptions size).
                                        temp521 indexOptions 
                                            keysAndValuesDo:[:temp522 :temp523 | 
                                                iprot writeString:temp522.
                                                iprot writeString:temp523
                                            ].
                                        oprot writeMapEnd
                                    ] value.
                                    oprot writeFieldEnd
                                ].
                            oprot
                                writeFieldStop;
                                writeStructEnd
                        ] value
                    ].
                    oprot writeListEnd
                ] value.
                oprot writeFieldEnd
            ].
        cfDef gcGraceSeconds 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'gcGraceSeconds';
                            type:TTypeI32;
                            id:14).
                iprot writeI32:cfDef gcGraceSeconds asInteger.
                oprot writeFieldEnd
            ].
        cfDef defaultValidationClass 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'defaultValidationClass';
                            type:TTypeString;
                            id:15).
                iprot writeString:cfDef defaultValidationClass.
                oprot writeFieldEnd
            ].
        cfDef id 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'id';
                            type:TTypeI32;
                            id:16).
                iprot writeI32:cfDef id asInteger.
                oprot writeFieldEnd
            ].
        cfDef minCompactionThreshold 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'minCompactionThreshold';
                            type:TTypeI32;
                            id:17).
                iprot writeI32:cfDef minCompactionThreshold asInteger.
                oprot writeFieldEnd
            ].
        cfDef maxCompactionThreshold 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'maxCompactionThreshold';
                            type:TTypeI32;
                            id:18).
                iprot writeI32:cfDef maxCompactionThreshold asInteger.
                oprot writeFieldEnd
            ].
        cfDef replicateOnWrite 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'replicateOnWrite';
                            type:TTypeBool;
                            id:24).
                iprot writeBool:cfDef replicateOnWrite.
                oprot writeFieldEnd
            ].
        cfDef mergeShardsChance 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'mergeShardsChance';
                            type:TTypeDouble;
                            id:25).
                iprot writeDouble:cfDef mergeShardsChance asFloat.
                oprot writeFieldEnd
            ].
        cfDef keyValidationClass 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'keyValidationClass';
                            type:TTypeString;
                            id:26).
                iprot writeString:cfDef keyValidationClass.
                oprot writeFieldEnd
            ].
        cfDef keyAlias 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'keyAlias';
                            type:TTypeString;
                            id:28).
                iprot writeString:cfDef keyAlias.
                oprot writeFieldEnd
            ].
        cfDef compactionStrategy 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'compactionStrategy';
                            type:TTypeString;
                            id:29).
                iprot writeString:cfDef compactionStrategy.
                oprot writeFieldEnd
            ].
        cfDef compactionStrategyOptions 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'compactionStrategyOptions';
                            type:TTypeMap;
                            id:30).
                [
                    oprot writeMapBegin:((TMap new)
                                keyType:TTypeString;
                                valueType:TTypeString;
                                size:cfDef compactionStrategyOptions size).
                    cfDef compactionStrategyOptions 
                        keysAndValuesDo:[:temp524 :temp525 | 
                            iprot writeString:temp524.
                            iprot writeString:temp525
                        ].
                    oprot writeMapEnd
                ] value.
                oprot writeFieldEnd
            ].
        cfDef compressionOptions 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'compressionOptions';
                            type:TTypeMap;
                            id:32).
                [
                    oprot writeMapBegin:((TMap new)
                                keyType:TTypeString;
                                valueType:TTypeString;
                                size:cfDef compressionOptions size).
                    cfDef compressionOptions 
                        keysAndValuesDo:[:temp526 :temp527 | 
                            iprot writeString:temp526.
                            iprot writeString:temp527
                        ].
                    oprot writeMapEnd
                ] value.
                oprot writeFieldEnd
            ].
        cfDef bloomFilterFpChance 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'bloomFilterFpChance';
                            type:TTypeDouble;
                            id:33).
                iprot writeDouble:cfDef bloomFilterFpChance asFloat.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendSystemUpdateKeyspaceKsDef:ksDef 
    oprot writeMessageBegin:((TCallMessage new)
                name:'system_update_keyspace';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'SystemUpdateKeyspace_args').
    oprot writeFieldBegin:((TField new)
                name:'ksDef';
                type:TTypeStruct;
                id:1).
    [
        oprot writeStructBegin:(TStruct new name:'KsDef').
        oprot writeFieldBegin:((TField new)
                    name:'name';
                    type:TTypeString;
                    id:1).
        iprot writeString:ksDef name.
        oprot writeFieldEnd.
        oprot writeFieldBegin:((TField new)
                    name:'strategyClass';
                    type:TTypeString;
                    id:2).
        iprot writeString:ksDef strategyClass.
        oprot writeFieldEnd.
        ksDef strategyOptions 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'strategyOptions';
                            type:TTypeMap;
                            id:3).
                [
                    oprot writeMapBegin:((TMap new)
                                keyType:TTypeString;
                                valueType:TTypeString;
                                size:ksDef strategyOptions size).
                    ksDef strategyOptions 
                        keysAndValuesDo:[:temp502 :temp503 | 
                            iprot writeString:temp502.
                            iprot writeString:temp503
                        ].
                    oprot writeMapEnd
                ] value.
                oprot writeFieldEnd
            ].
        ksDef replicationFactor 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'replicationFactor';
                            type:TTypeI32;
                            id:4).
                iprot writeI32:ksDef replicationFactor asInteger.
                oprot writeFieldEnd
            ].
        oprot writeFieldBegin:((TField new)
                    name:'cfDefs';
                    type:TTypeList;
                    id:5).
        [
            oprot writeListBegin:((TList new)
                        elemType:TTypeStruct;
                        size:ksDef cfDefs size).
            ksDef cfDefs do:[:temp504 | 
                [
                    oprot writeStructBegin:(TStruct new name:'CfDef').
                    oprot writeFieldBegin:((TField new)
                                name:'keyspace';
                                type:TTypeString;
                                id:1).
                    iprot writeString:temp504 keyspace.
                    oprot writeFieldEnd.
                    oprot writeFieldBegin:((TField new)
                                name:'name';
                                type:TTypeString;
                                id:2).
                    iprot writeString:temp504 name.
                    oprot writeFieldEnd.
                    temp504 columnType 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'columnType';
                                        type:TTypeString;
                                        id:3).
                            iprot writeString:temp504 columnType.
                            oprot writeFieldEnd
                        ].
                    temp504 comparatorType 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'comparatorType';
                                        type:TTypeString;
                                        id:5).
                            iprot writeString:temp504 comparatorType.
                            oprot writeFieldEnd
                        ].
                    temp504 subcomparatorType 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'subcomparatorType';
                                        type:TTypeString;
                                        id:6).
                            iprot writeString:temp504 subcomparatorType.
                            oprot writeFieldEnd
                        ].
                    temp504 comment 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'comment';
                                        type:TTypeString;
                                        id:8).
                            iprot writeString:temp504 comment.
                            oprot writeFieldEnd
                        ].
                    temp504 readRepairChance 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'readRepairChance';
                                        type:TTypeDouble;
                                        id:12).
                            iprot writeDouble:temp504 readRepairChance asFloat.
                            oprot writeFieldEnd
                        ].
                    temp504 columnMetadata 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'columnMetadata';
                                        type:TTypeList;
                                        id:13).
                            [
                                oprot writeListBegin:((TList new)
                                            elemType:TTypeStruct;
                                            size:temp504 columnMetadata size).
                                temp504 columnMetadata do:[:temp505 | 
                                    [
                                        oprot writeStructBegin:(TStruct new name:'ColumnDef').
                                        oprot writeFieldBegin:((TField new)
                                                    name:'name';
                                                    type:TTypeString;
                                                    id:1).
                                        iprot writeString:temp505 name.
                                        oprot writeFieldEnd.
                                        oprot writeFieldBegin:((TField new)
                                                    name:'validationClass';
                                                    type:TTypeString;
                                                    id:2).
                                        iprot writeString:temp505 validationClass.
                                        oprot writeFieldEnd.
                                        temp505 indexType 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'indexType';
                                                            type:TTypeI32;
                                                            id:3).
                                                iprot writeI32:temp505 indexType.
                                                oprot writeFieldEnd
                                            ].
                                        temp505 indexName 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'indexName';
                                                            type:TTypeString;
                                                            id:4).
                                                iprot writeString:temp505 indexName.
                                                oprot writeFieldEnd
                                            ].
                                        temp505 indexOptions 
                                            ifNotNil:[
                                                oprot writeFieldBegin:((TField new)
                                                            name:'indexOptions';
                                                            type:TTypeMap;
                                                            id:5).
                                                [
                                                    oprot writeMapBegin:((TMap new)
                                                                keyType:TTypeString;
                                                                valueType:TTypeString;
                                                                size:temp505 indexOptions size).
                                                    temp505 indexOptions 
                                                        keysAndValuesDo:[:temp506 :temp507 | 
                                                            iprot writeString:temp506.
                                                            iprot writeString:temp507
                                                        ].
                                                    oprot writeMapEnd
                                                ] value.
                                                oprot writeFieldEnd
                                            ].
                                        oprot
                                            writeFieldStop;
                                            writeStructEnd
                                    ] value
                                ].
                                oprot writeListEnd
                            ] value.
                            oprot writeFieldEnd
                        ].
                    temp504 gcGraceSeconds 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'gcGraceSeconds';
                                        type:TTypeI32;
                                        id:14).
                            iprot writeI32:temp504 gcGraceSeconds asInteger.
                            oprot writeFieldEnd
                        ].
                    temp504 defaultValidationClass 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'defaultValidationClass';
                                        type:TTypeString;
                                        id:15).
                            iprot writeString:temp504 defaultValidationClass.
                            oprot writeFieldEnd
                        ].
                    temp504 id 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'id';
                                        type:TTypeI32;
                                        id:16).
                            iprot writeI32:temp504 id asInteger.
                            oprot writeFieldEnd
                        ].
                    temp504 minCompactionThreshold 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'minCompactionThreshold';
                                        type:TTypeI32;
                                        id:17).
                            iprot writeI32:temp504 minCompactionThreshold asInteger.
                            oprot writeFieldEnd
                        ].
                    temp504 maxCompactionThreshold 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'maxCompactionThreshold';
                                        type:TTypeI32;
                                        id:18).
                            iprot writeI32:temp504 maxCompactionThreshold asInteger.
                            oprot writeFieldEnd
                        ].
                    temp504 replicateOnWrite 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'replicateOnWrite';
                                        type:TTypeBool;
                                        id:24).
                            iprot writeBool:temp504 replicateOnWrite.
                            oprot writeFieldEnd
                        ].
                    temp504 mergeShardsChance 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'mergeShardsChance';
                                        type:TTypeDouble;
                                        id:25).
                            iprot writeDouble:temp504 mergeShardsChance asFloat.
                            oprot writeFieldEnd
                        ].
                    temp504 keyValidationClass 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'keyValidationClass';
                                        type:TTypeString;
                                        id:26).
                            iprot writeString:temp504 keyValidationClass.
                            oprot writeFieldEnd
                        ].
                    temp504 keyAlias 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'keyAlias';
                                        type:TTypeString;
                                        id:28).
                            iprot writeString:temp504 keyAlias.
                            oprot writeFieldEnd
                        ].
                    temp504 compactionStrategy 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'compactionStrategy';
                                        type:TTypeString;
                                        id:29).
                            iprot writeString:temp504 compactionStrategy.
                            oprot writeFieldEnd
                        ].
                    temp504 compactionStrategyOptions 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'compactionStrategyOptions';
                                        type:TTypeMap;
                                        id:30).
                            [
                                oprot writeMapBegin:((TMap new)
                                            keyType:TTypeString;
                                            valueType:TTypeString;
                                            size:temp504 compactionStrategyOptions size).
                                temp504 compactionStrategyOptions 
                                    keysAndValuesDo:[:temp508 :temp509 | 
                                        iprot writeString:temp508.
                                        iprot writeString:temp509
                                    ].
                                oprot writeMapEnd
                            ] value.
                            oprot writeFieldEnd
                        ].
                    temp504 compressionOptions 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'compressionOptions';
                                        type:TTypeMap;
                                        id:32).
                            [
                                oprot writeMapBegin:((TMap new)
                                            keyType:TTypeString;
                                            valueType:TTypeString;
                                            size:temp504 compressionOptions size).
                                temp504 compressionOptions 
                                    keysAndValuesDo:[:temp510 :temp511 | 
                                        iprot writeString:temp510.
                                        iprot writeString:temp511
                                    ].
                                oprot writeMapEnd
                            ] value.
                            oprot writeFieldEnd
                        ].
                    temp504 bloomFilterFpChance 
                        ifNotNil:[
                            oprot writeFieldBegin:((TField new)
                                        name:'bloomFilterFpChance';
                                        type:TTypeDouble;
                                        id:33).
                            iprot writeDouble:temp504 bloomFilterFpChance asFloat.
                            oprot writeFieldEnd
                        ].
                    oprot
                        writeFieldStop;
                        writeStructEnd
                ] value
            ].
            oprot writeListEnd
        ] value.
        oprot writeFieldEnd.
        ksDef durableWrites 
            ifNotNil:[
                oprot writeFieldBegin:((TField new)
                            name:'durableWrites';
                            type:TTypeBool;
                            id:6).
                iprot writeBool:ksDef durableWrites.
                oprot writeFieldEnd
            ].
        oprot
            writeFieldStop;
            writeStructEnd
    ] value.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
!

sendTruncateCfname:cfname 
    oprot writeMessageBegin:((TCallMessage new)
                name:'truncate';
                seqid:self nextSeqid).
    oprot writeStructBegin:(TStruct new name:'Truncate_args').
    oprot writeFieldBegin:((TField new)
                name:'cfname';
                type:TTypeString;
                id:1).
    iprot writeString:cfname.
    oprot writeFieldEnd.
    oprot
        writeFieldStop;
        writeStructEnd;
        writeMessageEnd.
    oprot transport flush
! !

!CassandraClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CassandraClient.st,v 1.7 2013-03-21 10:47:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__CassandraClient.st,v 1.7 2013-03-21 10:47:01 cg Exp $'
! !

