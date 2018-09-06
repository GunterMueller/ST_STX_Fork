"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPDisplayDataMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-IOPub'
!

IPDisplayDataMsg comment:''
!


!IPDisplayDataMsg methodsFor:'accessing'!

msgType
	^#display_data
! !

!IPDisplayDataMsg methodsFor:'initialization'!

contentMetadata
	^ self content metadata
   
!

contentMetadata: aJsonMetadata
	self content metadata: aJsonMetadata
   
!

data
	^ self content data
   
!

data: aJsonData
	self content data: aJsonData
   
!

transient
	^ self content transient
   
!

transient: aJsonData
	self content transient: aJsonData
   
! !

!IPDisplayDataMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPDisplayDataMsg.st,v 1.2 2018-05-14 00:44:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPDisplayDataMsg.st,v 1.2 2018-05-14 00:44:47 cg Exp $'
! !

