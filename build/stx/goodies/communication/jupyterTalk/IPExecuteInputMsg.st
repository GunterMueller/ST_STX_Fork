"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPExecuteInputMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-IOPub'
!

IPExecuteInputMsg comment:''
!


!IPExecuteInputMsg methodsFor:'accessing'!

code: source
	self content code: source
!

executionCount
	^ self content execution_count
!

executionCount: anInteger
	self content execution_count:anInteger
! !

!IPExecuteInputMsg methodsFor:'initialization'!

initialize
	
	super initialize.
	self msgType: #execute_input.
	self parentHeader: '{}' asByteArray .
	self metadata: SCJsonObject new.
	self content: SCJsonObject new.
! !

!IPExecuteInputMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecuteInputMsg.st,v 1.2 2018-05-14 00:44:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecuteInputMsg.st,v 1.2 2018-05-14 00:44:11 cg Exp $'
! !

