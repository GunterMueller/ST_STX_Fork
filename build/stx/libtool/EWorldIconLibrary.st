"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

XPToolbarIconLibrary subclass:#EWorldIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!EWorldIconLibrary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
     Unfinished - Under construction.

    This is a style specific icon library for a fun look.

    Never access this iconlibrary directly from an application -
    always use ToolbarIconLibrary, which is an alias to one of the style specific
    icon libs.

     ToolbarIconLibrary := EWorldIconLibrary
     ToolbarIconLibrary := XPToolbarIconLibrary
     ToolbarIconLibrary := VistaToolbarIconLibrary
"
! !

!EWorldIconLibrary class methodsFor:'image specs'!

editor32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self editor32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#editor32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'EWorldIconLibrary class editor32x32Icon'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@1HREAPR@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LRD!!8EC1PC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@1HRD!!XV
C0TEE0LC@0LC@0LC@0LC@0LC@1HRD!!HRD!!PTB0,RFP0^AP<T@0LC@1HRD!!HRD!!HRD!!PTE@,VE!!$LC@@PBA4VGA$VEAHC@0LCEA\VE  HF@PLC@0@@A0PDA@P
GAXNEQTVAA$R@0LC@0LTC@@@@@@@@@@@@@@@GA0\D@@VBQTUA!!TRD!!HC@0LC@1HL@@@@@@@@@@@@GA0\GA@@B0$FEQTIF1HC@0LC@0LCD!! @@@@@@@@@GA0\
GA0PGAXBA XUC!!XVD LC@0LC@0LRB@@@@@@@GA0\GA0PDA@LA1DAEQXXDPPR@0LC@0LC@1HV@@@@GA0\GA0PDA@PB!!XYDQ(VCADQCAHC@0LC@0LCD ,\GA0\
GA0PDA@PD@(GD!!PYC@(QDQDGD LC@0LC@0LRE@@\GA0PDA@PDA@PCQ(DB 4QDQDQDQ0R@0LC@0LC@0LT@A@PDA@PDA@PB (JCQDQDQDQDQDQDQPC@0LC@0LC
@1HZDA@PDA@PB (QDP4QDQDQDQDQDQDQEAHC@0LC@0LCD 0PDA@PB (QDP4QDQDQDQDQDQDQDQDVD LC@0LC@0LRA@4PB (QDP4QDQDQDQDQDQDQDQDQDQ$R
@0LC@0LC@1HYCP(QDQDQDQDQDQDQDQDQDQDQDQDQCAHC@0LC@0LCD!!XQDP4QDQDQDQDQDQDQDQDQDQDQDQDGD LC@0LC@0LRE!!DQDQDQDQDQDQDQDQDQDQDQ
DQDQDP(R@0LC@0LC@1HKDQDQDQDQDQDQDQDQDQDQDQDJB (QDQPC@0LC@0LC@1PQDQDQDQDQDQDQDQDQDQDVE!!$YBA$YEAHC@0LC@0LCE@(QDQDQDQDQDQDQ
DQDQDP0HDA@PDA@TD LC@0LC@0LRGADQDQDQDQDQDQDQDQDQDQXPDA@PCAPC@0LC@0LC@1H\DQDQDQDQDQDQDQDQDQDQF  PDA@VD LC@0LC@0LCD \QDQDQ
DQDQDQDQDQDQDQDQE!!@PCAHC@0LC@0LC@0LRCADQDQDQDQDQDQDQDQDQDQDVDA@TD LC@0LC@0LC@1HDDQDQDQDQDQDQDQDQDQDQDQ$SEAHC@0LC@0LC@0LC
D!!$QDQDQDQDQDQDQDQDQDQDQE!!PR@0LC@0LC@0LC@0LRE!!DQDQDQDQDQDQDQDP(\F 0TD LC@0LC@0LC@0LC@1HKDQDQDQ0ZCA$VE!!PTEAHRD!!HC@0LC@0LC
@0LC@0LC@1PVB1PTD!!HRD!!HR@0LC@0LC@0LC@0LC@0LC@0@a') ; colorMapFromArray:#[212 159 170 255 255 170 212 191 85 202 226 255 132 132 132 255 95 85 255 255 85 188 187 187 85 95 170 212 159 85 221 221 221 68 68 68 168 159 167 255 204 255 170 159 85 212 95 85 204 204 255 255 253 247 0 0 0 170 159 255 34 34 34 255 191 85 85 90 85 85 63 85 170 95 170 118 118 117 170 170 170 42 63 0 207 204 196 170 95 85 170 63 85]; mask:((Depth1Image new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@_@@@@O0@@@_<@@_??C????0????8O???>C???>@???? O???8C???>@???? O???8A???>@_???0G???<A????@_???0G???<A????@_???0C???>@??
?? O???0C???<@???>@O??? C???0@???8@O??<@C??>@@_?@@@b') ; yourself); yourself]
!

imageEditor32x32Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self imageEditor32x32Icon2 inspect
     ImageEditor openOnClass:self andSelector:#imageEditor32x32Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'EWorldIconLibrary class imageEditor32x32Icon2'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@NS$9NS$9NS$9NS$9@  B@#$@@@@@@@@@@@@@@@@@@@@9NS$9NS$9NS$9@ H G3 BNP@@@@@@@@@@@@@@@@@@@C$9NS$9NS$@@ HO
AR$_G2@9@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EB@(JKQ<)BC$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(.IP8EH@ BNP@@@@@@@@@@@@@@@@@@@@@@@@@G
C ,IMA(#BPXI@#$9@@@@@@@@@@@@@@LGC 4FB $EFA0XBBLZF"<#B@HBNS$@@@@@@@4IBPTXFA ]GR,''D1LLD0<(IA(ZJBXBNS$9NP@@@@@@AS@3KALSD00L
C@0LC@0EMRP$F#DH@#$9NS$9@@@@@@@FJ1LSD00LC@0LC@0YF0,AL!!(%CP@@NS$9NS$@@@@@@@,]CALSH!!0\C@0LDA$XB \FDPX@@@@@@C$9NP@@@@@@A14L
CA J@0,EDA$YM HTBP4[A @@@@@@NS$9@@@@@@@@G@0"B DA@PX"FQ$KA!!$A@P8J@@@@@@@9NS$@@@@@@@@JI0TA@PDA@P<P@PDA@PDA@0$@@@@@@C$9NP@@
@@@@@@XXA DA@PDACP(A@PDACP$IAP@@@@@@NS$9@@@@@@@@B0 NA ,AB XAC0LA@P(!!EQ8V@@@@@@@9NS$@@@@@@@@GB@<QCP8OAP$TCPDKHPPDAAX@@@@@
@C$9NP@@@@@@@@@QF0XEAP,NB04I@1XUA@PDE \@@@@@NS$9@@@@@@@@@@T7C $MA0\G@0(ED PDA@PRC @@@@@9NS$@@@@@@@@@BP,GDA@C@0LAC"XUA@PD
AAHK@@@@@C$9NP@@@@@@@@@JCP\C@04JA 8JD PDA@PDJ 4@@@@@NS$9@@@@@@@@@@XF@PLIE!!HRD!!HDA@PDEQT^BP@@@@@9NS$@@@@@@@@@CP(ABQ8DA@PD
A@PDA@PRD TE@@@@@C$9NP@@@@@@@@@NBP4RA@PDA@PUEQTRD!!HRC0,@@@@@NS$9@@@@@@@@@@@TE!!T*G!!XVE"TEBPXMB0,@@@@@@@@9NS$@@@@@@@@@@@<T
DPTJA ,G@@@@@@@@@@@@@@@@NS$9NP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C$9NS$9@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@9NS$9NS$9
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C$9NS$9NS$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@NS$9NS$9NP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@9
NS$9NS$9@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C$9NP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 17 17 17 238 238 238 102 255 51 102 102 102 153 153 153 221 221 221 34 34 34 119 119 119 136 136 136 187 187 187 153 204 255 170 170 170 204 204 204 85 85 85 204 204 255 68 68 68 51 153 51 102 204 255 51 51 51 102 204 51 51 102 51 255 204 255 51 102 102 204 255 255 255 204 51 153 153 204 102 102 153 51 102 153 51 153 0 255 102 102 102 51 51 51 102 0 102 153 153 204 153 51 255 255 102 102 102 51 51 51 0 102 153 204 204 204 51 204 102 102 102 153 51 51 153 204 51 204 255 153 51 51 153 102 0 255 255 51 0 153 204 153 102 51 255 255 153 51 153 255 153 153 51 204 204 102 153 204 204 204 153 204 153 102 102 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@G @@@G8@@@G>@@@A? @@@_8@@A?<@C???@_???@G??? A??? @_??0@G??<@@???@@O??0@C??<@@???@@O??0@A??>@@_?? @G??8@A??>@@_?? @G?
?8@A??>@@O?>@@C?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
! !

!EWorldIconLibrary class methodsFor:'image specs-32x32'!

fileBrowser32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileBrowser32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#fileBrowser32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'EWorldIconLibrary class fileBrowser32x32Icon'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
HRD!!HRD!!HRD!!HRD!!HRD!!HPHB@"DB@"D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HPHB@ \Q@ T[C H!!HRD!!HRD!!HRD!!HRD!!HRD!!HRDBHPHB@ 8BA00RAQ4SGPHB
HRD!!HRD!!HRDB@ H!!HRDBHPHB@ TEB@(ECA$LD@\ID0\B@"D!!HRD!!HPHEDP8B@ HBC!!DNB@LMCPXID!!$QB!!POF1LE@ H!!HRD!!@!!@LCADEA04ED 0PCPLFA0(O
DQHO@PLABQLSC HBHRDBD@0LCA\ED1TSDP0RBP<PD@<JBQ PC0,CA $_A0H!!HPHPC@0LE0<ABQLUBQDWDR@LD $F@P$PC0DKA0 OARDB@!!@LC@0WBP,CB $M
D0<RC@0YDP\FAADRC \OA PGHPTHAQ0LC@0\B@(C@04HEP$PC@0QA 4IAP J@PPA@P\!!A0LABQ@RC@0VG!!@MB1POD1THCADGB@$FA@PAA@PAARDGB0LC@P$Z
E 0LE!! P@PLIEP GA0<AA@DA@PPJB DEHP\KC0DC@0DHF!!XLCAHO@0 EBP(AA@DA@PPFA0HI@PT!!A1PNA0<D@0,JDA VG TIC0XD@PDAA@PJA08ECPDAC"DG
B0TJA@$ME@LKCPTHB DD@PDAA@DJB@8GCPDD@PDNHP\KAP(C@0XIB!!PCB@XD@PDDA@XOAPTIA PD@PDAA 8!!A0,GB LC@0LIAP,IA DD@P(H@ 8O@PPA@PDA
@PDF@"DGB0\M@0LC@0(EB0$F@P4E@ TM@PPA@PDA@PPA@P(BHP\KA $J@0LCB TKB@XAAPTM@PPA@PDA@PPACP AB H!!A0,CB04IA@LJA0,IA DF@PPA@PDA
@PPAC0TNBPPJ@"DEB0LC@0PIB 4GB0 F@PDA@PDAA@PFBPTEC0XDA@4BHPTK@0LC@0LJAP KB@XA@PDAA@DJB@TGCPDD@PDDCPH!!A0LC@0LC@0LTE@,HA DA
A@XOAP8HA PD@PDA@PPM@"DN@PLC@0LC@0LCB0 F@P(HC 8OA PA@PDA@PPAB \BHPHNCP,C@0LC@0LKB@XDB@8O@PPA@PDA@PPACP\B@"D!!HRDBA1PC@0LC
@0,HA DF@PPA@PDA@PPFC0TB@"D!!HRD!!HRDBC 4C@0LCB0 F@PDA@PDAA@PJB@8B@"D!!HRD!!HRD!!HRDB@  T@0LKB@XA@PDAA@DJB@HB@"D!!HRD!!HRD!!HRD!!
HRD!!@ 8A@0,HA DAA@DMAPHBHRD!!HRD!!HRD!!HRD!!HRD!!HRD!!@ HMB0 AA@XOAPHBHRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HPHIB@(IC HBHRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HPHBC HBHRD!!HRD!!HRD!!HRD!!HRD!!HP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 187 187 187 17 17 17 255 255 255 204 204 204 51 51 51 170 170 170 68 68 68 85 85 85 102 102 102 153 153 153 238 238 238 255 255 153 136 136 136 34 34 34 119 119 119 102 102 51 153 153 102 204 204 102 102 102 153 221 221 221 153 153 204 255 204 102 255 255 102 153 153 51 255 255 204 153 102 51 51 102 102 204 153 102 51 51 102 204 153 51 153 204 255 204 204 153 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@C,@@@C?0@@K??@NK??<C????0?????O????3????=?????_????7????=?????_????7????=?????_????7????=?????_????7????=?????_????7??
??=?????_????!!???? O??? A??? @G??@@@??@@@C?@@@@_@@@b') ; yourself); yourself]
!

fileSave32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileSave32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#fileSave32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'EWorldIconLibrary class fileSave32x32Icon'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\GA0\GA0\GBP$IBP$IBP$IBP$IA0$P
D@$GE1\WE1\WA1@VEALMC (JA@HB@ HEAPTA@PDODQDQD \WE1\WA0$KA!!TH@ HB@ HEAPTE@PDA@PDA@P4QEAPRBQ\WE1\ID XFEP,D@ HB@ TEAPDA@PDA
@PDAB!!DHB0XPA1\WE1@FA XFB0PBA@PDA@PDA@PDB (D@PDDB@XFA!!PGE1\WD@XFA XKA@PMCP4MCP8NC (JB PA@PTKA XCB0\WE1\PA XFA ,D@ HBAPTE
@PDA@PDA@PDA@P FA LHA1\WE1@FA XFB0PBAPTE@PDA@PDA@PDA@PDAB@XC@0 GE1\WD@XFA XKA@HB@ HB@ PDA@(JC (A@PDHA LCDP\WE1\PA XFA ,D
AP8MCP8NC (JB PBAPDA@P<R@0LRA1\WE1@FA LCB@(EAPTE@PDA@PDA@PDA@PDAD1HC@1HGE1\WD@XC@0LHB DA@PDA@PDA@PDA@PTBA@8KCPLCCP\WE1\P
A LC@1DOB (JB 8MCQLOB@ HB@ QDQLC@0LFA1\WE1@C@0LCA!!DHDQDQC1HRCPXF@0LC@0LC@0LC@0XGE1\WBPXC@0LCC@LCA XFCQHRDQDQB@ HB@ K@0LC
A $WE1\IA LC@0XHB0,KB0 OC1LMC 8D@ TEAP F@0LCBQ\WE0$C@0LCC0 JB PD@ HEAPTEAPPNC PAC04DA@LIE1\WBPLC@0POD0PDA@PB@ HB@ TJE@<H
D0DSD 0D@1@WE1\I@0LCC@<SA@PD@ HB@ HEAP(HA@8O@P4OC@PJDA\WE0$CA@LLD!!LBA@PB@ HB@ TEA@ DC <ACQDLA@PTE1\WBPLDA@0RC0HD@ HB@ HE
APTBB0(NC0DNC00DAAPWE1\I@0PDCAHO@ HB@ HBAPTEAPHKB 8H@P(HC@PLEA\WE0$CA@PLD0<B@ HB@ HEAPTEAP JB  AA@ LC@0KE1\WBPXLA@0MC0HB
@ HBAPTEAPDEB@(JB0DBB@0LC@,WE1\GA 0DC@4H@ HB@ HEAPTE@PDHB0,K@PTHC@0LB1\WE0\FC@0LA  E@ TEAPDA@PDA@PHD@ TA@ ,MD0 IE1\WA04L
A@PFB0(NC 4MCQLSC0 HB0,TD@$IA0\GA0\WE1\GDAPPBP$GA0\GA0\GA0\GA0\GA0\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\W
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 221 221 221 204 153 204 204 204 204 238 238 238 153 153 204 17 17 17 102 102 102 34 34 34 187 187 187 85 85 85 204 204 255 153 153 153 170 170 170 119 119 119 51 51 51 102 102 153 153 102 153 136 136 136 68 68 68 153 102 204 51 51 102 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@O???8G???>G????!!????<_????G????1????<_????G????1????<_????G????1????<_????G????1????<_????G????1????<_????G??
??1????<_????G????1????<_????G????1???0@@@@@@@@@@@@b') ; yourself); yourself]
!

imageEditor32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self imageEditor32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#imageEditor32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'EWorldIconLibrary class imageEditor32x32Icon'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9@  B@#$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9@ H G3 BNS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$B@ HO
AR$_G2@9NS$9NS$9NS$9NS$9@ HB@ HB@ HHBADEB@(JKQ<)BC$9NPHB@ HB@ HBBAPQC0TJA 4KA0LA@P(.IP8EH@ BNS$9B@TJA 4KC \C@PDA@PDA@PDG
C ,IMA(#BPXI@#$9NS$T@PDA@PDA@PLGC 4FB $EFA0XBBLZF"<#B@HBNS$9NP G@P4IBPTXFA ]GR,''D1LLD0<(IA(ZJBXBNS$9NS$9@ ,AAS@3KALSD00L
C@0LC@0EMRP$F#DH@#$9NS$9NS$BA DFJ1LSD00LC@0LC@0YF0,AL!!(%CPTBNS$9NS$9NPHI@P,]CALSH!!0\C@0LDA$XB \FDPXAB H9NS$9NS$9@ <AA14L
CA J@0,EDA$YM HTBP4[A DF@#$9NS$9NS$BE@DAG@0"B DA@PX"FQ$KA!!$A@P8J@P,BNS$9NS$9NS$H@0DJI0TA@PDA@P<P@PDA@PDA@0$AC H9NS$9NS$9
NPHN@PXXA DA@PDACP(A@PDACP$IAPDCBC$9NS$9NS$9@ ,AB0 NA ,AB XAC0LA@P(!!EQ8V@PDTNS$9NS$9NS$BA DGB@<QCP8OAP$TCPDKHPPDAAXA@P<B
NS$9NS$9NPHI@PLQF0XEAP,NB04I@1XUA@PDE \ABPH9NS$9NS$9@!!DA@PT7C $MA0\G@0(ED PDA@PRC DF@#$9NS$9NS$9B@DABP,GDA@C@0LAC"XUA@PD
AAHK@P,BNS$9NS$9NS$BA0DJCP\C@04JA 8JD PDA@PDJ 4AA0H9NS$9NS$9NPHK@PXF@PLIE!!HRD!!HDA@PDEQT^BPLGBC$9NS$9NS$9@ XACP(ABQ8DA@PD
A@PDA@PRDPTEAPTH@#$9NS$9NS$BBPDNBP4RA@PDA@PUEQTRD"DODA@PF0H9NS$9NS$9NPHO@P\TE!!T*G!!XVE"TEBPXMB0TPDA@O@#$9NS$9NS$9@!!PC@0<T
DPTJA ,G@PDA@PDACP(CF0H9NS$9NS$9NS$9B@8C@0\C@0DA@PDA@PDA@PDNGA,H@#$9NS$9NS$9NS$BB1\CE1\C@0LC@0LA@PDA@P\QB@H9NS$9NS$9NS$9
NPHFE0\G@0LCE0LC@PDA@PLCCPHBNS$9NS$9NS$9NS$9@ (WA0\GE0LC@0\KA $ODP B@#$9NS$9NS$9NS$9NS$BAQ\PD@8MB TQB@HB@ HBNS$9NS$9NS$9
NS$9NS$9NPHTC1DTB@HB@ H9NS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 17 17 17 238 238 238 102 255 51 102 102 102 153 153 153 221 221 221 34 34 34 119 119 119 136 136 136 187 187 187 153 204 255 170 170 170 204 204 204 85 85 85 204 204 255 68 68 68 51 153 51 102 204 255 51 51 51 102 204 51 51 102 51 255 204 255 51 102 102 204 255 255 255 204 51 153 153 204 102 102 153 51 102 153 51 153 0 255 102 102 102 51 51 51 102 0 102 153 153 204 153 51 255 255 102 102 102 51 51 51 0 102 153 204 204 204 51 204 102 102 102 153 51 51 153 204 51 204 255 153 51 51 153 102 0 255 255 51 0 153 204 153 102 51 255 255 153 51 153 255 153 153 51 204 204 102 153 204 204 204 153 204 153 102 102 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@G @@@G8@@@O>@@???#????8????<O????C????@???? O???8C???>@???? O???8A???>@_??? G???8A????@_???0G???<@????@O???0C???<@??
?? O???0C???<@???>@G??? A???0@_??8@G??<@A??8@@_>@@@b') ; yourself); yourself]
! !

!EWorldIconLibrary class methodsFor:'image specs-tools-Launcher'!

saveImageIcon
    <resource: #programImage>

    ^ self fileSave32x32Icon
!

startFileBrowserIcon
    <resource: #programImage>

    ^ self fileBrowser32x32Icon
!

startImageEditorIcon
    <resource: #programImage>

    ^ self imageEditor32x32Icon2
!

startNewFileBrowserIcon
    <resource: #programImage>

    ^ self fileBrowser32x32Icon
! !

!EWorldIconLibrary class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/EWorldIconLibrary.st,v 1.2 2014-11-23 13:56:47 cg Exp $'
!

version_SVN
    ^ '$Id: EWorldIconLibrary.st,v 1.2 2014-11-23 13:56:47 cg Exp $'
! !

