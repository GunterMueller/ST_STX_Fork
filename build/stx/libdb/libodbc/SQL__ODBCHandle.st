"
 COPYRIGHT (c) 2004 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb/libodbc' }"

"{ NameSpace: SQL }"

DatabaseHandle subclass:#ODBCHandle
	instanceVariableNames:''
	classVariableNames:'DebugFlag SQL_SUCCESS SQL_SUCCESS_WITH_INFO SQL_ERROR
		SQL_STILL_EXECUTING SQL_NO_DATA SQL_NEED_DATA SQL_INVALID_HANDLE
		SQL_CONTINUE SQL_UNKNOWN Unthreaded'
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

ODBCHandle subclass:#ODBCDatabaseHandle
	instanceVariableNames:'connected'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCHandle
!

ODBCHandle subclass:#ODBCEnvironmentHandle
	instanceVariableNames:''
	classVariableNames:'HandleRegistry'
	poolDictionaries:''
	privateIn:ODBCHandle
!

ODBCHandle subclass:#ODBCStatementHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCHandle
!

!ODBCHandle primitiveDefinitions!
%{
/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */
#define __NEED_MALLOC_H__
#include "stxOSDefs.h"
#include <errno.h>

#if 0 && defined(__GNUC__) && !defined(__osx__)
# ifndef __INLINE__
#  define __INLINE__  inline
# endif
#endif

#ifndef __INLINE__
# define __INLINE__ /* */
#endif

#ifdef ADABAS
# include "WINDOWS.H"
# include "sql.h"
# include "sqlext.h"
# define THE_DB         ADABAS
# define THE_DB_NAME    "Adabas"
# define ODBC_NAME      "Adabas-ODBC"
#endif /* ADABAS */

#ifdef SYBASE
# include "unixodbc.h"
# define THE_DB         SYBASE
# define THE_DB_NAME    "Sybase"
# define ODBC_NAME      "Sybase-ODBC"
#endif /* SYBASE */

#if defined(MYODBC) || defined(PSQLODBC) || defined(LIBODBCTXT) || defined(UNIXODBC) || defined(IODBC) || defined(OSXODBC)
/*
 * sorry - these include files define true/false,
 * which is req'd in smalltalk.
 * The following fixes this.
 */
# undef true
# define true SQL_true
# undef false
# define false SQL_false

# include <sql.h>
# include <sqlext.h>

# ifdef __DEF_true
#  undef true
#  define true __DEF_true
# endif
# ifdef __DEF_false
#  undef false
#  define false __DEF_false
# endif

# ifdef LIBODBCTXT
#  define THE_DB        LIBODBCTXT
#  define THE_DB_NAME   "ODBCText"
#  define ODBC_NAME     "ODBCText"
# endif

# ifdef IODBC
#  define THE_DB         GENERIC
#  define THE_DB_NAME   "Generic"
#  define ODBC_NAME     "iODBC"
#  define HAS_SQLDrivers
#  define HAS_SQLDataSources
# endif

# ifdef MYODBC
#  define THE_DB        MYSQL
#  define THE_DB_NAME   "MySQL"
#  define ODBC_NAME     "myODBC"
# endif

# ifdef PSQLODBC
#  define THE_DB        POSTGRESQL
#  define THE_DB_NAME   "PostgreSQL"
#  define ODBC_NAME     "psql-ODBC"
#  define HAS_SQLDataSources
# endif

# ifdef UNIXODBC
/* using the unixodbc library */
#  define THE_DB        GENERIC
#  define THE_DB_NAME   "Generic"
#  define ODBC_NAME     "unixODBC"
#  define HAS_SQLDrivers
#  define HAS_SQLDataSources
#  ifndef __osx__
#   include <odbcinst.h>
#   define HAS_SQLGetPrivateProfileString
#   define HAS_SQLWritePrivateProfileString
#  endif
#  define xxNEED_PTHREAD_INITIALIZE
# endif

# ifdef OSXODBC
/* using the system-provided odbc library */
#  define THE_DB        GENERIC
#  define THE_DB_NAME   "Generic"
#  define ODBC_NAME     "osxODBC"
#  define HAS_SQLDrivers
#  define HAS_SQLDataSources
#  define xxHAS_SQLGetPrivateProfileString
#  define xxHAS_SQLWritePrivateProfileString
#  define xxNEED_PTHREAD_INITIALIZE
# endif


#endif /* any ODBC */

/* maximum lenth of a user name or password */
#define STXSQL_MAX_NAME_LEN   64

#if defined( WIN32 ) || defined( __win32__ )
# define THE_DB         GENERIC
# define THE_DB_NAME   "Generic"
# define ODBC_NAME     "msODBC"
# define HAS_SQLDrivers
# define HAS_SQLDataSources

# undef INT
# define INT WIN_INT
# undef Array
# define Array WIN_Array
# ifdef Number
#  undef Number
#  define Number WIN_Number
# endif
# undef Method
# define Method WIN_Method
# undef Point
# define Point WIN_Point
# undef Rectangle
# define Rectangle WIN_Rectangle
# undef True
# define True WIN_True
# undef False
# define False WIN_False
# undef true
# define true WIN_true
# undef false
# define false WIN_false
# undef Block
# define Block WIN_Block
# undef Context
# define Context WIN_Context
# undef Date
# define Date WIN_Date
# undef Delay
# define Delay WIN_Delay

# ifdef __BORLANDC__
#  define NOATOM
#  define NOGDICAPMASKS
#  define NOMETAFILE
#  define NOMINMAX
#  define NOOPENFILE
#  define NOSOUND
#  define NOWH
#  define NOCOMM
#  define NOKANJI
#  define NOCRYPT
#  define NOMCX
#  define WIN32_LEAN_AND_MEAN
#  include <windows.h>
# else /* MFC */
# endif /* __BORLANDC__ */

# include "sql.h"
# include "sqlext.h"
// # include "odbcinst.h"

# ifdef __DEF_Array
#  undef Array
#  define Array __DEF_Array
# endif

# ifdef __DEF_Number
#  undef Number
#  define Number __DEF_Number
# else
#  undef Number
# endif

# ifdef __DEF_Method
#  undef Method
#  define Method __DEF_Method
# else
#  undef Method
# endif

# ifdef __DEF_Point
#  undef Point
#  define Point __DEF_Point
# else
#  undef Point
# endif

# ifdef __DEF_Rectangle
#  undef Rectangle
#  define Rectangle __DEF_Rectangle
# else
#  undef Rectangle
# endif

# ifdef __DEF_true
#  undef true
#  define true __DEF_true
# else
#  undef true
# endif

# ifdef __DEF_false
#  undef false
#  define false __DEF_false
# else
#  undef false
# endif

# ifdef __DEF_True
#  undef True
#  define True __DEF_True
# else
#  undef True
# endif

# ifdef __DEF_False
#  undef False
#  define False __DEF_False
# else
#  undef False
# endif

# ifdef __DEF_Block
#  undef Block
# define Block __DEF_Block
# endif
# ifdef __DEF_Context
#  undef Context
#  define Context __DEF_Context
# endif
# ifdef __DEF_Date
#  undef Date
#  define Date __DEF_Date
# endif
# ifdef __DEF_Delay
#  undef Delay
#  define Delay __DEF_Delay
# endif

# undef INT
# define INT STX_INT
# undef UINT
# define UINT STX_UINT

# define THREADED_CALLS

#endif /* WIN32 */


#ifndef THE_DB
 /*
  * the line below will lead to a compilation error
  */
# error you_must_define_a_Database (any of UNIXODBC, MYODBC, ADABAS, SYBASE or MYSQL)
#endif

#if defined(ODBCVER)
# if (ODBCVER >= 0x0300)
#  define HAS_ODBC_V3
# endif
#endif

#if defined(HAS_ODBC_V3)
# define USE_ODBC_V3
#endif

#include <stdio.h>
#include <string.h>

#define TRACE(x)        \
    if (@global(SQL::ODBCHandle:DebugFlag) == true) { \
	fprintf x; \
    }

/*
 * check if something is a HENV / HDBC / HSTMT
 */
#define __isExternalLong(x) (__isNonNilObject(x) && __qClass(x) == @global(ExternalLong))
#define __isHENV(x)  (__isNonNilObject(x) && __qClass(x) == @global(SQL::ODBCHandle::ODBCEnvironmentHandle))
#define __isHDBC(x)  (__isNonNilObject(x) && __qClass(x) == @global(SQL::ODBCHandle::ODBCDatabaseHandle))
#define __isHSTMT(x) (__isNonNilObject(x) && __qClass(x) == @global(SQL::ODBCHandle::ODBCStatementHandle))
#define __isDESC(x)  (__isNonNilObject(x) && __qClass(x) == @global(SQL::ODBCHandle::ODBCDescriptorHandle))

/*
 * check stARg for being a smallInt;
 * deposit value in cVar if so.
 */
#define INT_ARG(stArg, cVar) \
	if (__isSmallInteger(stArg)) { \
	    cVar = __intVal(stArg); \
	} else { \
	    TRACE((stderr, "int-arg expected\n")); \
	    goto badArg; \
	}

/*
 * check stARg for being a smallInt or #SQL_NTS;
 * deposit value in cVar if so.
 */
#define INT_OR_NTS_ARG(stArg, cVar) \
	if (stArg == @symbol(SQL_NTS)) { \
	    cVar = SQL_NTS; \
	} else { \
	    INT_ARG(stArg, cVar); \
	}

/*
 * check stARg for being a string;
 * deposit char*-value in cVar if so.
 */
#define STRING_ARG(stArg, cVar, cSize) \
	if (__isStringLike(stArg)) { \
	    cVar = __stringVal(stArg); \
	    cSize = __stringSize(stArg); \
	} else { \
	    TRACE((stderr, "string arg expected\n")); \
	    goto badArg; \
	}

/*
 * check stARg for being a string or #NULL;
 * deposit char*-value in cVar if so.
 */
#define STRING_NULL_ARG(stArg, cVar, cSize) \
	if (stArg == nil) { \
	    cVar = NULL; \
	    cSize = 0; \
	} else { \
	    STRING_ARG(stArg, cVar, cSize) \
	}

/*
 * check stARg for being a Unicode16String;
 * deposit wchar*-value in cVar if so.
 */
#define UNICODE16_STRING_ARG(stArg, cVar, cSize) \
	if (__isUnicode16String(stArg)) { \
	    cVar = (SQLWCHAR  *)__unicode16StringVal(stArg); \
	    cSize = __unicode16StringSize(stArg); \
	} else { \
	    TRACE((stderr, "Unicode16String arg expected\n")); \
	    goto badArg; \
	}

/*
 * check stARg for being a Unicode16String or #NULL;
 * deposit wchar*-value in cVar if so.
 */
#define UNICODE16_STRING_NULL_ARG(stArg, cVar, cSize) \
	if (stArg == nil) { \
	    cVar = NULL; \
	    cSize = 0; \
	} else { \
	    UNICODE16_STRING_ARG(stArg, cVar, cSize) \
	}

#define __cTypeString(cType) (__symbolVal(__cTypeSymbol(cType)))
#define __sqlTypeString(cType) (__symbolVal(__sqlTypeSymbol(cType)))


#ifdef __INCREMENTAL_COMPILE__

__INLINE__ OBJ
__odbcReturnCode(SQLRETURN __retCode)
{
    switch (__retCode) {
	case SQL_SUCCESS:           return(@global(SQL_SUCCESS));
	case SQL_SUCCESS_WITH_INFO: return(@global(SQL_SUCCESS_WITH_INFO));
	case SQL_ERROR:             return(@global(SQL_ERROR));
	case SQL_STILL_EXECUTING:   return(@global(SQL_STILL_EXECUTING));
	case SQL_NEED_DATA:         return(@global(SQL_NEED_DATA));
	case SQL_INVALID_HANDLE:    return(@global(SQL_INVALID_HANDLE));
# if defined(SQL_NO_DATA)
	case SQL_NO_DATA:           return(@global(SQL_NO_DATA));
# endif
# ifdef SQL_CONTINUE
	case SQL_CONTINUE:          return(@global(SQL_CONTINUE));
# endif
# if defined(SQL_NO_DATA_FOUND) && (SQL_NO_DATA_FOUND != SQL_NO_DATA)
	case SQL_NO_DATA_FOUND:     return(@global(SQL_NO_DATA));
# endif
	default:                    return(@global(UnknownReturnCode));
    }
}

__INLINE__ char *
__returnCodeString(SQLRETURN __retCode)
{
    switch (__retCode) {
	case SQL_SUCCESS:           return("SQL_SUCCESS");
	case SQL_SUCCESS_WITH_INFO: return("SQL_SUCCESS_WITH_INFO");
	case SQL_STILL_EXECUTING:   return("SQL_STILL_EXECUTING");
	case SQL_ERROR:             return("SQL_ERROR");
	case SQL_INVALID_HANDLE:    return("SQL_INVALID_HANDLE");
	case SQL_NEED_DATA:         return("SQL_NEED_DATA");
# ifdef SQL_NO_DATA
	case SQL_NO_DATA:           return("SQL_NO_DATA");
# endif
# ifdef SQL_CONTINUE
	case SQL_CONTINUE:          return("SQL_CONTINUE");
# endif
# if defined(SQL_NO_DATA_FOUND) && (SQL_NO_DATA_FOUND != SQL_NO_DATA)
	case SQL_NO_DATA_FOUND:     return("SQL_NO_DATA");
# endif
	default:                    return("UnknownReturnCode");
    }
}

__INLINE__ OBJ
__cTypeSymbol(int cType)
{
    switch (cType) {
	case SQL_C_SHORT:           return(@symbol(SQL_C_SHORT));
	case SQL_C_LONG:            return(@symbol(SQL_C_LONG));
	case SQL_C_CHAR:            return(@symbol(SQL_C_CHAR));
	case SQL_C_SBIGINT:         return(@symbol(SQL_C_SBIGINT));
	case SQL_C_UBIGINT:         return(@symbol(SQL_C_UBIGINT));
	case SQL_C_FLOAT:           return(@symbol(SQL_C_FLOAT));
	case SQL_C_DOUBLE:          return(@symbol(SQL_C_DOUBLE));
	case SQL_C_DATE:            return(@symbol(SQL_C_DATE));
	case SQL_C_TIME:            return(@symbol(SQL_C_TIME));
	case SQL_C_TIMESTAMP:       return(@symbol(SQL_C_TIMESTAMP));
	case SQL_C_GUID:            return(@symbol(SQL_C_GUID));
	case SQL_C_BINARY:          return(@symbol(SQL_C_BINARY));
#ifdef SQL_C_WCHAR
	case SQL_C_WCHAR:           return(@symbol(SQL_C_WCHAR));
#endif
	default:                    return(@symbol(other));
    }
}

__INLINE__ OBJ
__sqlTypeSymbol(int sqlType)
{
    switch (sqlType) {
	case SQL_INTEGER:           return(@symbol(SQL_INTEGER));
	case SQL_SMALLINT:          return(@symbol(SQL_SMALLINT));
	case SQL_CHAR:              return(@symbol(SQL_CHAR));
	case SQL_VARCHAR:           return(@symbol(SQL_VARCHAR));
#if defined(SQL_WCHAR)
	case SQL_WCHAR:             return(@symbol(SQL_WCHAR));
#endif
	case SQL_FLOAT:             return(@symbol(SQL_FLOAT));
	case SQL_DOUBLE:            return(@symbol(SQL_DOUBLE));
	case SQL_REAL:              return(@symbol(SQL_REAL));
	case SQL_NUMERIC:           return(@symbol(SQL_NUMERIC));
	case SQL_DECIMAL:           return(@symbol(SQL_DECIMAL));
	case SQL_BIGINT:            return(@symbol(SQL_BIGINT));
	case SQL_DATE:              return(@symbol(SQL_DATE));
#ifdef SQL_TYPE_DATE
	case SQL_TYPE_DATE:         return(@symbol(SQL_TYPE_DATE));
#endif
	case SQL_TIME:              return(@symbol(SQL_TIME));
	case SQL_TYPE_TIME:         return(@symbol(SQL_TYPE_TIME));
	case SQL_TIMESTAMP:         return(@symbol(SQL_TIMESTAMP));
#ifdef SQL_TYPE_TIMESTAMP
	case SQL_TYPE_TIMESTAMP:    return(@symbol(SQL_TYPE_TIMESTAMP));
#endif
#if defined(SQL_DATETIME) && (SQL_DATETIME != SQL_TIMESTAMP) && (SQL_DATETIME != SQL_DATE)
	case SQL_DATETIME:          return(@symbol(SQL_DATETIME));
#endif
	case SQL_BINARY:            return(@symbol(SQL_BINARY));
	case SQL_VARBINARY:         return(@symbol(SQL_VARBINARY));
	case SQL_LONGVARBINARY:     return(@symbol(SQL_LONGVARBINARY));
	case SQL_BIT:               return(@symbol(SQL_BIT));
	case SQL_GUID:              return(@symbol(SQL_GUID));
# ifdef SQL_WVARCHAR
	case SQL_WVARCHAR:          return(@symbol(SQL_WVARCHAR));
# endif
# ifdef SQL_WLONGVARCHAR
	case SQL_WLONGVARCHAR:      return(@symbol(SQL_WLONGVARCHAR));
# endif
	default:                    return(@symbol(other));
    }
}

#endif /* __INCREMENTAL_COMPILE__ */
%}
! !

!ODBCHandle primitiveFunctions!
%{

/*
 * any local C (helper) functions
 * come here (please, define as static)
 */

#ifndef __INCREMENTAL_COMPILE__

static OBJ
__odbcReturnCode(SQLRETURN __retCode)
{
    switch (__retCode) {
	case SQL_SUCCESS:           return(@global(SQL_SUCCESS));
	case SQL_SUCCESS_WITH_INFO: return(@global(SQL_SUCCESS_WITH_INFO));
	case SQL_ERROR:             return(@global(SQL_ERROR));
	case SQL_STILL_EXECUTING:   return(@global(SQL_STILL_EXECUTING));
	case SQL_NEED_DATA:         return(@global(SQL_NEED_DATA));
	case SQL_INVALID_HANDLE:    return(@global(SQL_INVALID_HANDLE));
# if defined(SQL_NO_DATA)
	case SQL_NO_DATA:           return(@global(SQL_NO_DATA));
# endif
# ifdef SQL_CONTINUE
	case SQL_CONTINUE:          return(@global(SQL_CONTINUE));
# endif
# if defined(SQL_NO_DATA_FOUND) && (SQL_NO_DATA_FOUND != SQL_NO_DATA)
	case SQL_NO_DATA_FOUND:     return(@global(SQL_NO_DATA));
# endif
	default:                    return(@global(UnknownReturnCode));
    }
}

void
__printErrors(SQLHANDLE handle, SQLSMALLINT type)
{
    SQLINTEGER i = 0;
    SQLINTEGER native;
    SQLCHAR state[ 7 ];
    SQLCHAR text[256];
    SQLSMALLINT len;
    SQLRETURN ret;
    // fprintf(stderr, "Just before loop \n");
    do {
      // printf("In loop %d\n" i);
      ret = SQLGetDiagRec(type, handle, ++i, state, &native, text,
      sizeof(text), &len );
      if (SQL_SUCCEEDED(ret)){
	 fprintf(stderr, "%s:%"_ld_":%"_ld_":%s\n", state, (INT)i, (INT)native, text);
      }
    } while( ret == SQL_SUCCESS );
    // fprintf(stderr, "end loop \n");
 }

char *
__returnCodeString(SQLRETURN __retCode)
{
    switch (__retCode) {
	case SQL_SUCCESS:           return("SQL_SUCCESS");
	case SQL_SUCCESS_WITH_INFO: return("SQL_SUCCESS_WITH_INFO");
	case SQL_STILL_EXECUTING:   return("SQL_STILL_EXECUTING");
	case SQL_ERROR:             return("SQL_ERROR");
	case SQL_INVALID_HANDLE:    return("SQL_INVALID_HANDLE");
	case SQL_NEED_DATA:         return("SQL_NEED_DATA");
# ifdef SQL_NO_DATA
	case SQL_NO_DATA:           return("SQL_NO_DATA");
# endif
# ifdef SQL_CONTINUE
	case SQL_CONTINUE:          return("SQL_CONTINUE");
# endif
# if defined(SQL_NO_DATA_FOUND) && (SQL_NO_DATA_FOUND != SQL_NO_DATA)
	case SQL_NO_DATA_FOUND:     return("SQL_NO_DATA");
# endif
	default:                    return("UnknownReturnCode");
    }
}

OBJ
__cTypeSymbol(int cType)
{
    switch (cType) {
	case SQL_C_SHORT:           return(@symbol(SQL_C_SHORT));
	case SQL_C_LONG:            return(@symbol(SQL_C_LONG));
	case SQL_C_CHAR:            return(@symbol(SQL_C_CHAR));
	case SQL_C_SBIGINT:         return(@symbol(SQL_C_SBIGINT));
	case SQL_C_UBIGINT:         return(@symbol(SQL_C_UBIGINT));
	case SQL_C_FLOAT:           return(@symbol(SQL_C_FLOAT));
	case SQL_C_DOUBLE:          return(@symbol(SQL_C_DOUBLE));
	case SQL_C_DATE:            return(@symbol(SQL_C_DATE));
	case SQL_C_TIME:            return(@symbol(SQL_C_TIME));
	case SQL_C_TIMESTAMP:       return(@symbol(SQL_C_TIMESTAMP));
	case SQL_C_GUID:            return(@symbol(SQL_C_GUID));
	case SQL_C_BINARY:          return(@symbol(SQL_C_BINARY));
#ifdef SQL_C_WCHAR
	case SQL_C_WCHAR:           return(@symbol(SQL_C_WCHAR));
#endif
	default:                    return(@symbol(other));
    }
}

OBJ
__sqlTypeSymbol(int sqlType)
{
    switch (sqlType) {
	case SQL_INTEGER:           return(@symbol(SQL_INTEGER));
	case SQL_SMALLINT:          return(@symbol(SQL_SMALLINT));
	case SQL_CHAR:              return(@symbol(SQL_CHAR));
	case SQL_VARCHAR:           return(@symbol(SQL_VARCHAR));
#if defined(SQL_WCHAR)
	case SQL_WCHAR:             return(@symbol(SQL_WCHAR));
#endif
	case SQL_FLOAT:             return(@symbol(SQL_FLOAT));
	case SQL_DOUBLE:            return(@symbol(SQL_DOUBLE));
	case SQL_REAL:              return(@symbol(SQL_REAL));
	case SQL_NUMERIC:           return(@symbol(SQL_NUMERIC));
	case SQL_DECIMAL:           return(@symbol(SQL_DECIMAL));
	case SQL_BIGINT:            return(@symbol(SQL_BIGINT));
	case SQL_DATE:              return(@symbol(SQL_DATE));
#ifdef SQL_TYPE_DATE
	case SQL_TYPE_DATE:         return(@symbol(SQL_TYPE_DATE));
#endif
	case SQL_TIME:              return(@symbol(SQL_TIME));
	case SQL_TYPE_TIME:         return(@symbol(SQL_TYPE_TIME));
	case SQL_TIMESTAMP:         return(@symbol(SQL_TIMESTAMP));
#ifdef SQL_TYPE_TIMESTAMP
	case SQL_TYPE_TIMESTAMP:    return(@symbol(SQL_TYPE_TIMESTAMP));
#endif
#if defined(SQL_DATETIME) && (SQL_DATETIME != SQL_TIMESTAMP) && (SQL_DATETIME != SQL_DATE)
	case SQL_DATETIME:          return(@symbol(SQL_DATETIME));
#endif
	case SQL_BINARY:            return(@symbol(SQL_BINARY));
	case SQL_VARBINARY:         return(@symbol(SQL_VARBINARY));
	case SQL_LONGVARBINARY:     return(@symbol(SQL_LONGVARBINARY));
	case SQL_BIT:               return(@symbol(SQL_BIT));
	case SQL_GUID:              return(@symbol(SQL_GUID));
# ifdef SQL_WVARCHAR
	case SQL_WVARCHAR:          return(@symbol(SQL_WVARCHAR));
# endif
# ifdef SQL_WLONGVARCHAR
	case SQL_WLONGVARCHAR:      return(@symbol(SQL_WLONGVARCHAR));
# endif
	default:                    return(@symbol(other));
    }
}

#endif /* not __INCREMENTAL_COMPILE__ */
%}
! !

!ODBCHandle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ODBCHandle class methodsFor:'initialization'!

initialize
    super initialize.
    self initializeReturnCodes.

    "
     self initialize
    "
!

initializeReturnCodes
    SQL_SUCCESS            := SQL::DatabaseReturnValue success.
    SQL_SUCCESS_WITH_INFO  := SQL::DatabaseReturnValue successWithInfo.
    SQL_ERROR              := SQL::DatabaseReturnValue error.
    SQL_STILL_EXECUTING    := SQL::DatabaseReturnValue stillExecuting.
    SQL_NO_DATA            := SQL::DatabaseReturnValue noData.
    SQL_NEED_DATA          := SQL::DatabaseReturnValue needData.
    SQL_INVALID_HANDLE     := SQL::DatabaseReturnValue invalidHandle.
    SQL_CONTINUE           := SQL::DatabaseReturnValue continue.
    SQL_UNKNOWN            := SQL::DatabaseReturnValue unknown.

    "
     self initializeReturnCodes
    "
! !

!ODBCHandle class methodsFor:'instance creation'!

newEnvironmentHandle
    ^ ODBCEnvironmentHandle new
! !

!ODBCHandle class methodsFor:'Connection attribute values'!

SQL_ASYNC_ENABLE_OFF
"
   Used by SQL_ATTR_ASYNC_ENABLE (ODBC 3.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_ASYNC_ENABLE_OFF));

%}

!

SQL_ASYNC_ENABLE_ON
"
   Used by SQL_ATTR_ASYNC_ENABLE (ODBC 3.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_ASYNC_ENABLE_ON));

%}

!

SQL_AUTOCOMMIT_OFF
"
   Used by SQL_ATTR_AUTOCOMMIT (ODBC 1.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_AUTOCOMMIT_OFF));

%}

!

SQL_AUTOCOMMIT_ON
"
   Used by SQL_ATTR_AUTOCOMMIT (ODBC 1.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_AUTOCOMMIT_ON));

%}
!

SQL_CD_FALSE
"
   Used by SQL_ATTR_CONNECTION_DEAD (ODBC 3.5)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_CD_FALSE));

%}

!

SQL_CD_TRUE
"
   Used by SQL_ATTR_CONNECTION_DEAD (ODBC 3.5)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_CD_TRUE));

%}

!

SQL_CUR_USE_DRIVER
"
   Used by SQL_ATTR_ODBC_CURSORS (ODBC 2.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_CUR_USE_DRIVER));

%}

!

SQL_CUR_USE_IF_NEEDED
"
   Used by SQL_ATTR_ODBC_CURSORS (ODBC 2.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_CUR_USE_IF_NEEDED));

%}

!

SQL_CUR_USE_ODBC
"
   Used by SQL_ATTR_ODBC_CURSORS (ODBC 2.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_CUR_USE_ODBC));

%}

!

SQL_FALSE
"
   Used by SQL_ATTR_AUTO_IPD (ODBC 3.0), SQL_ATTR_METADATA_ID (ODBC 3.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_FALSE));

%}

!

SQL_MODE_READ_ONLY
"
   Used by SQL_ATTR_ACCESS_MODE (ODBC 1.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_MODE_READ_ONLY));

%}
!

SQL_MODE_READ_WRITE
"
   Used by SQL_ATTR_ACCESS_MODE  (ODBC 1.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_MODE_READ_WRITE));

%}

!

SQL_OPT_TRACE_OFF
"
   Used by SQL_ATTR_TRACE (ODBC 1.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_OPT_TRACE_OFF));

%}

!

SQL_OPT_TRACE_ON
"
   Used by SQL_ATTR_TRACE (ODBC 1.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_OPT_TRACE_ON));

%}




!

SQL_TRUE
"
   Used by SQL_ATTR_AUTO_IPD (ODBC 3.0), SQL_ATTR_METADATA_ID (ODBC 3.0)
"
%{  /* NOCONTEXT */

    RETURN (__MKSMALLINT(SQL_TRUE));

%}

! !

!ODBCHandle class methodsFor:'Connection attributes'!

SQL_AA_FALSE
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_AA_FALSE));
%}
!

SQL_AA_TRUE
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_AA_TRUE));
%}
!

SQL_ATTR_ACCESS_MODE
"
  Can be set before of after connection but for interoperability with different
  drivers do this before
"
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_ACCESS_MODE));
%}
!

SQL_ATTR_ANSI_APP
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_ANSI_APP));
%}
!

