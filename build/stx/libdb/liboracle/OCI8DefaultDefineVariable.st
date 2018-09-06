"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8DefineVariable subclass:#OCI8DefaultDefineVariable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8DefaultDefineVariable class methodsFor:'documentation'!

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
    This class is used to return data from a query statement when no piecewise
    fetch is necessary for the column represented by the define variable.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8DefineVariable
	OCI8DynamicDefineVariable
	OCI8Variable

    [instance variables:]
	none

    [class variables:]
	none
"
! !

!OCI8DefaultDefineVariable methodsFor:'accessing'!

mode
"
returns the default symbol. This means that the variable is fetched normal (not piecewise).

<return: Symbol>
"
    ^#'OCI_DEFAULT'



! !

!OCI8DefaultDefineVariable methodsFor:'setup'!

computeDataSize
"
returns the number of bytes which can be fetched
for the receivers column. This size depends on the table column
and the c type which is defined for the fetch.

<return: Integer>
"
    ^self converter dataSizeForColumnDescriptor:self columnDescriptor
!

setupFor:anOCI8Statement
"
setup the external bytes, the converter etc. and define the receiver.

<return: self>
"
    |dataSize|

    self basicSetupFor:anOCI8Statement.
    dataSize := self computeDataSize.
    self dataBuffer:(OCI8Handle bufferForSize:dataSize).
    self handle define:self position
       statementHandle:anOCI8Statement handle
		 cType:self externalCType
		buffer:self dataBuffer
	    bufferSize:dataSize
    nullValueIndicator:self indicatorArray
    elementLengthArray:self elementLengthArray
       returnCodeArray:self returnCodeArray
		  mode:self mode
	   errorHandle:anOCI8Statement errorHandle.
! !

!OCI8DefaultDefineVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8DefaultDefineVariable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
