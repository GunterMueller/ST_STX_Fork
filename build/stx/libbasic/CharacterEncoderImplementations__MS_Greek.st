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

SingleByteEncoder subclass:#MS_Greek
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!MS_Greek class methodsFor:'documentation'!

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
    CP1253 / Microsoft Greek

    [see with:]
        CharacterEncoderImplementations::MS_Greek showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!MS_Greek class methodsFor:'mapping'!

mapFileURL2_relativePathName
    ^ 'CP1253'

    "
     self generateCode
    "
!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/CP1253

<code_set_name> CP1253
<comment_char> %
<escape_char> /
% version: 1.0
% repertoiremap: mnemonic,ds
%  source: UNICODE 1.0

% alias MS-GREEK
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
<%0>                   /x89   <U2030> PER MILLE SIGN
<<1>                   /x8B   <U2039> SINGLE LEFT-POINTING ANGLE QUOTATION MARK
<'6>                   /x91   <U2018> LEFT SINGLE QUOTATION MARK
<'9>                   /x92   <U2019> RIGHT SINGLE QUOTATION MARK
<'6>                   /x93   <U201C> LEFT DOUBLE QUOTATION MARK
<'9>                   /x94   <U201D> RIGHT DOUBLE QUOTATION MARK
<sb>                   /x95   <U2022> BULLET
<-N>                   /x96   <U2013> EN DASH
<-M>                   /x97   <U2014> EM DASH
<TM>                   /x99   <U2122> TRADE MARK SIGN
</>1>                  /x9B   <U203A> SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
<NS>                   /xA0   <U00A0> NO-BREAK SPACE
<'%>                   /xA1   <U0385> GREEK DIALYTIKA TONOS
<A%>                   /xA2   <U0386> GREEK CAPITAL LETTER ALPHA WITH TONOS
<Pd>                   /xA3   <U00A3> POUND SIGN
<Cu>                   /xA4   <U00A4> CURRENCY SIGN
<Ye>                   /xA5   <U00A5> YEN SIGN
<BB>                   /xA6   <U00A6> BROKEN BAR
<SE>                   /xA7   <U00A7> SECTION SIGN
<':>                   /xA8   <U00A8> DIAERESIS
<Co>                   /xA9   <U00A9> COPYRIGHT SIGN
<<<>                   /xAB   <U00AB> LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
<NO>                   /xAC   <U00AC> NOT SIGN
<-->                   /xAD   <U00AD> SOFT HYPHEN
<Rg>                   /xAE   <U00AE> REGISTERED SIGN
<-3>                   /xAF   <U2015> HORIZONTAL BAR
<DG>                   /xB0   <U00B0> DEGREE SIGN
<+->                   /xB1   <U00B1> PLUS-MINUS SIGN
<2S>                   /xB2   <U00B2> SUPERSCRIPT TWO
<3S>                   /xB3   <U00B3> SUPERSCRIPT THREE
<'*>                   /xB4   <U0384> GREEK TONOS
<My>                   /xB5   <U00B5> MICRO SIGN
<PI>                   /xB6   <U00B6> PILCROW SIGN
<.M>                   /xB7   <U00B7> MIDDLE DOT
<E%>                   /xB8   <U0388> GREEK CAPITAL LETTER EPSILON WITH TONOS
<Y%>                   /xB9   <U0389> GREEK CAPITAL LETTER ETA WITH TONOS
<I%>                   /xBA   <U038A> GREEK CAPITAL LETTER IOTA WITH TONOS
</>/>>                 /xBB   <U00BB> RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
<O%>                   /xBC   <U038C> GREEK CAPITAL LETTER OMICRON WITH TONOS
<12>                   /xBD   <U00BD> VULGAR FRACTION ONE HALF
<U%>                   /xBE   <U038E> GREEK CAPITAL LETTER UPSILON WITH TONOS
<W%>                   /xBF   <U038F> GREEK CAPITAL LETTER OMEGA WITH TONOS
<i3>                   /xC0   <U0390> GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
<A*>                   /xC1   <U0391> GREEK CAPITAL LETTER ALPHA
<B*>                   /xC2   <U0392> GREEK CAPITAL LETTER BETA
<G*>                   /xC3   <U0393> GREEK CAPITAL LETTER GAMMA
<D*>                   /xC4   <U0394> GREEK CAPITAL LETTER DELTA
<E*>                   /xC5   <U0395> GREEK CAPITAL LETTER EPSILON
<Z*>                   /xC6   <U0396> GREEK CAPITAL LETTER ZETA
<Y*>                   /xC7   <U0397> GREEK CAPITAL LETTER ETA
<H*>                   /xC8   <U0398> GREEK CAPITAL LETTER THETA
<I*>                   /xC9   <U0399> GREEK CAPITAL LETTER IOTA
<K*>                   /xCA   <U039A> GREEK CAPITAL LETTER KAPPA
<L*>                   /xCB   <U039B> GREEK CAPITAL LETTER LAMDA
<M*>                   /xCC   <U039C> GREEK CAPITAL LETTER MU
<N*>                   /xCD   <U039D> GREEK CAPITAL LETTER NU
<C*>                   /xCE   <U039E> GREEK CAPITAL LETTER XI
<O*>                   /xCF   <U039F> GREEK CAPITAL LETTER OMICRON
<P*>                   /xD0   <U03A0> GREEK CAPITAL LETTER PI
<R*>                   /xD1   <U03A1> GREEK CAPITAL LETTER RHO
<S*>                   /xD3   <U03A3> GREEK CAPITAL LETTER SIGMA
<T*>                   /xD4   <U03A4> GREEK CAPITAL LETTER TAU
<U*>                   /xD5   <U03A5> GREEK CAPITAL LETTER UPSILON
<F*>                   /xD6   <U03A6> GREEK CAPITAL LETTER PHI
<X*>                   /xD7   <U03A7> GREEK CAPITAL LETTER CHI
<Q*>                   /xD8   <U03A8> GREEK CAPITAL LETTER PSI
<W*>                   /xD9   <U03A9> GREEK CAPITAL LETTER OMEGA
<J*>                   /xDA   <U03AA> GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
<V*>                   /xDB   <U03AB> GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
<a%>                   /xDC   <U03AC> GREEK SMALL LETTER ALPHA WITH TONOS
<e%>                   /xDD   <U03AD> GREEK SMALL LETTER EPSILON WITH TONOS
<y%>                   /xDE   <U03AE> GREEK SMALL LETTER ETA WITH TONOS
<i%>                   /xDF   <U03AF> GREEK SMALL LETTER IOTA WITH TONOS
<u3>                   /xE0   <U03B0> GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
<a*>                   /xE1   <U03B1> GREEK SMALL LETTER ALPHA
<b*>                   /xE2   <U03B2> GREEK SMALL LETTER BETA
<g*>                   /xE3   <U03B3> GREEK SMALL LETTER GAMMA
<d*>                   /xE4   <U03B4> GREEK SMALL LETTER DELTA
<e*>                   /xE5   <U03B5> GREEK SMALL LETTER EPSILON
<z*>                   /xE6   <U03B6> GREEK SMALL LETTER ZETA
<y*>                   /xE7   <U03B7> GREEK SMALL LETTER ETA
<h*>                   /xE8   <U03B8> GREEK SMALL LETTER THETA
<i*>                   /xE9   <U03B9> GREEK SMALL LETTER IOTA
<k*>                   /xEA   <U03BA> GREEK SMALL LETTER KAPPA
<l*>                   /xEB   <U03BB> GREEK SMALL LETTER LAMDA
<m*>                   /xEC   <U03BC> GREEK SMALL LETTER MU
<n*>                   /xED   <U03BD> GREEK SMALL LETTER NU
<c*>                   /xEE   <U03BE> GREEK SMALL LETTER XI
<o*>                   /xEF   <U03BF> GREEK SMALL LETTER OMICRON
<p*>                   /xF0   <U03C0> GREEK SMALL LETTER PI
<r*>                   /xF1   <U03C1> GREEK SMALL LETTER RHO
<*s>                   /xF2   <U03C2> GREEK SMALL LETTER FINAL SIGMA
<s*>                   /xF3   <U03C3> GREEK SMALL LETTER SIGMA
<t*>                   /xF4   <U03C4> GREEK SMALL LETTER TAU
<u*>                   /xF5   <U03C5> GREEK SMALL LETTER UPSILON
<f*>                   /xF6   <U03C6> GREEK SMALL LETTER PHI
<x*>                   /xF7   <U03C7> GREEK SMALL LETTER CHI
<q*>                   /xF8   <U03C8> GREEK SMALL LETTER PSI
<w*>                   /xF9   <U03C9> GREEK SMALL LETTER OMEGA
<j*>                   /xFA   <U03CA> GREEK SMALL LETTER IOTA WITH DIALYTIKA
<v*>                   /xFB   <U03CB> GREEK SMALL LETTER UPSILON WITH DIALYTIKA
<o%>                   /xFC   <U03CC> GREEK SMALL LETTER OMICRON WITH TONOS
<u%>                   /xFD   <U03CD> GREEK SMALL LETTER UPSILON WITH TONOS
<w%>                   /xFE   <U03CE> GREEK SMALL LETTER OMEGA WITH TONOS
END CHARMAP

