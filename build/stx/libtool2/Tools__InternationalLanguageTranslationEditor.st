"{ Package: 'stx:libtool2' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#InternationalLanguageTranslationEditor
	instanceVariableNames:'languagesList keyStringsToLanguageMappings languageTextHolder
		originalTextHolder modified shownLanguages selectedKeyRow
		showMissingTranslationsOnly
		keyStringAndLanguageSelectionTableColumnDescriptionHolder
		languageShownHolders dataSetView lastExtractedClass
		lastExtractedApplicationClass stopApplicationIconVisibleHolder
		monitoredApplication originalTextModifiedHolder
		languageTextModifiedHolder languageTextAcceptHolder
		inSingleFileMode lastExtractedProject lastLanguage
		lastSelectedKey autoAcceptHolder languageEditor
		selectedColIndexHolder exampleLanguageSelectionHolder
		exampleLanguageTextHolder pastePreviousTranslationEnableHolder
		searchForSimilarTranslationEnableHolder alwaysWriteUTF8Holder
		lastNameSpace pasteOriginalEnableHolder ignoreCaseHolder
		closeSearchBar searchTextModifiedHolder searchNextText
		searchBarImageInfoLabelHolder searchPreviousText searchBoxVisible
		searchBarInfoLabelHolder searchTextHolder searchTextView
		searchBoxView translationsPanel lastPackage methodsUsingKey'
	classVariableNames:'LastExtractedClass LastExtractedApplicationClass
		LastExtractedProject LastProject'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

Object subclass:#AccessCollectingPseudoResourcePack
	instanceVariableNames:'collectedKeys realResourcePack watchingTranslationEditor'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InternationalLanguageTranslationEditor
!

Collection subclass:#KeyStringsToLanguageMappings
	instanceVariableNames:'keys keyInfo perLanguageInfo perLanguageMappings languageMappings
		languages rowPerKey'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InternationalLanguageTranslationEditor
!

Object subclass:#LanguageMappingRow
	instanceVariableNames:'key mappings'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InternationalLanguageTranslationEditor
!

Visitor subclass:#UISpecVisitor
	instanceVariableNames:'translatedLabels'
	classVariableNames:''
	poolDictionaries:''
	privateIn:InternationalLanguageTranslationEditor
!

!InternationalLanguageTranslationEditor class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	cg (cg@FUSI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
								[exBegin]
    InternationalLanguageTranslationEditor open

								[exEnd]

  more examples to be added:
								[exBegin]
    ... add code fragment for
    ... executable example here ...
								[exEnd]
"
!

history
    "Created: / 04-03-2006 / 09:07:19 / cg"
! !

!InternationalLanguageTranslationEditor class methodsFor:'help spec'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#searchBox
'Show a search box at the bottom to search for substrings in the string keys'

#browseReferringMethods
'Browse methods which refer to this string'

)
! !

!InternationalLanguageTranslationEditor class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::InternationalLanguageTranslationEditor    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#searchBox
''

)
! !

!InternationalLanguageTranslationEditor class methodsFor:'image specs'!

closeSearchBarIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self closeSearchBar inspect
     ImageEditor openOnClass:self andSelector:#closeSearchBar
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:#'Psiware::SystemManagement class closeSearchBar'
	ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GQ\SD1LSD1LSD1LSD1LWGP@@@@@@
@ATGA@HA@PDA@PDA@PHDA1T@@@@@@@@TAENG!!(VB XA?_''57QPPT@@@@@@@@E NJ^V)&X%)UTT5IV7 KE @@@@@@@A A"7Q,#&9VS%^MQ$E<DQ @@@@@@@@Z
@X%-#9NRX52R$80:^1@Z@@@@@@@@F0FHY6>R$9JR$9ION''(PF0@@@@@@@A<A 5ABT)FS$9D=KR13C1<@@@@@@@@)@WUCND*Q$9NQM"T!!XP8)@@@@@@@@K E2
O4RQ$9FQ$9@2G%8JK @@@@@@@CLA\S2D$9D9M)BS]!!1]BSL@@@@@@@@7@W@5LXP6J2\2]"P"VP 7@@@@@@@@O U+R3@*I2T#HA0&N5 RO @@@@@@@D LPF%(
YVQ W59]VU 4CD @@@@@@@AGFP4F@PDA@PDA@PDFCQ%G@@@@@@@@K41TUEQTUEQTUEQTUEQLK0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 167 25 15 170 49 40 171 50 39 174 68 60 176 56 48 176 58 49 183 118 110 184 45 32 184 46 32 184 47 34 184 71 58 184 85 78 184 86 79 185 53 39 186 57 42 186 59 43 186 60 45 186 68 58 190 187 180 192 188 181 193 189 182 194 190 183 195 192 184 197 194 186 202 148 142 202 199 191 205 202 195 207 64 48 207 203 195 208 65 49 208 205 198 209 65 49 209 66 49 209 69 52 210 66 49 210 78 64 211 67 51 211 71 54 212 69 51 212 208 200 212 208 202 213 69 52 213 70 52 213 79 57 215 80 59 215 212 206 217 214 207 218 79 62 218 84 67 219 107 95 219 216 210 221 84 63 221 84 67 221 109 96 221 218 213 222 76 56 222 110 96 222 113 79 223 87 67 223 87 70 223 115 99 224 221 216 225 89 72 225 105 91 225 117 84 227 89 64 227 91 73 227 112 98 227 115 95 227 122 92 227 224 219 227 225 219 228 113 83 228 113 99 229 102 87 229 226 221 230 115 84 230 117 81 230 142 117 231 102 80 231 116 86 231 120 103 231 131 119 231 228 224 232 118 88 232 119 82 233 143 117 234 99 76 234 102 79 234 119 89 234 127 100 234 145 119 235 104 82 235 106 86 236 108 89 236 110 92 236 113 92 236 121 91 236 146 119 237 113 95 237 115 98 237 122 92 237 132 100 238 117 101 238 119 104 238 123 93 238 123 109 238 131 98 238 133 102 238 146 120 238 148 121 239 125 112 239 127 115 239 129 118 239 131 105 239 134 102 240 135 122 240 200 196 242 135 113 242 141 116 242 141 119 242 145 116 242 147 118 242 148 120 243 137 115 243 138 118 243 141 121 243 142 123 243 144 126 243 145 129 243 151 134 243 202 197 244 147 132 244 149 135 244 152 137 244 163 142 244 164 145 245 160 143 245 164 146 245 213 204 246 213 203 248 215 205 249 215 206 252 244 243 253 244 243 253 247 245 255 255 255]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? @@@@@@@@@@@@') ; yourself); yourself]

    "Created: / 15-06-2007 / 18:04:38 / Administrador"
!

restartSearchBarIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self restartSearchBarIcon inspect
     ImageEditor openOnClass:self andSelector:#restartSearchBarIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:#'Psiware::SystemManagement class restartSearchBarIcon'
	ifAbsentPut:[(Depth24Image new) width: 20; height: 20; photometric:(#rgb); bitsPerSample:(#[8 8 8]); samplesPerPixel:(3); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@?>SX?>''V?>;)?>O!!?>G]?>WY@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?=3\:[>''5;JF/Y-.+XY),(U.
6JZK?=J1?>V<>.+I@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?>?'':+:!!19]U6*-Q?]Y/?>RC?>*!!?>F_>+=939UL2Y!!L>MJT??W[@@@@@@@@@@@@@@@@@@@@
@@@@??[-=\^&1IEP=<Q[?>1/?=5$?=52?>NT?=^Q?>BP?>FG>;1]6JEO8;^H?]3I@@@@@@@@@@@@@@@@@@@@?\*95Y-)<+!!$??.F?>)17+-U8,E40Y-.09I)
:Z1-?=I??=)8?<1.>K597;NL??K,@@@@@@@@@@@@?=#M6I>B>+:@?>2U=,]]5[IN7,^C5LB[<MWL?]#O=,BZ7)=\>;Y[??FP?=>O1YEW8<B$;=WH@@@@@@@@
>,"%8Z:A?>N#?>._5KA$9-JW7=+FX6M+V%U3"''*T0Y>V4ZA7595T=;1"?=&D?=&L,W(93IU\:KE9=LBG9[Q9;K1<?=^R:K591*-6??''[@@@@RE%37>7?=?/?
>^_''3*.M0YAU<K5,?>ZO?=>G?<!!6?<Y6>+U(69YI3:IG?=Z@?>NU5:=19,6%@@@@@@@@OU5*2.+7;O??5-KF2;JS?=*&?>&"?=.E?>2R?=&F?>"X8I-N5)ED
29$&?>M:?=*F3:E&>]/A@@@@@@@@O5=.7O??5^/(?O++<M.>0I-/;LNE??2)?=&B?>^%,W)A8:14?=FX3)TR?>U/?=Q:3IAZ?=?T@@@@@@@@P5Y68_#?7.70
??[1??C_:,F%6;A=>MJA?>6":,6+&G91?>+^?>+]79<$?<1\?=:C5IM[?<;F@@@@@@@@Q$1>6N_?<?+?<.W.?>3*??S(=,.(2Z!!#=-:^+9>P4,[P<>''46=O^
=+MX;Z)O?>^Q:Z]*;+Z''@@@@@@@@TD:O9^/?;/C??>???>/:?>71?>7Z;]^%0+JA7=CI8]O"0+[D8=#&?<&V79="?=2L?\E88[BG@@@@@@@@VU&M=_3?9N''?
>/C???K??NK/??[1???#9M?B??3;(IV#/[WD;^_5@@@@;KR]<[10?=Q68[9,8,>W@@@@TU9&;/??9__9:.;/?_#<??/?>?[==?79>_?=<_S9T5M[0,WN7^G*
@@@@@@@@1Y= >=!!>9,]-3[],6]B''TEH=;O_''=O?6>O77>O''=>//?=_+?:O_?:_''?>O??SEM[/<[P6.O,@@@@@@@@8-F%1*%/9[>@?>R(7+VG_%,;\E]CW$=H
U5AWV5%.U5);R5M:Q5M;S%-=TE]*[GI>):696M;*@@@@@@@@@@@@6\F[2Y914)9.;[VF?L"!!8[^_3J>''0KB:0;?V0,_''-<C),K/(,;7!!+[OI,K[D2=G_9N+8
@@@@@@@@@@@@@@@@@@@@?\*_7*]>3))5/II9+9FF+9> 0;7I5-#-7NO?7^#?8^/?:/G?7NK07>W3@@@@@@@@@@@@@@@@@@@@@@@@?>N;?>N;?=:9?>7T?>#X
>^_%=N?6<OK?@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; mask:((Depth1Image new) width: 20; height: 20; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@?@OC?0OO?8O_?<O_?>O???O?????_??>_??>_??>_??>_??>_??>_??__??O???O???G???A??/A? O') ; yourself); yourself]
!

searchNextIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self searchNextIcon inspect
     ImageEditor openOnClass:self andSelector:#searchNextIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:#'Psiware::SystemManagement class searchNextIcon'
	ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ZE)ZZ@@@@@@@@@@@@@@@
@@@@@@AFF XA@PXUQ @@@@@@@@@@@@@@@@@*@Q5G^WX6E0D*@@@@@@@@@@@@@@@,AVQ?\&1#W&X8@20@@@@@@@@@@@A[@U==\F-"VUQOUSLAV0@@@@@@@@@@
G19-D <NCP0KB!!@7D1<@@@@@@@@@  ]MT5JY&Y&Y&Y%RLR4G  @@@@@@@H\A WL $)&Y&Y&RF35B@X\@@@@@@@BK@XA1WA"X&Y&XE#T:P@FK@@@@@@@@# !!H
]F$<II&YH3H>N2 H# @@@@@@@@@''GG)*Y2$9NRIDO4DQHP@@@@@@@@@@!!@EP[6U]I"UIQTL.@XP@@@@@@@@@@@ALAD-.XE]VS$(/@$0@@@@@@@@@@@@@@EDA
FSQ!!VC@T@UD@@@@@@@@@@@@@@@@@#R,I@PDIJ84@@@@@@@@@@@@@@@@@@@@@%)^W% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 48 54 77 55 63 87 56 64 89 57 67 90 59 67 90 64 69 89 71 74 92 72 76 96 76 81 100 80 89 118 82 90 119 83 91 120 84 92 122 86 94 123 87 96 124 89 97 126 92 104 132 97 106 136 97 110 138 97 112 138 100 102 112 101 107 130 104 118 144 105 113 135 105 124 146 107 109 118 107 116 144 110 127 148 112 126 148 113 129 148 117 119 129 118 130 156 119 123 133 125 140 174 127 131 146 127 132 148 127 146 178 130 151 181 131 132 143 133 149 185 133 152 182 134 134 138 137 140 150 138 138 142 139 156 191 141 160 195 143 164 199 143 169 198 144 157 197 144 158 197 152 173 208 153 184 209 155 167 210 156 180 208 157 179 215 157 180 211 160 162 171 160 173 216 160 174 216 160 182 214 161 173 217 161 174 217 161 176 219 161 179 220 161 180 220 163 182 222 163 184 222 164 182 222 164 184 223 166 164 161 166 189 212 166 194 211 167 190 228 167 194 229 167 200 221 169 170 174 169 195 212 169 196 232 170 181 228 170 203 221 171 171 176 171 173 182 171 193 220 173 182 232 173 192 232 173 200 234 175 206 239 175 210 240 176 188 237 178 175 168 178 175 173 178 202 234 178 206 240 179 195 238 180 205 223 180 214 243 180 216 244 181 193 242 181 195 239 181 204 223 181 212 243 182 206 242 182 209 243 184 180 173 184 211 244 184 215 245 185 198 246 185 200 244 188 215 233 188 225 249 189 226 249 190 206 250 190 219 248 191 209 249 191 217 248 191 222 248 192 188 181 192 221 249 194 190 184 195 191 184 196 226 251 196 232 251 199 196 189 202 198 191 202 226 253 203 199 193 203 229 253 203 237 252 203 237 253 204 202 196 206 202 195 206 205 204 207 203 196 208 204 197 208 205 201 212 208 200 212 208 201 212 208 202 212 209 205 213 210 202 213 212 213 214 211 206 215 212 207 216 213 206 218 215 210 220 221 223 221 219 214 222 219 215 222 220 215 230 228 225 236 235 232 243 243 244 255 255 255]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C@@@C@@@C@G C@_8C@?<CA?>CC??CC??CG??#G??#G??#G??#C??CC??CA?>C@?<C@_8C@G C@@@C@@@C@@@C') ; yourself); yourself]
!

searchPreviousIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self searchPreviousIcon inspect
     ImageEditor openOnClass:self andSelector:#searchPreviousIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:#'Psiware::SystemManagement class searchPreviousIcon'
	ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%)^W% @@@@@@@@@@@@@@
@@@@@@BMJ0$A@P$+#P@@@@@@@@@@@@@@@@AQ@Q$4XU 0E@EQ@@@@@@@@@@@@@@ALAD-.XE]VS$(/@$0@@@@@@@@@@@BD@UA/YU4&IT%EP28A!!@@@@@@@@@@@
I11:Z&\)NS$"QC=ADRD@@@@@@@@@# !!H]F$<II&YH3H>N2 H# @@@@@@@H,A GE\FI"Y&Y VMS)@@X,@@@@@@@BG@XE3HIJY&Y&Y$!!,=P FG@@@@@@@@  ]M
T5JY&Y&Y&Y%RLR4G  @@@@@@@@@_G&4RC08MC@,JDC\SG0@@@@@@@@@@V0E__WA+X%%TS5T3@U,@@@@@@@@@@@@,AVQ?\&1#W&X8@20@@@@@@@@@@@@@@B(A
GT]9]#XW@R(@@@@@@@@@@@@@@@@@Q!!(F@PDFETX@@@@@@@@@@@@@@@@@@@@@ZE)ZZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 48 54 77 55 63 87 56 64 89 57 67 90 59 67 90 64 69 89 71 74 92 72 76 96 76 81 100 80 89 118 82 90 119 83 91 120 84 92 122 86 94 123 87 96 124 89 97 126 92 104 132 97 106 136 97 110 138 97 112 138 100 102 112 101 107 130 104 118 144 105 113 135 105 124 146 107 109 118 107 116 144 110 127 148 112 126 148 113 129 148 117 119 129 118 130 156 119 123 133 125 140 174 127 131 146 127 132 148 127 146 178 130 151 181 131 132 143 133 149 185 133 152 182 134 134 138 137 140 150 138 138 142 139 156 191 141 160 195 143 164 199 143 169 198 144 157 197 144 158 197 152 173 208 153 184 209 155 167 210 156 180 208 157 179 215 157 180 211 160 162 171 160 173 216 160 174 216 160 182 214 161 173 217 161 174 217 161 176 219 161 179 220 161 180 220 163 182 222 163 184 222 164 182 222 164 184 223 166 164 161 166 189 212 166 194 211 167 190 228 167 194 229 167 200 221 169 170 174 169 195 212 169 196 232 170 181 228 170 203 221 171 171 176 171 173 182 171 193 220 173 182 232 173 192 232 173 200 234 175 206 239 175 210 240 176 188 237 178 175 168 178 175 173 178 202 234 178 206 240 179 195 238 180 205 223 180 214 243 180 216 244 181 193 242 181 195 239 181 204 223 181 212 243 182 206 242 182 209 243 184 180 173 184 211 244 184 215 245 185 198 246 185 200 244 188 215 233 188 225 249 189 226 249 190 206 250 190 219 248 191 209 249 191 217 248 191 222 248 192 188 181 192 221 249 194 190 184 195 191 184 196 226 251 196 232 251 199 196 189 202 198 191 202 226 253 203 199 193 203 229 253 203 237 252 203 237 253 204 202 196 206 202 195 206 205 204 207 203 196 208 204 197 208 205 201 212 208 200 212 208 201 212 208 202 212 209 205 213 210 202 213 212 213 214 211 206 215 212 207 216 213 206 218 215 210 220 221 223 221 219 214 222 219 215 222 220 215 230 228 225 236 235 232 243 243 244 255 255 255]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C@@@C@@@C@G C@_8C@?<CA?>CC??CC??CG??#G??#G??#G??#C??CC??CA?>C@?<C@_8C@G C@@@C@@@C@@@C') ; yourself); yourself]
!

searchToolBarIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self searchToolBarIcon inspect
     ImageEditor openOnClass:self andSelector:#searchToolBarIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:#'Psiware::SystemManagement class searchToolBarIcon'
	ifAbsentPut:[(Depth24Image new) width: 22; height: 22; photometric:(#rgb); bitsPerSample:(#[8 8 8]); samplesPerPixel:(3); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4][>4][>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@;>#8/L#+!!:KS!!:KS/,'',;>''9@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2];>^)WH
NE:+KU*:J5&9NE6*_I#K4^S>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4][>RV3DLER"SWR6$K#0#;[.SGJ4L5"''UG_N4][>@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*K''\JT*,U6Z7:^S?>/C*;.3,6>C>RFF(KEZ"3-_-@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@&Z''HFTF &Z7">N#:7NK?7NK?6=W>!!Y''YH4N -+3T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%I>;FDV)#ZWU??''57NK?
7NK?:>_?\8WKFCN".K#T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1L;.A#V[O5")3=W;=/[4</W:1,??K$JVI4Z\7-''4@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7NK?-,[1E#:&C"ZZH3F U6_EU63FHS^XHS.K JOX7-''4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7NK?
,K_*O5ZTCRBLPU&0FCBHDB&RDR6RH$NI Y#I4][>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7NK?-;#%ND&KC">BYV.*4=;>7.+>-<K!!,K/!!7NK?
:^C;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7NK?/K3^PT%<CBI/NE>==O;8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@7NK? (J9GB1SZV>W:M3?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5MS&++3H6M/#@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7NK?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@') ; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@C@@@C@@@C@A C@G8C@O<C@_>C@_>C@_>C@_>C@_>C@?>CA?<CC?8CG8@CG0@CC @CA@@C@@@C@@@C@@@C@@@C') ; yourself); yourself]
!

warningSearchBarIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self warningSearchBarIcon inspect
     ImageEditor openOnClass:self andSelector:#warningSearchBarIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:#'Psiware::SystemManagement class warningSearchBarIcon'
	ifAbsentPut:[(Depth24Image new) width: 22; height: 19; photometric:(#rgb); bitsPerSample:(#[8 8 8]); samplesPerPixel:(3); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?:.+<Y"P??C\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@>_;?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@?]SZ)5]X.6!! -HM2??''*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?>39-7*B4H&G>[N+%%MJ>\#A@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@<+R?*U1&?=CN?>W^4HJ@+FY$?>+"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@?>G_)U!!^>Z^->,B><+"4?*^-%C8?;;Z+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@??#1-(E;.65+?<#H
?=_T?=GP?::65W-=(EQF?>WQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?\#D*VAY?;61<;"0;,C@6J^+;*"0>ZN$&CX)6(-:@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?>#+/7Q148E6?<"4<L&:W#(:G@@@392!!48^G9WM(%24_?=WN@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
??C?7Y&$.E5\?;V*=<:8??K_R3X5DP@@4+R49ZZ!!7VIZ/#85)%UR??G/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?=7.2&)6=IJQ?;..=]W@??7*PS$7E@,N
4<OC?>K^>(M=1S8;)$ID8Y6^@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;HNR4U%%<)&S?<^9??_(??;3REEN@P,J2<[C??K/?:R!!/C8?&R(0(T-N?>GZ@@@@
@@@@@@@@@@@@@@@@@@@@?<;H,31B3T9U2'')1?L3@?>3&=^7*XWE0@@<M7=;\??S3?=_U46-,#Q(!!$B,/18"A@@@@@@@@@@@@@@@@@@@@??G&1G!!*,S03)SP,
3()?>=WL??_:<>33[G:@D2T%;^/,??#8??K19Y6^&R(0!!QPX#S8:;K22@@@@@@@@@@@@@@@@<*RZ+5I@*$D+*T48<[N&?>C_7,+U??3?7N''/(J.-?/+;??W5
;.O!!?>G_3&]+ 0(O#B8.(U9X@@@@@@@@@@@@?<?Y/%MM.487%$P^7I)7?<&=?=+ <^W3;?C?YV]3JR .-*60=/W35.[#<>W"?:*+*3@3$R\)^R ''2)^T@@@@
?>K2;(ZO2DQ@-SP!!,5H/?<F!!?<V=?;3B?=_"?>7:)72EUBT+<,GD?>?,<M;Z>]GO?<#J8VM& P4P_A0^ C(:?>+''?:"+34%H13L/02("13T(13\,5$H>3S<=
1TMC0DQD/$IB/D@>.S4;-S,8,C(:,C 9-3X:(A4""@4R_1DT RH&/6%*?82D/S8503873C<85C<923H,23@+/RP\-"HX,"HW+"DX*"@V)10U)1(S)!!XU)AXU
(Q0_$1XZ#1X["A(]^QPX&34>?;&).&-Z/6]Y06MU1&AR/5UG15-N0EYF1&EO0&EN/&EP.6AN.%5N.5-M.5%P/UYQ.$)I.4)L0UQW/U-\+5YX5XFA') ; mask:((Depth1Image new) width: 22; height: 19; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@C G@G0C@O0C@O8C@_8C@?<C@?<CA?>CC??CC??CC??#G??#O??3O??3_??;????????????????') ; yourself); yourself]
! !

!InternationalLanguageTranslationEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#windowSpec
     Tools::InternationalLanguageTranslationEditor new openInterface:#windowSpec
     Tools::InternationalLanguageTranslationEditor open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'InternationalLanguageTranslationEditor'
         name: 'InternationalLanguageTranslationEditor'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 774 610)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             menu: menuToolBar
             textDefault: true
           )
          (VariableVerticalPanelSpec
             name: 'TranslationsVariableVerticalPanel'
             layout: (LayoutFrame 0 0 30 0 0 1 -32 1)
             component: 
            (SpecCollection
               collection: (
                (DataSetSpec
                   name: 'KeyStringAndLanguageSelectionTable'
                   model: selectedKeyRow
                   menu: keyStringAndLanguageSelectionTableMenu
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   dataList: keyStringAndLanguageSelectionTable
                   columnHolder: keyStringAndLanguageSelectionTableColumnDescriptionHolder
                   beDependentOfRows: true
                   columnAdaptor: yourself
                   postBuildCallback: postBuildDataSet:
                 )
                (VariableVerticalPanelSpec
                   name: 'VariableVerticalPanel1'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box1'
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Original String (Key):'
                               name: 'Label2'
                               layout: (LayoutFrame 0 0 -2 0 0 1 28 0)
                               translateLabel: true
                               adjust: left
                             )
                            (TextEditorSpec
                               name: 'OriginalText'
                               layout: (LayoutFrame 0 0 27 0 0 1 -2 1)
                               model: originalTextHolder
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               modifiedChannel: originalTextModifiedHolder
                               acceptCallBack: languageTextAccepted
                               hasKeyboardFocusInitially: false
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'Box3'
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Select Another Language as example:'
                               name: 'Label3'
                               layout: (LayoutFrame 0 0 -6 0 0 1 24 0)
                               translateLabel: true
                               adjust: left
                             )
                            (ComboBoxSpec
                               name: 'ComboBox1'
                               layout: (LayoutFrame 281 0 -2 0 406 0 18 0)
                               model: exampleLanguageSelectionHolder
                               immediateAccept: false
                               acceptOnLeave: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: false
                               comboList: shownLanguages
                               useIndex: false
                             )
                            (TextEditorSpec
                               name: 'ExampleLanguageText'
                               layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                               model: exampleLanguageTextHolder
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               isReadOnly: true
                               hasKeyboardFocusInitially: false
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'Box2'
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Translated String:'
                               name: 'Label1'
                               layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                               translateLabel: true
                               adjust: left
                             )
                            (TextEditorSpec
                               name: 'LanguageText'
                               layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                               model: languageTextHolder
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               acceptChannel: languageTextAcceptHolder
                               modifiedChannel: languageTextModifiedHolder
                               acceptCallBack: languageTextAccepted
                               hasKeyboardFocusInitially: false
                               postBuildCallback: languageEditorBuilt:
                             )
                            (ActionButtonSpec
                               label: 'Paste Previous'
                               name: 'pastePreviousTranslation'
                               layout: (LayoutOrigin 0 0.83085250338295003 0 0.034482758620689995)
                               translateLabel: true
                               model: pastePreviousTranslationInLanguageText
                               enableChannel: pastePreviousTranslationEnableHolder
                               disabledLogo: 'Paste Previous'
                             )
                            (ActionButtonSpec
                               label: 'Paste Original'
                               name: 'Button1'
                               layout: (LayoutOrigin -95 0.83085250338295003 0 0.034482758620689995)
                               translateLabel: true
                               model: pasteOriginalInLanguageText
                               enableChannel: pasteOriginalEnableHolder
                               disabledLogo: 'Paste Original'
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   handles: (Any 0.3333333333333301 0.66666666666667018 1.0)
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
             postBuildCallback: postBuildTranslationsPanel:
           )
          (ViewSpec
             name: 'SearchBox'
             layout: (LayoutFrame 0 0 -32 1 0 1 0 1)
             level: -1
             visibilityChannel: searchBoxVisible
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'closeSearchBarIcon'
                   name: 'closeSearchBarButton'
                   layout: (LayoutFrame 4 0 5 0 25 0 26 0)
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: closeSearchBar
                 )
                (LabelSpec
                   label: 'Search:'
                   name: 'SearchLabel'
                   layout: (LayoutFrame 30 0 5 0 100 0 27 0)
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'SearchEntryField'
                   layout: (LayoutFrame 100 0 5 0 257 0 27 0)
                   model: searchTextHolder
                   immediateAccept: true
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   modifiedChannel: searchTextModifiedHolder
                   acceptOnPointerLeave: false
                   postBuildCallback: postBuildSearchTextView:
                 )
                (ActionButtonSpec
                   label: 'searchNextIcon'
                   name: 'SearchNextButton'
                   layout: (LayoutFrame 264 0 5 0 285 0 26 0)
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: searchNextText
                 )
                (ActionButtonSpec
                   label: 'searchPreviousIcon'
                   name: 'searchPreviousButton'
                   layout: (LayoutFrame 292 0 5 0 313 0 26 0)
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: searchPreviousText
                 )
                (CheckBoxSpec
                   label: 'Ignore case'
                   name: 'IgnoreCaseCheckBox'
                   layout: (LayoutFrame 322 0 5 0 518 0 27 0)
                   model: ignoreCaseHolder
                   translateLabel: true
                 )
                (LabelSpec
                   label: 'SearchBarImageInfoLabel'
                   name: 'SearchBarImageInfoLabel'
                   layout: (LayoutFrame 524 0 5 0 548 0 27 0)
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   labelChannel: searchBarImageInfoLabelHolder
                 )
                (LabelSpec
                   label: 'SearchBarInfoLabel'
                   name: 'SearchBarInfoLabel'
                   layout: (LayoutFrame 551 0 5 0 829 0 27 0)
                   translateLabel: true
                   labelChannel: searchBarInfoLabelHolder
                   adjust: left
                 )
                )
              
             )
             postBuildCallback: postBuildSearchBoxView:
           )
          )
        
       )
     )
! !

!InternationalLanguageTranslationEditor class methodsFor:'menu specs'!

keyStringAndLanguageSelectionTableMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#keyStringAndLanguageSelectionTableMenu
     (Menu new fromLiteralArrayEncoding:(Tools::InternationalLanguageTranslationEditor keyStringAndLanguageSelectionTableMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'Browse Methods Containing this String'
            itemValue: browseReferringMethods
            translateLabel: true
          )
         (MenuItem
            label: '-'
            isVisible: #false
          )
         (MenuItem
            label: 'Set Current NameSpace...'
            itemValue: changeLastNameSpace
            translateLabel: true
          )
         (MenuItem
            label: 'Search String in Current NameSpace'
            itemValue: searchStringInLastNameSpace
            translateLabel: true
          )
         (MenuItem
            label: '-'
            isVisible: #false
          )
         (MenuItem
            label: 'Set Current Package...'
            itemValue: changeLastPackage
            translateLabel: true
            isVisible: #false
          )
         (MenuItem
            label: 'Search String in Current Package'
            itemValue: searchStringInLastPackage
            translateLabel: true
            isVisible: #false
          )
         )
        nil
        nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::InternationalLanguageTranslationEditor mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'New'
                  itemValue: menuNew
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Open Resources for Package or Project...'
                  itemValue: menuOpenByPackage
                )
               (MenuItem
                  label: 'Open Resource File...'
                  itemValue: menuOpen
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Save All Resource Files'
                  itemValue: menuSaveAll
                )
               (MenuItem
                  label: 'Save Resource File'
                  itemValue: menuSave
                )
               (MenuItem
                  label: 'Save Resource File As...'
                  itemValue: menuSaveAs
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Import existing translations from file...'
                  itemValue: importExistingTranslationsFromFile
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Set Current NameSpace'
                  itemValue: changeLastNameSpace
                )
               (MenuItem
                  label: 'Set Current Package'
                  itemValue: changeLastPackage
                  isVisible: #false
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'View'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Show Missing Translations Only'
                  indication: showMissingTranslationsOnly
                )
               (MenuItem
                  label: 'Show Search Box'
                  indication: searchBoxVisible
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Shown Languages'
                  submenuChannel: shownLanguagesMenu
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Languages'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Add Language...'
                  itemValue: addLanguage
                )
               (MenuItem
                  label: 'Remove Language...'
                  itemValue: removeLanguage
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Translations'
            submenuChannel: translationsMenuSpec
          )
         (MenuItem
            label: 'Preferences'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Auto Accept Changes'
                  indication: autoAcceptHolder
                )
               (MenuItem
                  label: 'Search For Similar Translations'
                  indication: searchForSimilarTranslationEnableHolder
                )
               (MenuItem
                  label: 'Always Write UTF8'
                  indication: alwaysWriteUTF8Holder
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
!

menuItemsEditLanguage
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(Tools::InternationalLanguageTranslationEditor menu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: pastePreviousTranslationEnableHolder
	    label: 'Paste Previous Translation'
	    itemValue: pastePreviousTranslationInLanguageText
	    nameKey: pastePreviousTranslationInLanguageText
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
!

menuToolBar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#menuToolBar
     (Menu new fromLiteralArrayEncoding:(Tools::InternationalLanguageTranslationEditor menuToolBar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Save'
            itemValue: menuSave
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary saveImageIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Add Translation'
            itemValue: addTranslation
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary newRowIcon)
          )
         (MenuItem
            label: 'Remove Translation'
            itemValue: removeTranslation
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary removeRowIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: browseReferringMethods
            label: 'Browse'
            itemValue: browseReferringMethods
            labelImage: (ResourceRetriever ToolbarIconLibrary systemBrowserIcon)
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            label: 'Stop Application'
            itemValue: stopApplication
            isButton: true
            isVisible: stopApplicationIconVisibleHolder
            labelImage: (ResourceRetriever XPToolbarIconLibrary stop16x16Icon)
          )
         (MenuItem
            activeHelpKey: searchBox
            label: 'Search'
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            indication: searchBoxVisible
            shortcutKey: Ctrlf
            labelImage: (ResourceRetriever #'Tools::InternationalLanguageTranslationEditor' searchToolBarIcon)
          )
         )
        nil
        nil
      )
!

translationsMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#translationsMenuSpec
     (Menu new fromLiteralArrayEncoding:(Tools::InternationalLanguageTranslationEditor translationsMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add Translation...'
            itemValue: addTranslation
          )
         (MenuItem
            label: 'Remove Translation...'
            itemValue: removeTranslation
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Extract from Package...'
            itemValue: extractTranslationsFromProject
          )
         (MenuItem
            label: 'Extract from Class...'
            itemValue: extractTranslationsFromClass
          )
         (MenuItem
            label: 'Extract from NameSpace...'
            itemValue: extractTranslationsFromNameSpace
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Run Application and Collect Translations...'
            itemValue: runApplicationAndCollectTranslations
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Generate Missing Translations'
            itemValue: generateMissingTranslations
          )
         (MenuItem
            label: 'Generate Missing Translations Slice'
            submenuChannel: menuSliceTranslateGenerate
            isMenuSlice: true
          )
         )
        nil
        nil
      )
! !

!InternationalLanguageTranslationEditor class methodsFor:'startup'!

openOnFile:aFilename
    |fn|

    fn := aFilename asFilename.

    ^ self new
        allButOpen;
        readResourceFile:fn asLanguage:fn withoutSuffix baseName;
        openWindow;
        yourself.
!

openOnPackage:aPackageId
    ^ self new
        allButOpen;
        readResourceFileForPackage:aPackageId;
        openWindow;
        yourself.
! !

!InternationalLanguageTranslationEditor class methodsFor:'tableColumns specs'!

keyTableColumn
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#keyTableColumn
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
	 label: 'Key'
	 labelButtonType: Button
	 minWidth: 50
	 model: keyStringInRow:
       )
      )
!

languageTableColumn
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::InternationalLanguageTranslationEditor andSelector:#languageTableColumn
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
	 label: lang
	 labelButtonType: Button
	 minWidth: 50
	 editorType: None
	 model: columnInRow:at:
	 backgroundSelector: getBackgroundForRow:rowNr:col:
       )
      )
! !

!InternationalLanguageTranslationEditor methodsFor:'accessing'!

currentSelectionIndex

    ^ self selectedKeyRow value

    "Created: / 16-06-2007 / 09:04:11 / Administrador"
    "Modified: / 19-06-2007 / 17:28:38 / Administrador"
!

exists: anObject

    ^self objectsList includes: anObject

    "Created: / 19-06-2007 / 16:42:22 / Administrador"
!

indexOf: anObject

    ^self objectsList indexOf: anObject

    "Created: / 19-06-2007 / 16:39:44 / Administrador"
!

newLanguageText
"/   languageEditor accept
    ^self languageTextHolder value isEmptyOrNil
        ifTrue:['']
        ifFalse:[self languageTextHolder value asCollectionOfLines first.]
!

objectsList

    ^ keyStringsToLanguageMappings
!

selectListIndex: rowIndex
"/    |selection list|
"/    list := self objectsList.
"/    list isEmpty ifTrue:[^self].
"/    selection := list at:rowIndex ifAbsent:nil.
    self selectedKeyRow value: rowIndex.

    "Created: / 16-06-2007 / 09:06:46 / Administrador"
    "Modified: / 22-06-2007 / 13:45:54 / Administrador"
!

selectedKey
   "Returns the current selected key if there is one row seleted. Otherwise, returns nil"
     |rowSelectionIndex |

    keyStringsToLanguageMappings isNil ifTrue:[^nil].
    self selectedKeyRow value isNil ifTrue:[^nil].
    rowSelectionIndex := self selectedKeyRow value.
    rowSelectionIndex == 0 ifTrue:[^nil].
    ^ keyStringsToLanguageMappings keyAt:rowSelectionIndex.
!

tableView

    ^dataSetView scrolledView

    "Created: / 15-06-2007 / 18:59:51 / Administrador"
! !

!InternationalLanguageTranslationEditor methodsFor:'additionalFuncionalities'!

searchForSimilarTranslation
    "Looks for a quite similar translation for the key and display a dialog with available options"
    |similarTranslationsAssociations selectedTranslation key|

    self shouldSearchForSimilarTranslation ifFalse:[^self].

    key := self selectedKey.
    key isNil ifTrue:[^ self.].
    similarTranslationsAssociations := keyStringsToLanguageMappings searchForSimilarTranslation: key in: self currentLanguage.
    similarTranslationsAssociations isEmpty ifTrue:[^self].

    similarTranslationsAssociations := similarTranslationsAssociations associations inject: OrderedCollection new into:[:collection :association |
	collection detect:[:selectedAssociation |
	    selectedAssociation value sameAs: association value] ifNone:[collection add: association].
	collection].
    selectedTranslation := Dialog
	choose:'Choose one if you consider it´s usefull to translate:
    ',
	'<', key, '>  ', (self currentExampleLanguageText ifNil:[''])
	fromList: (similarTranslationsAssociations collect:[:each |  '<', each key, '>  ', each value])
	values: (similarTranslationsAssociations collect:[:each | each value])
	lines:10
	cancel: nil.

    selectedTranslation notNil ifTrue:[self languageTextHolderValue: selectedTranslation].
! !

!InternationalLanguageTranslationEditor methodsFor:'aspects'!

alwaysWriteUTF8Holder
    alwaysWriteUTF8Holder isNil ifTrue:[alwaysWriteUTF8Holder := true asValue].
    ^ alwaysWriteUTF8Holder
!

autoAcceptHolder
    autoAcceptHolder isNil ifTrue:[autoAcceptHolder := true asValue].
    ^ autoAcceptHolder
!

exampleLanguageSelectionHolder
    exampleLanguageSelectionHolder isNil ifTrue:[
	exampleLanguageSelectionHolder := self exampleLanguageByDefault asValue.
	exampleLanguageSelectionHolder addDependent:self.
    ].
    ^ exampleLanguageSelectionHolder
!

exampleLanguageTextHolder
    exampleLanguageTextHolder isNil ifTrue:[
	exampleLanguageTextHolder := '' asValue.
    ].
    ^ exampleLanguageTextHolder.
!

ignoreCaseHolder

    ignoreCaseHolder isNil ifTrue:[
	ignoreCaseHolder := false asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       ignoreCaseHolder addDependent:self.
	ignoreCaseHolder onChangeSend:#ignoreCaseHolderChanged to:self.

    ].
    ^ ignoreCaseHolder.

    "Created: / 16-06-2007 / 06:45:04 / Administrador"
    "Modified: / 16-06-2007 / 19:32:15 / Administrador"
!

keyStringAndLanguageSelectionTable
    keyStringsToLanguageMappings isNil ifTrue:[
	keyStringsToLanguageMappings := KeyStringsToLanguageMappings new.
    ].
    ^ keyStringsToLanguageMappings.
!

keyStringAndLanguageSelectionTableColumnDescriptionHolder
    keyStringAndLanguageSelectionTableColumnDescriptionHolder isNil ifTrue:[
	keyStringAndLanguageSelectionTableColumnDescriptionHolder := ValueHolder new.
	keyStringAndLanguageSelectionTableColumnDescriptionHolder value:(self keyStringAndLanguageSelectionTableColumnDescription).
    ].
    ^ keyStringAndLanguageSelectionTableColumnDescriptionHolder.
!

languageAtCol:colNr
    ^ shownLanguages at:colNr-1.
!

languageShownHolderFor:lang
    |holder|

    languageShownHolders isNil ifTrue:[
	languageShownHolders := Dictionary new
    ].
    holder := languageShownHolders
		at:lang
		ifAbsentPut:[
		    |h|

		    h := true asValue.
		    h onChangeEvaluate:[
			h value ifTrue:[
			   self enableLanguageDisplayFor:lang
			] ifFalse:[
			   self disableLanguageDisplayFor:lang
			].
		    ].
		    h
		].
    ^ holder.
!

languageTextAcceptHolder
    languageTextAcceptHolder isNil ifTrue:[
	languageTextAcceptHolder := false asValue.
    ].
    ^ languageTextAcceptHolder.
!

languageTextHolder
    languageTextHolder isNil ifTrue:[
	languageTextHolder := '' asValue.
    ].
    ^ languageTextHolder.
!

languageTextModifiedHolder
    languageTextModifiedHolder isNil ifTrue:[
	languageTextModifiedHolder := false asValue.
    ].
    ^ languageTextModifiedHolder.
!

languagesList
    languagesList isNil ifTrue:[
	languagesList := List withAll:(self keyStringAndLanguageSelectionTable languages).
    ].
    ^ languagesList.
!

originalTextHolder
    originalTextHolder isNil ifTrue:[
	originalTextHolder := '' asValue.
    ].
    ^ originalTextHolder.
!

originalTextModifiedHolder
    originalTextModifiedHolder isNil ifTrue:[
	originalTextModifiedHolder := false asValue.
    ].
    ^ originalTextModifiedHolder.
!

pasteOriginalEnableHolder
   pasteOriginalEnableHolder isNil ifTrue:[pasteOriginalEnableHolder := false asValue].
    ^ pasteOriginalEnableHolder
!

pastePreviousTranslationEnableHolder
   pastePreviousTranslationEnableHolder isNil ifTrue:[pastePreviousTranslationEnableHolder := false asValue].
    ^ pastePreviousTranslationEnableHolder
!

searchBarImageInfoLabelHolder

    searchBarImageInfoLabelHolder isNil ifTrue:[
	searchBarImageInfoLabelHolder := nil asValue .
    ].
    ^ searchBarImageInfoLabelHolder.

    "Created: / 16-06-2007 / 10:06:28 / Administrador"
!

searchBarInfoLabelHolder

    searchBarInfoLabelHolder isNil ifTrue:[
	searchBarInfoLabelHolder := '' asValue .
    ].
    ^ searchBarInfoLabelHolder.

    "Created: / 16-06-2007 / 06:20:49 / Administrador"
!

searchBoxVisible

    searchBoxVisible isNil ifTrue:[
        searchBoxVisible := false asValue.
        searchBoxVisible 
            onChangeEvaluate:[ 
                self updateToolVisibility.
                searchBoxVisible value ifTrue:[
                    searchTextView takeFocus.
                ].
            ].
    ].
    ^ searchBoxVisible.

    "Created: / 15-06-2007 / 18:15:52 / Administrador"
!

searchForSimilarTranslationEnableHolder
   searchForSimilarTranslationEnableHolder isNil
	ifTrue:[searchForSimilarTranslationEnableHolder := true asValue].
    ^ searchForSimilarTranslationEnableHolder
!

searchTextHolder

    searchTextHolder isNil ifTrue:[
	searchTextHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       userSelectedHolder addDependent:self.
"/       userSelectedHolder onChangeSend:#searchTextHolderChanged to:self.
    ].
    ^ searchTextHolder.

    "Created: / 15-06-2007 / 18:06:08 / Administrador"
!

searchTextModifiedHolder

    searchTextModifiedHolder isNil ifTrue:[
	searchTextModifiedHolder := false asValue .
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       searchTextModifiedHolder addDependent:self.
       searchTextModifiedHolder onChangeSend:#searchTextModifiedHolderChanged to:self.
    ].
    ^ searchTextModifiedHolder.

    "Created: / 15-06-2007 / 18:07:19 / Administrador"
!

selectedKeyRow
    selectedKeyRow isNil ifTrue:[
	selectedKeyRow := ValueHolder new.
	selectedKeyRow onChangeSend:#selectionChanged to:self.
    ].
    ^ selectedKeyRow.
!

showMissingTranslationsOnly
    showMissingTranslationsOnly isNil ifTrue:[
	showMissingTranslationsOnly := false asValue.
	showMissingTranslationsOnly onChangeSend:#showMissingTranslationsOnlyChanged to:self.
    ].
    ^ showMissingTranslationsOnly.
!

shownLanguages
    shownLanguages isNil ifTrue:[
	shownLanguages := List new.
	shownLanguages addAll:(self languagesList).
	shownLanguages onChangeSend:#shownLanguagesChanged to:self.
    ].
    ^ shownLanguages.
!

stopApplicationIconVisibleHolder
    stopApplicationIconVisibleHolder isNil ifTrue:[
	stopApplicationIconVisibleHolder := false asValue.
    ].
    ^ stopApplicationIconVisibleHolder.
! !

!InternationalLanguageTranslationEditor methodsFor:'change & update'!

languageTextHolderValue: aString

    self languageTextHolder value: aString.
    self languageTextModifiedHolder value:true.
!

update:something with:aParameter from:changedObject
    changedObject == shownLanguages ifTrue:[
	 self shownLanguagesChanged.
	 ^ self.
    ].
    changedObject == languageTextAcceptHolder ifTrue:[
	 self updateLanguageTextModification.
	 ^ self.
    ].
    changedObject == exampleLanguageSelectionHolder ifTrue:[
	self updateExampleLanguageText.
	^ self.
    ].
    changedObject == showMissingTranslationsOnly ifTrue:[
	self showMissingTranslationsOnlyChanged.
	^ self.
    ].
!

updateCopyPreviousTranslationButtonEnabled

     self pastePreviousTranslationEnableHolder value: self shouldCopyPreviousTranslationButtonBeEnabled
!

updateExampleLanguageText

    self selectedKeyRow value isNil ifTrue:[^ self].
    self exampleLanguageTextHolder value:self currentExampleLanguageText
!

updateKeyStringsToLanguageMappings

      keyStringsToLanguageMappings
	at:lastSelectedKey
	language:lastLanguage
	put: self newLanguageText.
!

updateLanguageAndKeySelection

    self originalTextHolder value: self selectedKey.
    self languageTextHolder value: (self languageTextFromSelectedKeyFor: self currentLanguage).
    lastLanguage := self currentLanguage.
    lastSelectedKey := self selectedKey.
!

updateLanguageTextModification
     self languageTextModifiedHolder value ifTrue:[
	(self autoAccept or:[Dialog confirm:'Accept changed translation ?']) ifTrue:[
	    self languageTextModifiedHolder value:false.
	    self languageTextHolder value:languageEditor contents.
	    lastLanguage notNil ifTrue:[self updateKeyStringsToLanguageMappings.]
	]
    ].
!

updateOriginalTextModification

    |answer|

        self originalTextModifiedHolder value ifTrue:[
            answer := OptionBox
                          request:'Accept changed original text (key) ?'
                          label:'Original text (key) changed'
                          image:(WarningBox iconBitmap)
                          buttonLabels:#('Cancel' 'Accept' 'Accept As New')
                          values:#(nil #accept #acceptAsNew)
                          default:#acceptAsNew.

            answer isNil ifTrue:[^ self originalTextModifiedHolder value:false. ].
            answer == #accept ifTrue:[
    self shouldImplement.        ].
            answer == #acceptAsNew ifTrue:[
    self shouldImplement.        ].
        ].
