"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalStructure subclass:#ZmqApiMessage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!


!ZmqApiMessage class methodsFor:'field definition'!

byteSize
    Smalltalk isSmalltalkX ifTrue:[
        ^ ExternalBytes sizeofPointer
    ] ifFalse:[
        ^ FFIArchitecture forCurrentArchitecture longTypeSize*8
    ].
! !

!ZmqApiMessage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiMessage.st,v 1.3 2018-05-11 07:51:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiMessage.st,v 1.3 2018-05-11 07:51:06 cg Exp $'
! !

