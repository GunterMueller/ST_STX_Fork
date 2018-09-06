"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

Object subclass:#IPMsg
	instanceVariableNames:'header msg_id msg_type parentHeader content metadata uuid msgUUID'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPMsg comment:''
!


!IPMsg class methodsFor:'instance creation'!

newFromWireMessage: aWireMessage
	| instance materializer |
	materializer := SCMaterializer new.
	instance := self new.
	instance header: ( materializer materialize: aWireMessage header asString).	
	instance parentHeader: (materializer materialize: aWireMessage parentHeader asString).
	instance metadata: ( materializer materialize: aWireMessage metadata asString).
	instance content: ( materializer materialize: aWireMessage content asString).
	instance msgId: (instance header ifNil:[nil] ifNotNil:[instance header msg_id]).
	instance msgType: (instance header ifNil:[nil] ifNotNil:[instance header msg_type]).
	^ instance
! !

!IPMsg methodsFor:'accessing'!

content
	^ content ifNil:[content := SCJsonObject new]
!

content: anObject
	content := anObject
!

header
	^ header  ifNil:[header := {
                'msg_id' -> self msgUUID.
                'date' -> DateAndTime now asString. 
                'msg_type' -> self msgType.
                'version' -> '5.0'.
     } asSCJsonObject ]
!

header: anObject
	header := anObject
!

metadata
	^ metadata ifNil:[metadata := SCJsonObject new]
!

metadata: anObject
	metadata := anObject
!

msgId
	^ msg_id ifNil:[ msg_id:= UUID new hex asString asUppercase].
!

msgId: anObject
	msg_id := anObject
!

msgType
	^ msg_type
!

msgType: anObject
	msg_type := anObject
!

msgUUID
 	^ msgUUID ifNil:[ UUID new hex asString asUppercase].
!

parentHeader
	^ parentHeader ifNil:[parentHeader := SCJsonObject new asByteArray ]
!

parentHeader: anObject
	parentHeader := anObject
!

uuid
 	^ uuid ifNil:[ uuid := UUID new hex asString asUppercase].
!

uuid: aString
 	uuid :=aString.
! !

!IPMsg methodsFor:'class membership'!

respondsToWireMessage: aWireMessage
	self parentHeader: aWireMessage header.
	self uuid: aWireMessage uuid.
! !

!IPMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPMsg.st,v 1.2 2018-05-14 00:45:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPMsg.st,v 1.2 2018-05-14 00:45:05 cg Exp $'
! !

