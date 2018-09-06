"
 COPYRIGHT (c) 2014 by eXept Software AG
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

XPToolbarIconLibrary subclass:#MacOSXToolbarIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!MacOSXToolbarIconLibrary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
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
    ToolbarIconLibrary := MacOSXToolbarIconLibrary

    This is a style specific icon library for a mac-OSX look (pre yosemity).

    Never access this iconlibrary directly from an application -
    always use ToolbarIconLibrary, which is an alias to one of the style specific
    icon libs.

    Notice and Warning:
        only redefine existing icons here; never add ionly to here.
        For every icon-method here, there MUST be a corresponding (albeit
        possibly ugly) icon-method in GenericToolBarIcon.

"
! !

!MacOSXToolbarIconLibrary class methodsFor:'image specs'!

comboViewActiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self comboViewActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#comboViewActiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary comboViewActiveIcon'
        ifAbsentPut:[(Depth8Image width:16 height:18) bits:(ByteArray fromPackedString:'
ITI^W%9BD4IBITIBLQU@@DXIQ$Y!!BTYFQ$Y!!XRQ(TSX$I@PDIDEAPTERIBQAAFUOO%AP@@@>HREP@C9PTEA(X#-)G#,^N19)G%(;G!!9)G"49U&Q$NVQVNUYV
NS%VYC$JJB!!TUB (UEP(UB!!TJEP(A5=_EAP4L =_W3AJDE=_E@ILZ$1*M2)MCB1MJ!!YLSD0<Y&Y&F6Y]I1D5A%4[F6X[GUTXJQ!!UFD$ WD$XUQ!!UUVL&I TE
I"XEI"XEI TEQBXWH#<A@S<AO3<?H D?@PD"XE-+G6-+G6-[V1=+V1=+V0M''Y6]''L6]KY6]''R6\\L5 :RE]HRD!!HCT MCU\.U5\HF!!$YFQ$YFQ$YFQ$YNB-E
S$]YC%%YK2=YVU%YK09SP2L@') colorMapFromArray:#[101 172 248 53 140 250 61 135 247 46 108 250 105 175 248 57 144 249 207 230 254 64 139 247 43 118 250 109 178 248 67 143 247 233 232 233 89 165 249 43 131 251 43 93 250 93 168 249 146 198 251 225 240 254 255 255 255 80 159 246 78 159 248 141 189 240 82 161 249 49 116 249 62 149 249 42 128 251 117 150 239 67 152 248 45 133 250 55 125 248 95 170 248 49 136 250 198 225 253 101 172 247 52 140 250 181 192 232 105 175 247 81 160 247 57 143 249 207 230 253 84 163 248 61 147 248 212 232 253 42 124 251 88 165 249 70 147 246 43 130 251 42 93 250 92 168 249 99 167 243 221 237 253 46 134 251 146 197 251 225 239 254 193 212 235 81 161 249 42 127 251 90 167 248 65 117 245 95 169 248 57 130 247 186 186 186 100 172 247 52 140 249 194 213 236 104 175 247 81 160 246 111 141 235 56 143 249 42 116 251 109 177 247 185 197 236 43 130 250 68 152 249 220 237 253 46 134 250 72 156 248 224 239 254 77 118 242 137 184 240 101 173 248 108 171 243 105 176 248 61 107 244 85 163 249 62 147 249 90 166 248 44 131 251 46 130 250 43 94 250 95 169 247 48 136 249 197 224 253 74 157 248 80 160 246 78 160 248 48 111 249 108 177 247 91 159 243 52 121 249 91 167 249 93 167 247 67 152 249 46 133 250 97 170 247 96 170 248 72 155 248 49 137 250] mask:((Depth1Image width:16 height:18) bits:(ByteArray fromPackedString:'??;????????????????????????????????????????????>'); yourself); yourself]
!

comboViewDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self comboViewDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#comboViewDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary comboViewDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:18) bits:(ByteArray fromPackedString:'
@@DA@PDA@PDA@@DA@ LDAPXGA XFA0XFA XFA  IB ,HB@ HB@0LC@0HB@ LB@4NC0TEAPTOAPTEAP<EAPTID@HIBPHI@ $IBPHBBP$IBQDMD 4MCP4RCQHR
CP4RCP4SDA@TEA@PEAPPEA@TDAPPEPDAE!!XWFA$A@Q$XE0DAE!!([GA,\@A4^G1<^GR@[F1,!!H"H"H"H#IA8^IBL"H"H"IRX''I"\&I2H(JRH''I"\&I"(UER,+
EQT+EQT+ER,+EQT,F!!(ZF!!(ZF!!(ZF!!(ZF!!(ZKR8/K2</K2<.K"</K"</K#@1LSD1HSD!!LSD1HSD1HRT2L2T3L3L3ISL%IRT%IRT4MSH2L#H2L#H2L#H2J#X7
LS 9N#$9N#(9NS$9N#(;H30E') colorMapFromArray:#[157 157 157 157 157 157 162 162 162 217 217 217 232 232 232 164 164 164 166 166 166 167 167 167 165 165 165 162 162 162 164 164 164 231 231 231 165 165 165 161 161 161 215 215 215 163 163 163 158 158 158 151 151 151 160 160 160 150 150 150 159 159 159 148 148 148 156 156 156 221 221 221 244 244 244 161 161 161 147 147 147 155 155 155 154 154 154 241 241 241 245 245 245 160 160 160 158 158 158 144 144 144 153 153 153 155 155 155 240 240 240 143 143 143 150 150 150 151 151 151 237 237 237 236 236 236 141 141 141 149 149 149 139 139 139 137 137 137 145 145 145 145 145 145 136 136 136 144 144 144 142 142 142 142 142 142 139 139 139 159 159 159 141 141 141 138 138 138 226 226 226 132 132 132 131 131 131 138 138 138 223 223 223] mask:((Depth1Image width:16 height:18) bits:(ByteArray fromPackedString:'??;????????????????????????????????????????????>'); yourself); yourself]
!

comboViewEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self comboViewEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#comboViewEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary comboViewEnteredIcon'
        ifAbsentPut:[(Depth8Image width:16 height:18) bits:(ByteArray fromPackedString:'
ITI^W%9BD4IBITIBLQU@@DXIQ$Y!!BTYFQ$Y!!XRQ(TSX$I@PDIDEAPTERIBQAAFUOO%AP@@@>HREP@C9PTEA(X#-)G#,^N19)G%(;G!!9)G"49U&Q$NVQVNUYV
NS%VYC$JJB!!TUB (UEP(UB!!TJEP(A5=_EAP4L =_W3AJDE=_E@ILZ$1*M2)MCB1MJ!!YLSD0<Y&Y&F6Y]I1D5A%4[F6X[GUTXJQ!!UFD$ WD$XUQ!!UUVL&I TE
I"XEI"XEI TEQBXWH#<A@S<AO3<?H D?@PD"XE-+G6-+G6-[V1=+V1=+V0M''Y6]''L6]KY6]''R6\\L5 :RE]HRD!!HCT MCU\.U5\HF!!$YFQ$YFQ$YFQ$YNB-E
S$]YC%%YK2=YVU%YK09SP2L@') colorMapFromArray:#[101 172 248 53 140 250 61 135 247 46 108 250 105 175 248 57 144 249 207 230 254 64 139 247 43 118 250 109 178 248 67 143 247 233 232 233 89 165 249 43 131 251 43 93 250 93 168 249 146 198 251 225 240 254 255 255 255 80 159 246 78 159 248 141 189 240 82 161 249 49 116 249 62 149 249 42 128 251 117 150 239 67 152 248 45 133 250 55 125 248 95 170 248 49 136 250 198 225 253 101 172 247 52 140 250 181 192 232 105 175 247 81 160 247 57 143 249 207 230 253 84 163 248 61 147 248 212 232 253 42 124 251 88 165 249 70 147 246 43 130 251 42 93 250 92 168 249 99 167 243 221 237 253 46 134 251 146 197 251 225 239 254 193 212 235 81 161 249 42 127 251 90 167 248 65 117 245 95 169 248 57 130 247 186 186 186 100 172 247 52 140 249 194 213 236 104 175 247 81 160 246 111 141 235 56 143 249 42 116 251 109 177 247 185 197 236 43 130 250 68 152 249 220 237 253 46 134 250 72 156 248 224 239 254 77 118 242 137 184 240 101 173 248 108 171 243 105 176 248 61 107 244 85 163 249 62 147 249 90 166 248 44 131 251 46 130 250 43 94 250 95 169 247 48 136 249 197 224 253 74 157 248 80 160 246 78 160 248 48 111 249 108 177 247 91 159 243 52 121 249 91 167 249 93 167 247 67 152 249 46 133 250 97 170 247 96 170 248 72 155 248 49 137 250] mask:((Depth1Image width:16 height:18) bits:(ByteArray fromPackedString:'??;????????????????????????????????????????????>'); yourself); yourself]
!

comboViewIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self comboViewIcon inspect
     ImageEditor openOnClass:self andSelector:#comboViewIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary comboViewIcon'
        ifAbsentPut:[(Depth8Image width:16 height:18) bits:(ByteArray fromPackedString:'
ITI^W%9BD4IBITIBLQU@@DXIQ$Y!!BTYFQ$Y!!XRQ(TSX$I@PDIDEAPTERIBQAAFUOO%AP@@@>HREP@C9PTEA(X#-)G#,^N19)G%(;G!!9)G"49U&Q$NVQVNUYV
NS%VYC$JJB!!TUB (UEP(UB!!TJEP(A5=_EAP4L =_W3AJDE=_E@ILZ$1*M2)MCB1MJ!!YLSD0<Y&Y&F6Y]I1D5A%4[F6X[GUTXJQ!!UFD$ WD$XUQ!!UUVL&I TE
I"XEI"XEI TEQBXWH#<A@S<AO3<?H D?@PD"XE-+G6-+G6-[V1=+V1=+V0M''Y6]''L6]KY6]''R6\\L5 :RE]HRD!!HCT MCU\.U5\HF!!$YFQ$YFQ$YFQ$YNB-E
S$]YC%%YK2=YVU%YK09SP2L@') colorMapFromArray:#[101 172 248 53 140 250 61 135 247 46 108 250 105 175 248 57 144 249 207 230 254 64 139 247 43 118 250 109 178 248 67 143 247 233 232 233 89 165 249 43 131 251 43 93 250 93 168 249 146 198 251 225 240 254 255 255 255 80 159 246 78 159 248 141 189 240 82 161 249 49 116 249 62 149 249 42 128 251 117 150 239 67 152 248 45 133 250 55 125 248 95 170 248 49 136 250 198 225 253 101 172 247 52 140 250 181 192 232 105 175 247 81 160 247 57 143 249 207 230 253 84 163 248 61 147 248 212 232 253 42 124 251 88 165 249 70 147 246 43 130 251 42 93 250 92 168 249 99 167 243 221 237 253 46 134 251 146 197 251 225 239 254 193 212 235 81 161 249 42 127 251 90 167 248 65 117 245 95 169 248 57 130 247 186 186 186 100 172 247 52 140 249 194 213 236 104 175 247 81 160 246 111 141 235 56 143 249 42 116 251 109 177 247 185 197 236 43 130 250 68 152 249 220 237 253 46 134 250 72 156 248 224 239 254 77 118 242 137 184 240 101 173 248 108 171 243 105 176 248 61 107 244 85 163 249 62 147 249 90 166 248 44 131 251 46 130 250 43 94 250 95 169 247 48 136 249 197 224 253 74 157 248 80 160 246 78 160 248 48 111 249 108 177 247 91 159 243 52 121 249 91 167 249 93 167 247 67 152 249 46 133 250 97 170 247 96 170 248 72 155 248 49 137 250] mask:((Depth1Image width:16 height:18) bits:(ByteArray fromPackedString:'??;????????????????????????????????????????????>'); yourself); yourself]
!

inspectView24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self inspectView24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#inspectView24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary class inspectView24x24Icon'
        ifAbsentPut:[(Depth24Image width:24 height:24) bitsPerSample:(#(8 8 8)); bits:(ByteArray fromPackedString:'
@@@@PI#DM)WDM9SDM)SDM)SDM9SDM)SDM)SDM9SDM)SDM9SDM)SDM)SDM)SDM9SDM)SDM)SDM9SDM)SDM9WE [SN@@@@@@@@@@@@V:+SZ+W"V*;_V:;^V:;^
V:;_V:;^V:;^V:;_V:;^V:;_V:;^V:;^V:;^V:;_V:;^V:;^V*;_VZ7^#<#+RHZ$@@@@@@@@@@@@X:7UTZ''^M)3XM93XM93XM93XM93XM93XM93XM93XM93X
M93XM93XM93XM93XM93XM93XM)3XL9+W$<+,QHR#@@@@@@@@@@@@[;SW$,#+_;?& K?& K?& K?'' K?& K?& K?'' K?& LC'' K?& K?& K?& LC'' K?& K?&
 K?''_+;&/M;4P(N#@@@@@@@@@@@@!![3U:>_#9NG_9NG_9NG_9NG_9NG_9NG_9^K 9^O 9.O 9.O 9.O 9.O 9.O 9.O 9.O 9.K 9^G_>OW/PXJ#@@@@@@@@
@@@@!!K3V6]#W3\;P3\;P3\;P3\;P3\7P3\7O1,[H+Z6-+J2,*:.+*:.+*:.+*:.+*:.+*:.++Z6-/[6=</C,PHJ#@@@@@@@@@@@@!!K3V7]/Z2<3M.+.<0,KC
0\KC0LGB3\;O2<7N7M3^?????/;>?/;>?/;>?????/;>?/;>;^;.1\WF<?G-PHJ#@@@@@@@@@@@@!!K3V7=7\1<_H(:N%,+J3,[F2,J>13L3N4]KS9.[''????
?/;>?/;>?/;>?????/;>?/;></K33<?P<?G-PHJ#@@@@@@@@@@@@!!K/V8M?_/;?A!!(^H''I6^3L3N&).\2L''J5=#Y<_G2????????????????????????????
>O#86=/\=OG-PHJ#@@@@@@@@@@@@!!K/U8.G 6]+\7M7^6=3^6-/]6-/]6M+\7];_=OS4;^7.2<3M''9>!!$YFS$YJS''9>!!2<3M;^;.9^W&=_G-PHJ#@@@@@@@@
@@@@!!K/U9NK!!6-/\6-/\6-/\6-/\6-/\6-/\6=3]4-OT*Z&+#)RY!!:N5!!Z/@!!:7@"*V5#9JU*:.-4-KT=/O/O8J#@@@@@@@@@@@@!!K/U9.S#7M7^7];_7];_
7];_7M;_7];_5-#X*Z*+%9VT"K;!!)-+82N3>/>+?+]?8%\W %)RT-[V7=OK.PHJ#@@@@@@@@@@@@!!K/U:^[&6]''[1<_I3<?Q4=OU5=_Y7]3^4-KT&Y&Z#;OM
-.W?9/[?4>??0>+?-._?''>G?''K/L''I.\9>[#PHN$@@@@@@@@@@@@!!K/U:>''''5MSU+:>//+:?1<_H4]GR6=/\4MCR%9VU"<[(6/K>4>?>1./>.^''?+NW>(>O>
(]S(%)RU8NC^PXN$@@@@@@@@@@@@!!K/U;^/*3\7N#8>P6=/\)*Z'')*Z''6M#Y4]KS&)"X#</+5/C?1^/?/N''?,.''?+^''?*>#?*M/+&)^X7=?^PXN$@@@@@@@@
@@@@!!K+U;.7+:^++:./-:^+,:./,:./,:^++4=SU&9*Z&,+&/^#>-._>+^[>+>/?-^?>,^7>+=#&''I*[8NC^PXN$@@@@@@@@@@@@!!K/U<^;-:.++:.++:.++
:>++:.++:>++8.G")*R%+;/D(M7>(>G>)NS>+.+?,.;>,^3>-K;D%INU9NS$O8N%@@@@@@@@@@@@!!+;V?O_2>/S0>/S0>/S0>/S0>/S0>/S1>/[23\''F''Y^W
/=O])]78''>O?)>''?,>_81]#^%)ZX,;R6-+V8N8N,@@@@@@@@@@@@T(*%M''2^L7*]L7*]L7*]L7*]L7*]L7*]MG.^MW6!!T''.P#H*K,+B00+>?0+>?,[B1!!(ZI
%)"\3\7N;-:<4*MY9.GY@@@@@@@@7M3\5MST4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4-KR-[R5#H2M (JC (JC#H2M!!(^H#8>O3J-7>\1:==VC4+^C<N?+
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8>O#7=?_7=?_8^G!!6]''Y$(6E6YX6?:0/?=NA8+142,Z?@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8>O#''YZL4ID78*UD/Y5*1,O@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@9NS#'')^M%X!!7+:.&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@')
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??<_??>_???@@_?@@@?@@@^@@@@'); yourself); yourself]
!

inspectView32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self inspectView32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#inspectView32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary class inspectView32x32Icon'
        ifAbsentPut:[(Depth24Image width:32 height:32) bitsPerSample:(#(8 8 8)); bits:(ByteArray fromPackedString:'
@@@@W*[KE8N8E(J7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(F7E(J7E8N8W*[K>?/;
@@@@@@@@@@@@E8J8&<?.&L7,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&,;,&L7,&<?.
E8J8</K2@@@@@@@@@@@@EHF6*][1E8/QF8;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RGH;RF8;R
E8/Q*][1EHF6:.+*@@@@@@@@@@@@D(B6.M75NY;YO:GZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZPJGZ
PJGZO:GZNY;Y.M75D(B6:^'')@@@@@@@@@@@@C7>60.O:T*/#UZ3#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#U*7#
U*7#U*7#U*7#UZ3#T*/#0.O:C7>6:^'')@@@@@@@@@@@@CG66??74??_2??#2??#3??#3??#3??#3??#3??#3??#3??#3??''3??''3??''3??''3??''3??''3??''3
??''3??''3??''3??''3??''3??#3??_2??74CG66:^'')@@@@@@@@@@@@B''66??362<''J2,+L2,+L2,+L2,+L2,+L2,+L2,+L2,+L2</M3L7N3\7N3\7N3\7N3\7N
3\7N3\7N3\7N3\7N3\7N3\7N3\7N3L3M3L+K??36B''66:^'')@@@@@@@@@@@@B''66??363,7N3,?Q3,?R3=CR3,?R3,?R3,?R3,?Q3,?Q3=CS)JN#(*J"(ZF 
(JB (JB (JB (JB (JB (JB (JB (ZF (*J"(:N"3<?P??37B''66:^'')@@@@@@@@@@@@B''66??364]CP4-OT5-_X5-_X5-_X5-_X5]_W5MWV4-OT4-OT-[^:
????????????????????????????????????????????-K^94-GQ??37B''66:^'')@@@@@@@@@@@@B''66??365MOS5=#YRD!!I!!8^H!!(VF!!XVF!!XVF (JC5][W
4-ST1\[G????????????????????????????????????????????1\[G4-KR??36B''66:^'')@@@@@@@@@@@@B''66??365-SU6]''[8NC"8^G#7=?!!7]7_7-7 
7M3^5=_Y4=OU5-_X????????????????????????????????????????????5][W5MKS??/6B''66:^'')@@@@@@@@@@@@B''26??/65=[X6-/]RT%J"H&J!!XZG
7M7_!!HVF 8VE6M''[4=SV:N#)????????????????????????????????????????????:N#)5MOU??/6B''26:^'')@@@@@@@@@@@@B''26??/66]#Y6]+\7]; 
7]; 7M7_6-/]6=3_6=3^6M+\5][X?O3;????????;^7..K&<%IVX%Y^Y%Y^Y%IVX.K&<;^7.?????_7<5-[W??/5B''26:^'')@@@@@@@@@@@@BW26??/56-+Z
6]+[6-/\6-/\6-/\6-/[6-/\6-/\6]+[6]+[6]+[7M7]+J60$)JT#X2K"XZD"HRB"HRB"XVD#X.K$YJT,[J47M7^6=+[??/5BW26:^'')@@@@@@@@@@@@BW26
??/57]3\6=3]6=3]6=3]6=3]6=3]6=3]6=3]6=3]7];_8^K#,;R7$9JS#9FS!!:7J \?? =W?!!-_?"MS?#KKJ#8.J$)JS,;N78^G!!??36BW26:^'')@@@@@@@@
@@@@BW26??/57=;^7];_7-? 7.C 7-? 7-? 7-? 7]? 7-? 8^O#+Z:.$IBS&IRR ,[5%]+?3>??9/_?5?K?1>7?*>W?$-G5%9NR#(>Q4L?O??;8B''66:^'')
@@@@@@@@@@@@BW26??/58]?!!8^G$9^W''9.[(9^W''9NS&8.K$8.K$8.G#9.W''''I:!!&Y"W#;[S%]''?=O/?8/W?4>??1>/?/.''?,>[?&M??''K;R&IZV):^(???:
B''67:^'')@@@@@@@@@@@@BW26??+49NK"9.[''ST5M$IBQ#(:O#H2M:N#)"H"I9.[&:^''*!!XVG)*N!! \;?3>??8/S?4>??2N3?/>+?-._?*NO?''>K?''^C?)JF 
!!(RG???<B7:7:^'')@@@@@@@@@@@@BW26??+49.W%:N#)<OC1<OC1;^7.;N3-;N3-:>/,:N#);N3- XJE,J2* ]O?9/[?4>??2N3?0N/?.^''?+>_?)>[?).W?
(^_?+:.* 8JE???<B7:7:^'')@@@@@@@@@@@@BW26??+4:N_'':>/,S$9O$IBQ;^7.#8:O$IBQ#(:O:.++;.;/_W:A.KR1 =S?5?G?1>/?/>+?.^''?,^''?+.+?
+>+?+N''?)./?-+J1_7:A???=B7:7:^'')@@@@@@@@@@@@BW26??+4:^''):^++;N7.:>7.:^/,:>3-;N7.:>3-:^++;?C0]7%;.;^5"]S?1./?/.''?-._?+._?
+^+?-^??-.??,N7?*.+?.[Z5^'')<???<B7:7:^'')@@@@@@@@@@@@BW26??''4:>''*:N#+:^''+:^''+:^#+:^''+:^''+:^''+:^'',;>;0''I.^*JZ&)<7%).C?,>[?
*NO?).[?+>+?-.??-?G?+>??.M_%*J^''(Y>!!???<B'':8:^'')@@@@@@@@@@@@B''66??/4<N7,;^3,;^3,;^3,;^3,;^3,;^3,;^3,;.3,</C05-WV_75>2,[D
&-''=%]3?''^C?)^S?+N''?,N7?+>;?,.''=2LSD_7:A"8.N????A''>=:^'')@@@@@@@@@@@@C7>7???7??#3??_2??_2??_2??_2??_2??_2??_2??_3??''4??;:
,**''"(VE5L?K--'',''.G?''.S?)N#?*.+?0NC,4L7L 8NF):"*7>G"%YNX@G;I:^'')@@@@@@@@@@@@R9Z:C7>7B''66BW26BW26BW26BW26BW26BW26BW26BW26
B''66B7>8B8J>R''6V!!XBA-;V56-_U7=/Y7=/Y6][U-[R5_7:A!!8"K0,SH9.+0;-253(848=#J@@@@@@@@@@@@5MST0LC@/K2</K2</K2</K2</K2</K2</K2<
/K2</K2</K2</K2</K2<.;.;*:** 8ND\WI4\WE4\WE4\WI4 8RF]''!!;%9._''JR.5<F^?>^,?=%/1H8?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2</K/;>?/K2</K2</;>?0<OC.+*:]G"@0I50?:( ?<I\?>^5?=)32IIB@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0,KB+8ED?:P]?:$)?<M_?>281YAA@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0,KB)8AL?:P_?:4(7,BF1IAE@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0,KB)8AL*G=K*(AI3L3L@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2L#H/+:>3L3L
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@')
            mask:((ImageMask width:32 height:32) bits:(ByteArray fromPackedString:'
_????G????1????<_????G????1????<_????G????1????<_????G????1????<_????G????1????<_????G????1????<_????G????1????<_????G??
??1????<_????G????0@@G?>@@@@? @@@G8@@@@>@@@@G@@@@@@b'); yourself); yourself]
!

osxTerminalIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self osxTerminalIcon inspect
     ImageEditor openOnClass:self andSelector:#osxTerminalIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary class osxTerminalIcon'
        ifAbsentPut:[(Depth8Image width:32 height:32) bits:(ByteArray fromPackedString:'
\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\:,;-R,+J2-%YZ.X&I"X&I"X&I"X&I"X&I"+B!!Y3\7ME,UP:N*MR/''Y6-C$9NS$9NS$9NS$9NS$9
NS%6VZ]3\;V8F7=H_B&(EPNAQ&!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF#E+7M3YKA> &C@Z''^SV6KG+(.K"8.K"8.K"8.K"8..C04G\7L_)P3IWGA0UR4S0ZIJR$)JR$)J
R$)JR$)JR$RWP%A3\4TI_W!!8^G (SD2^''):^''):^''):^''):^''):^]Y$=QWM3A!!9SVH5XVE5]WU5]WU5]WU5]WU5]WU5]WU5XT18F\7MPAH"THH0XO6=GGQ4]
GQ4]GQ4]GQ4]GQ4]GYRHAEA3\:\#07)9M#E,KE)VU%YVU%YVU%YVU%YVU%YV]LL#)7M3K:1''/6<EM),?I)2\''I2\''I2\''I2\''I2\''I0@Y:0/\7N=AIR\I&&I
M"IO^7-;^7-;^7-;^7-;^7-;^2*TAK53\1$D(SAV.#ZZ(H@3L3L3L3L3L3L3L3L3L3L3)JDDFWM3U4%K2D<6PKNJ$PHB@ HB@ HB@ HB@ HB@ J*R4%W\7LH
R[%1Z6:N\U=MST5MST5MST5MST5MST5MSWJ9RP!!3\<QIF 9!!C&F2,+J2,+J2,+J2,+J2,+J2,+J2C!!)I1GM3IH_HW#T5MST5MST5MST5MST5MST5MST5MSU^
2H\$\7L$TR\AK"8.K"8.K"8.K"8.K"8.K"8.K"8.K D''TRQ3\<YQDTE&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&PQEQ1''M3''RD%!!S 8NC 8NC 8NC 8NC 8NC 8
NC 8NC"EIRF]\7M#HZX4+Z6-+Z6-+Z6-+Z6-+Z6-+Z6-+Z6-+SR&HVM3\9<!!M1@RD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRDC\!!''7M3S(ZEE;^7-;^7-;^7-;^7
-;^7-;^7-;^7-;\W!!XYN\7NR*SP<O#8>O#8>O#8>O#8>O#8>O#8>O#8>O#04*YI3\9WB#;Y-[V5-[V5-[V5-[V5-[V5-[V5-[V5--(?B%WM3L .V[Q0\GA0\
GA0\GA0\GA0\GA0\GA0\GA1-% ,2\7L2 1B7$IBP$IBP$IBP$IBP$IBP$IBP$IBP$K\P 3I3\;0^.0/B0,KB0,KB0,KB0,KB0,KB0,KB0,KBB;,^/GM3!!AQC
P4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP1RD\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3
\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\7M3\0@a')
            colorMapFromArray:#[74 74 76 92 93 95 84 84 86 148 184 57 240 240 240 138 139 140 141 143 147 143 145 148 135 137 141 230 231 230 145 147 151 238 237 237 192 206 210 226 225 227 87 87 90 170 171 175 102 103 106 86 86 89 104 105 108 202 200 212 123 125 128 111 172 0 145 146 149 105 106 109 60 60 63 137 140 143 77 76 80 255 48 19 113 114 117 69 69 71 237 237 236 142 145 148 64 64 66 239 239 238 147 147 149 241 241 240 133 135 138 88 89 92 73 73 75 82 83 86 236 236 237 233 177 117 77 77 79 144 147 151 69 69 73 201 200 213 94 95 97 140 142 145 78 78 81 139 139 139 123 126 129 81 81 84 100 101 103 92 92 94 255 255 255 93 94 98 99 100 103 253 253 254 250 255 255 145 149 152 108 109 111 230 230 229 110 111 113 65 65 67 145 145 146 95 95 98 239 240 240 121 123 127 197 198 200 141 144 147 203 205 208 69 69 70 230 247 255 240 240 239 198 199 201 71 71 73 237 237 238 86 87 89 127 129 133 75 75 77 142 144 147 239 239 239 250 254 255 42 42 44 252 255 255 196 199 208 73 73 76 136 138 142 51 51 53 213 214 216 72 72 76 80 133 0 193 202 208 52 52 54 90 90 92 85 87 88 215 233 244 88 88 91 227 224 236 129 132 135 142 146 150 145 147 152 97 97 100 62 62 64 204 206 208 60 60 62 238 134 0 82 83 85 61 61 64 112 113 116 77 78 80 68 68 70 193 200 211 83 84 86 84 85 87 0 0 0 71 71 74 235 235 235 255 254 255 224 226 247 235 237 237 63 63 67 69 69 72 79 79 81 253 159 57 232 234 234 238 7 0 232 111 96 78 78 82 241 239 249 237 6 0 236 235 235 113 115 118 97 98 101 239 238 238 240 239 239 55 55 57 130 130 132 81 80 82 172 173 177 59 59 61 51 51 54 78 79 81 102 103 107 108 109 112 84 83 85 126 128 131 80 134 0 66 66 68 125 127 130 104 105 109 196 197 199 144 147 150 232 232 232 140 140 143 136 138 139 76 76 78 131 133 136 236 236 236 128 130 134 70 70 74 68 68 71 197 198 201 249 255 255 79 79 82 237 243 245 91 92 94 141 143 146 239 241 255 239 238 237 82 82 84 145 147 150 241 240 240 102 103 105 172 173 176 144 146 150 222 235 239 212 218 220 89 89 92 73 72 75 254 252 255 144 148 151 110 111 114 107 108 111 240 253 255 73 74 76 142 142 144 236 236 235 124 126 129 138 141 144 253 253 255 73 73 74 237 135 0 198 198 204 238 238 237 59 59 62 134 136 139 243 244 245 132 134 137 171 171 176 80 80 82 192 207 211]
            mask:((ImageMask width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@C????1????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''??
??9????>_????''????9????>_????''????8@@@@@@@@@@@@@@@@b'); yourself); yourself]
!

scrollDownDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollDownDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollDownDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@A8QC@4MCP4MCP4MCP4PE @QLTIBP$EAN#$8MSL.IA@@BTIBPS8=OCD.KR,%F2XN@@%APS<<N3$-J"$&G1($C @IPS<=N3$6J"\%H!!8YI@8@BTD?OS8?OSP1
LB8,FRPN@@%AO34EA1TXG"H]JQ$$C @IPS<=O0DDB@<LKB0YI@8@BTD?OS0=@@LFK"X&FRPN@@%AO349N3PBLB$^G!!$$C @IPS<=N3$6K3D,H!!8YI@8@BTD?
OS,9M"(''IRH^FRPN@@%AO309NCP)I"P!!GA $C @IO309MSP2I"P!!G!!,WI@8@D3D=N3$9NB4+J"$(I!!<T@B@SB (JB (KB ,KB0,RH0@a') colorMapFromArray:#[52 52 50 56 56 60 68 70 70 80 78 80 100 100 100 112 112 110 120 118 120 144 144 140 148 146 150 152 152 150 152 154 150 156 154 150 156 158 160 160 158 160 160 160 160 164 162 160 164 166 170 168 168 170 172 170 170 172 172 170 172 174 170 176 178 180 188 188 190 188 190 190 192 192 190 192 192 200 192 194 200 196 196 200 196 198 200 200 198 200 200 200 200 200 202 200 204 204 200 204 204 210 204 206 210 208 206 210 208 208 210 208 210 210 212 212 210 212 214 220 216 214 220 216 216 220 216 218 220 220 218 220 220 220 220 220 222 220 224 224 230 224 226 230 228 226 230 228 228 230 228 230 230 232 230 230 232 232 230 232 234 230 232 234 240 236 234 230 236 234 240 236 236 240 236 238 240 240 238 240 240 240 240 240 242 240 244 242 240 244 244 240 244 244 250 244 246 250 248 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b'); yourself); yourself]
!

scrollDownEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollDownEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollDownEnteredIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@A<NBP$IBP$IBP$IBP$KGP@PN41KR4-KRT%IRT%HM@,@BT1EP#<?O28.K"4(HDDI@@%KP#48NC &I"X&H!!,:BP@IR3<8M#X6H2L#H18ZM0$@BT,?NC1@PB</
K2<,F#\I@@%KO3 EA1DSEQ$TJ1(7BP@IR3<8P@DDB@0JKBTZM0$@BT,?NC1@@@LFK2\ZF#\I@@%KO3 6OB<BK2(^F!!(7BP@IR3<8M#X6J"<*H18ZM0$@BT,?
NCX6M"L#H2L^FC\I@@%KNST2L#H^G!!8^GA\7BP@IR#L1LC@0F!!(ZFA\VM0$@D#9GQ$QDQC\7M3\7M2$M@BPRBP$IBP$IBP$IBP$OHP@a') colorMapFromArray:#[12 38 52 13 41 57 17 56 76 20 66 91 28 91 124 32 106 145 34 113 155 45 148 203 46 151 207 60 127 177 66 161 212 71 123 162 76 166 214 89 143 184 92 144 183 93 147 188 97 149 188 103 179 220 105 154 191 128 192 226 141 198 229 143 199 229 148 192 216 152 198 222 155 201 226 155 205 232 156 202 227 159 206 232 160 208 233 162 186 204 164 213 239 166 191 209 166 215 241 167 194 214 168 218 245 169 219 246 174 195 211 177 213 233 181 224 247 183 222 242 185 226 248 187 202 213 187 227 248 192 221 237 197 228 245 197 231 249 198 231 249 200 232 249 207 229 242 209 231 244 211 235 247 212 236 248 213 226 235 213 237 250 214 238 251 219 221 223 220 240 251 222 241 252 223 225 227 223 234 242 223 242 252 226 242 252 227 235 241 227 244 252 229 244 252 231 234 236 233 246 253 234 234 234 238 239 240 238 248 253 240 240 242 244 245 246 250 252 254 251 253 254 253 253 255 253 254 255 254 255 255] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b'); yourself); yourself]
!

scrollDownIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollDownIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollDownIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHCAP HB@ H
B@ GA@TF@@DB@0 RD1PUE!!\XB@PEA @A@ LEB@4NC1@QB@\DAPX@@PHC@0THB ,LB@\CA@TF@@DB@0LCAP IB@\C@0PEA @A@ LC@0LGB@\C@0LDAPX@@PHC
@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @a') colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; yourself]
!

scrollLeftDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollLeftDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollLeftDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@=NC@1ZV%)ZC@0LC@0LS =NUQ 2L#H2L#H2L#H2L!!QNSVXKL"T%IRT>O#8>VD($L4AYL&TWE1\2Y#HWE2Q$U2]@B5 $U5]XL (2
U5]$X3@''PCH1U1X$R08&R1XVBQT0I4@%OQX=VA-HJE <O@ ;RR]@H2EGH%@^FT<"NS% T"@''PC0.D3(/S@@*K0TEG2,SI4AVQ5MEXP\ZQ@]EQQE^Q"]@B@X8
M3\-K$L.M3]^GV@''PFIE@14]GQ=TG14]M HRI4@:WQ1BP$IBP$IBMR%\KB]ATQ=_J2,+J2,+J2,+J1@@ACPMCP4MCP4MCP4MCP5[@P@a') colorMapFromArray:#[162 162 162 185 185 185 191 191 195 197 197 201 207 207 207 210 210 213 215 215 218 224 224 226 230 230 231 232 233 234 112 112 112 243 243 244 148 148 148 158 158 158 55 55 55 195 195 195 198 198 200 203 204 207 210 211 212 215 215 217 226 226 226 229 230 231 234 234 235 240 240 240 244 244 244 146 146 146 157 157 157 51 51 51 190 190 193 196 196 199 78 78 78 208 208 211 217 218 218 224 224 225 229 229 230 233 233 234 238 238 239 242 242 243 144 144 144 155 155 155 177 177 177 187 187 191 199 199 199 204 204 206 209 209 210 213 213 216 221 221 223 226 226 228 234 234 234 238 239 240 243 243 243 153 153 153 174 174 174 188 188 192 194 194 198 202 202 205 207 207 210 214 214 216 220 220 222 228 228 229 232 232 233 237 237 238 241 241 242 248 248 248 151 151 151 171 171 171 188 189 192 198 198 198 205 205 205 206 206 209 214 214 215 218 218 220 100 100 100 233 233 233 238 238 238 242 242 242 118 118 118 150 150 150 165 165 165 191 191 191 69 69 69 202 202 203 207 208 210 211 211 214 217 217 219 228 228 228 231 231 232 236 236 237 240 240 241 244 244 245 149 149 149 164 164 164 186 186 190 192 192 196 200 200 203 205 205 208 212 212 214 216 216 219 226 227 228 231 232 233 234 234 236 241 241 241 245 245 245] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@C???????????????????????????????????????<b'); yourself); yourself]
!

scrollLeftEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollLeftEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollLeftEnteredIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@CH0F!!(ZF!!(ZF!!(ZF!!(ZLB &H3$/K2</K2</K2</IQ@@F#$.BDEAPTEAPTEAFQ $HQ(/BD,,KB07SC\,K@X5NBDZK4D,R$("KQX-
R$(+RQD!!F"=AKD("KPE@KT)JJ4$QHQ(/PR0"KP(LD25JR"-IDRDZBQ\DC#,TM$TNJR$CQ#<!!F $WACPNRD4]C"$)@4X?HQ(IE0P)M@8[O@8)JPMFO2DZBR@D
JR$4C#DNJR$C@#<!!F $>L0LC@04*CPLCG ,?HQ)CQ1UFQ$YFQ$YF@ ,''O2D\AP\OO3<?O3<?O3<?O1=BOTP!!HRD!!HRD!!HRD!!HREBN @a') colorMapFromArray:#[92 144 183 13 41 57 155 201 226 164 213 239 181 224 247 207 222 233 213 237 250 231 234 236 232 246 253 251 253 254 12 38 52 152 198 222 28 91 124 183 222 242 200 232 249 223 225 227 227 235 241 238 239 240 248 248 248 103 179 220 20 66 91 159 206 232 32 106 145 198 231 249 212 236 248 222 241 252 60 127 177 66 161 212 100 152 191 143 199 229 160 208 233 187 202 213 197 231 249 52 110 153 223 242 252 229 237 245 244 245 246 253 253 255 98 150 189 148 192 216 166 191 209 169 219 246 197 228 245 211 235 247 220 240 251 229 244 252 238 248 253 253 254 255 97 149 188 141 198 229 165 190 208 168 218 245 187 227 248 209 231 244 46 151 207 227 243 252 240 240 242 254 255 255 117 142 160 17 56 76 155 205 232 176 200 218 185 226 248 219 221 223 45 148 203 227 244 252 71 123 162 250 252 254 94 146 185 128 192 226 156 202 227 166 215 241 34 113 155 207 229 242 214 238 251 225 242 252 233 245 252 76 166 214] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@C???????????????????????????????????????<b'); yourself); yourself]
!

scrollLeftIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollLeftIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollLeftIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDB@ HB@ HB@ HB@ HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCAP E@0LC@0LC@0LC@0LEBAHH
B@LC@0LC@0LC@0LEB@4SB@ C@0LC@0LC@0LCB@(NE@ H@0LC@0LC@0LC@0$KC1THB@LC@0LC@0LC@0LHCA@VB@ C@0LC@0LC@0LCA0 QE0 H@0LC@0LC@0LC
@0LGBA HB@LC@0LC@0LC@0LC@0LGB@\C@0LC@0PDA@PDA@PDA@PDA@PDA@PEAPTEAPTEAPTEAPTEAPTEA XFA XFA XFA XFA XFA @a') colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b'); yourself); yourself]
!

scrollRightDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollRightDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollRightDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@DP5I2\''I2\''I2\''I2\''MTP[U3MMST5MST5MST5MY1T(F!!%MSU)ZV%)ZV%(XB40?CP@YSQ %IT@LPBT%IS<>B @@L0,?B )@DD@2
B (>E$,@@CM&B#8>FDMYFC<>BRMX@@AMI#9%YRUCV4D%B#AJBP@@I@!!#UUT=JSQPM#4:NRD@@A\<N24-YFE]HFQVAQD.@@@1X1MFQ"INNBHTQ P+A @@BR8_
G!!9IS4%"G!!8+@4 @@C4,QQ4]NP\9GQ4]W3]T@@@/J%8OC0<OC0<OTPH\D @ADQ= T5MST5MST5MST5IBQ09\WE1\WE1\WE1\WE1BQ@@a') colorMapFromArray:#[158 158 158 177 177 177 190 190 194 199 199 202 206 207 210 211 211 214 217 217 218 219 219 221 226 226 228 234 234 235 238 238 239 242 242 243 246 246 247 157 157 157 175 175 175 191 192 195 73 73 73 207 207 209 212 212 213 214 214 217 218 219 221 228 228 228 233 233 234 236 236 238 243 243 243 247 247 247 156 156 156 171 171 171 189 189 192 198 199 202 204 204 208 210 210 213 216 216 216 220 220 221 225 226 228 231 231 233 238 238 238 241 241 242 239 239 240 151 151 151 169 169 169 63 63 63 195 195 199 203 203 206 209 209 212 213 213 216 218 218 220 225 225 226 232 232 233 235 236 236 242 242 242 246 246 246 146 146 146 167 167 167 190 190 190 194 194 198 205 205 205 210 211 213 214 215 217 217 217 220 224 224 226 231 231 232 236 236 237 240 240 241 244 244 245 142 142 142 165 165 165 60 60 60 198 198 198 200 200 204 208 209 212 212 212 212 215 215 217 222 222 225 229 229 231 236 236 236 240 240 240 245 245 245 128 128 128 162 162 162 187 187 187 191 191 195 201 201 202 206 206 209 213 214 215 217 217 219 222 222 224 231 231 231 235 235 236 112 112 112 243 243 244 121 121 121 160 160 160 184 184 184 192 193 196 197 197 201 208 208 210 86 86 86 215 215 218 221 221 223 228 228 230 233 233 235 240 241 241 244 244 244] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@C???????????????????????????????????????<b'); yourself); yourself]
!

scrollRightEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollRightEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollRightEnteredIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@A4HQ4]GQ4]GQ4]GQ4]GBA4HA"P[F1,[F1,[F1,[DS4RQ2PPMRH"H"H"H"H"Q$TGAD\[MR,NC!!$,FP8NC#LWF QGF2HNHRDOBP<E
HRDMJS8DQ1,"C"D!!C2TBC0T!!CR$>AD\[H 8!!HP<%G2(OAP4)O QGO3,:G!!82D1 .GCIBI"@DQ3<;N!!8^L# 7ESH(P"X AD\?N3(^G#IDECH(G$H&H@QGO0L:
G!!82M#H(G!!9BK2@DQ3<1I4IBP01CP$IBB$D AD\-NPD&I"X&I"X&K4D@H@Q@E#P<HB@ HB@ HB@ H@,#LD$DA@PDA@PDA@PDA@P#GP@a') colorMapFromArray:#[148 192 216 159 206 232 32 106 145 197 231 249 52 110 153 223 242 252 229 237 245 244 245 246 96 148 187 18 60 82 160 208 233 187 202 213 197 228 245 211 235 247 220 240 251 229 244 252 238 248 253 253 253 255 91 143 182 15 50 69 155 205 232 175 215 237 200 217 230 209 231 244 46 151 207 227 243 252 240 240 242 253 254 255 126 191 225 163 187 206 169 219 246 36 118 162 219 221 223 214 238 251 227 244 252 71 123 162 254 255 255 14 46 63 156 202 227 168 218 245 187 227 248 207 229 242 44 146 200 225 242 252 233 245 252 250 252 254 121 189 224 155 201 226 176 198 215 185 226 248 200 232 249 213 237 250 231 234 236 232 246 253 76 166 214 114 185 223 23 75 103 166 215 241 181 224 247 198 231 249 223 225 227 227 235 241 238 239 240 251 253 254 103 153 190 152 198 222 164 213 239 183 222 242 39 127 175 212 236 248 222 241 252 60 127 177 248 248 248 98 148 185] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@C???????????????????????????????????????<b'); yourself); yourself]
!

scrollRightIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollRightIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollRightIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDB@ HB@ HB@ HB@ HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0LCAP E@0LC@0LC@0LC@0LC@0 RB@TC
@0LC@0LC@0LC@0LHD04HAPLC@0LC@0LC@0LCBAPNB  G@0LC@0LC@0LC@0 UC0,IB@LC@0LC@0LC@0LHE!!@LB@\C@0LC@0LC@0LCBA\QB@\C@0LC@0LC@0LC
@0 XB@\C@0LC@0LC@0LC@0LGB@\C@0LC@0LC@0PDA@PDA@PDA@PDA@PDA@PEAPTEAPTEAPTEAPTEAPTEA XFA XFA XFA XFA XFA @a') colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b'); yourself); yourself]
!

scrollUpDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollUpDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollUpDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@B@SB (JB (KB ,KB0,RH0@SLTIBP$EAN#$8MSL.IAP@BTIBPS8=OCD.KR,%F2XN@@%APS<<N3$-J"$&G1($C @IPS<=N3$6J"\%H!!8YI@8@BTD?OS,9M"<1
KBH^FRPN@@%AO349N3PBLB$^G!!$$C @IPS<=OC4@@0X.I"XYI@8@BTD?OS<AA@ OCB0,FRPN@@%AO34EA1TXG"H]JQ$$C @IPS<=O#<=MCD0K"0YI@8@BTD?
OS,9M"(''IRH^FRPN@@%AO309NCP)I"P!!GA $C @IO309MSP2I"P!!G!!,WI@8@DSD=N3$9NB4+J"$(I!!<P@A8QC@4MCP4MCP4MCP4PE @a') colorMapFromArray:#[52 52 50 56 56 60 68 70 70 80 78 80 100 100 100 112 112 110 120 118 120 144 144 140 148 146 150 152 152 150 152 154 150 156 154 150 156 158 160 160 158 160 160 160 160 164 162 160 164 166 170 168 168 170 172 170 170 172 172 170 172 174 170 176 178 180 188 188 190 188 190 190 192 192 190 192 192 200 192 194 200 196 196 200 196 198 200 200 198 200 200 200 200 200 202 200 204 204 200 204 204 210 204 206 210 208 206 210 208 208 210 208 210 210 212 212 210 212 214 220 216 214 220 216 216 220 216 218 220 220 218 220 220 220 220 220 222 220 224 224 230 224 226 230 228 226 230 228 228 230 228 230 230 232 230 230 232 232 230 232 234 230 232 234 240 236 234 230 236 234 240 236 236 240 236 238 240 240 238 240 240 240 240 240 242 240 244 242 240 244 244 240 244 244 250 244 246 250 248 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b'); yourself); yourself]
!

scrollUpEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollUpEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollUpEnteredIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@BPRBP$IBP$IBP$IBP$OHP@RN41KR4-KRT%IRT%HM@4@BT1EP#<?O28.K"4(HDDI@@%KP#48NC &I"X&H!!,:BP@IR3<8M#X6H2L#H18ZM0$@BT,?NCX6M"(/
J"L^F#\I@@%KO3 6OB<BK2(^F!!(7BP@IR3<8OD@@@0X/I1(ZM0$@BT,?ND@AA@ LB"0%F#\I@@%KO3 EA1DSEQ$TJ1(7BP@IR3<8ODA@K2</K20ZM0$@BT,?
NCX6M"L#H2L^FC\I@@%KNST2L#H^G!!8^GA\7BP@IR#L1LC@0F!!(ZFA\VM0$@DC9GQ$QDQC\7M3\7M2$K@A<NBP$IBP$IBP$IBP$KGP@a') colorMapFromArray:#[12 38 52 13 41 57 17 56 76 20 66 91 28 91 124 32 106 145 34 113 155 45 148 203 46 151 207 60 127 177 66 161 212 71 123 162 76 166 214 89 143 184 92 144 183 93 147 188 97 149 188 103 179 220 105 154 191 128 192 226 141 198 229 143 199 229 148 192 216 152 198 222 155 201 226 155 205 232 156 202 227 159 206 232 160 208 233 162 186 204 164 213 239 166 191 209 166 215 241 167 194 214 168 218 245 169 219 246 174 195 211 177 213 233 181 224 247 183 222 242 185 226 248 187 202 213 187 227 248 192 221 237 197 228 245 197 231 249 198 231 249 200 232 249 207 229 242 209 231 244 211 235 247 212 236 248 213 226 235 213 237 250 214 238 251 219 221 223 220 240 251 222 241 252 223 225 227 223 234 242 223 242 252 226 242 252 227 235 241 227 244 252 229 244 252 231 234 236 233 246 253 234 234 234 238 239 240 238 248 253 240 240 242 244 245 246 250 252 254 251 253 254 253 253 255 253 254 255 254 255 255] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b'); yourself); yourself]
!

scrollUpIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollUpIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary scrollUpIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LCA0 G
@0LCA@TF@@DB@0LCAP IB@\C@0PEA @A@ LCAP JB00HA0LDAPX@@PHCAP MC <PDP GA@TF@@DB@0 RD1PUE!!\XB@PEA @A@ LEB@ HB@ HB@\DAPX@@PHC
@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @a') colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; yourself]
! !

!MacOSXToolbarIconLibrary class methodsFor:'image specs - widgets'!

checkToggleOffDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOffDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOffDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary checkToggleOffDisabledIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N0L$IBP$IBP$P@L<@@@@@@@;L!!X#H2LAH2L#H1X3N0@@@@@HGS8@NAXVE!!X8H 0!!F0@@
@@@/JR XC@0LC@0LJ089K0@@@@@%P34!!K@8NC 8NKSTJP@@@@@@ZFS<9ACT5MST5DDLYF @@@@@_A0XQAPTEM TEDPXGG0@@@@@;A1D6M"(*E3XB@!!DGN0@@
@@@RDP,^MCPYFSP4G ,QD @@@@@&B4MBNST5MST9P$LKI @@@@@MP2D(I2\''CB\+C"5CBP@@@@AAB0@0ER@#H2@UL@@KC0@@@@@7I ,?O3<?O3<?P1\&N @@
@@ADD1PTEAPTEAPTEAPSQ@@@@@@@NR8\GA0\GA0\GB89@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[235 235 235 241 241 242 210 211 210 123 123 123 223 224 224 210 210 210 208 208 208 206 206 206 120 120 120 169 169 169 217 217 218 214 214 214 232 232 232 168 168 168 228 228 228 153 153 153 222 222 222 209 209 209 154 154 154 110 110 110 97 97 97 239 239 239 237 237 237 213 213 213 230 230 231 218 218 218 132 132 132 119 119 119 199 199 199 229 229 228 215 215 215 140 140 140 240 240 240 227 227 227 235 235 234 241 241 241 126 126 126 124 124 124 162 162 162 231 231 231 229 229 229 225 225 225 212 212 212 230 230 230 227 227 228 226 226 226 202 202 202 127 127 127 238 238 238 234 234 234 190 190 190 188 188 188 217 217 217 224 224 224 211 211 211 116 116 116 236 236 236 223 223 223 117 117 117 146 146 146 144 144 144 225 224 225 233 233 233 220 220 220 125 125 125 152 152 152 221 221 221 219 219 219 197 197 197]; mask:((Depth1Image new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@G?8@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@G?8@@@@@') ; yourself); yourself]
!

checkToggleOffEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOffEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOffEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary checkToggleOffEnteredIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N0L$IBP$IBP$P@L<@@@@@@@;LY^_''9>_''9>_''9\>N0@@@@@H HBW%9^W%9^W((A?F0@@
@@@/[XB@ HB@ HB@ HAUK0@@@@@%UV5?+8B@ HB@[V6''P@@@@@@ZX%UU+F5-[V5-UUU"F @@@@@_ER@ HB@ H2@ HB@UG0@@@@@;ER@#H2L#H2N%)R@UN0@@
@@@RHD=OS4="X$=OS4< D @@@@@&S5UUUV5-[V5UUUUOI @@@@@MUW>@ HB@ HB@ F5UBP@@@@AAS9^W''9>_''9>_%9]OC0@@@@@7JT=UUUUUUUUUURL)N @@
@@ADD1PTEAPTEAPTEAPSQ@@@@@@@NR8\GA0\GA0\GB89@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[235 235 235 241 241 242 210 211 210 123 123 123 223 224 224 210 210 210 208 208 208 206 206 206 120 120 120 169 169 169 217 217 218 214 214 214 232 232 232 168 168 168 228 228 228 153 153 153 222 222 222 209 209 209 154 154 154 110 110 110 97 97 97 239 239 239 237 237 237 213 213 213 230 230 231 218 218 218 132 132 132 119 119 119 199 199 199 229 229 228 215 215 215 140 140 140 240 240 240 227 227 227 235 235 234 241 241 241 126 126 126 124 124 124 162 162 162 231 231 231 229 229 229 225 225 225 212 212 212 230 230 230 227 227 228 226 226 226 202 202 202 127 127 127 238 238 238 234 234 234 190 190 190 188 188 188 217 217 217 224 224 224 211 211 211 116 116 116 236 236 236 223 223 223 117 117 117 146 146 146 144 144 144 225 224 225 233 233 233 220 220 220 125 125 125 152 152 152 221 221 221 219 219 219 197 197 197 226 226 227 229 229 229 221 222 221 223 223 223 218 218 218 241 241 241 235 235 235 230 230 230 232 232 232 220 220 220 242 242 242 238 238 238 232 232 232 227 227 227 231 232 232 223 223 223 244 244 244 185 185 185 235 235 235 229 229 229 224 224 224 244 244 245 220 220 220 241 241 241 236 236 236 232 232 232 205 205 205 226 226 226 221 221 221 243 243 243 234 234 235 240 240 239 244 244 244 238 238 238 236 236 237 233 233 233 235 235 235 206 206 206 237 238 238 229 229 229 245 245 245 218 218 218 241 241 241 233 233 234 235 235 235 230 230 230 242 242 242 241 241 241 238 238 238 232 232 232 227 227 227 244 244 244 217 217 217 239 239 239 244 244 243 235 235 235 229 229 229 202 202 202 246 246 246 247 247 247 239 239 240 241 241 241 236 236 236 229 230 229 232 232 232 247 247 247 244 244 244 238 238 238 233 233 233 245 245 245 241 242 242 238 238 239 241 241 241 235 235 235 243 243 244 247 247 247 242 242 242 215 215 215 247 247 246 235 236 235 238 238 238 227 227 227 249 249 249 244 244 244 239 239 239 247 247 247 241 241 241 236 236 236 226 226 226 248 248 248 250 250 250 245 245 245 241 241 241 249 249 248 247 247 247 242 242 242 240 241 240 250 250 250 242 242 243 244 244 244 239 239 239 247 247 247 241 241 241 244 245 245 244 244 244 233 233 233 246 246 247]; mask:((Depth1Image new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@G?8@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@G?8@@@@@') ; yourself); yourself]
!

checkToggleOffIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOffIcon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOffIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary checkToggleOffIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
A XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA X@IB@@@@@@@@@@@B@$@@XFA XGGC$NC 8NC 8NC#$5DPXFA X;H3L9B0,KB0,9NPT-N0XF
A XXL#@PD@T3APTSDCP+F@XFA XYBSHUG3P4MCP#KQH"FPXFA XLH#(RL#H2L#H2J2$"C0XFA X7@"<DE!!XVE!!XVAA,BM0XFA X1CQXCJ"X&I"(*N@PMLPXF
A X''@RH:JB (JB :JRHAI0XFA X]I",#LA@PDC@4H2,&GPXFA XWJ0TKC 8NC 8NNPTRM XFA X1I ,NC 8NC 8NC ,&LPXFA X,E@(^G!!8^G!!8^G (TOPXF
A X>OA(ZF!!(ZF!!(ZF!!(<O XFA XFK  !!HRD!!HRD!!HP .A XFA XFA XFA XFA XFA XFA XF') ; colorMapFromArray:#[131 131 131 231 231 231 227 227 227 234 234 234 232 232 232 250 250 250 0 0 0 153 153 153 202 202 202 239 238 239 225 225 225 254 254 254 148 148 148 228 228 228 255 255 255 149 149 149 249 249 249 152 152 152 243 243 243 250 249 249 175 175 175 246 245 245 233 233 233 189 189 189 143 143 143 141 141 141 97 97 97 229 230 229 203 203 204 180 180 180 229 229 229 246 247 246 130 130 130 199 199 199 237 237 237 246 246 246 151 151 151 220 220 220 236 236 236 172 172 172 241 241 241 239 239 239 235 235 235 242 242 242 116 116 116 245 245 245 223 223 223 230 230 230 248 248 248 164 164 164 244 244 244 251 251 251 247 247 247 203 203 203 190 190 190 157 157 157 234 233 234 253 253 253 240 240 240 132 132 132 110 110 110 117 117 117 197 197 197]; mask:((Depth1Image new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@G?8@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@G?8@@@@@') ; yourself); yourself]
!

checkToggleOnDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOnDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOnDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary checkToggleOnDisabledIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@ABA0T@@@@@@@@@@@@@@@@@@@MZH0H@@@@@F @4MCP4MCP4MDTXH @@@@@NM1\QSUIRT$5MI# ''N @@@@@EBB()V1\WE5,7ES /AP@@
@@@OL0,*A@P)A@-LER-WC0@@@@@0S!!IUURPPDCTUG48AL@@@@@@2U3L&VC4MK%%XIT-HU@@@@@@SN5\(P3<1FT<>R5\AD0@@@@@JRCX\RS<UES5QPCYHB @@
@@ADR2)[E0<8NB5[PR(3Q@@@@@@LDBERBRAGGP%VT"DPC@@@@@@,HS0[F1,9L1,[E#0QD @@@@@JAA,[F1,[F1,[F1,DB @@@@AJEE\6M#X6M#X6M%\TGP@@
@@@^A$YFQ$YFQ$YFQ$XFG @@@@@@S%MPTEAPTEAPTEMN@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[142 142 142 222 222 222 209 209 209 145 145 145 236 236 236 132 132 132 110 110 110 88 88 88 230 230 230 248 248 248 164 164 164 233 233 233 180 180 180 218 218 218 165 165 165 143 143 143 234 234 234 243 243 243 190 190 190 157 157 157 175 175 175 60 60 60 253 253 253 240 240 240 32 32 32 123 123 123 163 163 163 254 254 254 232 232 232 117 117 117 197 197 197 82 82 82 244 244 244 242 242 242 136 136 136 52 52 52 174 174 174 183 183 183 130 130 130 77 77 77 219 219 219 237 237 237 235 235 235 140 140 140 189 189 189 176 176 176 216 216 216 194 194 194 141 141 141 119 119 119 148 148 148 228 228 228 131 131 131 160 160 160 229 229 229 196 196 196 61 61 61 214 214 214 161 161 161 221 221 221 250 250 250 73 73 73 122 122 122 58 58 58 231 231 231 238 238 238 103 103 103 81 81 81 172 172 172 37 37 37 97 97 97 95 95 95 224 224 224 191 191 191 116 116 116 227 227 227 92 92 92 245 245 245 223 223 223 57 57 57 199 199 199 217 217 217 246 246 246 202 202 202 149 149 149 74 74 74 247 247 247 225 225 225 59 59 59 68 68 68 46 46 46 239 239 239]; mask:((Depth1Image new) width:18; height:18; bits:(ByteArray fromPackedString:'@@N@@@^@G?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@G?8@@@@@') ; yourself); yourself]
!

checkToggleOnEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOnEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOnEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary checkToggleOnEnteredIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
A0\GA0\GA0\GA0\GA6E/N9\GA0\GA0\GA0\GA0\GA9QN &0GA0\GLD2V%)ZV%)ZVF2\OV \GA0]?B@NN''95QCZZAF$8;*@\GA0]7O@Q4^"QTIB6DS#,/L0\G
A0]]X9ICGRVURV$SS%")HP\GA0^GYDYNS!!TEAUYNN1%@B0\GA0\1"''0LS#-0!!#-NG*EGNP\GA0]W^XV*J$8BED8:Y''D5BP\GA0]=&5@\\$9NS!!@#GA<VO \G
A0^C[S>XP"@;N51BQJU6)@\GA0]EK%-MUW9_PSXRXE.''Y0\GA0\QV2J\$1]SZ!!^SOX2H@P\GA0^K#0X4 HB@ HBIMB&M( \GA0]ON@(,KEIRT$!!8RE:^L \G
A0]%I" (JB (JB (JB &YP\GA0\GA9A5]WU5]WU5]Y@@A0\GA0\GA0\GA0\GA0\GA0\GA0\G') ; colorMapFromArray:#[223 223 223 88 144 206 107 132 153 218 231 243 200 221 240 182 213 239 205 242 254 0 0 0 160 175 210 38 90 174 205 240 248 30 70 160 120 143 161 231 239 248 101 105 109 14 14 32 90 105 118 78 138 203 183 220 251 112 123 132 108 134 156 150 174 194 137 189 231 201 236 254 85 98 108 167 201 231 149 155 161 48 49 134 156 200 237 192 219 240 144 174 201 150 196 235 126 150 171 33 63 155 189 226 253 151 192 226 210 228 243 193 219 240 110 110 110 5 5 37 97 97 97 205 240 254 91 109 124 84 96 107 213 248 252 210 227 243 159 203 239 162 187 209 88 89 163 31 78 167 117 118 119 33 53 147 210 246 254 133 187 230 185 221 252 81 96 107 166 189 206 34 80 167 108 133 155 88 88 88 187 213 236 196 231 254 45 100 181 161 204 240 149 193 230 118 136 151 171 210 243 189 216 240 168 208 242 53 120 194 153 181 206 151 195 231 212 247 251 195 219 240 101 114 125 92 105 114 49 50 142 181 219 250 46 46 46 116 117 118 150 197 235 231 240 248 212 247 252 180 209 224 211 228 243 184 221 252 144 165 183 34 87 173 134 153 168 87 99 108 129 129 136 174 213 246 141 171 195 30 62 155 205 239 248 107 121 135 180 217 249 232 232 232 88 99 108 171 206 234 151 194 231 197 197 197 147 195 234 61 125 197 81 96 106 191 216 238 187 219 234 97 109 119 209 209 209 147 194 234 98 105 121 103 103 103 165 198 227 144 193 232 141 176 207 93 102 108 205 225 241 199 199 199 149 195 234 32 53 147 212 246 251 132 186 229 209 226 243 97 103 108 159 200 234 39 98 179 182 217 246 89 96 165 213 249 254 228 237 247 52 52 52 44 107 186 181 197 210 143 192 232 165 198 225 27 68 160 177 214 247 213 248 254 151 195 232 112 144 178 190 226 253 186 220 249 225 236 246 182 218 249 202 202 202 96 107 118 186 215 238 198 234 254 145 145 145 194 219 241 52 54 145 132 132 132 168 208 243 90 99 108 98 109 119 136 188 231 197 232 254 230 239 248 169 189 206 228 238 247 96 103 109 158 199 234 118 147 180 88 99 109 50 111 188 162 204 240 230 239 247 161 204 239 85 92 161 163 201 232 145 190 228]; mask:((Depth1Image new) width:18; height:18; bits:(ByteArray fromPackedString:'@@^@@@^@G?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@C?8@@@@@') ; yourself); yourself]
!

checkToggleOnIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOnIcon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOnIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary checkToggleOnIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
X6M#X6M#X6M#X6M#X08IR)]#X6M#X6M#X6M#X6M#X9POGII#X6M#($"*********EE4H_&M#X6MULHQB&%.CER12OQB-*VM#X6NH[E]<%WYNLU"3QJ"YA&M#
X6MYO0@8PYA9(V%@E+D''F6M#X6L6''(5(&@H>O%HMDY4KT6M#X6M;)$XC_PQ.TX0$J''@R*6M#X6N#UI,7+$\ZE6^EL58!!YVM#X6NOX#*V"16S$6EZCI1E,FM#
X6NAYF)-SH:F!!''PGJT.IK&M#X6N%S3U_MBTY]1<"!!509OFM#X6L^F@E?'':\S J]CZ0((RVM#X6MM$SH;"+H/,()VI&@+^&M#X6N/)@UPTG!!8^F> [7FBKVM#
X6M5+GM3\7M3\7M3\7N,]VM#X6M#X6X#H2L#H2L#H6X X6M#X6M#X6M#X6M#X6M#X6M#X6M#') ; colorMapFromArray:#[164 202 233 168 217 253 116 148 174 76 106 130 43 58 73 189 235 246 33 53 147 143 195 239 14 14 32 103 103 103 169 217 253 114 173 222 123 182 231 36 48 60 232 232 232 46 46 46 50 56 61 50 68 82 117 175 224 155 194 214 48 49 134 223 234 246 40 51 60 60 94 123 147 199 243 58 77 95 58 92 119 33 63 155 52 52 52 27 44 58 78 138 203 162 210 251 223 223 223 93 165 222 160 209 250 199 199 199 32 47 59 158 205 244 195 243 254 133 183 225 151 201 245 139 193 238 107 148 183 163 209 248 222 234 245 117 118 119 50 111 188 200 247 254 129 149 196 196 220 240 189 238 254 112 176 227 161 210 252 147 199 244 27 68 160 109 169 219 168 204 235 130 187 234 115 178 229 196 244 254 61 125 197 114 122 130 158 199 234 144 190 228 65 79 92 171 207 236 216 230 243 180 227 254 45 53 60 98 168 224 128 182 228 24 43 58 49 50 142 88 144 206 88 88 88 131 187 235 143 195 240 112 144 178 197 220 240 127 186 234 199 246 251 136 179 216 107 136 160 30 70 160 92 164 221 89 96 165 199 246 254 182 210 235 195 218 239 30 62 155 117 171 217 222 234 246 148 199 243 5 5 37 107 173 225 157 207 249 189 235 254 36 56 73 97 166 224 0 0 0 111 174 227 38 90 174 202 202 202 24 43 57 45 61 74 170 203 233 130 187 235 177 224 254 165 199 230 139 193 239 136 180 218 198 245 250 126 181 227 189 234 246 219 232 245 97 97 97 104 143 176 197 197 197 196 219 240 73 97 117 198 245 251 174 207 237 118 147 180 31 78 167 189 215 237 33 47 59 129 129 136 178 225 254 165 208 228 44 107 186 141 168 190 223 235 246 206 223 240 59 93 122 33 48 61 156 205 248 32 53 147 114 176 228 199 247 254 103 150 191 38 55 68 120 157 190 84 116 143 39 98 179 173 207 236 158 206 248 209 209 209 29 46 60 145 145 145 194 217 239 124 182 232 132 132 132 46 61 74 132 165 194 220 233 245 106 172 225 116 177 229 138 184 223 117 174 223 180 228 254 198 244 250 175 207 236 88 89 163 34 87 173 137 167 190 53 120 194 117 175 225 183 230 254 44 53 61 85 92 161 52 54 145 34 80 167 110 110 110 46 55 77 37 61 81 116 117 118 45 100 181 94 119 140 200 248 254 157 178 196]; mask:((Depth1Image new) width:18; height:18; bits:(ByteArray fromPackedString:'@@^@@@^@G?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@O?<@C?8@@@@@') ; yourself); yourself]
!

editFieldRightBorderImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self editFieldRightBorderImage inspect
     ImageEditor openOnClass:self andSelector:#editFieldRightBorderImage
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary editFieldRightBorderImage'
        ifAbsentPut:[(Depth8Image new) width:12; height:23; bits:(ByteArray fromPackedString:'
N#YKERL@@@@@@@@@S1IIT T+B@@@@@@@YEMTHD\JQ$T@@@@@K"9@K1P)KPH2@@@@K"8.K"9@YBHVC @@K"8.K"8.PC@"SS\@K"8.K"8.K$A$E1,@K"8.K"8.
K"9@JU]PK"8.K"8.K"8.LA [K"8.K"8.K"8.K2H_K"8.K"8.K"8.PB%UK"8.K"8.K"8.PFT9K"8.K"8.K"8.P@A!!K"8.K"8.K"8.PBAVK"8.K"8.K"8.K24[
K"8.K"8.K"8.T543K"8.K"8.K"8/G%1ZK"8.K"8.K$@)T%X@K"8.K"8.P@@1W@@@K"8.K"8/HAM\@@@@PD@/LCUNVE0@@@@@A!!$%@U%\W@@@@@@@PTEAPTD@
@@@@@@@@') ; colorMapFromArray:#[246 246 246 193 193 193 191 191 191 220 220 220 136 136 136 165 165 165 225 225 225 90 90 90 150 150 150 97 97 97 208 208 208 93 93 93 91 91 91 89 89 89 149 149 149 178 178 178 125 125 125 185 185 185 214 214 214 192 192 192 252 252 252 137 137 137 197 197 197 226 226 226 224 224 224 222 222 222 107 107 107 167 167 167 196 196 196 112 112 112 234 234 234 181 181 181 241 241 241 239 239 239 237 237 237 153 153 153 233 233 233 211 211 211 96 96 96 187 187 187 216 216 216 245 245 245 110 110 110 139 139 139 199 199 199 228 228 228 255 255 255 253 253 253 251 251 251 198 198 198 145 145 145 174 174 174 121 121 121 243 243 243 128 128 128 157 157 157 186 186 186 184 184 184 131 131 131 242 242 242 240 240 240 105 105 105 103 103 103 132 132 132 254 254 254 170 170 170 230 230 230 115 115 115 173 173 173 140 140 140 169 169 169 229 229 229 94 94 94 205 205 205 152 152 152 130 130 130 159 159 159 188 188 188 217 217 217 215 215 215 162 162 162 160 160 160 189 189 189 249 249 249 247 247 247 194 194 194 172 172 172 201 201 201 179 179 179 177 177 177 175 175 175 204 204 204 171 171 171 200 200 200 147 147 147 238 238 238 92 92 92 183 183 183 161 161 161 190 190 190 250 250 250 248 248 248]; mask:((ImageMask new) width:12; height:23; bits:(ByteArray fromPackedString:'>@C>@O<@?8C?0O? ?>C?<O?0??C?<O?0??C?<O?0??C?<O? ?<C? O<@? C8@@@a') ; yourself); yourself]
!

editFieldWithBorderImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self editFieldWithBorderImage inspect
     ImageEditor openOnClass:self andSelector:#editFieldWithBorderImage
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary editFieldWithBorderImage'
        ifAbsentPut:[(Depth8Image new) width:23; height:23; bits:(ByteArray fromPackedString:'
@@@@@@@@@BLUR3X:O3<?O3<?O3<?O3<@@@@@@@ +AUIID$<(JB (JB (JB (J@@@@@AEQ )GHEQSYFQ$YFQ$YFQ$YFQ$@@@@L H-JR8.K"8.K"8.K"8.K"8.
K"8@@@8VH&Q@K"8.K"8.K"8.K"8.K"8.K @7SRH0PD@.K"8.K"8.K"8.K"8.K"8.C1,WYD@.K"8.K"8.K"8.K"8.K"8.K"9PU2%@K"8.K"8.K"8.K"8.K"8.
K"8.K!!,XLB8/K"8.K"8.K"8.K"8.K"8.K"8.G2H/K!!P.K"8.K"8.K"8.K"8.K"8.K"9UJT@.LB8.K"8.K"8.K"8.K"8.K"8.K!!E%PB8TK"8.K"8.K"8.K"8.
K"8.K"8.XPA@K"<.K"8.K"8.K"8.K"8.K"8.K"9VHD@.K28.K"8.K"8.K"8.K"8.K"8.K!!,-K28.K"8.K"8.K"8.K"8.K"8.K"8.L55SK"8.K"8.K"8.K"8.
K"8.K"8.K"9ZWA8/K"8.K"8.K"8.K"8.K"8.K"8.K AVNB%@K"9@K"8.K"8.K"8.K"8.K"8.@@A\K@A@K"8.K"8.K"8.K"8.K"8.K"8@@@A\GB@/K"8.K"8.
K"8.PB8.K"8.K @@@@A\VD85LB=@PDA@PDA@PDA@PDA@@@@@@@A\VU$AIQ$FA XFA XFA XFA X@@@@@@@@@WDEAPTEAPTEAPTEAPTEAPP@a') ; colorMapFromArray:#[246 246 246 193 193 193 191 191 191 220 220 220 136 136 136 165 165 165 225 225 225 90 90 90 150 150 150 97 97 97 208 208 208 93 93 93 91 91 91 89 89 89 149 149 149 178 178 178 125 125 125 185 185 185 214 214 214 192 192 192 252 252 252 137 137 137 197 197 197 226 226 226 224 224 224 222 222 222 107 107 107 167 167 167 196 196 196 112 112 112 234 234 234 181 181 181 241 241 241 239 239 239 237 237 237 153 153 153 233 233 233 211 211 211 96 96 96 187 187 187 216 216 216 245 245 245 110 110 110 139 139 139 199 199 199 228 228 228 255 255 255 253 253 253 251 251 251 198 198 198 145 145 145 174 174 174 121 121 121 243 243 243 128 128 128 157 157 157 186 186 186 184 184 184 131 131 131 242 242 242 240 240 240 105 105 105 103 103 103 132 132 132 254 254 254 170 170 170 230 230 230 115 115 115 173 173 173 140 140 140 169 169 169 229 229 229 94 94 94 205 205 205 152 152 152 130 130 130 159 159 159 188 188 188 217 217 217 215 215 215 162 162 162 160 160 160 189 189 189 249 249 249 247 247 247 194 194 194 172 172 172 201 201 201 179 179 179 177 177 177 175 175 175 204 204 204 171 171 171 200 200 200 147 147 147 238 238 238 92 92 92 183 183 183 161 161 161 190 190 190 250 250 250 248 248 248]; mask:((ImageMask new) width:23; height:23; bits:(ByteArray fromPackedString:'@_?>A??>C??>G??>O??>_??>???>???>???>???>???>???>???>???>???>???>???>_??>O??>G??>C??>A??>@_?>') ; yourself); yourself]
!

editFieldWithSearchLeftBorderImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self editFieldWithSearchLeftBorderImage inspect
     ImageEditor openOnClass:self andSelector:#editFieldWithSearchLeftBorderImage
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary editFieldWithSearchLeftBorderImage'
        ifAbsentPut:[(Depth8Image new) width:23; height:23; bits:(ByteArray fromPackedString:'
@@@@@@@@@BLUR3X:O3<?O3<?O3<?O3<@@@@@@@ +AUIID$<(JB (JB (JB (J@@@@@AEQ )GHEQSYFQ$YFQ$YFQ$YFQ$@@@@L H-JQP/PB8.K"8.K"8.K"8.
K"8@@@8VH&Q@K"8.K"8.K"8.K"8.K"8.K @7SRH0PD@,R$MCH21@K"8.K"8.K"8.C1,WYD@.VRXKC@0KI%%@K"8.K"8.K"9PU2%@K"1HOT1[V40=RB0.K"8.
K"8.K!!,XLB8/W ]"HR$)W6HGW"<.K"8.K"8.G2H/K!!PZCR 0PDA$J@4ZK28.K"8.K"9UJT@.LC4MFT@.K$@YCS4TK"8.K"8.K!!E%PB8TJ043PB8.PCLMJ3@.
K"8.K"8.XPA@K"<QCR(OP$IYJ 4OEB8.K"8.K"9VHD@.K2AQA4 IBT GCSP<K"8.K"8.K!!,-K28.LE=XAC8>ADD]CA@ K"8.K"8.L55SK"8.EB@$P$\^H L]
XA@;K"8.K"9ZWA8/K"8.K1P0LAQ@@@L]RE,.K"8.K AVNB%@K"8.K"8.K"9@U@L8JT@.K"8.@@A\K@A@K"8.K"8.K"9@T0@/K"8.K"8@@@A\GB@/K"8.K"8.
K"8.PB8.K"8.K @@@@A\VD85LB=@PDA@PDA@PDA@PDA@@@@@@@A\VU$AIQ$FA XFA XFA XFA X@@@@@@@@@WDEAPTEAPTEAPTEAPTEAPP@a') ; colorMapFromArray:#[246 246 246 193 193 193 191 191 191 220 220 220 136 136 136 165 165 165 225 225 225 90 90 90 150 150 150 97 97 97 208 208 208 93 93 93 91 91 91 89 89 89 149 149 149 178 178 178 125 125 125 185 185 185 214 214 214 192 192 192 252 252 252 137 137 137 197 197 197 226 226 226 224 224 224 222 222 222 107 107 107 167 167 167 196 196 196 112 112 112 234 234 234 181 181 181 241 241 241 239 239 239 237 237 237 153 153 153 233 233 233 211 211 211 96 96 96 187 187 187 216 216 216 245 245 245 110 110 110 139 139 139 199 199 199 228 228 228 255 255 255 253 253 253 251 251 251 198 198 198 145 145 145 174 174 174 121 121 121 243 243 243 128 128 128 157 157 157 186 186 186 184 184 184 131 131 131 242 242 242 240 240 240 105 105 105 103 103 103 132 132 132 254 254 254 170 170 170 230 230 230 115 115 115 173 173 173 140 140 140 169 169 169 229 229 229 94 94 94 205 205 205 152 152 152 130 130 130 159 159 159 188 188 188 217 217 217 215 215 215 162 162 162 160 160 160 189 189 189 249 249 249 247 247 247 194 194 194 172 172 172 201 201 201 179 179 179 177 177 177 175 175 175 204 204 204 171 171 171 200 200 200 147 147 147 238 238 238 92 92 92 183 183 183 161 161 161 190 190 190 250 250 250 248 248 248]; mask:((ImageMask new) width:23; height:23; bits:(ByteArray fromPackedString:'@_?>A??>C??>G??>O??>_??>???>???>???>???>???>???>???>???>???>???>???>_??>O??>G??>C??>A??>@_?>') ; yourself); yourself]
!

radioOffDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOffDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#radioOffDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary radioOffDisabledIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@C=PTC<@@@@@@@@@@@@@@C=\O@=WHA]@WC<@@@@@@@@@B"  UAHLCCD9A2 J@@@@@@@JN@4HHRD!!HRDLU T8B @@@C<2SC >AD$LL0PQM3!!FL#<@
@A4ANQ<5@!!XQDQX^V@X;EQ4@T@8,IR,?R1,^G#UGU",-FP8@TDQTA!!4JO1L7M1L?B$HI@TQPTT)^W@(SM4,1LT,7D0(+K$)QTU-SC#=GV#8>O#9ZR5%MPU-Q
TET=L"L^E!!@DW1@VIC\0I5UP@C@@P3<VL2D!!HQ0XDQHF@C@@@CP/U0(PHRD!!HRD!!ABLKK3P@@E@_ED=RGBD!!HRD\O0LTG5@@@@AQJ"X"OTL>O$ ''H"X*TP@@
@@@@TSYAJTU]WTT)PSYQ@@@@@@@@@E@:A$8ZF$8FN%@@@@@@@@@@@@@@O5EBP%D?@@@@@@@@') ; colorMapFromArray:#[122 122 122 151 151 151 242 242 242 107 107 107 249 249 249 114 114 114 205 205 205 110 110 110 221 220 220 208 208 208 226 226 226 111 111 111 253 253 253 118 118 118 209 209 209 125 125 125 247 247 247 245 245 245 232 232 232 230 230 230 135 135 135 153 153 153 244 244 244 129 129 129 251 251 251 136 136 136 176 176 176 237 238 237 254 254 254 221 221 221 239 239 239 206 206 206 113 113 113 255 255 255 89 89 89 231 231 231 240 240 240 187 187 187 134 134 134 132 132 132 181 181 181 117 117 117 197 197 197 215 215 215 131 131 131 191 191 191 169 169 169 167 167 167 207 207 207 236 236 236 203 203 203 252 252 252 219 219 219 237 237 237 204 204 204 233 233 233 180 180 180 158 158 158 218 218 218 165 165 165 163 163 163 130 130 130 241 241 241 228 228 228 164 164 164 162 162 162 222 222 222 200 200 200 198 198 198 94 94 94 123 123 123 234 234 234 201 201 201 250 250 250 186 186 186 235 235 235 120 120 120 211 211 211 189 189 189 105 105 105 227 227 227 225 225 225 223 223 223 159 159 159 146 146 146 195 195 195 224 224 224 109 109 109 232 232 231 229 229 229 238 238 238 185 185 185 214 214 214 88 88 88 168 168 168 248 248 248]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@^@?C?0?G?8?O?<?_?>?_?>???>?????????????????_?>?_?>?_?>?O?<?G?8?C?0?@?@?') ; yourself); yourself]
!

radioOffEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOffEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#radioOffEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary radioOffEnteredIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@C=PTC<@@@@@@@@@@@@@@C=\O@=WHA]@WC<@@@@@@@@@B"  UAHLCCD9A2 J@@@@@@@JN@4HHRD!!HRDLU T8B @@@C<2SC >AD$LL0PQM3!!FL#<@
@A4ANQ<5@!!XQDQX^V@X;EQ4@T@8,IR,?R1,^G#UGU",-FP8@TDQTA!!4JO1L7M1L?B$HI@TQPTT)^W@(SM4,1LT,7D0(+K$)QTU-SC#=GV#8>O#9ZR5%MPU-Q
TET=L"L^E!!@DW1@VIC\0I5UP@C@@P3<VL2D!!HQ0XDQHF@C@@@CP/U0(PHRD!!HRD!!ABLKK3P@@E@_ED=RGBD!!HRD\O0LTG5@@@@AQJ"X"OTL>O$ ''H"X*TP@@
@@@@TSYAJTU]WTT)PSYQ@@@@@@@@@E@:A$8ZF$8FN%@@@@@@@@@@@@@@O5EBP%D?@@@@@@@@') ; colorMapFromArray:#[122 122 122 151 151 151 242 242 242 107 107 107 249 249 249 114 114 114 205 205 205 110 110 110 221 220 220 208 208 208 226 226 226 111 111 111 253 253 253 118 118 118 209 209 209 125 125 125 247 247 247 245 245 245 232 232 232 230 230 230 135 135 135 153 153 153 244 244 244 129 129 129 251 251 251 136 136 136 176 176 176 237 238 237 254 254 254 221 221 221 239 239 239 206 206 206 113 113 113 255 255 255 89 89 89 231 231 231 240 240 240 187 187 187 134 134 134 132 132 132 181 181 181 117 117 117 197 197 197 215 215 215 131 131 131 191 191 191 169 169 169 167 167 167 207 207 207 236 236 236 203 203 203 252 252 252 219 219 219 237 237 237 204 204 204 233 233 233 180 180 180 158 158 158 218 218 218 165 165 165 163 163 163 130 130 130 241 241 241 228 228 228 164 164 164 162 162 162 222 222 222 200 200 200 198 198 198 94 94 94 123 123 123 234 234 234 201 201 201 250 250 250 186 186 186 235 235 235 120 120 120 211 211 211 189 189 189 105 105 105 227 227 227 225 225 225 223 223 223 159 159 159 146 146 146 195 195 195 224 224 224 109 109 109 232 232 231 229 229 229 238 238 238 185 185 185 214 214 214 88 88 88 168 168 168 248 248 248]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@^@?C?0?G?8?O?<?_?>?_?>???>?????????????????_?>?_?>?_?>?O?<?G?8?C?0?@?@?') ; yourself); yourself]
!

radioOffIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOffIcon inspect
     ImageEditor openOnClass:self andSelector:#radioOffIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary radioOffIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@C=PTC<@@@@@@@@@@@@@@C=\O@=WHA]@WC<@@@@@@@@@B"  UAHLCCD9A2 J@@@@@@@JN@4HHRD!!HRDLU T8B @@@C<2SC >AD$LL0PQM3!!FL#<@
@A4ANQ<5@!!XQDQX^V@X;EQ4@T@8,IR,?R1,^G#UGU",-FP8@TDQTA!!4JO1L7M1L?B$HI@TQPTT)^W@(SM4,1LT,7D0(+K$)QTU-SC#=GV#8>O#9ZR5%MPU-Q
TET=L"L^E!!@DW1@VIC\0I5UP@C@@P3<VL2D!!HQ0XDQHF@C@@@CP/U0(PHRD!!HRD!!ABLKK3P@@E@_ED=RGBD!!HRD\O0LTG5@@@@AQJ"X"OTL>O$ ''H"X*TP@@
@@@@TSYAJTU]WTT)PSYQ@@@@@@@@@E@:A$8ZF$8FN%@@@@@@@@@@@@@@O5EBP%D?@@@@@@@@') ; colorMapFromArray:#[122 122 122 151 151 151 242 242 242 107 107 107 249 249 249 114 114 114 205 205 205 110 110 110 221 220 220 208 208 208 226 226 226 111 111 111 253 253 253 118 118 118 209 209 209 125 125 125 247 247 247 245 245 245 232 232 232 230 230 230 135 135 135 153 153 153 244 244 244 129 129 129 251 251 251 136 136 136 176 176 176 237 238 237 254 254 254 221 221 221 239 239 239 206 206 206 113 113 113 255 255 255 89 89 89 231 231 231 240 240 240 187 187 187 134 134 134 132 132 132 181 181 181 117 117 117 197 197 197 215 215 215 131 131 131 191 191 191 169 169 169 167 167 167 207 207 207 236 236 236 203 203 203 252 252 252 219 219 219 237 237 237 204 204 204 233 233 233 180 180 180 158 158 158 218 218 218 165 165 165 163 163 163 130 130 130 241 241 241 228 228 228 164 164 164 162 162 162 222 222 222 200 200 200 198 198 198 94 94 94 123 123 123 234 234 234 201 201 201 250 250 250 186 186 186 235 235 235 120 120 120 211 211 211 189 189 189 105 105 105 227 227 227 225 225 225 223 223 223 159 159 159 146 146 146 195 195 195 224 224 224 109 109 109 232 232 231 229 229 229 238 238 238 185 185 185 214 214 214 88 88 88 168 168 168 248 248 248]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@^@?C?0?G?8?O?<?_?>?_?>???>?????????????????_?>?_?>?_?>?O?<?G?8?C?0?@?@?') ; yourself); yourself]
!

radioOnDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOnDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#radioOnDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary radioOnDisabledIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@DB@ D@@@@@@@@@@@@@@@DCA@TFA0 D@0D@@@@@@@@@BP(KC@4NC0LPDQHI@@@@@@@ID1PUE!!\XFQ([GA4SBP@@@@D^G2@!!H"L$IRX''JB$*G D@
@B,,KR8/LCD2L3P5M#\8NR,@@C(@N30=O#=@PTICQDUFQ3(@@$!!IR$-LST9OS49PSEER@D BT5QUU%]XVU)[V5)\VE5^W5QST6A!!X&M$YVY''Y6!!)Z&-,[VAS
@&9/\GE2\7Q5]WY3]7!!9^&8B@G-<_W9? HFB 8RE!!!!2G_G,@@H R"X*K#H6N#9BQ$)NTD( @@@JU%)^XFY&Z&92]'')>V%PH@@@AS(JF"(:R%)ZZ''(*F T0@@
@@@@T:")**.,+J.**Z!!S@@@@@@@@@@J-+*>0,J>.+PH@@@@@@@@@@@@@@UN1,ULA@@@@@@@@') ; colorMapFromArray:#[77 77 77 228 228 228 227 227 227 211 211 211 139 139 139 82 82 82 59 59 59 62 62 62 87 87 87 226 226 226 167 167 167 56 56 56 81 81 81 206 206 206 244 244 244 243 243 243 99 99 99 55 55 55 167 167 167 165 165 165 52 52 52 172 172 172 211 211 211 221 221 221 223 223 223 222 222 222 218 218 218 207 207 207 174 174 174 50 50 50 202 202 202 58 58 58 87 87 87 180 180 180 194 194 194 199 199 199 202 202 202 201 201 201 196 196 196 189 189 189 167 167 167 86 86 86 58 58 58 221 221 221 126 126 126 74 74 74 111 111 111 171 171 171 182 182 182 184 184 184 175 175 175 175 175 175 183 183 183 176 176 176 160 160 160 110 110 110 77 77 77 127 127 127 209 209 209 92 92 92 126 126 126 156 156 156 167 167 167 111 111 111 42 42 42 41 41 41 109 109 109 164 164 164 146 146 146 127 127 127 95 95 95 79 79 79 198 198 198 73 73 73 109 109 109 138 138 138 149 149 149 144 144 144 37 37 37 37 37 37 143 143 143 139 139 139 116 116 116 225 225 225 186 186 186 87 87 87 123 123 123 148 148 148 160 160 160 155 155 155 40 40 40 40 40 40 154 154 154 150 150 150 130 130 130 95 95 95 185 185 185 103 103 103 123 123 123 156 156 156 171 171 171 178 178 178 118 118 118 44 44 44 117 117 117 179 179 179 172 172 172 161 161 161 133 133 133 112 112 112 195 195 195 106 106 106 119 119 119 163 163 163 181 181 181 192 192 192 198 198 198 187 187 187 197 197 197 183 183 183 170 170 170 133 133 133 111 111 111 207 207 207 121 121 121 140 140 140 164 164 164 192 192 192 206 206 206 214 214 214 215 215 215 215 215 215 212 212 212 207 207 207 197 197 197 152 152 152 219 219 219 99 99 99 169 169 169 203 203 203 219 219 219 231 231 231 233 233 233 232 232 232 229 229 229 221 221 221 208 208 208 180 180 180 101 101 101 206 206 206 135 135 135 96 96 96 179 179 179 232 232 232 240 240 240 240 240 240 233 233 233 224 224 224 188 188 188 98 98 98 197 197 197 134 134 134 89 89 89 115 115 115 172 172 172 215 215 215 175 175 175 117 117 117 204 204 204 162 162 162 117 117 117 94 94 94 88 88 88 218 218 218 205 205 205 189 189 189 176 176 176 222 222 222]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@^@?C?0?G?8?O?<?_?>?_?>?_?>?????????????????_?>?_?>?_?>?O?<?G?8?C?0?@?@?') ; yourself); yourself]
!

radioOnEnteredIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOnEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#radioOnEnteredIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary radioOnEnteredIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@G]EQW\@@@@@@@@@@@@@@G^LV0);-:A[#G\@@@@@@@@@YF)DB3&C#&ZW[YM$@@@@@@A$LJU''RJXS($)4BQX0Y@@@@G^BWVVP]SZ-G*\=@''E< ''\@
@BJV[''@)N9<#%FMIWH<WD"H@@B8GKS]MCX56DI&U"U>Z,B8@QR<8\92RDPL>O LH$&!! @B=EQ;T3[205XU"X&E"AMZ<(,+UGQ3H!!*DD+\ E=_T@*!!HUUCCIG
QUB)"A4<^U:1,Q!!9*%FQT%AE@J.FU@Z6^!!0:F4L'''' V.!!*,@@H)WMCF#S7!!,U&HZ"5*3U8(@@DV!!I), -DH%_2R]G:P&(TT@@@AGS*1SR40OC79)T:1NQ0@@
@@@@Q1PUC&.G!!6,NEQQG@@@@@@@@@DTYQ QYVPQFFTT@@@@@@@@@@@@@]4\?O4]7@@@@@@@@') ; colorMapFromArray:#[33 85 163 90 126 156 129 178 220 21 42 57 189 189 189 130 187 235 114 178 231 54 77 148 92 158 211 151 180 214 70 77 150 59 81 154 79 120 171 121 180 229 117 117 117 185 226 240 30 45 59 93 159 212 117 127 165 208 227 245 204 204 204 162 162 162 27 47 140 27 88 170 158 208 250 218 218 218 187 234 254 180 227 254 179 226 254 112 178 231 175 208 238 158 197 233 143 190 230 64 113 168 221 221 221 143 184 220 200 246 254 208 255 255 135 135 135 171 218 253 66 149 216 129 183 227 135 192 239 122 185 234 90 165 224 27 109 189 209 209 209 198 198 198 162 164 189 125 181 232 185 185 185 34 99 177 91 102 112 107 175 229 172 207 236 60 145 213 34 79 162 197 207 229 181 227 254 145 192 233 137 194 241 159 198 232 23 42 57 222 222 222 89 125 154 102 172 228 199 246 254 177 224 254 37 52 140 227 227 227 205 205 205 225 225 225 193 216 237 137 187 231 202 223 242 103 119 133 147 181 202 103 171 225 197 197 197 184 232 254 195 195 195 123 184 234 96 114 138 89 89 89 95 152 206 72 150 216 200 245 254 167 167 167 27 44 60 176 176 176 142 191 234 132 136 178 114 174 223 34 56 143 159 209 251 62 146 212 46 136 207 109 169 217 196 242 254 146 194 234 226 226 226 26 103 179 204 212 232 147 178 213 78 157 219 106 121 133 163 166 192 94 94 94 200 247 254 38 51 138 28 82 168 54 144 213 42 131 201 26 102 177 134 191 238 35 131 204 188 213 235 167 202 234 30 46 60 228 228 228 197 245 254 152 204 247 169 218 253 46 53 138 34 57 143 33 48 62 152 183 200 208 254 255 229 229 229 108 168 216 202 202 207 239 246 254 125 186 235 109 176 230 121 121 121 88 88 88 56 137 209 90 163 221 219 219 219 174 219 253 211 211 217 82 120 151 238 245 253 42 130 199 146 190 226 76 149 213 91 166 224 163 165 191 143 184 219 117 178 228 117 125 164 80 99 164 27 44 58 80 118 150 26 115 190 90 98 107 76 156 219 192 236 254 158 208 249 148 194 234 75 82 153 206 206 206 207 226 245 166 214 252 93 100 107 26 50 144 205 226 243 168 204 236 56 142 213 90 110 136 141 195 241 207 207 207 134 134 134 176 209 238 115 162 210 93 166 225 53 82 148 152 197 235 45 107 179 96 103 113 188 234 254 186 186 186 151 204 248 49 56 140]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@^@?C?0?G?8?O?<?_?>?_?>?_?>?????????????????_?>?_?>?_?>?O?<?G?8?C?0?@?@?') ; yourself); yourself]
!

radioOnIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOnIcon inspect
     ImageEditor openOnClass:self andSelector:#radioOnIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary radioOnIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@G]EQW\@@@@@@@@@@@@@@G^LV0);-:A[#G\@@@@@@@@@YF)DB3&C#&ZW[YM$@@@@@@A$LJU''RJXS($)4BQX0Y@@@@G^BWVVP]SZ-G*\=@''E< ''\@
