"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

IPMsg subclass:#IPExecuteRequestReplayMsg
	instanceVariableNames:'sequenceNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Messages-Shell'
!

IPExecuteRequestReplayMsg comment:''
!


!IPExecuteRequestReplayMsg class methodsFor:'instance creation'!

newWithSequenceNumber: aSeqNum
	^ self basicNew 
				executionCount: aSeqNum;
				initialize
! !

!IPExecuteRequestReplayMsg methodsFor:'accessing'!

executionCount
	^ self content execution_count
!

executionCount: anInteger
	self content execution_count: anInteger
!

status
	self subclassResponsibility 	
! !

!IPExecuteRequestReplayMsg methodsFor:'initialization'!

initialize
	super initialize.
	self msgType: #execute_reply.
	self parentHeader: '{}' asByteArray .
	self metadata:{ 
						#dependencies_met->true.
						#started-> DateAndTime now asString.
						#status -> self status.
						} asSCJsonObject.
	self content: { 
						#status -> self status.
						} asSCJsonObject.
! !

!IPExecuteRequestReplayMsg class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecuteRequestReplayMsg.st,v 1.2 2018-05-14 00:47:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPExecuteRequestReplayMsg.st,v 1.2 2018-05-14 00:47:36 cg Exp $'
! !

