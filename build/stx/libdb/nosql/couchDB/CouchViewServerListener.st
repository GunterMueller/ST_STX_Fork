"{ Package: 'stx:libdb/nosql/couchDB' }"

Object subclass:#CouchViewServerListener
	instanceVariableNames:'port process handlerClass'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Viewserver'
!


!CouchViewServerListener class methodsFor:'initialization'!

initialize
	Smalltalk addToStartUpList: self after: AutoStart.
	Smalltalk addToShutDownList: self
! !

!CouchViewServerListener class methodsFor:'public'!

on: aNumber handlerClass: aClass
	"Instantiate a new listener on a given port for a given class,
	send #start to it to start listening."

	^self new port: aNumber; handlerClass: aClass; yourself
!

start
	"Instantiate a new listener on port 5791 and start listening."

	^self startOn: 5791
!

startOn: aNumber
	"Instantiate a new listener on a given port and start listening."

	^self startOn: aNumber handlerClass: CouchViewServer
!

startOn: aNumber handlerClass: aClass
	"Instantiate a new listener on a given port and start listening."

	^(self on: aNumber handlerClass: aClass) start; yourself
! !

!CouchViewServerListener methodsFor:'accessing'!

handlerClass: aClass
	handlerClass := aClass
!

port
	  ^port
!

port: aNumber
	port := aNumber
!

process
	  ^process
! !

!CouchViewServerListener methodsFor:'constants'!

backlogSize
	^50
!

servePriority
	^Processor highIOPriority "userBackgroundPriority"
! !

!CouchViewServerListener methodsFor:'private'!

listenLoop
	"We create a listening Socket, then wait for a connection.
	After each connection we also check that the listening Socket
	is still valid - if not we just make a recursive call to this method
	to start over."

	| socket |
	socket := Socket newTCP.
	self setSocketOptions: socket.
	socket listenOn: port backlogSize: self backlogSize.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port displayString ].
	[[
		socket isValid ifFalse: [
			"will trigger #ifCurtailed: block and destroy socket"
			^self listenLoop ].
		self serveConnectionOn: socket] repeat ]
	
		ifCurtailed: [
			"probably copy pasted from ConnectionQueue >> #listenLoop"
			(Delay forMilliseconds: 10) wait.
			socket destroy ]
!

serveConnectionOn: listeningSocket
	"We wait up to 10 seconds for an incoming connection.
	If we get one we wrap it in a SocketStream and then let
	the server handle it."
		 
	| stream socket |
	socket := (listeningSocket waitForAcceptFor: 10) ifNil: [^ self].
	self setSocketOptions: socket.
	stream := SocketStream on: socket.
	stream autoFlush: false; noTimeout.
	[[[
		handlerClass new handle: stream
	]
		ensure: [ stream close ]]
			ifCurtailed: [ socket destroy ]]
				forkAt: self servePriority
!

setSocketOptions: aSocket
	"Tweak using options."

	aSocket setOption: 'TCP_NODELAY' value: 1.
"	aSocket setOption: 'TCP_MAXSEG' value: 0."
	aSocket setOption: 'SO_SNDBUF' value: 16384.
	aSocket setOption: 'SO_RCVBUF' value: 87380.
! !

!CouchViewServerListener methodsFor:'public'!

start
	self stop.
	process := [ [ self listenLoop ] repeat ]
		forkAt: Processor highIOPriority
!

stop
	process ifNotNil: [process terminate. process := nil]
! !

!CouchViewServerListener class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServerListener.st,v 1.1 2013-04-04 14:38:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServerListener.st,v 1.1 2013-04-04 14:38:08 cg Exp $'
! !


CouchViewServerListener initialize!
