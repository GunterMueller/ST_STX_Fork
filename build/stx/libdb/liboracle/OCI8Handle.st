"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

DatabaseHandle subclass:#OCI8Handle
	instanceVariableNames:''
	classVariableNames:'ExecutionLock PollDelay Debugging AttributeTypes OCI_SUCCESS
		OCI_SUCCESS_WITH_INFO OCI_ERROR OCI_STILL_EXECUTING OCI_NO_DATA
		OCI_NEED_DATA OCI_INVALID_HANDLE OCI_CONTINUE OCI_UNKNOWN'
	poolDictionaries:''
	category:'DataBase-Oracle-Utilities'
!

OCI8Handle class instanceVariableNames:'ociTypeInteger'

"
 No other class instance variables are inherited by this class.
"
!

OCI8Handle subclass:#OCI8VariableHandle
	instanceVariableNames:'variable'
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle::OCI8VariableHandle subclass:#OCI8DefineHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8DescribeHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8Descriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8ParentHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8ErrorHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle::OCI8Descriptor subclass:#OCI8LobDescriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle::OCI8Descriptor subclass:#OCI8ParameterDescriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle::OCI8ParentHandle subclass:#OCI8EnvironmentHandle
	instanceVariableNames:''
	classVariableNames:'Lobby'
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle::OCI8Descriptor subclass:#OCI8RowIdDescriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8ServerHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8ServiceContextHandle
	instanceVariableNames:'currentTransaction'
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle::OCI8ParentHandle subclass:#OCI8StatementHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8TransactionHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle subclass:#OCI8UserSessionHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

OCI8Handle::OCI8VariableHandle subclass:#OCI8BindHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:OCI8Handle
!

!OCI8Handle primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include <oci.h>
#include <xa.h>
#include <stdio.h>
#include <memory.h>
#include <malloc.h>

/*  internal/external datatype codes */
#define VARCHAR2_TYPE           SQLT_CHR
#define NUMBER_TYPE             SQLT_NUM
#define LONG_TYPE               SQLT_LNG
#define ROWID_TYPE              SQLT_RID
#define DATE_TYPE               SQLT_DAT
#define RAW_TYPE                SQLT_BIN
#define LONG_RAW_TYPE           SQLT_LBI
#define CHAR_TYPE               SQLT_AFC
#define ROWID_DESC_TYPE         SQLT_RDD
#define NAMED_DATA_TYPE         SQLT_NTY
#define REF_TYPE                SQLT_REF
#define CHARACTER_LOB_TYPE      SQLT_CLOB
#define BINARY_LOB_TYPE         SQLT_BLOB
#define BINARY_FILE_TYPE        SQLT_FILE
#define OCI_STRING_TYPE         SQLT_VST
#define OCI_DATE_TYPE           SQLT_ODT

#define __isOciHandle(o)                (__isNonNilObject(o) && \
					 (__ClassInstPtr(__qClass(o))->c_superclass==@global(SQL::OCI8Handle) || \
					  __ClassInstPtr(__qClass(o))->c_superclass==@global(SQL::OCI8Handle::OCI8ParentHandle) || \
					  __ClassInstPtr(__qClass(o))->c_superclass==@global(SQL::OCI8Handle::OCI8Descriptor) || \
					  __ClassInstPtr(__qClass(o))->c_superclass==@global(SQL::OCI8Handle::OCI8VariableHandle)))
#define __isOciBindHandle(o)            __HASCLASS(o, @global(SQL::OCI8Handle::OCI8ErrorHandle))
#define __isOciDefineHandle(o)          __HASCLASS(o, @global(SQL::OCI8Handle::OCI8DefineHandle))
#define __isOciDescribeHandle(o)        __HASCLASS(o, @global(SQL::OCI8Handle::OCI8DescribeHandle))
#define __isOciEnvironmentHandle(o)     __HASCLASS(o, @global(SQL::OCI8Handle::OCI8EnvironmentHandle))
#define __isOciErrorHandle(o)           __HASCLASS(o, @global(SQL::OCI8Handle::OCI8ErrorHandle))
#define __isOciParameterDescriptor(o)   __HASCLASS(o, @global(SQL::OCI8Handle::OCI8ParameterDescriptor))
#define __isOciLobDescriptor(o)         __HASCLASS(o, @global(SQL::OCI8Handle::OCI8LobDescriptor))
#define __isOciServerHandle(o)          __HASCLASS(o, @global(SQL::OCI8Handle::OCI8ServerHandle))
#define __isOciServiceContextHandle(o)  __HASCLASS(o, @global(SQL::OCI8Handle::OCI8ServiceContextHandle))
#define __isOciUserSessionHandle(o)     __HASCLASS(o, @global(SQL::OCI8Handle::OCI8UserSessionHandle))
#define __isOciStatementHandle(o)       __HASCLASS(o, @global(SQL::OCI8Handle::OCI8StatementHandle))
#define __isOciTransactionHandle(o)     __HASCLASS(o, @global(SQL::OCI8Handle::OCI8StatementHandle))

__ociDebugBreakPoint__() {}

inline OBJ
__ociReturnSymbol(__retCode)
    int __retCode;
{
    switch (__retCode) {
    case OCI_SUCCESS:           return(@global(OCI_SUCCESS));
    case OCI_SUCCESS_WITH_INFO: return(@global(OCI_SUCCESS_WITH_INFO));
    case OCI_ERROR:             return(@global(OCI_ERROR));
    case OCI_STILL_EXECUTING:   return(@global(OCI_STILL_EXECUTING));
    case OCI_NO_DATA:           return(@global(OCI_NO_DATA));
    case OCI_NEED_DATA:         return(@global(OCI_NEED_DATA));
    case OCI_INVALID_HANDLE:    return(@global(OCI_INVALID_HANDLE));
    case OCI_CONTINUE:          return(@global(OCI_CONTINUE));
    default:                    return(@global(UnknownReturnCode));
    }
}

%}
! !

!OCI8Handle primitiveFunctions!
%{
#ifdef later
inline OBJ
__ociReturnSymbol(__retCode)
    int __retCode;
{
    switch (__retCode) {
    case OCI_SUCCESS:           return(@global(OCI_SUCCESS));
    case OCI_SUCCESS_WITH_INFO: return(@global(OCI_SUCCESS_WITH_INFO));
    case OCI_ERROR:             return(@global(OCI_ERROR));
    case OCI_STILL_EXECUTING:   return(@global(OCI_STILL_EXECUTING));
    case OCI_NO_DATA:           return(@global(OCI_NO_DATA));
    case OCI_NEED_DATA:         return(@global(OCI_NEED_DATA));
    case OCI_INVALID_HANDLE:    return(@global(OCI_INVALID_HANDLE));
    case OCI_CONTINUE:          return(@global(OCI_CONTINUE));
    default:                    return(@global(UnknownReturnCode));
    }
}

/*
 * put a breakpoint here to debug exceptional conditions
 */
void __ociDebugBreakPoint__() {};
#endif
%}
! !

!OCI8Handle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This is an abstract superclass. Subclasses represent represents OCI Handles.

    From OCI documentation:
    Almost all Oracle OCI calls include in their parameter list one or more handles. A handle is
    an opaque pointer to a storage area allocated by the OCI library. A handle may be used to
    store context or connection information, (e.g., an environment or service context handle),
    or it may store information about other OCI functions or data (e.g., an error or describe
    handle). Handles can make programming easier, because the library, rather than the
    application, maintains this data.

    Most OCI applications will need to access the information stored in handles. The get and
    set attribute OCI calls, OCIAttrGet() and OCIAttrSet(), access this information.
    the type as a symbol.

    [author:]
	 Pierre Schwarz

    [see also:]

    [instance variables:]
	parent          OCI8Handle|nil     The parent of this handle

    [class variables:]
"
! !

!OCI8Handle class methodsFor:'initialization'!

initialize
    self initializeReturnCodes.
    self initializeTypes.

    ExecutionLock isNil ifTrue:[
	ExecutionLock := Semaphore forMutualExclusion name:'OCI8 global lock'.
	Debugging := false.
	PollDelay := Delay forMilliseconds:10.

	self initializeAttributeTypes.
    ].

    "
     ExecutionLock := nil.
     self initialize
    "
!

initializeAttributeTypes
    AttributeTypes := IdentityDictionary withKeysAndValues:#(
	OCI_ATTR_PARAM          ParameterDescriptor
	OCI_ATTR_NAME           String
	OCI_ATTR_IS_NULL        ub1
	OCI_ATTR_SCALE          sb1
	OCI_ATTR_PRECISION      ub2
	OCI_ATTR_NUM_COLS       ub2
	OCI_ATTR_DATA_TYPE      ub2
	OCI_ATTR_DATA_SIZE      ub4kludge
	OCI_ATTR_LIST_COLUMNS   ParameterDescriptor
	OCI_ATTR_EXTERNAL_NAME  String
	OCI_ATTR_INTERNAL_NAME  String
	OCI_ATTR_IN_V8_MODE     ub1
	OCI_ATTR_NONBLOCKING_MODE  ub1
	OCI_ATTR_FOCBK          ExternalAddress
	OCI_ATTR_ENV            ExternalAddress
	OCI_ATTR_SERVER         ExternalAddress
	OCI_ATTR_SESSION        ExternalAddress
	OCI_ATTR_TRANS          ExternalAddress
	OCI_ATTR_TRANS_NAME     String
	OCI_ATTR_XID            xid
	OCI_ATTR_NUM_DML_ERRORS ub1
	OCI_ATTR_SQLFNCODE      ub2
	OCI_ATTR_STMT_TYPE      ub2
	OCI_ATTR_PARSE_ERROR_OFFSET     ub2
	OCI_ATTR_ROW_COUNT      ub4
	OCI_ATTR_ROWID          RowIdDescriptor
	OCI_ATTR_PARAM_COUNT    ub4
	OCI_ATTR_MIGSESSION     ub1
    ).
!

initializeReturnCodes
    OCI_SUCCESS             := SQL::DatabaseReturnValue success.
    OCI_SUCCESS_WITH_INFO   := SQL::DatabaseReturnValue successWithInfo.
    OCI_ERROR               := SQL::DatabaseReturnValue error.
    OCI_STILL_EXECUTING     := SQL::DatabaseReturnValue stillExecuting.
    OCI_NO_DATA             := SQL::DatabaseReturnValue noData.
    OCI_NEED_DATA           := SQL::DatabaseReturnValue needData.
    OCI_INVALID_HANDLE      := SQL::DatabaseReturnValue invalidHandle.
    OCI_CONTINUE            := SQL::DatabaseReturnValue continue.
    OCI_UNKNOWN             := SQL::DatabaseReturnValue unknown.

    "
     self initializeReturnCodes
    "
!

initializeType
    "initialize my class instance variable ociTypeInteger
     with the oci type discriminator for this handle/descriptor type"

    ociTypeInteger := self numericType.
!

initializeTypes

    self allSubclassesDo:[:eachSubclass|
	eachSubclass initializeType
    ].
! !

!OCI8Handle class methodsFor:'instance creation'!

newEnvironment:aModeSymbolColl
    "return a new environment handle"

    ^ OCI8EnvironmentHandle newMode:aModeSymbolColl.
!

newHandleWithType:aTypeSymbol
    "create an uninitilized handle of a given type"

    ^ (self privateClassesAt:aTypeSymbol) new

    "
     self newHandleWithType:#OCI8BindHandle
    "
!

newParameterDescriptorForEnvironment:anEnvironmentHandle
    "answer an new ParameterDescriptor"

    ^ OCI8ParameterDescriptor newForEnvironment:anEnvironmentHandle.
!

newRowIdDescriptorForEnvironment:anEnvironmentHandle
    "answer an new ParameterDescriptor"

    ^ OCI8RowIdDescriptor newForEnvironment:anEnvironmentHandle.
! !

!OCI8Handle class methodsFor:'buffer handling'!

bufferForSize:aBufferSize
    "returns an external buffer of the desired size. The buffer is
     prevented from garbage collection, hence it dosent change its address and
     must be freed by the caller.

     <return: ExternalBytes>"

    ^ ExternalBytes new:aBufferSize
! !

!OCI8Handle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

    self isAbstract ifTrue:[
	^ nil.
    ].

    ^ self subclassResponsibility
!

numericValueForAttribute:anOCIAtributeSymbol
    "
     converts a symbol anOCIAtributeSymbol to its corresponding integer value.

     <return: Integer>
    "
