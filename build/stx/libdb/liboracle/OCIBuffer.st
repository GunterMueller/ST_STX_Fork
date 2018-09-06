"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

Visitor subclass:#OCIBuffer
	instanceVariableNames:'buffer controlData alenOffset rcodeOffset piece nElements
		maxElementLen'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!


!OCIBuffer class methodsFor:'documentation'!

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
! !

!OCIBuffer class methodsFor:'instance creation'!

elements:nElements withSize:maxElementLen

     ^ self basicNew elements:nElements maxElementLen:maxElementLen containerClass:ExternalBytes
!

new
     ^ self basicNew elements:1 maxElementLen:self elementSize containerClass:ExternalBytes
!

new:numberOfElements
     ^ self basicNew elements:numberOfElements maxElementLen:self elementSize containerClass:ExternalBytes
!

newType:ociDatabaseType size:size
    "return a new buffer (with 1 element) with size size.
     Use the correct subclass for ociDatabaseType"

    |cls|

    ociDatabaseType == #'CHAR_TYPE' ifTrue:[
	cls := OCIStringBuffer.
    ] ifFalse:[ociDatabaseType == #'VARCHAR2_TYPE' ifTrue:[
	cls := OCIStringBuffer.
    ] ifFalse:[ociDatabaseType == #'NUMBER_TYPE' ifTrue:[
	cls := OCINumberBuffer.
    ] ifFalse:[ociDatabaseType == #'DATE_TYPE' ifTrue:[
	cls := OCIDateBuffer.
    ] ifFalse:[ociDatabaseType == #'RAW_TYPE' ifTrue:[
	cls := OCIRawBuffer.
    ] ifFalse:[ociDatabaseType == #'LONG_TYPE' ifTrue:[
	cls := OCIStringBuffer.
	self halt.
    ] ifFalse:[ociDatabaseType == #'LONG_RAW_TYPE' ifTrue:[
	cls := OCIRawBuffer.
	self halt.
    ] ifFalse:[
	SQLError raiseErrorString:' - unknown database type: ', ociDatabaseType.
    ]]]]]]].

    ^ cls elements:1 withSize:size
! !

!OCIBuffer class methodsFor:'constants'!

elementSize
    "return the default element size of a buffer.
     Redefined in subclasses"

    ^ 256       "arbitrary default value"
! !

!OCIBuffer class methodsFor:'private'!

newContainer:size
    "allocate a new container of size size.
     Subclasses may redefine this to allocate ExternalBytes or whatever"

     ^ ByteArray new:size
! !

!OCIBuffer class methodsFor:'queries'!

ociDataType
    "return the C-Datatype used to represent the value(s) stored in this buffer"

    self subclassResponsibility
! !

!OCIBuffer methodsFor:'accessing'!

alenAt:index

    ^ controlData unsignedShortAt:alenOffset+(index-1 * 2)
!

alenAt:index put:value
    "set the element length. As side effect, set indicator to 0 (non-null buffer)"

    |off|

    off := (index-1*2).

    "set indicator"
    controlData shortAt:1+off put:0.
    "set alen"
    controlData unsignedShortAt:alenOffset+off put:value.
!

at:index
     "read a smalltalk object from index"

     ^ self subclassResponsibility
!

at:index put:anObject
     "store a smalltalk object at index"

     anObject acceptVisitor:self with:index
!

indicatorAt:index

    ^ controlData shortAt:(index-1*2)+1
!

indicatorAt:index put:value

    ^ controlData shortAt:(index-1*2)+1 put:value
!

maxElementLen
    "return the value of the instance variable 'maxElementLen' (automatically generated)"

    ^ maxElementLen
!

nElements
    "return the value of the instance variable 'nElements' (automatically generated)"

    ^ nElements
!

rcodeAt:index

    ^ controlData unsignedShortAt:rcodeOffset+(index-1 * 2)
!

rcodeAt:index put:value

    ^ controlData unsignedShortAt:rcodeOffset+(index-1 * 2) put:value
! !

!OCIBuffer methodsFor:'binding'!

bind:nameOrPos bindHandle:bindHandle statementHandle:statementHandle
	       errorHandle:errorHandle mode:bindMode
    "bind buffer to a bind handle and statement handle"

    bindHandle bind:nameOrPos
	       statementHandle:statementHandle
	       errorHandle:errorHandle
	       elementSize:maxElementLen
	       mode:bindMode
	       dataType:self ociDataType
	       dataBuffer:buffer
	       numberOfElements:nElements
	       controlData:controlData.
! !

!OCIBuffer methodsFor:'decoding'!

isNilAt:index
    "answer true, if nil value indicator at index is set"

    ^ (self indicatorAt:index) == -1
! !

!OCIBuffer methodsFor:'encoding'!

visitNilWith:index
    "every buffer can encode nil. This is done by setting the indicator to -1"

    self indicatorAt:index put:-1.
!

visitObject:anObject with:index
    "maybe some of my subclasses can represent any object,
     but most can't"

    ^ self subclassResponsibility
! !

!OCIBuffer methodsFor:'instance creation'!

elements:elements maxElementLen:size containerClass:containerClass
     "initialize buffer for size size"

     nElements := elements.
     size isNil ifTrue:[
	maxElementLen := self class elementSize.
     ] ifFalse:[
	maxElementLen := size.
     ].
     buffer := containerClass new:(maxElementLen*elements).

     "
      Allocate controlData.
      WARNING: Layout and size of controlData is also known in primitive code.
	       You have to change this too, if you make changes here!!

     "

     "indicatorOffset == 1"
     alenOffset := 1 + (elements * 2 "OCI8Handle sb2Size").
     rcodeOffset := alenOffset + (elements * 2  "OCI8Handle ub2Size").

     controlData := containerClass new:rcodeOffset + (elements * 2 "OCI8Handle ub2Size") - 1.

     "
      self basicNew elements:1 maxElementLen:7 containerClass:ExternalBytes
     "
! !

!OCIBuffer methodsFor:'queries'!

ociDataType
    "return the C-Datatype used to represent the value(s) stored in this buffer"

    ^ self class ociDataType
! !

!OCIBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIBuffer.st,v 1.7 2010-10-11 12:00:05 cg Exp $'
! !
