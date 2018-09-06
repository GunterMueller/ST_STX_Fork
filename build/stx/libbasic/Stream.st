"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Stream
	instanceVariableNames:'signalAtEnd'
	classVariableNames:'StreamErrorSignal PositionErrorSignal ReadErrorSignal
		WriteErrorSignal EndOfStreamSignal LineTooLongErrorSignal
		ChunkSeparator'
	poolDictionaries:''
	category:'Streams'
!

!Stream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    An abstract class defining common behavior for all stream-like objects.
    See concrete subclasses for more detail.

    The protocol as implemented here is often only provided as a fallBack
    for very uncommon cases. Much of it is redefined for performance.
    (In streams which know more about their internal representation ...)


    Subclasses should (at least) implement:
        #next           (if readable)
        #nextPut:       (if writable)
        #contents
        #atEnd
        #isReadable
        #isWritable

    Peekable & Positionable streams should (at least) implement:
        #peek
        #position
        #position:


    [instance variables:]
        signalAtEnd             <nil | Boolean> controls behavior when a read
                                                is attempted past the end-of-stream
                                                if true, the endOfStreamSignal is raised.
                                                if false, nil is returned.
                                                if nil (the default), the signal
                                                is raised, but if there is no handler,
                                                nil is returned.

    [Class variables / Exceptions:]
        StreamError             <Exception>     parent of all stream errors

        PositionError           <Exception>     position attemted on a stream
                                                which does not support positioning,
                                                or if the position is invalid.

        ReadError               <Exception>     raised on read errors

        WriteError              <Exception>     raised on write errors

        EndOfStreamSignal       <Signal>        raised at end of stream if signalAtEnd
                                                is enabled.

    [caveat:]
        The Stream hierarchy has a few little quirks in it, which are a consequence of some early historic
        decisions. The biggest problem is the distinction between readable and writeable streams based on inheritance,
        instead of by either using state (i.e. a flag) or delegation.
        The problem is that there are streams which can be both, and maybe even dynamically change their opinion,
        on whether being readable/writable.
        (For example, a buffer may be write-only while filled, but become readonly, when given to a consumer.)

        The above decision to base this on inheritance lead to the ugly ReadStream - WriteStream - ReadWriteStream
        hierarchy, with some subclasses undoing the blocking of their superclass.

        Classes named 'ReadStream', 'WriteStream', 'ReadWriteStream', 'PeekableStream' and 'PositionableStream' should
        all be eliminated in favour of a few flags in the 'Stream' superclass.

        It is really time for a new stream hierarchy (XStreams, for example).
        (On the other hand: there is so much code around, which depends on the current situation, that such a change
         must really be thought through - most got used to these issues and live with it more or less happily)

    [author:]
        Claus Gittinger
"
! !

!Stream class methodsFor:'initialization'!

initSignals
    StreamErrorSignal := StreamError.
    StreamErrorSignal notifierString:'Stream error'.

    PositionErrorSignal := PositionError.
    PositionErrorSignal notifierString:'stream has no concept of a position'.

    ReadErrorSignal := ReadError.
    ReadErrorSignal notifierString:'read error'.

    WriteErrorSignal := WriteError.
    WriteErrorSignal notifierString:'write error'.

    LineTooLongErrorSignal := QuerySignal new.
    LineTooLongErrorSignal parent:StreamError.
    LineTooLongErrorSignal nameClass:self message:#lineTooLongErrorSignal.
    LineTooLongErrorSignal notifierString:'line too long'.

    EndOfStreamSignal := EndOfStreamNotification.
    EndOfStreamSignal notifierString:'end of stream'.

    "Created: / 7.9.2001 / 14:15:13 / cg"
    "Modified: / 7.9.2001 / 14:15:27 / cg"
!

initialize
    ChunkSeparator := $!!.

    LineTooLongErrorSignal isNil ifTrue:[
	self initSignals
    ]

    "Modified: / 1.11.1998 / 15:57:37 / stefan"
    "Modified: / 7.9.2001 / 14:15:51 / cg"
! !

!Stream class methodsFor:'instance creation'!

new
    "{ Pragma: +optSpace }"

    "report an error - Streams are created using on:-messages"

    self error:'Streams cannot be created with new'
! !

!Stream class methodsFor:'Signal constants'!

endOfStreamSignal
    "return the signal raised if read past end of stream is attemted"

    ^ EndOfStreamNotification
!

incompleteNextCountSignal
    "return the signal raised if not all requested elements are returned"

    ^ IncompleteNextCountError
!

lineTooLongErrorSignal
    "return the signal raised if a line is read which is too long (>32k)"

    ^ LineTooLongErrorSignal

    "Created: / 15.10.1998 / 12:11:14 / cg"
!

positionErrorSignal
    "return the signal raised if positioning is requested for
     a stream which does not support that kind of operation"

    ^ PositionError
!

readErrorSignal
    "return the signal raised on read errors"

    ^ ReadError
!

streamErrorSignal
    "return the parent of all stream errors;
     handling this one also handles all other errors.
     Also, this one may be raised for errors not related to read/write
     operations, such as failed ioctls in externalStream etc."

    ^ StreamError
!

writeErrorSignal
    "return the signal raised on write errors"

    ^ WriteError
! !

!Stream class methodsFor:'constants'!

chunkSeparator
    "return the chunk-separation character"

    ^ ChunkSeparator
! !

!Stream class methodsFor:'testing'!

isAbstract
    ^ self == Stream
! !


!Stream methodsFor:'Compatibility-Dolphin'!

display:someObject
    "dolphin compatibility"

    "/ someObject printOn:self.
    self nextPutAll: someObject asString.
! !


!Stream methodsFor:'Compatibility-VW'!

nl
    "append a newline to the stream.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character nl)
! !


!Stream methodsFor:'accessing'!

contents
    "return the entire contents of the stream.
     For a readStream, that is the rest (i.e. upToEnd),
     for a writeStream, that is the collected data. As we do not know here,
     what we are, this is the responsibility of a subclass..."

    ^ self subclassResponsibility
!

signalAtEnd
    "return the signalAtEnd flag setting.
     If true, reading past the end will always raise an EndOfStream exception.
     If false, no exception is raised and nil is returned from all reading messages.
     If nil (default), the exception is raised if there is a handler; otherwise, nil is returned.
     The default is nil (for ST80 compatibility) i.e. to only raise a signal if there is a handler."

    ^ signalAtEnd

    "Created: 5.2.1996 / 18:24:53 / stefan"
    "Modified: 15.5.1996 / 17:35:55 / cg"
!

signalAtEnd:aBoolean
    "set the signalAtEnd flag setting. 
     If true, reading past the end will raise an EndOfStream exception. 
     If false, no exception is raised and nil is returned from all reading messages.
     If nil (default), the exception is raised if there is a handler; otherwise, nil is returned.
     The default (nil) is both st80 backward compatible (i.e. returning nil)
     AND allows for modern code to provide a handler."

    signalAtEnd := aBoolean.

    "default behavior: return nil if unhandled ...
     |s|

     s := '12' readStream.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
    "

    "... raise error if handled.
     |s|

     s := '12' readStream.
     Stream endOfStreamSignal handle:[:ex |
        Transcript showCR:'end reached'.
        ex return
     ] do:[
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
     ]
    "

    "force raise (useful for debugging):
     |s|

     s := '12' readStream.
     s signalAtEnd:true.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
    "


    "force no-raise (useful for compatibility with other systems):
     |s|

     s := '12' readStream.
     s signalAtEnd:false.
     Stream endOfStreamSignal handle:[:ex |
        Transcript showCR:'end reached'.
        ex return
     ] do:[
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
     ]
    "

    "Modified: / 16.6.1998 / 16:04:41 / cg"
! !

!Stream methodsFor:'converting'!

asLineNumberReadStream
    "returns a new stream, which keeps track of the line number.
     It can be asked for the current linenumber,
     which is useful eg. for error message generation"

    ^ LineNumberReadStream on:self
!

asStream
    ^ self
! !

!Stream methodsFor:'emphasis'!

bold
    "set emphasis to #bold.
     this allows Streams to be used interchangeable with printStreams"

    self emphasis:#bold.

    "Created: 14.5.1996 / 17:37:37 / cg"
    "Modified: 3.6.1996 / 16:57:17 / cg"
!

boldItalic
    "set emphasis to #boldItalic
     this allows Streams to be used interchangeable with printStreams"

    self emphasis:#(bold italic).

    "Created: 14.5.1996 / 17:37:47 / cg"
    "Modified: 3.6.1996 / 17:15:22 / cg"
!

emphasis
    "ignored here - allows Streams to be used interchangable with
     text streams"

    ^ nil

    "Created: 14.5.1996 / 17:39:45 / cg"
!

emphasis:anEmphasis
    "ignored here.
     this allows Streams to be used interchangeable with printStreams"

    ^ self

    "Created: 14.5.1996 / 17:38:07 / cg"
!

italic
    "set emphasis to #italic.
     this allows Streams to be used interchangeable with printStreams"

    self emphasis:#italic.

    "Created: 14.5.1996 / 17:37:55 / cg"
    "Modified: 3.6.1996 / 17:15:32 / cg"
!

normal
    "set emphasis to #normal.
     this allows Streams to be used interchangeable with printStreams"

    self emphasis:nil

    "Created: 14.5.1996 / 17:37:59 / cg"
    "Modified: 3.6.1996 / 17:15:35 / cg"
!

strikeout
    "set emphasis to #strikeout.
     this allows Streams to be used interchangeable with printStreams"

    self emphasis:#strikeout.

    "Modified: 3.6.1996 / 16:57:56 / cg"
    "Created: 3.6.1996 / 17:15:45 / cg"
!

underline
    "set emphasis to #underline.
     this allows Streams to be used interchangeable with printStreams"

    self emphasis:#underline.

    "Created: 3.6.1996 / 17:00:03 / cg"
    "Modified: 3.6.1996 / 17:15:38 / cg"
!

withEmphasis:anEmphasis do:aBlock
    "evaluate aBlock while my emphasis has been changed to anEmphasis.
     Emphasis is ignored here, but implemented in some subclasses (PrinterStream, TextCollector etc.)."

    |oldEmphasis|

    oldEmphasis := self emphasis.
    [
        self emphasis:anEmphasis.
        aBlock value
    ] ensure:[
        self emphasis:oldEmphasis.
    ].

    "Created: / 06-09-2012 / 16:12:55 / cg"
! !

!Stream methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for all remaining elements,
     up to the end of the stream"

    [self atEnd] whileFalse:[
	aBlock value:(self next)
    ]

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8 9).
     s next.
     s next.
     s do:[:element | Transcript showCR:element]
    "
!

linesDo:aBlock
    "evaluate the argument, aBlock for all lines,
     up to the end of the stream"

    [self atEnd] whileFalse:[
        aBlock value:(self nextLine)
    ]

    "
     |s|
     s := '/etc/hosts' asFilename readStream.
     s linesDo:[:line | Transcript showCR:line].
     s close
    "

    "
     Filename readingFile:'/etc/hosts'
     do:[:s |
         s linesDo:[:line | Transcript showCR:line].
     ].
    "
! !

!Stream methodsFor:'error handling'!

checkNilFileStream
    "Do nothing if this is a valid FileStream
     (i.e. the previous open operation was successful).
     Also implemented in UndefinedObject, to raise an Error there.

     This is an aid for converting from the old error reporting (returning nil)
     to the new error reporting (with real Exceptions).

     It will vanish as soon as the conversion has been done"

    ^ self
!

errorNotOpen
    "{ Pragma: +optSpace }"

    "report an error, that the stream has not been opened"

    ^ StreamNotOpenError raiseRequestWith:self  "/ in:thisContext sender

    "Modified: / 8.5.1999 / 20:12:33 / cg"
!

pastEnd
    "someone tried to read after the end of the stream.
     If signalAtEnd == true, raise a signal. If it's false, return nil.
     Otherwise raise the signal, but only if handled; otherwise return nil."

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #pastEndRead'.
    ^ self pastEndRead

    "Modified: / 18-11-2006 / 15:36:44 / cg"
!

pastEndRead
    "someone tried to read after the end of the stream.
     If signalAtEnd == true, raise a signal.
     If it is false, return nil.
     Otherwise raise a notification, which is ignored if not handled;
     otherwise return nil."

    |shouldSignalAtEnd|

    shouldSignalAtEnd := self signalAtEnd.

    shouldSignalAtEnd == true ifTrue:[
        "raise - a hard error..."
        ^ EndOfStreamError raiseRequestFrom:self
    ].
    shouldSignalAtEnd == false ifTrue:[
        "never raise ..."
        ^ nil
    ].

    "EndOfStreamNotification is a notification;
     i.e. it is ignored, if there is no handler.
     In this case, nil is returned"

    ^ EndOfStreamNotification raiseRequestFrom:self


    " ... no handler, no raise
     |s|

     s := '12' readStream.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
    "

    "... raise error if handled.
     |s|

     s := '12' readStream.
     EndOfStreamNotification handle:[:ex |
        Transcript showCR:'end reached'.
        ex return
     ] do:[
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
     ]
    "

    "force raise (useful for debugging):
     |s|

     s := '12' readStream.
     s signalAtEnd:true.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
     Transcript showCR:s next.
    "


    "force no-raise (useful for compatibility with other systems):
     |s|

     s := '12' readStream.
     s signalAtEnd:false.
     Stream endOfStreamSignal handle:[:ex |
        Transcript showCR:'end reached'.
        ex return
     ] do:[
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
        Transcript showCR:s next.
     ]
    "

    "Modified: / 16.6.1998 / 16:04:13 / cg"
! !

!Stream methodsFor:'misc'!

binary
    "switch to binary mode. In binary mode, reading of text streams
     returns byte-valued integers instead of characters; writing expects
     byte-valued integers respectively.
     Ignored here, but added to make internalStreams protocol compatible
     with externalStreams."

    "Modified: 15.5.1996 / 17:38:36 / cg"
!

blocking:aBoolean
    "set non-blocking mode.
     Ignored, since internal streams never block"

    ^ false.
!

eolMode
    "Dummy here, but added to make internalStreams protocol compatible
     with externalStreams."

     ^ nil  "/ transparent
!

eolMode:aSymbol
    "Ignored here, but added to make internalStreams protocol compatible
     with externalStreams."
!

