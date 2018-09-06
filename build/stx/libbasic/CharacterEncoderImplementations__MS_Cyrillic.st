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

SingleByteEncoder subclass:#MS_Cyrillic
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!MS_Cyrillic class methodsFor:'documentation'!

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
    CP1251 / Microsoft Cyrillic

    [see with:]
        CharacterEncoderImplementations::MS_Cyrillic showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!MS_Cyrillic class methodsFor:'mapping'!

mapFileURL2_relativePathName
    ^ 'CP1251'

    "
     self generateCode
    "
!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/CP1251

<code_set_name> CP1251
<comment_char> %
<escape_char> /
% version: 1.0
% repertoiremap: mnemonic,ds
%  source: UNICODE 1.0

% alias MS-CYRL
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
<D%>                   /x80   <U0402> CYRILLIC CAPITAL LETTER DJE (Serbocroatian)
<G%>                   /x81   <U0403> CYRILLIC CAPITAL LETTER GJE
<.9>                   /x82   <U201A> SINGLE LOW-9 QUOTATION MARK
<g%>                   /x83   <U0453> CYRILLIC SMALL LETTER GJE
<:9>                   /x84   <U201E> DOUBLE LOW-9 QUOTATION MARK
<.3>                   /x85   <U2026> HORIZONTAL ELLIPSIS
<//->                  /x86   <U2020> DAGGER
<//=>                  /x87   <U2021> DOUBLE DAGGER
<%0>                   /x89   <U2030> PER MILLE SIGN
<LJ>                   /x8A   <U0409> CYRILLIC CAPITAL LETTER LJE
<<1>                   /x8B   <U2039> SINGLE LEFT-POINTING ANGLE QUOTATION MARK
<NJ>                   /x8C   <U040A> CYRILLIC CAPITAL LETTER NJE
<KJ>                   /x8D   <U040C> CYRILLIC CAPITAL LETTER KJE
<Ts>                   /x8E   <U040B> CYRILLIC CAPITAL LETTER TSHE (Serbocroatian)
<DZ>                   /x8F   <U040F> CYRILLIC CAPITAL LETTER DZHE
<d%>                   /x90   <U0452> CYRILLIC SMALL LETTER DJE (Serbocroatian)
<'6>                   /x91   <U2018> LEFT SINGLE QUOTATION MARK
<'9>                   /x92   <U2019> RIGHT SINGLE QUOTATION MARK
<'6>                   /x93   <U201C> LEFT DOUBLE QUOTATION MARK
<'9>                   /x94   <U201D> RIGHT DOUBLE QUOTATION MARK
<sb>                   /x95   <U2022> BULLET
<-N>                   /x96   <U2013> EN DASH
<-M>                   /x97   <U2014> EM DASH
<TM>                   /x99   <U2122> TRADE MARK SIGN
<lj>                   /x9A   <U0459> CYRILLIC SMALL LETTER LJE
</>1>                  /x9B   <U203A> SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
<nj>                   /x9C   <U045A> CYRILLIC SMALL LETTER NJE
<kj>                   /x9D   <U045C> CYRILLIC SMALL LETTER KJE
<ts>                   /x9E   <U045B> CYRILLIC SMALL LETTER TSHE (Serbocroatian)
<dz>                   /x9F   <U045F> CYRILLIC SMALL LETTER DZHE
<NS>                   /xA0   <U00A0> NO-BREAK SPACE
<V%>                   /xA1   <U040E> CYRILLIC CAPITAL LETTER SHORT U (Byelorussian)
<v%>                   /xA2   <U045E> CYRILLIC SMALL LETTER SHORT U (Byelorussian)
<J%>                   /xA3   <U0408> CYRILLIC CAPITAL LETTER JE
<Cu>                   /xA4   <U00A4> CURRENCY SIGN
<G3>                   /xA5   <U0490> CYRILLIC CAPITAL LETTER GHE WITH UPTURN
<BB>                   /xA6   <U00A6> BROKEN BAR
<SE>                   /xA7   <U00A7> SECTION SIGN
<IO>                   /xA8   <U0401> CYRILLIC CAPITAL LETTER IO
<Co>                   /xA9   <U00A9> COPYRIGHT SIGN
<IE>                   /xAA   <U0404> CYRILLIC CAPITAL LETTER UKRAINIAN IE
<<<>                   /xAB   <U00AB> LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
<NO>                   /xAC   <U00AC> NOT SIGN
<-->                   /xAD   <U00AD> SOFT HYPHEN
<Rg>                   /xAE   <U00AE> REGISTERED SIGN
<YI>                   /xAF   <U0407> CYRILLIC CAPITAL LETTER YI (Ukrainian)
<DG>                   /xB0   <U00B0> DEGREE SIGN
<+->                   /xB1   <U00B1> PLUS-MINUS SIGN
<II>                   /xB2   <U0406> CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
<ii>                   /xB3   <U0456> CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
<g3>                   /xB4   <U0491> CYRILLIC SMALL LETTER GHE WITH UPTURN
<My>                   /xB5   <U00B5> MICRO SIGN
<PI>                   /xB6   <U00B6> PILCROW SIGN
<.M>                   /xB7   <U00B7> MIDDLE DOT
<io>                   /xB8   <U0451> CYRILLIC SMALL LETTER IO
<N0>                   /xB9   <U2116> NUMERO SIGN
<ie>                   /xBA   <U0454> CYRILLIC SMALL LETTER UKRAINIAN IE
</>/>>                 /xBB   <U00BB> RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
<j%>                   /xBC   <U0458> CYRILLIC SMALL LETTER JE
<DS>                   /xBD   <U0405> CYRILLIC CAPITAL LETTER DZE
<ds>                   /xBE   <U0455> CYRILLIC SMALL LETTER DZE
<yi>                   /xBF   <U0457> CYRILLIC SMALL LETTER YI (Ukrainian)
<A=>                   /xC0   <U0410> CYRILLIC CAPITAL LETTER A
<B=>                   /xC1   <U0411> CYRILLIC CAPITAL LETTER BE
<V=>                   /xC2   <U0412> CYRILLIC CAPITAL LETTER VE
<G=>                   /xC3   <U0413> CYRILLIC CAPITAL LETTER GHE
<D=>                   /xC4   <U0414> CYRILLIC CAPITAL LETTER DE
<E=>                   /xC5   <U0415> CYRILLIC CAPITAL LETTER IE
<Z%>                   /xC6   <U0416> CYRILLIC CAPITAL LETTER ZHE
<Z=>                   /xC7   <U0417> CYRILLIC CAPITAL LETTER ZE
<I=>                   /xC8   <U0418> CYRILLIC CAPITAL LETTER I
<J=>                   /xC9   <U0419> CYRILLIC CAPITAL LETTER SHORT I
<K=>                   /xCA   <U041A> CYRILLIC CAPITAL LETTER KA
<L=>                   /xCB   <U041B> CYRILLIC CAPITAL LETTER EL
<M=>                   /xCC   <U041C> CYRILLIC CAPITAL LETTER EM
<N=>                   /xCD   <U041D> CYRILLIC CAPITAL LETTER EN
<O=>                   /xCE   <U041E> CYRILLIC CAPITAL LETTER O
<P=>                   /xCF   <U041F> CYRILLIC CAPITAL LETTER PE
<R=>                   /xD0   <U0420> CYRILLIC CAPITAL LETTER ER
<S=>                   /xD1   <U0421> CYRILLIC CAPITAL LETTER ES
<T=>                   /xD2   <U0422> CYRILLIC CAPITAL LETTER TE
<U=>                   /xD3   <U0423> CYRILLIC CAPITAL LETTER U
<F=>                   /xD4   <U0424> CYRILLIC CAPITAL LETTER EF
<H=>                   /xD5   <U0425> CYRILLIC CAPITAL LETTER HA
<C=>                   /xD6   <U0426> CYRILLIC CAPITAL LETTER TSE
<C%>                   /xD7   <U0427> CYRILLIC CAPITAL LETTER CHE
<S%>                   /xD8   <U0428> CYRILLIC CAPITAL LETTER SHA
<Sc>                   /xD9   <U0429> CYRILLIC CAPITAL LETTER SHCHA
<='>                   /xDA   <U042A> CYRILLIC CAPITAL LETTER HARD SIGN
<Y=>                   /xDB   <U042B> CYRILLIC CAPITAL LETTER YERU
<%'>                   /xDC   <U042C> CYRILLIC CAPITAL LETTER SOFT SIGN
<JE>                   /xDD   <U042D> CYRILLIC CAPITAL LETTER E
<JU>                   /xDE   <U042E> CYRILLIC CAPITAL LETTER YU
<JA>                   /xDF   <U042F> CYRILLIC CAPITAL LETTER YA
<a=>                   /xE0   <U0430> CYRILLIC SMALL LETTER A
<b=>                   /xE1   <U0431> CYRILLIC SMALL LETTER BE
<v=>                   /xE2   <U0432> CYRILLIC SMALL LETTER VE
<g=>                   /xE3   <U0433> CYRILLIC SMALL LETTER GHE
<d=>                   /xE4   <U0434> CYRILLIC SMALL LETTER DE
<e=>                   /xE5   <U0435> CYRILLIC SMALL LETTER IE
<z%>                   /xE6   <U0436> CYRILLIC SMALL LETTER ZHE
<z=>                   /xE7   <U0437> CYRILLIC SMALL LETTER ZE
<i=>                   /xE8   <U0438> CYRILLIC SMALL LETTER I
<j=>                   /xE9   <U0439> CYRILLIC SMALL LETTER SHORT I
<k=>                   /xEA   <U043A> CYRILLIC SMALL LETTER KA
<l=>                   /xEB   <U043B> CYRILLIC SMALL LETTER EL
<m=>                   /xEC   <U043C> CYRILLIC SMALL LETTER EM
<n=>                   /xED   <U043D> CYRILLIC SMALL LETTER EN
<o=>                   /xEE   <U043E> CYRILLIC SMALL LETTER O
<p=>                   /xEF   <U043F> CYRILLIC SMALL LETTER PE
<r=>                   /xF0   <U0440> CYRILLIC SMALL LETTER ER
<s=>                   /xF1   <U0441> CYRILLIC SMALL LETTER ES
<t=>                   /xF2   <U0442> CYRILLIC SMALL LETTER TE
<u=>                   /xF3   <U0443> CYRILLIC SMALL LETTER U
<f=>                   /xF4   <U0444> CYRILLIC SMALL LETTER EF
<h=>                   /xF5   <U0445> CYRILLIC SMALL LETTER HA
<c=>                   /xF6   <U0446> CYRILLIC SMALL LETTER TSE
<c%>                   /xF7   <U0447> CYRILLIC SMALL LETTER CHE
<s%>                   /xF8   <U0448> CYRILLIC SMALL LETTER SHA
<sc>                   /xF9   <U0449> CYRILLIC SMALL LETTER SHCHA
<='>                   /xFA   <U044A> CYRILLIC SMALL LETTER HARD SIGN
<y=>                   /xFB   <U044B> CYRILLIC SMALL LETTER YERU
<%'>                   /xFC   <U044C> CYRILLIC SMALL LETTER SOFT SIGN
<je>                   /xFD   <U044D> CYRILLIC SMALL LETTER E
<ju>                   /xFE   <U044E> CYRILLIC SMALL LETTER YU
<ja>                   /xFF   <U044F> CYRILLIC SMALL LETTER YA
END CHARMAP

