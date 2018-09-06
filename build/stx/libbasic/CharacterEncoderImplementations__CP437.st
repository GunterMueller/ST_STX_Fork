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

SingleByteEncoder subclass:#CP437
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!CP437 class methodsFor:'documentation'!

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
    CodePage 437 / MSDOS Latin US.

    [see with:]
        CharacterEncoderImplementations::CP437 showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!CP437 class methodsFor:'encoding & decoding'!

mapFileURL2_relativePathName
    ^ 'CP437'

    "
     self generateCode
    "
! !

!CP437 class methodsFor:'mapping'!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/CP437

<code_set_name> IBM437
<comment_char> %
<escape_char> /
% version: 1.0
% repertoiremap: mnemonic,ds
%  source: IBM NLS RM Vol2 SE09-8002-01, March 1990

% alias CP437
% alias 437
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
<C,>                   /x80   <U00C7> LATIN CAPITAL LETTER C WITH CEDILLA
<u:>                   /x81   <U00FC> LATIN SMALL LETTER U WITH DIAERESIS
<e'>                   /x82   <U00E9> LATIN SMALL LETTER E WITH ACUTE
<a/>>                  /x83   <U00E2> LATIN SMALL LETTER A WITH CIRCUMFLEX
<a:>                   /x84   <U00E4> LATIN SMALL LETTER A WITH DIAERESIS
<a!!>                   /x85   <U00E0> LATIN SMALL LETTER A WITH GRAVE
<aa>                   /x86   <U00E5> LATIN SMALL LETTER A WITH RING ABOVE
<c,>                   /x87   <U00E7> LATIN SMALL LETTER C WITH CEDILLA
<e/>>                  /x88   <U00EA> LATIN SMALL LETTER E WITH CIRCUMFLEX
<e:>                   /x89   <U00EB> LATIN SMALL LETTER E WITH DIAERESIS
<e!!>                   /x8A   <U00E8> LATIN SMALL LETTER E WITH GRAVE
<i:>                   /x8B   <U00EF> LATIN SMALL LETTER I WITH DIAERESIS
<i/>>                  /x8C   <U00EE> LATIN SMALL LETTER I WITH CIRCUMFLEX
<i!!>                   /x8D   <U00EC> LATIN SMALL LETTER I WITH GRAVE
<A:>                   /x8E   <U00C4> LATIN CAPITAL LETTER A WITH DIAERESIS
<AA>                   /x8F   <U00C5> LATIN CAPITAL LETTER A WITH RING ABOVE
<E'>                   /x90   <U00C9> LATIN CAPITAL LETTER E WITH ACUTE
<ae>                   /x91   <U00E6> LATIN SMALL LETTER AE
<AE>                   /x92   <U00C6> LATIN CAPITAL LETTER AE
<o/>>                  /x93   <U00F4> LATIN SMALL LETTER O WITH CIRCUMFLEX
<o:>                   /x94   <U00F6> LATIN SMALL LETTER O WITH DIAERESIS
<o!!>                   /x95   <U00F2> LATIN SMALL LETTER O WITH GRAVE
<u/>>                  /x96   <U00FB> LATIN SMALL LETTER U WITH CIRCUMFLEX
<u!!>                   /x97   <U00F9> LATIN SMALL LETTER U WITH GRAVE
<y:>                   /x98   <U00FF> LATIN SMALL LETTER Y WITH DIAERESIS
<O:>                   /x99   <U00D6> LATIN CAPITAL LETTER O WITH DIAERESIS
<U:>                   /x9A   <U00DC> LATIN CAPITAL LETTER U WITH DIAERESIS
<Ct>                   /x9B   <U00A2> CENT SIGN
<Pd>                   /x9C   <U00A3> POUND SIGN
<Ye>                   /x9D   <U00A5> YEN SIGN
<Pt>                   /x9E   <U20A7> PESETA SIGN
<f2>                   /x9F   <U0192> LATIN SMALL LETTER F WITH HOOK
<a'>                   /xA0   <U00E1> LATIN SMALL LETTER A WITH ACUTE
<i'>                   /xA1   <U00ED> LATIN SMALL LETTER I WITH ACUTE
<o'>                   /xA2   <U00F3> LATIN SMALL LETTER O WITH ACUTE
<u'>                   /xA3   <U00FA> LATIN SMALL LETTER U WITH ACUTE
<n?>                   /xA4   <U00F1> LATIN SMALL LETTER N WITH TILDE
<N?>                   /xA5   <U00D1> LATIN CAPITAL LETTER N WITH TILDE
<-a>                   /xA6   <U00AA> FEMININE ORDINAL INDICATOR
<-o>                   /xA7   <U00BA> MASCULINE ORDINAL INDICATOR
<?I>                   /xA8   <U00BF> INVERTED QUESTION MARK
<NI>                   /xA9   <U2310> REVERSED NOT SIGN
<NO>                   /xAA   <U00AC> NOT SIGN
<12>                   /xAB   <U00BD> VULGAR FRACTION ONE HALF
<14>                   /xAC   <U00BC> VULGAR FRACTION ONE QUARTER
<!!I>                   /xAD   <U00A1> INVERTED EXCLAMATION MARK
<<<>                   /xAE   <U00AB> LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
</>/>>                 /xAF   <U00BB> RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
<.S>                   /xB0   <U2591> LIGHT SHADE
<:S>                   /xB1   <U2592> MEDIUM SHADE
<?S>                   /xB2   <U2593> DARK SHADE
<vv>                   /xB3   <U2502> BOX DRAWINGS LIGHT VERTICAL
<vl>                   /xB4   <U2524> BOX DRAWINGS LIGHT VERTICAL AND LEFT
<vL>                   /xB5   <U2561> BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE
<Vl>                   /xB6   <U2562> BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE
<Dl>                   /xB7   <U2556> BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE
<dL>                   /xB8   <U2555> BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE
<VL>                   /xB9   <U2563> BOX DRAWINGS DOUBLE VERTICAL AND LEFT
<VV>                   /xBA   <U2551> BOX DRAWINGS DOUBLE VERTICAL
<LD>                   /xBB   <U2557> BOX DRAWINGS DOUBLE DOWN AND LEFT
<UL>                   /xBC   <U255D> BOX DRAWINGS DOUBLE UP AND LEFT
<Ul>                   /xBD   <U255C> BOX DRAWINGS UP DOUBLE AND LEFT SINGLE
<uL>                   /xBE   <U255B> BOX DRAWINGS UP SINGLE AND LEFT DOUBLE
<dl>                   /xBF   <U2510> BOX DRAWINGS LIGHT DOWN AND LEFT
<ur>                   /xC0   <U2514> BOX DRAWINGS LIGHT UP AND RIGHT
<uh>                   /xC1   <U2534> BOX DRAWINGS LIGHT UP AND HORIZONTAL
<dh>                   /xC2   <U252C> BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
<vr>                   /xC3   <U251C> BOX DRAWINGS LIGHT VERTICAL AND RIGHT
<hh>                   /xC4   <U2500> BOX DRAWINGS LIGHT HORIZONTAL
<vh>                   /xC5   <U253C> BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
<vR>                   /xC6   <U255E> BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE
<Vr>                   /xC7   <U255F> BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE
<UR>                   /xC8   <U255A> BOX DRAWINGS DOUBLE UP AND RIGHT
<DR>                   /xC9   <U2554> BOX DRAWINGS DOUBLE DOWN AND RIGHT
<UH>                   /xCA   <U2569> BOX DRAWINGS DOUBLE UP AND HORIZONTAL
<DH>                   /xCB   <U2566> BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL
<VR>                   /xCC   <U2560> BOX DRAWINGS DOUBLE VERTICAL AND RIGHT
<HH>                   /xCD   <U2550> BOX DRAWINGS DOUBLE HORIZONTAL
<VH>                   /xCE   <U256C> BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL
<uH>                   /xCF   <U2567> BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE
<Uh>                   /xD0   <U2568> BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE
<dH>                   /xD1   <U2564> BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE
<Dh>                   /xD2   <U2565> BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE
<Ur>                   /xD3   <U2559> BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE
<uR>                   /xD4   <U2558> BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE
<dR>                   /xD5   <U2552> BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE
<Dr>                   /xD6   <U2553> BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE
<Vh>                   /xD7   <U256B> BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE
<vH>                   /xD8   <U256A> BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE
<ul>                   /xD9   <U2518> BOX DRAWINGS LIGHT UP AND LEFT
<dr>                   /xDA   <U250C> BOX DRAWINGS LIGHT DOWN AND RIGHT
<FB>                   /xDB   <U2588> FULL BLOCK
<LB>                   /xDC   <U2584> LOWER HALF BLOCK
<lB>                   /xDD   <U258C> LEFT HALF BLOCK
<RB>                   /xDE   <U2590> RIGHT HALF BLOCK
<TB>                   /xDF   <U2580> UPPER HALF BLOCK
<a*>                   /xE0   <U03B1> GREEK SMALL LETTER ALPHA
<ss>                   /xE1   <U00DF> LATIN SMALL LETTER SHARP S (German)
<G*>                   /xE2   <U0393> GREEK CAPITAL LETTER GAMMA
<p*>                   /xE3   <U03C0> GREEK SMALL LETTER PI
<S*>                   /xE4   <U03A3> GREEK CAPITAL LETTER SIGMA
<s*>                   /xE5   <U03C3> GREEK SMALL LETTER SIGMA
<My>                   /xE6   <U00B5> MICRO SIGN
<t*>                   /xE7   <U03C4> GREEK SMALL LETTER TAU
<F*>                   /xE8   <U03A6> GREEK CAPITAL LETTER PHI
<H*>                   /xE9   <U0398> GREEK CAPITAL LETTER THETA
<W*>                   /xEA   <U03A9> GREEK CAPITAL LETTER OMEGA
<d*>                   /xEB   <U03B4> GREEK SMALL LETTER DELTA
<00>                   /xEC   <U221E> INFINITY
<f*>                   /xED   <U03C6> GREEK SMALL LETTER PHI
<e*>                   /xEE   <U03B5> GREEK SMALL LETTER EPSILON
<(U>                   /xEF   <U2229> INTERSECTION
<=3>                   /xF0   <U2261> IDENTICAL TO
<+->                   /xF1   <U00B1> PLUS-MINUS SIGN
</>=>                  /xF2   <U2265> GREATER-THAN OR EQUAL TO
<=<>                   /xF3   <U2264> LESS-THAN OR EQUAL TO
<Iu>                   /xF4   <U2320> TOP HALF INTEGRAL
<Il>                   /xF5   <U2321> BOTTOM HALF INTEGRAL
<-:>                   /xF6   <U00F7> DIVISION SIGN
<?2>                   /xF7   <U2248> ALMOST EQUAL TO
<DG>                   /xF8   <U00B0> DEGREE SIGN
<.M>                   /xF9   <U00B7> MIDDLE DOT
<sb>                   /xFA   <U2022> BULLET
<RT>                   /xFB   <U221A> SQUARE ROOT
<nS>                   /xFC   <U207F> SUPERSCRIPT LATIN SMALL LETTER N
<2S>                   /xFD   <U00B2> SUPERSCRIPT TWO
<fS>                   /xFE   <U25A0> BLACK SQUARE
<NS>                   /xFF   <U00A0> NO-BREAK SPACE
END CHARMAP

"
! !

!CP437 methodsFor:'encoding & decoding'!

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
       "16r0080"    16r00C7 " LATIN CAPITAL LETTER C WITH CEDILLA " 
       "16r0081"    16r00FC " LATIN SMALL LETTER U WITH DIAERESIS " 
       "16r0082"    16r00E9 " LATIN SMALL LETTER E WITH ACUTE " 
       "16r0083"    16r00E2 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
       "16r0084"    16r00E4 " LATIN SMALL LETTER A WITH DIAERESIS " 
       "16r0085"    16r00E0 " LATIN SMALL LETTER A WITH GRAVE " 
       "16r0086"    16r00E5 " LATIN SMALL LETTER A WITH RING ABOVE " 
       "16r0087"    16r00E7 " LATIN SMALL LETTER C WITH CEDILLA " 
       "16r0088"    16r00EA " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
       "16r0089"    16r00EB " LATIN SMALL LETTER E WITH DIAERESIS " 
       "16r008A"    16r00E8 " LATIN SMALL LETTER E WITH GRAVE " 
       "16r008B"    16r00EF " LATIN SMALL LETTER I WITH DIAERESIS " 
       "16r008C"    16r00EE " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
       "16r008D"    16r00EC " LATIN SMALL LETTER I WITH GRAVE " 
       "16r008E"    16r00C4 " LATIN CAPITAL LETTER A WITH DIAERESIS " 
       "16r008F"    16r00C5 " LATIN CAPITAL LETTER A WITH RING ABOVE " 
       "16r0090"    16r00C9 " LATIN CAPITAL LETTER E WITH ACUTE " 
       "16r0091"    16r00E6 " LATIN SMALL LETTER AE " 
       "16r0092"    16r00C6 " LATIN CAPITAL LETTER AE " 
       "16r0093"    16r00F4 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
       "16r0094"    16r00F6 " LATIN SMALL LETTER O WITH DIAERESIS " 
       "16r0095"    16r00F2 " LATIN SMALL LETTER O WITH GRAVE " 
       "16r0096"    16r00FB " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
       "16r0097"    16r00F9 " LATIN SMALL LETTER U WITH GRAVE " 
       "16r0098"    16r00FF " LATIN SMALL LETTER Y WITH DIAERESIS " 
       "16r0099"    16r00D6 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
       "16r009A"    16r00DC " LATIN CAPITAL LETTER U WITH DIAERESIS " 
       "16r009B"    16r00A2 " CENT SIGN " 
       "16r009C"    16r00A3 " POUND SIGN " 
       "16r009D"    16r00A5 " YEN SIGN " 
       "16r009E"    16r20A7 " PESETA SIGN " 
       "16r009F"    16r0192 " LATIN SMALL LETTER F WITH HOOK " 
       "16r00A0"    16r00E1 " LATIN SMALL LETTER A WITH ACUTE " 
       "16r00A1"    16r00ED " LATIN SMALL LETTER I WITH ACUTE " 
       "16r00A2"    16r00F3 " LATIN SMALL LETTER O WITH ACUTE " 
       "16r00A3"    16r00FA " LATIN SMALL LETTER U WITH ACUTE " 
       "16r00A4"    16r00F1 " LATIN SMALL LETTER N WITH TILDE " 
       "16r00A5"    16r00D1 " LATIN CAPITAL LETTER N WITH TILDE " 
       "16r00A6"    16r00AA " FEMININE ORDINAL INDICATOR " 
       "16r00A7"    16r00BA " MASCULINE ORDINAL INDICATOR " 
       "16r00A8"    16r00BF " INVERTED QUESTION MARK " 
       "16r00A9"    16r2310 " REVERSED NOT SIGN " 
       "16r00AA"    16r00AC " NOT SIGN " 
       "16r00AB"    16r00BD " VULGAR FRACTION ONE HALF " 
       "16r00AC"    16r00BC " VULGAR FRACTION ONE QUARTER " 
       "16r00AD"    16r00A1 " INVERTED EXCLAMATION MARK " 
       "16r00AE"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
       "16r00AF"    16r00BB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
       "16r00B0"    16r2591 " LIGHT SHADE " 
       "16r00B1"    16r2592 " MEDIUM SHADE " 
       "16r00B2"    16r2593 " DARK SHADE " 
       "16r00B3"    16r2502 " BOX DRAWINGS LIGHT VERTICAL " 
       "16r00B4"    16r2524 " BOX DRAWINGS LIGHT VERTICAL AND LEFT " 
       "16r00B5"    16r2561 " BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE " 
       "16r00B6"    16r2562 " BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE " 
       "16r00B7"    16r2556 " BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE " 
       "16r00B8"    16r2555 " BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE " 
       "16r00B9"    16r2563 " BOX DRAWINGS DOUBLE VERTICAL AND LEFT " 
       "16r00BA"    16r2551 " BOX DRAWINGS DOUBLE VERTICAL " 
       "16r00BB"    16r2557 " BOX DRAWINGS DOUBLE DOWN AND LEFT " 
       "16r00BC"    16r255D " BOX DRAWINGS DOUBLE UP AND LEFT " 
       "16r00BD"    16r255C " BOX DRAWINGS UP DOUBLE AND LEFT SINGLE " 
       "16r00BE"    16r255B " BOX DRAWINGS UP SINGLE AND LEFT DOUBLE " 
       "16r00BF"    16r2510 " BOX DRAWINGS LIGHT DOWN AND LEFT " 
       "16r00C0"    16r2514 " BOX DRAWINGS LIGHT UP AND RIGHT " 
       "16r00C1"    16r2534 " BOX DRAWINGS LIGHT UP AND HORIZONTAL " 
       "16r00C2"    16r252C " BOX DRAWINGS LIGHT DOWN AND HORIZONTAL " 
       "16r00C3"    16r251C " BOX DRAWINGS LIGHT VERTICAL AND RIGHT " 
       "16r00C4"    16r2500 " BOX DRAWINGS LIGHT HORIZONTAL " 
       "16r00C5"    16r253C " BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL " 
       "16r00C6"    16r255E " BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE " 
       "16r00C7"    16r255F " BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE " 
       "16r00C8"    16r255A " BOX DRAWINGS DOUBLE UP AND RIGHT " 
       "16r00C9"    16r2554 " BOX DRAWINGS DOUBLE DOWN AND RIGHT " 
       "16r00CA"    16r2569 " BOX DRAWINGS DOUBLE UP AND HORIZONTAL " 
       "16r00CB"    16r2566 " BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL " 
       "16r00CC"    16r2560 " BOX DRAWINGS DOUBLE VERTICAL AND RIGHT " 
       "16r00CD"    16r2550 " BOX DRAWINGS DOUBLE HORIZONTAL " 
       "16r00CE"    16r256C " BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL " 
       "16r00CF"    16r2567 " BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE " 
       "16r00D0"    16r2568 " BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE " 
       "16r00D1"    16r2564 " BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE " 
       "16r00D2"    16r2565 " BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE " 
       "16r00D3"    16r2559 " BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE " 
       "16r00D4"    16r2558 " BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE " 
       "16r00D5"    16r2552 " BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE " 
       "16r00D6"    16r2553 " BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE " 
       "16r00D7"    16r256B " BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE " 
       "16r00D8"    16r256A " BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE " 
       "16r00D9"    16r2518 " BOX DRAWINGS LIGHT UP AND LEFT " 
       "16r00DA"    16r250C " BOX DRAWINGS LIGHT DOWN AND RIGHT " 
       "16r00DB"    16r2588 " FULL BLOCK " 
       "16r00DC"    16r2584 " LOWER HALF BLOCK " 
       "16r00DD"    16r258C " LEFT HALF BLOCK " 
       "16r00DE"    16r2590 " RIGHT HALF BLOCK " 
       "16r00DF"    16r2580 " UPPER HALF BLOCK " 
       "16r00E0"    16r03B1 " GREEK SMALL LETTER ALPHA " 
       "16r00E1"    16r00DF " LATIN SMALL LETTER SHARP S (German) " 
       "16r00E2"    16r0393 " GREEK CAPITAL LETTER GAMMA " 
       "16r00E3"    16r03C0 " GREEK SMALL LETTER PI " 
       "16r00E4"    16r03A3 " GREEK CAPITAL LETTER SIGMA " 
       "16r00E5"    16r03C3 " GREEK SMALL LETTER SIGMA " 
       "16r00E6"    16r00B5 " MICRO SIGN " 
       "16r00E7"    16r03C4 " GREEK SMALL LETTER TAU " 
       "16r00E8"    16r03A6 " GREEK CAPITAL LETTER PHI " 
       "16r00E9"    16r0398 " GREEK CAPITAL LETTER THETA " 
       "16r00EA"    16r03A9 " GREEK CAPITAL LETTER OMEGA " 
       "16r00EB"    16r03B4 " GREEK SMALL LETTER DELTA " 
       "16r00EC"    16r221E " INFINITY " 
       "16r00ED"    16r03C6 " GREEK SMALL LETTER PHI " 
       "16r00EE"    16r03B5 " GREEK SMALL LETTER EPSILON " 
       "16r00EF"    16r2229 " INTERSECTION " 
       "16r00F0"    16r2261 " IDENTICAL TO " 
       "16r00F1"    16r00B1 " PLUS-MINUS SIGN " 
       "16r00F2"    16r2265 " GREATER-THAN OR EQUAL TO " 
       "16r00F3"    16r2264 " LESS-THAN OR EQUAL TO " 
       "16r00F4"    16r2320 " TOP HALF INTEGRAL " 
       "16r00F5"    16r2321 " BOTTOM HALF INTEGRAL " 
       "16r00F6"    16r00F7 " DIVISION SIGN " 
       "16r00F7"    16r2248 " ALMOST EQUAL TO " 
       "16r00F8"    16r00B0 " DEGREE SIGN " 
       "16r00F9"    16r00B7 " MIDDLE DOT " 
       "16r00FA"    16r2022 " BULLET " 
       "16r00FB"    16r221A " SQUARE ROOT " 
       "16r00FC"    16r207F " SUPERSCRIPT LATIN SMALL LETTER N " 
       "16r00FD"    16r00B2 " SUPERSCRIPT TWO " 
       "16r00FE"    16r25A0 " BLACK SQUARE " 
       "16r00FF"    16r00A0 " NO-BREAK SPACE " 
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
        ^ self encodingError
    ].
    unicode <= 16r3C6 ifTrue:[
        unicode <= 16r192 ifTrue:[
            unicode <= 16rFF ifTrue:[
                [
                    |t|
                    t := #[
                       "16r00A0"    16rFF " NO-BREAK SPACE " 
                       "16r00A1"    16rAD " INVERTED EXCLAMATION MARK " 
                       "16r00A2"    16r9B " CENT SIGN " 
                       "16r00A3"    16r9C " POUND SIGN " 
                       "16r00A4"    16r00 " invalid " 
                       "16r00A5"    16r9D " YEN SIGN " 
                       "16r00A6"    16r00 " invalid " 
                       "16r00A7"    16r00 " invalid " 
                       "16r00A8"    16r00 " invalid " 
                       "16r00A9"    16r00 " invalid " 
                       "16r00AA"    16rA6 " FEMININE ORDINAL INDICATOR " 
                       "16r00AB"    16rAE " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                       "16r00AC"    16rAA " NOT SIGN " 
                       "16r00AD"    16r00 " invalid " 
                       "16r00AE"    16r00 " invalid " 
                       "16r00AF"    16r00 " invalid " 
                       "16r00B0"    16rF8 " DEGREE SIGN " 
                       "16r00B1"    16rF1 " PLUS-MINUS SIGN " 
                       "16r00B2"    16rFD " SUPERSCRIPT TWO " 
                       "16r00B3"    16r00 " invalid " 
                       "16r00B4"    16r00 " invalid " 
                       "16r00B5"    16rE6 " MICRO SIGN " 
                       "16r00B6"    16r00 " invalid " 
                       "16r00B7"    16rF9 " MIDDLE DOT " 
                       "16r00B8"    16r00 " invalid " 
                       "16r00B9"    16r00 " invalid " 
                       "16r00BA"    16rA7 " MASCULINE ORDINAL INDICATOR " 
                       "16r00BB"    16rAF " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                       "16r00BC"    16rAC " VULGAR FRACTION ONE QUARTER " 
                       "16r00BD"    16rAB " VULGAR FRACTION ONE HALF " 
                       "16r00BE"    16r00 " invalid " 
                       "16r00BF"    16rA8 " INVERTED QUESTION MARK " 
                       "16r00C0"    16r00 " invalid " 
                       "16r00C1"    16r00 " invalid " 
                       "16r00C2"    16r00 " invalid " 
                       "16r00C3"    16r00 " invalid " 
                       "16r00C4"    16r8E " LATIN CAPITAL LETTER A WITH DIAERESIS " 
                       "16r00C5"    16r8F " LATIN CAPITAL LETTER A WITH RING ABOVE " 
                       "16r00C6"    16r92 " LATIN CAPITAL LETTER AE " 
                       "16r00C7"    16r80 " LATIN CAPITAL LETTER C WITH CEDILLA " 
                       "16r00C8"    16r00 " invalid " 
                       "16r00C9"    16r90 " LATIN CAPITAL LETTER E WITH ACUTE " 
                       "16r00CA"    16r00 " invalid " 
                       "16r00CB"    16r00 " invalid " 
                       "16r00CC"    16r00 " invalid " 
                       "16r00CD"    16r00 " invalid " 
                       "16r00CE"    16r00 " invalid " 
                       "16r00CF"    16r00 " invalid " 
                       "16r00D0"    16r00 " invalid " 
                       "16r00D1"    16rA5 " LATIN CAPITAL LETTER N WITH TILDE " 
                       "16r00D2"    16r00 " invalid " 
                       "16r00D3"    16r00 " invalid " 
                       "16r00D4"    16r00 " invalid " 
                       "16r00D5"    16r00 " invalid " 
                       "16r00D6"    16r99 " LATIN CAPITAL LETTER O WITH DIAERESIS " 
                       "16r00D7"    16r00 " invalid " 
                       "16r00D8"    16r00 " invalid " 
                       "16r00D9"    16r00 " invalid " 
                       "16r00DA"    16r00 " invalid " 
                       "16r00DB"    16r00 " invalid " 
                       "16r00DC"    16r9A " LATIN CAPITAL LETTER U WITH DIAERESIS " 
                       "16r00DD"    16r00 " invalid " 
                       "16r00DE"    16r00 " invalid " 
                       "16r00DF"    16rE1 " LATIN SMALL LETTER SHARP S (German) " 
                       "16r00E0"    16r85 " LATIN SMALL LETTER A WITH GRAVE " 
                       "16r00E1"    16rA0 " LATIN SMALL LETTER A WITH ACUTE " 
                       "16r00E2"    16r83 " LATIN SMALL LETTER A WITH CIRCUMFLEX " 
                       "16r00E3"    16r00 " invalid " 
                       "16r00E4"    16r84 " LATIN SMALL LETTER A WITH DIAERESIS " 
                       "16r00E5"    16r86 " LATIN SMALL LETTER A WITH RING ABOVE " 
                       "16r00E6"    16r91 " LATIN SMALL LETTER AE " 
                       "16r00E7"    16r87 " LATIN SMALL LETTER C WITH CEDILLA " 
                       "16r00E8"    16r8A " LATIN SMALL LETTER E WITH GRAVE " 
                       "16r00E9"    16r82 " LATIN SMALL LETTER E WITH ACUTE " 
                       "16r00EA"    16r88 " LATIN SMALL LETTER E WITH CIRCUMFLEX " 
                       "16r00EB"    16r89 " LATIN SMALL LETTER E WITH DIAERESIS " 
                       "16r00EC"    16r8D " LATIN SMALL LETTER I WITH GRAVE " 
                       "16r00ED"    16rA1 " LATIN SMALL LETTER I WITH ACUTE " 
                       "16r00EE"    16r8C " LATIN SMALL LETTER I WITH CIRCUMFLEX " 
                       "16r00EF"    16r8B " LATIN SMALL LETTER I WITH DIAERESIS " 
                       "16r00F0"    16r00 " invalid " 
                       "16r00F1"    16rA4 " LATIN SMALL LETTER N WITH TILDE " 
                       "16r00F2"    16r95 " LATIN SMALL LETTER O WITH GRAVE " 
                       "16r00F3"    16rA2 " LATIN SMALL LETTER O WITH ACUTE " 
                       "16r00F4"    16r93 " LATIN SMALL LETTER O WITH CIRCUMFLEX " 
                       "16r00F5"    16r00 " invalid " 
                       "16r00F6"    16r94 " LATIN SMALL LETTER O WITH DIAERESIS " 
                       "16r00F7"    16rF6 " DIVISION SIGN " 
                       "16r00F8"    16r00 " invalid " 
                       "16r00F9"    16r97 " LATIN SMALL LETTER U WITH GRAVE " 
                       "16r00FA"    16rA3 " LATIN SMALL LETTER U WITH ACUTE " 
                       "16r00FB"    16r96 " LATIN SMALL LETTER U WITH CIRCUMFLEX " 
                       "16r00FC"    16r81 " LATIN SMALL LETTER U WITH DIAERESIS " 
                       "16r00FD"    16r00 " invalid " 
                       "16r00FE"    16r00 " invalid " 
                       "16r00FF"    16r98 " LATIN SMALL LETTER Y WITH DIAERESIS " 
                       ] at:(unicode - 16r9F).
                    t == 0 ifFalse:[^ t].
                    ^ self encodingError
                ] value.
            ].
            unicode <= 16r191 ifTrue:[
                ^ self encodingError
            ].
            ^  "16r0192" 16r009F " LATIN SMALL LETTER F WITH HOOK " 
        ].
        unicode <= 16r392 ifTrue:[
            ^ self encodingError
        ].
        [
            |t|
            t := #[
               "16r0393"    16rE2 " GREEK CAPITAL LETTER GAMMA " 
               "16r0394"    16r00 " invalid " 
               "16r0395"    16r00 " invalid " 
               "16r0396"    16r00 " invalid " 
               "16r0397"    16r00 " invalid " 
               "16r0398"    16rE9 " GREEK CAPITAL LETTER THETA " 
               "16r0399"    16r00 " invalid " 
               "16r039A"    16r00 " invalid " 
               "16r039B"    16r00 " invalid " 
               "16r039C"    16r00 " invalid " 
               "16r039D"    16r00 " invalid " 
               "16r039E"    16r00 " invalid " 
               "16r039F"    16r00 " invalid " 
               "16r03A0"    16r00 " invalid " 
               "16r03A1"    16r00 " invalid " 
               "16r03A2"    16r00 " invalid " 
               "16r03A3"    16rE4 " GREEK CAPITAL LETTER SIGMA " 
               "16r03A4"    16r00 " invalid " 
               "16r03A5"    16r00 " invalid " 
               "16r03A6"    16rE8 " GREEK CAPITAL LETTER PHI " 
               "16r03A7"    16r00 " invalid " 
               "16r03A8"    16r00 " invalid " 
               "16r03A9"    16rEA " GREEK CAPITAL LETTER OMEGA " 
               "16r03AA"    16r00 " invalid " 
               "16r03AB"    16r00 " invalid " 
               "16r03AC"    16r00 " invalid " 
               "16r03AD"    16r00 " invalid " 
               "16r03AE"    16r00 " invalid " 
               "16r03AF"    16r00 " invalid " 
               "16r03B0"    16r00 " invalid " 
               "16r03B1"    16rE0 " GREEK SMALL LETTER ALPHA " 
               "16r03B2"    16r00 " invalid " 
               "16r03B3"    16r00 " invalid " 
               "16r03B4"    16rEB " GREEK SMALL LETTER DELTA " 
               "16r03B5"    16rEE " GREEK SMALL LETTER EPSILON " 
               "16r03B6"    16r00 " invalid " 
               "16r03B7"    16r00 " invalid " 
               "16r03B8"    16r00 " invalid " 
               "16r03B9"    16r00 " invalid " 
               "16r03BA"    16r00 " invalid " 
               "16r03BB"    16r00 " invalid " 
               "16r03BC"    16r00 " invalid " 
               "16r03BD"    16r00 " invalid " 
               "16r03BE"    16r00 " invalid " 
               "16r03BF"    16r00 " invalid " 
               "16r03C0"    16rE3 " GREEK SMALL LETTER PI " 
               "16r03C1"    16r00 " invalid " 
               "16r03C2"    16r00 " invalid " 
               "16r03C3"    16rE5 " GREEK SMALL LETTER SIGMA " 
               "16r03C4"    16rE7 " GREEK SMALL LETTER TAU " 
               "16r03C5"    16r00 " invalid " 
               "16r03C6"    16rED " GREEK SMALL LETTER PHI " 
               ] at:(unicode - 16r392).
            t == 0 ifFalse:[^ t].
            ^ self encodingError
        ] value.
    ].
    unicode <= 16r2021 ifTrue:[
        ^ self encodingError
    ].
    unicode <= 16r2321 ifTrue:[
        unicode <= 16r20A7 ifTrue:[
            unicode == 16r2022 ifTrue:[
                ^  "16r2022" 16r00FA " BULLET " 
            ].
            unicode <= 16r207E ifTrue:[
                ^ self encodingError
            ].
            unicode == 16r207F ifTrue:[
                ^  "16r207F" 16r00FC " SUPERSCRIPT LATIN SMALL LETTER N " 
            ].
            unicode <= 16r20A6 ifTrue:[
                ^ self encodingError
            ].
            ^  "16r20A7" 16r009E " PESETA SIGN " 
        ].
        unicode <= 16r2219 ifTrue:[
            ^ self encodingError
        ].
        unicode <= 16r2265 ifTrue:[
            unicode <= 16r2229 ifTrue:[
                [
                    |t|
                    t := #[
                       "16r221A"    16rFB " SQUARE ROOT " 
                       "16r221B"    16r00 " invalid " 
                       "16r221C"    16r00 " invalid " 
                       "16r221D"    16r00 " invalid " 
                       "16r221E"    16rEC " INFINITY " 
                       "16r221F"    16r00 " invalid " 
                       "16r2220"    16r00 " invalid " 
                       "16r2221"    16r00 " invalid " 
                       "16r2222"    16r00 " invalid " 
                       "16r2223"    16r00 " invalid " 
                       "16r2224"    16r00 " invalid " 
                       "16r2225"    16r00 " invalid " 
                       "16r2226"    16r00 " invalid " 
                       "16r2227"    16r00 " invalid " 
                       "16r2228"    16r00 " invalid " 
                       "16r2229"    16rEF " INTERSECTION " 
                       ] at:(unicode - 16r2219).
                    t == 0 ifFalse:[^ t].
                    ^ self encodingError
                ] value.
            ].
            unicode <= 16r2247 ifTrue:[
                ^ self encodingError
            ].
            unicode == 16r2248 ifTrue:[
                ^  "16r2248" 16r00F7 " ALMOST EQUAL TO " 
            ].
            unicode <= 16r2260 ifTrue:[
                ^ self encodingError
            ].
            [
                |t|
                t := #[
                   "16r2261"    16rF0 " IDENTICAL TO " 
                   "16r2262"    16r00 " invalid " 
                   "16r2263"    16r00 " invalid " 
                   "16r2264"    16rF3 " LESS-THAN OR EQUAL TO " 
                   "16r2265"    16rF2 " GREATER-THAN OR EQUAL TO " 
                   ] at:(unicode - 16r2260).
                t == 0 ifFalse:[^ t].
                ^ self encodingError
            ] value.
        ].
        unicode <= 16r230F ifTrue:[
            ^ self encodingError
        ].
        unicode == 16r2310 ifTrue:[
            (#[
               "16r2310"    1 " REVERSED NOT SIGN " 
            ] at:(unicode - 8975)) ~~ 0 ifTrue:[^ unicode].
            ^ self encodingError
        ].
        unicode <= 16r231F ifTrue:[
            ^ self encodingError
        ].
        ^ #[
           "16r2320"    16rF4 " TOP HALF INTEGRAL " 
           "16r2321"    16rF5 " BOTTOM HALF INTEGRAL " 
           ] at:(unicode - 16r231F).
    ].
    unicode <= 16r24FF ifTrue:[
        ^ self encodingError
    ].
    [
        |t|
        t := #[
           "16r2500"    16rC4 " BOX DRAWINGS LIGHT HORIZONTAL " 
           "16r2501"    16r00 " invalid " 
           "16r2502"    16rB3 " BOX DRAWINGS LIGHT VERTICAL " 
           "16r2503"    16r00 " invalid " 
           "16r2504"    16r00 " invalid " 
           "16r2505"    16r00 " invalid " 
           "16r2506"    16r00 " invalid " 
           "16r2507"    16r00 " invalid " 
           "16r2508"    16r00 " invalid " 
           "16r2509"    16r00 " invalid " 
           "16r250A"    16r00 " invalid " 
           "16r250B"    16r00 " invalid " 
           "16r250C"    16rDA " BOX DRAWINGS LIGHT DOWN AND RIGHT " 
           "16r250D"    16r00 " invalid " 
           "16r250E"    16r00 " invalid " 
           "16r250F"    16r00 " invalid " 
           "16r2510"    16rBF " BOX DRAWINGS LIGHT DOWN AND LEFT " 
           "16r2511"    16r00 " invalid " 
           "16r2512"    16r00 " invalid " 
           "16r2513"    16r00 " invalid " 
           "16r2514"    16rC0 " BOX DRAWINGS LIGHT UP AND RIGHT " 
           "16r2515"    16r00 " invalid " 
           "16r2516"    16r00 " invalid " 
           "16r2517"    16r00 " invalid " 
           "16r2518"    16rD9 " BOX DRAWINGS LIGHT UP AND LEFT " 
           "16r2519"    16r00 " invalid " 
           "16r251A"    16r00 " invalid " 
           "16r251B"    16r00 " invalid " 
           "16r251C"    16rC3 " BOX DRAWINGS LIGHT VERTICAL AND RIGHT " 
           "16r251D"    16r00 " invalid " 
           "16r251E"    16r00 " invalid " 
           "16r251F"    16r00 " invalid " 
           "16r2520"    16r00 " invalid " 
           "16r2521"    16r00 " invalid " 
           "16r2522"    16r00 " invalid " 
           "16r2523"    16r00 " invalid " 
           "16r2524"    16rB4 " BOX DRAWINGS LIGHT VERTICAL AND LEFT " 
           "16r2525"    16r00 " invalid " 
           "16r2526"    16r00 " invalid " 
           "16r2527"    16r00 " invalid " 
           "16r2528"    16r00 " invalid " 
           "16r2529"    16r00 " invalid " 
           "16r252A"    16r00 " invalid " 
           "16r252B"    16r00 " invalid " 
           "16r252C"    16rC2 " BOX DRAWINGS LIGHT DOWN AND HORIZONTAL " 
           "16r252D"    16r00 " invalid " 
           "16r252E"    16r00 " invalid " 
           "16r252F"    16r00 " invalid " 
           "16r2530"    16r00 " invalid " 
           "16r2531"    16r00 " invalid " 
           "16r2532"    16r00 " invalid " 
           "16r2533"    16r00 " invalid " 
           "16r2534"    16rC1 " BOX DRAWINGS LIGHT UP AND HORIZONTAL " 
           "16r2535"    16r00 " invalid " 
           "16r2536"    16r00 " invalid " 
           "16r2537"    16r00 " invalid " 
           "16r2538"    16r00 " invalid " 
           "16r2539"    16r00 " invalid " 
           "16r253A"    16r00 " invalid " 
           "16r253B"    16r00 " invalid " 
           "16r253C"    16rC5 " BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL " 
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
           "16r2550"    16rCD " BOX DRAWINGS DOUBLE HORIZONTAL " 
           "16r2551"    16rBA " BOX DRAWINGS DOUBLE VERTICAL " 
           "16r2552"    16rD5 " BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE " 
           "16r2553"    16rD6 " BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE " 
           "16r2554"    16rC9 " BOX DRAWINGS DOUBLE DOWN AND RIGHT " 
           "16r2555"    16rB8 " BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE " 
           "16r2556"    16rB7 " BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE " 
           "16r2557"    16rBB " BOX DRAWINGS DOUBLE DOWN AND LEFT " 
           "16r2558"    16rD4 " BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE " 
           "16r2559"    16rD3 " BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE " 
           "16r255A"    16rC8 " BOX DRAWINGS DOUBLE UP AND RIGHT " 
           "16r255B"    16rBE " BOX DRAWINGS UP SINGLE AND LEFT DOUBLE " 
           "16r255C"    16rBD " BOX DRAWINGS UP DOUBLE AND LEFT SINGLE " 
           "16r255D"    16rBC " BOX DRAWINGS DOUBLE UP AND LEFT " 
           "16r255E"    16rC6 " BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE " 
           "16r255F"    16rC7 " BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE " 
           "16r2560"    16rCC " BOX DRAWINGS DOUBLE VERTICAL AND RIGHT " 
           "16r2561"    16rB5 " BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE " 
           "16r2562"    16rB6 " BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE " 
           "16r2563"    16rB9 " BOX DRAWINGS DOUBLE VERTICAL AND LEFT " 
           "16r2564"    16rD1 " BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE " 
           "16r2565"    16rD2 " BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE " 
           "16r2566"    16rCB " BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL " 
           "16r2567"    16rCF " BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE " 
           "16r2568"    16rD0 " BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE " 
           "16r2569"    16rCA " BOX DRAWINGS DOUBLE UP AND HORIZONTAL " 
           "16r256A"    16rD8 " BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE " 
           "16r256B"    16rD7 " BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE " 
           "16r256C"    16rCE " BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL " 
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
           "16r2580"    16rDF " UPPER HALF BLOCK " 
           "16r2581"    16r00 " invalid " 
           "16r2582"    16r00 " invalid " 
           "16r2583"    16r00 " invalid " 
           "16r2584"    16rDC " LOWER HALF BLOCK " 
           "16r2585"    16r00 " invalid " 
           "16r2586"    16r00 " invalid " 
           "16r2587"    16r00 " invalid " 
           "16r2588"    16rDB " FULL BLOCK " 
           "16r2589"    16r00 " invalid " 
           "16r258A"    16r00 " invalid " 
           "16r258B"    16r00 " invalid " 
           "16r258C"    16rDD " LEFT HALF BLOCK " 
           "16r258D"    16r00 " invalid " 
           "16r258E"    16r00 " invalid " 
           "16r258F"    16r00 " invalid " 
           "16r2590"    16rDE " RIGHT HALF BLOCK " 
           "16r2591"    16rB0 " LIGHT SHADE " 
           "16r2592"    16rB1 " MEDIUM SHADE " 
           "16r2593"    16rB2 " DARK SHADE " 
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
           "16r25A0"    16rFE " BLACK SQUARE " 
           ] at:(unicode - 16r24FF).
        t == 0 ifFalse:[^ t].
        ^ self encodingError
    ] value.
! !

!CP437 class methodsFor:'documentation'!

version
    ^ '$Id: CharacterEncoderImplementations__CP437.st 10842 2012-09-07 10:49:18Z vranyj1 $'
!

version_SVN
    ^ '$Id:: CharacterEncoderImplementations__CP437.st 10842 2012-09-07 10:49:18Z vranyj1                                           $'
! !
