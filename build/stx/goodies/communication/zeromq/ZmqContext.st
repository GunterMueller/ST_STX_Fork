"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqContext
	instanceVariableNames:'api parked contextPointer resources monitor globalPoller'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqContext class instanceVariableNames:'instance'

"
 No other class instance variables are inherited by this class.
"
!

ZmqContext comment:''
!


!ZmqContext class methodsFor:'instance creation'!

current
	^ self new.
!

new
	"There is only on thread in Squeak VM so there can only be one context."

	instance
		ifNil: [ ^ instance := super new initialize]
		ifNotNil: [
			instance isTerminated
				ifTrue: [
					instance := nil.
					^  self new initialize ]
				ifFalse: [ ^ instance ] ]
!

terminate
	instance ifNotNil: [ instance terminate ]
! !

!ZmqContext class methodsFor:'class initialization'!

initialize
    Smalltalk isSmalltalkX ifFalse:[
	Smalltalk addToShutDownList:  self.
	Smalltalk addToStartUpList:  self.
    ].
! !

!ZmqContext class methodsFor:'system startup'!

shutDown
	instance ifNotNil: [instance parkForSnapshot].
!

startUp
	instance
		ifNotNil: [instance reinitialize]
! !

!ZmqContext methodsFor:'accessing'!

contextPointer
	^contextPointer ifNil: [ contextPointer := self zmqApi newContextPointer ]
! !

!ZmqContext methodsFor:'as yet unclassified'!

addToPoller:aSocket
	self globalPoller pollInSocket: aSocket.
!

globalPoller
	^ globalPoller ifNil:[  globalPoller := ZmqGlobalPoller new ]
!

removeFromPoller: aSocket
	globalPoller ifNotNil: [ globalPoller removeSocket: aSocket ]
! !

!ZmqContext methodsFor:'controlling'!

terminate
	globalPoller ifNotNil:[ globalPoller stopPolling ].
	resources do: [ :zmqSocket | zmqSocket privateClose ].
	resources removeAll.
	self privateTerminate.
	self become: ZmqTerminatedContext new.
! !

!ZmqContext methodsFor:'finalization'!

finalize
	self terminate.
	super finalize.
! !

!ZmqContext methodsFor:'initialization'!

initialize
	super initialize.
	Smalltalk isSmalltalkX ifTrue:[
	    ExternalLibraryFunction dllMappingAt:'zmq' put:'libzmq'.
	    resources := WeakIdentitySet new.
	] ifFalse:[
	    resources := WeakSet new.
	].
	api := ZmqApi forCurrentVersion.
	parked := false.
	monitor := Monitor new.
! !

!ZmqContext methodsFor:'private'!

newSocket: aSocketClass
	| socket |
	socket := aSocketClass context: self.
	self register: socket.
	^ socket
!

privateTerminate
	contextPointer
		ifNotNil: [
			self zmqApi terminateContextPointer: contextPointer.
			contextPointer := nil ]
!

register: anObject
	resources add: anObject
!

removeSocket: aZmqSocket
	resources remove: aZmqSocket.
	self removeFromPoller: aZmqSocket.
	aZmqSocket privateClose
! !

!ZmqContext methodsFor:'system startup'!

parkForSnapshot
	monitor
		critical: [
			globalPoller ifNotNil: [ globalPoller parkForSnapshot ].
			resources do: [ :resource | resource parkForSnapshot ].
			self privateTerminate.
			parked := true ]
!

reinitialize
	monitor
		critical: [
			parked := false.
			resources do: [ :resource | resource reinitialize ].
			globalPoller ifNotNil: [globalPoller reinitialize].
			monitor signalAll.

			]
!

zmqApi
	^ api
! !

!ZmqContext methodsFor:'testing'!

isTerminated
	^false.
! !

!ZmqContext class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqContext.st,v 1.3 2018-05-11 07:04:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqContext.st,v 1.3 2018-05-11 07:04:25 cg Exp $'
! !


ZmqContext initialize!
