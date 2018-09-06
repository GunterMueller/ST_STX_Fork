"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

Object subclass:#IPSession
	instanceVariableNames:'id username startTime timeout context executionCounter
		executionProcess bindings jupyterData cachedObjects display'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPSession class instanceVariableNames:'currentSession'

"
 No other class instance variables are inherited by this class.
"
!

IPSession comment:''
!


!IPSession class methodsFor:'instance creation'!

session: sessionId

	^ self currentSession id = sessionId
			ifTrue:[self currentSession value]
			ifFalse:[ ZmqLog logDebug: 'Session ', sessionId,' not found'. nil ]

									
! !

!IPSession class methodsFor:'accessing'!

currentSession
	^ currentSession value
!

finalizeSession
	currentSession := nil
!

newSessionFor: aHeader

	currentSession :=
			(aHeader session) -> (self new 
							username: aHeader username;
							id: aHeader session;
							startTime: aHeader timestamp).
	^ currentSession value
		
									
! !

!IPSession methodsFor:'accessing'!

display
	^ display := IPDisplay new
!

executionCounter
	^ executionCounter 
!

guessTypeForName: aString
	| binding |
	bindings
		ifNotNil: [ 
			binding := bindings at: aString ifAbsent: [ nil ].
			binding isNil
				ifFalse: [ ^ binding class ] ].
	^ nil
!

id
	^ id
!

id: anObject
	id := anObject
!

increaseExecutionCounter
	executionCounter := executionCounter + 1
!

jupyterData
	^ jupyterData ifNil:[
		jupyterData := SCJsonObject new.
		jupyterData at:#data put:SCJsonObject new.
		jupyterData].
!

kernelUsername
	^#kernel
!

selectedClassOrMetaClass
	^ nil
!

setBindings: aDictionary
	"Sets the Workspace to use the specified dictionary as its namespace"

	bindings := aDictionary.
!

startTime
	^ startTime
!

startTime: anObject
	startTime := anObject
!

timeout
	^ timeout
!

timeout: anObject
	timeout := anObject
!

username
	^ username
!

username: anObject
	username := anObject
! !

!IPSession methodsFor:'comm messages'!

commCloseMessage
	 | msg |
	msg := IPCommCloseMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
!

commMsgMessage
	 | msg |
	msg := IPCommMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
!

commOpenMessage
	 | msg |
	msg := IPCommOpenMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
! !

!IPSession methodsFor:'compilation'!

bindingOf: aString 
	(bindings includesKey: aString)
		ifFalse: [ bindings add: (WorkspaceVariable key: aString asSymbol) ].
	^ bindings associationAt: aString
!

compileAndEvaluate: aMessage

	| result rcvr ctxt source|
	
	self resetJupyterData.
	rcvr := self doItReceiver.
	ctxt := self doItContext. 
	source := aMessage content code.

	[
	[result := rcvr class compiler
			source: source;
			context: ctxt;
			receiver: rcvr;
			requestor: self;
			failBlock:  [:err| ZmqLog logError:err msg . ^ nil];
			evaluate] on:Error do:[:e| 
				"We just need to chech for Error not Exception"
				result := e.
			] ] forkAndWait.		
		
	(result isKindOf: Error ) ifTrue:[ result signal].
	^  self jupyterData 
			
	
!

doItContext

	^  nil
	
!

doItReceiver

	^  self
	
!

hasBindingOf: aString 
	^(self guessTypeForName: aString) notNil
!

hasBindingThatBeginsWith: aString
	^ bindings keys anySatisfy: [:each | each beginsWith: aString]
! !

!IPSession methodsFor:'initialization'!

initialize

	super initialize.
	executionCounter := 1.
	self initializeBindings
!

initializeBindings
	
	bindings := Dictionary new
!

resetJupyterData
	jupyterData :=nil.
! !

!IPSession methodsFor:'iopub messages'!

displayDataMessage
	 | msg |
	msg := IPDisplayDataMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
!

executeErrorMessage
	 | msg |
	msg := IPExecuteErrorMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg 
!

executeInputMessage
	 | msg |
	msg := IPExecuteInputMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  executionCounter
	
																						
!

executeResultMessage
	 | msg |
	msg := IPExecuteResultMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  executionCounter
!

updateDisplayMessage
	 | msg |
	msg := IPUpdateDisplayDataMsg  new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg 
! !

!IPSession methodsFor:'public-api'!

defaultNumberOfRows
	^ 100

	 
	
														
														
!

loadScript: aStringScript

	self jupyterData data at:'text/html' put:aStringScript.
	self jupyterData metadata: SCJsonObject new.

	
	 
	
														
														
! !

!IPSession methodsFor:'shell messages'!

executionAbortedMessage
	 | msg |
	msg := IPExecutionAbortedMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  self executionCounter
!

executionErrorMessage
	 | msg |
	msg := IPExecutionErrorMsg new. 
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  self executionCounter
!

executionOkMessage
	 | msg |
	msg := IPExecutionOkMsg new.
	msg metadata engine: self id.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  self executionCounter
!

kernelInfoReplayMessage
	 | msg |
	msg := IPKernelInfoReplyMsg new. 
	msg uuid:'ŽØ'.
	msg header
				session: self id;
				username: self kernelUsername.
	^ msg 
! !

!IPSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPSession.st,v 1.2 2018-05-14 00:53:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPSession.st,v 1.2 2018-05-14 00:53:33 cg Exp $'
! !

