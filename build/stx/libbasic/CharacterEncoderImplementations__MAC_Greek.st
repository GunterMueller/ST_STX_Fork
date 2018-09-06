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

SingleByteEncoder subclass:#MAC_Greek
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!MAC_Greek class methodsFor:'documentation'!

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
! !

!MAC_Greek class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'VENDORS/APPLE/GREEK.TXT'
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/GREEK.TXT

#=======================================================================
#   File name:  GREEK.TXT
#
#   Contents:   Map (external version) from Mac OS Greek
#               character set to Unicode 2.1 through Unicode 3.2
#
#   Copyright:  (c) 1995-2002 by Apple Computer, Inc., all rights
#               reserved.
#
#   Contact:    charsets@apple.com
#
#   Changes:
#
#      b3,c1 2002-Dec-19    Update to match changes in Mac OS Greek
#                           encoding for Mac OS 9.2.2 and later.
#                           Update URLs, notes. Matches internal
#                           utom<b3>.
#       b02  1999-Sep-22    Update contact e-mail address. Matches
#                           internal utom<b1>, ufrm<b1>, and Text
#                           Encoding Converter version 1.5.
#       n06  1998-Feb-05    Update to match internal utom<n4>, ufrm<n17>,
#                           and Text Encoding Converter versions 1.3:
#                           Change mapping for 0xAF from U+0387 to its
#                           canonical decomposition, U+00B7. Also
#                           update header comments to new format.
#       n04  1995-Apr-15    First version (after fixing some typos).
#                           Matches internal ufrm<n7>.
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
#     Column #1 is the Mac OS Greek code (in hex as 0xNN)
#     Column #2 is the corresponding Unicode (in hex as 0xNNNN)
#     Column #3 is a comment containing the Unicode name
#
#   The entries are in Mac OS Greek code order.
#
#   One of these mappings requires the use of a corporate character.
#   See the file 'CORPCHAR.TXT' and notes below.
#
#   Control character mappings are not shown in this table, following
#   the conventions of the standard UTC mapping tables. However, the
#   Mac OS Greek character set uses the standard control characters at
#   0x00-0x1F and 0x7F.
#
# Notes on Mac OS Greek:
# ----------------------
#
#   Although a Mac OS script code is defined for Greek (smGreek = 6),
#   the Greek localized system does not currently use it (the font
#   family IDs are in the Mac OS Roman range). To determine if the
#   Greek encoding is being used when the script code is smRoman (0),
#   you must check if the system region code is 20, verGreece.
#
#   The Mac OS Greek encoding is a superset of the repertoire of
#   ISO 8859-7 (although characters are not at the same code points),
#   except that LEFT & RIGHT SINGLE QUOTATION MARK replace the
#   MODIFIER LETTER REVERSED COMMA & APOSTROPHE (spacing versions of
#   Greek rough & smooth breathing marks) that are in ISO 8859-7.
#   The added characters in Mac OS Greek include more punctuation and
#   symbols and several accented Latin letters.
#
#   Before Mac OS 9.2.2, code point 0x9C was SOFT HYPHEN (U+00AD), and
#   code point 0xFF was undefined. In Mac OS 9.2.2 and later versions,
#   SOFT HYPHEN was moved to 0xFF, and code point 0x9C was changed to be
#   EURO SIGN (U+20AC); the standard Apple fonts are updated for Mac OS
#   9.2.2 to reflect this. There is a 'no Euro sign' variant of the Mac
#   OS Greek encoding that uses the older mapping; this can be used for
#   older fonts.
#
#   This 'no Euro sign' variant of Mac OS Greek was the character set
#   used by Mac OS Greek systems before 9.2.2 except for system 6.0.7,
#   which used a variant character set but was quickly replaced with
#   Greek system 6.0.7.1 using the no Euro sign' character set
#   documented here. Greek system 4.1 used a variant Greek set that had
#   ISO 8859-7 in 0xA0-0xFF (with some holes filled in with DTP
#   characters), and Mac OS Roman accented Roman letters in 0x80-0x9F.
#
# Unicode mapping issues and notes:
# ---------------------------------
#
# Details of mapping changes in each version:
# -------------------------------------------
#
#   Changes from version b02 to version b03/c01:
#
#   - The Mac OS Greek encoding changed for Mac OS 9.2.2 and later
#     as follows:
#     0x9C, changed from 0x00AD SOFT HYPHEN to 0x20AC EURO SIGN
#     0xFF, changed from undefined to 0x00AD SOFT HYPHEN
#
#   Changes from version n04 to version n06:
#
#   - Change mapping of 0xAF from U+0387 to its canonical
#     decomposition, U+00B7.
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
0x81    0x00B9  # SUPERSCRIPT ONE
0x82    0x00B2  # SUPERSCRIPT TWO
0x83    0x00C9  # LATIN CAPITAL LETTER E WITH ACUTE
0x84    0x00B3  # SUPERSCRIPT THREE
0x85    0x00D6  # LATIN CAPITAL LETTER O WITH DIAERESIS
0x86    0x00DC  # LATIN CAPITAL LETTER U WITH DIAERESIS
0x87    0x0385  # GREEK DIALYTIKA TONOS
0x88    0x00E0  # LATIN SMALL LETTER A WITH GRAVE
0x89    0x00E2  # LATIN SMALL LETTER A WITH CIRCUMFLEX
0x8A    0x00E4  # LATIN SMALL LETTER A WITH DIAERESIS
0x8B    0x0384  # GREEK TONOS
0x8C    0x00A8  # DIAERESIS
0x8D    0x00E7  # LATIN SMALL LETTER C WITH CEDILLA
0x8E    0x00E9  # LATIN SMALL LETTER E WITH ACUTE
0x8F    0x00E8  # LATIN SMALL LETTER E WITH GRAVE
0x90    0x00EA  # LATIN SMALL LETTER E WITH CIRCUMFLEX
0x91    0x00EB  # LATIN SMALL LETTER E WITH DIAERESIS
0x92    0x00A3  # POUND SIGN
0x93    0x2122  # TRADE MARK SIGN
0x94    0x00EE  # LATIN SMALL LETTER I WITH CIRCUMFLEX
0x95    0x00EF  # LATIN SMALL LETTER I WITH DIAERESIS
0x96    0x2022  # BULLET
0x97    0x00BD  # VULGAR FRACTION ONE HALF
0x98    0x2030  # PER MILLE SIGN
0x99    0x00F4  # LATIN SMALL LETTER O WITH CIRCUMFLEX
0x9A    0x00F6  # LATIN SMALL LETTER O WITH DIAERESIS
0x9B    0x00A6  # BROKEN BAR
0x9C    0x20AC  # EURO SIGN # before Mac OS 9.2.2, was SOFT HYPHEN
0x9D    0x00F9  # LATIN SMALL LETTER U WITH GRAVE
0x9E    0x00FB  # LATIN SMALL LETTER U WITH CIRCUMFLEX
0x9F    0x00FC  # LATIN SMALL LETTER U WITH DIAERESIS
0xA0    0x2020  # DAGGER
0xA1    0x0393  # GREEK CAPITAL LETTER GAMMA
0xA2    0x0394  # GREEK CAPITAL LETTER DELTA
0xA3    0x0398  # GREEK CAPITAL LETTER THETA
0xA4    0x039B  # GREEK CAPITAL LETTER LAMDA
0xA5    0x039E  # GREEK CAPITAL LETTER XI
0xA6    0x03A0  # GREEK CAPITAL LETTER PI
0xA7    0x00DF  # LATIN SMALL LETTER SHARP S
0xA8    0x00AE  # REGISTERED SIGN
0xA9    0x00A9  # COPYRIGHT SIGN
0xAA    0x03A3  # GREEK CAPITAL LETTER SIGMA
0xAB    0x03AA  # GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
0xAC    0x00A7  # SECTION SIGN
0xAD    0x2260  # NOT EQUAL TO
0xAE    0x00B0  # DEGREE SIGN
0xAF    0x00B7  # MIDDLE DOT
0xB0    0x0391  # GREEK CAPITAL LETTER ALPHA
0xB1    0x00B1  # PLUS-MINUS SIGN
0xB2    0x2264  # LESS-THAN OR EQUAL TO
0xB3    0x2265  # GREATER-THAN OR EQUAL TO
0xB4    0x00A5  # YEN SIGN
0xB5    0x0392  # GREEK CAPITAL LETTER BETA
0xB6    0x0395  # GREEK CAPITAL LETTER EPSILON
0xB7    0x0396  # GREEK CAPITAL LETTER ZETA
0xB8    0x0397  # GREEK CAPITAL LETTER ETA
0xB9    0x0399  # GREEK CAPITAL LETTER IOTA
0xBA    0x039A  # GREEK CAPITAL LETTER KAPPA
0xBB    0x039C  # GREEK CAPITAL LETTER MU
0xBC    0x03A6  # GREEK CAPITAL LETTER PHI
0xBD    0x03AB  # GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
0xBE    0x03A8  # GREEK CAPITAL LETTER PSI
0xBF    0x03A9  # GREEK CAPITAL LETTER OMEGA
0xC0    0x03AC  # GREEK SMALL LETTER ALPHA WITH TONOS
0xC1    0x039D  # GREEK CAPITAL LETTER NU
0xC2    0x00AC  # NOT SIGN
0xC3    0x039F  # GREEK CAPITAL LETTER OMICRON
0xC4    0x03A1  # GREEK CAPITAL LETTER RHO
0xC5    0x2248  # ALMOST EQUAL TO
0xC6    0x03A4  # GREEK CAPITAL LETTER TAU
0xC7    0x00AB  # LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
0xC8    0x00BB  # RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
0xC9    0x2026  # HORIZONTAL ELLIPSIS
0xCA    0x00A0  # NO-BREAK SPACE
0xCB    0x03A5  # GREEK CAPITAL LETTER UPSILON
0xCC    0x03A7  # GREEK CAPITAL LETTER CHI
0xCD    0x0386  # GREEK CAPITAL LETTER ALPHA WITH TONOS
0xCE    0x0388  # GREEK CAPITAL LETTER EPSILON WITH TONOS
0xCF    0x0153  # LATIN SMALL LIGATURE OE
0xD0    0x2013  # EN DASH
0xD1    0x2015  # HORIZONTAL BAR
0xD2    0x201C  # LEFT DOUBLE QUOTATION MARK
0xD3    0x201D  # RIGHT DOUBLE QUOTATION MARK
0xD4    0x2018  # LEFT SINGLE QUOTATION MARK
0xD5    0x2019  # RIGHT SINGLE QUOTATION MARK
0xD6    0x00F7  # DIVISION SIGN
0xD7    0x0389  # GREEK CAPITAL LETTER ETA WITH TONOS
0xD8    0x038A  # GREEK CAPITAL LETTER IOTA WITH TONOS
0xD9    0x038C  # GREEK CAPITAL LETTER OMICRON WITH TONOS
0xDA    0x038E  # GREEK CAPITAL LETTER UPSILON WITH TONOS
0xDB    0x03AD  # GREEK SMALL LETTER EPSILON WITH TONOS
0xDC    0x03AE  # GREEK SMALL LETTER ETA WITH TONOS
0xDD    0x03AF  # GREEK SMALL LETTER IOTA WITH TONOS
0xDE    0x03CC  # GREEK SMALL LETTER OMICRON WITH TONOS
0xDF    0x038F  # GREEK CAPITAL LETTER OMEGA WITH TONOS
0xE0    0x03CD  # GREEK SMALL LETTER UPSILON WITH TONOS
0xE1    0x03B1  # GREEK SMALL LETTER ALPHA
0xE2    0x03B2  # GREEK SMALL LETTER BETA
0xE3    0x03C8  # GREEK SMALL LETTER PSI
0xE4    0x03B4  # GREEK SMALL LETTER DELTA
0xE5    0x03B5  # GREEK SMALL LETTER EPSILON
0xE6    0x03C6  # GREEK SMALL LETTER PHI
0xE7    0x03B3  # GREEK SMALL LETTER GAMMA
0xE8    0x03B7  # GREEK SMALL LETTER ETA
0xE9    0x03B9  # GREEK SMALL LETTER IOTA
0xEA    0x03BE  # GREEK SMALL LETTER XI
0xEB    0x03BA  # GREEK SMALL LETTER KAPPA
0xEC    0x03BB  # GREEK SMALL LETTER LAMDA
0xED    0x03BC  # GREEK SMALL LETTER MU
0xEE    0x03BD  # GREEK SMALL LETTER NU
0xEF    0x03BF  # GREEK SMALL LETTER OMICRON
0xF0    0x03C0  # GREEK SMALL LETTER PI
0xF1    0x03CE  # GREEK SMALL LETTER OMEGA WITH TONOS
0xF2    0x03C1  # GREEK SMALL LETTER RHO
0xF3    0x03C3  # GREEK SMALL LETTER SIGMA
0xF4    0x03C4  # GREEK SMALL LETTER TAU
0xF5    0x03B8  # GREEK SMALL LETTER THETA
0xF6    0x03C9  # GREEK SMALL LETTER OMEGA
0xF7    0x03C2  # GREEK SMALL LETTER FINAL SIGMA
0xF8    0x03C7  # GREEK SMALL LETTER CHI
0xF9    0x03C5  # GREEK SMALL LETTER UPSILON
0xFA    0x03B6  # GREEK SMALL LETTER ZETA
0xFB    0x03CA  # GREEK SMALL LETTER IOTA WITH DIALYTIKA
0xFC    0x03CB  # GREEK SMALL LETTER UPSILON WITH DIALYTIKA
0xFD    0x0390  # GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
0xFE    0x03B0  # GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
0xFF    0x00AD  # SOFT HYPHEN # before Mac OS 9.2.2, was undefined

