"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalStructure subclass:#ZmqApiStructForInt
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!


!ZmqApiStructForInt class methodsFor:'class initialization'!

initialize
    OFFSET_VALUE := 1
! !

!ZmqApiStructForInt class methodsFor:'field definition'!

fields
^#(value 'ulong')
	
! !

!ZmqApiStructForInt methodsFor:'accessing'!

value: anObject
        ^self "handle" signedLongAt: OFFSET_VALUE put: anObject.
! !

!ZmqApiStructForInt methodsFor:'evaluating'!

value
        ^self "handle" signedLongAt: OFFSET_VALUE
! !

!ZmqApiStructForInt methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: self value asString.
! !

!ZmqApiStructForInt class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiStructForInt.st,v 1.2 2018-05-11 00:00:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiStructForInt.st,v 1.2 2018-05-11 00:00:49 cg Exp $'
! !


ZmqApiStructForInt initialize!
