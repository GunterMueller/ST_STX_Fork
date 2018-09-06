'From Smalltalk/X, Version:5.1.4 on 17-Nov-2003 at 11:42:25'                    !

"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8ColumnDescriptor subclass:#OCI8SelectDescriptor
	instanceVariableNames:'position buffer handle'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Descriptors'
!

!OCI8SelectDescriptor class methodsFor:'documentation'!

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
    SelectDescriptors describe columns selected in a select statement.
    Columns have a numeric position (1-based), a buffer and an optionad
    define handle.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]
	OCI8BindDescriptor

"
! !

!OCI8SelectDescriptor methodsFor:'accessing'!

buffer
    "return the value of the instance variable 'buffer' (automatically generated)"

    ^ buffer
!

buffer:something
    "set the value of the instance variable 'buffer' (automatically generated)"

    buffer := something.
!

handle
    "return the value of the instance variable 'handle' (automatically generated)"

    ^ handle
!

handle:something
    "set the value of the instance variable 'handle' (automatically generated)"

    handle := something.
!

position
    "return the value of the instance variable 'position' (automatically generated)"

    ^ position
!

position:something
    "set the value of the instance variable 'position' (automatically generated)"

    position := something.
! !

!OCI8SelectDescriptor methodsFor:'defining'!

bindTo:statementHandle errorHandle:errorHandle
    "define the variable described by this descriptor to a statement.
     Define variables are used to return the information from select statements.
     An existing define handle is used, otherwise it is allocated implicitly"

    |defineHandle|

    buffer isNil ifTrue:[
	"if buffer has not yet allocated, allocate a default buffer"
	buffer := OCIBuffer newType:type size:size.
    ].
    handle isNil ifTrue:[
	defineHandle := OCI8Handle newHandleWithType:#OCI8DefineHandle.
    ] ifFalse:[
	defineHandle := handle.
    ].

    buffer bind:position
	       bindHandle:defineHandle
	       statementHandle:statementHandle
	       errorHandle:errorHandle
	       mode:nil.

    handle := defineHandle.
! !