%{
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_AGENT_ADDRESS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_AGENT_ADDRESS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_AGENT_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_AGENT_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_AGENT_PROTOCOL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_AGENT_PROTOCOL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ALLOC_DURATION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ALLOC_DURATION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ATTEMPTS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ATTEMPTS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_BUF_ADDR)) {
	RETURN (__mkSmallInteger(OCI_ATTR_BUF_ADDR));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_BUF_SIZE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_BUF_SIZE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CACHE_ARRAYFLUSH)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CACHE_ARRAYFLUSH));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CACHE_MAX_SIZE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CACHE_MAX_SIZE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CACHE_OPT_SIZE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CACHE_OPT_SIZE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CHAR_COUNT)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CHAR_COUNT));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CHARSET_ID)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CHARSET_ID));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CHARSET_FORM)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CHARSET_FORM));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_COL_COUNT)) {
	RETURN (__mkSmallInteger(OCI_ATTR_COL_COUNT));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CONSUMER_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CONSUMER_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CORRELATION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_CORRELATION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_COMPLEXOBJECT_LEVEL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_COMPLEXOBJECT_LEVEL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_COMPLEXOBJECT_COLL_OUTOFLINE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_COMPLEXOBJECT_COLL_OUTOFLINE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_COMPLEXOBJECTCOMP_TYPE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_COMPLEXOBJECTCOMP_TYPE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_COMPLEXOBJECTCOMP_TYPE_LEVEL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_COMPLEXOBJECTCOMP_TYPE_LEVEL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_CURSOR_COMMIT_BEHAVIOR)) {
	RETURN (__MKUINT(OCI_ATTR_CURSOR_COMMIT_BEHAVIOR));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DATA_SIZE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DATA_SIZE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DATA_TYPE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DATA_TYPE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DATEFORMAT)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DATEFORMAT));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DELAY)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DELAY));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DEQ_MODE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DEQ_MODE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DEQ_MSGID)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DEQ_MSGID));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DIRPATH_MODE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DIRPATH_MODE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DIRPATH_NOLOG)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DIRPATH_NOLOG));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DIRPATH_PARALLEL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DIRPATH_PARALLEL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_DML_ROW_OFFSET)) {
	RETURN (__mkSmallInteger(OCI_ATTR_DML_ROW_OFFSET));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ENV)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ENV));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ENQ_TIME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ENQ_TIME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_EXCEPTION_QUEUE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_EXCEPTION_QUEUE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_EXPIRATION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_EXPIRATION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_EXTERNAL_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_EXTERNAL_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_FOCBK)) {
	RETURN (__mkSmallInteger(OCI_ATTR_FOCBK));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_HEAPALLOC)) {
	RETURN (__mkSmallInteger(OCI_ATTR_HEAPALLOC));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_IN_V8_MODE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_IN_V8_MODE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_INTERNAL_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_INTERNAL_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_IS_NULL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_IS_NULL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_LIST_COLUMNS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_LIST_COLUMNS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_LIST_OBJECTS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_LIST_OBJECTS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_LIST_SCHEMAS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_LIST_SCHEMAS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_LIST_TYPE_ATTRS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_LIST_TYPE_ATTRS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_LIST_TYPE_METHODS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_LIST_TYPE_METHODS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_LOBEMPTY)) {
	RETURN (__mkSmallInteger(OCI_ATTR_LOBEMPTY));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MAXDATA_SIZE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MAXDATA_SIZE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MEMPOOL_APPNAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MEMPOOL_APPNAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MEMPOOL_HOMENAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MEMPOOL_HOMENAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MEMPOOL_INSTNAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MEMPOOL_INSTNAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MEMPOOL_MODEL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MEMPOOL_MODEL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MEMPOOL_SIZE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MEMPOOL_SIZE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MIGSESSION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MIGSESSION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_MSG_STATE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_MSG_STATE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_NAVIGATION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_NAVIGATION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_NONBLOCKING_MODE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_NONBLOCKING_MODE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_NUM_COLS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_NUM_COLS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_NUM_DML_ERRORS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_NUM_DML_ERRORS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_NUM_PARAMS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_NUM_PARAMS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_NUM_ROWS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_NUM_ROWS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_OBJECT_DETECTCHANGE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_OBJECT_DETECTCHANGE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_OBJECT_NEWNOTNULL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_OBJECT_NEWNOTNULL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_OBJECT)) {
	RETURN (__mkSmallInteger(OCI_ATTR_OBJECT));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ORIGINAL_MSGID)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ORIGINAL_MSGID));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PARAM)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PARAM));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PARAM_COUNT)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PARAM_COUNT));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PARSE_ERROR_OFFSET)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PARSE_ERROR_OFFSET));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PASSWORD)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PASSWORD));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PDPRC)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PDPRC));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PDSCL)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PDSCL));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PIN_DURATION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PIN_DURATION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PINOPTION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PINOPTION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PRECISION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PRECISION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PREFETCH_MEMORY)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PREFETCH_MEMORY));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PREFETCH_ROWS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PREFETCH_ROWS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_PRIORITY)) {
	RETURN (__mkSmallInteger(OCI_ATTR_PRIORITY));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_RECIPIENT_LIST)) {
	RETURN (__mkSmallInteger(OCI_ATTR_RECIPIENT_LIST));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_RELATIVE_MSGID)) {
	RETURN (__mkSmallInteger(OCI_ATTR_RELATIVE_MSGID));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ROW_COUNT)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ROW_COUNT));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ROWID)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ROWID));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_ROWS_RETURNED)) {
	RETURN (__mkSmallInteger(OCI_ATTR_ROWS_RETURNED));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SCALE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SCALE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SCHEMA_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SCHEMA_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SENDER_ID)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SENDER_ID));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SERVER)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SERVER));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SERVER_GROUP)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SERVER_GROUP));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SESSION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SESSION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SEQUENCE_DEVIATION)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SEQUENCE_DEVIATION));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SHARED_HEAPALLOC)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SHARED_HEAPALLOC));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SQLFNCODE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SQLFNCODE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_STMT_TYPE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_STMT_TYPE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_STREAM_OFFSET)) {
	RETURN (__mkSmallInteger(OCI_ATTR_STREAM_OFFSET));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SUB_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SUB_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SUBSCR_CALLBACK)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SUBSCR_CALLBACK));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SUBSCR_CTX)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SUBSCR_CTX));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SUBSCR_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SUBSCR_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SUBSCR_NAMESPACE)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SUBSCR_NAMESPACE));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_SUBSCR_PAYLOAD)) {
	RETURN (__mkSmallInteger(OCI_ATTR_SUBSCR_PAYLOAD));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_TRANS)) {
	RETURN (__mkSmallInteger(OCI_ATTR_TRANS));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_TRANS_NAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_TRANS_NAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_USERNAME)) {
	RETURN (__mkSmallInteger(OCI_ATTR_USERNAME));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_VISIBILITY)) {
	RETURN (__mkSmallInteger(OCI_ATTR_VISIBILITY));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_VISIBILITY)) {
	RETURN (__mkSmallInteger(OCI_ATTR_VISIBILITY));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_WAIT)) {
	RETURN (__mkSmallInteger(OCI_ATTR_WAIT));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_ATTR_XID)) {
	RETURN (__mkSmallInteger(OCI_ATTR_XID));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_CURSOR_CLOSED)) {
	RETURN (__MKUINT(OCI_CURSOR_CLOSED));
    }
    if (anOCIAtributeSymbol == @symbol(OCI_CURSOR_OPEN)) {
	RETURN (__MKUINT(OCI_CURSOR_OPEN));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad attribute arg'.
!

numericValueForBindMode:anOCIBindModeSymbol
    "
     converts a symbol anOCIBindModeSymbol to its corresponding integer value.

     The possible values are:

	     OCI_DEFAULT      - This is default mode.
	     OCI_DATA_AT_EXEC - When this mode is selected, the value_sz parameter defines the maximum
				size of the data that can be ever provided at runtime. The application must
				be ready to provide the OCI library runtime IN data buffers at any time and
				any number of times. Runtime data is provided in one of the two ways:

				- callbacks using a user-defined function which must be registered with
				  a subsequent call to OCIBindDynamic().
				- a polling mechanism using calls supplied by the OCI.
				  This mode is assumed if no callbacks are define.

     <return: Integer>
    "
%{
    if (anOCIBindModeSymbol == nil || anOCIBindModeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
    if (anOCIBindModeSymbol == @symbol(OCI_DATA_AT_EXEC)) {
	RETURN (__MKUINT(OCI_DATA_AT_EXEC));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad bind mode arg'.


    "
     self numericValueForBindByPosType:#'OCI_DEFAULT'
     self numericValueForBindByPosType:#'OCI_DATA_AT_EXEC'
    "
!

numericValueForCDataType:anOCICDataTypeSymbol

%{ /*NOCONTEXT*/
    if (anOCICDataTypeSymbol == @symbol(SQLT_NUM)) {
	RETURN (__mkSmallInteger(SQLT_NUM));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_CHR)) {
	RETURN (__mkSmallInteger(SQLT_CHR));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_BIN)) {
	RETURN (__mkSmallInteger(SQLT_BIN));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_LBI)) {
	RETURN (__mkSmallInteger(SQLT_LBI));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_LNG)) {
	RETURN (__mkSmallInteger(SQLT_LNG));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_DAT)) {
	RETURN (__mkSmallInteger(SQLT_DAT));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_INT)) {
	RETURN (__mkSmallInteger(SQLT_INT));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_FLT)) {
	RETURN (__mkSmallInteger(SQLT_FLT));
    }
    if (anOCICDataTypeSymbol == @symbol(SQLT_RDD)) {
	RETURN (__mkSmallInteger(SQLT_RDD));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad c-type arg'.


    "
     self numericValueForCDataType:#'C_TYPE_DATE'
    "
!

numericValueForCredentialType:anOCICredentialTypeSymbol
    "
     converts a symbol anOCICredentialTypeSymbol to its corresponding integer value.
     Specifies the type of credentials to use for establishing the user session.

     Valid values for anOCICredentialTypeSymbol are:

	     OCI_CRED_RDBMS - authenticate using a database username and password pair as credentials.
			      The attributes OCI_ATTR_USERNAME and OCI_ATTR_ PASSWORD should be set on
			      the user session context before this call.

	     OCI_CRED_EXT   - authenticate using external credentials. No username or password is provided.

     <return: Integer>
    "
%{
    if (anOCICredentialTypeSymbol == @symbol(OCI_CRED_RDBMS)) {
	RETURN (__MKUINT(OCI_CRED_RDBMS));
    }
    if (anOCICredentialTypeSymbol == @symbol(OCI_CRED_EXT)) {
	RETURN (__MKUINT(OCI_CRED_EXT));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad credential type arg'.


    "
     self numericValueForCredentialType:#'OCI_CRED_RDBMS'
     self numericValueForCredentialType:#'OCI_CRED_EXT'
    "
!

numericValueForDefineMode:anOCIDefineModeSymbol
    "
     converts a symbol anOCIDefineModeSymbol to its corresponding integer value.

     The possible values are:

	     OCI_DEFAULT       - This is default mode.

	     OCI_DYNAMIC_FETCH - For applications requiring dynamically allocated data at the time of fetch,
				 this mode must be used. The user may additionally call OCIDefineDynamic()
				 to set up a callback function that will be invoked to receive the dynamically
				 allocated buffers and. The valuep and value_sz parameters are ignored in this mode.

     <return: Integer>
    "
%{
    if (anOCIDefineModeSymbol == nil || anOCIDefineModeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
    if (anOCIDefineModeSymbol == @symbol(OCI_DYNAMIC_FETCH)) {
	RETURN (__MKUINT(OCI_DYNAMIC_FETCH));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:'- bad define mode arg'.


    "
     self numericValueForDefineMode:#'OCI_DEFAULT'
     self numericValueForDefineMode:#'OCI_DYNAMIC_FETCH'
    "
!

numericValueForEnvironmentMode:anOCIModeSymbol
    "
     converts a symbol anOCIModeSymbol to its corresponding integer value.
     Specifies initialization of the mode. Valid modes are:
	 #'OCI_DEFAULT'      - uses default mode.
	 #'OCI_THREADED'     - uses threaded environment. Internal data structures not exposed to the user
			       are protected from concurrent accesses by multiple threads.
	 #'OCI_OBJECT'       - uses object features.
	 #'OCI_SHARED'       - utilizes shared data structures.
	 #'OCI_EVENTS'       - utilizes publish-subscribe notifications.
	 #'OCI_NO_UCB'       - suppresses the calling of the dynamic callback routine.
			       The default behavior is to allow calling of callback routines at the time that the
			       environment is created.
	 #'OCI_ENV_NO_MUTEX' - no mutexing in this mode. All OCI calls done on the environment handle, or on
			       handles derived from the environment handle, must be serialized.

     <return: Integer>
    "
%{
    if (anOCIModeSymbol == nil || anOCIModeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
    if (anOCIModeSymbol == @symbol(OCI_THREADED)) {
	RETURN (__MKUINT(OCI_THREADED));
    }
    if (anOCIModeSymbol == @symbol(OCI_OBJECT)) {
	RETURN (__MKUINT(OCI_OBJECT));
    }
    if (anOCIModeSymbol == @symbol(OCI_SHARED)) {
	RETURN (__MKUINT(OCI_SHARED));
    }
    if (anOCIModeSymbol == @symbol(OCI_EVENTS)) {
	RETURN (__MKUINT(OCI_EVENTS));
    }
    if (anOCIModeSymbol == @symbol(OCI_NO_UCB)) {
	RETURN (__MKUINT(OCI_NO_UCB));
    }
    if (anOCIModeSymbol == @symbol(OCI_ENV_NO_MUTEX)) {
	RETURN (__MKUINT(OCI_ENV_NO_MUTEX));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad environment mode arg'.


    "
     self numericValueForMode:#'OCI_EVENTS'
     self numericValueForMode:#'OCI_OBJECT'
     self numericValueForMode:#'OCI_FOO'
    "
!

numericValueForExecuteMode:anOCIExecuteModeSymbol
    "
     converts a symbol anOCIExecuteModeSymbol to its corresponding integer value.

     The possible values are:

	     OCI_DEFAULT           - Calling OCIStmtExecute() in this mode executes the statement.
				     It also implicitly returns describe information about the select-list.

	     OCI_DESCRIBE_ONLY     - This mode is for users who wish to describe a query prior to execution.
				     Calling OCIStmtExecute() in this mode does not execute the statement,
				     but it does return the select-list description. To maximize performance,
				     it is recommended that applications execute the statement in default mode
				     and use the implicit describe which accompanies the execution.

	     OCI_COMMIT_ON_SUCCESS - When a statement is executed in this mode, the current transaction
				     is committed after execution, provided that execution completes successfully.

	     OCI_EXACT_FETCH       - Used when the application knows in advance exactly how many rows it will be fetching.
				     This mode turns prefetching off for Oracle release 8 mode, and requires that defines
				     be done before the execute call. Using this mode cancels the cursor after the
				     desired rows are fetched and may result in reduced server-side resource usage.
	     OCI_BATCH_ERRORS      - See Batch Error Mode for OCIStmtExecute() for information about this mode.

     <return: Integer>
    "
%{
    if (anOCIExecuteModeSymbol == nil || anOCIExecuteModeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
    if (anOCIExecuteModeSymbol == @symbol(OCI_DESCRIBE_ONLY)) {
	RETURN (__MKUINT(OCI_DESCRIBE_ONLY));
    }
    if (anOCIExecuteModeSymbol == @symbol(OCI_COMMIT_ON_SUCCESS)) {
	RETURN (__MKUINT(OCI_COMMIT_ON_SUCCESS));
    }
    if (anOCIExecuteModeSymbol == @symbol(OCI_EXACT_FETCH)) {
	RETURN (__MKUINT(OCI_EXACT_FETCH));
    }
    if (anOCIExecuteModeSymbol == @symbol(OCI_BATCH_ERRORS)) {
	RETURN (__MKUINT(OCI_BATCH_ERRORS));
    }
#if defined(OCI_STMT_SCROLLABLE_READONLY) /* supported in Oracle 9 and following */
    if (anOCIExecuteModeSymbol == @symbol(OCI_STMT_SCROLLABLE_READONLY)) {
	RETURN (__MKUINT(OCI_STMT_SCROLLABLE_READONLY));
    }
#endif

%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad execute mode arg'.


    "
     self numericValueForExecuteMode:#'OCI_DEFAULT'
     self numericValueForExecuteMode:#'OCI_BATCH_ERRORS'
     self numericValueForExecuteMode:#'OCI_STMT_SCROLLABLE_READONLY'
    "
!

numericValueForFetchMode:anOCIFetchModeSymbol
    "
     converts a symbol anOCIFetchModeSymbol to its corresponding integer value.

     The possible values are:

	     OCI_DEFAULT - only mode

     <return: Integer>
    "
%{
    if (anOCIFetchModeSymbol == nil || anOCIFetchModeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad fetch mode arg'.


    "
     self numericValueForFetchMode:#'OCI_DEFAULT'
    "
!

numericValueForInternalDataType:anOCIInternalDataTypeSymbol
    "
     converts a symbol anOCIInternalDataTypeSymbol to its corresponding integer value.

     The possible values are:

	 VARCHAR2_TYPE - The VARCHAR2 datatype is a variable-length string of characters
			 with a maximum length of 4000 bytes.

	 NUMBER_TYPE   - You should not need to use NUMBER as an external datatype.
			 If you do use it, Oracle returns numeric values in its internal
			 21-byte binary format and will expect this format on input.

	 LONG_TYPE     - The LONG datatype stores character strings longer than 4000 bytes. You can store up
			 to two gigabytes (2^31-1 bytes) in a LONG column. Columns of this type are used only
			 for storage and retrieval of long strings.

	 ROWID_TYPE    - The ROWID datatype identifies a particular row in a database table.

	 DATE_TYPE     - The DATE datatype can update, insert, or retrieve a date value using the Oracle internal date
			 binary format. A date in binary format contains seven bytes:

			 for 30-NOV-1992, 3:17 PM

			 Byte    | 1       | 2    | 3     | 4   | 5    | 6      | 7      |
			 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			 Meaning | Century | Year | Month | Day | Hour | Minute | Second |
			 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			 Example | 119     | 192  | 11    | 30  | 16   | 18     | 1      |

			 The century and year bytes are in an excess-100 notation. Dates Before Common Era (BCE) are less
			 than 100. The era begins on 01-JAN-4712 BCE, which is Julian day 1. For this date, the century
			 byte is 53, and the year byte is 88. The hour, minute, and second bytes are in excess-1 notation.
			 The hour byte ranges from 1 to 24, the minute and second bytes from 1 to 60. If no time was specified
			 when the date was created, the time defaults to midnight (1, 1, 1). When you enter a date in binary
			 format using the DATE external datatype, the database does not do consistency or range checking.
			 All data in this format must be carefully validated before input.

	 RAW_TYPE      - The RAW datatype is used for binary data or byte strings that are not to be interpreted
			 by Oracle.The maximum length of a RAW column is 2000 bytes.

	 LONG_RAW_TYPE - The LONG RAW datatype is similar to the RAW datatype, except that it stores raw data with
			 a length up to two gigabytes (2^31-1 bytes).

	 CHAR_TYPE          - The CHAR datatype is a string of characters, with a maximum length of 2000.
			      CHAR strings are compared using blank-padded comparison semantics.

	 REF_TYPE           - This is a reference to a named data type.

	 CHARACTER_LOB_TYPE - A LOB (Large OBject) stores character data up to 4 gigabytes in length.
			      Character data (fixed- or varying-width) is stored in a CLOB (Character LOB) or
			      NCLOB (National Character LOB). An NCLOB is a national character version of a CLOB.
			      It stores fixed-width, single- or multi-byte national character set character (NCHAR),
			      or varying-width character sets data.

	 BINARY_LOB_TYPE    - A LOB (Large OBject) stores binary data up to 4 gigabytes in length.
			      The BLOB (Binary LOB) datatype stores unstructured binary large objects.
			      BLOBs can be thought of as bitstreams with no character set semantics.

	 BINARY_FILE_TYPE   - The FILE datatype provides access to file LOBs that are stored in file systems outside
			      an Oracle database.


     <return: Integer>
    "
%{
    if (anOCIInternalDataTypeSymbol == @symbol(VARCHAR2_TYPE)) {
	RETURN (__MKUINT(VARCHAR2_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(NUMBER_TYPE)) {
	RETURN (__MKUINT(NUMBER_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(LONG_TYPE)) {
	RETURN (__MKUINT(LONG_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(ROWID_TYPE)) {
	RETURN (__MKUINT(ROWID_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(DATE_TYPE)) {
	RETURN (__MKUINT(DATE_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(RAW_TYPE)) {
	RETURN (__MKUINT(RAW_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(LONG_RAW_TYPE)) {
	RETURN (__MKUINT(LONG_RAW_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(CHAR_TYPE)) {
	RETURN (__MKUINT(CHAR_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(REF_TYPE)) {
	RETURN (__MKUINT(REF_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(CHARACTER_LOB_TYPE)) {
	RETURN (__MKUINT(CHARACTER_LOB_TYPE));
    }
    if (anOCIInternalDataTypeSymbol == @symbol(BINARY_LOB_TYPE)) {
	RETURN (__MKUINT(BINARY_LOB_TYPE));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad internal datatype'.


    "
     self numericValueForInternalDataType:#'VARCHAR2_TYPE'
     self numericValueForInternalDataType:#'ROWID_TYPE'
     self numericValueForInternalDataType:#'LONG_TYPE'
     self numericValueForInternalDataType:#'DATE_TYPE'
    "
!

numericValueForLanguageMode:anOCILanguageModeSymbol
    "
     converts a symbol anOCILanguageModeSymbol to its corresponding integer value.
     Specifies V7, or native syntax. Possible values are:

	     OCI_V7_SYNTAX - V7 ORACLE parsing syntax

	     OCI_NTV_SYNTAX - syntax depends upon the version of the server.

     <return: Integer>
    "
%{
    if (anOCILanguageModeSymbol == nil || anOCILanguageModeSymbol == @symbol(OCI_NTV_SYNTAX)) {
	RETURN (__MKUINT(OCI_NTV_SYNTAX));
    }
    if (anOCILanguageModeSymbol == @symbol(OCI_V7_SYNTAX)) {
	RETURN (__MKUINT(OCI_V7_SYNTAX));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad language mode arg'.


    "
     self numericValueForLanguageMode:#'OCI_V7_SYNTAX'
     self numericValueForLanguageMode:#'OCI_NTV_SYNTAX'
    "
!

numericValueForOrientationMode:anOCIOrientationModeSymbol
    "
     converts a symbol anOCIOrientationModeSymbol to its corresponding integer value.

     The possible values are:

	      OCI_FETCH_NEXT - For release 8.0, the only acceptable value is OCI_FETCH_NEXT,
			       which is also the default value.

     <return: Integer>
    "
%{
    if (anOCIOrientationModeSymbol == nil || anOCIOrientationModeSymbol == @symbol(OCI_FETCH_NEXT)) {
	RETURN (__MKUINT(OCI_FETCH_NEXT));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad orientation mode arg'.


    "
     self numericValueForOrientationMode:#'OCI_FETCH_NEXT'
    "
!

numericValueForPrepareMode:anOCIPrepareModeSymbol
    "
     converts a symbol anOCIPrepareModeSymbol to its corresponding integer value.

     The possible values are:

	     OCI_DEFAULT    - default mode
	     OCI_NO_SHARING - disables sharing mode for the SQL statement.

     <return: Integer>
    "
%{
    if (anOCIPrepareModeSymbol == nil || anOCIPrepareModeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
    if (anOCIPrepareModeSymbol == @symbol(OCI_NO_SHARING)) {
	RETURN (__MKUINT(OCI_NO_SHARING));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad prepare mode arg'.


    "
     self numericValueForPrepareMode:#'OCI_DEFAULT'
     self numericValueForPrepareMode:#'OCI_NO_SHARING'
    "
!

numericValueForSchemaTypes:anOCISchemaTypeSymbol
    "
     The type of schema object to be described.
     Valid values are:

	 OCI_PTYPE_TABLE     - for tables
	 OCI_PTYPE_VIEW      - for views
	 OCI_PTYPE_PROC      - for procedures
	 OCI_PTYPE_FUNC      - for functions
	 OCI_PTYPE_PKG       - for packages
	 OCI_PTYPE_TYPE      - for types
	 OCI_PTYPE_SYN       - for synonyms
	 OCI_PTYPE_SEQ       - for sequences
	 OCI_PTYPE_SCHEMA    - for schemas
	 OCI_PTYPE_DATABASE  - for databases
	 OCI_PTYPE_UNK       - for unknown schema objects

     <return: Integer>
    "

%{
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_TABLE)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_TABLE));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_VIEW)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_VIEW));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_PROC)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_PROC));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_FUNC)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_FUNC));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_PKG)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_PKG));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_TYPE)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_TYPE));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_SYN)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_SYN));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_SEQ)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_SEQ));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_SCHEMA)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_SCHEMA));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_DATABASE)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_DATABASE));
    }
    if (anOCISchemaTypeSymbol == @symbol(OCI_PTYPE_UNK)) {
	RETURN (__mkSmallInteger(OCI_PTYPE_UNK));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad schema type'.
!

numericValueForSessionMode:anOCISessionModeSymbol
    "
     Specifies the various modes of operation. Valid modes are:

	 OCI_DEFAULT     - in this mode, the user session context returned may only ever
			   be set with the same server context specified in svchp.

	 OCI_MIGRATE     - in this mode, the new user session context may be set in a service
			   handle with a different server handle. This mode establishes the user
			   session context. To create a migratable session, the service handle must
			   already be set with a non-migratable user session. A migratable session
			   must have a non-migratable parent session.

	 OCI_SYSDBA      - in this mode, the user is authenticated for SYSDBA access.

	 OCI_SYSOPER     - in this mode, the user is authenticated for SYSOPER access.

	 OCI_PRELIM_AUTH - this mode may only be used with OCI_SYSDBA or OCI_SYSOPER to
			      authenticate for certain administration tasks.

     <return: Integer>
    "
%{
    if (anOCISessionModeSymbol == nil || anOCISessionModeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
    if (anOCISessionModeSymbol == @symbol(OCI_MIGRATE)) {
	RETURN (__MKUINT(OCI_MIGRATE));
    }
    if (anOCISessionModeSymbol == @symbol(OCI_SYSDBA)) {
	RETURN (__MKUINT(OCI_SYSDBA));
    }
    if (anOCISessionModeSymbol == @symbol(OCI_SYSOPER)) {
	RETURN (__MKUINT(OCI_SYSOPER));
    }
    if (anOCISessionModeSymbol == @symbol(OCI_PRELIM_AUTH)) {
	RETURN (__MKUINT(OCI_PRELIM_AUTH));
    }
%}.
    OCIUnhandledAttributeTypeError raiseWith:' - bad session mode'.


    "
     self numericValueForSessionMode:#'OCI_DEFAULT'
     self numericValueForSessionMode:#'OCI_MIGRATE'
     self numericValueForSessionMode:#'OCI_PRELIM_AUTH'
    "
!

numericValueForStatement:anOCIStatementSymbol
    "
     converts a symbol anOCIStatementSymbol to its corresponding integer value.

     The possible values are:

	     OCI_STMT_SELECT         SELECT statement
	     OCI_STMT_UPDATE         UPDATE statement
	     OCI_STMT_DELETE         DELETE statement
	     OCI_STMT_INSERT         INSERT statement
	     OCI_STMT_CREATE         CREATE statement
	     OCI_STMT_DROP           DROP statement
	     OCI_STMT_ALTER          ALTER statement
	     OCI_STMT_BEGIN          BEGIN PL/SQL statement
	     OCI_STMT_DECLARE        DECLARE PL/SQL statement

     <return: Integer>
    "
%{
    if (anOCIStatementSymbol == @symbol(OCI_STMT_SELECT)) {
	RETURN (__MKUINT(OCI_STMT_SELECT));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_UPDATE)) {
	RETURN (__MKUINT(OCI_STMT_UPDATE));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_DELETE)) {
	RETURN (__MKUINT(OCI_STMT_DELETE));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_INSERT)) {
	RETURN (__MKUINT(OCI_STMT_INSERT));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_CREATE)) {
	RETURN (__MKUINT(OCI_STMT_CREATE));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_DROP)) {
	RETURN (__MKUINT(OCI_STMT_DROP));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_ALTER)) {
	RETURN (__MKUINT(OCI_STMT_ALTER));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_BEGIN)) {
	RETURN (__MKUINT(OCI_STMT_BEGIN));
    }
    if (anOCIStatementSymbol == @symbol(OCI_STMT_DECLARE)) {
	RETURN (__MKUINT(OCI_STMT_DECLARE));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad statement type'.


    "
     self numericValueForStatement:#'OCI_STMT_UPDATE'
     self numericValueForStatement:#'OCI_STMT_SELECT'
     self numericValueForStatement:#'OCI_STMT_INSERT'
    "
!

numericValueForTransactionCommitType:anOCITransactionCommitTypeSymbol
"
converts a symbol anOCITransactionCommitTypeSymbol to its corresponding integer value.

The possible values are:

	OCI_DEFAULT           - for non-distributed transactions, its a one phase commit
	OCI_TRANS_TWOPHASE    - for applications managing global transactions

<return: Integer>
"
%{
    if (anOCITransactionCommitTypeSymbol == nil || anOCITransactionCommitTypeSymbol == @symbol(OCI_DEFAULT)) {
	RETURN (__MKUINT(OCI_DEFAULT));
    }
    if (anOCITransactionCommitTypeSymbol == @symbol(OCI_TRANS_TWOPHASE)) {
	RETURN (__MKUINT(OCI_TRANS_TWOPHASE));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad transaction commit type'.


    "
     self numericValueForTransactionCommitType:#'OCI_DEFAULT'
     self numericValueForTransactionCommitType:#'OCI_TRANS_TWOPHASE'
    "
!

numericValueForTransactionType:anOCITransactionTypeSymbol
"
converts a symbol anOCITransactionTypeSymbol to its corresponding integer value.

The possible values are:

	OCI_TRANS_NEW           - starts a new transaction branch. By default starts
				  a tightly coupled and migratable branch.
	OCI_TRANS_TIGHT         - explicitly specifies a tightly coupled branch
	OCI_TRANS_LOOSE         - specifies a loosely coupled branch
	OCI_TRANS_RESUME        - resumes an existing transaction branch.
	OCI_TRANS_READONLY      - start a read-only transaction
	OCI_TRANS_SERIALIZABLE  - start a serializable transaction

<return: Integer>
"
%{
    if (anOCITransactionTypeSymbol == @symbol(OCI_TRANS_NEW)) {
	RETURN (__MKUINT(OCI_TRANS_NEW));
    }
    if (anOCITransactionTypeSymbol == @symbol(OCI_TRANS_TIGHT)) {
	RETURN (__MKUINT(OCI_TRANS_TIGHT));
    }
    if (anOCITransactionTypeSymbol == @symbol(OCI_TRANS_LOOSE)) {
	RETURN (__MKUINT(OCI_TRANS_LOOSE));
    }
    if (anOCITransactionTypeSymbol == @symbol(OCI_TRANS_RESUME)) {
	RETURN (__MKUINT(OCI_TRANS_RESUME));
    }
    if (anOCITransactionTypeSymbol == @symbol(OCI_TRANS_READONLY)) {
	RETURN (__MKUINT(OCI_TRANS_READONLY));
    }
    if (anOCITransactionTypeSymbol == @symbol(OCI_TRANS_SERIALIZABLE)) {
	RETURN (__MKUINT(OCI_TRANS_SERIALIZABLE));
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - bad transaction type'.


    "
     self numericValueForTransactionType:#'OCI_TRANS_RESUME'
     self numericValueForTransactionType:#'OCI_TRANS_SERIALIZABLE'
     self numericValueForTransactionType:#'OCI_TRANS_READONLY'
    "
!

numericValueForTransactionTypeColl:anOCITransactionTypeSymbolColl
    "converts the symbols in anOCITransactionTypeSymbolColl into an integer value.
     The values of the symbols are concatenated with bitOr.

     <return: Integer>"

    |returnValue|

    returnValue := 0.
    anOCITransactionTypeSymbolColl do:[:eachSymbol |
	returnValue := returnValue bitOr:(self numericValueForTransactionType:eachSymbol)
    ].
    ^ returnValue


    "
     self numericValueForTransactionTypeColl:#(#'OCI_TRANS_SERIALIZABLE' #'OCI_TRANS_READONLY')
     self numericValueForTransactionType:#'OCI_TRANS_SERIALIZABLE'
     self numericValueForTransactionType:#'OCI_TRANS_READONLY'
    "
!

sb2Size
    "return the size of an Oracle sb2 c datatype (two byte signed value)

     <return: Integer>"
%{
    RETURN(__MKINT(sizeof(sb2)))
%}

"
  self sb2Size
"
!

sb4Size
    "return the size of an Oracle sb4 c datatype (four byte signed value)

     <return: Integer>"

%{
    RETURN(__MKINT(sizeof(sb4)));
%}
!

symbolForNumericStatementType:anOCINumericStatementType
"
converts an integer value anOCINumericStatementType to its corresponding symbol.

The possible values are:

	OCI_STMT_SELECT         SELECT statement
	OCI_STMT_UPDATE         UPDATE statement
	OCI_STMT_DELETE         DELETE statement
	OCI_STMT_INSERT         INSERT statement
	OCI_STMT_CREATE         CREATE statement
	OCI_STMT_DROP           DROP statement
	OCI_STMT_ALTER          ALTER statement
	OCI_STMT_BEGIN          BEGIN PL/SQL statement
	OCI_STMT_DECLARE        DECLARE PL/SQL statement

<return: Symbol>
"
"
self symbolForNumericStatementType:(self numericValueForStatement:#'OCI_STMT_SELECT')
"

%{
    ub2 __attributetype = (ub2) __unsignedLongIntVal(anOCINumericStatementType);

    switch (__attributetype)
    {
	case OCI_STMT_SELECT:
	    RETURN (@symbol(OCI_STMT_SELECT));
	    break;
	case OCI_STMT_UPDATE:
	    RETURN (@symbol(OCI_STMT_UPDATE));
	    break;
	case OCI_STMT_DELETE:
	    RETURN (@symbol(OCI_STMT_DELETE));
	    break;
	case OCI_STMT_INSERT:
	    RETURN (@symbol(OCI_STMT_INSERT));
	    break;
	case OCI_STMT_CREATE:
	    RETURN (@symbol(OCI_STMT_CREATE));
	    break;
	case OCI_STMT_DROP:
	    RETURN (@symbol(OCI_STMT_DROP));
	    break;
	case OCI_STMT_ALTER:
	    RETURN (@symbol(OCI_STMT_ALTER));
	    break;
	case OCI_STMT_BEGIN:
	    RETURN (@symbol(OCI_STMT_BEGIN));
	    break;
	case OCI_STMT_DECLARE:
	    RETURN (@symbol(OCI_STMT_DECLARE));
	    break;
	default:
	    RETURN (@symbol(OCI_STMT_OTHER));
	    break;
    }
%}.
!

symbolForOCIDataType:anOCIDataType
"
converts an integer anOCIDataType which represents an internal data type of
an oracle db to its corresponding symbol.

The possible values are:

    VARCHAR2_TYPE - The VARCHAR2 datatype is a variable-length string of characters
		    with a maximum length of 4000 bytes.

    NUMBER_TYPE   - You should not need to use NUMBER as an external datatype.
		    If you do use it, Oracle returns numeric values in its internal
		    21-byte binary format and will expect this format on input.

    LONG_TYPE     - The LONG datatype stores character strings longer than 4000 bytes. You can store up
		    to two gigabytes (2^31-1 bytes) in a LONG column. Columns of this type are used only
		    for storage and retrieval of long strings.

    ROWID_TYPE    - The ROWID datatype identifies a particular row in a database table.

    DATE_TYPE     - The DATE datatype can update, insert, or retrieve a date value using the Oracle internal date
		    binary format. A date in binary format contains seven bytes:

		    for 30-NOV-1992, 3:17 PM

		    Byte    | 1       | 2    | 3     | 4   | 5    | 6      | 7      |
		    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		    Meaning | Century | Year | Month | Day | Hour | Minute | Second |
		    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		    Example | 119     | 192  | 11    | 30  | 16   | 18     | 1      |

		    The century and year bytes are in an excess-100 notation. Dates Before Common Era (BCE) are less
		    than 100. The era begins on 01-JAN-4712 BCE, which is Julian day 1. For this date, the century
		    byte is 53, and the year byte is 88. The hour, minute, and second bytes are in excess-1 notation.
		    The hour byte ranges from 1 to 24, the minute and second bytes from 1 to 60. If no time was specified
		    when the date was created, the time defaults to midnight (1, 1, 1). When you enter a date in binary
		    format using the DATE external datatype, the database does not do consistency or range checking.
		    All data in this format must be carefully validated before input.

    RAW_TYPE      - The RAW datatype is used for binary data or byte strings that are not to be interpreted
		    by Oracle.The maximum length of a RAW column is 2000 bytes.

    LONG_RAW_TYPE - The LONG RAW datatype is similar to the RAW datatype, except that it stores raw data with
		    a length up to two gigabytes (2^31-1 bytes).

    CHAR_TYPE           - The CHAR datatype is a string of characters, with a maximum length of 2000.
			  CHAR strings are compared using blank-padded comparison semantics.

    REF_TYPE            - This is a reference to a named data type.

    CHARACTER_LOB_TYPE - A LOB (Large OBject) stores character data up to 4 gigabytes in length.
			 Character data (fixed- or varying-width) is stored in a CLOB (Character LOB) or
			 NCLOB (National Character LOB). An NCLOB is a national character version of a CLOB.
			 It stores fixed-width, single- or multi-byte national character set character (NCHAR),
			 or varying-width character sets data.

    BINARY_LOB_TYPE    - A LOB (Large OBject) stores binary data up to 4 gigabytes in length.
			 The BLOB (Binary LOB) datatype stores unstructured binary large objects.
			 BLOBs can be thought of as bitstreams with no character set semantics.

<return: Symbol>
"
"
self symbolForOCIDataType:(self numericValueForInternalDataType:#'VARCHAR2_TYPE')
"

%{
    ub4 __attributetype = (ub4) __unsignedLongIntVal(anOCIDataType);

    switch (__attributetype)
    {
	case VARCHAR2_TYPE:
	    RETURN (@symbol(VARCHAR2_TYPE));
	    break;
	case NUMBER_TYPE:
	    RETURN (@symbol(NUMBER_TYPE));
	    break;
	case LONG_TYPE:
	    RETURN (@symbol(LONG_TYPE));
	    break;
	case ROWID_DESC_TYPE:
	    RETURN (@symbol(ROWID_DESC_TYPE));
	    break;
	case ROWID_TYPE:
	    RETURN (@symbol(ROWID_TYPE));
	    break;
	case DATE_TYPE:
	    RETURN (@symbol(DATE_TYPE));
	    break;
	case RAW_TYPE:
	    RETURN (@symbol(RAW_TYPE));
	    break;
	case LONG_RAW_TYPE:
	    RETURN (@symbol(LONG_RAW_TYPE));
	    break;
	case CHAR_TYPE:
	    RETURN (@symbol(CHAR_TYPE));
	    break;
	case REF_TYPE:
	    RETURN (@symbol(REF_TYPE));
	    break;
	case CHARACTER_LOB_TYPE:
	    RETURN (@symbol(CHARACTER_LOB_TYPE));
	    break;
	case BINARY_LOB_TYPE:
	    RETURN (@symbol(BINARY_LOB_TYPE));
	    break;
    }
%}.
    OCIUnhandledAttributeTypeError raiseErrorString:' - invalid datatype number'.
!

ub2Size
    "return the size of an Oracle ub2 c datatype (two byte unsigned value)

     <return: Integer>"
%{
    RETURN(__MKINT(sizeof(ub2)))
%}

"
  self ub2Size
"
!

valueTypeForAttribute:aSymbol
    "return a symbol denoting the type of an attribute"

    ^ AttributeTypes at:aSymbol
! !

!OCI8Handle class methodsFor:'error handling'!

exceptionForErrorStatus:statusSymbol code:errorCode
    "answer the Exception that is responsible for signalling the error
     with the OCI8 error code errorCode"

    |cls|

    errorCode = 1013 ifTrue:[
	cls := OCIUserInterruptError
    ] ifFalse:[errorCode = 3113 ifTrue:[
	cls := OCIEndOfCommunicationError
    ] ifFalse:[errorCode = 1010 ifTrue:[
	cls :=  OCIInvalidOperationError
    ] ifFalse:[errorCode = 1012 ifTrue:[
	cls :=  OCILogOnError
    ] ifFalse:[errorCode = 1033 ifTrue:[
	cls :=  OCILogOnError
    ] ifFalse:[errorCode = 1034 ifTrue:[
	cls :=  OCILogOnError
    ] ifFalse:[errorCode = 1089 ifTrue:[
	cls :=  OCILogOnError
    ] ifFalse:[errorCode = 1017 ifTrue:[
	cls :=  OCIInvalidUserParameterError
    ] ifFalse:[errorCode = 12154  ifTrue:[
	cls :=  OCIInvalidDatabaseParameterError
    ] ifFalse:[
	"this is the default"
	statusSymbol == OCI_SUCCESS_WITH_INFO ifTrue:[
	    cls :=  OCISuccessWithInfoSignal
	] ifFalse:[
	    cls :=  SQLError
	]
    ]]]]]]]]].

    ^ cls new errorCode:errorCode
! !

!OCI8Handle class methodsFor:'test'!

test
    "
     MessageTally spyDetailedOn:[
	 self test
     ]
    "

    |envHandle errorHandle serverHandle serviceHandle userSessionHandle x|

    envHandle := OCI8Handle newEnvironment:nil.
    10 timesRepeat:[
	    [
		errorHandle := envHandle newHandleWithType:#OCI8ErrorHandle.
		serverHandle := envHandle newHandleWithType:#OCI8ServerHandle.
		serviceHandle := envHandle newHandleWithType:#OCI8ServiceContextHandle.
		userSessionHandle := envHandle newHandleWithType:#OCI8UserSessionHandle.


		"unblock connection"
		serverHandle
		    setAttribute:#'OCI_ATTR_NONBLOCKING_MODE'
		    value:1
		    errorHandle:errorHandle.

		"connect server"
		serverHandle attach:'SECREC' errorHandle:errorHandle.
		serviceHandle
		    setAttribute:#'OCI_ATTR_SERVER'
		    value:serverHandle
		    errorHandle:errorHandle.
		"user session"
		userSessionHandle
		    setAttribute:#'OCI_ATTR_USERNAME'
		    value:'scott'
		    errorHandle:errorHandle.
		"set password attribute in user session handle"
		userSessionHandle
		    setAttribute:#'OCI_ATTR_PASSWORD'
		    value:'tiger'
		    errorHandle:errorHandle.
		x := serverHandle getAttribute:#'OCI_ATTR_NONBLOCKING_MODE'
			    errorHandle:errorHandle.
"/                self halt.


		"start session"
		serviceHandle
		    beginSession:userSessionHandle
		    credential:#'OCI_CRED_RDBMS'
		    mode:#'OCI_DEFAULT'
		    errorHandle:errorHandle.
		"set the user session in the service context"
		serviceHandle
		    setAttribute:#'OCI_ATTR_SESSION'
		    value:userSessionHandle
		    errorHandle:errorHandle
	    ] ensure:[
			"disconnect"
			SQLError handle:[:ex | ]
			    do:[serviceHandle endSession:userSessionHandle errorHandle:errorHandle].
			SQLError handle:[:ex | ]
			    do:[serverHandle detachWithErrorHandle:errorHandle]
		    ]
	].
    envHandle release
! !

!OCI8Handle class methodsFor:'testing'!

isAbstract
    self == OCI8Handle ifTrue:[^true].
    ^ super isAbstract
! !

!OCI8Handle methodsFor:'attributes'!

getAttribute:anAttributeTypeSymbol errorHandle:errorHandle

    ^ self getAttribute:anAttributeTypeSymbol into:nil errorHandle:errorHandle
!

getAttribute:anAttributeTypeSymbol into:aDescriptorOrNil errorHandle:errorHandle
    "get a particular attribute of a handle.

    Parameters:

	aTargetOCIHandle (IN)
	    Pointer to a handle type.

	anAttributeTypeSymbol (IN)
	    The type of attribute being retrieved.

	errorHandle (IN/OUT)
	    An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	    for diagnostic information in the event of an error.

    <return: self | String | Integer | ExternalAddress>
    "

    |aTypeInteger aValueType resultHolder statusSymbol|

    aTypeInteger := self class numericValueForAttribute:anAttributeTypeSymbol.
    aValueType := self class valueTypeForAttribute:anAttributeTypeSymbol.
    resultHolder := Array new:1.
    ^ self
	executePrimitive:[:errorHandle |
	    statusSymbol := self
			primGetAttribute:aTypeInteger
			valueType:aValueType
			into:aDescriptorOrNil
			errorHandle:errorHandle
			resultHolder:resultHolder.
	    statusSymbol == OCI_SUCCESS ifTrue:[
		aValueType == #ParameterDescriptor ifTrue:[ |parameterDescriptor|
		    parameterDescriptor := OCI8ParameterDescriptor newForEnvironment:environmentHandle.
		    parameterDescriptor handle:(resultHolder at:1).
		    ^ parameterDescriptor.
		] ifFalse:[
		    ^ resultHolder at:1.
		].
	    ].
	    statusSymbol
	]
	withErrorHandle:errorHandle.
!

getParameter:aPositionInteger errorHandle:errorHandle
    "
    returns a descriptor of a parameter specified by position in the describe handle
    or statement handle. Parameter descriptors are always allocated internally by the OCI library.
    They are read-only. An OCI8Handle with address 0 may be returned if there are no parameter
    descriptors for this position.

    Parameters:

	self (IN)
	     A statement handle or describe handle. The OCIParamGet() function will return a
	     parameter descriptor for this handle.

	aPositionInteger (IN)
	    Position number in the statement handle or describe handle. A parameter descriptor
	    will be returned for this position or an OCI8Handle with address 0 may be returned
	    if there are no parameter descriptors for this position.

	errorHandle (IN/OUT)
	    An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	    for diagnostic information in the event of an error.

    <return: self>
    "

    |newHandle resultStatus|

    newHandle := OCI8ParameterDescriptor newForEnvironment:environmentHandle.
    self executePrimitive:[:errorHandle|
	resultStatus := self primGetParameter:aPositionInteger
			     parameterDescriptorHandle:newHandle
			     errorHandle:errorHandle.
	(resultStatus == OCI_NO_DATA or:[resultStatus == OCI_SUCCESS]) ifTrue:[
	    newHandle registerChange.
	    ^ newHandle
	].
	resultStatus
    ] withErrorHandle:errorHandle.
!

primGetAttribute:anAttributeTypeInteger valueType:valueTypeSymbol into:aDescriptorOrNil
    errorHandle:anErrorHandle resultHolder:resultArray
    "get a particular attribute of a handle.

      Parameters:

	  anAttributeTypeInteger (IN)
	      The type of attribute being retrieved. Vaild types are:

		  OCI_ATTR_PARAM       - Points to the root of the description. Used for subsequent calls
					 to OCI8Lib>>ociAttrGet:attributeType:errorOCIHandle: and
					 OCI8Lib>>ociParamGet:position:errorOCIHandle:.

	  anErrorHandle (IN/OUT)
	      An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	      for diagnostic information in the event of an error.

	  resultArray (OUT)
	      An array of size > 0. The result of the operation is stored in the first element.

      Returns:
	  Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

      <return: Symbol>
    "

%{  /* UNLIMITEDSTACK */

    OBJ  __type = __OCINST(__qClass(self), ociTypeInteger);
    dvoid * __targethndlp = __INST(address_);
    OCIError * __errorhndlp;
    /*
     * To avoid misaligned-memory violations,
     * ensure that all of the attr-cells are aligned
     * to a long boundary
     */
    union {
	boolean boolean;
	ub1 ub1;
	ub2 ub2;
	ub4 ub4;
	sb1 sb1;
	sb2 sb2;
	sb4 sb4;
	text *text;
	dvoid *ptr;
	double *dbl;
    } __attr;
    ub4 __handletype;
    ub4 __attributetype;
    ub4 __attributesize = 0;
    sword __ret = -1;
    OBJ __retVal = nil;

    /* check if all attributes have correct type */
    if(__targethndlp == 0 || !__isOciErrorHandle(anErrorHandle) ||
       !__isSmallInteger(__type) || !__isInteger(anAttributeTypeInteger) ||
       !__isArray(resultArray) || __arraySize(resultArray) < 1
    ) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Lib [error]: OCIAttrGet called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }

    __errorhndlp  = (OCIError *) __externalAddressVal(anErrorHandle);
    __handletype = __smallIntegerVal(__type);
    __attributetype = (ub4) __unsignedLongIntVal(anAttributeTypeInteger);
    __attr.ub4 = 0;

    if (aDescriptorOrNil != nil) {
	if (!__isExternalAddressLike(aDescriptorOrNil)) {
	    RETURN(@global(ArgumentError));
	}
	__ret = OCIAttrGet( __targethndlp, __handletype, __externalAddressVal(aDescriptorOrNil),
			    0, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = aDescriptorOrNil;
	}
    } else if (valueTypeSymbol == @symbol(ExternalAddress)
	|| valueTypeSymbol == @symbol(ParameterDescriptor)) {
	__ret = OCIAttrGet( __targethndlp, __handletype, &__attr.ptr,
			    &__attributesize, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = __MKEXTERNALADDRESS(__attr.ptr);
	}
    } else if (valueTypeSymbol == @symbol(String)) {
	__ret = OCIAttrGet( __targethndlp, __handletype, &__attr.text,
			    &__attributesize, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = __MKSTRING_L(__attr.text,__attributesize);
	}
    } else if (valueTypeSymbol == @symbol(ub1)) {
	__ret = OCIAttrGet( __targethndlp, __handletype, &__attr.ub1,
			    &__attributesize, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = __mkSmallInteger(__attr.ub1);
	}
    } else if (valueTypeSymbol == @symbol(sb1)) {
	__ret = OCIAttrGet( __targethndlp, __handletype, &__attr.sb1,
			    &__attributesize, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = __mkSmallInteger(__attr.sb1);
	}
    } else if (valueTypeSymbol == @symbol(ub2)) {
	__ret = OCIAttrGet( __targethndlp, __handletype, &__attr.ub2,
			    &__attributesize, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = __mkSmallInteger(__attr.ub2);
	}
    } else if (valueTypeSymbol == @symbol(ub4)) {
	__ret = OCIAttrGet( __targethndlp, __handletype, &__attr.ub4,
			    &__attributesize, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = __MKUINT(__attr.ub4);
	}
    } else if (valueTypeSymbol == @symbol(ub4kludge)) {
	/*
	 * SOME CALLS ARE DOCUMENTED BY ORACLE TO RETURN ub4. THE SIZE RETURNED IS 4!
	 * BUT ub2 is returned!!!!!
	 */
	__ret = OCIAttrGet( __targethndlp, __handletype, &__attr.ub4,
			    &__attributesize, __attributetype, __errorhndlp);
	if (__ret == OCI_SUCCESS) {
	    __retVal = __mkSmallInteger(__attr.ub2);
	}
    } else {
	RETURN(@global(ArgumentError));
    }

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIAttrGet(%x) -> %u (size %d/4)\n", __targethndlp, __attr.ub4, __attributesize);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIAttrGet(%x) failed\n", __targethndlp);
	}
    }
    if (__ret == OCI_SUCCESS) {
	__ArrayInstPtr(resultArray)->a_element[0] = __retVal;
	__STORE(resultArray, __retVal);
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primGetParameter:aPositionInteger parameterDescriptorHandle:aParameterDescriptorHandle errorHandle:anErrorHandle
    "get a descriptor of a parameter specified by position in the describe handle
    or statement handle. Parameter descriptors are always allocated internally by the OCI library.
    They are read-only. An OCI8Handle with address 0 may be returned if there are no parameter
    descriptors for this position.

    Parameters:

	self (IN)
	    A statement handle or describe handle. The OCIParamGet() function will return a
	    parameter descriptor for this handle.

	aTypeInteger (IN)
	    The type of the handle passed in the handle parameter. Valid types are:

		#'OCI_DTYPE_PARM', for a parameter descriptor

		#'OCI_HTYPE_COR', for a complex object retrieval handle

		#'OCI_HTYPE_STMT', for a statement handle

	aPositionInteger (IN)
	    Position number in the statement handle or describe handle. A parameter descriptor
	    will be returned for this position or an OCI8Handle with address 0 may be returned
	    if there are no parameter descriptors for this position.

	aParameterDescriptorHandle parmdpp (OUT)
	    A descriptor of the parameter at the position given in the pos parameter.

	anErrorHandle (IN/OUT)
	    An error handle you can pass to OCI8Handle class>>errorStringForHandle:status:
	    for diagnostic information in the event of an error.

    Returns:
	Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

    <return: Symbol>
    "

%{  /* UNLIMITEDSTACK */

    OBJ  __type = __OCINST(__qClass(self), ociTypeInteger);
    dvoid * __hndlp = __INST(address_);
    dvoid * __paramdhndlp   = 0;
    OCIError * __errorhndlp;
    ub4 __pos;
    sword __ret;

    /* check if all attributes have correct type */
    if(__hndlp == 0 || !__isOciErrorHandle(anErrorHandle) ||
       !__isOciParameterDescriptor(aParameterDescriptorHandle) ||
       !__isSmallInteger(__type) || !__isInteger(aPositionInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIParamGet called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);
    __pos   = (ub4) __unsignedLongIntVal(aPositionInteger);

    __ret = OCIParamGet(__hndlp, (ub4)__smallIntegerVal(__type),
			__errorhndlp, &__paramdhndlp, __pos);
    if (__ret == OCI_SUCCESS) {
	__externalAddressVal(aParameterDescriptorHandle) = __paramdhndlp;
    }

    if (@global(Debugging) == true) {
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIParamGet(%x, %x) -> %x\n", __hndlp, __pos ,__paramdhndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIParamGet(%x, %x) failed\n", __hndlp, __pos);
	}
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primSetAttribute:anAttributeTypeInteger value:anAttribute errorHandle:anErrorHandle
    "set a particular attribute of a handle or a descriptor.

Parameters:

    self (IN/OUT)
	Pointer to a handle type whose attribute gets modified.

    anAttributeTypeInteger (IN)
	The type of attribute being set.

    anAttribute (IN)
	Pointer to an attribute value. The attribute value is copied into the target handle.
	If the attribute value is a pointer, then only the pointer is copied, not the contents of the pointer.

    anErrorHandle (IN/OUT)
	An error handle you can pass to OCI8Handle class>>errorStringForHandle:status:
	for diagnostic information in the event of an error.

Returns:
    Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

<return: Symbol>
"

%{  /* UNLIMITEDSTACK */

    OBJ  __type = __OCINST(__qClass(self), ociTypeInteger);
    dvoid * __targethndlp;
    OCIError * __errorhndlp;
    dvoid * __attributep = 0;
    ub4 __targettype;
    ub4 __attributetype;
    ub4 __attributesize = 0;
    sword __ret;
    ub4 __ub4Attr;

    /* check if all attributes have correct type */
    if(!__isOciErrorHandle(anErrorHandle) ||
       !__isSmallInteger(__type) || !__isInteger(anAttributeTypeInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIAttrSet called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    __targethndlp   = (dvoid *) __INST(address_);
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);
    __targettype    = (ub4) __smallIntegerVal(__type);
    __attributetype = (ub4) __unsignedLongIntVal(anAttributeTypeInteger);

    if (__isString(anAttribute)) {
	__attributesize  = __stringSize(anAttribute);
	__attributep = __stringVal(anAttribute);
    }
    else if (__isByteArray(anAttribute)) {
	__attributesize  = __byteArraySize(anAttribute);
	__attributep = __ByteArrayInstPtr(anAttribute)->ba_element;
    }
    else if (__isExternalBytes(anAttribute)) {
	__attributesize  = __intVal(__externalBytesSize(anAttribute));
	__attributep = __externalBytesAddress(anAttribute);
    }
    else if (__isOciHandle(anAttribute)) {
	__attributesize = 0;
	__attributep = __externalAddressVal(anAttribute);
    }
    else if (__isSmallInteger(anAttribute)) {
	__attributesize  = sizeof(ub4);
	__attributep = &__ub4Attr;
	__ub4Attr = __intVal(anAttribute);
    }
    else if (__isArray(anAttribute) && __arraySize(anAttribute) == 3) {
	/* This is an XID (Transaction id) */
	OBJ __format = __ArrayInstPtr(anAttribute)->a_element[0];
	OBJ __gtrid  = __ArrayInstPtr(anAttribute)->a_element[1];
	OBJ __bqual  = __ArrayInstPtr(anAttribute)->a_element[2];

	XID __xid;

	if (!__isInteger(__format) || !__isByteArray(__gtrid) || !__isByteArray(__bqual))
	    RETURN(@global(AttributeError));

	__xid.formatID = __unsignedLongIntVal(__format);
	__xid.gtrid_length = __byteArraySize(__gtrid);
	__xid.bqual_length = __byteArraySize(__bqual);

	if (__xid.gtrid_length > 64 ||  __xid.bqual_length > 64)
	    RETURN(@global(AttributeError));

	memcpy(__xid.data, __byteArrayVal(__gtrid), __xid.gtrid_length);
	memcpy(__xid.data+__xid.gtrid_length, __byteArrayVal(__bqual), __xid.bqual_length);


	__attributesize  = sizeof(__xid);
	__attributep = &__xid;
    }
    else {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [warning]: OCIAttrSet attribute must be a string, byte array, external bytes, external address or small integer object\n");
	}
	RETURN(@global(AttributeError));
    };

    __ret = OCIAttrSet( __targethndlp, __targettype, __attributep, __attributesize,
			__attributetype, __errorhndlp);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIAttrSet(%x, %d, %x, %d, %d)\n", __targethndlp, __targettype,  __attributep, __attributetype, __attributesize);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIAttrSet(%x, %d, %x, %d, %d) failed\n", __targethndlp, __targettype,  __attributep, __attributetype, __attributesize);
	}
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

setAttribute:anAttributeTypeSymbol  value:anAttribute errorHandle:errorHandle
    "set a particular attribute of a handle or a descriptor.

Parameters:

    self (IN/OUT)
	Pointer to a handle type whose attribute gets modified.

    anAttribute (IN)
	Pointer to an attribute value. The attribute value is copied into the target handle.
	If the attribute value is a pointer, then only the pointer is copied, not the contents of the pointer.

    anAttributeTypeSymbol (IN)
	The type of attribute being set.

    errorHandle (IN/OUT)
	An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	for diagnostic information in the event of an error.

<return: self>
"

    self executePrimitive:[:errorHandle |
	    self
		primSetAttribute:(self class numericValueForAttribute:anAttributeTypeSymbol)
		value:anAttribute
		errorHandle:errorHandle
	]
	withErrorHandle:errorHandle
! !

!OCI8Handle methodsFor:'execution'!

executePrimitive:aBlock withErrorHandle:errorHandleIn
    "
     evaluates aBlock after obtaining the execution log.
     The block is repeatently evaluated as long as the result status indicates that the
     operation is still executing.
     This is necessary because the oci lib is driven in non blocking mode.
     Between two block evaluations wait some time.
     TODO: This should be implemented as exponential backoff!!

     If the result does not indicate a successfull operation, raise a signal.
     anErrorHandle is used to retrieve the error in this case.

     <return: Symbol>
    "

    |errorHandle statusSymbol lock loop pollCount|

    "if no errorHandle present, supply one"
    errorHandleIn isNil ifTrue:[
	"no error handle used when operating on environment handle (self)"
	environmentHandle ~~ self ifTrue:[
	    errorHandle := environmentHandle newHandleWithType:#OCI8ErrorHandle.
	].
    ] ifFalse:[
	errorHandle := errorHandleIn.
    ].

    loop := true.
    pollCount := 1.

    [
	lock := ExecutionLock wait.
	[
	    statusSymbol := aBlock value:errorHandle.
	    statusSymbol == OCI_ERROR ifTrue:[
		"this usually raises an error. Some errors may be converted"
		statusSymbol := self handleError:statusSymbol errorHandle:errorHandle.
	    ].
	    statusSymbol == OCI_STILL_EXECUTING ifTrue:[
		"wait a bit an poll the operation status by calling
		 the operation with exactly the same arguments"
		self pollWait:pollCount.
		pollCount := pollCount+1.
	    ] ifFalse:[statusSymbol == OCI_NEED_DATA ifTrue:[
		"there are some dynamic bind/describe variables but
		 callback functions haven't been defined for them.
		 #needData can provide the data buffers and the operation
		 may be retried"
		self needData.
	    ] ifFalse:[
		"error or success"
		loop := false.
	    ]].
	] doWhile:[loop].
    ] ifCurtailed:[
	(statusSymbol == OCI_STILL_EXECUTING
	 or:[statusSymbol == OCI_NEED_DATA]) ifTrue:[
	    "the asynchronous operation has been aborted.
	     Inform OCI and reset the handle"
	    self breakAsyncOperationWithErrorHandle:errorHandle.
	    self resetAsyncOperationWithErrorHandle:errorHandle.
	].
	lock notNil ifTrue:[
	    ExecutionLock signal.
	].
	"release locally allocated errorHandle"
	errorHandleIn isNil ifTrue:[
	    errorHandle release.
	].
    ].

    ExecutionLock signal.
    "release locally allocated errorHandle"
    statusSymbol ~~ OCI_SUCCESS ifTrue:[
	[
	    self handleError:statusSymbol errorHandle:errorHandle.
	] ifCurtailed:[
	    errorHandleIn isNil ifTrue:[
		errorHandle release.
	    ].
	]
    ].
    errorHandleIn isNil ifTrue:[
	errorHandle release.
    ].
    ^ statusSymbol
!

handleError:ociReturnStatus errorHandle:errorHandle
    "handle errors from oci operations.

     aStatusSymbol  <Symbol>                returned by OCI primitive operations
					    (OCI_SUCCESS, OCI_ERROR, OCI_INVALID_HANDLE ...)
     errorHandle    <nil|errorHandle>       used to retrieve the error code and description.
    "


    ociReturnStatus == OCI_SUCCESS ifTrue:[
	"all is well"
	^ ociReturnStatus.
    ].

    "OCI Errors"
    (ociReturnStatus == OCI_ERROR
     or:[ociReturnStatus == OCI_SUCCESS_WITH_INFO]) ifTrue:[
	|errorCode textHolder errorText exception|

	(errorHandle isNil or:[errorHandle isValid not]) ifTrue:[
	    errorCode := nil.
	    errorText := ' got ', ociReturnStatus asString, ' without error handle'.
	] ifFalse:[
	    errorCode := errorHandle getErrorCodeWithErrorTextHolder:(textHolder := Array new:1)
			    recordNumber:1.
	    errorCode == 3123 ifTrue:[
		"beginSession results in OCI_ERROR with ORA-03123 instead of OCI_STILL_EXECUTING"
		^ OCI_STILL_EXECUTING
	    ].
	    errorText := textHolder at:1.
	].
	errorCode isSymbol ifTrue:[
	    "error when retrieving errorCode from errorHandle"
	    errorText := ' error while retrieving errorCode from error handle: ', errorCode.
	].
	exception := self class exceptionForErrorStatus:ociReturnStatus code:errorCode.
	errorText size > 0 ifTrue:[
	    exception messageText:errorText.
	].

	ociReturnStatus == OCI_SUCCESS_WITH_INFO ifTrue:[
	    "success exceptions are proceedable"
	    exception raiseRequest.
	    ^ ociReturnStatus.
	] ifFalse:[
	    exception raise.
	].
    ].

    "special return codes"
    ociReturnStatus == OCI_NO_DATA ifTrue:[
	"the command returns no data"
	OCINoDataError raiseRequest.
    ].
    ociReturnStatus == OCI_INVALID_HANDLE ifTrue:[
	"the handle supplied is invalid"
	OCIInvalidHandleError raise.
    ].
    ociReturnStatus == OCI_CONTINUE ifTrue:[
	OCIContinueSignal raiseRequest.
    ].

    "the next 2 statusSymbols should be catched by the sender"
    ociReturnStatus == OCI_STILL_EXECUTING ifTrue:[
	"commond is executed, poll for status"
	SQLError raiseRequestWith:ociReturnStatus.
    ].
    ociReturnStatus == OCI_NEED_DATA ifTrue:[
	"need data (pieces)"
	SQLError raiseRequestWith:ociReturnStatus.
    ].

    "ST/X Errors"
    ociReturnStatus == AttributeError ifTrue:[
	SQLError raiseErrorString:' - invalid attribute in primitive'.
    ].
    ociReturnStatus == ArgumentError ifTrue:[
	"bad argument to primitive call"
	Smalltalk::ArgumentError raise.
    ].
    ociReturnStatus == MallocError ifTrue:[
	"failed to allocate data"
	MallocFailure raise.
    ].
    SQLError raiseErrorString:' - unexepected status: ', ociReturnStatus asString.
    ^ ociReturnStatus.
!

pollWait:pollCount
    "wait some time before doing the next poll.
     Pollcount counts the number of polls already done
     for this operation"

    PollDelay wait
! !

!OCI8Handle methodsFor:'handle allocation & release'!

primInitializeHandleWithParent:parentHandle
    "
      sets a pointer to an allocated and initialized handle, corresponding to the type specified in aTypeSymbol.
      A non-nil handle is returned on success. All handles are allocated with respect to an environment handle
      which is passed in as a parent handle. No diagnostics are available on error.
      Handles must be allocated using this method before they can be passed into an OCI call.
      To allocate and initialize an environment handle, call OCI8Handle>>ociEnvCreate:mode:.

      Parameters:

	  aTypeInteger (IN)
	      Specifies the type of handle to be allocated.

      Returns:
	  Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

      <return: Symbol>
    "

%{  /* UNLIMITEDSTACK */

    OBJ   __type = __OCINST(__qClass(self), ociTypeInteger);
    dvoid * __parenthndlp;
    dvoid * __hndlp;
    sword __ret;

    /* check if all attributes have correct type */
    if (!__isOciHandle(parentHandle) ||
	!__isInteger(__type)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIHandleAlloc called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    __parenthndlp = __externalAddressVal(parentHandle);

    __ret = OCIHandleAlloc(__parenthndlp, &__hndlp, (ub4) __smallIntegerVal(__type), (size_t) 0, (dvoid **) 0);
    if (__ret == OCI_SUCCESS) {
	__INST(address_) = __hndlp;
    }

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIHandleAlloc(%x, %d) -> %x\n", __parenthndlp, __smallIntegerVal(__type), __hndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIHandleAlloc(%x, %d) failed\n", __parenthndlp, __smallIntegerVal(__type));
	}
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primRelease
    "free up storage associated with a handle.
     All handles may be explicitly deallocated.
     OCI will deallocate all child handle if the parent is deallocated.

      Return:
	  Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

      <return: Symbol>"

%{  /* UNLIMITEDSTACK */

    OBJ   __type    = __OCINST(__qClass(self), ociTypeInteger);
    OBJ   __address = __INST(address_);
    sword __ret;


    /* check if all attributes have correct type */
    if (__address == 0) {
	/* parent handle is uninitialized or invalidated,
	   nothing to be done */
	RETURN(@global(OCI_SUCCESS));
    }
    if (!__isSmallInteger(__type)) {
	RETURN(@global(InvalidType));
    }

    __ret = OCIHandleFree(__address, (ub4) __smallIntegerVal(__type));


    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIHandleFree(%d, %x)\n", __address);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIHandleFree(%d %x) failed\n", __address);
	}
    }

    if (__ret == OCI_SUCCESS) {
	__INST(address_) = 0;
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

releaseSubhandlesBeforeRelease
    "db libraries which deallocate all child handles when their parent handle
     is deallocated should redefine this to invalidate subhandles (OCI).
     Those which do not, should relsease subhandles here (ODBC)."

    "OCI: releasing a handle implicitely releases all subhandles"
    self invalidateSubhandles
! !

!OCI8Handle methodsFor:'primitives'!

breakAsyncOperationWithErrorHandle:anErrorHandle
"
performs an immediate (asynchronous) abort of any currently executing OCI function that is
associated with a server. It is normally used to stop a long-running OCI call being processed
on the server. This call can take either the service context handle or the server context handle
as a parameter to identify the function to be aborted.

Parameters:

    self (IN)
	The service context handle or the server context handle.

    anOCI8ErrorHandle (IN/OUT)
	An error handle you can pass to OCI8Handle class>>errorStringForHandle:status:
	for diagnostic information in the event of an error.

Returns:
    Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

<return: Symbol>
"

%{  /* UNLIMITEDSTACK */

    OCIError * __errorhndlp;
    dvoid * __hndlp = __INST(address_);
    sword __ret;

    /* check if all attributes have correct type */
    if (__hndlp == 0 || !__isOciErrorHandle(anErrorHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIBreak called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);

    __ret = OCIBreak(__hndlp, __errorhndlp);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIBreak(%x)\n", __hndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIBreak(%x) failed\n", __hndlp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

resetAsyncOperationWithErrorHandle:anErrorHandle
"
resets the interrupted asynchronous operation and protocol. Must be called if a
OCI8Handle>>ociBreak:errorOCIHandle: call had been issued while a non-blocking operation
was in progress. This call is called in non-blocking mode ONLY.

Parameters:

    self (IN)
	The service context handle or the server context handle.

    anOCI8ErrorHandle (IN/OUT)
	An error handle you can pass to OCI8Handle class>>errorStringForHandle:status:
	for diagnostic information in the event of an error.

Returns:
    Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

<return: Symbol>
"

%{  /* UNLIMITEDSTACK */

    OCIError * __errorhndlp;
    dvoid * __hndlp = __INST(address_);
    sword __ret;

    /* check if all attributes have correct type */
    if(__hndlp == 0 || !__isOciErrorHandle(anErrorHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIReset called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);

    __ret = OCIReset(__hndlp, __errorhndlp);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIReset(%x)\n", __hndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIReset(%x) failed\n", __hndlp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle methodsFor:'queries'!

isValid
    "a handle is valid when his address is not 0
    <return: Boolean>"

    ^ self address ~~ 0
! !

!OCI8Handle methodsFor:'subclass responsibility'!

needData
    "got OCI_NEED_DATA status code.
     This can happen only on OCI8StatementHandle"

    self subclassResponsibility
! !

!OCI8Handle::OCI8VariableHandle class methodsFor:'documentation'!

documentation
"
    OCI8VariableHandle is an abstract superclass of both bind dand define handles.
    It knows about pieces (dynamic data), and implements fetching of new pieces.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]
	variable        The variable, which provides pieces (dynamic data).

    [class variables:]
"
! !

!OCI8Handle::OCI8VariableHandle class methodsFor:'testing'!

isAbstract
    ^ self == SQL::OCI8Handle::OCI8VariableHandle
! !

!OCI8Handle::OCI8VariableHandle methodsFor:'dynamic data'!

needData:pieceInfoArray errorHandle:errorHandle
    "a statement needs dynamic data
#define OCI_ONE_PIECE 0                                         /* one piece */
#define OCI_FIRST_PIECE 1                                 /* the first piece */
#define OCI_NEXT_PIECE 2                          /* the next of many pieces */
#define OCI_LAST_PIECE 3                                   /* the last piece */

"

    |handleType pieceType dataIn index externalBuffer pieceLength|

    handleType := pieceInfoArray at:2.
    dataIn := pieceInfoArray at:3.
    index := pieceInfoArray at:5.
    pieceType := pieceInfoArray at:6.

    dataIn ifTrue:[
	pieceLength := self getNextPieceForIndex:index.
    ].

    self setPieceInfo:handleType
	 buffer:externalBuffer length:pieceLength pieceType:pieceType errorHandle:errorHandle
! !

!OCI8Handle::OCI8VariableHandle methodsFor:'primitives'!

bind:nameOrPos
    statementHandle:aStatementHandle
    errorHandle:errorHandle
    elementSize:elementSize                  "maximum size of a single value"
    mode:aModeSymbol                         "may be #OCI_DATA_AT_EXEC"
    dataType:aDataTypeInteger                "OCI C-Datatype of buffer"
    dataBuffer:aDataBuffer                   "data buffer, nil if dynamic bind"
    numberOfElements:numberOfElements        "number of values in buffer, nil if dynamic bind"
    controlData:controlData                  "nil if dynamic bind"
    "
    performs a basic bind operation. The bind creates an association between the address
    of a program variable and a placeholder/position in a SQL statement or PL/SQL block.
    The bind call also specifies the type of data which is being bound, and may
    also indicate the method by which data will be provided at runtime.

    This function implicitly allocates the bind handle indicated by the bindpp parameter.
    If a non-NULL pointer is passed in **bindpp, the OCI assumes that this points
    to a valid handle that has been previously allocated with a call to
    OCI8Lib>>ociHandleAlloc:type: or this method.

    Data in an OCI application can be bound to placeholders statically or dynamically.
    Binding is static when all the IN bind data and the OUT bind buffers are well-defined
    just before the execute.
    Binding is dynamic when the IN bind data and the OUT bind buffers are provided
    to the client library by the application on demand at execute time. Dynamic binding
    is indicated by setting the mode parameter of this call to OCI_DATA_AT_EXEC.

    This method take as parameter a bind handle, which is implicitly allocated by the
    bind call. A separate bind handle is allocated for each placeholder
    the application is binding.

    Additional bind calls may be required to specify particular attributes necessary
    when binding certain data types or handling input data in certain ways:

	If data is being provided dynamically at runtime, and the application will be
	using user-defined callback functions,
		OCI8Lib>>ociBindDynamic:callBackData:errorHandle:
	must be called to register the callbacks.

	If a statement with RETURNING clause is used, a call to
		OCI8Lib>>ociBindDynamic:callBackData:errorHandle:
	must follow this call.

    Parameters:

	statementHandle (IN/OUT)
	    The statement handle to the SQL or PL/SQL statement being processed.

	self (IN/OUT)
	    An address of a bind handle which is implicitly allocated by this call.
	    The bind handle maintains all the bind information for this particular
	    input value. The handle is freed implicitly when the statement handle
	    is deallocated. On input, the value of the pointer must be NULL or
	    a valid bind handle.

	aCType (IN)
	    The data type of the value(s) being bound.

	externalBytes (IN/OUT)
	    An address of a data value or an array of data values of the type specified
	    in the aCType parameter. An array of data values can be specified for
	    mapping into a PL/SQL table or for providing data for SQL multiple-row
	    operations. When an array of bind values is provided, this is called an
	    array bind in OCI terms.
	    If the #'OCI_ATTR_CHARSET_ID' is attribute is set to #'OCI_UCS2ID' (Unicode),
	    all data passed to and received with the corresponding bind call is
	    assumed to be in UCS-2 encoding.

	aBufferSize (IN)
	    The size of a data value. In the case of an array bind, this is the
	    maximum size of any element possible with the actual sizes being specified
	    in the alenp parameter. For descriptors, locators, or REFs, whose size is
	    unknown to client applications use the size of the structure you are
	    passing in; e.g., sizeof (OCILobLocator *).

	aNameOrPos (IN)
	    either a String|Symbol:
		The placeholder attributes are specified by name aName (OCIBindByByName).
	    or a Integer:
		The position to bind to (OCIBindByPos|OCIDefine) .

	aNullValueIndicator (IN/OUT)
	    Pointer to an indicator variable or array. For all data types except SQLT_NTY,
	    this is a pointer to sb2 or an array of sb2s.
	    This parameter is ignored for dynamic binds.

	anElementLenghtArray (IN/OUT)
	    Pointer to array of actual lengths of array elements.
	    Each element in alenp is the length of the data in the corresponding
	    element in the bind value array before and after the execute.
	    This parameter is ignored for dynamic binds.

	aReturnCodeArray (OUT)
	    Pointer to array of column level return codes.
	    This parameter is ignored for dynamic binds.

	aModeSymbol (IN)
	    The valid modes for this parameter are:

		#'OCI_DEFAULT'      - This is default mode.
		#'OCI_DATA_AT_EXEC' - When this mode is selected, the value_sz parameter
				      defines the maximum size of the data that can be
				      ever provided at runtime. The application must be
				      ready to provide the OCI library runtime IN data
				      buffers at any time and any number of times.
				      Runtime data is provided in one of the two ways:

				      1) callbacks using a user-defined function which
					 must be registered with a subsequent call to
					 OCI8Lib>>ociBindDynamic:callBackData:errorHandle:.

				      2) a polling mechanism using calls supplied by the OCI.
					 This mode is assumed if no callbacks are defined.

				      When the allocated buffers are not required any more,
				      they should be freed by the client.

	errorHandle (IN/OUT)
	    An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	    for diagnostic information in the event of an error.

    <return: self>
    "

    |result|

    parentHandle := aStatementHandle.
    environmentHandle := aStatementHandle environmentHandle.
    result := self executePrimitive:[:errorHandle|
	self primBind:nameOrPos
	    statementHandle:aStatementHandle
	    errorHandle:errorHandle
	    elementSize:elementSize
	    mode:(self class numericValueForBindMode:aModeSymbol)
	    dataType:aDataTypeInteger
	    dataBuffer:aDataBuffer
	    numberOfElements:numberOfElements
	    controlData:controlData
    ] withErrorHandle:errorHandle.

    "the handle has been set, register the change"
    self registerChange.

    ^ result.
!

bindLate:nameOrPos
    statementHandle:aStatementHandle
    errorHandle:anErrorHandle
    elementSize:elementSize                  "maximum size of a single value"
    dataType:aDataTypeInteger

    "late binding, data buffers are supplied at execution time via callbacks"

    |result|

    parentHandle := aStatementHandle.
    environmentHandle := aStatementHandle environmentHandle.
    result := self executePrimitive:[:errorHandle|
	self primBind:nameOrPos
		statementHandle:aStatementHandle
		errorHandle:anErrorHandle
		elementSize:elementSize
		mode:#DATA_AT_EXEC
		dataType:aDataTypeInteger
		dataBuffer:nil
		numberOfElements:nil
		controlData:nil
    ] withErrorHandle:anErrorHandle.

    "the handle has been set, register the change"
    self registerChange.

    ^ result.
!

primBind:nameOrPos
	    statementHandle:aStatementHandle
	    errorHandle:errorHandle
	    elementSize:elementSize
	    mode:aModeSymbol
	    dataType:aDataTypeInteger
	    dataBuffer:aDataBuffer
	    numberOfElements:numberOfElements
	    controlData:controlDataBuffer

    ^ self subclassResponsibility
!

setPieceInfo:handleType buffer:anExternalBuffer length:pieceLength pieceType:pieceSymbol errorHandle:errorHandle
   "set the information about the next piece"

%{  /* UNLIMITEDSTACK */

    OCIError * __errorp;
    dvoid * __hndlp = __INST(address_);
    ub4 __handleType;
    ub1 __piece;
    ub2 __rcodep = 0;
    ub4 __buf_size;
    dvoid * __buf;
    sword __ret;

    /* check if all attributes have correct type */
    if(__hndlp == 0 || !__isOciErrorHandle(errorHandle) || !__isInteger(handleType) ||
       !__isInteger(pieceLength) || !__isExternalBytes(anExternalBuffer)
    ) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIPiecewiseFetch called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }

    if (pieceSymbol == @symbol(OCI_ONE_PIECE))
	__piece = OCI_ONE_PIECE;
    else if (pieceSymbol == @symbol(OCI_FIRST_PIECE))
	__piece = OCI_FIRST_PIECE;
    else if (pieceSymbol == @symbol(OCI_NEXT_PIECE))
	__piece = OCI_NEXT_PIECE;
    else if (pieceSymbol == @symbol(OCI_LAST_PIECE))
	__piece = OCI_LAST_PIECE;
    else RETURN(@global(ArgumentError));

    __errorp   = (OCIError *) __externalAddressVal(errorHandle);
    __buf_size = __unsignedLongIntVal(pieceLength);
    __handleType = __unsignedLongIntVal(handleType);

    __ret = OCIStmtSetPieceInfo(__hndlp, __handleType, __errorp, __buf, &__buf_size, __piece, 0, &__rcodep);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	   fprintf(stderr, "OCI8Handle [info]: OCIStmtSetPieceInfo(%x , %x, %x, %d)\n", __hndlp, __handleType, __piece, __buf_size);
	} else {
	   fprintf(stderr, "OCI8Handle [warning]: OCIStmtSetPieceInfo(%x , %x, %x, %d) failed\n", __hndlp, __handleType, __piece, __buf_size);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8VariableHandle methodsFor:'releasing'!

finalize
    "variable handles are released implicitly when the statement handle
     is released or when a new statement is prepared on a statement handle.

     nothing to be done here"

    ^ self
!

release
    "variable handles are released implicitly when the statement handle
     is released or when a new statement is prepared on a statement handle.

     So only set the address to 0 here"

    self setAddress:0.
    parentHandle notNil ifTrue:[
	"if we have a parent, unregister from the parent"
	parentHandle unregister:self.
    ].
    environmentHandle := nil.
! !

!OCI8Handle::OCI8DefineHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_DEFINE));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8DefineHandle class methodsFor:'documentation'!

documentation
"
    Fetched data returned by a query is converted and stored according to the specifications of
    the define handles. The OCI library allocates a define handle for each output variable
    defined with OCIDefineByPos(). The user does not need to allocate define handles. They
    are implicitly allocated by the define call.

    Bind and define handles are freed when the statement handle is freed or when a statement
    is prepared on the statement handle.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8DefineHandle methodsFor:'primitives'!

primBind:position
    statementHandle:aStatementHandle
    errorHandle:anErrorHandle
    elementSize:elementSize                  "maximum size of a single value"
    mode:aModeInteger                        "may be OCI_DATA_AT_EXEC"
    dataType:aDataTypeInteger                "OCI C-Datatype of buffer"
    dataBuffer:aDataBuffer                   "data buffer, nil if dynamic bind"
    numberOfElements:numberOfElements        "number of values in buffer, nil if dynamic bind"
    controlData:controlData                  "nil if dynamic bind"

    "
	Returns:
	    Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

	<return: Symbol>
    "

%{  /* UNLIMITEDSTACK */

    OCIDefine * __bindpp = (OCIDefine *)__INST(address_);
    OCIStmt * __stmtp;
    OCIError * __errorp;
    dvoid * __valuep  = 0;
    sb2 * __indicatorp = 0;
    ub2 * __elementlengthp = 0;
    ub2 * __returncodep = 0;
    int __numberOfElements;
    text *__name;
    sb4 __namelen;
    sb4 __value_sz = 0;
    ub2 __datatype;
    ub4 __mode;
    sword __ret;

    /* check if all attributes have correct type */
    if(!__isOciStatementHandle(aStatementHandle) || !__isOciErrorHandle(anErrorHandle) ||
       !__bothSmallInteger(position, aDataTypeInteger) || !__isInteger(aModeInteger)) {
	__ociDebugBreakPoint__();
	RETURN(@global(ArgumentError));
    }
    if (!__isSmallInteger(elementSize)) {
	__ociDebugBreakPoint__();
	RETURN(@global(ArgumentError));
    }
    __value_sz = __smallIntegerVal(elementSize);

    if (aDataBuffer != nil) {
	/* Databuffer supplied, so this is not an dynamic bind */
	if (! __isExternalBytes(aDataBuffer)) {
	    __ociDebugBreakPoint__();
	    RETURN(@global(ArgumentError));
	}
	if (!__isSmallInteger(numberOfElements)) {
	    __ociDebugBreakPoint__();
	    RETURN(@global(ArgumentError));
	}
	__numberOfElements = __smallIntegerVal(numberOfElements);
	if (__smallIntegerVal(__externalBytesSize(aDataBuffer)) < __value_sz*__numberOfElements) {
	    __ociDebugBreakPoint__();
	    RETURN(@global(ArgumentError));
	}
	__valuep = (dvoid *)__externalBytesAddress(aDataBuffer);

	if (!__isSmallInteger(numberOfElements)) {
	    __ociDebugBreakPoint__();
	    RETURN(@global(ArgumentError));
	}
	__numberOfElements = __smallIntegerVal(numberOfElements);

	if (! __isExternalBytes(controlData)) {
	    __ociDebugBreakPoint__();
	    RETURN(@global(ArgumentError));
	}
	if (__smallIntegerVal(__externalBytesSize(controlData)) != (sizeof(sb2)+ 2*sizeof(ub2))*__numberOfElements) {
	    __ociDebugBreakPoint__();
	    RETURN(@global(ArgumentError));
	}
	__indicatorp = (sb2 *) __externalBytesAddress(controlData);
	__elementlengthp = (ub2 *) __indicatorp + __numberOfElements;
//        __returncodep = __elementlengthp + __numberOfElements;
    }

    __stmtp    = (OCIStmt *) __externalAddressVal(aStatementHandle);
    __errorp   = (OCIError *) __externalAddressVal(anErrorHandle);
    __datatype = (ub2) __smallIntegerVal(aDataTypeInteger);
    __mode = (ub4) __longIntVal(aModeInteger);

    __ret = OCIDefineByPos(__stmtp, &__bindpp, __errorp, __smallIntegerVal(position),
			   __valuep, __value_sz, __datatype, __indicatorp,
			   __elementlengthp, __returncodep, __mode);


    if (__ret == OCI_SUCCESS) {
	__INST(address_) = (OBJ)__bindpp;
    }

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIDefine(%x, %d, %d) -> %x\n", __stmtp, __datatype, __value_sz, __bindpp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIDefine(%x, %d, %d) failed\n", __stmtp, __value_sz, __datatype);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8DescribeHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_DESCRIBE));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8DescribeHandle class methodsFor:'documentation'!

documentation
"
    The describe handle is used by the OCI describe call, OCIDescribeAny(). This call obtains
    information about schema objects in a database (e.g., functions, procedures). The call takes
    a describe handle as one of its parameters, along with information about the object being
    described. When the call completes, the describe handle is populated with information
    about the object. The OCI application can then obtain describe information through the
    attributes of parameter descriptors.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8DescribeHandle methodsFor:'primitives'!

describe:aSchemaString type:aSchemaTypeSymbol serviceContextHandle:aServiceHandle errorHandle:anErrorHandle
    "describes existing schema objects: tables, views, synonyms, procedures, functions,
     packages, sequences, types, schemas, and databases. This call also describes
     sub-schema objects, such as a column in a table. This call populates the
     describe handle with the object-specific attributes which can be obtained through an
     OCI8Lib>>ociAttrGet:attributeType:errorOCIHandle: call.

     An OCI8Lib>>ociParamGet:position:errorOCIHandle: on the describe handle returns
     a parameter descriptor for a specified position. Parameter positions begin with 1.
     Calling OCI8Lib>>ociAttrGet:attributeType:errorOCIHandle: on the parameter
     descriptor returns the specific attributes of a stored procedure or function parameter,
     or a table column descriptor. These subsequent calls do not need an extra
     round trip to the server because the entire schema object description is cached on
     the client side by this method.
     Calling OCI8Lib>>ociAttrGet:attributeType:errorOCIHandle: on the describe handle
     also returns the total number of positions.

     If the #'OCI_ATTR_DESC_PUBLIC' attribute is set on the describe handle, then the
     object named is looked up as a public synonym when the object does not exist in the
     current schema and only <name1> is specified.

     Parameters:

	 self (IN/OUT)
	     A describe handle that is populated with describe information about the
	     object after the call.
	     Must be non-NULL.

	 aServiceHandle (IN)
	     A service context handle.

	 aSchemaString (IN)
	     A string containing the name of the object to be described.  The string
	     should be in the format <name1>[.<name2>.<name3>...][@<linkname>],
	     such as scott.emp.empno@mydb. Database links are only allowed to Oracle8i
	     databases. The object name is interpreted by the following SQL rules:

		 1) If only <name1> is entered and objtyp is equal to #'OCI_PTYPE_SCHEMA',
		    then the name refers to the named schema. The Oracle database
		    must be release 8.1 or greater.

		 2) If only <name1> is entered and objtyp is equal to #'OCI_PTYPE_DATABASE',
		    then the name refers to the named database. When describing a remote
		    database with database_name@db_link_name, the remote Oracle database
		    must be release 8.1 or greater.

		 3) If only <name1> is entered and objtyp is not equal to
		    #'OCI_PTYPE_SCHEMA' or #'OCI_PTYPE_DATABASE',
		    then the name refers to the named object (of type table / view /
		    procedure / function / package / type / synonym / sequence) in the
		    current schema of the current user. When connected to an Oracle7
		    Server, the only valid types are procedure and function.

		 4) If <name1>.<name2>.<name3>... is entered, the object name refers
		    to a schema/sub-schema object in the schema named <name1>. For example,
		    in the string scott.emp.deptno, scott is the name of the schema,
		    emp is the name of a table in the schema, and deptno is the name of
		    a column in the table.

	 aSchemaTypeInteger (IN/OUT)
	     The type of schema object being described. Valid values are:

		     1) OCI_PTYPE_TABLE, for tables
		     2) OCI_PTYPE_VIEW, for views
		     3) OCI_PTYPE_PROC, for procedures
		     4) OCI_PTYPE_FUNC, for functions
		     5) OCI_PTYPE_PKG, for packages
		     6) OCI_PTYPE_TYPE, for types
		     7) OCI_PTYPE_SYN, for synonyms
		     8) OCI_PTYPE_SEQ, for sequences
		     9) OCI_PTYPE_SCHEMA, for schemas
		     10) OCI_PTYPE_DATABASE, for databases
		     11) OCI_PTYPE_UNK, for unknown schema objects

	      A value for this argument must be specified. If OCI_PTYPE_UNK is specified,
	      then the description of an object with the specified name in the current
	      schema is returned, if such an object exists, along with the actual
	      type of the object.

	 anErrorHandle (IN/OUT)
	     An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	     for diagnostic information in the event of an error.

     <return: self>
    "

    self executePrimitive:[:errorHandle|
	self primDescribe:aSchemaString type:(self class numericValueForSchemaTypes:aSchemaTypeSymbol)
	     serviceContextHandle:aServiceHandle errorHandle:errorHandle
    ] withErrorHandle:anErrorHandle
