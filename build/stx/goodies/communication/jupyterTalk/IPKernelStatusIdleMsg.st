"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPKernelStatusMsg subclass:#IPKernelStatusIdleMsg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-IOPub'
!

IPKernelStatusIdleMsg comment:''
!


!IPKernelStatusIdleMsg methodsFor:'as yet unclassified'!

executionState
	^ #idle
! !

!IPKernelStatusIdleMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelStatusIdleMsg.st,v 1.2 2018-05-14 00:44:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPKernelStatusIdleMsg.st,v 1.2 2018-05-14 00:44:41 cg Exp $'
! !

