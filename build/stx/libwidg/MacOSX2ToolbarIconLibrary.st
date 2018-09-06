"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

MacOSXToolbarIconLibrary subclass:#MacOSX2ToolbarIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!MacOSX2ToolbarIconLibrary class methodsFor:'documentation'!

documentation
"
    ToolbarIconLibrary := MacOSX2ToolbarIconLibrary

    This is a style specific icon library for a mac-OSX look (yosemity).

    Never access this iconlibrary directly from an application -
    always use ToolbarIconLibrary, which is an alias to one of the style specific
    icon libs.

    Notice and Warning:
        only redefine existing icons here; never add ionly to here.
        For every icon-method here, there MUST be a corresponding (albeit
        possibly ugly) icon-method in GenericToolBarIcon.

"
! !

!MacOSX2ToolbarIconLibrary class methodsFor:'image specs'!

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
        constantNamed:'MacOSX2ToolbarIconLibrary checkToggleOffDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@KBP8NC 8NC $K@@@@@@@KB!!@FA XFA XPB ,@@@@@A@0CAPTEAPTE@00D@@@@@@HCAPTEAPTE
APTC@ @@@@@M@0TEAPTEAPTE@04@@@@@CPLEAPTEAPTEAPLM@@@@@@4CAPTEAPTEAPTCCP@@@@@M@0TEAPTEAPTE@04@@@@@CPLEAPTEAPTEAPLM@@@@@ADF
APTEAPTEAPTFDP@@@@@O@@XC@0LC@0LF@@<@@@@@@@<QCP4MCP4MDP<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[210 209 210 223 222 223 188 187 188 237 237 237 190 189 190 239 239 239 228 228 228 218 217 218 220 219 220 185 184 185 198 197 198 200 199 200 225 225 225 189 188 189 178 177 178 206 205 206 219 218 219 195 194 195] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@A?8O?0??C?<O?0??C?<O?0??C?<O?0_>@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary checkToggleOffEnteredIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1@PDA@PD@L@@@@@@@@BB 0DA@PDA@PLB H@@@@@CQDHEQTUEQTUBADM@@@@@@<HEQTUEQTU
EQTHC0@@@@@RBATUEQTUEQTUBAH@@@@@A  UEQTUEQTUEP F@@@@@@XHEQTUEQTUEQTHA @@@@@FBATUEQTUEQTUB@X@@@@@A  UEQTUEQTUEP F@@@@@@,G
EQTUEQTUEQTGB0@@@@@ND0\HB@ HB@ GD08@@@@@@@8KA XFA XFB08@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[185 185 185 223 222 223 187 187 187 163 163 163 237 237 237 214 213 214 178 178 178 241 241 241 254 254 254 218 217 218 193 193 193 184 184 184 221 221 221 173 173 173 199 199 199 175 175 175 151 151 151 236 236 236 177 177 177 216 216 216 225 217 212 255 255 255] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@A?8O?0??C?<O?0??C?<O?0??C?<O?0_>@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary checkToggleOffIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1@PDA@PD@L@@@@@@@@BB 0DA@PDA@PLB H@@@@@CQDHEQTUEQTUBADM@@@@@@<HEQTUEQTU
EQTHC0@@@@@RBATUEQTUEQTUBAH@@@@@A  UEQTUEQTUEP F@@@@@@XHEQTUEQTUEQTHA @@@@@FBATUEQTUEQTUB@X@@@@@A  UEQTUEQTUEP F@@@@@@,G
EQTUEQTUEQTGB0@@@@@ND0\HB@ HB@ GD08@@@@@@@8KA XFA XFB08@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[185 185 185 223 222 223 187 187 187 163 163 163 237 237 237 214 213 214 178 178 178 241 241 241 254 254 254 218 217 218 193 193 193 184 184 184 221 221 221 173 173 173 199 199 199 175 175 175 151 151 151 236 236 236 177 177 177 216 216 216 225 217 212 255 255 255] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@A?8O?0??C?<O?0??C?<O?0??C?<O?0_>@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary checkToggleOnDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@ LC@0LC@0HA@@@@@@@AA@TFA XFA TEA@D@@@@@@ TFA XFA TGB@TB@@@@@@LFA XFA $J
B00E@0@@@@@CA XFA TMC <PA L@@@@@@0XQD $SE@8UDPXC@@@@@@LEE ,JE0,XEPXF@0@@@@@CA!!$ZF10]G TFA L@@@@@@0XIG2@[HQDFA XC@@@@@@HE
A!!L@AA$FA XE@ @@@@@AA@TFHQTFA XEA@D@@@@@@@DB@0LC@0LC@ D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[143 143 143 170 170 170 155 155 155 149 149 149 150 150 150 152 152 152 153 153 153 169 169 169 153 153 153 151 151 151 222 222 222 255 255 255 166 166 166 159 159 159 253 253 253 238 238 238 146 146 146 152 152 152 161 161 161 150 150 150 240 240 240 147 147 147 168 168 168 217 217 217 214 214 214 147 147 147 239 239 239 254 254 254 252 252 252 242 242 242 143 143 143 142 142 142 246 246 246 151 151 151] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@A?8O?0??C?<O?0??C?<O?0??C?<O?0_>@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary checkToggleOnEnteredIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@''G2@PDA@PHA<''@@@@@@@''FA,C@0LC@1X[FB\@@@@@G1,C@0LC@08JA!!,_@@@@@B@C@0LC@28)
K20VH@@@@@@P@0LC@2(]G ,Y@1@@@@@@D@LOE2D\CQHHJ0LP@@@@@A@*D2<EI"<0EPLCD@@@@@@P@2HZH1PDKR(C@1@@@@@@H@L.JBT#@",C@0L @@@@@A<[
@0$@CADC@0L[G0@@@@@''FA,C@QTC@0L[FB\@@@@@@B\_HA@PDA@ G2\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[58 131 213 64 148 243 79 145 217 68 153 248 218 232 245 157 199 244 70 152 244 204 211 224 70 139 215 63 147 242 120 180 244 209 226 243 78 143 214 211 230 248 68 151 244 66 150 244 57 144 248 57 140 235 252 253 254 119 179 243 248 251 254 58 141 236 66 151 246 98 167 243 60 146 248 57 138 231 210 227 243 66 151 248 64 147 240 91 162 240 251 253 254 80 153 243 56 144 248 66 149 244 59 139 230 254 254 255 223 222 223 232 240 249 142 190 241 133 178 234 54 129 214 155 199 244 67 151 246 66 150 245 112 175 241 51 131 223 65 149 244 255 255 255 141 183 226] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@A?8O?0??C?<O?0??C?<O?0??C?<O?0_>@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary checkToggleOnIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@''G2@PDA@PHA<''@@@@@@@''FA,C@0LC@1X[FB\@@@@@G1,C@0LC@08JA!!,_@@@@@B@C@0LC@28)
K20VH@@@@@@P@0LC@2(]G ,Y@1@@@@@@D@LOE2D\CQHHJ0LP@@@@@A@*D2<EI"<0EPLCD@@@@@@P@2HZH1PDKR(C@1@@@@@@H@L.JBT#@",C@0L @@@@@A<[
@0$@CADC@0L[G0@@@@@''FA,C@QTC@0L[FB\@@@@@@B\_HA@PDA@ G2\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[58 131 213 64 148 243 79 145 217 68 153 248 218 232 245 157 199 244 70 152 244 204 211 224 70 139 215 63 147 242 120 180 244 209 226 243 78 143 214 211 230 248 68 151 244 66 150 244 57 144 248 57 140 235 252 253 254 119 179 243 248 251 254 58 141 236 66 151 246 98 167 243 60 146 248 57 138 231 210 227 243 66 151 248 64 147 240 91 162 240 251 253 254 80 153 243 56 144 248 66 149 244 59 139 230 254 254 255 223 222 223 232 240 249 142 190 241 133 178 234 54 129 214 155 199 244 67 151 246 66 150 245 112 175 241 51 131 223 65 149 244 255 255 255 141 183 226] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@A?8O?0??C?<O?0??C?<O?0??C?<O?0_>@@@@@@b'); yourself); yourself]
!

comboMenuButtonDisabledIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self comboMenuButtonDisabledIcon inspect
     ImageEditor openOnClass:self andSelector:#comboMenuButtonDisabledIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSX2ToolbarIconLibrary comboMenuButtonDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:18) bits:(ByteArray fromPackedString:'
@@DA@PDA@PDA@@DA@ LDAPXGA XFA0XFA XFA  IB ,HB@ HB@0LC@0HB@ LB@4NC0TEAPTOAPTEAP<EAPTID@HIBPHI@ $IBPHBBP$IBQDMD 4MCP4RCQHR
CP4RCP4SDA@TEA@PEAPPEA@TDAPPEPDAE!!XWFA$A@Q$XE0DAE!!([GA,\@A4^G1<^GR@[F1,!!H"H"H"H#IA8^IBL"H"H"IRX''I"\&I2H(JRH''I"\&I"(UER,+
EQT+EQT+ER,+EQT,F!!(ZF!!(ZF!!(ZF!!(ZF!!(ZKR8/K2</K2<.K"</K"</K#@1LSD1HSD!!LSD1HSD1HRT2L2T3L3L3ISL%IRT%IRT4MSH2L#H2L#H2L#H2J#X7
LS 9N#$9N#(9NS$9N#(;H30E') colorMapFromArray:#[157 157 157 157 157 157 162 162 162 217 217 217 232 232 232 164 164 164 166 166 166 167 167 167 165 165 165 162 162 162 164 164 164 231 231 231 165 165 165 161 161 161 215 215 215 163 163 163 158 158 158 151 151 151 160 160 160 150 150 150 159 159 159 148 148 148 156 156 156 221 221 221 244 244 244 161 161 161 147 147 147 155 155 155 154 154 154 241 241 241 245 245 245 160 160 160 158 158 158 144 144 144 153 153 153 155 155 155 240 240 240 143 143 143 150 150 150 151 151 151 237 237 237 236 236 236 141 141 141 149 149 149 139 139 139 137 137 137 145 145 145 145 145 145 136 136 136 144 144 144 142 142 142 142 142 142 139 139 139 159 159 159 141 141 141 138 138 138 226 226 226 132 132 132 131 131 131 138 138 138 223 223 223] mask:((ImageMask width:16 height:18) bits:(ByteArray fromPackedString:'??;????????????????????????????????????????????>'); yourself); yourself]
!

comboMenuButtonIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self comboMenuButtonIcon inspect
     ImageEditor openOnClass:self andSelector:#comboMenuButtonIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSX2ToolbarIconLibrary comboMenuButtonIcon'
        ifAbsentPut:[(Depth8Image width:16 height:18) bits:(ByteArray fromPackedString:'
IDA]WU5@D$A@IDA@K1P>@DPIQDQ_BTQDQDQ_W2M&S#T#H0PDH3<?O3=PH2L?AFMMOD=O@@@<HBAO@C1OS4=&XC)''GS(]N!!5''GU :GQ5''GR08UFI"NFITNEQT
NC!!TX# JI2]RT"\''T%H''T"]RI5H''A51\D1L3LP=\WCAHDE1\D0IJZD)(M"%KCB-KJQUJR$(;YFQ$F&Q[I!!D4A%,ZF&PZF5LWJA]SE4\_V$\WT1]ST6D%IPTE
IRTEIRTEIPTEP"TVHS4A@S4AOS4=HPD=@PD!!W%%)G&%)G&%YVQ9)VQ9)VPM%YVU%L&UIYVU%RVT\L%T9Q%YFQ$YFCTXMCUX-U%XHFQ XFA XFA XFA XM2)C
SDUWC%]WK"9WU5]WK 9QPRH@') colorMapFromArray:#[101 172 248 53 140 250 61 135 247 46 108 250 105 175 248 57 144 249 207 230 254 64 139 247 43 118 250 109 178 248 67 143 247 233 232 233 89 165 249 43 131 251 43 93 250 93 168 249 146 198 251 225 240 254 80 159 246 78 159 248 141 189 240 82 161 249 49 116 249 62 149 249 42 128 251 117 150 239 67 152 248 55 125 248 45 133 250 95 170 248 49 136 250 198 225 253 101 172 247 52 140 250 181 192 232 105 175 247 81 160 247 57 143 249 207 230 253 84 163 248 61 147 248 212 232 253 42 124 251 88 165 249 70 147 246 43 130 251 42 93 250 99 167 243 92 168 249 221 237 253 46 134 251 146 197 251 225 239 254 193 212 235 81 161 249 42 127 251 90 167 248 65 117 245 95 169 248 57 130 247 100 172 247 52 140 249 194 213 236 104 175 247 81 160 246 111 141 235 56 143 249 42 116 251 109 177 247 185 197 236 43 130 250 68 152 249 220 237 253 46 134 250 72 156 248 224 239 254 77 118 242 137 184 240 108 171 243 101 173 248 105 176 248 61 107 244 85 163 249 62 147 249 90 166 248 46 130 250 44 131 251 43 94 250 95 169 247 48 136 249 197 224 253 74 157 248 78 160 248 80 160 246 48 111 249 108 177 247 91 159 243 52 121 249 91 167 249 93 167 247 67 152 249 46 133 250 97 170 247 96 170 248 72 155 248 49 137 250] mask:((ImageMask width:16 height:18) bits:(ByteArray fromPackedString:'??;????????????????????????????????????????????>'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary radioOffDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@^A 8KB08FG @@@@@@@@@_@Q$BF1,BFPD_@@@@@@@_GAPQDQDQDQDTGA<@@@@ZEP\QDQDQDQDQDP\UF @@FQHQDQDQDQDQ
DQDQD!!$@@@(QDQDQDQDQDQDQDQDJ@@@XDQDQDQDQDQDQDQDQF@@@D1DQDQDQDQDQDQDQDQL@@A4QDQDQDQDQDQDQDQD]@@@DAQDQDQDQDQDQDQDEA@@@BQ@W
DQDQDQDQDQDWD@$@@@@CCQ\QDQDQDQDWCPL@@@@@@@LPAQDQDQDED@L@@@@@@@@@BPP]C0<]A@$@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[254 254 254 173 173 173 213 213 213 204 203 204 199 199 199 212 212 212 185 185 185 225 225 225 250 250 250 214 213 214 182 182 182 155 155 155 249 249 249 195 195 195 167 167 167 180 180 180 193 193 193 233 233 233 206 206 206 179 179 179 219 219 219 178 178 178 223 222 223 231 231 231 177 177 177 190 190 190 208 207 208 230 230 230 176 176 176 189 189 189 207 206 207 193 192 193] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@O<A?8O?1??''?>_?9??''?>_?9??''?>O?0_>@?0@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary radioOffIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@^A 8KB08FG @@@@@@@@@_@Q$BF1,BFPD_@@@@@@@_GAPH@B@ @@ TGA<@@@@ZEP\ HB@ HB@ H@\UF @@FQH HB@ HB@ 
HB@ D!!$@@@(QHB@ HB@ HB@ HADJ@@@XCB@ HB@ HB@ HB@LF@@@D00 HB@ HB@ HB@ CAL@@A4QHB@ HB@ HB@ HAD]@@@DAR@ HB@ HB@ HB@EA@@@BQ@W
HB@ HB@ HB@WD@$@@@@CCQ\ HB@ HB@WCPL@@@@@@@LPAQDLCADED@L@@@@@@@@@BPP]C0<]A@$@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[254 254 254 173 173 173 213 213 213 204 203 204 199 199 199 212 212 212 185 185 185 225 225 225 250 250 250 214 213 214 182 182 182 155 155 155 249 249 249 195 195 195 167 167 167 180 180 180 193 193 193 233 233 233 206 206 206 179 179 179 219 219 219 178 178 178 223 222 223 231 231 231 177 177 177 190 190 190 208 207 208 230 230 230 176 176 176 189 189 189 207 206 207 193 192 193 255 255 255] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@O<A?8O?1??''?>_?9??''?>_?9??''?>O?0_>@?0@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary radioOnDisabledIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@A@ LDA@LB@P@@@@@@@@@EA \HBP$HA0XE@@@@@@@EA@ JB (JB (HA@T@@@@AA  JB (JB (JB  F@P@@@ \JB (KC@0K
B (JA0H@@@LHB (KCP8OCP,JB  C@@@DBP(JC@<PD@<LB (IA@@@A@$JB 0QDA@QC@(JBPP@@@LHB (KBQHRBP,JB  C@@@BA0(JB!!LTEALJB (G@ @@@PXH
B (JB (JB (HA D@@@@EA@ JB (JB (HA@T@@@@@@@TFA0 IBP GA T@@@@@@@@@@PHCA@PC@ D@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[238 238 238 227 227 227 170 170 170 158 158 158 151 151 151 217 217 217 155 155 155 150 150 150 152 152 152 153 153 153 153 153 153 152 152 152 151 151 151 165 165 165 244 244 244 245 245 245 255 255 255 242 242 242 242 242 242 147 147 147 135 135 135] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@O<A?8O?1??''?>_?9??''?>_?9??''?>O?0_>@?0@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary radioOnIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@GE@HOC0HTA0@@@@@@@@@NE0LED!!HE@1\N@@@@@@@ND@TUEQTUEQTED@8@@@@GE0TUEQTUEQTUEPTWA0@@E@LUEQTFA@PF
EQTU@1P@@@HEEQTFC@,MC@XUEPTB@@@OD!!TUAADSD1DDEQTRC0@@C1HUEPPVD1LVAATUD <@@@HEEQTF@P$I@PXUEPTB@@@T@1TUEP JB  UEQTCE@@@A1\E
EQTUEQTUEQTEE0\@@@@ND@TUEQTUEQTED@8@@@@@@@8W@0TRD TCE08@@@@@@@@@A1PBC0<BE@\@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[223 222 223 85 149 218 93 160 240 61 147 248 65 149 244 65 151 248 67 151 246 187 203 228 58 141 236 219 232 245 38 115 212 222 236 250 109 173 243 225 238 251 151 185 232 66 147 246 64 148 245 226 238 250 67 152 248 255 255 255 133 178 234 68 153 248 220 233 246 82 154 243] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@O<A?8O?1??''?>_?9??''?>_?9??''?>O?0_>@?0@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollDownDisabledIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CL2DQ@@@@@@P3LQP@@@@@@DL1P@@@@@@@ACP@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 192 192 190 176 174 170 156 158 160 244 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@A?@G<@O @\@@@@@@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollDownEnteredIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FFYL3@@@@@@P!!FSP@@@@@@DVHP@@@@@@@AGP@@@@@@@@@P@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 72 74 70 32 34 30 136 134 130 244 246 250 32 30 30 84 86 90 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@A?@G<@O @\@@ @@@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollDownIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@FB@0MC1@N@@@@@@@@@@@@D HEBP,JD @@@@@@@@@@@@@R@PPGD @@@@@@@@@@@@@@@AHCD @@@@@@@@@@@@@@@@@@D @@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[0 0 0 32 30 30 32 34 30 44 46 50 52 54 50 72 74 70 84 86 90 92 92 90 120 120 120 120 122 120 136 134 130 140 140 140 156 158 160 176 174 170 184 182 180 184 184 180 192 192 190 228 228 230 244 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@A?@G<@O @\@@ @@@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollLeftDisabledIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P0@@@@@@@@P3@@@@@@@@P3L@@@@@@@P3L @@@@@@@DDQ@@@@@@@@AAD@@@@@@@
@@PP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 192 192 190 176 174 170 120 120 120 244 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@F@@8@G @>@A8@C @F@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollLeftEnteredIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L @@@@@@@@L!!@@@@@@@@MA\@@@@@@@MVE0@@@@@@@CY7@@@@@@@@@7\@@@@@@@
@@M0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 72 74 70 32 34 30 244 246 250 32 30 30 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@F@@8@G @>@A8@C @F@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollLeftIcon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D X@
@@@@@@@@@@@@@@@@D HH@@@@@@@@@@@@@@@@D DEC@@@@@@@@@@@@@@@D LDBP4@@@@@@@@@@@@@@@@RA0,O@@@@@@@@@@@@@@@@@AHJD@@@@@@@@@@@@@@@
@@@@D 8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[0 0 0 32 30 30 32 34 30 44 46 50 52 54 50 72 74 70 84 86 90 92 92 90 120 120 120 120 122 120 136 134 130 140 140 140 156 158 160 176 174 170 184 182 180 184 184 180 192 192 190 228 228 230 244 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@F@@8@G @>@A8@C @F@@@@@@@@@@@@b'); yourself); yourself]
!

scrollRightActiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollRightActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightActiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSX2ToolbarIconLibrary scrollRightActiveIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GT@@@@@@@@@\%@@@@@@@@B!!YP@@@@@@@JFXT@@@@@@@(9T@@@@@@@B$T@@@@@@@
@JT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 72 74 70 32 34 30 140 140 140 136 134 130 244 246 250 32 30 30 84 86 90 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@L@@8@C0@O @<@C @L@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollRightDisabledIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BP@@@@@@@@@H$@@@@@@@@@"I@@@@@@@@CH"P@@@@@@@DQP@@@@@@@@QP@@@@@@@
@AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 192 192 190 120 120 120 156 158 160 244 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@L@@8@C0@O @<@C @L@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollRightEnteredIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GT@@@@@@@@@\%@@@@@@@@B!!YP@@@@@@@JFXT@@@@@@@(9T@@@@@@@B$T@@@@@@@
@JT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 72 74 70 32 34 30 140 140 140 136 134 130 244 246 250 32 30 30 84 86 90 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@L@@8@C0@O @<@C @L@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollRightIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@IH@@@@@@@@@)R@@@@@@@@A>P @@@@@@@A<=H@@@@@@@"+H@@@@@@@CJH@@@@@@@
@FH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 176 174 170 244 246 250 52 54 50 32 30 30 32 34 30 184 182 180 156 158 160 184 184 180 84 86 90 140 140 140 92 92 90 192 192 190 44 46 50 72 74 70 120 122 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@L@@8@C0@O @<@C @L@@@@@@@@@@@@b'); yourself); yourself]
!

scrollUpActiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollUpActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpActiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSX2ToolbarIconLibrary scrollUpActiveIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@@@@@@@6L@@@@@@@@4]3@@@@@@@2HX 0@@@@@EVH"H@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 72 74 70 32 34 30 244 246 250 32 30 30 84 86 90 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@B@@\@C8@_0A?@@@@@@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollUpDisabledIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@@@@@@@@@ACP@@@@@@@ACLT@@@@@@ACL1E@@@@@@CL2DQ@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 192 192 190 176 174 170 156 158 160 244 246 250] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@B@@\@C8@_0A?@@@@@@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollUpEnteredIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@@@@@@@6L@@@@@@@@4]3@@@@@@@2HX 0@@@@@EVH"H@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 72 74 70 32 34 30 244 246 250 32 30 30 84 86 90 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@B@@\@C8@_0A?@@@@@@@@@@@@@@@@@b'); yourself); yourself]
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
        constantNamed:'MacOSX2ToolbarIconLibrary scrollUpIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@]D@@@@@@@@SJ!!@@@@@@@T;9$P@@@@@H1''^5@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 244 246 250 52 54 50 32 30 30 32 34 30 184 182 180 156 158 160 184 184 180 84 86 90 140 140 140 92 92 90 192 192 190 120 120 120 44 46 50 72 74 70 120 122 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@B@@\@C8@_0A?@@@@@@@@@@@@@@@@@b'); yourself); yourself]
! !

!MacOSX2ToolbarIconLibrary class methodsFor:'image specs - widgets'!

scrollDownActiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollDownActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownActiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSX2ToolbarIconLibrary scrollDownActiveIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FFYL3@@@@@@P!!FSP@@@@@@DVHP@@@@@@@AGP@@@@@@@@@P@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 72 74 70 32 34 30 136 134 130 244 246 250 32 30 30 84 86 90 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@A?@G<@O @\@@ @@@@@@@@@@@@@@b'); yourself); yourself]
!

scrollLeftActiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollLeftActiveIcon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftActiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSX2ToolbarIconLibrary scrollLeftActiveIcon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P0@@@@@@@@P2@@@@@@@@QR @@@@@@@Q''J@@@@@@@@D^H@@@@@@@@AH @@@@@@@
@@R@@@@@@@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 244 244 240 72 74 70 32 34 30 244 246 250 32 30 30 44 46 50 52 54 50 120 120 120] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@F@@8@G @>@A8@C @F@@H@@@@@@@@@b'); yourself); yourself]
! !

!MacOSX2ToolbarIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

