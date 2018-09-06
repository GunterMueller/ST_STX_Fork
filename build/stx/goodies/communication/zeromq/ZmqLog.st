"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqLog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!


!ZmqLog class methodsFor:'as yet unclassified'!

logDebug: aString
    Smalltalk isSmalltalkX ifTrue:[
        Logger debug:aString
    ] ifFalse:[
        self logInfo: aString
    ]
!

logError: aString
    Smalltalk isSmalltalkX ifTrue:[
        Logger error:aString
    ] ifFalse:[
        self logInfo: aString
    ]
!

logInfo: aString
    Smalltalk isSmalltalkX ifTrue:[
        Logger info:aString
    ] ifFalse:[
        self log: TimeStamp now asString, ' - ',aString, String cr.
    ].
! !

!ZmqLog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqLog.st,v 1.2 2018-05-10 20:44:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqLog.st,v 1.2 2018-05-10 20:44:54 cg Exp $'
! !

