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

SingleByteEncoder subclass:#KOI7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!KOI7 class methodsFor:'documentation'!

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
! !

!KOI7 class methodsFor:'mapping'!

mapFileURL2_relativePathName
    ^ 'KOI-7'
!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/KOI-7

<code_set_name> ISO_5427
<comment_char> %
<escape_char> /
% version: 1.0
% repertoiremap: mnemonic,ds
%  source: ECMA registry

% alias ISO-IR-37
% alias KOI-7
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
<Cu>                   /x24   <U00A4> CURRENCY SIGN
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
<ju>                   /x40   <U044E> CYRILLIC SMALL LETTER YU
<a=>                   /x41   <U0430> CYRILLIC SMALL LETTER A
<b=>                   /x42   <U0431> CYRILLIC SMALL LETTER BE
<c=>                   /x43   <U0446> CYRILLIC SMALL LETTER TSE
<d=>                   /x44   <U0434> CYRILLIC SMALL LETTER DE
<e=>                   /x45   <U0435> CYRILLIC SMALL LETTER IE
<f=>                   /x46   <U0444> CYRILLIC SMALL LETTER EF
<g=>                   /x47   <U0433> CYRILLIC SMALL LETTER GHE
<h=>                   /x48   <U0445> CYRILLIC SMALL LETTER HA
<i=>                   /x49   <U0438> CYRILLIC SMALL LETTER I
<j=>                   /x4A   <U0439> CYRILLIC SMALL LETTER SHORT I
<k=>                   /x4B   <U043A> CYRILLIC SMALL LETTER KA
<l=>                   /x4C   <U043B> CYRILLIC SMALL LETTER EL
<m=>                   /x4D   <U043C> CYRILLIC SMALL LETTER EM
<n=>                   /x4E   <U043D> CYRILLIC SMALL LETTER EN
<o=>                   /x4F   <U043E> CYRILLIC SMALL LETTER O
<p=>                   /x50   <U043F> CYRILLIC SMALL LETTER PE
<ja>                   /x51   <U044F> CYRILLIC SMALL LETTER YA
<r=>                   /x52   <U0440> CYRILLIC SMALL LETTER ER
<s=>                   /x53   <U0441> CYRILLIC SMALL LETTER ES
<t=>                   /x54   <U0442> CYRILLIC SMALL LETTER TE
<u=>                   /x55   <U0443> CYRILLIC SMALL LETTER U
<z%>                   /x56   <U0436> CYRILLIC SMALL LETTER ZHE
<v=>                   /x57   <U0432> CYRILLIC SMALL LETTER VE
<%'>                   /x58   <U044C> CYRILLIC SMALL LETTER SOFT SIGN
<y=>                   /x59   <U044B> CYRILLIC SMALL LETTER YERU
<z=>                   /x5A   <U0437> CYRILLIC SMALL LETTER ZE
<s%>                   /x5B   <U0448> CYRILLIC SMALL LETTER SHA
<je>                   /x5C   <U044D> CYRILLIC SMALL LETTER E
<sc>                   /x5D   <U0449> CYRILLIC SMALL LETTER SHCHA
<c%>                   /x5E   <U0447> CYRILLIC SMALL LETTER CHE
<='>                   /x5F   <U044A> CYRILLIC SMALL LETTER HARD SIGN
<JU>                   /x60   <U042E> CYRILLIC CAPITAL LETTER YU
<A=>                   /x61   <U0410> CYRILLIC CAPITAL LETTER A
<B=>                   /x62   <U0411> CYRILLIC CAPITAL LETTER BE
<C=>                   /x63   <U0426> CYRILLIC CAPITAL LETTER TSE
<D=>                   /x64   <U0414> CYRILLIC CAPITAL LETTER DE
<E=>                   /x65   <U0415> CYRILLIC CAPITAL LETTER IE
<F=>                   /x66   <U0424> CYRILLIC CAPITAL LETTER EF
<G=>                   /x67   <U0413> CYRILLIC CAPITAL LETTER GHE
<H=>                   /x68   <U0425> CYRILLIC CAPITAL LETTER HA
<I=>                   /x69   <U0418> CYRILLIC CAPITAL LETTER I
<J=>                   /x6A   <U0419> CYRILLIC CAPITAL LETTER SHORT I
<K=>                   /x6B   <U041A> CYRILLIC CAPITAL LETTER KA
<L=>                   /x6C   <U041B> CYRILLIC CAPITAL LETTER EL
<M=>                   /x6D   <U041C> CYRILLIC CAPITAL LETTER EM
<N=>                   /x6E   <U041D> CYRILLIC CAPITAL LETTER EN
<O=>                   /x6F   <U041E> CYRILLIC CAPITAL LETTER O
<P=>                   /x70   <U041F> CYRILLIC CAPITAL LETTER PE
<JA>                   /x71   <U042F> CYRILLIC CAPITAL LETTER YA
<R=>                   /x72   <U0420> CYRILLIC CAPITAL LETTER ER
<S=>                   /x73   <U0421> CYRILLIC CAPITAL LETTER ES
<T=>                   /x74   <U0422> CYRILLIC CAPITAL LETTER TE
<U=>                   /x75   <U0423> CYRILLIC CAPITAL LETTER U
<Z%>                   /x76   <U0416> CYRILLIC CAPITAL LETTER ZHE
<V=>                   /x77   <U0412> CYRILLIC CAPITAL LETTER VE
<%'>                   /x78   <U042C> CYRILLIC CAPITAL LETTER SOFT SIGN
<Y=>                   /x79   <U042B> CYRILLIC CAPITAL LETTER YERU
<Z=>                   /x7A   <U0417> CYRILLIC CAPITAL LETTER ZE
<S%>                   /x7B   <U0428> CYRILLIC CAPITAL LETTER SHA
<JE>                   /x7C   <U042D> CYRILLIC CAPITAL LETTER E
<Sc>                   /x7D   <U0429> CYRILLIC CAPITAL LETTER SHCHA
<C%>                   /x7E   <U0427> CYRILLIC CAPITAL LETTER CHE
<DT>                   /x7F   <U007F> DELETE (DEL)
END CHARMAP

