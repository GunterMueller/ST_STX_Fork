"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestGetInfo subclass:#TestODBCGetInfo_1_0
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Tests-GetInfo'
!

!TestODBCGetInfo_1_0 class methodsFor:'documentation'!

documentation
"
    Tests that we get the right type of info from the GetInfo messages for ODBC level 1

    [author:]
        james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 25-11-2005 / 14:16:08 / james"
! !

!TestODBCGetInfo_1_0 methodsFor:'tests'!

test10_SQL_CURSOR_ROLLBACK_BEHAVIOR

    self ensureGetInfo:#SQL_CURSOR_ROLLBACK_BEHAVIOR is:[:aValue |
        aValue isInteger
    ].
!

test11_SQL_CURSOR_ROLLBACK_BEHAVIOR

    self ensureGetInfo:#SQL_DATA_SOURCE_NAME is:[:aValue |
        aValue isString
    ].
!

test12_SQL_DATA_SOURCE_READ_ONLY

    self ensureGetInfo:#SQL_DATA_SOURCE_READ_ONLY is:[:aValue |
        aValue isBoolean
    ].
!

test13_SQL_DATABASE_NAME

    self ensureGetInfo:#SQL_DATABASE_NAME is:[:aValue |
        aValue isString
    ].
!

test14_SQL_DBMS_NAME

    self ensureGetInfo:#SQL_DBMS_NAME is:[:aValue |
        aValue isString
    ].
!

test15_SQL_DBMS_VER

    self ensureGetInfo:#SQL_DBMS_VER is:[:aValue |
        aValue isString
    ].
!

test16_SQL_DEFAULT_TXN_ISOLATION

    self ensureGetInfo:#SQL_DEFAULT_TXN_ISOLATION is:[:aValue |
        aValue isInteger
    ].
!

test17_SQL_DRIVER_HDBC

    self ensureGetInfo:#SQL_DRIVER_HDBC is:[:aValue |
        aValue isInteger
    ].
!

test18_SQL_DRIVER_HENV

    self ensureGetInfo:#SQL_DRIVER_HENV is:[:aValue |
        aValue isInteger
    ].
!

test19_SQL_DRIVER_HSTMT

    self ensureGetInfo:#SQL_DRIVER_HSTMT is:[:aValue |
        aValue isInteger
    ].
!

test1_SQL_ACCESSIBLE_PROCEDURES
    self ensureGetInfo:#SQL_ACCESSIBLE_PROCEDURES is:[:aValue |
        aValue isBoolean
    ].
!

test20_SQL_DRIVER_ODBC_VER

    self ensureGetInfo:#SQL_DRIVER_ODBC_VER is:[:aValue |
        aValue isString
    ].
!

test21_SQL_DRIVER_VER

    self ensureGetInfo:#SQL_DRIVER_VER is:[:aValue |
        aValue isString
    ].
!

test22_SQL_EXPRESSIONS_IN_ORDERBY

    self ensureGetInfo:#SQL_EXPRESSIONS_IN_ORDERBY is:[:aValue |
        aValue isBoolean
    ].
!

test23_SQL_IDENTIFIER_CASE

    self ensureGetInfo:#SQL_IDENTIFIER_CASE is:[:aValue |
        aValue isInteger
    ].
!

test23_SQL_IDENTIFIER_QUOTE_CHAR

    self ensureGetInfo:#SQL_IDENTIFIER_QUOTE_CHAR is:[:aValue |
        aValue isString
    ].
!

test24_SQL_INTEGRITY

    self ensureGetInfo:#SQL_INTEGRITY is:[:aValue |
        aValue isBoolean
    ].
!

test25_SQL_MAX_CATALOG_NAME_LEN

    self ensureGetInfo:#SQL_MAX_CATALOG_NAME_LEN is:[:aValue |
        aValue isInteger
    ].
!

test26_SQL_MAX_COLUMN_NAME_LEN

    self ensureGetInfo:#SQL_MAX_COLUMN_NAME_LEN is:[:aValue |
        aValue isInteger
    ].
