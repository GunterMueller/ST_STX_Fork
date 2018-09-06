"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXConnectionSettings
	instanceVariableNames:'host port database userName userPassword method encodingStrategy'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXConnectionSettings class methodsFor:'instance creation'!

host: aHost port: aPort
	^ self basicNew
		initializeHost: aHost 
			port: aPort;
		yourself
!

host: aHost port: aPort database: aDatabase userName: aUsername userPassword: aPassword
	^ self basicNew
		initializeHost: aHost 
			port: aPort 
			database: aDatabase 
			userName: aUsername  
			userPassword: aPassword
		yourself
!

host: aHost port: aPort database: aDatabase userName: aUsername userPassword: aPassword encodingStrategy: encodingStrategy
	^ self basicNew
		initializeHost: aHost 
			port: aPort 
			database: aDatabase 
			userName: aUsername  
			userPassword: aPassword;
			encodingStrategy: encodingStrategy;
		yourself
!

host: aDatabase userName: aUsername userPassword: aPassword
	^ self basicNew
		initializeHost: aDatabase 
			userName: aUsername  
			userPassword: aPassword
		yourself
! !

!DBXConnectionSettings methodsFor:'accessing'!

database
	^ database
!

database: anObject
	database := anObject
!

host
	^ host
!

host: anObject
	host := anObject
!

method
	^ method ifNil: [ method := DBXAuthenticationMethod usernamePassword ]
!

method: anObject
	^ method := anObject
!

port
	^ port
!

port: anObject
	port := anObject
!

userName
	^ userName
!

userName: anObject
	userName := anObject
!

userPassword
	^ userPassword
!

userPassword: anObject
	userPassword := anObject
! !

!DBXConnectionSettings methodsFor:'encoding'!

encodingStrategy
	"See encodingStrategy:"
	^encodingStrategy.
!

encodingStrategy: anObject
	"Encoding strategy used to determine actaul TextConverter to be used with database connections. Encoding strategy must be able to respond #encoderFor: -message and return TextConverter."

	encodingStrategy := anObject
! !

!DBXConnectionSettings methodsFor:'initialization'!

initializeHost: aHost port: aPort
	self initialize.
	host := aHost.
	port := aPort
!

initializeHost: aHost port: aPort database: aDatabaseName userName: aUserName userPassword: aPassword
	self initialize.
	host := aHost.
	port := aPort.
	database := aDatabaseName.
	userName := aUserName.
	userPassword := aPassword.
!

initializeHost: aDatabaseName userName: aUserName userPassword: aPassword
	self initialize.
	database  := aDatabaseName.
	userName := aUserName.
	userPassword := aPassword.
! !

!DBXConnectionSettings methodsFor:'validating'!

validateMethod
	self method notNil ifTrue: 
		[ self method = DBXAuthenticationMethod usernamePassword ifFalse: [ OpenDBXDriverError signal: 'The only supported method is zero' ] ]
!

validatePort
	(self port notNil and: [ port ~= ''] )
		ifTrue: [(self port asNumber > 0)
			ifFalse: [OpenDBXDriverError signal: 'The port must be a positive number']]
! !

!DBXConnectionSettings class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXConnectionSettings.st,v 1.2 2013-04-15 13:10:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXConnectionSettings.st,v 1.2 2013-04-15 13:10:10 cg Exp $'
! !

