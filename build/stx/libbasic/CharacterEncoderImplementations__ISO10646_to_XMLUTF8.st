"
 COPYRIGHT (c) 2006 by eXept Software AG
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

ISO10646_to_UTF8 subclass:#ISO10646_to_XMLUTF8
	instanceVariableNames:''
	classVariableNames:'ReplacementCharacter'
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO10646_to_XMLUTF8 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    This encoder encodes characters into utf8 characters that may
    occur in XML document.

    Not all UTF characters are valid in XML, whatever encoding
    is used. For a reference, see 

      http://www.w3.org/TR/2000/REC-xml-20001006#NT-Char   

    Invalid characters are replaced by ReplacementCharacter
    with $? as default.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        http://www.w3.org/TR/2000/REC-xml-20001006#NT-Char

"
! !

!ISO10646_to_XMLUTF8 class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    ReplacementCharacter := $?.

    "Modified: / 30-06-2012 / 19:55:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ISO10646_to_XMLUTF8 methodsFor:'encoding & decoding'!

encodeString:aUnicodeString
    "return the UTF-8 representation of a aUnicodeString.
     The resulting string contains only valid XML unicode
     characters. Invalid characters are replaced by a
     ReplacementCharacter. For details, please see

     http://www.w3.org/TR/2000/REC-xml-20001006#NT-Char

    "

    |s|

    "Copy-paste of superclass's method and tweaked. Not ideal, but
     but avoids 1 string copy"

    s := WriteStream on:(String uninitializedNew:aUnicodeString size).
    aUnicodeString do:[:eachCharacter |
        |codePoint b1 b2 b3 b4 b5 v "{Class: SmallInteger }"|

        codePoint := eachCharacter codePoint.
        (self isValidXMLunicode: codePoint) ifFalse:[
            codePoint := ReplacementCharacter codePoint.
        ].

        codePoint <= 16r7F ifTrue:[
            s nextPut:(Character value:codePoint).
        ] ifFalse:[
            b1 := Character value:((codePoint bitAnd:16r3F) bitOr:2r10000000).
            v := codePoint bitShift:-6.
            v <= 16r1F ifTrue:[
                s nextPut:(Character value:(v bitOr:2r11000000)).
                s nextPut:b1.
            ] ifFalse:[
                b2 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                v := v bitShift:-6.
                v <= 16r0F ifTrue:[
                    s nextPut:(Character value:(v bitOr:2r11100000)).
                    s nextPut:b2; nextPut:b1.
                ] ifFalse:[
                    b3 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                    v := v bitShift:-6.
                    v <= 16r07 ifTrue:[
                        s nextPut:(Character value:(v bitOr:2r11110000)).
                        s nextPut:b3; nextPut:b2; nextPut:b1.
                    ] ifFalse:[
                        b4 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                        v := v bitShift:-6.
                        v <= 16r03 ifTrue:[
                            s nextPut:(Character value:(v bitOr:2r11111000)).
                            s nextPut:b4; nextPut:b3; nextPut:b2; nextPut:b1.
                        ] ifFalse:[
                            b5 := Character value:((v bitAnd:16r3F) bitOr:2r10000000).
                            v := v bitShift:-6.
                            v <= 16r01 ifTrue:[
                                s nextPut:(Character value:(v bitOr:2r11111100)).
                                s nextPut:b5; nextPut:b4; nextPut:b3; nextPut:b2; nextPut:b1.
                            ] ifFalse:[
                                "/ cannot happen - we only support up to 30 bit characters
                                self error:'ascii value > 31bit in utf8Encode'.
                            ]
                        ].
                    ].
                ].
            ].
        ].
    ].

    ^ s contents

    "
     (self encodeString:'hello') asByteArray                             #[104 101 108 108 111]
     (self encodeString:(Character value:16r40) asString) asByteArray    #[64]
     (self encodeString:(Character value:16r7F) asString) asByteArray    #[127]
     (self encodeString:(Character value:16r80) asString) asByteArray    #[194 128]
     (self encodeString:(Character value:16rFF) asString) asByteArray    #[195 191]
     (self encodeString:(Character value:16r100) asString) asByteArray   #[196 128]
     (self encodeString:(Character value:16r200) asString) asByteArray   #[200 128]
     (self encodeString:(Character value:16r400) asString) asByteArray   #[208 128]
     (self encodeString:(Character value:16r800) asString) asByteArray   #[224 160 128]
     (self encodeString:(Character value:16r1000) asString) asByteArray  #[225 128 128]
     (self encodeString:(Character value:16r2000) asString) asByteArray  #[226 128 128]
     (self encodeString:(Character value:16r4000) asString) asByteArray  #[228 128 128]
     (self encodeString:(Character value:16r8000) asString) asByteArray  #[232 128 128]
     (self encodeString:(Character value:16rFFFF) asString) asByteArray  #[239 191 191]
    "

    "Created: / 30-06-2012 / 20:07:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ISO10646_to_XMLUTF8 methodsFor:'queries'!

isValidXMLunicode: codePoint
    "Returns true, if given codePoint (Integer!!!!!!) is
     valid XML unicode."

    codePoint == 16r0009 ifTrue:[ ^ true ].
    codePoint == 16r000A ifTrue:[ ^ true ].
    codePoint == 16r000D ifTrue:[ ^ true ].
    (codePoint between: 16r0020  and: 16rD7FF  ) ifTrue:[ ^ true ].
    (codePoint between: 16rE000  and: 16rFFFD  ) ifTrue:[ ^ true ].
    (codePoint between: 16r10000 and: 16r10FFFF) ifTrue:[ ^ true ].

    ^false.

    "Created: / 30-06-2012 / 20:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOfEncoding
    ^ #'utf8-XML'
! !

!ISO10646_to_XMLUTF8 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO10646_to_XMLUTF8.st,v 1.2 2015-02-18 17:55:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO10646_to_XMLUTF8.st,v 1.2 2015-02-18 17:55:54 cg Exp $'
! !


ISO10646_to_XMLUTF8 initialize!