SQL_ATTR_ASYNC_ENABLE
"
    Must be set before there is an active statement
"
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_ASYNC_ENABLE));
%}

!

SQL_ATTR_AUTOCOMMIT
"
    Can be set before or after connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_AUTOCOMMIT));
%}

!

SQL_ATTR_AUTO_IPD
"
    Must be set before there is an active statement
"
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_AUTO_IPD));
%}

!

SQL_ATTR_CONNECTION_DEAD
"
    Can be set before or after connection
"
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_CONNECTION_DEAD));
%}

!

SQL_ATTR_CONNECTION_TIMEOUT
"
    Can be set before or after connection
"
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_CONNECTION_TIMEOUT));
%}

!

SQL_ATTR_CURRENT_CATALOG
"
  Can be set before of after connection but for interoperability with different
  drivers do this before
"
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_CURRENT_CATALOG));
%}

!

SQL_ATTR_LOGIN_TIMEOUT
"
Set before connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_LOGIN_TIMEOUT));
%}

!

SQL_ATTR_METADATA_ID
"
Set before or after connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_METADATA_ID));
%}
!

SQL_ATTR_ODBC_CURSORS
"
Set before connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_ODBC_CURSORS));
%}


!

SQL_ATTR_PACKET_SIZE
"
Set before connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_PACKET_SIZE));
%}

!

SQL_ATTR_QUIET_MODE
"
Set before or after connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_QUIET_MODE));
%}

!

SQL_ATTR_TRACE
"
Set before or after connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_TRACE));
%}

!

SQL_ATTR_TRACEFILE
"
Set before or after connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_TRACEFILE));
%}

!

SQL_ATTR_TRANSLATE_LIB
"
Set after connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_TRANSLATE_LIB));
%}

!

SQL_ATTR_TRANSLATE_OPTION
"
Set after connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_TRANSLATE_OPTION));
%}

!

SQL_ATTR_TXN_ISOLATION
"
Set before or after connection if there are no open transactions on the connection
"

%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_TXN_ISOLATION));
%}

!

SQL_COMMIT
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_COMMIT));
%}

!

SQL_CURSOR_KEYSET_DRIVEN
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_CURSOR_KEYSET_DRIVEN));
%}
!

SQL_HANDLE_DBC
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_HANDLE_DBC));
%}

!

SQL_HANDLE_ENV
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_HANDLE_ENV));
%}

!

SQL_ROLLBACK
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ROLLBACK));
%}


!

SQL_UB_VARIABLE
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_UB_VARIABLE));
%}
! !

!ODBCHandle class methodsFor:'debugging'!

debug:aBoolean
    DebugFlag := aBoolean

    "
     self debug:true
    "
! !

!ODBCHandle class methodsFor:'other odbc values'!

SQL_BIND_BY_COLUMN
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_BIND_BY_COLUMN));
%}
!

SQL_CURSOR_DYNAMIC
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_CURSOR_DYNAMIC));
%}
!

SQL_NULL_DATA
%{ /*NOCONTEXT*/
   RETURN (__MKSMALLINT(SQL_NULL_DATA));
%}
! !

!ODBCHandle class methodsFor:'queries-ODBC'!

cAlignmentOf:cType
%{  /* NOCONTEXT */
    if ((cType == @symbol(SQL_C_LONG))
     || (cType == @symbol(SQL_C_SLONG))
     || (cType == @symbol(SQL_C_ULONG))) {
	RETURN ( __MKSMALLINT( sizeof(long) ));
    }
    if ((cType == @symbol(SQL_C_CHAR))
     || (cType == @symbol(SQL_C_BINARY))
     || (cType == @symbol(SQL_C_TINYINT))
     || (cType == @symbol(SQL_C_STINYINT))
     || (cType == @symbol(SQL_C_UTINYINT))
     || (cType == @symbol(SQL_C_XML))
     || (cType == @symbol(SQL_C_BINARY))
     || (cType == @symbol(SQL_C_BIT))) {
	RETURN ( __MKSMALLINT( 1 ));
    }
    if (cType == @symbol(SQL_C_WCHAR)){
	RETURN ( __MKSMALLINT( 2 ));
    }
    if ((cType == @symbol(SQL_C_SHORT))
     || (cType == @symbol(SQL_C_SSHORT))
     || (cType == @symbol(SQL_C_USHORT))) {
	RETURN ( __MKSMALLINT( sizeof(short) ));
    }
    if (cType == @symbol(SQL_C_FLOAT)) {
	RETURN ( __MKSMALLINT( sizeof(float) ));
    }
    if (cType == @symbol(SQL_C_DOUBLE)) {
	RETURN ( __MKSMALLINT( sizeof(double) ));
    }
    if ((cType == @symbol(SQL_C_BIGINT))
     || (cType == @symbol(SQL_C_SBIGINT))
     || (cType == @symbol(SQL_C_UBIGINT))) {
	RETURN ( __MKSMALLINT( 8 ));
    }
    if ((cType == @symbol(SQL_C_DATE))
     || (cType == @symbol(SQL_C_TYPE_DATE))) {
	RETURN ( __MKSMALLINT( sizeof(short) ) );
    }
    if ((cType == @symbol(SQL_C_TIME))
     || (cType == @symbol(SQL_C_TYPE_TIME))) {
	RETURN ( __MKSMALLINT( sizeof(short) ));
    }
    if ((cType == @symbol(SQL_C_TIMESTAMP))
     || (cType == @symbol(SQL_C_TYPE_TIMESTAMP))) {
	RETURN ( __MKSMALLINT( sizeof(short) ));
    }
    if (cType == @symbol(SQL_C_NUMERIC)) {
	RETURN ( __MKSMALLINT( 1 ));
    }
    if (cType == @symbol(SQL_C_GUID)) {
	RETURN ( __MKSMALLINT( 1 ));
    }
%}.
    KeyNotFoundError raiseWith:cType errorString:'unsupported odbc sql ctype: ', cType
!

cSizeOf:cType
%{  /* NOCONTEXT */
    if ((cType == @symbol(SQL_C_LONG))
     || (cType == @symbol(SQL_C_SLONG))
     || (cType == @symbol(SQL_C_ULONG))) {
	RETURN ( __MKSMALLINT( sizeof(long) ));
    }
    if ((cType == @symbol(SQL_C_CHAR))
     || (cType == @symbol(SQL_C_BINARY))
     || (cType == @symbol(SQL_C_TINYINT))
     || (cType == @symbol(SQL_C_STINYINT))
     || (cType == @symbol(SQL_C_UTINYINT))
     || (cType == @symbol(SQL_C_XML))
     || (cType == @symbol(SQL_C_BINARY))
     || (cType == @symbol(SQL_C_BIT))) {
	RETURN ( __MKSMALLINT( 1 ));
    }
    if (cType == @symbol(SQL_C_WCHAR)){
	RETURN ( __MKSMALLINT( 2 ));
    }
    if ((cType == @symbol(SQL_C_SHORT))
     || (cType == @symbol(SQL_C_SSHORT))
     || (cType == @symbol(SQL_C_USHORT))) {
	RETURN ( __MKSMALLINT( sizeof(short) ));
    }
    if (cType == @symbol(SQL_C_FLOAT)) {
	RETURN ( __MKSMALLINT( sizeof(float) ));
    }
    if (cType == @symbol(SQL_C_DOUBLE)) {
	RETURN ( __MKSMALLINT( sizeof(double) ));
    }
    if ((cType == @symbol(SQL_C_BIGINT))
     || (cType == @symbol(SQL_C_SBIGINT))
     || (cType == @symbol(SQL_C_UBIGINT))) {
	RETURN ( __MKSMALLINT( 8 ));
    }
    if ((cType == @symbol(SQL_C_DATE))
     || (cType == @symbol(SQL_C_TYPE_DATE))) {
	RETURN ( __MKSMALLINT( sizeof(SQL_DATE_STRUCT) ) );
    }
    if ((cType == @symbol(SQL_C_TIME))
     || (cType == @symbol(SQL_C_TYPE_TIME))) {
	RETURN ( __MKSMALLINT( sizeof(SQL_TIME_STRUCT) ));
    }
    if ((cType == @symbol(SQL_C_TIMESTAMP))
     || (cType == @symbol(SQL_C_TYPE_TIMESTAMP))) {
	RETURN ( __MKSMALLINT( sizeof(SQL_TIMESTAMP_STRUCT) ));
    }
    if (cType == @symbol(SQL_C_NUMERIC)) {
	RETURN ( __MKSMALLINT( sizeof(SQL_NUMERIC_STRUCT) ));
    }
    if (cType == @symbol(SQL_C_GUID)) {
	RETURN ( __MKSMALLINT( sizeof(SQLGUID) ));
    }
%}.
    KeyNotFoundError raiseWith:cType errorString:'unsupported odbc sql ctype: ', cType printString
!

cTypeNumberFromCTypeSymbol:cTypeSymbol
%{  /* NOCONTEXT */
    /* ODBC 2 (sql.h) */
    if (cTypeSymbol == @symbol(SQL_C_DEFAULT)) {
	RETURN (__MKSMALLINT(SQL_C_DEFAULT));
    }
    if (cTypeSymbol == @symbol(SQL_C_CHAR)) {
	RETURN (__MKSMALLINT(SQL_C_CHAR));
    }
    if (cTypeSymbol == @symbol(SQL_C_LONG)) {
	RETURN (__MKSMALLINT(SQL_C_LONG));
    }
    if (cTypeSymbol == @symbol(SQL_C_SHORT)) {
	RETURN (__MKSMALLINT(SQL_C_SHORT));
    }
    if (cTypeSymbol == @symbol(SQL_C_FLOAT)) {
	RETURN (__MKSMALLINT(SQL_C_FLOAT));
    }
    if (cTypeSymbol == @symbol(SQL_C_DOUBLE)) {
	RETURN (__MKSMALLINT(SQL_C_DOUBLE));
    }

    /* ODBC 3 */
#ifdef SQL_C_WCHAR
    if (cTypeSymbol == @symbol(SQL_C_WCHAR)){
	RETURN (__MKSMALLINT(SQL_C_WCHAR));
    }
#endif
#ifdef SQL_C_DATE
    if ((cTypeSymbol == @symbol(SQL_C_DATE))
     || (cTypeSymbol == @symbol(SQL_C_TYPE_DATE))) {
	RETURN (__MKSMALLINT(SQL_C_DATE));
    }
#endif
#ifdef SQL_C_TIME
    if ((cTypeSymbol == @symbol(SQL_C_TIME))
     || (cTypeSymbol == @symbol(SQL_C_TYPE_TIME))) {
	RETURN (__MKSMALLINT(SQL_C_TIME));
    }
#endif
#ifdef SQL_C_TIMESTAMP
    if ((cTypeSymbol == @symbol(SQL_C_TIMESTAMP))
     || (cTypeSymbol == @symbol(SQL_C_TYPE_TIMESTAMP))) {
	RETURN (__MKSMALLINT(SQL_C_TIMESTAMP));
    }
#endif

#ifdef SQL_C_BINARY
    if (cTypeSymbol == @symbol(SQL_C_BINARY)) {
	RETURN (__MKSMALLINT(SQL_C_BINARY));
    }
#endif
#ifdef SQL_C_BIT
    if (cTypeSymbol == @symbol(SQL_C_BIT)) {
	RETURN (__MKSMALLINT(SQL_C_BIT));
    }
#endif
#ifdef SQL_C_TINYINT
    if (cTypeSymbol == @symbol(SQL_C_TINYINT)) {
	RETURN (__MKSMALLINT(SQL_C_TINYINT));
    }
#endif
#ifdef SQL_C_SLONG
    if (cTypeSymbol == @symbol(SQL_C_SLONG)) {
	RETURN (__MKSMALLINT(SQL_C_SLONG));
    }
#endif
#ifdef SQL_C_ULONG
    if (cTypeSymbol == @symbol(SQL_C_ULONG)) {
	RETURN (__MKSMALLINT(SQL_C_ULONG));
    }
#endif
#ifdef SQL_C_SSHORT
    if (cTypeSymbol == @symbol(SQL_C_SSHORT)) {
	RETURN (__MKSMALLINT(SQL_C_SSHORT));
    }
#endif
#ifdef SQL_C_USHORT
    if (cTypeSymbol == @symbol(SQL_C_USHORT)) {
	RETURN (__MKSMALLINT(SQL_C_USHORT));
    }
#endif
#ifdef SQL_C_STINYINT
    if (cTypeSymbol == @symbol(SQL_C_STINYINT)) {
	RETURN (__MKSMALLINT(SQL_C_STINYINT));
    }
#endif
#ifdef SQL_C_UTINYINT
    if (cTypeSymbol == @symbol(SQL_C_UTINYINT)) {
	RETURN (__MKSMALLINT(SQL_C_UTINYINT));
    }
#endif
#ifdef SQL_C_BIGINT
    if (cTypeSymbol == @symbol(SQL_C_BIGINT)) {
	RETURN (__MKSMALLINT(SQL_C_BIGINT));
    }
#endif
#ifdef SQL_C_SBIGINT
    if (cTypeSymbol == @symbol(SQL_C_SBIGINT)) {
	RETURN (__MKSMALLINT(SQL_C_SBIGINT));
    }
#endif
#ifdef SQL_C_UBIGINT
    if (cTypeSymbol == @symbol(SQL_C_UBIGINT)) {
	RETURN (__MKSMALLINT(SQL_C_UBIGINT));
    }
#endif
#ifdef SQL_C_NUMERIC
    if (cTypeSymbol == @symbol(SQL_C_NUMERIC)) {
	RETURN (__MKSMALLINT(SQL_C_NUMERIC));
    }
#endif
#ifdef SQL_C_BOOKMARK
    if (cTypeSymbol == @symbol(SQL_C_BOOKMARK)) {
	RETURN (__MKSMALLINT(SQL_C_BOOKMARK));
    }
#endif
#ifdef SQL_C_VARBOOKMARK
    if (cTypeSymbol == @symbol(SQL_C_VARBOOKMARK)) {
	RETURN (__MKSMALLINT(SQL_C_VARBOOKMARK));
    }
#endif
#ifdef SQL_C_GUID
    if (cTypeSymbol == @symbol(SQL_C_GUID)) {
	RETURN (__MKSMALLINT(SQL_C_GUID));
    }
#endif
#ifdef SQL_C_XML
    if (cTypeSymbol == @symbol(SQL_C_XML)) {
	RETURN (__MKSMALLINT(SQL_C_XML));
    }
#endif

#ifdef SQL_C_INTERVAL_YEAR
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_YEAR)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_YEAR));
    }
#endif
#ifdef SQL_C_INTERVAL_MONTH
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_MONTH)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_MONTH));
    }
#endif
#ifdef SQL_C_INTERVAL_DAY
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_DAY)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_DAY));
    }
#endif
#ifdef SQL_C_INTERVAL_HOUR
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_HOUR)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_HOUR));
    }
#endif
#ifdef SQL_C_INTERVAL_MINUTE
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_MINUTE)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_MINUTE));
    }
#endif
#ifdef SQL_C_INTERVAL_SECOND
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_SECOND)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_SECOND));
    }
#endif
#ifdef SQL_C_INTERVAL_YEAR_TO_MONTH
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_YEAR_TO_MONTH)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_YEAR_TO_MONTH));
    }
#endif
#ifdef SQL_C_INTERVAL_DAY_TO_HOUR
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_DAY_TO_HOUR)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_DAY_TO_HOUR));
    }
#endif
#ifdef SQL_C_INTERVAL_DAY_TO_MINUTE
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_DAY_TO_MINUTE)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_DAY_TO_MINUTE));
    }
#endif
#ifdef SQL_C_INTERVAL_DAY_TO_SECOND
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_DAY_TO_SECOND)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_DAY_TO_SECOND));
    }
#endif
#ifdef SQL_C_INTERVAL_HOUR_TO_MINUTE
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_HOUR_TO_MINUTE)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_HOUR_TO_MINUTE));
    }
#endif
#ifdef SQL_C_INTERVAL_HOUR_TO_SECOND
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_HOUR_TO_SECOND)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_HOUR_TO_SECOND));
    }
#endif
#ifdef SQL_C_INTERVAL_MINUTE_TO_SECOND
    if (cTypeSymbol == @symbol(SQL_C_INTERVAL_MINUTE_TO_SECOND)) {
	RETURN (__MKSMALLINT(SQL_C_INTERVAL_MINUTE_TO_SECOND));
    }
#endif
%}.
    KeyNotFoundError raiseWith:cTypeSymbol errorString:'unsupported odbc sql ctype: ', cTypeSymbol printString
!

cTypeSymbolFromCTypeNumber:cTypeNr
%{  /* NOCONTEXT */
    switch (__intVal(cTypeNr)) {
	/* ODBC 2 (sql.h) */
	case SQL_C_DEFAULT:
	    RETURN ( @symbol(SQL_C_DEFAULT) );

	case SQL_C_CHAR:
	    RETURN ( @symbol(SQL_C_CHAR) );

	case SQL_C_LONG:
	    RETURN ( @symbol(SQL_C_LONG));
	    break;

	case SQL_C_SHORT:
	    RETURN ( @symbol(SQL_C_SHORT) );

	case SQL_C_FLOAT:
	    RETURN ( @symbol(SQL_C_FLOAT) );

	case SQL_C_DOUBLE:
	    RETURN ( @symbol(SQL_C_DOUBLE) );

	/* ODBC 2 extensions (sqlext.h) */
#ifdef SQL_C_WCHAR
	case SQL_C_WCHAR:
	    RETURN ( @symbol(SQL_C_WCHAR));
	    break;
#endif
#ifdef SQL_C_DATE
	case SQL_C_DATE:
	case SQL_C_TYPE_DATE:
	    RETURN ( @symbol(SQL_C_DATE));
	    break;
#endif
#ifdef SQL_C_TIME
	case SQL_C_TIME:
	case SQL_C_TYPE_TIME:
	    RETURN ( @symbol(SQL_C_TIME));
	    break;
#endif
#ifdef SQL_C_TIMESTAMP
	case SQL_C_TIMESTAMP:
	case SQL_C_TYPE_TIMESTAMP:
	    RETURN ( @symbol(SQL_C_TIMESTAMP));
	    break;
#endif
#ifdef SQL_C_BINARY
	case SQL_C_BINARY:
	    RETURN ( @symbol(SQL_C_BINARY));
	    break;
#endif
#ifdef SQL_C_BIT
	case SQL_C_BIT:
	    RETURN ( @symbol(SQL_C_BIT));
	    break;
#endif
#ifdef SQL_C_TINYINT
	case SQL_C_TINYINT:
	    RETURN ( @symbol(SQL_C_TINYINT));
	    break;
#endif
#ifdef SQL_C_SLONG
	case SQL_C_SLONG:
	    RETURN ( @symbol(SQL_C_SLONG));
	    break;
#endif
#ifdef SQL_C_ULONG
	case SQL_C_ULONG:
	    RETURN ( @symbol(SQL_C_ULONG));
	    break;
#endif
#ifdef SQL_C_SSHORT
	case SQL_C_SSHORT:
	    RETURN ( @symbol(SQL_C_SSHORT));
	    break;
#endif
#ifdef SQL_C_USHORT
	case SQL_C_USHORT:
	    RETURN ( @symbol(SQL_C_USHORT));
	    break;
#endif
#ifdef SQL_C_STINYINT
	case SQL_C_STINYINT:
	    RETURN ( @symbol(SQL_C_STINYINT));
	    break;
#endif
#ifdef SQL_C_UTINYINT
	case SQL_C_UTINYINT:
	    RETURN ( @symbol(SQL_C_UTINYINT));
	    break;
#endif
#ifdef SQL_C_SBIGINT
	case SQL_C_SBIGINT:
	    RETURN ( @symbol(SQL_C_SBIGINT));
	    break;
#endif
#ifdef SQL_C_UBIGINT
	case SQL_C_UBIGINT:
	    RETURN ( @symbol(SQL_C_UBIGINT));
	    break;
#endif
#ifdef SQL_C_NUMERIC
	case SQL_C_NUMERIC:
	    RETURN ( @symbol(SQL_C_NUMERIC));
	    break;
#endif
#ifdef SQL_C_BOOKMARK
# if (SQL_C_BOOKMARK != SQL_C_ULONG) && (SQL_C_BOOKMARK != SQL_C_UBIGINT)
	case SQL_C_BOOKMARK:
	    RETURN ( @symbol(SQL_C_BOOKMARK));
	    break;
# endif
#endif
#ifdef SQL_C_VARBOOKMARK
# if SQL_C_VARBOOKMARK != SQL_C_BINARY
	case SQL_C_VARBOOKMARK:
	    RETURN ( @symbol(SQL_C_VARBOOKMARK));
	    break;
# endif
#endif
#ifdef SQL_C_GUID
	case SQL_C_GUID:
	    RETURN ( @symbol(SQL_C_GUID));
	    break;
#endif
#ifdef SQL_C_XML
	case SQL_C_XML:
	    RETURN ( @symbol(SQL_C_XML));
	    break;
#endif
    }
%}.
    IndexNotFoundError raiseWith:cTypeNr errorString:'unsupported odbc sql ctype number: ', cTypeNr printString
!

databaseName
%{
    RETURN (__MKSTRING(THE_DB_NAME));
%}.
    "
     SQL::ODBCHandle databaseName
    "
!

infoTypeNumberFromInfoTypeSymbol:infoTypeSymbol
%{  /* NOCONTEXT */
    /* ODBC 1 (sql.h) */
#ifdef SQL_ACCESSIBLE_PROCEDURES
    if (infoTypeSymbol == @symbol(SQL_ACCESSIBLE_PROCEDURES)) {
	RETURN (__MKSMALLINT(SQL_ACCESSIBLE_PROCEDURES));
    }
#endif
#ifdef SQL_DEFAULT_TXN_ISOLATION
    if (infoTypeSymbol == @symbol(SQL_DEFAULT_TXN_ISOLATION)) {
	RETURN (__MKSMALLINT(SQL_DEFAULT_TXN_ISOLATION));
    }
#endif
#ifdef SQL_ACCESSIBLE_TABLES
    if (infoTypeSymbol == @symbol(SQL_ACCESSIBLE_TABLES)) {
	RETURN (__MKSMALLINT(SQL_ACCESSIBLE_TABLES));
    }
#endif
#ifdef SQL_CATALOG_NAME_SEPARATOR
    if (infoTypeSymbol == @symbol(SQL_CATALOG_NAME_SEPARATOR)) {
	RETURN (__MKSMALLINT(SQL_CATALOG_NAME_SEPARATOR));
    }
#endif
#ifdef SQL_CATALOG_TERM
    if (infoTypeSymbol == @symbol(SQL_CATALOG_TERM)) {
	RETURN (__MKSMALLINT(SQL_CATALOG_TERM));
    }
#endif
#ifdef SQL_CONCAT_NULL_BEHAVIOR
    if (infoTypeSymbol == @symbol(SQL_CONCAT_NULL_BEHAVIOR)) {
	RETURN (__MKSMALLINT(SQL_CONCAT_NULL_BEHAVIOR));
    }
#endif
#ifdef SQL_CONVERT_FUNCTIONS
    if (infoTypeSymbol == @symbol(SQL_CONVERT_FUNCTIONS)) {
	RETURN (__MKSMALLINT(SQL_CONVERT_FUNCTIONS));
    }
#endif
#ifdef SQL_CORRELATION_NAME
    if (infoTypeSymbol == @symbol(SQL_CORRELATION_NAME)) {
	RETURN (__MKSMALLINT(SQL_CORRELATION_NAME));
    }
#endif
#ifdef SQL_CURSOR_COMMIT_BEHAVIOR
    if (infoTypeSymbol == @symbol(SQL_CURSOR_COMMIT_BEHAVIOR)) {
	RETURN (__MKSMALLINT(SQL_CURSOR_COMMIT_BEHAVIOR));
    }
#endif
#ifdef SQL_CURSOR_ROLLBACK_BEHAVIOR
    if (infoTypeSymbol == @symbol(SQL_CURSOR_ROLLBACK_BEHAVIOR)) {
	RETURN (__MKSMALLINT(SQL_CURSOR_ROLLBACK_BEHAVIOR));
    }
#endif
#ifdef SQL_DATABASE_NAME
    if (infoTypeSymbol == @symbol(SQL_DATABASE_NAME)) {   /* obsoleted in ODBC 3 (sql.h) */
	RETURN (__MKSMALLINT(SQL_DATABASE_NAME));
    }
#endif
#ifdef SQL_DATA_SOURCE_NAME
    if (infoTypeSymbol == @symbol(SQL_DATA_SOURCE_NAME)) {
	RETURN (__MKSMALLINT(SQL_DATA_SOURCE_NAME));
    }
#endif
#ifdef SQL_DATA_SOURCE_READ_ONLY
    if (infoTypeSymbol == @symbol(SQL_DATA_SOURCE_READ_ONLY)) {
	RETURN (__MKSMALLINT(SQL_DATA_SOURCE_READ_ONLY));
    }
#endif
#ifdef SQL_DBMS_NAME
    if (infoTypeSymbol == @symbol(SQL_DBMS_NAME)) {
	RETURN (__MKSMALLINT(SQL_DBMS_NAME));
    }
#endif
#ifdef SQL_DBMS_VER
    if (infoTypeSymbol == @symbol(SQL_DBMS_VER)) {
	RETURN (__MKSMALLINT(SQL_DBMS_VER));
    }
#endif
#ifdef SQL_DRIVER_NAME
    if (infoTypeSymbol == @symbol(SQL_DRIVER_NAME)) {
	RETURN (__MKSMALLINT(SQL_DRIVER_NAME));
    }
#endif
#ifdef SQL_DRIVER_VER
    if (infoTypeSymbol == @symbol(SQL_DRIVER_VER)) {
	RETURN (__MKSMALLINT(SQL_DRIVER_VER));
    }
#endif
#ifdef SQL_EXPRESSIONS_IN_ORDERBY
    if (infoTypeSymbol == @symbol(SQL_EXPRESSIONS_IN_ORDERBY)) {
	RETURN (__MKSMALLINT(SQL_EXPRESSIONS_IN_ORDERBY));
    }
#endif
#ifdef SQL_IDENTIFIER_CASE
    if (infoTypeSymbol == @symbol(SQL_IDENTIFIER_CASE)) {
	RETURN (__MKSMALLINT(SQL_IDENTIFIER_CASE));
    }
#endif
#ifdef SQL_IDENTIFIER_QUOTE_CHAR
    if (infoTypeSymbol == @symbol(SQL_IDENTIFIER_QUOTE_CHAR)) {
	RETURN (__MKSMALLINT(SQL_IDENTIFIER_QUOTE_CHAR));
    }
#endif
#ifdef SQL_INTEGRITY
    if (infoTypeSymbol == @symbol(SQL_INTEGRITY)) {
	RETURN (__MKSMALLINT(SQL_INTEGRITY));
    }
#endif
#ifdef SQL_MAX_CATALOG_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_CATALOG_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_CATALOG_NAME_LEN));
    }
#endif
#ifdef SQL_MAX_COLUMN_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_COLUMN_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_COLUMN_NAME_LEN));
    }
#endif
#ifdef SQL_MAX_CONCURRENT_ACTIVITIES
    if (infoTypeSymbol == @symbol(SQL_MAX_CONCURRENT_ACTIVITIES)) {
	RETURN (__MKSMALLINT(SQL_MAX_CONCURRENT_ACTIVITIES));
    }
#endif
#ifdef SQL_MAX_CURSOR_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_CURSOR_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_CURSOR_NAME_LEN));
    }
#endif
#ifdef SQL_MAX_DRIVER_CONNECTIONS
    if (infoTypeSymbol == @symbol(SQL_MAX_DRIVER_CONNECTIONS)) {
	RETURN (__MKSMALLINT(SQL_MAX_DRIVER_CONNECTIONS));
    }
#endif
#ifdef SQL_MAX_PROCEDURE_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_PROCEDURE_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_PROCEDURE_NAME_LEN));
    }
#endif
#ifdef SQL_MAX_SCHEMA_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_SCHEMA_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_SCHEMA_NAME_LEN));
    }
#endif
#ifdef SQL_MAX_TABLE_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_TABLE_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_TABLE_NAME_LEN));
    }
#endif
#ifdef SQL_MULT_RESULT_SETS
    if (infoTypeSymbol == @symbol(SQL_MULT_RESULT_SETS)) {
	RETURN (__MKSMALLINT(SQL_MULT_RESULT_SETS));
    }
#endif
#ifdef SQL_MULTIPLE_ACTIVE_TXN
    if (infoTypeSymbol == @symbol(SQL_MULTIPLE_ACTIVE_TXN)) {
	RETURN (__MKSMALLINT(SQL_MULTIPLE_ACTIVE_TXN));
    }
