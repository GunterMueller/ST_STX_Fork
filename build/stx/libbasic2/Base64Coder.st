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

BaseNCoder subclass:#Base64Coder
	instanceVariableNames:''
	classVariableNames:'Base64Mapping Base64ReverseMapping'
	poolDictionaries:''
	category:'System-Storage'
!

!Base64Coder class methodsFor:'documentation'!

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
    Instances of this class perform Base64 en- and decoding as defined in RFC 2045
    3 bytes are mapped to 4 characters, representing 6 bits each.
    The encoded string consists only of characters from the set:
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='

    Thei main entry point API is 
        Base64Coder encode:aStringOrBytes
    and
        Base64Coder decode:aString

    If the decoder should return a string, use
        Base64Coder decodeAsString:aString.

    [author:]
        Stefan Vogel

    [see also:]

    [instance variables:]

    [class variables:]
        Base64Mapping         String   Mapping from bytes (with 6 valid bits)   
                                       to Base64 characters
        Base64ReverseMapping  Array    Mapping from Base64 characters to 6-bit-Bytes
"
!

examples
"
                                                                [exBegin]
   (Base64Coder encode:'queen%27s%20gambit') asString = 'cXVlZW4lMjdzJTIwZ2FtYml0'
                                                                [exEnd]

                                                                [exBegin]
   (Base64Coder decode:'cXVlZW4lMjdzJTIwZ2FtYml0') asString = 'queen%27s%20gambit'
                                                                [exEnd]

                                                                [exBegin]
   0 to:16 do:[:l |
        |coder decoder data encoding decoded|

        data := (0 to:l) asByteArray copyTo:l.
        coder := Base64Coder on:'' writeStream.
        coder nextPutAll:data.
        coder flush.

        encoding := coder contents.

        decoder := Base64Coder on:encoding readStream.
        decoded := decoder upToEnd.
        Transcript showCR:(data printString).
        Transcript show:' -> '; showCR:encoding.
        Transcript show:' ---> '; showCR:(decoded printString).
        self assert:(data = decoded).
   ].
                                                                [exEnd]
                                                                [exBegin]
   |data1 text data2|

   data1 := #[0 1 16r7F 16r80 16r81 16rFE 16rFF].
   text := Base64Coder encode:data1.
   data2 := Base64Coder decode:text.
   data2  
                                                                [exEnd]

                                                                [exBegin]
   |coder|

   coder := Base64Coder on:'' writeStream.
   coder nextPutAll:#[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19].
   coder flush.
   coder contents inspect.
   coder reset.
   coder nextPut:254.
   coder contents inspect.
                                                                [exEnd]

                                                                [exBegin]
   |coder decoder|

   coder := Base64Coder on:'' writeStream.
   coder nextPutAll:#[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20].
   coder flush.

   decoder := Base64Coder on:(coder contents readStream).
   [decoder atEnd] whileFalse:[
      Transcript show:decoder next
   ].
   Transcript cr.
                                                                [exEnd]
                                                                [exBegin]
   |coder|

   coder := Base64Coder on:'' writeStream.
   coder nextPutAll:(0 to:200) asByteArray.
   coder flush.

   Transcript showCR:(coder contents).
                                                                [exEnd]
"
! !

!Base64Coder class methodsFor:'initialization'!

initializeMappings
    "initialize class variables"

    Base64Mapping isNil ifTrue:[
        "65 characters representing the 6-bit values from 0-63 and one pad character"
        Base64Mapping := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='.
        Base64ReverseMapping := ByteArray new:128 withAll:255.
        Base64Mapping keysAndValuesDo:[:idx :char|
            Base64ReverseMapping at:char codePoint put:idx-1.
        ].
    ].

    "
     self initializeMappings
    "
! !

!Base64Coder methodsFor:'encoding'!

nextPutByte:aByte
    "encode aByte on the output stream"

    |b1 b2 b3 b4|

    buffer := (buffer bitShift:8) bitOr:aByte.
    bits := bits + 8.
    bits == 24 ifTrue:[
        "RFC 2045 says: max 76 characters in one line"
        (lineLimit notNil and:[charCount >= lineLimit]) ifTrue:[
            stream cr.
            charCount := 0.
        ].

        b4 := buffer bitAnd:16r3F.
        b3 := (buffer bitShift:-6)  bitAnd:16r3F.
        b2 := (buffer bitShift:-12) bitAnd:16r3F.
        b1 := (buffer bitShift:-18) bitAnd:16r3F.
        buffer := bits := 0.
        stream nextPut:(Base64Mapping at:b1+1);
               nextPut:(Base64Mapping at:b2+1);
               nextPut:(Base64Mapping at:b3+1);
               nextPut:(Base64Mapping at:b4+1).

        charCount := charCount + 4.
    ].
! !

!Base64Coder methodsFor:'misc'!

flush
    "flush the remaining bits of buffer. 
     The number of bits in buffer is not a multiple of 6, so we pad
     the buffer and signal that padding has been done via $= characters."

    |b1 b2 b3 b4|
        
    bits == 0 ifTrue:[
        "buffer is empty, nothing to do"
        ^ self.
    ].
            
    bits == 8 ifTrue:[
        buffer := buffer bitShift:4.
        b4 := b3 := 64. "pad with '=='"
        b1 := (buffer bitShift:-6) bitAnd:16r3F.
        b2 := buffer bitAnd:16r3F.
    ] ifFalse:[
        bits = 16 ifTrue:[
            buffer := buffer bitShift:2.
            b4 := 64.        "pad with '='"
            b3 := buffer bitAnd:16r3F.
            b2 := (buffer bitShift:-6)  bitAnd:16r3F.
            b1 := (buffer bitShift:-12) bitAnd:16r3F.
        ]
    ].
    bits := buffer := 0.

    "RFC 2045 says: max 76 characters in one line"
    (lineLimit notNil and:[charCount >= lineLimit]) ifTrue:[
        stream cr.
        charCount := 0.
    ].

    stream nextPut:(Base64Mapping at:b1+1);
           nextPut:(Base64Mapping at:b2+1);
           nextPut:(Base64Mapping at:b3+1);
           nextPut:(Base64Mapping at:b4+1).
    charCount := charCount + 4.
! !

!Base64Coder methodsFor:'private'!

fillBuffer
    "fill buffer with next 4 characters each representing 6 bits"

    |b shift tempBuffer "{Class: SmallInteger}"|

    tempBuffer := 0.
    bits := 0.
    [
        "read next valid Base64 character, skip invalid characters"
        b := 255.
        [b == 255] whileTrue:[
            b := stream next.
            b isNil ifTrue:[ "end of stream"
                b := 64.     "simulate end-mark"
            ] ifFalse:[
                b := Base64ReverseMapping at:b codePoint ifAbsent:255.
            ]
        ].

        b == 64 ifTrue:[
            "got $=, end of Base64 string has been reached"
            atEnd := true.
            bits == 12 ifTrue:[
                "data has been padded to 12, skip 4 bits"
                shift := -4.
            ] ifFalse:[bits == 18 ifTrue:[
                "data has been padded to 18, skip 2 bits"
                shift := -2.
            ] ifFalse:[
                shift := 0.
            ]].
            tempBuffer := tempBuffer bitShift:shift.
            bits := bits + shift.
        ] ifFalse:[
            "got valid Base64 character, append to buffer"
            tempBuffer := (tempBuffer bitShift:6) bitOr:b.
            bits := bits + 6.
        ].
        (bits == 24 or:[atEnd]) ifTrue:[
            buffer := tempBuffer.
            ^ self.
        ].
    ] loop.
! !

!Base64Coder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

