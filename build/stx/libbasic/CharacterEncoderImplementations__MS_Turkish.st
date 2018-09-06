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

SingleByteEncoder subclass:#MS_Turkish
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!MS_Turkish class methodsFor:'documentation'!

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
    CP1258 / Microsoft Turkish

    [see with:]
        CharacterEncoderImplementations::MS_Turkish showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!MS_Turkish class methodsFor:'mapping'!

mapFileURL2_relativePathName
    ^ 'CP1258'

    "
     self generateCode
    "
!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/CP1254

<code_set_name> CP1254
<comment_char> %
<escape_char> /
% version: 1.0
% repertoiremap: mnemonic,ds
%  source: UNICODE 1.0

% alias MS-TURK
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
<.9>                   /x82   <U201A> SINGLE LOW-9 QUOTATION MARK
<f2>                   /x83   <U0192> LATIN SMALL LETTER F WITH HOOK
<:9>                   /x84   <U201E> DOUBLE LOW-9 QUOTATION MARK
<.3>                   /x85   <U2026> HORIZONTAL ELLIPSIS
<//->                  /x86   <U2020> DAGGER
<//=>                  /x87   <U2021> DOUBLE DAGGER
<1/>>                  /x88   <U02C6> MODIFIER LETTER CIRCUMFLEX ACCENT
<%0>                   /x89   <U2030> PER MILLE SIGN
<S<>                   /x8A   <U0160> LATIN CAPITAL LETTER S WITH CARON
<<1>                   /x8B   <U2039> SINGLE LEFT-POINTING ANGLE QUOTATION MARK
<OE>                   /x8C   <U0152> LATIN CAPITAL LIGATURE OE
<'6>                   /x91   <U2018> LEFT SINGLE QUOTATION MARK
<'9>                   /x92   <U2019> RIGHT SINGLE QUOTATION MARK
<'6>                   /x93   <U201C> LEFT DOUBLE QUOTATION MARK
<'9>                   /x94   <U201D> RIGHT DOUBLE QUOTATION MARK
<sb>                   /x95   <U2022> BULLET
<-N>                   /x96   <U2013> EN DASH
<-M>                   /x97   <U2014> EM DASH
<1?>                   /x98   <U02DC> SMALL TILDE
<TM>                   /x99   <U2122> TRADE MARK SIGN
<s<>                   /x9A   <U0161> LATIN SMALL LETTER S WITH CARON
</>1>                  /x9B   <U203A> SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
<oe>                   /x9C   <U0153> LATIN SMALL LIGATURE OE
<Y:>                   /x9F   <U0178> LATIN CAPITAL LETTER Y WITH DIAERESIS
<NS>                   /xA0   <U00A0> NO-BREAK SPACE
<!!I>                   /xA1   <U00A1> INVERTED EXCLAMATION MARK
<Ct>                   /xA2   <U00A2> CENT SIGN
<Pd>                   /xA3   <U00A3> POUND SIGN
<Cu>                   /xA4   <U00A4> CURRENCY SIGN
<Ye>                   /xA5   <U00A5> YEN SIGN
<BB>                   /xA6   <U00A6> BROKEN BAR
<SE>                   /xA7   <U00A7> SECTION SIGN
<':>                   /xA8   <U00A8> DIAERESIS
<Co>                   /xA9   <U00A9> COPYRIGHT SIGN
<-a>                   /xAA   <U00AA> FEMININE ORDINAL INDICATOR
<<<>                   /xAB   <U00AB> LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
<NO>                   /xAC   <U00AC> NOT SIGN
<-->                   /xAD   <U00AD> SOFT HYPHEN
<Rg>                   /xAE   <U00AE> REGISTERED SIGN
<'m>                   /xAF   <U00AF> MACRON
<DG>                   /xB0   <U00B0> DEGREE SIGN
<+->                   /xB1   <U00B1> PLUS-MINUS SIGN
<2S>                   /xB2   <U00B2> SUPERSCRIPT TWO
<3S>                   /xB3   <U00B3> SUPERSCRIPT THREE
<''>                   /xB4   <U00B4> ACUTE ACCENT
<My>                   /xB5   <U00B5> MICRO SIGN
<PI>                   /xB6   <U00B6> PILCROW SIGN
<.M>                   /xB7   <U00B7> MIDDLE DOT
<',>                   /xB8   <U00B8> CEDILLA
<1S>                   /xB9   <U00B9> SUPERSCRIPT ONE
<-o>                   /xBA   <U00BA> MASCULINE ORDINAL INDICATOR
</>/>>                 /xBB   <U00BB> RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
<14>                   /xBC   <U00BC> VULGAR FRACTION ONE QUARTER
<12>                   /xBD   <U00BD> VULGAR FRACTION ONE HALF
<34>                   /xBE   <U00BE> VULGAR FRACTION THREE QUARTERS
<?I>                   /xBF   <U00BF> INVERTED QUESTION MARK
<A!!>                   /xC0   <U00C0> LATIN CAPITAL LETTER A WITH GRAVE
<A'>                   /xC1   <U00C1> LATIN CAPITAL LETTER A WITH ACUTE
<A/>>                  /xC2   <U00C2> LATIN CAPITAL LETTER A WITH CIRCUMFLEX
<A?>                   /xC3   <U00C3> LATIN CAPITAL LETTER A WITH TILDE
<A:>                   /xC4   <U00C4> LATIN CAPITAL LETTER A WITH DIAERESIS
<AA>                   /xC5   <U00C5> LATIN CAPITAL LETTER A WITH RING ABOVE
<AE>                   /xC6   <U00C6> LATIN CAPITAL LETTER AE
<C,>                   /xC7   <U00C7> LATIN CAPITAL LETTER C WITH CEDILLA
<E!!>                   /xC8   <U00C8> LATIN CAPITAL LETTER E WITH GRAVE
<E'>                   /xC9   <U00C9> LATIN CAPITAL LETTER E WITH ACUTE
<E/>>                  /xCA   <U00CA> LATIN CAPITAL LETTER E WITH CIRCUMFLEX
<E:>                   /xCB   <U00CB> LATIN CAPITAL LETTER E WITH DIAERESIS
<I!!>                   /xCC   <U00CC> LATIN CAPITAL LETTER I WITH GRAVE
<I'>                   /xCD   <U00CD> LATIN CAPITAL LETTER I WITH ACUTE
<I/>>                  /xCE   <U00CE> LATIN CAPITAL LETTER I WITH CIRCUMFLEX
<I:>                   /xCF   <U00CF> LATIN CAPITAL LETTER I WITH DIAERESIS
<G(>                   /xD0   <U011E> LATIN CAPITAL LETTER G WITH BREVE
<N?>                   /xD1   <U00D1> LATIN CAPITAL LETTER N WITH TILDE
<O!!>                   /xD2   <U00D2> LATIN CAPITAL LETTER O WITH GRAVE
<O'>                   /xD3   <U00D3> LATIN CAPITAL LETTER O WITH ACUTE
<O/>>                  /xD4   <U00D4> LATIN CAPITAL LETTER O WITH CIRCUMFLEX
<O?>                   /xD5   <U00D5> LATIN CAPITAL LETTER O WITH TILDE
<O:>                   /xD6   <U00D6> LATIN CAPITAL LETTER O WITH DIAERESIS
<*X>                   /xD7   <U00D7> MULTIPLICATION SIGN
<O//>                  /xD8   <U00D8> LATIN CAPITAL LETTER O WITH STROKE
<U!!>                   /xD9   <U00D9> LATIN CAPITAL LETTER U WITH GRAVE
<U'>                   /xDA   <U00DA> LATIN CAPITAL LETTER U WITH ACUTE
<U/>>                  /xDB   <U00DB> LATIN CAPITAL LETTER U WITH CIRCUMFLEX
<U:>                   /xDC   <U00DC> LATIN CAPITAL LETTER U WITH DIAERESIS
<I.>                   /xDD   <U0130> LATIN CAPITAL LETTER I WITH DOT ABOVE
<S,>                   /xDE   <U015E> LATIN CAPITAL LETTER S WITH CEDILLA
<ss>                   /xDF   <U00DF> LATIN SMALL LETTER SHARP S (German)
<a!!>                   /xE0   <U00E0> LATIN SMALL LETTER A WITH GRAVE
<a'>                   /xE1   <U00E1> LATIN SMALL LETTER A WITH ACUTE
<a/>>                  /xE2   <U00E2> LATIN SMALL LETTER A WITH CIRCUMFLEX
<a?>                   /xE3   <U00E3> LATIN SMALL LETTER A WITH TILDE
<a:>                   /xE4   <U00E4> LATIN SMALL LETTER A WITH DIAERESIS
<aa>                   /xE5   <U00E5> LATIN SMALL LETTER A WITH RING ABOVE
<ae>                   /xE6   <U00E6> LATIN SMALL LETTER AE
<c,>                   /xE7   <U00E7> LATIN SMALL LETTER C WITH CEDILLA
<e!!>                   /xE8   <U00E8> LATIN SMALL LETTER E WITH GRAVE
<e'>                   /xE9   <U00E9> LATIN SMALL LETTER E WITH ACUTE
<e;>                   /xEA   <U0119> LATIN SMALL LETTER E WITH OGONEK
<e:>                   /xEB   <U00EB> LATIN SMALL LETTER E WITH DIAERESIS
<e.>                   /xEC   <U0117> LATIN SMALL LETTER E WITH DOT ABOVE
<i'>                   /xED   <U00ED> LATIN SMALL LETTER I WITH ACUTE
<i/>>                  /xEE   <U00EE> LATIN SMALL LETTER I WITH CIRCUMFLEX
<i->                   /xEF   <U012B> LATIN SMALL LETTER I WITH MACRON
<g(>                   /xF0   <U011F> LATIN SMALL LETTER G WITH BREVE
<n?>                   /xF1   <U00F1> LATIN SMALL LETTER N WITH TILDE
<o!!>                   /xF2   <U00F2> LATIN SMALL LETTER O WITH GRAVE
<o'>                   /xF3   <U00F3> LATIN SMALL LETTER O WITH ACUTE
<o/>>                  /xF4   <U00F4> LATIN SMALL LETTER O WITH CIRCUMFLEX
<o?>                   /xF5   <U00F5> LATIN SMALL LETTER O WITH TILDE
<o:>                   /xF6   <U00F6> LATIN SMALL LETTER O WITH DIAERESIS
<-:>                   /xF7   <U00F7> DIVISION SIGN
<o//>                  /xF8   <U00F8> LATIN SMALL LETTER O WITH STROKE
<u!!>                   /xF9   <U00F9> LATIN SMALL LETTER U WITH GRAVE
<u'>                   /xFA   <U00FA> LATIN SMALL LETTER U WITH ACUTE
<u/>>                  /xFB   <U00FB> LATIN SMALL LETTER U WITH CIRCUMFLEX
<u:>                   /xFC   <U00FC> LATIN SMALL LETTER U WITH DIAERESIS
<i.>                   /xFD   <U0131> LATIN SMALL LETTER DOTLESS I
<s,>                   /xFE   <U015F> LATIN SMALL LETTER S WITH CEDILLA
<y:>                   /xFF   <U00FF> LATIN SMALL LETTER Y WITH DIAERESIS
END CHARMAP

"
! !

!MS_Turkish methodsFor:'encoding & decoding'!

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
           "16r0080"    16r0000 " invalid " 
           "16r0081"    16r0000 " invalid " 
           "16r0082"    16r201A " SINGLE LOW-9 QUOTATION MARK " 
           "16r0083"    16r0192 " LATIN SMALL LETTER F WITH HOOK " 
           "16r0084"    16r201E " DOUBLE LOW-9 QUOTATION MARK " 
           "16r0085"    16r2026 " HORIZONTAL ELLIPSIS " 
           "16r0086"    16r2020 " DAGGER " 
           "16r0087"    16r2021 " DOUBLE DAGGER " 
           "16r0088"    16r02C6 " MODIFIER LETTER CIRCUMFLEX ACCENT " 
           "16r0089"    16r2030 " PER MILLE SIGN " 
           "16r008A"    16r0160 " LATIN CAPITAL LETTER S WITH CARON " 
           "16r008B"    16r2039 " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
           "16r008C"    16r0152 " LATIN CAPITAL LIGATURE OE " 
           "16r008D"    16r0000 " invalid " 
           "16r008E"    16r0000 " invalid " 
           "16r008F"    16r0000 " invalid " 
           "16r0090"    16r0000 " invalid " 
           "16r0091"    16r2018 " LEFT SINGLE QUOTATION MARK " 
           "16r0092"    16r2019 " RIGHT SINGLE QUOTATION MARK " 
           "16r0093"    16r201C " LEFT DOUBLE QUOTATION MARK " 
           "16r0094"    16r201D " RIGHT DOUBLE QUOTATION MARK " 
           "16r0095"    16r2022 " BULLET " 
           "16r0096"    16r2013 " EN DASH " 
           "16r0097"    16r2014 " EM DASH " 
           "16r0098"    16r02DC " SMALL TILDE " 
           "16r0099"    16r2122 " TRADE MARK SIGN " 
           "16r009A"    16r0161 " LATIN SMALL LETTER S WITH CARON " 
           "16r009B"    16r203A " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
           "16r009C"    16r0153 " LATIN SMALL LIGATURE OE " 
           "16r009D"    16r0000 " invalid " 
           "16r009E"    16r0000 " invalid " 
           "16r009F"    16r0178 " LATIN CAPITAL LETTER Y WITH DIAERESIS " 
           "16r00A0"    16r00A0 " NO-BREAK SPACE " 
           "16r00A1"    16r00A1 " INVERTED EXCLAMATION MARK " 
           "16r00A2"    16r00A2 " CENT SIGN " 
           "16r00A3"    16r00A3 " POUND SIGN " 
           "16r00A4"    16r00A4 " CURRENCY SIGN " 
           "16r00A5"    16r00A5 " YEN SIGN " 
           "16r00A6"    16r00A6 " BROKEN BAR " 
           "16r00A7"    16r00A7 " SECTION SIGN " 
           "16r00A8"    16r00A8 " DIAERESIS " 
           "16r00A9"    16r00A9 " COPYRIGHT SIGN " 
           "16r00AA"    16r00AA " FEMININE ORDINAL INDICATOR " 
           "16r00AB"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00AC"    16r00AC " NOT SIGN " 
           "16r00AD"    16r00AD " SOFT HYPHEN " 
           "16r00AE"    16r00AE " REGISTERED SIGN " 
           "16r00AF"    16r00AF " MACRON " 
           "16r00B0"    16r00B0 " DEGREE SIGN " 
           "16r00B1"    16r00B1 " PLUS-MINUS SIGN " 
           "16r00B2"    16r00B2 " SUPERSCRIPT TWO " 
           "16r00B3"    16r00B3 " SUPERSCRIPT THREE " 
           "16r00B4"    16r00B4 " ACUTE ACCENT " 
           "16r00B5"    16r00B5 " MICRO SIGN " 
           "16r00B6"    16r00B6 " PILCROW SIGN " 
           "16r00B7"    16r00B7 " MIDDLE DOT " 
           "16r00B8"    16r00B8 " CEDILLA " 
           "16r00B9"    16r00B9 " SUPERSCRIPT ONE " 
           "16r00BA"    16r00BA " MASCULINE ORDINAL INDICATOR " 
           "16r00BB"    16r00BB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00BC"    16r00BC " VULGAR FRACTION ONE QUARTER " 
           "16r00BD"    16r00BD " VULGAR FRACTION ONE HALF " 
           "16r00BE"    16r00BE " VULGAR FRACTION THREE QUARTERS " 
           "16r00BF"    16r00BF " INVERTED QUESTION MARK " 
           "16r00C0"    16r00C0 " LATIN CAPITAL LETTER A WITH GRAVE " 
           "16r00C1"    16r00C1 " LATIN CAPITAL LETTER A WITH ACUTE " 
           "16r00C2"    16r00C2 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
           "16r00C3"    16r00C3 " LATIN CAPITAL LETTER A WITH TILDE " 
           "16r00C4"    16r00C4 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
           "16r00C5"    16r00C5 " LATIN CAPITAL LETTER A WITH RING ABOVE " 
           "16r00C6"    16r00C6 " LATIN CAPITAL LETTER AE " 
           "16r00C7"    16r00C7 " LATIN CAPITAL LETTER C WITH CEDILLA " 
           "16r00C8"    16r00C8 " LATIN CAPITAL LETTER E WITH GRAVE " 
           "16r00C9"    16r00C9 " LATIN CAPITAL LETTER E WITH ACUTE " 
           "16r00CA"    16r00CA " LATIN CAPITAL LETTER E WITH CIRCUMFLEX " 
           "16r00CB"    16r00CB " LATIN CAPITAL LETTER E WITH DIAERESIS " 
           "16r00CC"    16r00CC " LATIN CAPITAL LETTER I WITH GRAVE " 
           "16r00CD"    16r00CD " LATIN CAPITAL LETTER I WITH ACUTE " 
           "16r00CE"    16r00CE " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
           "16r00CF"    16r00CF " LATIN CAPITAL LETTER I WITH DIAERESIS " 
           "16r00D0"    16r011E " LATIN CAPITAL LETTER G WITH BREVE " 
           "16r00D1"    16r00D1 " LATIN CAPITAL LETTER N WITH TILDE " 
           "16r00D2"    16r00D2 " LATIN CAPITAL LETTER O WITH GRAVE " 
           "16r00D3"    16r00D3 " LATIN CAPITAL LETTER O WITH ACUTE " 
           "16r00D4"    16r00D4 " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
           "16r00D5"    16r00D5 " LATIN CAPITAL LETTER O WITH TILDE " 
           "16r00D6"    16r00D6 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
           "16r00D7"    16r00D7 " MULTIPLICATION SIGN " 
           "16r00D8"    16r00D8 " LATIN CAPITAL LETTER O WITH STROKE " 
           "16r00D9"    16r00D9 " LATIN CAPITAL LETTER U WITH GRAVE " 
           "16r00DA"    16r00DA " LATIN CAPITAL LETTER U WITH ACUTE " 
           "16r00DB"    16r00DB " LATIN CAPITAL LETTER U WITH CIRCUMFLEX " 
           "16r00DC"    16r00DC " LATIN CAPITAL LETTER U WITH DIAERESIS " 
           "16r00DD"    16r0130 " LATIN CAPITAL LETTER I WITH DOT ABOVE " 
           "16r00DE"    16r015E " LATIN CAPITAL LETTER S WITH CEDILLA " 
           "16r00DF"    16r00DF " LATIN SMALL LETTER SHARP S (German) " 
           "16r00E0"    16r00E0 " LATIN SMALL LETTER A WITH GRAVE " 
           "16r00E1"    16r00E1 " LATIN SMALL LETTER A WITH ACUTE " 
           "16r00E2"    16r00E2 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
           "16r00E3"    16r00E3 " LATIN SMALL LETTER A WITH TILDE " 
           "16r00E4"    16r00E4 " LATIN SMALL LETTER A WITH DIAERESIS " 
           "16r00E5"    16r00E5 " LATIN SMALL LETTER A WITH RING ABOVE " 
           "16r00E6"    16r00E6 " LATIN SMALL LETTER AE " 
           "16r00E7"    16r00E7 " LATIN SMALL LETTER C WITH CEDILLA " 
           "16r00E8"    16r00E8 " LATIN SMALL LETTER E WITH GRAVE " 
           "16r00E9"    16r00E9 " LATIN SMALL LETTER E WITH ACUTE " 
           "16r00EA"    16r0119 " LATIN SMALL LETTER E WITH OGONEK " 
           "16r00EB"    16r00EB " LATIN SMALL LETTER E WITH DIAERESIS " 
           "16r00EC"    16r0117 " LATIN SMALL LETTER E WITH DOT ABOVE " 
           "16r00ED"    16r00ED " LATIN SMALL LETTER I WITH ACUTE " 
           "16r00EE"    16r00EE " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
           "16r00EF"    16r012B " LATIN SMALL LETTER I WITH MACRON " 
           "16r00F0"    16r011F " LATIN SMALL LETTER G WITH BREVE " 
           "16r00F1"    16r00F1 " LATIN SMALL LETTER N WITH TILDE " 
           "16r00F2"    16r00F2 " LATIN SMALL LETTER O WITH GRAVE " 
           "16r00F3"    16r00F3 " LATIN SMALL LETTER O WITH ACUTE " 
           "16r00F4"    16r00F4 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
           "16r00F5"    16r00F5 " LATIN SMALL LETTER O WITH TILDE " 
           "16r00F6"    16r00F6 " LATIN SMALL LETTER O WITH DIAERESIS " 
           "16r00F7"    16r00F7 " DIVISION SIGN " 
           "16r00F8"    16r00F8 " LATIN SMALL LETTER O WITH STROKE " 
           "16r00F9"    16r00F9 " LATIN SMALL LETTER U WITH GRAVE " 
           "16r00FA"    16r00FA " LATIN SMALL LETTER U WITH ACUTE " 
           "16r00FB"    16r00FB " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
           "16r00FC"    16r00FC " LATIN SMALL LETTER U WITH DIAERESIS " 
           "16r00FD"    16r0131 " LATIN SMALL LETTER DOTLESS I " 
           "16r00FE"    16r015F " LATIN SMALL LETTER S WITH CEDILLA " 
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
    unicode > 16r2122 ifTrue:[
        ^ self encodingError.
    ].
    unicode <= 16r9F ifTrue:[
        ^ self encodingError
    ].
    unicode <= 16r2DC ifTrue:[
        unicode <= 16r192 ifTrue:[
            unicode <= 16r116 ifTrue:[
                (#[
                   "16r00A0"    1 " NO-BREAK SPACE " 
                   "16r00A1"    1 " INVERTED EXCLAMATION MARK " 
                   "16r00A2"    1 " CENT SIGN " 
                   "16r00A3"    1 " POUND SIGN " 
                   "16r00A4"    1 " CURRENCY SIGN " 
                   "16r00A5"    1 " YEN SIGN " 
                   "16r00A6"    1 " BROKEN BAR " 
                   "16r00A7"    1 " SECTION SIGN " 
                   "16r00A8"    1 " DIAERESIS " 
                   "16r00A9"    1 " COPYRIGHT SIGN " 
                   "16r00AA"    1 " FEMININE ORDINAL INDICATOR " 
                   "16r00AB"    1 " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                   "16r00AC"    1 " NOT SIGN " 
                   "16r00AD"    1 " SOFT HYPHEN " 
                   "16r00AE"    1 " REGISTERED SIGN " 
                   "16r00AF"    1 " MACRON " 
                   "16r00B0"    1 " DEGREE SIGN " 
                   "16r00B1"    1 " PLUS-MINUS SIGN " 
                   "16r00B2"    1 " SUPERSCRIPT TWO " 
                   "16r00B3"    1 " SUPERSCRIPT THREE " 
                   "16r00B4"    1 " ACUTE ACCENT " 
                   "16r00B5"    1 " MICRO SIGN " 
                   "16r00B6"    1 " PILCROW SIGN " 
                   "16r00B7"    1 " MIDDLE DOT " 
                   "16r00B8"    1 " CEDILLA " 
                   "16r00B9"    1 " SUPERSCRIPT ONE " 
                   "16r00BA"    1 " MASCULINE ORDINAL INDICATOR " 
                   "16r00BB"    1 " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                   "16r00BC"    1 " VULGAR FRACTION ONE QUARTER " 
                   "16r00BD"    1 " VULGAR FRACTION ONE HALF " 
                   "16r00BE"    1 " VULGAR FRACTION THREE QUARTERS " 
                   "16r00BF"    1 " INVERTED QUESTION MARK " 
                   "16r00C0"    1 " LATIN CAPITAL LETTER A WITH GRAVE " 
                   "16r00C1"    1 " LATIN CAPITAL LETTER A WITH ACUTE " 
                   "16r00C2"    1 " LATIN CAPITAL LETTER A WITH CIRCUMFLEX " 
                   "16r00C3"    1 " LATIN CAPITAL LETTER A WITH TILDE " 
                   "16r00C4"    1 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
                   "16r00C5"    1 " LATIN CAPITAL LETTER A WITH RING ABOVE " 
                   "16r00C6"    1 " LATIN CAPITAL LETTER AE " 
                   "16r00C7"    1 " LATIN CAPITAL LETTER C WITH CEDILLA " 
                   "16r00C8"    1 " LATIN CAPITAL LETTER E WITH GRAVE " 
                   "16r00C9"    1 " LATIN CAPITAL LETTER E WITH ACUTE " 
                   "16r00CA"    1 " LATIN CAPITAL LETTER E WITH CIRCUMFLEX " 
                   "16r00CB"    1 " LATIN CAPITAL LETTER E WITH DIAERESIS " 
                   "16r00CC"    1 " LATIN CAPITAL LETTER I WITH GRAVE " 
                   "16r00CD"    1 " LATIN CAPITAL LETTER I WITH ACUTE " 
                   "16r00CE"    1 " LATIN CAPITAL LETTER I WITH CIRCUMFLEX " 
                   "16r00CF"    1 " LATIN CAPITAL LETTER I WITH DIAERESIS " 
                   "16r00D0"    0 " invalid " 
                   "16r00D1"    1 " LATIN CAPITAL LETTER N WITH TILDE " 
                   "16r00D2"    1 " LATIN CAPITAL LETTER O WITH GRAVE " 
                   "16r00D3"    1 " LATIN CAPITAL LETTER O WITH ACUTE " 
                   "16r00D4"    1 " LATIN CAPITAL LETTER O WITH CIRCUMFLEX " 
                   "16r00D5"    1 " LATIN CAPITAL LETTER O WITH TILDE " 
                   "16r00D6"    1 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
                   "16r00D7"    1 " MULTIPLICATION SIGN " 
                   "16r00D8"    1 " LATIN CAPITAL LETTER O WITH STROKE " 
                   "16r00D9"    1 " LATIN CAPITAL LETTER U WITH GRAVE " 
                   "16r00DA"    1 " LATIN CAPITAL LETTER U WITH ACUTE " 
                   "16r00DB"    1 " LATIN CAPITAL LETTER U WITH CIRCUMFLEX " 
                   "16r00DC"    1 " LATIN CAPITAL LETTER U WITH DIAERESIS " 
                   "16r00DD"    0 " invalid " 
                   "16r00DE"    0 " invalid " 
                   "16r00DF"    1 " LATIN SMALL LETTER SHARP S (German) " 
                   "16r00E0"    1 " LATIN SMALL LETTER A WITH GRAVE " 
                   "16r00E1"    1 " LATIN SMALL LETTER A WITH ACUTE " 
                   "16r00E2"    1 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
                   "16r00E3"    1 " LATIN SMALL LETTER A WITH TILDE " 
                   "16r00E4"    1 " LATIN SMALL LETTER A WITH DIAERESIS " 
                   "16r00E5"    1 " LATIN SMALL LETTER A WITH RING ABOVE " 
                   "16r00E6"    1 " LATIN SMALL LETTER AE " 
                   "16r00E7"    1 " LATIN SMALL LETTER C WITH CEDILLA " 
                   "16r00E8"    1 " LATIN SMALL LETTER E WITH GRAVE " 
                   "16r00E9"    1 " LATIN SMALL LETTER E WITH ACUTE " 
                   "16r00EA"    0 " invalid " 
                   "16r00EB"    1 " LATIN SMALL LETTER E WITH DIAERESIS " 
                   "16r00EC"    0 " invalid " 
                   "16r00ED"    1 " LATIN SMALL LETTER I WITH ACUTE " 
                   "16r00EE"    1 " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
                   "16r00EF"    0 " invalid " 
                   "16r00F0"    0 " invalid " 
                   "16r00F1"    1 " LATIN SMALL LETTER N WITH TILDE " 
                   "16r00F2"    1 " LATIN SMALL LETTER O WITH GRAVE " 
                   "16r00F3"    1 " LATIN SMALL LETTER O WITH ACUTE " 
                   "16r00F4"    1 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
                   "16r00F5"    1 " LATIN SMALL LETTER O WITH TILDE " 
                   "16r00F6"    1 " LATIN SMALL LETTER O WITH DIAERESIS " 
                   "16r00F7"    1 " DIVISION SIGN " 
                   "16r00F8"    1 " LATIN SMALL LETTER O WITH STROKE " 
                   "16r00F9"    1 " LATIN SMALL LETTER U WITH GRAVE " 
                   "16r00FA"    1 " LATIN SMALL LETTER U WITH ACUTE " 
                   "16r00FB"    1 " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
                   "16r00FC"    1 " LATIN SMALL LETTER U WITH DIAERESIS " 
                   "16r00FD"    0 " invalid " 
                   "16r00FE"    0 " invalid " 
                   "16r00FF"    1 " LATIN SMALL LETTER Y WITH DIAERESIS " 
                   "16r0100"    0 " invalid " 
                   "16r0101"    0 " invalid " 
                   "16r0102"    0 " invalid " 
                   "16r0103"    0 " invalid " 
                   "16r0104"    0 " invalid " 
                   "16r0105"    0 " invalid " 
                   "16r0106"    0 " invalid " 
                   "16r0107"    0 " invalid " 
                   "16r0108"    0 " invalid " 
                   "16r0109"    0 " invalid " 
                   "16r010A"    0 " invalid " 
                   "16r010B"    0 " invalid " 
                   "16r010C"    0 " invalid " 
                   "16r010D"    0 " invalid " 
                   "16r010E"    0 " invalid " 
                   "16r010F"    0 " invalid " 
                   "16r0110"    0 " invalid " 
                   "16r0111"    0 " invalid " 
                   "16r0112"    0 " invalid " 
                   "16r0113"    0 " invalid " 
                   "16r0114"    0 " invalid " 
                   "16r0115"    0 " invalid " 
                   "16r0116"    0 " invalid " 
                ] at:(unicode - 159)) ~~ 0 ifTrue:[^ unicode].
                ^ self encodingError
            ].
            [
                |t|
                t := #[
                   "16r0117"    16rEC " LATIN SMALL LETTER E WITH DOT ABOVE " 
                   "16r0118"    16r00 " invalid " 
                   "16r0119"    16rEA " LATIN SMALL LETTER E WITH OGONEK " 
                   "16r011A"    16r00 " invalid " 
                   "16r011B"    16r00 " invalid " 
                   "16r011C"    16r00 " invalid " 
                   "16r011D"    16r00 " invalid " 
                   "16r011E"    16rD0 " LATIN CAPITAL LETTER G WITH BREVE " 
                   "16r011F"    16rF0 " LATIN SMALL LETTER G WITH BREVE " 
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
                   "16r012B"    16rEF " LATIN SMALL LETTER I WITH MACRON " 
                   "16r012C"    16r00 " invalid " 
                   "16r012D"    16r00 " invalid " 
                   "16r012E"    16r00 " invalid " 
                   "16r012F"    16r00 " invalid " 
                   "16r0130"    16rDD " LATIN CAPITAL LETTER I WITH DOT ABOVE " 
                   "16r0131"    16rFD " LATIN SMALL LETTER DOTLESS I " 
                   "16r0132"    16r00 " invalid " 
                   "16r0133"    16r00 " invalid " 
                   "16r0134"    16r00 " invalid " 
                   "16r0135"    16r00 " invalid " 
                   "16r0136"    16r00 " invalid " 
                   "16r0137"    16r00 " invalid " 
                   "16r0138"    16r00 " invalid " 
                   "16r0139"    16r00 " invalid " 
                   "16r013A"    16r00 " invalid " 
                   "16r013B"    16r00 " invalid " 
                   "16r013C"    16r00 " invalid " 
                   "16r013D"    16r00 " invalid " 
                   "16r013E"    16r00 " invalid " 
                   "16r013F"    16r00 " invalid " 
                   "16r0140"    16r00 " invalid " 
                   "16r0141"    16r00 " invalid " 
                   "16r0142"    16r00 " invalid " 
                   "16r0143"    16r00 " invalid " 
                   "16r0144"    16r00 " invalid " 
                   "16r0145"    16r00 " invalid " 
                   "16r0146"    16r00 " invalid " 
                   "16r0147"    16r00 " invalid " 
                   "16r0148"    16r00 " invalid " 
                   "16r0149"    16r00 " invalid " 
                   "16r014A"    16r00 " invalid " 
                   "16r014B"    16r00 " invalid " 
                   "16r014C"    16r00 " invalid " 
                   "16r014D"    16r00 " invalid " 
                   "16r014E"    16r00 " invalid " 
                   "16r014F"    16r00 " invalid " 
                   "16r0150"    16r00 " invalid " 
                   "16r0151"    16r00 " invalid " 
                   "16r0152"    16r8C " LATIN CAPITAL LIGATURE OE " 
                   "16r0153"    16r9C " LATIN SMALL LIGATURE OE " 
                   "16r0154"    16r00 " invalid " 
                   "16r0155"    16r00 " invalid " 
                   "16r0156"    16r00 " invalid " 
                   "16r0157"    16r00 " invalid " 
                   "16r0158"    16r00 " invalid " 
                   "16r0159"    16r00 " invalid " 
                   "16r015A"    16r00 " invalid " 
                   "16r015B"    16r00 " invalid " 
                   "16r015C"    16r00 " invalid " 
                   "16r015D"    16r00 " invalid " 
                   "16r015E"    16rDE " LATIN CAPITAL LETTER S WITH CEDILLA " 
                   "16r015F"    16rFE " LATIN SMALL LETTER S WITH CEDILLA " 
                   "16r0160"    16r8A " LATIN CAPITAL LETTER S WITH CARON " 
                   "16r0161"    16r9A " LATIN SMALL LETTER S WITH CARON " 
                   "16r0162"    16r00 " invalid " 
                   "16r0163"    16r00 " invalid " 
                   "16r0164"    16r00 " invalid " 
                   "16r0165"    16r00 " invalid " 
                   "16r0166"    16r00 " invalid " 
                   "16r0167"    16r00 " invalid " 
                   "16r0168"    16r00 " invalid " 
                   "16r0169"    16r00 " invalid " 
                   "16r016A"    16r00 " invalid " 
                   "16r016B"    16r00 " invalid " 
                   "16r016C"    16r00 " invalid " 
                   "16r016D"    16r00 " invalid " 
                   "16r016E"    16r00 " invalid " 
                   "16r016F"    16r00 " invalid " 
                   "16r0170"    16r00 " invalid " 
                   "16r0171"    16r00 " invalid " 
                   "16r0172"    16r00 " invalid " 
                   "16r0173"    16r00 " invalid " 
                   "16r0174"    16r00 " invalid " 
                   "16r0175"    16r00 " invalid " 
                   "16r0176"    16r00 " invalid " 
                   "16r0177"    16r00 " invalid " 
                   "16r0178"    16r9F " LATIN CAPITAL LETTER Y WITH DIAERESIS " 
                   "16r0179"    16r00 " invalid " 
                   "16r017A"    16r00 " invalid " 
                   "16r017B"    16r00 " invalid " 
                   "16r017C"    16r00 " invalid " 
                   "16r017D"    16r00 " invalid " 
                   "16r017E"    16r00 " invalid " 
                   "16r017F"    16r00 " invalid " 
                   "16r0180"    16r00 " invalid " 
                   "16r0181"    16r00 " invalid " 
                   "16r0182"    16r00 " invalid " 
                   "16r0183"    16r00 " invalid " 
                   "16r0184"    16r00 " invalid " 
                   "16r0185"    16r00 " invalid " 
                   "16r0186"    16r00 " invalid " 
                   "16r0187"    16r00 " invalid " 
                   "16r0188"    16r00 " invalid " 
                   "16r0189"    16r00 " invalid " 
                   "16r018A"    16r00 " invalid " 
                   "16r018B"    16r00 " invalid " 
                   "16r018C"    16r00 " invalid " 
                   "16r018D"    16r00 " invalid " 
                   "16r018E"    16r00 " invalid " 
                   "16r018F"    16r00 " invalid " 
                   "16r0190"    16r00 " invalid " 
                   "16r0191"    16r00 " invalid " 
                   "16r0192"    16r83 " LATIN SMALL LETTER F WITH HOOK " 
                   ] at:(unicode - 16r116).
                t == 0 ifFalse:[^ t].
                ^ self encodingError
            ] value.
        ].
        unicode <= 16r2C5 ifTrue:[
            ^ self encodingError
        ].
        unicode == 16r2C6 ifTrue:[
            ^  "16r02C6" 16r0088 " MODIFIER LETTER CIRCUMFLEX ACCENT " 
        ].
        unicode <= 16r2DB ifTrue:[
            ^ self encodingError
        ].
        ^  "16r02DC" 16r0098 " SMALL TILDE " 
    ].
    unicode <= 16r2012 ifTrue:[
        ^ self encodingError
    ].
    unicode <= 16r203A ifTrue:[
        [
            |t|
            t := #[
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
               "16r2027"    16r00 " invalid " 
               "16r2028"    16r00 " invalid " 
               "16r2029"    16r00 " invalid " 
               "16r202A"    16r00 " invalid " 
               "16r202B"    16r00 " invalid " 
               "16r202C"    16r00 " invalid " 
               "16r202D"    16r00 " invalid " 
               "16r202E"    16r00 " invalid " 
               "16r202F"    16r00 " invalid " 
               "16r2030"    16r89 " PER MILLE SIGN " 
               "16r2031"    16r00 " invalid " 
               "16r2032"    16r00 " invalid " 
               "16r2033"    16r00 " invalid " 
               "16r2034"    16r00 " invalid " 
               "16r2035"    16r00 " invalid " 
               "16r2036"    16r00 " invalid " 
               "16r2037"    16r00 " invalid " 
               "16r2038"    16r00 " invalid " 
               "16r2039"    16r8B " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
               "16r203A"    16r9B " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
               ] at:(unicode - 16r2012).
            t == 0 ifFalse:[^ t].
            ^ self encodingError
        ] value.
    ].
    unicode <= 16r2121 ifTrue:[
        ^ self encodingError
    ].
    ^  "16r2122" 16r0099 " TRADE MARK SIGN " 
! !

!MS_Turkish class methodsFor:'documentation'!

version
    ^ '$Id: CharacterEncoderImplementations__MS_Turkish.st 10842 2012-09-07 10:49:18Z vranyj1 $'
!

version_SVN
    ^ '$Id:: CharacterEncoderImplementations__MS_Turkish.st 10842 2012-09-07 10:49:18Z vranyj1                                      $'
! !
