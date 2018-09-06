"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCI8Statement subclass:#OCI8DDStatement
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Statements'
!

!OCI8DDStatement class methodsFor:'documentation'!

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
    instances of this class represent SQL data definition statements

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8Statement
	OCI8DMStatement
	OCI8QueryStatement

    [instance variables:]
	none

    [class variables:]
	none
"
! !

!OCI8DDStatement class methodsFor:'examples'!

examples
"
create the table inserttest for the examples of this class.
								[exBegin]
    |session dropTableStatement createTableStatement|

    session := OCI8Session new.
    dropTableStatement := session newStatementFor:'drop table inserttest'.
    createTableStatement := session newStatementFor:
	'create table inserttest (id number, fl float, name varchar2(100), data raw(200))'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.
    [
	[
	    dropTableStatement executeOn:session.
	] on:SQLError do:[:ex|
	    'table does not exist error is ok'.
	    ex errorCode ~~ 942 ifTrue:[
		ex reject
	    ]
	].
	createTableStatement executeOn:session.
    ] ensure:[
	session disconnect.
    ]
								[exEnd]

truncate the table inserttest
								[exBegin]
    |session truncateStatement|

    session := OCI8Session new.
    [
	truncateStatement := session newStatementFor:'truncate table inserttest'.

	session connectWithUsername:'scott' password:'tiger' dbname:'test'.

	truncateStatement executeOn:session.
    ] ensure:[
	session disconnect.
    ].
								[exEnd]

								[exBegin]
    |session selectStatement|

    session := OCI8Session new.
    [
	selectStatement := session newStatementFor:'select * from inserttest'.

	session connectWithUsername:'scott' password:'tiger' dbname:'test'.

	selectStatement executeOn:session.
	self halt.
    ] ensure:[
	session disconnect.
    ].
								[exEnd]
"
! !

!OCI8DDStatement methodsFor:'execution'!

executeOn:ociSession
    "execute a data definition statement.
     There are no variables in the statement"

    handle executeOn:ociSession serviceHandle mode:#'OCI_DEFAULT'
	   iterator:1 rowOffset:0
	   errorHandle:self errorHandle.
! !

!OCI8DDStatement methodsFor:'testing'!

isDDLStatement
    "return true if the statement is a data definition statement"

    ^ true
! !

!OCI8DDStatement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8DDStatement.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
