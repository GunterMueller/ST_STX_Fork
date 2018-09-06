"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8DefineVariable subclass:#OCI8DynamicDefineVariable
	instanceVariableNames:'pieceSize'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8DynamicDefineVariable class methodsFor:'documentation'!

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
    This class is used to return data from a query statement when a piecewise
    fetch is necessary for the column represented by the define variable.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8DefaultDefineVariable
	OCI8DefineVariable
	OCI8Variable

    [instance variables:]
	pieceSize <Integer>
	    holds the size of the pieces which are fetched in each iteration
	    of a piecewise fetch.

    [class variables:]
	none
"
! !

!OCI8DynamicDefineVariable methodsFor:'accessing'!

mode
"
returns the denamic fetch symbol. This means that the variable is fetched piecewise.

<return: Symbol>
"

    ^#'OCI_DYNAMIC_FETCH'


!

pieceSize
"
returns the size of the pieces. A piecewise fetch fetches in each iteration
a piece with the returned size.

<return: Integer>
"
    pieceSize isNil ifTrue:[
	pieceSize := self defaultPieceSize
    ].
    ^pieceSize
!

pieceSize:anInteger
"
sets the size of the pieces. A piecewise fetch fetches in each iteration
a piece with the returned size.

<return: Integer>
"

    pieceSize := anInteger.
! !

!OCI8DynamicDefineVariable methodsFor:'constants'!

defaultPieceSize
"
returns the default number of bytes which are fetched in each piecewise iteration.

<return: Integer>
"
    ^30000
! !

!OCI8DynamicDefineVariable methodsFor:'finialization'!

finalize
    "
this method is invoked when an instance of myself is simply forgotten.
Release the different external bytes. For OCI8DynamicDefineVariables
the instance variable dataBuffer musnt be released.

<return: self>
"

    self finalizeCommon
! !

!OCI8DynamicDefineVariable methodsFor:'setup'!

maxPiecewiseSizeForConverter
"
returns the maximum number of bytes which can be fetched
for the receivers column. In an oci define call the maximum
size which should be fetched must be defined.

<return: Integer>
"

    ^ self converter maxSizeForCType

!

setupFor:anOCI8Statement
"
setup the external bytes, the converter etc. and define the receiver.

<return: self>
"
    self basicSetupFor:anOCI8Statement.

    self handle define:self position
       statementHandle:anOCI8Statement handle
		  cType:self externalCType
		 buffer:nil
	     bufferSize:self maxPiecewiseSizeForConverter
     nullValueIndicator:self indicatorArray
     elementLengthArray:self elementLengthArray
	returnCodeArray:self returnCodeArray
		   mode:self mode
	    errorHandle:anOCI8Statement errorHandle.
! !

!OCI8DynamicDefineVariable methodsFor:'testing'!

isDynamic
"
test if the receiver is fetched via a piecevise fetch. Here true.

<return: Boolean>
"
    ^true

! !

!OCI8DynamicDefineVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8DynamicDefineVariable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
