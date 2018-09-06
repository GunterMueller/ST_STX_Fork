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

SingleByteEncoder subclass:#MAC_Roman
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!MAC_Roman class methodsFor:'documentation'!

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
    I encode/decode MAC roman encoded documents
"
! !

!MAC_Roman class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'VENDORS/APPLE/ROMAN.TXT'

    "
     self generateCode
    "

    "Modified: / 29-01-2011 / 21:32:53 / cg"
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/ROMAN.TXT

#=======================================================================
#   File name:  ROMAN.TXT
#
#   Contents:   Map (external version) from Mac OS Roman
#               character set to Unicode 2.1 through Unicode 3.2
#
#   Copyright:  (c) 1994-2002 by Apple Computer, Inc., all rights
#               reserved.
#
#   Contact:    charsets@apple.com
#
#   Changes:
#
#      b4,c1 2002-Dec-19    Update URLs, notes. Matches internal
#                           utom<b5>.
#       b03  1999-Sep-22    Update contact e-mail address. Matches
#                           internal utom<b4>, ufrm<b3>, and Text
#                           Encoding Converter version 1.5.
#       b02  1998-Aug-18    Encoding changed for Mac OS 8.5; change
#                           mapping of 0xDB from CURRENCY SIGN to
#                           EURO SIGN. Matches internal utom<b3>,
#                           ufrm<b3>.
#       n08  1998-Feb-05    Minor update to header comments
#       n06  1997-Dec-14    Add warning about future changes to 0xDB
#                           from CURRENCY SIGN to EURO SIGN. Clarify
#                           some header information
#       n04  1997-Dec-01    Update to match internal utom<n3>, ufrm<n22>:
#                           Change standard mapping for 0xBD from U+2126
#                           to its canonical decomposition, U+03A9.
#       n03  1995-Apr-15    First version (after fixing some typos).
#                           Matches internal ufrm<n9>.
#
# Standard header:
# ----------------
#
#   Apple, the Apple logo, and Macintosh are trademarks of Apple
#   Computer, Inc., registered in the United States and other countries.
#   Unicode is a trademark of Unicode Inc. For the sake of brevity,
#   throughout this document, 'Macintosh' can be used to refer to
#   Macintosh computers and 'Unicode' can be used to refer to the
#   Unicode standard.
#
#   Apple makes no warranty or representation, either express or
#   implied, with respect to these tables, their quality, accuracy, or
#   fitness for a particular purpose. In no event will Apple be liable
#   for direct, indirect, special, incidental, or consequential damages 
#   resulting from any defect or inaccuracy in this document or the
#   accompanying tables.
#
#   These mapping tables and character lists are subject to change.
#   The latest tables should be available from the following:
#
#   <http://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/>
#
#   For general information about Mac OS encodings and these mapping
#   tables, see the file 'README.TXT'.
#
# Format:
# -------
#
#   Three tab-separated columns;
#   '#' begins a comment which continues to the end of the line.
#     Column #1 is the Mac OS Roman code (in hex as 0xNN)
#     Column #2 is the corresponding Unicode (in hex as 0xNNNN)
#     Column #3 is a comment containing the Unicode name
#
#   The entries are in Mac OS Roman code order.
#
#   One of these mappings requires the use of a corporate character.
#   See the file 'CORPCHAR.TXT' and notes below.
#
#   Control character mappings are not shown in this table, following
#   the conventions of the standard UTC mapping tables. However, the
#   Mac OS Roman character set uses the standard control characters at
#   0x00-0x1F and 0x7F.
#
# Notes on Mac OS Roman:
# ----------------------
#
#   This character set is used for at least the following Mac OS
#   localizations: U.S., British, Canadian French, French, Swiss
#   French, German, Swiss German, Italian, Swiss Italian, Dutch,
#   Swedish, Norwegian, Danish, Finnish, Spanish, Catalan,
#   Portuguese, Brazilian, and the default International system.
#
#   Variants of Mac OS Roman are used for Croatian, Icelandic,
#   Turkish, Romanian, and other encodings. Separate mapping tables
#   are available for these encodings.
#
#   Before Mac OS 8.5, code point 0xDB was CURRENCY SIGN, and was
#   mapped to U+00A4. In Mac OS 8.5 and later versions, code point
#   0xDB is changed to EURO SIGN and maps to U+20AC; the standard
#   Apple fonts are updated for Mac OS 8.5 to reflect this. There is
#   a 'currency sign' variant of the Mac OS Roman encoding that still
#   maps 0xDB to U+00A4; this can be used for older fonts.
#
#   Before Mac OS 8.5, the ROM bitmap versions of the fonts Chicago,
#   New York, Geneva, and Monaco did not implement the full Mac OS
#   Roman character set; they only supported character codes up to
#   0xD8. The TrueType versions of these fonts have always implemented
#   the full character set, as with the bitmap and TrueType versions
#   of the other standard Roman fonts.
#
#   In all Mac OS encodings, fonts such as Chicago which are used
#   as 'system' fonts (for menus, dialogs, etc.) have four glyphs
#   at code points 0x11-0x14 for transient use by the Menu Manager.
#   These glyphs are not intended as characters for use in normal
#   text, and the associated code points are not generally
#   interpreted as associated with these glyphs; they are usually
#   interpreted (if at all) as the control codes DC1-DC4.
#
# Unicode mapping issues and notes:
# ---------------------------------
#
#   The following corporate zone Unicode character is used in this
#   mapping:
#
#     0xF8FF  Apple logo
#
#   NOTE: The graphic image associated with the Apple logo character
#   is not authorized for use without permission of Apple, and
#   unauthorized use might constitute trademark infringement.
#
# Details of mapping changes in each version:
# -------------------------------------------
#
#   Changes from version n08 to version b02:
#
#   - Encoding changed for Mac OS 8.5; change mapping of 0xDB from
#   CURRENCY SIGN (U+00A4) to EURO SIGN (U+20AC).
#
#   Changes from version n03 to version n04:
#
#   - Change mapping of 0xBD from U+2126 to its canonical
#     decomposition, U+03A9.
#
##################