#endif
#ifdef SQL_NON_NULLABLE_COLUMNS
    if (infoTypeSymbol == @symbol(SQL_NON_NULLABLE_COLUMNS)) {
	RETURN (__MKSMALLINT(SQL_NON_NULLABLE_COLUMNS));
    }
#endif
#ifdef SQL_NUMERIC_FUNCTIONS
    if (infoTypeSymbol == @symbol(SQL_NUMERIC_FUNCTIONS)) {
	RETURN (__MKSMALLINT(SQL_NUMERIC_FUNCTIONS));
    }
#endif
#ifdef SQL_ODBC_VER
    if (infoTypeSymbol == @symbol(SQL_ODBC_VER)) {
	RETURN (__MKSMALLINT(SQL_ODBC_VER));
    }
#endif
#ifdef SQL_PROCEDURE_TERM
    if (infoTypeSymbol == @symbol(SQL_PROCEDURE_TERM)) {
	RETURN (__MKSMALLINT(SQL_PROCEDURE_TERM));
    }
#endif
#ifdef SQL_PROCEDURES
    if (infoTypeSymbol == @symbol(SQL_PROCEDURES)) {
	RETURN (__MKSMALLINT(SQL_PROCEDURES));
    }
#endif
#ifdef SQL_ROW_UPDATES
    if (infoTypeSymbol == @symbol(SQL_ROW_UPDATES)) {
	RETURN (__MKSMALLINT(SQL_ROW_UPDATES));
    }
#endif
#ifdef SQL_SCHEMA_TERM
    if (infoTypeSymbol == @symbol(SQL_SCHEMA_TERM)) {
	RETURN (__MKSMALLINT(SQL_SCHEMA_TERM));
    }
#endif
#ifdef SQL_SCROLL_OPTIONS
    if (infoTypeSymbol == @symbol(SQL_SCROLL_OPTIONS)) {
	RETURN (__MKSMALLINT(SQL_SCROLL_OPTIONS));
    }
#endif
#ifdef SQL_SEARCH_PATTERN_ESCAPE
    if (infoTypeSymbol == @symbol(SQL_SEARCH_PATTERN_ESCAPE)) {
	RETURN (__MKSMALLINT(SQL_SEARCH_PATTERN_ESCAPE));
    }
#endif
#ifdef SQL_SERVER_NAME
    if (infoTypeSymbol == @symbol(SQL_SERVER_NAME)) {
	RETURN (__MKSMALLINT(SQL_SERVER_NAME));
    }
#endif
#ifdef SQL_STRING_FUNCTIONS
    if (infoTypeSymbol == @symbol(SQL_STRING_FUNCTIONS)) {
	RETURN (__MKSMALLINT(SQL_STRING_FUNCTIONS));
    }
#endif
#ifdef SQL_SYSTEM_FUNCTIONS
    if (infoTypeSymbol == @symbol(SQL_SYSTEM_FUNCTIONS)) {
	RETURN (__MKSMALLINT(SQL_SYSTEM_FUNCTIONS));
    }
#endif
#ifdef SQL_TABLE_TERM
    if (infoTypeSymbol == @symbol(SQL_TABLE_TERM)) {
	RETURN (__MKSMALLINT(SQL_TABLE_TERM));
    }
#endif
#ifdef SQL_TIMEDATE_FUNCTIONS
    if (infoTypeSymbol == @symbol(SQL_TIMEDATE_FUNCTIONS)) {
	RETURN (__MKSMALLINT(SQL_TIMEDATE_FUNCTIONS));
    }
#endif
#ifdef SQL_TXN_CAPABLE
    if (infoTypeSymbol == @symbol(SQL_TXN_CAPABLE)) {
	RETURN (__MKSMALLINT(SQL_TXN_CAPABLE));
    }
#endif
#ifdef SQL_TXN_ISOLATION_OPTION
    if (infoTypeSymbol == @symbol(SQL_TXN_ISOLATION_OPTION)) {
	RETURN (__MKSMALLINT(SQL_TXN_ISOLATION_OPTION));
    }
#endif
#ifdef SQL_USER_NAME
    if (infoTypeSymbol == @symbol(SQL_USER_NAME)) {
	RETURN (__MKSMALLINT(SQL_USER_NAME));
    }
#endif

    /* ODBC 2 */
#ifdef SQL_ALTER_TABLE
    if (infoTypeSymbol == @symbol(SQL_ALTER_TABLE)) {
	RETURN (__MKSMALLINT(SQL_ALTER_TABLE));
    }
#endif
#ifdef SQL_BOOKMARK_PERSISTANCE
    if (infoTypeSymbol == @symbol(SQL_BOOKMARK_PERSISTANCE)) {
	RETURN (__MKSMALLINT(SQL_BOOKMARK_PERSISTANCE));
    }
#endif
#ifdef SQL_CATALOG_USAGE
    if (infoTypeSymbol == @symbol(SQL_CATALOG_USAGE)) {
	RETURN (__MKSMALLINT(SQL_CATALOG_USAGE));
    }
#endif
#ifdef SQL_COLUMN_ALIAS
    if (infoTypeSymbol == @symbol(SQL_COLUMN_ALIAS)) {
	RETURN (__MKSMALLINT(SQL_COLUMN_ALIAS));
    }
#endif
#ifdef SQL_DRIVER_ODBC_VER
    if (infoTypeSymbol == @symbol(SQL_DRIVER_ODBC_VER)) {
	RETURN (__MKSMALLINT(SQL_DRIVER_ODBC_VER));
    }
#endif
#ifdef SQL_FETCH_DIRECTION
    if (infoTypeSymbol == @symbol(SQL_FETCH_DIRECTION)) {
	RETURN (__MKSMALLINT(SQL_FETCH_DIRECTION));
    }
#endif
#ifdef SQL_FILE_USAGE
    if (infoTypeSymbol == @symbol(SQL_FILE_USAGE)) {
	RETURN (__MKSMALLINT(SQL_FILE_USAGE));
    }
#endif
#ifdef SQL_GETDATA_EXTENSIONS
    if (infoTypeSymbol == @symbol(SQL_GETDATA_EXTENSIONS)) {
	RETURN (__MKSMALLINT(SQL_GETDATA_EXTENSIONS));
    }
#endif
#ifdef SQL_GROUP_BY
    if (infoTypeSymbol == @symbol(SQL_GROUP_BY)) {
	RETURN (__MKSMALLINT(SQL_GROUP_BY));
    }
#endif
#ifdef SQL_KEYWORDS
    if (infoTypeSymbol == @symbol(SQL_KEYWORDS)) {
	RETURN (__MKSMALLINT(SQL_KEYWORDS));
    }
#endif
#ifdef SQL_LIKE_ESCAPE_CLAUSE
    if (infoTypeSymbol == @symbol(SQL_LIKE_ESCAPE_CLAUSE)) {
	RETURN (__MKSMALLINT(SQL_LIKE_ESCAPE_CLAUSE));
    }
#endif
#ifdef SQL_MAX_BINARY_LITERAL_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_BINARY_LITERAL_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_BINARY_LITERAL_LEN));
    }
#endif
#ifdef SQL_MAX_CHAR_LITERAL_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_CHAR_LITERAL_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_CHAR_LITERAL_LEN));
    }
#endif
#ifdef SQL_MAX_COLUMNS_IN_GROUP_BY
    if (infoTypeSymbol == @symbol(SQL_MAX_COLUMNS_IN_GROUP_BY)) {
	RETURN (__MKSMALLINT(SQL_MAX_COLUMNS_IN_GROUP_BY));
    }
#endif
#ifdef SQL_MAX_COLUMNS_IN_INDEX
    if (infoTypeSymbol == @symbol(SQL_MAX_COLUMNS_IN_INDEX)) {
	RETURN (__MKSMALLINT(SQL_MAX_COLUMNS_IN_INDEX));
    }
#endif
#ifdef SQL_MAX_COLUMNS_IN_ORDER_BY
    if (infoTypeSymbol == @symbol(SQL_MAX_COLUMNS_IN_ORDER_BY)) {
	RETURN (__MKSMALLINT(SQL_MAX_COLUMNS_IN_ORDER_BY));
    }
#endif
#ifdef SQL_MAX_COLUMNS_IN_SELECT
    if (infoTypeSymbol == @symbol(SQL_MAX_COLUMNS_IN_SELECT)) {
	RETURN (__MKSMALLINT(SQL_MAX_COLUMNS_IN_SELECT));
    }
#endif
#ifdef SQL_MAX_COLUMNS_IN_TABLE
    if (infoTypeSymbol == @symbol(SQL_MAX_COLUMNS_IN_TABLE)) {
	RETURN (__MKSMALLINT(SQL_MAX_COLUMNS_IN_TABLE));
    }
#endif
#ifdef SQL_MAX_INDEX_SIZE
    if (infoTypeSymbol == @symbol(SQL_MAX_INDEX_SIZE)) {
	RETURN (__MKSMALLINT(SQL_MAX_INDEX_SIZE));
    }
#endif
#ifdef SQL_MAX_ROW_SIZE
    if (infoTypeSymbol == @symbol(SQL_MAX_ROW_SIZE)) {
	RETURN (__MKSMALLINT(SQL_MAX_ROW_SIZE));
    }
#endif
#ifdef SQL_MAX_STATEMENT_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_STATEMENT_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_STATEMENT_LEN));
    }
#endif
#ifdef SQL_MAX_OWNER_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_OWNER_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_OWNER_NAME_LEN));
    }
#endif
#ifdef SQL_MAX_QUALIFIER_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_QUALIFIER_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_QUALIFIER_NAME_LEN));
    }
#endif
#ifdef SQL_MAX_ROW_SIZE_INCLUDES_LONG
    if (infoTypeSymbol == @symbol(SQL_MAX_ROW_SIZE_INCLUDES_LONG)) {
	RETURN (__MKSMALLINT(SQL_MAX_ROW_SIZE_INCLUDES_LONG));
    }
#endif
#ifdef SQL_MAX_TABLES_IN_SELECT
    if (infoTypeSymbol == @symbol(SQL_MAX_TABLES_IN_SELECT)) {
	RETURN (__MKSMALLINT(SQL_MAX_TABLES_IN_SELECT));
    }
#endif
#ifdef SQL_MAX_USER_NAME_LEN
    if (infoTypeSymbol == @symbol(SQL_MAX_USER_NAME_LEN)) {
	RETURN (__MKSMALLINT(SQL_MAX_USER_NAME_LEN));
    }
#endif
#ifdef SQL_NEED_LONG_DATA_LEN
    if (infoTypeSymbol == @symbol(SQL_NEED_LONG_DATA_LEN)) {
	RETURN (__MKSMALLINT(SQL_NEED_LONG_DATA_LEN));
    }
#endif
#ifdef SQL_NULL_COLLATION
    if (infoTypeSymbol == @symbol(SQL_NULL_COLLATION)) {
	RETURN (__MKSMALLINT(SQL_NULL_COLLATION));
    }
#endif
#ifdef SQL_OJ_CAPABILITIES
    if (infoTypeSymbol == @symbol(SQL_OJ_CAPABILITIES)) {
	RETURN (__MKSMALLINT(SQL_OJ_CAPABILITIES));
    }
#endif
#ifdef SQL_ORDER_BY_COLUMNS_IN_SELECT
    if (infoTypeSymbol == @symbol(SQL_ORDER_BY_COLUMNS_IN_SELECT)) {
	RETURN (__MKSMALLINT(SQL_ORDER_BY_COLUMNS_IN_SELECT));
    }
#endif
#ifdef SQL_QUOTED_IDENTIFIER_CASE
    if (infoTypeSymbol == @symbol(SQL_QUOTED_IDENTIFIER_CASE)) {
	RETURN (__MKSMALLINT(SQL_QUOTED_IDENTIFIER_CASE));
    }
#endif
#ifdef SQL_SCHEMA_USAGE
    if (infoTypeSymbol == @symbol(SQL_SCHEMA_USAGE)) {
	RETURN (__MKSMALLINT(SQL_SCHEMA_USAGE));
    }
#endif
#ifdef SQL_SPECIAL_CHARACTERS
    if (infoTypeSymbol == @symbol(SQL_SPECIAL_CHARACTERS)) {
	RETURN (__MKSMALLINT(SQL_SPECIAL_CHARACTERS));
    }
#endif
#ifdef SQL_SUBQUERIES
    if (infoTypeSymbol == @symbol(SQL_SUBQUERIES)) {
	RETURN (__MKSMALLINT(SQL_SUBQUERIES));
    }
#endif
#ifdef SQL_TIMEDATE_ADD_INTERVALS
    if (infoTypeSymbol == @symbol(SQL_TIMEDATE_ADD_INTERVALS)) {
	RETURN (__MKSMALLINT(SQL_TIMEDATE_ADD_INTERVALS));
    }
#endif
#ifdef SQL_TIMEDATE_DIFF_INTERVALS
    if (infoTypeSymbol == @symbol(SQL_TIMEDATE_DIFF_INTERVALS)) {
	RETURN (__MKSMALLINT(SQL_TIMEDATE_DIFF_INTERVALS));
    }
#endif
#ifdef SQL_UNION
    if (infoTypeSymbol == @symbol(SQL_UNION)) {
	RETURN (__MKSMALLINT(SQL_UNION));
    }
#endif

#ifdef SQL_BOOKMARK_PERSISTENCE
    if (infoTypeSymbol == @symbol(SQL_BOOKMARK_PERSISTENCE)) {
	RETURN (__MKSMALLINT(SQL_BOOKMARK_PERSISTENCE));
    }
#endif

#ifdef SQL_CATALOG_LOCATION
    if (infoTypeSymbol == @symbol(SQL_CATALOG_LOCATION)) {
	RETURN (__MKSMALLINT(SQL_CATALOG_LOCATION));
    }
#endif

    /* ODBC 3 */
    /*
     * someone willing to add more stuff ?
     */
#ifdef SQL_ACTIVE_CONNECTIONS
    if (infoTypeSymbol == @symbol(SQL_ACTIVE_CONNECTIONS)) {
	RETURN (__MKSMALLINT(SQL_ACTIVE_CONNECTIONS));
    }
#endif
#ifdef SQL_ACTIVE_ENVIRONMENTS
    if (infoTypeSymbol == @symbol(SQL_ACTIVE_ENVIRONMENTS)) {
	RETURN (__MKSMALLINT(SQL_ACTIVE_ENVIRONMENTS));
    }
#endif
#ifdef SQL_ACTIVE_STATEMENTS
    if (infoTypeSymbol == @symbol(SQL_ACTIVE_STATEMENTS)) {
	RETURN (__MKSMALLINT(SQL_ACTIVE_STATEMENTS));
    }
#endif
#ifdef SQL_ASYNC_MODE
    if (infoTypeSymbol == @symbol(SQL_ASYNC_MODE)) {
	RETURN (__MKSMALLINT(SQL_ASYNC_MODE));
    }
#endif
#ifdef SQL_CA1_BULK_UPDATE_BY_BOOKMARK
    if (infoTypeSymbol == @symbol(SQL_CA1_BULK_UPDATE_BY_BOOKMARK)) {
	RETURN (__MKSMALLINT(SQL_CA1_BULK_UPDATE_BY_BOOKMARK));
    }
#endif
#ifdef SQL_DATETIME_LITERALS
    if (infoTypeSymbol == @symbol(SQL_DATETIME_LITERALS)) {
	RETURN (__MKSMALLINT(SQL_DATETIME_LITERALS));
    }
#endif
#ifdef SQL_DYNAMIC_CURSOR_ATTRIBUTES1
    if (infoTypeSymbol == @symbol(SQL_DYNAMIC_CURSOR_ATTRIBUTES1)) {
	RETURN (__MKSMALLINT(SQL_DYNAMIC_CURSOR_ATTRIBUTES1));
    }
#endif
#ifdef SQL_DYNAMIC_CURSOR_ATTRIBUTES2
    if (infoTypeSymbol == @symbol(SQL_DYNAMIC_CURSOR_ATTRIBUTES2)) {
	RETURN (__MKSMALLINT(SQL_DYNAMIC_CURSOR_ATTRIBUTES2));
    }
#endif
#ifdef SQL_AGGREGATE_FUNCTIONS
    if (infoTypeSymbol == @symbol(SQL_AGGREGATE_FUNCTIONS)) {
	RETURN (__MKSMALLINT(SQL_AGGREGATE_FUNCTIONS));
    }
#endif
#ifdef SQL_ALTER_DOMAIN
    if (infoTypeSymbol == @symbol(SQL_ALTER_DOMAIN)) {
	RETURN (__MKSMALLINT(SQL_ALTER_DOMAIN));
    }
#endif
#ifdef SQL_BATCH_ROW_COUNT
    if (infoTypeSymbol == @symbol(SQL_BATCH_ROW_COUNT)) {
	RETURN (__MKSMALLINT(SQL_BATCH_ROW_COUNT));
    }
#endif
#ifdef SQL_BATCH_SUPPORT
    if (infoTypeSymbol == @symbol(SQL_BATCH_SUPPORT)) {
	RETURN (__MKSMALLINT(SQL_BATCH_SUPPORT));
    }
#endif
#ifdef SQL_ODBC_API_CONFORMANCE
    if (infoTypeSymbol == @symbol(SQL_ODBC_API_CONFORMANCE)) {
	RETURN (__MKSMALLINT(SQL_ODBC_API_CONFORMANCE));
    }
#endif

%}.
    ^ KeyNotFoundError raiseRequestWith:infoTypeSymbol errorString:'unsupported odbc infoType: ', infoTypeSymbol

    "
       self infoTypeNumberFromInfoTypeSymbol:'bla'
    "
!

infoTypeSymbolFromInfoTypeNumber:infoTypeNr
%{  /* NOCONTEXT */
    switch (__intVal(infoTypeNr)) {
	/* ODBC 1 (sql.h) */
	case SQL_DATABASE_NAME:
	    RETURN ( @symbol(SQL_DATABASE_NAME) );

	case SQL_DATA_SOURCE_NAME:
	    RETURN ( @symbol(SQL_DATA_SOURCE_NAME) );

	case SQL_DATA_SOURCE_READ_ONLY:
	    RETURN ( @symbol(SQL_DATA_SOURCE_READ_ONLY) );

	case SQL_DBMS_NAME:
	    RETURN ( @symbol(SQL_DBMS_NAME) );

	case SQL_DBMS_VER:
	    RETURN ( @symbol(SQL_DBMS_VER) );

	case SQL_DRIVER_NAME:
	    RETURN ( @symbol(SQL_DRIVER_NAME) );

	case SQL_EXPRESSIONS_IN_ORDERBY:
	    RETURN ( @symbol(SQL_EXPRESSIONS_IN_ORDERBY) );

	case SQL_IDENTIFIER_CASE:
	    RETURN ( @symbol(SQL_IDENTIFIER_CASE) );

	case SQL_IDENTIFIER_QUOTE_CHAR:
	    RETURN ( @symbol(SQL_IDENTIFIER_QUOTE_CHAR) );

	case SQL_INTEGRITY:
	    RETURN ( @symbol(SQL_INTEGRITY) );

	case SQL_MAX_CATALOG_NAME_LEN:
	    RETURN ( @symbol(SQL_MAX_CATALOG_NAME_LEN) );

	case SQL_MAX_COLUMN_NAME_LEN:
	    RETURN ( @symbol(SQL_MAX_COLUMN_NAME_LEN) );

	case SQL_MAX_CONCURRENT_ACTIVITIES:
	    RETURN ( @symbol(SQL_MAX_CONCURRENT_ACTIVITIES) );

	case SQL_MAX_CURSOR_NAME_LEN:
	    RETURN ( @symbol(SQL_MAX_CURSOR_NAME_LEN) );

	case SQL_MAX_DRIVER_CONNECTIONS:
	    RETURN ( @symbol(SQL_MAX_DRIVER_CONNECTIONS) );

	case SQL_MAX_PROCEDURE_NAME_LEN:
	    RETURN ( @symbol(SQL_MAX_PROCEDURE_NAME_LEN) );

	case SQL_MAX_SCHEMA_NAME_LEN:
	    RETURN ( @symbol(SQL_MAX_SCHEMA_NAME_LEN) );

	case SQL_MAX_TABLE_NAME_LEN:
	    RETURN ( @symbol(SQL_MAX_TABLE_NAME_LEN) );

	case SQL_MULT_RESULT_SETS:
	    RETURN ( @symbol(SQL_MULT_RESULT_SETS) );

	case SQL_MULTIPLE_ACTIVE_TXN:
	    RETURN ( @symbol(SQL_MULTIPLE_ACTIVE_TXN) );

	case SQL_NON_NULLABLE_COLUMNS:
	    RETURN ( @symbol(SQL_NON_NULLABLE_COLUMNS) );

	case SQL_NUMERIC_FUNCTIONS:
	    RETURN ( @symbol(SQL_NUMERIC_FUNCTIONS) );

	case SQL_ODBC_VER:
	    RETURN ( @symbol(SQL_ODBC_VER) );

	case SQL_PROCEDURE_TERM:
	    RETURN ( @symbol(SQL_PROCEDURE_TERM) );

	case SQL_PROCEDURES:
	    RETURN ( @symbol(SQL_PROCEDURES) );

	case SQL_ROW_UPDATES:
	    RETURN ( @symbol(SQL_ROW_UPDATES) );

	case SQL_SCHEMA_TERM:
	    RETURN ( @symbol(SQL_SCHEMA_TERM) );

	case SQL_SCROLL_OPTIONS:
	    RETURN ( @symbol(SQL_SCROLL_OPTIONS) );

	case SQL_SEARCH_PATTERN_ESCAPE:
	    RETURN ( @symbol(SQL_SEARCH_PATTERN_ESCAPE) );

	case SQL_SERVER_NAME:
	    RETURN ( @symbol(SQL_SERVER_NAME) );

	case SQL_STRING_FUNCTIONS:
	    RETURN ( @symbol(SQL_STRING_FUNCTIONS) );

	case SQL_SYSTEM_FUNCTIONS:
	    RETURN ( @symbol(SQL_SYSTEM_FUNCTIONS) );

	case SQL_TABLE_TERM:
	    RETURN ( @symbol(SQL_TABLE_TERM) );

	case SQL_TIMEDATE_FUNCTIONS:
	    RETURN ( @symbol(SQL_TIMEDATE_FUNCTIONS) );

	case SQL_TXN_CAPABLE:
	    RETURN ( @symbol(SQL_TXN_CAPABLE) );

	case SQL_TXN_ISOLATION_OPTION:
	    RETURN ( @symbol(SQL_TXN_ISOLATION_OPTION) );

	case SQL_USER_NAME:
	    RETURN ( @symbol(SQL_USER_NAME) );

	/* ODBC 2 */
#ifdef SQL_ALTER_TABLE
	case SQL_ALTER_TABLE:
	    RETURN ( @symbol(SQL_ALTER_TABLE) );
#endif
#ifdef SQL_BOOKMARK_PERSISTANCE
	case SQL_BOOKMARK_PERSISTANCE:
	    RETURN ( @symbol(SQL_BOOKMARK_PERSISTANCE) );
#endif
#ifdef SQL_CATALOG_USAGE
	case SQL_CATALOG_USAGE:
	    RETURN ( @symbol(SQL_CATALOG_USAGE) );
#endif
#ifdef SQL_COLUMN_ALIAS
	case SQL_COLUMN_ALIAS:
	    RETURN ( @symbol(SQL_COLUMN_ALIAS) );
#endif
#ifdef SQL_DRIVER_ODBC_VER
	case SQL_DRIVER_ODBC_VER:
	    RETURN ( @symbol(SQL_DRIVER_ODBC_VER) );
#endif
#ifdef SQL_FILE_USAGE
	case SQL_FILE_USAGE:
	    RETURN ( @symbol(SQL_FILE_USAGE) );
#endif
#ifdef SQL_GETDATA_EXTENSIONS
	case SQL_GETDATA_EXTENSIONS:
	    RETURN ( @symbol(SQL_GETDATA_EXTENSIONS) );
#endif
#ifdef SQL_GROUP_BY
	case SQL_GROUP_BY:
	    RETURN ( @symbol(SQL_GROUP_BY) );
#endif
#ifdef SQL_KEYWORDS
	case SQL_KEYWORDS:
	    RETURN ( @symbol(SQL_KEYWORDS) );
#endif
#ifdef SQL_LIKE_ESCAPE_CLAUSE
	case SQL_LIKE_ESCAPE_CLAUSE:
	    RETURN ( @symbol(SQL_LIKE_ESCAPE_CLAUSE) );
#endif
#ifdef SQL_MAX_BINARY_LITERAL_LEN
	case SQL_MAX_BINARY_LITERAL_LEN:
	    RETURN ( @symbol(SQL_MAX_BINARY_LITERAL_LEN) );
#endif
#ifdef SQL_MAX_CHAR_LITERAL_LEN
	case SQL_MAX_CHAR_LITERAL_LEN:
	    RETURN ( @symbol(SQL_MAX_CHAR_LITERAL_LEN) );
#endif
#ifdef SQL_MAX_COLUMNS_IN_GROUP_BY
	case SQL_MAX_COLUMNS_IN_GROUP_BY:
	    RETURN ( @symbol(SQL_MAX_COLUMNS_IN_GROUP_BY) );
#endif
#ifdef SQL_MAX_COLUMNS_IN_INDEX
	case SQL_MAX_COLUMNS_IN_INDEX:
	    RETURN ( @symbol(SQL_MAX_COLUMNS_IN_INDEX) );
#endif
#ifdef SQL_MAX_COLUMNS_IN_ORDER_BY
	case SQL_MAX_COLUMNS_IN_ORDER_BY:
	    RETURN ( @symbol(SQL_MAX_COLUMNS_IN_ORDER_BY) );
#endif
#ifdef SQL_MAX_COLUMNS_IN_SELECT
	case SQL_MAX_COLUMNS_IN_SELECT:
	    RETURN ( @symbol(SQL_MAX_COLUMNS_IN_SELECT) );
#endif
#ifdef SQL_MAX_COLUMNS_IN_TABLE
	case SQL_MAX_COLUMNS_IN_TABLE:
	    RETURN ( @symbol(SQL_MAX_COLUMNS_IN_TABLE) );
#endif
#ifdef SQL_MAX_INDEX_SIZE
	case SQL_MAX_INDEX_SIZE:
	    RETURN ( @symbol(SQL_MAX_INDEX_SIZE) );
#endif
#ifdef SQL_MAX_ROW_SIZE
	case SQL_MAX_ROW_SIZE:
	    RETURN ( @symbol(SQL_MAX_ROW_SIZE) );
#endif
#ifdef SQL_MAX_STATEMENT_LEN
	case SQL_MAX_STATEMENT_LEN:
	    RETURN ( @symbol(SQL_MAX_STATEMENT_LEN) );
#endif
#ifdef SQL_MAX_TABLES_IN_SELECT
	case SQL_MAX_TABLES_IN_SELECT:
	    RETURN ( @symbol(SQL_MAX_TABLES_IN_SELECT) );
#endif
#ifdef SQL_MAX_USER_NAME_LEN
	case SQL_MAX_USER_NAME_LEN:
	    RETURN ( @symbol(SQL_MAX_USER_NAME_LEN) );
#endif
#ifdef SQL_NEED_LONG_DATA_LEN
	case SQL_NEED_LONG_DATA_LEN:
	    RETURN ( @symbol(SQL_NEED_LONG_DATA_LEN) );
#endif
#ifdef SQL_NULL_COLLATION
	case SQL_NULL_COLLATION:
	    RETURN ( @symbol(SQL_NULL_COLLATION) );
#endif
#ifdef SQL_OJ_CAPABILITIES
	case SQL_OJ_CAPABILITIES:
	    RETURN ( @symbol(SQL_OJ_CAPABILITIES) );
#endif
#ifdef SQL_ORDER_BY_COLUMNS_IN_SELECT
	case SQL_ORDER_BY_COLUMNS_IN_SELECT:
	    RETURN ( @symbol(SQL_ORDER_BY_COLUMNS_IN_SELECT) );
#endif
#ifdef SQL_QUOTED_IDENTIFIER_CASE
	case SQL_QUOTED_IDENTIFIER_CASE:
	    RETURN ( @symbol(SQL_QUOTED_IDENTIFIER_CASE) );
#endif
#ifdef SQL_SCHEMA_USAGE
	case SQL_SCHEMA_USAGE:
	    RETURN ( @symbol(SQL_SCHEMA_USAGE) );
#endif
#ifdef SQL_SPECIAL_CHARACTERS
	case SQL_SPECIAL_CHARACTERS:
	    RETURN ( @symbol(SQL_SPECIAL_CHARACTERS) );
#endif
#ifdef SQL_SUBQUERIES
	case SQL_SUBQUERIES:
	    RETURN ( @symbol(SQL_SUBQUERIES) );
#endif
#ifdef SQL_TIMEDATE_ADD_INTERVALS
	case SQL_TIMEDATE_ADD_INTERVALS:
	    RETURN ( @symbol(SQL_TIMEDATE_ADD_INTERVALS) );
#endif
#ifdef SQL_TIMEDATE_DIFF_INTERVALS
	case SQL_TIMEDATE_DIFF_INTERVALS:
	    RETURN ( @symbol(SQL_TIMEDATE_DIFF_INTERVALS) );
#endif
#ifdef SQL_UNION
	case SQL_UNION:
	    RETURN ( @symbol(SQL_UNION) );
#endif
#ifdef SQL_BOOKMARK_PERSISTENCE
	case SQL_BOOKMARK_PERSISTENCE:
	    RETURN ( @symbol(SQL_BOOKMARK_PERSISTENCE) );
#endif
#ifdef SQL_CATALOG_LOCATION
	case SQL_CATALOG_LOCATION:
	    RETURN ( @symbol(SQL_CATALOG_LOCATION) );
#endif


    /* ODBC 3 */
    /*
     * someone willing to add that stuff ?
     */
#if 0 /* == MAX_DRIVER_CONNECTIONS */
#ifdef SQL_ACTIVE_CONNECTIONS
	case SQL_ACTIVE_CONNECTIONS:
	    RETURN ( @symbol(SQL_ACTIVE_CONNECTIONS) );
#endif
#endif
#ifdef SQL_ACTIVE_ENVIRONMENTS
	case SQL_ACTIVE_ENVIRONMENTS:
	    RETURN ( @symbol(SQL_ACTIVE_ENVIRONMENTS) );
#endif
#ifdef SQL_ASYNC_MODE
	case SQL_ASYNC_MODE:
	    RETURN ( @symbol(SQL_ASYNC_MODE) );
#endif
#ifdef SQL_CA1_BULK_UPDATE_BY_BOOKMARK
	case SQL_CA1_BULK_UPDATE_BY_BOOKMARK:
	    RETURN ( @symbol(SQL_CA1_BULK_UPDATE_BY_BOOKMARK) );
#endif
#ifdef SQL_DATETIME_LITERALS
	case SQL_DATETIME_LITERALS:
	    RETURN ( @symbol(SQL_DATETIME_LITERALS) );
#endif
#ifdef SQL_DYNAMIC_CURSOR_ATTRIBUTES1
	case SQL_DYNAMIC_CURSOR_ATTRIBUTES1:
	    RETURN ( @symbol(SQL_DYNAMIC_CURSOR_ATTRIBUTES1) );
#endif
#ifdef SQL_DYNAMIC_CURSOR_ATTRIBUTES2
	case SQL_DYNAMIC_CURSOR_ATTRIBUTES2:
	    RETURN ( @symbol(SQL_DYNAMIC_CURSOR_ATTRIBUTES2) );
#endif
#ifdef SQL_AGGREGATE_FUNCTIONS
	case SQL_AGGREGATE_FUNCTIONS:
	    RETURN ( @symbol(SQL_AGGREGATE_FUNCTIONS) );
#endif
#ifdef SQL_ALTER_DOMAIN
	case SQL_ALTER_DOMAIN:
	    RETURN ( @symbol(SQL_ALTER_DOMAIN) );
#endif
#ifdef SQL_BATCH_ROW_COUNT
	case SQL_BATCH_ROW_COUNT:
	    RETURN ( @symbol(SQL_BATCH_ROW_COUNT) );
#endif
#ifdef SQL_BATCH_SUPPORT
	case SQL_BATCH_SUPPORT:
	    RETURN ( @symbol(SQL_BATCH_SUPPORT) );
#endif
    }

%}.
    IndexNotFoundError raiseWith:infoTypeNr errorString:'unsupported odbc infoType number: ', infoTypeNr printString