!

updatePasteOriginalButtonEnabled

     self pasteOriginalEnableHolder value: self shouldPasteOriginalButtonBeEnabled
! !

!InternationalLanguageTranslationEditor methodsFor:'dialogs'!

requestEncoderDialog

   |box val characterCollection|

    val := '' asValue.
    box := Dialog new.
    (box addTextLabel:'Select or write the encoder') adjust:#left.
    box addVerticalSpace.
    characterCollection := CharacterEncoder supportedExternalEncodings
	inject: OrderedCollection new
	into:[:collection :each |
	    collection add: each first;
			yourself].
    (box addComboBoxOn:val) list: characterCollection.
    box addOkButton.
    box open.
    ^val value
!

requestEncoderStringFor: lang
  "Returns an encoder string and updates the language's info"
    |encoderString encoder|
    encoderString := self requestEncoderDialog.
    encoderString notEmpty ifTrue:[
	encoder := CharacterEncoder encoderFor: encoderString ifAbsent:nil.
	encoder notNil ifTrue:[keyStringsToLanguageMappings atLanguage: lang putEncoder: encoder.].
    ].
    ^encoderString
!

requestFilename

    |aFilename|

    aFilename := Dialog
	requestFileName:(resources string:'Name of resource file:')
	default:nil
	pattern:'*.rs'.

    aFilename isEmptyOrNil ifTrue:[^ nil ].
    ^aFilename asFilename
!

requestFilenameFor: lang
  "Returns a filename to save the language resource and updates the language's info"
    |aFilename|

    aFilename := Dialog
	requestFileName:(resources string:'Name of resource file to save %1:' with:lang asString)
	default:nil
	pattern:'*.rs'.

    aFilename isEmptyOrNil ifTrue:[^ nil ].
    keyStringsToLanguageMappings atLanguage: lang putFilename: aFilename.
    ^aFilename asFilename
!

requestLanguage
    ^ Dialog
	choose:(resources string:'For which language ?')
	fromList:languagesList
	lines:10.
!

requestLanguageToSave
    ^ Dialog
	choose:'Which language do you want to save?'
	fromList:languagesList
	lines:10
!

requestPackage
    |package allProjects projectsWithResources|

    allProjects := Smalltalk allPackageIDs.
    projectsWithResources := allProjects
                                select:[:pID |
                                    |dir|
                                    dir := Smalltalk projectDirectoryForPackage:pID.
                                    dir notNil and:[
                                    (dir asFilename construct:'resources') exists]
                                ].

    package := Dialog
        requestProject:(resources string:'Name of Package:')
        from:projectsWithResources
        initialAnswer:LastProject
        suggestions:nil.

    package isEmptyOrNil ifTrue:[^ nil ].
    LastProject := package.
    ^ package
! !

!InternationalLanguageTranslationEditor methodsFor:'images'!

restartSearchBarIcon

    ^ self class restartSearchBarIcon
!

warningSearchBarIcon

    ^ self class warningSearchBarIcon
! !

!InternationalLanguageTranslationEditor methodsFor:'initialization & release'!

closeRequest
    "asks for permission before closing"

    self hasUnsavedChanges ifTrue:[
	(Dialog
	    confirm:(resources string:'Close without saving ?')
	    default:false) ifFalse:[
	    ^ self
	]
    ].

    super closeRequest
!

initialize
    modified := false.
    inSingleFileMode := false.
    methodsUsingKey := Dictionary new.
    super initialize
!

languageEditorBuilt:aView
    languageEditor := aView.
!

postBuildDataSet:aView
    dataSetView := aView.
    aView selectedColIndexHolder onChangeSend:#selectionChanged to:self.
! !

!InternationalLanguageTranslationEditor methodsFor:'initialize'!

postBuildSearchBoxView: aBoxView

    searchBoxView := aBoxView

    "Created: / 15-06-2007 / 18:02:38 / Administrador"
!

postBuildSearchTextView: anEditFieldView

    searchTextView := anEditFieldView

    "Created: / 15-06-2007 / 18:17:15 / Administrador"
!

postBuildTranslationsPanel: aPanel

    translationsPanel := aPanel
!

postBuildWith:aBuilder

    super postBuildWith:aBuilder.
    self updateToolVisibility.
! !

!InternationalLanguageTranslationEditor methodsFor:'menu actions'!

addLanguage
    |lang|

    lang := Dialog request:(resources string:'New language (ISO symbol):').
    lang isEmptyOrNil ifTrue:[^ self].
    self addLanguage:lang
!

addLanguage:langArg
    |lang|

    lang := langArg asSymbol.
    (keyStringsToLanguageMappings includesLanguage:lang) ifTrue:[^ self ].

    keyStringsToLanguageMappings addLanguage:lang.
    self languagesList add:lang.
    self shownLanguages add:lang.
    modified := true.
