"{ Package: 'stx:libdb/nosql/cassandra/tests' }"

TestCase subclass:#CassandraTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'Cassandra::CassandraConstants'
	category:'DataBase-Cassandra-Tests'
!

!CassandraTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        exept

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CassandraTests methodsFor:'misc'!

demoKeyspace
    ^ 'test_sunit_cassandra'
! !

!CassandraTests methodsFor:'tests'!

test00_connect
    "connect, close"
    
    |t|

    t := Time microsecondsToRun: 
            [
                |result client|

                client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.
                client close.
            ].
    Transcript show:'roundTrip time: '; show:t; showCR:' us'

    "
     self run:#test00_connect
     self new test00_connect
    "
!

test01_describeVersion
    "connect, get version, close"
    
    |t|

    t := Time microsecondsToRun: 
            [
                |result client|

                client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.
                result := client describeVersion.
                Transcript showCR:result.
                self assert:(result isString and:[result startsWith:'19.']).
                client close.
            ].
    Transcript show:'roundTrip time: '; show:t; showCR:' us'

    "
     self run:#test01_describeVersion
     self new test01_describeVersion
    "
!

test02_describeClusterName
    "connect, get cluster name, close"
    
    |t|

    t := Time microsecondsToRun: 
            [
                |result client|

                client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.
                result := client describeClusterName.
                Transcript showCR:result.
                self assert:(result isString).
                client close.
            ].
    Transcript show:'roundTrip time: '; show:t; showCR:' us'

    "
     self run:#test02_describeClusterName
     self new test02_describeClusterName
    "
!

test03_describeKeyspaces
    "connect, get keyspaces, close"
    
    |t|

    t := Time microsecondsToRun: 
            [
                |result client systemKeyspace hintsDef|

                client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.
                result := client describeKeyspaces.
                Transcript showCR:result.
                self assert:(result isOrderedCollection).
                systemKeyspace := result detect:[:ks | ks name = 'system'] ifNone:nil.
                self assert:systemKeyspace notNil.
                "/ dont know if this is a good test
                hintsDef := systemKeyspace cfDefs detect:[:ks | ks name = 'hints'] ifNone:nil.
                self assert:(hintsDef notNil).
                self assert:(hintsDef readRepairChance = 0.0).
                self assert:(hintsDef bloomFilterFpChance = 0.01).
                client close.
            ].
    Transcript show:'roundTrip time: '; show:t; showCR:' us'

    "
     self run:#test03_describeKeyspaces
     self new test03_describeKeyspaces
    "
!

test10_createKeyspace
    "connect, create a keyspace, close"
    
    |t|

    t := Time microsecondsToRun: 
            [
                |result client ksName testKeyspace cfDef ksDef|

                ksName := self demoKeyspace.

                client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.

                "/ drop any leftover keyspace
                Cassandra::CassandraError handle:[:ex |    
                ] do:[
                    result := client systemDropKeyspaceKeyspace: ksName.
                ].

                cfDef := Cassandra::CfDef new.
                cfDef keyspace:ksName.
                cfDef name:'cf1'.
                cfDef columnType:'Standard'.
                cfDef comparatorType:'IntegerType'.

                ksDef := Cassandra::KsDef new.
                ksDef name:ksName.
                ksDef durableWrites:true.
                ksDef strategyClass:'org.apache.cassandra.locator.SimpleStrategy'.
                ksDef strategyOptions:(Dictionary withAssociations: { 'replication_factor' -> '1' }).
                ksDef cfDefs:{ cfDef }.

                result := client systemAddKeyspaceKsDef:ksDef.
                client close.
            ].
    Transcript show:'roundTrip time: '; show:t; showCR:' us'

    "
     self run:#test10_createKeyspace
     self new test10_createKeyspace
    "
!

test11_dropKeyspace
    "connect, drop a keyspace, close.
     Must run after test10, which created the keyspace"
    
    |t|

    t := Time microsecondsToRun: 
            [
                |result client ksName testKeyspace cfDef ksDef|

                ksName := self demoKeyspace.

                client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.

                result := client systemDropKeyspaceKeyspace: ksName.
                Transcript showCR:'result is ',result.
                client close.
            ].
    Transcript show:'drop roundTrip time: '; show:t; showCR:' us'

    "
     self run:#test11_dropKeyspace
     self new test11_dropKeyspace
    "
!

