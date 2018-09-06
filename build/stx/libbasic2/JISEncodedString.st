"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

TwoByteString variableWordSubclass:#JISEncodedString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!JISEncodedString class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    OBSOLETE
        this class will vanish - its functionality has been replaced
        by the UnicodeString classes.

    JISEncodedString represents 16bit strings encoded in JIS.
    You need jis-encoded fonts on your display workstation, 
    to display them (i.e. when switching to japanese ...).

    [author:]
        Claus Gittinger

    [see also:]
        BIG5EncodedString GBEncodedString
        TwoByteString String CharacterArray
        StringCollection
"
!

examples
"
    JISEncodedString fromString:'hello world'

    'hello world' decodeFrom:#jis7

    <someStringWithJIS7Escapes> decodeFrom:#jis7
"
! !

!JISEncodedString class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagWords)

    "
     JISEncodedString initialize
    "

    "Created: 27.4.1996 / 13:12:02 / cg"
! !

!JISEncodedString class methodsFor:'code tables'!

defaultRomanCharacterValue
    ^ CharacterEncoderImplementations::JIS0208 defaultRomanCharacterValue

    "Created: 30.6.1997 / 18:34:58 / cg"
!

romanTable
    "return a table to decode from roman ascii to 16 bit JIS.

     WARNING: this is a temporary kludge for CJK characterSets and will be removed, 
     when the textViews always use unicode."

    ^ CharacterEncoderImplementations::JIS0208 romanTable
! !

!JISEncodedString class methodsFor:'encoding & decoding'!

