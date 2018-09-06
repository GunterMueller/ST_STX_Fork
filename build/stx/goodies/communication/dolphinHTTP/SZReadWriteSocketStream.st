"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SZReadWriteSocketStream
	instanceVariableNames:'readStream writeStream'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Support'
!

SZReadWriteSocketStream comment:'I am  a ReadWrite SocketStream. My stream contentSpecies is <String>, but I also provide methods to access the streams using ByteArrays/Integers.

Instance Variables:
	readStream	<SocketReadStream> 
	writeStream	<SocketWriteStream>

==========
Note:
-The readStream and writeStream can be streams (on ByteArrays) for testing purposes
'
!


!SZReadWriteSocketStream class methodsFor:'instance creation'!

readStream:readStreamArg writeStream:writeStreamArg
    ^ self new readStream:readStreamArg writeStream:writeStreamArg
!

socket: socket
    ^ self readStream:socket writeStream:socket

    "Created: / 23-09-2011 / 22:52:20 / cg"
!

testStreamReading: aByteObject
    "SW Test helper method.
    -aByteArray is set (and reset) into the readStream."

    ^self readStream: aByteObject "asByteArray" readStream writeStream: String "ByteArray" writeStream

    "Created: / 23-09-2011 / 14:53:06 / cg"
! !

!SZReadWriteSocketStream methodsFor:'accessing'!

log
	^''
!

readStream
	^readStream
!

readStream:readStreamArg writeStream:writeStreamArg 
    readStream := readStreamArg.
    writeStream := writeStreamArg.
!

writeStream
    ^ writeStream

    "Created: / 23-09-2011 / 22:09:46 / cg"
!

writeStream: aWriteStream
	writeStream := aWriteStream
! !

!SZReadWriteSocketStream methodsFor:'misc'!

close
	writeStream notNil ifTrue: [writeStream close].
	readStream notNil ifTrue: [readStream close].
	writeStream := readStream := nil
!

doBytes: operation
	[operation value: self nextByte] repeat
!

resetLogStream
! !

!SZReadWriteSocketStream methodsFor:'queries'!

contentsSpecies
	^String
!

hasInput 
	^readStream hasInput
! !

!SZReadWriteSocketStream methodsFor:'reading'!

atEnd
    ^ readStream atEnd.

    "Created: / 23-09-2011 / 21:55:35 / cg"
!

next
    ^ readStream next

    "Created: / 23-09-2011 / 22:34:09 / cg"
!

next:n
    ^ readStream next:n.

    "Created: / 23-09-2011 / 22:32:34 / cg"
!

next: count into: aSequenceableCollection startingAt: startAt
	^readStream 
		next: count
		into: aSequenceableCollection
		startingAt: startAt
!

nextByte
    ^ readStream nextByte.

    "Created: / 23-09-2011 / 21:55:54 / cg"
!

nextBytes:n
    ^ readStream nextBytes:n.

    "Created: / 23-09-2011 / 22:31:05 / cg"
!

peek
    ^ readStream peek

    "Created: / 23-09-2011 / 22:34:12 / cg"
!

upToCRLF
    ^ readStream nextLine.
"/    | line nextChar |
"/    line := readStream upTo: Character return "cr".
"/    self assert: [(nextChar := readStream next) = Character lf].
"/    ^line

    "Created: / 23-09-2011 / 18:05:44 / cg"
! !

!SZReadWriteSocketStream methodsFor:'writing'!

crlf
    writeStream crlf

    "Created: / 23-09-2011 / 22:08:46 / cg"
!

flush
    writeStream flush

    "Created: / 23-09-2011 / 22:53:16 / cg"
!

next: size putAll: aSequenceableCollection startingAt: start
	^writeStream 
		next: size
		putAll: aSequenceableCollection
		startingAt: start
!

nextPutAll:aCollection
    writeStream nextPutAll:aCollection.

    "Created: / 23-09-2011 / 22:05:30 / cg"
!

space
    writeStream space

    "Created: / 23-09-2011 / 22:09:22 / cg"
! !

!SZReadWriteSocketStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SZReadWriteSocketStream.st,v 1.6 2011-10-04 16:30:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SZReadWriteSocketStream.st,v 1.6 2011-10-04 16:30:08 cg Exp $'
! !