!

odbcName
%{
    RETURN (__MKSTRING(ODBC_NAME));
%}.
    "
     SQL::ODBCHandle odbcName
    "
!

odbcVersion
    |vsnHi vsnLow|

%{
#ifndef ODBCVER
# define ODBCVER 0x0100
#endif

    vsnHi = __MKSMALLINT((ODBCVER >> 8) & 0xFF);
    vsnLow = __MKSMALLINT(ODBCVER & 0xFF);
%}.
    ^ vsnHi printString , '.' , vsnLow printString

    "
     SQL::ODBCHandle odbcVersion
    "
!

sizeofSqlHandle
%{ /*NOCONTEXT*/
   RETURN (__MKSMALLINT(sizeof(HDBC)));
%}

    "
     self sizeofSqlHandle 
    "
!

sizeofSqlInteger
%{ /*NOCONTEXT*/
   RETURN (__MKSMALLINT(sizeof(SQLINTEGER)));
%}

    "
     self sizeofSqlInteger  
    "
!

sizeofSqlLen
%{ /*NOCONTEXT*/
   RETURN (__MKSMALLINT(sizeof(SQLLEN)));
%}
!

sizeofSqlReturn
%{ /*NOCONTEXT*/
   RETURN (__MKSMALLINT(sizeof(SQLRETURN)));
%}

    "
     self sizeofSqlReturn  
    "
!

sqlTypeNumberFromSqlTypeSymbol:sqlTypeSymbol
%{  /* NOCONTEXT */
    /* ODBC 2 (sql.h) */
    if (sqlTypeSymbol == @symbol(SQL_INTEGER)) {
	RETURN (__MKSMALLINT(SQL_INTEGER));
    }
    if (sqlTypeSymbol == @symbol(SQL_FLOAT)) {
	RETURN (__MKSMALLINT(SQL_FLOAT));
    }
    if (sqlTypeSymbol == @symbol(SQL_DOUBLE)) {
	RETURN (__MKSMALLINT(SQL_DOUBLE));
    }
    if (sqlTypeSymbol == @symbol(SQL_REAL)) {
	RETURN (__MKSMALLINT(SQL_REAL));
    }
    if (sqlTypeSymbol == @symbol(SQL_CHAR)) {
	RETURN (__MKSMALLINT(SQL_CHAR));
    }
    if (sqlTypeSymbol == @symbol(SQL_VARCHAR)) {
	RETURN (__MKSMALLINT(SQL_VARCHAR));
    }

    /* ODBC 2 extended datatypes (sqlext.h) */
#ifdef SQL_NUMERIC
    if (sqlTypeSymbol == @symbol(SQL_NUMERIC)) {
	RETURN (__MKSMALLINT(SQL_NUMERIC));
    }
#endif
#ifdef SQL_DECIMAL
    if (sqlTypeSymbol == @symbol(SQL_DECIMAL)) {
	RETURN (__MKSMALLINT(SQL_DECIMAL));
    }
#endif
#ifdef SQL_SMALLINT
    if (sqlTypeSymbol == @symbol(SQL_SMALLINT)) {
	RETURN (__MKSMALLINT(SQL_SMALLINT));
    }
#endif
#ifdef SQL_DATE
    if (sqlTypeSymbol == @symbol(SQL_DATE)) {
	RETURN (__MKSMALLINT(SQL_DATE));
    }
#endif
#ifdef SQL_TYPE_DATE
    if (sqlTypeSymbol == @symbol(SQL_TYPE_DATE)) {
	RETURN (__MKSMALLINT(SQL_TYPE_DATE));
    }
#endif
#ifdef SQL_TIME
    if (sqlTypeSymbol == @symbol(SQL_TIME)) {
	RETURN (__MKSMALLINT(SQL_TIME));
    }
#endif
#ifdef SQL_TYPE_TIME
    if (sqlTypeSymbol == @symbol(SQL_TYPE_TIME)) {
	RETURN (__MKSMALLINT(SQL_TYPE_TIME));
    }
#endif
#ifdef SQL_TIMESTAMP
    if (sqlTypeSymbol == @symbol(SQL_TIMESTAMP)) {
	RETURN (__MKSMALLINT(SQL_TIMESTAMP));
    }
#endif
#ifdef SQL_TYPE_TIMESTAMP
    if (sqlTypeSymbol == @symbol(SQL_TYPE_TIMESTAMP)) {
	RETURN (__MKSMALLINT(SQL_TYPE_TIMESTAMP));
    }
#endif
#ifdef SQL_DATETIME
    if (sqlTypeSymbol == @symbol(SQL_DATETIME)) {
	RETURN (__MKSMALLINT(SQL_DATETIME));
    }
#endif
#ifdef SQL_LONGVARCHAR
    if (sqlTypeSymbol == @symbol(SQL_LONGVARCHAR)) {
	RETURN (__MKSMALLINT(SQL_LONGVARCHAR));
    }
#endif
#ifdef SQL_BINARY
    if (sqlTypeSymbol == @symbol(SQL_BINARY)) {
	RETURN (__MKSMALLINT(SQL_BINARY));
    }
#endif
#ifdef SQL_VARBINARY
    if (sqlTypeSymbol == @symbol(SQL_VARBINARY)) {
	RETURN (__MKSMALLINT(SQL_VARBINARY));
    }
#endif
#ifdef SQL_LONGVARBINARY
    if (sqlTypeSymbol == @symbol(SQL_LONGVARBINARY)) {
	RETURN (__MKSMALLINT(SQL_LONGVARBINARY));
    }
#endif
#ifdef SQL_BIGINT
    if (sqlTypeSymbol == @symbol(SQL_BIGINT)) {
	RETURN (__MKSMALLINT(SQL_BIGINT));
    }
#endif
#ifdef SQL_TINYINT
    if (sqlTypeSymbol == @symbol(SQL_TINYINT)) {
	RETURN (__MKSMALLINT(SQL_TINYINT));
    }
#endif
#ifdef SQL_BIT
    if (sqlTypeSymbol == @symbol(SQL_BIT)) {
	RETURN (__MKSMALLINT(SQL_BIT));
    }
#endif
#ifdef SQL_INTERVAL_YEAR
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_YEAR)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_YEAR));
    }
#endif
#ifdef SQL_INTERVAL_MONTH
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_MONTH)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_MONTH));
    }
#endif
#ifdef SQL_INTERVAL_YEAR_TO_MONTH
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_YEAR_TO_MONTH)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_YEAR_TO_MONTH));
    }
#endif
#ifdef SQL_INTERVAL_DAY
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_DAY)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_DAY));
    }
#endif
#ifdef SQL_INTERVAL_HOUR
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_HOUR)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_HOUR));
    }
#endif
#ifdef SQL_INTERVAL_MINUTE
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_MINUTE)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_MINUTE));
    }
#endif
#ifdef SQL_INTERVAL_SECOND
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_SECOND)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_SECOND));
    }
#endif
#ifdef SQL_INTERVAL_DAY_TO_HOUR
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_DAY_TO_HOUR)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_DAY_TO_HOUR));
    }
#endif
#ifdef SQL_INTERVAL_DAY_TO_MINUTE
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_DAY_TO_MINUTE)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_DAY_TO_MINUTE));
    }
#endif
#ifdef SQL_INTERVAL_DAY_TO_SECOND
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_DAY_TO_SECOND)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_DAY_TO_SECOND));
    }
#endif
#ifdef SQL_INTERVAL_HOUR_TO_MINUTE
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_HOUR_TO_MINUTE)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_HOUR_TO_MINUTE));
    }
#endif
#ifdef SQL_INTERVAL_HOUR_TO_SECOND
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_HOUR_TO_SECOND)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_HOUR_TO_SECOND));
    }
#endif
#ifdef SQL_INTERVAL_MINUTE_TO_SECOND
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL_MINUTE_TO_SECOND)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL_MINUTE_TO_SECOND));
    }
#endif

#if defined(SQL_WCHAR)
    if (sqlTypeSymbol == @symbol(SQL_WCHAR)) {
	RETURN (__MKSMALLINT(SQL_WCHAR));
    }
#endif
#if defined(SQL_WVARCHAR)
    if (sqlTypeSymbol == @symbol(SQL_WVARCHAR)) {
	RETURN (__MKSMALLINT(SQL_WVARCHAR));
    }
#endif
#if defined(SQL_WLONGVARCHAR)
    if (sqlTypeSymbol == @symbol(SQL_WLONGVARCHAR)) {
	RETURN (__MKSMALLINT(SQL_WLONGVARCHAR));
    }
#endif

#if defined(SQL_UNICODE)
# if (SQL_UNICODE != SQL_WCHAR) || defined(SQL_WCHAR)
    if (sqlTypeSymbol == @symbol(SQL_UNICODE)) {
	RETURN (__MKSMALLINT(SQL_UNICODE));
    }
# endif
#endif
#if defined(SQL_UNICODE_VARCHAR)
# if (SQL_UNICODE_VARCHAR != SQL_WVARCHAR) || defined(SQL_WVARCHAR)
    if (sqlTypeSymbol == @symbol(SQL_UNICODE_VARCHAR)) {
	RETURN (__MKSMALLINT(SQL_UNICODE_VARCHAR));
    }
# endif
#endif
#if defined(SQL_UNICODE_LONGVARCHAR)
# if (SQL_UNICODE_LONGVARCHAR != SQL_WLONGVARCHAR) || defined(SQL_WLONGVARCHAR)
    if (sqlTypeSymbol == @symbol(SQL_UNICODE_LONGVARCHAR)) {
	RETURN (__MKSMALLINT(SQL_UNICODE_LONGVARCHAR));
    }
# endif
#endif
#if defined(SQL_UNICODE_CHAR)
# if (SQL_UNICODE_CHAR != SQL_WCHAR) || defined(SQL_WCHAR)
    if (sqlTypeSymbol == @symbol(SQL_UNICODE_CHAR)) {
	RETURN (__MKSMALLINT(SQL_UNICODE_CHAR));
    }
# endif
#endif

    /* ODBC 3 */
#if defined(SQL_DATETIME)
    if (sqlTypeSymbol == @symbol(SQL_DATETIME)) {
	RETURN (__MKSMALLINT(SQL_DATETIME));
    }
#endif
#if defined(SQL_INTERVAL)
    if (sqlTypeSymbol == @symbol(SQL_INTERVAL)) {
	RETURN (__MKSMALLINT(SQL_INTERVAL));
    }
#endif
#if defined(SQL_GUID)
    if (sqlTypeSymbol == @symbol(SQL_GUID)) {
	RETURN (__MKSMALLINT(SQL_GUID));
    }
#endif
%}.
    KeyNotFoundError raiseWith:sqlTypeSymbol errorString:'unsupported odbc sql type: ', sqlTypeSymbol printString
!

sqlTypeSymbolFromSqlTypeNumber:sqlTypeNr
%{  /* NOCONTEXT */
    switch (__intVal(sqlTypeNr)) {
	/* ODBC 2 (sql.h) */
	case SQL_INTEGER:
	    RETURN ( @symbol(SQL_INTEGER) );

	case SQL_FLOAT:
	    RETURN ( @symbol(SQL_FLOAT));
	    break;

	case SQL_DOUBLE:
	    RETURN ( @symbol(SQL_DOUBLE));
	    break;

	case SQL_REAL:
	    RETURN ( @symbol(SQL_REAL));
	    break;

	case SQL_CHAR:
	    RETURN ( @symbol(SQL_CHAR));
	    break;

	case SQL_VARCHAR:
	    RETURN ( @symbol(SQL_VARCHAR));
	    break;

	/* ODBC 2 extended datatypes (sqlext.h) */
#ifdef SQL_NUMERIC
	case SQL_NUMERIC:
	    RETURN ( @symbol(SQL_NUMERIC));
	    break;
#endif
#ifdef SQL_DECIMAL
	case SQL_DECIMAL:
	    RETURN ( @symbol(SQL_DECIMAL));
	    break;
#endif
#ifdef SQL_SMALLINT
	case SQL_SMALLINT:
	    RETURN ( @symbol(SQL_SMALLINT));
	    break;
#endif
#ifdef SQL_DATE
	case SQL_DATE:
	    RETURN ( @symbol(SQL_DATE));
	    break;
#endif
#ifdef SQL_TYPE_DATE
	case SQL_TYPE_DATE:
	    RETURN ( @symbol(SQL_TYPE_DATE));
	    break;
#endif
#ifdef SQL_TIME
	case SQL_TIME:
	    RETURN ( @symbol(SQL_TIME));
	    break;
#endif
#ifdef SQL_TYPE_TIME
	case SQL_TYPE_TIME:
	    RETURN ( @symbol(SQL_TYPE_TIME));
	    break;
#endif
#ifdef SQL_TIMESTAMP
	case SQL_TIMESTAMP:
	    RETURN ( @symbol(SQL_TIMESTAMP));
	    break;
#endif
#ifdef SQL_TYPE_TIMESTAMP
	case SQL_TYPE_TIMESTAMP:
	    RETURN ( @symbol(SQL_TYPE_TIMESTAMP));
	    break;
#endif
#if defined(SQL_DATETIME) && (SQL_DATETIME != SQL_TIMESTAMP && (SQL_DATETIME != SQL_DATE))
	case SQL_DATETIME:
	    RETURN ( @symbol(SQL_DATETIME));
	    break;
#endif
#ifdef SQL_LONGVARCHAR
	case SQL_LONGVARCHAR:
	    RETURN ( @symbol(SQL_LONGVARCHAR));
	    break;
#endif
#ifdef SQL_BINARY
	case SQL_BINARY:
	    RETURN ( @symbol(SQL_BINARY));
	    break;
#endif
#ifdef SQL_VARBINARY
	case SQL_VARBINARY:
	    RETURN ( @symbol(SQL_VARBINARY));
	    break;
#endif
#ifdef SQL_LONGVARBINARY
	case SQL_LONGVARBINARY:
	    RETURN ( @symbol(SQL_LONGVARBINARY));
	    break;
#endif
#ifdef SQL_BIGINT
	case SQL_BIGINT:
	    RETURN ( @symbol(SQL_BIGINT));
	    break;
#endif
#ifdef SQL_TINYINT
	case SQL_TINYINT:
	    RETURN ( @symbol(SQL_TINYINT));
	    break;
#endif
#ifdef SQL_BIT
	case SQL_BIT:
	    RETURN ( @symbol(SQL_BIT));
	    break;
#endif
#ifdef SQL_INTERVAL_YEAR
	case SQL_INTERVAL_YEAR:
	    RETURN ( @symbol(SQL_INTERVAL_YEAR));
	    break;
#endif
#ifdef SQL_INTERVAL_MONTH
	case SQL_INTERVAL_MONTH:
	    RETURN ( @symbol(SQL_INTERVAL_MONTH));
	    break;
#endif
#ifdef SQL_INTERVAL_YEAR_TO_MONTH
	case SQL_INTERVAL_YEAR_TO_MONTH:
	    RETURN ( @symbol(SQL_INTERVAL_YEAR_TO_MONTH));
	    break;
#endif
#ifdef SQL_INTERVAL_DAY
	case SQL_INTERVAL_DAY:
	    RETURN ( @symbol(SQL_INTERVAL_DAY));
	    break;
#endif
#ifdef SQL_INTERVAL_HOUR
	case SQL_INTERVAL_HOUR:
	    RETURN ( @symbol(SQL_INTERVAL_HOUR));
	    break;
#endif
#ifdef SQL_INTERVAL_MINUTE
	case SQL_INTERVAL_MINUTE:
	    RETURN ( @symbol(SQL_INTERVAL_MINUTE));
	    break;
#endif
#ifdef SQL_INTERVAL_SECOND
	case SQL_INTERVAL_SECOND:
	    RETURN ( @symbol(SQL_INTERVAL_SECOND));
	    break;
#endif
#ifdef SQL_INTERVAL_DAY_TO_HOUR
	case SQL_INTERVAL_DAY_TO_HOUR:
	    RETURN ( @symbol(SQL_INTERVAL_DAY_TO_HOUR));
	    break;
#endif
#ifdef SQL_INTERVAL_DAY_TO_MINUTE
	case SQL_INTERVAL_DAY_TO_MINUTE:
	    RETURN ( @symbol(SQL_INTERVAL_DAY_TO_MINUTE));
	    break;
#endif
#ifdef SQL_INTERVAL_DAY_TO_SECOND
	case SQL_INTERVAL_DAY_TO_SECOND:
	    RETURN ( @symbol(SQL_INTERVAL_DAY_TO_SECOND));
	    break;
#endif
#ifdef SQL_INTERVAL_HOUR_TO_MINUTE
	case SQL_INTERVAL_HOUR_TO_MINUTE:
	    RETURN ( @symbol(SQL_INTERVAL_HOUR_TO_MINUTE));
	    break;
#endif
#ifdef SQL_INTERVAL_HOUR_TO_SECOND
	case SQL_INTERVAL_HOUR_TO_SECOND:
	    RETURN ( @symbol(SQL_INTERVAL_HOUR_TO_SECOND));
	    break;
#endif
#ifdef SQL_INTERVAL_MINUTE_TO_SECOND
	case SQL_INTERVAL_MINUTE_TO_SECOND:
	    RETURN ( @symbol(SQL_INTERVAL_MINUTE_TO_SECOND));
	    break;
#endif
#if defined(SQL_WCHAR)
	case SQL_WCHAR:
	    RETURN ( @symbol(SQL_WCHAR));
	    break;
#endif
#if defined(SQL_WVARCHAR)
	case SQL_WVARCHAR:
	    RETURN ( @symbol(SQL_WVARCHAR));
	    break;
#endif
#if defined(SQL_WLONGVARCHAR)
	case SQL_WLONGVARCHAR:
	    RETURN ( @symbol(SQL_WLONGVARCHAR));
	    break;
#endif

#if defined(SQL_UNICODE)
# if SQL_UNICODE != SQL_WCHAR
	case SQL_UNICODE:
	    RETURN ( @symbol(SQL_UNICODE));
	    break;
# endif
#endif
#if defined(SQL_UNICODE_VARCHAR)
# if SQL_UNICODE_VARCHAR != SQL_WVARCHAR
	case SQL_UNICODE_VARCHAR:
	    RETURN ( @symbol(SQL_UNICODE_VARCHAR));
	    break;
# endif
#endif
#if defined(SQL_UNICODE_LONGVARCHAR)
# if SQL_UNICODE_LONGVARCHAR != SQL_WLONGVARCHAR
	case SQL_UNICODE_LONGVARCHAR:
	    RETURN ( @symbol(SQL_UNICODE_LONGVARCHAR));
	    break;
# endif
#endif

	/* ODBC 3 */
#if defined(SQL_DATETIME)
# if (SQL_DATETIME != SQL_DATE) && (SQL_DATETIME != SQL_TIMESTAMP)
	case SQL_DATETIME:
	    RETURN ( @symbol(SQL_DATETIME));
	    break;
# endif
#endif
#if defined(SQL_INTERVAL)
# if (SQL_INTERVAL != SQL_TIME)
	case SQL_INTERVAL:
	    RETURN ( @symbol(SQL_INTERVAL));
	    break;
# endif
#endif
#if defined(SQL_GUID)
	case SQL_GUID:
	    RETURN ( @symbol(SQL_GUID));
	    break;
#endif
    }
%}.
    IndexNotFoundError raiseWith:sqlTypeNr errorString:'unsupported odbc sql type number: ', sqlTypeNr printString
!

supportsMultipleDataSources
%{  /* NOCONTEXT */
#ifdef HAS_SQLDataSources
    RETURN (true);
#else
    RETURN (false);
#endif
%}
!

supportsMultipleDrivers
%{  /* NOCONTEXT */
#ifdef HAS_SQLDrivers
    RETURN (true);
#else
    RETURN (false);
#endif
%}
! !

!ODBCHandle methodsFor:'ODBC interface'!

prim_sqlGetErrorForHenv:henv hdbc:hdbc hstmt:hstmt recordNumber:recNo into:valueHolder
   "
    Returns: ODBC return code
   "

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HENV   __henv = SQL_NULL_HENV;
    HDBC   __hdbc = SQL_NULL_HDBC;
    HSTMT  __hstmt = SQL_NULL_HSTMT;
    SQLRETURN rc;
    char __stateBuffer[32];
    char __buffer[1024];
    char *__errorMessagePtr = __buffer;
    char *__mallocPtr = 0;
    SQLSMALLINT __errorMessageLength = sizeof(__buffer);
    SQLSMALLINT __recNo;
    SQLINTEGER __errorCode;
    OBJ state = nil, errorCode = nil, errorMessage = nil;

    if (__isHENV(henv)) {
	if (__externalAddressVal( henv )) {
	    __henv = (HENV) __externalAddressVal( henv );
	}
    }

    if (__isHDBC(hdbc)) {
	if (__externalAddressVal( hdbc )) {
	    __hdbc = (HDBC) __externalAddressVal( hdbc );
	}
    }

    if (__isHSTMT(hstmt)) {
	if (__externalAddressVal( hstmt )) {
	    __hstmt = (HSTMT) __externalAddressVal( hstmt );
	}
    }

#ifdef USE_ODBC_V3
    {
    int  __handleType;
    SQLHANDLE __handle;

    if (__hstmt != SQL_NULL_HSTMT) {
	__handleType =  SQL_HANDLE_STMT;
	__handle = __hstmt;
    } else {
	if (__hdbc != SQL_NULL_HDBC) {
	    __handleType =  SQL_HANDLE_DBC;
	    __handle = __hdbc;
	} else {
	    if (__henv != SQL_NULL_HENV) {
		__handleType =  SQL_HANDLE_ENV;
		__handle = __henv;
	    } else {
		TRACE((stderr, "sqlGetEror: all handles are NULL\n"));
		RETURN (@global(ArgumentError));
	    }
	}
    }

    if (!__isSmallInteger(recNo)){
	TRACE((stderr, "sqlGetEror: invalid recNo\n"));
	RETURN (@global(ArgumentError));
    }

    __recNo = __smallIntegerVal(recNo);

retry:
    rc = SQLGetDiagRec(
		   __handleType,
		   __handle,
		   __recNo,
		   __stateBuffer,
		   &__errorCode,
		   __errorMessagePtr,
		   __errorMessageLength,
		   &__errorMessageLength );
    }
#else
    if ((__hstmt == SQL_NULL_HSTMT)
     && (__hdbc == SQL_NULL_HDBC)
     && (__henv == SQL_NULL_HENV)) {
	TRACE((stderr, "sqlGetEror: all handles are nil"));
	RETURN (@global(ArgumentError));
    }
    if (__isSmallInteger(recNo) && __smallIntegerVal(recNo) > 1) {
	/* we support only one record in ODBC_V2 */
	RETURN (__odbcReturnCode(SQL_NO_DATA));
    }

retry:
    rc = SQLError( __henv,
		     __hdbc,
		     __hstmt,
		     __stateBuffer,
		     &__errorCode,
		     __errorMessagePtr,
		     __errorMessageLength,
		     &__errorMessageLength );
#endif
//printf("errorMsgLen: %d\n", __errorMessageLength);
    if (rc == SQL_SUCCESS_WITH_INFO && __mallocPtr == 0) {
	/* not enough space in errorMessageBuffer */
	__errorMessageLength += 10;     // MYSQL needs at least an additional byte
	__mallocPtr = __errorMessagePtr = malloc(__errorMessageLength);
	if (__mallocPtr)
	    goto retry;
	/* else fail... */
    }
    if (rc == SQL_SUCCESS) {
	if (__arraySize(valueHolder) < 3) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}

	__PROTECT__(valueHolder);
	__stateBuffer[sizeof(__stateBuffer)-1] = '\0';
	state = __MKSTRING(__stateBuffer);
	__UNPROTECT__(valueHolder);
	__ArrayInstPtr(valueHolder)->a_element[0] = state;  __STORE(valueHolder, state);

	__PROTECT__(valueHolder);
	errorCode = __MKINT(__errorCode);
	__UNPROTECT__(valueHolder);
	__ArrayInstPtr(valueHolder)->a_element[1] = errorCode; __STORE(valueHolder, errorCode);

	__PROTECT__(valueHolder);
// error string is 0-terminated, errorMessageLength is longer (at leats woth Oracle)
//        errorMessage = __MKSTRING_L(__errorMessagePtr, __errorMessageLength);
	errorMessage = __MKSTRING(__errorMessagePtr);
	__UNPROTECT__(valueHolder);
	__ArrayInstPtr(valueHolder)->a_element[2] = errorMessage; __STORE(valueHolder, errorMessage);
    }
    if (__mallocPtr) {
	free(__mallocPtr);
    }
    RETURN (__odbcReturnCode(rc));

  badArg: ;
    TRACE((stderr, "SQLError rc=%d(%s)\n", (int)rc, __returnCodeString(rc)));
    RETURN (@global(ArgumentError));
