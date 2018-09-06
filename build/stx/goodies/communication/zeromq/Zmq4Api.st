"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Zmq3Api subclass:#Zmq4Api
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!


!Zmq4Api class methodsFor:'structure definitions'!

pollItemClass
    ^ ZmqApiPollItemV4
! !

!Zmq4Api class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/Zmq4Api.st,v 1.2 2018-05-10 20:45:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/Zmq4Api.st,v 1.2 2018-05-10 20:45:11 cg Exp $'
! !