!

primDescribe:aSchemaString type:aSchemaTypeInteger serviceContextHandle:aServiceHandle errorHandle:anErrorHandle
    "Returns:
	  Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

      <return: Symbol>"

%{  /* UNLIMITEDSTACK */

    OCIDescribe * __describep = (OCIDescribe *)__INST(address_);
    OCISvcCtx * __svchp;
    OCIError * __errorp;
    dvoid * __objptr;
    ub4 __objptr_len;
    ub1 __objptr_typ = OCI_OTYPE_NAME;
    ub1 __objtyp;
    sword __ret;

    /* check if all attributes have correct type */
    if(__describep == 0 || !__isOciServiceContextHandle(aServiceHandle) || !__isOciErrorHandle(anErrorHandle) ||
       !__isSmallInteger(aSchemaTypeInteger) || !__isStringLike(aSchemaString)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIDescribeAny called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __svchp   = (OCISvcCtx *) __externalAddressVal(aServiceHandle);
    __errorp = (OCIError *) __externalAddressVal(anErrorHandle);
    __objtyp = __intVal(aSchemaTypeInteger);
    __objptr = __stringVal(aSchemaString);
    __objptr_len = __stringSize(aSchemaString);

    __ret = OCIDescribeAny(__svchp, __errorp, __objptr, __objptr_len, __objptr_typ,
			   OCI_DEFAULT, __objtyp, __describep);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIDescribeAny(%x)\n", __svchp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIDescribeAny(%x) failed\n", __svchp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8Descriptor class methodsFor:'instance creation'!

newForEnvironment:anEnvironmentHandle
    "set the parentHandle to anEnvironmentHandle to register with the environment"

    ^ self basicNew environmentHandle:anEnvironmentHandle parentHandle:anEnvironmentHandle
! !

!OCI8Handle::OCI8Descriptor class methodsFor:'testing'!

isAbstract
    ^ self == SQL::OCI8Handle::OCI8Descriptor
! !

!OCI8Handle::OCI8Descriptor methodsFor:'encoding'!

acceptVisitor:anEncoder with:aParameter

     anEncoder visitDescriptor:self with:aParameter
! !

!OCI8Handle::OCI8Descriptor methodsFor:'handle allocation & release'!

primInitializeHandleWithParent:parentHandle
    "
      sets a pointer to an allocated and initialized handle, corresponding to the type specified in aTypeSymbol.
      A non-nil handle is returned on success. All descriptors are allocated with respect to an environment handle
      which is passed in as a parent handle. No diagnostics are available on error.
      Handles must be allocated using this method before they can be passed into an OCI call.
      To allocate and initialize an environment handle, call OCI8Handle>>ociEnvCreate:mode:.

      Parameters:

	  aTypeInteger (IN)
	      Specifies the type of handle to be allocated.

      Returns:
	  Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

      <return: Symbol>
    "

%{  /* UNLIMITEDSTACK */

    OBJ   __type = __OCINST(__qClass(self), ociTypeInteger);
    dvoid * __parenthndlp;
    dvoid * __hndlp;
    sword __ret;

    /* check if all attributes have correct type */
    if (!__isOciHandle(parentHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Descriptor [error]: OCIDescriptorAlloc called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    if (!__isSmallInteger(__type)) {
	RETURN(@global(TypeError));
    }

    __parenthndlp = __externalAddressVal(parentHandle);

    __ret = OCIDescriptorAlloc(__parenthndlp, &__hndlp, (ub4)__smallIntegerVal(__type), (size_t) 0, (dvoid **) 0);
    if (__ret == OCI_SUCCESS) {
	__INST(address_) = __hndlp;
    }

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIDescriptorAlloc(%x, %d) -> %x\n", __parenthndlp, __smallIntegerVal(__type), __hndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIDescriptorAlloc(%x, %d) failed\n", __parenthndlp, __smallIntegerVal(__type));
	}
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primRelease
    "free up storage associated with a handle, corresponding to the type specified in the type parameter.
     All handles may be explicitly deallocated. The OCI will deallocate a child handle if the parent is deallocated.

      Parameters:

	  aTypeInteger (IN)
	      Specifies the type of storage to be freed

      Returns:
	  Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

      <return: Symbol>"

%{  /* UNLIMITEDSTACK */

    OBJ   __type    = __OCINST(__qClass(self), ociTypeInteger);
    OBJ   __address = __INST(address_);
    sword __ret;

    /* check if all attributes have correct type */
    if (__address == 0) {
	/* parent handle is uninitialized or invalidated,
	   nothing to be done */
	RETURN(@global(OCI_SUCCESS));
    }
    if (!__isSmallInteger(__type)) {
	RETURN(@global(InvalidType));
    }

    __ret = OCIDescriptorFree(__address, (ub4) __smallIntegerVal(__type));


    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIDescriptorFree(%x)\n", __address);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIDescriptorFree(%x) failed\n", __address);
	}
    }

    if (__ret == OCI_SUCCESS) {
	__INST(address_) = 0;
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8ParentHandle class methodsFor:'documentation'!

documentation
"
    This is an abstract superclass of any OCI handle that can have subHandles.
    The subHandles are implicitely released by the OCI lib when the parent handle
    is released.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8ParentHandle class methodsFor:'testing'!

isAbstract
    ^ self == SQL::OCI8Handle::OCI8ParentHandle
! !

!OCI8Handle::OCI8ParentHandle methodsFor:'handle allocation & release'!

newHandleWithType:aTypeSymbol
    "return a pointer to an allocated and initialized handle, corresponding to the type specified in aTypeSymbol.
     A non-nil handle is returned on success. All handles are allocated with respect to an environment handle
     which is passed in as a parent handle. No diagnostics are available on error.
     Handles must be allocated using this method before they can be passed into an OCI call.
     To allocate and initialize an environment handle, call OCI8Lib>>ociEnvCreate:mode:.

     Parameters:

	 aTypeSymbol (IN)
	     Specifies the type of handle to be allocated.

     <return: OCI8Handle>
    "

    |newHandle result|

    newHandle := OCI8Handle newHandleWithType:aTypeSymbol.
    result := newHandle primInitializeHandleWithParent:self.
    result ~~ OCI_SUCCESS ifTrue:[
	self handleError:result errorHandle:nil
    ].
    newHandle environmentHandle:environmentHandle parentHandle:self.
    self register:newHandle.
    ^ newHandle
! !

!OCI8Handle::OCI8ErrorHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_ERROR));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8ErrorHandle class methodsFor:'documentation'!

