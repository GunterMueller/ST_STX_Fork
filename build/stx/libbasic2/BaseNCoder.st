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

ObjectCoder subclass:#BaseNCoder
	instanceVariableNames:'buffer bits charCount peekByte atEnd lineLimit'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Storage'
!

!BaseNCoder class methodsFor:'documentation'!

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
    Abstract superclass of Base64Coder and Base32Coder
    Their main entry point API is 
        <BaseNCoder> encode:aStringOrBytes
    and
        <BaseNCoder> decode:aString

    If the decoder should return a string, use
        <BaseNCoder> decodeAsString:aString.

    [examples:]
        Base64Coder encode:'helloWorld'
        
        Base64Coder decode:'aGVsbG9Xb3JsZA=='
        
        Base64Coder decodeAsString:'aGVsbG9Xb3JsZA=='
        
    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        buffer          SmallInteger   buffered data
        bits            SmallInteger   Number of valid bits in buffer
        charCount       SmallInteger   Number of characters since last cr
        atEnd           Boolean        true if end of Base64 string reached

    [class variables:]

    [see also:]

"
! !

!BaseNCoder class methodsFor:'initialization'!

initializeMappings
    self subclassResponsibility
! !

!BaseNCoder class methodsFor:'instance creation'!

new
   self initializeMappings.
   ^ self basicNew initialize
! !

!BaseNCoder class methodsFor:'decoding'!

decodeAsString:encodedString
    "decode a base-n encoded string.
     We already expect a string instead of a ByteArray"

    ^ (self on:encodedString readStream) stringUpToEnd
! !

!BaseNCoder methodsFor:'accessing'!

lineLimit:something
    "set the line length of the encoded output.
     Default is a line length of 76 characters.

     If nil, no line breaks will be done."

    lineLimit := something.
! !

!BaseNCoder methodsFor:'decoding'!

next
    "answer the next decoded byte"

    |b|

    peekByte notNil ifTrue:[
        b := peekByte.
        peekByte := nil.
        ^ b
    ].
    ^ self basicNext.
!

