"{ Package: 'stx:goodies/communication/thrift' }"

TTransport subclass:#TFramedTransport
	instanceVariableNames:'outBuffer inBuffer'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Transport'
!

!TFramedTransport class methodsFor:'documentation'!

documentation
"
    now the standard transport (in cassandra at least).

    (took me a while to figure out, that the downloadable PD thrift.st is useless)
"
! !

!TFramedTransport methodsFor:'misc'!

close
    outBuffer := inBuffer := nil.
    super close.
! !

!TFramedTransport methodsFor:'reading'!

read: n
    |data|

    [inBuffer size < n] whileTrue:[
        self readFrame.
    ].
    data := inBuffer next:n.
    inBuffer size == 0 ifTrue:[
        inBuffer := nil.
    ].

    ^ data.
!

readByte
    |data|

    [inBuffer size < 1] whileTrue:[
        self readFrame.
    ].
    data := inBuffer next.

    inBuffer size == 0 ifTrue:[
        inBuffer := nil.
    ].
    ^ data
!

readFrame
    |frameSize|

    frameSize := socket nextUnsignedLongMSB:true.
    inBuffer isNil ifTrue:[
        inBuffer := ReadStream on:(socket next:frameSize).
    ] ifFalse:[
self halt.
        inBuffer setCollection:(inBuffer collection , (socket next:frameSize))
    ].
! !

!TFramedTransport methodsFor:'writing'!

flush
    |n|

    n := outBuffer size.
    n > 0 ifTrue:[
        socket nextPutLong:n MSB:true.
        socket nextPutBytes:n from:outBuffer collection startingAt:1.
        outBuffer := nil
    ].
!

write: aByteArray
    outBuffer isNil ifTrue:[
        outBuffer := WriteStream on:(ByteArray new:16*1024).
    ].
    outBuffer nextPutAll:aByteArray.
!

writeByte: aByte
    outBuffer isNil ifTrue:[
        outBuffer := WriteStream on:(ByteArray new:16*1024).
    ].
    outBuffer nextPut:aByte.
! !

!TFramedTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TFramedTransport.st,v 1.2 2013-03-22 14:23:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TFramedTransport.st,v 1.2 2013-03-22 14:23:57 cg Exp $'
! !

