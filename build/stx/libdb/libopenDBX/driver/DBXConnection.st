"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXConnection
	instanceVariableNames:'platform settings handle open connected result transactionOpened
		encoder'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXConnection class methodsFor:'initialization'!

initialize
	"DBConnection initialize"

	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self.
! !

!DBXConnection class methodsFor:'instance creation'!

platform: aPlatform settings: aConnectionSettings
	^self new
		platform: aPlatform;
		settings: aConnectionSettings;
		yourself
! !

!DBXConnection class methodsFor:'logging'!

log: message
	Transcript show: message; cr.
! !

!DBXConnection class methodsFor:'system startup'!

shutDown: quitting
	quitting ifTrue: [ self allInstancesDo: [:each | each shutDown]]
!

startUp: resumming
	"The OpenDBX current has to be reinitialized just in case the same image is loaded in a different Operating System"
	resumming ifTrue: [OpenDBX current: nil].
! !

!DBXConnection methodsFor:'*dbxdatabasemodel'!

schemas
	^platform schemasOn: self
!

tablesDescriptionForSchema: aSchemaName
	^ platform tablesDescriptionForSchema: aSchemaName on: self.
! !

!DBXConnection methodsFor:'accessing'!

authenticationMethod
	^ settings method
!

database
	^ settings database
!

handle
	^handle
!

host
	^ settings host
!

platform
	^platform
!

platform: aPlatform
	platform := aPlatform
!

port
	^ settings port
!

result
	^ result
!

result: anObject 
	result := anObject
!

settings
	^ settings
!

settings: aConnectionSettings
	settings := aConnectionSettings
!

transactionOpened 
	^ transactionOpened 
!

userName
	^ settings userName
!

userPassword
	^ settings userPassword
! !

!DBXConnection methodsFor:'comparing'!

= aDBXConnection
	^ self handle = aDBXConnection handle.
!

hash
	^ self handle hash
! !

!DBXConnection methodsFor:'connection open/close'!

close
	"It closes the connection releasing all the results. It will probably free tcp/ip database connection. You must re open it in order to execute more queries"
	self isOpen
		ifFalse: [OpenDBXDriverError signal: 'The connection is not open. Try opening it first'].
	self releasePreviousResult.
	self platform closeConnection: self.
	transactionOpened := false.
	self internalBeClosed
!

connect
	"This is the first method that must be called to a connection. It connects to database host and creates all the data structure for a connection. After it, you can call open. You cannot connect an already connected connection"
	self isConnected
		ifTrue: [OpenDBXDriverError signal: 'You are already connected. Try disconnecting first' ].
	self validateSettingsForConnect.
	"WARNING This is the only place where we have direct access to
	handles... "
	handle := self platform createConnection: self.
	
	self platform class isAutomaticConnectionReleaseOnGC ifTrue: [
		OpenDBXDriverSmalltalkDialect current addObjectToGarbageCollect: self].
	
	self internalBeConnected.
	
!

connectAndOpen
"Take into consideration that using this method you cannot specify special options because 
many of them should be called between connect and open operations
In case you don't want to use any OpenDBXDriver special options, you can use this message. However, we recommend to use connect and open separately"	
	self connect.
	self open.
!

disconnect
	" Disconnect from database releasing all resultSets. No operation will be permitted after it. It must be call when you finish using the connection. If the connection wasn't close, it will do it. In order to do a disconnection, the connection must be connected'"
	self isConnected
		ifFalse: [^ nil].
	self isOpen
		ifTrue: [self close].
	self releaseConnection.
	self internalBeDisconnected.
	handle := nil
!

