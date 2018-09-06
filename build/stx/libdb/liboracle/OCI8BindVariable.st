"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8Variable subclass:#OCI8BindVariable
	instanceVariableNames:'name needsBind maxElementSize setup value'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8BindVariable primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include <oci.h>
#include <xa.h>
#include <stdio.h>

/*  internal/external datatype codes */
#define VARCHAR2_TYPE           SQLT_CHR
#define NUMBER_TYPE             SQLT_NUM
#define INTEGER_TYPE            SQLT_INT
#define FLOAT_TYPE              SQLT_FLT
#define STRING_TYPE             SQLT_STR
#define VARNUM_TYPE             SQLT_VNU
#define LONG_TYPE               SQLT_LNG
#define VARCHAR_TYPE            SQLT_VCS
#define ROWID_TYPE              SQLT_RID
#define DATE_TYPE               SQLT_DAT
#define VARRAW_TYPE             SQLT_VBI
#define RAW_TYPE                SQLT_BIN
#define LONG_RAW_TYPE           SQLT_LBI
#define UNSIGNED_INT_TYPE       SQLT_UIN
#define LONG_VARCHAR_TYPE       SQLT_LVC
#define LONG_VARRAW_TYPE        SQLT_LVB
#define CHAR_TYPE               SQLT_AFC
#define CHARZ_TYPE              SQLT_AVC
#define ROWID_DESC_TYPE         SQLT_RDD
#define NAMED_DATA_TYPE         SQLT_NTY
#define REF_TYPE                SQLT_REF
#define CHARACTER_LOB_TYPE      SQLT_CLOB
#define BINARY_LOB_TYPE         SQLT_BLOB
#define BINARY_FILE_TYPE        SQLT_FILE
#define OCI_STRING_TYPE         SQLT_VST
#define OCI_DATE_TYPE           SQLT_ODT
%}

! !

!OCI8BindVariable class methodsFor:'documentation'!

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
    Abstract superclass for bind variables. They are used to bind an variable in a statement
    to external buffers. Three subclasses handle the insert of values into the database:

	OCI8MultipleValueBindVariable
		Used, if an array should be insert into the database. More then one value
		is given for each bind variable.

	OCI8ReturnValueBindVariable
		Used for variables in a returning clause of a statement. The data is
		fetched via callback functions.

	OCI8SingleValueBindVariable
		Used, if one value for each bind variable should be insert into the database.

    Each bind variable represent one variable in the statement text.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8MultipleValueBindVariable
	OCI8ReturnValueBindVariable
	OCI8SingleValueBindVariable
	OCI8Variable

    [instance variables:]

	name <Symbol>
	    holds the name of the bind variable. It must be exactly the same
	    as the name of the placeholder in the statement.

	needsBind <Boolean>
	    holds if the variable must be binded

	maxElementSize <Integer>
	   holds the maximal size of a element in the value instance variables.

	setup <Boolean>
	    holds if the variables needs a set up. All buffers of the receiver must be
	    initialized then. This is set to true if a new values is added to the variable.
	    Then all buffers must be reinitialized.

	value <Object>
	    holds the value of the variable. This value is written into
	    the data buffer. (Null values are handles via the indicator array).

    [class variables:]
	none
"
! !

!OCI8BindVariable methodsFor:'accessing'!

elementSize
"
returns the lenght of each element in the data buffer which is equal the
size of the longest element in the data buffer.

<return: Integer>
"
    ^self maxElementSize



!

maxElementSize
"
returns the maximal size of the values.

<return: Integer>
"
    ^ maxElementSize
!

maxElementSize:anInteger
"
sets the maximal size of the values.

<return: self>
"

    maxElementSize := anInteger.
!

name
"
returns the name of the bind variable. It must be exactly the same
as the name of the placeholder in the statement.

<return: Symbol>
"

    ^ name
!

name:aSymbol
"
sets the name of the bind variable. It must be exactly the same
as the name of the placeholder in the statement.

<return: self>
"

    name := aSymbol.
!

needsBind
"
returns if the variables must be binded

<return: Boolean>
"
    needsBind isNil ifTrue:[
	needsBind := true
    ].
    ^ needsBind
!

needsBind:aBoolean
"
sets if the variables must be binded

<return: self>
"
    needsBind := aBoolean.
!

numberOfElements
"
returns the number of elements which are stored in the value of the
receiver.

<return: Integer>
"
    self subclassResponsibility
!

setup
"
returns if the variables is set up.
All buffers of the receiver must be initialized then.

<return: Boolean>
"

    setup isNil ifTrue:[
	setup := false
    ].
    ^setup
!

setup:aBoolean
"
sets if the variables needs a set up.
All buffers of the receiver must be initialized then. This is set to true
if a new values is added to the receiver. Then all buffers must
be reinitialized.

