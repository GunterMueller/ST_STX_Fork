"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

SharedPool subclass:#CassandraConstants
	instanceVariableNames:''
	classVariableNames:'ConsistencyLevel_ONE ConsistencyLevel_QUORUM
		ConsistencyLevel_LOCAL_QUORUM ConsistencyLevel_EACH_QUORUM
		ConsistencyLevel_ALL ConsistencyLevel_ANY ConsistencyLevel_TWO
		ConsistencyLevel_THREE IndexOperator_EQ IndexOperator_GTE
		IndexOperator_GT IndexOperator_LTE IndexOperator_LT VERSION
		IndexType_KEYS IndexType_CUSTOM Compression_GZIP Compression_NONE
		CqlResultType_ROWS CqlResultType_VOID CqlResultType_INT'
	poolDictionaries:''
	category:'DataBase-Cassandra-Handwritten'
!


!CassandraConstants class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    VERSION := #( '19.24.0' ).

    ConsistencyLevel_ONE := 1.
    ConsistencyLevel_QUORUM := 2.
    ConsistencyLevel_LOCAL_QUORUM := 3.
    ConsistencyLevel_EACH_QUORUM := 4.
    ConsistencyLevel_ALL := 5.
    ConsistencyLevel_ANY := 6.
    ConsistencyLevel_TWO := 7.
    ConsistencyLevel_THREE := 8.

    IndexOperator_EQ := 0.
    IndexOperator_GTE := 1.
    IndexOperator_GT := 2.
    IndexOperator_LTE := 3.
    IndexOperator_LT := 4.

    IndexType_KEYS := 0.
    IndexType_CUSTOM := 1.

    Compression_GZIP := 1.
    Compression_NONE := 2.

    CqlResultType_ROWS := 1.
    CqlResultType_VOID := 2.
    CqlResultType_INT := 3.
! !

!CassandraConstants class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/CassandraConstants.st,v 1.3 2013-04-04 22:28:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/CassandraConstants.st,v 1.3 2013-04-04 22:28:04 cg Exp $'
! !


CassandraConstants initialize!
