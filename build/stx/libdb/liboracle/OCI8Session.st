"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

DatabaseSession subclass:#OCI8Session
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Session'
!

!OCI8Session class methodsFor:'documentation'!

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
    Framework for accessing oracle databases.
    For accessing an oracle database create an instance of OCI8Session with:
	OCI8Session class>>default.

    Connect to a database with:
	OCI8Session>>connectWithUsername:password:dbname:

    Disconnect from a database with:
	OCI8Session>>disconnect
    A disconnect is done if your instance of OCI8Session is finalized.

    Create a statement with:
	OCI8Session>>newStatementFor:
	Returns an instance of OCI8DDStatement, OCI8DMStatement or OCI8QueryStatement.

    Execute a statement with (does an implicit fetch for OCI8QueryStatement):
	OCI8Session>>executeStatement:                         (for OCI8DDStatement and OCI8DMStatement)
	OCI8Session>>executeStatement:from:                    (for OCI8DMStatement and OCI8QueryStatement)
	OCI8Session>>executeStatement:from:into:               (for OCI8DMStatement and OCI8QueryStatement)
	OCI8Session>>executeStatement:from:into:numberOfRows:  (for OCI8QueryStatement)
	OCI8Session>>executeStatement:into:                    (for OCI8DMStatement and OCI8QueryStatement)
	OCI8Session>>executeFrom:into:numberOfRows:            (for OCI8QueryStatement)

    Fetch (more) results from a statement (OCI8QueryStatement) with (used when the results are
    restricted by numberOfRows):
	OCI8Session>>fetchDataForStatement:anOCI8Statement into:               (for OCI8QueryStatement)
	OCI8Session>>fetchDataForStatement:anOCI8Statement into:numberOfRows:  (for OCI8QueryStatement)

    To create transcations call:
	OCI8Session>>newReadOnlyTransaction
	OCI8Session>>newReadWriteTransaction

    For detailed information see ee the examples in OCI8Session, OCI8DDStatement, OCI8DMStatement,
    OCI8QueryStatement and OCI8Transaction.

    [author:]
	Pierre Schwarz
	Stefan Vogel
	Claus Gittinger

    [see also:]
	OCI8DDStatement
	OCI8DMStatement
	OCI8QueryStatement
	OCI8Statement
	OCI8Transaction

    [instance variables:]

    [class variables:]
	none
"
! !

!OCI8Session class methodsFor:'instance creation'!

defaultEnvironment
    ^ OCI8Environment default
!

shared
    "creates a new session and initializes it shared.
     <return: OCI8Session>
    "
   self error:'not supported yet. Use default mode instead.'
!

threaded
    "
     creates a new session and initializes it threaded.
     <return: OCI8Session>
    "
   self error:'not supported yet. Use default mode instead.'
! !

!OCI8Session class methodsFor:'examples'!

example_ConnectToDatabase
"
    create a session and connect to a db
						    [exBegin]
    |session|
    session := OCI8Session new.
    session connectWithUsername:'scott' password:'tiger' dbname:'test'.
    Transcript showCR:'Connected'.
    Delay waitForSeconds:5.
    session disconnect.
    Transcript showCR:'Disconnected'.
						    [exEnd]
"
!

example_ShowTableInformation
"
show the column informations for a table

					[exBegin]
    |session|
    session := OCI8Session new.
    session connectWithUsername:'scott' password:'tiger' dbname:'test'.
    (session describeTable:'emp') inspect.
    session disconnect.
					[exEnd]

"
!

