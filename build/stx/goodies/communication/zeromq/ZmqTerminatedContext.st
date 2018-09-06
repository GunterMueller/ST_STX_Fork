"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqTerminatedContext
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqTerminatedContext comment:''
!


!ZmqTerminatedContext methodsFor:'error handling'!

doesNotUnderstand:  aMessage
	self error:'Context is terminated' 
! !

!ZmqTerminatedContext methodsFor:'private'!

privateTerminate
! !

!ZmqTerminatedContext methodsFor:'system startup'!

parkForSnapshot
	^ self
!

reinitialize
	^ self
! !

!ZmqTerminatedContext methodsFor:'testing'!

isTerminated 
	^true
! !

!ZmqTerminatedContext class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqTerminatedContext.st,v 1.1 2018-05-08 19:45:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqTerminatedContext.st,v 1.1 2018-05-08 19:45:40 cg Exp $'
! !

