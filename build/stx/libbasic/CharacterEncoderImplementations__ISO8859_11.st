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

SingleByteEncoder subclass:#ISO8859_11
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO8859_11 class methodsFor:'documentation'!

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
    8859-11 - Thai.

    [see with:]
        CharacterEncoderImplementations::ISO8859_11 showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!ISO8859_11 class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'ISO8859/8859-11.TXT'
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/ISO8859/8859-11.TXT

#
#       Name:             ISO/IEC 8859-11:2001 to Unicode
#       Unicode version:  3.2
#       Table version:    1.0
#       Table format:     Format A
#       Date:             2002 October 7
#       Authors:          Ken Whistler <kenw@sybase.com>
#
#       Copyright (c) 2002 Unicode, Inc.  All Rights reserved.
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
#       ISO/IEC 8859-11:2001 characters map into Unicode.
#
#       ISO/IEC 8859-11:2001 is equivalent to TIS 620-2533 (1990) with
#       the addition of 0xA0 NO-BREAK SPACE.
#
#       Format:  Three tab-separated columns
#                Column #1 is the ISO/IEC 8859-11 code (in hex as 0xXX)
#                Column #2 is the Unicode (in hex as 0xXXXX)
#                Column #3 the Unicode name (follows a comment sign, '#')
#
#       The entries are in ISO/IEC 8859-11 order.
#
#       Version history:
#               2002 October 7  Created
#
#       Updated versions of this file may be found in:
#               <ftp://ftp.unicode.org/Public/MAPPINGS/>
#
#       For any comments or problems, please use the Unicode
#       web contact form at:
#               http://www.unicode.org/unicode/reporting.html
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
0xA1    0x0E01  #       THAI CHARACTER KO KAI
0xA2    0x0E02  #       THAI CHARACTER KHO KHAI
0xA3    0x0E03  #       THAI CHARACTER KHO KHUAT
0xA4    0x0E04  #       THAI CHARACTER KHO KHWAI
0xA5    0x0E05  #       THAI CHARACTER KHO KHON
0xA6    0x0E06  #       THAI CHARACTER KHO RAKHANG
0xA7    0x0E07  #       THAI CHARACTER NGO NGU
0xA8    0x0E08  #       THAI CHARACTER CHO CHAN
0xA9    0x0E09  #       THAI CHARACTER CHO CHING
0xAA    0x0E0A  #       THAI CHARACTER CHO CHANG
0xAB    0x0E0B  #       THAI CHARACTER SO SO
0xAC    0x0E0C  #       THAI CHARACTER CHO CHOE
0xAD    0x0E0D  #       THAI CHARACTER YO YING
0xAE    0x0E0E  #       THAI CHARACTER DO CHADA
0xAF    0x0E0F  #       THAI CHARACTER TO PATAK
0xB0    0x0E10  #       THAI CHARACTER THO THAN
0xB1    0x0E11  #       THAI CHARACTER THO NANGMONTHO
0xB2    0x0E12  #       THAI CHARACTER THO PHUTHAO
0xB3    0x0E13  #       THAI CHARACTER NO NEN
0xB4    0x0E14  #       THAI CHARACTER DO DEK
0xB5    0x0E15  #       THAI CHARACTER TO TAO
0xB6    0x0E16  #       THAI CHARACTER THO THUNG
0xB7    0x0E17  #       THAI CHARACTER THO THAHAN
0xB8    0x0E18  #       THAI CHARACTER THO THONG
0xB9    0x0E19  #       THAI CHARACTER NO NU
0xBA    0x0E1A  #       THAI CHARACTER BO BAIMAI
0xBB    0x0E1B  #       THAI CHARACTER PO PLA
0xBC    0x0E1C  #       THAI CHARACTER PHO PHUNG
0xBD    0x0E1D  #       THAI CHARACTER FO FA
0xBE    0x0E1E  #       THAI CHARACTER PHO PHAN
0xBF    0x0E1F  #       THAI CHARACTER FO FAN
0xC0    0x0E20  #       THAI CHARACTER PHO SAMPHAO
0xC1    0x0E21  #       THAI CHARACTER MO MA
0xC2    0x0E22  #       THAI CHARACTER YO YAK
0xC3    0x0E23  #       THAI CHARACTER RO RUA
0xC4    0x0E24  #       THAI CHARACTER RU
0xC5    0x0E25  #       THAI CHARACTER LO LING
0xC6    0x0E26  #       THAI CHARACTER LU
0xC7    0x0E27  #       THAI CHARACTER WO WAEN
0xC8    0x0E28  #       THAI CHARACTER SO SALA
0xC9    0x0E29  #       THAI CHARACTER SO RUSI
0xCA    0x0E2A  #       THAI CHARACTER SO SUA
0xCB    0x0E2B  #       THAI CHARACTER HO HIP
0xCC    0x0E2C  #       THAI CHARACTER LO CHULA
0xCD    0x0E2D  #       THAI CHARACTER O ANG
0xCE    0x0E2E  #       THAI CHARACTER HO NOKHUK
0xCF    0x0E2F  #       THAI CHARACTER PAIYANNOI
0xD0    0x0E30  #       THAI CHARACTER SARA A
0xD1    0x0E31  #       THAI CHARACTER MAI HAN-AKAT
0xD2    0x0E32  #       THAI CHARACTER SARA AA
0xD3    0x0E33  #       THAI CHARACTER SARA AM
0xD4    0x0E34  #       THAI CHARACTER SARA I
0xD5    0x0E35  #       THAI CHARACTER SARA II
0xD6    0x0E36  #       THAI CHARACTER SARA UE
0xD7    0x0E37  #       THAI CHARACTER SARA UEE
0xD8    0x0E38  #       THAI CHARACTER SARA U
0xD9    0x0E39  #       THAI CHARACTER SARA UU
0xDA    0x0E3A  #       THAI CHARACTER PHINTHU
0xDF    0x0E3F  #       THAI CURRENCY SYMBOL BAHT
0xE0    0x0E40  #       THAI CHARACTER SARA E
0xE1    0x0E41  #       THAI CHARACTER SARA AE
0xE2    0x0E42  #       THAI CHARACTER SARA O
0xE3    0x0E43  #       THAI CHARACTER SARA AI MAIMUAN
0xE4    0x0E44  #       THAI CHARACTER SARA AI MAIMALAI
0xE5    0x0E45  #       THAI CHARACTER LAKKHANGYAO
0xE6    0x0E46  #       THAI CHARACTER MAIYAMOK
0xE7    0x0E47  #       THAI CHARACTER MAITAIKHU
0xE8    0x0E48  #       THAI CHARACTER MAI EK
0xE9    0x0E49  #       THAI CHARACTER MAI THO
0xEA    0x0E4A  #       THAI CHARACTER MAI TRI
0xEB    0x0E4B  #       THAI CHARACTER MAI CHATTAWA
0xEC    0x0E4C  #       THAI CHARACTER THANTHAKHAT
0xED    0x0E4D  #       THAI CHARACTER NIKHAHIT
0xEE    0x0E4E  #       THAI CHARACTER YAMAKKAN
0xEF    0x0E4F  #       THAI CHARACTER FONGMAN
0xF0    0x0E50  #       THAI DIGIT ZERO
0xF1    0x0E51  #       THAI DIGIT ONE
0xF2    0x0E52  #       THAI DIGIT TWO
0xF3    0x0E53  #       THAI DIGIT THREE
0xF4    0x0E54  #       THAI DIGIT FOUR
0xF5    0x0E55  #       THAI DIGIT FIVE
0xF6    0x0E56  #       THAI DIGIT SIX
0xF7    0x0E57  #       THAI DIGIT SEVEN
0xF8    0x0E58  #       THAI DIGIT EIGHT
0xF9    0x0E59  #       THAI DIGIT NINE
0xFA    0x0E5A  #       THAI CHARACTER ANGKHANKHU
0xFB    0x0E5B  #       THAI CHARACTER KHOMUT

