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

SingleByteEncoder subclass:#MS_Arabic
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!MS_Arabic class methodsFor:'documentation'!

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
    CP1256 / Microsoft Arabic

    [see with:]
        CharacterEncoderImplementations::MS_Arabic showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!MS_Arabic class methodsFor:'mapping'!

mapFileURL2_relativePathName
    ^ 'CP1256'

    "
     self generateCode
    "
!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/CP1256

<code_set_name> CP1256
<comment_char> %
<escape_char> /
% version: 1.0
% repertoiremap: mnemonic,ds
%  source: UNICODE 1.0

% alias MS-ARAB
CHARMAP
<NU>                   /x00   <U0000> NULL (NUL)
<SH>                   /x01   <U0001> START OF HEADING (SOH)
<SX>                   /x02   <U0002> START OF TEXT (STX)
<EX>                   /x03   <U0003> END OF TEXT (ETX)
<ET>                   /x04   <U0004> END OF TRANSMISSION (EOT)
<EQ>                   /x05   <U0005> ENQUIRY (ENQ)
<AK>                   /x06   <U0006> ACKNOWLEDGE (ACK)
<BL>                   /x07   <U0007> BELL (BEL)
<BS>                   /x08   <U0008> BACKSPACE (BS)
<HT>                   /x09   <U0009> CHARACTER TABULATION (HT)
<LF>                   /x0A   <U000A> LINE FEED (LF)
<VT>                   /x0B   <U000B> LINE TABULATION (VT)
<FF>                   /x0C   <U000C> FORM FEED (FF)
<CR>                   /x0D   <U000D> CARRIAGE RETURN (CR)
<SO>                   /x0E   <U000E> SHIFT OUT (SO)
<SI>                   /x0F   <U000F> SHIFT IN (SI)
<DL>                   /x10   <U0010> DATALINK ESCAPE (DLE)
<D1>                   /x11   <U0011> DEVICE CONTROL ONE (DC1)
<D2>                   /x12   <U0012> DEVICE CONTROL TWO (DC2)
<D3>                   /x13   <U0013> DEVICE CONTROL THREE (DC3)
<D4>                   /x14   <U0014> DEVICE CONTROL FOUR (DC4)
<NK>                   /x15   <U0015> NEGATIVE ACKNOWLEDGE (NAK)
<SY>                   /x16   <U0016> SYNCHRONOUS IDLE (SYN)
<EB>                   /x17   <U0017> END OF TRANSMISSION BLOCK (ETB)
<CN>                   /x18   <U0018> CANCEL (CAN)
<EM>                   /x19   <U0019> END OF MEDIUM (EM)
<SB>                   /x1A   <U001A> SUBSTITUTE (SUB)
<EC>                   /x1B   <U001B> ESCAPE (ESC)
<FS>                   /x1C   <U001C> FILE SEPARATOR (IS4)
<GS>                   /x1D   <U001D> GROUP SEPARATOR (IS3)
<RS>                   /x1E   <U001E> RECORD SEPARATOR (IS2)
<US>                   /x1F   <U001F> UNIT SEPARATOR (IS1)
<SP>                   /x20   <U0020> SPACE
<!!>                    /x21   <U0021> EXCLAMATION MARK
<'>                    /x22   <U0022> QUOTATION MARK
<Nb>                   /x23   <U0023> NUMBER SIGN
<DO>                   /x24   <U0024> DOLLAR SIGN
<%>                    /x25   <U0025> PERCENT SIGN
<&>                    /x26   <U0026> AMPERSAND
<'>                    /x27   <U0027> APOSTROPHE
<(>                    /x28   <U0028> LEFT PARENTHESIS
<)>                    /x29   <U0029> RIGHT PARENTHESIS
<*>                    /x2A   <U002A> ASTERISK
<+>                    /x2B   <U002B> PLUS SIGN
<,>                    /x2C   <U002C> COMMA
<->                    /x2D   <U002D> HYPHEN-MINUS
<.>                    /x2E   <U002E> FULL STOP
<//>                   /x2F   <U002F> SOLIDUS
<0>                    /x30   <U0030> DIGIT ZERO
<1>                    /x31   <U0031> DIGIT ONE
<2>                    /x32   <U0032> DIGIT TWO
<3>                    /x33   <U0033> DIGIT THREE
<4>                    /x34   <U0034> DIGIT FOUR
<5>                    /x35   <U0035> DIGIT FIVE
<6>                    /x36   <U0036> DIGIT SIX
<7>                    /x37   <U0037> DIGIT SEVEN
<8>                    /x38   <U0038> DIGIT EIGHT
<9>                    /x39   <U0039> DIGIT NINE
<:>                    /x3A   <U003A> COLON
<;>                    /x3B   <U003B> SEMICOLON
<<>                    /x3C   <U003C> LESS-THAN SIGN
<=>                    /x3D   <U003D> EQUALS SIGN
</>>                   /x3E   <U003E> GREATER-THAN SIGN
<?>                    /x3F   <U003F> QUESTION MARK
<At>                   /x40   <U0040> COMMERCIAL AT
<A>                    /x41   <U0041> LATIN CAPITAL LETTER A
<B>                    /x42   <U0042> LATIN CAPITAL LETTER B
<C>                    /x43   <U0043> LATIN CAPITAL LETTER C
<D>                    /x44   <U0044> LATIN CAPITAL LETTER D
<E>                    /x45   <U0045> LATIN CAPITAL LETTER E
<F>                    /x46   <U0046> LATIN CAPITAL LETTER F
<G>                    /x47   <U0047> LATIN CAPITAL LETTER G
<H>                    /x48   <U0048> LATIN CAPITAL LETTER H
<I>                    /x49   <U0049> LATIN CAPITAL LETTER I
<J>                    /x4A   <U004A> LATIN CAPITAL LETTER J
<K>                    /x4B   <U004B> LATIN CAPITAL LETTER K
<L>                    /x4C   <U004C> LATIN CAPITAL LETTER L
<M>                    /x4D   <U004D> LATIN CAPITAL LETTER M
<N>                    /x4E   <U004E> LATIN CAPITAL LETTER N
<O>                    /x4F   <U004F> LATIN CAPITAL LETTER O
<P>                    /x50   <U0050> LATIN CAPITAL LETTER P
<Q>                    /x51   <U0051> LATIN CAPITAL LETTER Q
<R>                    /x52   <U0052> LATIN CAPITAL LETTER R
<S>                    /x53   <U0053> LATIN CAPITAL LETTER S
<T>                    /x54   <U0054> LATIN CAPITAL LETTER T
<U>                    /x55   <U0055> LATIN CAPITAL LETTER U
<V>                    /x56   <U0056> LATIN CAPITAL LETTER V
<W>                    /x57   <U0057> LATIN CAPITAL LETTER W
<X>                    /x58   <U0058> LATIN CAPITAL LETTER X
<Y>                    /x59   <U0059> LATIN CAPITAL LETTER Y
<Z>                    /x5A   <U005A> LATIN CAPITAL LETTER Z
<<(>                   /x5B   <U005B> LEFT SQUARE BRACKET
<////>                 /x5C   <U005C> REVERSE SOLIDUS
<)/>>                  /x5D   <U005D> RIGHT SQUARE BRACKET
<'/>>                  /x5E   <U005E> CIRCUMFLEX ACCENT
<_>                    /x5F   <U005F> LOW LINE
<'!!>                   /x60   <U0060> GRAVE ACCENT
<a>                    /x61   <U0061> LATIN SMALL LETTER A
<b>                    /x62   <U0062> LATIN SMALL LETTER B
<c>                    /x63   <U0063> LATIN SMALL LETTER C
<d>                    /x64   <U0064> LATIN SMALL LETTER D
<e>                    /x65   <U0065> LATIN SMALL LETTER E
<f>                    /x66   <U0066> LATIN SMALL LETTER F
<g>                    /x67   <U0067> LATIN SMALL LETTER G
<h>                    /x68   <U0068> LATIN SMALL LETTER H
<i>                    /x69   <U0069> LATIN SMALL LETTER I
<j>                    /x6A   <U006A> LATIN SMALL LETTER J
<k>                    /x6B   <U006B> LATIN SMALL LETTER K
<l>                    /x6C   <U006C> LATIN SMALL LETTER L
<m>                    /x6D   <U006D> LATIN SMALL LETTER M
<n>                    /x6E   <U006E> LATIN SMALL LETTER N
<o>                    /x6F   <U006F> LATIN SMALL LETTER O
<p>                    /x70   <U0070> LATIN SMALL LETTER P
<q>                    /x71   <U0071> LATIN SMALL LETTER Q
<r>                    /x72   <U0072> LATIN SMALL LETTER R
<s>                    /x73   <U0073> LATIN SMALL LETTER S
<t>                    /x74   <U0074> LATIN SMALL LETTER T
<u>                    /x75   <U0075> LATIN SMALL LETTER U
<v>                    /x76   <U0076> LATIN SMALL LETTER V
<w>                    /x77   <U0077> LATIN SMALL LETTER W
<x>                    /x78   <U0078> LATIN SMALL LETTER X
<y>                    /x79   <U0079> LATIN SMALL LETTER Y
<z>                    /x7A   <U007A> LATIN SMALL LETTER Z
<(!!>                   /x7B   <U007B> LEFT CURLY BRACKET
<!!!!>                   /x7C   <U007C> VERTICAL LINE
<!!)>                   /x7D   <U007D> RIGHT CURLY BRACKET
<'?>                   /x7E   <U007E> TILDE
<DT>                   /x7F   <U007F> DELETE (DEL)
<,+>                   /x80   <U060C> ARABIC COMMA
<0a>                   /x81   <U0660> ARABIC-INDIC DIGIT ZERO
<.9>                   /x82   <U201A> SINGLE LOW-9 QUOTATION MARK
<1a>                   /x83   <U0661> ARABIC-INDIC DIGIT ONE
<:9>                   /x84   <U201E> DOUBLE LOW-9 QUOTATION MARK
<.3>                   /x85   <U2026> HORIZONTAL ELLIPSIS
<//->                  /x86   <U2020> DAGGER
<//=>                  /x87   <U2021> DOUBLE DAGGER
<2a>                   /x88   <U0662> ARABIC-INDIC DIGIT TWO
<3a>                   /x89   <U0663> ARABIC-INDIC DIGIT THREE
<4a>                   /x8A   <U0664> ARABIC-INDIC DIGIT FOUR
<<1>                   /x8B   <U2039> SINGLE LEFT-POINTING ANGLE QUOTATION MARK
<5a>                   /x8C   <U0665> ARABIC-INDIC DIGIT FIVE
<6a>                   /x8D   <U0666> ARABIC-INDIC DIGIT SIX
<7a>                   /x8E   <U0667> ARABIC-INDIC DIGIT SEVEN
<8a>                   /x8F   <U0668> ARABIC-INDIC DIGIT EIGHT
<9a>                   /x90   <U0669> ARABIC-INDIC DIGIT NINE
<'6>                   /x91   <U2018> LEFT SINGLE QUOTATION MARK
<'9>                   /x92   <U2019> RIGHT SINGLE QUOTATION MARK
<'6>                   /x93   <U201C> LEFT DOUBLE QUOTATION MARK
<'9>                   /x94   <U201D> RIGHT DOUBLE QUOTATION MARK
<sb>                   /x95   <U2022> BULLET
<-N>                   /x96   <U2013> EN DASH
<-M>                   /x97   <U2014> EM DASH
<;+>                   /x98   <U061B> ARABIC SEMICOLON
<TM>                   /x99   <U2122> TRADE MARK SIGN
<?+>                   /x9A   <U061F> ARABIC QUESTION MARK
</>1>                  /x9B   <U203A> SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
<H'>                   /x9C   <U0621> ARABIC LETTER HAMZA
<aM>                   /x9D   <U0622> ARABIC LETTER ALEF WITH MADDA ABOVE
<aH>                   /x9E   <U0623> ARABIC LETTER ALEF WITH HAMZA ABOVE
<Y:>                   /x9F   <U0178> LATIN CAPITAL LETTER Y WITH DIAERESIS
<NS>                   /xA0   <U00A0> NO-BREAK SPACE
<wH>                   /xA1   <U0624> ARABIC LETTER WAW WITH HAMZA ABOVE
<ah>                   /xA2   <U0625> ARABIC LETTER ALEF WITH HAMZA BELOW
<Pd>                   /xA3   <U00A3> POUND SIGN
<Cu>                   /xA4   <U00A4> CURRENCY SIGN
<yH>                   /xA5   <U0626> ARABIC LETTER YEH WITH HAMZA ABOVE
<BB>                   /xA6   <U00A6> BROKEN BAR
<SE>                   /xA7   <U00A7> SECTION SIGN
<a+>                   /xA8   <U0627> ARABIC LETTER ALEF
<Co>                   /xA9   <U00A9> COPYRIGHT SIGN
<b+>                   /xAA   <U0628> ARABIC LETTER BEH
<<<>                   /xAB   <U00AB> LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
<NO>                   /xAC   <U00AC> NOT SIGN
<-->                   /xAD   <U00AD> SOFT HYPHEN
<Rg>                   /xAE   <U00AE> REGISTERED SIGN
<p+>                   /xAF   <U067E> ARABIC LETTER PEH
<DG>                   /xB0   <U00B0> DEGREE SIGN
<+->                   /xB1   <U00B1> PLUS-MINUS SIGN
<tm>                   /xB2   <U0629> ARABIC LETTER TEH MARBUTA
<t+>                   /xB3   <U062A> ARABIC LETTER TEH
<tk>                   /xB4   <U062B> ARABIC LETTER THEH
<My>                   /xB5   <U00B5> MICRO SIGN
<PI>                   /xB6   <U00B6> PILCROW SIGN
<.M>                   /xB7   <U00B7> MIDDLE DOT
<g+>                   /xB8   <U062C> ARABIC LETTER JEEM
<tc>                   /xB9   <U0686> ARABIC LETTER TCHEH
<hk>                   /xBA   <U062D> ARABIC LETTER HAH
</>/>>                 /xBB   <U00BB> RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
<x+>                   /xBC   <U062E> ARABIC LETTER KHAH
<d+>                   /xBD   <U062F> ARABIC LETTER DAL
<dk>                   /xBE   <U0630> ARABIC LETTER THAL
<r+>                   /xBF   <U0631> ARABIC LETTER REH
<A!!>                   /xC0   <U00C0> LATIN CAPITAL LETTER A WITH GRAVE
<z+>                   /xC1   <U0632> ARABIC LETTER ZAIN
<A/>>                  /xC2   <U00C2> LATIN CAPITAL LETTER A WITH CIRCUMFLEX
<zj>                   /xC3   <U0698> ARABIC LETTER JEH
<s+>                   /xC4   <U0633> ARABIC LETTER SEEN
<sn>                   /xC5   <U0634> ARABIC LETTER SHEEN
<c+>                   /xC6   <U0635> ARABIC LETTER SAD
<C,>                   /xC7   <U00C7> LATIN CAPITAL LETTER C WITH CEDILLA
<E!!>                   /xC8   <U00C8> LATIN CAPITAL LETTER E WITH GRAVE
<E'>                   /xC9   <U00C9> LATIN CAPITAL LETTER E WITH ACUTE
<E/>>                  /xCA   <U00CA> LATIN CAPITAL LETTER E WITH CIRCUMFLEX
<E:>                   /xCB   <U00CB> LATIN CAPITAL LETTER E WITH DIAERESIS
<dd>                   /xCC   <U0636> ARABIC LETTER DAD
<tj>                   /xCD   <U0637> ARABIC LETTER TAH
<I/>>                  /xCE   <U00CE> LATIN CAPITAL LETTER I WITH CIRCUMFLEX
<I:>                   /xCF   <U00CF> LATIN CAPITAL LETTER I WITH DIAERESIS
<zh>                   /xD0   <U3113> BOPOMOFO LETTER ZH
<e+>                   /xD1   <U0639> ARABIC LETTER AIN
<i+>                   /xD2   <U063A> ARABIC LETTER GHAIN
<++>                   /xD3   <U0640> ARABIC TATWEEL
<O/>>                  /xD4   <U00D4> LATIN CAPITAL LETTER O WITH CIRCUMFLEX
<f+>                   /xD5   <U0641> ARABIC LETTER FEH
<q+>                   /xD6   <U0642> ARABIC LETTER QAF
<*X>                   /xD7   <U00D7> MULTIPLICATION SIGN
<k+>                   /xD8   <U0643> ARABIC LETTER KAF
<U!!>                   /xD9   <U00D9> LATIN CAPITAL LETTER U WITH GRAVE
<gf>                   /xDA   <U06AF> ARABIC LETTER GAF
<U/>>                  /xDB   <U00DB> LATIN CAPITAL LETTER U WITH CIRCUMFLEX
<U:>                   /xDC   <U00DC> LATIN CAPITAL LETTER U WITH DIAERESIS
<l+>                   /xDD   <U0644> ARABIC LETTER LAM
<m+>                   /xDE   <U0645> ARABIC LETTER MEEM
<n+>                   /xDF   <U0646> ARABIC LETTER NOON
<a!!>                   /xE0   <U00E0> LATIN SMALL LETTER A WITH GRAVE
<h+>                   /xE1   <U0647> ARABIC LETTER HEH
<a/>>                  /xE2   <U00E2> LATIN SMALL LETTER A WITH CIRCUMFLEX
<hH>                   /xE3   <U0681> ARABIC LETTER HAH WITH HAMZA ABOVE
<w+>                   /xE4   <U0648> ARABIC LETTER WAW
<j+>                   /xE5   <U0649> ARABIC LETTER ALEF MAKSURA
<y+>                   /xE6   <U064A> ARABIC LETTER YEH
<c,>                   /xE7   <U00E7> LATIN SMALL LETTER C WITH CEDILLA
<e!!>                   /xE8   <U00E8> LATIN SMALL LETTER E WITH GRAVE
<e'>                   /xE9   <U00E9> LATIN SMALL LETTER E WITH ACUTE
<e/>>                  /xEA   <U00EA> LATIN SMALL LETTER E WITH CIRCUMFLEX
<e:>                   /xEB   <U00EB> LATIN SMALL LETTER E WITH DIAERESIS
<:+>                   /xEC   <U064B> ARABIC FATHATAN
<'+>                   /xED   <U064C> ARABIC DAMMATAN
<i/>>                  /xEE   <U00EE> LATIN SMALL LETTER I WITH CIRCUMFLEX
<i:>                   /xEF   <U00EF> LATIN SMALL LETTER I WITH DIAERESIS
<=+>                   /xF0   <U064D> ARABIC KASRATAN
<//+>                  /xF1   <U064E> ARABIC FATHA
<'+>                   /xF2   <U064F> ARABIC DAMMA
<1+>                   /xF3   <U0650> ARABIC KASRA
<o/>>                  /xF4   <U00F4> LATIN SMALL LETTER O WITH CIRCUMFLEX
<3+>                   /xF5   <U0651> ARABIC SHADDA
<0+>                   /xF6   <U0652> ARABIC SUKUN
<-:>                   /xF7   <U00F7> DIVISION SIGN
<u!!>                   /xF9   <U00F9> LATIN SMALL LETTER U WITH GRAVE
<u/>>                  /xFB   <U00FB> LATIN SMALL LETTER U WITH CIRCUMFLEX
<u:>                   /xFC   <U00FC> LATIN SMALL LETTER U WITH DIAERESIS
<LR>                   /xFD   <U200E> LEFT-TO-RIGHT MARK
<RL>                   /xFE   <U200F> RIGHT-TO-LEFT MARK
<y:>                   /xFF   <U00FF> LATIN SMALL LETTER Y WITH DIAERESIS
END CHARMAP

