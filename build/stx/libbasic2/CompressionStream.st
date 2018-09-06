"
 COPYRIGHT (c) 2002 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#CompressionStream
	instanceVariableNames:'onStream hitEOF binary position readLimit mode inputBytes
		outputBytes zstream suppressHeaderAndChecksum propagateClose'
	classVariableNames:'BlockSize'
	poolDictionaries:''
	category:'Streams-Compressed'
!

!CompressionStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    Abstract superclass of streams that compress or decompress data

    [author:]
        Claus Atzkern

    [instance variables:]

    [class variables:]

    [see also:]
        ZipStream
"
! !

!CompressionStream class methodsFor:'initialization'!

initialize
    BlockSize := 6.
! !

!CompressionStream class methodsFor:'instance creation'!

readOpenOn:aStream
    "open to read data from an compressed stream"

    ^ self
        readOpenOn:aStream
        suppressHeaderAndChecksum:(self defaultSuppressHeaderAndChecksum)
!

readOpenOn:aStream suppressHeaderAndChecksum:aBoolean
    "open to read data from an compressed stream"

    ^ self basicNew
        openWithMode:#readonly
        on:aStream
        suppressHeaderAndChecksum:aBoolean
!

writeOpenOn:aStream
    "open to write data compressed to stream"

    ^ self
        writeOpenOn:aStream
        suppressHeaderAndChecksum:(self defaultSuppressHeaderAndChecksum)
!

writeOpenOn:aStream suppressHeaderAndChecksum:aBoolean
    "open to write data compressed to stream"

    ^ self basicNew
        openWithMode:#writeonly
        on:aStream
        suppressHeaderAndChecksum:aBoolean
! !

!CompressionStream class methodsFor:'defaults'!

defaultSuppressHeaderAndChecksum
    ^ true
! !

!CompressionStream methodsFor:'accessing'!

binary
    "switch to binary mode - default is text
    "
    binary := true.
!

propagateClose
    ^ propagateClose
!

propagateClose:aBoolean
    "close the underlying stream if the zip stream is closed"

    propagateClose := aBoolean.
!

text
    "switch to text mode - default is text"

    binary := false.
! !

!CompressionStream methodsFor:'error handling'!

errorNotOpen
    "report an error, that the stream has not been opened"

    self zerror:'not open'.
!

errorReadOnly
    "report an error, that the stream is a readOnly stream"

    self zerror:'is readonly'
!

errorWriteOnly
    "report an error, that the stream is a writeOnly stream"

    self zerror:'is writeonly'
!

invalidArgument
    "called if a method is invoked with invalid parameters"

    self zerror:'invalid arguments'.
!

zerror:anError
    |error|

    zstream isNil ifTrue:[
        error := 'not open'.
    ] ifFalse:[
        anError isNumber ifTrue:[
                     anError ==  1 ifTrue:[ error := 'stream at end' ]
            ifFalse:[anError == -1 ifTrue:[ error := 'processing error: ', anError printString ]
            ifFalse:[anError == -2 ifTrue:[ error := 'processing error' ]
            ifFalse:[anError == -3 ifTrue:[ error := 'input data corrupted' ]
            ifFalse:[anError == -4 ifTrue:[ error := 'not enough memory' ]
            ifFalse:[anError == -5 ifTrue:[ error := 'not enough memory in the output stream' ]
            ifFalse:[anError == -6 ifTrue:[ error := 'version error' ]
            ifFalse:[
                    error := 'compressing error: ', anError printString
            ]]]]]]].
        ] ifFalse:[
            error := anError printString
        ].
    ].
    StreamError raiseErrorString:(self class name , ': ', error).
! !

!CompressionStream methodsFor:'finalization'!

executor
    "redefined to return a lightweight copy
     - all we need is the memory handle"

    ^ self class basicNew finalizeCopy:zstream.
!

finalize
    "the compressin-stream was garbage collected;
     close the underlying zip-stream"

    self closeZStream.
!

finalizeCopy:aZStream
    "used for finalization to close the underlying zip-stream"

    zstream := aZStream.
! !

!CompressionStream methodsFor:'low level'!

