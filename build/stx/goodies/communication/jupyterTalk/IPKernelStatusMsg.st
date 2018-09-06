"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPKernelStatusMsg
	instanceVariableNames:'sequenceNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-IOPub'
!

IPKernelStatusMsg comment:''
!


!IPKernelStatusMsg methodsFor:'accessing'!

executionState
	self subclassResponsibility 	
! !

!IPKernelStatusMsg methodsFor:'initialization'!

initialize
	super initialize.
	self msgType: #status.
	self metadata: SCJsonObject new.
	self parentHeader: '{}' asByteArray. 
	self content: { 
						#execution_state -> self executionState.
						} asSCJsonObject.
! !

!IPKernelStatusMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelStatusMsg.st,v 1.2 2018-05-14 00:44:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelStatusMsg.st,v 1.2 2018-05-14 00:44:25 cg Exp $'
! !

