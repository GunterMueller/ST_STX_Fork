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

SingleByteEncoder subclass:#KOI8_R
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!KOI8_R class methodsFor:'documentation'!

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
    I encode/decode KOI8 encoded documents (cyrillic - russia)
"
! !

!KOI8_R class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'VENDORS/MISC/KOI8-R.TXT'
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/VENDORS/MISC/KOI8-R.TXT

#
#       Name:             KOI8-R (RFC1489) to Unicode
#       Unicode version:  3.0
#       Table version:    1.0
#       Table format:     Format A
#       Date:             18 August 1999
#       Authors:          Helmut Richter <richter@lrz.de>
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
#       KOI8-R characters map into Unicode. The underlying document is the
#       mapping described in RFC 1489. No statements are made as to whether
#       this mapping is the same as the mapping defined as 'Code Page 878'
#       with some vendors.
#
#       Format:  Three tab-separated columns
#                Column #1 is the KOI8-R code (in hex as 0xXX)
#                Column #2 is the Unicode (in hex as 0xXXXX)
#                Column #3 the Unicode name (follows a comment sign, '#')
#
#       The entries are in KOI8-R order.
#
#       Version history
#       1.0 version: created.
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
0x80    0x2500  #       BOX DRAWINGS LIGHT HORIZONTAL
0x81    0x2502  #       BOX DRAWINGS LIGHT VERTICAL
0x82    0x250C  #       BOX DRAWINGS LIGHT DOWN AND RIGHT
0x83    0x2510  #       BOX DRAWINGS LIGHT DOWN AND LEFT
0x84    0x2514  #       BOX DRAWINGS LIGHT UP AND RIGHT
0x85    0x2518  #       BOX DRAWINGS LIGHT UP AND LEFT
0x86    0x251C  #       BOX DRAWINGS LIGHT VERTICAL AND RIGHT
0x87    0x2524  #       BOX DRAWINGS LIGHT VERTICAL AND LEFT
0x88    0x252C  #       BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
0x89    0x2534  #       BOX DRAWINGS LIGHT UP AND HORIZONTAL
0x8A    0x253C  #       BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
0x8B    0x2580  #       UPPER HALF BLOCK
0x8C    0x2584  #       LOWER HALF BLOCK
0x8D    0x2588  #       FULL BLOCK
0x8E    0x258C  #       LEFT HALF BLOCK
0x8F    0x2590  #       RIGHT HALF BLOCK
0x90    0x2591  #       LIGHT SHADE
0x91    0x2592  #       MEDIUM SHADE
0x92    0x2593  #       DARK SHADE
0x93    0x2320  #       TOP HALF INTEGRAL
0x94    0x25A0  #       BLACK SQUARE
0x95    0x2219  #       BULLET OPERATOR
0x96    0x221A  #       SQUARE ROOT
0x97    0x2248  #       ALMOST EQUAL TO
0x98    0x2264  #       LESS-THAN OR EQUAL TO
0x99    0x2265  #       GREATER-THAN OR EQUAL TO
0x9A    0x00A0  #       NO-BREAK SPACE
0x9B    0x2321  #       BOTTOM HALF INTEGRAL
0x9C    0x00B0  #       DEGREE SIGN
0x9D    0x00B2  #       SUPERSCRIPT TWO
0x9E    0x00B7  #       MIDDLE DOT
0x9F    0x00F7  #       DIVISION SIGN
0xA0    0x2550  #       BOX DRAWINGS DOUBLE HORIZONTAL
0xA1    0x2551  #       BOX DRAWINGS DOUBLE VERTICAL
0xA2    0x2552  #       BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE
0xA3    0x0451  #       CYRILLIC SMALL LETTER IO
0xA4    0x2553  #       BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE
0xA5    0x2554  #       BOX DRAWINGS DOUBLE DOWN AND RIGHT
0xA6    0x2555  #       BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE
0xA7    0x2556  #       BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE
0xA8    0x2557  #       BOX DRAWINGS DOUBLE DOWN AND LEFT
0xA9    0x2558  #       BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE
0xAA    0x2559  #       BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE
0xAB    0x255A  #       BOX DRAWINGS DOUBLE UP AND RIGHT
0xAC    0x255B  #       BOX DRAWINGS UP SINGLE AND LEFT DOUBLE
0xAD    0x255C  #       BOX DRAWINGS UP DOUBLE AND LEFT SINGLE
0xAE    0x255D  #       BOX DRAWINGS DOUBLE UP AND LEFT
0xAF    0x255E  #       BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE
0xB0    0x255F  #       BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE
0xB1    0x2560  #       BOX DRAWINGS DOUBLE VERTICAL AND RIGHT
0xB2    0x2561  #       BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE
0xB3    0x0401  #       CYRILLIC CAPITAL LETTER IO
0xB4    0x2562  #       BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE
0xB5    0x2563  #       BOX DRAWINGS DOUBLE VERTICAL AND LEFT
0xB6    0x2564  #       BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE
0xB7    0x2565  #       BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE
0xB8    0x2566  #       BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL
0xB9    0x2567  #       BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE
0xBA    0x2568  #       BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE
0xBB    0x2569  #       BOX DRAWINGS DOUBLE UP AND HORIZONTAL
0xBC    0x256A  #       BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE
0xBD    0x256B  #       BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE
0xBE    0x256C  #       BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL
0xBF    0x00A9  #       COPYRIGHT SIGN
0xC0    0x044E  #       CYRILLIC SMALL LETTER YU
0xC1    0x0430  #       CYRILLIC SMALL LETTER A
0xC2    0x0431  #       CYRILLIC SMALL LETTER BE
0xC3    0x0446  #       CYRILLIC SMALL LETTER TSE
0xC4    0x0434  #       CYRILLIC SMALL LETTER DE
0xC5    0x0435  #       CYRILLIC SMALL LETTER IE
0xC6    0x0444  #       CYRILLIC SMALL LETTER EF
0xC7    0x0433  #       CYRILLIC SMALL LETTER GHE
0xC8    0x0445  #       CYRILLIC SMALL LETTER HA
0xC9    0x0438  #       CYRILLIC SMALL LETTER I
0xCA    0x0439  #       CYRILLIC SMALL LETTER SHORT I
0xCB    0x043A  #       CYRILLIC SMALL LETTER KA
0xCC    0x043B  #       CYRILLIC SMALL LETTER EL
0xCD    0x043C  #       CYRILLIC SMALL LETTER EM
0xCE    0x043D  #       CYRILLIC SMALL LETTER EN
0xCF    0x043E  #       CYRILLIC SMALL LETTER O
0xD0    0x043F  #       CYRILLIC SMALL LETTER PE
0xD1    0x044F  #       CYRILLIC SMALL LETTER YA
0xD2    0x0440  #       CYRILLIC SMALL LETTER ER
0xD3    0x0441  #       CYRILLIC SMALL LETTER ES
0xD4    0x0442  #       CYRILLIC SMALL LETTER TE
0xD5    0x0443  #       CYRILLIC SMALL LETTER U
0xD6    0x0436  #       CYRILLIC SMALL LETTER ZHE
0xD7    0x0432  #       CYRILLIC SMALL LETTER VE
0xD8    0x044C  #       CYRILLIC SMALL LETTER SOFT SIGN
0xD9    0x044B  #       CYRILLIC SMALL LETTER YERU
0xDA    0x0437  #       CYRILLIC SMALL LETTER ZE
0xDB    0x0448  #       CYRILLIC SMALL LETTER SHA
0xDC    0x044D  #       CYRILLIC SMALL LETTER E
0xDD    0x0449  #       CYRILLIC SMALL LETTER SHCHA
0xDE    0x0447  #       CYRILLIC SMALL LETTER CHE
0xDF    0x044A  #       CYRILLIC SMALL LETTER HARD SIGN
0xE0    0x042E  #       CYRILLIC CAPITAL LETTER YU
0xE1    0x0410  #       CYRILLIC CAPITAL LETTER A
0xE2    0x0411  #       CYRILLIC CAPITAL LETTER BE
0xE3    0x0426  #       CYRILLIC CAPITAL LETTER TSE
0xE4    0x0414  #       CYRILLIC CAPITAL LETTER DE
0xE5    0x0415  #       CYRILLIC CAPITAL LETTER IE
0xE6    0x0424  #       CYRILLIC CAPITAL LETTER EF
0xE7    0x0413  #       CYRILLIC CAPITAL LETTER GHE
0xE8    0x0425  #       CYRILLIC CAPITAL LETTER HA
0xE9    0x0418  #       CYRILLIC CAPITAL LETTER I
0xEA    0x0419  #       CYRILLIC CAPITAL LETTER SHORT I
0xEB    0x041A  #       CYRILLIC CAPITAL LETTER KA
0xEC    0x041B  #       CYRILLIC CAPITAL LETTER EL
0xED    0x041C  #       CYRILLIC CAPITAL LETTER EM
0xEE    0x041D  #       CYRILLIC CAPITAL LETTER EN
0xEF    0x041E  #       CYRILLIC CAPITAL LETTER O
0xF0    0x041F  #       CYRILLIC CAPITAL LETTER PE
0xF1    0x042F  #       CYRILLIC CAPITAL LETTER YA
0xF2    0x0420  #       CYRILLIC CAPITAL LETTER ER
0xF3    0x0421  #       CYRILLIC CAPITAL LETTER ES
0xF4    0x0422  #       CYRILLIC CAPITAL LETTER TE
0xF5    0x0423  #       CYRILLIC CAPITAL LETTER U
0xF6    0x0416  #       CYRILLIC CAPITAL LETTER ZHE
0xF7    0x0412  #       CYRILLIC CAPITAL LETTER VE
0xF8    0x042C  #       CYRILLIC CAPITAL LETTER SOFT SIGN
0xF9    0x042B  #       CYRILLIC CAPITAL LETTER YERU
0xFA    0x0417  #       CYRILLIC CAPITAL LETTER ZE
0xFB    0x0428  #       CYRILLIC CAPITAL LETTER SHA
0xFC    0x042D  #       CYRILLIC CAPITAL LETTER E
0xFD    0x0429  #       CYRILLIC CAPITAL LETTER SHCHA
0xFE    0x0427  #       CYRILLIC CAPITAL LETTER CHE
0xFF    0x042A  #       CYRILLIC CAPITAL LETTER HARD SIGN

