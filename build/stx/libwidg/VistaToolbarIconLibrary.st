"
 COPYRIGHT (c) 2008 by eXept Software AG
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

XPToolbarIconLibrary subclass:#VistaToolbarIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!VistaToolbarIconLibrary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    ToolbarIconLibrary := VistaToolbarIconLibrary

    This is a style specific icon library for a vista look.

    Never access this iconlibrary directly from an application -
    always use ToolbarIconLibrary, which is an alias to one of the style specific
    icon libs.

    Notice and Warning:
        only redefine existing icons here; never only add here.
        For every icon-method here, there MUST be a corresponding (albeit
        possibly ugly) icon-method in GenericToolBarIcon.
"
! !

!VistaToolbarIconLibrary class methodsFor:'image specs'!

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
	constantNamed:'VistaToolbarIconLibrary class checkToggleOffDisabledIcon'
	ifAbsentPut:[(Depth4Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#[4]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'"H"H"H"H H&Y&YT,PXBI&Y%R1AFH"Y&UKDF; H&YH$F7L8BET$F7L@BA#DF7@@** HP[\J*&*(BK\0**)**@!!3B*)&Y& XLJ**Y&Y(B@**)&Y&ZD"H"H"H"H
 @@a') ; colorMapFromArray:#[249 249 249 245 245 245 242 242 242 248 248 248 244 244 244 241 241 241 251 251 251 247 247 247 177 177 177 240 240 240 250 250 250 246 246 246 243 243 243]; yourself]
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
        constantNamed:'VistaToolbarIconLibrary checkToggleOffEnteredIcon'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
C 8NC 8NC 8NC 8NC 8IBP$IBP$IBP$IBP8NBP<OC0<OC04/EP$NC $OI2\''I3\-@P IC 8IC2\''LP,*LBXRBP8NBP<3M3XAL!!0LI@$NC $#KPDDC@(5A#PI
C 8IKC@(HPHWF!!\"BP8NBR@(HQXWK!!<.D@$NC $HJ1XQ@BTXA1PIC 8IG"$CGPTYF1,SBP8NBP$IBP$IBP$IBP$NC 8NC 8NC 8NC 8NC @a') ; colorMapFromArray:#[226 245 254 187 229 253 213 240 254 177 225 251 190 231 253 201 234 252 210 239 253 231 247 254 131 206 249 222 249 250 205 237 253 181 226 253 196 234 253 121 199 249 85 134 163 121 198 249 190 230 252 217 241 254 133 207 249 207 236 253 200 234 252 128 203 249 209 239 253 221 243 254 232 247 254 210 237 253 222 243 254 212 238 253 194 233 253 189 229 252 140 210 249 228 245 254 128 204 249 200 235 253 180 226 251 123 200 249 144 212 249 231 246 254 192 232 253 177 223 253 193 232 253 161 219 250 185 228 253 199 235 253 126 202 249 183 227 253 227 245 254 124 201 249 189 230 253 178 223 253 191 231 253 178 224 253 163 219 250 208 238 253 183 226 253 180 225 253]; yourself]
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
        constantNamed:'VistaToolbarIconLibrary checkToggleOffIcon'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@GA0\GA0\GA0\GA0@@A2@ HB@ HBH$G@\@@@\ L#H2L#DQB!!HG@@@GHCH2DC@WK!!(#A0@@A2@,G0HJG"XVC@\@@@\3DSP*E"DEARTG
@@@GB28)F3TA@PD(A0@@A04]FPTAA0$GEP\@@@\NFPTHA0XFA PG@@@G@1LTJ2<OFB4''A0@@A0\GA0\GA0\GA0\@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[142 143 143 242 242 242 212 215 219 202 203 204 230 230 230 237 237 237 246 246 246 244 244 244 240 240 240 245 245 245 219 221 223 184 187 191 204 205 205 188 191 194 194 196 198 234 235 235 205 209 214 213 216 220 193 195 197 212 212 213 219 219 220 225 226 226 232 232 232 216 219 222 235 236 236 233 233 233 226 227 228 234 234 234 187 190 193 227 228 229 225 226 227 208 212 217 174 179 185 236 236 236 175 180 186 198 199 200 180 185 189 212 213 214 229 230 230 233 233 234 220 221 222 228 229 229 224 225 227 224 225 225 205 209 215 235 235 236 221 223 225 230 231 231 210 213 218 208 211 216 203 207 213 178 183 188 218 220 223 239 239 239]; yourself]
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
        constantNamed:'VistaToolbarIconLibrary checkToggleOnDisabledIcon'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
J"(*J"(*J"(*J"(*J"(GA0\GA0\G@ @#A2(*A0XFA XFIPPX@RL*J \FEAPTHA0OG"X#J"(GA!!PTH@4NG 0$A2(*A0XYCQ$KH!!,RD0\*J \)EB\\EP L@ (G
J"(GJ0L[GQ(II"LSA2(*A1P+F0 IDPHGCP\*J \)G0THBP8@H1\GJ"(GJAXMAQ@GG1<!!A2(*A0\GH0@BH0\GA0\*J"(*J"(*J"(*J"(*J @a') ; colorMapFromArray:#[252 252 252 238 238 238 251 251 251 190 190 190 210 210 210 203 203 203 216 216 216 249 249 249 174 174 174 175 175 175 234 234 234 248 248 248 186 186 186 240 240 240 219 219 219 180 180 180 205 205 205 184 184 184 224 224 224 237 237 237 230 230 230 223 223 223 236 236 236 242 242 242 194 194 194 235 235 235 187 187 187 173 173 173 246 246 246 233 233 233 172 172 172 245 245 245 231 231 231 244 244 244 183 183 183 250 250 250 243 243 243 229 229 229 222 222 222 214 214 214 228 228 228 227 227 227 142 143 143 239 239 239]; yourself]
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
        constantNamed:'VistaToolbarIconLibrary checkToggleOnEnteredIcon'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
F1,[F1,[F1,[F1,[F1,VE!!XVE!!XVA0 .E!!,[E"L#H2L#I <+MS([F1X#M#X6IB@I@CL]F1,VH3X6L#4E@@(''E!!,[E"L!!OR(-D0@0MAX[F1X;DR 9G@@_KR0V
F1,VH!!T@DRT@APP)E!!,[E ,<@@@@BR@9NAX[F1XYMQ(@@@0^A!!PVF1,V@#\1@PL/E08XE!!,[E!!XVCQHPCQXVE!!X[F1,[F1,[F1,[F1,[F0@a') ; colorMapFromArray:#[4 34 113 104 122 170 140 210 249 107 125 171 236 248 254 158 169 200 231 247 254 236 252 252 243 253 253 34 60 130 48 73 138 173 222 251 146 159 193 228 250 251 212 238 253 149 161 195 241 253 253 196 203 222 242 253 253 39 65 133 200 234 252 63 86 146 222 249 250 214 239 253 207 236 253 141 210 249 98 117 166 85 134 163 166 177 205 232 251 251 243 251 254 42 68 135 249 250 252 196 231 253 225 243 254 121 198 249 179 224 253 45 70 136 184 225 252 233 247 254 140 154 190 180 226 251 186 227 253 93 112 163 164 219 250 252 252 253 230 250 251 246 247 250 169 180 207 225 229 238 178 223 253 181 190 213 190 230 251 234 237 243 177 223 253 181 227 251 190 230 252 228 245 254 225 249 250 170 219 251 220 224 235 214 239 254]; yourself]
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
        constantNamed:'VistaToolbarIconLibrary checkToggleOnIcon'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
E1\WE1\WE1\WE1\WE1\/K2</K2</MP(^K1\WK3\7M3\7B1=@H PWE2<7DQDQIB@IA1@^E1\/M1DQMDP(LPHEK1\WK3\%K!!X#BC@RGR<WE2<;C3<=KPD8MS(/
E1\/C@@0GAP3PQ8+K1\WK0L<CTL3C!!$/L"<WE2<XHRYBO"\JG X/E1\/F20UM#$SF"$*K1\WK2</A@(5AB</K2<WE1\WE1\WE1\WE1\WE0@a') ; colorMapFromArray:#[110 127 170 73 94 150 101 119 165 205 207 209 245 245 245 231 231 232 230 230 230 68 90 146 94 113 161 87 106 157 249 249 249 201 204 208 222 224 225 72 93 149 97 115 164 201 207 221 185 191 208 203 207 213 188 195 214 242 243 246 103 120 167 223 226 233 213 216 220 142 143 143 198 200 202 248 249 250 236 237 237 202 203 204 207 212 226 219 220 220 246 246 246 157 167 192 237 238 241 234 236 240 220 223 228 242 243 244 204 208 214 213 217 221 139 153 187 176 185 209 175 184 207 235 235 236 233 233 234 220 221 222 218 218 219 186 193 213 223 226 229 244 244 244 71 92 148 69 90 146 225 226 226 75 96 151 205 209 214 248 248 248 140 153 186 174 179 185 100 118 165 144 157 189 213 213 214 197 201 205 222 225 233 237 238 238 76 97 152 163 174 200 119 134 171 183 191 213 74 95 151 73 95 150 224 226 230]; yourself]
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
        constantNamed:'VistaToolbarIconLibrary fileTypeDirectoryOpenGrayIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@BPTPQ!!G<6"6@5]"0@@@@@@@YM0-R6/).74]GQ.HX@@@@@@@AM&Y&U%X?P1JR^''8$@@@@@@@AM&Y&Y&*&*5)?W%B8@@@@@
@@@-&Y&Y%Z: $YSH2Q0@@@@@@@AJ&Y''C-KJ:1,''A$!!@@@@@@@@@ &\OE&L_N()KO)XM"@@@@@@@$0<VN4=J]):W@(R$2@@@@@@A=1X:W.:#U+ZFV2&8_@@@@
@@AZ#)^;(;&P,L*+269N@@@@@@@E%;.##J><3L/M/V9[@@@@@@@T.:NL,9N\-[7X6DLH@@@@@@@L(8236[FM)-#X6GAX@@@@@@@;#KOY+KF?)-#X6F%E@@@@
@@BHRXHYEUT<TUYXQ&Q9@@@@@@@@@A)4\5</@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[252 252 252 205 185 103 247 236 174 225 199 90 250 245 188 233 216 120 251 251 250 223 195 81 216 192 93 216 186 81 249 245 176 227 207 124 228 209 111 210 186 81 240 226 144 220 194 98 223 201 106 242 224 137 254 253 244 245 236 165 231 212 116 214 191 95 255 255 255 242 229 151 215 192 89 214 191 93 234 225 184 237 223 135 225 202 109 222 193 77 224 197 85 219 195 98 242 227 136 255 255 252 208 183 77 195 166 66 240 224 132 217 188 85 234 215 121 245 241 229 224 203 104 230 208 108 246 241 198 198 172 77 242 231 190 245 230 141 226 204 111 218 207 172 252 250 232 236 218 130 220 197 100 221 200 99 200 175 83 234 213 124 239 219 134 236 225 146 206 188 109 229 210 129 227 202 95 225 206 107 193 166 74 253 251 233 225 204 117 249 244 182 218 196 94 245 231 142 228 212 128 92 185 221 244 228 141 219 199 114 214 190 91 202 176 68 232 219 137 217 195 94 243 229 138 212 189 85 224 206 118 245 231 141 218 194 97 250 244 183 232 211 114 212 184 85 196 168 68 247 241 170 252 249 191 202 175 67 215 192 93 251 247 180 215 191 92 222 198 104 236 219 124 217 193 95 244 234 153 253 250 194 247 239 172 196 175 99 236 215 128 228 205 101 234 220 164 244 236 163 219 199 113 203 182 96 218 191 91 249 242 177 243 233 158 221 193 79 251 246 177 213 198 126 208 190 115 0 0 0 236 236 236 196 169 72 72 165 211 246 238 174 218 196 102 204 179 76 218 200 125 240 231 155 235 216 138 224 201 111 220 205 120 234 224 179 215 184 77 209 192 119 204 178 70 238 222 129 251 247 187 241 221 137 247 245 234 201 178 90 214 192 92 226 204 110 241 222 136 238 222 137 232 213 134 206 180 73 230 214 141 228 205 113 221 201 110 238 217 131 171 159 96 147 126 51 183 177 122 168 152 78 150 131 62 170 155 93 180 169 108 151 132 51 185 179 129 191 191 189 172 156 81 180 173 116 189 187 174 188 185 135 191 191 191 165 154 90 147 127 54 152 136 72 188 185 140 187 183 137 156 142 86 174 158 85 168 151 83 174 164 103 189 187 143 177 163 97 161 138 58 166 148 78 156 137 58 166 150 74 157 144 89 170 151 71 163 147 76 165 145 73 163 147 70 153 133 52 163 143 68 151 131 50 161 144 67 168 154 88 190 190 183 162 139 61 183 175 115 187 184 141 187 183 136 154 135 55 154 141 82 177 169 109 148 129 58 167 146 61 178 167 101 146 124 49 175 161 91 181 172 113 188 184 133 187 184 132 184 178 130 185 181 127 169 153 88 159 142 64 184 177 124 182 175 118 171 154 76 169 149 67 163 141 64 168 148 64 154 139 77 178 166 103 160 148 94 190 187 145 157 139 61 184 181 148 190 188 175 151 133 67 172 157 97 187 181 133 166 145 58 166 151 82]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?O?0?_?0?O?0?O?0?O?0?O?0?O?8?O?8?O?8?O?8?O?8?O?8?O?8?O?8?O?8?C8@?@@@?') ; yourself); yourself]
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

!VistaToolbarIconLibrary class methodsFor:'image specs-09x09'!

closeIndicatorInTree9x9Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self closeIndicatorInTree9x9Icon inspect
     ImageEditor openOnClass:self andSelector:#closeIndicatorInTree9x9Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class closeIndicatorInTree9x9Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:9;
                height:9;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@AH@@C\@Q@@@M0AEP@@7@DXG@C\@Q&BEM0AFA0@7@DU@@C\@Q@@@M0@R@@@7');
                colorMapFromArray:#[ 232 232 232 200 202 200 242 242 242 0 0 0 168 168 168 232 232 232 255 255 255 152 152 152 132 132 132 ];
                mask:((ImageMask new)
                            width:9;
                            height:9;
                            bits:(ByteArray fromPackedString:'LG<8_31?O''<?_39?OG<8_3A?');
                            yourself);
                yourself
        ]
!

openIndicatorInTree9x9Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self openIndicatorInTree9x9Icon inspect
     ImageEditor openOnClass:self andSelector:#openIndicatorInTree9x9Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class openIndicatorInTree9x9Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:9;
                height:9;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'DQDQDQDQDQHADADQH3DPDQH1LQDQH1D1F!!H1DSDPDCL3@Q@QDQDQDADQDQDS');
                colorMapFromArray:#[ 136 136 136 89 89 89 188 188 188 38 38 38 ];
                mask:((ImageMask new)
                            width:9;
                            height:9;
                            bits:(ByteArray fromPackedString:'@G<F_09?G''<>_79?_''<@_0A?');
                            yourself);
                yourself
        ]
! !

!VistaToolbarIconLibrary class methodsFor:'image specs-tools-FileBrowser-Filetypes'!

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
        constantNamed:'VistaToolbarIconLibrary fileTypeDirectoryIcon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@BPTPQ!!G<6"6@5]"0@@@@@@@YMZ#5\F7 DWU5]O8X@@@@@@@AMU5\!!HR!!+\UQ>S8$@@@@@@@AMU5]WE#M;NT=''W"8@@@@@
@@@-U5]WHTA,B58SZA0@@@@@@@AJU5\JD!! 8O& WC!!@@@@@@@@@ U0)SLD,A]0:ELXM"@@@@@@@$B%M#J 5%VSD&TB$2@@@@@@A=T6M5M2JAC5@)XV8_@@@@
@@AZX7T7RH\4Y&D:@69N@@@@@@@E]S]HP''0+IPL^A69[@@@@@@@TM4!!BSD]/BP\]GTLH@@@@@@@LRDIL"%UR^!!4]GWAX@@@@@@@;P$2J\%T#^!!4]GV%E@@@@
@@BHRXHYEUT<TUYXQ&Q9@@@@@@@@@A)4\5</@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[252 252 252 205 185 103 247 236 174 225 199 90 250 245 188 233 216 120 251 251 250 223 195 81 216 192 93 216 186 81 249 245 176 227 207 124 228 209 111 210 186 81 240 226 144 220 194 98 223 201 106 242 224 137 254 253 244 245 236 165 231 212 116 214 191 95 255 255 255 242 229 151 215 192 89 214 191 93 234 225 184 237 223 135 225 202 109 222 193 77 224 197 85 219 195 98 242 227 136 255 255 252 208 183 77 195 166 66 240 224 132 217 188 85 234 215 121 245 241 229 224 203 104 230 208 108 246 241 198 198 172 77 242 231 190 245 230 141 226 204 111 218 207 172 252 250 232 236 218 130 220 197 100 221 200 99 200 175 83 234 213 124 239 219 134 236 225 146 206 188 109 229 210 129 227 202 95 225 206 107 193 166 74 253 251 233 225 204 117 249 244 182 218 196 94 245 231 142 228 212 128 92 185 221 244 228 141 219 199 114 214 190 91 202 176 68 232 219 137 217 195 94 243 229 138 212 189 85 224 206 118 245 231 141 218 194 97 250 244 183 232 211 114 212 184 85 196 168 68 247 241 170 252 249 191 202 175 67 215 192 93 251 247 180 215 191 92 222 198 104 236 219 124 217 193 95 244 234 153 253 250 194 247 239 172 196 175 99 236 215 128 228 205 101 234 220 164 244 236 163 219 199 113 203 182 96 218 191 91 249 242 177 243 233 158 221 193 79 251 246 177 213 198 126 208 190 115 0 0 0 236 236 236 196 169 72 72 165 211 246 238 174 218 196 102 204 179 76 218 200 125 240 231 155 235 216 138 224 201 111 220 205 120 234 224 179 215 184 77 209 192 119 204 178 70 238 222 129 251 247 187 241 221 137 247 245 234 201 178 90 214 192 92 226 204 110 241 222 136 238 222 137 232 213 134 206 180 73 230 214 141 228 205 113 221 201 110 238 217 131]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@?O?0?_?0?O?0?O?0?O?0?O?0?O?8?O?8?O?8?O?8?O?8?O?8?O?8?O?8?O?8?C8@?@@@?') ; yourself); yourself]
!

fileTypeDirectoryOpenIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryIcon
     Icon flushCachedIcons
    "

    <resource: #programImage>

    ^ self fileTypeDirectoryIcon    
! !

!VistaToolbarIconLibrary class methodsFor:'image-specs-12x12'!

radioOff12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self radioOff12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOff12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'VistaToolbarIconLibrary class radioOff12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
OC0@G"PRD"P^@C0<OA(=B#@#H3@JOQ(<@@@]H HA@S<2GP@@G (OD2T6K ,-P0(^KB KE@L/A@8_I2 ,D"L\PAX LRDXCBLRD"L5PTH!!DDP;NA@IMA\7CRDP
DP YJQ\4I#8*EPUDDSL:H38&@@@]J3$1A \ZGP@@OA(@O#@QDR >@A(<OC0@I"P[F20&@C0<');
                colorMapFromArray:#[ 162 163 163 181 186 191 198 201 205 203 207 213 213 216 220 225 226 226 233 234 234 238 238 239 245 245 245 147 148 148 185 186 186 197 200 204 208 209 210 213 214 216 220 222 224 233 234 235 239 239 239 244 244 244 145 146 146 179 184 189 190 195 201 205 206 207 211 214 218 221 221 221 232 232 233 238 238 238 243 243 243 142 143 143 180 185 189 195 195 195 207 208 208 211 212 215 219 221 223 233 233 233 237 237 238 242 242 242 170 171 171 189 194 199 206 206 206 212 213 213 220 220 220 232 232 232 236 236 237 240 240 241 169 169 169 190 193 197 201 206 211 206 210 215 219 219 219 228 228 229 237 238 238 241 241 241 167 168 168 187 190 194 200 205 210 207 209 211 219 220 220 226 227 227 235 235 235 239 239 240 255 255 255 163 164 164 186 187 187 200 203 206 205 209 214 215 218 221 224 225 227 235 236 236 240 240 240 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'G8=?;7?/????????????????_>=?;1>O');
                            yourself);
                yourself
        ]
!

radioOffDisabled12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self radioOffDisabled12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOffDisabled12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class radioOffDisabled12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
OC1N!!B]_W2^DS#0<OD5(JD%GQ4$(ZD4<S$9TTT-)ZUUQUD9N!!B"EZ&5V\6QHBB"DR$%$SDU+[E9 A$%JW4]XS69^\QE4VT]_W4]" %\QQ$YFRTY&[1%Z\AEF
SV]QF!!%/]WY7^DQFST\HQ7Y5S$9T^711DW9MUD9NOD5N]$%MST%6S$4<OC1N]R]?_4)5S#0<');
                colorMapFromArray:#[ 162 163 163 181 186 191 198 201 205 203 207 213 213 216 220 225 226 226 233 234 234 238 238 239 245 245 245 147 148 148 185 186 186 197 200 204 208 209 210 213 214 216 220 222 224 233 234 235 239 239 239 244 244 244 145 146 146 179 184 189 190 195 201 205 206 207 211 214 218 221 221 221 232 232 233 238 238 238 243 243 243 142 143 143 180 185 189 195 195 195 207 208 208 211 212 215 219 221 223 233 233 233 237 237 238 242 242 242 170 171 171 189 194 199 206 206 206 212 213 213 220 220 220 232 232 232 236 236 237 240 240 241 169 169 169 190 193 197 201 206 211 206 210 215 219 219 219 228 228 229 237 238 238 241 241 241 167 168 168 187 190 194 200 205 210 207 209 211 219 220 220 226 227 227 235 235 235 239 239 240 255 255 255 163 164 164 186 187 187 200 203 206 205 209 214 215 218 221 224 225 227 235 236 236 240 240 240 229 231 234 247 247 247 248 248 248 222 224 226 237 237 237 212 212 212 226 228 230 222 225 228 249 249 249 208 209 209 230 232 234 245 245 245 246 246 246 212 213 213 246 246 246 225 225 225 227 229 230 227 230 232 239 240 241 217 220 222 231 232 232 231 232 233 246 246 246 247 247 247 237 237 237 237 238 239 200 200 200 233 233 235 233 234 234 221 222 224 247 247 247 226 227 229 249 249 249 201 201 201 250 250 250 209 209 209 218 220 223 217 219 222 230 232 235 234 235 237 222 224 227 233 234 236 211 211 211 234 234 235 241 241 242 220 220 220 228 230 233 243 243 244 230 230 230 220 221 221 245 245 246 230 230 231 240 240 240 248 248 248 247 247 248 240 241 241 244 244 244 246 246 247 198 199 199 237 237 237 237 238 239 235 236 238 243 243 243 231 231 231 244 244 245 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'G8=?;7?/????????????????_>=?;1>O');
                            yourself);
                yourself
        ]
