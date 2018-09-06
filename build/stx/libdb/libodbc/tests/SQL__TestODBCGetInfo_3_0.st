"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestGetInfo subclass:#TestODBCGetInfo_3_0
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Tests-GetInfo'
!

!TestODBCGetInfo_3_0 class methodsFor:'documentation'!

documentation
"
    Tests that we get the right type of info from the GetInfo messages for ODBC level 3

    [author:]
        james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TestODBCGetInfo_3_0 methodsFor:'tests'!

test10_SQL_CREATE_ASSERTION

    self ensureGetInfo:#SQL_CREATE_ASSERTION is:[:aValue |
        aValue isInteger
    ].
!

test11_SQL_CREATE_CHARACTER_SET

    self ensureGetInfo:#SQL_CREATE_CHARACTER_SET is:[:aValue |
        aValue isInteger
    ].
!

test12_SQL_CREATE_COLLATION

    self ensureGetInfo:#SQL_CREATE_COLLATION is:[:aValue |
        aValue isInteger
    ].
!

test13_SQL_CREATE_DOMAIN

    self ensureGetInfo:#SQL_CREATE_DOMAIN is:[:aValue |
        aValue isInteger
    ].
!

test14_SQL_CREATE_SCHEMA

    self ensureGetInfo:#SQL_CREATE_SCHEMA is:[:aValue |
        aValue isInteger
    ].
!

test15_SQL_CREATE_TABLE

    self ensureGetInfo:#SQL_CREATE_TABLE is:[:aValue |
        aValue isInteger
    ].
!

test16_SQL_CREATE_TRANSLATION

    self ensureGetInfo:#SQL_CREATE_TRANSLATION is:[:aValue |
        aValue isInteger
    ].
!

test17_SQL_CREATE_VIEW

    self ensureGetInfo:#SQL_CREATE_VIEW is:[:aValue |
        aValue isInteger
    ].
!

test18_SQL_CURSOR_ROLLBACK_SQL_CURSOR_SENSITIVITY

    self ensureGetInfo:#SQL_CURSOR_ROLLBACK_SQL_CURSOR_SENSITIVITY is:[:aValue |
        aValue isInteger
    ].
!

test19_SQL_DATETIME_LITERALS

    self ensureGetInfo:#SQL_DATETIME_LITERALS is:[:aValue |
        aValue isInteger
    ].
!

test1_SQL_ACTIVE_ENVIRONMENTS
    self ensureGetInfo:#SQL_ACTIVE_ENVIRONMENTS is:[:aValue |
        aValue isBoolean
    ].
!

test20_SQL_DDL_INDEX

    self ensureGetInfo:#SQL_DDL_INDEX is:[:aValue |
        aValue isInteger
    ].
!

test21_SQL_DESCRIBE_PARAMETER

    self ensureGetInfo:#SQL_DESCRIBE_PARAMETER is:[:aValue |
        aValue isBoolean
    ].
!

test22_SQL_DM_VER

    self ensureGetInfo:#SQL_DESCRIBE_PARAMETER is:[:aValue |
        aValue isString
    ].
!

test23_SQL_DRIVER_HDESC

    self ensureGetInfo:#SQL_DRIVER_HDESC is:[:aValue |
        aValue isInteger
    ].
!

test24_SQL_DROP_ASSERTION

    self ensureGetInfo:#SQL_DROP_ASSERTION is:[:aValue |
        aValue isInteger
    ].
!

test25_SQL_DROP_CHARACTER_SET

    self ensureGetInfo:#SQL_DROP_CHARACTER_SET is:[:aValue |
        aValue isInteger
    ].
!

test26_SQL_DROP_COLLATION

    self ensureGetInfo:#SQL_DROP_COLLATION is:[:aValue |
        aValue isInteger
    ].
!

test27_SQL_DROP_DOMAIN

    self ensureGetInfo:#SQL_DROP_DOMAIN is:[:aValue |
        aValue isInteger
    ].
!

test28_SQL_DROP_SCHEMA

    self ensureGetInfo:#SQL_DROP_SCHEMA is:[:aValue |
        aValue isInteger
    ].
!

