"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqApi subclass:#Zmq2Api
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!

Zmq2Api comment:''
!


!Zmq2Api class methodsFor:'as yet unclassified'!

newContextPointer 
	^self apiZmqInit: 1
!

terminateContextPointer: aZmqApiContextPointer
	self apiZmqTerm: aZmqApiContextPointer
! !

!Zmq2Api class methodsFor:'private-library api'!

apiZmqInit: threads
	<cdecl: ZmqApiContext* 'zmq_init' (long) module:'zmq'>
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
  <cdecl: long 'zmq_recv' (ZmqApiSocket* ZmqApiMessage* long) module:'zmq'>
  ^self externalCallFailed
!

apiZmqSendToSocket: socketPointer message: messagePointer withFlags: flags
	<cdecl: long 'zmq_send' (ZmqApiSocket* ZmqApiMessage* long) module:'zmq'>
!

apiZmqTerm: threads
	<cdecl: long 'zmq_term' (ZmqApiContext*) module:'zmq'>
	^self externalCallFailed
! !

!Zmq2Api class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/Zmq2Api.st,v 1.1 2018-05-08 19:49:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/Zmq2Api.st,v 1.1 2018-05-08 19:49:43 cg Exp $'
! !

