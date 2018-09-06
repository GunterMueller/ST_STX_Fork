"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMessageProcessor subclass:#IPStdInProcessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPStdInProcessor comment:''
!


!IPStdInProcessor methodsFor:'accessing'!

threadName
	^ 'ipharo-stdin' 
! !

!IPStdInProcessor methodsFor:'hooks'!

execute: anIPMessage
	"TODO: What do we have to do here¿?¿ we will see"
! !

!IPStdInProcessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPStdInProcessor.st,v 1.2 2018-05-14 00:44:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPStdInProcessor.st,v 1.2 2018-05-14 00:44:35 cg Exp $'
! !

