"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPIsCompleteReplyMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-Shell'
!

IPIsCompleteReplyMsg comment:''
!


!IPIsCompleteReplyMsg methodsFor:'initialization'!

initialize
	super initialize.
	self msgType: #is_complete_reply.
	self parentHeader: '{}' asByteArray .
	self metadata: SCJsonObject new.
	self content: {#status->#complete} asSCJsonObject . 
! !

!IPIsCompleteReplyMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPIsCompleteReplyMsg.st,v 1.2 2018-05-14 00:44:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPIsCompleteReplyMsg.st,v 1.2 2018-05-14 00:44:45 cg Exp $'
! !

