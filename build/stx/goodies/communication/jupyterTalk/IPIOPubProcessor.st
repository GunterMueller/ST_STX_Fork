"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMessageProcessor subclass:#IPIOPubProcessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPIOPubProcessor comment:''
!


!IPIOPubProcessor methodsFor:'accessing'!

threadName
	^ 'ipharo-IOPub' 
! !

!IPIOPubProcessor methodsFor:'as yet unclassified'!

publish: anIPMessage
	| aMessage |
	aMessage := IPWireMessage newFromMessage: anIPMessage.
	self zmqSocket  
				send: ('kernel.',anIPMessage uuid asString ,'.',anIPMessage msgType) asByteArray  flags:ZmqApiConstants  zmqSendMore;
	 			send: self messageDelimiter asByteArray flags:ZmqApiConstants  zmqSendMore;
 				send: aMessage calculateHMAC hex asByteArray flags:ZmqApiConstants  zmqSendMore;
 				send: aMessage header flags:ZmqApiConstants  zmqSendMore;
				send: aMessage parentHeader flags:ZmqApiConstants  zmqSendMore;
 				send: aMessage metadata flags:ZmqApiConstants  zmqSendMore;
				send: aMessage content  
!

startingMessage
	^  IPKernelStatusStartingMsg new
!

threadStarted
	self publish: self startingMessage
! !

!IPIOPubProcessor methodsFor:'running'!

execute: aWireMessage
	| message |

	message := IPMsg newFromWireMessage: aWireMessage.
	self publish: (IPKernelStatusBusyMsg new respondsToWireMessage: wireMessage).
	message msgType = #comm_open ifTrue:[ self executeCommOpenRequest: message].	
	message msgType = #comm_close ifTrue:[ self executeCommCloseRequest: message].	
	message msgType = #comm_msg ifTrue:[ self executeCommMsgRequest: message].	

	self publish:  (IPKernelStatusIdleMsg new respondsToWireMessage: wireMessage).
!

executeCommCloseRequest: aMessage
	IPharoKernel instance removeCommMsgHandlersForChanel: aMessage content commID.
	IPharoKernel instance commChanels removeKey: aMessage content commID ifAbsent:[].
	
	"NO-RESPONSE"
!

executeCommMsgRequest: aMessage 
	| response |
	                       
	(IPharoKernel instance commMsgHandlerFor:aMessage commID) do:[:aMsgHandler|
		response := aMsgHandler value:self value:aMessage.
		response ifNotNil:[self publish: response]].
!

executeCommOpenRequest: aMessage
	
	IPharoKernel instance commChanels at: aMessage content commID put:aMessage content.
	
	"NO-RESPONSE"
! !

!IPIOPubProcessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPIOPubProcessor.st,v 1.2 2018-05-14 00:44:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPIOPubProcessor.st,v 1.2 2018-05-14 00:44:33 cg Exp $'
! !