%}
!

prim_sqlGetPrivateProfileStringFromFile:fileName section:section entry:entry default:defaultValue into:valueHolder
   "
    Returns: ODBC return code
   "

%{  /* UNLIMITEDSTACK(UNIXODBC) */
#ifdef HAS_SQLGetPrivateProfileString
    SQLCHAR *__fileName = NULL,
	 *__section = NULL,
	 *__entry = NULL,
	 *__defaultValue = NULL;
    SQLCHAR __stringValue[1024];
    SQLRETURN rc;
    OBJ stringValue = nil;
    int dummy;

    STRING_ARG(fileName, __fileName, dummy);
    STRING_NULL_ARG(section, __section, dummy);
    STRING_NULL_ARG(entry, __entry, dummy);
    STRING_ARG(defaultValue, __defaultValue, dummy);

    __stringValue[0] = '\0';

    rc = SQLGetPrivateProfileString(__section, __entry, __defaultValue, __stringValue, sizeof(__stringValue)-1, __fileName);
    TRACE ((stderr, "SQLGetPrivateProfileString('%s','%s','%s','%s') rc=%d(%s) val='%s'\n",
	    __section, __entry, __defaultValue, __fileName,
	    rc, __returnCodeString(rc),
	    __stringValue));

    if (rc) {
	if (__arraySize(valueHolder) < 1) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__stringValue[sizeof(__stringValue)-1] = '\0';
	__PROTECT__(valueHolder);
	stringValue = __MKSTRING(__stringValue);
	__UNPROTECT__(valueHolder);
	__ArrayInstPtr(valueHolder)->a_element[0] = stringValue; __STORE(valueHolder, stringValue);
    }
    RETURN( __odbcReturnCode(rc));

  badArg: ;
    RETURN (@global(ArgumentError));
#else
    RETURN (@global(UnsupportedOperation));
#endif /* HAS_SQLGetPrivateProfileString */
%}
!

prim_sqlWritePrivateProfileStringToFile:fileName section:section entry:entry value:stringValue
   "
    Returns: ODBC return code
   "

%{  /* UNLIMITEDSTACK(UNIXODBC) */
#ifdef HAS_SQLWritePrivateProfileString
    SQLCHAR *__fileName = NULL,
	 *__section = NULL,
	 *__entry = NULL,
	 *__stringValue = NULL;
    int dummyLen;
    SQLRETURN rc;

    STRING_ARG(fileName, __fileName, dummyLen);
    STRING_ARG(section, __section, dummyLen);
    STRING_NULL_ARG(entry, __entry, dummyLen);
    STRING_NULL_ARG(stringValue, __stringValue, dummyLen);

    rc = SQLWritePrivateProfileString(__section, __entry, __stringValue, __fileName);
    TRACE ((stderr, "SQLWritePrivateProfileString('%s','%s','%s','%s') rc=%d\n", __section, __entry, __stringValue, __fileName, rc));
    RETURN( __odbcReturnCode(rc));

  badArg: ;
    TRACE((stderr, "SQLError rc=%d(%s)\n", (int)rc, __returnCodeString(rc)));
    RETURN (@global(ArgumentError));
#else
    RETURN (@global(UnsupportedOperation));
#endif /* HAS_SQLWritePrivateProfileString */
%}
!

sqlGetErrorForHenv:henv hdbc:hdbc hstmt:hstmt
    |retVal valueHolder state errorCode errorStream recordNumber|

    valueHolder := Array new:3.
    recordNumber := 1.
    errorStream := '' writeStream.

    [
	retVal := self prim_sqlGetErrorForHenv:henv hdbc:hdbc hstmt:hstmt recordNumber:recordNumber into:valueHolder.
	retVal isSuccess
    ] whileTrue:[
	state := valueHolder at:1.
	errorCode := valueHolder at:2.
	errorStream nextPutAll:(valueHolder at:3); cr.
	recordNumber := recordNumber + 1.
    ].

    retVal isNoData ifFalse:[
	^ self primitiveFailed
    ].

    errorStream notEmpty ifTrue:[
	errorStream backStep.     "remove trailing cr"
    ].

    ^ (SQL::ODBCError newException
	state:state nativeErrorCode:errorCode errorString:errorStream contents)
!

sqlGetPrivateProfileStringFromFile:fileName section:section entry:entry default:defaultValue
    |retVal valueHolder stringValue|

    valueHolder := Array new:1.
    retVal := self prim_sqlGetPrivateProfileStringFromFile:fileName section:section entry:entry default:defaultValue into:valueHolder.
    stringValue := valueHolder at:1.

    "this is a noo-op if ret is success"
    retVal performErrorHandlingFor:self statement:nil.

    ^ stringValue

    "
     ODBCEnvironment debug:true.

     self new sqlGetPrivateProfileStringFromFile:'foo' section:'a' entry:'b' default:'bla'
    "
!

sqlWritePrivateProfileStringToFile:fileName section:section entry:entry value:stringValue
    |retVal|

    retVal := self prim_sqlWritePrivateProfileStringToFile:fileName section:section entry:entry value:stringValue.
    "this is a noo-op if ret is success"
    retVal performErrorHandlingFor:self statement:nil.

    "
     ODBCEnvironment debug:true.

     self new sqlWritePrivateProfileStringToFile:'foo' section:'a' entry:'b' value:'something'
    "
! !

!ODBCHandle methodsFor:'error handling'!

getError
    self subclassResponsibility
!

getInfoText
    "get the info text when SUCCES_WITH_INFO is returned"

    |ex|

    ex := self getError.
    ^ ex description.
!

handleError:result errorHandle:errorHandle
    self performErrorHandlingFor:nil
!

performErrorHandlingFor:aStatement
    |ex|

    ex := self getError.
    ex isNil ifTrue:[^ self].
    ex parameter:aStatement.
    ex raiseRequest.
! !

!ODBCHandle methodsFor:'instance release'!

releaseSubhandlesBeforeRelease
    self releaseSubhandles.
! !

!ODBCHandle methodsFor:'printing & storing'!

storeOn:aStream
    "DatabaseHandles cannot really be stored and restored."

    aStream
	nextPut:$(;
	nextPutAll:self className;
	nextPutAll:' new environmentHandle:'.
    environmentHandle storeOn:aStream.
    aStream nextPutAll:'; parentHandle:'.
    parentHandle storeOn:aStream.
    aStream nextPut:$).
! !

!ODBCHandle::ODBCDatabaseHandle methodsFor:'ODBC interface'!

commit
    ^ self prim_endTranOn:self handleType:self class SQL_HANDLE_DBC commit:self class SQL_COMMIT
!

primRelease
   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC hdbc  = (HDBC) __externalAddressVal(self);
    SQLRETURN rc;

    if (hdbc == 0) {
	/* handle is uninitialized or invalidated - nothing to be done */
	RETURN(@global(SQL_SUCCESS));
    }

#ifdef USE_ODBC_V3
# ifdef THREADED_CALLS
    if (@global(Unthreaded) != true) {
	do {
	    __threadErrno = 0;
	    rc = (SQLRETURN)__STX_API_NOINT_CALL2("SQLFreeHandle", SQLFreeHandle, (void *)SQL_HANDLE_DBC, hdbc);
	} while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
    } else
# endif
    {
	rc = SQLFreeHandle( SQL_HANDLE_DBC, hdbc);
    }
#else
# ifdef THREADED_CALLS
    if (@global(Unthreaded) != true) {
	do {
	    __threadErrno = 0;
	    rc = (SQLRETURN)__STX_API_NOINT_CALL1("SQLFreeConnect", SQLFreeConnect, hdbc);
	} while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
    } else
# endif
    {
	rc = SQLFreeConnect (hdbc);
    }
#endif /* USE_ODBC_V3 */

    TRACE ((stderr, "SQLFreeConnect(hdbc=%p) rc=%d(%s)\n", hdbc, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	__externalAddressVal(self) = 0;
    }
    RETURN (__odbcReturnCode(rc));
%}
!

prim_endTranOn:anObject handleType:handleType commit:commitOrRollbackValue

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC hdbc;
    SQLRETURN rc;
    SQLSMALLINT __handleType = (SQLSMALLINT)__intVal(handleType);
    SQLSMALLINT __commitOrRollback =(SQLSMALLINT) __intVal(commitOrRollbackValue);

    hdbc  = (HDBC) __externalAddressVal(anObject);

    rc = SQLEndTran(__handleType, hdbc, __commitOrRollback );
    TRACE ((stderr, "SQLEndTran(handleType=%d hdbc=%"_lx_", commit=%d) rc=%d(%s)\n",
			__handleType,  (INT)hdbc, __commitOrRollback, (int)rc, __returnCodeString(rc)));
    RETURN (__odbcReturnCode(rc));

%}


!

prim_sqlAlloc
   "
    Returns: ODBC return code
   "

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HENV henv;
    HDBC newHdbc;
    SQLRETURN rc;

    if (! __isHENV(__INST(environmentHandle))) {
	TRACE ((stderr, "sqlAllocConnect: henv is not an environmentHandle\n" ));
	RETURN (@global(AttributeError));
    }

    henv = (HENV) __externalAddressVal(__INST(environmentHandle));
    if (henv == 0) {
	TRACE ((stderr, "sqlAllocConnect: henv is NULL\n" ));
	RETURN (@global(AttributeError));
    }

#ifdef USE_ODBC_V3
    rc = SQLAllocHandle( SQL_HANDLE_DBC, henv, &newHdbc);
#else
    rc = SQLAllocConnect( henv, &newHdbc);
#endif
    TRACE ((stderr, "SQLAllocConnect -> hdbc=%"_lx_", rc=%d(%s)\n", (INT)newHdbc, (int)rc, __returnCodeString(rc) ));
    if (rc == SQL_SUCCESS) {
	__externalAddressVal(self) = newHdbc;
#if 0 && defined(UNIXODBC)
	// not supported in my SuSE 10.2 ODBC packages
	odbc_change_thread_support( newHdbc, 3 );  /* protection on a environment level */
#endif
    }
    RETURN( __odbcReturnCode(rc));
%}
!

prim_sqlConnectTo:databaseName userName:userName password:password
   "
    Returns: ODBC return code
   "

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC  hdbc  = (HDBC) __externalAddressVal(self);
    SQLRETURN rc = 0;
    SQLWCHAR  *__databaseName, *__userName, *__password;
    INT  __databaseNameL, __userNameL, __passwordL;

    if (hdbc == 0) {
	RETURN (@global(AttributeError));
    badArg: ;
	RETURN (@global(ArgumentError));
    }
    UNICODE16_STRING_ARG(databaseName, __databaseName, __databaseNameL);
    UNICODE16_STRING_ARG(userName, __userName, __userNameL);
    UNICODE16_STRING_ARG(password, __password, __passwordL);

#ifdef THREADED_CALLS
    if (@global(Unthreaded) != true) {
	SQLWCHAR databaseNameBuffer[SQL_MAX_DSN_LENGTH],
		 userNameBuffer[STXSQL_MAX_NAME_LEN],
		 passwdBuffer[STXSQL_MAX_NAME_LEN];

	if (__databaseNameL > SQL_MAX_DSN_LENGTH)
	    goto badArg;
	if (__userNameL > STXSQL_MAX_NAME_LEN)
	    goto badArg;
	if (__passwordL > STXSQL_MAX_NAME_LEN)
	    goto badArg;

	memcpy(databaseNameBuffer, __databaseName, __databaseNameL*sizeof(SQLWCHAR));
	memcpy(userNameBuffer, __userName, __userNameL*sizeof(SQLWCHAR));
	memcpy(passwdBuffer, __password, __passwordL*sizeof(SQLWCHAR));

	do {
	    __threadErrno = 0;
	    rc = (SQLRETURN)__STX_API_NOINT_CALL7("SQLConnectW", SQLConnectW,
						    hdbc,
						    databaseNameBuffer, __databaseNameL,
						    userNameBuffer,     __userNameL,
						    passwdBuffer,     __passwordL);
	} while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
    } else
#endif
    {
	do {
	    rc = SQLConnectW(hdbc,
			    __databaseName, __databaseNameL,
			    __userName,     __userNameL,
			    __password,     __passwordL);
	} while (rc == SQL_ERROR && __threadErrno == EINTR);
    }

    TRACE ((stderr, "SQLConnectW(%"_lx_") rc=%d(%s)\n", (INT)hdbc, (int)rc, __returnCodeString(rc)));
    RETURN ( __odbcReturnCode(rc) );
%}
!

prim_sqlDisconnect
   "
    Returns: ODBC return code
   "

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC  hdbc  = (HDBC) __externalAddressVal(self);
    SQLRETURN rc;
    char   *__szDSN, *__szUID, *__szAuthStr;

    if (hdbc == 0) {
	RETURN (@global(AttributeError));
    }

#ifdef THREADED_CALLS
    if (@global(Unthreaded) != true) {
	do {
	    __threadErrno = 0;
	    rc = (SQLRETURN)__STX_API_NOINT_CALL1("SQLDisconnect", SQLDisconnect, hdbc);
	} while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
    } else
#endif
    {
	rc = SQLDisconnect(hdbc);
    }

    TRACE ((stderr, "SQLDisconnect(%"_lx_") rc=%d(%s)\n", (INT)hdbc, (int)rc, __returnCodeString(rc)));
    RETURN (__odbcReturnCode(rc));
%}
!

prim_sqlGetConnectAttr:infoTypeNr into:valueHolder
"
    Returns: ODBC return code
"
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC  hdbc  = (HDBC) __externalAddressVal(self);
    SQLRETURN rc;
    int   __infoType;
    union {
	char  strValue[1024];
	int   intValue;
	unsigned int uintValue;
    } __info;

    SQLINTEGER   __resultStringlen;
    OBJ value = nil;

    if (hdbc == 0) {
	RETURN (@global(AttributeError));
    badArg: ;
	RETURN (@global(ArgumentError));
    }
    if (! __isSmallInteger(infoTypeNr)) {
	RETURN (@global(ArgumentError));
    }
    __infoType = __intVal(infoTypeNr);

   rc = SQLGetConnectAttr(hdbc, __infoType, &__info, sizeof(__info), &__resultStringlen);
    TRACE ((stderr, "SQLGetConnectAttr(%"_lx_", %d) rc=%d(%s)\n", (INT)hdbc, __infoType, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	TRACE ((stderr, "Going into switch case %d\n", __infoType));

	switch (__infoType) {
	    case SQL_ATTR_CURRENT_CATALOG:
	    case SQL_ATTR_TRACEFILE:
	    case SQL_ATTR_TRANSLATE_LIB:

	    /* a string value... */
		if (__resultStringlen >= 0) {
		    TRACE ((stderr, "Setting valueHolder to string %s\n" , __info.strValue));
		    __PROTECT__(valueHolder);
		    value = __MKSTRING_L(__info.strValue, __resultStringlen);
		    __UNPROTECT__(valueHolder);
		}
		break;

// SQL_ATTR_QUIET_MODE
// SQL_ATTR_TRANSLATE_OPTION
// SQL_ATTR_TXN_ISOLATION

	    case SQL_ATTR_ACCESS_MODE:
	    case SQL_ATTR_ASYNC_ENABLE:
	    case SQL_ATTR_AUTO_IPD:
	    case SQL_ATTR_AUTOCOMMIT:
	    case SQL_ATTR_CONNECTION_DEAD:
	    case SQL_ATTR_CONNECTION_TIMEOUT:
	    case SQL_ATTR_LOGIN_TIMEOUT:
	    case SQL_ATTR_METADATA_ID:
	    case SQL_ATTR_ODBC_CURSORS:
	    case SQL_ATTR_PACKET_SIZE:
	    case SQL_ATTR_TRACE:


	    default:
		TRACE ((stderr,"Setting valueHolder to %d\n" , __info.intValue));
		__PROTECT__(valueHolder);
		value = __MKUINT(__info.intValue);
		__UNPROTECT__(valueHolder);
		break;
	}
    }
    if (value != nil) {
	if (__arraySize(valueHolder) < 1) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = value; __STORE(valueHolder, value);
    }

    RETURN (__odbcReturnCode(rc));
%}
!

prim_sqlGetInfo:infoTypeNr into:valueHolder
   "
    Returns: ODBC return code
   "

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC  hdbc  = (HDBC) __externalAddressVal(self);
    SQLRETURN rc;
    int   __infoType;
    union {
	char  strValue[1024];
	int   intValue;
	unsigned int uintValue;
    } __info;
    SQLSMALLINT   __resultStringlen;
    OBJ value = nil;

    if (hdbc == 0) {
	RETURN (@global(AttributeError));
    badArg: ;
	RETURN (@global(ArgumentError));
    }
    if (! __isSmallInteger(infoTypeNr)) {
	RETURN (@global(ArgumentError));
    }
    __infoType = __intVal(infoTypeNr);
    __info.uintValue = 0;        /* take care, integer returned values may be 16 bits */

    rc = SQLGetInfo(hdbc, __infoType, &__info, sizeof(__info), &__resultStringlen);
    TRACE ((stderr, "SQLGetInfo(%"_lx_", %d) rc=%d(%s)\n", (INT)hdbc, __infoType, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	switch (__infoType) {
	    case SQL_CATALOG_NAME_SEPARATOR:
	    case SQL_CATALOG_TERM:
	    case SQL_DATA_SOURCE_NAME:
	    case SQL_DATABASE_NAME:
	    case SQL_DBMS_NAME:
	    case SQL_DBMS_VER:
	    case SQL_DRIVER_NAME:
	    case SQL_DRIVER_VER:
#ifdef SQL_DRIVER_ODBC_VER
	    case SQL_DRIVER_ODBC_VER:
#endif
	    case SQL_IDENTIFIER_QUOTE_CHAR:
#ifdef SQL_KEYWORDS
	    case SQL_KEYWORDS:
#endif
	    case SQL_ODBC_VER:
	    case SQL_PROCEDURE_TERM:
	    case SQL_SCHEMA_TERM:
	    case SQL_SERVER_NAME:
#ifdef SQL_SPECIAL_CHARACTERS
	    case SQL_SPECIAL_CHARACTERS:
#endif
	    case SQL_TABLE_TERM:
	    case SQL_USER_NAME:
	    case SQL_SEARCH_PATTERN_ESCAPE:
	    /* and many others... */
	    /* a string value... */
		if (__resultStringlen >= 0) {
		    if (__resultStringlen >= sizeof(__info.strValue)) {
			__resultStringlen = sizeof(__info.strValue);
		    }
		    __PROTECT__(valueHolder);
		    value = __MKSTRING_L(__info.strValue, __resultStringlen);
		    __UNPROTECT__(valueHolder);
		}
		break;

	    case SQL_ACCESSIBLE_PROCEDURES:
	    case SQL_ACCESSIBLE_TABLES:
#ifdef SQL_CATALOG_NAME
	    case SQL_CATALOG_NAME:
#endif
	    case SQL_COLUMN_ALIAS:
	    case SQL_DATA_SOURCE_READ_ONLY:
#ifdef SQL_DESCRIBE_PARAMETER
	    case SQL_DESCRIBE_PARAMETER:
#endif
	    case SQL_EXPRESSIONS_IN_ORDERBY:
	    case SQL_INTEGRITY:
#ifdef SQL_LIKE_ESCAPE_CLAUSE
	    case SQL_LIKE_ESCAPE_CLAUSE:
#endif
#ifdef SQL_MAX_ROW_SIZE_INCLUDES_LONG
	    case SQL_MAX_ROW_SIZE_INCLUDES_LONG:
#endif
	    case SQL_MULT_RESULT_SETS:
	    case SQL_MULTIPLE_ACTIVE_TXN:
#ifdef SQL_NEED_LONG_DATA_LEN
	    case SQL_NEED_LONG_DATA_LEN:
#endif
#if 0 /* == SQL_INTEGRITY */
#ifdef SQL_ODBC_SQL_OPT_IEF
	    case SQL_ODBC_SQL_OPT_IEF:
#endif
#endif
#ifdef SQL_ORDER_BY_COLUMNS_IN_SELECT
	    case SQL_ORDER_BY_COLUMNS_IN_SELECT:
#endif
#ifdef SQL_OUTER_JOINS
	    case SQL_OUTER_JOINS:
#endif
	    case SQL_PROCEDURES:
	    case SQL_ROW_UPDATES:
		/* and many others... */
		/* a "Y" or "N" string for a boolean... */
		if ((__info.strValue[0] == 'Y')
		 || (__info.strValue[0] == 'y')) {
		    value = true;
		} else {
		    value = false;
		}
		break;

#ifdef SQL_DATETIME_LITERALS
	    case SQL_DATETIME_LITERALS:
		if (__info.intValue == 0) {
		    value = false;
		} else {
		    value = true;
		}
		break;
#endif
#ifdef SQL_IDENTIFIER_CASE
	    case SQL_IDENTIFIER_CASE:
		switch (__info.intValue) {
		    case SQL_IC_MIXED:
			__PROTECT__(valueHolder);
			value = @symbol(SQL_IC_MIXED);
			__UNPROTECT__(valueHolder);
			break;
		    case SQL_IC_SENSITIVE:
			__PROTECT__(valueHolder);
			value = @symbol(SQL_IC_SENSITIVE);
			__UNPROTECT__(valueHolder);
			break;
		}
		break;
#endif

#ifdef SQL_ASYNC_MODE
	    case SQL_ASYNC_MODE:
		switch (__info.intValue) {
		    case SQL_AM_NONE:
			__PROTECT__(valueHolder);
			value = @symbol(SQL_AM_NONE);
			__UNPROTECT__(valueHolder);
			break;

		    case SQL_AM_CONNECTION:
			__PROTECT__(valueHolder);
			value = @symbol(SQL_AM_SESSION);
			__UNPROTECT__(valueHolder);
			break;

		    case SQL_AM_STATEMENT:
			__PROTECT__(valueHolder);
			value = @symbol(SQL_AM_STATEMENT);
			__UNPROTECT__(valueHolder);
			break;
		}
		break;
#endif

#if 0 /* == MAX_DRIVER_CONNECTIONS */
#ifdef SQL_ACTIVE_CONNECTIONS
	    case SQL_ACTIVE_CONNECTIONS:
#endif
#endif
#ifdef SQL_ACTIVE_ENVIRONMENTS
	    case SQL_ACTIVE_ENVIRONMENTS:
#endif
	    case SQL_ALTER_TABLE:
	    case SQL_BOOKMARK_PERSISTENCE:
	    case SQL_CATALOG_USAGE:
	    case SQL_CONCAT_NULL_BEHAVIOR:
	    case SQL_CONVERT_FUNCTIONS:
	    case SQL_CORRELATION_NAME:
	    case SQL_CURSOR_COMMIT_BEHAVIOR:
	    case SQL_CURSOR_ROLLBACK_BEHAVIOR:
	    case SQL_DEFAULT_TXN_ISOLATION:
#ifdef SQL_FILE_USAGE
	    case SQL_FILE_USAGE:
#endif
#ifdef SQL_GETDATA_EXTENSIONS
	    case SQL_GETDATA_EXTENSIONS:
#endif
#ifdef SQL_GROUP_BY
	    case SQL_GROUP_BY:
#endif
#ifdef SQL_MAX_BINARY_LITERAL_LEN
	    case SQL_MAX_BINARY_LITERAL_LEN:
#endif
	    case SQL_MAX_CATALOG_NAME_LEN:
#ifdef SQL_MAX_CHAR_LITERAL_LEN
	    case SQL_MAX_CHAR_LITERAL_LEN:
#endif
	    case SQL_MAX_COLUMN_NAME_LEN:
#ifdef SQL_MAX_COLUMNS_IN_GROUP_BY
	    case SQL_MAX_COLUMNS_IN_GROUP_BY:
#endif
#ifdef SQL_MAX_COLUMNS_IN_INDEX
	    case SQL_MAX_COLUMNS_IN_INDEX:
#endif
#ifdef SQL_MAX_COLUMNS_IN_ORDER_BY
	    case SQL_MAX_COLUMNS_IN_ORDER_BY:
#endif
#ifdef SQL_MAX_COLUMNS_IN_SELECT
	    case SQL_MAX_COLUMNS_IN_SELECT:
#endif
#ifdef SQL_MAX_COLUMNS_IN_TABLE
	    case SQL_MAX_COLUMNS_IN_TABLE:
#endif
	    case SQL_MAX_CONCURRENT_ACTIVITIES:
	    case SQL_MAX_CURSOR_NAME_LEN:
	    case SQL_MAX_DRIVER_CONNECTIONS:
#ifdef SQL_MAX_INDEX_SIZE
	    case SQL_MAX_INDEX_SIZE:
#endif
	    case SQL_MAX_PROCEDURE_NAME_LEN:
#ifdef SQL_MAX_ROW_SIZE
	    case SQL_MAX_ROW_SIZE:
#endif
	    case SQL_MAX_SCHEMA_NAME_LEN:
#ifdef SQL_MAX_STATEMENT_LEN
	    case SQL_MAX_STATEMENT_LEN:
#endif
	    case SQL_MAX_TABLE_NAME_LEN:
#ifdef SQL_MAX_TABLES_IN_SELECT
	    case SQL_MAX_TABLES_IN_SELECT:
#endif
#ifdef SQL_MAX_USER_NAME_LEN
	    case SQL_MAX_USER_NAME_LEN:
#endif
	    case SQL_NON_NULLABLE_COLUMNS:
#ifdef SQL_NULL_COLLATION
	    case SQL_NULL_COLLATION:
#endif
	    case SQL_NUMERIC_FUNCTIONS:
#ifdef SQL_OJ_CAPABILITIES
	    case SQL_OJ_CAPABILITIES:
#endif
#ifdef SQL_QUOTED_IDENTIFIER_CASE
	    case SQL_QUOTED_IDENTIFIER_CASE:
#endif
#ifdef SQL_SCHEMA_USAGE
	    case SQL_SCHEMA_USAGE:
#endif
	    case SQL_SCROLL_OPTIONS:
	    case SQL_STRING_FUNCTIONS:
#ifdef SQL_SUBQUERIES
	    case SQL_SUBQUERIES:
#endif
	    case SQL_SYSTEM_FUNCTIONS:
#ifdef SQL_TIMEDATE_ADD_INTERVALS
	    case SQL_TIMEDATE_ADD_INTERVALS:
#endif
#ifdef SQL_TIMEDATE_DIFF_INTERVALS
	    case SQL_TIMEDATE_DIFF_INTERVALS:
#endif
	    case SQL_TIMEDATE_FUNCTIONS:
	    case SQL_TXN_CAPABLE:
	    case SQL_TXN_ISOLATION_OPTION:
#ifdef SQL_UNION
	    case SQL_UNION:
#endif
	    default:
		__PROTECT__(valueHolder);
		value = __MKUINT(__info.uintValue);
		__UNPROTECT__(valueHolder);
		break;
	}
    }
    if (value != nil) {
	if (__arraySize(valueHolder) < 1) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = value; __STORE(valueHolder, value);
    }
    RETURN (__odbcReturnCode(rc));
%}
!

prim_sqlSetConnectAttr:option value:paramValue
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC  hdbc  = (HDBC) __externalAddressVal(self);
    SQLRETURN rc;

    int __option;
    INT __paramValue;

    char  strValue[1024];
    int   intValue;
    unsigned int uintValue;


    if (hdbc == 0) {
	RETURN (@global(AttributeError));
    badArg: ;
	RETURN (@global(ArgumentError));
    }

    if (! __isSmallInteger(option)) {
	RETURN (@global(ArgumentError));
    }
    __option = __intVal(option);
    __paramValue = __intVal(paramValue);

   rc = SQLSetConnectAttr(hdbc, __option, (void*)__paramValue, 0);

    RETURN (__odbcReturnCode(rc));
%}
!

rollback
    ^ self prim_endTranOn:self handleType:self class SQL_HANDLE_DBC commit:self class SQL_ROLLBACK
!

sqlAlloc
    |retVal|

    retVal := self prim_sqlAlloc.
    retVal isSuccess ifTrue:[
	parentHandle := environmentHandle.
	parentHandle register:self.
    ].
    ^ retVal.
!

sqlConnectTo:databaseName userName:userName password:password
    |retVal|

    retVal := self
	    prim_sqlConnectTo:databaseName asUnicode16String
	    userName:userName asUnicode16String
	    password:password asUnicode16String.

    retVal isSuccessOrSuccessWithInfo ifTrue:[
	connected := true.
	self registerChange.
    ].
    ^ retVal.
!

sqlDisconnect
    |retVal|

    self releaseSubhandles.
    retVal := self prim_sqlDisconnect.
    retVal isSuccessOrSuccessWithInfo ifTrue:[
	connected := false.
	self registerChange.
    ].
    ^ retVal.