"
! !

!MS_Arabic methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16r7F ifTrue:[ ^ code ].
    code > 16rFF ifTrue:[
        ^ self decodingError.
    ].
    [
        |t|
        t := #(
           "16r0080"    16r060C " ARABIC COMMA " 
           "16r0081"    16r0660 " ARABIC-INDIC DIGIT ZERO " 
           "16r0082"    16r201A " SINGLE LOW-9 QUOTATION MARK " 
           "16r0083"    16r0661 " ARABIC-INDIC DIGIT ONE " 
           "16r0084"    16r201E " DOUBLE LOW-9 QUOTATION MARK " 
           "16r0085"    16r2026 " HORIZONTAL ELLIPSIS " 
           "16r0086"    16r2020 " DAGGER " 
           "16r0087"    16r2021 " DOUBLE DAGGER " 
           "16r0088"    16r0662 " ARABIC-INDIC DIGIT TWO " 
           "16r0089"    16r0663 " ARABIC-INDIC DIGIT THREE " 
           "16r008A"    16r0664 " ARABIC-INDIC DIGIT FOUR " 
           "16r008B"    16r2039 " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
           "16r008C"    16r0665 " ARABIC-INDIC DIGIT FIVE " 
           "16r008D"    16r0666 " ARABIC-INDIC DIGIT SIX " 
           "16r008E"    16r0667 " ARABIC-INDIC DIGIT SEVEN " 
           "16r008F"    16r0668 " ARABIC-INDIC DIGIT EIGHT " 
           "16r0090"    16r0669 " ARABIC-INDIC DIGIT NINE " 
           "16r0091"    16r2018 " LEFT SINGLE QUOTATION MARK " 
           "16r0092"    16r2019 " RIGHT SINGLE QUOTATION MARK " 
           "16r0093"    16r201C " LEFT DOUBLE QUOTATION MARK " 
           "16r0094"    16r201D " RIGHT DOUBLE QUOTATION MARK " 
           "16r0095"    16r2022 " BULLET " 
           "16r0096"    16r2013 " EN DASH " 
           "16r0097"    16r2014 " EM DASH " 
           "16r0098"    16r061B " ARABIC SEMICOLON " 
           "16r0099"    16r2122 " TRADE MARK SIGN " 
           "16r009A"    16r061F " ARABIC QUESTION MARK " 
           "16r009B"    16r203A " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
           "16r009C"    16r0621 " ARABIC LETTER HAMZA " 
           "16r009D"    16r0622 " ARABIC LETTER ALEF WITH MADDA ABOVE " 
           "16r009E"    16r0623 " ARABIC LETTER ALEF WITH HAMZA ABOVE " 
           "16r009F"    16r0178 " LATIN CAPITAL LETTER Y WITH DIAERESIS " 
           "16r00A0"    16r00A0 " NO-BREAK SPACE " 
           "16r00A1"    16r0624 " ARABIC LETTER WAW WITH HAMZA ABOVE " 
           "16r00A2"    16r0625 " ARABIC LETTER ALEF WITH HAMZA BELOW " 
           "16r00A3"    16r00A3 " POUND SIGN " 
           "16r00A4"    16r00A4 " CURRENCY SIGN " 
           "16r00A5"    16r0626 " ARABIC LETTER YEH WITH HAMZA ABOVE " 
           "16r00A6"    16r00A6 " BROKEN BAR " 
           "16r00A7"    16r00A7 " SECTION SIGN " 
           "16r00A8"    16r0627 " ARABIC LETTER ALEF " 
           "16r00A9"    16r00A9 " COPYRIGHT SIGN " 
           "16r00AA"    16r0628 " ARABIC LETTER BEH " 
           "16r00AB"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00AC"    16r00AC " NOT SIGN " 
           "16r00AD"    16r00AD " SOFT HYPHEN " 
           "16r00AE"    16r00AE " REGISTERED SIGN " 
           "16r00AF"    16r067E " ARABIC LETTER PEH " 
           "16r00B0"    16r00B0 " DEGREE SIGN " 
           "16r00B1"    16r00B1 " PLUS-MINUS SIGN " 
           "16r00B2"    16r0629 " ARABIC LETTER TEH MARBUTA " 
           "16r00B3"    16r062A " ARABIC LETTER TEH " 
           "16r00B4"    16r062B " ARABIC LETTER THEH " 
           "16r00B5"    16r00B5 " MICRO SIGN " 
           "16r00B6"    16r00B6 " PILCROW SIGN " 
           "16r00B7"    16r00B7 " MIDDLE DOT " 
           "16r00B8"    16r062C " ARABIC LETTER JEEM " 
           "16r00B9"    16r0686 " ARABIC LETTER TCHEH " 
           "16r00BA"    16r062D " ARABIC LETTER HAH " 
           "16r00BB"    16r00BB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00BC"    16r062E " ARABIC LETTER KHAH " 
           "16r00BD"    16r062F " ARABIC LETTER DAL " 
           "16r00BE"    16r0630 " ARABIC LETTER THAL " 
           "16r00BF"    16r0631 " ARABIC LETTER REH " 
           "16r00C0"    16r00C0 " LATIN CAPITAL LETTER A WITH GRAVE " 
           "16r00C1"    16r0632 " ARABIC LETTER ZAIN " 
           "16r00C2"    16r00C2 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
           "16r00C3"    16r0698 " ARABIC LETTER JEH " 
           "16r00C4"    16r0633 " ARABIC LETTER SEEN " 
           "16r00C5"    16r0634 " ARABIC LETTER SHEEN " 
           "16r00C6"    16r0635 " ARABIC LETTER SAD " 
           "16r00C7"    16r00C7 " LATIN CAPITAL LETTER C WITH CEDILLA " 
           "16r00C8"    16r00C8 " LATIN CAPITAL LETTER E WITH GRAVE " 
           "16r00C9"    16r00C9 " LATIN CAPITAL LETTER E WITH ACUTE " 
           "16r00CA"    16r00CA " LATIN CAPITAL LETTER E WITH CIRCUMFLEX " 
           "16r00CB"    16r00CB " LATIN CAPITAL LETTER E WITH DIAERESIS " 
           "16r00CC"    16r0636 " ARABIC LETTER DAD " 
           "16r00CD"    16r0637 " ARABIC LETTER TAH " 
           "16r00CE"    16r00CE " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
           "16r00CF"    16r00CF " LATIN CAPITAL LETTER I WITH DIAERESIS " 
           "16r00D0"    16r3113 " BOPOMOFO LETTER ZH " 
           "16r00D1"    16r0639 " ARABIC LETTER AIN " 
           "16r00D2"    16r063A " ARABIC LETTER GHAIN " 
           "16r00D3"    16r0640 " ARABIC TATWEEL " 
           "16r00D4"    16r00D4 " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
           "16r00D5"    16r0641 " ARABIC LETTER FEH " 
           "16r00D6"    16r0642 " ARABIC LETTER QAF " 
           "16r00D7"    16r00D7 " MULTIPLICATION SIGN " 
           "16r00D8"    16r0643 " ARABIC LETTER KAF " 
           "16r00D9"    16r00D9 " LATIN CAPITAL LETTER U WITH GRAVE " 
           "16r00DA"    16r06AF " ARABIC LETTER GAF " 
           "16r00DB"    16r00DB " LATIN CAPITAL LETTER U WITH CIRCUMFLEX " 
           "16r00DC"    16r00DC " LATIN CAPITAL LETTER U WITH DIAERESIS " 
           "16r00DD"    16r0644 " ARABIC LETTER LAM " 
           "16r00DE"    16r0645 " ARABIC LETTER MEEM " 
           "16r00DF"    16r0646 " ARABIC LETTER NOON " 
           "16r00E0"    16r00E0 " LATIN SMALL LETTER A WITH GRAVE " 
           "16r00E1"    16r0647 " ARABIC LETTER HEH " 
           "16r00E2"    16r00E2 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
           "16r00E3"    16r0681 " ARABIC LETTER HAH WITH HAMZA ABOVE " 
           "16r00E4"    16r0648 " ARABIC LETTER WAW " 
           "16r00E5"    16r0649 " ARABIC LETTER ALEF MAKSURA " 
           "16r00E6"    16r064A " ARABIC LETTER YEH " 
           "16r00E7"    16r00E7 " LATIN SMALL LETTER C WITH CEDILLA " 
           "16r00E8"    16r00E8 " LATIN SMALL LETTER E WITH GRAVE " 
           "16r00E9"    16r00E9 " LATIN SMALL LETTER E WITH ACUTE " 
           "16r00EA"    16r00EA " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
           "16r00EB"    16r00EB " LATIN SMALL LETTER E WITH DIAERESIS " 
           "16r00EC"    16r064B " ARABIC FATHATAN " 
           "16r00ED"    16r064C " ARABIC DAMMATAN " 
           "16r00EE"    16r00EE " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
           "16r00EF"    16r00EF " LATIN SMALL LETTER I WITH DIAERESIS " 
           "16r00F0"    16r064D " ARABIC KASRATAN " 
           "16r00F1"    16r064E " ARABIC FATHA " 
           "16r00F2"    16r064F " ARABIC DAMMA " 
           "16r00F3"    16r0650 " ARABIC KASRA " 
           "16r00F4"    16r00F4 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
           "16r00F5"    16r0651 " ARABIC SHADDA " 
           "16r00F6"    16r0652 " ARABIC SUKUN " 
           "16r00F7"    16r00F7 " DIVISION SIGN " 
           "16r00F8"    16r0000 " invalid " 
           "16r00F9"    16r00F9 " LATIN SMALL LETTER U WITH GRAVE " 
           "16r00FA"    16r0000 " invalid " 
           "16r00FB"    16r00FB " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
           "16r00FC"    16r00FC " LATIN SMALL LETTER U WITH DIAERESIS " 
           "16r00FD"    16r200E " LEFT-TO-RIGHT MARK " 
           "16r00FE"    16r200F " RIGHT-TO-LEFT MARK " 
           "16r00FF"    16r00FF " LATIN SMALL LETTER Y WITH DIAERESIS " 
           ) at:(code - 16r7F).
        t == 0 ifFalse:[^ t].
        ^ self decodingError.
    ] value.
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode <= 16r7F ifTrue:[ ^ unicode ].
    unicode > 16r3113 ifTrue:[
        ^ self encodingError.
    ].
    unicode <= 16r9F ifTrue:[
        ^ self encodingError.
    ].
    unicode <= 16r6AF ifTrue:[
        unicode <= 16r178 ifTrue:[
            unicode <= 16rFF ifTrue:[
                    (#[
                       "16r00A0"    1 " NO-BREAK SPACE " 
                       "16r00A1"    0 " invalid " 
                       "16r00A2"    0 " invalid " 
                       "16r00A3"    1 " POUND SIGN " 
                       "16r00A4"    1 " CURRENCY SIGN " 
                       "16r00A5"    0 " invalid " 
                       "16r00A6"    1 " BROKEN BAR " 
                       "16r00A7"    1 " SECTION SIGN " 
                       "16r00A8"    0 " invalid " 
                       "16r00A9"    1 " COPYRIGHT SIGN " 
                       "16r00AA"    0 " invalid " 
                       "16r00AB"    1 " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                       "16r00AC"    1 " NOT SIGN " 
                       "16r00AD"    1 " SOFT HYPHEN " 
                       "16r00AE"    1 " REGISTERED SIGN " 
                       "16r00AF"    0 " invalid " 
                       "16r00B0"    1 " DEGREE SIGN " 
                       "16r00B1"    1 " PLUS-MINUS SIGN " 
                       "16r00B2"    0 " invalid " 
                       "16r00B3"    0 " invalid " 
                       "16r00B4"    0 " invalid " 
                       "16r00B5"    1 " MICRO SIGN " 
                       "16r00B6"    1 " PILCROW SIGN " 
                       "16r00B7"    1 " MIDDLE DOT " 
                       "16r00B8"    0 " invalid " 
                       "16r00B9"    0 " invalid " 
                       "16r00BA"    0 " invalid " 
                       "16r00BB"    1 " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                       "16r00BC"    0 " invalid " 
                       "16r00BD"    0 " invalid " 
                       "16r00BE"    0 " invalid " 
                       "16r00BF"    0 " invalid " 
                       "16r00C0"    1 " LATIN CAPITAL LETTER A WITH GRAVE " 
                       "16r00C1"    0 " invalid " 
                       "16r00C2"    1 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
                       "16r00C3"    0 " invalid " 
                       "16r00C4"    0 " invalid " 
                       "16r00C5"    0 " invalid " 
                       "16r00C6"    0 " invalid " 
                       "16r00C7"    1 " LATIN CAPITAL LETTER C WITH CEDILLA " 
                       "16r00C8"    1 " LATIN CAPITAL LETTER E WITH GRAVE " 
                       "16r00C9"    1 " LATIN CAPITAL LETTER E WITH ACUTE " 
                       "16r00CA"    1 " LATIN CAPITAL LETTER E WITH CIRCUMFLEX " 
                       "16r00CB"    1 " LATIN CAPITAL LETTER E WITH DIAERESIS " 
                       "16r00CC"    0 " invalid " 
                       "16r00CD"    0 " invalid " 
                       "16r00CE"    1 " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
                       "16r00CF"    1 " LATIN CAPITAL LETTER I WITH DIAERESIS " 
                       "16r00D0"    0 " invalid " 
                       "16r00D1"    0 " invalid " 
                       "16r00D2"    0 " invalid " 
                       "16r00D3"    0 " invalid " 
                       "16r00D4"    1 " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
                       "16r00D5"    0 " invalid " 
                       "16r00D6"    0 " invalid " 
                       "16r00D7"    1 " MULTIPLICATION SIGN " 
                       "16r00D8"    0 " invalid " 
                       "16r00D9"    1 " LATIN CAPITAL LETTER U WITH GRAVE " 
                       "16r00DA"    0 " invalid " 
                       "16r00DB"    1 " LATIN CAPITAL LETTER U WITH CIRCUMFLEX " 
                       "16r00DC"    1 " LATIN CAPITAL LETTER U WITH DIAERESIS " 
                       "16r00DD"    0 " invalid " 
                       "16r00DE"    0 " invalid " 
                       "16r00DF"    0 " invalid " 
                       "16r00E0"    1 " LATIN SMALL LETTER A WITH GRAVE " 
                       "16r00E1"    0 " invalid " 
                       "16r00E2"    1 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
                       "16r00E3"    0 " invalid " 
                       "16r00E4"    0 " invalid " 
                       "16r00E5"    0 " invalid " 
                       "16r00E6"    0 " invalid " 
                       "16r00E7"    1 " LATIN SMALL LETTER C WITH CEDILLA " 
                       "16r00E8"    1 " LATIN SMALL LETTER E WITH GRAVE " 
                       "16r00E9"    1 " LATIN SMALL LETTER E WITH ACUTE " 
                       "16r00EA"    1 " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
                       "16r00EB"    1 " LATIN SMALL LETTER E WITH DIAERESIS " 
                       "16r00EC"    0 " invalid " 
                       "16r00ED"    0 " invalid " 
                       "16r00EE"    1 " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
                       "16r00EF"    1 " LATIN SMALL LETTER I WITH DIAERESIS " 
                       "16r00F0"    0 " invalid " 
                       "16r00F1"    0 " invalid " 
                       "16r00F2"    0 " invalid " 
                       "16r00F3"    0 " invalid " 
                       "16r00F4"    1 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
                       "16r00F5"    0 " invalid " 
                       "16r00F6"    0 " invalid " 
                       "16r00F7"    1 " DIVISION SIGN " 
                       "16r00F8"    0 " invalid " 
                       "16r00F9"    1 " LATIN SMALL LETTER U WITH GRAVE " 
                       "16r00FA"    0 " invalid " 
                       "16r00FB"    1 " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
                       "16r00FC"    1 " LATIN SMALL LETTER U WITH DIAERESIS " 
                       "16r00FD"    0 " invalid " 
                       "16r00FE"    0 " invalid " 
                       "16r00FF"    1 " LATIN SMALL LETTER Y WITH DIAERESIS " 
                    ] at:(unicode - 159)) ~~ 0 ifTrue:[^ unicode].
                    ^ self encodingError.
            ].
            unicode <= 16r177 ifTrue:[
                ^ self encodingError.
            ].
            ^  "16r0178" 16r009F " LATIN CAPITAL LETTER Y WITH DIAERESIS " 
        ].
        unicode <= 16r60B ifTrue:[
            ^ self encodingError.
        ].
        [
            |t|
            t := #[
               "16r060C"    16r80 " ARABIC COMMA " 
               "16r060D"    16r00 " invalid " 
               "16r060E"    16r00 " invalid " 
               "16r060F"    16r00 " invalid " 
               "16r0610"    16r00 " invalid " 
               "16r0611"    16r00 " invalid " 
               "16r0612"    16r00 " invalid " 
               "16r0613"    16r00 " invalid " 
               "16r0614"    16r00 " invalid " 
               "16r0615"    16r00 " invalid " 
               "16r0616"    16r00 " invalid " 
               "16r0617"    16r00 " invalid " 
               "16r0618"    16r00 " invalid " 
               "16r0619"    16r00 " invalid " 
               "16r061A"    16r00 " invalid " 
               "16r061B"    16r98 " ARABIC SEMICOLON " 
               "16r061C"    16r00 " invalid " 
               "16r061D"    16r00 " invalid " 
               "16r061E"    16r00 " invalid " 
               "16r061F"    16r9A " ARABIC QUESTION MARK " 
               "16r0620"    16r00 " invalid " 
               "16r0621"    16r9C " ARABIC LETTER HAMZA " 
               "16r0622"    16r9D " ARABIC LETTER ALEF WITH MADDA ABOVE " 
               "16r0623"    16r9E " ARABIC LETTER ALEF WITH HAMZA ABOVE " 
               "16r0624"    16rA1 " ARABIC LETTER WAW WITH HAMZA ABOVE " 
               "16r0625"    16rA2 " ARABIC LETTER ALEF WITH HAMZA BELOW " 
               "16r0626"    16rA5 " ARABIC LETTER YEH WITH HAMZA ABOVE " 
               "16r0627"    16rA8 " ARABIC LETTER ALEF " 
               "16r0628"    16rAA " ARABIC LETTER BEH " 
               "16r0629"    16rB2 " ARABIC LETTER TEH MARBUTA " 
               "16r062A"    16rB3 " ARABIC LETTER TEH " 
               "16r062B"    16rB4 " ARABIC LETTER THEH " 
               "16r062C"    16rB8 " ARABIC LETTER JEEM " 
               "16r062D"    16rBA " ARABIC LETTER HAH " 
               "16r062E"    16rBC " ARABIC LETTER KHAH " 
               "16r062F"    16rBD " ARABIC LETTER DAL " 
               "16r0630"    16rBE " ARABIC LETTER THAL " 
               "16r0631"    16rBF " ARABIC LETTER REH " 
               "16r0632"    16rC1 " ARABIC LETTER ZAIN " 
               "16r0633"    16rC4 " ARABIC LETTER SEEN " 
               "16r0634"    16rC5 " ARABIC LETTER SHEEN " 
               "16r0635"    16rC6 " ARABIC LETTER SAD " 
               "16r0636"    16rCC " ARABIC LETTER DAD " 
               "16r0637"    16rCD " ARABIC LETTER TAH " 
               "16r0638"    16r00 " invalid " 
               "16r0639"    16rD1 " ARABIC LETTER AIN " 
               "16r063A"    16rD2 " ARABIC LETTER GHAIN " 
               "16r063B"    16r00 " invalid " 
               "16r063C"    16r00 " invalid " 
               "16r063D"    16r00 " invalid " 
               "16r063E"    16r00 " invalid " 
               "16r063F"    16r00 " invalid " 
               "16r0640"    16rD3 " ARABIC TATWEEL " 
               "16r0641"    16rD5 " ARABIC LETTER FEH " 
               "16r0642"    16rD6 " ARABIC LETTER QAF " 
               "16r0643"    16rD8 " ARABIC LETTER KAF " 
               "16r0644"    16rDD " ARABIC LETTER LAM " 
               "16r0645"    16rDE " ARABIC LETTER MEEM " 
               "16r0646"    16rDF " ARABIC LETTER NOON " 
               "16r0647"    16rE1 " ARABIC LETTER HEH " 
               "16r0648"    16rE4 " ARABIC LETTER WAW " 
               "16r0649"    16rE5 " ARABIC LETTER ALEF MAKSURA " 
               "16r064A"    16rE6 " ARABIC LETTER YEH " 
               "16r064B"    16rEC " ARABIC FATHATAN " 
               "16r064C"    16rED " ARABIC DAMMATAN " 
               "16r064D"    16rF0 " ARABIC KASRATAN " 
               "16r064E"    16rF1 " ARABIC FATHA " 
               "16r064F"    16rF2 " ARABIC DAMMA " 
               "16r0650"    16rF3 " ARABIC KASRA " 
               "16r0651"    16rF5 " ARABIC SHADDA " 
               "16r0652"    16rF6 " ARABIC SUKUN " 
               "16r0653"    16r00 " invalid " 
               "16r0654"    16r00 " invalid " 
               "16r0655"    16r00 " invalid " 
               "16r0656"    16r00 " invalid " 
               "16r0657"    16r00 " invalid " 
               "16r0658"    16r00 " invalid " 
               "16r0659"    16r00 " invalid " 
               "16r065A"    16r00 " invalid " 
               "16r065B"    16r00 " invalid " 
               "16r065C"    16r00 " invalid " 
               "16r065D"    16r00 " invalid " 
               "16r065E"    16r00 " invalid " 
               "16r065F"    16r00 " invalid " 
               "16r0660"    16r81 " ARABIC-INDIC DIGIT ZERO " 
               "16r0661"    16r83 " ARABIC-INDIC DIGIT ONE " 
               "16r0662"    16r88 " ARABIC-INDIC DIGIT TWO " 
               "16r0663"    16r89 " ARABIC-INDIC DIGIT THREE " 
               "16r0664"    16r8A " ARABIC-INDIC DIGIT FOUR " 
               "16r0665"    16r8C " ARABIC-INDIC DIGIT FIVE " 
               "16r0666"    16r8D " ARABIC-INDIC DIGIT SIX " 
               "16r0667"    16r8E " ARABIC-INDIC DIGIT SEVEN " 
               "16r0668"    16r8F " ARABIC-INDIC DIGIT EIGHT " 
               "16r0669"    16r90 " ARABIC-INDIC DIGIT NINE " 
               "16r066A"    16r00 " invalid " 
               "16r066B"    16r00 " invalid " 
               "16r066C"    16r00 " invalid " 
               "16r066D"    16r00 " invalid " 
               "16r066E"    16r00 " invalid " 
               "16r066F"    16r00 " invalid " 
               "16r0670"    16r00 " invalid " 
               "16r0671"    16r00 " invalid " 
               "16r0672"    16r00 " invalid " 
               "16r0673"    16r00 " invalid " 
               "16r0674"    16r00 " invalid " 
               "16r0675"    16r00 " invalid " 
               "16r0676"    16r00 " invalid " 
               "16r0677"    16r00 " invalid " 
               "16r0678"    16r00 " invalid " 
               "16r0679"    16r00 " invalid " 
               "16r067A"    16r00 " invalid " 
               "16r067B"    16r00 " invalid " 
               "16r067C"    16r00 " invalid " 
               "16r067D"    16r00 " invalid " 
               "16r067E"    16rAF " ARABIC LETTER PEH " 
               "16r067F"    16r00 " invalid " 
               "16r0680"    16r00 " invalid " 
               "16r0681"    16rE3 " ARABIC LETTER HAH WITH HAMZA ABOVE " 
               "16r0682"    16r00 " invalid " 
               "16r0683"    16r00 " invalid " 
               "16r0684"    16r00 " invalid " 
               "16r0685"    16r00 " invalid " 
               "16r0686"    16rB9 " ARABIC LETTER TCHEH " 
               "16r0687"    16r00 " invalid " 
               "16r0688"    16r00 " invalid " 
               "16r0689"    16r00 " invalid " 
               "16r068A"    16r00 " invalid " 
               "16r068B"    16r00 " invalid " 
               "16r068C"    16r00 " invalid " 
               "16r068D"    16r00 " invalid " 
               "16r068E"    16r00 " invalid " 
               "16r068F"    16r00 " invalid " 
               "16r0690"    16r00 " invalid " 
               "16r0691"    16r00 " invalid " 
               "16r0692"    16r00 " invalid " 
               "16r0693"    16r00 " invalid " 
               "16r0694"    16r00 " invalid " 
               "16r0695"    16r00 " invalid " 
               "16r0696"    16r00 " invalid " 
               "16r0697"    16r00 " invalid " 
               "16r0698"    16rC3 " ARABIC LETTER JEH " 
               "16r0699"    16r00 " invalid " 
               "16r069A"    16r00 " invalid " 
               "16r069B"    16r00 " invalid " 
               "16r069C"    16r00 " invalid " 
               "16r069D"    16r00 " invalid " 
               "16r069E"    16r00 " invalid " 
               "16r069F"    16r00 " invalid " 
               "16r06A0"    16r00 " invalid " 
               "16r06A1"    16r00 " invalid " 
               "16r06A2"    16r00 " invalid " 
               "16r06A3"    16r00 " invalid " 
               "16r06A4"    16r00 " invalid " 
               "16r06A5"    16r00 " invalid " 
               "16r06A6"    16r00 " invalid " 
               "16r06A7"    16r00 " invalid " 
               "16r06A8"    16r00 " invalid " 
               "16r06A9"    16r00 " invalid " 
               "16r06AA"    16r00 " invalid " 
               "16r06AB"    16r00 " invalid " 
               "16r06AC"    16r00 " invalid " 
               "16r06AD"    16r00 " invalid " 
               "16r06AE"    16r00 " invalid " 
               "16r06AF"    16rDA " ARABIC LETTER GAF " 
               ] at:(unicode - 16r60B).
            t == 0 ifFalse:[^ t].
            ^ self encodingError
        ] value.
    ].
    unicode <= 16r200D ifTrue:[
        ^ self encodingError.
    ].
    unicode <= 16r2122 ifTrue:[
        unicode <= 16r203A ifTrue:[
            unicode <= 16r2026 ifTrue:[
                [
                    |t|
                    t := #[
                       "16r200E"    16rFD " LEFT-TO-RIGHT MARK " 
                       "16r200F"    16rFE " RIGHT-TO-LEFT MARK " 
                       "16r2010"    16r00 " invalid " 
                       "16r2011"    16r00 " invalid " 
                       "16r2012"    16r00 " invalid " 
                       "16r2013"    16r96 " EN DASH " 
                       "16r2014"    16r97 " EM DASH " 
                       "16r2015"    16r00 " invalid " 
                       "16r2016"    16r00 " invalid " 
                       "16r2017"    16r00 " invalid " 
                       "16r2018"    16r91 " LEFT SINGLE QUOTATION MARK " 
                       "16r2019"    16r92 " RIGHT SINGLE QUOTATION MARK " 
                       "16r201A"    16r82 " SINGLE LOW-9 QUOTATION MARK " 
                       "16r201B"    16r00 " invalid " 
                       "16r201C"    16r93 " LEFT DOUBLE QUOTATION MARK " 
                       "16r201D"    16r94 " RIGHT DOUBLE QUOTATION MARK " 
                       "16r201E"    16r84 " DOUBLE LOW-9 QUOTATION MARK " 
                       "16r201F"    16r00 " invalid " 
                       "16r2020"    16r86 " DAGGER " 
                       "16r2021"    16r87 " DOUBLE DAGGER " 
                       "16r2022"    16r95 " BULLET " 
                       "16r2023"    16r00 " invalid " 
                       "16r2024"    16r00 " invalid " 
                       "16r2025"    16r00 " invalid " 
                       "16r2026"    16r85 " HORIZONTAL ELLIPSIS " 
                       ] at:(unicode - 16r200D).
                    t == 0 ifFalse:[^ t].
                    ^ self encodingError
                ] value.
            ].
            unicode <= 16r2038 ifTrue:[
                ^ self encodingError.
            ].
            ^ #[
               "16r2039"    16r8B " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
               "16r203A"    16r9B " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
               ] at:(unicode - 16r2038).
        ].
        unicode <= 16r2121 ifTrue:[
            ^ self encodingError.
        ].
        ^  "16r2122" 16r0099 " TRADE MARK SIGN " 
    ].
    unicode <= 16r3112 ifTrue:[
        ^ self encodingError.
    ].
    ^  "16r3113" 16r00D0 " BOPOMOFO LETTER ZH " 
! !

!MS_Arabic class methodsFor:'documentation'!

version
    ^ '$Id: CharacterEncoderImplementations__MS_Arabic.st 10842 2012-09-07 10:49:18Z vranyj1 $'
!

version_SVN
    ^ '$Id:: CharacterEncoderImplementations__MS_Arabic.st 10842 2012-09-07 10:49:18Z vranyj1                                       $'
! !
