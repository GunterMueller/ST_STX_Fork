"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalLibrary subclass:#ZmqApi
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!

!ZmqApi class methodsFor:'documentation'!

documentation
"


    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!ZmqApi class methodsFor:'as yet unclassified'!

forCurrentVersion
        |version|

        version := self zmqVersion.
        (version between: '2.0.0' and: '2.9.0')
                ifTrue: [ ^ Zmq2Api ].
        (version between: '3.0.0' and: '3.3.0')
                ifTrue: [ ^ Zmq3Api ].
        (version between: '4.0.0' and: '4.99.0')
                ifTrue: [ ^ Zmq4Api ].
        self error: 'Does not know what version to use for version ' , version asString
!

lastZmqError
	| errno |
	errno := self apiZmqErrno.
	^ (self zmqErrnoAsString: errno)
!

messageClass
	^ ZmqApiMessage
!

newMessagePointer 
	^ self messageClass externalNew.
!

pollItemClass
    ^ ZmqApiPollItem
!

zmqErrnoAsString: errno
	^ errno asString.
! !

!ZmqApi class methodsFor:'private-api conveniency'!

executeApiCall: aBlock
	| retVal tryAgains |
	retVal := aBlock value.
	tryAgains := {(ZmqApiConstants errnoEAGAIN).
	(ZmqApiConstants errnoEINTR)}.
	retVal < 0
		ifTrue: [ 
			| errno |
			errno := self apiZmqErrno.
			(tryAgains includes: errno)
				ifFalse: [ 
					self signalErrno: errno. ] ].
	^ retVal
!

pollApiCall: aBlock
	"Polls non blocking Api call until it returns a result."

	| retVal |
	[ 
	retVal := self executeApiCall: aBlock.
	retVal < 0 ] whileTrue: [ Processor yield ].
	^ retVal
!

signalErrno: errno
	| msg |
	msg := 'ZMQ Error: ' , (self zmqErrnoAsString: errno).
	ZmqLog logError: msg.
	Error signal: msg
! !

!ZmqApi class methodsFor:'private-library api'!

apiZmqBind: socket to: endpoint
	<cdecl: long 'zmq_bind' (ZmqApiSocket* char*) module:'zmq'>
	^self externalCallFailed
!

apiZmqClose: socket
	<cdecl: long 'zmq_close' (ZmqApiSocket*) module:'zmq'>
	^self externalCallFailed
!

apiZmqConnect: socket to: endpoint
	<cdecl: long 'zmq_connect' (ZmqApiSocket* char*) module:'zmq'>
	^self externalCallFailed
!

apiZmqErrno
	<cdecl:long 'zmq_errno' (void)  module:'zmq'>
	^self externalCallFailed
!

apiZmqPollSockets: aZmqPollItemArray ofLenght: length withTimeout: timeout
	<cdecl:  long 'zmq_poll' (ExternalStructure* long longlong) module:'zmq'>
	^self externalCallFailed
!

apiZmqSetsockoptSocket: socket option: option value: value size:  size
	<cdecl: long 'zmq_setsockopt' (ZmqApiSocket* long void* long) module:'zmq'>
	^self externalCallFailed
!

apiZmqSocketInContext: context socketType: type
        <cdecl: ZmqApiSocket* 'zmq_socket' (ZmqApiContext* int) module:'zmq'>
        ^self externalCallFailed
!

apiZmqVersion: major minor: minor patch: patch
	<cdecl:  void 'zmq_version' (ZmqApiStructForInt* ZmqApiStructForInt* ZmqApiStructForInt*) module:'zmq'>
	^self externalCallFailed
! !

!ZmqApi class methodsFor:'private-message handling'!

closeMessage: aZmqApiMessage
	self executeApiCall: [self apiZmqMsgClose: aZmqApiMessage].
!

initializeMessage: aZmqApiMessage
	self executeApiCall: [self apiZmqMsgInit: aZmqApiMessage].
!

messageContent: aZmqApiMessage
	| externalData size array|
	externalData := self apiZmqMsgData: aZmqApiMessage.
	size := self apiZmqMsgSize: aZmqApiMessage.
	array := ByteArray new: size.
	1 to: size do: [:i|
		array at: i put: (externalData getHandle unsignedByteAt: i).
	].
	^array.
!

messageFromByteArray: aByteArray
          | messagePointer dataPointer size null|
        size := aByteArray size.
    Smalltalk isSmalltalkX ifTrue:[
        dataPointer := ExternalBytes new: size.
    ] ifFalse:[
        null := (ExternalStructure fromHandle: ExternalAddress new beNull).
        dataPointer := ExternalAddress allocate: size.
    ].
        messagePointer := self newMessagePointer.
        aByteArray withIndexDo: [:b :i| dataPointer byteAt: i put: b].  
    Smalltalk isSmalltalkX ifTrue:[
        self apiZmqMsg: messagePointer 
             forData: dataPointer 
             ofSize: size andWhenFreeCall: null withArgument: null .
    ] ifFalse:[
        self apiZmqMsg: messagePointer 
             forData: (ExternalStructure fromHandle: dataPointer) 
             ofSize: size andWhenFreeCall: null withArgument: null .
    ].
        ^messagePointer.
! !

!ZmqApi class methodsFor:'private-socket handling'!

bindSocket: aZmqApiSocket to: aByteString
	self executeApiCall: [self apiZmqBind: aZmqApiSocket to:  aByteString ].
!

closeSocket: aZmqApiSocket
	^self executeApiCall: [self apiZmqClose: aZmqApiSocket ].
!

connectSocket: aZmqApiSocket to: aByteString
	Zmq3Api executeApiCall: [Zmq3Api apiZmqConnect: aZmqApiSocket to: aByteString].
!

receiveFromSocket: socketPointer message: messagePointer
	self pollApiCall: [self apiZmqReceiveFromSocket: socketPointer message: messagePointer withFlags: ZmqApiConstants zmqNoBlock] 
!

receiveFromSocket: socketPointer message: messagePointer withFlags: flags
	^ self executeApiCall: [self apiZmqReceiveFromSocket: socketPointer  message: messagePointer withFlags: flags] 
!

setSocketOption: option forSocket: socketPointer to: value
	| data size |
	data := 	value asByteArray.
	size := data size.
	self executeApiCall: [self apiZmqSetsockoptSocket: socketPointer option: option value: data size: size].  
! !

!ZmqApi class methodsFor:'public api'!

context
	^ZmqContext new
!

zmqVersion
        | major minor patch version |
        Smalltalk isSmalltalkX ifTrue:[
            major := ExternalLong new.
            minor := ExternalLong new.
            patch := ExternalLong new.
        ] ifFalse:[    
            major := ZmqApiStructForInt externalNew.
            minor := ZmqApiStructForInt externalNew.
            patch := ZmqApiStructForInt externalNew.
        ].
        self apiZmqVersion:  major minor:  minor patch:  patch.
        version := ZmqVersion major: major value minor: minor value patch: patch value.
        ^version.
! !

!ZmqApi class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApi.st,v 1.4 2018-05-11 01:36:25 cg Exp $'
! !

