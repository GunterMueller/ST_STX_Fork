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

TwoByteEncoder subclass:#JIS0208_to_EUC
	instanceVariableNames:''
	classVariableNames:'Jis7KanjiEscapeSequence Jis7RomanEscapeSequence
		JisISO2022EscapeSequence Jis7KanjiOldEscapeSequence'
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!JIS0208_to_EUC class methodsFor:'documentation'!

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

!JIS0208_to_EUC class methodsFor:'queries'!

nameOfDecodedCode
    "I encode jis0208 into jis7 and vice versa"

    ^ #'jis0208'
! !

!JIS0208_to_EUC methodsFor:'encoding & decoding'!

decode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

decodeString:aString
    "return a new string containing the characters from aString,
     which is interpreted as an EUC encoded singleByte string.

     There are various JIS encodings around (New-JIS, Old-JIS and NEC-JIS);
     this one only understands New-JIS.
     The result is a JISEncodedString (you need a JIS font to display that ...).

     This is a first-class candidate for a primitive"

    |newString 
     sz     "{ Class: SmallInteger }"
     dstIdx "{ Class: SmallInteger }"
     srcIdx "{ Class: SmallInteger }"
     b1     "{ Class: SmallInteger }"
     b2     "{ Class: SmallInteger }"
     val    "{ Class: SmallInteger }"
     c c2|

    sz := aString size.
    newString := TwoByteString new:sz.
    sz ~~ 0 ifTrue:[
        dstIdx := 1.
        srcIdx := 1.

%{
        if (__isString(aString)
         && (__Class(newString) == @global(JISEncodedString))) {
            int _dstIdx = 1, _srcIdx = 1;
            int _sz = __intVal(sz);
            unsigned char *_cp = __stringVal(aString);
            unsigned char _c1;
            unsigned short *_jcp = (unsigned short *)__stringVal(newString);

            while (_srcIdx <= _sz) {
                _c1 = _cp[_srcIdx-1];
                if (_c1 < 161) {
                    _jcp[_dstIdx-1] = _c1;
                } else {
                    _srcIdx++;
                    if (_srcIdx <= _sz) {
                        unsigned char _c2;
                        int _val;
                        int _b1, _b2;

                        _b1 = _c1 - 128;
                        _c2 = _cp[_srcIdx-1];
                        _b2 = _c2 - 128;
                        _val = (_b1<<8) + _b2;
                        if (_val < 0) {
                            /* decoder errors are handled in smalltalk */
                            _srcIdx--;
                            goto getOutOfHere;
                        }
                        _jcp[_dstIdx-1] = _val;
                    } else {
                        _jcp[_dstIdx-1] = _c1;
                    }
                }
                _dstIdx++;
                _srcIdx++;
            }
    getOutOfHere:
            srcIdx = __mkSmallInteger(_srcIdx);
            dstIdx = __mkSmallInteger(_dstIdx);
        }
%}.

        [srcIdx <= sz] whileTrue:[
            c := aString at:srcIdx.
            b1 := c codePoint.
            b1 < 161 ifTrue:[
                "/ characters below 16rA1 are left untranslated
                "/ (control character or roman).
                newString at:dstIdx put:c.
            ] ifFalse:[
                srcIdx := srcIdx + 1.
                srcIdx <= sz ifTrue:[    
                    b1 := b1 - 128.
                    b2 := (c2 := aString at:srcIdx) codePoint.
                    b2 := b2 - 128.
                    val := (b1 bitShift:8) bitOr:b2.
                    val <= 0 ifTrue:[
                        DecodingError
                            raiseWith:aString
                            errorString:'EUC decoding failed (not EUC encoded ?)'.
                        newString at:dstIdx put:c.
                        dstIdx := dstIdx + 1.
                        newString at:dstIdx put:c2.
                    ] ifFalse:[
                        newString at:dstIdx put:(Character value:val).
                    ].
                ] ifFalse:[
                    newString at:dstIdx put:c.
                ].
            ].
            dstIdx := dstIdx + 1.
            srcIdx := srcIdx + 1.
        ].

        (dstIdx-1) ~~ sz ifTrue:[
            newString := newString copyFrom:1 to:dstIdx-1.
        ].
    ].
    ^ newString

    "simple:

         'hello' decodeFrom:#euc 
    "

    "Created: 17.4.1996 / 16:10:22 / cg"
    "Modified: 4.7.1997 / 11:06:05 / cg"
!

encode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

encodeString:aJISString
    "return a new string with aJISStrings characters as EUC encoded 8bit string.
     The argument must be a JIS 16 bit character string.
     The resulting string is only useful to be stored on some external file,
     not for being displayed in an ST/X view.

     This is a first-class candidate for a primitive"

    |sz "{ Class: SmallInteger }"
     b1 "{ Class: SmallInteger }"
     val "{ Class: SmallInteger }"
     c romans out|

    romans := CharacterEncoderImplementations::JIS0208 romanTable.

    sz := aJISString size.
    sz == 0 ifTrue:[^ ''].

    out := WriteStream on:(String new:(sz * 2)).

    1 to:sz do:[:srcIndex |
        b1 := (c := aJISString at:srcIndex) codePoint.
        b1 < 161 ifTrue:[
            "/ a control or roman character    
            out nextPut:c.
        ] ifFalse:[
            "/
            "/ check for a roman character
            "/ the two numbers below are romanTable min and romanTable max
            "/
            (b1 between:16r2121 and:16r2573) ifTrue:[
                val := romans indexOf:b1.
                (val ~~ 0 and:[val <= 127]) ifTrue:[
                    out nextPut:(Character value:(val - 1 + 32))
                ] ifFalse:[
                    out nextPut:(Character value:(b1 bitShift:-8) + 128).
                    out nextPut:(Character value:(b1 bitAnd:16rFF) + 128).
                ].
            ] ifFalse:[
                out nextPut:(Character value:(b1 bitShift:-8) + 128).
                out nextPut:(Character value:(b1 bitAnd:16rFF) + 128).
            ]
        ].
    ].
    ^ out contents

    "simple:

         ('hello' decodeFrom:#euc) encodeInto:#euc    
    "

    "Created: 17.4.1996 / 16:13:33 / cg"
    "Modified: 4.7.1997 / 11:03:43 / cg"
! !

!JIS0208_to_EUC methodsFor:'queries'!

nameOfEncoding
    ^ #'euc'
! !

!JIS0208_to_EUC class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__JIS0208_to_EUC.st,v 1.4 2005/07/08 17:15:01 cg Exp $'
! !