lineEndCRLF
    "Ignored here, but added to make internalStreams protocol compatible
     with externalStreams."
!

lineEndConvention
     ^ self eolMode
!

lineEndConvention:aSymbol
     ^ self eolMode:aSymbol
!

lineEndLF
    "Ignored here, but added to make internalStreams protocol compatible
     with externalStreams."
!

lineEndTransparent
    "Ignored here, but added to make internalStreams protocol compatible
     with externalStreams."
!

stream
    "for compatibility with encodedStream"

    ^ self
!

text
    "switch to text mode.
     Ignored here, but added to make internalStreams protocol compatible
     with externalStreams."

    "Modified: 15.5.1996 / 17:38:36 / cg"
    "Created: 13.9.1996 / 18:33:26 / cg"
! !

!Stream methodsFor:'misc functions'!

copy:numberOfBytes into:outStream
    "read from the receiver, and write numberOfBytes data to another aWriteStream.
     Return the number of bytes which have been transferred."

    ^ self copy:numberOfBytes into:outStream bufferSize:(128*1024)
!

copy:numberOfBytes into:aWriteStream bufferSize:bufferSizeArg
    "read from the receiver, and write numberOfBytes data to another aWriteStream.
     Return the number of bytes which have been transferred."

    |bufferSpecies bufferSize bytesLeft buffer countWritten freeBuffer|

    countWritten := 0.
    bufferSpecies := self contentsSpecies.
    bytesLeft := numberOfBytes.
    bufferSize := bufferSizeArg min:numberOfBytes.

    bufferSpecies == ByteArray ifTrue:[
        "an ExternalBytes buffer is faster when writing to a windows ExternalStream"
        buffer:= ExternalBytes unprotectedNew:bufferSize.
        freeBuffer := true.
    ] ifFalse:[
        buffer := self contentsSpecies new:bufferSize.
        freeBuffer := false.
    ].

    "read loop: read required bytes"
    [
        |readCount|

        readCount := self nextAvailable:bytesLeft into:buffer startingAt:1.
        bytesLeft := bytesLeft - readCount.

        readCount > 0 ifTrue:[
            |writeCount|

            writeCount := 0.
            "write loop: write until all is written"
            [
                |count|

                count := aWriteStream
                            nextPutAll:readCount-writeCount
                            from:buffer
                            startingAt:writeCount+1.
                writeCount := writeCount + count.
                writeCount < readCount ifTrue:[
                    aWriteStream writeWait.
                    true.
                ] ifFalse:[
                    false
                ].
            ] whileTrue.
            countWritten := countWritten + writeCount.
        ].
        "Note: atEnd will block if reading from an empty pipe or socket.
         avoid atEnd if possible, because it reads a single byte."
        bytesLeft ~~ 0 or:[self atEnd not]
    ] whileTrue.

    freeBuffer ifTrue:[ buffer free ].
    ^ countWritten.
!

copyToEndFrom:inStream
    "read from inStream, and write all data up to the end to the receiver.
     Return the number of bytes which have been transferred.
     Same functionality as copyToEnd:, but reversed arg and receiver
     (useful in a cascade message of the writeStream)"

    ^ inStream copyToEndInto:self
!

copyToEndInto:outStream
    "read from the receiver, and write all data up to the end to another stream.
     Return the number of bytes which have been transferred"

    ^ self copyToEndInto:outStream bufferSize:(128*1024)

"/ data rate to USB2.0 stick (Win32):
"/   120 KB/s       8Kb SingleBuffer
"/   741 KB/s      64Kb SingleBuffer
"/  1345 KB/s     128Kb SingleBuffer
"/  2087 KB/s     256Kb SingleBuffer
"/  3573 KB/s    1024Kb SingleBuffer

"/|t retVal|
"/
"/t := Time millisecondsToRun:[
"/    retVal := self copyToEndInto:outStream bufferSize:(64*1024).
"/].
"/
"/Transcript showCR:('%1 KB copied in %2s (%3 KB/s)'
"/        bindWith:((retVal/1024)asFixedPoint:2)
"/        with:((t/1000)asFixedPoint:2)
"/        with:((retVal/1024/(t/1000))asFixedPoint:2)).
"/^ retVal.
"/
!

copyToEndInto:outStream bufferSize:bufferSize
    "read from the receiver, and write all data up to the end to another stream.
     Return the number of bytes which have been transferred"

    |bufferSpecies buffer countWritten freeBuffer|

    countWritten := 0.
    bufferSpecies := self contentsSpecies.
    bufferSpecies == ByteArray ifTrue:[
        "an ExternalBytes buffer is faster when writing to a windows ExternalStream"
        buffer:= ExternalBytes unprotectedNew:bufferSize.
        freeBuffer := true.
    ] ifFalse:[
        buffer := self contentsSpecies new:bufferSize.
        freeBuffer := false.
    ].

    "read loop: read until end of stream"
    [
        |readCount|

        readCount := self nextAvailable:bufferSize into:buffer startingAt:1.
        readCount > 0 ifTrue:[
            |writeCount|

            writeCount := 0.
            "write loop: write until all is written"
            [
                |count|

                count := outStream
                            nextPutAll:readCount-writeCount
                            from:buffer
                            startingAt:writeCount+1.
                writeCount := writeCount + count.
                writeCount < readCount ifTrue:[
                    outStream writeWait.
                    true.
                ] ifFalse:[
                    false
                ].
            ] whileTrue.
            countWritten := countWritten + writeCount.
        ].
        "Note: atEnd will block if reading from an empty pipe or socket.
         avoid atEnd if possible, because it reads a single byte."
        readCount ~~ 0 or:[self atEnd not]
    ] whileTrue.

    freeBuffer ifTrue:[ buffer free ].
    ^ countWritten

    "
      'hello world' readStream copyToEndInto:'/tmp/mist' asFilename writeStream.
      'hello world' readStream copyToEndInto:#[] writeStream.
      ('/tmp/mist' asFilename readStream binary; yourself) copyToEndInto:#[] writeStream
      #[1 2 3 4 5 6 7] readStream copyToEndInto:'/tmp/mist' asFilename writeStream.
      #(1 2 3 a 'b' 6.4 true) readStream next; copyToEndInto:#() writeStream inspect.

    "
! !

!Stream methodsFor:'non homogenous reading'!

nextAvailableBytes:numBytes into:aCollection startingAt:initialIndex
    "for compatibility with ExternalStream"

    ^ self nextBytes:numBytes into:aCollection startingAt:initialIndex
!

nextByte
    "return the next byte of the stream
     - we do not know here how to do it, it should be redefined in subclass"

    ^ self next asInteger
!

nextBytes:count
    "read the next count bytes and return it as a byteArray.
     If EOF is encountered while reading, a truncated byteArray is returned. 
     If EOF is already reached before the first byte can be read,
     an error is raised."

    |data n|

    data := ByteArray uninitializedNew:count.
    n := self nextBytes:count into:data startingAt:1.
    n ~~ count ifTrue:[
        n == 0 ifTrue:[
            ^ self pastEndRead.
        ].
        data := data copyTo:n
    ].
    ^ data

    "Created: / 21.6.1997 / 11:18:57 / cg"
    "Modified: / 30.3.1998 / 18:04:58 / cg"
!

nextBytes:count into:anObject
    "read the next count bytes into an object and return the number of
     bytes read. On EOF, 0 is returned.
     If the receiver is some socket/pipe-like stream, an exception
     is raised if the connection is broken.

     The object must have non-pointer indexed instvars (i.e. it must be
     a ByteArray, String, Float- or DoubleArray).
     If anObject is a string or byteArray and reused, this provides the
     fastest possible physical I/O (since no new objects are allocated).

     Use with care - non object oriented i/o.
     Warning: in general, you cannot use this method to pass data from other
     architectures since it does not care for byte order or float representation."

    ^ self nextBytes:count into:anObject startingAt:1

    "Modified: 22.4.1997 / 10:41:39 / cg"
!

nextBytes:numBytes into:aCollection startingAt:initialIndex
    "return the next numBytes from the stream. If the end is
     reached before, only that many bytes are copyied into the
     collection.
     Returns the number of bytes that have been actually read.
     The receiver must support reading of binary bytes.

     Notice: this method is provided here for protocol completeness
             with externalStreams - it is normally not used with other
             streams."

    |n "{Class: SmallInteger }"|

    n := 0.

    [n ~= numBytes and:[self atEnd not]] whileTrue:[
        aCollection byteAt:initialIndex+n put:self nextByte.
        n := n + 1.
    ].
    ^ n

    "
     |s n buffer|

     buffer := ByteArray new:10.

     s := ReadStream on:#[1 2 3 4 5 6 7 8 9].
     s next:3.
     n := s nextBytes:9 into:buffer startingAt:1.
     Transcript showCR:('n = %1; buffer = <%2>' bindWith:n with:buffer)
    "

    "
     |s n buffer|

     buffer := String new:10.

     s := ReadStream on:'Hello World'.
     s next:6.
     n := s nextBytes:5 into:buffer startingAt:1.
     Transcript showCR:('n = %1; buffer = <%2>' bindWith:n with:buffer)
    "


    "Modified: 22.4.1997 / 10:43:08 / cg"
!

nextBytes:numBytes into:aCollection startingAt:initialIndex blockSize:blockSize
    "like nextBytes:into:startingAt:, but read in blocks of the given size.
     This leads to better beahvior when reading large chunks from a slow device,
     such as a cdrom drive (since a single unix-read is not interruptable)."

    |nR oR n|

    nR := numBytes.
    oR := initialIndex.
    [nR > 0] whileTrue:[
	n := nR.
	n > blockSize ifTrue:[n := blockSize].
	n := self nextBytes:n into:aCollection startingAt:oR.
	n == 0 ifTrue:[
	    ^ numBytes - nR
	].
	oR := oR + n.
	nR := nR - n
    ].
    ^ numBytes

    "Created: 24.4.1997 / 21:09:34 / cg"
    "Modified: 24.4.1997 / 21:19:50 / cg"
!

nextBytesInto:anObject
    "read bytes into an object, regardless of binary/text mode.
     The number of bytes to read is defined by the object's size.
     Return the number of bytes read. On EOF, 0 is returned.
     If the receiver is some socket/pipe-like stream, an exception
     is raised if the connection is broken.

     The object to read into must have non-pointer indexed instvars
     (i.e. it must be a ByteArray, String, Float- or DoubleArray).
     If anObject is a string or byteArray and reused, this provides the
     fastest possible physical I/O (since no new objects are allocated).

     Use with care - non object oriented i/o.
     Warning: in general, you cannot use this method to pass data from other
     architectures since it does not care for byte order or float representation."

    ^ self nextBytes:(anObject byteSize) into:anObject startingAt:1

    " to read 100 bytes from a stream:

     |b aStream|

     aStream := 'smalltalk.rc' asFilename readStream.
     b := ByteArray new:100.
     aStream nextBytesInto:b.
     aStream close.
     b inspect
    "

    "
     |s aStream|
     aStream := 'smalltalk.rc' asFilename readStream.
     s := String new:100.
     aStream nextBytesInto:s.
     aStream close.
     s inspect
    "

    "Modified: 22.4.1997 / 10:42:02 / cg"
    "Created: 22.4.1997 / 10:42:26 / cg"
!

nextIEEEDouble
    "read an 8-byte IEEE double precision float number in native byte order"

    ^ Float readBinaryIEEEDoubleFrom:self
!

nextIEEEDoubleMSB:msbFirst
    "read an 8-byte IEEE double precision float number"

    ^ Float readBinaryIEEEDoubleFrom:self MSB:msbFirst
!

nextIEEESingle
    "read a 4-byte IEEE single precision float number in native byte order"

    ^ ShortFloat readBinaryIEEESingleFrom:self
!

nextIEEESingleMSB:msbFirst
    "read a 4-byte IEEE single precision float number"

    ^ ShortFloat readBinaryIEEESingleFrom:self MSB:msbFirst
!

nextInt16MSB:msbFlag
    "return a signed short (2 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |b1 b2 uval "{ Class: SmallInteger }"|

    b1 := self nextByte.
    b2 := self nextByte.

    msbFlag ifTrue:[
        "most significant first"
        uval := b1 bitShift:8.
        uval := uval bitOr:b2.
    ] ifFalse:[
        "least significant first"
        uval := b2 bitShift:8.
        uval := uval bitOr:b1.
    ].
    "change from unsigned 0..FFFF to signed -8000..7FFF"
    uval >= 16r8000 ifTrue:[
        ^ uval - 16r10000
    ].
    ^ uval

    "Modified: 11.7.1996 / 10:07:04 / cg"
!