@BJV[''@)N9<#%FMIWH<WD"H@@B8GKS]MCX56DI&U"U>Z,B8@QR<8\92RDPL>O LH$&!! @B=EQ;T3[205XU"X&E"AMZ<(,+UGQ3H!!*DD+\ E=_T@*!!HUUCCIG
QUB)"A4<^U:1,Q!!9*%FQT%AE@J.FU@Z6^!!0:F4L'''' V.!!*,@@H)WMCF#S7!!,U&HZ"5*3U8(@@DV!!I), -DH%_2R]G:P&(TT@@@AGS*1SR40OC79)T:1NQ0@@
@@@@Q1PUC&.G!!6,NEQQG@@@@@@@@@DTYQ QYVPQFFTT@@@@@@@@@@@@@]4\?O4]7@@@@@@@@') ; colorMapFromArray:#[33 85 163 90 126 156 129 178 220 21 42 57 189 189 189 130 187 235 114 178 231 54 77 148 92 158 211 151 180 214 70 77 150 59 81 154 79 120 171 121 180 229 117 117 117 185 226 240 30 45 59 93 159 212 117 127 165 208 227 245 204 204 204 162 162 162 27 47 140 27 88 170 158 208 250 218 218 218 187 234 254 180 227 254 179 226 254 112 178 231 175 208 238 158 197 233 143 190 230 64 113 168 221 221 221 143 184 220 200 246 254 208 255 255 135 135 135 171 218 253 66 149 216 129 183 227 135 192 239 122 185 234 90 165 224 27 109 189 209 209 209 198 198 198 162 164 189 125 181 232 185 185 185 34 99 177 91 102 112 107 175 229 172 207 236 60 145 213 34 79 162 197 207 229 181 227 254 145 192 233 137 194 241 159 198 232 23 42 57 222 222 222 89 125 154 102 172 228 199 246 254 177 224 254 37 52 140 227 227 227 205 205 205 225 225 225 193 216 237 137 187 231 202 223 242 103 119 133 147 181 202 103 171 225 197 197 197 184 232 254 195 195 195 123 184 234 96 114 138 89 89 89 95 152 206 72 150 216 200 245 254 167 167 167 27 44 60 176 176 176 142 191 234 132 136 178 114 174 223 34 56 143 159 209 251 62 146 212 46 136 207 109 169 217 196 242 254 146 194 234 226 226 226 26 103 179 204 212 232 147 178 213 78 157 219 106 121 133 163 166 192 94 94 94 200 247 254 38 51 138 28 82 168 54 144 213 42 131 201 26 102 177 134 191 238 35 131 204 188 213 235 167 202 234 30 46 60 228 228 228 197 245 254 152 204 247 169 218 253 46 53 138 34 57 143 33 48 62 152 183 200 208 254 255 229 229 229 108 168 216 202 202 207 239 246 254 125 186 235 109 176 230 121 121 121 88 88 88 56 137 209 90 163 221 219 219 219 174 219 253 211 211 217 82 120 151 238 245 253 42 130 199 146 190 226 76 149 213 91 166 224 163 165 191 143 184 219 117 178 228 117 125 164 80 99 164 27 44 58 80 118 150 26 115 190 90 98 107 76 156 219 192 236 254 158 208 249 148 194 234 75 82 153 206 206 206 207 226 245 166 214 252 93 100 107 26 50 144 205 226 243 168 204 236 56 142 213 90 110 136 141 195 241 207 207 207 134 134 134 176 209 238 115 162 210 93 166 225 53 82 148 152 197 235 45 107 179 96 103 113 188 234 254 186 186 186 151 204 248 49 56 140]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@^@?C?0?G?8?O?<?_?>?_?>?_?>?????????????????_?>?_?>?_?>?O?<?G?8?C?0?@?@?') ; yourself); yourself]
!

scrollDownActiveIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollDownActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownActiveIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'VistaToolbarIconLibrary class scrollDownActiveIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@ADWEAPTEAPTEAPTEAP)D A@O"H,M#X6@PDARQX=LB$@EBH!!O4!!HRDUEQT<%C3DT@AP,O0)QQ4\EAPTEAB4&E@@TM$!!QG" (SD1LSA%AS!!P@ECYHQ1<VE"\''
I2\;ID8T@AP6RAXHJ L.P4QMGA1NE@@TM$ _E# GB1 BN2P$S!!P@ECYHJA<VP#$<I2=APT8T@AP6RB (G1<ZI1,YPTENE@@TM$ (JB (F1-LFTEAS!!P@ECX4
Q2 (JD1LSD0YM48T@AQJL3IPTE@YFQ$YH4-NE@@TMTXSGQ4]PTEAM4,NS!!P@CP$ @ATUET9NS$9NS!!@+@C(MEAPTEAPTEAPTEAPLA @a');
                colorMapFromArray:#[ 203 226 236 211 239 250 69 137 173 105 160 189 111 201 239 131 209 242 152 178 198 30 75 99 35 88 116 189 217 232 198 234 249 50 125 165 64 116 156 79 126 162 98 177 211 109 198 235 139 179 201 153 177 195 162 186 204 171 219 239 24 89 138 201 224 234 204 236 250 64 114 153 80 144 178 108 196 233 18 46 61 141 213 243 157 211 233 170 217 236 176 225 247 192 231 249 206 231 241 221 243 251 238 249 253 105 192 228 134 201 228 138 212 243 161 203 221 163 221 245 175 225 247 43 94 132 49 123 162 60 112 152 234 247 253 104 190 226 130 176 200 139 208 238 157 201 223 167 211 230 175 225 246 190 231 248 201 235 249 218 241 251 231 246 252 102 185 220 14 34 45 22 55 72 163 183 199 161 217 241 37 94 124 189 230 248 204 222 233 211 239 251 69 120 158 102 186 221 13 31 41 145 185 207 157 193 212 159 220 245 174 223 244 186 229 248 202 236 249 211 238 250 227 244 252 100 182 216 111 202 240 143 184 206 158 199 217 158 219 245 173 222 243 187 230 248 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b');
                            yourself);
                yourself
        ]
!

scrollDownOffEntered1Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollDownOffEntered1Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownOffEntered1Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollDownOffEntered1Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@A8QC@4MCP4MCP4MCP4PE @QLTIBP$EAN#$8MSL.IA@@BTIBPS8=OCD.KR,%F2XN@@%APS<<N3$-J"$&G1($C @IPS<=N3$6J"\%H!!8YI@8@BTD?OS8?OSP1
LB8,FRPN@@%AO34EA1TXG"H]JQ$$C @IPS<=O0DDB@<LKB0YI@8@BTD?OS0=@@LFK"X&FRPN@@%AO349N3PBLB$^G!!$$C @IPS<=N3$6K3D,H!!8YI@8@BTD?
OS,9M"(''IRH^FRPN@@%AO309NCP)I"P!!GA $C @IO309MSP2I"P!!G!!,WI@8@D3D=N3$9NB4+J"$(I!!<T@B@SB (JB (KB ,KB0,RH0@a');
                colorMapFromArray:#[ 52 52 50 56 56 60 68 70 70 80 78 80 100 100 100 112 112 110 120 118 120 144 144 140 148 146 150 152 152 150 152 154 150 156 154 150 156 158 160 160 158 160 160 160 160 164 162 160 164 166 170 168 168 170 172 170 170 172 172 170 172 174 170 176 178 180 188 188 190 188 190 190 192 192 190 192 192 200 192 194 200 196 196 200 196 198 200 200 198 200 200 200 200 200 202 200 204 204 200 204 204 210 204 206 210 208 206 210 208 208 210 208 210 210 212 212 210 212 214 220 216 214 220 216 216 220 216 218 220 220 218 220 220 220 220 220 222 220 224 224 230 224 226 230 228 226 230 228 228 230 228 230 230 232 230 230 232 232 230 232 234 230 232 234 240 236 234 230 236 234 240 236 236 240 236 238 240 240 238 240 240 240 240 240 242 240 244 242 240 244 244 240 244 244 250 244 246 250 248 246 250 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b');
                            yourself);
                yourself
        ]
!

scrollDownOffEntered2Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollDownOffEntered2Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownOffEntered2Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollDownOffEntered2Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@A<NBP$IBP$IBP$IBP$KGP@PN41KR4-KRT%IRT%HM@,@BT1EP#<?O28.K"4(HDDI@@%KP#48NC &I"X&H!!,:BP@IR3<8M#X6H2L#H18ZM0$@BT,?NC1@PB</
K2<,F#\I@@%KO3 EA1DSEQ$TJ1(7BP@IR3<8P@DDB@0JKBTZM0$@BT,?NC1@@@LFK2\ZF#\I@@%KO3 6OB<BK2(^F!!(7BP@IR3<8M#X6J"<*H18ZM0$@BT,?
NCX6M"L#H2L^FC\I@@%KNST2L#H^G!!8^GA\7BP@IR#L1LC@0F!!(ZFA\VM0$@D#9GQ$QDQC\7M3\7M2$M@BPRBP$IBP$IBP$IBP$OHP@a');
                colorMapFromArray:#[ 12 38 52 13 41 57 17 56 76 20 66 91 28 91 124 32 106 145 34 113 155 45 148 203 46 151 207 60 127 177 66 161 212 71 123 162 76 166 214 89 143 184 92 144 183 93 147 188 97 149 188 103 179 220 105 154 191 128 192 226 141 198 229 143 199 229 148 192 216 152 198 222 155 201 226 155 205 232 156 202 227 159 206 232 160 208 233 162 186 204 164 213 239 166 191 209 166 215 241 167 194 214 168 218 245 169 219 246 174 195 211 177 213 233 181 224 247 183 222 242 185 226 248 187 202 213 187 227 248 192 221 237 197 228 245 197 231 249 198 231 249 200 232 249 207 229 242 209 231 244 211 235 247 212 236 248 213 226 235 213 237 250 214 238 251 219 221 223 220 240 251 222 241 252 223 225 227 223 234 242 223 242 252 226 242 252 227 235 241 227 244 252 229 244 252 231 234 236 233 246 253 234 234 234 238 239 240 238 248 253 240 240 242 244 245 246 250 252 254 251 253 254 253 253 255 253 254 255 254 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b');
                            yourself);
                yourself
        ]
!

scrollDownOffIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollDownOffIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownOffIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'VistaToolbarIconLibrary class scrollDownOffIcon'
	ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHCAP HB@ H
B@ GA@TF@@DB@0 RD1PUE!!\XB@PEA @A@ LEB@4NC1@QB@\DAPX@@PHC@0THB ,LB@\CA@TF@@DB@0LCAP IB@\C@0PEA @A@ LC@0LGB@\C@0LDAPX@@PHC
@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @a') ; colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; yourself]
!

scrollLeftActiveIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollLeftActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftActiveIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'VistaToolbarIconLibrary class scrollLeftActiveIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@BHIK2</K2</K2</K2</BQ!!QI2$3Q4]GQ4]GQ4\TQ"T2K2$<GQHRD!!HRD!!HGS!!AOK2<3GQ0[DQDGT@\QDT4.I"</Q1H[NTL:N2P;
P4LZNC@/K4\RDTL:N3UEN4MCF# 0K2=GD!!D:N3<#@C-CP1(8LB</D1$MP!!]@LR-B@PDVO L/K1LYCP9BAQ=JP DAE#8CK2<SFP4AC$H^R4HA@QX>@2</B@<M
@PDNP IB@PDVM@L/K3,6RQXVE"0DKAXVHD CK2<FCB(>O#8>O#8>MD K@2<=PT07@0LC@0LC@0LC@2EDKR /K2</K2</K2</K2=DB @a');
                colorMapFromArray:#[ 105 160 189 111 202 240 143 184 206 158 199 217 161 217 241 37 94 124 188 230 248 201 235 249 211 238 250 69 120 158 104 128 146 98 177 211 109 198 235 131 209 242 141 213 243 158 219 245 174 223 244 186 229 248 202 236 249 211 239 250 227 244 252 248 248 248 108 196 233 18 46 61 153 177 195 159 220 245 173 222 243 187 230 248 198 234 249 210 239 251 69 137 173 80 144 178 105 192 228 139 179 201 152 176 194 30 75 99 35 88 116 189 217 232 203 226 236 210 227 237 66 117 155 238 249 253 104 190 226 130 176 200 139 208 238 162 186 204 171 219 239 24 89 138 201 224 234 50 125 165 64 115 153 234 247 253 102 185 220 14 34 45 138 212 243 161 203 221 170 217 236 176 225 247 192 231 249 204 236 250 221 243 251 72 123 161 102 186 221 13 31 41 22 55 72 154 197 220 163 221 245 175 225 247 43 94 132 49 123 162 218 241 251 231 246 252 100 182 216 111 201 239 145 185 207 157 193 212 167 211 230 175 225 246 190 231 248 206 231 241 211 238 251 70 121 159 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C???????????????????????????????????????<b');
                            yourself);
                yourself
        ]
!

scrollLeftOffEntered1Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollLeftOffEntered1Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftOffEntered1Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollLeftOffEntered1Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@=NC@1ZV%)ZC@0LC@0LS =NUQ 2L#H2L#H2L#H2L!!QNSVXKL"T%IRT>O#8>VD($L4AYL&TWE1\2Y#HWE2Q$U2]@B5 $U5]XL (2
U5]$X3@''PCH1U1X$R08&R1XVBQT0I4@%OQX=VA-HJE <O@ ;RR]@H2EGH%@^FT<"NS% T"@''PC0.D3(/S@@*K0TEG2,SI4AVQ5MEXP\ZQ@]EQQE^Q"]@B@X8
M3\-K$L.M3]^GV@''PFIE@14]GQ=TG14]M HRI4@:WQ1BP$IBP$IBMR%\KB]ATQ=_J2,+J2,+J2,+J1@@ACPMCP4MCP4MCP4MCP5[@P@a');
                colorMapFromArray:#[ 162 162 162 185 185 185 191 191 195 197 197 201 207 207 207 210 210 213 215 215 218 224 224 226 230 230 231 232 233 234 112 112 112 243 243 244 148 148 148 158 158 158 55 55 55 195 195 195 198 198 200 203 204 207 210 211 212 215 215 217 226 226 226 229 230 231 234 234 235 240 240 240 244 244 244 146 146 146 157 157 157 51 51 51 190 190 193 196 196 199 78 78 78 208 208 211 217 218 218 224 224 225 229 229 230 233 233 234 238 238 239 242 242 243 144 144 144 155 155 155 177 177 177 187 187 191 199 199 199 204 204 206 209 209 210 213 213 216 221 221 223 226 226 228 234 234 234 238 239 240 243 243 243 153 153 153 174 174 174 188 188 192 194 194 198 202 202 205 207 207 210 214 214 216 220 220 222 228 228 229 232 232 233 237 237 238 241 241 242 248 248 248 151 151 151 171 171 171 188 189 192 198 198 198 205 205 205 206 206 209 214 214 215 218 218 220 100 100 100 233 233 233 238 238 238 242 242 242 118 118 118 150 150 150 165 165 165 191 191 191 69 69 69 202 202 203 207 208 210 211 211 214 217 217 219 228 228 228 231 231 232 236 236 237 240 240 241 244 244 245 149 149 149 164 164 164 186 186 190 192 192 196 200 200 203 205 205 208 212 212 214 216 216 219 226 227 228 231 232 233 234 234 236 241 241 241 245 245 245 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C???????????????????????????????????????<b');
                            yourself);
                yourself
        ]
!

scrollLeftOffEntered2Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollLeftOffEntered2Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftOffEntered2Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollLeftOffEntered2Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@CH0F!!(ZF!!(ZF!!(ZF!!(ZLB &H3$/K2</K2</K2</IQ@@F#$.BDEAPTEAPTEAFQ $HQ(/BD,,KB07SC\,K@X5NBDZK4D,R$("KQX-
R$(+RQD!!F"=AKD("KPE@KT)JJ4$QHQ(/PR0"KP(LD25JR"-IDRDZBQ\DC#,TM$TNJR$CQ#<!!F $WACPNRD4]C"$)@4X?HQ(IE0P)M@8[O@8)JPMFO2DZBR@D
JR$4C#DNJR$C@#<!!F $>L0LC@04*CPLCG ,?HQ)CQ1UFQ$YFQ$YF@ ,''O2D\AP\OO3<?O3<?O3<?O1=BOTP!!HRD!!HRD!!HRD!!HREBN @a');
                colorMapFromArray:#[ 92 144 183 13 41 57 155 201 226 164 213 239 181 224 247 207 222 233 213 237 250 231 234 236 232 246 253 251 253 254 12 38 52 152 198 222 28 91 124 183 222 242 200 232 249 223 225 227 227 235 241 238 239 240 248 248 248 103 179 220 20 66 91 159 206 232 32 106 145 198 231 249 212 236 248 222 241 252 60 127 177 66 161 212 100 152 191 143 199 229 160 208 233 187 202 213 197 231 249 52 110 153 223 242 252 229 237 245 244 245 246 253 253 255 98 150 189 148 192 216 166 191 209 169 219 246 197 228 245 211 235 247 220 240 251 229 244 252 238 248 253 253 254 255 97 149 188 141 198 229 165 190 208 168 218 245 187 227 248 209 231 244 46 151 207 227 243 252 240 240 242 254 255 255 117 142 160 17 56 76 155 205 232 176 200 218 185 226 248 219 221 223 45 148 203 227 244 252 71 123 162 250 252 254 94 146 185 128 192 226 156 202 227 166 215 241 34 113 155 207 229 242 214 238 251 225 242 252 233 245 252 76 166 214 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C???????????????????????????????????????<b');
                            yourself);
                yourself
        ]
!

scrollLeftOffIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollLeftOffIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftOffIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'VistaToolbarIconLibrary class scrollLeftOffIcon'
	ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDB@ HB@ HB@ HB@ HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCAP E@0LC@0LC@0LC@0LEBAHH
B@LC@0LC@0LC@0LEB@4SB@ C@0LC@0LC@0LCB@(NE@ H@0LC@0LC@0LC@0$KC1THB@LC@0LC@0LC@0LHCA@VB@ C@0LC@0LC@0LCA0 QE0 H@0LC@0LC@0LC
@0LGBA HB@LC@0LC@0LC@0LC@0LGB@\C@0LC@0PDA@PDA@PDA@PDA@PDA@PEAPTEAPTEAPTEAPTEAPTEA XFA XFA XFA XFA XFA @a') ; colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b') ; yourself); yourself]
!

scrollRightActiveIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollRightActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightActiveIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollRightActiveIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@H/R$)JR$)JR$)JR$)JK0H/K$PID1LSD1LSD1L&ST@9R$QCIQDQDQDQDQDGDB-LR$(IIRP,H0\HA2L#H2HDKT)JD1D,C1%BE$IK
FQ$5C#]JR!!LQH1$YP#IIP$,YMP87R$(SDRLYFTH2AQ-BR3TNM4)JGC8L@PDXJC KOA ^@A]JR!!0>C@DAFB@''O1 3G @WR$(\O 0A@Q 6CQ 3@Q8@E4)JD#PL
@PDXN!! 3@PD^QQ]JR$IGQ!!8^OR(=G!!8^LP(WR$(ZES,@@@@@@@@@QP(TE4)NJRDCE1\WE1\WE1\WE1<FRA5JR$)JR$)JR$)JR$)A@ @a');
                colorMapFromArray:#[ 102 186 221 111 202 240 150 173 191 161 203 221 171 219 239 39 98 129 43 93 131 201 235 249 211 238 251 234 247 253 100 182 216 124 172 197 131 209 242 157 193 212 170 217 236 176 225 247 190 231 248 202 236 249 210 238 250 231 246 252 98 177 211 109 198 235 20 50 65 158 199 217 163 221 245 175 225 247 188 230 248 48 121 159 211 239 250 72 120 156 108 196 233 139 179 201 25 62 82 167 211 230 175 225 246 186 229 248 198 234 249 210 239 251 227 244 252 117 167 194 17 42 55 149 192 216 161 217 241 174 223 244 187 230 248 203 226 236 210 227 237 68 119 157 248 248 248 105 192 228 15 38 50 141 213 243 158 219 245 173 222 243 42 105 139 201 224 234 50 125 165 63 114 152 80 144 178 104 190 226 129 175 200 139 208 238 159 220 245 176 205 220 189 217 232 43 94 132 204 236 250 221 243 251 238 249 253 102 185 220 111 201 239 138 212 243 164 186 202 35 88 116 24 89 138 192 231 249 206 231 241 218 241 251 77 125 161 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C???????????????????????????????????????<b');
                            yourself);
                yourself
        ]
!

scrollRightOffEntered1Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollRightOffEntered1Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightOffEntered1Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollRightOffEntered1Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@DP5I2\''I2\''I2\''I2\''MTP[U3MMST5MST5MST5MY1T(F!!%MSU)ZV%)ZV%(XB40?CP@YSQ %IT@LPBT%IS<>B @@L0,?B )@DD@2
B (>E$,@@CM&B#8>FDMYFC<>BRMX@@AMI#9%YRUCV4D%B#AJBP@@I@!!#UUT=JSQPM#4:NRD@@A\<N24-YFE]HFQVAQD.@@@1X1MFQ"INNBHTQ P+A @@BR8_
G!!9IS4%"G!!8+@4 @@C4,QQ4]NP\9GQ4]W3]T@@@/J%8OC0<OC0<OTPH\D @ADQ= T5MST5MST5MST5IBQ09\WE1\WE1\WE1\WE1BQ@@a');
                colorMapFromArray:#[ 158 158 158 177 177 177 190 190 194 199 199 202 206 207 210 211 211 214 217 217 218 219 219 221 226 226 228 234 234 235 238 238 239 242 242 243 246 246 247 157 157 157 175 175 175 191 192 195 73 73 73 207 207 209 212 212 213 214 214 217 218 219 221 228 228 228 233 233 234 236 236 238 243 243 243 247 247 247 156 156 156 171 171 171 189 189 192 198 199 202 204 204 208 210 210 213 216 216 216 220 220 221 225 226 228 231 231 233 238 238 238 241 241 242 239 239 240 151 151 151 169 169 169 63 63 63 195 195 199 203 203 206 209 209 212 213 213 216 218 218 220 225 225 226 232 232 233 235 236 236 242 242 242 246 246 246 146 146 146 167 167 167 190 190 190 194 194 198 205 205 205 210 211 213 214 215 217 217 217 220 224 224 226 231 231 232 236 236 237 240 240 241 244 244 245 142 142 142 165 165 165 60 60 60 198 198 198 200 200 204 208 209 212 212 212 212 215 215 217 222 222 225 229 229 231 236 236 236 240 240 240 245 245 245 128 128 128 162 162 162 187 187 187 191 191 195 201 201 202 206 206 209 213 214 215 217 217 219 222 222 224 231 231 231 235 235 236 112 112 112 243 243 244 121 121 121 160 160 160 184 184 184 192 193 196 197 197 201 208 208 210 86 86 86 215 215 218 221 221 223 228 228 230 233 233 235 240 241 241 244 244 244 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C???????????????????????????????????????<b');
                            yourself);
                yourself
        ]
!

scrollRightOffEntered2Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollRightOffEntered2Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightOffEntered2Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollRightOffEntered2Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@A4HQ4]GQ4]GQ4]GQ4]GBA4HA"P[F1,[F1,[F1,[DS4RQ2PPMRH"H"H"H"H"Q$TGAD\[MR,NC!!$,FP8NC#LWF QGF2HNHRDOBP<E
HRDMJS8DQ1,"C"D!!C2TBC0T!!CR$>AD\[H 8!!HP<%G2(OAP4)O QGO3,:G!!82D1 .GCIBI"@DQ3<;N!!8^L# 7ESH(P"X AD\?N3(^G#IDECH(G$H&H@QGO0L:
G!!82M#H(G!!9BK2@DQ3<1I4IBP01CP$IBB$D AD\-NPD&I"X&I"X&K4D@H@Q@E#P<HB@ HB@ HB@ H@,#LD$DA@PDA@PDA@PDA@P#GP@a');
                colorMapFromArray:#[ 148 192 216 159 206 232 32 106 145 197 231 249 52 110 153 223 242 252 229 237 245 244 245 246 96 148 187 18 60 82 160 208 233 187 202 213 197 228 245 211 235 247 220 240 251 229 244 252 238 248 253 253 253 255 91 143 182 15 50 69 155 205 232 175 215 237 200 217 230 209 231 244 46 151 207 227 243 252 240 240 242 253 254 255 126 191 225 163 187 206 169 219 246 36 118 162 219 221 223 214 238 251 227 244 252 71 123 162 254 255 255 14 46 63 156 202 227 168 218 245 187 227 248 207 229 242 44 146 200 225 242 252 233 245 252 250 252 254 121 189 224 155 201 226 176 198 215 185 226 248 200 232 249 213 237 250 231 234 236 232 246 253 76 166 214 114 185 223 23 75 103 166 215 241 181 224 247 198 231 249 223 225 227 227 235 241 238 239 240 251 253 254 103 153 190 152 198 222 164 213 239 183 222 242 39 127 175 212 236 248 222 241 252 60 127 177 248 248 248 98 148 185 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C???????????????????????????????????????<b');
                            yourself);
                yourself
        ]
!

scrollRightOffIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollRightOffIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightOffIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'VistaToolbarIconLibrary class scrollRightOffIcon'
	ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDB@ HB@ HB@ HB@ HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0LCAP E@0LC@0LC@0LC@0LC@0 RB@TC
@0LC@0LC@0LC@0LHD04HAPLC@0LC@0LC@0LCBAPNB  G@0LC@0LC@0LC@0 UC0,IB@LC@0LC@0LC@0LHE!!@LB@\C@0LC@0LC@0LCBA\QB@\C@0LC@0LC@0LC
@0 XB@\C@0LC@0LC@0LC@0LGB@\C@0LC@0LC@0PDA@PDA@PDA@PDA@PDA@PEAPTEAPTEAPTEAPTEAPTEA XFA XFA XFA XFA XFA @a') ; colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b') ; yourself); yourself]
!

scrollUpActiveIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollUpActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpActiveIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'VistaToolbarIconLibrary class scrollUpActiveIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@C(MEAPTEAPTEAPTEAPLA @MO"H,M#X6@PDARQX=LB,@EBH!!O4!!HRDUEQT<%C3DT@AP,O0)QQ4\EAPTEAB4&E@@TM$!!QG" (SD1LSA%AS!!P@ECYHJB (JA,[
SA%APT8T@AP6RB (G1<ZI1,YPTENE@@TM$ (G1YBNS0''K4EAS!!P@ECYHG1X8A0,X@#,$ID8T@AP6RAXHJ L.P4QMGA1NE@@TM$!!GG1XVI2\''I3,$S!!P@ECX4
Q2 (JD1LSD0YM48T@AQJL3IPTE@YFQ$YH4-NE@@TMTXSGQ4]PTEAM4,NS!!P@P@$ @ATUET9NS$9NS!!@)@ADWEAPTEAPTEAPTEAP)D @a');
                colorMapFromArray:#[ 203 226 236 211 239 250 69 137 173 105 160 189 111 201 239 131 209 242 152 178 198 30 75 99 35 88 116 189 217 232 198 234 249 50 125 165 64 116 156 79 126 162 98 177 211 109 198 235 139 179 201 153 177 195 162 186 204 171 219 239 24 89 138 201 224 234 204 236 250 64 114 153 80 144 178 108 196 233 18 46 61 141 213 243 157 211 233 170 217 236 176 225 247 192 231 249 206 231 241 221 243 251 238 249 253 105 192 228 134 201 228 138 212 243 161 203 221 163 221 245 175 225 247 43 94 132 49 123 162 60 112 152 234 247 253 104 190 226 130 176 200 139 208 238 157 201 223 167 211 230 175 225 246 190 231 248 201 235 249 218 241 251 231 246 252 102 185 220 14 34 45 22 55 72 163 183 199 161 217 241 37 94 124 189 230 248 204 222 233 211 239 251 69 120 158 102 186 221 13 31 41 145 185 207 157 193 212 159 220 245 174 223 244 186 229 248 202 236 249 211 238 250 227 244 252 100 182 216 111 202 240 143 184 206 158 199 217 158 219 245 173 222 243 187 230 248 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b');
                            yourself);
                yourself
        ]
!

scrollUpOffEntered1Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollUpOffEntered1Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpOffEntered1Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollUpOffEntered1Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@B@SB (JB (KB ,KB0,RH0@SLTIBP$EAN#$8MSL.IAP@BTIBPS8=OCD.KR,%F2XN@@%APS<<N3$-J"$&G1($C @IPS<=N3$6J"\%H!!8YI@8@BTD?OS,9M"<1
KBH^FRPN@@%AO349N3PBLB$^G!!$$C @IPS<=OC4@@0X.I"XYI@8@BTD?OS<AA@ OCB0,FRPN@@%AO34EA1TXG"H]JQ$$C @IPS<=O#<=MCD0K"0YI@8@BTD?
OS,9M"(''IRH^FRPN@@%AO309NCP)I"P!!GA $C @IO309MSP2I"P!!G!!,WI@8@DSD=N3$9NB4+J"$(I!!<P@A8QC@4MCP4MCP4MCP4PE @a');
                colorMapFromArray:#[ 52 52 50 56 56 60 68 70 70 80 78 80 100 100 100 112 112 110 120 118 120 144 144 140 148 146 150 152 152 150 152 154 150 156 154 150 156 158 160 160 158 160 160 160 160 164 162 160 164 166 170 168 168 170 172 170 170 172 172 170 172 174 170 176 178 180 188 188 190 188 190 190 192 192 190 192 192 200 192 194 200 196 196 200 196 198 200 200 198 200 200 200 200 200 202 200 204 204 200 204 204 210 204 206 210 208 206 210 208 208 210 208 210 210 212 212 210 212 214 220 216 214 220 216 216 220 216 218 220 220 218 220 220 220 220 220 222 220 224 224 230 224 226 230 228 226 230 228 228 230 228 230 230 232 230 230 232 232 230 232 234 230 232 234 240 236 234 230 236 234 240 236 236 240 236 238 240 240 238 240 240 240 240 240 242 240 244 242 240 244 244 240 244 244 250 244 246 250 248 246 250 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b');
                            yourself);
                yourself
        ]
!

scrollUpOffEntered2Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self scrollUpOffEntered2Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpOffEntered2Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class scrollUpOffEntered2Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@BPRBP$IBP$IBP$IBP$OHP@RN41KR4-KRT%IRT%HM@4@BT1EP#<?O28.K"4(HDDI@@%KP#48NC &I"X&H!!,:BP@IR3<8M#X6H2L#H18ZM0$@BT,?NCX6M"(/
J"L^F#\I@@%KO3 6OB<BK2(^F!!(7BP@IR3<8OD@@@0X/I1(ZM0$@BT,?ND@AA@ LB"0%F#\I@@%KO3 EA1DSEQ$TJ1(7BP@IR3<8ODA@K2</K20ZM0$@BT,?
NCX6M"L#H2L^FC\I@@%KNST2L#H^G!!8^GA\7BP@IR#L1LC@0F!!(ZFA\VM0$@DC9GQ$QDQC\7M3\7M2$K@A<NBP$IBP$IBP$IBP$KGP@a');
                colorMapFromArray:#[ 12 38 52 13 41 57 17 56 76 20 66 91 28 91 124 32 106 145 34 113 155 45 148 203 46 151 207 60 127 177 66 161 212 71 123 162 76 166 214 89 143 184 92 144 183 93 147 188 97 149 188 103 179 220 105 154 191 128 192 226 141 198 229 143 199 229 148 192 216 152 198 222 155 201 226 155 205 232 156 202 227 159 206 232 160 208 233 162 186 204 164 213 239 166 191 209 166 215 241 167 194 214 168 218 245 169 219 246 174 195 211 177 213 233 181 224 247 183 222 242 185 226 248 187 202 213 187 227 248 192 221 237 197 228 245 197 231 249 198 231 249 200 232 249 207 229 242 209 231 244 211 235 247 212 236 248 213 226 235 213 237 250 214 238 251 219 221 223 220 240 251 222 241 252 223 225 227 223 234 242 223 242 252 226 242 252 227 235 241 227 244 252 229 244 252 231 234 236 233 246 253 234 234 234 238 239 240 238 248 253 240 240 242 244 245 246 250 252 254 251 253 254 253 253 255 253 254 255 254 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??_?<b');
                            yourself);
                yourself
        ]
!

scrollUpOffIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollUpOffIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpOffIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'VistaToolbarIconLibrary class scrollUpOffIcon'
	ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LCA0 G
@0LCA@TF@@DB@0LCAP IB@\C@0PEA @A@ LCAP JB00HA0LDAPX@@PHCAP MC <PDP GA@TF@@DB@0 RD1PUE!!\XB@PEA @A@ LEB@ HB@ HB@\DAPX@@PHC
@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @a') ; colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; yourself]
! !

!MacOSXToolbarIconLibrary class methodsFor:'image specs-09x09'!

closeIndicatorInTree9x9Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self closeIndicatorInTree9x9Icon inspect
     ImageEditor openOnClass:self andSelector:#closeIndicatorInTree9x9Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary closeIndicatorInTree9x9Icon'
        ifAbsentPut:[(Depth4Image new) width:9; height:9; bits:(ByteArray fromPackedString:'EHDQDQDSL DQDAL3-QDPD3L3ZQ@SL3L7*AL3L6$PD3N5DQ@SL DQDARADQDP') ; colorMapFromArray:#[225 231 241 235 241 252 178 180 183 152 152 152 162 163 164 198 201 207 166 167 169 150 150 150 212 216 224 217 221 230 211 215 223 154 154 154]; mask:((ImageMask new) width:9; height:9; bits:(ByteArray fromPackedString:'XG=8_71?_7=??7=?_G=8_6A?') ; yourself); yourself]
!

fileTypeApplicationSharedLibraryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeApplicationSharedLibraryIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeApplicationSharedLibraryIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeApplicationSharedLibraryIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CP4MCP4MCP@@@@@@@@@@@@@@CPDA@PDPQ\4@@@@@@@@@@@@@CP@GQ4]J@8HM@@@@@@@
@@@@@CPZK"8.GT@HBCP@@@@@@@@@@CP$JR$)@RL&B@ 4@@@@@@@@@CP A0\GP4@"OA<4@@@@@@@@@CP2P4IBQDLGFB84@@@@@@@@@CPQKTUFQ$YCASH4@@@@
@@@@@CQCQDYF@D]BA104@@@@@@@@@CP&R@]IBDUHP2X4@@@@@@@@@CP[P$UEA4 HP1,4@@@@@@@@@CP[P4MCBBYCI!!,4@@@@@@@@@CPHB@ HP0 HB@ 4@@@@
@@@@@CP4MCP4MCP4MCP4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[246 246 246 233 233 233 252 252 251 216 212 172 245 245 245 243 243 243 239 239 239 237 237 237 255 255 255 159 154 124 181 177 143 100 103 106 223 223 223 241 241 241 197 197 197 201 197 160 166 160 114 251 251 251 145 141 101 197 191 137 159 155 126 157 153 122 139 135 100 204 204 204 222 222 222 218 213 173 247 247 247 254 254 254 252 252 252 228 228 228 153 149 116 169 169 169 249 249 249 215 210 169 161 161 161 188 188 188 248 248 248 148 144 118 253 253 253 218 212 172 227 227 227 234 234 234 120 116 84 222 228 234 0 0 0 244 244 244 231 231 231 138 134 101 155 151 119 208 202 155 250 250 250 145 140 99 149 153 157 214 208 165 146 142 103 198 193 140 166 162 117 162 158 115 191 184 139 199 193 138 162 162 162 219 213 174 151 147 112 138 134 99 192 192 192 242 242 241 165 165 165 85 85 85 225 225 225 149 149 149 255 211 171 255 255 223 129 129 129 255 237 211]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?C>@?C?@?C? ?C?0?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?@@@?@@@?') ; yourself); yourself]
!

openIndicatorInTree9x9Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self openIndicatorInTree9x9Icon inspect
     ImageEditor openOnClass:self andSelector:#openIndicatorInTree9x9Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary openIndicatorInTree9x9Icon'
        ifAbsentPut:[(Depth4Image new) width:9; height:9; bits:(ByteArray fromPackedString:'@@@@@@GCL3L34AL3L3O0B3L3N@@F03MYB@@CL0@@@@(7@@@@C#H@@@@@P@@@') ; colorMapFromArray:#[194 197 203 207 211 219 219 224 233 152 152 152 211 215 223 156 157 157 224 229 239 169 170 172 182 184 188 228 234 244 163 164 165 174 176 179 153 153 153 165 166 167 212 217 225 215 219 228]; mask:((ImageMask new) width:9; height:9; bits:(ByteArray fromPackedString:'@G??????_7=?_39?GG<\_0!!?') ; yourself); yourself]
! !

!MacOSXToolbarIconLibrary class methodsFor:'image specs-tools-FileBrowser'!

desktopIcon
    <resource: #programImage>

    ^ self desktopOSX24x24Icon
! !

!MacOSXToolbarIconLibrary class methodsFor:'image specs-tools-FileBrowser-Filetypes'!

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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeAddOnLinked'
        ifAbsentPut:[(Depth4Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@BH!! @@@@@@@@AP@P@@@@@@@@B"A@@@@@@@@@(CI@@@@@@@@@B$Q@@@@@@@@@%4@@@@@@@@@@Q@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 204 204 204 45 45 45 169 169 169 214 214 214 66 66 66 224 224 224 184 184 184 241 241 241 138 138 138 154 154 154]; mask:((Depth1Image new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@^@@@^@@@^@@@>@@@>@@@8@@@0@@@') ; yourself); yourself]
!

fileTypeApplicationBinaryIcon
    ^ self fileTypeBinaryFileIcon
!

fileTypeApplicationJavaArchiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeApplicationJavaArchiveIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeApplicationJavaArchiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeApplicationJavaArchiveIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APV:]%1L_7=8US @@@@@APTEM(*;ZUB4&*JW*Y0@@@T@@FIX"()F*599XDQN''@@E@@A")VU%Y(); ZA0Y:L@AP@@([E0&FY<]6*9R''%CNPT@@JE>''8]EO4>I
#694OK0E@@A"#%^$-9&K\T5,Q9BRAP@@(QEQ#U=Z^+J@&5&BT T@@F6QR%F3#H 5$4"5)5HE@@A--[Q(*GL5N&.5Q6=RAP@@+(:5''U](WU\!!T1D7%@T@@F5T
UC,JYD]2TE.,_UHE@@A-%Z,>Q;!!@N%]B+D-RAPT@+*AFTXNE+1>Q!!J1KT TE@F6,*&MF&@J+]Z2,,EHEAPV^+XYVU)ZV%)Y!!XS5IAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?>C?<O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
!

fileTypeApplicationPdfIcon
    ^ self fileTypeTextIcon
!

fileTypeApplicationPostscriptIcon
    ^ self fileTypeTextIcon
!

fileTypeApplicationRtfIcon
    ^ self fileTypeTextIcon
!

fileTypeArchiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeArchiveIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeArchiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeArchiveIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@V5-[V5-IS$X@@@@@@@@@@@@@V0PDA@QTSRAH@@@@@@@@@@@@V0@]GQ5YR%0HS0@@@@@@@@@@V1(.K"9XT5(HBE\@@@@@
@@@@V2P)JR%YP5T&B@!!V@@@@@@@@V2@GA0]LST\"OEIP@@@@@@@@V3HMCP5YS@DLFDQ[@@@@@@@@V1D-KR5IRPTEARA[@@@@@@@@V10@@@AEQP@@@A1[@@@@
@@@@V2X HBAKR2@ HBY[@@@@@@@@V1,\GA1QTQ0\GA-[@@@@@@@@V1,&I"X&I"X&I!!-[@@@@@@@@V0 HB@ HB@ HB@!![@@@@@@@@V0 HB@ HB@ HB@!![@@@@
@@@@V0 HB@ HB@ HB@!![@@@@@@@@V5-[V5-[V5-[V5-[@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[246 246 246 233 233 233 252 252 251 216 212 172 245 245 245 243 243 243 239 239 239 237 237 237 255 255 255 159 154 124 181 177 143 100 103 106 223 223 223 241 241 241 197 197 197 201 197 160 166 160 114 251 251 251 145 141 101 197 191 137 159 155 126 157 153 122 139 135 100 204 204 204 222 222 222 218 213 173 247 247 247 254 254 254 252 252 252 228 228 228 153 149 116 169 169 169 249 249 249 215 210 169 161 161 161 188 188 188 248 248 248 148 144 118 253 253 253 218 212 172 227 227 227 234 234 234 120 116 84 222 228 234 0 0 0 244 244 244 231 231 231 138 134 101 155 151 119 208 202 155 250 250 250 145 140 99 149 153 157 214 208 165 146 142 103 198 193 140 166 162 117 162 158 115 191 184 139 199 193 138 162 162 162 219 213 174 151 147 112 138 134 99 192 192 192 242 242 241 211 206 161 134 134 134 235 235 235 174 174 174 128 128 128 209 209 209 176 176 176 89 89 89 136 136 136 224 224 224 131 131 131 178 178 178 91 91 91 185 185 185 138 138 138 205 205 205 199 199 199 179 179 179 139 139 139 206 206 206 146 146 146 193 193 193 133 133 133 180 180 180 207 207 207 127 127 127 221 221 221]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?G>@?G?@?G? ?G?0?G?8?G?8?G?8?G?8?G?8?G?8?G?8?G?8?G?8?G?8?G?8?G?8?@@@?') ; yourself); yourself]
!

fileTypeAudioIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeAudioIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeAudioIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeAudioIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@]P\X_22J[V8PY @@@@@@@@@R]'',#SDX@E8Q*B@@@@@@@@@A!!DSHJQ4IST604V0@@@@@@@@A!!XHT_N#VGI(M4WP@@
@@@@@@A!!N0H/I6>@AS@N_P@@@@@@@@A!!_HJKNDA3@@A!!VP@@@@@@@@A!!S @@@@@@@@A!!J0@@@@@@@@A!!\ @@@@@@@@A!!O@@@@@@@@@A!!A@@@@@@@@@A!!R @@
@@@@@@A!!I@@@@@@@@@M!!P0@@@@@@@@A!!\@@@@@@KS2@FX @@@@BASQ%!!@P@@@A1IYX58GP@@@F](LV$9U @@F$U+O8Y#T@@@@H1HU34.D0@@KTQZ"ED!!M0@@
@@%:EUQ_J@@@@AQ1_%!!^@@@@@G^I^SLL@@@@@D,VJ#X%@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[56 166 247 15 62 120 27 144 230 220 226 232 13 60 118 75 127 183 50 126 185 194 211 228 42 108 173 48 97 145 115 201 253 166 184 203 119 129 142 215 222 230 61 135 193 214 221 228 41 132 208 40 159 245 115 160 200 13 50 108 129 144 157 55 140 205 151 155 164 75 177 251 166 188 211 103 145 189 189 208 226 218 224 231 115 160 197 14 54 108 215 221 227 111 205 253 97 142 182 15 64 133 179 184 189 26 137 224 13 59 117 188 193 198 57 167 250 18 116 196 117 132 153 204 210 215 157 162 172 18 63 117 123 167 207 189 204 218 44 138 213 23 130 215 107 143 184 43 169 252 99 197 253 70 91 123 125 205 253 84 185 252 174 178 184 130 145 164 164 184 209 49 155 222 98 195 253 22 136 226 17 62 115 115 207 253 196 202 207 121 215 253 181 197 215 222 228 234 131 209 253 16 61 116 16 89 153 20 126 215 42 160 247 119 203 253 53 178 252 24 145 237 18 61 115 158 162 167 31 143 233 104 152 198 16 72 133 106 151 193 21 55 109 46 123 201 178 184 190 146 215 253 43 119 196 214 222 230 12 56 111 115 210 253 80 104 140 17 63 120 44 144 212 33 103 171 216 223 230 28 91 151 144 152 167 13 61 134 29 151 237 68 133 189 16 60 115 39 131 203 216 223 229 40 163 252 46 125 197 122 163 199 27 143 232 57 170 247 156 215 253 60 191 252 144 216 253 78 148 209 55 137 210 29 107 184 12 60 121 39 73 116 13 62 120 201 210 222 29 155 235 196 212 227 25 121 203 137 148 158 42 142 205 41 69 109 35 122 188 26 130 214 16 91 163 23 67 121 39 72 119 150 180 207 56 116 184 166 185 203 103 134 173 35 156 241 96 188 252 94 198 253 108 203 253 71 176 252 68 153 219 49 77 109 104 159 207 156 173 198 37 121 192 50 160 238]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@?<?A?<?A?<?A?<?A?<?A?L?A L?A L?A L?A \?A!!<?O#<?_''<?_''<?_#8?_C8?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeBinaryFileIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@AY $)JE75PT6%J!!@@@@@@@@@AR!!X.KFF@WU592YT4@@@@@@@BC"14(JHVIW'',\\%!!-@@@@@@BC\$92\!!6EXFP\GGJG\P@@
@@BCU DAU"9NCF)$P&!!HTP@@@@BCX6L Q60 Q6I4T7]GR0@@@@BCA''UGHD\ Q2@ SD)7V @@@@BCCW1GHD\ Q8XMKUQ+RP@@@@BCAPT RB@ Q2@ HB9.W@@@
@@BC_@P$HB@ HB@ H@YVW@@@@@BCAP@ Q2@ Q2@ Q70FW@@@@@BCHBP Q0]G]T\MQ25<W@@@@@BCHAD Q2AGHD\ Q0@-W@@@@@BCDRX$Q04MQ2@GQ2BJW@@@
@@A>I!!0\GA0QDSH2HB@$UP@@@@A8QE-OS4=OS4=OS5-D P@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[246 246 246 233 233 233 252 252 251 216 212 172 245 245 245 243 243 243 239 239 239 237 237 237 255 255 255 159 154 124 181 177 143 100 103 106 223 223 223 241 241 241 197 197 197 201 197 160 166 160 114 251 251 251 145 141 101 197 191 137 159 155 126 157 153 122 139 135 100 204 204 204 222 222 222 218 213 173 247 247 247 254 254 254 252 252 252 228 228 228 153 149 116 169 169 169 249 249 249 215 210 169 161 161 161 188 188 188 248 248 248 148 144 118 253 253 253 218 212 172 227 227 227 234 234 234 120 116 84 222 228 234 0 0 0 244 244 244 231 231 231 138 134 101 155 151 119 208 202 155 250 250 250 145 140 99 149 153 157 214 208 165 146 142 103 198 193 140 166 162 117 162 158 115 191 184 139 199 193 138 162 162 162 219 213 174 151 147 112 138 134 99 192 192 192 242 242 241 144 144 144 175 175 175 59 60 63 155 155 155 237 243 254 166 166 166 177 177 177 169 173 181 208 208 208 179 183 192 219 219 219 209 214 224 230 230 230 34 35 36 179 179 179 200 205 215 181 185 194 190 190 190 221 221 221 162 166 174 232 232 232 181 181 181 179 181 183 202 207 217 173 178 186 27 28 29 164 168 176 172 172 172 203 203 203 183 183 183 214 214 214 163 163 163 225 225 225 236 236 236 154 154 154 183 185 187 185 185 185 216 216 216 165 165 165 196 196 196 176 176 176 207 207 207 238 238 238 208 213 223 218 218 218 167 167 167 198 198 198 218 223 234 229 229 229 178 178 178 209 209 209 240 240 240 158 158 158 189 189 189 180 184 193 200 200 200 149 149 149 180 180 180 242 242 242 191 191 191 182 186 195 140 140 140 171 171 171 174 179 187 213 213 213 184 188 197 214 220 230 224 224 224 235 235 235 181 183 186 184 184 184 215 215 215 246 245 245 226 226 226]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?O? ?O?0?O?8?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeCPlusPlusSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APW"7=?_:=/[8.@@@@@@APTE6JV%"*-P&$_^6 @@@@T@@NM0\JVX.<?EP.'',@@@E@@C#1;Q@]TCQQ:1B9N4@AP@@9+=0_#,;VGV//Z++NPT@@NY[N=M[#'':%
*<3N!!+0E@@C&1MQ00-I[V<^JZ]6RAP@@\<&%.>W%9:.+PI#.T T@@GND3NW'')TA&1*T;0EHE@@A3UHS%959F9\3%4#MRAP@@\9UX9^^D9^W%9^\3%@T@@GM 
4.W''UES%!!NWI\5HE@@A3(DKO9^W''%URD!!GMRAPT@\<N (K=P_&Z%.5Q3T TE@MZ,0<OC(JB (FA \5HEAPWP2,+J2,+J2,+JM]AIAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232 175 175 175 155 155 155 239 239 239 148 148 148 210 210 210 243 243 243 254 254 254 245 245 245 194 194 194 225 225 225 236 236 236 55 146 70 247 247 247 145 145 145 176 176 176 218 218 218 0 91 12 209 209 209 220 220 220 169 169 169 200 200 200 242 242 242 222 222 222 244 244 244 142 142 142 153 153 153 246 246 246 140 142 146 133 137 143 192 197 206 145 148 153 146 148 152 137 139 143 171 172 173 147 150 155 234 240 251 139 141 145 158 161 168 141 143 147 187 188 188 15 15 116 143 145 149 93 93 178 145 147 151 191 192 192 134 138 144 146 149 154 195 200 209 224 230 241 146 146 146]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?<C?8O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeCSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APW"7=?_:=/[8.@@@@@@APTE6JV%"*-P&$_^6 @@@@T@@NM0\JVX.<?EP.'',@@@E@@C#1;Q@]TCQQ:1B9N4@AP@@9+=0_#,;VGV//Z++NPT@@NY[N=M[#'':%
*<3N!!+0E@@C&1MQ00-I[V<^JZ]6RAP@@:L&%.>W%9^^+PI#!!T T@@N"D3NW'')TC%9:T;85HE@@C(UHS%959F]\154.YRAP@@:IUX9^^D!!HSI4-_&%@T@@N!! 
4.W''UES%98SI:EHE@@C((DKO9^W%95RD!!N!!RAPT@:LN (K=P_&Z%.5S(T TE@M2,0<OC(JB (FA :EHEAPW":.+*:.+*:.+*6^IIAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232 175 175 175 155 155 155 239 239 239 148 148 148 210 210 210 243 243 243 254 254 254 245 245 245 194 194 194 225 225 225 236 236 236 55 146 70 247 247 247 145 145 145 176 176 176 218 218 218 0 91 12 209 209 209 220 220 220 169 169 169 200 200 200 242 242 242 222 222 222 244 244 244 142 142 142 153 153 153 246 246 246 140 142 146 133 137 143 192 197 206 145 148 153 146 148 152 137 139 143 171 172 173 147 150 155 234 240 251 139 141 145 158 161 168 141 143 147 187 188 188 15 15 116 143 145 149 93 93 178 145 147 151 191 192 192 134 138 144 146 149 154 195 200 209 224 230 241]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?<C?8O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
!

fileTypeCompressedArchiveIcon
    ^ self fileTypeArchiveIcon
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeDirectoryGrayIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HP.E1\WE2:D!!HRD!!HRD!!HRD!!HPW$9L5$1^D!!HRD!!HRD!!HRD!!C /L@8NC''5=B0,$IC0<B8>D
!!E@QW5=)L1 &T UEH7DS P6D!!EA^S$:LS!!)AV!!X"QGIO"U.D!!B5$DCD1 BI''J02E_EE%%@RD!!GMM\@]''J3P[U0MI!!5L9[D"D!!GVRIS4=@4%\NW=8&"E/A"&D
!!D,(R)*Z&&>QQ(*U%V-+"9&D!!F8\#X6W%1PTHG9>$B@ M#JD!!D\Y^#,;UP HJ (*J D,SD^D!!F)(&F6HC1<UC0>VM8X]VC>D!!G-T^P$IBS(:BP%]WPA]]6JD
!!@IYX6M#X6M#X6M#X6MYVPJD!!FBC]DMVD#8^P"]@XXI&#''ZD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD') ; colorMapFromArray:#[97 128 147 106 137 156 102 135 156 128 150 165 112 143 163 150 166 177 121 147 165 134 153 167 107 137 156 96 128 147 104 136 156 111 144 166 130 153 165 112 144 163 154 183 200 99 134 153 135 156 168 156 171 182 191 196 201 141 161 174 114 141 159 100 132 153 138 156 168 119 151 171 156 169 181 105 139 160 143 159 171 130 152 166 114 143 162 102 133 153 188 193 198 99 132 153 112 141 158 121 145 162 135 155 167 145 164 175 112 144 166 129 150 164 153 168 178 187 192 197 118 147 168 108 142 162 106 136 156 132 153 167 106 136 154 114 144 163 161 179 191 109 143 165 153 182 200 137 156 168 106 140 161 157 171 181 132 153 166 164 197 218 111 141 162 101 134 154 133 160 177 124 148 163 96 126 147 108 138 156 113 144 166 129 150 165 189 194 200 100 137 159 188 194 199 140 157 168 186 191 196 195 201 206 134 153 166 145 165 176 118 144 160 102 138 159 111 142 163 127 150 164 123 146 162 108 141 161 105 138 159 132 156 170 144 160 171 130 150 164 114 146 165 128 150 164 153 168 177 125 148 163 94 129 153 108 137 156 193 198 203 131 151 165 99 136 160 87 124 149 141 157 168 111 144 163 126 150 163 98 128 147 145 162 174 156 171 181 199 207 214 190 195 200 101 137 158 87 125 149 135 155 171 127 150 163 195 200 205 133 153 167 99 134 160 156 171 180 101 137 159 117 144 159 123 150 168 99 133 153 107 140 161 121 146 162 133 153 166 143 162 174 132 153 165 112 143 164 198 203 209 110 142 163 196 203 209 96 131 153 123 147 162 98 128 146 107 138 156 102 137 158 129 151 165 111 144 165 112 141 159 123 147 163 136 156 168 142 162 177 192 197 202 201 206 211 162 194 216 129 152 165 100 134 154 126 150 164 98 133 153 131 152 168 119 144 161 114 145 165 144 160 170 115 142 159 197 202 208 132 159 177 111 141 158 120 145 162 129 153 170 165 197 218 126 150 168 117 144 160 102 134 154 114 142 159 100 133 153 109 140 160 122 146 162]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?O0@?O0@?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeDirectoryIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AT5MST0D@@@@@@@@@@@@@@@ASU5]"U5L@@@@@@@@@@@@@@DF@I LC@5EQQ4]OS6%)Q14@
@F-@&)(/GID!!''781E7J LE0@@F-TC 8"C$:[R)H=XT%RU($@@BM.^$L)A#4YO8)/$01U]''T@@H<QMR@YVV4SX1TE^S1;JI$@@@JENU5]EPUE^5\6V @-#Y0@
@A:FC5(HV"48"6TM%X2L  P@@DI8J")XVG1<IEAP"BP$Q#,@@GR]XIRT]1XVG7L_G8P2Y7P@@I!!MI4-_Y ,[Y(NGIR8I%60@@A)LDC8RO#NVO!!HXFDPX\I@@
@B,,M3\7M3\7M3\7M3\,KB,@@F*NRC)1A75[ VQ?MF!!^B!!P@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[162 194 216 161 179 191 110 142 163 154 183 200 109 140 160 170 200 219 182 208 224 191 196 201 163 195 217 136 178 205 197 202 208 132 176 205 171 200 219 157 192 214 193 214 229 164 195 217 131 171 195 176 208 227 128 171 196 174 203 222 196 203 209 171 200 220 143 183 209 194 219 234 131 171 196 178 205 223 102 137 158 134 176 205 210 229 242 132 159 177 108 141 161 142 182 208 179 205 223 204 225 238 193 214 227 114 144 163 150 188 211 135 179 206 153 182 200 134 178 204 165 200 224 183 209 224 154 190 212 102 135 156 87 124 149 162 195 216 134 179 206 209 228 240 190 216 236 194 221 235 142 182 206 128 169 196 190 195 200 178 205 222 164 197 217 87 125 149 160 194 216 172 200 219 195 201 206 106 140 161 167 198 218 180 207 223 129 171 196 176 205 223 209 229 243 133 160 177 107 140 161 183 208 224 130 171 196 168 200 218 148 189 216 111 144 166 198 203 209 176 204 221 188 210 224 133 178 205 126 173 205 132 179 214 191 212 228 112 144 166 150 188 212 111 144 165 174 201 219 119 151 171 194 216 232 170 200 218 175 203 225 165 197 218 153 190 212 177 205 223 163 195 216 188 193 198 112 144 163 172 201 220 195 200 205 131 178 205 143 184 208 179 205 222 164 197 218 175 202 221 187 192 197 159 193 215 133 179 205 140 185 213 192 197 202 113 144 166 199 207 214 114 146 165 100 137 159 176 205 222 181 207 228 173 203 221 128 175 205 193 198 203 191 217 233 139 182 208 102 138 159 112 143 163 168 200 224 144 183 209 153 191 217 169 200 219 181 208 224 166 198 218 152 189 212 189 194 200 200 222 237 188 194 199 109 143 165 186 191 196 153 194 221 132 179 205 142 183 208 173 204 227 158 197 224 136 179 206 149 188 211 111 144 163 174 204 220 158 193 214 156 192 213 162 197 221 201 206 211 112 143 164 101 137 158 208 226 242 185 208 225 173 202 220 144 184 209 156 192 214 129 169 196 133 182 214 101 137 159 111 142 163 209 228 242 187 210 224 108 142 162 140 186 214 222 228 234 204 224 237 189 215 232]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?O0@?O0@?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeDirectoryOpenGrayIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@IT@"!!7@4@@@@@@@@@@@@@@@@FD)]!!HH5^19ZAYJH@@@@@@@@G@]JW(I>@@$?YPQ1@@@@
@C8;F#L,UF]XEDY9TB<P#Q4@@C&Y-\ZX&LF 5MF$4*^;6CD@@FB$4\&"*::/.LR31[RV%)P@@IR<)=J9):&^1[RV%)*_2@(@@B/@*)^W-K:VS9>C053J288@
@@I\ 0!!"BE1\(:3L3KZ7,G<@@E%N)ZV1,ZZ&]7]7I''\- U$@@G*U/YV=/[6=/[6=/[6=%UD@@H*U/YV=/[6=/[6=/[6=%WH@@H*U/YV=/[6=/[6=/[6=%WH@
@AX:L#H2L#H2L#H2L#H:N!!X@@@=K"QDUX5VQJS@=P08RZ(,@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[194 217 233 129 175 203 116 148 167 112 164 196 176 205 224 155 180 198 136 180 206 185 211 228 159 194 215 192 215 232 118 150 168 139 181 207 111 164 196 123 171 200 192 192 192 210 212 214 116 152 175 199 199 199 197 197 197 127 174 202 122 156 178 193 193 193 112 144 163 122 171 200 175 198 214 144 184 209 125 159 181 128 174 202 169 193 209 148 172 187 154 179 197 133 177 205 120 169 199 132 177 204 173 197 212 140 181 207 111 164 197 220 230 236 150 188 211 135 178 205 148 187 210 180 180 180 115 166 198 118 149 167 124 159 180 150 188 212 122 170 200 118 152 175 181 181 181 121 151 169 95 132 154 125 160 181 210 220 227 157 182 200 124 171 200 255 255 255 121 170 200 123 152 169 95 131 154 125 161 183 127 173 202 185 185 185 149 173 187 186 212 229 177 200 215 119 168 199 130 174 203 188 188 188 141 181 206 128 174 201 121 155 178 149 186 210 135 179 206 146 185 210 195 218 234 209 209 209 140 181 208 114 164 195 151 188 211 161 194 216 119 153 175 109 144 165 145 184 209 117 167 198 124 158 180 186 186 186 152 189 212 125 172 200 121 157 178 111 145 165 154 180 197 119 168 198 157 193 214 203 224 239 203 224 237 138 181 206 122 151 170 133 176 204 159 193 215 190 190 190 143 183 208 180 210 227 125 172 202 123 158 179 111 165 196 134 177 205 202 202 202 132 176 204 129 174 203 141 182 208 154 191 213 126 173 201 167 191 207 154 180 198 110 144 164 144 183 209 116 166 198 115 166 197 237 243 254 151 188 212 124 172 201 120 154 176 110 144 165 154 181 198 118 168 199 116 166 197 202 221 237 115 148 167 137 180 206 149 187 210 210 229 242 160 194 215 209 228 240 143 184 209 141 182 207 170 194 210 159 185 201 204 204 204 111 144 164 201 204 205 133 176 203 115 152 175 118 148 166 112 164 197 125 172 201 183 183 183 156 183 199 134 178 205 120 150 169 148 187 211 163 196 217 165 198 218 183 209 225 183 208 225 160 195 216 161 194 216 159 194 215 150 188 212 168 199 219 160 194 216 179 207 223 159 193 215 177 205 222 156 192 214 175 204 221 153 190 213 151 189 212 171 201 220 150 188 211 169 200 219 165 197 217 176 205 222 155 192 214 175 204 221 175 203 221 173 202 221 153 190 212 152 190 213 149 187 210 167 199 218 164 197 217 184 209 225 155 191 214 154 190 213 172 201 220 171 202 220 151 188 212 169 199 219 169 199 218 147 187 211 164 196 217 147 187 211 163 196 216 181 208 224 160 194 215 158 193 214 169 200 220 166 199 218 184 209 226 163 196 217 160 194 214 177 205 223 157 193 215 157 192 214 154 191 214 151 188 211 147 187 211 166 199 218 157 193 214 176 205 223 172 202 220 163 196 217 178 205 223 157 193 214 172 202 220 157 193 214 169 199 220]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?G8@?G?8?G?8?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeDirectoryOpenIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@IT@"!!7@4@@@@@@@@@@@@@@@@FD)]!!HH5^19ZAYJH@@@@@@@@G@]JW(I>@@$?YPQ1@@@@
@C8;F#L,UF]XEDY9TB<P#Q4@@C%" 4<HBE1.U"4(T&P#SCD@@FBAKW]NI$]I\65_A)L_XYP@@IQDYA&EYHXK IL!!Z0E,QP(@@B.LI4!!H$6%+P&0[[9A&M(8@
@@IWF1L<D9A8CQ\8NB8 V7<@@E%=PTE<_EMS]GQ4]WP*SU$@@G(CCH<LI@0$Z@0$C@0L@5D@@H(CCH<LI@0$Z@0$C@0L@7H@@H(CCH<LI@0$Z@0$C@0L@7H@
@AX:L#H2L#H2L#H2L#H:N!!X@@@=K"QDUX5VQJS@=P08RZ(,@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[194 217 233 129 175 203 116 148 167 112 164 196 176 205 224 155 180 198 136 180 206 185 211 228 159 194 215 192 215 232 118 150 168 139 181 207 111 164 196 123 171 200 192 192 192 210 212 214 116 152 175 199 199 199 197 197 197 127 174 202 122 156 178 193 193 193 112 144 163 122 171 200 175 198 214 144 184 209 125 159 181 128 174 202 169 193 209 148 172 187 154 179 197 133 177 205 120 169 199 132 177 204 173 197 212 140 181 207 111 164 197 220 230 236 150 188 211 135 178 205 148 187 210 180 180 180 115 166 198 118 149 167 124 159 180 150 188 212 122 170 200 118 152 175 181 181 181 121 151 169 95 132 154 125 160 181 210 220 227 157 182 200 124 171 200 255 255 255 121 170 200 123 152 169 95 131 154 125 161 183 127 173 202 185 185 185 149 173 187 186 212 229 177 200 215 119 168 199 130 174 203 188 188 188 141 181 206 128 174 201 121 155 178 149 186 210 135 179 206 146 185 210 195 218 234 209 209 209 140 181 208 114 164 195 151 188 211 161 194 216 119 153 175 109 144 165 145 184 209 117 167 198 124 158 180 186 186 186 152 189 212 125 172 200 121 157 178 111 145 165 154 180 197 119 168 198 157 193 214 203 224 239 203 224 237 138 181 206 122 151 170 133 176 204 159 193 215 190 190 190 143 183 208 180 210 227 125 172 202 123 158 179 111 165 196 134 177 205 202 202 202 132 176 204 129 174 203 141 182 208 154 191 213 126 173 201 167 191 207 154 180 198 110 144 164 144 183 209 116 166 198 115 166 197 237 243 254 151 188 212 124 172 201 120 154 176 110 144 165 154 181 198 118 168 199 116 166 197 202 221 237 115 148 167 137 180 206 149 187 210 210 229 242 160 194 215 209 228 240 143 184 209 141 182 207 170 194 210 159 185 201 204 204 204 111 144 164 201 204 205 133 176 203 115 152 175 118 148 166 112 164 197 125 172 201 183 183 183 156 183 199 134 178 205 120 150 169]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?G8@?G?8?G?8?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?@@@?') ; yourself); yourself]
!

fileTypeDocumentsIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDocumentsIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDocumentsIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeDocumentsIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4MCP4MCP4@@@@@@@@@@@@@@@4OS4=OPLJM@@@@@@@@@@4MCPKECL3N1LPBCP@@@@@@@@4A@PDADDWD#\8B@ 4@@@@
@@@4@A4]GR NBCX9@  HM@@@@@@4F"8.K!!5@B@ *O1X%M@@@@@@4IB$)JPD#I  HK3(OM@@@@@@4H@\GA2%@H#0_O#DYM@@@@@@4L 4MCPX]CA .G$H=M@@@
@@@4DR4-KR4EAPT2LCT=M@@@@@@4G@@@@@@@@@@\ERD=M@@@@@@4I"@ HB@ HB@&BR\=M@@@@@@4F10\GA0\GA0[EC4=M@@@@@@4F2X&I"X&I"X[B3P4M@@@
@@@4B@ HB@ HB@ HM@@@@@@@@@@4MCP4MCP4MCP4M@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[246 246 246 233 233 233 252 252 251 216 212 172 245 245 245 243 243 243 239 239 239 237 237 237 255 255 255 159 154 124 181 177 143 100 103 106 223 223 223 241 241 241 197 197 197 201 197 160 166 160 114 251 251 251 145 141 101 197 191 137 159 155 126 157 153 122 139 135 100 204 204 204 222 222 222 218 213 173 247 247 247 254 254 254 252 252 252 228 228 228 153 149 116 169 169 169 249 249 249 215 210 169 161 161 161 188 188 188 248 248 248 148 144 118 253 253 253 218 212 172 227 227 227 234 234 234 120 116 84 222 228 234 0 0 0 244 244 244 231 231 231 138 134 101 155 151 119 208 202 155 250 250 250 145 140 99 149 153 157 214 208 165 146 142 103 198 193 140 166 162 117 162 158 115 191 184 139 199 193 138 162 162 162 219 213 174 151 147 112 138 134 99 192 192 192 242 242 241 211 206 161]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?A?@?A? ?O?0?O?8?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O? ?O? ?@@@?') ; yourself); yourself]
!

fileTypeExecutableFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeExecutableFileIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeExecutableFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeExecutableFileIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPT@@BTKB0,KB0,KB0,KIP@E@B(WC <XI1TLC@0LCA(*AP@KL"4YM@\ J2,VJ!!,RB0T@B2L,IB$]H2L#
H1PTJ@,E@AP2F1LRD!!HRD!!,[F1XTAP@"BP$IC@0@BP$LBP$IH T@E"</@2</A LCK2</K1XE@A@_G1<_G1<_G1<_G1<PAP@.CP4MCP4MCP4\G@4MK T@BCD3
L3@3L3L3L3L3LP E@@P&G!!8^G!!8^G!!8^G"XAAPTQHRD!!HRD!!HRD!!HRD!!@ TEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?<_?9??''?>_?9??''?>_?9??''?>_?9?? @@@@@b') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeFileIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CP4MCP4MCP@@@@@@@@@@@@@@CPDA@PDPQ\4@@@@@@@@@@@@@CP@GQ4]J@8HM@@@@@@@
@@@@@CPZK"8.GT@HBCP@@@@@@@@@@CP$JR$)@RL&B@ 4@@@@@@@@@CP A0\GJT@"OA<4@@@@@@@@@CP2CP4MA!!4LFB84@@@@@@@@@CPQKR4-KPTEASH4@@@@
@@@@@CP\@@@@@@@@@A04@@@@@@@@@CP&HB@ HB@ HBX4@@@@@@@@@CP[GA0\GA0\GA,4@@@@@@@@@CP[I"X&I"X&I!!,4@@@@@@@@@CPHB@ HB@ HB@ 4@@@@
@@@@@CP4MCP4MCP4MCP4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[246 246 246 233 233 233 252 252 251 216 212 172 245 245 245 243 243 243 239 239 239 237 237 237 255 255 255 159 154 124 181 177 143 100 103 106 223 223 223 241 241 241 197 197 197 201 197 160 166 160 114 251 251 251 145 141 101 197 191 137 159 155 126 157 153 122 139 135 100 204 204 204 222 222 222 218 213 173 247 247 247 254 254 254 252 252 252 228 228 228 153 149 116 169 169 169 249 249 249 215 210 169 161 161 161 188 188 188 248 248 248 148 144 118 253 253 253 218 212 172 227 227 227 234 234 234 120 116 84 222 228 234 0 0 0 244 244 244 231 231 231 138 134 101 155 151 119 208 202 155 250 250 250 145 140 99 149 153 157 214 208 165 146 142 103 198 193 140 166 162 117 162 158 115 191 184 139 199 193 138 162 162 162 219 213 174 151 147 112 138 134 99 192 192 192 242 242 241]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?C>@?C?@?C? ?C?0?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?@@@?@@@?') ; yourself); yourself]
!

fileTypeFileLinkIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeFileLinkIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeFileLinkIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeFileLinkIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@AZ_G1<_G1<_@@@@@@@AP@@_C@0LC@0LFY<@@@@@@T@@D80@ HB@"6DI$8@@@@E@@ANEC0<OC0<UQ@&S @@AP@@[E<)JR$)JVD7DBY,@@T@@G4AE1\WE1]W
MSU0_P@E@@APDC@0LC@0 $A2GU@@AP@@[Q0"H"H"H%=_W3--@@T@@HUIKB0,KB0,KB1I!!P@E@@@0LC@2GA0\GA0\CE8@AP@@!!0@@]P0LC@0LCC]T@@T@LEE>
@C47M3\7M3\V 0@E@ED@F''8=P4MCP4MCE%H@AP@@TS4=OTMCP4MCP4MV@@T@WVD=P4MCP4MCP4MCU @E@C4=ZV=6_51\_7Y/ZW,@@@@a') ; colorMapFromArray:#[0 0 0 245 245 245 228 228 228 211 211 211 194 194 194 195 200 209 240 240 240 223 223 223 158 161 168 209 214 224 155 155 155 171 172 173 252 252 252 183 90 90 218 218 218 150 150 150 247 247 247 230 230 230 140 142 146 145 145 145 242 242 242 192 197 206 254 254 254 237 237 237 220 220 220 146 149 154 169 169 169 152 152 152 249 249 249 232 232 232 215 215 215 234 240 251 147 147 147 210 216 226 244 244 244 120 4 4 193 193 193 142 142 142 239 239 239 224 230 241 251 251 251 234 234 234 217 217 217 200 200 200 246 246 246 229 229 229 144 144 144 187 188 188 241 241 241 217 222 233 224 224 224 226 232 243 210 215 225 156 156 156 173 173 173 253 253 253 236 236 236 219 219 219 145 148 153 248 248 248 231 231 231 214 214 214 197 197 197 141 143 147 226 226 226 209 209 209 175 175 175 255 255 255 238 238 238 221 221 221 147 150 155 153 153 153 216 222 232 250 250 250 233 233 233 111 112 112 191 192 192 226 226 226 184 188 197 253 253 253 180 184 193 154 154 154 173 178 186 228 228 228 176 181 189 182 182 182 172 177 185 187 187 187 214 214 214 241 241 241 197 202 211 224 224 224 134 138 144 138 138 138 177 182 190 243 243 243 239 239 239 184 184 184 244 244 244 242 242 242 249 249 249 245 245 245 190 190 190 237 237 237 255 255 255 163 167 175 169 169 169 247 247 247 183 187 196 179 183 192 246 246 246 155 159 166 160 160 160 229 229 229 225 225 225 252 252 252 248 248 248 204 204 204 144 147 154 231 231 231 156 156 156 254 254 254 250 250 250 186 191 200 184 189 198 182 186 195 45 45 45 137 141 147 232 232 232 237 243 254 235 235 235 174 179 187 180 180 180 178 182 191 234 234 234 66 66 66]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O<@?8C?0O? ??C?<O?0??C?<O?0??G?<_?1??G?<_?0b') ; yourself); yourself]
!

fileTypeFileOpenIcon
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeFileIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CP4MCP4MCP@@@@@@@@@@@@@@CPDA@PDPQ\4@@@@@@@@@@@@@CP@GQ4]J@8HM@@@@@@@
@@@@@CPZK"8.GT@HBCP@@@@@@@@@@CP$JR$)@RL&B@ 4@@@@@@@@@CP A0\GJT@"OA<4@@@@@@@@@CP2CP4MA!!4LFB84@@@@@@@@@CPQKR4-KPTEASH4@@@@
@@@@@CP\@@@@@@@@@A04@@@@@@@@@CP&HB@ HB@ HBX4@@@@@@@@@CP[GA0\GA0\GA,4@@@@@@@@@CP[I"X&I"X&I!!,4@@@@@@@@@CPHB@ HB@ HB@ 4@@@@
@@@@@CP4MCP4MCP4MCP4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[246 246 246 233 233 233 252 252 251 216 212 172 245 245 245 243 243 243 239 239 239 237 237 237 255 255 255 159 154 124 181 177 143 100 103 106 223 223 223 241 241 241 197 197 197 201 197 160 166 160 114 251 251 251 145 141 101 197 191 137 159 155 126 157 153 122 139 135 100 204 204 204 222 222 222 218 213 173 247 247 247 254 254 254 252 252 252 228 228 228 153 149 116 169 169 169 249 249 249 215 210 169 161 161 161 188 188 188 248 248 248 148 144 118 253 253 253 218 212 172 227 227 227 234 234 234 120 116 84 222 228 234 0 0 0 244 244 244 231 231 231 138 134 101 155 151 119 208 202 155 250 250 250 145 140 99 149 153 157 214 208 165 146 142 103 198 193 140 166 162 117 162 158 115 191 184 139 199 193 138 162 162 162 219 213 174 151 147 112 138 134 99 192 192 192 242 242 241]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?C>@?C?@?C? ?C?0?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?C?8?@@@?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeHeaderFileIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APW"7=?_:=/[8.@@@@@@APTE6JV%"*-P&$_^6 @@@@T@@NM0\JVX.<?EP.'',@@@E@@C#1;Q@]TCQQ:1B9N4@AP@@L;=0;?@;VGV//Z*CNPT@@GM[N>?0#'':%
*<3N5[0E@@A31MS/<MI[V<^JZ\*RAP@@\<&%;>?/;?B+PI 1T T@@GND3N?0)TC/<JT;L5HE@@CVUHS/<E9F;?A54#MRAP@@5)UX;?BD!!N?04-]3%@T@@MY 
4.?0UES/<HSI\5HE@@CV(DK/<FZU;?BD!!GMRAPT@5,N (K=P_&Z%.5Q3T TE@K:,0<OC(JB (FA \5HEAPWP2,+J2,+J2,+JM]AIAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232 175 175 175 155 155 155 239 239 239 148 148 148 210 210 210 243 243 243 254 254 254 245 245 245 194 194 194 225 225 225 236 236 236 55 146 70 247 247 247 145 145 145 176 176 176 218 218 218 0 91 12 209 209 209 220 220 220 169 169 169 200 200 200 242 242 242 222 222 222 244 244 244 142 142 142 153 153 153 246 246 246 140 142 146 133 137 143 192 197 206 145 148 153 146 148 152 137 139 143 171 172 173 147 150 155 234 240 251 139 141 145 158 161 168 141 143 147 187 188 188 15 15 116 143 145 149 93 93 178 145 147 151 191 192 192 134 138 144 146 149 154 195 200 209 224 230 241 146 146 146 120 4 4 183 90 90]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?<C?8O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
!

fileTypeHomeDirectoryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeHomeDirectoryIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeHomeDirectoryIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXToolbarIconLibrary fileTypeHomeDirectoryIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4 @@@@@@@@@@@@@@@@@@@@CE.\T@@I&4@@@@@@@@@@@@@I_W4]^R@L?G@@@@
@@@@@@@@%8?C2\NO);25@@@@@@@@@@BW5;>=4K6?(<R-@@@@@@@@@J:N69[!!5NFV6="&@@@@@@@@$LJ33[F 5*B13[OB$@@@@@@@0*>>0Y>$.JR_0[:/0 @@
@@@@@M:7''J#F5LZ(''K_^@@@@@@@@@L#]&M>26Z''_&M7H@@@@@@@@@JKL8MZS%L;V8L2"@@@@@@@@@I;V(][Z&+CV(]Z^@@@@@@@@@L+V5-Z*.:WV5-[J@@@@
@@@@@KZ[+J/\.-N]+I.6@@@@@@@@@@@@5\CK%\/@5P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[56 166 247 15 62 120 27 144 230 220 226 232 13 60 118 75 127 183 50 126 185 194 211 228 42 108 173 48 97 145 115 201 253 166 184 203 119 129 142 215 222 230 61 135 193 214 221 228 41 132 208 40 159 245 115 160 200 13 50 108 129 144 157 55 140 205 151 155 164 75 177 251 166 188 211 103 145 189 189 208 226 218 224 231 115 160 197 14 54 108 215 221 227 111 205 253 97 142 182 15 64 133 179 184 189 26 137 224 13 59 117 188 193 198 57 167 250 18 116 196 117 132 153 204 210 215 157 162 172 18 63 117 123 167 207 189 204 218 44 138 213 23 130 215 107 143 184 43 169 252 99 197 253 70 91 123 125 205 253 84 185 252 174 178 184 130 145 164 164 184 209 49 155 222 98 195 253 22 136 226 17 62 115 115 207 253 196 202 207 121 215 253 181 197 215 222 228 234 131 209 253 16 61 116 16 89 153 20 126 215 42 160 247 119 203 253 53 178 252 24 145 237 18 61 115 158 162 167 31 143 233 104 152 198 16 72 133 106 151 193 21 55 109 46 123 201 178 184 190 146 215 253 43 119 196 214 222 230 12 56 111 115 210 253 80 104 140 17 63 120 44 144 212 33 103 171 216 223 230 28 91 151 144 152 167 13 61 134 29 151 237 68 133 189 16 60 115 39 131 203 216 223 229 40 163 252 46 125 197 122 163 199 27 143 232 57 170 247 156 215 253 60 191 252 144 216 253 78 148 209 55 137 210 29 107 184 12 60 121 39 73 116 13 62 120 201 210 222 29 155 235 196 212 227 25 121 203 137 148 158 42 142 205 41 69 109 35 122 188 26 130 214 16 91 163 23 67 121 39 72 119 150 180 207 56 116 184 166 185 203 103 134 173 35 156 241 96 188 252 94 198 253 108 203 253 71 176 252 68 153 219 49 77 109 104 159 207 156 173 198 37 121 192 50 160 238 38 33 26 38 32 25 98 93 88 237 237 237 98 94 89 113 25 5 194 94 24 177 177 177 222 217 203 100 95 90 244 239 234 207 197 178 225 124 36 32 25 17 237 231 224 97 97 97 160 158 157 232 227 216 141 41 8 255 253 250 142 139 136 34 30 22 177 176 169 220 106 25 94 91 85 92 89 85 239 234 227 105 9 3 112 17 4 99 97 97 27 20 10 184 178 166 94 90 86 123 119 117 0 2 10 225 222 211 109 12 4 206 200 188 123 117 106 157 149 135 37 30 23 244 238 230 161 158 151 49 41 33 98 103 108 223 117 28 216 205 185 212 206 190 237 231 221 191 184 169 207 207 207 228 222 212 30 24 17 186 178 159 90 87 82 100 95 91 246 244 238 140 133 120 129 125 123 208 197 178 190 189 188 189 189 189 255 254 250 224 218 205 190 79 18 211 200 180 207 200 184 190 180 161 93 89 85 96 100 104 249 247 242 224 224 224 255 255 255 37 33 25 34 27 22 114 28 5 110 23 4 198 191 177 100 103 105 251 246 241 136 132 129 250 249 245 250 247 243 115 6 4]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?@D@?@NX?@_X?@?8?A?8?C?8?G?<?G?<?C?8?C?8?C?8?C?8?C?8?C?8?@? ?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeImageFileIcon'
        ifAbsentPut:[(Depth4Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H@@@@@@@@@@BHBH"H"H"H"HBHBL3L3L3L3HBHBL3L3L3L3HBHBL3L5UUL3HBHBL3MUUUT3HBHBL3L5UUL3HBHBL3L3D3L3HB
HBL3L3D3L3HBHBQCQDEDL3HBHBQDQDQDQDHBHBQDQDQDQDHBHBH"H"H"H"HBH@@@@@@@@@@BH"H"H"H"H"H"H"H"H"H"H"H"') ; colorMapFromArray:#[149 153 157 133 62 38 246 246 246 173 216 230 0 139 0 0 205 0]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?@@@?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?_?>?@@@?@@@?') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeJavaScriptSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APWPTUEQ 8N>4@@@@@@@APTE0JV%"*-P&$_K@ @@@@T@@CM0\JVX.<?EP,WA@@@E@@@31;Q@]TCQQ:1BW]H@AP@@L;=0_#,;VGV//Z*CNPT@@GM[N=M[#'':%
*<3N5[0E@@A3\LKR3\#G6-3ZZ\*RAP@@\;-&Q%B+7\#H2I 1T T@@GN+W*WM2L#M2L4;L5HE@@CV!!EA^3\#H3ZWY4#MRAP@@5%QT!!L7H6L7M6]]3%@T@@MZU
%USM2MKX2L7I\5HE@@CV3\!!&3\#M2L#M!!GMRAPT@5*CM3\!!&3\7M65Q3T TE@K:,0<OC(JB (FA \5HEAPWP2,+J2,+J2,+JM]AIAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232 175 175 175 155 155 155 239 239 239 148 148 148 210 210 210 243 243 243 254 254 254 245 245 245 194 194 194 225 225 225 236 236 236 55 146 70 247 247 247 145 145 145 176 176 176 218 218 218 0 91 12 209 209 209 220 220 220 169 169 169 200 200 200 242 242 242 222 222 222 244 244 244 142 142 142 153 153 153 246 246 246 252 250 250 255 254 250 252 252 250 248 250 250 232 230 230 224 224 220]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O<@?<C?8O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeJavaSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APWPTUEQ 8N>4@@@@@@@APTE0JV%"*-P&$_K@ @@@@T@@CM0\JVX.<?EP,WA@@@E@@@31;Q@]TCQQ:1BW]H@AP@@L;=0_#,;VGV//Z*CNPT@@GM[N=M[#'':%
*<3N5[0E@@A31MQ00-KM2L^JZ\*RAP@@\<&%.6YFTJ.+PI 1T T@@GND3J-^)\7H1*T;L5HE@@CVUHRDTE;M2L154#MRAP@@5)UXUERD3\#I4-]3%@T@@MY 
4)VUUL7H!!HSI\5HE@@CV(DKM2F[M2ERD!!GMRAPT@5,N (L7M2FZ%.5Q3T TE@K:,0<OC(JB (FA \5HEAPWP2,+J2,+J2,+JM]AIAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232 175 175 175 155 155 155 239 239 239 148 148 148 210 210 210 243 243 243 254 254 254 245 245 245 194 194 194 225 225 225 236 236 236 55 146 70 247 247 247 145 145 145 176 176 176 218 218 218 0 91 12 209 209 209 220 220 220 169 169 169 200 200 200 242 242 242 222 222 222 244 244 244 142 142 142 153 153 153 246 246 246]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O<@?<C?8O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeLispSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APW"7=?_:=/[8.@@@@@@APTE6JV%"*-P&$_^6 @@@@T@@NM0\JVX.<?EP.'',@@@E@@C#1;Q@]TCQQ:1B9N4@AP@@9+=0_#,;VGV//Z++NPT@@NY[N=M[#'':%
*<3N!!+0E@@C&1NW''4%-[18))Z]6RAP@@:L&;9^][V:-@&I#!!T T@@N"DV5/%95-[)S,;85HE@@C(UE-[W.W''3GWR4.YRAP@@:IU[V>W''9^_R5=_&%@T@@N!! 
V>W''UE/%9<''I:EHE@@C((E/%95-[9^^D!!N!!RAPT@:LN (K=P_&Z%.5S(T TE@M2,0<OC(JB (FA :EHEAPW":.+*:.+*:.+*6^IIAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232 175 175 175 155 155 155 239 239 239 148 148 148 210 210 210 243 243 243 254 254 254 245 245 245 194 194 194 225 225 225 236 236 236 55 146 70 247 247 247 145 145 145 176 176 176 218 218 218 0 91 12 209 209 209 220 220 220 169 169 169 200 200 200 242 242 242 222 222 222 244 244 244 142 142 142 153 153 153 246 246 246 140 142 146 133 137 143 192 197 206 145 148 153 146 148 152 137 139 143 171 172 173 147 150 155 234 240 251 139 141 145 158 161 168 141 143 147 187 188 188 15 15 116 143 145 149 93 93 178 145 147 151 191 192 192 134 138 144 146 149 154 195 200 209 224 230 241]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?<C?8O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeSmalltalkSourceIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APWPTUEQ 8N>4@@@@@@@APTE0JV%"*-P&$_K@ @@@@T@@CM0\JVX.<?EP,WA@@@E@@@31;Q@]TCQQ:1BW]H@AP@@L;=0_#,;VGV//Z*CNPT@@GM[N=M[#'':%
*<3N5[0E@@A31L#M3]OM3\7MZ\*RAP@@\<''M2L#MTL7H2I 1T T@@GND3\!!^VECM2JT;L5HE@@CVUL#MTE9X3\!!54#MRAP@@5)UX2L6DVL7H4-]3%@T@@MY 
4)WH3U#M2HSI\5HE@@CV(L7H2L5X3\"D!!GMRAPT@5,OH3\7HVL7H.5Q3T TE@K:,0<OC(JB (FA \5HEAPWP2,+J2,+J2,+JM]AIAP@a') ; colorMapFromArray:#[111 112 112 160 160 160 207 207 207 121 121 121 159 159 159 0 0 0 122 121 121 109 115 106 138 138 138 112 112 112 212 212 212 84 84 84 111 111 111 140 140 140 133 161 122 130 159 119 108 108 108 206 206 206 102 102 102 101 102 101 87 87 87 111 110 111 99 99 99 106 105 105 130 158 119 112 128 105 105 105 105 101 101 101 139 139 139 90 89 92 133 133 133 131 131 131 97 97 98 205 205 205 90 90 90 86 86 86 83 77 85 120 120 120 136 136 136 120 133 114 88 88 88 85 79 87 100 100 100 98 98 98 84 77 85 111 128 107 117 117 117 122 122 122 151 151 151 147 147 147 100 99 100 150 150 150 112 128 109 144 144 144 168 172 179 172 174 177 197 202 211 226 232 243 124 124 124 237 237 237 150 152 157 149 153 159 186 186 186 109 91 55 217 217 217 237 243 254 248 248 248 161 164 169 196 196 197 111 96 69 228 228 228 197 197 197 115 115 115 217 222 233 177 177 177 174 176 179 152 154 159 166 161 152 180 185 193 110 92 57 219 219 219 157 157 157 209 214 224 188 188 188 250 250 250 163 165 170 133 136 140 199 199 199 230 230 230 179 179 179 208 209 211 241 241 241 154 156 161 190 190 190 221 221 221 219 221 223 252 252 252 135 138 142 163 167 174 170 170 170 201 201 201 232 233 233 232 232 232 190 191 193 192 192 192 223 223 223 221 221 223 141 141 141 170 170 172 165 169 176 203 204 204 169 171 174 234 234 234 145 131 107 203 203 203 152 152 152 183 183 183 214 214 214 158 161 166 224 224 225 149 151 156 185 185 185 194 195 197 227 227 227 226 225 226 173 175 178 238 238 238 151 153 158 154 155 157 187 187 187 153 155 158 156 156 156 249 249 249 137 138 137 132 135 139 174 169 162 167 167 167 115 98 68 229 229 229 145 130 101 178 178 178 208 208 209 240 240 240 170 165 153 154 156 160 189 189 189 210 216 226 107 106 106 210 215 225 251 251 251 134 137 141 198 199 201 231 231 231 146 130 102 211 211 211 97 96 97 231 237 248 191 191 191 182 186 195 222 223 223 253 253 253 164 168 175 171 171 171 193 198 207 206 202 198 233 233 233 233 239 250 159 161 164 162 162 162 184 188 197 193 193 193 224 224 224 255 255 255 137 140 145 166 170 177 173 173 173 170 172 175 235 235 235 181 182 185 184 183 183 215 215 215 184 184 184 235 241 252 153 140 120 164 164 164 193 194 196 186 190 199 226 226 226 216 222 232 175 175 175 155 155 155 239 239 239 148 148 148 210 210 210 243 243 243 254 254 254 245 245 245 194 194 194 225 225 225 236 236 236 55 146 70 247 247 247 145 145 145 176 176 176 218 218 218 0 91 12 209 209 209 220 220 220 169 169 169 200 200 200 242 242 242 222 222 222 244 244 244 142 142 142 153 153 153 246 246 246]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O<@?<C?8O?0??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary class fileTypeTextHtmlIcon'
        ifAbsentPut:[(Depth8Image width:18 height:18) bits:(ByteArray fromPackedString:'
R$)JR$)JR$)JR$)JR$)JR$)JR$*OJ" (I!!<VG"D($$)JR$)JR$*KL3T5LR,&FBT8"IEJR$)JR$*MMS\6M#L,IQ]PNHZPR$)JR$*MNC$8NC\3J0YPTC"G$4)J
R$*MN30<N3(9L!!LFA@0T#$)JR$*MO30<_''9>_''9>OC0<"T)JR$*MP#0B@%UT_''9TUC0<!!D)JR$*MQEQTUEUT_%UUUC0< 4)JR$*MQ%QTU@I>_%UUUEP< $)J
R$*MQW9UUUU>_%QU_%P; $)JR$*MQ''9UUUQ>_%QTUW9B $)JR$*MSW9UUW9>UUQTUW9E $)JR$*MSW9>UW9>UUUTUW9G $)JR$*MS4%>_''9>_''9U^T%I $)J
R$*LTT%I_'':T%G9>RT%L T)JR$*JA@PDA@PDA@PDA@PD"$)JR$)JR$)JR$)JR$)JR$)JR$)J')
            colorMapFromArray:#[0 0 0 85 85 85 128 128 128 140 140 140 144 144 144 149 149 149 154 154 154 155 155 155 158 158 158 161 161 161 162 162 162 163 163 163 165 165 165 166 166 166 167 167 167 169 169 169 171 171 171 172 172 172 175 175 175 176 176 176 177 177 177 178 178 178 179 179 179 180 180 180 181 181 181 183 183 183 184 184 184 185 185 185 188 188 188 189 189 189 190 190 190 191 191 191 192 192 192 196 196 196 197 197 197 198 198 198 200 200 200 203 203 203 204 204 204 207 207 207 208 208 208 209 209 209 213 213 213 214 214 214 215 215 215 216 216 216 218 218 218 219 219 219 221 221 221 222 222 222 223 223 223 224 224 224 225 225 225 226 226 226 227 227 227 228 228 228 229 229 229 230 230 230 231 231 231 232 232 232 233 233 233 234 234 234 235 235 235 236 236 236 237 237 237 238 238 238 239 239 239 240 240 240 241 241 241 242 242 242 243 243 243 244 244 244 245 245 245 246 245 245 246 246 246 247 247 247 248 248 248 249 249 249 250 250 250 251 251 251 252 252 252 253 253 253 254 254 254 255 255 255 128 128 0 160 160 0 120 116 84 149 149 85 138 134 99 138 134 101 139 135 100 145 140 99 145 141 101 146 142 103 165 165 85 151 147 112 148 144 118 153 149 116 155 151 119 162 158 115 157 153 122 166 160 114 166 162 117 159 154 124 159 155 126 181 177 143 191 184 139 197 191 137 199 193 138 198 193 140 201 197 160 208 202 155 214 208 165 215 210 169 216 212 172 218 212 172 218 213 173 219 213 174 242 242 241 252 252 251 27 28 29 0 128 128 85 149 149 34 35 36 59 60 63 100 103 106 10 110 230 90 140 200 149 153 157 162 166 174 164 168 176 169 173 181 173 178 186 174 179 187 179 181 183 181 183 186 183 185 187 179 183 192 180 184 193 181 185 194 182 186 195 184 188 197 200 205 215 202 207 217 208 213 223 209 214 224 214 220 230 218 223 234 163 163 255]
            mask:((ImageMask width:18 height:18) bits:(ByteArray fromPackedString:'@@@?O? ?O?0?O?8?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?@@@?'); yourself); yourself]
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
        constantNamed:'MacOSXToolbarIconLibrary fileTypeTextIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@AY $)JE75PT6%J!!@@@@@@@@@AR!!X.KFF@WU592YT4@@@@@@@BC"14(JHVIW'',\\%!!-@@@@@@BC\$92\!!6EXFP\GGJG\P@@
@@BCU DAU"9NCF)$P&!!HTP@@@@BCX6M''"61LU&I4T7]GR0@@@@BCA''U3RD9CG8 #SD)7V @@@@BCCW15[ ]#]XXMKUQ+RP@@@@BCAPT#YE=6Q7=&\B9.W@@@
@@BC_@P$GP4M"2@GJ@YVW@@@@@BCAPBBWVE: G%/^''0FW@@@@@BCHBQ5[ ]#]XXMKR5<W@@@@@BCHAD#QX!!6Q7=&\@@-W@@@@@BCDRX$GP4M"2@GJBBJW@@@
@@A>I!!0\GA0QDSH2HB@$UP@@@@A8QE-OS4=OS4=OS5-D P@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[246 246 246 233 233 233 252 252 251 216 212 172 245 245 245 243 243 243 239 239 239 237 237 237 255 255 255 159 154 124 181 177 143 100 103 106 223 223 223 241 241 241 197 197 197 201 197 160 166 160 114 251 251 251 145 141 101 197 191 137 159 155 126 157 153 122 139 135 100 204 204 204 222 222 222 218 213 173 247 247 247 254 254 254 252 252 252 228 228 228 153 149 116 169 169 169 249 249 249 215 210 169 161 161 161 188 188 188 248 248 248 148 144 118 253 253 253 218 212 172 227 227 227 234 234 234 120 116 84 222 228 234 0 0 0 244 244 244 231 231 231 138 134 101 155 151 119 208 202 155 250 250 250 145 140 99 149 153 157 214 208 165 146 142 103 198 193 140 166 162 117 162 158 115 191 184 139 199 193 138 162 162 162 219 213 174 151 147 112 138 134 99 192 192 192 242 242 241 144 144 144 175 175 175 59 60 63 155 155 155 237 243 254 166 166 166 177 177 177 169 173 181 208 208 208 179 183 192 219 219 219 209 214 224 230 230 230 34 35 36 179 179 179 200 205 215 181 185 194 190 190 190 221 221 221 162 166 174 232 232 232 181 181 181 179 181 183 202 207 217 173 178 186 27 28 29 164 168 176 172 172 172 203 203 203 183 183 183 214 214 214 163 163 163 225 225 225 236 236 236 154 154 154 183 185 187 185 185 185 216 216 216 165 165 165 196 196 196 176 176 176 207 207 207 238 238 238 208 213 223 218 218 218 167 167 167 198 198 198 218 223 234 229 229 229 178 178 178 209 209 209 240 240 240 158 158 158 189 189 189 180 184 193 200 200 200 149 149 149 180 180 180 242 242 242 191 191 191 182 186 195 140 140 140 171 171 171 174 179 187 213 213 213 184 188 197 214 220 230 224 224 224 235 235 235 181 183 186 184 184 184 215 215 215 246 245 245 226 226 226]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?O? ?O?0?O?8?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?O?<?@@@?') ; yourself); yourself]
! !

!MacOSXToolbarIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

