"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb' }"

"{ NameSpace: SQL }"

Connection subclass:#DatabaseSession
	instanceVariableNames:'connected environment errorHandle serverHandle serviceHandle
		userSessionHandle currentTransaction cachedRowObjectClasses'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!DatabaseSession class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    Framework for accessing databases.
    For accessing an XXX-database create an instance of XXXSession with:
	XXXSession class>>default.

    Connect to a database with:
	XXXSession>>connectWithUsername:password:dbname:

    Disconnect from a database with:
	XXXSession>>disconnect
    A disconnect is done if your instance of XXXSession is finalized.

    Create a statement with:
	XXXSession>>newStatementFor:
	Returns an instance of XXXStatement (OCI8Statament, ODBCStatement etc.)

    Execute a statement with (does an implicit fetch for OCI8QueryStatement):
	XXXSession>>executeStatement:                         (for OCI8DDStatement and OCI8DMStatement)
	XXXSession>>executeStatement:from:                    (for OCI8DMStatement and OCI8QueryStatement)
	XXXSession>>executeStatement:from:into:               (for OCI8DMStatement and OCI8QueryStatement)
	XXXSession>>executeStatement:from:into:numberOfRows:  (for OCI8QueryStatement)
	XXXSession>>executeStatement:into:                    (for OCI8DMStatement and OCI8QueryStatement)
	XXXSession>>executeFrom:into:numberOfRows:            (for OCI8QueryStatement)

    Fetch (more) results from a statement (OCI8QueryStatement) with (used when the results are
    restricted by numberOfRows):
	XXXSession>>fetchDataForStatement:anOCI8Statement into:               (for OCI8QueryStatement)
	XXXSession>>fetchDataForStatement:anOCI8Statement into:numberOfRows:  (for OCI8QueryStatement)

    To create transcations call:
	XXXSession>>newReadOnlyTransaction
	XXXSession>>newReadWriteTransaction

    For detailed information see ee the examples in OCI8Session, OCI8DDStatement, OCI8DMStatement,
    OCI8QueryStatement and OCI8Transaction.

    [author:]
	Pierre Schwarz
	Stefan Vogel
	Claus Gittinger

    [see also:]
	OCI8Session

    [instance variables:]

	connected <Boolean>
	    Is true if a session is connected to a database, false if not.

	environmentHandle <OCI8Handle>
	    Holds the environment handle of the oci lib for the session. All other handles
	    are subhandles of the environment handle. In the finalization of a session only
	    the environment handle needs to be freed. All other subhandles are released implicit.

	errorHandle <OCI8Handle>
	    Holds an error handle. To most of the oci methods a error handle is passed to
	    get more information in case of an error. Used for the internal error handling of
	    the oci lib.

	serverHandle <OCI8Handle>
	    Holds an handle to the oci server. The server handle is attached to the
	    service handle with the database name given in the connection method.

	serviceHandle <OCI8Handle>
	    Holds an handle to the oci service. The server handle and user handle are
	    attached to this handle.

	userSessionHandle <OCI8Handle>
	    Holds an handle to an oci user session. The user session handle is attached to the
	    service handle with the username, password given in the connection method.

    [class variables:]
	none
"
! !

!DatabaseSession class methodsFor:'instance creation'!

defaultEnvironment
    self subclassResponsibility
!

new
    "creates a new session and initializes in the default mode.

     <return: DatabaseSession>"

    ^ self newForEnvironment:(self defaultEnvironment)
!

newConnectionForTests
    "this connection is used for tests.
     Change to your own database and credentials"

    ^ self new connectWithUsername:'scott' password:'tiger' dbname:'docker'.
!

newForEnvironment:environment
    "creates a new session and initializes in the default oci mode.

     <return: DatabaseSession>"

    ^ self basicNew environment:environment
!

shared
    self subclassResponsibility
!

threaded
    self subclassResponsibility
! !

!DatabaseSession class methodsFor:'defaults'!

