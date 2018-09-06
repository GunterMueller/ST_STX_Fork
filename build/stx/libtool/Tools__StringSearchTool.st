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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#StringSearchTool
	instanceVariableNames:'searchTextHolder searchTextView searchBarImageInfoLabelHolder
		searchBarInfoLabelHolder searchTextModifiedHolder matchCaseHolder
		closeBlock searchNextBlock searchPreviousBlock restartHolder'
	classVariableNames:'LastMatchCase LastRestart'
	poolDictionaries:''
	category:'Interface-Tools'
!

!StringSearchTool class methodsFor:'documentation'!

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
    documentation to be added.

    [author:]
        User (User@FELIXM)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Tools::StringSearchTool open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!StringSearchTool class methodsFor:'accessing'!

lastMatchCase

    ^ LastMatchCase ? false
!

lastMatchCase: aBoolean

    LastMatchCase := aBoolean
!

lastRestart

    ^ LastRestart ? false
!

lastRestart: aBoolean

    LastRestart := aBoolean
! !

!StringSearchTool class methodsFor:'image specs'!

closeSearchBarIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self closeSearchBar inspect
     ImageEditor openOnClass:self andSelector:#closeSearchBar
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'Tools::StringSearchTool class closeSearchBarIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GQ\SD1LSD1LSD1LSD1LWGP@@@@@@
@ATGA@HA@PDA@PDA@PHDA1T@@@@@@@@TAENG!!(VB XA?_''57QPPT@@@@@@@@E NJ^V)&X%)UTT5IV7 KE @@@@@@@A A"7Q,#&9VS%^MQ$E<DQ @@@@@@@@Z
@X%-#9NRX52R$80:^1@Z@@@@@@@@F0FHY6>R$9JR$9ION''(PF0@@@@@@@A<A 5ABT)FS$9D=KR13C1<@@@@@@@@)@WUCND*Q$9NQM"T!!XP8)@@@@@@@@K E2
O4RQ$9FQ$9@2G%8JK @@@@@@@CLA\S2D$9D9M)BS]!!1]BSL@@@@@@@@7@W@5LXP6J2\2]"P"VP 7@@@@@@@@O U+R3@*I2T#HA0&N5 RO @@@@@@@D LPF%(
YVQ W59]VU 4CD @@@@@@@AGFP4F@PDA@PDA@PDFCQ%G@@@@@@@@K41TUEQTUEQTUEQTUEQLK0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 167 25 15 170 49 40 171 50 39 174 68 60 176 56 48 176 58 49 183 118 110 184 45 32 184 46 32 184 47 34 184 71 58 184 85 78 184 86 79 185 53 39 186 57 42 186 59 43 186 60 45 186 68 58 190 187 180 192 188 181 193 189 182 194 190 183 195 192 184 197 194 186 202 148 142 202 199 191 205 202 195 207 64 48 207 203 195 208 65 49 208 205 198 209 65 49 209 66 49 209 69 52 210 66 49 210 78 64 211 67 51 211 71 54 212 69 51 212 208 200 212 208 202 213 69 52 213 70 52 213 79 57 215 80 59 215 212 206 217 214 207 218 79 62 218 84 67 219 107 95 219 216 210 221 84 63 221 84 67 221 109 96 221 218 213 222 76 56 222 110 96 222 113 79 223 87 67 223 87 70 223 115 99 224 221 216 225 89 72 225 105 91 225 117 84 227 89 64 227 91 73 227 112 98 227 115 95 227 122 92 227 224 219 227 225 219 228 113 83 228 113 99 229 102 87 229 226 221 230 115 84 230 117 81 230 142 117 231 102 80 231 116 86 231 120 103 231 131 119 231 228 224 232 118 88 232 119 82 233 143 117 234 99 76 234 102 79 234 119 89 234 127 100 234 145 119 235 104 82 235 106 86 236 108 89 236 110 92 236 113 92 236 121 91 236 146 119 237 113 95 237 115 98 237 122 92 237 132 100 238 117 101 238 119 104 238 123 93 238 123 109 238 131 98 238 133 102 238 146 120 238 148 121 239 125 112 239 127 115 239 129 118 239 131 105 239 134 102 240 135 122 240 200 196 242 135 113 242 141 116 242 141 119 242 145 116 242 147 118 242 148 120 243 137 115 243 138 118 243 141 121 243 142 123 243 144 126 243 145 129 243 151 134 243 202 197 244 147 132 244 149 135 244 152 137 244 163 142 244 164 145 245 160 143 245 164 146 245 213 204 246 213 203 248 215 205 249 215 206 252 244 243 253 244 243 253 247 245 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? G?? @@@@@@@@@@@@');
                            yourself);
                yourself
        ]

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
        constantNamed:'Tools::StringSearchTool restartSearchBarIcon'
        ifAbsentPut:[(Depth8Image new) width:20; height:20; bits:(ByteArray fromPackedString:'
3\7M3\7M RQXM(FA3\7M3\7M3\7M3\7M67H17Z+XBS''Y[<7M3\7M3\7MY#H42-8_TP)4E@9A)L7M3\7M3YGBKWZY 8A%+QTU$G(7W\7M3\7M/BY=Z9&^U4TD
L=+PTJKD$\7M3]LM.LF3QA[K(=L]AUIKEU%;(<7MM[HJT[.[WC4%@E9V)4 /''C@XZX$!!BJ4HO##M+1M8VG9Y31TU1WRD+(/ZYS.L3\53-&FG5EMQK<D/0V2.
2Z /&M_M3YN? ,^TQTHFK7D,(TD+JX(XY<7MODN7$ZQ2L])Q#B8 HI63K4@''3\7@*2("VFX5#!!,?UVORT+CAL6+M3V8S[[ET''2B4XK7CE0.O$)141L7M1"(S
,[E$$W2%^BOHS<6Z38(CSL5(J$L\^G"1^G!!-+KVW3\4BK7WL^YTLJ''!!8^B)!!XW!!J-P_M3T:)]4''DV=GN5 EM"H"M(FHR.\7M3S*FI!!;\5ZZ>-U>:%)YZ\DXS
3\7M3\7\,''<PFR"EDP>+D1(GQ<7M3\7M3]''Y52P VF5-3\7M3\7M3P@a') ; colorMapFromArray:#[143 127 144 95 95 111 192 160 96 224 191 111 192 144 111 224 160 95 255 255 175 223 224 240 239 191 127 223 160 143 255 224 160 224 223 224 239 255 224 223 160 128 207 159 80 223 224 255 191 144 127 223 223 240 175 175 191 224 239 255 208 144 80 255 224 143 224 207 128 192 176 207 207 144 95 176 144 128 239 240 255 255 223 160 239 239 240 255 192 144 239 176 128 255 224 128 255 239 223 224 176 127 240 224 240 160 144 160 255 239 208 95 80 127 208 159 111 255 207 207 176 160 160 255 224 111 240 255 255 208 144 16 176 127 64 192 144 80 159 127 111 255 223 128 176 127 63 223 176 128 239 191 160 239 175 111 207 159 95 255 207 175 255 224 224 224 191 143 255 255 223 255 208 176 223 192 160 223 176 111 64 80 127 96 96 111 207 175 127 176 160 143 208 144 95 255 208 144 239 192 128 224 255 255 208 176 80 192 159 111 207 208 223 224 224 240 255 191 96 255 224 175 79 80 95 255 240 143 224 208 144 95 95 127 224 208 175 239 239 255 255 207 111 255 239 160 255 176 95 255 223 175 255 239 255 208 192 208 208 160 127 224 192 127 255 239 224 192 144 95 175 176 207 128 95 63 224 223 207 255 223 207 192 160 144 192 207 224 192 176 128 239 255 255 111 112 128 240 239 240 255 224 240 255 224 144 255 240 224 255 224 208 80 95 96 239 176 127 240 176 175 255 255 128 224 159 80 240 240 255 80 79 143 255 239 207 176 176 207 255 239 175 239 192 175 63 95 111 255 192 127 239 207 111 255 192 95 224 192 128 255 255 255 223 208 175 223 160 80 224 192 160 255 255 224 240 191 96 208 175 143 208 159 127 255 223 111 255 224 223 208 239 224 255 223 96 255 176 96 192 191 207 207 159 111 223 208 207 79 80 127 240 192 143 255 208 127 208 160 64 239 207 175 80 95 128 207 175 96 255 207 144 255 191 95 255 240 240 224 160 96 64 96 111 240 223 191 80 80 63 176 191 224 223 224 224 208 160 96 255 239 111 239 176 160 239 208 144 255 223 143 224 160 47 224 191 95 255 239 240 80 95 111 224 175 127 255 191 127 240 208 207 255 240 223 224 224 191 207 176 175 223 159 80 255 224 127 207 175 111 175 128 111 223 239 255 80 80 95 255 223 144 223 144 64 79 95 127 239 175 80 255 240 255 224 175 128 255 207 95 239 223 175 192 192 208 207 239 255 224 239 240 255 191 128 223 223 224 191 192 224 208 176 96 255 207 191 224 208 207 192 176 191 223 255 255 79 79 128 255 239 144 240 207 175 224 208 224 224 176 143 255 207 127 95 95 143 255 255 240 191 176 207 207 159 47 223 175 80 208 192 160 207 191 111 0 0 0 96 80 64 240 191 111 255 223 127 112 95 64 223 208 223 255 223 208 207 176 144 224 191 160 95 80 95 255 223 191 176 128 111 255 224 191 255 208 128 255 223 223 255 207 160 191 159 111 255 208 111]; mask:((ImageMask new) width:20; height:20; bits:(ByteArray fromPackedString:'@?@OC?0OO?8O_?<O_?>O???O?????_??>_??>_??>_??>_??>_??>_??__??O???O???G???A??/A? O') ; yourself); yourself]
!

searchNextIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self searchNextIcon inspect
     ImageEditor openOnClass:self andSelector:#searchNextIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'Tools::StringSearchTool class searchNextIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ZE)ZZ@@@@@@@@@@@@@@@
@@@@@@AFF XA@PXUQ @@@@@@@@@@@@@@@@@*@Q5G^WX6E0D*@@@@@@@@@@@@@@@,AVQ?\&1#W&X8@20@@@@@@@@@@@A[@U==\F-"VUQOUSLAV0@@@@@@@@@@
G19-D <NCP0KB!!@7D1<@@@@@@@@@  ]MT5JY&Y&Y&Y%RLR4G  @@@@@@@H\A WL $)&Y&Y&RF35B@X\@@@@@@@BK@XA1WA"X&Y&XE#T:P@FK@@@@@@@@# !!H
]F$<II&YH3H>N2 H# @@@@@@@@@''GG)*Y2$9NRIDO4DQHP@@@@@@@@@@!!@EP[6U]I"UIQTL.@XP@@@@@@@@@@@ALAD-.XE]VS$(/@$0@@@@@@@@@@@@@@EDA
FSQ!!VC@T@UD@@@@@@@@@@@@@@@@@#R,I@PDIJ84@@@@@@@@@@@@@@@@@@@@@%)^W% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 48 54 77 55 63 87 56 64 89 57 67 90 59 67 90 64 69 89 71 74 92 72 76 96 76 81 100 80 89 118 82 90 119 83 91 120 84 92 122 86 94 123 87 96 124 89 97 126 92 104 132 97 106 136 97 110 138 97 112 138 100 102 112 101 107 130 104 118 144 105 113 135 105 124 146 107 109 118 107 116 144 110 127 148 112 126 148 113 129 148 117 119 129 118 130 156 119 123 133 125 140 174 127 131 146 127 132 148 127 146 178 130 151 181 131 132 143 133 149 185 133 152 182 134 134 138 137 140 150 138 138 142 139 156 191 141 160 195 143 164 199 143 169 198 144 157 197 144 158 197 152 173 208 153 184 209 155 167 210 156 180 208 157 179 215 157 180 211 160 162 171 160 173 216 160 174 216 160 182 214 161 173 217 161 174 217 161 176 219 161 179 220 161 180 220 163 182 222 163 184 222 164 182 222 164 184 223 166 164 161 166 189 212 166 194 211 167 190 228 167 194 229 167 200 221 169 170 174 169 195 212 169 196 232 170 181 228 170 203 221 171 171 176 171 173 182 171 193 220 173 182 232 173 192 232 173 200 234 175 206 239 175 210 240 176 188 237 178 175 168 178 175 173 178 202 234 178 206 240 179 195 238 180 205 223 180 214 243 180 216 244 181 193 242 181 195 239 181 204 223 181 212 243 182 206 242 182 209 243 184 180 173 184 211 244 184 215 245 185 198 246 185 200 244 188 215 233 188 225 249 189 226 249 190 206 250 190 219 248 191 209 249 191 217 248 191 222 248 192 188 181 192 221 249 194 190 184 195 191 184 196 226 251 196 232 251 199 196 189 202 198 191 202 226 253 203 199 193 203 229 253 203 237 252 203 237 253 204 202 196 206 202 195 206 205 204 207 203 196 208 204 197 208 205 201 212 208 200 212 208 201 212 208 202 212 209 205 213 210 202 213 212 213 214 211 206 215 212 207 216 213 206 218 215 210 220 221 223 221 219 214 222 219 215 222 220 215 230 228 225 236 235 232 243 243 244 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C@@@C@@@C@G C@_8C@?<CA?>CC??CC??CG??#G??#G??#G??#C??CC??CA?>C@?<C@_8C@G C@@@C@@@C@@@C');
                            yourself);
                yourself
        ]
!

searchPreviousIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self searchPreviousIcon inspect
     ImageEditor openOnClass:self andSelector:#searchPreviousIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'Tools::StringSearchTool class searchPreviousIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%)^W% @@@@@@@@@@@@@@
@@@@@@BMJ0$A@P$+#P@@@@@@@@@@@@@@@@AQ@Q$4XU 0E@EQ@@@@@@@@@@@@@@ALAD-.XE]VS$(/@$0@@@@@@@@@@@BD@UA/YU4&IT%EP28A!!@@@@@@@@@@@
I11:Z&\)NS$"QC=ADRD@@@@@@@@@# !!H]F$<II&YH3H>N2 H# @@@@@@@H,A GE\FI"Y&Y VMS)@@X,@@@@@@@BG@XE3HIJY&Y&Y$!!,=P FG@@@@@@@@  ]M
T5JY&Y&Y&Y%RLR4G  @@@@@@@@@_G&4RC08MC@,JDC\SG0@@@@@@@@@@V0E__WA+X%%TS5T3@U,@@@@@@@@@@@@,AVQ?\&1#W&X8@20@@@@@@@@@@@@@@B(A
GT]9]#XW@R(@@@@@@@@@@@@@@@@@Q!!(F@PDFETX@@@@@@@@@@@@@@@@@@@@@ZE)ZZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 48 54 77 55 63 87 56 64 89 57 67 90 59 67 90 64 69 89 71 74 92 72 76 96 76 81 100 80 89 118 82 90 119 83 91 120 84 92 122 86 94 123 87 96 124 89 97 126 92 104 132 97 106 136 97 110 138 97 112 138 100 102 112 101 107 130 104 118 144 105 113 135 105 124 146 107 109 118 107 116 144 110 127 148 112 126 148 113 129 148 117 119 129 118 130 156 119 123 133 125 140 174 127 131 146 127 132 148 127 146 178 130 151 181 131 132 143 133 149 185 133 152 182 134 134 138 137 140 150 138 138 142 139 156 191 141 160 195 143 164 199 143 169 198 144 157 197 144 158 197 152 173 208 153 184 209 155 167 210 156 180 208 157 179 215 157 180 211 160 162 171 160 173 216 160 174 216 160 182 214 161 173 217 161 174 217 161 176 219 161 179 220 161 180 220 163 182 222 163 184 222 164 182 222 164 184 223 166 164 161 166 189 212 166 194 211 167 190 228 167 194 229 167 200 221 169 170 174 169 195 212 169 196 232 170 181 228 170 203 221 171 171 176 171 173 182 171 193 220 173 182 232 173 192 232 173 200 234 175 206 239 175 210 240 176 188 237 178 175 168 178 175 173 178 202 234 178 206 240 179 195 238 180 205 223 180 214 243 180 216 244 181 193 242 181 195 239 181 204 223 181 212 243 182 206 242 182 209 243 184 180 173 184 211 244 184 215 245 185 198 246 185 200 244 188 215 233 188 225 249 189 226 249 190 206 250 190 219 248 191 209 249 191 217 248 191 222 248 192 188 181 192 221 249 194 190 184 195 191 184 196 226 251 196 232 251 199 196 189 202 198 191 202 226 253 203 199 193 203 229 253 203 237 252 203 237 253 204 202 196 206 202 195 206 205 204 207 203 196 208 204 197 208 205 201 212 208 200 212 208 201 212 208 202 212 209 205 213 210 202 213 212 213 214 211 206 215 212 207 216 213 206 218 215 210 220 221 223 221 219 214 222 219 215 222 220 215 230 228 225 236 235 232 243 243 244 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C@@@C@@@C@G C@_8C@?<CA?>CC??CC??CG??#G??#G??#G??#C??CC??CA?>C@?<C@_8C@G C@@@C@@@C@@@C');
                            yourself);
                yourself
        ]
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
        constantNamed:'Tools::StringSearchTool searchToolBarIcon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
