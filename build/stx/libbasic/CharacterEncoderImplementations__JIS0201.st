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

SingleByteEncoder subclass:#JIS0201
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!JIS0201 class methodsFor:'documentation'!

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

!JIS0201 class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'OBSOLETE/EASTASIA/JIS/JIS0201.TXT'
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/OBSOLETE/EASTASIA/JIS/JIS0201.TXT

#
#       Name:             JIS X 0201 (1976) to Unicode 1.1 Table
#       Unicode version:  1.1
#       Table version:    0.9
#       Table format:     Format A
#       Date:             8 March 1994
#
#       Copyright (c) 1991-1994 Unicode, Inc.  All Rights reserved.
#
#       This file is provided as-is by Unicode, Inc. (The Unicode Consortium).
#       No claims are made as to fitness for any particular purpose.  No
#       warranties of any kind are expressed or implied.  The recipient
#       agrees to determine applicability of information provided.  If this
#       file has been provided on magnetic media by Unicode, Inc., the sole
#       remedy for any claim will be exchange of defective media within 90
#       days of receipt.
#
#       Recipient is granted the right to make copies in any form for
#       internal distribution and to freely use the information supplied
#       in the creation of products supporting Unicode.  Unicode, Inc.
#       specifically excludes the right to re-distribute this file directly
#       to third parties or other organizations whether for profit or not.
#
#       General notes:
#
#
# This table contains one set of mappings from JIS X 0201 into Unicode.
# Note that these data are *possible* mappings only and may not be the
# same as those used by actual products, nor may they be the best suited
# for all uses.  For more information on the mappings between various code
# pages incorporating the repertoire of JIS X 0201 and Unicode, consult the
# VENDORS mapping data.  Normative information on the mapping between
# JIS X 0201 and Unicode may be found in the Unihan.txt file in the
# latest Unicode Character Database.
#
# If you have carefully considered the fact that the mappings in
# this table are only one possible set of mappings between JIS X 0201 and
# Unicode and have no normative status, but still feel that you
# have located an error in the table that requires fixing, you may
# report any such error to errata@unicode.org.
#
#
#       Format:  Three tab-separated columns
#               Column #1 is the shift JIS code (in hex as 0xXX)
#               Column #2 is the Unicode (in hex as 0xXXXX)
#               Column #3 the Unicode (ISO 10646) name (follows a comment sign)
#
#       The entries are in JIS order
#
#
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
0x5C    0x00A5  # YEN SIGN
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
0x7E    0x203E  # OVERLINE
0xA1    0xFF61  # HALFWIDTH IDEOGRAPHIC FULL STOP
0xA2    0xFF62  # HALFWIDTH LEFT CORNER BRACKET
0xA3    0xFF63  # HALFWIDTH RIGHT CORNER BRACKET
0xA4    0xFF64  # HALFWIDTH IDEOGRAPHIC COMMA
0xA5    0xFF65  # HALFWIDTH KATAKANA MIDDLE DOT
0xA6    0xFF66  # HALFWIDTH KATAKANA LETTER WO
0xA7    0xFF67  # HALFWIDTH KATAKANA LETTER SMALL A
0xA8    0xFF68  # HALFWIDTH KATAKANA LETTER SMALL I
0xA9    0xFF69  # HALFWIDTH KATAKANA LETTER SMALL U
0xAA    0xFF6A  # HALFWIDTH KATAKANA LETTER SMALL E
0xAB    0xFF6B  # HALFWIDTH KATAKANA LETTER SMALL O
0xAC    0xFF6C  # HALFWIDTH KATAKANA LETTER SMALL YA
0xAD    0xFF6D  # HALFWIDTH KATAKANA LETTER SMALL YU
0xAE    0xFF6E  # HALFWIDTH KATAKANA LETTER SMALL YO
0xAF    0xFF6F  # HALFWIDTH KATAKANA LETTER SMALL TU
0xB0    0xFF70  # HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK
0xB1    0xFF71  # HALFWIDTH KATAKANA LETTER A
0xB2    0xFF72  # HALFWIDTH KATAKANA LETTER I
0xB3    0xFF73  # HALFWIDTH KATAKANA LETTER U
0xB4    0xFF74  # HALFWIDTH KATAKANA LETTER E
0xB5    0xFF75  # HALFWIDTH KATAKANA LETTER O
0xB6    0xFF76  # HALFWIDTH KATAKANA LETTER KA
0xB7    0xFF77  # HALFWIDTH KATAKANA LETTER KI
0xB8    0xFF78  # HALFWIDTH KATAKANA LETTER KU
0xB9    0xFF79  # HALFWIDTH KATAKANA LETTER KE
0xBA    0xFF7A  # HALFWIDTH KATAKANA LETTER KO
0xBB    0xFF7B  # HALFWIDTH KATAKANA LETTER SA
0xBC    0xFF7C  # HALFWIDTH KATAKANA LETTER SI
0xBD    0xFF7D  # HALFWIDTH KATAKANA LETTER SU
0xBE    0xFF7E  # HALFWIDTH KATAKANA LETTER SE
0xBF    0xFF7F  # HALFWIDTH KATAKANA LETTER SO
0xC0    0xFF80  # HALFWIDTH KATAKANA LETTER TA
0xC1    0xFF81  # HALFWIDTH KATAKANA LETTER TI
0xC2    0xFF82  # HALFWIDTH KATAKANA LETTER TU
0xC3    0xFF83  # HALFWIDTH KATAKANA LETTER TE
0xC4    0xFF84  # HALFWIDTH KATAKANA LETTER TO
0xC5    0xFF85  # HALFWIDTH KATAKANA LETTER NA
0xC6    0xFF86  # HALFWIDTH KATAKANA LETTER NI
0xC7    0xFF87  # HALFWIDTH KATAKANA LETTER NU
0xC8    0xFF88  # HALFWIDTH KATAKANA LETTER NE
0xC9    0xFF89  # HALFWIDTH KATAKANA LETTER NO
0xCA    0xFF8A  # HALFWIDTH KATAKANA LETTER HA
0xCB    0xFF8B  # HALFWIDTH KATAKANA LETTER HI
0xCC    0xFF8C  # HALFWIDTH KATAKANA LETTER HU
0xCD    0xFF8D  # HALFWIDTH KATAKANA LETTER HE
0xCE    0xFF8E  # HALFWIDTH KATAKANA LETTER HO
0xCF    0xFF8F  # HALFWIDTH KATAKANA LETTER MA
0xD0    0xFF90  # HALFWIDTH KATAKANA LETTER MI
0xD1    0xFF91  # HALFWIDTH KATAKANA LETTER MU
0xD2    0xFF92  # HALFWIDTH KATAKANA LETTER ME
0xD3    0xFF93  # HALFWIDTH KATAKANA LETTER MO
0xD4    0xFF94  # HALFWIDTH KATAKANA LETTER YA
0xD5    0xFF95  # HALFWIDTH KATAKANA LETTER YU
0xD6    0xFF96  # HALFWIDTH KATAKANA LETTER YO
0xD7    0xFF97  # HALFWIDTH KATAKANA LETTER RA
0xD8    0xFF98  # HALFWIDTH KATAKANA LETTER RI
0xD9    0xFF99  # HALFWIDTH KATAKANA LETTER RU
0xDA    0xFF9A  # HALFWIDTH KATAKANA LETTER RE
0xDB    0xFF9B  # HALFWIDTH KATAKANA LETTER RO
0xDC    0xFF9C  # HALFWIDTH KATAKANA LETTER WA
0xDD    0xFF9D  # HALFWIDTH KATAKANA LETTER N
0xDE    0xFF9E  # HALFWIDTH KATAKANA VOICED SOUND MARK
0xDF    0xFF9F  # HALFWIDTH KATAKANA SEMI-VOICED SOUND MARK

