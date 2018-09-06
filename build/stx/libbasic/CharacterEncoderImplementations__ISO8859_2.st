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

SingleByteEncoder subclass:#ISO8859_2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO8859_2 class methodsFor:'documentation'!

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
    8859-2 (Latin 2) - East European.

    Notice: this is NOT the same as CP1250.

    [see with:]
        CharacterEncoderImplementations::ISO8859_2 showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!ISO8859_2 class methodsFor:'encoding & decoding'!

mapFileURL1_relativePathName
    ^ 'ISO8859/8859-2.TXT'

    "
     self generateCode
    "
! !

!ISO8859_2 class methodsFor:'mapping'!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/ISO8859/8859-2.TXT

#
#       Name:             ISO 8859-2:1999 to Unicode
#       Unicode version:  3.0
#       Table version:    1.0
#       Table format:     Format A
#       Date:             1999 July 27
#       Authors:          Ken Whistler <kenw@sybase.com>
#
#       Copyright (c) 1991-1999 Unicode, Inc.  All Rights reserved.
#
#       This file is provided as-is by Unicode, Inc. (The Unicode Consortium).
#       No claims are made as to fitness for any particular purpose.  No
#       warranties of any kind are expressed or implied.  The recipient
#       agrees to determine applicability of information provided.  If this
#       file has been provided on optical media by Unicode, Inc., the sole
#       remedy for any claim will be exchange of defective media within 90
#       days of receipt.
#
#       Unicode, Inc. hereby grants the right to freely use the information
#       supplied in this file in the creation of products supporting the
#       Unicode Standard, and to make copies of this file in any form for
#       internal or external distribution as long as this notice remains
#       attached.
#
#       General notes:
#
#       This table contains the data the Unicode Consortium has on how
#       ISO/IEC 8859-2:1999 characters map into Unicode.
#
#       Format:  Three tab-separated columns
#                Column #1 is the ISO/IEC 8859-2 code (in hex as 0xXX)
#                Column #2 is the Unicode (in hex as 0xXXXX)
#                Column #3 the Unicode name (follows a comment sign, '#')
#
#       The entries are in ISO/IEC 8859-2 order.
#
#       Version history
#       1.0 version updates 0.1 version by adding mappings for all
#       control characters.
#
#       Updated versions of this file may be found in:
#               <ftp://ftp.unicode.org/Public/MAPPINGS/>
#
#       Any comments or problems, contact <errata@unicode.org>
#       Please note that <errata@unicode.org> is an archival address;
#       notices will be checked, but do not expect an immediate response.
#
0x00    0x0000  #       NULL
0x01    0x0001  #       START OF HEADING
0x02    0x0002  #       START OF TEXT
0x03    0x0003  #       END OF TEXT
0x04    0x0004  #       END OF TRANSMISSION
0x05    0x0005  #       ENQUIRY
0x06    0x0006  #       ACKNOWLEDGE
0x07    0x0007  #       BELL
0x08    0x0008  #       BACKSPACE
0x09    0x0009  #       HORIZONTAL TABULATION
0x0A    0x000A  #       LINE FEED
0x0B    0x000B  #       VERTICAL TABULATION
0x0C    0x000C  #       FORM FEED
0x0D    0x000D  #       CARRIAGE RETURN
0x0E    0x000E  #       SHIFT OUT
0x0F    0x000F  #       SHIFT IN
0x10    0x0010  #       DATA LINK ESCAPE
0x11    0x0011  #       DEVICE CONTROL ONE
0x12    0x0012  #       DEVICE CONTROL TWO
0x13    0x0013  #       DEVICE CONTROL THREE
0x14    0x0014  #       DEVICE CONTROL FOUR
0x15    0x0015  #       NEGATIVE ACKNOWLEDGE
0x16    0x0016  #       SYNCHRONOUS IDLE
0x17    0x0017  #       END OF TRANSMISSION BLOCK
0x18    0x0018  #       CANCEL
0x19    0x0019  #       END OF MEDIUM
0x1A    0x001A  #       SUBSTITUTE
0x1B    0x001B  #       ESCAPE
0x1C    0x001C  #       FILE SEPARATOR
0x1D    0x001D  #       GROUP SEPARATOR
0x1E    0x001E  #       RECORD SEPARATOR
0x1F    0x001F  #       UNIT SEPARATOR
0x20    0x0020  #       SPACE
0x21    0x0021  #       EXCLAMATION MARK
0x22    0x0022  #       QUOTATION MARK
0x23    0x0023  #       NUMBER SIGN
0x24    0x0024  #       DOLLAR SIGN
0x25    0x0025  #       PERCENT SIGN
0x26    0x0026  #       AMPERSAND
0x27    0x0027  #       APOSTROPHE
0x28    0x0028  #       LEFT PARENTHESIS
0x29    0x0029  #       RIGHT PARENTHESIS
0x2A    0x002A  #       ASTERISK
0x2B    0x002B  #       PLUS SIGN
0x2C    0x002C  #       COMMA
0x2D    0x002D  #       HYPHEN-MINUS
0x2E    0x002E  #       FULL STOP
0x2F    0x002F  #       SOLIDUS
0x30    0x0030  #       DIGIT ZERO
0x31    0x0031  #       DIGIT ONE
0x32    0x0032  #       DIGIT TWO
0x33    0x0033  #       DIGIT THREE
0x34    0x0034  #       DIGIT FOUR
0x35    0x0035  #       DIGIT FIVE
0x36    0x0036  #       DIGIT SIX
0x37    0x0037  #       DIGIT SEVEN
0x38    0x0038  #       DIGIT EIGHT
0x39    0x0039  #       DIGIT NINE
0x3A    0x003A  #       COLON
0x3B    0x003B  #       SEMICOLON
0x3C    0x003C  #       LESS-THAN SIGN
0x3D    0x003D  #       EQUALS SIGN
0x3E    0x003E  #       GREATER-THAN SIGN
0x3F    0x003F  #       QUESTION MARK
0x40    0x0040  #       COMMERCIAL AT
0x41    0x0041  #       LATIN CAPITAL LETTER A
0x42    0x0042  #       LATIN CAPITAL LETTER B
0x43    0x0043  #       LATIN CAPITAL LETTER C
0x44    0x0044  #       LATIN CAPITAL LETTER D
0x45    0x0045  #       LATIN CAPITAL LETTER E
0x46    0x0046  #       LATIN CAPITAL LETTER F
0x47    0x0047  #       LATIN CAPITAL LETTER G
0x48    0x0048  #       LATIN CAPITAL LETTER H
0x49    0x0049  #       LATIN CAPITAL LETTER I
0x4A    0x004A  #       LATIN CAPITAL LETTER J
0x4B    0x004B  #       LATIN CAPITAL LETTER K
0x4C    0x004C  #       LATIN CAPITAL LETTER L
0x4D    0x004D  #       LATIN CAPITAL LETTER M
0x4E    0x004E  #       LATIN CAPITAL LETTER N
0x4F    0x004F  #       LATIN CAPITAL LETTER O
0x50    0x0050  #       LATIN CAPITAL LETTER P
0x51    0x0051  #       LATIN CAPITAL LETTER Q
0x52    0x0052  #       LATIN CAPITAL LETTER R
0x53    0x0053  #       LATIN CAPITAL LETTER S
0x54    0x0054  #       LATIN CAPITAL LETTER T
0x55    0x0055  #       LATIN CAPITAL LETTER U
0x56    0x0056  #       LATIN CAPITAL LETTER V
0x57    0x0057  #       LATIN CAPITAL LETTER W
0x58    0x0058  #       LATIN CAPITAL LETTER X
0x59    0x0059  #       LATIN CAPITAL LETTER Y
0x5A    0x005A  #       LATIN CAPITAL LETTER Z
0x5B    0x005B  #       LEFT SQUARE BRACKET
0x5C    0x005C  #       REVERSE SOLIDUS
0x5D    0x005D  #       RIGHT SQUARE BRACKET
0x5E    0x005E  #       CIRCUMFLEX ACCENT
0x5F    0x005F  #       LOW LINE
0x60    0x0060  #       GRAVE ACCENT
0x61    0x0061  #       LATIN SMALL LETTER A
0x62    0x0062  #       LATIN SMALL LETTER B
0x63    0x0063  #       LATIN SMALL LETTER C
0x64    0x0064  #       LATIN SMALL LETTER D
0x65    0x0065  #       LATIN SMALL LETTER E
0x66    0x0066  #       LATIN SMALL LETTER F
0x67    0x0067  #       LATIN SMALL LETTER G
0x68    0x0068  #       LATIN SMALL LETTER H
0x69    0x0069  #       LATIN SMALL LETTER I
0x6A    0x006A  #       LATIN SMALL LETTER J
0x6B    0x006B  #       LATIN SMALL LETTER K
0x6C    0x006C  #       LATIN SMALL LETTER L
0x6D    0x006D  #       LATIN SMALL LETTER M
0x6E    0x006E  #       LATIN SMALL LETTER N
0x6F    0x006F  #       LATIN SMALL LETTER O
0x70    0x0070  #       LATIN SMALL LETTER P
0x71    0x0071  #       LATIN SMALL LETTER Q
0x72    0x0072  #       LATIN SMALL LETTER R
0x73    0x0073  #       LATIN SMALL LETTER S
0x74    0x0074  #       LATIN SMALL LETTER T
0x75    0x0075  #       LATIN SMALL LETTER U
0x76    0x0076  #       LATIN SMALL LETTER V
0x77    0x0077  #       LATIN SMALL LETTER W
0x78    0x0078  #       LATIN SMALL LETTER X
0x79    0x0079  #       LATIN SMALL LETTER Y
0x7A    0x007A  #       LATIN SMALL LETTER Z
0x7B    0x007B  #       LEFT CURLY BRACKET
0x7C    0x007C  #       VERTICAL LINE
0x7D    0x007D  #       RIGHT CURLY BRACKET
0x7E    0x007E  #       TILDE
0x7F    0x007F  #       DELETE
0x80    0x0080  #       <control>
0x81    0x0081  #       <control>
0x82    0x0082  #       <control>
0x83    0x0083  #       <control>
0x84    0x0084  #       <control>
0x85    0x0085  #       <control>
0x86    0x0086  #       <control>
0x87    0x0087  #       <control>
0x88    0x0088  #       <control>
0x89    0x0089  #       <control>
0x8A    0x008A  #       <control>
0x8B    0x008B  #       <control>
0x8C    0x008C  #       <control>
0x8D    0x008D  #       <control>
0x8E    0x008E  #       <control>
0x8F    0x008F  #       <control>
0x90    0x0090  #       <control>
0x91    0x0091  #       <control>
0x92    0x0092  #       <control>
0x93    0x0093  #       <control>
0x94    0x0094  #       <control>
0x95    0x0095  #       <control>
0x96    0x0096  #       <control>
0x97    0x0097  #       <control>
0x98    0x0098  #       <control>
0x99    0x0099  #       <control>
0x9A    0x009A  #       <control>
0x9B    0x009B  #       <control>
0x9C    0x009C  #       <control>
0x9D    0x009D  #       <control>
0x9E    0x009E  #       <control>
0x9F    0x009F  #       <control>
0xA0    0x00A0  #       NO-BREAK SPACE
0xA1    0x0104  #       LATIN CAPITAL LETTER A WITH OGONEK
0xA2    0x02D8  #       BREVE
0xA3    0x0141  #       LATIN CAPITAL LETTER L WITH STROKE
0xA4    0x00A4  #       CURRENCY SIGN
0xA5    0x013D  #       LATIN CAPITAL LETTER L WITH CARON
0xA6    0x015A  #       LATIN CAPITAL LETTER S WITH ACUTE
0xA7    0x00A7  #       SECTION SIGN
0xA8    0x00A8  #       DIAERESIS
0xA9    0x0160  #       LATIN CAPITAL LETTER S WITH CARON
0xAA    0x015E  #       LATIN CAPITAL LETTER S WITH CEDILLA
0xAB    0x0164  #       LATIN CAPITAL LETTER T WITH CARON
0xAC    0x0179  #       LATIN CAPITAL LETTER Z WITH ACUTE
0xAD    0x00AD  #       SOFT HYPHEN
0xAE    0x017D  #       LATIN CAPITAL LETTER Z WITH CARON
0xAF    0x017B  #       LATIN CAPITAL LETTER Z WITH DOT ABOVE
0xB0    0x00B0  #       DEGREE SIGN
0xB1    0x0105  #       LATIN SMALL LETTER A WITH OGONEK
0xB2    0x02DB  #       OGONEK
0xB3    0x0142  #       LATIN SMALL LETTER L WITH STROKE
0xB4    0x00B4  #       ACUTE ACCENT
0xB5    0x013E  #       LATIN SMALL LETTER L WITH CARON
0xB6    0x015B  #       LATIN SMALL LETTER S WITH ACUTE
0xB7    0x02C7  #       CARON
0xB8    0x00B8  #       CEDILLA
0xB9    0x0161  #       LATIN SMALL LETTER S WITH CARON
0xBA    0x015F  #       LATIN SMALL LETTER S WITH CEDILLA
0xBB    0x0165  #       LATIN SMALL LETTER T WITH CARON
0xBC    0x017A  #       LATIN SMALL LETTER Z WITH ACUTE
0xBD    0x02DD  #       DOUBLE ACUTE ACCENT
0xBE    0x017E  #       LATIN SMALL LETTER Z WITH CARON
0xBF    0x017C  #       LATIN SMALL LETTER Z WITH DOT ABOVE
0xC0    0x0154  #       LATIN CAPITAL LETTER R WITH ACUTE
0xC1    0x00C1  #       LATIN CAPITAL LETTER A WITH ACUTE
0xC2    0x00C2  #       LATIN CAPITAL LETTER A WITH CIRCUMFLEX
0xC3    0x0102  #       LATIN CAPITAL LETTER A WITH BREVE
0xC4    0x00C4  #       LATIN CAPITAL LETTER A WITH DIAERESIS
0xC5    0x0139  #       LATIN CAPITAL LETTER L WITH ACUTE
0xC6    0x0106  #       LATIN CAPITAL LETTER C WITH ACUTE
0xC7    0x00C7  #       LATIN CAPITAL LETTER C WITH CEDILLA
0xC8    0x010C  #       LATIN CAPITAL LETTER C WITH CARON
0xC9    0x00C9  #       LATIN CAPITAL LETTER E WITH ACUTE
0xCA    0x0118  #       LATIN CAPITAL LETTER E WITH OGONEK
0xCB    0x00CB  #       LATIN CAPITAL LETTER E WITH DIAERESIS
0xCC    0x011A  #       LATIN CAPITAL LETTER E WITH CARON
0xCD    0x00CD  #       LATIN CAPITAL LETTER I WITH ACUTE
0xCE    0x00CE  #       LATIN CAPITAL LETTER I WITH CIRCUMFLEX
0xCF    0x010E  #       LATIN CAPITAL LETTER D WITH CARON
0xD0    0x0110  #       LATIN CAPITAL LETTER D WITH STROKE
0xD1    0x0143  #       LATIN CAPITAL LETTER N WITH ACUTE
0xD2    0x0147  #       LATIN CAPITAL LETTER N WITH CARON
0xD3    0x00D3  #       LATIN CAPITAL LETTER O WITH ACUTE
0xD4    0x00D4  #       LATIN CAPITAL LETTER O WITH CIRCUMFLEX
0xD5    0x0150  #       LATIN CAPITAL LETTER O WITH DOUBLE ACUTE
0xD6    0x00D6  #       LATIN CAPITAL LETTER O WITH DIAERESIS
0xD7    0x00D7  #       MULTIPLICATION SIGN
0xD8    0x0158  #       LATIN CAPITAL LETTER R WITH CARON
0xD9    0x016E  #       LATIN CAPITAL LETTER U WITH RING ABOVE
0xDA    0x00DA  #       LATIN CAPITAL LETTER U WITH ACUTE
0xDB    0x0170  #       LATIN CAPITAL LETTER U WITH DOUBLE ACUTE
0xDC    0x00DC  #       LATIN CAPITAL LETTER U WITH DIAERESIS
0xDD    0x00DD  #       LATIN CAPITAL LETTER Y WITH ACUTE
0xDE    0x0162  #       LATIN CAPITAL LETTER T WITH CEDILLA
0xDF    0x00DF  #       LATIN SMALL LETTER SHARP S
0xE0    0x0155  #       LATIN SMALL LETTER R WITH ACUTE
0xE1    0x00E1  #       LATIN SMALL LETTER A WITH ACUTE
0xE2    0x00E2  #       LATIN SMALL LETTER A WITH CIRCUMFLEX
0xE3    0x0103  #       LATIN SMALL LETTER A WITH BREVE
0xE4    0x00E4  #       LATIN SMALL LETTER A WITH DIAERESIS
0xE5    0x013A  #       LATIN SMALL LETTER L WITH ACUTE
0xE6    0x0107  #       LATIN SMALL LETTER C WITH ACUTE
0xE7    0x00E7  #       LATIN SMALL LETTER C WITH CEDILLA
0xE8    0x010D  #       LATIN SMALL LETTER C WITH CARON
0xE9    0x00E9  #       LATIN SMALL LETTER E WITH ACUTE
0xEA    0x0119  #       LATIN SMALL LETTER E WITH OGONEK
0xEB    0x00EB  #       LATIN SMALL LETTER E WITH DIAERESIS
0xEC    0x011B  #       LATIN SMALL LETTER E WITH CARON
0xED    0x00ED  #       LATIN SMALL LETTER I WITH ACUTE
0xEE    0x00EE  #       LATIN SMALL LETTER I WITH CIRCUMFLEX
0xEF    0x010F  #       LATIN SMALL LETTER D WITH CARON
0xF0    0x0111  #       LATIN SMALL LETTER D WITH STROKE
0xF1    0x0144  #       LATIN SMALL LETTER N WITH ACUTE
0xF2    0x0148  #       LATIN SMALL LETTER N WITH CARON
0xF3    0x00F3  #       LATIN SMALL LETTER O WITH ACUTE
0xF4    0x00F4  #       LATIN SMALL LETTER O WITH CIRCUMFLEX
0xF5    0x0151  #       LATIN SMALL LETTER O WITH DOUBLE ACUTE
0xF6    0x00F6  #       LATIN SMALL LETTER O WITH DIAERESIS
0xF7    0x00F7  #       DIVISION SIGN
0xF8    0x0159  #       LATIN SMALL LETTER R WITH CARON
0xF9    0x016F  #       LATIN SMALL LETTER U WITH RING ABOVE
0xFA    0x00FA  #       LATIN SMALL LETTER U WITH ACUTE
0xFB    0x0171  #       LATIN SMALL LETTER U WITH DOUBLE ACUTE
0xFC    0x00FC  #       LATIN SMALL LETTER U WITH DIAERESIS
0xFD    0x00FD  #       LATIN SMALL LETTER Y WITH ACUTE
0xFE    0x0163  #       LATIN SMALL LETTER T WITH CEDILLA
0xFF    0x02D9  #       DOT ABOVE