"
! !

!ISO8859_11 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Thai'
! !

!ISO8859_11 methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16rA0 ifTrue:[ ^ code ].
    code > 16rFB ifTrue:[
	^ self decodingError.
    ].
    [
	|t|
	t := #(
	   "16r00A1"    16r0E01 " THAI CHARACTER KO KAI " 
	   "16r00A2"    16r0E02 " THAI CHARACTER KHO KHAI " 
	   "16r00A3"    16r0E03 " THAI CHARACTER KHO KHUAT " 
	   "16r00A4"    16r0E04 " THAI CHARACTER KHO KHWAI " 
	   "16r00A5"    16r0E05 " THAI CHARACTER KHO KHON " 
	   "16r00A6"    16r0E06 " THAI CHARACTER KHO RAKHANG " 
	   "16r00A7"    16r0E07 " THAI CHARACTER NGO NGU " 
	   "16r00A8"    16r0E08 " THAI CHARACTER CHO CHAN " 
	   "16r00A9"    16r0E09 " THAI CHARACTER CHO CHING " 
	   "16r00AA"    16r0E0A " THAI CHARACTER CHO CHANG " 
	   "16r00AB"    16r0E0B " THAI CHARACTER SO SO " 
	   "16r00AC"    16r0E0C " THAI CHARACTER CHO CHOE " 
	   "16r00AD"    16r0E0D " THAI CHARACTER YO YING " 
	   "16r00AE"    16r0E0E " THAI CHARACTER DO CHADA " 
	   "16r00AF"    16r0E0F " THAI CHARACTER TO PATAK " 
	   "16r00B0"    16r0E10 " THAI CHARACTER THO THAN " 
	   "16r00B1"    16r0E11 " THAI CHARACTER THO NANGMONTHO " 
	   "16r00B2"    16r0E12 " THAI CHARACTER THO PHUTHAO " 
	   "16r00B3"    16r0E13 " THAI CHARACTER NO NEN " 
	   "16r00B4"    16r0E14 " THAI CHARACTER DO DEK " 
	   "16r00B5"    16r0E15 " THAI CHARACTER TO TAO " 
	   "16r00B6"    16r0E16 " THAI CHARACTER THO THUNG " 
	   "16r00B7"    16r0E17 " THAI CHARACTER THO THAHAN " 
	   "16r00B8"    16r0E18 " THAI CHARACTER THO THONG " 
	   "16r00B9"    16r0E19 " THAI CHARACTER NO NU " 
	   "16r00BA"    16r0E1A " THAI CHARACTER BO BAIMAI " 
	   "16r00BB"    16r0E1B " THAI CHARACTER PO PLA " 
	   "16r00BC"    16r0E1C " THAI CHARACTER PHO PHUNG " 
	   "16r00BD"    16r0E1D " THAI CHARACTER FO FA " 
	   "16r00BE"    16r0E1E " THAI CHARACTER PHO PHAN " 
	   "16r00BF"    16r0E1F " THAI CHARACTER FO FAN " 
	   "16r00C0"    16r0E20 " THAI CHARACTER PHO SAMPHAO " 
	   "16r00C1"    16r0E21 " THAI CHARACTER MO MA " 
	   "16r00C2"    16r0E22 " THAI CHARACTER YO YAK " 
	   "16r00C3"    16r0E23 " THAI CHARACTER RO RUA " 
	   "16r00C4"    16r0E24 " THAI CHARACTER RU " 
	   "16r00C5"    16r0E25 " THAI CHARACTER LO LING " 
	   "16r00C6"    16r0E26 " THAI CHARACTER LU " 
	   "16r00C7"    16r0E27 " THAI CHARACTER WO WAEN " 
	   "16r00C8"    16r0E28 " THAI CHARACTER SO SALA " 
	   "16r00C9"    16r0E29 " THAI CHARACTER SO RUSI " 
	   "16r00CA"    16r0E2A " THAI CHARACTER SO SUA " 
	   "16r00CB"    16r0E2B " THAI CHARACTER HO HIP " 
	   "16r00CC"    16r0E2C " THAI CHARACTER LO CHULA " 
	   "16r00CD"    16r0E2D " THAI CHARACTER O ANG " 
	   "16r00CE"    16r0E2E " THAI CHARACTER HO NOKHUK " 
	   "16r00CF"    16r0E2F " THAI CHARACTER PAIYANNOI " 
	   "16r00D0"    16r0E30 " THAI CHARACTER SARA A " 
	   "16r00D1"    16r0E31 " THAI CHARACTER MAI HAN-AKAT " 
	   "16r00D2"    16r0E32 " THAI CHARACTER SARA AA " 
	   "16r00D3"    16r0E33 " THAI CHARACTER SARA AM " 
	   "16r00D4"    16r0E34 " THAI CHARACTER SARA I " 
	   "16r00D5"    16r0E35 " THAI CHARACTER SARA II " 
	   "16r00D6"    16r0E36 " THAI CHARACTER SARA UE " 
	   "16r00D7"    16r0E37 " THAI CHARACTER SARA UEE " 
	   "16r00D8"    16r0E38 " THAI CHARACTER SARA U " 
	   "16r00D9"    16r0E39 " THAI CHARACTER SARA UU " 
	   "16r00DA"    16r0E3A " THAI CHARACTER PHINTHU " 
	   "16r00DB"    16r0000 " invalid " 
	   "16r00DC"    16r0000 " invalid " 
	   "16r00DD"    16r0000 " invalid " 
	   "16r00DE"    16r0000 " invalid " 
	   "16r00DF"    16r0E3F " THAI CURRENCY SYMBOL BAHT " 
	   "16r00E0"    16r0E40 " THAI CHARACTER SARA E " 
	   "16r00E1"    16r0E41 " THAI CHARACTER SARA AE " 
	   "16r00E2"    16r0E42 " THAI CHARACTER SARA O " 
	   "16r00E3"    16r0E43 " THAI CHARACTER SARA AI MAIMUAN " 
	   "16r00E4"    16r0E44 " THAI CHARACTER SARA AI MAIMALAI " 
	   "16r00E5"    16r0E45 " THAI CHARACTER LAKKHANGYAO " 
	   "16r00E6"    16r0E46 " THAI CHARACTER MAIYAMOK " 
	   "16r00E7"    16r0E47 " THAI CHARACTER MAITAIKHU " 
	   "16r00E8"    16r0E48 " THAI CHARACTER MAI EK " 
	   "16r00E9"    16r0E49 " THAI CHARACTER MAI THO " 
	   "16r00EA"    16r0E4A " THAI CHARACTER MAI TRI " 
	   "16r00EB"    16r0E4B " THAI CHARACTER MAI CHATTAWA " 
	   "16r00EC"    16r0E4C " THAI CHARACTER THANTHAKHAT " 
	   "16r00ED"    16r0E4D " THAI CHARACTER NIKHAHIT " 
	   "16r00EE"    16r0E4E " THAI CHARACTER YAMAKKAN " 
	   "16r00EF"    16r0E4F " THAI CHARACTER FONGMAN " 
	   "16r00F0"    16r0E50 " THAI DIGIT ZERO " 
	   "16r00F1"    16r0E51 " THAI DIGIT ONE " 
	   "16r00F2"    16r0E52 " THAI DIGIT TWO " 
	   "16r00F3"    16r0E53 " THAI DIGIT THREE " 
	   "16r00F4"    16r0E54 " THAI DIGIT FOUR " 
	   "16r00F5"    16r0E55 " THAI DIGIT FIVE " 
	   "16r00F6"    16r0E56 " THAI DIGIT SIX " 
	   "16r00F7"    16r0E57 " THAI DIGIT SEVEN " 
	   "16r00F8"    16r0E58 " THAI DIGIT EIGHT " 
	   "16r00F9"    16r0E59 " THAI DIGIT NINE " 
	   "16r00FA"    16r0E5A " THAI CHARACTER ANGKHANKHU " 
	   "16r00FB"    16r0E5B " THAI CHARACTER KHOMUT " 
	   ) at:(code - 16rA0).
	t == 0 ifFalse:[^ t].
	^ self decodingError.
    ] value.
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode <= 16rA0 ifTrue:[ ^ unicode ].
    unicode > 16rE5B ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16rE00 ifTrue:[
	^ self encodingError.
    ].
    [
	|t|
	t := #[
	   "16r0E01"    16rA1 " THAI CHARACTER KO KAI " 
	   "16r0E02"    16rA2 " THAI CHARACTER KHO KHAI " 
	   "16r0E03"    16rA3 " THAI CHARACTER KHO KHUAT " 
	   "16r0E04"    16rA4 " THAI CHARACTER KHO KHWAI " 
	   "16r0E05"    16rA5 " THAI CHARACTER KHO KHON " 
	   "16r0E06"    16rA6 " THAI CHARACTER KHO RAKHANG " 
	   "16r0E07"    16rA7 " THAI CHARACTER NGO NGU " 
	   "16r0E08"    16rA8 " THAI CHARACTER CHO CHAN " 
	   "16r0E09"    16rA9 " THAI CHARACTER CHO CHING " 
	   "16r0E0A"    16rAA " THAI CHARACTER CHO CHANG " 
	   "16r0E0B"    16rAB " THAI CHARACTER SO SO " 
	   "16r0E0C"    16rAC " THAI CHARACTER CHO CHOE " 
	   "16r0E0D"    16rAD " THAI CHARACTER YO YING " 
	   "16r0E0E"    16rAE " THAI CHARACTER DO CHADA " 
	   "16r0E0F"    16rAF " THAI CHARACTER TO PATAK " 
	   "16r0E10"    16rB0 " THAI CHARACTER THO THAN " 
	   "16r0E11"    16rB1 " THAI CHARACTER THO NANGMONTHO " 
	   "16r0E12"    16rB2 " THAI CHARACTER THO PHUTHAO " 
	   "16r0E13"    16rB3 " THAI CHARACTER NO NEN " 
	   "16r0E14"    16rB4 " THAI CHARACTER DO DEK " 
	   "16r0E15"    16rB5 " THAI CHARACTER TO TAO " 
	   "16r0E16"    16rB6 " THAI CHARACTER THO THUNG " 
	   "16r0E17"    16rB7 " THAI CHARACTER THO THAHAN " 
	   "16r0E18"    16rB8 " THAI CHARACTER THO THONG " 
	   "16r0E19"    16rB9 " THAI CHARACTER NO NU " 
	   "16r0E1A"    16rBA " THAI CHARACTER BO BAIMAI " 
	   "16r0E1B"    16rBB " THAI CHARACTER PO PLA " 
	   "16r0E1C"    16rBC " THAI CHARACTER PHO PHUNG " 
	   "16r0E1D"    16rBD " THAI CHARACTER FO FA " 
	   "16r0E1E"    16rBE " THAI CHARACTER PHO PHAN " 
	   "16r0E1F"    16rBF " THAI CHARACTER FO FAN " 
	   "16r0E20"    16rC0 " THAI CHARACTER PHO SAMPHAO " 
	   "16r0E21"    16rC1 " THAI CHARACTER MO MA " 
	   "16r0E22"    16rC2 " THAI CHARACTER YO YAK " 
	   "16r0E23"    16rC3 " THAI CHARACTER RO RUA " 
	   "16r0E24"    16rC4 " THAI CHARACTER RU " 
	   "16r0E25"    16rC5 " THAI CHARACTER LO LING " 
	   "16r0E26"    16rC6 " THAI CHARACTER LU " 
	   "16r0E27"    16rC7 " THAI CHARACTER WO WAEN " 
	   "16r0E28"    16rC8 " THAI CHARACTER SO SALA " 
	   "16r0E29"    16rC9 " THAI CHARACTER SO RUSI " 
	   "16r0E2A"    16rCA " THAI CHARACTER SO SUA " 
	   "16r0E2B"    16rCB " THAI CHARACTER HO HIP " 
	   "16r0E2C"    16rCC " THAI CHARACTER LO CHULA " 
	   "16r0E2D"    16rCD " THAI CHARACTER O ANG " 
	   "16r0E2E"    16rCE " THAI CHARACTER HO NOKHUK " 
	   "16r0E2F"    16rCF " THAI CHARACTER PAIYANNOI " 
	   "16r0E30"    16rD0 " THAI CHARACTER SARA A " 
	   "16r0E31"    16rD1 " THAI CHARACTER MAI HAN-AKAT " 
	   "16r0E32"    16rD2 " THAI CHARACTER SARA AA " 
	   "16r0E33"    16rD3 " THAI CHARACTER SARA AM " 
	   "16r0E34"    16rD4 " THAI CHARACTER SARA I " 
	   "16r0E35"    16rD5 " THAI CHARACTER SARA II " 
	   "16r0E36"    16rD6 " THAI CHARACTER SARA UE " 
	   "16r0E37"    16rD7 " THAI CHARACTER SARA UEE " 
	   "16r0E38"    16rD8 " THAI CHARACTER SARA U " 
	   "16r0E39"    16rD9 " THAI CHARACTER SARA UU " 
	   "16r0E3A"    16rDA " THAI CHARACTER PHINTHU " 
	   "16r0E3B"    16r00 " invalid " 
	   "16r0E3C"    16r00 " invalid " 
	   "16r0E3D"    16r00 " invalid " 
	   "16r0E3E"    16r00 " invalid " 
	   "16r0E3F"    16rDF " THAI CURRENCY SYMBOL BAHT " 
	   "16r0E40"    16rE0 " THAI CHARACTER SARA E " 
	   "16r0E41"    16rE1 " THAI CHARACTER SARA AE " 
	   "16r0E42"    16rE2 " THAI CHARACTER SARA O " 
	   "16r0E43"    16rE3 " THAI CHARACTER SARA AI MAIMUAN " 
	   "16r0E44"    16rE4 " THAI CHARACTER SARA AI MAIMALAI " 
	   "16r0E45"    16rE5 " THAI CHARACTER LAKKHANGYAO " 
	   "16r0E46"    16rE6 " THAI CHARACTER MAIYAMOK " 
	   "16r0E47"    16rE7 " THAI CHARACTER MAITAIKHU " 
	   "16r0E48"    16rE8 " THAI CHARACTER MAI EK " 
	   "16r0E49"    16rE9 " THAI CHARACTER MAI THO " 
	   "16r0E4A"    16rEA " THAI CHARACTER MAI TRI " 
	   "16r0E4B"    16rEB " THAI CHARACTER MAI CHATTAWA " 
	   "16r0E4C"    16rEC " THAI CHARACTER THANTHAKHAT " 
	   "16r0E4D"    16rED " THAI CHARACTER NIKHAHIT " 
	   "16r0E4E"    16rEE " THAI CHARACTER YAMAKKAN " 
	   "16r0E4F"    16rEF " THAI CHARACTER FONGMAN " 
	   "16r0E50"    16rF0 " THAI DIGIT ZERO " 
	   "16r0E51"    16rF1 " THAI DIGIT ONE " 
	   "16r0E52"    16rF2 " THAI DIGIT TWO " 
	   "16r0E53"    16rF3 " THAI DIGIT THREE " 
	   "16r0E54"    16rF4 " THAI DIGIT FOUR " 
	   "16r0E55"    16rF5 " THAI DIGIT FIVE " 
	   "16r0E56"    16rF6 " THAI DIGIT SIX " 
	   "16r0E57"    16rF7 " THAI DIGIT SEVEN " 
	   "16r0E58"    16rF8 " THAI DIGIT EIGHT " 
	   "16r0E59"    16rF9 " THAI DIGIT NINE " 
	   "16r0E5A"    16rFA " THAI CHARACTER ANGKHANKHU " 
	   "16r0E5B"    16rFB " THAI CHARACTER KHOMUT " 
	   ] at:(unicode - 16rE00).
	t == 0 ifFalse:[^ t].
	^ self encodingError
    ] value.
! !

!ISO8859_11 class methodsFor:'documentation'!

version
    ^ '$Id: CharacterEncoderImplementations__ISO8859_11.st 10842 2012-09-07 10:49:18Z vranyj1 $'
!

version_SVN
    ^ '$Id:: CharacterEncoderImplementations__ISO8859_11.st 10842 2012-09-07 10:49:18Z vranyj1                                      $'
! !
