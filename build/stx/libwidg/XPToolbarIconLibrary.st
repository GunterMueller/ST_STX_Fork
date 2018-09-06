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
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

GenericToolbarIconLibrary subclass:#XPToolbarIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!XPToolbarIconLibrary class methodsFor:'documentation'!

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
    ToolbarIconLibrary := XPToolbarIconLibrary.

    This is a style specific icon library for an XP look.

    Never access this iconlibrary directly from an application -
    always use ToolbarIconLibrary, which is an alias to one of the style specific
    icon libs.

    Notice and Warning:
        only redefine existing icons here; never only add here.
        For every icon-method here, there MUST be a corresponding (albeit
        possibly ugly) icon-method in GenericToolBarIcon.
"
! !

!XPToolbarIconLibrary class methodsFor:'image specs'!

addBreakPointIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addBreakPointIcon2 inspect
     ImageEditor openOnClass:self andSelector:#addBreakPointIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class addBreakPointIcon2'
        ifAbsentPut:[
            (Depth2Image new)
                width:12;
                height:21;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'EUUT_??=_:+=_%V=^TA-^P@-^P@-^P@-_ B=_:+=_??=_:+=_**=^)V-^%U-^%U-^UU-_%V=_:+=_??=EUUT');
                colorMapFromArray:#[ 255 0 0 63 63 63 0 0 0 127 127 127 ];
                mask:((ImageMask new)
                            width:12;
                            height:21;
                            bits:(ByteArray 
                                        fromPackedString:'_>C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<G? ');
                            yourself);
                yourself
        ]
!

addOverlayIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addOverlayIcon inspect
     ImageEditor openOnClass:self andSelector:#addOverlayIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class addOverlayIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:11;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
R@@@RT%RST1LTD9H@D%IT%MRSD1PS$!!RT$5RUEILT%INT%UVT%YWU%IVUUIHT%!!YV%-ZVU!!RWD!!MT%Y[@E-VT%5\RD1RU%,@V5YRWU1HT%!!YV%-ZVU!!RWEIU
U%IVU5YRU%URZ%IR@EITT ART&,@@@@@T%MR@@@@@@@@@@@@T @@@@@@');
                colorMapFromArray:#[ 255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 127 160 216 207 216 240 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 48 80 176 223 216 224 96 152 224 96 152 216 95 152 216 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 ];
                mask:((ImageMask new)
                            width:11;
                            height:12;
                            bits:(ByteArray fromPackedString:'A@@N@F;@?>A?0G>@O8A?0O? [,@N@@P@');
                            yourself);
                yourself
        ]
!

addOverlayIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addOverlayIcon2 inspect
     ImageEditor openOnClass:self andSelector:#addOverlayIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class addOverlayIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@% <@@@@@@@@@@@@@@C/P&.4@@@@@@@@@@@@@WGDIZ@@@@@@@@@@@@@B?B:Y(@@@@@@@@@@@@@N<AQ$8@@@@@@@CXFF=//:% S''L#^''(@H\''@X6ET
:4XINT=JR.T/PYMY\WEF78#DRL;N#@CHS$9N4P$+H7)2&I @@@@@@@B@RT=^@@@@@@@@@@@@@M%OFYD@@@@@@@@@@@@@W3CN" @@@@@@@@@@@@C'''' :4@@@@
@@@@@@@@@@@BIP@@@@@@@@@a');
                colorMapFromArray:#[ 176 175 128 176 240 159 143 159 128 240 240 208 240 223 128 192 160 112 192 159 79 191 160 111 255 240 208 127 208 96 255 255 224 175 239 144 239 239 176 191 176 175 15 79 0 160 176 95 255 208 128 255 240 224 208 207 192 192 160 111 239 223 111 175 160 159 255 240 207 47 32 31 0 160 0 64 176 48 95 80 79 176 160 128 111 128 48 143 128 127 208 208 207 255 240 223 208 207 191 112 159 95 79 64 63 0 96 0 240 224 160 144 159 143 255 255 223 239 224 176 224 223 127 176 160 127 160 159 144 96 207 80 240 224 128 224 224 223 223 207 207 127 159 111 63 175 48 160 144 96 112 111 96 175 159 112 240 239 176 255 224 127 239 223 143 176 144 96 191 159 111 96 207 79 224 224 175 80 176 64 240 239 143 223 208 159 176 127 64 144 144 143 240 224 159 31 159 31 240 239 175 223 208 191 208 207 144 160 144 143 143 224 112 240 239 208 64 176 63 95 207 79 63 160 47 207 191 144 160 128 64 255 224 176 0 127 0 80 191 64 208 192 143 239 207 112 223 192 96 160 143 111 176 240 144 239 224 192 255 239 160 207 192 176 223 191 95 143 239 112 255 224 175 240 224 207 15 160 15 80 79 79 16 95 16 0 80 0 143 224 111 191 240 159 255 224 143 175 240 144 208 176 80 207 191 143 63 63 48 240 208 128 15 127 15 255 239 191 192 192 191 207 207 207 207 176 112 63 48 47 112 112 111 0 175 0 223 207 191 144 239 127 0 79 0 0 112 0 239 224 223 159 159 144 224 223 192 223 192 160 111 96 47 191 176 159 0 95 0 255 255 240 239 224 191 192 191 191 176 176 175 207 175 112 15 112 15 208 192 192 144 143 96 240 223 143 223 192 159 223 191 128 176 160 112 175 175 175 111 207 80 96 95 80 16 79 16 176 160 144 15 79 15 159 144 143 240 240 176 128 127 112 224 223 191 16 80 16 192 175 127 128 223 111 191 159 96 31 31 16 159 159 63 80 80 79 15 64 15 160 159 159 31 144 16 255 240 192 240 240 224 208 207 207 16 80 15 64 64 63 160 160 160 160 143 96 143 144 128 224 208 143 255 239 143 176 144 111 128 224 111 159 144 128 255 240 191 176 239 159 96 96 95 111 111 96 207 207 192 160 160 159 240 208 144 175 143 111 240 223 160 255 208 112 223 223 208 192 176 112 95 112 80 144 128 80 240 224 144 255 240 239 255 255 208 192 192 176 207 191 160 160 144 128 240 208 143 32 32 31 224 223 208 15 175 15 144 224 127 64 63 48 48 48 47 144 112 48 95 192 79 240 224 192 240 239 160 239 192 96 31 95 15 32 160 31 159 143 80 175 175 160 224 223 207 223 208 208 48 159 47 191 176 176 32 159 31 15 128 15 224 224 191 240 224 191 240 239 159 192 192 175 176 175 160 79 79 64 95 160 47 0 111 0 127 112 111 223 208 207 208 191 128 207 176 128 191 191 176 127 223 96 255 224 159 31 16 15 255 239 176 207 192 192 192 175 111 15 80 0 240 240 192 64 112 63 240 255 208 223 192 175 192 191 176 159 239 127 191 191 175 95 159 79 240 208 112 16 175 16 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@0@G @^@A8@G G?8??3??G?8A8@G @^@A8@C@@@a');
                            yourself);
                yourself
        ]
!

addOverlayIcon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self addOverlayIcon3 inspect
     ImageEditor openOnClass:self andSelector:#addOverlayIcon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class addOverlayIcon3'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@K_ 5^ @@@@@@@@@@LGI*,\@@@@@@@@@@M*+5<\@@@@@@@@@@N&(.[4@@@@@8*;H2M+X1K7K,\3L7-/F1[?''.Z*6/+3%.MK@2\&99L;\.-?P7[6=/^F*
,;GL2-ST@@@@@L6;/,H@@@@@@@@@@NN>+=D@@@@@@@@@@LN57<<@@@@@@@@@@N[V+M$@@@@@') ; colorMapFromArray:#[255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 239 232 232 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 0 0 0 207 216 240 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 227 227 236 225 225 234 244 244 249 242 242 247 218 217 230 212 211 224 234 234 242 253 253 254 251 251 252 227 226 235 226 226 237 243 243 247 220 220 231 240 239 244 237 237 244 233 233 240 52 89 178 231 231 238 50 87 176 229 229 239 248 248 251 246 246 249 223 223 233 222 221 232 238 238 244 56 94 181 55 92 180 53 90 178 233 232 239 51 88 176 232 232 241 251 251 253 249 249 251 228 228 237 225 224 234 241 241 246 238 237 243 56 93 180 254 254 255 229 229 237 227 227 238 246 246 250 244 244 248 219 219 230 236 236 243 255 255 255 51 88 177 231 230 238 249 249 252 247 247 250 241 241 247 239 239 245 236 235 242 54 91 179 231 231 240 176 175 128 176 240 159 143 159 128 127 208 96 175 239 144 15 79 0 160 176 95 0 160 0 64 176 48 112 159 95 0 96 0 144 159 143 96 207 80 127 159 111 63 175 48 96 207 79 80 176 64 31 159 31 143 224 112 64 176 63 95 207 79 63 160 47 0 127 0 80 191 64 176 240 144 143 239 112 15 160 15 16 95 16 0 80 0 143 224 111 191 240 159 175 240 144 15 127 15 0 175 0 144 239 127 0 79 0 0 112 0 0 95 0 15 112 15 111 207 80 16 79 16 15 79 15 16 80 16 128 223 111 159 159 63 15 64 15 31 144 16 16 80 15 128 224 111 176 239 159 95 112 80 15 175 15 144 224 127 95 192 79 31 95 15 32 160 31 48 159 47 32 159 31 15 128 15 95 160 47 0 111 0 127 223 96 15 80 0 64 112 63 159 239 127 95 159 79 16 175 16]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0,O@@<EC0G?<O?0??C?<@<FC0DO@@<@') ; yourself); yourself]
!

addTab14x14Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self addTab14x14Icon inspect
     ImageEditor openOnClass:self andSelector:#addTab14x14Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary addTab14x14Icon'
        ifAbsentPut:[(Depth4Image width:14 height:14) bits:(ByteArray fromPackedString:'W]7]7]7]4M;]7]7]6;C].;.;.;.@7[.;.;.; M6;.>:;.8C].;/..;.@7[/.;.:; M6;;^;..8C].;/].;.@7[.;;+.; M6;.;.;.8C^.;.;.;"07X"H"H"K
,E@@@@@@@@@b') colorMapFromArray:#[0 0 0 17 17 17 34 34 34 51 51 51 68 68 68 85 85 85 102 102 102 119 119 119 136 136 136 153 153 153 170 170 170 187 187 187 204 204 204 221 221 221 238 238 238] mask:((ImageMask width:14 height:14) bits:(ByteArray fromPackedString:'_?O?>??;??/?>??;??/?>??;??/?>??;_?L@@0@a'); yourself); yourself]
!

changesBrowser18x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self changesBrowser18x22Icon inspect
     ImageEditor openOnClass:self andSelector:#changesBrowser18x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary changesBrowser18x22Icon'
        ifAbsentPut:[(Depth8Image new) width:18; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@ HB@@@@@@@@@" (JBL HB@ H@XB
@@@@@@HB@ HB@ HB@ HB@  B@@@@@@H(JB #HB@ HB@F@ (B@@@B@ HB@ HB@ HB@ HH@ LB@@@BJB (H2@ HB@ A HJ@ PB@ HB@ HB@ HB@ HBB@HC@ XB
@" (JBL HB@ H@ BB HD@ 8B@" A@PD#@RHXF@ B@0HF@ HB@" (JBT#H2LZE@(BA@HN@ @@@" AJ@D#@Q\TB LBA HB@ @@@" (JB\%GQ4LAPPBC H@@@@@
@" A@PD^@P$IA0XB@ H@@@@@@" ''I!!$YEALPC08B@@@@@@@@@ HB@ HB@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 78 78 91 127 127 127 201 201 218 204 204 219 206 206 221 208 208 223 210 210 224 211 211 225 213 213 228 215 215 229 216 216 230 218 218 231 219 219 232 220 220 233 222 222 235 224 224 236 225 225 237 228 228 238 229 229 239 230 230 240 232 232 241 234 234 243 235 235 244 236 236 244 238 238 245 239 239 246 240 240 247 241 241 248 242 242 249 243 243 249 244 244 250 245 245 252 246 246 253 248 248 254 249 249 254 250 250 255 252 252 255 253 253 255 254 254 255 255 255 255]; mask:((ImageMask new) width:18; height:22; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@??@@??@C??@C??@O??@O??@???@???@???@??<@??<@??0@??0@??@@??@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

changesBrowser22x24Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self changesBrowser22x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#changesBrowser22x24Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class changesBrowser22x24Icon2'
        ifAbsentPut:[(Depth8Image width:22 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ HB@ HB@ D@@@@@@@@@@@@@@(>O#8VB (JB %XA@@@@@@@@@@@B@ HB@ HB@ HB@ E[@P@@@@@@
@@@@@(>O#8VB (JB %XAWPD@@@@@@@@B@ HB@ HB@ HB@ E[@T A@@@@@@@@@(>O#8VB (JB %,AWPEI@P@@@@@@@@JO@PDA!!V 3APPHEQ,=]PD@@@@@@@@B
#8>O!!4<KE3]EQ$D0FAIV@@@@@@@@@(<A#4<\VH>O#8>O#8>OBEX@@@@@@@JO#6P]TX>O#8>O#8>O#1<E@@@@@@@B#0D5K8>O@PDA@X<A@X<BDBH@@@@@@(=(
IH>O#8>O#8>O#8>O@#@C@@@@@@DAYA6O@X<A#0DA@X<A#0IBA0@@@@@@@FP]#8>O#8>O#8>O#8<BVP4@@@@@@@A$GX<A@PDA#0DA#0FO@%PM@@@@@@@@YA88
#8>O#8>O#8>O^@IRA@@@@@@@@GT4I HB@ HB@ HB@ HBM (@@@@@@@@@S0<0UDMGVV)8_X>OZP1V@@@@@@@@^&PTC3!!UUU%%YV)=]"L,@@@@@@@@#''%LD0XO
I4AUYU%RO"L-@@@@@@@@#X.JR1D@QATIC!!X%H29D@@@@@@@@#X2JX2(!!@@@@@@@@@@@@@@@@@@@@@H2JX2, @@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[0 0 0 78 78 91 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 156 156 182 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 201 201 218 204 204 219 206 206 221 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 210 210 224 211 211 225 213 213 228 215 215 229 216 216 230 218 218 231 219 219 232 220 220 233 222 222 235 223 128 63 223 223 224 223 255 255 224 224 224 224 224 236 224 224 239 224 239 240 224 255 255 225 225 237 228 228 238 229 229 239 230 230 240 232 232 241 234 234 243 235 235 244 236 236 244 238 238 245 239 239 224 239 239 239 239 239 240 239 239 246 239 255 255 240 207 144 240 239 223 240 240 239 240 240 247 240 255 255 241 241 248 242 242 249 243 243 249 244 244 250 245 245 252 246 246 253 248 248 254 249 249 254 250 250 255 252 252 255 253 253 255 254 254 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255]
            mask:((ImageMask width:22 height:24) bits:(ByteArray fromPackedString:'@@@@@_? @_? A?? A?? G?? G?? G?? G?? G??0G??0G??8G??8G??8A??8A??8A??8A??8@??8A??0C?? G7?@O0@@O @@'); yourself); yourself]
!

cut19x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut19x22Icon inspect
     ImageEditor openOnClass:self andSelector:#cut19x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class cut19x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@%JQ@@@@@@@@!!P@@@@@@@@@@@J!!-F@@@@@@@@HT@@@@@@@@@@@AR!!TP@@@@@Q0^E@@@@@@@@@@@@TXUV@@@@ T4BI@@@@@@@@@@@@A.U P@@
]''2E@"P@@@@@@@@@@@@+HD8@DU:EXRPG@@@@@@@@@@@@GH%]YW4]KZ=''!!P@@@@@@@@@@@J6[[;L- *YB@HT@@@@@@@@@@@A5 RP>FI^W@@BE@@@@@S>D]@@@
C2!!RJ(52@@@@!!PA4P1TYBH>$M0-Q[GN_@@@@@HU4NINPOJ-$#1PJ_:^_@@@@@@BE#$&2,@AW]0!!1@3%+DAAP@@@@!!UQ&E @@VX19R)IOA#TF^8P@@HVXX:(@
@KA[ @V.H"I@IS,^^0BECJELCZ2GD$N%LX!!S")YH"6@@!!WQ8(S5*,RD3@E).''@@@ZP$_@HT@]E0DPR<@@@BZ_$X@@DX,V@BE@@@@@@@@@@@@I2%(@@@6*Q(@
!!P@@@@@@@@@@@I&]'')QE(7@:@HT@@@@@@@@@@@A4D:J (C@W@@BE@@@@@@@@@@@@@GRCH4,4@@@@!!P@a');
                colorMapFromArray:#[ 0 0 0 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 207 207 219 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 129 71 26 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 126 69 26 154 92 27 242 140 1 227 168 29 143 83 26 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 134 77 26 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 159 96 27 187 117 28 241 241 246 149 87 27 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 254 254 255 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 139 77 23 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 255 255 255 136 77 26 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191 ];
                mask:((ImageMask new)
                            width:19;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@G@@@G@@@GC@@GG @GO @G_ @G?@@G>@@G<@G''8@_?0@?? @=?8@9?<@9?>@??>@?7N@_GN@@GN@@G>@@G<@@C8@');
                            yourself);
                yourself
        ]
!

deleteFile17x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self deleteFile17x22Icon inspect
     ImageEditor openOnClass:self andSelector:#deleteFile17x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class deleteFile17x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:17;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
M@0LC@0LCBP&E4!!HV%)ZV%(LV%)ZV%)BM1!!)CC!!HV%)ZV 1ZV%)ZV$I_Y#<LW"EHV%)ZCE)ZV%)ZV&1LY 0F[B-HV%(LV%)ZV%)Z[E=&CE=ZS"EHV 1ZV%)Z
V%),H3\HB@ HB@ HCE)ZV%)ZV$H3SC@0Z$Y$IS8LV%)ZV%)ZP&1LFF(8M@A#O 1ZV%(VR%)DL3\!!UR][BTL>CE)ZB QEXE<7FFDNF$-''FS8LV%(RDU0/VF)-
C!!4,T# +O 1ZV!!<;J@<<G 8]K@,6M# >CE)BP#(MOPDNGR0[HT$SM#8LV$9NS MOC!!4,EF)+HT%IO 1ZSD1LVP8]K@T"JSH!!W!!L>CE)LSB4NGR0PPCTGYU4!!
RS8LV$0-C!!4,TT5(NS$1U2EIO 1ZSEL]KAU&FFIANS$.HT$>CE)LHEQPM6XXFB)AQ2D!!RS8LV#\7M0I&FA!!VZV)+HU8SO 1Z[F1,H2MNM6XXA#A*Z2D>GC8>
O#8>O#8>O#8>O#8>O#8b');
                colorMapFromArray:#[ 204 208 220 255 103 69 245 246 250 247 223 219 255 187 164 255 40 16 240 242 248 252 45 46 140 145 163 212 215 227 255 232 223 239 162 158 207 211 222 254 140 110 255 87 55 255 133 101 254 53 31 255 173 147 255 191 170 227 230 238 245 154 147 249 171 164 255 236 229 193 197 211 241 243 248 214 218 228 248 99 77 241 163 159 210 214 224 255 71 41 245 177 166 255 240 235 248 237 238 231 233 241 252 64 51 249 250 252 201 206 218 200 204 217 196 200 213 221 214 221 255 147 116 236 223 229 240 194 200 220 223 233 255 55 27 250 191 180 239 161 166 255 167 142 238 240 247 251 45 46 234 236 243 250 251 252 205 209 221 255 10 0 225 228 237 245 247 250 223 226 235 255 0 0 253 234 228 255 168 141 252 142 115 255 119 85 116 120 133 240 241 248 255 24 6 254 15 15 253 254 254 211 214 226 252 252 253 255 188 167 207 210 222 243 148 152 178 183 200 229 231 240 255 251 249 219 210 217 247 248 251 244 202 202 246 248 250 254 112 80 249 172 164 248 170 163 234 170 169 253 117 92 253 91 69 233 185 181 241 242 248 233 219 227 242 235 239 249 191 180 255 255 255 213 217 227 255 162 133 232 234 242 230 232 240 248 249 251 253 248 246 239 181 173 244 197 201 202 207 219 201 205 218 236 222 229 243 245 249 217 220 230 254 25 16 237 239 246 235 237 244 234 237 243 251 252 253 242 184 175 ];
                mask:((ImageMask new)
                            width:17;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'??@@?? @??0@??8@??<@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@');
                            yourself);
                yourself
        ]
!

desktopIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self desktopIcon1 inspect
     ImageEditor openOnClass:self andSelector:#desktopIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary desktopIcon1'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7''5=[F1,[M;^7-;^7-;^7-;^7-9=_V1,[F2_
^C:I)];^7-;^7-9,[F1,QG4>#&-HM3Y*L51LUEW^7-9,[@LO)8!! RW0%'' TEA]AM]30+IQW^7&29_\ 1F*=*Z*>/IU5]WU4''R*Z-LKO^7!![)"IVU%MRM$Q!!1
S> LMG?X_>EPC&_^7!!Y2P9V+3D?#V8WU-,^A$2X&I!!M>ZV_^7!!Y2P9T5^;YNL#4= !!Q##<I?NI08IV_^7!!Y2P0TM4Q=ZFU;V5$/&@)$ _;*CYFG^7!!Y2P0V@
8MYKR>Y@(4FF^7X&I!!KM0[K^7!!Y2P=AXN:MAPXXXFM+ZJ*)?)JG[W;K^7!!Y2P2&R]A].[ XF"1E(G]^L_>*L_E[^7!!Y2P0]E@H,QDV#%JM=90K,&I-$/BK?^
7!!Y2P4X$B2".77''$9FKOH%M?-FU:]0+^7!!Y2P19WNZ !!H\,\GK5-[\Q31[ -F(S^7!!Y2P9^52Q2V/V4[F<TP",N8B]2]T[;^7!!Y2!!0ER1A/E1QCD00&[&<8.
O;0?P +^7!!Y2!!<Y0Y Q/[6>"(#<?*Z&)#.KS+M;^7)C)4%''JO3<?O3<:&GUCO''!!,[DIB7-;^7)B7KKB0H4^X9=J &&1,P$K^7-;^7-;^7-;^_PN17V1=_TK^
7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^7-;^') ; colorMapFromArray:#[4 134 220 232 226 220 16 166 240 124 124 120 4 106 210 255 255 250 16 150 230 248 244 240 228 226 230 0 100 200 88 88 90 4 130 220 28 196 255 180 208 240 240 242 240 140 142 140 4 114 210 16 146 230 80 182 240 88 200 250 28 182 250 100 100 100 44 44 40 16 154 230 20 160 240 24 176 240 224 224 220 4 118 210 8 124 220 8 140 230 240 234 230 28 178 250 68 182 240 8 128 220 0 126 220 236 228 220 168 196 220 240 238 240 192 236 250 68 158 220 12 142 230 252 246 240 8 152 230 168 200 230 184 182 180 60 144 220 44 128 220 60 156 230 244 244 240 212 212 210 28 190 250 255 254 250 24 196 255 184 210 240 248 246 250 228 230 230 72 192 250 0 122 220 228 222 210 8 148 230 160 190 220 28 186 250 176 176 180 124 176 230 24 166 240 20 164 240 204 202 200 188 188 190 132 132 130 172 198 220 244 240 230 228 222 220 220 220 220 204 206 210 40 154 230 24 170 240 248 242 240 244 240 240 32 192 250 12 174 250 72 200 250 232 228 220 160 186 210 188 220 250 236 238 240 104 102 100 92 90 90 164 192 220 176 204 230 216 214 210 24 178 250 20 188 250 255 250 240 104 170 220 24 174 240 232 232 230 192 194 190 92 94 90 12 134 220 28 180 250 236 234 230 40 142 220 0 94 200 96 96 100 16 144 230 240 240 240 252 252 250 208 208 210 152 152 150 8 120 210 16 152 230 24 118 210 152 180 210 12 166 240 112 110 110 0 114 210 8 138 230 200 198 200 192 230 250 224 226 230 144 146 150 12 138 220 60 154 230 8 158 240 228 228 230 164 164 160 68 196 250 140 224 255 180 206 230 28 188 250 28 184 250 64 182 240 88 86 90 28 194 255 20 162 240 188 190 190 184 184 180 180 182 180 4 112 210 16 148 230 60 162 230 100 174 230 188 186 190 16 176 250 44 42 40 68 164 230 172 200 230 20 182 250 236 240 250 255 255 255 8 122 220 236 230 220 216 212 210 124 206 250 160 160 160 0 98 200 48 182 240 120 180 230 248 248 250 132 130 130 176 178 180 44 160 230 60 138 220 20 166 240 64 172 240 148 148 150 0 156 240 156 158 160 8 130 220 228 224 220 188 226 250 228 238 250 136 136 140 68 192 250 12 140 230 244 242 240 208 206 210 120 122 120 92 92 90 100 98 100 64 156 230 160 188 220 32 194 250 80 80 80 0 104 210 72 72 70 84 186 240 188 222 250 168 204 240 8 122 210 84 86 90 88 90 90 0 132 220 232 234 230 188 234 250 0 108 210 0 112 210 4 116 210 228 220 210 32 190 250 196 198 200 0 116 210 180 194 210 8 126 220 52 148 220 64 176 240 12 112 210 12 132 220 255 252 250 12 156 230 192 192 190 152 154 150 136 186 230 32 196 255 24 172 240 116 192 240 76 204 250 76 164 230 20 158 230 68 174 240 0 92 200 96 94 90 0 0 0 12 140 220 12 152 230 88 204 250 168 168 170 16 182 250 12 136 220 16 142 230 24 168 240 208 206 200 24 192 250 112 112 110 76 168 230]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@@C<@A?<A??>O??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??<_??8_?>@G>@@@@@@') ; yourself); yourself]
!

directory22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directory22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#directory22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class directory22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8B0,0L@\@@@@@@@@@@@@@@@@@@@@GA!!L$H" 0LC@0LC@0LC@0LH1="0@@A2 (
JB (X6M.[&9.[&9.[&:K#'',@@E((X3M.[#L3N3-[V26U%IBYM&5 @@@!!L5,3N3-KKQP5EBBS$YZRA ROJ @@HQQKKQP BP$G]''Y6D9^WG9]/B9 @@BE3XVDO
BP9#X6M#IBP(JC<_YR*X@@AFZ4)QK&8<N3, HB@3L68JO1\*@@@@QUD%W4\ \2@ RD +EAHR]Q(,@@@@@GDUL''P U3EHLT!!UUQPRD''TZK@@@@@@MNQ$[W"M*
\@T^APUS^T5$M@@@@@@@CWYP^U%YVQ0\Y34XOTP7U @@@@@@@@L>WT1LI$0&X$9&VAXQ[@@@@@@@@@A\P$QRPF!!2BG]AJT$@@@@@@@@@@@@@RTM)GS(BD@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 255 248 200 255 248 24 15 56 160 255 248 88 239 232 240 240 240 240 255 248 152 48 80 176 255 248 96 48 88 176 240 240 248 207 216 240 223 216 224 255 248 48 224 224 232 255 248 176 255 248 248 240 144 24 255 248 136 63 96 184 240 208 24 239 239 224 176 159 111 240 207 96 207 160 127 240 207 111 191 191 160 223 208 175 240 208 111 255 255 239 192 176 175 208 207 176 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@O0@@_??@_??@_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

directoryOpen22x24Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directoryOpen22x24Icon1 inspect
     ImageEditor openOnClass:self andSelector:#directoryOpen22x24Icon1
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class directoryOpen22x24Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
T5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5L@@@@@@@@@@@@@@@@@@@AST5MST5MS@@@@@@@@@@@@@@@@@@@@T5MST5MST0@@
@@@@@@@@@@@@@@@@@EMST5MST5L@@@@@@@@@@@@@@@@@@@AST5MST5MS@@@@@@@@@@@@@@@@@@@@T5MST5MST0@@@IJRA0\G@@@@@@AST5MST5MST5L@@D$_
SZY3Q3UPYSNO#8>OT5MST5MS@@A7E8JB !!]1\U)5FU.4#5MST5MST0@@]8JB (JBEHJB (JB (=ST5MST5L@@G]TUEQTUEQTUCXIBP$IBP$IBUMS@@A6 8NC
 8NC 0%\C"QOK$8<OBUST0@@LXRDT"@F#8=!!^WM3\5"%_WHBT5L@@A,?+*6(S:\EQDIBP$I."$ 8@EMS@@@0U6M$JHJB (JB (JB&0F_\EMST0@@]F6V)B\''
I2\''I2\''I5YY$P5ST5L@@E4O,8 QDQDQDQDQDQD)D9)ST5MS@@AF^$-UUUUUUUUUUUUU,"B)T5MST0@@F"HH,[F1,[F1,V-QHY@;T5MST5MST:N3KXVE!!XE>
B:)ECB*S@EMST5MST5MEXV*+_FYEN7@^@EMST5MST5MST5MSQTT9DJ@@T5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MS');
                colorMapFromArray:#[ 254 201 107 255 238 154 231 208 160 194 135 4 196 136 7 255 255 199 209 157 23 209 166 33 255 242 193 217 175 45 217 158 32 217 165 32 201 152 48 248 240 224 255 255 238 231 172 54 209 168 80 255 242 119 255 221 103 251 230 118 255 254 147 255 212 110 255 201 106 255 252 167 238 221 165 255 251 187 191 130 2 197 139 10 255 233 177 203 146 20 239 224 192 247 238 206 222 173 41 222 177 44 213 165 49 239 239 231 255 255 237 213 174 74 235 177 62 255 252 128 255 255 136 255 202 86 218 184 112 255 224 122 230 206 136 255 225 139 255 217 142 191 131 2 196 138 8 198 140 12 202 144 16 213 167 32 202 143 11 217 176 45 226 197 61 222 159 31 213 174 59 192 136 16 241 240 236 205 160 64 255 255 248 248 183 66 222 189 103 255 198 83 122 152 175 255 252 150 255 255 159 234 213 147 255 255 176 189 129 1 192 131 3 242 230 186 255 255 202 204 147 20 204 151 25 247 237 204 251 244 211 255 255 222 255 242 213 255 255 230 238 209 79 238 199 71 242 198 74 255 255 255 255 251 127 255 229 108 255 204 88 255 191 80 255 206 103 255 238 140 238 217 147 255 252 173 238 222 173 193 135 4 198 140 11 201 144 16 204 146 19 242 230 193 247 237 203 217 154 26 251 247 217 230 196 63 197 138 6 241 242 237 217 175 68 247 238 109 242 191 74 251 216 94 242 187 79 247 188 80 255 206 95 255 238 135 222 192 127 234 209 143 238 222 156 255 255 189 194 136 6 251 242 188 201 143 14 203 146 19 202 147 21 255 255 213 213 154 28 222 166 36 213 156 24 255 255 229 234 187 59 238 197 70 252 248 240 247 202 80 255 255 129 255 230 109 255 213 96 255 212 94 238 211 121 230 203 129 255 246 158 255 255 172 255 238 167 192 132 4 197 138 9 201 142 13 203 145 18 202 151 29 202 146 13 213 173 46 213 159 38 235 216 176 217 169 52 238 222 89 217 173 66 240 244 246 247 209 86 0 0 0 213 176 96 255 206 89 255 189 76 248 194 95 136 162 181 247 238 154 227 200 144 255 252 181 191 130 1 191 129 1 255 254 196 255 238 187 255 255 206 255 255 212 247 238 207 243 232 208 202 144 11 226 169 41 240 240 233 213 173 70 238 181 57 251 247 119 255 238 116 255 222 103 255 199 84 226 197 119 255 254 154 ];
                mask:((ImageMask new)
                            width:22;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@G0@@O?<@O?<@O?<@O??0O??0O??0O?? O?? O?? O??@O??@O?>@O?<@O?@@O @@@@@@');
                            yourself);
                yourself
        ]
!

directoryOpen22x24Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directoryOpen22x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#directoryOpen22x24Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class directoryOpen22x24Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
T5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5L@@@@@@@@@@@@@@@@@@@AST5MST5MS@@@@@@@@@@@@@@@@@@@@T5MST5MST0@@
@@@@@@@@@@@@@@@@@EMST5MST5L@@@@@@@@@@@@@@@@@@@AST5MST5MS@@@@@@@@@@@@@@@@@@@@T5MST5MST0@@@IJRA0\G@@@@@@AST5MST5MST5L@@D$_
SZY3Q3UPYSNO#8>OT5MST5MS@@A7E8JB !!]1\U)5FU.4#5MST5MST0@@]8JB (JBEHJB (JB (=ST5MST5L@@G]TUEQTUEQTUCXIBP$IBP$IBUMS@@A6 8NC
 8NC 0%\C"QOS48<OBUST0@@LXRDT"@F#8=!!^WM3\7N%_WHBT5L@@A,?+*6(S:\EQDIBP$IB"$ 8@EMS@@@0U6M$JHJB (JB (JBP F_\EMST0@@]F6V)B\''
I2\''I2\''I2]Y$P5ST5L@@E4O,8 QDQDQDQDQDQDQD9)ST5MS@@AF^$-UUUUUUUUUUUUU,"B)T5MST0@@F"HH,[F1,[F1,V-QHY@;T5MST5MST:N3KXVE!!XE>
B:)ECB*S@EMST5MST5MEXV*+_FYEN7@^@EMST5MST5MST5MSQTT9DJ@@T5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MS');
                colorMapFromArray:#[ 254 201 107 255 238 154 231 208 160 194 135 4 196 136 7 255 255 199 209 157 23 209 166 33 255 242 193 217 175 45 217 158 32 217 165 32 201 152 48 248 240 224 255 255 238 231 172 54 209 168 80 255 242 119 255 221 103 251 230 118 255 254 147 255 212 110 255 201 106 255 252 167 238 221 165 255 251 187 191 130 2 197 139 10 255 233 177 203 146 20 239 224 192 247 238 206 222 173 41 222 177 44 213 165 49 239 239 231 255 255 237 213 174 74 235 177 62 255 252 128 255 255 136 255 202 86 218 184 112 255 224 122 230 206 136 255 225 139 255 217 142 191 131 2 196 138 8 198 140 12 202 144 16 213 167 32 202 143 11 217 176 45 226 197 61 222 159 31 213 174 59 192 136 16 241 240 236 205 160 64 255 255 248 248 183 66 222 189 103 255 198 83 122 152 175 255 252 150 255 255 159 234 213 147 255 255 176 189 129 1 192 131 3 242 230 186 255 255 202 204 147 20 204 151 25 247 237 204 251 244 211 255 255 222 255 242 213 255 255 230 238 209 79 238 199 71 242 198 74 255 255 255 255 251 127 255 229 108 255 204 88 255 191 80 255 206 103 255 238 140 238 217 147 255 252 173 238 222 173 193 135 4 198 140 11 201 144 16 204 146 19 242 230 193 247 237 203 217 154 26 251 247 217 230 196 63 197 138 6 241 242 237 217 175 68 247 238 109 242 191 74 251 216 94 242 187 79 247 188 80 255 206 95 255 238 135 222 192 127 234 209 143 238 222 156 255 255 189 194 136 6 251 242 188 201 143 14 203 146 19 202 147 21 255 255 213 213 154 28 222 166 36 213 156 24 255 255 229 234 187 59 238 197 70 252 248 240 247 202 80 255 255 129 255 230 109 255 213 96 255 212 94 238 211 121 230 203 129 255 246 158 255 255 172 255 238 167 192 132 4 197 138 9 201 142 13 203 145 18 202 151 29 202 146 13 213 173 46 213 159 38 235 216 176 217 169 52 238 222 89 217 173 66 240 244 246 247 209 86 0 0 0 213 176 96 255 206 89 255 189 76 248 194 95 136 162 181 247 238 154 227 200 144 255 252 181 191 130 1 191 129 1 255 254 196 255 238 187 255 255 206 255 255 212 247 238 207 243 232 208 202 144 11 226 169 41 240 240 233 213 173 70 238 181 57 251 247 119 255 238 116 255 222 103 255 199 84 226 197 119 255 254 154 ];
                mask:((ImageMask new)
                            width:22;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@G0@@O?<@O?<@O?<@O??0O??0O??0O?? O?? O?? O??@O??@O?>@O?<@O?@@O @@@@@@');
                            yourself);
                yourself
        ]
!

directoryUp22x24Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self directoryUp22x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#directoryUp22x24Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class directoryUp22x24Icon2'
        ifAbsentPut:[(Depth8Image width:22 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@ L@@@@@@@@@@@@@@@@@@@@@@@@@APXGBA@@@@@@@@@@@@@@@@@@@@@@B ,LCP8OD@@@@@@@@@@@
@@@@@@@@@P\LCQDRD!!LT@@@@@@@@@@@@@@@@@@TLCQDRE1 XFQ([@@@@@@@@@@@@@@(\CQ4^E1 XG2@!!H"L@@@@@@BT%IRT"I  HI1 XJB$@@@@@@@@@@B(+
KB4.K3@@@CDYJCH)@@@@@@@@@@@3MCT5MSX7L3L8NSH:JP@@@@@@@@@@IS,5MST5OCT5MS$:OR$3L3L@@@@@@CL?O3<?O3<?PDEBOTL)QDQEQ @@@@@*Q4!!H
RD!!HRTEJR4MLJTUEQDX@@@@@ST9OTDEAPTEJOD-LSED-KTY(@@@@@EISUEUJMB9VOC1KSE]XME%F@@@@@@AZV51]MST5MST8R41^W5YFZ@@@@@@@XVI#MC<?
O3<?W&Q%Y&\<Z@@@@@@@@F%*Z61@PDA@NF5%[$A/Q& @@@@@@@A)\U5HRD!!HRGI3]D!!H]TX@@@@@@@@@ZRU6[6=/[6=7^G%MQ%H@@@@@@@@@@F%U^715_W9R
ZW>@Z@@@@@@@@@@@@@A)K4FBZXNDZ@@@@@@@@@@@@@@@@@@@ZV%UZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[240 240 232 160 192 160 16 104 16 144 184 144 224 232 224 16 112 16 16 152 8 15 120 0 63 136 56 208 224 208 79 144 72 16 144 8 31 160 8 47 176 24 47 160 16 31 120 16 143 176 128 48 176 24 79 184 32 47 144 16 47 128 40 192 216 192 224 232 216 80 192 40 96 200 48 79 176 40 16 120 8 127 168 112 16 136 8 47 168 24 64 176 32 79 176 32 32 136 16 31 128 16 0 96 0 95 152 88 240 232 216 223 176 56 16 120 16 31 136 16 111 200 48 47 144 24 223 168 40 239 216 152 255 248 216 255 248 224 255 248 200 240 232 200 223 192 120 32 112 0 112 208 56 223 168 48 255 248 208 255 248 152 255 248 184 239 216 160 159 184 88 64 160 32 112 216 64 255 248 160 255 248 168 127 224 72 224 208 160 255 248 144 255 240 136 223 176 48 63 160 32 128 224 72 240 224 184 255 248 248 207 152 8 255 232 152 255 232 128 240 216 104 255 248 232 64 160 40 143 240 88 223 168 32 255 224 136 255 216 120 239 200 80 47 128 32 208 160 24 255 216 128 240 200 88 224 192 112 255 248 192 95 192 56 128 160 72 255 240 184 208 160 16 255 208 120 224 168 40 255 240 216 32 128 16 239 216 128 239 224 200 208 152 8 255 200 112 223 176 64 144 248 96 48 144 32 159 192 88 255 224 128 223 192 96 207 152 0 240 192 96 239 208 136 255 240 176 63 152 32 128 168 64 255 224 120 239 224 184 224 184 72 64 128 32 16 104 8 175 192 88 255 208 104 255 240 208 159 176 72 224 192 80 224 184 56 239 216 176 255 224 160 255 216 112 239 192 80 224 176 48 208 168 40 223 184 104 224 208 144 208 160 8 208 168 56 223 192 112]
            mask:((ImageMask width:22 height:24) bits:(ByteArray fromPackedString:'@@@@@C @@C8@@G<@@O>@@O? @_?0G?<@O?<@O?<@O?? O??0O??0O??0O?? O?? O??@O??@O?>@O?<@O?0@O<@@O@@@@@@@'); yourself); yourself]
!

displayScreen22x27Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self displayScreen22x27Icon inspect
     ImageEditor openOnClass:self andSelector:#displayScreen22x27Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary displayScreen22x27Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:27;
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Q4\-+''QMD"0,KI:^''&UWZ7(@@@@@@DV\C>5!!''):^B0N,-H^GPVPNLP@@@@@@@MQYVZ2,;>< <QPR#^X+4[0@@@@@
M$]GKZ94SQH,KB0,N87&;S03@@@@@CYE''@?-XT8F)*Z&) YNX^4<30@@@@@)BGTV#"/&#X4FA(5NXR.NE)@@@@@@JUM7]P>NJ6G&9.[&XR.NE''V!!@@@@@B$*
GG]5C8;-J6E!!J>6NE''U7P @@@@@)I81Z,Q@PFA XFA@P,U*LW''L@@@@@@K.:L(2L,[F1,[F1#H02:1?X@@@@@@A+!!./+L#H2#H02L#K+:8@G-0@@@@@@[J\G
 HC+:>/+:>.@ @]^1[\@@@@@@E%*5-XGA6]''Y6\GG<,(6BD@@@@@@@AY6XG_8][V5 _(7]WXK.L@@@@@@@@@V[W[ XFAG9U?K'':)"0@@@@@@@@@@@@B<E8F0
S@WX_,''IMG;0@@@@@@@@@@@@86AW2HL.K)Q>_+^76 ,@@@@@@@C.;.N!!TP/"Z5G#(YRT%F,3@@@@@@C.M&&^JV$6D\A+[IBP$JE,Z0@@@@@@5CY)"X%)M!!DI
L6M:^''(1Z6/^@@@@@AD6ZV%)M!!DQ8$C.;H^G!!6-+7 @@@@C"DSX6M#XQ8 &RX2+/;>?^Z3L@@@@@;!!DQDQDQ8.HI3 N>Q0P>Z6,K@@@@@@C.8.K"8 $IB0/,
!!8_^[F,K@@@@@@@@@@C.VP$IB0.J",CZ^P,@@@@@@@@@@@@@@@@@B0,KB0,K@@@@@@@@@@@@');
                colorMapFromArray:#[ 128 128 160 31 80 159 96 160 224 176 176 207 127 127 159 175 175 223 191 240 255 63 176 255 143 160 191 208 208 223 15 48 127 207 207 223 63 63 112 112 112 176 128 159 192 143 224 255 111 207 255 224 224 224 176 223 239 47 63 127 175 207 223 31 95 160 143 223 255 16 160 255 111 208 255 160 160 176 112 112 175 31 64 128 112 208 255 79 79 128 112 175 223 79 176 255 144 160 191 143 143 208 31 95 159 127 143 160 15 32 96 79 80 128 160 160 175 128 160 207 143 159 208 239 239 240 176 176 192 159 239 255 207 255 255 144 144 160 143 143 207 0 79 159 111 111 144 127 127 176 80 192 255 144 144 192 96 96 192 112 143 208 239 239 239 95 127 160 15 80 159 191 191 192 32 95 159 191 255 255 143 192 239 80 95 143 127 127 175 48 64 127 144 144 191 143 144 191 112 143 207 111 128 176 64 111 160 143 175 191 63 96 159 144 144 159 31 32 96 0 63 128 111 159 224 159 175 160 176 207 239 160 192 223 175 240 255 143 143 176 80 112 176 160 160 208 0 0 0 160 175 192 16 31 95 47 96 159 96 96 144 192 192 224 224 224 240 207 207 208 95 207 255 112 112 160 143 143 175 111 112 144 95 175 240 32 80 159 144 192 240 160 239 255 112 160 207 192 192 223 143 175 207 191 191 223 128 128 208 63 191 255 111 111 176 240 240 240 80 144 223 160 160 207 175 175 208 159 255 111 16 80 159 15 47 112 80 111 160 0 64 128 48 80 143 128 128 207 159 176 192 128 223 255 112 127 175 127 208 255 79 111 175 175 175 207 128 128 176 159 159 176 15 47 111 80 95 128 111 111 192 160 175 223 64 191 255 32 175 255 111 111 175 127 127 192 64 64 127 176 176 176 79 176 240 128 128 175 159 159 175 255 255 255 192 192 208 111 111 191 95 192 255 176 240 255 144 224 255 208 208 239 127 127 191 111 128 159 160 160 192 47 48 111 112 112 192 144 207 240 0 79 144 176 176 223 143 159 176 79 112 159 32 47 96 159 160 160 128 207 224 31 80 144 223 223 239 79 111 160 175 175 192 112 112 191 128 143 176 0 79 143 127 223 255 112 143 176 192 255 255 79 175 239 31 47 96 95 95 191 0 64 143 95 112 176 160 160 191 144 159 192 144 160 176 31 48 112 112 192 255 96 207 255 112 143 175 48 96 159 144 144 176 112 144 208 112 191 239 111 111 207 95 96 144 79 111 159 79 192 255 159 160 192 143 143 192 15 63 127 192 192 192 15 48 112 191 191 208 144 144 175 16 32 95 112 128 176 96 127 175 112 159 223 64 80 143 48 95 159 159 159 208 96 96 207 143 143 191 127 176 239 64 79 128 127 143 191 191 191 207 128 128 191 144 159 176 143 176 223 15 80 144 143 159 191 223 223 224 144 144 208 48 176 255 16 31 80 127 127 207 96 144 208 176 176 208 31 160 255 160 175 207 144 176 224 159 159 192 47 175 255 111 111 159 47 176 255 223 223 223 144 144 207 159 159 207 128 144 191 175 239 255 111 112 160 111 191 240 127 127 160 175 175 224 79 191 255 159 159 191 159 224 255 208 208 224 143 143 160 207 207 224 160 176 207 ];
                mask:((ImageMask new)
                            width:22;
                            height:27;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@? @_?0C??0O??0O??0O??0O??0O??0O??0G??0G??0G??0G?? G??@G?<@C?>@C??@O??@_??@_?? _?? _?? _?? O??@C?<@@_ @');
                            yourself);
                yourself
        ]
!

displayScreen22x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self displayScreen22x32Icon inspect
     ImageEditor openOnClass:self andSelector:#displayScreen22x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class displayScreen22x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@T @@@@@@@@@@@@@@@@@@@@@@@@@@T%H@@@@@@@@@@@@@@@AWU6UWZ7(@@@@@@@@@@@@@''):^B0N,-H^GPVPNLP@@@@C"
J]QYVQ''/;>< <QPR#^X+4[0@@@@@M$]GKZ94SQH,KB0,N87&;S03@@@@@CYE''@?-XT8F)*Z&) YNX^4<30@@@@@)BGTV#"/&#X4FA(5NXR.NE)@@@@@@JUM7
]P>NJ6G&9.[&XR.NE''V!!<@@@@B$*GG]5C8;-J6E!!J>6NE''U7P((@@@@@"+X\]7TVC8:N#(8OE''U7GCUQ@@@@@@,^DA17]WU5E!!Y5]ZQ7GAAJK @@@@C0X+DP
GA17]7]7]7\\FAB1@"8@@@@@JR^LV+DPDA XFA PDKEZ#E93@@@@@@B;.#JL#KF1,[F1,X2LL.,_6@@@@@@@Z8[+:3H2L(2LL#H2:>.@A;\@@@@@@F2''A8B@
:>/+:>/+ H@GW,V7@@@@@@CZZ-[VA0]''Y6]''A1?KJM !!@@@@@@@@J]&A7>GV5-XG:M7U6B;#@@@@@@@@@@B568FA Q>U_29>*X,@@@@@@@@@@@@@/A^A,D0E
6G;I2SQ><@@@@@@@@@@@@NM U<"CK":T_'':7-=(K@@@@@@@@;.;#(UDK8&-Q8:FT%IQ+L0@@@@@@;#Y)''"%)M!!G@Z62P$IB!![F,@@@@@@MP6ZX&IZSXQBSM#
^''):LV-+7 @@@@@QM&%)ZSXQD^I@;.2G!!8]+Z=8@@@@@8!!D6M#X6D^HI$&L*;>?/7&,3@@@@@N8QDQDQD^K"B\8C/$\DO&-+B0@@@@@@;.K"8.HIBP,K;H^G
7&1+B0@@@@@@@@@@;%$IBP,K"(+@6''$K@@@@@@@@@@@@@@@@@@,KB0,KB0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 128 128 160 31 80 159 96 160 224 176 176 207 127 127 159 175 175 223 191 240 255 63 176 255 143 160 191 208 208 223 15 48 127 207 207 223 63 63 112 112 112 176 128 159 192 143 224 255 111 207 255 224 224 224 176 223 239 47 63 127 175 207 223 31 95 160 143 223 255 16 160 255 111 208 255 160 160 176 112 112 175 31 64 128 112 208 255 79 79 128 112 175 223 79 176 255 144 160 191 143 143 208 31 95 159 127 143 160 15 32 96 79 80 128 160 160 175 128 160 207 143 159 208 239 239 240 176 176 192 159 239 255 207 255 255 144 144 160 143 143 207 0 79 159 111 111 144 127 127 176 80 192 255 144 144 192 96 96 192 112 143 208 239 239 239 95 127 160 15 80 159 191 191 192 32 95 159 191 255 255 143 192 239 80 95 143 127 127 175 48 64 127 144 144 191 143 144 191 112 143 207 111 128 176 64 111 160 143 175 191 63 96 159 144 144 159 31 32 96 0 63 128 111 159 224 159 175 160 176 207 239 160 192 223 175 240 255 143 143 176 80 112 176 160 160 208 0 0 0 160 175 192 16 31 95 47 96 159 96 96 144 192 192 224 224 224 240 207 207 208 95 207 255 112 112 160 143 143 175 111 112 144 95 175 240 32 80 159 144 192 240 160 239 255 112 160 207 192 192 223 143 175 207 191 191 223 128 128 208 63 191 255 111 111 176 240 240 240 80 144 223 160 160 207 175 175 208 159 255 111 16 80 159 15 47 112 80 111 160 0 64 128 48 80 143 128 128 207 159 176 192 128 223 255 112 127 175 127 208 255 79 111 175 175 175 207 128 128 176 159 159 176 15 47 111 80 95 128 111 111 192 160 175 223 64 191 255 32 175 255 111 111 175 127 127 192 64 64 127 176 176 176 79 176 240 128 128 175 159 159 175 255 255 255 192 192 208 111 111 191 95 192 255 176 240 255 144 224 255 208 208 239 127 127 191 111 128 159 160 160 192 47 48 111 112 112 192 144 207 240 0 79 144 176 176 223 143 159 176 79 112 159 32 47 96 159 160 160 128 207 224 31 80 144 223 223 239 79 111 160 175 175 192 112 112 191 128 143 176 0 79 143 127 223 255 112 143 176 192 255 255 79 175 239 31 47 96 95 95 191 0 64 143 95 112 176 160 160 191 144 159 192 144 160 176 31 48 112 112 192 255 96 207 255 112 143 175 48 96 159 144 144 176 112 144 208 112 191 239 111 111 207 95 96 144 79 111 159 79 192 255 159 160 192 143 143 192 15 63 127 192 192 192 15 48 112 191 191 208 144 144 175 16 32 95 112 128 176 96 127 175 112 159 223 64 80 143 48 95 159 159 159 208 96 96 207 143 143 191 127 176 239 64 79 128 127 143 191 191 191 207 128 128 191 144 159 176 143 176 223 15 80 144 143 159 191 223 223 224 144 144 208 48 176 255 16 31 80 127 127 207 96 144 208 176 176 208 31 160 255 160 175 207 144 176 224 159 159 192 47 175 255 111 111 159 47 176 255 223 223 223 144 144 207 159 159 207 128 144 191 175 239 255 111 112 160 111 191 240 127 127 160 175 175 224 79 191 255 159 159 191 159 224 255 208 208 224 143 143 160 207 207 224 160 176 207 ];
                mask:((ImageMask new)
                            width:22;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@?@@?? _?? _?? _?? _?? _??0_??0O??0O??0O??0O??0G??0G??0G??0G?? G??@C?<@C?>@C??@O??@_??@_?? _?? _?? _?? O??@C?<@
@_ @@@@@');
                            yourself);
                yourself
        ]
!

doIt16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self doIt16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#doIt16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class doIt16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@A@@@@@@@@@A@@@@@@@@@A@E@@@@@@@A@ED@@@@@@A@DT@@@@@@A@DS@@@@@@A@DSLQDD@@A@DSLQDD@@@@@@@QDD@@@@@@AADD@@@@@@
ADDD@@@@@@@DDD@@@@@@@@@D@@@@@@@@@D@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 248 252 128 208 220 0 255 255 255 127 127 127]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@X@C @^@C8@_@C?0_?C?8O?@C8@_@A8@G@@X@@@@b'); yourself); yourself]
!

doIt20x20Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self doIt20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#doIt20x20Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class doIt20x20Icon'
        ifAbsentPut:[(Depth2Image width:20 height:20) bitsPerSample:(#[2]); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@D@@@@@MP@@@@CU@@@@@50@@@@A_P@@@@W0@@@@E?@@@@A_?=P@@W??T@@@@O5@@@@A=P@@@@_T@@@@@5@@@@@AP@@@@@T@@@@@A@@@@
@@@@@@@@@@@@@@@a')
            mask:((ImageMask width:20 height:20) bits:(ByteArray fromPackedString:'
@@@@@@@@@@ @@A @@C @@G @@O @@_@@@?<@A?<@C?8@C?0@@O @@_@@@^@@@\@@@X@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a'); yourself); yourself]
!

edit17x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self edit17x22Icon inspect
     ImageEditor openOnClass:self andSelector:#edit17x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class edit17x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:17;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UA,[F1,[F3=DI''M/ZV4O"H ["H"H"H!!+V"6(WP6%MC!!R"A.H"H"H"F.Q''&^-HXA>\PNHF8"H"H"H"J97UX(% UXIC8 ["H"H"H"H+)FTHJDL]@!!3"A.H"H"H
"H".RA8(*% #Y!!\WF8"H"H"H"F- EE1:DJ2XPFT["H"H"H"HR%BFGE:''G0BVYQ.H"H"H"H"MI8]$#G2IFV1%F8"H"H"HZ1)!!B#A0[*B K&T["H"H"H /SVNY
B4I=A5-KYQ.H"H"HZ9NRQ0X5()AYVU,SF8!!+Z6-AD!!6Z''@EINWY9X!! ["G!!8^G<>S$1W#:$<&2(*Z!!.H]7]7\"PNAI>N@$X)!!HU*F8!!7]7\6MADUN).[''XL)
J&(["G]7]344)(,,&9.] 2$*FA.H]7]7QPU(]WV[&96C '',SF8!!7]7]OJ3]5]Y.[P9T9]&T["E)ZV%>$L#H3%5N+NY@"YQ.H+*:.N3-8V)8-E%F)*3%%LVU%
YVU%YVU%YVU%YVU%YVTb');
                colorMapFromArray:#[ 204 208 220 222 120 43 215 217 224 183 59 8 254 203 97 163 140 130 254 191 54 224 227 236 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 115 119 132 254 226 7 248 201 137 240 242 248 140 145 163 106 109 123 212 215 227 247 181 30 207 211 222 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 227 230 238 242 102 12 254 226 119 254 191 0 193 197 211 254 231 26 254 203 3 208 210 219 207 208 218 169 113 95 210 207 211 241 243 248 214 218 228 249 210 160 254 176 36 210 214 224 229 231 236 228 229 235 254 231 201 254 165 69 241 195 142 219 221 226 234 184 145 231 233 241 186 100 65 249 250 252 228 231 238 226 180 137 254 239 98 201 206 218 200 204 217 245 209 172 220 114 42 217 219 227 196 200 213 161 124 106 211 213 221 254 197 55 247 233 220 222 209 212 252 246 238 220 223 233 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 238 240 247 166 46 5 232 234 241 205 209 221 241 212 187 254 136 5 254 184 94 254 144 8 225 228 237 245 247 250 223 226 235 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 211 214 223 254 207 47 254 181 24 116 120 133 145 109 112 240 241 248 193 129 103 223 153 96 105 108 122 253 254 254 211 214 226 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 178 183 200 254 116 14 217 219 225 229 231 240 247 248 251 246 248 250 224 227 235 254 171 10 219 221 230 207 90 27 222 218 223 254 161 10 248 203 113 254 162 0 254 158 0 211 213 222 209 211 220 207 209 218 205 207 216 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 230 232 240 248 249 251 254 231 65 249 193 57 240 178 78 224 226 234 202 207 219 222 224 232 201 205 218 254 191 42 254 201 65 214 216 224 254 184 75 212 214 222 243 245 249 228 142 66 217 220 230 254 167 2 195 120 93 0 0 17 231 233 237 254 214 81 248 214 181 248 122 26 237 239 246 235 237 244 254 167 5 234 237 243 197 82 32 232 174 56 251 252 253 ];
                mask:((ImageMask new)
                            width:17;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'??8@??<@??<@??<@??<@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@');
                            yourself);
                yourself
        ]
!

editorOverlayIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self editorOverlayIcon inspect
     ImageEditor openOnClass:self andSelector:#editorOverlayIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class editorOverlayIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C4HO@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@<IBXSA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O 2>1Z8;A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CJD28?^U/A
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CJU[1:AE7A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CJ*C6;B#OA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@CJ1FB_G3/A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CJFF(+''JSA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CJP22)O,''A@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@V1SV+H\3A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@VDKZJ!!YSA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A7+EXB[%CK@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@BY-2 UY27K@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4T81>"<,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%15%"
G@X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FDS]ELP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 230 230 229 242 108 0 21 232 231 255 186 105 101 75 66 186 160 156 234 234 236 163 163 163 250 163 90 255 188 108 228 228 230 104 104 105 226 226 228 102 102 103 167 102 48 137 61 2 114 91 85 218 218 220 128 58 3 59 58 54 226 160 119 90 53 35 84 84 85 147 68 5 82 82 83 80 80 81 182 182 181 200 156 136 88 88 92 247 247 248 255 187 104 21 231 230 249 184 108 186 186 188 184 184 186 237 237 238 111 89 88 235 235 236 180 180 182 191 120 84 231 231 232 5 237 237 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 213 213 214 99 91 79 254 232 208 253 196 141 101 62 48 221 111 4 101 101 104 114 80 64 133 233 234 150 150 152 89 89 92 255 200 146 85 85 88 218 115 4 254 184 102 254 127 3 174 239 241 172 217 216 215 165 133 134 60 4 0 129 126 85 77 68 0 125 126 110 110 109 69 69 72 105 104 104 19 230 230 0 138 139 102 102 101 3 135 132 116 116 118 165 165 166 254 232 217 161 161 162 19 234 233 137 78 56 84 84 83 139 65 5 220 102 2 97 94 99 95 96 97 172 104 77 90 90 92 253 205 143 88 88 90 255 199 145 86 86 88 84 84 86 219 112 4 56 56 55 231 173 141 5 141 143 21 231 231 3 189 187 115 113 116 252 217 191 107 107 108 2 191 189 223 115 4 247 184 110 134 137 141 225 225 227 250 157 80 221 221 223 0 134 131 219 219 221 254 254 252 205 198 194 159 97 83 89 89 90 105 105 109 91 51 26 193 193 192 254 184 100 254 129 1 95 95 99 185 185 184 110 113 117 219 162 125 144 146 147 91 91 95 89 89 93 9 238 238 216 154 122 253 198 145 246 163 82 173 173 172 120 116 120 186 187 188 238 238 239 247 120 7 249 219 197 174 106 74 181 181 183 254 204 149 108 108 108 230 230 231 2 190 188 2 186 188 179 170 171 243 174 115 116 116 119 0 133 130 165 165 167 223 217 214 75 37 16 216 216 217 108 108 111 255 190 110 175 249 249 190 190 188 255 132 1 96 96 99 135 225 226 251 251 251 90 90 93 255 201 146 88 88 91 101 104 107 137 137 139 145 68 5 254 128 3 133 225 227 251 120 0 133 59 3 0 128 126 111 111 110 11 243 242 109 109 108 240 110 9 159 158 157 106 103 105 5 237 236 88 135 130 215 106 4 119 58 22 173 233 233 107 107 109 122 123 127 254 136 9 222 113 4 85 85 84 173 235 236 213 213 216 138 138 139 190 118 68 83 83 85 187 187 187 136 62 5 133 58 2 164 165 161 127 70 39 138 243 244 254 202 147 78 38 4 201 153 138 254 200 147 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@@@@@8@@@@_@@@@O8@@@A?@@@@O8@@@A?@@@@O8@@@A?@@@@O8@@@A?@@@@O8@@@A?@@@@O8@@@A>@@@@O
0@@@A<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

editorOverlayIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self editorOverlayIcon2 inspect
     ImageEditor openOnClass:self andSelector:#editorOverlayIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class editorOverlayIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:17;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@A/ZV4O"H @@@@@@@@@@@@@WP6%MC!!R"@@@@@@@@@@@@@B-HXA>\PNH@@@@@@@@@@@@UX(% UXINH @@@@@@@@@@@BTHJDL]@ @"@@@@@@@
@@@@@A8(*% #Y @@@@@@@@@@@@A EE1:DJ0@@@@@@@@@@@@@@EBFGE:''G0@@@@@@@@@@@@BMI8]$#G2I@@@@@@@@@@@@@A)!!B#A0[ @@@@@@@@@@@@@/SVNY
B4H@@@@@@@@@@@@@@INRQ0X5( @@@@@@@@@@@@AAD!!6Z''@EI@@@@@@@@@@@@@G<>S$1W#0@@@@@@@@@@@@@@\"PNAI>N@@@@@@@@@@@@@@@6MADUN @@@@@@
@@@@@@@@@C44)(,@@@@@@@@@@@@@@@@@QPU(@@@@@@@@@@@@@@@@@@AOJ0@@@@@@@@@@@@@@@@@@@E<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 204 208 220 222 120 43 215 217 224 183 59 8 254 203 97 163 140 130 254 191 54 224 227 236 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 115 119 132 254 226 7 248 201 137 240 242 248 140 145 163 106 109 123 212 215 227 247 181 30 207 211 222 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 227 230 238 242 102 12 254 226 119 254 191 0 193 197 211 254 231 26 254 203 3 208 210 219 207 208 218 169 113 95 210 207 211 241 243 248 214 218 228 249 210 160 254 176 36 210 214 224 229 231 236 228 229 235 254 231 201 254 165 69 241 195 142 219 221 226 234 184 145 231 233 241 186 100 65 249 250 252 228 231 238 226 180 137 254 239 98 201 206 218 200 204 217 245 209 172 220 114 42 217 219 227 196 200 213 161 124 106 211 213 221 254 197 55 247 233 220 222 209 212 252 246 238 220 223 233 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 238 240 247 166 46 5 232 234 241 205 209 221 241 212 187 254 136 5 254 184 94 254 144 8 225 228 237 245 247 250 223 226 235 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 211 214 223 254 207 47 254 181 24 116 120 133 145 109 112 240 241 248 193 129 103 223 153 96 105 108 122 253 254 254 211 214 226 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 178 183 200 254 116 14 217 219 225 229 231 240 247 248 251 246 248 250 224 227 235 254 171 10 219 221 230 207 90 27 222 218 223 254 161 10 248 203 113 254 162 0 254 158 0 211 213 222 209 211 220 207 209 218 205 207 216 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 230 232 240 248 249 251 254 231 65 249 193 57 240 178 78 224 226 234 202 207 219 222 224 232 201 205 218 254 191 42 254 201 65 214 216 224 254 184 75 212 214 222 243 245 249 228 142 66 217 220 230 254 167 2 195 120 93 0 0 17 231 233 237 254 214 81 248 214 181 248 122 26 237 239 246 235 237 244 254 167 5 234 237 243 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:17;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@A8@@C<@@C<@@G<@@G8@@G8@@O0@@O0@@_0@@_ @@?@@@?@@A?@@A>@@A>@@A<@@A8@@A0@@A @@A@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

editorPenOverlay
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self editorPenOverlay inspect
     ImageEditor openOnClass:self andSelector:#editorPenOverlay
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class editorPenOverlay'
        ifAbsentPut:[
            (Depth8Image new)
                width:11;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@1,OD# @@@@@@@K*L9JN&-@@@@@@@:Y+O3\"C@@@@@KWU'']B6"JX@@@@@7Y''""<*G@@@@@@BW''>^8&<D@@@@@/YJ928?(@@@@@@B34YV;9) @@@@@
6I;R0M_L@@@@@@BT/(&"1<T@@@@@([B?7(*+@@@@@@C\6:6F)NL@@@@@*)FV7>BB@@@@@@CN*[F/-=(@@@@@@L&\#XS!!@@@@@@@@)ZNP$:\@@@@@@@B((>WV
@@@@@@@@@J2E0 @@@@@@@@@@,*@@@@@@@@@@@@B<@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 160 160 160 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 72 122 199 116 116 120 237 236 242 72 141 255 212 211 224 32 101 209 63 143 226 153 188 255 106 175 235 170 204 255 7 66 194 0 50 164 58 137 224 75 160 234 66 135 255 140 175 255 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 80 149 255 55 95 181 125 160 253 52 89 178 50 87 176 105 172 233 104 170 232 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 2 56 178 3 73 255 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 81 136 209 101 170 255 36 107 211 54 123 255 56 94 181 126 161 253 55 92 180 53 90 178 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 96 157 223 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 28 97 255 109 178 255 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 39 109 255 93 161 255 157 192 255 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 181 215 255 255 255 255 52 90 178 51 88 177 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 87 145 215 84 153 255 78 131 206 10 79 255 91 168 235 127 162 254 54 91 179 14 77 199 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:11;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@<@G8@_ C>@O0@?@G8@_ C<@O0A>@G8@?@C<@O @>@C0@N@@0@B@@@@a');
                            yourself);
                yourself
        ]
!

fileContents19x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileContents19x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileContents19x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileContents19x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
IQTFA XFA XND@ _G2T%IRT%IRTFIRT%IRT[E0$/A!! _IRT%IRT%A"T%IRT%F1,[F0X(CA<%IRT%IPX%ISL3L2T3L3LF@3HQG2T%IRTFIRT%IRT%IRT%A"$%
H 0_IRT%A"T%L3L3ISL3L0PDA@PDA@P%IPX%IRT%IRT%IRTRKR4&J0<YIRTFIRT3L2T%L3H3BSL3L0@*FRT%A"T%IRT%IQ4TE00XKRXEGA$%IPX%ISL%L1,%
L3L FCL3K (YIRTFIRT%IRT[IS@1CA G@!! QFRT%A"T%ISL3E3L3L@03L1XVFA$%IPX%F1,[@20C@2<0F@0 A1XYIRTFIRH3BSLAL0$$K3L3L2@ FRT%A"T!!
HRDWE2LIIB<0D00(A1$%IPX%HSL3HPD3HSL/K3L''CB@YIRTFIRD!!HRDAHP$IK2<0I00 FRT%A"T!!L3L3@SL3BR<3LCLLHA$%IPX%HRD!!HQ\!!BP$/LC@0CB@Y
IRTFIQ\3E3L,L3L3K3@3CB GFRT%A"T2L#HMCRHWK@$CD#@1CA$%IP,YFQ$YFQ$YFQ$YFQ$YFQ$YIP@a');
                colorMapFromArray:#[ 204 208 220 245 246 250 224 227 236 240 242 248 140 145 163 212 215 227 207 211 222 227 230 238 193 197 211 241 243 248 214 218 228 210 214 224 231 233 241 249 250 252 201 206 218 200 204 217 196 200 213 220 223 233 238 240 247 234 236 243 250 251 252 205 209 221 225 228 237 245 247 250 223 226 235 116 120 133 240 241 248 253 254 254 211 214 226 252 252 253 207 210 222 178 183 200 229 231 240 247 248 251 246 248 250 242 244 249 241 242 248 255 255 255 213 217 227 232 234 242 230 232 240 248 249 251 202 207 219 201 205 218 243 245 249 219 222 232 217 220 230 237 239 246 235 237 244 234 237 243 251 252 253 0 0 0 ];
                mask:((ImageMask new)
                            width:19;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_? @_?0@_?8@_?<@_?>@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@');
                            yourself);
                yourself
        ]
!

fileImageContents19x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileImageContents19x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileImageContents19x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class fileImageContents19x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
IQTFA XFA XND@ _G2T%IRT%IRTFIRT%IRT[E0$/A!! _IRT%IRT%A"T%IRT%H!!\,BPX(CA<%IRT%IPX%IRT%IP4"E20F@3HQG2T%IRTFIRT%IRTMH!!\,A"$%
H 0_IRT%A"T%M#X6M#X6M PDA@PDA@P%IPX%ISX6M#X6M#X6M#X8J0<YIRTFIRT6MST5MST5MSX6N@@*FRT%A"T%MST5MS\5M3T5M# EGA$%IPX%IST5MST5
MST5MSX8K (YIRTFIRT5MST5MST5MST6NA QFRT%A"T%MST5M3T5MST5M# VFA$%IPX%F3T5MST5MST5MSX8A1XYIRTFIRH6MST5MST7MST6NB@ FRT%A"T!!
MST5MST5MST5M# (A1$%IPX%HSX5MST4MST6M#X8CB@YIRTFIRD6M#X6MCX6M#X6N@0 FRT%A"T!!M#X6M#P6M#X6M# LHA$%IPX%HS\7M3\4M3\7M3\8CB@Y
IRTFISH2CP4"E20I@1H0LB GFRT%A"T2L#HMCRHWK@$CD#@1CA$%IP,YFQ$YFQ$YFQ$YFQ$YFQ$YIP@a');
                colorMapFromArray:#[ 204 208 220 245 246 250 224 227 236 240 242 248 140 145 163 212 215 227 207 211 222 227 230 238 193 197 211 241 243 248 214 218 228 210 214 224 231 233 241 249 250 252 201 206 218 200 204 217 196 200 213 220 223 233 238 240 247 234 236 243 250 251 252 205 209 221 225 228 237 245 247 250 223 226 235 116 120 133 240 241 248 253 254 254 211 214 226 252 252 253 207 210 222 178 183 200 229 231 240 247 248 251 246 248 250 242 244 249 241 242 248 255 255 255 213 217 227 232 234 242 230 232 240 248 249 251 202 207 219 201 205 218 243 245 249 219 222 232 217 220 230 237 239 246 235 237 244 234 237 243 251 252 253 0 0 0 133 60 36 0 206 0 174 218 230 0 137 0 130 163 172 ];
                mask:((ImageMask new)
                            width:19;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_? @_?0@_?8@_?<@_?>@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@');
                            yourself);
                yourself
        ]
!

fileIn18x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileIn18x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileIn18x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileIn18x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:18;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@]GQ4]GQ4]GQ4]GQ4]@@@@@@@]GQ4]GQ4]GQ4]GQ4]@@@@@@@]GQ4]GQ4]GQ4]GQ4]EQTUEQTUEQTTGQ4]GQ4]GQ4]EQ4]GQDDI2XUEA4]GQ4]GQ4]
EQ4]GP$K@"XUG!!P]GQ4]GQ4]EQ4]GP$QA"XTEAPTGQ4]GQ4]EQ4]GP<QARX_GBDTGR$]GQ4]EQ4]GQLIFQ,%E!!\TGR$)GQ4]EQ4]GQ4IH"X)JR$)JR$)JQ4]
EQ4]D1DDJAH)JR$)JR$)JR$]EQ4SC1 [G0()JR$)JR$)JR$)EQ4]DQ([C!!@)JR$)JR$)JR$]EQ4OC@TFI 8)JR$)JR$)JQ4]EQ4@H TFI 8(B DTGR$)GQ4]
EQ4DH TZF08(B DTGR$]GQ4]EQ4"FQ(F@ 8_B DTGQ4]GQ4]EP$"H TFI 8(B DTGQ4]GQ4]EAPTEAPTEAPTEAPTGQ4]GQ4]@@@@@@@]GQ4]GQ4]GQ4]GQ4]
@@@@@@@]GQ4]GQ4]GQ4]GQ4]@@@@@@@@@@@@@@@@GQ4]GQ4]');
                colorMapFromArray:#[ 250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 248 0 0 ];
                mask:((ImageMask new)
                            width:18;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@?8@@?<@@?>@@??@@??P@??X@??<@??>@???@??>@??<@??X@??P@??@@??@@??@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

fileSave19x19Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileSave19x19Icon inspect
     ImageEditor openOnClass:self andSelector:#fileSave19x19Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileSave19x19Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:19;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@CT4MCH0K20)I2P$H2H!!G14\@CV%(/SL4][4=OS4=OS4=OQ@OP(4(Y;4F1,[=OS4=OS4<.W^PC4HL9"W=A.#&/S4=OS4;NOW43$4A3JU$_P[''974=OS49]/S
3,PYFP\1#H+'':^/3<?O38=/S1<BNFA GK8RD^7Y.Y59ZT$1HP3<9F1TUA2:@_GM-ZU9ZT$5GP389F1,UEP\-]''M,Y&AXUD1JP389NQ,[EQTGJ&)/Y6M]U5EK
RTD=NS$9MQTUA2%#X.S$8-?Z5MCM2LN6,[DUEPX''V%+"8-?Z5MCM2LO@*ZZ)FQ$DI5UU8K.9-;R1+::-&X"E*Q X@2YNS-?_6-SP2LO@-JZ\$:LUEPT&RT'']
.KV2,J:-&8"A^WRVEQTGITIB6-+T4L"<*ZZ\$8.G#1TUA2U@PM^6,Z.(&YJE_W]1[H8UEP\%OC2P$H6F 7)5Z6U_WE%VEAPH@@$IBP$HB@ HB@ HB@ HB@ H
@@@a');
                colorMapFromArray:#[ 0 0 0 28 33 37 34 41 60 37 45 83 39 48 89 42 51 96 45 55 103 49 60 112 54 65 115 54 66 115 54 66 116 57 70 107 57 70 109 59 59 58 65 79 121 65 80 125 66 80 124 68 83 130 74 71 70 77 81 85 78 95 152 80 98 153 81 98 151 83 47 28 85 102 157 86 103 157 88 101 128 90 110 162 94 106 146 94 106 147 95 83 66 95 107 147 96 74 37 97 108 148 98 109 148 98 109 149 99 110 149 101 111 150 101 111 151 101 112 151 102 102 107 102 113 151 102 113 152 103 86 54 103 113 151 103 113 152 103 114 152 104 114 152 105 115 152 105 115 153 106 116 153 107 116 154 107 117 154 108 117 154 116 124 137 123 85 65 123 107 74 125 143 184 126 64 32 126 139 158 126 143 183 127 145 185 128 145 184 129 146 185 129 147 186 130 148 186 131 148 187 131 149 187 132 141 160 133 141 159 133 143 164 134 151 188 134 151 189 134 152 189 135 152 189 136 153 190 137 154 191 138 154 191 139 156 193 141 151 173 142 69 67 142 157 193 142 158 193 143 62 26 143 158 193 143 159 194 144 157 200 144 161 195 145 161 195 146 158 202 146 162 196 147 89 55 147 160 203 147 162 196 148 165 197 149 161 204 149 164 197 150 166 198 150 166 199 151 167 199 152 149 137 152 163 206 152 168 199 153 169 201 154 96 64 154 169 201 154 170 201 155 167 207 155 171 202 156 171 202 156 171 203 157 172 203 157 173 182 157 173 203 159 147 111 159 174 204 159 175 204 160 170 210 160 174 204 160 176 205 162 172 191 162 178 207 163 173 212 163 177 206 164 177 207 164 180 207 165 147 99 165 165 166 165 178 207 166 182 208 167 147 95 167 177 214 167 181 209 169 185 209 170 179 216 170 186 215 171 185 210 172 162 152 172 185 212 172 187 217 173 186 212 174 182 218 174 188 219 175 190 221 176 184 220 176 189 214 176 190 213 176 190 218 177 145 64 177 190 215 179 193 223 180 192 216 181 193 216 181 194 214 181 195 218 182 194 214 182 195 221 183 196 219 184 195 218 184 197 219 185 95 37 185 196 219 185 197 219 185 197 222 186 185 192 187 198 220 187 200 223 188 171 94 188 199 217 192 204 226 194 97 38 195 206 220 196 168 100 196 206 218 198 207 220 202 211 222 203 212 222 205 214 224 207 215 224 208 101 40 209 217 225 210 217 226 210 219 227 212 220 227 213 220 227 214 221 228 217 103 41 217 223 229 217 224 237 219 101 37 222 177 45 222 225 232 223 228 241 224 187 54 225 105 42 226 231 241 226 231 243 228 196 63 230 202 70 230 234 245 230 235 243 232 240 251 233 208 76 233 235 240 233 236 247 233 237 244 233 237 246 235 214 82 235 238 245 236 239 248 237 239 242 238 241 249 239 242 247 240 242 242 240 242 249 240 243 249 242 220 141 242 242 227 242 244 249 242 244 250 244 244 245 244 246 250 244 246 251 245 247 250 246 247 250 246 247 251 247 248 251 247 248 252 248 249 251 248 249 252 249 99 39 249 249 253 250 147 56 250 250 253 251 169 79 251 251 253 251 252 253 252 99 38 252 178 84 252 187 89 252 199 96 252 206 99 252 252 253 252 252 254 253 253 254 ];
                mask:((ImageMask new)
                            width:19;
                            height:19;
                            bits:(ByteArray 
                                        fromPackedString:'_??@??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? _??@');
                            yourself);
                yourself
        ]
!

fileSaveAs22x19Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileSaveAs22x19Icon inspect
     ImageEditor openOnClass:self andSelector:#fileSaveAs22x19Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileSaveAs22x19Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:19;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@EV[&2N]_>1!!M#$9@;FJ[5CY@@@@@EW83CMQA8L3L3L3L3L3L3LB[(UOX B[Z\435-[VL3L3L3L3)4^?@&;>F!!B(HDTSL=[[7#L3L3L3?IC0,+)I,ORB82N>
U3OVP@<3L3L3Q2^2\LR^P\E3F2+*J_EFZ8#:>/+:EB]]&J+7<$,A8_''C_;Z6C-==134J\W1_YS+%%-T&49H@0<X?CEX% S4J\Q?+++LI#[.S^^D@@LM 75Z@
;6^KCW1>++M&2OTV(SCN@@CC*>6\1<&56-7)1S#O%7ZT]C@E3 @@06GI+=KR.IG@A,*7M^!!Z&!!#XP)<@@LL6B *8.IG@KA67[TN4LZV,D]E(@@CCM-3\SA''B
)(\R8(<""S-^QE/6^0@@0:5:^)EI))UI\$&D;.O 95"=9$8@@LN-1\U7RT''PRZAIRZH>T+1*T5ON@@CCX3\70L@,2''I,Y@.YMK%M#%MS3 @@06LB@/CKD#0\
?WW3#EP$ D)ST<8@@LM#B@#T5M\W^CK;RNQYKR:#G!!:$@@CC@B</K2>$)JR$)JR$)JR$)JR$@@@@00@a');
                colorMapFromArray:#[ 0 0 0 142 69 67 129 147 186 98 109 149 242 51 50 86 103 157 240 242 242 236 239 248 126 143 183 165 147 99 146 162 196 187 200 223 164 177 207 143 158 193 163 177 206 183 196 219 147 89 55 66 80 124 205 214 224 180 192 216 247 248 252 203 212 222 255 100 39 170 179 216 123 107 74 217 223 229 186 185 192 77 81 85 188 199 217 242 242 227 78 95 152 138 154 191 107 116 154 226 231 241 242 220 141 106 116 153 157 173 203 156 171 202 255 106 42 242 244 250 247 105 44 173 186 212 83 47 28 196 206 218 239 242 247 147 160 203 146 158 202 54 66 115 95 83 66 225 105 42 163 173 212 253 253 254 176 190 218 222 177 45 101 112 151 131 148 187 130 148 186 99 110 149 129 146 185 96 74 37 195 206 220 148 165 197 166 182 208 165 178 207 184 197 219 188 171 94 81 98 151 255 236 120 133 141 159 181 193 216 249 249 253 248 249 252 155 167 207 88 101 128 174 188 219 250 147 56 246 247 250 170 186 215 42 51 96 154 96 64 94 106 147 233 236 247 162 178 207 80 98 153 160 176 205 108 117 154 159 174 204 176 189 214 141 151 173 149 161 204 252 99 38 57 70 107 213 220 227 233 235 240 126 139 158 134 151 189 103 113 152 102 113 151 254 107 43 101 111 150 192 204 226 150 166 198 159 147 111 149 164 197 39 48 89 185 196 219 179 193 223 250 250 253 217 224 237 222 225 232 127 145 185 95 107 147 233 237 246 142 158 193 230 235 243 165 165 166 208 101 40 176 190 213 252 199 96 244 246 250 167 177 214 185 95 37 139 156 193 37 45 83 137 154 191 156 171 203 135 152 189 104 114 152 155 171 202 154 169 201 102 102 107 240 242 249 34 41 60 54 66 116 210 217 226 209 217 225 251 251 253 219 101 37 97 108 148 145 161 195 164 180 207 230 202 70 175 190 221 172 162 152 246 247 251 245 247 250 28 33 37 255 101 39 254 99 38 237 239 242 233 208 76 224 187 54 230 234 245 182 195 221 217 103 41 107 117 154 157 172 203 105 115 152 177 145 64 45 55 103 198 207 220 194 97 38 171 185 210 144 157 200 54 65 115 103 86 54 212 220 227 252 252 253 255 117 45 182 194 214 223 228 241 102 113 152 162 172 191 101 111 151 131 149 187 150 166 199 244 244 245 98 109 148 238 241 249 128 145 184 249 99 39 147 162 196 167 181 209 233 237 244 247 248 251 172 187 217 125 143 184 252 178 84 159 175 204 65 80 125 177 190 215 244 246 251 242 244 249 157 173 182 214 221 228 255 255 255 226 231 243 134 152 189 103 114 152 153 169 201 228 196 63 151 167 199 235 238 245 210 219 227 185 197 219 184 195 218 49 60 112 152 149 137 207 215 224 65 79 121 248 249 251 143 62 26 176 184 220 251 169 79 90 110 162 174 182 218 85 102 157 94 106 146 144 161 195 185 197 222 143 159 194 142 157 193 181 195 218 160 174 204 132 141 160 74 71 70 202 211 222 126 64 32 152 163 206 167 147 95 68 83 130 133 143 164 252 206 99 136 153 190 105 115 153 134 151 188 103 113 151 154 170 201 123 85 65 152 168 199 240 243 249 172 185 212 235 214 82 169 185 209 232 240 251 252 187 89 57 70 109 196 168 100 187 198 220 59 59 58 252 252 254 160 170 210 251 252 253 181 194 214 116 124 137 ];
                mask:((ImageMask new)
                            width:22;
                            height:19;
                            bits:(ByteArray 
                                        fromPackedString:'_??@???8???<???<???<???8???0??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? _??@');
                            yourself);
                yourself
        ]
!

fileTypeCPlusPlusSourceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeCPlusPlusSourceIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeCPlusPlusSourceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeCPlusPlusSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKC@4GC@4KC08OC0@@@@@ED@,DB@\GB0<ODP<@@@@@@PHPA@,HA0\KB1LO@@@@@@=CNT@/M#YB
N3 KDP@@@@@QJR,0LCD*J"L=B1D@@@@@E"40LR$#M4D)L \V@@@@@A\(LCD&IC@-LB<GE0@@@@@YMS@1JC@0LC@1AA$@@@@@HB<0LRT%LB 0KA@ @@@@@BD3
K#@0LS0%JB PHP@@@@@!!O#8?MC(7JR,%DBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 248 248 248 219 219 219 230 230 230 241 241 241 232 232 232 223 223 223 234 234 234 238 238 238 229 229 229 251 251 251 231 231 231 253 253 253 239 239 239 243 243 243 225 225 225 236 236 236 244 244 244]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

heartOverlay
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self heartOverlay inspect
     ImageEditor openOnClass:self andSelector:#heartOverlay
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class heartOverlay'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:15;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
O3<NC0<?O3<?O4EAL4@?O3<8C =^@PD?L%MAL3L3TC= XC,DGPH@L$<''F%D6CCMPA \"UAAEJU<5WR((M6%)T@Y$OFDCM11DF4LMMEI\ZU@?G%\_Q",QQ3$,
F!!(RI%APO1%VRPU"UT :KRABF&]PO3<?B4(SX286HR TP$5PO3<?O3=(K1THYU!!KOSAPO3<?O3<?O6 #E %&VU)PO3<?O3<?O3<?SC9EJTAPO3<?O3<?O3<?
O2T1IE-PO3<?O3<?O3<?O3<?S!!\JTC<?O3<?O3<?O3<?O3<XTC<?O3<?O3<?O3<?O3<?TE@?O3<?O3<?');
                colorMapFromArray:#[ 237 93 63 240 72 43 255 96 56 255 110 74 255 125 93 255 116 81 244 165 152 255 175 155 255 102 64 255 95 55 96 57 66 215 109 88 224 81 58 255 52 2 230 114 94 241 101 71 255 107 70 255 94 54 255 87 44 255 136 106 255 61 12 255 113 78 255 104 67 252 101 65 208 79 60 223 96 73 255 55 5 255 71 26 255 92 51 255 105 68 252 134 104 255 138 109 255 58 8 255 80 37 255 186 169 255 130 99 255 100 62 190 136 133 236 53 17 255 56 6 255 70 24 255 89 47 255 51 1 255 104 66 255 64 17 255 67 20 255 99 60 255 164 142 109 41 45 252 109 74 197 81 70 241 57 15 255 57 7 255 68 22 255 90 48 255 101 63 236 144 129 255 75 30 255 77 33 255 167 145 255 180 162 255 63 15 255 108 72 255 255 255 159 49 39 241 51 8 255 52 1 255 61 13 255 81 38 255 98 59 255 111 75 255 85 42 255 87 45 255 162 139 255 183 164 255 73 28 238 109 78 120 41 44 212 97 79 248 64 20 77 77 77 255 84 41 255 97 58 247 36 9 255 129 98 255 97 57 252 170 150 255 181 162 255 83 40 255 76 32 120 45 46 220 64 38 252 51 2 255 58 9 239 97 68 241 73 37 241 132 110 255 128 96 255 106 69 255 109 72 255 178 158 255 93 52 255 86 43 114 46 52 212 117 99 248 53 7 ];
                mask:((ImageMask new)
                            width:16;
                            height:15;
                            bits:(ByteArray 
                                        fromPackedString:'NC1>?/???????7??_?8??A?8C?@G8@_@@<@A @F@');
                            yourself);
                yourself
        ]
!

help28x28Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self help28x28Icon2 inspect
     ImageEditor openOnClass:self andSelector:#help28x28Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class help28x28Icon2'
        ifAbsentPut:[(Depth4Image new) width: 28; height: 28; photometric:(#palette); bitsPerSample:(#[4]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@3H@@@@@@@@@@@@@@@@CL2@@@@@@@@@@@@@@@@L3L @@@@@@@@@@@@@@@3L3@@@@@@@@@@@@@BLCL3
L0@@@@L3@@@@@CL0L3L3@@H3L3L0@@A@L3@3L3LBH#L3L3A@@D@3LCL3L0H"L3L3LD@@PCL0L3L3@"D3L1L0P@A@L3@3L3LBH!!L1L3A@@D@3LCL3L0H"HQL3
LD@@PCL0L3L3@"H#D3L0P@A@L3@3L3LBH"D1L3A@A@L3LBL3L0H"D3LSLD@D@3L0H#L3@"D#L3D0P@PCL3LBH#LBHRL3L3A@A@L3L3@"H0H"H3L3LD@D@3L3
L H"@"H#L3L0P@PCL3L"@"HBH"L3L3A@A@H"H"H H H"H#L2HD@D@@H"H"HB@"H"H"H@P@ADP@H"H HBH"H @DQ@@@@DP@@"H@H"H@Q@@@@@@@@@Q@@B@ @D
P@@@@@@@@@@@AD@@Q@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[64 64 64 0 128 92 192 192 192 253 253 253 191 191 0]; mask:((ImageMask new) width: 28; height: 28; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@X@@@@G @@@A<@@@@_ @@@G<@@@G?@\@C?9? C????A????0_???<G????A????0_???<G????A????0????<O????C????0????<O????C????0????<O??
??C????0O???8@_?? @@?? @@A?@@@@a') ; yourself); yourself]
!

helpIcon
    ^ self help22x22Icon
!

hexToggle19x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hexToggle19x22Icon inspect
     ImageEditor openOnClass:self andSelector:#hexToggle19x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class hexToggle19x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
IQTFA XFA XND@ _G2T%IRT%IRTFIRT%IRT[E0$/A!! _IRT%IRT%A"T%IRT%F1,[F0X(CA<%IRT%IPX%ISL3L2T3L3LF@3HQG2T%IRTFIRT3IRT%L2D3A"$%
H 0_IRT%A"T%L3L3ISL3L0PDA@PDA@P%IPX%IRT%L2T3ECLRL243J0<YIRTFIRT3L2T%L3H3BSL3L0@*FRT%A"T%IRT%IQ4TE00XKRXEGA$%IPX%ISL3L1,3
L3L L3L3K (YIRTFIRT%ISL[L3@1CCLG@!! QFRT%A"T%ISL3E3L3L@03L1XVFA$%IPX%F1,[L203@2<0L00 A1XYIRTFIRH3L3LAL0$$K3L3L2@ FRT%A"T!!
HRDWE2LIIB<0D00(A1$%IPX%HSL3L0D3L3L/K3L''CB@YIRTFIRD3HSLAL0$IK3L0L00 FRT%A"T!!L3L3@SL3BR<3LCLLHA$%IPX%HSL!!L1\3BP$/L3@3CB@Y
IRTFIQ\3E3L,L3L3K3@3CB GFRT%A"T2L#HMCRHWK@$CD#@1CA$%IP,YFQ$YFQ$YFQ$YFQ$YFQ$YIP@a');
                colorMapFromArray:#[ 204 208 220 245 246 250 224 227 236 240 242 248 140 145 163 212 215 227 207 211 222 227 230 238 193 197 211 241 243 248 214 218 228 210 214 224 231 233 241 249 250 252 201 206 218 200 204 217 196 200 213 220 223 233 238 240 247 234 236 243 250 251 252 205 209 221 225 228 237 245 247 250 223 226 235 116 120 133 240 241 248 253 254 254 211 214 226 252 252 253 207 210 222 178 183 200 229 231 240 247 248 251 246 248 250 242 244 249 241 242 248 255 255 255 213 217 227 232 234 242 230 232 240 248 249 251 202 207 219 201 205 218 243 245 249 219 222 232 217 220 230 237 239 246 235 237 244 234 237 243 251 252 253 0 0 0 ];
                mask:((ImageMask new)
                            width:19;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_? @_?0@_?8@_?<@_?>@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@');
                            yourself);
                yourself
        ]
!

historyBackInGlobalListIcon
    <resource: #programImage>

    ^ self left2Arrow24x24Icon
!

historyOverlayIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self historyOverlayIcon inspect
     ImageEditor openOnClass:self andSelector:#historyOverlayIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class historyOverlayIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
7M0@^E]G/+Z"]K5#PP@@@M3\7&H(NG7!!P,YCR9AF@@C\0*@$H-FR7S;OASWP[L\@%6AJ.F.YLUJ,2''A.ML]O@GTY61ZE$ZZK0XM)HC''KW,^@CA@*_5.''U(0B
,H&XHU5O3+,^+)>Z ''-''T^BOE5!!>S2X.AJE&_IOVN7J#UM"%74>D2D97GAU(S\Q!!3H#CV'')OM0%PI5&G*-T6^P,HK=+ES:53/1P=]!!H]*BN^''K11J<\,!!-I-
Z"$[L@Z]T064G0(@[3H3&5TS2S0A2(7TYZ,+@@LG,[(ZIZSYRTUL##*J@@@C*[)HK]N5 ]>/8%>N@@@@@:$@@B5OS4=OS>H@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 210 226 249 14 16 17 130 130 154 76 115 210 167 187 210 222 247 254 128 128 152 123 181 246 200 202 216 55 55 77 146 201 252 218 219 227 149 200 245 56 56 68 6 6 9 134 176 227 4 4 7 202 241 254 206 236 248 133 192 249 133 190 249 167 214 246 95 162 248 42 42 54 224 220 226 182 182 198 219 243 254 120 179 246 209 246 254 122 178 238 122 120 149 140 184 216 117 135 177 200 208 222 189 232 254 227 226 232 163 169 189 209 206 211 119 179 248 219 216 224 206 242 254 169 220 254 102 100 129 137 139 160 121 121 141 170 189 222 99 167 248 233 253 254 233 251 254 131 131 154 188 185 200 159 163 188 178 182 200 176 225 254 182 181 194 218 218 226 122 159 211 83 82 110 2 3 4 175 181 230 164 214 252 185 202 233 43 43 54 57 57 71 123 123 149 190 198 218 201 198 209 39 39 50 150 161 182 87 87 107 177 177 192 69 69 86 163 171 198 228 227 232 168 167 183 125 129 154 60 64 67 82 134 224 56 57 73 103 158 228 46 60 73 197 213 241 187 235 254 97 160 245 162 190 213 214 254 254 163 163 181 77 115 189 143 197 247 76 111 188 194 236 254 0 0 1 149 145 167 111 110 133 57 57 80 183 184 197 46 62 79 182 182 196 124 124 149 24 24 31 122 120 147 142 197 249 18 22 25 71 92 110 44 54 57 181 231 254 194 227 247 92 92 114 142 178 219 141 178 218 139 139 160 198 243 254 112 117 150 68 90 110 213 210 216 170 170 187 168 168 185 187 230 253 103 160 240 166 166 183 168 220 254 137 135 161 116 145 160 134 191 247 206 209 222 153 150 170 184 230 253 184 183 197 162 162 182 164 208 230 158 188 201 201 198 207 202 242 254 178 177 191 163 214 252 102 164 245 145 192 231 13 13 19 219 248 254 160 194 206 169 207 228 124 123 151 144 200 253 123 123 150 209 241 254 228 238 243 62 76 90 37 37 49 33 33 45 31 31 43 169 169 185 128 185 247 226 249 254 178 226 253 179 183 198 142 200 254 206 241 254 167 215 252 166 215 251 192 192 204 116 163 235 189 188 201 94 134 177 179 187 201 57 95 187 213 242 254 203 243 254 203 241 254 136 136 162 170 218 248 82 81 109 210 232 251 153 153 172 154 208 252 129 128 155 36 47 57 110 110 133 90 90 110 40 40 51 106 123 162 160 159 182 200 197 208 36 36 47 171 191 219 28 28 39 166 166 181 191 201 222 107 158 222 141 141 163 192 191 203 142 169 210 170 170 188 224 254 254 167 168 185 71 131 236 47 63 77 127 123 149 196 197 210 159 158 177 177 192 221 241 254 254 221 254 254 166 166 187 65 98 134 57 57 70 201 198 208 195 221 235 178 177 192 201 216 231 192 195 209 155 154 176 118 133 166 153 196 220 55 51 48 11 11 18 39 88 214 151 154 195 94 120 172 181 195 221 171 171 188 149 158 216 167 167 184 146 146 170 154 206 247 189 200 222 105 105 133 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'G? ??G?>??;????????????????????>??9??C?8C>@b');
                            yourself);
                yourself
        ]
!

imageEditor19x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageEditor19x26Icon inspect
     ImageEditor openOnClass:self andSelector:#imageEditor19x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class imageEditor19x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@!!H!!LF@@@@@@@@@@@@@@@@@@@]N&I,I0(C@0LC@0LC@0LC@0LCI&QHQ4@N@00LC@0LC@0LC@0LJ#QUQC<$I0LLC@0LC@0LC@0LCB!!&
R4T=FP@CC@0L@ HB@ HBC@03V41AJ0T@@00L@ HB@ HB@PH,ZEAMO!!TC@@LL@ HB@ DB@ HBLFEOQ#HP@0@CC@HB@ HB@ HBLV)XTTHXC@L@@00B@ HB@ HB
@R=%UD9CD 0C@@LL@ HB@ HA@#$<W%YIG 0L@0@CC@HB@ DB@ H8Z5%WR!!PLC@L@@00B@ HB@ H.N6MZT!!< C@0C@@LLC@HB@ HBM&5_WELZC@0L@0@CC@HB
@ HB@"5)XE4%E00LC@L@@00B@ HDA@P)[F\5C00LC@0C@@LLC@HB@ PDH607CP0LC@0L@0@CC@0LC@0DA@ IDP0LC@0LC@L@@00LC@0LA@PGB00LC@0LC@0C
@@LLC@0L@PPDF00LC@0LC@0L@0@CC@0A@PDA@PDA@PDAC@0LC@L@@00A@PDA@PDA@PDA@PDAC@0C@@LC@0LC@0LC@0LC@0LC@0LC@0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 137 0 0 206 0 87 87 87 133 60 36 145 109 112 155 31 0 160 115 98 161 124 106 163 140 130 166 46 5 169 113 95 174 218 230 182 93 58 183 59 8 186 100 65 192 147 138 193 129 103 193 132 116 195 100 52 195 120 93 197 82 32 204 208 220 205 177 176 207 90 27 210 109 64 210 140 105 213 175 169 213 217 227 215 172 138 220 114 42 222 120 43 222 209 212 223 137 33 223 153 96 226 180 137 228 90 9 228 142 66 232 174 56 234 184 145 240 178 78 241 195 142 241 212 187 242 102 12 242 177 95 245 202 137 245 209 172 247 181 30 247 183 8 247 198 128 248 122 26 248 194 1 248 198 0 248 201 137 248 203 113 248 214 181 249 193 57 249 210 160 250 206 0 253 222 69 253 226 47 254 116 14 254 128 21 254 136 5 254 141 47 254 144 8 254 147 36 254 147 47 254 158 0 254 158 1 254 159 21 254 161 10 254 162 0 254 165 54 254 165 69 254 167 2 254 167 5 254 171 10 254 176 36 254 177 17 254 178 11 254 181 24 254 184 75 254 184 94 254 187 34 254 191 0 254 191 42 254 191 54 254 194 26 254 197 55 254 201 65 254 203 3 254 203 78 254 203 97 254 207 47 254 209 81 254 212 90 254 213 16 254 214 81 254 216 73 254 219 0 254 220 37 254 223 0 254 225 166 254 226 7 254 226 119 254 231 26 254 231 65 254 231 201 254 239 98 ];
                mask:((ImageMask new)
                            width:19;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@O@@@_ ??? ??? ???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

inspect22x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self inspect22x24Icon inspect
     ImageEditor openOnClass:self andSelector:#inspect22x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class inspect22x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ HB@ HB@ D@@@@@@@@@@@@@@(>O#8VB (JB %,A@@@@@@@@@@@@
@@JO#8>E (JB (I[@P@@@@@@@@@@@@@B#0DA!!PDA  FBV0D@@@@@@@@@@@@@@(>O#8VB (JB %,AWP@@@@@@@@@@@@JO@PDA!!V 3APPHEQ,=]P@@@@@@@@@B
#8>O!!4<KE3]EQ$D0FAIV@@@@@@@@@(<A#4<\VH>O#8>O#8>OBEX@@@@@@@JO#6P]TX>O#8>O#8>O#1<E]P@@@@@B#0D5K8>O@PDA@X<A@X<BDBH@@@@@@(=(
IH>O#8>O#8>O#8>O@#@CY @@@@DAYA6O@X<A#0DA@X<A#0IBA6P@@@@@@FP]#8>O#8>O#8>O#8<BVP5$@@@@@@A$GX<A@PDA#0DA#0FO@%PMY@@@@@@@YA88
#8>O#8>O#8>O^@IRAFP@@@@@@GT4I HB@ HB@ HB@ HBM )5@@@@@@@@S0<0UDMGVV)8_X>OZP1V@@@@@@@@^&PTC3!!UUU%%YV)=]"L,@@@@@@@@#''%LD0XO
I4AUYU%RO"L-]P@@@@@@#X.JR1EMQATIC!!X%H29D]@@@@@@@#X2JX2(!!Y A&S$QPU5Y&@@@@@@@@@H2JX2, L @@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 78 78 91 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 156 156 182 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 201 201 218 204 204 219 206 206 221 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 210 210 224 211 211 225 213 213 228 215 215 229 216 216 230 218 218 231 219 219 232 220 220 233 222 222 235 223 128 63 223 223 224 223 255 255 224 224 224 224 224 236 224 224 239 224 239 240 224 255 255 225 225 237 228 228 238 229 229 239 230 230 240 232 232 241 234 234 243 235 235 244 236 236 244 238 238 245 239 239 224 239 239 239 239 239 240 239 239 246 239 255 255 240 207 144 240 239 223 240 240 239 240 240 247 240 255 255 241 241 248 242 242 249 243 243 249 244 244 250 245 245 252 246 246 253 248 248 254 249 249 254 250 250 255 252 252 255 253 253 255 254 254 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@G?8@G?8@G?8@G?8@G?<@G??@G?? G??0G??8G??8G??<G??<A??<A??<A??<A??<@??8A??0C??0G?? O;>@O0@@');
                            yourself);
                yourself
        ]
!

magnifyingGlassOverlay
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self magnifyingGlassOverlay inspect
     ImageEditor openOnClass:self andSelector:#magnifyingGlassOverlay
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class magnifyingGlassOverlay'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADEQPX
IR)P@@@@@@@@@@@@@@@@@@@@@A,''RE!!YUD@(H&\@@@@@@@@@@@@@@@@@J6$@@@@@@@@@JQ!!''@@@@@@@@@@@@@@@,X @@@@@@@@@@@D@U@@@@@@@@@@@@@DX?
 P@@@@@@@@@@@HE@LP@@@@@@@@@@@CMR@@@@@@@@@@@@@@A@D0@@@@@@@@@@@B1Y@@@@@@@@@@@@@@A&E0@@@@@@@@@@@B1&@@@@@@@@@@@@@@A&GP@@@@@@
@@@@@B1Y@@@@@@@@@@@@@@A&GP@@@@@@@@@@@B5I@@@@@@@@@@@@@@A&E@@@@@@@@@@@@DT5@@@@@@@@@@@@@@AGF @@@@@@@@@@@@@_P@@@@@@@@@@@@F,\
Y0@@@@@@@@@@@@@$G4%&@@@@@@@@ CH<@@@@@@@@@@BP %4#E!!<6T6Y1Z&MQL#4@@@@@@@@@@H>M#E0!!@@@%FQ8&MCH>U0@@@@@@@@@@#8:L[S(0@@@@@@@@
@@@@@@@@@@@@@@@@#(1-N2<@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 32 223 32 40 255 124 50 255 112 51 255 109 54 229 139 62 255 87 62 255 88 62 255 91 62 255 136 64 64 64 73 255 115 83 255 62 91 255 73 94 255 74 101 255 84 105 255 85 112 255 96 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 170 170 170 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 176 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 183 183 183 190 190 190 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 196 196 196 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 217 217 217 223 32 32 223 128 63 223 192 255 223 223 32 223 223 224 223 255 255 224 224 224 224 224 239 224 239 240 224 255 255 231 207 255 231 208 255 238 191 255 238 192 255 239 159 232 239 191 255 239 223 255 239 224 255 239 239 224 239 239 239 239 239 240 239 255 255 240 207 144 240 239 223 240 240 239 240 255 255 246 176 255 247 175 255 247 207 255 247 239 255 254 160 255 254 191 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O8@@_>@@0G@A C@C C C@A C@A C@A C@A C@A C@A A C A8G@O?>@_O<@?@@@>@@@');
                            yourself);
                yourself
        ]
!

menuEditor19x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuEditor19x26Icon inspect
     ImageEditor openOnClass:self andSelector:#menuEditor19x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class menuEditor19x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@A5\''L=@@@@@@@@@@@@@@@@@@A)N9MRUVLEK"8.K"8.K"8.K"8.&D%>_G\2AP<OC0<OC0<OC0<OYHQL_6T7UPTOC0<OC0<OC0<OC81H
$S)9M @EC0<OC0<OC0<OC0=FS)Y''R''@@AP<OC0<OC0<OC0=,PV!!:O)\@@A,[F1,[F1,[F1,[X(ADZ)UG@@@C@0LC@0LC@0LC!!46A[8Y; 0@@CALSD1LSD1LS
D4M-NEE6]@@@@@0SD1LSD1LSD5A_[(49V!!P@@@@LD1LSD1LSD1NK"%05T9HT@@@@KB0,KB0,KB1YPDVN#3D,E@@@@@T.K"8.K"8._U!! W&ZIK!!P@@@@EC0<O
C0<OC7!!KOCNP"@<T@@@@AP<OC0<OC0=TT#=BU <OE@@@@@TOC0<OC0<OU5JT!!P<OC1P@@@@[F1,[F1,[F5,4\Q,$EAPT@@@@AR8.K"8.K"9!!S28.K"8.E@@@
@@TKC0<OC0<OZ0<OC0<OC1P@@@@EJP<OC0<OC0<OC0<OC0<T@@@@B!!8OC0<OC0<OC0<OC0<OE@@@@@8AFA<IGRL"@!!X E!!@TIAP@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 106 103 105 108 108 111 21 232 231 3 189 187 226 226 228 104 104 105 109 109 108 21 231 231 82 82 83 213 213 214 187 187 187 133 233 234 21 231 230 90 90 92 186 186 188 108 108 108 135 225 226 138 243 244 2 186 188 85 85 88 133 225 227 107 107 109 182 182 181 107 107 108 19 230 230 0 129 126 102 102 103 0 128 126 85 85 84 180 180 182 101 101 104 105 105 109 111 111 110 84 84 85 88 88 90 96 96 99 0 125 126 2 191 189 0 138 139 97 94 99 193 193 192 110 110 109 19 234 233 5 141 143 95 95 99 254 254 252 2 190 188 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:19;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@O@@@_ ??? ??? ???@???@??>@??>@??>@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

menuEditor22x26Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuEditor22x26Icon3 inspect
     ImageEditor openOnClass:self andSelector:#menuEditor22x26Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class menuEditor22x26Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@]WI3OP@@@@@@@@@@@@@@@@@@@@@@ZS.ST%U#@@@@@@@@@@@@@@@@@@@@@I!!I_''17L T.
K"8.K"8.K"8.K"8.K&RDSG=%M5TEC0<OC0<OC0<OC0<OC0>LRID:^SX@AP<OC0<OC0<OC0<OC0<OQ$:VY4)0@@TOC0<OC0<OC0<OC0<O[DE(^#:W@@@[F1,[
F1,[F1,[F1,[F6J@QF*UQ0@@@0LC@0LC@0LC@0LC@8]M V>F^8L@@@0SD1LSD1LSD1LSD1MC[S!!Q]''P@@@@LD1LSD1LSD1LSD1MPW6:MNU(T@@@@CALSD1LS
D1LSD1LS"8)\MUNRE@@@@B0,KB0,KB0,KB0,VTAE#(<1KAP@@@@EK"8.K"8.K"8.K''5XXE9&"R8T@@@@AP<OC0<OC0<OC0=8R303$H OE@@@@@TOC0<OC0<O
C0<OUEH?P%XOC1P@@@@EC0<OC0<OC0<OC5]R%HTOC0<T@@@@F1,[F1,[F1,[F1-[MGD[IAPTE@@@@@T.K"8.K"8.K"8.XT<.K"8.K!!P@@@@EB0<OC0<OC0<O
C6,OC0<OC0<T@@@@AR$OC0<OC0<OC0<OC0<OC0<OE@@@@@(^E0<OC0<OC0<OC0<OC0<OC1P@@@@N@P\*HQ _BQ4#H HVHAXPEBPT@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 106 103 105 108 108 111 21 232 231 3 189 187 226 226 228 104 104 105 109 109 108 21 231 231 82 82 83 213 213 214 187 187 187 133 233 234 21 231 230 90 90 92 186 186 188 108 108 108 135 225 226 138 243 244 2 186 188 85 85 88 133 225 227 107 107 109 182 182 181 107 107 108 19 230 230 0 129 126 102 102 103 0 128 126 85 85 84 180 180 182 101 101 104 105 105 109 111 111 110 84 84 85 88 88 90 96 96 99 0 125 126 2 191 189 0 138 139 97 94 99 193 193 192 110 110 109 19 234 233 5 141 143 95 95 99 254 254 252 2 190 188 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:22;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@A8@@C<@@C<???<???8???8???0???0???0??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? @@@@@@@@');
                            yourself);
                yourself
        ]
!

newFile20x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newFile20x22Icon inspect
     ImageEditor openOnClass:self andSelector:#newFile20x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class newFile20x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
IQTFA XFA XND@ _G2T;IRT%IP@%A"T%IRT%F1\IK0XXN30;IRT%@BTFIRT%IRT[F1,;N2 ;OS,%N3,@IPX%ISL3L2T3N38?N3=@O3,?O#,%A"T%IRT%IRT%
N4EBP4QCP$D;@BTFIRT3L3L%L3L8N3=DMDP?N2T@IPX%IRT%IRT%IRT;O4P4QC<;IP@%A"T%L3L%ISL2N4EBP4QCP$D;@BTFIRT%IRT%GS,>O3,?PC<;O38;
IPX%ISL%L1,%L3,;FC,=N0(;N0@%A"T%IRT%F2T0LP0XN30;DQ$%@BTFIRT%L3LWL3L0CCL3N1XXFRT@IPX%F1,[@20C@2<0F@0 A1XYIP@%A"T"L0$3@SLI
IB<3L3L HA$%@BTFIRD!!HQ\WH0$$K3@SCB GFRT@IPX%HSL3HPD3HSL/K3L''CB@YIP@%A"T!!HRD!!@RDIBR</LB\LHA$%@BTFIRD3L3LAL3LIK3L0L00 FRT@
IPX%HRD!!HQ\!!BP$/LC@0CB@YIP@%A"TWL1\3KCL3L2<0L00(A1$%@BTFISH2L 4MH!!\,BPLRLCDLFRT@IP,YFQ$YFQ$YFQ$YFQ$YFQ$YIP@b');
                colorMapFromArray:#[ 204 208 220 245 246 250 224 227 236 240 242 248 140 145 163 212 215 227 207 211 222 227 230 238 193 197 211 241 243 248 214 218 228 210 214 224 231 233 241 249 250 252 201 206 218 200 204 217 196 200 213 220 223 233 238 240 247 234 236 243 250 251 252 205 209 221 225 228 237 245 247 250 223 226 235 116 120 133 240 241 248 253 254 254 211 214 226 252 252 253 207 210 222 178 183 200 229 231 240 247 248 251 246 248 250 242 244 249 241 242 248 255 255 255 213 217 227 232 234 242 230 232 240 248 249 251 202 207 219 201 205 218 243 245 249 219 222 232 217 220 230 237 239 246 235 237 244 234 237 243 251 252 253 0 0 0 255 248 248 207 216 240 240 240 248 239 232 240 240 240 240 48 88 176 224 224 232 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 ];
                mask:((ImageMask new)
                            width:20;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_?(@_?<@_?= _??0_?? _??@_??@_?? _??0_?? _??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@');
                            yourself);
                yourself
        ]
!

openEditApplicationIcon
    <resource:#programImage>
    ^ self openEditApplication32x32Icon
!

openViewerApplicationIcon
    <resource:#programImage>
    ^ self openViewerApplication32x32Icon

    "Created: / 04-04-2011 / 14:26:20 / cg"
!

reload16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self reload16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#reload16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary reload16x16Icon'
        ifAbsentPut:[(Depth4Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@BQDQ@@@@@@DQRIDQ@@@@DT"Q@ADP@@BP"Q@@@AD@@QRQ@@@@@P@ABID@@@@@@P"H"H$@@@@@DH"H$@@@@@@ABH$@@@@@@@@QD@@@@@@@@@D@@@@@@@@@@
@@@@@@@@A @@@@@@A @@@F@F@@A @@@@@@@@A @@@@@G]7] @@@b') ; colorMapFromArray:#[0 0 0 255 255 255 0 192 0 0 64 0 0 128 0 0 255 0 127 127 127 63 64 63]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'A>@O>A>\O0X>@#8@?9!!?OC9>GO<HOD@<XG09>A?0A>@b') ; yourself); yourself]
!

removeBreakPointBlueIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self removeBreakPointBlueIcon2 inspect
     ImageEditor openOnClass:self andSelector:#removeBreakPointBlueIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary removeBreakPointBlueIcon2'
        ifAbsentPut:[(Depth2Image new) width:12; height:21; bits:(ByteArray fromPackedString:'EUUT_??=_:+=_**=^)V-^%U-^%U-^UU-_%V=_:+=_??=_:+=_%V=^PA-^@@-^@@-^@@-_ B=_:+=_??=EUUT') ; colorMapFromArray:#[158 158 255 63 63 63 0 0 0 127 127 127]; mask:((ImageMask new) width:12; height:21; bits:(ByteArray fromPackedString:'_>C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<G? ') ; yourself); yourself]
!

removeBreakPointIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self removeBreakPointIcon2 inspect
     ImageEditor openOnClass:self andSelector:#removeBreakPointIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary removeBreakPointIcon2'
        ifAbsentPut:[(Depth2Image new) width:12; height:21; bits:(ByteArray fromPackedString:'EUUT_??=_:+=_**=^)V-^%U-^%U-^UU-_%V=_:+=_??=_:+=_%V=^PA-^@@-^@@-^@@-_ B=_:+=_??=EUUT') ; colorMapFromArray:#[0 255 0 63 63 63 0 0 0 127 127 127]; mask:((ImageMask new) width:12; height:21; bits:(ByteArray fromPackedString:'_>C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<G? ') ; yourself); yourself]
!

saveAsMethod19x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveAsMethod19x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#saveAsMethod19x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class saveAsMethod19x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:21;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@5MCP2LB<,JR\$IBL"HQ<]G@@5)ZK43MGV=OS4=OS4=OS4PC4JMJF^=LE(0_S4=LE(0_K%7$@=BCNX%?SAZF#A=LE(ZLG!!
5=L9M@\2%YG40V#AZOQ(0V#A4<7MFQ$GLX2J9<E(<6!!(ZNM(0\_M3Q XA2>D!!N_AZOO3ZOOPZLGM3\4UEP\. G3''0V#3<?O34F#A3\7MEQTGKWY39<E(<?OP
4MA(0\7M3QTUA2)*[>_$:?O34MCP4MCP4M@UEP\)X6K$9NK_6-WP3\7M3\7MEQTFI5)Z8.K_6-SP3\#C0J&&*Q$YAB]UU^B;.[^4,Z>.+Y&H!!Z$XF@L&S$;_
7=+T4L#C0KR&''IN#EQTEI$%I7["5,+B.+Y.H W%4%!!TUA2UBP-+Z5MCH/J&&''INK!!8<UEP\%PDCW-+F+*I&R!!W57\V2NEQTGIS0<$IBM!!(M:]V-%W51YU!!PT
B@@IBP$IB@ HB@ HB@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 28 33 37 34 41 60 37 45 83 39 48 89 42 51 96 45 55 103 49 60 112 54 65 115 54 66 115 54 66 116 57 70 107 57 70 109 59 59 58 65 79 121 65 80 125 66 80 124 68 83 130 74 71 70 77 81 85 78 95 152 80 98 153 81 98 151 83 47 28 85 102 157 86 103 157 88 101 128 90 110 162 94 106 146 94 106 147 95 83 66 95 107 147 96 74 37 97 108 148 98 109 148 98 109 149 99 110 149 101 111 150 101 111 151 101 112 151 102 102 107 102 113 151 102 113 152 103 86 54 103 113 151 103 113 152 103 114 152 104 114 152 105 115 152 105 115 153 106 116 153 107 116 154 107 117 154 108 117 154 116 124 137 123 85 65 123 107 74 125 143 184 126 64 32 126 139 158 126 143 183 127 145 185 128 145 184 129 146 185 129 147 186 130 148 186 131 148 187 131 149 187 132 141 160 133 141 159 133 143 164 134 151 188 134 151 189 134 152 189 135 152 189 136 153 190 137 154 191 138 154 191 139 156 193 141 151 173 142 69 67 142 157 193 142 158 193 143 62 26 143 158 193 143 159 194 144 157 200 144 161 195 145 161 195 146 158 202 146 162 196 147 89 55 147 160 203 147 162 196 148 165 197 149 161 204 149 164 197 150 166 198 150 166 199 151 167 199 152 149 137 152 163 206 152 168 199 153 169 201 154 96 64 154 169 201 154 170 201 155 167 207 155 171 202 156 171 202 156 171 203 157 172 203 157 173 182 157 173 203 159 147 111 159 174 204 159 175 204 160 170 210 160 174 204 160 176 205 162 172 191 162 178 207 163 173 212 163 177 206 164 177 207 164 180 207 165 147 99 165 165 166 165 178 207 166 182 208 167 147 95 167 177 214 167 181 209 169 185 209 170 179 216 170 186 215 171 185 210 172 162 152 172 185 212 172 187 217 173 186 212 174 182 218 174 188 219 175 190 221 176 184 220 176 189 214 176 190 213 176 190 218 177 145 64 177 190 215 179 193 223 180 192 216 181 193 216 181 194 214 181 195 218 182 194 214 182 195 221 183 196 219 184 195 218 184 197 219 185 95 37 185 196 219 185 197 219 185 197 222 186 185 192 187 198 220 187 200 223 188 171 94 188 199 217 192 204 226 194 97 38 195 206 220 196 168 100 196 206 218 198 207 220 202 211 222 203 212 222 205 214 224 207 215 224 208 101 40 209 217 225 210 217 226 210 219 227 212 220 227 213 220 227 214 221 228 217 103 41 217 223 229 217 224 237 219 101 37 222 177 45 222 225 232 223 228 241 224 187 54 225 105 42 226 231 241 226 231 243 228 196 63 230 202 70 230 234 245 230 235 243 232 240 251 233 208 76 233 235 240 233 236 247 233 237 244 233 237 246 235 214 82 235 238 245 236 239 248 237 239 242 238 241 249 239 242 247 240 242 242 240 242 249 240 243 249 242 220 141 242 242 227 242 244 249 242 244 250 244 244 245 244 246 250 244 246 251 245 247 250 246 247 250 246 247 251 247 248 251 247 248 252 248 249 251 248 249 252 249 99 39 249 249 253 250 147 56 250 250 253 251 169 79 251 251 253 251 252 253 252 99 38 252 178 84 252 187 89 252 199 96 252 206 99 252 252 253 252 252 254 253 253 254 ];
                mask:((ImageMask new)
                            width:19;
                            height:21;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_??@??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? _??@@@@@');
                            yourself);
                yourself
        ]
!

searchOverlay2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self searchOverlay2 inspect
     ImageEditor openOnClass:self andSelector:#searchOverlay2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class searchOverlay2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
.[&9S\DQ''C59HRJ9.[&9.[&9.[&9.[&9)4]>.5!!JKM4: BB9.[&9.[&9.[&98RV[X%M,[F1,M;48\+&9.[&9.[&9Q#1PL*<]] ",.F1,(Y*9.[&9.[&9.PBP
FZ?JX@627K!!,NV3^9+&9.[&9.[$8 3JWB3C3#N^8.CQ]]_R9.PB9.[&9_JO2P*,#^>)=.F8K$3[C.[&9.[&9.T?W''Y6K:9%@[ST5MSW"20B9.[&9.[%OO?JB
%4R3Z]P5J^LJ/L @.[&9.[&9EKZ:4%$SRS;GJM"J=V/&@K&9.[&9.Z@*#I5''%T$MI7QW/527N0B9.[&9.[$@^!!BB+9XFPG54U;=EU@@@.[&9.[&9.RA1Z)UB
E+8U)DL-F<-_@K&9.[&9.[$@5.5LE=2>G--%"I:T"Z8/.[&9.[&9@@@@!!MGI2^P[I AK*L6Q]<Z9.[&9@@@@@@@@@@@@@@@@@OFA8M=7U+&9.P@@@@@@@@@@
@@@@@@A&[1+ 76!![.[$@@@@@@@@@@@@@@@@@@JY/''8>1@5:9@@@@@@@@@@@@@@@@@@@@B]$BX]CUX0@@@@@@@@@@@@@@@@@@@@@+3%HN$X\@@@@@@@@@@@@@
@@@@@@@@.Q#D0AH.@@@@@@@@@@@@@@@@@@@@@K&9!!Q#)L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 190 190 203 179 214 235 253 233 159 206 121 14 178 214 234 181 215 227 221 251 253 200 204 216 208 240 250 148 126 112 216 232 238 229 254 254 245 246 250 228 252 253 246 211 132 164 169 187 189 230 251 188 204 227 160 107 51 219 249 254 135 145 175 224 246 249 216 247 251 207 244 252 138 79 26 196 229 251 253 232 155 111 112 138 240 242 248 215 247 253 221 246 249 140 145 163 177 180 196 192 198 214 195 195 207 243 254 254 207 211 222 163 190 225 170 172 189 231 251 252 230 249 251 230 247 251 149 187 221 151 87 25 143 210 248 213 223 231 140 128 133 207 127 27 240 254 254 227 230 238 200 234 251 92 92 122 220 252 254 227 247 251 216 246 250 170 205 228 167 177 202 203 237 247 152 195 230 188 191 206 170 190 218 152 189 230 227 253 254 174 211 235 225 251 252 241 243 248 216 248 253 230 242 247 216 246 253 213 220 227 198 198 209 175 196 226 210 214 224 224 253 254 144 211 248 201 202 215 172 208 226 219 219 226 231 233 241 129 156 197 172 214 249 249 250 252 253 235 160 178 214 235 95 95 124 243 244 246 187 112 26 232 241 245 140 207 247 210 242 253 168 204 225 176 105 25 227 235 240 205 238 248 166 98 25 188 190 205 228 254 254 246 213 133 174 210 234 156 91 25 176 211 226 174 187 201 212 185 159 207 240 253 210 124 15 234 253 253 195 235 251 199 212 222 200 234 246 233 251 252 224 252 253 198 136 46 202 233 238 128 150 182 166 166 183 238 240 247 228 243 247 178 208 221 213 245 252 218 131 16 138 143 162 179 198 222 124 137 168 231 249 253 144 168 204 229 249 251 134 188 237 175 211 231 178 184 201 241 208 124 211 243 253 159 201 235 155 156 175 130 73 25 245 247 250 153 93 31 92 94 123 164 150 144 230 240 245 207 239 252 206 239 251 151 156 174 149 154 172 246 214 135 151 191 230 230 160 50 189 212 221 224 251 252 167 167 183 216 248 254 215 248 253 215 246 253 141 146 164 214 246 252 156 162 182 154 197 236 166 195 228 204 237 252 136 136 159 253 233 158 132 132 155 162 214 237 186 212 221 170 207 235 227 244 248 229 231 240 207 182 159 213 213 221 175 161 154 247 248 251 246 248 250 230 254 254 197 231 248 192 227 243 208 130 31 209 242 253 154 159 176 236 167 55 206 238 250 227 252 254 242 244 249 241 242 248 166 207 237 160 165 185 214 247 251 255 255 255 205 238 252 125 194 246 210 230 237 151 213 245 219 246 249 233 238 243 246 222 150 218 218 225 232 234 242 138 139 163 179 124 48 230 232 240 197 120 26 230 251 253 130 131 155 101 115 143 221 252 254 128 129 153 125 125 150 198 129 40 185 129 47 187 222 237 236 166 54 111 118 146 198 232 251 243 245 249 227 251 253 202 118 14 206 206 216 174 209 234 233 246 249 192 132 47 195 229 238 222 245 248 215 246 251 137 206 247 156 184 203 236 168 57 246 214 136 206 208 219 187 212 220 230 246 249 101 112 139 143 148 167 144 146 168 222 247 251 237 239 246 122 110 120 213 246 252 214 244 253 235 237 244 113 126 154 234 237 243 139 144 163 251 252 253 191 119 39 203 237 252 242 253 254 134 134 158 219 232 238 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'G>@CO? C_?0C??0C??8C??8C??8C??8C??8C??8C??8C_?0C_?8CO?>CC>?C@@_#@@_3@@O;@@G?@@C?@@A?@@@?');
                            yourself);
                yourself
        ]
!

uiPainter19x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter19x26Icon inspect
     ImageEditor openOnClass:self andSelector:#uiPainter19x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class uiPainter19x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:19;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@BX&X%2@@@@@@@@@@@@@@@@@@BT-]7''''7$0N#$2J"D^GA(XEALS''-?C0+.AN&1 UT-GPC /G1,[(:?P/;*\''4I)W$9IQC84JQ4YFZG!!
1,B8#0AJ!!W==_G)7\7E0\GB.5,^<)F<@WIFQ$YFQ$YFQ$YF%8</H.X, @E.Q(JB (JBQ(JB *-3J0Z6FH@AZ$ZBQ$YE_$ZBQ*>WS3K6N$R@@VIF $YFQW9FJ
$Z'' 3<&>"ID @E^Q(IFQ$U>Q(KR76]GD%YFQH@AV$U=_W5=_$U>39-SR1X*Q$R@@UIFQ$YFQ$YF''--;U3YZQ$YD @ENQW5=_W5=_,^#Z5<:PW:2QH@AR$U>(
*J"(*J[$6="]*IF,$R@@TYE_*J"(*J""9>J0 :"Q+ID @EBQW:"(*J"(&>^2 J2($Z2QH@AO$U>,+J2,+GY8!!:2,+IF,$R@@SYE_$YFQ$YE4^9FQ$YFQ+IDJ
@D2QW:2,+J2,$*2,+J2,+J2QH@AL$YFQ$YFQ$YFQ$YFQ$YFQ$R@@SIFQ$YFQ$YFQ$YFQ$YFQ$YD @B]HP34;M34=M20%HB@ HB@ CP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 50 164 0 50 171 1 50 177 2 56 178 3 64 241 3 67 246 3 73 255 4 74 255 5 63 191 7 66 194 10 71 196 10 79 255 12 59 167 12 82 255 14 77 199 18 83 201 19 88 255 21 91 255 23 89 204 27 95 206 28 97 255 29 72 179 30 100 255 32 101 209 36 106 255 36 107 211 39 109 255 41 113 214 45 115 255 45 119 216 48 118 255 50 87 176 50 125 219 51 88 176 51 88 177 52 89 178 52 90 178 53 90 178 53 127 212 54 91 179 54 123 255 54 131 221 55 92 180 55 95 181 56 93 180 56 94 181 57 127 255 57 149 229 58 99 184 58 137 224 61 104 187 63 132 255 63 143 226 64 108 190 66 113 193 66 135 255 67 149 229 68 157 232 69 117 196 71 155 231 72 122 199 72 141 255 75 126 202 75 144 255 75 160 234 77 163 236 78 131 206 80 149 255 81 136 209 84 140 212 84 153 255 87 145 215 88 157 255 91 168 235 93 161 255 94 154 222 96 157 223 96 165 255 97 159 225 98 160 225 98 162 226 99 163 227 100 165 228 101 166 229 101 170 255 102 167 230 103 169 231 104 170 232 104 173 255 105 172 233 105 174 234 106 175 235 109 178 255 112 180 255 116 116 120 117 186 255 119 187 255 122 154 245 125 160 253 125 193 255 126 161 253 126 194 255 127 162 254 130 165 254 132 200 255 132 201 255 135 170 255 139 207 255 140 175 255 144 179 255 145 109 112 149 184 255 153 188 255 155 31 0 157 192 255 160 115 98 160 160 160 161 124 106 162 196 255 163 140 130 166 46 5 166 200 255 169 113 95 170 204 255 174 208 255 177 212 255 181 215 255 182 93 58 183 59 8 185 219 255 186 100 65 188 222 255 191 225 255 192 147 138 193 129 103 193 132 116 195 100 52 195 120 93 197 82 32 204 208 220 205 177 176 207 90 27 210 109 64 210 140 105 212 211 224 213 175 169 213 217 227 215 172 138 220 114 42 222 120 43 222 209 212 223 137 33 223 153 96 225 225 234 226 180 137 228 90 9 228 142 66 232 174 56 234 184 145 237 236 242 240 178 78 241 195 142 241 212 187 242 102 12 242 177 95 245 202 137 245 209 172 245 244 247 247 181 30 247 183 8 247 198 128 247 246 249 248 122 26 248 194 1 248 198 0 248 201 137 248 203 113 248 214 181 249 193 57 249 210 160 250 206 0 253 222 69 253 226 47 254 116 14 254 128 21 254 136 5 254 141 47 254 144 8 254 147 36 254 147 47 254 158 0 254 158 1 254 159 21 254 161 10 254 162 0 254 165 54 254 165 69 254 167 2 254 167 5 254 171 10 254 176 36 254 177 17 254 178 11 254 181 24 254 184 75 254 184 94 254 187 34 254 191 0 254 191 42 254 191 54 254 194 26 254 197 55 254 201 65 254 203 3 254 203 78 254 203 97 254 207 47 254 209 81 254 212 90 254 213 16 254 214 81 254 216 73 254 219 0 254 220 37 254 223 0 254 225 166 254 226 7 254 226 119 254 231 26 254 231 65 254 231 201 254 239 98 ];
                mask:((ImageMask new)
                            width:19;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@O@@@_ ??? ??? ???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@???@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-16x16'!

copy16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copy16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#copy16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copy16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@B\''@ HLB3$@@@@@@@@@@@@''B@ HB@EDN@@@@@@@@@@@@  HB@ S@1,8@@@@@@@@@@0HFA\EK@P1LP47M2D@@@@AB@ RDPXDB@ H
BB8@J@@@GP VI"45K0 HB@ 6A@$ @ALHP3(FAQTHC 8OOP$IL @,P245MQ0^B@ HP0YAB3H@KADEPA<0O  .EC4$I@,+@B0?O3<?O2THBADEPSDAP @@@@@@
@@@JBC4$IBP$GTH@@@@@@@@@MDLKB0,AGQL*@@@@@@@@@C0IBSH2P$H*JP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 48 104 192 160 176 192 176 192 208 192 200 208 176 200 240 208 224 240 224 232 240 246 246 246 255 255 255 48 88 176 96 136 208 160 176 208 176 184 208 160 184 240 144 176 255 208 216 240 245 245 245 240 240 255 255 248 255 144 168 192 112 152 224 160 184 224 160 200 255 176 208 255 192 216 255 244 244 244 250 250 250 96 112 144 112 152 208 160 168 192 144 168 224 192 208 224 197 207 229 210 222 242 243 243 243 249 249 249 80 128 208 112 144 208 144 184 240 176 192 224 197 211 233 32 64 128 32 64 144 32 72 160 144 160 176 128 176 224 128 168 240 160 192 240 192 200 224 176 192 240 32 80 160 248 248 248 80 120 192 112 160 224 112 152 240 144 176 240 211 215 220 216 219 226 240 240 240 247 247 247 64 112 192 96 144 224 128 160 224 48 72 96 208 216 224 192 208 240 32 72 144 240 248 255 96 128 160 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C>@O<@?8C?>O?<??;??/?>??;?? O>@?8C? @@@@@b');
                            yourself);
                yourself
        ]
!

cut16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#cut16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class cut16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@PAT@@@@YO@@@@@@@@@@@@BP;P @\CA\@@@@@@@@@@@@@B$ @A!!,6@@@@@@@@@@@@@CP^M04#M @@@@@@@@@@@@@?N2 ]
D@@@@@@@@@@@@@@@C14[H3(@@@@@@@@@@@@@@@@&H1(*@@@@@@@@@@@@@B8DG0HTL"EJ@@@@@@@@@B8>B0$0QQP1@P@@@@@@@@@V@ALQI1P@MQD@@@@@@@@@
@@@@DP@T@B@E@@@@@@@@@A<@H$,@Q$<XJP@@@@@@@@@=S1D+@D%AC$\@@@@@@@@@@49AL0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 80 136 224 143 161 197 131 159 220 175 190 217 142 170 242 48 64 112 225 233 240 243 243 243 249 249 249 74 97 165 144 152 176 89 135 225 176 176 192 192 200 208 44 67 104 221 221 225 89 89 104 48 80 144 248 248 248 64 104 176 80 120 208 170 177 184 131 170 230 191 197 203 48 64 96 225 225 225 80 104 128 96 112 128 244 248 252 112 128 144 144 144 160 80 128 224 165 176 200 142 167 222 176 188 219 80 96 112 229 232 235 232 234 238 104 120 135 109 131 175 169 175 181 44 44 59 184 190 202 57 78 99 210 218 232 213 221 238 218 226 245 247 247 247 72 100 156 64 104 192 89 127 210 157 167 192 180 180 195 177 192 219 219 219 219 228 228 228 225 230 241 246 246 246 121 126 132 144 152 160 165 171 176 110 142 214 104 150 240 187 192 209 208 208 217 59 67 104 233 234 237 245 245 245 250 250 250 74 119 195 110 143 201 157 171 193 183 193 203 176 191 218 189 202 229 48 80 128 213 222 241 244 244 244 71 106 156 64 96 176 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@FL@]0@7@C<@O @>@A8@_8C? O6@%XB7 O^@<@@@@b');
                            yourself);
                yourself
        ]
!

indent16x16Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self indent16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#indent16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class indent16x16Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MCP4M@@4MCP4MCP4MCP@@@@@@@@@@@@@@@@@@@@@@J2@&@@@@CP4M
CP4MCP4M@BLJJ"HT@@4MCP4MCP4MCPPDB!!0!!A @@@@@@@@@@@@@@G"TFIA<@CP4MCP4M@@@@@B$(I0@@@@4MCP4MCP@@@@@@@@@@@@@@@@@@@@@@@@@@@@4M
CP4@CP4MCP4MCP4M@@@@@@@@@@@@@@@@@@@@@@@@CP4MCP@MCP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4@@@@@@@@@@@@a');
                colorMapFromArray:#[ 248 248 248 84 110 149 144 166 207 121 145 206 80 136 224 64 96 160 48 80 144 96 136 240 247 247 247 80 128 208 80 128 224 143 157 197 64 88 144 0 0 0 250 250 250 80 120 208 246 246 246 226 230 240 244 244 244 153 185 234 224 229 238 213 219 231 249 249 249 235 238 241 245 245 245 228 232 246 243 243 243 152 182 242 64 96 176 238 241 247 213 222 234 185 197 215 86 135 227 48 88 144 144 171 216 209 219 245 72 100 156 64 88 160 202 218 242 209 217 227 97 127 169 97 123 189 64 120 224 89 135 225 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A@@@@O_<@@GG?__?<@G78\_ @@C7?@@@= @@@@P@b');
                            yourself);
                yourself
        ]

    "Created: / 06-04-2011 / 18:38:27 / cg"
!

paste16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self paste16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#paste16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class paste16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@PTEME@@@@@@@@@ASS$9NH10\MS$KI - @@@@S%1]V5!![R1%UN"]HXP@@@D9]WR=BJ@0$ETX+NBH@@@AOWPL0E%UTUFD.
G# ;@@@@F%47P3QEQTT,NC 8GP@@@@@\CU$JKSXOJQ,ASA @@@@@P3<2RR4OIRT3OS0IX0@@V 9"RQ<QJRUPTB(HX5H @BX4RQ<RDQ,3OS1VQ4( A TK@!!<-
D@PAOUAPJ#YQM#YDPD 8NC 8SC1VQ2EQW5<6Q@\0XQM^QA HM#X6M#X6M$P@@@@@@@@IQDQDQDQDQDQD@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 160 152 128 112 128 160 240 200 112 255 240 160 208 152 0 64 64 64 64 72 80 218 214 210 208 224 240 80 104 128 240 208 80 144 136 112 224 216 128 240 224 128 240 216 128 144 152 176 224 168 0 224 160 0 240 168 0 96 80 64 224 221 218 176 152 80 128 112 96 249 249 249 96 112 144 208 200 128 160 160 144 128 136 160 240 232 160 64 56 48 144 112 32 240 184 16 64 80 96 192 200 224 112 88 80 160 144 96 224 200 96 255 255 255 144 136 128 240 192 96 240 232 144 128 144 176 160 168 192 160 128 32 208 152 16 240 176 16 112 88 64 144 136 96 144 128 96 248 248 248 240 200 80 255 248 255 240 208 112 224 216 144 144 160 176 255 232 160 208 144 0 112 104 64 128 96 48 96 72 64 224 232 240 240 240 240 247 247 247 240 216 96 144 128 112 192 176 128 208 200 144 240 224 144 64 48 32 208 160 16 96 88 64 192 208 224 240 184 32 240 192 48 80 88 112 137 130 111 96 120 144 176 160 128 176 168 144 176 160 144 160 176 192 176 192 208 192 200 208 216 213 202 112 104 80 128 112 80 208 216 240 243 243 243 160 152 112 240 216 112 160 144 128 240 240 160 240 240 176 255 240 176 80 64 48 176 184 208 222 220 214 112 96 80 240 200 64 80 96 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@G O?8??#?>O?8??#?>O?<??;??????????0O?@@@b');
                            yourself);
                yourself
        ]
!

redo16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redo16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#redo16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class redo16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@%S@TOP0@@@@@@@@@@@@@PP LCC$(-@@@@@@@@@@@FFPD<L#L+R"8@@C\@@@@@FB@IG$\@EC9JID,M@@@@@CXAD3$@MP(J
O0HWE @@@@@6@P@@@@@#OPIICC8@@@@@PR(@@@@@@C8WCB$4@@@@@C  @@@@@DP(Q @3G0@@@@@@RQ<,@@@@@@@@@@@@@@@@@D@ EP@@@@@@@@@@@@@@@@@@
RB@D@@@@@@@@@@@@@@@@@BHKHD4@@@@@@@@@@@@@@@@@@BDZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 64 104 192 74 127 225 112 160 240 142 177 241 176 194 231 170 192 241 184 198 241 226 232 244 246 246 246 64 96 160 64 96 176 80 120 208 80 128 240 128 168 240 156 184 241 170 194 242 180 195 240 217 225 245 240 242 248 59 97 165 64 112 192 97 130 201 112 152 224 112 152 240 170 198 241 165 187 240 188 206 242 231 234 239 242 243 246 250 250 250 86 128 184 64 120 224 80 136 240 153 181 225 183 195 223 197 209 229 188 208 244 208 217 244 239 241 247 249 249 249 48 88 176 48 112 224 89 135 225 105 150 240 193 203 221 169 194 242 183 203 243 222 228 238 244 244 244 245 245 245 64 104 176 64 112 208 80 128 224 160 181 216 157 187 241 144 168 240 187 205 236 226 232 238 243 243 243 248 248 248 59 105 180 109 126 176 96 144 224 104 150 240 173 194 229 165 192 242 170 191 241 210 225 246 48 80 144 247 247 247 48 96 176 97 133 194 89 127 210 96 144 240 144 176 240 176 202 241 182 206 242 203 213 239 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O A?@O>P??C7<NO08_C#<G@@\@@8@C0@C@@@@@@@b');
                            yourself);
                yourself
        ]
!

stop16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stop16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#stop16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class stop16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@CT1"PQ$B1<5@@@@@@@@](\5IU]WU5\%\&-6@@@@]%8&B#>L#H2LO0(9JGX@@E8A]$RASRP$SXED]''-"@CUR^XBHKR@ZF"@-WQXQ_#T3L")CR"4-W5<-
KQMZL@A3FU-1HQT<KTA@KQ +]G=*A1-''XGT#I0X-KX9:_49NCFX\JV4P#2)@KR5@\D9NS 0MR8P,KC -KTUEKR5/C@1XY''"DVEL-KV1LSF0-KXMX!!C45VW\W
K70H!!HPH_B<W]5@5@F-(_V$T!!W5=!!QQ)_X,^@@A6C695Y84WE85'']XXB] @@@GX:M0!!GQ4]GBDH]] @@@@@@@CTNUC9FXUX5@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 253 28 28 232 83 83 125 1 1 191 0 0 204 16 16 114 0 0 254 236 236 171 0 0 254 65 65 151 0 0 254 216 216 201 16 16 245 0 0 168 0 0 176 21 21 159 1 1 254 12 12 254 150 150 128 0 0 254 242 242 254 71 71 254 117 117 254 163 163 254 38 38 253 231 231 206 4 4 254 130 130 204 2 2 202 0 0 127 2 2 125 0 0 197 18 18 254 189 189 254 64 64 162 0 0 254 31 31 254 169 169 254 215 215 233 99 99 254 90 90 159 0 0 254 11 11 254 103 103 245 58 58 253 0 0 254 254 254 156 0 0 254 221 221 247 53 53 208 18 18 254 96 96 207 7 7 153 0 0 232 107 107 190 0 0 220 36 36 254 89 89 224 99 99 152 2 2 150 0 0 254 240 240 167 0 0 175 21 21 254 207 207 254 253 253 147 0 0 214 36 36 254 141 141 254 187 187 254 233 233 172 21 21 254 62 62 146 2 2 144 0 0 254 246 246 201 0 0 253 51 51 254 167 167 238 0 0 161 0 0 211 3 3 141 0 0 231 62 62 253 77 77 177 22 22 158 0 0 166 21 21 254 206 206 252 0 0 225 3 3 251 114 114 254 61 61 155 0 0 254 245 245 192 0 0 254 166 166 254 41 41 171 22 22 152 0 0 189 0 0 202 16 16 112 0 0 169 0 0 254 34 34 226 13 13 254 47 47 243 0 0 166 0 0 254 231 231 254 14 14 224 24 24 248 87 87 246 85 85 254 73 73 225 107 107 174 1 1 240 0 0 254 40 40 254 178 178 254 7 7 200 0 0 254 145 145 243 52 52 221 83 83 254 237 237 254 20 20 218 57 57 237 0 0 254 158 158 254 204 204 140 0 0 252 77 77 254 0 0 254 13 13 215 24 24 194 0 0 254 243 243 207 16 16 117 0 0 214 13 13 254 210 210 254 39 39 253 232 232 254 6 6 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'C?@??G?>_?;?????????????????????_?9??#?<C?@b');
                            yourself);
                yourself
        ]
!

tabAdd16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self tabAdd16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#tabAdd16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class tabAdd16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
QTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTTGR$)JA4)J
R$)JR$)JQTTGR$PWA4)DE1$FS!!89R$TGBTQDA0%DQDM8^BDLB$(GQDQDA4QD^G @^G !!^G!!JA1@VE \P^G]5^G]7^GU7^@\[E$PGF1Y8\7Y4]GY3^D(GMP<N
A3TOC''!!5^W%5^GEJA2MPOP\#TG!!3]''Q4]''M8R \=N08GOW!!7]W!!7]7!!5]7 GC"!!TA08(^G V^G 4^G!!JA0\GA0\GA0]J\''!!8R$)JR @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 218 221 227 252 102 76 239 157 162 250 154 143 255 219 207 234 236 239 232 234 237 112 122 139 219 205 211 181 188 200 251 251 252 250 206 195 247 247 248 255 87 55 199 205 214 197 203 212 196 201 211 255 72 45 50 55 61 253 196 181 238 239 242 255 193 173 212 216 223 210 214 221 233 164 161 227 229 234 255 172 146 171 179 192 254 71 43 243 150 154 245 246 248 244 222 224 247 99 102 243 244 246 246 160 160 188 194 205 255 66 37 237 191 187 243 137 127 249 200 192 202 207 215 255 131 99 246 107 110 251 141 118 255 7 7 254 223 213 221 224 230 254 9 9 254 107 81 238 152 141 237 239 242 235 237 240 233 235 238 178 185 197 249 188 181 253 120 96 250 139 126 250 250 251 200 206 215 196 202 211 245 235 236 194 200 209 255 233 226 241 211 209 254 12 8 254 71 44 241 240 245 215 219 226 213 217 224 255 255 255 229 232 236 254 118 86 255 160 133 252 102 84 176 184 197 255 46 21 254 96 66 244 245 247 242 243 245 253 47 32 191 197 208 247 112 105 255 67 37 248 208 201 205 210 218 246 244 245 243 240 242 253 102 74 246 135 123 0 0 0 0 0 5 0 0 152 0 0 196 0 0 3 0 0 160 0 0 200 0 0 133 0 0 136 0 0 48 0 0 20 0 0 74 0 0 72 0 0 10 0 0 1 0 0 232 0 0 149 0 0 8 0 0 26 0 0 144 0 0 27 0 0 24 0 0 14 0 0 172 244 244 246 153 153 153 255 255 93 255 255 182 255 198 0 255 255 140 255 255 26 255 149 0 255 255 204 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@A??O?=???????????????????????<b');
                            yourself);
                yourself
        ]
!

tabRemove16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self tabRemove16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#tabRemove16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class tabRemove16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
QTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTTGR$)JA4)J
R$)JR$)JQTTGR$PWA4)DE1$FS!!89R$TGBTQDA0%DQDMFARDLB$(GQDQDA4QDQC8DA#L!!ISDHA1@VE \PE!!XUF!!LTO0D\F@\[E$PGF1YDKT )J5]AI$(GMP<N
A3TOC$PKQ05RVEUJA2MPOP\#TC4:T40$R5EVR \=N08GOS,NI3@QRT=@HD(GC"!!TA08(UC]RNA<"KB<BA0\GA0\GA0\6@30GP!!4*QP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 218 221 227 252 102 76 239 157 162 250 154 143 255 219 207 234 236 239 232 234 237 112 122 139 219 205 211 181 188 200 251 251 252 250 206 195 247 247 248 255 87 55 199 205 214 197 203 212 196 201 211 255 72 45 50 55 61 253 196 181 238 239 242 255 193 173 212 216 223 210 214 221 233 164 161 227 229 234 255 172 146 171 179 192 254 71 43 243 150 154 245 246 248 244 222 224 247 99 102 243 244 246 246 160 160 188 194 205 255 66 37 237 191 187 243 137 127 249 200 192 202 207 215 255 131 99 246 107 110 251 141 118 255 7 7 254 223 213 221 224 230 254 9 9 254 107 81 238 152 141 237 239 242 235 237 240 233 235 238 178 185 197 249 188 181 253 120 96 250 139 126 250 250 251 200 206 215 196 202 211 245 235 236 194 200 209 255 233 226 241 211 209 254 12 8 254 71 44 241 240 245 215 219 226 213 217 224 255 255 255 229 232 236 254 118 86 255 160 133 252 102 84 176 184 197 255 46 21 254 96 66 244 245 247 242 243 245 253 47 32 191 197 208 247 112 105 255 67 37 248 208 201 205 210 218 246 244 245 243 240 242 253 102 74 246 135 123 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@A??O?=???????????????????????<b');
                            yourself);
                yourself
        ]
!

undent16x16Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self undent16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#undent16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class undent16x16Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MCP4M@@4MCP4MCP4MCP@@@@@@@@@@@@@@@@@@@@@@@A4S@0@@CP4M
CP4MCP4MFQ,GBQP@@@4MCP4MCP4MCPPJC10LA @@@@@@@@@@@@@Q@ TFEP@@CP4MCP4M@@@@@@@WB0D@@@4MCP4MCP@@@@@@@@@@@@@@@@@@@@@@@@@@@@4M
CP4@CP4MCP4MCP4M@@@@@@@@@@@@@@@@@@@@@@@@CP4MCP@MCP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4@@@@@@@@@@@@a');
                colorMapFromArray:#[ 248 248 248 84 110 149 144 166 207 121 145 206 80 136 224 64 96 160 48 80 144 96 136 240 247 247 247 80 128 208 80 128 224 143 157 197 64 88 144 0 0 0 250 250 250 80 120 208 246 246 246 226 230 240 244 244 244 153 185 234 224 229 238 213 219 231 249 249 249 235 238 241 245 245 245 228 232 246 243 243 243 152 182 242 64 96 176 238 241 247 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A@@@@O_<@@C''?>_?<@O''8N_ @@C7?@@@= @@@@P@b');
                            yourself);
                yourself
        ]

    "Created: / 06-04-2011 / 18:38:35 / cg"
!

undo16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self undo16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#undo16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class undo16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ACC0ULIP@@@@@@@@@@@@@-R 8C@4HP@@@@@@@7@@@.R",3L#0AFPX@@@@@CT,$R#8T@D\^BR@X@@@@@AXW@#<JB#T@
NQLAM @@@@@>CD$BORL@@@@@@SX@@@@@MB$LE38@@@@@@B)A@@@@@A<3@DX(Q@@@@@@ N@@@@@@@@@@@@@@@@B0_RP@@@@@@@@@@@@@@@@@UHD@@@@@@@@@@
@@@@@@@DHD @@@@@@@@@@@@@@@AMH@,"@@@@@@@@@@@@@@@@F"D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 64 104 192 74 127 225 112 160 240 142 177 241 176 194 231 170 192 241 184 198 241 226 232 244 246 246 246 64 96 160 64 96 176 80 120 208 80 128 240 128 168 240 156 184 241 170 194 242 180 195 240 217 225 245 240 242 248 59 97 165 64 112 192 97 130 201 112 152 224 112 152 240 170 198 241 165 187 240 188 206 242 231 234 239 242 243 246 250 250 250 86 128 184 64 120 224 80 136 240 153 181 225 183 195 223 197 209 229 188 208 244 208 217 244 239 241 247 249 249 249 48 88 176 48 112 224 89 135 225 105 150 240 193 203 221 169 194 242 183 203 243 222 228 238 244 244 244 245 245 245 64 104 176 64 112 208 80 128 224 160 181 216 157 187 241 144 168 240 187 205 236 226 232 238 243 243 243 248 248 248 59 105 180 109 126 176 96 144 224 104 150 240 173 194 229 165 192 242 170 191 241 210 225 246 48 80 144 247 247 247 48 96 176 97 133 194 89 127 210 96 144 240 144 176 240 176 202 241 182 206 242 203 213 239 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A<@O8I?0??C><O10>GC<\@C @N@A0@O@@0@@@@@@b');
                            yourself);
                yourself
        ]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-20x22'!

copy20x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copy20x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copy20x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copy20x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
EQTUEQTUEQTUEQTTGQ4]GQ4]GQ4UGQ4]DPPDABX&I!!P]GQ4]GQ4]GQT]GQ4IB0P&I"X_EA4]GQ4]GQ4]EQ4]GP$QABX&I!!<TGQ4]GQ4]GQ4UGQ4]C1DEI!!<_
G1P]GQ4]GQ4]GQT]GPPDA@P&I"X_EA4]GQ4]GQ4]EQ4]B0,DABXUEQTUEQTUEQTUEQPUGQ4QDP,DD!!T]GQ4QA@PDI"X&EAT]D1DQDPPJEQ4]GP$KABX&I!!<T
EQ4]DQ([C!!@UGQ4]BQDDI"X&G1PUGP<LAPX&C!!T]GQ4ODPT&G1<_EAT]@BHEA"XNEQ4]A@PDABX&I!!<TEQ4DH TZF08UGQ4KB0PDABX&I!!PUGRHYF XBC!!T]
GQDQB0P&I"X&EATIH"HEA"XNEQ4SDQDQABX&I"XTEAPTEAPTEAPUGQ4QF!!DEI!!<&I!!P]GQ4]GQ4]GQT]C00EA"XNG2@REA4]GQ4]GQ4]EQ4@H TFI 8(B DT
GQ4]GQ4]GQ4UGPP"AQ([C" J@QP]GQ4]GQ4]GQT]H!!$ZA HNG0(AEA4]GQ4]GQ4]EP$"H TFI 8(B DTGQ4]GQ4]GQ4TEAPTEAPTEAPTEAPb');
                colorMapFromArray:#[ 250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 ];
                mask:((ImageMask new)
                            width:20;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'??@@??@@??@@??@@??@@??@@???0???0???0???0???0???0???0???0???0???0@O?0@O?0@O?0@O?0@O?0@O?0');
                            yourself);
                yourself
        ]
!

copyFile20x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyFile20x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copyFile20x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copyFile20x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
EQTUEQTUEQTTGQ4]GQ4]GQ4]GQ4UGQ4]DPP''I!!TTGQ4]GQ4]GQ4]GQT]GQ4IB0H&EQ8TGQ4]GQ4]GQ4]EQ4]GP$QA"XTEAPTGQ4]GQ4]GQ4UGQ4]C1DEI!!<\
HQP]GQ4]GQ4]GQT]GQ4SBQ$[IQXWEA4]GQ4]GQ4]EQ4]GQ4IH"XUEQTUEQTUEQP]GQ4UGQ4SDPP(D!!T]GQ4QAB\&EQP]GQT]D0<XF1<JEQ4]GP$K@"XUG!!P]
EQ4]DQ([C!!@UGQ4]BQDFI!!PTEAPUGP<LAPX&C!!T]GQ4ODPT&G10!!EAT]@BHEA"XNEQ4]GQLIFQ,%E!!\TEQ4DH TZF08UGQ4]GP$"I LHEQPUGRHYF XBC!!T]
GQLQAB RI@4GEATIH"HEA"XNEQ4SC1 [G0(RH2PTEAPTEAPTEAPUGQ4QF!!,ND@(AD!!P]GQ4]GQ4]GQT]C00EA"XNG2@REA4]GQ4]GQ4]EQ4@H TFI 8(B DT
GQ4]GQ4]GQ4UGPP"AQ([C" J@QP]GQ4]GQ4]GQT]H!!$ZA HNG0(AEA4]GQ4]GQ4]EP$"H TFI 8(B DTGQ4]GQ4]GQ4TEAPTEAPTEAPTEAPb');
                colorMapFromArray:#[ 250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 ];
                mask:((ImageMask new)
                            width:20;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'?8@@?<@@?>@@??@@??@@??@@??>@???@??? ???0???0???0???0???0???0???0@O?0@O?0@O?0@O?0@O?0@O?0');
                            yourself);
                yourself
        ]
!

copyItem20x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyItem20x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copyItem20x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copyItem20x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@]7]7]7]7\@@@@GUUUUUUT7@@@@A5QDQDQDY0@@@@]TQDQDQF\@@@@GUDQD]7]7]7]7]5QDQGDQDQDQD7
]TQDQ1L3L3L3I7M&Y&\SL3L3L2]7]7]7D3L3L3L'']7]7]1L3L3L3I7]7]7\SL3L3L2]7]7]7L"H"H"H''@@@@A7]7]7]7]0@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 0 184 184 16 228 224 0 128 120 64 64 64 ];
                mask:((ImageMask new)
                            width:20;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@?? @?? @?? @?? @???0???0???0???0???0@_?0@_?0@_?0@_?0@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

copyWidget20x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self copyWidget20x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copyWidget20x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary copyWidget20x22Icon'
        ifAbsentPut:[(Depth4Image width:20 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@L3L3L3L @@@@@CH"H"H"D@@@@@@2H"H"H!!@@@@@@L"H"H"HP@@@@@CH"H"H"D@@@@@@2H"H"H!!@@@@@@L"H"@@@@@@@@@CH"H L3L3L3LJ
@2H"HCH"H"H"D@L"H"@2H"H"H!!@CH"H L"H"H"HP@2H"HCH"H"H"D@HQDQ@2H"H"H!!@@@@@@L"H"H"HP@@@@@CH"H"H"D@@@@@@2H"H"H!!@@@@@@L"H"H"HP
@@@@@CH"H"H"D@@@@@@2H"H"H!!@@@@@@HQDQDQDP@@@@@@@@@@@@@@@a') colorMapFromArray:#[0 0 0 127 127 127 170 170 170 255 255 255] mask:((ImageMask width:20 height:22) bits:(ByteArray fromPackedString:'?? @?? @?? @?? @?? @?? @?? @???0???0???0???0???0???0???0???0@_?0@_?0@_?0@_?0@_?0@_?0@_?0'); yourself); yourself]
!

copyWidget20x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyWidget20x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#copyWidget20x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copyWidget20x22Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
]7]7]7]7\@@@@GUUUUUUT7@@@@A5QDQDQDY0@@@@]TQDQDQF\@@@@GUDQDQDQ''@@@@A5QDQDQDY0@@@@]TQDQDQF\@@@@GUDQD]7]7]7]7]5QDQGDQDQDQD7
]TQDQ1L3L3L3I7UDQD\SL3L3L2]5QDQGD3L3L3L'']TQDQ1L3L3L3I7M&Y&\SL3L3L2]7]7]7D3L3L3L''@@@@A1L3L3L3I0@@@@\SL3L3L2\@@@@GD3L3L3L''
@@@@A1L3L3L3I0@@@@\SL3L3L2\@@@@GL"H"H"H''@@@@A7]7]7]7]0@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 0 184 184 16 228 224 0 128 120 64 64 64 ];
                mask:((ImageMask new)
                            width:20;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'?? @?? @?? @?? @?? @?? @?? @???0???0???0???0???0???0???0???0@_?0@_?0@_?0@_?0@_?0@_?0@_?0');
                            yourself);
                yourself
        ]
!

fileContents20x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileContents20x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileContents20x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileContents20x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
IQTFA XFA XND@ _G2T%IRT%IP@%A"T%IRT%F1\IK0XXG2T%IRT%@BTFIRT%IRT[F1,[A" LG2T%IRT@IPX%ISL3L2T3L3LF@3HQG2T%IP@%A"T%IRT%IRT%
IPX)IRHLG2T%@BTFIRT3L3L%L3L3A@PDA@PDABT@IPX%IRT%IRT%IRTRKR4&J0<YIP@%A"T%L3L%ISL2L0$3L3L@J!!$%@BTFIRT%IRT%GQPWCA -I T\FRT@
IPX%ISL%L1,%L3L FCL3K (YIP@%A"T%IRT%F2T0LP0XA0HXDQ$%@BTFIRT%L3LWL3L0CCL3E!!XXFRT@IPX%F1,[@20C@2<0F@0 A1XYIP@%A"T"L0$3@SLI
IB<3L3L HA$%@BTFIRD!!HQ\WH0$$K3@SCB GFRT@IPX%HSL3HPD3HSL/K3L''CB@YIP@%A"T!!HRD!!@RDIBR</LB\LHA$%@BTFIRD3L3LAL3LIK3L0L00 FRT@
IPX%HRD!!HQ\!!BP$/LC@0CB@YIP@%A"TWL1\3KCL3L2<0L00(A1$%@BTFISH2L 4MH!!\,BPLRLCDLFRT@IP,YFQ$YFQ$YFQ$YFQ$YFQ$YIP@b');
                colorMapFromArray:#[ 204 208 220 245 246 250 224 227 236 240 242 248 140 145 163 212 215 227 207 211 222 227 230 238 193 197 211 241 243 248 214 218 228 210 214 224 231 233 241 249 250 252 201 206 218 200 204 217 196 200 213 220 223 233 238 240 247 234 236 243 250 251 252 205 209 221 225 228 237 245 247 250 223 226 235 116 120 133 240 241 248 253 254 254 211 214 226 252 252 253 207 210 222 178 183 200 229 231 240 247 248 251 246 248 250 242 244 249 241 242 248 255 255 255 213 217 227 232 234 242 230 232 240 248 249 251 202 207 219 201 205 218 243 245 249 219 222 232 217 220 230 237 239 246 235 237 244 234 237 243 251 252 253 0 0 0 ];
                mask:((ImageMask new)
                            width:20;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_? @_?0@_?8@_?<@_?>@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@_??@');
                            yourself);
                yourself
        ]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-22x22'!

addBuffer22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addBuffer22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#addBuffer22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class addBuffer22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@FX@@@@@@@@:NC(:OC0<O#8JJB (JFY''Y" (JB :MST5M#X8NC(:J@A&Y A&ZFYGY&X(NCT5M#X7NC$:N2!!&ZV)&Z&-*Y&))Y#!!G
T%IRT%IRMVT(@FY,[V9/[&5,Y$T(JB (JB (JB (J@AKY&)/@F=*Y$!!IJ@@@@@@@@@@@@@@@@FY*[0A/Z&YJRR @@@@@@@@@@@@@@FY,[V9/[&5,Y$0(@@@@
@@@@@@@@@FY)Z&Y*Z6)&Z&%&J@@@@@@@@@@@@@@@Y&X@Y&!!&R6Y&SB @@@@@@@@@@@@@@@@@Q6Y''Y$)JS$0(@@@@@@@@@@@@@@@@Q4]KY$)JR$9LJ@@@@@@@
@@@@@@@@Q4]KR4)JR$)NSB @@@@@@@@@@@@@Q4]KR4)JR$)JTED(@@@@@@@@@@@@Q4]KR4)JR$)JT%AQJ@@@@@@@@@@@Q4]KR4)JR$)JT$9STR @@@@@@@@@
Q4]KR4)JR$)JT$9NT5D(@@@@@@@@Q4]GR4)JR$)JT$9NS%MQJ@@@Q4-KR4)JR%]NS$9NTEAST5MXTU%ZV5-\WU9_W6A!!X$1LTUEQTUEQTVL@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 239 232 232 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 0 0 0 207 216 240 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@BC_???????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

addBuffer22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addBuffer22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#addBuffer22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class addBuffer22x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:NC(:OC0<O#8JWE1\WE1\WE1\WB :MST5M#X8NC(:WI6]''YY7^IB!!!!W4(NCT5M#X7NC$:N52]'']N-^IB!!!!Y*TJC!!G
T%IRT%IRMVU\''[_ 5^"P(XVZ%DU\WE1\WE1\WE1\WI7A2Z+G^IB!!!!W6IW@@@@@@@@@@@@I6]6*/W19B!!!!Y*T%U0@@@@@@@@@@@B]''^&(.[56(XU3)H)\@@@@
@@@@@NJ.2L#Z6LR=2;GL$7>%W@@@@@@@@KC^6<[E/>^9*+Z>/NVA"50@@@@@@@B4.MK@2\&99L;\.-?P%8A\@@@@@@@@@M6=/[7!!*+N13L+T''GB^W@@@@@@@
@@@@@JBD3[.>0*M>''GY1#U0@@@@@@@@@@@A2''^N>+=E6(XVN!!(I\@@@@@@@@@@@@&WKC-]?O''GZN)(^BW@@@@@@@@@@@Q7I;9-Z,6WZN)(M< %0@@@@@@@@@
Q4]2''Y6),''!!6(XVX&8I\@@@@@@@@Q4]G(*NH''GZN)(NX^''RBW@@@Q4-KR4)JR(2_$W&R!!(]<&7Q5 %%ZV5-\WU9_W6A!!X$1LTUEQTUEQTVL@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 239 232 232 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 0 0 0 207 216 240 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 227 227 236 225 225 234 244 244 249 242 242 247 218 217 230 212 211 224 234 234 242 253 253 254 251 251 252 227 226 235 226 226 237 243 243 247 220 220 231 240 239 244 237 237 244 233 233 240 52 89 178 231 231 238 50 87 176 229 229 239 248 248 251 246 246 249 223 223 233 222 221 232 238 238 244 56 94 181 55 92 180 53 90 178 233 232 239 51 88 176 232 232 241 251 251 253 249 249 251 228 228 237 225 224 234 241 241 246 238 237 243 56 93 180 254 254 255 229 229 237 227 227 238 246 246 250 244 244 248 219 219 230 236 236 243 255 255 255 51 88 177 231 230 238 249 249 252 247 247 250 241 241 247 239 239 245 236 235 242 54 91 179 231 231 240 176 175 128 176 240 159 143 159 128 127 208 96 175 239 144 15 79 0 160 176 95 0 160 0 64 176 48 112 159 95 0 96 0 144 159 143 96 207 80 127 159 111 63 175 48 96 207 79 80 176 64 31 159 31 143 224 112 64 176 63 95 207 79 63 160 47 0 127 0 80 191 64 176 240 144 143 239 112 15 160 15 16 95 16 0 80 0 143 224 111 191 240 159 175 240 144 15 127 15 0 175 0 144 239 127 0 79 0 0 112 0 0 95 0 15 112 15 111 207 80 16 79 16 15 79 15 16 80 16 128 223 111 159 159 63 15 64 15 31 144 16 16 80 15 128 224 111 176 239 159 95 112 80 15 175 15 144 224 127 95 192 79 31 95 15 32 160 31 48 159 47 32 159 31 15 128 15 95 160 47 0 111 0 127 223 96 15 80 0 64 112 63 159 239 127 95 159 79 16 175 16 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C_???????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

addBuffer22x22Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addBuffer22x22Icon3 inspect
     ImageEditor openOnClass:self andSelector:#addBuffer22x22Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class addBuffer22x22Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@B78MW(@@@@@@@:NC(:OC0<O#8JWE1\0\&*151\WB :MST5M#X8NC(:WI6]'']*+5<^!!!!W4(NCT5M#X7NC$:N52]''Y7)*K&=!!Y*TJC!!G
T%IRT%IRMVW"+,#H6-#D/\.13L1\WE1\WE1\WE1\7-/F1[?''.Z*6/+3%W@@@@@@@@@@@@K#R0L''I.^SN7K+_4E0@@@@@@@@@@@C]/[6=8Z*3,\3J5MQ\@@@@
@@@@@@@@@@@@@L6;/,J&''W>%W@@@@@@@@I6]''Y6]''Y7#/*?Q''ZZA"50@@@@@@@B]''Y6]''Y6]0;W_396&%8A\@@@@@@@@''Y6]''Y6]''^[V+M&&)''B^W@@@@@@@
@@@@@JBD!!HRD!!JM>''GY1#U0@@@@@@@@@@@A2''WY6]''Y6(XVN!!(I\@@@@@@@@@@@@&ZY2\''I2)''ZN)(^BW@@@@@@@@@@@Q7J&^:Z&)*ZN)(M< %0@@@@@@@@@
Q4]2\''I2)''I6)(VX&8I\@@@@@@@@Q4]G(*NH''GY6)(NX^''RBW@@@Q4-KR4)JR(2_$W&R!!(]<&7Q5 %%ZV5-\WU9_W6A!!X$1LTUEQTUEQTVL@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 239 232 232 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 0 0 0 207 216 240 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 227 227 236 225 225 234 244 244 249 242 242 247 218 217 230 212 211 224 234 234 242 253 253 254 251 251 252 227 226 235 226 226 237 243 243 247 220 220 231 240 239 244 237 237 244 233 233 240 52 89 178 231 231 238 50 87 176 229 229 239 248 248 251 246 246 249 223 223 233 222 221 232 238 238 244 56 94 181 55 92 180 53 90 178 233 232 239 51 88 176 232 232 241 251 251 253 249 249 251 228 228 237 225 224 234 241 241 246 238 237 243 56 93 180 254 254 255 229 229 237 227 227 238 246 246 250 244 244 248 219 219 230 236 236 243 255 255 255 51 88 177 231 230 238 249 249 252 247 247 250 241 241 247 239 239 245 236 235 242 54 91 179 231 231 240 176 175 128 176 240 159 143 159 128 127 208 96 175 239 144 15 79 0 160 176 95 0 160 0 64 176 48 112 159 95 0 96 0 144 159 143 96 207 80 127 159 111 63 175 48 96 207 79 80 176 64 31 159 31 143 224 112 64 176 63 95 207 79 63 160 47 0 127 0 80 191 64 176 240 144 143 239 112 15 160 15 16 95 16 0 80 0 143 224 111 191 240 159 175 240 144 15 127 15 0 175 0 144 239 127 0 79 0 0 112 0 0 95 0 15 112 15 111 207 80 16 79 16 15 79 15 16 80 16 128 223 111 159 159 63 15 64 15 31 144 16 16 80 15 128 224 111 176 239 159 95 112 80 15 175 15 144 224 127 95 192 79 31 95 15 32 160 31 48 159 47 32 159 31 15 128 15 95 160 47 0 111 0 127 223 96 15 80 0 64 112 63 159 239 127 95 159 79 16 175 16 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@OC_???????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

bufferedView22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bufferedView22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#bufferedView22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class bufferedView22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:NC(:OC0<O#8JJB (JB (JB (JB :MST5M#X8NC(:JI6]''YY7^IB!!!!W4(NCT5M#X7NC$:N2"]''YY7^IB!!!!Y*TJC!!G
T%IRT%IRMVT(''Y6V]7"P(XVZ%DT(JB (JB (JB (JI6]''YY7^IB!!!!W6IJ@@@@@@@@@@@@I6]''YY7^IB!!!!Y*T%R @@@@@@@@@@@B]''Y6S]7!!6(XU3)H((@@@@
@@@@@@@@''YY7#9B!!!!Y)3$7>%J@@@@@@@@@@@@IZ]#9BD!!Y);$:NA"2 @@@@@@@@@@@A2''Y6S^G!!6(XU>%8@(@@@@@@@@@@@@#:BD!!Y);$:M>''GB^J@@@@@@@
@@@@@JBD&Y);$:M>''GY1#R @@@@@@@@@@@A2''Y6S]7!!6(XVN!!(H(@@@@@@@@@@@@&WJ]$:NH''GZN)(^BJ@@@@@@@@@@@Q7I;$:NH''GZN)(M< " @@@@@@@@@
Q4]2''Y6]^G!!6(XVX&8H(@@@@@@@@Q4]G(*NH''GZN)(NX^''RBJ@@@Q4-KR4)JR(2_$W&R!!(]<&7Q5 %%ZV5-\WU9_W6A!!X$1LTUEQTUEQTVL@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 239 232 232 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 0 0 0 207 216 240 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 227 227 236 225 225 234 244 244 249 242 242 247 218 217 230 212 211 224 234 234 242 253 253 254 251 251 252 227 226 235 226 226 237 243 243 247 220 220 231 240 239 244 237 237 244 233 233 240 52 89 178 231 231 238 50 87 176 229 229 239 248 248 251 246 246 249 223 223 233 222 221 232 238 238 244 56 94 181 55 92 180 53 90 178 233 232 239 51 88 176 232 232 241 251 251 253 249 249 251 228 228 237 225 224 234 241 241 246 238 237 243 56 93 180 254 254 255 229 229 237 227 227 238 246 246 250 244 244 248 219 219 230 236 236 243 255 255 255 51 88 177 231 230 238 249 249 252 247 247 250 241 241 247 239 239 245 236 235 242 54 91 179 231 231 240 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C_???????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

changesBrowser22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self changesBrowser22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#changesBrowser22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class changesBrowser22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(JB (JB (JB (JB\@@@@@
@@@@@@@@JA4]GQDDA@PDAAT''@@@@@@@@@@@(JB (JB (JB (JB\^I0@@@@@@@@@@JA4]GQDDA@PDAAT''GB\@@@@@@@@(JB (JB (JB (JB\^I2D''@@@@@@@@
JA4]GQDDA@PDAAT''GB\WI0@@@@@(JB (JB (JB (JB\^I2D''ER\@@@@@JA4]GQDDA@PDAA8''GB\WI2P''@@@@@B ]I2\''DR\K@ H^I2D''ER\''I0@@@@@(GQ4]
BQDQDPX_GB\WI2P''EAP@@@@@JA4''GR\QI2X_GBD''ER\''I0@@@@@@@B ]GQ4SBQ$YIQXWI2P''EAP@@@@@@@@(GR\''I2H''@0LHER\''I0@@@@@@@@@@JA4SC1,[
G0(RH2P''EAP@@@@@@@@@@B\''I2\''I2\''I2\''I0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 78 78 91 127 127 127]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@O?0@O?0@??0@??0C??0C??0O??0O??0O??0O??@O??@O?<@O?<@O?0@O?0@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

copy22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self copy22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copy22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class copy22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GQTUEQTUEQTUEQTUEA4]GQ4]GQ4]GQ4UGQ4]DPPDABX&I!!P]GQ4]GQ4]GQ4]EQ4]GP$KABX&I!!<TGQ4]GQ4]GQ4]GQT]GQ4IDPP&I"X_EA4]GQ4]GQ4]GQ4U
GQ4]C1DEI!!<_G1P]GQ4]GQ4]GQ4]EQ4]A@PDABX&I!!<TGQ4]GQ4]GQ4]GQT]GP,KA@P&EQTUEQTUEQTUEQTTGQ4UGQ4QDP,DD!!T]GQ4QA@PDI"X&EA4]EQ4S
DQDQA@(UGQ4]BP,DI"X&G1P]GQT]GQDZF08PEQ4]GP$QABX&I!!<TGQ4UGP<LAPX&C!!T]GQ4ODPT&G1<_EA4]EQ4@H TFI 8UGQ4DA@PDI"X&G1P]GQT]ABHE
F!!,NEQ4]B0,DA@P&I"XTGQ4UGRHYF XBC!!T]GQDQB0P&I"X&EA4]EP$"H TFI 8UGQLQDQDDI"X&I!!P]GQPTEAPTEAPTEQ4]DQ(QARX_I"XTGQ4]GQ4]GQ4]
GQT]C00EA"XNG2@REA4]GQ4]GQ4]GQ4UGP@"APX&C" J@QP]GQ4]GQ4]GQ4]EQ4DH TZF08(B DTGQ4]GQ4]GQ4]GQT]H!!$ZA HNG0(AEA4]GQ4]GQ4]GQ4U
BRH"APX&C" J@QP]GQ4]GQ4]GQ4]EAPTEAPTEAPTEAPTGP@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_? @_? @_? @_? @_? @_? @_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8@G?8@G?8@G?8@G?8@G?8@G?8') ; yourself); yourself]
!

copyFile22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self copyFile22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copyFile22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class copyFile22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GQTUEQTUEQTUEA4]GQ4]GQ4]GQ4]GQ4UGQ4]DPP''I!!TTGQ4]GQ4]GQ4]GQ4]EQ4]GP$K@"XUG!!P]GQ4]GQ4]GQ4]GQT]GQ4IDPX&EAPTEA4]GQ4]GQ4]GQ4U
GQ4]C1DEI!!<\HQP]GQ4]GQ4]GQ4]EQ4]GQLIFQ,%E!!\TGQ4]GQ4]GQ4]GQT]GQ4]BRH&EQTUEQTUEQTTGQ4]GQ4UGQ4SDPP(D!!T]GQ4QAB\&EQP]GQ4]EQ4S
C1 [G0(UGQ4]BP,BI!!T^EA4]GQT]GQDZF08PEQ4]GP$QA"XTEAPTGQ4UGP<LAPX&C!!T]GQ4ODPT&G10!!EA4]EQ4@H TFI 8UGQ4]D0$YF2TVE1P]GQT]ABHE
F!!,NEQ4]GQ4IH"XCBATTGQ4UGRHYF XBC!!T]GQLQAB RI@4GEA4]EP$"H TFI 8UGQLOFA,_B!!H#IAP]GQPTEAPTEAPTEQ4]DQ([C!!@J@QHTGQ4]GQ4]GQ4]
GQT]C00EA"XNG2@REA4]GQ4]GQ4]GQ4UGP@"APX&C" J@QP]GQ4]GQ4]GQ4]EQ4DH TZF08(B DTGQ4]GQ4]GQ4]GQT]H!!$ZA HNG0(AEA4]GQ4]GQ4]GQ4U
BRH"APX&C" J@QP]GQ4]GQ4]GQ4]EAPTEAPTEAPTEAPTGP@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_<@@_>@@_?@@_? @_? @_? @_??@_?? _??0_??8_??8_??8_??8_??8_??8_??8@G?8@G?8@G?8@G?8@G?8@G?8') ; yourself); yourself]
!

copyItem22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copyItem22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copyItem22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A7]7]7]7]0@@@@@GUUUUUUT7@@@@@@]TQDQDQF\@@@@@A5QDQDQDY0@@@@@GUDQD]7]7]7]7\@]T
QDQ1DQDQDQM0A5QDQGD3L3L3L''@GM&Y&\SL3L3L2\@]7]7]1L3L3L3I0A7]7]7D3L3L3L''@G]7]7\SL3L3L2\@]7]7]3H"H"H"I0@@@@@G]7]7]7]7@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 0 184 184 16 228 224 0 128 120 64 64 64 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@_?0@_?0@_?0@_?0@_??8_??8_??8_??8_??8@O?8@O?8@O?8@O?8@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

copyWidget22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyWidget22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copyWidget22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copyWidget22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@DQDQDQD0@@@@@@@SL3L3L2@@@@@@@AL3L3L3H@@@@@@@D3L3L3L @@@@@@@SL3L3L2@@@@@@@AL3L3L3H@@@@@@@D3L3@@@@@@@@@@@S
L3LADQDQDQL@@AL3L0D3L3L3L @@D3L3@SL3L3L2@@@SL3LAL3L3L3H@@AL3L0D3L3L3L @@L"H"@SL3L3L2@@@@@@@AL3L3L3H@@@@@@@D3L3L3L @@@@@@
@SL3L3L2@@@@@@@AL3L3L3H@@@@@@@D3L3L3L @@@@@@@SL3L3L2@@@@@@@CH"H"H"H@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_?0@_?0@_?0@_?0@_?0@_?0@_?0@_??8_??8_??8_??8_??8_??8_??8_??8@O?8@O?8@O?8@O?8@O?8@O?8@O?8');
                            yourself);
                yourself
        ]
!

copyWidget22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyWidget22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#copyWidget22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class copyWidget22x22Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
A7]7]7]7]0@@@@@GUUUUUUT7@@@@@@]TQDQDQF\@@@@@A5QDQDQDY0@@@@@GUDQDQDQ''@@@@@@]TQDQDQF\@@@@@A5QDQDQDY0@@@@@GUDQD]7]7]7]7\@]T
QDQ1DQDQDQM0A5QDQGD3L3L3L''@GUDQD\SL3L3L2\@]TQDQ1L3L3L3I0A5QDQGD3L3L3L''@GM&Y&\SL3L3L2\@]7]7]1L3L3L3I0@@@@@GD3L3L3L''@@@@@@
\SL3L3L2\@@@@@A1L3L3L3I0@@@@@GD3L3L3L''@@@@@@\SL3L3L2\@@@@@A3H"H"H"I0@@@@@G]7]7]7]7@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 0 184 184 16 228 224 0 128 120 64 64 64 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_?0@_?0@_?0@_?0@_?0@_?0@_?0@_??8_??8_??8_??8_??8_??8_??8_??8@O?8@O?8@O?8@O?8@O?8@O?8@O?8');
                            yourself);
                yourself
        ]
!

cut22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cut22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#cut22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class cut22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
!!XT@@@@@@@@@@@@BT)D@@@@@@@BE!!XVE@@@@@@@@@@@@*F4X@@@@@@@@!!XVE!!P@@@@@@@@@@@EJEQ@@@@@AGA8VE!!XT@@@@@@@@@@@AQ!!UX@@@BASPH$!!XVE
@@@@@@@@@@@@F9VA@@A6_HTBIHVE!!P@@@@@@@@@@@B, S @QW(U!!I@^E!!XT@@@@@@@@@@@@\"U5%_Q4-+6^E!!XVE@@@@@@@@@@@@+Y-/,26B)$H@!!XVE!!P@@
@@@@@@@@@GVAIC8X%9\@@HVE!!XT@@@@AO8Q4@@@OJEH*#WH@@@BE!!XVE@GQCEQ$H#:P7B5E,\9<@@@@@!!XVE!!WP8$9@<*6ROE@)?)9<@@@@@@HVE!!XVNR[J0
@E]7BGDCNV,PDE@@@@BE!!XVEUFXV@@AY#G%J$$<FMPY;!!@@@!!XVE!!Y!!#* @@,E.@AZ8"H$@%N19;@HVE!!XTL(T0M+H\RP:T1"ENJ%$"KX@BE!!XVE]G"!!OV*1
HSL@V&:\@@A)BQ<@!!XVE!!PA4W@QAK0@@@I)>Q @@Q"1X@HVE!!XT@@@@@@@@@@@@''JV @@CZ)F BE!!XVE@@@@@@@@@@@@&Y6^%DV#\C(@!!XVE!!P@@@@@@@@@@
@GPS(*B LA\@@HVE!!XT@@@@@@@@@@@@@]HL#R3P@@@BE!!P@a') ; colorMapFromArray:#[0 0 0 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 207 207 219 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 129 71 26 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 126 69 26 154 92 27 242 140 1 227 168 29 143 83 26 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 134 77 26 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 159 96 27 187 117 28 241 241 246 149 87 27 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 254 254 255 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 139 77 23 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 255 255 255 136 77 26 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A0@@A0@@A00@A18@A38@A78@A?0@A? @A?@A9>@G?<@O?8@O_>@N_?@N_? O?? O=3 G13 @A3 @A? @A?@@@>@') ; yourself); yourself]
!

cutFile22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cutFile22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#cutFile22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class cutFile22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GQTUEQTUEQTUEA4]J7^/GQ4]GQ4]GQ4UGQ4]DPP''I!!TTG\XSPA4]GQ4]GQ4]EQ4]GP$K@"XUG!!Q7GV$]GQ4][C@]GQT]GQ4IDPX&EAPT]!!5:GQ4](WH+SA4U
GQ4]C1DEI!!<\HTN3(Q4]%90]J40]EQ4]GQLIFQ,%E!!]RRGL]NXH]!!D00GQT]GQ4]BRH&@0 UQJ^A!!95EUL6I@A4UGQ4SDPP(D"PMA<.9$MET(,Q''@@@]EQ4S
C1 [G0(RH2RV(T1#PKV5@@@@GQT]GQDZJ&R$%PDRM4=7TZ.S@@@@@A4UGP>UZC5ALZ7BWCQ6#)R=@@@@@@@]EQ6UW[F.X\&F+S03''<V=@@@@@@@@GQT]+F;P
3!!-;&CFRKE:MNC!!5@@@@@A4UGW&HO XB_Z*Z[;A4K5(/&:P@@@@]EP&6!!\ FI,9?(B;LR$)%SVAF&0@@GQPTM[=1M,*%N&#CU:Y8*KQ-*XL@@A4]GYVY/6JL
34%X@G:O. @@"3IG@@@]GQ4]%X@-Y%T@@@B8''&,@@F-S_@@@GQ4]GQ4]@@@@@@@@S%BJ@@A[14H@@A4]GQ4]GP@@@@@@@K^;/KI*0YE_@@@]GQ4]GQ4@@@@@
@@BUN<B>/%X?@@@@GQ4]GQ4]@@@@@@@@@IV#R7AY@@@@@@@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 0 0 0 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 154 92 27 242 140 1 227 168 29 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 187 117 28 241 241 246 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_<8@_>8@_?8X_?8<_?9<_?;<_??8_??0_?? _??@_?>@_?<@_??@_?? _??0_??0G>90C890@@90@@?0@@? @@_@') ; yourself); yourself]
!

cutIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cutIcon inspect
     ImageEditor openOnClass:self andSelector:#cutIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class cutIcon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
!!XT@@@@@@@@@@@@BT)D@@@@@@@BE!!XT@@@@@@@@@@@@@*F4X@@@@@@@@!!XVE@@@@@@@@@@@@@EJEQ@@@@@AGA8VE!!P@@@@@@@@@@@@AQ!!UX@@@BASPH$!!XT@
@@@@@@@@@@@@F9VA@@A6_HTBIHVE@@@@@@@@@@@@@B, S @QW(U!!I@BE!!P@@@@@@@@@@@@@\"U5%_Q4-+0BE!!XT@@@@@@@@@@@@@+Y-/,26B) @@!!XVE@@@@
@@@@@@@@@GVAIC8X%0@@@HVE!!P@@@@@AO8Q4@@@OJEH*#P@@@@BE!!P@@@GQCEQ$H#:P7B5E,\0@@@@@@!!XVE@GP8$9@<*6ROE@)?)9<@@@@@@HVE!!PBNR[J0
@E]7BGDCNV,PDE@@@@BE!!XT@UFXV@@AY#G%J$$<FMPY;!!@@@!!XVE@I!!#* @@,E.@AZ8"H$@%N19;@HVE!!P@L(T0M+H\RP:T1"ENJ%$"KX@BE!!XT@]G"!!OV*1
HSL@V&:\@@A)BQ<@!!XVE!!PA4W@QAK0@@@I)>Q @@Q"1X@HVE!!XT@@@@@@@@@@@@''JV @@CZ)F BE!!XVE@@@@@@@@@@@@&Y6^%DV#\C(@!!XVE!!P@@@@@@@@@@
@GPS(*B LA\@@HVE!!XT@@@@@@@@@@@@@]HL#R3P@@@BE!!P@a') ; colorMapFromArray:#[0 0 0 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 207 207 219 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 129 71 26 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 126 69 26 154 92 27 242 140 1 227 168 29 143 83 26 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 134 77 26 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 159 96 27 187 117 28 241 241 246 149 87 27 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 254 254 255 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 139 77 23 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 255 255 255 136 77 26 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A0@@A0@@A00@A18@A38@A70@A? @A?@@A>@A9<@G?8@O?8@O_>@N_?@N_? O?? O=3 G13 @A3 @A? @A?@@@>@') ; yourself); yourself]
!

cutItem22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cutItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#cutItem22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class cutItem22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
!!P@@@@@@@@@@@@@BT)D@@@@@@@BE!!XT@@@@@@@@@@@@@*F4X@@@@@@@@!!XVE@@@@@@@@@@@@@EJEQKT@@@AGA8VE!!P@@@@@@@@@@@@AQ!!UZ4@@BASPH$!!XT@
@@@@@@@@@@@@F9VA-@A6_HTBIHVE@K^7-;^7-;^7-2, S+REW(U!!I@^E!!PB7-+Z6-+Z6-+X\"U5%_Q4-+6\@!!XT@-;Z6-+Z6-+Z6+Y-/,26B)$J8@HVE@K^6
-+Z6-+Z6-''VAIC8X%9^6.@BE!!PB7-+XAO8Q4-+XOJEH*#WJ6-+ @!!XT@.GQCEQ$H#:P7B5E,\9>8.K"8@HVE@GP8$9@<*6ROE@)?)9<@@@@@@@BE!!PBNR[J0
@E]7BGDCNV,PDE@@@@BE!!XT@UFXV@@AY#G%J$$<FMPY;!!@@@!!XVE@I!!#* @@,E.@AZ8"H$@%N19;@HVE!!P@L(T0M+H\RP:T1"ENJ%$"KX@BE!!XT@]G"!!OV*1
HSL@V&:\@@A)BQ<@!!XVE!!PA4W@QAK0@@@I)>Q @@Q"1X@HVE!!XT@@@@@@@@@@@@''JV @@CZ)F BE!!XVE@@@@@@@@@@@@&Y6^%DV#\C(@!!XVE!!P@@@@@@@@@@
@GPS(*B LA\@@HVE!!XT@@@@@@@@@@@@@]HL#R3P@@@BE!!P@a') ; colorMapFromArray:#[64 64 64 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 207 207 219 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 129 71 26 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 126 69 26 154 92 27 242 140 1 227 168 29 143 83 26 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 134 77 26 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 159 96 27 187 117 28 241 241 246 149 87 27 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 254 254 255 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 139 77 23 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 255 255 255 136 77 26 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191 127 127 127 170 170 170 0 184 184 16 228 224 0 128 120]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A0@@A0@@A80@A98_??8_??8_??8_??8_??8_??8_??8_??8O_>@N_?@N_? O?? O=3 G13 @A3 @A? @A?@@@>@') ; yourself); yourself]
!

cutWidget22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cutWidget22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#cutWidget22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class cutWidget22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
!!XT@@@@@@@@@@@@BT)D@@@@@@@BE!!XT@@@@@@@@@@@@@*F4X@@@@@@@@!!XVE@HVE!!XVE!!XVE!!UJEQKT@@@AGA8VE!!PBE-[V5-[V5-[UQ!!UZ4@@BASPH$!!XT@
!![V5-[V5-[V5F9VA-@A6_HTBIHVE@HV5-[V5-[V5-R, S+PQW(U!!I@^E!!PBE-[V5-[V5-[T\"U5%_Q4-+6^E!!XT@!![V5-[V5-[V5+Y-/,26B)$H@!!XVE@HV5
-[V5-[V5-WVAIC8X%9\@@HVE!!PBE-[TAO8Q4-[TOJEH*#WH@@@BE!!XT@!!WQCEQ$H#:P7B5E,\9<@@@@@!!XVE@GP8$9@<*6ROE@)?)9<@@@@@@HVE!!PBNR[J0
-U]7BGDCNV,PDE@@@@BE!!XT@UFXV-[UY#G%J$$<FMPY;!!@@@!!XVE@I!!#*+V5,E.@AZ8"H$@%N19;@HVE!!P@L(T0M+H\RP:T1"ENJ%$"KX@BE!!XT@]G"!!OV*1
HSL@V&:\@@A)BQ<@!!XVE!!PA4W@QAK0@@@I)>Q @@Q"1X@HVE!!XT@@@@@@@@@@@@''JV @@CZ)F BE!!XVE@@@@@@@@@@@@&Y6^%DV#\C(@!!XVE!!P@@@@@@@@@@
@GPS(*B LA\@@HVE!!XT@@@@@@@@@@@@@]HL#R3P@@@BE!!P@a') ; colorMapFromArray:#[0 0 0 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 207 207 219 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 129 71 26 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 126 69 26 154 92 27 242 140 1 227 168 29 143 83 26 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 134 77 26 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 159 96 27 187 117 28 241 241 246 149 87 27 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 254 254 255 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 139 77 23 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 255 255 255 136 77 26 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191 127 127 127 170 170 170]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A0@_?<@_?<0_?=8_??8_??8_??0_?? _??@_?>@_?<@_?<@_?>@_??@_?? _?? _?? G13 @A3 @A? @A?@@@>@') ; yourself); yourself]
!

cutWidget22x22Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cutWidget22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#cutWidget22x22Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class cutWidget22x22Icon2'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
!!XT@@@@@@@@@@@@BT)D@@@@@@@BE!!XV9.[&9.[&9.[&9*F4X.[&9@@@@!!XVE.["8.K"8.K"8.EJEQK"5.PAGA8VE!![&8-+Z6-+Z6-+YQ!!UZ6-K&ASPH$!!XV9
.KZ6-+Z6-+Z6F9VA-+Q6_HTBIHVE.["6-+Z6-+Z6-", S+XQW(U!!I@^E!![&8-+Z6-+Z6-+X\"U5%_Q4-+6^E!!XV9.KZ6-+Z6-+Z6+Y-/,26B)$H@!!XVE.["6
-+Z6-+Z6-''VAIC8X%9\@@HVE!![&8-+XAO8Q4-+XOJEH*#WH@@@BE!!XV9.GQCEQ$H#:P7B5E,\;Z9@@@@!!XVE.WP8$9@<*6ROE@)?)9>6.P@@@HVE!![&NR[J0
-%]7BGDCNV,PDE@@@@BE!!XV9UFXV-+YY#G%J$$<FMPY;!!@@@!!XVE.Y!!#*+Z6,E.@AZ8"H$@%N19;@HVE!![$L(T0M+H\RP:T1"ENJ%$"KX@BE!!XV9]G"!!OV*1
HSN9V&:\.[%)BQ<@!!XVE!!PA4W@QAK0@@@I)>Q @@Q"1X@HVE!!XT@@@@@@@@@@@@''JV @@CZ)F BE!!XVE@@@@@@@@@@@@&Y6^%DV#\C(@!!XVE!!P@@@@@@@@@@
@GPS(*B LA\@@HVE!!XT@@@@@@@@@@@@@]HL#R3P@@@BE!!P@a') ; colorMapFromArray:#[0 0 0 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 207 207 219 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 129 71 26 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 126 69 26 154 92 27 242 140 1 227 168 29 143 83 26 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 134 77 26 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 159 96 27 187 117 28 241 241 246 149 87 27 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 254 254 255 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 139 77 23 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 255 255 255 136 77 26 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191 127 127 127 170 170 170 0 184 184 0 184 184 16 228 224 64 64 64]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A0@_?>@_?>0_??8_??8_??8_??0_?? _??@_?>@_?>@_?>@_?>@_??@_?? _?? _?? G13 @A3 @A? @A?@@@>@') ; yourself); yourself]
!

diff22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self diff22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#diff22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class diff22x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@0PEA XGB@$JB00MC <PDQHSEATBE!!\XFQ([GA4^G2@!!H"L$IRX&I"\(@1\XFR$*J20-K"<0LRH#ICH&I"X''L3P5
M#X7M3 9N#,<OS8?PDEBP4MCQDUF@@@@@@@@@@@@Q4 @@@@@@@AIRT)KQ @@@@@@@@@@@D]H@@@@@@AIRT%LR4X@YVU%YVU%YPAGR@@@@@@@@D%MSD9F@@@@
@@@@@@@@Q4 @@@AIRT%MST1NS0A''Y6]''Y6]''@D]H@F]''Y6]''Y6]PS%D@@@@@@@@@@@AGR@@@RT%MST1LTD9Q@@@@@@@@@@@@Q4 @Y&Y&Y&Y&Y%ANTP@@@@@@
@@@@@D]HRT%MST1LSD1PS%D@Y6]''Y6]''Y0AGRD%''Y6]''Y6]''T%MQ@@@@@@@@@@@@Q4!!MST5MST5LUEISTPA''Y6]''Y6]''RT]HSV]''Y6]''Y6]UT5X@@@@@@@@@
RT%GRD1LSD1LUEAPUUMW@F]''Y6]''Y6]IQ4!!LY6]''Y6]''Y5USV@@@RT5MST1LSD]HTEAPT%IUUUUYT5)[WE1]W%= XFE"X49NT5MST5MST6P@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 127 160 216 207 216 240 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 248 0 0 0 252 0 24 24 24 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

directoryBookmarks22x22Icon
    <resource:#programImage>
    ^ self directoryBookmarks22x22Icon2
!

directoryBookmarks22x22Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directoryBookmarks22x22Icon1 inspect
     ImageEditor openOnClass:self andSelector:#directoryBookmarks22x22Icon1
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class directoryBookmarks22x22Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@M60@@@@@@@@@@@@@@@@@@@@@@@@@H2''/JD@@@@@@@@@@@@@@@@@@@@@@@B@58.&@@@@@@@@@@@@@@@@@@@@@@@@/<+K&0@@@@@@@@@@
@@@@@@@@@@@@0KOP4H"N@@@@@@@@@@@@@@CD3JI;*-;X4MBP1Y6V,*2/@@@8B0,0.JSI_G26-+Z6-+Z4_H6A5 @GA!!L$H""O6*.G!!8^G!!8^G+XJ^(0@@A2 (
JB (X8CM1(&I"X&I(MNZ_0@@@E((X3M.[#L3$-1>_''9>_)F>3&5 @@@!!L5,3N3-KKYRC!!HRE!!HR7!!*<?X@@@HQQKKQP BP&)"''6%.\^._\KYO0D@@BE3XVDO
BP9#.-KU6<"=*MRU72(@@@AFZ4)QK&8<"[.\4\D3L<;O$9$@@@@@QUD%W4\ \9RW4[D+EAHR&I?C@@@@@GDUL''P U3FW-T!!UUT!!UUR?]00@@@@@MNQ$[W"M*
\@T^APUS^T5$M@@@@@@@CWYP^U%YVQ0\Y34XOTP7U @@@@@@@@L>WT1LI$0&X$9&VAXQ[@@@@@@@@@A\P$QRPF!!2BG]AJT$@@@@@@@@@@@@@RTM)GS(BD@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 0 0 0 245 140 6 254 247 77 254 167 8 254 198 21 195 71 0 239 120 0 217 118 18 251 198 41 239 136 3 254 183 14 254 181 14 220 106 4 254 229 40 234 151 34 254 214 30 243 141 3 243 177 49 240 121 0 251 220 73 228 130 21 247 128 0 250 231 85 254 191 23 239 147 25 220 89 0 240 174 62 247 126 3 213 100 6 217 95 0 190 64 0 190 62 0 209 92 2 226 112 2 234 105 0 222 124 21 207 92 3 187 60 0 254 207 32 231 111 0 248 131 0 194 69 0 251 174 39 254 151 9 228 107 0 242 136 7 219 96 1 234 147 32 243 151 21 253 226 50 198 74 0 254 225 41 254 166 8 195 70 0 239 119 0 212 88 0 213 107 14 242 163 29 254 247 70 219 97 0 254 247 50 254 180 14 253 137 0 248 136 8 231 133 21 225 106 2 237 131 7 203 78 0 213 97 3 239 126 2 237 118 0 210 85 0 231 113 4 183 56 0 254 138 0 225 127 21 250 194 22 248 147 7 207 83 0 254 240 95 253 245 84 253 243 84 251 136 0 239 136 8 197 72 0 197 70 0 254 254 55 214 90 0 250 142 2 243 169 28 251 140 3 251 130 3 194 68 0 247 181 38 251 234 78 191 66 0 245 142 3 226 102 1 234 127 2 242 122 0 240 146 21 188 62 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@X@@@<@@@<@@@<@@A>@@??<O??<_??8_??0_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

directoryBookmarks22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directoryBookmarks22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#directoryBookmarks22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class directoryBookmarks22x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@BH"X$@@@@@@K.;+[(@@@@@@@@@@@B2"H''X^7,@+L6;+Z6-2 @@@@@@@@CZ6+U>%71:+L&!!%L.0!!*7J@@@@@@@@ HF\3(*?(=&/5:R",^O#2 @@
@@@@@HC^---=,YZ>%[6G+,3V8<(@@@@@@@@@&MFY0JVK0[N&%IRL(L+J@@@8B0,0LIOP07?\3<J4)9*<%NGJ@@@GA!!L$H" 0!!\RM7Z"0&:JN/L_J@@@@A2 (
JB (X6O"*X>B7=KE-:+J@@@@@E((X3M.[#L3N>J]$HO 4=SJM&5 @@@!!L5,3N3-KKQP51+"?(;+JO3<?X@@@HQQKKQP BP$G])>+''-WJD6=/O0D@@BE3XVDO
BP9#X6M#2IFD2#<_YR(@@@AFZ4)QK&8<N3, HBBR2&8JO1\@@@@@QUD%W4\ \2@ RD +2,(R]Q(,@@@@@GDUL''P U3EHLT!!UUT!!UUR=8I0@@@@@MNQ$[W"M*
\@T^APUS^T5$M@@@@@@@CWYP^U%YVQ0\Y34XOTP7U @@@@@@@@L>WT1LI$0&X$9&VAXQ[@@@@@@@@@A\P$QRPF!!2BG]AJT$@@@@@@@@@@@@@RTM)GS(BD@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 237 93 63 240 72 43 255 96 56 255 110 74 255 125 93 255 116 81 244 165 152 255 175 155 255 102 64 255 95 55 96 57 66 215 109 88 224 81 58 255 52 2 230 114 94 241 101 71 255 107 70 255 94 54 255 87 44 255 136 106 255 61 12 255 113 78 255 104 67 252 101 65 208 79 60 223 96 73 255 55 5 255 71 26 255 92 51 255 105 68 252 134 104 255 138 109 255 58 8 255 80 37 255 186 169 255 130 99 255 100 62 190 136 133 236 53 17 255 56 6 255 70 24 255 89 47 255 51 1 255 104 66 255 64 17 255 67 20 255 99 60 255 164 142 109 41 45 252 109 74 197 81 70 241 57 15 255 57 7 255 68 22 255 90 48 255 101 63 236 144 129 255 75 30 255 77 33 255 167 145 255 180 162 255 63 15 255 108 72 255 255 255 159 49 39 241 51 8 255 52 1 255 61 13 255 81 38 255 98 59 255 111 75 255 85 42 255 87 45 255 162 139 255 183 164 255 73 28 238 109 78 120 41 44 212 97 79 248 64 20 77 77 77 255 84 41 255 97 58 247 36 9 255 129 98 255 97 57 252 170 150 255 181 162 255 83 40 255 76 32 120 45 46 220 64 38 252 51 2 255 58 9 239 97 68 241 73 37 241 132 110 255 128 96 255 106 69 255 109 72 255 178 158 255 93 52 255 86 43 114 46 52 212 117 99 248 53 7 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@NC0@_/8@??<@??<@??<@_?<O??8_??0_?? _??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

directoryUp22x22Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directoryUp22x22Icon1 inspect
     ImageEditor openOnClass:self andSelector:#directoryUp22x22Icon1
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class directoryUp22x22Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C\+2?\@@@@@@@@@@@@@@@@@@@@@@MSC9JB>:P@@@@@@@@@@@@@@@@@@@MQVV,1"5+9(@@@@@@@@@@@@
@@@@AMP4J[@''#/EOCO\@@@@@@@@@@@@@@F &L>EFD-T37/QC=0@@@@@@@@A0X_ L(OF&RB\004?,KZRZ@@@@@@A!!JDIEI++@!!FTUX/TH/I_>]P@@@@@@,%AP
1]EV/$35Z]93HZ!!3<9$@@@@@@EO])ZV_$''>3#K*P*E;Z4C#=[]29@@@N,7^SW)M^HJ#2<":/VNUYCP(DV0@@ORA,[C3[4 @TX0F]G>7-N>7_D>8@@C7''.;,[
DA''A''Q"''*4%PTG8;1U,@@@BJ59F!!W=59]5V\''D]*Z-4Q_"(@@@@@"ZEJ.H,<930<^7-\HA8^;3I]@@@@@NL$Y>(<+VRMYH6)*X6)*VC:S @@@@@W]CD5-4SS
8@,:B0.#?IWBZ0@@@@@@E?Z^?KF1,SX63W(/^(].+@@@@@@@@@%<-)RTR9QK/9[F+"T]6@@@@@@@@@B4!!X^" \;&C?&CUH<@@@@@@@@@@@@@#8[ONWXGG@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 96 144 255 208 208 207 128 127 112 239 239 224 207 192 191 207 191 176 160 144 128 80 111 191 175 143 112 224 223 207 255 224 127 79 96 176 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 208 239 255 192 176 144 63 80 159 175 208 255 239 224 223 175 143 111 95 128 240 239 224 176 80 80 79 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 176 176 191 64 64 63 79 79 64 240 208 127 160 127 63 80 112 192 192 224 255 239 239 192 160 192 239 176 159 112 96 112 192 127 127 112 111 143 239 64 80 160 255 224 96 176 223 255 207 160 64 224 208 175 159 191 240 95 112 207 239 208 144 240 223 95 191 192 208 176 159 111 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 207 207 192 175 160 160 208 192 192 175 175 160 255 255 224 79 95 175 255 223 112 191 192 207 191 223 240 143 144 160 95 127 208 255 240 223 255 223 143 255 208 64 176 191 192 175 160 159 208 192 191 128 175 239 255 255 223 192 192 191 223 223 208 192 176 111 160 143 127 143 144 159 95 127 207 224 224 223 240 207 96 207 160 127 160 191 240 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 175 207 255 111 144 255 255 224 144 80 111 207 208 207 192 239 208 112 191 191 208 159 192 255 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 191 176 175 207 191 128 143 128 127 96 95 80 64 96 176 239 208 111 191 191 207 144 112 96 255 240 191 144 143 128 255 239 192 240 224 95 208 207 160 192 144 48 191 191 176 240 239 208 208 208 191 111 96 96 224 192 64 176 175 160 144 112 95 80 127 207 160 127 47 127 80 47 255 224 111 192 191 176 176 144 96 176 159 96 240 223 176 64 95 176 240 239 144 191 208 255 176 175 159 128 176 255 240 224 144 175 191 176 255 239 191 240 208 64 255 239 128 239 208 79 111 159 255 160 159 144 224 223 223 223 208 208 111 96 95 48 79 144 63 80 144 191 144 64 224 224 192 143 175 240 240 223 143 240 208 63 255 239 127 63 95 159 240 240 192 175 207 240 80 128 240 64 95 175 255 239 159 207 192 176 63 80 143 144 112 79 240 224 143 191 159 63 240 207 111 207 224 255 240 223 80 207 176 112 240 240 191 175 143 127 112 112 111 224 192 112 240 223 112 208 176 80 176 159 127 143 176 255 255 224 160 112 159 239 208 207 207 79 111 191 240 223 79 144 176 240 255 240 208 207 191 112 80 112 207 223 208 207 239 239 207 208 176 79 79 64 63 159 144 143 239 224 208 128 127 127 95 112 191 176 208 255 255 223 95 192 160 63 128 111 48 191 191 160 80 96 176 239 192 127 255 223 127 191 192 223 191 223 255 143 176 240 255 224 159 159 127 95 96 96 95 223 208 175 239 223 144 176 160 112 255 240 207 159 191 255 255 255 240 240 224 112 192 223 255 176 176 175 176 143 96 143 176 239 240 208 111 160 143 48 240 239 160 80 79 64 176 191 208 207 160 80 112 111 96 128 175 255 255 255 239 192 176 175 239 223 175 95 95 80 160 207 255 127 160 255 80 95 144 127 159 239 64 96 191 239 192 96 176 191 207 191 160 127 143 111 64 160 143 95 224 223 208 255 224 128 208 207 176 63 95 175 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@G @@O0@@_8@A?<@A?>@O??@_??@_??@_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

dosShellTerminal22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self dosShellTerminal22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#dosShellTerminal22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class dosShellTerminal22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
 XFA XFA XFA XFA XFA XFA XFA XFAPX)8%QL9U9LQ]T52^(@/K2</ XFAGDFA XFA XFA XFA:>/+:>2ANRVA TJA(Q(ZF!!(ZF!!+#9^W%9^S- _H% XF[
 ^[K*;OZ7^C!!+]OA0?W:>8G.IXFAF8G&2:.''):_ 8Z7S0\O5>/.A<BVA R^A9-2''3\7Q)>F-4<G9=_+; _H% XEJ ^J6);B07^C!!+]OA>_W:>8G.IXFA\XG"
*:^0,M618Z6''0_''5>/.A<BVA S:A8*.'',KB0,Z7J0\OY=_+; _@% XE!! ^J?)=GQ7Z6-4<GC6_+;?XG/IXFAL8G",:_R4-6-+]N''6S?U>O>A;2VA X6A8;B''
7]61)=.*4L#U3?36 _L% XE- ^O],Z^'')=SL5,B).[''>=(G1IXFA[XG%+*:;1=,++;SH/\?8??^A<RVA V6A XFA XFA XFA XFA XFA _P% XE-</K.;/C/
;?O3<?G1<_O3<_G1IXFA RT%IRT%IRT%IRT%IRT%IRT%IXFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA
 XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA P@a') ; colorMapFromArray:#[109 243 0 55 187 0 11 108 0 18 149 0 55 167 0 213 232 255 218 229 250 217 227 249 62 176 0 90 104 197 79 200 0 226 234 251 96 230 0 210 230 255 69 185 0 86 215 0 42 150 0 142 156 218 187 197 239 158 177 227 201 255 153 32 135 0 197 206 242 49 159 0 22 122 0 39 148 0 160 173 232 131 157 220 147 178 229 224 238 255 73 206 0 56 168 0 221 232 252 29 131 0 73 190 0 90 224 0 19 118 0 63 67 120 63 177 0 126 151 218 16 146 0 53 164 0 70 186 0 33 164 0 214 224 248 213 222 247 132 255 21 99 106 198 16 114 0 60 173 0 216 232 253 101 118 203 30 162 0 111 245 0 184 194 238 47 180 0 224 237 254 154 172 225 223 235 253 214 232 254 194 203 241 64 178 0 111 131 209 17 149 0 133 145 214 167 193 234 142 171 226 249 252 255 61 194 0 216 225 249 44 152 0 105 239 0 34 139 0 7 102 0 121 144 215 209 230 255 246 250 255 128 139 212 24 124 0 68 185 0 102 235 0 4 98 0 48 157 0 21 122 0 206 255 162 45 177 0 11 107 0 150 167 223 72 196 0 219 230 251 156 255 66 62 195 0 168 180 234 1 94 0 191 200 240 89 214 0 106 240 0 106 124 206 69 202 0 8 103 0 218 232 253 159 255 72 32 164 0 113 247 0 59 191 0 164 176 233 42 149 0 76 209 0 76 195 0 85 97 195 49 164 0 49 158 0 190 255 132 116 137 212 123 134 209 83 216 0 12 122 0 137 151 216 119 252 2 118 252 1 166 187 231 194 222 255 118 128 207 36 141 0 97 226 0 87 221 0 16 113 0 77 210 0 113 122 205 255 255 255 23 128 0 40 146 0 30 151 0 225 238 255 13 111 0 101 235 0 47 179 0 222 234 252 170 192 234 252 253 255 121 253 3 96 111 201 180 191 237 220 234 253 54 166 0 212 231 255 27 129 0 147 161 221 115 249 0 162 182 229 61 183 0 61 175 0 176 187 236 41 173 0 217 232 253 137 164 224 68 184 0 4 135 0 4 133 0 85 212 0 14 112 0 226 239 255 31 134 0 215 232 254 92 225 0 172 183 235 243 249 255 0 0 0 123 255 0 15 139 0 32 165 0 103 255 0 144 255 27 46 203 0 56 194 0 29 157 0 90 248 0 60 217 0 192 255 130 94 251 0 23 151 0 206 255 147 111 255 0 148 255 63 37 167 0 10 132 0 27 154 0 51 187 0 130 254 18 14 139 0 48 201 0 102 255 0 21 148 0 28 183 0 164 255 71 18 174 0 55 192 0 167 224 170 171 255 81 45 179 0 18 142 0 116 255 0 42 191 0 113 255 0 32 162 0 93 251 0 43 178 0 6 128 0 23 152 0 84 241 0 84 239 0 37 192 0 37 168 0 10 133 0 27 155 0 159 255 70 0 98 0 14 166 0 85 242 0 41 175 0 112 255 0 75 231 0 135 255 26 31 160 0 65 222 0 55 211 0 141 157 224 164 175 229 178 194 242 178 187 232 130 147 221 46 145 54 47 129 47 46 132 45 46 133 45 250 255 255 241 249 255 195 206 251 184 201 251 178 197 251 182 200 251 170 192 251 187 202 251 177 197 251 166 191 251 7 162 0 0 111 0 0 107 0 1 122 0 16 173 0 0 154 0 0 142 0 0 120 0 0 118 0 0 116 0 0 114 0]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@O??0_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8O??0@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

fileBrowser22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileBrowser22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileBrowser22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class fileBrowser22x22Icon'
        ifAbsentPut:[(Depth8Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N@,KLC@G@@@@@C@0LC@0L@@@@@@@A0XSIBH(LC@0LC@0A )TUCX@@@@@@@\(JB (JFM#[&9.L3L3L3L6@@@@@@AZ
JFL3[&83L3,;V4-KEB5!!@3Y-X@@@HSM[L3,;+8F2/8%;"=2TXVD?O6@@@BDTR24T!!I#B3;^+1<V5-II/[3<A@@@!!\6E!!!!J^;5[2:&:/[ L2I$&T*@@@@Q&-J
7:&_5]WH I68''Y.+4KJT@@@@@DUQIW6O/MVF18:N#(:N*:.V) @@@@A1EZ?X1J7H*)6@&:/[6:/[1ZP@@@@@CS''_*Z.+ H:@6=.\''I2\68BU@@@@@@567:''[
#+"Y*=.\+Z6-+Y2\5 @@@@@CO->)*8BL#'':\+[2</J:-.-X@@@@@WDK_$M&+''XC[''J:<!!(Z<+XJ?@@@@@D%C%M7M*9&@6:6./MWU5Z;C20@@@@@@@@BD-,V:
&7:\++2F5]V 0P@@@@@@@@BS7<B66]/[''J6-+([!!*MD@@@@@@@CF,9*0,[ZM.].-''HJ,*G<@@@@@@@CZ2\*>/P@@^:VW",:( 9D@@@@@@@CZ(<*G(''0@@@@@
@@@@@@@@@@@@@@@@(<*G"M_R@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 191 175 143 144 159 192 160 144 159 176 191 208 192 255 255 175 175 192 191 239 255 176 176 207 207 239 240 175 175 207 207 207 223 239 239 224 240 255 255 223 128 63 175 111 95 128 143 191 144 160 192 159 159 192 160 223 255 160 192 224 176 224 255 175 191 223 159 160 208 192 192 208 208 208 223 240 239 223 239 239 239 128 143 176 143 175 208 143 159 192 143 143 191 176 239 255 207 207 191 191 240 255 208 255 255 175 223 255 207 207 207 207 223 239 224 239 240 240 240 239 175 111 80 255 191 95 127 127 175 128 144 191 160 160 191 159 160 192 160 175 207 159 160 207 176 223 255 192 240 255 191 207 224 223 255 255 224 255 255 224 224 239 144 159 160 128 143 175 128 128 175 240 207 144 144 144 191 144 160 208 143 159 207 192 239 255 160 208 255 191 224 240 207 240 255 208 224 239 239 255 255 144 143 143 207 143 95 127 128 175 144 159 191 143 144 191 144 160 207 176 208 224 191 223 239 175 208 240 255 208 159 191 224 255 207 239 255 255 191 80 255 175 79 143 143 176 144 191 239 160 191 224 160 176 208 176 208 239 159 192 239 175 160 192 176 175 207 224 224 224 208 208 224 255 255 255 143 159 191 160 128 144 160 175 208 176 223 240 255 207 144 207 255 255 191 191 208 176 176 208 207 207 208 223 223 224 207 208 223 239 239 240]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@O0?@_??@_??@_??8_??8_??8_??0_?? _?? _?? _?? _?? _?? _?? _?? C??@G??@O?>@_O<@?@@@?@@@'); yourself); yourself]
!

fileBrowser22x22Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileBrowser22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#fileBrowser22x22Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class fileBrowser22x22Icon2'
        ifAbsentPut:[(Depth8Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\&U%\GA.@@@@@GA0\GA0\@@@@@@@[''N=7^C_\GA0\GA0\;N</FX@@@@@@F;_7=?_7=3\6=/[6-+Z6-)&@@@@@@A/
7=3Z6=/[\GA0\GA0\GA0OVYKR @@YM*;6-''Y$48G@0(\H5.!!4MB8.D(@@FSU5+_U]08^T&!!)W4P_FXK!!8[ F@@A$-]CP]2RD8.#(:N#(:B@J )<.@@@@RL>2
""U98.#(:N#(:N#(I0^!!@@@@@D^,2UAC:N#(:N#(:N#(:F$SL @@@@AF)9L4:N#(:N#(:N#(:N#(Q@H@@@@@OI"JI^#(:N#(:N#(:N#(:F@I@@@@@C2V""W(
:N#(:N#(:N#(:N"ED@@@@@@=X((%:N#(:N#(:N#(:N#(_A@@@@@@O""JI%O(:N#(:N#(:N#(:G(C@@@@@@@A(T<6:.+*:.+*:.+*:.)QCP@@@@@@@@A7D$Q<
:X.K"8.K"8.TC0@@@@@@@@B9"!!,RT75=!!X.K"8.KL4@@@@@@@@CE)GPZBAH7W''6K!!W)\L4D@@@@@@@CC0\A+F@@@G@,QGST3P&\@@@@@@@CC0,BFN#@@@@@@
@@@@@@@@@@@@@@@@0,BFN2(@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 127 80 47 127 127 175 127 128 175 128 96 64 128 111 48 128 127 112 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 111 64 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 112 48 144 112 79 144 112 95 144 112 96 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 112 64 159 127 95 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 127 47 160 127 63 160 128 144 160 143 48 160 143 95 160 143 127 160 144 111 160 144 128 160 144 159 160 159 112 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 175 111 80 175 111 95 175 143 111 175 143 112 175 143 127 175 159 128 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 143 96 176 144 96 176 159 96 176 159 112 176 159 127 176 160 112 176 175 159 176 175 207 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 191 144 64 191 159 63 191 175 143 191 175 160 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 144 48 192 160 63 192 160 111 192 176 144 192 176 159 192 192 208 192 239 255 192 240 255 192 255 255 207 143 95 207 160 64 207 160 80 207 175 112 207 176 112 207 176 127 207 191 112 207 191 128 207 192 160 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 176 79 208 176 80 208 176 111 208 192 191 208 208 223 208 208 224 208 224 239 208 255 255 223 128 63 223 191 95 223 192 111 223 208 208 223 223 224 223 255 255 224 192 64 224 192 112 224 192 128 224 207 111 224 208 175 224 223 207 224 224 224 224 224 239 224 239 240 224 255 255 239 192 96 239 208 79 239 208 111 239 208 112 239 208 144 239 223 159 239 223 175 239 224 176 239 224 223 239 239 207 239 239 224 239 239 239 239 239 240 239 255 255 240 207 144 240 208 63 240 208 64 240 208 127 240 223 79 240 223 80 240 223 95 240 223 112 240 223 143 240 223 176 240 224 95 240 224 112 240 224 127 240 224 143 240 224 144 240 224 191 240 239 144 240 239 160 240 239 175 240 239 176 240 239 208 240 239 223 240 240 175 240 240 191 240 240 192 240 240 208 240 240 239 240 255 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 64 255 208 159 255 223 95 255 223 112 255 223 127 255 223 143 255 224 96 255 224 111 255 224 127 255 224 128 255 224 144 255 224 159 255 224 160 255 239 127 255 239 128 255 239 159 255 239 175 255 239 176 255 239 191 255 239 192 255 240 176 255 240 191 255 240 192 255 240 207 255 240 208 255 240 223 255 240 224 255 255 223 255 255 224 255 255 240 255 255 255 247 255 255 247 255 255 239 255 255 231 255 255 223 255 255 255 247 223 223 247 255 191 167 151]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@O0?@_??@_??@_??8_??8_??8_??0_?? _?? _?? _?? _?? _?? _?? O?? C??@G??@O?>@_O<@?@@@>@@@'); yourself); yourself]
!

fileIn22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileIn22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileIn22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class fileIn22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@GQ4]GQ4]GQ4]GQ4]GQ4]GP@@@@@@@A4]GQ4]GQ4]GQ4]GQ4]GQ4@@@@@@@@]GQ4]GQ4]GQ4]GQ4]GQ4]@ATUEQTUEQTUEA4]GQ4]GQ4]GQ4]GP@U
GQ4]DPP''I!!TTGQ4]GQ4]GQ4]GQ4@EQ4]GP$K@"XUG!!P]GQ4]GQ4]GQ4]@AT]GQ4IDPX&EAPTEA4]GQ4]GQ4]GP@UGQ4]C1DEI!!<\HQP]JQ4]GQ4]GQ4@EQ4]
GQLIFQ,%E!!\TGR$)GQ4]GQ4]@AT]GQ4]BRH&JR$)JR$)JR$]GQ4]GP@UGQ4SDPP(D"$)JR$)JR$)JQ4]GQ4@EQ4SC1 [G0()JR$)JR$)JR$)GQ4]@AT]GQDZ
F08PJR$)JR$)JR$)GQ4]GQ4UGP<LAPX&C"$)JR$)JR$)GQ4]GQ4]EQ4@H TFI 8(B DTGR$)GQ4]GQ4]GQT]ABHEF!!,NJ@(AEA4)GQ4]GQ4]GQ4UGRHYF XB
C!!<J@QP]GQ4]GQ4]GQ4]EP$"H TFI 8(B DTGQ4]GQ4]GQ4]@APTEAPTEAPTEAPTEA4]GQ4]GQ4]GP@@@@@@@A4]GQ4]GQ4]GQ4]GQ4]GQ4@@@@@@@@]GQ4]
GQ4]GQ4]GQ4]GQ4]@@@@@@@@@@@@@@@@@A4]GQ4]GQ4]GP@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 248 0 0]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@_<@@_>@@_?@@_? @_?(@_?,@_?>@_??@_?? _??@_?>@_?,@_?(@_? @_? @_? @@@@@@@@@@@@@') ; yourself); yourself]
!

fileOpen22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileOpen22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileOpen22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileOpen22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"G!!8^G!!$"H"H"H"H"H"H"H"H"H"H"H"$TJQ8HGB@^H"H"H"H"H"H"H"H"H"H"H"H"H"H^G@TZ
G"H"H"H"H"H"H"H"H"H"H"H"H"H"G"@]G"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!(]AQ8"H"H"H"H"A@PDA@P"H"H"H"H"H!!(]D18"H"H"H"HDI!!TNCATDH"H"
H $^EB@SD18^@"H"H"HDDB(*B D,A@PDAA8 GQLSD1LSG"H"H"HDJ (JB (AA X*B (^HALSD1L^H"H"H"H[B (JB (JB (JB"TOH2@SD18"H"H"H"H[HRD!!
HRD!!HRT-I0@@@@,]G!!\"H"H"H"H[D!!H+D @DAB\M@PDAF@8^BRP"H"H"H"H-J2,D@B0CDQ@FA XFFA P@2P"H"H"H"H-A1,N@R(*J"(*J"(*D!! AIBH"H"H"
H"H-A1,PB (JB (JB (JD!! *IBH"H"H"H"H-E"XFB (!!B"DJHP(!!J1H$H"H"H"H"H"H$G1T*D"D!!HRD!!HRD!!J2,$H"H"H"H"H"H$AADRD!!HRD!!HRD!!HRC2P"
H"H"H"H"H"H$@AD+J2,+J2,O@A,$IBH"H"H"H"H"H"H$KA +A1<DKRP[F1,"H"H"H"H"H"H"H"H$J@P$IA,[H"H"H"H"H"H"H"H"H"H"H"H$IA,"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"');
                colorMapFromArray:#[ 224 189 75 255 253 212 114 169 125 244 219 172 224 180 55 105 195 48 255 253 194 253 210 112 27 163 14 139 188 141 254 253 153 67 140 42 245 230 190 245 250 242 238 222 158 240 212 96 254 253 228 249 239 209 254 233 132 135 224 88 62 138 68 241 209 144 254 198 97 148 180 81 255 227 154 39 125 38 61 166 37 216 172 46 46 153 24 113 206 71 25 131 15 240 198 86 79 187 37 254 243 141 255 255 255 69 123 9 205 154 5 249 235 113 225 193 100 218 179 65 241 239 199 10 113 5 254 251 173 254 221 123 230 203 126 213 166 29 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@>@@C?@@@O @@G @@C0G0C0O8_<O??<O??8O??0O??0O??0O??0O?? O?? O??@O??@O?>@O?<@O?0@O8@@N@@@@@@@');
                            yourself);
                yourself
        ]
!

fileSave22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileSave22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileSave22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileSave22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@CT4MCH0K20)I2P$H2H!!G14\@@@@@CV%(/SL4][4=OS4=OS4=OQ@OP(@@@@4(Y;4F1,[=OS4=OS4<.W^PC4H@@@@L9"W=A.#&/S4=OS4;NOW43$4A0@@@CJU
$_P[''974=OS49]/S3,PYFP\@@@@1#H+'':^/3<?O38=/S1<BNFA G@@@@K8RD^7Y.Y59ZT$1HP3<9F1TUA0@@@B:@_GM-ZU9ZT$5GP389F1,UEP\@@@@-]''M,
Y&AXUD1JP389NQ,[EQTG@@C<J&)/Y6M]U5EKRTD=NS$9MQTUA0@@?B%#X.S$8-?Z5MCM2LN6,[DUEPX@@O0''V%+"8-?Z5MCM2LO@*ZZ)FQ$D@@C<I5UU8K.9
-;R1+::-&X"E*Q X@0@@?BYNS-?_6-SP2LO@-JZ\$:LUEPT@@O0&RT''].KV2,J:-&8"A^WRVEQTG@@C<ITIB6-+T4L"<*ZZ\$8.G#1TUA0@@?BU@PM^6,Z.(
&YJE_W]1[H8UEP\@@O0%OC2P$H6F 7)5Z6U_WE%VEAPH@@C<@@$IBP$HB@ HB@ HB@ HB@ H@@@@?@@@@@@@@@@@@@@@@@@@@@@@@@@@@O0@@@@@@@@@@@@@
@@@@@@@@@@@@@@C<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 28 33 37 34 41 60 37 45 83 39 48 89 42 51 96 45 55 103 49 60 112 54 65 115 54 66 115 54 66 116 57 70 107 57 70 109 59 59 58 65 79 121 65 80 125 66 80 124 68 83 130 74 71 70 77 81 85 78 95 152 80 98 153 81 98 151 83 47 28 85 102 157 86 103 157 88 101 128 90 110 162 94 106 146 94 106 147 95 83 66 95 107 147 96 74 37 97 108 148 98 109 148 98 109 149 99 110 149 101 111 150 101 111 151 101 112 151 102 102 107 102 113 151 102 113 152 103 86 54 103 113 151 103 113 152 103 114 152 104 114 152 105 115 152 105 115 153 106 116 153 107 116 154 107 117 154 108 117 154 116 124 137 123 85 65 123 107 74 125 143 184 126 64 32 126 139 158 126 143 183 127 145 185 128 145 184 129 146 185 129 147 186 130 148 186 131 148 187 131 149 187 132 141 160 133 141 159 133 143 164 134 151 188 134 151 189 134 152 189 135 152 189 136 153 190 137 154 191 138 154 191 139 156 193 141 151 173 142 69 67 142 157 193 142 158 193 143 62 26 143 158 193 143 159 194 144 157 200 144 161 195 145 161 195 146 158 202 146 162 196 147 89 55 147 160 203 147 162 196 148 165 197 149 161 204 149 164 197 150 166 198 150 166 199 151 167 199 152 149 137 152 163 206 152 168 199 153 169 201 154 96 64 154 169 201 154 170 201 155 167 207 155 171 202 156 171 202 156 171 203 157 172 203 157 173 182 157 173 203 159 147 111 159 174 204 159 175 204 160 170 210 160 174 204 160 176 205 162 172 191 162 178 207 163 173 212 163 177 206 164 177 207 164 180 207 165 147 99 165 165 166 165 178 207 166 182 208 167 147 95 167 177 214 167 181 209 169 185 209 170 179 216 170 186 215 171 185 210 172 162 152 172 185 212 172 187 217 173 186 212 174 182 218 174 188 219 175 190 221 176 184 220 176 189 214 176 190 213 176 190 218 177 145 64 177 190 215 179 193 223 180 192 216 181 193 216 181 194 214 181 195 218 182 194 214 182 195 221 183 196 219 184 195 218 184 197 219 185 95 37 185 196 219 185 197 219 185 197 222 186 185 192 187 198 220 187 200 223 188 171 94 188 199 217 192 204 226 194 97 38 195 206 220 196 168 100 196 206 218 198 207 220 202 211 222 203 212 222 205 214 224 207 215 224 208 101 40 209 217 225 210 217 226 210 219 227 212 220 227 213 220 227 214 221 228 217 103 41 217 223 229 217 224 237 219 101 37 222 177 45 222 225 232 223 228 241 224 187 54 225 105 42 226 231 241 226 231 243 228 196 63 230 202 70 230 234 245 230 235 243 232 240 251 233 208 76 233 235 240 233 236 247 233 237 244 233 237 246 235 214 82 235 238 245 236 239 248 237 239 242 238 241 249 239 242 247 240 242 242 240 242 249 240 243 249 242 220 141 242 242 227 242 244 249 242 244 250 244 244 245 244 246 250 244 246 251 245 247 250 246 247 250 246 247 251 247 248 251 247 248 252 248 249 251 248 249 252 249 99 39 249 249 253 250 147 56 250 250 253 251 169 79 251 251 253 251 252 253 252 99 38 252 178 84 252 187 89 252 199 96 252 206 99 252 252 253 252 252 254 253 253 254 254 99 38 254 107 43 255 100 39 255 101 39 255 106 42 255 117 45 255 236 120 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_??C???#???#???#???#???#???#???#???#???#???#???#???#???#???#???#???#???#_??C@@@C@@@C@@@C');
                            yourself);
                yourself
        ]
!

fileSaveAs22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileSaveAs22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileSaveAs22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileSaveAs22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@EV[&2N]_>1!!M#$9@;FJ[5CY@@@@@EW83CMQA8L3L3L3L3L3L3LB[(UOX B[Z\435-[VL3L3L3L3)4^?@&;>F!!B(HDTSL=[[7#L3L3L3?IC0,+)I,ORB82N>
U3OVP@<3L3L3Q2^2\LR^P\E3F2+*J_EFZ8#:>/+:EB]]&J+7<$,A8_''C_;Z6C-==134J\W1_YS+%%-T&49H@0<X?CEX% S4J\Q?+++LI#[.S^^D@@LM 75Z@
;6^KCW1>++M&2OTV(SCN@@CC*>6\1<&56-7)1S#O%7ZT]C@E3 @@06GI+=KR.IG@A,*7M^!!Z&!!#XP)<@@LL6B *8.IG@KA67[TN4LZV,D]E(@@CCM-3\SA''B
)(\R8(<""S-^QE/6^0@@0:5:^)EI))UI\$&D;.O 95"=9$8@@LN-1\U7RT''PRZAIRZH>T+1*T5ON@@CCX3\70L@,2''I,Y@.YMK%M#%MS3 @@06LB@/CKD#0\
?WW3#EP$ D)ST<8@@LM#B@#T5M\W^CK;RNQYKR:#G!!:$@@CC@B</K2>$)JR$)JR$)JR$)JR$@@@@00@@@@@@@@@@@@@@@@@@@@@@@@@@@LL@@@@@@@@@@@@@
@@@@@@@@@@@@@@CC0<OC0<OC0<OC0<OC0<OC0<OC0<OC00@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 142 69 67 129 147 186 98 109 149 242 51 50 86 103 157 240 242 242 236 239 248 126 143 183 165 147 99 146 162 196 187 200 223 164 177 207 143 158 193 163 177 206 183 196 219 147 89 55 66 80 124 205 214 224 180 192 216 247 248 252 203 212 222 255 100 39 170 179 216 123 107 74 217 223 229 186 185 192 77 81 85 188 199 217 242 242 227 78 95 152 138 154 191 107 116 154 226 231 241 242 220 141 106 116 153 157 173 203 156 171 202 255 106 42 242 244 250 247 105 44 173 186 212 83 47 28 196 206 218 239 242 247 147 160 203 146 158 202 54 66 115 95 83 66 225 105 42 163 173 212 253 253 254 176 190 218 222 177 45 101 112 151 131 148 187 130 148 186 99 110 149 129 146 185 96 74 37 195 206 220 148 165 197 166 182 208 165 178 207 184 197 219 188 171 94 81 98 151 255 236 120 133 141 159 181 193 216 249 249 253 248 249 252 155 167 207 88 101 128 174 188 219 250 147 56 246 247 250 170 186 215 42 51 96 154 96 64 94 106 147 233 236 247 162 178 207 80 98 153 160 176 205 108 117 154 159 174 204 176 189 214 141 151 173 149 161 204 252 99 38 57 70 107 213 220 227 233 235 240 126 139 158 134 151 189 103 113 152 102 113 151 254 107 43 101 111 150 192 204 226 150 166 198 159 147 111 149 164 197 39 48 89 185 196 219 179 193 223 250 250 253 217 224 237 222 225 232 127 145 185 95 107 147 233 237 246 142 158 193 230 235 243 165 165 166 208 101 40 176 190 213 252 199 96 244 246 250 167 177 214 185 95 37 139 156 193 37 45 83 137 154 191 156 171 203 135 152 189 104 114 152 155 171 202 154 169 201 102 102 107 240 242 249 34 41 60 54 66 116 210 217 226 209 217 225 251 251 253 219 101 37 97 108 148 145 161 195 164 180 207 230 202 70 175 190 221 172 162 152 246 247 251 245 247 250 28 33 37 255 101 39 254 99 38 237 239 242 233 208 76 224 187 54 230 234 245 182 195 221 217 103 41 107 117 154 157 172 203 105 115 152 177 145 64 45 55 103 198 207 220 194 97 38 171 185 210 144 157 200 54 65 115 103 86 54 212 220 227 252 252 253 255 117 45 182 194 214 223 228 241 102 113 152 162 172 191 101 111 151 131 149 187 150 166 199 244 244 245 98 109 148 238 241 249 128 145 184 249 99 39 147 162 196 167 181 209 233 237 244 247 248 251 172 187 217 125 143 184 252 178 84 159 175 204 65 80 125 177 190 215 244 246 251 242 244 249 157 173 182 214 221 228 255 255 255 226 231 243 134 152 189 103 114 152 153 169 201 228 196 63 151 167 199 235 238 245 210 219 227 185 197 219 184 195 218 49 60 112 152 149 137 207 215 224 65 79 121 248 249 251 143 62 26 176 184 220 251 169 79 90 110 162 174 182 218 85 102 157 94 106 146 144 161 195 185 197 222 143 159 194 142 157 193 181 195 218 160 174 204 132 141 160 74 71 70 202 211 222 126 64 32 152 163 206 167 147 95 68 83 130 133 143 164 252 206 99 136 153 190 105 115 153 134 151 188 103 113 151 154 170 201 123 85 65 152 168 199 240 243 249 172 185 212 235 214 82 169 185 209 232 240 251 252 187 89 57 70 109 196 168 100 187 198 220 59 59 58 252 252 254 160 170 210 251 252 253 181 194 214 116 124 137 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_??C???;???????????????;???3???#???#???#???#???#???#???#???#???#???#???#_??C@@@C@@@C@@@C');
                            yourself);
                yourself
        ]
!

fitImageSizeToView22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fitImageSizeToView22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fitImageSizeToView22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class fitImageSizeToView22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
,;N3,;N3,;N3,;N3,;N3,;N3,;N3,3H<P38;M3P,H2@^GA(VEQHQCP0KA D<[&-%XU=WST%BN#D!!GQ$TD@(IBP\BQF(A@PDA@T-FPCX+G1,W@PDA@PDHAT23
@[N3,;N3,;N3,;N3,;N3,;LA&1!!^,0F3@PDA,;N3,;N3,;HA@PF)@Y,0W[LA,0F3,;N3,;N3,;J1+:0A) FWK523@[LA,0@@@@@@@@@@@@B&@ZXA%25Z,;N3
,;L@^G!!8^G!!8^G @(:N ''YD*V[N3,;N3@G DA@PDA@Q8@JN!!''Y*MJE"3,;N3,0A8^@PDA@Q8^@B](Y6Z#RYV,;N3,;L@^G!!8[G!!8^G @&)*V%H %U[N3,;N3
@G!!8^F18^G!!8@I*V%IJEIER3,;N3,0@C@0M,@0M8^@BT%)RR!!RIS,;N3,;L@@0LC@0LC@0L@$)JO#(H"T+LA,0F1@@@@@@@@@@@@@IHA# FAH%F3@[LA,Z*''
)JJ^&)"T$(>N@X8A RIO,0F1@PDA):R"'')*X%IHA@PFI@W<"S*4A*J^''):^''$9BL"(^D#8>O @E>H"&-@PDA@PF'')9NP#H*G!!@DA@PDA @<)R$!!GQTD?OS$8
MSL.I2H"H"H"H"HO,;N3,;N3,;N3,;N3,;N3,;N3,;N3,0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 50 164 0 50 171 0 137 0 0 206 0 1 50 177 2 56 178 3 64 241 3 67 246 3 73 255 4 74 255 5 63 191 7 66 194 10 71 196 10 79 255 12 59 167 12 82 255 14 77 199 18 83 201 19 88 255 21 91 255 23 89 204 27 95 206 28 97 255 29 72 179 30 100 255 32 101 209 36 106 255 36 107 211 39 109 255 41 113 214 45 115 255 45 119 216 48 118 255 50 87 176 50 125 219 51 88 176 51 88 177 52 89 178 52 90 178 53 90 178 53 127 212 54 91 179 54 123 255 54 131 221 55 92 180 55 95 181 56 93 180 56 94 181 57 127 255 57 149 229 58 99 184 58 137 224 61 104 187 63 132 255 63 143 226 64 108 190 66 113 193 66 135 255 67 149 229 68 157 232 69 117 196 71 155 231 72 122 199 72 141 255 75 126 202 75 144 255 75 160 234 77 163 236 78 131 206 80 149 255 81 136 209 84 140 212 84 153 255 87 145 215 88 157 255 91 168 235 93 161 255 94 154 222 96 157 223 96 165 255 97 159 225 98 160 225 98 162 226 99 163 227 100 165 228 101 166 229 101 170 255 102 167 230 103 169 231 104 170 232 104 173 255 105 172 233 105 174 234 106 175 235 109 178 255 112 180 255 117 186 255 119 187 255 122 154 245 125 160 253 125 193 255 126 161 253 126 194 255 127 162 254 130 165 254 132 200 255 132 201 255 133 60 36 135 170 255 139 207 255 140 175 255 144 179 255 149 184 255 153 188 255 157 192 255 162 196 255 166 200 255 170 204 255 174 208 255 174 218 230 177 212 255 181 215 255 185 219 255 188 222 255 191 225 255 212 211 224 218 217 230 219 219 230 220 220 231 222 221 232 223 223 233 225 224 234 225 225 234 226 226 237 227 226 235 227 227 236 227 227 238 228 228 237 229 229 239 231 230 238 231 231 238 231 231 240 232 232 241 233 232 239 233 233 240 234 234 242 235 234 241 236 236 243 237 236 242 237 237 244 238 237 243 238 238 244 239 238 243 239 239 245 240 239 244 241 240 245 241 241 246 241 241 247 242 242 246 242 242 247 243 243 247 243 243 248 244 244 248 244 244 249 245 244 247 246 246 249 246 246 250 247 246 249 247 247 250 248 248 251 249 249 250 249 249 251 250 250 251 250 250 252 251 251 252 251 251 253 253 253 254 254 254 255 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????????@@@C');
                            yourself);
                yourself
        ]
!

history22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self history22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#history22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class history22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ATUEQTUEQTUE@@@@@@@@@@@@@@@@@@UGQ4]DPP''I!!TT@@@@@@@@@@@@@@@@EQ4]GP$K@"XUG!!PT@@@@@@@@@@@@@AT]GQ4IDPX&EAPTEAP@@@@@@@@@@@@U
GQ4]C1DEI!!<\HQP^EAP@@@@@@@@@EQ4]GQLIFQ,%E!!\TEAPTE@@@@@@@@AT]GQ4]BRH&@0 UEA0!!EA8TE@@@@@@UGQ4SDPP(D"PMA1PVE1PTEAPT@@@@EQ4S
C1 [G0(RH2PTBATTGBDTG!!P@@AT]GQDZF08PB DRE@4GEAXWEAPTE@@UGP<LAPX&C!!< D!!P#IAPHEQP\HQP@EQ4@H TFI 8(B DT@QHTCP\TE!!\T@AT]ABHE
F!!,NJ@(AEB@REBL$E@ UE@@UGRHYF XBC!!<J@QPJ@QPAD!!PMA1P@EP$"H TFI 8(B DTB DTHAHTH2PT@APTEAPTEAPTEAPTE@(AE@(AE@DRE@@@@@@UBRH"
APX&C" J@QPJ@QP D!!P@@@@@EAPTEAPTEAPTEAPTB DTB DT@@@@@@@@@ATIH"HEA"XNJ@(AE@(AE@@@@@@@@@@TEAPTEAPTEAPTEAPJ@QP@@@@@@@@@@@@@
EP$"H TFI 8(B DT@@@@@@@@@@@@@APTEAPTEAPTEAPTE@@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_<@@_>@@_? @_?0@_?<@_?>@_?? _??0_??8_??<_??<_??<_??<_??<_??<_??<C??<C??<@_?<@_?<@C?<@C?<') ; yourself); yourself]
!

history22x22Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self history22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#history22x22Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class history22x22Icon2'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ATUEQTUEQTUE@@@@@@@@@@@@@@@@@@UGQ4]DPP''I!!TT@@@@@@@@@@@@@@@@EQ4]GP$K@"XUG!!PT@@@@@@@@@@@@@AT]GQ4IDPX&EAPTEAP@@@@@@@@@@@@U
GQ4]C1DEI!!<\HQP^EAP@@@@@@@@@EQ4]GQOW5=_W51\TEAPTE@@@@@@@@AT]GY!!9Z]_Q/9SV!!FP!!EA8TE@@@@@@UG_RCSU6]=6W^Y&60ZAPTEAPT@@@@E]*=
RT_(,/M#9"9Z983_GBDTG!!P@@KRA[MJK-%Y42^JP#%''_\QXWEAPTE@BUO/D<)[GC*=&#"TU^87?_EQP\HQSW(CT7S9==1G",J<6)-TY>\P\TE!!\T5>WTP<.<
-:J[!!7O6+35:''''D$E@ UEM]KT26>!!)23;VBR0G[.0/U1D!!PMA1SW)NA0%4D;"F?\ .R(672Z\QHTH2PT5502\$1;)<_,V9$4LUS07WDAE@DREM_J$= :X)X8
P,UH.;''U$UC_@QP D!!P@TZ[)#X)NPET/.''T634P3B DTB DT@H=WVK!!7N^E!!J.J-:8WHT@(AE@(AE@@@LL;SO4+A;6-''[*9_*!!PTEAPJ@QP@@@CSZ%K*4JG5
3O"@+ TFI 8(B DT@@@@@@AR\WE1\WG8EAPTEAPTEAPTE@@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 0 0 0 210 226 249 14 16 17 130 130 154 76 115 210 167 187 210 222 247 254 128 128 152 123 181 246 200 202 216 55 55 77 146 201 252 218 219 227 149 200 245 134 176 227 202 241 254 206 236 248 133 192 249 133 190 249 167 214 246 95 162 248 224 220 226 182 182 198 219 243 254 120 179 246 209 246 254 122 178 238 122 120 149 140 184 216 117 135 177 200 208 222 189 232 254 227 226 232 163 169 189 209 206 211 119 179 248 219 216 224 206 242 254 169 220 254 102 100 129 137 139 160 121 121 141 170 189 222 99 167 248 233 253 254 233 251 254 131 131 154 188 185 200 159 163 188 178 182 200 176 225 254 182 181 194 218 218 226 122 159 211 83 82 110 2 3 4 175 181 230 164 214 252 185 202 233 123 123 149 190 198 218 201 198 209 150 161 182 87 87 107 177 177 192 69 69 86 163 171 198 228 227 232 168 167 183 125 129 154 60 64 67 82 134 224 56 57 73 103 158 228 46 60 73 197 213 241 187 235 254 97 160 245 162 190 213 214 254 254 163 163 181 77 115 189 143 197 247 76 111 188 194 236 254 149 145 167 111 110 133 57 57 80 183 184 197 46 62 79 182 182 196 124 124 149 122 120 147 142 197 249 18 22 25 71 92 110 44 54 57 181 231 254 194 227 247 92 92 114 142 178 219 141 178 218 139 139 160 198 243 254 112 117 150 68 90 110 213 210 216 170 170 187 168 168 185 187 230 253 103 160 240 166 166 183 168 220 254 137 135 161 116 145 160 134 191 247 206 209 222 153 150 170 184 230 253 184 183 197 162 162 182 164 208 230 158 188 201 201 198 207 202 242 254 178 177 191 163 214 252 102 164 245 145 192 231 13 13 19 219 248 254 160 194 206 169 207 228 124 123 151 144 200 253 123 123 150 209 241 254 228 238 243 62 76 90 169 169 185 128 185 247 226 249 254 178 226 253 179 183 198 142 200 254 206 241 254 167 215 252 166 215 251 192 192 204 116 163 235 189 188 201 94 134 177 179 187 201 57 95 187 213 242 254 203 243 254 203 241 254 136 136 162 170 218 248 82 81 109 210 232 251 153 153 172 154 208 252 129 128 155 36 47 57 110 110 133 106 123 162 160 159 182 200 197 208 171 191 219 166 166 181 191 201 222 107 158 222 141 141 163 192 191 203 142 169 210 224 254 254 167 168 185 71 131 236 47 63 77 127 123 149 196 197 210 159 158 177 177 192 221 241 254 254 221 254 254 166 166 187 65 98 134 201 198 208 195 221 235 178 177 192 201 216 231 192 195 209 155 154 176 118 133 166 153 196 220 55 51 48 39 88 214 151 154 195 94 120 172 181 195 221 171 171 188 149 158 216 167 167 184 146 146 170 154 206 247 189 200 222 105 105 133]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_<@@_>@@_? @_?0@_?<@_?>@_?? _??0_??8_??<_??<???<???<???<???<???<???<_??<_??<O??<G??<A??<') ; yourself); yourself]
!

image22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self image22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#image22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class image22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@LC@0LC@0LC@0LC@0LC@0LC@@@@@@@C@0LC@0LC@0LC@0LC@0LC@0@@@@@@
@0LC@ HB@ HB@ LC@0LC@0L@@@@@@@LC@ HB@ HB@ HB@0LC@0LC@@@@@@@C@ HB@ HD@ HD@ HC@0LC@0@@@@@@@0HB@ HB@ HB@ HB@ LC@0L@@@@@@@LB
A@HB@ HB@ HB@ HC@0LC@@@@@@@C@ HB@ HBA@HD@ HB@0LC@0@@@@@@@0HB@ HD@ HB@ HB@ LC@0L@@@@@@@LB@ HB@ HB@ HB@ HC@0LC@@@@@@@C@0HB
@ HB@ HD@ HB@0LC@0@@@@@@@0HD@ HB@ HB@ HB@ LC@0L@@@@@@@LB@ HB@PDA@ HB@0LC@0LC@@@@@@@C@0HB@ HA@PHB@0LC@0LC@0@@@@@@@0LC@0LC
@PDC@0LC@0LC@0L@@@@@@@LC@0LC@0DA@0LC@0LC@0LC@@@@@@@DA@PDA@PA@PPDA@PDA@LC@0@@@@@@A@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 87 87 87 133 60 36 0 206 0 174 218 230 0 137 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3@@@C');
                            yourself);
                yourself
        ]
!

imageEditor22x22Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageEditor22x22Icon3 inspect
     ImageEditor openOnClass:self andSelector:#imageEditor22x22Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class imageEditor22x22Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@D)GRAH@@@@@@@@@@@@@@@@@@@@@@C8PZB\*N@@@@@@@@@@@@@@@@@@@@@A-G%MQS@\@@@@@@0LC@0LC@0LC@0L9VRETN 0*@@@@
@@LC@0LC@0LC@0LCXQ5&C48K@@@@@@@C@0LB@ HB@ HC@1,#Z30_QP@@@@@@@0LB@ HB@ HD@$DVOT<S[@@@@@@@@@LB@ HBA@HB@ H7UQ$?Z!!0@@@@@@@@C
@ HB@ HB@ I\H%YDV5@C@@@@@@@@@0HB@ HB@ HDFDHMI$-I@0@@@@@@@@LB@ HB@ PBISQCX 8/@0L@@@@@@@@C@ HBA@HB@&A_LP((Y0LC@@@@@@@@@0HB
@ HB@"8UF&M$A#HC@0@@@@@@@@LC@ HB@ IRKST3N58C@0L@@@@@@@@C@ HB@ HBSR@QBFU]@0LC@@@@@@@@@0HB@ DA@R$''EA\+@0LC@0@@@@@@@@LC@ HB
@PD,I6%Z@0LC@0L@@@@@@@@C@0LC@0DAL@%F@0LC@0LC@@@@@@@@@0LC@0LA@SX$@0LC@0LC@0@@@@@@@@LC@0LD@PE@@0LC@0LC@0L@@@@@@@@C@0PDA@PD
A@PDA@PC@0LC@@@@@@@@@0PDA@PDA@PDA@PDA@PC@0@@@@@@@@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 87 87 87 133 60 36 0 206 0 174 218 230 0 137 0 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:22;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@C0@@G8O??8O??8O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0@@@@@@@@');
                            yourself);
                yourself
        ]
!

loadFromFile22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self loadFromFile22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#loadFromFile22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class loadFromFile22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BF''(^H@@@@@@@@@@@@
@@@@@@@@@@BF%IFK#8P@@@@@@@@@@@@@@@@@@@B_!!)F@ (J#(0@@@@@@@@@8B0,0L@^_*Z&Q 8J$#((@@@@@@@@GA!!L$H(ZY*:^[%XNB)G6#(0@@@@@@A2 (
JJJ# IY?&9VC *RP_Y4@@@@@@E((X9I;%)ZV_9.U 8JM)HXCM&5 @@@!!L72A%)ZV%''>[%XNL)(XCO3<?X@@@HQQK_IZVBP$G]''Y6]''XSD6=/O0D@@BE3XW0O
BP9#X6M#IBP(JC<_YR(@@@AFZ4)QK&8<N3, HB@3L68JO1\@@@@@QUD%W4\ \2@ RD +EAHR]Q(,@@@@@GDUL''P U3EHLT!!UUT!!UUR=8I0@@@@@MNQ$[W"M*
\@T^APUS^T5$M@@@@@@@CWYP^U%YVQ0\Y34XOTP7U @@@@@@@@L>WT1LI$0&X$9&VAXQ[@@@@@@@@@A\P$QRPF!!2BG]AJT$@@@@@@@@@@@@@RTM)GS(BD@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 166 166 166 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 0 0 0 226 226 226 181 181 181 231 231 231 144 144 144 252 252 255 246 246 246 211 211 211 234 234 251 239 239 254 120 120 120 240 240 240 195 195 195 130 130 130 135 135 135 93 93 93 114 114 114 219 219 219 224 224 224 219 219 219 238 238 253 224 224 224 229 229 229 243 243 255 159 159 159 143 143 143 134 134 134 242 242 255 255 255 255 168 168 168 123 123 123 138 138 138 91 91 91 248 248 255 135 135 135 107 107 107 133 133 133 138 138 138 83 83 83 161 161 161 172 172 172 172 172 172 232 232 232 135 135 135 201 201 201 253 253 255 121 121 121 231 231 231 46 46 46 206 206 206 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@A8@@C<@@G>@O?>@_??@_??@_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

loadFromMethod22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self loadFromMethod22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#loadFromMethod22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class loadFromMethod22x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4/A0\GOS4=OS4=OS4=
OS4=OS4=OS4/A6X?QPL=OS4=OS4=OS4=OS4=OS4IK6ZETE@^G#4=OS4=OS45KR43L3DIQTVE!!UAOT@D=OS4=OS41M&Q? "<IM8RE!!XVES4T^G#4=OS4=LXFA
 Q8^YXVE!!X^E!!T=EQP@=OS4=OSJA_!!AE!!HVE!!X^G!!8VES2<[K"P#OS4,_BX<!!HVE!!X^G!!8^EM2<[X&I"H34=KG]8I(RDP$H1Q$YFQ$Y$YHNCX X=OR1!!\"X>
P$5>_''9>_7>A VJ@S!!X=OS4!!\U9XN''59^0I6]''XB@!!E_X"H=OS4=HE!!+NU%6XPI6@&@B]0I:SDPXOS4=OQ=SRQ%6WQDB\@HB]PHQ]T,TN34=OS4ZRCAJU6$B
V69\[&8B[7P4GS4=OS4=F$X''[5TQ@%YVZE),V&5CB34=OS4=OQ,*PUIRY5I''UD\8JAHNC34=OS4=OS4\DV5QPB,SB  LERT=OS4=OS4=OS4=IPHEA@4WJS4=
OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OP@a');
                colorMapFromArray:#[ 111 104 104 112 112 112 127 80 40 127 120 120 128 96 64 128 104 48 128 120 112 128 128 128 143 104 64 143 136 136 144 112 48 144 112 72 144 112 88 144 112 96 159 112 64 159 120 88 159 152 152 160 120 40 160 120 56 160 136 48 160 136 88 160 136 120 160 144 104 160 144 128 160 152 112 160 160 160 175 136 104 175 136 112 175 136 120 175 152 128 175 168 168 176 136 96 176 144 96 176 152 96 176 152 112 176 152 120 176 160 112 176 168 152 176 176 176 191 144 64 191 152 56 191 168 160 192 144 48 192 160 56 192 160 104 192 176 144 192 176 152 192 192 192 207 160 64 207 168 112 207 176 112 207 176 120 207 184 112 207 184 128 207 192 160 207 200 200 208 176 72 208 176 80 208 176 104 208 192 184 208 208 208 223 184 88 223 192 104 223 216 216 224 192 64 224 192 112 224 192 128 224 200 104 224 208 168 224 224 224 239 192 96 239 208 72 239 208 104 239 208 112 239 208 144 239 216 152 239 216 168 239 224 176 239 232 200 239 232 232 239 232 248 240 208 56 240 208 64 240 208 120 240 216 72 240 216 80 240 216 88 240 216 112 240 216 136 240 216 176 240 224 88 240 224 112 240 224 120 240 224 136 240 224 144 240 224 184 240 232 144 240 232 160 240 232 208 240 240 168 240 240 208 240 240 240 240 240 248 255 208 64 255 216 88 255 216 112 255 216 120 255 216 136 255 224 96 255 224 104 255 224 120 255 224 128 255 224 144 255 224 152 255 224 160 255 232 120 255 232 128 255 232 152 255 232 168 255 232 176 255 232 184 255 232 192 255 240 176 255 240 184 255 240 192 255 240 200 255 240 208 255 240 216 255 240 224 255 248 216 255 248 224 255 248 240 255 248 248 168 216 224 0 136 0 0 204 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@A8@@C<@@G>@O?>@_??@_??@_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

loadImageFromFile22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self loadImageFromFile22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#loadImageFromFile22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class loadImageFromFile22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4/A0\GOS4=OS4=OS4=
OS4=OS4=OS4/A6X?QPL=OS4=OS4=OS4=OS4=OS4IK6ZETE@^G#4=OS4=OS45KR43L3DIQTVE!!UAOT@D=OS4=OS41M&Q? "<IM8RE!!XVES4T^G#4=OS4=LXFA
 Q8^YXVE!!X^E!!T=EQP@=OS4=OSJA_!!AE!!HVE!!X^G!!8VES2<[K"P#OS4,_BX<!!HVE!!X^G!!8^EM2<[X&I"H34=KG]8I(RDP$H1Q$YFQ$Y$YHNCX X=OR1!!\"X>
P$5>_''9>_7>A VJ@S!!X=OS4!!\U9XN''59^7-6]''Y<_G5_X"H=OS4=HE!!+NU%6XWY6XFA#]7):SDPXOS4=OQ=SRQ%6WWA \FA5]VA5]T,TN34=OS4ZRCAJU6%*
V69\[&93[7P4GS4=OS4=F$X''[5UUUUYVZE),V&5CB34=OS4=OQ,*PUIRY5I''UD\8JAHNC34=OS4=OS4\DV5QPB,SB  LERT=OS4=OS4=OS4=IPHEA@4WJS4=
OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OP@a');
                colorMapFromArray:#[ 111 104 104 112 112 112 127 80 40 127 120 120 128 96 64 128 104 48 128 120 112 128 128 128 143 104 64 143 136 136 144 112 48 144 112 72 144 112 88 144 112 96 159 112 64 159 120 88 159 152 152 160 120 40 160 120 56 160 136 48 160 136 88 160 136 120 160 144 104 160 144 128 160 152 112 160 160 160 175 136 104 175 136 112 175 136 120 175 152 128 175 168 168 176 136 96 176 144 96 176 152 96 176 152 112 176 152 120 176 160 112 176 168 152 176 176 176 191 144 64 191 152 56 191 168 160 192 144 48 192 160 56 192 160 104 192 176 144 192 176 152 192 192 192 207 160 64 207 168 112 207 176 112 207 176 120 207 184 112 207 184 128 207 192 160 207 200 200 208 176 72 208 176 80 208 176 104 208 192 184 208 208 208 223 184 88 223 192 104 223 216 216 224 192 64 224 192 112 224 192 128 224 200 104 224 208 168 224 224 224 239 192 96 239 208 72 239 208 104 239 208 112 239 208 144 239 216 152 239 216 168 239 224 176 239 232 200 239 232 232 239 232 248 240 208 56 240 208 64 240 208 120 240 216 72 240 216 80 240 216 88 240 216 112 240 216 136 240 216 176 240 224 88 240 224 112 240 224 120 240 224 136 240 224 144 240 224 184 240 232 144 240 232 160 240 232 208 240 240 168 240 240 208 240 240 240 240 240 248 255 208 64 255 216 88 255 216 112 255 216 120 255 216 136 255 224 96 255 224 104 255 224 120 255 224 128 255 224 144 255 224 152 255 224 160 255 232 120 255 232 128 255 232 152 255 232 168 255 232 176 255 232 184 255 232 192 255 240 176 255 240 184 255 240 192 255 240 200 255 240 208 255 240 216 255 240 224 255 248 216 255 248 224 255 248 240 255 248 248 168 216 224 0 136 0 0 204 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@A8@@C<@@G>@O?>@_??@_??@_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

loadImageFromMethod22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self loadImageFromMethod22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#loadImageFromMethod22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class loadImageFromMethod22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4@@@@@@C4=OS4=OS4=OS4=OS4=OS4=@@@@@@@=OS4=OS4=OS4=OS4=OS4=@@@@@@@@OS4=OS4/A0\?OS4=OS4=OP@@
@@@@@@@=OS4/A6X?G#<=OS4=OS4@@@@@@@@=OS4IK6ZE!!E@^O34=OS4=OP@@@@@@@@@IQTVE!!XQOT@$=OS4=OP@@@@@@@B<IM8RE!!XVE!!DT?BS4=OS4@@@@@
@A8^YXVE!!X^E!!T>DQS<IOS4=@@@@@AAE!!HVE!!X^G!!8VE!!D<?I @@OP@@@BX<!!HVE!!X^G!!8^E!!XRDI @@@C4@@@@@I(RD!!XVG!!8^G!!XRDI @@@@@=@@@@@BX<
!!HREB(^G!!XQPI @@@@@=OPBI"X&II#2D!!HVE!!TUPI(&I"X&I"S4@"X2L#H0&!!HRD!!TUPK82L#H2L"8$=@H&L"H"H"BYE!!DT/K8"H"H"H"H*IOPBI#H"H"(*J
"(*J"(*J"(*J"H"J"S4@"X2H"H"H"H"H"H"H"H"H"H"H"($=@H&L"H"H"H"H"H"H"H"H"H"H"H*IOPBI"8*J"(*J"(*J"(*J"(*J"(*J"S4@"X&I"X&I"X&I
"X&I"X&I"X&I"X$=@@@@@@@@@@@@@@@@@@@@@@@@@@@=OP@a');
                colorMapFromArray:#[ 111 104 104 112 112 112 127 80 40 127 120 120 128 96 64 128 104 48 128 120 112 128 128 128 143 104 64 143 136 136 144 112 48 144 112 72 144 112 88 144 112 96 159 112 64 159 120 88 159 152 152 160 120 40 160 120 56 160 136 48 160 136 88 160 136 120 160 144 104 160 144 128 160 152 112 160 160 160 175 136 104 175 136 112 175 136 120 175 152 128 175 168 168 176 136 96 176 144 96 176 152 96 176 152 112 176 152 120 176 160 112 176 168 152 176 176 176 191 144 64 191 152 56 191 168 160 192 144 48 192 160 56 192 160 104 192 176 144 192 176 152 192 192 192 207 160 64 207 168 112 207 176 112 207 176 120 207 184 112 207 184 128 207 192 160 207 200 200 208 176 72 208 176 80 208 176 104 208 192 184 208 208 208 223 184 88 223 192 104 223 216 216 224 192 64 224 192 112 224 192 128 224 200 104 224 208 168 224 224 224 239 192 96 239 208 72 239 208 104 239 208 112 239 208 144 239 216 152 239 216 168 239 224 176 239 232 200 239 232 232 239 232 248 240 208 56 240 208 64 240 208 120 240 216 72 240 216 80 240 216 88 240 216 112 240 216 136 240 216 176 240 224 88 240 224 112 240 224 120 240 224 136 240 224 144 240 224 184 240 232 144 240 232 160 240 232 208 240 240 168 240 240 208 240 240 240 240 240 248 255 208 64 255 216 88 255 216 112 255 216 120 255 216 136 255 224 96 255 224 104 255 224 120 255 224 128 255 224 144 255 224 152 255 224 160 255 232 120 255 232 128 255 232 152 255 232 168 255 232 176 255 232 184 255 232 192 255 240 176 255 240 184 255 240 192 255 240 200 255 240 208 255 240 216 255 240 224 255 248 216 255 248 224 255 248 240 255 248 248 168 216 224 0 136 0 0 204 0 32 223 32 64 64 64 16 111 16 170 170 170 199 247 199 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@A8@@C<@@G>@@O>@@??@A?? C?? G??@C?>@C?<@_??8_??8_??8_??8_??8_??8_??8_??8@@@@');
                            yourself);
                yourself
        ]
!

make22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self make22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#make22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class make22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@DA@PDA@PD@@@@@@@@A@PDA@PDA@P@A@PDA@PDA@@@@@@@@@PDA@PDA@PD@@PDA@PDA@P@B@0P@@@DA@PDA@PDA@@DA@PDA@PTFA0 IB ,LCPDA@PDA@P@A
@PDA@P8LC@,LC1@QC1HA@PDA@PDA@PDA@PDCD1LSD1LSD1LTEQXA@PDA@PDA@PDWFA$YFQLZFQ$YF1$SG@DA@PDA@Q4^G2@!!F2H#IBT&HRD!!D2\A@PDA@PDX
G1<_G2 )@@DAJ",_HR0A@PDA@PDAKR8/LCD''@@@A@SH3LA<4MPDA@P@@@@@6M3 9@PDA@PDAN#,8NBX5@PD@@A4<OS4=O DA@PDA@SX?OS5@MPDA@@AAP$MC
OTPA@PDA@SH3OS=EQ DA@P@@Q4!!IP4MJ@PDA@PEKSDMCSPDA@PD@@@ANM$=PTUHA@PESUEAPTE@5@PDA@@@@UUYWU5]XVU%ZV5AWWE1]@PDA@PD@@EU^U5]W
U5]XU5]WU5= XPDA@P@A@@@@X&L6YFQ$YFQ$YFQ%@@@A@PD@@P@@@@A&N&]''ZF]''ZV)$W0@@@PDA@@D@@@@@@TE+R ]''Y61-[ @@@@DA@P@A@@@@@@DA[4Y0
\S9!!@@@@@@@A@PD@\''I2\''I2\''HA@PE2\''I2\''I2@PDA\ @a');
                colorMapFromArray:#[ 240 240 224 240 232 224 176 184 208 143 144 200 143 144 208 175 176 216 207 200 224 144 160 192 111 112 208 111 104 208 128 136 184 143 152 200 112 112 208 175 168 216 128 144 200 112 112 216 127 128 208 112 120 208 111 104 168 127 120 216 127 120 176 160 176 208 192 200 224 208 208 232 144 160 200 127 120 224 127 120 208 128 128 224 208 208 216 175 176 208 143 144 216 143 136 232 128 136 224 128 128 232 112 112 176 143 136 152 176 176 184 160 168 192 143 136 216 160 160 168 112 112 168 191 184 184 175 176 200 143 144 224 127 120 144 207 200 208 144 152 208 143 144 240 143 136 240 128 128 208 223 216 232 144 160 208 159 152 216 191 184 192 159 168 200 144 144 232 144 144 248 127 120 168 159 168 208 144 144 240 144 152 224 159 152 248 144 144 168 159 152 240 143 136 208 160 168 200 159 152 232 160 160 248 160 160 184 128 128 160 176 176 176 192 200 208 144 144 192 159 160 232 160 160 200 175 184 208 159 160 224 176 176 216 208 216 216 160 168 240 175 168 248 160 160 232 223 216 224 192 200 216 159 160 208 160 176 200 160 168 224 176 176 248 176 176 240 224 224 240 176 184 216 159 168 216 175 168 240 143 136 192 175 176 240 143 136 160 191 184 200 175 168 176 159 160 192 159 152 192 191 184 248 175 168 208 176 184 200 192 192 248 176 184 240 160 160 208 175 176 232 191 184 232 144 144 160 175 176 184 159 152 160 192 200 200 176 176 192 144 152 176 239 232 224 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C@@@C@G@C@_<C@?<C@??CA??#G??#G<_CG8O#C0O3O0O3O0_#O0_CG8?#G??CG??CC?<CA?<C@?8C@_ C@@@G');
                            yourself);
                yourself
        ]
!

newBookmark22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newBookmark22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#newBookmark22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class newBookmark22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@C<?C <OO3<?O3=APSM@O3<@@@@@@@@?N@8OW DAO3ISPSL3L5@?@@@@@@@@XF@;AA4B@CIOI1)QM 03T@@@@@@@@@XGH%PPQR%_MU4*JG])ZU@@@@@@@@@F
YC1!!@3\\QA-CCW]4]6%P@@@@@@@@O19WG4X+DT]7]1)7\7]P]7\@@@@@@C<YU$$EX%U7[7%7^WI9]7%/]0@@@@@?O0-JD6L.M'']0^GU.]W!!0]0@@@@@@O3<?
ZB<UBFU1]7%.]&99]0@@@@@@@C<?O3=(H1XIZ7]9[''Y.^W\@@@@@@@@?O3<?O40>QW]0^GU.]W!!0]0@@@@@@O3<?O3<%LW]/^W]9\''%7^V=7@@@@@C<?O3<?
O49-]7],]7M7O7]7@@@@@@@?O3<?O3<?FE@?O7]4]3<?@@@@@@@@O3<?O3<?O5APO3<?]3<?O0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 237 93 63 240 72 43 255 96 56 255 110 74 255 125 93 255 116 81 244 165 152 255 175 155 255 102 64 255 95 55 96 57 66 215 109 88 224 81 58 255 52 2 230 114 94 241 101 71 255 107 70 255 94 54 255 87 44 255 136 106 255 61 12 255 113 78 255 104 67 252 101 65 208 79 60 223 96 73 255 55 5 255 71 26 255 92 51 255 105 68 252 134 104 255 138 109 255 58 8 255 80 37 255 186 169 255 130 99 255 100 62 190 136 133 236 53 17 255 56 6 255 70 24 255 89 47 255 51 1 255 104 66 255 64 17 255 67 20 255 99 60 255 164 142 109 41 45 252 109 74 197 81 70 241 57 15 255 57 7 255 68 22 255 90 48 255 101 63 236 144 129 255 75 30 255 77 33 255 167 145 255 180 162 255 63 15 255 108 72 255 255 255 159 49 39 241 51 8 255 52 1 255 61 13 255 81 38 255 98 59 255 111 75 255 85 42 255 87 45 255 162 139 255 183 164 255 73 28 238 109 78 120 41 44 212 97 79 248 64 20 77 77 77 255 84 41 255 97 58 247 36 9 255 129 98 255 97 57 252 170 150 255 181 162 255 83 40 255 76 32 120 45 46 220 64 38 252 51 2 255 58 9 239 97 68 241 73 37 241 132 110 255 128 96 255 106 69 255 109 72 255 178 158 255 93 52 255 86 43 114 46 52 212 117 99 248 53 7 223 191 95 239 224 223 255 239 176 240 240 191 255 248 200 255 248 24 255 248 88 240 240 240 255 248 152 255 248 96 255 248 48 255 248 176 255 248 248 240 144 24 255 248 136 240 208 24 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@A0^@C=?@G?? G?? G?? C??0C??8A??0@?? @_? @O?0@O?8@G>0@CN@@CD@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

newDirectory22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self newDirectory22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#newDirectory22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary newDirectory22x22Icon'
        ifAbsentPut:[(Depth8Image width:22 height:20) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@HL@@@@@@@@@@@@@@@@@@@@@@@@@@HN@ 0@@@@@@@@@@@@@@@@@@@@BC 0BC_8L@ 8L@@@@8B0,0L@\@@@BC^8VC!!W:E 8U; 0@G
A!!L$H" 0LC@0LHM=!!HE< XQ= 0@@A2 (JB (X6M.[&83 8U< ''2E 0@@@E((X3M.[#L3N3-[R8NE_HI<!!XM @@@!!L5,3N3-KKQP5EHM=!!HE< XQ= 0@@HQQK
KQP BP$G](M;!!XNE_(VC!!W.C@BE3XVDOBP9#X6M# 8L( 7>CYXNC@@AFZ4)QK&8<N3, HB@3L8N@ 1\@@@@@QUD%W4\ \2@ RD +EAHR 1(,@@@@@GDUL''PJ
U3EHLT!!UUT!!UUR=8I0@@@@@MNQ$[W"M*\@T^APUS^T5$M@@@@@@@CWYP^U%YVQ0\Y34XOTP7U @@@@@@@@L>WT1LI$0&X$9&VAXQ[@@@@@@@@@A\P$QRPF!!2
BG]AJT$@@@@@@@@@@@@@RTM)GS(BD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 0 0 0 255 248 24 255 248 200 255 248 88 255 248 152 255 248 96 255 248 48 255 248 176 255 248 248 240 144 24 255 248 136 240 208 24] mask:((ImageMask width:22 height:20) bits:(ByteArray fromPackedString:'@@B@@@G@@@7XO1?<_??8_??0_??8_??8_??<_??8_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@@@@@'); yourself); yourself]
!

newDirectory22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newDirectory22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#newDirectory22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class newDirectory22x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@H,@@@@@@@@@@@@@@@@@@@@@@@@@@H.G"0@@@@@@@@@@@@@@@@@@@@BK"0BK (,@"8,@@@@@@@@@@@@@@@BK^8:K#(BN"89;"0@@
@@@@@@@@@@@@@H-=#H%:"X1="0@@@@@@@@@@@@@@@@A?"89:"''*N"0@@@@@8B0,0L@\@@@@@CH.N^():#(,@@@@GA!!L$H" 0LC@0LH-=#H%:"X1="0@@A2 (
JB (X6M.[(-;#(.N H:K#''.K@E((X3M.[#L3N3-["8,T"8JKM(.K@@@!!L5,3N3-KKQP5EB@D@H.G"3<?X@@@HQQKKQP BP$G]''Y6]''XS"6=/O0D@@BE3XVDO
BP9#X6M#IBP(JC<_YR(@@@AFZ4)QK&8<N3, HB@3L68JO1\@@@@@QUD%W4\ \2@ RD +EAHR]Q(,@@@@@GDUL''P U3EHLT!!UUT!!UUR=8I0@@@@@MNQ$[W"M*
\@T^APUS^T5$M@@@@@@@CWYP^U%YVQ0\Y34XOTP7U @@@@@@@@L>WT1LI$0&X$9&VAXQ[@@@@@@@@@A\P$QRPF!!2BG]AJT$@@@@@@@@@@@@@RTM)GS(BD@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 223 191 95 128 127 112 160 144 128 175 143 112 224 223 207 255 224 127 207 192 160 207 175 112 144 112 48 224 192 128 240 224 191 192 176 144 239 224 223 175 143 111 239 224 176 223 192 111 191 175 160 159 112 64 255 240 176 240 240 208 255 239 176 240 208 127 160 127 63 176 159 112 255 224 96 207 160 64 224 208 175 239 208 144 240 223 95 128 96 64 240 224 127 255 240 224 255 239 175 192 160 111 255 255 224 255 223 112 255 240 223 255 223 143 255 208 64 208 192 191 255 255 223 160 143 127 160 144 111 240 240 175 160 159 112 240 239 176 208 176 111 239 223 159 207 176 127 255 224 144 239 208 112 255 240 192 175 159 128 240 239 175 192 176 159 224 207 111 207 191 128 239 208 111 144 112 96 255 240 191 255 239 192 240 224 95 192 144 48 240 239 208 224 192 64 144 112 95 160 127 47 127 80 47 255 224 111 176 144 96 176 159 96 240 223 176 240 239 144 176 175 159 240 224 144 255 239 191 240 208 64 255 239 128 239 208 79 223 208 208 191 144 64 240 223 143 240 208 63 255 239 127 240 240 192 255 239 159 144 112 79 240 224 143 191 159 63 240 223 80 207 176 112 240 240 191 175 143 127 224 192 112 240 223 112 208 176 80 176 159 127 255 224 160 240 223 79 255 240 208 207 191 112 239 239 207 208 176 79 255 223 95 192 160 63 128 111 48 255 223 127 255 224 159 159 127 95 176 160 112 255 240 207 255 255 240 240 224 112 176 143 96 160 143 48 240 239 160 207 160 80 239 223 175 239 192 96 143 111 64 160 143 95 255 224 128 255 248 200 255 248 24 15 56 160 255 248 88 239 232 240 240 240 240 255 248 152 48 80 176 255 248 96 48 88 176 240 240 248 207 216 240 223 216 224 255 248 48 224 224 232 255 248 176 255 248 248 240 144 24 255 248 136 63 96 184 240 208 24 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@B@@@G@@@7X@A?<@@?8@@?0O0?0_??8_??<_??8_??8_??8_??0_?? _?? _?? _??@_?>@_?<@_? @_0@@@@@@');
                            yourself);
                yourself
        ]
!

newImage22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newImage22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#newImage22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class newImage22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@@0MC@@@@@@@@@LC@0LC@0LC@0LLC@LLC 0CC@0@@@@C@0LC@0LC@0LLC1@LDADPCA@OC@@@
@0LC@ HB@ HB@ 0RD1PUEALRC@@@@@LC@ HB@ HB@ HICA@UAQTPC@@@@@@C@ HB@ HD@ HD@ 0PEPTUD@0@@@@@@0HB@ HB@ HB@ 0RD1PUEALRC@@@@@LB
A@HB@ HB@ 0OD@0PDQ@LD@<L@@@C@ HB@ HBA@HDC@0BC@8L@00L@@@@@0HB@ HD@ HB@ HB@ 0MC@L@@@@@@@LB@ HB@ HB@ HB@ HCC@LC@@@@@@@C@0HB
@ HB@ HD@ HB@0LC@0@@@@@@@0HD@ HB@ HB@ HB@ LC@0L@@@@@@@LB@ HB@PDA@ HB@0LC@0LC@@@@@@@C@0HB@ HA@PHB@0LC@0LC@0@@@@@@@0LC@0LC
@PDC@0LC@0LC@0L@@@@@@@LC@0LC@0DA@0LC@0LC@0LC@@@@@@@DA@PDA@PA@PPDA@PDA@LC@0@@@@@@A@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 87 87 87 133 60 36 0 206 0 174 218 230 0 137 0 255 248 248 207 216 240 240 240 248 239 232 240 240 240 240 48 88 176 224 224 232 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@BC_??3_??;_???_??;_??3_??3_??;_???_??;_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3@@@C');
                            yourself);
                yourself
        ]
!

newItem22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self newItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#newItem22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class newItem22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
!!P@@@@@@@@@@@@@@@@@@@@@@@@@@!!XT@@@@@@@@@@@@@@@@@@@@@@@@@@HVE@@@@@@@@@@@@@@@@@@@@0@@@@@BE!!P@@@@@@@@@@@@@@@@@@0LG@@@@@!!XT@
@@@@@@@@@@@@@LC@@LCB0@C@0HVE@K^7-;^7-;^7-<CC1LCD1\S@1LO@!!PB7-+Z6-+Z6-+Z60L[G2L''H1<[@!!XT@-;Z6-+Z6-+Z6-+7@1L&92\S@@HVE@K^6
-+Z6-+Z6-+Z60LSI.\''D0@BE!!PB7-+Z6-+Z6-+Z60L[G2L''H1<[@!!XT@.K"8.K"8.K"80LOD0LSE1LCD0<BE@@@@@@@@@@@@@@C@0@C@0,@@0LBE!!P@@@@@@
@@@@@@@@@@@@0LG@@@BE!!XT@@@@@@@@@@@@@@@@@@@C@@@@@@HVE@@@@@@@@@@@@@@@@@@@@@@@@@@BE!!P@@@@@@@@@@@@@@@@@@@@@@@@@@!!XT@@@@@@@@@
@@@@@@@@@@@@@@@@@HVE@@@@@@@@@@@@@@@@@@@@@@@@@@BE!!P@@@@@@@@@@@@@@@@@@@@@@@@@@!!XT@@@@@@@@@@@@@@@@@@@@@@@@@@HVE@@@@@@@@@@@@
@@@@@@@@@@@@@@BE!!P@@@@@@@@@@@@@@@@@@@@@@@@@@!!P@a') ; colorMapFromArray:#[64 64 64 190 120 28 223 223 232 255 230 45 187 107 15 198 129 29 248 208 38 188 188 204 255 233 38 254 192 24 182 178 92 164 150 134 190 106 11 138 79 26 207 207 219 115 109 132 212 137 29 120 120 150 248 180 21 166 97 20 245 208 41 235 178 28 153 91 27 142 82 26 195 195 210 255 218 34 160 96 27 189 189 204 164 164 186 241 241 245 207 139 30 178 110 28 239 239 243 176 110 26 255 230 37 198 108 8 158 158 180 255 220 37 129 71 26 190 120 23 127 127 156 252 168 11 181 181 199 177 177 195 255 192 17 227 227 234 126 69 26 154 92 27 242 140 1 227 168 29 143 83 26 172 106 28 133 76 26 251 214 39 192 121 21 218 141 30 186 118 25 230 170 35 151 90 27 255 223 36 224 156 29 255 160 0 213 213 223 197 125 29 255 211 36 164 98 23 130 130 158 186 118 28 184 184 201 154 89 23 176 109 28 180 180 197 249 193 30 245 162 13 253 213 37 181 99 13 166 95 18 205 205 218 147 147 171 255 235 42 211 137 29 201 201 214 199 199 212 229 161 30 183 109 18 134 77 26 172 172 192 219 142 30 169 103 27 198 126 29 222 157 26 248 186 25 177 99 15 133 133 160 189 189 205 159 96 27 187 117 28 241 241 246 149 87 27 232 138 6 255 228 38 100 100 134 250 158 7 150 150 173 156 92 27 211 142 28 255 169 5 224 161 34 121 121 151 254 254 255 252 189 25 119 119 149 208 127 15 255 242 44 90 90 127 86 86 123 209 134 29 142 142 168 140 140 166 246 190 32 240 130 0 255 223 34 139 77 23 218 153 31 192 192 207 188 188 203 243 171 19 130 125 146 250 195 29 159 159 181 211 211 222 151 85 21 203 130 29 255 255 255 136 77 26 230 156 19 255 218 30 228 228 235 221 144 30 237 180 29 237 176 29 91 91 127 154 91 27 243 200 38 234 170 26 197 197 211 220 158 32 255 191 20 133 75 26 249 249 252 218 142 30 110 110 142 202 116 11 151 89 27 211 142 23 218 218 228 197 126 29 251 156 6 211 127 13 77 77 116 255 153 0 255 151 0 255 149 0 242 149 7 215 144 30 186 117 28 129 129 157 113 93 95 181 181 198 245 163 13 137 78 26 241 181 32 164 99 26 152 152 176 231 178 32 148 148 172 183 115 28 219 142 17 205 134 23 171 171 191 127 127 127 170 170 170 0 184 184 16 228 224 0 128 120 255 248 248 207 216 240 240 240 248 239 232 240 240 240 240 48 88 176 224 224 232 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@B@@@G@_??8_??<_??8_??8_??8_??8_??<_??8@@G@@@B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

newWindowSpecIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newWindowSpecIcon inspect
     ImageEditor openOnClass:self andSelector:#newWindowSpecIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class newWindowSpecIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)_F%)ZV%)R@?EPY%C!!QKGW5ZM050ROG2<R,+KQL?Q7<>YE@6W''UIE#C1<U71<?F@<_EVVTIUSTY2U4@!!B6O1=OW1=_[5<_W4<W ^
[#I''V6@QS''1_C?G7>O'':>_#7<Q PC@0LC@0LC@0LC@3.<_W::/+5<P09V@0JB (JB (JB 0LB/G5>.+:=_DLT"XLB 0LC@0LC@$LCOG7>O'':>_#7<S,''C@(L
C@0LC@0ICOG4=_G5=/W1=_S1[@0JC@0LC@0LBP0L<_DL<_O1COG1OF4LBP$IBP$IBP$LC@$IB_G2<P$ICBP(C@0LC@0LC@0LC@0LC@0L<P0LC@1*[00IBP$I
BP$IBP$IBP$IBP$IBP$LOWDLBPLC@0LC@0LC@0LC@0LC@0HACBT*C@$C@0LC@0LC@0LC@0LC@0LB@P0%_ 0I@0LC@0LC@0LC@0LC@0LC@ DLIWLLBPHB@ HB
@ HB@ HB@ HB@ HACBUCC@$A@PDA@PDA@PDA@PDA@PDA@P0%K@0LC@0LC@0LC@0LC@0LC@0LC@0LIR0LC@0LC@0LC@0LC@0LC@0LC@0LCBT,C@0LC@0LC@0L
C@0LC@0LC@0LC@0%Y''P4MWXGBEESB@!!SH&$%IRT%IRT%Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 160 160 160 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 72 122 199 116 116 120 237 236 242 72 141 255 212 211 224 32 101 209 63 143 226 153 188 255 106 175 235 170 204 255 7 66 194 0 50 164 58 137 224 75 160 234 66 135 255 140 175 255 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 80 149 255 55 95 181 125 160 253 52 89 178 50 87 176 105 172 233 104 170 232 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 2 56 178 3 73 255 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 81 136 209 101 170 255 36 107 211 54 123 255 56 94 181 126 161 253 55 92 180 53 90 178 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 96 157 223 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 28 97 255 109 178 255 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 39 109 255 93 161 255 157 192 255 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 181 215 255 255 255 255 52 90 178 51 88 177 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 87 145 215 84 153 255 78 131 206 10 79 255 91 168 235 127 162 254 54 91 179 14 77 199 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 255 248 248 207 216 240 240 240 248 239 232 240 240 240 240 48 88 176 224 224 232 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@BC????????????????????????????????????????????????????????????????????????????????????');
                            yourself);
                yourself
        ]
!

pasteFile22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self pasteFile22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#pasteFile22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class pasteFile22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@0LC@0LBD@@@@@@EMST5MST0@@@@AEX%MST5L%D0@@@EMST5MST5L[BAU2UUL3L3L3X@42EP!!ST5MST5MSJT(/A4A(ZF!!(ZF!!@NB<=JUMST5MST4XN
C!!Q@PDA@PDA@PD NZSUST5MST5MGQDP*EAPTEAPTEAP*QB, T5MST5MSAV=/[6=/[6=/PTEAPTEAPTD?T5MST58$IBP$IBP$IDEST5L6E7A.PS=ST5MV[F1,
[F1,[F1AT5MSG2LK[$ETO5MSC5=_W5=_W5=_PUMST1<6FV8?O3<?T4<\GA0\GA0\GDEST5L-M!!!!.U5I]O5L(V5-[[QXRV%)AT5MSO!!=KS&YBP3=SN0)PG $I
BP$IPUMST5L_X68LGTD?T6DPN DA@PDA@TEST386E7D7YR\ZO5LCMF]''Y6]''Y6]AT38-RT9WH#]$YS=SLU1\WE1\WE1\PUMSM$5NKB8"A#\?T6-QTUEQTUEQ
TTESKRXXFV8,U5$7O5MLA@PDA@PDA@QAT0I#FA%.KGD"A#=SDS1*Z&)*Z&)*PULWX1!!MS"11H X?T5MXNS$9NS$9NTESX4-MFP,,U2HFO5MST5MST5MST5MA
G6M#FA%.KGD"A#=ST5MST5MST5MSO3<?O3<?O3<?O3<?T0@a') ; colorMapFromArray:#[0 0 0 238 175 55 250 250 255 146 100 44 231 151 25 187 141 61 225 225 237 139 135 136 216 146 43 240 181 63 241 206 77 236 236 244 213 213 228 139 139 162 254 252 139 157 113 54 239 199 68 123 73 37 242 189 71 125 125 151 133 132 129 217 147 43 242 193 74 245 245 252 241 241 248 239 239 246 216 216 230 214 145 43 244 218 92 210 210 224 240 186 65 252 252 255 198 144 60 136 136 161 229 229 239 248 248 254 249 235 116 151 151 172 244 244 250 219 219 232 148 104 50 204 137 42 200 195 127 253 239 126 234 234 243 253 253 255 232 232 241 244 227 137 137 137 161 146 97 41 153 126 104 245 245 247 237 182 54 204 148 58 249 249 254 224 224 236 138 134 135 144 86 32 238 180 58 147 103 48 222 140 19 232 198 98 254 254 255 156 156 182 196 196 208 208 208 223 206 206 221 204 204 219 253 246 131 126 126 152 204 151 60 198 150 64 132 131 128 246 246 253 232 198 107 242 242 249 145 89 35 240 240 247 238 238 245 149 106 52 241 204 76 233 157 32 215 215 229 255 255 255 211 211 225 139 139 164 167 122 56 230 230 240 123 73 36 228 228 238 242 187 70 243 212 84 235 163 40 201 201 218 177 131 59 246 223 100 237 237 240 147 101 46 152 152 173 243 243 249 222 222 235 220 220 233 218 218 231 236 169 47 227 227 233 254 249 137 229 145 17 145 90 37 248 229 108 242 203 79 235 235 244 251 240 124 233 233 242 231 231 240 154 127 105]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A>@@C?@@??8@??<@??<@??<@???@??? ???0???8???8???8???8???8???8???8???8???8???8_??8@G?8@G?8') ; yourself); yourself]
!

pasteItem22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self pasteItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#pasteItem22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class pasteItem22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@0LC@0LBD@@@@@@EMST5MST0@@@@AEX%MST5L%D0@@@EMST5MST5L[BAU2UUL3L3L3X@42EP!!ST5MST5MSJT(/A4A(ZF!!(ZF!!@NB<=JUMST5MST4XN
C!!Q@PDA@PDA@PD NZSUST5MST5MGQDP*EAPTEAPTEAP*QB, T5MST5MSAV=/[6=/[6=/]WU5]WU5]WU5]WU5]U8$IBP$IBP$IGUST5MST5MST5MS]GUV[F1,
[F1,[F15T7Q4]GQ4]GQ4]GM5C5=_W5=_W5=_]UM4]GQ4]GQ4]GQ3]T<\GA0\GA0\GGUS]GQ4]GQ4]GQ4\7T(V5-[[QXRV%)5T7Q4]GQ4]GQ4]GM5N0)PG $I
BP$I]UM4]GQ4]GQ4]GQ3]VDPN DA@PDA@WU4\7M3\7M3\7M3\7TCMF]''Y6]''Y6]5]WU5]WU5]WU5]WU5LU1\WE1\WE1\Z&)*Z&)*NP@@@@@@@F-QTUEQTUEQ
TV)*Z&)*Z#$@@@@@@@ALA@PDA@PDA@Q*Z&)*Z&(9@@@@@@@@DS1*Z&)*Z&)*Z&)*Z&)*NP@@@@@@@EMXNS$9NS$9NS$9NS$9NS$@@@@@@@AST5MST5MST0@@
@@@@@@@@@@@@@@@@T5MST5MST5L@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 238 175 55 250 250 255 146 100 44 231 151 25 187 141 61 225 225 237 139 135 136 216 146 43 240 181 63 241 206 77 236 236 244 213 213 228 139 139 162 254 252 139 157 113 54 239 199 68 123 73 37 242 189 71 125 125 151 133 132 129 217 147 43 242 193 74 245 245 252 241 241 248 239 239 246 216 216 230 214 145 43 244 218 92 210 210 224 240 186 65 252 252 255 198 144 60 136 136 161 229 229 239 248 248 254 249 235 116 151 151 172 244 244 250 219 219 232 148 104 50 204 137 42 200 195 127 253 239 126 234 234 243 253 253 255 232 232 241 244 227 137 137 137 161 146 97 41 153 126 104 245 245 247 237 182 54 204 148 58 249 249 254 224 224 236 138 134 135 144 86 32 238 180 58 147 103 48 222 140 19 232 198 98 254 254 255 156 156 182 196 196 208 208 208 223 206 206 221 204 204 219 253 246 131 126 126 152 204 151 60 198 150 64 132 131 128 246 246 253 232 198 107 242 242 249 145 89 35 240 240 247 238 238 245 149 106 52 241 204 76 233 157 32 215 215 229 255 255 255 211 211 225 139 139 164 167 122 56 230 230 240 123 73 36 228 228 238 242 187 70 243 212 84 235 163 40 201 201 218 177 131 59 246 223 100 237 237 240 147 101 46 152 152 173 243 243 249 222 222 235 220 220 233 218 218 231 236 169 47 227 227 233 254 249 137 229 145 17 145 90 37 248 229 108 242 203 79 235 235 244 251 240 124 233 233 242 231 231 240 154 127 105 127 127 127 170 170 170 64 64 64]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A>@@C?@@??8@??<@??<@??<@???<???<???<???<???<???<???<???<???<??<@??<@??<@??<@_?<@@@@@@@@@') ; yourself); yourself]
!

pasteWidget22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self pasteWidget22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#pasteWidget22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class pasteWidget22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@0LC@0LBD@@@@@@EMST5MST0@@@@AEX%MST5L%D0@@@EMST5MST5L[BAU2UUL3L3L3X@42EP!!ST5MST5MSJT(/A4A(ZF!!(ZF!!@NB<=JUMST5MST4XN
C!!Q@PDA@PDA@PD NZSUST5MST5MGQDP*EAPTEAPTEAP*QB, T5MST5MSAV=/[6=/[6=/@@@@@@@@@@@@@@@@@E8$IBP$IBP$I@AST5MST5MST5MS]@AV[F1,
[F1,[F0@T7Q4]GQ4]GQ4]GL@C5=_W5=_W5=_@EM4]GQ4]GQ4]GQ3@D<\GA0\GA0\G@AS]GQ4]GQ4]GQ4\0@(V5-[[QXRV%(@T7Q4]GQ4]GQ4]GL@N0)PG $I
BP$I@EM4]GQ4]GQ4]GQ3@FDPN DA@PDA@PAS]GQ4]GQ4]GQ4\0@CMF]''Y6]''Y6\@T7Q4]GQ4]GQ4]GL@LU1\WE1\WE1\@EM4]GQ4]GQ4]GQ3@F-QTUEQTUEQ
TPAS]GQ4]GQ4]GQ4\0ALA@PDA@PDA@P@T7Q4]GQ4]GQ4]GL@DS1*Z&)*Z&)*@EM4]GQ4]GQ4]GQ3@EMXNS$9NS$9NPA4\7M3\7M3\7M3\0AST5MST5MST5L@
@@@@@@@@@@@@@@@@T5MST5MST5L@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 238 175 55 250 250 255 146 100 44 231 151 25 187 141 61 225 225 237 139 135 136 216 146 43 240 181 63 241 206 77 236 236 244 213 213 228 139 139 162 254 252 139 157 113 54 239 199 68 123 73 37 242 189 71 125 125 151 133 132 129 217 147 43 242 193 74 245 245 252 241 241 248 239 239 246 216 216 230 214 145 43 244 218 92 210 210 224 240 186 65 252 252 255 198 144 60 136 136 161 229 229 239 248 248 254 249 235 116 151 151 172 244 244 250 219 219 232 148 104 50 204 137 42 200 195 127 253 239 126 234 234 243 253 253 255 232 232 241 244 227 137 137 137 161 146 97 41 153 126 104 245 245 247 237 182 54 204 148 58 249 249 254 224 224 236 138 134 135 144 86 32 238 180 58 147 103 48 222 140 19 232 198 98 254 254 255 156 156 182 196 196 208 208 208 223 206 206 221 204 204 219 253 246 131 126 126 152 204 151 60 198 150 64 132 131 128 246 246 253 232 198 107 242 242 249 145 89 35 240 240 247 238 238 245 149 106 52 241 204 76 233 157 32 215 215 229 255 255 255 211 211 225 139 139 164 167 122 56 230 230 240 123 73 36 228 228 238 242 187 70 243 212 84 235 163 40 201 201 218 177 131 59 246 223 100 237 237 240 147 101 46 152 152 173 243 243 249 222 222 235 220 220 233 218 218 231 236 169 47 227 227 233 254 249 137 229 145 17 145 90 37 248 229 108 242 203 79 235 235 244 251 240 124 233 233 242 231 231 240 154 127 105 127 127 127 170 170 170]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A>@@C?@@??8@??<@??<@??<@???<???<???<???<???<???<???<???<???<???<???<???<???<_??<@G?<@@@@') ; yourself); yourself]
!

saveAsMethod22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveAsMethod22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#saveAsMethod22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class saveAsMethod22x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MSP4L#@/KB$''IBP#H"D_GQ0@@@@@MZV"=L3Q5/S4=OS4=OS4=D@=B @@@CR!!''/SAZLG4=OSAZLG29]9@OP @@@@3
&I_40V!!(0_SAZF#A8]_SNSPG@@@@L)VQ=LE(0V#4ZLE(0]OM3Q$YA0@@@CFL"._AZOM(ZF##ZLGG3\4XF@\@@@@/!!HS''0V#3<6#34F#A3\7MEQTG@@@@K(A<
9<E(<?O3<=A(0\7M3QTUA0@@@B56\>_AZOO34MCPZLGM3\4UEP\@@@@*Z&?''9N/3<=CP4MCP4MCPEQTG@@@@JVM"9NS"7=+U4L7M3\7M3QTUA @@@B]ZV.K"
7=+T4L7H0<B))*$YFPP@@@@''UUW .;&7-KF/+*6Y"HV)FA C@@@@I$9N7=?Z5MCH0<B4))2S(1TUAP@@@BYIR]68-[J0+*6["HE9]IXUEP\@@@@%P$KZ6-SP
2K2)))2S"8^OEQTG@@@@ITA@5;Z1*:"Y$(U=]7E,#!!TUA0@@@BT<OIBP#XZC^''U+YU=\VUXTE@ @@@@@BP$IBP HB@ HB@ HB@ HB@ @@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 28 33 37 34 41 60 37 45 83 39 48 89 42 51 96 45 55 103 49 60 112 54 65 115 54 66 115 54 66 116 57 70 107 57 70 109 59 59 58 65 79 121 65 80 125 66 80 124 68 83 130 74 71 70 77 81 85 78 95 152 80 98 153 81 98 151 83 47 28 85 102 157 86 103 157 88 101 128 90 110 162 94 106 146 94 106 147 95 83 66 95 107 147 96 74 37 97 108 148 98 109 148 98 109 149 99 110 149 101 111 150 101 111 151 101 112 151 102 102 107 102 113 151 102 113 152 103 86 54 103 113 151 103 113 152 103 114 152 104 114 152 105 115 152 105 115 153 106 116 153 107 116 154 107 117 154 108 117 154 116 124 137 123 85 65 123 107 74 125 143 184 126 64 32 126 139 158 126 143 183 127 145 185 128 145 184 129 146 185 129 147 186 130 148 186 131 148 187 131 149 187 132 141 160 133 141 159 133 143 164 134 151 188 134 151 189 134 152 189 135 152 189 136 153 190 137 154 191 138 154 191 139 156 193 141 151 173 142 69 67 142 157 193 142 158 193 143 62 26 143 158 193 143 159 194 144 157 200 144 161 195 145 161 195 146 158 202 146 162 196 147 89 55 147 160 203 147 162 196 148 165 197 149 161 204 149 164 197 150 166 198 150 166 199 151 167 199 152 149 137 152 163 206 152 168 199 153 169 201 154 96 64 154 169 201 154 170 201 155 167 207 155 171 202 156 171 202 156 171 203 157 172 203 157 173 182 157 173 203 159 147 111 159 174 204 159 175 204 160 170 210 160 174 204 160 176 205 162 172 191 162 178 207 163 173 212 163 177 206 164 177 207 164 180 207 165 147 99 165 165 166 165 178 207 166 182 208 167 147 95 167 177 214 167 181 209 169 185 209 170 179 216 170 186 215 171 185 210 172 162 152 172 185 212 172 187 217 173 186 212 174 182 218 174 188 219 175 190 221 176 184 220 176 189 214 176 190 213 176 190 218 177 145 64 177 190 215 179 193 223 180 192 216 181 193 216 181 194 214 181 195 218 182 194 214 182 195 221 183 196 219 184 195 218 184 197 219 185 95 37 185 196 219 185 197 219 185 197 222 186 185 192 187 198 220 187 200 223 188 171 94 188 199 217 192 204 226 194 97 38 195 206 220 196 168 100 196 206 218 198 207 220 202 211 222 203 212 222 205 214 224 207 215 224 208 101 40 209 217 225 210 217 226 210 219 227 212 220 227 213 220 227 214 221 228 217 103 41 217 223 229 217 224 237 219 101 37 222 177 45 222 225 232 223 228 241 224 187 54 225 105 42 226 231 241 226 231 243 228 196 63 230 202 70 230 234 245 230 235 243 232 240 251 233 208 76 233 235 240 233 236 247 233 237 244 233 237 246 235 214 82 235 238 245 236 239 248 237 239 242 238 241 249 239 242 247 240 242 242 240 242 249 240 243 249 242 220 141 242 242 227 242 244 249 242 244 250 244 244 245 244 246 250 244 246 251 245 247 250 246 247 250 246 247 251 247 248 251 247 248 252 248 249 251 248 249 252 249 99 39 249 249 253 250 147 56 250 250 253 251 169 79 251 251 253 251 252 253 252 99 38 252 178 84 252 187 89 252 199 96 252 206 99 252 252 253 252 252 254 253 253 254 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@CO??#_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3O??#@@@C@@@C');
                            yourself);
                yourself
        ]
!

saveAsMethodAs22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveAsMethodAs22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#saveAsMethodAs22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class saveAsMethodAs22x22Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@00AU&9,#''W?,XSX9NPN1"&=P6P@@@@AU>L03TP^CL3L3L3L3L3L3@&:ES6H@&6''ML9]O%3L3L9]O%:]G/0I.?!!(P*BAE
D3NWS4>WL9]OS9^P<KJ:R[C4 .L#/%\3%4>WS3MO%4>W,''CD''$GA\1,*:"''1Q)]O>$=OS1QO%9"*=?IK@^G907>6-$ZWS?+:S?+JS9^79Y[UI-NR@LOFO01F
%4?:>/+:2$>WBX6;$7''!!@@CCXM=VQ)]O>/+J2,)OY,#5E*D03 @@0:/-''D[R"O+:2,+J39]6%GP0A\8@@LM!!2Z?R4+"Q0@[J-3W(V)(X6DJ_@@CCM (J.K"Q
0B0]-65C-CF%+AGQZ@@@03[\7D0Y0*ZGD.JOH($;W$Q[='',@@LN-^''*QRZZURWII!!N;#8N]X/^YN@@CC+\WE]4%I4D& RT&"O%J<Z%MS3 @@06L7M<C@KL)2
[FPK&SR9SX9ST<8@@LM#@ K021H<GO55<81TIHAJT5ON@@CCX0 H5MSWE7 2>4#$VR4.(18^)@@@00@/K2</)JR$)JR$)JR$)JR$)@@@@LL@@@@@@@@@@@@@
@@@@@@@@@@@@@@CC@@@@@@@@@@@@@@@@@@@@@@@@@@@@00@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 142 69 67 129 147 186 98 109 149 242 51 50 86 103 157 240 242 242 236 239 248 126 143 183 165 147 99 146 162 196 187 200 223 164 177 207 143 158 193 163 177 206 183 196 219 147 89 55 66 80 124 205 214 224 180 192 216 247 248 252 203 212 222 255 100 39 170 179 216 123 107 74 217 223 229 186 185 192 77 81 85 188 199 217 242 242 227 78 95 152 138 154 191 107 116 154 226 231 241 242 220 141 106 116 153 157 173 203 156 171 202 255 106 42 242 244 250 247 105 44 173 186 212 83 47 28 196 206 218 239 242 247 147 160 203 146 158 202 54 66 115 95 83 66 225 105 42 163 173 212 253 253 254 176 190 218 222 177 45 101 112 151 131 148 187 130 148 186 99 110 149 129 146 185 96 74 37 195 206 220 148 165 197 166 182 208 165 178 207 184 197 219 188 171 94 81 98 151 255 236 120 133 141 159 181 193 216 249 249 253 248 249 252 155 167 207 88 101 128 174 188 219 250 147 56 246 247 250 170 186 215 42 51 96 154 96 64 94 106 147 233 236 247 162 178 207 80 98 153 160 176 205 108 117 154 159 174 204 176 189 214 141 151 173 149 161 204 252 99 38 57 70 107 213 220 227 233 235 240 126 139 158 134 151 189 103 113 152 102 113 151 254 107 43 101 111 150 192 204 226 150 166 198 159 147 111 149 164 197 39 48 89 185 196 219 179 193 223 250 250 253 217 224 237 222 225 232 127 145 185 95 107 147 233 237 246 142 158 193 230 235 243 165 165 166 208 101 40 176 190 213 252 199 96 244 246 250 167 177 214 185 95 37 139 156 193 37 45 83 137 154 191 156 171 203 135 152 189 104 114 152 155 171 202 154 169 201 102 102 107 240 242 249 34 41 60 54 66 116 210 217 226 209 217 225 251 251 253 219 101 37 97 108 148 145 161 195 164 180 207 230 202 70 175 190 221 172 162 152 246 247 251 245 247 250 28 33 37 255 101 39 254 99 38 237 239 242 233 208 76 224 187 54 230 234 245 182 195 221 217 103 41 107 117 154 157 172 203 105 115 152 177 145 64 45 55 103 198 207 220 194 97 38 171 185 210 144 157 200 54 65 115 103 86 54 212 220 227 252 252 253 255 117 45 182 194 214 223 228 241 102 113 152 162 172 191 101 111 151 131 149 187 150 166 199 244 244 245 98 109 148 238 241 249 128 145 184 249 99 39 147 162 196 167 181 209 233 237 244 247 248 251 172 187 217 125 143 184 252 178 84 159 175 204 65 80 125 177 190 215 244 246 251 242 244 249 157 173 182 214 221 228 255 255 255 226 231 243 134 152 189 103 114 152 153 169 201 228 196 63 151 167 199 235 238 245 210 219 227 185 197 219 184 195 218 49 60 112 152 149 137 207 215 224 65 79 121 248 249 251 143 62 26 176 184 220 251 169 79 90 110 162 174 182 218 85 102 157 94 106 146 144 161 195 185 197 222 143 159 194 142 157 193 181 195 218 160 174 204 132 141 160 74 71 70 202 211 222 126 64 32 152 163 206 167 147 95 68 83 130 133 143 164 252 206 99 136 153 190 105 115 153 134 151 188 103 113 151 154 170 201 123 85 65 152 168 199 240 243 249 172 185 212 235 214 82 169 185 209 232 240 251 252 187 89 57 70 109 196 168 100 187 198 220 59 59 58 252 252 254 160 170 210 251 252 253 181 194 214 116 124 137 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C_??C???;???????????????;???3???#???#???#???#???#???#???#???#???#???#???#_??C@@@C@@@C');
                            yourself);
                yourself
        ]
!

saveImage22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveImage22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#saveImage22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class saveImage22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@BHGO3<?O3<?O3<?O3<?O3<?EB1F@CT3RR8.K"8.K"8.K"8.K"8.K!!P C",NAD$.K"8.K"8.K"8.K"8.K"8THCL+C#MIK"8;N3,;N3,;N3,;N28.EB@NJ083
RR8.K"8.K"8.K"8.K"8.K!!P OB,NL4$.K#,;N3,;N3,;N3,;K"8TC30+C#MIK"8.K"8.K"8.K"8.K"8.E@<<J083RR8.N3,;N3,;N3,;N3,.K!!POOB,NL4$.
K"8.K"8.K"8.K"8.K"8TC30EMSMIK"8.K"8.K"8.K"8.K"8.EC4*J08NA#((E!!\?O3<?O3<?O3<?F!!P!!J",5L2@=M1,AGA0\GA0\GA0\G@(9MT EM PDA@PD
MR4-KR4-KSYHKST5KSUHASXDA@P3MBT9BQ-APTDIP!!H"CP4NR@T6ACLDC$XLC@0LC@0LJR82P@UFC$ EM#L3C 8XCB0,KB<]G4\.B4@+Q#MHASX3MSL6F@0,
KB0@G38$K -@J4XNR@T6C 8NM!! LKB0,P4\QBB81NB-FL4 EM 85C#XXCB0,K@LYBD)JN# +Q 9HASXNC#T6F@0,KB0WK  YDAL#J4X3R@T6C#T5M!! LI01G
FP QQ2$SH2-FL2(+@BD=OQ +I!!8^@#,BEQ5DLBL+J34X@@@a');
                colorMapFromArray:#[ 107 132 173 123 148 206 189 198 198 198 206 222 0 115 214 0 49 148 8 66 165 16 57 156 247 255 255 90 148 206 132 165 206 140 156 206 206 214 222 0 82 181 0 107 206 0 66 173 247 247 239 247 247 247 57 115 198 123 140 189 148 173 214 189 189 198 198 206 231 222 231 239 0 57 165 239 247 247 239 231 239 82 140 198 123 165 214 189 189 189 198 189 189 214 214 222 0 74 173 0 82 189 0 74 181 0 33 148 247 247 255 66 140 206 140 148 173 181 189 189 165 181 214 231 231 222 0 99 198 0 49 156 0 41 148 0 99 214 255 255 255 90 115 156 107 123 173 132 156 206 148 156 206 0 115 206 0 90 189 0 107 214 0 99 206 33 99 181 0 24 148 90 148 214 132 148 198 198 198 198 0 107 198 0 66 165 231 231 231 231 231 239 0 24 140 66 132 189 99 165 222 156 173 198 198 198 189 236 233 216 0 57 156 231 239 239 0 90 198 24 74 165 255 255 247 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_??8???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<_??8');
                            yourself);
                yourself
        ]
!

saveImageAsMethod22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveImageAsMethod22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#saveImageAsMethod22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class saveImageAsMethod22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
OS4=OS4=OS4=OS4=OS4=O]OP4Y,=OS4@@@@@@C4=OS4=OS4=O\^Y<[B30S4=@@@@@@@=OS4=OS4=OS76)=3Z5Y@=@@@@@@@@OS4=OS4/A0_B8*+]09V3OP@@
@@@@@@@=OS4/A6X?:*[/&M^TOS4@@@@@@@@=OS4IK6ZE!!JR,=LV(3#4=OP@@@@@@@@@IQTVE!!\*_1-"\=S4=OP@@@@@@@B<IM8RE!!XW@7*KH<:T=OS4@@@@@
@A8^YXVE!!X_%*=?M9M''!!OS4=@@@@@AAE!!HVE!!X^G(\.V+=SRI @@OP@@@BX<!!HVE!!X^G++7L:9^8I @@@C4@@@@@I(RD!!XVG!!>''(.)N1<@@@@@@=@@@@@BX<
!!HREB+^^(>3-#;,@@@@=OPBI"X&II#2D!!HW[-+:<1N^I"X&I"S4@"X2L#H0&!!HRD5*&Z$^;&#H2L"8$=@H&L"H"H"BYE!!KJ0''ZB4"H"H"H*IOPBI#H"H"(*J
"(*5,OK#"(*J"H"J"S4@"X2H"H"H"H"H.YKO"H"H"H"H"($=@H&L"H"H"H"H"K>-"H"H"H"H"H*IOPBI"8*J"(*J"(+I"(*J"(*J"(*J"S4@"X&I"X&I"X&I
"X&I"X&I"X&I"X$=@@@@@@@@@@@@@@@@@@@@@@@@@@@=OP@a');
                colorMapFromArray:#[ 111 104 104 112 112 112 127 80 40 127 120 120 128 96 64 128 104 48 128 120 112 128 128 128 143 104 64 143 136 136 144 112 48 144 112 72 144 112 88 144 112 96 159 112 64 159 120 88 159 152 152 160 120 40 160 120 56 160 136 48 160 136 88 160 136 120 160 144 104 160 144 128 160 152 112 160 160 160 175 136 104 175 136 112 175 136 120 175 152 128 175 168 168 176 136 96 176 144 96 176 152 96 176 152 112 176 152 120 176 160 112 176 168 152 176 176 176 191 144 64 191 152 56 191 168 160 192 144 48 192 160 56 192 160 104 192 176 144 192 176 152 192 192 192 207 160 64 207 168 112 207 176 112 207 176 120 207 184 112 207 184 128 207 192 160 207 200 200 208 176 72 208 176 80 208 176 104 208 192 184 208 208 208 223 184 88 223 192 104 223 216 216 224 192 64 224 192 112 224 192 128 224 200 104 224 208 168 224 224 224 239 192 96 239 208 72 239 208 104 239 208 112 239 208 144 239 216 152 239 216 168 239 224 176 239 232 200 239 232 232 239 232 248 240 208 56 240 208 64 240 208 120 240 216 72 240 216 80 240 216 88 240 216 112 240 216 136 240 216 176 240 224 88 240 224 112 240 224 120 240 224 136 240 224 144 240 224 184 240 232 144 240 232 160 240 232 208 240 240 168 240 240 208 240 240 240 240 240 248 255 208 64 255 216 88 255 216 112 255 216 120 255 216 136 255 224 96 255 224 104 255 224 120 255 224 128 255 224 144 255 224 152 255 224 160 255 232 120 255 232 128 255 232 152 255 232 168 255 232 176 255 232 184 255 232 192 255 240 176 255 240 184 255 240 192 255 240 200 255 240 208 255 240 216 255 240 224 255 248 216 255 248 224 255 248 240 255 248 248 168 216 224 0 136 0 0 204 0 32 223 32 64 64 64 16 111 16 170 170 170 199 247 199 0 0 0 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@C0@@G8@@G8@A?8@C?0@G?0@O? @?? A?? C?? G??@C?>@C?>@_??8_??8_??8_??8_??8_??8_??8_??8@@@@');
                            yourself);
                yourself
        ]
!

saveImageBlack22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveImageBlack22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#saveImageBlack22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class saveImageBlack22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@DR@0LC@0LC@0LC@0LC@0LCDALW@@HZ@P\GA0\GA0\GA0\GA0\GA1@RF!!LBF DGA0\GA0\GA0\GA0\GA0\PD!!(W@!!(AA0\XFA XFA XFA XF@\GDAHBD0HZ
@P\GA0\GA0\GA0\GA0\GA1@R@!!LBF DGA1 XFA XFA XFA XA0\PD HS@!!(AA0\GA0\GA0\GA0\GA0\GDAHBE0HZ@P\GFA XFA XFA XFA GA1@R@!!LBF DG
A0\GA0\GA0\GA0\GA0\PD HS@!!([A0\GA0\GA0\GA0\GA0\GDAHBD0HZD!!DY@A0C@0LC@0LC@0LC@1@[F1LBF DRF TQCP4MCP4MCP4MCQ@I@!!,S@!!(ZF!!(Z
@ HB@ HB@!!,[@ HB@ H[D0HZF!!(ZF0TNBP$EB TIDP(R@PDBF1LBF!!(Z@!!\DA@PDA@PD@0\MB1LWF!!,S@!!(ZF HWAALSD0XTA@ GCQXSE1([D0HZF!!(BE0PS
D1LIA@LLA04VD1\ZF1LB@ HB@!!\DD1LSEP LA0\ME!!LWF!!,S@ HB@ HWAALSD0@LA0\GDQXSE1([D0HB@ HBE0PSD1LCA0\LC@8VD1\ZF1LB@ HB@!!\DE@PC
C@\L@0LNE!!LWF HS@@DRD!!\SDQPTFA XEAPXAQXWE1HW@@@a');
                colorMapFromArray:#[ 206 206 206 66 66 66 82 82 82 231 231 231 214 214 214 123 123 123 107 107 107 255 255 255 239 239 239 132 132 132 115 115 115 24 24 24 247 247 247 156 156 156 140 140 140 236 233 216 165 165 165 148 148 148 57 57 57 41 41 41 189 189 189 173 173 173 33 33 33 49 49 49 198 198 198 181 181 181 90 90 90 74 74 74 222 222 222 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_??8???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<_??8');
                            yourself);
                yourself
        ]
!

searchFile22x22Icon
    <resource: #programImage>

    "/ ^ self searchFile22x22Icon1
    ^ self searchFile22x22Icon2
!

searchFile22x22Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self searchFile22x22Icon1 inspect
     ImageEditor openOnClass:self andSelector:#searchFile22x22Icon1
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class searchFile22x22Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
.[&9S\DQ''C59HRJ9.[&9.[&9.[&9.[&9)4]>.5!!JKM4: BB9.[&9.[&9.[&98RV[X%LD_3]ZM;48\+&9.[&9.[&9Q#1PL*<]] ",@Z5$(Y*9.[&9.[&9.PBP
FZ?JX@627L=,NPW^9+&9.[&9.[$8 3JWB3C3#N_Z.CQ]]_R9.PB9.[&9_JO2P*,#^>)=\F8K$3[C.[&9.[&9.T?W''Y6K:9%@[ZJR$)K"20>9.[&9.[%OO?JB
%4R3Z]P5J^LJ/L!!8.[&9.[&9EKZ:4%$SRS;GJM"J=V/&;;&9.[&9.Z@*#I5''%T$MI7QW/527N>>9.[&9.[''L^!!BB+9XFPG54U;=EU@\_.[&9.[&9.RA1Z)UB
E+8U)DL-F<-_G;&9.[&9.[$$5.5LE=2>G--%"I:T"Z8/.[&9.[&9IK%U!!MGI2^P[I$!!K*L6Q]<Z9.[&9.RR9*(XL44F5:N3.S/FA8M=7U+&9.[$$.Z&F!!+QA
-^#,;$9&[1+ 76!![.[&9IK&)* 3SPTG(:N3BS*Y/''8>1@5:9.RR9*Z*F44EA:N#,S$:%B]$BX]CUX;$$.XXL44EA-^#,;$;ELY +3%HN$X^9IK''0TUF*!!-MA
GGO,;$:X.Q#D0AH..T"0#X6M#X6M#X6N#(:N9[&9!!Q#)L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 190 190 203 179 214 235 253 233 159 206 121 14 178 214 234 181 215 227 221 251 253 200 204 216 208 240 250 148 126 112 216 232 238 229 254 254 245 246 250 228 252 253 246 211 132 164 169 187 189 230 251 188 204 227 160 107 51 219 249 254 135 145 175 224 246 249 216 247 251 207 244 252 138 79 26 196 229 251 253 232 155 111 112 138 240 242 248 215 247 253 221 246 249 140 145 163 177 180 196 192 198 214 195 195 207 243 254 254 207 211 222 163 190 225 170 172 189 231 251 252 230 249 251 230 247 251 149 187 221 151 87 25 143 210 248 213 223 231 140 128 133 207 127 27 240 254 254 227 230 238 200 234 251 92 92 122 220 252 254 227 247 251 216 246 250 170 205 228 167 177 202 203 237 247 152 195 230 188 191 206 170 190 218 152 189 230 227 253 254 174 211 235 225 251 252 241 243 248 216 248 253 230 242 247 216 246 253 213 220 227 198 198 209 175 196 226 210 214 224 224 253 254 144 211 248 201 202 215 172 208 226 219 219 226 231 233 241 129 156 197 172 214 249 249 250 252 253 235 160 178 214 235 95 95 124 243 244 246 187 112 26 232 241 245 140 207 247 210 242 253 168 204 225 176 105 25 227 235 240 205 238 248 166 98 25 188 190 205 228 254 254 246 213 133 174 210 234 156 91 25 176 211 226 174 187 201 212 185 159 207 240 253 210 124 15 234 253 253 195 235 251 199 212 222 200 234 246 233 251 252 224 252 253 198 136 46 202 233 238 128 150 182 166 166 183 238 240 247 228 243 247 178 208 221 213 245 252 218 131 16 138 143 162 179 198 222 124 137 168 231 249 253 144 168 204 229 249 251 134 188 237 175 211 231 178 184 201 241 208 124 211 243 253 159 201 235 155 156 175 130 73 25 245 247 250 153 93 31 92 94 123 164 150 144 230 240 245 207 239 252 206 239 251 151 156 174 149 154 172 246 214 135 151 191 230 230 160 50 189 212 221 224 251 252 167 167 183 216 248 254 215 248 253 215 246 253 141 146 164 214 246 252 156 162 182 154 197 236 166 195 228 204 237 252 136 136 159 253 233 158 132 132 155 162 214 237 186 212 221 170 207 235 227 244 248 229 231 240 207 182 159 213 213 221 175 161 154 247 248 251 246 248 250 230 254 254 197 231 248 192 227 243 208 130 31 209 242 253 154 159 176 236 167 55 206 238 250 227 252 254 242 244 249 241 242 248 166 207 237 160 165 185 214 247 251 255 255 255 205 238 252 125 194 246 210 230 237 151 213 245 219 246 249 233 238 243 246 222 150 218 218 225 232 234 242 138 139 163 179 124 48 230 232 240 197 120 26 230 251 253 130 131 155 101 115 143 221 252 254 128 129 153 125 125 150 198 129 40 185 129 47 187 222 237 236 166 54 111 118 146 198 232 251 243 245 249 227 251 253 202 118 14 206 206 216 174 209 234 233 246 249 192 132 47 195 229 238 222 245 248 215 246 251 137 206 247 156 184 203 236 168 57 246 214 136 206 208 219 187 212 220 230 246 249 101 112 139 143 148 167 144 146 168 222 247 251 237 239 246 122 110 120 213 246 252 214 244 253 235 237 244 113 126 154 234 237 243 139 144 163 251 252 253 191 119 39 203 237 252 242 253 254 134 134 158 219 232 238 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'G>@CO? C_?0C??0C??8C??8C??8C??<C??<C??<C??<C??<C_?<C_?>C_??C_??#_??3_??;_???_???_?=?_?<?');
                            yourself);
                yourself
        ]
!

searchFile22x22Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self searchFile22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#searchFile22x22Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary searchFile22x22Icon2'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
L#H2^7-<_W9? HD2L#H2L#H2L#H2L#H2 (ND!!XZG"HZI"(,2L#H2L#H2L#H2#H6N#9BQ$YFQ$)NT%SH2L#H2L#H2 IZW&I&Y&Y&Z&YFQ&902L#H2L#H2L)6^
&)&_(JBX&Y&Q$YF!!(#H2L#H2L#JT(9"Y(JR$&JVY&Y>X)*\2L#H2L#H2*J&X'':B$(I& &ZB (JV*J"(4L#H2L*.O&I"X&Y& +J6-+Z6.)5-[ISH2L#J+#9"Y
&ZV +JB-+Z6/,J]2\"T2L#H2,[JX,9&_(JB (KR5+;Z"U6 TIQ0[L*^7&I"8'':B (KV9.+.<''SHTVE!!XF3H2/[:Y&[>_(JB5.[+@0S-\WG%9V@L2L(/B,9>_
)ZV-+[W@0:^]]5!!6QA@2L#HY1LWF.I&%)ZWG0\"U2\+KVA(2L#H2FD1!!3L7N3,;C35SP4]KS5MTRL#H2L!!]GO"],TVYTY%Q+Z=[W6M''T6#H2L#HSORX?R5=J
S6QPYFS[7M7X6];_L#H2D3,^YT%IRT)JW$9"S.C\7^G"8>P2L!!P!!M$YFWTY]RC0.G00I9]K]8^K&93HUB6MEMRHMAPPGC142L#K(:^+!!4>\2GP@B@P QHCH2
L#H2L#H2L./,;^;/L#H2L#H2L#H2L#H2L#H2L#H2<@@@@@@a') ; colorMapFromArray:#[127 80 47 128 96 64 128 111 48 128 127 112 143 111 64 144 112 48 144 112 79 144 112 95 144 112 96 159 112 64 159 127 95 160 127 47 160 127 63 160 143 48 160 143 95 160 143 127 160 144 111 160 144 128 160 159 112 175 143 111 175 143 112 175 143 127 175 159 128 176 143 96 176 144 96 176 159 96 176 159 112 176 159 127 176 160 112 176 175 159 191 144 64 191 159 63 191 175 160 192 144 48 192 160 63 192 160 111 192 176 144 192 176 159 207 160 64 207 160 80 207 175 112 207 176 112 207 176 127 207 191 112 207 191 128 207 192 160 208 176 79 208 176 80 208 176 111 208 192 191 223 191 95 223 192 111 223 208 208 224 192 64 224 192 112 224 192 128 224 207 111 224 208 175 224 223 207 239 192 96 239 208 79 239 208 111 239 208 112 239 208 144 239 223 159 239 223 175 239 224 176 239 224 223 239 239 207 240 208 63 240 208 64 240 208 127 240 223 79 240 223 80 240 223 95 240 223 112 240 223 143 240 223 176 240 224 95 240 224 112 240 224 127 240 224 143 240 224 144 240 224 191 240 239 144 240 239 160 240 239 175 240 239 176 240 239 208 240 240 175 240 240 191 240 240 192 240 240 208 255 208 64 255 223 95 255 223 112 255 223 127 255 223 143 255 224 96 255 224 111 255 224 127 255 224 128 255 224 144 255 224 159 255 224 160 255 239 127 255 239 128 255 239 159 255 239 175 255 239 176 255 239 191 255 239 192 255 240 176 255 240 191 255 240 192 255 240 207 255 240 208 255 240 223 255 240 224 255 255 223 255 255 224 255 255 240 255 248 248 223 216 224 191 200 224 160 192 224 159 184 224 176 192 216 192 192 208 192 192 200 208 208 216 175 192 224 128 184 232 127 192 240 143 200 240 144 208 248 143 208 248 159 192 224 176 184 200 176 176 192 207 208 216 160 184 224 159 192 232 175 208 232 176 208 232 207 232 240 175 200 224 144 208 240 160 176 200 160 160 176 175 184 216 175 208 248 207 232 248 208 240 248 192 224 248 160 208 232 159 160 176 191 184 200 144 184 224 223 248 248 224 248 248 159 184 200 144 144 168 159 200 232 240 248 248 223 240 248 176 208 216 128 128 152 144 168 200 175 200 232 143 136 160 128 152 192 239 248 248 224 240 248 191 208 216 223 232 232 208 224 232 128 144 168 160 200 232 192 232 248 239 240 248 224 240 240 192 208 216 144 184 216 207 240 248 239 240 240 239 232 240 224 232 240 160 160 184 127 136 168 191 224 248 208 248 248 208 216 224 95 88 120 128 144 176 111 112 136 207 200 216 112 120 152 175 208 224 175 184 200 143 136 152 160 144 144 208 128 24 207 120 24 159 152 168 111 112 144 96 112 136 175 168 184 207 200 208 175 160 152 192 128 40 224 160 48 223 128 16 192 120 24 191 112 32 240 208 120 240 208 136 239 168 56 191 112 24 208 184 152 192 136 40 255 232 152 208 120 8 176 104 24 207 176 152 240 208 128 239 160 48 207 120 8 160 96 24 144 120 112 207 112 8 159 88 24 144 80 24 191 128 40 255 232 160 143 72 24 176 120 48 240 216 144 160 104 48 143 128 128 128 72 24]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'G>@@O? @_?0@??0@??8@??8@???@???@???@???8???8_??8_??0_?? _?? _?? _??0_??8_??<_?#<_0A<@@@<') ; yourself); yourself]
!

terminal22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self terminal22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#terminal22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class terminal22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
 XFA XFA XFA XFA XFA XFA XFA XFAPX)8%QL9U9LQ]T52^(@/K2</ XFAGDFA XFA XFA XFA:>/+:>2ANRVA TJA(Q(ZF!!(ZF!!+#9^W%9^S- _H% XF[
 ^[K*;OZ7^C!!+]OA0?W:>8G.IXFAF8G&2:.36-7 8Z7S0\O5>/.A<BVA R^A9-2+3]G]8NF-4<G9=_+; _H% XEJ ^J6/;CR7^C!!+]OA>_W:>8G.IXFA\XG"
*;>04-618Z7S0_''5>/.A<BVA S:A8*.36-7 ,Z7J0\OY=_+; _@% XE!! ^J?,MG]8NF-4<GC6_+;?XG/IXFAL8G",=+R7[G!!+]OA6S?U>O>A;2VA X6A8;CR
7[F>2-.*4L#U3?36 _L% XE- ^O],\R;3-SL5,B).[''>=(G1IXFA[XG%+*:;1=,++;SH/\?8??^A<RVA V6A XFA XFA XFA XFA XFA _P% XE-</K.;/C/
;?O3<?G1<_O3<_G1IXFA RT%IRT%IRT%IRT%IRT%IRT%IXFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA
 XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA P@a') ; colorMapFromArray:#[109 243 0 55 187 0 11 108 0 18 149 0 55 167 0 213 232 255 218 229 250 217 227 249 62 176 0 90 104 197 79 200 0 226 234 251 96 230 0 210 230 255 69 185 0 86 215 0 42 150 0 142 156 218 187 197 239 158 177 227 201 255 153 32 135 0 197 206 242 49 159 0 22 122 0 39 148 0 160 173 232 131 157 220 147 178 229 224 238 255 73 206 0 56 168 0 221 232 252 29 131 0 73 190 0 90 224 0 19 118 0 63 67 120 63 177 0 126 151 218 16 146 0 53 164 0 70 186 0 33 164 0 214 224 248 213 222 247 132 255 21 99 106 198 16 114 0 60 173 0 216 232 253 101 118 203 30 162 0 111 245 0 184 194 238 47 180 0 224 237 254 154 172 225 223 235 253 214 232 254 194 203 241 64 178 0 111 131 209 17 149 0 133 145 214 167 193 234 142 171 226 249 252 255 61 194 0 216 225 249 44 152 0 105 239 0 34 139 0 7 102 0 121 144 215 209 230 255 246 250 255 128 139 212 24 124 0 68 185 0 102 235 0 4 98 0 48 157 0 21 122 0 206 255 162 45 177 0 11 107 0 150 167 223 72 196 0 219 230 251 156 255 66 62 195 0 168 180 234 1 94 0 191 200 240 89 214 0 106 240 0 106 124 206 69 202 0 8 103 0 218 232 253 159 255 72 32 164 0 113 247 0 59 191 0 164 176 233 42 149 0 76 209 0 76 195 0 85 97 195 49 164 0 49 158 0 190 255 132 116 137 212 123 134 209 83 216 0 12 122 0 137 151 216 119 252 2 118 252 1 166 187 231 194 222 255 118 128 207 36 141 0 97 226 0 87 221 0 16 113 0 77 210 0 113 122 205 255 255 255 23 128 0 40 146 0 30 151 0 225 238 255 13 111 0 101 235 0 47 179 0 222 234 252 170 192 234 252 253 255 121 253 3 96 111 201 180 191 237 220 234 253 54 166 0 212 231 255 27 129 0 147 161 221 115 249 0 162 182 229 61 183 0 61 175 0 176 187 236 41 173 0 217 232 253 137 164 224 68 184 0 4 135 0 4 133 0 85 212 0 14 112 0 226 239 255 31 134 0 215 232 254 92 225 0 172 183 235 243 249 255 0 0 0 123 255 0 15 139 0 32 165 0 103 255 0 144 255 27 46 203 0 56 194 0 29 157 0 90 248 0 60 217 0 192 255 130 94 251 0 23 151 0 206 255 147 111 255 0 148 255 63 37 167 0 10 132 0 27 154 0 51 187 0 130 254 18 14 139 0 48 201 0 102 255 0 21 148 0 28 183 0 164 255 71 18 174 0 55 192 0 167 224 170 171 255 81 45 179 0 18 142 0 116 255 0 42 191 0 113 255 0 32 162 0 93 251 0 43 178 0 6 128 0 23 152 0 84 241 0 84 239 0 37 192 0 37 168 0 10 133 0 27 155 0 159 255 70 0 98 0 14 166 0 85 242 0 41 175 0 112 255 0 75 231 0 135 255 26 31 160 0 65 222 0 55 211 0 141 157 224 164 175 229 178 194 242 178 187 232 130 147 221 46 145 54 47 129 47 46 132 45 46 133 45 250 255 255 241 249 255 195 206 251 184 201 251 178 197 251 182 200 251 170 192 251 187 202 251 177 197 251 166 191 251 7 162 0 0 111 0 0 107 0 1 122 0 16 173 0 0 154 0 0 142 0 0 120 0 0 118 0 0 116 0 0 114 0]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@O??0_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8O??0@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

uiPainter22x22Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter22x22Icon3 inspect
     ImageEditor openOnClass:self andSelector:#uiPainter22x22Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class uiPainter22x22Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)R@?EPY%C!!QKGW5ZM050RL[C1H8+KQL?Q7<>YE@6W''UIE#@EW[*L9JN&-HAVVTIUSTY2U4@!!B6L8UA3)&,?M2HLYLW ^
[#I''V6@QS''1_C4*55Y7P-("&SA PC@0LC@0LC@0LC@0L7Y''""<*GC@09V@0JB (JB (JB 0LB)^_9;"[0P(LT"XLB 0LC@0LC@$LCK6R.\.O:@0ICC,''C@(L
C@0LC@0IC@234YV;9) LBP1:[@0JC@0LC@0LBP3X''-K@5<3TC@$LOF4LBP$IBP$IBP$L%K:I(,_EBP$ICBP(C@0LC@0LC@0L([B?7(*+C@0LC@1*[00IBP$I
BP$IB]3[+XZ$80$IBP$LOWDLBPLC@0LC@:*Q%-?  *8C@0HACBT*C@$C@0LC@0ON*[F/-=(C@0LB@P0%_ 0I@0LC@0LC2Y2M!!NGY@ LC@ DLIWLLBPHB@ HB
@*V#$IN''@ HB@ HACBUCC@$A@PDA@PF((>WV@PDA@PDA@P0%K@0LC@0LC@0L+HWBC@0LC@0LC@0LIR0LC@0LC@0LCKJ C@0LC@0LC@0LCBT,C@0LC@0LC@2<
C@0LC@0LC@0LC@0%Y''P4MWXGBEESB@!!SH&$%IRT%IRT%Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 160 160 160 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 72 122 199 116 116 120 237 236 242 72 141 255 212 211 224 32 101 209 63 143 226 153 188 255 106 175 235 170 204 255 7 66 194 0 50 164 58 137 224 75 160 234 66 135 255 140 175 255 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 80 149 255 55 95 181 125 160 253 52 89 178 50 87 176 105 172 233 104 170 232 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 2 56 178 3 73 255 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 81 136 209 101 170 255 36 107 211 54 123 255 56 94 181 126 161 253 55 92 180 53 90 178 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 96 157 223 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 28 97 255 109 178 255 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 39 109 255 93 161 255 157 192 255 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 181 215 255 255 255 255 52 90 178 51 88 177 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 87 145 215 84 153 255 78 131 206 10 79 255 91 168 235 127 162 254 54 91 179 14 77 199 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????????????');
                            yourself);
                yourself
        ]
!

uiPainter32x32Icon3a
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter32x32Icon3 inspect
     ImageEditor openOnClass:self andSelector:#uiPainter32x32Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class uiPainter32x32Icon3a'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)R@?EPY%C!!QKGW5ZM050RL[C1H8+KQL?Q7<>YE@6W''UIE#@EW[*L9JN&-HAVVTIUSTY2U4@!!B6L8UA3)&,?M2HLYLW ^
[#I''V6@QS''1_C4*55Y7P-("&SA PC@0LC@0LC@0LC@0L7Y''""<*GC@09V@0JB (JB (JB 0LB)^_9;"[0P(LT"XLB 0LC@0LC@$LCK6R.\.O:@0ICC,''C@(L
C@0LC@0IC@234YV;9) LBP1:[@0JC@0LC@0LBP3X''-K@5<3TC@$LOF4LBP$IBP$IBP$L%K:I(,_EBP$ICBP(C@0LC@0LC@0L([B?7(*+C@0LC@1*[00IBP$I
BP$IB]3[+XZ$80$IBP$LOWDLBPLC@0LC@:*Q%-?  *8C@0HACBT*C@$C@0LC@0ON*[F/-=(C@0LB@P0%_ 0I@0LC@0LC2Y2M!!NGY@ LC@ DLIWLLBPHB@ HB
@*V#$IN''@ HB@ HACBUCC@$A@PDA@PF((>WV@PDA@PDA@P0%K@0LC@0LC@0L+HWBC@0LC@0LC@0LIR0LC@0LC@0LCKJ C@0LC@0LC@0LCBT,C@0LC@0LC@2<
C@0LC@0LC@0LC@0%Y''P4MWXGBEESB@!!SH&$%IRT%IRT%Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 160 160 160 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 72 122 199 116 116 120 237 236 242 72 141 255 212 211 224 32 101 209 63 143 226 153 188 255 106 175 235 170 204 255 7 66 194 0 50 164 58 137 224 75 160 234 66 135 255 140 175 255 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 80 149 255 55 95 181 125 160 253 52 89 178 50 87 176 105 172 233 104 170 232 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 2 56 178 3 73 255 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 81 136 209 101 170 255 36 107 211 54 123 255 56 94 181 126 161 253 55 92 180 53 90 178 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 96 157 223 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 28 97 255 109 178 255 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 39 109 255 93 161 255 157 192 255 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 181 215 255 255 255 255 52 90 178 51 88 177 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 87 145 215 84 153 255 78 131 206 10 79 255 91 168 235 127 162 254 54 91 179 14 77 199 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????????????');
                            yourself);
                yourself
        ]
!

unixShellTerminal22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self unixShellTerminal22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#unixShellTerminal22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class unixShellTerminal22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
 XFA XFA XFA XFA XFA XFA XFA XFAPX)8%QL9U9LQ]T52^(@/K2</ XFAGDFA XFA XFA XFA:>/+:>2ANRVA TJA(Q(ZF!!(ZF!!+#9^W%9^S- _H% XF[
 ^[K*;OZ7^C!!+]OA0?W:>8G.IXFAF8G&2:.''):_ 8Z7S0\O5>/.A<BVA R^A9-2''3Z_Q)>F-4<G9=_+; _H% XEJ ^J6);B''7^C!!+]OA>_W:>8G.IXFA\XG"
*:^0)=618Z7S0_''5>/.A<BVA S:A8*.3):^'',Z7J0\OY=_+; _@% XE!! ^J?,MF''7Z^-4<GC6_+;?XG/IXFAL8G",=+R)=6''+]OA6S?U>O>A;2VA X6A8;B''
7Z^1)=.*4L#U3?36 _L% XE- ^O],Z^'')=SL5,B).[''>=(G1IXFA[XG%+*:;1=,++;SH/\?8??^A<RVA V6A XFA XFA XFA XFA XFA _P% XE-</K.;/C/
;?O3<?G1<_O3<_G1IXFA RT%IRT%IRT%IRT%IRT%IRT%IXFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA
 XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA P@a') ; colorMapFromArray:#[109 243 0 55 187 0 11 108 0 18 149 0 55 167 0 213 232 255 218 229 250 217 227 249 62 176 0 90 104 197 79 200 0 226 234 251 96 230 0 210 230 255 69 185 0 86 215 0 42 150 0 142 156 218 187 197 239 158 177 227 201 255 153 32 135 0 197 206 242 49 159 0 22 122 0 39 148 0 160 173 232 131 157 220 147 178 229 224 238 255 73 206 0 56 168 0 221 232 252 29 131 0 73 190 0 90 224 0 19 118 0 63 67 120 63 177 0 126 151 218 16 146 0 53 164 0 70 186 0 33 164 0 214 224 248 213 222 247 132 255 21 99 106 198 16 114 0 60 173 0 216 232 253 101 118 203 30 162 0 111 245 0 184 194 238 47 180 0 224 237 254 154 172 225 223 235 253 214 232 254 194 203 241 64 178 0 111 131 209 17 149 0 133 145 214 167 193 234 142 171 226 249 252 255 61 194 0 216 225 249 44 152 0 105 239 0 34 139 0 7 102 0 121 144 215 209 230 255 246 250 255 128 139 212 24 124 0 68 185 0 102 235 0 4 98 0 48 157 0 21 122 0 206 255 162 45 177 0 11 107 0 150 167 223 72 196 0 219 230 251 156 255 66 62 195 0 168 180 234 1 94 0 191 200 240 89 214 0 106 240 0 106 124 206 69 202 0 8 103 0 218 232 253 159 255 72 32 164 0 113 247 0 59 191 0 164 176 233 42 149 0 76 209 0 76 195 0 85 97 195 49 164 0 49 158 0 190 255 132 116 137 212 123 134 209 83 216 0 12 122 0 137 151 216 119 252 2 118 252 1 166 187 231 194 222 255 118 128 207 36 141 0 97 226 0 87 221 0 16 113 0 77 210 0 113 122 205 255 255 255 23 128 0 40 146 0 30 151 0 225 238 255 13 111 0 101 235 0 47 179 0 222 234 252 170 192 234 252 253 255 121 253 3 96 111 201 180 191 237 220 234 253 54 166 0 212 231 255 27 129 0 147 161 221 115 249 0 162 182 229 61 183 0 61 175 0 176 187 236 41 173 0 217 232 253 137 164 224 68 184 0 4 135 0 4 133 0 85 212 0 14 112 0 226 239 255 31 134 0 215 232 254 92 225 0 172 183 235 243 249 255 0 0 0 123 255 0 15 139 0 32 165 0 103 255 0 144 255 27 46 203 0 56 194 0 29 157 0 90 248 0 60 217 0 192 255 130 94 251 0 23 151 0 206 255 147 111 255 0 148 255 63 37 167 0 10 132 0 27 154 0 51 187 0 130 254 18 14 139 0 48 201 0 102 255 0 21 148 0 28 183 0 164 255 71 18 174 0 55 192 0 167 224 170 171 255 81 45 179 0 18 142 0 116 255 0 42 191 0 113 255 0 32 162 0 93 251 0 43 178 0 6 128 0 23 152 0 84 241 0 84 239 0 37 192 0 37 168 0 10 133 0 27 155 0 159 255 70 0 98 0 14 166 0 85 242 0 41 175 0 112 255 0 75 231 0 135 255 26 31 160 0 65 222 0 55 211 0 141 157 224 164 175 229 178 194 242 178 187 232 130 147 221 46 145 54 47 129 47 46 132 45 46 133 45 250 255 255 241 249 255 195 206 251 184 201 251 178 197 251 182 200 251 170 192 251 187 202 251 177 197 251 166 191 251 7 162 0 0 111 0 0 107 0 1 122 0 16 173 0 0 154 0 0 142 0 0 120 0 0 118 0 0 116 0 0 114 0]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@O??0_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8O??0@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

view22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self view22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#view22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class view22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)SM"H Z!!D2E5LLRMU1J.\";APA=BRRA"\\Y!!(G5U$;]3ID8E$T4D#6=KR<^D#FVC]7B0"&L5C9=X "=<K[%KR4,,S;,1
+EB$#)0\^LNZEWR)I&QQ/%,7]",[)ZV%)ZV%)ZV%)ZV%)XXWFF&3Q2)Z":V%)ZV%)ZV%)ZV%)XXWFF&3Q9Q> C2%)ZV%)ZV%)ZV%)ZVFE1!!),4^T_%0=)ZV%
)ZV%)ZV%)XXWZF&3Q9PI^##@**V%)ZV%)ZV%)XZ%ZF%EQ9P''^+0:W*.%)ZV%)ZV%)ZVF)V!!)QT^TI7*<N#$?)ZV%)ZV%)ZTWZKIEQ9P''^+04(0B''+ZV%)ZV%
)ZTWZKIE$)P''^+04(1XBXJ>%)ZV%)ZV%E6"2QYJTI7*<MJLV@#-A)ZV%)ZTWZL%E$  ''^+1Y(1Y&2D0;1ZV%)ZTWZL%E$  ''^+1Y(1Y&2DP)N;F%)ZV%E6#I
QYHHI7*<VZLVY,!!DJS-'')ZTWZL%E$ !!9.+1Y(1Y&2DRPIP4;P8 Z@PNV&I,NWU>(Z15-R$0)&P4PN:J6T%R8A0-? Y6^L#Z&N3,;N3,;N6:%)ZV%)ZV%)ZV%
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 227 227 236 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 244 244 249 242 242 247 118 118 122 72 122 199 116 116 120 218 217 230 237 236 242 72 141 255 212 211 224 141 141 141 32 101 209 63 143 226 133 133 133 153 188 255 234 234 242 253 253 254 251 251 252 127 127 127 249 249 250 106 175 235 170 204 255 227 226 235 135 135 138 7 66 194 0 50 164 58 137 224 75 160 234 123 123 126 66 135 255 226 226 237 140 175 255 243 243 247 119 119 122 220 220 231 240 239 244 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 237 237 244 80 149 255 55 95 181 125 160 253 233 233 240 52 89 178 231 231 238 50 87 176 105 172 233 104 170 232 138 138 140 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 229 229 239 248 248 251 124 124 126 246 246 249 122 122 124 2 56 178 223 223 233 3 73 255 222 221 232 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 128 128 133 81 136 209 101 170 255 126 126 131 36 107 211 54 123 255 238 238 244 56 94 181 126 161 253 55 92 180 235 234 241 53 90 178 233 232 239 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 232 232 241 96 157 223 251 251 253 249 249 251 125 125 126 228 228 237 123 123 124 225 224 234 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 243 243 248 241 241 246 117 117 121 28 97 255 109 178 255 238 237 243 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 132 132 132 254 254 255 128 128 128 250 250 251 229 229 237 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 227 227 238 39 109 255 246 246 250 93 161 255 244 244 248 120 120 123 242 242 246 118 118 121 241 240 245 219 219 230 157 192 255 239 238 243 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 236 236 243 181 215 255 255 255 255 52 90 178 51 88 177 231 230 238 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 249 249 252 247 247 250 123 123 125 121 121 123 87 145 215 84 153 255 78 131 206 10 79 255 241 241 247 91 168 235 239 239 245 115 115 120 127 162 254 236 235 242 54 91 179 14 77 199 138 138 139 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 231 231 240 250 250 252 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

viewAdd22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewAdd22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#viewAdd22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class viewAdd22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)R-UG@ZLDA-&JJ):R >YX2Z(M1$9O!!)UX*1T"65I JA$GTLE_$K*.VA@PJ54^U!!3ZFF[]5X-CX)K\"_U,,+VPD@$QJP)
%4VO^8\WZZ&EDVVT4KR7,T8/Y2LV$IBP$IBP$IBP$IBP$L_I6+F^ORIM^IBP$IBP$IBP$IBP$GV?.L7DOXE.\CRP$IBP$IBP$IC-8=''Y1;;Q1L;[74<5$IBP
$IBP$IB3<\CF;<K+3[_&2<# %YBP$IBP$IBP7[+^0;R43_KX-^_W7IZP$IBP$IBP$ICA1LSD;K_!!6=?09SD6$IBP$IBP$I@SV94<O[/)2<T,# BR&IBP$IBP
$I@SV94<_8GT2;CO#!!HBT9*P$IBP$IBPD5.]OG>A:K3W4(8R@#L8$IBP$I@SV:<<_0  Z>KS9KYY+$D3*9BP$I@SV:<<_0  Z:UL/^9Y+#,!!L92P$IBPD5./
OG<HHF.%SH8RVZ8;HSMZ$I@SV:<<_0!!*(:UL#!!IY+#-=G ,3N''XU@PNB 8XLTEJSWQ!!^O4D!!!!@,NL86_Q4"!!A0)/\X"IJ":QL3L3L3L3L5>%)ZV%)ZV%)ZV%
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 227 227 236 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 244 244 249 242 242 247 72 122 199 218 217 230 237 236 242 72 141 255 212 211 224 32 101 209 63 143 226 153 188 255 234 234 242 253 253 254 251 251 252 249 249 250 106 175 235 170 204 255 227 226 235 7 66 194 0 50 164 58 137 224 75 160 234 66 135 255 226 226 237 140 175 255 243 243 247 220 220 231 240 239 244 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 237 237 244 80 149 255 55 95 181 125 160 253 233 233 240 52 89 178 231 231 238 50 87 176 105 172 233 104 170 232 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 229 229 239 248 248 251 246 246 249 2 56 178 223 223 233 3 73 255 222 221 232 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 81 136 209 101 170 255 36 107 211 54 123 255 238 238 244 56 94 181 126 161 253 55 92 180 235 234 241 53 90 178 233 232 239 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 232 232 241 96 157 223 251 251 253 249 249 251 228 228 237 225 224 234 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 243 243 248 241 241 246 28 97 255 109 178 255 238 237 243 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 254 254 255 250 250 251 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 227 227 238 39 109 255 246 246 250 93 161 255 244 244 248 242 242 246 241 240 245 219 219 230 157 192 255 239 238 243 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 236 236 243 181 215 255 255 255 255 52 90 178 51 88 177 231 230 238 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 249 249 252 247 247 250 87 145 215 84 153 255 78 131 206 10 79 255 241 241 247 91 168 235 239 239 245 127 162 254 54 91 179 14 77 199 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 231 231 240 250 250 252 64 176 48 15 127 15 32 159 31 112 159 95 144 239 127 95 192 79 95 112 80 127 208 96 176 240 159 160 176 95 31 159 31 15 112 15 63 175 48 143 159 128 176 239 159 16 175 16 144 224 127 31 95 15 176 240 144 143 239 112 0 127 0 16 95 16 175 240 144 15 175 15 63 160 47 175 239 144 31 144 16 80 191 64 176 175 128 143 224 112 0 112 0 16 80 16 15 160 15 143 224 111 16 79 16 16 80 15 0 111 0 80 176 64 95 159 79 48 159 47 111 207 80 0 175 0 128 224 111 0 96 0 15 79 15 127 159 111 128 223 111 0 95 0 15 80 0 96 207 80 64 112 63 0 160 0 15 79 0 15 64 15 96 207 79 64 176 63 0 80 0 95 207 79 159 159 63 159 239 127 15 128 15 95 160 47 144 159 143 191 240 159 0 79 0 32 160 31 127 223 96 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

viewDetails22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewDetails22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#viewDetails22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class viewDetails22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)SM"H Z!!D2E5LLRMU1J.\";APA=BRRA"\\Y!!(G5U$;]3ID8E$T4D#6=KR<^D#FVC]7B0"&L5C9=X "=<K[%KR4,,S;,1
+EB$#)0\^LNZEWR)I&QQ/%,7]",[)ZV%)ZV%)ZV%)ZV%)XXWFF&3Q2)Z":V%)ZV%)ZV%)ZV%)XXWFF&3Q9Q> C2%)XTYFQ&%)X^G)Q''JE<.4,4 I/50=)ZV%
)ZV%)ZV%)XXWZF&3Q9PI^##@**V%)ZV%)ZV%)XZ%ZF%EQ9P''^+0:W*.%)QPYFQ&%)Q&G)T[KE4"5,2L4"S$?)ZV%)ZV%)ZTWZKIEQ9P''^+04(0B''+ZV%)ZV%
)ZTWZKIE$)P''^+04(1XBXJ>%)Q$YFQDWZDX>)T"5E2 J,5M&R#-A)ZV%)ZTWZL%E$  ''^+1Y(1Y&2D0;1ZV%)ZTWZL%E$  ''^+1Y(1Y&2DP)N;F%)Q''JZ,IE
$$ ^)R (E7,L,5ZP&S-'')ZTWZL%E$ !!9.+1Y(1Y&2DRPIP4;P8 Z@PNV&I,NWU>(Z15-R$0)&P4PN:J6T%R8A0-? Y6^L#Z&N3,;N3,;N6:%)ZV%)ZV%)ZV%
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 227 227 236 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 244 244 249 242 242 247 118 118 122 72 122 199 116 116 120 218 217 230 237 236 242 72 141 255 212 211 224 141 141 141 32 101 209 63 143 226 133 133 133 153 188 255 234 234 242 253 253 254 251 251 252 127 127 127 249 249 250 106 175 235 170 204 255 227 226 235 135 135 138 7 66 194 0 50 164 58 137 224 75 160 234 123 123 126 66 135 255 226 226 237 140 175 255 243 243 247 119 119 122 220 220 231 240 239 244 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 237 237 244 80 149 255 55 95 181 125 160 253 233 233 240 52 89 178 231 231 238 50 87 176 105 172 233 104 170 232 138 138 140 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 229 229 239 248 248 251 124 124 126 246 246 249 122 122 124 2 56 178 223 223 233 3 73 255 222 221 232 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 128 128 133 81 136 209 101 170 255 126 126 131 36 107 211 54 123 255 238 238 244 56 94 181 126 161 253 55 92 180 235 234 241 53 90 178 233 232 239 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 232 232 241 96 157 223 251 251 253 249 249 251 125 125 126 228 228 237 123 123 124 225 224 234 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 243 243 248 241 241 246 117 117 121 28 97 255 109 178 255 238 237 243 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 132 132 132 254 254 255 128 128 128 250 250 251 229 229 237 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 227 227 238 39 109 255 246 246 250 93 161 255 244 244 248 120 120 123 242 242 246 118 118 121 241 240 245 219 219 230 157 192 255 239 238 243 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 236 236 243 181 215 255 255 255 255 52 90 178 51 88 177 231 230 238 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 249 249 252 247 247 250 123 123 125 121 121 123 87 145 215 84 153 255 78 131 206 10 79 255 241 241 247 91 168 235 239 239 245 115 115 120 127 162 254 236 235 242 54 91 179 14 77 199 138 138 139 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 231 231 240 250 250 252 126 126 127 124 124 125 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
!

viewFlyByInfo22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewFlyByInfo22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#viewFlyByInfo22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class viewFlyByInfo22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
\GA0\GA0\GA0\GA0\GA0\GA0\GA0\C@:PS09MSH*HQ8\F!! TD1@OB0(IA@D:\''A#W55UR4]@NB<_F1\RC  GA0TBP&=%XE9YS$%DO#P)GQ$UDP0GA0\F@4*-
):Z%)IZU%INF!!XRB\7E.ZFQ"XQY\</K2</K2<.X@@@@@@@@@@@@@@M .V?K2</K2</K2<?G1<_G1<_G1<PCRKU+2</K2</K2</O1<_G1<_G1<_D@<"-X<$A@
PDA@PDC3<_O3<?O1<_G1@OH(U?I@-+Z6-+X@<?G1<_G1<_G1<PC2I%[2PKZ6-+X@<_G1<?O3<_G1<_D@<"QT<$B6-+X@<_G1<_G1<_G1<_G1@OH#T?I@-+Z6
@@@@@OG3<?O1<_G1<PC2H%K2PKZ6-+Z6POO1<_G1<_G1<_D@<"AQ<$A@PDA@PDC3<_O3<?O1<_G1@OH TOK2</K2</K2<?G1<_G1<_G1<PC2HD?23?K2</K2
</O1<?O3<?G1<_D@<"AM</K2</K2</K3<_G1<_G1<_G1@OH SN#2</K2</K2<?O3<?O3<?O3<?O2HBC(:N#(:N#(:N#(:N#(:N#(</K2< 4 HB@ HB@ HB@J
HB@ HB@ HB@ HB@ @@@@@@@@@GA0\GA0\GA0\GA0\GA0\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 50 164 0 50 171 1 50 177 2 56 178 3 64 241 3 67 246 3 73 255 4 74 255 5 63 191 7 66 194 10 71 196 10 79 255 12 59 167 12 82 255 14 77 199 18 83 201 19 88 255 21 91 255 23 89 204 27 95 206 28 97 255 29 72 179 30 100 255 32 101 209 36 106 255 36 107 211 39 109 255 41 113 214 45 115 255 45 119 216 48 118 255 50 87 176 50 125 219 51 88 176 51 88 177 52 89 178 52 90 178 53 90 178 53 127 212 54 91 179 54 123 255 54 131 221 55 92 180 55 95 181 56 93 180 56 94 181 57 127 255 57 149 229 58 99 184 58 137 224 61 104 187 63 132 255 63 143 226 64 108 190 66 113 193 66 135 255 67 149 229 68 157 232 69 117 196 71 155 231 72 122 199 72 141 255 75 126 202 75 144 255 75 160 234 77 163 236 78 131 206 80 149 255 81 136 209 84 140 212 84 153 255 87 145 215 88 157 255 91 168 235 93 161 255 94 154 222 96 157 223 96 165 255 97 159 225 98 160 225 98 162 226 99 163 227 100 165 228 101 166 229 101 170 255 102 167 230 103 169 231 104 170 232 104 173 255 105 172 233 105 174 234 106 175 235 109 178 255 112 180 255 117 186 255 119 187 255 122 154 245 125 160 253 125 193 255 126 161 253 126 194 255 127 127 175 127 128 175 127 162 254 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 130 165 254 132 200 255 132 201 255 135 170 255 139 207 255 140 175 255 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 179 255 144 191 239 149 184 255 153 188 255 157 192 255 159 159 192 159 160 192 159 160 207 159 160 208 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 162 196 255 166 200 255 170 204 255 174 208 255 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 177 212 255 181 215 255 185 219 255 188 222 255 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 225 255 192 192 208 192 239 255 192 240 255 207 143 95 207 207 191 207 223 239 207 239 240 207 255 255 208 208 223 208 224 239 208 255 255 212 211 224 217 217 217 218 217 230 219 219 230 220 220 231 222 221 232 223 128 63 223 255 255 225 225 234 226 226 237 227 227 236 227 227 238 228 228 237 229 229 239 231 230 238 231 231 238 231 231 240 232 232 241 233 232 239 233 233 240 234 234 242 235 234 241 236 236 243 237 236 242 237 237 244 238 237 243 239 238 243 239 239 240 239 239 245 239 255 255 240 207 144 240 239 244 241 240 245 241 241 246 242 242 246 242 242 247 243 243 247 244 244 248 245 244 247 246 246 249 246 246 250 247 246 249 247 247 250 248 248 251 249 249 250 249 249 251 249 249 252 250 250 251 251 251 252 251 251 253 253 253 254 254 254 255 255 175 79 255 191 80 255 191 95 255 207 144 247 241 170 255 255 255 0 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????????@@@C');
                            yourself);
                yourself
        ]
!

viewInspect22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewInspect22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#viewInspect22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class viewInspect22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
\GA0\GA0\GA0\GA0\GA0\GA0\GA0\C@:PS09MSH*HQ8\F!! TD1@OB0(IA@D:\''A#W55UR4]@NB<_F1\RC  GA0TBP&=%XE9YS$%DO#P)GQ$UDP0GA0\F@4*-
):Z%)IZU%INF!!XRB\7E.ZFQ"XQY\</K2</K2<)9)Y61>!!:#+:^[#8M .V?K2</K2<''V@(*>0+I6A^;[#8M;RKU+2</K2<("7-[V5-[V5.XM,-.C^4"-X<$A@
PH&3X6M#X6M#X6M#''V''\6,0(U?I@''JB6-+Z6-+Z6-+Z6X;V]#]WHI%[2PI2O*+Z6-+Z6-+Z6-&N5''V[U2BQT<$B\"[B6-+Z6-+Z6-+Y#-[U+3<L#T?I@''H&5
-+Z6-+Z6-+Z6X;V5]<7AH%K2PI2I,KZ6-+Z6-+Z6-&N5-W_M0RAQ<$A@"*N6-+Z6-+Z6-+Y#-[U''2[8 TOK2<)>Q-+Z6-+Z6-+Z6X;V!!]LZ=HD?23<?O^Y66
-+Z6-+Z6-&N5]+[F/RAM<,?O3759(6M#X6M#X6M##)''D0+, SN#15;I<Z''&5-[V5-[V)#)*=/K.9HB_0;.61^+,;_&58_9BN&::;.;.;.070;>6?%80 HB@
HB@ HB@ HB@ HB@ ;>6?&H-0\GA0\GA0\GA0\GA0\GA0\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 50 164 0 50 171 1 50 177 2 56 178 3 64 241 3 67 246 3 73 255 4 74 255 5 63 191 7 66 194 10 71 196 10 79 255 12 59 167 12 82 255 14 77 199 18 83 201 19 88 255 21 91 255 23 89 204 27 95 206 28 97 255 29 72 179 30 100 255 32 101 209 36 106 255 36 107 211 39 109 255 41 113 214 45 115 255 45 119 216 48 118 255 50 87 176 50 125 219 51 88 176 51 88 177 52 89 178 52 90 178 53 90 178 53 127 212 54 91 179 54 123 255 54 131 221 55 92 180 55 95 181 56 93 180 56 94 181 57 127 255 57 149 229 58 99 184 58 137 224 61 104 187 63 132 255 63 143 226 64 108 190 66 113 193 66 135 255 67 149 229 68 157 232 69 117 196 71 155 231 72 122 199 72 141 255 75 126 202 75 144 255 75 160 234 77 163 236 78 131 206 80 149 255 81 136 209 84 140 212 84 153 255 87 145 215 88 157 255 91 168 235 93 161 255 94 154 222 96 157 223 96 165 255 97 159 225 98 160 225 98 162 226 99 163 227 100 165 228 101 166 229 101 170 255 102 167 230 103 169 231 104 170 232 104 173 255 105 172 233 105 174 234 106 175 235 109 178 255 112 180 255 117 186 255 119 187 255 122 154 245 125 160 253 125 193 255 126 161 253 126 194 255 127 127 175 127 128 175 127 162 254 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 130 165 254 132 200 255 132 201 255 135 170 255 139 207 255 140 175 255 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 179 255 144 191 239 149 184 255 153 188 255 157 192 255 159 159 192 159 160 192 159 160 207 159 160 208 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 162 196 255 166 200 255 170 204 255 174 208 255 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 177 212 255 181 215 255 185 219 255 188 222 255 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 225 255 192 192 208 192 239 255 192 240 255 207 143 95 207 207 191 207 223 239 207 239 240 207 255 255 208 208 223 208 224 239 208 255 255 212 211 224 217 217 217 218 217 230 219 219 230 220 220 231 222 221 232 223 128 63 223 255 255 225 225 234 226 226 237 227 227 236 227 227 238 228 228 237 229 229 239 231 230 238 231 231 238 231 231 240 232 232 241 233 232 239 233 233 240 234 234 242 235 234 241 236 236 243 237 236 242 237 237 244 238 237 243 239 238 243 239 239 240 239 239 245 239 255 255 240 207 144 240 239 244 241 240 245 241 241 246 242 242 246 242 242 247 243 243 247 244 244 248 245 244 247 246 246 249 246 246 250 247 246 249 247 247 250 248 248 251 249 249 250 249 249 251 249 249 252 250 250 251 251 251 252 251 251 253 253 253 254 254 254 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????????>@@C');
                            yourself);
                yourself
        ]
!

viewNoDetails22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewNoDetails22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#viewNoDetails22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class viewNoDetails22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)SM"H Z!!D2E5LLRMU1J.\";APA=BRRA"\\Y!!(G5U$;]3ID8E$T4D#6=KR<^D#FVC]7B0"&L5C9=X "=<K[%KR4,,S;,1
+EB$#)0\^LNZEWR)I&QQ/%,7]",[)ZV%)ZV%)ZV%)ZV%)XXWFF&3Q2)Z":V%)ZV%)ZV%)ZV%)XXWFF&3Q9Q> C2%)XTYFQ&%)ZV%)ZU:E1 V,4\I/50=)ZV%
)ZV%)ZV%)XXWZF&3Q9PI^##@**V%)ZV%)ZV%)XZ%ZF%EQ9P''^+0:W*.%)QPYFQ&%)ZTH)ZU:FA V,4\4"S$?)ZV%)ZV%)ZTWZKIEQ9P''^+04(0B''+ZV%)ZV%
)ZTWZKIE$)P''^+04(1XBXJ>%)Q$YFQDWZJTH)ZU:E1 V,4]&R#-A)ZV%)ZTWZL%E$ "%^+1Y(1Y&2D0;1ZV%)ZTWZL%E$  ''^+1Y(1Y&2DP)N;F%)Q''JZ,IE
$*TH)ZV%FA V,4^P&S-'')ZTWZL%E$ !!9.+1Y(1Y&2DRPIP4;P8 Z@PNV&I,NWU>(Z15-R$0)&P4PN:J6T%R8A0-? Y6^L#Z&N3,;N3,;N6:%)ZV%)ZV%)ZV%
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 227 227 236 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 244 244 249 242 242 247 118 118 122 72 122 199 116 116 120 218 217 230 237 236 242 72 141 255 212 211 224 141 141 141 32 101 209 63 143 226 133 133 133 153 188 255 234 234 242 253 253 254 251 251 252 127 127 127 249 249 250 106 175 235 170 204 255 227 226 235 135 135 138 7 66 194 0 50 164 58 137 224 75 160 234 123 123 126 66 135 255 226 226 237 140 175 255 243 243 247 119 119 122 220 220 231 240 239 244 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 237 237 244 80 149 255 55 95 181 125 160 253 233 233 240 52 89 178 231 231 238 50 87 176 105 172 233 104 170 232 138 138 140 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 229 229 239 248 248 251 124 124 126 246 246 249 122 122 124 2 56 178 223 223 233 3 73 255 222 221 232 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 128 128 133 81 136 209 101 170 255 126 126 131 36 107 211 54 123 255 238 238 244 56 94 181 126 161 253 55 92 180 235 234 241 53 90 178 233 232 239 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 232 232 241 96 157 223 251 251 253 249 249 251 125 125 126 228 228 237 123 123 124 225 224 234 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 243 243 248 241 241 246 117 117 121 28 97 255 109 178 255 238 237 243 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 132 132 132 254 254 255 128 128 128 250 250 251 229 229 237 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 227 227 238 39 109 255 246 246 250 93 161 255 244 244 248 120 120 123 242 242 246 118 118 121 241 240 245 219 219 230 157 192 255 239 238 243 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 236 236 243 181 215 255 255 255 255 52 90 178 51 88 177 231 230 238 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 249 249 252 247 247 250 123 123 125 121 121 123 87 145 215 84 153 255 78 131 206 10 79 255 241 241 247 91 168 235 239 239 245 115 115 120 127 162 254 236 235 242 54 91 179 14 77 199 138 138 139 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 231 231 240 250 250 252 126 126 127 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????@@@C@@@C');
                            yourself);
                yourself
        ]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-24x24'!

browseClassExtensions24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self browseClassExtensions24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#browseClassExtensions24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class browseClassExtensions24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
NP(JB (JB (JB (JNP@@@@@@@@@@@@@@B)FQ$YFQ$YFQ$YD9B @@@@@@@@@@@@@@B)E,[F1,[F1,[F0RB @@@@@@@@@@@@@@B)E,[F1,[F1,[F0RB @@@K:X
@@@@@@@@B)E,[F1,[F1,[F0RB @@(,/@40@@@@@@B#$RD!!HRD!!HRD!!HRB @@+KRU, @@@@@@NP(JB (JB (JB (JNP@@1Y[B, @@@@@@@@@@@@@@@@ADEQPX
IR)P5IN$*@@@@@@@@@@@@@@@@A,''RE!!YUD@(H&^/*KZ\-;\@@@@@@@@@J6%1\WECA TEJQ!!''%ZF)):_P@@@@@@@,X''E1\WECA LES%$U.\^%2,*;@@@@@DX?
 WE1\WECA PDS%$ L[^5/;<@@@@@@CMR\U-NS$9NA 4MS$9ND0@@@@@@@@@@@B1YVT8KB@4MC 8NC 4EE0@@@@@@@@@@@B1&R4LKA 4NC0<OC08EGP@@@@@@
@@@@@B1YUTLKC@8ODQDQD@<EGP@@@@@@@@@@@B5IVT5CP4MCB0,KP4MCE@@@@@@@@@@@@DT5VU%YVU%CB0,KP5%YF @@@@@@@@@@@@@_PE%YVU%CB0,KP5$\
Y0@@@@@@@@@@@@@$G4%&VU%CB0,KP3H<@@@@@@@@@@BP %4#E!!<6T6Y1Z&MQL#4@@@@@@@@@@H>M#E0!!@@@%FQ8&MCH>U0@@@@@@@@@@#8:L[S(0@@@@@@@@
@@@@@@@@@@@@@@@@#(1-N2<@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 32 223 32 40 255 124 50 255 112 51 255 109 54 229 139 62 255 87 62 255 88 62 255 91 62 255 136 64 64 64 73 255 115 83 255 62 91 255 73 94 255 74 101 255 84 105 255 85 112 255 96 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 170 170 170 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 176 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 183 183 183 190 190 190 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 196 196 196 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 217 217 217 223 32 32 223 128 63 223 192 255 223 223 32 223 223 224 223 255 255 224 224 224 224 224 239 224 239 240 224 255 255 231 207 255 231 208 255 238 191 255 238 192 255 239 159 232 239 191 255 239 223 255 239 224 255 239 239 224 239 239 239 239 239 240 239 255 255 240 207 144 240 239 223 240 240 239 240 255 255 246 176 255 247 175 255 247 207 255 247 239 255 254 160 255 254 191 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255 176 175 128 176 240 159 143 159 128 127 208 96 175 239 144 15 79 0 160 176 95 0 160 0 64 176 48 112 159 95 0 96 0 144 159 143 96 207 80 127 159 111 63 175 48 96 207 79 80 176 64 31 159 31 143 224 112 64 176 63 95 207 79 63 160 47 0 127 0 80 191 64 176 240 144 143 239 112 15 160 15 16 95 16 0 80 0 143 224 111 191 240 159 175 240 144 15 127 15 0 175 0 144 239 127 0 79 0 0 112 0 0 95 0 15 112 15 111 207 80 16 79 16 15 79 15 16 80 16 128 223 111 159 159 63 15 64 15 31 144 16 16 80 15 128 224 111 176 239 159 95 112 80 15 175 15 144 224 127 95 192 79 31 95 15 32 160 31 48 159 47 32 159 31 15 128 15 95 160 47 0 111 0 127 223 96 15 80 0 64 112 63 159 239 127 95 159 79 16 175 16 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'?? @?? @?? @??#@??'' ??'' ??'' @O? @_?>@???A???C??>C?? C?? C?? C?? C?? C?? A?? A??@O?>@_O<@?@@@>@@@');
                            yourself);
                yourself
        ]
!

changesBrowser24x24Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self changesBrowser24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#changesBrowser24x24Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class changesBrowser24x24Icon2'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ HB@ HB@ HB@ HB@@@@@@@@@@@B#8>O#8>O#8VB (JB %XB@@@@@@@@@ HB@ HB@ HB@ HB@ HB
@%,B@@@@@@@@@(>O#8VB#8>E (JB (IV@%4B@@@@@@HB@ HB@ HB@ HB@ HB@ I[@$ B@@@@@@JO#8>E (JB!!XJB (JBV0I]@$$B@@@@@@JO@PDA!!V 3APPH
EQ,=]PI]@$$B@@@@@@JO#8>GS0,WM4UFPS@XD%Y]@$$B@@@@@@JO@X=OGE"O#8>O#8>O#0!!V@$$B@@@@@@JO#6P]TX>O#8>O#8>O#1<E]T$B@@@@@@JO@ST/
#8>R$)JR#9JR#9DPH HB@@@@@@JOZBRO#8>O#8>O#8>O#9D0@0@@@@@@@@HBYA6O$(>R#9JR$(>R#9EBA0@@@@@@@@@@YA6O#8>O#8>O#8>O#9EYCP@@@@@@
@@@@YA6O$)JR$(>R$(>R#9ETCP@@@@@@@@@@YA88#8>O#8>O#8>O$IERA@@@@@@@@@@@]SP&$YFQ$YFQ$YFQ$YD6B @@@@@@@@@@@D<OLEQCQ5%*^G6O#6$L
@@@@@@@@@@@@^&PTC3!!UUU%%YV)=]"L,@@@@@@@@@@BN^T0SA <''PEU%VUH>H24@@@@@@@@@@H6K"$,QSP@UBP8VIRL.Q@@@@@@@@@@@#X2JX2(!!@@@@@@@@
@@@@@@@@@@@@@@@@#H)#J2@@@@@@@@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[0 0 0 78 78 91 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 156 156 182 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 201 201 218 204 204 219 206 206 221 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 210 210 224 211 211 225 213 213 228 215 215 229 216 216 230 218 218 231 219 219 232 220 220 233 222 222 235 223 128 63 223 223 224 223 255 255 224 224 224 224 224 236 224 224 239 224 239 240 224 255 255 225 225 237 228 228 238 229 229 239 230 230 240 232 232 241 234 234 243 235 235 244 236 236 244 238 238 245 239 239 224 239 239 239 239 239 240 239 239 246 239 255 255 240 207 144 240 239 223 240 240 239 240 240 247 240 255 255 241 241 248 242 242 249 243 243 249 244 244 250 245 245 252 246 246 253 248 248 254 249 249 254 250 250 255 252 252 255 253 253 255 254 254 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255 247 255 255 191 191 191 166 166 173]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@A??8A??8G??8G??8_??8_??8_??8_??8_??8_??8_??8_?? _?? G?? G?? G?? G?? C??@G??@O?>@_/<@?@@@>@@@'); yourself); yourself]
!

fileBrowser24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileBrowser24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#fileBrowser24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileBrowser24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C0@@@@@@@@@@C@0@A XFA XFA XFA XF
@@@@@@@@@@@@C@0@A @@@@@@@@@@@@@F@@@@@@@@@@@@C@0@A @NC 8NC 8NC @F@@@@@@@@@@@@C@0@A @NC 8@@@@@@@@@@@@@@@@@@@@@C@0@A @NC 8@
DA@PDA@PDA@P@@@@@@@@C@0@A @@C 8@DA@PDA@PDA@P@@@@@@@@C@0@A @A@@8@DA@P@@@@@A@P@@@@@@@@C@0@A @@@P@@DA@P@A@P@A@P@@@@@@@@C@0@
A @@@@D@DA@PDA@PDA@P@@@@@@@@C@0@A @@@@@@DA@PDA@PDA@P@@@@@@@@C@0@A @P@@@@DA@PDA@PDA@P@@@@@@@@C@0@A @PD@@@@@@@@@@@@@@@@@@@
@@@@C@0@A @PD@@@@@@@@@@@@@@@@@@@@@@@C@0@A @PDA@PDA@PD@@F@@@@@@@@@@@@C@0@A @PDA@PDA@PD@@F@@@@@@@@@@@@C@0@A @@@@@@@@@@@@@F
@@@@@@@@@@@@@@0@A XFA XFA XFA XF@@@@@@@@@@@@@@@@A XFA XFA XFA XF@@@@@@@@@@@@@@@O@@@@@@@@@@@@@@@@C0@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 64 64 64 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170 227 227 22 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@O?? O?? O?? O?? O??<O??<O??<O??<O??<O??<O??<O??<O??<O?? O?? O?? O?? G?? C?? A?? @@@@@@@@');
                            yourself);
                yourself
        ]
!

home24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self home24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#home24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class home24x24Icon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3=EI"X5O3<?O3<?O3<?O3<?O3<GA3<?O3<%E1HPO3<?O3<?O3<?O3<?O0\GA3(''@C<%E28PO3<?O3<?O3<?O3<?N \GN!! XFA GP LP
O3<?O3<?O3<?O3<:A0\XFB\XF@\GM3\PO3<?O3<?O3<?O0\GA1 XFA XA0\7N#DCKC<?O3<?O3<?A0\GFA XFC(GA3\:H3H]JTT?O3<?O3<GA3(XFA XN \G
M0\#C2<_GR%EO3<?O0\GN!! XFA :A3\7N"LOK0,KEBX&MS<?A0\:FA XFC(GM3\:H2</EP,TECL!!I",?O1LXFA XA0\7M4HYBP<UB1PTL11CQ$X?O0HSFA G
A3\7P!!$IC1TKEAP3GA1APTX?O0HVJA4GM3]BC (/EP,KECL\G@EAOCX?O0H<PB ]P$HFBR<UB1P0J!!9F@TD<OCX?O0IGP@TVQDPVC1TKEAP"H"HZPS0<OCX?
O0HVAPTVE  <EP4TECL"H"HZOC1GQ3X?O0IGOAXVE" VB0,TL10"H"HZOC0<Q3X?O3<BAQXVBDPVB1PTGA0"H"H8OD]GQ3X?O3<?CAXHJDP(ECL3GDD"H"H6
Q4]GJCX?O3<?O01DQDP(ICL\@TDQDQ)FQ0HLNDX?O3<?O3<LKTP(L10APS0ZM#X6Q#$?O3<?O3<?O3<?Q!!-DG@D4@#$DHC<?O3<?O3<?O3<?O3<?O3$=M!!(9
O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?')
            colorMapFromArray:#[255 227 154 199 228 240 160 180 218 224 128 58 153 154 204 171 215 254 183 188 202 255 175 75 154 204 254 250 250 253 247 250 254 231 239 246 148 168 214 233 244 254 249 239 209 243 249 254 241 130 102 116 120 164 247 90 41 171 184 198 223 234 245 236 243 248 163 209 243 154 1 2 254 198 97 249 239 223 118 129 180 135 168 220 209 227 243 203 175 133 160 166 205 240 240 248 187 188 214 163 143 171 102 107 152 253 246 240 215 235 254 204 127 124 166 130 141 253 210 112 161 200 234 171 113 93 181 197 216 211 215 222 230 217 192 142 177 227 222 50 7 245 246 249 205 209 228 239 169 152 254 254 240 216 228 239 190 205 229 228 205 209 133 142 186 254 156 57 130 140 161 171 171 200 252 178 93 245 230 190 183 217 237 130 154 203 244 219 172 0 0 0 183 232 253 204 218 236 237 147 68 212 219 234 146 189 237 220 198 190 149 152 191 170 211 227]
            mask:((Depth1Image width:24 height:24) bits:(ByteArray fromPackedString:'@@O@@LO@@_/@@??@A??@C?? G??0O??8_??<???>_??>_??>_??>_??>_??>_??>_??>O??>G??>C??>A??0@?<@@_@@@@@@'); yourself); yourself]
!

left2Arrow24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self left2Arrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#left2Arrow24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class left2Arrow24x24Icon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
%)ZVM3^V%)X7M3\7M3\7%)ZVM3\7M3^V%)ZVM3^V%)X7M3\7Y#T@%)ZVM3\7M3^V%)ZVM3^V%)X7M0A&TT0@M9ZVM3\7M3^V%)ZVM3^V%)X7@E8,I3T@M9ZV
M3\7M3^V%)ZVM3^V%)X@TSL>FST@M9ZVM3\7M3^V%)ZVM3^V% @$!!!!%]T#T@M9ZVM3\7M3^V%)ZVM3^VW"P?"%ZEICT@M9ZVM3\7M3^V%)ZVM3]^S@16^H9L
CCT5MST5MST5N0$@M3\7M58EHWQ#W T!!]FNW%6=/MCP4H@D@M3\@TUQ\MIEQUE04"FEMIRT"RP<9LCT@M0BG_)\HT(]>%0 (JAQ+#8<ZA2-,#ST@M8]2DFQN
!!7HPYD9 XFAW#4E;^%MG"3T@M8\RVFI !!1IXX&A_W8ROGV!!UK&\^TCT@M0@;#DIP]3.LP%@@\G@_B )UT6\^@#T@M3\@A#5OE)@FOT<VC :S_8A)_UU)IST@
M3\7@HL:RS2B 3)IOF,%IWA0H"JTVPD@DQDQDPA%IA,SR&T$F3T5MST5MST5@W$@DQDQDQD@ RPDC$*AICT@@@@@@@@@@@@@DQDQDQDQ@HD$\X=J@3T@@D)J
R$)JR$)JDQDQDQDQDQFAA&4UJ#T@@ADQDQDQDQDQDQDQDQDQDQDQ@HMFV#T@R!!DQDQDQDQDQDQDQDQDQDQDQDPBIV3T@R!!DQDQDQDQDQDQDQDQDQDQDQDQD@
CQ\@R!!DQDQDQDQDQDQDQDQDQDQDQDQDQ@@@@R!!DQ@@@@@@@@')
            colorMapFromArray:#[132 239 107 16 150 16 132 239 123 189 215 181 57 199 49 41 166 41 41 158 41 82 231 82 173 251 148 57 166 57 90 211 74 214 211 214 173 235 156 148 199 148 115 239 99 107 235 107 189 251 173 247 243 239 107 211 99 132 247 123 140 247 123 66 227 57 148 247 132 33 154 33 123 195 123 231 255 214 90 231 82 90 227 82 222 227 214 99 223 82 90 207 82 99 215 82 181 251 173 181 239 165 115 239 107 115 227 99 8 150 8 123 239 115 140 247 115 206 243 181 148 247 123 173 170 156 74 231 66 74 227 74 49 166 49 115 142 222 82 203 66 222 231 214 173 251 165 222 223 222 99 223 90 82 182 74 189 255 173 0 146 0 123 243 107 247 243 247 247 239 247 123 239 123 24 162 24 24 154 24 148 251 132 41 174 41 222 251 206 140 215 132 90 235 82 90 235 90 173 251 156 107 239 90 99 219 82 222 219 222 0 158 0 99 211 90 231 227 231 115 235 107 247 239 239 255 255 255 16 154 16 132 243 123 140 243 123 140 243 132 148 243 132 41 162 41 206 227 206 74 203 66 66 178 57 82 207 74 181 251 156 107 235 90 181 251 165 107 235 99 33 211 24 0 150 0 189 247 173 198 251 173 90 182 90 132 243 115 140 243 115 148 251 123 148 243 123 156 251 132 156 243 132 123 190 123 132 199 132 74 199 66 90 215 74 90 215 82 222 219 214 107 239 99 99 227 99 8 170 8 239 235 231 189 255 181 123 239 107 24 182 24 115 211 99 206 255 189 214 255 189 214 255 198 222 255 198 198 223 198 165 251 140 49 162 49 82 215 74 90 223 82 214 207 206 90 211 82 82 190 74 99 219 90 99 215 90 156 203 156 239 235 239 82 174 82 132 243 107 173 215 173 107 195 99 24 158 24 156 251 123 115 186 107 222 255 206 156 243 140 66 190 57 165 251 156 140 203 140 99 235 90 222 227 222 231 239 231 107 227 90 107 223 90 115 235 99 239 243 239 247 247 247 198 255 181]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@0@@A0@@C0@@G0@@O0@@?0@A??>C??>G??>O??>_??>_??>O??>G??>C??>A??>@?0@@_0@@O0@@C0@@A0@@@0@@@@@'); yourself); yourself]
!

leftArrow24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self leftArrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#leftArrow24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class leftArrow24x24Icon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
%)ZVM3^V%)X7M3\7M3\7%)ZVM3\7M3^V%)ZVM3^V%)X7M3\7W!! @%)ZVM3\7M3^V%)ZVM3^V%)X7M3]&TT0@M9ZVM3\7M3^V%)ZVM3^V%)X7@E8,I3T@M9ZV
M3\7M3^V%)ZVM3^V%)X@TSL>FST@M9ZVM3\7M3^V%)ZVM3^V%%8$!!!!%]"#T@M9ZVM3\7M3^V%)ZVM3^VW"P?"%Y ]ST@M9ZVM3\7M3^V%)ZVM3]^S@16^B!!J
]CT5MST5MST5N0$@M3\7M58EHWQ#XQQ \9^W%6=/MCP4H@D@M3\@TUQ\MH!!!!JBY_TD9MIRT"RP<9LCT@M0BG_)\HJB TI%<6M 9+#8<ZA2-,#ST@M8]2DFQN
XFA W3X6C&-W#4E;^%MG"3T@M8\RVFI W5>DM#XNZ4NOGV!!UK&\^TCT@M0@;#DIP@GA0H 9+U3H_B )UT6\^@#T@M3\@A#5OE 8NC%&RH9NS_8A)_UU)IST@
M3\7@HL:RS1+U4P_S"T%IWA0H"JTVPD@DQDQDP@@IA,S$1=)H#T5MST5MST5@W$@DQDQDQD@@BPDC#HJP3T@@@@@@@@@@@@@DQDQDQDQ@@@$\X<]PCT@@D)J
R$)JR$)JDQDQDQDQDQD@A&4UJ#T@R!!DQDQDQDQDQDQDQDQDQDQDQ@HMFV#T@R!!DQDQDQDQDQDQDQDQDQDQDQDPBIV3T@R!!DQDQDQDQDQDQDQDQDQDQDQDQD@
CQ\@R!!DQDQDQDQDQDQDQDQDQDQDQDQDQ@@@@R!!DQ@@@@@@@@')
            colorMapFromArray:#[132 239 107 16 150 16 132 239 123 189 215 181 57 199 49 41 166 41 41 158 41 82 231 82 173 251 148 57 166 57 90 211 74 214 211 214 173 235 156 148 199 148 115 239 99 107 235 107 189 251 173 247 243 239 107 211 99 132 247 123 140 247 123 66 227 57 148 247 132 33 154 33 123 195 123 231 255 214 90 231 82 90 227 82 222 227 214 99 223 82 90 207 82 99 215 82 181 251 173 181 239 165 115 239 107 115 227 99 8 150 8 123 239 115 140 247 115 206 243 181 148 247 123 173 170 156 74 231 66 74 227 74 49 166 49 115 142 222 82 203 66 222 231 214 173 251 165 222 223 222 99 223 90 82 182 74 189 255 173 0 146 0 123 243 107 247 243 247 247 239 247 123 239 123 24 162 24 24 154 24 148 251 132 41 174 41 222 251 206 140 215 132 90 235 82 90 235 90 173 251 156 107 239 90 99 219 82 222 219 222 0 158 0 99 211 90 231 227 231 115 235 107 247 239 239 255 255 255 16 154 16 132 243 123 140 243 123 140 243 132 148 243 132 41 162 41 206 227 206 74 203 66 66 178 57 82 207 74 181 251 156 107 235 90 181 251 165 107 235 99 33 211 24 0 150 0 189 247 173 198 251 173 90 182 90 132 243 115 140 243 115 148 251 123 148 243 123 156 251 132 156 243 132 123 190 123 132 199 132 74 199 66 90 215 74 90 215 82 222 219 214 107 239 99 99 227 99 8 170 8 239 235 231 189 255 181 123 239 107 24 182 24 115 211 99 206 255 189 214 255 189 214 255 198 222 255 198 198 223 198 165 251 140 49 162 49 82 215 74 90 223 82 214 207 206 90 211 82 82 190 74 99 219 90 99 215 90 156 203 156 239 235 239 82 174 82 132 243 107 173 215 173 107 195 99 24 158 24 156 251 123 115 186 107 222 255 206 156 243 140 66 190 57 165 251 156 140 203 140 99 235 90 222 227 222 231 239 231 107 227 90 107 223 90 115 235 99 239 243 239 247 247 247 198 255 181]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@0@@A0@@C0@@G0@@_0@@?0@A??>C??>G??>O??>_??>_??>O??>G??>C??>@??>@_0@@O0@@G0@@C0@@A0@@@0@@@@@'); yourself); yourself]
!

leftArrow24x24Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self leftArrow24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#leftArrow24x24Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class leftArrow24x24Icon2'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UB0TEAP,KD1\WE1\WE1\WE1\WE1\SE@TKEQTUEQHOA@PUE1\WE1\WE1\WE1<EEA< GQ4VEAHRD <D
B!!\WE1\WE1\WGPT]G14]EQPTD!!HRD!!HRA@(WE1\WE1\%AQ4]GQTVEA$ HAHRD!!HRD  NE1\WE1\KEA4]EQXRE"4/K1XRD!!HRD!!HCD1\WE14EGQTVEAHYK"</
K1PRD!!HRD!!HO@1\WE0,TEQPRD!!P/K2</GQHRD!!HRD!!HO@1(WD0@TEAHRE"0/K2<]D!!HRD!!HRC0<OB@8WD0TRD!!HTJ2</K2 ]GQ4 GQ4]E@<OB 0WD0PRD!!X,
K2</K2</K2<.K"</GP<IBPHWD0PRD!!P*K2</K2</K2</K2</GP$IA@HWD0PRD!!HVJ2</K2@]GQ4]GQ4]E@$IA@HWD0@RD!!HREB(/K28TC0<OBP$IBP$I@04W
E0 OD!!HRD!!P.K2<*E@<IBP$IBPTE@!!LWE1THD!!HRD!!HTJ"</JP<IBP$IAPTE@QLWE1LCC1HOC0<OEB$/K14IBPTEAPTBDQ\WE1\X@0<OC0<OBQH)JQPEAPTE
AP@AD1\WE1\WD@LOC0$IBP$IBPTEAPTE@@D^E1\WE1\WE08BBP$IBP$EAPTEAPTB@Q,WE1\WE1\WE1\X@ LDBPTEAPT@@0DFD1\WE1\WE1\WE1\WEQLG@PHB
@ DAA!!,WE1\WE1\WE1\WE1\WE1\SD1LSD1LSE1\WE1\WE1\W')
            colorMapFromArray:#[0 156 0 8 82 0 8 115 8 24 131 16 24 164 16 24 180 8 41 90 32 41 123 41 49 156 24 49 180 24 57 164 32 57 197 57 65 139 41 65 139 65 74 172 74 82 189 32 98 164 106 106 139 98 106 197 49 115 172 123 115 205 74 123 205 123 131 222 90 131 238 106 139 189 139 148 180 82 156 197 164 164 164 164 172 205 172 172 222 148 180 180 180 180 230 189 189 230 172 197 197 197 197 213 189 205 205 205 205 222 205 205 238 213 222 230 222 222 238 222 222 246 213 238 246 238 246 246 238 246 246 246 255 246 238 255 255 238 255 255 246 255 255 255]
            mask:((Depth1Image width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@O<@A??@C?? G??0O??8O??<_??<_??>???>???>???>???>???>???>_??>_??>_??<O??<G??8C??0A?? @?>@@O8@'); yourself); yourself]
!

leftArrow24x24disabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self leftArrow24x24disabledIcon inspect
     ImageEditor openOnClass:self andSelector:#leftArrow24x24disabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class leftArrow24x24disabledIcon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@PD@@@@A@PDA@PDA@@@@@PDA@PD@@@@@@PD@@@@A@PDAVE D@@@@@PDA@PD@@@@@@PD@@@@A@PEXA \@@P@@@PDA@PD@@@@@@PD@@@@A@@(KC@4@@P@@
@PDA@PD@@@@@@PD@@@@@A <PDP4@@P@@@PDA@PD@@@@@@PD@@ALSEADUE 4@@P@@@PDA@PD@@@@@@PD@D1LXE!!$ZD@4@@P@@@PDA@PD@@@@@@PEXA10]G!!<Z
H@4MCP4MCP4MHRHD@PDA@P(#G"@$IRXZI2 (JATUEQTUBB$@@PD@A"(HER,%G20-K"<0LSD2L3P5M 4@@P@7NB 9G1<&KB4DAC(;OC0=O#=@PP4@@S\>P$L/
F!!(ZKPPDN#-DOA-EQ$\?R@4@@S]IR"XZKR4-A@P:N1 <O$-LST8TK 4@@P@!!S1H.ACD1L#(;Q@TCQ$YLQ48TT@4@@PD@TUH,P3(:N#P[T5QTUUYWQ$1WLP4@
@PDA@E!!YL10;QDTCK3D1LSD1L#H;MB$@DQDQDPAXD38/U@MWL 4MCP4MCP4MJRL@DQDQDQD@VALON UFF@4@@@@@@@@@@@@@DQDQDQDQ@E SV30>W@4@@E)Z
V%)ZV%)ZDQDQDQDQDQEXTU5FU 4@V!!DQDQDQDQDQDQDQDQDQDQDQ@E!!_X@4@V!!DQDQDQDQDQDQDQDQDQDQDQDPAXXP4@V!!DQDQDQDQDQDQDQDQDQDQDQDQD@
VE4@V!!DQDQDQDQDQDQDQDQDQDQDQDQDQ@@@@V!!DQDQDQDQDQ')
            colorMapFromArray:#[251 251 251 249 249 249 234 234 234 210 210 210 224 224 224 213 213 213 184 184 184 176 176 176 238 238 238 245 245 245 200 200 200 187 187 187 240 240 240 171 171 171 233 233 233 198 198 198 246 246 246 249 249 249 236 236 236 174 174 174 207 207 207 241 241 241 247 247 247 226 226 226 219 219 219 237 237 237 227 227 227 216 216 216 231 231 231 247 247 247 234 234 234 229 229 229 245 245 245 178 178 178 188 188 188 185 185 185 232 232 232 231 231 231 228 228 228 244 244 244 242 242 242 175 175 175 193 193 193 232 232 232 228 228 228 225 225 225 229 229 229 227 227 227 226 226 226 223 223 223 221 221 221 220 220 220 219 219 219 223 223 223 237 237 237 179 179 179 200 200 200 236 236 236 221 221 221 220 220 220 217 217 217 214 214 214 213 213 213 210 210 210 215 215 215 235 235 235 239 239 239 230 230 230 218 218 218 212 212 212 208 208 208 202 202 202 230 230 230 211 211 211 238 238 238 209 209 209 205 205 205 204 204 204 201 201 201 197 197 197 225 225 225 183 183 183 187 187 187 217 217 217 214 214 214 212 212 212 211 211 211 209 209 209 196 196 196 180 180 180 248 248 248 186 186 186 215 215 215 180 180 180 240 240 240 174 174 174 196 196 196 172 172 172]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@0@@A0@@C0@@G0@@_0@@?0@A??>C??>G??>O??>_??>_??>O??>G??>C??>A??>@?0@@_0@@O0@@C0@@A0@@@0@@@@@'); yourself); yourself]
!

right2Arrow24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self right2Arrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#right2Arrow24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class right2Arrow24x24Icon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HDAP@@@@@@@@@@@@@@@@@@@@@@@@@@@@HFA0 @@@@@
@@@@@@@@@@@@@@@@@@@@@@HJB00M@@@@@@@@@@@@@@@@@@@@@@@@@@HODADRD1$@@@@@@@@@@@@@@@@@@@@@@@HSFQXWFALY@@@@@@@@@ALZF1,[F1,[F1,_
AB@!!G!!<DH@@@@@@@@@HWB0,KB0,KB0,%I"\(JRT&I2 @J"(*@@HWJ20-K"</K#@3J3P[CST+MA,M@B(*@@H6M3 8KC$9LC@=O#<4PDEBO3Q@PP@*@@HPKSD8
NC 0P3EHO$%JR4(SRT)KR!!L@@@IMGSD1LSD1GDP>TUH>T4(ST#9SR!!L@@@IUETP:GC(:QT<>RUYWVE%ZU%]XVP@@@@I[EQ0\GA1\WE1IWE5^W6A\WU9_@@@@
@@HUXVE!!GS 8NFI$Q&U&Y6QFYVX@@@@*@ALB@ HB@ HB@ I*@&-''QF(BZ0@@@B(*@@@@@@@@@@@@@@HS\GE.[1M0@@@@J"(*J"()JP@@@@@@JPI.\''M4D0@@
@@@*J"(*J"(*J"(*J"(*J I5]'']_@@@@J"(*J"(*J"(*J"(*J"(*J I8^VX@@@@*J"(*J"(*J"(*J"(*J"(*J HB^0@@@@@*J"(*J"(*J"(*J"(*J"(*J I<
@@@@J"(*J"(*J"(*J"(*J"(*J"(*J @@@@@*J"(*J"(*J"(*')
            colorMapFromArray:#[240 240 240 223 224 216 0 144 0 159 200 152 16 144 16 112 184 112 207 240 184 48 160 48 80 176 80 224 232 224 239 248 208 208 248 192 80 176 72 47 152 40 224 224 224 224 248 208 191 248 168 223 248 200 96 192 88 15 144 8 192 216 192 127 240 112 159 248 144 207 248 184 128 208 120 144 192 144 32 152 24 63 168 48 112 240 104 128 240 120 192 248 184 159 232 144 128 192 128 240 232 240 127 248 104 111 240 96 111 240 104 176 248 168 160 232 152 47 160 32 80 168 80 240 232 232 240 240 232 159 240 136 143 240 112 143 240 120 143 248 120 144 248 120 128 248 112 127 240 104 96 240 96 95 240 88 160 240 152 224 224 216 192 248 176 144 240 128 128 240 112 143 248 112 112 240 96 111 232 96 96 224 88 95 208 80 80 200 72 112 216 104 79 184 64 31 152 24 192 216 184 127 248 112 112 232 96 111 224 88 96 216 80 96 208 80 95 208 72 79 200 64 95 200 80 144 240 136 239 224 224 176 248 160 112 224 88 111 216 88 111 216 80 80 200 64 79 192 64 143 232 128 223 216 208 160 248 152 96 208 88 143 232 120 63 184 48 31 144 24 175 192 160 159 248 136 112 224 96 112 224 104 32 168 32 32 152 32 192 200 192 128 248 120 128 232 112 95 200 72 112 232 104 16 160 16 79 168 72 208 208 200 239 232 224 80 208 72 79 208 64 112 176 112 224 216 216 208 208 208 96 232 88 48 192 40 128 184 120 223 208 208 80 216 72 95 232 72 31 176 24 80 232 72 63 216 56 15 160 8 32 208 32 0 152 0 207 200 192 111 176 96 128 184 128]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@C@@@C @@C0@@C8@@C>@@C?@_?? _??0_??8_??<_??>_??>_??<_??8_??0_?? @C?@@C<@@C8@@C0@@C @@C@@@@@@'); yourself); yourself]
!

rightArrow24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self rightArrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#rightArrow24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class rightArrow24x24Icon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HDAP@@@@@@@@@@@@@@@@@@@@@@@@@@@@HFA0 @@@@@
@@@@@@@@@@@@@@@@@@@@@@HJB00M@@@@@@@@@@@@@@@@@@@@@@@@@@HODADRD1$@@@@@@@@@@@@@@@@@@@@@@@HQEQXWFALY@@@@@@@@@ALZF1,[F1,[F1,K
EQ0]G!!<DH@@@@@@@@@HWB0,KB0,KB0,KH!!0#IBT&I2 @J"(*@@HWJ20-K"</K#@0LQ0#L#L+MA,M@B(*@@H6M3 8KC$9LC@"GC(;OC4>O3Q@PP@*@@HPKSD8
NC 0P3D\QDUFQ4 >RT)KR!!L@@@IMGSD1LSD1GDQNS5AGRC9QT#9SR!!L@@@IUETP:GC(:QT=OQ$\=RC9IU%]XVP@@@@I[EQ0\GA1\WE1\Q4!!HO$%\WU9_@@@@
@@HUXVE!!GS 8NFH-RFL>O&QFYVX@@@@*@ALB@ HB@ HB@ H8O%E)QF(BZ0@@@B(*@@@@@@@@@@@@@@IDRT!!.[1M0@@@@J"(*J"(@@@@@JR$)JPI.\''M4D7@@
@@@*J"(*J"(*J"(*J"(*J I5]'']_@@@@J"(*J"(*J"(*J"(*J"(*J I8^VX@@@@*J"(*J"(*J"(*J"(*J"(*J HB^0@@@@@*J"(*J"(*J"(*J"(*J"(*J I<
@@@@J"(*J"(*J"(*J"(*J"(*J"(*J @@@@@*J"(*J"(*J"(*')
            colorMapFromArray:#[240 240 240 223 224 216 0 144 0 159 200 152 16 144 16 112 184 112 207 240 184 48 160 48 80 176 80 224 232 224 239 248 208 208 248 192 80 176 72 47 152 40 224 224 224 224 248 208 191 248 168 223 248 200 96 192 88 15 144 8 192 216 192 127 240 112 159 248 144 207 248 184 128 208 120 144 192 144 32 152 24 63 168 48 112 240 104 128 240 120 192 248 184 159 232 144 128 192 128 240 232 240 127 248 104 111 240 96 111 240 104 176 248 168 160 232 152 47 160 32 80 168 80 240 232 232 240 240 232 159 240 136 143 240 112 143 240 120 143 248 120 144 248 120 128 248 112 127 240 104 96 240 96 95 240 88 160 240 152 224 224 216 192 248 176 144 240 128 128 240 112 143 248 112 112 240 96 111 232 96 96 224 88 95 208 80 80 200 72 112 216 104 79 184 64 31 152 24 192 216 184 127 248 112 112 232 96 111 224 88 96 216 80 96 208 80 95 208 72 79 200 64 95 200 80 144 240 136 239 224 224 176 248 160 112 224 88 111 216 88 111 216 80 80 200 64 79 192 64 143 232 128 223 216 208 160 248 152 96 208 88 143 232 120 63 184 48 31 144 24 175 192 160 159 248 136 112 224 96 112 224 104 32 168 32 32 152 32 192 200 192 128 248 120 128 232 112 95 200 72 112 232 104 16 160 16 79 168 72 208 208 200 239 232 224 80 208 72 79 208 64 112 176 112 224 216 216 208 208 208 96 232 88 48 192 40 128 184 120 223 208 208 80 216 72 95 232 72 31 176 24 80 232 72 63 216 56 15 160 8 32 208 32 0 152 0 207 200 192 111 176 96 128 184 128]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@C@@@C @@C0@@C8@@C>@@C?@_?? _??0_??8_??<_??>_??>_??<_??8_??0_?? @C?@@C>@@C8@@C0@@C @@C@@@@@@'); yourself); yourself]
!

rightArrow24x24Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self rightArrow24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#rightArrow24x24Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class rightArrow24x24Icon2'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE08UB0TEAP,KC!!\WE1\WE1\WE1\WE1\NE@TKEQTUEQHOA@PUE1\WE1\WE1\WE1<EEA< GQ4VEAHRD <D
B!!\WE1\WE1\WGPT]G14]EQPTD!!HRD!!HRA@(WE1\WE1\NAQ5@L#H0MST2PCT3L3L3L0 NE1\WE1\KEA42LC85L388LTD5L3L3L1HCC!!\WE08EGQT0MSL3L3AB
LS!!AMSL3L1HO@1\WE0,TEQP5L3L3L3L2NR<6PSL3L1HO@1(WC @TEAH3L3L3L3L3L#,8LTD3L0<OB@8WC TRL3L0PCH2PCH2L$D/NB=AL0<OB 0WC PRL3L2
P#X/N3X/K2<6NCX/PP<IBPHWC PRL3L2K3 1K2<1K3 /NB<1O@$IA@HWC PRL3L0PCH2L#H2L$@/NB<<L0$IA@HWC @RD!!H3L3L3L3L3MS06NS03M0$I@04W
E0 OD!!H3L3L3MCP5OC /P3L7M0TE@ 8WE08HD!!H3L3L4MCUCK3X=O3\7N TE@P8WE08CC1H3MCP4MCH1K303M3(:N TBDQ\WE1\X@0<4MCP4M3T<OC<7N#(:
N @AC!!\WE1\WD@LOC0$IBP$IBPTEAPTE@@D^E1\WE1\WE08BBP$IBP$EAPTEAPTB@Q,WE1\WE1\WE1\X@ LDBPTEAPT@@0DFC!!\WE1\WE1\WE1\WC!!LG@PHB
@ DAA!!,WE1\WE1\WE1\WE1\WE1\WC 8NC 8WE1\WE1\WE1\W')
            colorMapFromArray:#[0 156 0 8 82 0 8 115 8 24 131 16 24 164 16 24 180 8 41 90 32 41 123 41 49 156 24 49 180 24 57 164 32 57 197 57 65 139 41 65 139 65 74 172 74 82 189 32 98 164 106 106 139 98 106 197 49 115 172 123 115 205 74 123 205 123 131 222 90 131 238 106 139 189 139 148 180 82 156 197 164 164 164 164 172 205 172 172 222 148 180 180 180 180 230 189 189 230 172 197 197 197 197 213 189 205 205 205 205 222 205 205 238 213 222 230 222 222 238 222 222 246 213 238 246 238 246 246 238 246 246 246 255 246 238 255 255 238 255 255 246 255 255 255 135 224 88 254 254 254 169 222 145 105 195 48 79 187 37 113 206 71 254 254 252 50 180 22 255 254 255 254 255 255 25 178 9 254 255 249 245 250 242 248 248 248 127 206 122 57 195 57 191 230 175 226 243 217 252 251 251 240 249 239]
            mask:((Depth1Image width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@_<@A??@C?? G??0O??8O??<_??<_??>???>???>???>???>???>???>_??>_??>_??<O??<G??8C??0A?? @?>@@G0@'); yourself); yourself]
!

rightArrow24x24disabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self rightArrow24x24disabledIcon inspect
     ImageEditor openOnClass:self andSelector:#rightArrow24x24disabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class rightArrow24x24disabledIcon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HDCP@@@@@@@@@@@@@@@@@@@@@@@@@@@@HFA0 @@@@@
@@@@@@@@@@@@@@@@@@@@@@HJB00MI@@@@@@@@@@@@@@@@@@@@@@@@@HN@P<PDRP@@@@@@@@@@@@@@@@@@@@@@@HOD1PUE!!D$@@@@@@@@@ADXFQ$YFQ$YFQ$K
D1([A!!0DGP@@@@@@@@HUB0,KB0,KB0,KG!!(_HBD"H2P@I"X&@@HUI2 (JR(*JR (J1(_@20''KQ$M@BX&@@HFK1LSJBH"JB ^F"@CE3@1L"43M@@&@@HAJB,S
D1L(JB,Z@3T]LCX1M3 /NAD@@@H9F2,+J2,+F L5N#,0M#D7OCD[NAD@@@H=D0L F"@ MS(:GS@0M#D7O!!,?P@@@@@HTD1(ZF!!)BP$IBLCX6LS]BP2MD@@@@
@@HSQ$YFF1LSD1((M T1LTD]MD\@@@@&@ADB@ HB@ HB@ HSLS\8@4 BM0@@@BX&@@@@@@@@@@@@@@HCM3X5R!!D6@@@@I"X&I"X%IRT%IRT%IPH5M$-LDSX@
@@@&I"X&I"X&I"X&I"X&I H;RD5DM @@I"X&I"X&I"X&I"X&I"X&I HHDT\@@@@&I"X&I"X&I"X&I"X&I"X&I HBS @@@@@&I"X&I"X&I"X&I"X&I"X&I H0
@@@@I"X&I"X&I"X&I"X&I"X&I"X&I @@@@@&I"X&I"X&I"X&')
            colorMapFromArray:#[247 247 247 238 238 238 170 170 170 218 218 218 173 173 173 205 205 205 239 239 239 185 185 185 196 196 196 241 241 241 248 248 248 242 242 242 195 195 195 182 182 182 245 245 245 245 245 245 203 203 203 173 173 173 230 230 230 224 224 224 232 232 232 242 242 242 215 215 215 213 213 213 179 179 179 189 189 189 221 221 221 224 224 224 228 228 228 210 210 210 226 226 226 220 220 220 221 221 221 236 236 236 228 228 228 184 184 184 193 193 193 244 244 244 247 247 247 230 230 230 226 226 226 229 229 229 229 229 229 223 223 223 218 218 218 231 231 231 239 239 239 227 227 227 208 208 208 203 203 203 214 214 214 197 197 197 178 178 178 215 215 215 207 207 207 202 202 202 205 205 205 236 236 236 213 213 213 212 212 212 200 200 200 233 233 233 208 208 208 194 194 194 176 176 176 219 219 219 216 216 216 216 216 216 179 179 179 225 225 225 227 227 227 193 193 193 204 204 204 231 231 231 194 194 194 214 214 214 186 186 186 178 178 178 201 201 201]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@C@@@C @@C0@@C<@@C>@@C?@_?? _??0_??8_??<_??>_??>_??<_??8_??0_?? @C?@@C>@@C<@@C0@@C @@C@@@@@@'); yourself); yourself]
!

sUnit24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sUnit24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#sUnit24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary sUnit24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
AEUUUUUUUUUUUTAEH"H"H"H"H"H"UEH"H"H"H"H"H"\5T"H"H"H"H"H"\3URH"H"H"H"H"\3MUH"H"H"H"H"\3L5T"H"H"H"H!!DCL3URH"H"H"H!!DEL3MUH"
HQH"H!!D@T3L5T"H DRH!!D@T3L3URH"HAD!!D@T3L3MUH"H @QD@T3L3L5T"H"T@D@T3L3L3URH"H%@@T3L3L3MUH"H"]PT3L3L3L5T"H"\3T3L3L3L3URH"\3
L3L3L3L3MUH"\3L3L3L3L3L5T"\3L3L3L3L3L3UR\3L3L3L3L3L3MTT3L3L3L3L3L3MTAEUUUUUUUUUUUT@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 170 170 170 127 127 127 127 127 127 214 132 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_??8???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<_??8');
                            yourself);
                yourself
        ]
!

stxHome24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxHome24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#stxHome24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class stxHome24x24Icon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
F1,[F1,[F1,[F1,[F1,NF!!(CF1,[F1,[F1,[F1,[F1,''I1,[F1,+L!!\"F1,[F1,[F1,[F1,[F2\''I0DUB1,+L $"F1,[F1,[F1,[F1,[@R\''@Q@PDA@''H1 "
F1,[F1,[F1,[F1,AI2\PDATPDB\''HRD"F1,[F1,[F1,[F2\''I1@PDA@PI2\!!@Q4XJ!!,[F1,[F1,[I2\''DA@PD@D''I2DA@ HYJ@8[F1,[F1,''I0DPDA@P@R\''
HR\B@ HBFR NF1,[F2\''@Q@PDA@AI2D!!@PHB@ HB@!!(Z@1,[I2\ADA@PD@D''HRDA@ HB@ HBK0HQF"$[F2PPDA@PI2\!!HRLB@"<B@ H/K0HBLSD[F00$DA@''
I2D!!H0HB@"</@ H/@ HB@#D[F00OGA$''HRD#@ HB@ H/K2</@ HB@"X[F000AQ0YH2LD@ HB@ HBK2</@ HB@"X[F00JAR@OG1<O@ HB@ H/K2</@ HB@"X[
F00OHB@OC240@ HB@ H/@ \/@ HB@"X[F00JL@<OC10O@ HB@"</@!!H/K0HB@"X[F1,LH@<OKQ<O@ HBK2<B@ HBK2<B@"X[F1,[D0<-GA<\@ HBK2<B@ HB
@ HB@"X[F1,[F1L_G1<\@ HB@ HB@ HB@"8.@CD[F1,[F1,SIQ<\@ HB@ HBI"X&LPX[F1,[F1,[F1,[LQ8_@ HBK XHE!!,[F1,[F1,[F1,[F1,[F0XTI"8F
F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[')
            colorMapFromArray:#[130 140 161 252 178 93 82 89 99 228 205 209 183 188 202 183 232 253 171 171 200 74 73 82 153 154 204 222 50 7 170 211 227 255 227 154 160 180 218 245 230 190 220 198 190 163 209 243 254 198 97 163 143 171 74 81 90 148 168 214 130 154 203 253 210 112 187 188 214 247 90 41 224 128 58 203 175 133 166 130 141 0 0 0 161 200 234 239 169 152 135 168 220 146 189 237 171 215 254 254 156 57 241 130 102 237 147 68 171 184 198 142 177 227 133 142 186 255 175 75 171 113 93 211 215 222 230 217 192 204 127 124 244 219 172 154 204 254 118 129 180 0 203 49 183 217 237 149 152 191 154 1 2]
            mask:((Depth1Image width:24 height:24) bits:(ByteArray fromPackedString:'@@O@@LO@@_/@@??@A??@C?? G??0O??8_??<???>_??>_??>_??>_??>_??>_??>_??>O??>G??>C??>A??0@?<@@_@@@@@@'); yourself); yourself]
!

systemBrowser24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self systemBrowser24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#systemBrowser24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class systemBrowser24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
P"H"H"H"P@@@@@@@I7]7]7]4H@@@@@@@I5UUUUUSH@@@@@@@I5UUUUUSH@@@@@@@I5UUUUUSH@@@@@@@ICL3L3L3H@@@@@@@P"H"H"H"P@@@@@@@@@@@L@@@
@@@@@@@@@@@@L@@@@@@@@@@@@@@@L@@DH"H"H"H$@@@@L@@B]7]7]7]B@@@CH0@B\QDQDQD2@@@B\#L3\QDQDQD2@@@CH0@B\QDQDQD2@@@@L@@BP3L3L3L2
@@@@L@@DH"H"H"H$@@@@L@@@@@@@@@@@@@@@L@@DH"H"H"H$@@@@L@@B]7]7]7]B@@@CH0@B]&Y&Y&X2@@@B\#L3]&Y&Y&X2@@@CH0@B]&Y&Y&X2@@@@@@@B
P3L3L3L2@@@@@@@DH"H"H"H$');
                colorMapFromArray:#[ 0 0 0 32 223 32 64 64 64 127 127 127 170 170 170 223 32 32 223 223 32 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'?? @?? @?? @?? @?? @?? @?? @@ @@@ @@@!!??@!!??A1??A???A1??@!!??@!!??@ @@@!!??@!!??A1??A???A1??@A??@A??');
                            yourself);
                yourself
        ]
!

systemBrowser24x24Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self systemBrowser24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#systemBrowser24x24Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class systemBrowser24x24Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
NP(JB (JB (JB (JNP@@@@@@@@@@@@@@B)FQ$YFQ$YFQ$YD9B @@@@@@@@@@@@@@B)E,[F1,[F1,[F0RB @@@@@@@@@@@@@@B)E,[F1,[F1,[F0RB @@@@@@
@@@@@@@@B)E,[F1,[F1,[F0RB @@@@@@@@@@@@@@B#$RD!!HRD!!HRD!!HRB @@@@@@@@@@@@@@NP(JB (JB (JB (JNP@@@@@@@@@@@@@@@@@@@@@@@@ADEQPX
IR)P@@@@@@@@@@@@@@@@@@@@@A,''RE!!YUD@(H&\@@@@@@@@@@@@@@@@@J6&Q XFA XEUJQ!!''B (JB (9@@@@@@@,X%,KB0 C@ LGA TU_9FQ$S$J@@@@@DX?
 U,KBPPDA@PDA X LPDA@QHJ@@@@@CMR\U,K@0 GA 4MA 4ED0DA@QHJ@@@@@B1YVT8KB@4MC 8NC 4EE0DA@QHJ@@@@@B1&R4LKA 4NC0<OC08EGQHRD!!HJ
@@@@@B1YUTLKC@8ODQDQD@<EGP(JB (9@@@@@B5IVT4KB0,KB0,KB0,KE@@@@@@@@@@@@DT5VT4KB0,KB0,KB0-GF (JB (9@@@@@@@_PD5MST9NS$9NS&,\
Y9FQ$S$J@@@@@@@$G4%&Y&)1\WVE CH<[6=/[1HJ@@BP %4#E!!<6T6Y1Z&MQL#6B[6=/[1HJ@H>M#E0!!@@@%FQ8&MCH>U8I/[6=/[1HJ#8:L[S(0@@@@@@@@
K2<RD!!HRD!!HRD!!HJ#(1-N2<@@@@@@@@@B (JB (JB (JB (9');
                colorMapFromArray:#[ 0 0 0 32 223 32 40 255 124 50 255 112 51 255 109 54 229 139 62 255 87 62 255 88 62 255 91 62 255 136 64 64 64 73 255 115 83 255 62 91 255 73 94 255 74 101 255 84 105 255 85 112 255 96 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 170 170 170 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 176 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 183 183 183 190 190 190 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 196 196 196 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 217 217 217 223 32 32 223 128 63 223 192 255 223 223 32 223 223 224 223 255 255 224 224 224 224 224 239 224 239 240 224 255 255 231 207 255 231 208 255 238 191 255 238 192 255 239 159 232 239 191 255 239 223 255 239 224 255 239 239 224 239 239 239 239 239 240 239 255 255 240 207 144 240 239 223 240 240 239 240 255 255 246 176 255 247 175 255 247 207 255 247 239 255 254 160 255 254 191 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'?? @?? @?? @?? @?? @?? @?? @@O8@@_>@@???A???C???C???C???C???C???C?? C???A???A???O???_O???@??>@??');
                            yourself);
                yourself
        ]
!

workspace24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self workspace24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#workspace24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class workspace24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
APTEAPTEAPTEAPTEAPTEAY6Z&6TEAPTEA XFA XFA XFA XFA XF$VN:^''6KA HEA TEAPTEAPTEAPTEAPTE/7F&)I=ZAPHEA TEAPTEAPTEAPTEAPVL*7R''
#U==APHBA TEAPTEAPTEAPTEAPV3\K!!"(U8EAPHBA TEAPTEAPTEAPTEAPU.]+6O\) EAPHBA TEAPTEAPTEAPTEAYQ)$JI&/ DEAPHBA TEAPTEAPTEAPTE
AX*([IJ<[0TEAPHBA TEAPTEAPTEAPTE+''V)%:6#APTEAPHBA TEAPTEAPTEAPTEZ9U ^Y:\APTEAPHBA TEAPTEAPTEAPU8!!9Z4XXHEAPTEAPHBA TEAPTE
APTEAPV2,XQ]^;$EAPTEAPHBA TEAPTEAPTEAXE([[V6VPTEAPTEAPHBA TEAPTEAPTEAZV@"HZN,@TEAPTEAPHBA TEAPTEAPTEAZA3YE.7+0TEAPTEAPHB
A W@0LC@0\C@0G1:Y6)>0LC@0L@EAPHBA W@0LC@0\C@0G=:.:3@0LCA0L@EAPHBA W@0LC@0\C@0HM\&\CA0LGA0\@EAPHBA W@0LGA0LC@0X%70LC@0LCA
0L@EAPHBA W@0\C@0\CA0IOA0LCA0LCA0L@EAPHBA W@0\C@0\CA0LCA0LCA0LCA0L@EAPHBA W@0LGA0LC@0\G@0LCA0LCA0L@EAPHBA W@0LC@0LC@0LC@
0LC@0LC@0L@EAPHBA HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB');
                colorMapFromArray:#[ 64 64 64 160 160 160 128 128 128 0 0 128 88 88 88 255 255 255 195 195 195 242 108 0 255 186 105 186 160 156 250 163 90 255 188 108 167 102 48 137 61 2 114 91 85 128 58 3 226 160 119 90 53 35 147 68 5 200 156 136 255 187 104 249 184 108 111 89 88 191 120 84 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 99 91 79 253 196 141 101 62 48 221 111 4 114 80 64 255 200 146 218 115 4 254 184 102 254 127 3 215 165 133 134 60 4 85 77 68 254 232 217 137 78 56 139 65 5 220 102 2 172 104 77 253 205 143 255 199 145 219 112 4 231 173 141 252 217 191 223 115 4 247 184 110 250 157 80 254 254 252 91 51 26 254 184 100 254 129 1 219 162 125 216 154 122 253 198 145 246 163 82 247 120 7 249 219 197 174 106 74 254 204 149 243 174 115 75 37 16 255 190 110 255 132 1 255 201 146 145 68 5 254 128 3 251 120 0 133 59 3 240 110 9 215 106 4 119 58 22 254 136 9 222 113 4 190 118 68 136 62 5 133 58 2 127 70 39 254 202 147 78 38 4 201 153 138 254 200 147 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 32 220 32 0 0 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@C0???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>???>');
                            yourself);
                yourself
        ]
!

workspace24x24Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self workspace24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#workspace24x24Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class workspace24x24Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
APTEAPTEAPTEAPTEAPTE@@@@@@@@APTE@@XFA XFA XFA XFA XFA XFA XFA HE@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHE@@XE0LC@0LG@0LC@0LC@0LC@
0LC@APHB@@XE0LC@0LG@0LC@0LC@0LC@0\C@APHB@@XE0LC@0LG@0LC@0LC@0\CA0\G@APHB@@XE0LCA0\C@0LGA0LC@0LC@0\C@APHB@@XE0LG@0LG@0\C@
0\C@0\C@0\C@APHB@@XE0LG@0LG@0\C@0\C@0\C@0\C@APHB@@XE0LCA0\C@0LGA0LC@0\C@0\C@APHB@@XE0LC@0LC@0LC@0LC@0LC@0LC@APHB@@XEAPTE
APTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB
@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTE
APTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XEAPTEAPTEAPTEAPTEAPTEAPTEAPHB@@XB@ HB@ HB@ HB
@ HB@ HB@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 64 64 64 160 160 160 128 128 128 0 0 128 88 88 88 255 255 255 195 195 195 242 108 0 255 186 105 186 160 156 250 163 90 255 188 108 167 102 48 137 61 2 114 91 85 128 58 3 226 160 119 90 53 35 147 68 5 200 156 136 255 187 104 249 184 108 111 89 88 191 120 84 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 99 91 79 253 196 141 101 62 48 221 111 4 114 80 64 255 200 146 218 115 4 254 184 102 254 127 3 215 165 133 134 60 4 85 77 68 254 232 217 137 78 56 139 65 5 220 102 2 172 104 77 253 205 143 255 199 145 219 112 4 231 173 141 252 217 191 223 115 4 247 184 110 250 157 80 254 254 252 91 51 26 254 184 100 254 129 1 219 162 125 216 154 122 253 198 145 246 163 82 247 120 7 249 219 197 174 106 74 254 204 149 243 174 115 75 37 16 255 190 110 255 132 1 255 201 146 145 68 5 254 128 3 251 120 0 133 59 3 240 110 9 215 106 4 119 58 22 254 136 9 222 113 4 190 118 68 136 62 5 133 58 2 127 70 39 254 202 147 78 38 4 201 153 138 254 200 147 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 32 220 32 0 0 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>@@@@');
                            yourself);
                yourself
        ]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-26x26'!

currentDirectoryIcon26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self currentDirectoryIcon26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#currentDirectoryIcon26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class currentDirectoryIcon26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV'';:O*54.K @@@IZV%)ZV%)ZV%)ZV%)ZV%)>&%ZTS2,9AM<<@@IZV%)ZV%)ZV%)ZV%)Z_BW TZV%)
C0?I,%[C@IZV%)ZV%)ZV%)ZV''0%8U:0VDWNI1C6OAQWA@IZV%)ZV%)ZV%)=(''&HC4H(Q_(VY^Z9,[BF6@IZV%)ZV%)Z_ZJU-F=@V);<-,[6T+;B0IP5L@IZV
%)ZV''6"%J=A/E(*?)4!!I&*>0,KB00G4,@IZV%)Y_#"@V"((Q/;=S2$HR,KB0,KB00IMP@IZV%*/O.B@O);=>T2^OX[B0,KB0,KB0NU"\@IZV%,\(BKGBL ?I
^W^0,KB0,KB0,KB0Y6:7%)ZVN72QAD7BRHM\,KB0,KB0,KB0,K@;3K^V%)X;$L <&HMQ]+B0,KB0,KB0,KB0,C,@@IZV%#.4FY5&V,1$,KB0,KB0,KB0,KB0
N0@@%)ZVN;P@)G*W$%:0,KB0,C,;,KB0,K@;@@BV%)X;-@@X,@D]4[B0,K@;N3.0,KB0,C,@@IZV%#.4@A"0/A(P,KB0,K@;,KB0,KB0N0@@%)ZVN4:[FKB<
C!!B0,KB0,KB0,KB0,K@;@@BV%)[@ $9 ,K0NDKB0,KB0,KB0,KB0,C,@@IZV% AK !!=C/@8P,KB0,KB0,KB0,KB0N0@@%)ZV% C@ #F[C!!B0,KB0,KB0,KB0
,K@;@@BV%)ZV@@CF (5CDKB0,KB0,@JHCC.;(# @@IZV%)ZV@@AE!!%WQ,KAU@#-1Z<C@1 @@@@@@%)ZV%)ZV% A$@(I1NFWF@@@@@@@@@@@@@@BV%)ZV%)ZV
% @@@@@@@@@@@@@@@@@@%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV% @a');
                colorMapFromArray:#[ 198 219 239 165 190 214 123 134 156 255 219 66 140 101 24 156 150 148 231 235 239 74 77 82 181 146 57 148 101 33 214 211 222 239 231 231 140 154 173 115 101 82 181 203 222 247 215 82 255 251 255 239 199 41 173 170 173 222 199 90 255 235 115 132 125 123 247 207 49 181 186 198 198 215 231 165 186 206 181 199 214 255 215 57 255 247 247 148 166 198 123 203 255 189 195 214 255 231 107 132 121 115 222 203 181 123 125 140 198 207 214 165 174 181 123 134 148 239 211 99 132 89 24 214 203 189 231 227 222 255 227 99 140 117 82 239 199 57 189 158 123 140 146 156 107 109 115 181 195 206 247 211 74 255 255 255 206 211 222 115 121 132 107 65 8 156 117 33 156 162 181 181 182 189 198 203 206 99 117 148 123 130 140 239 207 90 255 251 247 206 207 214 231 243 247 181 150 57 140 105 57 214 223 239 239 239 239 198 199 198 49 52 57 115 190 239 247 227 99 198 162 66 206 203 206 173 182 189 107 85 41 222 190 82 214 219 231 239 235 231 148 130 99 189 150 57 57 65 66 247 223 90 189 190 206 148 162 181 123 89 49 255 239 115 82 56 16 214 215 222 123 121 123 82 89 99 165 146 123 165 125 82 222 223 231 132 93 16 206 223 239 173 174 173 255 235 107 82 174 222 214 211 214 173 174 189 132 150 181 99 105 123 165 125 49 247 215 74 247 243 247 148 158 173 165 166 181 255 231 99 82 52 8 247 211 49 231 231 239 132 142 165 99 101 115 239 190 41 222 219 222 247 239 239 156 130 99 173 166 156 247 227 115 148 109 33 156 174 198 231 227 231 132 138 156 107 89 66 239 190 33 222 215 214 189 190 198 206 211 214 107 121 148 173 134 49 74 154 206 239 203 57 115 125 148 132 134 148 99 113 132 231 186 33 247 203 49 247 247 247 90 97 107 165 178 198 247 223 107 140 97 33 156 170 189 123 101 82 132 158 189 107 81 49 148 125 107 239 223 107 247 243 239 140 158 189 123 89 41 247 219 99 132 105 66 214 227 239 181 162 140 132 154 181 255 235 123 206 182 156 222 219 214 189 170 156 140 150 173 165 174 189 189 207 231 247 231 115 140 101 33 239 199 49 231 223 222 132 138 148 99 105 115 156 117 66 247 215 66 181 186 206 148 142 132 165 170 181 189 211 231 247 227 107 214 186 82 214 223 231 231 239 247 74 73 82 107 73 33 198 186 173 231 207 99 239 243 255 198 199 206 107 125 148 189 207 222 173 138 49 132 85 24 239 195 41 173 178 189 90 65 16 255 227 107 90 60 16 239 207 74 189 178 165 198 195 198 107 101 107 123 142 173 247 223 99 214 190 82 214 211 206 123 113 99 74 81 90 189 158 57 156 113 33 247 211 57 239 235 239 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@O0G<@C<C?0@?A??@O0??8C<_??@?O??8O7???C=???8?_???O3???;<???>?O??>O3???#<???8?O??>O3???#<???8?O??>O1???#<O??8?A??>O0O?
<C<A?@@?@@@@O0@@@C<b');
                            yourself);
                yourself
        ]
!

directoryBookmarks26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self home26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#home26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class directoryBookmarks26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV'';:O*54.K"H"%)ZV%)ZV%)ZV%)ZV%)ZV%)>&%ZTS2,9AM<<6(YZV%)ZV%)ZV%)ZV%)Z_BW TZV%)
C0?I,%[C1YZV%)ZV%)ZV%)ZV''0%8U:0VDWNI1C6OAQWAJYZV%)ZV%)ZV%)=(''&HC4H(Q_(VY^Z9,[BF6J)ZV%)ZV%)Z_ZJU-F=@V);<-,[6T+:<%IP5LJ)ZV
%)ZV''6"%J=A/E(*?)4!!I&*<W JN/0G4,]YZV%)Y_#"@V"((Q/;=S2$HR+P8XB&TW0IMP]YZV%*/O.B@O);=>T2^OXS&3!!D\>.%QTNU"\]YZV%,\(BKGBL ?I
^W^@Y@Y#G#8KV[($Y6:7%)ZVN72QAD7BRHM\.(EO"4B9O$>K]CP;3K^V%)X;$L <&HMQ]#(?QD=OS4=D"8.K\C/K*IZV%#.4FY5&V,1$O4>V"38P4VPPGC83
N6Q5%)ZVN;P@)G*W$%9;%)Y*LKUFQ#L>O#L;YGVV%)X;-@@X,@D]4WVV%&)R-P]RL1@PL3-$]YZV%#.4@A"0/A(P%)Y*Z+VL#KT3DA@3N6Q5%)ZVN4:[FKB<
C!!BV%&)*3S@03SLPDCL;YGVV%)[@ $9 ,K0NDIZV"6)[MSU[L1@PL3-$]YZV%''UK !!=C/@8P%)ZKDH0#*X03DA@3N6Q5%)ZV%*#@ #F[C!!BVZ(,P\(\/\#L3
\E$;YGVV%)ZV]Z#F (5CDH,\DCN*I JHCC.;(#!!$]YZV%)ZV]R)E!!%WQMA]U@#-1Z<C@1$+K27=5%)ZV%)ZV% -$@(I1NFWFR,/KYG> *B(KS9ZV%)ZV%)ZV
%$>(_6Q?(J *B4=5]WVV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV% @a');
                colorMapFromArray:#[ 198 219 239 165 190 214 123 134 156 255 219 66 140 101 24 156 150 148 231 235 239 74 77 82 181 146 57 148 101 33 214 211 222 239 231 231 140 154 173 115 101 82 181 203 222 247 215 82 255 251 255 239 199 41 173 170 173 222 199 90 255 235 115 132 125 123 247 207 49 181 186 198 198 215 231 165 186 206 181 199 214 255 215 57 255 247 247 148 166 198 123 203 255 189 195 214 255 231 107 132 121 115 222 203 181 123 125 140 198 207 214 165 174 181 123 134 148 239 211 99 132 89 24 214 203 189 231 227 222 255 227 99 140 117 82 239 199 57 189 158 123 140 146 156 107 109 115 181 195 206 247 211 74 255 255 255 206 211 222 115 121 132 107 65 8 156 117 33 156 162 181 181 182 189 198 203 206 99 117 148 123 130 140 239 207 90 255 251 247 206 207 214 231 243 247 181 150 57 140 105 57 214 223 239 239 239 239 198 199 198 49 52 57 115 190 239 247 227 99 198 162 66 206 203 206 173 182 189 107 85 41 222 190 82 214 219 231 239 235 231 148 130 99 189 150 57 57 65 66 247 223 90 189 190 206 148 162 181 123 89 49 255 239 115 82 56 16 214 215 222 123 121 123 82 89 99 165 146 123 165 125 82 222 223 231 132 93 16 206 223 239 173 174 173 255 235 107 82 174 222 214 211 214 173 174 189 132 150 181 99 105 123 165 125 49 247 215 74 247 243 247 148 158 173 165 166 181 255 231 99 82 52 8 247 211 49 231 231 239 132 142 165 99 101 115 239 190 41 222 219 222 247 239 239 156 130 99 173 166 156 247 227 115 148 109 33 156 174 198 231 227 231 132 138 156 107 89 66 239 190 33 222 215 214 189 190 198 206 211 214 107 121 148 173 134 49 74 154 206 239 203 57 115 125 148 132 134 148 99 113 132 231 186 33 247 203 49 247 247 247 90 97 107 165 178 198 247 223 107 140 97 33 156 170 189 123 101 82 132 158 189 107 81 49 148 125 107 239 223 107 247 243 239 140 158 189 123 89 41 247 219 99 132 105 66 214 227 239 181 162 140 132 154 181 255 235 123 206 182 156 222 219 214 189 170 156 140 150 173 165 174 189 189 207 231 247 231 115 140 101 33 239 199 49 231 223 222 132 138 148 99 105 115 156 117 66 247 215 66 181 186 206 148 142 132 165 170 181 189 211 231 247 227 107 214 186 82 214 223 231 231 239 247 74 73 82 107 73 33 198 186 173 231 207 99 239 243 255 198 199 206 107 125 148 189 207 222 173 138 49 132 85 24 239 195 41 173 178 189 90 65 16 255 227 107 90 60 16 239 207 74 189 178 165 198 195 198 107 101 107 123 142 173 247 223 99 214 190 82 214 211 206 123 113 99 74 81 90 189 158 57 156 113 33 247 211 57 239 235 239 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@O0G?@C<C?<@?A?? O0??<C<_?? ?O??<O7???#=???<?_???/3???;<???>?O???/3???;<???>?O???/3???;<???>?O???/3???;<_??>?G???/0??
?;<C??<?@_?0O0@@@C<b');
                            yourself);
                yourself
        ]
!

home26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self home26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#home26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class home26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV'';:O*54.K @@%)ZV%)ZV%)ZV%)ZV%)ZV%)>&%ZTS2,9AM<<6@IZV%)ZV%)ZV%)ZV%)Z_BW TZV%)
C0?I,%[C@IZV%)ZV%)ZV%)ZV''0%8U:0VDWNI1C6OAQWA@IZV%)ZV%)ZV%)=(''&HC4H(Q_(VY^Z9,[BF6@IZV%)ZV%)Z_ZJU-F=@V);<-,[6T+:<%IP5L@IZV
%)ZV''6"%J=A/E(*?)4!!I&*<W JN/0G4,@IZV%)Y_#"@V"((Q/;=S2$HR+P8XB&TW0IMP@IZV%*/O.B@O);=>T2^OXS&3!!D\>.%QTNU"\@IZV%,\(BKGBL ?I
^W^@Y@Y#G#8KV[($Y6:7%)ZVN72QAD7BRHM\.(EO"4B9O$>K]CP;3K^V%)X;$L <&HMQ]#(?QD=OS4=D"8.K\C,@@IZV%#.4FY5&V,1$O4>V"38P4VPPGC83
N0@@%)ZVN;P@)G*W$%9;%)Y*LKUFQ#L>O#L;@@BV%)X;-@@X,@D]4WVV%&)R-P]RL1@PL3,@@IZV%#.4@A"0/A(P%)Y*Z+VL#KT3DA@3N0@@%)ZVN4:[FKB<
C!!BV%&)*3S@03SLPDCL;@@BV%)[@ $9 ,K0NDIZV"6)[MSU[L1@PL3,@@IZV% AK !!=C/@8P%)ZKDH0#*X03DA@3N0@@%)ZV% C@ #F[C!!BVZ(,P\(\/\#L3
\E$;@@BV%)ZV@@CF (5CDH,\DCN*I JHCC.;(# @@IZV%)ZV@@AE!!%WQMA]U@#-1Z<C@1 @@@@@@%)ZV%)ZV@@A$@(I1NFWF@@@@@@@@@@@@@@BV%)ZV%)ZV
% @@@@@@@@@@@@@@@@@@%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV% @a');
                colorMapFromArray:#[ 198 219 239 165 190 214 123 134 156 255 219 66 140 101 24 156 150 148 231 235 239 74 77 82 181 146 57 148 101 33 214 211 222 239 231 231 140 154 173 115 101 82 181 203 222 247 215 82 255 251 255 239 199 41 173 170 173 222 199 90 255 235 115 132 125 123 247 207 49 181 186 198 198 215 231 165 186 206 181 199 214 255 215 57 255 247 247 148 166 198 123 203 255 189 195 214 255 231 107 132 121 115 222 203 181 123 125 140 198 207 214 165 174 181 123 134 148 239 211 99 132 89 24 214 203 189 231 227 222 255 227 99 140 117 82 239 199 57 189 158 123 140 146 156 107 109 115 181 195 206 247 211 74 255 255 255 206 211 222 115 121 132 107 65 8 156 117 33 156 162 181 181 182 189 198 203 206 99 117 148 123 130 140 239 207 90 255 251 247 206 207 214 231 243 247 181 150 57 140 105 57 214 223 239 239 239 239 198 199 198 49 52 57 115 190 239 247 227 99 198 162 66 206 203 206 173 182 189 107 85 41 222 190 82 214 219 231 239 235 231 148 130 99 189 150 57 57 65 66 247 223 90 189 190 206 148 162 181 123 89 49 255 239 115 82 56 16 214 215 222 123 121 123 82 89 99 165 146 123 165 125 82 222 223 231 132 93 16 206 223 239 173 174 173 255 235 107 82 174 222 214 211 214 173 174 189 132 150 181 99 105 123 165 125 49 247 215 74 247 243 247 148 158 173 165 166 181 255 231 99 82 52 8 247 211 49 231 231 239 132 142 165 99 101 115 239 190 41 222 219 222 247 239 239 156 130 99 173 166 156 247 227 115 148 109 33 156 174 198 231 227 231 132 138 156 107 89 66 239 190 33 222 215 214 189 190 198 206 211 214 107 121 148 173 134 49 74 154 206 239 203 57 115 125 148 132 134 148 99 113 132 231 186 33 247 203 49 247 247 247 90 97 107 165 178 198 247 223 107 140 97 33 156 170 189 123 101 82 132 158 189 107 81 49 148 125 107 239 223 107 247 243 239 140 158 189 123 89 41 247 219 99 132 105 66 214 227 239 181 162 140 132 154 181 255 235 123 206 182 156 222 219 214 189 170 156 140 150 173 165 174 189 189 207 231 247 231 115 140 101 33 239 199 49 231 223 222 132 138 148 99 105 115 156 117 66 247 215 66 181 186 206 148 142 132 165 170 181 189 211 231 247 227 107 214 186 82 214 223 231 231 239 247 74 73 82 107 73 33 198 186 173 231 207 99 239 243 255 198 199 206 107 125 148 189 207 222 173 138 49 132 85 24 239 195 41 173 178 189 90 65 16 255 227 107 90 60 16 239 207 74 189 178 165 198 195 198 107 101 107 123 142 173 247 223 99 214 190 82 214 211 206 123 113 99 74 81 90 189 158 57 156 113 33 247 211 57 239 235 239 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@O0G<@C<C?8@?A??@O0??8C<_??@?O??8O7???C=???8?_???O3???;<???>?O??>O3???#<???8?O??>O3???#<???8?O??>O1???#<O??8?A??>O0O?
<C<A?@@?@@@@O0@@@C<b');
                            yourself);
                yourself
        ]
!

make26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self make26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#make26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class make26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRHSM@M!!HRD!!HRD!!HRD!!HRD!!HRD!!HRM1 6D"0YFQ$JA!!@RD!!HRD!!HRD!!HRD!!HRD$@HFR<B
BQ$YQCH''P0AMD!!HRD!!HRD!!HRD!!HRP1,[BCH[F1,2L$PYFTLED!!HRD!!HRD!!HRD!!HJF0 (JCIDN3H2N1,HQCH+D!!HRD!!HRD"P6@$P[BB 2L#H2L#,;N3-DN30R
D!!HRD!!I@QDMDB@!!DL#H2L#,;N3,;QDP^OQHRD!!HRIC-DBDQDQCH2L$T%I"$UN4QDQC@)D!!HRD!!HSLDQDJCH2L#H9CCXRD$,OQDQDB@ !!GAHRD!!IAN3H2L#H2
IRHRD!!HRKT\0B@ HBDUJD!!HRD X;N3H2L#(=D!!HRD!!IKQ1<HB@ HLT(RD!!A@I3,;N3H;GSXRD!!HRID]GI0 HP1PVM!!HRH3H2L#H;N3,LD!!HRD!!HM@4!!CB@ K
R!!HRD!!H!!L#H2N3,;P4(RD!!HRO D4MA,[BAPRD!!HRD$@(L#,;N3-DOQHRD")CLB\HF1,[BB$RD!!HRD$DCL#,;QDQNHA\ZBP%CBA,[F1$HC!!HRD!!HRD PQDSID
QDP[F1,HB@ [F0 0BTXGD!!HRD!!H7EQ<_L$QDB@ HBA,[F1,HB01LOQHRD!!HRD"POEQ=DQ@ HB@ [F1,[F4LVD!!HRD!!HRD!!HRD$%HI0!!DI3,HF1,HBA$YBT0R
D!!HRD!!HRD!!HRD$5BO0<OMQ,[P0-KB@%FOQHRD!!HRD!!HRD!!HRD!!H8J4,5FQ-FR#X)C"HRD!!HRD!!HRD!!HRD!!HRD!!HRM"8^G!!XRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HR
D!!HRD#YMGAHRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD @a');
                colorMapFromArray:#[ 192 159 96 223 159 63 192 159 128 223 127 64 192 128 96 192 159 159 192 160 159 191 191 191 255 223 63 224 192 63 224 160 64 159 127 96 160 160 160 223 159 96 159 128 128 223 96 64 224 223 192 255 128 63 224 224 223 223 191 191 160 127 96 224 127 63 160 160 159 255 224 128 223 160 128 255 255 63 224 223 64 255 224 63 224 223 223 160 159 127 191 127 95 224 128 63 192 192 160 223 128 95 192 191 191 223 128 96 223 192 191 160 159 96 160 160 128 224 159 63 255 159 63 191 159 128 223 192 128 191 160 159 223 159 128 223 127 96 191 128 128 224 191 64 224 160 63 192 128 64 255 160 63 223 159 95 223 128 63 223 127 63 223 223 192 223 191 160 192 192 192 160 159 95 223 160 64 255 191 63 159 128 127 191 191 160 223 191 128 223 128 64 223 159 127 191 159 159 191 128 127 224 191 63 255 192 63 223 159 64 160 127 95 192 95 64 192 96 64 192 191 160 192 192 191 192 96 95 191 160 160 223 192 192 192 191 96 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@O0@G C<@;>@?@_?8O0G??C<A??8?C??>O1???#<???8?O?3?/1?0?;<_8O>?_>G?/7?A?#=?0?0?_<_>O3???#<_??8?O??<O3??8C<_?>@?C?? O0O?
0C<@>@@?@C @O0@@@C<b');
                            yourself);
                yourself
        ]
!

menu26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menu26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#menu26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class menu26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@EK"8.K"8.K"8.K"8.K"8.K"8T@@@@@@@@@@TOC0<OC0<OC0<OC0<OC0<OC1P@@@@@@@@@AP<OC0<OC0<OC0<OC0<OC0<OE@@@
@@@@@@@EC0<OC0<OC0<OC0<OC0<OC0<T@@@@@@@@@A,[F1,[F1,[F1,[F1,[F1,[F1P@@@@@@@@@@0LC@0LC@0LC@0LC@0LC@0LCE@@@@@@@@@@LD1LSD1LS
D1LSD1LSD1LSD1LT@@@@@@@@@@0SD1LSD1LSD1LSD1LSD1LSD1P@@@@@@@@@CALSD1LSD1LSD1LSD1LSD1LSE@@@@@@@@@@,KB0,KB0,KB0,KB0,KB0,KB0T
@@@@@@@@@@T.K"8.K"8.K"8.K"8.K"8.K!!P@@@@@@@@@AP<OC0<OC0<OC0<OC0<OC8 OE@@@@@@@@@@EC0<OC0<OC0<OC0<OC0<OC0<T@@@@@@@@@@TOC0<O
C0<OC0<OC0<OC0<OC1P@@@@@@@@@F1,[F1,[F1,[F1,[F1,[IAPTE@@@@@@@@@@EK"8.K"8.K"8.K"8.K"8.K"8T@@@@@@@@@@TKC0<OC0<OC0<OC0<OC0<O
C1P@@@@@@@@@AR$OC0<OC0<OC0<OC0<OC0<OE@@@@@@@@@@JG!!\OC0<OC0<OC0<OC0<OC0<T@@@@@@@@@@8AA2(!!FA<IGRL"@!!X E!!@TIAP@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 106 103 105 108 108 111 21 232 231 3 189 187 226 226 228 104 104 105 109 109 108 21 231 231 82 82 83 213 213 214 187 187 187 133 233 234 21 231 230 90 90 92 186 186 188 108 108 108 135 225 226 138 243 244 2 186 188 85 85 88 133 225 227 107 107 109 182 182 181 107 107 108 19 230 230 0 129 126 102 102 103 0 128 126 85 85 84 180 180 182 101 101 104 105 105 109 111 111 110 84 84 85 88 88 90 96 96 99 0 125 126 2 191 189 0 138 139 97 94 99 193 193 192 110 110 109 19 234 233 5 141 143 95 95 99 254 254 252 2 190 188 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A??
?@@_??0@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

newMenu26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newMenu26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#newMenu26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class newMenu26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@J@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B (Z@@@@@@@@@@@@@@@@@@@@@@@@@@@JB @JB"(@B (@@@@@@@@@@@@@@@@@@@
@@B (:R )JV$(JR#(@@@@@@EK"8.K"8.K"8.K": )*^(*Z"'')*@@@@@@@@TOC0<OC0<OC0<OC96 )J&Y*ZR @@@@@@@@AP<OC0<OC0<OC0<OC:B$*Y&))J@@
@@@@@@@EC0<OC0<OC0<OC0> )*^(*Z"'')*@@@@@@@A,[F1,[F1,[F1,[(JN$(JR%)JB$(:@@@@@@@0LC@0LC@0LC@0LC(J@C(JJ EJB @@@@@@@LD1LSD1LS
D1LSD1LSD1N (Z@T@@@@@@@@@@0SD1LSD1LSD1LSD1LSD1N D1P@@@@@@@@@CALSD1LSD1LSD1LSD1LSD1LSE@@@@@@@@@@,KB0,KB0,KB0,KB0,KB0,KB0T
@@@@@@@@@@T.K"8.K"8.K"8.K"8.K"8.K!!P@@@@@@@@@AP<OC0<OC0<OC0<OC0<OC8 OE@@@@@@@@@@EC0<OC0<OC0<OC0<OC0<OC0<T@@@@@@@@@@TOC0<O
C0<OC0<OC0<OC0<OC1P@@@@@@@@@F1,[F1,[F1,[F1,[F1,[IAPTE@@@@@@@@@@EK"8.K"8.K"8.K"8.K"8.K"8T@@@@@@@@@@TKC0<OC0<OC0<OC0<OC0<O
C1P@@@@@@@@@AR$OC0<OC0<OC0<OC0<OC0<OE@@@@@@@@@@JG!!\OC0<OC0<OC0<OC0<OC0<T@@@@@@@@@@8AA2(!!FA<IGRL"@!!X E!!@TIAP@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 106 103 105 108 108 111 21 232 231 3 189 187 226 226 228 104 104 105 109 109 108 21 231 231 82 82 83 213 213 214 187 187 187 133 233 234 21 231 230 90 90 92 186 186 188 108 108 108 135 225 226 138 243 244 2 186 188 85 85 88 133 225 227 107 107 109 182 182 181 107 107 108 19 230 230 0 129 126 102 102 103 0 128 126 85 85 84 180 180 182 101 101 104 105 105 109 111 111 110 84 84 85 88 88 90 96 96 99 0 125 126 2 191 189 0 138 139 97 94 99 193 193 192 110 110 109 19 234 233 5 141 143 95 95 99 254 254 252 2 190 188 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 255 248 248 207 216 240 240 240 248 239 232 240 240 240 240 48 88 176 224 224 232 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@P@@@@N@@@@[,@@@O? A???0@_??8@G??>@A???0@_??>@G???@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A??
?@@_??0@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

printer26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self printer26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#printer26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class printer26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CTTPA$PDA@PDA@PDA@WP@@@@@@@@@@@@@@@MQQT[-M 8NC 8NC 057%P@@@@@@@@@@@@@@5EEQ@M$A@PDA@PDA
]DCX@@@@@@@@@@@@@@CTTUD@\QLC@0LC@0LCT%<@@@@@@@@@@@@@@MQQTP@@H&=/[6=/[6>BP@@@@@@@@@@@@@@@R[0@@@BR)ZV%)ZV%)ZU@B @@@@@@@@@@
@@AI/@@@@LP$S4=OS4=OS1I_@@@@@@@@@@@@@D&</@@@@KR9.[&9.[&94S<@@@@@@@@@@@@@R[2<@@@@U(FA W@73MB,RE @@@@@@@@@@@AI/K0@@D][][@9
T1>WY\CIDZLG- @@@@@@@D&</@@@Q<+J,WY<_CR2_Y%8O[(-" @@@@@@R[0@@)G@G3%&,*<:+Y<XQS4^2 2DPP@@@@@@@I(.%A\+F#LTN*6_FDT2BA6W_@B:
'' @@@@CK)7H.%A]L+6V-''3H1571<0C%+SC%;@@@@@G(=)7H.%A]2_RU<_AXZ+:>"''\A<I2<@@@@@*,/ZBGH.%A\#JQ8=BKH@&HXN$<U,O@@@@@@\EA+ZHX8.
%E@W.E$''QC/C28,V%#UF@@@@@KFOEI<H32F5''J%NNC ;*B5<E#M<G4X@@@@@@KNOEI<=B@,ENC-Y&HP-_H5*BVJ=Q @@@@A._D-CEI<=)3$''V)"DVPPO-7M:
!!DPUM @@@@CNWFT#EI<=%E*X^*ATXK]3^(R]_\A?@@@@@@@@18 WZI==&HP*U6B7\6+M%LF+K@@@@@@@@@@@@HB8K''JDKSCB)G$.''LE''D@@@@@@@@@@@@@@@
@@A^[HU#P!!%>UQ/S/0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 184 184 184 238 247 255 210 209 203 225 240 255 139 139 139 146 146 146 239 237 218 199 198 192 218 218 218 101 101 101 185 184 198 178 178 178 211 211 211 234 236 243 152 152 152 113 113 113 228 226 211 165 165 185 165 178 212 187 197 223 245 245 245 186 185 180 189 189 189 205 205 205 238 238 238 215 213 196 206 206 206 171 170 163 166 166 166 200 200 200 231 231 231 195 195 195 222 219 205 155 155 155 146 152 191 232 232 232 176 206 242 180 180 180 206 204 202 167 167 167 224 221 212 227 227 227 142 142 154 222 222 222 218 216 202 182 182 182 216 216 216 178 176 168 149 149 158 207 207 207 233 233 233 194 194 194 193 193 193 151 189 132 204 202 188 191 224 255 129 129 129 209 209 209 243 243 243 143 143 143 184 182 173 234 234 234 237 234 217 151 151 186 150 150 185 200 198 191 204 202 186 249 249 249 156 156 156 236 236 236 189 187 178 170 170 170 168 168 196 238 235 218 237 234 216 221 221 221 220 220 220 215 216 230 142 142 142 187 221 255 210 210 210 240 237 220 173 177 206 197 197 197 68 68 68 172 172 180 132 151 198 78 78 85 189 188 191 165 165 165 169 169 169 245 248 251 183 183 181 205 204 205 185 184 181 154 154 188 95 95 95 238 235 217 90 90 90 167 165 157 146 145 175 192 192 192 196 196 196 191 190 185 237 237 237 240 237 218 154 154 154 224 224 224 149 149 149 238 235 216 206 204 190 217 236 255 181 218 255 188 187 195 223 223 223 133 133 133 233 242 251 228 240 253 181 181 181 154 154 187 230 230 232 172 172 175 144 144 144 194 192 184 185 185 185 219 219 219 161 159 171 191 190 183 179 178 173 170 213 255 204 219 241 251 253 255 176 176 176 145 145 144 171 171 171 221 219 205 185 185 184 223 220 205 196 194 188 160 160 160 237 235 219 174 174 174 208 208 208 251 251 251 238 234 216 172 172 172 159 160 187 132 132 132 212 212 212 219 217 211 143 182 125 187 187 187 175 175 175 228 228 230 208 208 207 238 236 219 199 199 199 198 198 198 221 219 204 239 239 239 76 76 76 223 221 205 214 214 214 175 175 174 131 131 163 204 229 255 238 236 218 226 226 226 163 163 163 159 159 159 154 155 154 188 187 184 215 225 236 241 241 241 237 235 217 228 228 228 204 217 230 177 177 177 203 203 203 253 253 253 151 174 217 186 186 186 212 210 199 103 103 103 188 188 188 179 217 255 202 202 202 197 196 199 239 236 219 204 204 204 238 236 217 230 227 211 190 190 190 186 186 185 134 134 175 130 130 130 180 178 190 125 125 125 237 235 216 201 199 190 239 236 218 169 169 186 230 230 230 137 137 137 213 234 255 213 213 213 212 210 197 157 157 157 211 228 243 175 208 246 237 235 215 197 196 190 239 238 220 239 237 219 230 228 215 191 191 191 178 177 194 154 154 183 151 151 151 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@O1?<@C<_? @?C?8@O0?>@C<G? @?A?<@O0_?@C<C?0@?@?>@O0_?<C<G?? ?G??<O3???#=???8?_??>O7???#=???8?_??>O7???#=???<?O???O0??
?#<C?? ?@O? O0@@@C<b');
                            yourself);
                yourself
        ]
!

search26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self search26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#search26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class search26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB 6A3%GC0DQZ1((JB (JB (JB (JB (JB (B!!=JWC<2TD8<N1 (JB (JB (JB (JB (J@(.
P6IDP"H2Z YYC1 (JB (JB (JB (JB!!.LBY"X%DFID@$H#I]NQ((JB (JB (JB (J@LUQFHLTAPTEAPTL#H]KR (JB (JB (JB 6Y444TSD$A"H2Z&(2Z$8+
XB (JB (JB (JF80L#HFE@Y*Z"L#H2M*A!!1.JB (JB (JB ([#A*ED@ L&(#MCP4MBL#YV8(JB (JB (JB!!.LCHFD!!PDH3QDQDP5MDI%[" (JB (JB (JF8V
ZCH$A&(#MTPLCDP4BD].JB (JB (JB (F&1ZL"@FZ#P5QFI"X#UKU1((JB (JB (JB (B#5NP"HDH3UDCFI"I4$XJB (JB (JB (JA%.RC5(Z&(#MCP5CG@/
W" (JB (JB (JB!!ON"D7NC4SPV(4H0 3K0TZJB (JB (JB (ZUQUQ$T%E0D,G!!A[K0$WB2 (JB (JB (JF$*UP4)@&@(XF4W[6DXXB (JB (JB (JB!!)J%TM
C&Y_@B (JB (JB (JB (JB (JB (ZVMUCP9XBP@(JB (JB (JB (JB (JB (JF%#UP4NY%H@JB (JB (JB (JB (JB (JB!!LX5TMC&YR@B (JB (JB (JB (
JB (JB (J@AUCP9&T @(JB (JB (JB (JB (JB (JB (YELNY%H@JB (JB (JB (JB (JB (JB (JB >U!!,I@B (JB (JB (JB (JB (JB (JB (F!!(ZF!!(Z
F!!(ZF!!(ZF!!(ZF ,KF!!(KB0,KB0,ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZB0,ZF ,KB0,KB0@a');
                colorMapFromArray:#[ 191 175 143 144 159 192 160 144 159 176 191 208 192 255 255 175 175 192 191 239 255 176 176 207 207 239 240 175 175 207 207 207 223 239 239 224 240 255 255 223 128 63 175 111 95 128 143 191 144 160 192 159 159 192 160 223 255 160 192 224 176 224 255 175 191 223 159 160 208 192 192 208 208 208 223 240 239 223 239 239 239 143 127 128 128 143 176 143 175 208 143 159 192 143 143 191 176 239 255 207 207 191 191 240 255 208 255 255 175 223 255 207 207 207 207 223 239 224 239 240 240 240 239 175 111 80 255 191 95 127 127 175 128 144 191 160 160 191 159 160 192 160 175 207 159 160 207 176 223 255 192 240 255 191 207 224 223 255 255 224 255 255 224 224 239 144 159 160 128 143 175 128 128 175 240 207 144 144 144 191 144 160 208 143 159 207 207 207 192 192 239 255 160 208 255 191 224 240 207 240 255 208 224 239 239 255 255 144 143 143 207 143 95 127 128 175 144 159 191 143 144 191 144 160 207 176 208 224 255 208 144 191 223 239 175 208 240 255 208 159 191 224 255 207 239 255 175 160 207 143 112 96 255 191 80 255 175 79 160 159 159 143 143 176 159 128 144 144 191 239 160 191 224 160 176 208 176 208 239 159 192 239 175 160 192 176 175 207 224 224 224 208 208 224 255 255 255 255 192 95 175 175 160 143 159 191 160 128 144 160 175 208 176 223 240 255 207 144 207 255 255 191 191 208 176 176 208 207 207 208 223 223 224 207 208 223 239 239 240 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@O0@O>C<@G?0?@C?>O0A??3<@_?<?@O??/0C??;<@??>?@O??/0C??;<@??>?@G??O0C??#<A??8?@??<O0_7<C<O8@@?G<@@O3>@@C=?@@@?_ @@O70@
@C=8@@@?@@@@O0@@@C<b');
                            yourself);
                yourself
        ]
!

stxHome26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stxHome26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#stxHome26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class stxHome26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV'';:O*54.K @@@IZV%)ZV%)ZV%)ZV%)ZV%)>&%ZTS2,9AM<<@@IZV%)ZV%)ZV%)ZV%)Z_BW TZV%)
C0?I,%[C@IZV%)ZV%)ZV%)ZV''0%8U:0VDWNI1C6OAQWA@IZV%)ZV%)ZV%)=(''&HC4H(Q_(VY^Z9,[BF6@IZV%)ZV%)Z_ZJU-F=@V);<-,[6T+5-[IP5L@IZV
%)ZV''6"%J=A/E(*?)4!!I&*=[V5-[0G4,@IZV%)Y_#"@V"((Q/;=S2$HRV5-[V5-[0IMP@IZV%*/O.B@O);=>T2^OXU-[V5-[V5-[NU"\@IZV%,\(BKGBL ?I
^W][45-[V5-[45-[Y6:7%)ZVN72QAD7BRHM\V5/S4=M[V=OSV5,;3K^V%)X;$L <&HMQ]%-[V5/S45-[45-[V3,@@IZV%#.4FY5&V,1$V5-[V5/S4=OSV5-[
N0@@%)ZVN;P@)G*W$%9[V5-[V5/S4=M[V5,;@@BV%)X;-@@X,@D]4U-[V5-[4=OS45-[V3,@@IZV%#.4@A"0/A(PV5-[V5/SV;WSV5-[N0@@%)ZVN4:[FKB<
C!!A[V5-[4=M[3]OSV5,;@@BV%)[@ $9 ,K0NDE-[V=OSV5-[V=M[V3,@@IZV% AK !!=C/@8PV5-[4=M[V5-[4=M[N0@@%)ZV% C@ #F[C!!A[V5-[V5-[\%-[
V5,;@@BV%)ZV@@CF (5CDE-[V5.*I JHCC.;(# @@IZV%)ZV@@AE!!%WQV5-U@#-1Z<C@1 @@@@@@%)ZV%)ZV% A$@(I1NFWF@@@@@@@@@@@@@@BV%)ZV%)ZV
% @@@@@@@@@@@@@@@@@@%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV% @a');
                colorMapFromArray:#[ 198 219 239 165 190 214 123 134 156 255 219 66 140 101 24 156 150 148 231 235 239 74 77 82 181 146 57 148 101 33 214 211 222 239 231 231 140 154 173 115 101 82 181 203 222 247 215 82 255 251 255 239 199 41 173 170 173 222 199 90 255 235 115 132 125 123 247 207 49 181 186 198 198 215 231 165 186 206 181 199 214 255 215 57 255 247 247 148 166 198 123 203 255 189 195 214 255 231 107 132 121 115 222 203 181 123 125 140 198 207 214 165 174 181 123 134 148 239 211 99 132 89 24 214 203 189 231 227 222 255 227 99 140 117 82 239 199 57 189 158 123 140 146 156 107 109 115 181 195 206 247 211 74 255 255 255 206 211 222 115 121 132 107 65 8 156 117 33 156 162 181 181 182 189 198 203 206 99 117 148 123 130 140 239 207 90 255 251 247 206 207 214 231 243 247 181 150 57 140 105 57 214 223 239 239 239 239 198 199 198 49 52 57 115 190 239 247 227 99 198 162 66 206 203 206 173 182 189 107 85 41 222 190 82 214 219 231 239 235 231 148 130 99 189 150 57 57 65 66 247 223 90 189 190 206 148 162 181 123 89 49 255 239 115 82 56 16 214 215 222 123 121 123 82 89 99 165 146 123 165 125 82 222 223 231 132 93 16 206 223 239 173 174 173 255 235 107 82 174 222 214 211 214 173 174 189 132 150 181 99 105 123 165 125 49 247 215 74 247 243 247 148 158 173 165 166 181 255 231 99 82 52 8 247 211 49 231 231 239 132 142 165 99 101 115 239 190 41 222 219 222 247 239 239 156 130 99 173 166 156 247 227 115 148 109 33 156 174 198 231 227 231 132 138 156 107 89 66 239 190 33 222 215 214 189 190 198 206 211 214 107 121 148 173 134 49 74 154 206 239 203 57 115 125 148 132 134 148 99 113 132 231 186 33 247 203 49 247 247 247 90 97 107 165 178 198 247 223 107 140 97 33 156 170 189 123 101 82 132 158 189 107 81 49 148 125 107 239 223 107 247 243 239 140 158 189 123 89 41 247 219 99 132 105 66 214 227 239 181 162 140 132 154 181 255 235 123 206 182 156 222 219 214 189 170 156 140 150 173 165 174 189 189 207 231 247 231 115 140 101 33 239 199 49 231 223 222 132 138 148 99 105 115 156 117 66 247 215 66 181 186 206 148 142 132 165 170 181 189 211 231 247 227 107 214 186 82 214 223 231 231 239 247 74 73 82 107 73 33 198 186 173 231 207 99 239 243 255 198 199 206 107 125 148 189 207 222 173 138 49 132 85 24 239 195 41 173 178 189 90 65 16 255 227 107 90 60 16 239 207 74 189 178 165 198 195 198 107 101 107 123 142 173 247 223 99 214 190 82 214 211 206 123 113 99 74 81 90 189 158 57 156 113 33 247 211 57 239 235 239 0 0 0 0 203 49 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@O0G<@C<C?0@?A??@O0??8C<_??@?O??8O7???C=???8?_???O3???;<???>?O??>O3???#<???8?O??>O3???#<???8?O??>O1???#<O??8?A??>O0O?
<C<A?@@?@@@@O0@@@C<b');
                            yourself);
                yourself
        ]
!

workspace26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self workspace26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#workspace26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class workspace26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@APTEAPTEAPTEAPTEAPTEAY6Z&6TEAPTEAP@FA XFA XFA XFA XFA ZQX;):_X,F@ TE@@XEAPTEAPTEAPTE
APTEA[=1)*R_V TBAPT@A TEAPTEAPTEAPTEAPVL*7R''#U==APHB@ @FAPTEAPTEAPTEAPTEA[M0.FJ!!W TE@ HB@@XEAPTEAPTEAPTEAPTE[''Z=#7JXAPTB
@ H@A TEAPTEAPTEAPTEAYQ)$JI&/ DEAPHB@ @FAPTEAPTEAPTEAPTE"*!!,$+1/APTE@ HB@@XEAPTEAPTEAPTEAZ95*Y^-(0TEAPTB@ H@A TEAPTEAPTE
APTEZ9U ^Y:\APTEAPHB@ @FAPTEAPTEAPTEAW"G%+Q!!  TEAPTE@ HB@@XEAPTEAPTEAPTE,+FDWW.9APTEAPTB@ H@A TEAPTEAPTEAXE([[V6VPTEAPTE
APHB@ @FAPTEAPTEAPTE)XBH!!(:0APTEAPTE@ HB@@XEAPTEAPTEAPV \6Q[-:<EAPTEAPTB@ H@A W@0LC@0\C@0G1:Y6)>0LC@0L@EAPHB@ @FA\C@0LCA
0LC@_7*;+LC@0LG@0@TE@ HB@@XE0LC@0LG@0LBCWI''@0\CA0\G@APTB@ H@A W@0LGA0LC@0X%70LC@0LCA0L@EAPHB@ @FA\CA0LCA0LG@$<G@0LG@0LG@
0@TE@ HB@@XE0LG@0LG@0\C@0\C@0\C@0\C@APTB@ H@A W@0LGA0LC@0\G@0LCA0LCA0L@EAPHB@ @FA\C@0LC@0LC@0LC@0LC@0LC@0@TE@ HB@@XB@ HB
@ HB@ HB@ HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ @a');
                colorMapFromArray:#[ 64 64 64 160 160 160 128 128 128 0 0 128 88 88 88 255 255 255 195 195 195 242 108 0 255 186 105 186 160 156 250 163 90 255 188 108 167 102 48 137 61 2 114 91 85 128 58 3 226 160 119 90 53 35 147 68 5 200 156 136 255 187 104 249 184 108 111 89 88 191 120 84 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 99 91 79 253 196 141 101 62 48 221 111 4 114 80 64 255 200 146 218 115 4 254 184 102 254 127 3 215 165 133 134 60 4 85 77 68 254 232 217 137 78 56 139 65 5 220 102 2 172 104 77 253 205 143 255 199 145 219 112 4 231 173 141 252 217 191 223 115 4 247 184 110 250 157 80 254 254 252 91 51 26 254 184 100 254 129 1 219 162 125 216 154 122 253 198 145 246 163 82 247 120 7 249 219 197 174 106 74 254 204 149 243 174 115 75 37 16 255 190 110 255 132 1 255 201 146 145 68 5 254 128 3 251 120 0 133 59 3 240 110 9 215 106 4 119 58 22 254 136 9 222 113 4 190 118 68 136 62 5 133 58 2 127 70 39 254 202 147 78 38 4 201 153 138 254 200 147 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 32 220 32 0 0 0 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@^@A???<@_???@G???0A???<@_???@G???0A???<@_???@G???0A???<@_???@G???0A???<@_???@G???0A???<@_???@G???0A???<@_???@G??
?0A???<@_???@@@@@@@b');
                            yourself);
                yourself
        ]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-32x32'!

deleteFileConfirmation32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self deleteFileConfirmation32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#deleteFileConfirmation32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'XPToolbarIconLibrary class deleteFileConfirmation32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
A XFA XIBP$IBP$IA XFA XFA XFA XFA XFA XFA XFA XFA \EAPTEAPTIA XFA XFA XFA XFA XFA XFA XFA XIAPTEAPTEAPTIA XFA XFA XFA XF
A XFA XFA XFBPPEAPTEAPTEAPTIA XFA XFA XFA XFA XFA X@@@$C@0LC@0LC@0LC@0LIBP$IBP$IBP$IA XFA XFA @@BP\GA0\GA0\GA0\GA0\GA0\G
A0\GA0\KA XFA XF@@@IA0TEAPTEAPTEAPTEAPTBAPTBAPTBAPLFA XFA X@@@$GAPTEAPTA@PDA@PDA@PDA@PDA@PDB@0XFA XFA @@BP\EAPTEAPDGA0\G
A0\GA0\GA0\G@P,CA XFA XF@@@IA0TEAPTE@P\GA0\GA0\GA0\GA0\A@P,FA XFA X@@@$GAPTEAPTAA0\GA0\GA0\GA0\GA0DF@PXFA XFA @@BP\EAPTE
APDGA0\GA0\GA0\GA0\G@P\FB0XFA XF@@@IA0TEAPTE@P\GA0\GA0\GA0\GA0\AA0\AB0XFA X@@@$GAPTEAPTAA0\@@@@@@@@@A0\GA0DKB0,KB0XFA @@
BP\EAPTEAPDGA0\GA0\GA0\GA0\GA0\GA0XKA XF@@@IA0TEAPTE@P\G@@@@@@@@@@@@@@@@@@@GA ,FA X@@@$GAPTE@ TAA0\GA0\GA0\GA0\GA0\GA0\F
B0XFA @@BP\EAPTBAPDGA0\GA0\GA0\GA0\GA0\GA0XKA XF@@@IA0TEAPTE@P\G@@@@@@@@@@@@@@@@@@@GA ,FA X@@@$GAPXEAP(JB \GA0\GA0\GA0\G
A0\GA0\FB0XFA @@A \E@ (JB (JB (@@@@@@@@@@@@@@@@@A0XKA XF@@@IA TJB (JA0(JB (G@P\GA0\GA0DGA \G@PDFA X@@@XGA (JB (GB (JB DF
A DA@PDFA0DA@PDGB@XFA @@BPXJB (JB \JB (JB DG@P\FA0\FA0DGA0DFA XF@@@FA (JB (JA0(JB (JA0XG@P\AA \AA0DFA0DFA XFA XFB (JB (G
B (JB (AA0DG@P\G@P\AA0XF@PXFA XFA XJB (JB (JB (JB \AA0DF@PDGA \A@P\FA XFA XFA @JB (JA0(JB (F@P\AA \FA XG@PXF@PDFA XFA XF
A (JB (GB (JB XG@PXAA DFA DFA DFA XFA XFA XFA (JB (JB (FA DFA XFA XAA \FA \AA XFA XFA XFA XJB (FA0XAA DFA DFA XF@PXF@PXF
A XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA @a');
                colorMapFromArray:#[ 0 0 255 134 134 134 255 204 153 204 204 102 255 251 240 255 255 153 236 233 216 255 255 255 0 0 0 153 153 0 255 0 0 4 4 4 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
A?@@@@_8@@@O?@@@G?8@@C???8@????@O???0C???<@????@O???0C???<@???? O???<C???? ????8O???>C???? ????8O???>C???? _???8O???>A??
?? /???0C???>@???? O???0A?71&@_=*R@C>PJX@N*P$@@@@@@b');
                            yourself);
                yourself
        ]
!

error32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self error32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#error32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'XPToolbarIconLibrary class error32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
\''I2\''I2\''I2\#D>O31JR#0EK$I2\''I2\''I2\''I2\ A2\''I2\''I2ZS8<STL&GV9UJ1\_R#)[\''I2\''I2\''I2@GI2\''I2\%ALD0)GJ%<N[&9#X2-QFD)&P''I2
\''I2\''H@\''I2\''HQSP@@B''E_Y@9.UVM#J5EVU#@5V7I2\''I2\ A2\''I2ARD9[P@J\U<NGV9UX2,+TUYVR@$,@7I2\''I2@GI2\!!D!!NS$@Q5@*W08][%U#J5EH
U%X%IQ<,ZGI2\''H@\''IPSS$9[P(\VFA$C&9.X6L+H!!QQRBTXBT0OA''I2\ A2ZT0A[P@JGF]%Z%H][%U#J2IZWDP6IQ IBU$''S''I2@GH>D0@@Q11''YQ$YZ$A.
X6L"R502QDQRBP$#G5]I\''H@\#0JB )PVFTYFS$9B6=#LD-\XVEDQDQSBRL_VS-N\ @1ST]1\R) Z!!$9NS$9TAUKWFE!!XSIDQP$IG1=LM0]2@C9CJ%=_W6QR
Z#$9NS$9JE0YXVE!!L"4IBRL_G41WG''H@O2Y_Y@8NC!!5@B3$9NS$YFQ%!!XVDZF@$IG1=LSB1+S @<GP8NGQ5.[&9/B3$9NQ$YFVE!!F!! IBRL_G41LK@1B@D).
[&9.[&9UX6LUJA$YFQ%!!XP,%BP$IG1=LSD0,CE4@R&9.UUUUX6M#LD-\FQ$YFVE!!S2HIBRL_G41LSB0LA @<X6M#X6M#J2IKWA$YFVE!!XVE!!S1T#G1=LSD0<
C01]@@TWX6L+J2,"R51!!XVE!!XVE!!XTQDPQT_SD1LSC10X$H@K!!<+J2-QH%)\XVE!!XVDKS6EDQDQDPT)LSD0<OEQFS ABR%EQTT TWCI!!XVE!!F"T"S4QDQC 8
PT1LOC05UA92@GH:FEYVU%EDQDP2L!!(XBP$UPTP8NC )O40<OG@3A7H@\%-JU%YVRCYDQDP-F@$IBRLUPS 8JPULOC1YUDYN\ A2\#40RBT%IUIDQP$IBP$#
G1=JK2$ESC0<HG@3K7I2@GI2P!!@IIQ XBULIBP$#G1<_SD1LO40<OC0BIA-N\''H@\''I2V20_BP$IBP$#G1<_G41LSD1LOC0<C1XHWWI2\ A2\''I2@21LBRL#
G1<_G41LSD1LOC0<H@HVX ]2\''I2@GI2\''I2S0=YG1<_G41LSD1LSC0<OE%0[@ G\''I2\''H@\''I2\''I2D"\BVT1LSD1LSC0<OCU0UCL[WWI2\''I2\ A2\''I2
\''I2S$$;M5\,KB0,C7ATE#MFK492\''I2\''I2@GI2\''I2\''I2\$8DG&,LW%8LX 4^AD92\''I2\''I2\''H@\''I2\''I2\''I2\''I2S$I]A%5BS''I2\''I2\''I2\''I2
\ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 224 223 255 224 224 127 32 31 191 159 128 160 160 160 191 96 96 192 191 191 191 160 160 95 95 64 223 95 95 255 223 192 223 160 160 95 63 63 95 95 95 255 160 159 127 32 32 128 63 63 192 127 96 192 191 160 223 159 128 191 32 32 191 63 63 64 31 31 224 96 96 224 95 95 224 255 255 223 191 191 96 96 96 160 127 96 255 159 159 128 127 127 192 95 64 160 64 63 192 128 128 192 64 63 192 95 95 64 32 32 224 96 95 224 159 159 128 95 64 223 159 159 191 223 255 255 191 191 255 127 127 128 32 32 223 160 191 192 159 128 160 159 159 192 64 64 223 191 160 192 255 255 64 63 63 224 224 223 128 63 32 224 127 127 96 32 32 191 224 255 255 255 255 160 95 64 127 64 64 160 64 64 160 95 95 192 128 127 191 95 95 223 127 96 160 128 159 223 192 191 223 128 128 192 224 255 192 160 191 96 95 95 255 192 192 255 96 95 160 159 128 160 63 63 160 32 32 191 64 64 192 96 96 223 223 192 191 159 159 223 160 159 255 127 96 223 127 127 223 96 96 95 31 31 255 128 128 255 96 96 127 31 31 159 96 96 159 63 63 191 32 31 192 160 159 192 159 159 192 192 191 95 63 32 255 191 160 223 128 127 223 255 255 95 64 64 255 128 127 255 160 160 223 224 255 159 95 95 160 127 127 191 160 159 224 223 192 192 160 160 96 95 64 64 32 31 255 255 224 255 159 128 223 96 95 96 31 31 255 192 191 0 0 0 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@C?0@@G??@@C??<@A??? @???<@_??? O???<G????!!????8_????O????3????<?????/????;????>?????/????;????>?????/????1????<_????C??
?? ????8G???<@???>@G???@@??? @G??0@@_?0@@@? @@@@@@@b');
                            yourself);
                yourself
        ]
!

fileBrowser32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileBrowser32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#fileBrowser32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class fileBrowser32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@KB0B@ PFR45PCP<QVE)\FQ-)@@@@@@@@@@@@@@@@@@@BQ"0,R@XHB%ARUQDSEU1^XA4_JP@@@@@@
@@@@@@@@@D]GA@P,KD0JC@9UU5$UFA) X&T!!H60@@@@@@@@@@@@@R@TERT$FKC@0LG\2^CL4^3Y=M788D2\(\& @@@@@@@AIA YJR \GLG\''I2\''I2\''I2\''
I3T%X8M6 0@@@@@@@@\GR4,HBD17L"]3\7M3@F56]''Y6"ELWX6=1^P@@@@@@B@!!LS@$ISW 3I3E3KR,@[VMO@F9.S4=OS4=OX0@@@@@IST4JB$9N^#P''K"=0
\0A-X0A._G1<_G1<_G1<[ @@@@)NS ,KTEA;M"\;BWQ3@F5#@B\''I2\''I2\''I2\''Z @@TE@LCEEQCSX7I1LSN0$@[VL@I7T3_S&BOX%B@PQK@@AQTP4MT%HN
M78''@@@SD3,IX0@'']3Q>QC2GPX5FAT,@@EHNC%QTC0<8_3&@ P@@D1L;BR\3_S%_IB)+I@QJR0@@U@<OUUTPDC&@I2\''I2\@@ALSI3Q>N#2GPX5FAT-K@@@P
DEYVDQEWN(D'']SM=NXH&@@@''_S&BOX%B@PQJBT,@@ADQU5\RD%"A "]7MG9DOH]A#R\''I2\''@@@@@@@@@@@@D%!!XD1MYVXH;I3M=NU<$J&,$AD)KI4L@@@@@
@@@@@@@SVU$TEE)Z!!C0''MG8:OH]A#TXER4,''Q@@@@@@@@@@@@E)ZEQU[V1ZEOR]=NXH="THAAD(IR2]E@@@@@@@@@@@@V5,VE%1\FHX>I2\''I2\''I2\''I2\''
I4X@@@@@@@@@@@A\FA!!]WQ$YO#>IPH)A"4JL#TPAQPIF@0@@@@@@@@@@@E4YFU9^F!!(?"R\''I2\''I2\''I2\''Z"\D@@@@@@@@@@@@F!!)_W1,[XDBJI7T3_S&B
OX%B@PQKI0T@@@@@@@@@@@@[F6A GA1!!PX,'']3Q>QC2GPX5FAT,''A @@@@@@@@@@@A1!!XQ4]X&IB#B\3_S%_IB)+I@QJR2\G@@@@@@@@@@@@GVI"G!!9$YH2M
I3Q>N#2GPX5FAT-KI4,@@@@@@@@@@@A$YA<_YVT #TP''_S&BOX%B@PQJBT,''S@@@@@@@@@@@@@@@HBA&Y"DAQR\''I2\''I2\''I2\''I2]M@@@@@@@@@@@@@@@@
@F\"H IF@4\DRD$FR ]KBD0IB$8@@@@@@@@@@@@@@@@@@@@#@4\DR@UIA ]KBD0ISP)NB0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 177 177 177 175 175 175 173 173 173 171 171 171 169 169 169 167 167 167 165 165 165 163 163 163 161 161 161 159 159 159 157 157 157 155 155 155 153 153 153 151 151 151 149 149 149 147 147 147 145 145 145 143 143 143 141 141 141 139 139 139 137 137 137 135 135 135 242 0 0 133 133 133 131 131 131 129 129 129 127 127 127 125 125 125 123 123 123 121 121 121 119 119 119 117 117 117 115 115 115 113 113 113 111 111 111 107 107 107 159 0 0 95 95 95 91 91 91 42 167 42 77 77 77 75 75 75 55 55 55 226 226 226 47 47 47 45 45 45 43 43 43 216 216 216 37 37 37 214 214 214 212 212 212 210 210 210 53 0 0 208 208 208 206 206 206 204 204 204 202 202 202 200 200 200 196 196 196 194 194 194 192 192 192 190 190 190 188 188 188 186 186 186 184 184 184 182 182 182 180 180 180 178 178 178 176 176 176 174 174 174 172 172 172 170 170 170 168 168 168 166 166 166 164 164 164 162 162 162 160 160 160 158 158 158 255 0 0 156 156 156 154 154 154 152 152 152 235 0 0 150 150 150 148 148 148 146 146 146 144 144 144 142 142 142 140 140 140 138 138 138 136 136 136 134 134 134 132 132 132 130 130 130 128 128 128 126 126 126 124 124 124 122 122 122 192 0 0 120 120 120 118 118 118 116 116 116 114 114 114 53 188 53 90 90 90 88 88 88 78 78 78 76 76 76 0 192 0 254 177 102 74 21 21 52 52 52 66 21 13 200 253 200 42 42 42 40 40 40 217 217 217 192 255 192 215 215 215 213 213 213 53 7 0 211 211 211 209 209 209 254 218 164 207 207 207 205 205 205 203 203 203 201 201 201 199 199 199 197 197 197 159 255 159 195 195 195 193 193 193 191 191 191 189 189 189 102 33 18 187 187 187 185 185 185 183 183 183 181 181 181 179 179 179 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@G??8@A??? @_??>@G???>A???? _???<G????!!????<_????''????9????>_????''????9????>_???@G???0A???<@_???@G???0A???<@_???@G??
?0A???<@_???@G???0A???<@G???@@_??0@A??<@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

help32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self help32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#help32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class help32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRTR)RT%IRT%IRTR$*C[&5ST5M=_E8>OBACRVU)T5Q. 4)J%IRT%IRT%IRB[UM-R$)SM"1HSFE!!W4UA@$9-R%QS
UGBT%IRT%IRT %QTR$)RFEJB-KV5-[N2+:=$TS\Z[$)*T8JT%IRT%D)*T4)JM%JS.[&2+:.'')*"(*J29 5H2T$)-[XNT%IRT %MJR#Y-.[&9.ZN '')2\''):
(+"V$6(6T4)* YRT%D)S[T(6[[&9.[&9&)^W%9^W&Y*\$9ZU$64YT%I-$9RT 65JM&69.[&9.YM3U3,\GA1YU8"S$9NS$5TX[V6T%IRBT65P.[&9.[&SZ $
I2(-J"LKN6>S%INS 5D6M(JT%F(7FHJ9.[&9$5H1J6N@ (JAY$($M(FC$9JS !! XT9RTT3\6.[&9%)MRESFB$9RT%IRT%FTFL(JS$)NBM#IR%IQRJW"1*9.W
VQH1 9RT%IRT%IRT%F$+G7V!!''X]2BSRT%FT)#Z:$&XX=K8BT%IRT%IRT%IRTR$8"V:V]&WHILIRT]2V0,Y>Y!!!!ANR)RT%IRT%IRT%IRT_4X )*J\!!!!1C%IQ6
I[B.''Y]Y@6VT%IRT%IRT%IRT%D*PQ02()Y2FN3:T%E(),J.]%3,QZT*T%IRT%IRT%IRT%IEGC*.&''XX9GYRTO"&-*96XN2])R)RT%IRT%IRT%IRT$D\A*:"]
!!#$^%IQ]DJ.+(I!!YO6UJ%IRT%IRT%IRT%IRCP :.*96FN"NT%G,O*J. &''H]K)MJ%IRT%IRT%IRTR&4KW::("WH:I9RTYQE *ZJ\"C,M_$)J%D)JR)QJR)RO
QRF+,*!!4V@(1%IQ)S6^V%YNS[Q X#9RT%IRT%D)J%F(ST[&8$(9(AC"T%EMTF(N9.YVD[AQKZ)BTR$)JR)A"ASZT.YQ1U!!,GT9RTUULYT)N9-)NET1$PSV%*
 W=OK"\6!!K&7#7ARESI*%IQ.T682 [&7%INC[S4 IB\*I2X&^+"9.YJB[SHYT''BT%IMSR%H6 )NS$9ND#GU\P$ED^Z:1.K&P (@6AV5T!!YRTR%Q-R!!(8 )NS
$9R")ZZ''**:.+*>S 690M1URR&*T%IRT &)JR#X6[YJR#92 (*V&)*R$"8E0 D<FT$)T\IRT%IQJZ&5JR#\YT(JB%9&G"X*J!!8]3Z5HVA&5JUF)J%IRT%IQJ
T69JR%HXFCYW\''JF!!(Y2U3(WA#MJR%QSR)RT%IRT%IQJT5I.R$)RM ,@BP$IB@$ICSU.R&5)UD*T%IRT%IRT%IRTR&9-T5MRTB=@OS0>JB=&T6).[T*T%IRT
%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%@@a');
                colorMapFromArray:#[ 128 32 32 128 95 32 128 96 96 128 127 95 128 128 127 128 128 128 128 128 159 128 159 159 159 32 31 159 32 32 159 32 63 159 63 32 159 64 63 159 64 64 159 95 63 159 96 63 159 96 64 159 96 95 159 127 96 159 127 127 159 128 128 159 128 159 159 128 160 159 159 128 159 159 159 159 159 160 159 160 160 159 191 160 160 32 32 160 63 32 160 63 63 160 64 32 160 64 63 160 95 32 160 95 63 160 95 64 160 95 95 160 96 63 160 96 64 160 96 95 160 96 96 160 127 64 160 127 96 160 127 127 160 128 95 160 128 96 160 128 127 160 128 128 160 159 127 160 159 159 160 159 160 160 159 191 160 160 128 160 160 159 160 160 160 160 160 191 160 191 191 191 31 31 191 31 32 191 32 32 191 63 32 191 63 63 191 64 63 191 64 64 191 95 95 191 96 63 191 96 64 191 96 95 191 127 63 191 127 64 191 127 95 191 127 96 191 128 64 191 128 127 191 128 128 191 128 159 191 159 64 191 159 127 191 159 159 191 160 159 191 160 160 191 160 191 191 191 191 191 191 192 191 192 192 191 192 223 191 223 223 192 31 32 192 31 63 192 32 32 192 64 63 192 64 64 192 96 64 192 96 96 192 127 96 192 128 64 192 128 96 192 159 64 192 159 159 192 159 160 192 160 64 192 160 160 192 160 191 192 191 159 192 191 160 192 191 191 192 191 192 192 192 160 192 192 191 192 192 192 192 192 223 192 223 192 192 223 223 192 224 224 223 31 31 223 31 32 223 63 31 223 95 64 223 96 95 223 128 128 223 159 32 223 159 63 223 159 64 223 159 159 223 160 128 223 191 160 223 191 191 223 191 192 223 192 192 223 192 223 223 223 223 223 223 224 223 224 223 223 224 224 224 31 31 224 32 31 224 32 32 224 63 31 224 63 32 224 95 32 224 95 64 224 191 63 224 192 223 224 223 223 224 223 224 224 223 255 224 224 223 224 224 224 224 224 255 224 255 224 224 255 255 255 31 31 255 31 32 255 32 31 255 32 32 255 63 31 255 63 32 255 64 32 255 64 63 255 95 32 255 95 63 255 96 32 255 96 63 255 96 64 255 127 63 255 127 64 255 128 64 255 159 63 255 159 64 255 159 95 255 160 63 255 160 64 255 160 95 255 191 63 255 191 64 255 191 95 255 192 63 255 192 64 255 192 95 255 192 96 255 223 64 255 223 95 255 224 224 255 224 255 255 255 224 255 255 255 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@O??<@OO?;0GO??.A''??=03???,M????&????1????>_????''?<C?9?<@_>_>@C?''?@@?9?0@O>_<@C?''?@@?9?0@O>_>@C?''? A?9?<@_>_?0_?''??
??9????>[????#_???P3???,F_??6@3??3@GO?; @_?? @@@@@@b');
                            yourself);
                yourself
        ]
!

imageEditor32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageEditor32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#imageEditor32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class imageEditor32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A#X0A#X6L@X6M#@FM#X0A#X6L@X6M#@FM#X6M#X6M#X6L@X0A#@FL@X0A#@FL@X0A#@FL@X0A#@FM#
X6M#X6M#@FM#X0A#X6L@X6M#@FM#X0A#X6L@X6M#@FM#X6M#X6M#@FM#X6M#X6M#X6M#X6M#X6M#X6M#X0A#X6M#X6M#X6M#@FMST5MST5MST5MST5MST5MS
T6L@X6M#X6M#X6M#X0A#X8UST5MST5MST5MST5MST5MSX6L@X6M#X6M#X6L@X6NE''8TUT%IRDW-6T&TUEQUREVU#X6L@X6M#X6M#X6L@!!XNC-\$"CP4AZF!!,
[@58H'']F^FM#@FM#X6M#X6M#X8V4%\R-.,%-ZF!!(ZF!!(@R,+J2,+X0A#X6M#X6M#X6M#@L:H%I:1)<$6M#X6M#Y;S0@WU!!\@X0A#@FM#X0A#X0A#X<:$2KJA
*L$PRT$PRT$@X0AJ@FL@X0A#@FL@X0A#X0A#X<;@''L^D%<%GQ4]G@FM#X0A#X6L@X6M#@FM#X0A#X0A#_L;J*[:M&<%!!K2<V@FM#X6M#X6M#X6M#X6L@X6L@
X6MBP,:K+IF=/<$GA59B@FM]WU5]WU5]WPU#@FM#@FM#X1QQT\: $,F]3\&/+0A#X79>_''8?SG9>M6M#@FM#@FM#W5<]W8+K&\JN4L$@X6M#]TU5^''):O4T-
X6M#@FM#@FLDA@PDAH*F1[^6.<$@X6M4]GQCP4MC@!!-#X0A#X0A#X7%9^W%9^[CC)XB.(,<@X6)*N2P$IBP;F6L@X6L@X6M#\7M3\7M@BK3F$H&+$<=#C1<L
LC@0FA=MX6L@X6L@X6L9ZS$9NU!!NS)"#.[N836L^\&\C@0M/G%Q#X6L@X6L@X3D1LSHJD!!HRD(?L)**L $QDQ@% [11DUFM#@FM#@FM#N" :B"@ BB8.VHJG
&*FVWE0ZWE,&I2\IX0A#X0A#X6MPHU@!!HU@!!TEAPHRD@X6L8NC 3L3L3NCU#X0A#X0A#X0,KB0,KB0,KB0,K@FM#X6Y&Y@X)JU]UD6M#X0A#X0A#[&8=[&9.
[&8>[&9.@FM#V%)ZV%)ZV%(*X6L@X6L@X6M#X6M#X6M#X6M#X6M#@FM=_W5=_W5=_T-#@FM#@FM#X0A#X6L@X6M#@FM#X0A#X6M#X6M#X6M#X6M#@FM#@FL@
X0A#@FL@X0A#@FL@X6M#@FM#X0A#X6L@X6M#@FM#@FM#X0A#X6L@X6M#@FL@X0A#@FL@X0A#@FL@X0A#X6M#X6M#X6M#X6M#X6M#X6L@X6M#@FM#X0A#X6L@
X6L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 204 182 197 175 191 155 231 236 210 180 93 134 80 116 78 243 246 205 237 221 229 243 212 225 168 189 45 234 181 203 230 120 163 206 217 175 116 58 97 238 191 210 119 149 33 231 217 226 122 70 106 246 226 234 199 215 22 167 85 127 112 56 96 233 210 221 127 63 104 222 229 200 239 222 230 165 188 18 104 136 54 150 174 23 174 90 130 135 162 28 120 150 33 248 227 235 224 117 159 115 57 98 187 97 139 225 231 212 242 223 232 237 241 207 165 187 17 218 113 156 232 239 159 210 224 18 121 60 100 225 203 215 82 118 61 245 216 228 234 219 227 228 234 211 211 109 152 210 109 151 240 244 206 232 166 192 185 203 26 229 217 225 69 107 61 181 200 12 203 105 147 218 114 155 144 168 98 207 170 190 236 123 166 235 123 165 178 193 171 196 101 143 142 72 113 159 81 123 221 228 213 149 174 23 71 109 49 116 57 97 232 218 227 208 144 174 231 218 226 134 68 108 218 231 11 64 102 55 128 156 45 245 225 233 181 144 167 224 117 160 167 86 127 112 55 96 111 55 95 149 173 39 195 213 8 127 64 104 228 236 143 239 202 217 240 223 231 207 223 3 237 241 208 165 187 18 69 106 66 233 215 224 174 89 130 234 239 208 234 219 228 135 67 108 255 255 255 219 229 107 112 56 95 195 212 7 156 178 68 227 215 224 203 105 148 103 135 39 243 224 233 186 157 177 172 135 160 235 123 166 225 232 195 223 181 200 193 135 164 135 162 27 195 101 143 85 121 44 71 109 50 136 89 121 116 57 98 115 57 97 188 97 139 218 226 214 210 190 203 150 77 118 216 230 0 61 100 53 165 120 149 242 108 0 255 186 105 186 160 156 250 163 90 255 188 108 167 102 48 137 61 2 114 91 85 128 58 3 226 160 119 90 53 35 147 68 5 200 156 136 255 187 104 249 184 108 111 89 88 191 120 84 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 99 91 79 253 196 141 101 62 48 221 111 4 114 80 64 255 200 146 218 115 4 254 184 102 254 127 3 215 165 133 134 60 4 85 77 68 254 232 217 137 78 56 139 65 5 220 102 2 172 104 77 253 205 143 255 199 145 219 112 4 231 173 141 252 217 191 223 115 4 247 184 110 250 157 80 254 254 252 91 51 26 254 184 100 254 129 1 219 162 125 216 154 122 253 198 145 246 163 82 247 120 7 249 219 197 174 106 74 254 204 149 243 174 115 75 37 16 255 190 110 255 132 1 255 201 146 145 68 5 254 128 3 251 120 0 133 59 3 240 110 9 215 106 4 119 58 22 254 136 9 222 113 4 190 118 68 136 62 5 133 58 2 127 70 39 254 202 147 78 38 4 201 153 138 254 200 147 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@BH"H A7]7\@???? G???0@???8@_???@O???8A???<@_??>@G???4S????._????3????9????<?????''????<????>_????O????9?????O????''??
??3????>_????3????9????<?????'']7??<"H.;.@@ADQ@@@@@@b');
                            yourself);
                yourself
        ]
!

imageEditor32x32Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageEditor32x32Icon3 inspect
     ImageEditor openOnClass:self andSelector:#imageEditor32x32Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class imageEditor32x32Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@D)GRAH@@@@@@@@@@@@@@@@@@@@@@C8PZB\*N@@@@@LC@0LC@0LC@0LC@0M-G%MQS@\@@@@C@0LC@0LC@0LC@0L9VRETN 0*@@@@
@0LC@ HB@ HB@ LCXQ5&C48K@@@@@@LC@ HB@ HB@ HB@1,#Z30_QP@@@@@C@ HB@ HD@ HD@$DVOT<S[@@@@@@@@0HB@ HB@ HB@ H7UQ$?Z!!0@@@@@@@LB
A@HB@ HB@ I\H%YDV5@C@@@@@@@C@ HB@ HBA@HDFDHMI$-I@0@@@@@@@0HB@ HD@ HBISQCX 8/@0L@@@@@@@LB@ HB@ HB@&A_LP((Y0LC@@@@@@@C@0HB
@ HB@"8UF&M$A#HC@0@@@@@@@0HD@ HB@ IRKST3N58C@0L@@@@@@@LB@ HB@PDASR@QBFU]@0LC@@@@@@@C@0HB@ HA@R$''EA\+@0LC@0@@@@@@@0LC@0LC
@PD,I6%Z@0LC@0L@@@@@@@LC@0LC@0DAL@%F@0LC@0LC@@@@@@@DA@PDA@PA@SX$A@PDA@LC@0@@@@@@A@PDA@PDA@Q@A@PDA@PDA@P@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 87 87 87 133 60 36 0 206 0 174 218 230 0 137 0 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@C3_??;_??;_??;_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3_??3@@@C');
                            yourself);
                yourself
        ]
!

menuEditor32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuEditor32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#menuEditor32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class menuEditor32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\''I2\''I2\''I2\''I2\''I2\#0@@@@@@@@@@@@@@@@@@@BPH"H"H"H"H"H"H)8"H"H"O@@@
@@@@@@@@@@@@@@@@@F4"H"H"H"H"H"H"H"H"H"H<@@@@@@@@@@@@@@@@@@@@D"H"H"H"H"H"H"H"H"H"H#0@@@@@@@@@@@@@@@@@@@BSU5]WU5]WU5]WU5]W
U5]WO@@@@@@@@@@@@@@@@@@@@L!!J@2A$YB@C@2A$YEIRT%H<@@@@@@@@@@@@@@CJ2 @@NIJR$)JR$)JR$)JR$)JR$#0@@@@@@@@@@@@@2$HO2 B*$)JR$)JR
$)JQZYJR$)JRO@@@@@@@@@@@@L(2BXSA2*E%$)JR$)JR$)JR$)JR$)H<@@@@@@@@@@CJ 2>1Z8;A-VN-+Z5FQ$Z-QDQDR4-KR30@@@@@@@@@@@CJD28?^U/A
H''I2\''I2\''I2\''I2\''I2O@@@@@@@@@@@@@CJU[1:AE7AH"H"H"H"H"H"H"H"H"H<@@@@@@@@@@@@@@CJ*C6;B#OAH"H"H"H"H"H"H"H"H#0@@@@@@@@@@@@@
@@CJ1FB_G3/AH"H"H"H"H"H"H"H"O@@@@@@@@@@@@@@@@@CJFF(+''JSA^7-;(E];(@0LC@0<@@@@@@@@@@@@@@@@@@CJP22)O,''A\''I2\''I2\''I2\#0@@@@@
@@@@@@@@@@@@@@@V1SV+H\3AH"H"H"H"H"H"O@@@@@@@@@@@@@@@@@@@@@ VDKZJ!!YSAH"H"H"H"H"H<@@@@@@@@@@@@@@@@@@@@#W57+EXB[%A4H"H"H"H"
H#0@@@@@@@@@@@@@@@@@@@B2RARY-2 UY24E) 8NC : O@@@@@@@@@@@@@@@@@@@@@^?"LX4T81>"<.X\''I2\''H<@@@@@@@@@@@@@@@@@@@@B<MQ_8\%15%"
G@X"H"H"H#0@@@@@@@@@@@@@@@@@@@@M^B]O)61&DS]ELRH"H"H"O@@@@@@@@@@@@@@@@@@@@C@''F2NWN\B:%U!!!!H"H"H"H<@@@@@@@@@@@@@@@@@@@@!!+N0
Q:9(M!!&=WA^[.WZ9#30@@@@@@@@@@@@@@@@@@@@^\''I2\''I2\''I1[7I2\''I2O@@@@@@@@@@@@@@@@@@@@@D"H"H"H"H"H"H"H"H"H"H<@@@@@@@@@@@@@@@@
@@@@CRH"H"H"H"H"H"H"H"H"H#0@@@@@@@@@@@@@@@@@@@BZH"H"H"H"H"H"H"H"H"H[O@@@@@@@@@@@@@@@@@@@@D153XF%V!!6#V,4] U(:GQ6@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 230 230 229 242 108 0 21 232 231 255 186 105 101 75 66 186 160 156 234 234 236 163 163 163 250 163 90 255 188 108 228 228 230 104 104 105 226 226 228 102 102 103 167 102 48 137 61 2 114 91 85 218 218 220 128 58 3 59 58 54 226 160 119 90 53 35 84 84 85 147 68 5 82 82 83 80 80 81 182 182 181 200 156 136 88 88 92 247 247 248 255 187 104 21 231 230 249 184 108 186 186 188 184 184 186 237 237 238 111 89 88 235 235 236 180 180 182 191 120 84 231 231 232 5 237 237 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 213 213 214 99 91 79 254 232 208 253 196 141 101 62 48 221 111 4 101 101 104 114 80 64 133 233 234 150 150 152 89 89 92 255 200 146 85 85 88 218 115 4 254 184 102 254 127 3 174 239 241 172 217 216 215 165 133 134 60 4 0 129 126 85 77 68 0 125 126 110 110 109 69 69 72 105 104 104 19 230 230 0 138 139 102 102 101 3 135 132 116 116 118 165 165 166 254 232 217 161 161 162 19 234 233 137 78 56 84 84 83 139 65 5 220 102 2 97 94 99 95 96 97 172 104 77 90 90 92 253 205 143 88 88 90 255 199 145 86 86 88 84 84 86 219 112 4 56 56 55 231 173 141 5 141 143 21 231 231 3 189 187 115 113 116 252 217 191 107 107 108 2 191 189 223 115 4 247 184 110 134 137 141 225 225 227 250 157 80 221 221 223 0 134 131 219 219 221 254 254 252 205 198 194 159 97 83 89 89 90 105 105 109 91 51 26 193 193 192 254 184 100 254 129 1 95 95 99 185 185 184 110 113 117 219 162 125 144 146 147 91 91 95 89 89 93 9 238 238 216 154 122 253 198 145 246 163 82 173 173 172 120 116 120 186 187 188 238 238 239 247 120 7 249 219 197 174 106 74 181 181 183 254 204 149 108 108 108 230 230 231 2 190 188 2 186 188 179 170 171 243 174 115 116 116 119 0 133 130 165 165 167 223 217 214 75 37 16 216 216 217 108 108 111 255 190 110 175 249 249 190 190 188 255 132 1 96 96 99 135 225 226 251 251 251 90 90 93 255 201 146 88 88 91 101 104 107 137 137 139 145 68 5 254 128 3 133 225 227 251 120 0 133 59 3 0 128 126 111 111 110 11 243 242 109 109 108 240 110 9 159 158 157 106 103 105 5 237 236 88 135 130 215 106 4 119 58 22 173 233 233 107 107 109 122 123 127 254 136 9 222 113 4 85 85 84 173 235 236 213 213 216 138 138 139 190 118 68 83 83 85 187 187 187 136 62 5 133 58 2 164 165 161 127 70 39 138 243 244 254 202 147 78 38 4 201 153 138 254 200 147 87 87 92 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@G??0@A??<@@_??@@G??0@A??<@@_??@A''??0@=??<@_???@O???0A???<@O???@A???0@O??<@A???@@O??0@A??<@@_??@@G??0@A??<@@_??@@G?
?0@A??<@@_??@@G??0@A??<@@_??@@G??0@A??<@@_??@@@@@@@b');
                            yourself);
                yourself
        ]
!

menuEditor32x32Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuEditor32x32Icon2 inspect
     ImageEditor openOnClass:self andSelector:#menuEditor32x32Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class menuEditor32x32Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@L!!J@2A$YB@C@2A$YEIRT%H<@@@@@@@@@@@@@@CJ2 @@NIJR$)JR$)JR$)JR$)JR$#0@@@@@@@@@@@@@2$HO2 B*$)JR$)JR
$)JQZYJR$)JRO@@@@@@@@@@@@L(2BXSA2*E%$)JR$)JR$)JR$)JR$)H<@@@@@@@@@@CJ 2>1Z8;A-VN-+Z5FQ$Z-QDQDR4-KR30@@@@@@@@@@@CJD28?^U/A
H''I2\''I2\''I2\''I2\''I2O@@@@@@@@@@@@@CJU[1:AE7AH"H"H"H"H"H"H"H"H"H<@@@@@@@@@@@@@@CJ*C6;B#OAH"H"H"H"H"H"H"H"H#0@@@@@@@@@@@@@
@@CJ1FB_G3/AH"H"H"H"H"H"H"H"O@@@@@@@@@@@@@@@@@CJFF(+''JSA^7-;(E];(@0LC@0<@@@@@@@@@@@@@@@@@@CJP22)O,''A\''I2\''I2\''I2\#0@@@@@
@@@@@@@@@@@@@@@V1SV+H\3AH"H"H"H"H"H"O@@@@@@@@@@@@@@@@@@@@@ VDKZJ!!YSAH"H"H"H"H"H<@@@@@@@@@@@@@@@@@@@@#W57+EXB[%A4H"H"H"H"
H#0@@@@@@@@@@@@@@@@@@@B2RARY-2 UY24E) 8NC : O@@@@@@@@@@@@@@@@@@@@@^?"LX4T81>"<.X\''I2\''H<@@@@@@@@@@@@@@@@@@@@B<MQ_8\%15%"
G@X"H"H"H#0@@@@@@@@@@@@@@@@@@@@M^B]O)61&DS]ELRH"H"H"O@@@@@@@@@@@@@@@@@@@@C@''F2NWN\B:%U!!!!H"H"H"H<@@@@@@@@@@@@@@@@@@@@V+N0
Q:9(M!!&=WA^[.WZ9#30@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 230 230 229 242 108 0 21 232 231 255 186 105 101 75 66 186 160 156 234 234 236 163 163 163 250 163 90 255 188 108 228 228 230 104 104 105 226 226 228 102 102 103 167 102 48 137 61 2 114 91 85 218 218 220 128 58 3 59 58 54 226 160 119 90 53 35 84 84 85 147 68 5 82 82 83 80 80 81 182 182 181 200 156 136 88 88 92 247 247 248 255 187 104 21 231 230 249 184 108 186 186 188 184 184 186 237 237 238 111 89 88 235 235 236 180 180 182 191 120 84 231 231 232 5 237 237 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 213 213 214 99 91 79 254 232 208 253 196 141 101 62 48 221 111 4 101 101 104 114 80 64 133 233 234 150 150 152 89 89 92 255 200 146 85 85 88 218 115 4 254 184 102 254 127 3 174 239 241 172 217 216 215 165 133 134 60 4 0 129 126 85 77 68 0 125 126 110 110 109 69 69 72 105 104 104 19 230 230 0 138 139 102 102 101 3 135 132 116 116 118 165 165 166 254 232 217 161 161 162 19 234 233 137 78 56 84 84 83 139 65 5 220 102 2 97 94 99 95 96 97 172 104 77 90 90 92 253 205 143 88 88 90 255 199 145 86 86 88 84 84 86 219 112 4 56 56 55 231 173 141 5 141 143 21 231 231 3 189 187 115 113 116 252 217 191 107 107 108 2 191 189 223 115 4 247 184 110 134 137 141 225 225 227 250 157 80 221 221 223 0 134 131 219 219 221 254 254 252 205 198 194 159 97 83 89 89 90 105 105 109 91 51 26 193 193 192 254 184 100 254 129 1 95 95 99 185 185 184 110 113 117 219 162 125 144 146 147 91 91 95 89 89 93 9 238 238 216 154 122 253 198 145 246 163 82 173 173 172 120 116 120 186 187 188 238 238 239 247 120 7 249 219 197 174 106 74 181 181 183 254 204 149 108 108 108 230 230 231 2 190 188 2 186 188 179 170 171 243 174 115 116 116 119 0 133 130 165 165 167 223 217 214 75 37 16 216 216 217 108 108 111 255 190 110 175 249 249 190 190 188 255 132 1 96 96 99 135 225 226 251 251 251 90 90 93 255 201 146 88 88 91 101 104 107 137 137 139 145 68 5 254 128 3 133 225 227 251 120 0 133 59 3 0 128 126 111 111 110 11 243 242 109 109 108 240 110 9 159 158 157 106 103 105 5 237 236 88 135 130 215 106 4 119 58 22 173 233 233 107 107 109 122 123 127 254 136 9 222 113 4 85 85 84 173 235 236 213 213 216 138 138 139 190 118 68 83 83 85 187 187 187 136 62 5 133 58 2 164 165 161 127 70 39 138 243 244 254 202 147 78 38 4 201 153 138 254 200 147 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_??@A''??0@=??<@_???@O???0A???<@O???@A???0@O??<@A???@@O??0@A??<@@_??@@G??0@A??<@@_??@@G?
?0@A??<@@_??@@G??0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

menuEditor32x32Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuEditor32x32Icon3 inspect
     ImageEditor openOnClass:self andSelector:#menuEditor32x32Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class menuEditor32x32Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GU2\34@@@@@@@@@@@@@@@@@@@@@@@@@@@A)N9MRUVL@@@@@@@@@@@@@@@@@
@@@@@@@@@I!!I_''17L @@@@@EK"8.K"8.K"8.K"8.K"9$!!D1?YS]U@@@@@@TOC0<OC0<OC0<OC0<OC81H$S)9M @@@@@@AP<OC0<OC0<OC0<OC0<OQ$:VY4)0
@@@@@@@EC0<OC0<OC0<OC0<OC61AZG(>%0@@@@@@@A,[F1,[F1,[F1,[F1,[X(ADZ)UG@@@@@@@@@0LC@0LC@0LC@0LC@8]M V>F^8L@@@@@@@@LD1LSD1LS
D1LSD1LSP648TWY4@@@@@@@@@@0SD1LSD1LSD1LSD5A_[(49V!!P@@@@@@@@@CALSD1LSD1LSD1LS"8)\MUNRE@@@@@@@@@@,KB0,KB0,KB0,KE%@QX:OLR0T
@@@@@@@@@@T.K"8.K"8.K"8._U!! W&ZIK!!P@@@@@@@@@AP<OC0<OC0<OC0=8R303$H OE@@@@@@@@@@EC0<OC0<OC0<OC5QRO4IVC0<T@@@@@@@@@@TOC0<O
C0<OC0<OU5JT!!P<OC1P@@@@@@@@@F1,[F1,[F1,[F1-[MGD[IAPTE@@@@@@@@@@EK"8.K"8.K"8.K&EOK"8.K"8T@@@@@@@@@@TKC0<OC0<OC0<OZ0<OC0<O
C1P@@@@@@@@@AR$OC0<OC0<OC0<OC0<OC0<OE@@@@@@@@@@JG!!\OC0<OC0<OC0<OC0<OC0<T@@@@@@@@@@8AA2(!!FA<IGRL"@!!X E!!@TIAP@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 106 103 105 108 108 111 21 232 231 3 189 187 226 226 228 104 104 105 109 109 108 21 231 231 82 82 83 213 213 214 187 187 187 133 233 234 21 231 230 90 90 92 186 186 188 108 108 108 135 225 226 138 243 244 2 186 188 85 85 88 133 225 227 107 107 109 182 182 181 107 107 108 19 230 230 0 129 126 102 102 103 0 128 126 85 85 84 180 180 182 101 101 104 105 105 109 111 111 110 84 84 85 88 88 90 96 96 99 0 125 126 2 191 189 0 138 139 97 94 99 193 193 192 110 110 109 19 234 233 5 141 143 95 95 99 254 254 252 2 190 188 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@C0@@@A>@@@@_ A???8@_??<@G???@A??? @_??8@G??>@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A???@@_??0@G??<@A??
?@@_??0@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

openEditApplication32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self openEditApplication32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#openEditApplication32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class openEditApplication32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@ LC@0LC@0LC@0LC@0LCA@@@@@@@@@@@@@@@@@@@@@TFA0 HB@ HB@ HB@ HB@ IB @@@@@@@@,KC@4NC0@@DA@P
DA@PDA@PDA@QD!!DRD0$TEP@@@@@@E!!\WE1 @@A$ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZEA,\@@@@@@@@@@@@@@@@GQ8^G!!8^G!!8^G!!8^G!!8^G!!8JEQ0@@@@@@@@@@@@@
@@@_G!!8^HB@^HB@ HB@!!HQL^G"HU@@@@@@@@B0,#G@<@IBT&G!!8 HA8 HB@ HRDSD18^I10@@@@@@@@VE1\(@@@]H18^G!!8^G!!8^G"D!!JR$SG"(''G@@@@@@@
@@@@@@@@@A<^G!!8 HA8 HB@!!HR$)JQL^J1T@@@@@@@@@@@@@@@@$IQ8^G"@ G"@ HRD)JR$,KQ8.EP@@@@@@@@@KB0,O@A4#G!!8^G!!8^G"D0JR$)KB4^J (\
@@@@@@@@@CHWE0@@GRL^G"@ G"@1LC@)JR0-G!!8*B!!0@@@@@@@@@@@@@@@@_G!!8^HB@^HBD0LC@0L2@^G",''G@@@@@@@@@@@@@@@IBT^G!!8^G!!81LC@0KB0 
G!!8^K!!T@@@@@@@@@@CT5@@@]H18^HB@^HCP0KB0 HB@ G"(JEP@@@@@@@@@@E1\@@A<^G!!8 HA84KSL HB@ HB@^J2\\@@@@@@@@@@@@@@@$M18^G!!8^G#P^
G!!8^G!!8^G!!8.EQ0@@@@@@@@@@@@@@C 9N#(:N#(:N#(:N#(:N#(:N0(U@@@@@@@@@@@@@@@@OC4>O3<?O3<?O3<?O3<?O3<?EQ0@@@@@@@@@@@@@@@@@EQTU
EQTUEQTUEQTUEQTUEQTU@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 80 112 176 48 88 168 47 80 160 16 64 144 0 72 176 32 112 208 32 120 208 63 136 216 0 104 208 0 48 160 223 224 240 208 216 224 207 200 200 191 184 184 191 184 200 0 112 216 159 208 248 16 112 208 255 104 48 0 64 168 96 96 96 160 160 168 127 120 120 112 120 120 95 120 176 32 160 248 47 64 104 207 192 184 16 64 168 240 232 216 16 64 160 255 248 248 255 168 88 15 40 120 208 208 208 79 104 168 96 136 176 240 232 208 16 48 120 112 112 104 255 128 0 224 216 208 128 152 184 192 88 0 48 48 48 32 72 168 207 208 216 255 216 168 160 160 160 143 144 144 64 0 0 95 88 88 191 192 200 144 144 136 128 160 184 15 56 144 160 176 200 207 200 208 191 192 208 63 88 168 31 64 136 15 48 128 15 48 120 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A??<@@_?? _''??<G3???@@???0@O??8G7??>A9??? @_??0@O??<A;???@\???0@O??<@G??>@Y??? F_??8@O?
?>@C???@@???0@G??8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

openViewerApplication32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self openViewerApplication32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#openViewerApplication32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class openViewerApplication32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@ LC@0LC@0LC@0LC@0LCA@@@@@@@@@@@@@@@@@@@@@TFA0 HB@ HB@ HB@ HB@ IB @@@@@@@@,KC@4NC0@@DA@P
DA@PDA@PDA@QD!!DRD0$TEP@@@@@@E!!\WE1 @@A$ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZEA,\@@@@@@@@@@@@@@@@GP@@@@@@@@@@@@@@@@@@@@@JEQ0@@@@@@@@@@@@@
@@@^@@@@G1<@G1<_G1<_G1<@@B@U@@@@@@@@B0,!!G@<@H"L$@@@_G0@_G1<_G1<_G0@@IQ0@@@@@@@@VE1\&@@@]HP@@@@@@@@@@@@@@@@@@@B\%G@@@@@@@
@@@@@@@@@A8@@@@_G0@_G1<_G1<_G0@@JAT@@@@@@@@@@@@@@@@"H0@@@A<_@A<_G1<_G1<_@@@)EP@@@@@@@@@*J <O@A4!!@@@@@@@@@@@@@@@@@@@@I0(\
@@@@@@@@@B,+J0@@GRD@@A<_@A<_G1<_G1<_@@@''B!!0@@@@@@@@@KB0,@@@^@@@@G1<@G1<_G1<_G1<@@B %G@@@@@@@@@@@@@@@H"L@@@@@@@@@@@@@@@@@
@@@@JQT@@@@@@@@@@@4MK@@]HP@@G1<@G1<_G1<_G1<@@B\JEP@@@@@@@@@@KR4,@A8@@@@_G0@_G1<_G1<_G0@@JBT\@@@@@@@@@@@,K@@"K @@@@@@@@@@
@@@@@@@@@@@)EQ0@@@@@@@@@@@@@@B<0LSD1LSD1LSD1LSD1LSD1L (U@@@@@@@@@@@@@@@@L3P5M#X6M#X6M#X6M#X6M#X6EQ0@@@@@@@@@@@@@@@@@EQTU
EQTUEQTUEQTUEQTUEQTU@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 240 232 216 80 112 176 48 88 168 47 80 160 16 64 144 0 72 176 32 112 208 32 120 208 63 136 216 0 104 208 0 48 160 223 224 240 208 216 224 207 200 200 191 184 184 191 184 200 0 112 216 159 208 248 16 112 208 255 104 48 0 64 168 96 96 96 160 160 168 127 120 120 112 120 120 95 120 176 32 160 248 47 64 104 207 192 184 16 64 168 16 64 160 255 248 248 15 40 120 208 208 208 79 104 168 96 136 176 240 232 208 16 48 120 112 112 104 224 216 208 128 152 184 32 72 168 207 208 216 143 144 144 0 0 0 144 144 136 128 160 184 15 56 144 160 176 200 207 200 208 191 192 208 63 88 168 31 64 136 15 48 128 15 48 120 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A??<@@_?? _''??<G3???@@???0@O??8G7??>A9??? @_??0@O??<A;???@\???0@O??<@G??>@Y??? F_??8@O?
?>@C???@@???0@G??8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

uiPainter32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#uiPainter32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class uiPainter32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@T@APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTE@@@EAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTE
APTEAPT@@@@EAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAP@@@@TFA XFA XFA XFA XFA XFA XFA XFA XFA XB@@@@APXFA XFA XFA XFA XFA XF
A XFA XFA XFA H@@@@EC@XEAPTEAPTEAPTEAP@FA PDA@PDA@PDA@TF@ @@@@0&C@TFA XFA XFA XF@@XFA@DA@PDA@PDAAPXB@@@LB (<T@XFA XFA XF
A X@A XD@PDAAPXA@PDEA H@CC,\R3QAT@XFA XFA XFA @FA PA@PTFA XA@PTF@ @@UP<[IS .T@XFA XFA XF@@XFA@DEA XFA XAAPXB@@@@UR-ONP /
T@XFA XFA X@A XD@PPDA@PDA@DEA H@@@@EUT\#S ,^T@XFA XFA @FA PA@PDA@PDA@PTF@ @@@@TFUUD0QQP"T@@@@@@@@@XFA@DA@PDA@PDAAPXB@@@@
APXFUQH3FDQFT@XFA XFA XD@PDA@PDA@PDEA H@@@@EA XFUR\YRBQTT@XFA XFA PA@PDA@PDA@PTF@ @@@@TFA XFDUH RQUWT@XFA XFA@DA@PDA@PDA
APXB@@@@APX@@@@@DP5LO#5BT@@@A XD@PDA@PDA@PDEA H@@@@EA @EAPTEM4(,A3T)U TFA PA@PDA@PDA@PTF@ @@@@TF@@TEAPTEP44WDCHZU XFA@DA
@PDA@PDAAPXB@@@@APX@APTEAPTEG2)@N#=VA XD@PDA@PDA@PDEA H@@@@EA @EAPTEAPTEE%L-LQLIA PAAPTEAPTE@PTF@ @@@@TF@@TEAPTEAPTEBP8!!
JA4FA@DEA XFA PAAPXB@@@@APX@APTEAPTEAPTEAPXEA XD@PDEA XD@PDEA H@@@@EA @EAPTEAPTEAPTEA TFA PA@PDEA@DA@PTF@ @@@@TF@@XFA XF
A XFA XFAPXFA@DA@PDA@PDAAPXB@@@@APXEAPTEAPTEAPTEAPTEA XEAPTEAPTEAPTEA H@@@@EA XFA XFA XFA XFA XFA XFA XFA XFA XF@ @@@@HB
@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@@E@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H@@@TB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB
@ @E@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 160 160 160 128 128 128 0 0 128 88 88 88 255 255 255 195 195 195 242 108 0 255 186 105 186 160 156 250 163 90 255 188 108 167 102 48 137 61 2 114 91 85 128 58 3 226 160 119 90 53 35 147 68 5 200 156 136 255 187 104 249 184 108 111 89 88 191 120 84 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 99 91 79 253 196 141 101 62 48 221 111 4 114 80 64 255 200 146 218 115 4 254 184 102 254 127 3 215 165 133 134 60 4 85 77 68 254 232 217 137 78 56 139 65 5 220 102 2 172 104 77 253 205 143 255 199 145 219 112 4 231 173 141 252 217 191 223 115 4 247 184 110 250 157 80 254 254 252 91 51 26 254 184 100 254 129 1 219 162 125 216 154 122 253 198 145 246 163 82 247 120 7 249 219 197 174 106 74 254 204 149 243 174 115 75 37 16 255 190 110 255 132 1 255 201 146 145 68 5 254 128 3 251 120 0 133 59 3 240 110 9 215 106 4 119 58 22 254 136 9 222 113 4 190 118 68 136 62 5 133 58 2 127 70 39 254 202 147 78 38 4 201 153 138 254 200 147 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@O????#????8????>O????#????9????>?????''????8????>O????#????8????>O????#????8????>O????#????8????>O????#??
??8????>O????#????8????>O????#????8@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

uiPainter32x32Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter32x32Icon2 inspect
     ImageEditor openOnClass:self andSelector:#uiPainter32x32Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class uiPainter32x32Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@APTEAPTEAPTEAPTEAPTEAY6Z&6TEAPTEAP@EAPTEAPTEAPTEAPTEAPVQX;):_X,EAPTE@@@EAPTEAPTEAPTE
APTEA[=1)*R_V TEAPT@@@TFA XFA XFA XFA ZL*7R''#U==A HB@ @@APXFA XFA XFA XFA+M0.FJ!!W XF@ HB@@@EA TEAPTEAPTEAPTE[''Z=#7JXAPXB
@ H@@@TFAPXFA XFA XFA)Q)$JI&/ D@A HB@ @@APXEA XFA XFA XF"*!!,$+1/A @F@ HB@@@EA TFA XFA XFA*95*Y^-(0XF@@XB@ H@@@TFAPXFA XF
A XFZ9U ^Y:\A X@A HB@ @@APXEA XFA XFA''"G%+Q!!  XFA @F@ HB@@@EA TFA XFA XF,+FDWW.9A XF@@XB@ H@@@TF@@@@@@@@@HE([[V6VP@@@@@@
A HB@ @@APXFA XFA XF)XBH!!(:0A XFA XF@ HB@@@EA XFA XFA Z \6Q[-:<FA XFA XB@ H@@@TF@@@@@@@@@G1:Y6)>@@@@@@@@A HB@ @@APX@APTE
APTE_7*;+@TEAPTEA TF@ HB@@@EA @EAPTEAPVCWI$EAPTEAPTFAPXB@ H@@@TF@@TEAPTEAX%7APTEAPTEAPXEA HB@ @@APX@APTEAPTE$0TEAPTEAPTE
A TF@ HB@@@EA @FA XFA XFA XFA XFA XFAPXB@ H@@@TFAPTEAPTEAPTEAPTEAPTEAPTEA HB@ @@APXFA XFA XFA XFA XFA XFA XF@ HB@@@B@ HB
@ HB@ HB@ HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ @a');
                colorMapFromArray:#[ 64 64 64 160 160 160 128 128 128 0 0 128 88 88 88 255 255 255 195 195 195 242 108 0 255 186 105 186 160 156 250 163 90 255 188 108 167 102 48 137 61 2 114 91 85 128 58 3 226 160 119 90 53 35 147 68 5 200 156 136 255 187 104 249 184 108 111 89 88 191 120 84 255 132 8 214 114 4 239 204 187 214 106 4 241 146 80 99 91 79 253 196 141 101 62 48 221 111 4 114 80 64 255 200 146 218 115 4 254 184 102 254 127 3 215 165 133 134 60 4 85 77 68 254 232 217 137 78 56 139 65 5 220 102 2 172 104 77 253 205 143 255 199 145 219 112 4 231 173 141 252 217 191 223 115 4 247 184 110 250 157 80 254 254 252 91 51 26 254 184 100 254 129 1 219 162 125 216 154 122 253 198 145 246 163 82 247 120 7 249 219 197 174 106 74 254 204 149 243 174 115 75 37 16 255 190 110 255 132 1 255 201 146 145 68 5 254 128 3 251 120 0 133 59 3 240 110 9 215 106 4 119 58 22 254 136 9 222 113 4 190 118 68 136 62 5 133 58 2 127 70 39 254 202 147 78 38 4 201 153 138 254 200 147 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@^@@@@O0@O???@C???0@???<@O???@C???0@???<@O???@C???0@???<@O???@C???0@???<@O???@C???0@???<@O???@C???0@???<@O???@C??
?0@???<@O???@@@@@@@b');
                            yourself);
                yourself
        ]
!

uiPainter32x32Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter32x32Icon3 inspect
     ImageEditor openOnClass:self andSelector:#uiPainter32x32Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class uiPainter32x32Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)R@?EPY%C!!QKGW5ZM050RL[C1H8+KQL?Q7<>YE@6W''UIE#@EW[*L9JN&-HAVVTIUSTY2U4@!!B6L8UA3)&,?M2HLYLW ^
[#I''V6@QS''1_C4*55Y7P-("&SA PC@0LC@0LC@0LC@0L7Y''""<*GC@09V@0JB (JB (JB 0LB)^_9;"[0P(LT"XLB 0LC@0LC@$LCK6R.\.O:@0ICC,''C@(L
C@0LC@0IC@234YV;9) LBP1:[@0JC@0LC@0LBP3X''-K@5<3TC@$LOF4LBP$IBP$IBP$L%K:I(,_EBP$ICBP(C@0LC@0LC@0L([B?7(*+C@0LC@1*[00IBP$I
BP$IB]3[+XZ$80$IBP$LOWDLBPLC@0LC@:*Q%-?  *8C@0HACBT*C@$C@0LC@0ON*[F/-=(C@0LB@P0%_ 0I@0LC@0LC2Y2M!!NGY@ LC@ DLIWLLBPHB@ HB
@*V#$IN''@ HB@ HACBUCC@$A@PDA@PF((>WV@PDA@PDA@P0%K@0LC@0LC@0L+HWBC@0LC@0LC@0LIR0LC@0LC@0LCKJ C@0LC@0LC@0LCBT,C@0LC@0LC@2<
C@0LC@0LC@0LC@0%Y''P4MWXGBEESB@!!SH&$%IRT%IRT%Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 160 160 160 247 246 249 225 225 234 245 244 247 21 91 255 48 118 255 71 155 231 75 126 202 72 122 199 116 116 120 237 236 242 72 141 255 212 211 224 32 101 209 63 143 226 153 188 255 106 175 235 170 204 255 7 66 194 0 50 164 58 137 224 75 160 234 66 135 255 140 175 255 29 72 179 3 67 246 19 88 255 18 83 201 36 106 255 50 125 219 191 225 255 58 99 184 57 149 229 80 149 255 55 95 181 125 160 253 52 89 178 50 87 176 105 172 233 104 170 232 101 166 229 10 71 196 98 162 226 5 63 191 94 154 222 2 56 178 3 73 255 30 100 255 57 127 255 1 50 177 185 219 255 130 165 254 84 140 212 81 136 209 101 170 255 36 107 211 54 123 255 56 94 181 126 161 253 55 92 180 53 90 178 51 88 176 125 193 255 68 157 232 88 157 255 135 170 255 132 200 255 96 157 223 12 59 167 4 74 255 112 180 255 139 207 255 23 89 204 75 144 255 149 184 255 54 131 221 122 154 245 119 187 255 166 200 255 28 97 255 109 178 255 69 117 196 56 93 180 66 113 193 45 115 255 126 194 255 0 50 171 96 165 255 105 174 234 77 163 236 41 113 214 177 212 255 12 82 255 39 109 255 93 161 255 157 192 255 174 208 255 64 108 190 61 104 187 63 132 255 117 186 255 67 149 229 53 127 212 181 215 255 255 255 255 52 90 178 51 88 177 144 179 255 103 169 231 102 167 230 188 222 255 100 165 228 27 95 206 99 163 227 104 173 255 97 159 225 87 145 215 84 153 255 78 131 206 10 79 255 91 168 235 127 162 254 54 91 179 14 77 199 162 196 255 45 119 216 98 160 225 132 201 255 3 64 241 204 208 220 222 120 43 183 59 8 254 203 97 163 140 130 254 191 54 210 109 64 228 90 9 254 187 34 254 165 54 254 158 1 250 206 0 254 212 90 155 31 0 254 128 21 254 225 166 253 222 69 254 226 7 248 201 137 247 181 30 254 177 17 254 216 73 248 194 1 192 147 138 254 223 0 254 219 0 242 102 12 254 226 119 254 191 0 254 231 26 254 203 3 169 113 95 249 210 160 254 176 36 254 231 201 254 165 69 241 195 142 234 184 145 186 100 65 226 180 137 254 239 98 245 209 172 220 114 42 161 124 106 254 197 55 222 209 212 254 203 78 253 226 47 254 209 81 160 115 98 247 183 8 166 46 5 241 212 187 254 136 5 254 184 94 254 144 8 254 178 11 215 172 138 254 159 21 213 175 169 242 177 95 254 220 37 254 207 47 254 181 24 145 109 112 193 129 103 223 153 96 195 100 52 193 132 116 223 137 33 254 147 47 254 141 47 245 202 137 254 116 14 254 171 10 207 90 27 254 161 10 248 203 113 254 162 0 254 158 0 254 213 16 254 194 26 255 255 255 213 217 227 248 198 0 182 93 58 254 147 36 247 198 128 205 177 176 210 140 105 254 231 65 249 193 57 240 178 78 254 191 42 254 201 65 254 184 75 228 142 66 254 167 2 195 120 93 254 214 81 248 214 181 248 122 26 254 167 5 197 82 32 232 174 56 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C????????????????????????????????????????????????????????????????????????????????????');
                            yourself);
                yourself
        ]
!

warn32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self warn32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#warn32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'XPToolbarIconLibrary class warn32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@I.[&9.[&9.[&9.[&9-ZLFUG&9.[&9.[&9.[
&9.[&9.[&9.[&9.[&9.[&9.[&3A0#FUF&9.[&9.[&9.[&9.[&9.[&9.[&9.[&9.[&9.AGQ]V^R, &9.[&9.[&9.[&9.[&9.[&9.[&9.[&9.[&6UJIA *]11Z
&9.[&9.[&9.[&9.[&9.[&9.[&9.[&9-CP1^Q_Q 8J4Z[&9.[&9.[&9.[&9.[&9.[&9.[&9.[V&TWIIE$_Q"M"9V[&9.[&9.[&9.[&9.[&9.[&9.[&9,I\A\M
U)E$F@P%TY.[&9.[&9.[&9.[&9.[&9.[&9.[ P(W\V5V$S9=J!!DEHI.[&9.[&9.[&9.[&9.[&9.[&9-%W!!]1%W83$$,X&RT\&9.[&9.[&9.[&9.[&9.[&9.[
P14WE2RU$)JRE1"Y!!QI)&9.[&9.[&9.[&9.[&9.[&5(+#A\$ICRR^G WJ)$7T#>U&9.[&9.[&9.[&9.[&9.[BRDW[V4MC''!!*U7D*&S^ZKEF[&9.[&9.[&9.[
&9.[&7ADIF5VU%X1Z!!9W\Y$7%%6BFRB[&9.[&9.[&9.[&9.[A --$YFQ$YL^_3L$&S^Z[%.FGI.[&9.[&9.[&9.[&4M%CYE=#&RN_W=+RF47&%5.[''I_ZY.[
&9.[&9.[&9-ZJ5"QFA XFA X_7)HCYY][&9]%$09%Y.[&9.[&9.[&4T&$R*YAB(*J Q&D785WV9.WY(7@H\2&9.[&9.[&9,4J6RNM3\7&Y&YM5M@H =.[%6Z
M9$D\6BU&9.[&9.[&0X_YIY]&)*V%)ZZSY\:CF9]WYX7&R(XI12[&9.[&9.TJ88T[&9]WU5]WU4A"F9.WY*VM9$*FG4&]HN[&9.[[0T-#))][&9.[&9.WFDZ
S)&ZM3^YJ!!!!=YIDRNU*[&9-EA88*%))]WU5]WU4;F" U@)&YAB(X_VRQU(BOL).[%QI=_Y&YM3^V%)*Z&(%5EW,WJ"(XFG5$$UXM[PY"%Y,FI(8XJ"*Y&Y$7
M3\7&QEI#EX*FG6NYIEVCV4$M$=''&21=_Q XF@PDA@QT@@@<OC2EPTEAK"8[F61YB@"PJRLV_BU(ZGM3\5UUIRT;SD1L@8*JJR%6]$I6]''Y6]!!BXX2B["2L#
H2L#!!HQPTEA#X6M#X6M#X6M#X6M#X6M#X34/&9.[HHNC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NCHI.[@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 224 192 64 255 191 31 223 223 223 160 96 32 255 223 95 159 127 95 160 128 96 191 160 95 224 191 96 191 160 127 191 159 127 224 223 160 255 223 127 255 255 191 224 224 191 255 224 159 128 95 32 223 191 64 159 127 64 64 95 128 255 224 64 32 32 96 223 192 192 255 255 255 255 224 96 128 96 95 63 63 127 223 160 64 159 128 127 192 160 128 95 96 160 223 192 127 192 192 191 223 191 160 159 159 191 96 95 64 255 255 223 160 128 64 192 191 96 128 96 63 32 63 127 159 95 32 255 224 95 160 128 95 159 96 64 224 223 127 223 160 63 127 127 127 192 160 127 224 224 160 160 160 159 127 128 191 223 223 191 255 224 160 224 223 191 255 223 63 224 223 95 128 127 96 223 223 224 160 128 63 224 191 64 95 64 64 224 224 128 159 127 96 64 64 128 224 160 63 159 64 31 192 191 159 191 128 96 191 160 128 191 160 159 223 191 159 128 128 191 191 160 160 224 224 223 255 224 192 160 127 63 192 160 63 96 95 95 127 64 32 96 64 63 160 159 128 191 128 63 96 96 127 255 192 64 191 128 64 255 255 160 127 127 160 224 224 159 224 160 95 224 223 192 255 191 0 224 191 31 255 192 31 224 223 223 128 96 64 127 96 64 64 64 96 127 95 64 95 64 63 255 255 128 191 159 96 96 96 128 159 159 128 191 159 95 191 191 160 96 96 160 95 95 159 223 160 95 255 255 192 255 192 0 224 224 192 223 192 191 255 255 224 223 160 32 191 159 64 127 95 63 63 63 96 159 95 31 192 159 95 96 127 160 224 192 95 64 95 159 64 64 127 160 159 127 255 224 127 128 159 191 95 96 159 224 223 159 223 192 160 192 159 32 192 191 191 96 95 63 224 191 63 159 127 63 128 95 63 223 160 31 223 191 63 159 96 32 159 128 96 255 224 224 192 160 95 255 255 127 127 64 63 223 159 63 255 255 159 96 127 191 255 224 128 192 191 160 223 223 192 255 223 32 191 191 191 96 63 32 255 223 64 255 192 32 0 0 0 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@A8@@@@_@@@@O8@@@C?@@@A?0@@@?>@@@O? @@G?<@@A??@@@??8@@_??@@G??0@C??>@@??? @_??<@O??? C???8A????@_???0O???>G??
??1????<?????/????;??????????7????8????<@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

workspace32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self workspace32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#workspace32x32Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class workspace32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\11VAA(@[0@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@\D@< "1()[0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FT\@@@ "1)8[0@@@@@@@@@@@@@@@@@@@@@@@@@@\11VAA(@K''%&
VG%9[0@@@@@@@@@@@@@@@@@@@@@@@@@\D@< "18?K$1[^W%9[0@@@@@@@@@@@@@@@@@@@@@@@FT\\4%6P!!8?XTE9"W%9[0@@@@@@@@@@@@@@@@@@\11VAA*W
K''$RXC:U@G%9"W%9[0@@@@@@@@@@@@@@@@@\D@< "18?K$1^_"(&^W%9T7%9[0@@@@@@@@@@@@@@@FT\\4%6P!!8?XTE8M''!!8^EM8"RY:[0@@@@@@@@@@\11V
AA*WK''$RXH6U@G]8T7!!S^G\#AW $[0@@@@@@@@@\D@< "18?K$1^_''99]7!!8T7!!7H2M8N"P([0@@@@@@@FT\\4%6P!!8?XTE8T7]7]5M8"BL#^C($W70)@@@@
\11VAA*WK''$RXH6U@G!!8"G^H]7\#AW :IG%9X78@@@@\D@< "18?K$1^_''99^G!!7"G]7H2M8N"Q9^RY>% @@@FT\ED%6P!!8?XTE8T7!!8^H!!7"BL#^C($W7$&
I)I:@@@\G@BWK''$RXH6U@G!!7"G^H]7\#AW :IG%9B7)EI7,@@@]4@C<?K$1^_''99^G]7"G]7H2M8N''$AR4-\WF1,[@@@EDX#K#<?XTE8T7!!8]8!!7"BL#IEER
T#MTVPY=_W5=@@@Q@BD#K(6U@G!!8T7"H]7]8TUIRL4)HGT "]YL,H&4@@@@@YG%9_''99^G!!8T7]U\WD1R 8NJ543L0$UEQTUEP@@@@A$YG!!9T7!!8]5M7E!!XV
M82DQHRD!!I@/EQTUEQTU@@@@@F!!$YG%9T7!!S]7\$@!!XJP4A)@34;F2=WEQTUEQT@@@@@[6!!$YG%8T7!!7H7%?&@EPE *EIP5M!!(JB (JB  @@@@@@[6!!$YG!!8
T2L#^S:CTS>T@U@VB(VEB@0LC@0L@@@@@@@@[6!!$YG$&NRZKI240Z#)[$PEN\V1,[F1,[F0@@@@@@@@@[6!!$YG(''V"P&I7:AS3P8OIFXYT9NS$9NG0@@@@@@
@@@@[6!!$YG-;W7$&^$\)D282"''BN\(>O#7H?@@@@@@@@@@@@[6!!$YB!!<X"ZR^'',(Y25+ 3RG[#TYMX\@@@@@@@@@@@@@FF!!$YB$&$''(''I7-;Y2$*KR4-E8B@
KP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 167 167 167 157 157 157 146 82 44 155 155 155 208 208 207 234 154 84 147 147 147 138 66 36 234 130 84 70 70 68 190 190 189 146 66 4 86 70 44 250 198 172 131 131 131 129 129 129 127 127 127 123 123 123 174 174 173 119 119 119 254 130 4 46 46 44 166 166 165 107 107 107 154 154 153 99 99 99 186 94 36 83 83 83 250 218 204 77 77 77 126 126 125 71 71 71 248 248 248 254 202 188 246 246 246 244 244 244 82 70 52 242 242 242 240 240 240 238 238 238 236 236 236 234 234 234 250 194 164 254 206 148 232 232 232 226 226 226 230 106 52 222 222 222 246 182 140 218 218 218 246 178 140 216 216 216 214 214 214 212 212 212 134 106 76 208 208 208 206 206 206 202 202 202 150 94 52 198 198 198 150 86 52 194 194 194 192 192 192 118 82 60 11 11 11 186 186 186 98 82 60 214 142 108 184 184 184 5 5 5 182 182 182 250 214 196 3 3 3 250 210 196 122 66 44 176 176 176 102 66 44 174 174 174 170 170 170 90 86 12 166 166 166 186 114 100 213 213 212 250 190 156 158 158 158 156 156 156 242 110 36 152 152 152 246 198 132 203 203 202 148 148 148 102 34 4 246 186 132 146 146 146 197 197 196 140 140 140 138 138 138 191 191 190 187 187 186 132 132 132 126 126 126 124 124 124 171 171 170 116 116 116 130 74 44 167 167 166 163 163 162 2 2 4 254 222 172 155 155 154 100 100 100 143 143 142 84 84 84 137 137 136 255 255 255 74 74 74 254 174 132 70 70 70 247 247 247 245 245 245 243 243 243 241 241 241 239 239 239 237 237 237 254 170 92 235 235 235 233 233 233 231 231 231 229 229 229 178 82 4 221 221 221 210 138 108 94 74 60 122 82 28 215 215 215 213 213 213 211 211 211 209 209 209 201 201 201 186 126 84 195 195 195 193 193 193 191 191 191 210 106 68 187 187 187 185 185 185 254 190 124 183 183 183 4 4 4 181 181 181 2 2 2 179 179 179 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@> @@@O<@@@C? @@G?<@@A?? @@_?<@@??? @O??<@C??? G???<A???? _???8????>O????#????9????>_????''????9_???>G????!!??
??8_???>G???? ????8G???>@???? G???8@???>@G??? @@@@@b');
                            yourself);
                yourself
        ]
!

workspace32x32Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self workspace32x32Icon2 inspect
     ImageEditor openOnClass:self andSelector:#workspace32x32Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class workspace32x32Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\11VAA(@[0@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@\D@< "1()[0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FT\@@@ "1)8[0@@@@@@@@@@@@@@@@@@@@@@@@@@\11VAA(@K''%&
VG%9[0@@@@@@@@@@@@@@@@@@@@@@@@@\D@< "18?K$1[^W%9[0@@@@@@@@@@@@@@@@@@@@@@@FT\\4%6P!!8?XTE9"W%9[0@@@@@@@@@@@@@@@@@@\11VAA*W
K''$RXC:U@G%9"W%9[0@@@@@@@@@@@@@@@@@\D@< "18?K$1^_"(&^W%9T7%9[0@@@@@@@@@@@@@@@FT\\4%6P!!8?XTE8M''!!8^EM8"RY:[0@@@@@@@@@@\11V
AA*WK''$RXH6U@G]8T7!!S&W\#AW $[0@@@@@@@@@\D@< "18?K$1^_''99]7!!8T9&Z&"M8N"P([0@@@@@@@FT\\4%6P!!8?XTE8T7]7]5NY"I*Z&S($W70)@@@@
\11VAA*WK''$RXH6U@G!!8"G^H&Y*YAY&Z&W%9X78@@@@\D@< "18?K$1^_''99^G!!7"I&Y&Y&YN)&Z&RY>% @@@FT\ED%6P!!8?XTE8T7!!8^H"Y"I&Y&Y*YW9$&
I)I:@@@\G@BWK''$RXH6U@G!!7"G^H&Y&Y&Y$:&Y*YB7)EI7,@@@]4@C<?K$1^_''99^G]7"I&Y&Y*ZN)$AR4-\WF1,[@@@EDX#K#<?XTE8T7!!8]8"Y"I&Z&UER
T#MTVPY=_W5=@@@Q@BD#K(6U@G!!8T7"H&Y*YTUIRL4)HGT "]YL,H&4@@@@@YG%9_''99^G!!8T9%U\WD1R 8NJ543L0$UEQTUEP@@@@A$YG!!9T7!!8]5NZE!!XV
M82DQHRD!!I@/EQTUEQTU@@@@@F!!$YG%9T7!!S&Y&Z@!!XJP4A)@34;F2=WEQTUEQT@@@@@[6!!$YG%8T7!!7&Y&Z& EPE *EIP5M!!(JB (JB  @@@@@@[6!!$YG!!8
T2L#&#:Y&)*T@U@VB(VEB@0LC@0L@@@@@@@@[6!!$YG$&NRZZ&)&ZZ#)[$PEN\V1,[F1,[F0@@@@@@@@@[6!!$YG(''V"RZ&)&AS3P8OIFXYT9NS$9NG0@@@@@@
@@@@[6!!$YG-;W7$&^$\)D282"''BN\(>O#7H?@@@@@@@@@@@@[6!!$YB!!<X"ZR^'',(Y25+ 3RG[#TYMX\@@@@@@@@@@@@@FF!!$YB$&$''(''I7-;Y2$*KR4-E8B@
KP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 167 167 167 157 157 157 146 82 44 155 155 155 208 208 207 234 154 84 147 147 147 138 66 36 234 130 84 70 70 68 190 190 189 146 66 4 86 70 44 250 198 172 131 131 131 129 129 129 127 127 127 123 123 123 174 174 173 119 119 119 254 130 4 46 46 44 166 166 165 107 107 107 154 154 153 99 99 99 186 94 36 83 83 83 250 218 204 77 77 77 126 126 125 71 71 71 248 248 248 254 202 188 246 246 246 244 244 244 82 70 52 242 242 242 240 240 240 238 238 238 236 236 236 234 234 234 250 194 164 254 206 148 232 232 232 226 226 226 230 106 52 222 222 222 246 182 140 218 218 218 246 178 140 216 216 216 214 214 214 212 212 212 134 106 76 208 208 208 206 206 206 202 202 202 150 94 52 198 198 198 150 86 52 194 194 194 192 192 192 118 82 60 11 11 11 186 186 186 98 82 60 214 142 108 184 184 184 5 5 5 182 182 182 250 214 196 3 3 3 250 210 196 122 66 44 176 176 176 102 66 44 174 174 174 170 170 170 90 86 12 166 166 166 186 114 100 213 213 212 250 190 156 158 158 158 156 156 156 242 110 36 152 152 152 246 198 132 203 203 202 148 148 148 102 34 4 246 186 132 146 146 146 197 197 196 140 140 140 138 138 138 191 191 190 187 187 186 132 132 132 126 126 126 124 124 124 171 171 170 116 116 116 130 74 44 167 167 166 163 163 162 2 2 4 254 222 172 155 155 154 100 100 100 143 143 142 84 84 84 137 137 136 255 255 255 74 74 74 254 174 132 70 70 70 247 247 247 245 245 245 243 243 243 241 241 241 239 239 239 237 237 237 254 170 92 235 235 235 233 233 233 231 231 231 229 229 229 178 82 4 221 221 221 210 138 108 94 74 60 122 82 28 215 215 215 213 213 213 211 211 211 209 209 209 201 201 201 186 126 84 195 195 195 193 193 193 191 191 191 210 106 68 187 187 187 185 185 185 254 190 124 183 183 183 4 4 4 181 181 181 2 2 2 179 179 179 104 216 0 0 144 0 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@> @@@O<@@@C? @@G?<@@A?? @@_?<@@??? @O??<@C??? G???<A???? _???8????>O????#????9????>_????''????9_???>G????!!??
??8_???>G???? ????8G???>@???? G???8@???>@G??? @@@@@b');
                            yourself);
                yourself
        ]
!

workspace32x32Icon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self workspace32x32Icon3 inspect
     ImageEditor openOnClass:self andSelector:#workspace32x32Icon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class workspace32x32Icon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:30;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A)/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F''!!8[0@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@Z^G!!8^F<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A(.^G!!8T7%/@@@@@@@@@@@@@@@@@@@@@@@@@@@@F''!!8"W!!S^G%9[0@@@@@@@@@@
@@@@@@@@@@@@@@@Z^G!!8^H$*I''%9^V<@@@@@@@@@@@@@@@@@@@@@@A(.^G!!8T7 6^G!!8T7!!/@@@@@@@@@@@@@@@@@@@@F''!!8"W!!S^G]8T7!!S&W\#[0@@@@@@
@@@@@@@@@@@^^G!!8^H%>^W]8^ENY&)(#^F<@@@@@@@@@@@@@@A8.^G!!8T7"I]7]7T9&H&)*YN"Q/@@@@@@@@@@@@G''!!8"W!!S^G!!8"G^H&Y*YAY&Z&W%9[0@@
@@@@@@@^^G!!8^H%>^W!!8]8"Y&Y&Y&S*Y&)$&_&<@@@@@@GX.^G!!8T7!!S^G!!8"I&H&Y&Y&)%_&RX&$''(@@@@@G''!!8"W!!S^G!!7"G^H&Y&Y&Y$:&Y*YB7)EI7,@
@@@^^G!!8^H%8^W!!7]8"Y&Y&Z&#*Y@T-KWE1,[F0@@A9$^G!!8T7!!S^G!!7"I&H&Y*YTUIRL5QYA''5=_W4@@A9$YG!!S^G!!8T7"H&Y*YTUIRL4)HGT "]YL,H&4@
@F=(YFQ>^W!!8^ENYUWE1LT(NC"-]L3LIEQTUEQT@@@A/ZFQ$^G!!7T9(VE!!X7#HQD!!HRD$B<UEQTUEQT@@@@@[6!!$YG!!S&Y&Z@!!XJP4A)@34;F2=WEQTUEQT@
@@@@@F=(YFQ8]9&Y&)(ATAXJ!!RTMSXZB (JB (H@@@@@@@A/ZFQ$H2NZO)&Z&)PATAXJ!!XTHC@0LC@0@@@@@@@@@[6!!$YBZZ&)&ZZ#)[$PEN\V1,[F1,[F0@
@@@@@@@@@F=(YFP$&)*Y T<4NC2Q&FUNS$9NS!!<@@@@@@@@@@@A/ZFQ$^RY:Q2$SK#JJ\H92#8>O\#<@@@@@@@@@@@@@[6!!$YBZR^'',(Y25+ 3RG[#TYMX\@
@@@@@@@@@@@@@F=(YFQ:I2];^6\)J"4-KQ^@ B4@');
                colorMapFromArray:#[ 0 0 0 167 167 167 157 157 157 146 82 44 155 155 155 208 208 207 234 154 84 147 147 147 138 66 36 234 130 84 70 70 68 190 190 189 146 66 4 86 70 44 250 198 172 131 131 131 129 129 129 127 127 127 123 123 123 174 174 173 119 119 119 254 130 4 46 46 44 166 166 165 107 107 107 154 154 153 99 99 99 186 94 36 83 83 83 250 218 204 77 77 77 126 126 125 71 71 71 248 248 248 254 202 188 246 246 246 244 244 244 82 70 52 242 242 242 240 240 240 238 238 238 236 236 236 234 234 234 250 194 164 254 206 148 232 232 232 226 226 226 230 106 52 222 222 222 246 182 140 218 218 218 246 178 140 216 216 216 214 214 214 212 212 212 134 106 76 208 208 208 206 206 206 202 202 202 150 94 52 198 198 198 150 86 52 194 194 194 192 192 192 118 82 60 11 11 11 186 186 186 98 82 60 214 142 108 184 184 184 5 5 5 182 182 182 250 214 196 3 3 3 250 210 196 122 66 44 176 176 176 102 66 44 174 174 174 170 170 170 90 86 12 166 166 166 186 114 100 213 213 212 250 190 156 158 158 158 156 156 156 242 110 36 152 152 152 246 198 132 203 203 202 148 148 148 102 34 4 246 186 132 146 146 146 197 197 196 140 140 140 138 138 138 191 191 190 187 187 186 132 132 132 126 126 126 124 124 124 171 171 170 116 116 116 130 74 44 167 167 166 163 163 162 2 2 4 254 222 172 155 155 154 100 100 100 143 143 142 84 84 84 137 137 136 255 255 255 74 74 74 254 174 132 70 70 70 247 247 247 245 245 245 243 243 243 241 241 241 239 239 239 237 237 237 254 170 92 235 235 235 233 233 233 231 231 231 229 229 229 178 82 4 221 221 221 210 138 108 94 74 60 122 82 28 215 215 215 213 213 213 211 211 211 209 209 209 201 201 201 186 126 84 195 195 195 193 193 193 191 191 191 210 106 68 187 187 187 185 185 185 254 190 124 183 183 183 4 4 4 181 181 181 2 2 2 179 179 179 104 216 0 0 144 0 ];
                mask:((ImageMask new)
                            width:30;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@0@@@@^@@@@O0@@@G>@@@C?0@@A?>@@@??0@@_?>@@O??0@G??>@C???0A???>@???? _???8O???>G????!!????8_???>C???? _???8C???>@_?
?? C???8@_??>@C??? @_??8@C??>@@a');
                            yourself);
                yourself
        ]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-tools-FileBrowser'!

addBufferIcon
    <resource: #programImage>

    "/ ^ self tabAdd16x16Icon
    ^ self addBuffer22x22Icon
    "/ ^ self addBuffer22x22Icon2
!

addTabIcon
    <resource: #programImage>

    ^ self addTab14x14Icon
!

changesBrowserIcon
    <resource: #programImage>

    ^ self changesBrowser18x22Icon
!

copyFileIcon
    <resource: #programImage>

    ^ self copyFile20x22Icon
!

copyIcon
    <resource: #programImage>

    ^ self copy20x22Icon
!

currentDirectoryIcon
    <resource: #programImage>

    ^ self currentDirectoryIcon26x26Icon
!

cutFileIcon
    <resource: #programImage>

    ^ self cutFile22x22Icon
!

deleteFileIcon
    <resource: #programImage>

    ^ self deleteFile17x22Icon
!

diffIcon
    <resource: #programImage>

    ^ self diff22x22Icon2
!

directoryBookmarksIcon
    <resource: #programImage>

    ^ self directoryBookmarks22x22Icon
!

directoryUpIcon
    <resource: #programImage>

    ^ self directoryUp22x24Icon2
!

dosShellTerminalIcon
    <resource: #programImage>

    ^ self dosShellTerminal22x22Icon
!

editFileIcon
    <resource: #programImage>

    ^ self edit17x22Icon
!

editIcon
    <resource: #programImage>

    ^ self edit17x22Icon
!

encodingLockIcon
    <resource: #programImage>

    ^ self padLockGold15x15Icon
!

fileContentsIcon
    <resource: #programImage>

    ^ self fileContents19x22Icon
!

fileImageContentsIcon
    <resource: #programImage>

    ^ self fileImageContents19x22Icon

    "Created: / 01-06-2010 / 17:35:07 / cg"
!

fileInIcon
    <resource: #programImage>

    ^ self fileIn18x22Icon
!

fitImageSizeToViewIcon
    <resource: #programImage>

    ^ self fitImageSizeToView22x22Icon
!

hexToggleIcon
    <resource: #programImage>

    ^ self hexToggle19x22Icon
!

historyBackIcon
    <resource: #programImage>

    ^ self leftArrow24x24Icon
!

historyForwardIcon
    <resource: #programImage>

    ^ self rightArrow24x24Icon
!

historyForwardInGlobalListIcon
    <resource: #programImage>

    ^ self right2Arrow24x24Icon

    "Created: / 02-07-2011 / 18:46:28 / cg"
!

historyIcon
    <resource: #programImage>

    ^ self history22x22Icon2
!

homeIcon
    <resource: #programImage>

    ^ self home24x24Icon
    "/ ^ self home26x26Icon
!

makeIcon
    <resource: #programImage>

    ^ self make26x26Icon
    "/ ^ self make22x22Icon
!

newDirectoryIcon
    <resource: #programImage>

    ^ self newDirectory22x22Icon2
!

newFileIcon
    <resource: #programImage>

    ^ self newFile20x22Icon

    "Created: / 31-03-2011 / 11:02:08 / cg"
!

pasteFileIcon
    <resource: #programImage>

    ^ self pasteFile22x22Icon
!

printerIcon
    <resource: #programImage>

    ^ self printer26x26Icon
!

reloadTextFromFileIcon
    <resource: #programImage>

    ^ self reload24x24Icon
!

removeTabEnteredIcon
    <resource: #programImage>

    ^ self removeTabEntered14x14Icon
!

removeTabIcon
    <resource: #programImage>

    ^ self removeTab14x14Icon
!

searchFileIcon
    <resource: #programImage>

    ^ self searchFile22x22Icon
!

searchIcon
    <resource: #programImage>

    ^ self search26x26Icon
!

stxHomeIcon
    <resource: #programImage>

    "/ ^ self stxHome26x26Icon
    ^ self stxHome24x24Icon
!

unixShellTerminalIcon
    <resource: #programImage>

    ^ self unixShellTerminal22x22Icon
!

viewDetailsIcon
    <resource: #programImage>

    ^ self viewDetails22x22Icon
!

viewNoDetailsIcon
    <resource: #programImage>

    ^ self viewNoDetails22x22Icon
! !

!XPToolbarIconLibrary class methodsFor:'image specs-tools-FileBrowser-Filetypes'!

fileTypeAddOnLinked
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeAddOnLinked inspect
     ImageEditor openOnClass:self andSelector:#fileTypeAddOnLinked
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeAddOnLinked'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@XFA XD0@@@@@@@@@@@@@@@@@XC1\WB@@@@@@@@@@@@@@@@@@XCA@W@0@@@@@@@@@@@@@@
@A LE0@P@0@@@@@@@@@@@@@@@A WC@LC@0@@@@@@@@@@@@@@@A FGPL@@@@@@@@@@@@@@@@@@A C@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[169 169 169 122 122 122 121 121 121 214 214 214 101 102 101 139 139 139 138 138 138 111 111 111 204 204 204 150 150 150 111 112 112 100 99 100 154 154 154 87 87 87 140 140 140 66 66 66 45 45 45 122 121 121 131 131 131 224 224 224 190 195 204 102 102 102 101 101 101 0 0 0 241 241 241 133 133 133 99 99 99 112 112 112 237 243 254 184 184 184]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?@@@?@@@?@@@?@@@?@@@?O @?O @?O @?_ @?_ @?^@@?\@@?@@@?@@@?@@@?@@@?') ; yourself); yourself]
!

fileTypeAddOnLocked
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeAddOnLocked inspect
     ImageEditor openOnClass:self andSelector:#fileTypeAddOnLocked
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeAddOnLocked'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@#H!!8"H0@@@@@@@@@@@@@@@BLJACXDB"L@@@@@@@@@@@@@@BHDQ$YFABH@@@@@@@@@@@@@@A86B@ HM!!8@@@@@@@@@@@@@@BHDQ$YFABH@
@@@@@@@@@@@@@BLJACXDB"L@@@@@@@@@@@@@@@@#H!!8"H0@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[163 195 216 173 203 221 147 163 174 180 207 223 245 117 117 132 176 205 116 131 143 144 161 172 255 255 255 143 183 209 249 207 207 119 126 130 141 160 171 144 183 209 170 200 218 152 189 212 118 146 161 173 202 220 170 200 219 137 149 157 127 137 142 168 200 224 133 179 205 128 169 196 121 122 123 98 128 148 131 139 144 129 171 196 113 124 132 159 189 211 250 250 250 153 190 212 177 205 223 171 171 171 220 220 220 176 176 176 176 205 223 203 203 203 171 200 219 136 148 158 122 123 123 112 139 156 182 208 224 216 216 216 162 195 216 119 133 144 132 139 144 175 175 175 176 205 222 120 150 168 120 126 131 224 226 227 120 121 122 174 204 220 239 29 29 0 0 0 167 192 209 171 200 220 161 189 206 178 205 223 214 214 214 123 133 140 95 131 153 124 124 124 174 203 222 124 146 160 218 218 218 143 143 143 114 125 132 120 150 169 238 16 17]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?@@@?@@@?@@@?@@@?@@@?@@@?@@@?@@@?@A<?@C>?@C>?@C>?@C>?@C>?@A<?@@@?') ; yourself); yourself]
!

fileTypeBinaryFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeBinaryFileIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeBinaryFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeBinaryFileIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKA@PDA@PKC08OC0@@@@@EA@,DB@\GB0<ODP<@@@@@@PP(N P(N PKB1LO@@@@@@<?N" :JC((
A@PKDP@@@@@QK3((N" :A@PDB1D@@@@@E#P(N2 (N" DA@\V@@@@@A\3NB (JB (A@PGE0@@@@@YL" :JB :JB0:K1$@@@@@HC (N#T:O3(DN$D @@@@@BD7
JC((N" :IS(2HP@@@@@!!NS :M#X:JAH:JBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 246 246 246 245 245 245 243 243 243 237 237 237 241 241 241 251 251 251 248 248 248 253 253 253 166 166 166 177 177 177 225 225 225 236 236 236 238 238 238 240 240 240 235 235 235 244 244 244]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeCSourceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeCSourceIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeCSourceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeCSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKC@4GC@4KC08OC0@@@@@ED@,DB@\GB0<ODP<@@@@@@PHPA@,HA0\KB1LO@@@@@@<@EAPTEAPT
EAPKDP@@@@@QD@PDLC@0LPPDB1D@@@@@E @TLCD)H3@1JP\V@@@@@A\XFC@1A@PDA@PGE0@@@@@YFAP0LR (JB0/AA$@@@@@HA8PLCD%IS@1JA@ @@@@@BD^
EB80LC@1IR PHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeDirectoryGrayIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryGrayIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryGrayIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeDirectoryGrayIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8C@1LLGP@@@B8.K"8.K"8.K L,KB0TE@\@@B8.K"8.K"8.
@1@B@ HB@!!@MB!!,QC!!T@K"8.D20,KB0,KB0,KB0,KBL@K"8.CC@5MST5MST5MST5LA\@K"8.FC@0LC@0LC@0LC@0L@X@K"8.E#@1LSD1LSD1LSD1LAH@K"8.
A3@4MCP4MCP4MCP4L@$@K"8.G#@/K2</K2</K2</L@,@K"8.CS@2L#H2L#H2L#H2LBD@K"8.B#@3L3L3L3L3L3L3L@<@K"8.@ADNER@\H!!(FD $KC0@@K"8.
@@@@@@@@@@@@@@@@@@@@K"8.@@@@@@@@@@@@@@@@@@@@K @.K"8.K"8.K"8.K"8.K"8.K"8.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@a') ; colorMapFromArray:#[251 251 251 239 239 239 219 183 82 204 153 52 228 228 228 193 193 193 163 113 11 194 143 42 183 183 183 158 108 6 186 135 34 156 106 4 201 150 49 189 138 37 179 129 27 153 103 1 219 183 113 181 130 29 160 110 8 203 152 51 255 255 186 176 126 24 197 146 45 167 117 15 199 148 47 166 166 166 165 115 13 183 132 31 171 121 19 200 149 48 192 141 40 198 198 198 174 124 22 154 104 2 168 118 16 172 122 20 255 212 111 255 248 147 235 235 235 255 255 156 255 219 117 255 228 127 255 239 137 182 182 182 255 255 255 255 255 153 0 0 0 191 171 95 191 191 115 191 186 110 191 164 88 191 159 83 191 179 103 191 191 117]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@O @@_0@@??0@??0@??0@??0@??0@??0@??0@??0@??0@_? @@@@@@@@@@@@@') ; yourself); yourself]
!

fileTypeDirectoryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeDirectoryIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8C@1LLGP@@@B8.K"8.K"8.K L,KB0TE@\@@B8.K"8.K"8.
@1@B@ HB@!!@MB!!,QC!!T@K"8.D20,KB0,KB0,KB0,KBL@K"8.CB4''I2\''I2\''I2\''KQ\@K"8.FB4-KR4-KR4-KR4-KPX@K"8.E"4%IRT%IRT%IRT%KQH@K"8.
A24*J"(*J"(*J"(*KP$@K"8.G"4)JR$)JR$)JR$)KP,@K"8.CR4(JB (JB (JB (KRD@K"8.B"4$IBP$IBP$IBP$KP<@K"8.@ADNER@\H!!(FD $KC0@@K"8.
@@@@@@@@@@@@@@@@@@@@K"8.@@@@@@@@@@@@@@@@@@@@K @.K"8.K"8.K"8.K"8.K"8.K"8.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@a') ; colorMapFromArray:#[251 251 251 239 239 239 219 183 82 204 153 52 228 228 228 193 193 193 163 113 11 194 143 42 183 183 183 158 108 6 186 135 34 156 106 4 201 150 49 189 138 37 179 129 27 153 103 1 219 183 113 181 130 29 160 110 8 203 152 51 255 255 186 176 126 24 197 146 45 167 117 15 199 148 47 166 166 166 165 115 13 183 132 31 171 121 19 200 149 48 192 141 40 198 198 198 174 124 22 154 104 2 168 118 16 172 122 20 255 212 111 255 248 147 235 235 235 255 255 156 255 219 117 255 228 127 255 239 137 182 182 182 255 255 255 255 255 153 0 0 0]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@O @@_0@@??0@??0@??0@??0@??0@??0@??0@??0@??0@_? @@@@@@@@@@@@@') ; yourself); yourself]
!

fileTypeDirectoryOpenGrayIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryOpenGrayIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryOpenGrayIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeDirectoryOpenGrayIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5@0LHBR @@@@5MST5MST5MSTCMCP4C@0V@@@5MST5MST5
MPL4L#H2L#H4DRXZFQ T@CT5MP 4L#H2L#H2L#P4MCP*@CT5MP$4LC@0LC@0LC@0LCHS@CT5LSD1LSD1LSD1LSD1HQ4''@CT5LTE@PDA@PDA@PDD:LRTG@CT5
LTE@O3<?O3<?O4@;LRLJ@CT5@CEAO#8>O#8>O#87H!!TK@CT5@CEAPC0<OC0<OC07NQHF@CT5@@@1PS4=OS4=OS4=N@<^@CT5MP@1@PDA@PD$E0\JB0X@@CT5
MST@@@@@@@@@@@@@@@@@@CT5MST@@@@@@@@@@@@@@@@@@CT5MST5MST5MST5MST5MST5MST5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@a') ; colorMapFromArray:#[239 239 239 165 115 13 251 251 251 204 153 52 193 193 193 228 228 228 154 104 2 160 110 8 203 152 51 201 150 49 158 108 6 156 106 4 250 251 252 183 183 183 255 255 165 198 154 26 240 228 122 189 138 37 207 162 38 167 117 15 176 126 24 226 179 67 194 143 42 162 112 10 179 129 27 181 130 29 183 132 31 215 184 64 218 191 108 255 235 132 153 103 1 247 240 137 166 166 166 226 193 80 201 160 33 253 213 112 164 114 12 255 215 132 186 135 34 163 113 11 200 149 48 198 198 198 172 122 20 255 228 127 255 219 117 255 239 137 235 235 235 182 182 182 255 248 147 198 154 25 255 255 156 255 255 153 255 255 255 0 0 0 119 119 119 210 210 0 163 148 18 115 97 24 130 106 33 180 169 12 191 151 0 186 137 0 196 169 0 201 188 0 205 205 0 204 204 0]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@G0@@O8@@_?8@_?8@_?8@??8@??8@??8@_?8@_?8@O?8@O?0@@@@@@@@@@@@@') ; yourself); yourself]
!

fileTypeDirectoryOpenIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryOpenIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryOpenIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeDirectoryOpenIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5@0LHBR @@@@5MST5MST5MSTCMCP4C@0V@@@5MST5MST5
MPL4L#H2L#H4DRXZFQ T@CT5MP 4L#H2L#H2L#P4MCP*@CT5MP$4LC@0LC@0LC@0LCHS@CT5LSD1LSD1LSD1LSD1HQ4''@CT5LSL2L#H2L#H2L#L\LRTG@CT5
LSL2LC@0LC@0LCH_LRLJ@CT5@CD3KR4-KR4-KR4NH!!TK@CT5@CD3L",+J2,+J2,NF1HF@CT5@@@1L20,KB0,KB0,D@<^@CT5MP@1@PDA@PD$E0\JB0X@@CT5
MST@@@@@@@@@@@@@@@@@@CT5MST@@@@@@@@@@@@@@@@@@CT5MST5MST5MST5MST5MST5MST5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@a') ; colorMapFromArray:#[239 239 239 165 115 13 251 251 251 204 153 52 193 193 193 228 228 228 154 104 2 160 110 8 203 152 51 201 150 49 158 108 6 156 106 4 250 251 252 183 183 183 255 255 165 198 154 26 240 228 122 189 138 37 207 162 38 167 117 15 176 126 24 226 179 67 194 143 42 162 112 10 179 129 27 181 130 29 183 132 31 215 184 64 218 191 108 255 235 132 153 103 1 247 240 137 166 166 166 226 193 80 201 160 33 253 213 112 164 114 12 255 215 132 186 135 34 163 113 11 200 149 48 198 198 198 172 122 20 255 228 127 255 219 117 255 239 137 235 235 235 182 182 182 255 248 147 198 154 25 255 255 156 255 255 153 255 255 255 0 0 0]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@G0@@O8@@_?8@_?8@_?8@??8@??8@??8@_?8@_?8@O?8@O?0@@@@@@@@@@@@@') ; yourself); yourself]
!

fileTypeFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeFileIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeFileIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKA@PDA@PKC08OC0@@@@@EA@PDA@\GB0<ODP<@@@@@@PPDA@PHA0\KB0PO@@@@@@<@A@PDA@PD
A@PKDP@@@@@QD@PDA@PKB@PGB1D@@@@@E @DA@PDA@PDA@\V@@@@@A\XFA@DA@PXB0PGE0@@@@@YA@PDA@PDA@PDAA$@@@@@HA8PDA@PDA@PDA@ @@@@@BD^
A@PDA@PDA@PPHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeHeaderFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeHeaderFileIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeHeaderFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeHeaderFileIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKC@4GC@4KC08OC0@@@@@ED@,;OCH3I3$ODP<@@@@@@PHPN307M"$*B1LO@@@@@@<@EC,<K3P4
N!!PKDP@@@@@QD@P;N3,;OB(DB1D@@@@@E @TN30)H3,<JP\V@@@@@A\XFC,<I"P;O@PGE0@@@@@YFAP;OB (N30/AA$@@@@@HA8PN30%IS,<JA@ @@@@@BD^
EC,<MS ;OB PHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 230 230 230 241 241 241 232 232 232 238 238 238 240 240 240 251 251 251 173 173 173 236 236 236 120 4 4 183 90 90]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeImageFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeImageFileIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeImageFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeImageFileIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@EQTUEQTUEQTUEQTUEQTUEQTRD!!HRD!!HRD!!HRD!!HRD!!TUD!!VU%YVU%YVU%YVU%YHUEQHU%YVU%YVU%YVU%YVREQTREYVU%YVVE!!X
VEYVU$!!TUD!!VU%YVVE!!XVE!!XU%YHUEQHU%YVU%YXVE!!XU%YVREQTREYVU%YVU%UVU%YVU$!!TUD!!VU%YVU%YUU%YVU%YHUEQHU5]VU5]WUU]WU%YVREQTRE]W
U5]WU5]WU5]WU4!!TUD!!WU5]WU5]WU5]WU5]HUEQHRD!!HRD!!HRD!!HRD!!HREQTUEQTUEQTUEQTUEQTUEQT@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 230 230 230 241 241 241 232 232 232 238 238 238 240 240 240 251 251 251 173 173 173 236 236 236 120 4 4 183 90 90 248 248 248 219 219 219 234 234 234 253 253 253 243 243 243 225 225 225 55 146 70 0 91 12 244 244 244 229 229 229 222 222 222 246 246 246 227 227 227 208 208 208 190 190 190 209 209 209 189 189 189 149 149 149 85 85 85 85 149 149 90 140 200 149 149 85 165 165 85 149 153 157 133 62 38 173 216 230 0 139 0 0 205 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@C?????????????????????????????????????@@@b') ; yourself); yourself]
!

fileTypeJavaScriptSourceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeJavaScriptSourceIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeJavaScriptSourceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeJavaScriptSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKB04GB04KC08OC0@@@@@ED@,KB3H3I3$ODP<@@@@@@S=AK4QCN ,SB1LO@@@@@@<+MRP>J!!QC
P4LGDP@@@@@QJ"X)QDMCQDMDA1D@@@@@E" >I$QCP4P)A0\V@@@@@A\%IR!!DP0QDQ@\GE0@@@@@YNC %QDL/ADMDA1$@@@@@HDQCMTQCQDMCQ@\ @@@@@BE@
QDQCMTQDQA@PHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 230 230 230 241 241 241 232 232 232 238 238 238 240 240 240 251 251 251 173 173 173 236 236 236 120 4 4 183 90 90 248 248 248 219 219 219 234 234 234 253 253 253 243 243 243 225 225 225 55 146 70 0 91 12]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeJavaSourceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeJavaSourceIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeJavaSourceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeJavaSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKB04GB04KC08OC0@@@@@ED@,KB3H3I3$ODP<@@@@@@PIEO4D/QDL:B1LO@@@@@@<@JR,5IC8*
J!!PKDP@@@@@QDB4*I"%DP4HDB1D@@@@@E @(JC8&QDL-JP\V@@@@@A\XL2T%JDQCK@PGE0@@@@@YFB<8NBUDP2 /AA$@@@@@HA8=QDL5QDL%JA@ @@@@@BD^
PDADQDL5JR PHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 230 230 230 241 241 241 232 232 232 238 238 238 240 240 240 251 251 251 173 173 173 236 236 236 120 4 4 183 90 90 248 248 248 219 219 219 234 234 234 253 253 253 243 243 243 225 225 225 55 146 70 0 91 12 244 244 244]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeLispSourceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeLispSourceIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeLispSourceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeLispSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKB04GB04KC08OC0@@@@@ED@,KB3H3I3$ODP<@@@@@@PIEO4D/K2<:B1LO@@@@@@<@LCD/MCP:
Q!!PKDP@@@@@QDB,0LSP4J"LDB1D@@@@@E @4MC@1MCP)JP\V@@@@@A\XMCP&LCD-I0PGE0@@@@@YFCP4LCD0LR</AA$@@@@@HA84LCD%MC@1JA@ @@@@@BD^
MC@1MCP0LR PHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 230 230 230 241 241 241 232 232 232 238 238 238 240 240 240 251 251 251 173 173 173 236 236 236 120 4 4 183 90 90 248 248 248 219 219 219 234 234 234 253 253 253 243 243 243 225 225 225 55 146 70 0 91 12 244 244 244 229 229 229]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeSmalltalkSourceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeSmalltalkSourceIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeSmalltalkSourceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeSmalltalkSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKB04GB04KC08OC0@@@@@ED@,KB3H3I3$ODP<@@@@@@PICQDQGQDQDQALO@@@@@@<@QDMCQC9D
P4LKDP@@@@@QDDQCI#L>QDL)B1D@@@@@E ACQC8&L4QCI0\V@@@@@A\XL4MDJCMDP2<GE0@@@@@YFB<8P4P3QDL(AA$@@@@@HA9DP4MDL4QCJA@ @@@@@BD^
P4QDP3MDP2,PHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 230 230 230 241 241 241 232 232 232 238 238 238 240 240 240 251 251 251 173 173 173 236 236 236 120 4 4 183 90 90 248 248 248 219 219 219 234 234 234 253 253 253 243 243 243 225 225 225 55 146 70 0 91 12 244 244 244 229 229 229 222 222 222]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

fileTypeTextHtmlIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeTextHtmlIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeTextHtmlIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary class fileTypeTextHtmlIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKB04GB04KC08OC0@@@@@ED@,KB3H3I3$ODP<@@@@@@S()UUUUUUUUR44O@@@@@@<7U5]TVEUU
VE!!JDP@@@@@QVE!!XUE!!UUEQXI!!D@@@@@E%!!XVE]UUUQTVE V@@@@@A]UUEQTUUUXUEUXE0@@@@@YUUQTVEUUVE!!TUQ$@@@@@HEUTUEUUUE!!XUET @@@@@BEU
UUQUUUQTVEQUHP@@@@@!!PEUUUUUUUUQVJBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140 217 217 217 228 228 228 250 250 250 221 221 221 214 214 214 249 249 249 233 233 233 224 224 224 226 226 226 247 247 247 218 218 218 220 220 220 242 242 242 15 15 116 93 93 178 237 237 237 230 230 230 241 241 241 232 232 232 238 238 238 240 240 240 251 251 251 173 173 173 236 236 236 120 4 4 183 90 90 248 248 248 219 219 219 234 234 234 253 253 253 243 243 243 225 225 225 55 146 70 0 91 12 244 244 244 229 229 229 222 222 222 246 246 246 227 227 227 208 208 208 190 190 190 209 209 209 189 189 189 149 149 149 85 85 85 85 149 149 90 140 200 149 149 85 165 165 85 160 160 0 10 110 230 0 128 128 128 128 128 128 128 0]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'O?@?>C?<O?0''9B?4O?P??C?<O?0??C?<K?P??@@@@@@b'); yourself); yourself]
!

fileTypeTextIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeTextIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeTextIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary fileTypeTextIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@PDA@PDA@PDC@@@@@@@@@PPDA@PDA@ OBP(@@@@@@@LKC@4GC@4KC08OC0@@@@@ED@,DB@\GB0<ODP<@@@@@@PHPA@,HA0\KB1LO@@@@@@<@EAPTEAPT
EAPKDP@@@@@QD@PDA@PKB@PGB1D@@@@@E @TEAPTEAPTE@\V@@@@@A\XFA@DA@PXB0 GE0@@@@@YFAPTEAPTEAPTAA$@@@@@HA8PDA@PDA@PDA@ @@@@@BD^
EAPTEAPTEAPPHP@@@@@!!G!!H^G1HRD!!HRDBD@@@@@H"H"H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 192 192 190 248 248 250 204 202 200 252 250 250 196 198 200 224 226 230 255 254 250 252 254 250 216 216 220 188 188 190 252 252 250 228 230 230 240 242 240 200 214 220 188 190 190 248 250 250 188 186 190 244 244 240 232 230 230 224 224 220 0 0 0 184 186 190 184 184 180 248 246 250 180 182 180 180 180 180 244 244 250 176 178 180 172 174 170 244 242 240 248 246 240 172 172 170 156 158 160 144 144 140]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?@?>C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
! !

!XPToolbarIconLibrary class methodsFor:'image specs-tools-ImageEditor'!

loadImageFromFileIcon
    <resource: #programImage>

    ^ self loadImageFromFile22x22Icon
!

loadImageFromMethodIcon
    <resource: #programImage>

    ^ self loadFromMethod22x22Icon2
    "/ ^ self loadImageFromMethod22x22Icon
!

newImageIcon
    <resource: #programImage>

    ^ self newImage22x22Icon
!

saveImageAsMethodAsIcon
    <resource: #programImage>

    ^ self saveAsMethodAs22x22Icon2
    "/ ^ self saveImageAsMethod22x22Icon
!

saveImageAsMethodIcon
    <resource: #programImage>

    ^ self saveAsMethod19x22Icon2
    "/ ^ self saveImageAsMethod22x22Icon
! !

!XPToolbarIconLibrary class methodsFor:'image specs-tools-Launcher'!

browseClassExtensionsIcon
    <resource: #programImage>

    ^ self browseClassExtensions24x24Icon
!

displayScreenIcon
    <resource: #programImage>

    ^ self displayScreen22x27Icon
!

imageEditorIcon
    <resource:#programImage>
    ^ self imageEditor22x22Icon3

    "Created: / 31-03-2011 / 11:07:05 / cg"
!

saveImageIcon
    <resource: #programImage>

    "/ ^ self saveImage22x22Icon
    ^ self fileSave19x19Icon
!

startChangesBrowserIcon
    <resource: #programImage>

    "/ ^ self changesBrowser22x22Icon
    ^ self changesBrowser24x24Icon2
!

startFileBrowserIcon
    <resource: #programImage>

    ^ self fileBrowser22x22Icon2
    "/ ^ self fileBrowser26x24Icon
    "/ ^ self fileBrowser24x24Icon
    "/ ^ self fileBrowser32x32Icon
!

startImageEditorIcon
    <resource: #programImage>

    ^ self imageEditor19x26Icon
!

startMenuEditorIcon
    <resource: #programImage>

    ^ self menuEditor19x26Icon
!

startNewFileBrowserIcon
    <resource: #programImage>

    ^ self fileBrowser22x22Icon2
    "/ ^ self fileBrowser26x24Icon
    "/ ^ self fileBrowser24x24Icon
    "/ ^ self fileBrowser32x32Icon
!

startNewSystemBrowserIcon
    <resource: #programImage>

    ^ self systemBrowser24x24Icon2
!

startSystemBrowserIcon
    <resource: #programImage>

    ^ self systemBrowser24x24Icon2
!

startUIPainterIcon
    <resource: #programImage>

    ^ self uiPainter19x26Icon
!

startWorkspaceIcon
    <resource: #programImage>

    "/ ^ self workspace32x32Icon2
    "/ ^ self workspace32x32Icon3
    ^ self workspace24x24Icon2
!

stxHelpIcon
    <resource: #programImage>

    ^ self helpIcon2
    "/ ^ self help32x32Icon
!

systemBrowserIcon
    <resource: #programImage>

    ^ self systemBrowser24x24Icon2

    "Created: / 08-08-2011 / 08:26:37 / cg"
! !

!XPToolbarIconLibrary class methodsFor:'image specs-tools-MenuEditor'!

copyMenuItemIcon
    <resource: #programImage>

    ^ self copyItem20x22Icon
!

cutMenuItemIcon
    <resource: #programImage>

    ^ self cutItem22x22Icon
!

newMenuIcon
    <resource: #programImage>

    ^ self newMenu26x26Icon
!

pasteMenuItemIcon
    <resource: #programImage>

    ^ self pasteItem22x22Icon
! !

!XPToolbarIconLibrary class methodsFor:'image specs-tools-UIPainter'!

copyWidgetIcon
    <resource: #programImage>

    ^ self copyWidget20x22Icon2
!

cutWidgetIcon
    <resource: #programImage>

    ^ self cutWidget22x22Icon2
!

pasteWidgetIcon
    <resource: #programImage>

    ^ self pasteWidget22x22Icon
! !

!XPToolbarIconLibrary class methodsFor:'image specs-tools-misc'!

fileOpenIcon
    <resource: #programImage>

    ^ self fileOpen22x22Icon
!

loadFromFileIcon
    <resource: #programImage>

    ^ self loadFromFile22x22Icon
!

loadFromMethodIcon
    <resource: #programImage>

    ^ self loadFromMethod22x22Icon2
    "/ ^ self loadImageFromMethod22x22Icon
!

newRowIcon
    <resource: #programImage>

    ^ self newItem22x22Icon
!

redoIcon
    <resource: #programImage>

    ^ self redoXP24x24Icon
!

removeRowIcon
    <resource: #programImage>

    ^ self cutItem22x22Icon
!

saveAsMethodAsIcon
    <resource: #programImage>

    ^ self saveAsMethodAs22x22Icon2
    "/ ^ self saveImageAsMethod22x22Icon
!

saveAsMethodIcon
    <resource: #programImage>

    ^ self saveAsMethod19x22Icon2
    "/ ^ self saveImageAsMethod22x22Icon
!

saveTextToFileIcon
    <resource: #programImage>

    ^ self fileSave19x19Icon
!

saveToFileAsIcon
    <resource: #programImage>

    ^ self fileSaveAs22x19Icon
!

saveToFileIcon
    <resource: #programImage>

    ^ self fileSave19x19Icon
!

undoIcon
    <resource: #programImage>

    ^ self undoXP24x24Icon
! !

!XPToolbarIconLibrary class methodsFor:'image specs-window icons'!

newFileBrowserIcon
    <resource: #programImage>

    ^ self fileBrowser22x22Icon
    "/ ^ self fileBrowser26x24Icon
    "/ ^ self fileBrowser24x24Icon
    "/ ^ self fileBrowser32x32Icon
! !

!XPToolbarIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