encodeHalfWidthKatakana:aString
    "encode halfWidth katakana characters in aString.
     Return the argument or a copy."

    |newString char code cell halfWidthKanaToFullKana|

    halfWidthKanaToFullKana := #(
       "/ full            half       uni
       16r2123         "/ 0x8E21    0xFF61  # HALFWIDTH IDEOGRAPHIC FULL STOP
       16r2156         "/ 0x8E22    0xFF62  # HALFWIDTH LEFT CORNER BRACKET
       16r2157         "/ 0x8E23    0xFF63  # HALFWIDTH RIGHT CORNER BRACKET
       16r2122         "/ 0x8E24    0xFF64  # HALFWIDTH IDEOGRAPHIC COMMA
       16r2126         "/ 0x8E25    0xFF65  # HALFWIDTH KATAKANA MIDDLE DOT
       16r2572         "/ 0x8E26    0xFF66  # HALFWIDTH KATAKANA LETTER WO
       16r2522         "/ 0x8E27    0xFF67  # HALFWIDTH KATAKANA LETTER SMALL A
       16r2521         "/ 0x8E28    0xFF68  # HALFWIDTH KATAKANA LETTER SMALL I
       16r2525         "/ 0x8E29    0xFF69  # HALFWIDTH KATAKANA LETTER SMALL U
       16r2527         "/ 0x8E2A    0xFF6A  # HALFWIDTH KATAKANA LETTER SMALL E
       16r2529         "/ 0x8E2B    0xFF6B  # HALFWIDTH KATAKANA LETTER SMALL O
       16r2563         "/ 0x8E2C    0xFF6C  # HALFWIDTH KATAKANA LETTER SMALL YA
       16r2565         "/ 0x8E2D    0xFF6D  # HALFWIDTH KATAKANA LETTER SMALL YU
       16r2567         "/ 0x8E2E    0xFF6E  # HALFWIDTH KATAKANA LETTER SMALL YO
       16r2543         "/ 0x8E2F    0xFF6F  # HALFWIDTH KATAKANA LETTER SMALL TU
       16r213C         "/ 0x8E30    0xFF70  # HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK
       16r2522         "/ 0x8E31    0xFF71  # HALFWIDTH KATAKANA LETTER A
       16r2524         "/ 0x8E32    0xFF72  # HALFWIDTH KATAKANA LETTER I
       16r2526         "/ 0x8E33    0xFF73  # HALFWIDTH KATAKANA LETTER U
       16r2528         "/ 0x8E34    0xFF74  # HALFWIDTH KATAKANA LETTER E
       16r252A         "/ 0x8E35    0xFF75  # HALFWIDTH KATAKANA LETTER O
       16r252B         "/ 0x8E36    0xFF76  # HALFWIDTH KATAKANA LETTER KA
       16r252D         "/ 0x8E37    0xFF77  # HALFWIDTH KATAKANA LETTER KI
       16r252F         "/ 0x8E38    0xFF78  # HALFWIDTH KATAKANA LETTER KU
       16r2531         "/ 0x8E39    0xFF79  # HALFWIDTH KATAKANA LETTER KE
       16r2533         "/ 0x8E3A    0xFF7A  # HALFWIDTH KATAKANA LETTER KO
       16r2535         "/ 0x8E3B    0xFF7B  # HALFWIDTH KATAKANA LETTER SA
       16r2537         "/ 0x8E3C    0xFF7C  # HALFWIDTH KATAKANA LETTER SI
       16r2539         "/ 0x8E3D    0xFF7D  # HALFWIDTH KATAKANA LETTER SU
       16r253B         "/ 0x8E3E    0xFF7E  # HALFWIDTH KATAKANA LETTER SE
       16r253D         "/ 0x8E3F    0xFF7F  # HALFWIDTH KATAKANA LETTER SO
       16r253F         "/ 0x8E40    0xFF80  # HALFWIDTH KATAKANA LETTER TA
       16r2541         "/ 0x8E41    0xFF81  # HALFWIDTH KATAKANA LETTER TI
       16r2544         "/ 0x8E42    0xFF82  # HALFWIDTH KATAKANA LETTER TU
       16r2546         "/ 0x8E43    0xFF83  # HALFWIDTH KATAKANA LETTER TE
       16r2548         "/ 0x8E44    0xFF84  # HALFWIDTH KATAKANA LETTER TO
       16r254A         "/ 0x8E45    0xFF85  # HALFWIDTH KATAKANA LETTER NA
       16r254B         "/ 0x8E46    0xFF86  # HALFWIDTH KATAKANA LETTER NI
       16r254C         "/ 0x8E47    0xFF87  # HALFWIDTH KATAKANA LETTER NU
       16r254D         "/ 0x8E48    0xFF88  # HALFWIDTH KATAKANA LETTER NE
       16r254E         "/ 0x8E49    0xFF89  # HALFWIDTH KATAKANA LETTER NO
       16r254F         "/ 0x8E4A    0xFF8A  # HALFWIDTH KATAKANA LETTER HA
       16r2552         "/ 0x8E4B    0xFF8B  # HALFWIDTH KATAKANA LETTER HI
       16r2555         "/ 0x8E4C    0xFF8C  # HALFWIDTH KATAKANA LETTER HU
       16r2558         "/ 0x8E4D    0xFF8D  # HALFWIDTH KATAKANA LETTER HE
       16r255B         "/ 0x8E4E    0xFF8E  # HALFWIDTH KATAKANA LETTER HO
       16r255E         "/ 0x8E4F    0xFF8F  # HALFWIDTH KATAKANA LETTER MA
       16r255F         "/ 0x8E50    0xFF90  # HALFWIDTH KATAKANA LETTER MI
       16r2560         "/ 0x8E51    0xFF91  # HALFWIDTH KATAKANA LETTER MU
       16r2561         "/ 0x8E52    0xFF92  # HALFWIDTH KATAKANA LETTER ME
       16r2562         "/ 0x8E53    0xFF93  # HALFWIDTH KATAKANA LETTER MO
       16r2564         "/ 0x8E54    0xFF94  # HALFWIDTH KATAKANA LETTER YA
       16r2566         "/ 0x8E55    0xFF95  # HALFWIDTH KATAKANA LETTER YU
       16r2568         "/ 0x8E56    0xFF96  # HALFWIDTH KATAKANA LETTER YO
       16r2569         "/ 0x8E57    0xFF97  # HALFWIDTH KATAKANA LETTER RA
       16r256A         "/ 0x8E58    0xFF98  # HALFWIDTH KATAKANA LETTER RI
       16r256B         "/ 0x8E59    0xFF99  # HALFWIDTH KATAKANA LETTER RU
       16r256C         "/ 0x8E5A    0xFF9A  # HALFWIDTH KATAKANA LETTER RE
       16r256D         "/ 0x8E5B    0xFF9B  # HALFWIDTH KATAKANA LETTER RO
       16r256F         "/ 0x8E5C    0xFF9C  # HALFWIDTH KATAKANA LETTER WA
       16r2573         "/ 0x8E5D    0xFF9D  # HALFWIDTH KATAKANA LETTER N
       16r212B         "/ 0x8E5E    0xFF9E  # HALFWIDTH KATAKANA VOICED SOUND MARK
       16r212C         "/ 0x8E5F    0xFF9F  # HALFWIDTH KATAKANA SEMI-VOICED SOUND MARK
        ).

    1 to:aString size do:[:idx |
        char := aString at:idx.
        ((code := char codePoint) bitAnd:16rFF00) == 16r8E00 ifTrue:[
            cell := code bitAnd:16rFF.
            (cell between:16r21 and:16r5F) ifTrue:[
                newString isNil ifTrue:[
                    newString := JISEncodedString fromString:aString
                ].
                code := halfWidthKanaToFullKana at:(cell - 16r21 + 1).
                newString at:idx put:(Character value:code).
            ].
        ]
    ].
    newString notNil ifTrue:[
        ^ newString
    ].
    ^ aString

    "Created: 2.7.1997 / 12:41:21 / cg"
    "Modified: 2.7.1997 / 12:51:08 / cg"
! !

!JISEncodedString class methodsFor:'standards'!

jis7KanjiEscapeSequence
    "return the escape sequence used to switch to kanji in jis7 encoded strings.
     This happens to be the same as ISO2022-JP's escape sequence."

    ^ CharacterEncoder jis7KanjiEscapeSequence.

    "Created: 26.2.1996 / 17:38:08 / cg"
    "Modified: 30.6.1997 / 16:03:16 / cg"
!

jis7RomanEscapeSequence
    "return the escape sequence used to switch to roman in jis7 encoded strings"

    ^ CharacterEncoder jis7RomanEscapeSequence.

    "Created: 26.2.1996 / 17:38:03 / cg"
    "Modified: 22.4.1996 / 16:08:42 / cg"
!

jisISO2022EscapeSequence
    "return the escape sequence used to switch to kanji in iso2022 encoded strings"

    ^ CharacterEncoder jisISO2022EscapeSequence

    "Created: 30.6.1997 / 16:02:34 / cg"
!

oldJis7KanjiEscapeSequence
    "return the escape sequence used to switch to kanji in old jis7 encoded strings"

    ^ CharacterEncoder jis7KanjiOldEscapeSequence.
! !

!JISEncodedString methodsFor:'queries'!

encoding
    "return the strings encoding as a symbol. 
     Here, the constant symbol #jis is returned."

    ^ #jis

    "Modified: 27.4.1996 / 13:23:16 / cg"
! !

!JISEncodedString class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


JISEncodedString initialize!