!

sqlGetInfo:infoType
    |retVal infoTypeNr value valueHolder|

    infoType isInteger ifTrue:[
	infoTypeNr := infoType.
    ] ifFalse:[
	infoTypeNr := self class infoTypeNumberFromInfoTypeSymbol:infoType.
    ].

    valueHolder := Array new:1.
    retVal := self prim_sqlGetInfo:infoTypeNr into:valueHolder.
    value := valueHolder at:1.

    value notNil ifTrue:[
	^ value
    ].

    self address == 0 ifTrue:[
	^ self error:'DatabaseHandle is invalid'.
    ].

    retVal performErrorHandlingFor:self statement:nil.
! !

!ODBCHandle::ODBCDatabaseHandle methodsFor:'accessing'!

connected
    "is a connection established for the connection handle?

     return:<Boolean>
    "

    ^ connected ? false

    "Created: / 10.9.1999 / 13:50:57 / ps"
    "Modified: / 10.9.1999 / 14:08:37 / ps"
!

connected:aBoolean

    connected := aBoolean.

    "Created: / 20.8.1999 / 17:29:08 / ps"
    "Modified: / 10.9.1999 / 11:53:51 / ps"
!

setAddress:anAddress
    anAddress == 0 ifTrue:[
	connected == true ifTrue:[
	    self error:'did free without disconnect'
	].
    ].
    super setAddress:anAddress
! !

!ODBCHandle::ODBCDatabaseHandle methodsFor:'error handling'!

getError
    ^ self sqlGetErrorForHenv:environmentHandle hdbc:self hstmt:nil
! !

!ODBCHandle::ODBCDatabaseHandle methodsFor:'handle allocation & release'!

newStatementHandle
    |hst ret|

    hst := ODBCHandle::ODBCStatementHandle new.
    hst databaseHandle:self.
    hst environmentHandle:environmentHandle.
    ret := hst sqlAlloc.
    "this is a no-op if ret is succes"
    ret performErrorHandlingFor:self statement:nil.
    ^ hst
!

release
    |ret|

    connected == true ifTrue:[
	ret := self sqlDisconnect.
	"this is a no-op if ret is succes"
	ret performErrorHandlingFor:self statement:nil.
    ].
    super release.
! !

!ODBCHandle::ODBCDatabaseHandle methodsFor:'interface'!

autocommit
    |val|
    val := Array with:1.
    self prim_sqlGetConnectAttr:self class SQL_ATTR_AUTOCOMMIT into:val.
    ^ val first == self class SQL_AUTOCOMMIT_ON.
!

autocommit:aBoolean
    |attr|

    aBoolean ifTrue:[
	attr := self class SQL_AUTOCOMMIT_ON.
    ] ifFalse:[
	attr := self class SQL_AUTOCOMMIT_OFF.
    ].

    ^ self
	prim_sqlSetConnectAttr:self class SQL_ATTR_AUTOCOMMIT
	value:attr.
!

isAnsiApp:aBoolean
    "if true, convert all unicode data to ansi"

    |attr|

    aBoolean ifTrue:[
	attr := self class SQL_AA_TRUE.
    ] ifFalse:[
	attr := self class SQL_AA_FALSE.
    ].

    ^ self
	prim_sqlSetConnectAttr:self class SQL_ATTR_ANSI_APP
	value:attr.
! !

!ODBCHandle::ODBCEnvironmentHandle class methodsFor:'environment attributes'!

SQL_ATTR_ODBC_VERSION
"
   (ODBC 3.0)
"
%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(SQL_ATTR_ODBC_VERSION));
%}
! !

!ODBCHandle::ODBCEnvironmentHandle class methodsFor:'environment attributes values'!

SQL_OV_ODBC2
"
   (ODBC 3.0)
"
%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(SQL_OV_ODBC2));
%}
!

SQL_OV_ODBC3
"
   (ODBC 3.0)
"
%{  /* NOCONTEXT */
    RETURN (__MKSMALLINT(SQL_OV_ODBC3));
%}
! !

!ODBCHandle::ODBCEnvironmentHandle class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!ODBCHandle::ODBCEnvironmentHandle class methodsFor:'registering'!

register:aHandle
    HandleRegistry isNil ifTrue:[
	HandleRegistry := Registry new.
    ].
    HandleRegistry register:aHandle
!

registerChange:anEnvironmentHandle
    HandleRegistry registerChange:anEnvironmentHandle
!

unregister:anEnvironmentHandle
    HandleRegistry unregister:anEnvironmentHandle
! !

!ODBCHandle::ODBCEnvironmentHandle methodsFor:'ODBC interface'!

commit
    ^ self
	prim_endTranOn:self
	handleType:self class SQL_HANDLE_ENV
	commit:self class SQL_COMMIT
!

handleType
    ^ self class SQL_HANDLE_ENV
!

odbcVersion
   |array|
   array := Array new:1.
   self
    prim_sqlGetInfo:self class SQL_ATTR_ODBC_VERSION
    into:array.

   ^ array first

!

primRelease
   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HENV henv = (HENV) __externalAddressVal(self);
    SQLRETURN rc;

    if (henv == 0) {
	/* handle is uninitialized or invalidated - nothing to be done */
	RETURN(@global(SQL_SUCCESS));
    }

#ifdef USE_ODBC_V3
    rc = SQLFreeHandle( SQL_HANDLE_ENV, henv);
#else
    rc = SQLFreeEnv (henv);
#endif
    TRACE ((stderr, "SQLFreeEnv(henv=%"_lx_") rc=%d(%s)\n", (INT)henv, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	__externalAddressVal(self) = 0;
    }
    RETURN (__odbcReturnCode(rc));
%}
!

prim_endTranOn:anObject handleType:handleType commit:commitOrRollbackValue

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HENV henv;
    SQLRETURN rc;
    SQLSMALLINT __handleType = (SQLSMALLINT)__intVal(handleType);
    SQLSMALLINT __commitOrRollback =(SQLSMALLINT) __intVal(commitOrRollbackValue);

     henv  = (HENV) __externalAddressVal(anObject);

    rc = SQLEndTran(__handleType, henv, __commitOrRollback );
    TRACE ((stderr, "SQLEndTran(handleType=%d henv=%"_lx_", commit=%d) rc=%d(%s)\n", __handleType, (INT)henv, __commitOrRollback, (int)rc, __returnCodeString(rc)));
    RETURN (__odbcReturnCode(rc));

%}
!

prim_sqlAlloc

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    SQLRETURN rc;
    HENV newEnv;

#ifdef NEED_PTHREAD_INITIALIZE
    /*
     * somehow, errno_location returns NULL unless we initialize the
     * pthread system here manually - sigh.
     * Q: a bug in libpthread ?
     */
    fprintf(stderr, "1 - errno_location is: %"_lx_"\n", (INT)__errno_location() );
    __pthread_initialize();
    fprintf(stderr, "2 - errno_location is: %"_lx_"\n", (INT)__errno_location() );
#endif

#ifdef USE_ODBC_V3
    rc = SQLAllocHandle( SQL_HANDLE_ENV, SQL_NULL_HANDLE, &newEnv);
#else
    rc = SQLAllocEnv( &newEnv );
#endif
    TRACE ((stderr, "SQLAllocEnv -> henv=%"_lx_" rc=%d(%s)\n", (INT)newEnv, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	__externalAddressVal(self) = newEnv;
    }
    RETURN (__odbcReturnCode(rc));
%}
!

prim_sqlDataSources:direction into:valueHolder

%{  /* UNLIMITEDSTACK(UNIXODBC) */
#ifdef HAS_SQLDataSources
    HENV henv = (HENV) __externalAddressVal(self);
    SQLRETURN rc;
    int __direction;
    char __serverName[256];
    short __serverNameLength;
    char __description[256];
    short __descriptionLength;
    OBJ serverName = nil, description = nil;

    if (henv == 0) {
	/* handle is uninitialized or invalidated */
	RETURN ( @global(AttributeError));
    }
    if (direction == @symbol(SQL_FETCH_FIRST) ) {
	__direction = SQL_FETCH_FIRST;
    } else if (direction == @symbol(SQL_FETCH_NEXT) ) {
	__direction = SQL_FETCH_NEXT;
    } else if (direction == @symbol(SQL_FETCH_FIRST_USER) ) {
	__direction = SQL_FETCH_FIRST_USER;
    } else if (direction == @symbol(SQL_FETCH_FIRST_SYSTEM) ) {
	__direction = SQL_FETCH_FIRST_SYSTEM;
    } else {
	RETURN ( @global(ArgumentError));
    }

    rc = SQLDataSources (henv, __direction,
			 __serverName, sizeof(__serverName), &__serverNameLength,
			 __description, sizeof(__description), &__descriptionLength);

    TRACE ((stderr, "SQLDataSources(henv=%"_lx_") rc=%d(%s)\n", (INT)henv, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	if (__serverNameLength >= 0) {
	    __PROTECT__(valueHolder);
	    serverName = __MKSTRING_L(__serverName, __serverNameLength);
	    __UNPROTECT__(valueHolder);
	}
	if (__descriptionLength >= 0) {
	    __PROTECT__(valueHolder);
	    description = __MKSTRING_L(__description, __descriptionLength);
	    __UNPROTECT__(valueHolder);
	}

	if (__arraySize(valueHolder) < 2) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = serverName;  __STORE(valueHolder, serverName);
	__ArrayInstPtr(valueHolder)->a_element[1] = description; __STORE(valueHolder, description);
    }
    RETURN ( __odbcReturnCode(rc));
#else /* not HAS_SQLDataSources */
    RETURN ( @global(UnsupportedOperation) );
#endif /* HAS_SQLDataSources */
%}
!

prim_sqlDrivers:direction into:valueHolder

%{  /* UNLIMITEDSTACK(UNIXODBC) */
#ifdef HAS_SQLDrivers
    HENV henv = (HENV) __externalAddressVal(self);
    SQLRETURN rc;
    int __direction;
    char __driverDescription[256];
    short __driverDescriptionLength;
    char __driverAttributes[256];
    short __driverAttributesLength;
    OBJ driverDescription = nil, driverAttributes = nil;

    if (henv == 0) {
	/* handle is uninitialized or invalidated */
	RETURN( @global(AttributeError));
    }
    if (direction == @symbol(SQL_FETCH_FIRST) ) {
	__direction = SQL_FETCH_FIRST;
    } else if (direction == @symbol(SQL_FETCH_NEXT) ) {
	__direction = SQL_FETCH_NEXT;
    } else {
	RETURN( @global(ArgumentError));
    }

    rc = SQLDrivers (henv, __direction,
			 __driverDescription, sizeof(__driverDescription), &__driverDescriptionLength,
			 __driverAttributes, sizeof(__driverAttributes), &__driverAttributesLength);

    TRACE ((stderr, "SQLDrivers(henv=%"_lx_") rc=%d(%s)\n", (INT)henv, (int)rc, __returnCodeString(rc)));

    if (rc == SQL_SUCCESS) {
	if (__driverDescriptionLength >= 0) {
	    __PROTECT__(valueHolder);
	    driverDescription = __MKSTRING_L(__driverDescription, __driverDescriptionLength);
	    __UNPROTECT__(valueHolder);
	}
	if (__driverAttributesLength >= 0) {
	    __PROTECT__(valueHolder);
	    driverAttributes = __MKSTRING_L(__driverAttributes, __driverAttributesLength);
	    __UNPROTECT__(valueHolder);
	}
	if (__arraySize(valueHolder) < 2) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = driverDescription;  __STORE(valueHolder, driverDescription);
	__ArrayInstPtr(valueHolder)->a_element[1] = driverAttributes; __STORE(valueHolder, driverAttributes);
    }
    RETURN ( __odbcReturnCode(rc) );
#else /* not HAS_SQLDrivers */
    RETURN ( @global(UnsupportedOperation) );
#endif /* HAS_SQLDrivers */
%}
!

prim_sqlGetInfo:infoTypeNr into:valueHolder
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HENV henv;
    SQLRETURN rc;
    int __infoType;
    SQLINTEGER   __resultStringlen;
    OBJ value = nil;

    union {
	char  strValue[1024];
	int   intValue;
	unsigned int uintValue;
    } __info;

    if (! __isSmallInteger(infoTypeNr)) {
	RETURN (@global(ArgumentError));
    }
    __infoType = __intVal(infoTypeNr);
    __info.uintValue = 0;

    henv  = (HENV) __externalAddressVal(self);

    rc = SQLGetEnvAttr(henv, __infoType, &__info, sizeof(__info), &__resultStringlen);
    TRACE ((stderr, "SQLGetEnvAttr(%"_lx_", %d) rc=%d(%s)\n", (INT)henv, __infoType, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	switch (__infoType) {
	    default:
		__PROTECT__(valueHolder);
		value = __MKUINT(__info.uintValue);
		__UNPROTECT__(valueHolder);
		break;
       }
    }
    if (value != nil) {
	if (__arraySize(valueHolder) < 1) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = value; __STORE(valueHolder, value);
    }
    RETURN (__odbcReturnCode(rc));
%}
!

rollback
    ^ self
	prim_endTranOn:self
	handleType:self class SQL_HANDLE_ENV
	commit:self class SQL_ROLLBACK
!

sqlAlloc
   "
    Returns: ODBC return code
    Side effect: self has a valid handle
   "
    |retVal|

    self
	assert:self address == 0
	message:'EnvironmentHandle has already been allocated'.

    retVal := self prim_sqlAlloc.
    retVal isSuccess ifTrue:[
	self register.
    ].
    ^ retVal.

    "
     DebugFlag := true.
     self new sqlAlloc
    "
!

sqlDataSources:direction
    |retVal serverName description valueHolder|

    valueHolder := Array new:2.
    retVal := self prim_sqlDataSources:direction into:valueHolder.

    retVal isNoData ifTrue:[
	^ nil
    ].
    "this is a noo-op if ret is success"
    retVal performErrorHandlingFor:self statement:nil.

    serverName := valueHolder at:1.
    description := valueHolder at:2.
    ^ serverName -> (self extractKeyValuesFrom:description)
!

sqlDrivers:direction
    |retVal driverDescription driverAttributes valueHolder|

    valueHolder := Array new:2.
    retVal := self prim_sqlDrivers:direction into:valueHolder.

    retVal isNoData ifTrue:[
	^ nil
    ].
    "this is a noo-op if ret is success"
    retVal performErrorHandlingFor:self statement:nil.

    driverDescription := valueHolder at:1.
    driverAttributes := valueHolder at:2.

    ^ driverDescription -> (self extractKeyValuesFrom:driverAttributes)
!

sqlSetEnvionmentOption:option value:paramValue
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HENV henv  = (HENV) __externalAddressVal(self);
    SQLRETURN rc;
    INT __option, __paramValue;

    if (henv == 0) {
	RETURN (@global(AttributeError));
    }

    if (! __isSmallInteger(option)) {
	RETURN (@global(ArgumentError));
    }
    __option = __intVal(option);

    if ( !__isSmallInteger(paramValue)) {
      RETURN (@global(ArgumentError));
    }
    __paramValue = __intVal(paramValue);

    rc = SQLSetEnvAttr(henv, __option, (SQLPOINTER) __paramValue ,0);
    TRACE ((stderr, "SQLSetEnvAttr(%"_lx_", %"_ld_") rc=%d(%s)\n", (INT)henv, (INT)__option, (int)rc, __returnCodeString(rc)));
    RETURN (__odbcReturnCode(rc));

%}
! !

!ODBCHandle::ODBCEnvironmentHandle methodsFor:'accessing'!

environmentHandle
    ^ nil
!

environmentHandle:aHandle
    self shouldNotImplement
! !

!ODBCHandle::ODBCEnvironmentHandle methodsFor:'error handling'!

getError
    ^ self sqlGetErrorForHenv:self hdbc:nil hstmt:nil
! !

!ODBCHandle::ODBCEnvironmentHandle methodsFor:'handle allocation & release'!

register
    "environment handles are registered with the class"
    self class register:self.
!

registerChange
    "environment handles are registered with the class"

    self class registerChange:self.
!

release
    "environment handles are registered with the class"

    super release.
    self class unregister:self.
! !

!ODBCHandle::ODBCEnvironmentHandle methodsFor:'handle creation'!

newDatabaseHandle
    |hdb ret|

    hdb := ODBCHandle::ODBCDatabaseHandle new.
    hdb environmentHandle:self.
    ret := hdb sqlAlloc.
    "this is a no-op if ret is succes"
    ret performErrorHandlingFor:self statement:nil.

    ^ hdb
!

newErrorHandle
    ^ nil
! !

!ODBCHandle::ODBCEnvironmentHandle methodsFor:'initialization'!

initialize
    |ret|

    ret := self sqlAlloc.
    "this is a no-op if ret is succes"
    ret performErrorHandlingFor:self statement:nil.

    ret := self
       sqlSetEnvionmentOption:self class SQL_ATTR_ODBC_VERSION
       value:self class SQL_OV_ODBC3.
    "this is a no-op if ret is succes"
    ret performErrorHandlingFor:self statement:nil.

    "
     self new
    "
! !

!ODBCHandle::ODBCEnvironmentHandle methodsFor:'private'!

extractKeyValuesFrom:aString
    |s dict key value|

    dict := Dictionary new.
    s := aString readStream.
    [s atEnd] whileFalse:[
	s skipSeparators.
	key := s upTo:$=.
	s skipSeparators.
	value := s upTo:(Character value:0).
	dict at:key put:value.
	s skipSeparators.
    ].
    ^ dict
!

extractMultipleValuesFrom:aString
    |s values value|

    values := OrderedCollection new.
    s := aString readStream.
    [s atEnd] whileFalse:[
	value := s upTo:(Character value:0).
	values add:value.
    ].
    ^ values
! !

!ODBCHandle::ODBCStatementHandle class methodsFor:'other odbc values'!

SQL_IS_INTEGER
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_IS_INTEGER));
%}
!

SQL_IS_UINTEGER
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_IS_UINTEGER));
%}
! !

!ODBCHandle::ODBCStatementHandle class methodsFor:'statement attributes'!

SQL_ADD
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ADD));
%}
!

SQL_ATTR_CONCURRENCY
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_CONCURRENCY));
%}
!

SQL_ATTR_CURSOR_TYPE
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_CURSOR_TYPE));
%}
!

SQL_ATTR_ROW_ARRAY_SIZE
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_ROW_ARRAY_SIZE));
%}
!

SQL_ATTR_ROW_BIND_TYPE
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_ATTR_ROW_BIND_TYPE));
%}
!

SQL_DELETE_BY_BOOKMARK
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_DELETE_BY_BOOKMARK));
%}
!

SQL_FETCH_BY_BOOKMARK
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_FETCH_BY_BOOKMARK));
%}
!

SQL_UPDATE_BY_BOOKMARK
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_UPDATE_BY_BOOKMARK));
%}
! !

!ODBCHandle::ODBCStatementHandle class methodsFor:'statement attributes values'!

SQL_CONCUR_LOCK
%{  /* NOCONTEXT */
   RETURN (__MKSMALLINT(SQL_CONCUR_LOCK));
%}
! !

!ODBCHandle::ODBCStatementHandle methodsFor:'OCBC interface - temp'!

bindCols:storage types:fieldCTypes sizes:fieldSizes offsets:fieldOffsets
    |errorOrNil|

%{
    SQLRETURN sr;
    SQLHSTMT hstmt  = (HSTMT) __externalAddressVal(self);;

    if (__isArray(fieldSizes)
     && __isArray(fieldOffsets)
     && __isArray(fieldCTypes)
     && (__arraySize(fieldSizes) == __arraySize(fieldOffsets))
     && (__arraySize(fieldSizes) == __arraySize(fieldCTypes))
     && __isExternalBytes(storage)
    ) {
	char *data = (char *)__externalBytesVal(storage);
	int numFields = __arraySize(fieldSizes);
	{
	    SQLLEN *colSizes;
	    int i;

	    colSizes = malloc(sizeof(*colSizes) * numFields);
	    if (colSizes == NULL) {
		// printf( "failed to malloc collSizes for %d fields\n", numFields);
		errorOrNil = @symbol(malloc);
		goto getOutOfHere;
	    }

	    // Bind each column (of the first row)
	    for (i=1; i<=numFields; i++) {
		OBJ sql_c_type_ST = __arrayVal(fieldCTypes)[i-1];
		int sql_c_type_C = __intVal(sql_c_type_ST);
		OBJ fieldOffset_ST = __arrayVal(fieldOffsets)[i-1];
		int fieldOffset_C = __intVal(fieldOffset_ST);
		OBJ fieldSize_ST = __arrayVal(fieldSizes)[i-1];
		int fieldSize_C = __intVal(fieldSize_ST);
		char *fieldAddr = data + fieldOffset_C;

		colSizes[i-1] = (sql_c_type_C == SQL_C_CHAR) ? SQL_NTS : fieldSize_C;
		sr = SQLBindCol(hstmt, i, sql_c_type_C, fieldAddr, fieldSize_C, &(colSizes[i-1]));
		if (sr != SQL_SUCCESS && sr != SQL_SUCCESS_WITH_INFO) {
		    // printf( "Error in Binding %d in OnViewBulkinsert\n", i);
		    __printErrors(hstmt, SQL_HANDLE_STMT);
		    errorOrNil = @symbol(SQLBindCol);
		    goto getOutOfHere;
		}
	    }
	}
    }
getOutOfHere: ;
    // fprintf(stderr, "Get out of here!\n");
%}.
    errorOrNil notNil ifTrue:[
	self error:'error in bind cols: ',errorOrNil.
    ].
!

bulkInsert:storage numRows:numRows_ST rowStorageSize:rowStorageSize_ST types:fieldCTypes sizes:fieldSizes offsets:fieldOffsets sqlSelect:sqlSelectStatement
"
    Works with MySQL
    ----------------
    BUGS:

    Problem with Access:
       1) 'When' it works it inserts null data in varchars after the first one
       2) We receive an error message 'Fehler in der Funktionsreihenfolge' when
        doing a SELECT on the data after the insert.

    Problems with Oracle:
       1) VERY slow
       2) Always inserts null values into columns for VARCHARS.

    The implementation:

        This implementation uses bind by row. This was decided as through testing I found that
        this type of binding only fully worked with Oracle. We needed BULK insert for MySQL.
        There are many examples involving binding by row and very little about binding
        by column. The implementation of binding by column should be much easier as we
        do not need to construct c structs by hand.
"

    self
        prim_setStatementAttribute:self class SQL_ATTR_CURSOR_TYPE
        value:self class SQL_CURSOR_DYNAMIC
        stringLength:0.

    self
        prim_setStatementAttribute:self class SQL_ATTR_CONCURRENCY
        value:self class SQL_CONCUR_LOCK
        stringLength:0.

    self sqlExecuteDirect:sqlSelectStatement.

    self
        prim_setStatementAttribute:self class SQL_ATTR_ROW_ARRAY_SIZE
        value:numRows_ST
        stringLength:0.


"
    When this is called row wise binding is specified
"
    self
        prim_setStatementAttribute:self class SQL_ATTR_ROW_BIND_TYPE
        value:rowStorageSize_ST
        stringLength:0.

    self bindCols:storage types:fieldCTypes sizes:fieldSizes offsets:fieldOffsets.
    self prim_sqlBulkOperations:self class SQL_ADD.

    self sqlCloseCursor.

    "Modified (comment): / 09-11-2017 / 09:42:27 / mawalch"
!

prim_SQLBindCol:columnNumber targetType:sql_c_type targetValuePtr:targetValuePtr bufferLength:fieldSize stringLengthOrIndexAddress:stringLengthOrIndexAddress
"
 To be tested with databases other than MySQL
"
%{
#if 0
    SQLRETURN sr;
    SQLUSMALLINT __columnNumber = __intVal(columnNumber);
    SQLSMALLINT __targetType = __intVal(sql_c_type);
    SQLINTEGER __fieldSize = __intVal(fieldSize);
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);

    SQLLEN  __stringLengthOrIndexAddress =  (SQLLEN)__externalAddressVal(stringLengthOrIndexAddress);

    SQLPOINTER  __targetValuePtr = __externalAddressVal(targetValuePtr);

    // Add new rows to the database
    sr = SQLBindCol(hstmt, __columnNumber, __targetType, __targetValuePtr, __fieldSize, &(__stringLengthOrIndexAddress[i-1]));

    if(sr != SQL_SUCCESS && sr != SQL_SUCCESS_WITH_INFO){
	fprintf(stderr, "Error in bulk insert\n");
	__printErrors(hstmt, SQL_HANDLE_STMT);
	RETURN (__odbcReturnCode(sr));
    }
#endif
%}.
    self shouldImplement
! !

!ODBCHandle::ODBCStatementHandle methodsFor:'ODBC interface'!

primRelease
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;

    if (hstmt == 0) {
	/* handle is uninitialized or invalidated - nothing to be done */
	RETURN(@global(SQL_SUCCESS));
    }

    rc = SQLFreeHandle (SQL_HANDLE_STMT, hstmt);
    TRACE ((stderr, "SQLFreeHandle(SQL_HANDLE_STMT, hstmt=%"_lx_") rc=%d(%s)\n", (INT)hstmt, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	__externalAddressVal(self) = 0;
    }
    RETURN (__odbcReturnCode(rc));
%}
!

prim_setStatementAttribute: anAttribute value:aValue stringLength:stringLength
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    SQLRETURN sr;
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLINTEGER __attr = __intVal(anAttribute);

    SQLPOINTER __aValue;
    SQLINTEGER __stringLength = __intVal(stringLength);

    if(__isInteger(aValue)){
	__aValue = (SQLPOINTER)__intVal(aValue);
    } else {
	__printErrors(hstmt, SQL_HANDLE_STMT);
	RETURN(self);
    }


	// Lock out other users.
	sr = SQLSetStmtAttr(hstmt, __attr, __aValue, __stringLength);
	if(sr != SQL_SUCCESS && sr != SQL_SUCCESS_WITH_INFO)
		__printErrors(hstmt, SQL_HANDLE_STMT);

%}
!

prim_sqlAlloc

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HDBC hdbc;
    HSTMT newStmt;
    SQLRETURN rc;

    if (!__isHDBC(__INST(parentHandle))) {
	RETURN (@global(AttributeError));
    }
    hdbc = (HDBC) __externalAddressVal(__INST(parentHandle));
    if (hdbc == 0) {
	RETURN (@global(AttributeError));
    }

#ifdef USE_ODBC_V3
    rc = SQLAllocHandle( SQL_HANDLE_STMT, hdbc, &newStmt);
#else
    rc = SQLAllocStmt( hdbc, &newStmt );
#endif
    TRACE ((stderr, "SQLAllocStmt(%"_lx_") -> hstmt=%"_lx_" rc=%d(%s)\n", (INT)hdbc, (INT)newStmt, (int)rc, __returnCodeString(rc)));
    if (rc == SQL_SUCCESS) {
	__externalAddressVal(self) = newStmt;
    }
    RETURN (__odbcReturnCode(rc) );
%}
!

prim_sqlBindCol:colNr cTypeNr:cTypeNr columnSize:columnSize valueBuffer:valueBuffer sizeInfo:sizeInfo
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt;
    SQLRETURN rc;
    int    __cType;
    int    __colNr, __valueBufferSize;
    void*  __valuePtr;
    void*  __sizePtr;
    static int __size;

    hstmt = (HSTMT) __externalAddressVal(self);
    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }
    if (! __isExternalBytesLike(valueBuffer)) {
	RETURN (@global(ArgumentError));
    }
    __valuePtr = __externalBytesAddress(valueBuffer);
    __valueBufferSize = __smallIntegerVal(__externalBytesSize(valueBuffer));

    if (! __isSmallInteger(cTypeNr)) {
	RETURN (@global(ArgumentError));
    }
    __cType = __intVal(cTypeNr);

    if (__isExternalBytesLike(sizeInfo)) {
	__sizePtr = __externalBytesAddress(sizeInfo);
    } else {
	 if (sizeInfo == @symbol(SQL_NTS)) {
	    __size = SQL_NTS;
	} else if ((sizeInfo == nil) || (sizeInfo == @symbol(SQL_NULL_DATA))) {
	    __size = SQL_NULL_DATA;
	} else if (sizeInfo == @symbol(SQL_DEFAULT_PARAM)) {
	    __size = SQL_DEFAULT_PARAM;
	} else if (sizeInfo == @symbol(SQL_DATA_AT_EXEC)) {
	    __size = SQL_DATA_AT_EXEC;
	} else {
	    RETURN (@global(ArgumentError));
	}
	 __sizePtr = &__size;
    }

    if (__isSmallInteger(colNr)) {
	__colNr = __smallIntegerVal(colNr);
    } else {
	RETURN (@global(ArgumentError));
    }

    rc = SQLBindCol( hstmt,
			   __colNr,
			   __cType,
			   __valuePtr,
			   __valueBufferSize,
			   __sizePtr );

    TRACE ((stderr, "SQLBindCol(col=%d, ctype=%d(%s), bufSize=%d) rc=%d\n",
		__colNr, __cType, __cTypeString(__cType), __valueBufferSize, (int)rc));
    RETURN (__odbcReturnCode(rc));