!

test27_SQL_MAX_CONCURRENT_ACTIVITIES

    self ensureGetInfo:#SQL_MAX_CONCURRENT_ACTIVITIES is:[:aValue |
        aValue isInteger
    ].
!

test28_SQL_MAX_CURSOR_NAME_LEN

    self ensureGetInfo:#SQL_MAX_CURSOR_NAME_LEN is:[:aValue |
        aValue isInteger
    ].
!

test29_SQL_MAX_DRIVER_CONNECTIONS

    self ensureGetInfo:#SQL_MAX_DRIVER_CONNECTIONS is:[:aValue |
        aValue isInteger
    ].
!

test2_SQL_ACCESSIBLE_TABLES

    self ensureGetInfo:#SQL_ACCESSIBLE_TABLES is:[:aValue |
        aValue isBoolean
    ].
!

test30_SQL_MAX_PROCEDURE_NAME_LEN

    self ensureGetInfo:#SQL_MAX_PROCEDURE_NAME_LEN is:[:aValue |
        aValue isInteger
    ].
!

test31_SQL_MAX_SCHEMA_NAME_LEN

    self ensureGetInfo:#SQL_MAX_SCHEMA_NAME_LEN is:[:aValue |
        aValue isInteger
    ].
!

test32_SQL_MAX_TABLE_NAME_LEN

    self ensureGetInfo:#SQL_MAX_TABLE_NAME_LEN is:[:aValue |
        aValue isInteger
    ].
!

test33_SQL_MULT_RESULT_SETS

    self ensureGetInfo:#SQL_MULT_RESULT_SETS is:[:aValue |
        aValue isBoolean
    ].
!

test34_SQL_MULTIPLE_ACTIVE_TXN

    self ensureGetInfo:#SQL_MULTIPLE_ACTIVE_TXN is:[:aValue |
        aValue isBoolean
    ].
!

test35_SQL_NON_NULLABLE_COLUMNS

    self ensureGetInfo:#SQL_NON_NULLABLE_COLUMNS is:[:aValue |
        aValue isInteger
    ].
!

test36_SQL_NUMERIC_FUNCTIONS

    self ensureGetInfo:#SQL_NUMERIC_FUNCTIONS is:[:aValue |
        aValue isInteger
    ].
!

test37_SQL_ODBC_VER

    self ensureGetInfo:#SQL_ODBC_VER is:[:aValue |
        aValue isString
    ].
!

test38_SQL_PROCEDURE_TERM

    self ensureGetInfo:#SQL_PROCEDURE_TERM is:[:aValue |
        aValue isString
    ].
!

test39_SQL_PROCEDURES

    self ensureGetInfo:#SQL_PROCEDURES is:[:aValue |
        aValue isBoolean
    ].
!

test3_SQL_CATALOG_NAME_SEPARATOR

    self ensureGetInfo:#SQL_CATALOG_NAME_SEPARATOR is:[:aValue |
        aValue isString
    ].
!

test40_SQL_ROW_UPDATES

    self ensureGetInfo:#SQL_ROW_UPDATES is:[:aValue |
        aValue isBoolean
    ].
!

test41_SQL_SCHEMA_TERM

    self ensureGetInfo:#SQL_SCHEMA_TERM is:[:aValue |
        aValue isString
    ].
!

test42_SQL_SCROLL_OPTIONS

    self ensureGetInfo:#SQL_SCROLL_OPTIONS is:[:aValue |
        aValue isInteger
    ].
!

test42_SQL_SEARCH_PATTERN_ESCAPE

    self ensureGetInfo:#SQL_SEARCH_PATTERN_ESCAPE is:[:aValue |
        aValue isString
    ].
!

test43_SQL_SERVER_NAME

    self ensureGetInfo:#SQL_SERVER_NAME is:[:aValue |
        aValue isString
    ].
!

test43_SQL_SPECIAL_CHARACTERS

    self ensureGetInfo:#SQL_SPECIAL_CHARACTERS is:[:aValue |
        aValue isString
    ].
!

