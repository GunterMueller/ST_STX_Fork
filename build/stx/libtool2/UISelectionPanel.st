"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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

ApplicationModel subclass:#UISelectionPanel
	instanceVariableNames:'gallery userClass userSpecs userLabels majorSelection
		clipBoardSpec'
	classVariableNames:'UserClass UserSpecs UserLabels'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

Object subclass:#UserDefinedGallery
	instanceVariableNames:''
	classVariableNames:'LabelList SelectorList HolderList NextUniqueNumber'
	poolDictionaries:''
	privateIn:UISelectionPanel
!

!UISelectionPanel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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
    implements a selection panel, keeping widgets which could be placed
    into the UIPainter by drag & drop.

    [start with:]
        UISelectionPanel open

    [author:]
        Claus Gittinger
        Claus Atzkern

    [see also:]
        TabView
        NoteBookView
        UIGalleryView
        UIPainter

"

! !

!UISelectionPanel class methodsFor:'initialization'!

initialize
    UserClass  := UISelectionPanel::UserDefinedGallery.
    UserSpecs  := #listOfSelectors.
    UserLabels := #listOfLabels.

    "Modified: / 8.12.1997 / 18:53:06 / cg"
! !

!UISelectionPanel class methodsFor:'accessing'!

userClass
    "return the class which provides the user defined gallery specs."

    ^ UserClass

    "Created: / 5.12.1997 / 15:12:50 / cg"
!

userClass:aClass specSelector:aSpecAccessSelector labelSelector:aLabelListAccessSelector
    "change the class which provides the user defined gallery specs."

    UserClass := aClass.
    UserSpecs := aSpecAccessSelector.
    UserLabels := aLabelListAccessSelector.

    "
     UISelectionPanel 
        userClass:UISelectionPanel::VariableUserDefinedGallery
        specSelector:#listOfSelectors
        labelSelector:#listOfLabels
    "

    "Modified: / 5.12.1997 / 13:54:47 / cg"
    "Created: / 5.12.1997 / 13:56:10 / cg"
! !

!UISelectionPanel class methodsFor:'classAccess'!

galleryClass

    ^ UserDefinedGallery
! !

!UISelectionPanel class methodsFor:'image specs'!

sketchImageIcon
    ^ self sketchImageIcon2
!

sketchImageIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sketchImageIcon1 inspect
     ImageEditor openOnClass:self andSelector:#sketchImageIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'UISelectionPanel sketchImageIcon1'
        ifAbsentPut:[(Depth8Image new) width:62; height:48; bits:(ByteArray fromPackedString:'
&RH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H)$"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@"H @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH"@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@"H @@@@@@(+Z6O*6-D1LSX6LSD1LSB*6-,[F1,[D>W%9^W&&"(*H[S4=OED*D!!H>O#5)Z]GQ4$9L@@@@@@BH"@@@@@@@>G(Z[&51;\%]W
U5]2\%L-WH.K"8.[_W5=[V4^G& O)*Z;.;.]''Y6R"H"HMH6M#X59V @@@@@@H"H@@@@@@A9=&512U40HJR$)JP!!L@0L2 XD9NS$-KX.K_W5=-KRVC:YH.;,$
''Y6R"H"HMCP4#Q%9@@@@@@@"H @@@@@@G)-\U:PH+:(QDQD]+:<)S@LCL(FANS$-WH.K&75=-KQ(C:Z&.;.]''YJR"H!!EMCRMFW$@@@@@@BH"@@@@@@ANWG.$
+:)6YP0LQ7Z_GZ<)FD0C@3JA XD9WE2K&75=!!+RVC:YH.2R]''YJH"DT4MCPY^P@@@@@@H"H@@@@@@DI;U:<QYP@@@@@@@K!!,DQ6/JT0C@0L2 XESWGIW\''-\
&;POC:YH.2R]$("HQSP4MA%9@@@@@@@"H @@@@@@&3Y *+ @@@@@@@@@@F),DQ4)JQ C@0L2 XDCSE]W\''-\_Q8OC4!!HII6]$(!!EMCP4#W$@@@@@@BH"@@@@
@@A\U6B_@@@@@@@@@@@@LGY,GX()FA!!L@0L2 T1L\U]W^7-\G <O)$!!HC0>U^H 4MCRM^P@@@@@@H"H@@@@@@E23+6(@@@@@@@@@@@@@Z&0QGZ<)FD1L@0NA
SD1LU5]2^9.4G >&R@<B@ >U$#P4MH59@@@@@@@"H @@@@@@WKN/.@@@@@@@@@@@@@AG])(]""$)FD0C@0L=@0M1U5]\_[P^C0=HR@HBC4"HMCP4#W$@@@@@
@BH"@@@@@@A\,:>8@@@@@@@@@@@@@F)6&!!6JJR$XSD0C@0M2\%1\WI-=!!!!9(C:YH.59/$(!!EMCRM^P@@@@@@H"H@@@@@@E1WE''X@@@@@@@@@@@@@HV0QGX()
JQ XS@LCOWI2WE2K&75=G!!8OC4";[96R"DT4MH59@@@@@@@"H @@@@@@&5] *&T@@@@@@@@@@D]6[AD]+2$)FD1LS@LC WI\WH.[_W4^G <ORD";''YJH"CP4
#W$@@@@@@BH"@@@@@@B[^;N/''3@@@@@@@@@L]&0QGX()JQ XFD1L@0NA\%M\"9-=_Q8^C0=HRBR]''X"HMCPY^P@@@@@@H"H@@@@@@D9\U42*D[ 0@@@0Z''Y,
DQ6J+2$)FA!!LS@LC@8E2WE1\&76[&9,^C:YH.6>]"H 4MA%9@@@@@@@"H @@@@@@G)-\U0"/DY=,[F1,DQD]"*<)JR$XSD1L@0L=\''ISWH.[_U1\WDHORD";
[96H"CRMFW$@@@@@@BH"@@@@@@@^_Y-;U42/+14]GQ4]+:<)JR$XFD1LS@LC@352\%1\"9-=&9.[G >&RE:]''X"HMH4Y^P@@@@@@H"H@@@@@@@>4_U1;U:QL
JR&/+2$)JR$XSD1LS@LC@0L=\''I2WE2K&76FG!!8OC4";W)6R"H 4#Q%9@@@@@@@"H @@@@@@C;R4_X-\\%\CSD1LSD1LSD1LS@LC@0LCOWI2\%1\"8.[_Q8^
G >&RK-/''YJHQSPYFW$@@@@@@BH"@@@@@@B&Y;RF_Y-\WGJAOPLC@0LC@0LC@0LCOS52\''I\WE2K&75=G!!8OC:YHW&>]$(!!E#Q$Y^P@@@@@@H"H@J"(*@D O
Y;Q-_Y.KWE12 XFAOS4COPL=OXFA\''I2WE1\"9-=_R0^G <ORD!!^''Y6R"CRMFQ%9@B(*J @"H @*J"(@RJXOY;R4_Y.K"51\WGI2\''I2\(FA\''I2\%1\WH.[
&75=G!!8OC:YH.6>]''X"HMH4Y^W$@J"(*@BH"@B(*J"Z;)*XO%+Q-_W6["51\WE1S\''I2\''I2\%M\WE2K&9-=_Q8^G <O)$!!^[96R"DVM#Q%9^RX*J"(@H"H@
J"(*I)DG&JF:.+*:(P8(NEH_R5YI]WI\WE1\WE1\"9.[_W4,X''0E#DMT-R<#SZV%)XAMH7N\I"(*J @"H @*J"(*BU%>A XFA''9PTEAPVSLR*Z&)(Q\<U&YA
"9.[Z7^L ;^''):2,+C,1LSD1%IRT%CE:^''(*J"(*@BH"@A(ZF"(IQDA@(:N#(:N#(0XFA XFA XFTE@R*Y"QW[U.%1TUV8TA@PDA@PFP''):^''):^*J"(*B(Z
F!!(@H"H@F!!(ZJ*T1%IRTB0-@PDA@PDB#(:N#(:N#A XFA''9PVU&,DB-!!XVF.+*:.J:B @PDA@PDA@YB^J!!(ZF @"H @ZF!!(*O1B(*A0\%IRT%IRT%IPKB4A@
PDA@PJN#(:N#Q@YYO1T+CP5UQ&E!!XVE!!XZ:.+*8+(J@*F!!(Z@BH"@A(ZF"*''''):^''):^''*"(*J"(GA2T%IRT%IRT%@,KPDA@PDB#QC<UJ;B9CP4MCP4MCUUF
XVE!!XR(ZF!!(@H"H@F!!(ZF)\A(@DA@PDA@PFP''):^''):^*J"(*J \GIRT%IRT%IRTB4B2V2^G!!5EQTUF0,K$MCP4MF!!(ZF @"H @ZF!!(ZEZ9!!XVF.+*:.J:B 
@PDA@PDA@YB^''):^''):(*J"(*A0\%IP1N",%IPPD!!8^G!!8^GTUDZF!!(Z@BH"@A(ZF!!)?I04MCP5UQ&E!!XVE!!XZ:.+*8+(J@A@PDA@PDA$I:^''):^''*"(%CTD
K"T%IRT%IRT%AA(ZF!!(@H"H@F!!(ZF%>0TUEQ,KB9CP4MCP4MCUUFXVE!!XVE!!+*:.+". (@DA@PDA@PFP''",%VE!!XVE 7M28.F!!(ZF @"H @ZF!!(ZMX\DAH^G
!!8^G!!5EQTUF0,K$MCP4MCP4MUTY!!XVE!!XVF.+*:.J:B @TX  "@ HB@ HB@ZF!!(Z@BH"I*.+*1)0IR8%IRT%IRT%IPPD!!8^G!!8^GTUEQT[B0.P4MCP4MCP5U
Q&E!!XVE!!++BI"X&I"X&IYA*+*:,&H"H**:.+F"\7HE!!XVE!!XM3\.K"T%IRT%IRT%A@RG!!8^G!!8]QTUEQ,KB9CP4MCP4MCRBN#(:N"X&IF*.+*2("H"*+*:.+
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B+*:.+J"H"J*.+*:.+F!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(Z
F!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(Z*:.+*:,*H"H**:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*2("
H"*+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+J"H"@B(*J"(*J"(*J"(*J"(*J"(*J"(*J"(*J"(*
J"(*J"(*J"(*J"(*J"(*J"(*J"(*J"(*J"(*J"(*J"(@H)$"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"JY') ; colorMapFromArray:#[255 255 255 160 208 95 96 160 224 143 207 255 127 176 63 143 192 207 208 240 128 208 239 176 159 207 255 223 240 160 95 175 223 192 224 111 239 240 255 143 192 64 223 240 176 95 160 224 176 223 111 176 223 255 224 255 144 96 175 223 48 143 208 176 223 127 160 207 240 208 239 191 144 208 255 48 127 208 240 240 240 63 144 208 176 224 111 175 223 255 96 175 224 191 224 207 96 175 47 207 239 255 191 207 208 192 224 160 79 144 224 112 176 48 255 240 255 143 192 80 208 240 176 159 208 255 240 240 255 159 207 95 111 175 224 127 191 255 111 176 48 191 224 160 240 255 255 191 224 127 128 207 255 223 255 144 48 128 223 159 207 96 143 191 240 111 175 48 207 239 191 127 192 255 191 223 127 191 224 128 192 224 207 143 192 255 80 159 223 207 239 143 192 239 127 128 192 224 112 176 224 160 207 176 207 239 128 63 128 223 144 192 80 223 240 255 80 159 224 159 208 223 48 143 207 176 223 208 144 207 255 207 239 160 111 176 224 63 143 208 223 240 143 128 191 63 192 239 191 127 192 240 175 208 175 144 192 64 175 223 208 143 192 240 111 175 47 223 240 144 47 127 207 175 223 111 127 191 240 191 224 176 79 159 223 160 208 96 159 207 240 144 207 80 112 176 223 111 175 223 95 160 47 224 240 255 159 207 223 95 160 240 95 175 224 64 159 208 208 239 255 127 191 224 191 224 255 96 176 240 176 223 143 79 144 223 144 207 95 143 207 240 128 192 240 191 223 175 32 127 207 144 207 224 192 224 255 143 192 208 80 144 223 47 127 208 192 224 127 128 191 240 127 191 208 111 176 240 208 240 143 175 208 111 208 239 160 128 192 255 96 160 47 160 208 175 48 128 207 175 208 96 111 175 240 127 191 63 63 143 223 95 160 31 160 223 255 112 191 240 144 207 191 48 128 208 80 160 31 47 128 207 175 208 95 207 239 176 64 143 223 32 112 191 191 224 111 95 159 224 95 175 240 191 223 128 223 240 175 208 223 224 176 224 255 112 176 240 176 208 175 64 144 223 175 223 96 191 223 255 159 208 95 224 240 175 64 144 208 207 239 127 144 207 240 208 239 144 80 160 224 192 224 143 176 223 96 224 255 160 175 208 255 239 239 240 192 224 128 95 160 223 159 207 80 160 208 255 128 191 64 80 160 223 192 239 128 144 192 240 96 175 240 176 223 175 79 159 208 176 223 144 223 239 255 128 192 64 224 255 175 79 159 224]; mask:((ImageMask new) width:62; height:48; bits:(ByteArray fromPackedString:'
??????????3??????????O?????????<??????????3??????????O?????????<??????????3??????????O?????????<??????????3??????????O??
???????<??????????3??????????O?????????<??????????3??????????O?????????<??????????3??????????O?????????<??????????3?????
?????O?????????<??????????3??????????O?????????<??????????3??????????O?????????<??????????3??????????O?????????<????????
??3??????????O?????????<??????????3??????????O?????????<??????????3??????????O?????????<??????????3??????????O?????????<
??????????3??????????O?????????<') ; yourself); yourself]
!

sketchImageIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sketchImageIcon2 inspect
     ImageEditor openOnClass:self andSelector:#sketchImageIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'UISelectionPanel class sketchImageIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:96;
                height:78;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@
PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@
PDA@PDA@PDA@PDA@PC49A9"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X
&I"X&I"X&I"X&I"X&I"XA3%@PC%0I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''
I2\''I2\''I2\''I2\''I2\''I2\''I2\''HPI@P@\=I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''
I2\''I2\''I2\''I2\''I2\''I2\''\GA0\G@?O3<?NPA@P@\=I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''
I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2]0\GA0O3<?O3<=NVM@P@\=I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''
I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''\GA0\G@?O3<?OS4=NVM@P@\=I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''
I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2]0\GA0O3<?O3<=OS4=NVM@P@\=I2\''I5]OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=O
S4=OS4=!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE%XVE!!XVE!!YT9NS$9NNS$9NS%NS%T=OS4=NVM@P@\=I2\''I6YGQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]G
Q4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]DQB</KB0,E84_G22$EB0,KB2$R9VU+9V/B"TJ+3N,R6D=OS4=NVM@P@\=I2\''I6YGQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]G
Q4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQDP/K20,KB19%YV,+6I6#R0WX$.,+IV/+0(J%RTJ+D-"X&D=OS4=NVM@P@\=I2\''I6YGQ4]GQ4]GQ4]GQ4]GQ4]G
Q4]GQ4]GQ4]GQ4]GQ4\[F1-GQ4]GQ4]GQ4]GK2</E1^PKI@_R6IKR6IK+:=6#ZRMB *U+J2U+@*,+J1"X&I"X&D=OS4=NVM@P@\=I2\''I6X[F1,[F1,[F1,[
F1,[F1,[F1,[F1,[F1,[F1,[K2</K2</K1,[F1,[K2</K1^P^W4_X*2U+62/+D.,+0*,#VJU+IVU]&IK+D.MX(6M#VI"X&D=OS4=NVM@P@\=I2\''I6X/K2</
K2</K2</K2</K2</K2</K2</K2</K2</K2</K0LCK2</K2</K2<CE9A=G1=R+9VU%Z03%Z<JIP(JR3^U])U")JQ"+FJM#X6M#VI"X&T=OS4=NVM@P@\=I2\''
I6X/K2</K2</K2</K2</K2</K2</K2</K2</K2</K2<C@0LCK0L/K2</K0LW$G%)T*>/+:>UR4.,%P*/B"V/+J1KX*2M)JRMX(5"#X6MX&IK+D8=OS4=NVM@
P@\=I2\''I6X/K2</K2</K2</K2</K2</K2</K2</K2</K0LC@0LC@1\W@0LC@0LC@0LCE7%)+9VU+D-KX&IK+IVUB"TJ+A="R4-"R6J$)G%"X&I"X!!=KR6T=
OS4=NVM@P@\=I2\''I6XC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCE1\WE0LC@0LC@1\WE7$_+J1KG6I"X*2/+J0JIP*/+FI"+H6MX''&$)G&MR4-K
G6H_X&D=OS4=NVM@P@\=I2\''I8DC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCE1\W$IBP$A\WE1\WE9BP$G4_G6I"X&I"X*2/+J<JIS^/+FIK%T-"#W&$
^W%K+EJ,R6I"X&D=OS4=NVM@P@\=I2\''I4<WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\W$IBP$IBP$IBP$IBP$IA9^Q=KX&I"X&I"G9VU+J>/B*>UR:2U
%Z2M^W%9^W%K%YV,R6I"X&D=OS4=NVM@P@\=I2\''I4>P$IBP$IBP$IBP^W&P$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$G%9X!!<_X&I"X&H_R:2,+J>U
+:>U+EJ,X&I9^W%9^W$_+J2,+D-"#VD=OS4=NVM@P@\=I2\''I4>P$IBP$IBP^W%=G1=9^W%9X''59%IBP$IBP$IBP$IBT^W%9^YRT%IRT^W%9X!!<_X&I"X$-K
+J2,+J=,+:1KX&I"X*2UR86M#X4_G:2UG:0_X&D=OS4=NVM@P@\=I2\''I4>P$IQ9^W%9^Z1RT%J,+EIRT*2,X''%9^YRT%G%9^W%9^W%9^W%9^W%9^W%9^VIK
G1<_R4.,+J1R+2T%IP*,G1>,B (%B%I"X&H_+IV,X&IKR6D=OS4=NVM@P@\=I2\''I4>T^W%9^W%"G4.,+:=,[J>/[F1,[A==^W5=_W5=_VI"_W5=_W5=_W59
^W%=_VH_+J2,T*2,+J2U+2T%B"TJ+J1R+:=,%Z1"X&IK+A="X&I"X&D=OS4=NVM@P@\=I2\''I3)9^W5"X&J,R:1R+:>,T*2,%Z>/+:<_G1<__W5=G1<_G6I=
_W5=_W5=_W5=X&I"G1=RT*1RT)V/B*>U+2T%IRT%[J>UR6I"X&I"X&I"X&I"X&D=OS4=NVM@P@\=I2\''I3)=X&H_%YUR+EJ/T*2,+J2,T*>/%UJ,+J2,G1<_
G1=)G1<__W5=_W5=_W5"X&I"X!!>/%YV/+9V/+9UR%Z>/[F2/+62/R6I"X&I"X&I"X&I"X&D=OS4=NVM@P@\=I2\''I3)"+EIR+9V/%YV,+D.,+J2U+:>/%Z1R
T%IRT*1)G6&,+F$_G75=_W5=_VI"X&H_G:1,+:>/+:=,+:2,R4,_G:2,+:=RR1<_G1<_G1<_G6H_G6D=OS4=NVM@P@\=I2\''I2IR%Z>/+:>UT%J,R:2,+J1R
%YVU+:=,+:>/+9URG1>,T%J,ZQ<_G6I"X&I"G1<_G1=K+J1K+J>/+9V,R4.,R4.,+D.,+D-KR4,_G1<_R4-KG6T=OS4=NVM@P@\=I2\''I2J/+:>/+:>U%UJ,
+J2,+J2,+EJU+61,+:>/[F1,+5IRT%IRT*2,G1<_G1<_G1<_R4-KR4-KR:2/T*1RR4-KR:2/+5J/B&1,[J=KR4-K+J2,R6T=OS4=NVM@P@\=I2\''I2J/+:>/
+:>U+5J,+J2,+J1RT)V/+:>/[F1,[F1,[J>UT%IR%UJ,+J1)G1<_R4-KR4-KR:2,+J<JIP),[J<J+61,+2U,+60%IRT%[J>U+J2,+FT=OS4=NVM@P@\=I2\''
I2JU%YVU%UIRT*2,+J2,+EJU%YVU+62/+:>/[@(J+9VU%YURT%IRT%IR+J2,+J2,+J2,+J2,%Z=,B */B"T%IZ>U%V0%B&1,%P(%IRT%IYV,+FT=OS4=NVM@
P@\=I2\''I2JUT)VU%Z2,+J2,+J1R%YVU%YV/+:>/+:>/+:>/%YURT%J,+EJU%YVUT%IR+J2,+J2,+J2,%YVU+9VU+:<J+9VU+0(%IRT%+60%[J<JIRV/+FT=
OS4=NVM@P@\=I2\''I2JU%YVU%Z2,+J2U%YVU%YVU%YVU%YV/[J>/%YVU%YV,+J2,+EJU%YVU%YVU+:>UL:2,B */%YVU%YVU%YU,%YVU+0(JB (J+0),+:>/
+60%B$8=OS4=NVM@P@\=I2\''I6VU%YVU%YVU%YVU%YVU%YVU%YVU%YV/+:>/%YVU%Z2,+J2,+IVU%YVU%Z>/+0),%YU,B"T%+9VU%YVU%Z>/%YV/B */+:>/
%Z>/+:>/+0(%IS$=OS4=NVM@P@\=I2\''I7TIV''LVE*2U%YU_IG8I\9VU%YVU%YVU+:>/%YVU%SL3+CNU%YVU%YV/[F2/+0(%IRT%B*>/%YVU%YVU%YVU%YV/
+:>U%YVU%YV/+:>/+60JB$8=OS4=NVM@P@\=I2\''I1V.+''8$Z&*.V"Q*Z''9>%7NU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Z=,+:>/+0*/+:>/+:>U%YVU%YVU
%YVU%YVU%YVU%YVU%Z>/+:>/B"T%IS$=OS4=NVM@P@\=I2\''I1V._'':.+''9>_&)''Z''9>TC!!Y+9VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU+:>/B */+:>/+:>/
%YVU%YVU%Z>/+:>/+:>/+:>/+:>/+:>/[@(JIT8=OS4!!T6M@P@\=I2\''I1V.+*9*+*:.+&)*_''9>_%@8VZ>/%YVU%YVU%YVU%YVU%YVU%YVU%YVU+:<JB */
+:>/+:>/+:>/+:>/+:>/+:>/+:>/+:>/+:>/+:=,B (%B$8=ORD!!T6M@P@\=I2\''I1U''Z*:.+*:._&)*_''9>_''9PCHZ/M9VU%YVU%YVU%YVU%YVU%YVU%Z>/
M0(%B#\7M3\7M3^/+:>/+:>/+:>/+:>/+:>/+:<7+3\7M0(JB (%IT8!!HRD!!T6M@P@\=I2\''I1U''Y6]*Z*:.+&)*_''8;_''8;BY\M*C\7M3\7+:<7+:>/+3\7
+3^/M3\7M0(JB (7M3\7M3\7M3\7+3\7+3^/M3\7M3\7M3\7M3\JB (JB"T%IT8!!HRD!!T6M@P@\=I2\''I1U''Y6]''Y6)*Z''9*_''9>_''8;BP$I[: 7M3\7M3\7
M3\7M3\7M3\7M3\7M0(JB#\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\JB (JB (JB"T%B$8!!HRD!!T6M@P@\=I2\''I1U''Y6]''Y6)*Z*9*_''9>_#,;BY\I+ &F
[7MJ+3\7M3\7M3\7M3\7B#\7B (JB#\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7B (JB (JB (JB (JB$8!!HRD!!T6M@P@\=I2\''I1U''Y6]''Y6]''Z&)*Z&)>_''8;
BP$IBP$IBS,I,%>(M3\7B (JB (JB (JB (JB (7M3\7M3\7M3\7M0(7B (JB (JB (JB (JB (JB (JB (JB$8!!HRD!!T6M@P@\=I2\''I;Z%Y6]''Y6]''Y6^+
SH:N#"A>_#,$I@$IBP$IBP$I\3\JB (JB (JB (JB (JB (7M3\7M3\JB (JB (JB (JB (JB (JB (JB (JB (JB"TJB$8!!HRD!!T6M@P@\=I2\''I02^'':]''
H:-L(JB (I:^'')>8.W]>IBR._*8IBZ:.BRR2\ (JB (JB */+:<JB*>/+J2U+3\7+:>/+0(JB (JB (JB (JB (JB (JB (JB"T%IT8!!HRD!!T6M@P@\=I2\''
I8VG(JF!!''): (JB (JB ''):_'';!!7]7:.+*:.BRR.+ $IBU<JB (JB%JQG1<_T!!>QZW(_+F%:Y''*:.+)RB (JB (JB (JB (JB (JB (JIRT%IT8!!HRD!!T6M@
P@\=I2\''I8VI!!8^!!(I:^!!8^G(JB (I:!!''9>9.[&N+*:.+*:.+*8$+ %3B (JT''6Q$YFQ$YFQ$W*Q+G*:.+(2(:N#S4<HB (JB (JB (JB (%IRT%IRT%IT8!!
HRD!!A6M@P@\=I2\''I8VI!!4"!!(ZV!!(X^G!!8^G(JB ''):_#+&9.W:.Z&*.+*9*+*8$P4):$YF:.+*:$YFQ$YFQ$YF:.+*#(:N#(:N#S0(%IRT%IRT%IRT%IRT%
IRT%IS$!!HRD!!A6M@P@\=I2\''I8VI"X&!!)ZV")ZV!!!!8^G!!8^G(JB )X:9.[$4_&*.+*:.Z*9>_!!0DMCR9.[&KAF>:$YFQ$YFQ.+*#(:N#(:N#(3H:[BT%IRT%
IRT%IRT%IRT%IS$!!HRD!!A6M@P@\=I2\''I8VL"X&I!!8*J)ZV%(X^I"X^G!!8^G!!:F"#*F_#+&N#(:N#(:N.X9^.[&9.[&9.[$0A@$IBP&2WK*:L*N#(:N#(:N#
(1)!!XRH%IRT%IRT%IRT%IS$!!HRD!!A6M@P@\=I2\''I8VL#H&I"X&I"X&G"(^G"X^I!!8^G!!8]H)ZV%(+"9.[&)#+&9.[%^W#Q^.[&9.X.K"8.9.X.KTE!!\P%"2
BSX\.PR2\ZN#(:N:[BT%IRT%IRT%IS$!!HRD<A6M@P@\=I2\''I8VL#H2I"X&I"X&I"X&I"X^G!!8&G!!8^J"*VJ(T"!!RJVN(%:'')ZJ9W+&9W%9^#(:".[&N.[&9
LA29.[%[.[$+AC@0LCX>WE11WFD?I2\''I2\''I3$!!HS0<A6M@P@\=I2\''I8VL#H&L#H2I"X&I"X&I"X&I"X&I"X^J"*V%)ZV%RJV''(*J%)ZJ"#%9^W%9^#(:"
((:"(*J"(%8DW%:9W+&NW#B9#+&9AC@0AA0\G$FROS<?O48<OC0<A6M@P@\=I2\''I8VL#H2I"X2I"X&I"X&I"X&I"X&I"Q!! "&A;RT&%)ZV%)ZV%(*J%($&"
)ZJ'')5:"(*J")ZV%)ZI^YE:N.U9^V5:9#+%^A@PDV0P0.U,1LSYXQT4<OC0<A6M@P@\=I2\''I8VL#H2L"X&I"X&I"X&I"X&I"X&I"X&IXGQ ]FB%^:U4XH*%
)ZV"RT%IRT&''RT&''RZJ%)T"%)ZV%(%:"#*I^#(9^W%9^W%8YA@PDA@P1A@PDMQT<OC09A6M@P@\=I2\''I8VL#H&I"X&I"X&I"X&I"X&I"X$XFH&IFA X"&A 
XFB%XFA ^:V%)ZV%)ZUIRZJ"RZV")Q4]GQ4])ZJ")ZJ%(*J''YH9^AE9^W&Q^W%8YAA%[A@<<OC$9A6M@P@\=I2\''I56-+Z6-+Z6-+Z6-+Z6-+P,K%)ZV%+B0
,KB0,KB0,KB0,KB1 HB@ I*Z&)*Z&)*Z&)&Y 8L(JI.[&9,PD5!!XVE!!XV%)ZP$H-KR4-J$Y_Q%=_@PT9NS$9A6M@P@\=I2\''I54K%)ZV%)ZV%)ZV%)ZB%(JB
,[F1,[FB,[F1,XB@ KF@ HBZ&)*@&)*Z!!HRD-8RD!!B (J[\)JQLSD5 SVE!!BD$IBP$I\Q$Y_W4Y_XVU%YVU%R \9NS$9A6M@P@\=I2\''\B6B (JB (JB,XJB
,[F1 HB@ HB@ HB@&(BZ HBD HRZ!!KRD!!HRD!!K^DJR )JR$)JR%XVE RD%!!.D!!HRD!!IBQ%2&)%=_Q%=_XVU%YT9NR$9NS \9NS$9A6M@P@\=I2]0\E6B (JB
 (JB,[FB,XB1 HB1 HB@ HBZ!!HBD!!AFDDQDQDQD)I"$QDQD)JR$)C"$R''R&]''Y4RD%1\D*Y\QTV&W6F&)%>&)%>***Y!!XVE%YVE!!S \9NS$9A6M@P@\=\GA0
\E6B (JB (JB (JB,XB@ HB@ (B@ HA-!!F5-[V-+DQDQI"X)D!!L)I"$)I"X)"H"H''R$)JX"]''R$)"AI\#8=\P%<.)%2&)%=_W6E%A&E!!YVE%*''<9NS$9A6M@
P@\=\GA0\E6B (JB &!!(ZHJB HB@ HB@ HA-Z65-[[M+Z;M+DQDQI"X)JR$)JR$)JR$)JR&OJR$RD":OD!!H)K"8.WB:&)*Z*W8>&XU<.W5>*YVV*YVU%*''<9
NS$9A6M@P@\=\G@?O7"B (ITU(ITUEQT[UQT[V5-[UQ-[V5+,;LQDQD&I"X)I"$QDR$)JR$)JQH)JR$RD2$RJQLRJR8R)"8R#28.)%2&)(=_*%>&**Y!!YZY!!
YVUNA T9NS$9A6M@P@\=\C<?O7"B (JBU%QT (ITUF"BZF"BZEQ-,;N3,1F3I!!DQDQDQDQD)I"$)JR$QI"$RJQLRJR$RJQH.D":&D1I\K"8RK":O#:Z&SU=_
P*Z*W4:*W5<FR T9NS$9A6M@P@\=O3<?O7"B %QT &!!(ZEQ(UEQTUF5+[[LQDQF3,;N3DQDQDRXQDR$)JR$QJR$)DQD)DQD)DQD&DQH)JR$)JQHRD8=\WJZ&
W52&WD5\) Z&A&F*W:Z&W:(9NS$9A6M@P@\=O3<=OR5TUEQTUEQTUEQT[V5+[V5+[[V3,1DQ,;LQI!!F3JQD&DQDQDQD&JQL)DR$)JRX)JR$)JQJOWAH.D!!J&
K"9_WD5%W5>&)*Y\)*ZOWB8.YVV&R T9NS$9A6M@P@\=O34=OR5--UQTUEQTUEQ-[V63,;N3,;N3DQDQJQDQDQD&DQDQDQD&I!!DQJQDQJRX)JQD&JR8)I"$)
JR$.D!!HRD$6&D!!J&WJX.JU2&K"8SSZZ&W0XR) T9NS$9A6M@P@\=OS4=OR5T[[N3D[N\-[N5-[N3,;N5,;N3,;N3,;N3,1DQDQDQDQD)JR$&DQF3DQDQJRXQ
D[LQZ;LQDQH)D!!H.WJY_WB9\WJZ&)*Z&)%1\D!!LRW28RK*(9NS$9A6M@P@\=OS4=OR5TUERSUEQTUF!!TUEQT[V63,;N5[[L)JQDQ,1F3DQDQDR$SDRX)DR$)
JRX)JR$)I"%XJR$)D( .D"$RJQHSK"$R)!!H.JPX.D!!H.D"8.K*Z&W7<9NS$9A6M@P@\=OS4=OR63,;M-UEQT[UQTUF5TUF63D[N5UEQT,;N3,;N3,;LQ,1D&
DR$)JR$)DRXQDRXQJR$SK!!L)K!!HRD"8SK%2*WB$)K!!LRWJXF)!!I\#:Y_**Z&W7<9NS$9A6M@P@\=OS4=OW!!(ZF!!TZF5TUEQTUF5-[V5-Z65-[V5-[V.D[V.D
DV--[V.D!!AE-[QDQJQDQDXPQ!!F.DZ1D)JQD)DR:7D45ZVALSSR5_^B&7K%<.D:Z&)*Z**''<9NS$9A6M@P@\=OS4=OS4=OS4=OS4=OS4=OS4=ORD!!HRD!!TUEQ
TS%QTUD9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9A6M@P@\=OS4=OS4=OS4=OS4=OS4=OS4=OS4=
OS4=OS4=OS4=OS4=OS4=HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!OC0<OC0<NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9A6M@P@\=OS4=OS4=OS4=OS4=OS4=
OS4=OS4=OS4=OS4=OS4=OS4=OS4!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HS0<OC0<OC09NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9A6M@P@\=OS4=OS4=OS4=
OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!OC0<OC0<NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9A6M@P@\=OS4=
OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HS0<OC0<OC$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9A0A@
PC$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NUMST5MST5MST5MST5MST0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\G
A0\GA0A@PBDG@FM#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#X6M#
X6M#X6M#X6L@_@]@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@
PDA@PDA@PDA@PDA@PDA@PDA@');
                colorMapFromArray:#[ 176 176 180 176 208 210 192 192 190 96 160 255 96 160 130 192 208 210 176 192 220 208 208 210 192 224 240 112 160 140 224 255 255 48 80 130 144 176 140 128 176 160 96 160 180 144 176 160 112 144 160 80 128 180 112 160 190 112 144 180 96 192 255 160 176 180 160 208 220 96 176 255 48 80 80 80 160 130 160 192 220 80 144 255 112 176 130 64 96 100 128 192 140 160 208 255 96 128 110 240 240 220 208 224 240 80 112 130 112 144 140 240 255 255 80 144 180 255 255 255 96 128 160 96 144 180 144 192 190 80 160 100 80 176 255 144 176 190 128 160 190 80 160 255 96 160 110 96 176 130 144 176 220 176 240 255 96 144 110 96 176 140 112 176 140 208 255 255 128 176 130 224 224 220 192 208 240 112 144 130 240 224 220 240 240 240 112 176 180 240 240 255 0 0 0 160 208 180 128 176 190 144 176 180 64 160 255 112 160 210 144 192 210 64 144 255 64 96 80 64 128 110 192 224 220 160 224 255 80 112 100 160 176 210 208 224 220 176 208 240 112 160 130 224 240 220 192 224 255 224 208 210 48 112 160 224 224 240 48 96 160 224 224 255 112 160 180 160 208 190 128 160 180 80 160 110 128 176 210 144 160 180 80 144 110 160 192 210 48 96 100 176 208 220 144 208 255 176 160 180 80 144 130 192 208 220 160 192 240 80 128 130 48 112 140 176 208 255 96 128 130 64 128 160 224 240 255 64 112 160 112 176 190 128 176 180 255 240 255 112 176 210 160 192 190 160 208 210 48 112 100 176 192 190 144 224 255 96 144 100 144 160 190 128 192 255 160 208 240 64 112 110 192 176 180 144 192 255 96 144 130 192 192 210 64 112 140 176 192 240 48 96 140 96 128 140 80 128 160 144 160 140 144 192 180 48 96 60 96 144 190 48 80 60 48 96 80 96 160 100 48 64 60 128 208 255 80 128 100 128 160 210 112 176 255 144 192 240 208 224 210 32 112 140 128 176 255 192 240 255 48 96 130 128 176 140 208 192 210 80 128 140 80 112 140 96 144 160 48 112 180 96 160 190 64 112 60 64 128 80 64 96 60 64 112 80 64 128 100 128 176 220 112 192 255 64 112 100 144 176 210 80 128 110 192 240 240 112 160 110 176 192 210 80 112 110 176 224 255 48 80 110 96 144 140 208 240 255 64 96 130 64 96 140 112 160 160 64 128 180 80 112 160 64 112 180 160 176 160 96 128 180 80 128 80 80 144 100 144 192 220 ];
                mask:((ImageMask new)
                            width:96;
                            height:78;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_???????
???????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>
_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_???????
???????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>
_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_???????
???????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>
_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_???????
???????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>
_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_???????
???????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>_??????????????>
_??????????????>_??????????????>@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!UISelectionPanel class methodsFor:'interface specs'!

nameAndSelectorSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#nameAndSelectorSpec
     UISelectionPanel new openInterface:#nameAndSelectorSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: nameAndSelectorSpec
        window: 
       (WindowSpec
          label: 'Painter'
          name: 'Painter'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 329 262)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Class & selectors to access user specs:'
              name: 'title'
              layout: (Point 5 10)
              resizeForLabel: true
              adjust: left
            )
           (LabelSpec
              label: 'Class:'
              name: 'classLabel'
              layout: (AlignmentOrigin 68 0.11 51 0 1 0.5)
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'classField'
              layout: (LayoutFrame 74 0.11 39 0 -5 1.0 61 0)
              tabable: true
              model: className
              type: string
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Labels:'
              name: 'labelsLabel'
              layout: (AlignmentOrigin 68 0.11 74 0 1 0.5)
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'labelsField'
              layout: (LayoutFrame 74 0.11 64 0 -5 1.0 86 0)
              tabable: true
              model: labelsKey
              type: symbolOrNil
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Specifications:'
              name: 'specsLabel'
              layout: (AlignmentOrigin 68 0.11 99 0 1 0.5)
              resizeForLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'specsField'
              layout: (LayoutFrame 74 0.11 89 0 -5 1.0 111 0)
              tabable: true
              model: specsKey
              type: symbolOrNil
              acceptOnPointerLeave: false
            )
           (HorizontalPanelViewSpec
              name: 'commitPanel'
              layout: (LayoutFrame 0 0.0 -23 1.0 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: fit
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'cancel'
                    name: 'cancel'
                    tabable: true
                    model: cancel
                    extent: (Point 153 23)
                  )
                 (ActionButtonSpec
                    label: 'ok'
                    name: 'accept'
                    tabable: true
                    model: accept
                    isDefault: true
                    extent: (Point 153 23)
                  )
                 )
               
              )
            )
           (CheckBoxSpec
              label: 'Update Default Resources'
              name: 'updateDefaultResources'
              layout: (Point 5 133)
              model: updateDefaultResources
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#windowSpec
     UISelectionPanel new openInterface:#windowSpec
     UISelectionPanel open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Widget Gallery'
          name: 'Widget Gallery'
          min: (Point 100 280)
          bounds: (Rectangle 14 46 508 348)
        )
        component: 
       (SpecCollection
          collection: (
           (NoteBookViewSpec
              name: 'NoteBook1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              model: majorChannel
              menu: majorList
              direction: right
              useIndex: true
              canvas: gallery
            )
           )
         
        )
      )
! !

!UISelectionPanel class methodsFor:'interface specs-standard gallery'!

specifications

    ^ #(
        #( 'Standard'  #( 
                            #('Buttons' standardButtons)
                            #('Menus'   standardMenus)
                            #('Text'    standardTexts)
                            #('Lists'   standardLists)
                            #('Trees'   standardTrees)
                            #('Groups'  standardGroups)
                            #('Embed'       standardEmbed)
                            #('Geometric'   standardMorphs1)
                            #('Misc'    standardMisc)
                         )
         )

        #( 'Clipboard'  #(
                            #('Copy & Paste Buffer'     clipBoardSpec)
                          )
         )

        #( 'User Def.'   #userDefined )
     )

    "Modified: / 21.4.1998 / 12:04:22 / cg"
!

standardButtons
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardButtons
     UISelectionPanel new openInterface:#standardButtons
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: standardButtons
       window: 
      (WindowSpec
         label: 'Buttons'
         name: 'Buttons'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 477 241)
       )
       component: 
      (SpecCollection
         collection: (
          (ActionButtonSpec
             label: 'Button'
             name: 'Button'
             layout: (LayoutFrame 2 0 1 0 127 0 23 0)
           )
          (ActionButtonSpec
             label: 'OK'
             name: 'Button - OK'
             layout: (LayoutFrame 2 0 33 0 127 0 55 0)
             translateLabel: true
             model: accept
           )
          (ActionButtonSpec
             label: 'Cancel'
             name: 'Button - Cancel'
             layout: (LayoutFrame 2 0 65 0 127 0 87 0)
             translateLabel: true
             model: cancel
           )
          (ActionButtonSpec
             label: 'Help'
             name: 'Button - Help'
             layout: (LayoutFrame 2 0 97 0 127 0 119 0)
             translateLabel: true
             model: help
           )
          (ActionButtonSpec
             label: 'Close'
             name: 'Button - Close'
             layout: (LayoutFrame 2 0 129 0 127 0 151 0)
             translateLabel: true
             model: closeRequest
           )
          (ToggleSpec
             label: 'Toggle'
             name: 'Toggle'
             layout: (LayoutFrame 144 0 1 0 280 0 23 0)
             isTriggerOnDown: true
             lampColor: (Color 100.0 100.0 0.0)
           )
          (RadioButtonSpec
             label: 'Radio Button'
             name: 'Radio Button'
             layout: (LayoutFrame 144 0.0 33 0 280 0 55 0)
             isTriggerOnDown: true
           )
          (CheckBoxSpec
             label: 'Check Box'
             name: 'Check Box'
             layout: (LayoutFrame 142 0 65 0 278 0 87 0)
           )
          (CheckToggleSpec
             name: 'Check Toggle'
             layout: (LayoutOrigin 146 0 99 0)
             isTriggerOnDown: true
             showLamp: false
             lampColor: (Color 100.0 100.0 0.0)
           )
          (LabelSpec
             label: 'Check Toggle'
             name: 'CheckToggleLabel'
             layout: (AlignmentOrigin 166 0 98 0 0 0)
             resizeForLabel: true
             adjust: left
             canUIDrag: false
           )
          (TriggerBoxSpec
             label: 'Trigger Box'
             name: 'TriggerBox1'
             layout: (LayoutFrame 142 0 129 0 278 0 151 0)
           )
          (ButtonSpec
             label: 'Model Button'
             name: 'Model Button'
             layout: (LayoutFrame 296 0 1 0 432 0 23 0)
           )
          (LabelSpec
             label: 'Spin Button'
             name: 'UpDownButtonLabel'
             layout: (AlignmentOrigin 348 0 35 0 0 0)
             resizeForLabel: true
             adjust: left
             canUIDrag: false
           )
          (UpDownButtonSpec
             name: 'UpDown Button'
             layout: (LayoutFrame 296 0 33 0 341 0 55 0)
             orientation: horizontal
           )
          (LabelSpec
             label: 'Arrow Button'
             name: 'ArrowButtonsLabel'
             layout: (AlignmentOrigin 348 0 69 0 0 0)
             resizeForLabel: true
             adjust: left
             canUIDrag: false
           )
          (ArrowButtonSpec
             name: 'Arrow Button'
             layout: (LayoutFrame 296 0 65 0 318 0 87 0)
             isTriggerOnDown: true
             direction: right
           )
          (ActionButtonSpec
             label: '...'
             name: 'Button1'
             layout: (LayoutFrame 296 0 98 0 316 0 120 0)
             translateLabel: true
             model: someAction
           )
          (LabelSpec
             label: 'Ok/Cancel Panel'
             name: 'Label2'
             layout: (LayoutFrame 3 0 -49 1 208 0 -26 1)
             adjust: left
             canUIDrag: false
           )
          (HorizontalPanelViewSpec
             keepUILayout: true
             name: 'OkCancelPanel'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             reverseOrderIfOKAtLeft: true
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'Button2'
                   translateLabel: true
                   model: cancel
                   extent: (Point 125 22)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'Button3'
                   translateLabel: true
                   model: accept
                   extent: (Point 125 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

standardEmbed
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardEmbed
     UISelectionPanel new openInterface:#standardEmbed
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardEmbed
        window: 
       (WindowSpec
          label: 'Misc'
          name: 'Misc'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 456 269)
        )
        component: 
       (SpecCollection
          collection: (
           (ArbitraryComponentSpec
              name: 'Arbitrary Component'
              layout: (LayoutFrame 3 0 3 0 128 0 104 0)
              hasBorder: false
            )
           (LabelSpec
              label: 'Scrollable'
              name: 'ScrollableArbitraryLabel1'
              layout: (AlignmentOrigin 7 0 7 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (LabelSpec
              label: 'Arbitrary-'
              name: 'ScrollableArbitraryLabel2'
              layout: (AlignmentOrigin 7 0 23 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (LabelSpec
              label: 'Component'
              name: 'ScrollableArbitraryLabel3'
              layout: (AlignmentOrigin 7 0 39 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (UISubSpecification
              name: 'SubSpecification'
              layout: (LayoutFrame 145 0 3 0 280 0 104 0)
            )
           (LabelSpec
              label: 'SubSpecification'
              name: 'SubSpecificationLabel'
              layout: (Point 149 7)
              resizeForLabel: true
              canUIDrag: false
            )
           (SubCanvasSpec
              name: 'SubCanvas'
              layout: (LayoutFrame 297 0 3 0 433 0 104 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
            )
           (LabelSpec
              label: 'SubCanvas'
              name: 'SubCanvasLabel'
              layout: (AlignmentOrigin 324 0 7 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (NonScrollableArbitraryComponentSpec
              name: 'NonSrollable Arbitrary Component'
              layout: (LayoutFrame 3 0 120 0 128 0 221 0)
            )
           (LabelSpec
              label: 'NonScrollable'
              name: 'NonScrollableArbitraryLabel1'
              layout: (AlignmentOrigin 7 0 124 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (LabelSpec
              label: 'Arbitrary-'
              name: 'NonScrollableArbitraryLabel2'
              layout: (AlignmentOrigin 7 0 140 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (LabelSpec
              label: 'Component'
              name: 'NonScrollableArbitraryLabel3'
              layout: (AlignmentOrigin 7 0 156 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           )
         
        )
      )
!

standardGraphs
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardGraphs
     UISelectionPanel new openInterface:#standardGraphs
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardGraphs
        window: 
       (WindowSpec
          label: 'Graphs'
          name: 'Graphs'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 453 161)
        )
        component: 
       (SpecCollection
          collection: (
           (GraphColumnView2DSpec
              name: 'GraphColumnView2D'
              layout: (LayoutFrame 3 0 3 0 208 0 98 0)
              gridX: 0
              gridY: 0
            )
           (LabelSpec
              label: 'GraphColumnViewView2D'
              name: 'GraphColumnView2DLabel'
              layout: (AlignmentOrigin 7 0 7 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (GraphColumnView3DSpec
              name: 'GraphColumnView3D'
              layout: (LayoutFrame 228 0 3 0 433 0 98 0)
            )
           (LabelSpec
              label: 'GraphColumnViewView3D'
              name: 'GraphColumnView3DLabel'
              layout: (AlignmentOrigin 232 0 7 0 0 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           )
         
        )
      )
!

standardGroups
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardGroups
     UISelectionPanel new openInterface:#standardGroups
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: standardGroups
       window: 
      (WindowSpec
         label: 'Groups'
         name: 'Groups'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 450 267)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Box'
             layout: (LayoutFrame 3 0 3 0 95 0 95 0)
           )
          (TransparentBoxSpec
             name: 'TBox1'
             layout: (LayoutFrame 113 0 3 0 204 0 95 0)
           )
          (LabelSpec
             label: 'TransparentBox'
             name: 'Label1'
             layout: (AlignmentOrigin 106 0 5 0 0 0)
             translateLabel: true
             resizeForLabel: true
             adjust: left
             canUIDrag: false
           )
          (LabelSpec
             label: 'Box'
             name: 'ViewLabel'
             layout: (AlignmentOrigin 6 0 5 0 0 0)
             translateLabel: true
             resizeForLabel: true
             adjust: left
             canUIDrag: false
           )
          (LabelSpec
             label: 'Variable Panels'
             name: 'VPanelLabel'
             layout: (LayoutFrame 3 0 104 0 208 0 127 0)
             translateLabel: true
             adjust: left
             canUIDrag: false
           )
          (VariableHorizontalPanelSpec
             name: 'Variable Horizontal Panel'
             layout: (LayoutFrame 3 0 128 0 98 0 218 0)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'A'
                   name: 'label4'
                   level: 2
                   translateLabel: true
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'B'
                   name: 'label5'
                   level: 2
                   translateLabel: true
                   canUIDrag: false
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          (VariableVerticalPanelSpec
             name: 'Variable Vertical Panel'
             layout: (LayoutFrame 113 0 128 0 208 0 218 0)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'A'
                   name: 'label9'
                   level: 2
                   translateLabel: true
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'B'
                   name: 'label10'
                   level: 2
                   translateLabel: true
                   canUIDrag: false
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          (FramedBoxSpec
             label: 'Framed Box'
             name: 'Framed Box'
             layout: (LayoutFrame 228 0 3 0 433 0 98 0)
             labelPosition: topLeft
             translateLabel: true
           )
          (LabelSpec
             label: 'Panels'
             name: 'PanelLabel'
             layout: (LayoutFrame 228 0 104 0 433 0 127 0)
             translateLabel: true
             adjust: left
             canUIDrag: false
           )
          (HorizontalPanelViewSpec
             name: 'Horizontal Panel'
             layout: (LayoutFrame 228 0 128 0 312 0 218 0)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'A'
                   name: 'label1'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'B'
                   name: 'label2'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'C'
                   name: 'label3'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'Vertical Panel'
             layout: (LayoutFrame 320 0 128 0 367 0 218 0)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'A'
                   name: 'label6'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'B'
                   name: 'label7'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'C'
                   name: 'label8'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                )
              
             )
           )
          (PanelViewSpec
             name: 'Panel'
             layout: (LayoutFrame 375 0 128 0 433 0 218 0)
             horizontalLayout: fitSpace
             verticalLayout: fitSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'A'
                   name: 'label11'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'B'
                   name: 'label12'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'C'
                   name: 'label13'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'D'
                   name: 'label14'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                (LabelSpec
                   label: 'E'
                   name: 'label15'
                   level: 2
                   translateLabel: true
                   extent: (Point 23 23)
                   canUIDrag: false
                 )
                )
              
             )
           )
          )
        
       )
     )
!

standardLists
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardLists
     UISelectionPanel new openInterface:#standardLists
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardLists
        window: 
       (WindowSpec
          label: 'Lists'
          name: 'Lists'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 455 264)
        )
        component: 
       (SpecCollection
          collection: (
           (SequenceViewSpec
              name: 'List'
              layout: (LayoutFrame 3 0 3 0 208 0 101 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              useIndex: false
            )
           (DataSetSpec
              name: 'Table'
              layout: (LayoutFrame 228 0 3 0 433 0 101 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              has3Dseparators: false
            )
           (SelectionInListModelViewSpec
              name: 'SelectionInListModelView'
              layout: (LayoutFrame 3 0 110 0 208 0 208 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              useIndex: false
              highlightMode: line
            )
           )
         
        )
      )
!

standardMenus
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardMenus
     UISelectionPanel new openInterface:#standardMenus
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardMenus
        window: 
       (WindowSpec
          label: 'Menus'
          name: 'Menus'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 491 269)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'Tool Bar'
              layout: (LayoutFrame 4 0 134 0 129 0 166 0)
              textDefault: true
            )
           (LabelSpec
              label: 'Tool Bar'
              name: 'ToolBarLabel'
              layout: (AlignmentOrigin 4 0 134 0 0 1)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (MenuPanelSpec
              name: 'Menu Bar'
              layout: (LayoutFrame 4 0 188 0 129 0 210 0)
            )
           (LabelSpec
              label: 'Menu Bar'
              name: 'MenuBarLabel'
              layout: (AlignmentOrigin 4 0 187 0 0 1)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (PopUpListSpec
              label: 'PopUp List'
              name: 'PopUp List'
              layout: (LayoutFrame 4 0 3 0 129 0 25 0)
              tabable: true
            )
           (ComboListSpec
              name: 'Combo List'
              layout: (LayoutFrame 4 0 33 0 129 0 53 0)
              useIndex: false
            )
           (ComboBoxSpec
              name: 'Combo Box'
              layout: (LayoutFrame 4 0 61 0 129 0 81 0)
              acceptOnPointerLeave: false
            )
           (ExtendedComboBoxSpec
              name: 'Extended Combo Box'
              layout: (LayoutFrame 4 0 88 0 129 0 108 0)
              miniScrollerHorizontal: true
            )
           (TabViewSpec
              name: 'Tab Header'
              layout: (LayoutFrame 146 0 3 0 281 0 39 0)
            )
           (NoteBookViewSpec
              name: 'Note Book'
              layout: (LayoutFrame 146 0 46 0 281 0 138 0)
            )
           (UIGalleryViewSpec
              name: 'Gallery'
              layout: (LayoutFrame 298 0 3 0 434 0 138 0)
            )
           (ColorMenuSpec
              name: 'ColorMenu'
              layout: (LayoutFrame 143 0 188 0 -46 1.0 210 0)
              labelsAreColored: true
            )
           (LabelSpec
              label: 'Color Menu'
              name: 'Label1'
              layout: (AlignmentOrigin 142 0 187 0 0 1)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           )
         
        )
      )
!

standardMisc
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardMisc
     UISelectionPanel new openInterface:#standardMisc
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardMisc
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 453 289)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'StepSlider'
              name: 'StepSliderLabel'
              layout: (AlignmentOrigin 87 0 9 0 1 0)
              resizeForLabel: true
              canUIDrag: false
            )
           (LabelSpec
              label: 'Slider'
              name: 'SliderLabel'
              layout: (AlignmentOrigin 87 0 35 0 1 0)
              resizeForLabel: true
              canUIDrag: false
            )
           (SliderSpec
              name: 'Slider'
              layout: (LayoutFrame 88 0 34 0 203 0 52 0)
              orientation: horizontal
            )
           (LabelSpec
              label: 'ThumbWheel'
              name: 'ThumbWheelLabel'
              layout: (AlignmentOrigin 88 0 62 0 1 0)
              resizeForLabel: true
              canUIDrag: false
            )
           (ThumbWheelSpec
              name: 'Thumb Wheel'
              layout: (LayoutFrame 88 0 60 0 203 0 80 0)
              orientation: horizontal
            )
           (LabelSpec
              label: 'ScrollBar'
              name: 'ScrollBarLabel'
              layout: (AlignmentOrigin 87 0 103 0 1 0)
              initiallyInvisible: true
              resizeForLabel: true
              canUIDrag: false
            )
           (LabelSpec
              label: 'Scroller'
              name: 'ScrollerLabel'
              layout: (AlignmentOrigin 87 0 130 0 1 0)
              initiallyInvisible: true
              resizeForLabel: true
              canUIDrag: false
            )
           (ScrollerSpec
              name: 'Scroller'
              layout: (LayoutFrame 88 0 127 0 203 0 145 0)
              initiallyInvisible: true
              orientation: horizontal
            )
           (SteppingSliderSpec
              name: 'VStepSlider'
              layout: (LayoutFrame 226 0 6 0 244 0 106 0)
            )
           (SliderSpec
              name: 'VSlider'
              layout: (LayoutFrame 254 0 6 0 272 0 106 0)
            )
           (ThumbWheelSpec
              name: 'VThumbWheel'
              layout: (LayoutFrame 280 0 6 0 298 0 106 0)
            )
           (ScrollerSpec
              name: 'VScroller'
              layout: (LayoutFrame 345 0 6 0 363 0 106 0)
              initiallyInvisible: true
            )
           (LabelSpec
              label: 'Region'
              name: 'RegionLabel'
              layout: (AlignmentOrigin 83 0 177 0 1 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (RegionSpec
              name: 'Region'
              layout: (LayoutFrame 88 0 171 0 203 0 200 0)
              lineWidth: 2
              regionType: ellipse
            )
           (LabelSpec
              label: 'Separator'
              name: 'SeparatorLabel'
              layout: (AlignmentOrigin 83 0 207 0 1 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (DividerSpec
              name: 'Separator'
              layout: (LayoutFrame 88 0 213 0 203 0 217 0)
            )
           (LabelSpec
              label: 'Progress Indicator'
              name: 'ProgressIndicatorsLabel'
              layout: (AlignmentOrigin 333 0 117 0 1 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (ProgressIndicatorSpec
              name: 'Progress Indicator'
              layout: (LayoutFrame 338 0 114 0 433 0 132 0)
            )
           (LabelSpec
              label: 'Round
Progress Indicator'
              name: 'RoundProgressIndicatorsLabel'
              layout: (AlignmentOrigin 333 0 167 0 1 0)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (RoundProgressIndicatorSpec
              name: 'Round Progress Indicator'
              layout: (LayoutFrame 338 0 136 0 425 0 219 0)
              level: 0
              borderWidth: 1
            )
           (ScrollBarSpec
              name: 'ScrollBar'
              layout: (LayoutFrame 88 0 100 0 203 0 118 0)
              initiallyInvisible: true
              orientation: horizontal
            )
           (ScrollBarSpec
              name: 'VScrollBar'
              layout: (LayoutFrame 317 0 6 0 335 0 106 0)
              initiallyInvisible: true
            )
           )
         
        )
      )
!

standardMorphs1
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardMorphs1
     UISelectionPanel new openInterface:#standardMorphs1
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardMorphs1
        window: 
       (WindowSpec
          label: 'Morphs'
          name: 'Morphs'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 419 272)
        )
        component: 
       (SpecCollection
          collection: (
           (ArcMorphSpec
              name: 'Circle'
              layout: (LayoutFrame 3 0 3 0 63 0 63 0)
              line: true
              lineColor: (Color 100.0 0.0 0.0)
            )
           (ArcMorphSpec
              name: 'FilledCircle'
              layout: (LayoutFrame 3 0 70 0 63 0 133 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              fill: true
            )
           (ArcMorphSpec
              name: 'FilledCircleL'
              layout: (LayoutFrame 3 0 143 0 63 0 206 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
            )
           (RectangleMorphSpec
              name: 'RectangleMorph1'
              layout: (LayoutFrame 70 0 3 0 133 0 63 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: false
              lineColor: (Color 100.0 0.0 0.0)
            )
           (RectangleMorphSpec
              name: 'RectangleMorph2'
              layout: (LayoutFrame 70 0 72 0 133 0 135 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              fill: true
            )
           (RectangleMorphSpec
              name: 'RectangleMorph3'
              layout: (LayoutFrame 70 0 139 0 133 0 202 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
            )
           (ArcMorphSpec
              name: 'FilledPieL'
              layout: (LayoutFrame 143 0 143 0 206 0 206 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              line: true
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
              startAngle: -45
              sweepAngle: 270
              pie: true
            )
           (ArcMorphSpec
              name: 'FilledPie'
              layout: (LayoutFrame 143 0 70 0 206 0 133 0)
              foregroundColor: (Color 100.0 100.0 0.0)
              fill: true
              startAngle: -45
              sweepAngle: 270
              pie: true
            )
           (ArcMorphSpec
              name: 'Pie'
              layout: (LayoutFrame 143 0 3 0 206 0 63 0)
              line: true
              lineColor: (Color 100.0 0.0 0.0)
              startAngle: -45
              sweepAngle: 270
              pie: true
            )
           (LineSegmentMorphSpec
              name: 'LineSegmentMorph1'
              foregroundColor: (Color 100.0 100.0 0.0)
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
              startPoint: (Point 214 9)
              endPoint: (Point 254 59)
              showArrow: true
            )
           (LineSegmentMorphSpec
              name: 'Line1'
              foregroundColor: (Color 100.0 100.0 0.0)
              fill: true
              lineColor: (Color 100.0 0.0 0.0)
              startPoint: (Point 214 75)
              endPoint: (Point 254 125)
            )
           (SketchMorphSpec
              name: 'SketchMorph1'
              layout: (LayoutFrame 280 0 10 0 373 0 90 0)
              image: sketchImageIcon
            )
           )
         
        )
      )
!

standardTexts
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardTexts
     UISelectionPanel new openInterface:#standardTexts
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardTexts
        window: 
       (WindowSpec
          label: 'Texts'
          name: 'Texts'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 464 224)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'Text Editor'
              layout: (LayoutFrame 3 0 3 0 208 0 98 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              hasKeyboardFocusInitially: false
            )
           (HTMLViewSpec
              name: 'HTML Browser'
              layout: (LayoutFrame 228 0 3 0 433 0 98 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
            )
           (InputFieldSpec
              name: 'Entry Field'
              layout: (LayoutFrame 3 0 113 0 208 0 135 0)
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnPointerLeave: true
            )
           (FilenameInputFieldSpec
              name: 'Filename Entry Field'
              layout: (LayoutFrame 3 0 141 0 208 0 163 0)
              acceptOnPointerLeave: true
            )
           (FilenameInputFieldSpec
              name: 'Filename + History'
              layout: (LayoutFrame 3 0 171 0 208 0 193 0)
              acceptOnPointerLeave: true
              viewClassName: FilenameWidgetWithHistory
            )
           (LabelSpec
              label: 'Label'
              name: 'Label'
              layout: (LayoutFrame 228 0 113 0 433 0 135 0)
              translateLabel: true
            )
           (LinkButtonSpec
              label: 'LinkButton'
              name: 'LinkButton1'
              layout: (LayoutFrame 228 0 141 0 433 0 163 0)
              translateLabel: true
            )
           )
         
        )
      )
!

standardTrees
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardTrees
     UISelectionPanel new openInterface:#standardTrees
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: standardTrees
        window: 
       (WindowSpec
          label: 'Trees'
          name: 'Trees'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 455 264)
        )
        component: 
       (SpecCollection
          collection: (
           (SelectionInTreeViewSpec
              name: 'Tree List'
              layout: (LayoutFrame 4 0 3 0 209 0 101 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              highlightMode: line
            )
           (FileSelectionTreeSpec
              name: 'File Tree List'
              layout: (LayoutFrame 229 0 3 0 434 0 101 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              highlightMode: line
            )
           (HierarchicalListViewSpec
              name: 'New ModelTree List'
              layout: (LayoutFrame 4 0 110 0 209 0 208 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              highlightMode: line
            )
           )
         
        )
      )
!

standardUserPanel
    "this window spec was automatically generated by the ST/X UIPainter"

    "do not manually edit this - the painter/builder may not be able to
     handle the specification if its corrupted."

    "
     UIPainter new openOnClass:UISelectionPanel andSelector:#standardUserPanel
     UISelectionPanel new openInterface:#standardUserPanel
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #'window:' 
           #(#WindowSpec
              #'name:' 'UserPanel'
              #'layout:' #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #'label:' 'UserPanel'
              #'bounds:' #(#Rectangle 0 0 445 162)
          )
          #'component:' 
           #(#SpecCollection
              #'collection:' 
               #(
                 #(#LabelSpec
                    #'name:' 'helpText'
                    #'layout:' #(#Point 10 0)
                    #'labelChannel:' #userDefinedHelpText
                    #'resizeForLabel:' true
                    #'canUIDrag:' false
                )
              )
          )
      )
! !

!UISelectionPanel class methodsFor:'menus'!

menuSelected

    <resource: #menu>

    ^ #(#Menu #(
                #(#MenuItem
                        #'label:' 'copy'
                        #'value:' #copy
                 )
                #(#MenuItem
                        #'label:' 'cut'
                        #'value:' #cut
                 )
                )
               nil
               nil
        )

    "Modified: / 29.10.1997 / 03:20:30 / cg"
!

menuUnselected
    <resource: #menu>

    ^ #(#Menu #(
                #(#MenuItem
                        #'label:' 'paste'
                        #'value:' #paste
                 )
                )
               nil
               nil
        )

    "Modified: / 29.10.1997 / 03:20:38 / cg"
! !

!UISelectionPanel class methodsFor:'resources'!

classResources
    "my translations are found in the UIPainter classes resources"

    ^ UIPainter classResources 
! !

!UISelectionPanel methodsFor:'actions'!

defineClassAndSelector
    |bd cls sel lbl|

    bd := IdentityDictionary new.
    bd at:#className put:( userClass asValue).
    bd at:#specsKey  put:( (userSpecs  ? '') asValue).
    bd at:#labelsKey put:( (userLabels ? '') asValue).
    bd at:#updateDefaultResources put:(false asValue).

    (self openDialogInterface:#nameAndSelectorSpec withBindings:bd) ifTrue:[
        (      (cls := (bd at:#className) value) notNil
          and:[(sel := (bd at:#specsKey)  value) notNil
          and:[(lbl := (bd at:#labelsKey) value) notNil]]
        ) ifTrue:[
            userClass  := cls.
            userSpecs  := sel.
            userLabels := lbl.

            (bd at:#updateDefaultResources) value ifTrue:[
                UserClass  := userClass.
                UserSpecs  := userSpecs.
                UserLabels := userLabels.
            ]
        ]
    ].
!

paste:something
    "paste something at a point"

    |coll specs point gallerysDevice ext spec|

    clipBoardSpec isNil ifTrue:[
        clipBoardSpec := SpecCollection new.
        clipBoardSpec collection:(OrderedCollection new).
    ].
    coll   := clipBoardSpec collection.
    gallerysDevice := gallery device.

    point  := gallerysDevice translatePoint:(gallerysDevice pointerPosition)
                           fromView:nil
                             toView:(gallery canvas).

    point y < 1 ifTrue:[point y:1].
    ext := gallery extent - (10@10).

    (specs := something) isCollection ifFalse:[
        specs := Array with:something
    ].

    specs do:[:aSpec|
        point x > ext x ifTrue:[point x:1].
        point y > ext y ifTrue:[point y:1].

        spec := aSpec copy.
        spec keepUILayout ifFalse:[
            spec layout:(LayoutOrigin fromPoint:point).
        ].
        coll add:spec.
        point := point + (20@20).
    ].
    gallery update.

    "Modified: / 10.10.2001 / 14:14:36 / cg"
!

raiseMenu
    "can open menu"

    |spec menu value paste|

    spec := self clientSpec value.

    spec notNil ifTrue:[
        menu := self class menuSelected decodeAsLiteralArray.
        self isClipBoard ifFalse:[
            (menu someMenuItemWithValue:#cut) disable.
        ].

        (value := menu startUp) == #cut ifTrue:[
            clipBoardSpec collection remove:spec ifAbsent:nil.
            gallery update.
        ] ifFalse:[
            value == #copy ifTrue:[
                self window setClipboardObject:spec
            ]
        ].
      ^ self
    ].

    self isUserBoard ifTrue:[
        ^ self defineClassAndSelector
    ].

    paste := self window getClipboardObject.

    (self canPaste:paste) ifTrue:[
        menu := self class menuUnselected decodeAsLiteralArray.

        (menu startUp) == #paste ifTrue:[
            self paste:paste
        ]
    ].
! !

!UISelectionPanel methodsFor:'aspects'!

clientSpec
    ^ gallery clientSpecHolder
!

clipBoardSpec
    ^ clipBoardSpec
!

gallery
    ^ gallery
!

galleryList
    ^ gallery listHolder
!

galleryModel
    ^ gallery model

!

majorChannel
    |holder|

    (holder := builder bindingAt:#majorChannel) isNil ifTrue:[
        holder := AspectAdaptor new subject:self; forAspect:#majorSelection.
        builder aspectAt:#majorChannel put:holder.
    ].
    ^ holder
!

majorList
    ^ self class specifications collect:[:el| el first]
!

minorKeys
    ^ gallery minorKeysHolder
! !

!UISelectionPanel methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "one of my models changed its value"

    |label|

    changedObject == self clientSpec  ifTrue:[
        (label := changedObject value) notNil ifTrue:[
            label := 'Widget Gallery: ' , label name.
        ] ifFalse:[
            label := 'Widget Gallery'
        ].
        builder window topView label:(label , ' ')
    ].

    super update:something with:aParameter from:changedObject.
! !

!UISelectionPanel methodsFor:'drag & drop'!

canDropObjects:aCollectionOfDropObjects in:aComponent
    ^ self canPaste:(aCollectionOfDropObjects collect:[:el| el theObject ]).

    "Created: / 13-10-2006 / 15:53:04 / cg"
!

dropObjects:aCollectionOfDropObjects in:aComponent

    |spc top|

    top := DragAndDropManager dragOriginatorQuerySignal query topView.

    top == aComponent topView ifTrue:[
        spc := self clientSpec value.
        spc isNil ifTrue:[^ self].

        (clipBoardSpec collection remove:spc ifAbsent:nil) isNil ifTrue:[
            ^ self
        ].
    ] ifFalse:[
        spc := aCollectionOfDropObjects collect:[:el| el theObject].
    ].
    self paste:spc.

    "Modified: / 18-03-1999 / 18:29:19 / stefan"
    "Created: / 13-10-2006 / 18:25:50 / cg"
! !

!UISelectionPanel methodsFor:'initialization'!

initialize
    |holder|

    super initialize.

    userClass  := UserClass.
    userSpecs  := UserSpecs.
    userLabels := UserLabels.

    gallery := UIGalleryView new.

    gallery           model:(ValueHolder new).
    gallery      listHolder:(ValueHolder new).
    gallery minorKeysHolder:(ValueHolder new).
    gallery    menuSelector:#raiseMenu.

    gallery clientSpecHolder:(holder := ValueHolder new).
    holder  addDependent:self.

    majorSelection := 0.
! !

!UISelectionPanel methodsFor:'queries'!

canPaste:something
    "returns true if something could be paste"

    (self isClipBoard and:[something notNil]) ifTrue:[
        something isCollection ifTrue:[
            something notEmpty ifTrue:[
                ^ (something at:1) isKindOf:UISpecification
            ]
        ] ifFalse:[
            ^ something isKindOf:UISpecification
        ]
    ].
    ^ false
!

isClipBoard
    "returns true if current view is clip board"

    majorSelection ~~ 0 ifTrue:[
        ^ (self majorList at:majorSelection) startsWith:'Clip'
    ].
    ^ false
!

isUserBoard
    "returns true if current view is clip board"

    majorSelection ~~ 0 ifTrue:[
        ^ (self majorList at:majorSelection) startsWith:'User'
    ].
    ^ false
! !

!UISelectionPanel methodsFor:'selection'!

majorSelection
    ^ majorSelection ? 0
!

majorSelection:aSelection
    |spec model|

    (majorSelection == aSelection or:[aSelection == 0]) ifTrue:[
        ^ self
    ].

    gallery builder:nil.
    majorSelection := aSelection.
    spec := ((self class specifications) at:majorSelection) last.

    model := self galleryModel.
    model value:0.
    self minorKeys value:nil.

    spec isSymbol ifFalse:[
        self galleryList  value:(spec collect:[:a| a first]).
        self minorKeys setValue:(spec collect:[:a| a last]).
    ] ifTrue:[
        self perform:spec.
    ].
    model value:1.

    "Modified: / 21.4.1998 / 11:59:08 / cg"
! !

!UISelectionPanel methodsFor:'startup & release'!

closeRequest
    |sav|

    (sav := masterApplication) notNil ifTrue:[
        masterApplication := nil.
        sav closeRequestFor:(self window).
        masterApplication := sav.
    ] ifFalse:[
        super closeRequest.
    ]

    "Modified: 28.7.1997 / 09:44:40 / cg"
!

postOpenWith:aBuilder
    self majorChannel value:1.
    super postOpenWith:aBuilder.
! !

!UISelectionPanel methodsFor:'user defined'!

userDefined
    |cls lbl sel builder|

    cls := self resolveName:userClass.

    (cls notNil and:[(cls respondsTo:userLabels)]) ifTrue:[
        lbl := cls perform:userLabels.
        sel := Array new:(lbl size) withAll:#userDefinedSpec.
        self galleryList value:lbl.
        self minorKeys   value:sel.
    ] ifFalse:[
        builder := UIBuilder new isEditing:true.

        builder application:self.
        gallery builder:builder. 
        self galleryList value:#( '???' ).
        self minorKeys   value:#( standardUserPanel ).
    ]
!

userDefinedHelpText

^ '
no user defined specifications are configured yet. To assign
user defined specifications to the gallery, press the middle
button of your mouse to open a dialog.
'
!

userDefinedSpec
    |cls spc idx|

    cls := self resolveName:userClass.

    (cls notNil and:[(cls respondsTo:userSpecs)]) ifTrue:[
        spc := cls perform:userSpecs.
        idx := self galleryModel value.

        idx <= spc size ifTrue:[
            spc := spc at:idx.
            (cls respondsTo:spc) ifTrue:[
                ^ cls perform:spc
            ]
        ]
    ].
  ^ nil
! !

!UISelectionPanel::UserDefinedGallery class methodsFor:'class initialization'!

initialize
    "initialize my default user-def from the superclasses specs.
     I.e. provide a clocks entry"

    LabelList := self defaultListOfLabels asOrderedCollection.
    SelectorList := self defaultListOfSelectors asOrderedCollection.
    HolderList := OrderedCollection newWithSize:(SelectorList size).
    NextUniqueNumber := 1.

    UISelectionPanel 
        userClass:self
        specSelector:#listOfSelectors
        labelSelector:#listOfLabels.

    "
     self initialize
    "

    "Modified: / 5.12.1997 / 14:25:22 / cg"
    "Created: / 8.12.1997 / 18:49:42 / cg"
! !

!UISelectionPanel::UserDefinedGallery class methodsFor:'defaults'!

defaultListOfLabels
    ^ #( 'Clocks etc.' 'Business Graphics' )

    "Created: / 8.12.1997 / 18:50:06 / cg"
    "Modified: / 16.6.1998 / 10:20:12 / cg"
!

defaultListOfSelectors
    ^ #( clocksSpec businessGraphicsSpec)

    "Modified: / 5.12.1997 / 14:03:55 / cg"
    "Created: / 8.12.1997 / 18:50:21 / cg"
! !

!UISelectionPanel::UserDefinedGallery class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    The standard user-defined selectionPanel entry.
    Here, a single item named 'clocks' is provided, containing
    an analog and digital clock.
    This is a dumb example; the actual user-defined panel may be
    extended dynamically.

    Frameworks which provide additional widgets may dynamically
    add more entries, by sending #addUserSpecHolder:label:
    or #removeUserSpecWithLabel:.
    Typically, this is done when a framework is loaded, by one of the
    frameworks class-initialization methods.

    [start with:]
        UISelectionPanel open

    [author:]
        Claus Gittinger
        Claus Atzkern

    [see also:]
        TabView
        NoteBookView
        UIGalleryView
        UIPainter

"
! !

!UISelectionPanel::UserDefinedGallery class methodsFor:'installation / deinstallation'!

addUserSpecHolder:aValueHolder label:aLabelString
    "add a new entry with the given label.
     The specHolder is typically either a spec, a valueHolder or a block.
     In any case, it should return a valid spec from the #value message.
     This spec is installed under that label."

    |syntheticSelector idx|

    syntheticSelector := ('userSpec' , NextUniqueNumber printString) asSymbol.
    NextUniqueNumber := NextUniqueNumber + 1.

    idx := LabelList indexOf:aLabelString.
    idx ~~ 0 ifTrue:[
        SelectorList at:idx put:syntheticSelector.
        HolderList at:idx put:aValueHolder
    ] ifFalse:[
        LabelList addLast:aLabelString.
        SelectorList addLast:syntheticSelector.
        HolderList addLast:aValueHolder
    ]

    "Modified: / 5.12.1997 / 14:13:17 / cg"
    "Created: / 8.12.1997 / 18:50:55 / cg"
!

removeUserSpecWithLabel:aLabelString
    "remove the spec which was previously installed under the given label"

    |idx|

    idx := LabelList indexOf:aLabelString.
    idx ~~ 0 ifTrue:[
        LabelList removeIndex:idx.
        SelectorList removeIndex:idx.
        HolderList removeIndex:idx
    ].

    "Modified: / 5.12.1997 / 14:13:45 / cg"
    "Created: / 8.12.1997 / 18:51:03 / cg"
! !

!UISelectionPanel::UserDefinedGallery class methodsFor:'user defined gallery'!

businessGraphicsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel::UserDefinedGallery andSelector:#businessGraphicsSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: businessGraphicsSpec
        window: 
       (WindowSpec
          label: 'Interface Builder'
          name: 'Interface Builder'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 394 317)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'PieChart'
              name: 'Label2'
              layout: (LayoutFrame 5 0 5 0 126 0 20 0)
              translateLabel: true
              canUIDrag: false
            )
           (PieChartWidgetSpec
              name: 'PIE Chart'
              layout: (LayoutFrame 15 0 21 0 103 0 141 0)
            )
           (LabelSpec
              label: 'ChartDescription'
              name: 'Label1'
              layout: (LayoutFrame 8 0.0 153 0 131 0 168 0)
              translateLabel: true
              canUIDrag: false
            )
           (ChartDescriptionSpec
              name: 'Chart Legend'
              layout: (LayoutFrame 14 0.0 -9 0.656827 14 0.323684 -9 1.0)
            )
           (LabelSpec
              label: 'BarChart'
              name: 'Label3'
              layout: (LayoutFrame 115 0 5 0 237 0 20 0)
              translateLabel: true
              canUIDrag: false
            )
           (BarChartWidgetSpec
              name: 'Bar Chart'
              layout: (LayoutFrame 121 0 21 0 232 0 141 0)
            )
           )
         
        )
      )
!

clocksSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISelectionPanel::UserDefinedGallery andSelector:#clocksSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: clocksSpec
        window: 
       (WindowSpec
          label: 'Interface Builder'
          name: 'Interface Builder'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 439 319)
        )
        component: 
       (SpecCollection
          collection: (
           (NonScrollableArbitraryComponentSpec
              name: 'Analog Clock'
              layout: (LayoutFrame 15 0 39 0 129 0 151 0)
              hasBorder: false
              component: ClockView
            )
           (NonScrollableArbitraryComponentSpec
              name: 'Digital Clock'
              layout: (LayoutOrigin 15 0 176 0)
              hasBorder: false
              component: DigitalClockView
            )
           (NonScrollableArbitraryComponentSpec
              name: 'Digital Number display'
              layout: (LayoutOrigin 142 0 39 0)
              hasBorder: false
              component: DigitalLedDisplay
            )
           (LabelSpec
              label: 'Analog Clock'
              name: 'Label1'
              layout: (LayoutFrame 15 0 16 0 128 0 38 0)
              translateLabel: true
              adjust: left
              canUIDrag: false
            )
           (LabelSpec
              label: 'Number Display'
              name: 'Label2'
              layout: (LayoutFrame 142 0 16 0 270 0 38 0)
              translateLabel: true
              adjust: left
              canUIDrag: false
            )
           (LabelSpec
              label: 'Digital Clock'
              name: 'Label3'
              layout: (LayoutFrame 15 0 155 0 128 0 177 0)
              translateLabel: true
              adjust: left
              canUIDrag: false
            )
           (MeterWidgetSpec
              name: 'Meter Widget'
              layout: (Rectangle 143 99 259 216)
              model: meterValue
            )
           (LabelSpec
              label: 'Meter Widget'
              name: 'Label4'
              layout: (LayoutFrame 142 0 77 0 269 0 99 0)
              translateLabel: true
              canUIDrag: false
            )
           (MeterClackCounterSpec
              name: 'Meter Clack Counter'
              layout: (Rectangle 291 40 387 72)
              model: model
            )
           (LabelSpec
              label: 'Meter Clack Counter'
              name: 'Label5'
              layout: (LayoutFrame 290 0 16 0 417 0 38 0)
              translateLabel: true
              adjust: left
              canUIDrag: false
            )
           )
         
        )
      )
!

listOfLabels
    ^ LabelList

    "Created: / 5.12.1997 / 13:43:03 / cg"
    "Modified: / 8.12.1997 / 18:51:20 / cg"
!

listOfSelectors
    ^ SelectorList

    "Created: / 5.12.1997 / 13:43:13 / cg"
    "Modified: / 8.12.1997 / 18:51:28 / cg"
! !

!UISelectionPanel::UserDefinedGallery class methodsFor:'user spec access'!

doesNotUnderstand:aMessage
    "catch queries for a userSpec"

    |sel idx|

    ((sel := aMessage selector) startsWith:'userSpec') ifTrue:[
        idx := SelectorList indexOf:sel.
        idx ~~ 0 ifTrue:[
            ^ (HolderList at:idx) value
        ]
    ].
    ^ super doesNotUnderstand:aMessage

    "Modified: / 5.12.1997 / 14:23:24 / cg"
    "Created: / 8.12.1997 / 18:51:50 / cg"
!

respondsTo:aSelector
    "catch queries for a userSpec"

    |idx|

    (aSelector startsWith:'userSpec') ifTrue:[
        idx := Number fromString:(aSelector copyFrom:9).
        idx := SelectorList indexOf:aSelector.
        idx ~~ 0 ifTrue:[^ true].
    ].
    ^ super respondsTo:aSelector

    "Modified: / 5.12.1997 / 14:19:55 / cg"
    "Created: / 8.12.1997 / 18:51:57 / cg"
! !

!UISelectionPanel class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


UISelectionPanel initialize!
UISelectionPanel::UserDefinedGallery initialize!