open
	"Opens the connection. You must first do a connect and you cannot call this method if the connection is already open.. This method will probably opens the tcp/ip database connection. After calling this method, you should be able to send queries"
	self isConnected ifFalse: [
		OpenDBXDriverError signal: 'You are not connected. Try connecting first'].
	self isOpen ifTrue: [ 
		OpenDBXDriverError signal: 'The connection is already open'].
	self validateSettingsForOpen.
	"If it's a fatal error, it means it couldn't open the connection, therefore, we just disconnect it and signal the error again"
	[ self platform openConnection: self.] 
		on: DBXFatalError 
		do: [ :aFatalError | 
			self disconnect.
			aFatalError signal ].
	self internalBeOpen.
	self setEncoding.
	self setDateStyle. 
!

reOpen: aConnectionSettings
	"It simply do a close and an open with the new connectionSettings. 
	Suppouse you have a DBXConnection connected and open. Sometimes it may be necessary to connect to a different database (schema) or re-authenticate using different credentials. In such a case you can use this message"
	self isConnected ifFalse: [
		OpenDBXDriverError signal: 'You are not connected. Try connecting first' ].
	self isOpen ifFalse: [ 
		OpenDBXDriverError signal: 'The connection must be open in order to reOpen it' ].
	self close.
	self settings: aConnectionSettings.
	self open.
! !

!DBXConnection methodsFor:'encoding'!

decodeString: aByteArray
	"Decodes system string from encoded representation."

	^ encoder isNil ifTrue:[aByteArray ] ifFalse: [encoder convertFromSystemString: aByteArray].
!

encodeString: aString
	"Encodes system string to some format"

	^ encoder isNil ifTrue:[aString] ifFalse:[ encoder convertToSystemString: aString].
!

queryEncoding
	"I return prefered encoding for my self. I need the help of my platform to do it but it
	is possible that the platform has no idea about the encoding. "
	^(self platform queryEncoding: self).
!

setEncoding
	"Sets the encoding based on encoding strategy."

	self settings encodingStrategy isNil
		ifFalse: [ encoder := self settings encodingStrategy encoderFor: self ]
! !

!DBXConnection methodsFor:'finalization'!

finalize
	" If it is connected, it will disconnect it"
	self isConnected ifTrue: [ self disconnect ]
!

releasePreviousResult
	"If there is, I must release the previous query"
	self result ifNotNil: [ self result releaseResult ].
	self result: nil.
! !

!DBXConnection methodsFor:'initialization'!

initialize
	super initialize.
	"These ValueHolder are very important and you cannot change them. If you instantiate a DBXConnection and never do the disconnect, OpenDBXDriver will do it whe the object is garbage collected. How OpenDBXDriver do that? DBXConnection is registered in the default WeakRegistry. So, when you call connect we add the object to that registry. In that moment a clone is generated from the original object. Suppose you then do the disconnect to the original object. If we don't use ValueHolder, the clone will have other objects for open and connected and because of this, the disconnect will be called twice, generating an openDBX error.' "
	open := ValueHolder new contents: false.
	connected := ValueHolder new contents: false.
	result := nil.
	transactionOpened := false.
!

initializePlatform: aPlatform settings: aConnectionSettings handle: aNumber
	platform := aPlatform.
	settings := aConnectionSettings.
	handle := aNumber.
	self internalBeConnected.
!

setDateStyle
	self platform setDateStyleOn: self.
! !

!DBXConnection methodsFor:'options'!

enableCompression
	"It tries to enable Compression option. If it can, it activates the option, returns true and you can use that option. If not, it will return false. So you must ask the return on this method in order to now what to do."
	^self enableSpecialOption: DBXSpecialOptions compression.
!

enableEncryption: aEncryptionOption
"It tries to enable Encryption option. If it can, it activates the option, returns true and you can use that option. If not, it will return false. So you must ask the return on this method in order to now what to do."
	(self isOptionSupportedByPlattform: DBXSpecialOptions encryption) ifTrue: 
		[ self platform 
			setOption: DBXSpecialOptions encryption
			value: aEncryptionOption
			on: self.
		^ true ].
	^ false
!

