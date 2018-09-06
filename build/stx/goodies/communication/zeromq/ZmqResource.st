"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqResource
	instanceVariableNames:'monitor parked'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqResource comment:''
!


!ZmqResource class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ZmqResource methodsFor:'as yet unclassified'!

initialize
	super initialize.
	monitor := Monitor new.
	parked := false.
!

logDebug: aString
	ZmqLog logDebug: self asString,': ', aString.
!

logError: aString 
	ZmqLog logError: aString.
!

parkForSnapshot
	self parkResource.
!

privateClose
	
!

reinitialize
	self unparkResource.
! !

!ZmqResource methodsFor:'synchronization'!

critical: aBlock
	^ monitor
		critical: [ 
			parked
				ifTrue: [ monitor wait ].
			aBlock value ]
!

parkResource
	monitor critical: [ parked := true ]
!

unparkResource
	monitor
		critical: [ 
			parked := false.
			monitor signalAll ]
! !

!ZmqResource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqResource.st,v 1.1 2018-05-08 19:44:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqResource.st,v 1.1 2018-05-08 19:44:46 cg Exp $'
! !

