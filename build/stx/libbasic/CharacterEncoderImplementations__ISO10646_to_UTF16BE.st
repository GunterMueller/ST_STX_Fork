"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: CharacterEncoderImplementations }"

TwoByteEncoder subclass:#ISO10646_to_UTF16BE
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO10646_to_UTF16BE class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
    encodes/decodes UTF16 BigEndian (big-end-first)

    Notice the naming (many are confused):
        Unicode is the set of number-to-glyph assignments
    whereas:
        UTF8, UTF16 etc. are a concrete way of xmitting Unicode codePoints (numbers).

    ST/X NEVER uses UTF8 or UTF16 internally - all characters are full 24bit characters.
    Only when exchanging data, are these converted into UTF8 (or other) byte sequences.
"
!

examples
"
  Encoding (unicode to utf16BE)
     ISO10646_to_UTF16BE encodeString:'hello'.


  Decoding (utf16BE to unicode):
     |t|

     t := ISO10646_to_UTF16BE encodeString:''.
     ISO10646_to_UTF16BE decodeString:t.

  Decoding (utf16LE-Bytes to unicode):
     |bytes|

     bytes := #[ 16r40 0 16r41 0 16r42 0 16r43 0 16r44 0 ].
     ISO10646_to_UTF16LE decodeString:bytes.
"
! !

!ISO10646_to_UTF16BE methodsFor:'encoding & decoding'!

decode:aCode
    ^ aCode
!

decodeString:aStringOrByteCollection
    "given a byteArray (2-bytes per character) or unsignedShortArray in UTF16 encoding,
     return a new string containing the same characters, in 8, 16bit (or more) encoding.
     Returns either a normal String, a TwoByte- or a FourByte-String instance.
     Only useful, when reading from external sources.
     This only handles up-to 30bit characters."

    |s newString bitsPerElementIn nextIn
     codeIn codeIn1 codeIn2 estimatedSize out|

    aStringOrByteCollection isByteArray ifTrue:[
        bitsPerElementIn := 8.
    ] ifFalse:[
        aStringOrByteCollection isString ifTrue:[
            bitsPerElementIn := aStringOrByteCollection bitsPerCharacter.
        ] ifFalse:[
            "can be a ShortArray"
            bitsPerElementIn := 16.
        ].
    ].

    s := aStringOrByteCollection readStream.
    bitsPerElementIn == 8 ifTrue:[
        s size odd ifTrue:[
            InvalidEncodingError raiseWith:aStringOrByteCollection errorString:' - size is not a multiple of 2 bytes'.
        ].
        nextIn := [self nextTwoByteValueFrom:s].
    ] ifFalse:[
        nextIn := [s next].
    ].

    estimatedSize := s size * bitsPerElementIn // 16.
    out := CharacterWriteStream on:(String new:estimatedSize).
    [s atEnd] whileFalse:[
        codeIn := nextIn value.
        codeIn <= 16rFF ifTrue:[
        ] ifFalse:[
            (codeIn between:16rD800 and:16rDBFF) ifTrue:[
                codeIn1 := codeIn.
                codeIn2 := nextIn value.
                codeIn := ((codeIn1 - 16rD800) bitShift:10)
                          +
                          (codeIn2 - 16rDC00)
                          + 16r00010000.
            ].
        ].
        out nextPut:(Character value:codeIn).
    ].
    newString := out contents.