0x20    0x0020  # SPACE
0x21    0x0021  # EXCLAMATION MARK
0x22    0x0022  # QUOTATION MARK
0x23    0x0023  # NUMBER SIGN
0x24    0x0024  # DOLLAR SIGN
0x25    0x0025  # PERCENT SIGN
0x26    0x0026  # AMPERSAND
0x27    0x0027  # APOSTROPHE
0x28    0x0028  # LEFT PARENTHESIS
0x29    0x0029  # RIGHT PARENTHESIS
0x2A    0x002A  # ASTERISK
0x2B    0x002B  # PLUS SIGN
0x2C    0x002C  # COMMA
0x2D    0x002D  # HYPHEN-MINUS
0x2E    0x002E  # FULL STOP
0x2F    0x002F  # SOLIDUS
0x30    0x0030  # DIGIT ZERO
0x31    0x0031  # DIGIT ONE
0x32    0x0032  # DIGIT TWO
0x33    0x0033  # DIGIT THREE
0x34    0x0034  # DIGIT FOUR
0x35    0x0035  # DIGIT FIVE
0x36    0x0036  # DIGIT SIX
0x37    0x0037  # DIGIT SEVEN
0x38    0x0038  # DIGIT EIGHT
0x39    0x0039  # DIGIT NINE
0x3A    0x003A  # COLON
0x3B    0x003B  # SEMICOLON
0x3C    0x003C  # LESS-THAN SIGN
0x3D    0x003D  # EQUALS SIGN
0x3E    0x003E  # GREATER-THAN SIGN
0x3F    0x003F  # QUESTION MARK
0x40    0x0040  # COMMERCIAL AT
0x41    0x0041  # LATIN CAPITAL LETTER A
0x42    0x0042  # LATIN CAPITAL LETTER B
0x43    0x0043  # LATIN CAPITAL LETTER C
0x44    0x0044  # LATIN CAPITAL LETTER D
0x45    0x0045  # LATIN CAPITAL LETTER E
0x46    0x0046  # LATIN CAPITAL LETTER F
0x47    0x0047  # LATIN CAPITAL LETTER G
0x48    0x0048  # LATIN CAPITAL LETTER H
0x49    0x0049  # LATIN CAPITAL LETTER I
0x4A    0x004A  # LATIN CAPITAL LETTER J
0x4B    0x004B  # LATIN CAPITAL LETTER K
0x4C    0x004C  # LATIN CAPITAL LETTER L
0x4D    0x004D  # LATIN CAPITAL LETTER M
0x4E    0x004E  # LATIN CAPITAL LETTER N
0x4F    0x004F  # LATIN CAPITAL LETTER O
0x50    0x0050  # LATIN CAPITAL LETTER P
0x51    0x0051  # LATIN CAPITAL LETTER Q
0x52    0x0052  # LATIN CAPITAL LETTER R
0x53    0x0053  # LATIN CAPITAL LETTER S
0x54    0x0054  # LATIN CAPITAL LETTER T
0x55    0x0055  # LATIN CAPITAL LETTER U
0x56    0x0056  # LATIN CAPITAL LETTER V
0x57    0x0057  # LATIN CAPITAL LETTER W
0x58    0x0058  # LATIN CAPITAL LETTER X
0x59    0x0059  # LATIN CAPITAL LETTER Y
0x5A    0x005A  # LATIN CAPITAL LETTER Z
0x5B    0x005B  # LEFT SQUARE BRACKET
0x5C    0x005C  # REVERSE SOLIDUS
0x5D    0x005D  # RIGHT SQUARE BRACKET
0x5E    0x005E  # CIRCUMFLEX ACCENT
0x5F    0x005F  # LOW LINE
0x60    0x0060  # GRAVE ACCENT
0x61    0x0061  # LATIN SMALL LETTER A
0x62    0x0062  # LATIN SMALL LETTER B
0x63    0x0063  # LATIN SMALL LETTER C
0x64    0x0064  # LATIN SMALL LETTER D
0x65    0x0065  # LATIN SMALL LETTER E
0x66    0x0066  # LATIN SMALL LETTER F
0x67    0x0067  # LATIN SMALL LETTER G
0x68    0x0068  # LATIN SMALL LETTER H
0x69    0x0069  # LATIN SMALL LETTER I
0x6A    0x006A  # LATIN SMALL LETTER J
0x6B    0x006B  # LATIN SMALL LETTER K
0x6C    0x006C  # LATIN SMALL LETTER L
0x6D    0x006D  # LATIN SMALL LETTER M
0x6E    0x006E  # LATIN SMALL LETTER N
0x6F    0x006F  # LATIN SMALL LETTER O
0x70    0x0070  # LATIN SMALL LETTER P
0x71    0x0071  # LATIN SMALL LETTER Q
0x72    0x0072  # LATIN SMALL LETTER R
0x73    0x0073  # LATIN SMALL LETTER S
0x74    0x0074  # LATIN SMALL LETTER T
0x75    0x0075  # LATIN SMALL LETTER U
0x76    0x0076  # LATIN SMALL LETTER V
0x77    0x0077  # LATIN SMALL LETTER W
0x78    0x0078  # LATIN SMALL LETTER X
0x79    0x0079  # LATIN SMALL LETTER Y
0x7A    0x007A  # LATIN SMALL LETTER Z
0x7B    0x007B  # LEFT CURLY BRACKET
0x7C    0x007C  # VERTICAL LINE
0x7D    0x007D  # RIGHT CURLY BRACKET
0x7E    0x007E  # TILDE
#
0x80    0x00C4  # LATIN CAPITAL LETTER A WITH DIAERESIS
0x81    0x00C5  # LATIN CAPITAL LETTER A WITH RING ABOVE
0x82    0x00C7  # LATIN CAPITAL LETTER C WITH CEDILLA
0x83    0x00C9  # LATIN CAPITAL LETTER E WITH ACUTE
0x84    0x00D1  # LATIN CAPITAL LETTER N WITH TILDE
0x85    0x00D6  # LATIN CAPITAL LETTER O WITH DIAERESIS
0x86    0x00DC  # LATIN CAPITAL LETTER U WITH DIAERESIS
0x87    0x00E1  # LATIN SMALL LETTER A WITH ACUTE
0x88    0x00E0  # LATIN SMALL LETTER A WITH GRAVE
0x89    0x00E2  # LATIN SMALL LETTER A WITH CIRCUMFLEX
0x8A    0x00E4  # LATIN SMALL LETTER A WITH DIAERESIS
0x8B    0x00E3  # LATIN SMALL LETTER A WITH TILDE
0x8C    0x00E5  # LATIN SMALL LETTER A WITH RING ABOVE
0x8D    0x00E7  # LATIN SMALL LETTER C WITH CEDILLA
0x8E    0x00E9  # LATIN SMALL LETTER E WITH ACUTE
0x8F    0x00E8  # LATIN SMALL LETTER E WITH GRAVE
0x90    0x00EA  # LATIN SMALL LETTER E WITH CIRCUMFLEX
0x91    0x00EB  # LATIN SMALL LETTER E WITH DIAERESIS
0x92    0x00ED  # LATIN SMALL LETTER I WITH ACUTE
0x93    0x00EC  # LATIN SMALL LETTER I WITH GRAVE
0x94    0x00EE  # LATIN SMALL LETTER I WITH CIRCUMFLEX
0x95    0x00EF  # LATIN SMALL LETTER I WITH DIAERESIS
0x96    0x00F1  # LATIN SMALL LETTER N WITH TILDE
0x97    0x00F3  # LATIN SMALL LETTER O WITH ACUTE
0x98    0x00F2  # LATIN SMALL LETTER O WITH GRAVE
0x99    0x00F4  # LATIN SMALL LETTER O WITH CIRCUMFLEX
0x9A    0x00F6  # LATIN SMALL LETTER O WITH DIAERESIS
0x9B    0x00F5  # LATIN SMALL LETTER O WITH TILDE
0x9C    0x00FA  # LATIN SMALL LETTER U WITH ACUTE
0x9D    0x00F9  # LATIN SMALL LETTER U WITH GRAVE
0x9E    0x00FB  # LATIN SMALL LETTER U WITH CIRCUMFLEX
0x9F    0x00FC  # LATIN SMALL LETTER U WITH DIAERESIS
0xA0    0x2020  # DAGGER
0xA1    0x00B0  # DEGREE SIGN
0xA2    0x00A2  # CENT SIGN
0xA3    0x00A3  # POUND SIGN
0xA4    0x00A7  # SECTION SIGN
0xA5    0x2022  # BULLET
0xA6    0x00B6  # PILCROW SIGN
0xA7    0x00DF  # LATIN SMALL LETTER SHARP S
0xA8    0x00AE  # REGISTERED SIGN
0xA9    0x00A9  # COPYRIGHT SIGN
0xAA    0x2122  # TRADE MARK SIGN
0xAB    0x00B4  # ACUTE ACCENT
0xAC    0x00A8  # DIAERESIS
0xAD    0x2260  # NOT EQUAL TO
0xAE    0x00C6  # LATIN CAPITAL LETTER AE
0xAF    0x00D8  # LATIN CAPITAL LETTER O WITH STROKE
0xB0    0x221E  # INFINITY
0xB1    0x00B1  # PLUS-MINUS SIGN
0xB2    0x2264  # LESS-THAN OR EQUAL TO
0xB3    0x2265  # GREATER-THAN OR EQUAL TO
0xB4    0x00A5  # YEN SIGN
0xB5    0x00B5  # MICRO SIGN
0xB6    0x2202  # PARTIAL DIFFERENTIAL
0xB7    0x2211  # N-ARY SUMMATION
0xB8    0x220F  # N-ARY PRODUCT
0xB9    0x03C0  # GREEK SMALL LETTER PI
0xBA    0x222B  # INTEGRAL
0xBB    0x00AA  # FEMININE ORDINAL INDICATOR
0xBC    0x00BA  # MASCULINE ORDINAL INDICATOR
0xBD    0x03A9  # GREEK CAPITAL LETTER OMEGA
0xBE    0x00E6  # LATIN SMALL LETTER AE
0xBF    0x00F8  # LATIN SMALL LETTER O WITH STROKE
0xC0    0x00BF  # INVERTED QUESTION MARK
0xC1    0x00A1  # INVERTED EXCLAMATION MARK
0xC2    0x00AC  # NOT SIGN
0xC3    0x221A  # SQUARE ROOT
0xC4    0x0192  # LATIN SMALL LETTER F WITH HOOK
0xC5    0x2248  # ALMOST EQUAL TO
0xC6    0x2206  # INCREMENT
0xC7    0x00AB  # LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
0xC8    0x00BB  # RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
0xC9    0x2026  # HORIZONTAL ELLIPSIS
0xCA    0x00A0  # NO-BREAK SPACE
0xCB    0x00C0  # LATIN CAPITAL LETTER A WITH GRAVE
0xCC    0x00C3  # LATIN CAPITAL LETTER A WITH TILDE
0xCD    0x00D5  # LATIN CAPITAL LETTER O WITH TILDE
0xCE    0x0152  # LATIN CAPITAL LIGATURE OE
0xCF    0x0153  # LATIN SMALL LIGATURE OE
0xD0    0x2013  # EN DASH
0xD1    0x2014  # EM DASH
0xD2    0x201C  # LEFT DOUBLE QUOTATION MARK
0xD3    0x201D  # RIGHT DOUBLE QUOTATION MARK
0xD4    0x2018  # LEFT SINGLE QUOTATION MARK
0xD5    0x2019  # RIGHT SINGLE QUOTATION MARK
0xD6    0x00F7  # DIVISION SIGN
0xD7    0x25CA  # LOZENGE
0xD8    0x00FF  # LATIN SMALL LETTER Y WITH DIAERESIS
0xD9    0x0178  # LATIN CAPITAL LETTER Y WITH DIAERESIS
0xDA    0x2044  # FRACTION SLASH
0xDB    0x20AC  # EURO SIGN
0xDC    0x2039  # SINGLE LEFT-POINTING ANGLE QUOTATION MARK
0xDD    0x203A  # SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
0xDE    0xFB01  # LATIN SMALL LIGATURE FI
0xDF    0xFB02  # LATIN SMALL LIGATURE FL
0xE0    0x2021  # DOUBLE DAGGER
0xE1    0x00B7  # MIDDLE DOT
0xE2    0x201A  # SINGLE LOW-9 QUOTATION MARK
0xE3    0x201E  # DOUBLE LOW-9 QUOTATION MARK
0xE4    0x2030  # PER MILLE SIGN
0xE5    0x00C2  # LATIN CAPITAL LETTER A WITH CIRCUMFLEX
0xE6    0x00CA  # LATIN CAPITAL LETTER E WITH CIRCUMFLEX
0xE7    0x00C1  # LATIN CAPITAL LETTER A WITH ACUTE
0xE8    0x00CB  # LATIN CAPITAL LETTER E WITH DIAERESIS
0xE9    0x00C8  # LATIN CAPITAL LETTER E WITH GRAVE
0xEA    0x00CD  # LATIN CAPITAL LETTER I WITH ACUTE
0xEB    0x00CE  # LATIN CAPITAL LETTER I WITH CIRCUMFLEX
0xEC    0x00CF  # LATIN CAPITAL LETTER I WITH DIAERESIS
0xED    0x00CC  # LATIN CAPITAL LETTER I WITH GRAVE
0xEE    0x00D3  # LATIN CAPITAL LETTER O WITH ACUTE
0xEF    0x00D4  # LATIN CAPITAL LETTER O WITH CIRCUMFLEX
0xF0    0xF8FF  # Apple logo
0xF1    0x00D2  # LATIN CAPITAL LETTER O WITH GRAVE
0xF2    0x00DA  # LATIN CAPITAL LETTER U WITH ACUTE
0xF3    0x00DB  # LATIN CAPITAL LETTER U WITH CIRCUMFLEX
0xF4    0x00D9  # LATIN CAPITAL LETTER U WITH GRAVE
0xF5    0x0131  # LATIN SMALL LETTER DOTLESS I
0xF6    0x02C6  # MODIFIER LETTER CIRCUMFLEX ACCENT
0xF7    0x02DC  # SMALL TILDE
0xF8    0x00AF  # MACRON
0xF9    0x02D8  # BREVE
0xFA    0x02D9  # DOT ABOVE
0xFB    0x02DA  # RING ABOVE
0xFC    0x00B8  # CEDILLA
0xFD    0x02DD  # DOUBLE ACUTE ACCENT
0xFE    0x02DB  # OGONEK
0xFF    0x02C7  # CARON

