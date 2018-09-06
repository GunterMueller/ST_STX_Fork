"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8Variable subclass:#OCI8DefineVariable
	instanceVariableNames:'columnDescriptor position'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Variables'
!

!OCI8DefineVariable class methodsFor:'documentation'!

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
    This abstract class is used to return data from a query statement. Each column which is returned
    is represented by a define variable. Two classes are used for query statements:

	OCI8DefaultDefineVariable
	    Is used when no piecewise fetch is necessary for the column
	    represented by the define variable.

	OCI8DynamicDefineVariable
	    Is used when a piecewise fetch is necessary for the column
	    represented by the define variable.

     A piecewise fetch must be done for long, long raw cloumns.

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8DefaultDefineVariable
	OCI8DynamicDefineVariable
	OCI8Variable

    [instance variables:]

	columnDescriptor <OCI8ColumnDescriptor>
	    holds the descriptor of the define variable. The descriptor describes the
	    column of a table for which the define variable is generated.

	position <Integer>
	    holds the index of the define variable in the select cluase of the statement.

    [class variables:]
	none
"
!

examples
"
    examples to be added.
								[exBegin]
    |session dropTableStatement createTableStatement|

    session := OCI8Session default.
    session username:'scott' password:'tiger' dbname:'secrec'.
    dropTableStatement := session newStatementFor:'drop table numbertest'.
    createTableStatement := session newStatementFor:'create table numbertest (table_intger integer, table_float float, table_number_1_0 number(1,0), table_number_38_0 number(38,0))'.

    session connect.
    OCIErrorSignal handle:[:ex |
    ] do:[
	session executeStatement:dropTableStatement.
    ].
    OCIErrorSignal handle:[:ex |
    ] do:[
	session executeStatement:createTableStatement.
    ].
    Transcript cr.
    Transcript show:'NAME';tab;tab;show:'SCALE';tab;tab;show:'PRECISION'.
    Transcript cr.


    (session columnsOfTable:'numbertest') do:[:eachDescriptor|
	Transcript show:eachDescriptor name;tab;show:eachDescriptor scale printString;tab;tab;show:eachDescriptor precision printString.
	Transcript cr.
    ].

    session disconnect.

								[exEnd]
"
! !

!OCI8DefineVariable class methodsFor:'instance creation'!

newFor:anOCI8Statement columnDescriptor:anOCI8ColumnDescriptor position:aPositionInteger
"
returns a new default or dynamic (for piecewise fetches) define variable. The external
buffers are setup and the define variable is binded to the statement via an oci call.

<return: <OrderedCollection of:(OCI8DynamicDefineVariable|OCI8DefaultDefineVariable)>>
"
    |defineVariable newPieceSize|

    (anOCI8ColumnDescriptor isPiecewiseType) ifTrue:[
	defineVariable := self dynamicDefineVariable.
	(newPieceSize := anOCI8Statement pieceSize) notNil ifTrue:[
	    defineVariable pieceSize:newPieceSize.
	].
    ] ifFalse:[
	defineVariable :=  self defaultDefineVariable.
    ].
    defineVariable columnDescriptor:anOCI8ColumnDescriptor.
    defineVariable position:aPositionInteger.
    defineVariable setupFor:anOCI8Statement.

    ^defineVariable


! !

!OCI8DefineVariable class methodsFor:'constants'!

defaultDefineVariable
"
returns a new define variable for a normal (not piecewise) fetch of
data.

<return: OCI8DefaultDefineVariable>
"
    ^OCI8DefaultDefineVariable new


!

dynamicDefineVariable
"
returns a new dynamic variable for a piecewise fetch of
data.


<return: OCI8DynamicDefineVariable>
"
    ^OCI8DynamicDefineVariable new

! !

!OCI8DefineVariable methodsFor:'accessing'!

columnDescriptor
"
returns the descriptor of the receiver. The descriptor describes the
column of a table for which the receiver is generated.

<return: OCI8ColumnDescriptor>
"

    ^ columnDescriptor
!

columnDescriptor:anOCI8ColumnDescriptor
"
sets the descriptor of the receiver. The descriptor describes the
column of a table for which the receiver is generated.

<return: self>
"
    columnDescriptor := anOCI8ColumnDescriptor.
!

handleType
"
default handle type for the receeiver.

<return: Symbol>
"
    ^#OCI8DefineHandle.
!

position
"
returns the index where the receiver is defined.

<return: Integer>
"

    ^ position
!

position:anInteger
"
sets the index where the receiver is defined.


<return: self>
"
    position := anInteger.
! !

!OCI8DefineVariable methodsFor:'setup'!

basicSetupFor:anOCI8Statement
"
setup the needed external bytes and compute a converter class for the receiver.
The converter depends on the table column.

<return: self>
"
    self computeConverter.
    self indicatorArray:(OCI8Handle bufferForSize:OCI8Handle sb2Size).
    self returnCodeArray:(OCI8Handle bufferForSize:OCI8Handle ub2Size).
    self elementLengthArray:(OCI8Handle bufferForSize:OCI8Handle ub2Size).
!

computeConverter
"
sets the converter for the receiver. The converter depends on the
table column.

<return: self>
"
    self converter:(self columnDescriptor newConverter)

! !

!OCI8DefineVariable methodsFor:'testing'!

isDynamic
    " test if the receiver is fetched via a piecewise fetch. Here false.

     <return: Boolean>"

    ^ false
! !

!OCI8DefineVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8DefineVariable.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