"/    nBitsRequired := 8.
"/    sz := 0.
"/    [s atEnd] whileFalse:[
"/        codeIn := nextIn value.
"/        sz := sz + 1.
"/
"/        codeIn <= 16rFF ifTrue:[
"/        ] ifFalse:[
"/            nBitsRequired := nBitsRequired max:16.
"/            (codeIn between:16rD800 and:16rDBFF) ifTrue:[
"/                nBitsRequired := 32.
"/                codeIn2 := nextIn value.
"/            ].
"/        ]
"/    ].
"/
"/    nBitsRequired == 8 ifTrue:[
"/        newString := String uninitializedNew:sz
"/    ] ifFalse:[
"/        nBitsRequired <= 16 ifTrue:[
"/            newString := Unicode16String new:sz
"/        ] ifFalse:[
"/            newString := Unicode32String new:sz
"/        ]
"/    ].
"/
"/    s := aStringOrByteCollection readStream.
"/    idx := 1.
"/    [s atEnd] whileFalse:[
"/        codeIn := nextIn value.
"/        codeIn <= 16rFF ifTrue:[
"/        ] ifFalse:[
"/            nBitsRequired := nBitsRequired max:16.
"/            (codeIn between:16rD800 and:16rDBFF) ifTrue:[
"/                nBitsRequired := 32.
"/                codeIn1 := codeIn.
"/                codeIn2 := nextIn value.
"/                codeIn := ((codeIn1 - 16rD800) bitShift:10)
"/                          +
"/                          (codeIn2 - 16rDC00)
"/                          + 16r00010000.
"/            ].
"/        ].
"/        newString at:idx put:(Character value:codeIn).
"/        idx := idx + 1.
"/    ].
    ^ newString

    "
     self new decodeString:#[ 16r00 16r42 ]            
     self new decodeString:#[ 16r01 16r42 ]            
     self new decodeString:#[ 16r00 16r48
                              16r00 16r69  
                              16rD8 16r00  
                              16rDC 16r00  
                              16r00 16r21  
                              16r00 16r21  
                            ]            

     self new decodeString:#( 16r0048
                              16r0069  
                              16rD800  
                              16rDC00  
                              16r0021  
                              16r0021  
                            )
    "

    "Modified: / 12-07-2012 / 19:56:12 / cg"
!

encode:aCode
    ^ aCode
!

encodeString:aUnicodeString
    "return the UTF-16 representation of a aUnicodeString.
     The resulting string is only useful to be stored on some external file,
     not for being used inside ST/X."

    |s|

    s := WriteStream on:(ByteArray uninitializedNew:aUnicodeString size).
    aUnicodeString do:[:eachCharacter |
        |codePoint t hi low|

        codePoint := eachCharacter codePoint.
        (codePoint <= 16rFFFF) ifTrue:[
            ((codePoint <= 16rD7FF) or:[ codePoint between:16rE000 and:16rFFFF]) ifTrue:[
                self nextPutTwoByteValue:codePoint to:s.
            ] ifFalse:[
                "/ unrepresentable: D800..DFFFF
                self error:'unrepresentable value (D800..DFFFF) in utf16Encode'.
            ].
        ] ifFalse:[
            t := codePoint - 16r00010000.
            hi := t bitShift:-10.
            low := t bitAnd:16r3FF.
            hi > 16r3FF ifTrue:[
                "/ unrepresentable: above 110000
                self error:'unrepresentable value (> 10FFFF) in utf16Encode'.
            ].
            self nextPutTwoByteValue:(hi + 16rD800) to:s.
            self nextPutTwoByteValue:(low + 16rDC00) to:s.
        ].
    ].

    ^ s contents

    "
     (self encodeString:'hello')                                         #[0 104 0 101 0 108 0 108 0 111]
     (self encodeString:(Character value:16r40) asString)                #[0 64]
     (self encodeString:(Character value:16rFF) asString)                #[0 255]
     (self encodeString:(Character value:16r100) asString)               #[1 0]
     (self encodeString:(Character value:16r1000) asString)              #[16 0]
     (self encodeString:(Character value:16r2000) asString)              #[32 0]
     (self encodeString:(Character value:16r4000) asString)              #[64 0]
     (self encodeString:(Character value:16r8000) asString)              #[128 0]
     (self encodeString:(Character value:16rD7FF) asString)              #[215 255]
     (self encodeString:(Character value:16rE000) asString)              #[224 0]
     (self encodeString:(Character value:16rFFFF) asString)              #[255 255]
     (self encodeString:(Character value:16r10000) asString)             #[216 64 220 0]
     (self encodeString:(Character value:16r10FFF) asString)             #[216 67 223 255]
     (self encodeString:(Character value:16r1FFFF) asString)             #[216 127 223 255]
     (self encodeString:(Character value:16r10FFFF) asString)            #[219 255 223 255]             
    error cases:
     (self encodeString:(Character value:16rD800) asString) 
     (self encodeString:(Character value:16rD801) asString) 
     (self encodeString:(Character value:16rDFFF) asString) 
     (self encodeString:(Character value:16r110000) asString)   
    "
! !

!ISO10646_to_UTF16BE methodsFor:'private'!

nextPutTwoByteValue:anInteger to:aStream
    aStream nextPutInt16MSB:anInteger
!

nextTwoByteValueFrom:aStream
    ^ aStream nextUnsignedInt16MSB:true
! !

!ISO10646_to_UTF16BE methodsFor:'queries'!

nameOfEncoding
    ^ #utf16be
! !

!ISO10646_to_UTF16BE class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

