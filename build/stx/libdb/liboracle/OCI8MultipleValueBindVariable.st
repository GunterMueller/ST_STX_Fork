"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8BindVariable subclass:#OCI8MultipleValueBindVariable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8MultipleValueBindVariable class methodsFor:'documentation'!

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
    This bind variable must be used, if an array should be insert into the database.
    More then one value is given for each bind variable.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8BindVariable
	OCI8ReturnValueBindVariable
	OCI8SingleValueBindVariable
	OCI8Variable

    [instance variables:]
	none

    [class variables:]
	none
"
! !

!OCI8MultipleValueBindVariable class methodsFor:'instance creation'!

name:aName converter:anOCI8Converter
"
returns an instance of OCI8MultipleValueBindVariable class. Used for
array inserts.

<return: OCI8MultipleValueBindVariable>
"
   |inst|

   inst:= super new.
   inst name:aName.
   inst converter:anOCI8Converter.
   ^inst


! !

!OCI8MultipleValueBindVariable methodsFor:'accessing'!

addValue:anObject
"
adds a value anObject of the receiver. Set the state setup to false
because the external bytes must be rearranged. This is done before executing
the statement to which the receiver belongs.

<return: self>
"

    self isSetup ifTrue:[
	self initializeValue
    ].
    self value add:anObject.
    self setup:false.

!

getConvertedValueColl
"
return the value of the receiver. The stored value of the receiver
is converted into the external c type.

<return: Array with:<ByteArray|String|nil>>
"

    ^self value collect:[:eachValue |
	eachValue isNil ifTrue:[
	    nil
	] ifFalse:[
	    self convertToExternalCTypeValue:eachValue
	]
    ]

!

getValue:anOCI8Lib

    |nElements values tmpBuffer elementSize indicatorStep|

    elementSize := self maxElementSize.
    nElements := self numberOfElements.
    values := Array new:nElements.
    indicatorStep := anOCI8Lib class sb2Size.
    1 to:nElements do:[:index |
	(self indicatorArray shortAt:1+((index-1)*indicatorStep)) = -1 ifTrue:[
	    value := nil.
	] ifFalse:[
	    tmpBuffer := self dataBuffer from:1+((index-1)*elementSize) to:(index*elementSize).
	    value := self converter getDataFromBuffer:tmpBuffer.
	].
	values at:index put:value.
    ].
    ^ values
!

initializeValue

    value := OrderedCollection new

!

newDataBufferSizeAndSizeArrayForValues
"
returns the size of the data buffer for the values and an arrray with
the length of the values of the receiver.
The size for the data buffer is maxElementSizeOf(values) * number of values.

<return: Array with:<Integer, Array with:<Integer>>>
"

    |maxSize sizeArray tmpSize|

    maxSize := 0.
    sizeArray := OrderedCollection new:self numberOfElements.
    self getConvertedValueColl do:[:eachValue |
	eachValue isNil ifTrue:[
	    tmpSize := 0.
	] ifFalse:[
	    tmpSize := self sizeFor:eachValue externalCType:self converter externalCType.
	].
	maxSize := maxSize max:tmpSize.
	sizeArray add:tmpSize.
    ].
    ^Array with:maxSize with:sizeArray.
!

numberOfElements
"
returns the number of elements which are stored in the value of the
receiver.

<return: Integer>
"

   ^ self value size
!

setElementLengthAtIndex:anIndex toSize:aSize
"

<return: self>
"
    |offset|

    offset := OCI8Lib ub2Size.
    aSize > ((2 raisedTo:(offset*8)) - 1) ifTrue:[
	SQLError raiseErrorString:' - value in array insert is greater than ',
		((2 raisedTo:(offset*8)) - 1) printString ,' bytes'
    ].
    elementLengthArray unsignedShortAt:(1+(offset*(anIndex-1))) put:aSize
!

value
"
return the value coollection of the receiver. These values are
copied into the data buffer.

<return: OrderedCollection>
"
    value isNil ifTrue:[
	self initializeValue
    ].
    ^value

! !

!OCI8MultipleValueBindVariable methodsFor:'setup'!

setNullIndicatorAtIndex:anIndex
"

<return: self>
"
    |offset|

    offset := OCI8Handle sb2Size.
    self indicatorArray shortAt:(1+(offset*(anIndex-1))) put:-1.
