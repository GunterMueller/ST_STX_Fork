"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8BindVariable subclass:#OCI8SingleValueBindVariable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8SingleValueBindVariable class methodsFor:'documentation'!

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
    This bind variable must be used, if one value for each bind variable
    should be insert into the database.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8BindVariable
	OCI8MultipleValueBindVariable
	OCI8ReturnValueBindVariable
	OCI8Variable

    [instance variables:]
	none

    [class variables:]
	none
"
! !

!OCI8SingleValueBindVariable class methodsFor:'instance creation'!

name:aName converter:anOCI8Converter
"
returns an instance of OCI8SingleValueBindVariable class. Used for
single value inserts.

<return: OCI8SingleValueBindVariable>
"
   |inst|

   inst:= super new.
   inst name:aName.
   inst converter:anOCI8Converter.
   ^inst


! !

!OCI8SingleValueBindVariable methodsFor:'accessing'!

addValue:aNewValue
"
set the value of the receiver. If the value is nil the flag nullValue is set
to true. If the receiver is an array bind the null value flag is also set
when the argument aNewValue is an empty collection. Set the state setup to false
because the external bytes must be rearranged. This is done before executing
the statement to which the receiver belongs.

<return: self>
"
    value := aNewValue.
    self setup:false.


!

getConvertedValue
"
returns the value of the receiver. The stored value of the receiver
is converted into the external c type.

<return: ByteArray|String|nil>
"

    self isNullValue ifTrue:[^nil].
    ^self convertToExternalCTypeValue:value


!

newDataBufferSize
"
returns the size for the data buffer of the receiver.
The size of the data buffer is the size of the value.

<return: Integer>
"
    self isNullValue ifTrue:[
	"null value and no arrray bind -> external bytes size = 0"
	^0
    ].
    "non null value"
    ^self sizeFor:self getConvertedValue externalCType:self converter externalCType.
!

numberOfElements
"
returns number of elements for a single bind value and that is one element.

<return: Integer>
"
    ^1

! !

!OCI8SingleValueBindVariable methodsFor:'setup'!

setupElementLengthArray
"
For checkins of single values (like longs!!) the
element legth array is omitted.

<return: self>
"
    ^ self
!

setupExternalBytes
"
sets up the data buffer of the receiver.

<return: self>
"

    |size buffer|

    size := self newDataBufferSize.
    self maxElementSize:size.
    self isNullValue ifTrue:[
	"A null value is indicated by a -1 in the indicator array."
	"The default value of the indicator array is 0."
       self indicatorArray shortAt:1 put:-1.
    ].

    buffer := self dataBuffer.
    buffer isNil ifTrue:[
	self dataBuffer:(buffer := OCI8Handle bufferForSize:size).
	self needsBind:true.
    ] ifFalse:[
	(buffer size < size) ifTrue:[
	    size := (size / 4000) ceiling * 4000.
	    buffer free.
	    self dataBuffer:(buffer := OCI8Handle bufferForSize:size).
	    self needsBind:true.
	]
    ].
    self copyValue:self getConvertedValue toBuffer:buffer withOffset:0 valueSize:size externalCType:self externalCType
!

setupIndicatorArray
"
sets up the indicator array of the receiver.

<return: self>
"
    self indicatorArray isNil ifTrue:[
	"new indicator array"
	self indicatorArray:(OCI8Handle bufferForSize:OCI8Handle sb2Size).
	self needsBind:true.
    ] ifFalse:[
	self indicatorArray atAllPut:0.
    ].
!

setupReturnCodeArray
"
Setup the return code array of the receiver.

<return: self>
"
    self returnCodeArray isNil ifTrue:[
	self returnCodeArray:(OCI8Handle bufferForSize:OCI8Handle ub2Size).
	self needsBind:true.
    ] ifFalse:[
	self returnCodeArray atAllPut:0.
    ]
! !

!OCI8SingleValueBindVariable methodsFor:'testing'!

isNullValue
    "returns if the receiver represents a null value.

     <return: Boolean>"

    ^ self value isNil
! !

!OCI8SingleValueBindVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8SingleValueBindVariable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
