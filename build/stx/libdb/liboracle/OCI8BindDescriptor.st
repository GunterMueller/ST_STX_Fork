"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

Object subclass:#OCI8BindDescriptor
	instanceVariableNames:'position name indicator duplicate handle buffer'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Descriptors'
!

!OCI8BindDescriptor class methodsFor:'documentation'!

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
    Instances of this class describe variables in SQL statements.

    [author:]
	 Stefan Vogel

    [see also:]

    [instance variables:]

	duplicate <Boolean>
	    true if the variable appears more than once in the statement text

	handle <ExternalAddress|nil>
	    bind handle for the variable if the statement is bound
	    (a bind handle must exist for the position of the variable).

	indicator <String>
	    the name of the indicator variable

	name <Symbol>
	    the name of the variable for the position in the statement text.

	position <Integer>
	    the position of the variable in the statement text (1-based).

    [class variables:]
	none
"
! !

!OCI8BindDescriptor methodsFor:'accessing'!

buffer

    ^ buffer
!

buffer:something

    buffer := something.
!

duplicate
   "return true if the variable appears more than one time in the statement text"

    ^ duplicate
!

duplicate:aBoolean

    duplicate := aBoolean.
!

handle

    ^ handle
!

handle:anExternalAddressOrNil

    handle := anExternalAddressOrNil.
!

indicator

    ^ indicator
!

indicator:aString

    indicator := aString.
!

name

    ^ name
!

name:aSymbol

    name := aSymbol.
!

position
    "return the position of the variable in the statement text"

    ^ position
!

position:anInteger

    position := anInteger.
! !

!OCI8BindDescriptor methodsFor:'binding'!

bindTo:statementHandle errorHandle:errorHandle
    "bind the variable described by this descriptor to a statement.
     An existing bind handle is used, otherwise it is allocated implicitly"

    |bindHandle|

    duplicate ifFalse:[
	buffer isNil ifTrue:[
	    SQLError raiseErrorString:' - undeclared bind variable: ', name.
	].
	handle isNil ifTrue:[
	    bindHandle := OCI8Handle newHandleWithType:#OCI8BindHandle.
	] ifFalse:[
	    bindHandle := handle.
	].

	buffer bind:name
		   bindHandle:bindHandle
		   statementHandle:statementHandle
		   errorHandle:errorHandle
		   mode:nil.

	handle := bindHandle.
    ]
! !

!OCI8BindDescriptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8BindDescriptor.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
