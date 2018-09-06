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

SingleByteEncoder subclass:#ISO8859_5
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO8859_5 class methodsFor:'documentation'!

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
    8859-5 - Kyrillic.

    [see with:]
        CharacterEncoderImplementations::ISO8859_5 showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!ISO8859_5 class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'ISO8859/8859-5.TXT'
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/ISO8859/8859-5.TXT

#
#       Name:             ISO 8859-5:1999 to Unicode
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
#       ISO/IEC 8859-5:1999 characters map into Unicode.
#
#       Format:  Three tab-separated columns
#                Column #1 is the ISO/IEC 8859-5 code (in hex as 0xXX)
#                Column #2 is the Unicode (in hex as 0xXXXX)
#                Column #3 the Unicode name (follows a comment sign, '#')
#
#       The entries are in ISO/IEC 8859-5 order.
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
0xA1    0x0401  #       CYRILLIC CAPITAL LETTER IO
0xA2    0x0402  #       CYRILLIC CAPITAL LETTER DJE
0xA3    0x0403  #       CYRILLIC CAPITAL LETTER GJE
0xA4    0x0404  #       CYRILLIC CAPITAL LETTER UKRAINIAN IE
0xA5    0x0405  #       CYRILLIC CAPITAL LETTER DZE
0xA6    0x0406  #       CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
0xA7    0x0407  #       CYRILLIC CAPITAL LETTER YI
0xA8    0x0408  #       CYRILLIC CAPITAL LETTER JE
0xA9    0x0409  #       CYRILLIC CAPITAL LETTER LJE
0xAA    0x040A  #       CYRILLIC CAPITAL LETTER NJE
0xAB    0x040B  #       CYRILLIC CAPITAL LETTER TSHE
0xAC    0x040C  #       CYRILLIC CAPITAL LETTER KJE
0xAD    0x00AD  #       SOFT HYPHEN
0xAE    0x040E  #       CYRILLIC CAPITAL LETTER SHORT U
0xAF    0x040F  #       CYRILLIC CAPITAL LETTER DZHE
0xB0    0x0410  #       CYRILLIC CAPITAL LETTER A
0xB1    0x0411  #       CYRILLIC CAPITAL LETTER BE
0xB2    0x0412  #       CYRILLIC CAPITAL LETTER VE
0xB3    0x0413  #       CYRILLIC CAPITAL LETTER GHE
0xB4    0x0414  #       CYRILLIC CAPITAL LETTER DE
0xB5    0x0415  #       CYRILLIC CAPITAL LETTER IE
0xB6    0x0416  #       CYRILLIC CAPITAL LETTER ZHE
0xB7    0x0417  #       CYRILLIC CAPITAL LETTER ZE
0xB8    0x0418  #       CYRILLIC CAPITAL LETTER I
0xB9    0x0419  #       CYRILLIC CAPITAL LETTER SHORT I
0xBA    0x041A  #       CYRILLIC CAPITAL LETTER KA
0xBB    0x041B  #       CYRILLIC CAPITAL LETTER EL
0xBC    0x041C  #       CYRILLIC CAPITAL LETTER EM
0xBD    0x041D  #       CYRILLIC CAPITAL LETTER EN
0xBE    0x041E  #       CYRILLIC CAPITAL LETTER O
0xBF    0x041F  #       CYRILLIC CAPITAL LETTER PE
0xC0    0x0420  #       CYRILLIC CAPITAL LETTER ER
0xC1    0x0421  #       CYRILLIC CAPITAL LETTER ES
0xC2    0x0422  #       CYRILLIC CAPITAL LETTER TE
0xC3    0x0423  #       CYRILLIC CAPITAL LETTER U
0xC4    0x0424  #       CYRILLIC CAPITAL LETTER EF
0xC5    0x0425  #       CYRILLIC CAPITAL LETTER HA
0xC6    0x0426  #       CYRILLIC CAPITAL LETTER TSE
0xC7    0x0427  #       CYRILLIC CAPITAL LETTER CHE
0xC8    0x0428  #       CYRILLIC CAPITAL LETTER SHA
0xC9    0x0429  #       CYRILLIC CAPITAL LETTER SHCHA
0xCA    0x042A  #       CYRILLIC CAPITAL LETTER HARD SIGN
0xCB    0x042B  #       CYRILLIC CAPITAL LETTER YERU
0xCC    0x042C  #       CYRILLIC CAPITAL LETTER SOFT SIGN
0xCD    0x042D  #       CYRILLIC CAPITAL LETTER E
0xCE    0x042E  #       CYRILLIC CAPITAL LETTER YU
0xCF    0x042F  #       CYRILLIC CAPITAL LETTER YA
0xD0    0x0430  #       CYRILLIC SMALL LETTER A
0xD1    0x0431  #       CYRILLIC SMALL LETTER BE
0xD2    0x0432  #       CYRILLIC SMALL LETTER VE
0xD3    0x0433  #       CYRILLIC SMALL LETTER GHE
0xD4    0x0434  #       CYRILLIC SMALL LETTER DE
0xD5    0x0435  #       CYRILLIC SMALL LETTER IE
0xD6    0x0436  #       CYRILLIC SMALL LETTER ZHE
0xD7    0x0437  #       CYRILLIC SMALL LETTER ZE
0xD8    0x0438  #       CYRILLIC SMALL LETTER I
0xD9    0x0439  #       CYRILLIC SMALL LETTER SHORT I
0xDA    0x043A  #       CYRILLIC SMALL LETTER KA
0xDB    0x043B  #       CYRILLIC SMALL LETTER EL
0xDC    0x043C  #       CYRILLIC SMALL LETTER EM
0xDD    0x043D  #       CYRILLIC SMALL LETTER EN
0xDE    0x043E  #       CYRILLIC SMALL LETTER O
0xDF    0x043F  #       CYRILLIC SMALL LETTER PE
0xE0    0x0440  #       CYRILLIC SMALL LETTER ER
0xE1    0x0441  #       CYRILLIC SMALL LETTER ES
0xE2    0x0442  #       CYRILLIC SMALL LETTER TE
0xE3    0x0443  #       CYRILLIC SMALL LETTER U
0xE4    0x0444  #       CYRILLIC SMALL LETTER EF
0xE5    0x0445  #       CYRILLIC SMALL LETTER HA
0xE6    0x0446  #       CYRILLIC SMALL LETTER TSE
0xE7    0x0447  #       CYRILLIC SMALL LETTER CHE
0xE8    0x0448  #       CYRILLIC SMALL LETTER SHA
0xE9    0x0449  #       CYRILLIC SMALL LETTER SHCHA
0xEA    0x044A  #       CYRILLIC SMALL LETTER HARD SIGN
0xEB    0x044B  #       CYRILLIC SMALL LETTER YERU
0xEC    0x044C  #       CYRILLIC SMALL LETTER SOFT SIGN
0xED    0x044D  #       CYRILLIC SMALL LETTER E
0xEE    0x044E  #       CYRILLIC SMALL LETTER YU
0xEF    0x044F  #       CYRILLIC SMALL LETTER YA
0xF0    0x2116  #       NUMERO SIGN
0xF1    0x0451  #       CYRILLIC SMALL LETTER IO
0xF2    0x0452  #       CYRILLIC SMALL LETTER DJE
0xF3    0x0453  #       CYRILLIC SMALL LETTER GJE
0xF4    0x0454  #       CYRILLIC SMALL LETTER UKRAINIAN IE
0xF5    0x0455  #       CYRILLIC SMALL LETTER DZE
0xF6    0x0456  #       CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
0xF7    0x0457  #       CYRILLIC SMALL LETTER YI
0xF8    0x0458  #       CYRILLIC SMALL LETTER JE
0xF9    0x0459  #       CYRILLIC SMALL LETTER LJE
0xFA    0x045A  #       CYRILLIC SMALL LETTER NJE
0xFB    0x045B  #       CYRILLIC SMALL LETTER TSHE
0xFC    0x045C  #       CYRILLIC SMALL LETTER KJE
0xFD    0x00A7  #       SECTION SIGN
0xFE    0x045E  #       CYRILLIC SMALL LETTER SHORT U
0xFF    0x045F  #       CYRILLIC SMALL LETTER DZHE

