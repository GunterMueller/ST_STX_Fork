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

TwoByteEncoder subclass:#ISO10646_to_SGML
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO10646_to_SGML class methodsFor:'documentation'!

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

documentation
"
    Incomplete - only knows how to encode/decode escaped decimal-code characters
    (i.e. &#nnnn; )

    TODO:
        add all other characters
        reuse this code in XML and HTML processing code.
"
! !

!ISO10646_to_SGML methodsFor:'encoding & decoding'!

decode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

decodeString:aStringOrByteCollection
    "given a string in SGML encoding (i.e. with SGML escaped characters),
     return a new string containing the same characters, in 16bit (or more) encoding.
     Returns either a normal String, a TwoByteString or a FourByteString instance.
     Only useful, when reading from external sources.
     This only handles up-to 30bit characters."

    |nBits ch 
     in out codePoint t|

    nBits := 8.
    in := aStringOrByteCollection readStream.
    out := WriteStream on:(String new:10).
    [in atEnd] whileFalse:[
        ch := in next.
        ch == $& ifTrue:[
            in peekOrNil == $# ifTrue:[
                in next.
                codePoint := 0.
                [ch := in peekOrNil.
                 ch notNil and:[ch isDigit]
                ] whileTrue:[
                    codePoint := (codePoint * 10) + ch digitValue.
                    in next.
                ].
                codePoint > 16rFF ifTrue:[
                    codePoint > 16rFFFF ifTrue:[
                        nBits < 32 ifTrue:[
                            t := out contents.
                            out := WriteStream on:(Unicode32String fromString:t).
                            out position:t size.
                            nBits := 32.
                        ]
                    ] ifFalse:[
                        nBits < 16 ifTrue:[
                            t := out contents.
                            out := WriteStream on:(Unicode16String fromString:t).
                            out position:t size.
                            nBits := 16.
                        ]
                    ]
                ].
                out nextPut:(Character value:codePoint).
                in peekOrNil == $; ifTrue:[
                    in next.
                ]
            ] ifFalse:[
                out nextPut:ch
            ]
        ] ifFalse:[
            out nextPut:ch
        ].
    ].
    ^ out contents

    "
     CharacterEncoderImplementations::ISO10646_to_SGML
        decodeString:'&#1060;&#1072;&#1081;&#1083;' 

     CharacterEncoderImplementations::ISO10646_to_SGML
        decodeString:'#197;&bn...'
    "
!

encode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

encodeString:aUnicodeString
    "return the SGML representation of aUnicodeString.
     The resulting string is only useful to be stored on some external file,
     not for being used inside ST/X."

    |ch in out codePoint|

    in := aUnicodeString readStream.
    out := WriteStream on:(String new:10).
    [in atEnd] whileFalse:[
        ch := in next.
        codePoint := ch codePoint.
        (codePoint between:16r20 and:16r7F) ifTrue:[
            out nextPut:ch.
        ] ifFalse:[
            out nextPutAll:'&#'.
            out nextPutAll:(codePoint printString).
            out nextPutAll:';'.
        ].
    ].
    ^ out contents

    "
     CharacterEncoderImplementations::ISO10646_to_SGML
        encodeString:'hello ' 
    "

    "Modified: / 23-10-2006 / 13:25:27 / cg"
! !

!ISO10646_to_SGML class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO10646_to_SGML.st,v 1.3 2006/10/23 11:25:11 cg Exp $'
! !