documentation
"
    The error handle is passed as a parameter to most OCI calls. The error handle maintains
    information about errors that occur during an OCI operation. If an error occurs in a call, the
    error handle can be passed to OCIErrorGet() to obtain additional information about the
    error that occurred.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8ErrorHandle methodsFor:'primitives'!

getErrorCodeWithErrorTextHolder:resultArrayOrNil recordNumber:recordNumber
    "Return the errorCode stored in the errorHandler as SmallInteger.
     If errorTextHolder is an array with at least one element,
     the error text is stored in the first element as String.

     More than on error record may be retrieved from the handle.
     recordNumber (1-based) says, which error record should be retrieved.

     <return: SmallInteger|Symbol|nil>
    "
%{  /* UNLIMITEDSTACK */

    text __errbuf[512];
    ub4 __errbufsize;
    sb4 __errcode = 0;
    ub4 __recordno;
    sword __returnCode;

    if (__INST(address_) == 0) {
	RETURN(@global(AttributeError));
    }
    if (!__isSmallInteger(recordNumber)) {
	RETURN(@global(ArgumentError));
    }

    __recordno = __smallIntegerVal(recordNumber);


    /*
     * Do we want an error string?
     */

    if (__isArray(resultArrayOrNil) && __arraySize(resultArrayOrNil) > 0) {
	__errbuf[0] = '\0';
	__errbufsize = (ub4) sizeof(__errbuf);
    } else {
	__errbufsize = 0;
    }

    __returnCode = OCIErrorGet(__INST(address_), __recordno, (text *) 0, &__errcode,
		       __errbuf, __errbufsize, OCI_HTYPE_ERROR);
    if (__returnCode != OCI_SUCCESS) {
	RETURN(nil);
    }


    if (__errbufsize > 0) {
	OBJ __t;
	int __len = strnlen(__errbuf, __errbufsize);
	/* Strip a trailing newline */
	if (__len > 0 && __errbuf[__len-1] == '\n') __len--;
	__arrayVal(resultArrayOrNil)[0] = __t = __MKSTRING_L(__errbuf, __len);
	__STORE(resultArrayOrNil, __t);
    }

    RETURN(__mkSmallInteger(__errcode));
%}
! !