test29_SQL_DROP_TRANSLATION

    self ensureGetInfo:#SQL_DROP_TRANSLATION is:[:aValue |
        aValue isInteger
    ].
!

test2_SQL_AGGREGATE_FUNCTIONS
    self ensureGetInfo:#SQL_AGGREGATE_FUNCTIONS is:[:aValue |
        false
    ].
!

test30_SQL_DROP_VIEW

    self ensureGetInfo:#SQL_DROP_VIEW is:[:aValue |
        aValue isInteger
    ].
!

test31_SQL_DYNAMIC_CURSOR_ATTRIBUTES1

    self ensureGetInfo:#SQL_DYNAMIC_CURSOR_ATTRIBUTES1 is:[:aValue |
        aValue isInteger
    ].
!

test32_SQL_DYNAMIC_CURSOR_ATTRIBUTES2

    self ensureGetInfo:#SQL_DYNAMIC_CURSOR_ATTRIBUTES2 is:[:aValue |
        aValue isInteger
    ].
!

test33_SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1

    self ensureGetInfo:#SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1 is:[:aValue |
        aValue isInteger
    ].
!

test34_SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2

    self ensureGetInfo:#SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2 is:[:aValue |
        aValue isInteger
    ].
!

test35_SQL_INDEX_KEYWORDS

    self ensureGetInfo:#SQL_INDEX_KEYWORDS is:[:aValue |
        aValue isInteger
    ].
!

test35_SQL_INFO_SCHEMA_VIEWS

    self ensureGetInfo:#SQL_INFO_SCHEMA_VIEWS is:[:aValue |
        aValue isInteger
    ].
!

test35_SQL_INSERT_STATEMENT

    self ensureGetInfo:#SQL_INSERT_STATEMENT is:[:aValue |
        aValue isInteger
    ].
!

test36_SQL_KEYSET_CURSOR_ATTRIBUTES1

    self ensureGetInfo:#SQL_KEYSET_CURSOR_ATTRIBUTES1 is:[:aValue |
        aValue isInteger
    ].
!

test37_SQL_KEYSET_CURSOR_ATTRIBUTES2

    self ensureGetInfo:#SQL_KEYSET_CURSOR_ATTRIBUTES2 is:[:aValue |
        aValue isInteger
    ].
!

test38_SQL_MAX_ASYNC_CONCURRENT_STATEMENTS

    self ensureGetInfo:#SQL_MAX_ASYNC_CONCURRENT_STATEMENTS is:[:aValue |
        aValue isInteger
    ].
!

test39_SQL_MAX_IDENTIFIER_LEN

    self ensureGetInfo:#SQL_MAX_IDENTIFIER_LEN is:[:aValue |
        aValue isInteger
    ].
!

test3_SQL_ALTER_DOMAIN
    self ensureGetInfo:#SQL_ALTER_DOMAIN is:[:aValue |
        false
    ].
!

test40_SQL_MAX_ROW_SIZE_INCLUDES_LONG

    self ensureGetInfo:#SQL_MAX_ROW_SIZE_INCLUDES_LONG is:[:aValue |
        aValue isBoolean
    ].
!

test41_SQL_ODBC_INTERFACE_CONFORMANCE

    self ensureGetInfo:#SQL_ODBC_INTERFACE_CONFORMANCE is:[:aValue |
        aValue isInteger
    ].
!

test42_SQL_PARAM_ARRAY_ROW_COUNTS

    self ensureGetInfo:#SQL_PARAM_ARRAY_ROW_COUNTS is:[:aValue |
        aValue isInteger
    ].
!

test43_SQL_PARAM_ARRAY_SELECTS

    self ensureGetInfo:#SQL_PARAM_ARRAY_SELECTS is:[:aValue |
        aValue isInteger
    ].
!

test44_SQL_SQL92_DATETIME_FUNCTIONS

    self ensureGetInfo:#SQL_SQL92_FOREIGN_KEY_DELETE_RULE is:[:aValue |
        aValue isInteger
    ].
!

test45_SQL_SQL_CONFORMANCE

    self ensureGetInfo:#SQL_SQL_CONFORMANCE is:[:aValue |
        aValue isInteger
    ].