"
! !

!KOI7 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Cyrillic (Old)'
! !

!KOI7 methodsFor:'encoding & decoding'!

decode:codeArg
    "Decode from my encoding into unicode."

    |code "{ Class: SmallInteger }"|

    code := codeArg.
    code == 16r24 ifTrue:[
        ^  "16r0024" 16r00A4 " CURRENCY SIGN " 
    ].
    code <= 16r3F ifTrue:[ ^ code ].
    code > 16r7F ifTrue:[
        ^ self decodingError.
    ].
    ^ #(
       "16r0040"    16r044E " CYRILLIC SMALL LETTER YU " 
       "16r0041"    16r0430 " CYRILLIC SMALL LETTER A " 
       "16r0042"    16r0431 " CYRILLIC SMALL LETTER BE " 
       "16r0043"    16r0446 " CYRILLIC SMALL LETTER TSE " 
       "16r0044"    16r0434 " CYRILLIC SMALL LETTER DE " 
       "16r0045"    16r0435 " CYRILLIC SMALL LETTER IE " 
       "16r0046"    16r0444 " CYRILLIC SMALL LETTER EF " 
       "16r0047"    16r0433 " CYRILLIC SMALL LETTER GHE " 
       "16r0048"    16r0445 " CYRILLIC SMALL LETTER HA " 
       "16r0049"    16r0438 " CYRILLIC SMALL LETTER I " 
       "16r004A"    16r0439 " CYRILLIC SMALL LETTER SHORT I " 
       "16r004B"    16r043A " CYRILLIC SMALL LETTER KA " 
       "16r004C"    16r043B " CYRILLIC SMALL LETTER EL " 
       "16r004D"    16r043C " CYRILLIC SMALL LETTER EM " 
       "16r004E"    16r043D " CYRILLIC SMALL LETTER EN " 
       "16r004F"    16r043E " CYRILLIC SMALL LETTER O " 
       "16r0050"    16r043F " CYRILLIC SMALL LETTER PE " 
       "16r0051"    16r044F " CYRILLIC SMALL LETTER YA " 
       "16r0052"    16r0440 " CYRILLIC SMALL LETTER ER " 
       "16r0053"    16r0441 " CYRILLIC SMALL LETTER ES " 
       "16r0054"    16r0442 " CYRILLIC SMALL LETTER TE " 
       "16r0055"    16r0443 " CYRILLIC SMALL LETTER U " 
       "16r0056"    16r0436 " CYRILLIC SMALL LETTER ZHE " 
       "16r0057"    16r0432 " CYRILLIC SMALL LETTER VE " 
       "16r0058"    16r044C " CYRILLIC SMALL LETTER SOFT SIGN " 
       "16r0059"    16r044B " CYRILLIC SMALL LETTER YERU " 
       "16r005A"    16r0437 " CYRILLIC SMALL LETTER ZE " 
       "16r005B"    16r0448 " CYRILLIC SMALL LETTER SHA " 
       "16r005C"    16r044D " CYRILLIC SMALL LETTER E " 
       "16r005D"    16r0449 " CYRILLIC SMALL LETTER SHCHA " 
       "16r005E"    16r0447 " CYRILLIC SMALL LETTER CHE " 
       "16r005F"    16r044A " CYRILLIC SMALL LETTER HARD SIGN " 
       "16r0060"    16r042E " CYRILLIC CAPITAL LETTER YU " 
       "16r0061"    16r0410 " CYRILLIC CAPITAL LETTER A " 
       "16r0062"    16r0411 " CYRILLIC CAPITAL LETTER BE " 
       "16r0063"    16r0426 " CYRILLIC CAPITAL LETTER TSE " 
       "16r0064"    16r0414 " CYRILLIC CAPITAL LETTER DE " 
       "16r0065"    16r0415 " CYRILLIC CAPITAL LETTER IE " 
       "16r0066"    16r0424 " CYRILLIC CAPITAL LETTER EF " 
       "16r0067"    16r0413 " CYRILLIC CAPITAL LETTER GHE " 
       "16r0068"    16r0425 " CYRILLIC CAPITAL LETTER HA " 
       "16r0069"    16r0418 " CYRILLIC CAPITAL LETTER I " 
       "16r006A"    16r0419 " CYRILLIC CAPITAL LETTER SHORT I " 
       "16r006B"    16r041A " CYRILLIC CAPITAL LETTER KA " 
       "16r006C"    16r041B " CYRILLIC CAPITAL LETTER EL " 
       "16r006D"    16r041C " CYRILLIC CAPITAL LETTER EM " 
       "16r006E"    16r041D " CYRILLIC CAPITAL LETTER EN " 
       "16r006F"    16r041E " CYRILLIC CAPITAL LETTER O " 
       "16r0070"    16r041F " CYRILLIC CAPITAL LETTER PE " 
       "16r0071"    16r042F " CYRILLIC CAPITAL LETTER YA " 
       "16r0072"    16r0420 " CYRILLIC CAPITAL LETTER ER " 
       "16r0073"    16r0421 " CYRILLIC CAPITAL LETTER ES " 
       "16r0074"    16r0422 " CYRILLIC CAPITAL LETTER TE " 
       "16r0075"    16r0423 " CYRILLIC CAPITAL LETTER U " 
       "16r0076"    16r0416 " CYRILLIC CAPITAL LETTER ZHE " 
       "16r0077"    16r0412 " CYRILLIC CAPITAL LETTER VE " 
       "16r0078"    16r042C " CYRILLIC CAPITAL LETTER SOFT SIGN " 
       "16r0079"    16r042B " CYRILLIC CAPITAL LETTER YERU " 
       "16r007A"    16r0417 " CYRILLIC CAPITAL LETTER ZE " 
       "16r007B"    16r0428 " CYRILLIC CAPITAL LETTER SHA " 
       "16r007C"    16r042D " CYRILLIC CAPITAL LETTER E " 
       "16r007D"    16r0429 " CYRILLIC CAPITAL LETTER SHCHA " 
       "16r007E"    16r0427 " CYRILLIC CAPITAL LETTER CHE " 
       "16r007F"    16r007F " DELETE (DEL) " 
       ) at:(code - 16r3F).
