"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPKernelStatusMsg subclass:#IPKernelStatusBusyMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-IOPub'
!

IPKernelStatusBusyMsg comment:''
!


!IPKernelStatusBusyMsg methodsFor:'as yet unclassified'!

executionState
	^ #busy
! !

!IPKernelStatusBusyMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelStatusBusyMsg.st,v 1.2 2018-05-14 00:44:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelStatusBusyMsg.st,v 1.2 2018-05-14 00:44:43 cg Exp $'
! !

