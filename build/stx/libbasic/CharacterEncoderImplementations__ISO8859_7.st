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

SingleByteEncoder subclass:#ISO8859_7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO8859_7 class methodsFor:'documentation'!

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
    8859-7 - Greek.

    [see with:]
        CharacterEncoderImplementations::ISO8859_7 showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!ISO8859_7 class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'ISO8859/8859-7.TXT'
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/ISO8859/8859-7.TXT

#
#       Name:             ISO 8859-7:2003 to Unicode
#       Unicode version:  4.0
#       Table version:    2.0
#       Table format:     Format A
#       Date:             2003-Nov-12
#       Authors:          Ken Whistler <kenw@sybase.com>
#
#       Copyright (c) 1991-2003 Unicode, Inc.  All Rights reserved.
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
#       ISO 8859-7:2003 characters map into Unicode.
#
#       ISO 8859-7:1987 is equivalent to ISO-IR-126, ELOT 928,
#       and ECMA 118. ISO 8859-7:2003 adds two currency signs 
#       and one other character not in the earlier standard.
#
#       Format:  Three tab-separated columns
#                Column #1 is the ISO 8859-7 code (in hex as 0xXX)
#                Column #2 is the Unicode (in hex as 0xXXXX)
#                Column #3 the Unicode name (follows a comment sign, '#')
#
#       The entries are in ISO 8859-7 order.
#
#       Version history
#       1.0 version updates 0.1 version by adding mappings for all
#       control characters.
#       Remap 0xA1 to U+2018 (instead of 0x02BD) to match text of 8859-7
#       Remap 0xA2 to U+2019 (instead of 0x02BC) to match text of 8859-7
#
#       2.0 version updates 1.0 version by adding mappings for the
#       three newly added characters 0xA4, 0xA5, 0xAA.
#
#       Updated versions of this file may be found in:
#               <http://www.unicode.org/Public/MAPPINGS/>
#
#       Any comments or problems, contact the Unicode Consortium at:
#               <http://www.unicode.org/reporting.html>
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
0xA1    0x2018  #       LEFT SINGLE QUOTATION MARK
0xA2    0x2019  #       RIGHT SINGLE QUOTATION MARK
0xA3    0x00A3  #       POUND SIGN
0xA4    0x20AC  #       EURO SIGN
0xA5    0x20AF  #       DRACHMA SIGN
0xA6    0x00A6  #       BROKEN BAR
0xA7    0x00A7  #       SECTION SIGN
0xA8    0x00A8  #       DIAERESIS
0xA9    0x00A9  #       COPYRIGHT SIGN
0xAA    0x037A  #       GREEK YPOGEGRAMMENI
0xAB    0x00AB  #       LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
0xAC    0x00AC  #       NOT SIGN
0xAD    0x00AD  #       SOFT HYPHEN
0xAF    0x2015  #       HORIZONTAL BAR
0xB0    0x00B0  #       DEGREE SIGN
0xB1    0x00B1  #       PLUS-MINUS SIGN
0xB2    0x00B2  #       SUPERSCRIPT TWO
0xB3    0x00B3  #       SUPERSCRIPT THREE
0xB4    0x0384  #       GREEK TONOS
0xB5    0x0385  #       GREEK DIALYTIKA TONOS
0xB6    0x0386  #       GREEK CAPITAL LETTER ALPHA WITH TONOS
0xB7    0x00B7  #       MIDDLE DOT
0xB8    0x0388  #       GREEK CAPITAL LETTER EPSILON WITH TONOS
0xB9    0x0389  #       GREEK CAPITAL LETTER ETA WITH TONOS
0xBA    0x038A  #       GREEK CAPITAL LETTER IOTA WITH TONOS
0xBB    0x00BB  #       RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
0xBC    0x038C  #       GREEK CAPITAL LETTER OMICRON WITH TONOS
0xBD    0x00BD  #       VULGAR FRACTION ONE HALF
0xBE    0x038E  #       GREEK CAPITAL LETTER UPSILON WITH TONOS
0xBF    0x038F  #       GREEK CAPITAL LETTER OMEGA WITH TONOS
0xC0    0x0390  #       GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
0xC1    0x0391  #       GREEK CAPITAL LETTER ALPHA
0xC2    0x0392  #       GREEK CAPITAL LETTER BETA
0xC3    0x0393  #       GREEK CAPITAL LETTER GAMMA
0xC4    0x0394  #       GREEK CAPITAL LETTER DELTA
0xC5    0x0395  #       GREEK CAPITAL LETTER EPSILON
0xC6    0x0396  #       GREEK CAPITAL LETTER ZETA
0xC7    0x0397  #       GREEK CAPITAL LETTER ETA
0xC8    0x0398  #       GREEK CAPITAL LETTER THETA
0xC9    0x0399  #       GREEK CAPITAL LETTER IOTA
0xCA    0x039A  #       GREEK CAPITAL LETTER KAPPA
0xCB    0x039B  #       GREEK CAPITAL LETTER LAMDA
0xCC    0x039C  #       GREEK CAPITAL LETTER MU
0xCD    0x039D  #       GREEK CAPITAL LETTER NU
0xCE    0x039E  #       GREEK CAPITAL LETTER XI
0xCF    0x039F  #       GREEK CAPITAL LETTER OMICRON
0xD0    0x03A0  #       GREEK CAPITAL LETTER PI
0xD1    0x03A1  #       GREEK CAPITAL LETTER RHO
0xD3    0x03A3  #       GREEK CAPITAL LETTER SIGMA
0xD4    0x03A4  #       GREEK CAPITAL LETTER TAU
0xD5    0x03A5  #       GREEK CAPITAL LETTER UPSILON
0xD6    0x03A6  #       GREEK CAPITAL LETTER PHI
0xD7    0x03A7  #       GREEK CAPITAL LETTER CHI
0xD8    0x03A8  #       GREEK CAPITAL LETTER PSI
0xD9    0x03A9  #       GREEK CAPITAL LETTER OMEGA
0xDA    0x03AA  #       GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
0xDB    0x03AB  #       GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
0xDC    0x03AC  #       GREEK SMALL LETTER ALPHA WITH TONOS
0xDD    0x03AD  #       GREEK SMALL LETTER EPSILON WITH TONOS
0xDE    0x03AE  #       GREEK SMALL LETTER ETA WITH TONOS
0xDF    0x03AF  #       GREEK SMALL LETTER IOTA WITH TONOS
0xE0    0x03B0  #       GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
0xE1    0x03B1  #       GREEK SMALL LETTER ALPHA
0xE2    0x03B2  #       GREEK SMALL LETTER BETA
0xE3    0x03B3  #       GREEK SMALL LETTER GAMMA
0xE4    0x03B4  #       GREEK SMALL LETTER DELTA
0xE5    0x03B5  #       GREEK SMALL LETTER EPSILON
0xE6    0x03B6  #       GREEK SMALL LETTER ZETA
0xE7    0x03B7  #       GREEK SMALL LETTER ETA
0xE8    0x03B8  #       GREEK SMALL LETTER THETA
0xE9    0x03B9  #       GREEK SMALL LETTER IOTA
0xEA    0x03BA  #       GREEK SMALL LETTER KAPPA
0xEB    0x03BB  #       GREEK SMALL LETTER LAMDA
0xEC    0x03BC  #       GREEK SMALL LETTER MU
0xED    0x03BD  #       GREEK SMALL LETTER NU
0xEE    0x03BE  #       GREEK SMALL LETTER XI
0xEF    0x03BF  #       GREEK SMALL LETTER OMICRON
0xF0    0x03C0  #       GREEK SMALL LETTER PI
0xF1    0x03C1  #       GREEK SMALL LETTER RHO
0xF2    0x03C2  #       GREEK SMALL LETTER FINAL SIGMA
0xF3    0x03C3  #       GREEK SMALL LETTER SIGMA
0xF4    0x03C4  #       GREEK SMALL LETTER TAU
0xF5    0x03C5  #       GREEK SMALL LETTER UPSILON
0xF6    0x03C6  #       GREEK SMALL LETTER PHI
0xF7    0x03C7  #       GREEK SMALL LETTER CHI
0xF8    0x03C8  #       GREEK SMALL LETTER PSI
0xF9    0x03C9  #       GREEK SMALL LETTER OMEGA
0xFA    0x03CA  #       GREEK SMALL LETTER IOTA WITH DIALYTIKA
0xFB    0x03CB  #       GREEK SMALL LETTER UPSILON WITH DIALYTIKA
0xFC    0x03CC  #       GREEK SMALL LETTER OMICRON WITH TONOS
0xFD    0x03CD  #       GREEK SMALL LETTER UPSILON WITH TONOS
0xFE    0x03CE  #       GREEK SMALL LETTER OMEGA WITH TONOS

