"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

CommandLineHandler subclass:#IPharoCommandLineHandler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPharoCommandLineHandler comment:''
!


!IPharoCommandLineHandler class methodsFor:'accessing'!

commandName
	^ 'ipharo'
!

description
	^ 'Starts ipharo kernel'
! !

!IPharoCommandLineHandler methodsFor:'activation'!

activate

	| ref stream kernelConfig content |
	self activateHelp ifTrue: [  ^ self ].
	self arguments notEmpty
		ifTrue:[
			ref :=self arguments first asFileReference .
			[	stream := ref readStreamIfAbsent: [ self error: 'Kernel config not found.' ].
				content := stream upToEnd.
			 	ZmqLog logDebug: content.	
			 	kernelConfig := SCMaterializer materializeFromString:content]
			ensure: [ stream ifNotNil: [ stream close ]]].
	ZmqContext new.
	IPharoKernel new 
						configKernel: kernelConfig;
						start;
						inspect.
! !

!IPharoCommandLineHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPharoCommandLineHandler.st,v 1.3 2018-05-14 07:43:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPharoCommandLineHandler.st,v 1.3 2018-05-14 07:43:29 cg Exp $'
! !