nextInt24MSB:msbFlag
    "return a signed 3 byte integer from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |uval "{ Class: SmallInteger }"|

    uval := self nextUnsignedInt24MSB:msbFlag.
    "change from unsigned 0..FFFFFF to signed -800000..7FFFFF"
    uval >= 16r800000 ifTrue:[
        ^ uval - 16r1000000
    ].
    ^ uval

    "
     ((ReadStream on:#[16r10 16r20 16rFF]) nextInt24MSB:true) hexPrintString
     ((ReadStream on:#[16rFF 16r20 16r30]) nextInt24MSB:false) hexPrintString

     ((ReadStream on:#[16rFF 16r20 16r30]) nextInt24MSB:true) hexPrintString
     ((ReadStream on:#[16r10 16r20 16rFF]) nextInt24MSB:false) hexPrintString
    "
!

nextInt32MSB:msbFlag
    "return a signed long (4 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |b1 b2 b3 b4 uval "{ Class: SmallInteger }" val|

    b1 := self nextByte.
    b2 := self nextByte.
    b3 := self nextByte.
    b4 := self nextByte.

    msbFlag ifTrue:[
        "most significant first"
        uval := (b1 bitShift:8) bitOr:b2.
        uval := (uval bitShift:8) bitOr:b3.
        val := (uval bitShift:8) bitOr:b4.
    ] ifFalse:[
        "least significant first"
        uval := (b4 bitShift:8) bitOr:b3.
        uval := (uval bitShift:8) bitOr:b2.
        val := (uval bitShift:8) bitOr:b1.
    ].
    "change from unsigned 0..FFFFFFFF to signed -80000000..7FFFFFFF"

    val >= 16r80000000 ifTrue:[
      ^ val - 16r100000000
    ].
    ^ val

    "
     |bytes s|

     bytes := #[16rFF 16rFF 16rFF 16rFF].
     s := bytes readStream.
     Transcript showCR:(s nextInt32MSB:true).
     s reset.
     Transcript showCR:(s nextInt32MSB:false).

     bytes := #[16r12 16r34 16r56 16r78].
     s := bytes readStream.
     Transcript showCR:(s nextInt32MSB:true).
     s reset.
     Transcript showCR:(s nextInt32MSB:false).

     bytes := #[16r89 16rab 16rcd 16ref].
     s := bytes readStream.
     Transcript showCR:(s nextInt32MSB:true).
     s reset.
     Transcript showCR:(s nextInt32MSB:false).
    "

    "Modified: / 14.1.1998 / 15:40:41 / cg"
!

nextInt64MSB:msbFlag
    "return a signed longlong (also called hyper) (8 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |uval|

    uval := self nextUnsignedInt64MSB:msbFlag.
    "change from unsigned 0..FF..FF to signed -80..00..7FF..FF"

    uval >= 16r8000000000000000 ifTrue:[
      ^ uval - 16r10000000000000000
    ].
    ^ uval

    "
     |bytes s|

     bytes := #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
     s := bytes readStream.
     Transcript showCR:(s nextInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextInt64MSB:false) hexPrintString.

     bytes := #[16r10 16r00 16r00 16r00 16r00 16r00 16r00 16r00].
     s := bytes readStream.
     Transcript showCR:(s nextInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextInt64MSB:false) hexPrintString.

     bytes := #[16r12 16r34 16r56 16r78 16r9a 16rbc 16rde 16rf0].
     s := bytes readStream.
     Transcript showCR:(s nextInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextInt64MSB:false) hexPrintString.

     bytes := #[16rFe 16rdc 16rba 16r98 16r76 16r54 16r32 16r10].
     s := bytes readStream.
     Transcript showCR:(s nextInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextInt64MSB:false) hexPrintString.
    "

    "Modified: / 14.1.1998 / 15:40:41 / cg"
!

nextSignedByte
    "return a signed byte (-128..127) from the stream.
     The receiver must support reading of binary bytes."

    |uval "{ Class: SmallInteger }"|

    uval := self nextByte.
    "change from unsigned 0..FF to signed -80..7F"
    uval >= 16r80 ifTrue:[
        ^ uval - 16r100
    ].
    ^ uval

    "
     #[16rFF 16r80 16r7F 16r01] readStream nextSignedByte
    "
!

nextString:count
    "read the next count bytes and return it as a string.
     If EOF is encountered while reading, a truncated string is returned.
     If EOF is already reached before the first byte can be read,
     an error is raised."

    |data n|

    data := String uninitializedNew:count.
    n := self nextBytes:count into:data startingAt:1.
    n ~~ count ifTrue:[
        n == 0 ifTrue:[
            ^ self pastEndRead.
        ].
        data := data copyTo:n
    ].
    ^ data
!

nextUnsigned:numBytes MSB:msbFlag
    "return a numBytes-sized unsigned (numBytes bytes) from the stream as an Integer.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |val shift bytes|

    "claus: this method is central in binaryStorage -
     therefore it has been tuned a bit (and needs even more tuning)"

    numBytes == 1 ifTrue:[
        ^ self nextByte
    ].
    numBytes == 2 ifTrue:[
        ^ self nextUnsignedInt16MSB:msbFlag
    ].
    numBytes == 3 ifTrue:[
        ^ self nextUnsignedInt24MSB:msbFlag.
    ].
    numBytes == 4 ifTrue:[
        ^ self nextUnsignedInt32MSB:msbFlag
    ].
    numBytes == 8 ifTrue:[
        ^ self nextUnsignedInt64MSB:msbFlag
    ].
    "/ bytes
    bytes := self nextBytes:numBytes.
    ^ (LargeInteger digitBytes:bytes MSB:msbFlag) compressed

"/    val := 0.
"/    msbFlag ifTrue:[
"/        numBytes timesRepeat:[
"/            val := (val bitShift:8) + self nextByte
"/        ].
"/    ] ifFalse:[
"/        shift := 0.
"/        numBytes timesRepeat:[
"/            val := val + (self nextByte bitShift:shift).
"/            shift := shift + 8.
"/        ].
"/    ].
"/    ^ val

    "
     |s|

     s := #[ 16r01 16r02 16r03 16r04 16r05 ] readStream.
     (s nextUnsigned:3 MSB:true) hexPrintString.
     s := #[ 16r01 16r02 16r03 16r04 16r05 16r06 16r07 16r08 16r09 ] readStream.
     (s nextUnsigned:9 MSB:true) hexPrintString.

     s := #[ 16r01 16r02 16r03 16r04 16r05 ] readStream.
     (s nextUnsigned:3 MSB:false) hexPrintString.
     s := #[ 16r01 16r02 16r03 16r04 16r05 16r06 16r07 16r08 16r09 ] readStream.
     (s nextUnsigned:9 MSB:false) hexPrintString.
    "
!

nextUnsignedInt16MSB:msbFlag
    "return an unsigned short (2 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |b1 b2 uval "{ Class: SmallInteger }"|

    b1 := self nextByte.
    b2 := self nextByte.

    msbFlag ifTrue:[
        "most significant first"
        uval := b1 bitShift:8.
        uval := uval bitOr:b2.
    ] ifFalse:[
        "least significant first"
        uval := b2 bitShift:8.
        uval := uval bitOr:b1.
    ].

    ^ uval

    "
     ((ReadStream on:#[16r10 16r20 16r30]) nextUnsignedInt16MSB:true) hexPrintString
     ((ReadStream on:#[16r10 16r20 16r30]) nextUnsignedInt16MSB:false) hexPrintString
    "

    "Modified: 11.7.1996 / 10:07:20 / cg"
!

nextUnsignedInt24MSB:msbFlag
    "return an unsigned 3 byte integer from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |b1 b2 b3 bL bM bH|

    b1 := self nextByte.
    b2 := self nextByte.
    b3 := self nextByte.

    msbFlag ifTrue:[
        bH := b1.
        bM := b2.
        bL := b3.
    ] ifFalse:[
        bH := b3.
        bM := b2.
        bL := b1.
    ].
    ^ (((bH bitShift:8) bitOr:bM) bitShift:8) bitOr:bL

    "
     ((ReadStream on:#[16r10 16r20 16r30]) nextUnsignedInt24MSB:true) hexPrintString
     ((ReadStream on:#[16r10 16r20 16r30]) nextUnsignedInt24MSB:false) hexPrintString
    "
!

nextUnsignedInt32MSB:msbFlag
    "return an unsigned long (4 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |b1 b2 b3 b4 uval "{ Class: SmallInteger }" val|

    b1 := self nextByte.
    b2 := self nextByte.
    b3 := self nextByte.
    b4 := self nextByte.

    msbFlag ifTrue:[
        "most significant first"
        uval := (b1 bitShift:8) bitOr:b2.
        uval := (uval bitShift:8) bitOr:b3.
        val := (uval bitShift:8) bitOr:b4.
    ] ifFalse:[
        "least significant first"
        uval := (b4 bitShift:8) bitOr:b3.
        uval := (uval bitShift:8) bitOr:b2.
        val := (uval bitShift:8) bitOr:b1.
    ].

    ^ val
!

nextUnsignedInt64MSB:msbFlag
    "return an unsigned longlong (also called hyper) (8 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |bytes uval t|

    bytes := self nextBytes:8.
    uval := 0.

    msbFlag ifTrue:[
        "most significant first"
        1 to:8 do:[:i |
            t := (uval bitShift:8).
            uval := t bitOr:(bytes at:i).
        ].
    ] ifFalse:[
        "least significant first"
        8 to:1 by:-1 do:[:i |
            t := (uval bitShift:8).
            uval := t bitOr:(bytes at:i).
        ].
    ].
    ^ uval

    "
     |bytes s|

     bytes := #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedInt64MSB:false) hexPrintString.

     bytes := #[16r10 16r00 16r00 16r00 16r00 16r00 16r00 16r00].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedInt64MSB:false) hexPrintString.

     bytes := #[16r12 16r34 16r56 16r78 16r9a 16rbc 16rde 16rf0].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedInt64MSB:false) hexPrintString.

     bytes := #[16rFe 16rdc 16rba 16r98 16r76 16r54 16r32 16r10].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedInt64MSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedInt64MSB:false) hexPrintString.
    "

    "Modified: / 14.1.1998 / 15:40:41 / cg"
! !

!Stream methodsFor:'non homogenous reading - aliases'!

nextInt16LSB
    "return a signed short (2 bytes) in LSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextInt16MSB:false
!

nextInt16MSB
    "return a signed short (2 bytes) in MSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextInt16MSB:true
!

nextInt16Net
    "return a signed short (2 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextInt16MSB:true

    "Created: 10.1.1996 / 19:49:41 / cg"
!

nextInt32LSB
    "return a signed long (4 bytes) in LSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextInt32MSB:false
!

nextInt32MSB
    "return a signed long (4 bytes) in MSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextInt32MSB:true
!

nextInt32Net
    "return a signed long (4 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextInt32MSB:true

    "Created: 10.1.1996 / 19:49:28 / cg"
!

nextInt64LSB
    "return a signed longlong (also called hyper) (8 bytes) in LSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextInt64MSB:false
!

nextInt64MSB
    "return a signed longlong (also called hyper) (8 bytes) in MSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextInt64MSB:true
!

nextInt64Net
    "return a signed longlong (also called hyper) (8 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextInt64MSB:true
!

nextNumber:numBytes
    "Return the next n bytes as a positive Integer;
     bytes are taken msb-first."

    ^ self nextUnsigned:numBytes MSB:true
!

nextUnsignedInt16LSB
    "return an unsigned short (2 bytes) in LSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextUnsignedInt16MSB:false
!

nextUnsignedInt16MSB
    "return an unsigned short (2 bytes) in MSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextUnsignedInt16MSB:true
!

nextUnsignedInt16Net
    "return an unsigned short (2 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextUnsignedInt16MSB:true

    "Created: 10.1.1996 / 19:50:02 / cg"
!

nextUnsignedInt32LSB
    "return an unsigned long (4 bytes) in LSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextUnsignedInt32MSB:false
!

nextUnsignedInt32MSB
    "return an unsigned long (4 bytes) in MSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextUnsignedInt32MSB:true
!

nextUnsignedInt32Net
    "return an unsigned long (4 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextUnsignedInt32MSB:true

    "Created: 10.1.1996 / 19:49:02 / cg"
    "Modified: 10.1.1996 / 19:49:50 / cg"
!

nextUnsignedInt64LSB
    "return an unsigned longlong (also called hyper) (8 bytes) in LSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextUnsignedInt64MSB:false
!

nextUnsignedInt64MSB
    "return an unsigned longlong (also called hyper) (8 bytes) in MSB-first order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextUnsignedInt64MSB:true
!

nextUnsignedInt64Net
    "return an unsigned longlong (also called hyper) (8 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextUnsignedInt64MSB:true
! !

!Stream methodsFor:'non homogenous reading - obsolete'!

nextHyperMSB:msbFlag
    <resource: #obsolete>
    "return a signed hyper (8 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextInt64MSB:msbFlag

    "
     |bytes s|

     bytes := #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
     s := bytes readStream.
     Transcript showCR:(s nextHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextHyperMSB:false) hexPrintString.

     bytes := #[16r10 16r00 16r00 16r00 16r00 16r00 16r00 16r00].
     s := bytes readStream.
     Transcript showCR:(s nextHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextHyperMSB:false) hexPrintString.

     bytes := #[16r12 16r34 16r56 16r78 16r9a 16rbc 16rde 16rf0].
     s := bytes readStream.
     Transcript showCR:(s nextHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextHyperMSB:false) hexPrintString.

     bytes := #[16rFe 16rdc 16rba 16r98 16r76 16r54 16r32 16r10].
     s := bytes readStream.
     Transcript showCR:(s nextHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextHyperMSB:false) hexPrintString.
    "

    "Modified: / 14.1.1998 / 15:40:41 / cg"
!

nextLong
    <resource: #obsolete>
    "Read four bytes (msb-first) and return the value as a 32-bit signed Integer.
     The returned value may be a LargeInteger.
     (msb-first for compatibility with other smalltalks)"

    ^ self nextInt32MSB:true
!

nextLongMSB:msbFlag
    <resource: #obsolete>
    "return a signed long (4 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextInt32MSB:msbFlag

    "
     |bytes s|

     bytes := #[16rFF 16rFF 16rFF 16rFF].
     s := bytes readStream.
     Transcript showCR:(s nextLongMSB:true).
     s reset.
     Transcript showCR:(s nextLongMSB:false).

     bytes := #[16r12 16r34 16r56 16r78].
     s := bytes readStream.
     Transcript showCR:(s nextLongMSB:true).
     s reset.
     Transcript showCR:(s nextLongMSB:false).

     bytes := #[16r89 16rab 16rcd 16ref].
     s := bytes readStream.
     Transcript showCR:(s nextLongMSB:true).
     s reset.
     Transcript showCR:(s nextLongMSB:false).
    "

    "Modified: / 14.1.1998 / 15:40:41 / cg"
!

nextLongNet
    <resource: #obsolete>
    "return a signed long (4 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextInt32MSB:true

    "Created: 10.1.1996 / 19:49:28 / cg"
!

nextShortMSB:msbFlag
    <resource: #obsolete>
    "return a signed short (2 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextInt16MSB:msbFlag

    "Modified: 11.7.1996 / 10:07:04 / cg"
!

nextShortNet
    <resource: #obsolete>
    "return a signed short (2 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB per definition"

    ^ self nextInt16MSB:true

    "Created: 10.1.1996 / 19:49:41 / cg"
!

nextUnsignedHyperMSB:msbFlag
    <resource: #obsolete>
    "return an unsigned hyper (8 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextUnsignedInt64MSB:msbFlag

    "
     |bytes s|

     bytes := #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedHyperMSB:false) hexPrintString.

     bytes := #[16r10 16r00 16r00 16r00 16r00 16r00 16r00 16r00].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedHyperMSB:false) hexPrintString.

     bytes := #[16r12 16r34 16r56 16r78 16r9a 16rbc 16rde 16rf0].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedHyperMSB:false) hexPrintString.

     bytes := #[16rFe 16rdc 16rba 16r98 16r76 16r54 16r32 16r10].
     s := bytes readStream.
     Transcript showCR:(s nextUnsignedHyperMSB:true) hexPrintString.
     s reset.
     Transcript showCR:(s nextUnsignedHyperMSB:false) hexPrintString.
    "

    "Modified: / 14.1.1998 / 15:40:41 / cg"
!

nextUnsignedLongMSB:msbFlag
    <resource: #obsolete>
    "return an unsigned long (4 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextUnsignedInt32MSB:msbFlag

    "Modified: 11.7.1996 / 10:07:13 / cg"
!

nextUnsignedLongNet
    <resource: #obsolete>
    "return an unsigned long (4 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes."

    ^ self nextUnsignedInt32MSB:true

    "Created: 10.1.1996 / 19:49:02 / cg"
    "Modified: 10.1.1996 / 19:49:50 / cg"
!

nextUnsignedShortMSB:msbFlag
    <resource: #obsolete>
    "return an unsigned short (2 bytes) from the stream.
     The receiver must support reading of binary bytes.

     The msbFlag argument controls if the integer is to be read with
     most-significant-byte-first (true) or least-first (false).
     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextUnsignedInt16MSB:msbFlag

    "Modified: 11.7.1996 / 10:07:20 / cg"
!

nextUnsignedShortNet
    <resource: #obsolete>
    "return an unsigned short (2 bytes) in network byte order from the stream.
     The receiver must support reading of binary bytes.
     Network byte order is MSB per definition"

    ^ self nextUnsignedInt16MSB:true

    "Created: 10.1.1996 / 19:50:02 / cg"
! !

!Stream methodsFor:'non homogenous writing'!

next:count putByte:aByteValue
    "write a byte n times"

    |n "{ Class: SmallInteger }"|

    n := count.
    n timesRepeat:[self nextPutByte:aByteValue].

    "
     |s|
     s := ByteArray new writeStream.
     s nextPutByte:1.
     s next:10 putByte:99.
     s nextPutByte:2.
     s contents
    "
!

nextNumber:n put:v
    "Append to the receiver the argument, v, which is a positive Integer,
     as the next n bytes. Bytes are written msb first.
     Possibly pad with leading zeros.
     The receiver must support writing of binary bytes."

    self nextNumber:n put:v MSB:true
!

nextNumber:n put:v MSB:msb
    "Append to the receiver the argument, v, which is a positive Integer,
     as the next n bytes.
     Bytes are written in the specified byte order.
     Possibly pad with leading zeros (trailing zeros, if lsb).
     The receiver must support writing of binary bytes."

    |vlen "{ Class: SmallInteger }"
     i    "{ Class: SmallInteger }"
     bl bm bh bml bmh|

    "claus: this method is central in binaryStorage -
     therefore it has been tuned a bit (and needs even more tuning)"

    v class == SmallInteger ifTrue:[  "- this is a hint to stc"
        n == 1 ifTrue:[
            (v between:0 and:16rFF) ifTrue:[
                self nextPutByte:v.
                ^ self
            ].
        ].
        n == 2 ifTrue:[
            (v between:0 and:16rFFFF) ifTrue:[
                bl := (v bitAnd:16rFF).
                bh := (v bitShift:-8) bitAnd:16rFF.
                msb ifTrue:[
                    self nextPutByte:bh; nextPutByte:bl.
                ] ifFalse:[
                    self nextPutByte:bl; nextPutByte:bh.
                ].
                ^ self
            ].
        ].
        n == 3 ifTrue:[
            (v between:0 and:16rFFFFFF) ifTrue:[
                bl := (v bitAnd:16rFF).
                bm := (v bitShift:-8) bitAnd:16rFF.
                bh := (v bitShift:-16) bitAnd:16rFF.
                msb ifTrue:[
                    self nextPutByte:bh.
                    self nextPutByte:bm.
                    self nextPutByte:bl.
                ] ifFalse:[
                    self nextPutByte:bl.
                    self nextPutByte:bm.
                    self nextPutByte:bh.
                ].
                ^ self
            ].
        ].
        n == 4 ifTrue:[
            (v between:0 and:16rFFFFFFFF) ifTrue:[
                bl := (v bitAnd:16rFF).
                bml := (v bitShift:-8) bitAnd:16rFF.
                bmh := (v bitShift:-16) bitAnd:16rFF.
                bh := (v bitShift:-24) bitAnd:16rFF.
                msb ifTrue:[
                    self nextPutByte:bh.
                    self nextPutByte:bmh.
                    self nextPutByte:bml.
                    self nextPutByte:bl.
                ] ifFalse:[
                    self nextPutByte:bl.
                    self nextPutByte:bml.
                    self nextPutByte:bmh.
                    self nextPutByte:bh.
                ].
                ^ self
            ].
        ].
    ].

    "
     arbitrary long
    "
    n < (vlen := v digitLength) ifTrue: [
        "
         the number is too big to be repesented in n bytes
        "
        self error:'number too big'
    ].

    msb ifTrue:[
        "pad with leading zeros"
        i := n.
        [i > vlen] whileTrue:[
            self nextPutByte:0.
            i := i - 1
        ].

        i == 1 ifTrue:[
            ^ self nextPutByte:v
        ].

        [i > 0] whileTrue:[
            self nextPutByte:(v digitAt:i).
            i := i - 1
        ]
    ] ifFalse:[
        1 to:vlen do:[:idx |
            self nextPutByte:(v digitAt:idx).
        ].
        "pad with trailing zeros"
        vlen+1 to:n do:[:idx |
            self nextPutByte:0.
        ].
    ].

    "Modified: / 22-06-2006 / 11:31:13 / fm"
!

nextPutAllUtf16:aString
    "write a string as UTF-16 characters.
     Notice: this writes characters - not bytes.
     The underlying stream must be a stream which can deal with characters,
     eg. OrderedCollectionStream, TwoByteCharacterStream, etc.
     Also notice, that characters above 16rFFFF are escaped according UTF16 sepcifications."

    |sz "{Class: SmallInteger}"|

    sz := aString size.
    1 to:sz do:[:idx|
        self nextPutUtf16:(aString at:idx).
    ].
!

nextPutAllUtf16Bytes:aString MSB:msb
    "write a string as UTF-16 bytes - no 0-word is written.
     The underlying stream must support writing of bytes"

    |sz "{Class: SmallInteger}"|

    sz := aString size.
    1 to:sz do:[:idx|
        self nextPutUtf16Bytes:(aString at:idx) MSB:msb.
    ].

    "
        (#[] writeStream
            nextPutAllUtf16Bytes:'BÄxxx' MSB:true;
            nextPutUtf16:(Character codePoint:16r10CCCC) MSB:true;
            contents)
   "
!

nextPutAllUtf8:aString
    "normal streams can not handle multi-byte characters, so convert them to utf8"

    |sz "{Class: SmallInteger}"|

    sz := aString size.
    1 to:sz do:[:idx|
        self nextPutUtf8:(aString at:idx).
    ].
!

nextPutByte:aByteValue
    "write a byte.
     Same as nextPut: here; for protocol compatibility with externalStream."

    self nextPut:aByteValue

    "Created: / 22-04-1997 / 10:43:55 / cg"
    "Modified: / 23-06-2006 / 12:19:47 / fm"
!

nextPutBytes:anObject
    "write bytes from an object; the number of bytes is defined by
     the object's size.
     Return the number of bytes written or nil on error.
     The object must have non-pointer indexed instvars
     (i.e. be a ByteArray, String, Float- or DoubleArray).
     Use with care - non object oriented i/o.
     Warning: in general, you cannot use this method to pass non-byte data to other
     architectures since it does not care for byte order or float representation."

    ^ self nextPutBytes:(anObject size) from:anObject startingAt:1

    "Created: 22.4.1997 / 10:44:18 / cg"
!

nextPutBytes:count from:anObject
    "write count bytes from an object.
     Return the number of bytes written or nil on error.
     The object must have non-pointer indexed instvars
     (i.e. be a ByteArray, String, Float- or DoubleArray).
     Use with care - non object oriented i/o.
     Warning: in general, you cannot use this method to pass non-byte data to other
     architectures since it does not care for byte order or float representation."

    ^ self nextPutBytes:count from:anObject startingAt:1

    "Created: 22.4.1997 / 10:43:59 / cg"
!

nextPutBytes:count from:anObject startingAt:start
    "write count bytes from an object starting at index start.
     Return the number of bytes written.
     The object must have non-pointer indexed instvars 
     (i.e. be a ByteArray, String, Float- or DoubleArray).     
     Use with care - non object oriented i/o.
     This is provided for compatibility with externalStream;
     to support binary storage"

    |idx|

    idx := start.
    self isBinary ifTrue:[
        1 to:count do:[:i |
            self nextPutByte:(anObject byteAt:idx).
            idx := idx + 1
        ].
    ] ifFalse:[
        1 to:count do:[:i |
            self nextPut:(anObject at:idx).
            idx := idx + 1
        ].
    ].    
    ^ count

    "Created: 22.4.1997 / 10:44:09 / cg"
!

nextPutBytesFrom:anObject
    "write bytes from an object; the number of bytes is defined by the object's size.
     Return the number of bytes written or nil on error.
     The object must have non-pointer indexed instvars 
     (i.e. be a ByteArray, String, Float- or DoubleArray).     
     Use with care - non object oriented i/o.
     Warning: in general, you cannot use this method to pass non-byte data to other 
     architectures since it does not care for byte order or float representation."

    ^ self nextPutBytes:(anObject size) from:anObject startingAt:1

    "Created: 22.4.1997 / 10:44:18 / cg"
!

nextPutIEEEDouble:aFloat
    "write an 8-byte IEEE double precision float number"

    Float storeBinaryIEEEDouble:aFloat on:self MSB:(UninterpretedBytes isBigEndian)
!

nextPutIEEEDouble:aFloat MSB:msb
    "write an 8-byte IEEE double precision float number"

    Float storeBinaryIEEEDouble:aFloat on:self MSB:msb
!

nextPutIEEESingle:aFloat
    "write a 4-byte IEEE single precision float number"

    ShortFloat storeBinaryIEEESingle:aFloat on:self MSB:(UninterpretedBytes isBigEndian).
!

nextPutIEEESingle:aFloat MSB:msb
    "write a 4-byte IEEE single precision float number"

    ShortFloat storeBinaryIEEESingle:aFloat on:self MSB:msb.
!

nextPutInt16:anIntegerOrCharacter MSB:msbFlag
    "Write the argument, anIntegerOrCharacter as a short (two bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.

     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |iNum "{ Class: SmallInteger }" hi lo b1 b2|

    iNum := anIntegerOrCharacter asInteger.
    lo := iNum digitByteAt:1.
    hi := iNum digitByteAt:2.
    msbFlag ifTrue:[
        "high word first"
        b1 := hi.
        b2 := lo.
    ] ifFalse:[
        "low word first"
        b1 := lo.
        b2 := hi.
    ].
    self nextPutByte:b1.
    self nextPutByte:b2.

    "
     |s|

     s := #[] writeStream.
     s nextPutInt16:16r1234 MSB:false.
     s contents.
    "
    "
     |s|

     s := #[] writeStream.
     s nextPutInt16:16r1234 MSB:true.
     s contents.
    "

    "Modified: / 22-06-2006 / 11:30:26 / fm"
!

nextPutInt16LSB:aNumber
    "Write the argument, aNumber as a short (two bytes) in LSB-first order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes."

    ^ self nextPutInt16:aNumber MSB:false.
!

nextPutInt16MSB:aNumber
    "Write the argument, aNumber as a short (two bytes) in MSB-first order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes."

    ^ self nextPutInt16:aNumber MSB:true.
!

nextPutInt16Net:aNumber
    "Write the argument, aNumber as a short (two bytes) in the network byte order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextPutInt16:aNumber MSB:true.

    "Created: 10.1.1996 / 19:50:33 / cg"
!

nextPutInt32:aNumber MSB:msbFlag
    "Write the argument, aNumber as a long (four bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.

     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    |hh hl lh ll b1 b2 b3 b4|

    ll := aNumber digitByteAt:1.
    lh := aNumber digitByteAt:2.
    hl := aNumber digitByteAt:3.
    hh := aNumber digitByteAt:4.
    msbFlag ifTrue:[
        "high byte first"
        b1 := hh.
        b2 := hl.
        b3 := lh.
        b4 := ll.
    ] ifFalse:[
        "low word first"
        b1 := ll.
        b2 := lh.
        b3 := hl.
        b4 := hh.
    ].
    self nextPutByte:b1.
    self nextPutByte:b2.
    self nextPutByte:b3.
    self nextPutByte:b4.

    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt32:16r12345678 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextInt32MSB:false) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt32:16r12345678 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextInt32MSB:true) hexPrintString.
.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt32:16r-80000000 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextInt32MSB:true) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt32:16r-80000000 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextInt32MSB:false) hexPrintString.
    "

    "Modified: / 01-11-1997 / 18:30:52 / cg"
    "Modified: / 22-06-2006 / 11:31:43 / fm"
!

nextPutInt32LSB:aNumber
    "Write the argument, aNumber as a long (4 bytes) in LSB-first order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes."

    ^ self nextPutInt32:aNumber MSB:false.
!

nextPutInt32MSB:aNumber
    "Write the argument, aNumber as a long (4 bytes) in MSB-first order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes."

    ^ self nextPutInt32:aNumber MSB:true.
!

nextPutInt32Net:aNumber
    "Write the argument, aNumber as a long (four bytes) in the network byte order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextPutInt32:aNumber MSB:true
!

nextPutInt64:aNumber MSB:msbFlag
    "Write the argument, aNumber as a longlong (8 bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.

     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    msbFlag ifTrue:[
        1 to:8 do:[:i |
            self nextPutByte:(aNumber digitByteAt:8+1-i)
        ].
    ] ifFalse:[
        1 to:8 do:[:i |
            self nextPutByte:(aNumber digitByteAt:i)
        ].
    ].

    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt64:16r123456789abcdef0 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextUInt64MSB:false) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt64:16r123456789abcdef0 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextUInt64MSB:true) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt64:16r-8000000000000000 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextUInt64MSB:true) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutInt64:16r-8000000000000000 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextUInt64MSB:false) hexPrintString.
    "

    "Modified: / 01-11-1997 / 18:30:52 / cg"
    "Modified: / 22-06-2006 / 11:31:37 / fm"
!

nextPutInt64LSB:aNumber
    "Write the argument, aNumber as a longlong (8 bytes) in LSB-first order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes."

    ^ self nextPutInt64:aNumber MSB:false.
!

nextPutInt64MSB:aNumber
    "Write the argument, aNumber as a longlong (8 bytes) in MSB-first order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes."

    ^ self nextPutInt64:aNumber MSB:true.
!

nextPutInt64Net:aNumber
    "Write the argument, aNumber as a longlong (8 bytes) in the network byte order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.
     Network byte order is MSB-first per definition"

    ^ self nextPutInt64:aNumber MSB:true
!

nextPutUtf16:aCharacter
    "append my UTF-16 representation to the argument, aStream.
     Notice: this writes characters - not bytes.
     The underlying stream must be a stream which can deal with characters,
     eg. OrderedCollectionStream, TwoByteCharacterStream, etc.
     Also notice, that characters above 16rFFFF are escaped according UTF16 specifications."

    |codePoint "{Class: SmallInteger}"|

    codePoint := aCharacter codePoint.
    (codePoint <= 16rD7FF or:[codePoint between:16rE000 and:16rFFFF]) 
        ifTrue:[
            self nextPut:aCharacter.
        ] 
        ifFalse:[
            codePoint <= 16r10FFFF ifTrue:[
                |highBits lowBits|

                codePoint := codePoint - 16r100000.
                highBits := codePoint bitShift:-10.
                lowBits := codePoint bitAnd:16r3FF.
                self nextPut:(Character codePoint:highBits+16rD800).
                self nextPut:(Character codePoint:lowBits+16rDC00).
            ] ifFalse:[
                EncodingError raiseWith:aCharacter errorString:'Character cannot be encoded as UTF-16'.
            ]
        ].

    "
        ((WriteStream on:Unicode16String new)
            nextPutUtf16:$B;
            nextPutUtf16:$Ä; 
            nextPutUtf16:(Character codePoint:16r10CCCC)
            yourself) contents
    "
!

nextPutUtf16Bytes:aCharacter MSB:msb
    "append my UTF-16 representation to the argument, aStream.
     UTF-16 can encode only characters with code points between 0 to 16r10FFFF.
     The underlying stream must support writing of bytes."

    |codePoint "{ Class: SmallInteger }"|

    codePoint := aCharacter codePoint.
    (codePoint <= 16rD7FF or:[ codePoint between:16rE000 and:16rFFFF ])
        ifTrue:[ 
            self nextPutInt16:codePoint MSB:msb. 
        ]
        ifFalse:[
            codePoint <= 16r10FFFF ifTrue:[
                |highBits lowBits|

                codePoint := codePoint - 16r100000.
                highBits := codePoint bitShift:-10.
                lowBits := codePoint bitAnd:16r3FF.
                self nextPutInt16:(highBits + 16rD800) MSB:msb.
                self nextPutInt16:(lowBits + 16rDC00) MSB:msb.
            ] ifFalse:[
                EncodingError raiseWith:aCharacter
                    errorString:'Character cannot be encoded as UTF-16'.
            ]
        ].

    "
        (#[] writeStream
            nextPutUtf16:$B MSB:true;
            nextPutUtf16:$Ä MSB:true;
            nextPutUtf16:(Character codePoint:16r10CCCC) MSB:true;
            contents)

        (FileStream newTemporary
            nextPutUtf16:$B MSB:false;
            nextPutUtf16:$Ä MSB:false;
            nextPutUtf16:(Character codePoint:16r10CCCC) MSB:false;
            reset;
            binary;
            contents)"
!

nextPutUtf8:aCharacter
    "append my UTF-8 representation to the argument, aStream.
     The underlying stream must be a stream which can deal with characters.
     Up to 31 bits can be encoded in up to 6 bytes.
     However, currently, characters are limited to 31 bits."

    |codePoint "{Class: SmallInteger}"
     v "{Class: SmallInteger}"
     b1 b2 b3 b4 b5|

    codePoint := aCharacter codePoint.

    codePoint <= 16r7F ifTrue:[
        "/ 7 bits - 1 byte    
        self nextPut:aCharacter.
        ^ self.
    ].
    codePoint <= 16r7FF ifTrue:[
        "/ 11 bits - 2 byte sequence 5+6   
        self 
            nextPut:(Character value:(((codePoint bitShift:-6) bitAnd:16r1F) bitOr:16rC0));
            nextPut:(Character value:((codePoint bitAnd:16r3F) bitOr:16r80)).
        ^ self.
    ].
    codePoint <= 16rFFFF ifTrue:[
        "/ 16 bits - 3 byte sequence 4+6+6  
        self 
            nextPut:(Character value:(((codePoint bitShift:-12) bitAnd:16r0F) bitOr:16rE0));
            nextPut:(Character value:(((codePoint bitShift:-6) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:((codePoint bitAnd:16r3F) bitOr:16r80)).
        ^ self.
    ].
    codePoint <= 16r1FFFFF ifTrue:[
        "/ 21 bits - 4 byte sequence 3+6+6+6  
        self 
            nextPut:(Character value:(((codePoint bitShift:-18) bitAnd:16r07) bitOr:16rF0));
            nextPut:(Character value:(((codePoint bitShift:-12) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:(((codePoint bitShift:-6) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:((codePoint bitAnd:16r3F) bitOr:16r80)).
        ^ self.
    ].
    codePoint <= 16r1FFFFF ifTrue:[
        "/ 26 bits - 5 byte sequence 2+6+6+6+6  
        self 
            nextPut:(Character value:(((codePoint bitShift:-24) bitAnd:16r03) bitOr:16rF8));
            nextPut:(Character value:(((codePoint bitShift:-18) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:(((codePoint bitShift:-12) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:(((codePoint bitShift:-6) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:((codePoint bitAnd:16r3F) bitOr:16r80)).
        ^ self.
    ].
    codePoint <= 16r3FFFFFF ifTrue:[
        "/ 31 bits - 6 byte sequence 1+6+6+6+6+6  
        self 
            nextPut:(Character value:(((codePoint bitShift:-30) bitAnd:16r01) bitOr:16rFC));
            nextPut:(Character value:(((codePoint bitShift:-24) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:(((codePoint bitShift:-18) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:(((codePoint bitShift:-12) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:(((codePoint bitShift:-6) bitAnd:16r3F) bitOr:16r80));
            nextPut:(Character value:((codePoint bitAnd:16r3F) bitOr:16r80)).
        ^ self.
    ].

"/    b1 := Character codePoint:((codePoint bitAnd:16r3F) bitOr:2r10000000).
"/    v := codePoint bitShift:-6.
"/    v <= 16r1F ifTrue:[
"/        self nextPut:(Character value:(v bitOr:2r11000000)).
"/        self nextPut:b1.
"/        ^ self.
"/    ].
"/    b2 := Character codePoint:((v bitAnd:16r3F) bitOr:2r10000000).
"/    v := v bitShift:-6.
"/    v <= 16r0F ifTrue:[
"/        self nextPut:(Character value:(v bitOr:2r11100000)).
"/        self nextPut:b2; nextPut:b1.
"/        ^ self.
"/    ].
"/    b3 := Character codePoint:((v bitAnd:16r3F) bitOr:2r10000000).
"/    v := v bitShift:-6.
"/    v <= 16r07 ifTrue:[
"/        self nextPut:(Character value:(v bitOr:2r11110000)).
"/        self nextPut:b3; nextPut:b2; nextPut:b1.
"/        ^ self.
"/    ].
"/    b4 := Character codePoint:((v bitAnd:16r3F) bitOr:2r10000000).
"/    v := v bitShift:-6.
"/    v <= 16r03 ifTrue:[
"/        self nextPut:(Character value:(v bitOr:2r11111000)).
"/        self nextPut:b4; nextPut:b3; nextPut:b2; nextPut:b1.
"/        ^ self.
"/    ].
"/    b5 := Character codePoint:((v bitAnd:16r3F) bitOr:2r10000000).
"/    v := v bitShift:-6.
"/    v <= 16r01 ifTrue:[
"/        self nextPut:(Character value:(v bitOr:2r11111100)).
"/        self nextPut:b5; nextPut:b4; nextPut:b3; nextPut:b2; nextPut:b1.
"/        ^ self.
"/    ].

    EncodingError raiseWith:aCharacter errorString:'codePoint > 31bit in #nextPutUtf8:'.

    "
      (String streamContents:[:s|
            s nextPutUtf8:$a.
            s nextPutUtf8:$ü.
            s nextPutUtf8: (Character value:16r1fff).
            s nextPutUtf8: (Character value:16rffff).
            s nextPutUtf8: (Character value:16r1ffffff).
            s nextPutUtf8: (Character value:16r800).
      ])
            asByteArray

    "
! !

!Stream methodsFor:'non homogenous writing - obsolete'!

nextPutHyper:aNumber MSB:msbFlag
    <resource: #obsolete>
    "Write the argument, aNumber as a hyper (8 bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.

     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextPutInt64:aNumber MSB:msbFlag

    "
     |s bytes|

     s := #[] writeStream.
     s nextPutHyper:16r123456789abcdef0 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextHyperMSB:false) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutHyper:16r123456789abcdef0 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextHyperMSB:true) hexPrintString.
.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutHyper:16r-8000000000000000 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextHyperMSB:true) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutHyper:16r-8000000000000000 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextHyperMSB:false) hexPrintString.
    "

    "Modified: / 01-11-1997 / 18:30:52 / cg"
    "Modified: / 22-06-2006 / 11:31:37 / fm"
!

nextPutLong:aNumber MSB:msbFlag
    <resource: #obsolete>
    "Write the argument, aNumber as a long (four bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.

     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextPutInt32:aNumber MSB:msbFlag

    "
     |s bytes|

     s := #[] writeStream.
     s nextPutLong:16r12345678 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextLongMSB:false) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutLong:16r12345678 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextLongMSB:true) hexPrintString.
.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutLong:16r-80000000 MSB:true.
     bytes := s contents.
     s := bytes readStream.
     (s nextLongMSB:true) hexPrintString.
    "
    "
     |s bytes|

     s := #[] writeStream.
     s nextPutLong:16r-80000000 MSB:false.
     bytes := s contents.
     s := bytes readStream.
     (s nextLongMSB:false) hexPrintString.
    "

    "Modified: / 01-11-1997 / 18:30:52 / cg"
    "Modified: / 22-06-2006 / 11:31:43 / fm"
!

nextPutLongNet:aNumber
    <resource: #obsolete>
    "Write the argument, aNumber as a long (four bytes) in the network byte order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes."

    ^ self nextPutInt32:aNumber MSB:true

    "Modified: 10.1.1996 / 19:47:10 / cg"
    "Created: 10.1.1996 / 19:50:23 / cg"
!

nextPutShort:anIntegerOrCharacter MSB:msbFlag
    <resource: #obsolete>
    "Write the argument, anIntegerOrCharacter as a short (two bytes).
     If msbFlag is true, data is written most-significant byte first;
     otherwise least first.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.

     This interface is provided to allow talking to external programs,
     where it's known that the byte order is some definite one.
     If you don't care (i.e. talk to other smalltalks) or you can control the
     order, please use the corresponding xxxNet methods, which use a standard
     network byte order."

    ^ self nextPutInt16:anIntegerOrCharacter MSB:msbFlag

    "
     |s|

     s := #[] writeStream.
     s nextPutShort:16r1234 MSB:false.
     s contents.
    "
    "
     |s|

     s := #[] writeStream.
     s nextPutShort:16r1234 MSB:true.
     s contents.
    "

    "Modified: / 22-06-2006 / 11:30:26 / fm"
!

nextPutShortNet:aNumber
    <resource: #obsolete>
    "Write the argument, aNumber as a short (two bytes) in the network byte order.
     Returns the receiver on ok, nil on error.
     The receiver must support writing of binary bytes.
     Network byte order is MSB per definition"

    ^ self nextPutInt16:aNumber MSB:true.

    "Created: 10.1.1996 / 19:50:33 / cg"
! !

!Stream methodsFor:'open & close'!

close
    "close the stream - nothing done here.
     Added for compatibility with external streams."

    ^ self
! !

!Stream methodsFor:'private'!

contentsSpecies
    "this should return the class of which an instance is
     returned by the #contents method. Here, Array is returned,
     since the abstract Stream-class has no idea of the underlying
     collection class.
     It is redefined in some subclasses - for example, to return String."

    ^ Array

    "Modified: 15.5.1996 / 17:53:31 / cg"
! !

!Stream methodsFor:'queries'!

canReadWithoutBlocking
    "return true, if the stream can be read without blocking the program (actually: suspending the thread).
     This is redefined in external streams, which read from a communication line
     (sockets and devices).
     Always true here, because all internal streams never block"

    ^ true
!

canWriteWithoutBlocking
    "return true, if the stream can be written without blocking the program (actually: suspending the thread).
     This is redefined in external streams, which write to a communication line
     (sockets and devices).
     Always true here, because all internal streams never block"

    ^ true
!

current
    "for compatibility with Transcript - allow Transcript current,
     even if redirected to the standardError"

    self == Transcript ifTrue:[
        ^ self
    ].
    "/ this will raise an DNU error, usually.
    ^ super current

    "Modified (comment): / 29-08-2013 / 11:09:21 / cg"
!

inputStream
    "return the receiver.
     for compatibility with filtering streams"

    self isReadable ifFalse:[ ^ nil ].
    ^ self
!

isBinary
    "return true, if in binary mode. Always returns false here,
     to make internalStreams protocol compatible with externalStreams."

    ^ self contentsSpecies == ByteArray

    "Modified: 15.5.1996 / 17:53:51 / cg"
!

isOpen
    "for compatibility with externalStream:
     return true, if this stream is open."

    ^ true
!

isReadable
    "return true, if reading is supported by the receiver.
     This has to be redefined in concrete subclasses."

    ^ self subclassResponsibility

    "Modified: 15.5.1996 / 17:54:31 / cg"
!

isWritable
    "return true, if writing is supported by the receiver.
     This has to be redefined in concrete subclasses."

    ^ self subclassResponsibility

    "Modified: 15.5.1996 / 17:54:54 / cg"
!

lineLength
    "return the lineLength which `looks good' when pretty printed
     text is sent to this stream.
     This has NO meaning whatsoever to regular streams;
     however, it may be used as a layout hint for prettyprinting functions
     - for compatibility with TextCollectors, which returns its views actual
       line length, and allows the prettyprinter to wrap at that position."

    ^ 80

    "Modified: 15.5.1996 / 17:57:01 / cg"
!

lineNumber
    "return the current lineNumber if known
     (for compatibility with LineNumberReadStream)"

    ^ nil
!

numAvailableForRead
    "answer the number of bytes available for reading"

    ^ self size
!

numberOfTerminalCols
    ^ self lineLength
!

numberOfTerminalLines
    ^ 24
!

outputStream
    "return the receiver.
     for compatibility with filtering streams"

    self isWritable ifFalse:[ ^ nil ].
    ^ self
!

pageFormat
    "return the pageFormat - nil here.
     This has NO meaning whatsoever to regular streams;
     however, it has been added for protocol compatibility with printerStreams"

    ^ nil

    "Modified: / 15.5.1996 / 17:57:01 / cg"
    "Created: / 29.5.1998 / 16:57:48 / cg"
!

size
    "return the number of elements in the streamed collection."

    self subclassResponsibility

    "Created: / 05-08-2012 / 18:38:12 / cg"
!

terminalType
    ^ 'dump'
! !

!Stream methodsFor:'reading'!

next
    "return the next element of the stream
     - we do not know here how to do it, it must be redefined in subclass"

    ^ self subclassResponsibility
!

next:count
    "return the next count elements of the stream as aCollection,
     which depends on the streams type - (see #contentsSpecies)."

    |answerStream
     cnt  "{ Class: SmallInteger }" |

    cnt := count.
    answerStream := WriteStream on:(self contentsSpecies new:cnt).
    1 to:cnt do:[:index | |next|
        next := self next.
        next isNil ifTrue:[
            "if next did not raise EndOfStreamError, we have to do it"
            EndOfStreamError raiseRequestFrom:self.
            "if you proceed, you get what we have already collected"
            ^ answerStream contents
        ].
        answerStream nextPut:next.
    ].
    ^ answerStream contents

    "
     (ReadStream on:#(1 2 3 4 5)) next:3
     (ReadStream on:'hello') next:3
    "

    "Modified: 15.5.1996 / 17:57:58 / cg"
!

next:count into:aWriteStream
    "put the next count elements of the stream into aWriteStream"

    |cnt  "{ Class: SmallInteger }" |

    cnt := count.
    1 to:cnt do:[:index |  |next|
        next := self next.
        next isNil ifTrue:[
            "if next did not raise EndOfStreamError, we have to do it"
            EndOfStreamError raiseRequestFrom:self.
        ].
        aWriteStream nextPut:next.
    ].

    "
      |writeStream|
      writeStream := #() writeStream.
      #(1 2 3 4 5) readStream next:3 into:writeStream.
      writeStream contents.

      |writeStream|
      writeStream := '' writeStream.
      'hello' readStream next:3 into:writeStream.
      writeStream contents.
    "

    "Modified: 15.5.1996 / 17:57:58 / cg"
!

next:numObjects into:aCollection startingAt:initialIndex
    "return the next numObjects from the stream."

    |n "{Class: SmallInteger }"|

    n := 0.

    [n ~~ numObjects] whileTrue:[
        self atEnd ifTrue:[
            ^ aCollection copyFrom:1 to:initialIndex+n-1.
        ].
        aCollection at:(initialIndex + n) put:self next.
        n := n + 1.
    ].
    ^ aCollection.

    "
     |s n buffer|

     buffer := Array new:10.

     s := ReadStream on:#(1 2 3 4 5 6 7 8 9).
     s next:3.
     n := s next:9 into:buffer startingAt:2.
     Transcript showCR:('n = %1; buffer = %2' bindWith:n with:buffer)
    "

    "Modified: 22.4.1997 / 10:43:08 / cg"
!

nextAvailable:count
    "return the next count elements of the stream as aCollection.
     If the stream reaches the end before count elements have been read,
     return what is available. (i.e. a shorter collection).
     The type of collection is specified in #contentsSpecies."

    |answerStream
     cnt  "{ Class: SmallInteger }"|

    cnt := count.
    answerStream := WriteStream on:(self contentsSpecies new:cnt).
    1 to:cnt do:[:index |
        self atEnd ifTrue:[
            ^ answerStream contents
        ].
        answerStream nextPut:(self next)
    ].
    ^ answerStream contents

    "
     (ReadStream on:#(1 2 3 4 5)) nextAvailable:3
     (ReadStream on:#(1 2 3 4 5)) nextAvailable:10
     (ReadStream on:'hello') nextAvailable:3
     (ReadStream on:'hello') nextAvailable:10
    "

    "Modified: / 16.6.1998 / 15:52:41 / cg"
!

nextAvailable:numObjects into:aCollection startingAt:initialIndex
    "return the next numObjects from the stream."

    |n "{Class: SmallInteger }"|

    n := 0.

    [n ~= numObjects and:[self atEnd not]] whileTrue:[
        aCollection at:(initialIndex + n) put:self next.
        n := n + 1.
    ].
    ^ n.
!

nextMatchFor:anObject
    "read an element from the receiver, return true if it was equal to
     the argument, anObject; false otherwise."

    ^ (self next = anObject)

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     s nextMatchFor:2
    "
    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     s nextMatchFor:2.
     s nextMatchFor:2
    "

    "Modified: 15.5.1996 / 17:58:57 / cg"
!

nextOrNil
    "like #next, this returns the next element, if available.
     If nothing is available, this does never raise a read-beyond end signal.
     Instead, nil is returned immediately."

    self atEnd ifTrue:[^ nil].
    ^ self next
!

skip:numberToSkip
    "skip numberToSkip objects, return the receiver"

    "don't know how to unread ..."
    numberToSkip < 0 ifTrue:[
        PositionError raiseRequest.
        ^ self
    ].
    numberToSkip timesRepeat:[self next]

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     s skip:4.
     s next
    "

    "Modified: / 30.7.1999 / 12:12:10 / cg"
!

skipFor:anObject
    "skip all objects up-to and including anObject;
     read and return the element after anObject."

    (self skipThrough:anObject) notNil ifTrue:[
        ^ self next
    ].
    ^ nil

    "
     |s next rest|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     next := s skipFor:4.
     rest := s upToEnd.
    "
    "
     |s next rest|
     s := ReadStream on:'12345678'.
     next := s skipFor:$4.
     rest := s upToEnd.
    "

    "Modified: 15.5.1996 / 17:59:23 / cg"
!

skipLine
    "read the next line (characters up to newline) skip only;
     return nil if EOF reached, self otherwise.
     Not allowed in binary mode."

    ^ self skipThrough:Character cr
!

skipThrough:anObject
    "skip all objects up-to and including anObject.
     Return the receiver if skip was successful,
     otherwise (i.e. if not found) return nil and leave the stream positioned at the end.
     The next read operation will return the element after anObject."

    |nextElement|

    [
        nextElement := self nextOrNil.
        (nextElement isNil and:[self atEnd]) ifTrue:[
             ^ nil.
        ].
        nextElement = anObject
    ] whileFalse.

    "
     |s|
     s := ReadStream on:#(1 nil 2 3 4 5 6 7 8).
     s skipThrough:4.
     s next
    "
    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     s skipThrough:4.
     s skipThrough:4.
     s next
    "
    "
     |s|
     s := ReadStream on:'12345678'.
     s skipThrough:$4.
     s next
    "
    "
     |s|
     s := ReadStream on:'12345678'.
     s skipThrough:$4.
     s skipThrough:$4.
     s next
    "
    "
     |s|
     s := ReadStream on:'12345678'.
     s skipThrough:$4.
     s skipThrough:$4.
     s atEnd
    "
!

skipThroughAll:aCollection
    "skip for and through the sequence given by the argument, aCollection;
     return nil if not found, the receiver otherwise.
     On a successful match, the next read will return elements after aCollection;
     if no match was found, the receiver will be positioned at the end."

    |buffer l first idx|

    l := aCollection size.
    first := aCollection at:1.
    [self atEnd] whileFalse:[
        buffer isNil ifTrue:[
            buffer := self nextAvailable:l.
        ].
        buffer = aCollection ifTrue:[
            ^ self
        ].
        idx := buffer indexOf:first startingAt:2.
        idx == 0 ifTrue:[
            buffer := nil
        ] ifFalse:[
            buffer := (buffer copyFrom:idx) , (self nextAvailable:(idx - 1))
        ]
    ].
    ^ nil

    "
     |s|
     s := ReadStream on:'12345678901234567890'.
     s skipThroughAll:'901'.
     s upToEnd
    "
    "
     |s|
     s := ReadStream on:'12345678901234567890'.
     s skipThroughAll:'1234'.
     s upToEnd
    "
    "
     |s|
     s := ReadStream on:'12345678901234567890'.
     s skipThroughAll:'999'.
     s atEnd
    "

    "Created: 11.1.1997 / 18:55:13 / cg"
    "Modified: 11.1.1997 / 19:09:06 / cg"
!

through:anObject
    "read a collection of all objects up-to anObject and return these
     elements, including anObject.
     The next read operation will return the element after anObject.
     If anObject is not encountered, all elements up to the end are read
     and returned.
     Compare this with #upTo: which also reads up to some object
     and also positions behind it, but does not include it in the returned
     value."

    |answerStream element|

    answerStream := WriteStream on:(self contentsSpecies new).
    [self atEnd] whileFalse:[
        element := self next.
        answerStream nextPut:element.
        (element = anObject) ifTrue: [
            ^ answerStream contents
        ]
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s through:4).
     Transcript showCR:s next

     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s through:9).
     Transcript showCR:s next

     |s|
     s := ReadStream on:'hello world'.
     Transcript showCR:(s through:Character space).
     Transcript showCR:(s upToEnd)
    "

    "Modified: 17.5.1996 / 08:51:40 / cg"
!

throughAll:aCollection
    "read & return a collection of all objects up-to and including
     a subcollection given by aCollection.
     (i.e. read until a ``substring'' is encountered.)
     The next read operation will return the element after aCollection.
     If aCollection is not encountered, all elements up to the end are read
     and returned."

    |answerStream element last|

    last := aCollection last.
    answerStream := WriteStream on:(self contentsSpecies new).
    [(element := self nextOrNil) isNil and:[self atEnd]] whileFalse:[
        answerStream nextPut:element.
        element == last ifTrue:[
            (answerStream endsWith:aCollection) ifTrue:[
                ^ answerStream contents
            ]
        ].
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s throughAll:#(4 4 4)).
     Transcript showCR:s next

     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s throughAll:#(4 5 6)).
     Transcript showCR:s next

     |s|
     s := ReadStream on:'hello world, this is some text'.
     Transcript showCR:(s throughAll:'world').
     Transcript showCR:(s throughAll:'some').
     Transcript showCR:s upToEnd.
    "

    "Modified: 15.7.1996 / 09:08:07 / cg"
!

throughAny:aCollection
    "read & return a collection of all objects up-to and including
     an element contained in aCollection.
     (i.e. read until any from aCollection is encountered.)
     If no such character is encountered, all elements up to the end are read
     and returned."

    |answerStream element|

    answerStream := WriteStream on:(self contentsSpecies new).
    [self atEnd] whileFalse:[
        element := self next.
        answerStream nextPut:element.
        (aCollection includes:element) ifTrue:[
            ^ answerStream contents
        ].
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s throughAny:#(3 4 5)).
     Transcript showCR:s next

     |s|
     s := ReadStream on:'hello world, this is some text'.
     Transcript showCR:(s throughAny:'wt').
     Transcript showCR:(s throughAny:'wt').
     Transcript showCR:s upToEnd.
    "

    "Modified: / 11.1.1998 / 15:28:04 / cg"
!

throughElementForWhich:aBlock
    "read elements until aBlock returns true for an element.
     Return the collected elements including that element.
     Leave the stream positioned for the next read to return the element after that one."

    |answerStream element|

    answerStream := WriteStream on:(self contentsSpecies new).

    [self atEnd] whileFalse:[
        element := self next.
        answerStream nextPut:element.
        (aBlock value:element) ifTrue: [
            ^ answerStream contents
        ]
    ].
    ^ answerStream contents

    "
     #(1 2 3 4 5 6 7 8 9 10) readStream
        throughElementForWhich:[:el | el > 5];
    "
!

upTo:anObject
    "read a collection of all objects up-to anObject and return these
     elements, but excluding anObject.
     The next read operation will return the element after anObject.
     (i.e. anObject is considered a separator, which is skipped)
     Similar to #through:, but the matching object is not included in the
     returned collection.
     If anObject is not encountered, all elements up to the end are read
     and returned.
     Compare this with #through: which also reads up to some object
     and also positions behind it, but DOES include it in the returned
     value."

    |answerStream|

    answerStream := WriteStream on:(self contentsSpecies new).
    self upTo:anObject into:answerStream.
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s upTo:4).
     Transcript showCR:s next

     compare the above to:
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s through:4).
     Transcript showCR:s next

     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s upTo:9).
     Transcript showCR:s next

     |s|
     s := ReadStream on:'hello world'.
     Transcript showCR:(s upTo:Character space).
     Transcript showCR:(s upToEnd)

     (ReadStream on:'12345678905') upTo:$5; next

     (ReadStream on:'12345678905') upTo:$5; upTo:$5

     (ReadStream on:'123456') upTo:$7

     (ReadStream on:#(1 2 3 4 5 6)) upTo:4

     (ReadStream on:'line 1
                     line 2') upTo:Character cr

     'Makefile' asFilename readStream upTo:Character cr;upTo:Character cr
    "

    "Modified: / 12.1.1998 / 21:58:38 / cg"
    "Modified: / 15.1.1998 / 23:28:47 / stefan"
!

upTo:anObject into:aStream
    "read a collection of all objects up-to anObject and append these
     elements to aStream, but excluding anObject. 
     The next read operation will return the element after anObject.
     (i.e. anObject is considered a separator, which is skipped)
     Similar to #through:, but the matching object is not included in the returned collection.
     If anObject is not encountered, all elements up to the end are read and returned.
     Compare this with #through: which also reads up to some object
     and also positions behind it, but DOES include it in the returned value."

    |element|

    [
        element := self nextOrNil.
        ((element isNil and:[self atEnd]) or:[element = anObject]) ifTrue:[
            ^ self
        ].
        aStream nextPut:element.
    ] loop.
!

upToAllExcluding:aCollection
    "read a collection of all objects up-to a element which is contained in
     aCollection and return these elements, but excluding the matching one.
     The next read operation will return the element after aCollection.
     If no such element is encountered, all elements up to the end are read
     and returned.
     See also #throughAll: which also reads up to some object
     and also positions behind it, but DOES include it in the returned
     value.
     See also #upToAll:, which returns the same, but leaves the
     read pointer before the matched subcollection."

    |answerStream element last|

    last := aCollection last.
    answerStream := ReadWriteStream on:(self contentsSpecies new).
    [(element := self nextOrNil) isNil and:[self atEnd]] whileFalse:[
        answerStream nextPut:element.
        element == last ifTrue:[
            (answerStream endsWith:aCollection) ifTrue:[
                |pos|
                pos := answerStream position.
                answerStream reset.
                ^ answerStream next:pos-aCollection size.
            ]
        ].
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:'hello world world'.
     Transcript show:'<'; show:(s upToAllExcluding:'wo'); showCR:'>'.
     Transcript show:'<'; show:(s upToAllExcluding:'wo'); showCR:'>'.
     Transcript show:'<'; show:(s upToEnd); showCR:'>'.
    "

    "Created: / 15.6.1998 / 19:11:31 / cg"
!

upToEnd
    "return a collection of the elements up-to the end.
     Return an empty collection, if the stream-end is already at the end."

    |answerStream|

    answerStream := WriteStream on:(self contentsSpecies new).
    [self atEnd] whileFalse:[
        answerStream nextPut:(self next)
    ].
    ^ answerStream contents

    "
     (ReadStream on:'1234567890') upToEnd
     ('123456' readStream) next; next; upToEnd
     ('1 23456' readStream) upTo:Character space; upToEnd
     ('12' readStream) next; next; upToEnd
    "

    "Modified: 15.5.1996 / 18:00:39 / cg"
!

upToMatching:aBlock
    "Return the next elements up to but not including the next element
     for which aBlock returns true.
     The next read will return that matching element.
     If none matches, the remaining elements up to the end are returned."

    ^ self upToElementForWhich:aBlock
"/    |answerStream element|
"/
"/    answerStream := WriteStream on:(self contentsSpecies new).
"/    [self atEnd] whileFalse: [
"/        element := self peek.
"/        (aBlock value:element) ifTrue: [^ answerStream contents].
"/        answerStream nextPut:element.
"/        self next.
"/    ].
"/    ^ answerStream contents

    "
     'hello world' readStream upToMatching:[:c | c isSeparator].
    "
    "
     'helloworld' readStream upToMatching:[:c | c isSeparator].
    "
    "
     |s|

     s := 'hello world' readStream.
     s upToMatching:[:c | c isSeparator].
     s upToEnd
    "

    "Modified: 26.2.1997 / 12:20:57 / cg"
!

upToSeparator
    "Return the next elements up to but not including the next separator.
     The next read will return the separator.
     If no separator is encountered, the contents up to the end is returned.
     The elements are supposed to understand #isSeparator
     (i.e. the receiver is supposed to be a character-stream)."

    ^ self upToElementForWhich:[:ch | ch isSeparator]

    "
     'hello world' readStream upToSeparator
     'helloworld' readStream upToSeparator
     'helloworld' readStream upToSeparator
     '' readStream upToSeparator

     |s|
     s := 'hello world' readStream.
     s upToSeparator.
     s upToEnd
    "

    "Modified: 4.1.1997 / 23:38:05 / cg"
! !

!Stream methodsFor:'reading-numbers'!

nextDecimalInteger
    "read and return the next integer from the receiver stream.
     Leaves the stream positioned after the digits"

    ^ Integer readFrom:self

    "
     |s|
     s := '1234a' readStream.
     Transcript showCR:(s nextDecimalInteger).
     s peek                                -> $a
    "
    "
     |s|
     s := '1234.0a' readStream.
     Transcript showCR:(s nextDecimalInteger).
     s peek                                -> $.
    "
    "
     |s|
     s := '1234.0a' readStream.
     Transcript showCR:(s nextDecimalNumber).
     s peek                                -> $a
    "
!

nextDecimalInteger:numChars
    "read and return the next integer of numChars size from the receiver stream.
     Does NOT skip separators.
     Leaves the stream positioned after the digits.
     Raises an error, if the characters cannot be converted to an integer"

    |chars|

    chars := self next:numChars.
    ^ Integer readFrom:chars

    "
     |s|
     s := '1234a' readStream.
     Transcript showCR:(s nextDecimalInteger:2).
     Transcript showCR:(s nextDecimalInteger).
     s peek                                -> $a
    "
!

nextDecimalNumber
    "read and return the next number from the receiver stream.
     Leaves the stream positioned after the digits"

    ^ Number readFrom:self

    "
     |s|
     s := '1234.0a' readStream.
     Transcript showCR:(s nextDecimalNumber).
     s peek                                -> $a
    "
!

nextDecimalNumber:numChars
    "read and return the next number of numChars size from the receiver stream.
     Does NOT skip separators.
     Leaves the stream positioned after the digits.
     Raises an error, if the characters cannot be converted to a number"

    |chars|

    chars := self next:numChars.
    ^ Integer readFrom:chars

    "
     |s|
     s := '12.34a' readStream.
     Transcript showCR:(s nextDecimalNumber:4).
     Transcript showCR:(s nextDecimalInteger).
     s peek                                -> $a
    "
! !

!Stream methodsFor:'reading-strings'!

nextLine
    "return the characters upTo (but excluding) the next cr (carriage return)
     character (i.e. read a single line of text).
     If the previous-to-last character is a cr, this is also removed,
     so it's possible to read alien (i.e. ms-dos) text as well.
     Added for protocol compatibility with externalStreams."

    |answerStream|

    self atEnd ifTrue:[
        ^ self pastEndRead
    ].
    answerStream := WriteStream on:(self contentsSpecies uninitializedNew:80).
    self upTo:Character cr into:answerStream.
    (answerStream size ~~ 0 and:[answerStream last = Character return]) ifTrue:[
        answerStream backStep.
    ].
    ^ answerStream contents


    "Modified: / 19.5.1998 / 17:26:25 / cg"
! !


!Stream methodsFor:'testing'!

atEnd
    "return true if the end of the stream has been reached;
     - we do not know here how to do it, it must be redefined in subclass"

    ^ self subclassResponsibility
!

isEmpty
    "return true, if the contents of the stream is empty"

    ^ self subclassResponsibility
!

isEmptyOrNil
    "return true, if the contents of the stream is empty
     (we already know, that we are not nil)"

    ^ self isEmpty
!

isEncodedStream
    "true, iff this is an encoder/decoder stream"

    ^ false
!

isLineNumberReadStream
    "true, iff this is a lineNumbering stream"

    ^ false
!

isPositionable
    "return true, if the stream supports positioning (some do not).
     Since this is an abstract class, false is returned here - just to make certain."

    ^ false

    "Modified: 15.5.1996 / 17:54:16 / cg"
!

isPrinterStream
    "return true, if this is a printerStream.
     Since this is an abstract class, false is returned here."

    ^ false

    "Modified: 15.5.1996 / 17:54:16 / cg"
    "Created: 3.6.1996 / 12:05:35 / cg"
!

isStream
    "return true, if the receiver is some kind of Stream. Always return true here."

    ^ true

    "Modified: 15.5.1996 / 17:54:48 / cg"
!

isTTY
    "Return true if receiver refers to TTY / PTY, false otherwise."

    ^ false

    "Created: / 30-05-2017 / 21:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTerminalStream
    "true, iff this is a terminal emulator stream"

    ^ false
!

isTextCollector
    "true, iff this is a text collector emulating a stream"

    ^ false

    "
     Transcript isTextCollector
    "

    "Created: / 29-08-2013 / 11:33:10 / cg"
!

notEmpty
    "return true, if the contents of the stream is not empty"

    ^ self isEmpty not
!

notEmptyOrNil
    "return true, if the contents of the stream is empty
     (we already know, that we are not nil)"

    ^ self isEmpty not
! !

!Stream methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitStream:with: to aVisitor."

    ^ aVisitor visitStream:self with:aParameter
! !

!Stream methodsFor:'waiting for I/O'!

readWait
    "suspend the current process, until the receiver
     becomes ready for reading. If data is already available,
     return immediately.
     The other threads are not affected by the wait."

    ^ self readWaitWithTimeoutMs:nil
!

readWaitTimeoutMs:timeout
    "ST-80 compatibility"
    ^ self readWaitWithTimeoutMs:timeout
!

readWaitWithTimeout:secondsOrTimeDurationOrNil
    "suspend the current process, until the receiver
     becomes ready for reading or a timeout (in seconds) expired.
     If data is already available, return immediate.
     With nil seconds, wait forever.
     Return true if a timeout occurred (i.e. false, if data is available).
     The other threads are not affected by the wait."

    |ms|

    secondsOrTimeDurationOrNil notNil ifTrue:[
        secondsOrTimeDurationOrNil isNumber ifTrue:[
            ms := secondsOrTimeDurationOrNil * 1000.
        ] ifFalse:[
            ms := secondsOrTimeDurationOrNil getMilliseconds.
        ]
    ].
    ^ self readWaitWithTimeoutMs:ms
!

readWaitWithTimeoutMs:millis
    "suspend the current process, until the receiver
     becomes ready for reading or a timeout (in milliseconds) expired.
     If data is already available, return immediate.
     With nil millis, wait forever.
     Return true if a timeout occurred (i.e. false, if data is available).
     The other threads are not affected by the wait."

    ^ false "/ never have to wait
!

readWriteWait
    "suspend the current process, until the receiver
     becomes ready for writing or reading.
     Return immediate if the receiver is already ready.
     The other threads are not affected by the wait."

    self readWriteWaitWithTimeoutMs:nil
!

readWriteWaitWithTimeoutMs:millis
    ^ false "/ never have to wait
!

writeWait
    "suspend the current process, until the receiver
     becomes ready for writing.
     Return immediate if the receiver is already ready.
     The other threads are not affected by the wait."

    self writeWaitWithTimeoutMs:nil
!

writeWaitTimeoutMs:timeout
    "ST-80 compatibility"
    ^ self writeWaitWithTimeoutMs:timeout
!

writeWaitWithTimeout:secondsOrTimeDuration
    "suspend the current process, until the receiver
     becomes ready for writing or a timeout (in seconds) expired.
     Return true if a timeout occurred (i.e. false, if data is available).
     Return immediate if the receiver is already ready.
     The other threads are not affected by the wait."

    |ms|

    secondsOrTimeDuration notNil ifTrue:[
        secondsOrTimeDuration isNumber ifTrue:[
            ms := secondsOrTimeDuration * 1000.
        ] ifFalse:[
            ms := secondsOrTimeDuration getMilliseconds.
        ]
    ].
    ^ self writeWaitWithTimeoutMs:ms
!

writeWaitWithTimeoutMs:millis
    ^ false "/ never have to wait
! !

!Stream methodsFor:'writing'!

commit
    "alias for flush -- ST80 compatibility"

    ^ self flush

    "Modified: 7.5.1996 / 23:55:39 / stefan"
!

cr
    "append a carriage-return to the stream.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character cr)

    "Modified: 15.5.1996 / 18:01:21 / cg"
!

crTab
    "append a carriage-return followed by a tab to the stream.
     Same as crtab for ST/X backward compatibility.
     This is only allowed, if the receiver supports writing."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #crtab'.
    self crtab

    "Modified: 15.5.1996 / 18:01:28 / cg"
!

crlf
    "append a CR LF to the stream.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character return);
         nextPut:(Character lf).
!

crtab
    "append a carriage-return followed by a tab to the stream.
     This is only allowed, if the receiver supports writing."

    self crtab:1

    "Modified: 15.5.1996 / 18:01:35 / cg"
!

crtab:n
    "append a carriage-return followed by n tabs to the stream.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character cr).
    self next:n put:(Character tab)

    "Modified: 15.5.1996 / 18:01:39 / cg"
!

endEntry
    "ignored here - for compatibility with Transcript"

    ^ self
!

ff
    "append a form-feed (new-pagee) to the receiver-stream.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character ff)

    "Modified: 15.5.1996 / 18:01:47 / cg"
!

flush
    "write out all unbuffered data - ignored here, but added
     to make internalStreams protocol compatible with externalStreams"

    "Modified: 7.5.1996 / 23:54:53 / stefan"
!

format:formatSpec with:args
    "convenient formatted printing:
        %1..%9  - positional parameters from args-collection
        %(name) - named parameter from args-dictionary
        %%      - escape for %
        %<cr>   - cr (also tab, nl)"

    formatSpec expandPlaceholders:$% with:args on:self

    "
     1 to: 10 do:[:i |
        Transcript
            format:'[%1] Hello %2 World - this is %3%<cr>'
            with:{i . 'my' . 'nice'}
     ].
    "
!

next:count put:anObject
    "put the argument, anObject count times onto the receiver.
     This is only allowed, if the receiver supports writing."

    |n "{ Class: SmallInteger }"|

    n := count.
    n timesRepeat:[self nextPut:anObject].
    "/ ^ anObject -- return self

    "
     |s|

     s := WriteStream on:#().
     s nextPut:1.
     s next:5 put:2.
     s nextPut:3.
     s contents
    "

    "Modified: 11.7.1996 / 10:00:13 / cg"
!

next:count putAll:aCollection
    "put all elements from the argument, aCollection count times onto the receiver.
     This is only allowed, if the receiver supports writing."

    |n "{ Class: SmallInteger }"|

    n := count.
    n timesRepeat:[self nextPutAll:aCollection].
    "/ ^ anObject -- return self

    "
     |s|

     s := WriteStream on:(String new).
     s next:5 putAll:'Hello'.
     s contents
    "
!

nextPut:anObject
    "put the argument, anObject onto the receiver
     - we do not know here how to do it, it must be redefined in subclass"

    ^ self subclassResponsibility
!

nextPutAll:aCollection
    "put all elements of the argument, aCollection onto the receiver.
     This is only allowed, if the receiver supports writing."

    (aCollection notNil and:[aCollection isSequenceable]) ifFalse:[
        "/ fallback
        aCollection do:[:eachElement|
            self nextPut:eachElement.
        ].
         ^ self.
    ].

    self nextPutAll:aCollection startingAt:1 to:aCollection size

    "
     |s|

     s := WriteStream on:#().
     s nextPutAll:(1 to:5).
     s nextPutAll:#('one' 'two' 'three').
     s contents
    "
    "
     |s|

     s := WriteStream on:(String new).
     s nextPutAll:($a to:$f).
     s nextPutAll:'one ';
       nextPutAll:'two ';
       nextPutAll:'three'.
     s contents
    "

    "Modified: 11.7.1996 / 10:00:21 / cg"
!

nextPutAll:count from:aCollection startingAt:initialIndex
    "append count elements with index starting at initialIndex
     of the argument, aCollection onto the receiver.
     This is only allowed, if the receiver supports writing.
     Answer the number of elements that were appended.
     This is for compatibility with ExternalStream, where less then
     count elements may be written. Dolphin defines this as well."

    self nextPutAll:aCollection startingAt:initialIndex to:initialIndex+count-1.
    ^ count

    "
     |s|

     s := WriteStream on:#().
     s nextPutAll:4 from:#('one' 'two' 'three' 'four' 'five') startingAt:2.
     s contents
    "

    "Modified: 11.7.1996 / 10:00:32 / cg"
!

nextPutAll:aCollection startingAt:first
    "append the elements starting with index to the end
     of the argument, aCollection onto the receiver.
     This is only allowed, if the receiver supports writing."

    self nextPutAll:aCollection startingAt:first to:(aCollection size).

    "
     |s|

     s := WriteStream on:#().
     s nextPutAll:#('one' 'two' 'three' 'four' 'five') startingAt:2.
     s contents
    "

    "Modified: 11.7.1996 / 10:00:28 / cg"
!

nextPutAll:aCollection startingAt:first to:last
    "append the elements with index from first to last
     of the argument, aCollection onto the receiver.
     This is only allowed, if the receiver supports writing."

    aCollection from:first to:last do:[:element |
	self nextPut:element
    ].
    ^ aCollection

    "
     |s|

     s := WriteStream on:#().
     s nextPutAll:#('one' 'two' 'three' 'four' 'five') startingAt:2 to:4.
     s contents
    "

    "Modified: 11.7.1996 / 10:00:32 / cg"
!

nextPutAllLines:aCollectionOfStrings
    "put all elements of the argument, aCollection as individual lines
     onto the receiver, append a cr (carriage return) after each.
     This is only useful with character streams in textMode,
     and only allowed, if the receiver supports writing."

    aCollectionOfStrings do:[:eachLine |
        self nextPutLine:eachLine.
    ].

    "Modified: / 08-11-1996 / 23:53:41 / cg"
    "Created: / 27-07-2012 / 09:26:09 / cg"
!

nextPutAllText:aText
    "normal streams can not handle text/emphasis, so convert aText to the string"

    aText string printOn:self.
!

nextPutAllUnicode:aString
    "normal streams can not handle multi-byte characters, so convert them to utf8"

    aString do:[:eachCharacter|
        self nextPutUtf8:eachCharacter.
    ].
!

nextPutAllUntranslated:aCollection
    "for compatibility with printStreams (putAll - as-is without escapes)"

    self nextPutAll:aCollection
!

nextPutLine:aCollection
    "put all elements of the argument, aCollection onto the receiver,
     and append a cr (carriage return). aCollection should contain characters.
     This is only useful with character streams in textMode
     and only allowed if the receiver supports writing."

    self nextPutAll:aCollection.
    self cr.

    "Created: 13.12.1995 / 10:49:17 / cg"
    "Modified: 8.11.1996 / 23:53:41 / cg"
!

nextPutUnicode:aCharacter
    "normal streams can not handle multi-byte characters, so convert them to utf8"

    self nextPutUtf8:aCharacter.
!

print:anObject
    "append a printed representation of anObject to the receiver.
     Same as 'anObject printOn:self'; Added for ST-80 compatibility."

    anObject printOn:self

    "
     |s|

     s := WriteStream on:''.
     s nextPutAll:'one ';
       print:1;
       nextPutAll:' two ';
       print:2.

     s contents
    "

    "Modified: 15.5.1996 / 18:06:06 / cg"
!

printCR:anObject
    "append a printed representation of anObject to the receiver,
     followed by a newline character."

    self print:anObject.
    self cr.

    "Created: / 26-09-2012 / 18:21:06 / cg"
!

printf:format
    "C-style printing into a stream"

    format printf:#() on:self.

    "
     Transcript printf:'Hello World\n'
    "
!

printf:format with:argument
    "C-style printing into a stream"

    format printf:{argument} on:self.

    "
     Transcript printf:'%05x\n' with:12345
    "
!

printf:format with:argument1 with:argument2
    "C-style printing into a stream"

    format printf:{argument1 . argument2} on:self.

    "
     Transcript printf:'%05x %3s\n' with:12345 with:'abc'
    "
!

printf:format with:argument1 with:argument2 with:argument3
    "C-style printing into a stream"

    format printf:{argument1 . argument2 . argument3} on:self.

    "
     Transcript printf:'%05x %3s %09s\n' with:12345 with:'abc' with:'abc'
     Transcript printf:'%05x %3s %9s\n' with:12345 with:'abc' with:'abc'
    "
!

printf:format with:argument1 with:argument2 with:argument3 with:argument4
    "C-style printing into a stream"

    format printf:{argument1 . argument2 . argument3 . argument4} on:self.

    "
     Transcript printf:'%02x %02x %02x %02x\n' with:1 with:2 with:3 with:4
     Transcript printf:'%2x %2x %2x %2x\n' with:1 with:2 with:3 with:4
     Transcript printf:'%-2x %-2x %-2x %-2x\n' with:1 with:2 with:3 with:4
    "
!

printf:format with:argument1 with:argument2 with:argument3 with:argument4 with:argument5
    "C-style printing into a stream"

    format printf:{argument1 . argument2 . argument3 . argument4 . argument5} on:self.

    "
     Transcript printf:'%02x %02x %02x %02x\n' with:1 with:2 with:3 with:4
     Transcript printf:'%2x %2x %2x %2x\n' with:1 with:2 with:3 with:4
     Transcript printf:'%-2x %-2x %-2x %-2x\n' with:1 with:2 with:3 with:4
    "
!

printf:format withAll:arguments
    "C-style printing into a stream"

    format printf:arguments on:self.

    "
     Transcript printf:'%05x %d %f %o\n' withAll:{ 123. 234*5. 1.234. 8r377 }
     Transcript printf:'%03d %03d %03d\n' withAll:{ 1. 2. 3 }
    "
!

println
    "for those used to Java/Javascript, a compatibility message.
     Most useful inside expecco"

    self cr
!

println:anObject
    "for those used to Java/Javascript, a compatibility message.
     Most useful inside expecco"

    self showCR:anObject
!

show:something
    "append a printed representation of the argument to the stream.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    something printOn:self
!

show:something with:arg
    "append a printed representation of the argument to the stream, expanding
     the placeHolder %1 with the printString of arg.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self show:(something bindWith:arg)

    "Modified: / 19-08-2010 / 15:42:00 / cg"
!

show:something with:arg1 with:arg2
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1 and %2 with the printStrings of arg1 and arg2.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self show:(something bindWith:arg1 with:arg2)

    "Modified: / 19-08-2010 / 15:42:09 / cg"
!

show:something with:arg1 with:arg2 with:arg3
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of arg1, arg2 and arg3.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self show:(something bindWith:arg1 with:arg2 with:arg3)

    "Modified: / 19-08-2010 / 15:42:17 / cg"
!

show:something with:arg1 with:arg2 with:arg3 with:arg4
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of arg1, arg2 and arg3.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self show:(something bindWith:arg1 with:arg2 with:arg3 with:arg4)

    "Created: / 19-08-2010 / 15:42:25 / cg"
!

show:something with:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of arg1, arg2 and arg3.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self show:(something bindWith:arg1 with:arg2 with:arg3 with:arg4 with:arg5)

    "Created: / 19-08-2010 / 15:42:25 / cg"
!

show:something withArguments:args
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of argi.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self show:(something bindWithArguments:args)
!

showCR:aString
    "append a printed representation of the argument to the stream
     and append a newline character.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self show:aString.
    self cr

    "Created: 18.5.1996 / 15:34:17 / cg"
    "Modified: 11.7.1996 / 10:01:27 / cg"
!

showCR:something with:arg
    "append a printed representation of the argument to the stream, expanding
     the placeHolder %1 with the printString of arg.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self showCR:(something bindWith:arg)

    "Created: / 19-08-2010 / 15:41:46 / cg"
!

showCR:something with:arg1 with:arg2
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1 and %2 with the printStrings of arg1 and arg2.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self showCR:(something bindWith:arg1 with:arg2)

    "Created: / 19-08-2010 / 15:42:37 / cg"
!

showCR:something with:arg1 with:arg2 with:arg3
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of arg1, arg2 and arg3.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self showCR:(something bindWith:arg1 with:arg2 with:arg3)

    "Created: / 19-08-2010 / 15:42:43 / cg"
!

showCR:something with:arg1 with:arg2 with:arg3 with:arg4
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of arg1, arg2 and arg3.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self showCR:(something bindWith:arg1 with:arg2 with:arg3 with:arg4)

    "Created: / 19-08-2010 / 15:42:50 / cg"
!

showCR:something with:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of arg1, arg2 and arg3.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self showCR:(something bindWith:arg1 with:arg2 with:arg3 with:arg4 with:arg5)

    "Created: / 19-08-2010 / 15:42:50 / cg"
!

showCR:something withArguments:args
    "append a printed representation of the argument to the stream, expanding
     the placeHolders %1,%2 and %3 with the printStrings of argi.
     This makes streams somewhat compatible to TextCollectors and
     allows you to say:
        Smalltalk at:#Transcript put:Stdout
     or to use #show:/#showCR: with internal or external streams."

    self showCR:(something bindWithArguments:args)
!

showCr:aString
    "append a printed representation of the argument to the stream
     and append a newline character.
     This is obsolete ST/X backward compatibility; use #showCR:"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #showCR:'.
    self showCR:aString.

    "Modified: 11.7.1996 / 10:01:50 / cg"
!

space
    "append a space character to the receiver.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character space)

    "Modified: 11.7.1996 / 10:02:06 / cg"
!

spaces:count
    "append count space-characters to the receiver.
     This is only allowed, if the receiver supports writing."

    self next:count put:(Character space)

    "Modified: 11.7.1996 / 10:02:10 / cg"
!

store:anObject
    "append a printed representation of anObject to the receiver,
     from which the receiver can be reconstructed (i.e. its storeString).
     Same as 'anObject storeOn:self'; Added for ST-80 compatibility."

    anObject storeOn:self

    "Modified: 15.5.1996 / 18:05:55 / cg"
!

sync
    "write out all unbuffered data - ignored here, but added
     to make internalStreams protocol compatible with externalStreams"
!

syncData
    "write out all unbuffered data - ignored here, but added
     to make internalStreams protocol compatible with externalStreams"
!

tab
    "append a tab-character to the stream.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character tab)

    "Modified: 11.7.1996 / 10:02:20 / cg"
!

tab:count
    "append count tab-characters to the receiver.
     This is only allowed, if the receiver supports writing."

    self next:count put:(Character tab)

    "Modified: 11.7.1996 / 10:02:10 / cg"
! !

!Stream methodsFor:'writing-chunks'!

nextChunkPut:aString
    "put aString as a chunk onto the receiver;
     double all exclamation marks except within primitives and append a
     single delimiting exclamation mark at the end.
     This modification of the chunk format (not doubling exclas in primitive code)
     was done to have primitive code more readable and easier be edited in the fileBrowser
     or other editors.
     It's no incompatibility, since inline primitives are an ST/X special
     and code containing ST/X primitives cannot be loaded into other smalltalks anyway."

    self nextPutAllAsChunk:aString.
    self nextPut:(self class chunkSeparator)

    "Modified: 9.12.1995 / 15:56:54 / cg"
!

nextPutAllAsChunk:aString
    "put aString as a chunk onto the receiver;
     double all exclamation marks except within primitives.
     This modification of the chunk format (not doubling exclas in primitive code)
     was done to have primitive code more readable and easier be edited in the fileBrowser
     or other editors.
     It's no incompatibility, since inline primitives are an ST/X special
     and code containing ST/X primitives cannot be loaded into other smalltalks anyway."

    |sep stopChars inPrimitive character
     index    "{ Class:SmallInteger }"
     endIndex "{ Class:SmallInteger }"
     stop     "{ Class:SmallInteger }"
     next     "{ Class:SmallInteger }"|

    endIndex := aString size.
    endIndex == 0 ifTrue:[^ self].

    sep := self class chunkSeparator.
    stopChars := '{}' copyWith:sep.

    inPrimitive := false.
    index := 1.
    stop := endIndex + 1.

    [index <= endIndex] whileTrue:[
        "
         find position of next interesting character;
         output stuff up to that one in one piece
        "
        next := aString indexOfAny:stopChars startingAt:index ifAbsent:stop.

        ((index == 1) and:[next == stop]) ifTrue:[
            self nextPutAll:aString
        ] ifFalse:[
            self nextPutAll:aString startingAt:index to:(next - 1)
        ].

        index := next.
        (index <= endIndex) ifTrue:[
            character := aString at:index.

            (character == ${ ) ifTrue:[
                "/ starts a primitive
                ((index > 1) and:[(aString at:index-1) == $%]) ifTrue:[
                    inPrimitive := true
                ]
            ] ifFalse:[
                "/ ends a primitive
                (character == $} ) ifTrue:[
                    ((index > 1) and:[(aString at:index-1) == $%]) ifTrue:[
                        inPrimitive := false
                    ]
                ] ifFalse:[
                    "/
                    "/ exclas have to be doubled - except if within a primitive
                    "/
                    inPrimitive ifFalse:[
                        (character == sep) ifTrue:[
                            self nextPut:sep
                        ]
                    ]
                ]
            ].

            self nextPut:character.
            index := index + 1.
        ].
    ].
    (aString endsWith:Character cr) ifFalse:[
        self cr.
    ].

    "Modified: / 21.4.1998 / 17:22:47 / cg"
!

nextPutChunkSeparator
    "append a chunk separator character"

    self nextPut:(self class chunkSeparator)

    "Created: 13.9.1995 / 17:39:26 / claus"
! !

!Stream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Stream initialize!