!OCI8Handle::OCI8LobDescriptor class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_DTYPE_LOB));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8LobDescriptor methodsFor:'comparing'!

= aLobDescriptor
    "compare if two lob descriptors reference the same lob.
     Two NULL-lobs are not considered equal"

    |ret|

"/    self == aLobDescriptor ifTrue:[^ true].   /" could be a null lob descriptor

    ret := self primIsEqual:aLobDescriptor.
    (ret == true or:[ret == false]) ifTrue:[
	^ ret.
    ].
    self handleError:ret errorHandle:nil.
    ^ false.
!

hash
    "there is nothing like hash in OCI.
     So all Descriptors hash to the same value!!"

    ^ self class hash
!

primIsEqual:aLobDescriptor
    "return:
	<Boolean> on success
	<Symbol> on error"

%{  /* UNLIMITEDSTACK */

    OCILobLocator * __dstLob = (OCILobLocator *)__INST(address_);
    OCILobLocator * __srcLob;
    OCIEnv * __envhp;
    boolean __isEqual = 0;
    sword __ret;

    if (!__isOciLobDescriptor(aLobDescriptor) || __dstLob == 0) {
	RETURN(false);
    }
    /* check if all attributes have correct type */
    if(!__isOciEnvironmentHandle(__INST(environmentHandle)) ||
       (__envhp = (OCIEnv *) __externalAddressVal(__INST(environmentHandle))) == 0) {

	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCILobIsEqual called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    __srcLob = __externalAddressVal(aLobDescriptor);

    __ret = OCILobIsEqual(__envhp, __dstLob, __srcLob, &__isEqual);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCILobIsEqual(%x %x %x) success ->%d\n", __envhp, __dstLob, __srcLob, __isEqual);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCILobIsEqual(%x %x %x) failed\n", __envhp, __dstLob, __srcLob);
	}
    };

    if (__ret == OCI_SUCCESS) {
	RETURN(__isEqual ? true : false);
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8LobDescriptor methodsFor:'lob misc'!

assign:destLob errorHandle:errorHandle
    "assigns destLob to myself"

    ^ self executePrimitive:[:errorHandle|
	self primAssign:destLob errorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
!

isInitializedWithErrorHandle:errorHandle

    |ret|

    ret := self primIsInitializedWithErrorHandle:errorHandle.
    (ret == true or:[ret == false]) ifTrue:[
	^ ret.
    ].
    self handleError:ret errorHandle:errorHandle.
    ^ false.
!

primAssign:srcLob errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCILobLocator * __destLob = (OCILobLocator *)__INST(address_);
    OCILobLocator * __srcLob;
    OCIEnv * __envhp;
    OCIError * __errorp;
    sword __ret;

    /* check if all attributes have correct type */
    if(!__isOciEnvironmentHandle(__INST(environmentHandle)) ||
       (__envhp = (OCIEnv *) __externalAddressVal(__INST(environmentHandle))) == 0 ||
       !__isOciErrorHandle(errorHandle) ||
       !__isOciLobDescriptor(srcLob) ||
       __destLob == 0) {

	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8LobDescriptor [error]: OCILobAssign called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __srcLob = __externalAddressVal(srcLob);
    __errorp = (OCIError *) __externalAddressVal(errorHandle);

    __ret = OCILobAssign(__envhp, __errorp, __srcLob, &__destLob);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCILobAssign(%x %x %x) success", __envhp, __destLob, __srcLob);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCILobAssign(%x %x %x) failed", __envhp, __destLob, __srcLob);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primIsInitializedWithErrorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCILobLocator * __destLob = (OCILobLocator *)__INST(address_);
    OCILobLocator * __srcLob;
    OCIEnv * __envhp;
    OCIError * __errorp;
    boolean __isInitialized;
    sword __ret;

    /* check if all attributes have correct type */
    if(!__isOciEnvironmentHandle(__INST(environmentHandle)) ||
       (__envhp = (OCIEnv *) __externalAddressVal(__INST(environmentHandle))) == 0 ||
       !__isOciErrorHandle(errorHandle) ||
       __destLob == 0) {

	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCILobLocatorIsInit called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    __errorp = (OCIError *) __externalAddressVal(errorHandle);

    __ret = OCILobLocatorIsInit(__envhp, __errorp, __destLob, &__isInitialized);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCILobLocatorIsInit(%x %x) success\n", __envhp, __destLob);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCILobLocatorIsInit(%x %x) failed\n", __envhp, __destLob);
	}
    };
    if (__ret == OCI_SUCCESS)
	RETURN(__isInitialized ? true : false);

    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8ParameterDescriptor class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_DTYPE_PARAM));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8ParameterDescriptor methodsFor:'converting'!

as:class withErrorHandle:errorHandle

    |columnDescriptor|

    columnDescriptor := class new.
    columnDescriptor name:(self getAttribute:#'OCI_ATTR_NAME' errorHandle:errorHandle).
    columnDescriptor type:(self class symbolForOCIDataType:
			    (self getAttribute:#'OCI_ATTR_DATA_TYPE' errorHandle:errorHandle)).

    columnDescriptor nullValue:((self getAttribute:#'OCI_ATTR_IS_NULL' errorHandle:errorHandle) = 1).
    columnDescriptor precision:(self getAttribute:#'OCI_ATTR_PRECISION' errorHandle:errorHandle).
    columnDescriptor scale:(self getAttribute:#'OCI_ATTR_SCALE' errorHandle:errorHandle).
    columnDescriptor size:(self getAttribute:#'OCI_ATTR_DATA_SIZE' errorHandle:errorHandle).

    ^ columnDescriptor
! !

!OCI8Handle::OCI8EnvironmentHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_ENV));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8EnvironmentHandle class methodsFor:'documentation'!

documentation
"
    The environment handle defines a context in which all OCI functions are invoked. Each
    environment handle contains a memory cache, which allows for fast memory management
    in a threaded environment where each thread has its own environment. When multiple
    threads share a single environment, they may block on access to the cache.

    The environment handle is passed as the parent parameter to the OCIHandleAlloc() call
    to allocate all other handle types, except for the bind and define handles.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8EnvironmentHandle class methodsFor:'instance creation'!

newMode:modeSymbolCollection

    ^ self new create:modeSymbolCollection.
! !

!OCI8Handle::OCI8EnvironmentHandle class methodsFor:'registering'!

register:anEnvironmentHandle

     Lobby isNil ifTrue:[
	Lobby := Registry new.
     ].
     Lobby register:anEnvironmentHandle
!

registerChange:anEnvironmentHandle

     Lobby registerChange:anEnvironmentHandle
!

unregister:anEnvironmentHandle

     Lobby unregister:anEnvironmentHandle
! !

!OCI8Handle::OCI8EnvironmentHandle methodsFor:'handle allocation & release'!

registerChange
    "environment handles are registered with the class"

    self class registerChange:self.
!

release
    "environment handles are registered with the class"

    super release.
    self class unregister:self.
! !

!OCI8Handle::OCI8EnvironmentHandle methodsFor:'primitives'!

create:aModeSymbolCollIn
    "creates an environment for all the OCI calls using the modes specified by the user.
     This call should be invoked before any other OCI call. This call initializes
     an environment handle which is then used by the remaining OCI functions.
     There can be multiple environments in OCI, each with its own environment modes.
     This function also performs any process level initialization if required by any mode.
     For example if the user wants to initialize an environment as #'OCI_THREADED',
     then all libraries that are used by OCI are also initialized in the threaded mode.

     Parameters:

	 aModeSymbolColl (IN)
	     Specifies initialization of the mode. Valid modes are:
		 #'OCI_DEFAULT'      - uses default mode.
		 #'OCI_THREADED'     - uses threaded environment. Internal data structures
				       not exposed to the user are protected from concurrent
				       accesses by multiple threads.
		 #'OCI_OBJECT'       - uses object features.
		 #'OCI_SHARED'       - utilizes shared data structures.
		 #'OCI_EVENTS'       - utilizes publish-subscribe notifications.
		 #'OCI_NO_UCB'       - suppresses the calling of the dynamic callback routine.
				       The default behavior is to allow calling of callback
				       routines at the time that the environment is created.
		 #'OCI_ENV_NO_MUTEX' - no mutexing in this mode. All OCI calls done on the
				       environment handle, or on handles derived from the
				       environment handle, must be serialized.

     <return: self>"

    |modeInteger aModeSymbolColl|

    environmentHandle := self.

    aModeSymbolColl size == 0 ifTrue:[
	aModeSymbolColl := #(OCI_DEFAULT).
    ] ifFalse:[
	aModeSymbolColl := aModeSymbolCollIn.
    ].
    modeInteger := 0.
    aModeSymbolColl do:[:eachModeSymbol|
	modeInteger := modeInteger bitOr:(self class numericValueForEnvironmentMode:eachModeSymbol).
    ].

    self executePrimitive:[:errorHandle|
	self primCreate:modeInteger.
    ] withErrorHandle:nil.

    self class register:self
!

primCreate:aModeInteger

%{  /* UNLIMITEDSTACK */
    OCIEnv *__envhp = 0;
    ub4 __mode = (ub4) __unsignedLongIntVal(aModeInteger);
    sword __ret;

    __ret = OCIEnvCreate(&__envhp, __mode, 0, 0, 0, 0, 0, 0);

    if (__ret == OCI_SUCCESS) {
	__INST(address_) = (OBJ)__envhp;
    }
    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIEnvCreate -> %x\n", __envhp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIEnvCreate failed\n");
	}
    };

    RETURN(__ociReturnSymbol(__ret));
%}
! !

!OCI8Handle::OCI8RowIdDescriptor class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_DTYPE_ROWID));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8ServerHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_SERVER));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8ServerHandle class methodsFor:'documentation'!