U5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]PTE]WU5]WU5]WU5]W
U5]WU5]WU5%SE!!YRP5]WU5]WU5]WU5]WU5]WU2L"V@XSB2@8U5]WU5]WU5]WU5]WU5@RJ$]OB@1IV%AWU5]WU5]WU5]WU5\\JUT/@S@;LS$IU5]WU5]WU5]W
U5]WKD9L@BT%QUYJM%]WU5]WU5]WU5]WU1)"IC(%ISTPPQ5WU5]WU5]WU5]WU5\_X@(=E31BW4XCU5]WU5]WU5]WU5\%AT@(R5PTO#\G@5]WU5]WU5]WU5\%
TU02W!!-H@",NTE]WU5]WU5]WU5\%XT44HSL.DR\%V5]WU5]WU5]WU5\%QA$MO0=WU5]WU5]WU5]WU5]WU5]WIRXXAE5WU5]WU5]WU5]WU5]WU5]WU5\^ER5W
U5]WU5]WU5]WU5]WU5]WU5]WU2UWU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]W
U5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU5]WU0@a') ; colorMapFromArray:#[248 232 250 250 240 234 17 45 146 222 217 244 105 111 151 182 198 241 45 90 186 128 163 216 143 182 238 206 215 237 63 88 169 56 93 170 76 114 180 12 34 111 129 152 201 244 254 248 115 133 203 183 194 225 73 108 196 43 89 185 87 108 198 174 188 200 135 162 211 246 246 244 28 44 83 65 73 124 148 159 187 24 48 136 168 185 220 184 184 212 212 212 230 196 206 238 124 152 203 101 107 170 122 149 200 201 222 254 141 165 213 220 226 255 130 130 185 176 187 225 14 38 154 41 74 172 48 84 162 34 67 137 153 169 200 216 219 227 222 234 254 233 228 255 238 236 236 72 97 168 13 32 140 211 222 254 14 47 130 235 231 255 182 188 212 33 59 139 209 228 254 44 86 162 255 249 245 219 224 254 242 245 250 207 213 251 33 55 152 56 95 189 22 62 166 24 51 162 198 207 255 239 233 249 188 188 222 219 213 254 39 70 156 77 116 182 16 41 146 51 88 167 35 67 160 35 49 160 153 173 226 56 73 139 25 65 160 144 184 240 209 214 254 176 183 234 190 201 236 188 200 235 87 103 197 87 102 183 133 153 217 0 0 0 56 94 171 239 232 248 84 119 206 233 224 251 63 86 148 232 220 255 65 89 176 46 66 150 6 53 155 183 184 229 24 69 169]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@C@@@C@@@C@A C@G8C@O<C@_>C@_>C@_>C@_>C@_>C@?>CA?<CC?8CG8@CG0@CC @CA@@C@@@C@@@C@@@C@@@C') ; yourself); yourself]
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
        constantNamed:'Tools::StringSearchTool warningSearchBarIcon'
        ifAbsentPut:[(Depth8Image new) width:22; height:19; bits:(ByteArray fromPackedString:'
ZF!!(ZF!!(ZF!!(ZD-?1V!!(ZF!!(ZF!!(W6!!(ZF!!(ZF!!(ZE0V1:YAZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZN\ G P!!QV!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!<[)%*>X KZF!!(ZF!!(ZF!!(
ZF!!(ZF >+3V=Q##_PF!!(ZF!!(ZF!!(ZF!!(ZF"EU@0O(B*I( *;ZF!!(ZF!!(ZF!!(ZF!!(,"::Q-#0*IPA5V!!(ZF!!(ZF!!(ZF!!(\D4)Q7G2S+QY_]ZCZF!!(ZF!!(ZF!!(
3@",.MA)\%@+N/F>P3E(ZF!!(ZF!!(ZK>PTX7O<9,_"38PM<N6ZF!!(ZF!!(ZF!!W)HYO3QJS%*81"*E4A#9(ZF!!(ZF!!:T K))>B]\40&-:CR#):OZF!!(ZF #RRP<
GDQS2!! TXEL1H''R5JCI(ZF!!(4ZL6X!!.UX[D]K?#+]S;(&KB+ZF!!(Z7''D%>Y/KFQ%;^3@F*VA9CS6!!M1(C[''!!N<XE#N=&6]4@7''\IU ?7:*&QB3#5^I>< &7K
[GY''V1VRVB4CUSN\_-OA9S_KR(\?0,"*>!!$W,=S#&"\0;-\QD2WZX3%BC$J@8%7I3/Q;+U9HV _[OP@a') ; colorMapFromArray:#[84 38 40 152 54 40 204 78 90 184 54 60 248 180 170 255 194 160 160 76 80 188 92 90 220 154 160 240 222 220 160 84 70 255 234 230 188 110 110 255 226 240 200 92 80 255 200 200 252 132 130 156 62 60 255 254 240 255 186 170 20 38 40 184 62 60 168 88 90 168 28 20 108 126 130 172 32 20 248 246 240 240 180 170 208 138 130 220 234 240 208 138 140 20 12 10 184 122 130 152 84 70 228 158 160 255 242 230 176 60 50 188 108 90 224 222 220 148 22 30 140 62 60 212 130 120 255 210 210 212 180 180 255 218 220 176 56 60 168 96 90 160 172 170 144 22 30 255 242 240 236 188 180 136 14 20 172 48 50 248 168 170 172 66 40 196 62 60 255 168 170 200 96 80 228 166 160 180 52 30 164 52 40 212 130 130 255 226 220 204 48 40 240 182 170 255 250 230 192 86 70 168 86 80 252 214 200 248 200 190 244 184 180 255 200 180 188 74 80 196 120 110 212 64 60 255 172 170 0 16 10 192 116 110 28 0 0 255 200 190 16 0 0 244 146 150 180 60 70 255 248 250 184 130 120 160 30 30 248 210 210 236 132 150 176 58 60 212 136 140 192 84 90 188 64 60 252 212 220 192 98 80 188 74 70 248 254 255 236 236 240 224 202 210 168 78 60 196 100 90 240 230 240 240 240 255 255 216 230 192 66 70 0 0 0 255 242 220 255 230 220 255 208 220 196 68 70 216 66 60 168 92 100 255 202 190 255 232 240 240 202 190 76 54 50 96 114 110 152 42 50 240 228 230 192 68 70 255 240 240 200 52 50 192 84 80 255 206 200 188 90 80 244 180 190 228 116 100 128 34 40 240 152 140 200 98 80 244 230 230 200 56 40 255 214 210 120 40 40 255 248 240 244 154 150 204 50 40 172 102 100 255 174 180 255 164 160 212 196 200 255 198 190 255 188 170 140 26 30 200 136 130 204 106 120 128 58 60 180 60 60 72 82 80 248 164 160 255 224 220 0 12 10 152 68 30 132 10 20 255 208 210 160 28 30 64 58 60 128 18 20 244 238 230 144 44 50 196 42 30 255 216 210 188 62 60 212 124 130 176 82 60 208 90 100 216 230 230 180 132 110 252 204 190 240 168 180 124 28 30 180 34 20 160 94 90 184 94 90 188 86 80 204 198 200 164 88 90 140 46 50 255 252 255 252 200 200 168 26 20 208 156 160 132 20 20 224 158 160 255 244 240 255 182 170 240 134 140 255 190 180 255 230 210 200 54 40 252 192 190 192 62 50 255 222 240 184 174 180 255 140 130 188 36 30 168 66 70 188 78 60 255 240 220 180 82 50 188 104 100 184 34 20 188 96 80 244 236 240 204 64 60 255 240 255 255 248 230 188 94 80 244 214 190 248 206 180 244 164 150 212 108 110 192 106 110 168 22 20 220 140 120 152 46 30 120 20 20 240 192 190 255 238 250 192 104 90 176 86 90 204 152 150 168 124 130 244 194 200 148 62 60 255 236 230 200 68 60 196 98 80 164 22 20 255 170 170 188 62 50 220 154 120 255 236 250 208 104 110 204 122 110 128 14 20 255 246 250 40 40 50 100 104 120 136 26 30 255 188 190 216 168 170 220 98 90 96 58 60 255 254 230 188 92 80 208 74 70 144 40 40 224 100 100 255 250 250 208 130 130 176 34 20]; mask:((ImageMask new) width:22; height:19; bits:(ByteArray fromPackedString:'@C G@G0C@O0C@O8C@_8C@?<C@?<CA?>CC??CC??CC??#G??#O??3O??3_??;????????????????') ; yourself); yourself]
! !

!StringSearchTool class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::StringSearchTool andSelector:#windowSpec
     Tools::StringSearchTool new openInterface:#windowSpec
     Tools::StringSearchTool open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Tools::StringSearchTool'
          name: 'Tools::StringSearchTool'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 801 27)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'SearchBox'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              level: -1
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'closeSearchBarIcon'
                    name: 'hideSearchBarButton'
                    layout: (LayoutFrame 4 0 2 0 25 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideSearchBar
                  )
                 (LabelSpec
                    label: 'Search:'
                    name: 'SearchLabel'
                    layout: (LayoutFrame 30 0 1 0 81 0 23 0)
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'SearchEntryField'
                    layout: (LayoutFrame 87 0 1 0 298 0 23 0)
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
                    layout: (LayoutFrame 302 0 1 0 323 0 22 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: searchNextTextButtonPressed
                  )
                 (ActionButtonSpec
                    label: 'searchPreviousIcon'
                    name: 'searchPreviousButton'
                    layout: (LayoutFrame 330 0 1 0 351 0 22 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: searchPreviousTextButtonPressed
                  )
                 (CheckBoxSpec
                    label: 'Case'
                    name: 'DoNotIgnoreCaseCheckBox'
                    layout: (LayoutFrame 360 0 1 0 553 0 23 0)
                    model: matchCaseHolder
                    translateLabel: true
                  )
                 (LabelSpec
                    label: 'SearchBarImageInfoLabel'
                    name: 'SearchBarImageInfoLabel'
                    layout: (LayoutFrame 557 0 1 0 581 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    labelChannel: searchBarImageInfoLabelHolder
                  )
                 (LabelSpec
                    label: 'SearchBarInfoLabel'
                    name: 'SearchBarInfoLabel'
                    layout: (LayoutFrame 584 0 1 0 862 0 23 0)
                    translateLabel: true
                    labelChannel: searchBarInfoLabelHolder
                    adjust: left
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!StringSearchTool methodsFor:'accessing'!

closeBlock
    ^ closeBlock
!

closeBlock:something
    closeBlock := something.
!

ignoreCase

    ^ self matchCaseHolder value not
!

initialSearchString: aString  

    self searchTextHolder value: aString.
!

matchCheckboxVisible
    ^ false
!

restartSearch

    ^ self restartHolder value
!

searchNextBlock
    ^ searchNextBlock
!

searchNextBlock:something
    searchNextBlock := something.
!

searchPreviousBlock
    ^ searchPreviousBlock
!

searchPreviousBlock:something
    searchPreviousBlock := something.
!

searchText

    ^ searchTextView contents
! !

!StringSearchTool methodsFor:'aspects'!

matchCaseHolder

    matchCaseHolder isNil ifTrue:[
        matchCaseHolder := self class lastMatchCase asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       matchCaseHolder addDependent:self.
        matchCaseHolder onChangeSend:#matchCaseHolderChanged to:self.

    ].
    ^ matchCaseHolder.
!

restartHolder

    restartHolder isNil ifTrue:[
        restartHolder := self class lastRestart asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       restartHolder addDependent:self.
        restartHolder onChangeSend:#restartHolderChanged to:self.
    ].
    ^ restartHolder.
!

searchBarImageInfoLabelHolder

    searchBarImageInfoLabelHolder isNil ifTrue:[
        searchBarImageInfoLabelHolder := nil asValue .
    ].
    ^ searchBarImageInfoLabelHolder.
!

searchBarInfoLabelHolder

    searchBarInfoLabelHolder isNil ifTrue:[
        searchBarInfoLabelHolder := '' asValue .
    ].
    ^ searchBarInfoLabelHolder.
!

searchTextHolder

    searchTextHolder isNil ifTrue:[
        searchTextHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       userSelectedHolder addDependent:self.
"/       userSelectedHolder onChangeSend:#searchTextHolderChanged to:self.
    ].
    ^ searchTextHolder.
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
! !

!StringSearchTool methodsFor:'change & update'!

matchCaseHolderChanged

    self searchNextTextIncludingCurrentSelection: true.
    self setFocusToSearchTextView.
    self class lastMatchCase: self matchCaseHolder value. 
!

processEvent:anEvent
    <resource: #keyboard (#Escape #FindNext #FindPrev)>

    searchTextView hasFocus ifFalse:[^ false].

    anEvent isKeyPressEvent ifTrue:[
"/        Transcript showCR: anEvent key printString.
"/        anEvent key == #Find ifTrue:[
"/            self halt.
"/            self searchNextText.
"/            ^ true
"/        ].
        anEvent key == #Escape ifTrue:[
            self escapePressed.
            ^ true
        ].
        anEvent key == #FindNext ifTrue:[
            self searchNextText.
            ^ true
        ].
        anEvent key == #FindPrev ifTrue:[
            self searchPreviousText.
            ^ true
        ].
    ].
    ^ false
!

restartHolderChanged

    self setFocusToSearchTextView.
    self class lastRestart: self restartHolder value.
!

searchTextModifiedHolderChanged

    |previousRestart|

    "Always restart when looking for a typed string"
    previousRestart := self restartSearch.
    self restartHolder setValue: true.

    self searchNextTextIncludingCurrentSelection: true.
    self searchTextModifiedHolder setValue: false.
    self restartHolder setValue: previousRestart.


"/Transcript showCR: 'searchTextModifiedHolderChanged: ',(self searchTextHolder value ? '').
"/Transcript showCR: 'searchTextView contents: ',(self searchText ? '').

    "Created: / 15-06-2007 / 18:07:57 / Administrador"
    "Modified: / 16-06-2007 / 09:21:27 / Administrador"
! !

!StringSearchTool methodsFor:'images'!

restartSearchBarIcon

    ^ self class restartSearchBarIcon
!

warningSearchBarIcon

    ^ self class warningSearchBarIcon
! !

!StringSearchTool methodsFor:'initialization & release'!

commonPostOpen
    self windowGroup addPreEventHook:self.
    super commonPostOpen
!

postBuildSearchTextView: anEditFieldView

    searchTextView := anEditFieldView

    "Created: / 15-06-2007 / 18:17:15 / Administrador"
! !

!StringSearchTool methodsFor:'private'!

searchReachEndOrBeginningIcon

    ^ self restartSearch 
        ifTrue:[self restartSearchBarIcon.]
        ifFalse:[self warningSearchBarIcon.].
!

searchTextRestarted: message

    self searchBarImageInfoLabelHolder value: self searchReachEndOrBeginningIcon.
    self searchBarInfoLabelHolder value: message.
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

!StringSearchTool methodsFor:'public'!

escapePressed

    self hideSearchBar.
!

searchBarOpened

    self setFocusToSearchTextView.
    self selectAllInSearchTextView.
!

searchNextTextReachEnd
    |message|
    message := (resources string: 'End of text reached').
    self searchTextRestarted: message.
    Smalltalk beep.

    self restartSearch ifTrue:[
        message := message, (resources string: ', starting from the beginning').
        self searchTextRestarted: message.
        self searchNextTextFromBeginning.
    ].
!

searchPreviousTextReachBeginning
    |message|

    message := (resources string: 'Beginning of text reached').
    self searchTextRestarted: message.
    Smalltalk beep.

    self restartSearch ifTrue:[
        message := message, (resources string: ', starting from the end').
        self searchTextRestarted: message.
        self searchPreviousTextFromEnd
    ].
!

searchTextNotFound

    self searchTextNotFound: (resources string: 'Text not found').
!

searchTextNotFound: aMessage

    self searchBarImageInfoLabelHolder value: self warningSearchBarIcon.
    self searchBarInfoLabelHolder value: aMessage.
    self setSearchTextNotFoundColors.

    "Created: / 16-06-2007 / 06:51:01 / Administrador"
    "Modified: / 16-06-2007 / 11:43:53 / Administrador"
!

searchTextStarted

    self searchBarImageInfoLabelHolder value: nil.
    self searchBarInfoLabelHolder value: ''.
    self setSearchTextFoundColors.

    "Created: / 16-06-2007 / 06:54:03 / Administrador"
    "Modified: / 16-06-2007 / 10:07:06 / Administrador"
!

selectAllInSearchTextView

    searchTextView selectAllInitially.
!

setFocusToSearchTextView

    searchTextView requestFocus.
! !

!StringSearchTool methodsFor:'searching'!

hideSearchBar

    closeBlock isNil ifTrue:[^ self].
    closeBlock value
!

searchNextText

    self searchNextTextIncludingCurrentSelection: false.
"/    self setFocusToSearchTextView.
!

searchNextTextButtonPressed

    self searchNextText.
    self setFocusToSearchTextView.
!

searchNextTextFromBeginning
    |searchText ignoreCase|

    searchText := self searchText.
    searchText isEmptyOrNil ifTrue:[^self].
    ignoreCase := self ignoreCase.
    searchNextBlock isNil ifTrue:[^ self].
    searchNextBlock value: self value: searchText value: ignoreCase value: #beginning

"/    self parent
"/            searchNextTextFromBeginning: searchText 
"/            ignoreCase: ignoreCase 
!

searchNextTextIncludingCurrentSelection: includeCurrentSelection
    |searchText ignoreCase startPlace|

    self searchTextStarted.
    searchText := self searchText.
    searchText isEmptyOrNil ifTrue:[^self].
    ignoreCase := self ignoreCase.
    searchNextBlock isNil ifTrue:[^ self].
    startPlace := includeCurrentSelection ifTrue:[#current] ifFalse:[#includingCurrent].
    searchNextBlock value: self value: searchText value: ignoreCase value: startPlace 

"/    self parent 
"/            searchNextText: searchText 
"/            ignoreCase: ignoreCase 
"/            includingCurrentSelection: includeCurrentSelection.
!

searchPreviousText

    |searchText ignoreCase|

    self searchTextStarted.
    searchText := self searchText.      
"/    self setFocusToSearchTextView.
    searchText isEmptyOrNil ifTrue:[^self].
    ignoreCase := self ignoreCase.
    searchPreviousBlock isNil ifTrue:[^ self].
    searchPreviousBlock value: self value: searchText value: ignoreCase value: #current.

"/    self parent 
"/            searchPreviousText: searchText 
"/            ignoreCase: ignoreCase 
!

searchPreviousTextButtonPressed

    self searchPreviousText.
    self setFocusToSearchTextView.
!

searchPreviousTextFromEnd

    |searchText ignoreCase|

    searchText := self searchText.
    searchText isEmptyOrNil ifTrue:[^self].
    ignoreCase := self ignoreCase.
    searchPreviousBlock isNil ifTrue:[^ self].
    searchPreviousBlock value: self value: searchText value: ignoreCase value: #end

"/    self parent
"/            searchPreviousTextFromEnd: searchText 
"/            ignoreCase: ignoreCase 
! !

!StringSearchTool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

