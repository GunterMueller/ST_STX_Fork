"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqEventFilter
	instanceVariableNames:'eventMask'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqEventFilter comment:''
!


!ZmqEventFilter class methodsFor:'as yet unclassified'!

, aZmqEventFilter
	^ZmqEventFilter  new eventMask: (self eventMask bitOr: aZmqEventFilter eventMask).
!

eventMask
	^0.
! !

!ZmqEventFilter methodsFor:'as yet unclassified'!

eventMask
	^eventMask.
!

eventMask: anInteger
	eventMask:=anInteger.
! !

!ZmqEventFilter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqEventFilter.st,v 1.1 2018-05-08 19:44:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqEventFilter.st,v 1.1 2018-05-08 19:44:42 cg Exp $'
! !