"
! !

!MAC_Greek methodsFor:'encoding & decoding'!

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
           "16r0081"    16r00B9 " SUPERSCRIPT ONE " 
           "16r0082"    16r00B2 " SUPERSCRIPT TWO " 
           "16r0083"    16r00C9 " LATIN CAPITAL LETTER E WITH ACUTE " 
           "16r0084"    16r00B3 " SUPERSCRIPT THREE " 
           "16r0085"    16r00D6 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
           "16r0086"    16r00DC " LATIN CAPITAL LETTER U WITH DIAERESIS " 
           "16r0087"    16r0385 " GREEK DIALYTIKA TONOS " 
           "16r0088"    16r00E0 " LATIN SMALL LETTER A WITH GRAVE " 
           "16r0089"    16r00E2 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
           "16r008A"    16r00E4 " LATIN SMALL LETTER A WITH DIAERESIS " 
           "16r008B"    16r0384 " GREEK TONOS " 
           "16r008C"    16r00A8 " DIAERESIS " 
           "16r008D"    16r00E7 " LATIN SMALL LETTER C WITH CEDILLA " 
           "16r008E"    16r00E9 " LATIN SMALL LETTER E WITH ACUTE " 
           "16r008F"    16r00E8 " LATIN SMALL LETTER E WITH GRAVE " 
           "16r0090"    16r00EA " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
           "16r0091"    16r00EB " LATIN SMALL LETTER E WITH DIAERESIS " 
           "16r0092"    16r00A3 " POUND SIGN " 
           "16r0093"    16r2122 " TRADE MARK SIGN " 
           "16r0094"    16r00EE " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
           "16r0095"    16r00EF " LATIN SMALL LETTER I WITH DIAERESIS " 
           "16r0096"    16r2022 " BULLET " 
           "16r0097"    16r00BD " VULGAR FRACTION ONE HALF " 
           "16r0098"    16r2030 " PER MILLE SIGN " 
           "16r0099"    16r00F4 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
           "16r009A"    16r00F6 " LATIN SMALL LETTER O WITH DIAERESIS " 
           "16r009B"    16r00A6 " BROKEN BAR " 
           "16r009C"    16r20AC " EURO SIGN # before Mac OS 9.2.2, was SOFT HYPHEN " 
           "16r009D"    16r00F9 " LATIN SMALL LETTER U WITH GRAVE " 
           "16r009E"    16r00FB " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
           "16r009F"    16r00FC " LATIN SMALL LETTER U WITH DIAERESIS " 
           "16r00A0"    16r2020 " DAGGER " 
           "16r00A1"    16r0393 " GREEK CAPITAL LETTER GAMMA " 
           "16r00A2"    16r0394 " GREEK CAPITAL LETTER DELTA " 
           "16r00A3"    16r0398 " GREEK CAPITAL LETTER THETA " 
           "16r00A4"    16r039B " GREEK CAPITAL LETTER LAMDA " 
           "16r00A5"    16r039E " GREEK CAPITAL LETTER XI " 
           "16r00A6"    16r03A0 " GREEK CAPITAL LETTER PI " 
           "16r00A7"    16r00DF " LATIN SMALL LETTER SHARP S " 
           "16r00A8"    16r00AE " REGISTERED SIGN " 
           "16r00A9"    16r00A9 " COPYRIGHT SIGN " 
           "16r00AA"    16r03A3 " GREEK CAPITAL LETTER SIGMA " 
           "16r00AB"    16r03AA " GREEK CAPITAL LETTER IOTA WITH DIALYTIKA " 
           "16r00AC"    16r00A7 " SECTION SIGN " 
           "16r00AD"    16r2260 " NOT EQUAL TO " 
           "16r00AE"    16r00B0 " DEGREE SIGN " 
           "16r00AF"    16r00B7 " MIDDLE DOT " 
           "16r00B0"    16r0391 " GREEK CAPITAL LETTER ALPHA " 
           "16r00B1"    16r00B1 " PLUS-MINUS SIGN " 
           "16r00B2"    16r2264 " LESS-THAN OR EQUAL TO " 
           "16r00B3"    16r2265 " GREATER-THAN OR EQUAL TO " 
           "16r00B4"    16r00A5 " YEN SIGN " 
           "16r00B5"    16r0392 " GREEK CAPITAL LETTER BETA " 
           "16r00B6"    16r0395 " GREEK CAPITAL LETTER EPSILON " 
           "16r00B7"    16r0396 " GREEK CAPITAL LETTER ZETA " 
           "16r00B8"    16r0397 " GREEK CAPITAL LETTER ETA " 
           "16r00B9"    16r0399 " GREEK CAPITAL LETTER IOTA " 
           "16r00BA"    16r039A " GREEK CAPITAL LETTER KAPPA " 
           "16r00BB"    16r039C " GREEK CAPITAL LETTER MU " 
           "16r00BC"    16r03A6 " GREEK CAPITAL LETTER PHI " 
           "16r00BD"    16r03AB " GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA " 
           "16r00BE"    16r03A8 " GREEK CAPITAL LETTER PSI " 
           "16r00BF"    16r03A9 " GREEK CAPITAL LETTER OMEGA " 
           "16r00C0"    16r03AC " GREEK SMALL LETTER ALPHA WITH TONOS " 
           "16r00C1"    16r039D " GREEK CAPITAL LETTER NU " 
           "16r00C2"    16r00AC " NOT SIGN " 
           "16r00C3"    16r039F " GREEK CAPITAL LETTER OMICRON " 
           "16r00C4"    16r03A1 " GREEK CAPITAL LETTER RHO " 
           "16r00C5"    16r2248 " ALMOST EQUAL TO " 
           "16r00C6"    16r03A4 " GREEK CAPITAL LETTER TAU " 
           "16r00C7"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00C8"    16r00BB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00C9"    16r2026 " HORIZONTAL ELLIPSIS " 
           "16r00CA"    16r00A0 " NO-BREAK SPACE " 
           "16r00CB"    16r03A5 " GREEK CAPITAL LETTER UPSILON " 
           "16r00CC"    16r03A7 " GREEK CAPITAL LETTER CHI " 
           "16r00CD"    16r0386 " GREEK CAPITAL LETTER ALPHA WITH TONOS " 
           "16r00CE"    16r0388 " GREEK CAPITAL LETTER EPSILON WITH TONOS " 
           "16r00CF"    16r0153 " LATIN SMALL LIGATURE OE " 
           "16r00D0"    16r2013 " EN DASH " 
           "16r00D1"    16r2015 " HORIZONTAL BAR " 
           "16r00D2"    16r201C " LEFT DOUBLE QUOTATION MARK " 
           "16r00D3"    16r201D " RIGHT DOUBLE QUOTATION MARK " 
           "16r00D4"    16r2018 " LEFT SINGLE QUOTATION MARK " 
           "16r00D5"    16r2019 " RIGHT SINGLE QUOTATION MARK " 
           "16r00D6"    16r00F7 " DIVISION SIGN " 
           "16r00D7"    16r0389 " GREEK CAPITAL LETTER ETA WITH TONOS " 
           "16r00D8"    16r038A " GREEK CAPITAL LETTER IOTA WITH TONOS " 
           "16r00D9"    16r038C " GREEK CAPITAL LETTER OMICRON WITH TONOS " 
           "16r00DA"    16r038E " GREEK CAPITAL LETTER UPSILON WITH TONOS " 
           "16r00DB"    16r03AD " GREEK SMALL LETTER EPSILON WITH TONOS " 
           "16r00DC"    16r03AE " GREEK SMALL LETTER ETA WITH TONOS " 
           "16r00DD"    16r03AF " GREEK SMALL LETTER IOTA WITH TONOS " 
           "16r00DE"    16r03CC " GREEK SMALL LETTER OMICRON WITH TONOS " 
           "16r00DF"    16r038F " GREEK CAPITAL LETTER OMEGA WITH TONOS " 
           "16r00E0"    16r03CD " GREEK SMALL LETTER UPSILON WITH TONOS " 
           "16r00E1"    16r03B1 " GREEK SMALL LETTER ALPHA " 
           "16r00E2"    16r03B2 " GREEK SMALL LETTER BETA " 
           "16r00E3"    16r03C8 " GREEK SMALL LETTER PSI " 
           "16r00E4"    16r03B4 " GREEK SMALL LETTER DELTA " 
           "16r00E5"    16r03B5 " GREEK SMALL LETTER EPSILON " 
           "16r00E6"    16r03C6 " GREEK SMALL LETTER PHI " 
           "16r00E7"    16r03B3 " GREEK SMALL LETTER GAMMA " 
           "16r00E8"    16r03B7 " GREEK SMALL LETTER ETA " 
           "16r00E9"    16r03B9 " GREEK SMALL LETTER IOTA " 
           "16r00EA"    16r03BE " GREEK SMALL LETTER XI " 
           "16r00EB"    16r03BA " GREEK SMALL LETTER KAPPA " 
           "16r00EC"    16r03BB " GREEK SMALL LETTER LAMDA " 
           "16r00ED"    16r03BC " GREEK SMALL LETTER MU " 
           "16r00EE"    16r03BD " GREEK SMALL LETTER NU " 
           "16r00EF"    16r03BF " GREEK SMALL LETTER OMICRON " 
           "16r00F0"    16r03C0 " GREEK SMALL LETTER PI " 
           "16r00F1"    16r03CE " GREEK SMALL LETTER OMEGA WITH TONOS " 
           "16r00F2"    16r03C1 " GREEK SMALL LETTER RHO " 
           "16r00F3"    16r03C3 " GREEK SMALL LETTER SIGMA " 
           "16r00F4"    16r03C4 " GREEK SMALL LETTER TAU " 
           "16r00F5"    16r03B8 " GREEK SMALL LETTER THETA " 
           "16r00F6"    16r03C9 " GREEK SMALL LETTER OMEGA " 
           "16r00F7"    16r03C2 " GREEK SMALL LETTER FINAL SIGMA " 
           "16r00F8"    16r03C7 " GREEK SMALL LETTER CHI " 
           "16r00F9"    16r03C5 " GREEK SMALL LETTER UPSILON " 
           "16r00FA"    16r03B6 " GREEK SMALL LETTER ZETA " 
           "16r00FB"    16r03CA " GREEK SMALL LETTER IOTA WITH DIALYTIKA " 
           "16r00FC"    16r03CB " GREEK SMALL LETTER UPSILON WITH DIALYTIKA " 
           "16r00FD"    16r0390 " GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS " 
           "16r00FE"    16r03B0 " GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS " 
           "16r00FF"    16r00AD " SOFT HYPHEN # before Mac OS 9.2.2, was undefined " 
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
    unicode > 16r2265 ifTrue:[
        ^ self encodingError.
    ].
    unicode <= 16r9F ifTrue:[
        ^ self encodingError
    ].
    unicode <= 16r3CE ifTrue:[
        unicode <= 16r153 ifTrue:[
            unicode <= 16rFC ifTrue:[
                [
                    |t|
                    t := #[
                       "16r00A0"    16rCA " NO-BREAK SPACE " 
                       "16r00A1"    16r00 " invalid " 
                       "16r00A2"    16r00 " invalid " 
                       "16r00A3"    16r92 " POUND SIGN " 
                       "16r00A4"    16r00 " invalid " 
                       "16r00A5"    16rB4 " YEN SIGN " 
                       "16r00A6"    16r9B " BROKEN BAR " 
                       "16r00A7"    16rAC " SECTION SIGN " 
                       "16r00A8"    16r8C " DIAERESIS " 
                       "16r00A9"    16rA9 " COPYRIGHT SIGN " 
                       "16r00AA"    16r00 " invalid " 
                       "16r00AB"    16rC7 " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                       "16r00AC"    16rC2 " NOT SIGN " 
                       "16r00AD"    16rFF " SOFT HYPHEN # before Mac OS 9.2.2, was undefined " 
                       "16r00AE"    16rA8 " REGISTERED SIGN " 
                       "16r00AF"    16r00 " invalid " 
                       "16r00B0"    16rAE " DEGREE SIGN " 
                       "16r00B1"    16rB1 " PLUS-MINUS SIGN " 
                       "16r00B2"    16r82 " SUPERSCRIPT TWO " 
                       "16r00B3"    16r84 " SUPERSCRIPT THREE " 
                       "16r00B4"    16r00 " invalid " 
                       "16r00B5"    16r00 " invalid " 
                       "16r00B6"    16r00 " invalid " 
                       "16r00B7"    16rAF " MIDDLE DOT " 
                       "16r00B8"    16r00 " invalid " 
                       "16r00B9"    16r81 " SUPERSCRIPT ONE " 
                       "16r00BA"    16r00 " invalid " 
                       "16r00BB"    16rC8 " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                       "16r00BC"    16r00 " invalid " 
                       "16r00BD"    16r97 " VULGAR FRACTION ONE HALF " 
                       "16r00BE"    16r00 " invalid " 
                       "16r00BF"    16r00 " invalid " 
                       "16r00C0"    16r00 " invalid " 
                       "16r00C1"    16r00 " invalid " 
                       "16r00C2"    16r00 " invalid " 
                       "16r00C3"    16r00 " invalid " 
                       "16r00C4"    16r80 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
                       "16r00C5"    16r00 " invalid " 
                       "16r00C6"    16r00 " invalid " 
                       "16r00C7"    16r00 " invalid " 
                       "16r00C8"    16r00 " invalid " 
                       "16r00C9"    16r83 " LATIN CAPITAL LETTER E WITH ACUTE " 
                       "16r00CA"    16r00 " invalid " 
                       "16r00CB"    16r00 " invalid " 
                       "16r00CC"    16r00 " invalid " 
                       "16r00CD"    16r00 " invalid " 
                       "16r00CE"    16r00 " invalid " 
                       "16r00CF"    16r00 " invalid " 
                       "16r00D0"    16r00 " invalid " 
                       "16r00D1"    16r00 " invalid " 
                       "16r00D2"    16r00 " invalid " 
                       "16r00D3"    16r00 " invalid " 
                       "16r00D4"    16r00 " invalid " 
                       "16r00D5"    16r00 " invalid " 
                       "16r00D6"    16r85 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
                       "16r00D7"    16r00 " invalid " 
                       "16r00D8"    16r00 " invalid " 
                       "16r00D9"    16r00 " invalid " 
                       "16r00DA"    16r00 " invalid " 
                       "16r00DB"    16r00 " invalid " 
                       "16r00DC"    16r86 " LATIN CAPITAL LETTER U WITH DIAERESIS " 
                       "16r00DD"    16r00 " invalid " 
                       "16r00DE"    16r00 " invalid " 
                       "16r00DF"    16rA7 " LATIN SMALL LETTER SHARP S " 
                       "16r00E0"    16r88 " LATIN SMALL LETTER A WITH GRAVE " 
                       "16r00E1"    16r00 " invalid " 
                       "16r00E2"    16r89 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
                       "16r00E3"    16r00 " invalid " 
                       "16r00E4"    16r8A " LATIN SMALL LETTER A WITH DIAERESIS " 
                       "16r00E5"    16r00 " invalid " 
                       "16r00E6"    16r00 " invalid " 
                       "16r00E7"    16r8D " LATIN SMALL LETTER C WITH CEDILLA " 
                       "16r00E8"    16r8F " LATIN SMALL LETTER E WITH GRAVE " 
                       "16r00E9"    16r8E " LATIN SMALL LETTER E WITH ACUTE " 
                       "16r00EA"    16r90 " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
                       "16r00EB"    16r91 " LATIN SMALL LETTER E WITH DIAERESIS " 
                       "16r00EC"    16r00 " invalid " 
                       "16r00ED"    16r00 " invalid " 
                       "16r00EE"    16r94 " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
                       "16r00EF"    16r95 " LATIN SMALL LETTER I WITH DIAERESIS " 
                       "16r00F0"    16r00 " invalid " 
                       "16r00F1"    16r00 " invalid " 
                       "16r00F2"    16r00 " invalid " 
                       "16r00F3"    16r00 " invalid " 
                       "16r00F4"    16r99 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
                       "16r00F5"    16r00 " invalid " 
                       "16r00F6"    16r9A " LATIN SMALL LETTER O WITH DIAERESIS " 
                       "16r00F7"    16rD6 " DIVISION SIGN " 
                       "16r00F8"    16r00 " invalid " 
                       "16r00F9"    16r9D " LATIN SMALL LETTER U WITH GRAVE " 
                       "16r00FA"    16r00 " invalid " 
                       "16r00FB"    16r9E " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
                       "16r00FC"    16r9F " LATIN SMALL LETTER U WITH DIAERESIS " 
                       ] at:(unicode - 16r9F).
                    t == 0 ifFalse:[^ t].
                    ^ self encodingError
                ] value.
            ].
            unicode <= 16r152 ifTrue:[
                ^ self encodingError
            ].
            ^  "16r0153" 16r00CF " LATIN SMALL LIGATURE OE " 
        ].
        unicode <= 16r383 ifTrue:[
            ^ self encodingError
        ].
        [
            |t|
            t := #[
               "16r0384"    16r8B " GREEK TONOS " 
               "16r0385"    16r87 " GREEK DIALYTIKA TONOS " 
               "16r0386"    16rCD " GREEK CAPITAL LETTER ALPHA WITH TONOS " 
               "16r0387"    16r00 " invalid " 
               "16r0388"    16rCE " GREEK CAPITAL LETTER EPSILON WITH TONOS " 
               "16r0389"    16rD7 " GREEK CAPITAL LETTER ETA WITH TONOS " 
               "16r038A"    16rD8 " GREEK CAPITAL LETTER IOTA WITH TONOS " 
               "16r038B"    16r00 " invalid " 
               "16r038C"    16rD9 " GREEK CAPITAL LETTER OMICRON WITH TONOS " 
               "16r038D"    16r00 " invalid " 
               "16r038E"    16rDA " GREEK CAPITAL LETTER UPSILON WITH TONOS " 
               "16r038F"    16rDF " GREEK CAPITAL LETTER OMEGA WITH TONOS " 
               "16r0390"    16rFD " GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS " 
               "16r0391"    16rB0 " GREEK CAPITAL LETTER ALPHA " 
               "16r0392"    16rB5 " GREEK CAPITAL LETTER BETA " 
               "16r0393"    16rA1 " GREEK CAPITAL LETTER GAMMA " 
               "16r0394"    16rA2 " GREEK CAPITAL LETTER DELTA " 
               "16r0395"    16rB6 " GREEK CAPITAL LETTER EPSILON " 
               "16r0396"    16rB7 " GREEK CAPITAL LETTER ZETA " 
               "16r0397"    16rB8 " GREEK CAPITAL LETTER ETA " 
               "16r0398"    16rA3 " GREEK CAPITAL LETTER THETA " 
               "16r0399"    16rB9 " GREEK CAPITAL LETTER IOTA " 
               "16r039A"    16rBA " GREEK CAPITAL LETTER KAPPA " 
               "16r039B"    16rA4 " GREEK CAPITAL LETTER LAMDA " 
               "16r039C"    16rBB " GREEK CAPITAL LETTER MU " 
               "16r039D"    16rC1 " GREEK CAPITAL LETTER NU " 
               "16r039E"    16rA5 " GREEK CAPITAL LETTER XI " 
               "16r039F"    16rC3 " GREEK CAPITAL LETTER OMICRON " 
               "16r03A0"    16rA6 " GREEK CAPITAL LETTER PI " 
               "16r03A1"    16rC4 " GREEK CAPITAL LETTER RHO " 
               "16r03A2"    16r00 " invalid " 
               "16r03A3"    16rAA " GREEK CAPITAL LETTER SIGMA " 
               "16r03A4"    16rC6 " GREEK CAPITAL LETTER TAU " 
               "16r03A5"    16rCB " GREEK CAPITAL LETTER UPSILON " 
               "16r03A6"    16rBC " GREEK CAPITAL LETTER PHI " 
               "16r03A7"    16rCC " GREEK CAPITAL LETTER CHI " 
               "16r03A8"    16rBE " GREEK CAPITAL LETTER PSI " 
               "16r03A9"    16rBF " GREEK CAPITAL LETTER OMEGA " 
               "16r03AA"    16rAB " GREEK CAPITAL LETTER IOTA WITH DIALYTIKA " 
               "16r03AB"    16rBD " GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA " 
               "16r03AC"    16rC0 " GREEK SMALL LETTER ALPHA WITH TONOS " 
               "16r03AD"    16rDB " GREEK SMALL LETTER EPSILON WITH TONOS " 
               "16r03AE"    16rDC " GREEK SMALL LETTER ETA WITH TONOS " 
               "16r03AF"    16rDD " GREEK SMALL LETTER IOTA WITH TONOS " 
               "16r03B0"    16rFE " GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS " 
               "16r03B1"    16rE1 " GREEK SMALL LETTER ALPHA " 
               "16r03B2"    16rE2 " GREEK SMALL LETTER BETA " 
               "16r03B3"    16rE7 " GREEK SMALL LETTER GAMMA " 
               "16r03B4"    16rE4 " GREEK SMALL LETTER DELTA " 
               "16r03B5"    16rE5 " GREEK SMALL LETTER EPSILON " 
               "16r03B6"    16rFA " GREEK SMALL LETTER ZETA " 
               "16r03B7"    16rE8 " GREEK SMALL LETTER ETA " 
               "16r03B8"    16rF5 " GREEK SMALL LETTER THETA " 
               "16r03B9"    16rE9 " GREEK SMALL LETTER IOTA " 
               "16r03BA"    16rEB " GREEK SMALL LETTER KAPPA " 
               "16r03BB"    16rEC " GREEK SMALL LETTER LAMDA " 
               "16r03BC"    16rED " GREEK SMALL LETTER MU " 
               "16r03BD"    16rEE " GREEK SMALL LETTER NU " 
               "16r03BE"    16rEA " GREEK SMALL LETTER XI " 
               "16r03BF"    16rEF " GREEK SMALL LETTER OMICRON " 
               "16r03C0"    16rF0 " GREEK SMALL LETTER PI " 
               "16r03C1"    16rF2 " GREEK SMALL LETTER RHO " 
               "16r03C2"    16rF7 " GREEK SMALL LETTER FINAL SIGMA " 
               "16r03C3"    16rF3 " GREEK SMALL LETTER SIGMA " 
               "16r03C4"    16rF4 " GREEK SMALL LETTER TAU " 
               "16r03C5"    16rF9 " GREEK SMALL LETTER UPSILON " 
               "16r03C6"    16rE6 " GREEK SMALL LETTER PHI " 
               "16r03C7"    16rF8 " GREEK SMALL LETTER CHI " 
               "16r03C8"    16rE3 " GREEK SMALL LETTER PSI " 
               "16r03C9"    16rF6 " GREEK SMALL LETTER OMEGA " 
               "16r03CA"    16rFB " GREEK SMALL LETTER IOTA WITH DIALYTIKA " 
               "16r03CB"    16rFC " GREEK SMALL LETTER UPSILON WITH DIALYTIKA " 
               "16r03CC"    16rDE " GREEK SMALL LETTER OMICRON WITH TONOS " 
               "16r03CD"    16rE0 " GREEK SMALL LETTER UPSILON WITH TONOS " 
               "16r03CE"    16rF1 " GREEK SMALL LETTER OMEGA WITH TONOS " 
               ] at:(unicode - 16r383).
            t == 0 ifFalse:[^ t].
            ^ self encodingError
        ] value.
    ].
    unicode <= 16r2012 ifTrue:[
        ^ self encodingError
    ].
    unicode <= 16r2122 ifTrue:[
        unicode <= 16r2030 ifTrue:[
            [
                |t|
                t := #[
                   "16r2013"    16rD0 " EN DASH " 
                   "16r2014"    16r00 " invalid " 
                   "16r2015"    16rD1 " HORIZONTAL BAR " 
                   "16r2016"    16r00 " invalid " 
                   "16r2017"    16r00 " invalid " 
                   "16r2018"    16rD4 " LEFT SINGLE QUOTATION MARK " 
                   "16r2019"    16rD5 " RIGHT SINGLE QUOTATION MARK " 
                   "16r201A"    16r00 " invalid " 
                   "16r201B"    16r00 " invalid " 
                   "16r201C"    16rD2 " LEFT DOUBLE QUOTATION MARK " 
                   "16r201D"    16rD3 " RIGHT DOUBLE QUOTATION MARK " 
                   "16r201E"    16r00 " invalid " 
                   "16r201F"    16r00 " invalid " 
                   "16r2020"    16rA0 " DAGGER " 
                   "16r2021"    16r00 " invalid " 
                   "16r2022"    16r96 " BULLET " 
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
                   "16r2030"    16r98 " PER MILLE SIGN " 
                   ] at:(unicode - 16r2012).
                t == 0 ifFalse:[^ t].
                ^ self encodingError
            ] value.
        ].
        unicode <= 16r20AB ifTrue:[
            ^ self encodingError
        ].
        unicode == 16r20AC ifTrue:[
            ^  "16r20AC" 16r009C " EURO SIGN # before Mac OS 9.2.2, was SOFT HYPHEN " 
        ].
        unicode <= 16r2121 ifTrue:[
            ^ self encodingError
        ].
        ^  "16r2122" 16r0093 " TRADE MARK SIGN " 
    ].
    unicode <= 16r2247 ifTrue:[
        ^ self encodingError
    ].
    unicode == 16r2248 ifTrue:[
        ^  "16r2248" 16r00C5 " ALMOST EQUAL TO " 
    ].
    unicode <= 16r225F ifTrue:[
        ^ self encodingError
    ].
    [
        |t|
        t := #[
           "16r2260"    16rAD " NOT EQUAL TO " 
           "16r2261"    16r00 " invalid " 
           "16r2262"    16r00 " invalid " 
           "16r2263"    16r00 " invalid " 
           "16r2264"    16rB2 " LESS-THAN OR EQUAL TO " 
           "16r2265"    16rB3 " GREATER-THAN OR EQUAL TO " 
           ] at:(unicode - 16r225F).
        t == 0 ifFalse:[^ t].
        ^ self encodingError
    ] value.
! !

!MAC_Greek class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__MAC_Greek.st,v 1.3 2004/03/09 21:59:52 cg Exp $'
! !