%}
!

prim_sqlBindParameter:colNr type:paramType cTypeNr:cTypeNr sqlTypeNr:sqlTypeNr columnSize:columnSize scale:scale valueBuffer:valueBuffer sizeInfo:sizeInfo
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt;
    SQLRETURN rc;
    int    __sqlType;
    int    __cType;
    int    __paramType;
    int    __colNr, __columnSize, __scale, __valueBufferSize;
    void*  __valuePtr;
    SQLLEN*  __sizePtr;
    static SQLLEN __size;

    hstmt = (HSTMT) __externalAddressVal(self);
    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }
    if (! __isExternalBytesLike(valueBuffer)) {
	RETURN (@global(ArgumentError));
    }
    __valuePtr = __externalBytesAddress(valueBuffer);
    __valueBufferSize = __smallIntegerVal(__externalBytesSize(valueBuffer));

    if (paramType == @symbol(SQL_PARAM_INPUT)) {
	__paramType = SQL_PARAM_INPUT;
    } else if (paramType == @symbol(SQL_PARAM_INPUT_OUTPUT)) {
	__paramType = SQL_PARAM_INPUT_OUTPUT;
    } else  if (paramType == @symbol(SQL_PARAM_OUTPUT)) {
	__paramType = SQL_PARAM_OUTPUT;
    } else {
	RETURN (@global(ArgumentError));
    }

    if (! __isSmallInteger(sqlTypeNr)) {
	RETURN (@global(ArgumentError));
    }
    __sqlType = __intVal(sqlTypeNr);

    if (! __isSmallInteger(cTypeNr)) {
	RETURN (@global(ArgumentError));
    }
    __cType = __intVal(cTypeNr);

    if (__isExternalBytesLike(sizeInfo)) {
	__sizePtr = (SQLLEN *)__externalBytesAddress(sizeInfo);
    } else {
	 if (sizeInfo == @symbol(SQL_NTS)) {
	    __size = SQL_NTS;
	} else if ((sizeInfo == nil) || (sizeInfo == @symbol(SQL_NULL_DATA))) {
	    __size = SQL_NULL_DATA;
	} else if (sizeInfo == @symbol(SQL_DEFAULT_PARAM)) {
	    __size = SQL_DEFAULT_PARAM;
	} else if (sizeInfo == @symbol(SQL_DATA_AT_EXEC)) {
	    __size = SQL_DATA_AT_EXEC;
	} else {
	    RETURN (@global(ArgumentError));
	}
	 __sizePtr = &__size;
    }

    if (__isSmallInteger(colNr)) {
	__colNr = __smallIntegerVal(colNr);
    } else {
	RETURN (@global(ArgumentError));
    }
    if (__isSmallInteger(columnSize)) {
	__columnSize = __smallIntegerVal(columnSize);
    } else {
	RETURN (@global(ArgumentError));
    }
    if (__isSmallInteger(scale)) {
	__scale = __smallIntegerVal(scale);
    } else {
	RETURN (@global(ArgumentError));
    }

    rc = SQLBindParameter( hstmt,
			   __colNr,
			   __paramType,
			   __cType,
			   __sqlType,
			   __columnSize,
			   __scale,
			   __valuePtr,
			   __valueBufferSize,
			  __sizePtr );

    TRACE ((stderr, "SQLBindParameter(col=%d, ctype=%d(%s), sqlType=%d(%s), colSize=%d, scale=%d, bufSize=%d) rc=%d\n",
		__colNr, __cType, __cTypeString(__cType), __sqlType, __sqlTypeString(__sqlType), __columnSize, __scale, __valueBufferSize, (int)rc));
    RETURN (__odbcReturnCode(rc));
%}
!

prim_sqlBulkOperations:anOperationIndicator
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    SQLRETURN sr;
    int operation = __intVal(anOperationIndicator);
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);

    sr = SQLBulkOperations(hstmt, operation);

    if(sr != SQL_SUCCESS && sr != SQL_SUCCESS_WITH_INFO){
	fprintf(stderr, "Error in bulk insert\n");
	__printErrors(hstmt, SQL_HANDLE_STMT);
	RETURN (__odbcReturnCode(sr));
    }

%}
!

prim_sqlDescribeCol:colNr into:valueHolder

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    SQLSMALLINT __colNr;
    char __columnNameBuffer[256+1];
    SQLSMALLINT __columnNameLength = 0;
    SQLSMALLINT __sqlTypeNr = 0;
    SQLSMALLINT __scale = 0;
    SQLSMALLINT __isnullable = 0;
    SQLULEN __columnSize = 0;
    OBJ name = nil;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }

    if (! __isSmallInteger(colNr)) {
	RETURN (@global(AttributeError));
    }
    __colNr = __intVal(colNr);

    rc = SQLDescribeCol(hstmt, __colNr,
		__columnNameBuffer, sizeof(__columnNameBuffer)-1, &__columnNameLength,
		&__sqlTypeNr, &__columnSize, &__scale, &__isnullable);

    __columnNameBuffer[sizeof(__columnNameBuffer)-1] = '\0';
    if (__columnNameLength <= sizeof(__columnNameBuffer)-1) {
	__columnNameBuffer[__columnNameLength] = '\0';
    }

    TRACE ((stderr, "SQLDescribeCol(col=%d) rc=%d, name=\"%s\", sqlType=%d(%s) sz=%d, digits=%d nullable=%d\n",
		__colNr, (int)rc, __columnNameBuffer,
		__sqlTypeNr, __sqlTypeString(__sqlTypeNr), (int)__columnSize,
		__scale, __isnullable));

    if (rc == SQL_SUCCESS) {
	__columnNameBuffer[sizeof(__columnNameBuffer)-1] = '\0';
	__PROTECT__(valueHolder);
	name = __MKSTRING(__columnNameBuffer);
	__UNPROTECT__(valueHolder);

	if (__arraySize(valueHolder) < 5) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = name;  __STORE(valueHolder, name);
	__ArrayInstPtr(valueHolder)->a_element[1] = __MKSMALLINT(__columnSize);
	__ArrayInstPtr(valueHolder)->a_element[2] = __MKSMALLINT(__scale);
	__ArrayInstPtr(valueHolder)->a_element[3] = __isnullable == 1 ? true : false;
	__ArrayInstPtr(valueHolder)->a_element[4] = __MKSMALLINT(__sqlTypeNr);
    }
    RETURN(__odbcReturnCode(rc));
%}
!

prim_sqlDescribeParam:paramNr into:valueHolder

%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    SQLUSMALLINT __paramNr;
    SQLSMALLINT __sqlTypeNr = 0;
    SQLSMALLINT __scale = 0;
    SQLSMALLINT __isnullable = 0;
    SQLULEN __columnSize = 0;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }

    if (! __isSmallInteger(paramNr)) {
	RETURN (@global(AttributeError));
    }
    __paramNr = __intVal(paramNr);

    rc = SQLDescribeParam(hstmt, __paramNr,
		&__sqlTypeNr, &__columnSize, &__scale, &__isnullable);

    TRACE ((stderr, "SQLDescribeParam(param=%d) rc=%d, sqlType=%d(%s) sz=%d, digits=%d nullable=%d\n",
		__paramNr, (int)rc,
		__sqlTypeNr, __sqlTypeString(__sqlTypeNr), (int)__columnSize,
		(int)__scale, __isnullable));

    if (rc == SQL_SUCCESS) {
	if (__arraySize(valueHolder) < 4) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = __MKSMALLINT(__columnSize);
	__ArrayInstPtr(valueHolder)->a_element[1] = __MKSMALLINT(__scale);
	__ArrayInstPtr(valueHolder)->a_element[2] = __MKSMALLINT(__isnullable);
	__ArrayInstPtr(valueHolder)->a_element[3] = __MKSMALLINT(__sqlTypeNr);
    }
    RETURN(__odbcReturnCode(rc));
%}
!

prim_sqlNumParamsInto:valueHolder
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    SQLSMALLINT __numParams = 0;
    OBJ numParams = nil;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }
    rc = SQLNumParams(hstmt, &__numParams);

    TRACE ((stderr, "SQLNumParams rc=%d, nc = %d\n", (int)rc, __numParams));
    if (rc == SQL_SUCCESS) {
	numParams = __MKSMALLINT(__numParams);

	if (__arraySize(valueHolder) < 1) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = numParams;
    }

    RETURN (__odbcReturnCode(rc));
%}
!

prim_sqlNumResultColsInto:valueHolder
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    SQLSMALLINT __numCols = 0;
    OBJ numCols = nil;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }
    rc = SQLNumResultCols(hstmt, &__numCols);

    TRACE ((stderr, "SQLNumResultCols rc=%d, nc = %d\n", (int)rc, __numCols));
    if (rc == SQL_SUCCESS) {
	numCols = __MKSMALLINT(__numCols);

	if (__arraySize(valueHolder) < 1) {
	    fprintf(stderr, "valueHolder too small\n");
	    RETURN (nil);
	}
	__ArrayInstPtr(valueHolder)->a_element[0] = numCols;
    }

    RETURN (__odbcReturnCode(rc));
%}
!

sqlAlloc
   "
    Returns: ODBC return code
    Side effect: self has a valid handle
   "
    |retVal|

    self address ~~ 0 ifTrue:[
	^ self error:'StatementHandle has already been allocated'.
    ].
    retVal := self prim_sqlAlloc.
    retVal isSuccess ifTrue:[
	parentHandle register:self.
    ].
    ^ retVal.
!

sqlBindCol:colNr cType:cType columnSize:columnSize  valueBuffer:valueBuffer sizeInfo:sizeInfo
    "Returns: ODBC return code"

    |cTypeNr retVal|

    cType isInteger ifTrue:[
	cTypeNr := cType.
    ] ifFalse:[
	cTypeNr := self class cTypeNumberFromCTypeSymbol:cType.
    ].
    retVal := self
	    prim_sqlBindCol:colNr
	    cTypeNr:cTypeNr
	    columnSize:columnSize
	    valueBuffer:valueBuffer
	    sizeInfo:sizeInfo.
    ^ retVal
!

sqlBindParameter:colNr type:paramType cType:cType sqlType:sqlType columnSize:columnSize scale:scale valueBuffer:valueBuffer sizeInfo:sizeInfo
    "Returns: ODBC return code"

    |sqlTypeNr cTypeNr retVal|

    sqlType isInteger ifTrue:[
	sqlTypeNr := sqlType.
    ] ifFalse:[
	sqlTypeNr := self class sqlTypeNumberFromSqlTypeSymbol:sqlType.
    ].
    cType isInteger ifTrue:[
	cTypeNr := cType.
    ] ifFalse:[
	cTypeNr := self class cTypeNumberFromCTypeSymbol:cType.
    ].
    DebugFlag == true ifTrue:[
	'BindValue: ' infoPrint.
	valueBuffer asByteArray infoPrint.
	((sqlType == #'SQL_NUMERIC') and:[ cType == #'SQL_C_CHAR' ]) ifTrue:[
	    ' ' infoPrint.
	    (valueBuffer asString copyTo:columnSize) infoPrint.
	].
	'' infoPrintCR.
    ].
    retVal := self
	    prim_sqlBindParameter:colNr
	    type:paramType
	    cTypeNr:cTypeNr
	    sqlTypeNr:sqlTypeNr
	    columnSize:columnSize
	    scale:scale
	    valueBuffer:valueBuffer
	    sizeInfo:sizeInfo.
    ^ retVal
!

sqlCloseCursor
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;

    if (hstmt == 0) {
	/* handle is uninitialized or invalidated - nothing to be done */
	RETURN(@global(SQL_SUCCESS));
    }

    rc = SQLCloseCursor (hstmt);
    TRACE ((stderr, "SQLCloseCursor(hstmt=%"_lx_") rc=%d(%s)\n", (INT)hstmt, (int)rc, __returnCodeString(rc)));
    RETURN (__odbcReturnCode(rc));
%}
!

sqlColumnsInCatalog:catalogOrPattern schema:schemaOrPattern table:tablePattern column:columnPattern
   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    SQLCHAR *__catalogOrPattern;
    SQLCHAR *__schemaOrPattern;
    SQLCHAR *__tablePattern;
    SQLCHAR *__columnPattern;
    SQLSMALLINT __catalogOrPatternL;
    SQLSMALLINT __schemaOrPatternL;
    SQLSMALLINT __tablePatternL;
    SQLSMALLINT __columnPatternL;

    if (hstmt == 0) {
	RETURN(@global(AttributeError));
    badArg: ;
	RETURN (@global(ArgumentError));
    }
    STRING_NULL_ARG(catalogOrPattern, __catalogOrPattern, __catalogOrPatternL);
    STRING_NULL_ARG(schemaOrPattern, __schemaOrPattern, __schemaOrPatternL);
    STRING_NULL_ARG(tablePattern, __tablePattern, __tablePatternL);
    STRING_NULL_ARG(columnPattern, __columnPattern, __columnPatternL);

    rc = SQLColumns ( hstmt,
			__catalogOrPattern, __catalogOrPatternL,
			__schemaOrPattern, __schemaOrPatternL,
			__tablePattern, __tablePatternL,
			__columnPattern, __columnPatternL);

    TRACE ((stderr, "SQLColumns(\"%s\",\"%s\",\"%s\",\"%s\") rc=%d\n",
		    __catalogOrPattern, __schemaOrPattern, __tablePattern, __columnPattern, (int)rc));
    RETURN (__odbcReturnCode(rc));
%}.
!

sqlDescribeCol:colNr
    |retVal valueHolder descr name sqlTypeNr columnSize scale nullable|

    valueHolder := Array new:5.
    retVal := self prim_sqlDescribeCol:colNr into:valueHolder.
    "this is a noo-op if ret is success"
    retVal performErrorHandlingFor:self statement:self.

    name := valueHolder at:1.
    columnSize := valueHolder at:2.
    scale := valueHolder at:3.
    nullable := valueHolder at:4.
    sqlTypeNr := valueHolder at:5.

    descr := SQL::ODBCColumnDescription new.
    descr
	columnNumber:colNr
	name:name
	type:nil
	columnSize:columnSize
	scale:scale
	nullable:nullable;
	sqlTypeNr:sqlTypeNr.
    ^ descr
!

sqlDescribeParam:paramNr
    |retVal valueHolder descr sqlTypeNr columnSize scale nullable|

    valueHolder := Array new:4.
    retVal := self prim_sqlDescribeParam:paramNr into:valueHolder.
    "this is a noo-op if ret is success"
    retVal performErrorHandlingFor:self statement:self.

    columnSize := valueHolder at:1.
    scale := valueHolder at:2.
    nullable := valueHolder at:3.
    sqlTypeNr := valueHolder at:4.

    descr := SQL::ODBCColumnDescription new.
    descr
	columnNumber:paramNr
	name:nil
	type:nil
	columnSize:columnSize
	scale:scale
	nullable:nullable;
	sqlTypeNr:sqlTypeNr.
    ^ descr
!

sqlExecute
   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }
#ifdef THREADED_CALLS
    if (@global(Unthreaded) != true) {
	do {
	    __threadErrno = 0;
	    rc = (SQLRETURN)__STX_API_NOINT_CALL1("SQLExecute", SQLExecute, hstmt);
	} while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
    } else
#endif
    {
	rc = SQLExecute(hstmt);
    }

    TRACE ((stderr, "SQLExecute rc=%d(%s)\n", (int)rc, __returnCodeString(rc)));
    RETURN (__odbcReturnCode(rc));
%}.
!

sqlExecuteDirect:sqlQuery
   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    int len;
    char *__sqlString;
    char sqlBuffer[256*16];
    char *sqlStringPtr;
    SQLWCHAR *__sqlStringW;
    SQLWCHAR sqlBufferW[256*16];
    SQLWCHAR *sqlStringPtrW;
    void *allocatedSaveBuffer = 0;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }
    if (__isStringLike(sqlQuery)) {
	__sqlString = __stringVal(sqlQuery);
	len = strlen(__sqlString);

	/* must keep the string in a save place */
	if (len < (sizeof(sqlBuffer)-1)) {
	    sqlStringPtr = sqlBuffer;
	} else {
	    sqlStringPtr = allocatedSaveBuffer = malloc(len + 1);
	}
	strncpy(sqlStringPtr, __sqlString, len);
#ifdef THREADED_CALLS
	if (@global(Unthreaded) != true) {
	    do {
		__threadErrno = 0;
		rc = (SQLRETURN)__STX_API_NOINT_CALL3("SQLExecDirect", (wrapFunction_t)SQLExecDirect, hstmt, sqlStringPtr, (void *)((INT)len));
	    } while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
	} else
#endif
	{
	    rc = SQLExecDirect(hstmt, sqlStringPtr, len);
	}
	TRACE ((stderr, "SQLExecDirect(\"%20s\") rc=%d(%s)\n", sqlStringPtr, (int)rc, __returnCodeString(rc)));
    } else if (__isUnicode16String(sqlQuery)) {
	__sqlStringW = (SQLWCHAR *)__unicode16StringVal(sqlQuery); \
	len = __unicode16StringSize(sqlQuery); \

	/* must keep the string in a save place */
	if (len < (sizeof(sqlBufferW)/sizeof(SQLWCHAR) - 1)) {
	    sqlStringPtrW = sqlBufferW;
	} else {
	    sqlStringPtrW = allocatedSaveBuffer = malloc((len+1)*sizeof(SQLWCHAR));
	}
	memcpy(sqlStringPtrW, __sqlStringW, len*sizeof(SQLWCHAR));
	sqlStringPtrW[len] = 0;
#ifdef THREADED_CALLS
	if (@global(Unthreaded) != true) {
	    do {
		__threadErrno = 0;
		rc = (SQLRETURN)__STX_API_NOINT_CALL3("SQLExecDirectW", SQLExecDirectW, hstmt, sqlStringPtrW, (void *)((INT)len));
	    } while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
	} else
#endif
	{
	    rc = SQLExecDirectW(hstmt, sqlStringPtrW, len);
	}
	TRACE ((stderr, "SQLExecDirect(\"%20ls\") rc=%d(%s)\n", sqlStringPtrW, (int)rc, __returnCodeString(rc)));
    } else {
	RETURN (@global(ArgumentError));
    }

    if (allocatedSaveBuffer) {
	free(allocatedSaveBuffer);
    }
    RETURN (__odbcReturnCode(rc));
%}.
!

sqlFetch
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }
#ifdef THREADED_CALLS
    if (@global(Unthreaded) != true) {
	do {
	    __threadErrno = 0;
	    rc = (SQLRETURN)__STX_API_NOINT_CALL1("SQLFetch", SQLFetch, hstmt);
	} while (/*(rc == SQL_ERROR) && */(__threadErrno == EINTR));
    } else
#endif
	rc = SQLFetch(hstmt);
    TRACE ((stderr, "SQLFetch rc=%d(%s)\n", (int)rc, __returnCodeString(rc) ));

    RETURN (__odbcReturnCode(rc));
%}.
!

sqlGetData:colNr sqlTypeNr:sqlTypeNr buffer:bufferOrNil preferWideChar:preferWideChar into:valueHolder

%{  /* UNLIMITEDSTACK(UNIXODBC) */

    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    OBJ retVal = nil, value = nil, valueSize = nil, hasMoreData = false;
    OBJ day = nil, month = nil, year = nil;
    OBJ hour = nil, minute = nil, second = nil, nanosecond = nil;
    int __sqlType, __cType, __colNr, __offset;
    SQLRETURN rc;
    SQLLEN __bufferSize, __valueSize = 0;
#if defined(INT64) || (__POINTER_SIZE__ == 8)
    INT64 __longLongVal;
# define HI32(l)    (((l) >> 32) & 0xFFFFFFFFL)
# define LO32(l)    ((l) & 0xFFFFFFFFL)
#else
# ifdef __LSBFIRST
    struct {
	INT low32, high32;
    } __longLongVal;
# else
    struct {
	INT high32, low32;
    } __longLongVal;
# endif
# define HI32(l)    ((l).high32)
# define LO32(l)    ((l).low32)
#endif
    long __longVal;
    short __shortVal;
    unsigned char __byteVal;
    float __floatVal;
    double __doubleVal;
    unsigned char *__valuePtr;
    int __binary = 0, __wideChar = 0;
#  define QUICKBUFFER_SIZE 4096
    unsigned char __quickBuffer[QUICKBUFFER_SIZE+4];
#  define NIL_DATE_YR  0000
    struct {
	short yr, mn, dy;
    } __dateVal;
#  define NIL_TIME_HR  99
    struct {
	short h, m, s;
    } __timeVal;
    struct {
	short yr, mn, dy;
	short h, m, s;
	unsigned int ns;
    } __timestampVal;
    struct {
	char b[16];
    } __guidVal;

    if (hstmt == 0) {
	retVal = @global(AttributeError);
	goto getOutOfHere;
    }

    if (! __bothSmallInteger(colNr, sqlTypeNr)) {
	retVal = @global(AttributeError);
	goto getOutOfHere;
    }
    __colNr = __intVal(colNr);
    __sqlType = __intVal(sqlTypeNr);

    switch (__sqlType) {
	case SQL_BIGINT:
#ifdef SQL_C_SBIGINT
	    __cType = SQL_C_SBIGINT;
	    __valuePtr = (void *)&__longLongVal;
	    __bufferSize = sizeof(__longLongVal);
#else
	    __bufferSize = QUICKBUFFER_SIZE;
	    goto useString;
#endif
	    break;

	case SQL_NUMERIC:
	case SQL_DECIMAL:
	    __bufferSize = QUICKBUFFER_SIZE;
	    goto useString;

	case SQL_INTEGER:
	    __cType = SQL_C_LONG;
	    __valuePtr = (void *)&__longVal;
	    __bufferSize = sizeof(__longVal);
	    break;

	case SQL_SMALLINT:
	case SQL_TINYINT:
	    __cType = SQL_C_SHORT;
	    __valuePtr = (void *)&__shortVal;
	    __bufferSize = sizeof(__shortVal);
	    break;

	case SQL_BIT:
	    __cType = SQL_C_BIT;
	    __valuePtr = (void *)&__byteVal;
	    __bufferSize = sizeof(__byteVal);
	    break;

	case SQL_FLOAT:
	    __cType = SQL_C_FLOAT;
	    __valuePtr = (void *)&__floatVal;
	    __bufferSize = sizeof(__floatVal);
	    break;

	case SQL_REAL:
	case SQL_DOUBLE:
	    __cType = SQL_C_DOUBLE;
	    __valuePtr = (void *)&__doubleVal;
	    __bufferSize = sizeof(__doubleVal);
	    break;

#ifdef SQL_WCHAR
	case SQL_WCHAR:
#endif
#ifdef SQL_VARWCHAR
	case SQL_VARWCHAR:
#endif
#ifdef SQL_WVARCHAR
	case SQL_WVARCHAR:
#endif
#ifdef SQL_LONGVARWCHAR
	case SQL_LONGVARWCHAR:
#endif
#ifdef SQL_WLONGVARCHAR
	case SQL_WLONGVARCHAR:
#endif
#ifdef SQL_C_WCHAR
	    __wideChar = 1;
#endif
	    goto stringOrWideString;

	case SQL_BINARY:
	case SQL_VARBINARY:
	case SQL_LONGVARBINARY:
	    __binary = 1;
	    /* fall into */
	case SQL_CHAR:
	case SQL_VARCHAR:
	case SQL_LONGVARCHAR:
	    /* fall into */

	stringOrWideString:
	    if (preferWideChar == true)
		__wideChar = 1;
	    if (bufferOrNil == nil) {
		__bufferSize = QUICKBUFFER_SIZE;
	    } else if (__isString(bufferOrNil) || __isByteArray(bufferOrNil) || __isUnicode16String(bufferOrNil)) {
		__bufferSize = __byteArraySize(bufferOrNil);
		__valuePtr = __byteArrayVal(bufferOrNil);
		TRACE((stderr, "set bufferSize for explicit buffer length: %d\n", (int)__bufferSize));
	    } else {
		retVal = @global(ArgumentError);
		goto getOutOfHere;
	    }

	useString:
	    if (__binary) {
		__cType = SQL_C_BINARY;
#ifdef SQL_C_WCHAR
	    } else if (__wideChar) {
		__cType = SQL_C_WCHAR;
#endif
	    } else {
		__cType = SQL_C_CHAR;
	    }

	    if (bufferOrNil == nil) {
		__valuePtr = __quickBuffer;
	    }
	    break;

	case SQL_DATE:
#ifdef SQL_TYPE_DATE
	case SQL_TYPE_DATE:
#endif
	    __cType = SQL_C_DATE;
	    __dateVal.yr = NIL_DATE_YR;
	    __valuePtr = (void *)&__dateVal;
	    __bufferSize = sizeof(__dateVal);
	    break;

	case SQL_TIME:
	case SQL_TYPE_TIME:
	    __cType = SQL_C_TIME;
	    __timeVal.h = NIL_TIME_HR;
	    __valuePtr = (void *)&__timeVal;
	    __bufferSize = sizeof(__timeVal);
	    break;

	case SQL_TIMESTAMP:
#ifdef SQL_TYPE_TIMESTAMP
	case SQL_TYPE_TIMESTAMP:
#endif
	    __cType = SQL_C_TIMESTAMP;
	    __timestampVal.yr = NIL_DATE_YR;
	    __timestampVal.h = NIL_TIME_HR;
	    __valuePtr = (void *)&__timestampVal;
	    __bufferSize = sizeof(__timestampVal);
	    break;

#if defined(SQL_DATETIME) && (SQL_DATETIME != SQL_TIMESTAMP && (SQL_DATETIME != SQL_DATE))
	case SQL_DATETIME:
	    __cType = SQL_C_DATETIME;
	    __valuePtr = (void *)&__datetimeVal;
	    __bufferSize = sizeof(__datetimeVal);
	    break;
#endif

	case SQL_GUID:
	    __cType = SQL_C_GUID;
	    __valuePtr = (void *)&__guidVal;
	    __bufferSize = sizeof(__guidVal);
	    break;

	default:
	    TRACE((stderr, "ODBC [error]: unhandled sql-Type:%d(%s)\n", __sqlType, __sqlTypeString(__sqlType)));
	    retVal = @global(InvalidType);
	    goto getOutOfHere;
    }

    // THREADED_CALLS are not needed - GetData does not block
    rc = SQLGetData(hstmt, __colNr, __cType, __valuePtr, __bufferSize, &__valueSize);

    TRACE ((stderr, "SQLGetData(%d, sqlType=%d(%s), cType=%d(%s), bufferSize=%d ) rc=%d, valueSize=%d\n",
	    __colNr,
	    __sqlType, __sqlTypeString(__sqlType),
	    __cType, __cTypeString(__cType),
	    (int)__bufferSize, (int)rc, (int)__valueSize));

    retVal =__odbcReturnCode(rc);
    if ((rc == SQL_SUCCESS) || (rc == SQL_SUCCESS_WITH_INFO)) {
	if (__valueSize == 0 || __valueSize == SQL_NULL_DATA) {
	    // NULL value
	    valueSize = __MKSMALLINT(0);
	    value = nil;
	    goto getOutOfHere;
	} else if (__valueSize == SQL_NO_TOTAL) {
	    valueSize = __MKSMALLINT(-1);
	} else {
	    valueSize = __MKSMALLINT(__valueSize);
	}

	switch (__cType) {
#ifdef SQL_C_SBIGINT
	    case SQL_C_SBIGINT:
# if __POINTER_SIZE__ == 8
		TRACE ((stderr, "SQLGetData SQL_C_SBIGINT -> %"_lx_"\n",
			(INT)__longLongVal));
		value = __MKINT( __longLongVal );
		break;
# else
		TRACE ((stderr, "SQLGetData SQL_C_SBIGINT -> %"_lx_"%"_lx_"\n",
			(INT)HI32(__longLongVal), (INT)LO32(__longLongVal)));
		if (HI32(__longLongVal) == 0) {
		    value = __MKUINT( LO32(__longLongVal) );
		} else {
		    value = __MKINT64(&__longLongVal);
		}
		break;
# endif
#endif
	    case SQL_C_LONG:
		TRACE ((stderr, "SQLGetData SQL_C_LONG -> %ld\n", __longVal));
		value = __MKINT(__longVal);
		break;

	    case SQL_C_SHORT:
		TRACE ((stderr, "SQLGetData SQL_C_SHORT -> %d\n", __shortVal));
		value = __MKSMALLINT(__shortVal);
		break;

	    case SQL_C_BIT:
		TRACE ((stderr, "SQLGetData SQL_C_BIT -> %d\n", __byteVal));
		value = __MKSMALLINT(__byteVal);
		break;

	    case SQL_C_FLOAT:
		TRACE ((stderr, "SQLGetData SQL_C_FLOAT -> %f\n", __floatVal));
		value = __MKSFLOAT(__floatVal);
		break;

	    case SQL_C_DOUBLE:
		TRACE ((stderr, "SQLGetData SQL_C_DOUBLE -> %lf\n", __doubleVal));
		value = __MKFLOAT(__doubleVal);
		break;

	    case SQL_C_BINARY:
		TRACE ((stderr, "SQLGetData SQL_C_BINARY -> %02x %02x %02x %02x (%d)...\n",
			__valuePtr[0], __valuePtr[1], __valuePtr[2], __valuePtr[3],
			(int)__valueSize));
		__binary = 1;
		__wideChar = 0;
		goto SQL_C_BINARY_or_SQL_C_CHAR;

#ifdef SQL_C_WCHAR
	    case SQL_C_WCHAR:
		TRACE ((stderr, "SQLGetData SQL_C_WCHAR -> %04x %04x %04x %04x (%d)...\n",
			((unsigned short *)__valuePtr)[0], ((unsigned short *)__valuePtr)[1],
			((unsigned short *)__valuePtr)[2], ((unsigned short *)__valuePtr)[3],
			(int)__valueSize));
		__binary = 0;
		__wideChar = 1;
		goto SQL_C_BINARY_or_SQL_C_CHAR;
#endif
	    case SQL_C_CHAR:
		TRACE ((stderr, "SQLGetData SQL_C_CHAR -> \"%s\"(%d)\n", __valuePtr, (int)__valueSize));
		__binary = 0;
		__wideChar = 0;
		/* fall into */

SQL_C_BINARY_or_SQL_C_CHAR:
		if (bufferOrNil != nil) {
		    // got data into explicit buffer - we are done
		    if (__valueSize == SQL_NO_TOTAL || __valueSize > __bufferSize) {
			hasMoreData = true;
			__valueSize = __bufferSize;
		    }
		    break;
		}

		if (__valueSize == SQL_NO_TOTAL) {
		    // dont know the total amount of data
		    __valueSize = __bufferSize;
		    hasMoreData = true;
		}

		if (__binary) {
		    value = __BYTEARRAY_NEW_INT(__valueSize);
		} else if (__wideChar) {
		    value = __MKEMPTYU16STRING(__valueSize/2);
		} else {
		    value = __STRING_NEW_INT(__valueSize);
		}
		memcpy(__byteArrayVal(value), __valuePtr, (__valueSize < __bufferSize ? __valueSize : __bufferSize));

		if (__valueSize > __bufferSize) {
		    /*
		     * assemble parts as returned by multiple SQLGetData calls
		     * until SQL_NO_DATA is returned.
		     */
		    TRACE ((stderr, "*****  SQLGetData  __valueSize(%d) > __bufferSize(%d) ****\n", (int)__valueSize, (int)__bufferSize));
		    if (__binary) {
			__offset = __bufferSize;
			__bufferSize = __valueSize - __offset;
		    } else if (__wideChar) {
			__offset = __bufferSize - 2;                // overwrite 00-bytes at end
			__bufferSize = __valueSize - __offset;      // there is no space for 00-bytes in Unicode16String
		    } else {
			__offset = __bufferSize - 1;                // overwrite 0-byte at end
			__bufferSize = __valueSize - __bufferSize;  // there is space for a 0-byte in String
		    }

		    rc = SQLGetData(hstmt, __colNr, __cType, __byteArrayVal(value) + __offset, __bufferSize, &__valueSize);
		    TRACE ((stderr, "SQLGetData(%d, sqlType=%d(%s), cType=%d(%s), bufferSize=%d ) rc=%d, valueSize=%d offset=%d\n",
			    __colNr,
			    __sqlType, __sqlTypeString(__sqlType),
			    __cType, __cTypeString(__cType),
			    (int)__bufferSize, (int)rc, (int)__valueSize, __offset));

		    if (__wideChar && rc == SQL_SUCCESS_WITH_INFO) {
			// there are one real character and a 00-character left
			short buffer[2];

			rc = SQLGetData(hstmt, __colNr, __cType, buffer, sizeof(buffer), &__valueSize);
			__unicode16StringVal(value)[__unicode16StringSize(value)-1] = buffer[0];
		    }
		    if (rc != SQL_NO_DATA) {
			retVal = __odbcReturnCode(rc);
			goto getOutOfHere;
		    }
		}
		break;

	    case SQL_C_DATE:
		TRACE ((stderr, "SQLGetData SQL_C_DATE -> %d.%d.%d\n", __dateVal.yr, __dateVal.mn, __dateVal.dy));
		if (__dateVal.yr == NIL_DATE_YR) {
		    day = nil;
		} else {
		    value = year = __MKSMALLINT(__dateVal.yr);
		    month = __MKSMALLINT(__dateVal.mn);
		    day = __MKSMALLINT(__dateVal.dy);
		}
		break;

	    case SQL_C_TIME:
		TRACE ((stderr, "SQLGetData SQL_C_TIME -> %d:%d:%d\n", __timeVal.h, __timeVal.m, __timeVal.s));
		if (__timeVal.h == NIL_TIME_HR) {
		    hour = nil;
		} else {
		    value = hour = __MKSMALLINT(__timeVal.h);
		    minute = __MKSMALLINT(__timeVal.m);
		    second = __MKSMALLINT(__timeVal.s);
		}
		break;

	    case SQL_C_TIMESTAMP:
		TRACE ((stderr, "SQLGetData SQL_C_TIMESTAMP -> %d.%d.%d %d:%d:%d.%d\n",
			__timestampVal.yr, __timestampVal.mn, __timestampVal.dy,
			__timestampVal.h, __timestampVal.m, __timestampVal.s,
			__timestampVal.ns));
		if (__timestampVal.yr == NIL_DATE_YR) {
		    day = nil;
		} else {
		    value = year = __MKSMALLINT(__timestampVal.yr);
		    month = __MKSMALLINT(__timestampVal.mn);
		    day = __MKSMALLINT(__timestampVal.dy);
		    hour = __MKSMALLINT(__timestampVal.h);
		    minute = __MKSMALLINT(__timestampVal.m);
		    second = __MKSMALLINT(__timestampVal.s);
		    nanosecond = __MKSMALLINT(__timestampVal.ns);
		}
		break;

	    case SQL_C_GUID:
		TRACE ((stderr, "SQLGetData SQL_C_GUID -> %02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\n",
		    __guidVal.b[0], __guidVal.b[1], __guidVal.b[2], __guidVal.b[3],
		    __guidVal.b[4], __guidVal.b[5], __guidVal.b[6], __guidVal.b[7],
		    __guidVal.b[8], __guidVal.b[9], __guidVal.b[10], __guidVal.b[11],
		    __guidVal.b[12], __guidVal.b[13], __guidVal.b[14], __guidVal.b[15]));
		value = __MKBYTEARRAY(__guidVal.b, 16);
		break;

	    default:
		TRACE((stderr, "ODBC [error]: unhandled c-Type:%d(%s)\n", __cType, __cTypeString(__cType)));
		retVal = @global(InvalidType);
		goto getOutOfHere;
	}
    } else {
	retVal = __odbcReturnCode(rc);
    }

getOutOfHere: ;
    if (__arraySize(valueHolder) < 11) {
	fprintf(stderr, "valueHolder too small\n");
	RETURN (nil);
    }
    __ArrayInstPtr(valueHolder)->a_element[0] = value;        __STORE(valueHolder, value);
    __ArrayInstPtr(valueHolder)->a_element[1] = valueSize;    __STORE(valueHolder, valueSize);
    __ArrayInstPtr(valueHolder)->a_element[2] = __cTypeSymbol(__cType);
    __ArrayInstPtr(valueHolder)->a_element[3] = day;
    __ArrayInstPtr(valueHolder)->a_element[4] = month;
    __ArrayInstPtr(valueHolder)->a_element[5] = year;
    __ArrayInstPtr(valueHolder)->a_element[6] = hour;
    __ArrayInstPtr(valueHolder)->a_element[7] = minute;
    __ArrayInstPtr(valueHolder)->a_element[8] = second;
    __ArrayInstPtr(valueHolder)->a_element[9] = nanosecond;
    __ArrayInstPtr(valueHolder)->a_element[10] = hasMoreData;
    RETURN (retVal);
%}
!