z_nextAvailableInto:aCollection startingAt:offset maxCount:maxCount
    "read the next available bytes into a collection, a string or byteArray;
     returns the size read"

    |start count avail|

    avail := readLimit - position.
    avail > 0 ifFalse:[^ 0].

    count := aCollection size - offset + 1.
    count < 0 ifTrue:[
        self zerror:'invalid arguments'
    ].
    count == 0 ifTrue:[
        ^ 0
    ].

    count := avail min:count.
    maxCount notNil ifTrue:[ count := count min:maxCount ].

    start := position.
    position := position + count.

%{
    unsigned char * _dstPt;
    int             _count = __intVal( count );
    int             _offset = __intVal( offset );
    unsigned char * _srcPt;
    OBJ             _srcObj = __INST( outputBytes );

    if( __isBytes(aCollection) ) {
        _dstPt = (unsigned char *) (__byteArrayVal(aCollection));
    } else if (__isStringLike(aCollection)) {
        _dstPt = (unsigned char *) (__stringVal( aCollection));
    } else {
        goto error;
    }

    _dstPt  = _dstPt + _offset - 1;

    _srcPt  = (unsigned char *) __externalBytesAddress( _srcObj );
    _srcPt += __intVal( start );

    memcpy(_dstPt, _srcPt, _count);

    RETURN(__MKSMALLINT(_count));

error: ;
%}.

    ^ self zerror:'invalid argument'
!

zclose
    "low level close of the zip stream"

    ^ self subclassResponsibility
!

zdeflate
    "low level - deflate
     returns false if the deflate operation is finished otherwise true"

    ^ self subclassResponsibility
!

zdeflateInit
    "low level - deflateInit
     initialize the deflate mode, write header"

    ^ self subclassResponsibility
!

zget_avail_out
    "low level - get the number of available out bytes"

    ^ self subclassResponsibility
!

zinflate
    "low level - inflate
     returns nil if at uncompress is finished, or the number of
     available bytes in the output-buffer"

    ^ self subclassResponsibility
!

zinflateInit
    "low level - inflateInit
     initialize the inflate mode, read and check header"

    ^ self subclassResponsibility
!

zopen
    "low level - opens the zip stream
     create the resources"

    ^ self subclassResponsibility
!

zset_avail_in:count
    "set the 'avail_in' and compute the crc"

    ^ self subclassResponsibility
! !

!CompressionStream methodsFor:'private'!

closeZStream
    "close the zip-stream"

    onStream := mode := nil.
    hitEOF   := true.

    zstream notNil ifTrue:[
        self unregisterForFinalization.
        self zclose.
        zstream := nil.
    ].

    "Modified: / 08-08-2010 / 14:40:41 / cg"
!

contentsSpecies
    "return the kind of object to be returned by sub-collection builders"

    binary ifTrue:[^ ByteArray].
    ^ String
!

fillBuffer
    "Fill the inputBytes buffer.
     returns true if data is available for reading;
     false if the stream is at end.
     Updates the readLimit and position."

    hitEOF ifTrue:[
        ^ false.
    ].

    position >= readLimit ifTrue:[
        [(readLimit := self zinflate) == 0] whileTrue:[
            |n|

            [
                n := onStream nextAvailableBytes:(inputBytes size) into:inputBytes startingAt:1.
                n == 0 ifTrue:[
                    onStream atEnd ifTrue:[
                        hitEOF := true.
                        ^ false.
                    ] ifFalse:[
                        "must be a socket or pipe"
                        onStream readWait.
                    ].
                ].
                n == 0
            ] whileTrue.
            self zset_avail_in:n.
        ].
        readLimit isNil ifTrue:[
            hitEOF := true.
            ^ false
        ].
        position := 0.
    ].
    ^ true
!

onStreamPutBytes:count from:data
    "write compressed data to the (output) stream"

    onStream nextPutBytes:count from:data startingAt:1
! !

!CompressionStream methodsFor:'queries'!

atEnd
    "return true if the end of the compressed input stream has been reached"

    ^ self fillBuffer not
!

isBinary
    "return true, if the stream is in binary (as opposed to text-) mode.
     The default when created is false"

    ^ binary
!

