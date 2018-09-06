"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2004 by eXept Software AG
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

TwoByteEncoder subclass:#JIS0208_to_SJIS
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!JIS0208_to_SJIS class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JIS0208_to_SJIS class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'OBSOLETE/EASTASIA/JIS/SHIFTJIS.TXT'
! !

!JIS0208_to_SJIS class methodsFor:'queries'!

nameOfDecodedCode
    "I encode sjis into jis"

    ^ #'jis0208'
! !

!JIS0208_to_SJIS methodsFor:'encoding & decoding'!

decodeString:aString
    "return a new JIS-Encoded-String containing the characters from aString,
     which are interpreted as Shift-JIS encoded singleByte chars.
     Shift-JIS is a leadyByte code, with a variable-length encoding."

    |newString char1 char2
     sz         "{ Class: SmallInteger }"
     dstIdx     "{ Class: SmallInteger }"
     srcIdx     "{ Class: SmallInteger }"
     b1         "{ Class: SmallInteger }"
     b2         "{ Class: SmallInteger }"
     val        "{ Class: SmallInteger }"
     any16bit romans|

    sz := aString size.
    sz == 0 ifTrue:[^ aString].

    newString := TwoByteString new:sz.
    any16bit := false.
    dstIdx := 1.
    srcIdx := 1.

    romans := CharacterEncoderImplementations::JIS0208 romanTable.

