"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Object subclass:#IconLibrary
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'SVN-UI'
!

!IconLibrary class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!IconLibrary class methodsFor:'initialization'!

initialize

    MenuEditor addNewImageRetriever:self name

    "
        self initialize 
    "

    "Created: / 11-04-2008 / 09:55:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!IconLibrary class methodsFor:'image specs'!

add
"      Loaded from: /tmp/full/tortoise/add.gif"

    "
     self add inspect
     ImageEditor openOnClass:self andSelector:#add
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class add'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ C@0L@@@@@@@@@@@@@@@@HA0\C
@@@@@@@@@@@@@@ HB@PF@0LC@@@@@@@@@@@HAP\B@PXF@0@@@@@@@@@@B@\G@P HB@L@@@@@@@@@@@LC@0\H@0LC@@@@@@@@@@@@@@ FB@L@@@@@@@@@@@@@
@@@HB@LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 4 126 188 36 182 252 4 86 124 76 134 252 148 218 252 4 146 220 76 194 252 4 106 156]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@C0@O@C?@O<@?0C?@C0@O@@@@@@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

added_ov
"      Loaded from: /tmp/full/ovr16/added_ov.gif"

    "
     self added_ov inspect
     ImageEditor openOnClass:self andSelector:#added_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class added_ov'
        ifAbsentPut:[(Depth8Image new) width: 8; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'BP$E@@@@BP$IBPTFA @IBPTEAPPG@@@@APLF@PHGA0@EA XBAPTE@@@@@@XE@@@@B@$EA0T@BP$HBPTE@@@IBP@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[4 86 124 36 182 252 4 126 188 148 218 252 76 134 252 4 106 156 76 194 252 4 146 220 253 254 254 255 255 255]; mask:((ImageMask new) width: 8; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'OC3?????/K0b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

annotate
"      Loaded from: /tmp/full/subversive/annotate.gif"

    "
     self annotate inspect
     ImageEditor openOnClass:self andSelector:#annotate
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class annotate'
        ifAbsentPut:[(Depth8Image new) width: 17; height: 17; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
VE!!XVE!!XVE!!YVU%YVU%YVU%XUEQTUEQTM5!!YVU%YVU%YVT$PB3<PB0,SP%!!YVU%YVU%YS$PA@ @CL"DSF$UYVU%YVU$0OEL[T4!!ST5MSTE%YVU%YVQX#BP(G
@PH@@28VVU%YVU%YOUYVU%YVU%YVU"YYVU%YVU$OJ@$JA0DB@@L C5%YVU%YVP9WU5]WU5]WU5\NVU%YVU%YJ1PIB \A@ @CEDAYVU%YVU%CT%IRT%IRC@0L
N5%YVU%YVST9A0DB@BPWGS(EL1$WVU%YM  HS0 "A TQUPQUDS8FVU%KKR)QI0XEQ%T^LPQUG3PFVU%YVU%YAP4MAA1GR"T)K3!!YVU%YVU$UD$5UAB1AUP4R
EU%YVU%YVU%YVQ!!USETXVU%YVP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[140 159 194 154 172 203 147 166 198 134 154 190 127 127 250 74 74 74 124 124 124 162 179 207 220 231 247 172 188 213 168 184 211 248 249 252 249 251 254 244 246 255 155 161 161 161 164 156 247 249 251 165 163 151 151 150 146 218 189 124 228 236 249 195 195 190 173 171 149 178 178 178 227 227 227 90 90 89 212 178 104 242 246 251 39 23 143 101 101 101 255 255 255 239 242 255 246 203 110 224 200 143 248 250 253 240 245 251 231 235 242 130 129 251 167 168 153 230 233 239 241 198 104 242 244 255 131 146 176 149 157 164 35 19 135 131 146 177 240 244 251 241 244 255 178 174 146 23 8 111 246 248 251 81 81 81 52 53 52 139 150 171 134 148 174 212 178 105 44 44 44 223 233 248 85 85 85 233 235 238 242 245 251 167 168 152 60 60 60 248 249 251 150 157 164 133 134 251 213 178 105 144 154 168 245 248 251 183 177 142 241 243 255 29 14 124 243 245 251 187 180 139 17 3 100 131 145 177 137 137 251 246 248 255 183 177 143 221 231 247 178 175 146 130 145 176 225 234 248 243 246 251 249 250 252 202 200 185 242 198 104 245 203 110 191 182 136 255 255 255]; mask:((ImageMask new) width: 17; height: 17; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'?0@@?8@@?<@@?>@@?>@@?>@@?>@@?>@@?>@@?>@@?>@@??0@??8@??<@A?<@A?<@@O @') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

annotate_view
"      Loaded from: /tmp/full/cview16/annotate_view.gif"

    "
     self annotate_view inspect
     ImageEditor openOnClass:self andSelector:#annotate_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class annotate_view'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
V5-[V5-[V5-[V5-[V5-[V5-[V5,\F1,\V5-[V5-[V5-[V5-[EU-[F%-[V5-[V5-[V4MCQQ%ED1QIP4MCP4MCP5-CMP,PMQDXQCT5MST5MTM[P#PJC3LRE4D3
MA44L#QGV4 /E 8/C@$<LB8-K3D/Q%-KJ  DK@4EPB$+KB$*KD-[S"\GI0L(A#<(JB\(JB!!NV5@%@RT$I@@;IBT%IS$>TE-THBMQ@%D:HRH#I$)MT5)[VQ<_
G3\8G1<_G3YLT%)[V5 ^G!!8^G!!8^G!!8=S5Y[V5-WU5]WU5]WU5]WU5U[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[94 76 84 72 58 64 90 71 80 99 80 89 104 85 94 103 86 94 98 80 89 75 61 68 79 65 72 109 92 101 87 74 81 91 78 85 144 131 138 139 126 133 109 91 101 114 98 107 119 103 112 151 139 146 147 135 142 155 143 150 123 108 117 127 112 121 82 69 77 113 97 107 118 102 112 122 108 117 126 112 121 129 115 124 205 199 203 253 245 158 255 234 46 255 235 56 254 236 70 255 236 71 255 237 71 254 236 71 254 237 88 254 238 88 254 238 90 254 239 107 254 240 107 254 241 125 254 241 126 254 242 126 253 241 126 254 243 143 253 242 143 253 243 143 254 243 144 253 242 144 254 244 157 254 244 158 253 244 158 253 245 168 255 229 48 223 203 62 222 202 62 253 233 79 223 204 74 222 206 87 222 210 131 255 218 14 254 223 33 222 206 102 222 208 118 221 210 143 193 183 127 193 184 129 221 211 151 212 205 167 193 181 124 193 182 127 193 180 124 180 170 127 221 178 25 193 178 121 203 164 39 195 158 45 193 175 117 186 152 52 193 172 113 179 164 119 178 145 58 171 140 63 193 170 110 171 139 64 166 135 68 193 164 101 193 165 103 193 167 106 161 132 71 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@O@@$@_?=??7??_?=??7??_?=??7?>_?1?>@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

arrowDown24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self arrowDown24x24 inspect
     ImageEditor openOnClass:self andSelector:#arrowDown24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class arrowDown24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
%)ZV%)ZV% AEB0,KB0,KB0-*R!!DQDQEKM3\7M3\7M0$AMST5MST5@W$KR!!DQDQEKM3\7M3\7M3, LH6KT@H%VPDKR!!DQDQEKM3\7M3\7M3T4NV1GG!!9)%CTK
R!!DQDQEKM3\7M3\7M3T4C2-SY6]UH#TKR!!DQDQEKM3\7M3\7M3T4RP]:K%M=H#TKR!!DQDQEK%)ZV%)ZV%#U/H!!);UUU)\CTKR!!DQDQDQ%)ZV%)ZV%#U/IX=A
Z@*@\CTKR!!DQDQDQ%)X7M3\7M3VWIX>OGP)?ISTK[$)JR$)JM0@1B0,KB3VWSV-W#1>SISU<B0,KB0,1M1!!LMST5MSVWS 9+P3JSIST5MST5MQ]HM7]QI1&J
]WQ3TCXNZ5\#S"ICPB)ZV05JM3]&KC9]XD) W3X6C&.RG6$JGQUF"T(QM3\7W#LYU" TI%<6M 9YQA<2#66C[!!DQM3\7$UFF"''!!!!JBY_M"HNU9LN\PX/DQDQ
M3\7M9D$O7Y#XQQ !!G@NZ1LDIA0QDQDQ%)ZV%)YRI@14"B!! W7@NOA,$@1DQDQDQ%)ZV%)ZV!!T0!!MB!! W0@VRRRAR!!DQDQDQ%)ZV%)ZV%(8EW@!!NXEAON&UJ
DQDQDQDQM3\7M3\7M3]^UI]$X$H= 4(QDQDQDQDQM3\7M3\7M3\7TW8PVH0F !!DQDQDQDQDQ%)ZV%)ZV%)X7$X]2D#.PM1DQDQDQDQDQ%)ZV%)ZV%)X7M5JG
!!7\7M1DQDQDQDQDQ%)ZV%)ZV%)X7M3\7M3\7M1DQDQDQDQDQ') ; colorMapFromArray:#[132 239 107 16 150 16 132 239 123 189 215 181 57 199 49 41 166 41 41 158 41 82 231 82 173 251 148 57 166 57 90 211 74 214 211 214 173 235 156 148 199 148 115 239 99 107 235 107 189 251 173 247 243 239 107 211 99 132 247 123 140 247 123 66 227 57 148 247 132 33 154 33 123 195 123 231 255 214 90 231 82 90 227 82 222 227 214 99 223 82 90 207 82 99 215 82 181 251 173 181 239 165 115 239 107 115 227 99 8 150 8 123 239 115 140 247 115 206 243 181 148 247 123 173 170 156 74 231 66 74 227 74 49 166 49 115 142 222 82 203 66 222 231 214 173 251 165 222 223 222 99 223 90 82 182 74 189 255 173 0 146 0 123 243 107 247 243 247 247 239 247 123 239 123 24 162 24 24 154 24 148 251 132 41 174 41 222 251 206 140 215 132 90 235 82 90 235 90 173 251 156 107 239 90 99 219 82 222 219 222 0 158 0 99 211 90 231 227 231 115 235 107 247 239 239 255 255 255 16 154 16 132 243 123 140 243 123 140 243 132 148 243 132 41 162 41 206 227 206 74 203 66 66 178 57 82 207 74 181 251 156 107 235 90 181 251 165 107 235 99 33 211 24 0 150 0 189 247 173 198 251 173 90 182 90 132 243 115 140 243 115 148 251 123 148 243 123 156 251 132 156 243 132 123 190 123 132 199 132 74 199 66 90 215 74 90 215 82 222 219 214 107 239 99 99 227 99 8 170 8 239 235 231 189 255 181 123 239 107 24 182 24 115 211 99 206 255 189 214 255 189 214 255 198 222 255 198 198 223 198 165 251 140 49 162 49 82 215 74 90 223 82 214 207 206 90 211 82 82 190 74 99 219 90 99 215 90 156 203 156 239 235 239 82 174 82 132 243 107 173 215 173 107 195 99 24 158 24 156 251 123 115 186 107 222 255 206 156 243 140 66 190 57 165 251 156 140 203 140 99 235 90 222 227 222 231 239 231 107 227 90 107 223 90 115 235 99 239 243 239 247 247 247 198 255 181]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O?@@_?@@_?@@_?@@_?@@_?@@_?@@_?@@_? O???_???_???O??>G??<G??8C??0A?? @?? @_?@@O>@@G<@@G8@@C0@@@@@') ; yourself); yourself]
!

arrowUp24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self arrowUp24x24 inspect
     ImageEditor openOnClass:self andSelector:#arrowUp24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class arrowUp24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
DQDQDQDQDQD7M3\7M3\7M9ZV%)ZV%)ZVDQDQDQDQDQD7M7^G!!5H7M9ZV%)ZV%)ZVDQDQDQDQDQD7$C,R\(^QM9ZV%)ZV%)ZVDQDQDQDQDQFBA(1XDG9QM3\7
M3\7M3\7DQDQDQDQDT*COTI"YI]TW#\7M3\7M3\7DQDQDQDQR&T:S5A S !!\AX:V%)ZV%)ZVDQDQDQEJ RQIE A_XB 4HT2E%)ZV%)ZVDQDQDQDCIA,<C''A_
XB"H]@0$T)ZV%)ZVDQDQDQ0$AAM+C''BDXAQ!!X7X?IID7M3\7DQDQK0Y1C)MWC"H6W2X(XW"J!!%FQM3\7DQE. 66OL!!=DVP86M%<&EB!!VFSM^M3\7DT*IQ!!T]
B&$_$&,NM#Y_XD) WS8,Y#\7R 5[V")@P2INH5]+C#YP\7Q5"!!$''TW\7RA\5MST5MST%$3ICZ09N%3T5MST5SA 7LP,KB0,K_CT%$1>OU6-M%3TKB0,KLP@7
R$)JR$).B3T%_0(]#8<%%3T7M3\7M9ZVDQDQDQEJB3U0 @)(PX<%[3VV%)ZV%)ZVDQDQDQEJB3U0ZUUU^1("[3VV%)ZV%)ZVR1DQDQEJB3T"_UL.^ ]IMCT7
M3\7M3\7R1DQDQEJB3T"UV]''T2,OMCT7M3\7M3\7R1DQDQEJB3VTZQ8^Q609MCT7M3\7M3\7R1DQDQEJB0EYIPIP"840HC,7M3\7M3\7R1DQDQEJB7$AMST5
MST5@P$7M3\7M3\7R1DQDQEJZ ,KB0,KB0,KQPBV%)ZV%)ZV') ; colorMapFromArray:#[132 239 107 16 150 16 132 239 123 189 215 181 57 199 49 41 166 41 41 158 41 82 231 82 173 251 148 57 166 57 90 211 74 214 211 214 173 235 156 148 199 148 115 239 99 107 235 107 189 251 173 247 243 239 107 211 99 132 247 123 140 247 123 66 227 57 148 247 132 33 154 33 123 195 123 231 255 214 90 231 82 90 227 82 222 227 214 99 223 82 90 207 82 99 215 82 181 251 173 181 239 165 115 239 107 115 227 99 8 150 8 123 239 115 140 247 115 206 243 181 148 247 123 173 170 156 74 231 66 74 227 74 49 166 49 115 142 222 82 203 66 222 231 214 173 251 165 222 223 222 99 223 90 82 182 74 189 255 173 0 146 0 123 243 107 247 243 247 247 239 247 123 239 123 24 162 24 24 154 24 148 251 132 41 174 41 222 251 206 140 215 132 90 235 82 90 235 90 173 251 156 107 239 90 99 219 82 222 219 222 0 158 0 99 211 90 231 227 231 115 235 107 247 239 239 255 255 255 16 154 16 132 243 123 140 243 123 140 243 132 148 243 132 41 162 41 206 227 206 74 203 66 66 178 57 82 207 74 181 251 156 107 235 90 181 251 165 107 235 99 33 211 24 0 150 0 189 247 173 198 251 173 90 182 90 132 243 115 140 243 115 148 251 123 148 243 123 156 251 132 156 243 132 123 190 123 132 199 132 74 199 66 90 215 74 90 215 82 222 219 214 107 239 99 99 227 99 8 170 8 239 235 231 189 255 181 123 239 107 24 182 24 115 211 99 206 255 189 214 255 189 214 255 198 222 255 198 198 223 198 165 251 140 49 162 49 82 215 74 90 223 82 214 207 206 90 211 82 82 190 74 99 219 90 99 215 90 156 203 156 239 235 239 82 174 82 132 243 107 173 215 173 107 195 99 24 158 24 156 251 123 115 186 107 222 255 206 156 243 140 66 190 57 165 251 156 140 203 140 99 235 90 222 227 222 231 239 231 107 227 90 107 223 90 115 235 99 239 243 239 247 247 247 198 255 181]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C0@@G8@@O8@@_<@@?>@A??@A?? C??0G??8O??8_??<???>???>???<A?>@@?>@@?>@@?>@@?>@@?>@@?>@@?>@@?<@') ; yourself); yourself]
!

blame
"      Loaded from: /tmp/full/tortoise/blame.gif"

    "
     self blame inspect
     ImageEditor openOnClass:self andSelector:#blame
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class blame'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CP$@BP4@@@@@@@@@@@@@H2@JI"@ H0@@@@@@@@@@CR@JHP( H@\M@@@@@@@@@APHC14VGRLG
BP@@@@@@@APDIQD&I"@JA0@@@@@@@@@#A@P%C1XPHP\I@@@@@@@@CP<HABHJHR@TE @@@@@@@AXTC0  A0\TIA0(@@@@@@@@F2LMBP@IE 0ZAA0@@@@TD1\J
D!!LC@@@FGBHDG@@@A"\''D1LS@0@@@A<\H  \@ATSD0DA@Q8@@@@@G10"BB U@QTU@1 N@@@@@@@_G@,(CPTEAP8NFP@@@@@@@@@\A @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 108 154 4 132 130 132 60 94 4 252 218 148 20 62 4 68 70 68 148 218 252 252 206 108 60 58 60 252 250 252 156 106 4 60 42 4 108 110 108 20 18 20 252 158 108 164 162 164 252 254 148 220 222 220 124 186 4 148 146 148 84 126 4 92 94 92 108 254 36 60 62 4 4 6 4 220 146 4 132 134 132 124 86 4 196 194 196 44 62 4 84 82 84 180 230 252 252 254 252 188 126 4 124 122 124 28 30 28 252 254 180 236 234 236 132 254 76 92 62 4]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@6@G<@?8C? _<A?8G? _?@=>O9<?#;>G?8O? Lb') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

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

branches_rep
"      Loaded from: /tmp/full/obj16/branches_rep.gif"

    "
     self branches_rep inspect
     ImageEditor openOnClass:self andSelector:#branches_rep
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class branches_rep'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@DAA@PDA@PDA@PDA@PDA@D@@@DDA@PDA@PDA@PDA@D@@@@@@PPDA@PDA@PDA@D@@ @@@ @AA@PDA@DAA@P@@PP@@@PA@@PDA@D@@@DDA@PD
@@@CA@PDA@D@@@@@@PPDA@@@@@LDA@D@@ @@@ @AA@P@@@@@@0P@@PP@@@PA@@PD@@@B@@@CA@PD@@@CA@PDA@@@A@H@@@PDA@@@@@LDA@P@@@PD@ HDA@P@
@@@@@0PDA@PDA@PDA@PD@@@B@@@CA@PDA@PDA@PDA@@@A@H@@@PDA@PDA@PDA@P@@@PD@ HDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[55 92 165 55 130 197 92 165 197 165 197 197 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@C@@^@C<@_8Y-#08_#3?O-,?GC\^L1<@G8@[ A&@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

browserSpheresBlue
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self browserSpheresBlue inspect
     ImageEditor openOnClass:self andSelector:#browserSpheresBlue
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class browserSpheresBlue'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_D1D]@@@@@@@@@@@^C!!XRBA,@
@@@@@@@@DAPWEP$J@@@@@@@@@@4LC0,CA0@@@@@@@@@\@PTB@A$@@@@@@@@@@A(FAA @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[33 33 155 50 50 217 52 52 230 57 57 244 67 67 120 58 58 244 70 70 134 70 70 140 64 64 241 68 68 255 77 77 166 78 78 254 78 78 255 89 89 212 91 91 248 92 92 254 97 97 221 99 99 217 99 99 255 104 104 220 103 103 255 108 108 254 123 123 255 141 141 253 153 153 167 154 154 169 157 157 182 160 160 196 162 162 199 166 166 209 170 170 217 172 172 217]; mask:((ImageMask new) width: 13; height: 11; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@O@A>@G8@_ A>@C0@@a') ; yourself); yourself]
!

browserSpheresBlueAndOrange
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self browserSpheresBlueAndOrange inspect
     ImageEditor openOnClass:self andSelector:#browserSpheresBlueAndOrange
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class browserSpheresBlueAndOrange'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@:J"P6@@@@@@@@@@@9LC07G3H@@@@@@@@@H3!!AN2HV@@@@@@@@@B@(LRX\DP@@@@@@@@@3EA8X@20@@@@@@@@5F 8ICB,@@@@@@@@4D2DYB"8@
@@@@@@@@E1,%GP,M@@@@@@@@@AHPEP<DB@@@@@@@@@@/@PXB@B$@@@@@@@@@@B4GAR\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[33 33 155 50 50 217 52 52 230 120 59 25 57 57 244 67 67 120 58 58 244 70 70 134 70 70 140 101 69 61 64 64 241 68 68 255 104 77 64 77 77 166 89 76 147 78 78 254 78 78 255 121 86 67 89 89 212 91 91 248 179 88 37 92 92 254 143 97 71 97 97 221 187 92 38 99 99 255 102 102 217 103 103 255 203 100 41 108 108 254 207 101 42 221 111 46 190 119 78 123 123 255 235 118 49 212 132 84 213 135 84 141 141 253 247 135 55 153 153 167 252 136 56 154 154 169 220 145 88 163 157 153 165 157 153 157 157 182 160 160 196 162 162 199 248 157 64 252 157 65 187 168 158 189 169 159 170 170 217 172 172 217 202 176 161 255 170 70 255 177 72 216 185 165 216 187 166 254 185 76 255 208 85 227 227 227 227 227 228 228 227 227 230 230 230 253 239 98]; mask:((ImageMask new) width: 13; height: 11; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O@A>@G8@_ A>@O0A>@G8@_ A>@C0@@a') ; yourself); yourself]
!

browserSpheresLime
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self browserSpheresLime inspect
     ImageEditor openOnClass:self andSelector:#browserSpheresLime
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class browserSpheresLime'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F!!HME @@@@@@@@@@FQ\^F0(T@@@@@@@@@@0\H!!4KAP@@@@@@@@@IDQ PA0L@@@@@@@@@EPPHA @O@@@@@@@@
@@@S@ DN@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[53 79 33 76 87 67 80 94 70 83 98 71 79 118 48 93 112 77 83 123 50 90 134 55 91 136 56 113 143 88 101 150 61 107 160 65 124 161 94 127 165 95 156 159 154 157 160 154 123 182 74 123 183 74 135 178 101 161 166 157 167 175 160 168 176 161 174 185 165 142 206 85 143 213 85 181 196 169 183 199 170 154 223 92 160 228 96 167 238 100 190 244 113 227 227 227 227 228 227 230 230 230 219 254 131]; mask:((ImageMask new) width: 13; height: 11; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@G @?@C<@O0@?@A8@@@@@@@@@@@a') ; yourself); yourself]
!

browserSpheresLimeAndBlue
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self browserSpheresLimeAndBlue inspect
     ImageEditor openOnClass:self andSelector:#browserSpheresLimeAndBlue
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class browserSpheresLimeAndBlue'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O2T!!O3<?O3<?O3<?O2$.J2L?O3<?O3<?O2@,K24$CC<?O3<?O3<YJB(''G  ?D1D?O3<?O1 _F 4EE"H[D#<?
O3<?A0L?C10&GQPDO3<?O3<?O0(UE1TN@#<?O3<?O3<?BQ@KA#<?O3<?O3<?O3<A@C<?O3<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[18 18 88 22 22 106 23 23 114 30 44 19 32 32 148 33 39 82 33 33 155 36 54 23 39 58 24 50 50 217 51 51 208 52 52 230 52 77 32 53 79 33 57 57 244 60 60 215 58 58 244 64 64 214 64 64 241 70 70 218 68 68 255 78 78 255 91 91 248 92 92 255 79 118 48 81 120 49 83 123 50 99 99 255 103 103 255 108 108 255 90 134 55 91 136 56 96 143 57 99 148 59 123 123 255 101 150 61 107 160 65 110 164 66 141 141 254 123 182 74 123 183 74 142 206 85 143 213 85 154 223 92 160 228 96 167 239 100 190 244 113 219 255 131 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width: 13; height: 11; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C@@^@C<@O6@_<@78@_ @<@A @@a') ; yourself); yourself]
!

browserSpheresLimeAndBlueAndOrange
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self browserSpheresLimeAndBlueAndOrange inspect
     ImageEditor openOnClass:self andSelector:#browserSpheresLimeAndBlueAndOrange
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class browserSpheresLimeAndBlueAndOrange'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@ASNSEK@@@@@@@@@@AQQE!!LJTX@UTD4SP@@LD=_UB8\T$9ZU"5G@B(7QST#ECIWXE$/GPAHFBX^@30,O5@>IQUJHQ@JCS(@RQ,''G0P(E2, B4@@
@@ABDP8;F"H3I@0O@@@@@@@@@AXSFQHEBP@@@@@@@@AC@P\B@C @@@@@@@@@@C4HA#X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[33 33 155 50 50 217 52 52 230 120 59 25 53 79 33 57 57 244 67 67 120 58 58 244 70 70 134 70 70 140 101 69 61 64 64 241 68 68 255 104 77 64 76 87 67 77 77 166 89 76 147 80 94 70 78 78 254 78 78 255 121 86 67 83 97 71 89 89 212 91 91 248 179 88 37 92 92 254 95 95 218 79 118 48 143 97 71 93 112 77 187 92 38 83 123 50 99 99 255 102 102 217 103 103 255 203 100 41 108 108 254 90 134 55 207 101 42 91 136 56 117 120 146 221 111 46 190 119 78 123 123 255 113 143 88 101 150 61 235 118 49 107 160 65 212 132 84 213 135 84 124 161 94 141 141 253 127 165 95 247 135 55 153 153 167 252 136 56 154 154 169 220 145 88 163 157 153 156 159 154 165 157 153 157 157 182 123 182 74 123 183 74 160 160 196 135 178 101 161 166 157 162 162 199 248 157 64 252 157 65 187 168 158 167 175 160 189 169 159 168 176 161 172 172 217 202 176 161 255 170 70 174 185 165 142 206 85 255 177 72 143 213 85 216 185 165 181 196 169 216 187 166 254 185 76 183 199 170 154 223 92 160 228 96 255 208 85 167 238 100 190 244 113 227 227 227 228 227 227 227 228 227 230 230 230 253 239 98 219 254 131]; mask:((ImageMask new) width: 13; height: 11; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O@A>G''8?_#=>O?0?>A?8@_ A>@C0@@a') ; yourself); yourself]
!

browserSpheresLimeAndOrange
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self browserSpheresLimeAndOrange inspect
     ImageEditor openOnClass:self andSelector:#browserSpheresLimeAndOrange
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class browserSpheresLimeAndOrange'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@6G!!$.@@@@@@@@@@@4JC,/D"(@NBT[L@@@FCIBM1XJMSD=NQT+@AL]JQ0NA!!(:P30WB0@,BA@L@BDTICL#C0\@@BXD@!!<@KP$QCPD"@@@@@@@@
@@@''APL @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[120 59 25 53 79 33 105 78 64 76 87 67 116 83 66 80 94 70 121 86 67 83 98 71 179 88 37 79 118 48 143 97 71 93 112 77 187 92 38 83 123 50 203 100 41 90 134 55 207 101 42 91 136 56 221 111 46 190 119 78 113 143 88 101 150 61 235 118 49 107 160 65 212 132 84 213 135 84 124 161 94 127 165 95 247 135 55 252 136 56 220 145 88 163 157 153 156 159 154 165 157 153 157 160 154 123 182 74 123 183 74 135 178 101 175 162 155 161 166 157 248 157 64 252 157 65 187 168 158 167 175 160 189 169 159 168 176 161 202 176 161 255 170 70 174 185 165 142 206 85 255 177 72 143 213 85 216 185 165 181 196 169 216 187 166 254 185 76 183 199 170 154 223 92 160 228 96 255 208 85 167 238 100 190 244 113 227 227 227 228 227 227 227 228 227 230 230 230 253 239 98 219 254 131]; mask:((ImageMask new) width: 13; height: 11; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O@A>G''8?_#=>O30?@A8@@@@@@@@@@@a') ; yourself); yourself]
!

browserSpheresOrange
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self browserSpheresOrange inspect
     ImageEditor openOnClass:self andSelector:#browserSpheresOrange
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class browserSpheresOrange'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@\D@4X@@@@@@@@@@@[EA8YBQX@@@@@@@@@CA("GP,E@@@@@@@@@@(OEP8G@0@@@@@@@@@WA@ F@AH@@@@@@@@@@ALB@QD@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[120 59 25 105 78 64 116 83 66 121 86 67 179 88 37 143 97 71 187 92 38 203 100 41 207 101 42 221 111 46 190 119 78 235 118 49 212 132 84 213 135 84 247 135 55 252 136 56 220 145 88 163 157 153 165 157 153 175 162 155 248 157 64 252 157 65 187 168 158 189 169 159 202 176 161 255 170 70 255 177 72 216 185 165 216 187 166 254 185 76 255 208 85 227 227 227 228 227 227 230 230 230 253 239 98]; mask:((ImageMask new) width: 13; height: 11; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O@A>@G8@_ A>@C0@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

checkout
"      Loaded from: /tmp/full/subversive/checkout.gif"

    "
     self checkout inspect
     ImageEditor openOnClass:self andSelector:#checkout
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class checkout'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
TUEQTUEQTUEQTUEQTUEQTUEQTUEQTUDFL3 +HR<FTUEQTUEQTUDZQTH@B@QNS1)QTUEQTUEQMS0"@@ DS$<2TUEQTUEQTR%@LA09Q0UFF5EQTUEQTUDYJ 8@
B@QNS1-QTUEQTUAPT@,N@D0,S$<JTUEQTQ\^BR9PA1TRN$9OB%EQTPLMST5PB00UHD-NS0)QTUDC@T5PFSXL@AHDS$=ITPHB@0EMTEAPA4D$GT9OC5DBE#\A
SP$IT@]CH3-NS0=QTPHV@T5JTBXPEADXAQMHTUEQ@04=TCP?DAPQF@TSG5EQTUDWIUEQA$P''O" -LUEQTUEQTUEQTUEQTUEQTUEQTP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[252 248 161 201 250 180 82 131 61 88 137 67 246 224 90 226 166 20 199 177 79 255 254 247 251 239 140 236 255 227 191 125 50 254 252 243 249 232 112 188 237 167 249 233 112 194 129 49 243 211 52 246 224 79 251 240 138 229 121 7 249 240 97 252 248 162 181 230 160 95 144 74 237 197 40 251 248 244 191 170 61 190 124 51 249 240 101 246 224 94 195 244 174 170 152 50 251 240 136 189 141 47 249 213 68 251 240 143 251 240 140 101 150 80 253 249 241 199 162 63 196 155 58 182 132 61 240 200 59 192 149 52 246 224 89 194 149 55 249 255 246 184 129 43 243 213 53 192 161 63 176 109 38 194 149 50 252 250 245 197 158 59 240 200 61 189 238 168 194 153 53 246 223 77 246 224 88 246 224 97 251 203 45 187 236 166 198 161 61 223 153 21 226 156 19 252 248 158 249 216 77 252 248 156 198 161 63 251 201 44 229 121 6 237 197 37 179 102 39 194 128 49 196 245 175 246 224 87 251 239 139 211 255 192 240 207 60 242 177 31 106 155 85 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@A?@O>@?8C? O>C?8_?#?>O?;??/?>_?8??!!''<@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:33:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

cleanup
"      Loaded from: /tmp/full/tortoise/cleanup.gif"

    "
     self cleanup inspect
     ImageEditor openOnClass:self andSelector:#cleanup
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class cleanup'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@0@@@@@@@@@@@@@@@@@GD@\C@@@@@@@@@@DA@P@GD@\FB @@@@@@@@DKB0,QD@\FB @@@@@@@@DHB@,K
B0HFB @@@@@@@PDHB@ HB0,KB @@@@@@@P HA@ HB@$IBP$IAP@@@P HA@,DB@ ICP4OC00@@@@AB@ DB0PHBP<OC0<L@@@@@@DHB@PKA@$MCP4MC@@@@@@@
@P HA@ IC0<OC00@@@@@@@@AB@ NBP4MCP4L@@@@@@@@@@DA@P$OC0<OC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 220 146 4 132 130 132 4 86 124 252 254 36 196 194 196 4 2 156 4 106 156 252 194 76 252 254 252 4 62 92 244 170 4 164 162 164 92 94 92 252 254 76 220 222 220 4 126 188 4 42 124]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@A @O@]<C? _<G? ??''?>O?8_? ?>A?8C? @@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

clear_co
"      Loaded from: /tmp/full/dlcl16/clear_co.gif"

    "
     self clear_co inspect
     ImageEditor openOnClass:self andSelector:#clear_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class clear_co'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@DA@PDA@P@B@ HB@ HB@ D@@ HB@ @A@ HB@ HB@ D@@ HB@ H@@PHB@ HB@ HA@@HB@ H@@P@B@ HB@ HA@@HB@ HB
@@D@@ HB@ HB@P@B@ HB@@D@@ HB@ HB@PHB@ HB@ @A@@HB@ HB@ DB@ HB@ HA@@HB@ HB@ DB@ HB@ H@@P@B@ HB@ HA@ HB@ HB@P@B@ HB@ HA@ HB
@ HB@@D@@ HB@ HB@PHB@ HB@ D@@ HB@ HB@ DB@ HB@@@A@@HB@ HB@ H@@PDA@PDA@@HA@PDA@PDA@ HB@ HB@ HB@ HB@ HB@ @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[191 191 191 159 159 159 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@G>@XXCA LNA 8FG@ \BA PNA@0HG@ XBG O=?@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

collapseall
"      Loaded from: /tmp/full/clcl16/collapseall.gif"

    "
     self collapseall inspect
     ImageEditor openOnClass:self andSelector:#collapseall
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class collapseall'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0DA@PDA@PDA@PDAB0,KB0,AA@PDA@PDA@PD@P,KB0,K@PP@@@@@@@@@@@@@@@,KB0DD@@PDA@PD
A@PDA@@KB0,AA@@DA XFA XFA X@B0,K@PP@A@\GA0\GA0\G@@,KB0DD@@PEAPTEAPTEAP@KB0,AA@@D@ HB@ HB@ T@B0,K@PP@A@ DA@PDA@PD@@,KB0DD
@@PC@0LC@0LC@0@KB0,A@P@DBP$IBP$IBP$@B0,KB0,@A@(JB (JB (J@@,KB0,K@@@@@@@@@@@@@@@KB0,KB0,KB0,KB0,KB0,KB0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[139 150 171 165 177 195 1 70 122 249 253 255 213 243 255 241 251 255 236 250 255 238 251 255 246 253 255 250 255 255 252 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C?8O? ??#?>O?8??#?>O?8??#?>O?8O? ?>@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

comments
"      Loaded from: /tmp/full/elcl16/comments.gif"

    "
     self comments inspect
     ImageEditor openOnClass:self andSelector:#comments
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class comments'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@ @@@@@@@ DA@PDA@PDA@PDB@@@@@@HA@ HB@ HB
@ DA@ @@@@@B@PDA@PDA@PDA@PH@@@@@@ DB@ HB@ HA@PDB@@@@@@HA@PDA@PDA@PDA@ @@@@@B@PDA@PDA@PDA@PH@@@@@@@HB@ HA@PHB@ H@@@@@@@@@
@@@@@ DB@@@@@@@@@@@@@@@@@@@B@ @@@@@@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 254 254 234 234 234 66 66 66]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G? ??C?<O?0??C?<O?0_>@G@@L@@P@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
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

commit_all
"      Loaded from: /tmp/full/elcl16/commit_all.gif"

    "
     self commit_all inspect
     ImageEditor openOnClass:self andSelector:#commit_all
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class commit_all'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
R4-KR4-KR4-KR4-KR4-KR4,:N#(:N#(:N$-KR4-KR4-KN"H"H"H"H#]KR4-KR4-KR3(@@0LC@0@7R4-KR4-KR4,2GBD!!GA0\N4,=OT-KR4-KL2@E@PPBHCEK
OR8=R4-KR3PTM#X6P$ICP4H.K$EKR4,5DB (JC@+J2,+J2,+O4-KKQ<)JR$/K2</K2</K3%@R2(SJB (NC0<OC0<OC0>R4,''FR0,KD]ERDYGOC1GR4-KIQ,M
A \GF2YKR#1DR4-KR2LRD!!HRFAH$R4%IR4-KR4,]E0 HB0 WDT-KR4-KR4-KEQ8ZG!!X^G =KR4-KR4-KR0(IC@8LBP$JR4-KR4-KR0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[247 248 252 187 193 214 186 192 213 191 196 215 187 193 213 186 193 213 166 177 205 166 177 204 160 173 202 137 148 173 136 148 173 160 174 202 137 149 173 166 179 204 136 149 173 139 148 165 239 243 250 130 137 148 227 235 248 234 240 250 242 245 250 143 153 168 222 232 247 225 234 248 227 235 247 231 238 248 222 233 248 229 237 248 245 248 252 146 155 166 222 233 247 236 242 248 243 247 251 245 248 251 248 250 252 151 158 162 117 122 125 155 159 159 108 112 111 160 163 156 162 190 109 148 169 90 165 167 153 252 250 217 242 240 209 170 169 150 254 253 238 251 242 183 251 245 197 148 142 108 186 179 139 183 177 142 179 174 145 176 172 146 247 242 210 182 174 136 251 236 170 251 237 174 189 180 139 167 159 124 251 228 151 189 132 22 176 118 18 184 126 20 180 122 19 187 129 21 186 129 21 187 130 22 168 109 16 172 113 17 171 114 17 172 113 18 171 113 18 166 107 16 168 109 17 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@A? G>@_8A?,G>8_?1??''??_?9??G>8_;A? G>@_8@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
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

compressedLayout
"      Loaded from: /tmp/full/elcl16/compressedLayout.gif"

    "
     self compressedLayout inspect
     ImageEditor openOnClass:self andSelector:#compressedLayout
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class compressedLayout'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
LSD1LSD1LSD1LSD1LSD1LSD1LQ<_G3D1LSD1LSD1LSD1LR40LC@-LSD1LSD1LSD1LQ8@@@ YGBH^HBH1LSD1LSD#@PDA@ HB@ HAHSD1LSD1I@TFB0\_G1<M
CR 1LSD1LR\JDP8-LC@0KQ,/LSD1LSD&C1(^@@@HFQ0"G"@"LSD1J1H]H0DA@PDA@PDA@RD1LR(WIRPEA TDAPPCA@P(LSD1KB8''B 0IBP0IB 0LI3D1LSD1
I <OC0<PC1@ODBX1LSD1LR,REQLUEAPSEAP)LSD1LSD*E1XWE!! VE!!XVJ#D1LSD1LR0,KB0,KB0,KCD1LSD1LSD1LSD1LSD1LSD1LP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[248 224 124 255 241 183 255 227 130 255 234 169 255 235 169 255 234 170 255 235 170 255 217 110 242 210 114 255 227 149 255 227 150 255 214 112 255 225 149 255 199 72 255 201 85 255 215 126 255 215 127 255 199 85 255 204 105 255 206 105 255 204 106 255 206 106 255 196 88 255 196 90 255 197 90 215 169 86 255 181 62 255 174 51 201 149 74 255 165 46 192 144 82 194 146 84 192 143 82 189 140 81 192 144 83 188 140 81 183 136 79 255 149 34 174 126 73 179 131 76 185 136 79 170 121 70 165 118 68 170 121 71 159 112 66 165 104 49 98 50 21 86 37 11 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@\@C8@_>A?<G?0_?A??G?>_?8?? ?>C?8O? _<@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

confauto_ov
"      Loaded from: /tmp/full/ovr16/confauto_ov.gif"

    "
     self confauto_ov inspect
     ImageEditor openOnClass:self andSelector:#confauto_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class confauto_ov'
        ifAbsentPut:[(Depth8Image new) width: 11; height: 9; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GA0\F1,\F1,\GA0\GA,UEQ,FA!!,\GA0[EQHUF0XJA!!,\F1XRDAX@A00JA1,WD!!DQC08MB0,JBA,XD1LX@PLIBPL[GA,YEA$[A@HDF10\GA,ZF!!,EAQ,\GA0\
GA,[GA,[GA0\@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[158 61 63 138 41 63 4 114 48 0 66 23 0 57 20 0 43 14 0 105 32 0 99 31 0 90 28 16 131 52 28 157 56 127 204 61 141 220 65 151 180 55 195 186 33 214 186 33 231 193 21 225 186 31 219 121 9 213 98 6 208 80 2 202 72 0 197 67 0 190 57 0 169 41 0 155 33 0 122 11 0 255 255 255 255 255 255]; mask:((ImageMask new) width: 11; height: 9; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'F0@? G?@?>C?8O? _<@? A,@') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

conflict
"      Loaded from: /tmp/full/tortoise/conflict.gif"

    "
     self conflict inspect
     ImageEditor openOnClass:self andSelector:#conflict
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class conflict'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B1@@D@,@@@@@@@@@@@@@FQXICQXVFP@@@@@@@@@@B1XIBP$VE XK@@@@@@@@@A@ICP OEA$F
D@@@@@@@@@@@E0 [BAXIA @@@@@@@@@@@@ [F1,HE0XP@@@@@@@@@ATHF0 [BAXCC0@@@@@@@@@GFQ,HF1,CD HX@@@@@@@@A00OD@@PC0(AAPH@@@@@A00L
C@\LC@0D@ 8E@ @@@@\LC@0LC@0LA1TBC!!DB@@@@A0\GA0\GA0@@EPHNDQ @@@@@@@@@@@@@@@@U@!!LX@@@@@@@@@@@@@@@@@@@BA@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 220 146 4 124 86 4 148 146 148 68 70 68 252 218 148 148 218 252 252 2 4 252 74 76 252 250 252 60 42 4 108 110 108 252 254 4 220 222 220 188 126 4 92 94 92 60 58 60 252 206 108 28 30 28 156 106 4 196 194 196 84 82 84 180 230 252 252 254 252 92 62 4 124 122 124 236 234 236 252 254 108]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@6@G<@?8C? G<@_8C? O?@=>G?<_?8?''0@O@@Lb') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

conflicted_ov
"      Loaded from: /tmp/full/ovr16/conflicted_ov.gif"

    "
     self conflicted_ov inspect
     ImageEditor openOnClass:self andSelector:#conflicted_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class conflicted_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'DQDQDQDQDP@@DA@P@@@@@@PDBP@@D@LOC0<CDA@GC 4MBA@P@ (LB0XP@@@A@PT@@@@@DA@P@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[48 72 126 69 99 152 71 101 153 76 106 158 78 108 160 69 99 150 71 102 154 73 104 157 73 104 155 78 109 160 164 184 213 163 184 213 163 184 212 199 213 230 199 213 229 226 235 244 255 255 255 255 255 255]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O;>?/;>?/8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

console_view
"      Loaded from: /tmp/full/cview16/console_view.gif"

    "
     self console_view inspect
     ImageEditor openOnClass:self andSelector:#console_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class console_view'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
]A<KB0,KB0,KB0,KB1=4]GPLA0\GA0\GA0\GA0\L]GQ4CP .K"8.K"8.K"8HCWQ4]@8TK"4*@B(+K"8.B@54]GPOBR8FA@LAK41!!W%5&SGQ4E!!T.JB ,JD][
R#L:QE!!G]A@]K XFAPE_T$44N$QX\WPQHB8$I2\BZ6IBM$!!P[GA4E2T.JQ8#B&!!NOSH8P5%/]AH&I"H&I"E''S342NTQX[''P\FQ$XFQ$YZUL;LS1EVF54]GQ4
]A0SD6)TM3@>RU!!-]GP\F!!,ZF1-*YT@5PUY2\7Q4]GQ4]GQ4UVP?MTEW\$Y4]GQ4]GQ4]GQKWE) X5E4]GQ4]GQ4]GQ4]GQ4]GQ4]@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[244 245 249 36 52 102 221 225 238 46 64 117 56 78 134 58 80 136 64 88 145 49 62 93 51 65 96 58 72 103 218 224 238 21 72 173 21 71 170 21 69 165 21 68 159 21 66 153 21 61 141 21 59 134 22 55 120 22 52 111 53 68 98 62 77 107 21 64 146 21 58 127 21 54 115 22 54 115 22 52 107 22 51 106 38 76 143 67 83 113 213 224 245 53 88 145 71 88 117 80 97 125 80 97 124 213 225 244 218 228 245 75 93 120 79 97 125 217 228 245 231 238 248 211 225 244 242 245 249 242 246 251 229 238 248 242 246 249 188 229 249 209 205 122 252 248 158 252 248 159 252 248 161 252 248 163 252 248 164 249 239 97 249 238 99 250 237 122 249 234 116 249 234 119 249 234 121 250 236 124 249 234 123 250 236 125 249 234 127 245 218 63 245 219 63 243 215 63 245 221 66 242 216 71 242 216 72 242 216 74 167 143 20 190 163 33 243 214 60 242 216 76 250 224 97 198 169 50 198 171 53 250 221 90 241 202 66 241 202 67 230 182 25 190 154 34 250 201 46 241 202 69 240 200 70 203 170 59 229 177 25 230 178 26 241 186 38 241 186 39 198 155 34 250 198 43 197 154 34 190 140 21 192 145 23 196 150 30 196 151 32 192 139 20 228 163 25 194 143 27 226 160 25 225 159 26 182 117 11 184 123 31 184 124 31 184 123 32 184 123 33 179 121 33 227 134 9 193 117 18 193 116 19 192 114 20 188 112 20 173 95 6 229 121 7 177 88 7 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_?1??G?<_?1??''??_?=??7??_?=??0_?O?<@?0A>@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

contents
"      Loaded from: /tmp/full/dtool16/contents.gif"

    "
     self contents inspect
     ImageEditor openOnClass:self andSelector:#contents
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class contents'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@A@PDA@P@@@@@@@@@@@@@A@@@@@@@A@@@@@@@@@@@@@P@@@@@@@P@@@@@@@@@@@@D@@@@@@@D@@@@@@@@@@@@A@@@@@@DA@PDA@PD@@@@@@P@@@@@A@@@@
@@@A@P@@@@D@@@@@@P@@@@@@@P@A@@@A@@@@@@D@@PDA@@DA@PD@@P@@@@@A@@@@@@@@@@@A@@@A@PDA@P@A@PDA@P@@@P@@@@@@@@D@@@@@@@@@@@D@@@@@
@@@A@@DA@PDA@@@A@@@@@@@@@P@@@@@@@@@@@P@@@@@@@@D@@@@@@@@@@@D@@@@@@@@A@@@@@@@@@@@A@@@@@@@@@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[192 192 192 159 159 159]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O AA@DD@PPAC>DHLP )B;4HAO/$B@PK9@ DB@PHA@?<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

copy
"      Loaded from: /tmp/full/subversive/copy.gif"

    "
     self copy inspect
     ImageEditor openOnClass:self andSelector:#copy
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class copy'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
Q4]GQ4]GQ4]GQ4]GQ4]GQ4\8NC 8NC 8NC!!GQ4]GQ4]GN@TEAS 8NC 8NC 8Q4]GQ3$&@PX8APTEAPTEQC!!GQ4\:IQPQLBXAA"XA@TUFLD]GL P[ICD%EADJ
A2EBQTL;Q3<#E@<=AA,$F0@[F1,[OD\4F!!(CO"LTC1HMC@$BDC9GMR@TC3LZF LZF!!(ZF!!(4Q20"FQ%@HAPOD 4LBPH MT\-FAPOM"HYFQ$YFQ$"FTEGK!!<_
G3\XE@<RCP0I@!! -Q2$]EAL+G1<_G1<_G1<_K$\*GA0VJQ4TD08KBA\^ER=GJB (JB(\GAX\E!!0VE!!0''Q4]GQ4\(JB (JB (JB (J@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[243 245 251 248 249 252 99 122 167 238 242 250 242 245 251 249 250 252 248 249 251 94 118 163 102 126 168 106 130 172 109 132 173 113 136 177 115 137 178 124 146 184 126 147 186 140 160 195 240 244 251 129 151 188 132 154 191 137 158 193 145 165 199 222 232 248 221 231 247 223 232 247 228 236 249 231 238 249 237 242 250 243 246 251 220 231 247 223 233 248 222 232 247 225 234 248 234 240 249 246 248 251 230 238 249 240 245 251 242 246 251 245 248 251 247 249 251 154 154 144 152 152 145 157 156 141 154 153 144 161 158 138 170 164 132 166 161 135 162 158 138 158 155 141 196 180 115 193 178 117 189 175 119 180 170 125 181 170 126 176 167 129 170 163 133 166 160 135 199 181 113 196 179 115 194 178 116 193 177 117 190 175 119 190 175 120 185 172 122 186 173 123 176 166 129 171 163 132 224 200 143 212 178 104 212 178 105 218 189 124 213 178 105 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@A?0G?8_?1??''??_?=??7??_?=??7??_?=??7??A?<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

copy_edit
"      Loaded from: /tmp/full/dtool16/copy_edit.gif"

    "
     self copy_edit inspect
     ImageEditor openOnClass:self andSelector:#copy_edit
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class copy_edit'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@PDA@PDA@PDA@PD@@@@@@@@@@PDA@PDA@PDA@@DA@PDA@@@A@PDA@PDA@P@A@PDA@@@@@@@@@@DA@PD@@P@@@@@A@PDA@P@@@PDA@@DA@PD@@PDA
@PD@@P@A@P@A@@@@@@D@@@@A@@@@@@D@@PDA@P@A@PDA@PDA@P@A@@D@@@@@@P@@@@@@@PD@@P@A@PDA@@DA@PDA@PDA@@D@@P@@@@@A@@@@@@@A@P@A@@DA
@PD@@PDA@PDA@PD@@P@A@PDA@@D@@@@@@@DA@@D@@@@@@@@A@PDA@PDA@P@A@PDA@PD@@PDA@PDA@PD@@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[159 159 159 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@A?@DF@P?!!^CDHJW.=B@U;9P E^>THAP/%>@PHA@?<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

createpatch_wizban
"      Loaded from: /tmp/full/wizban/createpatch_wizban.gif"

    "
     self createpatch_wizban inspect
     ImageEditor openOnClass:self andSelector:#createpatch_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class createpatch_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HEWR''4C@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@J05#74C@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HD5 A$T@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@ALA8AJ_SD1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BA
SAV@ A$6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?IS<@@@@@@@@@@@@@@@@@@E\U HAJ_SX6W#D1@0LC@0LC
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D:8?\WE1N;,@@@@@@C=D(GD@@@@@@@@@@@@@@@C]A8B@ A$TECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@AL;G\UC:>/+^HQ1.0@@O4RF:''D@@@@@@@@@@@@@+@^@ HB@FQPTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.<]OV$UE
V%+?!!([_GZ8?QHXF:''D@@@@@@@@@@HD5EQV@ HB/D!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B;!!@!!E:4MTUEQTGJ%_P$QD!!(XFL7D@
@@@@@@@@S@\UEQV@ B,RD!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AL]BE)C]'' /K2<7(*H"P$JF!!"HF.WD@@@@@@HE"A1TUEQV@J74R
D!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GE6V''YO1\T&I"X&I-R"($I_H"HF.WD@@@@@S@\GA1TUEX@+_W4RD!!PTECX6W#D1@0LC@0LC
@@@@@@@@@@@@@@@@@@@@@@@@@@@@I8QZ],WE!!A6>/"T][6?T("H"H!!0F.WD@@K\5A0\GA1TU B,+_W4RD!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@
@@@@@@@@,$MC1TRDN2\@2Z91/"[T("H\GL4FL7D@+FHGA0\GA1V@+2,+_W4RD!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@/ !!OQH3I@@@@
@@@?QDI_H!!0\3\4FL7ELA0\GA0\GA8B/J2,+_W4RD!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@''GWYD11L@@@@@@C=DP%<"H!!3M3Z@FL7DG
A0\GA0\G J>/J2,+_W4RD!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@''!!G ]+ @@@@@@O4S?*]Q:.#][V;H3L7DGA0\GA0\U+:>/J2,+_W4R
D!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@''GT<]@@@@@@B.G^-[[6=:^++-V;IC;GDGA0\GA0\Y+:>/J2,+_W4RD!!PTECX6W#D1@0LC@0LC
@@@@@@@@@@@@@@@@@@@@@@@@@@@SG\U1@@@@@@C;GRT%IRT%IQ4]GXRD!!C<GA0\GA8<Y+:>/J2,+_W4RD!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@
@@@@@@@@+!!4;@@@@@@@@I2\''I2\''I2\''I2\''I6HGA0\GR!!$Y+:>/J2,+_W4RD!!PTECX6W#D1@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@-5]"X&I"X&HGA0^@FQ$Y+:>/J2,+_W4RD!!PTECX6W#D1@0LC@0LC@@C@]GQ4]GQ4]GQ4Y6]''Y6]''Y6]''Y3700L @@@@@@@@@@@A<OWQ4]GQ4]GQ4
Y6]''Y6]''Y6]''Y6\=XI,RD!!PTECX6W#D1@0LCRV9.@@C@MCP4"H"HO#9VU%X!!PTD2"X&IHBB^''#7$@@@@@@@@@HD0&#P4MH"H+S9VU%X!! 4D2L(&IHB@$''#6X
D!!PTECX6LT%.F!! B@ HB@@CSMCRH"J4>O%YVU(MAL#JI"X$ HBA C.8$_@@@@@@@ U\0 #RH"H >O%YVU"EAPSJI"X$ HBA]C 8$&APT94$ZFA B@ HB@ HB
@@CSMH"H+S9VU%X!! 4D2L(&IHB@ KB0,_/@NO\ @@@BAU5\0 ("H+S8>U%YV 4D2L(&I"R@ HB0,OVN^II ZF!!)MFA B@ HB@ HB@@CS"H >O%YVU"EAPSJI
"X$ HB@,KDA@O_NV''''P@@HEWU5\0 ("-O%YVU"FCPSH2"X$ HB@,KDA@JOF8C"RGF!!)MFA B@ HB@ HB@@CS+S8>U%YV 4D2L(&I"R@ HB0,PDA?XH71(1X(
 U]WU5^<0#8>U%YVHTEAL(&I"R@ HB0,PDA?W\*8X9;VF!!)MFA B@ HB@ HB@@@(O%YVU"FCPSH2"X$ HB@,KDA@_7=K&'';J_ ;<D5]WU5^<0#9VU%ZCPSH2
"X&IHB@ KB1@PG=K>P?J2 8V0!!)MFA B@ HB@ HB@@@(U%YVAW%Q#(:NT\RNTV%)1N&KDW=K&''@OC08N7E]WU5^<F5YVHXMAL#JI"R@4Q3 8ND]G[V5->''@O
C:LNH5YMFA B@ HB@ HB@@@(U%X!!=S1)TUEQTV%)^S1NZPUHDT-K?WM3\G@NE#AWU5^<F5X!!PTD2"X&IHBBKQ3 8NC 8Q4\8=GM3\G@N;!!-MFA B@ HB@ HB
@@BZHXMAL#JI"R@ HL0,PDA?_4-K&Y&&IGM0C?0V;(IWU5_WF8MAL#JI"X$ HB@,KDA@_4-K&Y$I5WM3\@?<C"MMFA B@ HB@ HB@@BZPTD2PTD2L(&IHB@ 
3B0,PDC2&P&[\H7BJ,/CWM)WU5_WF4D2L(&IHB@ 3B0,KDA@_:YKR9&%)@?>CB''CWNMMFA B@ HB@ HB@@BZPSH2TZ)NOC0<S$97*)BPS/UHDY&4-GJS$,8)
2>IWU5_WF3H2"X$ HB@,KD@-=T[R4$YF=_W5?&5!!%OSQ2:!!MFA B@ HB@ HB@@CBL(&I">''):^%GQ4]GQ4]G0VG9< %2A@PD)^#N4^IWU5_WCH&I"R@ HB0,
PD@Q''I2\''I1XVE!!X>QG2)X](4Z!!MFA B@ HB@ HB@@CB"X$ HB@,KDA@_7=KR9$IBS(:\''HDA@PDDINR3)EWU5]]CH$ HBCLKDA@%7=KR9&YBP$:\''HDA@PD
DJW(ZJ!!MFA B@ HB@ HB@@CB"R@ MN%GQ65-[\GA0V5-RI0Q&WHDAA@PDAB6$)EWU5]]CMHKB0,KB0,J_7?)TUFNQ$YFQ$YF=PVK3GJS$(UMFA B@ HB@ HB
@@CBHB@ #*)NOC0<S-97*)BPS/UHKGHDDA@PEQU2T)EWU6I]CKM$YFQ$YFSPR4A%VU%YVU%YVU%YVVU9[ZTD-(UMFA B@ HB@ HB@@@[HB0,DQDQHL0,KDC2
_:ZW<*XI\ PPDA@UEUTU-IEWA4*RCFD<-[V5-[WD&Y''LDQDQD\3L8^G23AG2\!!AU\(UMFA B@ HB@ HB@@@[KB1@PG=KR9&YBP$:N''I2A@PDDA@P ATUUY4A
AHV@R$*R]R1@PG=?R4.YBP$:N''I2A@PDAA@PDATUUV(AEXUMFA B@ HB@ HB@@@[PDA@AW%Q#(:NTW$<=Y0:A@PPDA@UEUU*@PDAUXV@R(>R]TA@_:YK&Y$I
BS*\># 8NO+:>&F%DAUU''PDA@XUMFA B@ HB@ HB@@@LPG=?Q5F?/;>?/89)=Y0:AA@PDATUUV(A@PDA@Q^@R!!&R]Y]?R4.Y&P$IN#+90V5-[V7A0VF%EV(A
@PDA@XUMFA B@ HB@ HB@@@L_:YK&Y$IBS(:\''HDA@PPDAB@EQUU''PDA@PDA@Q^@FQ&R]W=KR9&YBS(:\''HDA@PDDA@PEQUUZ DA@PDA@Q]MFA B@ HB@ HB
@@@LR4.Y&P$IN''I2\ PDAA@PDATUUV(A@PDA@PDA@Q],FQ%+]T.Y&P$IN#)2\ SLXVE!!XVE!!''I2\VL0IAATA@Q]MFA B@ HB@ HB@@@LR9&YBS(:\''HDA@PD
DA@PEQUUZ DA@PDA@PDA@VZOFQ%+JY&YBP*''N''I2A@Q!!A__7=?_7APTENB79BQ@A@VYMFA B@ HB@ HB@@A5&P$IN#)2\ PDAA@PDH@UEUV]@PDA@PDA@PDA
@VZOFQ%+JY$IN -$PPPDA@PPDA@PEQUUUUUUUUUUUPDA@VYMFA B@ HB@ HB@@A5BP$:VB5HRD!!H"8.K"8.KXQF%AETA@PDA@PDA@VZOFQ%+JP$:N -$KPPD
DA@P ATUUY4A@PDA@PDA@PDA@VYMFA B@ HB@ HB@@A5N#(I1J)NOC0<S-97*)BPS/^T)Q@A@PDA@PDA@U2OFQ%+JZ]$YFQ$YFR3D@P<"(*J"(*J"(*J"$;7
VGJ]@U1MFA B@ HB@ HB@@A5N''I2BP$IBS(:\#(I\''I2\''HPEV(A@PDA@PDA@U2OFQ''4JZ]$YFQ$YFSPD@Q7YVU%YVU%YVU%YZ*NR@%*@U1MFA B@ HB@ HB
@@@)\''HDA@PPDA@UEUU*@PDA@PDA@PDA@PDA@PDA@S&OFQ''4CWI?KP-$>B4-EQUU''PDA@PDA@PDA@PDA@PDA@U1MFA B@ HB@ HB@@@)A@PDRO\ENC 8NC 8
APTE[Y3!!\!!TA@PDA@PDA@S&OFQ''4CPPDA@-$KQTUUV(A@PDA@PDA@PDA@PDA@PDA@S%MFA B@ HB@ HB@@@)A@PD=T99ZV%)^S0<S$97^PU!!)Q@A@PDA@PDA
@S&OFQ$JCPPDDF/PKQUUZ)5XNC 8NC 8Q8.%EPDA@PDA@S%MFA B@ HB@ HB@@@)AA@PDH@UEUUUUUUUUUUUUUUUUPDA@PDA@PDA@Y<:N#(JCQ@PDH@UEUV]
@PF=%H.K"8.K%O$:UPDA@PDA@Y<.K"8.K"8.K"8.@@@MDA@PEQUUZ DA@PDA@PDA@PDA@PDA@PDA@PDA@^[!!/[6''CQ@PEQUUZ DA@PDA@PDA@PDA@PDA@PDA
@PDA@Y=!!*:,4MCP4MCR+@@@MDH@P[UF?Q$YF/89QAQDP@PDA@PDA@PDA@PDA@^VG!!8\*CQ@UEUU*@PDA@PDA@PDA@PDA@PDA@PDA@PDA@^X^G!!8^G!!8^G$ 4
@@@MEQTUQ6&N/;>?#&%9=U P@PDA@PDA@PDA@PDA@YW/;><*G1TUUY4A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@^YST5MST?[/G$"+@@@MEUU*@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@P-;T><*G5U*@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@^U(ZF!!;^?X^RJ,.@@@_UY4A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@P-;=. *G6(A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@YWF1&!!;=!!:+K HB@@@_@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P//%E *G0DA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@PDA@YWFZEL^"28B@ HB7[S G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G>WO3<<*%Q<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_
G1<_G=-S;4"+K HB@ HB6GJ[6]''Y6]''YT%IRT%IRT%IRT%IRT%JG!!8^G!!8_Y/ZVYR:[23L3L3ADQDQDQDQDQL#H2HRD!!HRD!!HZF!!(ZF!!(ZF!!K HB@ HB@ HB
@@@@-8F,+J2,SD1LTE]WU;F0X&I"A0\UEXB@ D)J#8>OFQ$Y+:<+J74RD!!PTECY^LPLC9>]IRT%IRV9.[!!(ZF!!)MFA B@ HB@ HB@@@@ XF,+J2,SD1LTE]W
U;F0X&I"A0\UEXB@ D)J#8>OFQ$Y+:<+J74RD!!PTECY^LPLC9>]IRT%IRV9.[!!(ZF!!)MFA B@ HB@ HB@@B7 Z2,+J2,SD1LTE]WU;F0X&I"Z \UEXB@ D)J
#8>OFQ$Y+:<+J74RD!!PTECY^LPLC9>]IRT%IRV9.[!!(ZF!!)MFA B@ HB@ HB@@BA Z2,+J2,SD1LTE]WU;F0X&I"A0\UEXB@ D)J#8>OFQ$Y+:<+J74RD!!PT
ECY^LPLC9>]IRT%IRV9.[!!(ZF!!)MFA B@ HB@ HB@HFA Z2,+J2,SD1LTE]WU;F0X&I"A0\UEXB@ D)J#8>OFQ$Y+:<+J74RD!!PTECY^LPLC9>]IRT%IRV9.
[!!(ZF!!)MFA B@ HB@ HB@HFA Z2,+J2,SD1LTE]WU;F0X&I*A0\UEXB@ D)J#8>OFQ$Y+:<+J74RD!!PTECY^LPLC9>]IRT%IRV9.[!!(ZF!!)MFA B@ HB@ HB
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 249 250 252 222 230 248 232 238 250 242 245 249 204 212 226 175 226 176 247 249 253 142 200 111 237 241 247 202 213 218 102 134 138 199 199 187 167 183 181 230 167 91 243 180 106 244 246 250 229 233 242 236 241 251 243 245 242 235 240 250 246 248 251 218 170 110 168 171 154 223 231 248 240 244 252 225 232 248 209 203 189 116 184 123 67 136 45 216 219 231 155 176 178 228 235 244 224 230 241 107 181 123 208 179 137 228 186 135 60 132 43 71 150 72 204 222 199 231 217 196 179 187 184 186 195 201 238 242 251 230 236 244 213 221 235 221 228 244 92 167 84 243 236 226 233 238 250 226 232 243 158 211 151 217 225 238 249 250 254 234 239 250 93 167 98 207 214 227 136 154 148 238 242 248 150 187 136 181 193 211 234 199 154 220 228 240 132 175 115 232 237 245 224 231 242 145 223 168 127 188 101 77 148 57 178 233 150 197 206 221 209 216 229 217 222 234 229 236 249 243 246 252 234 239 246 251 252 254 224 231 248 177 189 209 100 168 74 250 252 254 190 200 217 229 229 234 212 211 222 107 180 102 248 249 251 222 229 241 249 251 254 225 230 238 122 142 175 163 220 137 104 171 101 148 158 152 229 227 223 233 239 250 153 225 173 234 209 180 221 226 236 248 250 253 239 187 122 59 101 104 149 165 193 157 165 152 232 204 166 206 203 212 187 198 216 248 249 252 211 218 219 242 246 252 212 219 231 227 234 249 60 142 76 246 177 98 107 159 87 240 243 248 248 173 93 230 203 166 188 193 185 117 183 91 173 185 206 107 176 88 185 195 214 74 152 88 210 206 218 250 242 230 237 241 251 241 186 116 233 238 246 245 247 253 254 254 255 220 208 188 223 231 242 73 141 48 175 172 151 163 227 172 226 227 234 218 227 240 227 233 243 157 171 197 218 224 234 94 151 73 245 201 153 192 201 218 241 245 252 165 178 203 183 178 156 218 220 221 234 237 241 221 225 234 111 139 140 241 197 140 232 238 245 232 222 211 235 240 246 224 212 193 236 234 236 223 228 237 248 250 252 225 168 100 128 149 145 135 196 132 222 228 241 93 174 113 237 178 104 241 188 141 236 239 245 234 238 245 194 207 211 174 164 138 136 213 149 168 181 204 220 226 240 253 253 255 219 228 240 180 207 171 239 243 251 249 250 253 249 251 253 119 172 103 188 203 210 239 238 240 162 182 199 232 233 236 254 255 255 247 211 163 164 211 153 86 160 91 218 231 213 239 233 224 232 235 242 57 127 32 195 204 220 245 225 198 213 220 231 216 208 192 164 166 169 191 202 221 86 159 64 204 197 209 82 143 59 254 251 248 230 239 227 244 192 127 174 176 179 231 235 243 128 188 128 201 203 206 228 230 237 168 186 201 188 190 193 197 206 218 239 222 197 80 162 101 229 205 184 217 193 158 234 230 223 251 251 252 231 230 235 207 192 163 84 120 123 217 197 165 252 252 253 174 186 207 124 198 128 143 162 167 233 236 244 198 187 160 182 164 131 252 247 241 115 143 145 122 146 144 231 237 250 221 222 228 206 215 229 146 208 147 145 208 126 151 205 137 96 163 94 218 163 97 217 217 226 239 192 132 247 207 154 233 237 244 250 220 179 207 213 217 199 208 223 214 214 225 201 209 224 205 215 234 227 231 239 210 216 228 168 199 157 221 177 119 231 198 167 223 198 178 161 226 155]; yourself]

    "Modified: / 11-04-2008 / 11:32:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

createrepos
"      Loaded from: /tmp/full/tortoise/createrepos.gif"

    "
     self createrepos inspect
     ImageEditor openOnClass:self andSelector:#createrepos
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class createrepos'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@HR<@@@@@@@@@@@@@@@@0HS@Y@$\@@@@@@AH_G1<VLC@0@P M@@@@@B%CAQ8WJBXKPC4&I0@@@@@UP1 ^E1\/AAEBABD@@@@@GCD NCPC
D0 3J  2@@@@@A0IA18WEDP$O!!$MM0@@@@@\BS(^E3<IICX7@@@@@@@@G@$GH!!\TF2P<@@@@@@@@@B0#A18WO1,$O@@@@@@@@@@\IP<^E1P[IC0@@@@@@@@@
Q $GH!!\TF2PJ@@@@@@@@@DX%A2HWN!!,$O@@@@@@@@@@\LR@8MBL5GP0@@@@@@@@@NSD NCP#MQ4P@@@@@@@@@@@RN3,;KQ<;@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 252 134 36 244 166 140 236 198 36 252 130 68 252 218 76 228 158 20 252 234 116 252 66 12 244 202 60 196 130 52 252 110 4 180 102 36 236 210 188 252 138 60 252 234 108 172 154 52 252 210 44 196 178 76 252 190 140 244 226 92 196 158 60 204 118 36 252 238 140 252 214 68 244 142 108 244 226 76 244 206 60 180 130 60 228 122 4 252 250 164 196 150 52 244 210 52 244 190 164 252 250 156 236 198 44 244 178 28 236 198 68 252 98 28 252 98 52 252 186 100 188 170 60 244 118 52 252 242 140 180 134 60 196 154 60 244 214 52 252 198 164 252 62 4 220 154 20 244 178 148 252 130 76 244 222 76 228 166 20 212 106 36 236 222 204 252 242 100 204 178 84 244 226 100 196 162 60 188 126 52 252 234 148 252 154 108 244 226 84 252 246 196 196 154 52 252 210 52 252 202 44 244 202 68 252 106 28 188 134 60 244 202 180]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@0@O0_?C?<O?0??C?<O?@?8C? O>@?8C? O>@?8A?@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

cut_edit
"      Loaded from: /tmp/full/dtool16/cut_edit.gif"

    "
     self cut_edit inspect
     ImageEditor openOnClass:self andSelector:#cut_edit
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class cut_edit'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H@@PHB@ HB@ HB@ HB@ HB@P@B@ HB@ HB@ HB@ HB@@DB@ HB@ HB@ HB@ HB@ D@@ HB@@DB@ HB@ HB@ @A
@ H@@PD@@ HB@ HB@ @A@@@A@P@B@ @A@PD@@ @A@PDA@@HB@ HA@ HB@PDA@ D@@ HB@ HB@PHB@ D@@@D@@ HB@ HB@ DB@ HA@ @A@ HB@ HB@ H@@PDA
@@DA@PD@@ HB@ HB@ HB@ HA@ HB@PHB@ HB@ HB@ HB@PHB@ DB@ HB@ HB@ HB@ DB@ HA@ HB@ HB@ HB@ H@@PDA@@HB@ HB@ @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[191 191 191 159 159 159 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@L@@0@F@@X0CO@_3;<H;@#8BK@O?@AD@DP@Q@A<@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

delete
"      Loaded from: /tmp/full/tortoise/delete.gif"

    "
     self delete inspect
     ImageEditor openOnClass:self andSelector:#delete
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class delete'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P\A@@@@@@@@@@@@@@@@@@\CA0D@@@@AA0@@@@@@@@@@A0LG@P@A
A0X@@@@@@@@@@@@G@0\GA0P@@@@@@@@@@@@@@@\CA0H@@@@@@@@@@@@@@@\CA0LGB@@@@@@@@@@@@@\CA0 G@0\H@@@@@@@@@@\CA0 @@@\CA0 @@@@@@@@A
A0D@@@@@A0LE@@@@@@@@@@@@@@@@@@@H@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 252 110 108 252 158 108 132 2 4 252 182 148 252 74 76 252 146 148 252 2 4 252 182 180]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G@@^L@=0A>@C0@_ C?@^^A08@A @@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

deleted_ov
"      Loaded from: /tmp/full/ovr16/deleted_ov.gif"

    "
     self deleted_ov inspect
     ImageEditor openOnClass:self andSelector:#deleted_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class deleted_ov'
        ifAbsentPut:[(Depth8Image new) width: 8; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@P@A@PDA@@D@@@@A@P@@@@D@@@@@@@@A@PD@@@@@@PDA@P@@@@@A@PD@@@@@@@@A@@@@@PD@@@@A@@DA@PD@@P@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[132 2 4 255 255 255]; mask:((ImageMask new) width: 8; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'P.]>OC1>94Hb') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
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

edit24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self edit24x24 inspect
     ImageEditor openOnClass:self andSelector:#edit24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class edit24x24'
        ifAbsentPut:[(Depth32Image new) width: 25; height: 24; photometric:(#rgb); bitsPerSample:(#(8 8 8 8)); samplesPerPixel:(4); bits:(ByteArray fromPackedString:'
????@O???0C???<@+*:.&=/[6>;]7]7/7-;^;=7]7^?\7M3/6=/[;=''Y6^?X6M#/5=_W;=WU5^?T5MS/4=OS;=GQ4^?P4MC/3<?O;<7M3^?L3L3/2,+J;9BP
$K????<@????@O???0C???<@????@LGA0][):^''?8NC ?>S$9O?"8.K?8>O#?>O#8??$9NS?9^W%?>W%9_?%9^W?9.[&?>[&9/?%9^W?9^W%?>W%9_?%9^W?
9^W%?>''):_>;.;/(????@O???0C???<@????@O???0C@0LCV:^'')?=?_7??#8>O?8^G!!?>K"8/?#8>O?8>O#?>S$9O?$9NS?9^W%?>W%9_?%9^W?9^W%?>W%
9_?%9^W?9^W%?>W%9_?(:N#?.;.;:O???0C???<@????@O???0C???<@/+:>5.''):_? 8NC?9NS$?>K"8/?]7]7?3\7M?<7M3_?N3,;?3,;N?<?O3??O3<??
3<?O?<?O3??O3<??3<?O?=#X6O?&9.[?:^'')?;.;.>#???<@????@O???0C???<@????@K6=/][):^''?8^G!!?>W%9_?#8>O?7]7]?<?O3??O3<??3<?O?=CP
4O?P4MC?4MCP?=GQ4_?Q4]G?4]GQ?=GQ4_?Y6]''?:N#(?>+*:/>;.;/(????@O???0C???<@????@O???0B</K3V:.+*?>K"8/?&9.[?9NS$?=;^7/?O3<??
3<?O?<?O3??P4MC?4MCP?=GQ4_?Q4]G?4]GQ?=GQ4_?Q4]G?6]''Y?>''):_?,;N3?.;.;:O???0C???<@????@O???0C???<@.+*:5./+:??#8>O?9>_''?>W%
9_?_7=??4MCP?=GQ4_?Q4]G?4]GQ?=KR4/?R4-K?4-KR?=OS4??S4=O?4=OS?=/[6??*:.+?;^7-?;.;.>#???<@????@O???0C???<@????@K"8.M[+:>/?
8.K"?>#(:O?&9.[?8^G!!?=ST5O?U5]W?5]WU?=WU5_?V5-[?5-[V?=_W5??W5=_?5=_W?=_W5??^7-;?:>/+?>7-;_>;.;/(????@O???0C???<@????@O??
?0B7-;_V:.+*?>3,;O?):^''?9>_''?>K"8/?U5]W?5-[V?=_W5??W5=_?6M#X?=#X6O?X6M#?6M#X?=#X6O?X6M#?8NC ?>7-;_>2((O?*HIZ>7)RE+P@??<@
????@O???0C???<@-[V55.3,;O?&9.[?:^'')?>#(:O?#8>O?5-[V?=_W5??X6M#?6M#X?=#X6O?Y6]''?6]''Y?=''Y6_?Y6]''?6]''Y?=?^7/>!!"&K?:ZBF??=$
YO?0L17?[T4O _???0C???<@????@KJ2,-[,;N3?9.[&?>''):_?):^''?9NS$?=_W5??X6M#?6M#X?=#X6O?Y6]''?6-+Z?=+Z6/?[6=/?6=/[?=OQ3/>_!!%7?
2;^3?=BZ&/?,GQ7?-R@Q?65MC7#???<@????@O???0B0,KCV;^7-?>_''9??*:.+?:^'')?>W%9_?Y6]''?6]''Y?=+Z6/?Z6-+?7]7]?>K"8/?"8.K?8.K"?=CL
1O>T^TW?5*=&?=ZYY_>3,+K?*TT6?7MGC<X@??<@????@O???0C???<@+*:.5.7-;_?''9>_?:>/+?>+*:/?&9.[?6=/[?=3\7O?]7]7?7]7]?>[&9/?1<_G?
</K2?<7E-_>_ $''?6;U.?=N!!QO?E#BG?''7EZ?8-3SO\@??<@????@O???0C???<@@O??@J"(*M_%9^W?7]7]?=;^7/?[6=/?7]7]?=;^7/? 8NC?8>O#?>[&
9/?+:>/?;>?/?;.,$/>,#EC?7[U-?=B[NO>?"BC?!!6T%?;")"?>8.K#(????@O???0@@??<@@O??@@C??0B]''Y7Y5=_W?<?O3??P4MC?2</K?<SD1O>7-;_?
.;.;?;>?/??C0<O?2L_G?9"EXO>9%5_?6;M''?<:VK/>4 A;? FL*?<?G-/?4=OS?.K"8:O???0C???<@????@@C??0@@??<@''Y6]6M3\7O?U5]W?5]WU?=GQ
4_?L3L3?/[6=?<C@0O?C0<O?1LOA?898R??F(%??6Z9^?<2SJO>&]!!3? FT2?=SP2_?5=_W?=_W5?;"8.N#???<@????@O???0C???<@????@JZ&)-[,;N3?
9.[&?>_''9??%9^W?7-;^?<;N3/?Q4]G?2\[B?8=5QO?Q*6[?5*!!R?<&NH?>X[Q7?"''ID?=[T4/?&9.[?=/[6??W5=_>8.K#(????@O???0C???<@????@O??
?0B$)JSV;.;.?>''):_?,;N3?;N3,?>[&9/?V5-[?5-[V?9Q<R??Z/G+?5JMH?<RKH_>KY"G?&(]"?=3\7O?]7]7?9.[&??[6=/?5=_W?.K"8:O???0C???<@
????@O???0C???<@(ZF!!5.;.;/?):^''?;N3,?>3,;O?&9.[?5-[V?;F&$_?H+6??8-J[?<*"S?>BX"S?+*FH?>?/;??:>/+?>_''9??#8>O?6=/[?=_W5?;"8
.N#???<@????@O???0C???<@????@I>_''=[-;^7?:^'')?>3,;O?,;N3?;^7-?>/*:_>"#E;?3;I,?;RWUO>S^$[?4<2>??S4=O?6=/[?>_''9??#8>O?7=?_?
=/[6??W5=_>8.K#(????@O???0C???<@????@O???0B\''I3W;^7-?>''):_?,;N3?;N3,?>7-;_>$$7C?WD\^?817S?>=.J7?3\7M?<_G1??J2,+?4-KR?=''Y
6_?!!8^G?:N#(?>?/;??5=_W?-;^7:_???0C???<@????@@C??0@@??<@#H2L7?K2</?1<_G?</K2??K2</?2</G?0["''?>;-:??4=OS?=_W5??W5=_?5=_W?
=_W5??_7=??7=?_?=?_7??[6=/?6=/[?=/[6?:.+*>4@??<@@O??@O???0@@??<@@O??@CT5MV!!-[V7L[&9.3F=/[<1/[6?L[6=/3GA0\L10\GCL\GA03GA0
\L11\WGL\WE13GE1\\11\WGL\WE13GE1\\11\WGL\WE13GE1\\-MST6A@O??@@C??0C???<@@O??@@C??0@@??<@@O??@@C??0@@??<@@O??@@C??0@@??<@
@O??@@C??0@@??<@@O??@@C??0@@??<@@O??@@C??0@@??<@@O??@@C??0@@??<@@O??@@C??0@@??<@') ; yourself]
!

edited_ov
"      Loaded from: /tmp/full/ovr16/edited_ov.gif"

    "
     self edited_ov inspect
     ImageEditor openOnClass:self andSelector:#edited_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class edited_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'D!!HRD!!DQDQHRD!!DLC@8RD!!DMB00ID!!DMD@,CC1DOCP,HA!!DQBP4G@QDRDP(IAP@RD!!DD@ <RD!!H@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[245 239 249 109 64 153 150 108 195 23 46 95 15 40 86 62 85 126 181 189 204 38 73 120 51 80 121 96 126 165 123 152 186 183 199 219 70 110 156 143 175 205 167 192 216 229 237 244 248 251 253 253 254 254 255 255 255]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C!!8>_/;<>O@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

empty
"      Loaded from: /tmp/full/empty/empty.gif"

    "
     self empty inspect
     ImageEditor openOnClass:self andSelector:#empty
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class empty'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[192 192 192 0 0 128 127 127 95 159 159 127 255 223 159]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

expandall
"      Loaded from: /tmp/full/clcl16/expandall.gif"

    "
     self expandall inspect
     ImageEditor openOnClass:self andSelector:#expandall
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class expandall'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@DA@PDA@PDA@PDAC@0LC@0AA@PDA@PDA@PD@P0LC@0L@PP@@@@@@@@@@@@@@@0LC@DD@@PDA@PD
A@PDA@@LC@0AA@@DA XF@ XFA X@C@0L@PP@A@\GA0HDA0\G@@0LC@DD@@PEAPTBA@TEAP@LC@0AA@@D@ HB@ HB@  @C@0L@PP@A@$DA@HDA@PD@@0LC@DD
@@PC@0LBA@LC@0@LC@0A@P@DB (J@ PJB (@C@0LC@0@A@,KB0,DB0,K@@0LC@0L@@@@@@@@@@@@@@@LC@0LC@0LC@0LC@0LC@0LC@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[139 150 171 165 177 195 1 70 122 249 253 255 213 243 255 241 251 255 236 250 255 238 251 255 243 252 255 246 253 255 250 255 255 252 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C?8O? ??#?>O?8??#?>O?8??#?>O?8O? ?>@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
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

external_ov
"      Loaded from: /tmp/full/ovr16/external_ov.gif"

    "
     self external_ov inspect
     ImageEditor openOnClass:self andSelector:#external_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class external_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'E1\WE1\WE0 HB@ HB@ HEQTUEQTIBAPA@PDVA  Q@PDSD THD@DO@P8DB@,JC@4A@@ IA0TC@@H@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[171 185 212 23 50 93 44 69 110 146 164 193 147 164 193 116 137 168 84 109 143 83 109 142 34 67 103 54 84 119 228 236 245 227 236 245 228 236 244 228 237 245 235 239 242 235 240 243 235 240 242 243 244 240 243 243 240 243 243 241 250 247 238 255 249 237 251 246 238 255 255 255]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'?/;>?/;>?/8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileadd_pending
"      Loaded from: /tmp/full/pending16/fileadd_pending.gif"

    "
     self fileadd_pending inspect
     ImageEditor openOnClass:self andSelector:#fileadd_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class fileadd_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
IBP$IBP$IBP$IBP$IBP$IBP$IBL#H2L#H2L#IBP$IBP$IBP#C0<OC0<OARL$IBP$IBP$H1POC1POC1,EH2P$IBP$IAXTA0$!!C!!PQF0TVIBP$IBPMG1<_G1<_
G1<_CRP$IBP$FQ<RD!!4GBRDNG1$$IBP$I@HKB0,KB0,KB0,BIBP$IBP\B1HRGP\IE0@@@BP$IBP$A"H"H"H"H!!\XF@@$IBP$I@("D!!H]E1\WER@@@@@$IBP^
H"H"H!!\CF@DLHB@@IBP$DAL]A0$WFA LE1\W@BP$I@PHB@ H@@@@FA\@@@@$IBPDA@PDA@PDE2@W@BP$IBP$IBP$IBP$IA\W@@@$I@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 86 124 36 182 252 167 168 153 148 218 252 134 148 174 212 178 105 155 161 161 154 172 203 220 231 247 147 166 198 149 157 164 237 242 250 4 126 188 178 175 146 134 154 190 249 250 252 139 150 171 224 200 143 170 186 212 223 233 248 246 249 251 76 134 252 183 177 143 4 106 156 76 194 252 173 171 149 131 146 176 218 189 124 161 164 156 162 179 207 144 154 168 242 246 251 4 146 220 140 159 194 228 236 249 191 182 136 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@_8A?0G? _?A?<G?0_?A?<G?0_?1??G?<_?1?<@C0b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filedelete_pending
"      Loaded from: /tmp/full/pending16/filedelete_pending.gif"

    "
     self filedelete_pending inspect
     ImageEditor openOnClass:self andSelector:#filedelete_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class filedelete_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H2L#H2L#H2L#H2L#H2L#H2L#H2H"H"H"H"H"H2L#H2L#H2L"HRD!!HRD!!B"H#H2L#H2L#H!!L!!HQL!!HQ8JH"L#H2L#H1PSB@X_CALBG (TH2L#H2LMB0,KB0,K
B0,KCRL#H2L#FP,RD!!0HA!!<LB1$#H2L#H0PQDQDOEP<QDQDDH2L#H2LZDQHREP@UC00QF <UH2L#AQ,[F1,U@ATOF0<UFBL#H0$[D!!H\BAT@EQTUC"L#H2L]
F1,[F1,[EP@U@2L#H2L#D@\\B@X_EP@U@AT H2L#H0DWE1\WEP@UHAT@ER@#H2LVE!!XVEP@UHAXVEP@UH2L#H2L#H0<UC2L#H2LU@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[132 2 4 134 148 174 224 200 143 252 158 108 167 168 153 155 161 161 147 166 198 223 233 248 154 172 203 149 157 164 212 178 105 242 246 251 134 154 190 178 175 146 252 182 148 252 110 108 139 150 171 236 242 250 170 186 212 246 249 251 183 177 143 252 2 4 131 146 177 220 231 247 252 146 148 173 171 149 161 164 156 228 236 249 162 179 207 144 154 168 218 189 124 140 159 194 252 182 180 249 250 252 191 182 136 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@_8A?0G? _?A?<G?0_?A??G?<_?!!?<G?8_?1??@\Lb') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filemissing_pending
"      Loaded from: /tmp/full/pending16/filemissing_pending.gif"

    "
     self filemissing_pending inspect
     ImageEditor openOnClass:self andSelector:#filemissing_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class filemissing_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H 8NC 8NC 8NH"H"H"H"H"HNC0<UC0<U@08"H"H"H"H"C!!T[C1T[C04CC"H"H"H"H!!LUGP(^B1T_CPLSH"H"H"HZF1,[F1,[
F1,[F"H"H"H"AQ,LC@$]B!!8KF0T"H"H"H!!@GA0\OC0<GA0\PH"H"H"HWA00LC@0@@@@@@@@@H"H"@R@ HB@O@@XXE!! F@BH"H   C@0IGP@XC2DOF@@"H"HH
HB@ HB@@E"DOHQX@H"H"D!!DIGP(^@AX!!C2DV@BH"H PB@ HB@ @XC2DOF@@"H"HYFQ$YFQ$@A!! VFBD@H"H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[216 66 79 155 161 161 220 231 247 212 178 105 134 148 174 173 171 149 227 119 128 236 242 250 149 157 164 162 179 207 147 166 198 134 154 190 170 186 212 218 189 124 191 182 136 252 253 254 167 168 153 223 233 248 139 150 171 183 177 143 231 136 144 246 249 251 221 91 102 161 164 156 236 160 167 131 146 177 178 175 146 242 246 251 144 154 168 154 172 203 140 159 194 224 200 143 228 236 249 232 144 151 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@_8A?0G? _?A?<G?0_?A??G?<_?1??G?<_?1??@G<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filemodified_pending
"      Loaded from: /tmp/full/pending16/filemodified_pending.gif"

    "
     self filemodified_pending inspect
     ImageEditor openOnClass:self andSelector:#filemodified_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class filemodified_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
IRT%IRT%IRT%IRT%IRT%IRT%IRL#H2L#H2L#IRT%IRT%IRT#IBP$IBP$CBL%IRT%IRT%H1X$IAX$IB@LH2T%IRT%IQLVCP _B1XBH@0SIRT%IRTCDA@PDA@P
DA@P@2T%IRT%F!!@UERDMBA<KDA(%IRT%IPPTEAPTEAPTEAPDIRT%IRT[EATUHP4HG0,TF2T%IRT%AQ0\GA0\C0<OC0<OC2T%IP$\EQT!!CQ4"H ("H!!4%IRT^
GA0\GA0GB"HJH (GIRT%D X!!CP _C"HJB ("C"T%IPDYFQ$YFQDJH ("B!!D%IRTXFA XFA WH"HJH"HWIRT%IRT%IRT%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[29 20 7 134 148 174 224 200 143 178 175 146 167 168 153 155 161 161 223 233 248 63 44 22 147 166 198 149 157 164 250 250 206 134 154 190 212 178 105 154 172 203 52 36 18 81 57 29 242 246 251 42 29 13 139 150 171 183 177 143 237 242 250 170 186 212 246 249 251 34 23 10 131 146 177 220 231 247 173 171 149 161 164 156 228 236 249 73 52 26 144 154 168 140 159 194 218 189 124 162 179 207 84 56 48 191 182 136 249 250 252 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@_8A?0G? _?A?<G?0_?A?<G?<_?1??G?<_?1??@G<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filter_history
"      Loaded from: /tmp/full/dlcl16/filter_history.gif"

    "
     self filter_history inspect
     ImageEditor openOnClass:self andSelector:#filter_history
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class filter_history'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ HB@ HB@ HB@ HB@ HB@ HB@PHB@ DB@ HB@ HB@ HB@ DA@ HA@ HB@ HB@PDA@PDA@PDB@PHB@ HB@ HB@ HB@PDB@ DB@PHB@ HB@ HB@ DB@ HA
@ DA@ HB@ HB@ HB@ HB@ HA@ DB@ HB@PDA@PDA@PDA@PHB@PHB@ DB@ HB@ HB@ HB@ @A@ HA@PDA@PDA@PDA@ @A@ HB@ HB@ HB@ HB@P@A@ HB@ HB
@ DB@ HA@ DA@ HB@ HB@ HA@PHB@PHA@ HB@ DA@PDA@PDA@ DB@ HB@ HB@ HB@ DA@ HA@ HB@ HB@ HB@ HA@ HB@PHB@ HB@ @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[191 191 191 159 159 159 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@DP@Y@?4@FT@QX@AP?<"@CO?X@G@QXA%C?P@Y@AD@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

flatLayout
"      Loaded from: /tmp/full/elcl16/flatLayout.gif"

    "
     self flatLayout inspect
     ImageEditor openOnClass:self andSelector:#flatLayout
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class flatLayout'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@PDAA0\GA0\GA0\GA0\GA0DD@P\FA XE@0H@A0\GA0\A@PDGA0\G
A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0DA@P\GA0\GA0\GA0\GA0\AA@DGA XFAPLB@@\GA0\G@PDAA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\A
@PDGA0\GA0\GA0\GA0\G@PPAA0XFA TC@ @GA0\GA0DA@P\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[109 130 172 107 128 169 113 135 176 117 140 181 146 164 197 122 145 184 125 149 188 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G@@]?A0@@@@\@A7<G@@@@A0@G_0\@@@@C?<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

folder_pending
"      Loaded from: /tmp/full/pending16/folder_pending.gif"

    "
     self folder_pending inspect
     ImageEditor openOnClass:self andSelector:#folder_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class folder_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[C 8NC!!,[F1,[F1,[F1,[EA(ZF!!(TF1,[F1,[F1,[D0@@A@LICALS
D1LSF1,[F04A@PDA@PDA@PDACQ,[F1,R@ HB@ HB@ HB@!! [F1,[C0XFA XVE!!XVE!!XVE!!XVF1DJB (VAPTEAPTEAPTCE!!,PA0\VA0\GA0\GA0\CE!!,[E0 V
B0,KB0,KB0,CE!!,[F1$VB@ HB@ HB@ CE!!,[F1,[EQTUEQTUEQTUEQ,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[248 232 152 248 240 200 248 232 176 232 208 136 240 216 144 248 224 152 248 224 160 248 216 136 248 208 120 224 192 120 248 216 144 248 208 128 216 176 112 188 133 50 195 139 54 180 127 50 165 108 36 173 114 43 188 127 50 195 133 54 173 108 36 158 102 39 173 114 47 158 95 29 158 95 32 143 82 25 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G @?@G?8_?!!?>G??_?=??''?<_? ?<@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

folderadd_pending
"      Loaded from: /tmp/full/pending16/folderadd_pending.gif"

    "
     self folderadd_pending inspect
     ImageEditor openOnClass:self andSelector:#folderadd_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class folderadd_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"D!!HRD"H"H"H"H"H"H"H"DQ$YFQ$QH"H"H"H"H"H"G@ HA XW@10\
GA0\H"H"H (GA0\GA0\GA0\GB"H"H"HOF!!(ZF!!(ZF!!(ZF!!<"H"H"FA8^G!!8EAPTEEP@@@@TEH T D@4QB@4MBATVE @FARH[DA@EDA@PEQTUD14@@@@"C!!PE
HRD!!HQTDE DKGQ4@H HEEAPTEAPUE!!XKEQTU@BH"BP$IBP$I@@@@E!!T@@@@"H"H"H"H"H"H"EQ4U@BH"H"H"H"H"H"H"H!!TU@@@"H @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 86 124 36 182 252 143 82 25 216 176 112 148 218 252 173 114 47 240 216 144 248 240 200 248 232 152 158 102 39 188 133 50 4 126 188 232 208 136 248 224 152 158 95 29 188 127 50 248 216 136 173 108 36 195 139 54 76 134 252 248 208 120 4 106 156 76 194 252 224 192 120 180 127 50 255 255 255 248 232 176 165 108 36 195 133 54 4 146 220 248 224 160 158 95 32 248 216 144 248 208 128 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G @?@G?8_?!!?>G??_?=??7??_?<??0@<@C0b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

folderdelete_pending
"      Loaded from: /tmp/full/pending16/folderdelete_pending.gif"

    "
     self folderdelete_pending inspect
     ImageEditor openOnClass:self andSelector:#folderdelete_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class folderdelete_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"DQDQDRH"H"H"H"H"H"H"FP$IBP$YH"H"H"H"H"H"E <DA@ BA1XV
E!!XVH"H"H DLC@0LC@0LC@0L@RH"H"H]G!!8^G!! UFA8^G"@"H"H"CQ\WE1\U@ATXD1LSFATSH!!L_D@PSAAT@EQ DFAT\D2HFDA@YDA@PEP@UEQTTD2H"D (S
F1@[B!!@U@ATKD2H"H LSB (JB (U@AT@ERD"H"H"C 8NC 8U@AT!!EP@UHRH"H"H"H"HU@AT!!H"HU@AT!!H"H"H"H"FATXH"H"H!!T@AP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[132 2 4 188 133 50 224 192 120 143 82 25 248 224 152 252 74 76 165 108 36 216 176 112 232 208 136 255 255 255 248 208 120 252 158 108 248 240 200 180 127 50 158 102 39 248 232 152 248 216 136 195 139 54 158 95 29 173 114 47 252 182 148 252 2 4 195 133 54 248 224 160 252 110 108 173 108 36 240 216 144 248 208 128 252 146 148 188 127 50 248 232 176 248 216 144 158 95 32 252 182 180 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G @?@G?8_?!!?>G??_?=??''?<_?0?? OO@8\b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

foldermodified_pending
"      Loaded from: /tmp/full/pending16/foldermodified_pending.gif"

    "
     self foldermodified_pending inspect
     ImageEditor openOnClass:self andSelector:#foldermodified_pending
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class foldermodified_pending'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#@PDA@RL#H2L#H2L#H2L#EAHRD!!HTH2L#H2L#H2L#GP0FA L!!DA4]
GQ4]H2L#H0(DA@PDA@PDA@PDB"L#H2LSG!!8^G!!8^G!!8^G"H#H2L#FA$YFQ$EAPTEAPTEAPTEH0T C XEA XFCP4MCP4MCRL[C 8TC 8NC!!(_G1\_G1(#DP$E
G@8\BP8GE1<WG1\GH0HEBP$IBP$IB1<WE1\_B2L#B@ HB@ HB@<WG1\_E0<#H2L#H2L#H2LUG1<WG1<UH2L#H2L#H2L#@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[29 20 7 195 139 54 143 82 25 232 208 136 248 240 200 173 114 47 248 224 152 63 44 22 158 102 39 248 208 120 188 133 50 52 36 18 248 232 152 81 57 29 248 216 136 42 29 13 216 176 112 158 95 29 255 255 255 188 127 50 173 108 36 34 23 10 240 216 144 250 250 206 180 127 50 248 224 160 73 52 26 165 108 36 248 208 128 195 133 54 248 232 176 84 56 48 248 216 144 224 192 120 158 95 32 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G @?@G?8_?!!?>G??_?=??7??_?<??0A?@G<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

get_all
"      Loaded from: /tmp/full/clcl16/get_all.gif"

    "
     self get_all inspect
     ImageEditor openOnClass:self andSelector:#get_all
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class get_all'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE0\HB@ WE1\QD PWE1\WE1\G@@HOE1\WD04RDPTWE1\WA0@BC1\WE1LJBP0SDPTW
E0\@@08WE1\SB (KBP0RDPPF@@LPE1\WD ,JB (JB 4VB@DCC1\WE1HJB (JCQLUAP\@@0<WE1\RB (LD!!TEE1\G@@LNE1\WD00RE@TWE1\WA0@CC1\WE1TS
AQ\WE1\WE0\@@ 8WE1\WE1\WE1\WE1\GDA@NE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[226 226 226 225 225 225 204 204 204 203 203 203 185 185 185 184 184 184 174 174 174 173 173 173 172 172 172 123 123 123 122 122 122 121 121 121 119 119 119 118 118 118 113 113 113 112 112 112 111 111 111 95 95 95 74 74 74 73 73 73 70 70 70 69 69 69 68 68 68 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@^NA8>G#>^O?8??#?>O98>G# ^@A8@@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

get_next
"      Loaded from: /tmp/full/clcl16/get_next.gif"

    "
     self get_next inspect
     ImageEditor openOnClass:self andSelector:#get_next
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class get_next'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
CP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP$H@P4MCP4MCP4MCP4MCP4JA  F@@4MCP4MCP4MCP4MB0LCAP E@@4MCP4MCP4MCP,C@ LDA $F
@@4MCP4MCP4K@ LC@ LCA $FCP4MCP4MB LB@ LCA@LCAP,MCP4MCP(C@0HC@0LFBP(MCP4MCP4J@0HB@0XIB DMCP4MCP4MB LBA $J@P4MCP4MCP4MCP(F
A0,@CP4MCP4MCP4MCP4LBPDMCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[183 183 183 182 182 182 168 168 168 167 167 167 166 166 166 141 141 141 140 140 140 111 111 111 110 110 110 109 109 109 88 88 88 87 87 87 65 65 65 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C @O @? C? O?@?>C?0O>@? C8@N@@@@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph1
"      Loaded from: /tmp/full/glyphs/glyph1.gif"

    "
     self glyph1 inspect
     ImageEditor openOnClass:self andSelector:#glyph1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph1'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB (JB (JB ,LC@0LC@0LC@(HB@ HB@ KC@0LC@0AC@0JB@$IBP$HB00LC@0A@P0LB  HB@ HB@,LC@0AB@DLC@$H
BP$IBP KC@0AB@HA@PDA@P HB@ HB00AB@HB@ HB@ H@@@@@@@,FAPH@@@LC@0LCA@\GA0@KC@XE@0LEAPTEAP@@@@@@B00LA TCA XFA XHB@ HB@,LC@0F
APXLC@$HBP$IBP KC@0LC@XFC@0JB@ HB@ HB00LC@0LA 0LB  IBP$IB@,LC@0LC@0LC@(HB@ HB@ KC@0LC@0LC@0JB0,KB0,KB0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 63 127 127 63 255 255 159 255 223 63 255 191 63 223 159 63 127 95 63 223 127 63 255 255 255 191 191 191 128 128 128 95 95 95 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@?0C?AO<L?13?O?=?????_?<??13?CO<D?0C?@O<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph2
"      Loaded from: /tmp/full/glyphs/glyph2.gif"

    "
     self glyph2 inspect
     ImageEditor openOnClass:self andSelector:#glyph2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph2'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
BP$IBP$IBP$IBP$IBP$IBP$IBP$IB@\IBP@IBP$IBP$GA0\GA0@HA0$@BP$IBP$IB@ HB@ HB@ I@@$IBP$IBP\GA0\G@@ IBP@I@P$IBP$IBP$IBP GBP$@
BPDABP$IBP$IBP$IBP$I@0$A@ DIBP$I@PDA@PDA@PDA@PPB@P$IBPDDA@PDA@PDA@PDA@TFBP$AA XFA XFA XFA@TFBP$IBP$IBP$IBPLIA TFBP$IBP$I
BP GBP$@BPXFBP$IA0\GA0\@B@\I@@$FBP$IBP HB@ HB@ HBP@IBP$IBP$GA0\GA0@HA0$@BP$IBP$IBP$IBP$HA0$I@@$IBP$IBP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[63 63 95 127 127 63 255 255 159 223 223 191 255 223 63 223 159 63 127 95 63 191 191 191 0 0 0 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@FPO=@?4C>T@YX@E0??#??O?8@W@YX?5C?PO=@A$@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph3
"      Loaded from: /tmp/full/glyphs/glyph3.gif"

    "
     self glyph3 inspect
     ImageEditor openOnClass:self andSelector:#glyph3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph3'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H@PDAB@ HB@ HB@ HB@ HB@DE@@ B@ HHB@ H@0PHB@ A
@@\HB@ HB@ HB@LCA@ HB@\HB@ HB@LC@0LCA LDB@ BB@ A@PDFA XFA XF@@PHA0HG@PT@@0LC@0LF@@PHB@HHB@D@A0 HB@ C@@PHB@ BB@ HB@ HB@ H
@@PHB@ H@  H@PDAB@ HB@ HB@ HB@\BA0DF@@ HB@ HB@ HB@ HB@ A@@\HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 128 63 63 127 63 63 95 63 95 159 159 191 191 255 251 240 255 255 255 0 0 0 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@G@@]010C"C?I?>??2\NH@0''@C<@A0@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph4
"      Loaded from: /tmp/full/glyphs/glyph4.gif"

    "
     self glyph4 inspect
     ImageEditor openOnClass:self andSelector:#glyph4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph4'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA HEA XFA XFA XFA XFA XF@PTFA XFA XFA XFA XFA XBAPXFA XFA XFA XFA XFA DEA XF
A XFA XFA XFA XF@ TF@@XFA XFA HB@ DFA XC@@@FA HB@ DBA@PAA XF@@@@A XBA@PA@ PA@PXF@@@@@@XF@ DD@PHD@PXFA XFA XFA XBA@DBA@DF
A XFA XFA XF@ PA@ PB@ HB@ HB@ HB@ HD@PHDA@PDA@PDA@PDA@PDA@DB@PDA@PDA@PDA@PDA@PDAA XFA XFA XFA XFA XFA @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 128 63 63 159 63 95 159 63 127 191 63 159 191 191 223 191 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C@@F@@L@@X@@4C13?GO<<? A>@G????????@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph5
"      Loaded from: /tmp/full/glyphs/glyph5.gif"

    "
     self glyph5 inspect
     ImageEditor openOnClass:self andSelector:#glyph5
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph5'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTDA@PDA@TEAPTEAPTEAPTEA@H@@0PEAPTEAPTEAPTEAPPB@@LDAPTEAPTEAPTEAPTD@ @C
A@TEAPTEAPTEAPTEA@H@@0PEAPTEAPTEAPTEAPPB@@LDAPTEAPTEAPTEA@PD@ @CA@PDAPTEAPTEAPPB@@@@@@@CA@TEAPTEAPTEA@H@@@@CA@TEAPTEAPTE
APTD@ @CA@TEAPTEAPTEAPTEAPPAA@TEAPTEAPTEAPTEAPTEA@TEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 255 63 63 191 95 95 191 127 127 191 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@O @>@C8@O @>@C8@?8C? G<@O @\@@ @@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph6
"      Loaded from: /tmp/full/glyphs/glyph6.gif"

    "
     self glyph6 inspect
     ImageEditor openOnClass:self andSelector:#glyph6
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph6'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@XHB@ HB@ HB@ HB@ HB@DEA  HB@ HB@ HB@ HB@DG@ TFB@ HB@ HB@ HB@DG@0@D
APXHB@ HB@ HB@DG@0L@A@PEA  HB@ HB@DA@PDCA@TFA XFB@ HB@ HB@ A@0PEA  HB@ HB@ HB@ H@PLDAPXHB@ HB@ HB@ HB@DCA@TFB@ HB@ HB@ H
B@ A@0PEA  HB@ HB@ HB@ H@P@DAPXHB@ HB@ HB@ HB@XFA XFB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 63 127 127 63 255 255 127 255 255 159 255 223 63 223 159 63 127 95 63 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@B@@\@C8@_0C? _?@O @>@C8@O @>@C8@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph7
"      Loaded from: /tmp/full/glyphs/glyph7.gif"

    "
     self glyph7 inspect
     ImageEditor openOnClass:self andSelector:#glyph7
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph7'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
CP4MCP4MCP4MCPDMCP4MCP4MCP4MCP4MCPDACP4MCP4MCP4MCP4MCPDJ@P4MCP4MCP4MCP4MCPDJ@0HA@ 0KCP4MC@PGCP$F@@@@@@@AC@,MC@\ECP4MBPXF
A0$G@@DLC@\ECP4MCP4IB@$MA@$F@P0GAP4M@P4MCP$ICPTDB@DAB@PECPDACP4MBP4MAP\L@PXIA@4AB DMCP4MCPTGC@0A@@\I@ LJ@P4MCPTGC@4KC@D@
@@@@@@XICP\DC@4MCP,L@ $GA XICP4MCP4MCP4MCP4MBP ICP4MCP4MCP4MCP4MCP$ICP4MCP4MCP4MCP4MCP4ICP4MCP4MCP4MCP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 63 127 127 63 159 159 95 255 255 159 159 159 127 191 191 159 255 223 63 159 127 63 223 159 63 127 95 63 255 255 255 191 191 191 159 159 159 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@B@@X@C @_8;?7G?8N?$[?X''=0_?#/?\_8@G@@X@A@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

glyph8
"      Loaded from: /tmp/full/glyphs/glyph8.gif"

    "
     self glyph8 inspect
     ImageEditor openOnClass:self andSelector:#glyph8
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class glyph8'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC@DLC0<OC0<OC0<OC0<OC00@C@<OC0<OC0TOC0<OC0<L@00OC0<OC0<EAP<OC0<OC@8LC0<OC0<O
AP,EC0<OC00NC@<OAPTEAPTGB0TOC0<LC 0OC0\GA0\GA0\KAP<OC@8LC0<HB@ HB@PDA $JC00NC@<OBP$IBP$HB@$JC0<LC 0OC0(JB (JB@$JC0<OC@8L
C0<OC0<OB $JC0<OC HN@ 8OC0<OC0(JC0<OC04NC 8MC0<OC0<JC0<OC0<OCP8MC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[3 0 2 1 1 3 63 63 95 0 1 0 255 255 63 127 127 63 255 255 127 255 255 159 255 223 63 223 159 63 127 95 63 255 255 255 191 191 191 159 159 159 0 0 0 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@G@@\BA0LG@8\?13?''O?\?93?G@8>CC8HG@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

history_view
"      Loaded from: /tmp/full/cview16/history_view.gif"

    "
     self history_view inspect
     ImageEditor openOnClass:self andSelector:#history_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class history_view'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
T5MST5MST3!!CPTAFNEMST5MST5MST3H?MBX+K342T5MST5MST5MBOC$''J2<=S%MST5MST5MSQ4P-JCL:RT5ST5MST5MST4UHT @%K#9LT5MST5L5MST5MST5
MS\=R5MST5MSMQ(ZF!!(ZF#T7OT)ST5MST3XAA0PCB0(,M35JT5MST5L*GPHBG1<PLC]OTEMST5MSJP$GA 0KBRP7S3EST5MST2LOC0<VE <"TS-ST5MST5L!!
FP\E@0,UHEMST5MST5MSG!!PXC!!PTD19ST5MST5MST10MD!!\HD!!H[T5MST5MST5LQDQDQDQDQDUMST5MST5MST5MST5MST5MST5MST0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[235 235 242 244 245 249 239 242 249 81 107 158 90 115 165 91 115 165 91 115 163 97 121 167 213 224 246 234 239 249 242 245 251 71 100 153 80 107 158 213 224 245 217 227 246 228 235 248 238 242 249 97 114 143 211 224 245 215 227 246 217 228 246 222 231 246 227 235 248 211 225 245 217 228 245 221 231 246 246 248 251 102 118 139 103 118 139 239 244 249 110 123 134 238 244 249 120 127 127 120 127 126 130 134 119 130 134 120 140 140 113 235 235 192 252 248 163 252 248 164 249 238 99 141 139 112 150 146 106 249 234 121 159 152 102 245 221 66 242 216 71 242 216 72 152 145 107 167 143 20 190 163 33 243 214 60 250 224 97 166 154 98 159 150 102 235 222 157 198 171 53 250 221 90 230 182 25 190 154 34 250 201 46 241 186 38 241 186 39 250 198 43 190 140 21 192 145 23 196 150 30 192 139 20 228 163 25 187 165 120 182 117 11 179 121 33 228 208 177 227 134 9 193 117 18 193 116 19 192 114 20 188 112 20 173 95 6 229 121 7 177 88 7 179 155 133 232 222 215 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@_ C?@O<@?0C?A?<G?0_?A?<G?0_>A? G>@_8A? @@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

horizontal
"      Loaded from: /tmp/full/elcl16/horizontal.gif"

    "
     self horizontal inspect
     ImageEditor openOnClass:self andSelector:#horizontal
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class horizontal'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
KR4-KR4-KR4-KR4-KR4-KR4-JR$)JR$)JR$)JR$)JR4-KR\KB0,KB2\KB0,KB2\-KR4(B1<^G1 (B0LE@1 (KR4-I ,^HA8II ,FB@XXI"4-KRTKG18_C2TK
B@ HGBT-KR4$B1LSD1L$B0<SD1L$KR4-H0,_G!!<JH0,,KB,WH24-KRHKG"@^F"HKKB(+C"H-KR4!!B1<^G08!!B2,+J1H!!KR4-CP,UE!!XVCP,VE!!XVCR4-KP\K
GQ8]FP\K@0TCC@\-KR4DB18 G!!DDB0XHA!!@DKR4-@ ,]G!!4[@ ,HB@ P@"4-KPDKEAPTE@DKEAPTE@D-KR4@@@@@@@@@@@@@@@@@KP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[134 148 174 136 149 172 140 151 170 215 227 244 143 154 168 87 141 200 154 187 223 148 156 165 57 121 189 246 252 255 242 251 255 213 243 255 238 250 255 152 159 162 241 251 255 245 252 255 236 250 255 237 250 255 240 251 255 244 252 255 235 250 255 238 251 255 239 251 255 243 252 255 247 253 255 237 251 255 242 252 255 235 251 255 245 253 255 147 197 178 55 152 96 168 206 183 124 184 125 158 162 158 162 165 155 168 168 151 173 171 148 177 174 145 181 176 142 189 181 137 185 178 140 191 182 136 238 158 147 224 107 94 235 145 134 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@??#?>O?8??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

iconMinus
    ^ ToolbarIconLibrary iconMinus12x12

    "Modified: / 31-08-2011 / 10:51:23 / cg"
!

iconMinus24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconMinus24x24 inspect
     ImageEditor openOnClass:self andSelector:#iconMinus24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class iconMinus24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@8.J.+,#H2L#Z6.C 5]V=/\/K,[GL3L3L8.J.+,#H2L#Z6.C 5]V=/\/K,[GL3L3L7-;[6<[F1\V?/>_''.[&**+Z6/+:</NW%7-;[6<[F
1\V?/>_''.[&**+Z6/+:</NW%.K#R4,C@2\''I2[&99NSN3-3\.++_7=CP.K#R4,C@2\''I2[&99NSN3-3\.++_7=CP7]6=/[6=/[7!!8][V+J21,\3L2,+T5MST
7]6=/[6=/[7!!8][V+J21,\3L2,+T5MST@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 239 232 232 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 0 0 0 207 216 240 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 227 227 236 225 225 234 244 244 249 242 242 247 218 217 230 212 211 224 234 234 242 253 253 254 251 251 252 227 226 235 226 226 237 243 243 247 220 220 231 240 239 244 237 237 244 233 233 240 52 89 178 231 231 238 50 87 176 229 229 239 248 248 251 246 246 249 223 223 233 222 221 232 238 238 244 56 94 181 55 92 180 53 90 178 233 232 239 51 88 176 232 232 241 251 251 253 249 249 251 228 228 237 225 224 234 241 241 246 238 237 243 56 93 180 254 254 255 229 229 237 227 227 238 246 246 250 244 244 248 219 219 230 236 236 243 255 255 255 51 88 177 231 230 238 249 249 252 247 247 250 241 241 247 239 239 245 236 235 242 54 91 179 231 231 240 176 175 128 176 240 159 143 159 128 127 208 96 175 239 144 15 79 0 160 176 95 0 160 0 64 176 48 112 159 95 0 96 0 144 159 143 96 207 80 127 159 111 63 175 48 96 207 79 80 176 64 31 159 31 143 224 112 64 176 63 95 207 79 63 160 47 0 127 0 80 191 64 176 240 144 143 239 112 15 160 15 16 95 16 0 80 0 143 224 111 191 240 159 175 240 144 15 127 15 0 175 0 144 239 127 0 79 0 0 112 0 0 95 0 15 112 15 111 207 80 16 79 16 15 79 15 16 80 16 128 223 111 159 159 63 15 64 15 31 144 16 16 80 15 128 224 111 176 239 159 95 112 80 15 175 15 144 224 127 95 192 79 31 95 15 32 160 31 48 159 47 32 159 31 15 128 15 95 160 47 0 111 0 127 223 96 15 80 0 64 112 63 159 239 127]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@????????????????????????????????@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

iconPlus
    ^ ToolbarIconLibrary iconPlus12x12

    "Modified: / 31-08-2011 / 10:51:37 / cg"
!

iconPlus24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconPlus24x24 inspect
     ImageEditor openOnClass:self andSelector:#iconPlus24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class iconPlus24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@B7->C 5]W(:@@@@@@@@@@@@@@@@@@@@@B7->C 5]W(:@@@@@@@@@@@@@@@@@@@@@CA0\''I**+G10@@@@@@@@@@@@@@@@@@@@CA0\''I**+G10@@
@@@@@@@@@@@@@@@@@@CZ6*.+5=_G10@@@@@@@@@@@@@@@@@@@@CZ6*.+5=_G10@@@@@@@@@@@@@@@@@@@@C):Z"(.[&=/P@@@@@@@@@@@@@@@@@@@@C):Z"(
.[&=/P@@@@@@@@@@8.J.+,#H2L#Z6-#X1LR=/\/K,[GL3L3L8.J.+,#H2L#Z6-#X1LR=/\/K,[GL3L3L7-;[6<[F1\V?/>_''.[&**+Z6/+:</NW%7-;[6<[F
1\V?/>_''.[&**+Z6/+:</NW%.K#R4,C@2\''I2[&99NSN3-3\.++_7=CP.K#R4,C@2\''I2[&99NSN3-3\.++_7=CP7]6=/[6=/[7!!8Z**,;N1,\3L2,+T5MST
7]6=/[6=/[7!!8Z**,;N1,\3L2,+T5MST@@@@@@@@@@CM3[.;/+;B0 @@@@@@@@@@@@@@@@@@@@CM3[.;/+;B0 @@@@@@@@@@@@@@@@@@@@C#8;:>+:?Q4P@@
@@@@@@@@@@@@@@@@@@C#8;:>+:?Q4P@@@@@@@@@@@@@@@@@@@@CC0;V57=?O30@@@@@@@@@@@@@@@@@@@@CC0;V57=?O30@@@@@@@@@@@@@@@@@@@@C&9-[V
+J3Y6P@@@@@@@@@@@@@@@@@@@@C&9-[V+J3Y6P@@@@@@@@@@') ; colorMapFromArray:#[255 248 248 63 144 224 64 152 232 79 160 232 64 152 224 64 144 224 63 136 224 48 128 216 48 120 216 47 112 216 47 112 208 32 104 208 32 96 208 31 88 200 16 88 200 16 80 200 15 72 192 15 64 192 0 64 192 0 56 184 0 56 176 0 48 160 143 200 248 128 200 248 127 192 248 112 184 248 111 176 248 96 168 248 95 160 248 80 152 248 79 144 248 64 128 248 63 120 248 48 112 248 32 104 248 31 96 248 16 88 248 15 80 248 0 72 248 0 64 240 0 48 168 112 176 248 111 168 248 96 160 248 95 152 248 80 144 248 79 136 248 63 128 248 48 120 248 47 112 248 15 72 248 0 48 176 95 168 232 191 224 248 191 216 248 176 208 248 175 208 248 175 200 248 160 200 248 160 192 248 159 192 248 159 184 248 144 184 248 144 176 248 143 168 248 128 168 248 128 160 248 127 160 248 127 152 240 31 72 176 111 168 232 240 240 248 240 232 240 63 88 176 239 232 240 240 240 240 48 88 176 96 168 224 224 224 232 96 160 224 223 216 232 48 80 176 224 224 240 223 216 224 96 152 224 96 152 216 95 152 216 239 232 232 208 208 224 48 120 208 80 144 208 80 136 208 79 128 200 79 120 200 79 120 192 64 112 192 64 104 184 63 104 184 63 96 184 15 56 160 0 0 0 207 216 240 240 144 24 255 248 48 255 248 96 255 248 24 240 208 24 255 248 152 255 248 88 255 248 136 255 248 176 255 248 200 227 227 236 225 225 234 244 244 249 242 242 247 218 217 230 212 211 224 234 234 242 253 253 254 251 251 252 227 226 235 226 226 237 243 243 247 220 220 231 240 239 244 237 237 244 233 233 240 52 89 178 231 231 238 50 87 176 229 229 239 248 248 251 246 246 249 223 223 233 222 221 232 238 238 244 56 94 181 55 92 180 53 90 178 233 232 239 51 88 176 232 232 241 251 251 253 249 249 251 228 228 237 225 224 234 241 241 246 238 237 243 56 93 180 254 254 255 229 229 237 227 227 238 246 246 250 244 244 248 219 219 230 236 236 243 255 255 255 51 88 177 231 230 238 249 249 252 247 247 250 241 241 247 239 239 245 236 235 242 54 91 179 231 231 240 176 175 128 176 240 159 143 159 128 127 208 96 175 239 144 15 79 0 160 176 95 0 160 0 64 176 48 112 159 95 0 96 0 144 159 143 96 207 80 127 159 111 63 175 48 96 207 79 80 176 64 31 159 31 143 224 112 64 176 63 95 207 79 63 160 47 0 127 0 80 191 64 176 240 144 143 239 112 15 160 15 16 95 16 0 80 0 143 224 111 191 240 159 175 240 144 15 127 15 0 175 0 144 239 127 0 79 0 0 112 0 0 95 0 15 112 15 111 207 80 16 79 16 15 79 15 16 80 16 128 223 111 159 159 63 15 64 15 31 144 16 16 80 15 128 224 111 176 239 159 95 112 80 15 175 15 144 224 127 95 192 79 31 95 15 32 160 31 48 159 47 32 159 31 15 128 15 95 160 47 0 111 0 127 223 96 15 80 0 64 112 63 159 239 127 95 159 79 16 175 16]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O<@@O<@@O<@@O<@@O<@@O<@@O<@@O<@????????????????????????????????@O<@@O<@@O<@@O<@@O<@@O<@@O<@@O<@') ; yourself); yourself]
!

ignore
"      Loaded from: /tmp/full/tortoise/ignore.gif"

    "
     self ignore inspect
     ImageEditor openOnClass:self andSelector:#ignore
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class ignore'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@\GQD]DQ4]GPT\@@@@@@@MGPLEAPTQ@0L]D!!4@@@@@GA0\AQ XFA Q@14RCP@@@A$IE1\WBQ$LA@PYD!!4@@@@YBP$IBQ$YFQ$YFPPYBQ\FFQ$YFP0LC@PD
A@PDFQ$YA PDA@PDA@PDA@PDFQHRFQ@[F1,[F1,[C!!0ED!!$YD @PC1,[B0,[F1,SGQHYE1H@@@<[F1,[F1,[F1,RFP$R@@@HC0<OC0 [F1TFD!!$YD @@@@ H
B@ JBA,UF XRCP@@@@@@@@4JB@ [EQTZA!!HM@@@@@@@@CP HF1,B@!!XAD 4@@@@@@@4AA0HB@P\VE DR@@@@@@4AA0HB@PDGA1XVD @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 108 154 4 60 94 4 132 130 132 156 2 4 68 70 68 252 206 108 172 242 4 156 50 4 252 74 76 92 30 4 252 194 76 220 2 4 196 198 196 220 146 4 188 126 4 252 182 148 92 94 92 60 22 4 124 86 4 188 2 4 252 254 108 132 254 76 252 110 108 44 46 44 252 2 4 252 254 180 244 170 4 188 186 188 108 110 108]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O?A?>G?<_?1??????????/?>_?9??#?<C?8G?0_?C?<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
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

keywordsub_wizban
"      Loaded from: /tmp/full/wizban/keywordsub_wizban.gif"

    "
     self keywordsub_wizban inspect
     ImageEditor openOnClass:self andSelector:#keywordsub_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class keywordsub_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G!!JY<8C@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H5S\,8C@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G!!SI%EK@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@7I&U''3$YF@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A8
M2Y%YUE,_4YF@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D(&YVU''3&1,_4YF@0LC@0LC
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7I"X&YUEKR61,_4YF@0LC@0LC@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#RX&I"X&TT-KR61,_4YF@0LC@0LC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G!!SI"X&I&V)^T-KR61,_4YF@0LC@0LC@@@@@FQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YM(@@@@@@@@@@@@@@M)$YFQ$YFQ$
YFQ$YFQ$YIFQ$YFQ$\]9^T-KR61,_4YF@0LC@0LC@@@@@D<ZF!!(ZF!!(ZF!!(ZF!!(ZDA@PDA@PS3[.1P@@@@@@@@@@@N:=F!!(ZF!!(ZF!!(ZF!!(ZF!!@PDA@PDCYO
14-KR61,_4YF@0LC@0LC@@@@@L>^''):^''+>?B@ HTEAPC0<OMST5$FI"S<T@@@@@@@@@@N:O''):^''+>?B@ HBEAPC0<OMST5MT1"M)]KR61,_4YF@0LC@0LC
@@@@@L>^''):^/;<HB@!!PT@<OC0<5MST5N4<9X$?E@@@@@@@@@N:O''):^/;<HB@!!PTE@OC0<5MST5N9@9NSZWR61,_4YF@0LC@0LC@@@@@L>^''+>?B@ HTEAP
C0<OMST5MS,;N0\>&&IO1P@@@@@@@N:O''):?/0 HBEAPT@<OC3T5MST;N3-O*;H6%61,_4YF@0LC@0LC@@@@@I"^/;<HB@!!PTE@OC0<5MST5N3,;BS,>\C9"
/P@@@@@@@N:O/;<HB@ HTE@OC0<5MST5MS,;BP&=0<M"S@9,_4YF@0LC@0LC@@@@@I"?B@ HBEAPC0<OC3T5MST;N3,IBP&Z*9*2EYD@@@@@@ABO/0 HBEAP
T@<OC3T5MST;N3,IBP&W&*,>N^A,_4YF@0LC@0LC@@@@@I HB@!!PTE@OC0<5MST5N3,;BP$IKP$>O#9YNPW]@@@@@ABOB@ HTEAPC0<OMST5MS,;N0$IBR6W
VS8>,!!U+_4YF@0LC@0LC@@@@@I HBEAPT@<OC3T5MST;N3,IBP$-K[X>75%Y,&HP@@@@@ABOB@!!PTA:I^(2L#H1:^*NI"ZN\\U@Z75%Y,#$E9$YF@0LC@0LC
@@@@@BDHTE@OC0<5MST5MS,;N0$IBR4-?EIY"M=YVS$E7P@@@ABGTEAPC98^G!!8^G!!;1<_D^G!!91/3V="M?_V[I"Z4YF@0LC@0LC@@@@@BEPT@<OC3T5MST;
N3,IBP$-KR7<?H>H,3XEA^#($P@@@A*GTE@OC0<5MST5N3,;BP$IKR7<?M1L"KL6A^#(HTYF@0LC@0LC@@@@@BEPC0<OMST5MS,;N0$IBR4-?O3<Y''C$$H]*
JHNC$P@@5F.GC0<OM[<^G/G1<_G1<_G1<WDFTKX>\H?:JHNCHTYF@0LC@0LC@@@@@BDOC3T5MST5N3,;BP$IKR7<?O1&Y''-;^<*''>"#+10@@R&.GC0<5M_FI
^(2L#H1:^*NI"ZN\\UC\^?0N]N]NHTYF@0LCJTA@@@@@@BDOMP[=AH0;N0$I\PPDK_3<?A8D4@XTEASJ)?((17"]T6.GC3T5MST5MST;N3,IBS,IBP$I7O1;
EAQ;C''S''HR%@P4DB@ HB@@@@@BD5A"8?O3=-BP%-O3<?''/1&^#<?O=K1EBL#+:D+14)ST;VGMST5MS,;BP$IKR4-?O3<Y&Y;^1PTEBL#.\Y4L4DB@ HB@ HB
@@@@@@,5AC<_L!! ?^ $XK#<?L&YR4-I#43<XY&U%ENY*$I5ST;VGMST;N5^V*I2\''I2(*G]7%* ^A+Y&H2M%Y\*''L4DB@ HB@ HB@@@@@@,5K#=#.-@?G;=P
L#<?L&Y7O282!!Q ?.&T*J+%4$I5ST;VGMS,;N0Z(V5-[V5-[''I2\*I0^A#U&H6T*J"N/L4DB@ HB@ HB@@@@@@,;O3<2''.<?FM;<''#<?L'',DO1=BH1<?42*A
 R*O$I5ST;VGN3,IBP$-KR7<?O1&Y''-;EAPTH2M%YR(* XF9L4DB@ HB@ HB@@@@@@,;O3<2B^<?FK+<Y#<?L!!PDO1?^YQ<?40>1@PFD$I5ST;VGN0$IBP%P
TEAPTEIR-+X-^1P#H6T*J(FA@PD*L4DB@ HB@ HB@@@@@@,IK#=#KZL?G;)&Y#<?L!!Q7O2;^YQ ?L <A@PFD!!I5ST2.GBP$IK_FI#IZV%)Y:"W+1BRM%YR(*
 XDA@PDAL4DB@ HB@ HB@@@@@GLIAC<_N1<?[_=;^3<?L!!R64-J(0#<XL/0A@PFD!!I5ST2.GBR4-KS,FU5]WU0YWU;^6^6U%J"*A@PDA@PDAL4DB@ HB@ HB
@@@@@GL-TB8?O3<.L(U;EC<?L"M%#C<?O=I#.+8''@PFD!!I5ST2.GKR4-?O3<Y''-;EAPTEBL#YR(* XDA@PDA@PDAL4DB@ HB@ HB@@@@@GL-K[]-G642./0T
E@P_L&U%J)X_[VL2A,$QCPFD!!I5ST2-4K_3<?FY&^7,TEAP#H6U%J"*A PDA@PDA@PDAL4DB@ HB@ HB@@@@@GO<?O1P?;+??APTEBMBP"(* XFEP/<H@QMU
N@6D!!I5ST3M4?O3<Y&Y;^1PTEBL#YVT* XDA@PDA@PDA@PDAJDDB@ HB@ HB@@@@@OS<?FY&^7,TEAP#H6U%J"*A,PDA@PDA@QOY6S"_!!I5ST3M4?FY&^7,T
EAPTH2M%J"*A PDA@PDA@PDA@PDAJDDB@ HB@ HB@@@@@OS<Y''-;^1PTEBL#YVT* XDA@PDA@PDA@QOYXB<8CY5ST2!!4Y&Y;^5^V*I2\;>>\*J!!7%''\^A+XT
,PDA@PDAJDDB@ HB@ HB@@@@@OQ&^7,TEAPTH2M%J"*A PDA@PDA@PDA@QOY&4%IN@5SI"!!4Y''-;EEC;0!!8^G!!;B0,KB><I1TM0#,PDA@PDAS$DB@ HB@ HB
@@@@@L1;^1PTEBL#YVT*J(F1@PDA@PDA/&>-]!!OY)*YEQRTM;D94^1PTEAP#H6T*J(FA@PDA@PDA@PDA@PDA@PDAS$DB@ HB@ HB@@@@@L0TEAPTH2M%J"*A
 PDA@PDA/ 4"H(.K"8,/GQ&&QT %CT94EAPTH:56]''[U<"(*J"(*J"(*J(FA@PDA@PDAS$DB@ HB@ HB@@@@@LPTEAP#H6T*J(FA@PDA@Z0WD.%.K2= XFAI
GQ&&B$!!HIZ)4EAP#H2H"DX,%H,''"^*NI"ZN\U;XT,PDA@PDAS$DB@ HB@ HB@@@@@LPTH2M%YR(* [DA@PDA+GVY>SP/K5V[GY.[)!!&&B%!!H82T<EBL#Y]V_
2QKKE$P"WU]WU5]P-''-%@PDA@PDAS$DB@ HB@ HB@@@@@O\#H6T*J(FA@PDA@PF,]Y$4MO$])JR$)G5=FQ&&B%"0_L S[6U%J"*A,P4RID_)N@4A@PDA@PDA
@PDA@PDAS*B (JB (JB @@@@@O\#YR(* XDA@PDA@PDW<5)ZGCD0LO =O\D FQ&&B% MOL%5+FT* QQRT%KINDQGQ3"-J DA@PDA@PDA@PDAS+^7-;^7-;^7
@@@@@O]%J"*A,PDA@PDA@[8R?%(\LS@=N#(:N#6&GQ&&B#2YH!!H,J-V- U^I#IZFDRPVQ1366@DA@PDA@PDA@PDAAF%)ZV%)ZV%W@@@@@A,* XDA@PDA@PDA
@Q]DV+P1L@0:N''8RD!!IEB!!&&LEX"=,0,CQLS@QQRT%J-DX,VQ9PRKBLA@PDA@PDA@PDAAE9^W%9^"&%W@@@@@A.A PDA@PDA@PDA@WVRWAX1"01>DP43L1ME
GQ$ U!!K6]@S0D5XS@PDA@PE/D(,VE)P%L>XA@PDA@PDA@PDAAJJ"(+!!^"&$F@@@@@A,A@PDA@PDA@PDA@QMZGAZYCG;6!!<[F9!!MEGR@LD9=4(\@SCEPS@PDA
@PGQDX,VE)P%L<XA@PDA@PDA@PDAAL7M(%9)U;> @@CVH?T,KB0,KB0,KB0,:"UZQ1[KCBIN HC:KAL/H@0SOLZ!!0ALLLD$SKB0,KB3ICL,VQ5(%\8@,KB0,
KB0,KB0,6<68"%^7(@HB@J:/Z]-_W5=_W5=_W5=_F2W>E!![KD_A_W5=_W1N[CAM]<Z_@D%X GTTS6=/[F1M>CI$VGE("1M/[6=/[6=/[6=/[AE9)A  B@ HB
5"+J9 8NC 8NC 8NC 8N]BJTQ1ZKD^(NC 8NC!!OKD8Z6;\@RU"@YB+,SE1\<D''8LCCDVWISITEAPTK^7-;^7-;^7-0" @ HB@ HB@@@@@@@@@@@@@@A8#X6M
#RJRQ1X$DWX&I"X&I,$SCWJU]RIVLJXYB$U>_''9>N#(LLCF4V$PMJR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@@@@@@@@@@G"M#X6M#P5GQ4^YN@4&I"X&I.5/
\)U5NC0MB*XYB*X=N#(:N/ 0LQ1Z?!!J!!JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@@@@@@@@@^G"M#X6MR+;IQ4_)"1F,I"X&YV]''%WWIOA]XB*Z&)#@ 0\D 
)C@1-CQZ<04)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@@@@@@@@@^G"M#S]JR)7QD$QG&QE5;RX&YV]''<!!OHRL!!XB *&FW5=)JR$_Y/9MCRY]R$)JR$)PDA@
XYNSP4NNPTDB@ HB@ HB@@@@@@@@@@A8^G"MM4)JR)6%4QG3:Y$QD1L<YV]''\(H"_NN0B*Z&G]%UUUSYK2<4$"U5/2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB
@@@@@@@@@G!!8^G 7ST)JR)6%ZK8MH!!D8DRHSYV]''\''JBH''2;VJXYGT% XFA 6Q0$H''XC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@@@@@@G!!8^H47ST)J
R)6%ZF!!(I/J-]''[2YV]''\''I2 "I<RK@YGT$8NC RD9?!!T@LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@@@@@^G!!8#S\7ST)JR)6%ZF!!(I"X&I&U%YV]''
\''I2TXH"9TV[GT$S5=^!!R61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@@@A8^G"MM3\7ST)JR)6%ZF!!(I"X&I"Y%YV]''\''I2TUFBH&9IUV@S^T-K
R61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@@@A8^H6MM3\7ST)JR)6%ZF!!(I"X&I"Y%YV]''\''I2TUEQ "I.XF@S^T-KR61?Q LC@2$)JR$)PDA@
XYNSP4NNPTDB@ HB@ HB@@@@@G!!8#X6MM3\7ST)JR)6%ZF!!(I"X&I"Y%YV]''\''I2TUEQ/HHRUF@S^T-KR61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB
@@@@5G"M#X6MM3\7ST)JR)6%ZF!!(I"X&I"Y%YV]''\''I2TUEQ/J&BD),S^T-KR61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@@@^G"M#X6MM3\7ST)J
R)6%ZF!!(I"X&I"Y%YV]''\''I2TUEQ/J&)+RI5^T-KR61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@CT^H6M#X6MM3\7ST)JR)6%ZF!!(ZBX&I"Y%YV]''
\''I2TUEQ/J&)3,99^T-KR61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@@A8^H6M#X6MM3\7ST)JR)6%ZF!!(I"X&I"Y%YV]''\''I2TUEQ/J&)3,99^T-K
R61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB@G!!8^H6M#X6MM3\7ST)JR)6%ZF!!(I"X&I"Y%YV]''\''I2TUEQ/J&)3,99^T-KR61?Q LC@2$)JR$)PDA@
XYNSP4NNPTDB@ HB@ HB@G!!8^H6M#X6MM3\7ST)JR)6%ZF!!(I"X&I"Y%YV]''\''I2TUEQ/J&)3,99^T-KR61?Q LC@2$)JR$)PDA@XYNSP4NNPTDB@ HB@ HB
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 249 250 252 222 230 248 232 238 250 150 165 180 207 176 135 218 225 236 233 225 217 221 229 241 233 238 245 136 195 134 176 174 156 70 148 71 128 173 114 228 227 233 225 232 243 230 215 193 68 139 49 61 132 40 57 127 32 242 245 249 220 171 109 115 183 98 135 184 128 88 109 143 120 185 125 227 212 191 114 143 139 135 200 118 126 196 138 204 212 226 110 131 165 88 164 100 197 186 163 67 135 43 244 246 250 90 163 77 86 151 61 246 248 253 213 227 211 182 187 185 229 236 249 246 248 251 196 197 187 202 213 214 235 239 246 100 120 153 156 228 171 98 172 104 105 179 103 161 180 216 187 193 182 168 233 163 228 234 244 229 181 122 252 252 254 76 148 57 230 167 91 62 144 78 230 236 245 115 168 103 70 151 87 242 186 121 65 88 124 228 234 249 223 231 248 184 199 226 225 232 248 106 173 82 181 232 181 233 238 250 120 185 95 198 234 187 165 231 182 250 251 254 235 240 250 231 187 138 250 252 254 170 182 182 233 198 153 224 230 241 240 244 252 228 233 240 249 250 254 133 213 154 140 215 161 86 158 88 217 222 234 148 198 136 242 179 101 179 235 156 195 204 220 172 229 148 110 157 102 212 211 223 132 149 157 152 229 178 226 234 249 225 167 97 148 168 204 250 240 226 245 247 252 238 242 248 243 246 252 248 250 253 216 219 230 200 200 199 218 209 192 234 239 250 128 147 179 150 215 153 199 218 197 244 215 184 211 218 231 242 245 252 159 168 152 208 213 214 92 149 72 151 187 141 185 195 213 254 254 255 236 241 251 173 185 206 240 243 248 183 220 167 104 179 120 61 138 57 233 239 250 182 190 199 248 249 251 171 199 169 166 168 170 221 223 219 211 220 236 122 165 116 213 216 215 250 172 93 166 179 203 214 215 227 78 152 66 179 190 208 253 253 255 224 231 248 219 217 214 229 227 224 242 234 224 154 215 131 226 233 248 167 222 137 230 238 238 182 193 212 232 220 206 214 194 162 98 167 80 243 196 137 130 204 148 191 201 217 249 251 253 218 226 240 104 157 89 222 229 245 214 221 222 206 202 214 169 182 205 92 173 113 249 250 253 125 190 129 220 223 225 188 198 216 238 243 251 81 132 70 245 204 149 236 241 238 186 209 183 249 249 250 234 234 238 156 204 146 248 250 252 236 174 97 251 175 97 142 208 131 208 204 190 232 236 242 221 226 239 209 206 217 241 242 245 178 193 223 200 238 193 239 243 252 230 208 180 225 235 224 220 228 240 89 146 70 75 157 96 201 209 223 247 212 164 133 153 147 253 251 248 224 223 230 236 231 223 169 209 151 79 142 58 237 239 242 81 157 73 140 156 148 205 198 210 237 241 251 225 200 164 162 175 195 177 204 169 74 96 131 137 157 193 254 255 255 163 195 155 254 254 254 191 212 196 232 234 240 144 224 167 252 247 241 133 152 158 235 239 245 252 250 247 201 212 233 245 175 95 218 193 154 156 190 154 138 168 152 211 239 194 246 205 168 167 217 161 231 231 236 192 194 197 196 160 116 111 180 92 166 191 169 179 176 169 240 243 252 222 233 225 242 223 196 192 201 216 95 142 90 207 215 228 210 225 211 91 158 65 147 159 149 95 129 132 87 144 68 125 148 145 78 159 93 157 225 158 200 204 208 198 206 222 237 241 247 167 179 199 171 227 144 192 205 229]; yourself]

    "Modified: / 11-04-2008 / 11:32:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

lock
"      Loaded from: /tmp/full/subversive/lock.gif"

    "
     self lock inspect
     ImageEditor openOnClass:self andSelector:#lock
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class lock'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD0LC@0LCD1LSD1LSD1LSD0FB(VB"$0LSD1LSD1LSD1LA,AL@D^LCD1LSD1LSD1LS@#LCD0
I#@1LSD1LSD1LSD0BC@1L@<0LSD1LSD1LSDELC@0@S@0L@T1LSD1LSD/@BPDDPX G@4@K3D1LSD1K2TU@0H/K0$,B2<1LSD1LR<]AB\PK28+D"H/LSD1LSD/
E@LBFR<GC"DWK3D1LSD1K0@(A!!(_CAL-@B<1LSD1LSD/K2</K2</K2<1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[232 172 171 172 172 172 249 189 189 249 192 191 249 193 192 209 73 73 248 188 188 247 183 182 211 210 211 247 182 182 188 189 188 245 177 177 247 181 181 246 181 180 246 180 180 187 187 186 248 189 188 249 190 190 246 179 179 245 179 179 249 193 193 250 194 193 194 194 194 244 175 175 207 207 207 248 187 187 248 187 186 208 208 208 247 183 183 250 194 194 184 184 184 247 184 184 247 186 185 245 178 177 245 176 175 209 209 209 249 194 194 250 195 194 185 185 185 249 191 190 248 191 190 182 182 182 201 201 201 247 182 181 246 180 179 245 177 176 247 184 183 174 86 85 109 109 109 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@O A?@G<@]0A7@O>A?<G?0_?A?<G?0O>@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

locked_ov
"      Loaded from: /tmp/full/ovr16/locked_ov.gif"

    "
     self locked_ov inspect
     ImageEditor openOnClass:self andSelector:#locked_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class locked_ov'
        ifAbsentPut:[(Depth8Image new) width: 8; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A XFA XGA0XEEAPT@@@SAPTRCADQD1LECQLAAALSD04HD1LSD1LKB@8SD1LS@0LNC0$SD0HBBP<PDA@PB (PD@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[74 74 76 36 38 46 43 49 67 53 59 75 35 38 46 29 36 53 31 38 55 20 24 34 26 31 43 43 50 67 18 20 25 78 83 96 55 57 62 27 34 50 22 26 35 20 23 30 18 21 27 54 57 62 55 58 61 255 255 255 145 145 145]; mask:((ImageMask new) width: 8; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??????????<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

log
"      Loaded from: /tmp/full/tortoise/log.gif"

    "
     self log inspect
     ImageEditor openOnClass:self andSelector:#log
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class log'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MA00@@@@@@@@@@@@@@@@MA@(J@@@@
@@@@@@@@@@@@@ PDF@0@@@@@@@@@@@@@@A0LA0PN@A$OFQ$YE0@@@@@RCP0G@@@OGAHEAP$@@@@@@@HBG@@@FPTEAPTI@@@@CQPQC0TT@1$RD!!HRBP@@@@ [
F1PTE@LYAPTEAP$@@@@VEAPA@PDPFQHRD!!HI@@@@E DVE LZB1$EAPTEBP@@@A0FA XKB1L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 108 154 4 132 130 132 60 94 4 252 218 148 220 222 220 20 62 4 252 206 108 68 70 68 164 162 164 252 254 148 20 18 20 252 158 108 148 146 148 188 126 4 252 250 252 44 62 4 108 254 36 92 94 92 4 6 4 124 186 4 132 134 132 84 126 4 196 194 196 252 254 180 252 254 252 60 62 4 132 254 76 108 110 108]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@N@A8@G0@__!!9>C''8??#?>O?8??#>@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
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
!

merged_ov
"      Loaded from: /tmp/full/ovr16/merged_ov.gif"

    "
     self merged_ov inspect
     ImageEditor openOnClass:self andSelector:#merged_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class merged_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'DQDQDQDQDP@@DA@P@@@@@@PDBP@@D@LOC0<CDA@GC 4MBA@P@ (LB0XP@@@A@PT@@@@@DA@P@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[48 72 126 69 99 152 71 101 153 76 106 158 78 108 160 69 99 150 71 102 154 73 104 157 73 104 155 78 109 160 164 184 213 163 184 213 163 184 212 199 213 230 199 213 229 226 235 244 255 255 255 255 255 255]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O;>?/;>?/8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

mergestream_wizban
"      Loaded from: /tmp/full/wizban/mergestream_wizban.gif"

    "
     self mergestream_wizban inspect
     ImageEditor openOnClass:self andSelector:#mergestream_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class mergestream_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ATCDP<B@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G\?G <B@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AT?J8+L@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@DA6 QC04M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@U
AAL1Z@ ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@LSLSDQC08ND 4M@ HB@ HB
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ASTR,+LX*$AP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@I \+J2,+B@TEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AT?D1L+J3D$BPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@A@\SD1L+R1@IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B)ETQLSD1MKFP<I
BPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CUA\P@@@@@@@@@@@@@@A@]QTQLSD6 YC0<IBPTEAP8ND 4M@ HB@ HB
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MVE?4''D@@@@@@@@@@F,?A0]QTQLSZA@YC0<IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@M/Q''$''A7-I1@@@@@@@@]00GA0]QTQL1IA@YC0<IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@L#+0X/''WT[R\P@@@@@DA0\GA0]QTSD"DA@YC0<IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M\</##9=V%!!F4''D@Z4HG
A0\GA0]QLRH$DA@YC0<IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5XYL5#YU=WJT#Q-I1QP0GA0\GA0\SH"H$DA@YC0<I
BPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CU!!\55\9F2NMG"BH4[RW@0GA0\GA5FJH"H$DA@YC0<IBPTEAP8ND 4M@ HB@ HB
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MVE3WS''TYH-H4FP9)RMF4%0GA0\GA4@HH"H$DA@YC0<IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@5XWM]NZYX%)+)H9[2NZYXQ-I\A0\GDP HH"H$DA@YC0<IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CU!!(;QH
)RMFX#H)H6J-WS%*<D[RW@](B@ HH"H$DA@YC0<IBPTEAP8ND 4M@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MVFS''V8)H4Z<M3H)H3Y K%49Z#-3
4&2JB@ HH"H$DA@YC0<IBPTEAP8ND 4M@ HBF"@]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5XX]H]E30Q*6:M3H)H3YIXB8-JV(;\=IHB@ HH"H$DA@YC0<I
BPTEAP8NCQ(]E0XA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EQ !!7D=UU5F+S4;M3H)H3YZY&@.N6()KZL3[  HH"H$DA@YC0<IBPT08!! \A XA@PDA@PDA
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C.P''YUC''DZ-OP@;M3H)H3YZQVY K/A*:R6-%@ HH"H$DA@YC0<E@!! [E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@C-RY&2\Q*4=@AUOM3H)H3YZQP1&XB9X*Y2G&@ HH"H$DA@OD!!(]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E$3#8!!M+S4@
EPMOM3H)H3YZQP0LY&AMK::-T@ HH"H$)@HXG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A1TH".OP@U@0MOM3H)H3YZQP0L.<V<
$L+RR@ HH T(B (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ATC@0MOM3H)H3YZQP0+DQ:*WU52BBH0JBTZB (XG2@]
HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ER\C@0MOM3H)H3YZQP\QDQ8^PD@"L@HBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@UA@LC@0MOM3H)H3YZCF QDQ8^BJPRCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@ATD@0LC@0MOM3H)H3YZD1DQDP IL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P''@0LC
@0MOM3H)H3[3ZAD^FPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@T0P''@0LC@0MOM3H)H3ZR.2HIBPTE
L@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@KA@P''@0LC@0MOM3H)H3Z&D@<IBPTEL@8RCPHBJBTZB (X9Q0\
GA0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,DA@P''@0LC@0MOM3H)H3Y_FP<IBPTEL@8RCPHBJO[&\#3;SO!!/030[E1XTA XA@PDA@PDA
@@@@@@@@@@@@@@@@@@@@@@@@@@@@I PDA@P''@0LC@0MOM3H)H3Y_FP<IBPTEL@8R8OQ2+IG*6O<8W%;FSO-0E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@
@@@@@@@UA@PDA@P''@0LC@0MOM3H)H3Y_FP<IBP:I!!^O\^#*(Y<H,KB0,Q4]^?43;\AXTA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@ATDA@PDA@P''@0LC
@51A_3H)H8>^08&EV_1#S&48V20,KB0,KB1^Q4]GW/?8UW@TA XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@Z0,DA@PDA@P''@0LCWDE%K8,91IROSWE:N,^A
^7-;KE-[V:H,KC#IND]GQ:K?#EU0A XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@B5LDA@PDA@P''@0M,PVT/"7#7N[P/ST56N,]''NF6(S-!!''("0,]^):6LIG
Q4\,]X1UU XA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@A7B5LDA@PDA@P''CF1AYR?@^FX/*S&+K45"=VM#R/3<N%,,KE:(SC0<$] 8Q4]GNLZLUUXA@PDA@PDA
@@@@@@@@@@@@@@@@@@@@@B(KB5LDA@PDAB\G[DE%K:%8&%AR!!:-8*2=FL:BE,D+GW"0,NM"Q&0(XOIEWY3 8]U^LUUXA@PDA@PDA@@@@@@@@@@@@@@@@@@@@
EP,KB5LDA@PD@0],PVT/*W"ZTL)X,YM)^J,#Q,> N#!!;KE9'':*12B (XG31U>E]WU81/UUXA@PDA@PDA@@@@@@@@@@@@@@@@@@A+B0,KB5LDA@QBA61AYR>)
N[RG2$ HL&FV&''"BH7OO-''-;V<]:)0(ZB (XG2@<>6=/UUUUU XA@PDA@PDA@@@@@@@@@@@@@@@@@@A7B0,KB5LDA@0GWDE%?.%8''I_JR@ HQLQ \;!!8 "N#
$L9[S/3& BTZB (XG2@]F7A0\G@TA XA@PDA@PDA@@@@@@@@@@@@@@@@@B(KB0,KB5LDC@]\PW=]:N"Z%<)H,+JF-8''2XB9]NU<-&DD-7OPBJBTZB (XG2@]
HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@@ERXKB0,KB0LLA51A#3V[6#VXM5QC 8MY&T)#-TEMN3%*KY#V.H@BJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA
@@@@@@@@@@@@@@A+I"XKB0,K@01<73Y?/:>FW9]9(I%JX3)N[V^AV;YA''/@)Z%6XPYJ@JBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@@@*I"XK
B0,CCG2U46F.&35ZTOF_N+M-Y8E[V5.AY<^5PW?=)%>T$K*0 BTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@@AT&I"XKB4H?CG0=]&AP''[=P$JE>
_%-[V8E'',3)JVWQ4'';E%K3-I$E"''9"TZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@ER(&I"XK@4H?CM^//R83X,*P(W9>_&5NX9&CP;^23P<E]CQ%
T&KJL?*D&>DZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@@J"(&I%LC@4H?CG2U/-#,K.:!!6S)J&[67,"HHQBPPFP<IA]3-5T79MD3\\!!(ZB (XG2@]
HQ0[E1XTA XA@PDA@PDA@@@@@@@@@@@UJ"(&T0LC@4H?C@1<G*>> 8N=;=6J"!!9@B@ HQBPPFP<IBX&DN-#XSHR[=BTZB (XG2@]HQ0[E1XTA XA@PDA@PDA
@@@@@@@@@AT*J")SI0LC@4H?C@0LA0\SJ==(R1DQG!!9@B@ HQBPPFP<IBPVI!![B0]KB@JBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@@AT*J ,DI0LC
@4H?C@0LA0\GA1L1R1DQG!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@@EQT*B0PDI0LC@4H?C@0LA0\G23D1R1DQ
G!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@UER(KA@PDI0LC@4H?C@0LA0\GD2,1R1DQG!!9@B@ HQBPPFP<IBPTE
L@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@@@@UEP,KA@PDI0LC@4H?C@0LA0\GD2,1R1DQG!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]
HQ0[E1XTA XA@PDA@PDA@@@@@ATU]0,KA@PDI0LC@4H?C@0LA0\SD2,1R1DQG!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA
@@@@Z1U7B0,KA@PDI0LC@4H?C@0LA0\SD2,1R1DQG!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@@ER(&B0,KA@PDI0LC
@4H?C@0LA0\SD2,1R1DQG!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@A+J"X&B0,KA@PDI0LC@4H?C@0L.P\SD2,1R1DQ
G!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@@@UJ"X&B0,KA@PDI0LC@4H?C@0LA0\SD2,1R1DQG!!9@B@ HQBPPFP<IBPTE
L@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA@ATUJ"X&B0,KA@PDI0LC@4H?C@0LA0\SD2,1R1DQG!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]
HQ0[E1XTA XA@PDA@PDA@ATUJ"X&B0,KA@PDI0LC@4H?C@29A0\SD2,1R1DQG!!9@B@ HQBPPFP<IBPTEL@8RCPHBJBTZB (XG2@]HQ0[E1XTA XA@PDA@PDA
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 222 230 248 232 238 250 250 251 254 251 252 254 235 240 250 223 231 248 247 249 253 240 244 252 236 241 251 229 236 249 252 253 254 248 250 253 233 238 250 234 239 250 237 241 251 238 242 251 243 246 252 233 239 250 246 248 253 224 231 248 254 254 255 224 232 248 225 232 248 229 235 249 237 242 251 230 236 249 225 233 248 226 233 248 227 234 249 242 245 252 228 235 249 228 234 249 226 234 249 239 243 251 142 163 201 238 243 251 230 237 250 253 253 255 250 252 254 231 237 250 193 206 229 253 254 255 245 248 252 212 209 221 153 171 206 93 121 174 131 153 195 234 240 250 245 247 253 165 182 214 70 102 163 196 203 217 177 190 216 77 108 166 77 108 167 214 212 225 196 209 231 222 222 232 150 169 204 226 232 245 242 244 248 242 244 242 249 250 253 241 245 252 66 99 161 249 251 253 233 237 245 239 243 252 248 250 254 97 124 177 210 208 221 203 213 232 120 144 189 226 228 237 244 247 252 222 225 237 89 118 172 221 220 230 148 167 203 113 138 185 246 249 253 74 105 164 252 252 254 201 210 228 222 228 241 222 230 245 218 221 233 145 164 202 229 233 242 197 207 228 214 211 222 208 218 233 156 174 208 213 210 223 189 201 225 58 92 157 61 95 159 80 110 168 224 225 235 161 178 210 83 113 169 170 186 214 216 214 225 244 247 253 173 189 218 192 205 228 254 255 255 207 216 233 218 216 226 214 223 238 222 226 240 224 231 246 215 222 235 229 234 246 98 125 177 230 234 244 216 216 228 213 217 231 253 253 254 198 210 232 78 108 166 224 227 237 213 210 221 247 249 252 225 232 238 216 212 222 85 114 170 231 237 249 215 212 222 185 199 224 232 234 242 226 230 240 231 236 246 237 240 248 111 136 184 105 131 180 234 238 248 241 244 252 181 195 221 219 223 236 232 235 239 221 228 227 87 116 171 76 107 165 224 228 240 194 206 228 105 131 181 125 148 192 244 246 249 102 128 179 110 135 184 108 134 182 229 231 239 167 184 215 228 233 244 164 181 212 184 197 221 87 116 172 190 198 218 195 205 224 186 189 210 212 209 222 99 126 178 235 240 251 186 200 225 191 204 227 228 232 244 218 218 229 183 198 224 217 224 239 177 192 220 227 231 243 94 123 175 128 150 192 240 242 247 230 235 246 63 96 159 238 241 249 221 219 229 166 183 214 188 195 217 183 187 209 235 240 247 163 180 212 248 249 253 138 159 197 243 246 253 57 91 156 234 236 242 237 238 243 178 192 218 182 196 223 149 168 198 214 211 225 224 231 243 165 182 213 167 183 213 217 218 231 218 217 228 180 193 218 218 219 230 79 109 167 247 248 253 236 240 251 236 241 250 160 170 199 73 104 163 169 185 177 185 197 211 71 103 163 190 201 222 209 218 192 109 131 177 67 100 162 246 248 251 219 221 232 220 217 226 225 232 243 255 255 245 227 231 241 239 242 248 119 143 157 245 247 252 232 237 249 229 236 248 232 237 250 230 233 244 225 231 223 228 235 248 229 235 247 216 224 211 212 221 237 195 207 230 222 224 235 138 159 155 135 153 191 207 208 222 103 126 176 237 239 245 147 167 204 78 108 165 159 177 210 196 207 227 230 236 248 191 199 220 230 237 249 191 204 228 220 223 236 111 132 179 211 215 230 224 229 242 226 229 239 139 160 200 141 162 200 216 217 229]; yourself]

    "Modified: / 11-04-2008 / 11:32:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

module_rep
"      Loaded from: /tmp/full/obj16/module_rep.gif"

    "
     self module_rep inspect
     ImageEditor openOnClass:self andSelector:#module_rep
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class module_rep'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0A@PDA@P0LC@0LC@0LC@0KBP$IBP$DC@0LC@0LC@0A@ H@@@@B@ DA@PDA@PHL@P$IBP$IBP$I
BP$IBP$DC@DIBP$IBP$IBP$IBP$IA@0ABP$B@PHIBP(JB $IBPPL@P$BA0XA@PDJBP(JBP$DC@DI@PLC@0 FB $KB0,IA@0ABPDC@0 FAP(IBP$KBPPL@P$A
@0 FAPTJBP$IB0$DC@DI@PXFAPTEB $IBP,IA@0BA@HDA@PDA@(KB0,KA@HLC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[190 191 127 128 128 0 159 159 63 255 255 159 95 95 63 223 191 63 255 223 95 255 191 63 255 223 159 255 255 255 128 128 128 95 95 95 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@A<@O8A??7??_?=??7??_?=??7??_?=??0@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

newconnect_wiz
"      Loaded from: /tmp/full/wizards/newconnect_wiz.gif"

    "
     self newconnect_wiz inspect
     ImageEditor openOnClass:self andSelector:#newconnect_wiz
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class newconnect_wiz'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H2L#H2L#H2L#H2L#GRL#H2L#H2L#H2L#H2L#GP0]H2L#H2L#H2L#H2L#B0,LB0,#E!!XVE!!XVE!!XXEQ@PDA@PG0D!!G XFG XFG XNC LNC"LABP$^BPX[G $^
G!!0"GBL#H@$!!HP$!!BQ8IBQ8IB"L#H1D^F!!HZHQ(^A18GA0<#H2LMA0\RD \RD \^G \MH2L#CQHRD!!HRD!!HRD!!HRCRL#H1PTEAPTEAPTEAPTEAP#H2L#H2L#
@ HB@ H#H2L#H2L#FPPDE0H^G!!8BE0PDFRL#H0 EAPTBC@0C@ TEAP #H2LYA@PW@ALHB@@WA@PYH2L#H2L#H0@@@@@@H2L#H2L#H0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[111 111 20 186 185 154 155 156 28 249 228 170 155 152 117 185 173 119 245 247 250 118 133 163 230 191 108 134 154 191 153 116 19 181 146 35 255 254 239 157 168 175 166 130 26 220 221 218 253 244 207 170 171 168 233 248 255 247 209 119 149 161 182 192 164 80 197 188 153 145 144 108 232 228 212 155 156 137 127 143 176 143 161 195 158 121 22 186 151 38 255 255 255 174 138 31 177 177 175 244 249 253 251 221 131 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@ @G@@>?????/?<??#?>O?8??#?>@>@??#?>O?8C8@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

newconnect_wizban
"      Loaded from: /tmp/full/wizban/newconnect_wizban.gif"

    "
     self newconnect_wizban inspect
     ImageEditor openOnClass:self andSelector:#newconnect_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class newconnect_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y\V=UVU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y\V=URUUUVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y\WEUUUUUUT%/VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU%YVU%YVU%YVU%YVP51[5UU[4%/RUUUVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y
VP51\WEUUUUUUUUUUT%/VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU$MCWE1[5UUUUUU[4%/RUUU
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YCP4M\WE/[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU$MCP51\V=/[5UUUUUU[4%/RUUUVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y\P51VWE/[6=U[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU$MCWEY\V=/[6=/[5UUUUUU[4%/RUUUVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y\P51VWE1[6=/
[6=U[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVP4MCP4MCWE/[6=/[6=/[5UUUUUU[4%/RUUU
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YCP4MCP51CV=1[6=/[6=U[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU$MCP4MCP51\V=/[6=/[6=/[5UUUUUU[4%/RUUUVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%Y
VU%YVU%YVU%YVU%YVU%YCP4MVWDMCWE1[7E/[6=/[6=U[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YND=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=OS4=O
S4=OS4=OS7)/[6=/[6=/[6=/[5UUUUUU[4%/RUUUVU%YVU%YVU%YVU%YNG)YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%1VWE1\Q4]]GQ4X&H*!!W)1[6=/[6=/
[6=U[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YNG)YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVWE1\RI1GWQ4]FI"X&H*I7)/[6=1[6=/[6=/[5UUUUUU[4%/RUUU
VU%YVU%YVU%YVU%YBW=YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%1VWD"\Q4]]GQ4X&H*I7)/\V=/[6=/[6=U[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YBW=Y
VU%YVU%YVU%YVU%YVU%YVU%YVU%YVWE1H''E1GWQ4]FI"X$$*I7=1[6=/[6=/[6=/[5UUUUUU[4%/RUUUVU%YVU%YVU%YVU%YBW=YVU%YVU%YVU%YVU%YVU%Y
VU%YVU%1CRI1\Q4]]GQ4X&H*"FJHR''=/\V=/[6=/[6=U[5U/UUUUUUUUUT%/VU%YVU%YVU%YVU%YBU9YVWD*Q75="15YB#<("5%YVU%YJ(:N#''E5_W4#X''Q"
X&VD!!ERHR''=1[6=/[6=/[6=/[5UUUUUUUUUURT%IVU%YVU%YVU%YVU%Y!!U9YB 9\C%0NC 9Y"08VC''QYVU%1WAXV[GQ\E%>F!!FI"J(QLSF2HR%9/\V=/[6=/
[6=U[5U/UT%IRU)ZV%)ZVU%YVU%YVU%YVU%Y!!U94E(&I"QXVE(QYH%<VE&UYVX]4!!$1L#!!4NSD1&SGVHJ&1&D%15CE91[6=/[6=/[6=/UT%IV%)ZV%)ZV%)Z
VU%YVU%YVU%YVU%Y!!XJDE%<VJ%%1"6UYVQYLS@91CP6NY&Y&X''PVD!!HRD!!ZH"E0=OX15CE9/\V=/[6=/UT%IRT%ZU5)ZV%)ZV%)ZVU%YVU%YVU%YVU%YI8JL
SD0VVU%YVU%YVQLRD!!H"\RJID#6I]GRFOS4=T#52"@9RT%-5M8I1[6=/[4%IRT%"RU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YI8I\D!!HRE )YVU%YVP(=OS6N
\WERT%JD]FILT"DRHRDR"GM XAY.XXI/[5UIRT%IRT%IV$%ZRU)ZV%)ZV%)ZVU%YVU%YVU%YVU%Y^XD*OS4=T%HR_U%YVU$RT"DV\RL!!HRFHX&HRXFA\_G1<
#AY<_CZRXXEURT%IRT%IRT%IU4%WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%Y^XEY"34!!HRD!!HQYY\WDN_BER]AY<_FY"X( RTUFD!!%EQXHY-[XYTXXEIUT%URT%I
RT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YKXEYVRH#D''1<_G1%H''E5TUEQYREQTX1""B*Q[V5,$%D[F1H[F5YTK(EURT%IRT%IRT%I"D%WV%)ZV%)ZV%)Z
VU%YVU%YVU%YVU%YKTMYVU%YVW5Q[UFI\WE1XF4[!!!!,[F8-""H !!F4I,]UYBP!!-BP&X%K$MIUT%IRT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YYDMY
VU%YVU$!!F1,VH''D]U$H[TTIB$X"H"H!! P%6L]RT[WU5]WQH%K$MURT%IRT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YM4NL_HXS_VYBP$I[GQ54[DI]
WTI]\8"H]X 1WU6LYUP6WU4@WS5SN4MIUT%URT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YM2$=P%5BWU5BWV4*]GQ4X$I]WU5]UH!!5"GUQ@@AM[)IT
P @@@IESN2%URT%IRT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YXR$1WU5]WU5]_GU4]GQ"X)D@@@A<"H-5]WU-@@A[$%QT @@@@IE(N2%IUT%IRT%I
RT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YXT:GYX1VU%-=]GQ4X&I"J%Q\F(12"GU5]WTZV5-(UEP%T3X6M)A;ID9URT%IRT%IRT%I"D%WV%)ZV%)ZV%)Z
VU%YVU%YVU%YVU%YBD8M\WE1GQ54]GQ"X(!!""H"H"H!!5]WU5YV9T$%QTUEM=T5M(ZF!!;ID9IUT%URT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YBD91
\RH]GWQ4]FI""FH*"H"H"7U5]WU5UF9TUEQTT5MST6!!(^7-PAT9URT%IRT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YEF%1\Q4]]GQ"X&I""H"H"GVH
]WU5]VVR$%RRIUMST5M(T7-;^5APAV%IRT%IRT%IRT%IV%]WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YE@XWZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZQ\WE1\WE1\WE1\W
E1\WE4YFA!!]"J&H*U2(*"H"H"H"H"H"HV%)ZV%)ZVU%YVU%YVU%YVU%Y]A0\GA0\#!!2NGH8\#!!2NQ4\#H6L5\B,UEQTUEXRD!!HRD!!HRD!!HRD!!BNH"H"H"H"H
"H"H"H"H"H"HV%)ZV%)ZVU%YVU%YVU%YVU%YVU%YVU%YVU$MVU$MVU%1H''@KB0,KB0,KB30*J"(*J"(*"B*HJ(.H"8"K"H,*"8.K"8.K"8.K"8"HV%)ZV%)Z
VU%YVU%YVU%YVU%YVU%YVU%YVU%YCU$MCRH]]@,CK2</K2</H@.KJ(,X"8.K"8.K"8,X"8.K"8.K"8.K"7VK"8.K"E)ZV%)ZV%)ZVU%YVU%YVU%YVU%YVU%Y
VU%YVU$MVU%1H''Q4P@,/R4-KR7 4Z0.K"8.K"8.K"8.K"6VKYX-%"6U%"6U%YVVK"8-ZU5)ZV%)ZV%)ZVU%YVU%YVU%YVU%Y 0DA@PE>_ DAL79>L3L3L0,/
R3$9NT,4FP-XVE!!XVE!!XVE!!XVE!!XVHI%YVU%YVU%YVVK"E)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YR0HB@ HB@ HB@ HB@ HB@ ,/#3$9NT,4FP,B@ HB@ HB
@ HB@ HB@"=%G6TQYQ=%"8.HU5]WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YNPPDA@PDA@PDA@PDA@PDA@,/#3$9NW"MFP,DA@PDA@PDA@PDA@PDAHT_G1<_YVU%
"D%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YRA8^G!!8^G!!8^G!!8^G!!8^G ,/R4-KR22MFP,^G!!8^G!!8^G!!8^G!!8^G#1=G1=%YX,*RT%I"D%WV%)ZV%)ZV%)Z
VU%YVU%YVU%YVU%YVU$MH''Q4J!!"KYVT_G1<__P,/#X6M#X44FP-''Y6]''Y6]''Y6]''Y6]''Y6]''G1>KJ$%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YVRI4
PDA%YQ<_Y6]''Y6]''Y0,CZ6-+Z6-+H@-''Y6]''Y6]''Y6]''Y6]''Y6\_"2)IRT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU&JH''Q@FFU%G6]''Y6]''Y6]''Y2,K
B0,KB0,KB7]''Y6]''Y6]''Y6]''Y6]''G6VHRT%IRT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%1H''Q@J$@XFA X"1 X"1"KFH.K"8.K"8.K"6VKYX-%"6VK
YX-%"6VHJ$%URT%URT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YVU%Y"%&JVWEY\X)1VWFJ\WD"\WD"\WE1[7D][6=/GV=4[5UUUUUURUUIRT%IRT%I
RT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YVU%1VP5Y\U%1VWEY\U%1\WE1\WE1[7E/\V=/[6=/[5U/[5UU[4%/RUUIUT%URT%IRT%I"D%WV%)ZV%)ZV%)Z
VU%YVU%YVU%YVU%YCU%YCU$MVP5Y\U%1CWEY\WE1\WE1\V=1[7E/[6=/[6=U[5UUUUUURUUIRT%IRT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU$MVU$M
VP5Y\U$MCP4MCU%1\WE1\WE1[7E1\V=/[6=/[6=/[5UUUV=IUUUIUT%URT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU%YCU%YCU$MVWEYCP4M\WEY\WE1
\WE1\V=1[7E/\V=/[6=U[5UUUUUURUUIRT%IRT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU$MVU%1VP5Y\U$MVWEY\U%1\WE1\WE1[7E1\V=/[6=/[6=/
[5UUUV=IUUUIUT%URT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YCU%YCU%YCU$MVWEY\U%1CWEY\WE1\WE1\V=1[7E/[6=/[6=U[5UUUUUURUUIRT%IRT%I
RT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU$MVU$MVP5YCP5YCP4M\U%1\WE1\WE1[7E1\V=/[6=/[6=/[5UUUV=IUUUIUT%URT%IRT%I"D%WV%)ZV%)ZV%)Z
VU%YVU%YVU%YCU%YCU%YCU%1VWEY\U%1CWEY\WE1\WE1\V=1[7E/[6=/[6=U[5UUUUUURUUIRT%IRT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU$MVU%1
VU$MVP5YCP4M\U%1\WE1\WE1[7E/\V=1[6=/[6=/[5UUUV=IUUUIUT%URT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVU%YCU%YCU%Y\U$MCU%1VWEY\P51CWE1
\WE1\WE1[6=/[6=/[6=U[5UUUUUURUUIRT%IRT%IRT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YVU$MVU$MVU$MVWEYCP4M\U%1CWE1\WE1[7E/\V=1[6=/[6=/
[5UUUV=IUUUIUT%URT%IRT%I"D%WV%)ZV%)ZV%)ZVU%YVU%YVP5YVU%YCU%Y\U$MVP4MVWDM\P51CWE1\WE1\V=1[6=/[6=/[6=U[5UUUUUURUUIRT%IRT%I
RT%IRU)WV%)ZV%)ZV%)ZVU%YVU%YVU%YCU$MVU%1VU$MVWEYCP4MCP4M\WE1\WE1[7E1\V=1[6=/[6=/[5UUUV=IUUUIUT%URT%IRT%I"D%WV%)ZV%)ZV%)Z
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[34 57 106 170 160 88 225 213 130 196 180 113 241 235 186 144 166 173 82 117 119 199 209 212 171 185 183 233 218 195 231 236 236 130 119 41 195 193 183 246 249 253 170 173 191 215 224 238 246 242 216 213 209 221 132 138 165 194 197 210 163 181 181 189 201 208 160 165 186 107 137 140 225 222 230 216 193 121 171 187 218 76 90 129 207 217 217 238 241 247 157 143 44 210 205 216 190 168 93 109 117 148 243 242 246 196 203 213 152 170 174 197 210 230 234 232 237 212 204 188 213 217 226 136 154 148 228 228 236 147 143 92 252 240 206 198 200 188 172 180 178 220 205 150 189 193 209 85 108 144 207 201 213 165 155 84 250 231 180 197 202 166 148 165 193 187 193 185 244 225 198 254 249 235 222 224 236 161 175 176 181 173 135 124 130 158 251 246 241 219 217 228 233 231 237 175 177 193 65 81 123 153 162 151 216 209 168 250 232 183 103 134 139 201 211 214 230 226 202 227 234 249 203 197 185 253 243 216 147 150 173 165 178 203 124 147 145 235 195 141 180 196 221 89 100 137 117 123 153 194 206 228 202 211 230 233 238 250 138 152 181 224 231 248 161 150 81 254 254 255 222 230 248 162 173 198 179 182 200 52 70 115 199 187 160 158 160 180 103 112 146 181 187 181 229 234 243 133 133 59 194 198 187 213 213 226 138 144 170 204 197 209 189 203 227 113 141 142 224 223 234 218 198 132 181 188 208 81 94 133 206 217 234 236 241 251 177 175 121 242 245 251 195 202 220 158 170 196 235 237 244 211 220 236 225 231 243 158 148 104 252 241 210 203 203 189 229 204 167 186 199 224 96 108 141 202 205 216 168 158 86 215 195 164 152 167 196 169 171 154 185 180 157 234 231 213 186 198 206 220 212 190 149 156 178 254 249 243 221 227 241 166 169 188 248 247 250 219 221 234 172 180 202 251 234 190 205 213 218 252 246 225 164 180 214 113 127 162 203 214 232]; yourself]

    "Modified: / 11-04-2008 / 11:32:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

newfolder_wiz
"      Loaded from: /tmp/full/wizards/newfolder_wiz.gif"

    "
     self newfolder_wiz inspect
     ImageEditor openOnClass:self andSelector:#newfolder_wiz
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class newfolder_wiz'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
K2</K2</K2</K2</K2</K2</K2</K2</K2</K0$/K2</K2<%IRT%K2</K0$@BR</K2<-K"8.K"4/K0\H@@ HK2<%@PDED!! ^G1@C@0XF@1@/IPHB@ HB@ HD
C0<JC 4/K2XKB0,KB0,KB14LDP0 K2<''D1LSD1LSD1LSF!!PZI2</H!!TUEQTUEQTUEQTYERL/K2PWE1\WE1\WE1\WE1\$K2<+E!!XVE!!XVE!!XVE!!XVHR</JQ0\
GA0\GA0\GA0\GB$/K20[F1,[F1,[F1,[F1,(K2</J"(*J"(*J"(*J"(*K2</K2</K2</K2</K2</K2</K2</K2</K2</K2</K2</K0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[254 253 239 252 240 184 255 245 204 253 244 207 255 251 235 249 233 177 253 243 207 181 145 35 181 146 35 186 151 38 252 231 163 255 241 194 158 121 22 166 129 26 166 130 26 165 130 26 174 138 31 251 221 131 242 223 168 255 235 179 153 116 19 255 229 164 255 218 137 255 223 150 236 211 156 255 241 210 255 243 217 255 209 117 255 213 125 255 248 234 229 200 145 220 183 128 240 225 203 183 125 49 191 131 52 191 132 52 187 128 51 199 139 55 197 137 54 194 135 54 177 119 47 180 121 48 175 117 47 183 124 50 177 119 48 179 112 38 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@BA8\O39??7?>_?9??''?>_?9??''?>_?8??@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

newfolder_wizban
"      Loaded from: /tmp/full/wizban/newfolder_wizban.gif"

    "
     self newfolder_wizban inspect
     ImageEditor openOnClass:self andSelector:#newfolder_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class newfolder_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O-$O@3<?O3<?O3<?O3<?O3<?O
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O-$O@),C@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O-+[@0LC@0JYC3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O
3<?O3<?O3<?O3<?O3<?O3<?OQTV6P<C@P:YC),C@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O
34V6QTMC0LC@)$N&P:YC3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<=EQ[Z6P4O@0LC@0LC@0LC@
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?OQTUE-+YCP<AC0LC@0JYC)$N&3<?O3<?O3<?O3<?O3<?O
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<=EQTV6-$MCP<C@0LAC)$N&P:[@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O-$V6Q[YCP4O@P<AC),C@0LC@0LC@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O
3<?O3<?O34UEQ[[O-$MCP4MCP<C@P<AC)$N&P:[@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?OQTV6QTV6P4MC
P4O@P<C@0LC@0JYC)$N&3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O34UEQTUEQ[YCP4MCP4MCP<AC0LC@0LC@0LC@
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?OQTUEQTUE-$MCP4MCP4O@P<C@0LC@0JYC)$N&3<?O3<?O3<?O3<?O3<?O
3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<=EQTUEQTUEP4MCP4MCP4MCP<AC0LAC)$N&P:[@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O
3<?O3<?O3<?O3<?O3<?OQTUEQTUEQ[YC-$MCP4MCP4N&P<C@0LC@0LC@0LC@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<=E
QTUEQTUEQTMCP4MCP4MCP4MCP<AC0LAC)$N&P:[@3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O34UEQTUEQTUEP;YCP4MCP4MC
P4MCP<C@0LC@0JYC)$N&3<?O3<?O3<?O3<?O32F?''$:?/;>?/;>?/;>?/;>?^K963<?O3<?O3<?OQTUEQTUEQTV6P4MCP4MCP4MCP4N&P<AC0LC@0LC@0LC@
3<?O3<?O3<?O3<?OW@$H3<?O3<?O3<?O_<=?_7=?_;''H!!<?O3<?O34UE34UEQTUEQ[Z6P;YCP4MCP4MCP4MCP<C@0LC@0JYC)$N&3<?O3<?O3<?O3<?O/63O
3<?O_7=?*J"(*J"(*J"(*J!!#S''?O3<?O34WOQTUEQTUE-+YC-$MCP4MCP4MCP4O@P<AC0LAC)$N&P:[@3<?O3<?O3<?O3<>9/,?O*J"(*J"(*J"(*J"(*J"(
*J"(UT+O3<=EQTUE34UEQTV6-$N6P;YCP4MCP4MCP4MCP<C@0LC@0LC@0LC@3<?O3<?O3<?O3<>?O7<TEAPTEAPTEAPTEAPTEAPTEAPTE@.G3<=EQTWOQTUE
QTV6P;Z6P4MCP4MCP4MCP4N&P<AC0LC@0LC@)*Z&3<?O3<?O36M,[A*>*KF%O#OFZF#J1\VRPEVQ$XVER$+K/< I[F1,[F1,[F1,[F1,[D66P;YCP4MCP4MC
P4MCP<C@0JZ&)&)*Z&)*3<?O3<?O30-J!!<UB,[ >_W631%9(ZATU1\VRPDAUUYFQ_G1<!!XVE!!XVE!!XVE!!XVE!!Y9C-$MCP4MCP4MCP4MC)*Z&Z&)*Z&)*Z&)*
3<?O3<?O30.[*K"8.K"8.JV8.JV%)["8O+"8O+"8O+"8.K"8.K"8.K"8.K"8.K"%)QZ6P;YCP4MCP4MC)*Z&)*Z*)&)*Z&)*Z&)*3<?O3<?O37"[*C8>O#8>
O#8>O#8>O#8>.C8>.C8>O+ >O#8>O#8>O#8>O#8>O*V%_QZ6P4MCP4MCP:Z&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O38B[*C8>O#8>O#8>O#8>O#8>O#8>O#8>
O#8>O#8>O#8>O#8>O#8>O#:3,4.6P;YCP4N&)*Z&)*Z&**Y*)&)*Z&)*Z&)*3<?O3<?O3;0 !!C9YO#9YO#9YO"(>J#8>VS8>VS8>VS8>VS8>VS8>VS8>VS8*
O"(2ZHN6P4MC)*Z&)*Z&)*Z&)*Z5Z&)*Z&)*Z&)*3<?O3<?O3:</!!E$2VU$2VU$2VU%YVU%YL%%YL&X>VU%YL%%YL%%YL%%YL%%YVR(3Z@UC)*Z&),B&)*Z&
)*Y*)&*&Z&)*Z&)*Z&)*3<?O3<?O3;.,!!E%YVU%YVU%YVU-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5.RUXLC@0LC@0LC@0LC"ZZ&Z*Z5Z&)*Z&)*Z&)*
3<?O3<?O3:>,,SL3L3L3L3L3_D=JR$)JR$)JR$)JR$)JR$)JPT)JPTEAPTFW%9^4-KR4-KR4-KPPS$9N@ZZ&)&*&Z&)*Z&)*Z&)*3<?O3<?O3;.,.J\3)3N''
L:^''*3SO3<?O3<?O3<?O37U5]XRD!!K 2L#H2L,[FKR4-KR4-KR4-K\)0(2MNYJZ&Z*Z5Z&)*Z&)*Z&)*3<?O3<?O3:>,.CN''):^''):]<@\>(L+!!^W%;J(7B#
(<%0(<%0[7B#(7B#(<%0(6=0(7B#\JM0(6=0(80K)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3;.,.K6''RZ^=)<)N],10(7A/(6>#2ZM/2V=0[<&#[7A/[7A/[7A/
(6=0[:M/[7A/[<&#H<!!$)*Z&Z*Z5Z&)*Z&)*Z&)*3<?O3<?O3;.,O$%IRT%I/RUO325/[6?I[<%/2\''I[6=/\F=/(6?I[6=0[6?I[:M/2V=0[6=0[6=/AL"*
)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3;.,O+6=/[6=/Z,?,!!.SF9L[F1-/[1,7F:M/[6=/$3\7$F>S#S^_[6=/[6>Z&)A/[6<#2H"&)*Z&**Z5Z&)*Z&)*Z&)*
3<?O3<?O3:>,Y+6=/[6=I\"(M7]7]3\7M5I/[3\7#X=/[6=/''9*Z[6<[&)(&&&=/[9@&SIM/[6<D2J*&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3;.,''K6=/[6=
FP!!RM3\7[6=/[6=/[3^Z&!!-/[6=!!I"X&[6<7SD1LSC]/[9M"X,I/[6''H"JZ&)*Z&Z*Z5Z&)*Z&)*Z&)*3<?O3<?O3:>,RZN=(4"U%&MV&)(73,;N3,;N3)5L
SD3N3&=7SFI73,:_X&I"A&I/3!!,FA,7NZ[_H**Z&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3;.,/[6#(:LY[B6SSD1LM<;N3,;N3,9"X&I!!3,8FA [N3,:ZA*IL
(*IL3&VF!!#])Z\ /)*Z&)*Z&**Z5Z&)*Z&)*Z&)*3<?O3<?O3:>,''JN#(7:^C\;NX&I"A YL\\;NZ\9LA*H73(:"(*KN3,9L!!(ZSV%)Z0#]ZV 1)AD:I)*Z&
)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O34Z,\JN#(:-J2#*)VFJ"(*J"(#^)N#([V*HFN#]ZV"Z)3*%L[&9R''69.!!)>Y&Y=>2B>&)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*
3<?O3<?O3;.,@ HB,AXM*Z&)*Z&NSE)ZV%*O*Z''A[&9.#:I.[,J)*V&$&Y&PDV8^G$0^G%\DS(&&)*Z&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O34Z,@ HB%$GJ
*Z&)*Z&)*WE.&V97*Z&)!!)$^''18^G*&)*Z&"G%>P*U]_W19_W2[HK:Z5-[V5-Z**********Z&)*Z&)*3<?O3<?O3:<_^PJ:E ")*Z&)*Z&)*Z&"G!!87*Z&)
U5<^[%=_)J&)*Z&FW8GB*Z$^ XFA T1NM*******************Z&)*Z&)*3<?O3<?O34Z,^W%+ GB)*Z''BV)>]\RY_W5?M*Z&)$E>A U>AYZ&)*Z$5 XGB
*Z$L XD@ VIA0<OC0<OC0<OC0<OC**)*Z&)*Z&)*3<?O3<?O3;.,^[)KF*%]*Z%"W8E_ XE_ Y&)WZ$W*U>A XFA*U6)WZ%.@@@)*Q^)W0@@@JSGVE!!XVE!!X
VE!!X0<N**&)*Z&)*Z&)*3<?O3<?O3;-A^Z.BH:%]*U45 XFA XFAV,F)WZ%]*PX@@@AZ*U6).*&Y@@CM*[*0,@@@@JRO#8>O#8>OKH=X0:**Z&)*Z&)*Z&)*
3<?O3<?O3:>JQHLZ*[*).*$W#<IWU<51E55]E;*).*$WE55]WU6).!!\R3\49.#B7OP0LCJ:O(X>!!#8>O0U"**+V&Z&)*Z&)*Z&)*3<?O3<?O3;.J%(-0WU5]
WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]W[*:,K(0OS6UA@SH%:F!!(ZFO#8=X0:)*-ZZ5Z&)*Z&)*Z&)*3<?O3<?O3:=T 2!!].%6:W[)].%5]WU5]WU5]WU6:
W[)].+*:.+*:,AL0LIT0%YTD#L,I]B\''(ZF!!KLN*-ZZ&)&*&Z&)*Z&)*Z&)*3<?O3<?O3;.K 1N:.+*:.+*:.+*:.$Q]QK)DWTR:.+*:.$QDQAL0LC@=OYVU
AH2L#D9NI2^!!#8=X*+V&)*Z&Z*Z5Z&)*Z&)*Z&)*3<?O3<=?GJ<ER:.+*:.+*:-+Z6-+Z6-+J2,+J2,(J2,+J2,+J2 +J2,+J2-+2F^+/)94I:FOKLN5)*Z&
)*Z&)&*&Z&)*Z&)*Z&)*3<?O35@;VGP]GQ4]&I"X&F5-[V5FQ$X.K"8.K''M3K"H"H"H"/BH"/K2</K0PDA@PDI^!!#23C**Z&)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*
3<?OOA1PN3.T%IRT%IRT%IRT%IRT%IRT%E!!XVIQX%E"TVIQXVE!!XVE!!XVE!!XVE!!XVE!!X*+V&)*Z&)*Z&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3<?O3<?O3<?O
34WOQ\=E3;[O-,>6Q[Z6-+Z6-$N6-$N6P4MCP4MCP<C@0J[@),B&)*[@)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*3<?O3<?O3<?O34WOQ\=E34WO-,>6QTUEQ[Z6-+Z6
-+Z6-+YC-$MCP4MCP4O@P<AC0LC@),B&0JZ&)*Z&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3<?OQ\?O3<=E34WOQTWOQTUEQTUE-$V6-+Z6-$N6P4MCP4MCP4MC
P:YC)$N&P:[@)*Z&)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*3<?O3<?O3<?O34WOQ\?OQ\>634UEQTUEQ[YE-+Z6-+Z6P;Z6P4MCP4MCP4MCP<C@0LC@),B&0J[@)*Z&
)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3<?OQ\?O3<>634WOQTWOQTUEQTUE-$V6-+Z6-+Z6P;YCP4MCP4N&P<C@P:YC),C@)*Z&)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*
3<?O3<?O3<?O34WOQ\?OQ\>63;[O-,>6Q[YE-+Z6-+Z6P;YC-$MCP4MCP4MCP<C@0LB&P:[@),B&)*Z&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3<?OQ\?O3<=E
34WOQ\=EQTUEQTUE-$V6-+Z6P;Z6P4MCP4MCP4O@P<C@0LC@0J[@)*Z&)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*3<?O3<?O3<?O34WOQ\=E34UEQTWO-$UE-$V6Q[Z6
-+Z6-$N6P4MCP4MCP4MCP<C@0LB&0LB&0JZ&)*Z&)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3<?OQ\?O34WO34WOQ\=EQTUEQTUE-+Z6-+Z6P;Z6P;YCP4MCP4N&
P<C@0LC@0J[@)*[@)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*3<?O3<?O3<?O34WO3<>634WO-,=EQTUE-$V6Q[Z6-+Z6-$N6P4MCP4MCP4MCP<C@0LC@),B&)*Z&)*Z&
)*Z&)&*&Z&)*Z&)*Z&)*3<?O3<?O3<?OQ\?O3;[O3<>634UEQTUEQTUE-+Z6-+Z6P;Z6-$MCP4MCP4O@P<AC)$N&0LB&0J[@)*Z&)*Z&Z*Z5Z&)*Z&)*Z&)*
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[34 57 106 184 160 93 247 209 119 213 210 198 204 169 83 117 72 5 117 123 153 245 232 188 214 197 154 159 125 34 230 192 107 172 147 71 148 165 193 238 223 190 227 233 246 247 224 157 166 137 68 203 214 232 171 187 218 224 182 85 252 248 228 233 210 158 140 100 14 234 193 99 222 226 237 169 133 39 201 176 123 170 173 191 241 239 242 134 98 54 76 90 129 181 154 109 198 176 128 241 233 209 155 124 62 236 201 123 239 209 137 219 184 100 138 144 170 205 199 211 191 151 69 165 178 203 248 233 181 182 142 49 216 215 228 244 214 155 148 115 59 188 169 121 219 179 85 249 240 197 249 227 188 247 228 169 243 240 228 85 108 144 216 215 215 160 165 186 167 136 73 189 203 227 239 201 114 231 227 234 246 245 247 214 176 84 248 235 188 218 205 169 220 194 135 177 153 90 238 227 189 237 241 251 228 186 86 247 249 253 144 110 58 166 135 58 247 217 139 246 222 154 187 164 98 132 89 13 132 138 165 212 204 179 164 133 44 176 149 70 238 236 240 215 216 229 189 193 209 150 112 18 171 133 70 213 190 132 175 177 193 138 152 181 219 218 230 248 230 173 96 108 141 227 206 141 236 229 211 233 191 92 245 221 168 65 81 123 244 209 132 206 209 220 124 130 158 245 233 206 203 196 172 158 170 196 249 226 164 170 138 50 235 216 167 234 197 114 222 230 248 177 135 47 200 183 136 141 106 57 89 100 137 242 205 124 242 211 140 202 205 216 191 155 71 152 119 61 188 172 150 253 243 224 230 222 198 166 169 188 171 142 75 246 204 105 224 231 248 249 246 240 202 178 106 243 230 185 226 188 102 252 251 243 163 133 72 52 70 115 143 106 39 125 82 9 253 243 220 199 174 107 103 112 146 224 212 179 196 184 147 220 222 223 179 143 77 135 95 33 199 163 77 158 160 180 198 202 215 213 213 225 181 188 208 209 183 119 225 198 142 179 182 200 226 223 230 210 172 83 167 125 39 171 147 83 137 102 55 81 94 133 147 150 173 194 172 124 249 222 154 194 197 210 153 117 22 149 156 178 212 209 221 209 204 216 109 117 148 247 212 127 113 127 162 247 236 193 227 234 249 247 226 163 253 250 236 237 197 107 221 227 242 172 131 45 181 156 114 158 127 65 164 180 214 151 118 68 219 181 93 250 240 200 250 231 193 242 227 181 163 141 80 225 230 244 242 245 252 212 176 90 248 238 194 235 226 199 230 188 89 146 111 65 163 133 65 247 220 147 166 133 49 179 151 77 233 238 250 211 220 236 172 180 202 219 221 235 248 231 177 228 204 150 244 222 180 204 197 183 170 141 57 243 207 129 242 213 147 191 156 72 253 246 232 162 173 198 240 203 118 254 254 255]; yourself]

    "Modified: / 11-04-2008 / 11:32:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

newlocation_wiz
"      Loaded from: /tmp/full/wizards/newlocation_wiz.gif"

    "
     self newlocation_wiz inspect
     ImageEditor openOnClass:self andSelector:#newlocation_wiz
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class newlocation_wiz'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
L3L3L3L3L3L3L3L3L3L3L3L3@QXVE L[@SL3L283L3L3JPP/LQ8&H!!T)L28_K#L3L0<DGCD^I"HUGQ XG1 XL3L*CQ\ZBB0(LBPTEAPTEBP3J"HZLQ8&H!!TN
A XEA X3L2("H3D^I"HUB#L B2@3L3L*H"L1G"X"EP(3L0@3L3L3J"D!!HRD!!HRD!!HRDIHRD!!L2(BL#H2L#H2L#H2L#H2@#L*@#H%ISH%L"T2ISH2IPH3J"\2
A3H2A3HGL",+L",''L2(LL#H+L",2J3H+L",+CCL3D3HRD#H2D#H2D#H2D!!L3L1L2L#H2L#H2L#H2L#HSL3LYFQ$YFQ$YFQ$YFQ$YFP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[153 116 19 200 185 86 186 185 154 192 156 29 252 219 77 252 231 163 166 130 26 134 154 191 249 233 117 232 228 212 194 142 37 251 221 131 170 171 168 235 185 36 244 215 170 198 170 53 251 240 150 189 150 54 118 133 163 157 168 175 253 244 207 246 201 56 195 163 38 247 226 88 181 146 35 149 161 182 251 245 140 189 146 20 251 226 107 246 218 166 252 244 172 254 253 239 158 121 22 197 188 153 245 220 97 251 239 150 174 138 31 143 161 195 249 234 129 177 177 175 235 193 37 194 180 58 188 148 57 127 143 176 243 215 66 195 167 43 186 151 38 251 228 117 254 221 161 253 250 189 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@?"G?\_?9??7?>_=1?2G??_?=??7??_?<??3??O?<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

newlocation_wizban
"      Loaded from: /tmp/full/wizban/newlocation_wizban.gif"

    "
     self newlocation_wizban inspect
     ImageEditor openOnClass:self andSelector:#newlocation_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class newlocation_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB ,JB (JB U%YV_''9>_ <OC65-[Z>/+:>/(:>#(:N#,KB0,KB0,KB0,KB0,KB0
,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,JB0F*B (JB U%Y>_''9>C0<O[V5-[Z>/+:>#+:N#(:N#,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0
,KB0,KB0,KB0,KB0(KB F*@Z(EZ U%Y>_''8O_ <O[V5-+:>/+:=QE:N#(:L-,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KA'',J@Z
(JB U*AVU''9>_''8OC0=-[V5-+:>/+1\W(:N#(:N#,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB ,JB0(JB (EYV_%Y>_ <OC0=-
[V6/+:>/(:>#+:N#(24-,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,JB0F!!* (JB (EYVU''9>C78OC65-[V6/+:<W+5F#(:N#(:L-
,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB F*@Z(JAVU%Y>_''9>C0<OC65-[Z>/+:>#E1^#(:N#KR4-,KB0,KB0,KB0,KB0,IFC
P96]''Y"X&C6]''Y6W 5.0,KB0,KB0,KB0(KB ,JB (EZ U%Y>_''9>C0<O[V5-[Z>/+:N/+:N#(:L-(24-,KB0,KB0,KA[K36(,7="%QPTEBP$''C.J"()"X+N3
$4M_,KB0,KB0(KB (A* (EYVU''9>_ <OC0=-[V5-+:>/+:>#(:N#(:L-KR5(,KB0,KB0W363X(*\C 8NM3]LM3\NC''6&_Y&\&RRJ%W>3*I^0,KB ,J@Z(JB 
U*AVU%Y>_''9>C0=-[V6/+:>/+:N/(:N#(:L-KV!!(,KB0,K@/,9V\_ZZ&_P87SD1LSD07C''6&)''6Y''I0;"(*UX+L=,KA''F!!* F*B U%YV_''9>C0<OC65-[V6/
+:<W+:N#+:N#(24-KV!!(,KB0,E>3N92Y_ZY=C#\7SH6M#T1LM0:&)''6Y''I0;"((T%VJ3''[@ZF!!(Z(JAV(EYVU''8O_''8OC65-[Z>/+:>/(:>#(:N#KR4-ZF!!(
,KB0,HM?''I1=_ZZ&C#]L#X6M#T1LM09=)''6Y''I0;N1PT%VJ3&A(ZF*B (JB U%Y>_''9>C0<O[V5-[Z>/+1^/(:N#(:N#(24-ZF!!(,KB0,HN3X)2Y_ZY=C#]L
SH6M#X5LM0:&)''6Y&RP;"((T%W>3[K@ZF*B (JAVU''9>_''8OC0<O[V5-+:>/+:>/E5F#(:L-KR5(ZF!!(,KB0,HM?J[LT''JZ&C#\7SH6M#T07M0:&)''6Y''I0$
"!!Q",4T=&JB F*B U%YV_%Y>C0<OC0=-[V5-+:>/(:>#(:N#(:N#KR5(ZF!!5,KB0,HLPBV,#,;NU""P$SD1LSC\7C''6&)''6\N1Q"_6N''Q2>%[JB U''9>_''9>
C0<OC0=-[V5-[Z>/+:>/+:>#(:N#(:L-KV!!(ZF!!5,KB0,HLPBPI3"AYJQ4!!E,6M?X&I"X&JUX6N3,;N3,:^XHB>%[G9>C65-[V5-[V6/+:>/+:>/+:>/+:>#
+:LW(:N#KZL-KV!!(ZGTD,KB0,HLPBPI3"E 1#$B[''"8&#3P4MYIGGD\3RJ^3,:]GHB>%[F5-+:>/+:>/+5F/(:>#+:N/(:>#+:N/E:N#(:N#(24-ZF!!(Z@PD
,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:\\HB>%EZ>/TZ>#(5F#+:N#TZN#(:N#(:N#(5F#(:>#(:L-KR5(KV!!(Z@PD,KB0,HLPBPI3"E 1#$B[
'')9*ARY&#3P5$$\3RJ^3,:]GHB>%EQ]Q(:N#TZN#(:N#(:N#(:N#(1.#(:N#(:N#(:N#KR5(ZF!!(A@PD,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3
,:\\HB>%EZN#(:N#(:N#(:N#(1.#F:M((1-(ZF"#(:N#KR4-KV!!(ZF!!5A@PD,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:]GHB>%EZN#(:N#F:N#
F:L[ZJM(ZF!!(ZF!!(ZF!!((ZL-KZL-KV!!(ZF DA@PD,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:\\HB>%EZN#F:M((6 [ZF [ZF!!(ZF!!(ZF!!((ZF!!
ZF"#(6 -ZB5(ZGTDA@PD,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:]GHB=9[A-(KV [ZA-(ZF!!(ZF!!(ZF"!!ZF"$(V"!!ZJN#(24-ZF!!(Z@PDA@PD
,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:\\HB=CEV [ZF!!(ZF!!(ZF!!(ZJQ()F"$ZFU()F!!(KZM(KR5(ZF!!(]PPDAJ8D,KB0,HLPBPI3"E 1#$B[
'')9*ARY&#3P5$$\3RJ^3,:^XHB</EV!!(ZF!!(ZF!!(ZJQ()F!!%ZFU5YV!!%ZF!!((26#KR5(ZF!!5A@PDA@Q%,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3
,:]GHB>%EV!!()F"$ZFU%ZFU5YVU%YVU%YVU%ZF -(24-KV!!(ZF D]PPD+ R.,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:\\HB>%EV"$ZFU5YWV$
YVU%YZQ%YVU%YVV!!ZB4-(24-ZF!!(ZF DA@PDAJ8D,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:^XHB>%EV!!(YV!!%YVU%YVU%YVU%YVU%YVU(F:N#
KR4-ZF!!(]PPDA@PD+ R.,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:\\HB>%EV!!%ZFU%YVU%YVU%YVVTYYQ%YZE(KZL-KR5(ZF!!(Z@PDA@PD+ R.
,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:]GHB>%EPR!!YZQ%YVU%WZ9%%FVTYZ9%YV -(:L-KR5(ZF!!5A@PDAJ8D+*:.,KB0,HLPBPI3"E 1#$B[
'')9*ARY&#3P5$$\3RJ^3,:\\HB>%EPR!!YVU%YVU%+*:T+)R.%FU%(V"#(24-KV!!(ZF!!5A@PDA@PD+ R.,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3
,:]GHB>%EPQ%ZFU%YVVT+*:.%IR.%FU(ZJN#(24-KV!!(ZGTDA@PD+ R.+*:.,KB0,HLPBPI3"E 1#$B['')9*ARY&#3P5$$\3RJ^3,:\\HB>%EWV$YVU%YYR.
YYRT%IRTYPQ((:N#KR4-ZF!!(ZGTDA@R.A@R.AJ:.,KB0,HLPBPI3"E 1#$B['')8HPTEAPTEAPTEA $FB (JB (JBD1LSD1LS HB@Q$YF#H2L#H0*J"(*]B4-
ZF!!(]PQ5A@PD+*:.+*:.,KB0,HLPBPI3"E 1#$B['')9A^"\''I2\''I2\''I2\''I2^1,[F1,[F1,[F1,VF1XVE!!XVE!!XVE6XWY4]F!!(ZF!!(A@PDA@R.AJ8D+*:.
,KB0,HLPBPI3"E 1#$B['')8HFKB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,JB0(JB U%Y>_''8OC:%6@6 -ZF!!(A@PDA@R.AJ:.+*8Q,KB0,HLPBPI3"E 1#$B[
'')8HFKB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0(JB (JAV_''9>C0<O[V56@6!!(ZF DA@PDAJ8D+*:.+!!F.,KB0,HLPBPI3"E 1#$B['')8HFKB0,KB0,KB0,KB0
,KB0,KB0,KB0,J@Z(JB U%Y>_''8OC65-[V4F@6!!(ZGTDA@PDAJ8D+ PQ+*8Q,KB0,HLPBPI3"E 1#$B['')8HT[B0(J&$)JQQ_+B)TS1Q,KB0,KB)NC 8(JN$
)CHO_ <OF1<_(Z<F@6!!(Z@PDA@PD+ R.+*:.+!!DQ,KB0,HLPBPI3"E 1#$B['')8!!FKB)\EQ0UGA0\KAQ\C)0_+B0,JATN#)S_%P?O8,_C0=-G2T%T:<FSV!!(
]PPDA@PD+*8D+*:.DQDQ,KB0,HLPBPI3"E 1#$B[''"8!!FG8:TEAPN#(:G;B O3(?F;B0Y7:KIRT8U''@%IXX%(65-T8XYUJLFSV!!(A@PDAJ8D+ R.+*8QDQDQ
,KB0,HLPBPI3"E 1#$B['')8!!FA<:O3*),JAQOKB0N"T%\J@ZF#"F!!(XO_#(YFQ$YN*>/UE9^(*LFSV D]PPDAJ8D+*:.+*8QDQDQ,KB0,HLPBPI3"E 1#$B[
''"80FC$%IS*0,KB0,KB0WQ$YFZB (E@YW%A>_(-^W%9$W)>/\FQ$+JM:SPPDA@R.+*:.+*:.DQDQDQDQ,KB0,HLPBPI3"E 1#$B['')80TUPYFQ$:*[B0,KB0
*U9^W#" (FQ$YA=>C2U$UQ%UUQ&/%''-;N"5:SYRT%IPQ+*.+DZ.+*:.+*:.+,KB0,HLPBPI3"E 1#$B[''"80TZ%^W%9$YA&$,KB0,A%$US* L%UUUZ<OC1%;
^5RE!!XV"N(VE\&!!:^G]7]7]7]7]7]7]7]7]7]2"+,KB0,HLPBPI3"E 1#$B['')8LT[AQW%UUUUUUN+B (GBEUVQ>N(VE!! <O+1&G!!1>K!!8];"2,+":E:^G1<
_G1<_G1<_G1<_G17]2"+,KB0,HLPBPI3"E 1#$B[''"80T[B0(CHY!!XVE!!Q. (JNG!!8\[UX^G( >/[[P+J5M(!!8FAFXFAV*DK^F9.[&9.[&9<_G1<_G]7JJ.+
,KB0,IDPBPI3"E 1#$B[''):ET[B0,KB0)H\+!!5B (JA;J8FK XFATP>/+5VAT%N#V%IR UIR!! PK^F9.[&9.[&9.[''1<_G0(*1DQ,KB0,KB''P I3"E 1#$B[
''":E(;B0,KB0,EVA S* (EYZT(FGT%J4+:>/+7-R\ZJ#AHE1\WE1FPPK^J(^R6:*[&9._F9<]2"+*:,Q,KB0,KBW,6-3"E 1#$B['')9O(:JE"56$!!%IRT*1V
U''9ST''E1T''FV+:>#+4=1\ZH[ZGI1\PA1W&TR!!J*******&:*[''17JJ,Q+!!DQ,KB0,KB0P;NP"E 1#$B[''"9OOE9R\UI1\UI1J65>_''8OT''E1\WF!!+:N/(8\@
@@4-ZJER@@@@-FTR^A8^*****&9._G\(*1DQDQDQ,KB0,KB0,I^''JT(1#$B['')9\(4=1\WE1\WFE(79>_ <O-@@@@HV/TQ^#(2,@@J1((ZFZ@@@@-J8R!!A8^
G!!:*[&9<]2"+DQDQDQDQ,KB0,KB0,KA''^Z"3L3U&'')9\(U,[(%)Z+JQ>_''8OC0=-(UQ7()>/(:N#(7^,+J:!!(PQ%\''I2_IQ !!A8^G!!:*[''17*:,QDQDQDQDQ
,KB0,KB0,KB0,A(",YN(,6M\(Q* (JAVU''9>_ <O[V5-+:>/+:N#(:L[KZE((ZF!!YZQ%YZ:.+)Q !!A8^G*)._B"+*1DQDQDQDQDQ,KB0,KB0,KB0,KB0F*AV
_''8]NJB (EYV_''9>C0=-[V6/+:=Q(:N#(:M(KZF!!(ZE%YVU%+*:T%J- !!A8^*&9<JJ,QDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,JB (J@]AJB U%Y>_ <OC65-
+:>/(:>#(:N#F6!!((V DYVU%YZ9%%IRT*:.K!!A9.[''0(*1DQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0(J@]V$-KR4-K\$-K\$-2\''I2\''I2\''I2"7I2\(-2
"3>K"8.K"8.K"8.DW&9<]:.+DQDQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0(J@]GQ4]GQ4]GQ5\GU1\WE1\WD=\S4=OS4=O!!XVE!!XTLCHT0!!S@0LC@0!!G\(
*1F.DQDQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0,JB.+*:.+*:.%J:+%J.T*:.+T:.+T:,G]:I<( 4MCP4MCP4MCZ2,+J2,CZ,Q+*:.DQDQDQDQDQDQDQDQ
,KB0,KB0,KB0,KB0,KB0,KB U%Y>_ =>C0<O[V6)+:>/+5DW(5F#(24-ZF!!(Z@PDA@Q%YVV.+*:.+*:.DQDQDQDQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0
,KB0U%Y>_''9>C0<O[V5-+:>/+:<W+:N#(:N#KR5(ZF!!(Z@PDA@PDAJ:.+*:.+!!DQDQDQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0,KB0,JA>_ <OC0=-[V5-
+:>/E:>#(1^#(:L-KR5(ZF!!(A@PDAJ8D+ R.+!!F.DQDQDQDQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0,KB0,K@Z_''9>C0=-[V6/+:>/+:N/(:N#(24-KV!!(
ZF!!(A@PDA@R.AJ:.+*:.DQDQDQDQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0,KB0,KB0,EXOC65-[V6/+:<W+:N#TZN#(:L-KV!!(ZGTDA@PDAJ8D+*:.+!!F.
DQDQDQDQDQDQDQDQDQDQ,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0_&5-[Z>/+:>/(:>#(:N#KR4-ZF!!(ZGTDA@PDAJ8D+ R.+*8QDQDQDQDQDQDQDQDQDQDQ
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[34 57 106 148 161 186 212 213 77 215 162 106 197 210 230 249 235 174 209 181 156 174 186 210 148 124 109 207 207 64 247 208 162 184 169 164 103 112 134 165 178 203 245 234 83 229 234 243 234 165 47 183 201 225 171 164 167 202 139 75 243 188 63 234 168 92 229 213 106 215 224 238 226 221 220 132 138 165 246 248 251 209 213 224 245 184 102 56 101 157 145 165 206 189 193 209 248 202 137 126 118 122 242 232 224 233 176 62 245 213 72 147 150 173 249 228 161 214 193 174 175 192 221 235 169 55 231 148 54 81 94 133 148 168 197 206 217 234 251 248 199 250 220 175 112 114 130 230 232 136 198 202 215 245 180 84 247 208 127 245 200 116 242 242 245 246 227 73 206 209 220 175 177 193 160 165 186 244 207 76 213 217 226 248 191 125 201 202 213 158 160 180 240 241 168 172 131 94 217 194 60 250 210 163 244 240 91 244 162 62 216 143 65 245 187 94 245 173 74 224 224 231 236 196 96 147 171 201 247 220 66 196 156 117 179 193 215 85 108 144 166 169 188 218 219 225 65 81 123 181 188 208 179 182 200 109 117 148 238 241 247 186 201 222 226 227 121 218 225 239 138 152 181 254 249 243 71 105 150 194 197 210 124 130 158 254 242 229 160 159 170 228 193 156 244 170 53 243 153 46 117 123 153 194 206 228 248 221 150 251 246 241 203 214 232 168 182 208 249 241 187 218 201 72 242 174 95 225 231 242 156 174 211 181 198 224 170 173 191 52 70 115 148 165 193 216 217 91 228 167 99 199 212 232 225 188 151 171 187 218 165 141 126 245 212 174 196 175 160 103 112 146 164 180 214 243 238 93 234 237 245 244 163 51 210 141 69 76 90 129 190 136 83 252 229 202 138 133 140 96 108 141 138 144 170 89 100 137 221 222 106 233 199 93 243 197 70 149 156 178 222 145 60 248 213 56 235 237 152 248 214 138 225 196 77 253 236 216 245 193 105 243 184 115 186 199 224 243 179 59 158 170 196 251 223 189 246 177 97 243 231 90 152 167 196 245 246 185 243 220 84 248 203 150 249 251 202 195 202 220 242 244 249 202 211 230 172 180 202 211 220 236 202 205 216 250 215 168 244 244 98 244 166 68 243 169 84 230 231 236 150 169 208 180 196 221 162 173 198 216 223 237 189 203 227 221 227 240 254 255 255 226 196 166 244 175 58 244 156 51 113 127 162]; yourself]

    "Modified: / 11-04-2008 / 11:32:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

newstream_wiz
"      Loaded from: /tmp/full/clcl16/newstream_wiz.gif"

    "
     self newstream_wiz inspect
     ImageEditor openOnClass:self andSelector:#newstream_wiz
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class newstream_wiz'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HA@QHRD!!HRD $RD!!HRD!!HA@@@AD!!HRD $DBQHRD!!HA@@@@@@DRD \HA@ HD!!HA@@H@@@H@@P<EAPXFAP<R@@DR@@@R@P@R
C 8JCP0RD!!HRD @@D!!HRD!!HKD@,RD!!HRD!!H@@AHRD!!HRD!!DRD!!HRD!!HR@@@CD!!HRD!!HRD!!HRD!!HRD @@@@LRD!!HRD!!HRD!!HRD!!H@@@@@@1HRD!!HRD!!HRD!!HR
@@@B@@@CD!!HRD!!HRD!!HRD @@D H@@@LRD!!HRD!!HRD!!H@@AHR@ @@D!!HRD!!HRD!!HR@@@RD!!HB@1HRD!!HRD!!HRD @@D!!HRD!!HRD!!HRD @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[85 114 170 86 143 192 113 172 212 181 193 200 254 253 239 253 244 207 253 243 207 181 145 35 181 146 35 186 151 38 252 231 163 158 121 22 166 129 26 166 130 26 165 130 26 174 138 31 251 221 131 153 116 19 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@LBA8\O39??66>CA0LB@8@C0@O @?@C^@L8@1 C@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

no_remotedir_ov
"      Loaded from: /tmp/full/ovr16/no_remotedir_ov.gif"

    "
     self no_remotedir_ov inspect
     ImageEditor openOnClass:self andSelector:#no_remotedir_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class no_remotedir_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'B (JB (JB $C@ HB@0(I@ $E@@DJBPHIA@@AB $BBP @@P(I@ $F@@DJBPHIA0@AB $C@ HB@0(@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[107 148 89 64 95 43 65 96 44 77 109 54 143 168 122 141 166 120 143 168 120 143 166 122 143 166 120 255 255 255 255 255 255]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O3<?O3<?O0b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

paste_edit
"      Loaded from: /tmp/full/dtool16/paste_edit.gif"

    "
     self paste_edit inspect
     ImageEditor openOnClass:self andSelector:#paste_edit
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class paste_edit'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ H@@PD@@ HB@ HB@ HB@ H@@P@@@P@B@ HB@ HB@@DA@PDA@PDA@PD@@ HB@ DB@P@@@@@@@@DB@PHB@ HA@ @A@PDA@PD@@ DB@ HB@PHB@ HB@ HB
@ HA@ HB@ DB@ HB@ DA@PDA@PHB@ HA@ HB@ HA@ HB@ DA@ HB@PHB@ HB@PHA@PHA@PDB@ DB@ HB@ DB@ HB@ HA@ HA@ HB@ HA@ DA@PDB@PHB@PHB
@ HB@PHB@ HB@ DB@ DB@ HB@ DB@PDA@PHA@ HA@ HB@ HA@ HB@ HB@PHB@@DA@PDA@PHB@ HB@ DB@ HB@ HB@ DA@PDA@PDA@ @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[191 191 191 159 159 159 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A8@O0G?8W>!!_:D@HP_!!ACDE.PPIA^$DBPW)A@''<B@_8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

patch
"      Loaded from: /tmp/full/tortoise/patch.gif"

    "
     self patch inspect
     ImageEditor openOnClass:self andSelector:#patch
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class patch'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@&M0@@@@@PJ@@@@@@@@@@&A3X0@@@1OC0(@@@@@@@&A0\-KP41H#0<O@P@@@@&A0\6KR81OC0<OC(XA@@@FP\6KR8CJ!!D]
OC0<G0D@@@@0M 0''M#H;G0XRF@D@@@@@@B<NH@(QN30#IP @@@@@@@@0L2(^MC0$G2\+@@@@@@@0B"4SL#PXNA0DICT@@@@YE0(2L (2OB\OIBP]E @@@ (^
DSP4EA0OIC ]KB$@@@@LL!!D4H#DHIC ]BR$@@@@@@@T4N3D@@CTIBR$@@@@@@@@@B3D@@@@@E"$@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 108 134 204 172 186 228 148 162 196 92 126 228 148 166 228 20 70 196 204 218 252 92 118 180 44 102 244 180 202 252 132 154 228 156 178 228 140 150 180 164 174 196 76 114 228 124 146 204 164 190 252 100 134 244 236 234 236 148 174 252 124 158 252 84 114 204 188 210 252 100 142 252 172 182 204 60 114 252 140 154 196 156 170 196 60 110 252 180 198 252 92 134 252 228 238 252 156 182 252 132 166 252 116 150 244 76 122 252 20 34 84 188 198 228 156 166 196 100 134 228 36 86 220 220 226 252 100 122 180 52 106 252 188 206 252 164 182 228 148 154 180 164 178 204 132 150 204 172 194 252 244 242 244 148 178 252 92 122 204 196 214 252 180 182 204 68 118 252 132 154 204 92 138 252 140 170 252 116 154 252]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@LLA98O?1??''?>O?0_>A?8O?1??''?>O?0^^@00@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

prjversions_rep
"      Loaded from: /tmp/full/obj16/prjversions_rep.gif"

    "
     self prjversions_rep inspect
     ImageEditor openOnClass:self andSelector:#prjversions_rep
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class prjversions_rep'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
OS4=OS0<OC0=OS4=OS4=OS4=OS08NC$;N#4=OS4=OS4@@@@#F!!@KB $@@@@@@@@=AQ0*J"(*J"(*J"(*J 4EOS4NJB$)I2T$I2$)I"TNOS4=A!!8_HBH"H"D!!
HRH @S4=OPH[GP HB@ HB@ HB@ HBC4BFA$HK2</K2</K2</K0 =AQTWBB<OA28.K!!XGC28HOPLRE@ /K \.K"8GJ0\.BC4CDQLHK3LGL200A2,GL@ =C@LD
BB<1A3D1LP\+A24HOS4=OP /L \4A3TOA0<5BC4=OS4HK3\7M#X6M3\6M0 =OS4=B@ HB@ HB@ HB@ HOS4=OS4=OS4=OS4=OS4=OP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 175 169 207 47 56 143 21 40 149 137 154 211 33 57 124 52 64 97 10 24 57 102 114 140 21 71 174 30 87 207 38 106 237 55 92 163 87 115 174 69 80 102 108 124 157 53 114 221 103 145 222 108 154 228 190 210 242 193 214 244 114 163 231 140 153 171 196 218 245 121 175 237 199 222 248 73 146 222 130 186 242 80 139 194 203 227 249 137 197 246 137 197 245 206 232 252 207 232 252 207 232 251 90 165 215 143 206 251 143 207 251 143 206 249 144 206 249 144 207 249 143 207 249 148 213 252 177 192 200 229 246 255 237 249 255 227 246 255 196 238 255 231 248 255 235 249 255 241 251 255 229 248 255 241 252 255 242 252 255 248 254 255 246 254 255 252 217 181 254 207 181 121 75 58 251 149 117 131 98 93 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0@_ O?>??9??G?<_?=??7??_?=??7??C?<O?0??@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

propchg_ov
"      Loaded from: /tmp/full/ovr16/propchg_ov.gif"

    "
     self propchg_ov inspect
     ImageEditor openOnClass:self andSelector:#propchg_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class propchg_ov'
        ifAbsentPut:[(Depth8Image new) width: 11; height: 10; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GA,[F1,[F1,[F10\F0HB@ HB@ H[GA0[B1(WF1PZAQ,\GA,@FAT[D1XFF10\F0DYF1H[D@([GA0[AA,QC08[@1,\GA,LF1,[F1,GF10\F0 HB@ IB@4[GA0[
F1,[F1,[F1,\GA0\GA0\GA0\GA0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[1 56 9 1 46 8 2 70 12 1 36 6 1 35 6 2 64 11 2 56 10 0 26 3 0 18 2 0 17 2 1 47 7 2 64 10 1 26 4 1 18 2 64 133 10 68 135 10 69 139 11 71 137 11 75 143 11 79 147 12 85 153 12 85 152 12 84 151 12 88 157 13 83 151 13 82 146 11 93 159 13 255 255 255 255 255 255]; mask:((ImageMask new) width: 11; height: 10; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_<A?0G?@_<A?0G?@_<A?0G?@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

propertiesedit
"      Loaded from: /tmp/full/subversive/propertiesedit.gif"

    "
     self propertiesedit inspect
     ImageEditor openOnClass:self andSelector:#propertiesedit
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class propertiesedit'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
PDA@PDA@PDAAPTEAPTEAPT@;N3,;N3,-PDEAPTEAPTD7DP4YDP4MFA)@PTEAPTEAI" CA0 UH2TXGSEAO3<)PSP.N#X:HC(:N#(^O0X8O4D5NP,NA@LGBAT0
O38JB#=AF34=GC4=OS4=OC8FB#=APR<$B08D@0\HOC8>B#=APTD2I0@@@@@@OC8>A#1APTEAL2(KC PCEA\>A#1APTEAPQ@B@ HB@ 0WO#0PPTEAPTDSH PC
A0 LCAP_D4EAPTEAHPDAAPDE@PTE@R-APTEAPP<VBQHVBP$RBP<,PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[231 238 249 220 231 247 225 234 248 154 172 203 162 179 207 221 231 247 249 217 71 147 166 198 140 159 194 131 146 176 252 221 86 172 188 213 14 0 6 248 249 252 168 184 211 131 145 177 144 154 168 247 249 251 130 145 176 139 150 171 181 137 53 134 154 190 131 146 177 233 205 168 218 189 124 248 249 251 213 178 105 167 168 152 238 242 250 212 178 104 178 175 146 222 232 248 243 245 251 134 148 174 223 233 248 246 248 251 234 240 249 224 200 143 183 177 143 230 238 249 245 248 251 245 202 117 228 236 249 135 147 174 131 145 176 212 178 105 242 245 251 161 164 156 240 244 251 183 177 142 155 161 161 149 157 164 178 174 146 173 171 149 242 246 251 187 180 139 255 213 97 240 245 251 243 246 251 249 250 252 197 141 86 237 242 250 254 210 53 205 156 97 191 182 136 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'?0C? O?@?>;??/?>??3?>O?0?>C?8O? ?>C?8@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

props_view
"      Loaded from: /tmp/full/cview16/props_view.gif"

    "
     self props_view inspect
     ImageEditor openOnClass:self andSelector:#props_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class props_view'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H0<FD2D!!HRDFH"L#H2L#H2LF@!!$HB@ O@ X#H2L#H2L#HP<!!CP4MHP4@H2L#H2L#H2DUFP OEP4M@"L#H2L#H2L!!EQ$HC1TMCPH#H2L#H2L#HQTYB@<UCP4B
H2L#H2L#H2DUFP OEP4MA0\QD"L#H2L!!EQ$HC1TQBP8 GP$QH2L#HQTYB@<UF DYFQ$KGAH#H2DUFP OEPT^FP,^FQP\H2L!!EQ$HC0\V@1$YFP,CA2L#HQTY
B@<GF0LYB0LCB P#H1T@FP OD!!\PFP,PDA\RH2LFEP@B@ HZG@,AFA0\H2L#H2L#H2L#H2LXA1DRH2L#H2L#H2L#H2L#H2L#H2L#H0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[127 95 63 93 179 225 159 95 63 9 153 214 86 143 189 82 162 209 223 191 95 90 142 188 255 255 159 100 154 198 40 148 204 184 205 224 89 144 190 255 159 63 106 166 209 255 223 159 49 163 220 99 148 191 141 182 214 159 127 127 69 158 208 255 191 95 25 154 210 83 148 195 91 165 212 255 255 255 106 154 194 52 150 203 91 150 196 117 175 215 57 169 221 96 149 194 133 194 230 191 127 63 255 191 127 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_<A?0G?@_<A?0G?@_?!!??G?>_?9??''?>_?9??@A8@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

protected_ov
"      Loaded from: /tmp/full/ovr16/protected_ov.gif"

    "
     self protected_ov inspect
     ImageEditor openOnClass:self andSelector:#protected_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class protected_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'BP$IBP$IBP$IBP$IBP$D@ @@@ PI@P@@@@@ABPLDA@PD@0$CA@PDA@LIA0@@@@@ABPPEA XHA@$@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[255 0 0 254 157 158 254 109 110 254 52 53 255 254 254 254 120 121 254 26 27 254 159 160 254 119 120 255 255 255]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@C<?O3<?O0b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

question_ov
"      Loaded from: /tmp/full/ovr16/question_ov.gif"

    "
     self question_ov inspect
     ImageEditor openOnClass:self andSelector:#question_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class question_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'APTEAPTEA TD@@@DAPXE@@PE@@TFAPTE@PLEA TE@@PEAPXEAPTEAPTFAPT@@ TEA TEAPTE@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 1 141 0 20 155 0 23 161 12 111 206 19 131 213 255 255 255 255 255 255]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'?O3<?O3<?O8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

refresh
"      Loaded from: /tmp/full/dlcl16/refresh.gif"

    "
     self refresh inspect
     ImageEditor openOnClass:self andSelector:#refresh
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class refresh'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ HB@ HB@ DB@ HB@ HB@ HB@ HB@ DA@ HB@ HB@ HB@ HB@ DB@PHB@ HB@ HB@ HB@ DB@ DA@PD@@ HB@@DA@ DB@ HB@ H@@P@B@@D@@ HB@PHB
@PDA@ D@@@D@@ HB@ HA@ DB@@DB@PDA@@HB@PHB@ DA@ @@@PDA@P@@@ DA@ HB@PHB@@DA@PHA@@HA@ DB@ HB@ @A@@@A@ DA@PHB@PHB@ @A@@H@@P@B
@ HB@ HA@ DA@@HB@ @A@PDA@ HA@ HB@ HB@ HB@ HB@PHA@ HB@ HB@ HB@ HB@ DA@ HB@ HB@ HB@ HB@ HA@ HB@ HB@ HB@ @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[191 191 191 159 159 159 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@B@@X@B @S8:A7D;8J7$[?X''-P_\#.A\_H@E@@X@A@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

relocate
"      Loaded from: /tmp/full/tortoise/relocate.gif"

    "
     self relocate inspect
     ImageEditor openOnClass:self andSelector:#relocate
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class relocate'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DA@P@@@@@@@@@@C0< @PDDA@PWDP@WDP@@F!!,R@PPDA@PDA@HQ@!!D@@ALJB DDDQ\AA@PBE1\Q@@@FDAPQDQ<@DPHX
F@HWDP@@A"HTEA4_@@@QF@HWE1D@@@XTEA@]G0@AA@PB@!!\QB0@IB@ HA2D@DQDQDQDQDP8@@A$YFQ8@@@@@D0(JB 0N@@@@@@@@@@@@@@XPEAP]BP@@@@@@
@@@@@@@FEA@PGQ<@@@@@@@@@@@@@A!!P"EA4_@@@@@@@@@@@@@@$HBA,GHP@@@@@@@@@@@@@@@04MAP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 52 154 4 68 218 4 172 142 60 132 254 76 180 142 44 212 166 60 236 178 36 244 222 76 212 150 44 252 234 116 180 162 108 236 198 52 188 158 60 204 138 36 220 186 76 252 238 132 44 126 4 252 222 92 212 158 52 252 234 124 188 162 60 212 146 44 60 186 4 84 242 4 196 170 84 220 170 52 244 222 84 212 154 52 244 210 68 188 154 68 212 142 36 220 186 84 204 126 28 252 238 124]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C G?,??3??O7<?O3=?/7>^G8@_ A>@G8@_ @<@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

rename
"      Loaded from: /tmp/full/tortoise/rename.gif"

    "
     self rename inspect
     ImageEditor openOnClass:self andSelector:#rename
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class rename'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A XD@@@@@@@@@@@@@@@@A TEB0P@@@@@@@@@@@@@@Q@G
B0<D@@@@@@@@@@@@@P8I@0LOB@@@@@@@@@@@@P8I@PDLB@@@@@@@@@@@@P8I@PDFB@@@@@@@@@@@@PTI@PDFB@@@@@@@@@@@@@<EB0DFB@@@@@@@@@@@@@@M
APHBB@@@@@@@@@@@@@@@B 4HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 244 170 4 156 106 4 132 134 132 156 50 4 252 218 148 188 126 4 212 210 212 132 2 4 252 254 108 4 6 4 252 158 108 68 70 68 60 58 60 252 254 180 252 110 36 252 254 252]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@G@@>@G8@? G<@? G<@_ A<@G @@@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

rep_editors_view
"      Loaded from: /tmp/full/cview16/rep_editors_view.gif"

    "
     self rep_editors_view inspect
     ImageEditor openOnClass:self andSelector:#rep_editors_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class rep_editors_view'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B0,KB0,KB0,KB0,KB0,KB ,OC0<OC0<OC0<OC0<OC0(KAP@@AP<LD!!HLC0T@@@TJB0HFAPDOD 4ID <BA TAB ,BAPPAC1HIB@DO@ TD@P(KC0H@C0<LD DL
C1@B@@<JB0HEAPDLD $H@P0BAPTAB HFAPTDDP4IB@\RA TEA@@BA TEAADMBP G@PXEAPP@@ XEAPPQCP$HA0DFAPTD@@HBAPP@A1DIA1HG@ TD@@@K@ TD
@P<QBP\AC0HEA@DJB0HEA@DODP$G@P<BAPPAB ,C@ HCC \QDP\O@0HB@0(KC0<OC0<OC0<OC0<OC0<JB0(JB (JB (JB (JB (JB @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[63 63 159 63 63 95 63 95 159 63 127 191 63 159 191 159 191 191 191 223 191 159 159 95 191 191 127 223 223 159 127 127 95 159 159 127 223 223 191 255 251 240 212 208 200 255 255 255 191 191 191 99 99 99 95 95 95]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repo_rep
"      Loaded from: /tmp/full/cview16/repo_rep.gif"

    "
     self repo_rep inspect
     ImageEditor openOnClass:self andSelector:#repo_rep
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class repo_rep'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
P$IBP$IBP$IBP$IBP$IBP$IB@@@<OC01LSDVE!!XVP$IBP!!XAC#PWN2XEKS8>N$IBP$H@OC0<OCD1BBP$IBPHP$IBKCH2L#H2GRPPO3\^I@!!BP"02L!!03L3L3
GDEAHQ,$P$H,L!!03OS\5FSL\A2 [DTIBACH3PS@JH040L0\(F1EBP# 2K2$.C@<CER<GJA,QP$HSL %AK 0O@1TIA2 [ITIBPCHIJR8LC0LUBP\(F2UBP"@2
G4D.C@<CEQ<GJA,9P$HFA!!<)K 0O@1T_A2 TBDIBP$H+PR8LC0LUJ2(TBDIBP$IBGB,.C@<CJ11BP$IBP$IBP$H\@ HB@!!1BP$IBP @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[43 86 141 129 190 237 166 102 31 254 225 52 152 147 114 187 221 250 104 118 146 234 234 195 207 171 35 186 122 18 224 143 16 42 97 165 250 238 209 204 123 25 135 193 239 255 255 122 252 231 140 190 141 37 251 240 161 130 133 128 173 121 54 251 154 9 42 107 187 153 203 243 43 89 146 242 216 72 208 233 254 246 168 29 210 164 15 206 163 22 252 244 204 178 115 22 110 122 142 208 142 50 41 103 178 215 133 20 195 147 32 181 131 45 175 215 247 42 94 160 249 225 78 239 191 89 184 168 141 171 107 28 165 155 105 198 228 253 249 225 182 191 129 15 230 151 13 42 100 172 255 255 255 196 135 12 143 198 240 249 234 121 184 137 41 252 248 164 142 141 122 176 127 49 41 111 195 164 210 245 43 92 154 250 221 90 216 238 255 253 250 191 119 127 136 240 186 94 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@??C?<O?8??3??O?<??3??O?<??3??O?<O? ?0A>@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repobrowse
"      Loaded from: /tmp/full/tortoise/repobrowse.gif"

    "
     self repobrowse inspect
     ImageEditor openOnClass:self andSelector:#repobrowse
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class repobrowse'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DA,@F1@@@@@@@@@@@@@@JBT,KBT%J@@@@@@@@@@@DBTLC@0%IP,P@@@@@@@@@A,LE!!\YE2 K
F0@@@@@@@@@@J2,+KBTLB0@@@@@@@@@!!@B$O@1 ^I ,[@@@@@@@@K"POC0L-I"TBFP@@@@@@@AL\J@<CF@,BGPP''@@@@@@@SH!!0YF0@[FP4AA P@@@@@D10/
H!!<-@@@IAAHFA@@@@APQDQDEJ @@@BPDD  D@@@@C (JA0@@@@@@I@PRBB\@@@@@@@@@@@@@@@@$AB@''@@@@@@@@@@@@@@@@@@@DBP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 220 146 4 148 146 148 236 198 52 124 86 4 236 178 36 252 218 148 180 142 44 252 206 108 68 70 68 188 158 60 148 218 252 252 250 252 60 42 4 172 142 60 252 234 116 108 110 108 244 222 76 188 126 4 212 166 60 212 150 44 188 162 60 220 222 220 196 194 196 204 138 36 92 94 92 212 154 52 60 58 60 252 234 124 28 30 28 164 162 164 244 210 68 156 106 4 220 170 52 252 238 132 252 222 92 84 82 84 180 230 252 252 254 252 92 62 4 124 122 124 244 222 84 204 126 28 220 186 76 236 234 236 212 142 36 212 158 52 252 238 124]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@6@G<@?8C? G<A_8G? _?A=>G9<_#8<G0@O@@Lb') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repository_rep
"      Loaded from: /tmp/full/obj16/repository_rep.gif"

    "
     self repository_rep inspect
     ImageEditor openOnClass:self andSelector:#repository_rep
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class repository_rep'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
Q4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GHC@,LSP7HD]GQ4]GQ4]GF"L_A@$UGR<ZQ4]GQ4]GQ24$G PIEQ4/QT]GQ4]GQ4\:L1$ADQ,+PTMGQ4]GQ4]GO"DOA@$U
GR=CQ4]GQ4]GQ34!!C0PHEA4/P$]GQ4]GQ4\<HP8EA1L]K4IGQ4]GQ4]GNRDNAPXRGR=BQ4]GQ4]GQ3 "C PGEQ4/O4]GQ4]GQ4\;IP8CB!!X]K4AGQ4]GQ4]G
N2XM@ ,WGR=@Q4]GQ4]GQ3,6F@@LGB-DQ$]GQ4]GQ4\(M!! @CA0+QAAGQ4]GQ4]GQ2@.J"$2MR]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[249 240 97 249 240 101 252 248 156 252 248 158 252 248 161 252 248 162 251 240 136 251 240 138 251 239 139 251 239 140 251 240 140 251 240 143 246 224 79 249 232 111 249 232 112 249 233 112 170 152 50 246 223 77 246 224 87 246 224 88 246 224 89 246 224 90 246 224 94 246 224 97 243 211 52 243 213 53 191 170 61 237 197 37 237 197 40 240 207 60 249 213 68 249 216 77 199 177 79 240 200 59 240 200 61 251 201 44 251 203 45 240 200 65 239 198 66 192 161 63 204 176 84 198 161 61 199 162 63 226 166 20 194 153 53 197 158 59 198 161 63 242 177 31 194 149 50 192 149 52 196 155 58 226 156 19 189 141 47 194 149 55 223 153 21 184 129 43 186 134 60 184 133 60 182 132 61 186 134 61 183 132 60 182 131 61 181 129 61 194 128 49 194 129 49 229 121 6 191 125 50 190 124 51 229 121 7 176 109 38 179 102 39 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@G<@?8C? O>@?8C? O>@?8C? O>@?8C? O>@_0@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolve
"      Loaded from: /tmp/full/tortoise/resolve.gif"

    "
     self resolve inspect
     ImageEditor openOnClass:self andSelector:#resolve
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class resolve'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@E@@@@@@@@@@@@@@@@@@@E@ T@@@@@@@@@@@@@@@@E@ HBAP@@@@@@@@@@@@@@APHE@ T@@@@@@@@@@@@@APHBAPHBAP@@
@@@@@@D@@@TB@ HB@ T@@@@@A@D@@@TB@ HE@ HBAP@@A L@@@@E@ HB@ HB@ T@A L@@@@@@@TEA@PDAPT@A L@@@@@@@@@@@@A@0P@A LA@@@@@@@@@@@@
@@DCA@LA@@@@@@@@@@@@@@@@@PLA@@@@@@@@@@@@@@@@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 4 186 4 252 254 4 4 126 4 4 218 4 252 2 4 4 242 4]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@H@A0@O @>@G<B_03?&O>0_6@N8@_@@8@A@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revert
"      Loaded from: /tmp/full/subversive/revert.gif"

    "
     self revert inspect
     ImageEditor openOnClass:self andSelector:#revert
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class revert'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JA XJA \G@PPJB (JB (JB X@@  IBP$H
@P(JB (JB (B@@$IBP$IBP AB (JB (JA  CBP$GA0$IB@PJB (JB XH@0LGB (GBP AB (JB (FB@ @@@HJA0$HA0(JB (JA0XFA0XFB \IB@\JB (JB (J
B (JB (EBP GB (JB (JB (JB (EB@ EB (JB (JB (JB (JAPTEB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[249 205 95 181 137 53 178 118 14 249 211 121 205 156 97 193 155 32 181 121 19 172 116 19 246 220 131 251 232 158 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@70C? O?@?>C98O7 ?^@A8@O@@8@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revisiongraph
"      Loaded from: /tmp/full/tortoise/revisiongraph.gif"

    "
     self revisiongraph inspect
     ImageEditor openOnClass:self andSelector:#revisiongraph
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class revisiongraph'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@ED0@SAP@@@@@@@@@@@@@YF0(_F1,Y@@@@@@@@@@@EF0(JB!!,[A0T@@@@@@@@@D0(MF!!HZFP\S@@@@@@@@@@@ HA<_F0(G
@@@@@@@@@@@@BAPPD!!\]A1L@@@@@@@@!!GADQDP(]F0HR@@@@@@@!!C@8YDQDHA0HU@18@@@@@CBD@CAHS@ALRB0DD@0@@@@@@@@0L@@@FA $CC0PC@@@@@@@L
C@@FC@0@G@LOE L@@@@@C@0ZC@0F@@@\@0<VG @@@@0LC@0F@@@@@A0CFA8@@@@LC@0F@@@@@@@@@@LI@@@@C@0F@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 220 146 4 148 146 148 124 86 4 252 218 148 108 110 108 156 190 188 148 218 252 76 134 196 68 70 68 252 250 252 60 42 4 60 94 156 220 222 220 92 158 188 188 126 4 164 186 212 76 142 196 92 94 92 60 58 60 76 126 172 28 30 28 252 206 108 164 162 164 156 106 4 124 122 124 196 194 196 180 230 252 84 82 84 252 254 252 92 62 4 236 234 236 92 146 196 60 126 188]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@M A?@O>@?8A?@G>A?8O?07_ Y?A.>G9<_C18CG@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

share_wizban
"      Loaded from: /tmp/full/wizban/share_wizban.gif"

    "
     self share_wizban inspect
     ImageEditor openOnClass:self andSelector:#share_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class share_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@1UWPB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N4HA''PB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@HC@XX@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@1BEUU]B,+@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A0
LP0LUPYAX",+@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CDLC@1U]DEAX",+@ HB@ HB
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@>C@0LC@XXFDEAX",+@ HB@ HB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;P LC@0LA!! XFDEAX",+@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@HC@0LC@2YEQ XFDEAX",+@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@LP LC@0LUS4UEQ XFDEAX",+@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HXHC@0LC@1UOWPU
EQ XFDEAX",+@ HB@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@LP LC@0LCET=]GPUEQ XFDEAX",+@ HB@ HB
@@@@@@@@@@@@@@@@@NY9Y&Y&Y&Y&Y&Y&Y&Y&Y&XD@@@@@@@@@@@@@@@@@@@@@K,HB@ LC@0LUS4=]GPUEQ XFDEAX",+@ HB@ HB@@@@@@@@@@@@@@B3;=^G
''Y6]!!8\WE3@0LCAO%&9MY @@@@@@@@@@@@@@@@@@;P HB@ LC@0L&S4=]GPUEQ XFDEAX",+@ HB@ HB@@@@@@@@@@@@@@C/8<\DVWEVU(ADL3L3L3L3L3M.
SZ @@@@@@@@@@@@@@@@1B@ HB@ LC@2YOS4=]GPUEQ XFDEAX",+@ HB@ HB@@@@@@@@@@@@@J#518@3L3L3L3L3L3L3L3L3L3O<SW23,:#ZY&Y&Y&Y&Y*2,
+J2,+G$LCI&YOS4=]GPUEQ XFDEAX",+@ HB@ HB@@@@@@@@@@@@@N>+ D1LSD1LSD1LSD1LSD1LSD1L%$4M53B]''Y6G!!8\WLC@0LCAO545<GY&YOS4=]GPU
EQ XFDEAX",+@ HB@ HB@@@@@@B3*FY&=AIPQDQDQDQDQDQDQDQDQDQDQDQDQF;:"(*++V1V CP3L3L3L3L3L9YM;9&YOS4=]GPUEQ XFDEAX",+@ HB@ HB
@@@@@@B(>*&)*Z-PTEAPTEAPTEAPTJ6-+WE1</K\ &8D+SL3L3L3L3L3L3L3L3L3L3M.SW&YOS4=]GPUEQ XFDEAX",+@ HB@ HB@@@@@@B(: @@AJ-YV^9,
[F1,[CP4MCP4MCP4MCP4%!!^+SD1LSD1LSD1LSD1LSD1LSD3%S]D]OS4=]GPUEQ XFDEAX",+@ HB@ HB@I]*T(79CZ?UJR$)JR$)JR$)JR$)JR$)JR%O%!!HR
4UADQDQDQDQDQDQDQDQDQDQDQDQDS44M$)JR$)JR$)JR$)KAX",+@ HB@ HB@H4TEMLIBP$IBP$IBP$IBP$IBP$IBP$IBP''Q*Z&)60QPTEAPTEAPTEAP+Z6-
\WE1<-3\U)4WE1\WE1\WE1\W547DX",+@ HBL%=_@HFA _8PDA@PDA@PDA@PDA@PDA@PDA@PDAA.@@BJAE%YVV1,[F1,MCP4MCP4MCP4MCP4MCP4MCP4MCP4
MCP4D$7DJ3I_&4,A@PDA@APQ@H:1,[FO#8=JR$)JR$*!!(ZF!!"L2M3K@,+6()JR$)JR$)JR$)JR$)JR$)JR$)JR$)JR$)JR$)JR$)JR$)CR3+8P\GV!!<A@PDA
@@@@@HQHRD!!HDE]W#8>O#5"N#(:NS(DT8H8IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IQ1RAEE(A@PDA@@@@@HQH"LH(JB (JB (
JB (JB (8H4[?<4PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P<U(T U(A@PDA@@@@@HQH02D!!HRD!!HRD!!HRD!!HRD!!8M<!!'',.1,X>O
#4)JR$)JR*F!!(ZFH"H"H"O[6=/[6\7U5]WU5]^S$9NS$9NSK1$.M#PDA@PDA@@@@@HR<H2L#H2L#H2L#H2L#H2L#H2L#$U]HRD"<U5_M#8>O28:N#(:N#(8!!
WE1\WE1\WE1\WE1\WE1\WE1\WE1\1$,A@PDA@PDA@@@@@HQWH"H"H"H"H"H"H"H"H"H"H"H"$U^<02 (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (
JB (JB (1$,A@PDA@PDA@@@@@HS6IBP$IBP$IBP$IBP$IBP$IBP$$U^HHRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!1$,A@PDA@PDA
@@@@@HQJI2\''I2\''I2\''I2\''I2]''I2\''&!!AXH2L#H2L#H2L#H2L#H2L#H2MX02L#H2L#H2L#H2L#H2L#H2L#H2L#B$,A@PDA@PDA@@@@@HQJK"8.K"8.K"8.
K"8.KWTPK"8.&!!@"H"H"H"H"H"H"H"H"H"H"H"IJU2\"H"H"H"H"H"H"H"H"H"H"H"H"B$,A@PDA@PDA@@@@@HR!!KR4-KR4-KR4-KR5''DF"PKR4-''%\$IBP$
IBP$IBP$IBP$IBP$IBR!!-K3KIBP$IBP$IBP$IBP$IBP$IBP$B$,A@PDA@PDA@@@@@BZHYVU%YVU%YVU%YS];RRB$YVU%''''T''I2\''I2\''I2\''I2\''I2\''I2^H
_)1#(R\''I2\''I2\''I2\''I2\''I2\''/T,A@PDA@PDA@@@@@BY3YFQ$YFQ$YFQ$]Q0V0C2LYFQ$:_X.K"8.K"8.K"8.K"8.K"8.K";6_,@*$GT-K"8.K"8.K"8.
K"8.K"8./T,A@PDA@PDA@@@@@BY5M3\7M3\7M3^#+0, _"VLM3\7>JD-KR4-KR4-KR4-KR4-KR4-KR55_))>HJXPY24-KR4-KR4-KR4-KR4-/T,A@PDA@PDA
@@@@@B[$"8.K"8.K$7-(,M[0J"VL$9NSH7M$YFQ$YFQ$YFQ$YFQ$YFQ$YFS$_))3^,AG^3]%YVU%YVU%YVU%Y[9%/T,A@PDA@PDA@@@@@BZX$9NS$9MQG@;@
2&T76RT*@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCHIG$\>$ _&M5YFQ$YFQ$YFQ$Y6]'' 4,A@PDA@PDA@@@@@BZ#TUEQTWJI%BA:Y5 9N0/S4?;>?$YFQ$YF
E!!XVE!!XVE!!XVE$YFQ$YF?/BU) $''5+A((3\7M3\7M3\7YFP7 4,A@PDA@PDA@@@@@BY2&I"X^6L*5"F$S*U@7(2L%YVU_7=?$IA(ZF#T5MST5MQ(ZF"P$G=?
_9V&NT8NVL( C''.S"8.K"8.KM3\7 4,A@PDA@PDA@@@@@BY2(7H\$BC]:^]G)ZU@PD9NNS$NC*YIRU.4-A8^Z6-+Z18^-KQ[RT&&C 89NT9NPJQ:HI0\TYNS
$9NS(JB  4,A@PDA@PDA@@@@@BY/\&>I%C2''%D]G)ZU@PD9NNS$NC*YIRU.4-A8^Z6-+Z18^-KQ[RT&&C 89NT9NPDC10KA#\%EQTUEQ+*BS 4,A@PDA@PDA
@@@@@BY/[6=/"ZXJT>1G)ZU@PD9NNS$NC*Z&RU.4-A8^Z6-+Z18^-KQ[RT&&C 8NNT9NB5OYB:=2&I"X&I!!Q''::_ 0DA@PDA@PDA@@@@@BYTUEQTUK)#,EMS
B:U@)65-[V4:N#(:N#(;N3,;N3,;N3,;N3,:N#(:N,Z%NP/Y[\[''"WJ#(:N#(:N8''9?O 3<A@PDA@PDA@@@@@BXYFQ$YFQ&:"P,%[Z_?)2T<OC0<OC0<OC0<
OC0<OC0<OC0<OC0<OC0<OIDVIS(:0IT\\''I2\''I2\''J839>8 0DA@PDA@PDA@@@@@BYEQTUEQTUE.+X&B&4:N"U)-[V5ZQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$Y
_'')S[ULC^1%/[6=/[6=/[6>8.G\Z 3<?O3<?O3<?@@@@@BX6M#X6M#X6M#Z6_<@;=2U)M#X61UQTUEQTUEQTUEQTUEQTUEQTUEPYB=Y-IYRIFUQTUEQTUEQT
UF<Z.G\Z >K"8.K"8.K"@@@@@BX8NC 8NC 8NC 8P6LCT2U)NC 81Q$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ%EB=$JN[XYFQ$YFQ$YFQ$YFV<ZXG^E :J"(*J"(*J"
@@@@@BX5MST5MST5MST5MPV6?31)MST5ZTUEQTUEQTUEQTUEQTUEQTUEQTV:B2A#P4UEQTUEQTUEQTUEQXTZXG^E ?/;>?/;>?/;@@@@@BXEAPTEAPTEAPTE
APTE6@8ZAPTEZSX6M#X6M#X6M#X6M#X6M#X6M#Z5PKYCM#X6M#X6M#X6M#X6M'' ZXG^E 0<OC0<OC0<O@@@@@BXEAPTEAPTEAPTEAPTEAZ**APTEZS 8NC 8
NC 8NC 8NC 8NC 8NC#=6DL8NC 8NC 8NC 8NC!!=K7!! XKH//U5]WU5]WU5]@@C-3.\EAPTEAPTEAPTEAPTEAPTEAPTEZST5MST5MST5MST5MST5MST5MSTE
AST5MST5MST5MS#RQWX/K7!! XKH//U5]WU5]WU5]@MBW2N#??59BW%9^W%9^W%9^W%9^W%9^B0TEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPT5M[''R_W6?]''X/
^G!! ,,$//P\GA0\GWU5]@MCN%9_H2L#H2L#HGQ4]GQ4]GQ4]GQ4]Z0TEAPTEAPTEAPTEAPTEAPTEAPTEAPT5MSW=4-I=_[=6]"=8^FB22\$//P\GA0]]WP?;
@@@@@@@@@GBF!!(X>LSD1LP HB@ HBK_HZ0TEAPTEAPTEAPTEAPTEAPTEAPTEAST5MSV9.]I=_[>?/7X/K7!!8XKI6O@\GA54O>1<?@@@@@@@@@GBF!!#81LSD1
LP HB@ L2FGAA59BP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBF0]]WP>"8#<A@@@@@@@@\GBFO#D1LSD1LP HB@"72A5!!0\GA0\GA
0\GADQDQDQDQDQDQDQDQDQDQD_O3<?O3<?O3<?O3<?O;>?/;C?/;G>H?@PDA@@@@@@A0\HX>LSD1LSD1LP HB@ HB@ HC@0LUUUUA XFA XF&Y$=OWPUEQ X
FDE"J0HB@#H2L#H2W5=_D1LS&9-KR4,A@PDA@PDA@@@@@@A0\C8>LSD1LSD1LP HB@ HB@ HC@0LUUUUA XFA XF&Y$=OWPUEQ XFDE"J0HB@#H2L#H2W5=_
D1LS&9-KR4,A@PDA@PDA@@@@@GA0;S8>LSD1LSD1LP HB@ HB@ LC@0LUUUUA XFA XF&Y$=OWPUEQ XFDE"J0HB@#H2L#H2W5=_D1LS&9-KR4,A@PDA@PDA
@@@@.7C-O#8>LSD1LSD1LP HB@ HB@ LC@0LUUUUA XFA XF&Y$=OWPUEQ XFDE"J0HB@#H2L#H2W5=_D1LS&9-KR4,A@PDA@PDA@@@@\H[-O#8>LSD1LSD1
LP HB@ HB@ LC@0LUUUUA XFA XF&Y$=OWPUEQ XFDE"J0HB@#H2L#H2W5=_D1LS&9-KR4,A@PDA@PDA@@B;!!.7-O#8>LSD1LSD1LP HB@ HB@ LC@0LUUUU
A XFA XF&Y$=OWPUEQ XFDE"J0HB@#H2L#H2W5=_D1LS&9-KR4,A@PDA@PDA@@A0!!.7-O#8>LSD1LSD1LP HB@ HB@ LC@0LUUUUA XFA XF&Y$=OWPUEQ X
FDE"J0HB@#H2L#H2W5=_D1LS&9-KR4,A@PDA@PDA@GA0!!.7-O#8>LSD1LSD1LP HB@ HB@ LC@0LUUUUA XFA XF&Y$=OWPUEQ XFDE"J0HB@#H2L#H2W5=_
D1LS&9-KR4,A@PDA@PDA@GA0!!.7-O#8>LSD1LSD1LP HB@ HB@ LC@0LUUUUA XFA XF&Y$=OWPUEQ XFDE"J0HB@#H2L#H2W5=_D1LS&9-KR4,A@PDA@PDA
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 222 230 248 232 238 250 94 127 163 249 234 211 209 240 244 241 244 252 203 199 210 248 250 253 172 195 221 52 91 134 103 132 166 246 248 253 175 149 84 162 180 202 212 211 226 191 209 232 220 218 229 198 152 59 225 233 248 180 180 180 236 241 251 129 156 188 220 172 101 235 240 250 197 227 238 186 215 226 154 165 183 203 225 237 235 234 240 181 194 212 216 220 236 69 106 150 147 178 214 153 184 217 150 181 216 155 186 218 48 81 125 141 171 195 158 189 220 144 175 213 199 171 116 88 120 159 233 238 250 137 118 57 163 194 222 161 192 221 193 222 226 219 165 94 250 252 254 229 236 249 243 174 82 245 187 96 207 238 243 202 233 241 172 203 226 205 236 242 158 177 199 33 61 104 35 64 108 59 96 141 238 242 251 252 253 254 220 227 244 149 169 194 234 239 250 127 146 170 211 237 243 244 181 89 199 230 239 124 154 187 140 164 188 202 217 237 170 186 206 173 197 226 223 231 248 243 177 85 154 117 20 154 173 197 221 165 74 250 218 173 180 211 230 210 210 210 41 70 112 194 225 237 243 246 252 246 192 124 187 207 231 163 190 219 250 222 177 191 194 203 173 188 208 142 173 212 209 205 219 129 148 172 228 234 249 185 213 219 232 232 237 233 239 250 194 214 226 169 200 225 166 197 224 204 185 137 168 198 224 186 203 221 171 203 217 204 204 199 185 197 214 248 204 136 30 57 100 179 134 38 191 222 235 254 254 255 248 211 166 188 218 234 178 205 229 237 241 251 181 206 229 196 225 229 182 210 220 189 218 222 218 207 180 122 159 197 197 219 233 169 137 56 202 232 236 96 129 167 176 197 217 245 190 119 173 173 174 246 201 149 51 97 137 131 164 197 189 219 228 253 254 255 222 176 106 177 201 228 209 229 238 254 244 230 174 205 228 163 188 211 182 187 194 157 184 218 172 195 225 180 200 219 130 165 202 194 178 135 177 208 229 122 149 178 171 192 214 211 157 63 244 243 245 183 214 231 239 243 252 133 169 204 224 232 248 119 147 178 224 179 109 138 173 207 179 209 225 174 205 225 175 200 226 216 218 234 186 215 233 158 183 209 145 166 192 165 184 205 64 91 130 229 220 196 227 202 155 220 244 246 249 225 191 200 182 136 249 215 169 176 207 225 204 219 231 79 114 154 171 194 225 183 210 214 249 246 240 176 191 210 205 233 241 216 236 242 244 245 250 183 213 226 206 236 240 202 230 240 254 255 255 195 213 233 50 95 134 165 196 223 199 229 233 64 100 145 224 221 230 152 181 216 154 184 217 214 208 192 166 201 216 49 87 128 254 250 244 239 237 242 179 206 210 105 145 186 167 193 223 169 183 196 177 199 226 249 249 250 181 211 226 253 253 253 166 127 33 204 235 239 118 150 184 191 207 225 201 183 145 81 121 165 191 143 52 224 244 247 46 77 120 210 194 151 232 206 160 247 205 159 98 141 184 113 139 173 147 156 167 146 160 177 62 114 167 218 222 239 231 194 135 183 209 231 238 173 81 242 238 225 142 166 192 163 178 194 142 175 207 201 169 97 79 114 139 85 109 144 253 253 254 249 213 156 183 158 93 156 188 219 97 121 150 248 208 162 216 215 228 198 177 123 200 160 83 179 204 229 23 48 88 143 179 208 72 102 120 188 149 67 214 215 230 237 171 78 207 237 243 121 152 186 129 154 181]; yourself]

    "Modified: / 11-04-2008 / 11:32:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showchanged
"      Loaded from: /tmp/full/tortoise/showchanged.gif"

    "
     self showchanged inspect
     ImageEditor openOnClass:self andSelector:#showchanged
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class showchanged'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!CP(@@@@@@@@@@@@@@@@JCPHMB @@@@@@@@@@@@@!!CP@@@@4J@@@@@@@@@@@@B 4@@@@MB @@@@@@@@@@@@@@@@@M
CP@@@@@@D!!H_A"PUFP@MCP@@@@@@@@,OJA0HIQT!!CP@@@@@@@@@RD!!<FIBPYHP4@KB0,K@@@J1DQDQDQJ0@@H2$]BPLX@ALQG!!8^G!!L!!CR8IBP$CKP@ DQ80
G#@ HP4.E1,WH"4@I"X&I"X&I @@EA,WK2H-@@@@@@@@@@@@@AP[F1\"KP@@@@@@@@@@@@@''DA@)APP@@@@@@@@@@@@@@@0VA0D@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[4 2 4 180 142 44 4 146 220 236 198 52 204 126 28 236 178 36 36 66 116 188 158 60 148 206 252 252 234 116 4 126 188 20 70 172 172 142 60 4 86 124 212 146 44 76 146 220 244 222 76 196 238 252 28 50 100 116 110 76 212 166 60 44 74 132 188 162 60 252 238 132 204 138 36 44 74 124 212 154 52 252 234 124 140 190 236 252 222 92 228 246 252 28 58 108 108 98 100 4 170 244 244 210 68 220 170 52 44 70 124 180 226 236 76 90 116 212 150 44 92 166 212 244 222 84 28 54 100 140 118 68 220 186 76 212 142 36 212 158 52 252 238 124 236 250 252]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@A0@O A#@FL@A ?,C? O><?'';??/?>?''8@_ A>@C0b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showhistory
"      Loaded from: /tmp/full/subversive/showhistory.gif"

    "
     self showhistory inspect
     ImageEditor openOnClass:self andSelector:#showhistory
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class showhistory'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
LSD1LSD1LSD1LSD1LSD1LSD1LSD1LQ GA0\SFCD1LSD1LSD1LP,ZBAHH@!!$KLSD1LSD1LSDKF!!@RBA@OC#D1LSD1LSD1E2(BH0HOJQL1LSD1LSD1LQ<$G@D''
@ $@LSD1LSD.K"4.KR8.KP(I@CD1LSD1K!!DTDQP[F28!!FP@1LSD1LR4"CP0DAR@-B $&LSD1LSD-@0L%@2,AKP(@C#D1LSD1E DMC@PE@QX^@A\1LSD1LQT,
KB0,KB0UJA41LSD1LSDFK04LA@T/A#D1LSD1LSD1LB</K2</K0X1LSD1LSD1LS@0LC@0LC@0LSD1LSD1LSD1LSD1LSD1LSD1LSD1LP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[205 118 15 234 240 249 249 217 71 237 243 253 81 107 158 71 100 153 124 127 127 194 141 20 248 228 107 234 178 36 234 221 152 193 155 32 85 120 168 97 121 167 175 92 7 235 181 26 252 221 86 246 254 255 252 248 164 178 118 14 251 250 248 131 130 120 142 140 123 178 129 26 198 171 53 238 195 46 250 195 38 249 250 252 225 224 216 206 147 26 251 232 158 187 165 120 246 248 251 235 230 148 244 244 244 249 238 94 233 205 168 241 241 241 181 121 19 235 235 192 166 158 143 210 151 15 222 165 23 242 245 251 227 235 249 156 150 104 169 147 100 218 229 249 100 116 141 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C<@_8A? G>@_8O? ?>C?8O? ?>C?0O<@?0C?@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:33:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sphereBlue16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sphereBlue16x16 inspect
     ImageEditor openOnClass:self andSelector:#sphereBlue16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class sphereBlue16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
1<_G1<_G1<_G1<_G1<_G1<_G1<_G17"I!!(L81<_G1<_G1<\2#9JU%)NO"HEXE\_G1<\2")NX(JBZ%X.F]%_G1<_G"9B *[&9+:^R"''54G<_G186R)[J?0[V+
%X1>]S7G16"L$:*31LV7+)VK_WQKF<];"9F&,K:>,**R"W-3Q2KG\(VJ%9>)*ZJZ"XA4Z38^16*@!!YBT''Y:V$HM=\F@6E,\)]W2A!!HZF 7=5\U%FH@KG16-3
^75>_''-6\F]KN!!SG1<\4S&Q+[V5%XT=EK!!3G1<_GB#EMTU-ZTD4=MQ(K1<_G1<_GC1<+K2\$F@;G1<_G1<_G1<_GCQDQB0GG1<_G10@a') ; colorMapFromArray:#[1 1 9 4 4 22 5 5 26 5 5 28 5 5 29 7 7 37 8 8 38 8 8 43 9 9 48 9 9 50 10 10 51 11 11 57 11 11 58 12 12 60 12 12 62 13 13 65 14 14 65 13 13 68 15 15 70 14 14 72 15 15 74 18 18 83 18 18 87 18 18 88 18 18 89 21 21 102 21 21 104 23 23 108 22 22 109 23 23 111 23 23 112 24 24 114 24 24 118 25 25 120 26 26 121 26 26 123 27 27 128 29 29 134 29 29 137 29 29 139 30 30 141 31 31 142 30 30 143 31 31 145 31 31 146 31 31 147 31 31 148 32 32 148 32 32 149 33 33 153 44 44 155 34 34 161 35 35 161 35 35 164 36 36 169 38 38 175 42 42 169 38 38 176 39 39 179 39 39 181 42 42 182 40 40 184 40 40 185 41 41 189 41 41 191 42 42 191 42 42 193 42 42 194 43 43 197 43 43 199 44 44 203 45 45 205 45 45 206 50 50 192 57 57 192 45 45 208 46 46 209 46 46 211 46 46 212 47 47 214 48 48 219 48 48 221 48 48 222 49 49 223 62 62 220 49 49 224 49 49 225 50 50 227 52 52 225 50 50 228 50 50 229 50 50 230 61 61 229 51 51 232 52 52 235 52 52 237 52 52 239 53 53 239 53 53 240 53 53 242 54 54 244 54 54 246 55 55 246 55 55 247 63 63 243 55 55 248 56 56 248 56 56 250 56 56 251 57 57 252 58 58 253 59 59 253 58 58 254 59 59 254 61 61 254 60 60 255 61 61 255 62 62 255 63 63 255 66 66 220 72 72 243 65 65 254 64 64 255 65 65 255 66 66 255 67 67 255 68 68 255 69 69 255 70 70 255 71 71 255 75 75 252 72 72 255 73 73 255 74 74 255 75 75 255 77 77 252 76 76 255 77 77 255 78 78 255 79 79 255 80 80 255 81 81 255 82 82 255 83 83 255 84 84 255 85 85 255 86 86 255 87 87 255 88 88 255 89 89 255 90 90 255 91 91 255 92 92 255 93 93 255 94 94 255 95 95 255 96 96 255 97 97 255 98 98 255 99 99 255 100 100 255 101 101 255 102 102 255 103 103 255 104 104 255 107 107 255 108 108 255 109 109 255 111 111 255 112 112 255 113 113 255 114 114 255 115 115 255 118 118 255 119 119 255 120 120 255 121 121 255 123 123 255 126 126 255 127 127 255 128 128 255 129 129 255 130 130 255 134 134 255 135 135 255 136 136 255 137 137 255 139 139 255 141 141 255 142 142 255 143 143 255 145 145 255 146 146 255 147 147 255 150 150 255 152 152 255 153 153 255 154 154 255 156 156 255 0 0 0]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C8A?<O?0??#?>_?=??7??_?=??3?>O?0??@?0@>@b') ; yourself); yourself]
!

sphereBlue24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sphereBlue24x24 inspect
     ImageEditor openOnClass:self andSelector:#sphereBlue24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class sphereBlue24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<]J^H&H!!(M\NL_G1<_G1<_G1<_G1<_G]82N#9BO#X.H W$<1<_G1<_G1<_G13JG#9JT%YZU$8>L"HE<
VAWG1<_G1<_GL(*O$9"\(JB^&)VP"8Z@]%\P1<_G1<_G (:S&ZF&+J6,))>U#(&C_F=A1<_G1<]T"9BW(J&2.[&6+:^]$(*D_WQ_G<_G1<^E#YJZ)[J;/<F<
-Z. %X2D_''U%O\_G14&F#YN\*+Z=0<[B.*>#%X6E_''U)RAKG16"F#IN]*+N=1LW@-::#%X.D_WQ&R1/G17.E"9F[)+B8/+:9,** $(&A^7M#Q2KG17*C"X:V
(J"1-KR1*:RY#(U?]''A^QBOG17I?!!X*P%9>&*Z&&()*Q"XA<]F-UO!!;G16)< HVJ$IRZ''Y:[%)BJ 756\FALM!![G1452_HBD"X.N$YFO#H"A_WY1YUM@KP3G
12%)]W1> XRE!!(ZE 7=;]WE)VTX6H@KG1<]PZ7M:^75>_''9=^7Y4\F]ZR3((EL_G1<\%T&U.\7Q5]''U4\7A,X%YHN3@YAL_G1<_GMD9]YF--[V5+YVEYS4T9
K!!0I1<_G1<_GB#EBSUEYV5)VTD5EOST''F ,@1<_G1<_G10X!!MS,?P$M@O#\3J"DWB@CG1<_G1<_G1<_GC1<&J2<,I2P]F@8C1<_G1<_G1<_G1<_G1<\ECQDS
DP,G@\_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[1 1 9 4 4 22 5 5 26 5 5 28 5 5 29 7 7 37 8 8 38 8 8 43 9 9 48 9 9 50 10 10 51 11 11 57 11 11 58 12 12 60 12 12 62 13 13 65 14 14 65 13 13 68 15 15 70 14 14 72 15 15 74 18 18 83 18 18 87 18 18 88 18 18 89 21 21 102 21 21 104 23 23 108 22 22 109 23 23 111 23 23 112 24 24 114 24 24 118 25 25 120 26 26 121 26 26 123 27 27 128 29 29 134 29 29 137 29 29 139 30 30 141 31 31 142 30 30 143 31 31 145 31 31 146 31 31 147 31 31 148 32 32 148 32 32 149 33 33 153 44 44 155 34 34 161 35 35 161 35 35 164 36 36 169 38 38 175 42 42 169 38 38 176 39 39 179 39 39 181 42 42 182 40 40 184 40 40 185 41 41 189 41 41 191 42 42 191 42 42 193 42 42 194 43 43 197 43 43 199 44 44 203 45 45 205 45 45 206 50 50 192 57 57 192 45 45 208 46 46 209 46 46 211 46 46 212 47 47 214 48 48 219 48 48 221 48 48 222 49 49 223 62 62 220 49 49 224 49 49 225 50 50 227 52 52 225 50 50 228 50 50 229 50 50 230 61 61 229 51 51 232 52 52 235 52 52 237 52 52 239 53 53 239 53 53 240 53 53 242 54 54 244 54 54 246 55 55 246 55 55 247 63 63 243 55 55 248 56 56 248 56 56 250 56 56 251 57 57 252 58 58 253 59 59 253 58 58 254 59 59 254 61 61 254 60 60 255 61 61 255 62 62 255 63 63 255 66 66 220 72 72 243 65 65 254 64 64 255 65 65 255 66 66 255 67 67 255 68 68 255 69 69 255 70 70 255 71 71 255 75 75 252 72 72 255 73 73 255 74 74 255 75 75 255 77 77 252 76 76 255 77 77 255 78 78 255 79 79 255 80 80 255 81 81 255 82 82 255 83 83 255 84 84 255 85 85 255 86 86 255 87 87 255 88 88 255 89 89 255 90 90 255 91 91 255 92 92 255 93 93 255 94 94 255 95 95 255 96 96 255 97 97 255 98 98 255 99 99 255 100 100 255 101 101 255 102 102 255 103 103 255 104 104 255 107 107 255 108 108 255 109 109 255 111 111 255 112 112 255 113 113 255 114 114 255 115 115 255 118 118 255 119 119 255 120 120 255 121 121 255 123 123 255 126 126 255 127 127 255 128 128 255 129 129 255 130 130 255 134 134 255 135 135 255 136 136 255 137 137 255 139 139 255 141 141 255 142 142 255 143 143 255 145 145 255 146 146 255 147 147 255 150 150 255 152 152 255 153 153 255 154 154 255 156 156 255 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@O<@@??@C??0G??8G??8O??<O??<_??>_??>_??>_??>_??>_??>_??>_??>O??<O??<G??8G??8C??0@??@@O<@@@@@') ; yourself); yourself]
!

sphereGray24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sphereGray24x24 inspect
     ImageEditor openOnClass:self andSelector:#sphereGray24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::ChangeSetDiffBrowser class sphereGray24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
''9>_''9>_''9>_''9>_''9>_''9>_''9>_''9>_''9>_''9>_''9<:S5UUT$9@I9>_''9>_''9>_''9>_''9>_Q%)]W%9]V5!!TS$X''''9>_''9>_''9>_''2%VWVE$Y&]&X%9YUD9F
M@:_''9>_''9>_JE]^X6%/]GQ2[FU_VEIKQCHI''9>_''9>_T55#Z7U: XNB^''I&WEUNQ38''''9>_''9=AVE=(]G6K$IFN!!W-0X%]PRTD5D)>_''9=QV&I-^X&T&I&U
#XA5Y%)PRTH8I)>_''3ESV&M/_8:V&9:Z$8U7Y%)QRTL9K@2_''4MSV&I0_8.V''I6Y#8Q8YU%PRDH8KQF_''4YQVFA-^(ZP%9^R"''93X%YNQ$@7KAV_''4UOUU1''
]G2H#H2G G!!*WUIJQC45J!!Z_''4EKTU]_ZWM:_W9:]&1!!U$5FPS(1I!!N_''3-FSUEWW&Q,\WE.Y5=WS$!!COSX.H >_''29ARD1PUU%\XFA^V%QNRDP?NCD(G@&_
''1$:P$YJSUAQT%MQS4)FP3<9L"0"E J_''9<0N4EEQ$!!JR$%HQ$QAOS$3KRP[C)>_''9<XLC =PDICP4MBPC8:M#D-IQ4Q@9>_''9>_G2<4NC(;OC,:NCX2K2(#
GQLH''9>_''9>_A!!8)K#@2L3L2LB8+I"DZDP(@''9>_''9>_''0PVHRT''JR$(I"L F1XPA0B_''9>_''9>_''9>_B1PYGA4\F!!\SD@0C''9>_''9>_''9>_''9>_''9<EB 4N
CP(F@Y>_''9>_''9>_''9>_''9>_''9>_''9>_''9>_''9>_''9>_''9>_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[3 3 3 8 8 8 10 10 10 11 11 11 13 13 13 14 14 14 17 17 17 18 18 18 19 19 19 21 21 21 22 22 22 23 23 23 24 24 24 25 25 25 27 27 27 31 31 31 33 33 33 37 37 37 38 38 38 39 39 39 40 40 40 41 41 41 42 42 42 44 44 44 45 45 45 47 47 47 48 48 48 49 49 49 50 50 50 51 51 51 52 52 52 54 54 54 55 55 55 56 56 56 57 57 57 59 59 59 60 60 60 61 61 61 62 62 62 63 63 63 64 64 64 65 65 65 66 66 66 67 67 67 68 68 68 69 69 69 70 70 70 71 71 71 73 73 73 74 74 74 75 75 75 76 76 76 77 77 77 78 78 78 79 79 79 80 80 80 81 81 81 82 82 82 83 83 83 84 84 84 85 85 85 86 86 86 87 87 87 88 88 88 89 89 89 90 90 90 91 91 91 92 92 92 93 93 93 94 94 94 96 96 96 97 97 97 98 98 98 99 99 99 100 100 100 101 101 101 102 102 102 103 103 103 104 104 104 105 105 105 106 106 106 107 107 107 108 108 108 109 109 109 110 110 110 111 111 111 112 112 112 113 113 113 114 114 114 115 115 115 116 116 116 117 117 117 118 118 118 119 119 119 120 120 120 121 121 121 122 122 122 123 123 123 124 124 124 125 125 125 126 126 126 127 127 127 128 128 128 129 129 129 130 130 130 131 131 131 132 132 132 133 133 133 134 134 134 135 135 135 136 136 136 137 137 137 138 138 138 139 139 139 140 140 140 141 141 141 142 142 142 143 143 143 145 145 145 146 146 146 147 147 147 151 151 151 153 153 153 154 154 154 156 156 156 158 158 158 159 159 159 160 160 160 161 161 161 162 162 162 163 163 163 166 166 166 168 168 168 169 169 169 170 170 170 172 172 172 173 173 173 176 176 176 177 177 177 178 178 178 179 179 179 181 181 181 182 182 182 188 188 188 189 189 189 190 190 190 191 191 191 192 192 192 194 194 194 197 197 197 198 198 198 199 199 199 203 203 203 204 204 204 209 209 209 212 212 212 213 213 213 214 214 214 217 217 217 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@O<@@??@C??0G??8G??8O??<O??<_??>_??>_??>_??>_??>_??>_??>_??>O??<O??<G??8G??8C??0@??@@O<@@@@@') ; yourself); yourself]
!

sphereLime16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sphereLime16x16 inspect
     ImageEditor openOnClass:self andSelector:#sphereLime16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class sphereLime16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
Q$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ"T''IRTTQ$YFQ$YFQ$XTJ24/K24+I2PYBDYFQ$XTJB4/MCT2K"$%G1%FQ$YFJR,5N#=@OS -JRH^CDYFQ"$-M39CP3<;
K"$"G1QFQ!!<)KS,>QDP?OR8)H!!4VB4X!!JB,8OTIBO#(-I2H]EP1FG"T(K3P:N#T2JBL^GAPLQ!!4#IR0.L3P/KBP"GQ(QBDXOG"@#IRX%IBL_GQ$UC@IFQ!!0^
HRH"H"D_GQ(VD0]FQ$XQE!!,\GA0ZF!!\TD@%FQ$YFAA@VE1$YFAXSDP$DQ$YFQ$YFAP0OD@8MB@UFQ$YFQ$YFQ$YFA@\EA@EFQ$YFQ @a') ; colorMapFromArray:#[3 5 2 7 11 5 9 14 6 14 20 9 19 28 12 23 33 14 24 36 15 26 38 17 30 45 19 36 53 22 38 56 23 39 57 24 41 61 25 45 66 28 48 71 30 49 73 30 52 77 32 57 85 35 62 92 38 64 95 39 67 100 41 71 104 43 73 108 45 77 114 47 79 117 48 80 119 49 83 124 51 87 129 53 89 132 54 93 138 57 96 143 58 99 146 60 103 153 62 104 154 63 106 158 64 110 163 66 112 167 68 116 172 70 118 176 71 119 176 72 121 180 73 125 186 76 128 190 77 131 194 79 133 198 80 135 201 81 138 205 83 142 211 85 144 215 87 145 216 87 148 220 89 151 224 91 154 229 92 157 233 94 160 238 96 163 242 98 168 247 101 169 249 102 174 252 104 178 253 107 185 254 111 188 255 113 196 255 117 202 255 121 210 255 126 214 255 128 219 255 131 225 255 135 235 255 141 240 255 144 0 0 0]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C8A?<O?0??#?>_?=??7??_?=??3?>O?0??@?0@>@b') ; yourself); yourself]
!

sphereLime24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sphereLime24x24 inspect
     ImageEditor openOnClass:self andSelector:#sphereLime24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::ChangeSetDiffBrowser class sphereLime24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
Q$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$X\IR\''IRT^EDYFQ$YFQ$YFQ$YFQ$YFHR$+J2,*JR &IB@TQ$YFQ$YFQ$YFQ!!P(J24-K2<.KR,)I2P!!
FP!!FQ$YFQ$YFEB +KR<3MCT3L"8,JRT#G1$EQ$YFQ$YFIR,-LCT8N34;NCP.JR\$H!!4TQ$YFQ$X_JR,/MS(>O4@?OS 3KR$%H!!8YCDYFQ$X%JR42M39AP4MA
O3,5K"$%H!!<ZEDYFQ!!$''JR82N#=BQDUDPS46K"$%H!!<\EP]FQ!!<%JR43N39BQDQCO346K"$%H!!4[E -FQ"D%JB,2NC5@P$IAO#(4KR\$H!!4ZEP1FQ!!<%I2(/
MS =O38=N#\0J"T#G10ZEP5FQ!!8#IR +K3P8N#(8MSH,JBL"G!!0XE@1FQ!!4 H2T(KB80L3P2K20(IBH_GQ(VDP!!FQ!!X_HRL%JB +J20+JRX$HQ<]F!! TD@QF
Q <\G"@#H2T%I"T%IBL G14\FQTQC@IFQ$XWGA8_HRH#H"H"HQ<^GQ(YE!!LNA4YFQ$XME1(]GQ<_G1<^G!!4\F!!$VD1@I@$YFQ$YFDQXYF10\GA0\F!!(YE1PR
D@$DQ$YFQ$YFAA@TE!!\YFQ$XFAXUD1DPBPP@Q$YFQ$YFQ LMDQHTEAPTD1HQD@0HA@AFQ$YFQ$YFQ$YFAP0OC1@PC 4KB@TAQ$YFQ$YFQ$YFQ$YFQ$XCA@\G
APPC@TYFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YF@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[3 5 2 7 11 5 9 14 6 14 20 9 19 28 12 23 33 14 24 36 15 26 38 17 30 45 19 36 53 22 38 56 23 39 57 24 41 61 25 45 66 28 48 71 30 49 73 30 52 77 32 57 85 35 62 92 38 64 95 39 67 100 41 71 104 43 73 108 45 77 114 47 79 117 48 80 119 49 83 124 51 87 129 53 89 132 54 93 138 57 96 143 58 99 146 60 103 153 62 104 154 63 106 158 64 110 163 66 112 167 68 116 172 70 118 176 71 119 176 72 121 180 73 125 186 76 128 190 77 131 194 79 133 198 80 135 201 81 138 205 83 142 211 85 144 215 87 145 216 87 148 220 89 151 224 91 154 229 92 157 233 94 160 238 96 163 242 98 168 247 101 169 249 102 174 252 104 178 253 107 185 254 111 188 255 113 196 255 117 202 255 121 210 255 126 214 255 128 219 255 131 225 255 135 235 255 141 240 255 144 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@O<@@??@C??0G??8G??8O??<O??<_??>_??>_??>_??>_??>_??>_??>_??>O??<O??<G??8G??8C??0@??@@O<@@@@@') ; yourself); yourself]
!

sphereOrange16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sphereOrange16x16 inspect
     ImageEditor openOnClass:self andSelector:#sphereOrange16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class sphereOrange16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
P$IBP$IBP$IBP$IBP$IBP$IBP$IBP",+J2$UP$IBP$IBP$HUKR8/LB8.J2(YA4IBP$HTKR81L3L1K24+H!!%BP$IBKR82M#4=NCT.J2X"B$IBP"4.MC)@PC,6
K24(H!!IBP"H-K#X:PTD<NB<-I2HWBTH%KB85NC<?N#X.J2X!!E )BHR,+LCH5M#L1KB$!!G!!LJP!!8)J28/L#D/K"(''G1(QA4HMH"T)J",+JR "G1$VB EBP!!8!!
IR\''I2X"G14WD YBP$HOE1,^G!!<]F!!\VC %BP$IBA@<WFA$YFA\RD@$DP$IBP$IBAP(NC 4KA0UBP$IBP$IBP$IBAPTEA@EBP$IBP @a') ; colorMapFromArray:#[8 3 1 20 10 4 30 14 6 36 18 8 44 21 10 52 25 11 58 29 13 66 33 14 70 35 16 84 42 18 92 46 20 98 49 22 108 54 23 110 55 24 115 57 25 126 62 27 128 63 27 131 65 28 140 70 30 144 71 30 148 74 31 150 75 32 156 77 33 163 81 34 173 86 36 179 89 37 186 92 39 190 95 40 191 99 41 192 95 40 196 97 41 204 102 43 208 103 43 213 106 44 219 109 46 219 114 47 224 111 46 229 114 47 230 114 48 236 117 49 240 119 50 245 123 51 250 125 52 253 130 54 255 135 56 255 139 58 255 147 61 255 153 63 255 156 65 255 164 67 255 171 70 255 175 72 255 178 73 255 186 77 255 193 79 255 196 80 255 204 84 255 209 86 255 215 88 255 219 89 255 230 94 255 232 95 255 236 96 255 243 99 255 248 102 255 254 106 0 0 0]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C8A?<O?0??#?>_?=??7??_?=??3?>O?0??@?0@>@b') ; yourself); yourself]
!

sphereOrange24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sphereOrange24x24 inspect
     ImageEditor openOnClass:self andSelector:#sphereOrange24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::ChangeSetDiffBrowser class sphereOrange24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
P$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$H\J2,+J2$!!ETIBP$IBP$IBP$IBP$IBH24-K"4.KR,+JRTTP$IBP$IBP$IBP!!T,KR8/K3@/K"8-J2(&
FP]BP$IBP$IBEB4-K#D1L3L3LR<.KR,)H!!$EP$IBP$IBJ28.LCL5M3\7MSH/KR,*IR@TP$IBP$H!!KR80L#X:OS4;NCT1K",+I"HZB$IBP$H+KR81MC(=PD@?
N3X3K24*JBH]D$IBP!!$+KR81M#,?PTEAOS 3K24*I2H[E0YBP"H+KR82M#(?PTE@OC 4K24*I2H[E0%BP"T+KB81MS <O3<=N#X2K",*I"D[E )BP"T*KB40
L3T9N#,9M#P1KR,''H!!<YE )BP"D)J2,.LCH5MSX5L3D.KB$&HQ8XD0)BP!!8%JR,,K"<1L#D1K28+J"\"G1(WDP]BP!!\!!I"$*J20-K"8.KR,)I2H G!! UC QB
P 4^H"T(JR(+J2,+JR %H!!<]FQXQB EBP$HXG"D$IR\(I2\&I"H!!G14YE1HMA$IBP$HKFA4_HBH"H"H"HR@^F1 WD 8I@TIBP$IBC1\YF18^G!!<^GQ(YE1XR
C $DP$IBP$IBA@<UE1 YFQ$XFA\VD!!@MBPP@P$IBP$IBP HJDQHSEQTUD1HOCP,H@0ABP$IBP$IBP$IBAP(LC 8NCP,IA0TAP$IBP$IBP$IBP$IBP$HBAPTF
APPC@TIBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[8 3 1 20 10 4 30 14 6 36 18 8 44 21 10 52 25 11 58 29 13 66 33 14 70 35 16 84 42 18 92 46 20 98 49 22 108 54 23 110 55 24 115 57 25 126 62 27 128 63 27 131 65 28 140 70 30 144 71 30 148 74 31 150 75 32 156 77 33 163 81 34 173 86 36 179 89 37 186 92 39 190 95 40 191 99 41 192 95 40 196 97 41 204 102 43 208 103 43 213 106 44 219 109 46 219 114 47 224 111 46 229 114 47 230 114 48 236 117 49 240 119 50 245 123 51 250 125 52 253 130 54 255 135 56 255 139 58 255 147 61 255 153 63 255 156 65 255 164 67 255 171 70 255 175 72 255 178 73 255 186 77 255 193 79 255 196 80 255 204 84 255 209 86 255 215 88 255 219 89 255 230 94 255 232 95 255 236 96 255 243 99 255 248 102 255 254 106 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@O<@@??@C??0G??8G??8O??<O??<_??>_??>_??>_??>_??>_??>_??>_??>O??<O??<G??8G??8C??0@??@@O<@@@@@') ; yourself); yourself]
!

svn_persp
"      Loaded from: /tmp/full/cview16/svn_persp.gif"

    ^ GenericToolbarIconLibrary repositorySVNIcon
!

svn_prop_add
"      Loaded from: /tmp/full/ctool16/svn_prop_add.gif"

    "
     self svn_prop_add inspect
     ImageEditor openOnClass:self andSelector:#svn_prop_add
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class svn_prop_add'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
KRPEC!!,[F1,EJ24-KR4-KR4E@!!(PDA@$@ T-KRX-KR4-F2P[CP4MF04@KRX!!I"4-KQ,VF!!@$E 4M@!! XHQ XKR4[E!!(PIAXMCPH%IRT%IR@-F1XZDBPVCP4B
A0\FA0\-KQ,VF!!@$E 4MBBD''C2\WKR4[E!!(PIAX,B"$_BQHIDR4-F1XZDBPVE@DZF!!(LFQ0-KQ,VF!!@$E" *F 0*F!!LYKR4[E!!(PI@ ]@1(ZF 0CBB4-F1XZ
DBPHH0LZC@LCB0P-KQX@F!!@$GA8UF 0UEQ8\KR4EE @B@ HTFP0AH!!$YKR4-KR4-KR4-KR4"BB0\KR4-KR4-KR4-KR4-KR4-KR4-KP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[127 95 63 93 179 225 159 95 63 9 153 214 86 143 189 223 191 95 252 231 163 166 130 26 90 142 188 255 243 217 100 154 198 40 148 204 184 205 224 255 159 63 159 127 127 251 221 131 255 255 159 194 135 54 153 116 19 69 158 208 106 154 194 49 163 220 255 191 95 240 225 203 181 146 35 91 150 196 255 255 255 191 127 63 141 182 214 25 154 210 83 148 195 255 235 179 174 138 31 254 251 237 91 165 212 52 150 203 255 223 159 253 244 207 186 151 38 158 121 22 82 162 209 106 166 209 57 169 221 255 191 127 99 148 191 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_<A?2G?\_?9??7?>_?9??''?>_?9??''?>_?9??@A8@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svn_synch
"      Loaded from: /tmp/full/wizards/svn_synch.gif"

    "
     self svn_synch inspect
     ImageEditor openOnClass:self andSelector:#svn_synch
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class svn_synch'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
N#(:N#(:N#(:N#(/K2</N#(:N#(:N#(LN#(/I!!,^JR<:N#(A@P8LC@0:LB0#JB80N#(:@S(:N 0:N#D"FA0)LS(:N 8:N#(:N#(2H!!$]JSH:N 0LCC(:N#(:
MBHXG2$3N#(:CC(:N#(:N#T!!FB@*M#(:N#(:N#(:N#(7I1(%J3 :@ (KA@XGB@$:N#$9NS$:N DOD!!@QD1\IN#(:N#(:N#(BB ,CAP\HBS(:N#(:N#(:KQXV
E!!XVE"4:N#(:N#(:N"PVEQTUEQT$N#(:N#(:N#(@E!!PTEAPT@C(:N#(:N#(:CP4MCP4MCP4:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 21 71 174 25 50 99 33 59 112 33 60 112 37 64 118 37 64 117 41 68 123 45 72 126 47 75 130 26 53 103 29 56 106 21 58 120 78 91 112 24 70 136 73 146 222 115 177 234 137 188 237 90 165 215 146 206 249 237 248 254 227 246 255 196 238 255 183 227 239 252 248 156 252 248 157 249 237 89 252 245 155 246 229 100 246 229 103 246 229 105 246 229 106 246 229 109 247 226 106 247 226 107 244 218 79 117 110 75 237 199 47 251 216 77 242 205 78 233 189 42 241 195 47 241 195 48 248 193 35 238 190 46 141 118 66 223 143 15 190 125 16 186 122 17 183 117 20 177 110 24 172 105 28 171 104 28 166 99 31 166 100 31 161 95 35 160 95 35 158 92 37 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A8AO1>?DS<PO3 ?DC<@O7>^_8A? G>@_8A? G>@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svn_wizban
"      Loaded from: /tmp/full/wizban/svn_wizban.gif"

    "
     self svn_wizban inspect
     ImageEditor openOnClass:self andSelector:#svn_wizban
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class svn_wizban'
        ifAbsentPut:[(Depth8Image new) width: 75; height: 66; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/+2:-3Y?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/+29=3Y6]''Y?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/+2:.O\6]''Y6]''Y?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;6;N_''7]''Y6]''Y6]''Y?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;:
=.7)9>S\6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/O):^''''7M''Y6]''Y6]''Y6]''Y
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;5;^7-:^O[7M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>>_C-;^7-8=3\7M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/+2;^7-;^+\7]3\7M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;><>7-;^7-:.K]7]3\7M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/+0;^7-;^7*7]7]
7]3\7M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;/:N#/;>?/;>?1;>?/;>?/;>?/;>?1<_G/;>?1<^?/;>?/<^?/;>?/;>?1<_G1;>?/;>?/;=''Y6]''Y6]''Y6]''Y
?/;>?/;>?/;>?/;1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_C1<_G1<_G1<]''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;1;^+*
:.+*:.+*:.+*:.+*:.+*:.+*;.;*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+-:.?/<]''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;%Q3(9S4=YXVE,[F17]7]7]7]7
]7]7]7]7]7]9]7]=]7]7]7]7]7]7]6Y&XVE_W5=6#;F<;=''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;%CPXCE2@4PT%TUE5$YF!!(ZF!!0\''I3\7M3\7M2\7I2\7M/
\F=/YFQ VV17 YN'',[F*''I>$8M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;^B0LRE"H3Q$5SWFM#Z7E-[V51\WQ5]WU5]WU5]WU3\6=(ZF].^YJ//=?$9NS"7M_M
2Y2#8M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;MB P]JR<<Q%A[WFM-[V51\WE5]GQ5]WQ4]GU5]V=([''"M(K+Y9OO6>/+:>/+:=>SF''T=H3]''Y6]''Y6]''Y6]''Y
?/;>?/;>?/;>?/;IB P^K3@5P%EPV59#Z651\WE5]GQ4\7M3[7A/ IJ.0.K0=/+:>/+:>/[#0*>JWT$7E0DH1]''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;@B P]
K3@0ODILTFM#Z6--[WQ4]GM/\F:@#J?H7^+3=/+:>/+:9MJ:&()0VDP6KB4,F0LM0M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;EB P]K280LDIJTE-#Z65-ZF!!(
ZGNQ+,K[:/O:>/+:>/+''2Z>T GM$W%!!LQS00LC@/G LM0M''Y6]''Y6]''Y6]''Y?/;>?/;>?/;>?/;@B P^K28.LCUBR%EZX59''Z(BY.]''*<?+:>/+:>.ST-9&@
\6!!(Y6-#WEAJP#T.K"8/G LM1]''Y6]''Y6]''T5L/K?/;>?/;>?/;>?/;@A0T^K28.K#@5QTQSYG:.2NS0=/+>>/+:<=6=(H)8^GM3\V-+[VM"V41BMR8.K"8/
G LM/-''Y7MGK2,#D1LSD?/;>?/;>?/;>?/;@A0T^K28.JBD"PV>+2>+0>/;>?/+::=67$(A3\''M3\7M1\V-+Z6I[TTH.LB8.K"8/G LM0MGJ1<_D1LSD1LSD
?/;>?/;>?/;>?/;@A0L#JBD!!M&NU2NW3>/;>?/+:=-67#HA8\7M4\WQ4[WE-Z65#X5-PQ#<0K"8.K"8/G PM0L+J1<_D1LSD1LSD?/;>?/;>?/;>?/;@A0LU
L%Q?-=S$<?+>?/;>>/CO*X);\&=/]GQ1]F5-[WE+Z6M#V5AJP"<0K"8.K"8/GPPJ0L+J1<_D1LSD1LSD?/;>?/;>?/;>?/;@B@-]*<?%>/;>?/;>?/+6/Y%8
ZF5+[WE-[V51[WE1Z6-+X6I[TT0;L24(JB$!!HRD!!EPLO0L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<RG_I<O+>?/;>?/;>>-2RYE1\W&M+Z6-1[WE1\V-+X59^
T5MKPC44M35DR5]$\''>M D=&0L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<$I3-?/;>>_/>?/;>=(D=O$1LT5!!^WE1$W%9$Y6Q''\F=3^8^G#)Z(,++I3=[W7.W%
38>W/L+J1<_D1LSD1LSD?/;>?/;>?/;>?/;A&931?/;>?/;>?/;>>*]YRT9WWV!!.^HBM$Y6,-;+B2MS[7];":.+0=/[:>/+>?/;>7):^/L+J1<_D1LSD1LSD
?/;>?/;>?/;>?/:<&9?1?/;>?/;>?/;>>-^6(JB +:>6/[7I3=S]9^+*=/+>?/;>?/;>?/;>?/;>?/;>7)2\/L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<&9?1
?/;>?/;>?/;>?/+:=/O3=/+:>/+:?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>8I>[/L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<&9?1?/;>?/;>?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>>/;>?/;>?/;>?/;>?/;>8I>[/L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<&9?1?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;:>/+:>/+:
<?C+:>/6>/+>?/;>?/;>8I>[/L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<&9?0?/;>?/;>?/;>?/;>?/;:>/+:<>+$7]SI/[Z7+:& &X6M#YJ --;>?/;>?/;>
8I>[/L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<&930?/+:>/+:>/+0:>K]4,":-:> $(]?\6!!]T4-DP35@M#L3M#L=PX36?/;>?/;>8I2\/L+J1<_D1LSD1LSD
?/;>?/;>?/;>?/:<%93":.W%7-_V3<&:,*"U!!7Q+WD-DN3X+HRD!!H" (JB )JB4-KR "IV;0?/;>?/;>7):^/L+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<Y%&R
$(.G\&QWR4@7M20#H"D!!JB (KR4.K"8.K"8.K"8.K"8.JB03W[?:?/;>?/;>7*FW/L#J1<_D1LSD1LSD?/;>?/;>?/;>?/:>C0L[H"D!!HR$(JB -KS@0LC@0
LC@.K"8.K"8.K"8.K"<.K"8-M$.M6_+>?/''9?/;:2XE&/L_G1<_D1LSD1LSD?/;>?/;>?/;>?/:>BPL]K3@.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"4)
L4AS#\#:>/;>?/;::=&:^Q0N/,KG1<_D1LSD1LSD?/;>?/;>?/;>?/:>BP1LTUX(K"8.K"8.K"8.K"8.K"8.K"8.LC@-KR -LC9K^J''Y>/+:?/;::-&?%VL;
EPLM/+&9/<_D1LSD1LSD?/;>?/;>?/;>?/:>BQVC_HT(K"8.K"8.K"8.K"81K"8.K"<.KR4(KCH=VH:?;_+:>/+:<>+T+&=CH"D(GPPM/+B90+>?1LSD1LSD
?/;>?/;>?/;>?/:>BPL"LB4.K"8.K"8.K"8.LB8/K3@.K#@-KCQN[*CH:?+:>/+6<NWL)V-@HRD(LC@-G LM/+N90,KB1LSD1LSD?/;>?/;>?/;>?/;@BPP<
P$H.K"8.K"8.K#@/K"4)J202N4M]!!;#_<?+:>/+3:-.:$%47H"D*K"8.K"8/G LM/+&90,J?1LSD1LSD?/;>?/;>?/;>?/;@BQND!!HP(K#@.K"8.K"8-LCH=
RVBM-=S3>/+:>/O-9\"%\4L+H2D(K3@.K"8.K"8-GPLM/+?B0,KD1LSD1LSD?/;>?/;>?/;>?/;@BPL"L3T(KR<-JB02M$QX_)*;8/_:>/+:<>+"2J"BU3\"
H"D.K"8.K"8.K"8.LC@-GPLM/,^?0,_D1LSD1LSD?/;>?/;>?/;>?/;@B L]KB 2L3]KWW"Y.]K3>/+:>/[0:.KL*7=XN20"HR40KR8.K"8.K"8.K"8.LC@/
G PM/,+J1<_D1LSD1LSD?/;>?/;>?/;>?/:>BP(4SVRG)\[_=O+:>/+:>/[39L"(^5P7H"D!!JC@.K"8.K"8.K"8.K"8.K"8.K#@/G PM0L+J1<_D1LSD1LSD
?/;>?/;>?/;>?/:<Y''_I;_+:>/+:>/+3<N7].9U1SSH"H"L#JS@0KR4-KR</KR4-LB4-KS@.K"4.K"8)G LM/,+J1<_D1LSD1LSD?/;>?/;>?/;>?/:<%:GW
5=#W4MCP/Z&LXC(''FQTUE!!X]F!!(ZF!!(]F!!(ZF!!8]GQ(ZF!!(ZF!!(]F!!(ZF!!4ZE LM0L+J1<_D1LSD1LSD?/;>?/;>?/;>?/*<%9"X$817US$_DP$@@@@A@0LC
@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCA@PC@0LM1\+J1<_D1LSD1LSD?/;>?/;>?/;>>_+C"EH8IA PC 8OC0<QDQDQDQDQDQDODQDODQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQP&0<+J1<_D1LSD1LSD?/;>?/;>?/;>>/+N-Y.I"X&I!!(ZF!!(ZH!!("F"HZH!!("F"H"F"H"F"HZF"HZH!!("F"HZH!!("F"HZH!!("H
#9254<+J1<_D1LSD1LSD?/;>?/;>?/;9>/+Z0[R-)JZ"(*J"(*Z&)*Z&(*J"(*J"'':Z&)*Z&)*Z&))>&)*Z&(*J"(*J")*Z&(*J$+[SA6,+J1<_D1LSD1LSD
?/;>?/;>?/'':>/+(6,;A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\;Z:L+J1<_D1LSD1LSD?/;>?/;>?/+:>/#5<?O3
<?O0<OC0;N3,;N+):._''9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD?/;>?/;>>/+:=/W5<?O3<?O0<OC0;N3,;^+):._''
9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD?/;>?/;:>/+6=_W5<?O3<?O0<OC0;N3,:.7):._''9NS$9NS$8>K\7M3]7]/[
6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD?/;>?/;:>_[6=_W5<?O3<?O0<OC0;N3-:^7):._''9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K
2<3L2,+J1<_D1LSD1LSD?/;>?/+9=/[6=_W5<?O3<?O0<OC0;N3*;^7):._''9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD
?/;>?/''6=/[6=_W5<?O3<?O0<OC0;N7);^7):._''9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD?/;>>_+9=/[6=_W5<?O3
<?O0<OC0;OC-;^7):._''9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD?/;>>/''9=/[6=_W5<?O3<?O0<OC0;N3-;^7):._''
9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD?/;9>/''9=/[6=_W5<?O3<?O0<OC0<OC-;^7):._''9NS$9NS$8>K\7M3]7]/[
6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD?/'':>/''9=/[6=_W5<?O3<?O0<OC0;_C-;^7):._''9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K
2<3L2,+J1<_D1LSD1LSD?/+:>/''9=/[6=_W5<?O3<?O0<OC,<OC-;^7):._''9NS$9NS$8>K\7M3]7]/[6=''Y5]WU5MKR4-KQ4\/K2<3L2,+J1<_D1LSD1LSD
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[108 123 153 104 127 155 106 126 161 108 127 162 103 128 168 97 130 169 113 128 158 112 131 154 116 131 149 119 130 155 116 131 162 112 135 164 115 134 170 116 135 158 125 133 152 124 135 160 125 137 150 120 138 162 114 139 180 114 142 176 122 141 165 121 141 177 118 142 184 120 144 173 131 143 156 128 143 174 121 145 186 125 145 181 133 144 169 123 147 189 117 149 189 135 146 171 126 150 179 127 151 193 131 151 187 125 153 187 143 151 159 136 151 182 141 152 165 134 153 177 129 153 195 123 156 196 126 155 202 128 156 191 135 154 191 130 155 197 127 156 204 125 158 198 132 156 198 121 159 205 137 156 193 131 159 194 142 157 188 135 159 201 140 159 196 138 161 191 152 160 168 152 159 180 146 161 180 142 161 198 138 162 204 146 161 192 136 164 199 132 165 205 141 165 194 147 166 190 142 166 209 151 166 197 145 168 198 147 167 204 142 169 205 156 168 181 163 167 182 151 170 194 146 170 212 148 171 201 151 170 207 155 170 202 158 170 196 157 172 191 154 174 211 148 176 211 168 174 176 153 176 206 156 176 200 166 174 194 152 176 219 164 175 202 161 176 208 162 177 197 152 180 216 159 178 216 157 180 211 161 180 205 164 179 211 172 180 189 166 181 200 169 181 194 161 181 218 160 183 214 164 183 208 166 182 214 177 181 197 171 182 209 166 185 210 168 184 216 177 184 205 170 185 218 174 186 200 164 188 218 172 187 206 168 188 213 175 186 213 172 187 219 177 188 215 171 190 215 167 191 221 174 189 221 184 190 192 179 191 204 176 192 211 183 190 212 180 192 206 173 193 218 166 194 231 187 192 207 182 194 221 176 196 221 181 196 216 185 196 210 187 195 216 180 196 228 178 197 236 174 198 242 192 197 200 180 199 225 193 198 201 196 198 195 184 200 220 188 200 227 189 201 215 187 202 222 185 204 229 198 203 205 205 202 207 196 203 225 190 205 225 198 206 214 200 205 220 189 208 234 196 207 234 208 206 210 200 208 216 197 209 223 195 210 230 207 209 206 204 210 212 202 209 231 211 209 213 209 211 208 200 212 226 209 210 220 212 211 202 206 212 214 210 212 209 194 214 239 213 212 203 205 213 221 198 214 234 203 215 229 215 213 217 201 216 236 210 214 230 216 215 206 207 215 236 206 218 233 217 217 228 215 220 223 206 221 241 215 219 235 220 220 211 218 220 217 212 221 229 210 222 236 214 221 243 219 223 239 214 226 240 217 225 246 225 227 223 219 228 236 222 228 230 217 229 243 224 229 232 229 229 219 224 228 244 227 229 226 221 229 251 225 230 233 216 232 252 226 230 246 220 232 246 223 232 240 227 231 247 228 232 248 222 234 248 229 234 237 235 234 224 226 235 243 233 233 244 230 234 250 225 237 252 235 237 234 229 238 246 236 236 247 223 240 246 232 238 240 239 236 241 231 239 248 239 239 229 232 240 249 238 239 249 233 241 250 236 241 244 230 242 255 239 242 238 240 241 252 234 243 251 242 243 253 236 245 253 239 245 247 237 246 255 244 244 255 248 247 237 248 246 250 243 248 251 241 249 255 250 247 252 244 249 252 238 251 252 247 249 246 245 250 253 248 250 247 252 249 254 246 251 254 240 253 254 253 251 255 247 253 255 242 255 255 251 253 250 254 252 255 248 254 255 255 253 251 255 253 255 249 255 255 254 255 252]; mask:((ImageMask new) width: 75; height: 66; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
????????????8O???????????>C???????????? ????????????8O???????????>C???????????? ????????????8O???????????>C???????????? 
????????????8O???????????>C???????????? ????????????8O???????????>C???????????? ????????????8O???????????>C???????????? 
????????????8O???????????>C???????????? ????????????8O???????????>C???????????? ????????????8O???????????>C???????????? 
????????????8O???????????>C???????????? ????????????8O???????????>C???????????? ????????????8O???????????>C???????????? 
????????????8O???????????>C???????????? ????????????8O???????????>C???????????? ????????????8O???????????>C???????????? 
????????????8O???????????>C???????????? ????????????8O???????????>C???????????? ????????????8O???????????>C???????????? 
????????????8O???????????>C???????????? ????????????8O???????????>C???????????? ????????????8O???????????>C???????????? 
????????????8O???????????>C???????????? ') ; yourself); yourself]

    "Created: / 11-04-2008 / 11:32:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svn_wizban2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self svn_wizban2 inspect
     ImageEditor openOnClass:self andSelector:#svn_wizban2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class svn_wizban2'
        ifAbsentPut:[(Depth8Image new) width: 51; height: 38; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
Q3(9S4=YXVE,[F17]7]7]7]7]7]7]7]7]7]9]7]=]7]7]7]7]7]7]6Y&XVE_W5=6#;F<CPXCE2@4PT%TUE5$YF!!(ZF!!0\''I3\7M3\7M2\7I2\7M/\F=/YFQ 
VV17 YN'',[F*''I>$B0LRE"H3Q$5SWFM#Z7E-[V51\WQ5]WU5]WU5]WU3\6=(ZF].^YJ//=?$9NS"7M_M2Y2#B P]JR<<Q%A[WFM-[V51\WE5]GQ5]WQ4]GU5
]V=([''"M(K+Y9OO6>/+:>/+:=>SF''T=HB P^K3@5P%EPV59#Z651\WE5]GQ4\7M3[7A/ IJ.0.K0=/+:>/+:>/[#0*>JWT$7E0DHB P]K3@0ODILTFM#Z6--
[WQ4]GM/\F:@#J?H7^+3=/+:>/+:9MJ:&()0VDP6KB4,F0LMB P]K280LDIJTE-#Z65-ZF!!(ZGNQ+,K[:/O:>/+:>/+''2Z>T GM$W%!!LQS00LC@/G LMB P^
K28.LCUBR%EZX59''Z(BY.]''*<?+:>/+:>.ST-9&@\6!!(Y6-#WEAJP#T.K"8/G LMA0T^K28.K#@5QTQSYG:.2NS0=/+>>/+:<=6=(H)8^GM3\V-+[VM"V41B
MR8.K"8/G LMA0T^K28.JBD"PV>+2>+0>/;>?/+::=67$(A3\''M3\7M1\V-+Z6I[TTH.LB8.K"8/G LMA0L#JBD!!M&NU2NW3>/;>?/+:=-67#HA8\7M4\WQ4
[WE-Z65#X5-PQ#<0K"8.K"8/G PMA0LUL%Q?-=S$<?+>?/;>>/CO*X);\&=/]GQ1]F5-[WE+Z6M#V5AJP"<0K"8.K"8/GPPJB@-]*<?%>/;>?/;>?/+6/Y%8
ZF5+[WE-[V51[WE1Z6-+X6I[TT0;L24(JB$!!HRD!!EPLORG_I<O+>?/;>?/;>>-2RYE1\W&M+Z6-1[WE1\V-+X59^T5MKPC44M35DR5]$\''>M D=&$I3-?/;>
>_/>?/;>=(D=O$1LT5!!^WE1$W%9$Y6Q''\F=3^8^G#)Z(,++I3=[W7.W%38>W&931?/;>?/;>?/;>>*]YRT9WWV!!.^HBM$Y6,-;+B2MS[7];":.+0=/[:>/+>
?/;>7):^&9?1?/;>?/;>?/;>>-^6(JB +:>6/[7I3=S]9^+*=/+>?/;>?/;>?/;>?/;>?/;>7)2\&9?1?/;>?/;>?/;>?/+:=/O3=/+:>/+:?/;>?/;>?/;>
?/;>?/;>?/;>?/;>?/;>8I>[&9?1?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>?/;>>/;>?/;>?/;>?/;>?/;>8I>[&9?1?/;>?/;>?/;>?/;>?/;>?/;>
?/;>?/;:>/+:>/+:<?C+:>/6>/+>?/;>?/;>8I>[&9?0?/;>?/;>?/;>?/;>?/;:>/+:<>+$7]SI/[Z7+:& &X6M#YJ --;>?/;>?/;>8I>[&930?/+:>/+:
>/+0:>K]4,":-:> $(]?\6!!]T4-DP35@M#L3M#L=PX36?/;>?/;>8I2\%93":.W%7-_V3<&:,*"U!!7Q+WD-DN3X+HRD!!H" (JB )JB4-KR "IV;0?/;>?/;>
7):^Y%&R$(.G\&QWR4@7M20#H"D!!JB (KR4.K"8.K"8.K"8.K"8.JB03W[?:?/;>?/;>7*FWC0L[H"D!!HR$(JB -KS@0LC@0LC@.K"8.K"8.K"8.K"<.K"8-
M$.M6_+>?/''9?/;:2XE&BPL]K3@.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"4)L4AS#\#:>/;>?/;::=&:^Q0NBP1LTUX(K"8.K"8.K"8.K"8.K"8.K"8.
LC@-KR -LC9K^J''Y>/+:?/;::-&?%VL;EPLMBQVC_HT(K"8.K"8.K"8.K"81K"8.K"<.KR4(KCH=VH:?;_+:>/+:<>+T+&=CH"D(GPPMBPL"LB4.K"8.K"8.
K"8.LB8/K3@.K#@-KCQN[*CH:?+:>/+6<NWL)V-@HRD(LC@-G LMBPP<P$H.K"8.K"8.K#@/K"4)J202N4M]!!;#_<?+:>/+3:-.:$%47H"D*K"8.K"8/G LM
BQND!!HP(K#@.K"8.K"8-LCH=RVBM-=S3>/+:>/O-9\"%\4L+H2D(K3@.K"8.K"8-GPLMBPL"L3T(KR<-JB02M$QX_)*;8/_:>/+:<>+"2J"BU3\"H"D.K"8.
K"8.K"8.LC@-GPLMB L]KB 2L3]KWW"Y.]K3>/+:>/[0:.KL*7=XN20"HR40KR8.K"8.K"8.K"8.LC@/G PMBP(4SVRG)\[_=O+:>/+:>/[39L"(^5P7H"D!!
JC@.K"8.K"8.K"8.K"8.K"8.K#@/G PMY''_I;_+:>/+:>/+3<N7].9U1SSH"H"L#JS@0KR4-KR</KR4-LB4-KS@.K"4.K"8)G LM%:GW5=#W4MCP/Z&LXC(''
FQTUE!!X]F!!(ZF!!(]F!!(ZF!!8]GQ(ZF!!(ZF!!(]F!!(ZF!!4ZE LM%9"X$817US$_DP$@@@@A@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCA@PC@0LM"EH8
IA PC 8OC0<QDQDQDQDQDQDODQDODQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQP&') ; colorMapFromArray:#[108 123 153 104 127 155 106 126 161 108 127 162 103 128 168 97 130 169 113 128 158 112 131 154 116 131 149 119 130 155 116 131 162 112 135 164 115 134 170 116 135 158 125 133 152 124 135 160 125 137 150 120 138 162 114 139 180 114 142 176 122 141 165 121 141 177 118 142 184 120 144 173 131 143 156 128 143 174 121 145 186 125 145 181 133 144 169 123 147 189 117 149 189 135 146 171 126 150 179 127 151 193 131 151 187 125 153 187 143 151 159 136 151 182 141 152 165 134 153 177 129 153 195 123 156 196 126 155 202 128 156 191 135 154 191 130 155 197 127 156 204 125 158 198 132 156 198 121 159 205 137 156 193 131 159 194 142 157 188 135 159 201 140 159 196 138 161 191 152 160 168 152 159 180 146 161 180 142 161 198 138 162 204 146 161 192 136 164 199 132 165 205 141 165 194 147 166 190 142 166 209 151 166 197 145 168 198 147 167 204 142 169 205 156 168 181 163 167 182 151 170 194 146 170 212 148 171 201 151 170 207 155 170 202 158 170 196 157 172 191 154 174 211 148 176 211 168 174 176 153 176 206 156 176 200 166 174 194 152 176 219 164 175 202 161 176 208 162 177 197 152 180 216 159 178 216 157 180 211 161 180 205 164 179 211 172 180 189 166 181 200 169 181 194 161 181 218 160 183 214 164 183 208 166 182 214 177 181 197 171 182 209 166 185 210 168 184 216 177 184 205 170 185 218 174 186 200 164 188 218 172 187 206 168 188 213 175 186 213 172 187 219 177 188 215 171 190 215 167 191 221 174 189 221 184 190 192 179 191 204 176 192 211 183 190 212 180 192 206 173 193 218 166 194 231 187 192 207 182 194 221 176 196 221 181 196 216 185 196 210 187 195 216 180 196 228 178 197 236 174 198 242 192 197 200 180 199 225 193 198 201 196 198 195 184 200 220 188 200 227 189 201 215 187 202 222 185 204 229 198 203 205 205 202 207 196 203 225 190 205 225 198 206 214 200 205 220 189 208 234 196 207 234 208 206 210 200 208 216 197 209 223 195 210 230 207 209 206 204 210 212 202 209 231 211 209 213 209 211 208 200 212 226 209 210 220 212 211 202 206 212 214 210 212 209 194 214 239 213 212 203 205 213 221 198 214 234 203 215 229 215 213 217 201 216 236 210 214 230 216 215 206 207 215 236 206 218 233 217 217 228 215 220 223 206 221 241 215 219 235 220 220 211 218 220 217 212 221 229 210 222 236 214 221 243 219 223 239 214 226 240 217 225 246 225 227 223 219 228 236 222 228 230 217 229 243 224 229 232 229 229 219 224 228 244 227 229 226 221 229 251 225 230 233 216 232 252 226 230 246 220 232 246 223 232 240 227 231 247 228 232 248 222 234 248 229 234 237 235 234 224 226 235 243 233 233 244 230 234 250 225 237 252 235 237 234 229 238 246 236 236 247 223 240 246 232 238 240 239 236 241 231 239 248 239 239 229 232 240 249 238 239 249 233 241 250 236 241 244 230 242 255 239 242 238 240 241 252 234 243 251 242 243 253 236 245 253 239 245 247 237 246 255 244 244 255 248 247 237 248 246 250 243 248 251 241 249 255 250 247 252 244 249 252 238 251 252 247 249 246 245 250 253 248 250 247 252 249 254 246 251 254 240 253 254 253 251 255 247 253 255 242 255 255 251 253 250 254 252 255 248 254 255 255 253 251 255 253 255 249 255 255 254 255 252]; mask:((Depth1Image new) width: 51; height: 38; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
????????8O???????>C???????? ????????8O???????>C???????? ????????8O???????>C???????? ????????8O???????>C???????? ????????
8O???????>C???????? ????????8O???????>C???????? ????????8O???????>C???????? ????????8O???????>C???????? ????????8O??????
?>C???????? ????????8O???????>C???????? ????????8O???????>C???????? ????????8O???????>C???????? ????????8O???????>@b') ; yourself); yourself]

    "Modified: / 26-05-2008 / 15:00:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

switch
"      Loaded from: /tmp/full/subversive/switch.gif"

    "
     self switch inspect
     ImageEditor openOnClass:self andSelector:#switch
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class switch'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8MCP8NC 8NC 8NC 8NC 8NCPDMC 8NC 8NC 8NCP4M
CP4A@P4NC 8NC 8N@0 HB@ HB@ H@08NC ,KC 8LC@0LC@HBC@8NC ,@B08NC 8NC 0BC@8NC ,@@@,KB0,KC 8LC@8NC TIBP$IBP$IBP\NC 8NC 8NB PF
B (JB (NC 8NC 8NC 8JA@(NC 8NC 8NC 8NC 8NC (JC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[246 254 255 255 251 239 251 232 158 172 116 19 202 243 246 96 137 140 198 239 242 95 136 139 253 241 199 211 251 254 86 127 130 103 144 147 161 110 19 178 129 26 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@A @G@G>@?<Y?# \_9#?0G>@N@@X@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:33:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

switched_ov
"      Loaded from: /tmp/full/ovr16/switched_ov.gif"

    "
     self switched_ov inspect
     ImageEditor openOnClass:self andSelector:#switched_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class switched_ov'
        ifAbsentPut:[(Depth8Image new) width: 7; height: 8; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'BP$IBP$IBPDBA XF@ $AA DDAPXI@PXAA@TFBPDF@PPEA $AA DDAPXI@PXAA@TFBPDBA XF@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 231 241 255 86 93 181 75 81 159 140 149 255 118 128 250 74 80 157 142 151 255 141 149 255 0 0 0]; mask:((ImageMask new) width: 7; height: 8; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O3<?O3<?O8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

synced
"      Loaded from: /tmp/full/clcl16/synced.gif"

    "
     self synced inspect
     ImageEditor openOnClass:self andSelector:#synced
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class synced'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C0<OC0@@C0<OC0<OC0<OC0<OC0@G@@<OC0<OC0<OC0<OC0@GA0@OC0<OC0<OC0<OC0@LCP,@@@@@@@@@C0<OC0@EA XEA TEA TEAPDOC0<O@P HB@DA@PDA
@PDOC0<OC0<AA@PAC0<OC0<OC0<OC0<OC0DD@P<OC0<@B <OC0<OC0<O@PDOC0<O@@@JC0<OC0<OC0<OC0<OC0@G@@@OC0<OC0<@@@@@@@@@BP$I@@<OC0<@
@08C@0LC@0LC@0L@C0<OC0HB@ HB@ HDA@PBC0<OC0<OC0<OC0<BA@PBC0<OC0<OC0<OC0<O@ PBC0<OC0<OC0<OC0<OC0HBC0<OC0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[189 132 22 170 111 16 166 107 16 252 236 177 251 229 151 252 241 195 253 241 195 254 253 239 252 234 169 253 246 213 186 151 38 254 248 222 254 248 221 253 248 221 251 236 177 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C@@\@C0@_?C?>G?0O@@\L@08@C0O?!!??C?8@O@@8@C@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

synch
"      Loaded from: /tmp/full/subversive/synch.gif"

    "
     self synch inspect
     ImageEditor openOnClass:self andSelector:#synch
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class synch'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
FQ$YFQ$YFQ$YFQ$YFQ$YFQ@GC1$RFQTUD1$YFQ$YFQ$GFPHYD!!$UFQLYFQ$YFQ$YA0HBFQHYEQLEFQXVE 8YFQ$YFQ$YFQ$YFQXJ@Q\TE!!$BFQHUEQ$SFQ$V
E@(TCAXY@!!$RFQLYAQ$YE!!\AE0,VFQHYEQTSFPTYFPPW@Q\TAA$YFQ$YFQ$YFQ$DE0DWE@PYFQ$XFQ X@1$YA!!\AE1PFFQ$YF@LYFQ$IFP@MDQPKA!!$YFQ X
FA$YFP Y@@@@@A$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YBA$YFQ XFA$YFQ$YFQ$YFQ$IFQ$Y@1 YFQ$YFQ$YFQ$YFPLXFA$XFQ$YFQ$YFP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[158 92 37 252 247 156 177 176 176 66 213 78 177 108 25 199 199 200 163 97 33 171 171 171 187 252 194 114 229 127 249 217 71 250 195 38 210 151 15 252 204 69 205 118 15 173 173 173 168 168 167 249 238 94 183 183 183 195 194 194 238 195 46 189 189 189 181 121 19 248 228 107 74 144 69 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@C+ J*@:;0@_+)>*''::_ A>K''81_#"<@@@# AF@C(@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

synch_synch
"      Loaded from: /tmp/full/obj16/synch_synch.gif"

    "
     self synch_synch inspect
     ImageEditor openOnClass:self andSelector:#synch_synch
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class synch_synch'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
N#(:N#(:N#(:N#(/K2</N#(:N#(:N#(LN#(/I!!,^JR<:N#(A@P8LC@0:LB0#JB80N#(:@S(:N 0:N#D"FA0)LS(:N 8:N#(:N#(2H!!$]JSH:N 0LCC(:N#(:
MBHXG2$3N#(:CC(:N#(:N#T!!FB@*M#(:N#(:N#(:N#(7I1(%J3 :@ (KA@XGB@$:N#$9NS$:N DOD!!@QD1\IN#(:N#(:N#(BB ,CAP\HBS(:N#(:N#(:KQXV
E!!XVE"4:N#(:N#(:N"PVEQTUEQT$N#(:N#(:N#(@E!!PTEAPT@C(:N#(:N#(:CP4MCP4MCP4:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 21 71 174 25 50 99 33 59 112 33 60 112 37 64 118 37 64 117 41 68 123 45 72 126 47 75 130 26 53 103 29 56 106 21 58 120 78 91 112 24 70 136 73 146 222 115 177 234 137 188 237 90 165 215 146 206 249 237 248 254 227 246 255 196 238 255 183 227 239 252 248 156 252 248 157 249 237 89 252 245 155 246 229 100 246 229 103 246 229 105 246 229 106 246 229 109 247 226 106 247 226 107 244 218 79 117 110 75 237 199 47 251 216 77 242 205 78 233 189 42 241 195 47 241 195 48 248 193 35 238 190 46 141 118 66 223 143 15 190 125 16 186 122 17 183 117 20 177 110 24 172 105 28 171 104 28 166 99 31 166 100 31 161 95 35 160 95 35 158 92 37 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A8AO1>?DS<PO3 ?DC<@O7>^_8A? G>@_8A? G>@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

tableLayout
"      Loaded from: /tmp/full/elcl16/tableLayout.gif"

    "
     self tableLayout inspect
     ImageEditor openOnClass:self andSelector:#tableLayout
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class tableLayout'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N  I@0HTA@,UE 0%E1 :N#(7L2L!!@R@-M!!8QKB,(N#(:B@@NC04EFQ,ZGA@]I3(:N"(9NS$.NS$9
NS$9NR(:N#(*H \8NBH8NCH8NCP*N#(:JS$9NQL9NS$9NS$9LC(:N"XFD XRA XFA XFA"X:N#($NS$9D#$9NS$9NS$$N#(:K3D5LQH1LSD1LSD1K3(:N (9
NS$_NS$9NS$9NP(:N#(HB@ HB@ HB@ HB@ HN#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[129 141 164 168 176 192 98 114 143 96 112 140 104 120 148 138 150 171 188 196 211 198 205 218 91 108 137 94 111 139 107 123 150 108 124 150 119 135 160 134 148 170 130 143 165 132 145 166 152 164 183 170 180 196 187 196 211 193 201 214 101 118 144 111 128 153 115 132 157 127 143 166 131 146 168 140 153 173 146 159 178 143 156 175 149 162 181 156 168 185 173 183 198 182 192 207 185 194 208 192 201 214 196 205 218 195 204 217 120 137 160 123 140 163 128 144 166 131 147 169 131 147 168 135 150 171 139 154 174 164 176 192 166 178 194 180 190 204 200 209 221 113 131 154 135 150 169 176 187 200 196 207 220 198 208 220 198 207 218 176 188 201 175 187 200 144 160 176 196 207 218 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C?>O?8??#?>O?8??#?>O?8??#?>O?8@@@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

tag
"      Loaded from: /tmp/full/subversive/tag.gif"

    "
     self tag inspect
     ImageEditor openOnClass:self andSelector:#tag
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class tag'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OA <OC0<OC 8KC08NA0<OBP$OC0<O@@8BC 8MA0 N
C 8@C0<OC0XAC HJCP4M@0 @C0<OC0<OAP8C@ 4M@08@C0<OC0<OC0PAC HCC 8@C0<OC0<OC0<OAP8LC DOC0<OC0<OC0<OC0PAC <OC0<OC0<OC0<OC0<O
AP8OC0<OC0<OC0<OC0<OC0PAC <OC0<OC0<OC0<OC0<OA 8OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[249 211 121 219 179 99 254 218 35 218 195 42 255 251 239 245 202 117 255 244 215 174 162 51 147 107 43 252 237 191 254 223 29 207 149 10 238 195 46 255 232 17 151 107 19 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@ ;&G?8_?@?8C?@G0@\@@0@C @F@@@@A?<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

text_conflicted_ov
"      Loaded from: /tmp/full/ovr16/text_conflicted_ov.gif"

    "
     self text_conflicted_ov inspect
     ImageEditor openOnClass:self andSelector:#text_conflicted_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class text_conflicted_ov'
        ifAbsentPut:[(Depth8Image new) width: 11; height: 10; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
F!!(ZFQDYDQ$ZF!!(ZF!!$RFALXD1$ZF!!(YE@DA@@DAEA$ZFQ\JB (JB (JE1$UE 8MC08ND@8VEQ$BE $IB@$IE HYF!!$FE LC@1XGFQ(ZF!!$EE PVCA$ZF!!(Z
F!!$KFP,YF!!(ZF!!(ZF!!$ZFQ(ZF!!(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[237 98 99 235 111 113 189 41 46 237 86 91 188 24 35 187 24 35 189 32 40 188 32 40 236 71 79 235 76 85 231 78 87 187 19 32 187 24 36 231 60 76 229 48 65 229 49 66 232 73 88 194 87 73 193 79 69 192 80 69 192 70 64 190 51 51 223 63 63 191 61 58 239 130 129 255 255 255 255 255 255]; mask:((ImageMask new) width: 11; height: 10; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'G0@? G?@?>C?8O? _<@? A<@B @b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

treeLayout
"      Loaded from: /tmp/full/elcl16/treeLayout.gif"

    "
     self treeLayout inspect
     ImageEditor openOnClass:self andSelector:#treeLayout
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class treeLayout'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@PDAA0\GA0\GA0\GA0\GA0DD@P\FA XE@0H@A0\GA0\A@PDGA0\G
A0\GA0\GA0\GA0DGA0\GA0\GA0\GA0\GA0\AA0\A@PDGA0\GA0\GA0\G@PDA@PPAA0LB@@\GA0\GA0DGA0DA@P\GA0\GA0\GA0\AA0\GA0\GA0\GA0\GA0\G
@P\G@PDAA0\GA0\GA0\GA0DA@PDD@P\C@ @GA0\GA0\GA0\A@PDGA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[109 130 172 107 128 169 113 135 176 117 140 181 146 164 197 122 145 184 125 149 188 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G@@]?A0@B@@I0@?\B\@H@@''@C=0A0@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

unlock
"      Loaded from: /tmp/full/subversive/unlock.gif"

    "
     self unlock inspect
     ImageEditor openOnClass:self andSelector:#unlock
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class unlock'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRL#H2L#IRT%IRT%IRT%IRL"H"H"H"L%IRT%IRT%IRT#H T#AP #IRT%IRT%IRT%H2L#IRLXH2T%
IRT%IRT%IRT%IRT#CBL%IRT%IRT%IRT%IRT$H2L#@@@@@BP%IRT%IRT$HRDGBQ,MGPHCIBT%IRT%IBDQC (A@Q<DHBP%IRT%IRPKG XT@Q0B@2@$IRT%IRT$
HQLWD DOF"@ IBT%IRT%IBD!!E!!@YEPP HBP%IRT%IRT$IBP$IBP$IBP%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[67 116 45 155 188 141 190 239 169 189 237 168 189 238 168 172 172 172 202 248 182 204 250 185 208 208 208 201 247 181 200 246 180 208 252 189 211 210 211 195 242 175 204 248 184 191 240 171 196 243 177 206 251 186 198 244 178 204 249 184 199 246 179 191 239 170 200 247 180 200 247 181 209 209 209 194 241 173 189 238 169 198 245 178 193 241 172 192 241 172 205 250 185 191 239 171 188 237 167 195 244 174 207 207 207 109 109 109 82 131 61 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C8@_0A?@G\@A0@O>A?<G?0_?A?<G?0O>@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

update
"      Loaded from: /tmp/full/subversive/update.gif"

    "
     self update inspect
     ImageEditor openOnClass:self andSelector:#update
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class update'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
FA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XF@<DAADAC1 XFA XFA XFAPVB1@UE!!LTFA XFA XFA TE!!XPEQXSBA XFA WE1 XDP@V
C H@DPDXFA WCA\XF@<UA!!@UE!!LAFA WB (WE1\WE0\PEQXSDQ WD!!HRD!!HRD!!HWDATVD0DXFA\IBPLCE0LWA1@UE!!LQFA XE04WFA OEPXPEQXSDQ XFA W
E1 XDP@VAPHSE@ XFA XFA XF@<@E TB@APQFA XFA XFA XC1PTE@PTFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XF@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[235 181 26 207 149 10 252 204 69 65 145 59 214 157 24 249 231 172 251 232 158 252 237 191 193 138 7 114 229 127 157 243 167 246 220 131 175 248 183 94 219 99 252 232 179 234 178 36 255 244 215 210 151 15 147 229 150 250 195 38 222 165 23 255 224 139 255 213 97 74 144 69 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@C<@_8A?!!''>N_9??/?>_?89?!!''>@_8@?@@@@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

update_all
"      Loaded from: /tmp/full/elcl16/update_all.gif"

    "
     self update_all inspect
     ImageEditor openOnClass:self andSelector:#update_all
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class update_all'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
ST5MST5MST5MST5MST5MST5MST5MST5MN#(:N#(:N#)MST5MST5MSS\"H"H"H"H:ST5MST5MST47@@LC@0L@N$5MST5MO#9MN10\GBD!!GCIMST5MO"8>SSD 
@ PAAR@3ST5MP28.P$H=P$D6M#XTMD5MO2,+J2,+J2,0JB (DCUMPC$/K2</K2</K2$)JQ<-ST5KOC0<OC0<OC (JB SJ$5MSTT<OD!!FQ$)IKB0,FR]MST5M
Q31DSRX[A0\FCQ,%ST5MST5LSD4$D!! RD!!HRH45MST5MST5MDQ\HB0 HE15MST5MST5MSP<^G!!X^F!!8UST5MST5MST4JBP$LC 0IB @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[247 248 252 187 193 214 186 192 213 191 196 215 187 193 213 186 193 213 166 177 205 166 177 204 160 173 202 137 148 173 136 148 173 160 174 202 137 149 173 166 179 204 136 149 173 139 148 165 239 243 250 130 137 148 227 235 248 234 240 250 242 245 250 143 153 168 222 232 247 225 234 248 227 235 247 231 238 248 222 233 248 229 237 248 245 248 252 146 155 166 222 233 247 236 242 248 243 247 251 245 248 251 248 250 252 151 158 162 117 122 125 155 159 159 108 112 111 160 163 156 162 190 109 148 169 90 165 167 153 252 250 217 242 240 209 170 169 150 254 253 238 251 242 183 251 245 197 148 142 108 186 179 139 183 177 142 179 174 145 176 172 146 247 242 210 182 174 136 251 236 170 251 237 174 189 180 139 167 159 124 251 228 151 187 130 21 189 132 22 183 126 20 179 122 19 187 129 21 186 129 21 186 129 22 169 110 16 172 113 17 171 113 17 168 110 17 172 113 18 171 113 18 171 114 18 175 117 19 166 107 16 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@?0C?@O<F?0;?G?<??7??O?<_?0;?A/<@?0C?@O<b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versions_rep
"      Loaded from: /tmp/full/obj16/versions_rep.gif"

    "
     self versions_rep inspect
     ImageEditor openOnClass:self andSelector:#versions_rep
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class versions_rep'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NC 8N@@@@C 8NC 8NC 8NC 8N@@4MSX@NC 8NC 8NC @@@@)I2L!!APDA@@@8NC 8BCH2L#H2L0@@@CLHNC 8NC CLB<1K0@4MSX@NC 8NC 8AB,@@@@)JBP"
G @@@@@8N@X_BCH2L#H2L#H2L#HHNC IFQ4CKR4.K"8.K"(BNC 8B1HVABT&CP4MCP4MCP4MN@(JC@\[G@4XFA XFA XCS 8NC IEQ\MK@8,C08OK@48NC 8
B1DSCR@NH@87C"@MNC 8N@(JC@4ZC <OC <PCS 8NC 8NC MEAPTEAPTE@48NC 8NC 8CP4MCP4MCP4MNC 8NC 8NC 8NC 8NC 8N@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[146 126 138 211 203 208 199 198 212 114 113 147 103 106 152 157 165 221 86 96 159 86 97 159 63 84 170 68 87 167 40 70 179 51 77 174 169 181 225 102 114 140 11 26 56 108 124 153 218 229 249 136 171 231 141 177 234 207 221 245 208 222 244 142 180 234 209 224 247 210 225 247 246 248 251 148 187 238 218 231 249 152 191 239 213 229 249 212 228 248 98 164 236 216 232 250 232 241 251 99 166 237 104 170 239 106 174 240 109 178 242 162 205 245 218 235 251 113 184 243 115 185 245 118 190 246 221 239 253 219 237 251 244 248 251 171 217 249 221 240 253 222 240 253 172 219 250 222 241 253 177 225 253 224 243 254 252 227 208 252 214 193 251 196 170 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C @_@O?0??A?8G?>_?9??G??_?<O?0??C?<A?0G?@@@b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

vertical
"      Loaded from: /tmp/full/elcl16/vertical.gif"

    "
     self vertical inspect
     ImageEditor openOnClass:self andSelector:#vertical
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class vertical'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!GQ4]GQ4]GQ4]GQ4]GRD!!HQ,KB0,KB0,KB0,KB1,!!HRD\B1LRD1@PDA@PDA@\HRD!!F ,REAHP@0PA@ @PF"D!!HQ$KD1HSDQDJ
DQDQDQ$!!HRDXB0<OCP<OC0<OC0<XHRD!!E0,NC 8NC 8NC 8NE2D!!HQXVE!!XVE!!XVE!!XVE!!X!!HRDUB0,KB0,KB0,KB0,UHRD!!C@,PDA@PDA@PDA@PCBD!!HP$K
HB@_DA@PDA@PD@$!!HRDHB2@^G1DCA@DB@ADHHRD!!A0,_G1<OC0<OC0<OA2D!!HPXKC 8NC 8NC 8NC X!!HRDEAPTEAPTEAPTEAPTEHP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[180 187 209 137 152 187 159 171 199 103 125 169 116 136 176 134 148 174 136 149 172 140 151 170 143 154 168 148 156 165 239 250 255 213 243 255 152 159 162 245 252 255 248 253 255 244 252 255 235 250 255 239 251 255 55 152 96 168 206 183 124 184 125 158 162 158 162 165 155 168 168 151 173 171 148 177 174 145 181 176 142 189 181 137 185 178 140 191 182 136 238 158 147 224 107 94 235 145 134 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@??#?>O?8??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

warn
"      Loaded from: /tmp/full/obj16/warn.gif"

    "
     self warn inspect
     ImageEditor openOnClass:self andSelector:#warn
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SVN::IconLibrary class warn'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
%IRT%IRT%IRT%IRT%IQ,%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRTU%XK%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%@5KJ")]^9RT%IRT%IRT
%IRT%IRT%IRT%IRT%IRT%IQ#A$-\J"(2XYRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%@XFU!!)VJ JM%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IQ#L@6NR(9KJ&8 
%IRT%IRT%IRT%IRT%IRT%IRT%IRT%@XFR5YV#$,*]!!FT%IRT%IRT%IRT%IRT%IRT%IRT%IP&N"5VJ")V#$,*[''BT%IRT%IRT%IRT%IRT%IRT%IRT%C@FR5YK
JEZNR2*A^YRT%IRT%IRT%IRT%IRT%IRT%IQ5C25VB @@@FAVVD-<PYRT%IRT%IRT%IRT%IRT%IRT%C@:VEX@@D<YQX9XR8FM%IRT%IRT%IRT%IRT%IRT%IQ5
C3AVJ ACK4A>#%YXVG2C%IRT%IRT%IRT%IRT%IRT%H0OG%X*L8</PA\*#%!!K]GJT%IRT%IRT%IRT%IRT%IQ5NCBPU")^Z2\/MB*N#!!9X!! ^T%IRT%IRT%IRT
%IRT%@<OG)AXJ$$YD T8R9BNG% %\)RT%IRT%IRT%IRT%IQ5NA.K$A8*^(="V$-XG(:P$9NFQ)RT%IRT%IRT%IRT%E,8F9ARG% ^Y3Y=R18^$H:SV@D<%IRT
%IRT%IRT%IRGNC!!R"18^G"(C"QYKG!!8^#!!:SG$0.%IRT%IRT%IRT%FT8LH,^$18^J%QGS$,^$9MV$F4^QC2T%IRT%IRT%IRGNG>S"9NS$9MXM0 LVINS$1:N
$9L[SA>T%IRT%IRT%E,8_8,^$9NS$19-SYL^$9NS$5ZP[Q8A$YRT%IRT%IRGN@2S"9NS$9NS$19)G)NS$9M-$51R[YMLG9RT%IRT%C 8JX,^[V5-$9MXVD,^
G)M-$65-$H9-$8 <%IRT%IRGU02ST&5-[V5-G$9C@F]-$65-[V6S#)M-JT0.%IRT%E-WCEJS[V5-[V4^D0ACFV)X[V5-[V5RFB$^IEBT%IP#U5]7T&5-[V5-
[YL@P1BD!!U!!-[V5-[YLX[W\LJ9JT%E<,U65-[V5-[V5-G#UCUXBBG&5-[V5-[YM-JV5QBYRTHR1WCB$)JR$)JR%7[P89O&4)JR$)JR$)JP0L[WLQOYPD"((,
KB0,KB0,KB1WJW\LKB0,KB0,KB0,U017GVX.%IQ1"!!TUEQTUEQTUEQTUEQTUEQTUEQTUEQVJKFPQH)JT%IQ(LXZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!!!2FDRIH
%IRT%IRTG1>R$)JR$)JR$)JR$)JR$)JR$)JR$)JRZIRT%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 4 146 132 47 198 197 21 88 68 30 233 206 104 61 39 79 233 230 0 127 130 175 7 0 75 59 65 136 167 166 17 246 246 62 239 197 0 242 240 0 131 105 33 231 214 0 49 26 97 10 17 115 55 33 104 36 25 17 166 167 182 205 164 0 170 145 22 109 85 34 255 240 27 0 0 45 255 255 104 241 214 0 53 50 93 80 71 81 254 230 0 149 149 184 99 101 158 230 197 41 27 30 105 229 219 176 132 116 54 159 148 41 235 231 100 30 8 74 195 184 2 245 201 0 255 254 0 21 25 110 223 179 0 241 232 0 139 140 174 23 0 67 240 221 0 59 56 108 81 83 79 16 10 6 165 142 19 77 58 24 105 91 186 199 169 9 230 203 0 119 97 86 232 223 0 17 18 123 37 43 133 187 186 204 179 151 61 255 248 24 0 0 66 111 113 167 233 223 126 0 0 18 150 137 45 92 77 46 134 136 175 0 0 106 83 84 135 180 163 1 255 255 49 253 247 0 41 42 99 29 16 67 206 174 6 10 0 48 46 50 135 88 78 78 255 229 16 153 153 181 140 123 29 23 5 99 254 254 18 230 188 0 254 239 0 255 222 0 68 49 78 234 206 25 255 255 41 202 202 35 90 78 12 235 209 96 227 226 35 130 130 178 80 64 146 236 234 89 129 107 54 236 211 15 17 23 111 39 24 34 165 164 189 191 159 18 121 93 33 0 0 48 234 233 161 254 214 0 73 73 84 254 230 8 104 106 167 228 194 61 27 29 134 140 118 51 165 155 38 234 227 110 191 186 24 253 207 1 255 255 9 20 24 127 208 188 0 144 143 185 64 63 88 100 80 50 80 60 43 239 207 0 190 178 255 179 171 30 184 157 79 118 120 174 30 11 111 125 98 93 49 47 95 233 220 140 158 137 41 0 0 124 215 174 0 255 238 16 234 216 12 18 20 128 255 254 33 0 0 28 255 246 15 47 53 137 154 154 186 254 222 8 255 255 255]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@H@@@@G@@@@C<@@@A? @@@_8@@@O?@@@C?0@@A?>@@@_? @@O?<@@C??@@A??8@@_?>@@O??0@C??<@A??? @_??8@O???@C???0A???>@_??? O???<C??
??A????8_???>O????3????<?????/????9????>O????@???? b') ; yourself); yourself]

    "Modified: / 11-04-2008 / 11:32:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!IconLibrary class methodsFor:'image specs - versions'!

versionA12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionA12x12 inspect
     ImageEditor openOnClass:self andSelector:#versionA12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionA12x12'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<+KR8/LCD2L3<?O3<?J"T%IRX''JB0?O3<?O18 HRD!!H2P)O3<?O3<RE1\[F14_H#<?O3<?A@LLD1DQE!!0?O3<?
O0HPCP(FB@TNO3<?O3<GF!!$XEQPMBS<?O3<?@@<NC ,KB0D?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O0@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[118 148 84 116 158 86 107 162 80 106 167 47 110 163 75 107 168 48 106 169 57 115 166 71 109 170 51 104 171 73 109 172 60 111 170 74 112 173 54 107 176 55 115 173 77 124 173 71 114 177 65 124 176 50 127 172 85 123 176 58 111 180 59 113 182 61 127 179 53 129 181 55 125 185 58 127 186 59 129 187 51 135 186 52 134 184 81 136 187 53 141 183 81 138 188 54 145 187 46 148 190 49 150 189 73 158 193 53 154 195 54 162 195 47 165 198 50 169 202 54 171 204 56 171 202 80 168 203 102 191 213 121 193 221 91 201 229 99 203 231 101 208 231 109 215 239 123 217 242 134 226 244 137 235 253 145 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@O<@?0C?@O<@?0C?@O<@?0@@@@@@@@@b') ; yourself); yourself]
!

versionA16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionA16x16 inspect
     ImageEditor openOnClass:self andSelector:#versionA16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionA16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
DLQ;_W7F1<#R4-_T5]WZG2[%9._&:>/,;^;/<OG2<<T 7;Z:/K6<0LGA8NK#9N)9F-6(+*:1-[V5*;V>/;?"^A''P^*J#+[B0*KF7-;F+02 X2(2R%9^ ^*N%
(:Z0+]0''E<&H H*J")JU%)ZU)9^''IQY-SFQ$"H"@ XFJ$)JR''"PRM$A@QU]XT5NB (RD Y0#B3\,LR9@QDQERT%WVE!!1H 1-TC$9LSD1K#8.QDUE[BDN[51[
VT=OO#T>K"8.KC8^CGY&YV!!"W%1[T%APTC)+GAON+I*X&I.[Z&%)W%9^\A4U6M;O3,;L3G]7]''I3]WT[@ADOBP$IBP$EAPTB@ ,V@P@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[30 49 18 35 64 22 53 108 28 58 107 28 59 107 28 57 108 28 59 108 29 59 109 29 59 110 30 60 109 29 61 110 30 60 106 33 63 106 37 62 106 38 59 103 43 67 108 28 70 87 32 70 101 35 64 106 35 69 106 34 68 106 35 70 100 40 68 108 41 77 112 43 82 115 39 86 118 39 94 121 45 75 117 54 71 126 50 72 123 50 74 126 50 103 117 41 98 124 43 80 129 54 87 133 53 98 132 47 106 136 45 111 140 47 109 131 49 119 146 52 124 150 50 111 167 50 106 171 49 108 170 50 108 170 51 109 171 51 107 169 52 105 171 53 106 170 52 106 169 54 108 170 52 111 171 53 108 172 53 111 173 55 107 162 63 107 167 62 108 170 57 105 173 56 107 175 56 107 175 57 109 174 57 109 175 57 109 173 58 108 170 60 112 171 53 114 170 52 112 172 53 115 173 52 114 172 54 117 173 52 116 172 53 118 173 53 117 173 54 120 174 53 120 174 54 121 175 54 121 174 56 108 176 54 108 176 55 107 177 56 108 177 56 109 178 57 111 179 59 125 177 50 124 176 51 126 178 51 123 176 53 124 176 54 124 177 54 112 177 58 113 179 58 113 179 59 118 179 58 117 180 57 118 181 56 116 181 58 119 182 58 117 178 62 117 183 60 126 179 56 125 178 58 123 185 57 127 186 57 121 184 60 121 184 61 122 185 60 125 185 61 108 172 64 116 174 67 115 168 69 113 172 69 118 174 76 113 176 70 125 179 65 123 183 70 123 183 71 124 184 71 125 182 74 125 183 74 124 184 72 131 155 47 138 159 53 146 189 44 146 165 61 144 168 60 146 169 61 130 182 48 131 182 50 131 182 51 132 183 49 129 178 52 131 178 53 132 179 53 131 180 52 129 181 54 131 182 54 131 183 54 134 184 51 133 184 53 134 185 54 139 187 48 136 186 50 142 187 50 136 185 53 138 185 52 136 186 53 139 187 52 138 187 53 141 187 53 142 187 54 140 188 52 143 188 52 130 188 56 131 189 56 133 190 56 128 187 61 135 184 63 129 188 60 141 188 60 146 188 48 145 188 51 144 189 51 147 189 50 148 190 49 150 190 50 151 191 50 151 191 51 145 189 56 154 192 45 152 193 46 158 196 44 159 197 47 137 193 55 150 192 50 154 192 49 152 193 50 152 193 51 157 194 48 156 194 49 158 196 48 159 197 48 159 197 49 166 198 43 160 195 49 160 198 48 167 199 51 169 199 49 170 198 51 170 199 53 171 199 53 163 200 48 165 200 50 174 203 57 175 203 58 175 203 59 168 202 63 141 159 72 149 167 68 147 172 66 149 174 71 152 173 75 129 179 70 138 184 65 130 187 75 131 187 75 131 188 74 134 190 73 137 187 72 146 188 65 149 191 64 154 174 81 154 175 81 154 175 89 158 174 89 128 181 87 156 176 87 144 186 87 160 175 91 163 176 89 139 193 75 158 196 67 157 193 69 145 196 77 168 201 69 177 204 64 177 207 68 183 208 69 186 211 72 190 214 79 190 218 95 193 221 77 194 221 80 195 221 81 196 223 86 194 218 92 197 224 89 201 226 93 205 227 99 206 229 104 207 230 110 210 233 115 215 236 118 220 239 126 226 243 131]; yourself]
!

versionA24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionA24x24 inspect
     ImageEditor openOnClass:self andSelector:#versionA24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionA24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@",2L3T8MCP:O#(<OC0<O349M3,7M#XEG.[4;/G1<_O6=/W7>_''9>?/;?O3=??80G>O$9>#(:N#):^''/;^;0<OK5=?_8>O(0FMSH2</M3\7Q3]GW5=_W6-3!!
8.K+9^0/G]''J,<C@0LCH0LCS2L#H2MOU6MWW7.(1GKB1.*65.LGA0\GA0\GA0\GN2\CH4>@.F:2/)Z6-+Z65.K.8.++@0LC@0LB=4=4-F96#(JJ#+Z6-+Z6-
+Z6;.;.;.;::1=X,FX.Z(I2\''I2#(:J"+Z6-+Z6-+Z6-.]@,FXVF&X&I&Y&Y&ZF!!(:N"(*N#+:>-+<H*E7A(!!(RD!!HRO&Y&Y&Y&Y&Y2\(:F );P)E%YJXGE9
^W6D!!HR@"X&I"Y&Y$)&Y&[P''D4%AQ6A Y6=/]&=/]''ZC 8NC 8&I%JP&E$%AT4!!HT6E*\WE/[6=/[6=6]''6@!!I,$EDI]S5=PT5MSU5]\XVA''Y6]''Z&==Z'',(
E$%-YE=_UT9KR4!!HSEATU6E!!Y6)*ZG,%DDY4X65.X6Q_W55]T5APT5MSSD1SUFX"B4VH[F13YV9$YFQ$YVE#W5]ST5MSSE("C5J*%YFN!!8I<\61,[&9.[&Q$
YFQ$WVH#D5F2$I^X%YVQ$YFQ[G13\7M.[&Q2WU("DU/C*9:^%9^W&IVX&I"U$YE:^''),^E$!!EWW_6=KR3LR</K2<)*Z&)*Z&)*Z*-8D @4BJZ6-;W&Y&W&Y^
W%9^W%9^W%9Q_$PZ@@PFCP(IC@8NC@8LC@0LC@$IBP$LCP A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 10 4 0 21 0 16 31 1 26 46 7 30 55 9 45 56 0 33 62 1 24 66 0 34 64 12 18 70 0 25 68 0 26 66 19 26 69 0 33 68 0 28 71 1 31 69 15 29 69 22 39 68 8 29 72 1 34 70 9 29 72 10 39 69 16 36 72 11 36 73 20 51 72 6 46 74 15 42 74 27 50 77 10 54 76 18 57 78 12 64 79 15 63 83 10 51 88 34 47 90 28 54 97 35 48 99 35 64 98 30 58 101 38 73 99 25 77 102 29 66 107 37 81 105 25 85 109 29 88 109 44 90 114 34 94 117 29 96 118 21 102 118 23 102 119 32 100 122 26 111 123 45 108 125 38 108 129 34 112 128 34 116 127 49 116 129 57 111 133 38 113 132 59 112 135 47 119 132 60 116 134 54 116 135 62 114 137 49 118 136 56 118 148 84 103 159 57 102 161 65 103 165 45 116 158 86 112 160 79 107 162 80 111 165 47 106 167 47 110 163 75 108 165 62 105 167 56 107 168 48 108 169 49 101 171 50 104 171 42 106 169 57 115 166 71 113 166 77 109 170 51 107 170 58 101 172 59 117 165 84 110 171 52 110 169 72 108 169 79 104 171 73 122 166 72 111 172 53 109 172 60 111 170 74 105 174 53 118 171 53 112 173 54 106 173 75 111 174 62 107 176 55 114 175 56 115 173 77 120 174 56 119 174 64 108 178 57 122 175 57 124 173 71 116 177 58 114 177 65 110 179 58 124 176 50 127 172 85 123 176 58 112 180 51 111 180 59 120 176 73 133 171 85 125 177 51 118 179 59 116 179 67 124 178 60 121 180 53 119 178 81 113 182 61 127 179 53 130 175 87 133 178 53 129 180 45 122 178 95 115 184 63 135 179 55 129 181 55 134 177 83 128 181 63 122 183 63 124 181 77 131 182 47 138 176 90 136 178 77 124 184 56 132 183 48 119 186 57 131 183 57 127 185 49 125 185 58 139 182 50 133 184 49 132 184 58 127 186 59 134 185 50 129 187 51 128 187 60 135 186 52 134 186 60 134 184 81 136 187 53 141 183 81 131 189 53 142 186 53 139 188 45 138 188 54 145 187 46 144 187 55 144 185 76 148 189 37 130 191 71 140 190 56 147 189 47 146 189 56 129 192 79 137 193 49 145 187 85 148 190 49 131 193 73 147 190 58 151 186 86 153 189 58 138 192 73 156 190 40 150 189 73 151 192 51 140 194 75 137 194 89 153 194 53 151 194 62 154 195 44 158 193 53 142 196 77 157 196 35 154 195 54 161 194 45 162 195 47 156 197 47 156 194 79 146 198 72 141 200 73 164 197 49 158 199 49 157 199 58 165 198 50 160 200 50 164 198 59 167 199 41 149 201 75 171 197 51 161 201 41 166 200 52 166 197 83 173 199 53 152 204 78 169 202 54 167 201 93 171 204 56 171 202 80 177 203 58 172 205 57 168 203 102 177 205 68 158 210 83 184 204 69 176 206 84 181 208 71 165 211 93 181 209 80 188 209 73 191 211 76 181 214 105 189 216 78 193 215 95 191 213 121 189 220 65 193 219 73 194 221 84 193 221 91 199 220 92 198 221 100 202 222 86 203 224 96 199 226 88 205 226 98 201 229 99 205 228 106 203 231 101 206 230 115 208 231 109 206 234 104 212 235 113 221 237 124 215 239 123 220 242 120 217 242 134 226 244 137 226 247 146 235 253 145 241 254 154]; yourself]
!

versionAB12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionAB12x12 inspect
     ImageEditor openOnClass:self andSelector:#versionAB12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionAB12x12'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=FS%AQUEUVV''=?_7=?O",+J284NT!!?_7=?_1<"H2L#JB$<_7=?_7<SFA \GA8 IE]XVU-RA@LMEAHRE15LST=O
T0HQC (FB@TOQ4%IR$,GF1(YE!!TNBTEBP4ME@A@OC0,KB0D;OS4?NG=?_7=?L3D*IRX&I21?_7=?_4@:N#X1LR4!!_7=?_7=DMS\2L"<0C@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[118 148 84 116 158 86 107 162 80 106 167 47 110 163 75 107 168 48 106 169 57 115 166 71 109 170 51 104 171 73 109 172 60 111 170 74 184 149 76 112 173 54 107 176 55 115 173 77 124 173 71 114 177 65 124 176 50 127 172 85 123 176 58 111 180 59 113 182 61 127 179 53 129 181 55 125 185 58 127 186 59 129 187 51 135 186 52 134 184 81 136 187 53 141 183 81 138 188 54 214 165 59 145 187 46 148 190 49 150 189 73 234 173 0 235 174 0 231 176 0 158 193 53 154 195 54 238 177 1 162 195 47 224 175 69 240 179 7 165 198 50 236 178 58 233 180 49 243 181 13 234 181 50 242 181 31 169 202 54 232 185 42 242 186 19 232 186 53 226 187 61 171 204 56 245 188 0 233 190 16 171 202 80 236 192 0 168 203 102 237 193 0 243 193 28 237 199 6 240 201 0 244 204 0 240 196 94 231 202 64 191 213 121 244 210 3 193 221 91 250 215 0 247 218 0 239 214 66 245 222 0 241 225 0 201 229 99 245 228 5 203 231 101 208 231 109 233 227 112 247 234 74 215 239 123 217 242 134 226 244 137 255 248 86 255 249 95 255 251 104 235 253 145 253 255 115 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@O<@?0C?@O?8??#?>O?8?? G>@_8A? b') ; yourself); yourself]
!

versionABBase12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionABBase12x12 inspect
     ImageEditor openOnClass:self andSelector:#versionABBase12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionABBase12x12'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
_7=?_4!!QU51]YF!!@_7=?_7<+H"T''KCQPN''=^Y6)+[&=0]A\_H!!!!?T30<OC=FSF@EA 4C_281L#H2NC%O@PDB@G<\H2L)JR4/L7E2\7U,B $TGQ,[HR)%Y&%)
[P ZEQDLC0,VW6E!!X&LNJBX$HA8UDEYXVU%[AA$VE!!HRD ]NT%ITR7=?_7=?QTL;MSX6M35?_7=?_5UMST%CP380_7=?_7=ZQ4)DQDEBD0@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[45 133 171 11 149 204 25 153 208 65 148 187 118 148 84 42 161 216 46 163 218 116 158 86 107 162 80 106 167 47 110 163 75 107 168 48 106 169 57 55 168 224 115 166 71 109 170 51 104 171 73 109 172 60 111 170 74 184 149 76 112 173 54 107 176 55 115 173 77 61 175 225 96 168 202 124 173 71 114 177 65 124 176 50 127 172 85 123 176 58 111 180 59 65 178 228 113 182 61 127 179 53 80 177 228 129 181 55 125 185 58 92 179 225 127 186 59 93 180 226 129 187 51 135 186 52 134 184 81 75 186 235 95 181 227 136 187 53 141 183 81 138 188 54 214 165 59 145 187 46 148 190 49 150 189 73 102 188 234 234 173 0 235 174 0 231 176 0 158 193 53 154 195 54 116 191 219 238 177 1 162 195 47 224 175 69 240 179 7 165 198 50 149 189 203 236 178 58 233 180 49 243 181 13 234 181 50 242 181 31 169 202 54 232 185 42 137 196 220 242 186 19 232 186 53 226 187 61 171 204 56 245 188 0 233 190 16 171 202 80 114 203 242 126 201 229 236 192 0 168 203 102 237 193 0 243 193 28 237 199 6 133 208 236 240 201 0 244 204 0 240 196 94 231 202 64 146 211 240 148 213 243 191 213 121 244 210 3 193 221 91 250 215 0 247 218 0 239 214 66 161 220 245 245 222 0 241 225 0 201 229 99 170 224 243 245 228 5 203 231 101 208 231 109 233 227 112 247 234 74 215 239 123 217 242 134 226 244 137 255 248 86 255 249 95 255 251 104 235 253 145 253 255 115 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C?@O<O?0??C?<O?8??#?>O?8?? G>@_8A? b') ; yourself); yourself]
!

versionABase12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionABase12x12 inspect
     ImageEditor openOnClass:self andSelector:#versionABase12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionABase12x12'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
_7=?_4UIR41MTEIC_7=?_7<5KB<1M#5HPG=NTUMTUUYWVBD)KBI?R$EAPTIDQ$<PDQ N_3 :N3,;O#=GB (MBG<&KR43L3\9O@LEBPE?EQP^I2T%J3PGA P@
_1L$G10WF!!X C@0K@''<YL#@.J" _F7=?_7=?C2L HA4]GQI?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_7=?_0@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[16 117 155 0 123 166 48 114 148 9 133 194 0 137 204 17 135 197 0 141 202 0 143 204 45 133 171 29 139 201 11 149 204 33 143 199 39 146 202 25 153 208 65 148 187 118 148 84 42 161 216 46 163 218 116 158 86 107 162 80 106 167 47 110 163 75 107 168 48 106 169 57 55 168 224 115 166 71 109 170 51 104 171 73 109 172 60 111 170 74 112 173 54 107 176 55 115 173 77 61 175 225 96 168 202 124 173 71 114 177 65 124 176 50 127 172 85 123 176 58 111 180 59 65 178 228 113 182 61 127 179 53 80 177 228 129 181 55 125 185 58 92 179 225 127 186 59 93 180 226 129 187 51 135 186 52 134 184 81 75 186 235 95 181 227 136 187 53 141 183 81 138 188 54 145 187 46 148 190 49 150 189 73 102 188 234 158 193 53 154 195 54 116 191 219 162 195 47 165 198 50 149 189 203 169 202 54 137 196 220 171 204 56 171 202 80 114 203 242 126 201 229 168 203 102 133 208 236 146 211 240 148 213 243 191 213 121 193 221 91 161 220 245 201 229 99 170 224 243 203 231 101 208 231 109 215 239 123 217 242 134 226 244 137 235 253 145 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C?@O<O?0??C?<O?0??C?<O<@?0@@@@@@@@@b') ; yourself); yourself]
!

versionB12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionB12x12 inspect
     ImageEditor openOnClass:self andSelector:#versionB12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionB12x12'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O20+KR0.K3@)O3<?O3<&H2T%I2 (
J#<?O3<?HQ0_HBH"H2P?O3<?O1\VFQ([GA0^O3<?O3<G@ $TEQTVD#<?O3<?C 0E@ LCA@X?O3<?O1 SD1@LC@ AO3<?O3<]C1DMCP(K@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[184 149 76 214 165 59 234 173 0 235 174 0 231 176 0 238 177 1 224 175 69 240 174 37 240 179 7 232 184 6 236 178 58 233 180 49 243 181 13 234 181 50 242 181 31 232 185 42 242 186 19 232 186 53 226 187 61 245 188 0 233 190 16 236 192 0 237 193 0 248 191 29 243 193 28 242 197 9 237 199 6 240 201 0 244 204 0 240 196 94 231 202 64 246 206 0 244 210 3 249 210 32 250 215 0 247 218 0 239 214 66 245 222 0 246 223 0 241 225 0 245 228 5 233 227 112 247 234 74 255 245 52 255 248 86 254 251 69 255 249 95 255 251 104 253 255 115 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@_8A? G>@_8A? G>@_8A? b') ; yourself); yourself]
!

versionB16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionB16x16 inspect
     ImageEditor openOnClass:self andSelector:#versionB16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionB16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GRP H"L%]GU6;N;.:^/*@]#$8^K#9^_(<OG2</S6=Q0-4\KM3\/Q4=SU5]_ 9.<\KLV5.++B.++B0,KB3<?UF2:7(:N2-[V8.LR81LSB2!!$/*).['':N!!([J/
+;J5-\$XJ:&O#)R[&9:#&9>_(ZGHCB).SIFV$X*L"8:'')9"[6  )\C]FQ49KR8VE!!XVT%-$II7@6LS9DQD9NT$-LSH):BRY1MS(8NC 7OC0<P5EN^0\(\&Y"
W$Y^W$A@MSD1LW\FJLY[ZF](X&I"W59UT5M8AQ?F%5ZW%6)*Y5%YY''I"^PL!!7-7G1<]=_W6C XFA_HPD@!!\MCQTQDQDQEQTUEP<K@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[64 38 12 86 84 25 102 69 21 120 84 22 113 81 27 127 87 25 126 89 26 127 93 27 127 97 27 129 97 24 128 100 24 140 102 31 129 106 25 151 107 17 150 107 19 151 106 22 153 104 19 153 104 20 153 105 20 152 106 21 153 104 22 152 104 23 153 104 23 150 108 28 134 114 25 135 117 24 135 126 31 136 124 25 131 125 41 137 131 31 191 150 12 189 151 23 188 183 31 181 147 49 189 184 35 191 185 39 189 182 42 191 185 42 194 141 30 195 141 31 193 146 18 198 145 22 199 151 21 203 159 23 205 181 12 205 189 9 205 174 16 204 169 23 233 174 1 234 175 0 235 174 1 234 174 3 236 174 1 236 175 1 233 173 4 233 175 4 234 173 11 234 174 10 235 174 11 236 175 10 233 176 1 234 177 0 233 176 3 234 177 2 238 176 2 233 177 5 237 176 5 234 180 4 234 180 6 235 182 6 236 183 7 237 187 3 234 191 2 235 190 3 237 188 1 236 191 1 239 189 2 233 185 6 235 187 6 236 185 4 235 189 4 233 183 11 236 188 9 240 176 4 241 176 4 240 178 6 247 190 2 247 190 3 247 191 3 246 184 7 247 184 7 244 187 6 240 178 8 241 179 9 242 180 10 242 180 11 242 180 12 242 181 12 242 181 13 243 182 12 243 183 14 243 183 15 245 183 13 247 187 9 244 184 10 245 185 11 245 189 9 246 189 11 243 186 12 242 184 15 241 186 15 235 175 21 236 174 25 239 177 23 243 183 21 244 190 18 192 186 48 193 186 55 193 187 60 228 175 33 229 174 34 229 180 39 234 189 35 233 184 39 239 188 38 245 188 35 244 189 35 245 189 35 244 186 36 244 187 38 243 188 38 244 188 36 227 184 63 233 193 0 234 194 0 234 194 1 235 194 2 236 192 1 236 195 0 235 197 0 234 196 3 237 199 2 239 198 2 239 198 7 240 192 2 240 192 3 240 195 3 241 195 3 240 199 1 240 196 3 242 194 6 247 193 6 243 200 1 241 202 1 242 203 0 243 203 0 243 202 1 242 203 1 241 203 3 243 204 0 243 205 1 242 207 0 244 204 0 244 205 0 245 206 0 244 207 0 240 200 4 240 200 5 243 200 4 243 198 13 243 204 12 242 208 1 243 208 1 243 209 1 244 211 1 246 210 0 246 211 0 246 210 1 244 209 2 247 213 0 246 212 1 247 215 0 247 214 1 245 209 7 248 213 1 244 217 0 245 217 0 247 216 0 246 218 0 246 219 0 247 219 0 245 220 0 246 221 0 245 222 0 246 223 3 249 216 0 248 217 0 246 215 9 245 196 21 246 192 31 240 208 30 242 214 30 244 221 25 243 225 2 243 225 3 245 225 3 246 224 2 246 225 3 244 226 5 245 225 7 247 227 6 246 227 7 246 229 16 246 230 27 245 229 31 248 231 29 204 194 42 237 195 38 239 203 37 246 195 32 246 195 33 247 199 35 247 202 59 249 233 33 250 235 45 253 242 37 253 242 41 253 244 43 253 243 47 252 244 47 252 238 54 252 244 55 254 245 61 186 188 69 178 178 77 187 189 75 193 187 66 192 187 68 193 187 68 251 237 68 255 246 71 255 247 81 255 248 85 255 248 88 254 250 100 252 246 110 255 251 107]; yourself]
!

versionB24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionB24x24 inspect
     ImageEditor openOnClass:self andSelector:#versionB24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionB24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GB$/KB00K2</MC 8NCX6M#X6LSL5L!!<BN?S0;.;0=_W8>OS4>_'';>?/;?/;<?=<QPN_(:N#(:N#*9>/.<OC3<?O4<//6>>0SO=7U5MSU5]WU5]/[7^C 8.K%
9N''-:^LSO-SG2,3R3=KR4-KR4-WU5M/[7-/^8.XWOM":2\#H2L#J2,+J3MKS4-KT5MS\5^DTN,J5-KR8.++I2\''I2\#I2L+L4=SR5MDRN\Z+*:.++;R8.K*:
.,''I2\''I.,3H4L4RM;.])ZV+*:.+,KB0-["8.KR:,L#I1<DRK*2](*J%)ZV+*:.+*:.+*:./*;*8.+XOJ9^V%(*J")2!!)Y6")ZV%*:.%)Z.%/J8IJ''][\8JR
%)2E!!X"H"H>]''Y2"(ZF\,ZPIJE9JS%-; '')1\XVE"H"H"H"H''JFJ)(8GI5YGQ4YMS&A;^(E1!!XVE!!XVE!!X*M%W4KHU1JQ$YIRT9ST5- Y''I;\7NE!!XVM^7XM
HVQJRT%JR$)JR$)MST9ST5M&\&5:_&$IH6!!#X6MZUEQIRTYFRT%IRT%ISD5SVUTHIHY#X6M#X6M#X6M#UEQIRT%FRT%ISDPHI)&G G!!8[6=#X6M#X6M#X5)T
T$-KR$PLH)&R HB@ HB@^G!!8Z6M#X6M#X5)#YTDEHJ"V%(.@"8.@ H.K"W%.[&9/X6-+_$HDI\CK1K&3,;N)(9*Z&)*W%9FW&)^Y''$LDG*6L 7A<_G1''X&]''
Y6]*Z&E*]FIP,#4C@QTYFQ$[F!!(ZF!!(ZF!!(ZF!!(ZE!!4YF08@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[16 1 1 42 14 1 27 26 0 53 26 0 61 33 0 66 33 3 61 38 0 66 37 0 67 38 0 64 40 0 65 41 0 68 42 0 75 40 0 67 43 3 78 42 0 66 46 0 70 53 0 58 57 0 71 55 0 64 58 0 69 57 0 92 53 0 97 53 1 69 62 0 97 57 0 99 58 0 103 57 0 100 59 0 73 70 2 108 62 3 122 94 29 118 117 35 156 120 13 164 117 27 154 124 0 162 121 17 164 122 3 152 123 35 161 124 3 171 123 23 174 125 13 140 134 30 170 127 12 174 131 19 146 144 16 151 143 18 175 136 24 152 144 20 148 146 20 145 145 39 143 145 55 142 148 41 155 146 23 147 148 50 154 147 44 177 143 17 155 148 35 176 148 22 179 150 8 164 156 44 179 155 15 184 149 76 178 160 0 180 168 13 179 167 27 214 165 59 211 168 52 212 170 69 218 169 63 230 171 12 234 173 0 232 172 16 229 175 0 235 174 0 233 173 19 240 173 0 228 175 16 231 176 0 232 177 0 236 176 0 221 176 52 235 175 22 242 175 3 233 178 0 238 177 1 224 175 69 240 174 37 239 178 4 234 180 2 233 179 23 240 179 7 236 181 5 242 176 40 241 180 10 239 179 28 237 182 9 232 184 6 236 178 58 233 180 49 243 181 13 244 178 43 236 182 29 234 185 9 234 181 50 242 181 31 227 182 66 233 181 59 240 184 15 235 182 51 235 186 12 247 184 0 245 183 18 232 185 42 233 189 0 236 187 15 238 188 0 235 183 61 243 187 0 224 186 68 240 185 33 242 186 19 249 186 0 239 189 0 237 188 18 232 186 53 226 187 61 236 187 33 234 191 0 245 188 0 233 190 16 240 190 0 235 187 45 246 189 0 236 192 0 242 187 36 244 188 23 232 194 0 251 188 4 237 193 0 247 190 3 234 188 64 243 192 1 230 190 64 233 196 0 248 191 6 251 188 28 244 193 4 239 195 2 235 197 0 237 194 25 245 194 8 248 191 29 240 196 6 243 193 28 249 192 31 246 195 11 242 197 9 237 199 6 242 193 52 243 198 0 239 200 0 245 199 0 238 200 11 251 194 34 232 197 61 240 201 0 242 198 32 241 202 0 242 198 45 255 197 21 243 203 0 244 204 0 247 201 21 240 196 94 231 202 64 245 205 0 240 207 0 243 204 22 238 199 88 253 201 25 246 206 0 241 208 0 233 204 66 247 207 1 243 209 0 255 203 28 244 210 3 247 207 28 242 209 27 246 211 0 245 211 7 247 212 0 247 205 71 234 210 61 246 212 10 248 213 0 254 208 33 243 215 0 249 210 32 243 215 12 245 216 0 250 215 0 246 217 0 255 210 49 247 218 0 239 214 66 242 220 0 243 221 0 246 218 21 237 218 58 245 222 0 250 221 0 246 223 0 241 225 0 242 226 0 247 225 0 250 222 28 243 227 1 248 226 4 245 228 5 250 227 8 246 229 10 248 232 17 233 227 112 247 231 36 243 230 59 249 233 39 243 231 79 249 234 53 251 235 41 247 234 74 251 241 48 253 242 34 254 239 70 254 243 37 253 243 50 248 239 110 255 242 73 255 245 52 255 247 55 255 246 66 255 248 68 253 247 93 255 248 78 255 248 86 254 251 69 253 248 102 255 249 87 252 251 78 255 249 95 255 251 97 255 251 104 253 251 119 255 252 106 253 255 115 255 254 130]; yourself]
!

versionBBase12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionBBase12x12 inspect
     ImageEditor openOnClass:self andSelector:#versionBBase12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionBBase12x12'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
_7=?_3@7O$MER4<)_7=?_7<\FQ([GQ<6H7=?_7=?D!!DSEQXXFQ]?_7=?_0TJC@4NC1HK_7=?_7<@@PXGB@ IAG=?_7=?@%QSUUQVU5!!Q_7=?_0MMRT1LS%AP
T''=?_7<PQ4ADQ$!!HRT)?_7=?_3(9OC4?PDAB_7=?_7<&HB 5NC 9L7=?_7=?K"0$HBD!!H"U?_7=?_3,4MCD,KB\^_7=?_7=AK3H-KR(+E@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 126 187 4 132 193 17 135 197 0 143 204 45 133 171 0 146 201 7 146 208 13 147 209 11 149 204 25 153 208 31 155 211 65 148 187 33 156 212 38 159 214 42 161 216 46 163 218 83 160 206 51 169 218 55 168 224 67 167 217 184 149 76 58 173 223 61 175 225 96 168 202 65 178 228 80 177 228 92 179 225 93 180 226 75 186 235 95 181 227 214 165 59 102 188 234 234 173 0 235 174 0 231 176 0 116 191 219 238 177 1 224 175 69 240 174 37 240 179 7 232 184 6 149 189 203 236 178 58 233 180 49 243 181 13 234 181 50 242 181 31 232 185 42 137 196 220 242 186 19 232 186 53 226 187 61 245 188 0 233 190 16 114 203 242 126 201 229 236 192 0 237 193 0 248 191 29 243 193 28 242 197 9 237 199 6 133 208 236 240 201 0 244 204 0 240 196 94 231 202 64 146 211 240 246 206 0 148 213 243 244 210 3 249 210 32 250 215 0 247 218 0 239 214 66 161 220 245 245 222 0 246 223 0 241 225 0 170 224 243 245 228 5 233 227 112 247 234 74 255 245 52 255 248 86 254 251 69 255 249 95 255 251 104 253 255 115 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C?@O<@?0C?@O<@?8C? O>@_8A? G>@_8A? b') ; yourself); yourself]
!

versionBase16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionBase16x16 inspect
     ImageEditor openOnClass:self andSelector:#versionBase16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionBase16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
ARP!!HRL%I"\0LSL4L#X5@TK.;^70</O4=_[6>_+;=1AA9NC^7.W%9._(:^3.<^($PMGL4=OU5=[V6=/\7^S!!HC:>0<OC0L''I3,?Q4-_W108/,J6-+[R9.+.<
0L''E3LXMK)& (:Z''):^,,[R6/+;AB212$YZU"9^\(:N%)::.''00TN$=)]XVD"(*R_Y&Y&Y8JD3(:N4Q_U6=5]WU5^IF]BQIHR$-EP4QHTV)+Y&&DT@\+Y55Z
VUUUU4YFR$]MUS0FJ&>CU6Y,U6Y]U6!!(S%T<@!!->^H*C"''=?_6=_U6Y&OPH(/*>##X2Q^W!!=^72J$3<DBB$-G!!(_GA(WGQ\VE!!TQ@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[9 43 68 33 57 70 7 65 94 8 66 94 16 64 93 42 74 91 6 68 101 6 73 103 20 72 106 16 78 107 20 84 116 31 89 119 21 87 120 36 90 117 40 98 124 56 108 127 71 107 120 14 100 138 3 102 154 5 103 153 6 109 158 10 107 152 12 107 152 15 105 154 14 106 154 15 105 156 15 105 158 15 109 158 18 106 159 17 108 157 17 110 159 22 108 158 44 103 129 49 108 132 49 109 133 50 111 135 57 105 128 54 112 136 61 113 138 61 117 141 40 111 154 38 114 157 1 108 160 9 108 162 5 114 162 25 114 163 20 120 166 30 127 172 66 118 141 71 120 142 77 120 137 74 120 140 76 120 141 80 119 130 82 122 134 9 129 179 1 128 189 1 131 191 2 130 191 5 130 191 9 128 184 19 132 182 37 132 177 35 135 183 44 144 188 67 151 191 95 152 181 5 131 192 2 134 195 7 132 193 3 133 198 5 133 197 6 133 196 6 134 198 7 135 199 9 133 195 9 134 196 9 133 198 8 134 199 1 137 198 15 138 193 15 136 197 12 137 199 2 135 200 3 135 200 5 133 200 3 136 201 1 139 202 5 136 202 7 137 202 6 138 203 4 140 201 0 138 204 0 139 205 0 140 205 0 142 204 0 143 204 2 143 204 1 140 207 0 141 207 3 143 207 5 142 205 5 140 207 9 138 203 13 139 201 10 143 204 20 137 199 18 140 201 3 144 206 6 144 205 7 144 205 5 144 206 4 145 206 7 145 207 13 145 203 8 145 205 8 147 207 10 147 206 15 144 206 11 149 207 13 148 207 15 149 207 13 150 207 17 147 203 18 147 205 19 148 207 20 152 207 4 146 209 4 147 209 6 146 208 10 146 208 10 147 209 14 146 208 11 148 210 10 149 210 11 149 210 15 149 208 13 148 210 13 151 210 14 153 211 12 152 212 14 155 213 17 144 210 19 149 209 16 150 209 19 151 208 21 150 208 24 146 208 22 152 208 20 152 211 18 152 212 20 154 213 25 153 208 28 155 209 29 155 211 30 155 210 31 155 213 36 142 192 41 150 196 51 157 206 33 157 210 33 157 213 35 157 213 33 158 213 35 159 215 37 158 214 25 160 213 40 162 213 41 162 213 40 161 214 41 160 215 47 164 213 47 165 214 46 166 215 45 163 218 43 167 223 49 162 215 53 163 215 49 166 215 48 163 216 50 164 216 48 164 220 60 166 218 60 167 221 62 167 220 51 169 218 52 170 219 55 171 220 57 171 221 61 168 221 61 169 223 59 173 223 61 173 223 73 162 207 66 170 220 68 169 220 69 171 221 73 172 223 87 170 213 96 180 220 67 173 224 64 174 224 66 175 226 77 175 224 76 174 225 77 174 225 65 177 227 65 177 228 68 179 229 70 176 230 70 180 230 79 176 225 82 177 227 81 178 227 85 179 228 82 180 228 81 180 231 86 180 230 87 181 231 88 182 232 89 184 233 92 191 236 97 189 230 99 190 230 98 190 232 108 195 231 98 194 235 103 193 233 99 193 237 104 192 232 110 194 232 120 196 234 123 199 237 123 204 241 141 212 233 131 207 244 134 213 244 134 214 245 137 211 243 139 211 242 140 216 245 145 219 246 145 218 247 146 219 248 148 220 248 154 222 248 158 224 249 176 227 238 160 226 250 168 229 251 179 232 248 182 236 250]; yourself]
!

versionBase24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionBase24x24 inspect
     ImageEditor openOnClass:self andSelector:#versionBase24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::IconLibrary class versionBase24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@!!LNDADQE!!XVF!!0_H2D$H2@ H18"H!!8AO=SZ6]''\7^C"8.[&9.#*;N?2;_W6>]HXU^''.;.;.<OS4=OS4=?_8>O#;?O;=?>\RTMOM3L3K2<3M3<?Q5=/^8^W)
9.[1:=T]Q<N:.[&8.K?A/\GA1LSG1<+J5-#$7<8VR*:.,+N6-+&9.[2<0LC@0LC@0<#B4L$ON:J*****+:.+*;N1-[V5-;.;0LB=1+8VN*J\)JF!!)JR#*J"+
*:6-,[V5-+&9/;@MNIBQ$)JY$)JY''):^(:N#*J"/)+J/-I4LNXNK#H.N!!)JT$)JR%).[&Y.&)*J&*YLTM6&H"H"H"H.N#(:N#9BP$IZV&*JZ&8(UMU5,\8E9
 V=2^XRH"8.K"8:O#9*V%''4UMT%HV6I1\WE1\W9/^XNC (NH"H.K#G@YM$EAP45_W&11[7E1^GM8\7M: (M3"VLULDMCRDMAP45[V6I"X&I"[F1,X''91_5 K
LDMQUEEMRDMCPUQTW6!!+]&I,[HE5[D0KLU)ST5M(W5)TTT5MTUEQUE)SW6-SYC4JL65ST5MST5MST5MSS$9NS$9HQD9DRC8JLVI1[FI"X&I WE1ST5M[ZF!!_
UEQNS30GLFI,\V11\W!!,X&I"Y&I!!W%9^T5MSWS0HLH]:^&93[798[G9/\V1,X&I!!WFA\Y30EMIF,%9RK_G%9\&=/[6=1[&91[GV@]DHDJ9>6+)2P"8"A!!7=?
_7=?_7=?\7Q.^4@CA"X-I2\''I2</JR$)JR (JB (K"4,J"T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[1 10 28 0 14 26 0 23 36 0 29 57 1 32 55 0 32 58 0 34 61 3 34 57 0 35 56 0 36 63 0 37 64 0 41 63 3 45 67 0 47 68 5 46 69 6 47 70 0 50 72 0 51 73 15 48 60 17 47 65 9 49 72 0 51 79 0 53 74 0 53 75 25 47 61 2 53 81 13 51 74 1 55 77 4 57 79 15 55 72 23 55 68 7 59 81 19 58 76 12 61 83 25 59 67 21 60 77 23 61 79 5 67 94 6 75 114 0 78 122 0 80 124 0 80 130 0 82 120 25 76 110 0 84 122 17 80 119 0 85 123 20 80 125 2 85 129 0 86 135 0 88 137 0 90 139 26 85 125 1 97 141 22 92 137 9 99 143 16 104 142 31 100 139 22 107 145 26 109 147 16 117 155 0 123 166 22 117 161 73 108 128 48 114 148 0 126 187 40 118 156 0 128 189 0 128 196 0 129 190 0 130 191 31 124 162 0 131 192 0 132 187 32 125 163 0 131 198 20 129 172 4 132 193 0 133 200 3 134 189 57 122 156 9 133 194 0 135 202 0 137 204 13 134 196 66 123 152 0 138 199 0 138 206 41 130 168 0 139 207 17 135 197 0 140 201 0 140 208 16 137 192 0 141 202 20 136 198 0 141 209 0 142 203 0 143 204 45 133 171 23 137 199 0 144 205 0 144 211 23 139 194 26 138 200 0 146 201 2 145 206 29 139 201 7 146 208 31 140 202 5 148 203 0 150 210 52 138 176 13 147 209 0 151 211 11 149 204 33 143 199 18 146 214 36 142 204 0 152 212 17 148 210 0 153 213 15 150 205 33 146 195 0 154 214 47 143 187 21 149 211 39 146 202 41 145 208 24 150 212 22 152 207 25 153 208 28 152 214 28 154 209 1 162 216 47 150 207 31 155 211 45 152 202 65 148 187 33 156 212 32 159 208 35 158 213 38 159 214 40 160 215 42 161 216 55 158 208 40 163 211 73 155 194 44 162 217 42 164 213 46 163 218 28 168 223 44 165 214 47 166 215 49 165 221 62 163 214 51 166 222 87 159 193 50 168 217 83 160 206 64 165 215 51 169 218 55 168 224 53 170 219 67 167 217 58 170 227 68 168 218 56 172 221 58 173 223 80 168 213 71 170 220 60 174 224 62 173 229 61 175 225 64 174 231 74 172 223 96 168 202 63 176 226 75 173 224 76 174 225 85 173 218 65 178 228 78 175 226 67 180 229 77 178 222 80 177 228 82 178 229 70 182 231 83 179 230 81 181 226 105 176 211 92 179 225 85 181 233 93 180 226 84 184 228 75 186 235 95 181 227 87 183 234 94 184 223 98 184 230 89 188 232 106 188 222 102 188 234 100 190 229 101 191 230 104 193 232 116 191 219 105 194 233 107 196 235 114 196 229 149 189 203 102 199 244 137 196 220 135 198 215 113 202 241 128 199 234 114 203 242 126 201 229 134 199 228 130 201 236 128 203 231 131 205 234 134 204 240 117 209 242 133 208 236 128 209 243 143 208 238 145 209 239 123 215 247 133 213 247 146 211 240 161 210 223 148 213 243 144 214 250 156 215 239 155 218 235 158 217 241 163 217 235 142 223 255 161 220 245 149 223 252 154 223 246 170 220 246 151 225 254 153 227 255 170 224 243 176 225 238 161 230 253 163 232 255 181 231 244 166 235 255 172 236 253 190 240 253 184 242 254 193 243 255 193 248 253]; yourself]
! !

!IconLibrary class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!IconLibrary class methodsFor:'utilities'!

loadAndCompileImagesFrom:aFilename

    "
        self loadAndCompileImagesFrom:'/tmp/full'
    "

    aFilename asFilename directoryContentsAsFilenames do:
        [:img|
        img isDirectory 
            ifTrue:
                [self loadAndCompileImagesFrom:img]
            ifFalse:
                [(img suffix = 'gif') ifTrue:
                    [| selector |
                    selector := (img withoutSuffix baseName) asString.
                    CodeGeneratorTool
                        createImageSpecMethodFor:(GIFReader fromStream:img readStream)
                        comment:'"      Loaded from: ',img asString,'"'
                        in:self class
                        selector:selector asSymbol]]]

    "Created: / 11-04-2008 / 09:54:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!IconLibrary class methodsFor:'documentation'!

version

    ^ '$Header$'

!

version_SVN
    ^ '§Id: SVN__IconLibrary.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !

IconLibrary initialize!