documentation
"
    A server handle identifies a data source. It translates into a physical connection in a
    connection-oriented transport mechanism.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8ServerHandle methodsFor:'primitives'!

attach:aDBName errorHandle:errorHandle
    "creates an association between an OCI application and a particular server.
     The server handle initialized by this call can be associated with
     a service context through a call to
	OCI8Lib>>ociAttrSet:attribute:attributeType:errorOCIHandle:.
     Once that association has been made, OCI operations can be performed against
     the server. If an application is operating against multiple servers, multiple
     server handles can be maintained. OCI operations are performed against whichever
     server is currently associated with the service context. When #attach:errorHandle:
     is successfully completed, an Oracle shadow process is started.
     #ociSessionEnd:userSession:errorHandle: and
     #detachWithErrorHandle: should be called to clean up the Oracle shadow process.
     Otherwise, the shadow processes accumulate and cause the system to run out of processes.
     If the database is restarted and there are not enough processes, the database
     may not startup.

     Parameters:

	 aDBName (IN)
	     Specifies the database (server) to use. This string specifies a connect
	     string or a service point.
	     If the connect string is nil, then this call attaches to the default host.

	 errorHandle (IN/OUT)
	     An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	     for diagnostic information in the event of an error.

     <return: self>
    "

    ^ self executePrimitive:[:errorHandle|
	self primAttach:aDBName errorHandle:errorHandle.
    ] withErrorHandle:errorHandle
!

detachWithErrorHandle:errorHandle
    "deletes an access to a data source for OCI operations, which was established
     by a call to OCI8Lib>>ociServerAttach:dbname:errorHandle:.
     The handle gets reset to uninitialized state but is not de-allocated.

     Parameters:

	 anOCI8ErrorHandle (IN/OUT)
	     An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	     for diagnostic information in the event of an error.

     <return: self> "

    ^ self executePrimitive:[:errorHandle|
	self primDetachWithErrorHandle:errorHandle.
    ] withErrorHandle:errorHandle
!

primAttach:aDBName errorHandle:anErrorHandle

