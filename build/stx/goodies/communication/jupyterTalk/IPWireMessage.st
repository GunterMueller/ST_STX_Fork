"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

Object subclass:#IPWireMessage
	instanceVariableNames:'wireMessage currentProperty'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPWireMessage comment:''
!


!IPWireMessage class methodsFor:'instance creation'!

newFromMessage: anIPMessage
	|instance serializer|
	serializer := SCSerializer new.
	instance := self new.
	"be sure message type is the correct msgType
	uuid is set in the IPMessageProcessor #execute: method"
	instance push: anIPMessage uuid asByteArray.
	instance push: 0.
	instance push: (serializer serialize: anIPMessage header) asByteArray.
	"parent_header must be exactly the same header, this won't be serialized/paterialized"
	instance push: anIPMessage parentHeader.
	instance push: (serializer serialize: anIPMessage metadata) asByteArray.
	instance push: (serializer serialize: anIPMessage content) utf8Encoded.
	instance hmac: instance calculateHMAC hex asByteArray.
	^instance
! !

!IPWireMessage methodsFor:'accessing'!

content
	^ wireMessage at:6 
		
!

extra
	^ wireMessage at:7 
		
!

header
	^ wireMessage at:3 
		
!

hmac
	^ wireMessage at:2
!

hmac: hmac
	wireMessage at:2 put:hmac
!

metadata
	^ wireMessage at:5 
		
!

uuid
	^ wireMessage at:1 ifAbsent:[ByteArray new]
!

uuid: aZmqUUID
	wireMessage at:1 put: aZmqUUID
! !

!IPWireMessage methodsFor:'as yet unclassified'!

calculateHMAC
	^ (HMAC on: SHA256)
			key: IPharoKernel instance sharedKey asByteArray ;
			digestMessage:
						self header,
						self parentHeader,
						self metadata,
						self content  
! !

!IPWireMessage methodsFor:'converting'!

hmacIsValid
^	self hmac asString = self calculateHMAC hex 
	
!

parentHeader
	^ wireMessage at:4 
		
! !

!IPWireMessage methodsFor:'initialization'!

initialize
	super initialize.
	wireMessage := Array new:7.
	wireMessage from: 1 to: 7 put: ByteArray new.
	currentProperty := 1
!

push: aProperty
	currentProperty <= wireMessage size ifTrue:[wireMessage at:currentProperty put:aProperty].
	currentProperty := currentProperty + 1
	
! !

!IPWireMessage methodsFor:'testing'!

isEmpty
	^ currentProperty= 1
!

isFull
	^ currentProperty >= wireMessage size
! !

!IPWireMessage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPWireMessage.st,v 1.2 2018-05-14 00:44:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPWireMessage.st,v 1.2 2018-05-14 00:44:07 cg Exp $'
! !