enableMultipleStatements
"It tries to enable Multiple Statements option. If it can, it activates the option, returns true and you can use that option. If not, it will return false. So you must ask the return on this method in order to now what to do."
	^self enableSpecialOption: DBXSpecialOptions multipleStatements
!

enablePagedResults
"It tries to enable paged results. If it can, it activates the option, returns true and you can use that option. If not, it will return false. So you must ask the return on this method in order to now what to do."
	^self enableSpecialOption: DBXSpecialOptions pagedResults.
!

enableSpecialModes: modes 
	"It tries to enable specific modes. For example MySQL special modes (http://dev.mysql.com/doc/refman/5.0/en/server-sql-mode.html). If it can, it activates the option, returns true and you can use that option. If not, it will return false. So you must ask the return on this method in order to now what to do."
	(self isOptionSupportedByPlattform: DBXSpecialOptions specialModes) ifTrue: 
		[ self platform 
			setOption: DBXSpecialOptions specialModes
			value: modes
			on: self.
		^ true ].
	^ false
!

enableSpecialOption: specialOption 
	"It returns if the specialOption could be enable or not.
	Before enabling a specific option, I must be sure the current backend
	support it"
	(self isOptionSupportedByPlattform: specialOption)
		ifTrue: [self platform
				setOption: specialOption
				value: true
				on: self.
				^true.].
		^false.
!

isOptionSupportedByPlattform: specialOption 
"It returns if the specialOption is supported by the backend"
	^self platform
		getOption: specialOption
		on: self.
! !

!DBXConnection methodsFor:'private'!

internalBeClosed
	open contents: false
!

internalBeConnected
	connected contents: true.
!

internalBeDisconnected
	connected contents: false.
!

internalBeOpen
	open contents: true.
! !

!DBXConnection methodsFor:'query'!

execute: aString 
	"This message is used for ALL type of query: SQL, DML and DDL.
	Depending on the type of query it will return DBXResult or
	DBXResultSet. 
	The queries sent to the server must be understood by the DBMS because
	there is no translation done between the different dialects of SQL for
	example. 
	To execute a query you must be connected and open.
	You DON'T need to call nextRow till nil its returned, the framework will
	do it for you in your next query. 
	If you want multistatement queries, you must use executeMultiStatement:
	
	"
	| aResult |
	self isOpen ifFalse: 
		[ OpenDBXDriverError signal: 'You cannot execute a query if the connection is not open' ].
	self releasePreviousResult.
	aResult := self platform 
		executeStatement: aString
		on: self.
	self result: aResult.
	^ self result
!

execute: aString querySettings: aQuerySettings 
	"Same as execute, but it ads a query settings.
	A query settigs has two things: pageSize and timeout.
	
	Page size: Dependent on the native
	database library, it may be possible to retrieve all rows at once (if the
	page size parameter is zero), one by one or more than one row at once.
	All positive values including zero are allowed as values for the page size If
	paging (more than one row at once) is not supported by the backend, it
	will use one by one or all at once if this is the only option provided.
	
	Timeout: Restricts the time OpenDBXDriver is waiting for a result form the server. 
	It may be nil to wait until a result arrives. Otherwise, it can contain any number 
	of seconds and microseconds to wait for.
	
	"
	| aResult |
	self isOpen ifFalse: 
		[ OpenDBXDriverError signal: 'You cannot execute a query if the connection is not open' ].
	self releasePreviousResult.
	aResult := self platform 
		executeStatement: aString
		on: self
		querySettings: aQuerySettings.
	self result: aResult.
	^ self result
!

executeDDLScript: aDDLScript 
"Its very common you need to execute a complete DDL script: create, drop or alter tables. In these cases, you don't have any interesting results from each query. In such a case, you should use this method. Remember OpenDBXDriver doesn't do any translation so your statement delimiter must be understood by the backend. In order to know which delimiter we use, you can see the message queryDelimiter of the current platform backend, for example DBXPostgresBackend.
This message doesn't use the multistatements option of openDBX, it is all done by OpenDBXDriver so you don't have to care about it"

	| ddlStatements |
	ddlStatements := aDDLScript findTokens: self platform queryDelimiter.
	ddlStatements
		do: [:ddlStatement | self execute: ddlStatement]