test44_SQL_STRING_FUNCTIONS

    self ensureGetInfo:#SQL_STRING_FUNCTIONS is:[:aValue |
        aValue isInteger
    ].
!

test45_SQL_SYSTEM_FUNCTIONS

    self ensureGetInfo:#SQL_SYSTEM_FUNCTIONS is:[:aValue |
        aValue isInteger
    ].
!

test46_SQL_TABLE_TERM

    self ensureGetInfo:#SQL_TABLE_TERM is:[:aValue |
        aValue isString
    ].
!

test47_SQL_TIMEDATE_FUNCTIONS

    self ensureGetInfo:#SQL_TIMEDATE_FUNCTIONS is:[:aValue |
        aValue isInteger
    ].
!

test48_SQL_TXN_CAPABLE

    self ensureGetInfo:#SQL_TXN_CAPABLE is:[:aValue |
        aValue isInteger
    ].
!

test49_SQL_TXN_ISOLATION_OPTION

    self ensureGetInfo:#SQL_TXN_ISOLATION_OPTION is:[:aValue |
        aValue isInteger
    ].
!

test4_SQL_CATALOG_TERM

    self ensureGetInfo:#SQL_CATALOG_TERM is:[:aValue |
        aValue isString
    ].
!

test50_SQL_USER_NAME

    self ensureGetInfo:#SQL_USER_NAME is:[:aValue |
        aValue isString
    ].
!

test5_SQL_CONCAT_NULL_BEHAVIOR

    self ensureGetInfo:#SQL_CONCAT_NULL_BEHAVIOR is:[:aValue |
        aValue isInteger
    ].
!

test6_CONVERT
    #(
         #SQL_CONVERT_BIGINT
         #SQL_CONVERT_BINARY
         #SQL_CONVERT_BIT
         #SQL_CONVERT_CHAR
         #SQL_CONVERT_GUID
         #SQL_CONVERT_DATE
         #SQL_CONVERT_DECIMAL
         #SQL_CONVERT_DOUBLE
         #SQL_CONVERT_FLOAT
         #SQL_CONVERT_INTEGER
         #SQL_CONVERT_INTERVAL_YEAR_MONTH
         #SQL_CONVERT_INTERVAL_DAY_TIME
         #SQL_CONVERT_LONGVARBINARY
         #SQL_CONVERT_LONGVARCHAR
         #SQL_CONVERT_NUMERIC
         #SQL_CONVERT_REAL
         #SQL_CONVERT_SMALLINT
         #SQL_CONVERT_TIME
         #SQL_CONVERT_TIMESTAMP
         #SQL_CONVERT_TINYINT
         #SQL_CONVERT_VARBINARY
         #SQL_CONVERT_VARCHAR
    ) do:[:aSymbol |
        self ensureGetInfo:aSymbol is:[:aValue |
            aValue isInteger
        ].
    ].
!

test7_SQL_CONVERT_FUNCTIONS

    self ensureGetInfo:#SQL_CONVERT_FUNCTIONS is:[:aValue |
        aValue isInteger
    ].

"
bitmasks supported:

SQL_FN_CVT_CAST
SQL_FN_CVT_CONVERT
"
!

test8_SQL_CORRELATION_NAME

    self ensureGetInfo:#SQL_CORRELATION_NAME is:[:aValue |
        aValue isInteger
    ].



"
An SQLUSMALLINT value indicating whether table correlation names are supported:

SQL_CN_NONE = Correlation names are not supported.

SQL_CN_DIFFERENT = Correlation names are supported but must differ from the names of the tables they represent.

SQL_CN_ANY = Correlation names are supported and can be any valid user-defined name.
"
!

test9_SQL_CURSOR_COMMIT_BEHAVIOR

    self ensureGetInfo:#SQL_CURSOR_COMMIT_BEHAVIOR is:[:aValue |
        aValue isInteger
    ].
! !

!TestODBCGetInfo_1_0 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestODBCGetInfo_1_0.st,v 1.3 2005-11-28 10:07:11 cg Exp $'
! !