!

radioOffEntered12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self radioOffEntered12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOffEntered12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class radioOffEntered12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@(XS@0HR!!@@@@@K1=!!*J/+:JF_[0@@G.I*</F1,*,"W,@(XZ*0<7S5MCE*XZ!! :SI3M#W6-;Q3*RC0J?C5-/]8NI12J?@0J?D6==1:N3*5Z7A *WO4.O)
;.?+9JVB''8^)1=3,<N7&,X^_@G.I+-''!!9^^2"W,@@K1;!!:J4-JRG^;0@@@@@''8R>/(N_@@@@');
                colorMapFromArray:#[ 162 163 163 181 186 191 198 201 205 203 207 213 213 216 220 225 226 226 233 234 234 238 238 239 245 245 245 147 148 148 185 186 186 197 200 204 208 209 210 213 214 216 220 222 224 233 234 235 239 239 239 244 244 244 145 146 146 179 184 189 190 195 201 205 206 207 211 214 218 221 221 221 232 232 233 238 238 238 243 243 243 142 143 143 180 185 189 195 195 195 207 208 208 211 212 215 219 221 223 233 233 233 237 237 238 242 242 242 170 171 171 189 194 199 206 206 206 212 213 213 220 220 220 232 232 232 236 236 237 240 240 241 169 169 169 190 193 197 201 206 211 206 210 215 219 219 219 228 228 229 237 238 238 241 241 241 167 168 168 187 190 194 200 205 210 207 209 211 219 220 220 226 227 227 235 235 235 239 239 240 255 255 255 163 164 164 186 187 187 200 203 206 205 209 214 215 218 221 224 225 227 235 236 236 240 240 240 252 252 252 0 0 0 125 141 152 130 144 156 133 147 159 137 151 162 142 154 164 143 156 166 144 213 229 151 163 172 153 163 171 145 178 198 24 51 71 12 61 93 24 51 72 15 63 93 24 53 74 166 176 185 25 52 74 20 64 92 169 180 188 174 184 191 30 63 87 29 62 87 30 62 87 32 64 88 31 63 88 36 68 93 185 190 196 188 193 197 39 71 96 186 191 197 192 197 201 48 75 95 201 204 205 54 81 102 14 132 198 11 130 199 24 152 209 209 213 215 15 131 199 23 138 199 32 157 209 40 162 209 199 235 253 34 143 198 217 220 222 72 99 120 220 223 226 93 206 221 105 194 212 92 152 191 94 153 191 127 230 238 115 155 179 108 161 192 117 157 180 102 163 201 99 159 199 102 163 204 111 168 201 123 161 184 125 162 185 127 164 186 123 166 192 143 183 200 145 184 201 142 179 201 156 194 208 152 183 202 23 51 72 156 186 204 24 53 75 157 187 205 148 206 235 13 67 103 145 204 237 147 205 237 21 70 100 146 204 237 17 69 103 177 246 250 153 211 239 29 63 88 28 62 88 30 63 88 29 62 88 30 64 90 34 68 94 38 72 98 181 202 215 175 218 237 183 204 216 188 221 229 47 75 96 190 222 230 191 223 231 53 82 104 190 224 239 199 227 238 207 242 250 207 241 250 211 244 250 212 244 250 216 244 246 215 246 250 219 246 248 71 100 122 219 247 250 221 248 250 30 190 255 222 249 250 17 163 242 13 160 243 40 196 255 19 162 243 29 170 243 50 202 255 42 176 242 237 242 245 233 247 254 85 134 163 116 255 255 89 137 165 93 140 167 251 252 253 128 202 249 132 205 249 134 206 249 132 203 249 146 213 249 153 216 250 154 215 249 156 216 249 155 215 249 152 213 251 150 211 251 161 220 249 159 219 249 154 213 251 166 220 251 167 221 251 170 221 253 171 221 253 177 225 251 175 222 253 178 224 253 177 223 253 189 232 251 183 227 253 182 226 253 186 229 252 187 229 253 188 229 253 191 231 253 193 232 253 194 232 252 197 234 253 200 235 253 202 237 251 208 237 253 210 238 253 215 242 252 213 240 254 214 241 254 216 241 254 216 240 253 218 242 254 223 243 254 226 245 254 229 246 254 228 245 254 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'G8=?;7?/????????????????_>=?;1>O');
                            yourself);
                yourself
        ]
