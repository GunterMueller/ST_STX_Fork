"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPStreamMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-IOPub'
!

IPStreamMsg comment:''
!


!IPStreamMsg methodsFor:'accessing'!

name
	^ self content name
!

name: aString
	self content name:aString
	
!

text
	^ self content text
!

text: aString
	self content text:aString
! !

!IPStreamMsg methodsFor:'initialization'!

initialize
	super initialize.
	self msgType: #stream.
! !

!IPStreamMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPStreamMsg.st,v 1.2 2018-05-14 00:44:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPStreamMsg.st,v 1.2 2018-05-14 00:44:51 cg Exp $'
! !

