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

SingleByteEncoder subclass:#ISO8859_1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO8859_1 class methodsFor:'documentation'!

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
    8859-1 (West European) - 8bit identity subset of Unicode.

    [see with:]
        CharacterEncoderImplementations::ISO8859_1 showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!ISO8859_1 class methodsFor:'mapping'!

mapFileURL2_relativePathName
    ^ 'LATIN1'

    "
     self generateCode
    "
!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/LATIN1

<code_set_name> ISO-8859-1
<comment_char> %
<escape_char> /
% version: 1.0
% repertoiremap: mnemonic,ds
%  source: ECMA registry

% alias ISO-IR-100
% alias ISO_8859-1:1987
% alias ISO_8859-1
% alias LATIN1
% alias L1
% alias IBM819
% alias CP819
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
<PA>                   /x80   <U0080> PADDING CHARACTER (PAD)
<HO>                   /x81   <U0081> HIGH OCTET PRESET (HOP)
<BH>                   /x82   <U0082> BREAK PERMITTED HERE (BPH)
<NH>                   /x83   <U0083> NO BREAK HERE (NBH)
<IN>                   /x84   <U0084> INDEX (IND)
<NL>                   /x85   <U0085> NEXT LINE (NEL)
<SA>                   /x86   <U0086> START OF SELECTED AREA (SSA)
<ES>                   /x87   <U0087> END OF SELECTED AREA (ESA)
<HS>                   /x88   <U0088> CHARACTER TABULATION SET (HTS)
<HJ>                   /x89   <U0089> CHARACTER TABULATION WITH JUSTIFICATION (HTJ)
<VS>                   /x8A   <U008A> LINE TABULATION SET (VTS)
<PD>                   /x8B   <U008B> PARTIAL LINE FORWARD (PLD)
<PU>                   /x8C   <U008C> PARTIAL LINE BACKWARD (PLU)
<RI>                   /x8D   <U008D> REVERSE LINE FEED (RI)
<S2>                   /x8E   <U008E> SINGLE-SHIFT TWO (SS2)
<S3>                   /x8F   <U008F> SINGLE-SHIFT THREE (SS3)
<DC>                   /x90   <U0090> DEVICE CONTROL STRING (DCS)
<P1>                   /x91   <U0091> PRIVATE USE ONE (PU1)
<P2>                   /x92   <U0092> PRIVATE USE TWO (PU2)
<TS>                   /x93   <U0093> SET TRANSMIT STATE (STS)
<CC>                   /x94   <U0094> CANCEL CHARACTER (CCH)
<MW>                   /x95   <U0095> MESSAGE WAITING (MW)
<SG>                   /x96   <U0096> START OF GUARDED AREA (SPA)
<EG>                   /x97   <U0097> END OF GUARDED AREA (EPA)
<SS>                   /x98   <U0098> START OF STRING (SOS)
<GC>                   /x99   <U0099> SINGLE GRAPHIC CHARACTER INTRODUCER (SGCI)
<SC>                   /x9A   <U009A> SINGLE CHARACTER INTRODUCER (SCI)
<CI>                   /x9B   <U009B> CONTROL SEQUENCE INTRODUCER (CSI)
<ST>                   /x9C   <U009C> STRING TERMINATOR (ST)
<OC>                   /x9D   <U009D> OPERATING SYSTEM COMMAND (OSC)
<PM>                   /x9E   <U009E> PRIVACY MESSAGE (PM)
<AC>                   /x9F   <U009F> APPLICATION PROGRAM COMMAND (APC)
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
<D->                   /xD0   <U00D0> LATIN CAPITAL LETTER ETH (Icelandic)
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
<Y'>                   /xDD   <U00DD> LATIN CAPITAL LETTER Y WITH ACUTE
<TH>                   /xDE   <U00DE> LATIN CAPITAL LETTER THORN (Icelandic)
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
<e/>>                  /xEA   <U00EA> LATIN SMALL LETTER E WITH CIRCUMFLEX
<e:>                   /xEB   <U00EB> LATIN SMALL LETTER E WITH DIAERESIS
<i!!>                   /xEC   <U00EC> LATIN SMALL LETTER I WITH GRAVE
<i'>                   /xED   <U00ED> LATIN SMALL LETTER I WITH ACUTE
<i/>>                  /xEE   <U00EE> LATIN SMALL LETTER I WITH CIRCUMFLEX
<i:>                   /xEF   <U00EF> LATIN SMALL LETTER I WITH DIAERESIS
<d->                   /xF0   <U00F0> LATIN SMALL LETTER ETH (Icelandic)
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
<y'>                   /xFD   <U00FD> LATIN SMALL LETTER Y WITH ACUTE
<th>                   /xFE   <U00FE> LATIN SMALL LETTER THORN (Icelandic)
<y:>                   /xFF   <U00FF> LATIN SMALL LETTER Y WITH DIAERESIS
<NUL>                  /x00   <U0000> NUL
<SOH>                  /x01   <U0001> START OF HEADING (SOH)
<STX>                  /x02   <U0002> START OF TEXT (STX)
<ETX>                  /x03   <U0003> END OF TEXT (ETX)
<EOT>                  /x04   <U0004> END OF TRANSMISSION (EOT)
<ENQ>                  /x05   <U0005> ENQUIRY (ENQ)
<ACK>                  /x06   <U0006> ACKNOWLEDGE (ACK)
<alert>                /x07   <U0007> BELL (BEL)
<BEL>                  /x07   <U0007> BELL (BEL)
<backspace>            /x08   <U0008> BACKSPACE (BS)
<tab>                  /x09   <U0009> CHARACTER TABULATION (HT)
<newline>              /x0A   <U000A> LINE FEED (LF)
<vertical-tab>         /x0B   <U000B> LINE TABULATION (VT)
<form-feed>            /x0C   <U000C> FORM FEED (FF)
<carriage-return>      /x0D   <U000D> CARRIAGE RETURN (CR)
<DLE>                  /x10   <U0010> DATALINK ESCAPE (DLE)
<DC1>                  /x11   <U0011> DEVICE CONTROL ONE (DC1)
<DC2>                  /x12   <U0012> DEVICE CONTROL TWO (DC2)
<DC3>                  /x13   <U0013> DEVICE CONTROL THREE (DC3)
<DC4>                  /x14   <U0014> DEVICE CONTROL FOUR (DC4)
<NAK>                  /x15   <U0015> NEGATIVE ACKNOWLEDGE (NAK)
<SYN>                  /x16   <U0016> SYNCHRONOUS IDLE (SYN)
<ETB>                  /x17   <U0017> END OF TRANSMISSION BLOCK (ETB)
<CAN>                  /x18   <U0018> CANCEL (CAN)
<SUB>                  /x1A   <U001A> SUBSTITUTE (SUB)
<ESC>                  /x1B   <U001B> ESCAPE (ESC)
<IS4>                  /x1C   <U001C> FILE SEPARATOR (IS4)
<IS3>                  /x1D   <U001D> GROUP SEPARATOR (IS3)
<intro>                /x1D   <U001D> GROUP SEPARATOR (IS3)
<IS2>                  /x1E   <U001E> RECORD SEPARATOR (IS2)
<IS1>                  /x1F   <U001F> UNIT SEPARATOR (IS1)
<DEL>                  /x7F   <U007F> DELETE (DEL)
<space>                /x20   <U0020> SPACE
<exclamation-mark>     /x21   <U0021> EXCLAMATION MARK
<quotation-mark>       /x22   <U0022> QUOTATION MARK
<number-sign>          /x23   <U0023> NUMBER SIGN
<dollar-sign>          /x24   <U0024> DOLLAR SIGN
<percent-sign>         /x25   <U0025> PERCENT SIGN
<ampersand>            /x26   <U0026> AMPERSAND
<apostrophe>           /x27   <U0027> APOSTROPHE
<left-parenthesis>     /x28   <U0028> LEFT PARENTHESIS
<right-parenthesis>    /x29   <U0029> RIGHT PARENTHESIS
<asterisk>             /x2A   <U002A> ASTERISK
<plus-sign>            /x2B   <U002B> PLUS SIGN
<comma>                /x2C   <U002C> COMMA
<hyphen>               /x2D   <U002D> HYPHEN-MINUS
<hyphen-minus>         /x2D   <U002D> HYPHEN-MINUS
<period>               /x2E   <U002E> FULL STOP
<full-stop>            /x2E   <U002E> FULL STOP
<slash>                /x2F   <U002F> SOLIDUS
<solidus>              /x2F   <U002F> SOLIDUS
<zero>                 /x30   <U0030> DIGIT ZERO
<one>                  /x31   <U0031> DIGIT ONE
<two>                  /x32   <U0032> DIGIT TWO
<three>                /x33   <U0033> DIGIT THREE
<four>                 /x34   <U0034> DIGIT FOUR
<five>                 /x35   <U0035> DIGIT FIVE
<six>                  /x36   <U0036> DIGIT SIX
<seven>                /x37   <U0037> DIGIT SEVEN
<eight>                /x38   <U0038> DIGIT EIGHT
<nine>                 /x39   <U0039> DIGIT NINE
<colon>                /x3A   <U003A> COLON
<semicolon>            /x3B   <U003B> SEMICOLON
<less-than-sign>       /x3C   <U003C> LESS-THAN SIGN
<equals-sign>          /x3D   <U003D> EQUALS SIGN
<greater-than-sign>    /x3E   <U003E> GREATER-THAN SIGN
<question-mark>        /x3F   <U003F> QUESTION MARK
<commercial-at>        /x40   <U0040> COMMERCIAL AT
<left-square-bracket>  /x5B   <U005B> LEFT SQUARE BRACKET
<backslash>            /x5C   <U005C> REVERSE SOLIDUS
<reverse-solidus>      /x5C   <U005C> REVERSE SOLIDUS
<right-square-bracket> /x5D   <U005D> RIGHT SQUARE BRACKET
<circumflex>           /x5E   <U005E> CIRCUMFLEX ACCENT
<circumflex-accent>    /x5E   <U005E> CIRCUMFLEX ACCENT
<underscore>           /x5F   <U005F> LOW LINE
<low-line>             /x5F   <U005F> LOW LINE
<grave-accent>         /x60   <U0060> GRAVE ACCENT
<left-brace>           /x7B   <U007B> LEFT CURLY BRACKET
<left-curly-bracket>   /x7B   <U007B> LEFT CURLY BRACKET
<vertical-line>        /x7C   <U007C> VERTICAL LINE
<right-brace>          /x7D   <U007D> RIGHT CURLY BRACKET
<right-curly-bracket>  /x7D   <U007D> RIGHT CURLY BRACKET
<tilde>                /x7E   <U007E> TILDE
END CHARMAP

"
! !

!ISO8859_1 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Western'
! !

!ISO8859_1 methodsFor:'encoding & decoding'!

decode:codeArg
    "Automagically generated by generateCode - do not modify.
     Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code > 16rFF ifTrue:[
	^ self decodingError.
    ].
    ^ code.
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode > 16rFF ifTrue:[
        ^ self encodingError.
    ].
    ^ unicode.
! !

!ISO8859_1 class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