%{
    if (__isStringLike(aString)
     && (__Class(newString) == @global(TwoByteString))) {
        INT _dstIdx = 0, _srcIdx = 0;
        int _sz = __intVal(sz);
        unsigned char *_cp = __stringVal(aString);
        unsigned char _c1, _c2;
        unsigned short *_jcp = (unsigned short *)__stringVal(newString);

        while (_srcIdx < _sz) {
            int _val;

            _c1 = _cp[_srcIdx];
            _srcIdx++;

            if ((_srcIdx < _sz)
             && (((_c1 >= 129) && (_c1 <= 159))
                 || ((_c1 >= 224) && (_c1 <= 239)))) {
                _c2 = _cp[_srcIdx];
                _srcIdx++;
                if ((_c2 >= 64) && (_c2 <= 252)) {
                    int _adjust, _rowOffs, _cellOffs;
                    int _b1, _b2;

                    _adjust = (_c2 < 159) ? 1 : 0;
                    _rowOffs = (_c1 < 160) ? 112 : 176;
                    if (_adjust) {
                        _cellOffs = 31 + ((_c2 > 127) ? 1 : 0);
                    } else {
                        _cellOffs = 126;
                    }
                    _b1 = ((_c1 - _rowOffs) << 1) - _adjust;
                    _b2 = (_c2 - _cellOffs);
                    _val = (_b1<<8) + _b2;
                    if (_val <= 0) {
                        /* decoder error - let smalltalk handle that */
                        _srcIdx -= 2;
                        goto getOutOfHere;
                    }
                    if (_val > 0xFF) any16bit = true;
                    _jcp[_dstIdx] = _val;
                } else {
                    /* mhmh - append untranslated */

                    _jcp[_dstIdx] = _c1;
                    _dstIdx++;
                    _jcp[_dstIdx] = _c2;
                }
            } else {
                if ((_c1 >= 0xA1 /* 161 */) && (_c1 <= 0xDF /* 223 */)) {
                    /* HALFWIDTH KATAKANA
                     * map half-width katakana to 8E:xx
                     */
                    _val = _c1 - 128;
                    _val = _val + 0x8E00;
                    any16bit = true;
                    _jcp[_dstIdx] = _val;
                } else {
                    /* roman characters are translated as per romanTable */
                    _jcp[_dstIdx] = _c1;
                    if ((romans != nil) 
                     && (__isArray(romans))
                     && ((_c1 - 0x20) < __arraySize(romans))) {
                        any16bit = true;
                        _jcp[_dstIdx] = __intVal(__ArrayInstPtr(romans)->a_element[(_c1 - 0x20)]);
                    }
                }
            }
            _dstIdx++;
        }
    getOutOfHere: ;
        dstIdx = __mkSmallInteger(_dstIdx+1);
        srcIdx = __mkSmallInteger(_srcIdx+1);
    }
%}.

    [srcIdx <= sz] whileTrue:[
        "/
        "/ scan for next character in 129..159 or 224..239
        "/
        char1 := aString at:srcIdx.
        srcIdx := srcIdx + 1.
        b1 := char1 codePoint.

        ((srcIdx <= sz) 
        and:[(b1 >= 16r81"129" and:[b1 <= 16r9F"159"])                 "/ SJIS1 81 .. 9F
             or:[b1 >= 16rE0"224" and:[b1 <= 16rEF"239"]]]) ifTrue:[   "/       E0 .. EF
            char2 := aString at:srcIdx.
            srcIdx := srcIdx + 1.
            b2 := char2 codePoint.
            (b2 >= 16r40"64" and:[b2 <= 16rFC"252"]) ifTrue:[          "/ SJIS2 40 .. FC
                |adjust rowOffs cellOffs|

                adjust := (b2 < 16r9F"159") ifTrue:[1] ifFalse:[0].
                rowOffs := b1 < 16rA0"160" ifTrue:[112] ifFalse:[176].
                adjust == 1 ifTrue:[
                    cellOffs := 31 + (b2 > 127 ifTrue:[1] ifFalse:[0]).
                ] ifFalse:[
                    cellOffs := 126.
                ].
                b1 := ((b1 - rowOffs) bitShift:1) - adjust.
                b2 := (b2 - cellOffs).
                val := (b1 bitShift:8) + b2.
                val <= 0 ifTrue:[
                    DecodingError
                            raiseWith:aString
                            errorString:'SJIS decoding failed (not SJIS encoded ?)'.
                    newString at:dstIdx put:char1.
                    dstIdx := dstIdx + 1.
                    newString at:dstIdx put:char2.
                ] ifFalse:[
                    val > 16rFF ifTrue:[any16bit := true].
                    newString at:dstIdx put:(Character value:val).
                ]
            ] ifFalse:[
                "/ mhmh - append untranslated

                newString at:dstIdx put:char1.
                dstIdx := dstIdx + 1.
                newString at:dstIdx put:char2.
            ]
        ] ifFalse:[    
            (b1 >= 16rA1 "161" and:[b1 <= 16rDF "223"]) ifTrue:[     "/ HALFWIDTH KATAKANA
                "/ map half-width katakan to 8E:xx
                val := b1 - 128.
                val := val + (16r8E"142" bitShift:8).
                any16bit := true.
                newString at:dstIdx put:(Character value:val).
            ] ifFalse:[    
                "/ roman characters translated as per romanTable
                newString at:dstIdx put:char1
                romans isArray ifTrue:[
                    char1 codePoint < romans size ifTrue:[
                        any16bit := true.
                        newString at:dstIdx put:(Character value:(romans at:char1 codePoint-32+1)).
                    ]
                ]
            ]
        ].
        dstIdx := dstIdx + 1.
    ].
    any16bit ifFalse:[
        newString := String fromString:newString 
    ].

    (dstIdx-1) ~~ sz ifTrue:[
        newString := newString copyTo:dstIdx - 1.
    ].

    ^ newString

    "simple:

     CharacterEncoderImplementations::JIS0208_to_SJIS decodeString:'hello'  
     (CharacterEncoder encoderFor:#sjis) decodeString:'hello'         

     CharacterEncoderImplementations::JIS0208_to_SJIS decodeString:('../../doc/online/japanese/TOP.html' asFilename contents asString)  

     '../../doc/online/japanese/TOP.html' asFilename contents asString
                decodeFrom:#sjis  
    "
!

encodeString:aJISString
    "return a new string with aJISString's characters as SJIS encoded 8bit string.
     The resulting string is only useful to be stored on some external file,
     not for being displayed in an ST/X view."

    |sz "{ Class: SmallInteger }"
     rval "{ Class: SmallInteger }"
     val  "{ Class: SmallInteger }"
     romans c out isSJIS|

    romans := JIS0208 romanTable.

    sz := aJISString size.
    sz == 0 ifTrue:[^ ''].

    out := WriteStream on:(String new:(sz * 2)).

    1 to:sz do:[:srcIndex |
        val := (c := aJISString at:srcIndex) codePoint.
        (val <= 128) ifTrue:[
            "/ a control or ascii character    
            out nextPut:c.
        ] ifFalse:[
            (val == 16rFFFF "invalid-char") ifTrue:[
                out nextPut:Character space.
            ] ifFalse:[
                (val > 150 and:[val < 224]) ifTrue:[
                    "/ ascii subset
                    out nextPut:c.
                ] ifFalse:[
                    "/ should not happen ...
                    val <= 255 ifTrue:[
                        out nextPut:c.
                    ] ifFalse:[
                        isSJIS := true.

                        "/ check for HALFWIDTH KATAKANA
                        "/ 8E:xx
                        "/ NO: halfwidth katakana no longer generated
                        "/     remains there as full-width katakana

"/                        (val bitAnd:16rFF00) == 16r8E00 ifTrue:[
"/                            |b|
"/
"/                            b := (val bitAnd:16rFF) + 128.
"/                            (b >= 16rA1 "161" and:[b <= 16rDF "223"]) ifTrue:[
"/                                out nextPut:(Character value:b).
"/                                isSJIS := false.
"/                            ].
"/                        ].

                        isSJIS ifTrue:[
                            "/ check for a roman character
                            (val between:"romanTable min" 16r2121 and:"romanTable max" 16r2573) ifTrue:[
                                rval := romans indexOf:val.
                                rval ~~ 0 ifTrue:[
                                    rval := rval - 1 + 32.
                                    rval <= 16r7F ifTrue:[ "/ do not translate halfwidth katakana
                                        out nextPut:(Character value:rval).
                                        isSJIS := false.
                                    ]
                                ].
                            ].
                        ].

                        isSJIS ifTrue:[
                            |b1 b2 rowOffset cellOffset|

                            b1 := (val bitShift:-8).
                            b2 := (val bitAnd:16rFF).
                            rowOffset := (b1 < 95) ifTrue:[112] ifFalse:[176].
                            cellOffset := b1 odd ifTrue:[(b2 > 95) ifTrue:[32] ifFalse:[31]]
                                                 ifFalse:[126].

                            out nextPut:(Character value:(((b1 + 1) bitShift:-1) + rowOffset)).
                            out nextPut:(Character value:b2 + cellOffset).
                        ]
                    ]
                ]
            ]
        ].
    ].
    ^ out contents
! !

!JIS0208_to_SJIS methodsFor:'private'!

newString:size
    ^ JISEncodedString new:size
! !

!JIS0208_to_SJIS methodsFor:'queries'!

nameOfEncoding
    ^ #'sjis'
! !

!JIS0208_to_SJIS class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__JIS0208_to_SJIS.st,v 1.2 2015-04-20 11:05:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__JIS0208_to_SJIS.st,v 1.2 2015-04-20 11:05:35 cg Exp $'
! !

