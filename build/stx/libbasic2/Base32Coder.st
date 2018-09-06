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

BaseNCoder subclass:#Base32Coder
	instanceVariableNames:''
	classVariableNames:'Base32Mapping Base32ReverseMapping'
	poolDictionaries:''
	category:'System-Storage'
!

!Base32Coder class methodsFor:'documentation'!

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
    Instances of this class perform Base32 en- and decoding as defined in RFC 3548
    5 bytes are mapped to 8 characters, representing 5 bits each.

    [author:]
        Stefan Vogel

    [see also:]

    [instance variables:]

    [class variables:]
        Base32Mapping         String   Mapping from bytes (with 5 valid bits)   
                                       to Base32 characters
        Base32ReverseMapping  Array    Mapping from Base32 characters to 5-bit-Bytes
"
!

examples
"
                                                                [exBegin]
   0 to:16 do:[:l |
        |coder decoder data encoding decoded|

        data := (0 to:l) asByteArray copyTo:l.
        coder := Base32Coder on:'' writeStream.
        coder nextPutAll:data.
        coder flush.

        encoding := coder contents.

        decoder := Base32Coder on:encoding readStream.
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
   text := Base32Coder encode:data1.
   data2 := Base32Coder decode:text.
   data2  
                                                                [exEnd]

                                                                [exBegin]
   |coder|

   coder := Base32Coder on:'' writeStream.
   coder nextPutAll:#[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19].
   coder flush.
   coder contents inspect.
   coder reset.
   coder nextPut:254.
   coder contents inspect.
                                                                [exEnd]

                                                                [exBegin]
   |coder decoder|

   coder := Base32Coder on:'' writeStream.
   coder nextPutAll:#[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20].
   coder flush.

   decoder := Base32Coder on:(coder contents readStream).
   [decoder atEnd] whileFalse:[
      Transcript show:decoder next
   ].
   Transcript cr.
                                                                [exEnd]
                                                                [exBegin]
   |coder|

   coder := Base32Coder on:'' writeStream.
   coder nextPutAll:(0 to:200) asByteArray.
   coder flush.

   Transcript showCR:(coder contents).
                                                                [exEnd]
"
! !

!Base32Coder class methodsFor:'initialization'!

initializeMappings
    "initialize class variables"
    
    Base32Mapping isNil ifTrue:[
        "33 characters representing the 5-bit values from 0-31 and one pad character"
        Base32Mapping := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567='.
        Base32ReverseMapping := ByteArray new:96 withAll:255.
        Base32Mapping keysAndValuesDo:[:idx :char|
            Base32ReverseMapping at:char codePoint put:idx-1.
        ].
    ].

    "
     self initializeMappings
    "
! !

!Base32Coder methodsFor:'encoding'!

nextPutByte:aByte
    "encode aByte on the output stream"

    "RFC 2045 says: max 76 characters in one line"
    (lineLimit notNil and:[charCount >= lineLimit]) ifTrue:[
        stream cr.
        charCount := 0.
    ].

    buffer := (buffer bitShift:8) bitOr:aByte.
    bits := bits + 8 - 5.           "max value of bits = 4 + 8 - 5"

    bits >= 5 ifTrue:[
        "enough bits to write two chars: write the first 5 bits"
        stream nextPut:(Base32Mapping at:(buffer rightShift:bits)+1).
        "clear the first 5 bits"
        buffer := buffer bitAnd:(1 bitShift:bits)-1.
        charCount := charCount + 1.
        bits := bits - 5.
    ].

    "write 5 bits"
    stream nextPut:(Base32Mapping at:(buffer rightShift:bits)+1).
    "clear the first 5 bits"
    buffer := buffer bitAnd:(1 bitShift:bits)-1.
    charCount := charCount + 1.
! !

!Base32Coder methodsFor:'misc'!

flush
    "flush the remaining bits of buffer. 
     The number of bits in buffer is not a multiple of 6, so we pad
     the buffer and signal that padding has been done via $= characters."
        
    |shift|

    bits == 0 ifTrue:[
        "buffer is empty, nothing to do"
        ^ self.
    ].

    "RFC 2045 says: max 76 characters in one line"
    (lineLimit notNil and:[charCount >= lineLimit]) ifTrue:[
        stream cr.
        charCount := 0.
    ].

    shift := 5 - bits.
    buffer := buffer bitShift:shift.

    stream nextPut:(Base32Mapping at:buffer+1).
    bits := bits + 3.
    [
        "simulate adding 8 bits and removing 5 bits, until we get a multiple of 8"
        stream nextPut:$=.
        bits := bits + 8 - 5.
    ] doUntil:[bits \\ 8 == 0].

    buffer := bits := 0.
! !

!Base32Coder methodsFor:'private'!

fillBuffer
    "fill buffer with next 8 characters each representing 5 bits"

    |b shift tempBuffer|

    tempBuffer := 0.
    bits := 0.
    [
        "read next valid Base64 character, skip invalid characters"
        [
            b := stream next.
            b isNil ifTrue:[ "end of stream"
                b := 32.     "simulate end-mark"
            ] ifFalse:[
                b := Base32ReverseMapping at:b codePoint ifAbsent:255.
            ]
        ] doWhile:[b == 255].

        b == 32 ifTrue:[
            "got $=, end of Base32 string has been reached.
             Strip fill bits"
            atEnd := true.
            bits > 8 ifTrue:[
                shift := bits \\ 8.
                tempBuffer := tempBuffer rightShift:shift.
                bits := bits - shift.
            ].
        ] ifFalse:[
            "got valid Base64 character, append to buffer"
            tempBuffer := (tempBuffer bitShift:5) bitOr:b.
            bits := bits + 5.
        ].
    ] doUntil:[bits == 40 or:[atEnd]].

    buffer := tempBuffer.
! !

!Base32Coder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