!

radioOn12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self radioOn12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOn12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'VistaToolbarIconLibrary class radioOn12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
OC0@G"PRD"P^@C0<OA(=B#@#H3@JOQ(<@@@]H&QIRVH2GP@@G (OR&M4ZE9KP0(^KB!!!!XEA1]5!![Y2 ,D"MGY$56\F9SSBLRD"MHTWI/Z6%SS!!@IMA]%V5Q-
Z%I_\1\4I#8*S51UU55ZH38&@@@]J61VVWTZGP@@OA(@O#@QDR >@A(<OC0@I"P[F20&@C0<');
                colorMapFromArray:#[ 162 163 163 181 186 191 198 201 205 203 207 213 213 216 220 225 226 226 233 234 234 238 238 239 245 245 245 147 148 148 185 186 186 197 200 204 208 209 210 213 214 216 220 222 224 233 234 235 239 239 239 244 244 244 145 146 146 179 184 189 190 195 201 205 206 207 211 214 218 221 221 221 232 232 233 238 238 238 243 243 243 142 143 143 180 185 189 195 195 195 207 208 208 211 212 215 219 221 223 233 233 233 237 237 238 242 242 242 170 171 171 189 194 199 206 206 206 212 213 213 220 220 220 232 232 232 236 236 237 240 240 241 169 169 169 190 193 197 201 206 211 206 210 215 219 219 219 228 228 229 237 238 238 241 241 241 167 168 168 187 190 194 200 205 210 207 209 211 219 220 220 226 227 227 235 235 235 239 239 240 255 255 255 163 164 164 186 187 187 200 203 206 205 209 214 215 218 221 224 225 227 235 236 236 240 240 240 252 252 252 0 0 0 125 141 152 130 144 156 133 147 159 137 151 162 142 154 164 143 156 166 144 213 229 151 163 172 153 163 171 145 178 198 24 51 71 12 61 93 24 51 72 15 63 93 24 53 74 166 176 185 25 52 74 20 64 92 169 180 188 174 184 191 30 63 87 29 62 87 30 62 87 32 64 88 31 63 88 36 68 93 185 190 196 188 193 197 39 71 96 186 191 197 192 197 201 48 75 95 201 204 205 54 81 102 14 132 198 11 130 199 24 152 209 209 213 215 15 131 199 23 138 199 32 157 209 40 162 209 199 235 253 34 143 198 217 220 222 72 99 120 220 223 226 93 206 221 105 194 212 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'G8=?;7?/????????????????_>=?;1>O');
                            yourself);
                yourself
        ]
