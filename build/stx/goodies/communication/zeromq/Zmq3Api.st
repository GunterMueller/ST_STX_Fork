"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqApi subclass:#Zmq3Api
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!

Zmq3Api comment:''
!


!Zmq3Api class methodsFor:'as yet unclassified'!

newContextPointer 
	^self apiZmqContextNew.
!

terminateContextPointer: aZmqApiContextPointer
	self apiZmqContextDestroy: aZmqApiContextPointer
!

zmqErrnoAsString: errno
	^ errno asString , ': ' , (self apiZmqStrError: errno)
! !

!Zmq3Api class methodsFor:'private-library api'!

apiZmqContextDestroy: aZmqApiContext
	<cdecl: long 'zmq_ctx_destroy' (ZmqApiContext*) module:'zmq'>
	^self externalCallFailed
!

apiZmqContextNew
	<cdecl: ZmqApiContext* 'zmq_ctx_new' (void) module:'zmq'>
	^self externalCallFailed
!

apiZmqMsg: message forData: data ofSize: size andWhenFreeCall: functionPtr withArgument: argument
	<cdecl:  long 'zmq_msg_init_data' (ZmqApiMessage* ExternalStructure* long ExternalStructure* ExternalStructure*) module:'zmq'>
	^self externalCallFailed
!

apiZmqMsg: message ofSize: size
	<cdecl:  long 'zmq_msg_init_size' (ZmqApiMessage* long) module:'zmq'>
	^self externalCallFailed
!

apiZmqMsgClose: threads
	<cdecl: long 'zmq_msg_close' (ZmqApiMessage*) module:'zmq'>
	^self externalCallFailed
!

apiZmqMsgData: aZmqApiMessage
	<cdecl: void* 'zmq_msg_data' (ZmqApiMessage*) module:'zmq'>
	^self externalCallFailed
!

apiZmqMsgInit: messagePointer
  <cdecl: long 'zmq_msg_init' (ZmqApiMessage*) module:'zmq'>
	^self externalCallFailed
!

apiZmqMsgSize: messagePointer
  <cdecl: long 'zmq_msg_size' (ZmqApiMessage*) module:'zmq'>
	^self externalCallFailed
!

apiZmqReceiveFromSocket: socket message:  message withFlags:   flags
  <cdecl: long 'zmq_recvmsg' (ZmqApiSocket* ZmqApiMessage* long) module:'zmq'>
  ^self externalCallFailed
!

apiZmqSendToSocket: socketPointer message: messagePointer withFlags: flags
	<cdecl: long 'zmq_sendmsg' (ZmqApiSocket* ZmqApiMessage* long) module:'zmq'>
!

apiZmqStrErrno:errno
	<cdecl:char* 'zmq_strerrno' (long)  module:'zmq'>
	^self externalCallFailed
!

apiZmqStrError:errno
	<cdecl:char* 'zmq_strerror' (long)  module:'zmq'>
	^self externalCallFailed
! !

!Zmq3Api class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/Zmq3Api.st,v 1.1 2018-05-08 19:49:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/Zmq3Api.st,v 1.1 2018-05-08 19:49:52 cg Exp $'
! !

