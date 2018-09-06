"
 COPYRIGHT (c) 2004 by eXept Software AG
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

TwoByteEncoder subclass:#JIS0208_to_JIS7
	instanceVariableNames:''
	classVariableNames:'Jis7KanjiEscapeSequence Jis7RomanEscapeSequence
		JisISO2022EscapeSequence Jis7KanjiOldEscapeSequence'
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!JIS0208_to_JIS7 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
  Encoding (jis0208 to jis-7)
     |t|

     t := JIS0208_to_JIS7 decodeString:'hello'.
     JIS0208_to_JIS7 encodeString:t. 



 Decoding (jis-7 to jis0208):

     JIS0208_to_JIS7 decodeString:'hello'  

 ending with a crippled escape:

     |s|
     s := 'hello' copyWith:Character esc.
     JIS0208_to_JIS7 decodeString:s

     |s|
     s := 'hello' copyWith:Character esc.
     s := s copyWith:$A.
     JIS0208_to_JIS7 decodeString:s

     |s|
     s := 'hello' copyWith:Character esc.
     s := s copyWith:$$.
     JIS0208_to_JIS7 decodeString:s

     |s|
     s := 'hello' copyWith:Character esc.
     s := s copyWith:$$.
     s := s copyWith:$A.
     JIS0208_to_JIS7 decodeString:s

 ending with a KANJI-in,  but no more chars:

     |s|
     s := 'hello' copyWith:Character esc.
     s := s copyWith:$$.
     s := s copyWith:$B.
     JIS0208_to_JIS7 decodeString:s

 ending with a KANJI-in, followed by $3 (KO):

     |s|
     s := 'hello' copyWith:Character esc.
     s := s copyWith:$$.
     s := s copyWith:$B.
     s := s , '$3'.
     JIS0208_to_JIS7 decodeString:s

 ending with a KANJI-in, followed by $3$l$OF| (KO RE HA NI):

     |s|
     s := 'hello' copyWith:Character esc.
     s := s copyWith:$$.
     s := s copyWith:$B.
     s := s , '$3$l$OF|'.
     JIS0208_to_JIS7 decodeString:s

 a KO in between:

     |s|
     s := 'hello' copyWith:Character esc.
     s := s copyWith:$$.
     s := s copyWith:$B.
     s := s , '$3'.
     s := s copyWith:Character esc.
     s := s copyWith:$(.
     s := s copyWith:$B.
     s := s , 'hello'.
     JIS0208_to_JIS7 decodeString:s

 I dont know what that means ;-):

     |s t l|
     s := 'kterm ' copyWith:Character esc.
     s := s copyWith:$$.
     s := s copyWith:$B.
     s := s , '$N4A;zC<Kv%(%_%e%l!!<%?'.
     s := s copyWith:Character esc.
     s := s copyWith:$(.
     s := s copyWith:$B.
     s := s , ' kterm'.
     t := JIS0208_to_JIS7 decodeString:s.

     l := Label new.
     l label:t.
     l font:(Font family:'k14' face:nil style:nil size:nil).
     l font:(Font family:'gothic' size:17).
     l font:(Font family:'mincho' size:23).
     l realize
"
! !

!JIS0208_to_JIS7 class methodsFor:'queries'!

nameOfDecodedCode
    "I encode jis0208 into jis7 and vice versa"

    ^ #'jis0208'
! !

!JIS0208_to_JIS7 methodsFor:'encoding & decoding'!

decode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

decodeString:aString
    "given a string in JIS7 encoding,
     return a new string containing the same characters, in JIS0208 encoding.
     The argument is interpreted as a JIS7 or ISO2022-JP encoded singleByte string.
     There are various JIS encodings around (New-JIS, Old-JIS, NEC-JIS and ISO2022);
     this one understands New-JIS, ISO2022 and treats Old-JIS just the same.
     This conversion is only needed to convert strings as read from some external file.

     If you work a lot with jis7 encoded textFiles, 
     this is a first-class candidate for a primitive."

    |newString 
     sz         "{ Class: SmallInteger }"
     dstIdx     "{ Class: SmallInteger }"
     start      "{ Class: SmallInteger }"
     stop       "{ Class: SmallInteger }"
     n1 n2 n3  
     b1         "{ Class: SmallInteger }"
     b2         "{ Class: SmallInteger }"
     val        "{ Class: SmallInteger }"
     singleBytes katakana c|

    sz := aString size.
    newString := JISEncodedString new:sz.
    sz ~~ 0 ifTrue:[
        dstIdx := 1.
        start := 1.
        singleBytes := true.
        katakana := false.

        [true] whileTrue:[
            "/
            "/ scan for next escape"
            "/
            stop := aString indexOf:(Character esc) startingAt:start.
            stop == 0 ifTrue:[
                stop := sz + 1.
            ] ifFalse:[
                (stop + 2) > sz ifTrue:[
                    stop := sz + 1.
                ]
            ].
            singleBytes ifTrue:[
                start to:(stop - 1) do:[:i |
                    c := aString at:i.
                    newString at:dstIdx put:c.
                    dstIdx := dstIdx + 1.
                ].
            ] ifFalse:[
                start to:(stop - 2) by:2 do:[:i |
                    b1 := (aString at:i) codePoint.
                    b2 := (aString at:i+1) codePoint.
                    val := (b1 bitShift:8) bitOr:b2.
                    newString at:dstIdx put:(Character value:val).
                    dstIdx := dstIdx + 1.
                ]
            ].

            stop > sz ifTrue:[
                ^ newString copyFrom:1 to:dstIdx - 1.
            ].
            start := stop.

            "/
            "/ found an escape (at start) 
            "/ - check for KI (<ESC> '$' 'B') or OLD-JIS-KI (<ESC> '$' '@')
            "/ and KO(ASCII) (<ESC> '(' 'B') or KO(ROMAN) (<ESC> '(' 'J')
            "/
            n1 := aString at:start.
            n2 := aString at:(start + 1).
            n3 := aString at:(start + 2).
            katakana := false.

            (n2 == $$ and:[n3 == $B ]) ifTrue:[
                singleBytes := false.
            ] ifFalse:[
                (n2 == $$ and:[n3 == $@ ]) ifTrue:[
                    singleBytes := false.
                ] ifFalse:[
                    (n2 == $( and:[n3 == $B ]) ifTrue:[
                        singleBytes := true.
                    ] ifFalse:[
                        (n2 == $( and:[n3 == $J ]) ifTrue:[
                            singleBytes := true.
                        ] ifFalse:[
                            (n2 == $( and:[n3 == $I ]) ifTrue:[
                                singleBytes := true.
                                katakana := true.
                            ] ifFalse:[
                                singleBytes ifTrue:[
                                    newString at:dstIdx put:n1.
                                    newString at:(dstIdx + 1) put:n2.
                                    newString at:(dstIdx + 2) put:n3.
                                    dstIdx := dstIdx + 3.
                                ] ifFalse:[
                                    DecodingError 
                                            raiseWith:aString
                                            errorString:'JIS7 decoding failed (not JIS7 encoded ?)'.
                                    newString at:dstIdx put:n1.
                                    newString at:(dstIdx + 1) put:n2.
                                    newString at:(dstIdx + 2) put:n3.
                                    dstIdx := dstIdx + 3.
                                ]
                            ]
                        ]
                    ]
                ]
            ].
            start := start + 3.
            start > sz ifTrue:[
                ^ newString copyFrom:1 to:dstIdx-1.
            ]
        ]
    ].
    ^ newString
!

encode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

encodeString:aJISString
    "return a new string with aJISStrings characters as JIS7 encoded 7bit string,
     The receiver must be a JIS encoded character string.
     The resulting string is only useful to be stored on some external file,
     not for being used inside ST/X.

     If you work a lot with jis7 encoded textFiles, 
     this is a first-class candidate for a primitive."

    |sz "{ Class:SmallInteger }"
     b1 "{ Class:SmallInteger }"
     val romans out inSingleByteMode c kanji roman val2|

    inSingleByteMode := true.
    kanji := CharacterEncoder jis7KanjiEscapeSequence.
    roman := CharacterEncoder jis7RomanEscapeSequence.

    romans := CharacterEncoderImplementations::JIS0208 romanTable.

    sz := aJISString size.
    sz == 0 ifTrue:[^ ''].

    out := WriteStream on:(String new:(sz * 2)).

    1 to:sz do:[:srcIndex |
        c := aJISString at:srcIndex.
        b1 := c codePoint.
        b1 < 33 ifTrue:[
            "/ a control character
            inSingleByteMode ifFalse:[
                out nextPutAll:roman.
                inSingleByteMode := true
            ].
            out nextPut:c.
        ] ifFalse:[
            "/ check for a roman character
            "/ the two numbers below are romanTable min and romanTable max
            (b1 between:16r2121 and:16r2573) ifTrue:[
                val := romans indexOf:b1.
                val2 := val - 1 + 32.
                (val ~~ 0 and:[val2 <= 16r7F]) ifTrue:[
                    inSingleByteMode ifFalse:[
                        out nextPutAll:roman.
                        inSingleByteMode := true
                    ].
                    out nextPut:(Character value:val2)
                ] ifFalse:[
                    inSingleByteMode ifTrue:[
                        out nextPutAll:kanji.
                        inSingleByteMode := false
                    ].
                    out nextPut:(Character value:(b1 bitShift:-8)).
                    out nextPut:(Character value:(b1 bitAnd:16rFF)).
                ].
            ] ifFalse:[
                b1 <= 255 ifTrue:[
                    "/ mhmh - unrepresentable roman (national chars)
"/                    b1 >= 160 ifTrue:[
"/                        ('no rep for ' , b1 printString) printNL.
"/                    ].
                    "/ there are non-japanese characters in there...
                    "/ assume that is OK (leave as is) ...
"/                    EncodingFailedError
"/                        raiseWith:aJISString
"/                        errorString:'JIS7 encoding failed (contains 8-bit characters ?)'.

                    inSingleByteMode ifFalse:[
                        out nextPutAll:roman.
                        inSingleByteMode := true
                    ].
                    out nextPut:c
                ] ifFalse:[
                    inSingleByteMode ifTrue:[
                        out nextPutAll:kanji.
                        inSingleByteMode := false
                    ].
                    out nextPut:(Character value:(b1 bitShift:-8)).
                    out nextPut:(Character value:(b1 bitAnd:16rFF)).
                ]
            ]
        ].
    ].
    inSingleByteMode ifFalse:[
        out nextPutAll:roman.
    ].
    ^ out contents

    "simple:

     JIS0208_to_JIS7 encodeString:(JISEncodedString encodeRomans:'hello')
    "
! !

!JIS0208_to_JIS7 methodsFor:'queries'!

nameOfEncoding
    ^ #'jis7'
! !

!JIS0208_to_JIS7 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__JIS0208_to_JIS7.st,v 1.7 2004/03/12 09:15:11 ca Exp $'
! !



