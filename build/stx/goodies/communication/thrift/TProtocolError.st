"{ Package: 'stx:goodies/communication/thrift' }"

TError subclass:#TProtocolError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Protocol'
!


!TProtocolError class methodsFor:'as yet unclassified'!

badVersion
	^ 4
!

invalidData
	^ 1
!

negativeSize
	^ 2
!

sizeLimit
	^ 3
!

unknown
	^ 0
! !

!TProtocolError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TProtocolError.st,v 1.1 2013-03-19 14:47:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TProtocolError.st,v 1.1 2013-03-19 14:47:30 cg Exp $'
! !

