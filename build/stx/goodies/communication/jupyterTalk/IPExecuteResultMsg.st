"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPDisplayDataMsg subclass:#IPExecuteResultMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-IOPub'
!

IPExecuteResultMsg comment:''
!


!IPExecuteResultMsg methodsFor:'accessing'!

msgType
	^ #execute_result
! !

!IPExecuteResultMsg methodsFor:'as yet unclassified'!

executionCount
	^ self content execution_count
!

executionCount: anInteger
	self content execution_count: anInteger
! !

!IPExecuteResultMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecuteResultMsg.st,v 1.2 2018-05-14 00:44:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecuteResultMsg.st,v 1.2 2018-05-14 00:44:23 cg Exp $'
! !