!

test46_SQL_SQL92_FOREIGN_KEY_UPDATE_RULE

    self ensureGetInfo:#SQL_SQL92_FOREIGN_KEY_UPDATE_RULE is:[:aValue |
        aValue isInteger
    ].
!

test47_SQL_SQL92_GRANT

    self ensureGetInfo:#SQL_SQL92_GRANT is:[:aValue |
        aValue isInteger
    ].
!

test48_SQL_SQL92_NUMERIC_VALUE_FUNCTIONS

    self ensureGetInfo:#SQL_SQL92_NUMERIC_VALUE_FUNCTIONS is:[:aValue |
        aValue isInteger
    ].
!

test49_SQL_SQL92_PREDICATES

    self ensureGetInfo:#SQL_SQL92_PREDICATES is:[:aValue |
        aValue isInteger
    ].
!

test4_SQL_ASYNC_MODE
    self ensureGetInfo:#SQL_ASYNC_MODE is:[:aValue |
        #(#'SQL_AM_NONE' #'SQL_AM_STATEMENT' #'SQL_AM_CONNECTION') includes:aValue
    ].
!

test50_SQL_SQL92_RELATIONAL_JOIN_OPERATORS

    self ensureGetInfo:#SQL_SQL92_RELATIONAL_JOIN_OPERATORS is:[:aValue |
        aValue isInteger
    ].
!

test51_SQL_SQL92_REVOKE

    self ensureGetInfo:#SQL_SQL92_REVOKE is:[:aValue |
        aValue isInteger
    ].
!

test52_SQL_SQL92_ROW_VALUE_CONSTRUCTOR

    self ensureGetInfo:#SQL_SQL92_ROW_VALUE_CONSTRUCTOR is:[:aValue |
        aValue isInteger
    ].
!

test53_SQL_SQL92_STRING_FUNCTIONS

    self ensureGetInfo:#SQL_SQL92_STRING_FUNCTIONS is:[:aValue |
        aValue isInteger
    ].
!

test54_SQL_SQL92_VALUE_EXPRESSIONS

    self ensureGetInfo:#SQL_SQL92_VALUE_EXPRESSIONS is:[:aValue |
        aValue isInteger
    ].
!

test55_SQL_STANDARD_CLI_CONFORMANCE

    self ensureGetInfo:#SQL_STANDARD_CLI_CONFORMANCE is:[:aValue |
        aValue isInteger
    ].
!

test56_SQL_STATIC_CURSOR_ATTRIBUTES1

    self ensureGetInfo:#SQL_STATIC_CURSOR_ATTRIBUTES1 is:[:aValue |
        aValue isInteger
    ].
!

test57_SQL_STATIC_CURSOR_ATTRIBUTES2

    self ensureGetInfo:#SQL_STATIC_CURSOR_ATTRIBUTES2 is:[:aValue |
        aValue isInteger
    ].
!

test58_SQL_XOPEN_CLI_YEAR

    self ensureGetInfo:#SQL_XOPEN_CLI_YEAR is:[:aValue |
        aValue isString
    ].
!

test5_SQL_BATCH_ROW_COUNT
    self ensureGetInfo:#SQL_BATCH_ROW_COUNT is:[:aValue |
       false
    ].
!

test6_SQL_BATCH_SUPPORT 
    self ensureGetInfo:#SQL_BATCH_SUPPORT  is:[:aValue |
       false
    ].
!

test7_SQL_QUALIFIER_LOCATION
    self ensureGetInfo:#SQL_QUALIFIER_LOCATION is:[:aValue |
        #(#'SQL_CL_START' '#SQL_CL_END') includes:aValue
    ].
!

test8_SQL_CATALOG_NAME
    self ensureGetInfo:#SQL_CATALOG_NAME is:[:aValue |
        aValue isBoolean
    ].
!

test9_SQL_COLLATION_SEQ
    self ensureGetInfo:#SQL_COLLATION_SEQ is:[:aValue |
        aValue isString
    ].
! !

!TestODBCGetInfo_3_0 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestODBCGetInfo_3_0.st,v 1.3 2005-11-28 10:07:11 cg Exp $'
! !
