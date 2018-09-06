"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMessageProcessor subclass:#IPShellProcessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPShellProcessor comment:''
!


!IPShellProcessor methodsFor:'accessing'!

threadName
	^ 'ipharo-shell' 
! !

!IPShellProcessor methodsFor:'running'!

execute: aWireMessage
	| message response|

	message := IPMsg newFromWireMessage: aWireMessage.
	self publish: (IPKernelStatusBusyMsg new respondsToWireMessage: wireMessage).
	message msgType = #kernel_info_request ifTrue:[ response:=self executeKernelInfoRequest: message].	
	message msgType = #comm_info_request ifTrue:[ response:=self executeCommInfoRequest: message].			
	message msgType = #execute_request ifTrue:[ response:=self executeExecuteRequest: message].
	message msgType = #is_complete_request ifTrue:[ response:=self executeIsCompleteRequest: message].
	message msgType = #shutdown_request ifTrue:[ self executeShutdown: message].
	response ifNotNil:[self respond: response].
	self publish:  (IPKernelStatusIdleMsg new respondsToWireMessage: wireMessage).

	
!

executeCommInfoRequest: aMessage
	| response |
	response := IPCommInfoReplyMsg new.
	"parent_header must be exactly the same header"
	response respondsToWireMessage: wireMessage.
	^  response
	
!

executeExecuteRequest: aMessage
	| response session result executionResult |
	"parent_header must be exactly the same header"
	
	session := IPSession session: aMessage header session.
	self publish: (session executeInputMessage
										respondsToWireMessage: wireMessage;
										code:aMessage content code;
										yourself ).	
	[result :=session compileAndEvaluate: aMessage] 
		on:Exception do:[:e| 
			response := (session executionErrorMessage 
									respondsToWireMessage: wireMessage;
									exceptionObject: e;
									yourself).
			self publish: (session executeErrorMessage    
									content: response content;
									respondsToWireMessage: wireMessage;
									yourself)].
					
	aMessage content silent = false
	ifTrue:[
		response ifNil:[
			result ifNotNil:[		
				executionResult := session executeResultMessage 
													respondsToWireMessage: wireMessage;
													yourself.	
				executionResult content addAll:result.				
				self publish:  executionResult].
			response:= session executionOkMessage.
			response respondsToWireMessage: wireMessage ]].

	session increaseExecutionCounter.	
	^ response
	
!

executeIsCompleteRequest: aMessage
	| response |
	response := IPIsCompleteReplyMsg new.
	"parent_header must be exactly the same header"
	response respondsToWireMessage: wireMessage.
	^ response
	
!

executeKernelInfoRequest: aMessage
	| response session|
	
	session := IPSession newSessionFor: aMessage header.
	response := session kernelInfoReplayMessage.
	"must be exactly the same header"
	response respondsToWireMessage: wireMessage.

	^  response
	
!

executeShutdown: aMessage
	Smalltalk snapshot: false andQuit: true 
! !

!IPShellProcessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPShellProcessor.st,v 1.2 2018-05-14 00:44:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPShellProcessor.st,v 1.2 2018-05-14 00:44:59 cg Exp $'
! !

