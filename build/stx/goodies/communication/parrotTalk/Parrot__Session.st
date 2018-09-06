"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

ThunkLayer subclass:#Session
	instanceVariableNames:'stack farKey map portal'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk'
!

Session comment:''
!


!Session class methodsFor:'instance creation'!

connectToFarKey: farKey portal: portal

	| ep |
	[ep := SocketThunk newConnection: farKey host port: farKey port]
		on: ConnectionTimedOut
		do: [:ex |
			ex pass].
	^ self onSource: ep farKey: farKey portal: portal.
!

new

	self shouldNotImplement 
!

onSource: source farKey: farKey portal: portal

	^ super new
		initializeOnSource: source farKey: farKey portal: portal;
		yourself.
! !

!Session methodsFor:'accessing'!

farKey

	^ farKey
!

nearKey

	^ portal portalKey
! !

!Session methodsFor:'control'!

answer

	self ops answer.
	stack run.
!

call

	stack run.
	self ops call.
!

close

	self triggerEvent: #connectionClosed with: self.
	map ifNotNil: [map release. map := nil].
	self releaseActionMap.
!

flush
!

isConnected

	^stack notNil
!

shutdown

        stack ifNotNil: [stack shutdown].
        self releaseActionMap.
! !

!Session methodsFor:'derived'!

isExpectingGoTooOrConnected

	^ self ops isExpectingGoToo or: [self ops isConnected]
!

localVatId

	^ self nearKey vatId
!

ops

	^ stack propertyAt: #Ops.
!

portal

	^ portal
!

remotePublicKey

	^ farKey publicKey
!

remotePublicKey: aKey

	^ farKey receivePublicKey: aKey
!

remoteVatId

	^ farKey vatId
!

remoteVatId: aVatId

	^ farKey vatId: aVatId.
!

stack

	^ stack
! !

!Session methodsFor:'initialize-release'!

initializeOnSource: source farKey: aFarKey portal: aPortal

	| ops |
	farKey := aFarKey.
	portal := aPortal.
	stack := source stack.
	map := portal portalMap copy.

	ops := SessionOperations newOnStack: stack session: self map: map.
	stack
		push:	(FrameBuffer newOnStack: stack);
		push:	ops;
		propertyAt: #Ops put: ops;
		push:	self;
		install.

	ops when: #connectionSuccessful send: #connectionRunning: to: portal with: self.
! !

!Session methodsFor:'protocol'!

send: chunk

	| frame |
	chunk ifNil: [^ nil].
	(chunk isKindOf: Frame)
		ifTrue: [frame := chunk]
		ifFalse: [
			(chunk isEmpty) ifTrue: [^ chunk].
			frame := Frame onHeader: RawData new payload: chunk].
	stack downcall: frame from: self.
! !

!Session methodsFor:'thunk - accessing'!

doesPop

	^ false
!

doesPush

	^ false
!

downThunk

	^ [:frame | frame ].
!

upThunk

	^ [:frame | [self triggerEvent: #dataReceived with: frame payload] forkAt: (frame priority * 10 + 30)].
! !

!Session class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Session.st,v 1.2 2018-05-14 00:22:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Session.st,v 1.2 2018-05-14 00:22:20 cg Exp $'
! !