!

addTranslation
    |key index|

    key := Dialog request:'New Key:'.
    key isEmpty ifTrue:[^self].
    (self includesKey:key) ifFalse:[
	keyStringsToLanguageMappings addKey:key.
	modified := true.
    ].
   index := keyStringsToLanguageMappings indexOfKey:key.
   self selectedKeyRow value:index
!

browseReferringMethods
    |selectedKey methods browser|

    selectedKey := self selectedKey.
    selectedKey isNil ifTrue:[^ Dialog information: 'No selected key'].

    methods := methodsUsingKey at:selectedKey ifAbsent:nil.
    methods isEmptyOrNil ifTrue:[
        Dialog information:(resources stringWithCRs:'oops - no method remembered.\Please rerun the extract from XXX menu operation').
        ^ self.
    ].    
    browser := UserPreferences systemBrowserClass browseMethods:methods.
    browser autoSearch:selectedKey ignoreCase:true.
!

changeLastNameSpace

    |nameSpace defaultNameSpace|

    lastNameSpace notNil ifTrue:[defaultNameSpace := lastNameSpace name].
    nameSpace := Dialog requestNameSpace:'NameSpace:' title:'Search String in Name Space:' initialAnswer:defaultNameSpace.
    nameSpace isNil ifTrue:[^self].
    nameSpace := Smalltalk at:nameSpace asSymbol.
    nameSpace isNil ifTrue:[
	^Dialog information:(resources string:'No such nameSpace exists.')
    ].
    lastNameSpace := nameSpace.
!

changeLastPackage

    |package defaultPackage|

    lastPackage notNil ifTrue:[defaultPackage := lastPackage].
    package := Dialog
	    requestProject:'Package:'
	    initialAnswer:defaultPackage
	    suggestions:#('foo' 'bar' 'baz').
    package isNil ifTrue:[
	^ self "/ Dialog information:(resources string:'No such package exists.')
    ].
    lastPackage := package.
!

extractTranslationsFromClass
    |aClass newTranslations|

    aClass := Dialog
		requestClass:'Class to extract translations from:'
		okLabel:'OK'
		initialAnswer:(lastExtractedClass ? LastExtractedClass).
    aClass isNil ifTrue:[^ self ].

    lastExtractedClass := LastExtractedClass := aClass.

    newTranslations := self extractTranslationsFromClass:aClass.
    self addAllTranslations:newTranslations.
!

extractTranslationsFromNameSpace

    |newTranslations|

    self changeLastNameSpace.
    lastNameSpace isNil ifTrue:[^self.].
    newTranslations := OrderedCollection new.
    lastNameSpace allClassesDo:[:eachClass |
	newTranslations addAll:( self extractTranslationsFromClass:eachClass theNonMetaclass).
    ].
    self addAllTranslations:newTranslations.
!

extractTranslationsFromProject
    |projectID newTranslations|

    projectID := Dialog requestProject:(resources string:'Package to extract translations from:') initialAnswer:(lastExtractedProject ? LastExtractedProject) suggestions:(lastExtractedProject ? LastExtractedProject).
    projectID notNil ifTrue:[
        projectID := projectID withoutSeparators asSymbol.
    ].
    projectID isEmptyOrNil ifTrue:[^ self ].

    lastExtractedProject := LastExtractedProject := projectID.

    newTranslations := Set new.
    self withWaitCursorDo:[
        Smalltalk allClassesDo:[:eachClass |
            eachClass theNonMetaclass instAndClassMethodsDo:[:eachMethod |
                eachMethod package == projectID ifTrue:[ 
                    newTranslations addAll:( self extractTranslationsFromMethod:eachMethod ).
                ]
            ].
        ].

        self addAllTranslations:newTranslations.
    ].
    
    "Modified: / 19-02-2015 / 11:44:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateMissingTranslations: keys for: languages using: translator    
    keys do:[:string |
        languages do:[:lang | 
            | translation |

            translation := keyStringsToLanguageMappings at:string language:lang.
            translation isNil ifTrue:[ 
                translation := translator value: lang value: string.
                translation notNil ifTrue:[ 
                    keyStringsToLanguageMappings at: string language: lang put: translation.  
                ].
            ].
        ].
    ].

    "Created: / 19-02-2015 / 12:31:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateMissingTranslationsFor: languages
    self 
        generateMissingTranslations: keyStringsToLanguageMappings keys
                                for: languages
                              using: [ :lang :string | '**%1** %2' bindWith: lang asUppercase with: string ]

    "Created: / 19-02-2015 / 12:39:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateMissingTranslationsForAll
    self generateMissingTranslationsFor: keyStringsToLanguageMappings languages

    "Created: / 19-02-2015 / 12:40:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

importExistingTranslationsFromFile
    self information:'The import function is not available in this release'.
!

inspectCanvasMissingStrings

    |spec nameSpace missingStrings|

    missingStrings := OrderedCollection new.
    nameSpace := Dialog requestNameSpace:'NameSpace:' title:'Specify NameSpace to look for missing strings' initialAnswer:nil.
    nameSpace := Smalltalk at:nameSpace asSymbol.
    nameSpace isNil ifTrue:[
	^Dialog information:(resources string:'No such nameSpace exists.?')
    ].

    nameSpace allClassesDo:[:cls |
	cls theMetaclass methodsDo:[:m |
	    m hasResource ifTrue:[
		(m resources includesKey:#canvas) ifTrue:[
		    spec := (cls perform:m selector) decodeAsLiteralArray.
		    spec do:[:eachComponent |
			eachComponent translationKeysDo:[:k |
			    (self includesKey: k) ifFalse:[
				missingStrings add: k.
				Transcript showCR: k storeString, '                         ', m printString]]
		    ]
		]
	    ]
	]
    ].
    missingStrings asSet inspect
!

menuNew
    modified ifTrue:[
	(Dialog
	    confirm:(resources stringWithCRs:'Modified translations have not been changed.\\Create new translations set anyway ?')
	    default:false) ifFalse:[^ self].
    ].

    keyStringsToLanguageMappings initialize.
    keyStringsToLanguageMappings changed.

    self languagesList contents:self keyStringAndLanguageSelectionTable languages.
    self shownLanguages contents:self keyStringAndLanguageSelectionTable languages.
    modified := false.
!

menuOpen
    |aFilename|

    self withWaitCursorDo:[
	aFilename := self requestFilename.
	aFilename isNil ifTrue:[^ self ].
	self readResourceFile:aFilename.
    ]
!

menuOpenByPackage
    |package|

    self withWaitCursorDo:[
	package := self requestPackage.
	package isNil ifTrue:[^ self ].
	self readResourceFileForPackage:package.
    ]
!

menuSave
"Saves the language selected in the fileName from where the language resource was obtained."
    |lang|

    lang := self requestLanguageToSave.
    lang isNil ifTrue:[^ self].
    self saveLanguage: lang
!

menuSaveAll
"Saves all the languages in the fileName from where the language resource was obtained."
    keyStringsToLanguageMappings languagesInUse do:[:each | self saveLanguage: each].
!

menuSaveAs
"Saves the language selected in the specified fileName."
     |lang aFilename|

    lang := self requestLanguageToSave.
    lang isNil ifTrue:[^ self].
    aFilename := self requestFilenameFor:lang.
    aFilename isNil ifTrue:[^ self].
    self saveResourceFile:aFilename for:lang asSymbol
!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'tools/languageEditor/TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
!

readResourceFile:aFilename
    |lang|

    lang := self requestLanguage.
    lang isNil ifTrue:[^ self ].

    self readResourceFile:aFilename asLanguage:lang asSymbol
!

readResourceFileForPackage:aPackage
    |allLanguages lang packageDir resourceDir langFile|

    packageDir := Smalltalk packageDirectoryForPackageId:aPackage.
    resourceDir := packageDir asFilename construct:'resources'.

    allLanguages := Set new.
    resourceDir directoryContentsAsFilenamesDo:[:eachFile |
	eachFile suffix = 'rs' ifTrue:[
	    (('##.rs' match:eachFile baseName)
	    or:[('##-##.rs' match:eachFile baseName)]) ifTrue:[
		allLanguages add:(eachFile withoutSuffix baseName)
	    ].
	].
    ].

    allLanguages addAll:languagesList.
    allLanguages := allLanguages asSortedCollection.

    lang := Dialog
	choose:(resources string:'For which language ?')
	fromList:allLanguages
	values:allLanguages
	buttons:(resources array:#('All'))
	values:#(all)
	lines:10
	cancel:nil.

    lang isNil ifTrue:[^ self ].

    langFile := resourceDir construct:lang,'.rs'.

    lang == #all ifTrue:[
	allLanguages do:[:lang |
	    self addLanguage:lang.
	    self readResourceFile:(resourceDir construct:lang,'.rs') asLanguage:lang.
	].
    ] ifFalse:[
	self readResourceFile:langFile asLanguage:lang asSymbol
    ].
!

removeLanguage
    |languagesToRemove|

    languagesToRemove := Dialog chooseMultiple:'Which language(s) do you want to remove?' fromList:languagesList lines:10.
    languagesToRemove isEmptyOrNil ifTrue:[^ self ].
    (Dialog confirm: 'Are you sure to remove the languages: ', languagesToRemove printString) ifTrue:[
          self languagesList removeAll:languagesToRemove.
          self shownLanguages removeAll:languagesToRemove.
    ].
!

removeTranslation
    |rowSelectionIndex selectedKey|

    rowSelectionIndex := self selectedKeyRow value.
    rowSelectionIndex isNil ifTrue:[^self].
    rowSelectionIndex ~~ 0 ifTrue:[
	selectedKey := keyStringsToLanguageMappings keyAt:rowSelectionIndex ifAbsent:nil.
	selectedKey isNil ifTrue:[^self].
	(Dialog confirm:(resources string:'Really remove key %1' with:selectedKey)) ifTrue:[
	    keyStringsToLanguageMappings removeKey:selectedKey.
	].
    ].
!

