"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPExecuteRequestReplayMsg subclass:#IPExecutionAbortedMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-Shell'
!

IPExecutionAbortedMsg comment:''
!


!IPExecutionAbortedMsg methodsFor:'accessing'!

status
	^ #abort
! !

!IPExecutionAbortedMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecutionAbortedMsg.st,v 1.2 2018-05-14 00:44:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecutionAbortedMsg.st,v 1.2 2018-05-14 00:44:27 cg Exp $'
! !