"
! !

!MAC_Roman methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16r1F ifTrue:[
        ^ self decodingError.
    ].
    code <= 16r7E ifTrue:[ ^ code ].
    code > 16rFF ifTrue:[
        ^ self decodingError.
    ].
    [
        |t|
        t := #(
           "16r007F"    16r0000 " invalid " 
           "16r0080"    16r00C4 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
           "16r0081"    16r00C5 " LATIN CAPITAL LETTER A WITH RING ABOVE " 
           "16r0082"    16r00C7 " LATIN CAPITAL LETTER C WITH CEDILLA " 
           "16r0083"    16r00C9 " LATIN CAPITAL LETTER E WITH ACUTE " 
           "16r0084"    16r00D1 " LATIN CAPITAL LETTER N WITH TILDE " 
           "16r0085"    16r00D6 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
           "16r0086"    16r00DC " LATIN CAPITAL LETTER U WITH DIAERESIS " 
           "16r0087"    16r00E1 " LATIN SMALL LETTER A WITH ACUTE " 
           "16r0088"    16r00E0 " LATIN SMALL LETTER A WITH GRAVE " 
           "16r0089"    16r00E2 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
           "16r008A"    16r00E4 " LATIN SMALL LETTER A WITH DIAERESIS " 
           "16r008B"    16r00E3 " LATIN SMALL LETTER A WITH TILDE " 
           "16r008C"    16r00E5 " LATIN SMALL LETTER A WITH RING ABOVE " 
           "16r008D"    16r00E7 " LATIN SMALL LETTER C WITH CEDILLA " 
           "16r008E"    16r00E9 " LATIN SMALL LETTER E WITH ACUTE " 
           "16r008F"    16r00E8 " LATIN SMALL LETTER E WITH GRAVE " 
           "16r0090"    16r00EA " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
           "16r0091"    16r00EB " LATIN SMALL LETTER E WITH DIAERESIS " 
           "16r0092"    16r00ED " LATIN SMALL LETTER I WITH ACUTE " 
           "16r0093"    16r00EC " LATIN SMALL LETTER I WITH GRAVE " 
           "16r0094"    16r00EE " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
           "16r0095"    16r00EF " LATIN SMALL LETTER I WITH DIAERESIS " 
           "16r0096"    16r00F1 " LATIN SMALL LETTER N WITH TILDE " 
           "16r0097"    16r00F3 " LATIN SMALL LETTER O WITH ACUTE " 
           "16r0098"    16r00F2 " LATIN SMALL LETTER O WITH GRAVE " 
           "16r0099"    16r00F4 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
           "16r009A"    16r00F6 " LATIN SMALL LETTER O WITH DIAERESIS " 
           "16r009B"    16r00F5 " LATIN SMALL LETTER O WITH TILDE " 
           "16r009C"    16r00FA " LATIN SMALL LETTER U WITH ACUTE " 
           "16r009D"    16r00F9 " LATIN SMALL LETTER U WITH GRAVE " 
           "16r009E"    16r00FB " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
           "16r009F"    16r00FC " LATIN SMALL LETTER U WITH DIAERESIS " 
           "16r00A0"    16r2020 " DAGGER " 
           "16r00A1"    16r00B0 " DEGREE SIGN " 
           "16r00A2"    16r00A2 " CENT SIGN " 
           "16r00A3"    16r00A3 " POUND SIGN " 
           "16r00A4"    16r00A7 " SECTION SIGN " 
           "16r00A5"    16r2022 " BULLET " 
           "16r00A6"    16r00B6 " PILCROW SIGN " 
           "16r00A7"    16r00DF " LATIN SMALL LETTER SHARP S " 
           "16r00A8"    16r00AE " REGISTERED SIGN " 
           "16r00A9"    16r00A9 " COPYRIGHT SIGN " 
           "16r00AA"    16r2122 " TRADE MARK SIGN " 
           "16r00AB"    16r00B4 " ACUTE ACCENT " 
           "16r00AC"    16r00A8 " DIAERESIS " 
           "16r00AD"    16r2260 " NOT EQUAL TO " 
           "16r00AE"    16r00C6 " LATIN CAPITAL LETTER AE " 
           "16r00AF"    16r00D8 " LATIN CAPITAL LETTER O WITH STROKE " 
           "16r00B0"    16r221E " INFINITY " 
           "16r00B1"    16r00B1 " PLUS-MINUS SIGN " 
           "16r00B2"    16r2264 " LESS-THAN OR EQUAL TO " 
           "16r00B3"    16r2265 " GREATER-THAN OR EQUAL TO " 
           "16r00B4"    16r00A5 " YEN SIGN " 
           "16r00B5"    16r00B5 " MICRO SIGN " 
           "16r00B6"    16r2202 " PARTIAL DIFFERENTIAL " 
           "16r00B7"    16r2211 " N-ARY SUMMATION " 
           "16r00B8"    16r220F " N-ARY PRODUCT " 
           "16r00B9"    16r03C0 " GREEK SMALL LETTER PI " 
           "16r00BA"    16r222B " INTEGRAL " 
           "16r00BB"    16r00AA " FEMININE ORDINAL INDICATOR " 
           "16r00BC"    16r00BA " MASCULINE ORDINAL INDICATOR " 
           "16r00BD"    16r03A9 " GREEK CAPITAL LETTER OMEGA " 
           "16r00BE"    16r00E6 " LATIN SMALL LETTER AE " 
           "16r00BF"    16r00F8 " LATIN SMALL LETTER O WITH STROKE " 
           "16r00C0"    16r00BF " INVERTED QUESTION MARK " 
           "16r00C1"    16r00A1 " INVERTED EXCLAMATION MARK " 
           "16r00C2"    16r00AC " NOT SIGN " 
           "16r00C3"    16r221A " SQUARE ROOT " 
           "16r00C4"    16r0192 " LATIN SMALL LETTER F WITH HOOK " 
           "16r00C5"    16r2248 " ALMOST EQUAL TO " 
           "16r00C6"    16r2206 " INCREMENT " 
           "16r00C7"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00C8"    16r00BB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00C9"    16r2026 " HORIZONTAL ELLIPSIS " 
           "16r00CA"    16r00A0 " NO-BREAK SPACE " 
           "16r00CB"    16r00C0 " LATIN CAPITAL LETTER A WITH GRAVE " 
           "16r00CC"    16r00C3 " LATIN CAPITAL LETTER A WITH TILDE " 
           "16r00CD"    16r00D5 " LATIN CAPITAL LETTER O WITH TILDE " 
           "16r00CE"    16r0152 " LATIN CAPITAL LIGATURE OE " 
           "16r00CF"    16r0153 " LATIN SMALL LIGATURE OE " 
           "16r00D0"    16r2013 " EN DASH " 
           "16r00D1"    16r2014 " EM DASH " 
           "16r00D2"    16r201C " LEFT DOUBLE QUOTATION MARK " 
           "16r00D3"    16r201D " RIGHT DOUBLE QUOTATION MARK " 
           "16r00D4"    16r2018 " LEFT SINGLE QUOTATION MARK " 
           "16r00D5"    16r2019 " RIGHT SINGLE QUOTATION MARK " 
           "16r00D6"    16r00F7 " DIVISION SIGN " 
           "16r00D7"    16r25CA " LOZENGE " 
           "16r00D8"    16r00FF " LATIN SMALL LETTER Y WITH DIAERESIS " 
           "16r00D9"    16r0178 " LATIN CAPITAL LETTER Y WITH DIAERESIS " 
           "16r00DA"    16r2044 " FRACTION SLASH " 
           "16r00DB"    16r20AC " EURO SIGN " 
           "16r00DC"    16r2039 " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
           "16r00DD"    16r203A " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
           "16r00DE"    16rFB01 " LATIN SMALL LIGATURE FI " 
           "16r00DF"    16rFB02 " LATIN SMALL LIGATURE FL " 
           "16r00E0"    16r2021 " DOUBLE DAGGER " 
           "16r00E1"    16r00B7 " MIDDLE DOT " 
           "16r00E2"    16r201A " SINGLE LOW-9 QUOTATION MARK " 
           "16r00E3"    16r201E " DOUBLE LOW-9 QUOTATION MARK " 
           "16r00E4"    16r2030 " PER MILLE SIGN " 
           "16r00E5"    16r00C2 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
           "16r00E6"    16r00CA " LATIN CAPITAL LETTER E WITH CIRCUMFLEX " 
           "16r00E7"    16r00C1 " LATIN CAPITAL LETTER A WITH ACUTE " 
           "16r00E8"    16r00CB " LATIN CAPITAL LETTER E WITH DIAERESIS " 
           "16r00E9"    16r00C8 " LATIN CAPITAL LETTER E WITH GRAVE " 
           "16r00EA"    16r00CD " LATIN CAPITAL LETTER I WITH ACUTE " 
           "16r00EB"    16r00CE " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
           "16r00EC"    16r00CF " LATIN CAPITAL LETTER I WITH DIAERESIS " 
           "16r00ED"    16r00CC " LATIN CAPITAL LETTER I WITH GRAVE " 
           "16r00EE"    16r00D3 " LATIN CAPITAL LETTER O WITH ACUTE " 
           "16r00EF"    16r00D4 " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
           "16r00F0"    16rF8FF " Apple logo " 
           "16r00F1"    16r00D2 " LATIN CAPITAL LETTER O WITH GRAVE " 
           "16r00F2"    16r00DA " LATIN CAPITAL LETTER U WITH ACUTE " 
           "16r00F3"    16r00DB " LATIN CAPITAL LETTER U WITH CIRCUMFLEX " 
           "16r00F4"    16r00D9 " LATIN CAPITAL LETTER U WITH GRAVE " 
           "16r00F5"    16r0131 " LATIN SMALL LETTER DOTLESS I " 
           "16r00F6"    16r02C6 " MODIFIER LETTER CIRCUMFLEX ACCENT " 
           "16r00F7"    16r02DC " SMALL TILDE " 
           "16r00F8"    16r00AF " MACRON " 
           "16r00F9"    16r02D8 " BREVE " 
           "16r00FA"    16r02D9 " DOT ABOVE " 
           "16r00FB"    16r02DA " RING ABOVE " 
           "16r00FC"    16r00B8 " CEDILLA " 
           "16r00FD"    16r02DD " DOUBLE ACUTE ACCENT " 
           "16r00FE"    16r02DB " OGONEK " 
           "16r00FF"    16r02C7 " CARON " 
           ) at:(code - 16r7E).
        t == 0 ifFalse:[^ t].
        ^ self decodingError.
    ] value.
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode <= 16r1F ifTrue:[
        ^ self decodingError.
    ].
    unicode <= 16r7E ifTrue:[ ^ unicode ].
    unicode > 16rFB02 ifTrue:[
        ^ self encodingError.
    ].
    unicode <= 16r9F ifTrue:[
        ^ self encodingError
    ].
    unicode <= 16r25CA ifTrue:[
        unicode <= 16r3C0 ifTrue:[
            unicode <= 16r192 ifTrue:[
                unicode <= 16rFF ifTrue:[
                    [
                        |t|
                        t := #[
                           "16r00A0"    16rCA " NO-BREAK SPACE " 
                           "16r00A1"    16rC1 " INVERTED EXCLAMATION MARK " 
                           "16r00A2"    16rA2 " CENT SIGN " 
                           "16r00A3"    16rA3 " POUND SIGN " 
                           "16r00A4"    16r00 " invalid " 
                           "16r00A5"    16rB4 " YEN SIGN " 
                           "16r00A6"    16r00 " invalid " 
                           "16r00A7"    16rA4 " SECTION SIGN " 
                           "16r00A8"    16rAC " DIAERESIS " 
                           "16r00A9"    16rA9 " COPYRIGHT SIGN " 
                           "16r00AA"    16rBB " FEMININE ORDINAL INDICATOR " 
                           "16r00AB"    16rC7 " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                           "16r00AC"    16rC2 " NOT SIGN " 
                           "16r00AD"    16r00 " invalid " 
                           "16r00AE"    16rA8 " REGISTERED SIGN " 
                           "16r00AF"    16rF8 " MACRON " 
                           "16r00B0"    16rA1 " DEGREE SIGN " 
                           "16r00B1"    16rB1 " PLUS-MINUS SIGN " 
                           "16r00B2"    16r00 " invalid " 
                           "16r00B3"    16r00 " invalid " 
                           "16r00B4"    16rAB " ACUTE ACCENT " 
                           "16r00B5"    16rB5 " MICRO SIGN " 
                           "16r00B6"    16rA6 " PILCROW SIGN " 
                           "16r00B7"    16rE1 " MIDDLE DOT " 
                           "16r00B8"    16rFC " CEDILLA " 
                           "16r00B9"    16r00 " invalid " 
                           "16r00BA"    16rBC " MASCULINE ORDINAL INDICATOR " 
                           "16r00BB"    16rC8 " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                           "16r00BC"    16r00 " invalid " 
                           "16r00BD"    16r00 " invalid " 
                           "16r00BE"    16r00 " invalid " 
                           "16r00BF"    16rC0 " INVERTED QUESTION MARK " 
                           "16r00C0"    16rCB " LATIN CAPITAL LETTER A WITH GRAVE " 
                           "16r00C1"    16rE7 " LATIN CAPITAL LETTER A WITH ACUTE " 
                           "16r00C2"    16rE5 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
                           "16r00C3"    16rCC " LATIN CAPITAL LETTER A WITH TILDE " 
                           "16r00C4"    16r80 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
                           "16r00C5"    16r81 " LATIN CAPITAL LETTER A WITH RING ABOVE " 
                           "16r00C6"    16rAE " LATIN CAPITAL LETTER AE " 
                           "16r00C7"    16r82 " LATIN CAPITAL LETTER C WITH CEDILLA " 
                           "16r00C8"    16rE9 " LATIN CAPITAL LETTER E WITH GRAVE " 
                           "16r00C9"    16r83 " LATIN CAPITAL LETTER E WITH ACUTE " 
                           "16r00CA"    16rE6 " LATIN CAPITAL LETTER E WITH CIRCUMFLEX " 
                           "16r00CB"    16rE8 " LATIN CAPITAL LETTER E WITH DIAERESIS " 
                           "16r00CC"    16rED " LATIN CAPITAL LETTER I WITH GRAVE " 
                           "16r00CD"    16rEA " LATIN CAPITAL LETTER I WITH ACUTE " 
                           "16r00CE"    16rEB " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
                           "16r00CF"    16rEC " LATIN CAPITAL LETTER I WITH DIAERESIS " 
                           "16r00D0"    16r00 " invalid " 
                           "16r00D1"    16r84 " LATIN CAPITAL LETTER N WITH TILDE " 
                           "16r00D2"    16rF1 " LATIN CAPITAL LETTER O WITH GRAVE " 
                           "16r00D3"    16rEE " LATIN CAPITAL LETTER O WITH ACUTE " 
                           "16r00D4"    16rEF " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
                           "16r00D5"    16rCD " LATIN CAPITAL LETTER O WITH TILDE " 
                           "16r00D6"    16r85 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
                           "16r00D7"    16r00 " invalid " 
                           "16r00D8"    16rAF " LATIN CAPITAL LETTER O WITH STROKE " 
                           "16r00D9"    16rF4 " LATIN CAPITAL LETTER U WITH GRAVE " 
                           "16r00DA"    16rF2 " LATIN CAPITAL LETTER U WITH ACUTE " 
                           "16r00DB"    16rF3 " LATIN CAPITAL LETTER U WITH CIRCUMFLEX " 
                           "16r00DC"    16r86 " LATIN CAPITAL LETTER U WITH DIAERESIS " 
                           "16r00DD"    16r00 " invalid " 
                           "16r00DE"    16r00 " invalid " 
                           "16r00DF"    16rA7 " LATIN SMALL LETTER SHARP S " 
                           "16r00E0"    16r88 " LATIN SMALL LETTER A WITH GRAVE " 
                           "16r00E1"    16r87 " LATIN SMALL LETTER A WITH ACUTE " 
                           "16r00E2"    16r89 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
                           "16r00E3"    16r8B " LATIN SMALL LETTER A WITH TILDE " 
                           "16r00E4"    16r8A " LATIN SMALL LETTER A WITH DIAERESIS " 
                           "16r00E5"    16r8C " LATIN SMALL LETTER A WITH RING ABOVE " 
                           "16r00E6"    16rBE " LATIN SMALL LETTER AE " 
                           "16r00E7"    16r8D " LATIN SMALL LETTER C WITH CEDILLA " 
                           "16r00E8"    16r8F " LATIN SMALL LETTER E WITH GRAVE " 
                           "16r00E9"    16r8E " LATIN SMALL LETTER E WITH ACUTE " 
                           "16r00EA"    16r90 " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
                           "16r00EB"    16r91 " LATIN SMALL LETTER E WITH DIAERESIS " 
                           "16r00EC"    16r93 " LATIN SMALL LETTER I WITH GRAVE " 
                           "16r00ED"    16r92 " LATIN SMALL LETTER I WITH ACUTE " 
                           "16r00EE"    16r94 " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
                           "16r00EF"    16r95 " LATIN SMALL LETTER I WITH DIAERESIS " 
                           "16r00F0"    16r00 " invalid " 
                           "16r00F1"    16r96 " LATIN SMALL LETTER N WITH TILDE " 
                           "16r00F2"    16r98 " LATIN SMALL LETTER O WITH GRAVE " 
                           "16r00F3"    16r97 " LATIN SMALL LETTER O WITH ACUTE " 
                           "16r00F4"    16r99 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
                           "16r00F5"    16r9B " LATIN SMALL LETTER O WITH TILDE " 
                           "16r00F6"    16r9A " LATIN SMALL LETTER O WITH DIAERESIS " 
                           "16r00F7"    16rD6 " DIVISION SIGN " 
                           "16r00F8"    16rBF " LATIN SMALL LETTER O WITH STROKE " 
                           "16r00F9"    16r9D " LATIN SMALL LETTER U WITH GRAVE " 
                           "16r00FA"    16r9C " LATIN SMALL LETTER U WITH ACUTE " 
                           "16r00FB"    16r9E " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
                           "16r00FC"    16r9F " LATIN SMALL LETTER U WITH DIAERESIS " 
                           "16r00FD"    16r00 " invalid " 
                           "16r00FE"    16r00 " invalid " 
                           "16r00FF"    16rD8 " LATIN SMALL LETTER Y WITH DIAERESIS " 
                           ] at:(unicode - 16r9F).
                        t == 0 ifFalse:[^ t].
                        ^ self encodingError
                    ] value.
                ].
                unicode <= 16r130 ifTrue:[
                    ^ self encodingError
                ].
                unicode <= 16r153 ifTrue:[
                    unicode == 16r131 ifTrue:[
                        ^  "16r0131" 16r00F5 " LATIN SMALL LETTER DOTLESS I " 
                    ].
                    unicode <= 16r151 ifTrue:[
                        ^ self encodingError
                    ].
                    ^ #[
                       "16r0152"    16rCE " LATIN CAPITAL LIGATURE OE " 
                       "16r0153"    16rCF " LATIN SMALL LIGATURE OE " 
                       ] at:(unicode - 16r151).
                ].
                unicode <= 16r177 ifTrue:[
                    ^ self encodingError
                ].
                unicode == 16r178 ifTrue:[
                    ^  "16r0178" 16r00D9 " LATIN CAPITAL LETTER Y WITH DIAERESIS " 
                ].
                unicode <= 16r191 ifTrue:[
                    ^ self encodingError
                ].
                ^  "16r0192" 16r00C4 " LATIN SMALL LETTER F WITH HOOK " 
            ].
            unicode <= 16r2C5 ifTrue:[
                ^ self encodingError
            ].
            unicode <= 16r2DD ifTrue:[
                unicode <= 16r2C7 ifTrue:[
                    ^ #[
                       "16r02C6"    16rF6 " MODIFIER LETTER CIRCUMFLEX ACCENT " 
                       "16r02C7"    16rFF " CARON " 
                       ] at:(unicode - 16r2C5).
                ].
                unicode <= 16r2D7 ifTrue:[
                    ^ self encodingError
                ].
                ^ #[
                   "16r02D8"    16rF9 " BREVE " 
                   "16r02D9"    16rFA " DOT ABOVE " 
                   "16r02DA"    16rFB " RING ABOVE " 
                   "16r02DB"    16rFE " OGONEK " 
                   "16r02DC"    16rF7 " SMALL TILDE " 
                   "16r02DD"    16rFD " DOUBLE ACUTE ACCENT " 
                   ] at:(unicode - 16r2D7).
            ].
            unicode <= 16r3A8 ifTrue:[
                ^ self encodingError
            ].
            unicode == 16r3A9 ifTrue:[
                ^  "16r03A9" 16r00BD " GREEK CAPITAL LETTER OMEGA " 
            ].
            unicode <= 16r3BF ifTrue:[
                ^ self encodingError
            ].
            ^  "16r03C0" 16r00B9 " GREEK SMALL LETTER PI " 
        ].
        unicode <= 16r2012 ifTrue:[
            ^ self encodingError
        ].
        unicode <= 16r2265 ifTrue:[
            unicode <= 16r2122 ifTrue:[
                unicode <= 16r20AC ifTrue:[
                    unicode <= 16r2044 ifTrue:[
                        [
                            |t|
                            t := #[
                               "16r2013"    16rD0 " EN DASH " 
                               "16r2014"    16rD1 " EM DASH " 
                               "16r2015"    16r00 " invalid " 
                               "16r2016"    16r00 " invalid " 
                               "16r2017"    16r00 " invalid " 
                               "16r2018"    16rD4 " LEFT SINGLE QUOTATION MARK " 
                               "16r2019"    16rD5 " RIGHT SINGLE QUOTATION MARK " 
                               "16r201A"    16rE2 " SINGLE LOW-9 QUOTATION MARK " 
                               "16r201B"    16r00 " invalid " 
                               "16r201C"    16rD2 " LEFT DOUBLE QUOTATION MARK " 
                               "16r201D"    16rD3 " RIGHT DOUBLE QUOTATION MARK " 
                               "16r201E"    16rE3 " DOUBLE LOW-9 QUOTATION MARK " 
                               "16r201F"    16r00 " invalid " 
                               "16r2020"    16rA0 " DAGGER " 
                               "16r2021"    16rE0 " DOUBLE DAGGER " 
                               "16r2022"    16rA5 " BULLET " 
                               "16r2023"    16r00 " invalid " 
                               "16r2024"    16r00 " invalid " 
                               "16r2025"    16r00 " invalid " 
                               "16r2026"    16rC9 " HORIZONTAL ELLIPSIS " 
                               "16r2027"    16r00 " invalid " 
                               "16r2028"    16r00 " invalid " 
                               "16r2029"    16r00 " invalid " 
                               "16r202A"    16r00 " invalid " 
                               "16r202B"    16r00 " invalid " 
                               "16r202C"    16r00 " invalid " 
                               "16r202D"    16r00 " invalid " 
                               "16r202E"    16r00 " invalid " 
                               "16r202F"    16r00 " invalid " 
                               "16r2030"    16rE4 " PER MILLE SIGN " 
                               "16r2031"    16r00 " invalid " 
                               "16r2032"    16r00 " invalid " 
                               "16r2033"    16r00 " invalid " 
                               "16r2034"    16r00 " invalid " 
                               "16r2035"    16r00 " invalid " 
                               "16r2036"    16r00 " invalid " 
                               "16r2037"    16r00 " invalid " 
                               "16r2038"    16r00 " invalid " 
                               "16r2039"    16rDC " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
                               "16r203A"    16rDD " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
                               "16r203B"    16r00 " invalid " 
                               "16r203C"    16r00 " invalid " 
                               "16r203D"    16r00 " invalid " 
                               "16r203E"    16r00 " invalid " 
                               "16r203F"    16r00 " invalid " 
                               "16r2040"    16r00 " invalid " 
                               "16r2041"    16r00 " invalid " 
                               "16r2042"    16r00 " invalid " 
                               "16r2043"    16r00 " invalid " 
                               "16r2044"    16rDA " FRACTION SLASH " 
                               ] at:(unicode - 16r2012).
                            t == 0 ifFalse:[^ t].
                            ^ self encodingError
                        ] value.
                    ].
                    unicode <= 16r20AB ifTrue:[
                        ^ self encodingError
                    ].
                    ^  "16r20AC" 16r00DB " EURO SIGN " 
                ].
                unicode <= 16r2121 ifTrue:[
                    ^ self encodingError
                ].
                ^  "16r2122" 16r00AA " TRADE MARK SIGN " 
            ].
            unicode <= 16r2201 ifTrue:[
                ^ self encodingError
            ].
            [
                |t|
                t := #[
                   "16r2202"    16rB6 " PARTIAL DIFFERENTIAL " 
                   "16r2203"    16r00 " invalid " 
                   "16r2204"    16r00 " invalid " 
                   "16r2205"    16r00 " invalid " 
                   "16r2206"    16rC6 " INCREMENT " 
                   "16r2207"    16r00 " invalid " 
                   "16r2208"    16r00 " invalid " 
                   "16r2209"    16r00 " invalid " 
                   "16r220A"    16r00 " invalid " 
                   "16r220B"    16r00 " invalid " 
                   "16r220C"    16r00 " invalid " 
                   "16r220D"    16r00 " invalid " 
                   "16r220E"    16r00 " invalid " 
                   "16r220F"    16rB8 " N-ARY PRODUCT " 
                   "16r2210"    16r00 " invalid " 
                   "16r2211"    16rB7 " N-ARY SUMMATION " 
                   "16r2212"    16r00 " invalid " 
                   "16r2213"    16r00 " invalid " 
                   "16r2214"    16r00 " invalid " 
                   "16r2215"    16r00 " invalid " 
                   "16r2216"    16r00 " invalid " 
                   "16r2217"    16r00 " invalid " 
                   "16r2218"    16r00 " invalid " 
                   "16r2219"    16r00 " invalid " 
                   "16r221A"    16rC3 " SQUARE ROOT " 
                   "16r221B"    16r00 " invalid " 
                   "16r221C"    16r00 " invalid " 
                   "16r221D"    16r00 " invalid " 
                   "16r221E"    16rB0 " INFINITY " 
                   "16r221F"    16r00 " invalid " 
                   "16r2220"    16r00 " invalid " 
                   "16r2221"    16r00 " invalid " 
                   "16r2222"    16r00 " invalid " 
                   "16r2223"    16r00 " invalid " 
                   "16r2224"    16r00 " invalid " 
                   "16r2225"    16r00 " invalid " 
                   "16r2226"    16r00 " invalid " 
                   "16r2227"    16r00 " invalid " 
                   "16r2228"    16r00 " invalid " 
                   "16r2229"    16r00 " invalid " 
                   "16r222A"    16r00 " invalid " 
                   "16r222B"    16rBA " INTEGRAL " 
                   "16r222C"    16r00 " invalid " 
                   "16r222D"    16r00 " invalid " 
                   "16r222E"    16r00 " invalid " 
                   "16r222F"    16r00 " invalid " 
                   "16r2230"    16r00 " invalid " 
                   "16r2231"    16r00 " invalid " 
                   "16r2232"    16r00 " invalid " 
                   "16r2233"    16r00 " invalid " 
                   "16r2234"    16r00 " invalid " 
                   "16r2235"    16r00 " invalid " 
                   "16r2236"    16r00 " invalid " 
                   "16r2237"    16r00 " invalid " 
                   "16r2238"    16r00 " invalid " 
                   "16r2239"    16r00 " invalid " 
                   "16r223A"    16r00 " invalid " 
                   "16r223B"    16r00 " invalid " 
                   "16r223C"    16r00 " invalid " 
                   "16r223D"    16r00 " invalid " 
                   "16r223E"    16r00 " invalid " 
                   "16r223F"    16r00 " invalid " 
                   "16r2240"    16r00 " invalid " 
                   "16r2241"    16r00 " invalid " 
                   "16r2242"    16r00 " invalid " 
                   "16r2243"    16r00 " invalid " 
                   "16r2244"    16r00 " invalid " 
                   "16r2245"    16r00 " invalid " 
                   "16r2246"    16r00 " invalid " 
                   "16r2247"    16r00 " invalid " 
                   "16r2248"    16rC5 " ALMOST EQUAL TO " 
                   "16r2249"    16r00 " invalid " 
                   "16r224A"    16r00 " invalid " 
                   "16r224B"    16r00 " invalid " 
                   "16r224C"    16r00 " invalid " 
                   "16r224D"    16r00 " invalid " 
                   "16r224E"    16r00 " invalid " 
                   "16r224F"    16r00 " invalid " 
                   "16r2250"    16r00 " invalid " 
                   "16r2251"    16r00 " invalid " 
                   "16r2252"    16r00 " invalid " 
                   "16r2253"    16r00 " invalid " 
                   "16r2254"    16r00 " invalid " 
                   "16r2255"    16r00 " invalid " 
                   "16r2256"    16r00 " invalid " 
                   "16r2257"    16r00 " invalid " 
                   "16r2258"    16r00 " invalid " 
                   "16r2259"    16r00 " invalid " 
                   "16r225A"    16r00 " invalid " 
                   "16r225B"    16r00 " invalid " 
                   "16r225C"    16r00 " invalid " 
                   "16r225D"    16r00 " invalid " 
                   "16r225E"    16r00 " invalid " 
                   "16r225F"    16r00 " invalid " 
                   "16r2260"    16rAD " NOT EQUAL TO " 
                   "16r2261"    16r00 " invalid " 
                   "16r2262"    16r00 " invalid " 
                   "16r2263"    16r00 " invalid " 
                   "16r2264"    16rB2 " LESS-THAN OR EQUAL TO " 
                   "16r2265"    16rB3 " GREATER-THAN OR EQUAL TO " 
                   ] at:(unicode - 16r2201).
                t == 0 ifFalse:[^ t].
                ^ self encodingError
            ] value.
        ].
        unicode <= 16r25C9 ifTrue:[
            ^ self encodingError
        ].
        ^  "16r25CA" 16r00D7 " LOZENGE " 
    ].
    unicode <= 16rF8FE ifTrue:[
        ^ self encodingError
    ].
    unicode == 16rF8FF ifTrue:[
        ^  "16rF8FF" 16r00F0 " Apple logo " 
    ].
    unicode <= 16rFB00 ifTrue:[
        ^ self encodingError
    ].
    ^ #[
       "16rFB01"    16rDE " LATIN SMALL LIGATURE FI " 
       "16rFB02"    16rDF " LATIN SMALL LIGATURE FL " 
       ] at:(unicode - 16rFB00).
! !

!MAC_Roman class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

