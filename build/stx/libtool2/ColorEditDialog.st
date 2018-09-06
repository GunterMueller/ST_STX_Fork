"
 COPYRIGHT (c) 1995 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

SimpleDialog subclass:#ColorEditDialog
	instanceVariableNames:'red green blue hue light saturation colorNameHolder
		htmlColorNameHolder colorDefinitionStringHolder previewBox
		brightnessStringHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-UIPainter'
!

!ColorEditDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by eXept Software AG
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
    An edit-dialog for colors.
"
!

examples
"
                                                                                [exBegin]                                      
    |editor color|

    editor := ColorEditDialog new.
    editor color:(Color green).
    editor open.
    editor accepted ifTrue:[
        editor color inspect.
    ]
                                                                                [exEnd]
"
! !

!ColorEditDialog class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ColorEditDialog    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#pickColor
'Pick a Color from the Screen'

)
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ColorEditDialog    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#brightness
'The Color''s brightness value (0..1)'

#colorDefinitionString
'A Smalltalk expression to construct the color'

#colorName
'The standard colorname (as used in the X-Window System), if known'

#copyToClipboard
'Copy the color to the clipboard'

#hlsMixer
'Mix color from hls (hue-light-saturation) components'

#htmlColorName
'The color as used in an HTML page'

#pasteFromClipboard
'Paste color from the Clipboard'

#rgbMixer
'Mix color from rgb (red-green-blue) components'

)

    "Modified: / 09-08-2012 / 09:35:29 / cg"
! !

!ColorEditDialog class methodsFor:'image specs'!

hueGradientImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self hueGradientImage inspect
     ImageEditor openOnClass:self andSelector:#hueGradientImage
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'ColorEditDialog hueGradientImage'
        ifAbsentPut:[(Depth8Image new) width:400; height:50; bits:(ByteArray fromPackedString:'
J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE
''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9
^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3
+;F/+1 XFA"R$+"8.K!!&''"N^''''@I\@%WVU$TEAPA(:N#"(*J"(X_G1-,[F0UEQUOS6]OR;]K\WM1\R8.K"9>_''9>_''9>''Y46''Y6]M#Z************4-KR4
-KR4-B,+J2,+J2,+J0-LS@-LSD1APTEAPTEAPTFK"8.K"8.K"5YVU")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)
Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.GV8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0
LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL
#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''
Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LE$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4
''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR
_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.
+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,[F1[V5-[Z&)
Y&Y&Y&X#H2L#BP$IBU%YVPDA@PE;^7,8NC 8G1<_F1,[F1\WE6]''Y6^7-;]3\7M3[6=/[0HB@ HB@ H6M#Z]''Y46M************+R4-KR4-KR4J2,+J2,+
J2,+B41LB41LSAYAPTEAPTDVPX.K"8.K"8.KU%X*J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (D9N$I@)ZV%+Z9^WGA8^RT$"
H(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):
^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LC
Z&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.
K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@,KB0,VPQXVPQXVE!!ZKHB@ HB@ HB(*J")VU(HFA  HMCR_]7^9.;-ST4A@
%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAPTEAY2\''I26-+XRD!!I?_7=?F!!(Z!!8^G
!!8\7M0=PTE@@@@@@VE!!XVI.[&9-5]WVO#8>O#3@0LC@0LC@0^''):^''):^''*E!!XVE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%
QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+:<XFA X$)J8.K"8Y)8#'')90
BW@IU5%YEAPT@ZN#(8*J"(*FG1<[[F1,EQTUS4=''S4.7R7E3\WD.K"8._''9>_''9>_)6]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1L
E$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7Z"("\''/K0?O2%)ZTQ+Q4\J-[T$IAD"$YD;N36(P(RD
!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE
!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0L
W%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&).FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6
''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB0,KB1YAE!!YAE!!XVE(, HB@ HB@ J"(*J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"
N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<
@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:
.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA
(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK
"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]*J"I2^</C<?JV%)QF-GQ0*5-RP$DRJQ$S,;OZ!!B!!HRD,%1\, 9 XF@P
TZ^T%IR''KR4EKTYFQ$Y4]GP%IRU?ZF!!(*1*+!!5-[V5.I"P<OC5A<_@A<KB0,KI&Y&Y.H"H"OST6OSS@YFQ$0FQ$YNS$9NS%:^'')CP4MCP8VE#(8<OC2N#"</
K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HAT
UJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6****
********-KR4-KR4-KP+J2,+J2,+J2,KSD0KB0,KE$DVE$DVE!!XV"2@ HB@ HB@*J"(*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5
MZB S$:P$B%)ZV-+%9\\G!!9IRRH"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[
]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF-
 XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&).FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_
F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB0,KB1YAE!!YAE!!XVE(, HB@ HB@ J"(*
J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WE22C&A XAAQ)9RT%J\-KPT-
Q$YFQ''Q4]BT%IW=(ZF"+F*.GV5-[V8&IC0<OTG1<@G0,KB0,&Y&Y&8"H"H=MSX=MLA$YFS@YFQ$9NS$9NW):^$MCP4MC!!XVN##0<OH:NK2</K2</K2=9^W%9
^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3
+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4
-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)
Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.GV8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0
LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL
#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''
Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KB0,KE$DVE$DVE!!XV"2@ HB@ HB@*J"(*U%ZBA XHBCP4
''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB S$:P$B%)ZV-+%9\\G!!9IRRH"#X4;N36(P(RD!!KI\WKHNXFA DEF''%IRT)24-AR5FQ$YF]GQ4IRT%
_6!!(ZJ,Z*8][V5-["X$OC0=P_G0@_B0,KB2Y&Y&["H"H#45M#440FQ$YLA$YFS$9NS$9^''):P4MCP4NE!!X:NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.
+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&)
.FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+
J2,+B41LB41LSDEAPTEAPTEAPX.K"8.K"8.KU%YVJ%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (D9N$I@)ZV%+Z9^WGA8^RT$"
H(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):
^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LC
Z&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F1,V5-[V6)*VY&Y&Y&H2L#H0$IBP%YVU$A@PDA^7-;NC 8NA<_G1,[F1,WE1]''Y6]''-;^7\7M3\6=/
[6<B@ HB@ HBM#X6''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@-LSD1APTEAPTEAPTFK"8.K"8.K"5YVU")VU(HFA  HMCR_]7^9.;-ST4A@
%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JANS)BPJV%)Z6.W%10^G$%IH"JM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.G
V8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%
QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0
BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1L
E$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD
!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE
!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0L
W%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&).FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6
''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB0,KB1YAE!!YAE!!XVE(, HB@ HB@ J"(*J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"
N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<
@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:
.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA
(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@,KB0,VPQXVPQXVE!!ZK
HB@ HB@ HB(*J")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]*J"I2^</C<?JV%)QF-GQ0*5-RP$DRJQ$S,;OZ!!B!!HRD,%22, 8NC 9Q
TYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.GV8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</
K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HAT
UJZ&)FM#XVF3,:>1,[E-[V5-*Z%&Y&Y&Y"L#H2LIBP$IVU%Y@PDA@W-;^3 8NC _G1<[F1,[E1\WY6]''Y;^7-7M3\7M/[6=/@ HB@ HB@#X6M)6]''SX6****
********-KR4-KR4-KP+J2,+J2,+J2,KSD0KB0,KE$DVE$DVE!!XV"2@ HB@ HB@*J"(*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5
MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@TEAPV\''I2\-+Z6D!!HR_7=?_1(ZF(^G!!8^GM3\OTEAP@@@@@E!!XVE"[&9.[
]WU5#8>O#8<0LC@0LC@0LG):^''):^''):!!XVE!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF-
 XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,[F1[V5-[Z&)Y&Y&Y&X#H2L#BP$IBU%YVPDA@PE;^7,8NC 8G1<_
F1,[F1\WE6]''Y6^7-;]3\7M3[6=/[0HB@ HB@ H6M#Z]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB41LSAYAPTEAPTDVPX.K"8.K"8.KU%X*
J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WE22C&A XAAQ)9RT%J\-APT-
Q$YFQ''Q4-"T%IW=?_6"+F*.G!!5.GV8$7C5APT@@@@G0,VB0,&Y&[&8"H"H=MSX=MLA$YFS@YFQ$9^#$9NW):^$NE!!TMC!!XVN##0<OH:NK2</K2</K2=9^W%9
^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3
+;F1,V5-[V6)*VY&Y&Y&H2L#H0$IBP%YVU$A@PDA^7-;NC 8NA<_G1,[F1,WE1]''Y6]''-;^7\7M3\6=/[6<B@ HB@ HBM#X6''Y6]M#Z************4-KR4
-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)
Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAPTEAY2\''I26-+XRD!!I?_7=?F!!(Z!!8^G!!8\7M0=PTE@@@@@@VE!!XVI.[&9-5]WVO#8>O#3@0
LC@0LC@0^''):^''):^''*E!!XVE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL
#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1,[E-[V5-*Z%&Y&Y&Y"L#H2LIBP$IVU%Y@PDA@W-;^3 8NC _G1<[F1,[E1\WY6]''
Y;^7-7M3\7M/[6=/@ HB@ HB@#X6M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LE$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4
''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB S$:P$B%)ZV-+%9\\G!!9IRRH"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@TEAPV\''I2\-+Z6D!!HR
_7=?_1(ZF(^G!!8^GM3\OTEAP@@@@@E!!XVE"[&9.[]WU5#8>O#8<0LC@0LC@0LG):^''):^''):!!XVE!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.
+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&)
.FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+
J2,+B41LB41LSAYAPTEAPTDVPX.K"8.K"8.KU%X*J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$Q
H(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):
^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LC
Z&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F1,V5-[V6)*VY&Y&Y&H2L#H0$IBP%YVU$A@PDA^7-;NC 8NA<_G1,[F1,WE1]''Y6]''-;^7\7M3\6=/
[6<B@ HB@ HBM#X6''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@,KB0,VPQXVPQXVE!!ZKHB@ HB@ HB(*J")VU(HFA  HMCR_]7^9.;-ST4A@
%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JANS)BPJV%)Z6.W%10^G$%IH"JM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.G
V8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%
QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+:<XFA X$)J8.K"8Y)8#'')90
BW@IU5%YEAPT@ZN#(8*J"(*FG1<[[F1,EQTUS4=''S4.7R7E3\WD.K"8._''9>_''9>_)6]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KB0,K
E$DVE$DVE!!XV"2@ HB@ HB@*J"(*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD
!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE
!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0L
W%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&).FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6
''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB0,KB1YAE!!YAE!!XVE(, HB@ HB@ J"(*J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"
N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEAPTE''I2\''KZ6-!!HRD''=?_7<ZF!!*G!!8^G!!3\7C5APT@@@
@@AXVE!!X&9.[&7U5]X>O#8>OLC@0LC@0LCA:^''):^''):^(VE!!XVE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:
.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F1,V5-[V6)*VY&Y&Y&H2L#H0$IBP%YVU$A@PDA
^7-;NC 8NA<_G1,[F1,WE1]''Y6]''-;^7\7M3\6=/[6<B@ HB@ HBM#X6''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK
"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JANS)BPJV%)Z6.W%10^G$%IH"JM#S,;OZ!!B!!HRD,%22, 8NC 9Q
TYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.GV8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</
K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HAT
UJZ&)FM#XVF3,:>1+:<XFA X$)J8.K"8Y)8#'')90BW@IU5%YEAPT@ZN#(8*J"(*FG1<[[F1,EQTUS4=''S4.7R7E3\WD.K"8._''9>_''9>_)6]M)6]''SX6****
********-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LE$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5
MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[
]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF-
 XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>/FA XFIJR.K"8.FZ^H9:^\@%0BU]YVQPTE@F#(:NJ"(*J!!!!<_
F61,[ATUET=OY4=K-4-1\7E1K"8.K''9>_''9>_'':]''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB41LSAYAPTEAPTDVPX.K"8.K"8.KU%X*
J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WE22C&A XAAQ)9RT%J\-KPT-
Q$YFQ''Q4]BT%IW=(ZF"+F*.GV5-[V8&IC0<OTG1<@G0,KB0,&Y&Y&8"H"H=MSX=MLA$YFS@YFQ$9NS$9NW):^$MCP4MC!!XVN##0<OH:NK2</K2</K2=9^W%9
^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3
+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4
-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JANS)BPJV%)
Z6.W%10^G$%IH"JM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.GV8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0
LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL
#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''
Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LE$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4
''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB S$:P$B%)ZV-+%9\\G!!9IRRH"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR
_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.
+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&)
.FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+
J2,+B41LB41LSDEAPTEAPTEAPX.K"8.K"8.KU%YVJ%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (D9N$I@)ZV%+Z9^WGA8^RT$"
H(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEAPTE''I2\''KZ6-!!HRD''=?_7<ZF!!*G!!8^G!!3\7C5APT@@@@@AXVE!!X&9.[&7U5]X>O#8>OLC@0LC@0LCA:^''):
^''):^(VE!!XVE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LC
Z&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.
K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@
%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.G
V8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%
QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0
BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1L
E$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB S$:P$B%)ZV-+%9\\G!!9IRRH"#X4;N36(P(RD
!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE
!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0L
W%82L%)Z+HB@UER&)*Q#X6E!!,;N/,[F1[V5-[Z&)Y&Y&Y&X#H2L#BP$IBU%YVPDA@PE;^7,8NC 8G1<_F1,[F1\WE6]''Y6^7-;]3\7M3[6=/[0HB@ HB@ H6
M#Z]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB41LSDEAPTEAPTEAPX.K"8.K"8.KU%YVJ%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"
N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<
@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:
.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/+1 XFA"R$+"8.K!!&''"N^''''@I\@%WVU$TEAPA
(:N#"(*J"(X_G1-,[F0UEQUOS6]OR;]K\WM1\R8.K"9>_''9>_''9>''Y46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK
"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JANS)BPJV%)Z6.W%10^G$%IH"JM#S,;OZ!!B!!HRD,%22, 8NC 9Q
TYRT%IRTAPTEAY2\''I26-+XRD!!I?_7=?F!!(Z!!8^G!!8\7M0=PTE@@@@@@VE!!XVI.[&9-5]WVO#8>O#3@0LC@0LC@0^''):^''):^''*E!!XVE!!XVEOH8<OC2N#"</
K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HAT
UJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6****
********-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LPTEAPTEAPTEA"8.K"8.K"8-VU%X*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5
MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[
]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF-
 XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>/FA XFIJR.K"8.FZ^H9:^\@%0BU]YVQPTE@F#(:NJ"(*J!!!!<_
F61,[ATUET=OY4=K-4-1\7E1K"8.K''9>_''9>_'':]''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB41LSAYAPTEAPTDVPX.K"8.K"8.KU%X*
J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$QH(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEAPTE
''I2\''KZ6-!!HRD''=?_7<ZF!!*G!!8^G!!3\7C5APT@@@@@AXVE!!X&9.[&7U5]X>O#8>OLC@0LC@0LCA:^''):^''):^(VE!!XVE!!XT<##0<OH:NK2</K2</K2=9^W%9
^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3
+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4
-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ%YVU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)
Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.GV8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0
LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL
#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1,[E-[V5-*Z%&Y&Y&Y"L#H2LIBP$IVU%Y@PDA@W-;^3 8NC _G1<[F1,[E1\WY6]''
Y;^7-7M3\7M/[6=/@ HB@ HB@#X6M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LE$EAPTEAPQYA"8.K"8.K"8-VU"(*U%ZBA XHBCP4
''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD!!KI\WKHNXFA DEF''%IRT)24-AR5FQ$YF]GQ4IRT%
_6!!(ZJ,Z*8][V5-["X$OC0=P_G0@_B0,KB2Y&Y&["H"H#45M#440FQ$YLA$YFS$9NS$9^''):P4MCP4NE!!X:NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.
+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&)
.FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+
J2,+B41LB0,KB1YAE!!YAE!!XVE(, HB@ HB@ J"(*J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$Q
H(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):
^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LC
Z&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.
K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ")VU(HFA  HMCR_]7^9.;-ST4A@
%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.G
V8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%
QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0
BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1L
E$EAPTEAPQYA"8.K"8.K"8-VU"(SU%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD
!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE
!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0L
W%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&).FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6
''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB41LSDEAPTEAPTEAPX.K"8.K"8.KU%YVD5YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"
N#*Z&#NCA0]6(*H''I;2<O3<)ZV%DZ4]GB+V5IBPQH)FQN3,=*DJD!!HR2WE22C&A XAAQ)9RT%J\-KPT-Q$YFQ''Q4]BT%IW=(ZF"+F*.GV5-[V8&IC0<OTG1<
@G0,KB0,&Y&Y&8"H"H=MSX=MLA$YFS@YFQ$9NS$9NW):^$MCP4MC!!XVN##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:
.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA
(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@,KB0,VPQXVPQXVE!!ZK
HB@ HB@ HB(*J!!MVU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9Q
TYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.GV8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</
K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HAT
UJZ&)FM#XVF3,:>1,[E-[V5-*Z%&Y&Y&Y"L#H2LIBP$IVU%Y@PDA@W-;^3 8NC _G1<[F1,[E1\WY6]''Y;^7-7M3\7M/[6=/@ HB@ HB@#X6M)6]''SX6****
********-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LPTEAPTEAPTEA"8.K"8.K"8-VU%X*U%ZBA XHBCP4''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5
MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD!!KI\,+HNC 8NTUFT%IRT%@T-APV\''I2\-+Y4D!!HR_6!!(_1(ZF(][!!5.GM8$OC0=P_G0@@E ,VE"[&9&[
]WU5#8>O#8<0LC@0LC@0LG(9^''):^''):!!TMC!!XVE!!S2NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF-
 XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&).FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_
F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+J2,+B41LB41LSAYAPTEAPTDVPX.K"8.K"8.KU%X*
J%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (D9N$I@)ZV%+Z9^WGA8^RT$"H(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEKPTE
''I2\''KZ6]AHRD''=(ZG<ZF!!*GV8][!!3^IC0<OTG1<@@AXKE!!X&9.Y&7U5]X>O#8>OLC@0LC@0LCA:NW):^''):^(UCP8VE!!XT<##0<OH:NK2</K2</K2=9^W%9
^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LCZ&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3
+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4
-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ%YVU(HFA  HMCR_]7^9.;-ST4A@%&9.,KAHRBD!!X#(:&)(3 0\G]#T5(JB<S)@?JV%)
Z6.WQ125G$%IDRJM#S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAPTEAY2\''I26-+XRD!!I?_7=?F!!(Z!!8^G!!8\7M0=PTE@@@@@@VE!!XVI.[&9-5]WVO#8>O#3@0
LC@0LC@0^''):^''):^''*E!!XVE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL
#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1,[E-[V5-*Z%&Y&Y&Y"L#H2LIBP$IVU%Y@PDA@W-;^3 8NC _G1<[F1,[E1\WY6]''
Y;^7-7M3\7M/[6=/@ HB@ HB@#X6M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KSD1LPTEAPTEAPTEA"8.K"8.K"8-VU%ZBU%ZBA XHBCP4
''7]7.[.;T5M@PIY.[+B0RD !!HVH:N)*ZL8LGA7X5MZB /D:PO2%)ZV-+%4\\-Q9IRQD"#X4;N36(P(RD!!KI\WKHNXFA DEF''%IRT)24EAR5FQ$YF]GR6IRT%
_7=?ZJ,Z*8^GV8]["S\OTEAP@@@@_B1XKB2Y&Y.["H"H#45M#440FQ$YLA$YFS%:NS$9^''):P8VEP4NE!!X:NOC0<#(8/K2</K2</K7%9^W%9^W%9+*:.+*:.
+&U%YVU%YVU%YTUEAIVU$9MRT+*:^G MW55]LSF- XEUUS8>)ZU$#H1JR''I2GQ6X@0M*Z''5=JB &(P0LW%82L%)Z+HB@UER&)*Q#X6E!!,;N/,Z>1FF5-FJ&)
.FY&Y&X#H98#\@$IBU%YVPDA@PF#(7,8NH(8G1<_F60[F1\WE6]''Y6^7-4-3\7M3[28.[0HB@ HB_ H6''SZ]''Y46M************+R4-KR4-KR4J2,+J2,+
J2,+B41LB0,KB1YAE!!YAE!!XVE(, HB@ HB@ J"(*A%YV  XFB@ 4MI=7];&;.5MSPDBV[&:0,D!!HHRE"N#*Z&#NCA0]6MSV (K1N$C<)ZV%+Z9]GGKT^RT$Q
H(6MN3,=*DJD!!HR2WKJ2C 8NC%EQ%IRT%IPEAPTE''I2\''KZ6-!!HRD''=?_7<ZF!!*G!!8^G!!3\7C5APT@@@@@AXVE!!X&9.[&7U5]X>O#8>OLC@0LC@0LCA:^''):
^''):^(VE!!XVE!!XT<##0<OH:NK2</K2</K2=9^W%9^W%9^Z:.+*:.+*9%YVU%YVU%YVUEQPRU%YNST%J:.''!!8CU=]WSD1+XFAUUT>O*V%YH2LR$)2\!!4]&@LC
Z&)=_R (I*DLCE9^L#IZV*2@ EQT)*Z$X6M!!X[N3+;F/,Q!!-[Q")*[!!&Y&Y&H2N^H7@IBP%YVU$A@PDA(:M;NC"JNA<_G1-,F1,WE1]''Y6]''-;]K\7M3\6<.
K&<B@ HB@''8BM)46''Y6]M#Z************4-KR4-KR4-B,+J2,+J2,+J0-LS@-LSD0VPTEAPTEAE$FK"8.K"8.K"5YVJ#QVU(HFA  HMCR_]7^9.;-ST4A@
%&9.,KAHRBD!!X#(:&)(3 0\G]*J"I2^</C<?JV%)QF-GQ0*5-RP$DRJQ$S,;OZ!!B!!HRD,%22, 8NC 9QTYRT%IRTAR4EAY2\''I26-''PRD!!I?ZF!!?F!!(Z!!5.G
V8\7"P<OC5A<_@@@VB1XVI.[&Y-5]WVO#8>O#3@0LC@0LC@0^#%:^''):^''*EP4NE!!XVEOH8<OC2N#"</K2</K2</^W%9^W%9^W&.+*:.+*:.YVU%YVU%YVU%
QTTD%YVS$5IR.+)8^@5_WU41LZ6A UUUO#:%)VRL#D)J\''H]GY C@6)*_W4(JBZ!!C@1^W#H2V%*, HATUJZ&)FM#XVF3,:>1+;DX[V4X*Z&8Y&Y&Y"L#''"M0
BP$IVU%Y@PDA@ZN#^3 8"# _G1<[[A,[E1\WY6]''Y;^7R7M3\7M/K"9/@ HB@ I>@#Z]M)6]''SX6************-KR4-KR4-KP+J2,+J2,+J2,KSD0KB0,K
E$DVE$DVE!!XV"2@ HB@ HB@*J"(b') ; colorMapFromArray:#[108 168 80 124 90 170 164 90 170 92 122 170 92 164 170 144 168 80 164 96 90 168 132 80 164 98 90 116 90 170 164 152 80 164 90 120 92 110 170 92 152 170 156 168 80 112 166 80 152 166 80 164 158 80 132 168 80 164 88 90 124 88 170 144 88 170 164 90 110 144 90 170 100 88 170 92 166 90 124 168 80 140 90 170 168 152 80 92 126 170 168 154 80 136 90 170 164 90 100 164 122 90 168 158 80 112 90 170 164 156 80 132 166 80 92 114 170 164 138 80 92 116 170 168 144 80 164 90 90 164 90 130 104 166 80 144 166 80 160 88 170 92 166 130 92 168 90 92 146 170 92 106 170 164 130 80 164 100 90 168 136 80 164 90 160 116 168 80 132 90 170 92 166 100 164 126 90 168 162 80 92 168 120 168 164 80 92 138 170 164 142 80 164 112 90 164 92 110 164 166 80 92 166 110 164 148 80 92 166 170 140 166 80 164 150 80 164 120 90 168 156 80 92 130 170 152 88 170 164 92 120 92 166 80 168 140 80 148 88 170 112 168 80 152 168 80 92 158 170 164 110 90 92 98 170 92 140 170 164 92 90 120 88 170 104 168 80 120 90 170 92 104 170 120 166 80 160 166 80 92 148 170 92 108 170 92 150 170 156 166 80 92 90 170 164 124 90 92 92 170 92 134 170 92 166 160 108 90 170 148 90 170 128 166 80 168 146 80 92 120 170 168 148 80 140 88 170 100 90 170 164 116 90 160 90 170 116 88 170 156 88 170 92 128 170 156 90 170 136 166 80 96 168 80 164 134 80 164 104 90 92 154 170 92 166 140 92 168 100 128 90 170 108 166 80 92 118 170 164 88 170 128 168 80 92 100 170 92 142 170 164 94 90 168 130 80 164 168 80 92 168 110 136 88 170 120 168 80 96 166 80 116 166 80 132 88 170 164 92 100 92 132 170 168 160 80 92 166 120 92 168 80 168 142 80 164 160 80 104 88 170 92 160 170 148 168 80 92 162 170 164 114 90 168 150 80 92 124 170 100 166 80 164 128 80 100 168 80 140 168 80 164 88 160 112 88 170 164 102 90 168 138 80 92 112 170 164 136 80 128 88 170 92 94 170 92 136 170 92 96 170 148 166 80 168 166 80 104 90 170 164 90 150 124 166 80 92 102 170 92 144 170 92 166 150 96 88 170 164 118 90 96 90 170 160 168 80 92 88 170 164 90 140 164 154 80 136 168 80 152 90 170 108 88 170 164 106 90 92 156 170 164 108 90 164 140 80]; yourself]
!

pickColorIcon
    ^ ToolbarIconLibrary pipette16x16Icon
! !

!ColorEditDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ColorEditDialog andSelector:#windowSpec
     ColorEditDialog new openInterface:#windowSpec
     ColorEditDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Define Color'
         name: 'Define Color'
         min: (Point 440 360)
         bounds: (Rectangle 0 0 440 360)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'RGBLabelPanel'
             layout: (LayoutFrame 0 0 0 0 90 0 76 0)
             horizontalLayout: fit
             verticalLayout: spreadSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Red:'
                   name: 'RedLabel'
                   translateLabel: true
                   adjust: right
                   useDefaultExtent: true
                 )
                (LabelSpec
                   label: 'Green:'
                   name: 'GreenLabel'
                   translateLabel: true
                   adjust: right
                   useDefaultExtent: true
                 )
                (LabelSpec
                   label: 'Blue:'
                   name: 'BlueLabel'
                   translateLabel: true
                   adjust: right
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'RGBSliderPanel'
             layout: (LayoutFrame 90 0 0 0 -177 1 76 0)
             horizontalLayout: fit
             verticalLayout: spreadSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (SliderSpec
                   name: 'RedSlider'
                   tabable: false
                   model: red
                   orientation: horizontal
                   stop: 255
                   step: 1
                   backgroundColor: (Color 100.0 0.0 0.0)
                   extent: (Point 173 16)
                 )
                (SliderSpec
                   name: 'GreenSlider'
                   tabable: false
                   model: green
                   orientation: horizontal
                   stop: 255
                   step: 1
                   backgroundColor: (Color 0.0 100.0 0.0)
                   extent: (Point 173 16)
                 )
                (SliderSpec
                   name: 'BlueSlider'
                   tabable: false
                   model: blue
                   orientation: horizontal
                   stop: 255
                   step: 1
                   backgroundColor: (Color 0.0 0.0 100.0)
                   extent: (Point 173 16)
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'RGBFieldPanel'
             layout: (LayoutFrame -173 1 0 0 -130 1 76 0)
             horizontalLayout: fit
             verticalLayout: spreadSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (InputFieldSpec
                   name: 'RedField'
                   model: red
                   type: numberInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 255
                   acceptOnPointerLeave: false
                   extent: (Point 41 20)
                 )
                (InputFieldSpec
                   name: 'GreenField'
                   model: green
                   type: numberInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 255
                   acceptOnPointerLeave: false
                   extent: (Point 41 20)
                 )
                (InputFieldSpec
                   name: 'BlueField'
                   model: blue
                   type: numberInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 255
                   acceptOnPointerLeave: false
                   extent: (Point 41 20)
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'RGBFieldPanelHex'
             layout: (LayoutFrame -130 1 0 0 -100 1 76 0)
             horizontalLayout: fit
             verticalLayout: spreadSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (InputFieldSpec
                   name: 'EntryField4'
                   model: red
                   type: hexIntegerInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 255
                   acceptOnPointerLeave: false
                   extent: (Point 28 20)
                 )
                (InputFieldSpec
                   name: 'EntryField5'
                   model: green
                   type: hexIntegerInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 255
                   acceptOnPointerLeave: false
                   extent: (Point 28 20)
                 )
                (InputFieldSpec
                   name: 'EntryField6'
                   model: blue
                   type: hexIntegerInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 255
                   acceptOnPointerLeave: false
                   extent: (Point 28 20)
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'HLSLabelPanel'
             layout: (LayoutFrame 0 0 86 0 90 0 163 0)
             horizontalLayout: fit
             verticalLayout: spreadSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Hue:'
                   name: 'Label1'
                   translateLabel: true
                   adjust: right
                   useDefaultExtent: true
                 )
                (LabelSpec
                   label: 'Light:'
                   name: 'Label2'
                   translateLabel: true
                   adjust: right
                   useDefaultExtent: true
                 )
                (LabelSpec
                   label: 'Saturation:'
                   name: 'Label3'
                   translateLabel: true
                   adjust: right
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'HLSSliderPanel'
             layout: (LayoutFrame 90 0 86 0 -177 1 163 0)
             horizontalLayout: fit
             verticalLayout: spreadSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (SliderSpec
                   name: 'HueSlider'
                   tabable: false
                   model: hue
                   orientation: horizontal
                   stop: 359
                   step: 1
                   keyboardStep: 1
                   extent: (Point 173 16)
                 )
                (SliderSpec
                   name: 'LightSlider'
                   tabable: false
                   model: light
                   orientation: horizontal
                   step: 1
                   backgroundColor: (Color 67.0 67.0 67.0)
                   keyboardStep: 1
                   extent: (Point 173 16)
                 )
                (SliderSpec
                   name: 'SaturationSlider'
                   tabable: false
                   model: saturation
                   orientation: horizontal
                   step: 1
                   backgroundColor: (Color 67.0 67.0 67.0)
                   keyboardStep: 1
                   extent: (Point 173 16)
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'HLSFieldPanel'
             layout: (LayoutFrame -173 1 86 0 -130 1 163 0)
             horizontalLayout: fit
             verticalLayout: spreadSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (InputFieldSpec
                   name: 'EntryField1'
                   model: hue
                   type: numberInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 359
                   acceptOnPointerLeave: false
                   extent: (Point 41 20)
                 )
                (InputFieldSpec
                   name: 'EntryField2'
                   model: light
                   type: numberInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 100
                   acceptOnPointerLeave: false
                   extent: (Point 41 20)
                 )
                (InputFieldSpec
                   name: 'EntryField3'
                   model: saturation
                   type: numberInRange
                   numChars: 3
                   minValue: 0
                   maxValue: 100
                   acceptOnPointerLeave: false
                   extent: (Point 41 20)
                 )
                )
              
             )
           )
          (ViewSpec
             name: 'PreviewBoxFrame'
             layout: (LayoutFrame -100 1 4 0.0 -3 1.0 -39 1.0)
             level: 1
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Preview'
                   name: 'PreviewBox'
                   layout: (LayoutFrame 2 0.0 2 0.0 -2 1.0 -2 1.0)
                   level: -1
                   translateLabel: true
                   postBuildCallback: postBuildPreviewBox:
                 )
                )
              
             )
           )
          (LabelSpec
             label: 'Brightness:'
             name: 'Label5'
             layout: (LayoutFrame 0 0 175 0 90 0 197 0)
             activeHelpKey: brightness
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'EntryField8'
             layout: (LayoutFrame 90 0 175 0 -277 1 197 0)
             activeHelpKey: brightness
             model: brightnessStringHolder
             isReadOnly: true
             immediateAccept: false
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'Color Name:'
             name: 'ColorNameLabel'
             layout: (LayoutFrame 2 0 214 0 135 0 236 0)
             activeHelpKey: colorName
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'ColorNameField'
             layout: (LayoutFrame 135 0 214 0 -122 1 236 0)
             activeHelpKey: colorName
             model: colorNameHolder
             immediateAccept: false
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'HTML Color Name:'
             name: 'HTMLColorNameLabel'
             layout: (LayoutFrame 2 0 240 0 135 0 262 0)
             activeHelpKey: htmlColorName
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'MLHTColorNameFieldField'
             layout: (LayoutFrame 135 0 240 0 -122 1 262 0)
             activeHelpKey: htmlColorName
             model: htmlColorNameHolder
             immediateAccept: false
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'Color Definition:'
             name: 'Label4'
             layout: (LayoutFrame 2 0 266 0 135 0 288 0)
             activeHelpKey: colorDefinitionString
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'EntryField7'
             layout: (LayoutFrame 135 0 266 0 -122 1 288 0)
             activeHelpKey: colorDefinitionString
             model: colorDefinitionStringHolder
             isReadOnly: true
             immediateAccept: false
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (ActionButtonSpec
             label: 'Copy Color'
             name: 'CopyColor'
             layout: (LayoutFrame 12 0 298 0 120 0 320 0)
             activeHelpKey: hlsMixer
             translateLabel: true
             resizeForLabel: true
             tabable: true
             model: copyColor
           )
          (ActionButtonSpec
             label: 'Paste Color'
             name: 'PasteColor'
             layout: (LayoutFrame 122 0 298 0 240 0 320 0)
             translateLabel: true
             resizeForLabel: true
             tabable: true
             model: pasteColor
           )
          (ActionButtonSpec
             label: 'pickColorIcon'
             name: 'Button1'
             layout: (LayoutFrame 285 0 298 0 312 0 325 0)
             activeHelpKey: pickColor
             hasCharacterOrientedLabel: false
             translateLabel: true
             resizeForLabel: true
             tabable: true
             model: pickColor
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0.0 -32 1 -16 1.0 0 1.0)
             horizontalLayout: okCancelBox
             verticalLayout: centerMax
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'CancelButton'
                   translateLabel: true
                   resizeForLabel: false
                   tabable: true
                   model: cancel
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'OKButton'
                   translateLabel: true
                   resizeForLabel: false
                   tabable: true
                   model: accept
                   isDefault: true
                   defaultable: true
                   useDefaultExtent: true
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!ColorEditDialog class methodsFor:'startup'!

openOn:aColor
    ^ self new
        color:aColor;
        open;
        yourself

    "
     self openOn:Color red
    "
! !

!ColorEditDialog methodsFor:'accessing'!

color
    |colorName|

    colorName := self colorName.
    colorName notEmptyOrNil ifTrue:[
        ^ Color name:(colorName asSymbol)
    ].
    ^ Color redByte:(red value) greenByte:(green value) blueByte:(blue value)
!

color:aColor
    aColor isNil ifTrue:[
        ^ self
    ].

    aColor isSymbol ifTrue:[
        self colorNameHolder value:aColor
    ] ifFalse:[
        self red value:aColor redByte.
        self green value:aColor greenByte.
        self blue value:aColor blueByte.
    ]
!

colorName
    ^ colorNameHolder value
!

colorNameOrColor
    |colorName|

    colorName := self colorName.
    colorName notEmptyOrNil ifTrue:[
        "/ ^ Color name:(colorName asSymbol)
        ^ colorName asSymbol
    ].
    ^ Color redByte:(red value) greenByte:(green value) blueByte:(blue value)
!

htmlColorName
    ^ htmlColorNameHolder value
! !

!ColorEditDialog methodsFor:'actions'!

colorChanged
    |clr nm|

    clr := self colorNameOrColor.
    clr isColor ifTrue:[
        "not a symbol"
        self setPreview:clr.
        self htmlColorNameHolder value:(clr htmlPrintString) withoutNotifying:self.

        nm := #(white red green blue black) detect:[:nm | clr = (Color perform:nm)] ifNone:nil.
        nm notNil ifTrue:[
            self colorDefinitionStringHolder value:('Color ',nm).
        ] ifFalse:[
            self colorDefinitionStringHolder value:('Color rgbValue:16r',(clr rgbValue hexPrintString leftPaddedTo:6 with:$0)).
        ].
        self brightnessStringHolder value:((clr brightness asFixedPoint:3) printString).
    ].

    "Modified: / 27-01-2011 / 12:54:04 / cg"
!

colorChangedTo:clr
    "compute rgb and hls (if possible)"

    |h|

    self red   value:clr redByte withoutNotifying:self.
    self green value:clr greenByte withoutNotifying:self.
    self blue  value:clr blueByte withoutNotifying:self.

    h := clr hue.
    h notNil ifTrue:[
        self hue        value:(h rounded) withoutNotifying:self.
    ].
    self light      value:(clr light rounded) withoutNotifying:self.
    self saturation value:(clr saturation rounded) withoutNotifying:self.

    self colorChanged

    "Modified: / 27-01-2011 / 12:48:28 / cg"
!

colorNameChanged
    "compute rgb and hls (if possible)"

    |clr|

    clr := Color name:(self colorName) ifIllegal:nil.
    clr isNil ifTrue:[
        ^ self
    ].
    self colorChangedTo:clr.
!

copyColor
    self window setClipboardObject:self color
!

copyColorName
    self window setClipboardText:self htmlColorName
!

hlsSliderChanged
    "compute rgb"

    Color withRGBFromHue:hue value light:light value saturation:saturation value do:[:r :g :b |
        red    value:(r * 255 / 100) rounded withoutNotifying:self.
        green  value:(g * 255 / 100) rounded withoutNotifying:self.
        blue   value:(b * 255 / 100) rounded withoutNotifying:self.
    ].
    colorNameHolder value:'' withoutNotifying:self.
    self colorChanged
!

htmlColorNameChanged
    "compute rgb and hls (if possible)"

    |clr|

    htmlColorNameHolder value isEmptyOrNil ifTrue:[
        ^ self.
    ].

    clr := Color rgbValue:(Integer 
                                readFrom:(htmlColorNameHolder value copyFrom:2)
                                radix:16
                                onError:nil).
    clr isNil ifTrue:[
        ^ self
    ].
    self colorNameHolder value:'' withoutNotifying:self.
    self colorChangedTo:clr.
!

pasteColor
    |copyBufferColor|

    copyBufferColor := self window getClipboardObject.
    copyBufferColor isColor ifFalse:[
        UserPreferences current beepInEditor ifTrue:[                
            self window beep.
        ].
        ^ self
    ].
    self color:copyBufferColor
!

pickColor
    |color|

    color := Color fromUserWithFeedBack:[:clr | self setPreview:clr].
    color notNil ifTrue:[
        self color:color.
    ]
!

rgbSliderChanged
    "compute hls"

    |r g b|

    r := self red value.
    g := self green value.
    b := self blue value.

    Color withHLSFromRed:(r * 100 / 255) green:(g * 100 / 255) blue:(b * 100 / 255) do:[:h :l :s |
        h isNil ifTrue:[
            "/ achromatic
        ] ifFalse:[
            self hue    value:(h rounded) withoutNotifying:self.
        ].
        self light      value:(l rounded) withoutNotifying:self.
        self saturation value:(s rounded) withoutNotifying:self.
    ].
    self colorNameHolder value:'' withoutNotifying:self.
    self colorChanged
!

setPreview:color
    previewBox isNil ifTrue:[^ self "called before setup"].

    previewBox backgroundColor:color.
    previewBox foregroundColor:color contrastingBlackOrWhite.
! !

!ColorEditDialog methodsFor:'aspects'!

blue
    blue isNil ifTrue:[
        blue := 0 asValue.
        blue addDependent:self.
    ].
    ^blue
!

brightnessStringHolder
    brightnessStringHolder isNil ifTrue:[
        brightnessStringHolder := 0 asValue.
        "/ brightness addDependent:self.
    ].
    ^ brightnessStringHolder

    "Created: / 27-01-2011 / 12:48:00 / cg"
!

colorDefinitionStringHolder
    colorDefinitionStringHolder isNil ifTrue:[
        colorDefinitionStringHolder := '' asValue.
        "/ colorDefinitionStringHolder addDependent:self.
    ].
    ^colorDefinitionStringHolder

    "Created: / 27-01-2011 / 12:38:12 / cg"
!

colorNameHolder
    colorNameHolder isNil ifTrue:[
        colorNameHolder := '' asValue.
        colorNameHolder addDependent:self.
    ].
    ^colorNameHolder
!

green
    green isNil ifTrue:[
        green := 0 asValue.
        green addDependent:self.
    ].
    ^green
!

htmlColorNameHolder
    htmlColorNameHolder isNil ifTrue:[
        htmlColorNameHolder := '' asValue.
        htmlColorNameHolder addDependent:self.
    ].
    ^htmlColorNameHolder
!

hue
    hue isNil ifTrue:[
        hue := 0 asValue.
        hue addDependent:self.
    ].
    ^hue
!

light
    light isNil ifTrue:[
        light := 0 asValue.
        light addDependent:self.
    ].
    ^light
!

red
    red isNil ifTrue:[
        red := 0 asValue.
        red addDependent:self.
    ].
    ^red
!

saturation
    saturation isNil ifTrue:[
        saturation := 0 asValue.
        saturation addDependent:self.
    ].
    ^saturation
! !

!ColorEditDialog methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    (changedObject == red
    or:[changedObject == green
    or:[changedObject == blue]]) ifTrue:[
        self rgbSliderChanged.
        ^ self
    ].

    (changedObject == hue
    or:[changedObject == light
    or:[changedObject == saturation]]) ifTrue:[
        self hlsSliderChanged.
        ^ self
    ].

    (changedObject == colorNameHolder) ifTrue:[
        self colorNameChanged.
        ^ self
    ].
    (changedObject == htmlColorNameHolder) ifTrue:[
        self htmlColorNameChanged.
        ^ self
    ].

    super update:something with:aParameter from:changedObject
! !

!ColorEditDialog methodsFor:'startup & release'!

postBuildPreviewBox:aView
    previewBox := aView
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    (aBuilder componentAt:'HueSlider') 
        viewBackground:
            (ImageBackground new 
                image:(self class hueGradientImage);
                align:#fit;
                yourself).
    self colorChanged.

    "Modified: / 6.9.1998 / 22:55:25 / cg"
! !

!ColorEditDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

