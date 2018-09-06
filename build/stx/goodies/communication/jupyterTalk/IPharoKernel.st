"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

Object subclass:#IPharoKernel
	instanceVariableNames:'heartbeat shell control stdin ioPub port stop processors
		sharedKey config commChanels commMsgHandlers'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPharoKernel class instanceVariableNames:'instance'

"
 No other class instance variables are inherited by this class.
"
!

IPharoKernel comment:''
!

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
	
!

new
	instance ifNotNil:[instance stop].
	instance := self basicNew.
	instance initialize.
	^ instance
	
! !

!IPharoKernel class methodsFor:'as yet unclassified'!

implementation
	^ 'IPharo Smalltalk'
!

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
!

version
	^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPharoKernel.st,v 1.2 2018-05-14 00:53:37 cg Exp $'
! !

!IPharoKernel methodsFor:'accessing'!

debug: anError

	Transcript show: anError asString;cr
!

isStopping
	^ stop 
!

port
	^ port ifNil:[port := 171172]
!

port: anInteger
	port := anInteger
!

processors
	^ processors ifNil:[processors := Dictionary new]
!

sharedKey
	^ sharedKey ifNil:[0]
!

start
	ZmqContext new.
 	self processors at:#shell put: (IPShellProcessor new: shell).
	self processors at:#ctrl put: (IPControlProcessor new:control).
	self processors at:#stdin put: (IPStdInProcessor new:stdin).
	self processors at:#iopub put: (IPIOPubProcessor new:ioPub).
	self heartbeatThread.
	IPSession finalizeSession
!

stop
	stop := true.
	self processors values do:[:each| each stop].
	self processors removeAll.
	IPDisplay resetCache.
	[ZmqContext terminate] on:Error do:[:e| Transcript show:e asString;cr].
	stop :=false
	 
! !

!IPharoKernel methodsFor:'comm handlers'!

addCommMsgHandler: aTwoParamBlock toChanel:aChanelId
	self commMsgHandlers at:aChanelId put:aTwoParamBlock
!

commChanels
	^ commChanels ifNil:[commChanels := Dictionary new]
	
!

commMsgHandlerFor: commID
	^ self commMsgHandlers at:commID ifAbsent:[Array new]
!

commMsgHandlers

	^ commMsgHandlers ifNil:[ commMsgHandlers := Dictionary new]
!

newCommChannelFor: anUUID
	^ self commChanels at:anUUID
	
!

removeCommMsgHandlersForChanel:aChanelId
	self commMsgHandlers removeKey: aChanelId ifAbsent:[]
! !

!IPharoKernel methodsFor:'initialization'!

config
	^ config 
!

config: kernelConfig 
	config := kernelConfig 
!

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
!

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

!IPharoKernel methodsFor:'utility'!

connectionStringFor:transport ip:anIp port:aPort
	^ transport asString , '://' , anIp asString, ':' ,aPort asString
! !



IPharoKernel initialize!
