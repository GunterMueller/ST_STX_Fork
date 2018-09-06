"{ Package: 'stx:goodies/communication/jupyterTalk' }"!

!Dictionary methodsFor:'*JupyterTalk-Core'!

asJupyterDataWithExtent:aPoint
	|c|
	c := Array 
				with: self keys
				with: self values.

	^ c asJupyterDataWithExtent:aPoint
! !

!IPDisplay methodsFor:'public-api'!

extent
	"default extent"
	^  extent ifNil:[ extent :=  640@256 ].
	
	
! !

!IPDisplay methodsFor:'public-api'!

extent: aPoint
	extent:= aPoint 
	
	
! !

!IPDisplay methodsFor:'initialization'!

initialize
	super initialize.
	interaction := false
! !

!IPDisplay methodsFor:'accessing'!

jupyterData
	"Uses Session jupyterData to write the anwer"
	^ IPSession currentSession jupyterData 
! !

!IPDisplay methodsFor:'public-api'!

maxNumberOfRows
	^ 500

	 
	
														
														
! !

!IPDisplay methodsFor:'public-api'!

openInJupyter: data 
	|aJupyterData  uuid  |
	
	
	aJupyterData := (interaction and:[data respondsTo:#asJupyterInteractiveDataWithExtent:]) 
							ifTrue:[data asJupyterInteractiveDataWithExtent: self extent]
							ifFalse:[data asJupyterDataWithExtent: self extent].	
	self jupyterData data at:aJupyterData key put:aJupyterData value.
	self jupyterData metadata:{
 									aJupyterData key -> {
    															'width' -> self extent x.
    															'height' -> self extent y
 														 	} asSCJsonObject.
														} asSCJsonObject.
	uuid:= UUID new hex asString asUppercase.
	self jupyterData transient: {#display_id -> uuid} asSCJsonObject.
	self class cachedObjects 
						at:uuid put: {    #data-> data.
												#interactive-> interaction.
												#extent->self extent.
												#metadata ->self jupyterData metadata} asDictionary. 
	^ uuid
! !

!IPDisplay methodsFor:'public-api'!

openInJupyter: data extent: aPoint
	
	self extent: aPoint.
	^ self openInJupyter: data
! !

!IPDisplay methodsFor:'as yet unclassified'!

publish: aResultMessage

	(IPharoKernel instance processors at:#iopub) publish:  aResultMessage
! !

!IPDisplay methodsFor:'public-api'!

refresh: anUUID 
	| cdata udm|

	cdata:= self class cachedObjects at:anUUID ifAbsent:[self error:'Object ', anUUID asString,' not found in jupyter kernel cache'].
	"get the old object and execute display again"
	(cdata at:#interactive) ifTrue:[self interactionOn].
	self openInJupyter: (cdata at:#data) extent: (cdata at:#extent). 
	udm := IPSession currentSession  updateDisplayMessage.
	udm content addAll: self jupyterData .	
	udm transient: {#display_id -> anUUID} asSCJsonObject.
	udm metadata: (cdata at:#metadata).
	udm respondsToWireMessage:(IPharoKernel instance processors at:#shell) wireMessage.
	self publish:udm.
	"we need to reset current output to avoid double response..."
	IPSession currentSession resetJupyterData.
	
! !

!IPDisplay class methodsFor:'accessing'!

cachedObjects
	^ cachedObjects ifNil:[cachedObjects := Dictionary new]
! !

!IPDisplay class methodsFor:'removing'!

resetCache
	cachedObjects :=nil
! !

!IPSession methodsFor:'compilation'!

bindingOf: aString 
	(bindings includesKey: aString)
		ifFalse: [ bindings add: (WorkspaceVariable key: aString asSymbol) ].
	^ bindings associationAt: aString
! !

!IPSession methodsFor:'comm messages'!

commCloseMessage
	 | msg |
	msg := IPCommCloseMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
! !

!IPSession methodsFor:'comm messages'!

commMsgMessage
	 | msg |
	msg := IPCommMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
! !

!IPSession methodsFor:'comm messages'!

commOpenMessage
	 | msg |
	msg := IPCommOpenMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
! !

!IPSession methodsFor:'compilation'!

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
			
	
! !

!IPSession methodsFor:'public-api'!

defaultNumberOfRows
	^ 100

	 
	
														
														
! !

!IPSession methodsFor:'accessing'!

display
	^ display := IPDisplay new
! !

!IPSession methodsFor:'iopub messages'!

displayDataMessage
	 | msg |
	msg := IPDisplayDataMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.

	^ msg 
! !

!IPSession methodsFor:'compilation'!

doItContext

	^  nil
	
! !

!IPSession methodsFor:'compilation'!

doItReceiver

	^  self
	
! !

!IPSession methodsFor:'iopub messages'!

executeErrorMessage
	 | msg |
	msg := IPExecuteErrorMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg 
! !

!IPSession methodsFor:'iopub messages'!

executeInputMessage
	 | msg |
	msg := IPExecuteInputMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  executionCounter
	
																						
! !

!IPSession methodsFor:'iopub messages'!

executeResultMessage
	 | msg |
	msg := IPExecuteResultMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  executionCounter
! !

!IPSession methodsFor:'shell messages'!

executionAbortedMessage
	 | msg |
	msg := IPExecutionAbortedMsg new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  self executionCounter
! !

!IPSession methodsFor:'accessing'!

executionCounter
	^ executionCounter 
! !

!IPSession methodsFor:'shell messages'!

executionErrorMessage
	 | msg |
	msg := IPExecutionErrorMsg new. 
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  self executionCounter
! !

!IPSession methodsFor:'shell messages'!

executionOkMessage
	 | msg |
	msg := IPExecutionOkMsg new.
	msg metadata engine: self id.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg executionCount:  self executionCounter
! !

!IPSession methodsFor:'accessing'!

guessTypeForName: aString
	| binding |
	bindings
		ifNotNil: [ 
			binding := bindings at: aString ifAbsent: [ nil ].
			binding isNil
				ifFalse: [ ^ binding class ] ].
	^ nil
! !

!IPSession methodsFor:'compilation'!

hasBindingOf: aString 
	^(self guessTypeForName: aString) notNil
! !

!IPSession methodsFor:'compilation'!

hasBindingThatBeginsWith: aString
	^ bindings keys anySatisfy: [:each | each beginsWith: aString]
! !

!IPSession methodsFor:'accessing'!

id
	^ id
! !

!IPSession methodsFor:'accessing'!

id: anObject
	id := anObject
! !

!IPSession methodsFor:'accessing'!

increaseExecutionCounter
	executionCounter := executionCounter + 1
! !

!IPSession methodsFor:'initialization'!

initialize

	super initialize.
	executionCounter := 1.
	self initializeBindings
! !

!IPSession methodsFor:'initialization'!

initializeBindings
	
	bindings := Dictionary new
! !

!IPSession methodsFor:'accessing'!

jupyterData
	^ jupyterData ifNil:[
		jupyterData := SCJsonObject new.
		jupyterData at:#data put:SCJsonObject new.
		jupyterData].
! !

!IPSession methodsFor:'shell messages'!

kernelInfoReplayMessage
	 | msg |
	msg := IPKernelInfoReplyMsg new. 
	msg uuid:'ŽØ'.
	msg header
				session: self id;
				username: self kernelUsername.
	^ msg 
! !

!IPSession methodsFor:'accessing'!

kernelUsername
	^#kernel
! !

!IPSession methodsFor:'public-api'!

loadScript: aStringScript

	self jupyterData data at:'text/html' put:aStringScript.
	self jupyterData metadata: SCJsonObject new.

	
	 
	
														
														
! !

!IPSession methodsFor:'initialization'!

resetJupyterData
	jupyterData :=nil.
! !

!IPSession methodsFor:'accessing'!

selectedClassOrMetaClass
	^ nil
! !

!IPSession methodsFor:'accessing'!

setBindings: aDictionary
	"Sets the Workspace to use the specified dictionary as its namespace"

	bindings := aDictionary.
! !

!IPSession methodsFor:'accessing'!

startTime
	^ startTime
! !

!IPSession methodsFor:'accessing'!

startTime: anObject
	startTime := anObject
! !

!IPSession methodsFor:'accessing'!

timeout
	^ timeout
! !

!IPSession methodsFor:'accessing'!

timeout: anObject
	timeout := anObject
! !

!IPSession methodsFor:'iopub messages'!

updateDisplayMessage
	 | msg |
	msg := IPUpdateDisplayDataMsg  new.
	msg header 
				session: self id;
				username: self kernelUsername.
	^ msg 
! !

!IPSession methodsFor:'accessing'!

username
	^ username
! !

!IPSession methodsFor:'accessing'!

username: anObject
	username := anObject
! !

!IPSession class methodsFor:'accessing'!

currentSession
	^ currentSession value
! !

!IPSession class methodsFor:'accessing'!

finalizeSession
	currentSession := nil
! !

!IPSession class methodsFor:'accessing'!

newSessionFor: aHeader

	currentSession :=
			(aHeader session) -> (self new 
							username: aHeader username;
							id: aHeader session;
							startTime: aHeader timestamp).
	^ currentSession value
		
									
! !

!IPSession class methodsFor:'instance creation'!

session: sessionId

	^ self currentSession id = sessionId
			ifTrue:[self currentSession value]
			ifFalse:[ ZmqLog logDebug: 'Session ', sessionId,' not found'. nil ]

									
! !

!IPharoKernel methodsFor:'comm handlers'!

addCommMsgHandler: aTwoParamBlock toChanel:aChanelId
	self commMsgHandlers at:aChanelId put:aTwoParamBlock
! !

!IPharoKernel methodsFor:'comm handlers'!

commChanels
	^ commChanels ifNil:[commChanels := Dictionary new]
	
! !

!IPharoKernel methodsFor:'comm handlers'!

commMsgHandlerFor: commID
	^ self commMsgHandlers at:commID ifAbsent:[Array new]
! !

!IPharoKernel methodsFor:'comm handlers'!

commMsgHandlers

	^ commMsgHandlers ifNil:[ commMsgHandlers := Dictionary new]
! !

!IPharoKernel methodsFor:'initialization'!

config
	^ config 
! !

!IPharoKernel methodsFor:'initialization'!

config: kernelConfig 
	config := kernelConfig 
! !

!IPharoKernel methodsFor:'initialization'!

configKernel: kernelConfig
	sharedKey := (kernelConfig at:#key).
	heartbeat bind: (self connectionStringFor:(kernelConfig at:#transport)
								ip: (kernelConfig at:#ip)
								port: (kernelConfig at:#hb_port)).
	stdin bind: (self connectionStringFor:(kernelConfig at:#transport)
								ip: (kernelConfig at:#ip)
								port: (kernelConfig at:#stdin_port)).
	control bind:(self connectionStringFor:(kernelConfig at:#transport)
								ip: (kernelConfig at:#ip)
								port: (kernelConfig at:#control_port)).
	shell bind: (self connectionStringFor:(kernelConfig at:#transport)
								ip: (kernelConfig at:#ip)
								port: (kernelConfig at:#shell_port)).
	ioPub bind: (self connectionStringFor:(kernelConfig at:#transport)
								ip: (kernelConfig at:#ip)
								port: (kernelConfig at:#iopub_port)).
	self config: kernelConfig 
! !

!IPharoKernel methodsFor:'utility'!

connectionStringFor:transport ip:anIp port:aPort
	^ transport asString , '://' , anIp asString, ':' ,aPort asString
! !

!IPharoKernel methodsFor:'accessing'!

debug: anError

	Transcript show: anError asString;cr
! !

!IPharoKernel methodsFor:'threads'!

heartbeatThread
	[	|echoData|
	[
		[ self isStopping ] whileFalse:[
			echoData := heartbeat receiveAndWait. 
			heartbeat send: echoData asByteArray]
	]on:Error do:[:e| self debug:e]
	] forkNamed:'ipharo-echo' 
! !

!IPharoKernel methodsFor:'initialization'!

initialize
	super initialize.
	ZmqContext new.
	heartbeat := ZmqRequestSocket new.
	shell := ZmqRouterSocket new. 
	control := ZmqRouterSocket new. 
	stdin := ZmqRouterSocket new. 
	ioPub := ZmqPublisherSocket new.
	stop := false.
! !

!IPharoKernel methodsFor:'accessing'!

isStopping
	^ stop 
! !

!IPharoKernel methodsFor:'comm handlers'!

newCommChannelFor: anUUID
	^ self commChanels at:anUUID
	
! !

!IPharoKernel methodsFor:'accessing'!

port
	^ port ifNil:[port := 171172]
! !

!IPharoKernel methodsFor:'accessing'!

port: anInteger
	port := anInteger
! !

!IPharoKernel methodsFor:'accessing'!

processors
	^ processors ifNil:[processors := Dictionary new]
! !

!IPharoKernel methodsFor:'comm handlers'!

removeCommMsgHandlersForChanel:aChanelId
	self commMsgHandlers removeKey: aChanelId ifAbsent:[]
! !

!IPharoKernel methodsFor:'accessing'!

sharedKey
	^ sharedKey ifNil:[0]
! !

!IPharoKernel methodsFor:'accessing'!

start
	ZmqContext new.
 	self processors at:#shell put: (IPShellProcessor new: shell).
	self processors at:#ctrl put: (IPControlProcessor new:control).
	self processors at:#stdin put: (IPStdInProcessor new:stdin).
	self processors at:#iopub put: (IPIOPubProcessor new:ioPub).
	self heartbeatThread.
	IPSession finalizeSession
! !

!IPharoKernel methodsFor:'accessing'!

stop
	stop := true.
	self processors values do:[:each| each stop].
	self processors removeAll.
	IPDisplay resetCache.
	[ZmqContext terminate] on:Error do:[:e| Transcript show:e asString;cr].
	stop :=false
	 
! !

!IPharoKernel class methodsFor:'as yet unclassified'!

implementation
	^ 'IPharo Smalltalk'
! !

!IPharoKernel class methodsFor:'initialization'!

initialize
"by now we need to stop the kernel each time the image is stopped or saved"
	SessionManager default registerUserClassNamed: self name  atPriority: 100.
"build a link in your image/Pluggings folder to"
	'libzmq.dylib'.
"create folder"
	'/usr/local/share/jupyter/kernels/pharo'.
"create file"
	'kernel.json'.
"with contents"
'{
  "argv": [
    "/Applications/Pharo6.1-64_ZeroMQ.app/Contents/MacOS/Pharo",
    "/Applications/Pharo6.1-64_ZeroMQ.app/Contents/Resources/Pharo6.1-64.image",
    "ipharo",
    "{connection_file}"
  ],
  "display_name": "Pharo Smalltalk",
  "language": "smalltalk"
}'
"copy an icon with file name logo-64x64.png"
! !

!IPharoKernel class methodsFor:'instance creation'!

instance
	^ instance ifNil:[self new]
	
! !

!IPharoKernel class methodsFor:'instance creation'!

new
	instance ifNotNil:[instance stop].
	instance := self basicNew.
	instance initialize.
	^ instance
	
! !

!IPharoKernel class methodsFor:'as yet unclassified'!

protocolVersion
	^ '5.0.0'
! !

!IPharoKernel class methodsFor:'system startup'!

shutDown
	self instance stop.
	(Delay forSeconds:1) wait
! !

!IPharoKernel class methodsFor:'versions'!

startUp
! !

!IPharoKernel class methodsFor:'versions'!

version
	^ '0.1.0'
! !

!Object methodsFor:'*JupyterTalk-Core'!

asJupyterDataWithExtent: size
	^ 'text/plain'-> self asString  
! !

!SequenceableCollection methodsFor:'*JupyterTalk-Core'!

asJupyterDataWithExtent:aPoint
	|htmlStream  |

	htmlStream := ReadWriteStream on:String new.
	htmlStream 
			nextPutAll:'<table>';cr;
			nextPutAll:'<tr>'.
	(self first isKindOf: SequenceableCollection)
		ifTrue:[ self first do:[:each| 
						htmlStream nextPutAll:'<th>';	nextPutAll:each asString;nextPutAll:'</th>']]
		ifFalse:[htmlStream nextPutAll:'<th>';	nextPutAll:self first asString;nextPutAll:'</th>'].	
			
	self allButFirst do:[ :eachRow|
		htmlStream nextPutAll:'<tr>'.
		(eachRow isKindOf: SequenceableCollection) ifTrue:[
			eachRow do:[:eachElement| htmlStream nextPutAll:'<td>';	nextPutAll:eachElement asString;nextPutAll:'</td>']].	
		htmlStream nextPutAll:'</tr>'].
	htmlStream nextPutAll:'</table>'.
	
	^ 'text/html' -> htmlStream contents 
! !

!String methodsFor:'*JupyterTalk-Core'!

asJupyterDataWithExtent: size
	^ 'text/html'-> ('<pre>',(self asString  copyReplaceAll: String cr with: '<br/>'),'</pre>') 
! !

!stx_goodies_communication_jupyterTalk class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/extensions.st,v 1.4 2018-05-14 00:51:27 cg Exp $'
! !
