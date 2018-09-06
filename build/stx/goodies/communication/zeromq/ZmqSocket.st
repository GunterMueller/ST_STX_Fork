"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqSocket
	instanceVariableNames:'socketPointer context associations parked monitor resultHandler
		dataAvailable'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!


!ZmqSocket class methodsFor:'as yet unclassified'!

context: aZmqContext
        ^super new initialize context:  aZmqContext; yourself.
!

createSocketCreationMethodToContext
        (self class methodDictionary at: #socketType) isAbstract
                ifFalse: [ 
                        ZmqContext
                                compileSilently: self name asString asLegalSelector , '^ self newSocket:' , self name asString
                                classified: #'socket creation'
                                notifying: nil ]
!

initializeAllSubclasses
	self subclasses do: [:subclass| subclass initialize].
!

new
	^ZmqContext new newSocket: self.
!

socketPointer: socketPointer inContext: aZmqContext
	^self new socketPointer: socketPointer inContext: aZmqContext.
!

socketType
	self subclassResponsibility.
! !

!ZmqSocket class methodsFor:'class initialization'!

initialize
	super initialize.
	self createSocketCreationMethodToContext.
! !

!ZmqSocket methodsFor:'accessing'!

context: aZmqContext
	context := aZmqContext
! !

!ZmqSocket methodsFor:'actions'!

close
	self logDebug:'Socket close called'.
	context removeSocket: self.
! !

!ZmqSocket methodsFor:'as yet unclassified'!

addAssociation: aZmqSocketAssociation
	monitor
		critical: [ 
			aZmqSocketAssociation associateSocket: self.
			associations add: aZmqSocketAssociation ]
!

bind: aByteString
	self addAssociation: (ZmqSocketBind toTarget: aByteString).
!

connect: aByteString
	self addAssociation: (ZmqSocketConnection toTarget: aByteString).
!

context
	^ context
!

logDebug: aString
	ZmqLog logDebug: self asString,': ', aString.
!

logError: aString
	ZmqLog logError: self asString,': ', aString.
!

needsPoller 
	^false
!

newSocketPointer
	^ZmqApi apiZmqSocketInContext:  context contextPointer socketType: self socketType.
!

printOn: aStream
        aStream nextPutAll: self socketTypeName.
        aStream nextPut:$(.
        Smalltalk isSmalltalkX ifTrue:[
            associations printOn:aStream.
        ] ifFalse:[
            aStream nextPutAll: (',' join: associations).
        ].
        aStream nextPut:$).
!

privateClose
        monitor
                critical: [ 
                        socketPointer
                                ifNotNil: [ 
                                        self context zmqApi "ZmqApi" closeSocket: socketPointer.
                                        socketPointer := nil.] ]
!

receive
        ^ monitor 
                critical: [ 
                        | messagePointer msg zmqApi|
                        zmqApi := self context zmqApi.
                        messagePointer := zmqApi newMessagePointer.
                        zmqApi initializeMessage: messagePointer.
                        zmqApi receiveFromSocket: self socketPointer message: messagePointer.
                        msg := zmqApi messageContent: messagePointer.
                        zmqApi closeMessage: messagePointer.
                        msg 
                ]
!

receiveIfAvailable
        ^ monitor
                critical: [ 
                        | read messagePointer msg zmqApi|
                        zmqApi := self context zmqApi.
                        messagePointer := zmqApi newMessagePointer.
                        zmqApi initializeMessage: messagePointer.
                        read := zmqApi
                                receiveFromSocket: self socketPointer
                                message: messagePointer
                                withFlags: ZmqApiConstants zmqNoBlock.
                        read < 0 ifFalse: [ 
                            msg := zmqApi messageContent: messagePointer.
                            zmqApi closeMessage: messagePointer 
                        ].
                        msg 
                ]
!

send: aByteArray
        monitor
                critical: [ 
                        | messagePointer zmqApi|
                        self waitForUnpark.
                        zmqApi := self context zmqApi.
                        messagePointer := zmqApi messageFromByteArray: aByteArray.
                        zmqApi executeApiCall: [ zmqApi apiZmqSendToSocket: self socketPointer message: messagePointer withFlags: 0 ].
                        zmqApi executeApiCall: [ zmqApi apiZmqMsgClose: messagePointer ].
                        self logDebug: 'Sended ' , aByteArray size asString , ' bytes' ]
!

socketPointer
        ^ monitor
                critical: [ 
                        self waitForUnpark.
                        socketPointer ifNil: [ 
                            socketPointer := self newSocketPointer.
                            Smalltalk isSmalltalkX ifTrue:[
                                socketPointer := ZmqApiSocket address:(socketPointer address).   
                            ].
                        ].
                        socketPointer
                ]
!

socketPointer: aZmqApiSocket inContext: aZmqContext
	socketPointer := aZmqApiSocket.
	context := aZmqContext.
!

socketType
	^self class socketType.
!

socketTypeName
	self subclassResponsibility
!

waitForUnpark
	[ parked ] whileTrue: [ monitor wait ].
!

withResultDo: anOneArgumentBlock
        resultHandler := anOneArgumentBlock.
        resultHandler 
            ifNil: [ self context removeFromPoller: self ] 
            ifNotNil: [ self context addToPoller: self ].
!

zmqApi
	^ self context zmqApi.
! !

!ZmqSocket methodsFor:'finalization'!

finalize 
	ZmqLog logDebug: 'Closing socket'.
	self close.
	ZmqLog logDebug: 'Closed socket'.
	super finalize.
! !

!ZmqSocket methodsFor:'initialization'!

initialize 
	super initialize.
	associations := OrderedCollection new.
	parked := false.
	monitor := Monitor new.
! !

!ZmqSocket methodsFor:'queries'!

dataAvailable
        self logDebug: 'There is data available.'.
        resultHandler 
            ifNil:[self logDebug: 'Data available, but no handler'] 
            ifNotNil:[self receiveIfAvailable:[:data| resultHandler cull: data] ].
!

receiveIfAvailable: anOneArgumentBlock
	| data |
	data := self receiveIfAvailable.
	^ data ifNotNil: anOneArgumentBlock
! !

!ZmqSocket methodsFor:'system startup'!

parkForSnapshot
	monitor
		critical: [ 
			parked := true.
			self privateClose.
			]
!

reinitialize
	monitor
		critical: [ 
			socketPointer := self newSocketPointer.
			parked := false.
			associations do: [ :association | association associateSocket: self ].			
			monitor signalAll ]
! !

!ZmqSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocket.st,v 1.3 2018-05-10 20:43:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocket.st,v 1.3 2018-05-10 20:43:05 cg Exp $'
! !


ZmqSocket initialize!