"
! !

!ISO8859_5 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Cyrillic'
! !

!ISO8859_5 methodsFor:'encoding & decoding'!

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
       "16r00A1"    16r0401 " CYRILLIC CAPITAL LETTER IO " 
       "16r00A2"    16r0402 " CYRILLIC CAPITAL LETTER DJE " 
       "16r00A3"    16r0403 " CYRILLIC CAPITAL LETTER GJE " 
       "16r00A4"    16r0404 " CYRILLIC CAPITAL LETTER UKRAINIAN IE " 
       "16r00A5"    16r0405 " CYRILLIC CAPITAL LETTER DZE " 
       "16r00A6"    16r0406 " CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I " 
       "16r00A7"    16r0407 " CYRILLIC CAPITAL LETTER YI " 
       "16r00A8"    16r0408 " CYRILLIC CAPITAL LETTER JE " 
       "16r00A9"    16r0409 " CYRILLIC CAPITAL LETTER LJE " 
       "16r00AA"    16r040A " CYRILLIC CAPITAL LETTER NJE " 
       "16r00AB"    16r040B " CYRILLIC CAPITAL LETTER TSHE " 
       "16r00AC"    16r040C " CYRILLIC CAPITAL LETTER KJE " 
       "16r00AD"    16r00AD " SOFT HYPHEN " 
       "16r00AE"    16r040E " CYRILLIC CAPITAL LETTER SHORT U " 
       "16r00AF"    16r040F " CYRILLIC CAPITAL LETTER DZHE " 
       "16r00B0"    16r0410 " CYRILLIC CAPITAL LETTER A " 
       "16r00B1"    16r0411 " CYRILLIC CAPITAL LETTER BE " 
       "16r00B2"    16r0412 " CYRILLIC CAPITAL LETTER VE " 
       "16r00B3"    16r0413 " CYRILLIC CAPITAL LETTER GHE " 
       "16r00B4"    16r0414 " CYRILLIC CAPITAL LETTER DE " 
       "16r00B5"    16r0415 " CYRILLIC CAPITAL LETTER IE " 
       "16r00B6"    16r0416 " CYRILLIC CAPITAL LETTER ZHE " 
       "16r00B7"    16r0417 " CYRILLIC CAPITAL LETTER ZE " 
       "16r00B8"    16r0418 " CYRILLIC CAPITAL LETTER I " 
       "16r00B9"    16r0419 " CYRILLIC CAPITAL LETTER SHORT I " 
       "16r00BA"    16r041A " CYRILLIC CAPITAL LETTER KA " 
       "16r00BB"    16r041B " CYRILLIC CAPITAL LETTER EL " 
       "16r00BC"    16r041C " CYRILLIC CAPITAL LETTER EM " 
       "16r00BD"    16r041D " CYRILLIC CAPITAL LETTER EN " 
       "16r00BE"    16r041E " CYRILLIC CAPITAL LETTER O " 
       "16r00BF"    16r041F " CYRILLIC CAPITAL LETTER PE " 
       "16r00C0"    16r0420 " CYRILLIC CAPITAL LETTER ER " 
       "16r00C1"    16r0421 " CYRILLIC CAPITAL LETTER ES " 
       "16r00C2"    16r0422 " CYRILLIC CAPITAL LETTER TE " 
       "16r00C3"    16r0423 " CYRILLIC CAPITAL LETTER U " 
       "16r00C4"    16r0424 " CYRILLIC CAPITAL LETTER EF " 
       "16r00C5"    16r0425 " CYRILLIC CAPITAL LETTER HA " 
       "16r00C6"    16r0426 " CYRILLIC CAPITAL LETTER TSE " 
       "16r00C7"    16r0427 " CYRILLIC CAPITAL LETTER CHE " 
       "16r00C8"    16r0428 " CYRILLIC CAPITAL LETTER SHA " 
       "16r00C9"    16r0429 " CYRILLIC CAPITAL LETTER SHCHA " 
       "16r00CA"    16r042A " CYRILLIC CAPITAL LETTER HARD SIGN " 
       "16r00CB"    16r042B " CYRILLIC CAPITAL LETTER YERU " 
       "16r00CC"    16r042C " CYRILLIC CAPITAL LETTER SOFT SIGN " 
       "16r00CD"    16r042D " CYRILLIC CAPITAL LETTER E " 
       "16r00CE"    16r042E " CYRILLIC CAPITAL LETTER YU " 
       "16r00CF"    16r042F " CYRILLIC CAPITAL LETTER YA " 
       "16r00D0"    16r0430 " CYRILLIC SMALL LETTER A " 
       "16r00D1"    16r0431 " CYRILLIC SMALL LETTER BE " 
       "16r00D2"    16r0432 " CYRILLIC SMALL LETTER VE " 
       "16r00D3"    16r0433 " CYRILLIC SMALL LETTER GHE " 
       "16r00D4"    16r0434 " CYRILLIC SMALL LETTER DE " 
       "16r00D5"    16r0435 " CYRILLIC SMALL LETTER IE " 
       "16r00D6"    16r0436 " CYRILLIC SMALL LETTER ZHE " 
       "16r00D7"    16r0437 " CYRILLIC SMALL LETTER ZE " 
       "16r00D8"    16r0438 " CYRILLIC SMALL LETTER I " 
       "16r00D9"    16r0439 " CYRILLIC SMALL LETTER SHORT I " 
       "16r00DA"    16r043A " CYRILLIC SMALL LETTER KA " 
       "16r00DB"    16r043B " CYRILLIC SMALL LETTER EL " 
       "16r00DC"    16r043C " CYRILLIC SMALL LETTER EM " 
       "16r00DD"    16r043D " CYRILLIC SMALL LETTER EN " 
       "16r00DE"    16r043E " CYRILLIC SMALL LETTER O " 
       "16r00DF"    16r043F " CYRILLIC SMALL LETTER PE " 
       "16r00E0"    16r0440 " CYRILLIC SMALL LETTER ER " 
       "16r00E1"    16r0441 " CYRILLIC SMALL LETTER ES " 
       "16r00E2"    16r0442 " CYRILLIC SMALL LETTER TE " 
       "16r00E3"    16r0443 " CYRILLIC SMALL LETTER U " 
       "16r00E4"    16r0444 " CYRILLIC SMALL LETTER EF " 
       "16r00E5"    16r0445 " CYRILLIC SMALL LETTER HA " 
       "16r00E6"    16r0446 " CYRILLIC SMALL LETTER TSE " 
       "16r00E7"    16r0447 " CYRILLIC SMALL LETTER CHE " 
       "16r00E8"    16r0448 " CYRILLIC SMALL LETTER SHA " 
       "16r00E9"    16r0449 " CYRILLIC SMALL LETTER SHCHA " 
       "16r00EA"    16r044A " CYRILLIC SMALL LETTER HARD SIGN " 
       "16r00EB"    16r044B " CYRILLIC SMALL LETTER YERU " 
       "16r00EC"    16r044C " CYRILLIC SMALL LETTER SOFT SIGN " 
       "16r00ED"    16r044D " CYRILLIC SMALL LETTER E " 
       "16r00EE"    16r044E " CYRILLIC SMALL LETTER YU " 
       "16r00EF"    16r044F " CYRILLIC SMALL LETTER YA " 
       "16r00F0"    16r2116 " NUMERO SIGN " 
       "16r00F1"    16r0451 " CYRILLIC SMALL LETTER IO " 
       "16r00F2"    16r0452 " CYRILLIC SMALL LETTER DJE " 
       "16r00F3"    16r0453 " CYRILLIC SMALL LETTER GJE " 
       "16r00F4"    16r0454 " CYRILLIC SMALL LETTER UKRAINIAN IE " 
       "16r00F5"    16r0455 " CYRILLIC SMALL LETTER DZE " 
       "16r00F6"    16r0456 " CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I " 
       "16r00F7"    16r0457 " CYRILLIC SMALL LETTER YI " 
       "16r00F8"    16r0458 " CYRILLIC SMALL LETTER JE " 
       "16r00F9"    16r0459 " CYRILLIC SMALL LETTER LJE " 
       "16r00FA"    16r045A " CYRILLIC SMALL LETTER NJE " 
       "16r00FB"    16r045B " CYRILLIC SMALL LETTER TSHE " 
       "16r00FC"    16r045C " CYRILLIC SMALL LETTER KJE " 
       "16r00FD"    16r00A7 " SECTION SIGN " 
       "16r00FE"    16r045E " CYRILLIC SMALL LETTER SHORT U " 
       "16r00FF"    16r045F " CYRILLIC SMALL LETTER DZHE " 
       ) at:(code - 16rA0).
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode <= 16rA0 ifTrue:[ ^ unicode ].
    unicode > 16r2116 ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r45F ifTrue:[
	unicode <= 16rAD ifTrue:[
	    [
		|t|
		t := #[
		   "16r00A1"    16r00 " invalid " 
		   "16r00A2"    16r00 " invalid " 
		   "16r00A3"    16r00 " invalid " 
		   "16r00A4"    16r00 " invalid " 
		   "16r00A5"    16r00 " invalid " 
		   "16r00A6"    16r00 " invalid " 
		   "16r00A7"    16rFD " SECTION SIGN " 
		   "16r00A8"    16r00 " invalid " 
		   "16r00A9"    16r00 " invalid " 
		   "16r00AA"    16r00 " invalid " 
		   "16r00AB"    16r00 " invalid " 
		   "16r00AC"    16r00 " invalid " 
		   "16r00AD"    16rAD " SOFT HYPHEN " 
		   ] at:(unicode - 16rA0).
		t == 0 ifFalse:[^ t].
		^ self encodingError
	    ] value.
	].
	unicode <= 16r400 ifTrue:[
	    ^ self encodingError.
	].
	[
	    |t|
	    t := #[
	       "16r0401"    16rA1 " CYRILLIC CAPITAL LETTER IO " 
	       "16r0402"    16rA2 " CYRILLIC CAPITAL LETTER DJE " 
	       "16r0403"    16rA3 " CYRILLIC CAPITAL LETTER GJE " 
	       "16r0404"    16rA4 " CYRILLIC CAPITAL LETTER UKRAINIAN IE " 
	       "16r0405"    16rA5 " CYRILLIC CAPITAL LETTER DZE " 
	       "16r0406"    16rA6 " CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I " 
	       "16r0407"    16rA7 " CYRILLIC CAPITAL LETTER YI " 
	       "16r0408"    16rA8 " CYRILLIC CAPITAL LETTER JE " 
	       "16r0409"    16rA9 " CYRILLIC CAPITAL LETTER LJE " 
	       "16r040A"    16rAA " CYRILLIC CAPITAL LETTER NJE " 
	       "16r040B"    16rAB " CYRILLIC CAPITAL LETTER TSHE " 
	       "16r040C"    16rAC " CYRILLIC CAPITAL LETTER KJE " 
	       "16r040D"    16r00 " invalid " 
	       "16r040E"    16rAE " CYRILLIC CAPITAL LETTER SHORT U " 
	       "16r040F"    16rAF " CYRILLIC CAPITAL LETTER DZHE " 
	       "16r0410"    16rB0 " CYRILLIC CAPITAL LETTER A " 
	       "16r0411"    16rB1 " CYRILLIC CAPITAL LETTER BE " 
	       "16r0412"    16rB2 " CYRILLIC CAPITAL LETTER VE " 
	       "16r0413"    16rB3 " CYRILLIC CAPITAL LETTER GHE " 
	       "16r0414"    16rB4 " CYRILLIC CAPITAL LETTER DE " 
	       "16r0415"    16rB5 " CYRILLIC CAPITAL LETTER IE " 
	       "16r0416"    16rB6 " CYRILLIC CAPITAL LETTER ZHE " 
	       "16r0417"    16rB7 " CYRILLIC CAPITAL LETTER ZE " 
	       "16r0418"    16rB8 " CYRILLIC CAPITAL LETTER I " 
	       "16r0419"    16rB9 " CYRILLIC CAPITAL LETTER SHORT I " 
	       "16r041A"    16rBA " CYRILLIC CAPITAL LETTER KA " 
	       "16r041B"    16rBB " CYRILLIC CAPITAL LETTER EL " 
	       "16r041C"    16rBC " CYRILLIC CAPITAL LETTER EM " 
	       "16r041D"    16rBD " CYRILLIC CAPITAL LETTER EN " 
	       "16r041E"    16rBE " CYRILLIC CAPITAL LETTER O " 
	       "16r041F"    16rBF " CYRILLIC CAPITAL LETTER PE " 
	       "16r0420"    16rC0 " CYRILLIC CAPITAL LETTER ER " 
	       "16r0421"    16rC1 " CYRILLIC CAPITAL LETTER ES " 
	       "16r0422"    16rC2 " CYRILLIC CAPITAL LETTER TE " 
	       "16r0423"    16rC3 " CYRILLIC CAPITAL LETTER U " 
	       "16r0424"    16rC4 " CYRILLIC CAPITAL LETTER EF " 
	       "16r0425"    16rC5 " CYRILLIC CAPITAL LETTER HA " 
	       "16r0426"    16rC6 " CYRILLIC CAPITAL LETTER TSE " 
	       "16r0427"    16rC7 " CYRILLIC CAPITAL LETTER CHE " 
	       "16r0428"    16rC8 " CYRILLIC CAPITAL LETTER SHA " 
	       "16r0429"    16rC9 " CYRILLIC CAPITAL LETTER SHCHA " 
	       "16r042A"    16rCA " CYRILLIC CAPITAL LETTER HARD SIGN " 
	       "16r042B"    16rCB " CYRILLIC CAPITAL LETTER YERU " 
	       "16r042C"    16rCC " CYRILLIC CAPITAL LETTER SOFT SIGN " 
	       "16r042D"    16rCD " CYRILLIC CAPITAL LETTER E " 
	       "16r042E"    16rCE " CYRILLIC CAPITAL LETTER YU " 
	       "16r042F"    16rCF " CYRILLIC CAPITAL LETTER YA " 
	       "16r0430"    16rD0 " CYRILLIC SMALL LETTER A " 
	       "16r0431"    16rD1 " CYRILLIC SMALL LETTER BE " 
	       "16r0432"    16rD2 " CYRILLIC SMALL LETTER VE " 
	       "16r0433"    16rD3 " CYRILLIC SMALL LETTER GHE " 
	       "16r0434"    16rD4 " CYRILLIC SMALL LETTER DE " 
	       "16r0435"    16rD5 " CYRILLIC SMALL LETTER IE " 
	       "16r0436"    16rD6 " CYRILLIC SMALL LETTER ZHE " 
	       "16r0437"    16rD7 " CYRILLIC SMALL LETTER ZE " 
	       "16r0438"    16rD8 " CYRILLIC SMALL LETTER I " 
	       "16r0439"    16rD9 " CYRILLIC SMALL LETTER SHORT I " 
	       "16r043A"    16rDA " CYRILLIC SMALL LETTER KA " 
	       "16r043B"    16rDB " CYRILLIC SMALL LETTER EL " 
	       "16r043C"    16rDC " CYRILLIC SMALL LETTER EM " 
	       "16r043D"    16rDD " CYRILLIC SMALL LETTER EN " 
	       "16r043E"    16rDE " CYRILLIC SMALL LETTER O " 
	       "16r043F"    16rDF " CYRILLIC SMALL LETTER PE " 
	       "16r0440"    16rE0 " CYRILLIC SMALL LETTER ER " 
	       "16r0441"    16rE1 " CYRILLIC SMALL LETTER ES " 
	       "16r0442"    16rE2 " CYRILLIC SMALL LETTER TE " 
	       "16r0443"    16rE3 " CYRILLIC SMALL LETTER U " 
	       "16r0444"    16rE4 " CYRILLIC SMALL LETTER EF " 
	       "16r0445"    16rE5 " CYRILLIC SMALL LETTER HA " 
	       "16r0446"    16rE6 " CYRILLIC SMALL LETTER TSE " 
	       "16r0447"    16rE7 " CYRILLIC SMALL LETTER CHE " 
	       "16r0448"    16rE8 " CYRILLIC SMALL LETTER SHA " 
	       "16r0449"    16rE9 " CYRILLIC SMALL LETTER SHCHA " 
	       "16r044A"    16rEA " CYRILLIC SMALL LETTER HARD SIGN " 
	       "16r044B"    16rEB " CYRILLIC SMALL LETTER YERU " 
	       "16r044C"    16rEC " CYRILLIC SMALL LETTER SOFT SIGN " 
	       "16r044D"    16rED " CYRILLIC SMALL LETTER E " 
	       "16r044E"    16rEE " CYRILLIC SMALL LETTER YU " 
	       "16r044F"    16rEF " CYRILLIC SMALL LETTER YA " 
	       "16r0450"    16r00 " invalid " 
	       "16r0451"    16rF1 " CYRILLIC SMALL LETTER IO " 
	       "16r0452"    16rF2 " CYRILLIC SMALL LETTER DJE " 
	       "16r0453"    16rF3 " CYRILLIC SMALL LETTER GJE " 
	       "16r0454"    16rF4 " CYRILLIC SMALL LETTER UKRAINIAN IE " 
	       "16r0455"    16rF5 " CYRILLIC SMALL LETTER DZE " 
	       "16r0456"    16rF6 " CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I " 
	       "16r0457"    16rF7 " CYRILLIC SMALL LETTER YI " 
	       "16r0458"    16rF8 " CYRILLIC SMALL LETTER JE " 
	       "16r0459"    16rF9 " CYRILLIC SMALL LETTER LJE " 
	       "16r045A"    16rFA " CYRILLIC SMALL LETTER NJE " 
	       "16r045B"    16rFB " CYRILLIC SMALL LETTER TSHE " 
	       "16r045C"    16rFC " CYRILLIC SMALL LETTER KJE " 
	       "16r045D"    16r00 " invalid " 
	       "16r045E"    16rFE " CYRILLIC SMALL LETTER SHORT U " 
	       "16r045F"    16rFF " CYRILLIC SMALL LETTER DZHE " 
	       ] at:(unicode - 16r400).
	    t == 0 ifFalse:[^ t].
	    ^ self encodingError
	] value.
    ].
    unicode <= 16r2115 ifTrue:[
	^ self encodingError.
    ].
    ^  "16r2116" 16r00F0 " NUMERO SIGN " 
! !

!ISO8859_5 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO8859_5.st,v 1.5 2012-07-11 16:42:52 stefan Exp $'
! !