!

encode:unicodeArg
    "Automagically generated by generateCode - do not modify.
     Encode from unicode into my encoding."

    |unicode "{ Class: SmallInteger }"|

    unicode := unicodeArg.
    unicode <= 16r23 ifTrue:[ ^ unicode ].
    unicode > 16r44F ifTrue:[
        ^ self encodingError.
    ].
    unicode == 16r24 ifTrue:[
        ^ self encodingError
    ].
    unicode <= 16rA4 ifTrue:[
        unicode <= 16r3F ifTrue:[
            ^ unicode
        ].
        unicode <= 16r7E ifTrue:[
            ^ self encodingError
        ].
        unicode == 16r7F ifTrue:[
            ^  "16r007F" 16r007F " DELETE (DEL) " 
        ].
        unicode <= 16rA3 ifTrue:[
            ^ self encodingError
        ].
        ^  "16r00A4" 16r0024 " CURRENCY SIGN " 
    ].
    unicode <= 16r40F ifTrue:[
        ^ self encodingError
    ].
    [
        |t|
        t := #[
           "16r0410"    16r61 " CYRILLIC CAPITAL LETTER A " 
           "16r0411"    16r62 " CYRILLIC CAPITAL LETTER BE " 
           "16r0412"    16r77 " CYRILLIC CAPITAL LETTER VE " 
           "16r0413"    16r67 " CYRILLIC CAPITAL LETTER GHE " 
           "16r0414"    16r64 " CYRILLIC CAPITAL LETTER DE " 
           "16r0415"    16r65 " CYRILLIC CAPITAL LETTER IE " 
           "16r0416"    16r76 " CYRILLIC CAPITAL LETTER ZHE " 
           "16r0417"    16r7A " CYRILLIC CAPITAL LETTER ZE " 
           "16r0418"    16r69 " CYRILLIC CAPITAL LETTER I " 
           "16r0419"    16r6A " CYRILLIC CAPITAL LETTER SHORT I " 
           "16r041A"    16r6B " CYRILLIC CAPITAL LETTER KA " 
           "16r041B"    16r6C " CYRILLIC CAPITAL LETTER EL " 
           "16r041C"    16r6D " CYRILLIC CAPITAL LETTER EM " 
           "16r041D"    16r6E " CYRILLIC CAPITAL LETTER EN " 
           "16r041E"    16r6F " CYRILLIC CAPITAL LETTER O " 
           "16r041F"    16r70 " CYRILLIC CAPITAL LETTER PE " 
           "16r0420"    16r72 " CYRILLIC CAPITAL LETTER ER " 
           "16r0421"    16r73 " CYRILLIC CAPITAL LETTER ES " 
           "16r0422"    16r74 " CYRILLIC CAPITAL LETTER TE " 
           "16r0423"    16r75 " CYRILLIC CAPITAL LETTER U " 
           "16r0424"    16r66 " CYRILLIC CAPITAL LETTER EF " 
           "16r0425"    16r68 " CYRILLIC CAPITAL LETTER HA " 
           "16r0426"    16r63 " CYRILLIC CAPITAL LETTER TSE " 
           "16r0427"    16r7E " CYRILLIC CAPITAL LETTER CHE " 
           "16r0428"    16r7B " CYRILLIC CAPITAL LETTER SHA " 
           "16r0429"    16r7D " CYRILLIC CAPITAL LETTER SHCHA " 
           "16r042A"    16r00 " invalid " 
           "16r042B"    16r79 " CYRILLIC CAPITAL LETTER YERU " 
           "16r042C"    16r78 " CYRILLIC CAPITAL LETTER SOFT SIGN " 
           "16r042D"    16r7C " CYRILLIC CAPITAL LETTER E " 
           "16r042E"    16r60 " CYRILLIC CAPITAL LETTER YU " 
           "16r042F"    16r71 " CYRILLIC CAPITAL LETTER YA " 
           "16r0430"    16r41 " CYRILLIC SMALL LETTER A " 
           "16r0431"    16r42 " CYRILLIC SMALL LETTER BE " 
           "16r0432"    16r57 " CYRILLIC SMALL LETTER VE " 
           "16r0433"    16r47 " CYRILLIC SMALL LETTER GHE " 
           "16r0434"    16r44 " CYRILLIC SMALL LETTER DE " 
           "16r0435"    16r45 " CYRILLIC SMALL LETTER IE " 
           "16r0436"    16r56 " CYRILLIC SMALL LETTER ZHE " 
           "16r0437"    16r5A " CYRILLIC SMALL LETTER ZE " 
           "16r0438"    16r49 " CYRILLIC SMALL LETTER I " 
           "16r0439"    16r4A " CYRILLIC SMALL LETTER SHORT I " 
           "16r043A"    16r4B " CYRILLIC SMALL LETTER KA " 
           "16r043B"    16r4C " CYRILLIC SMALL LETTER EL " 
           "16r043C"    16r4D " CYRILLIC SMALL LETTER EM " 
           "16r043D"    16r4E " CYRILLIC SMALL LETTER EN " 
           "16r043E"    16r4F " CYRILLIC SMALL LETTER O " 
           "16r043F"    16r50 " CYRILLIC SMALL LETTER PE " 
           "16r0440"    16r52 " CYRILLIC SMALL LETTER ER " 
           "16r0441"    16r53 " CYRILLIC SMALL LETTER ES " 
           "16r0442"    16r54 " CYRILLIC SMALL LETTER TE " 
           "16r0443"    16r55 " CYRILLIC SMALL LETTER U " 
           "16r0444"    16r46 " CYRILLIC SMALL LETTER EF " 
           "16r0445"    16r48 " CYRILLIC SMALL LETTER HA " 
           "16r0446"    16r43 " CYRILLIC SMALL LETTER TSE " 
           "16r0447"    16r5E " CYRILLIC SMALL LETTER CHE " 
           "16r0448"    16r5B " CYRILLIC SMALL LETTER SHA " 
           "16r0449"    16r5D " CYRILLIC SMALL LETTER SHCHA " 
           "16r044A"    16r5F " CYRILLIC SMALL LETTER HARD SIGN " 
           "16r044B"    16r59 " CYRILLIC SMALL LETTER YERU " 
           "16r044C"    16r58 " CYRILLIC SMALL LETTER SOFT SIGN " 
           "16r044D"    16r5C " CYRILLIC SMALL LETTER E " 
           "16r044E"    16r40 " CYRILLIC SMALL LETTER YU " 
           "16r044F"    16r51 " CYRILLIC SMALL LETTER YA " 
           ] at:(unicode - 16r40F).
        t == 0 ifFalse:[^ t].
        ^ self encodingError
    ] value.
! !

!KOI7 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__KOI7.st,v 1.4 2012-07-11 16:43:12 stefan Exp $'
! !
