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

SingleByteEncoder subclass:#ISO8859_8
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO8859_8 class methodsFor:'documentation'!

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
    8859-8 - Hebrew.

    [see with:]
        CharacterEncoderImplementations::ISO8859_8 showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!ISO8859_8 class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'ISO8859/8859-8.TXT'
!

mapping
"
# From: http://www.unicode.org/Public/MAPPINGS/ISO8859/8859-8.TXT

#
#       Name:             ISO/IEC 8859-8:1999 to Unicode
#       Unicode version:  3.0
#       Table version:    1.1
#       Table format:     Format A
#       Date:             2000-Jan-03
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
#       ISO/IEC 8859-8:1999 characters map into Unicode.
#
#       Format:  Three tab-separated columns
#                Column #1 is the ISO/IEC 8859-8 code (in hex as 0xXX)
#                Column #2 is the Unicode (in hex as 0xXXXX)
#                Column #3 the Unicode name (follows a comment sign, '#')
#
#       The entries are in ISO/IEC 8859-8 order.
#
#       Version history
#       1.0 version updates 0.1 version by adding mappings for all
#       control characters.
#       1.1 version updates to the published 8859-8:1999, correcting
#          the mapping of 0xAF and adding mappings for LRM and RLM.
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
0xA2    0x00A2  #       CENT SIGN
0xA3    0x00A3  #       POUND SIGN
0xA4    0x00A4  #       CURRENCY SIGN
0xA5    0x00A5  #       YEN SIGN
0xA6    0x00A6  #       BROKEN BAR
0xA7    0x00A7  #       SECTION SIGN
0xA8    0x00A8  #       DIAERESIS
0xA9    0x00A9  #       COPYRIGHT SIGN
0xAA    0x00D7  #       MULTIPLICATION SIGN
0xAB    0x00AB  #       LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
0xAC    0x00AC  #       NOT SIGN
0xAD    0x00AD  #       SOFT HYPHEN
0xAE    0x00AE  #       REGISTERED SIGN
0xAF    0x00AF  #       MACRON
0xB0    0x00B0  #       DEGREE SIGN
0xB1    0x00B1  #       PLUS-MINUS SIGN
0xB2    0x00B2  #       SUPERSCRIPT TWO
0xB3    0x00B3  #       SUPERSCRIPT THREE
0xB4    0x00B4  #       ACUTE ACCENT
0xB5    0x00B5  #       MICRO SIGN
0xB6    0x00B6  #       PILCROW SIGN
0xB7    0x00B7  #       MIDDLE DOT
0xB8    0x00B8  #       CEDILLA
0xB9    0x00B9  #       SUPERSCRIPT ONE
0xBA    0x00F7  #       DIVISION SIGN
0xBB    0x00BB  #       RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
0xBC    0x00BC  #       VULGAR FRACTION ONE QUARTER
0xBD    0x00BD  #       VULGAR FRACTION ONE HALF
0xBE    0x00BE  #       VULGAR FRACTION THREE QUARTERS
0xDF    0x2017  #       DOUBLE LOW LINE
0xE0    0x05D0  #       HEBREW LETTER ALEF
0xE1    0x05D1  #       HEBREW LETTER BET
0xE2    0x05D2  #       HEBREW LETTER GIMEL
0xE3    0x05D3  #       HEBREW LETTER DALET
0xE4    0x05D4  #       HEBREW LETTER HE
0xE5    0x05D5  #       HEBREW LETTER VAV
0xE6    0x05D6  #       HEBREW LETTER ZAYIN
0xE7    0x05D7  #       HEBREW LETTER HET
0xE8    0x05D8  #       HEBREW LETTER TET
0xE9    0x05D9  #       HEBREW LETTER YOD
0xEA    0x05DA  #       HEBREW LETTER FINAL KAF
0xEB    0x05DB  #       HEBREW LETTER KAF
0xEC    0x05DC  #       HEBREW LETTER LAMED
0xED    0x05DD  #       HEBREW LETTER FINAL MEM
0xEE    0x05DE  #       HEBREW LETTER MEM
0xEF    0x05DF  #       HEBREW LETTER FINAL NUN
0xF0    0x05E0  #       HEBREW LETTER NUN
0xF1    0x05E1  #       HEBREW LETTER SAMEKH
0xF2    0x05E2  #       HEBREW LETTER AYIN
0xF3    0x05E3  #       HEBREW LETTER FINAL PE
0xF4    0x05E4  #       HEBREW LETTER PE
0xF5    0x05E5  #       HEBREW LETTER FINAL TSADI
0xF6    0x05E6  #       HEBREW LETTER TSADI
0xF7    0x05E7  #       HEBREW LETTER QOF
0xF8    0x05E8  #       HEBREW LETTER RESH
0xF9    0x05E9  #       HEBREW LETTER SHIN
0xFA    0x05EA  #       HEBREW LETTER TAV
0xFD    0x200E  #       LEFT-TO-RIGHT MARK
0xFE    0x200F  #       RIGHT-TO-LEFT MARK