next:count
    "return the next count bytes of the stream as ByteArray"

    |answerStream 
     cnt  "{ Class: SmallInteger }" |

    cnt := count.
    answerStream := WriteStream on:(ByteArray new:cnt).
    answerStream signalAtEnd:true.
    1 to:cnt do:[:index |
        |next|

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
!

peek
    "answer the next decoded byte. Do not consume this byte"

    peekByte isNil ifTrue:[
        peekByte := self basicNext.
    ].
    ^ peekByte
! !

!BaseNCoder methodsFor:'encoding'!

visitByteArray:aByteArray with:aParameter 
    ^ self
        nextPutBytes:aByteArray;
        flush.

    "
      Base64Coder encodingOf:#[1 2 3 4 5 6 255]
    "
!

visitObject:anObject with:aParameter
    "not defined. Use nextPut or nextPutAll:.
     Could encode the printString here"

    ^ self shouldNotImplement
!

visitStream:aStream with:aParameter
    aStream copyToEndInto:self.
    self flush.

    "
      Base64Coder encodingOf:#[1 2 3 4 5 6 255]
      Base64Coder encodingOf:#[1 2 3 4 5 6 255] readStream
    "
!

visitString:aString with:aParameter 
    ^ self
        nextPutAll:aString;
        flush.

    "
      |encoded decoded decoder|

      encoded := Base64Coder encode:'hello world'.  
      decoded := #[] writeStream.
      decoder := Base64Coder on:encoded readStream.
      [decoder atEnd] whileFalse:[
          decoded nextPut:(decoder next).
      ].
      decoded := decoded contents.
      decoded asString.    
    "
! !

!BaseNCoder methodsFor:'initialization'!

emptyWriteStream
    "answer an empty stream. We encode as string"
    
    ^ WriteStream on:(String new:64)
!

initialize

    buffer := bits := charCount := 0.
    lineLimit := 76.   "RFC 2045 says: max 76 characters in one line"
    atEnd := false.
! !

!BaseNCoder methodsFor:'misc'!

reset
    "reset to initial state"

    super reset.
    buffer := bits := charCount := 0.
    atEnd := false.
    peekByte := nil.
! !

!BaseNCoder methodsFor:'private'!

basicNext
    "answer the next decoded byte. 
     No peekByte handling is done here."

    |b|

    bits == 0 ifTrue:[
        self fillBuffer.
        bits == 0 ifTrue:[
            ^ stream pastEndRead.
        ]
    ].
    b := (buffer bitShift:(8 - bits)) bitAnd:16rFF.
    bits := bits - 8.

    ^ b.
! !

!BaseNCoder methodsFor:'queries'!

atEnd
    "answer true, if no more bytes can be read"

    bits == 0 ifTrue:[
        atEnd ifTrue:[^ true].
        self fillBuffer.
        bits == 0 ifTrue:[^ true].
    ].
    ^ false.
!

binary
    "switch to binary mode - nothing is done here.
     Defined for compatibility with ExternalStream."

    ^ self
!

isStream
    "we simulate a stream"

    ^ true
! !

!BaseNCoder methodsFor:'stream compatibility'!

nextBytesInto:anObject startingAt:offset
    "copy bytes into anObject starting at offset"

    |off|

    off := offset.
    [self atEnd] whileFalse:[
        anObject at:off put:self next.
        off := off + 1.
    ].
    ^ off - offset
!

nextPut:aByte
    "encode aByte on the output stream"

    ^ self nextPutByte:aByte asInteger.
!

nextPutAll:aCollection startingAt:first to:last
    "append the elements with index from first to last
     of the argument, aCollection onto the receiver."

    aCollection from:first to:last do:[:element |
        self nextPutByte:element
    ].
    ^ aCollection
!

nextPutBytes:aCollectionOfBytes
    "encode all objects from the argument"

    aCollectionOfBytes do:[:o |
        self nextPutByte:o
    ]
!

stringUpToEnd
    "return a collection of the elements up-to the end"

    |answerStream|

    answerStream := WriteStream on:(String new:128).
    peekByte notNil ifTrue:[
        answerStream nextPut:(Character codePoint:peekByte).
        peekByte := nil.
    ].
    [
        [bits >= 8] whileTrue:[
            answerStream nextPut:(Character codePoint:((buffer bitShift:(8 - bits)) bitAnd:16rFF)).
            bits := bits - 8.
        ].
        atEnd ifTrue:[
            bits ~~ 0 ifTrue:[
                answerStream nextPut:(Character codePoint:(buffer bitAnd:16rFF)).
                bits := 0.
            ]
        ] ifFalse:[
            self fillBuffer.
        ].
    ] doWhile:[bits > 0].

    ^ answerStream contents
!

upToEnd
    "return a collection of the elements up-to the end"

    |answerStream|

    answerStream := WriteStream on:(ByteArray new:128).
    peekByte notNil ifTrue:[
        answerStream nextPut:peekByte.
        peekByte := nil.
    ].
    [
        [bits >= 8] whileTrue:[
            answerStream nextPut:((buffer bitShift:(8 - bits)) bitAnd:16rFF).
            bits := bits - 8.
        ].
        atEnd ifTrue:[
            bits ~~ 0 ifTrue:[
                answerStream nextPut:(buffer bitAnd:16rFF).
                bits := 0.
            ]
        ] ifFalse:[
            self fillBuffer.
        ].
    ] doWhile:[bits > 0].

    ^ answerStream contents
! !

!BaseNCoder methodsFor:'subclass responsibility'!

fillBuffer
    "fill buffer with next n characters each representing m bits"

    ^ self subclassResponsibility.
!

flush
    "flush the remaining bits of buffer. 
     The number of bits in buffer is not a multiple of m, so we pad
     the buffer and signal that padding has been done via $= characters."

    ^ self subclassResponsibility.
!

nextPutByte:aByte
    "encode aByte on the output stream"

    ^ self subclassResponsibility.
! !

!BaseNCoder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