sqlNumParams
    |retVal valueHolder|

    valueHolder := Array new:1.
    retVal := self prim_sqlNumParamsInto:valueHolder.

    ^ valueHolder at:1. "this is nil if retVal is not success"
!

sqlNumResultCols
    |retVal valueHolder|

    valueHolder := Array new:1.
    retVal := self prim_sqlNumResultColsInto:valueHolder.

    ^ valueHolder at:1. "this is nil if retVal is not success"
!

sqlPrepare:sqlString
    "prepare the SQL statement"

   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    int len;

    if (hstmt == 0) {
	RETURN(@global(AttributeError));
    }
    if (__isStringLike(sqlString)) {
	char *__sqlString = __stringVal(sqlString);
	len = strlen(__sqlString);

	rc = SQLPrepare (hstmt, __sqlString, len);
	TRACE ((stderr, "SQLPrepare(\"%20s\") rc=%d\n", __sqlString, (int)rc));
    } else if (__isUnicode16String(sqlString)) {
	SQLWCHAR *__sqlString = (SQLWCHAR *)__unicode16StringVal(sqlString); \
	len = __unicode16StringSize(sqlString); \

	rc = SQLPrepareW (hstmt, __sqlString, len);
	TRACE ((stderr, "SQLPrepareW(\"%20ls\") rc=%d\n", __sqlString, (int)rc));
    } else {
	RETURN (@global(ArgumentError));
    }
    RETURN (__odbcReturnCode(rc));
%}.
!

sqlPrimaryKeysInCatalog:catalogOrPattern schema:schemaOrPattern table:tablePattern
   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    SQLCHAR *__catalogOrPattern;
    SQLCHAR *__schemaOrPattern;
    SQLCHAR *__tablePattern;
    SQLSMALLINT __catalogOrPatternSize;
    SQLSMALLINT __schemaOrPatternSize;
    SQLSMALLINT __tablePatternSize;

    if (hstmt == 0) {
	RETURN(@global(AttributeError));
    badArg: ;
	RETURN (@global(ArgumentError));
    }
    STRING_NULL_ARG(catalogOrPattern, __catalogOrPattern, __catalogOrPatternSize);
    STRING_NULL_ARG(schemaOrPattern, __schemaOrPattern, __schemaOrPatternSize);
    STRING_NULL_ARG(tablePattern, __tablePattern, __tablePatternSize);

    rc = SQLPrimaryKeys ( hstmt,
			__catalogOrPattern, __catalogOrPatternSize,
			__schemaOrPattern, __schemaOrPatternSize,
			__tablePattern, __tablePatternSize);

    TRACE ((stderr, "SQLPrimaryKeys(\"%s\",\"%s\",\"%s\") rc=%d\n",
		    __catalogOrPattern, __schemaOrPattern, __tablePattern, (int)rc));
    RETURN (__odbcReturnCode(rc));
%}.
!

sqlSetStatementOption:option value:paramValue
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT hstmt = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;
    SQLINTEGER __option;
    INT __paramValue;

    if (hstmt == 0) {
	RETURN (@global(AttributeError));
    }

    if (option == @symbol(SQL_ASYNC_ENABLE)) {
	__option = SQL_ASYNC_ENABLE;
    } else if (option == @symbol(SQL_BIND_TYPE)) {
	__option = SQL_BIND_TYPE;
    } else if (option == @symbol(SQL_CONCURRENCY)) {
	__option = SQL_CONCURRENCY;
    } else if (option == @symbol(SQL_CURSOR_TYPE)) {
	__option = SQL_CURSOR_TYPE;
    } else if (option == @symbol(SQL_KEYSET_SIZE)) {
	__option = SQL_KEYSET_SIZE;
    } else if (option == @symbol(SQL_ATTR_MAX_LENGTH)) {
	__option = SQL_ATTR_MAX_LENGTH;
    } else if (option == @symbol(SQL_MAX_LENGTH)) {     // same as SQL_ATTR_MAX_LENGTH
	__option = SQL_MAX_LENGTH;
    } else if (option == @symbol(SQL_MAX_ROWS)) {
	__option = SQL_MAX_ROWS;
    } else if (option == @symbol(SQL_NOSCAN)) {
	__option = SQL_NOSCAN;
    } else if (option == @symbol(SQL_QUERY_TIMEOUT)) {
	__option = SQL_QUERY_TIMEOUT;
    } else if (option == @symbol(SQL_RETRIEVE_DATA)) {
	__option = SQL_RETRIEVE_DATA;
    } else if (option == @symbol(SQL_ROWSET_SIZE)) {
	__option = SQL_ROWSET_SIZE;
    } else if (option == @symbol(SQL_SIMULATE_CURSOR)) {
	__option = SQL_SIMULATE_CURSOR;
    } else if (option == @symbol(SQL_USE_BOOKMARKS)) {
	__option = SQL_USE_BOOKMARKS;
#ifdef SQL_ATTR_PARAMSET_SIZE
    } else if (option == @symbol(SQL_ATTR_PARAMSET_SIZE)) {
	__option = SQL_ATTR_PARAMSET_SIZE;
#endif
#ifdef SQL_ATTR_ROW_ARRAY_SIZE
    } else if (option == @symbol(SQL_ATTR_ROW_ARRAY_SIZE)) {
	__option = SQL_ATTR_ROW_ARRAY_SIZE;
#endif

#ifdef SQL_ATTR_USE_BOOKMARKS
    } else if (option == @symbol(SQL_ATTR_USE_BOOKMARKS)) {
	__option = SQL_ATTR_USE_BOOKMARKS;
/* hack*/
	__paramValue = SQL_UB_VARIABLE;
#endif


    } else {
	RETURN (@global(ArgumentError));
    }

    switch (__option) {
	case SQL_ASYNC_ENABLE:
	    if ((paramValue == @symbol(SQL_ASYNC_ENABLE_ON))
	     || (paramValue == true)) {
		__paramValue = SQL_ASYNC_ENABLE_ON;
	    } else {
		__paramValue = SQL_ASYNC_ENABLE_OFF;
	    }
	    break;

	case SQL_BIND_TYPE:
	    if (paramValue == @symbol(SQL_BIND_BY_COLUMN)) {
		__paramValue = SQL_BIND_BY_COLUMN;
	    } else if (__isSmallInteger(paramValue)) {
		__paramValue = __intVal(paramValue);
	    } else {
		RETURN (@global(ArgumentError));
	    }
	    break;

	case SQL_CONCURRENCY:
	    if (paramValue == @symbol(SQL_CONCUR_LOCK)) {
		__paramValue = SQL_CONCUR_LOCK;
	    } else if (paramValue == @symbol(SQL_CONCUR_ROWVER)) {
		__paramValue = SQL_CONCUR_ROWVER;
	    } else if (paramValue == @symbol(SQL_CONCUR_VALUES)) {
		__paramValue = SQL_CONCUR_VALUES;
	    } else {
		__paramValue = SQL_CONCUR_READ_ONLY;
	    }
	    break;

	case SQL_CURSOR_TYPE:
	    if (paramValue == @symbol(SQL_CURSOR_STATIC)) {
		__paramValue = SQL_CURSOR_STATIC;
	    } else if (paramValue == @symbol(SQL_CURSOR_KEYSET_DRIVEN)) {
		__paramValue = SQL_CURSOR_KEYSET_DRIVEN;
	    } else if (paramValue == @symbol(SQL_CURSOR_DYNAMIC)) {
		__paramValue = SQL_CURSOR_DYNAMIC;
	    } else {
		__paramValue = SQL_CURSOR_FORWARD_ONLY;
	    }
	    break;

	case SQL_KEYSET_SIZE:
	case SQL_MAX_ROWS:
	case SQL_QUERY_TIMEOUT:
	case SQL_ROWSET_SIZE:
	case SQL_ATTR_MAX_LENGTH:
#ifdef SQL_ATTR_PARAMSET_SIZE
	case SQL_ATTR_PARAMSET_SIZE:
#endif
#ifdef SQL_ATTR_ROW_ARRAY_SIZE
	case SQL_ATTR_ROW_ARRAY_SIZE:
#endif
	    if (__isSmallInteger(paramValue)) {
		__paramValue = __intVal(paramValue);
	    } else {
		RETURN (@global(ArgumentError));
	    }
	    break;

	case SQL_NOSCAN:
	    if ((paramValue == @symbol(SQL_NOSCAN_ON))
	     || (paramValue == true)) {
		__paramValue = SQL_NOSCAN_ON;
	    } else {
		__paramValue = SQL_NOSCAN_OFF;
	    }
	    break;

	case SQL_RETRIEVE_DATA:
	    if ((paramValue == @symbol(SQL_RD_ON))
	     || (paramValue == true)) {
		__paramValue = SQL_RD_ON;
	    } else {
		__paramValue = SQL_RD_OFF;
	    }
	    break;

	case SQL_SIMULATE_CURSOR:
	    if (paramValue == @symbol(SQL_SC_NON_UNIQUE)) {
		__paramValue = SQL_SC_NON_UNIQUE;
	    } else if (paramValue == @symbol(SQL_SC_TRY_UNIQUE)) {
		__paramValue = SQL_SC_TRY_UNIQUE;
	    } else {
		__paramValue = SQL_SC_UNIQUE;
	    }
	    break;

	case SQL_USE_BOOKMARKS:
	    if ((paramValue == @symbol(SQL_UB_ON))
	     || (paramValue == true)) {
		__paramValue = SQL_UB_ON;
	    } else {
		__paramValue = SQL_UB_OFF;
	    }
	    break;

	default:
	    RETURN (@global(ArgumentError));
    }
#if defined(USE_ODBC_V3)
    rc = SQLSetStmtAttr(hstmt, __option, (SQLPOINTER)__paramValue, 0);
#else
    switch (__option) {
	default:
	    rc = SQLSetStmtOption (hstmt, __option, __paramValue );
	    break;

#ifdef SQL_ATTR_PARAMSET_SIZE
	case SQL_ATTR_PARAMSET_SIZE:
#endif
	    rc = SQLParamOptions (hstmt, __paramValue, NULL /* &RowCount */);
	    break;

    }
#endif
    TRACE ((stderr, "SQLSetStmtAttr(%d,%d) rc=%d(%s)\n", (int)__option, (int)__paramValue, (int)rc, __returnCodeString(rc)));
    RETURN ( __odbcReturnCode(rc));
%}.
!

sqlTablesInCatalog:catalogOrPattern schema:schemaOrPattern table:tablePattern type:typePattern
   "
    Returns: ODBC return code
   "
%{  /* UNLIMITEDSTACK(UNIXODBC) */
    HSTMT  hstmt  = (HSTMT) __externalAddressVal(self);
    SQLRETURN rc;

    SQLSMALLINT __catalogOrPatternSize = 0;
    SQLSMALLINT __schemaOrPatternSize = 0;
    SQLSMALLINT __tablePatternSize = 0;
    SQLSMALLINT __typePatternSize = 0;

    SQLCHAR *__catalogOrPattern = "";
    SQLCHAR *__schemaOrPattern = "";
    SQLCHAR *__tablePattern = "";
    SQLCHAR *__typePattern = "";

    if (hstmt == 0) {
	RETURN(@global(AttributeError));
    badArg: ;
	RETURN (@global(ArgumentError));
    }

    if (catalogOrPattern != nil) {
	STRING_ARG(catalogOrPattern, __catalogOrPattern, __catalogOrPatternSize);
    }
    if (schemaOrPattern != nil) {
	STRING_ARG(schemaOrPattern, __schemaOrPattern, __schemaOrPatternSize);
    }
    if (tablePattern != nil) {
	STRING_ARG(tablePattern, __tablePattern, __tablePatternSize);
    }
    if (typePattern != nil) {
	STRING_ARG(typePattern, __typePattern, __typePatternSize);
    }

    rc = SQLTables ( hstmt,
			__catalogOrPattern, __catalogOrPatternSize,
			__schemaOrPattern, __schemaOrPatternSize,
			__tablePattern, __tablePatternSize,
			__typePattern,__typePatternSize);


    TRACE ((stderr, "SQLTables(\"%s\",\"%s\",\"%s\",\"%s\") rc=%d\n",
		    __catalogOrPattern, __schemaOrPattern, __tablePattern, __typePattern, (int)rc));
    RETURN (__odbcReturnCode(rc));
%}.
! !

!ODBCHandle::ODBCStatementHandle methodsFor:'accessing'!

databaseHandle:aHandle
    parentHandle := aHandle.
! !

!ODBCHandle::ODBCStatementHandle methodsFor:'error handling'!

getError
    ^ self sqlGetErrorForHenv:environmentHandle hdbc:parentHandle hstmt:self
! !

!ODBCHandle::ODBCStatementHandle methodsFor:'private helpers'!

buildStructFor:fieldInfo values:arrayOfRows
    |offset rowOffset fieldOffsets fieldSizes fieldCTypes
     storage requiredAlignmentOfFirstField maxAlignmentRequirement numBytesPerRow|

    "/ compute the overall size of the structure (in bytes)
    "/ collect fieldOffsets as side effect

    fieldOffsets := OrderedCollection new.
    fieldSizes := OrderedCollection new.
    fieldCTypes := OrderedCollection new.
    offset := 0.
    maxAlignmentRequirement := 8.
    fieldInfo do:[:eachFieldInfo |
	|requiredAlignment fieldSize fieldsCType|

	fieldsCType := SQL::ODBCHandle cTypeNumberFromCTypeSymbol:(eachFieldInfo at:1).

	requiredAlignment := self requiredAlignmentForField:eachFieldInfo.
	(offset \\ requiredAlignment) ~~ 0 ifTrue:[
	    offset := offset + (requiredAlignment-(offset \\ requiredAlignment)).
	].
	fieldSize := self requiredSizeForField:eachFieldInfo.
	(fieldsCType == 1) ifTrue:[
	    fieldSize := fieldSize + 1.
	].
	fieldSizes add:fieldSize.

	fieldOffsets add:offset.
	fieldCTypes add:fieldsCType.

	offset := offset + fieldSize.
	maxAlignmentRequirement := maxAlignmentRequirement max:requiredAlignment.
    ].

    requiredAlignmentOfFirstField := (self requiredAlignmentForField:fieldInfo first) max:maxAlignmentRequirement.
    (offset \\ requiredAlignmentOfFirstField) ~~ 0 ifTrue:[
	offset := offset + (requiredAlignmentOfFirstField-(offset \\ requiredAlignmentOfFirstField)).
    ].
    numBytesPerRow := offset.

    storage := ExternalBytes unprotectedNew:(numBytesPerRow * arrayOfRows size).
    storage atAllPut:0.

    "/ now, fill the values

    rowOffset := 0.
    arrayOfRows do:[:eachRow |
	1 to:fieldInfo size do:[:idx |
	    |value thisFieldsInfo fieldOffset|

	    value := eachRow at:idx.
	    thisFieldsInfo := fieldInfo at:idx.
	    fieldOffset := fieldOffsets at:idx.

	    self field:thisFieldsInfo in:storage at:(rowOffset+fieldOffset) put:value
	].
	rowOffset := rowOffset + numBytesPerRow.
    ].

    ^ (Array with:storage with:fieldOffsets with:fieldSizes with:fieldCTypes with:numBytesPerRow)

    "
     |rows|

     rows := {
		    { 'aaaa' asUnicode16String. 1000.0. 'AAA' }.
		    { 'bbbb' asUnicode16String. 2000.0. 'BBB' }.
		    { 'cccc' asUnicode16String. 3000.0. 'CCC' }.
		    { 'dddd' asUnicode16String. 4000.0. 'DDD' }.
		    { 'eeee' asUnicode16String. 5000.0. 'EEE' }.
		}.
     self basicNew
	buildStructFor:
		#(
			( SQL_C_WCHAR    12 )
			( SQL_C_DOUBLE  )
			( SQL_C_CHAR    5 )
		)
	values:rows
    "
!

bulkInsertInto:tableName columnNames:aColOfColumnNames values:aColOfValues bufferBindings:buffer

    |columnNameStringStream columnNameString selectStmt storageAndInfo storage fieldOffsets fieldSizes fieldCTypes numBytesPerRow|

    columnNameStringStream := '' writeStream.
    aColOfColumnNames
	do:[:aColumnName | columnNameStringStream nextPutAll:aColumnName ]
	separatedBy:[ columnNameStringStream nextPutAll:', ' ].

    columnNameString := columnNameStringStream contents.
    selectStmt := 'SELECT %1 FROM %2' bindWith:columnNameString with:tableName.

    storageAndInfo := self
       buildStructFor:(
	   buffer collect:[:aBuffer |
	       Array with:aBuffer sqlCType with:aBuffer sqlColSize
	   ]
       )
       values:aColOfValues.

    storage := storageAndInfo at:1.
    fieldOffsets := storageAndInfo at:2.
    fieldSizes := storageAndInfo at:3.
    fieldCTypes := storageAndInfo at:4.
    numBytesPerRow := storageAndInfo at:5.
    self
       bulkInsert:storage
       numRows:aColOfValues size
       rowStorageSize:numBytesPerRow
       types:fieldCTypes asArray
       sizes:fieldSizes asArray
       offsets:fieldOffsets asArray
       sqlSelect:selectStmt
!

field:aFieldInfo in:storage at:cOffset put:value
    |cTypeSymbol stIndex numBytes |

    stIndex := cOffset + 1.

    cTypeSymbol := aFieldInfo at:1.

    cTypeSymbol == #SQL_C_LONG ifTrue:[
	storage unsignedLongAt:stIndex put:value.
	^ self.
    ].

    cTypeSymbol == #SQL_C_CHAR ifTrue:[
	numBytes := (aFieldInfo at:2 ifAbsent:1) min:value size.
	storage replaceFrom:stIndex to:stIndex+numBytes-1 with:value startingAt:1.
	^ self.
    ].

    cTypeSymbol == #SQL_C_WCHAR ifTrue:[
	numBytes := ((aFieldInfo at:2 ifAbsent:1) * 2) min:value byteSize.
	storage replaceFrom:stIndex to:stIndex+numBytes-1 with:value startingAt:1.
	^ self.
    ].

    cTypeSymbol == #SQL_C_DOUBLE ifTrue:[
	storage doubleAt:stIndex put:value.
	^ self.
    ].

"/ ever needed?
"/    cTypeSymbol == #SQL_C_FLOAT ifTrue:[
"/        storage floatAt:stIndex put:value.
"/        ^ self.
"/    ].

    cTypeSymbol == #'SQL_C_TIMESTAMP' ifTrue:[
	|nanoseconds|
	storage shortAt:stIndex+0 put:(value year).
	storage unsignedShortAt:stIndex+2 put:(value month).
	storage unsignedShortAt:stIndex+4 put:(value day).
	storage unsignedShortAt:stIndex+6 put:(value hours).
	storage unsignedShortAt:stIndex+8 put:(value minutes).
	storage unsignedShortAt:stIndex+10 put:(value seconds).
	nanoseconds := value milliseconds * 1000 * 1000.
	storage unsignedLongAt:stIndex+12 put:nanoseconds.
	^ self
    ].



    self error:'unimplemented type' mayProceed:true.

    "
     self basicNew
	buildStructFor:
		#(
			( SQL_C_LONG    )
			( SQL_C_CHAR    5 )
			( SQL_C_LONG    )
			( SQL_C_CHAR    1 )
			( SQL_C_DOUBLE  )
		)
	values:#( 123 'hello' 987 '4' 5.678 )
    "
!

requiredAlignmentForField:aFieldInfo
    |cTypeSymbol|

    cTypeSymbol := aFieldInfo at:1.
    ^ SQL::ODBCHandle cSizeOf:cTypeSymbol
!

requiredSizeForField:aFieldInfo
    |cTypeSymbol numElement|

    cTypeSymbol := aFieldInfo at:1.
    numElement := aFieldInfo at:2 ifAbsent:1.
    ^ (SQL::ODBCHandle cSizeOf:cTypeSymbol) * numElement
! !

!ODBCHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCHandle.st,v 1.226 2018-01-19 14:19:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCHandle.st,v 1.226 2018-01-19 14:19:14 cg Exp $'
! !


ODBCHandle initialize!