!

radioOnDisabled12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self radioOnDisabled12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOnDisabled12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class radioOnDisabled12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
N#(:E1UAPQTWN#(:N!!@CP08=OP9C@1@:N#$_A3,0LCHGG3$:E4LXP"4RF0@KFDLWC@X;M TYGRLQH@XLPS4/IB$JIQ0>EC5APS4&O!!L7@P$>A@<8I31DDQ(.
PB0QJ#0''QSDXG  5MS<MMCEEN#$_Q#L(E"D+G3$:N!!@9LP8"H X1NQ@:N#(:QQTB@ 1EN#(:');
                colorMapFromArray:#[ 142 159 172 142 222 255 170 194 209 186 206 217 189 210 223 206 221 230 222 238 242 233 249 252 141 158 171 136 209 248 185 255 255 178 209 228 190 208 220 205 220 229 221 238 242 235 249 250 246 248 250 142 159 171 163 177 188 148 215 248 181 208 223 191 209 220 203 219 228 219 229 235 231 248 252 244 251 254 136 162 179 154 168 179 142 212 249 191 242 246 183 211 228 205 224 231 204 233 247 227 241 246 238 252 252 138 162 177 151 165 175 152 228 255 174 204 223 189 208 219 198 217 228 216 250 252 222 239 247 238 251 252 134 161 179 146 163 176 137 208 249 173 203 223 177 207 227 200 219 228 201 230 246 215 236 246 237 251 252 139 154 165 144 161 174 147 225 255 174 197 211 185 205 217 208 209 209 200 229 246 223 239 243 237 250 251 139 153 163 142 158 171 134 207 249 172 196 210 178 209 229 199 219 227 201 230 245 218 228 235 235 250 252 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'G8=?;7?/????????????????_>=?;1>O');
                            yourself);
                yourself
        ]
