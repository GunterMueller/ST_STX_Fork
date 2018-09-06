"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

Object subclass:#OCI8Variable
	instanceVariableNames:'converter dataBuffer elementLengthArray handle indicatorArray
		returnCodeArray'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8Variable class methodsFor:'documentation'!

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
    Subclasses of this abstract class are OCI8BindVariable and OCI8DefineVariable.
    OCI8BindVariable defines variables from which values are insert into the database.
    OCI8DefineVariable are variables which are filled with the values fron the database.
    Common behaviour for the two subclasses is implemented here.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8BindVariable
	OCI8DefaultDefineVariable
	OCI8DefineVariable
	OCI8DynamicDefineVariable
	OCI8MultipleValueBindVariable
	OCI8ReturnValueBindVariable
	OCI8SingleValueBindVariable

    [instance variables:]

	converter <OCI8Converter>
	    The external c type of the converter determines the conversion of the values
	    in the data buffer. For bind variables the converted values represented by the
	    bind varaibles are copied into the databuffer. For define variables the values in
	    the datas buffer are converted into the correct smalltalk type. The subclasses
	    of OCI8Converter determine the conversion parameters.

	dataBuffer <ExternalBytes|ByteArray|nil>
	    for bind variables the values in the data are insert into the
	    database. For define variables they represent the returned values.
	    Nil values are handled via the indicator array.

	elementLengthArray <ExternalBytes|nil>
	    the values represents the lenght for the corresponding value in the
	    data buffer.

	handle <OCI8Handle>
	    holds the external address (handle) and type (a symbol)
	    for the oci handle

	indicatorArray <ExternalBytes|nil>
	    the values in this buffer indicate if the corresponding value in the
	    data buffer is a null value. Null values are indicated with an -1.
	    Not null values with 0.

	returnCodeArray <ExternalBytes|nil>
	    the values represents the return codes for the corresponding value in the
	    data buffer. For exapmle an error code is set here, if a values has been
	    truncated.

    [class variables:]
	none
"
! !

!OCI8Variable methodsFor:'accessing'!

converter
"
returns a converter needed for the bind operation of the receiver.

<return: OCI8ByteArrayConverter|OCI8DateConverter|OCI8FixedPointConverter|OCI8FloatConverter|OCI8IntegerConverter>
"

    ^ converter
!

converter:anOCI8Converter
"
sets a converter needed for the bind operation of the receiver.
Possible converters are:
    OCI8ByteArrayConverter
    OCI8DateConverter
    OCI8FixedPointConverter
    OCI8FloatConverter
    OCI8IntegerConverter

<return: self>
"

    converter := anOCI8Converter.
!

dataBuffer
"
returns the buffer where the values for the receiver are insert
from the oci c functions.

<return: ExternalBytes|ByteArray|nil>
"
    ^dataBuffer


!

dataBuffer:anExternalBytes
"
sets the buffer where the values for the receiver are insert
from the oci c functions.

<return: self>
"
    dataBuffer := anExternalBytes.
    self reRegisterForFinalization.


!

dataBufferSize
"
returns the size of the buffer

<return: Integer>
"
    dataBuffer isNil ifTrue:[^0].
    ^dataBuffer size


!

elementLengthArray
"
returns the buffer where the lenght of the values for the receiver are insert
from the oci c functions.

<return: ExternalBytes|nil>
"
    ^ elementLengthArray

!

elementLengthArray:anExternalBytesOrNil
"
sets the buffer where the lenght of the values for the receiver are insert
from the oci c functions.

<return: self>
"

    elementLengthArray := anExternalBytesOrNil.
    elementLengthArray atAllPut:0.
    self reRegisterForFinalization.
!

externalCType
"
returns the symbol needed for the bind operation of the receiver.

<return: Symbol>
"
    ^ self converter externalCType

!

getValue
"
access the data form the external bytes aBuffer.

<return: String|Integer|Float|ByteArray|nil>
"
    ^self getDataFromBuffer:self dataBuffer
	     indicatorArray:self indicatorArray





!

handle
    "return the value of the instance variable 'handle' (automatically generated)"

    handle isNil ifTrue:[
	handle := OCI8Handle newHandleWithType:self handleType
    ].
    ^ handle
!

indicatorArray
"
returns the buffer which indicates if its a null value for the receiver.
The values are insert from the oci c functions.

<return: ExternalBytes|nil>
"

    ^ indicatorArray
!

indicatorArray:anExternalBytes
"
sets the buffer which indicates if its a null value for the receiver.
The values are insert from the oci c functions.

<return: self>
"

    indicatorArray := anExternalBytes.
    indicatorArray atAllPut:0.
    self reRegisterForFinalization.
!

returnCodeArray
"
returns the buffer which holds the return values for the values receiver.
The values are insert from the oci c functions.

<return: ExternalBytes|nil>
"

    ^ returnCodeArray

!

returnCodeArray:anExternalBytes
"
sets the buffer which holds the return values for the values receiver.
The values are insert from the oci c functions.

<return: ExternalBytes|nil>
"

    returnCodeArray := anExternalBytes.
    returnCodeArray atAllPut:0.
    self reRegisterForFinalization.
! !

!OCI8Variable methodsFor:'buffer accessing'!

getDataFromBuffer:aBuffer indicatorArray:anIndicatorArray
    "access the data form the external bytes aBuffer. The value is stored there in the
     external c type format of the used converter. The value is converted into the smalltalk format
     of the used converter.

     <return: String|Integer|Float|ByteArray|nil>"

    "a nil value is indicated in the indicator array"
    ((anIndicatorArray shortAt:1) == -1) ifTrue:[
	^ nil
    ].
    ^ self converter getDataFromBuffer:aBuffer.
! !

!OCI8Variable methodsFor:'finalization'!

finalize
    "
this is invoked when an instance of myself is simply forgotten.
Release the different external bytes. For OCI8DynamicDefineVariables
the instance variable dataBuffer isnt an instance of external bytes.
Therefore the method is redefined there.

<return: self>
"

    dataBuffer notNil ifTrue:[
	dataBuffer free.
	dataBuffer := nil
    ].
    self finalizeCommon
!

finalizeCommon
    "
releases the external bytes buffers in the instance variables indicatorArray,
returnCodeArray and elementLengthArray. These instance variables are always
instances of external bytes.

<return: self>
"

    indicatorArray notNil ifTrue:[
	indicatorArray free.
	indicatorArray := nil
    ].
    returnCodeArray notNil ifTrue:[
	returnCodeArray free.
	returnCodeArray := nil
    ].
    elementLengthArray notNil ifTrue:[
	elementLengthArray free.
	elementLengthArray := nil
    ]
    "do not free the handle here, it is freed implicitly by OCI lib when the
     statement handle is released"
! !

!OCI8Variable methodsFor:'testing'!

isArrayBind
    "returns true if the receiver hold more than one value

     <return: Boolean>"

    ^ false
!

isReturnVariable
"
returns if the receiver is a bind variable which is used to return
values. Used in returning clauses of statements.

<return: Boolean>
"

    ^ false

! !

!OCI8Variable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8Variable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