isHeaderAndChecksumSuppressed
    "answer true if the checksum and header are suppressed;
    the default is true (backward compatibility)"

    suppressHeaderAndChecksum isNil ifTrue:[
        ^ self class defaultSuppressHeaderAndChecksum
    ].
    ^ suppressHeaderAndChecksum
!

isOpen
    "return true, if this stream is open"

    ^ onStream notNil
!

isReadable
    "return true, if this stream can be read from"

    ^ mode == #readonly
!

isWritable
    "return true, if this stream can be written to"

    ^ mode == #writeonly
! !

!CompressionStream methodsFor:'reading'!

contents
    "return the entire contents of and close the stream"

    |species stream bfsize buffer count|

    mode ~~ #readonly ifTrue:[
        self errorWriteOnly
    ].
    species := self contentsSpecies.
    self fillBuffer ifFalse:[
        "at end"
        ^ species new.
    ].

    bfsize := outputBytes size.
    buffer  := species new:bfsize.
    stream  := WriteStream on:(species new:bfsize).

    [
        count := self z_nextAvailableInto:buffer startingAt:1 maxCount:nil.

        count == bfsize ifTrue:[
            stream nextPutAll:buffer.
        ] ifFalse:[
            count > 0 ifTrue:[
                stream nextPutAll:buffer startingAt:1 to:count.
            ]
        ].
        self fillBuffer
    ] whileTrue.
    self close.
    ^ stream contents
!

next
    "return the next element,
     as character (text mode) or byte (binary mode). 
     Possibly raises ReadPastEnd error, if there are no more elements"

    |byte|

    (byte := self nextByte) isNil ifTrue:[
        "there is no more element; the stream is at end"
        ^ nil
    ].
    binary ifTrue:[^ byte ].
    ^ Character value:byte
!

next:n
    "return the next count elements of the stream as a collection.
     Redefined to return a String or ByteArray and for optimization"

    |data count species|

    mode ~~ #readonly ifTrue:[
        self errorWriteOnly
    ].
    species := self contentsSpecies.

    hitEOF ifTrue:[
        "This normally raises an error. If you proceed, you get what has been collected (nothing)."
        self pastEndRead.
        ^ species new
    ].
    data := species new:n.
    count := self next:n into:data startingAt:1.
    count = n ifTrue:[
        ^ data.
    ].
    "This normally raises an error. If you proceed, you get what has been collected."
    self pastEndRead.
    ^ data copyFrom:1 to:count.
!

next:n into:aBuffer startingAt:startIndex
    "read the next n elements of the stream into aBuffer.
     Return the number of bytes read."

    |count remaining offset|

    mode ~~ #readonly ifTrue:[
        self errorWriteOnly
    ].
    self fillBuffer ifFalse:[
        self pastEndRead isNil ifTrue:[^ 0].
    ].
    offset := startIndex.
    remaining := n.

    [
        count  := self z_nextAvailableInto:aBuffer startingAt:offset maxCount:remaining.
        offset := count + offset.
        remaining := remaining - count.
        remaining ~~ 0 and:[self fillBuffer]
    ] whileTrue.
    ^ n - remaining
!

nextByte
    "return the next element, a byte 
     raise an error, if there are no more elements"

    mode ~~ #readonly ifTrue:[
        self errorWriteOnly
    ].
    position >= readLimit ifTrue:[
        self fillBuffer ifFalse:[
            "there is no more element; the stream is at end"
            ^ self pastEndRead.
        ].
    ].    
    position := position + 1.
    ^ outputBytes at:position.
!

nextByteOrNil
    "return the next element, a byte 
     return nil, if there are no more elements"

    mode ~~ #readonly ifTrue:[
        self errorWriteOnly
    ].
    position >= readLimit ifTrue:[
        self fillBuffer ifFalse:[
            "there is no more element; the stream is at end"
            ^ nil.
        ].
    ].
    position := position + 1.
    ^ outputBytes at:position.
!

nextBytes:numBytes into:aByteCollection startingAt:initialIndex
    "can do it faster here than in super class"

    ^ self next:numBytes into:aByteCollection startingAt:initialIndex.
!

nextOrNil
    "return the next element, 
     as character (text mode) or byte (binary mode). 
     return nil, if there are no more elements"

    |byte|

    (byte := self nextByteOrNil) isNil ifTrue:[
        "there is no more element; the stream is at end"
        ^ nil
    ].
    binary ifTrue:[^ byte].
    ^ Character value:byte