!

radioOnEntered12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self radioOnEntered12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOnEntered12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'VistaToolbarIconLibrary class radioOnEntered12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@(XS@0HR!!@@@@@K1=!!*J/+:JF_[0@@G.I*9Q?_9J,"W,@(XZ* I:0))1>*XZ!! :RQ''X:=^)NX%:RC0J=8(9Z?.+&K_J?@0J=9";.7,;VK!!Z7A *VO&IV8
-)BZ):VB''8^) Y&M#Y.L,X^_@G.I+*BH"*"2"W,@@K1;!!:J4-JRG^;0@@@@@''8R>/(N_@@@@');
                colorMapFromArray:#[ 162 163 163 181 186 191 198 201 205 203 207 213 213 216 220 225 226 226 233 234 234 238 238 239 245 245 245 147 148 148 185 186 186 197 200 204 208 209 210 213 214 216 220 222 224 233 234 235 239 239 239 244 244 244 145 146 146 179 184 189 190 195 201 205 206 207 211 214 218 221 221 221 232 232 233 238 238 238 243 243 243 142 143 143 180 185 189 195 195 195 207 208 208 211 212 215 219 221 223 233 233 233 237 237 238 242 242 242 170 171 171 189 194 199 206 206 206 212 213 213 220 220 220 232 232 232 236 236 237 240 240 241 169 169 169 190 193 197 201 206 211 206 210 215 219 219 219 228 228 229 237 238 238 241 241 241 167 168 168 187 190 194 200 205 210 207 209 211 219 220 220 226 227 227 235 235 235 239 239 240 255 255 255 163 164 164 186 187 187 200 203 206 205 209 214 215 218 221 224 225 227 235 236 236 240 240 240 252 252 252 0 0 0 125 141 152 130 144 156 133 147 159 137 151 162 142 154 164 143 156 166 144 213 229 151 163 172 153 163 171 145 178 198 24 51 71 12 61 93 24 51 72 15 63 93 24 53 74 166 176 185 25 52 74 20 64 92 169 180 188 174 184 191 30 63 87 29 62 87 30 62 87 32 64 88 31 63 88 36 68 93 185 190 196 188 193 197 39 71 96 186 191 197 192 197 201 48 75 95 201 204 205 54 81 102 14 132 198 11 130 199 24 152 209 209 213 215 15 131 199 23 138 199 32 157 209 40 162 209 199 235 253 34 143 198 217 220 222 72 99 120 220 223 226 93 206 221 105 194 212 92 152 191 94 153 191 127 230 238 115 155 179 108 161 192 117 157 180 102 163 201 99 159 199 102 163 204 111 168 201 123 161 184 125 162 185 127 164 186 123 166 192 143 183 200 145 184 201 142 179 201 156 194 208 152 183 202 23 51 72 156 186 204 24 53 75 157 187 205 148 206 235 13 67 103 145 204 237 147 205 237 21 70 100 146 204 237 17 69 103 177 246 250 153 211 239 29 63 88 28 62 88 30 63 88 29 62 88 30 64 90 34 68 94 38 72 98 181 202 215 175 218 237 183 204 216 188 221 229 47 75 96 190 222 230 191 223 231 53 82 104 190 224 239 199 227 238 207 242 250 207 241 250 211 244 250 212 244 250 216 244 246 215 246 250 219 246 248 71 100 122 219 247 250 221 248 250 30 190 255 222 249 250 17 163 242 13 160 243 40 196 255 19 162 243 29 170 243 50 202 255 42 176 242 237 242 245 233 247 254 85 134 163 116 255 255 89 137 165 93 140 167 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'G8=?;7?/????????????????_>=?;1>O');
                            yourself);
                yourself
        ]
! !

!VistaToolbarIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