!

setupElementLengthArray
"
setup the element lenght array of the receiver. The array
is only setup for checkins of array elements. Because the elements
in the array are limited to 2 bytes, they can only indicate
sizes <= 65535. For checkins of single values (like longs!!) the
element legth array is omitted.

<return: self>
"
    |size tmpBuffer|

    size :=  self numberOfElements * OCI8Handle ub2Size.
    self elementLengthArray isNil ifTrue:[
	self elementLengthArray:(OCI8Handle bufferForSize:size).
	self needsBind:true.
    ] ifFalse:[
	self elementLengthArray size ~= size ifTrue:[
	    tmpBuffer := self elementLengthArray.
	    self elementLengthArray:nil.
	    tmpBuffer free.
	    self elementLengthArray:(OCI8Handle bufferForSize:size).
	    self needsBind:true.
	].
    ].
    "store maximum element size in element length array at every index"
    1 to:self numberOfElements do:[:index |
	self setElementLengthAtIndex:index toSize:self maxElementSize.
    ].
!

setupExternalBytes
"
<return: self>
"

    |returnArray size sizeArray buffer type index offset|

    returnArray := self newDataBufferSizeAndSizeArrayForValues.
    maxElementSize := returnArray at:1.
    sizeArray := returnArray at:2.
    size := maxElementSize * self numberOfElements.

    buffer := self dataBuffer.
    buffer isNil ifTrue:[
	size ~= 0 ifTrue:[
	    self dataBuffer:(buffer := OCI8Handle bufferForSize:size).
	    self needsBind:true.
	].
    ] ifFalse:[
	(buffer size < size) ifTrue:[
	    size := (size / 4000) ceiling * 4000.
	    buffer free.
	    self dataBuffer:(buffer := OCI8Handle bufferForSize:size).
	    self needsBind:true.
	]
    ].
    type := self externalCType.
    index := 1.
    offset := 0.
    self getConvertedValueColl do:[:eachValue |
	(self isNullValueAt:index) ifTrue:[
	    self setNullIndicatorAtIndex:index.
	] ifFalse:[
	    self copyValue:eachValue toBuffer:buffer withOffset:offset valueSize:(sizeArray at:index) externalCType:type
	].
	offset := offset + maxElementSize.
	index := index + 1.
    ]
!

setupIndicatorArray
"
sets up the indicator array of the receiver.

<return: self>
"
    |size tmpBuffer|

    size :=  self numberOfElements * OCI8Handle sb2Size.
    self indicatorArray isNil ifTrue:[
	"new indicator array"
	self indicatorArray:(OCI8Handle bufferForSize:size).
	self needsBind:true.
    ] ifFalse:[
	self indicatorArray size ~= size ifTrue:[
	    "if number of values changed get new buffer"
	    tmpBuffer := self indicatorArray.
	    self indicatorArray:nil.
	    tmpBuffer free.
	    self indicatorArray:(OCI8Handle bufferForSize:size).
	    self needsBind:true.
	] ifFalse:[
	    self indicatorArray atAllPut:0.
	].
    ]
!

setupReturnCodeArray
"
Setup the return code array of the receiver.

<return: self>
"
    |size tmpBuffer|

    size :=  self numberOfElements * OCI8Handle ub2Size.
    size = 0 ifTrue:[^self]. "no elements -> no return code array"
    self returnCodeArray isNil ifTrue:[
	self returnCodeArray:(OCI8Handle bufferForSize:size).
	self needsBind:true.
    ] ifFalse:[
	self returnCodeArray size ~= size ifTrue:[
	    tmpBuffer := self returnCodeArray.
	    self returnCodeArray:nil.
	    tmpBuffer free.
	    self returnCodeArray:(OCI8Lib bufferForSize:size).
	    self needsBind:true.
	]
    ]
! !

!OCI8MultipleValueBindVariable methodsFor:'testing'!

isArrayBind
"
returns if the receiver is an array bind.

<return: Boolean>
"

    ^true


!

isNullValueAt:anIndex
"
returns if the receiver represents a null value at an index.
This method is called instead of #isNullValue if the receiver is an array bind.

<return: Boolean>
"

    ^(self value at:anIndex ifAbsent:nil) == nil

! !

!OCI8MultipleValueBindVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8MultipleValueBindVariable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
