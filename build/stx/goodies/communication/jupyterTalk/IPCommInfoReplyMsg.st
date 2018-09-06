"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPCommInfoReplyMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-Shell'
!

IPCommInfoReplyMsg comment:''
!


!IPCommInfoReplyMsg methodsFor:'initialization'!

initialize
	super initialize.
	self msgType: #comm_info_reply.
	self parentHeader: '{}' asByteArray .
	self metadata: SCJsonObject new.
	self content: IPharoKernel instance commChanels asSCJsonObject. 
! !

!IPCommInfoReplyMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPCommInfoReplyMsg.st,v 1.2 2018-05-14 00:44:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPCommInfoReplyMsg.st,v 1.2 2018-05-14 00:44:29 cg Exp $'
! !

