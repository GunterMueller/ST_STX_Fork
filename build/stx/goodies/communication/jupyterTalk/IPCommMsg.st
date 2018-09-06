"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPCommMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-Comm'
!

IPCommMsg comment:''
!


!IPCommMsg methodsFor:'accessing'!

data
	^ self content at:#data 
!

data: data
	^ self content at:#data put: data
!

msgType
	^ #comm_msg
! !

!IPCommMsg methodsFor:'as yet unclassified'!

commID
	^ self content at:#comm_id ifAbsentPut:[ self msgUUID ]
!

commID: aValue
	self content at:#comm_id put: aValue
!

targetName
	^ self content at: #target_name 
!

targetName: aName
	^ self content at:#target_name put: aName
! !

!IPCommMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPCommMsg.st,v 1.2 2018-05-14 00:45:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPCommMsg.st,v 1.2 2018-05-14 00:45:03 cg Exp $'
! !