"
! !

!MS_Greek methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code <= 16r7F ifTrue:[ ^ code ].
    code > 16rFE ifTrue:[
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
           "16r0088"    16r0000 " invalid " 
           "16r0089"    16r2030 " PER MILLE SIGN " 
           "16r008A"    16r0000 " invalid " 
           "16r008B"    16r2039 " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
           "16r008C"    16r0000 " invalid " 
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
           "16r0098"    16r0000 " invalid " 
           "16r0099"    16r2122 " TRADE MARK SIGN " 
           "16r009A"    16r0000 " invalid " 
           "16r009B"    16r203A " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
           "16r009C"    16r0000 " invalid " 
           "16r009D"    16r0000 " invalid " 
           "16r009E"    16r0000 " invalid " 
           "16r009F"    16r0000 " invalid " 
           "16r00A0"    16r00A0 " NO-BREAK SPACE " 
           "16r00A1"    16r0385 " GREEK DIALYTIKA TONOS " 
           "16r00A2"    16r0386 " GREEK CAPITAL LETTER ALPHA WITH TONOS " 
           "16r00A3"    16r00A3 " POUND SIGN " 
           "16r00A4"    16r00A4 " CURRENCY SIGN " 
           "16r00A5"    16r00A5 " YEN SIGN " 
           "16r00A6"    16r00A6 " BROKEN BAR " 
           "16r00A7"    16r00A7 " SECTION SIGN " 
           "16r00A8"    16r00A8 " DIAERESIS " 
           "16r00A9"    16r00A9 " COPYRIGHT SIGN " 
           "16r00AA"    16r0000 " invalid " 
           "16r00AB"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00AC"    16r00AC " NOT SIGN " 
           "16r00AD"    16r00AD " SOFT HYPHEN " 
           "16r00AE"    16r00AE " REGISTERED SIGN " 
           "16r00AF"    16r2015 " HORIZONTAL BAR " 
           "16r00B0"    16r00B0 " DEGREE SIGN " 
           "16r00B1"    16r00B1 " PLUS-MINUS SIGN " 
           "16r00B2"    16r00B2 " SUPERSCRIPT TWO " 
           "16r00B3"    16r00B3 " SUPERSCRIPT THREE " 
           "16r00B4"    16r0384 " GREEK TONOS " 
           "16r00B5"    16r00B5 " MICRO SIGN " 
           "16r00B6"    16r00B6 " PILCROW SIGN " 
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
    unicode <= 16r3CE ifTrue:[
        unicode <= 16r192 ifTrue:[
            unicode <= 16rBD ifTrue:[
                [
                    |t|
                    t := #[
                       "16r00A0"    16rA0 " NO-BREAK SPACE " 
                       "16r00A1"    16r00 " invalid " 
                       "16r00A2"    16r00 " invalid " 
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
                       "16r00AF"    16r00 " invalid " 
                       "16r00B0"    16rB0 " DEGREE SIGN " 
                       "16r00B1"    16rB1 " PLUS-MINUS SIGN " 
                       "16r00B2"    16rB2 " SUPERSCRIPT TWO " 
                       "16r00B3"    16rB3 " SUPERSCRIPT THREE " 
                       "16r00B4"    16r00 " invalid " 
                       "16r00B5"    16rB5 " MICRO SIGN " 
                       "16r00B6"    16rB6 " PILCROW SIGN " 
                       "16r00B7"    16rB7 " MIDDLE DOT " 
                       "16r00B8"    16r00 " invalid " 
                       "16r00B9"    16r00 " invalid " 
                       "16r00BA"    16r00 " invalid " 
                       "16r00BB"    16rBB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                       "16r00BC"    16r00 " invalid " 
                       "16r00BD"    16rBD " VULGAR FRACTION ONE HALF " 
                       ] at:(unicode - 16r9F).
                    t == 0 ifFalse:[^ t].
                    ^ self encodingError
                ] value.
            ].
            unicode <= 16r191 ifTrue:[
                ^ self encodingError
            ].
            ^  "16r0192" 16r0083 " LATIN SMALL LETTER F WITH HOOK " 
        ].
        unicode <= 16r383 ifTrue:[
            ^ self encodingError
        ].
        [
            |t|
            t := #[
               "16r0384"    16rB4 " GREEK TONOS " 
               "16r0385"    16rA1 " GREEK DIALYTIKA TONOS " 
               "16r0386"    16rA2 " GREEK CAPITAL LETTER ALPHA WITH TONOS " 
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
               ] at:(unicode - 16r383).
            t == 0 ifFalse:[^ t].
            ^ self encodingError
        ] value.
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
               "16r2015"    16rAF " HORIZONTAL BAR " 
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

!MS_Greek class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__MS_Greek.st,v 1.4 2005/03/31 18:49:01 cg Exp $'
!

version_SVN
    ^ '$Id: CharacterEncoderImplementations__MS_Greek.st 10807 2012-05-05 21:58:24Z vranyj1 $'
! !



