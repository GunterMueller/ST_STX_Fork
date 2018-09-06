"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
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

TwoByteEncoder subclass:#ISO10646_to_JavaText
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO10646_to_JavaText class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
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
    Translates \uXXXX-escapes in the text
"
! !

!ISO10646_to_JavaText methodsFor:'encoding & decoding'!

decode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

decodeString:aStringOrByteCollection
    "given a string in JavaText encoding (i.e. with \uXXXX escaped characters),
     return a new string containing the same characters, in 16bit (or more) encoding.
     Returns either a normal String, a TwoByteString or a FourByteString instance.
     Only useful, when reading Java property and resource files.
     This only handles up-to 30bit characters."

    |nBits ch 
     in out codePoint t|

    nBits := 8.
    in := aStringOrByteCollection readStream.
    out := WriteStream on:(String new:10).
    [in atEnd] whileFalse:[
        ch := in next.
        ch == $\ ifTrue:[
            in peekOrNil == $u ifTrue:[
                in next.
                codePoint := 0.
                4 timesRepeat:[
                    ch := in peekOrNil.
                    codePoint := (codePoint * 16) + ch digitValue.
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
            ] ifFalse:[
                out nextPut:ch
            ]
        ] ifFalse:[
            out nextPut:ch
        ].
    ].
    ^ out contents

    "
     CharacterEncoderImplementations::ISO10646_to_JavaText
        decodeString:'AB\u1234CD' 
    "

    "Modified: / 23-10-2006 / 13:23:18 / cg"
!

encode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

encodeString:aUnicodeString
    "return the JavaText representation of aUnicodeString.
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
            out nextPutAll:'\u'.
            out nextPutAll:((codePoint printStringRadix:16) leftPaddedTo:4 with:$0).
        ].
    ].
    ^ out contents

    "
     CharacterEncoderImplementations::ISO10646_to_JavaText
        encodeString:'hello '  

     CharacterEncoderImplementations::ISO10646_to_JavaText
        decodeString:(CharacterEncoderImplementations::ISO10646_to_JavaText encodeString:'hello ') 
    "

    "Modified: / 23-10-2006 / 13:25:03 / cg"
! !

!ISO10646_to_JavaText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO10646_to_JavaText.st,v 1.1 2014-02-05 17:11:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO10646_to_JavaText.st,v 1.1 2014-02-05 17:11:06 cg Exp $'
! !