"
! !

!JIS0201 methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16r1F ifTrue:[
	^ self decodingError.
    ].
    code <= 16r5B ifTrue:[ ^ code ].
    code > 16rDF ifTrue:[
	^ self decodingError.
    ].
    [
	|t|
	t := #(
	   "16r005C"    16r00A5 " YEN SIGN " 
	   "16r005D"    16r005D " RIGHT SQUARE BRACKET " 
	   "16r005E"    16r005E " CIRCUMFLEX ACCENT " 
	   "16r005F"    16r005F " LOW LINE " 
	   "16r0060"    16r0060 " GRAVE ACCENT " 
	   "16r0061"    16r0061 " LATIN SMALL LETTER A " 
	   "16r0062"    16r0062 " LATIN SMALL LETTER B " 
	   "16r0063"    16r0063 " LATIN SMALL LETTER C " 
	   "16r0064"    16r0064 " LATIN SMALL LETTER D " 
	   "16r0065"    16r0065 " LATIN SMALL LETTER E " 
	   "16r0066"    16r0066 " LATIN SMALL LETTER F " 
	   "16r0067"    16r0067 " LATIN SMALL LETTER G " 
	   "16r0068"    16r0068 " LATIN SMALL LETTER H " 
	   "16r0069"    16r0069 " LATIN SMALL LETTER I " 
	   "16r006A"    16r006A " LATIN SMALL LETTER J " 
	   "16r006B"    16r006B " LATIN SMALL LETTER K " 
	   "16r006C"    16r006C " LATIN SMALL LETTER L " 
	   "16r006D"    16r006D " LATIN SMALL LETTER M " 
	   "16r006E"    16r006E " LATIN SMALL LETTER N " 
	   "16r006F"    16r006F " LATIN SMALL LETTER O " 
	   "16r0070"    16r0070 " LATIN SMALL LETTER P " 
	   "16r0071"    16r0071 " LATIN SMALL LETTER Q " 
	   "16r0072"    16r0072 " LATIN SMALL LETTER R " 
	   "16r0073"    16r0073 " LATIN SMALL LETTER S " 
	   "16r0074"    16r0074 " LATIN SMALL LETTER T " 
	   "16r0075"    16r0075 " LATIN SMALL LETTER U " 
	   "16r0076"    16r0076 " LATIN SMALL LETTER V " 
	   "16r0077"    16r0077 " LATIN SMALL LETTER W " 
	   "16r0078"    16r0078 " LATIN SMALL LETTER X " 
	   "16r0079"    16r0079 " LATIN SMALL LETTER Y " 
	   "16r007A"    16r007A " LATIN SMALL LETTER Z " 
	   "16r007B"    16r007B " LEFT CURLY BRACKET " 
	   "16r007C"    16r007C " VERTICAL LINE " 
	   "16r007D"    16r007D " RIGHT CURLY BRACKET " 
	   "16r007E"    16r203E " OVERLINE " 
	   "16r007F"    16r0000 " invalid " 
	   "16r0080"    16r0000 " invalid " 
	   "16r0081"    16r0000 " invalid " 
	   "16r0082"    16r0000 " invalid " 
	   "16r0083"    16r0000 " invalid " 
	   "16r0084"    16r0000 " invalid " 
	   "16r0085"    16r0000 " invalid " 
	   "16r0086"    16r0000 " invalid " 
	   "16r0087"    16r0000 " invalid " 
	   "16r0088"    16r0000 " invalid " 
	   "16r0089"    16r0000 " invalid " 
	   "16r008A"    16r0000 " invalid " 
	   "16r008B"    16r0000 " invalid " 
	   "16r008C"    16r0000 " invalid " 
	   "16r008D"    16r0000 " invalid " 
	   "16r008E"    16r0000 " invalid " 
	   "16r008F"    16r0000 " invalid " 
	   "16r0090"    16r0000 " invalid " 
	   "16r0091"    16r0000 " invalid " 
	   "16r0092"    16r0000 " invalid " 
	   "16r0093"    16r0000 " invalid " 
	   "16r0094"    16r0000 " invalid " 
	   "16r0095"    16r0000 " invalid " 
	   "16r0096"    16r0000 " invalid " 
	   "16r0097"    16r0000 " invalid " 
	   "16r0098"    16r0000 " invalid " 
	   "16r0099"    16r0000 " invalid " 
	   "16r009A"    16r0000 " invalid " 
	   "16r009B"    16r0000 " invalid " 
	   "16r009C"    16r0000 " invalid " 
	   "16r009D"    16r0000 " invalid " 
	   "16r009E"    16r0000 " invalid " 
	   "16r009F"    16r0000 " invalid " 
	   "16r00A0"    16r0000 " invalid " 
	   "16r00A1"    16rFF61 " HALFWIDTH IDEOGRAPHIC FULL STOP " 
	   "16r00A2"    16rFF62 " HALFWIDTH LEFT CORNER BRACKET " 
	   "16r00A3"    16rFF63 " HALFWIDTH RIGHT CORNER BRACKET " 
	   "16r00A4"    16rFF64 " HALFWIDTH IDEOGRAPHIC COMMA " 
	   "16r00A5"    16rFF65 " HALFWIDTH KATAKANA MIDDLE DOT " 
	   "16r00A6"    16rFF66 " HALFWIDTH KATAKANA LETTER WO " 
	   "16r00A7"    16rFF67 " HALFWIDTH KATAKANA LETTER SMALL A " 
	   "16r00A8"    16rFF68 " HALFWIDTH KATAKANA LETTER SMALL I " 
	   "16r00A9"    16rFF69 " HALFWIDTH KATAKANA LETTER SMALL U " 
	   "16r00AA"    16rFF6A " HALFWIDTH KATAKANA LETTER SMALL E " 
	   "16r00AB"    16rFF6B " HALFWIDTH KATAKANA LETTER SMALL O " 
	   "16r00AC"    16rFF6C " HALFWIDTH KATAKANA LETTER SMALL YA " 
	   "16r00AD"    16rFF6D " HALFWIDTH KATAKANA LETTER SMALL YU " 
	   "16r00AE"    16rFF6E " HALFWIDTH KATAKANA LETTER SMALL YO " 
	   "16r00AF"    16rFF6F " HALFWIDTH KATAKANA LETTER SMALL TU " 
	   "16r00B0"    16rFF70 " HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK " 
	   "16r00B1"    16rFF71 " HALFWIDTH KATAKANA LETTER A " 
	   "16r00B2"    16rFF72 " HALFWIDTH KATAKANA LETTER I " 
	   "16r00B3"    16rFF73 " HALFWIDTH KATAKANA LETTER U " 
	   "16r00B4"    16rFF74 " HALFWIDTH KATAKANA LETTER E " 
	   "16r00B5"    16rFF75 " HALFWIDTH KATAKANA LETTER O " 
	   "16r00B6"    16rFF76 " HALFWIDTH KATAKANA LETTER KA " 
	   "16r00B7"    16rFF77 " HALFWIDTH KATAKANA LETTER KI " 
	   "16r00B8"    16rFF78 " HALFWIDTH KATAKANA LETTER KU " 
	   "16r00B9"    16rFF79 " HALFWIDTH KATAKANA LETTER KE " 
	   "16r00BA"    16rFF7A " HALFWIDTH KATAKANA LETTER KO " 
	   "16r00BB"    16rFF7B " HALFWIDTH KATAKANA LETTER SA " 
	   "16r00BC"    16rFF7C " HALFWIDTH KATAKANA LETTER SI " 
	   "16r00BD"    16rFF7D " HALFWIDTH KATAKANA LETTER SU " 
	   "16r00BE"    16rFF7E " HALFWIDTH KATAKANA LETTER SE " 
	   "16r00BF"    16rFF7F " HALFWIDTH KATAKANA LETTER SO " 
	   "16r00C0"    16rFF80 " HALFWIDTH KATAKANA LETTER TA " 
	   "16r00C1"    16rFF81 " HALFWIDTH KATAKANA LETTER TI " 
	   "16r00C2"    16rFF82 " HALFWIDTH KATAKANA LETTER TU " 
	   "16r00C3"    16rFF83 " HALFWIDTH KATAKANA LETTER TE " 
	   "16r00C4"    16rFF84 " HALFWIDTH KATAKANA LETTER TO " 
	   "16r00C5"    16rFF85 " HALFWIDTH KATAKANA LETTER NA " 
	   "16r00C6"    16rFF86 " HALFWIDTH KATAKANA LETTER NI " 
	   "16r00C7"    16rFF87 " HALFWIDTH KATAKANA LETTER NU " 
	   "16r00C8"    16rFF88 " HALFWIDTH KATAKANA LETTER NE " 
	   "16r00C9"    16rFF89 " HALFWIDTH KATAKANA LETTER NO " 
	   "16r00CA"    16rFF8A " HALFWIDTH KATAKANA LETTER HA " 
	   "16r00CB"    16rFF8B " HALFWIDTH KATAKANA LETTER HI " 
	   "16r00CC"    16rFF8C " HALFWIDTH KATAKANA LETTER HU " 
	   "16r00CD"    16rFF8D " HALFWIDTH KATAKANA LETTER HE " 
	   "16r00CE"    16rFF8E " HALFWIDTH KATAKANA LETTER HO " 
	   "16r00CF"    16rFF8F " HALFWIDTH KATAKANA LETTER MA " 
	   "16r00D0"    16rFF90 " HALFWIDTH KATAKANA LETTER MI " 
	   "16r00D1"    16rFF91 " HALFWIDTH KATAKANA LETTER MU " 
	   "16r00D2"    16rFF92 " HALFWIDTH KATAKANA LETTER ME " 
	   "16r00D3"    16rFF93 " HALFWIDTH KATAKANA LETTER MO " 
	   "16r00D4"    16rFF94 " HALFWIDTH KATAKANA LETTER YA " 
	   "16r00D5"    16rFF95 " HALFWIDTH KATAKANA LETTER YU " 
	   "16r00D6"    16rFF96 " HALFWIDTH KATAKANA LETTER YO " 
	   "16r00D7"    16rFF97 " HALFWIDTH KATAKANA LETTER RA " 
	   "16r00D8"    16rFF98 " HALFWIDTH KATAKANA LETTER RI " 
	   "16r00D9"    16rFF99 " HALFWIDTH KATAKANA LETTER RU " 
	   "16r00DA"    16rFF9A " HALFWIDTH KATAKANA LETTER RE " 
	   "16r00DB"    16rFF9B " HALFWIDTH KATAKANA LETTER RO " 
	   "16r00DC"    16rFF9C " HALFWIDTH KATAKANA LETTER WA " 
	   "16r00DD"    16rFF9D " HALFWIDTH KATAKANA LETTER N " 
	   "16r00DE"    16rFF9E " HALFWIDTH KATAKANA VOICED SOUND MARK " 
	   "16r00DF"    16rFF9F " HALFWIDTH KATAKANA SEMI-VOICED SOUND MARK " 
	   ) at:(code - 16r5B).
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
    unicode <= 16r5B ifTrue:[ ^ unicode ].
    unicode > 16rFF9F ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r203E ifTrue:[
	unicode <= 16rA5 ifTrue:[
	    unicode <= 16r7D ifTrue:[
		[
		    |t|
		    t := #[
		       "16r005C"    16r00 " invalid " 
		       "16r005D"    16r5D " RIGHT SQUARE BRACKET " 
		       "16r005E"    16r5E " CIRCUMFLEX ACCENT " 
		       "16r005F"    16r5F " LOW LINE " 
		       "16r0060"    16r60 " GRAVE ACCENT " 
		       "16r0061"    16r61 " LATIN SMALL LETTER A " 
		       "16r0062"    16r62 " LATIN SMALL LETTER B " 
		       "16r0063"    16r63 " LATIN SMALL LETTER C " 
		       "16r0064"    16r64 " LATIN SMALL LETTER D " 
		       "16r0065"    16r65 " LATIN SMALL LETTER E " 
		       "16r0066"    16r66 " LATIN SMALL LETTER F " 
		       "16r0067"    16r67 " LATIN SMALL LETTER G " 
		       "16r0068"    16r68 " LATIN SMALL LETTER H " 
		       "16r0069"    16r69 " LATIN SMALL LETTER I " 
		       "16r006A"    16r6A " LATIN SMALL LETTER J " 
		       "16r006B"    16r6B " LATIN SMALL LETTER K " 
		       "16r006C"    16r6C " LATIN SMALL LETTER L " 
		       "16r006D"    16r6D " LATIN SMALL LETTER M " 
		       "16r006E"    16r6E " LATIN SMALL LETTER N " 
		       "16r006F"    16r6F " LATIN SMALL LETTER O " 
		       "16r0070"    16r70 " LATIN SMALL LETTER P " 
		       "16r0071"    16r71 " LATIN SMALL LETTER Q " 
		       "16r0072"    16r72 " LATIN SMALL LETTER R " 
		       "16r0073"    16r73 " LATIN SMALL LETTER S " 
		       "16r0074"    16r74 " LATIN SMALL LETTER T " 
		       "16r0075"    16r75 " LATIN SMALL LETTER U " 
		       "16r0076"    16r76 " LATIN SMALL LETTER V " 
		       "16r0077"    16r77 " LATIN SMALL LETTER W " 
		       "16r0078"    16r78 " LATIN SMALL LETTER X " 
		       "16r0079"    16r79 " LATIN SMALL LETTER Y " 
		       "16r007A"    16r7A " LATIN SMALL LETTER Z " 
		       "16r007B"    16r7B " LEFT CURLY BRACKET " 
		       "16r007C"    16r7C " VERTICAL LINE " 
		       "16r007D"    16r7D " RIGHT CURLY BRACKET " 
		       ] at:(unicode - 16r5B).
		    t == 0 ifFalse:[^ t].
		    ^ self encodingError
		] value.
	    ].
	    unicode <= 16rA4 ifTrue:[
		^ self encodingError.
	    ].
	    ^  "16r00A5" 16r005C " YEN SIGN " 
	].
	unicode <= 16r203D ifTrue:[
	    ^ self encodingError.
	].
	^  "16r203E" 16r007E " OVERLINE " 
    ].
    unicode <= 16rFF60 ifTrue:[
	^ self encodingError.
    ].
    ^ #[
       "16rFF61"    16rA1 " HALFWIDTH IDEOGRAPHIC FULL STOP " 
       "16rFF62"    16rA2 " HALFWIDTH LEFT CORNER BRACKET " 
       "16rFF63"    16rA3 " HALFWIDTH RIGHT CORNER BRACKET " 
       "16rFF64"    16rA4 " HALFWIDTH IDEOGRAPHIC COMMA " 
       "16rFF65"    16rA5 " HALFWIDTH KATAKANA MIDDLE DOT " 
       "16rFF66"    16rA6 " HALFWIDTH KATAKANA LETTER WO " 
       "16rFF67"    16rA7 " HALFWIDTH KATAKANA LETTER SMALL A " 
       "16rFF68"    16rA8 " HALFWIDTH KATAKANA LETTER SMALL I " 
       "16rFF69"    16rA9 " HALFWIDTH KATAKANA LETTER SMALL U " 
       "16rFF6A"    16rAA " HALFWIDTH KATAKANA LETTER SMALL E " 
       "16rFF6B"    16rAB " HALFWIDTH KATAKANA LETTER SMALL O " 
       "16rFF6C"    16rAC " HALFWIDTH KATAKANA LETTER SMALL YA " 
       "16rFF6D"    16rAD " HALFWIDTH KATAKANA LETTER SMALL YU " 
       "16rFF6E"    16rAE " HALFWIDTH KATAKANA LETTER SMALL YO " 
       "16rFF6F"    16rAF " HALFWIDTH KATAKANA LETTER SMALL TU " 
       "16rFF70"    16rB0 " HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK " 
       "16rFF71"    16rB1 " HALFWIDTH KATAKANA LETTER A " 
       "16rFF72"    16rB2 " HALFWIDTH KATAKANA LETTER I " 
       "16rFF73"    16rB3 " HALFWIDTH KATAKANA LETTER U " 
       "16rFF74"    16rB4 " HALFWIDTH KATAKANA LETTER E " 
       "16rFF75"    16rB5 " HALFWIDTH KATAKANA LETTER O " 
       "16rFF76"    16rB6 " HALFWIDTH KATAKANA LETTER KA " 
       "16rFF77"    16rB7 " HALFWIDTH KATAKANA LETTER KI " 
       "16rFF78"    16rB8 " HALFWIDTH KATAKANA LETTER KU " 
       "16rFF79"    16rB9 " HALFWIDTH KATAKANA LETTER KE " 
       "16rFF7A"    16rBA " HALFWIDTH KATAKANA LETTER KO " 
       "16rFF7B"    16rBB " HALFWIDTH KATAKANA LETTER SA " 
       "16rFF7C"    16rBC " HALFWIDTH KATAKANA LETTER SI " 
       "16rFF7D"    16rBD " HALFWIDTH KATAKANA LETTER SU " 
       "16rFF7E"    16rBE " HALFWIDTH KATAKANA LETTER SE " 
       "16rFF7F"    16rBF " HALFWIDTH KATAKANA LETTER SO " 
       "16rFF80"    16rC0 " HALFWIDTH KATAKANA LETTER TA " 
       "16rFF81"    16rC1 " HALFWIDTH KATAKANA LETTER TI " 
       "16rFF82"    16rC2 " HALFWIDTH KATAKANA LETTER TU " 
       "16rFF83"    16rC3 " HALFWIDTH KATAKANA LETTER TE " 
       "16rFF84"    16rC4 " HALFWIDTH KATAKANA LETTER TO " 
       "16rFF85"    16rC5 " HALFWIDTH KATAKANA LETTER NA " 
       "16rFF86"    16rC6 " HALFWIDTH KATAKANA LETTER NI " 
       "16rFF87"    16rC7 " HALFWIDTH KATAKANA LETTER NU " 
       "16rFF88"    16rC8 " HALFWIDTH KATAKANA LETTER NE " 
       "16rFF89"    16rC9 " HALFWIDTH KATAKANA LETTER NO " 
       "16rFF8A"    16rCA " HALFWIDTH KATAKANA LETTER HA " 
       "16rFF8B"    16rCB " HALFWIDTH KATAKANA LETTER HI " 
       "16rFF8C"    16rCC " HALFWIDTH KATAKANA LETTER HU " 
       "16rFF8D"    16rCD " HALFWIDTH KATAKANA LETTER HE " 
       "16rFF8E"    16rCE " HALFWIDTH KATAKANA LETTER HO " 
       "16rFF8F"    16rCF " HALFWIDTH KATAKANA LETTER MA " 
       "16rFF90"    16rD0 " HALFWIDTH KATAKANA LETTER MI " 
       "16rFF91"    16rD1 " HALFWIDTH KATAKANA LETTER MU " 
       "16rFF92"    16rD2 " HALFWIDTH KATAKANA LETTER ME " 
       "16rFF93"    16rD3 " HALFWIDTH KATAKANA LETTER MO " 
       "16rFF94"    16rD4 " HALFWIDTH KATAKANA LETTER YA " 
       "16rFF95"    16rD5 " HALFWIDTH KATAKANA LETTER YU " 
       "16rFF96"    16rD6 " HALFWIDTH KATAKANA LETTER YO " 
       "16rFF97"    16rD7 " HALFWIDTH KATAKANA LETTER RA " 
       "16rFF98"    16rD8 " HALFWIDTH KATAKANA LETTER RI " 
       "16rFF99"    16rD9 " HALFWIDTH KATAKANA LETTER RU " 
       "16rFF9A"    16rDA " HALFWIDTH KATAKANA LETTER RE " 
       "16rFF9B"    16rDB " HALFWIDTH KATAKANA LETTER RO " 
       "16rFF9C"    16rDC " HALFWIDTH KATAKANA LETTER WA " 
       "16rFF9D"    16rDD " HALFWIDTH KATAKANA LETTER N " 
       "16rFF9E"    16rDE " HALFWIDTH KATAKANA VOICED SOUND MARK " 
       "16rFF9F"    16rDF " HALFWIDTH KATAKANA SEMI-VOICED SOUND MARK " 
       ] at:(unicode - 16rFF60).
! !

!JIS0201 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__JIS0201.st,v 1.3 2004/03/09 21:59:06 cg Exp $'
! !