defaultCachedRowObjectClasses
    "default value for the 'cachedRowObjectClasses' instance variable (automatically generated)"

    self halt:'unfinished code'.
    ^ nil.
! !

!DatabaseSession methodsFor:'accessing'!

cachedRowObjectClasses
    "see SQL::Cursor>>#rowAsObject, for how this is used..."

    cachedRowObjectClasses isNil ifTrue:[
        cachedRowObjectClasses := Dictionary new.
    ].
    ^ cachedRowObjectClasses
!

environment
    ^ environment
!

environment:something
    "set the environment and allocate an error handle"

    environment := something.
    self errorHandle.
!

flushCachedRowObjectClasses
    cachedRowObjectClasses := nil

    "
     self allInstancesDo:[:session | session flushCachedRowObjectClasses]
    "
! !

!DatabaseSession methodsFor:'compatibility-squeak'!

query:sqlStatementText
    ^ self newStatementFor:sqlStatementText
! !

!DatabaseSession methodsFor:'connection setup & teardown'!

connectWithUsername:aUsername password:aPassword dbname:aDBName 
    "establish a server to the database dbname and start a user session with username and password.
     If already connected do nothing.
    "

    self isConnected ifTrue:[^ self].

    self initializeServerFor:aDBName.

"/        self setInternalName:'internal-stefan'.
    self setExternalName:'external-stefan'.
    self 
	beginUserSessionFor:aUsername
	password:aPassword.

    "unblock the connection. not allowed before #beginSession..." 
    self unblockConnection.
    self connected:true.
!

disconnect
    "terminate a databese session and disconnect from the database server.
     The server, user session and service context handles are deallocated. 
     It is possible to disconnect while a statement is executed."

    self isConnected ifTrue:[
	Error handle:[:ex | ] do:[ self endUserSession].
	self releaseUserSessionHandle.
	Error handle:[:ex | ] do:[ self detachServer].
	self releaseServerHandle.
	self connected:false.
    ].
!

setExternalName:aString 
    "set the external name of the server.
     One of external or internal name must be set in order to use global locks"

    self subclassResponsibility.
!

setInternalName:aString 
    "set the external name of the server.
     One of external or internal name must be set in order to use global locks"

    self subclassResponsibility.
! !

!DatabaseSession methodsFor:'error handling'!

errorNotConnected
    self logOnError:' - cannot perform operation if not connected'
!

logOnError:message
    DatabaseError raiseErrorString:message
! !

!DatabaseSession methodsFor:'initialization & release'!

initialize:aModeColl
    "initialize the enviroment and error handle."

    self subclassResponsibility.
! !

!DatabaseSession methodsFor:'obsolete statement execution'!

executeStatement:aStatement from:anInsertStreamOrCollection
    "
     executes a database statement.
     The values for the variables in the statement text are taken from the stream/collection anInsertStreamOrCollection.
    "

    self executeStatement:aStatement from:anInsertStreamOrCollection into:nil.
!

executeStatement:aStatement from:anInsertStreamOrCollection into:aReturningStream
    "
     executes a database statement.
     The values for the variables in the statement text are taken from the stream/collection anInsertStreamOrCollection.
     The result of the statement will be put into the stream aReturningStream.
    "

    self isConnected ifTrue:[
	aStatement executeFrom:anInsertStreamOrCollection into:aReturningStream.
    ] ifFalse:[
	self errorNotConnected
    ]
!

executeStatement:aStatement from:anInsertStreamOrCollection into:aReturningStream numberOfRows:aRowIntegerOrNil
    "
     executes a database statement.
     The values for the variables in the statement text are taken from the stream/collection anInsertStreamOrCollection.
     The result of the statement will be put into the stream aReturningStream.
     If a aRowIntegerOrNil is nil all results of the statement will be inserted into the stream aReturningStream,
     otherwise, only the first aRowIntegerOrNil number of results will be inserted.
    "

    self isConnected ifTrue:[
	aStatement executeFrom:anInsertStreamOrCollection into:aReturningStream numberOfRows:aRowIntegerOrNil.
    ] ifFalse:[
	self errorNotConnected
    ]