"
! !

!ISO8859_7 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Greek'
! !

!ISO8859_7 methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16rA0 ifTrue:[ ^ code ].
    code > 16rFE ifTrue:[
	^ self decodingError.
    ].
    [
	|t|
	t := #(
	   "16r00A1"    16r2018 " LEFT SINGLE QUOTATION MARK " 
	   "16r00A2"    16r2019 " RIGHT SINGLE QUOTATION MARK " 
	   "16r00A3"    16r00A3 " POUND SIGN " 
	   "16r00A4"    16r20AC " EURO SIGN " 
	   "16r00A5"    16r20AF " DRACHMA SIGN " 
	   "16r00A6"    16r00A6 " BROKEN BAR " 
	   "16r00A7"    16r00A7 " SECTION SIGN " 
	   "16r00A8"    16r00A8 " DIAERESIS " 
	   "16r00A9"    16r00A9 " COPYRIGHT SIGN " 
	   "16r00AA"    16r037A " GREEK YPOGEGRAMMENI " 
	   "16r00AB"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
	   "16r00AC"    16r00AC " NOT SIGN " 
	   "16r00AD"    16r00AD " SOFT HYPHEN " 
	   "16r00AE"    16r0000 " invalid " 
	   "16r00AF"    16r2015 " HORIZONTAL BAR " 
	   "16r00B0"    16r00B0 " DEGREE SIGN " 
	   "16r00B1"    16r00B1 " PLUS-MINUS SIGN " 
	   "16r00B2"    16r00B2 " SUPERSCRIPT TWO " 
	   "16r00B3"    16r00B3 " SUPERSCRIPT THREE " 
	   "16r00B4"    16r0384 " GREEK TONOS " 
	   "16r00B5"    16r0385 " GREEK DIALYTIKA TONOS " 
	   "16r00B6"    16r0386 " GREEK CAPITAL LETTER ALPHA WITH TONOS " 
	   "16r00B7"    16r00B7 " MIDDLE DOT " 
	   "16r00B8"    16r0388 " GREEK CAPITAL LETTER EPSILON WITH TONOS " 
	   "16r00B9"    16r0389 " GREEK CAPITAL LETTER ETA WITH TONOS " 
	   "16r00BA"    16r038A " GREEK CAPITAL LETTER IOTA WITH TONOS " 
	   "16r00BB"    16r00BB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
	   "16r00BC"    16r038C " GREEK CAPITAL LETTER OMICRON WITH TONOS " 
	   "16r00BD"    16r00BD " VULGAR FRACTION ONE HALF " 
	   "16r00BE"    16r038E " GREEK CAPITAL LETTER UPSILON WITH TONOS " 
	   "16r00BF"    16r038F " GREEK CAPITAL LETTER OMEGA WITH TONOS " 
	   "16r00C0"    16r0390 " GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS " 
	   "16r00C1"    16r0391 " GREEK CAPITAL LETTER ALPHA " 
	   "16r00C2"    16r0392 " GREEK CAPITAL LETTER BETA " 
	   "16r00C3"    16r0393 " GREEK CAPITAL LETTER GAMMA " 
	   "16r00C4"    16r0394 " GREEK CAPITAL LETTER DELTA " 
	   "16r00C5"    16r0395 " GREEK CAPITAL LETTER EPSILON " 
	   "16r00C6"    16r0396 " GREEK CAPITAL LETTER ZETA " 
	   "16r00C7"    16r0397 " GREEK CAPITAL LETTER ETA " 
	   "16r00C8"    16r0398 " GREEK CAPITAL LETTER THETA " 
	   "16r00C9"    16r0399 " GREEK CAPITAL LETTER IOTA " 
	   "16r00CA"    16r039A " GREEK CAPITAL LETTER KAPPA " 
	   "16r00CB"    16r039B " GREEK CAPITAL LETTER LAMDA " 
	   "16r00CC"    16r039C " GREEK CAPITAL LETTER MU " 
	   "16r00CD"    16r039D " GREEK CAPITAL LETTER NU " 
	   "16r00CE"    16r039E " GREEK CAPITAL LETTER XI " 
	   "16r00CF"    16r039F " GREEK CAPITAL LETTER OMICRON " 
	   "16r00D0"    16r03A0 " GREEK CAPITAL LETTER PI " 
	   "16r00D1"    16r03A1 " GREEK CAPITAL LETTER RHO " 
	   "16r00D2"    16r0000 " invalid " 
	   "16r00D3"    16r03A3 " GREEK CAPITAL LETTER SIGMA " 
	   "16r00D4"    16r03A4 " GREEK CAPITAL LETTER TAU " 
	   "16r00D5"    16r03A5 " GREEK CAPITAL LETTER UPSILON " 
	   "16r00D6"    16r03A6 " GREEK CAPITAL LETTER PHI " 
	   "16r00D7"    16r03A7 " GREEK CAPITAL LETTER CHI " 
	   "16r00D8"    16r03A8 " GREEK CAPITAL LETTER PSI " 
	   "16r00D9"    16r03A9 " GREEK CAPITAL LETTER OMEGA " 
	   "16r00DA"    16r03AA " GREEK CAPITAL LETTER IOTA WITH DIALYTIKA " 
	   "16r00DB"    16r03AB " GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA " 
	   "16r00DC"    16r03AC " GREEK SMALL LETTER ALPHA WITH TONOS " 
	   "16r00DD"    16r03AD " GREEK SMALL LETTER EPSILON WITH TONOS " 
	   "16r00DE"    16r03AE " GREEK SMALL LETTER ETA WITH TONOS " 
	   "16r00DF"    16r03AF " GREEK SMALL LETTER IOTA WITH TONOS " 
	   "16r00E0"    16r03B0 " GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS " 
	   "16r00E1"    16r03B1 " GREEK SMALL LETTER ALPHA " 
	   "16r00E2"    16r03B2 " GREEK SMALL LETTER BETA " 
	   "16r00E3"    16r03B3 " GREEK SMALL LETTER GAMMA " 
	   "16r00E4"    16r03B4 " GREEK SMALL LETTER DELTA " 
	   "16r00E5"    16r03B5 " GREEK SMALL LETTER EPSILON " 
	   "16r00E6"    16r03B6 " GREEK SMALL LETTER ZETA " 
	   "16r00E7"    16r03B7 " GREEK SMALL LETTER ETA " 
	   "16r00E8"    16r03B8 " GREEK SMALL LETTER THETA " 
	   "16r00E9"    16r03B9 " GREEK SMALL LETTER IOTA " 
	   "16r00EA"    16r03BA " GREEK SMALL LETTER KAPPA " 
	   "16r00EB"    16r03BB " GREEK SMALL LETTER LAMDA " 
	   "16r00EC"    16r03BC " GREEK SMALL LETTER MU " 
	   "16r00ED"    16r03BD " GREEK SMALL LETTER NU " 
	   "16r00EE"    16r03BE " GREEK SMALL LETTER XI " 
	   "16r00EF"    16r03BF " GREEK SMALL LETTER OMICRON " 
	   "16r00F0"    16r03C0 " GREEK SMALL LETTER PI " 
	   "16r00F1"    16r03C1 " GREEK SMALL LETTER RHO " 
	   "16r00F2"    16r03C2 " GREEK SMALL LETTER FINAL SIGMA " 
	   "16r00F3"    16r03C3 " GREEK SMALL LETTER SIGMA " 
	   "16r00F4"    16r03C4 " GREEK SMALL LETTER TAU " 
	   "16r00F5"    16r03C5 " GREEK SMALL LETTER UPSILON " 
	   "16r00F6"    16r03C6 " GREEK SMALL LETTER PHI " 
	   "16r00F7"    16r03C7 " GREEK SMALL LETTER CHI " 
	   "16r00F8"    16r03C8 " GREEK SMALL LETTER PSI " 
	   "16r00F9"    16r03C9 " GREEK SMALL LETTER OMEGA " 
	   "16r00FA"    16r03CA " GREEK SMALL LETTER IOTA WITH DIALYTIKA " 
	   "16r00FB"    16r03CB " GREEK SMALL LETTER UPSILON WITH DIALYTIKA " 
	   "16r00FC"    16r03CC " GREEK SMALL LETTER OMICRON WITH TONOS " 
	   "16r00FD"    16r03CD " GREEK SMALL LETTER UPSILON WITH TONOS " 
	   "16r00FE"    16r03CE " GREEK SMALL LETTER OMEGA WITH TONOS " 
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
    unicode > 16r20AF ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r3CE ifTrue:[
	unicode <= 16rBD ifTrue:[
	    [
		|t|
		t := #[
		   "16r00A1"    16r00 " invalid " 
		   "16r00A2"    16r00 " invalid " 
		   "16r00A3"    16rA3 " POUND SIGN " 
		   "16r00A4"    16r00 " invalid " 
		   "16r00A5"    16r00 " invalid " 
		   "16r00A6"    16rA6 " BROKEN BAR " 
		   "16r00A7"    16rA7 " SECTION SIGN " 
		   "16r00A8"    16rA8 " DIAERESIS " 
		   "16r00A9"    16rA9 " COPYRIGHT SIGN " 
		   "16r00AA"    16r00 " invalid " 
		   "16r00AB"    16rAB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
		   "16r00AC"    16rAC " NOT SIGN " 
		   "16r00AD"    16rAD " SOFT HYPHEN " 
		   "16r00AE"    16r00 " invalid " 
		   "16r00AF"    16r00 " invalid " 
		   "16r00B0"    16rB0 " DEGREE SIGN " 
		   "16r00B1"    16rB1 " PLUS-MINUS SIGN " 
		   "16r00B2"    16rB2 " SUPERSCRIPT TWO " 
		   "16r00B3"    16rB3 " SUPERSCRIPT THREE " 
		   "16r00B4"    16r00 " invalid " 
		   "16r00B5"    16r00 " invalid " 
		   "16r00B6"    16r00 " invalid " 
		   "16r00B7"    16rB7 " MIDDLE DOT " 
		   "16r00B8"    16r00 " invalid " 
		   "16r00B9"    16r00 " invalid " 
		   "16r00BA"    16r00 " invalid " 
		   "16r00BB"    16rBB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
		   "16r00BC"    16r00 " invalid " 
		   "16r00BD"    16rBD " VULGAR FRACTION ONE HALF " 
		   ] at:(unicode - 16rA0).
		t == 0 ifFalse:[^ t].
		^ self encodingError
	    ] value.
	].
	unicode <= 16r379 ifTrue:[
	    ^ self encodingError.
	].
	[
	    |t|
	    t := #[
	       "16r037A"    16rAA " GREEK YPOGEGRAMMENI " 
	       "16r037B"    16r00 " invalid " 
	       "16r037C"    16r00 " invalid " 
	       "16r037D"    16r00 " invalid " 
	       "16r037E"    16r00 " invalid " 
	       "16r037F"    16r00 " invalid " 
	       "16r0380"    16r00 " invalid " 
	       "16r0381"    16r00 " invalid " 
	       "16r0382"    16r00 " invalid " 
	       "16r0383"    16r00 " invalid " 
	       "16r0384"    16rB4 " GREEK TONOS " 
	       "16r0385"    16rB5 " GREEK DIALYTIKA TONOS " 
	       "16r0386"    16rB6 " GREEK CAPITAL LETTER ALPHA WITH TONOS " 
	       "16r0387"    16r00 " invalid " 
	       "16r0388"    16rB8 " GREEK CAPITAL LETTER EPSILON WITH TONOS " 
	       "16r0389"    16rB9 " GREEK CAPITAL LETTER ETA WITH TONOS " 
	       "16r038A"    16rBA " GREEK CAPITAL LETTER IOTA WITH TONOS " 
	       "16r038B"    16r00 " invalid " 
	       "16r038C"    16rBC " GREEK CAPITAL LETTER OMICRON WITH TONOS " 
	       "16r038D"    16r00 " invalid " 
	       "16r038E"    16rBE " GREEK CAPITAL LETTER UPSILON WITH TONOS " 
	       "16r038F"    16rBF " GREEK CAPITAL LETTER OMEGA WITH TONOS " 
	       "16r0390"    16rC0 " GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS " 
	       "16r0391"    16rC1 " GREEK CAPITAL LETTER ALPHA " 
	       "16r0392"    16rC2 " GREEK CAPITAL LETTER BETA " 
	       "16r0393"    16rC3 " GREEK CAPITAL LETTER GAMMA " 
	       "16r0394"    16rC4 " GREEK CAPITAL LETTER DELTA " 
	       "16r0395"    16rC5 " GREEK CAPITAL LETTER EPSILON " 
	       "16r0396"    16rC6 " GREEK CAPITAL LETTER ZETA " 
	       "16r0397"    16rC7 " GREEK CAPITAL LETTER ETA " 
	       "16r0398"    16rC8 " GREEK CAPITAL LETTER THETA " 
	       "16r0399"    16rC9 " GREEK CAPITAL LETTER IOTA " 
	       "16r039A"    16rCA " GREEK CAPITAL LETTER KAPPA " 
	       "16r039B"    16rCB " GREEK CAPITAL LETTER LAMDA " 
	       "16r039C"    16rCC " GREEK CAPITAL LETTER MU " 
	       "16r039D"    16rCD " GREEK CAPITAL LETTER NU " 
	       "16r039E"    16rCE " GREEK CAPITAL LETTER XI " 
	       "16r039F"    16rCF " GREEK CAPITAL LETTER OMICRON " 
	       "16r03A0"    16rD0 " GREEK CAPITAL LETTER PI " 
	       "16r03A1"    16rD1 " GREEK CAPITAL LETTER RHO " 
	       "16r03A2"    16r00 " invalid " 
	       "16r03A3"    16rD3 " GREEK CAPITAL LETTER SIGMA " 
	       "16r03A4"    16rD4 " GREEK CAPITAL LETTER TAU " 
	       "16r03A5"    16rD5 " GREEK CAPITAL LETTER UPSILON " 
	       "16r03A6"    16rD6 " GREEK CAPITAL LETTER PHI " 
	       "16r03A7"    16rD7 " GREEK CAPITAL LETTER CHI " 
	       "16r03A8"    16rD8 " GREEK CAPITAL LETTER PSI " 
	       "16r03A9"    16rD9 " GREEK CAPITAL LETTER OMEGA " 
	       "16r03AA"    16rDA " GREEK CAPITAL LETTER IOTA WITH DIALYTIKA " 
	       "16r03AB"    16rDB " GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA " 
	       "16r03AC"    16rDC " GREEK SMALL LETTER ALPHA WITH TONOS " 
	       "16r03AD"    16rDD " GREEK SMALL LETTER EPSILON WITH TONOS " 
	       "16r03AE"    16rDE " GREEK SMALL LETTER ETA WITH TONOS " 
	       "16r03AF"    16rDF " GREEK SMALL LETTER IOTA WITH TONOS " 
	       "16r03B0"    16rE0 " GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS " 
	       "16r03B1"    16rE1 " GREEK SMALL LETTER ALPHA " 
	       "16r03B2"    16rE2 " GREEK SMALL LETTER BETA " 
	       "16r03B3"    16rE3 " GREEK SMALL LETTER GAMMA " 
	       "16r03B4"    16rE4 " GREEK SMALL LETTER DELTA " 
	       "16r03B5"    16rE5 " GREEK SMALL LETTER EPSILON " 
	       "16r03B6"    16rE6 " GREEK SMALL LETTER ZETA " 
	       "16r03B7"    16rE7 " GREEK SMALL LETTER ETA " 
	       "16r03B8"    16rE8 " GREEK SMALL LETTER THETA " 
	       "16r03B9"    16rE9 " GREEK SMALL LETTER IOTA " 
	       "16r03BA"    16rEA " GREEK SMALL LETTER KAPPA " 
	       "16r03BB"    16rEB " GREEK SMALL LETTER LAMDA " 
	       "16r03BC"    16rEC " GREEK SMALL LETTER MU " 
	       "16r03BD"    16rED " GREEK SMALL LETTER NU " 
	       "16r03BE"    16rEE " GREEK SMALL LETTER XI " 
	       "16r03BF"    16rEF " GREEK SMALL LETTER OMICRON " 
	       "16r03C0"    16rF0 " GREEK SMALL LETTER PI " 
	       "16r03C1"    16rF1 " GREEK SMALL LETTER RHO " 
	       "16r03C2"    16rF2 " GREEK SMALL LETTER FINAL SIGMA " 
	       "16r03C3"    16rF3 " GREEK SMALL LETTER SIGMA " 
	       "16r03C4"    16rF4 " GREEK SMALL LETTER TAU " 
	       "16r03C5"    16rF5 " GREEK SMALL LETTER UPSILON " 
	       "16r03C6"    16rF6 " GREEK SMALL LETTER PHI " 
	       "16r03C7"    16rF7 " GREEK SMALL LETTER CHI " 
	       "16r03C8"    16rF8 " GREEK SMALL LETTER PSI " 
	       "16r03C9"    16rF9 " GREEK SMALL LETTER OMEGA " 
	       "16r03CA"    16rFA " GREEK SMALL LETTER IOTA WITH DIALYTIKA " 
	       "16r03CB"    16rFB " GREEK SMALL LETTER UPSILON WITH DIALYTIKA " 
	       "16r03CC"    16rFC " GREEK SMALL LETTER OMICRON WITH TONOS " 
	       "16r03CD"    16rFD " GREEK SMALL LETTER UPSILON WITH TONOS " 
	       "16r03CE"    16rFE " GREEK SMALL LETTER OMEGA WITH TONOS " 
	       ] at:(unicode - 16r379).
	    t == 0 ifFalse:[^ t].
	    ^ self encodingError
	] value.
    ].
    unicode <= 16r2014 ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r2019 ifTrue:[
	[
	    |t|
	    t := #[
	       "16r2015"    16rAF " HORIZONTAL BAR " 
	       "16r2016"    16r00 " invalid " 
	       "16r2017"    16r00 " invalid " 
	       "16r2018"    16rA1 " LEFT SINGLE QUOTATION MARK " 
	       "16r2019"    16rA2 " RIGHT SINGLE QUOTATION MARK " 
	       ] at:(unicode - 16r2014).
	    t == 0 ifFalse:[^ t].
	    ^ self encodingError
	] value.
    ].
    unicode <= 16r20AB ifTrue:[
	^ self encodingError.
    ].
    [
	|t|
	t := #[
	   "16r20AC"    16rA4 " EURO SIGN " 
	   "16r20AD"    16r00 " invalid " 
	   "16r20AE"    16r00 " invalid " 
	   "16r20AF"    16rA5 " DRACHMA SIGN " 
	   ] at:(unicode - 16r20AB).
	t == 0 ifFalse:[^ t].
	^ self encodingError
    ] value.
! !

!ISO8859_7 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO8859_7.st,v 1.5 2012-07-11 16:42:54 stefan Exp $'
! !