"
! !

!ISO8859_8 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Hebrew'
! !

!ISO8859_8 methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16rA0 ifTrue:[ ^ code ].
    code > 16rFE ifTrue:[
	^ self decodingError.
    ].
    code <= 16rBE ifTrue:[
	[
	    |t|
	    t := #[
	       "16r00A1"    16r00 " invalid " 
	       "16r00A2"    16rA2 " CENT SIGN " 
	       "16r00A3"    16rA3 " POUND SIGN " 
	       "16r00A4"    16rA4 " CURRENCY SIGN " 
	       "16r00A5"    16rA5 " YEN SIGN " 
	       "16r00A6"    16rA6 " BROKEN BAR " 
	       "16r00A7"    16rA7 " SECTION SIGN " 
	       "16r00A8"    16rA8 " DIAERESIS " 
	       "16r00A9"    16rA9 " COPYRIGHT SIGN " 
	       "16r00AA"    16rD7 " MULTIPLICATION SIGN " 
	       "16r00AB"    16rAB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
	       "16r00AC"    16rAC " NOT SIGN " 
	       "16r00AD"    16rAD " SOFT HYPHEN " 
	       "16r00AE"    16rAE " REGISTERED SIGN " 
	       "16r00AF"    16rAF " MACRON " 
	       "16r00B0"    16rB0 " DEGREE SIGN " 
	       "16r00B1"    16rB1 " PLUS-MINUS SIGN " 
	       "16r00B2"    16rB2 " SUPERSCRIPT TWO " 
	       "16r00B3"    16rB3 " SUPERSCRIPT THREE " 
	       "16r00B4"    16rB4 " ACUTE ACCENT " 
	       "16r00B5"    16rB5 " MICRO SIGN " 
	       "16r00B6"    16rB6 " PILCROW SIGN " 
	       "16r00B7"    16rB7 " MIDDLE DOT " 
	       "16r00B8"    16rB8 " CEDILLA " 
	       "16r00B9"    16rB9 " SUPERSCRIPT ONE " 
	       "16r00BA"    16rF7 " DIVISION SIGN " 
	       "16r00BB"    16rBB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
	       "16r00BC"    16rBC " VULGAR FRACTION ONE QUARTER " 
	       "16r00BD"    16rBD " VULGAR FRACTION ONE HALF " 
	       "16r00BE"    16rBE " VULGAR FRACTION THREE QUARTERS " 
	       ] at:(code - 16rA0).
	    t == 0 ifFalse:[^ t].
	    ^ self decodingError.
	] value.
    ].
    code <= 16rDE ifTrue:[
	^ self decodingError.
    ].
    [
	|t|
	t := #(
	   "16r00DF"    16r2017 " DOUBLE LOW LINE " 
	   "16r00E0"    16r05D0 " HEBREW LETTER ALEF " 
	   "16r00E1"    16r05D1 " HEBREW LETTER BET " 
	   "16r00E2"    16r05D2 " HEBREW LETTER GIMEL " 
	   "16r00E3"    16r05D3 " HEBREW LETTER DALET " 
	   "16r00E4"    16r05D4 " HEBREW LETTER HE " 
	   "16r00E5"    16r05D5 " HEBREW LETTER VAV " 
	   "16r00E6"    16r05D6 " HEBREW LETTER ZAYIN " 
	   "16r00E7"    16r05D7 " HEBREW LETTER HET " 
	   "16r00E8"    16r05D8 " HEBREW LETTER TET " 
	   "16r00E9"    16r05D9 " HEBREW LETTER YOD " 
	   "16r00EA"    16r05DA " HEBREW LETTER FINAL KAF " 
	   "16r00EB"    16r05DB " HEBREW LETTER KAF " 
	   "16r00EC"    16r05DC " HEBREW LETTER LAMED " 
	   "16r00ED"    16r05DD " HEBREW LETTER FINAL MEM " 
	   "16r00EE"    16r05DE " HEBREW LETTER MEM " 
	   "16r00EF"    16r05DF " HEBREW LETTER FINAL NUN " 
	   "16r00F0"    16r05E0 " HEBREW LETTER NUN " 
	   "16r00F1"    16r05E1 " HEBREW LETTER SAMEKH " 
	   "16r00F2"    16r05E2 " HEBREW LETTER AYIN " 
	   "16r00F3"    16r05E3 " HEBREW LETTER FINAL PE " 
	   "16r00F4"    16r05E4 " HEBREW LETTER PE " 
	   "16r00F5"    16r05E5 " HEBREW LETTER FINAL TSADI " 
	   "16r00F6"    16r05E6 " HEBREW LETTER TSADI " 
	   "16r00F7"    16r05E7 " HEBREW LETTER QOF " 
	   "16r00F8"    16r05E8 " HEBREW LETTER RESH " 
	   "16r00F9"    16r05E9 " HEBREW LETTER SHIN " 
	   "16r00FA"    16r05EA " HEBREW LETTER TAV " 
	   "16r00FB"    16r0000 " invalid " 
	   "16r00FC"    16r0000 " invalid " 
	   "16r00FD"    16r200E " LEFT-TO-RIGHT MARK " 
	   "16r00FE"    16r200F " RIGHT-TO-LEFT MARK " 
	   ) at:(code - 16rDE).
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
    unicode > 16r2017 ifTrue:[
	^ self encodingError.
    ].
    unicode <= 16r5EA ifTrue:[
	unicode <= 16rF7 ifTrue:[
	    unicode <= 16rD7 ifTrue:[
		unicode <= 16rBE ifTrue:[
		    [
			|t|
			t := #[
			   "16r00A1"    16r00 " invalid " 
			   "16r00A2"    16rA2 " CENT SIGN " 
			   "16r00A3"    16rA3 " POUND SIGN " 
			   "16r00A4"    16rA4 " CURRENCY SIGN " 
			   "16r00A5"    16rA5 " YEN SIGN " 
			   "16r00A6"    16rA6 " BROKEN BAR " 
			   "16r00A7"    16rA7 " SECTION SIGN " 
			   "16r00A8"    16rA8 " DIAERESIS " 
			   "16r00A9"    16rA9 " COPYRIGHT SIGN " 
			   "16r00AA"    16r00 " invalid " 
			   "16r00AB"    16rAB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
			   "16r00AC"    16rAC " NOT SIGN " 
			   "16r00AD"    16rAD " SOFT HYPHEN " 
			   "16r00AE"    16rAE " REGISTERED SIGN " 
			   "16r00AF"    16rAF " MACRON " 
			   "16r00B0"    16rB0 " DEGREE SIGN " 
			   "16r00B1"    16rB1 " PLUS-MINUS SIGN " 
			   "16r00B2"    16rB2 " SUPERSCRIPT TWO " 
			   "16r00B3"    16rB3 " SUPERSCRIPT THREE " 
			   "16r00B4"    16rB4 " ACUTE ACCENT " 
			   "16r00B5"    16rB5 " MICRO SIGN " 
			   "16r00B6"    16rB6 " PILCROW SIGN " 
			   "16r00B7"    16rB7 " MIDDLE DOT " 
			   "16r00B8"    16rB8 " CEDILLA " 
			   "16r00B9"    16rB9 " SUPERSCRIPT ONE " 
			   "16r00BA"    16r00 " invalid " 
			   "16r00BB"    16rBB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
			   "16r00BC"    16rBC " VULGAR FRACTION ONE QUARTER " 
			   "16r00BD"    16rBD " VULGAR FRACTION ONE HALF " 
			   "16r00BE"    16rBE " VULGAR FRACTION THREE QUARTERS " 
			   ] at:(unicode - 16rA0).
			t == 0 ifFalse:[^ t].
			^ self encodingError
		    ] value.
		].
		unicode <= 16rD6 ifTrue:[
		    ^ self encodingError.
		].
		^  "16r00D7" 16r00AA " MULTIPLICATION SIGN " 
	    ].
	    unicode <= 16rF6 ifTrue:[
		^ self encodingError.
	    ].
	    ^  "16r00F7" 16r00BA " DIVISION SIGN " 
	].
	unicode <= 16r5CF ifTrue:[
	    ^ self encodingError.
	].
	^ #[
	   "16r05D0"    16rE0 " HEBREW LETTER ALEF " 
	   "16r05D1"    16rE1 " HEBREW LETTER BET " 
	   "16r05D2"    16rE2 " HEBREW LETTER GIMEL " 
	   "16r05D3"    16rE3 " HEBREW LETTER DALET " 
	   "16r05D4"    16rE4 " HEBREW LETTER HE " 
	   "16r05D5"    16rE5 " HEBREW LETTER VAV " 
	   "16r05D6"    16rE6 " HEBREW LETTER ZAYIN " 
	   "16r05D7"    16rE7 " HEBREW LETTER HET " 
	   "16r05D8"    16rE8 " HEBREW LETTER TET " 
	   "16r05D9"    16rE9 " HEBREW LETTER YOD " 
	   "16r05DA"    16rEA " HEBREW LETTER FINAL KAF " 
	   "16r05DB"    16rEB " HEBREW LETTER KAF " 
	   "16r05DC"    16rEC " HEBREW LETTER LAMED " 
	   "16r05DD"    16rED " HEBREW LETTER FINAL MEM " 
	   "16r05DE"    16rEE " HEBREW LETTER MEM " 
	   "16r05DF"    16rEF " HEBREW LETTER FINAL NUN " 
	   "16r05E0"    16rF0 " HEBREW LETTER NUN " 
	   "16r05E1"    16rF1 " HEBREW LETTER SAMEKH " 
	   "16r05E2"    16rF2 " HEBREW LETTER AYIN " 
	   "16r05E3"    16rF3 " HEBREW LETTER FINAL PE " 
	   "16r05E4"    16rF4 " HEBREW LETTER PE " 
	   "16r05E5"    16rF5 " HEBREW LETTER FINAL TSADI " 
	   "16r05E6"    16rF6 " HEBREW LETTER TSADI " 
	   "16r05E7"    16rF7 " HEBREW LETTER QOF " 
	   "16r05E8"    16rF8 " HEBREW LETTER RESH " 
	   "16r05E9"    16rF9 " HEBREW LETTER SHIN " 
	   "16r05EA"    16rFA " HEBREW LETTER TAV " 
	   ] at:(unicode - 16r5CF).
    ].
    unicode <= 16r200D ifTrue:[
	^ self encodingError.
    ].
    [
	|t|
	t := #[
	   "16r200E"    16rFD " LEFT-TO-RIGHT MARK " 
	   "16r200F"    16rFE " RIGHT-TO-LEFT MARK " 
	   "16r2010"    16r00 " invalid " 
	   "16r2011"    16r00 " invalid " 
	   "16r2012"    16r00 " invalid " 
	   "16r2013"    16r00 " invalid " 
	   "16r2014"    16r00 " invalid " 
	   "16r2015"    16r00 " invalid " 
	   "16r2016"    16r00 " invalid " 
	   "16r2017"    16rDF " DOUBLE LOW LINE " 
	   ] at:(unicode - 16r200D).
	t == 0 ifFalse:[^ t].
	^ self encodingError
    ] value.
! !

!ISO8859_8 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__ISO8859_8.st,v 1.5 2012-07-11 16:43:21 stefan Exp $'
! !