!

executeStatement:aStatement into:aReturningStream
    "
     executes a database statement.
     The result of the statement will be put into the stream aReturningStream.
    "

    self isConnected ifTrue:[
	aStatement executeInto:aReturningStream.
    ] ifFalse:[
	self errorNotConnected
    ]
!

executeStatement:aStatement into:aReturningStream numberOfRows:aRowIntegerOrNil
    "
     executes a database statement.
     The result of the statement will be put into the stream aReturningStream.
     If a aRowIntegerOrNil is nil all results of the statement will be inserted into the stream aReturningStream,
     otherwise, only the first aRowIntegerOrNil number of results will be inserted.
    "

    self isConnected ifTrue:[
	aStatement executeInto:aReturningStream numberOfRows:aRowIntegerOrNil.
    ] ifFalse:[
	self errorNotConnected
    ]
! !

!DatabaseSession methodsFor:'private'!

releaseServerHandle
    "release the server handle"

    |tmpHandle|

    tmpHandle := serverHandle.
    serverHandle := nil.
    tmpHandle release.
!

releaseUserSessionHandle
    "release the user session handle"

    |tmpHandle|

    tmpHandle := userSessionHandle.
    userSessionHandle := nil.
    tmpHandle release.
! !

!DatabaseSession methodsFor:'private accessing'!

connected:aBoolean
    "sets the connection state of the session"

    connected := aBoolean.
!

environmentHandle
    ^ environment handle
!

errorHandle
    "
    returns the error handler from the session.
    The handle is used to get specific informations when an error occurred.

    <return: ErrorHandle>
    "

    errorHandle isNil ifTrue:[
        errorHandle := environment handle newErrorHandle.
    ].
    ^ errorHandle
!

serverHandle
    "
     returns the server handle.

     <return: ServerHandle>
    "

    serverHandle isNil ifTrue:[
        serverHandle := environment newDatabaseHandle.
    ].
    ^ serverHandle
!

serviceHandle
    "returns the service context handle.

     <return: ServiceContextHandle>
    "

    serviceHandle isNil ifTrue:[
	serviceHandle := environment handle newServiceContextHandle.
    ].
    ^ serviceHandle
!

userSessionHandle
    "
     returns the user session handle. 

     <return: UserSessionHandle>
    "

    userSessionHandle isNil ifTrue:[
	userSessionHandle := environment handle newUserSessionHandle
    ].
    ^ userSessionHandle
! !

!DatabaseSession methodsFor:'private connection handling'!

beginUserSessionFor:aUsername password:aPassword 
    "set the username and password properties in the user session handle and
     connect to the server. Add the session handle to the session attribute
     of the service context."

    self subclassResponsibility 
!

detachServer
    "detaches from the server."

    serverHandle detachWithErrorHandle:errorHandle.
!

endUserSession
    "terminate the user session (log off the user from the database)"

    serviceHandle endSession:userSessionHandle errorHandle:errorHandle.
!

initializeServerFor:aDBName 
    "establish an access path to the server for the database dbname by attaching.
     Set the server attribute to the server handle in the service context."

    self subclassResponsibility 
!

unblockConnection
    "after unblocking the receiver, an oci call returns immediatly and
     the lib must poll the result. This prevents smalltalk to be blocked
     while doing an oci call."

    self subclassResponsibility 
! !

!DatabaseSession methodsFor:'statements'!

describeTable:aTableName 
    "describes a table with the name aTableName. A collection of column
     descriptors is returned. Each of them describes a column in the table.

     <return: OrderedCollection with:DatabaseColumnDescriptor>"

    self subclassResponsibility
!

execute:aStatementText
    "execute the statementText and return the result.
     The statement (i.e. the Database cursor) is released after execution"

    ^ self execute:aStatementText release:true