!

executeMultiStatement: aString
	"This message is used when you must use multistatement, stored procedures or functions.
	It returns a DBXMultiStatementResultSetIterator. 
	The queries sent to the server must be understood by the DBMS because
	there is no translation done between the different dialects of SQL for
	example. 
	To execute a query you must be connected and open.
	
	You DON'T need to call next till nil its returned, the framework will
	do it for you in your next query.
	"
		
	| multiStatmentIterator |
	self isOpen ifFalse: 
		[ OpenDBXDriverError signal: 'You cannot execute a query if the connection is not open' ].
	self result ifNotNil: [ self result releaseResult ].
	multiStatmentIterator := self platform 
		executeMultiStatement: aString
		on: self.
	self result: multiStatmentIterator.
	^ self result
!

processNextResultSetMultiStatement: aQuerySettings
	"proccess and obtains the next resultset"
	^ self platform processNextResultSet: self querySettings: aQuerySettings
! !

!DBXConnection methodsFor:'release'!

cleanUp
"It cleanUps all the necessary stuff from the connection so that it can be safetly used in another context, without needing to close it and open it again. For example, if the last query with this connection, did not finish to get all resultSets and raws, it will do it. If there was a transaction opened, it will be rollbacked.
This methos is useful for a ConnectionPool. When someone gives to back a connection (because it is not used anymore) con can send this message and after this, the connection should be perfectly avaiable for another user."
	self rollbackCurrentTransaction.
	self releasePreviousResult.
	
!

releaseConnection
	self platform disconnectConnection: self
!

releaseResult
	 self result releaseResult 
! !

!DBXConnection methodsFor:'running'!

shutDown
	"This message is called when the object is garbage collected. In case the connection was connected, but not disconnected, it will be disconnected"
	 self isConnected ifTrue: [
		 [self disconnect] on: Error do: [:e | Transcript show: e ] ]
!

startUp
	"till now, nothing is done on the startup"
! !

!DBXConnection methodsFor:'testing'!

isConnected
	^connected contents.
!

isOpen
	^open contents.
! !

!DBXConnection methodsFor:'transactional manage'!

commit
	"executes a commit statement"
	| aResult |
	self isOpen ifFalse: 
		[ OpenDBXDriverError signal: 'You cannot commit if the connection is not open' ].
	self result ifNotNil: [ self releaseResult ].
	aResult := self platform commit: self.
	transactionOpened := false.
	self result: aResult.
	^ self result
!

rollback
	"executes a rollback statement"
	| aResult |
	self isOpen ifFalse: 
		[ OpenDBXDriverError signal: 'You cannot rollback if the connection is not open' ].
	self result ifNotNil: [ self releaseResult ].
	aResult := self platform rollback: self.
	transactionOpened := false.
	self result: aResult.
	^ self result
!

rollbackCurrentTransaction
	transactionOpened ifTrue: [self rollback].
	transactionOpened := false.
!

startTransaction
	"executes a start transaction statement"
	| aResult |
	self isOpen ifFalse: 
		[ OpenDBXDriverError signal: 'You cannot start a transaction if the connection is not open' ].
	self result ifNotNil: [ self releaseResult ].
	aResult := self platform startTransaction: self.
	transactionOpened := true.
	self result: aResult.
	^ self result
! !

!DBXConnection methodsFor:'validating'!

validateSettingsForConnect
	self settings validatePort.
!

validateSettingsForOpen
	self settings method.
! !

!DBXConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXConnection.st,v 1.2 2013-04-15 13:11:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXConnection.st,v 1.2 2013-04-15 13:11:34 cg Exp $'
! !


DBXConnection initialize!
