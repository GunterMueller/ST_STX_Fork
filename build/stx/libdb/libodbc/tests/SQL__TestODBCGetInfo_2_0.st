"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestGetInfo subclass:#TestODBCGetInfo_2_0
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Tests-GetInfo'
!

!TestODBCGetInfo_2_0 class methodsFor:'documentation'!

documentation
"
    Tests that we get the right type of info from the GetInfo messages for ODBC level 2

    [author:]
        james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TestODBCGetInfo_2_0 methodsFor:'tests'!

test10_SQL_GROUP_BY

    self ensureGetInfo:#SQL_GROUP_BY is:[:aValue |
        aValue isInteger
    ].
!

test11_SQL_KEYWORDS

    self ensureGetInfo:#SQL_KEYWORDS is:[:aValue |
        aValue isString
    ].
!

test12_SQL_LIKE_ESCAPE_CLAUSE

    self ensureGetInfo:#SQL_LIKE_ESCAPE_CLAUSE is:[:aValue |
        aValue isBoolean
    ].
!

test13_SQL_MAX_BINARY_LITERAL_LEN

    self ensureGetInfo:#SQL_MAX_BINARY_LITERAL_LEN is:[:aValue |
        aValue isInteger
    ].
!

test14_SQL_MAX_CHAR_LITERAL_LEN

    self ensureGetInfo:#SQL_MAX_CHAR_LITERAL_LEN is:[:aValue |
        aValue isInteger
    ].
!

test15_SQL_MAX_COLUMNS_IN_GROUP_BY

    self ensureGetInfo:#SQL_MAX_COLUMNS_IN_GROUP_BY is:[:aValue |
        aValue isInteger
    ].
!

test16_SQL_MAX_COLUMNS_IN_INDEX

    self ensureGetInfo:#SQL_MAX_COLUMNS_IN_INDEX is:[:aValue |
        aValue isInteger
    ].
!

test17_SQL_MAX_COLUMNS_IN_ORDER_BY

    self ensureGetInfo:#SQL_MAX_COLUMNS_IN_ORDER_BY is:[:aValue |
        aValue isInteger
    ].
!

test18_SQL_MAX_COLUMNS_IN_SELECT

    self ensureGetInfo:#SQL_MAX_COLUMNS_IN_SELECT is:[:aValue |
        aValue isInteger
    ].
!

test19_SQL_MAX_COLUMNS_IN_TABLE

    self ensureGetInfo:#SQL_MAX_COLUMNS_IN_TABLE is:[:aValue |
        aValue isInteger
    ].
!

test1_SQL_ALTER_TABLE
    self ensureGetInfo:#SQL_ALTER_TABLE is:[:aValue |
        aValue isInteger
    ].
!

test20_SQL_MAX_INDEX_SIZE

    self ensureGetInfo:#SQL_MAX_INDEX_SIZE is:[:aValue |
        aValue isInteger
    ].
!

test21_SQL_MAX_ROW_SIZE

    self ensureGetInfo:#SQL_MAX_ROW_SIZE is:[:aValue |
        aValue isInteger
    ].
!

test22_SQL_MAX_STATEMENT_LEN

    self ensureGetInfo:#SQL_MAX_STATEMENT_LEN is:[:aValue |
        aValue isInteger
    ].
!

test23_SQL_MAX_TABLES_IN_SELECT

    self ensureGetInfo:#SQL_MAX_TABLES_IN_SELECT is:[:aValue |
        aValue isInteger
    ].
!

test24_SQL_MAX_USER_NAME_LEN

    self ensureGetInfo:#SQL_MAX_USER_NAME_LEN is:[:aValue |
        aValue isInteger
    ].
!

test25_SQL_NEED_LONG_DATA_LEN

    self ensureGetInfo:#SQL_NEED_LONG_DATA_LEN is:[:aValue |
        aValue isBoolean
    ].
!

test26_SQL_NULL_COLLATION

    self ensureGetInfo:#SQL_NULL_COLLATION is:[:aValue |
        aValue isInteger
    ].
!

test27_SQL_ORDER_BY_COLUMNS_IN_SELECT

    self ensureGetInfo:#SQL_ORDER_BY_COLUMNS_IN_SELECT is:[:aValue |
        aValue isBoolean
    ].
!

test28_SQL_POS_OPERATIONS

    self ensureGetInfo:#SQL_POS_OPERATIONS is:[:aValue |
        aValue isInteger
    ].
!

test28_SQL_QUOTED_IDENTIFIER_CASE

    self ensureGetInfo:#SQL_QUOTED_IDENTIFIER_CASE is:[:aValue |
        aValue isInteger
    ].
!

test29_SQL_SCHEMA_USAGE

    self ensureGetInfo:#SQL_SCHEMA_USAGE is:[:aValue |
        aValue isInteger
    ].
!

test2_SQL_BOOKMARK_PERSISTENCE
    self ensureGetInfo:#SQL_BOOKMARK_PERSISTENCE is:[:aValue |
        aValue isInteger
    ].
!

test30_SQL_SUBQUERIES

    self ensureGetInfo:#SQL_SUBQUERIES is:[:aValue |
        aValue isInteger
    ].
!

test31_SQL_TIMEDATE_ADD_INTERVALS

    self ensureGetInfo:#SQL_TIMEDATE_ADD_INTERVALS is:[:aValue |
        aValue isInteger
    ].
!

test32_SQL_TIMEDATE_DIFF_INTERVALS

    self ensureGetInfo:#SQL_TIMEDATE_DIFF_INTERVALS is:[:aValue |
        aValue isInteger
    ].
!

test33_SQL_UNION

    self ensureGetInfo:#SQL_UNION is:[:aValue |
        aValue isInteger
    ].
!

test3_SQL_CATALOG_LOCATION
    self ensureGetInfo:#SQL_CATALOG_LOCATION is:[:aValue |
        aValue isInteger
    ].
!

test4_SQL_CATALOG_USAGE
    self ensureGetInfo:#SQL_CATALOG_LOCATION is:[:aValue |
        aValue isInteger
    ].
!

test5_SQL_COLUMN_ALIAS
    self ensureGetInfo:#SQL_COLUMN_ALIAS is:[:aValue |
        aValue isBoolean
    ].
!

test6_SQL_DRIVER_HLIB
    self ensureGetInfo:#SQL_DRIVER_HLIB is:[:aValue |
        aValue isInteger
    ].
!

test7_SQL_DRIVER_NAME

    self ensureGetInfo:#SQL_DRIVER_NAME is:[:aValue |
        aValue isString
    ].
!

test8_SQL_FILE_USAGE

    self ensureGetInfo:#SQL_FILE_USAGE is:[:aValue |
        aValue isInteger
    ].
!

test9_SQL_GETDATA_EXTENSIONS

    self ensureGetInfo:#SQL_GETDATA_EXTENSIONS is:[:aValue |
        aValue isInteger
    ].
! !

!TestODBCGetInfo_2_0 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestODBCGetInfo_2_0.st,v 1.3 2005-11-28 10:07:11 cg Exp $'
! !