!

skip:count
    "skip count objects, return the receiver
     redefined for optimization"

    |n avail|

    mode ~~ #readonly ifTrue:[
        self errorWriteOnly
    ].

    n := count.
    n <= 0 ifTrue:[
        n ~~ 0 ifTrue:[
            "don't know how to unread ..."
            PositionError raiseRequest
        ].
        ^ self
    ].

    [self fillBuffer] whileTrue:[
        avail := readLimit - position.
        avail >= n ifTrue:[
            position := position + n.
            ^ self
        ].
        position := readLimit := 0. "/ reset input
        n := n - avail.
    ].
! !

!CompressionStream methodsFor:'startup & release'!

close
    "close the zip-stream"

    hitEOF := true.
    zstream notNil ifTrue:[
        self flush.
        self closeZStream.
    ].

    (propagateClose and:[onStream notNil]) ifTrue:[
        onStream close.
    ].
!

openWithMode:aMode on:aStream
    "open the zip-stream on a stream
     can be reimplemented to do some additional stuff (e.g. gzip header) like
     in the ZipStream
    "

    ^ self
        openWithMode:aMode
        on:aStream
        suppressHeaderAndChecksum:(self class defaultSuppressHeaderAndChecksum)
!

openWithMode:aMode on:aStream suppressHeaderAndChecksum:aBoolean
    "open the zip-stream on a stream
     can be reimplemented to do some additional stuff (e.g. gzip header) like
     in the ZipStream
    "

    ^ self
        streamOpenWithMode:aMode
        on:aStream
        suppressHeaderAndChecksum:aBoolean
!

setInputStream:aStream
    "change the input stream (i.e. continue reading from aStream).
     Useful if the input arrives in chunks, and we have to continue decompressing
     from the next chunk (passing a readStream on the next chunk here)."

    mode ~~ #readonly ifTrue:[
        self errorWriteOnly
    ].
    onStream := aStream.
!

streamOpenWithMode:aMode on:aStream

    ^ self
        streamOpenWithMode:aMode
        on:aStream
        suppressHeaderAndChecksum:(self class defaultSuppressHeaderAndChecksum)
!

streamOpenWithMode:aMode on:aStream suppressHeaderAndChecksum:aBoolean
    "open the compression stream on a stream
         #readonly    uncompress the data derived from the read-stream,  aStream
         #writeonly   compress   the data and write to the write-stream, aStream
    "

    aStream isNil ifTrue:[
        ^ self errorNotOpen
    ].

    propagateClose := false.
    onStream    := aStream.
    mode        := aMode.
    outputBytes := ExternalBytes unprotectedNew:16384.
    inputBytes  := ExternalBytes unprotectedNew:16384.
    readLimit   := position := 0.
    binary      := false.
    suppressHeaderAndChecksum := aBoolean.

    self zopen.
    self registerForFinalization.

    hitEOF := false.

    aMode == #readonly ifTrue:[
        self zinflateInit.
    ] ifFalse:[
        self zdeflateInit
    ].
! !

!CompressionStream methodsFor:'writing'!

contents:contents
    "write the entire contents to and close the stream"

    self nextPutAll:contents.
    self close.
!

flush
    "flush the input and output buffer"

    |continue availOut|

    self isWritable ifFalse:[^ self].
    self zset_avail_in:position.

    position := 0.

    [   continue := self zdeflate.
	availOut := self zget_avail_out.

	availOut > 0 ifTrue:[
	    self onStreamPutBytes:availOut from:outputBytes
	].

    ] doWhile:[ continue == true ].
!

nextPut:aByteOrCharacter
    "write the argument, aByteOrCharacter"

    position == inputBytes size ifTrue:[self flush].
    position := position + 1.
    inputBytes at:position put:aByteOrCharacter asInteger.
!

nextPutAll:aCollection
    |limit|

    limit := inputBytes size.

    aCollection do:[:aByteOrCharacter|
        position == limit ifTrue:[self flush].
        position := position + 1.
        inputBytes at:position put:aByteOrCharacter asInteger.
    ].
! !

!CompressionStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


CompressionStream initialize!