%{  /* UNLIMITEDSTACK */

    OCIServer * __srvhndlp  = (OCIServer *)__INST(address_);
    OCIError * __errorhndlp;
    sword __ret;
    text * __dbname = 0;
    sb4 __dbname_len = 0;

    /* check if all attributes have correct type */
    if (__srvhndlp == 0
	|| !__isOciErrorHandle(anErrorHandle)
	|| (aDBName != nil && !__isStringLike(aDBName))) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIServerAttach called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);
    if (aDBName != nil) {
	 __dbname = __stringVal(aDBName);
	 __dbname_len = __stringSize(aDBName);
    }

    __ret = OCIServerAttach(__srvhndlp, __errorhndlp, __dbname, __dbname_len, OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIServerAttach(%x, ", __srvhndlp);
	    fwrite(__dbname, 1, __dbname_len, stderr);
	    fprintf(stderr,")\n");
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIServerAttach(%x) failed\n", __srvhndlp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primDetachWithErrorHandle:anErrorHandle

%{  /* UNLIMITEDSTACK */

    OCIServer * __srvhndlp = (OCIServer *)__INST(address_);
    OCIError * __errorhndlp;
    sword __ret;

    /* check if all attributes have correct type */
    if (__srvhndlp == 0 || !__isOciErrorHandle(anErrorHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIServerDetach called with wrong attributes.\n");
	}
	RETURN(@global(AttributeError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);

    __ret = OCIServerDetach(__srvhndlp, __errorhndlp, OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIServerDetach(%x)\n", __srvhndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIServerDetach(%x) failed\n", __srvhndlp);
	}
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8ServiceContextHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_SVCCTX));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8ServiceContextHandle class methodsFor:'documentation'!

documentation
"
    A service context handle defines attributes that determine the operational context for OCI
    calls to a server. The service context contains three handles that represent a server
    connection, a user session, and a transaction.

	 A server handle identifies a data source. It translates into a physical connection in a
	 connection-oriented transport mechanism.

	 A user session handle defines a user's roles and privileges (also known as the user's
	 security domain), and the operational context on which the calls execute.

	 A transaction handle defines the transaction in which the SQL operations are
	 performed. The transaction context includes user session state information,
	 including the fetch state and package instantiation, if any.

    Breaking the service context down in this way provides scalability and enables
    programmers to create sophisticated three-tiered applications and transaction processing
    (TP) monitors to execute requests on behalf of multiple users on multiple application
    servers and different transaction contexts.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8ServiceContextHandle methodsFor:'lob primitives'!

lobOpen:lobHandle mode:modeSymbol errorHandle:errorHandle


    ^ self executePrimitive:[:errorHandle|
	self primLobOpen:lobHandle mode:modeSymbol errorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
!

primLobOpen:aLobDescriptor mode:modeSymbol errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx *__svchndl = (OCISvcCtx *)__INST(address_);
    OCILobLocator * __lob;
    OCIError * __errorp;
    sword __ret;
    ub1 __mode;

    /* check if all attributes have correct type */
    if(!__isOciErrorHandle(errorHandle) || !__isOciLobDescriptor(aLobDescriptor) ||
       __svchndl == 0) {

	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCILobOpen called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __lob = __externalAddressVal(aLobDescriptor);
    __errorp = (OCIError *) __externalAddressVal(errorHandle);

    if (modeSymbol == @symbol(OCI_LOB_READONLY))
	__mode = OCI_LOB_READONLY;
    else if (modeSymbol == @symbol(OCI_LOB_READWRITE))
	__mode = OCI_LOB_READWRITE;
    else if (modeSymbol == @symbol(OCI_FILE_READONLY))
	__mode = OCI_FILE_READONLY;
    else RETURN(@global(AttributeError));

    __ret = OCILobOpen(__svchndl, __errorp, __lob, __mode);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCILobOpen(%x %x %d) success\n", __svchndl, __lob, __mode);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCILobOpen(%x %x %d) failed\n", __svchndl, __lob, __mode);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8ServiceContextHandle methodsFor:'session primitives'!

beginSession:aSessionHandle credential:aCredSymbol mode:aModeSymbol errorHandle:anErrorHandle
    "used to authenticate a user against the server set in the service context handle.

	 Note:   Check for any errors returned when trying to start a session.
		 For example, if the password for the account has expired,
		 an ORA-28001 error is returned.

     For Oracle8i, this method must be called for any given server handle before requests
     can be made against it. Also, this method only supports authenticating the user
     for access to the Oracle server specified by the server handle in the service context.
     In other words, after OCI8ServerHandle>>attach:errorHandle: has been called
     to initialize a server handle, this method must be called to authenticate the user
     for that given server.

     When this method is called for the first time for a given server handle,
     the user session may not be created in migratable (#'OCI_MIGRATE') mode.

     After this method has been called for a server handle, the application may call
     this method again to initialize another user session handle with different (or the same)
     credentials and different (or the same) operation modes.
     If an application wants to authenticate a user in #'OCI_MIGRATE' mode,
     the service context handle must already be associated with a non-migratable user handle.
     The user ID of that user handle becomes the ownership ID of the migratable user session.
     Every migratable session must have a non-migratable parent session.

     If the #'OCI_MIGRATE' mode is not specified, then the user session context can
     only be used with the same server handle set in aServiceHandle.
     If #'OCI_MIGRATE' mode is specified, then the user authentication may be set
     with different server handles. However, the user session context may only be used
     with server handles which resolve to the same database instance. Security checking
     is done during session switching. A process or circuit is allowed to switch to a
     migratable session only if the ownership ID of the session matches the user ID of a
     non-migratable session currently connected to that same process or circuit,
     unless it is the creator of the session.

     Modes #'OCI_SYSDBA', #'OCI_SYSOPER', and #'OCI_PRELIM_AUTH' may only be used with
     a primary user session context.

     To provide credentials for a call to this method, one of two methods are supported.
     The first is to provide a valid username and password pair for database authentication
     in the user session handle passed to this method.
     This involves using OCI8Lib>>ociAttrSet:attribute:attributeType:errorOCIHandle: to
     set the #'OCI_ATTR_USERNAME' and #'OCI_ATTR_PASSWORD' attributes on the
     user session handle. Then this method is called with #'OCI_CRED_RDBMS'.

	 Note: When the user session handle is terminated using
	       OCI8Lib>>ociSessionEnd:userSession:errorHandle:,
	       the username and password attributes remain unchanged and thus can be
	       re-used in a future call to this method. Otherwise, they must be reset
	       to new values before the next call to this method.

     The second type of credentials supported are external credentials. No attributes
     need to be set on the user session handle before calling this method.
     The credential type is #'OCI_CRED_EXT'. This is equivalent to the Oracle7
     'connect /'  syntax. If values have been set for #'OCI_ATTR_USERNAME' and
     #'OCI_ATTR_PASSWORD', then these are ignored if #'OCI_CRED_EXT' is used. Another way
     of setting credentials is to use the session Id of an already authenticated user
     with the #'OCI_MIGSESSION' attribute. This Id can be extracted from the session handle
     of an authenticated user using the OCI8Lib>>ociAttrGet:attributeType:errorOCIHandle:
     call.

     Parameters:

	 self (IN)
	     A handle to a valid service context.

	 aSessionHandle (IN)
	     A handle to an user session.

	 aCredSymbol (IN)
	     Specifies the type of credentials to use for establishing the user session.
	     Valid values for credt are:
		 #'OCI_CRED_RDBMS' - authenticate using a database username and password
				     pair as credentials. The attributes OCI_ATTR_USERNAME
				     and OCI_ATTR_ PASSWORD should be set on the user
				     session context before this call.
		 #'OCI_CRED_EXT'   - authenticate using external credentials.
				     No username or password is provided.

	 aModeSymbol (IN)
	     Specifies the various modes of operation. Valid modes are:
		 #'OCI_DEFAULT'     - in this mode, the user session context returned may
				      only ever be set with the same server context
				      specified in svchp.
		 #'OCI_MIGRATE'     - in this mode, the new user session context may be set
				      in a service handle with a different server handle.
				      This mode establishes the user session context.
				      To create a migratable session, the service handle
				      must already be set with a non-migratable user session.
				      A migratable session must have a non-migratable
				      parent session.
		 #'OCI_SYSDBA'      - in this mode, the user is authenticated for
				      SYSDBA access.
		 #'OCI_SYSOPER'     - in this mode, the user is authenticated for
				      SYSOPER access.
		 #'OCI_PRELIM_AUTH' - this mode may only be used with OCI_SYSDBA or
				      OCI_SYSOPER to authenticate for certain administration
				      tasks.

	 anErrorHandle (IN/OUT)
	     An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	     for diagnostic information in the event of an error.

     <return: self>
    "

    ^ self executePrimitive:[:errorHandle|
	self primBeginSession:aSessionHandle
		   credential:(self class numericValueForCredentialType:aCredSymbol)
			 mode:(self class numericValueForSessionMode:aModeSymbol)
		  errorHandle:errorHandle.
    ] withErrorHandle:anErrorHandle
!

changeUserPassword:userName oldPassword:oldPassword newPassword:newPassword mode:modeSymbol errorHandle:errorHandle

    ^ self executePrimitive:[:errorHandle|
	self primChangeUserPassword:userName
			oldPassword:oldPassword
			newPassword:newPassword
			       mode:modeSymbol
			errorHandle:errorHandle.
    ] withErrorHandle:errorHandle
!

endSession:anUserSessionHandle errorHandle:anErrorHandle
    "terminates a user session created by #beginSession:credential:mode:errorHandle:.
     The user security context associated with the service context is invalidated by this
     call. Storage for the user session context is not freed. The transaction specified
     by the service context is implicitly committed. The transaction handle, if explicitly
     allocated, may be freed if not being used. Resources allocated on the server for
     this user are freed. The user session handle may be reused in a new call to
     #beginSession:credential:mode:errorHandle:.

     Parameters:

	 self (IN/OUT)
	     The service context handle. There must be a valid server handle and user
	     session handle associated with aServiceHandle.

	 anUserSessionHandle (IN)
	     De-authenticate this user. If this parameter is passed as nil, the user
	     in the service context handle is de-authenticated.

	 anErrorHandle (IN/OUT)
	     An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	     for diagnostic information in the event of an error.

     <return: self>"

    self executePrimitive:[:errorHandle|
	self primEndSession:anUserSessionHandle errorHandle:errorHandle.
    ] withErrorHandle:anErrorHandle.

    currentTransaction notNil ifTrue:[
	currentTransaction invalidateAndUnregister.
	currentTransaction := nil.
    ].
!

primBeginSession:aUserSessionHandle credential:aCredInteger mode:aModeInteger errorHandle:anErrorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svchndlp = (OCISvcCtx *) __INST(address_);
    OCISession * __usrhndlp;
    OCIError * __errorhndlp;
    sword __ret;
    ub4 __credt;
    ub4 __mode;

    /* check if all attributes have correct type */
   if(__svchndlp == 0 || !__isOciUserSessionHandle(aUserSessionHandle) || !__isOciErrorHandle(anErrorHandle) ||
       !__isInteger(aCredInteger) || !__isInteger(aModeInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCISessionBegin called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __usrhndlp = (OCISession *) __externalAddressVal(aUserSessionHandle);
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);
    __credt = __unsignedLongIntVal(aCredInteger);
    __mode  = __unsignedLongIntVal(aModeInteger);

    __ret = OCISessionBegin(__svchndlp, __errorhndlp, __usrhndlp,  __credt, __mode);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCISessionBegin(%x, %x, %d, %d)\n", __svchndlp, __usrhndlp, __credt, __mode);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCISessionBegin(%x, %x, %d, %d) failed\n", __svchndlp, __usrhndlp, __credt, __mode);
	}
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primChangeUserPassword:userName oldPassword:oldPassword newPassword:newPassword mode:modeSymbol errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svchndlp = (OCISvcCtx *) __INST(address_);
    OCIError * __errorhndlp;
    sword __ret;
    ub4 __mode;

    /* check if all attributes have correct type */
   if(__svchndlp == 0 || !__isOciErrorHandle(errorHandle) ||
      !__isStringLike(userName) || !__isStringLike(oldPassword) || !__isStringLike(newPassword)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCISessionBegin called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(errorHandle);

    if (modeSymbol == nil || modeSymbol == @symbol(OCI_DEFAULT))
	__mode == OCI_DEFAULT;
    else if (modeSymbol == @symbol(OCI_AUTH))
	__mode == OCI_AUTH;
    else
	RETURN(@global(AttributeError));

    __ret = OCIPasswordChange(__svchndlp, __errorhndlp,
			      __stringVal(userName), __stringSize(userName),
			      __stringVal(oldPassword), __stringSize(oldPassword),
			      __stringVal(newPassword), __stringSize(newPassword),
			      __mode);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIPasswordChange(%x)\n", __svchndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIPasswordChange(%x) failed\n");
	}
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primEndSession:aUserSessionHandle errorHandle:anErrorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svchndlp = (OCISvcCtx *) __INST(address_);
    OCISession * __usrhndlp;
    OCIError * __errorhndlp;
    sword __ret;

    /* check if all attributes have correct type */
    if(__svchndlp == 0 ||
       !__isOciUserSessionHandle(aUserSessionHandle) || !__isOciErrorHandle(anErrorHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCISessionEnd called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __usrhndlp = (OCISession *) __externalAddressVal(aUserSessionHandle);
    __errorhndlp = (OCIError *) __externalAddressVal(anErrorHandle);

    __ret = OCISessionEnd(__svchndlp, __errorhndlp, __usrhndlp, OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCISessionEnd(%x, %x)\n", __svchndlp, __usrhndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCISessionEnd(%x, %x) failed\n", __svchndlp, __usrhndlp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8ServiceContextHandle methodsFor:'transaction primitives'!

commitTransaction:aTransactionCommitType errorHandle:errorHandle
    "commits the transaction which is currently associated with the service context.
     If it is a global transaction that the server cannot commit, this call additionally
     retrieves the state of the transaction from the database to be returned to the user
     in the error handle. If the application has defined multiple transactions, this
     function operates on the transaction currently associated with the service context.
     If the application is working with only the implicit local transaction created when
     database changes are made, that implicit transaction is committed.
     If the application is running in the object mode, then the modified or updated
     objects in the object cache for this transaction are also flushed and committed.
     Under normal circumstances, this method returns with a status indicating that the
     transaction has either been committed or rolled back. With global transactions,
     it is possible that the transaction is now in-doubt, meaning that it is neither
     committed nor aborted. In this case, this method attempts to retrieve the status
     of the transaction from the server. The status is returned.

     Parameters:

	 self (IN)
	     The service context handle.

	 aTransactionCommitType (IN)
	     A flag used for one-phase commit optimization in global transactions.
	     If the transaction is non-distributed, the flags parameter is ignored,
	     and #'OCI_ DEFAULT' can be passed as its value. OCI applications managing
	     global transactions should pass a value of #'OCI_TRANS_TWOPHASE' to the
	     flags parameter for a two-phase commit. The default is one-phase commit.

	 errorHandle (IN/OUT)
	     An error handle you can use to retrieve diagnostic information in the
	     event of an error.

     <return: self>
    "

    self executePrimitive:[:errorHandle|
	self primCommitTransaction:(self class numericValueForTransactionCommitType:aTransactionCommitType)
		       errorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
!

detachTransactionWithErrorHandle:errorHandle
    "detaches a global transaction from the service context handle. The transaction
     currently attached to the service context handle becomes inactive at the end of this
     call. The transaction may be resumed later by calling #startTransaction... , specifying
     a flags value of #'OCI_TRANS_RESUME'. When a transaction is detached, the value
     which was specified in the timeout parameter of #startTransaction... when the
     transaction was started is used to determine the amount of time the branch can remain
     inactive before being deleted by the server s PMON process.

	 Note: The transaction can be resumed by a different process than the one that
	       detached it, provided that the transaction has the same authorization.
	       If this function is called before a transaction is actually started,
	       this function is a no-op.

     Parameters:

	 self (IN)
	     The service context handle.

	 errorHandle (IN/OUT)
	     An error handle you can use to retrieve diagnostic information in the
	     event of an error.

     <return: self>
    "

    self executePrimitive:[:errorHandle|
	self primDetachTransactionWithErrorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
    currentTransaction := nil.
!

prepareTransactionWithErrorHandle:errorHandle
    "prepares the specified global transaction for commit. This call is valid only for
     global transactions. The call raises an OCISuccessWithInfoSignal-Signal if the
     transaction has not made any changes.
     The error handle will indicate that the transaction is read-only.

     Parameters:

	 self (IN)
	     The service context handle.

	 errorHandle (IN/OUT)
	     An error handle you can use to retrieve diagnostic information in the
	     event of an error.


     <return: self>
    "

    self executePrimitive:[:errorHandle|
	self primPrepareTransactionWithErrorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
!

primCommitTransaction:aFlagInteger errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svcxtxhndlp = (OCISvcCtx *)__INST(address_);
    OCIError * __errorhndlp;
    ub4 __flags;
    sword __ret;

    /* check if all attributes have correct type */
    if(__svcxtxhndlp == 0 || !__isOciErrorHandle(errorHandle) || !__isInteger(aFlagInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIServerAttach called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp  = (OCIError *) __externalAddressVal(errorHandle);
    __flags = __unsignedLongIntVal(aFlagInteger);

    __ret = OCITransCommit(__svcxtxhndlp, __errorhndlp, __flags);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCITransCommit(%x, %d)\n", __svcxtxhndlp, __flags);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCITransCommit(%x, %d) failed\n", __svcxtxhndlp, __flags);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primDetachTransactionWithErrorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svcxtxhndlp = (OCISvcCtx *)__INST(address_);
    OCIError * __errorhndlp;
    sword __ret;

     /* check if all attributes have correct type */
    if(__svcxtxhndlp == 0 || !__isOciErrorHandle(errorHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIServerAttach called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp  = (OCIError *) __externalAddressVal(errorHandle);

    __ret = OCITransDetach(__svcxtxhndlp, __errorhndlp, OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCITransDetach(%x)\n", __svcxtxhndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCITransDetach(%x) failed\n", __svcxtxhndlp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primPrepareTransactionWithErrorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svcxtxhndlp = (OCISvcCtx *)__INST(address_);
    OCIError * __errorhndlp;
    sword __ret;

    /* check if all attributes have correct type */
    if(__svcxtxhndlp == 0 || !__isOciErrorHandle(errorHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIServerDetach called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp   = (OCIError *) __externalAddressVal(errorHandle);

    __ret = OCITransPrepare(__svcxtxhndlp, __errorhndlp, OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCITransPrepare(%x)\n", __svcxtxhndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCITransPrepare(%x) failed\n", __svcxtxhndlp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primRollbackTransactionWithErrorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svcxtxhndlp = (OCISvcCtx *)__INST(address_);
    OCIError * __errorhndlp;
    sword __ret;

    /* check if all attributes have correct type */
    if (__svcxtxhndlp == 0 || !__isOciErrorHandle(errorHandle)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCITransRollback called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp  = (OCIError *) __externalAddressVal(errorHandle);

    __ret = OCITransRollback(__svcxtxhndlp, __errorhndlp, OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCITransRollback(%x)\n", __svcxtxhndlp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCITransRollback(%x) failed\n", __svcxtxhndlp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primStartTransaction:aFlagInteger timeout:aTimeoutInteger errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svcxtxhndlp = (OCISvcCtx *)__INST(address_);
    OCIError * __errorhndlp;
    ub4 __flags;
    uword __time;
    sword __ret;

    /* check if all attributes have correct type */
    if (__svcxtxhndlp == 0|| !__isOciErrorHandle(errorHandle)
	|| !__isInteger(aFlagInteger) || !__isInteger(aTimeoutInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCITransStart called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp  = (OCIError *) __externalAddressVal(errorHandle);
    __flags = __unsignedLongIntVal(aFlagInteger);
    __time  = __unsignedLongIntVal(aTimeoutInteger);

    __ret = OCITransStart(__svcxtxhndlp, __errorhndlp, __time, __flags);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCITransStart(%x, %d, %d)\n", __svcxtxhndlp, __time, __flags);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCITransStart(%x, %d, %d) failed\n", __svcxtxhndlp, __time, __flags);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

rollbackTransactionWithErrorHandle:errorHandle
    "rolls back the current transaction which is defined as the set of statements
     executed since the last #commitTransaction... or #beginSession...
     If the application is running under object mode then the modified or updated objects
     in the object cache for this transaction are also rolled back. Attempting to
     roll back a global transaction that is not currently active causes an error.

     Parameters:

	 self (IN)
	     A service context handle. The transaction currently set in the service
	     context handle is rolled back.

	 errorHandle (IN/OUT)
	     An error handle you can use to retrieve diagnostic information in the
	     event of an error.

     <return: self>
    "

    self executePrimitive:[:errorHandle|
	self primRollbackTransactionWithErrorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
!

setTransaction:transactionHandle errorHandle:errorHandle
    "set the current transaction handle of this service context"

    self setAttribute:#'OCI_ATTR_TRANS' value:transactionHandle errorHandle:errorHandle.
    currentTransaction := transactionHandle.
!

startTransaction:aTransactionTypeColl timeout:aTimeoutInteger errorHandle:errorHandle
    "sets the beginning of a global or serializable transaction. The transaction context
     currently associated with the service context handle is initialized at the end of
     the call if the flags parameter specifies that a new transaction should be started.

     The XID of the transaction is set as an attribute of the transaction handle
     (#'OCI_ATTR_XID').

     Parameters:

	 self (IN)
	     The service context handle. The transaction context in the service context
	     handle is initialized at the end of the call if the flag specified a
	     new transaction to be started.

	 aTimeoutInteger (IN)
	     The time, in seconds, to wait for a transaction to become available for
	     resumption when #'OCI_TRANS_RESUME' is specified. When #'OCI_TRANS_NEW'
	     is specified, the timeout parameter indicates the number of seconds the
	     transaction can be inactive before it is automatically aborted by the system.
	     A transaction is inactive between the time it is detached with
	     #detachTrasactionWithErrorCode and the time it is resumed
	     #startTransaction... (with mode = #'OCI_TRANS_RESUME').

	 aTransactionTypeColl (IN)
	     Specifies whether a new transaction is being started or an existing
	     transaction is being resumed. Also specifies serializiability or read-only
	     status. More than a single value can be specified. By default, a read/write
	     transaction is started. The flag values are:

		 #'OCI_TRANS_NEW'          - starts a new transaction branch. By default
					     starts a tightly coupled and migratable branch.
		 #'OCI_TRANS_TIGHT'        - explicitly specifies a tightly coupled branch
		 #'OCI_TRANS_LOOSE'        - specifies a loosely coupled branch
		 #'OCI_TRANS_RESUME'       - resumes an existing transaction branch.
		 #'OCI_TRANS_READONLY'     - start a read-only transaction
		 #'OCI_TRANS_SERIALIZABLE' - start a serializable transaction

	 errorHandle (IN/OUT)
	     An error handle you can use to retrieve diagnostic information in the
	     event of an error.

     <return: self>
    "

    self executePrimitive:[:errorHandle|
	self primStartTransaction:(self class numericValueForTransactionTypeColl:aTransactionTypeColl)
			  timeout:aTimeoutInteger
		      errorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
! !

!OCI8Handle::OCI8StatementHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_STMT));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8StatementHandle class methodsFor:'documentation'!

documentation
"
    A statement handle is the context that identifies a SQL or PL/SQL statement and its
    associated attributes.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8StatementHandle methodsFor:'dynamic data'!

needDataWithErrorHandle:errorHandle
    "a dynamic bind or define handle needs data. Find out about the bind/define handle and
     forward the request"

    |returnArray bindAddress bindHandle|

    returnArray := Array new:6.

    self getPieceInfoInto:returnArray errorHandle:errorHandle.
    bindAddress := returnArray at:1.
    bindHandle := childHandleRegistry collection detect:[:handle| handle notNil and:[handle ~~ 0 and:[handle = bindAddress]]].
    ^ bindHandle needData:returnArray errorHandle:errorHandle.
! !

!OCI8Handle::OCI8StatementHandle methodsFor:'local primitives'!

getBindInfoWithErrorHandle:errorHandleIn
    "return information about bind variables after a statement has been prepared.
     This includes bind names, indicator names, and whether or not binds are duplicate binds.
     This call also returns an associated bind handle if there is one. This function
     does not include SELECT INTO list variables, because they are not considered to
     be binds. The statement must have been prepared with a call to
     #prepare:language:mode:errorHandle: prior to this call.

     Parameters:

	 self (IN)
	     The statement handle.

	 errorHandle (IN/OUT)
	     An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	     for diagnostic information in the event of an error.

     <return: Array of:OCI8BindDescriptor>
    "

    |errorHandle result descriptor dict|

    errorHandleIn isNil ifTrue:[
	"no error handle used when operating on environment handle (self)"
	environmentHandle ~~ self ifTrue:[
	    errorHandle := environmentHandle newHandleWithType:#OCI8ErrorHandle.
	].
    ] ifFalse:[
	errorHandle := errorHandleIn.
    ].
    ExecutionLock critical:[
	"call primitve function to get info about the bind variables of the statement"
	"if there are no bind variables an empty array is returned
	 else an array with bind desciptors is returned.
	 a symbol is returned on error"
	result := self primGetBindInfoWithErrorHandle:errorHandle.
	result isCollection ifFalse:[
	    result == OCI_NO_DATA ifTrue:[
		result := #().
	    ] ifFalse:[
		self handleError:result errorHandle:errorHandle.
	    ].
	].
	errorHandleIn isNil ifTrue:[
	    errorHandle release.
	].
    ].

    dict := Dictionary new:result size.
    result keysAndValuesDo:[:index :eachElement |
	|name|
	name := (eachElement at:1) asSymbol.
	descriptor := OCI8BindDescriptor new.
	descriptor position:index;
		   name:name;
		   indicator:(eachElement at:2);
		   duplicate:(eachElement at:3);
		   handle:(eachElement at:4).
	dict at:name put:descriptor.
    ].
    ^ dict.
!

prepare:statementTextBuffer language:aLanguageSymbolOrNil mode:aModeSymbolOrNil errorHandle:errorHandle
    "prepares a SQL or PL/SQL statement for execution. This is a purely local call.
     Data values for this statement initialized in subsequent bind calls will be stored
     in a bind handle which will hang off this statement handle. This call does not create
     an association between this statement handle and any particular server.

     Parameters:

	 self (IN)
	     A statement handle.

	 statementTextBuffer (IN)
	     A pointer to a SQL or PL/SQL statement text to be executed. Must be a
	     null-terminated string. The pointer to the text of the statement must be
	     available as long as the statement is executed, or data is fetched from it.

	 aLanguageSymbolOrNil (IN)
	     Specifies V7, or native syntax. Possible values are:
		 OCI_V7_SYNTAX  - V7 ORACLE parsing syntax
		 OCI_NTV_SYNTAX or nil - syntax depends upon the version of the server.

	 aModeSymbolOrNil (IN)
	     The possible values are:

		 OCI_DEFAULT or nil  - default mode

		 OCI_NO_SHARING - disables sharing mode for the SQL statement.

	 errorHandle (IN/OUT)
	     An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	     for diagnostic information in the event of an error.

     <return: self>
    "

    self executePrimitive:[:errorHandle|
	self primPrepare:statementTextBuffer
		language:(self class numericValueForLanguageMode:aLanguageSymbolOrNil)
		    mode:(self class numericValueForPrepareMode:aModeSymbolOrNil)
	     errorHandle:errorHandle.
    ] withErrorHandle:errorHandle.

    "preparing a statement implicitely releases all subhandles (bind and define handles)"
    self invalidateSubhandles.
!

primGetBindInfoWithErrorHandle:errorHandle

    |valueArray|

%{  /* UNLIMITEDSTACK */

# define PREINITIALIZED_VARIABLES 20

    OCIStmt * __stmtp = (OCIStmt *)__INST(address_);
    OCIError * __errorp;
    sb4 __found = 0;
    ub1 * __bvnl = 0;
    ub1 * __inpl = 0;
    ub1 * __dupl = 0;
    text ** __bvnp = 0;
    text ** __invp = 0;
    OCIBind ** __hndl = 0;
    OBJ t;
    sword __ret;
    int i;
    OBJ __retObj;

#define returnc return/*This is defined to avoid stc-Warnings*/

    OBJ allocatememory(ub4 __numberOfBinds)
    {
	__bvnp = (text **) malloc(__numberOfBinds *
				  (2*sizeof(text *) + sizeof(OCIBind *) + 3*sizeof(ub1)));
	if(__bvnp == 0) {
	    returnc(@global(MallocError));
	}
	__invp = __bvnp + __numberOfBinds;
	__hndl = (OCIBind **)__invp + __numberOfBinds;
	__bvnl = (ub1 *) __hndl + __numberOfBinds;
	__inpl = __bvnl + __numberOfBinds;
	__dupl = __inpl + __numberOfBinds;
	returnc(true);
    }
#undef returnc

    void freememory(void) {
	free(__bvnp);
    }

    /* check if all attributes have correct type */
    if (__stmtp == 0 || !__isOciErrorHandle(errorHandle)) {
	__ociDebugBreakPoint__();
	RETURN(@global(ArgumentError));
    }
    __errorp = (OCIError *) __externalAddressVal(errorHandle);

    /* initialize memory pointers for PREINITIALIZED_VARIABLES number of bind variables */
    if ((__retObj = allocatememory((ub4) PREINITIALIZED_VARIABLES)) != true) {
	RETURN(__retObj);
    }

    /* in first call of OCIStmtGetBindInfo get only PREINITIALIZED_VARIABLES number
     * of bind variables. If the returned number of existing bind variables is greater
     * than the PREINITIALIZED_VARIABLES number, a second call of OCIStmtGetBindInfo
     * is necessary.
     */

    __ret = OCIStmtGetBindInfo (__stmtp, __errorp, (ub4) PREINITIALIZED_VARIABLES, (ub4) 1,
				&__found, __bvnp, __bvnl, __invp, __inpl, __dupl, __hndl);

    if (__ret != OCI_SUCCESS) {
	__ociDebugBreakPoint__();
	freememory();
	RETURN(__ociReturnSymbol(__ret));
    };

    /*
     * if more then PREINITIALIZED_VARIABLES number of bind variables exist,
     * a negative number is returned.
     * reinitialize the memory pointers and call OCIStmtGetBindInfo again with the
     * number of existing bind variables
     */
    if (__found < 0) {
	freememory();
	__found = -__found;
	if ((__retObj = allocatememory(__found)) != true) {
	    RETURN(__retObj);
	}
	/* get definitly all bind variables */
	__ret = OCIStmtGetBindInfo (__stmtp, __errorp, __found, (ub4) 1,
				    &__found, __bvnp, __bvnl, __invp, __inpl, __dupl, __hndl);

	if (__ret != OCI_SUCCESS) {
	    __ociDebugBreakPoint__();
	    freememory();
	    RETURN(__ociReturnSymbol(__ret));
	}
    }

    /* allocate return-value aray */
    valueArray = __ARRAY_NEW_INT(__found);

    for (i = 0; i < __found; i++) {
	OBJ bindInfo;

	/* add info arrays after found varibale into returnArray */
	__ArrayInstPtr(valueArray)->a_element[i] = bindInfo = __ARRAY_NEW_INT(4);
	__STORE(valueArray, bindInfo);

	__ArrayInstPtr(bindInfo)->a_element[0] = t = __MKSTRING_L(__bvnp[i],__bvnl[i]);
	__STORE(bindInfo, t);

	__ArrayInstPtr(bindInfo)->a_element[1] = t = __MKSTRING_L(__invp[i],__inpl[i]);
	__STORE(bindInfo, t);

	__ArrayInstPtr(bindInfo)->a_element[2] = __dupl[i] ? true : false;

	if (__hndl[i] != 0) {
	    __ArrayInstPtr(bindInfo)->a_element[3] = t = __MKEXTERNALADDRESS(__hndl[i]);
	    __STORE(bindInfo, t);
	}
    }

    if (@global(Debugging) == true) {
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtGetBindInfo(%x)\n", __stmtp);
	} else if (__ret == OCI_NO_DATA) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtGetBindInfo(%x) NO DATA\n", __stmtp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIStmtGetBindInfo(%x) failed\n", __stmtp);
	}
    };

    freememory();
    RETURN(valueArray);
%}.
!

primPrepare:aStatementTextBuffer language:aLanguageInteger mode:aModeInteger errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCIStmt * __stmthndlp = (OCIStmt *)__INST(address_);
    OCIError * __errorhndlp;
    ub4 __language;
    ub4 __mode;
    unsigned char * __stringp;
    sword __ret;

    /* check if all attributes have correct type */
    if (__stmthndlp == 0 || !__isOciErrorHandle(errorHandle) ||
	!__isExternalBytes(aStatementTextBuffer) || !__isInteger(aModeInteger) ||
	!__isInteger(aLanguageInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIStmtPrepare called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(errorHandle);
    __language = __unsignedLongIntVal(aLanguageInteger);
    __mode     = __unsignedLongIntVal(aModeInteger);
    __stringp  = (unsigned char *)__externalBytesAddress(aStatementTextBuffer);


    __ret = OCIStmtPrepare(__stmthndlp, __errorhndlp, __stringp, strlen((char *)__stringp),
			   __language, __mode);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtPrepare(%x, %x, %x) = %s\n", __stmthndlp, __language, __mode, __stringp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIStmtPrepare(%x, %x, %x) = %s failed\n", __stmthndlp, __language, __mode, __stringp);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8StatementHandle methodsFor:'primitives'!

executeOn:serviceContextHandle mode:modeSymbol iterator:iteratorInteger rowOffset:rowOffsetInteger errorHandle:errorHandle
    "used to execute a prepared SQL statement. Using an execute call, the application
     associates a request with a server. If a SELECT statement is executed, the
     description of the select-list is available implicitly as a response. This description
     is buffered on the client side for describes, fetches and define type conversions.
     Hence it is optimal to describe a select list only after an execute. Also for SELECT
     statements, some results are available implicitly. Rows will be received and buffered
     at the end of the execute. For queries with small row count, a prefetch causes memory
     to be released in the server if the end of fetch is reached, an optimization that may
     result in memory usage reduction. Set attribute call has been defined to set the
     number of rows to be prefetched per result set. For SELECT statements, at the end of
     the execute, the statement handle implicitly maintains a reference to the service
     context on which it is executed. It is the user s responsibility to maintain the
     integrity of the service context. The implicit reference is maintained until the
     statement handle is freed or the fetch is cancelled or an end of fetch condition is
     reached.

     Note: If output variables are defined for a SELECT statement before a call to
	   OCIStmtExecute(), the number of rows specified by iters will be fetched directly
	   into the defined output buffers and additional rows equivalent to the prefetch
	   count will be prefetched. If there are no additional rows, then the fetch is
	   complete without calling OCI8Lib>>ociStatementPiecewiseFetch:serviceOCIHandle:pieceSize:numberOfRows:errorOCIHandle:.

     Parameters:

	 self (IN)
	     An statement handle. It defines the statement and the associated data to be
	     executed at the server. It is invalid to pass in a statement handle that
	     has bind of data types only supported in release 8 when anOCI8Statement handle
	     points to an Oracle7 server.

	 serviceContextHandle (IN)
	     Service context handle.

	 anIteratorInteger (IN)
	     For non-SELECT statements, the number of times this statement is executed.
	     For SELECT statements, if iters is non-zero, then defines must have been done
	     for the statement handle. The execution fetches iters rows into these
	     predefined buffers and prefetches more rows depending upon the prefetch row
	     count. If you do not know how many rows the SELECT statement will retrieve,
	     set iters to zero.
	     This function returns an error if iters=0 for non-SELECT statements.

	 aRowOffInteger (IN)
	     The starting index from which the data in an array bind is relevant for this
	     multiple row execution.

	 aModeInteger (IN)
	     The modes are:

		 OCI_DEFAULT           - Calling OCIStmtExecute() in this mode executes the
					 statement. It also implicitly returns describe
					 information about the select-list.

		 OCI_DESCRIBE_ONLY     - This mode is for users who wish to describe a
					 query prior to execution. Calling OCIStmtExecute()
					 in this mode does not execute the statement, but it
					 does return the select-list description.
					 To maximize performance, it is  recommended that
					 applications execute the statement in default mode
					 and use the implicit describe which accompanies
					 the execution.

		 OCI_COMMIT_ON_SUCCESS - When a statement is executed in this mode, the
					 current transaction is committed after execution,
					 provided that execution completes successfully.

		OCI_EXACT_FETCH        - Used when the application knows in advance exactly
					 how many rows it will be fetching. This mode turns
					 prefetching off for Oracle release 8 mode,
					 and requires that defines be done before the
					 execute call. Using this mode cancels the cursor
					 after the desired rows are fetched and may result
					 in reduced server-side resource usage.

		OCI_BATCH_ERRORS       - In this mode, the OCI attempts to INSERT, UPDATE,
					 or DELETE all rows, and collects (batches)
					 information about any errors which occurred.
					 The application can then retrieve this error
					 information and re-execute any DML operations
					 which failed during the first call.

	     The modes are not mutually exclusive and can be used together.

	 errorHandle (IN/OUT)
	    An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	    for diagnostic information in the event of an error.

     <return: self>
    "

    |mode|

    mode := self class numericValueForExecuteMode:modeSymbol.

    self executePrimitive:[:errorHandle|
	self primExecuteOn:serviceContextHandle
		  iterator:iteratorInteger
		 rowOffset:rowOffsetInteger
		      mode:mode
	       errorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
!

fetchNumberOfRows:aNumberOfRowsInteger errorHandle:errorHandle
"
fetches rows from a query. The fetch call is a local call, if prefetched rows suffice.
However, this is transparent to the application. If LOB columns are being read,
LOB locators are fetched for subsequent LOB operations to be performed on these locators.
Prefetching is turned off if LONG columns are involved.
If you call this method with the aNumberOfRowsInteger parameter set to zero,
this cancels the cursor.

Parameters:

    self (IN)
	A statement (application request) handle.

    aNumberOfRowsInteger (IN)
	Number of rows to be fetched from the current position.

    errorHandle (IN/OUT)
       An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
       for diagnostic information in the event of an error.

<return: self>
"

    self executePrimitive:[:errorHandle|
	self primFetchNumberOfRows:aNumberOfRowsInteger errorHandle:errorHandle.
    ] withErrorHandle:errorHandle.
!

getPieceInfoInto:resultArray errorHandle:errorHandle
    "get info about the next data piece for piecewise operation.
     return the in returnArray

	resultArray (OUT)
	   Array[6] getting the piece information

	errorHandle (IN/OUT)
	   An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	   for diagnostic information in the event of an error.

    <return: Symbol>"

%{  /* UNLIMITEDSTACK */

    OCIStmt * __stmtp = (OCIStmt *)__INST(address_);
    OCIError * __errorp;
    dvoid * __hndlp = 0;
    ub4 __type = 0;
    ub1 __in_out = 0;
    ub4 __iter = 0;
    ub4 __index = 0;
    ub1 __piece = 0;
    sword __ret;
    OBJ t;

    /* check if all attributes have correct type */
    if(__stmtp == 0 || !__isOciErrorHandle(errorHandle) ||
       !__isArray(resultArray) || __arraySize(resultArray) < 6
    ) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: getPieceInfo called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }

    __errorp   = (OCIError *) __externalAddressVal(errorHandle);
    __ret = OCIStmtGetPieceInfo(__stmtp, __errorp, &__hndlp, &__type, &__in_out, &__iter,
				&__index, &__piece);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	   fprintf(stderr, "OCI8Handle [info]: OCIStmtGetPieceInfo(%x) -> %x, %x, %x, %x, %x, %x\n", __stmtp, __hndlp, __type, __in_out, __iter, __index, __piece);
	} else {
	   fprintf(stderr, "OCI8Handle [warning]: OCIStmtGetPieceInfo(%x) failed\n", __stmtp);
	}
    };

    if (__ret == OCI_SUCCESS) {
	__ArrayInstPtr(resultArray)->a_element[0] = t = __MKEXTERNALADDRESS(__hndlp); __STORE(resultArray, t);
	__ArrayInstPtr(resultArray)->a_element[1] = t = __MKUINT(__type); __STORE(resultArray, t);
	__ArrayInstPtr(resultArray)->a_element[2] = (__in_out == OCI_PARAM_IN ? true : false);
	__ArrayInstPtr(resultArray)->a_element[3] = t = __MKUINT(__iter); __STORE(resultArray, t);
	__ArrayInstPtr(resultArray)->a_element[4] = t = __MKUINT(__index); __STORE(resultArray, t);
	__ArrayInstPtr(resultArray)->a_element[5] = __mkSmallInteger(__piece);
    }
    RETURN(__ociReturnSymbol(__ret));
%}.
!

piecewiseFetchNumberOfRows:aNumberOfRowsInteger pieceSize:aBufferSize errorHandle:errorHandle
    "
    picewise fetches rows from a query. The fetch call is a local call, if prefetched rows suffice. However,
    this is transparent to the application. Only some datatypes can be manipulated in pieces. Piecewise fetches
    can only performed with  of the following data types: VARCHAR2, STRING, LONG, LONG RAW.
    Prefetching is turned off if LONG columns are involved. If you call this method with the aNumberOfRowsInteger
    parameter set to zero, this cancels the cursor.

    Parameters:

	self (IN)
	    A statement (application request) handle.

	aNumberOfRowsInteger (IN)
	    Number of rows to be fetched from the current position.

	aBufferSize (IN)
	    The buffer length for the pieces.

	errorHandle (IN/OUT)
	   An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	   for diagnostic information in the event of an error.

    <return: ByteArray>
    "
    |resultHolder result status|

    resultHolder := Array new:1.

    ExecutionLock critical:[
	"first call to statement fetch must return need data signal."
	"if not reject exception"
	[
	    status := self primFetchNumberOfRows:aNumberOfRowsInteger
				     errorHandle:errorHandle.
	] doWhile:[status == OCI_STILL_EXECUTING and:[self pollWait. true]].

	(status ~~ OCI_SUCCESS and:[status ~~ OCI_NEED_DATA]) ifTrue:[
	    self handleError:status errorHandle:errorHandle.
	].

	result := #[] writeStream.
	[
	    [
		status := self primPiecewiseFetchNumberOfRows:aNumberOfRowsInteger
						   bufferSize:aBufferSize
						  errorHandle:errorHandle
						 resultHolder:resultHolder.
	    ] valueOnUnwindDo:[
		"reset the oci lib only if the statement was executed once and wasnt finished"
		"correctly"
		(status notNil and:[status ~~ OCI_SUCCESS]) ifTrue:[
		      self breakAsyncOperationWithErrorHandle:errorHandle.
		      self resetAsyncOperationWithErrorHandle:errorHandle.
		].
	    ].
	    result nextPutAll:(resultHolder at:1).
	] doWhile:[status == OCI_NEED_DATA].

	status ~~ OCI_SUCCESS ifTrue:[
	    self handleError:status errorHandle:errorHandle.
	].

    ].

    ^ result contents
!

primExecuteOn:aServiceContextHandle iterator:anIteratorInteger rowOffset:aRowOffInteger mode:aModeInteger errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCISvcCtx * __svcxtxhndlp;
    OCIStmt * __stmthndlp = (OCIStmt *)__INST(address_);
    OCIError * __errorhndlp;
    ub4 __iters;
    ub4 __rowOff;
    ub4 __mode;
    sword __ret;

    /* check if all attributes have correct type */
    if(__stmthndlp == 0 || !__isOciServiceContextHandle(aServiceContextHandle) ||
       !__isOciErrorHandle(errorHandle) || !__isInteger(anIteratorInteger) ||
       !__isInteger(aRowOffInteger) || !__isInteger(aModeInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIStmtExecute called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __svcxtxhndlp = (OCISvcCtx *) __externalAddressVal(aServiceContextHandle);
    __errorhndlp  = (OCIError *) __externalAddressVal(errorHandle);
    __iters  = __unsignedLongIntVal(anIteratorInteger);
    __rowOff = __unsignedLongIntVal(aRowOffInteger);
    __mode   = __unsignedLongIntVal(aModeInteger);

    __ret = OCIStmtExecute(__svcxtxhndlp, __stmthndlp, __errorhndlp, __iters, __rowOff,
			   0/*__snap_in*/, 0/*__snap_out*/, __mode);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtExecute(%x, %x, %d, %d, %x)\n", __svcxtxhndlp, __stmthndlp, __iters, __rowOff, __mode);
	} else if (__ret == OCI_STILL_EXECUTING){
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtExecute(%x, %x, %d, %d, %x) still executing\n", __svcxtxhndlp, __stmthndlp, __iters, __rowOff, __mode);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIStmtExecute(%x, %x, %d, %d, %x) failed\n", __svcxtxhndlp, __stmthndlp, __iters, __rowOff, __mode);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primFetchNumberOfRows:aNumberOfRowsInteger errorHandle:errorHandle

%{  /* UNLIMITEDSTACK */

    OCIStmt * __stmthndlp = (OCIStmt *)__INST(address_);
    OCIError * __errorhndlp;
    ub4 __nrows;
    sword __ret;

    /* check if all attributes have correct type */
    if(__stmthndlp == 0 || !__isOciErrorHandle(errorHandle) ||
       !__isInteger(aNumberOfRowsInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIStmtFetch called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }
    __errorhndlp = (OCIError *) __externalAddressVal(errorHandle);
    __nrows = __unsignedLongIntVal(aNumberOfRowsInteger);

    __ret = OCIStmtFetch(__stmthndlp, __errorhndlp, __nrows, OCI_FETCH_NEXT, OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtFetch(%x, %d)\n", __stmthndlp, __nrows);
	} else if (__ret == OCI_STILL_EXECUTING) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtFetch(%x, %d) still executing\n", __stmthndlp, __nrows);
	} else if (__ret == OCI_NEED_DATA) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtFetch(%x, %d) need data\n", __stmthndlp, __nrows);
	} else if (__ret == OCI_NO_DATA) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtFetch(%x, %d) no data\n", __stmthndlp, __nrows);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIStmtFetch(%x, %d) failed\n", __stmthndlp, __nrows);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primPiecewiseFetchNumberOfRows:aNumberOfRowsInteger bufferSize:aBufferSize
		   errorHandle:errorHandle resultHolder:resultArray

%{  /* UNLIMITEDSTACK */

    OCIStmt * __stmtp = (OCIStmt *)__INST(address_);
    OCIError * __errorp;
    dvoid * __hndlp = 0;
    ub4 __type = 0;
    ub1 __in_out = 0;
    ub4 __iter = 0;
    ub4 __index = 0;
    ub1 __piece = OCI_FIRST_PIECE;
    ub2 __rcodep = 0;
    ub4 __buf_size;
    ub4 __tmp_buf_size = 0;
    dvoid * __buf;
    ub4 __nrows;
    sword __ret;
    OBJ t;

    /* check if all attributes have correct type */
    if(__stmtp == 0 || !__isOciErrorHandle(errorHandle) ||
       !__isInteger(aBufferSize) || !__isInteger(aNumberOfRowsInteger) ||
       !__isArray(resultArray) || __arraySize(resultArray) < 1
    ) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIPiecewiseFetch called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }

    __errorp   = (OCIError *) __externalAddressVal(errorHandle);
    __buf_size = __unsignedLongIntVal(aBufferSize);
    __nrows    = __unsignedLongIntVal(aNumberOfRowsInteger);

    /* allocate memory */
    __buf = (dvoid *) malloc(__buf_size);
    if (!__buf) {
	if (@global(Debugging) == true){
	   fprintf(stderr, "OCI8Handle [warning]: OCIStmtPiecewiceFetch(%x) unable to alloc %d bytes", __stmtp, __buf_size);
	}
	RETURN(@global(MallocError));
    }

    __ret = OCIStmtGetPieceInfo(__stmtp, __errorp, &__hndlp, &__type, &__in_out, &__iter,
				&__index, &__piece);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	   fprintf(stderr, "OCI8Handle [info]: OCIStmtGetPieceInfo(%x) -> %x, %x, %x, %x, %x, %x\n", __stmtp, __hndlp, __type, __in_out, __iter, __index, __piece);
	} else {
	   fprintf(stderr, "OCI8Handle [warning]: OCIStmtGetPieceInfo(%x) failed\n", __stmtp);
	}
    };

    if (__ret != OCI_SUCCESS) {
	free(__buf);
	RETURN(__ociReturnSymbol(__ret));
    }

    __tmp_buf_size = __buf_size;

    __ret = OCIStmtSetPieceInfo(__hndlp, __type, __errorp, __buf, &__tmp_buf_size,
				__piece, 0, &__rcodep);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	   fprintf(stderr, "OCI8Handle [info]: OCIStmtSetPieceInfo(%x , %x, %x, %d)\n", __hndlp, __type, __piece, __tmp_buf_size);
	} else {
	   fprintf(stderr, "OCI8Handle [warning]: OCIStmtSetPieceInfo(%x , %x, %x, %d) failed\n", __hndlp, __type, __piece, __tmp_buf_size);
	}
    };

    if (__ret != OCI_SUCCESS) {
	free(__buf);
	RETURN(__ociReturnSymbol(__ret));
    }

    __ret = OCIStmtFetch(__stmtp, __errorp, __nrows, OCI_FETCH_NEXT,  OCI_DEFAULT);

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtPiecewiseFetch(%x, %d, %d)\n", __stmtp, __nrows, __tmp_buf_size);
	} else if (__ret == OCI_NEED_DATA) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtPiecewiseFetch(%x, %d, %d) need data\n", __stmtp, __nrows, __tmp_buf_size);
	} else if (__ret == OCI_NO_DATA) {
	    fprintf(stderr, "OCI8Handle [info]: OCIStmtPiecewiseFetch(%x, %d, %d) no data\n", __stmtp, __nrows, __tmp_buf_size);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIStmtPiecewiseFetch(%x, %d, %d) -> %d failed\n", __stmtp, __nrows, __tmp_buf_size, __ret);
	}
    };

    /* make from fetched piece a byte array */
    if ((__ret == OCI_SUCCESS) || (__ret == OCI_NEED_DATA)) {
	__ArrayInstPtr(resultArray)->a_element[0] = t = __MKBYTEARRAY(__buf, __tmp_buf_size);
	__STORE(resultArray, t);
    }

    free(__buf);
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8TransactionHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_TRANS));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8TransactionHandle class methodsFor:'documentation'!

documentation
"
    A transaction handle defines the transaction in which the SQL operations are
    performed. The transaction context includes user session state information,
    including the fetch state and package instantiation, if any.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8UserSessionHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_SESSION));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8UserSessionHandle class methodsFor:'documentation'!

documentation
"
    A user session handle defines a user's roles and privileges (also known as the user's
    security domain), and the operational context on which the calls execute.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8BindHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

%{ /* NOCONTEXT */
    RETURN (__MKUINT(OCI_HTYPE_BIND));
%}

    "
	self numericType
    "
! !

!OCI8Handle::OCI8BindHandle class methodsFor:'documentation'!

documentation
"
    Information about input variables is stored in bind handles. The OCI library allocates a bind
    handle for each placeholder bound with the OCIBindByName() or OCIBindByPos()
    function. The user does not need to allocate bind handles. They are implicitly allocated by
    the bind call.

    Bind and define handles are freed when the statement handle is freed or when a statement
    is prepared on the statement handle.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!OCI8Handle::OCI8BindHandle methodsFor:'obsolete'!

primBind:aNameOrPos statementHandle:aStatementHandle dataBuffer:aDataBuffer dataSize:aDataSize
    dataType:aDataTypeInteger nullValueIndicator:anIndicatorArray
    elementLengthArray:anElementLengthArray returnCodeArray:aReturnCodeArray
    mode:aModeInteger errorHandle:anErrorHandle

    "
	Returns:
	    Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

	<return: Symbol>
    "

%{  /* UNLIMITEDSTACK */

    OCIBind * __bindpp = (OCIBind *)__INST(address_);
    OCIStmt * __stmtp;
    OCIError * __errorp;
    dvoid * __valuep  = 0;
    dvoid * __indicatorp = 0;
    ub2 * __elementlengthp = 0;
    ub2 * __returncodep = 0;
    text *__name;
    sb4 __namelen;
    sb4 __value_sz = 0;
    ub2 __datatype;
    ub4 __mode;
    sword __ret;

    /* check if all attributes have correct type */
    if(!__isOciStatementHandle(aStatementHandle) || !__isOciErrorHandle(anErrorHandle) ||
       !__isSmallInteger(aDataTypeInteger) || !__isInteger(aModeInteger)) {
	if (@global(Debugging) == true){
	    fprintf(stderr, "OCI8Handle [error]: OCIBindByName called with wrong attributes.\n");
	}
	RETURN(@global(ArgumentError));
    }

    if (aDataBuffer != nil) {
	if (! __isExternalBytes(aDataBuffer)) {
	    if (@global(Debugging) == true){
		fprintf(stderr, "OCI8Handle [error]: bind buffer in OCIBindByName must be an external bytes object\n");
	    }
	    RETURN(@global(ArgumentError));
	}
	__valuep = (dvoid *)__externalBytesAddress(aDataBuffer);
    }
    if (aDataSize != nil) {
	if (! __isInteger(aDataSize)) {
	    if (@global(Debugging) == true){
		fprintf(stderr, "OCI8Handle [error]: data size in OCIBindByName must be an integer\n");
	    }
	    RETURN(@global(ArgumentError));
	}
	__value_sz = __longIntVal(aDataSize);
    }
    if (anIndicatorArray != nil) {
	if (! __isExternalBytes(anIndicatorArray)) {
	    if (@global(Debugging) == true){
		fprintf(stderr, "OCI8Handle [error]: indicator array in OCIBindByName must be an external bytes object\n");
	    }
	    RETURN(@global(ArgumentError));
	}
	__indicatorp = (dvoid *) __externalBytesAddress(anIndicatorArray);
    }
    if (aReturnCodeArray != nil) {
	if(! __isExternalBytes(aReturnCodeArray)) {
	    if (@global(Debugging) == true){
		fprintf(stderr, "OCI8Handle [error]: return-code array in OCIBindByName must be an external bytes object\n");
	    }
	    RETURN(@global(ArgumentError));
	}
	__returncodep = (ub2 *) __externalBytesAddress(aReturnCodeArray);
    }
    if (anElementLengthArray != nil) {
	if (! __isExternalBytes(aReturnCodeArray)) {
	    if (@global(Debugging) == true){
		fprintf(stderr, "OCI8Handle [error]: element length array in OCIBindByName must be an external bytes object\n");
	    }
	    RETURN(@global(ArgumentError));
	}
	__elementlengthp = (ub2 *) __externalBytesAddress(anElementLengthArray);
    }

    __stmtp    = (OCIStmt *) __externalAddressVal(aStatementHandle);
    __errorp   = (OCIError *) __externalAddressVal(anErrorHandle);
    __datatype = (ub2) __intVal(aDataTypeInteger);
    __mode = (ub4) __longIntVal(aModeInteger);

    if (__isInteger(aNameOrPos)) {
	__ret = OCIBindByPos(__stmtp, &__bindpp, __errorp, __intVal(aNameOrPos),
			      __valuep, __value_sz, __datatype, __indicatorp, __elementlengthp,
			      __returncodep,
			      (ub4) 0,   /* only for PL/SQL binds */
			      (ub4 *) 0, /* only for PL/SQL binds */
			       __mode);

    } else if (__isStringLike(aNameOrPos)) {
	__name = (text *) __stringVal(aNameOrPos);
	__namelen = __stringSize(aNameOrPos);
	__ret = OCIBindByName(__stmtp, &__bindpp, __errorp, __name, __namelen,
			      __valuep, __value_sz, __datatype, __indicatorp, __elementlengthp,
			      __returncodep,
			      (ub4) 0,   /* only for PL/SQL binds */
			      (ub4 *) 0, /* only for PL/SQL binds */
			       __mode);

    } else {
	RETURN(@global(ArgumentError));
    }


    if (__ret == OCI_SUCCESS) {
	__INST(address_) = (OBJ)__bindpp;
    }

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIBind(%x, %d, %d) -> %x\n", __stmtp, __datatype, __value_sz, __bindpp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIBindByName(%x, %d, %d) failed\n", __stmtp, __value_sz, __datatype);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle::OCI8BindHandle methodsFor:'primitives'!

bindDynamic:callbackContext errorHandle:errorHandle
"
used to register user-defined callback functions for providing or receiving data if #'OCI_DATA_AT_EXEC'
mode was specified in a previous call to OCI8Lib>>ociBindByName:bindHandle:cType:buffer:bufferSize:name:nullValueIndicator:elementLengthArray:returnCodeArray:mode:errorOCIHandle:.

The callback function pointers must return #'OCI_CONTINUE' if it the call is successful. Any return code
other than #'OCI_CONTINUE' signals that the client wishes to abort processing immediately.

When passing the address of a storage area, make sure that the storage area will exist even after
the application returns from the callback. This means that you should not allocate such storage on the stack.

Parameters:

   anOCI8BindHandle (IN)
       An address of a bind handle. The bind handle maintains all the bind information for this particular input value.

   anOCI8CallBackData (IN)
       Provides the callback function pointers and handles the allocation and deallocation of storage area
       needed by the callback functions. (See OCI8CallBackData documentation for more information.)

   anOCI8ErrorHandle (IN/OUT)
       An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
       for diagnostic information in the event of an error.

<return: self>
"
   ^ self executePrimitive:[:errorHandle|
       self primBindDynamicIn:callbackContext
			  out:callbackContext
		   errorHandle:errorHandle.
   ] withErrorHandle:errorHandle.
!

primBind:aNameOrPos
    statementHandle:aStatementHandle
    errorHandle:anErrorHandle
    elementSize:elementSize                  "maximum size of a single value"
    mode:aModeInteger                        "may be OCI_DATA_AT_EXEC"
    dataType:aDataTypeInteger                "OCI C-Datatype of buffer"
    dataBuffer:aDataBuffer                   "data buffer, nil if dynamic bind"
    numberOfElements:numberOfElements        "number of values in buffer, nil if dynamic bind"
    controlData:controlData                  "nil if dynamic bind"

    "
	Returns:
	    Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

	<return: Symbol>
    "

%{  /* UNLIMITEDSTACK */

    OCIBind * __bindpp = (OCIBind *)__INST(address_);
    OCIStmt * __stmtp;
    OCIError * __errorp;
    dvoid * __valuep  = 0;
    sb2 * __indicatorp = 0;
    ub2 * __elementlengthp = 0;
    ub2 * __returncodep = 0;
    int __numberOfElements;
    text *__name;
    sb4 __namelen;
    sb4 __value_sz = 0;
    ub2 __datatype;
    ub4 __mode;
    sword __ret;

    /* check if all attributes have correct type */
    if(!__isOciStatementHandle(aStatementHandle) || !__isOciErrorHandle(anErrorHandle) ||
       !__isSmallInteger(aDataTypeInteger) || !__isInteger(aModeInteger)) {
	__ociDebugBreakPoint__();
fprintf(stderr, "1\n");
	RETURN(@global(ArgumentError));
    }
    if (!__isSmallInteger(elementSize)) {
	__ociDebugBreakPoint__();
fprintf(stderr, "2\n");
	RETURN(@global(ArgumentError));
    }
    __value_sz = __smallIntegerVal(elementSize);
    __numberOfElements = __smallIntegerVal(numberOfElements);

    if (aDataBuffer != nil) {
	/* Databuffer supplied, so this is not an dynamic bind */
	if (! __isExternalBytes(aDataBuffer)) {
	    __ociDebugBreakPoint__();
fprintf(stderr, "3\n");
	    RETURN(@global(ArgumentError));
	}
	if (__smallIntegerVal(__externalBytesSize(aDataBuffer)) < __value_sz*__numberOfElements) {
	    __ociDebugBreakPoint__();
fprintf(stderr, "4\n");
	    RETURN(@global(ArgumentError));
	}
	__valuep = (dvoid *)__externalBytesAddress(aDataBuffer);

	if (!__isSmallInteger(numberOfElements)) {
	    __ociDebugBreakPoint__();
fprintf(stderr, "5\n");
	    RETURN(@global(ArgumentError));
	}
	__numberOfElements = __smallIntegerVal(numberOfElements);

	if (! __isExternalBytes(controlData)) {
	    __ociDebugBreakPoint__();
fprintf(stderr, "6\n");
	    RETURN(@global(ArgumentError));
	}
	if (__smallIntegerVal(__externalBytesSize(controlData)) != (sizeof(sb2)+sizeof(ub2)*2)*__numberOfElements) {
	    __ociDebugBreakPoint__();
fprintf(stderr, "7\n");
	    RETURN(@global(ArgumentError));
	}
	__indicatorp = (sb2 *) __externalBytesAddress(controlData);
	__elementlengthp = (ub2 *) __indicatorp + __numberOfElements;
	__returncodep = __elementlengthp + __numberOfElements;
    }

    __stmtp    = (OCIStmt *) __externalAddressVal(aStatementHandle);
    __errorp   = (OCIError *) __externalAddressVal(anErrorHandle);
    __datatype = (ub2) __smallIntegerVal(aDataTypeInteger);
    __mode = (ub4) __longIntVal(aModeInteger);

    if (__isSmallInteger(aNameOrPos)) {
	__ret = OCIBindByPos(__stmtp, &__bindpp, __errorp, __smallIntegerVal(aNameOrPos),
			      __valuep, __value_sz, __datatype, __indicatorp, __elementlengthp,
			      __returncodep,
			      (ub4) 0,   /* only for PL/SQL binds */
			      (ub4 *) 0, /* only for PL/SQL binds */
			       __mode);

    } else if (__isStringLike(aNameOrPos)) {
	__name = (text *) __stringVal(aNameOrPos);
	__namelen = __stringSize(aNameOrPos);
	__ret = OCIBindByName(__stmtp, &__bindpp, __errorp, __name, __namelen,
			      __valuep, __value_sz, __datatype, __indicatorp, __elementlengthp,
			      __returncodep,
			      (ub4) 0,   /* only for PL/SQL binds */
			      (ub4 *) 0, /* only for PL/SQL binds */
			       __mode);

    } else {
fprintf(stderr, "aNameOrPos\n");
	__ociDebugBreakPoint__();
	RETURN(@global(ArgumentError));
    }


    if (__ret == OCI_SUCCESS) {
	__INST(address_) = (OBJ)__bindpp;
    }

    if (@global(Debugging) == true){
	if (__ret == OCI_SUCCESS) {
	    fprintf(stderr, "OCI8Handle [info]: OCIBind(%x, %d, %d) -> %x\n", __stmtp, __datatype, __value_sz, __bindpp);
	} else {
	    fprintf(stderr, "OCI8Handle [warning]: OCIBindByName(%x, %d, %d) failed\n", __stmtp, __value_sz, __datatype);
	}
    };
    RETURN(__ociReturnSymbol(__ret));
%}.
!

primBindDynamicIn:inCallbackIndex out:outCallbackIndex errorHandle:errorHandle
"
used to register user-defined callback functions for providing or receiving data if #'OCI_DATA_AT_EXEC'
mode was specified in a previous call to OCI8Lib>>ociBindByName:bindHandle:cType:buffer:bufferSize:name:nullValueIndicator:elementLengthArray:returnCodeArray:mode:errorOCIHandle:.

The callback function pointers must return #'OCI_CONTINUE' if it the call is successful. Any return code
other than #'OCI_CONTINUE' signals that the client wishes to abort processing immediately.

When passing the address of a storage area, make sure that the storage area will exist even after
the application returns from the callback. This means that you should not allocate such storage on the stack.

Parameters:

    aBindHandle (IN)
	An address of a bind handle. The bind handle maintains all the bind information for this particular input value.

    anInOCICallBackContext (IN)
	a SmallInteger to associate this call

    anOutOCICallBackContext (IN)
	a SmallInteger to associate this call

    anErrorHandle (IN/OUT)
	An error handle you can pass to OCI8Lib class>>errorStringForHandle:status:
	for diagnostic information in the event of an error.

Returns:
    Symbol indicating the status of the operation (OCI_SUCCESS, OCI_ERROR, ....)

<return: Symbol>
"

%{  /* UNLIMITEDSTACK */

    sword __ret;
    OCIBind * __bindp = (OCIBind *)__INST(address_);
    OCIError * __errorp;

#define returnc return/*define this to avoid stc Warnings*/
/*
 * this is an OCI callback.
 * The caller requests a data buffer with data to be written to
 * a database cell
 */

sb4
__ociInBindCallback(dvoid *ctxp, OCIBind *bindp, ub4 iter, ub4 index,
		    dvoid **bufpp, ub4 *alenp, ub1 *piecep, dvoid **indpp)
{
    static struct inlineCache cb = _ILC3;
    OBJ __retArray, __val;
    sb2 __indicator = 0;

    __retArray = (*cb.ilc_func)(SQL__OCI8Handle__OCI8VariableHandle,
			   @symbol(inBindCallback:iter:index:), nil, &cb,
			   ctxp, __mkSmallInteger(iter), __mkSmallInteger(index));
    if (__retArray == nil) {
	/* this is an expected RETURN with OCI_ERROR */
	returnc(OCI_ERROR);
    }

    if (!__isArray(__retArray) || __arraySize(__retArray) < 4) {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }

    *indpp = (dvoid *) & __indicator;

    /*
     * The array[0] is the buffer.
     * Set the lenth as well.
     */
    __val = __ArrayInstPtr(__retArray)->a_element[0];
    if (__isStringLike(__val)) {
	*bufpp = (dvoid *)__stringVal(__val);
	*alenp = (ub4)__stringSize(__val);
    } else if (__isByteArray(__val)) {
	*bufpp = (dvoid *)__byteArrayVal(__val);
	*alenp = (ub4)__byteArraySize(__val);
    } else if (__isExternalBytes(__val)) {
	*bufpp = (dvoid *)__externalBytesAddress(__val);
	*alenp = (ub4)__externalBytesSize(__val);
    } else if (__val == nil) {
	__indicator = -1;
    } else {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }

    /*
     * array[1] is the length of the data in the buffer
     * or nil (which means:the whole buffer)
     */
    __val = __ArrayInstPtr(__retArray)->a_element[1];
    if (__isSmallInteger(__val)) {
	*alenp = (ub4)__smallIntegerVal(__val);
    } else if (__val != nil) {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }

    /*
     * array[2] is an integer: OCI_ONE_PIECE, OCI_FIRST_PIECE, OCI_NEXT_PIECE
     * or OCI_LAST_PIECE
     */
    __val = __ArrayInstPtr(__retArray)->a_element[2];
    if (!__isSmallInteger(__val)) {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }
    *piecep = (ub1)__smallIntegerVal(__val);

    returnc(OCI_CONTINUE);
}


/*
 * this is an OCI callback.
 * The caller requests a data buffer.
 * The contents of a database cell will be written into this buffer.
 */

sb4
__ociOutBindCallback(dvoid *ctxp, OCIBind *bindp, ub4 iter, ub4 index,
		     dvoid **bufpp, ub4 **alenpp, ub1 *piecep, dvoid **indpp,
		     ub2 **rcodepp)
{
    static struct inlineCache cb = _ILC4;
    OBJ __retArray, __val;
    ub4 __alen;

    __retArray = (*cb.ilc_func)(SQL__OCI8Handle__OCI8VariableHandle,
			   @symbol(outBindCallback:iter:index:piece:), nil, &cb,
			   ctxp, __mkSmallInteger(iter), __mkSmallInteger(index),
			   __mkSmallInteger(*piecep));
    if (__retArray == nil) {
	/* this is an expected RETURN with OCI_ERROR */
	returnc(OCI_ERROR);
    }

    if (!__isArray(__retArray) || __arraySize(__retArray) < 4) {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }

    /*
     * The array[0] is the buffer.
     * Set the lenth as well.
     */
    __val = __ArrayInstPtr(__retArray)->a_element[0];
    if (__isString(__val)) {
	*bufpp = (dvoid *)__stringVal(__val);
	__alen = (ub4)__stringSize(__val);
    } else if (__isByteArray(__val)) {
	*bufpp = (dvoid *)__byteArrayVal(__val);
	__alen = (ub4)__byteArraySize(__val);
    } else if (__isExternalBytes(__val)) {
	*bufpp = (dvoid *)__externalBytesAddress(__val);
	__alen = (ub4)__externalBytesSize(__val);
    } else {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }

    /*
     * array[1] is an ByteArray used to RETURN the result status.
     * (sb2 indicator, ub2 rcode, ub4 alen)
     */
    __val = __ArrayInstPtr(__retArray)->a_element[1];
    if (!__isByteArray(__val) ||
	__byteArraySize(__val) < sizeof(ub4)+sizeof(ub2)+sizeof(ub2)) {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }
    *indpp    = (dvoid *)__byteArrayVal(__val);
    *rcodepp  = (ub2 *)((sb2 *)*indpp + 1);
    *alenpp   = (ub4 *)(*rcodepp + 1);

    **alenpp = __alen;

    /*
     * array[2] is an integer: OCI_ONE_PIECE, OCI_FIRST_PIECE, OCI_NEXT_PIECE
     * or OCI_LAST_PIECE
     */
    __val = __ArrayInstPtr(__retArray)->a_element[2];
    if (!__isSmallInteger(__val)) {
	__ociDebugBreakPoint__();
	returnc(OCI_ERROR);
    }
    *piecep = (ub1)__smallIntegerVal(__val);

    returnc(OCI_CONTINUE);
}
#undef returnc

    /*
     * End of local definitions
     */

    /* check if all attributes have correct type */
    if(__bindp == 0 || !__isOciErrorHandle(errorHandle) ||
       !__bothSmallInteger(inCallbackIndex, outCallbackIndex)) {
	RETURN(@global(ArgumentError));
    }
    __errorp   = (OCIError *) __externalAddressVal(errorHandle);

    __ret = OCIBindDynamic(__bindp, __errorp,
			   (dvoid *) inCallbackIndex,
			   (dvoid *) __ociInBindCallback,
			   (dvoid *) outCallbackIndex,
			   (dvoid *) __ociOutBindCallback);

    RETURN(__ociReturnSymbol(__ret));
%}.
! !

!OCI8Handle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8Handle.st,v 1.29 2010-10-11 12:00:05 cg Exp $'
! !

OCI8Handle initialize!