<return: self>
"

    setup := aBoolean.
!

value
"
returns the value of the receiver. This value is written into
the data buffer. (Null values are handles via the indicator array).

<return: Object>
"
    ^ value
! !

!OCI8BindVariable methodsFor:'binding'!

bindForStatement:anOCI8Statement
"
bind the receiver with buffers and OCI_DEFAULT mode

<return: self>
"
    self handle bind:self name
		  statementHandle:anOCI8Statement handle
		       cType:self externalCType
		      buffer:self dataBuffer
		  bufferSize:self elementSize
	      nullValueIndicator:self indicatorArray
	      elementLengthArray:self elementLengthArray
	     returnCodeArray:self returnCodeArray
			mode:self mode
	      errorHandle:anOCI8Statement errorHandle.
! !

!OCI8BindVariable methodsFor:'constants'!

handleType
"
default handle type for the bind variable. If using another mode, the given oci session,
statement mechanismen cannot be used.

<return: Symbol>
"
    ^#OCI8BindHandle.
!

mode
"
default mode for the bind variable. If using another mode, the given oci session,
statement mechanismen cannot be used.

<return: Symbol>
"
    ^#'OCI_DEFAULT'

! !

!OCI8BindVariable methodsFor:'converting'!

convertToExternalCTypeValue:aValue
"
converts the value aValue and returns it. The external c type of
the converter determines the conversion. The converted value is later copied
into the external bytes. Nil values must be handled via the indicator array.
Dont call this method with nil values.

<return: ByteArray|String>
"
    ^self converter convertToCTypeValue:aValue.
!

copyValue:aValue toBuffer:aBuffer withOffset:anOffset valueSize:aSize externalCType:anExternalCDataType
"
copies the value aValue to the buffer aBuffer. The symbol anExternalCDataType determines the conversion
of the value.

<return: self>
"

    |type errorSymbol|

    type := OCI8Handle numericValueForCDataType:anExternalCDataType.

%{
	dvoid * __valuep;
	sb4 __value_sz = (sb4) __smallIntegerVal(aSize);
	ub2 __datatype = (ub2) __smallIntegerVal(type);
	int __offset = __smallIntegerVal(anOffset);
	dvoid * __bindbufferp;
	int __int_value;
	int __sizeWanted;
	double __double_value;

	if (!__bothSmallInteger(aSize, anOffset) || !__isSmallInteger(anOffset) ||
	    !__isExternalBytes(aBuffer) ||
	     __offset + __value_sz > __smallIntegerVal(__externalBytesSize(aBuffer))) {
		goto badArg;
	}

	switch (__datatype) {

	    case STRING_TYPE:
		/* 0-terminated strings only */
		if (__isString(aValue) || __isSymbol(aValue)) {
		    __valuep = (text *)__stringVal(aValue);
		    break;
		}
		/* no byteArray allowed here (0-termination req'd */
		goto badArg;

	    case LONG_RAW_TYPE:
	    case RAW_TYPE:
		/* strings or byteArrays */
		if (__isString(aValue) || __isSymbol(aValue)) {
		    __valuep = __stringVal(aValue);
		    break;
		}
		if (__isByteArray(aValue)) {
		    __valuep = __ByteArrayInstPtr(aValue)->ba_element;
		    break;
		}
		goto badArg;

	    case INTEGER_TYPE:
		/* integer */
		__valuep = (dvoid *)(&__int_value);
		if (__isSmallInteger(aValue)) {
		    __int_value = __intVal(aValue);
		    break;
		}
		if ((__int_value = __signedLongIntVal(aValue)) != 0) {
		    break;
		}
		goto badArg;

	    case FLOAT_TYPE:
		/* float */
		__valuep = (dvoid *)(&__double_value);

		if (__isSmallInteger(aValue)) {
		    __double_value = (double) __intVal(aValue);
		    break;
		}
		if ((__int_value = __longIntVal(aValue)) != 0) {
		    __double_value = (double) __int_value;
		    break;
		}
		if (__isFloat(aValue)) {
		    __double_value = __floatVal(aValue);
		    break;
		}
		if (__isShortFloat(aValue)) {
		    __double_value = (double) __shortFloatVal(aValue);
		    break;
		}
		goto badArg;

	    case DATE_TYPE:
	    case VARNUM_TYPE:
		/* byteArray */
		if (__isByteArray(aValue)) {
		    __valuep = __ByteArrayInstPtr(aValue)->ba_element;
		    break;
		}
		goto badArg;

	    default:
		if (@global(OCI8Lib:Debugging) == true){
		    fprintf(stderr, "OCI8Lib [warning]: unhandled data type: %d\n",__datatype);
		}
		errorSymbol = @symbol(OCIUnhandledAttributeType);
		goto error;

	}

	__bindbufferp = __externalBytesAddress(aBuffer) + __offset;
	memcpy(__bindbufferp, __valuep, __value_sz);
	RETURN(self);

badArg:
	if (@global(OCI8Lib:Debugging) == true) {
	    fprintf(stderr, "OCI8Lib [warning]: data type mismatch: %d\n",__datatype);
	}
	errorSymbol = @symbol(OCIInvalidAttributeType);
error:;
%}.

    (Smalltalk classNamed:errorSymbol) raise.