!

execute:aStatementText release:doRelease
    "execute the statementText and return the result.
     The statement (i.e. the Database cursor) is released after execution"

    |statement result|

    statement := self newStatementFor:aStatementText.
    result := statement execute.
    doRelease ifTrue:[
        statement release.
        ^ nil.
    ].
    ^ result.
!

execute:aStatementText with:valueCollection
    "execute the statementText, passing data and return the result.
     The statement (i.e. the Database cursor) is released after execution"

    ^ self execute:aStatementText with:valueCollection release:true
!

execute:aStatementText with:valueCollection release:doRelease
    "execute the statementText, passing data and return the result.
     The statement (i.e. the Database cursor) is released after execution"

    |statement result|

    statement := self newStatementFor:aStatementText.
    result := statement executeWith:valueCollection.
    doRelease ifTrue:[
        statement release.
        ^ nil.
    ].
    ^ result.
!

executeDirect:aStatementText
    "execute the statementText and return the result.
     The statement (i.e. the Database cursor) is released after execution"

    ^ self executeDirect:aStatementText release:true
!

executeDirect:aStatementText release:doRelease
    "execute the statementText and return the result.
     If doRelease is true,
        the statement (i.e. the Database cursor) is released after execution"

    |statement result|

    statement := self newStatementFor:aStatementText.
    result := statement executeDirect.
    doRelease ifTrue:[
        statement release.
        ^ nil.
    ].
    ^ result.
!

executeDirect:aStatementText with:valueCollection
    "execute the statementText, passing data and return the result.
     The statement (i.e. the Database cursor) is released after execution"

    ^ self executeDirect:aStatementText with:valueCollection release:true
!

executeDirect:aStatementText with:valueCollection release:doRelease
    "execute the statementText, passing data and return the result.
     The statement (i.e. the Database cursor) is released after execution"

    |statement result|

    statement := self newStatementFor:aStatementText.
    result := statement executeDirectWith:valueCollection.
    doRelease ifTrue:[
        statement release.
        ^ nil.
    ].
    ^ result.
!

executeStatement:aDatabaseStatement 
    "execute a DatabaseStatement"

    aDatabaseStatement executeOn:self.
!

newStatementFor:aStatementText 
    "return a new statement for the text aStatementText. 
     Different statement types could be returned depending on the text.

     <return: DatabaseStatement>"

    self subclassResponsibility
! !

!DatabaseSession methodsFor:'testing'!

isConnected
    "test if the receiver is connected.

     <return: Boolean>"

    connected isNil ifTrue:[
	connected := false.
    ].
    ^ connected
! !

!DatabaseSession methodsFor:'transaction creation'!

newGlobalTransaction
    self subclassResponsibility
!

newTransaction
    self subclassResponsibility
! !

!DatabaseSession methodsFor:'transaction operations'!

commit
    "one phase commit the current transaction."

    self commitOnePhase
!

commitOnePhase
    "one phase commit the current transaction."

    self subclassResponsibility
!

commitTwoPhase
    "two phase commit of the current transaction. Only needed if the oci application
     manageing global transactions."

    self subclassResponsibility
!

detachTransaction
    "detach the current transaction.

     <return: DatabaseTransaction>"

    self subclassResponsibility
!

prepareTransaction
    "prepare the current transaction (for 2-phase commit)."

    self subclassResponsibility
!

resumeTransaction:aTransaction timeout:aTimeInteger
    "resume an existing transaction"

    self subclassResponsibility
!

rollback
    "rollback the current transaction."

    self subclassResponsibility
!

startTransaction:aTransaction
    "start a new transaction.
     The previous transaction (if one exists) is committed"

    self subclassResponsibility
! !

!DatabaseSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseSession.st,v 1.18 2016-08-15 10:52:26 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseSession.st,v 1.18 2016-08-15 10:52:26 mawalch Exp $'
! !