example_ShowTables
"
show the column informations for a table

					[exBegin]
    |session statement s|
    session := OCI8Session new.
    session connectWithUsername:'system' password:'manager' dbname:'test'.
    (statement := session newStatementFor:'select * from dba_tables order by owner') executeInto:(s := #() writeStream).
    statement columnDescriptors inspect.
    s contents inspect.
    session disconnect.
					[exEnd]

"
! !

!OCI8Session methodsFor:'connection setup & teardown'!

setExternalName:aString
    "set the external name of the server.
     One of external or internal name must be set in order to use global locks"

    self serverHandle
	setAttribute:#'OCI_ATTR_EXTERNAL_NAME'
	value:aString
	errorHandle:errorHandle.
!

setInternalName:aString
    "set the external name of the server.
     One of external or internal name must be set in order to use global locks"

    self serverHandle
	setAttribute:#'OCI_ATTR_INTERNAL_NAME'
	value:aString
	errorHandle:errorHandle.
! !

!OCI8Session methodsFor:'error handling'!

logOnError:message
    OCILogOnError raiseErrorString:message
! !

!OCI8Session methodsFor:'initialize & release'!

initialize:aModeColl
    "initialize the enviroment and error handle.

     <return: self>"

    environment := OCI8Environment new modes:aModeColl.
    self errorHandle.
! !

!OCI8Session methodsFor:'private accessing'!

errorHandle
"XXX: see inherited - add #newErrorHandle to OCI8EnvironmentHandle "
    errorHandle isNil ifTrue:[
	errorHandle := environment handle newHandleWithType:#OCI8ErrorHandle.
    ].
    ^ errorHandle
!

serverHandle
"XXX: see inherited - add #newServerHandle to OCI8EnvironmentHandle "
    serverHandle isNil ifTrue:[
	serverHandle := environment handle newHandleWithType:#OCI8ServerHandle.
    ].
    ^ serverHandle
!

serviceHandle
"XXX: see inherited - add #newServiceHandle to OCI8EnvironmentHandle "
    serviceHandle isNil ifTrue:[
	serviceHandle := environment handle newHandleWithType:#OCI8ServiceContextHandle.
    ].
    ^ serviceHandle
!

userSessionHandle
"XXX: see inherited - add #newUserSessionHandle to OCI8EnvironmentHandle "
    userSessionHandle isNil ifTrue:[
	userSessionHandle := environment handle newHandleWithType:#OCI8UserSessionHandle.
    ].
    ^ userSessionHandle
! !

!OCI8Session methodsFor:'private connection handling'!

beginUserSessionFor:aUsername password:aPassword
    "set the username and password properties in the user session handle and
     connect to the server. Add the session handle to the session attribute
     of the service context.

     <return: self>"

    "set username and password attribute in user session handle"
    self userSessionHandle
	setAttribute:#'OCI_ATTR_USERNAME' value:aUsername errorHandle:errorHandle;
	setAttribute:#'OCI_ATTR_PASSWORD' value:aPassword errorHandle:errorHandle.

    "start session
     and set the user session in the service context"
    self serviceHandle
	beginSession:self userSessionHandle credential:#'OCI_CRED_RDBMS'
		mode:#'OCI_DEFAULT' errorHandle:errorHandle;

	setAttribute:#'OCI_ATTR_SESSION' value:userSessionHandle errorHandle:errorHandle.
!

initializeServerFor:aDBName
    "establish an access path to the server for the database dbname by attaching.
     Set the server attribute to the server handle in the service context.

     <return: self>"

    "if server handle already initialized return"
    serverHandle notNil ifTrue:[
	^ self
    ].

    "create server context"
    self serverHandle attach:aDBName errorHandle:errorHandle.

    "set attribute server context in the service context"
    self serviceHandle
	setAttribute:#'OCI_ATTR_SERVER'
	value:serverHandle
	errorHandle:errorHandle
!

unblockConnection
    "after unblocking the receiver, an oci call returns immediatly and
     the lib must poll the result. This prevents smalltalk to be blocked
     while doing an oci call.

     <return: self>"

    self serverHandle
	setAttribute:#'OCI_ATTR_NONBLOCKING_MODE'
	value:0
	errorHandle:errorHandle
! !

!OCI8Session methodsFor:'statements'!

describeTable:aTableName
    "describes a table with the name aTableName. A collection of column
     descriptors is returned. Each of them describes a column in the table.

     <return: OrderedCollection with:OCI8ColumnDescriptor>"

    |describeHandle parameterDescriptor numberOfCols listHandle parameterColl|

    [
	describeHandle := environment handle
		    newHandleWithType:#OCI8DescribeHandle.

	"get parameter handle"
	describeHandle
	    describe:aTableName
	    type:#'OCI_PTYPE_TABLE'
	    serviceContextHandle:self serviceHandle
	    errorHandle:errorHandle.

	parameterDescriptor := describeHandle getAttribute:#'OCI_ATTR_PARAM'
		    errorHandle:errorHandle.
	numberOfCols := parameterDescriptor getAttribute:#'OCI_ATTR_NUM_COLS'
		    errorHandle:errorHandle.
	listHandle := parameterDescriptor getAttribute:#'OCI_ATTR_LIST_COLUMNS'
		    errorHandle:errorHandle.
	parameterColl := Array new:numberOfCols.
	1 to:numberOfCols do:[:i |
	    parameterDescriptor := listHandle getParameter:i errorHandle:errorHandle.
	    parameterColl at:i
		put:(parameterDescriptor as:OCI8ColumnDescriptor withErrorHandle:errorHandle)
	]
    ] ensure:[ describeHandle release ].
    ^ parameterColl
!

newStatementFor:aStatementText
    "return a new statement for the text aStatementText. Three different statement type
     could be returned depending on the text. An OCI8QueryStatement is returned if the
     text specified a select statement. An OCI8DMStatement (Data Manipulation) is returned
     for insert, update etc statement texts. An OCI8DDStatement (Data Definition) si returned
     for create, drop etc statement texts.

     <return: OCI8QueryStatement | OCI8DMStatement | OCI8DDStatement>"

    ^ OCI8Statement newForSession:self text:aStatementText.
! !

!OCI8Session methodsFor:'transaction creation'!

newGlobalTransaction

    ^ OCI8GlobalTransaction new.
!

newTransaction

    ^ OCI8Transaction new.
! !

!OCI8Session methodsFor:'transaction operations'!

commitOnePhase
    "one phase commit the current transaction.

     <return: self>"

    serviceHandle commitTransaction:#'OCI_DEFAULT' errorHandle:errorHandle
!

commitTwoPhase
    "two phase commit of the current transaction. Only needed if the oci application
     manageing global transactions.

     <return: self>"

    serviceHandle commitTransaction:#'OCI_TRANS_TWOPHASE' errorHandle:errorHandle
!

detachTransaction
    "detach the current transaction.

     <return: DatabaseTransaction>"

    |trans|

    trans := currentTransaction.
    serviceHandle detachTransactionWithErrorHandle:errorHandle.
    currentTransaction := nil.
    ^ trans

    "
     |session trans|

     session := OCI8Session new.
     session connectWithUsername:'scott' password:'tiger' dbname:'test'.


     trans := session newGlobalTransaction
			     xid:#(1000 #[1 2 3 4] #[1]); beReadOnly; timeout:6.
     session startTransaction:trans.

     trans := session detachTransaction.
     trans inspect.
     Delay waitForSeconds:20.
     session resumeTransaction:trans timeout:10.
     session rollback.
    "
!

prepareTransaction
    "prepare the current transaction (for 2-phase commit).

     <return: self>"

    serviceHandle prepareTransactionWithErrorHandle:errorHandle
!

resumeTransaction:aTransaction timeout:aTimeInteger
    "resume an existing transaction"

    aTransaction startOn:self withFlag:#'OCI_TRANS_RESUME' timeout:aTimeInteger.
    currentTransaction := aTransaction.
!

rollback
    "rollback the current transaction.

     <return: self>"

    serviceHandle rollbackTransactionWithErrorHandle:errorHandle
!

startTransaction:aTransaction
    "start a new transaction.
     The previous transaction (if one exists) is committed"

    serviceHandle commitTransaction:#'OCI_DEFAULT' errorHandle:errorHandle.
    aTransaction startOn:self withFlag:#'OCI_TRANS_NEW' timeout:nil.
    currentTransaction := aTransaction.
! !

!OCI8Session class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8Session.st,v 1.6 2010-10-11 12:00:05 cg Exp $'
! !
