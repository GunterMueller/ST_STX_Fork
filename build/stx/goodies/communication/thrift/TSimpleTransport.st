"{ Package: 'stx:goodies/communication/thrift' }"

TTransport subclass:#TSimpleTransport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Transport'
!

!TSimpleTransport class methodsFor:'documentation'!

documentation
"
    Obsolete.

    Based on the original thrift downloadable version, 
    but completely uselss as unframed I/O is no longer used by thrift 
    (took me a while to figure that one out)
"
! !

!TSimpleTransport methodsFor:'reading'!

read: n
    ^ socket next:n.
!

readByte
    ^ socket next
! !

!TSimpleTransport methodsFor:'writing'!

flush
    socket flush
!

write: aByteArray
    socket nextPutAll:aByteArray.
!

writeByte: aByte
    socket nextPut:aByte.
! !

!TSimpleTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TSimpleTransport.st,v 1.1 2013-03-20 15:53:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TSimpleTransport.st,v 1.1 2013-03-20 15:53:31 cg Exp $'
! !