runApplicationAndCollectTranslations
    |applicationClass newTranslations pseudoPack app startSelector|

    monitoredApplication notNil ifTrue:[
        monitoredApplication terminate.
        [monitoredApplication notNil] whileTrue:[
            Delay waitForSeconds:0.1
        ].
    ].

    applicationClass := Dialog
                requestClass:'Application class to start and collect translations from:'
                okLabel:'OK'
                initialAnswer:(lastExtractedApplicationClass ? LastExtractedApplicationClass ).
    applicationClass isNil ifTrue:[^ self ].
    applicationClass isNameSpace ifTrue:[
        Dialog warn:'Entered class is a NameSpace'.
        ^ self.
    ].

    applicationClass isVisualStartable ifTrue:[
        startSelector := #open
    ] ifFalse:[
        startSelector := Dialog
                    request:'Entered class seems to be no application class. Ok to start using selector:'
                    initialAnswer:((applicationClass respondsTo:#'start')
                                        ifTrue:#'start'
                                        ifFalse:#'new')
                    okLabel:'START'
                    title:'Start Application'.
        startSelector isNil ifTrue:[
            ^ self
        ].
        startSelector := startSelector asSymbol.
    ].

    lastExtractedApplicationClass := LastExtractedApplicationClass := applicationClass.

    newTranslations := Set new.

    pseudoPack := AccessCollectingPseudoResourcePack new.
    pseudoPack realResourcePack:(applicationClass classResources).
    pseudoPack watchingTranslationEditor:self.

    self stopApplicationIconVisibleHolder value:true.

    monitoredApplication := 
        [
            [
                app := applicationClass new.
                app resources:pseudoPack.
                
                app perform:startSelector.
                app window waitUntilVisible.
                app window waitUntilClosed.
            ] ensure:[
                app closeRequest.
                self stopApplicationIconVisibleHolder value:false.
                monitoredApplication := nil.
            ].
        ] fork.
!

searchStringInLastNameSpace

    |selectedKey browser lastSearchPatterns|

    selectedKey := self selectedKey.
    selectedKey isNil ifTrue:[^Dialog information: 'No selected key'].
    browser := NewSystemBrowser new "open".
    browser allButOpen.
    lastSearchPatterns := browser lastSearchPatterns.
    (lastSearchPatterns notNil and:[lastSearchPatterns first ~= selectedKey]) ifTrue:[
	browser lastSearchPatterns addFirst: selectedKey
    ].
    SearchDialog lastStringSearchArea: #currentNameSpace.
    lastNameSpace isNil ifTrue:[
	self changeLastNameSpace.
    ].
    lastNameSpace notNil ifTrue:[
"/        browser navigationState selectedClasses value: lastNameSpace allClasses.
	browser navigationState nameSpaceFilter value: (OrderedCollection with:lastNameSpace name).
	browser navigationState selectedNamespaces value: (OrderedCollection with:lastNameSpace name).
    ].
    self withWaitCursorDo:[
	browser browseMenuMethodsWithString
    ].
!

searchStringInLastPackage

    | selectedKey browser lastSearchPatterns|

    selectedKey := self selectedKey.
    selectedKey isNil ifTrue:[^ Dialog information: 'No selected key'].

    browser := NewSystemBrowser new "open".
    browser allButOpen.
    
    lastSearchPatterns := browser lastSearchPatterns.
    (lastSearchPatterns notNil and:[lastSearchPatterns first ~= selectedKey]) ifTrue:[
        browser lastSearchPatterns addFirst: selectedKey
    ].
    SearchDialog lastStringSearchArea: #currentPackage.
    lastPackage isNil ifTrue:[
        self changeLastPackage.
    ].
    lastPackage notNil ifTrue:[
"/        browser navigationState selectedClasses value: lastNameSpace allClasses.
        browser navigationState packageFilter value: (OrderedCollection with:lastPackage).
        browser navigationState selectedProjects value: (OrderedCollection with:lastPackage).
    ].
    self withWaitCursorDo:[
        browser 
            askForMethodAndSpawnSearchTitle:'String to Search for in Sources:'
            browserLabel:'Methods containing "%1"'
            searchWith:#( #'findString:in:ignoreCase:match:' #'findString:inMethods:ignoreCase:match:' )
            searchWhat:#string
            searchArea:#currentPackage
            withCaseIgnore:false
            withTextEntry:false
            withMatch:true
            withMethodList:false
            setSearchPattern:[:brwsr :string :ignoreCase :doMatch|
                                brwsr autoSearchPattern:string ignoreCase:ignoreCase.
                             ]
            initialText:selectedKey "/ does not work: ('''*',selectedKey,'*''') check match!!               
    ].
! !

!InternationalLanguageTranslationEditor methodsFor:'menus dynamic'!

disableLanguageDisplayFor:lang
    self shownLanguages remove:lang ifAbsent:[]
!

enableLanguageDisplayFor:newLang
    |shownLanguagesInOrder|

    (self shownLanguages includes:newLang) ifFalse:[
"/        shownLanguagesInOrder := self languagesList
"/                                    select:[:lang | (self shownLanguages includes:lang)
"/                                                    or:[ lang = newLang ]].
"/        self shownLanguages contents:shownLanguagesInOrder.
	self shownLanguages add:newLang.
    ]
!

isLanguageShown:lang
    ^ self shownLanguages includes:lang
!

menuSliceTranslateGenerate
    | menu |

    menu := Menu new.
    keyStringsToLanguageMappings notNil ifTrue:[ 
        keyStringsToLanguageMappings languages do:[:lang | 
            menu addItem:   
                (MenuItem
                    label: (resources string: 'Generate Missing Translations - %1' with: lang asUppercase)
                    itemValue: [ self generateMissingTranslationsFor: (Array with: lang) ])
        ].
    ].
    ^ menu

    "Created: / 19-02-2015 / 12:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shownLanguagesMenu
    <resource: #programMenu >

    ^ [
	|m selected|

	m := Menu new.

	self languagesList do:[:lang |
	    |item|

	    item := MenuItem label:lang.
	    item indication:(self languageShownHolderFor:lang).
	    item hideMenuOnActivated:false.
	    m addItem:item.
	].
	m
    ].
!

toggleLanguageDisplayFor:lang
    (self shownLanguages includes:lang) ifTrue:[
	self disableLanguageDisplayFor:lang
    ] ifFalse:[
	self enableLanguageDisplayFor:lang
    ].
! !

!InternationalLanguageTranslationEditor methodsFor:'private-key extraction'!

addAllTranslations:newTranslations
    "merge found xlations into the list of already present xlations"
    
    |newTranslationKeys stringKeys nonStringKeys|

    newTranslationKeys := newTranslations select:[:k | k notEmptyOrNil and:[k isString not or:[k isBlank not]]].
    newTranslationKeys := newTranslationKeys select:[:k | (keyStringsToLanguageMappings includesKey:k) not].
    "/ follow the common-xlations algrithm of ResourcePack
    "/ (which knows how to xlate strings with additional special chars.)
    newTranslationKeys := 
        newTranslationKeys collect:[:oldKey |
            |newKey methods|
            
            (oldKey endsWith:' ...') ifTrue:[
                newKey := oldKey copyButLast:4.
            ] ifFalse:[ (oldKey endsWith:'...') ifTrue:[
                newKey := oldKey copyButLast:3.
            ] ifFalse:[ ('\.:?=,!! ' includes:oldKey last) ifTrue:[
                newKey := oldKey copyButLast:1.
            ] ifFalse:[ ((oldKey first == $() and:[ oldKey last == $) ]) ifTrue:[
                newKey := oldKey copyFrom:2 to:oldKey size - 1
            ] ifFalse:[ ((oldKey first == $[) and:[ oldKey last == $] ]) ifTrue:[
                newKey := oldKey copyFrom:2 to:oldKey size - 1
            ] ifFalse:[
                newKey :=oldKey
            ]]]]].
            "/ must attach oldKey-methods to newKey
            methods := methodsUsingKey at:oldKey ifAbsent:nil.
            methods notNil ifTrue:[
                (methodsUsingKey at:newKey ifAbsentPut:[Set new]) addAll:methods
            ].    
            newKey
        ].
        
    newTranslationKeys := newTranslationKeys asSet.
    newTranslationKeys := newTranslationKeys select:[:k | (keyStringsToLanguageMappings includesKey:k) not].

    newTranslationKeys notEmpty ifTrue:[
        stringKeys := newTranslationKeys select:[:k | k isString].
        nonStringKeys := newTranslationKeys select:[:k | k isString not].

        stringKeys := stringKeys asSortedCollection.
        keyStringsToLanguageMappings addKeys:stringKeys.
        keyStringsToLanguageMappings addKeys:nonStringKeys.
        modified := true.
    ].
!

extractTranslationsFromClass:aClass
    |newTranslations|

    newTranslations := Set new.

    self withWaitCursorDo:[
        "/ now, the hard part:
        "/ possible translations are in the specs,
        "/ and all arguments to (resources string:) messages.
        aClass instAndClassMethodsDo:[:eachMethod |
            newTranslations addAll:( self extractTranslationsFromMethod:eachMethod ).
        ].
    ].
    
    newTranslations := 
        newTranslations select:[:eachTranslation|
            (aClass resources at:eachTranslation ifAbsent:nil) isNil
        ].
    ^ newTranslations
!

extractTranslationsFromHelpSpecMethod:aMethod
    "return strings which need translation from a help-spec method"

    |codeStrings matcher parseTree resourceKeys|

    parseTree := RBParser
            parseMethod:aMethod source
            onError: [:str :pos | Transcript showCR:str. Transcript showCR:pos.
                                  nil].
    parseTree isNil ifTrue:[^ #() ].

    codeStrings  :=
        #(
                '`@dict addPairsFrom: `#helpKeysAndStrings'
                '^ `#lit'
        ).

    resourceKeys := Set new.

    matcher := ParseTreeSearcher new.
    matcher
        matchesAnyOf: codeStrings
        do: [:aNode :answer |
                |sel argNode arg|

                aNode isReturn ifTrue:[
                    "/ a ^ #(...)
                    aNode value isLiteralArray ifTrue:[
                        aNode value value pairWiseDo:[:helpKey :helpString |
                            self rememberMethod:aMethod usingKey:helpString.
                            resourceKeys add:helpString.
                        ].
                    ].    
                ] ifFalse:[    
                    sel := aNode selector.
                    (sel startsWith:'addPairsFrom:') ifTrue:[
                        argNode := aNode arguments at:1.
                        argNode isLiteralArray ifTrue:[
                            arg := argNode value.
                            arg doWithIndex:[:el :index |
                                index even ifTrue:[
                                    el isString ifTrue:[
                                        self rememberMethod:aMethod usingKey:el.
                                        resourceKeys add:el.
                                    ]
                                ].
                            ].
                        ] ifFalse:[
                            Transcript halt
                                showCR:(resources
                                            string:'Cannot derive resourceKey from non-literal array: %1 in %2'
                                            with:argNode formattedCode
                                            with:aMethod selector).
                        ].
                    ].
                ].
                aNode
            ].

    matcher executeTree: parseTree initialAnswer: nil.
    ^ resourceKeys
!

extractTranslationsFromMenuSpecMethod:aMethod
    "return strings which need translation from a menu-spec method"

    |menu resourceKeys|

    menu := aMethod mclass theNonMetaclass perform:aMethod selector.
    menu isNil ifTrue:[ ^ #() ].

    (menu isKindOf:Menu) ifFalse:[
        menu := Menu new fromLiteralArrayEncoding:menu
    ].

    resourceKeys := Set new.
    menu allItemsDo:[:aMenuItem |
        aMenuItem translateLabel ifTrue:[
            (aMenuItem isSeparatorItem or:[aMenuItem isMenuSlice])  ifFalse:[
                self rememberMethod:aMethod usingKey:aMenuItem label.
                resourceKeys add:aMenuItem label.
            ]
        ]
    ].
    ^ resourceKeys
!

extractTranslationsFromMethod:aMethod
    "return strings which need translation from a method."
    
    |mResources|

    mResources := aMethod resources.
    mResources notNil ifTrue:[
        (mResources includesKey:#menu) ifTrue:[
             ^ self extractTranslationsFromMenuSpecMethod:aMethod.
        ].
        (mResources includesKey:#canvas) ifTrue:[
             ^ self extractTranslationsFromUISpecMethod:aMethod.
        ].
        (mResources includesKey:#help) ifTrue:[
             ^ self extractTranslationsFromHelpSpecMethod:aMethod.
        ].
        (mResources includesKey:#tableColumns) ifTrue:[
             ^ self extractTranslationsFromTableColumnsSpecMethod:aMethod.
        ].

        ^ self extractTranslationsFromSpecMethod:aMethod.
    ].
    ^ self extractTranslationsFromMethodsCode:aMethod
!

extractTranslationsFromMethodsCode:aMethod
    "return strings which need translation from a normal method.
     detects messages to the resource translation mechanism"

    |codeStrings matcher parseTree resourceKeys|

    parseTree := RBParser
            parseMethod:aMethod source
            onError: [:str :pos | Transcript showCR:str. Transcript showCR:pos.
                                  nil].
    parseTree isNil ifTrue:[^ #() ].

    codeStrings  :=
        #(
                'resources `@msg: `@args'
                'self resources `@msg: `@args'
                'self class resources `@msg: `@args'
                'self class classResources `@msg: `@args'
                'self classResources `@msg: `@args'
                '`V classResources `@msg: `@args'
        ).

    resourceKeys := Set new.

    matcher := ParseTreeSearcher new.
    matcher
        matchesAnyOf: codeStrings
        do: [:aNode :answer |
                |sel keyStringArgNode keyStringArg|

                sel := aNode selector.
                ((sel startsWith:'string:') or:[(sel startsWith:'at:') or:[sel startsWith:'stringWithCRs:']]) ifTrue:[
                    keyStringArgNode := aNode arguments at:1.
                    (keyStringArg := self literalStringOrStringConcatenation:keyStringArgNode) notNil ifTrue:[
                        self rememberMethod:aMethod usingKey:keyStringArg.
                        resourceKeys add:keyStringArg.
                    ] ifFalse:[
                        Transcript
                            showCR:(resources
                                    string:'[LanguageTranslator] warning: Cannot derive resourceKey from non-string: %1 in %2'
                                    with:keyStringArgNode formattedCode
                                    with:aMethod whoString).
                    ].
                ].
                aNode
            ].

    matcher executeTree: parseTree initialAnswer: nil.
    ^ resourceKeys

    "Modified: / 19-02-2015 / 11:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractTranslationsFromSpecMethod:aMethod
    ^ #()
!

extractTranslationsFromTableColumnsSpecMethod:aMethod
    "return strings which need translation from a table-spec method"

    |columnDescription resourceKeys|

    columnDescription := aMethod mclass theNonMetaclass perform:aMethod selector.
    columnDescription isNil ifTrue:[ ^ #() ].

    (columnDescription first isKindOf:DataSetColumnSpec) ifFalse:[
        columnDescription := columnDescription collect:[:el | DataSetColumnSpec new fromLiteralArrayEncoding:el].
    ].

    resourceKeys := Set new.
    columnDescription do:[:aColumnSpec |
        aColumnSpec translateLabel ifTrue:[
            self rememberMethod:aMethod usingKey:aColumnSpec label.
            resourceKeys add:aColumnSpec label.
        ]
    ].
    ^ resourceKeys
!

extractTranslationsFromUISpecMethod:aMethod
    "return strings which need translation from a UI-spec method"
    
    |spec resourceKeys visitor|

    spec := aMethod mclass theNonMetaclass perform:aMethod selector.
    spec isNil ifTrue:[ ^ #() ].

    (spec isKindOf:UISpecification) ifFalse:[
        spec := UISpecification from:spec
    ].

    resourceKeys := Set new.

    visitor := UISpecVisitor new.
    spec acceptVisitor:visitor.
    visitor translatedLabels do:[:each |
        self rememberMethod:aMethod usingKey:each.
    ].
    ^ visitor translatedLabels
!

literalStringOrStringConcatenation:aParseNode
    "nil if not a literal or a string concatenation"
    
    aParseNode isLiteralString ifTrue:[^ aParseNode value].
    (aParseNode isMessage and:[aParseNode selector == #,]) ifTrue:[
        |leftString rightString|
        
        aParseNode receiver isLiteralString ifTrue:[
            leftString := aParseNode receiver value
        ] ifFalse:[
            leftString := self literalStringOrStringConcatenation:aParseNode receiver.
        ].
        aParseNode arguments first isLiteralString ifTrue:[
            rightString := aParseNode arguments first value
        ] ifFalse:[
            rightString := self literalStringOrStringConcatenation:aParseNode arguments first.
        ].
        (leftString notNil and:[rightString notNil]) ifTrue:[
            ^ leftString , rightString
        ].
    ].
    ^ nil
!

recordNewTranslation:aString
    "called from recorder, when the monitored application does a translation"
    
    self addAllTranslations:{ aString }
!

rememberMethod:aMethod usingKey:aKey
    (methodsUsingKey at:aKey ifAbsentPut:[Set new]) add:aMethod
! !

!InternationalLanguageTranslationEditor methodsFor:'queries'!

autoAccept

    ^ self autoAcceptHolder value
!

currentExampleLanguageText
   "Returns the language text corresponding for the current selected key and the example language selection"

  ^self languageTextFromSelectedKeyFor: self exampleLanguageSelectionHolder value
!

currentLanguage

    |colSelectionIndex |

    colSelectionIndex := dataSetView selectedColIndex.
    ^colSelectionIndex > 1 ifTrue:[ shownLanguages at:colSelectionIndex-1 ] ifFalse:nil.
!

exampleLanguageByDefault

    ^self shownLanguages isEmpty
	ifTrue:[nil]
	ifFalse:[self shownLanguages first]
!

hasFirstRowSelection
    self selectedKeyRow isNil ifTrue:[^false].
    ^ self selectedKeyRow value > 1
!

hasLanguageSelection
    dataSetView selectedColIndex isNil ifTrue:[^false].
    ^ dataSetView selectedColIndex > 1
!

hasUnsavedChanges
    ^ modified
!

includesKey: aKey
    keyStringsToLanguageMappings isNil ifTrue:[^false].
    ^keyStringsToLanguageMappings includesKey:aKey
!

isSearchForSimilarTranslationEnabled

    ^self searchForSimilarTranslationEnableHolder value
!

languageTextFromKey: aKeyIndex for: language
    "Returns the language text corresponding for the aKeyIndex and the received language"

    language isNil ifTrue:[^''].
    ^keyStringsToLanguageMappings at: aKeyIndex language:language.
!

languageTextFromSelectedKeyFor: language
    "Returns the language text corresponding for the current selected key and the received language"

    ^self languageTextFromKey: self selectedKey for: language
!

shouldCopyPreviousTranslationButtonBeEnabled
    ^ self hasLanguageSelection
	and:[self hasFirstRowSelection]
!

shouldPasteOriginalButtonBeEnabled
    ^ self hasLanguageSelection
	and:[self hasFirstRowSelection]
!

shouldSearchForSimilarTranslation

    self isSearchForSimilarTranslationEnabled ifFalse:[^false].
    (self languageTextHolder value notNil and:[self languageTextHolder value notEmpty]) ifTrue:[^false].
    (self hasLanguageSelection and:[self selectedKeyRow notNil]) ifFalse:[^false].
    ^true
! !

!InternationalLanguageTranslationEditor methodsFor:'read/write resourceFile'!

encoderAt: lang

    self alwaysWriteUTF8Holder value ifTrue:[^CharacterEncoder encoderForUTF8].
    ^keyStringsToLanguageMappings encoderAt: lang.
!

printEditingWarningOn: aStream

    aStream nextPutAll: ';';
            cr;
            nextPutAll: '; WARNING:';
            cr;
            nextPutAll: '; this file contains national characters.';
            cr;
            nextPutAll: '; DO NOT EDIT this file with an old vi!!';
            cr;
            nextPutAll: ';';
            cr;
            cr.
!

printEncoderFor: lang on: aStream
    |characterEncoder encoderString|

    characterEncoder := self encoderAt: lang.
    encoderString := characterEncoder isNil
	ifTrue:[self requestEncoderStringFor: lang]
	ifFalse:[characterEncoder nameOfEncoding printString].

    aStream nextPutAll: '#encoding';
	    space;
	    nextPutAll: encoderString;
	    cr;
	    cr.
!

printLanguage: lang on: aStream

    self printEncoderFor: lang on: aStream.
    self printEditingWarningOn: aStream.
    self printLanguageMappingsFor: lang on: aStream.
!

printLanguageMappingsFor: lang on: aStream

    |orderedAssociations maxKeySize characterEncoder|

    characterEncoder := self encoderAt: lang.
    characterEncoder isNil ifTrue:[ characterEncoder := CharacterEncoder::NullEncoder ].
    orderedAssociations := keyStringsToLanguageMappings orderedLanguageMappingsAssociationsFor: lang.

    maxKeySize := keyStringsToLanguageMappings maxKeySizeForLanguage: lang.

    orderedAssociations do:[:association |
        "use #basicStoreString to avoid implicit utf8Encoding for UnicodeStrings"
        aStream nextPutAll: ((characterEncoder encodeString:association key basicStoreString) paddedTo: maxKeySize) ;
            tab;
            nextPutAll: (characterEncoder encodeString: association value basicStoreString);
            cr.
        ].
!

readResourceFile:aFilename asLanguage:lang
    |resourcePack inStream lineString encoding decoder sortedKeys remainingKeys|

    aFilename exists ifFalse:[
        Dialog information:(resources string:'Language file: "%1" does not exist' with:aFilename baseName).
        ^ self
    ].

    resourcePack := ResourcePack new.

    inStream := aFilename readStream.
    [inStream atEnd] whileFalse:[
        lineString := inStream nextLine.
        (lineString notEmpty
        and:[ (lineString startsWith:';') not and:[ (lineString startsWith:'"/') not]]) ifTrue:[
            ((lineString startsWith:'#') and:[(lineString startsWith:'#(') not]) ifTrue:[
                lineString := (lineString copyFrom:2) withoutSeparators.
                (lineString startsWith:'encoding ') ifTrue:[
                    encoding := ResourcePack extractEncodingFromLine:lineString.
                    decoder := CharacterEncoder encoderFor:encoding ifAbsent:nil.
                ].
            ] ifFalse:[
                ResourcePack
                    processResourceLine:lineString
                    encoding:decoder
                    file:aFilename pathName
                    printErrorWith:[:msg | Transcript showCR:msg ]
                    for:resourcePack
                    keepUselessTranslations:true.
            ].
        ].
    ].
    inStream close.

    sortedKeys := (resourcePack keys select:[:k | k isString]) asSortedCollection.
    remainingKeys := resourcePack keys select:[:k | k isString not].

    keyStringsToLanguageMappings atLanguage: lang putFilename: aFilename.
    keyStringsToLanguageMappings atLanguage: lang putEncoder: decoder.

    sortedKeys do:[:k |
        keyStringsToLanguageMappings at:k language:lang put:(resourcePack at:k) sendChange:false
    ].
    remainingKeys do:[:k |
        keyStringsToLanguageMappings at:k language:lang put:(resourcePack at:k) sendChange:false
    ].
    keyStringsToLanguageMappings changed.
!

saveLanguage: lang
"Saves the language in the fileName from where the language resource was obtained."
    |aFilename|

    lang isNil ifTrue:[^ self].
    aFilename := keyStringsToLanguageMappings filenameAt:lang.
    aFilename isNil ifTrue:[
	aFilename := self requestFilenameFor: lang.
	aFilename isNil ifTrue:[^ self].
    ].
    self saveResourceFile:aFilename for:lang asSymbol
!

saveResourceFile: aFilename for: lang

    |aStream |

    keyStringsToLanguageMappings atLanguage: lang putFilename: aFilename.
    aStream := FileStream newFileNamed: aFilename.
    self printLanguage: lang on: aStream.
    aStream flush;
	    close.
    DialogBox information: 'The resource file for the language ', lang printString storeString, ' was saved in the file: ', aFilename nameString
! !

!InternationalLanguageTranslationEditor methodsFor:'searching'!

ignoreCaseHolderChanged

    self searchNextTextIncludingCurrentSelection: true.

    "Created: / 16-06-2007 / 09:33:33 / Administrador"
!

searchNextText

    self searchNextTextIncludingCurrentSelection: false.

    "Modified: / 16-06-2007 / 09:21:14 / Administrador"
!

searchNextTextFromBeginning
    |searchText rowFoundIndex|

    searchText := searchTextView contents.
    searchText isEmptyOrNil ifTrue:[^self].
    self objectsList isEmpty ifTrue:[^self].
    rowFoundIndex := self tableView findFirstRowWithString: searchText
		from:1
		to:self objectsList size
		ignoreCase:self ignoreCaseHolder value.
    rowFoundIndex isNil ifTrue:[
	self searchTextNotFound.
	^self
    ].
    self selectListIndex: rowFoundIndex

    "Created: / 16-06-2007 / 10:54:51 / Administrador"
    "Modified: / 19-06-2007 / 15:38:59 / Administrador"
!

searchNextTextIncludingCurrentSelection: includeCurrentSelection
    |searchText currentSelectionIndex rowFoundIndex fromIndex listSize|

    self searchTextStarted.
    searchText := searchTextView contents.
    searchText isEmptyOrNil ifTrue:[^self].
    self objectsList isEmpty ifTrue:[^self].
    currentSelectionIndex := self currentSelectionIndex.
    (currentSelectionIndex isNil or:[currentSelectionIndex == 0]) ifTrue:[
	self searchNextTextFromBeginning.
	^self.
    ].
    listSize := self objectsList size.
    (currentSelectionIndex == listSize and:[includeCurrentSelection not]) ifTrue:[
	self searchNextTextReachEnd.
	^self.
    ].
    fromIndex := includeCurrentSelection
	ifTrue:[currentSelectionIndex]
	ifFalse:[currentSelectionIndex + 1].
    rowFoundIndex := self tableView findFirstRowWithString: searchText
		from:fromIndex
		to:listSize
		ignoreCase:self ignoreCaseHolder value.
    rowFoundIndex isNil ifTrue:[
	self searchNextTextReachEnd.
	^self
    ].
    self selectListIndex: rowFoundIndex

    "Created: / 16-06-2007 / 09:20:57 / Administrador"
    "Modified: / 19-06-2007 / 15:38:06 / Administrador"
!

searchNextTextReachEnd
    |message|
    message := 'End of list reached, starting from the beginning'.
    self searchTextRestarted: message.
    Smalltalk beep.
    self searchNextTextFromBeginning.

    "Created: / 16-06-2007 / 11:00:59 / Administrador"
!

searchPreviousText

    |searchText currentSelectionIndex rowFoundIndex fromIndex|

    self searchTextStarted.
    searchText := searchTextView contents.
    searchText isEmptyOrNil ifTrue:[^self].
    self objectsList isEmpty ifTrue:[^self].
    currentSelectionIndex := self currentSelectionIndex.
    currentSelectionIndex == 1 ifTrue:[
	self searchPreviousTextReachBeginning.
	^self.
    ].
    (currentSelectionIndex isNil or:[currentSelectionIndex == 0])
	ifTrue:[
	    self searchPreviousTextFromEnd.
	    ^self.
	]
	ifFalse:[fromIndex := currentSelectionIndex - 1].
    rowFoundIndex := self tableView findFirstRowWithString: searchText
		from: fromIndex
		to: 1
		by: -1
		ignoreCase:self ignoreCaseHolder value.
    rowFoundIndex isNil ifTrue:[
	self searchPreviousTextReachBeginning.
	^self
    ].
    self selectListIndex: rowFoundIndex.

    "Modified: / 19-06-2007 / 15:38:16 / Administrador"
!

searchPreviousTextFromEnd

    |searchText rowFoundIndex|

    searchText := searchTextView contents.
    searchText isEmptyOrNil ifTrue:[^self].
    self objectsList isEmpty ifTrue:[^self].
    rowFoundIndex := self tableView findFirstRowWithString: searchText
		from: self objectsList size
		to: 1
		by: -1
		ignoreCase:self ignoreCaseHolder value.
    rowFoundIndex isNil ifTrue:[
	self searchTextNotFound.
	^self
    ].
    self selectListIndex: rowFoundIndex.

    "Created: / 16-06-2007 / 10:55:43 / Administrador"
    "Modified: / 19-06-2007 / 15:38:26 / Administrador"
!

searchPreviousTextReachBeginning
    |message|
    message := 'Beginning of list reached, starting from the end'.
    self searchTextRestarted: message.
    Smalltalk beep.
    self searchPreviousTextFromEnd.

    "Created: / 16-06-2007 / 11:01:23 / Administrador"
!

searchTextModifiedHolderChanged

    self searchNextTextIncludingCurrentSelection: true.
    self searchTextModifiedHolder setValue: false.

"/Transcript showCR: 'searchTextModifiedHolderChanged: ',(self searchTextHolder value ? '').
"/Transcript showCR: 'searchTextView contents: ',(searchTextView contents ? '').

    "Created: / 15-06-2007 / 18:07:57 / Administrador"
    "Modified: / 16-06-2007 / 09:21:27 / Administrador"
!

searchTextNotFound

    self selectListIndex: 0.
    self searchBarImageInfoLabelHolder value: self warningSearchBarIcon.
    self searchBarInfoLabelHolder value: 'Text not found'.
    self setSearchTextNotFoundColors.

    "Created: / 16-06-2007 / 06:51:01 / Administrador"
    "Modified: / 16-06-2007 / 11:43:53 / Administrador"
!

searchTextRestarted: message

    self searchBarImageInfoLabelHolder value: self restartSearchBarIcon.
    self searchBarInfoLabelHolder value: message.
"/    self setSearchTextNotFoundColors.

    "Created: / 16-06-2007 / 11:02:06 / Administrador"
!

searchTextStarted

    self searchBarImageInfoLabelHolder value: nil.
    self searchBarInfoLabelHolder value: ''.
    self setSearchTextFoundColors.

    "Created: / 16-06-2007 / 06:54:03 / Administrador"
    "Modified: / 16-06-2007 / 10:07:06 / Administrador"
!

setSearchTextFoundColors

    searchTextView foregroundColor: Color black.
    searchTextView backgroundColor: Color white.

    "Created: / 16-06-2007 / 06:28:32 / Administrador"
!

setSearchTextNotFoundColors

    searchTextView foregroundColor: Color white.
    searchTextView backgroundColor: Color lightRed.

    "Created: / 16-06-2007 / 06:29:00 / Administrador"
! !

!InternationalLanguageTranslationEditor methodsFor:'specs-dynamic'!

columnInRow:row at:colIndex
    |lang|

    lang := self languageAtCol:colIndex.
    ^ row atLanguage:lang
!

getBackgroundForRow:row rowNr:rowNr col:colIndex
    |lang|

    colIndex == 1 ifTrue:[^ nil].
    lang := self languageAtCol:colIndex.
    ^ (row atLanguage:lang) isNil ifTrue:[Color red lightened] ifFalse:nil
!

keyStringAndLanguageSelectionTableColumnDescription
    |spec|

    spec := OrderedCollection new.

    spec add:(self class keyTableColumn first).

    self shownLanguages do:[:lang |
	|entry|

	entry := self class languageTableColumn first.
	entry := entry copy replaceAll:#lang with:lang.
	spec add: entry
    ].
    ^ spec
!

keyStringInRow:row
    ^ row keyString
! !

!InternationalLanguageTranslationEditor methodsFor:'update'!

updateToolVisibility
    | bottomOffset searchBarVisible |

    bottomOffset := 0.

    searchBarVisible := self searchBoxVisible value.
    searchBarVisible ifTrue:[
	bottomOffset := bottomOffset - searchBoxView height.
    ].
    translationsPanel layout bottomOffset:bottomOffset-1.
    translationsPanel container notNil ifTrue:[
	translationsPanel containerChangedSize.
    ].

    "Created: / 16-06-2007 / 11:58:25 / Administrador"
! !

!InternationalLanguageTranslationEditor methodsFor:'user actions'!

closeSearchBar

    self searchBoxVisible value: false.
    self updateToolVisibility.

    "Created: / 15-06-2007 / 18:03:05 / Administrador"
    "Modified: / 16-06-2007 / 11:58:52 / Administrador"
!

exampleLanguageSelectionChanged

   self updateExampleLanguageText.
!

languageTextAccepted
    |nextRowIndex selRow|

    selRow := self selectedKeyRow value.
    selRow notNil ifTrue:[
	keyStringsToLanguageMappings size = selRow
	    ifTrue:[ self updateLanguageTextModification.]
	    ifFalse:[
		nextRowIndex := selRow + 1.
		self selectedKeyRow value: nextRowIndex]
    ].
!

pasteOriginalInLanguageText
    <resource: #uiCallback>

    | originalText|

    originalText := self selectedKey.
    languageEditor selectAll.
    languageEditor pasteOrReplace:originalText.
    self languageTextModifiedHolder value:true.
!

pastePreviousTranslationInLanguageText
    "Obtain the text from the previous translation and paste it into the languageTextEditor"

    | previousLanguageText previousLanguageRow|

    previousLanguageRow := dataSetView at:self selectedKeyRow value - 1
		ifAbsent:[^self].
    previousLanguageText := previousLanguageRow atLanguage: self currentLanguage.
    languageEditor selectAll.
    languageEditor pasteOrReplace:previousLanguageText.
    self languageTextModifiedHolder value:true.
!

search
    "make the searchbox visible"
    
    self searchBoxVisible value: true.
    self updateToolVisibility.
    searchTextView takeFocus.

    "Modified: / 16-06-2007 / 11:58:44 / Administrador"
!

selectionChanged

   self updateOriginalTextModification.
   self updateLanguageTextModification.
   self updateLanguageAndKeySelection.
   self updateExampleLanguageText.

   self updateCopyPreviousTranslationButtonEnabled.
   self updatePasteOriginalButtonEnabled.

   self originalTextModifiedHolder value:false.
   self languageTextModifiedHolder value:false.

   self searchForSimilarTranslation.
!

showMissingTranslationsOnlyChanged
!

shownLanguagesChanged
    self keyStringAndLanguageSelectionTableColumnDescriptionHolder
	value:(self keyStringAndLanguageSelectionTableColumnDescription).
!

stopApplication
    |p|

    (p := monitoredApplication) notNil ifTrue:[
	p terminate.
    ].
! !

!InternationalLanguageTranslationEditor::AccessCollectingPseudoResourcePack methodsFor:'accessing'!

realResourcePack:something
    realResourcePack := something.
!

watchingTranslationEditor:something
    watchingTranslationEditor := something.
! !

!InternationalLanguageTranslationEditor::AccessCollectingPseudoResourcePack methodsFor:'resource pack protocol'!

forwardFor:aString
    collectedKeys isNil ifTrue:[
        collectedKeys := Set new.
    ].
    collectedKeys add:aString.
    watchingTranslationEditor notNil ifTrue:[
        watchingTranslationEditor recordNewTranslation:aString.
    ].
    ^ realResourcePack perform:(thisContext sender selector) withArguments:(thisContext sender args).
!

string:aString
    ^ self forwardFor:aString
! !

!InternationalLanguageTranslationEditor::KeyStringsToLanguageMappings class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!InternationalLanguageTranslationEditor::KeyStringsToLanguageMappings methodsFor:'accessing'!

addKey:aKey
    self addKey:aKey sendChange:true
!

addKey:aKey sendChange:aBoolean
    (keys includes:aKey) ifFalse:[
	keys add:aKey.
	aBoolean ifTrue:[ self changed ].
    ]
!

addKeys:aCollectionOfKey
    keys addAll:aCollectionOfKey.
    self changed.
!

addLanguage:lang
    (languages includes:lang) ifFalse:[
	languages add:lang.
	perLanguageMappings at:lang put:(OrderedDictionary new).
    ]
!

at:aKey language:language
    ^ (perLanguageMappings at:language) at:aKey ifAbsent:nil
!

at:aKey language:language put:value
    self addKey:aKey.
    (perLanguageMappings at:language) at:aKey put:value.
    (self rowForKey:aKey) changed
!

at:aKey language:language put:value sendChange:sendChange
    self addKey:aKey sendChange:sendChange.
    (perLanguageMappings at:language) at:aKey put:value.
    (self rowForKey:aKey) changed
!

atLanguage: lang putEncoder: aDecoder

^(self languageInfoAt: lang) at: self encoderKey put: aDecoder
!

atLanguage: lang putFilename: aFilename

^(self languageInfoAt: lang) at: self fileNameKey put: aFilename
!

decoderKey
   ^#decoder
!

encoderAt:lang
    ^ (self languageInfoAt:lang) at: self encoderKey ifAbsent:[nil]
!

encoderKey
   ^#encoder
!

fileNameKey
    ^ #filename
!

filenameAt:lang
    ^ (self languageInfoAt:lang) at: self fileNameKey ifAbsent:[nil]
!

keyAt:index
    ^ keys at:index ifAbsent:[nil].
!

keyAt:index ifAbsent:exceptionalValue
    ^ keys at:index ifAbsent:exceptionalValue.
!

keys
    ^ keys
!

languageInfoAt: lang

^self perLanguageInfo at: lang ifAbsentPut:[Dictionary new]
!

languages
    ^ languages
!

languagesInUse
"Returns a collection of symbols for the languages that have mappings"

^self languages select:[:each | (self atLanguage: each) notEmpty]
!

orderedLanguageMappingsAssociationsFor: language
"Returns a collection of languageMappings associations (alphabetically ordered by keys) "
    ^(self atLanguage: language) associations 
            asSortedCollection:[:a :b | a key isArray or:[b key isArray or:[a key < b key]]].
!

perLanguageInfo
    ^ perLanguageInfo
!

perLanguageInfo:something
    perLanguageInfo := something.
!

removeKey:aKey
    keys remove:aKey ifAbsent:[].
    perLanguageMappings do:[:eachMapping |
	eachMapping removeKey:aKey ifAbsent:[].
    ].
    self changed.
!

rowForKey:aKey
    ^ rowPerKey
	    at:aKey
	    ifAbsentPut:[InternationalLanguageTranslationEditor::LanguageMappingRow new
			    key:aKey; mappings:self].
!

size
    ^ keys size
! !

!InternationalLanguageTranslationEditor::KeyStringsToLanguageMappings methodsFor:'enumerating'!

do:aBlock
    keys do:[:eachKey |
	aBlock value:(self rowForKey:eachKey).
    ].
! !

!InternationalLanguageTranslationEditor::KeyStringsToLanguageMappings methodsFor:'initialization'!

initialize
    super initialize.

    keys := OrderedSet new.
    languages := OrderedCollection new.
    perLanguageMappings := Dictionary new.
    perLanguageInfo := Dictionary new.
    rowPerKey := Dictionary new.

    self addLanguage:#'de'.
    self addLanguage:#'fr'.
    self addLanguage:#'en'.
    self addLanguage:#'it'.
    self addLanguage:#'es'.
    self addLanguage:(Smalltalk language).

    "/ self initializeDemoMappings.
!

initializeDemoMappings
    keys add:'open'.
    keys add:'close'.
    keys add:'yes'.
    keys add:'no'.

    self addLanguage:#'de'.
    self addLanguage:#'fr'.

    self at:'open' language:#'de' put:'öffnen'.
    self at:'close' language:#'de' put:'schließen'.
    self at:'yes' language:#'de' put:'ja'.
    self at:'no' language:#'de' put:'nein'.
    self at:'cancel' language:#'de' put:'abbrechen'.

    self at:'open' language:#'fr' put:'ouvrir'.
    self at:'close' language:#'fr' put:'fermer'.
    self at:'yes' language:#'fr' put:'oui'.
    self at:'no' language:#'fr' put:'non'.
! !

!InternationalLanguageTranslationEditor::KeyStringsToLanguageMappings methodsFor:'private'!

atLanguage:lang
    ^ perLanguageMappings at:lang
!

atLanguageIndex:idx
    |lang|

    lang := languages at:idx.
    ^ self atLanguage:lang.
!

mappingAtLanguage:lang
    ^ perLanguageMappings at:lang
!

mappingAtLanguageIndex:idx
    |lang|

    lang := languages at:idx.
    ^ self mappingAtLanguage:lang.
! !

!InternationalLanguageTranslationEditor::KeyStringsToLanguageMappings methodsFor:'queries'!

includesKey:aKey
    ^ keys includes:aKey
!

includesLanguage:lang
    ^ languages includes:lang
!

indexOfKey:aKey
    ^ keys indexOf:aKey
!

maxKeySizeForLanguage: lang

^(self atLanguage: lang) keys inject: 0 into:[:maxSize :each |
    (maxSize < each size and:[each size < 100])
	ifTrue:[each size]
	ifFalse:[maxSize].].
!

searchForSimilarTranslation: aKey in: language
    "Returns a collection of translation associations that corresponds to a quite similar key comparing with aKey"

    |similarAssociations|

    similarAssociations:=
    (self mappingAtLanguage: language) associationsSelect:[:each |
        |eachKey|

        eachKey := eachKey.
        eachKey isString 
        and:[(eachKey sameAs: aKey)
             or:[(aKey asUppercase startsWith: eachKey asUppercase)
             or:[((eachKey asUppercase levenshteinTo: aKey asUppercase)/ eachKey size) < 0.3
         ]]]
         and:[each value notEmptyOrNil]
    ].
    ^similarAssociations
! !

!InternationalLanguageTranslationEditor::LanguageMappingRow methodsFor:'accessing'!

atLanguage:language
    |translation|

    translation := (mappings mappingAtLanguage:language) at:key ifAbsent:nil.
    ^ translation isNil ifTrue:nil ifFalse:[translation printString]
!

columnAt:columnNr
    ^ (mappings mappingAtLanguageIndex:columnNr-1) at: key ifAbsent:nil
!

key:something
    key := something.
!

keyString
    ^ key printString
!

mappings:something
    mappings := something.
! !

!InternationalLanguageTranslationEditor::UISpecVisitor methodsFor:'accessing'!

translatedLabels
    ^ translatedLabels ? #()
! !

!InternationalLanguageTranslationEditor::UISpecVisitor methodsFor:'visiting'!

visitObject:anObject with:aParameter
    |l|

    (anObject isKindOf:UISpecification) ifTrue:[
	(anObject respondsTo:#translateLabel) ifTrue:[
	    anObject translateLabel == true ifTrue:[
		translatedLabels isNil ifTrue:[
		    translatedLabels := Set new.
		].
		l := anObject perform:#label ifNotUnderstood:nil.
		l notNil ifTrue:[
		    translatedLabels add:l.
		].
	    ].
	].
    ].
    self visitChildrenOf:anObject.
! !

!InternationalLanguageTranslationEditor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