test20_insert
    "connect, create a keyspace, insert some data, close."
    
    |t result client ksName parent cfDef ksDef
     timestamp nameColumn ageColumn|

    ksName := self demoKeyspace.

    client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.

    "/ drop any leftover keyspace
    Cassandra::CassandraError handle:[:ex |    
    ] do:[
        result := client systemDropKeyspaceKeyspace: ksName.
    ].

    "/ create a fresh keyspace
    cfDef := Cassandra::CfDef new.
    cfDef keyspace:ksName.
    cfDef name:'Family1'.
    cfDef columnType:'Standard'.
    cfDef comparatorType:'IntegerType'.

    ksDef := Cassandra::KsDef new.
    ksDef name:ksName.
    ksDef durableWrites:true.
    ksDef strategyClass:'org.apache.cassandra.locator.SimpleStrategy'.
    ksDef strategyOptions:(Dictionary withAssociations: { 'replication_factor' -> '1' }).
    ksDef cfDefs:{ cfDef }.

    result := client systemAddKeyspaceKsDef:ksDef.

    client setKeyspaceKeyspace:ksName.

    parent := Cassandra::ColumnParent new columnFamily:'Family1'. 

    timestamp := OperatingSystem getMillisecondTime.

    "/ insert column
    nameColumn := Cassandra::Column new name:'name'.
    nameColumn value:'Fred'.
    nameColumn timestamp: timestamp.
    client 
        insertKey: '1' 
        columnParent: parent 
        column: nameColumn 
        consistencyLevel: ConsistencyLevel_ONE.

    t := Time microsecondsToRun: 
            [
                "/ insert column
                ageColumn := Cassandra::Column new name:'age'.
                ageColumn value:'24'.
                ageColumn timestamp: timestamp.
                client 
                    insertKey: '1' 
                    columnParent: parent 
                    column: ageColumn 
                    consistencyLevel: ConsistencyLevel_ONE.

            ].

    client close.
    Transcript show:'insert time: '; show:t; showCR:' us'

    "
     self run:#test20_insert
     self new test20_insert
    "
!

test21_insertMore
    "connect, insert more data into previous keyspace, close."
    
    |client ksName parent timestamp nameColumn ageColumn|

    ksName := self demoKeyspace.

    client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.

    client setKeyspaceKeyspace:ksName.

    parent := Cassandra::ColumnParent new columnFamily:'Family1'. 

    timestamp := OperatingSystem getMillisecondTime.

    "/ insert column
    nameColumn := Cassandra::Column new name:'name'.
    nameColumn value:'Claus'.
    nameColumn timestamp: timestamp.
    client 
        insertKey: '2' 
        columnParent: parent 
        column: nameColumn 
        consistencyLevel: ConsistencyLevel_ONE.

    "/ insert column
    ageColumn := Cassandra::Column new name:'age'.
    ageColumn value:'54'.
    ageColumn timestamp: timestamp.
    client 
        insertKey: '2' 
        columnParent: parent 
        column: ageColumn 
        consistencyLevel: ConsistencyLevel_ONE.

    client close.

    "
     self run:#test21_insertMore
     self new test21_insertMore
    "
!

test22_get
    "connect, get previously inserted data, close."
    
    |t result1 result2 client ksName path|

    ksName := self demoKeyspace.

    client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.

    client setKeyspaceKeyspace:ksName.

    t := Time microsecondsToRun: 
            [
                path := Cassandra::ColumnPath new.
                path columnFamily:'Family1'.
                path column:'name'.
                result1 := client getKey:'1' columnPath: path consistencyLevel: ConsistencyLevel_ONE.

                path column:'age'.
                result2 := client getKey:'1' columnPath: path consistencyLevel: ConsistencyLevel_ONE.
            ].

    self assert:(result1 notNil).
    self assert:(result1 column notNil).
    self assert:(result1 column name = 'name').
    self assert:(result1 column value = 'Claus').

    self assert:(result2 notNil).
    self assert:(result2 column notNil).
    self assert:(result2 column name = 'age').
    self assert:(result2 column value = '54').

    client close.

    Transcript show:'get time: '; show:t; showCR:' us'

    "
     self run:#test22_get
     self new test22_get
    "
!

test23_getNonExisting
    "connect, get previously inserted data, close."
    
    |t result1 result2 client ksName path|

    ksName := self demoKeyspace.

    client := Cassandra::CassandraClient binaryOnHost:'localhost' port:9160.

    client setKeyspaceKeyspace:ksName.

    t := Time microsecondsToRun: 
            [
                path := Cassandra::ColumnPath new.
                path columnFamily:'Family1'.
                path column:'name'.
                self should:[
                    result1 := client getKey:'xxx' columnPath: path consistencyLevel: ConsistencyLevel_ONE.
                ] raise: Cassandra::NotFoundException.

                path column:'nonexisting'.
                self should:[
                    result2 := client getKey:'1' columnPath: path consistencyLevel: ConsistencyLevel_ONE.
                ] raise: Cassandra::NotFoundException.
            ].

    client close.

    Transcript show:'getNonExisting time: '; show:t; showCR:' us'

    "
     self run:#test23_getNonExisting
     self new test23_getNonExisting
    "
! !

!CassandraTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/tests/CassandraTests.st,v 1.9 2013-03-22 15:07:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/tests/CassandraTests.st,v 1.9 2013-03-22 15:07:35 cg Exp $'
! !