!

sizeFor:aValue externalCType:anExternalCDataType
"
returns the size for a data buffer for the value aValue and type anExternalCDataType.
Possible types are:
    STRING_TYPE   - the value aValue must be a string, the size of the string + 1 is returned
    LONG_RAW_TYPE - the value aValue must be a string or a byte array, the size of the string or
		    the byte array size is returned
    RAW_TYPE      - the value aValue must be a string or a byte array, the size of the string or
		    the byte array size is returned
    INTEGER_TYPE  - the value aValue must be a small integer, the size of a c type int is returned
    FLOAT_TYPE    - the value aValue must be a small integer, long intger, float or short float,
		    the size of a c type float is returned.
    VARNUM_TYPE   - the value aValue must be a byte array, the size of the byte array size is returned

<return: Integer>
"
    |type errorSymbol|

    type := OCI8Handle numericValueForCDataType:anExternalCDataType.

%{

    sb4 __value_sz;
    ub2 __datatype  = (ub2) __longIntVal(type);
    int __sizeWanted;

    switch (__datatype) {

	case STRING_TYPE:
	    /* 0-terminated strings only */
	    if (__isString(aValue) || __isSymbol(aValue)) {
		__value_sz = __stringSize(aValue) + 1;
		break;
	    }
	    /* no byteArray allowed here 0-termination req'd */
	    goto badArg;

	case LONG_RAW_TYPE:
	case RAW_TYPE:
	    /* strings or byteArrays */
	    if (__isString(aValue) || __isSymbol(aValue)) {
		__value_sz = __stringSize(aValue);
		break;
	    }
	    if (__isByteArray(aValue)) {
		__value_sz = __byteArraySize(aValue);
		break;
	    }
	    goto badArg;

	case INTEGER_TYPE:
	    /* integer */
	    __value_sz = sizeof(int);
	    if (__isSmallInteger(aValue)) {
		break;
	    }
	    if (__signedLongIntVal(aValue) != 0) {
		break;
	    }
	    goto badArg;

	case FLOAT_TYPE:
	    /* float */
	    __value_sz = sizeof(double);

	    if (__isSmallInteger(aValue)) {
		break;
	    }
	    if (__longIntVal(aValue) != 0) {
		break;
	    }
	    if (__isFloat(aValue)) {
		break;
	    }
	    if (__isShortFloat(aValue)) {
		break;
	    }
	    goto badArg;

	case VARNUM_TYPE:
	case DATE_TYPE:
	    /* byte array */
	    if (__isByteArray(aValue)) {
		__value_sz = __byteArraySize(aValue);
		break;
	    }
	    goto badArg;

	badArg:
	    if (@global(OCI8Lib:Debugging) == true) {
		fprintf(stderr, "OCI8Lib [warning]: data type mismatch: %d\n",__datatype);
	    }
	    errorSymbol = @symbol(OCIInvalidAttributeType);
	    goto error;

	default:
	    if (@global(OCI8Lib:Debugging) == true){
		fprintf(stderr, "OCI8Lib [warning]: unhandled data type: %d\n",__datatype);
	    }
	    errorSymbol = @symbol(OCIUnhandledAttributeType);
	    goto error;

    }

    RETURN(__MKSMALLINT(__value_sz));

    error:;
%}.

    (Smalltalk classNamed:errorSymbol) raise.
! !

!OCI8BindVariable methodsFor:'setup'!

setupForStatement:anOCI8Statement
"
sets up all necassary buffers for the receiver and copies
the value to the external bytes buffer.

<return: self>
"
    self isSetup ifFalse:[
	self setupIndicatorArray.
	self setupReturnCodeArray.
	self setupExternalBytes.
	self setupElementLengthArray.
	self setup:true.
	self needsBind ifTrue:[
	    self bindForStatement:anOCI8Statement.
	].
    ].



!

setupIndicatorArray
"
sets up the indicator array of the receiver.

<return: self>
"
    self subclassResponsibility
! !

!OCI8BindVariable methodsFor:'testing'!

isSetup
"
returns if the receiver is already set up.
This means the external bytes are set up for the current value(s) of the
receiver. If the value(s) of the receiver changes the setup state switch
to false.

<return: Boolean>
"

    ^ self setup
! !

!OCI8BindVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8BindVariable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