"
! !

!ISO8859_2 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Central European'
! !

!ISO8859_2 methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16rA0 ifTrue:[ ^ code ].
    code > 16rFF ifTrue:[
        ^ self decodingError.
    ].
    ^ #(
       "16r00A1"    16r0104 " LATIN CAPITAL LETTER A WITH OGONEK " 
       "16r00A2"    16r02D8 " BREVE " 
       "16r00A3"    16r0141 " LATIN CAPITAL LETTER L WITH STROKE " 
       "16r00A4"    16r00A4 " CURRENCY SIGN " 
       "16r00A5"    16r013D " LATIN CAPITAL LETTER L WITH CARON " 
       "16r00A6"    16r015A " LATIN CAPITAL LETTER S WITH ACUTE " 
       "16r00A7"    16r00A7 " SECTION SIGN " 
       "16r00A8"    16r00A8 " DIAERESIS " 
       "16r00A9"    16r0160 " LATIN CAPITAL LETTER S WITH CARON " 
       "16r00AA"    16r015E " LATIN CAPITAL LETTER S WITH CEDILLA " 
       "16r00AB"    16r0164 " LATIN CAPITAL LETTER T WITH CARON " 
       "16r00AC"    16r0179 " LATIN CAPITAL LETTER Z WITH ACUTE " 
       "16r00AD"    16r00AD " SOFT HYPHEN " 
       "16r00AE"    16r017D " LATIN CAPITAL LETTER Z WITH CARON " 
       "16r00AF"    16r017B " LATIN CAPITAL LETTER Z WITH DOT ABOVE " 
       "16r00B0"    16r00B0 " DEGREE SIGN " 
       "16r00B1"    16r0105 " LATIN SMALL LETTER A WITH OGONEK " 
       "16r00B2"    16r02DB " OGONEK " 
       "16r00B3"    16r0142 " LATIN SMALL LETTER L WITH STROKE " 
       "16r00B4"    16r00B4 " ACUTE ACCENT " 
       "16r00B5"    16r013E " LATIN SMALL LETTER L WITH CARON " 
       "16r00B6"    16r015B " LATIN SMALL LETTER S WITH ACUTE " 
       "16r00B7"    16r02C7 " CARON " 
       "16r00B8"    16r00B8 " CEDILLA " 
       "16r00B9"    16r0161 " LATIN SMALL LETTER S WITH CARON " 
       "16r00BA"    16r015F " LATIN SMALL LETTER S WITH CEDILLA " 
       "16r00BB"    16r0165 " LATIN SMALL LETTER T WITH CARON " 
       "16r00BC"    16r017A " LATIN SMALL LETTER Z WITH ACUTE " 
       "16r00BD"    16r02DD " DOUBLE ACUTE ACCENT " 
       "16r00BE"    16r017E " LATIN SMALL LETTER Z WITH CARON " 
       "16r00BF"    16r017C " LATIN SMALL LETTER Z WITH DOT ABOVE " 
       "16r00C0"    16r0154 " LATIN CAPITAL LETTER R WITH ACUTE " 
       "16r00C1"    16r00C1 " LATIN CAPITAL LETTER A WITH ACUTE " 
       "16r00C2"    16r00C2 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
       "16r00C3"    16r0102 " LATIN CAPITAL LETTER A WITH BREVE " 
       "16r00C4"    16r00C4 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
       "16r00C5"    16r0139 " LATIN CAPITAL LETTER L WITH ACUTE " 
       "16r00C6"    16r0106 " LATIN CAPITAL LETTER C WITH ACUTE " 
       "16r00C7"    16r00C7 " LATIN CAPITAL LETTER C WITH CEDILLA " 
       "16r00C8"    16r010C " LATIN CAPITAL LETTER C WITH CARON " 
       "16r00C9"    16r00C9 " LATIN CAPITAL LETTER E WITH ACUTE " 
       "16r00CA"    16r0118 " LATIN CAPITAL LETTER E WITH OGONEK " 
       "16r00CB"    16r00CB " LATIN CAPITAL LETTER E WITH DIAERESIS " 
       "16r00CC"    16r011A " LATIN CAPITAL LETTER E WITH CARON " 
       "16r00CD"    16r00CD " LATIN CAPITAL LETTER I WITH ACUTE " 
       "16r00CE"    16r00CE " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
       "16r00CF"    16r010E " LATIN CAPITAL LETTER D WITH CARON " 
       "16r00D0"    16r0110 " LATIN CAPITAL LETTER D WITH STROKE " 
       "16r00D1"    16r0143 " LATIN CAPITAL LETTER N WITH ACUTE " 
       "16r00D2"    16r0147 " LATIN CAPITAL LETTER N WITH CARON " 
       "16r00D3"    16r00D3 " LATIN CAPITAL LETTER O WITH ACUTE " 
       "16r00D4"    16r00D4 " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
       "16r00D5"    16r0150 " LATIN CAPITAL LETTER O WITH DOUBLE ACUTE " 
       "16r00D6"    16r00D6 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
       "16r00D7"    16r00D7 " MULTIPLICATION SIGN " 
       "16r00D8"    16r0158 " LATIN CAPITAL LETTER R WITH CARON " 
       "16r00D9"    16r016E " LATIN CAPITAL LETTER U WITH RING ABOVE " 
       "16r00DA"    16r00DA " LATIN CAPITAL LETTER U WITH ACUTE " 
       "16r00DB"    16r0170 " LATIN CAPITAL LETTER U WITH DOUBLE ACUTE " 
       "16r00DC"    16r00DC " LATIN CAPITAL LETTER U WITH DIAERESIS " 
       "16r00DD"    16r00DD " LATIN CAPITAL LETTER Y WITH ACUTE " 
       "16r00DE"    16r0162 " LATIN CAPITAL LETTER T WITH CEDILLA " 
       "16r00DF"    16r00DF " LATIN SMALL LETTER SHARP S " 
       "16r00E0"    16r0155 " LATIN SMALL LETTER R WITH ACUTE " 
       "16r00E1"    16r00E1 " LATIN SMALL LETTER A WITH ACUTE " 
       "16r00E2"    16r00E2 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
       "16r00E3"    16r0103 " LATIN SMALL LETTER A WITH BREVE " 
       "16r00E4"    16r00E4 " LATIN SMALL LETTER A WITH DIAERESIS " 
       "16r00E5"    16r013A " LATIN SMALL LETTER L WITH ACUTE " 
       "16r00E6"    16r0107 " LATIN SMALL LETTER C WITH ACUTE " 
       "16r00E7"    16r00E7 " LATIN SMALL LETTER C WITH CEDILLA " 
       "16r00E8"    16r010D " LATIN SMALL LETTER C WITH CARON " 
       "16r00E9"    16r00E9 " LATIN SMALL LETTER E WITH ACUTE " 
       "16r00EA"    16r0119 " LATIN SMALL LETTER E WITH OGONEK " 
       "16r00EB"    16r00EB " LATIN SMALL LETTER E WITH DIAERESIS " 
       "16r00EC"    16r011B " LATIN SMALL LETTER E WITH CARON " 
       "16r00ED"    16r00ED " LATIN SMALL LETTER I WITH ACUTE " 
       "16r00EE"    16r00EE " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
       "16r00EF"    16r010F " LATIN SMALL LETTER D WITH CARON " 
       "16r00F0"    16r0111 " LATIN SMALL LETTER D WITH STROKE " 
       "16r00F1"    16r0144 " LATIN SMALL LETTER N WITH ACUTE " 
       "16r00F2"    16r0148 " LATIN SMALL LETTER N WITH CARON " 
       "16r00F3"    16r00F3 " LATIN SMALL LETTER O WITH ACUTE " 
       "16r00F4"    16r00F4 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
       "16r00F5"    16r0151 " LATIN SMALL LETTER O WITH DOUBLE ACUTE " 
       "16r00F6"    16r00F6 " LATIN SMALL LETTER O WITH DIAERESIS " 
       "16r00F7"    16r00F7 " DIVISION SIGN " 
       "16r00F8"    16r0159 " LATIN SMALL LETTER R WITH CARON " 
       "16r00F9"    16r016F " LATIN SMALL LETTER U WITH RING ABOVE " 
       "16r00FA"    16r00FA " LATIN SMALL LETTER U WITH ACUTE " 
       "16r00FB"    16r0171 " LATIN SMALL LETTER U WITH DOUBLE ACUTE " 
       "16r00FC"    16r00FC " LATIN SMALL LETTER U WITH DIAERESIS " 
       "16r00FD"    16r00FD " LATIN SMALL LETTER Y WITH ACUTE " 
       "16r00FE"    16r0163 " LATIN SMALL LETTER T WITH CEDILLA " 
       "16r00FF"    16r02D9 " DOT ABOVE " 
       ) at:(code - 16rA0).
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode <= 16rA0 ifTrue:[ ^ unicode ].
    unicode > 16r2DD ifTrue:[
        ^ self encodingError.
    ].
    unicode <= 16r17E ifTrue:[
        unicode <= 16r101 ifTrue:[
            (#[
               "16r00A1"    0 " invalid " 
               "16r00A2"    0 " invalid " 
               "16r00A3"    0 " invalid " 
               "16r00A4"    1 " CURRENCY SIGN " 
               "16r00A5"    0 " invalid " 
               "16r00A6"    0 " invalid " 
               "16r00A7"    1 " SECTION SIGN " 
               "16r00A8"    1 " DIAERESIS " 
               "16r00A9"    0 " invalid " 
               "16r00AA"    0 " invalid " 
               "16r00AB"    0 " invalid " 
               "16r00AC"    0 " invalid " 
               "16r00AD"    1 " SOFT HYPHEN " 
               "16r00AE"    0 " invalid " 
               "16r00AF"    0 " invalid " 
               "16r00B0"    1 " DEGREE SIGN " 
               "16r00B1"    0 " invalid " 
               "16r00B2"    0 " invalid " 
               "16r00B3"    0 " invalid " 
               "16r00B4"    1 " ACUTE ACCENT " 
               "16r00B5"    0 " invalid " 
               "16r00B6"    0 " invalid " 
               "16r00B7"    0 " invalid " 
               "16r00B8"    1 " CEDILLA " 
               "16r00B9"    0 " invalid " 
               "16r00BA"    0 " invalid " 
               "16r00BB"    0 " invalid " 
               "16r00BC"    0 " invalid " 
               "16r00BD"    0 " invalid " 
               "16r00BE"    0 " invalid " 
               "16r00BF"    0 " invalid " 
               "16r00C0"    0 " invalid " 
               "16r00C1"    1 " LATIN CAPITAL LETTER A WITH ACUTE " 
               "16r00C2"    1 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
               "16r00C3"    0 " invalid " 
               "16r00C4"    1 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
               "16r00C5"    0 " invalid " 
               "16r00C6"    0 " invalid " 
               "16r00C7"    1 " LATIN CAPITAL LETTER C WITH CEDILLA " 
               "16r00C8"    0 " invalid " 
               "16r00C9"    1 " LATIN CAPITAL LETTER E WITH ACUTE " 
               "16r00CA"    0 " invalid " 
               "16r00CB"    1 " LATIN CAPITAL LETTER E WITH DIAERESIS " 
               "16r00CC"    0 " invalid " 
               "16r00CD"    1 " LATIN CAPITAL LETTER I WITH ACUTE " 
               "16r00CE"    1 " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
               "16r00CF"    0 " invalid " 
               "16r00D0"    0 " invalid " 
               "16r00D1"    0 " invalid " 
               "16r00D2"    0 " invalid " 
               "16r00D3"    1 " LATIN CAPITAL LETTER O WITH ACUTE " 
               "16r00D4"    1 " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
               "16r00D5"    0 " invalid " 
               "16r00D6"    1 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
               "16r00D7"    1 " MULTIPLICATION SIGN " 
               "16r00D8"    0 " invalid " 
               "16r00D9"    0 " invalid " 
               "16r00DA"    1 " LATIN CAPITAL LETTER U WITH ACUTE " 
               "16r00DB"    0 " invalid " 
               "16r00DC"    1 " LATIN CAPITAL LETTER U WITH DIAERESIS " 
               "16r00DD"    1 " LATIN CAPITAL LETTER Y WITH ACUTE " 
               "16r00DE"    0 " invalid " 
               "16r00DF"    1 " LATIN SMALL LETTER SHARP S " 
               "16r00E0"    0 " invalid " 
               "16r00E1"    1 " LATIN SMALL LETTER A WITH ACUTE " 
               "16r00E2"    1 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
               "16r00E3"    0 " invalid " 
               "16r00E4"    1 " LATIN SMALL LETTER A WITH DIAERESIS " 
               "16r00E5"    0 " invalid " 
               "16r00E6"    0 " invalid " 
               "16r00E7"    1 " LATIN SMALL LETTER C WITH CEDILLA " 
               "16r00E8"    0 " invalid " 
               "16r00E9"    1 " LATIN SMALL LETTER E WITH ACUTE " 
               "16r00EA"    0 " invalid " 
               "16r00EB"    1 " LATIN SMALL LETTER E WITH DIAERESIS " 
               "16r00EC"    0 " invalid " 
               "16r00ED"    1 " LATIN SMALL LETTER I WITH ACUTE " 
               "16r00EE"    1 " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
               "16r00EF"    0 " invalid " 
               "16r00F0"    0 " invalid " 
               "16r00F1"    0 " invalid " 
               "16r00F2"    0 " invalid " 
               "16r00F3"    1 " LATIN SMALL LETTER O WITH ACUTE " 
               "16r00F4"    1 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
               "16r00F5"    0 " invalid " 
               "16r00F6"    1 " LATIN SMALL LETTER O WITH DIAERESIS " 
               "16r00F7"    1 " DIVISION SIGN " 
               "16r00F8"    0 " invalid " 
               "16r00F9"    0 " invalid " 
               "16r00FA"    1 " LATIN SMALL LETTER U WITH ACUTE " 
               "16r00FB"    0 " invalid " 
               "16r00FC"    1 " LATIN SMALL LETTER U WITH DIAERESIS " 
               "16r00FD"    1 " LATIN SMALL LETTER Y WITH ACUTE " 
               "16r00FE"    0 " invalid " 
               "16r00FF"    0 " invalid " 
               "16r0100"    0 " invalid " 
               "16r0101"    0 " invalid " 
            ] at:(unicode - 160)) ~~ 0 ifTrue:[^ unicode].
            ^ self encodingError
        ].
        [
            |t|
            t := #[
               "16r0102"    16rC3 " LATIN CAPITAL LETTER A WITH BREVE " 
               "16r0103"    16rE3 " LATIN SMALL LETTER A WITH BREVE " 
               "16r0104"    16rA1 " LATIN CAPITAL LETTER A WITH OGONEK " 
               "16r0105"    16rB1 " LATIN SMALL LETTER A WITH OGONEK " 
               "16r0106"    16rC6 " LATIN CAPITAL LETTER C WITH ACUTE " 
               "16r0107"    16rE6 " LATIN SMALL LETTER C WITH ACUTE " 
               "16r0108"    16r00 " invalid " 
               "16r0109"    16r00 " invalid " 
               "16r010A"    16r00 " invalid " 
               "16r010B"    16r00 " invalid " 
               "16r010C"    16rC8 " LATIN CAPITAL LETTER C WITH CARON " 
               "16r010D"    16rE8 " LATIN SMALL LETTER C WITH CARON " 
               "16r010E"    16rCF " LATIN CAPITAL LETTER D WITH CARON " 
               "16r010F"    16rEF " LATIN SMALL LETTER D WITH CARON " 
               "16r0110"    16rD0 " LATIN CAPITAL LETTER D WITH STROKE " 
               "16r0111"    16rF0 " LATIN SMALL LETTER D WITH STROKE " 
               "16r0112"    16r00 " invalid " 
               "16r0113"    16r00 " invalid " 
               "16r0114"    16r00 " invalid " 
               "16r0115"    16r00 " invalid " 
               "16r0116"    16r00 " invalid " 
               "16r0117"    16r00 " invalid " 
               "16r0118"    16rCA " LATIN CAPITAL LETTER E WITH OGONEK " 
               "16r0119"    16rEA " LATIN SMALL LETTER E WITH OGONEK " 
               "16r011A"    16rCC " LATIN CAPITAL LETTER E WITH CARON " 
               "16r011B"    16rEC " LATIN SMALL LETTER E WITH CARON " 
               "16r011C"    16r00 " invalid " 
               "16r011D"    16r00 " invalid " 
               "16r011E"    16r00 " invalid " 
               "16r011F"    16r00 " invalid " 
               "16r0120"    16r00 " invalid " 
               "16r0121"    16r00 " invalid " 
               "16r0122"    16r00 " invalid " 
               "16r0123"    16r00 " invalid " 
               "16r0124"    16r00 " invalid " 
               "16r0125"    16r00 " invalid " 
               "16r0126"    16r00 " invalid " 
               "16r0127"    16r00 " invalid " 
               "16r0128"    16r00 " invalid " 
               "16r0129"    16r00 " invalid " 
               "16r012A"    16r00 " invalid " 
               "16r012B"    16r00 " invalid " 
               "16r012C"    16r00 " invalid " 
               "16r012D"    16r00 " invalid " 
               "16r012E"    16r00 " invalid " 
               "16r012F"    16r00 " invalid " 
               "16r0130"    16r00 " invalid " 
               "16r0131"    16r00 " invalid " 
               "16r0132"    16r00 " invalid " 
               "16r0133"    16r00 " invalid " 
               "16r0134"    16r00 " invalid " 
               "16r0135"    16r00 " invalid " 
               "16r0136"    16r00 " invalid " 
               "16r0137"    16r00 " invalid " 
               "16r0138"    16r00 " invalid " 
               "16r0139"    16rC5 " LATIN CAPITAL LETTER L WITH ACUTE " 
               "16r013A"    16rE5 " LATIN SMALL LETTER L WITH ACUTE " 
               "16r013B"    16r00 " invalid " 
               "16r013C"    16r00 " invalid " 
               "16r013D"    16rA5 " LATIN CAPITAL LETTER L WITH CARON " 
               "16r013E"    16rB5 " LATIN SMALL LETTER L WITH CARON " 
               "16r013F"    16r00 " invalid " 
               "16r0140"    16r00 " invalid " 
               "16r0141"    16rA3 " LATIN CAPITAL LETTER L WITH STROKE " 
               "16r0142"    16rB3 " LATIN SMALL LETTER L WITH STROKE " 
               "16r0143"    16rD1 " LATIN CAPITAL LETTER N WITH ACUTE " 
               "16r0144"    16rF1 " LATIN SMALL LETTER N WITH ACUTE " 
               "16r0145"    16r00 " invalid " 
               "16r0146"    16r00 " invalid " 
               "16r0147"    16rD2 " LATIN CAPITAL LETTER N WITH CARON " 
               "16r0148"    16rF2 " LATIN SMALL LETTER N WITH CARON " 
               "16r0149"    16r00 " invalid " 
               "16r014A"    16r00 " invalid " 
               "16r014B"    16r00 " invalid " 
               "16r014C"    16r00 " invalid " 
               "16r014D"    16r00 " invalid " 
               "16r014E"    16r00 " invalid " 
               "16r014F"    16r00 " invalid " 
               "16r0150"    16rD5 " LATIN CAPITAL LETTER O WITH DOUBLE ACUTE " 
               "16r0151"    16rF5 " LATIN SMALL LETTER O WITH DOUBLE ACUTE " 
               "16r0152"    16r00 " invalid " 
               "16r0153"    16r00 " invalid " 
               "16r0154"    16rC0 " LATIN CAPITAL LETTER R WITH ACUTE " 
               "16r0155"    16rE0 " LATIN SMALL LETTER R WITH ACUTE " 
               "16r0156"    16r00 " invalid " 
               "16r0157"    16r00 " invalid " 
               "16r0158"    16rD8 " LATIN CAPITAL LETTER R WITH CARON " 
               "16r0159"    16rF8 " LATIN SMALL LETTER R WITH CARON " 
               "16r015A"    16rA6 " LATIN CAPITAL LETTER S WITH ACUTE " 
               "16r015B"    16rB6 " LATIN SMALL LETTER S WITH ACUTE " 
               "16r015C"    16r00 " invalid " 
               "16r015D"    16r00 " invalid " 
               "16r015E"    16rAA " LATIN CAPITAL LETTER S WITH CEDILLA " 
               "16r015F"    16rBA " LATIN SMALL LETTER S WITH CEDILLA " 
               "16r0160"    16rA9 " LATIN CAPITAL LETTER S WITH CARON " 
               "16r0161"    16rB9 " LATIN SMALL LETTER S WITH CARON " 
               "16r0162"    16rDE " LATIN CAPITAL LETTER T WITH CEDILLA " 
               "16r0163"    16rFE " LATIN SMALL LETTER T WITH CEDILLA " 
               "16r0164"    16rAB " LATIN CAPITAL LETTER T WITH CARON " 
               "16r0165"    16rBB " LATIN SMALL LETTER T WITH CARON " 
               "16r0166"    16r00 " invalid " 
               "16r0167"    16r00 " invalid " 
               "16r0168"    16r00 " invalid " 
               "16r0169"    16r00 " invalid " 
               "16r016A"    16r00 " invalid " 
               "16r016B"    16r00 " invalid " 
               "16r016C"    16r00 " invalid " 
               "16r016D"    16r00 " invalid " 
               "16r016E"    16rD9 " LATIN CAPITAL LETTER U WITH RING ABOVE " 
               "16r016F"    16rF9 " LATIN SMALL LETTER U WITH RING ABOVE " 
               "16r0170"    16rDB " LATIN CAPITAL LETTER U WITH DOUBLE ACUTE " 
               "16r0171"    16rFB " LATIN SMALL LETTER U WITH DOUBLE ACUTE " 
               "16r0172"    16r00 " invalid " 
               "16r0173"    16r00 " invalid " 
               "16r0174"    16r00 " invalid " 
               "16r0175"    16r00 " invalid " 
               "16r0176"    16r00 " invalid " 
               "16r0177"    16r00 " invalid " 
               "16r0178"    16r00 " invalid " 
               "16r0179"    16rAC " LATIN CAPITAL LETTER Z WITH ACUTE " 
               "16r017A"    16rBC " LATIN SMALL LETTER Z WITH ACUTE " 
               "16r017B"    16rAF " LATIN CAPITAL LETTER Z WITH DOT ABOVE " 
               "16r017C"    16rBF " LATIN SMALL LETTER Z WITH DOT ABOVE " 
               "16r017D"    16rAE " LATIN CAPITAL LETTER Z WITH CARON " 
               "16r017E"    16rBE " LATIN SMALL LETTER Z WITH CARON " 
               ] at:(unicode - 16r101).
            t == 0 ifFalse:[^ t].
            ^ self encodingError
        ] value.
    ].
    unicode <= 16r2C6 ifTrue:[
        ^ self encodingError
    ].
    unicode == 16r2C7 ifTrue:[
        ^  "16r02C7" 16r00B7 " CARON " 
    ].
    unicode <= 16r2D7 ifTrue:[
        ^ self encodingError
    ].
    [
        |t|
        t := #[
           "16r02D8"    16rA2 " BREVE " 
           "16r02D9"    16rFF " DOT ABOVE " 
           "16r02DA"    16r00 " invalid " 
           "16r02DB"    16rB2 " OGONEK " 
           "16r02DC"    16r00 " invalid " 
           "16r02DD"    16rBD " DOUBLE ACUTE ACCENT " 
           ] at:(unicode - 16r2D7).
        t == 0 ifFalse:[^ t].
        ^ self encodingError
    ] value.
! !

!ISO8859_2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO8859_2.st,v 1.4 2005/03/31 18:12:47 cg Exp $'
!

version_SVN
    ^ '$Id: CharacterEncoderImplementations__ISO8859_2.st 10807 2012-05-05 21:58:24Z vranyj1 $'
! !


