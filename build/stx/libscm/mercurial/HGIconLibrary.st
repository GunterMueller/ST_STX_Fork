"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HGIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGIconLibrary class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGIconLibrary class methodsFor:'image specs'!

branch
"      Loaded from: /tmp/full/subversive/branch.gif"

    "
     self branch inspect
     ImageEditor openOnClass:self andSelector:#branch
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class branch'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C@0LC@0LC@0LC@0LC@0LC@0LC@0LC@PEA@0LC@0LC@0LC@0LC@0KAP,LC@0LC@0LC@0LC@0LB0$KC@0LC@0LC@0LC@0LC@,IB00LC@0LC@0LC@0LC@0KBP,L
C@0LC@0LC@0L@P,K@P$AB0,AC@0LC@0L@@,IBP$IBP$IB0@LC@0LC@,F@@,KB0,K@@XKC@0LC@0KBP,LC@0LC@,IB00LC@,KB0\KB0,LB0,KA0,KB00CB (J
B (CC@LJB (JB LLC@ J@ (HC@0LB@(BB  LC@0LB@HHC@0LC@0H@  LC@0LC@0HC@0LC@0LC@ LC@0LC@0LC@0LC@0LC@0LC@0LC@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[160 201 204 175 207 214 198 239 242 96 137 140 178 219 222 246 254 255 235 253 255 211 251 254 86 127 130 226 253 255 202 243 246 103 144 147 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C @N@@8@C @N@G?@?>C?8NC#>?/;>_G08NA@P@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

commit
"      Loaded from: /tmp/full/subversive/commit.gif"

    "
     self commit inspect
     ImageEditor openOnClass:self andSelector:#commit
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class commit'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
F!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF 0A@P$IAQ(ZF!!(ZF!!(ZF DXA1LUFAXTF!!(ZF!!(ZF!!(AFA SEQ VBA(ZF!!(ZF!!$YDQTX
B0LF@@PZF!!(ZF!!(YD!!$ZD1LUFAXDF!!(YFQ$YFQ\WFQ(JEQ V@A(Y@!!\WE1\WE1\YF <XE PZF!!$YFQ$Y@ HYF (UFAX@F!!(ZF!!(ZFP4YF!!LSEQ V@A(ZF!!(Z
F!!$YD@\XB0LVE@ ZF!!(ZF!!(ZF TFF@8CA!!P@F!!(ZF!!(ZF!!(ZAQPTE@0TF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[210 151 15 206 147 26 231 172 171 252 204 69 207 149 10 234 178 36 235 181 26 246 220 131 193 138 7 194 141 20 255 251 239 252 232 179 214 157 24 235 154 154 249 231 172 253 241 199 233 230 213 235 222 212 249 199 199 255 244 215 222 165 23 255 224 139 250 195 38 242 180 180 255 213 97 210 2 1 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@C<@_8A? _>A79?//?^_;8G_ _>@_8@?@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

compare
"      Loaded from: /tmp/full/tortoise/compare.gif"

    "
     self compare inspect
     ImageEditor openOnClass:self andSelector:#compare
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class compare'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BP8@C $@@@@@@@@@@@@@E1PGFAPTE0@@@@@@@@@@BQPGA0\TE@XI@@@@@@@@@@8GB 0MCA\F
C @@@@@@@@@@A0\XFAPGA @@@@@@@@@@@A WB 4RA0XN@@@@@@@@@ALTEAPGEQPCCP@@@@@@@@@@E1PTA XCC0HV@@@@@@@@@@@MC @NCP AA@H@@@@@@@@@
@@@@@@@E@ ,D@ @@@@@@@@@@@@@@@ALBB1@B@@@@@@@@@@@@@@@@D0HKDAX@@@@@@@@@@@@@@@@S@!!DV@@@@@@@@@@@@@@@@@@@BAP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 220 146 4 124 86 4 148 146 148 252 218 148 68 70 68 148 218 252 252 250 252 60 42 4 108 110 108 220 222 220 188 126 4 196 194 196 92 94 92 60 58 60 28 30 28 252 206 108 156 106 4 164 162 164 84 82 84 180 230 252 252 254 252 92 62 4 124 122 124 236 234 236]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@6@G<@?8C? G<@_8C? G?@M>@A<@C8@G0@O@@Lb') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diff
"      Loaded from: /tmp/full/tortoise/diff.gif"

    "
     self diff inspect
     ImageEditor openOnClass:self andSelector:#diff
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class diff'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@VE@@@@@@]C0@@@@@@@@@VL1TT@@@HBP$(@@@@@@@VL1TJB THH@$*AB @@@@VL1T.L"DXJ $IJ"(DG0@@ECL.B# 9DAL_
AB(DC2H@@@@TL# RB X/C1,OABH@@@@@@@T1D@(5M2L+I1\@@@@@@@@%F"$SC"(BNQDW@@@@@@@TL"8$K@XOCQD_JA\@@@@TL!!L,K@(CB1D_@!!<_M @@N@(S
A"</C!!D_@!!<-A0D@@@@!!A#TNM14W@!!<GA0D@@@@@@BL5K0 @@A\GC@D@@@@@@@@@H14@@@@@G@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 4 142 52 4 202 68 100 250 148 4 234 76 84 178 116 44 254 116 4 174 60 60 206 108 4 250 84 68 254 132 60 218 108 4 166 60 28 186 84 28 250 100 4 226 76 156 254 188 140 190 156 60 198 108 60 250 124 100 202 132 76 254 140 76 226 124 52 166 92 44 198 92 28 254 108 212 254 220 4 98 28 60 150 92 52 202 100 28 230 100 4 190 68 4 254 92 52 226 108 52 186 100 20 226 92 188 250 188 100 202 140 52 170 92 12 42 12 4 214 68 124 254 164 4 242 84 84 186 116 52 254 116 4 182 68 76 254 132 20 254 100 164 254 196 84 198 124 68 254 124 84 254 140 60 166 92 36 254 108 60 154 92 12 254 92 60 226 116 60 190 100]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@LLA98O?1??''?>O?0_>A?8O?1??''?>O?0^^@00@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

export
"      Loaded from: /tmp/full/subversive/export.gif"

    "
     self export inspect
     ImageEditor openOnClass:self andSelector:#export
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class export'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
R$)JR$)JR$)JR$)JR$)JR$)JR$)JR$)JR$(C@4)JR$)JR$)JR$)JR$)J@0\CR$)JR$(:C1$OR$(EAPTGA3=JR$)JPT%IRT$&D0DA@PD^JD)JR!!-IRT%GCP@@
@@@@OCMJR$(ZRT%GA XB@ HFB IJR$)JHD%IQ0)GLD$DB QJR$)JR#\\E$\MQ2,UGPQJR$)JR$(6DB8KQ0,4J!!AJR$)JR$)JL"<''NQQBFDT!!R$)JR$)JR!!\H
C@ HKC,RCDMJR$)JR$(=NADQIB$NC$ADR$)JR$)JMQ<"KP$IQ#8IH4)JR$)JR$ %LT!!HRD!!HRD!!JR$)JR$)JR$)JR$)JR$)JR$)JR @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[251 233 158 251 240 180 173 114 18 189 132 22 169 110 17 186 129 21 251 222 133 254 253 239 234 240 250 224 233 250 249 205 95 252 234 183 234 239 251 241 211 115 205 216 236 166 146 102 243 246 251 209 219 238 233 240 251 241 218 131 216 224 239 247 249 252 247 248 252 122 126 127 214 221 236 167 146 102 153 139 110 158 142 107 246 248 252 166 107 16 249 232 148 224 234 250 146 136 113 238 243 251 225 234 249 111 121 134 208 219 238 107 119 136 182 125 21 217 225 238 182 124 20 206 217 236 242 246 252 246 249 252 233 239 251 225 233 250 243 245 251 238 242 251 168 110 17 106 119 137 128 129 124 177 120 19 242 246 251 112 121 135 134 131 121 140 135 117 229 237 250 217 224 238 166 146 101 233 239 250 249 221 122 117 123 131 225 234 250 187 129 21 229 236 250 162 144 104 215 222 237 122 126 128 117 124 131 213 222 236 225 233 249 194 153 32 107 119 137 249 250 252 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@L@@8OO0??#?>O?0?>C?0O>@?8C?0O?@?<C?0@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

hgLogo1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self hgLogo1 inspect
     ImageEditor openOnClass:self andSelector:#hgLogo1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HGIconLibrary hgLogo1'
        ifAbsentPut:[(Depth8Image width:68 height:66) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@TFA0 HA0XEBP(KC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@DBCP8ODADRD1LTEQTTD1LRDQ@VAA\X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A WFQ(PD1,\GQ8_HBD!!HRD"G2L]
IA,SDBT&I0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@WJ@<PF2$*HB,,KBD!!HRD!!HRD!!KB0+HB4\EA@.K0H@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@LLB8HECD2KB0!!H"H"H"H"H"H"H"H"H"D!!KBH3MALOAP(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@STHDBP3HRD!!H"H"H"H"H"H"H"H"H"H"H"H"HRD"H10PM PL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EBA@)HBD!!H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"D!!HA4RC3TL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M0 PGB@!!HRH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"D!!H!!8RG!!D@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C HDC$ HRD"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!HQ8SN#L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C
C0 RL2D"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"KA8UN24@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CC0PDB$+H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"KB4\OS$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@>D  QL"D"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"J3=@PST@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P<RBA,,H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!H!!-BP0L@@@@@@@@@@@@@@@@@@@@@@@@@@@@5
D0 HQBD"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!QTYGR@0@@@@@@@@@@@@@@@@@@@@@@@@@@D$4B@!!JHRH"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H!!R41MS @@@@@@@@@@@@@@@@@@@@@@@@@@NT<HC2L!!H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H 
GUAQT @@@@@@@@@@@@@@@@@@@@@@@EMIU@ OG"D"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HRIKUUX9@@@@@@@@@@@@@@@@@@@@@@@@
U3P9B@!!XHRH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!HSIXVU)[@@@@@@@@@@@@@@@@@@@@@@ARMD@TBC<,H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!HA1\PP\@@@@@@@@@@@@@@@@@@@@@@@IKWU8PEB0!!H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"D!!R"M_XA\@@@@@@@@@@@@@@@@@@@@@@BI!!X$XPX2D"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"D2EVQ%C @@@@@@@@@@@@@@@@@@
@@@@KE9&Y0<$HRD"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HRATZF%D@P@@@@@@@@@L@P@@@@@@@@@ZHF)+J  ^KBH"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!KCD Y&1R@@@@@@A-LF8([ %R@@@@@@A/\GEMD1P_KBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H,R#=2Z!!$@@@@A[!!(?GU ]GD93@@@@@GQ5YWY7M$X KBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"D3EG!!9A0@@CCT\^"@"HRH 
G!!DI@@@@FG-<\W5>S#< KBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HTTRZ''X#@P@IQ"H!!HRD!!HRD"H0!!?@@@@A(A>](FBM%QEHRD"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H!!HAE$]%TBB2$_HRD"H"D,J20  8P@@@@@!!V]Y]''57D1H*HRD"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"HRD DXY6!!8 6IB,"H"D!!^"9.A"JIW@8@@@@@"&BK]''X;^!!BL^"H"H"D!!HRD"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"D J"4STGX:AH4?KBH!!KB4/
#%HW#9BQNP@@@@@X$)NT]''Y6TB@$GB4_HB@"HRD!!HRH"H"H"H"H"H"H"H"H"H"H"H"H"HW(.EX1*]&H5$3<,H"E@%Q\WE1\7 9XS@@@@@@BN%)]8&I%=])*Q
SFL*R5 3HBH!!HRH"H"H"H"H"H"H"H"H"H"H"H"D!!J&8UMG!!6&0Z\EB,!!HRE.T!!]RK3Q\Y1$@@@@@@@@B''Y:_]5* (ZI=Z3-Q$D($GSH!!HRH"H"H"H"H"H"H"
H"H"H"H"HREDK1Q#U''Y_F&]DX2,,J9T''E7<R(:B$@@@@@@@@@@@@UJU])*^I*J")TJ)1*:0,ED, HRH"H"H"H"H"H"H"H"H"H"H!!HABHD72Z](,QO*4OGQ5E
QC0<D&!!"N#D@@@@@@@@@@@@@\2*E^6R) 59EF2BF_XF,DB$ HRH"H"H"H"H"H"H"H"H"H"D NGLTZJ96+1LXY;@-+F21W*R2,5B4C@@@@@@@@@@@@@@@@KV6
-:ZJ''+!!H^ T7ZF-!!OCP!!HRH"H"H"H"H"H"H"H"H"H#MW_829]''YADP@D.+.A_XFF\KQGTU\@@@@@@@@@@@@@@@@@@@AW[#Z#/K6$(2MREI RD"(,H"H"H"H"
H"H"H"H"H"H"D2\8R5A6]&HO@@B>/<A=0\KC1KES@@@@@@@@@@@@@@@@@@@@@@@@@B^HELU;(;I31T0<GBD!!H"H"H"H"H"H"H"H"H"DD[R8+W7[F,3X@@@@@
/$''G2H=S@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D&<''YYV !!X9QRD"H"H"H"H"H"H"H"H!!JUH/F;CF]*/I%P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@EM;2\*8#1U:HRH"H"H"H"H"H"H"HR0(E2!!K27Y6YX$I@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A;]S0HEFL,H"H"
H"H"H"H"H"H,GQ\JD2AV]''''LKP(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F=D0<UL"D"H"H"H"H"H"H"HRE.E0P#UWY6,%$)B0@@
@@@@@@@@@@@@@@@@@@@XU0LMB%HL@@@@@@@@@@@@@@@@@@@@@L7NOEP HRH"H"H"H"H"H"I^EA]WNR*&]''[K31LL@@@@@@@@@@@@@@@@@@@WAC .O@\<M2!!3
B0@@@@@@@@@@@@@@@@@@4G8VGBD!!H"H"H"H"H"H"J18IT&9EHG56(XZIJ@@@@@@@@@@@@@@@@@@LBS8QIA5JG!!9XJQHE@0@@@@@@@@@@@@@@@@AS_#0]KBD"
H"H"H"H"H"0 %Q\WLT.W]''[O26M[@@@@@@@@@@@@@@@@C@8G#BL H"D!!HRH ^"P</ @@@@@@@@@@@@@@@EN#DFL,H"H"H"H"H"H!!J31-I9T G\Y6^\=\U@,@
@@@@@@@@@@@@@@@8DDP HRD!!HRH!!HRD!!HBPO@0@@@@@@@@@@@@@@V2L9HRD"H"H"H"H"HR0Q@5I[H4QC]''X:Y:PDC@@@@@@@@@@@@@@@CQH)H"D!!H"H"H"H"
H"D!!X144B0@@@@@@@@@@@@@NEQ4,HRH"H"H!!HRD"DP(WI1@2X7Y6&Z!!>HA\@@@@@@@@@@@@@@A SF2@!!H"H"H"H"H"H"H"D,EU%N@@@@@@@@@@@@@A4RHBD"
HRH"HB@ R3URE5I.QX1Y]''Z3,\<8F@@@@@@@@@@@@@@@K!!@-KBH"H"H"H"H"H"H!!HBFL4VDA@@@@@@@@@@@KR2P+H"D R2U3/( ''T!!]R[SP-4''Y61DV)!!F4@
@@@@@@@@@@@@@@0*D"H!!H"H"H"H"H"H"HR09QA7O&WL@@@@@@@@@@@THX2D,QX=-I5IRE1\WE5H.L4RY]''ZGIDL5F@@@@@@@@@@@@@@@[!!UFJ2H"H"H"H"H"
H"H,J#@<GV16I@@@@@@@@@@@LQ,!!HSL7E5HWE1\WE1]R[$(4TGY6&3V,]P4@@@@@@@@@@@@@@@AIBCD,H"H"H"H"H"H"HR@VT1(1WGZ]@@@@@@@@@B OR"1E
AUHWE1\WE1\WT"<4LW;F]''4UX6Q.@@@@@@@@@@@@@@@@@B@PGR0"H"H"H"H"H"D,O2YSDS=Q]&\@@@@@@@@@D!!L H@<WT!!\WE1\WE5HJD15H&GY6UWM8JP,@
@@@@@@@@@@@@@@@@\AMDKBH"H"H"H"H!!PB4I#%]FD7#S\@@@@@@@@CTPQBEKB%HWE1\WE1\WU31JG9-6]%5R5L%-@@@@@@@@@@@@@@@@@@AXGS$+H"H"H"H!!
PB@OK1\''FSEDOUX<@@@@@@@@-!!A:H@T''E1\WE1\WE1\GG$)%]''Y_/''1P%P@@@@@@@@@@@@@@@@@@@MWVDB@!!H"H"HRD</&4WE5,S#I]!!+5H@@@@@@M_XDBH2
B!!\WE1\WE5H&IFMDTGY6Y TEOQ4@@@@@@@@@@@@@@@@@@@@@@M$QQB0!!HRD,%U\WE1]-M% ,&4JB@@@@@@@@#EPPH$(WE1\WE5HMO$T-JVU6]&XPI-)0@@@@
@@@@@@@@@@@@@@@@@@@@W+<OR4T HW)3V64JAC%#X:E5(GL@@@@@@@GXD0<*HF9[B"<5D4T_MCJ+]''Y9EQ]%WA @@@@@@@@@@@@@@@@@@@@@@@@@$$(PO4X]
L!!4QD$P2H9AYU]/NC@@@@@@@A@ HBAD-G4,*HBH H6O[]''Y1X"T/''4HB@@@@@@@@@@@@@@@@@@@@@@@@@@@5YGT:WXP_L$T W*RQ)"1(!!5\@@@@@@@@8F0 P
C4, W(&P(4I%1''Y6(+Q3AS)/V0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@S.$N/1,SZ(E&&N)4]XFDD@@@@@@@@@M0#EA)0&=6/ZV-6]''Y6PV]NU3N_/=@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@F7%AM"8E6W8^P,EB0BP@@@@@@@@@@T60]K*I6]''Y61)%8XQ=.@H2]7>AW@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CW
Q(Q%%NG"(L27OE\@@@@@@@@@@@@@3&>O27Y62!!DPO''L@I4*(P-,EI0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@V2 784:U["\@@@@@@@@@@@@@@@@B
7-=D$WY8NC!!FU\/$5+IX/ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ASG>V-*YF2,=R-]>[''"@H@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@V4[[6.#" N''*@ 0@@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[254 254 254 251 251 251 248 248 248 236 236 236 223 223 223 207 207 207 199 199 199 193 193 193 190 190 190 226 226 226 238 238 238 249 249 249 252 252 252 235 235 235 214 214 214 191 191 191 189 189 189 188 188 188 187 187 187 186 186 186 185 185 185 184 184 184 197 197 197 242 242 242 250 250 250 221 221 221 194 194 194 183 183 183 177 177 177 170 170 170 164 164 164 157 157 157 154 154 154 151 151 151 152 152 152 163 163 163 179 179 179 203 203 203 233 233 233 245 245 245 217 217 217 174 174 174 165 165 165 149 149 149 150 150 150 167 167 167 200 200 200 231 231 231 224 224 224 171 171 171 159 159 159 161 161 161 173 173 173 212 212 212 198 198 198 205 205 205 213 213 213 182 182 182 84 84 84 55 55 55 195 195 195 44 44 44 202 202 202 175 175 175 148 148 148 51 51 51 109 109 109 86 86 86 172 172 172 158 158 158 178 178 178 57 57 57 140 140 140 181 181 181 166 166 166 169 169 169 138 138 138 56 56 56 201 201 201 176 176 176 74 74 74 101 101 101 243 243 243 247 247 247 181 181 181 133 133 133 46 46 46 241 241 241 168 168 168 63 63 63 100 100 100 240 240 240 120 120 120 83 83 83 147 147 147 44 44 44 116 116 116 106 106 106 62 62 62 162 162 162 79 79 79 65 65 65 21 21 21 111 111 111 126 126 126 30 30 30 70 70 70 15 15 15 121 121 121 239 239 239 218 218 218 110 110 110 134 134 134 3 3 3 40 40 40 228 228 228 154 154 154 142 142 142 1 1 1 94 94 94 60 60 60 27 27 27 160 160 160 76 76 76 145 145 145 11 11 11 117 117 117 222 222 222 84 84 84 17 17 17 118 118 118 144 144 144 139 139 139 120 120 120 81 81 81 107 107 107 234 234 234 143 143 143 62 62 62 38 38 38 180 180 180 127 127 127 244 244 244 196 196 196 141 141 141 91 91 91 69 69 69 105 105 105 42 42 42 210 210 210 87 87 87 93 93 93 27 27 27 23 23 23 34 34 34 48 48 48 87 87 87 125 125 125 94 94 94 83 83 83 58 58 58 54 54 54 35 35 35 132 132 132 129 129 129 112 112 112 77 77 77 135 135 135 123 123 123 114 114 114 26 26 26 42 42 42 96 96 96 96 96 96 19 19 19 39 39 39 128 128 128 146 146 146 85 85 85 82 82 82 119 119 119 225 225 225 186 186 186 143 143 143 136 136 136 100 100 100 89 89 89 64 64 64 57 57 57 73 73 73 232 232 232 125 125 125 19 19 19 4 4 4 26 26 26 36 36 36 28 28 28 72 72 72 8 8 8 132 132 132 138 138 138 115 115 115 71 71 71 95 95 95 68 68 68 169 169 169 147 147 147 102 102 102 239 239 239 64 64 64 131 131 131 16 16 16 88 88 88 218 218 218 121 121 121 232 232 232 191 191 191 71 71 71 53 53 53 98 98 98 216 216 216 36 36 36 114 114 114 91 91 91 157 157 157 39 39 39 54 54 54 204 204 204 102 102 102 49 49 49 79 79 79 162 162 162 47 47 47 150 150 150 220 220 220]; yourself]
!

hgLogo2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self hgLogo2 inspect
     ImageEditor openOnClass:self andSelector:#hgLogo2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'HGIconLibrary hgLogo2'
        ifAbsentPut:[(Depth8Image new) width: 67; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
?O''7=_S1;>+(9NG 7M3Z6M_S4MCI1,''B0[.8-[V,+J2*)96]%9VP"X^F!!HB@^WM1[6=*YVU!!W55]VUURT$=KR4-KR?;<>__5=OG,:.#$8^C\6=+X5]SP4L''F
1LKA/K"6,*2,+J^''''Y6W%YBI!!8ZB G%9\7E/[6!!%YVE_WU)YT%IRS4=KR4/>?/39=?W4<^3*:NS!!8M3[6-#U5MCM2\[D1LF;.KZ2+J2,**^]''I^U$H&G!!(R@
 G%3\V=/Z&U%XU=]WU%RT%IOS4-K?/;>?O''7=_S1;N+(9NG!!7M/Z5=WS4L7I1,SB0[.8-[V,+J2*)96\%9BP"X^F!!HB@^WM1[61(YVU!!W5-ZU5URT$=KR?;>
?/;<>__5=OG,:.#$8^C\6=+W5=SP3\''F1LSA.;"5,*2,+J^''''Y6W$IBI!!8ZB HA9\7E/ZF!!%YVE]WU5WT%IOS4?>?/;>?/39=?W2<^7*:NS!!8]3[6-_W4=CM
2\[D1LF;.KV2+J2,):^]''I^P$H&G!!(J@^W%3\V=,ZFU%XU=]V%%RT$=O?/;>?/;>?O''7=_S1;>#$9NG!!7M/Z5=_S4L7I1,J<0K^)$(2M#YJV+*> %9BP"X^F
 (A9^WM1[6!!*YVU!!WU5WU5]RS?;>?/;>?/;<>__5</G/:NS$8^G\6=#W5=SP2J:&$8"A\&-&Y&Y&Z7"E$9ZZ%IBI!!8ZB G%9\7E/ZF!!%YVE]WU%WT%K>?/;>
?/;>?/39=?W2<^3,9NS!!8]3[6M_X'')NK^%9NSD1LR$)JR$1LS%Q2"9NR(H&F!!(J@^W%3\V=,ZFU%XU5]U5]R?/;>?/;>?/;>?O''7=_K1;>#$9NG!!7M+E"8!!8
UD!!JSD1LSD1LSD1LSD1JRT1&!!X:Z%X^F (B@^WM1[6=*YVU!!WU5YU?;>?/;>?/;>?/;9>__5<.?/:NS$8NF+#(U\R$)LSD1LSD1LSD1LSD1LSD1JRUQ)#)ZT
!!8ZB^8A9\7E/ZF)%YVE]V5''>?/;>?/;>?/;>?/''9=?S2;>?(9>R^#(ENR$)LSD1LSD1LSD1LSD1LSD1LSD)JSE:H#Y"G!!(J@^W%3\V=(Z&U!!XU5[?/;>?/;>
?/;>?/;>>_''7=OK/;>"+"8UQR$1LSD1LSD1LSD1LSD1LSD1LSD1LSD)IVHEF"(^D (A9^WE1[61%YVE!!W_;>?/;>?/;>?/;>?/;9>__5<.?N"89^R$1LSD1L
SD1LSD1LSD1LSD1LSD1LSD1LSD)VU!!>J!!(ZB G%9\7E/[F!!%XVG>?/;>?/;>?/;>?/;>?/''9=?S2 9M8RT)LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LR%9&
FYRF!!(J@^W%3\V=,Z&U!!?/;>?/;>?/;>?/;>?/;>>_''7_)NNUD)LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1HZS89%8ZD (A9^WM1[6!!%Y_;>?/;>?/;>
?/;>?/;>?/;99(VN 4)LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LR$)+GVNI!!(ZB^7%9\WE/Z&+>?/;>?/;>?/;>?/;>?/;>?)ZM#''ILSD1LSD1LSD1L
SD1LSD1LSD1LSD1LSD1LSD1LSD1LUD(L((&G!!HJ@ GM1\V=(?/;>?/;>?/;>?/;>?/;>?/9>!!X9)SD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD*A
HSJ\"XZD (A9^WE1[?;>?/;>?/;>?/;>?/;>?/;:!!X"NZ41LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1JUGPN_H&I!!(R@ G%9\WG>?/;>?/;>?/;>
?/;>?/;>>GJE#''ILSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD%2IC*W"X&F!!HJ@^W%1?/;>?/;>?/;>?/;>?/;>?/)2MINER$1LSD1LSD1LSD1L
SD1LSD1LSD1LSD1LSD1LSD1LSD1JTT(O(9BI"XZD HA9^_;>?/;>?/;>?/;>?/;>?/;>XB 8&UQJSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LR$18
B$J]%X&I!!(R@ G''>?/;>?/;>?/;>?/;>?/;>?%YQA''Q8RT)LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1L\"\S+9VU"X&G!!HB@?/;>?/;>?/;>?/+:
?/;>?/:4QP<-$51JSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSFID@W>W%YVI!!8ZD O;>?/;>?/;>6Y>Y&Y?]?/;>?!!1@@U:ES$1LSD1LSD1LSD1L
SD1LSD1LSD1LSD1LSD1LSD1LSD1X\@EB(Y^U$H&I!!(S>?/;>?/;:+WIXSD1X^LO>?/:[K0,G^''!!LR$1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LUH D
J:B]%9BP"X^F?/;>?/;>059JR$)JR$12/_;>?#,-@QA:^%QJSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSEFYAA:%''Y6W$IBI!!?;>?/;>:6ILR$1LR$!!I
WB#>?/;LLQ4ABVJNWD%JSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD)L&PTU&*^]''I^U$H''>?/;>?''9"R$1JTYOV.U 4YO;>?$4.D@DAMF-:W%EJR$)JSD1L
SD1LSD1LSD1LSD1LSD1LSD% ZYLDCIF*)96\%9VP?/;>?/8:XD)JQ+S3<N.SLS3>?/;>[Q0Y@PDFHTA0 6YTR$%JSD1LSD1LSD1LSD1LSD1LSD1F+XVA@ !!5
+J*''''Y2W$O;>?/;>KFYJR$3):>/)]B!!+?/;>?/:$FSXYK PA@0<6^(U&SD)JSD1LSD1LSD1LSD1LSD1JQ-ZEW DF[*2,):^]''I_>?/;>?#M)R$)H7?C]$3L]
:?;>?/;>?-4)J!!9FQ#P"CPDON&Y0TT)LSD1LSD1LSD1LSD1LR%#+!!TLAAV6,+J2'')96\?/;>?/:YPWI+UF.E"3 YN/;>?/;>?/;>?*P7F#E@N%24P@XEPHMQ
R$1LSD1LSD1LSD1LSD&C:8D*@PU.-Z2,+J^!!''_;>?/;><B9)E")@PA,_I]7>?/;>?/;>?/;>?.T7D#P<IG+>Y@)& T1JSD1LSD1LSD1LSD1J.^%)E DH[+V5
+J2,):G>?/;>?/;CK@TA@R@)I*7>?/;>?/;>?/;>?/;>?/9>M#T*OIMFPIM R$1LSD1LSD1LSD1LVM7LV@$ACG^8-[J,+J2''?/;>?/;>?/NYPR$=!!^O>?/;>
?/;>?/;>?/;>?/;>?/;]Z1(<H2"Y\D1LSD1LSD1LSD1LR(G6!!TPD@RNL/K"5-Z2,+O;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;6FB(4&W!!L
SD1LSD1LSD1LR$''V9VP3@PL:++2<.KV5+J3>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/80 X9:SD1LSD1LSD1LSDY:=*"ACPD]N,CD/K*8
-[V,?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>!!T^S\$1LSD1LSD1LSD)Q7^U8TPDAP3+H0,R<.;"5-_;>?/;>?/;>?/;>?/;>?/;>=-Z-
'':#L<O+>?/;>?/;>?/;>?/,=&VYLSD1LSD1LSD1J&^/C^!!$AC3E.2\[B0[2:.KW>?/;>?/;>?/;>?/;>?/;+08-8Y&Q$ZW*-8?;>?/;>?/;>?/;>O)% R$1L
SD1LSD1IYNO0Y$$A@TLY/=CI1,SA/K*8?/;>?/;>?/;>?/;>?/;)''8EVSD1JR$1LW(;]?/;>?/;>?/;>?$VNUD)LSD1LSD1JSM73+U8^@P$.P;;Q2,''F0,F<
.?;>?/;>?/;>?/;>?/;8&WIIR$1LSD1LSD)"!!]?>?/;>?/;>?/!!4^$%JSD1LR$)JU-[075ELAPD#G9KW4MGJ2\[D0[3>?/;>?/;>?/;>?/;>+W)LR$1LSD1L
SD1JSGH8?/;>?/;>?/;V"E1JSD)HQ$YH\,3+:XU+H0DARC236MWP4\/I1,SA?/;>?/;>?/;>?/;>3H!!^R$1LSD1LSD1LR$!!:EZ7>?/;>?/;>/XEIR$)L!!\OL
7^''+:=YVRPDANDAN7M_W5MCQ2,''F1O;>?/;>?/;>?/;>?''*ER$)LSD1LSD1LR%RAY!!<>?/;>?/;>>)=$R$%"5/O0<N/+:>-&Y  AB=X_/=3\5=_T4MGK1,S>
?/;>?/;>?/;>?.VH\D%LSD1LSD1LSDZ4.VX$G?#>?/;>?.-4TT)27?C+:>/+:?BEU" A@8 ^T=3\7M#W5=OP4\/I?/;>?/;>?/;>?/;V 6YISD1LSD1LSD%2
:;Q)H1C3?/;>?/:A]D1X7^/+:>/+:>.9UD8B@RQ"J+?!!8]3\6M_W5]CP2?;>?/;>?/;>?/;>.VY&RT1LSD1LR$%\7^._ P<V<?;>?/;]!!VAI3OC+:>/+:?CV
XFPE@P+VH9K(9NG!!7M3Z5=_S4MG>?/;>?/;>?/;>?,1 ^D!!LSD1LRTY:5./+^GHFN/#>?/;>#H-J!!_O+:>/+:?OLWF@N@PWCP3?&:.#$8^G\7M+W5=OP?/;>
?/;>?/;>?/;3OX9LR$)JR&SV:>/006X_LT[>?/;>;)NCQ,3+:>/+:>&9UGPV@PM$''1_N;.3*:NS!!8]3\6-_W4?;>?/;>?/;>?/;>?#!!+ZT1IRUS0<?C%-E1@
H"7L?/;>?,M4!!T#L<?O+7[%:W%0U@PED01Z&=?S1;N+(9NG!!7M/X5=W>?/;>?/;>?/;>?/;)F)&E 5!!L*KRSZ8E@H#P>?/;>?/:("8-$W("AY%9&!!SXF@PU:
5"F+>__5=OG,:.#$8^G\6=+X?/;>?/;>?/;>?/;>?(03MB!!+\&Y&\E8[GV@$?/;>?/;>^(:N"GQ"XFYNKPXA@P?L01BE?/39=?W4<^3*:NS!!8M3[6/;>?/;>
?/;>?/;>?/;>SB$UA@,VFQ<%Q%0''7_;>?/;>?&RA!!R MC $D@PDDGU;6UA2H?/;>?O''7=_S1;N+(9NG 7M/>?/;>?/;>?/;>?/;>?/*(GA4VA0,*J"@8:_;>
?/;>?/9-VG(B@PDDBQ=Q3O9+KS[C?/;>?/;<>__5</G,:.S$8^C\?/;>?/;>?/;>?/;>?/;>?/:LG1 \GS/#?/;>?/;>?/;>3B!!8H D#?/;8:9$$MC#:?/;>
?/;>?/39=?W4<^3(:NS!!8_;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/:_KCX!!FS8:JQ,\TJ#>?/;>?/;>?/;>?O''7=_K1;N+(9NG>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?..(N1 QF#^$7_#>?/;>?/;>?/;>?/;<>__5</G,:N#$?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/39=?W2<^3,9O;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?O''7=_K1;N#>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;<>__5</G/?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/''9=?W2<_;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>>_''7=_K>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;9>__5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 1 0 1 4 0 2 5 1 4 7 3 8 11 6 14 16 13 19 21 18 21 23 20 23 25 22 27 28 26 29 31 29 34 36 33 35 37 34 38 39 37 40 41 39 43 45 42 47 49 46 50 48 51 51 49 53 47 51 53 49 51 49 52 54 51 55 57 54 56 60 62 62 60 64 62 63 61 65 63 66 66 67 65 70 68 71 69 71 68 71 73 70 73 75 72 78 76 80 77 79 76 79 80 78 81 83 80 85 87 84 87 89 86 91 89 93 90 92 90 93 94 92 96 93 97 96 98 95 95 100 102 102 100 103 100 101 99 102 103 101 106 104 108 101 106 108 105 107 104 105 109 112 108 110 107 111 113 110 114 112 116 114 116 113 118 115 119 117 119 116 116 121 124 120 122 119 123 121 125 123 125 122 130 128 132 128 130 127 126 131 134 132 134 131 138 136 140 133 138 140 136 138 135 142 144 141 147 144 148 146 148 145 150 148 152 148 150 147 149 151 148 150 152 149 123 154 214 151 153 150 154 152 156 153 155 152 130 156 211 157 155 159 155 157 153 133 158 213 154 159 161 157 159 156 135 161 216 159 161 158 129 164 217 160 162 159 138 163 218 131 166 219 144 164 214 162 164 161 138 167 215 163 165 162 140 169 217 165 167 164 141 170 218 166 168 165 164 169 172 168 170 167 144 173 221 169 171 168 145 174 222 150 174 217 171 173 170 146 175 224 172 174 171 147 176 225 176 173 177 170 175 177 153 177 220 174 176 173 154 178 221 176 178 175 156 180 223 178 180 177 173 181 189 158 182 225 176 181 183 179 181 178 159 183 227 180 182 179 160 184 228 178 182 197 164 184 222 185 182 187 173 185 198 166 185 223 182 185 181 167 186 224 184 186 183 168 187 225 185 187 184 169 188 226 170 189 227 187 189 186 171 190 228 176 191 211 188 190 187 191 189 193 186 191 193 189 191 188 172 192 230 173 193 231 185 193 201 188 193 196 191 193 190 182 193 220 179 194 226 190 195 198 180 196 228 181 197 216 194 196 193 185 197 211 198 195 200 182 197 230 183 199 231 194 199 202 197 199 196 188 199 226 185 200 233 195 199 215 189 201 215 202 199 204 193 200 222 196 201 204 186 201 234 199 201 198 199 200 210 191 202 230 199 204 207 193 204 231 203 205 202 197 206 214 198 205 227 194 206 233 196 208 235 191 210 236 204 209 212 207 209 206 198 209 237 193 212 238 209 210 220 200 211 238 210 212 209 199 214 234 201 213 240 206 213 235 212 214 211 206 215 223 209 215 217 204 216 230 207 215 236 202 217 237 214 216 212 209 216 238 216 216 227 204 220 240 217 219 216 215 219 235 212 220 241 207 223 243 214 221 243 220 222 218 208 224 244 219 224 227 222 224 221 219 223 240 213 225 239 224 226 223 221 225 242 215 227 241 216 228 243 226 228 224 218 230 244 225 229 245 229 231 228 220 232 246 227 231 247 225 233 242 231 233 230 226 235 244 233 235 232 233 234 245 228 237 245 229 238 247 235 238 234 231 239 248 237 239 236 234 240 242 238 239 249 233 241 250 240 242 238 234 243 251 241 243 240 241 242 252 235 244 252 245 242 247 239 244 247 243 245 241 240 246 248 242 247 249 245 247 244 243 248 251 244 249 252 247 249 246 245 250 253 249 251 248 246 252 254 251 253 249 254 252 255 248 254 255 252 255 251 254 255 252]; mask:((ImageMask new) width: 67; height: 66; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? 
??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? 
??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? 
??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? 
??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? 
??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ??????????? 
??????????? ??????????? ??????????? ??????????? ??????????? ??????????? ') ; yourself); yourself]
!

import
"      Loaded from: /tmp/full/subversive/import.gif"

    "
     self import inspect
     ImageEditor openOnClass:self andSelector:#import
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class import'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
RD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HR@9FH$YFQ$YFQ 9HRD!!HQD!!HQTUEQP$=D")ARD!!HQ@5DRDT!!A!!(#
I $-ND!!HRDPJQD!!EA (FK#L6BR-HRD!!DB@ C@0LHB MCQR\VRD!!HRDPM@@@@@@@WF1 ,O4!!HRD!!HIQ4B@ HBDA87OCEHRD!!HRD DA@PEASH>JALURD!!HRD!!H
RADAAPDOECABFT!!HRD!!HRD!!@@PD_JP0LGC)HRD!!HRD KK2@5A0\4NP\KRD!!HRD!!HQ2P;Q4]GQ4]GQ4!!HRD!!HRD!!HRD!!HRD!!HRD!!HR@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[251 233 158 189 132 22 251 240 180 173 114 18 186 129 21 254 253 239 169 110 17 224 233 250 251 222 133 247 249 252 249 205 95 112 121 135 205 216 236 241 211 115 166 146 101 233 239 251 249 232 148 234 240 250 248 251 253 238 243 251 233 239 250 128 129 124 146 136 113 249 221 122 221 227 237 122 126 127 244 246 249 177 120 19 229 236 250 241 218 131 182 124 20 208 219 238 225 234 249 166 107 16 167 146 102 246 247 250 107 119 136 182 125 21 246 249 251 246 248 251 213 222 236 206 217 236 249 251 254 153 139 110 245 246 249 248 249 253 220 225 235 224 234 250 233 240 251 134 131 121 171 126 41 219 225 236 225 233 249 225 233 250 220 226 236 242 246 252 158 142 107 225 234 250 117 123 131 106 119 137 243 246 251 247 250 252 214 221 236 140 135 117 229 237 250 162 144 104 234 239 251 244 245 249 194 153 32 249 250 252 166 146 102 107 119 137 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@C?0''?G_<]?1??C?<G?0O?@_<A?0O?@?<@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:33:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

merge
"      Loaded from: /tmp/full/subversive/merge.gif"

    "
     self merge inspect
     ImageEditor openOnClass:self andSelector:#merge
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class merge'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
CP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCPLM@04MCP4M@04CCP4MCP4LB@0MCP4MCP0HC@4MCP4MC@,LCP4MCP4LB00MCP4MCP0GA@0LC@0L
A@\LCP4MCP4DC@,KB0,KB0,LA@4MCP4MCPHLC@HK@ 0L@ 4MCP4MCP4MCP4LB00MCP4MCP4MCP4MCP4MC@,LCP4MCP4MCP4MCP4LC@0JC@0LCP4MCP4MCP4M
A DA@PDAA 4MCP4MCP4MCP4@APTE@@4MCP4MCP4MCP4MCP@I@@4MCP4MCP4MCP4MCP4M@@4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[161 110 19 252 232 179 218 198 143 233 205 168 214 189 123 249 231 172 172 116 19 254 248 231 255 251 239 251 232 158 252 237 191 255 244 215 178 129 26 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@B (NC 8NC?8O? _<@N@@8@O8@? A<@C @D@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HGIconLibrary class methodsFor:'image specs - file status'!

fileStatusAdded
    ^ ToolbarIconLibrary iconPlusBlue12x12

    "Created: / 29-11-2013 / 14:23:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStatusClean
    "raise an error: this method should be implemented (TODO)"

    ^ nil

    "Created: / 29-11-2013 / 15:44:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStatusCopied
    "raise an error: this method should be implemented (TODO)"

    ^ nil

    "Created: / 29-11-2013 / 15:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStatusIgnored
    "raise an error: this method should be implemented (TODO)"

    ^ nil

    "Created: / 29-11-2013 / 15:45:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStatusMissing
    "raise an error: this method should be implemented (TODO)"

    ^ nil

    "Created: / 29-11-2013 / 15:45:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStatusModified
    "raise an error: this method should be implemented (TODO)"

    ^ nil

    "Created: / 29-11-2013 / 15:47:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStatusNotTracked
    "raise an error: this method should be implemented (TODO)"

    ^ nil

    "Created: / 29-11-2013 / 15:45:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileStatusRemoved
    ^ ToolbarIconLibrary iconMinusRed12x12

    "Created: / 29-11-2013 / 14:24:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Path: stx/libscm/mercurial/HGIconLibrary.st, Version: 1.0, User: cg, Time: 2015-07-27T20:09:33.748+02$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