"
! !

!KOI8_R class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Cyrillic'
! !

!KOI8_R methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16r7F ifTrue:[ ^ code ].
    code > 16rFF ifTrue:[
	^ self decodingError.
    ].
    ^ #(
       "16r0080"    16r2500 " BOX DRAWINGS LIGHT HORIZONTAL " 
       "16r0081"    16r2502 " BOX DRAWINGS LIGHT VERTICAL " 
       "16r0082"    16r250C " BOX DRAWINGS LIGHT DOWN AND RIGHT " 
       "16r0083"    16r2510 " BOX DRAWINGS LIGHT DOWN AND LEFT " 
       "16r0084"    16r2514 " BOX DRAWINGS LIGHT UP AND RIGHT " 
       "16r0085"    16r2518 " BOX DRAWINGS LIGHT UP AND LEFT " 
       "16r0086"    16r251C " BOX DRAWINGS LIGHT VERTICAL AND RIGHT " 
       "16r0087"    16r2524 " BOX DRAWINGS LIGHT VERTICAL AND LEFT " 
       "16r0088"    16r252C " BOX DRAWINGS LIGHT DOWN AND HORIZONTAL " 
       "16r0089"    16r2534 " BOX DRAWINGS LIGHT UP AND HORIZONTAL " 
       "16r008A"    16r253C " BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL " 
       "16r008B"    16r2580 " UPPER HALF BLOCK " 
       "16r008C"    16r2584 " LOWER HALF BLOCK " 
       "16r008D"    16r2588 " FULL BLOCK " 
       "16r008E"    16r258C " LEFT HALF BLOCK " 
       "16r008F"    16r2590 " RIGHT HALF BLOCK " 
       "16r0090"    16r2591 " LIGHT SHADE " 
       "16r0091"    16r2592 " MEDIUM SHADE " 
       "16r0092"    16r2593 " DARK SHADE " 
       "16r0093"    16r2320 " TOP HALF INTEGRAL " 
       "16r0094"    16r25A0 " BLACK SQUARE " 
       "16r0095"    16r2219 " BULLET OPERATOR " 
       "16r0096"    16r221A " SQUARE ROOT " 
       "16r0097"    16r2248 " ALMOST EQUAL TO " 
       "16r0098"    16r2264 " LESS-THAN OR EQUAL TO " 
       "16r0099"    16r2265 " GREATER-THAN OR EQUAL TO " 
       "16r009A"    16r00A0 " NO-BREAK SPACE " 
       "16r009B"    16r2321 " BOTTOM HALF INTEGRAL " 
       "16r009C"    16r00B0 " DEGREE SIGN " 
       "16r009D"    16r00B2 " SUPERSCRIPT TWO " 
       "16r009E"    16r00B7 " MIDDLE DOT " 
       "16r009F"    16r00F7 " DIVISION SIGN " 
       "16r00A0"    16r2550 " BOX DRAWINGS DOUBLE HORIZONTAL " 
       "16r00A1"    16r2551 " BOX DRAWINGS DOUBLE VERTICAL " 
       "16r00A2"    16r2552 " BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE " 
       "16r00A3"    16r0451 " CYRILLIC SMALL LETTER IO " 
       "16r00A4"    16r2553 " BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE " 
       "16r00A5"    16r2554 " BOX DRAWINGS DOUBLE DOWN AND RIGHT " 
       "16r00A6"    16r2555 " BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE " 
       "16r00A7"    16r2556 " BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE " 
       "16r00A8"    16r2557 " BOX DRAWINGS DOUBLE DOWN AND LEFT " 
       "16r00A9"    16r2558 " BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE " 
       "16r00AA"    16r2559 " BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE " 
       "16r00AB"    16r255A " BOX DRAWINGS DOUBLE UP AND RIGHT " 
       "16r00AC"    16r255B " BOX DRAWINGS UP SINGLE AND LEFT DOUBLE " 
       "16r00AD"    16r255C " BOX DRAWINGS UP DOUBLE AND LEFT SINGLE " 
       "16r00AE"    16r255D " BOX DRAWINGS DOUBLE UP AND LEFT " 
       "16r00AF"    16r255E " BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE " 
       "16r00B0"    16r255F " BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE " 
       "16r00B1"    16r2560 " BOX DRAWINGS DOUBLE VERTICAL AND RIGHT " 
       "16r00B2"    16r2561 " BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE " 
       "16r00B3"    16r0401 " CYRILLIC CAPITAL LETTER IO " 
       "16r00B4"    16r2562 " BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE " 
       "16r00B5"    16r2563 " BOX DRAWINGS DOUBLE VERTICAL AND LEFT " 
       "16r00B6"    16r2564 " BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE " 
       "16r00B7"    16r2565 " BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE " 
       "16r00B8"    16r2566 " BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL " 
       "16r00B9"    16r2567 " BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE " 
       "16r00BA"    16r2568 " BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE " 
       "16r00BB"    16r2569 " BOX DRAWINGS DOUBLE UP AND HORIZONTAL " 
       "16r00BC"    16r256A " BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE " 
       "16r00BD"    16r256B " BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE " 
       "16r00BE"    16r256C " BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL " 
       "16r00BF"    16r00A9 " COPYRIGHT SIGN " 
       "16r00C0"    16r044E " CYRILLIC SMALL LETTER YU " 
       "16r00C1"    16r0430 " CYRILLIC SMALL LETTER A " 
       "16r00C2"    16r0431 " CYRILLIC SMALL LETTER BE " 
       "16r00C3"    16r0446 " CYRILLIC SMALL LETTER TSE " 
       "16r00C4"    16r0434 " CYRILLIC SMALL LETTER DE " 
       "16r00C5"    16r0435 " CYRILLIC SMALL LETTER IE " 
       "16r00C6"    16r0444 " CYRILLIC SMALL LETTER EF " 
       "16r00C7"    16r0433 " CYRILLIC SMALL LETTER GHE " 
       "16r00C8"    16r0445 " CYRILLIC SMALL LETTER HA " 
       "16r00C9"    16r0438 " CYRILLIC SMALL LETTER I " 
       "16r00CA"    16r0439 " CYRILLIC SMALL LETTER SHORT I " 
       "16r00CB"    16r043A " CYRILLIC SMALL LETTER KA " 
       "16r00CC"    16r043B " CYRILLIC SMALL LETTER EL " 
       "16r00CD"    16r043C " CYRILLIC SMALL LETTER EM " 
       "16r00CE"    16r043D " CYRILLIC SMALL LETTER EN " 
       "16r00CF"    16r043E " CYRILLIC SMALL LETTER O " 
       "16r00D0"    16r043F " CYRILLIC SMALL LETTER PE " 
       "16r00D1"    16r044F " CYRILLIC SMALL LETTER YA " 
       "16r00D2"    16r0440 " CYRILLIC SMALL LETTER ER " 
       "16r00D3"    16r0441 " CYRILLIC SMALL LETTER ES " 
       "16r00D4"    16r0442 " CYRILLIC SMALL LETTER TE " 
       "16r00D5"    16r0443 " CYRILLIC SMALL LETTER U " 
       "16r00D6"    16r0436 " CYRILLIC SMALL LETTER ZHE " 
       "16r00D7"    16r0432 " CYRILLIC SMALL LETTER VE " 
       "16r00D8"    16r044C " CYRILLIC SMALL LETTER SOFT SIGN " 
       "16r00D9"    16r044B " CYRILLIC SMALL LETTER YERU " 
       "16r00DA"    16r0437 " CYRILLIC SMALL LETTER ZE " 
       "16r00DB"    16r0448 " CYRILLIC SMALL LETTER SHA " 
       "16r00DC"    16r044D " CYRILLIC SMALL LETTER E " 
       "16r00DD"    16r0449 " CYRILLIC SMALL LETTER SHCHA " 
       "16r00DE"    16r0447 " CYRILLIC SMALL LETTER CHE " 
       "16r00DF"    16r044A " CYRILLIC SMALL LETTER HARD SIGN " 
       "16r00E0"    16r042E " CYRILLIC CAPITAL LETTER YU " 
       "16r00E1"    16r0410 " CYRILLIC CAPITAL LETTER A " 
       "16r00E2"    16r0411 " CYRILLIC CAPITAL LETTER BE " 
       "16r00E3"    16r0426 " CYRILLIC CAPITAL LETTER TSE " 
       "16r00E4"    16r0414 " CYRILLIC CAPITAL LETTER DE " 
       "16r00E5"    16r0415 " CYRILLIC CAPITAL LETTER IE " 
       "16r00E6"    16r0424 " CYRILLIC CAPITAL LETTER EF " 
       "16r00E7"    16r0413 " CYRILLIC CAPITAL LETTER GHE " 
       "16r00E8"    16r0425 " CYRILLIC CAPITAL LETTER HA " 
       "16r00E9"    16r0418 " CYRILLIC CAPITAL LETTER I " 
       "16r00EA"    16r0419 " CYRILLIC CAPITAL LETTER SHORT I " 
       "16r00EB"    16r041A " CYRILLIC CAPITAL LETTER KA " 
       "16r00EC"    16r041B " CYRILLIC CAPITAL LETTER EL " 
       "16r00ED"    16r041C " CYRILLIC CAPITAL LETTER EM " 
       "16r00EE"    16r041D " CYRILLIC CAPITAL LETTER EN " 
       "16r00EF"    16r041E " CYRILLIC CAPITAL LETTER O " 
       "16r00F0"    16r041F " CYRILLIC CAPITAL LETTER PE " 
       "16r00F1"    16r042F " CYRILLIC CAPITAL LETTER YA " 
       "16r00F2"    16r0420 " CYRILLIC CAPITAL LETTER ER " 
       "16r00F3"    16r0421 " CYRILLIC CAPITAL LETTER ES " 
       "16r00F4"    16r0422 " CYRILLIC CAPITAL LETTER TE " 
       "16r00F5"    16r0423 " CYRILLIC CAPITAL LETTER U " 
       "16r00F6"    16r0416 " CYRILLIC CAPITAL LETTER ZHE " 
       "16r00F7"    16r0412 " CYRILLIC CAPITAL LETTER VE " 
       "16r00F8"    16r042C " CYRILLIC CAPITAL LETTER SOFT SIGN " 
       "16r00F9"    16r042B " CYRILLIC CAPITAL LETTER YERU " 
       "16r00FA"    16r0417 " CYRILLIC CAPITAL LETTER ZE " 
       "16r00FB"    16r0428 " CYRILLIC CAPITAL LETTER SHA " 
       "16r00FC"    16r042D " CYRILLIC CAPITAL LETTER E " 
       "16r00FD"    16r0429 " CYRILLIC CAPITAL LETTER SHCHA " 
       "16r00FE"    16r0427 " CYRILLIC CAPITAL LETTER CHE " 
       "16r00FF"    16r042A " CYRILLIC CAPITAL LETTER HARD SIGN " 
       ) at:(code - 16r7F).
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode <= 16r7F ifTrue:[ ^ unicode ].
    unicode > 16r25A0 ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r9F ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r451 ifTrue:[
	unicode <= 16rF7 ifTrue:[
	    unicode <= 16rB7 ifTrue:[
		[
		    |t|
		    t := #[
		       "16r00A0"    16r9A " NO-BREAK SPACE " 
		       "16r00A1"    16r00 " invalid " 
		       "16r00A2"    16r00 " invalid " 
		       "16r00A3"    16r00 " invalid " 
		       "16r00A4"    16r00 " invalid " 
		       "16r00A5"    16r00 " invalid " 
		       "16r00A6"    16r00 " invalid " 
		       "16r00A7"    16r00 " invalid " 
		       "16r00A8"    16r00 " invalid " 
		       "16r00A9"    16rBF " COPYRIGHT SIGN " 
		       "16r00AA"    16r00 " invalid " 
		       "16r00AB"    16r00 " invalid " 
		       "16r00AC"    16r00 " invalid " 
		       "16r00AD"    16r00 " invalid " 
		       "16r00AE"    16r00 " invalid " 
		       "16r00AF"    16r00 " invalid " 
		       "16r00B0"    16r9C " DEGREE SIGN " 
		       "16r00B1"    16r00 " invalid " 
		       "16r00B2"    16r9D " SUPERSCRIPT TWO " 
		       "16r00B3"    16r00 " invalid " 
		       "16r00B4"    16r00 " invalid " 
		       "16r00B5"    16r00 " invalid " 
		       "16r00B6"    16r00 " invalid " 
		       "16r00B7"    16r9E " MIDDLE DOT " 
		       ] at:(unicode - 16r9F).
		    t == 0 ifFalse:[^ t].
		    ^ self encodingError
		] value.
	    ].
	    unicode <= 16rF6 ifTrue:[
		^ self encodingError.
	    ].
	    ^  "16r00F7" 16r009F " DIVISION SIGN " 
	].
	unicode <= 16r400 ifTrue:[
	    ^ self encodingError.
	].
	[
	    |t|
	    t := #[
	       "16r0401"    16rB3 " CYRILLIC CAPITAL LETTER IO " 
	       "16r0402"    16r00 " invalid " 
	       "16r0403"    16r00 " invalid " 
	       "16r0404"    16r00 " invalid " 
	       "16r0405"    16r00 " invalid " 
	       "16r0406"    16r00 " invalid " 
	       "16r0407"    16r00 " invalid " 
	       "16r0408"    16r00 " invalid " 
	       "16r0409"    16r00 " invalid " 
	       "16r040A"    16r00 " invalid " 
	       "16r040B"    16r00 " invalid " 
	       "16r040C"    16r00 " invalid " 
	       "16r040D"    16r00 " invalid " 
	       "16r040E"    16r00 " invalid " 
	       "16r040F"    16r00 " invalid " 
	       "16r0410"    16rE1 " CYRILLIC CAPITAL LETTER A " 
	       "16r0411"    16rE2 " CYRILLIC CAPITAL LETTER BE " 
	       "16r0412"    16rF7 " CYRILLIC CAPITAL LETTER VE " 
	       "16r0413"    16rE7 " CYRILLIC CAPITAL LETTER GHE " 
	       "16r0414"    16rE4 " CYRILLIC CAPITAL LETTER DE " 
	       "16r0415"    16rE5 " CYRILLIC CAPITAL LETTER IE " 
	       "16r0416"    16rF6 " CYRILLIC CAPITAL LETTER ZHE " 
	       "16r0417"    16rFA " CYRILLIC CAPITAL LETTER ZE " 
	       "16r0418"    16rE9 " CYRILLIC CAPITAL LETTER I " 
	       "16r0419"    16rEA " CYRILLIC CAPITAL LETTER SHORT I " 
	       "16r041A"    16rEB " CYRILLIC CAPITAL LETTER KA " 
	       "16r041B"    16rEC " CYRILLIC CAPITAL LETTER EL " 
	       "16r041C"    16rED " CYRILLIC CAPITAL LETTER EM " 
	       "16r041D"    16rEE " CYRILLIC CAPITAL LETTER EN " 
	       "16r041E"    16rEF " CYRILLIC CAPITAL LETTER O " 
	       "16r041F"    16rF0 " CYRILLIC CAPITAL LETTER PE " 
	       "16r0420"    16rF2 " CYRILLIC CAPITAL LETTER ER " 
	       "16r0421"    16rF3 " CYRILLIC CAPITAL LETTER ES " 
	       "16r0422"    16rF4 " CYRILLIC CAPITAL LETTER TE " 
	       "16r0423"    16rF5 " CYRILLIC CAPITAL LETTER U " 
	       "16r0424"    16rE6 " CYRILLIC CAPITAL LETTER EF " 
	       "16r0425"    16rE8 " CYRILLIC CAPITAL LETTER HA " 
	       "16r0426"    16rE3 " CYRILLIC CAPITAL LETTER TSE " 
	       "16r0427"    16rFE " CYRILLIC CAPITAL LETTER CHE " 
	       "16r0428"    16rFB " CYRILLIC CAPITAL LETTER SHA " 
	       "16r0429"    16rFD " CYRILLIC CAPITAL LETTER SHCHA " 
	       "16r042A"    16rFF " CYRILLIC CAPITAL LETTER HARD SIGN " 
	       "16r042B"    16rF9 " CYRILLIC CAPITAL LETTER YERU " 
	       "16r042C"    16rF8 " CYRILLIC CAPITAL LETTER SOFT SIGN " 
	       "16r042D"    16rFC " CYRILLIC CAPITAL LETTER E " 
	       "16r042E"    16rE0 " CYRILLIC CAPITAL LETTER YU " 
	       "16r042F"    16rF1 " CYRILLIC CAPITAL LETTER YA " 
	       "16r0430"    16rC1 " CYRILLIC SMALL LETTER A " 
	       "16r0431"    16rC2 " CYRILLIC SMALL LETTER BE " 
	       "16r0432"    16rD7 " CYRILLIC SMALL LETTER VE " 
	       "16r0433"    16rC7 " CYRILLIC SMALL LETTER GHE " 
	       "16r0434"    16rC4 " CYRILLIC SMALL LETTER DE " 
	       "16r0435"    16rC5 " CYRILLIC SMALL LETTER IE " 
	       "16r0436"    16rD6 " CYRILLIC SMALL LETTER ZHE " 
	       "16r0437"    16rDA " CYRILLIC SMALL LETTER ZE " 
	       "16r0438"    16rC9 " CYRILLIC SMALL LETTER I " 
	       "16r0439"    16rCA " CYRILLIC SMALL LETTER SHORT I " 
	       "16r043A"    16rCB " CYRILLIC SMALL LETTER KA " 
	       "16r043B"    16rCC " CYRILLIC SMALL LETTER EL " 
	       "16r043C"    16rCD " CYRILLIC SMALL LETTER EM " 
	       "16r043D"    16rCE " CYRILLIC SMALL LETTER EN " 
	       "16r043E"    16rCF " CYRILLIC SMALL LETTER O " 
	       "16r043F"    16rD0 " CYRILLIC SMALL LETTER PE " 
	       "16r0440"    16rD2 " CYRILLIC SMALL LETTER ER " 
	       "16r0441"    16rD3 " CYRILLIC SMALL LETTER ES " 
	       "16r0442"    16rD4 " CYRILLIC SMALL LETTER TE " 
	       "16r0443"    16rD5 " CYRILLIC SMALL LETTER U " 
	       "16r0444"    16rC6 " CYRILLIC SMALL LETTER EF " 
	       "16r0445"    16rC8 " CYRILLIC SMALL LETTER HA " 
	       "16r0446"    16rC3 " CYRILLIC SMALL LETTER TSE " 
	       "16r0447"    16rDE " CYRILLIC SMALL LETTER CHE " 
	       "16r0448"    16rDB " CYRILLIC SMALL LETTER SHA " 
	       "16r0449"    16rDD " CYRILLIC SMALL LETTER SHCHA " 
	       "16r044A"    16rDF " CYRILLIC SMALL LETTER HARD SIGN " 
	       "16r044B"    16rD9 " CYRILLIC SMALL LETTER YERU " 
	       "16r044C"    16rD8 " CYRILLIC SMALL LETTER SOFT SIGN " 
	       "16r044D"    16rDC " CYRILLIC SMALL LETTER E " 
	       "16r044E"    16rC0 " CYRILLIC SMALL LETTER YU " 
	       "16r044F"    16rD1 " CYRILLIC SMALL LETTER YA " 
	       "16r0450"    16r00 " invalid " 
	       "16r0451"    16rA3 " CYRILLIC SMALL LETTER IO " 
	       ] at:(unicode - 16r400).
	    t == 0 ifFalse:[^ t].
	    ^ self encodingError
	] value.
    ].
    unicode <= 16r2218 ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r2321 ifTrue:[
	unicode <= 16r2265 ifTrue:[
	    unicode <= 16r221A ifTrue:[
		^ #[
		   "16r2219"    16r95 " BULLET OPERATOR " 
		   "16r221A"    16r96 " SQUARE ROOT " 
		   ] at:(unicode - 16r2218).
	    ].
	    unicode <= 16r2247 ifTrue:[
		^ self encodingError.
	    ].
	    unicode == 16r2248 ifTrue:[
		^  "16r2248" 16r0097 " ALMOST EQUAL TO " 
	    ].
	    unicode <= 16r2263 ifTrue:[
		^ self encodingError.
	    ].
	    ^ #[
	       "16r2264"    16r98 " LESS-THAN OR EQUAL TO " 
	       "16r2265"    16r99 " GREATER-THAN OR EQUAL TO " 
	       ] at:(unicode - 16r2263).
	].
	unicode <= 16r231F ifTrue:[
	    ^ self encodingError.
	].
	^ #[
	   "16r2320"    16r93 " TOP HALF INTEGRAL " 
	   "16r2321"    16r9B " BOTTOM HALF INTEGRAL " 
	   ] at:(unicode - 16r231F).
    ].
    unicode <= 16r24FF ifTrue:[
	^ self encodingError.
    ].
    [
	|t|
	t := #[
	   "16r2500"    16r80 " BOX DRAWINGS LIGHT HORIZONTAL " 
	   "16r2501"    16r00 " invalid " 
	   "16r2502"    16r81 " BOX DRAWINGS LIGHT VERTICAL " 
	   "16r2503"    16r00 " invalid " 
	   "16r2504"    16r00 " invalid " 
	   "16r2505"    16r00 " invalid " 
	   "16r2506"    16r00 " invalid " 
	   "16r2507"    16r00 " invalid " 
	   "16r2508"    16r00 " invalid " 
	   "16r2509"    16r00 " invalid " 
	   "16r250A"    16r00 " invalid " 
	   "16r250B"    16r00 " invalid " 
	   "16r250C"    16r82 " BOX DRAWINGS LIGHT DOWN AND RIGHT " 
	   "16r250D"    16r00 " invalid " 
	   "16r250E"    16r00 " invalid " 
	   "16r250F"    16r00 " invalid " 
	   "16r2510"    16r83 " BOX DRAWINGS LIGHT DOWN AND LEFT " 
	   "16r2511"    16r00 " invalid " 
	   "16r2512"    16r00 " invalid " 
	   "16r2513"    16r00 " invalid " 
	   "16r2514"    16r84 " BOX DRAWINGS LIGHT UP AND RIGHT " 
	   "16r2515"    16r00 " invalid " 
	   "16r2516"    16r00 " invalid " 
	   "16r2517"    16r00 " invalid " 
	   "16r2518"    16r85 " BOX DRAWINGS LIGHT UP AND LEFT " 
	   "16r2519"    16r00 " invalid " 
	   "16r251A"    16r00 " invalid " 
	   "16r251B"    16r00 " invalid " 
	   "16r251C"    16r86 " BOX DRAWINGS LIGHT VERTICAL AND RIGHT " 
	   "16r251D"    16r00 " invalid " 
	   "16r251E"    16r00 " invalid " 
	   "16r251F"    16r00 " invalid " 
	   "16r2520"    16r00 " invalid " 
	   "16r2521"    16r00 " invalid " 
	   "16r2522"    16r00 " invalid " 
	   "16r2523"    16r00 " invalid " 
	   "16r2524"    16r87 " BOX DRAWINGS LIGHT VERTICAL AND LEFT " 
	   "16r2525"    16r00 " invalid " 
	   "16r2526"    16r00 " invalid " 
	   "16r2527"    16r00 " invalid " 
	   "16r2528"    16r00 " invalid " 
	   "16r2529"    16r00 " invalid " 
	   "16r252A"    16r00 " invalid " 
	   "16r252B"    16r00 " invalid " 
	   "16r252C"    16r88 " BOX DRAWINGS LIGHT DOWN AND HORIZONTAL " 
	   "16r252D"    16r00 " invalid " 
	   "16r252E"    16r00 " invalid " 
	   "16r252F"    16r00 " invalid " 
	   "16r2530"    16r00 " invalid " 
	   "16r2531"    16r00 " invalid " 
	   "16r2532"    16r00 " invalid " 
	   "16r2533"    16r00 " invalid " 
	   "16r2534"    16r89 " BOX DRAWINGS LIGHT UP AND HORIZONTAL " 
	   "16r2535"    16r00 " invalid " 
	   "16r2536"    16r00 " invalid " 
	   "16r2537"    16r00 " invalid " 
	   "16r2538"    16r00 " invalid " 
	   "16r2539"    16r00 " invalid " 
	   "16r253A"    16r00 " invalid " 
	   "16r253B"    16r00 " invalid " 
	   "16r253C"    16r8A " BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL " 
	   "16r253D"    16r00 " invalid " 
	   "16r253E"    16r00 " invalid " 
	   "16r253F"    16r00 " invalid " 
	   "16r2540"    16r00 " invalid " 
	   "16r2541"    16r00 " invalid " 
	   "16r2542"    16r00 " invalid " 
	   "16r2543"    16r00 " invalid " 
	   "16r2544"    16r00 " invalid " 
	   "16r2545"    16r00 " invalid " 
	   "16r2546"    16r00 " invalid " 
	   "16r2547"    16r00 " invalid " 
	   "16r2548"    16r00 " invalid " 
	   "16r2549"    16r00 " invalid " 
	   "16r254A"    16r00 " invalid " 
	   "16r254B"    16r00 " invalid " 
	   "16r254C"    16r00 " invalid " 
	   "16r254D"    16r00 " invalid " 
	   "16r254E"    16r00 " invalid " 
	   "16r254F"    16r00 " invalid " 
	   "16r2550"    16rA0 " BOX DRAWINGS DOUBLE HORIZONTAL " 
	   "16r2551"    16rA1 " BOX DRAWINGS DOUBLE VERTICAL " 
	   "16r2552"    16rA2 " BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE " 
	   "16r2553"    16rA4 " BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE " 
	   "16r2554"    16rA5 " BOX DRAWINGS DOUBLE DOWN AND RIGHT " 
	   "16r2555"    16rA6 " BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE " 
	   "16r2556"    16rA7 " BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE " 
	   "16r2557"    16rA8 " BOX DRAWINGS DOUBLE DOWN AND LEFT " 
	   "16r2558"    16rA9 " BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE " 
	   "16r2559"    16rAA " BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE " 
	   "16r255A"    16rAB " BOX DRAWINGS DOUBLE UP AND RIGHT " 
	   "16r255B"    16rAC " BOX DRAWINGS UP SINGLE AND LEFT DOUBLE " 
	   "16r255C"    16rAD " BOX DRAWINGS UP DOUBLE AND LEFT SINGLE " 
	   "16r255D"    16rAE " BOX DRAWINGS DOUBLE UP AND LEFT " 
	   "16r255E"    16rAF " BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE " 
	   "16r255F"    16rB0 " BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE " 
	   "16r2560"    16rB1 " BOX DRAWINGS DOUBLE VERTICAL AND RIGHT " 
	   "16r2561"    16rB2 " BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE " 
	   "16r2562"    16rB4 " BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE " 
	   "16r2563"    16rB5 " BOX DRAWINGS DOUBLE VERTICAL AND LEFT " 
	   "16r2564"    16rB6 " BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE " 
	   "16r2565"    16rB7 " BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE " 
	   "16r2566"    16rB8 " BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL " 
	   "16r2567"    16rB9 " BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE " 
	   "16r2568"    16rBA " BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE " 
	   "16r2569"    16rBB " BOX DRAWINGS DOUBLE UP AND HORIZONTAL " 
	   "16r256A"    16rBC " BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE " 
	   "16r256B"    16rBD " BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE " 
	   "16r256C"    16rBE " BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL " 
	   "16r256D"    16r00 " invalid " 
	   "16r256E"    16r00 " invalid " 
	   "16r256F"    16r00 " invalid " 
	   "16r2570"    16r00 " invalid " 
	   "16r2571"    16r00 " invalid " 
	   "16r2572"    16r00 " invalid " 
	   "16r2573"    16r00 " invalid " 
	   "16r2574"    16r00 " invalid " 
	   "16r2575"    16r00 " invalid " 
	   "16r2576"    16r00 " invalid " 
	   "16r2577"    16r00 " invalid " 
	   "16r2578"    16r00 " invalid " 
	   "16r2579"    16r00 " invalid " 
	   "16r257A"    16r00 " invalid " 
	   "16r257B"    16r00 " invalid " 
	   "16r257C"    16r00 " invalid " 
	   "16r257D"    16r00 " invalid " 
	   "16r257E"    16r00 " invalid " 
	   "16r257F"    16r00 " invalid " 
	   "16r2580"    16r8B " UPPER HALF BLOCK " 
	   "16r2581"    16r00 " invalid " 
	   "16r2582"    16r00 " invalid " 
	   "16r2583"    16r00 " invalid " 
	   "16r2584"    16r8C " LOWER HALF BLOCK " 
	   "16r2585"    16r00 " invalid " 
	   "16r2586"    16r00 " invalid " 
	   "16r2587"    16r00 " invalid " 
	   "16r2588"    16r8D " FULL BLOCK " 
	   "16r2589"    16r00 " invalid " 
	   "16r258A"    16r00 " invalid " 
	   "16r258B"    16r00 " invalid " 
	   "16r258C"    16r8E " LEFT HALF BLOCK " 
	   "16r258D"    16r00 " invalid " 
	   "16r258E"    16r00 " invalid " 
	   "16r258F"    16r00 " invalid " 
	   "16r2590"    16r8F " RIGHT HALF BLOCK " 
	   "16r2591"    16r90 " LIGHT SHADE " 
	   "16r2592"    16r91 " MEDIUM SHADE " 
	   "16r2593"    16r92 " DARK SHADE " 
	   "16r2594"    16r00 " invalid " 
	   "16r2595"    16r00 " invalid " 
	   "16r2596"    16r00 " invalid " 
	   "16r2597"    16r00 " invalid " 
	   "16r2598"    16r00 " invalid " 
	   "16r2599"    16r00 " invalid " 
	   "16r259A"    16r00 " invalid " 
	   "16r259B"    16r00 " invalid " 
	   "16r259C"    16r00 " invalid " 
	   "16r259D"    16r00 " invalid " 
	   "16r259E"    16r00 " invalid " 
	   "16r259F"    16r00 " invalid " 
	   "16r25A0"    16r94 " BLACK SQUARE " 
	   ] at:(unicode - 16r24FF).
	t == 0 ifFalse:[^ t].
	^ self encodingError
    ] value.
! !

!KOI8_R class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

