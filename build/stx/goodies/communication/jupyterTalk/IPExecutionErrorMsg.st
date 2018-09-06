"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPExecuteRequestReplayMsg subclass:#IPExecutionErrorMsg
	instanceVariableNames:'exceptionObject'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-Shell'
!

IPExecutionErrorMsg comment:''
!


!IPExecutionErrorMsg class methodsFor:'instance creation'!

newWithSequenceNumber: aSeqNum 
		self error:'use newWithSequenceNumber:anInteger error:anExceptionObject'
				
!

newWithSequenceNumber: aSeqNum error: AnException
	^ self basicNew 
				executionCount: aSeqNum;
				exceptionObject: AnException;
				initialize
				
! !

!IPExecutionErrorMsg methodsFor:'accessing'!

fillContent

	self content at:#ename put: self exceptionObject className.
	self content at:#evalue put: self exceptionObject messageText asString.
	self content at:#traceback put: self traceback.
	
!

status
	^ #error
! !

!IPExecutionErrorMsg methodsFor:'as yet unclassified'!

traceback
	|sender traceback|
	traceback := OrderedCollection new.
	sender := self exceptionObject signalerContext sender.
	traceback add: self exceptionObject className.
	traceback add: self exceptionObject messageText asString.
	[ sender notNil ] whileTrue:[
		[traceback 
			add: sender asString.
		sender := sender sender]
		on:Error do:[sender := nil]].

	^ traceback asArray 
! !

!IPExecutionErrorMsg methodsFor:'initialization'!

exceptionObject
	^ exceptionObject 
!

exceptionObject: anException
	exceptionObject := anException.
	self fillContent 
! !

!IPExecutionErrorMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecutionErrorMsg.st,v 1.2 2018-05-14 00:44:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecutionErrorMsg.st,v 1.2 2018-05-14 00:44:57 cg Exp $'
! !

