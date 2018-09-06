"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

Transaction subclass:#OCI8Transaction
	instanceVariableNames:'handle flags timeout'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Session'
!

!OCI8Transaction class methodsFor:'documentation'!

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
    To create a transaction:
	OCI8Session>>newReadOnlyTransaction
	OCI8Session>>newReadOnlyTransactionWithTimeOut:
	OCI8Session>>newReadWriteTransaction
	OCI8Session>>newReadWriteTransactionWithTimeOut:

    If a transaction is created with OCI8Session>>newReadOnlyTransaction or
    OCI8Session>>newReadWriteTransaction then the transaction will be rollback
    immeditially if it is detached because the time out integer of the transaction
    is set to 0.  To create a transaction which is detach- and resumeable call
    OCI8Session>>newReadOnlyTransactionWithTimeOut: or OCI8Session>>newReadWriteTransactionWithTimeOut:.

    To commit or rollback a transaction:
	OCI8Transaction>>commit
	OCI8Transaction>>commitOnePhase
	OCI8Transaction>>rollback

    To detach or resume a transaction:
	OCI8Transaction>>detach
	OCI8Transaction>>resume:

    To prepare a transaction:
	OCI8Transaction>>prepare

    [author:]
	Pierre Schwarz

    [see also:]
	OCI8DDStatement
	OCI8DMStatement
	OCI8QueryStatement

    [instance variables:]

	flags <Collection>
	    a collection with the symbols representing the mode
	    of a transaction.

	handle <OCI8Handle>
	    holds the external address (handle) and type (a symbol)
	    for the oci handle

	session <OCI8Session>
	    holds the session which created the transaction. Used to access some
	    parameters of the session.

    [class variables:]
	none
"
! !

!OCI8Transaction class methodsFor:'instance creation'!

new

    ^ self basicNew initialize
! !

!OCI8Transaction class methodsFor:'examples'!

example_createTable
"
create the table transactiontest for the examples of this class.
								[exBegin]
    |session transaction dropTableStatement createTableStatement|

    session := OCI8Session default.
    dropTableStatement := session newStatementFor:'drop table transactiontest'.
    createTableStatement := session newStatementFor:'create table transactiontest (testnumber integer)'.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.
    transaction := session newReadWriteTransaction.

    OCIErrorSignal handle:[:ex |
	OCIErrorSignal handle:[:ex |
	] do:[
	    transaction rollback.
	].
    ] do:[
	session executeStatement:dropTableStatement.
    ].

    OCIErrorSignal handle:[:ex |
	OCIErrorSignal handle:[:ex |
	] do:[
	    transaction rollback.
	].
    ] do:[
	session executeStatement:createTableStatement.
    ].

    session disconnect.
								[exEnd]
"


!

example_transactionTest1
"
insert integers and rollback each insert, if integer is odd

								[exBegin]
    |session truncateStatement insertStatement insertStream transaction|

    session := OCI8Session default.
    truncateStatement := session newStatementFor:'truncate table transactiontest'.
    insertStatement := session newStatementFor:'insert into transactiontest values (:testnumber)'.
    insertStatement integerBindVariable:#testnumber.

    session connectWithUsername:'scott' password:'tiger' dbname:'test'.

    session executeStatement:truncateStatement.

    12 to: 22 do:[:eachNumber|
	transaction := session newReadWriteTransaction.
	session executeStatement:insertStatement from:(Array with:eachNumber).
	eachNumber odd ifTrue:[
	    transaction rollback.
	] ifFalse:[
	    transaction commit.
	]
    ].
    session disconnect.
								[exEnd]

"

! !

!OCI8Transaction methodsFor:'accessing'!

beReadOnly

    self addFlag:#'OCI_TRANS_READONLY'
!

beReadWrite

    self removeFlag:#'OCI_TRANS_READONLY'
!

beSerializable

    self addFlag:#'OCI_TRANS_SERIALIZABLE'
!

flags
"
returns the collection with the symbols representing the mode
of the receiver.

<return: Collection>
"

    ^ flags
!

flags:aCollection
"
sets the collection with the symbols representing the mode
of the receiver.

<return: self>
"

    flags := aCollection.
!

handle
    "return the value of the instance variable 'handle' (automatically generated)"

    ^ handle
!

handle:something
    "set the value of the instance variable 'handle' (automatically generated)"

    handle := something.
!

timeout
    "return the value of the instance variable 'timeout' (automatically generated)"

    ^ timeout
!

timeout:something
    "set the value of the instance variable 'timeout' (automatically generated)"

    timeout := something.
! !

!OCI8Transaction methodsFor:'initialization'!

initialize
    timeout := 0.
!

startOn:aSession withFlag:transactionFlag timeout:timeoutArg
    "start a new transaction. Set the necessary attributes"

    |errorHandle t|

    t := timeoutArg isNil ifTrue:[timeout] ifFalse:[timeoutArg].

    handle isNil ifTrue:[
	handle := aSession environmentHandle newHandleWithType:#OCI8TransactionHandle.
    ].
    errorHandle := aSession errorHandle.

    aSession serviceHandle
		setTransaction:handle errorHandle:errorHandle;
		startTransaction:(flags copy add:transactionFlag; yourself)
			 timeout:t errorHandle:errorHandle.
! !

!OCI8Transaction methodsFor:'private'!

addFlag:aSymbol
    "add a symbol to the list of flags"

    flags isNil ifTrue:[
	flags := Set new.
    ].
    flags add:aSymbol.
!

removeFlag:aSymbol
    "remove a symbol from the list of flags"

    flags notNil ifTrue:[
	flags remove:aSymbol ifAbsent:[].
    ].
! !

!OCI8Transaction class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8Transaction.st,v 1.4 2010-10-11 12:00:05 cg Exp $'
! !