"
! !

!MS_Cyrillic methodsFor:'encoding & decoding'!

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
           "16r0080"    16r0402 " CYRILLIC CAPITAL LETTER DJE (Serbocroatian) " 
           "16r0081"    16r0403 " CYRILLIC CAPITAL LETTER GJE " 
           "16r0082"    16r201A " SINGLE LOW-9 QUOTATION MARK " 
           "16r0083"    16r0453 " CYRILLIC SMALL LETTER GJE " 
           "16r0084"    16r201E " DOUBLE LOW-9 QUOTATION MARK " 
           "16r0085"    16r2026 " HORIZONTAL ELLIPSIS " 
           "16r0086"    16r2020 " DAGGER " 
           "16r0087"    16r2021 " DOUBLE DAGGER " 
           "16r0088"    16r0000 " invalid " 
           "16r0089"    16r2030 " PER MILLE SIGN " 
           "16r008A"    16r0409 " CYRILLIC CAPITAL LETTER LJE " 
           "16r008B"    16r2039 " SINGLE LEFT-POINTING ANGLE QUOTATION MARK " 
           "16r008C"    16r040A " CYRILLIC CAPITAL LETTER NJE " 
           "16r008D"    16r040C " CYRILLIC CAPITAL LETTER KJE " 
           "16r008E"    16r040B " CYRILLIC CAPITAL LETTER TSHE (Serbocroatian) " 
           "16r008F"    16r040F " CYRILLIC CAPITAL LETTER DZHE " 
           "16r0090"    16r0452 " CYRILLIC SMALL LETTER DJE (Serbocroatian) " 
           "16r0091"    16r2018 " LEFT SINGLE QUOTATION MARK " 
           "16r0092"    16r2019 " RIGHT SINGLE QUOTATION MARK " 
           "16r0093"    16r201C " LEFT DOUBLE QUOTATION MARK " 
           "16r0094"    16r201D " RIGHT DOUBLE QUOTATION MARK " 
           "16r0095"    16r2022 " BULLET " 
           "16r0096"    16r2013 " EN DASH " 
           "16r0097"    16r2014 " EM DASH " 
           "16r0098"    16r0000 " invalid " 
           "16r0099"    16r2122 " TRADE MARK SIGN " 
           "16r009A"    16r0459 " CYRILLIC SMALL LETTER LJE " 
           "16r009B"    16r203A " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK " 
           "16r009C"    16r045A " CYRILLIC SMALL LETTER NJE " 
           "16r009D"    16r045C " CYRILLIC SMALL LETTER KJE " 
           "16r009E"    16r045B " CYRILLIC SMALL LETTER TSHE (Serbocroatian) " 
           "16r009F"    16r045F " CYRILLIC SMALL LETTER DZHE " 
           "16r00A0"    16r00A0 " NO-BREAK SPACE " 
           "16r00A1"    16r040E " CYRILLIC CAPITAL LETTER SHORT U (Byelorussian) " 
           "16r00A2"    16r045E " CYRILLIC SMALL LETTER SHORT U (Byelorussian) " 
           "16r00A3"    16r0408 " CYRILLIC CAPITAL LETTER JE " 
           "16r00A4"    16r00A4 " CURRENCY SIGN " 
           "16r00A5"    16r0490 " CYRILLIC CAPITAL LETTER GHE WITH UPTURN " 
           "16r00A6"    16r00A6 " BROKEN BAR " 
           "16r00A7"    16r00A7 " SECTION SIGN " 
           "16r00A8"    16r0401 " CYRILLIC CAPITAL LETTER IO " 
           "16r00A9"    16r00A9 " COPYRIGHT SIGN " 
           "16r00AA"    16r0404 " CYRILLIC CAPITAL LETTER UKRAINIAN IE " 
           "16r00AB"    16r00AB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00AC"    16r00AC " NOT SIGN " 
           "16r00AD"    16r00AD " SOFT HYPHEN " 
           "16r00AE"    16r00AE " REGISTERED SIGN " 
           "16r00AF"    16r0407 " CYRILLIC CAPITAL LETTER YI (Ukrainian) " 
           "16r00B0"    16r00B0 " DEGREE SIGN " 
           "16r00B1"    16r00B1 " PLUS-MINUS SIGN " 
           "16r00B2"    16r0406 " CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I " 
           "16r00B3"    16r0456 " CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I " 
           "16r00B4"    16r0491 " CYRILLIC SMALL LETTER GHE WITH UPTURN " 
           "16r00B5"    16r00B5 " MICRO SIGN " 
           "16r00B6"    16r00B6 " PILCROW SIGN " 
           "16r00B7"    16r00B7 " MIDDLE DOT " 
           "16r00B8"    16r0451 " CYRILLIC SMALL LETTER IO " 
           "16r00B9"    16r2116 " NUMERO SIGN " 
           "16r00BA"    16r0454 " CYRILLIC SMALL LETTER UKRAINIAN IE " 
           "16r00BB"    16r00BB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
           "16r00BC"    16r0458 " CYRILLIC SMALL LETTER JE " 
           "16r00BD"    16r0405 " CYRILLIC CAPITAL LETTER DZE " 
           "16r00BE"    16r0455 " CYRILLIC SMALL LETTER DZE " 
           "16r00BF"    16r0457 " CYRILLIC SMALL LETTER YI (Ukrainian) " 
           "16r00C0"    16r0410 " CYRILLIC CAPITAL LETTER A " 
           "16r00C1"    16r0411 " CYRILLIC CAPITAL LETTER BE " 
           "16r00C2"    16r0412 " CYRILLIC CAPITAL LETTER VE " 
           "16r00C3"    16r0413 " CYRILLIC CAPITAL LETTER GHE " 
           "16r00C4"    16r0414 " CYRILLIC CAPITAL LETTER DE " 
           "16r00C5"    16r0415 " CYRILLIC CAPITAL LETTER IE " 
           "16r00C6"    16r0416 " CYRILLIC CAPITAL LETTER ZHE " 
           "16r00C7"    16r0417 " CYRILLIC CAPITAL LETTER ZE " 
           "16r00C8"    16r0418 " CYRILLIC CAPITAL LETTER I " 
           "16r00C9"    16r0419 " CYRILLIC CAPITAL LETTER SHORT I " 
           "16r00CA"    16r041A " CYRILLIC CAPITAL LETTER KA " 
           "16r00CB"    16r041B " CYRILLIC CAPITAL LETTER EL " 
           "16r00CC"    16r041C " CYRILLIC CAPITAL LETTER EM " 
           "16r00CD"    16r041D " CYRILLIC CAPITAL LETTER EN " 
           "16r00CE"    16r041E " CYRILLIC CAPITAL LETTER O " 
           "16r00CF"    16r041F " CYRILLIC CAPITAL LETTER PE " 
           "16r00D0"    16r0420 " CYRILLIC CAPITAL LETTER ER " 
           "16r00D1"    16r0421 " CYRILLIC CAPITAL LETTER ES " 
           "16r00D2"    16r0422 " CYRILLIC CAPITAL LETTER TE " 
           "16r00D3"    16r0423 " CYRILLIC CAPITAL LETTER U " 
           "16r00D4"    16r0424 " CYRILLIC CAPITAL LETTER EF " 
           "16r00D5"    16r0425 " CYRILLIC CAPITAL LETTER HA " 
           "16r00D6"    16r0426 " CYRILLIC CAPITAL LETTER TSE " 
           "16r00D7"    16r0427 " CYRILLIC CAPITAL LETTER CHE " 
           "16r00D8"    16r0428 " CYRILLIC CAPITAL LETTER SHA " 
           "16r00D9"    16r0429 " CYRILLIC CAPITAL LETTER SHCHA " 
           "16r00DA"    16r042A " CYRILLIC CAPITAL LETTER HARD SIGN " 
           "16r00DB"    16r042B " CYRILLIC CAPITAL LETTER YERU " 
           "16r00DC"    16r042C " CYRILLIC CAPITAL LETTER SOFT SIGN " 
           "16r00DD"    16r042D " CYRILLIC CAPITAL LETTER E " 
           "16r00DE"    16r042E " CYRILLIC CAPITAL LETTER YU " 
           "16r00DF"    16r042F " CYRILLIC CAPITAL LETTER YA " 
           "16r00E0"    16r0430 " CYRILLIC SMALL LETTER A " 
           "16r00E1"    16r0431 " CYRILLIC SMALL LETTER BE " 
           "16r00E2"    16r0432 " CYRILLIC SMALL LETTER VE " 
           "16r00E3"    16r0433 " CYRILLIC SMALL LETTER GHE " 
           "16r00E4"    16r0434 " CYRILLIC SMALL LETTER DE " 
           "16r00E5"    16r0435 " CYRILLIC SMALL LETTER IE " 
           "16r00E6"    16r0436 " CYRILLIC SMALL LETTER ZHE " 
           "16r00E7"    16r0437 " CYRILLIC SMALL LETTER ZE " 
           "16r00E8"    16r0438 " CYRILLIC SMALL LETTER I " 
           "16r00E9"    16r0439 " CYRILLIC SMALL LETTER SHORT I " 
           "16r00EA"    16r043A " CYRILLIC SMALL LETTER KA " 
           "16r00EB"    16r043B " CYRILLIC SMALL LETTER EL " 
           "16r00EC"    16r043C " CYRILLIC SMALL LETTER EM " 
           "16r00ED"    16r043D " CYRILLIC SMALL LETTER EN " 
           "16r00EE"    16r043E " CYRILLIC SMALL LETTER O " 
           "16r00EF"    16r043F " CYRILLIC SMALL LETTER PE " 
           "16r00F0"    16r0440 " CYRILLIC SMALL LETTER ER " 
           "16r00F1"    16r0441 " CYRILLIC SMALL LETTER ES " 
           "16r00F2"    16r0442 " CYRILLIC SMALL LETTER TE " 
           "16r00F3"    16r0443 " CYRILLIC SMALL LETTER U " 
           "16r00F4"    16r0444 " CYRILLIC SMALL LETTER EF " 
           "16r00F5"    16r0445 " CYRILLIC SMALL LETTER HA " 
           "16r00F6"    16r0446 " CYRILLIC SMALL LETTER TSE " 
           "16r00F7"    16r0447 " CYRILLIC SMALL LETTER CHE " 
           "16r00F8"    16r0448 " CYRILLIC SMALL LETTER SHA " 
           "16r00F9"    16r0449 " CYRILLIC SMALL LETTER SHCHA " 
           "16r00FA"    16r044A " CYRILLIC SMALL LETTER HARD SIGN " 
           "16r00FB"    16r044B " CYRILLIC SMALL LETTER YERU " 
           "16r00FC"    16r044C " CYRILLIC SMALL LETTER SOFT SIGN " 
           "16r00FD"    16r044D " CYRILLIC SMALL LETTER E " 
           "16r00FE"    16r044E " CYRILLIC SMALL LETTER YU " 
           "16r00FF"    16r044F " CYRILLIC SMALL LETTER YA " 
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
    unicode <= 16r491 ifTrue:[
        unicode <= 16rBB ifTrue:[
            [
                |t|
                t := #[
                   "16r00A0"    16rA0 " NO-BREAK SPACE " 
                   "16r00A1"    16r00 " invalid " 
                   "16r00A2"    16r00 " invalid " 
                   "16r00A3"    16r00 " invalid " 
                   "16r00A4"    16rA4 " CURRENCY SIGN " 
                   "16r00A5"    16r00 " invalid " 
                   "16r00A6"    16rA6 " BROKEN BAR " 
                   "16r00A7"    16rA7 " SECTION SIGN " 
                   "16r00A8"    16r00 " invalid " 
                   "16r00A9"    16rA9 " COPYRIGHT SIGN " 
                   "16r00AA"    16r00 " invalid " 
                   "16r00AB"    16rAB " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                   "16r00AC"    16rAC " NOT SIGN " 
                   "16r00AD"    16rAD " SOFT HYPHEN " 
                   "16r00AE"    16rAE " REGISTERED SIGN " 
                   "16r00AF"    16r00 " invalid " 
                   "16r00B0"    16rB0 " DEGREE SIGN " 
                   "16r00B1"    16rB1 " PLUS-MINUS SIGN " 
                   "16r00B2"    16r00 " invalid " 
                   "16r00B3"    16r00 " invalid " 
                   "16r00B4"    16r00 " invalid " 
                   "16r00B5"    16rB5 " MICRO SIGN " 
                   "16r00B6"    16rB6 " PILCROW SIGN " 
                   "16r00B7"    16rB7 " MIDDLE DOT " 
                   "16r00B8"    16r00 " invalid " 
                   "16r00B9"    16r00 " invalid " 
                   "16r00BA"    16r00 " invalid " 
                   "16r00BB"    16rBB " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK " 
                   ] at:(unicode - 16r9F).
                t == 0 ifFalse:[^ t].
                ^ self encodingError
            ] value.
        ].
        unicode <= 16r400 ifTrue:[
            ^ self encodingError
        ].
        unicode <= 16r45F ifTrue:[
            [
                |t|
                t := #[
                   "16r0401"    16rA8 " CYRILLIC CAPITAL LETTER IO " 
                   "16r0402"    16r80 " CYRILLIC CAPITAL LETTER DJE (Serbocroatian) " 
                   "16r0403"    16r81 " CYRILLIC CAPITAL LETTER GJE " 
                   "16r0404"    16rAA " CYRILLIC CAPITAL LETTER UKRAINIAN IE " 
                   "16r0405"    16rBD " CYRILLIC CAPITAL LETTER DZE " 
                   "16r0406"    16rB2 " CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I " 
                   "16r0407"    16rAF " CYRILLIC CAPITAL LETTER YI (Ukrainian) " 
                   "16r0408"    16rA3 " CYRILLIC CAPITAL LETTER JE " 
                   "16r0409"    16r8A " CYRILLIC CAPITAL LETTER LJE " 
                   "16r040A"    16r8C " CYRILLIC CAPITAL LETTER NJE " 
                   "16r040B"    16r8E " CYRILLIC CAPITAL LETTER TSHE (Serbocroatian) " 
                   "16r040C"    16r8D " CYRILLIC CAPITAL LETTER KJE " 
                   "16r040D"    16r00 " invalid " 
                   "16r040E"    16rA1 " CYRILLIC CAPITAL LETTER SHORT U (Byelorussian) " 
                   "16r040F"    16r8F " CYRILLIC CAPITAL LETTER DZHE " 
                   "16r0410"    16rC0 " CYRILLIC CAPITAL LETTER A " 
                   "16r0411"    16rC1 " CYRILLIC CAPITAL LETTER BE " 
                   "16r0412"    16rC2 " CYRILLIC CAPITAL LETTER VE " 
                   "16r0413"    16rC3 " CYRILLIC CAPITAL LETTER GHE " 
                   "16r0414"    16rC4 " CYRILLIC CAPITAL LETTER DE " 
                   "16r0415"    16rC5 " CYRILLIC CAPITAL LETTER IE " 
                   "16r0416"    16rC6 " CYRILLIC CAPITAL LETTER ZHE " 
                   "16r0417"    16rC7 " CYRILLIC CAPITAL LETTER ZE " 
                   "16r0418"    16rC8 " CYRILLIC CAPITAL LETTER I " 
                   "16r0419"    16rC9 " CYRILLIC CAPITAL LETTER SHORT I " 
                   "16r041A"    16rCA " CYRILLIC CAPITAL LETTER KA " 
                   "16r041B"    16rCB " CYRILLIC CAPITAL LETTER EL " 
                   "16r041C"    16rCC " CYRILLIC CAPITAL LETTER EM " 
                   "16r041D"    16rCD " CYRILLIC CAPITAL LETTER EN " 
                   "16r041E"    16rCE " CYRILLIC CAPITAL LETTER O " 
                   "16r041F"    16rCF " CYRILLIC CAPITAL LETTER PE " 
                   "16r0420"    16rD0 " CYRILLIC CAPITAL LETTER ER " 
                   "16r0421"    16rD1 " CYRILLIC CAPITAL LETTER ES " 
                   "16r0422"    16rD2 " CYRILLIC CAPITAL LETTER TE " 
                   "16r0423"    16rD3 " CYRILLIC CAPITAL LETTER U " 
                   "16r0424"    16rD4 " CYRILLIC CAPITAL LETTER EF " 
                   "16r0425"    16rD5 " CYRILLIC CAPITAL LETTER HA " 
                   "16r0426"    16rD6 " CYRILLIC CAPITAL LETTER TSE " 
                   "16r0427"    16rD7 " CYRILLIC CAPITAL LETTER CHE " 
                   "16r0428"    16rD8 " CYRILLIC CAPITAL LETTER SHA " 
                   "16r0429"    16rD9 " CYRILLIC CAPITAL LETTER SHCHA " 
                   "16r042A"    16rDA " CYRILLIC CAPITAL LETTER HARD SIGN " 
                   "16r042B"    16rDB " CYRILLIC CAPITAL LETTER YERU " 
                   "16r042C"    16rDC " CYRILLIC CAPITAL LETTER SOFT SIGN " 
                   "16r042D"    16rDD " CYRILLIC CAPITAL LETTER E " 
                   "16r042E"    16rDE " CYRILLIC CAPITAL LETTER YU " 
                   "16r042F"    16rDF " CYRILLIC CAPITAL LETTER YA " 
                   "16r0430"    16rE0 " CYRILLIC SMALL LETTER A " 
                   "16r0431"    16rE1 " CYRILLIC SMALL LETTER BE " 
                   "16r0432"    16rE2 " CYRILLIC SMALL LETTER VE " 
                   "16r0433"    16rE3 " CYRILLIC SMALL LETTER GHE " 
                   "16r0434"    16rE4 " CYRILLIC SMALL LETTER DE " 
                   "16r0435"    16rE5 " CYRILLIC SMALL LETTER IE " 
                   "16r0436"    16rE6 " CYRILLIC SMALL LETTER ZHE " 
                   "16r0437"    16rE7 " CYRILLIC SMALL LETTER ZE " 
                   "16r0438"    16rE8 " CYRILLIC SMALL LETTER I " 
                   "16r0439"    16rE9 " CYRILLIC SMALL LETTER SHORT I " 
                   "16r043A"    16rEA " CYRILLIC SMALL LETTER KA " 
                   "16r043B"    16rEB " CYRILLIC SMALL LETTER EL " 
                   "16r043C"    16rEC " CYRILLIC SMALL LETTER EM " 
                   "16r043D"    16rED " CYRILLIC SMALL LETTER EN " 
                   "16r043E"    16rEE " CYRILLIC SMALL LETTER O " 
                   "16r043F"    16rEF " CYRILLIC SMALL LETTER PE " 
                   "16r0440"    16rF0 " CYRILLIC SMALL LETTER ER " 
                   "16r0441"    16rF1 " CYRILLIC SMALL LETTER ES " 
                   "16r0442"    16rF2 " CYRILLIC SMALL LETTER TE " 
                   "16r0443"    16rF3 " CYRILLIC SMALL LETTER U " 
                   "16r0444"    16rF4 " CYRILLIC SMALL LETTER EF " 
                   "16r0445"    16rF5 " CYRILLIC SMALL LETTER HA " 
                   "16r0446"    16rF6 " CYRILLIC SMALL LETTER TSE " 
                   "16r0447"    16rF7 " CYRILLIC SMALL LETTER CHE " 
                   "16r0448"    16rF8 " CYRILLIC SMALL LETTER SHA " 
                   "16r0449"    16rF9 " CYRILLIC SMALL LETTER SHCHA " 
                   "16r044A"    16rFA " CYRILLIC SMALL LETTER HARD SIGN " 
                   "16r044B"    16rFB " CYRILLIC SMALL LETTER YERU " 
                   "16r044C"    16rFC " CYRILLIC SMALL LETTER SOFT SIGN " 
                   "16r044D"    16rFD " CYRILLIC SMALL LETTER E " 
                   "16r044E"    16rFE " CYRILLIC SMALL LETTER YU " 
                   "16r044F"    16rFF " CYRILLIC SMALL LETTER YA " 
                   "16r0450"    16r00 " invalid " 
                   "16r0451"    16rB8 " CYRILLIC SMALL LETTER IO " 
                   "16r0452"    16r90 " CYRILLIC SMALL LETTER DJE (Serbocroatian) " 
                   "16r0453"    16r83 " CYRILLIC SMALL LETTER GJE " 
                   "16r0454"    16rBA " CYRILLIC SMALL LETTER UKRAINIAN IE " 
                   "16r0455"    16rBE " CYRILLIC SMALL LETTER DZE " 
                   "16r0456"    16rB3 " CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I " 
                   "16r0457"    16rBF " CYRILLIC SMALL LETTER YI (Ukrainian) " 
                   "16r0458"    16rBC " CYRILLIC SMALL LETTER JE " 
                   "16r0459"    16r9A " CYRILLIC SMALL LETTER LJE " 
                   "16r045A"    16r9C " CYRILLIC SMALL LETTER NJE " 
                   "16r045B"    16r9E " CYRILLIC SMALL LETTER TSHE (Serbocroatian) " 
                   "16r045C"    16r9D " CYRILLIC SMALL LETTER KJE " 
                   "16r045D"    16r00 " invalid " 
                   "16r045E"    16rA2 " CYRILLIC SMALL LETTER SHORT U (Byelorussian) " 
                   "16r045F"    16r9F " CYRILLIC SMALL LETTER DZHE " 
                   ] at:(unicode - 16r400).
                t == 0 ifFalse:[^ t].
                ^ self encodingError
            ] value.
        ].
        unicode <= 16r48F ifTrue:[
            ^ self encodingError
        ].
        ^ #[
           "16r0490"    16rA5 " CYRILLIC CAPITAL LETTER GHE WITH UPTURN " 
           "16r0491"    16rB4 " CYRILLIC SMALL LETTER GHE WITH UPTURN " 
           ] at:(unicode - 16r48F).
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
    unicode <= 16r2115 ifTrue:[
        ^ self encodingError
    ].
    unicode == 16r2116 ifTrue:[
        (#[
           "16r2116"    1 " NUMERO SIGN " 
        ] at:(unicode - 8469)) ~~ 0 ifTrue:[^ unicode].
        ^ self encodingError
    ].
    unicode <= 16r2121 ifTrue:[
        ^ self encodingError
    ].
    ^  "16r2122" 16r0099 " TRADE MARK SIGN " 
! !

!MS_Cyrillic class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__MS_Cyrillic.st,v 1.4 2005/03/31 18:48:53 cg Exp $'
!

version_SVN
    ^ '$Id: CharacterEncoderImplementations__MS_Cyrillic.st 10807 2012-05-05 21:58:24Z vranyj1 $'
! !



