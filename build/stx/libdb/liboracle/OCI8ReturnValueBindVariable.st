"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8BindVariable subclass:#OCI8ReturnValueBindVariable
	instanceVariableNames:'callBackData'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8ReturnValueBindVariable class methodsFor:'documentation'!

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
    This bind variable must be used, if a value is returned in a returning clause of a statement.
    The data isfetched via callback functions.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8BindVariable
	OCI8MultipleValueBindVariable
	OCI8SingleValueBindVariable
	OCI8Variable

    [instance variables:]

	callBackData <OCI8CallBackData>
	    Holds the class used for in-,out-callback functions for returning clauses in statements.

    [class variables:]
	none
"
! !

!OCI8ReturnValueBindVariable methodsFor:'accessing'!

basicElementSize
"
returns the maximum size for each element which can be returned by a returning clause.
This size depends on the smalltalk type of the receiver.

<return: Integer>
"
    ^ self converter basicElementSize
!

callBackData
"
returns an instance of the utility class OCI8CallBackData. This class holds the in-,out-callback functions for
returning clauses in statements.

<return: OCI8CallBackData>
"

    ^ callBackData
!

callBackData:anOCI8CallBackDataInst
"
sets an instance of the utility class OCI8CallBackData. This class holds the in-,out-callback functions for
returning clauses in statements.

<return: self>
"

    callBackData := anOCI8CallBackDataInst.
!

value
"
returns a collection of the values received from the callback functions.
The values are converted in the converter to the approperiate smalltalk type.

<return: Collection of:<nil|ByteArray|FixedPoint|Float|Integer|String>>
"
    ^callBackData elements.



! !

!OCI8ReturnValueBindVariable methodsFor:'binding'!

bindDynamicForStatement:anOCI8Statement
"
sets in-,out-returning function and in-,out-callbackdata for the receiver.
Those parameters are hold in the utility class OCI8CallBackData.

<return: self>
"
    anOCI8Statement ociLib ociBindDynamic:self handle
			     callBackData:self callBackData
			      errorHandle:anOCI8Statement errorHandle.

!

bindForStatement:anOCI8Statement
"
bind the receiver without any buffers but with maximal element size
and OCI_DATA_AT_EXEC mode.

<return: self>
"
    self handle bind:self name
	     statementHandle:anOCI8Statement handle
		       cType:self externalCType
		      buffer:nil
		  bufferSize:self basicElementSize
	      nullValueIndicator:nil
	      elementLengthArray:nil
	     returnCodeArray:nil
			mode:self mode
		 errorHandle:anOCI8Statement errorHandle.
! !

!OCI8ReturnValueBindVariable methodsFor:'constants'!

callBackDataClass
"
returns the class for the callback functionality

<return: Symbol>
"
    ^OCI8CallBackData
!

mode
"
default mode for the bind variable. If using another mode, the given oci session,
statement mechanismen cannot be used.

<return: Symbol>
"
    ^#'OCI_DATA_AT_EXEC'
! !

!OCI8ReturnValueBindVariable methodsFor:'setup'!

setupCallBackData:anOCI8ErrorHandle
"
create an instance of the utility class OCI8CallBackData which holds all
parameters for the dynamic bind.

<return: self>
"
    self callBackData:(self callBackDataClass elementSize:self basicElementSize
						converter:self converter
					      errorHandle:anOCI8ErrorHandle).



!

setupForStatement:anOCI8Statement
"
if the receiver isnt setup do all bind steps. First do a bind without any buffer, then setup the
callbackdata and finally do a dynamic bind with the callbackdata. Reset the receivers callbackdata,
because new data will be fechted.

<return: self>
"
    self isSetup ifFalse:[
	"bind variable without any buffers"
	self bindForStatement:anOCI8Statement.
	"create an instance of OCI8CallDackData which is used as the context parameter"
	"in the OCI8BindDynamic oci call"
	self setupCallBackData:anOCI8Statement errorHandle.
	"dynamic bind with the callback data"
	self bindDynamicForStatement:anOCI8Statement.
	self setup:true.
    ].
    "clear buffers in the callback"
    self callBackData resetCallBackData
! !

!OCI8ReturnValueBindVariable methodsFor:'testing'!

isReturnVariable
"
returns if the receiver is a bind variable which is used to return
values. Used in returning clauses of statements.

<return: Boolean>
"

    ^ true
! !

!OCI8ReturnValueBindVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8ReturnValueBindVariable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
