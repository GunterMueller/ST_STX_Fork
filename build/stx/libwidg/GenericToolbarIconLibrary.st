"
 COPYRIGHT (c) 2001 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

Object subclass:#GenericToolbarIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!GenericToolbarIconLibrary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    A common place to keep commonly used icons.
    (also: VW compatibility)

    Every method found here returns as value an image instance, which can be
    directly used for labels, menus, etc.
    The use of external files for bitmap images is no longer considered good style,
    and all uses of them within ST/X are replaced by internal icons over the time.
    (the reason is that it makes packaging, deployment etc. much easier. 
    Also, systems which have a poor disk performance for small files (aka Windows) 
    suffer from accessing many small bitmap files. So performance is improved there).

    Notice: 
        now, ToolbarIconLibrary is a reference to the actual IconLibrary,
        which will refer to either this class (GenericToolbarIconLibrary) or
        one of its subclasses (especially: XPToolbarIconLibrary).

    The choice of which concrete iconLibrary class is actually used
    is done in the styleSheet, where the global variable ToolbarIconLibrary
    is set (see mswindowsXP.style as an example). By redefining individual icons
    in that concrete class, different view styles may provide different looks
    (try windowsXP vs. Windows95 looks, to see different icons).
    Please make sure, that no concrete icon library is used in specs (window and menu
    specs); only refer to ToolbarIconLibrary there, so you won't loose the ability to
    change the look with another icon library.
"
! !

!GenericToolbarIconLibrary class methodsFor:'class initialization'!

initialize
    ToolbarIconLibrary isNil ifTrue:[
        ToolbarIconLibrary := self
    ]
! !

!GenericToolbarIconLibrary class methodsFor:'compatibility-VW'!

visualFor:aKey
    ^ self perform:aKey ifNotUnderstood:[nil]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs'!

barResizeHorizontalIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self barResizeHorizontalIcon inspect
     ImageEditor openOnClass:self andSelector:#barResizeHorizontalIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class barResizeHorizontalIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:11;
                height:19;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@B@A@@@A@B@A@@@A@@@A@@@A@@@!!H@B!!J@J!!J B!!JC@!!H@@A@@@A@@@A@@@A@@@A@@@A@@@@@A');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:11;
                            height:19;
                            bits:(ByteArray 
                                        fromPackedString:'@A<DG0P_AA<DG0P_AA<UG3V_]]<5''1T_AA<DG0P_AA<DG0P_@A<b');
                            yourself);
                yourself
        ]
!

barResizeVerticalIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self barResizeVerticalIcon inspect
     ImageEditor openOnClass:self andSelector:#barResizeVerticalIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class barResizeVerticalIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:19;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@B@@@@@@*@@@@@J*@@@@@@@@@AUUUUUP@@@@@@@@@*(@@@@@*@@@@@@ @@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:19;
                            height:11;
                            bits:(ByteArray 
                                        fromPackedString:'@@@S@D@@@N@@@_@@@@@A_??@@@@@@_@@@N@@@D@D@@@H');
                            yourself);
                yourself
        ]
!

bookmarks17x18
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bookmarks17x18 inspect
     ImageEditor openOnClass:self andSelector:#bookmarks17x18
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary bookmarks17x18'
        ifAbsentPut:[(Depth4Image width:17 height:18) bits:(ByteArray fromPackedString:'
DQDQDQDQDQDPDQDQDQDQDQDVDQDQDA@QDQDPDQDQDC@QDQDPDQDQ@2LADQDPDQDQ@2LADQDPDP@@L"H0@ADPDCL3H"H#L0HPDPH"H"H"H DPDQ@!!DQDQHADP
DQDBDQDR@QDPDQDBDQDR@QDQDQDBDRDR@QDQDQ@1H H!!LADTDQ@"@A@BHADPDRD@DQDP@RDPDQHQDQDQD!!DQDQDQDQDQDQDP') colorMapFromArray:#[240 76 0 240 151 26 255 213 5 245 234 120] mask:((ImageMask width:17 height:18) bits:(ByteArray fromPackedString:'@@@@@H@@@\@@@\@@@>@@@>@@_?<@_?<@O?8@G?0@C? @C? @C? @G?0@G70@OA8@D@P@@@@@'); yourself); yourself]
!

checkToggleOffEnteredIcon
    <resource: #programImage>

    ^ self checkToggleOffIcon
!

checkToggleOffIcon
    <resource: #programImage>

    ^ self checkToggleOff13x13Icon
!

checkToggleOnEnteredIcon
    <resource: #programImage>

    ^ self checkToggleOnIcon
!

checkToggleOnIcon
    <resource: #programImage>

    ^ self checkToggleOn13x13Icon
!

clearConsoleIcon
    <resource: #programImage>

    ^ self clearConsole22x22Icon
!

directoryOpen18x18Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directoryOpen18x18Icon inspect
     ImageEditor openOnClass:self andSelector:#directoryOpen18x18Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class directoryOpen18x18Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:18;
                height:18;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@EMST5MS@IJRA0\G@@@@@@AST5MST5MSRQ=M)''MGMUA%L8>O#8=ST5MS]1^B (HW\WEZ]Q%[-H=ST5MS]8JB (JBEHJB (JB (=ST5MS
]5QTUEQTUEQTM $IBP$IBP$I](NC 8NC 8LIW@8$S4=NOC0%LXRDT"@F#8=!!^WM3\7N%_WHBF3>.+Z!!O)0UDP$IBP$JJRC @LE]#YB"B (JB (JB $HA''7AS
]F6V)B\''I2\''I2\''I2]Y$P5SWP>3"ADQDQDQDQDQDQDS&%MSQ'')KUUUUUUUUUUUUU[H *UMSF"HH,[F1,[F1,V-QHY@;T5MS(;L-!!XVE W8K*$TLJ)L@T5MS
QVE**71&QS-0G AST5MST5MSQTT9DJ@@T5MST5MST5MST5MST5MST5MST5MST5MST5MST5MS');
                colorMapFromArray:#[ 254 201 107 255 238 154 231 208 160 194 135 4 196 136 7 255 255 199 209 157 23 209 166 33 255 242 193 217 175 45 217 158 32 217 165 32 201 152 48 248 240 224 255 255 238 231 172 54 209 168 80 255 242 119 255 221 103 251 230 118 255 254 147 255 212 110 255 201 106 255 252 167 238 221 165 255 251 187 191 130 2 197 139 10 255 233 177 203 146 20 239 224 192 247 238 206 222 173 41 222 177 44 213 165 49 239 239 231 255 255 237 213 174 74 235 177 62 255 252 128 255 255 136 255 202 86 218 184 112 255 224 122 230 206 136 255 225 139 255 217 142 191 131 2 196 138 8 198 140 12 202 144 16 213 167 32 202 143 11 217 176 45 226 197 61 222 159 31 213 174 59 192 136 16 241 240 236 205 160 64 255 255 248 248 183 66 222 189 103 255 198 83 122 152 175 255 252 150 255 255 159 234 213 147 255 255 176 189 129 1 192 131 3 242 230 186 255 255 202 204 147 20 204 151 25 247 237 204 251 244 211 255 255 222 255 242 213 255 255 230 238 209 79 238 199 71 242 198 74 255 255 255 255 251 127 255 229 108 255 204 88 255 191 80 255 206 103 255 238 140 238 217 147 255 252 173 238 222 173 193 135 4 198 140 11 201 144 16 204 146 19 242 230 193 247 237 203 217 154 26 251 247 217 230 196 63 197 138 6 241 242 237 217 175 68 247 238 109 242 191 74 251 216 94 242 187 79 247 188 80 255 206 95 255 238 135 222 192 127 234 209 143 238 222 156 255 255 189 194 136 6 251 242 188 201 143 14 203 146 19 202 147 21 255 255 213 213 154 28 222 166 36 213 156 24 255 255 229 234 187 59 238 197 70 252 248 240 247 202 80 255 255 129 255 230 109 255 213 96 255 212 94 238 211 121 230 203 129 255 246 158 255 255 172 255 238 167 192 132 4 197 138 9 201 142 13 203 145 18 202 151 29 202 146 13 213 173 46 213 159 38 235 216 176 217 169 52 238 222 89 217 173 66 240 244 246 247 209 86 0 0 0 213 176 96 255 206 89 255 189 76 248 194 95 136 162 181 247 238 154 227 200 144 255 252 181 191 130 1 191 129 1 255 254 196 255 238 187 255 255 206 255 255 212 247 238 207 243 232 208 202 144 11 226 169 41 240 240 233 213 173 70 238 181 57 251 247 119 255 238 116 255 222 103 255 199 84 226 197 119 255 254 154 ];
                mask:((ImageMask new)
                            width:18;
                            height:18;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_@@@??0@??0@??0@???@???@???@??>@??>@??>@??<@??<@??8@??0@?<@@>@@@@@@@');
                            yourself);
                yourself
        ]
!

directoryOpenHalfGrey18x18Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self directoryOpenHalfGrey18x18Icon inspect
     ImageEditor openOnClass:self andSelector:#directoryOpenHalfGrey18x18Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary directoryOpenHalfGrey18x18Icon'
        ifAbsentPut:[(Depth8Image new) width:18; height:18; bits:(ByteArray fromPackedString:'
/+:>/+:>/+:>/+:>/%MST5MS/,WE2L#H/+:>/+9ST5MST5MS-;V:/L&8.\R?-,GA0\EST5MS.;7@0LB=3L3C1,/G/\EST5MS.<C@0LC@/\C@0LC@0LEST5MS
.<7M3\7M3\5TM $IBP$IBP$I4L;N3,;N3,8IW@8$S4=NOC0%4]_W42@F#8=!!^WM3\7N%_WHB5-#]+Z!!O)0UDP$IBP$JJRC @4-M#YB"B (JB (JB $HA''7AS
5]*V)B\''I2\''I2\''I2]Y$P5S5M&3"ADQDQDQDQDQDQDS&%MSQ'')KUUUUUUUUUUUUU[H *UMSF"HH,[F1,[F1,V-QHY@;T5MS(;L-!!XVE W8K*$TLJ)L@T5MS
QVE**71&QS-0G AST5MST5MSQTT9DJ@@T5MST5MST5MST5MST5MST5MST5MST5MST5MST5MS') ; colorMapFromArray:#[254 201 107 255 238 154 231 208 160 194 135 4 196 136 7 255 255 199 209 157 23 209 166 33 255 242 193 217 175 45 217 158 32 217 165 32 201 152 48 248 240 224 255 255 238 231 172 54 209 168 80 255 242 119 255 221 103 251 230 118 255 254 147 255 212 110 255 201 106 255 252 167 238 221 165 255 251 187 191 130 2 197 139 10 255 233 177 203 146 20 239 224 192 247 238 206 222 173 41 222 177 44 213 165 49 239 239 231 255 255 237 213 174 74 235 177 62 255 252 128 255 255 136 255 202 86 218 184 112 255 224 122 230 206 136 255 225 139 255 217 142 191 131 2 196 138 8 198 140 12 202 144 16 213 167 32 202 143 11 217 176 45 226 197 61 222 159 31 213 174 59 192 136 16 241 240 236 205 160 64 255 255 248 248 183 66 222 189 103 255 198 83 122 152 175 255 252 150 255 255 159 234 213 147 255 255 176 189 129 1 192 131 3 242 230 186 255 255 202 204 147 20 204 151 25 247 237 204 251 244 211 255 255 222 255 242 213 255 255 230 238 209 79 238 199 71 242 198 74 255 255 255 255 251 127 255 229 108 255 204 88 255 191 80 255 206 103 255 238 140 238 217 147 255 252 173 238 222 173 193 135 4 198 140 11 201 144 16 204 146 19 242 230 193 247 237 203 217 154 26 251 247 217 230 196 63 197 138 6 241 242 237 217 175 68 247 238 109 242 191 74 251 216 94 242 187 79 247 188 80 255 206 95 255 238 135 222 192 127 234 209 143 238 222 156 255 255 189 194 136 6 251 242 188 201 143 14 203 146 19 202 147 21 255 255 213 213 154 28 222 166 36 213 156 24 255 255 229 234 187 59 238 197 70 252 248 240 247 202 80 255 255 129 255 230 109 255 213 96 255 212 94 238 211 121 230 203 129 255 246 158 255 255 172 255 238 167 192 132 4 197 138 9 201 142 13 203 145 18 202 151 29 202 146 13 213 173 46 213 159 38 235 216 176 217 169 52 238 222 89 217 173 66 240 244 246 247 209 86 0 0 0 213 176 96 255 206 89 255 189 76 248 194 95 136 162 181 247 238 154 227 200 144 255 252 181 191 130 1 191 129 1 255 254 196 255 238 187 255 255 206 255 255 212 247 238 207 243 232 208 202 144 11 226 169 41 240 240 233 213 173 70 238 181 57 251 247 119 255 238 116 255 222 103 255 199 84 226 197 119 255 254 154 237 237 237 167 167 167 151 151 151 229 229 229 175 175 175 252 252 252 150 150 150 250 250 250 244 244 244 207 207 207 193 193 193 242 242 242 154 154 154 244 244 244 216 216 216 205 205 205 163 163 163 239 239 239 245 245 245 166 166 166 248 248 248 244 244 244 246 246 246 210 210 210 240 240 240 225 225 225 150 150 150 147 147 147 145 145 145 142 142 142 199 199 199 139 139 139 140 140 140 143 143 143 214 214 214 204 204 204 178 178 178 195 195 195 199 199 199 214 214 214 186 186 186]; mask:((ImageMask new) width:18; height:18; bits:(ByteArray fromPackedString:'@@@@_@@@??0@??0@??0@???@???@???@??>@??>@??>@??<@??<@??8@??0@?<@@>@@@@@@@') ; yourself); yourself]
!

editOverlay
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self editOverlay inspect
     ImageEditor openOnClass:self andSelector:#editOverlay
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class editOverlay'
        ifAbsentPut:[(Depth4Image width:11 height:13) bits:(ByteArray fromPackedString:'@@@@@J.0@@@@@K-P@@@@B;UP@@@@.5UP@@@K-UU0@@B;UU]@@@,%UWZ @@H%U6* @KH"I@* @BH''\@* BR]0@@* A$@@@@* @@@@@@* ')
            colorMapFromArray:#[0 0 0 255 255 255 255 220 168 220 220 220 64 0 0 255 128 0 48 48 48 192 88 0 195 195 195 88 88 88 160 160 160 255 168 88]
            mask:((ImageMask width:11 height:13) bits:(ByteArray fromPackedString:'@F@@8@G @>@G8@? G<@_ C<@O A8@F@@@@@b'); yourself); yourself]
!

onOffSliderIconOff
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self onOffSliderIconOff inspect
     ImageEditor openOnClass:self andSelector:#onOffSliderIconOff
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class onOffSliderIconOff'
        ifAbsentPut:[(Depth8Image width:25 height:13) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+AA8^HQ(]GQ4]GQ4]BR<"AP@@@@@@@AXPDBLUE2()G (KB0,KB0 HBP$Y@@@@@@@^I1<SD1LSD1T^C2D!!
HRDOB!!(KB@D@@@@ HQ,SD0HB@!!LSCRD''LC@0I28^HQ(-@@@@IR8\A0HB@ HBA2P,I1,[J@@#CB\PF @@@B8''A \B@ HB@ \TK"8$IBP_E1,)I2DE@@@%I1PF
@ HB@ H\IB80EAPTC#D$F00,@@@@HB\*E@XB@!!L\E@@PJ!!PTEAPTLQ\MIP@@@@@0LBPNC!!PNC!!<''I3D1LSD1LSDWCQH@@@@@E#@''@A<_E0@''I1TUEQTUEQTU
@B@@@@@@@@@@@2\''I2\.I2\''I2\''I2\''IQD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[189 189 190 215 218 214 255 255 255 172 172 173 118 120 119 227 228 228 248 248 248 251 251 251 36 37 37 21 22 24 71 71 75 50 50 50 160 158 159 180 182 187 238 238 239 82 80 80 103 103 103 207 207 207 225 226 219 254 254 254 242 241 242 209 209 211 233 233 236 216 217 217 250 250 250 168 169 168 59 60 61 200 200 200 244 244 245 9 12 15 109 109 109 222 223 223 217 215 214 91 90 91 122 122 122 178 177 178 229 229 229 161 161 163 250 250 251 139 139 139 191 196 200 171 170 171 202 204 206 179 179 179 117 118 118 109 111 110 128 128 128 58 58 58 149 149 150 233 233 234]
            mask:((ImageMask width:25 height:13) bits:(ByteArray fromPackedString:'@@@@_0??>G<???1?O??>_7???''=???9?_???_7???''=???9?O??>_3???G<O??!!?@@@@_0@a'); yourself); yourself]
!

onOffSliderIconOn
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self onOffSliderIconOn inspect
     ImageEditor openOnClass:self andSelector:#onOffSliderIconOn
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class onOffSliderIconOn'
        ifAbsentPut:[(Depth8Image width:25 height:13) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"MA<8NC 8NC 8NA8OKR4GD0@@@@@@@@@*N@@7M3\7M3\7G"4FI $9H0<D@@@@@@@H@C\/B0,KE0,WE2D''
@0LC@0L&KPP@@@@$G2<KE0(]GQ4]GQTE@0L2L#HC@1H*D0@@CR<WGR (LB,+J2,!!E 82L#H2L 8.G@P@@A0WGR +MST)JR$)HQ$NL#H2L#HNDCXG@@@LB" +
JR@ HB@ HBDPFSH2L#H2E"86A@@@IA4+MR@ HB@ HB@%NQ@YL#HCE!!@3C0H@@@@XJ2$ HB@ HB@ DQ(.N#(PN#(''HP\@@@@@@CD5JR$)JR$)JR$1HSL''I0$3
HP4@@@@@@@@@KATUEQTUEQTUEQT6M"D6M!!P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[21 22 24 250 250 251 215 218 223 254 254 254 155 160 165 200 200 200 178 177 178 137 134 128 118 120 119 216 217 217 65 85 109 28 55 81 161 161 163 143 143 146 251 251 251 103 103 103 242 241 242 119 160 203 180 182 187 227 228 228 194 193 190 96 113 136 244 244 245 47 69 95 109 127 148 248 248 248 149 149 150 233 233 236 117 118 118 76 98 126 59 60 61 36 37 37 107 159 232 139 139 139 179 179 179 171 170 171 217 215 214 126 141 161 209 209 211 222 223 223 83 113 165 100 159 211 91 90 91 88 135 188 172 172 173 109 109 109 229 229 229 21 41 61 85 110 182 116 133 181 255 255 255 189 189 190 74 77 81 93 151 201 128 128 128 15 28 42 9 12 15 202 204 206 238 238 239]
            mask:((ImageMask width:25 height:13) bits:(ByteArray fromPackedString:'@@@@_0??>G<_??1?O??>_7???7=???=?_???_7???7=???=?O??>_1???G<O??!!?@@@@_0@a'); yourself); yourself]
!

radioOffDisabledIcon
    <resource: #programImage>

    ^ self radioOffDisabled17x17Icon    
!

radioOffEnteredIcon
    <resource: #programImage>

    ^ self radioOffIcon
!

radioOffIcon
    <resource: #programImage>

    ^ self radioOff17x17Icon
!

radioOnDisabledIcon

    <resource: #programImage>

    ^ self radioOnDisabled17x17Icon
!

radioOnEnteredIcon
    <resource: #programImage>

    ^ self radioOnIcon
!

radioOnIcon
    <resource: #programImage>

    ^ self radioOn17x17Icon
!

scrollDownOffIcon
    <resource: #programImage>

    ^ self scrollDownOff16x16Icon
!

scrollLeftOffIcon
    <resource: #programImage>

    ^ self scrollLeftOff16x16Icon
!

scrollLockIcon
    <resource: #programImage>

    ^ self scrollLock22x22Icon
!

scrollRightOffIcon
    <resource: #programImage>

    ^ self scrollRightOff16x16Icon
!

scrollUpOffIcon
    <resource: #programImage>

    ^ self scrollUpOff16x16Icon
!

shiftToggleOff26x15
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self shiftToggleOff26x15 inspect
     ImageEditor openOnClass:self andSelector:#shiftToggleOff26x15
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary shiftToggleOff26x15'
        ifAbsentPut:[(Depth8Image new) width:26; height:15; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F @TE@@(EQTUEQTUEQTJC0@@@@@@@@@@@APTFRT[IQ$T
J1 XFA XBP$UEQX@@@@@@@@THRP*J"(*J!!,TG@@@@@@\J2 XBP@@@@@@E0@AJ"(*J"(*J!!<@HQHRD"DQA @(G @@@@@NDR$HJ"(*J"(H@0X!!@PD HA<LHQP(
@@@@@AD!!GQ4*J"(*J!!4&DQDCA@P$F0DYHP@@@@@@C"D&JR(*J"(*JPLQD"X&I \BA@DLA @@@@@WHRT&JR(*J"$&HAP%I"X&I"XBF1<#@@@@@@@RD PBA2XG
@"P!!HPHB@ HB@ L[G1@@@@@@@@@RHR@$IBP_HRD%IRT%IRT%IR@W@@@@@@@@@@@''HRD!!HQD!!HRD!!HRD!!HRDND@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[94 94 94 201 201 201 235 237 237 231 232 232 225 227 229 235 235 236 119 119 119 239 239 239 252 252 252 37 37 37 74 77 80 242 247 250 161 161 160 250 250 250 150 151 153 122 124 127 223 225 218 128 128 128 150 150 151 212 216 210 106 106 105 16 20 24 170 172 173 213 212 210 51 50 51 172 173 173 176 176 177 214 216 216 83 80 81 251 250 251 88 90 91 182 183 186 191 192 193 139 139 139 227 228 227 169 168 169 220 222 223 207 207 209 243 243 243 172 171 171 59 60 60 246 247 247 255 255 255 68 72 75]; mask:((Depth1Image new) width:26; height:15; bits:(ByteArray fromPackedString:'@@@@@@@@@@@G?? @C??>@A??? @???<@O???@C???0@???<@O???@A???0@O??8@A??<@@@@@@@@@@@@') ; yourself); yourself]
!

shiftToggleOnBlue26x15
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self shiftToggleOnBlue26x15 inspect
     ImageEditor openOnClass:self andSelector:#shiftToggleOnBlue26x15
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary shiftToggleOnBlue26x15'
        ifAbsentPut:[(Depth8Image new) width:27; height:15; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_C@(-KR4WKR4-KS\TA1PQHP@@@@@@@@@@@CHWE1\#
H2L#H2L@EAH)L2$REA$@@@@@@@@@EA\#H2\''I1TUEQT^I HB@ HBL1PM@@@@@@@XB"LUBP$0LC@0LB A@ HB@ HB@#T2HP@@@@@OI1T0GQ4DA@PDAA8.NPHB
@ HBNPLGG0@@@@@GES@]AB0,K2</K186M HB@ HBM"(VDP@@@@@OBQ4DK2H"H"H"H!!8*K HB@ HBK LVCP@@@@@XL@P,H"H"H"H"H!!L)J"8B@ H.J"@TF0@@
@@@@IPP/H"H"H"H"H!!(\AS HJ  8I!!8P@@@@@@@@@BP,K2</K2</K2<$G"@&I"X5G#D@@@@@@@@@@@@+JB (JB (JB (JAXVG!!XVB0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[68 72 75 201 201 201 255 255 255 231 232 232 97 132 184 225 227 229 235 235 236 119 119 119 239 239 239 65 85 109 37 37 37 197 198 199 74 77 80 146 148 149 250 250 250 150 151 153 129 129 129 126 122 111 172 173 173 136 149 166 106 106 105 46 68 94 128 128 128 16 20 24 213 212 210 162 162 163 119 156 198 214 219 227 150 150 151 88 115 164 139 139 139 176 176 177 191 192 193 227 228 227 113 161 232 19 34 51 120 140 179 114 131 152 220 222 223 28 52 77 100 118 137 207 207 209 243 243 243 172 171 171 96 152 199 2 2 2 246 247 247 103 160 209 68 101 141 143 143 144 94 94 94 214 216 216 242 247 250 182 183 186 251 250 251 59 60 60 235 237 237 252 252 252]; mask:((Depth1Image new) width:27; height:15; bits:(ByteArray fromPackedString:'@@@@@@@@@@@G??0@C??>@A???0@???>@O??? C???8@???>@O??? A???0@O??8@A??<@@@@@@@@@@@@') ; yourself); yourself]
!

sortIndicatorGreyIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortIndicatorGreyIcon inspect
     ImageEditor openOnClass:self andSelector:#sortIndicatorGreyIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary sortIndicatorGreyIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:5;
                            bits:(ByteArray fromPackedString:'@A@(UJ(b');
                            yourself);
                yourself
        ]
!

sortIndicatorIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortIndicatorIcon inspect
     ImageEditor openOnClass:self andSelector:#sortIndicatorIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary sortIndicatorIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:4;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@B@0 @a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:4;
                            bits:(ByteArray fromPackedString:'?''08D@@a');
                            yourself);
                yourself
        ]
!

sortReverseIndicatorGreyIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortReverseIndicatorGreyIcon inspect
     ImageEditor openOnClass:self andSelector:#sortReverseIndicatorGreyIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary sortReverseIndicatorGreyIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:5;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:5;
                            bits:(ByteArray fromPackedString:'*%P(D@@b');
                            yourself);
                yourself
        ]
!

sortReverseIndicatorIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sortReverseIndicatorIcon inspect
     ImageEditor openOnClass:self andSelector:#sortReverseIndicatorIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary sortReverseIndicatorIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:7;
                height:4;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'0(@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:7;
                            height:4;
                            bits:(ByteArray fromPackedString:'DC!!<? @a');
                            yourself);
                yourself
        ]
!

warn16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self warn16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#warn16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class warn16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@B@@@@@@@@@BH@@@@@@@@@H"@@@@@@@@H"H@@@@@@@@"D"@@@@@@@"DRH@@@@@@BH@D"@@@@@BHP@RH@@@@@H!!@AD"@@@@H!!D@DRH@@@@"DP@QD"@@@"
DQDQDRH@@BHQD@DQD"@BHQDP@QDRH@H"H"H"H"H"H"H"H"H"H"Hb')
            colorMapFromArray:#[0 0 0 255 255 255 255 0 0]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@H@A @G@@<@C8@_ A?@O<@?8G? _?C?<O?9??''????<b'); yourself); yourself]
!

warn32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self warn32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#warn32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class warn32x32Icon'
        ifAbsentPut:[(Depth4Image width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@@@@H @@@@@@@@@@@@@@@@@@@BH@@@@@@@@@@@@@@@@@@@H"H@@@@@@@@@@@@@@@@@@BH"@@@@@@@@@@@@@@@@@@H"H"@@@@@@@@@@@@@@@@@BH"H 
@@@@@@@@@@@@@@@@H"H"H @@@@@@@@@@@@@@@BH"H"H@@@@@@@@@@@@@@@H"HQH"H@@@@@@@@@@@@@@BH"DRH"@@@@@@@@@@@@@@H"HQDRH"@@@@@@@@@@@@
@BH"D@D"H @@@@@@@@@@@@H"HP@@D"H @@@@@@@@@@@BH"D@@AH"H@@@@@@@@@@@H"HQ@@@QH"H@@@@@@@@@@BH"DP@@DRH"@@@@@@@@@@H"HQD@@ADRH"@@
@@@@@@@BH"DQ@@@QD"H @@@@@@@@H"HQDP@@DQD"H @@@@@@@BH"DQD@@ADQH"H@@@@@@@H"HQDQ@@@QDQH"H@@@@@@BH"DQDQ@ADQDRH"@@@@@@H"HQDQDQ
DQDQDRH"@@@@@BH"DQDQD@DQDQD"H @@@@H"HQDQDP@@DQDQD"H @@@BH"DQDQD@@ADQDQH"H@@@H"HQDQDQD@DQDQDQH"H@@BH"DQDQDQDQDQDQDRH"@@H"
H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"Hb')
            colorMapFromArray:#[0 0 0 255 255 255 255 0 0]
            mask:((ImageMask width:32 height:32) bits:(ByteArray fromPackedString:'
@@F@@@@A @@@@<@@@@O@@@@G8@@@A>@@@@?0@@@O<@@@G? @@A?8@@@??@@@O?0@@G?>@@A?? @@??<@@O??@@G??8@A??>@@???0@O??<@G??? A???8@??
??@O???0G???>A???? ????<O????G????9????>??????????<b'); yourself); yourself]
!

worldIcon25_25
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self worldIcon25_25 inspect
     ImageEditor openOnClass:self andSelector:#worldIcon25_25
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary worldIcon25_25'
        ifAbsentPut:[(Depth8Image new) width:25; height:25; bits:(ByteArray fromPackedString:'
IRT%IRT%IS2&S&)V*0-VTV:2IRT%IRT%IRT%IRT%G*E"ZDJEQ36Y%S@:KTV2IRT%IRT%IRT%W4IOC$<IX")=_T\0N)6D( 0%IRT%IRT%RVE(W)=B-@8*O$^U
(%%;''SJDA2T%IRT%W6 9Z"(NBR,>]GQ4 25Y^96]L(R0IRT%,)QSU#4=OV%)GA(''BU09VW.]''SH2JKH%IR2QK(X=OYZVZU]NX+Q!!NU%;''Y42 ZMQIPE<$R:''
OS6V''46_I4I!!XS%Y^96]L(F,!!@1PX9FQ)34=OY<CI6J4XVEYVW.]''SJA+JL O4"Q$X"''OQ%V-KQ!!XVD9VS);''SH2 Z2#^S]HX9FQK(Y\X$<NX&D(S3(Q!!I42
 XF, TAZPT"Q$X"UWI!!>B:6"HZ8:N(P2L(F, [FLM4EHX6NK&E%YVYH_K0UTLY6]L#H2+@5,D56$PTEZXIM;^5$:XF=3!!I6]]WV[YAZBSF4&"TDOY)6]''SD1
LSF]''XRDL#JGYH<8PD1J+:"I"RP2L)6]''Y6]''SH2@(\2P8BI#60;EV:MV8&(@CH2L#H2L#H2L(]5)QBO"U,;H!!,%DS-["W^Z''SH2L#JA XF,(9@S"U,J(I8%
ITT"H *OSAL4MXF,+J2,+@ZWB ("(G**IRT%FJ@"B )[N;F,+J2A!!8D6N3,"(G(S@RT%IW=U^*B H#-UA*2, XD5URI:^''B)""T%IRT%QQM0^''* ^)2,+HD2
MW!!DQ PPQRT%IRT%IRU?JU!!0\@PV+J2,(15KR6\)_2T%IRT%IRT%IRV3T(92L92#E6-2#%J3IRT%IRT%IRT%IRT%IRTH]# #YQH8\QP%IRT%IRT%IP@a') ; colorMapFromArray:#[224 224 60 224 240 255 160 192 140 208 240 160 0 80 190 80 160 210 224 224 50 224 240 220 160 208 220 176 224 180 16 80 240 80 160 220 240 240 240 192 224 80 192 224 180 32 112 220 32 112 210 176 208 140 48 128 180 48 112 210 160 192 220 96 128 220 176 208 100 192 208 60 64 112 210 80 176 240 112 208 220 160 176 240 64 208 255 64 128 140 255 255 240 32 144 220 208 224 210 208 224 130 16 64 220 64 128 180 112 176 180 0 0 0 128 176 190 224 240 160 176 208 160 64 128 210 96 192 220 160 208 190 160 208 255 208 224 140 48 160 255 64 144 210 144 192 180 240 240 60 224 240 50 64 144 180 96 144 180 192 224 60 128 176 130 64 128 240 48 128 210 240 240 110 224 240 100 16 80 220 255 255 220 64 176 255 80 192 240 112 176 240 160 192 130 32 112 255 208 224 160 128 176 140 80 128 180 176 208 220 16 80 190 64 176 240 32 128 255 240 255 210 80 128 190 64 128 160 32 96 220 160 224 210 224 240 180 160 208 180 176 208 255 208 224 190 48 144 210 128 176 220 160 208 140 48 96 210 128 192 210 128 208 220 0 96 210 240 240 100 48 128 240 16 80 255 192 224 160 96 144 210 144 192 210 240 255 220 192 224 130 240 240 130 224 240 140 48 128 255 80 144 190 64 144 160 80 144 210 0 96 190 224 240 130 96 192 240 176 208 180 96 160 140 32 96 210 64 128 190 224 240 210 208 224 110 0 80 210 96 160 220 0 112 210 192 224 110 64 192 240 176 208 130 112 160 220 112 160 160 64 112 180 160 192 190 0 64 210 240 240 80 80 144 240 64 192 255 96 176 210 208 224 240 32 96 240 224 240 30 160 192 100 80 176 220 208 224 100 112 176 220 64 160 240 208 224 60 48 144 240 16 96 255 208 224 220 64 144 220 144 192 140 112 160 180 16 112 210 16 96 240 192 224 100 48 144 255 128 192 180 224 240 80 128 192 220 64 160 220 80 192 255 112 160 140 160 208 160 48 176 240 208 224 80 96 160 180 192 208 80 224 240 60 48 96 220 144 208 210 0 64 220 224 240 190 192 224 140 208 224 50 32 96 255 144 192 130 240 240 210 64 160 255 48 112 220 32 112 190 144 160 220 112 192 220 224 240 20 112 176 210 224 240 110 192 208 190 224 240 240 144 176 130 240 240 255 144 192 220 240 240 140]; mask:((ImageMask new) width:25; height:25; bits:(ByteArray fromPackedString:'@_?@_0_?<G<O??!!?G??<_3???''=???=?_???_?????????????????????????????????????????????????????=???=?_???_3???7<???9?G??<_0??
>G<C?>A?@O>@_0@a') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-09x09'!

breakpointBlueDisabled9x9
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self breakpointBlueDisabled9x9 inspect
     ImageEditor openOnClass:self andSelector:#breakpointBlueDisabled9x9
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary breakpointBlueDisabled9x9'
        ifAbsentPut:[
            (Depth4Image new)
                width:9;
                height:9;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'H$QDQBADX7M$HDZTQIY@RDQDRDA@QDQ@PD!!DQD!!@R%QDV$@$(PF$HDQDQDH ');
                colorMapFromArray:#[ 79 80 79 85 85 85 255 255 255 135 135 135 227 235 248 122 122 122 201 201 201 105 105 105 98 98 98 103 103 103 182 182 182 ];
                mask:((ImageMask new)
                            width:9;
                            height:9;
                            bits:(ByteArray fromPackedString:'@@@>@G\@X0AA@FL@]0@>@@@@');
                            yourself);
                yourself
        ]
!

breakpointBlueEnabled9x9
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self breakpointBlueEnabled9x9 inspect
     ImageEditor openOnClass:self andSelector:#breakpointBlueEnabled9x9
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary breakpointBlueEnabled9x9'
        ifAbsentPut:[
            (Depth8Image new)
                width:9;
                height:9;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'D1L@@@@@@@@SD0@J@0HCB @S@@<ABP,I@P<@@@LHDQDQB@L@@@HDCP0RA@H@@@LEC 8NAPL@@@<AA!!@G@P<@D0@J@0HCB @@D0@@@@@@@ALS');
                colorMapFromArray:#[ 255 252 255 46 85 127 38 78 114 54 98 139 108 165 203 107 159 195 131 175 205 130 174 204 130 172 200 152 185 208 169 202 225 180 209 229 83 149 190 90 154 194 115 169 204 144 188 216 145 188 215 152 193 219 89 154 192 255 255 255 ];
                mask:((ImageMask new)
                            width:9;
                            height:9;
                            bits:(ByteArray fromPackedString:'@@@>@G<@_0A?@G<@_0@>@@@@');
                            yourself);
                yourself
        ]
!

breakpointDisabled9x9
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self breakpointRedDisabled9x9 inspect
     ImageEditor openOnClass:self andSelector:#breakpointRedDisabled9x9
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary breakpointRedDisabled9x9'
        ifAbsentPut:[
            (Depth4Image new)
                width:9;
                height:9;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:1;
                bits:(ByteArray 
                            fromPackedString:'H$QDQBADX7M$HDZTQIY@RDQDRDA@QDQ@PD!!DQD!!@R%QDV$@$(PF$HDQDQDH ');
                colorMapFromArray:#[ 79 80 79 85 85 85 255 255 255 135 135 135 227 235 248 122 122 122 201 201 201 105 105 105 98 98 98 103 103 103 182 182 182 ];
                mask:((ImageMask new)
                            width:9;
                            height:9;
                            bits:(ByteArray fromPackedString:'@@@>@G\@X0AA@FL@]0@>@@@@');
                            yourself);
                yourself
        ]
!

breakpointDisabledWithWarning9x9
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self breakpointRedDisabledWithWarning9x9 inspect
     ImageEditor openOnClass:self andSelector:#breakpointRedDisabledWithWarning9x9
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary breakpointRedDisabledWithWarning9x9'
        ifAbsentPut:[
            (Depth4Image width:9 height:9)
                bits:(ByteArray 
                            fromPackedString:'DTQDQB@QX7M$HAFTQIY@DTQDRD@QQDQ@PAEDQD!!@R%QDV$@Q(@B$HAEDQDH ')
                    colorMapFromArray:#[ 79 80 79 255 0 0 255 255 255 135 135 135 227 235 248 122 122 122 201 201 201 105 105 105 98 98 98 103 103 103 182 182 182 ]
                    mask:((ImageMask width:9 height:9)
                            bits:(ByteArray fromPackedString:'0@C>@O\@80CA@NL@]0C>@L@@');
                            yourself);
                yourself
        ]
!

breakpointRedEnabled9x9
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self breakpointRedEnabled9x9 inspect
     ImageEditor openOnClass:self andSelector:#breakpointRedEnabled9x9
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary breakpointRedEnabled9x9'
        ifAbsentPut:[
            (Depth8Image new)
                width:9;
                height:9;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'D1L@@@@@@@@SD0@J@0HCB @S@@<ABP,I@P<@@@LHDQDQB@L@@@HDCP0RA@H@@@LEC 8NAPL@@@<AA!!@G@P<@D0@J@0HCB @@D0@@@@@@@ALS');
                colorMapFromArray:#[ 253 255 252 127 73 46 114 60 38 139 79 54 203 129 108 195 127 107 205 147 131 204 146 130 200 145 130 208 165 152 225 182 169 229 191 180 190 104 83 194 111 90 204 134 115 216 159 144 215 159 145 219 166 152 192 108 89 255 255 255 ];
                mask:((ImageMask new)
                            width:9;
                            height:9;
                            bits:(ByteArray fromPackedString:'@@@>@G<@_0A?@G<@_0@>@@@@');
                            yourself);
                yourself
        ]
!

breakpointRedEnabledWithWarning9x9
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self breakpointRedEnabledWithWarning9x9 inspect
     ImageEditor openOnClass:self andSelector:#breakpointRedEnabledWithWarning9x9
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary breakpointRedEnabledWithWarning9x9'
        ifAbsentPut:[(Depth8Image width:9 height:9) bits:(ByteArray fromPackedString:'D1L@@@@@@@@SD1LJ@0HCB @SD1LABP,I@P<@D1LHDQDQB@L@D1LDCP0RA@H@D1LEC 8NAPL@@@<AA!!@G@P<@D1LJ@0HCB @@D1L@@@@@@ALS')
            colorMapFromArray:#[253 255 252 127 73 46 114 60 38 139 79 54 203 129 108 195 127 107 205 147 131 204 146 130 200 145 130 208 165 152 225 182 169 229 191 180 190 104 83 194 111 90 204 134 115 216 159 144 215 159 145 219 166 152 192 108 89 255 0 0]
            mask:((ImageMask width:9 height:9) bits:(ByteArray fromPackedString:'0@C>@O<@?0C?@O<@_0C>@L@@'); yourself); yourself]
!

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
        constantNamed:'GenericToolbarIconLibrary class closeIndicatorInTree9x9Icon'
        ifAbsentPut:[(Depth2Image new) width: 9; height: 9; photometric:(#palette); bitsPerSample:(#(2)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'UUU@Z*)@Z")@Z")@X@I-Z")@Z")KZ*)@UUU;') ; colorMapFromArray:#[0 0 0 128 128 128 255 255 255]; yourself]
!

fullBreakPoint9x9Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fullBreakPoint9x9Icon inspect
     ImageEditor openOnClass:self andSelector:#fullBreakPoint9x9Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fullBreakPoint9x9Icon'
        ifAbsentPut:[(Depth4Image new) width:9; height:9; bits:(ByteArray fromPackedString:'L0L3@C@0Y5] L@:8FK8@M9DQ%3@54@CULC_AD\\0C+)B/ @0Y5] @@@CL0@@') ; colorMapFromArray:#[255 255 255 196 96 86 164 75 67 176 176 176 182 74 66 79 34 26 193 90 78 96 47 37 171 87 78 158 77 70 165 75 67 88 43 32 148 68 60 159 65 56 184 74 65]; mask:((Depth1Image new) width:9; height:9; bits:(ByteArray fromPackedString:'G@@>@G<@?8C? O>@_0@>@A0@') ; yourself); yourself]
!

lineBreakPoint9x9Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lineBreakPoint9x9Icon inspect
     ImageEditor openOnClass:self andSelector:#lineBreakPoint9x9Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary lineBreakPoint9x9Icon'
        ifAbsentPut:[(Depth4Image new) width:9; height:9; bits:(ByteArray fromPackedString:'L0L3@C@0Y5] L@:8FK8@M9DQ%3@54QGULC_AD\\0C+)B/ @0Y5] @C@CL0L0') ; colorMapFromArray:#[255 255 255 196 96 86 164 75 67 176 176 176 182 74 66 79 34 26 193 90 78 96 47 37 171 87 78 158 77 70 165 75 67 88 43 32 148 68 60 159 65 56 184 74 65]; mask:((Depth1Image new) width:9; height:9; bits:(ByteArray fromPackedString:'G@@>@G<@?8C? O>@_0@>@A0@') ; yourself); yourself]
!

lineTracePoint9x9Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lineTracePoint9x9Icon inspect
     ImageEditor openOnClass:self andSelector:#lineTracePoint9x9Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary lineTracePoint9x9Icon'
        ifAbsentPut:[(Depth4Image width:9 height:9) bits:(ByteArray fromPackedString:'L0L3@C@0Y5] L@:8FK8@M9DQ%3@54QGULC_AD\\0C+)B/ @0Y5] @C@CL0L0') colorMapFromArray:#[255 255 255 86 186 196 67 156 164 176 176 176 66 174 182 26 71 79 78 181 193 37 86 96 78 162 171 70 151 158 67 157 165 32 77 88 60 140 148 56 150 159 65 175 184] mask:((Depth1Image width:9 height:9) bits:(ByteArray fromPackedString:'G@@>@G<@?8C? O>@_0@>@A0@'); yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary openIndicatorInTree9x9Icon'
        ifAbsentPut:[(Depth2Image new) width:9; height:9; bits:(ByteArray fromPackedString:'UUU@Z*)@Z*)(Z*)HX@I@Z*)@Z*)@Z*)@UUU.') ; colorMapFromArray:#[0 0 0 128 128 128 255 255 255]; yourself]
!

stopPoint9x9
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stopPoint9x9 inspect
     ImageEditor openOnClass:self andSelector:#stopPoint9x9
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary stopPoint9x9'
        ifAbsentPut:[(Depth4Image new) width:9; height:9; bits:(ByteArray fromPackedString:'L0L3@C@0Y5] L@:8FK8@M9DQ%3@54@CULC_AD\\0C+)B/ @0Y5] @C@CL0L0') ; colorMapFromArray:#[255 255 255 196 96 86 164 75 67 176 176 176 182 74 66 79 34 26 193 90 78 96 47 37 171 87 78 158 77 70 165 75 67 88 43 32 148 68 60 159 65 56 184 74 65]; mask:((Depth1Image new) width:9; height:9; bits:(ByteArray fromPackedString:'G@@>@G<@?8C? O>@_0@>@A0@') ; yourself); yourself]
!

tracepointBlue9x9
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self tracepointBlue9x9 inspect
     ImageEditor openOnClass:self andSelector:#tracepointBlue9x9
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary tracepointBlue9x9'
        ifAbsentPut:[
            (Depth8Image new)
                width:9;
                height:9;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'D1L@@@@@@@@SD0@J@0HCB @S@@<ABP,I@P<@@@LHDQDQB@L@@@HDCP0RA@H@@@LEC 8NAPL@@@<AA!!@G@P<@D0@J@0HCB @@D0@@@@@@@ALS');
                colorMapFromArray:#[ 254 252 255 46 104 127 38 96 114 54 118 139 108 187 203 107 179 195 131 193 205 130 192 204 130 188 200 152 198 208 169 215 225 180 220 229 83 174 190 90 178 194 115 189 204 144 205 216 145 204 215 152 208 219 89 178 192 255 255 255 ];
                mask:((ImageMask new)
                            width:9;
                            height:9;
                            bits:(ByteArray fromPackedString:'@@@>@G<@_0A?@G<@_0@>@@@@');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-10x11'!

ledDarkRed14x14
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledDarkRed14x14 inspect
     ImageEditor openOnClass:self andSelector:#ledDarkRed14x14
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary ledDarkRed14x14'
        ifAbsentPut:[(Depth8Image new) width: 14; height: 14; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@0DA@0HA@@@@@@DAA@TFA0\FAPPA@@@@@P IB ,LC@,JBP A@@@ACP8ODADQD@<NCPD@@@DRD1PU
E!!XUEALR@P@@@Q\XFQ([F1,\FA\A@@@AGQ ^G2@!!HRHXGPD@@@D#IBT&I2\(IRP#@P@@@PD)G2(+J20 KPDA@@@@@PD.K3@0K28A@PD@@@@@@PD1L#H1@PD@
@@@@@@@@@PDA@PDA@P@@@@@a') ; colorMapFromArray:#[76 94 60 46 12 10 90 75 80 64 39 40 80 59 60 60 1 0 92 52 50 106 68 70 90 74 75 62 1 0 104 56 55 118 86 85 126 103 105 68 37 40 82 18 20 106 48 50 110 58 60 106 47 45 56 11 10 92 7 5 98 15 15 104 24 25 106 24 25 60 10 10 90 0 0 104 8 10 110 9 10 112 9 10 106 8 10 72 33 35 114 0 0 118 0 0 120 0 0 122 0 0 116 0 0 88 63 65 92 0 0 127 15 15 127 4 5 127 12 10 127 6 5 94 45 45 127 35 35 127 52 50 127 41 40 96 45 45 98 56 60 110 28 30 122 20 20 90 93 95 86 89 95]; mask:((ImageMask new) width: 14; height: 14; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@?@G>@?<C?0O?H?<C?0O?@_8@?@A8@@@@@a') ; yourself); yourself]
!

ledGrayedRed10x11
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self ledGrayedRed10x11 inspect
     ImageEditor openOnClass:self andSelector:#ledGrayedRed10x11
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary ledGrayedRed10x11'
        ifAbsentPut:[
            (Depth8Image new)
                width:10;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@DB@0DA@0HA@@DDAPXGA0XEA@DHBP(KC@0KB $HCP8ODADQD@<NCQHSEATVE!!TTD1HWFA$ZF1,[GA WGQ ^G2@!!HRHXGRL$IRX''I2 %IBLAJQ<*J2,,HB4A
@PD.K3@0K28A@P@A@SD2L#DA@P@b');
                colorMapFromArray:#[ 165 174 157 150 133 132 172 165 167 159 147 147 167 157 157 157 128 127 173 153 152 180 161 162 172 164 165 158 128 127 179 155 155 186 170 170 190 179 180 161 146 147 168 136 137 180 151 152 182 156 157 180 151 150 155 133 132 173 131 130 176 135 135 179 139 140 180 139 140 157 132 132 172 127 127 179 131 132 182 132 132 183 132 132 180 131 132 163 144 145 184 127 127 186 127 127 187 127 127 188 127 127 185 127 127 171 159 160 173 127 127 191 135 135 191 129 130 191 133 132 191 130 130 174 150 150 191 145 145 191 153 152 191 148 147 175 150 150 176 155 157 182 141 142 188 137 137 172 174 175 170 172 175 ];
                mask:((ImageMask new)
                            width:10;
                            height:11;
                            bits:(ByteArray fromPackedString:'O0A? O?@?<C?0O?@?<C?0G>@O0@^@@@a');
                            yourself);
                yourself
        ]
!

ledGrayedRed14x14
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledGrayedRed14x14 inspect
     ImageEditor openOnClass:self andSelector:#ledGrayedRed14x14
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary ledGrayedRed14x14'
        ifAbsentPut:[(Depth8Image new) width: 14; height: 14; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@0DA@0HA@@@@@@DAA@TFA0\FAPPA@@@@@P IB ,LC@,JBP A@@@ACP8ODADQD@<NCPD@@@DRD1PU
E!!XUEALR@P@@@Q\XFQ([F1,\FA\A@@@AGQ ^G2@!!HRHXGPD@@@D#IBT&I2\(IRP#@P@@@PD)G2(+J20 KPDA@@@@@PD.K3@0K28A@PD@@@@@@PD1L#H1@PD@
@@@@@@@@@PDA@PDA@P@@@@@a') ; colorMapFromArray:#[165 174 157 150 133 132 172 165 167 159 147 147 167 157 157 157 128 127 173 153 152 180 161 162 172 164 165 158 128 127 179 155 155 186 170 170 190 179 180 161 146 147 168 136 137 180 151 152 182 156 157 180 151 150 155 133 132 173 131 130 176 135 135 179 139 140 180 139 140 157 132 132 172 127 127 179 131 132 182 132 132 183 132 132 180 131 132 163 144 145 184 127 127 186 127 127 187 127 127 188 127 127 185 127 127 171 159 160 173 127 127 191 135 135 191 129 130 191 133 132 191 130 130 174 150 150 191 145 145 191 153 152 191 148 147 175 150 150 176 155 157 182 141 142 188 137 137 172 174 175 170 172 175]; mask:((ImageMask new) width: 14; height: 14; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@?@G>@?<C?0O?H?<C?0O?@_8@?@A8@@@@@a') ; yourself); yourself]
!

ledGreen10x11
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self ledGreen10x11 inspect
     ImageEditor openOnClass:self andSelector:#ledGreen10x11
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary ledGreen10x11'
        ifAbsentPut:[
            (Depth8Image new)
                width:10;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
K @+A0@@A2,@K @Q@QT/K1TADP@*@"T:P4L:IPH*B ,#LBX&LBLKB LIC!!HSFAHNBPLDAP<TFQ,[D@TDCP ZG2\)KA0FCR LKSD4M#H-CB @GQX7PTT;E2D@
@C .G"@$H"88@B8@@CT3L3T@@B8b');
                colorMapFromArray:#[ 24 86 20 32 110 0 36 116 0 40 108 20 48 114 20 60 172 0 72 172 0 76 128 80 76 172 0 76 174 10 80 134 80 80 156 40 88 164 0 92 144 70 96 188 30 104 200 20 108 200 20 116 158 120 116 198 50 120 202 50 120 206 20 124 180 100 124 198 0 124 200 0 124 202 50 124 208 20 124 214 0 128 210 20 128 214 0 132 174 90 132 196 60 132 218 0 132 218 40 136 176 90 136 198 60 136 206 100 136 224 60 140 204 110 140 208 100 140 220 0 144 178 130 144 222 0 148 182 150 148 182 160 148 224 0 148 230 0 152 188 120 156 206 140 156 216 120 156 234 0 164 236 0 172 178 190 176 240 30 180 186 190 184 244 40 184 244 70 188 194 200 192 200 210 192 234 170 192 248 90 196 202 210 208 216 220 212 218 230 212 220 230 216 222 230 216 255 120 220 226 240 220 248 210 224 232 240 224 255 130 ];
                mask:((ImageMask new)
                            width:10;
                            height:11;
                            bits:(ByteArray fromPackedString:'O0A? O?@?<C?0O?@?<C?0G>@_8@^@@@a');
                            yourself);
                yourself
        ]
!

ledGrey10x11
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self ledGrey10x11 inspect
     ImageEditor openOnClass:self andSelector:#ledGrey10x11
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary ledGrey10x11'
        ifAbsentPut:[
            (Depth8Image new)
                width:10;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@B@0PD@0H@@@@EA \HB@\FAP@IB ,LCP4LB0(IC1@QD!!LTD!!DPC1XWFA$ZF1$\E1X^G2@!!H"L#IA<^I"\(JR(+J2 ,I"4.K1H0LSH/K#L@MSX7NC$:M#,@
@C0=O#=@PS4<@@@@@DP3L4P@@@@b');
                colorMapFromArray:#[ 170 170 170 235 235 235 179 179 179 123 123 123 83 83 83 154 154 154 105 105 105 178 178 178 203 203 203 179 179 179 111 111 111 197 197 197 226 226 226 241 241 241 230 230 230 132 132 132 151 151 151 197 197 197 208 208 208 199 199 199 200 200 200 225 225 225 107 107 107 163 163 163 177 177 177 187 187 187 188 188 188 189 189 189 175 175 175 221 221 221 118 118 118 159 159 159 184 184 184 189 189 189 192 192 192 193 193 193 185 185 185 218 218 218 146 146 146 163 163 163 194 194 194 197 197 197 198 198 198 201 201 201 162 162 162 176 176 176 160 160 160 206 206 206 217 217 217 220 220 220 210 210 210 177 177 177 201 201 201 168 168 168 182 182 182 225 225 225 240 240 240 242 242 242 229 229 229 169 169 169 192 192 192 181 181 181 183 183 183 200 200 200 206 206 206 184 184 184 217 217 217 198 198 198 184 184 184 ];
                mask:((ImageMask new)
                            width:10;
                            height:11;
                            bits:(ByteArray fromPackedString:'O0A? O?@?<C?0O?@?<C?0G>@_8@^@@@a');
                            yourself);
                yourself
        ]
!

ledRed10x11
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self ledRed10x11 inspect
     ImageEditor openOnClass:self andSelector:#ledRed10x11
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary ledRed10x11'
        ifAbsentPut:[
            (Depth8Image new)
                width:10;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
B@@OAP@@AP<@B@@I@!!L#H1LBBP@NAA41MST1GPPNA ("JRD!!JRHJA DRFA0 HA0XD DCCQ,''J2,+G04CA04-LCH3L2<MA00QNSX8NC\9DP0@EC@:OC0;L!!X@
@@@YJCP4JA$@@@ @@A@KB1@@@@ b');
                colorMapFromArray:#[ 92 24 20 112 22 20 120 2 0 120 20 20 124 2 0 128 78 80 136 74 80 144 66 70 152 188 120 160 118 120 164 36 40 172 178 190 176 126 130 180 0 0 180 148 150 180 150 160 180 186 190 184 0 0 184 14 10 184 104 100 188 90 90 188 194 200 192 90 90 192 200 210 196 30 30 196 112 120 196 202 210 208 16 20 208 48 50 208 112 110 208 216 220 212 16 20 212 48 50 212 94 90 212 96 100 212 136 140 212 218 230 212 220 230 216 222 230 220 18 20 220 56 60 220 116 120 220 226 240 224 18 20 224 232 240 228 0 0 228 236 250 232 0 0 236 0 0 236 172 170 240 0 0 244 0 0 244 40 40 252 206 210 255 8 10 255 12 10 255 24 20 255 30 30 255 70 70 255 82 80 255 104 100 ];
                mask:((ImageMask new)
                            width:10;
                            height:11;
                            bits:(ByteArray fromPackedString:'O0A? O?@?<C?0O?@?<C?0G>@O0@^@@@a');
                            yourself);
                yourself
        ]
!

ledYellow10x11
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self ledYellow10x11 inspect
     ImageEditor openOnClass:self andSelector:#ledYellow10x11
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary ledYellow10x11'
        ifAbsentPut:[
            (Depth8Image new)
                width:10;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@P@R@ @@@!!H@@P@JA2L3L2LGB @SBS@?QTT?L@$SAQ,2NSP6NSH[APL%JR0.K20(IPLHIB,1MS\7KRPHCRH8N#,<OC !!CP< OS9AP$@=HA@@EB)CQ$]DJ!!T@
@@,QGBX''GQDK@@D@@@XDA@X@@@Db');
                colorMapFromArray:#[ 144 64 20 152 188 120 168 108 80 172 90 20 172 178 190 180 118 80 180 186 190 184 84 0 184 102 20 188 92 0 188 144 120 188 194 200 192 200 210 196 134 70 196 202 210 200 172 130 200 174 130 200 182 120 204 170 160 204 172 150 208 162 90 208 164 90 208 216 220 212 218 230 212 220 230 216 222 230 220 226 240 224 134 40 224 184 60 224 186 60 224 232 240 228 236 250 236 150 0 236 152 0 236 154 0 236 162 100 240 146 0 240 150 10 244 206 40 244 212 60 248 164 30 248 166 30 252 178 0 252 178 20 252 178 50 252 180 20 252 180 50 252 182 50 252 184 110 252 186 20 252 186 100 252 190 140 255 188 100 255 190 20 255 190 100 255 192 20 255 196 0 255 200 120 255 202 0 255 204 0 255 208 0 255 216 0 255 220 0 255 222 170 255 224 0 255 230 30 255 234 40 255 236 70 255 240 90 255 240 210 255 254 120 255 255 130 ];
                mask:((ImageMask new)
                            width:10;
                            height:11;
                            bits:(ByteArray fromPackedString:'O0A? O?@?<C?0O?@?<C?0G>@_8@^@@@a');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-12x12'!

dart12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self dart12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#dart12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary dart12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@ @@@@@@@@@@@@ FB0(@@@@@@@@@D@(KB0,O@@@@@@@ZGA8^G!!8^G0@@@@@!!B2P%IRT%IR,@@BD%H0,$IRT%IR(''MBT^B0,KIBT%IR<*@B8^H0,K
B2P%IRT*@@@9B0,KB0,$IRT*@@@@OADFA ,KO"T*@@@@@A@IO@XFA$ME@@@@@@@PD@$IDC,@');
                colorMapFromArray:#[ 0 0 0 176 216 240 48 208 200 15 216 184 144 216 224 48 216 200 0 208 184 31 216 200 191 216 240 95 216 208 0 216 184 0 208 176 16 216 184 143 216 224 32 216 200 0 224 200 80 216 208 15 208 184 79 216 200 47 176 200 0 168 208 0 152 200 0 152 184 0 160 200 16 168 200 112 192 240 95 160 216 0 192 208 15 168 184 0 112 200 0 120 200 0 160 240 31 176 240 0 128 208 0 184 184 0 216 176 0 160 184 0 128 200 0 144 208 0 168 240 15 168 240 32 144 208 0 160 224 0 168 224 15 168 224 95 168 216 0 136 208 0 152 216 0 176 184 16 168 224 47 144 208 15 160 224 47 152 208 15 128 200 31 136 208 16 136 208 16 144 208 0 136 216 31 184 200 160 224 224 63 216 200 32 208 184 0 168 184 111 216 208 0 176 240 31 168 224 31 208 184 15 176 200 79 184 224 143 208 240 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'@ @O@A>@O<@?8G?0??A?<C?0G?@O<@_ ');
                            yourself);
                yourself
        ]
!

iconEqual12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconEqual12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconEqual12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconEqual12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@PHC@0PEA \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\D0$IG2@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHC@0PE
A \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\D0$IG2@ @@@@@@@@@@@@@@@@') ; colorMapFromArray:#[255 248 250 96 160 50 0 160 0 0 176 0 16 176 20 32 160 30 32 144 20 0 128 0 0 112 0 0 96 0 144 224 130 176 240 140 192 240 160 160 240 130 144 224 110 128 208 100 96 208 80 80 192 60 64 160 50 16 80 0 128 224 110 144 240 110 144 240 130 128 224 100 112 208 80 96 192 80 64 176 60 48 160 50 16 80 20 32 96 20 16 128 20 0 80 0 16 64 20]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@/?<O?5??G?<@@@@@C?<O?6??G?<@@@') ; yourself); yourself]
!

iconEqualGray12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconEqualGray12x12  inspect
     Icon flushCachedIcons
    "

    <resource: #programImage>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconEqualGray12x12'
        ifAbsentPut:[self iconEqual12x12 asGrayImageDepth: 8]

    "Created: / 31-08-2011 / 10:53:15 / cg"
!

iconEqualOrange12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconEqualOrange12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconEqualOrange12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconEqualOrange12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@PHC@0PEA \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\D0$IG2@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHC@0PE
A \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\D0$IG2@ @@@@@@@@@@@@@@@@') ; colorMapFromArray:#[255 255 255 197 104 70 203 139 0 224 153 0 224 165 20 203 149 38 183 118 25 163 111 0 142 97 0 122 83 0 243 227 207 252 237 231 255 253 253 251 232 219 240 205 184 227 191 164 224 188 141 210 163 110 197 141 70 102 49 0 240 213 184 249 218 196 251 237 219 239 203 173 224 178 141 211 176 134 202 165 98 198 158 66 102 81 20 122 76 25 163 124 20 102 70 0 81 67 20]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@/?<O?5??G?<@@@@@C?<O?6??G?<@@@') ; yourself); yourself]
!

iconEqualYellow12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconEqualYellow12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconEqualYellow12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconEqualYellow12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@PHC@0PEA \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\D0$IG2@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHC@0PE
A \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\D0$IG2@ @@@@@@@@@@@@@@@@') ; colorMapFromArray:#[255 255 255 197 144 70 203 203 0 224 224 0 218 224 20 203 201 38 183 168 25 163 163 0 142 142 0 122 122 0 243 238 207 252 244 231 255 254 253 251 242 219 240 223 184 227 211 164 224 214 141 210 195 110 197 181 70 102 81 0 240 231 184 249 235 196 251 247 219 239 224 173 224 204 141 211 200 134 202 198 98 196 198 66 97 102 20 122 107 25 157 163 20 102 102 0 76 81 20]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@/?<O?5??G?<@@@@@C?<O?6??G?<@@@') ; yourself); yourself]
!

iconExclaRed12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconExclaRed12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconExclaRed12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary iconExclaRed12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
EQTUEP8LA04UEQTUEQTUEP,TD (UEQTUEQTUEP(RD0LUEQTUEQTUEPXSD@TUEQTUEQTUEPPPDPHUEQTUEQTUEPDQC0HUEQTUEQTUEP$B@@ UEQTUEQTUEQTU
EQTUEQTUEQTUEP8LA04UEQTUEQTUEP,TD (UEQTUEQTUEPDQC0HUEQTUEQTUEP$B@@ UEQTU') ; colorMapFromArray:#[80 0 31 80 0 15 80 16 24 100 0 16 110 0 22 100 16 26 110 16 30 140 20 56 110 80 103 110 60 75 130 16 33 160 16 39 160 32 56 160 80 111 180 60 100 160 48 68 190 60 106 180 52 86 210 100 148 210 80 120 240 132 165 250 251 255]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0,O@@<EC0DO@@<@C0@@@@<FC0DO@@<@') ; yourself); yourself]
!

iconMinus12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconMinus12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconMinus12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconMinus12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHC@0PEA \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\
D0$IG2@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[255 248 250 96 160 50 0 160 0 0 176 0 16 176 20 32 160 30 32 144 20 0 128 0 0 112 0 0 96 0 144 224 130 176 240 140 192 240 160 160 240 130 144 224 110 128 208 100 96 208 80 80 192 60 64 160 50 16 80 0 128 224 110 144 240 110 144 240 130 128 224 100 112 208 80 96 192 80 64 176 60 48 160 50 16 80 20 32 96 20 16 128 20 0 80 0 16 64 20]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@,@@@@E@@G?<O?0??C?<@@F@@D@@@@@') ; yourself); yourself]
!

iconMinusGray12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconMinusGray12x12  inspect
     Icon flushCachedIcons
    "

    <resource: #programImage>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconMinusGray12x12'
        ifAbsentPut:[self iconMinus12x12 asGrayImageDepth: 8]

    "Created: / 31-08-2011 / 10:54:22 / cg"
!

iconMinusRed12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconMinusRed12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconMinusRed12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary iconMinusRed12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHC@0PEA \HBP$IAP(KC@,MC <PDQHSAQPUE!!XNE1 YF!!,\GP\GA18\
D0$IG2@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[248 248 255 160 50 56 160 59 0 176 65 0 176 79 16 160 76 30 144 53 20 128 47 0 112 41 0 96 35 0 224 150 130 240 141 140 240 160 163 240 140 130 224 118 110 208 112 100 208 111 80 192 88 60 160 76 50 80 13 0 224 134 110 240 124 110 240 156 130 224 117 100 208 95 80 192 105 80 176 99 60 160 91 48 80 43 16 96 36 20 128 61 16 80 29 0 64 38 16]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@,@@@@E@@G?<O?0??C?<@@F@@D@@@@@') ; yourself); yourself]
!

iconPlus12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconPlus12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconPlus12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconPlus12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@DB@0P@@@@@@@@@@@TFA0 @@@@@@@@@@@$JB0 @@@@@@@@@@@$LCP8@@@@@C1@QDP$LCP8RD1LS@!!PJEP(VCP\WFA$Z@ ,[A XMGA4^G2@!!H 8NC  G
E1LSH2P$@@@@@BTWFBX@@@@@@@@@@AHXI2D@@@@@@@@@@BL''HBD@@@@@@@@@@B !!F"$@@@@@') ; colorMapFromArray:#[255 248 250 80 176 60 32 160 30 32 144 20 96 160 80 16 160 20 144 240 130 128 208 100 16 128 20 16 176 20 176 240 140 128 224 110 176 240 160 144 224 110 0 128 0 96 160 50 0 160 0 0 176 0 0 112 0 0 96 0 144 224 130 192 240 160 160 240 130 96 208 80 80 192 60 64 160 50 16 80 0 144 240 110 128 224 100 112 208 80 96 192 80 64 176 60 48 160 50 16 80 20 32 96 20 0 80 0 16 64 20 16 112 20 16 96 20 64 176 50 64 112 60 96 112 80]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0,O@@<EC0G?<O?0??C?<@<FC0DO@@<@') ; yourself); yourself]
!

iconPlusBlue12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconPlusBlue12x12 inspect
     ImageEditor openOnClass:self andSelector:#iconPlusBlue12x12
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary iconPlusBlue12x12'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@DB@0P@@@@@@@@@@@TFA0 @@@@@@@@@@@$JB0 @@@@@@@@@@@$LCP8@@@@@C1@QDP$LCP8RD1LS@!!PJEP(VCP\WFA$Z@ ,[A XMGA4^G2@!!H 8NC  G
E1LSH2P$@@@@@BTWFBX@@@@@@@@@@AHXI2D@@@@@@@@@@BL''HBD@@@@@@@@@@B !!F"$@@@@@') ; colorMapFromArray:#[253 255 248 60 126 176 30 84 160 20 82 144 80 128 160 16 70 160 130 188 240 100 171 208 16 57 128 16 76 176 140 216 240 110 174 224 160 208 240 110 190 224 0 51 128 50 140 160 0 64 160 0 70 176 0 45 112 0 38 96 130 182 224 160 224 240 130 204 240 80 147 208 60 133 192 50 108 160 0 48 80 110 196 240 100 178 224 80 163 208 80 141 192 60 110 176 48 91 160 16 38 80 20 62 96 0 32 80 16 31 64 16 50 112 16 44 96 50 114 176 60 85 112 80 109 112]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0,O@@<EC0G?<O?0??C?<@<FC0DO@@<@') ; yourself); yourself]
!

iconPlusGray12x12
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self iconPlusGray12x12  inspect
     Icon flushCachedIcons
    "

    <resource: #programImage>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class iconPlusGray12x12'
        ifAbsentPut:[self iconPlus12x12 asGrayImageDepth: 8]

    "Created: / 31-08-2011 / 10:54:27 / cg"
!

javascript12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self javascript12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#javascript12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary javascript12x12Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
S0@@E1\WE1\KHA]O@@, E!!XVJ2ELSAML@AXVJ0!!LD1LSU18SPR-LD1LLG!!8RD!!HRBALSG!!HLR ,KB4)JD1H=MT)NR"H[SB]UD5T\T$\KC -VJ4\NA2X@GC!!D
ID0;@BHNA2YG@@0+C @L@D\EU4YFATX2Q#<;Q$YFU4YFQ$YFQ$YFQ$YFS4YFQ$YFQ$YFQ$X@');
                colorMapFromArray:#[ 240 255 255 96 128 160 112 160 190 128 160 190 144 160 180 112 128 190 176 176 180 192 208 210 208 224 220 176 176 220 240 255 240 240 240 240 255 255 255 255 240 255 96 128 180 112 160 210 160 176 190 128 128 180 176 192 210 192 208 220 160 160 210 192 208 240 224 224 240 240 240 255 96 96 140 128 160 180 144 144 160 144 160 190 144 144 180 144 144 190 176 192 220 208 208 210 224 240 240 208 208 240 224 224 255 128 128 140 112 144 180 112 112 160 128 144 190 160 160 180 176 176 190 160 176 220 192 192 210 208 224 240 208 224 255 128 144 140 112 112 140 128 144 160 128 128 160 160 176 180 112 144 210 160 160 190 112 128 210 176 176 210 240 240 220 224 240 255 112 128 140 96 144 180 96 112 160 96 128 190 96 112 180 160 192 210 144 176 220 128 144 210 192 224 240 224 224 220 96 128 140 96 112 140 255 240 240 112 128 160 112 144 190 112 128 180 144 176 210 176 208 220 160 176 210 240 255 220 208 208 220 255 240 220 255 255 240 0 0 0 96 144 190 144 176 190 128 144 180 128 160 210 160 192 220 144 160 210 224 240 220 192 192 220 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'_>C?<O?0??C?<O?0??C?<O?0??C?<G? ');
                            yourself);
                yourself
        ]
!

padLockBlack12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self padLockBlack12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#padLockBlack12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class padLockBlack12x12Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'?0C??F$?<TEO<S1O<@@O2**#2UUS2TES2VES2UUS<@@O????');
                colorMapFromArray:#[ 0 0 0 63 63 63 127 127 127 255 255 255 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray 
                                        fromPackedString:'
C0@_ C?@N\@?0G? _>A?8G? _>@?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

padLockBlue12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self padLockBlue12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#padLockBlue12x12Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class padLockBlue12x12Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'?0C??F$?<TEO<S1O<@@O2**#2UUS2TES2VES2UUS<@@O????');
                colorMapFromArray:#[ 0 0 0 128 128 255 212 212 255 255 255 255 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray 
                                        fromPackedString:'
C0@_ C?@N\@?0G? _>A?8G? _>@?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

padLockGray12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self padLockGray12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#padLockGray12x12Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class padLockGray12x12Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'?0C??F$?<TEO<S1O<@@O2**#2UUS2TES2VES2UUS<@@O????');
                colorMapFromArray:#[ 0 0 0 128 128 128 212 212 212 255 255 255 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray 
                                        fromPackedString:'
C0@_ C?@N\@?0G? _>A?8G? _>@?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

padLockGreen12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self padLockGreen12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#padLockGreen12x12Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class padLockGreen12x12Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'?0C??F$?<TEO<S1O<@@O2**#2UUS2TES2VES2UUS<@@O????');
                colorMapFromArray:#[ 0 0 0 128 255 128 212 255 212 255 255 255 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray 
                                        fromPackedString:'
C0@_ C?@N\@?0G? _>A?8G? _>@?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

padLockRed12x12Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self padLockRed12x12Icon inspect
     ImageEditor openOnClass:self andSelector:#padLockRed12x12Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class padLockRed12x12Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'?0C??F$?<TEO<S1O<@@O2**#2UUS2TES2VES2UUS<@@O????');
                colorMapFromArray:#[ 0 0 0 255 128 128 255 212 212 255 255 255 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray 
                                        fromPackedString:'
C0@_ C?@N\@?0G? _>A?8G? _>@?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-13x13'!

checkToggleOff13x13Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOff13x13Icon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOff13x13Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary checkToggleOff13x13Icon'
        ifAbsentPut:[(Depth8Image width:13 height:13) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@GA0\GA0\GA0\GA0@@A0\GA0\GA0\GA0\@@@\GA0\GA0\GA0\G@@@GA0\GA0\GA0\GA0@@A0\GA0\GA0\GA0\@@@\GA0\GA0\GA0\G
@@@GA0\GA0\GA0\GA0@@A0\GA0\GA0\GA0\@@@\GA0\GA0\GA0\G@@@GA0\GA0\GA0\GA0@@A0\GA0\GA0\GA0\@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[142 143 143 242 242 242 212 215 219 202 203 204 230 230 230 237 237 237 246 246 246 244 244 244]; yourself]
!

checkToggleOn13x13Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkToggleOn13x13Icon inspect
     ImageEditor openOnClass:self andSelector:#checkToggleOn13x13Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary checkToggleOn13x13Icon'
        ifAbsentPut:[(Depth8Image width:13 height:13) bits:(ByteArray fromPackedString:'
E1\WE1\WE1\WE1\WE1\/K2</K2</MP(^K1\WK2</K2</K1=@H"<WE2</K2</K2<IA1@/E1\/K2</K2<(LPH/K1\WK2</K2</BC@RK2<WE2</C3<=KPD8K2</
E1\/K0@0GAP3PR</K1\WK2</CTL3C!!$/K2<WE2</K2YBO"\JK2</E1\/K2</M#$SK2</K1\WK2</K2</K2</K2<WE1\WE1\WE1\WE1\WE0@a')
            colorMapFromArray:#[110 127 170 73 94 150 101 119 165 205 207 209 245 245 245 231 231 232 230 230 230 68 90 146 94 113 161 87 106 157 249 249 249 201 204 208 222 224 225 72 93 149 97 115 164 201 207 221 185 191 208 203 207 213 188 195 214 242 243 246 103 120 167 223 226 233 213 216 220 142 143 143 198 200 202 248 249 250 236 237 237 202 203 204 207 212 226 219 220 220 246 246 246 157 167 192 237 238 241 234 236 240 220 223 228 242 243 244 204 208 214 213 217 221 139 153 187 176 185 209 175 184 207 235 235 236 233 233 234 220 221 222 218 218 219 186 193 213 223 226 229 244 244 244 71 92 148 69 90 146 225 226 226 75 96 151 205 209 214 248 248 248 140 153 186 174 179 185 100 118 165 144 157 189 213 213 214 197 201 205 222 225 233 237 238 238 76 97 152 163 174 200 119 134 171 183 191 213 74 95 151 73 95 150]; yourself]
!

clock13x13Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self clock13x13Icon inspect
     ImageEditor openOnClass:self andSelector:#clock13x13Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary clock13x13Icon'
        ifAbsentPut:[(Depth4Image new) width:13; height:13; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@H@@ @@@@@AL3D@@@@@L3@3L@@@HSL0L3D @@L3LCL3@@@CL3@@@0@@@3L3L3L@@BD3L3L1H@@@L3L3L@@@@@D3LP@@@@@B@@H@@@@@@@@@@@
@@@a') ; colorMapFromArray:#[0 0 0 128 128 128 97 97 97 255 255 255]; mask:((Depth1Image new) width:13; height:13; bits:(ByteArray fromPackedString:'@@@O A?@O>A?<G?0_?A?<G?0O>@_0@>@@@@b') ; yourself); yourself]
!

clockPink13x13Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self clockPink13x13Icon inspect
     ImageEditor openOnClass:self andSelector:#clockPink13x13Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary clockPink13x13Icon'
        ifAbsentPut:[(Depth4Image new) width:13; height:13; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@H@@ @@@@@AQDD@@@@@QDADP@@@HTQ@QDD @@QDPDQD@@@DQD@@A@@@ADQDQDP@@BEDQDQAH@@@QDQDP@@@@@EDPP@@@@@B@@H@@@@@@@@@@@
@@@a') ; colorMapFromArray:#[0 0 0 128 128 128 97 97 97 255 255 255 255 127 127]; mask:((Depth1Image new) width:13; height:13; bits:(ByteArray fromPackedString:'@@@O A?@O>A?<G?0_?A?<G?0O>@_0@>@@@@b') ; yourself); yourself]
!

console13x13Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self console13x13Icon inspect
     ImageEditor openOnClass:self andSelector:#console13x13Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary console13x13Icon'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
@PHB@ HB@ HB@ HB@PLDA@PDA@PDA@PDA@LCAPXFA XFA XFA TC@0\FB@ HB@ HB@ G@0$JA ,LCP8ODA@PB $QB XPDAHPDA@PD (QD1PFB0,UE!!\XC1HT
D1LYA!!(ZF!!(ZF!!(ZF1L\GPXZF!!(ZF!!(ZF!!4\G!!<_G1<_G1<_G1<_G"@@@@@@@@@@@@@@@B@@@@@@H@@@@B@@@@@@@B@!!HRD!!HRD!!HRD @@@a') ; colorMapFromArray:#[47 88 144 95 128 176 47 112 200 47 104 184 80 96 128 95 104 128 208 232 248 95 104 136 255 248 248 47 104 176 96 112 136 111 128 176 95 112 168 80 96 144 64 88 136 63 72 128 240 240 248 47 96 176 239 240 248 47 96 168 111 120 144 96 120 168 95 104 160 79 96 144 64 80 136 112 128 144 224 232 248 112 120 144 47 96 160 112 128 160 47 88 160 127 136 160 79 112 168 47 88 136]; mask:((Depth1Image new) width:13; height:13; bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@>@_?@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-14x14'!

addTabEntered14x14Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self addTabEntered14x14Icon inspect
     ImageEditor openOnClass:self andSelector:#addTabEntered14x14Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'XPToolbarIconLibrary addTabEntered14x14Icon'
        ifAbsentPut:[(Depth4Image new) width:14; height:14; bits:(ByteArray fromPackedString:'@RH"H"H"LAHQDQDQDRL!!L3L3L3L2HSL3L3L3L"D3L4P3L3H!!L3MDL3L2HSMDQDP3L"D3PTQDL3H!!L3LQL3L2HSL3QCL3L"D3L3L3L3H!!L3L3L3L2L#L3L3L3
H0L"H"H"H#@b') ; colorMapFromArray:#[127 127 127 238 238 238 153 153 153 221 221 221 246 246 246]; mask:((ImageMask new) width:14; height:14; bits:(ByteArray fromPackedString:'_?/???????????????????????????????=?>0@a') ; yourself); yourself]
!

bookmarks14x14
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bookmarks14x14 inspect
     ImageEditor openOnClass:self andSelector:#bookmarks14x14
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary bookmarks14x14'
        ifAbsentPut:[
            (Depth8Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@GA0@@@@@@@@@@@@@@BPDABP@@@@@@@@@@@@@UJ"(U@@@@@@@@@@@BJB<WE2<(@ @@@@@!!H"L]LA0\LA4#H"D@@@<HDB$.
I2\.JQ@HC0@@@@@TA!!(KB1(FE@@@@@@@@B4,IQ$YIR0-@@@@@@@@F0TRA@PRAQ,@@@@@@@@ML2X HBX3CP@@@@@@@ALLL!!XVL 0S@@@@@@@@M@8@@@@$C#P@
@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 204 180 130 228 201 132 205 197 179 206 217 231 255 237 92 245 219 101 254 243 126 206 180 127 233 208 130 204 197 178 206 213 221 255 231 79 241 217 97 210 175 98 205 176 116 204 182 135 255 255 185 206 210 213 255 235 81 215 180 85 231 204 105 206 176 115 203 180 133 255 253 181 206 208 209 255 225 70 255 235 98 204 174 114 255 244 145 239 223 167 205 205 199 207 219 236 237 212 92 206 176 111 225 196 126 234 211 152 205 202 194 255 233 73 253 241 103 255 239 125 202 179 132 255 254 167 249 243 190 206 218 234 244 218 87 204 172 107 255 245 144 224 197 133 251 244 184 207 218 232 217 178 74 254 238 111 207 175 107 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@LC@0^CA8L_87?;_?,?<1?#G>L_81?#FNL@@0@a');
                            yourself);
                yourself
        ]
!

ledBlue14x14
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledBlue14x14 inspect
     ImageEditor openOnClass:self andSelector:#ledBlue14x14
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class ledBlue14x14'
        ifAbsentPut:[(Depth8Image width:14 height:14) bits:(ByteArray fromPackedString:'
K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K @+A0@@A2,@K"8.K"8@DPDUK2<U@QD@K"8.@B(BIS)CP3(%@"(@K"8@B ,#LBX&LBLKB @.K @CBP8R
D1 RC $C@@@.@@PEC1PYF1,PAPP@K"8@CP ZG2\)KA0FCP@.K @(CB41MCX2KP0(@B8.@@@]E#]AQS,WHP@@@B8.@C .G"@$H"88@B8@K"8.@@@5L3L5@@@.
@@@.K"8.@@@@@@@@K"8.K @a')
            colorMapFromArray:#[20 29 86 0 41 110 0 46 116 20 47 108 20 56 114 0 74 172 0 86 172 76 76 128 0 90 172 10 90 174 80 84 134 40 90 156 0 102 164 70 98 144 30 109 188 20 119 200 20 123 200 116 116 158 50 128 198 50 133 202 20 135 206 100 131 180 0 140 198 0 141 200 50 137 202 20 140 208 0 142 214 20 144 210 0 146 214 90 139 174 60 143 196 0 150 218 40 147 218 90 143 176 60 147 198 100 145 206 60 150 224 110 148 204 100 149 208 0 158 220 130 148 178 0 162 222 148 149 182 157 148 182 0 167 224 0 167 230 120 158 188 140 161 206 120 164 216 0 175 234 0 184 236 190 172 179 30 193 240 190 180 187 40 201 244 70 198 244 200 188 195 210 192 201 170 197 234 90 205 248 210 196 203 220 208 217 230 212 219 230 212 221 230 216 223 120 227 255 240 220 228 210 223 248 240 224 233 130 234 255]
            mask:((ImageMask width:14 height:14) bits:(ByteArray fromPackedString:'@@@@@@?@G>@?<C?0O?L?<C?0O?@_8A? A8@@@@@a'); yourself); yourself]
!

ledDarkRed10x11
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self ledDarkRed10x11 inspect
     ImageEditor openOnClass:self andSelector:#ledDarkRed10x11
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary ledDarkRed10x11'
        ifAbsentPut:[
            (Depth8Image new)
                width:10;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
B@@OAP@@AP<@B@@I@!!L#H1LBBP@NAA41MST1GPPNA ("JRD!!JRHJA DRFA0 HA0XD DCCQ,''J2,+G04CA04-LCH3L2<MA00QNSX8NC\9DP0@EC@:OC0;L!!X@
@@@YJCP4JA$@@@ @@A@KB1@@@@ b');
                colorMapFromArray:#[ 46 12 10 56 11 10 60 1 0 60 10 10 62 1 0 64 39 40 68 37 40 72 33 35 76 94 60 80 59 60 82 18 20 86 89 95 88 63 65 90 0 0 90 74 75 90 75 80 90 93 95 92 0 0 92 7 5 92 52 50 94 45 45 94 97 100 96 45 45 96 100 105 98 15 15 98 56 60 98 101 105 104 8 10 104 24 25 104 56 55 104 108 110 106 8 10 106 24 25 106 47 45 106 48 50 106 68 70 106 109 115 106 110 115 108 111 115 110 9 10 110 28 30 110 58 60 110 113 120 112 9 10 112 116 120 114 0 0 114 118 125 116 0 0 118 0 0 118 86 85 120 0 0 122 0 0 122 20 20 126 103 105 127 4 5 127 6 5 127 12 10 127 15 15 127 35 35 127 41 40 127 52 50 ];
                mask:((ImageMask new)
                            width:10;
                            height:11;
                            bits:(ByteArray fromPackedString:'O0A? O?@?<C?0O?@?<C?0G>@O0@^@@@a');
                            yourself);
                yourself
        ]
!

ledGreen14x14
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledGreen14x14 inspect
     ImageEditor openOnClass:self andSelector:#ledGreen14x14
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary ledGreen14x14'
        ifAbsentPut:[(Depth8Image new) width: 14; height: 14; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K @+A0@@A2,@K"8.K"8@DPDUK2<U@QD@K"8.@B(BIS)CP3(%@"(@K"8@B ,#LBX&LBLKB @.K @CBP8R
D1 RC $C@@@.@@PEC1PYF1,PAPP@K"8@CP ZG2\)KA0FCP@.K @(CB41MCX2KP0(@B8.@@@]E#]AQS,WHP@@@B8.@C .G"@$H"88@B8@K"8.@@@5L3L5@@@.
@@@.K"8.@@@@@@@@K"8.K @a') ; colorMapFromArray:#[24 86 20 32 110 0 36 116 0 40 108 20 48 114 20 60 172 0 72 172 0 76 128 80 76 172 0 76 174 10 80 134 80 80 156 40 88 164 0 92 144 70 96 188 30 104 200 20 108 200 20 116 158 120 116 198 50 120 202 50 120 206 20 124 180 100 124 198 0 124 200 0 124 202 50 124 208 20 124 214 0 128 210 20 128 214 0 132 174 90 132 196 60 132 218 0 132 218 40 136 176 90 136 198 60 136 206 100 136 224 60 140 204 110 140 208 100 140 220 0 144 178 130 144 222 0 148 182 150 148 182 160 148 224 0 148 230 0 152 188 120 156 206 140 156 216 120 156 234 0 164 236 0 172 178 190 176 240 30 180 186 190 184 244 40 184 244 70 188 194 200 192 200 210 192 234 170 192 248 90 196 202 210 208 216 220 212 218 230 212 220 230 216 222 230 216 255 120 220 226 240 220 248 210 224 232 240 224 255 130]; mask:((ImageMask new) width: 14; height: 14; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@?@G>@?<C?0O?L?<C?0O?@_8A? A8@@@@@a') ; yourself); yourself]
!

ledGrey14x14
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledGrey14x14 inspect
     ImageEditor openOnClass:self andSelector:#ledGrey14x14
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary ledGrey14x14'
        ifAbsentPut:[(Depth8Image new) width: 14; height: 14; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@0PD@0H@@@@@@@@@APXGB@ GA T@@@@@@@$JB00MCP0KB $@@@@@C1@QD!!LTD!!DPC0@@@@@VE1 Y
F!!,YGA\V@@@@@A8_HBD"H2L$G18@@@@@I"\(JR(+J2 ,I @@@@@-K"<RLCD2K283@@@@@@@5M#\8NS(6N0@@@@@@@C0=O#=@PS4<@@@@@@@@@@ADL3MD@@@@
@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[170 170 170 235 235 235 179 179 179 123 123 123 83 83 83 154 154 154 105 105 105 178 178 178 203 203 203 179 179 179 111 111 111 197 197 197 226 226 226 241 241 241 230 230 230 132 132 132 151 151 151 197 197 197 208 208 208 199 199 199 200 200 200 225 225 225 107 107 107 163 163 163 177 177 177 187 187 187 188 188 188 189 189 189 175 175 175 221 221 221 118 118 118 159 159 159 184 184 184 189 189 189 192 192 192 193 193 193 185 185 185 218 218 218 146 146 146 163 163 163 194 194 194 197 197 197 198 198 198 201 201 201 162 162 162 176 176 176 160 160 160 206 206 206 217 217 217 220 220 220 210 210 210 177 177 177 201 201 201 168 168 168 182 182 182 225 225 225 240 240 240 242 242 242 229 229 229 169 169 169 192 192 192 181 181 181 183 183 183 200 200 200 206 206 206 184 184 184 217 217 217 198 198 198 184 184 184]; mask:((ImageMask new) width: 14; height: 14; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@?CG>@?<3?0O?@?<C?0O?@_81? A8@@@@@a') ; yourself); yourself]
!

ledRed14x14
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledRed14x14 inspect
     ImageEditor openOnClass:self andSelector:#ledRed14x14
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary ledRed14x14'
        ifAbsentPut:[(Depth8Image new) width: 14; height: 14; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@OAP@@AP<@B@ HB@@@BPHSH2LS@ $@B@ H@@8DGSD5MSD]A@8@B@ @A ("JRD!!JRHJA @HB@@AD!! \
HB@\FAHA@@ H@@LMF2\+J2,_CPL@B@ @A04-LCH3L2<MA0@HB@@LDS$6NC 7NQDL@@ H@@@TLC(<OC,2E @@B@ H@@@YJCP4JA$@@@@HB@ H@@@PB0,P@@@H
B@ HB@ H@@@@@@@@@@ HB@@a') ; colorMapFromArray:#[92 24 20 112 22 20 120 2 0 120 20 20 124 2 0 128 78 80 136 74 80 144 66 70 152 188 120 160 118 120 164 36 40 172 178 190 176 126 130 180 0 0 180 148 150 180 150 160 180 186 190 184 0 0 184 14 10 184 104 100 188 90 90 188 194 200 192 90 90 192 200 210 196 30 30 196 112 120 196 202 210 208 16 20 208 48 50 208 112 110 208 216 220 212 16 20 212 48 50 212 94 90 212 96 100 212 136 140 212 218 230 212 220 230 216 222 230 220 18 20 220 56 60 220 116 120 220 226 240 224 18 20 224 232 240 228 0 0 228 236 250 232 0 0 236 0 0 236 172 170 240 0 0 244 0 0 244 40 40 252 206 210 255 8 10 255 12 10 255 24 20 255 30 30 255 70 70 255 82 80 255 104 100]; mask:((ImageMask new) width: 14; height: 14; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@?@G>@?<C?0O?H?<C?0O?@_8@?@A8@@@@@a') ; yourself); yourself]
!

ledYellow14x14
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledYellow14x14 inspect
     ImageEditor openOnClass:self andSelector:#ledYellow14x14
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary ledYellow14x14'
        ifAbsentPut:[(Depth8Image new) width: 14; height: 14; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@R@ @@@!!H@@PDA@PD@B \#L3L#A0(@@PDA@ALILC=EQS<0BQL@@PD@AQ,2NSP6NSH[AP@A@P@CIR$,
K"<,JBTC@@DA@@ $J3D5M3\-I@ @@PD@CRH8N#,<OC !!CP@A@P@OHC4>PTI@OR@P@@DA@@@TJ$MFQ4P*EP@@@PDA@@,QGBX''GQDK@@@A@PDA@@@FA@PF@@@A
@PDA@PD@@@@@@@@@@@DA@P@a') ; colorMapFromArray:#[144 64 20 152 188 120 168 108 80 172 90 20 172 178 190 180 118 80 180 186 190 184 84 0 184 102 20 188 92 0 188 144 120 188 194 200 192 200 210 196 134 70 196 202 210 200 172 130 200 174 130 200 182 120 204 170 160 204 172 150 208 162 90 208 164 90 208 216 220 212 218 230 212 220 230 216 222 230 220 226 240 224 134 40 224 184 60 224 186 60 224 232 240 228 236 250 236 150 0 236 152 0 236 154 0 236 162 100 240 146 0 240 150 10 244 206 40 244 212 60 248 164 30 248 166 30 252 178 0 252 178 20 252 178 50 252 180 20 252 180 50 252 182 50 252 184 110 252 186 20 252 186 100 252 190 140 255 188 100 255 190 20 255 190 100 255 192 20 255 196 0 255 200 120 255 202 0 255 204 0 255 208 0 255 216 0 255 220 0 255 222 170 255 224 0 255 230 30 255 234 40 255 236 70 255 240 90 255 240 210 255 254 120 255 255 130]; mask:((ImageMask new) width: 14; height: 14; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@?CG>@?<3?0O?@?<C?0O?@_81? A8@@@@@a') ; yourself); yourself]
!

removeTab14x14Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self removeTab14x14Icon inspect
     ImageEditor openOnClass:self andSelector:#removeTab14x14Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class removeTab14x14Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@HD4JB (JB (JB 0\ BAM8BL"8.K"8.K#HP6YCE"[&]''YV]''Y&Y''[V /JVMXVD1+T%MYVUMXWCH,X5%N$Y5,SY&YV%-]MRE[TU:Z'')2W'')9@N5X%E5]HPR*X
&9.[HBL3NQ8QXT]FP(JV%(4-R%U0F@Y*QDU6]75/^''!!< 8 R@V%COR-IGQ(>N#2E# 0@]E@.D1$''S1,TUH&OC T?R2X"IC!!__''NG!!)@DG0];\VA5_8*R%IRS
EQX@G@HKB@$JCP<OD@LV@@@a');
                colorMapFromArray:#[ 129 65 62 131 63 61 131 74 71 135 64 67 135 67 67 138 81 79 146 67 67 149 71 67 155 76 70 155 78 70 156 76 70 157 76 71 158 69 70 158 79 68 159 71 71 159 78 68 161 79 68 162 70 71 170 73 75 171 71 80 172 95 104 175 84 71 175 138 136 178 74 75 179 74 79 181 123 128 182 88 95 183 97 105 184 150 150 186 125 132 189 75 82 191 162 161 194 135 141 199 79 81 203 59 91 206 61 78 207 61 87 207 103 107 209 63 91 211 62 81 213 77 82 213 81 86 213 162 165 213 207 210 214 81 86 214 91 102 215 83 98 215 86 92 216 92 97 217 102 106 217 105 110 218 62 87 218 100 105 218 102 109 218 105 109 218 106 110 219 63 91 220 61 85 220 225 226 221 110 128 222 102 112 222 116 121 222 225 226 223 83 95 223 154 164 224 147 158 225 136 142 226 119 122 226 132 137 226 134 138 226 142 147 226 142 148 226 150 160 226 230 231 227 63 85 227 83 97 227 152 165 227 153 165 227 153 166 228 64 86 228 107 110 228 156 167 228 156 168 228 157 169 229 68 83 229 70 90 229 151 163 229 155 166 229 158 170 229 159 171 229 161 172 229 161 173 229 162 174 229 163 176 229 166 176 230 67 91 230 111 80 230 146 153 230 164 174 230 164 177 230 165 168 230 167 178 230 168 179 230 169 179 230 169 180 231 122 126 231 136 142 231 168 178 231 169 179 231 170 180 231 171 181 231 230 231 233 70 90 233 107 80 233 177 180 234 68 88 234 109 112 234 113 80 234 226 227 234 236 238 235 232 234 235 235 235 235 236 238 236 85 83 236 102 116 236 238 240 238 68 88 238 115 80 238 196 202 238 203 204 238 230 230 240 70 86 240 202 208 241 70 87 241 71 91 242 71 91 242 74 90 242 75 90 242 116 80 242 212 218 242 213 220 242 240 240 243 74 90 244 75 91 244 75 92 245 223 227 246 118 79 247 117 81 247 118 79 247 247 247 247 247 248 248 237 238 248 246 246 249 241 243 250 248 248 250 250 250 251 248 248 252 249 249 252 252 252 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'_?/???????????????????????????????=?>0@a');
                            yourself);
                yourself
        ]
!

removeTabEntered14x14Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self removeTabEntered14x14Icon inspect
     ImageEditor openOnClass:self andSelector:#removeTabEntered14x14Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class removeTabEntered14x14Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@HD4JB (JB (JB 0\ BAQ(.Q$YFQ$YFQ$X1FYCF@ HB@ HB@ HB@ H@/JXA2\''J@\''I2\''I2 CH, GI2%9.@\)"X\(B@MRF@\(B['')6Y'')92XWH%E7I2[''JZ
''):^J#,;N18Q\&-+YH6[&9%DN6%)F@Y$YFQ8#X5:#W5!!ZV$R@U]!!XS97J"A/[4])ZP0@XTYDFQ<;N2@ ZV%)C UDQC,;N3-)ZV%)ZV$DG1%)ZV%)ZV%)ZV%)
GQX@G@HKB@$JCP<OD@LV@@@a');
                colorMapFromArray:#[ 129 65 62 131 63 61 131 74 71 135 64 67 135 67 67 138 81 79 146 67 67 149 71 67 155 76 70 155 78 70 156 76 70 157 76 71 158 69 70 158 79 68 159 71 71 159 78 68 161 79 68 162 70 71 170 73 75 171 71 80 172 95 104 175 84 71 175 138 136 178 74 75 179 74 79 181 123 128 182 88 95 183 97 105 184 150 150 186 125 132 189 75 82 191 162 161 194 135 141 199 79 81 203 59 91 206 61 78 207 61 87 207 103 107 209 63 91 211 62 81 213 77 82 213 81 86 213 162 165 213 207 210 214 81 86 214 91 102 215 83 98 215 86 92 216 92 97 217 102 106 217 105 110 218 62 87 218 100 105 218 102 109 218 105 109 218 106 110 219 63 91 220 61 85 220 225 226 221 110 128 222 102 112 222 116 121 222 225 226 223 83 95 223 154 164 224 147 158 225 136 142 226 119 122 226 132 137 226 134 138 226 142 147 226 142 148 226 150 160 226 230 231 227 63 85 227 83 97 227 152 165 227 153 165 227 153 166 228 64 86 228 107 110 228 156 167 228 156 168 228 157 169 229 68 83 229 70 90 229 151 163 229 155 166 229 158 170 229 159 171 229 161 172 229 161 173 229 162 174 229 163 176 229 166 176 230 67 91 230 111 80 230 146 153 230 164 174 230 164 177 230 165 168 230 167 178 230 168 179 230 169 179 230 169 180 231 122 126 231 136 142 231 168 178 231 169 179 231 170 180 231 171 181 231 230 231 233 70 90 233 107 80 233 177 180 234 68 88 234 109 112 234 113 80 234 226 227 234 236 238 235 232 234 235 235 235 235 236 238 236 85 83 236 102 116 236 238 240 238 68 88 238 115 80 238 196 202 238 203 204 238 230 230 240 70 86 240 202 208 241 70 87 241 71 91 242 71 91 242 74 90 242 75 90 242 116 80 242 212 218 242 213 220 242 240 240 243 74 90 244 75 91 244 75 92 245 223 227 246 118 79 247 117 81 247 118 79 247 247 247 247 247 248 248 237 238 248 246 246 249 241 243 250 248 248 250 250 250 251 248 248 252 249 249 252 252 252 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'_?/???????????????????????????????=?>0@a');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-15x15'!

edit_anchor15x15
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self edit_anchor15x15 inspect
     ImageEditor openOnClass:self andSelector:#edit_anchor15x15
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary edit_anchor15x15'
        ifAbsentPut:[
            (Depth4Image new)
                width:15;
                height:15;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
DQDQDQDQDQ@QDQD].!!DQDADQD]D8DQDPDQDQ,9 QDQ@QDQDTRQDQDAD1DQAADQDPDQDQDHDQFQ@Q4QD[ QDPDAF;(Q.AD; PD[(QF8DQ%Q@Q69H; R5EDAD$
B7AVQ^\PDQI%U^W.0Q@QDQI%9GLQDADQDQDQDQDP');
                colorMapFromArray:#[ 88 113 160 165 174 205 194 198 206 211 212 217 81 99 143 58 78 114 95 108 136 136 148 166 60 84 129 165 173 191 189 196 217 101 122 176 167 170 178 123 144 186 43 63 103 ];
                mask:((ImageMask new)
                            width:15;
                            height:15;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A0@O@@<@C0BF@HXP1#C&\LX0?/C?<G? G<@@@');
                            yourself);
                yourself
        ]
!

edit_bold_15x15
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self edit_bold_15x15 inspect
     ImageEditor openOnClass:self andSelector:#edit_bold_15x15
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary edit_bold_15x15'
        ifAbsentPut:[
            (Depth1Image new)
                width:15;
                height:15;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:15;
                            height:15;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@G>@N\@90C''@O8@90C''@N\A? @@@@@@@@');
                            yourself);
                yourself
        ]
!

edit_code_15x15
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self edit_code_15x15 inspect
     ImageEditor openOnClass:self andSelector:#edit_code_15x15
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary edit_code_15x15'
        ifAbsentPut:[
            (Depth2Image new)
                width:15;
                height:15;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@P@@@@L@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@D@@@@A@@@@@0@@@@@@@@@B@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:15;
                            height:15;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@A8@@@@],@@@F; @@A4@@@@[@@@@GX@@@@@@');
                            yourself);
                yourself
        ]
!

edit_escapeHTMLCharacters
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self edit_escapeHTMLCharacters inspect
     ImageEditor openOnClass:self andSelector:#edit_escapeHTMLCharacters
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary edit_escapeHTMLCharacters'
        ifAbsentPut:[(Depth2Image new) width:15; height:15; bits:(ByteArray fromPackedString:'@@@@@P@@@@L@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@D@@@@A@@@@@0@@@@@@@@@B@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 84 84 84 170 170 170 255 255 255]; mask:((ImageMask new) width:15; height:15; bits:(ByteArray fromPackedString:'@@@@@A0@H @"@BH@E@@H@APLH(0!!@BJLGD @F@@@') ; yourself); yourself]
!

edit_image_15x15
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self edit_image_15x15 inspect
     ImageEditor openOnClass:self andSelector:#edit_image_15x15
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary edit_image_15x15'
        ifAbsentPut:[(Depth4Image width:15 height:15) bits:(ByteArray fromPackedString:'
Y&Y&Y&Y&Y&A%UUUUUUUUXFUUUWU0UUU YUU5&W]4UVA%U9&Y$WUUXFUW&Y$RUUU"YWUY&W\RUVA%Q7%R\''\TX&Y7]4IHP''Y Y&](I8]6Y&I&Y&ZCY&Y&XF&Y
&YNI&Y% Y7]7!!8]7]6A"D!!HRD!!HRXFY&Y&Y&Y&Y ') colorMapFromArray:#[153 153 153 51 94 9 59 145 19 50 50 50 225 225 225 164 207 242 255 255 255 111 147 26 147 63 49 165 199 47]; yourself]
!

edit_italic_15x15
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self edit_italic_15x15 inspect
     ImageEditor openOnClass:self andSelector:#edit_italic_15x15
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary edit_italic_15x15'
        ifAbsentPut:[
            (Depth2Image new)
                width:15;
                height:15;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@P@@@@L@@@@@@@@@@ @@B@@@@P@@@@@P@@@D@@D@@D@A@A@@@0@A@@@@@@@B@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:15;
                            height:15;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@_@@8@G@@\@C @N@A0@G@A>@@@@@@@@@');
                            yourself);
                yourself
        ]
!

padLockGold15x15Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self padLockGold15x15Icon inspect
     ImageEditor openOnClass:self andSelector:#padLockGold15x15Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class padLockGold15x15Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:15;
                height:15;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
^G!!8]3<0P4MZ$@@@^G!!8^G!!7@C1\K8TLD8<@@G!!8(J@AI1H=NH,[ 6MR@JB (J@*O$0UH)9X[4M;@JB IRP,H3X"IRT%DU-T@BT%S$6N%WVJS$9NN%NL@D9N
S)%VU2:AVTPGA%TDRFENS"@<(UE&^&X;YRZ"R3QNYG@NL6@!!Q9Z[!!16HG8Y$S64MZ8I*E4FS F8(QWIO''1)1$T@VFG8Y%A2MB@._''9\2@2-?P"4E[DZ\LP._
D@$NEG1(Y2$BZW6X!!I(PI@*R^UA6C954RU4^\5<@IH%_R$)JR$)JR$)JW8$@');
                colorMapFromArray:#[ 132 141 152 147 150 154 250 223 1 246 214 0 205 172 133 238 195 0 213 180 146 217 186 150 188 136 0 206 151 0 183 125 9 208 208 202 196 204 214 255 255 210 255 255 219 210 178 65 242 242 235 106 112 117 96 107 126 250 255 255 255 241 0 154 154 151 255 227 0 67 35 0 52 17 0 253 211 0 208 159 0 167 178 193 222 168 0 248 231 45 208 174 26 199 152 26 225 184 36 255 249 75 220 220 215 77 88 108 241 241 235 245 245 239 255 250 109 242 249 255 255 255 142 255 237 1 142 148 162 242 212 1 143 154 176 174 133 0 222 189 144 169 179 192 177 184 193 184 129 0 255 255 194 253 241 60 210 210 205 214 214 209 77 83 92 230 230 225 98 106 114 243 243 238 117 117 114 255 252 115 255 255 255 115 123 147 130 140 156 152 156 159 241 210 0 53 18 0 151 116 0 162 170 184 218 187 150 193 143 4 220 165 0 206 188 46 181 130 21 204 173 44 206 206 201 208 167 44 72 84 108 240 240 234 244 244 238 243 243 237 212 182 79 255 255 126 131 135 141 119 133 159 132 141 163 195 162 126 219 188 133 218 185 135 180 180 176 221 190 150 175 181 191 176 183 196 181 189 201 202 170 38 209 209 204 207 207 202 251 241 74 229 229 224 238 238 233 226 234 245 244 244 237 255 251 113 255 255 124 255 241 2 255 234 3 249 219 0 255 249 29 252 243 30 227 181 0 212 165 5 222 170 0 173 179 194 216 171 19 255 255 198 208 208 203 156 90 7 206 175 50 91 91 95 211 180 71 242 242 237 246 246 241 212 182 80 255 255 123 129 137 152 255 239 8 251 223 0 59 25 0 251 215 0 228 183 0 222 191 149 249 238 43 177 186 197 187 129 0 186 194 206 209 209 203 249 238 67 255 255 211 226 226 221 235 235 229 100 103 111 76 93 127 255 255 112 88 104 139 130 135 148 149 155 158 247 218 0 224 194 126 255 217 0 228 184 0 13 30 68 161 138 32 204 152 0 255 255 53 206 155 18 207 207 201 255 250 72 255 255 82 209 176 59 232 232 227 243 243 236 245 245 240 255 255 115 255 255 251 ];
                mask:((ImageMask new)
                            width:15;
                            height:15;
                            bits:(ByteArray 
                                        fromPackedString:'C<D_8S?1OOD8\S!!1_?5??W?=_?5??W?=_?5??S?9');
                            yourself);
                yourself
        ]
!

padLockGoldOpen15x15Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self padLockGoldOpen15x15Icon inspect
     ImageEditor openOnClass:self andSelector:#padLockGoldOpen15x15Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary padLockGoldOpen15x15Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:15;
                height:15;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
^G!!8]3<0P4MZ$@@@^G!!8^G @@C1\K8TLD8<@@G!!8(J@@I1H=NH,[ 6MR@JB (J@@O$0UH)9X[4M;@JB IRP@@@@"IRT%DU-T@BT%S$4@@@@@S$9NN%NL@D9N
S)%VU2:AVTPGA%TDRFENS"@<(UE&^&X;YRZ"R3QNYG@NL6@!!Q9Z[!!16HG8Y$S64MZ8I*E4FS F8(QWIO''1)1$T@VFG8Y%A2MB@._''9\2@2-?P"4E[DZ\LP._
D@$NEG1(Y2$BZW6X!!I(PI@*R^UA6C954RU4^\5<@IH%_R$)JR$)JR$)JW8$@');
                colorMapFromArray:#[ 132 141 152 147 150 154 250 223 1 246 214 0 205 172 133 238 195 0 213 180 146 217 186 150 188 136 0 206 151 0 183 125 9 208 208 202 196 204 214 255 255 210 255 255 219 210 178 65 242 242 235 106 112 117 96 107 126 250 255 255 255 241 0 154 154 151 255 227 0 67 35 0 52 17 0 253 211 0 208 159 0 167 178 193 222 168 0 248 231 45 208 174 26 199 152 26 225 184 36 255 249 75 220 220 215 77 88 108 241 241 235 245 245 239 255 250 109 242 249 255 255 255 142 255 237 1 142 148 162 242 212 1 143 154 176 174 133 0 222 189 144 169 179 192 177 184 193 184 129 0 255 255 194 253 241 60 210 210 205 214 214 209 77 83 92 230 230 225 98 106 114 243 243 238 117 117 114 255 252 115 255 255 255 115 123 147 130 140 156 152 156 159 241 210 0 53 18 0 151 116 0 162 170 184 218 187 150 193 143 4 220 165 0 206 188 46 181 130 21 204 173 44 206 206 201 208 167 44 72 84 108 240 240 234 244 244 238 243 243 237 212 182 79 255 255 126 131 135 141 119 133 159 132 141 163 195 162 126 219 188 133 218 185 135 180 180 176 221 190 150 175 181 191 176 183 196 181 189 201 202 170 38 209 209 204 207 207 202 251 241 74 229 229 224 238 238 233 226 234 245 244 244 237 255 251 113 255 255 124 255 241 2 255 234 3 249 219 0 255 249 29 252 243 30 227 181 0 212 165 5 222 170 0 173 179 194 216 171 19 255 255 198 208 208 203 156 90 7 206 175 50 91 91 95 211 180 71 242 242 237 246 246 241 212 182 80 255 255 123 129 137 152 255 239 8 251 223 0 59 25 0 251 215 0 228 183 0 222 191 149 249 238 43 177 186 197 187 129 0 186 194 206 209 209 203 249 238 67 255 255 211 226 226 221 235 235 229 100 103 111 76 93 127 255 255 112 88 104 139 130 135 148 149 155 158 247 218 0 224 194 126 255 217 0 228 184 0 13 30 68 161 138 32 204 152 0 255 255 53 206 155 18 207 207 201 255 250 72 255 255 82 209 176 59 232 232 227 243 243 236 245 245 240 255 255 115 255 255 251 ];
                mask:((ImageMask new)
                            width:15;
                            height:15;
                            bits:(ByteArray 
                                        fromPackedString:'C<D_8Q?1GOD@\PA1_?5??W?=_?5??W?=_?5??S?9');
                            yourself);
                yourself
        ]
!

smiley_angry
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_angry inspect
     ImageEditor openOnClass:self andSelector:#smiley_angry
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_angry'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
C 8NC @FA XHB@@NC 8NC 8N@@LC@0,KB0,@C 8NC 8DAP\GA0\G@0,L@@8NC XEA0\IBP,G@ $IC@@NC PKA0\CB0$JBP(EAP4NA HG@0LC@@TI@ @KB00H
B@,C@0LE@@,CB0@AB0DHB@,C@0LCAPLGA0DEAP(HB@,GA0LCAPTKB0DEAP(HB@DGA0LJ@@4MCP@L@P0HC 4KA0,@B TAB 0@C@XNC  AA0TEB0,EAPDLC@ N
C 8M@PTKB0TE@P0LA 8NC 8NB@4L@P(LC@XHC 8NC 8NC 8HB@ HB@8NC 8N') ; colorMapFromArray:#[0 0 0 255 28 4 255 32 8 255 92 76 109 8 0 255 48 24 72 4 0 255 108 92 44 4 0 89 60 56 255 24 0 255 68 48 208 24 0 85 8 0 0 0 0]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
!

smiley_biggrin
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_biggrin inspect
     ImageEditor openOnClass:self andSelector:#smiley_biggrin
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_biggrin'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ H@@@@@@@HB@ HB@ HB@@@A@PDA@P@@@ HB@ H@@PDA@PDA@PDA@@HB@ @A@PDA@PDA@PDA@P@B@ @A@P@@@PDA@@@A@P@B@@DA@P@@@PDA@@@A@PD@
@@DA@PDA@PDA@PDA@PD@@@DA@PDA@PDA@PDA@PD@@@DA@@@@@@@@@@@@@PD@@@DA@@HB@ HB@ H@@PD@@ @A@P@B@ HB@ @A@P@B@ @A@PD@@@@@@@DA@P@B
@ H@@PDA@PDA@PDA@@HB@ HB@@@A@PDA@P@@@ HB@ HB@ H@@@@@@@HB@ HB') ; colorMapFromArray:#[0 0 0 0 255 0 255 255 255]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
!

smiley_cool
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_cool inspect
     ImageEditor openOnClass:self andSelector:#smiley_cool
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_cool'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ @@@@@@@@@@@ HB@ HB@ HB@@@@@@@B@ HB@ HB@ HB@ @@@@@B@ @@@ HB@@@B@ @@@@@@@@@@@@H@@@@@@@@@
@@HB@@@@@@@@@@@@@ H@@@HB@ @@@ HB@@@B@ H@@@HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ H@@@@B@ @B@ HB@ @B@ @@@@@B@ H@@@@@@@HB@ @@
@@@@@ HB@ HB@ HB@@@@@@@@@@@B@ HB@ @@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 0 0 0 255 0]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
!

smiley_eek
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_eek inspect
     ImageEditor openOnClass:self andSelector:#smiley_eek
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_eek'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@C@0LC@0@@@@@@@@@@@0LC@0LC@0LC@@@@@@@C@0LC@0LC@0LC@0@@@@@C@0LC@0LC@0LC@0@@@@LC@0@@@0LC@@@C@0L@
@@LC@0HB@0LC@ HC@0L@@@LC@0LC@0LC@0LC@0L@@@LC@0LC@0LC@0LC@0L@@@LC@0LC@0LC@0LC@0L@@@@C@0LC@0@C@0LC@0@@@@@C@0LC@@@@@0LC@0@@
@@@@@0LC@0@C@0LC@@@@@@@@@@@C@0LC@0@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 0 0 48 48 48 255 157 167]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
!

smiley_frown
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_frown inspect
     ImageEditor openOnClass:self andSelector:#smiley_frown
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_frown'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ @@@@@@@@@@@ HB@ HB@ HB@@@@@@@B@ HB@ HB@ HB@ @@@@@B@ HB@ HB@ HB@ @@@@HB@ @@@ HB@@@B@ H@
@@HB@ @@@ HB@@@B@ H@@@HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ H@@@HB@ H@@@@@@@HB@ H@@@@B@ @B@ HB@ @B@ @@@@@B@ HB@ HB@ HB@ @@
@@@@@ HB@ HB@ HB@@@@@@@@@@@B@ HB@ @@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 0 0 255 163 0]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
!

smiley_mhmh
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_mhmh inspect
     ImageEditor openOnClass:self andSelector:#smiley_mhmh
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_mhmh'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ @@@@@@@@@@@ HB@ HB@ HB@@@@@@@B@ HB@ HB@ HB@ @@@@@B@ @@@ HB@@@B@ @@@@HB@ @@@ HB@@@B@ H@
@@HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ H@@@@B@ HB@ HB@ HB@ @@@@@B@ H@@@@@@@HB@ @@
@@@@@ HB@ HB@ HB@@@@@@@@@@@B@ HB@ @@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 0 0 255 222 0]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
!

smiley_ok
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_ok inspect
     ImageEditor openOnClass:self andSelector:#smiley_ok
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_ok'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ H@@@@@@@HB@ HB@ HB@@@A@PDA@P@@@ HB@ H@@PDA@PDA@PDA@@HB@ @A@PDA@PDA@PDA@P@B@ @A@P@@@PDA@@@A@P@B@@DA@P@@@PDA@@@A@PD@
@@DA@PDA@PDA@PDA@PD@@@DA@PDA@PDA@PDA@PD@@@DA@PDA@PDA@PDA@PD@@@DA@PDA@PDA@PDA@PD@@ @A@PDA@PDA@P@A@P@B@ @A@PD@@@@@@@DA@P@B
@ H@@PDA@PDA@PDA@@HB@ HB@@@A@PDA@P@@@ HB@ HB@ H@@@@@@@HB@ HB') ; colorMapFromArray:#[0 0 0 255 255 0 0 0 0]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
!

smiley_smile
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smiley_smile inspect
     ImageEditor openOnClass:self andSelector:#smiley_smile
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class smiley_smile'
        ifAbsentPut:[(Depth8Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ H@@@@@@@HB@ HB@ HB@@@A@PDA@P@@@ HB@ H@@PDA@PDA@PDA@@HB@ @A@PDA@PDA@PDA@P@B@ @A@P@@@PDA@@@A@P@B@@DA@P@@@PDA@@@A@PD@
@@DA@PDA@PDA@PDA@PD@@@DA@PDA@PDA@PDA@PD@@@DA@PDA@PDA@PDA@PD@@@DA@@DA@PDA@PD@@PD@@ @A@P@A@PDA@P@A@P@B@ @A@PD@@@@@@@DA@P@B
@ H@@PDA@PDA@PDA@@HB@ HB@@@A@PDA@P@@@ HB@ HB@ H@@@@@@@HB@ HB') ; colorMapFromArray:#[0 0 0 255 255 0 0 0 0]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A<@_<C?8_?1??O?>??;??/?>??9??G?<O? _<@_@') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-16x16'!

back16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self back16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#back16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary back16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@T@@@@@@@@@D @@@@@@@@D#@@@@@@@@D#L@@@@@@@D#L2UUH@@@D#L3L3M @@T#L3L3L6@@@DX3L3L3X@@@AFL3Y&Y @@@@
Q#L@@@@@@@@DX0@@@@@@@@AF@@@@@@@@@@P@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 255 255 255 0 255 255 0 192 192 0 64 64 192 255 255 0 128 128] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@A @N@A8@O A?<O?1??O?<_?0??A?<C8@G @N@@X@b'); yourself); yourself]
!

bookmarks16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bookmarks16x16 inspect
     ImageEditor openOnClass:self andSelector:#bookmarks16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary bookmarks16x16'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@A@@@@@@@@@@@@@@@@@@D@ P@@@@@@@@@@@@@@@@D@ DBA@@@@@@@@@@@@@@@A@HA@ P@@@@@@@@@A@PDA@HA@PDB
A@PD@@@@A@HB@ HA@PDA@PHB@ PA@@@D@PDA@PDA@PDA@PDD@@@@@@PA@@@@@@@@@@DD@@@@@@@@A@D@@@@@@@DD@@@@@@@@@@PA@@@@@@@AA@@@@@@@@@@D
@P@@@P@@@PP@@@@@@@@D@ @A@PPA@P@BA@@@@@@@A@DAA@P@A@PA@PP@@@@@@P@DA@@@@@@@A@P@@P@@@@@A@@@@@@@@@@@@@P@@@@@a') ; colorMapFromArray:#[240 151 26 255 213 5 245 234 120 240 243 250 240 76 0]; mask:((Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@P@C @N@A<@G0O?>??9??C?8G?@_<A?0O? >>G <H@ b') ; yourself); yourself]
!

bottom16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bottom16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#bottom16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class bottom16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@DQDQD@@@@@@QUY"P@@@@@AEH"M@@@@@@DT"H4@@@@@@Q"H#P@@@QDQAH"MDQDAFD"H"H"H0P@Q!!H"H"H0P@@DXRH"H0P@@@AFD"H0P@@@@@
Q!!H0P@@@@@@DX0P@@@@@@@A@P@@@@@QDQDQDQDP@ADQDQDQDQ@@b');
                colorMapFromArray:#[ 0 64 64 0 255 255 0 192 192 0 128 128 0 0 0 255 255 255 192 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O8@? C>@O8@? ??;??''?<O? _<@? A<@C G?<_?0b');
                            yourself);
                yourself
        ]
!

browseIt16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self browseIt16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#browseIt16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class browseIt16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADQDPXB@@@@D3L0XCT@@@@SL0Y MP@@@BUPY!!@@@@@@@@Y!!E&X@@@@@Y!!E&X@@@@@@@A&X@@@@@@ADFXADR@@@@
E@XDQDT@@@@ XEUUUP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 0 0 0 255 0 127 127 127 248 252 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@HG?8_?!!?>G?8_?1?>A?0O?8_?!!?>G?8_? P@@@@b');
                            yourself);
                yourself
        ]
!

bugGrey16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bugGrey16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#bugGrey16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class bugGrey16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@GA0@NC @GA0\@@@@@@@@G@@ IB ,LA0@G@@@@@@@@C @PDQHRD1P@C @@@@@@@@@WFA$Z@!!,\GP@@@@@@@@@@G2@@HRH[
H2P@@@@@@@@@I"\(JR(+KB4.I @@@@@@@B<0LSH3MCT6M3 @@@@@@C$:N30=O#=@PTIC\P@@@GEGRD%JR39LST9O@@A1@@AQ@EISUEUVU5!!YV%,@TP@@@@A]
W%= XVI#YFU&@@@@@@A1W#!!(ZV)+[F5.[7D@@@@@\PAX\&53]GU6]0A1@@@@@G$@@@A;_G1=@@@@^P@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 180 180 180 237 237 237 189 189 189 255 255 255 243 243 243 250 250 250 246 246 246 137 137 137 255 255 255 13 13 13 23 23 23 25 25 25 8 8 8 202 202 202 207 207 207 255 255 255 84 84 84 5 5 5 1 1 1 4 4 4 56 56 56 255 255 255 253 253 253 19 19 19 71 71 71 169 169 169 197 197 197 150 150 150 58 58 58 0 0 0 250 250 250 207 207 207 232 232 232 135 135 135 116 116 116 180 180 180 169 169 169 255 255 255 201 201 201 255 255 255 255 255 255 255 255 255 234 234 234 199 199 199 255 255 255 240 240 240 224 224 224 185 185 185 255 255 255 255 255 255 255 255 255 253 253 253 224 224 224 255 255 255 234 234 234 230 230 230 187 187 187 142 142 142 179 179 179 255 255 255 255 255 255 255 255 255 251 251 251 226 226 226 255 255 255 220 220 220 224 224 224 180 180 180 159 159 159 255 255 255 161 161 161 255 255 255 179 179 179 255 255 255 255 255 255 255 255 255 230 230 230 249 249 249 207 207 207 210 210 210 255 255 255 103 103 103 184 184 184 244 244 244 255 255 255 255 255 255 250 250 250 216 216 216 213 213 213 187 187 187 201 201 201 193 193 193 255 255 255 187 187 187 212 212 212 227 227 227 226 226 226 208 208 208 183 183 183 183 183 183 184 184 184 192 192 192 203 203 203 194 194 194 217 217 217 201 201 201 182 182 182 173 173 173 178 178 178 201 201 201 189 189 189 235 235 235 255 255 255 124 124 124 189 189 189 204 204 204 203 203 203 199 199 199 188 188 188 226 226 226 255 255 255 130 130 130 255 255 255 194 194 194 182 182 182 198 198 198 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@M.A_(E> O<@?0G? _>C?<_?)_>!!?8O?0/=BOD@@@b');
                            yourself);
                yourself
        ]
!

bugRed16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bugRed16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#bugRed16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class bugRed16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@JN0A9]0@]PP@@@@@@@@@!!@F\BAB$A!! @!!@@@@@@@@F 6IRRP$[S=UF @@@@@@@DHCPC^EN6.HRH(@@@@@@@A&WP$UZW)+
EG4K@@@@@@@@W&VKLR0%KS4X 0@@@@@@@G<0G(0[E''Y_FQL@@@@@@E!!>UELL!!41QNC1,MX4@@E(_M&QRGGQKXAH9@F)Z@@AC@E-"TFLW F9FWBX@P0@@L AJ
 R]/VU]EH!!EM@CH@@@@*BHI0Q3LN_C((K"(@@@BNU @G\PVD\$8F]PAV# @@ZG,@@B=!!S4<+^@@@^6 @@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 165 43 7 6 6 6 10 10 10 18 6 2 18 18 18 171 89 52 167 60 24 184 100 74 173 141 131 188 163 150 187 187 187 213 158 142 254 157 105 214 207 206 153 55 4 237 237 237 245 245 245 165 76 37 181 80 27 169 50 15 145 132 125 143 140 139 192 108 62 220 91 21 188 114 80 193 127 92 163 163 163 212 140 101 253 132 65 197 197 197 253 159 107 212 212 212 230 230 230 108 108 108 160 78 34 254 254 254 1 1 1 169 104 68 172 61 26 198 90 33 168 58 20 20 20 21 153 153 153 175 71 38 196 132 98 230 118 58 192 159 151 212 158 142 248 159 112 253 172 130 228 228 228 162 59 4 243 243 243 125 125 125 164 42 5 133 133 133 192 90 35 177 108 72 171 101 64 149 149 149 188 122 87 205 115 67 254 253 253 47 29 23 57 52 50 194 194 194 201 196 196 81 81 81 227 227 227 164 58 0 165 66 14 176 78 26 0 0 0 4 4 4 164 73 45 202 89 27 195 100 49 176 88 60 170 89 52 166 43 6 234 92 17 240 107 36 253 124 53 253 144 84 252 152 100 208 200 199 98 98 98 163 57 0 112 112 112 186 65 0 127 127 127 166 53 18 171 97 60 178 84 46 177 72 39 202 101 47 219 95 28 173 67 35 209 110 60 249 100 19 237 131 75 240 144 95 216 161 145 206 206 206 225 225 225 106 106 106 240 240 240 118 118 118 165 42 4 3 3 3 189 75 14 202 71 0 185 106 63 168 60 23 173 105 68 254 252 252 218 110 51 193 111 85 248 116 44 191 191 191 216 165 148 205 205 205 91 91 91 102 102 102 156 72 26 147 66 37 164 40 3 168 49 12 191 78 17 182 83 38 166 55 18 178 73 42 174 105 68 155 155 155 159 159 159 214 128 81 48 44 43 71 46 36 199 194 194 253 165 117 254 177 137 231 231 231 238 238 238 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@M,A_(G? _>A?8G? _>C?>_?9_>%?:O?1/=&_&@@@b');
                            yourself);
                yourself
        ]
!

bugYellow16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bugYellow16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#bugYellow16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class bugYellow16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@JN0A9]0@]PP@@@@@@@@@!!@F\BAB$A!! @!!@@@@@@@@F 6IRRP$[S=UF @@@@@@@DHCPC^EN6.HRH(@@@@@@@A&WP$UZW)+
EG4K@@@@@@@@W&VKLR0%KS4X 0@@@@@@@G<0G(0[E''Y_FQL@@@@@@E!!>UELL!!41QNC1,MX4@@E(_M&QRGGQKXAH9@F)Z@@AC@E-"TFLW F9FWBX@P0@@L AJ
 R]/VU]EH!!EM@CH@@@@*BHI0Q3LN_C((K"(@@@BNU @G\PVD\$8F]PAV# @@ZG,@@B=!!S4<+^@@@^6 @@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 165 154 7 6 6 6 10 10 10 18 17 2 18 18 18 170 171 52 167 160 24 184 177 74 173 170 131 186 188 150 187 187 187 213 208 142 247 254 105 214 213 206 147 153 4 237 237 237 245 245 245 164 165 37 174 181 27 169 158 15 144 145 125 143 143 139 185 192 62 210 220 21 186 188 80 188 193 92 163 163 163 206 212 101 242 253 65 197 197 197 245 253 107 212 212 212 230 230 230 108 108 108 154 160 34 254 254 254 1 1 1 163 169 68 172 163 26 190 198 33 168 162 20 21 20 21 153 153 153 175 167 38 191 196 98 222 230 58 192 188 151 212 207 142 242 248 112 248 253 130 228 228 228 154 162 4 243 243 243 125 125 125 164 153 5 133 133 133 184 192 35 172 177 72 166 171 64 149 149 149 183 188 87 198 205 67 254 254 253 47 46 23 57 57 50 194 194 194 201 199 196 81 81 81 227 227 227 155 164 0 158 165 14 169 176 26 0 0 0 4 4 4 164 156 45 192 202 27 188 195 49 176 169 60 168 170 52 166 155 6 224 234 17 230 240 36 242 253 53 244 253 84 246 252 100 208 206 199 98 98 98 155 163 0 112 112 112 177 186 0 127 127 127 166 157 18 167 171 60 178 176 46 177 169 39 194 202 47 209 219 28 173 164 35 204 209 60 237 249 19 230 237 75 234 240 95 216 211 145 206 206 206 225 225 225 106 106 106 240 240 240 118 118 118 165 155 4 3 3 3 180 189 14 192 202 0 179 185 63 168 161 23 167 173 68 254 253 252 209 218 51 193 187 85 237 248 44 191 191 191 216 213 148 205 205 205 91 91 91 102 102 102 149 156 26 147 143 37 164 153 3 168 158 12 182 191 17 180 182 38 166 159 18 178 168 42 169 174 68 155 155 155 159 159 159 207 214 81 48 47 43 71 70 36 199 197 194 246 253 117 249 254 137 231 231 231 238 238 238 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@M,A_(G? _>A?8G? _>C?>_?9_>%?:O?1/=&_&@@@b');
                            yourself);
                yourself
        ]
!

centerAdjust16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self centerAdjust16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#centerAdjust16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary centerAdjust16x16Icon'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@AUUUUPP@@@DEUUUUAU@@UPUUUUTD@@@AAUUUUPUP@ETEUUUUA@@@@PUUUUTET@AUAUUUUPUUUUT@@@@@@@a') colorMapFromArray:#[0 0 0 255 255 255]; yourself]
!

clock16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self clock16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#clock16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary clock16x16Icon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@A0@]0A7@O^@<HC? G<@_0@\@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@\@G<@?8C? _?A?<G?0O>@?8A?@A0@@@@@@b') ; yourself); yourself]
!

colorHistory16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self colorHistory16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#colorHistory16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class colorHistory16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@EUUUUT@@@@@UUUUUP@@@@AUUUUU@@@@@EUUUUTB@@@@UUUUUPH@@@@@@@@@@ @@@@@"H"H"@0@@@BH"H"HC@@@@@@@@@@L@@@@@L3L3L0P@@@
@3L3L3A@@@@@@@@@@D@@@@@DQDQDP@@@@@QDQDQ@@@@@@@@@@@@b');
                colorMapFromArray:#[ 1 104 205 255 255 255 255 0 0 0 255 0 0 0 255 255 255 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'?<C?0O?@??C?<O?0??0??C?<O?<O?0??C?<C?0O?@?<b');
                            yourself);
                yourself
        ]
!

configure16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self configure16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#configure16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class configure16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@DH3\@@@@@@@ARH5\@@@@@@@ARM0@@@A\@DPH3\@@@D3LBH3M0@@@!!D3L3L3\@A!!H!!D3L3L7\@T1H"I1D3L7@@T5U2H!!D3L@@@A5UWH!!D0@@
@@@@L7H!!@@@@@@@@L7H@@@@@@@@@L0@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 88 88 88 220 220 220 128 128 128 195 195 195 48 48 48 160 160 160 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'G8@_8@?09?C?>O?8??;?????_?<_?0O?@C<@C0@C@@@b');
                            yourself);
                yourself
        ]
!

copy16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copy16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#copy16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class copy16x16Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@* @@@J( @@BBEUP@*)*%@H@Z)$B*&BUP A**$J*X@I@@F**P@A @$@@Z*)@@EUUP@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 0 128 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@C<@O8@?0C?<O?8??3??/?>??;?? O>@?8C? @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

cut16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#cut16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class cut16x16Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16 ;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@E@@W@GR@%HBT IL@X@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@BH@H @"@CX@E@@\@@ @G@@W@GR@%HBT IL@X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

cut16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#cut16x16Icon2"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class cut16x16Icon2'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@EUP@@A*%@@@Z)$@@FBUP@A**$@@X@I@@F**P@A @$@@Z*)@@EUUP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 0 128 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@C<@O9D?4S?1O?,?:#?.O>P?;#?+ C)@R$AJPD&@L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

delete16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self delete16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#delete16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class delete16x16Icon'
        ifAbsentPut:[(Depth1Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@0@'' LOA N\@_ @<@C0@_@C&@\LC P^@ 0@@@D@@@b') ; colorMapFromArray:#[255 255 255 65 65 65]; yourself]
!

desktop16x16Icon
    <resource: #programImage>

    ^self desktop16x16Icon2
!

desktop16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self desktop16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#desktop16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class desktop16x16Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@BL#H2L#_!!HSW@LDJB]J@%,#EF<9 %:CW44;JPY S&E-H1Q@]5L.T%EPA8U4X  =_2NAPP)%"A0?]R0I!!2<]F D#WP-6"W!!&UDH0
G 19CX(AH55#KV]UP3D_"7(NU3M(@RM]J39$U$P2HH1E_CQY^0D#WQ^D!!&$!!C85*VAAGDTXAH54YRBH[# >MZ''4PQ1E+@RL5RBTUH$=OS4=OS4=OS0D#OBH:
J''H@@@@@@@@@@@@AH3Y1\!!YKV%)ZV%)ZV%)Z@V0$RX@&\D0ENF87_0DA@PD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 53 53 53 165 184 209 191 203 219 217 221 225 225 228 230 222 226 231 59 101 158 67 116 189 82 134 196 72 125 201 80 118 190 76 115 189 82 141 218 93 152 223 87 149 230 56 122 226 91 156 241 103 168 246 176 189 203 189 200 211 8 51 135 118 198 49 16 82 167 41 81 155 255 255 255 107 153 185 99 137 181 102 158 195 71 118 197 87 142 207 77 136 216 60 122 218 62 126 225 47 112 220 52 136 255 163 179 196 173 187 202 247 62 14 214 219 224 220 224 230 227 229 232 56 98 156 255 218 89 58 102 183 64 118 197 62 107 191 83 123 191 82 137 205 64 123 210 58 119 216 55 120 222 97 160 234 95 159 239 149 151 153 58 58 58 179 195 214 210 218 226 14 57 138 24 178 255 46 89 152 117 120 123 95 132 173 52 100 190 67 118 197 81 118 187 82 118 188 61 119 208 57 116 213 52 113 217 84 148 234 111 155 206 97 162 243 114 178 250 186 198 209 207 215 226 41 142 195 227 230 232 41 84 150 68 109 161 132 133 133 70 117 189 74 119 191 79 120 191 86 125 192 63 118 208 59 114 206 52 111 210 92 154 232 85 150 238 101 165 242 55 55 55 176 193 214 204 211 218 8 52 137 27 70 143 37 80 149 63 105 160 89 125 167 77 129 193 68 109 186 53 106 201 79 120 194 65 117 205 62 112 200 107 149 198 45 106 211 71 137 232 111 155 207 164 180 197 171 189 212 194 206 221 11 55 137 224 227 229 60 124 168 33 110 194 0 0 0 72 123 192 65 117 197 71 113 191 84 121 190 68 116 201 88 147 220 81 143 227 110 154 204 90 154 237 84 150 238 165 181 198 167 186 210 201 209 217 8 51 136 22 66 143 32 75 147 36 80 161 71 121 190 45 101 200 77 132 203 76 120 196 71 116 198 104 144 191 68 131 221 70 135 228 63 129 229 48 112 220 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C??????????????????????????????????0@@@@@b');
                            yourself);
                yourself
        ]
!

desktopOSX16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self desktopOSX16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#desktopOSX16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary desktopOSX16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@A)4\ =G60\QZ@@@R!!+G \4Z8:KP4MB(*JP>N#*"(&4=YK<RL0:^ EQEPLV^$D8#HM]]- &<$''3A06JF!!L;O%<V \8>B^-=S$6H7
Q%]LV-R36@H\&MM=0JW -YD-E8T^Z-T5,TRT!!>\''X2HE2AU)9*D)P#DJ4X/DTM&,]\H,"Q!!K&]:>7#0T''149N@4^+%&*9KI0*5Y\M"#^6#/KK2EI:NSJBH2;
3G$+[&=,VEV&+YU^J''\3/P02*V,%XX98AEEB,K#"_;($IB9HR@NH"MYR1>D4Y;PK Z_\1!!BVP[%CW444@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 95 79 95 239 239 255 79 64 128 207 207 223 208 192 240 223 143 208 223 208 224 111 80 111 160 112 176 79 47 96 112 95 144 64 48 80 176 192 224 192 127 176 96 48 96 112 95 127 79 79 80 111 79 111 95 64 111 240 224 255 128 95 160 192 112 207 176 191 191 191 96 191 95 63 128 175 175 175 95 79 96 175 175 176 79 63 127 208 160 224 176 111 176 207 207 208 96 64 96 112 80 143 224 176 224 112 64 111 223 223 255 95 111 144 224 223 240 224 175 224 112 80 160 63 48 96 63 32 64 95 96 160 176 111 191 239 143 224 208 208 240 144 96 144 223 224 224 111 80 144 111 128 175 80 48 96 16 15 31 96 95 144 127 111 175 224 191 223 175 112 176 223 175 240 192 160 191 143 96 160 128 96 175 80 64 95 207 175 207 176 176 176 96 63 95 64 64 80 95 79 128 47 47 48 95 79 143 95 47 80 239 160 224 111 95 111 224 224 255 79 63 128 96 80 96 48 31 80 208 112 208 31 16 31 96 47 96 224 239 240 224 176 240 48 32 80 192 192 208 176 95 160 111 48 96 224 207 224 127 95 144 223 143 223 255 240 255 96 64 143 176 95 175 191 191 191 128 112 175 48 32 95 31 15 63 48 48 63 223 223 224 191 192 224 239 191 223 240 192 240 48 47 80 239 224 240 224 208 224 32 16 48 95 64 95 176 112 207 63 16 63 127 128 176 112 112 160 175 144 175 176 176 255 159 159 223 160 127 191 240 239 255 128 111 128 63 48 111 127 96 128 224 143 208 223 208 223 112 79 128 159 144 160 191 207 255 143 79 143 160 160 176 175 96 160 159 80 144 224 224 224 208 191 223 111 47 96 64 63 80 95 63 127 208 207 208 208 144 208 192 111 207 208 159 207 144 80 160 224 223 224 112 64 144 223 224 240 143 96 175 143 95 143 239 223 240 191 191 207 79 63 111 111 48 111 224 144 223 144 80 143 223 144 207 128 80 160 111 95 144 63 63 64 159 95 143 95 64 128 64 48 96 223 224 223 176 176 191 192 207 208 239 224 255 111 63 96 176 128 207 16 16 63 48 16 64 207 175 208 175 160 175 208 175 207 224 159 208 95 79 127 80 79 95 208 160 208 192 208 255 96 79 143 144 96 160 208 159 208 79 48 127 143 95 175 208 207 223 31 0 48 64 63 127 96 64 127 95 47 95 63 48 80 223 175 223 64 47 96 239 239 240 31 15 47 48 47 48 239 223 255 111 80 128 112 63 127 208 191 224 128 96 160 80 64 111 192 111 176 192 128 176 191 96 176 223 160 207 175 127 191 96 48 95 64 64 64 79 64 95 192 111 191 240 224 240 64 32 80 128 80 128 192 207 255 47 32 48 223 144 223 192 112 191 207 160 207 127 80 144 239 224 224 128 64 143 191 112 176 32 31 80 224 224 240 16 15 48 31 31 64 224 191 240 111 79 143 111 95 127 64 63 64 191 176 191 143 111 175 175 95 160 255 207 240 0 0 16 96 80 127 160 128 175 32 16 64 223 223 223 112 64 143 191 128 207 96 79 144 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@C?????????????????????????????????????@@@b');
                            yourself);
                yourself
        ]
!

diff16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self diff16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#diff16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary diff16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:15) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@BH"H"H @@@@HQDQDR@@@@@!!DQ@@@@@@@BDQ@QD @@@@HQ@QDR@@@@@!!DADQH@@@@BDPDQD @@@@HQ@QDR@@@@@!!DPDQH@@@@BDQD@@@@@@@HQ
DQDR@@@@@!!DQDQH@@@@BH"H"H @@@@@@@@@@@@@@')
            colorMapFromArray:#[0 0 0 255 255 255 132 132 132]
            mask:((ImageMask width:16 height:15) bits:(ByteArray fromPackedString:'@@A?0G?@_<A?8G?P_=A?4G?P_?A?>G?\_<9?1 @@'); yourself); yourself]
!

diff16x16Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self diff16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#diff16x16Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary diff16x16Icon2'
        ifAbsentPut:[(Depth4Image width:16 height:15) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@DQDQDQ@@@@@P"IBH$@@@@ABL$@@@@@@@DH"@"I@@@@@P!!ABD$@@@@ABHDH"P@@@@DHPP!!I@@@@@P"ABH$@@@@ABL HRP@@@@DH"P@@@@@@@P!!
IBD$@@@@ABH$H"P@@@@DQDQDQ@@@@@@@@@@@@@@@')
            colorMapFromArray:#[0 0 0 0 252 0 255 255 255 248 0 0 132 132 132]
            mask:((ImageMask width:16 height:15) bits:(ByteArray fromPackedString:'@@A?0G?@_<A?8G?P_=A?4G?P_?A?>G?\_<9?1 @@'); yourself); yourself]
!

doIt16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self doIt16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#doIt16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class doIt16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@A@@@@@@@@@A@@@@@@@@@ADD@@@@@@@A@E@@@@@@@A@DP@@@@@@A@DS@@@@@@A@DSLQDD@@A@DSLQDD@@@@@@@QDD@@@@@@@ADD@@@@@@
@DDD@@@@@@@@ED@@@@@@@@@D@@@@@@@@@D@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 248 252 128 208 220 0 255 255 255 63 63 64]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@X@C @^@C0@_@C?0_?C?8O?@C8@O@A8@G@@X@@@@b'); yourself); yourself]
!

down16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self down16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#down16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class down16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@EUUUU@@@@@@U&@CT@@@@@AVL3QP@@@@@EX3ME@@@@@@TCL4T@@@UUURL3QUUUAPH3L3L3MAT@TBL3L3MAT@@E@#L3MAT@@@APH3MAT@@@@@
TBMAT@@@@@@EAAT@@@@@@@AQT@@@@@@@@@T@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 192 255 255 0 64 64 0 255 255 0 192 192 0 128 128 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O8@? C>@O8@? ??;??''?<O? _<@? A<@C @D@@@@b');
                            yourself);
                yourself
        ]
!

edit16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self edit16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#edit16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary edit16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:17) bits:(ByteArray fromPackedString:'
************L3L3L3L:.:(1DQ QDQ.5*#DQFADQ.5V*NH"H"H.5UZ(1DQ Q.5UW*#DQFA.5UWR*NH"H,%UWZ*(1DQ("UWZ**#DQF2H"PJ**NH""H''^ **(1
DYI7 1B**#DYYHLQDJ**N*B**** **(1DQ(QDQB*) @@@@@@@J*********** @a')
            colorMapFromArray:#[0 0 0 255 255 255 255 220 168 220 220 220 64 0 0 255 128 0 48 48 48 192 88 0 195 195 195 88 88 88 160 160 160 255 168 88]
            mask:((ImageMask width:16 height:17) bits:(ByteArray fromPackedString:'@@@?>3??O?<??3??O?<??#?<O?0??C?<O?0??C?<_?0@@@@a'); yourself); yourself]
!

editcopy16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self editcopy16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#editcopy16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class editcopy16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUU@@@@@@ATQDUP@@@@@EQDQRT@@@@@U@AEP%@@@@ATQDUUUUT@@EP@QCL5QU@@UDQDIBUEEPAT@@P@ITUATEQDIBH%QUUUU@A@@BUDL3UTIBH"ITQDEUUU
UUUPA@AE@@@@UDQDQDT@@@AT@D@@QP@@@EQDQDQE@@@@UUUUUUTb');
                colorMapFromArray:#[ 48 48 48 220 220 220 255 255 192 160 160 160 255 255 255 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'?@C>@O<@?8C?<O?8??3??/??????????@?<C?0O?@?<b');
                            yourself);
                yourself
        ]
!

editcut16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self editcut16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#editcut16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class editcut16x16Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@4@@@@4@@@@4@@@@4@@@@4@@@@4@@@@4@@@@@$@@@@CP@@@@M@@@@@4@@@@CP@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 220 220 220 128 128 128 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@A8A,0O1!!9"OC=8C?@C8@O C?@?^FH<1!!;LC7 F@@@b');
                            yourself);
                yourself
        ]
!

editpaste16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self editpaste16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#editpaste16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class editpaste16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@Q@@@@@ADQDP@QDQ@AY&XPDPE&XPEFXP@@@AY!!@TY!!DQDQE&DAQ&Y!!H"HQXPEFY&D"H!!TQ@TY&XRL2D%DQQ&Y!!H"HQDQEFY&D#L"Y&DTY&XRH"IRTQQ&
Y!!H3L#MQEFY&D"IRUUDVY&XRL2L3TPDQDQIRUUUQ@@@@DQDQDQDb');
                colorMapFromArray:#[ 192 192 0 0 0 0 255 255 255 48 48 48 220 220 220 255 255 192 160 160 160 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@XA??O?>??;??/?>??;??????????????????7??@?<b');
                            yourself);
                yourself
        ]
!

edittrash16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self edittrash16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#edittrash16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class edittrash16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@0@@@@@@@@N@H@@@@@@QE&Y@Y(@@@C!!!!DVX"H@@@ACNH"DP@@@@H"DP"Q0@@@@ XNDP''@@@@BA 8QB\@@@@HFC!!DI0@@@@ XNDP''@@@@BA 8QB\@@@@H
FC!!DI0@@@@ XNDP''@@@@@1 8QB\@@@@@@3"D@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 88 88 88 220 220 220 128 128 128 93 93 93 195 195 195 48 48 48 160 160 160 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'A8@?>G?<_?0?>C?8O? ?>C?8O? ?>C?8O? ?>A?0A<@b');
                            yourself);
                yourself
        ]
!

erase16x16Icon
    <resource: #programImage>

    ^ self erase16x16Icon2
!

erase16x16Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self erase16x16Icon1 inspect
     ImageEditor openOnClass:self andSelector:#erase16x16Icon1"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class erase16x16Icon1'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@8@#0LG!! GL@O @\@C8@\0C!! \BC0DN@@P@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

erase16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self erase16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#erase16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class erase16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@@@@@3@@@C@@@@@0@3@C@A@@@@@ @0@A@@@@@@H@@A@@@@@@@C@C@@@@@@@C@@L@@@@@@C@PHC@@@@@@LP@B@@@@@@
L@@@@ @@@@@1@@@@@@@@@C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 192 0 0 64 0 0 128 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@HCA0_O@_8@?@A8@O A7@FL@0XC@ H@@@@@@@b');
                            yourself);
                yourself
        ]
!

exec16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self exec16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#exec16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class exec16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@A7@@@@@@A7A9%0]0@@A9A0Q@\I\@@GBR@3@)A0@@A2L8NCI0@@]9@8H# I]0^T@8L@"#AI]2BR"(!!ZJPI0\Q$()XJQE0@GII$"&TI0@GARD)$!!IP\@^P
E7@G\P%0@G]0^U\G]0@@@@A1I0@@@@@@@@]0@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 160 160 160 88 88 88 128 128 128 255 168 88 195 195 195 255 255 255 93 93 93 0 0 0 255 220 168 220 220 220 255 255 192 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@X@[6C?<O?0_>G?>?''???7?>O?1??''?>N=0C0@F@@@@b');
                            yourself);
                yourself
        ]
!

exit16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self exit16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#exit16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class exit16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@QDQ@@@@@@DRH"H"@@@@@RH H"H@@@@RH"@"H%@@@AH"HBH"T@@@D"H H"IP@@@RH"@"H%@@@AH"HBH"T@@@@"H H"TC@@@B
H"H"UP@@@@@EUUT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 220 220 220 128 128 128 93 93 93 160 160 160 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@G0A?0O? ?>G?<_?1??G?<_?0??C?8G?@G0@@@@@@b');
                            yourself);
                yourself
        ]
!

fileNew16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileNew16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#fileNew16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileNew16x16Icon'
        ifAbsentPut:[(Depth1Image width:16 height:16) bits:(ByteArray fromPackedString:' @F@@X@A#<FO4X?A#?&O>X?9#?&O>X?9#?&O>X@A0@Db')
            colorMapFromArray:#[0 0 0 255 255 255]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@A? G?@_>A?<G?0_?A?<G?0_?A?<G?0_?A?<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a'); yourself); yourself]
!

fileOpen16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileOpen16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#fileOpen16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class fileOpen16x16Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'0@@@@0@@@@@@@@@@@@@@@@@@@@@]@@@@M7]0@A7]4@@7P@@@GR**(CR**(@R**(@B**(@@@@@@@@@@@@<@@@@0@a');
                colorMapFromArray:#[ 0 0 0 255 255 0 128 128 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@\@BJ@@Y0C/? ?>C?8O????;??O?8??C?8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fileSave16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileSave16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#fileSave16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class fileSave16x16Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'0@@@@0@@@@@D**( AJ**@@R**!!@D**(PAJ**D@R**!!@E@@APAUUUT@T@@A@E@@(PAP@JD@T@B!!@@@@@@@@@@@0@a');
                colorMapFromArray:#[ 0 0 0 128 128 0 212 208 200 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@A??''?>_?9??''?>_?9??''?>_?9??''?>_?9??#?>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fileclose16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileclose16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#fileclose16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class fileclose16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"@@H @@@@@BH H"@@@@@@@"H"@@@@@@@@H"@@@@@@@@H"H @@@@@@H"@"H@@@@@
@"@@H @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 93 93 93 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@O C? _?A?<O?8??#?>O?8??!!?<G?0O>@O @@@b');
                            yourself);
                yourself
        ]
!

filter16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self filter16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#filter16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary filter16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
H1$YFQ$YFR$YFQ$DLA$DD"D:C 8NC 8NK@8NC 8NKA,@MP$^J2XH@R<CEQXVIPH@@@@5GA8"@A@LER4VKS\@@@@@@CTZG!!  CCHWIP,@@@@@@@@@F10*D0XV
KS\@@@@@@@@@@@@_BR<LC0,@@@@@@@@@@@@@@CXAHB$@@@@@@@@@@@@@@@@6@R@6@@@@@@@@@@@@@@@@M#P DP@@@@@@@@@@@@@@@CXAD2$@@@@@@@@@@@@@
@@@.M@L8@@@@@@@@@@@@@@@@MR\ JP@@@@@@@@@@@@@@@@@5JC @@@@@@@@@@@@@@@@@@@H1@@@@@@@@@@@@@@@@@@@@B @@@@@@@@@a');
                colorMapFromArray:#[ 255 240 0 240 224 20 112 80 20 255 192 0 144 96 20 240 240 220 255 176 30 255 240 255 255 240 20 240 240 50 112 80 30 112 64 20 255 192 20 240 224 220 255 255 255 255 176 60 255 224 0 160 112 0 128 96 30 255 208 20 240 240 210 255 176 20 255 160 30 255 176 50 255 255 30 144 96 0 240 240 60 96 80 50 240 240 80 240 224 210 255 240 100 80 80 30 255 208 0 80 80 60 255 240 50 128 112 60 240 255 240 240 176 50 255 255 20 240 224 30 224 192 20 160 96 0 255 240 60 255 240 80 255 255 240 255 160 50 144 128 20 240 208 20 144 80 0 128 80 20 240 176 30 240 255 255 240 224 0 96 80 20 144 112 20 128 64 0 160 112 20 224 224 220 240 240 240 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'?????7?>O?0_>@?0A>@C0@O@@<@C0@O@@<@A0@C@@D@b');
                            yourself);
                yourself
        ]
!

filterBlue16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self filterBlue16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#filterBlue16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary filterBlue16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GDQDQDQD@@@B:Y&Y&X@@@@@P)&Y$@@@@@@LL"H@@@@@@@CFL@@@@@@@@AQ @@@@@@@@]]@@@@@@@@A;P@@@@@@@
@H/@@@@@@@@@ U@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 52 70 80 100 136 150 96 130 150 80 110 130 64 98 120 92 124 140 40 52 60 32 42 50 112 148 170 88 118 130 64 88 100 76 102 120 80 116 130 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@O? _<@? A<@C @N@@8@C @N@@8@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

finish16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self finish16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#finish16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class finish16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@AD@@@@@@@@@DY@@@AD@@@@P6P@@DP@@@ABM$@@Q@QDQDH#Y@ADAEUVL"H6PDPDT"H"H"M$Q@Q"H"H"H!!ADAFH"H"H!!ADPDHQDRH!!A@Q@QD
QDH!!A@AD@@@@P!!A@@DP@@@AAA@@@Q@@@@DA@@@AD@@@@Q@@@@@@b');
                colorMapFromArray:#[ 0 64 64 0 128 128 0 192 192 0 255 255 0 0 0 255 255 255 192 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C@@NC@<LC87?3_?-??7??_?=?>7?3@>LC00NC@0@b');
                            yourself);
                yourself
        ]
!

flagRed16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self flagRed16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#flagRed16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class flagRed16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@F@@@@@@@@@FY @@@@@@@FA&@@@@@@Y&APY @@@FXEUPI&@@@@YUUSIBY @@A%T3IBI&@@@@X4QBI&Y @@A$QBI A&@@@@YBY @@Y @@@F
X@@@A&@@@@@@@@@@Y @@@@@@@@A&@@@@@@@@@@Y @@@@@@@@A&@b');
                colorMapFromArray:#[ 195 195 195 93 93 93 192 0 0 255 192 192 255 0 0 255 255 255 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A@@N@A8@?0O?@?>C?8G?0_3@>FA X@@0@C@@F@@Xb');
                            yourself);
                yourself
        ]
!

formatCode16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self formatCode16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#formatCode16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary formatCode16x16Icon'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@AUUUUPP@@UTEUUUUAP@AUPUUUUTE@@AUAUUUUPUU@ATEUUUUAUT@EPUUUUTE@@@UAUUUUPUUUUT@@@@@@@a') colorMapFromArray:#[0 0 0 255 255 255]; yourself]
!

formatCodeAndAccept16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self formatCodeAndAccept16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#formatCodeAndAccept16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary formatCodeAndAccept16x16Icon'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@AUUUUP)@@ATJUUUUB%@@EP)UUUTJT@@EB%UUUP)UT@DJUUUUB%UP@P)UUUTJT@@AB%UUUPUUUUT@@@@@@@a')
            colorMapFromArray:#[0 0 0 255 255 255 0 255 0]; yourself]
!

forward16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self forward16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#forward16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class forward16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@BH@@@@@@@@@IB@@@@@@@@@!!P @@@@@@@B@TH@@@@"H"H@EB@@@BL3PP@AP @@H0@@@@@TH@@$@@@@@@YR@BP@@@@@YR@@HFY&@@YR@@@"
H"H@YR@@@@@@@ YR@@@@@@@BYR@@@@@@@@IR@@@@@@@@@"@@@@@b');
                colorMapFromArray:#[ 0 192 192 0 255 255 0 0 0 255 255 255 192 255 255 0 64 64 0 128 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A @G@@^@A<C?8O?0??#??O?8??C?8@_@A8@G@@X@b');
                            yourself);
                yourself
        ]
!

functionsOnly16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self functionsOnly16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#functionsOnly16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class functionsOnly16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
QDQDQDQDQDQDQDQDQDQDQDQEITQDQDQDQEA@UDQDQDQDMDQEETEQUDPTQEADQDDEQAQDEDEDEAEADQPTQAEDDTPTQAQDDTPQQAQDEDEDEAEDEDQPQDQAATPT
QDTUPUETQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDPb');
                colorMapFromArray:#[ 63 63 95 0 0 0 3 0 2 0 1 0 159 191 191 191 191 191 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@A0@M @!!3"LCH$%:LRH1H$$#@2GN@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

goto16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self goto16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#goto16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary goto16x16Icon'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[0 0 0] mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@C@@>@G0@?@C8@G@C@@^B@0<@G0@>@C8@O@BX@\@A0@b'); yourself); yourself]
!

grid16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self grid16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#grid16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary grid16x16Icon'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'UUUUUTDDDDEAAAAAUUUUUTDDDDEAAAAAUUUUUTDDDDEAAAAAUUUUUTDDDDEAAAAAUUUUUTDDDDEAAAAAUUUUUP@a') colorMapFromArray:#[248 248 248 248 184 112 0 0 0]; yourself]
!

gridAlign16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self gridAlign16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#gridAlign16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary gridAlign16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
H"H"H"H"H"H)$)$)$)$)$"&R&R&R&R&RH"H"H"H"H"H)$)$)$)$)\"&R&R&R&RFBH"H"H"H"\KH)$)$)$)]J$"&WFR&R^K&RH"]GH"]+H"H)$*!!9\C$)$"&R
&$]E&R&RH"H"U@H"H"H)$)$#$)$)$"&R&R&R&R&RH"H"H"H"H"Hb') colorMapFromArray:#[32 12 48 32 56 216 248 184 112 40 36 32 32 48 92 40 12 8 8 0 144 24 60 216 88 36 120 248 248 248 32 40 32 32 16 0]; yourself]
!

history16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self history16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#history16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class history16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@ADQDQD@@@@@DQDQDP@@@@@QDQDQ@@@@@ADQDQDA@@@@DQDQDPD@@@@@@@@@@P@@@@@QDQDQ@P@@@ADQDQDA@@@@@@@@@@D@@@@@DQDQDPD@@@
@QDQDQ@P@@@@@@@@@A@@@@@ADQDQD@@@@@DQDQDP@@@@@@@@@@@b');
                colorMapFromArray:#[ 1 104 205 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'?<C?0O?@??C?<O?0??0??C?<O?<O?0??C?<C?0O?@?<b');
                            yourself);
                yourself
        ]
!

idea16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self idea16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#idea16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class idea16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@BH"H@@@@@@BAUTB@@@@@BA*V @ @@@BAZU%)PH@@@HJUVV*@ @@@ )VQ%(B@@@BA&I T@H@@@@ T H@H@@@@@H@H@H@@@@@@*@ ( @@@@@@HB@ @@@@@@
@"L"@@@@@@@BNXH@@@@@@@JI\ @@@@@@@!! R@@@@@@@@H"@@@@@b');
                colorMapFromArray:#[ 255 255 0 48 48 48 0 0 0 220 220 220 255 255 255 255 220 168 255 255 192 160 160 160 88 88 88 128 128 128 255 168 88 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'A<@O8A?0O? ?>C?8O? _<@? C>@G0@_@A<@G0@_@@8@b');
                            yourself);
                yourself
        ]
!

indent16x16Icon
    <resource:#programImage>
    ^ self indent16x16Icon1

    "Modified: / 06-04-2011 / 18:37:52 / cg"
!

indent16x16Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self indent16x16Icon1 inspect
     ImageEditor openOnClass:self andSelector:#indent16x16Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary indent16x16Icon1'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@D@@@@AP@@@EU@@@@E@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 0 0 128]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@?8@@@O>@@@BG?L_?8@CG?H_<@@C?@@@@?0@@@@@@b'); yourself); yourself]
!

indent16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self indent16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#indent16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary indent16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"H"H"H"H@@"H"H@@@@@@BHRH"H"H"@@H!!D"@@@@@@DQDQH"H"H @BHQH @@@@@@H!!H"H"H"H@@"
H"H@@@@@@BH"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 34 110 181 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@O?8??#?>O?8??''?>O?8??#?>O?8?? @@@@@b');
                            yourself);
                yourself
        ]
!

javaPackage16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaPackage16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#javaPackage16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary javaPackage16x16Icon'
        ifAbsentPut:[(Depth4Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
;.;.;.;.;.;.;.;.;.;.;.;.;.8N;.;.;.***"***.;.:\3KSL29;.;(3-1L;\#.;.#M7D3]2N;.9;3KF<27;.8BQDDQQDHN;.[L213L-.;.9\;\SN7E;.;#
3]1L7\O.;.N<24/L,>;.:#L3H3L:;.;.;.8N;.;.;.;.;.;.;.8b') ; colorMapFromArray:#[112 56 16 127 80 56 144 80 24 160 88 24 160 112 88 175 96 40 176 96 40 191 104 40 191 112 40 192 120 40 192 128 48 208 168 136 224 200 160 239 208 168 255 240 184]; mask:((Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@B@G?0_?A?<G?0_?C?>G?0_?A?<G?0_?@B@@@@b') ; yourself); yourself]
!

leftAdjust16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self leftAdjust16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#leftAdjust16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary leftAdjust16x16Icon'
        ifAbsentPut:[(Depth1Image width:16 height:16) bits:(ByteArray fromPackedString:'@@A??$@B_?9@O''?>P@I??$@>_?9@@''?>PC9??''?>@@@b') colorMapFromArray:#[0 0 0 255 255 255]; yourself]
!

leftDown16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self leftDown16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#leftDown16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class leftDown16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@EUUUUUUT@@@T@@@@@AP@@APL3L3L5@@@E@3MDQDT@@@TCL4UUUP@@ARL3QP@@@@@EL3ME@@@@UUT3L3UUT@@E@#L3MAT@@@APH3MAT@@@@@
TBMAT@@@@@@EAAT@@@@@@@AQT@@@@@@@@@T@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 192 255 255 0 64 64 0 255 255 0 192 192 0 128 128 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O? ?>C?8O? ?>C>@O8G?<O? _<@? A<@C @D@@@@b');
                            yourself);
                yourself
        ]
!

lock16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self lock16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#lock16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class lock16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@]7\@@@@@@@\Z*(@@@@@@]''"G)0@@@@A: @_H@@@@@G2@A< @@@@@]5@G1P@@@@^H!!RJH @@@\3)&E$M5@@A3@DP4L7T@@HN0QDL3]P@@!!+DVZ*)5@@BF
,QY&*''T@@E*1E&**]P@@U+DVZ*M5@@AS@DP4L7T@@@VBJH"XT@@b');
                colorMapFromArray:#[ 255 220 168 220 220 220 64 64 0 128 128 0 192 192 0 0 0 0 195 195 195 88 88 88 48 48 48 64 0 0 160 160 160 255 255 255 128 128 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@<@G8@?0C''@N\@90G? ??C?<O?0??C?<O?0??C?<G? b');
                            yourself);
                yourself
        ]
!

palette16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self palette16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#palette16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary palette16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
;.;.L3L>;.;-;#&***''.;.89**GL*#;.;#**(\2*''.;#(K.****^;#*+U:**(8;.N**-***^;.8:JH****L>;#*H"*****$8N*****'']&*L:*$QJ+X#Z(3**
QD*-;-*#8:)$Z*'']N*''.N*******(>;)******L=;.:SL3L3'']8b')
            colorMapFromArray:#[16 48 240 240 8 0 32 104 0 143 96 56 240 200 56 48 48 168 239 232 128 79 48 120 0 152 0 160 112 0 172 140 108 15 48 248 255 8 0 170 140 140 255 248 248]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@>@O<C?8O?!!?>O?0?>C?>O?>????3??O_?<??1?>C? b'); yourself); yourself]
!

paste16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self paste16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#paste16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class paste16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@FX@@@@@AWTF@FA5\@@G\CL3L0]P@@U0@@@@A7@@A5]WU5]WT@@E]WV**** @@]WU:DQDZ(@AWU5(QDQ(Z@GU5^!!@@F** U5
]ZDQDQDZA5]W(P@@@A(@@@B!!DQDQF @@@J******@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 0 212 208 200 255 255 255 128 128 0 255 255 0 128 128 128 0 255 255 0 0 255 0 0 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@G G?8??3??O?<??3??O?<??;???????=??0O?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

pipette16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self pipette16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#pipette16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class pipette16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
FQ$[F18^G!!8^G!!8^J"(^G!!\YF1,[G!!8^G!!8^IR (C!!$WFQ([F18^G!!8^IR$*J"TYE1\YF!!,[G!!8YIR *J"$SFQ\WFQ([F1,[IR *J"$TFQ$WE1\YF!!,YFR $
J" JFQ$YE1\WFQ$YFQ@]JAHCFQ$YFQXWE1\WE1T#I \LFQ$YFQ$UE!!\WE1X&I $YFQ$YFQ$YEQXVFQD&H  YFQ$YFQ$YFQTUEQD&HPPYFQ$YFQ$YFQ,UEQ@''
H@HYFQ$YFQ$YFQ([FP<&G0DYFQ$YFQ$YFQ$YFP4!!G@@YFQ$YFQ$YE1$WFQ$XBPTYFQ$YFQ$YE1$YE1\WB0XYFQ$YFQ$YFQ$YE1\WE0@a');
                colorMapFromArray:#[ 48 48 50 48 48 60 64 72 80 80 8 20 80 88 100 88 72 60 96 72 60 96 104 120 96 104 130 112 120 140 120 24 20 120 88 70 128 24 20 128 96 70 136 40 40 136 96 70 136 96 80 136 104 80 144 24 20 144 32 40 144 40 40 144 104 80 144 104 90 144 112 90 144 120 110 152 112 90 152 112 100 152 120 100 152 160 190 160 160 180 168 136 110 168 184 220 176 192 220 184 200 230 192 216 240 200 216 230 208 48 50 208 56 60 216 240 240 224 240 240 240 64 70 240 88 100 240 136 140 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@0@G @>@G8@?@C8@_@C8@^@C0@^@C0@^@C0@N@@0@@b');
                            yourself);
                yourself
        ]
!

printIt16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self printIt16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#printIt16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary printIt16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@Y&Y&Y @@@@A$QDQ@@@@@@FQDQ@L@@@@BYDQ@L@@BH@I$Q@L0Q@H @&Q@L1@@@B@BY@L1D3LBH@I L1D3L@H @ @@@3LE@"@BYDPCLETBH@I$
P@LEUPH @&QPLEUU@"@@YU@EUUT@@@A&XFY&X@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 255 255 255 0 255 0 248 252 128 248 252 248 168 228 240 64 64 64]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@?8C? O?@?>C?8O?0?>C?8O? ?>C?8O? ?>C?8@@@b'); yourself); yourself]
!

redo16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redo16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#redo16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class redo16x16Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@O@ACDHB0 GB@<DG0P@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@O@ACDHB0 GB@<DG0P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

redo16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redo16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#redo16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class redo16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@L3L@@@@@@CL@@CL@@@@C@@@@@C@@LC@!!L2@@@0H0LSL@L2@@L#LC@@@@L @BL3L@@@@C@@H3L0@@@@L@@#L3@@@@H"H"LCL@@@L3L3L0L3
@@@@@@@@@CL0@@@@@@@@@3L0@@@@@@@@@3L@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 192 0 0 64 0 0 128 0 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@G A? O?E?>7''?8G? O>@?8G= ?7@@N@@^@@\@@@@b');
                            yourself);
                yourself
        ]
!

reload16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self reload16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#reload16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class reload16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@ARH@L@@@@@T"P@@@@@@@@"P@@@@@@@ARP@@@@@@@@BI@@@@@@@AUH"I@@@@@@@T"I@@@@@@@@EI@@@@@@@@@A@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 192 0 0 64 0 0 128 0 0 255 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@>@O>A>\G0P>@#8@?9!!?OC9>GO<HOD@<HG 9>A?0A<@b');
                            yourself);
                yourself
        ]
!

removeTab16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self removeTab16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#removeTab16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'XPToolbarIconLibrary class removeTab16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@RA HA@PDA@PDA@PHFD @@A#=2\WA-[F-*ZV!!"M@X@@@M5YEUQSTU@OS$6Q&LN@@@A]%=W^U%AN$I8MSA''CP@@@WQX^''9=S$]=
_''\*Y 0@@@E3T%)=_''5=_''4;J&TL@@@A[#01O''1>_''0-HRA^B0@@@V@2JC]<_''9<I1(VS@(@@@E]K#M<_''1<_'',$ED$I@@@AWB1/_''0)I7->XQMHB@@@@U,&
H6<''G14$XQ$WQ@\@@@QVNBH^GQ(XEQL[J4LO@@@PK5QSTD=KR$%HQDL%D@@@GADE@PDA@PDA@PDEDQ0@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 167 25 15 173 52 41 174 53 42 178 59 50 178 60 51 181 74 64 184 45 32 184 46 32 184 47 34 185 53 39 186 57 42 186 59 43 186 60 45 187 74 60 188 71 59 188 89 81 188 91 82 195 132 118 207 64 48 208 65 49 209 65 49 209 66 49 209 69 52 210 66 49 210 78 64 211 67 51 211 71 54 211 157 147 212 69 51 213 69 52 213 70 52 213 79 57 215 80 59 218 79 62 218 84 67 219 107 95 221 84 63 221 84 67 221 109 96 222 76 56 222 110 96 222 113 79 223 87 67 223 87 70 223 115 99 225 89 72 225 105 91 225 117 84 227 89 64 227 91 73 227 112 98 227 115 95 227 122 92 228 113 83 228 113 99 229 102 87 230 115 84 230 117 81 230 142 117 231 102 80 231 116 86 231 120 103 231 131 119 232 118 88 232 119 82 233 143 117 234 99 76 234 102 79 234 119 89 234 127 100 234 145 119 235 104 82 235 106 86 236 108 89 236 110 92 236 113 92 236 121 91 236 146 119 237 113 95 237 115 98 237 122 92 237 132 100 238 117 101 238 119 104 238 123 93 238 123 109 238 131 98 238 133 102 238 146 120 238 148 121 239 125 112 239 127 115 239 129 118 239 131 105 239 134 102 240 135 122 240 200 196 242 135 113 242 141 116 242 141 119 242 145 116 242 147 118 242 148 120 243 137 115 243 138 118 243 141 121 243 142 123 243 144 126 243 145 129 243 151 134 243 202 197 244 147 132 244 149 135 244 152 137 244 163 142 244 164 145 245 160 143 245 164 146 245 213 204 246 213 203 248 215 205 249 215 206 252 244 243 253 244 243 253 247 245 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@A??''?>_?9??''?>_?9??''?>_?9??''?>_?9??''?>@@@b');
                            yourself);
                yourself
        ]
!

removeTabEntered16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self removeTabEntered16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#removeTabEntered16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'XPToolbarIconLibrary class removeTabEntered16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@M@0D@@@@@@@@@@@DCCP@@@1)HRD]EQDMBPD@>FPL@@@EHPC\7M3P4MCL1NS8J@@@@RC(4P3\1K#UAK"8<BP@@@D\7P4%IMSUI
RTD,N0 @@@AGM3UIRT%IRT$4KC,G@@@@QCD*K4!!IRTX+IRP8A0@@@DH,I25HRT%FJRD_L \@@@A@KB5HRTYFRTX''G"<F@@@@PB(?RTX)JTYIOA4-AP@@@C8(
I#4)H2H''OBD^J0P@@@H;LBX#H"D G14_I",L@@@KFC 8M#T2LB<-J2,WB0@@C ,B@@@@@@@@@@@BB08@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 160 24 8 175 48 40 176 56 48 176 72 64 191 56 40 191 56 48 191 64 48 191 72 56 191 72 64 191 80 64 191 88 72 191 88 80 192 80 64 192 128 112 208 152 144 208 208 192 223 208 192 223 216 200 224 216 208 224 224 208 239 224 216 239 232 216 239 232 224 240 120 112 240 168 152 240 176 160 240 208 200 240 232 224 240 240 224 255 88 72 255 96 72 255 96 80 255 104 80 255 104 88 255 112 88 255 112 96 255 120 96 255 120 104 255 128 112 255 136 120 255 144 120 255 144 128 255 152 128 255 152 136 255 160 136 255 160 144 255 168 144 255 168 152 255 168 160 255 176 152 255 176 160 255 184 152 255 184 160 255 184 168 255 184 176 255 192 168 255 192 176 255 192 184 255 200 176 255 208 192 255 208 200 255 208 208 255 216 200 255 216 208 255 224 208 255 224 216 255 232 216 255 232 224 255 240 224 255 240 232 255 240 240 255 248 232 255 248 240 255 248 248 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@A??''?>_?9??''?>_?9??''?>_?9??''?>_?9??''?>@@@b');
                            yourself);
                yourself
        ]
!

repositoryCVSIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositoryCVSIcon inspect
     ImageEditor openOnClass:self andSelector:#repositoryCVSIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class repositoryCVSIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$\I2X%J20\NS$9NS$9NS$WHA8LDAX[JA\9NS$9NS$9H2D]CA@VF2 7NS$9NS$9NSL*F@,SF"P6MS$9NS$9NS$2G1HLDAX[JCT9NS$9NS$9LQ<RC@<UF2 4
NS$9NS$9NR8_DP4NEA,(MC$9NS$9NS$-APTEAPTEAPTEAPTEAPT9KPTA@PDA@PDA@PDA@PDENR<E@PDDA@DDB@PHA PAAS$0AP A@0$H@0$CBPLI@PT9L@TI
@PLIBPXIA $AA DENRHEB DD@ (J@ (J@ PAAS$9AP(JB (JB (JB (JB T9NPTEAPTEAPTEAPTEAPTENS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 245 246 251 25 50 99 40 69 126 47 75 130 69 80 102 34 56 94 78 91 112 242 245 249 237 248 254 227 246 255 249 240 101 252 248 161 252 248 162 251 240 138 251 239 139 251 239 140 249 232 112 249 233 112 246 223 77 246 224 88 246 224 89 246 224 90 185 160 32 243 213 53 117 110 75 237 197 37 240 207 60 194 167 52 249 213 68 249 216 77 240 200 59 251 201 44 251 203 45 199 167 58 191 147 29 226 166 20 186 138 21 188 142 23 188 137 19 242 177 31 141 118 66 226 156 19 183 129 16 178 115 11 178 119 30 177 118 30 180 121 31 180 121 32 175 117 31 175 116 32 175 118 32 185 110 19 184 110 20 229 121 6 170 93 6 90 90 90 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O8A?0G?@_<A?0G?@_<A??7??_?=??7??_?<??3??@@@b') ; yourself); yourself]
!

repositoryCheckIn
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self repositoryCheckIn inspect
     ImageEditor openOnClass:self andSelector:#repositoryCheckIn
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class repositoryCheckIn'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@TCP<MB  T@@@@@@@@@@@RG2H)JBP^FQH@@@@@@@@@DB@!!JR $G!!$F@@@@@@@@@@$VGR\#FA\UB0@@@@@@@@@GF2X)JBP^FP,@@@@@@@@@BQ,&
JR $G!!$K@@@@K"8.K"8.K"8(IA8YB0@@@@@@J2</J2,.JBP^FP,@@@@@K"<,K2<+K" $G!!$L@@@@K"0,K2</J28(IA8YC@@@K"4-K28.K",.JBT^FP0@K",-
KB8@BQ,.K"LXE1TE@B8/KR8@@AL[I"8#FA\UA@@.K28@@@@@D1LSD1@NDP@@K",.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 128 0 48 152 0 63 184 0 111 248 40 175 152 48 176 96 40 176 104 40 176 128 56 191 128 40 191 128 56 191 136 48 192 120 48 192 128 48 192 144 48 192 144 56 192 152 48 192 152 56 192 160 56 192 168 56 207 160 56 207 176 80 224 120 8 224 152 16 224 160 16 239 192 40 240 176 24 240 192 64 240 200 56 240 200 64 240 208 48 240 208 56 255 200 40 255 200 48 255 208 64 255 216 80 255 224 80 255 224 88 255 224 96 255 232 104 255 240 96 255 240 136 255 248 160 241 241 241 50 155 0 109 255 36 133 255 72 40 124 0 60 186 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@O8A?0G?@_<A?0G?G?<G?0??G?<??77?^_=0?''@@@@@b');
                            yourself);
                yourself
        ]
!

repositoryCheckOut
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self repositoryCheckOut inspect
     ImageEditor openOnClass:self andSelector:#repositoryCheckOut
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class repositoryCheckOut'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@TCP<MB  T@@@@@@@@@@@RG2H)JBP^FQH@@@@@@@@@DB@!!JR $G!!$F@@@@@@@@@@$VGR\#FA\UB0@@@@@@@@@GF2X)JBP^FP,@@@@@@@@@BQ,&
JR $G!!$K@@@@@@@@@@@@@@@(IA8YB0@@@@@@@@DB@ DB@BP^FP,@@@@@@@LC@0@@JR $G!!$L@@@@@@LC@0@\I"$(IA8YC@@@@PHC@ @IF"X)JBT^FP0@@@HC
@ @@BQX]I2LXE1TE@@@B@ H@@APVGR\#FA\UA@@@@PHB@@@@EALSD1@NDP@@@@DA@PD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 128 0 48 152 0 63 184 0 111 248 40 175 152 48 176 96 40 176 104 40 176 128 56 191 128 40 191 128 56 191 136 48 192 120 48 192 128 48 192 144 48 192 144 56 192 152 48 192 152 56 192 160 56 192 168 56 207 160 56 207 176 80 224 120 8 224 152 16 224 160 16 239 192 40 240 176 24 240 192 64 240 200 56 240 200 64 240 208 48 240 208 56 255 200 40 255 200 48 255 208 64 255 216 80 255 224 80 255 224 88 255 224 96 255 232 104 255 240 96 255 240 136 255 248 160 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@O8A?0G?@_<A?0G?@?<G?4??W?=??77?__=<?''8@_0@b');
                            yourself);
                yourself
        ]
!

repositoryGitIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositoryGitIcon inspect
     ImageEditor openOnClass:self andSelector:#repositoryGitIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class repositoryGitIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$\I2X%J20\NS$9NS$9NS$WHA8LDAX[JA\9NS$9NS$9H2D]CA@VF2 7NS$9NS$9NSL*F@,SF"P6MS$9NS$9NS$2G1HLDAX[JCT9NS$9NS$9LQ<RC@<UF2 4
NS$9NS$9NR8_DP4NEA,(MC$9NS$9NS$-JR$)JR$)JR$)JR$)JR$9KR$A@PDA@PDA@PDA@PD)NR<Y@PDDA@DAA@DDA@PAFS$0FP$CBPDA@PPABPPA@Q$9L@@I
A $F@0DF@P$F@PD@NRH8@P(D@ (AA (A@ (ANC$9A0(AB (JB (JB (AB \9NPTEAPTEAPTEAPTEAPTENS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 245 246 251 25 50 99 40 69 126 47 75 130 69 80 102 34 56 94 78 91 112 242 245 249 237 248 254 227 246 255 249 240 101 252 248 161 252 248 162 251 240 138 251 239 139 251 239 140 249 232 112 249 233 112 246 223 77 246 224 88 246 224 89 246 224 90 185 160 32 243 213 53 117 110 75 237 197 37 240 207 60 194 167 52 249 213 68 249 216 77 240 200 59 251 201 44 251 203 45 199 167 58 191 147 29 226 166 20 186 138 21 188 142 23 188 137 19 242 177 31 141 118 66 226 156 19 183 129 16 178 115 11 178 119 30 177 118 30 180 121 31 180 121 32 175 117 31 175 116 32 175 118 32 185 110 19 184 110 20 229 121 6 170 93 6 90 90 90 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O8A?0G?@_<A?0G?@_<A??7??_?=??7??_?<??3??@@@b') ; yourself); yourself]
!

repositoryHGIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositoryHGIcon inspect
     ImageEditor openOnClass:self andSelector:#repositoryHGIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class repositoryHGIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$\I2X%J20\NS$9NS$9NS$WHA8LDAX[JA\9NS$9NS$9H2D]CA@VF2 7NS$9NS$9NSL*F@,SF"P6MS$9NS$9NS$2G1HLDAX[JCT9NS$9NS$9LQ<RC@<UF2 4
NS$9NS$9NR8_DP4NEA,(MC$9NS$9NS$-JR$)JR$)JR$)JR$)JR$9KR$A@PDA@PDA@PDA@PD)NR<Y@PDD@PDD@PDDA@DAFS$0FP AA@(JA@$CBPDA@Q$9L@@I
@PXDA@XIA $F@0D@NRH8B DBB (F@P(D@ (ANC$9A0(AB (JB (JB (AB \9NPTEAPTEAPTEAPTEAPTENS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 245 246 251 25 50 99 40 69 126 47 75 130 69 80 102 34 56 94 78 91 112 242 245 249 237 248 254 227 246 255 249 240 101 252 248 161 252 248 162 251 240 138 251 239 139 251 239 140 249 232 112 249 233 112 246 223 77 246 224 88 246 224 89 246 224 90 185 160 32 243 213 53 117 110 75 237 197 37 240 207 60 194 167 52 249 213 68 249 216 77 240 200 59 251 201 44 251 203 45 199 167 58 191 147 29 226 166 20 186 138 21 188 142 23 188 137 19 242 177 31 141 118 66 226 156 19 183 129 16 178 115 11 178 119 30 177 118 30 180 121 31 180 121 32 175 117 31 175 116 32 175 118 32 185 110 19 184 110 20 229 121 6 170 93 6 90 90 90 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O8A?0G?@_<A?0G?@_<A??7??_?=??7??_?<??3??@@@b') ; yourself); yourself]
!

repositoryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositoryIcon inspect
     ImageEditor openOnClass:self andSelector:#repositoryIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class repositoryIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$\I2X%J20\NS$9NS$9NS$WHA8LDAX[JA\9NS$9NS$9H2D]CA@VF2 7NS$9NS$9NSL*F@,SF"P6MS$9NS$9NS$2G1HLDAX[JCT9NS$9NS$9LQ<RC@<UF2 4
NS$9NS$9NR8_DP4NEA,(MC$9NS$9NS$-APTEAPTEAPTEAPTEAPT9KPTA@PDA@PDA@PDA@PDENR<E@PDA@PDA@PDA@PDAAS$0AP A@PDA@PDA@PDA@PT9L@TI
@PHB@PHB@PHB@PDENRHEB DD@ (B@ (B@ DAAS$9AP(JB (JB (JB (JB T9NPTEAPTEAPTEAPTEAPTENS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 245 246 251 25 50 99 40 69 126 47 75 130 69 80 102 34 56 94 78 91 112 242 245 249 237 248 254 227 246 255 249 240 101 252 248 161 252 248 162 251 240 138 251 239 139 251 239 140 249 232 112 249 233 112 246 223 77 246 224 88 246 224 89 246 224 90 185 160 32 243 213 53 117 110 75 237 197 37 240 207 60 194 167 52 249 213 68 249 216 77 240 200 59 251 201 44 251 203 45 199 167 58 191 147 29 226 166 20 186 138 21 188 142 23 188 137 19 242 177 31 141 118 66 226 156 19 183 129 16 178 115 11 178 119 30 177 118 30 180 121 31 180 121 32 175 117 31 175 116 32 175 118 32 185 110 19 184 110 20 229 121 6 170 93 6 90 90 90 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O8A?0G?@_<A?0G?@_<A??7??_?=??7??_?<??3??@@@b') ; yourself); yourself]
!

repositoryLog
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self repositoryLog inspect
     ImageEditor openOnClass:self andSelector:#repositoryLog
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class repositoryLog'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4E@@@@@@@@@@@@@@@@@@DLF @@@@@@@@@@@@@@@A0A@P0E@@@@@@@@@@@@@@@WAP4AB0@C
@0LC@0\@@@@@E@@ECP@@@1PTFA I@@@@@@@RGA\@@@LXFA XBP@@@@@DC!!TXAA,CEAPTE@$@@@@YA XDA@P[@1 XFA I@@@@B@PDB (JD@LTEAPTBP@@@@ J
B@ [E!!LCFA XF@$@@@@WC0<OD1LQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 146 146 146 255 218 144 241 241 241 255 255 255 126 186 0 255 157 108 133 255 72 192 192 192 84 124 0 160 160 164 105 155 0 186 126 0 255 255 180 255 206 108 109 255 36 20 62 0 42 62 0 6 6 6 133 133 133 18 18 18 95 95 95 248 248 248 62 62 0 108 108 108 222 222 222 69 69 69 255 255 144 63 93 0 128 128 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@8@G @_@A=>G''8N_#?>O?8??#?>O8@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

repositoryMCIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositoryMCIcon inspect
     ImageEditor openOnClass:self andSelector:#repositoryMCIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class repositoryMCIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$\I2X%J20\NS$9NS$9NS$WHA8LDAX[JA\9NS$9NS$9H2D]CA@VF2 7NS$9NS$9NSL*F@,SF"P6MS$9NS$9NS$2G1HLDAX[JCT9NS$9NS$9LQ<RC@<UF2 4
NS$9NS$9NR8_DP4NEA,(MC$9NS$9NS$-JR$)JR$)JR$)JR$)JR$9KR$A@PDA@PDA@PDA@PD)NR<Y@PDD@PDDB@DDA@ AFS$0FP HA@LDA@ D@P$H@Q$9L@@I
BPPA@PPHA DAB@D@NRH8B (D@P(DB DDA@ ANC$9A0(JB (JB (JB (JB \9NPTEAPTEAPTEAPTEAPTENS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 245 246 251 25 50 99 40 69 126 47 75 130 69 80 102 34 56 94 78 91 112 242 245 249 237 248 254 227 246 255 249 240 101 252 248 161 252 248 162 251 240 138 251 239 139 251 239 140 249 232 112 249 233 112 246 223 77 246 224 88 246 224 89 246 224 90 185 160 32 243 213 53 117 110 75 237 197 37 240 207 60 194 167 52 249 213 68 249 216 77 240 200 59 251 201 44 251 203 45 199 167 58 191 147 29 226 166 20 186 138 21 188 142 23 188 137 19 242 177 31 141 118 66 226 156 19 183 129 16 178 115 11 178 119 30 177 118 30 180 121 31 180 121 32 175 117 31 175 116 32 175 118 32 185 110 19 184 110 20 229 121 6 170 93 6 90 90 90 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O8A?0G?@_<A?0G?@_<A??7??_?=??7??_?<??3??@@@b') ; yourself); yourself]
!

repositoryP4Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositoryP4Icon inspect
     ImageEditor openOnClass:self andSelector:#repositoryP4Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary repositoryP4Icon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$\I2X%J20\NS$9NS$9NS$WHA8LDAX[JA\9NS$9NS$9H2D]CA@VF2 7NS$9NS$9NSL*F@,SF"P6MS$9NS$9NS$2G1HLDAX[JCT9NS$9NS$9LQ<RC@<UF2 4
NS$9NS$9NR8_DP4NEA,(MC$9NS$9NS$-JR$)JR$)JR$)JR$)JR$9KR$A@PDA@PDA@PDA@PD)NR<Y@PDAA@PAB@PAB@ AFS$0FP HB@LIA@ DA@$H@Q$9L@@I
BP$DA@$HA XFB@D@NRH8B (J@ (JB (FB  ANC$9A0(JB (JB (JB (JB \9NPTEAPTEAPTEAPTEAPTENS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 245 246 251 25 50 99 40 69 126 47 75 130 69 80 102 34 56 94 78 91 112 242 245 249 237 248 254 227 246 255 249 240 101 252 248 161 252 248 162 251 240 138 251 239 139 251 239 140 249 232 112 249 233 112 246 223 77 246 224 88 246 224 89 246 224 90 185 160 32 243 213 53 117 110 75 237 197 37 240 207 60 194 167 52 249 213 68 249 216 77 240 200 59 251 201 44 251 203 45 199 167 58 191 147 29 226 166 20 186 138 21 188 142 23 188 137 19 242 177 31 141 118 66 226 156 19 183 129 16 178 115 11 178 119 30 177 118 30 180 121 31 180 121 32 175 117 31 175 116 32 175 118 32 185 110 19 184 110 20 229 121 6 170 93 6 90 90 90 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O8A?0G?@_<A?0G?@_<A??7??_?=??7??_?<??3??@@@b') ; yourself); yourself]
!

repositoryPerforceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositoryPerforceIcon inspect
     ImageEditor openOnClass:self andSelector:#repositoryPerforceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class repositoryPerforceIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@T@@@@@A \H@@@@BP(KC@4NC0@@DADRD0@@@APUE!!\XFQ([GA4^G2@@@@@!!H"L$@BT&I2 )J",,@@@@KR8/LCD2L3P5
M#\8NP@@@C(;OC4>O4AAP$MDQP@@@@AFQ4!!IR$-LST8@S5@@@@@@TRIRT5QUU%\@VE%Z@@@@@E-\WU9_XFE"@FM$YP@@@@@@@FY''J&!!)Z&-,[V9/@@@@@@@@
\GE2\7Q5]'']8^P@@@@@@@@@@@@@@@G);@@@@@@@@@@@@@@@@@@A<_P@@@@@@@@@@@@@@@@@@_''<@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 166 144 53 162 134 43 161 134 43 163 134 42 149 116 32 144 140 67 165 134 41 84 61 13 155 131 46 247 203 70 238 189 60 232 178 48 227 174 50 235 185 58 187 145 44 147 149 89 241 206 86 235 183 54 107 78 15 148 120 36 239 191 62 209 157 41 75 52 8 56 39 5 188 142 37 232 182 57 113 86 23 87 91 60 236 207 95 226 178 57 222 171 50 69 50 8 148 117 34 239 192 62 195 146 38 11 6 0 176 156 56 237 186 59 152 122 44 166 147 71 211 158 37 212 165 50 211 161 45 37 26 3 148 120 38 239 192 63 214 167 51 169 132 38 179 159 56 232 201 82 227 176 50 146 118 41 163 121 29 94 67 11 206 174 54 192 144 39 13 9 0 148 121 41 239 191 65 229 181 58 226 176 54 221 171 51 213 164 48 179 141 44 120 91 25 94 68 13 14 14 3 236 199 63 162 122 34 149 118 29 238 191 62 209 158 41 70 52 14 45 35 9 116 105 55 128 100 29 101 74 14 2 1 0 245 202 63 129 99 31 150 117 28 200 150 39 16 9 0 120 120 76 208 170 64 154 111 22 12 7 0 127 112 33 238 192 58 98 76 22 124 95 24 207 164 53 194 147 38 78 74 37 211 184 80 211 158 42 93 68 14 72 57 12 181 171 75 228 179 55 100 78 21 31 23 6 141 121 44 230 181 57 242 192 57 244 192 56 241 192 57 234 191 67 227 179 59 241 189 56 215 166 47 89 65 13 104 76 15 106 78 17 103 79 23 104 80 24 106 79 20 221 176 55 211 163 48 110 85 22 105 78 19 239 199 62 163 122 32 235 188 57 138 100 22 85 64 18 50 38 9]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@>GG<<_?1;?G?<_?!!?6G>8_; _?@?<@C@@L@@0@@@b') ; yourself); yourself]
!

repositorySVNIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self repositorySVNIcon inspect
     ImageEditor openOnClass:self andSelector:#repositorySVNIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class repositorySVNIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
NS$\I2X%J20\NS$9NS$9NS$WHA8LDAX[JA\9NS$9NS$9H2D]CA@VF2 7NS$9NS$9NSL*F@,SF"P6MS$9NS$9NS$2G1HLDAX[JCT9NS$9NS$9LQ<RC@<UF2 4
NS$9NS$9NR8_DP4NEA,(MC$9NS$9NS$-JR$)JR$)JR$)JR$)JR$9KR$A@PDA@PDA@PDA@PD)NR<Y@PPD@PPHA@ D@PPAFS$0FP CBP CBPLI@0LD@Q$9L@@I
BPXIA $FBPXCA D@NRH8B HBB (BB (BB PANC$9A0(JB (JB (JB (JB \9NPTEAPTEAPTEAPTEAPTENS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 97 99 245 246 251 25 50 99 40 69 126 47 75 130 69 80 102 34 56 94 78 91 112 242 245 249 237 248 254 227 246 255 249 240 101 252 248 161 252 248 162 251 240 138 251 239 139 251 239 140 249 232 112 249 233 112 246 223 77 246 224 88 246 224 89 246 224 90 185 160 32 243 213 53 117 110 75 237 197 37 240 207 60 194 167 52 249 213 68 249 216 77 240 200 59 251 201 44 251 203 45 199 167 58 191 147 29 226 166 20 186 138 21 188 142 23 188 137 19 242 177 31 141 118 66 226 156 19 183 129 16 178 115 11 178 119 30 177 118 30 180 121 31 180 121 32 175 117 31 175 116 32 175 118 32 185 110 19 184 110 20 229 121 6 170 93 6 90 90 90 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O8A?0G?@_<A?0G?@_<A??7??_?=??7??_?<??3??@@@b') ; yourself); yourself]
!

repositoryTag
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self repositoryTag inspect
     ImageEditor openOnClass:self andSelector:#repositoryTag
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class repositoryTag'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH"H"H"@@@JL3L3L3N@@BL3L3L3L8@KJVL3L3L3 K/NT3L3L3N@@BL3L0LC@8@@43L3L3L3 @@ML3L3L3N@@@
@DQDQDQA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 35 35 35 98 98 98 128 128 66 252 252 128 68 68 68 129 65 65 128 64 2 241 241 241 67 67 67 128 64 64 190 190 66 2 2 2 66 66 66 65 65 3 97 65 3 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A?8O?1??O?=??1??G?<O?0_?@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

repositoryVersions
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self repositoryVersions inspect
     ImageEditor openOnClass:self andSelector:#repositoryVersions
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class repositoryVersions'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@#FA(XH0@@@@@@@@@@@@@JABDNA@PJ@@@@@@@@@@@#ABD[HPPDG"L@@@@@@@@@FBDQC1XOB!!8X@@@@@@@@@A(\B08NABD^
F @@@@@@@@@ZD T$E \[G!! @@@@@@@@ICQLSD2D[A@XV@@@@@@@I@0HJD1LAG X]ER@@@@@@@0$@@1XXF!! VE@0"EP@@@@@@@@LC@@@@@A<U@BHU@@@@@@@C
@0@@@@@@CQT@E1T@@@@@@0L@@@@@@@@MEP@WH@@@@@LC@@@@@@@@@@4UDB@@@@@C@0@@@@@@@@@@@AT_@@@@@0L@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 186 126 0 74 140 199 95 159 191 63 95 159 180 230 255 79 124 169 146 146 146 160 160 164 241 241 241 63 127 191 120 120 120 89 144 198 217 147 0 82 82 82 235 235 235 192 192 192 155 105 0 222 222 222 74 134 193 79 141 199 62 42 0 124 84 0 95 95 95 255 206 108 57 57 57 159 191 191 0 0 0 255 255 255 90 145 199 31 31 31 144 218 255 69 69 69 93 63 0 248 248 248 255 218 144 108 108 108 162 186 210 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O A?@O>@?8C? O>A?8O?07? X_A >FA<XC1 CF@@b');
                            yourself);
                yourself
        ]
!

rightAdjust16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self rightAdjust16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#rightAdjust16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary rightAdjust16x16Icon'
        ifAbsentPut:[(Depth1Image width:16 height:16) bits:(ByteArray fromPackedString:'@@A??$@B_?9<@''?>P@I??''0B_?9@@''?>_@I??''?>@@@b') colorMapFromArray:#[0 0 0 255 255 255]; yourself]
!

run16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self run16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#run16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class run16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@AT@@@@@@!!@@EP@AT@@CPRMDT!!P0@@ATQDQDP0@@@CQEMTQD@@@@IEL@EDH@@AEDL@@AQAD@L4QP@@EDL0@@MDD@EDT@@@ADQAEDQ@@@@A
QDQDQC@@@AP4IDMAP0@@T0@AL@@#@@@@@@D0@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 220 220 220 128 128 128 195 195 195 160 160 160 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A CFLO?0_>A?8G''!!<O''0>G'' _>A?8O?01#@F@@@@b');
                            yourself);
                yourself
        ]
!

scrollDownOff16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollDownOff16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollDownOff16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary scrollDownOff16x16Icon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHCAP HB@ H
B@ GA@TF@@DB@0 RD1PUE!!\XB@PEA @A@ LEB@4NC1@QB@\DAPX@@PHC@0THB ,LB@\CA@TF@@DB@0LCAP IB@\C@0PEA @A@ LC@0LGB@\C@0LDAPX@@PHC
@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @a')
            colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; yourself]
!

scrollLeftOff16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollLeftOff16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollLeftOff16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary scrollLeftOff16x16Icon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDB@ HB@ HB@ HB@ HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LCAP E@0LC@0LC@0LC@0LEBAHH
B@LC@0LC@0LC@0LEB@4SB@ C@0LC@0LC@0LCB@(NE@ H@0LC@0LC@0LC@0$KC1THB@LC@0LC@0LC@0LHCA@VB@ C@0LC@0LC@0LCA0 QE0 H@0LC@0LC@0LC
@0LGBA HB@LC@0LC@0LC@0LC@0LGB@\C@0LC@0PDA@PDA@PDA@PDA@PDA@PEAPTEAPTEAPTEAPTEAPTEA XFA XFA XFA XFA XFA @a')
            colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b'); yourself); yourself]
!

scrollRightOff16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollRightOff16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollRightOff16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary scrollRightOff16x16Icon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDB@ HB@ HB@ HB@ HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0LCAP E@0LC@0LC@0LC@0LC@0 RB@TC
@0LC@0LC@0LC@0LHD04HAPLC@0LC@0LC@0LCBAPNB  G@0LC@0LC@0LC@0 UC0,IB@LC@0LC@0LC@0LHE!!@LB@\C@0LC@0LC@0LCBA\QB@\C@0LC@0LC@0LC
@0 XB@\C@0LC@0LC@0LC@0LGB@\C@0LC@0LC@0PDA@PDA@PDA@PDA@PDA@PEAPTEAPTEAPTEAPTEAPTEA XFA XFA XFA XFA XFA @a')
            colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b'); yourself); yourself]
!

scrollUpOff16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollUpOff16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollUpOff16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary scrollUpOff16x16Icon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LCA0 G
@0LCA@TF@@DB@0LCAP IB@\C@0PEA @A@ LCAP JB00HA0LDAPX@@PHCAP MC <PDP GA@TF@@DB@0 RD1PUE!!\XB@PEA @A@ LEB@ HB@ HB@\DAPX@@PHC
@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @A@ LC@0LC@0LC@0LDAPX@@PHC@0LC@0LC@0LCA@TF@@DB@0LC@0LC@0LC@0PEA @a')
            colorMapFromArray:#[228 228 230 232 232 230 236 238 240 240 240 240 240 242 240 244 242 240 236 234 230 244 244 240 244 246 250 44 46 50 32 30 30 52 54 50 92 92 90 32 34 30 72 74 70 120 122 120 140 140 140 136 134 130 84 86 90 120 120 120 156 158 160 176 174 170 184 184 180 192 192 190 184 182 180]; yourself]
!

search16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self search16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#search16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class search16x16Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@ @ @@@@@@@@@@@@B@B@@@@@@@@PDD@@DBA@@B@@ @@@@@@@P@@D@H@@B@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 212 208 200 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@\\A10GG@>>C;8_?3??/?>??;>?/ >>C;8O @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

search16x16Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self search16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#search16x16Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary search16x16Icon2'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HB@@@@@@@@@@@@@@@@@0PEAPXC@@@@@@@@@@@@A0 IB (IB00@@@@@@@@@@ 4NC1@QC1HS@ @@@@@@@APUE!!\X
FPDZF10@@@@@@@@]G!!< @PD!!H"L$@@@@@@@@IRXEI0DAJB$*I@@@@@@@@@X+K@H-K"<0LSH@@@@@@@D3MCT6M3\8NS(2@@@@@@D;OC4>O4A@PTHB@@@@@@EC
QDUFQ4!!IN0DW@@@@@@EJR41MS @@@@@@@@@@@@@AS5AQT @@@@@@@@@@@@@@@EMTUP@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 223 224 248 208 208 248 240 232 248 191 200 240 143 160 208 192 200 240 207 216 248 127 144 200 63 88 168 47 88 184 127 152 200 208 224 248 79 104 200 48 80 160 79 112 176 144 184 240 144 176 240 48 88 168 80 120 208 175 184 216 47 72 168 95 96 176 239 224 248 255 240 224 240 232 240 79 96 168 47 80 160 208 216 240 159 168 200 31 64 160 159 168 224 255 232 248 223 208 248 128 152 216 32 64 160 191 184 208 144 160 184 31 64 168 255 248 248 239 232 248 112 128 200 31 48 160 15 48 160 64 88 168 255 240 240 240 240 248 207 208 248 48 64 144 47 64 160 224 216 240 191 192 240 31 56 168 16 32 144 32 48 160 95 104 200 32 56 144 32 56 136 128 160 216 176 184 224 64 80 144 15 32 136 64 88 176 31 48 136 16 40 144 32 64 136 128 152 200 191 184 224 63 72 136 16 48 128 96 104 168 208 216 248 224 232 248 191 192 224 191 184 216 64 72 120 15 32 104 63 96 184 240 248 248 128 128 184 31 40 80 111 112 144 239 216 248 208 208 224 176 184 200 223 216 224]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@X@G8@?0G? _>A?8G? _>C?8_?C?8_ A<@C @D@@b'); yourself); yourself]
!

searchNext16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self searchNext16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#searchNext16x16Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class searchNext16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@DUUT@@@@@@DT@AE@E@@@@T@@@AUT@@@AP@@@EUP@@@DT@@EUU@@@@AE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@P@@@@@@C@@@C@@@@@@D@A@D@@@@@@@
@@@@@@@@@C@@@@L@@@@@D@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 0 212 208 200 128 128 128 0 0 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
A<@LY@ \BA0LO@X@FL@X0C7 _?A?<G?0^OA8<G#0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

searchPrev16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self searchPrev16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#searchPrev16x16Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class searchPrev16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@UUU@@@@@T@U@@EP@@@AUT@@@AP@@@EUP@@@E@@@@UUT@@EP@@@@@@@@EP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@P@@@@@@@@0@@@0@@@@@AA@@A@@@@
@@@@@@@@@@@@L@@@@0@@@@@P@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 0 212 208 200 128 128 128 0 0 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@>@&LC PNA@<L@A @1 CF@^<C?8O? ?>C18OG <^@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

settings16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self settings16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#settings16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class settings16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@LC@0@@@@@@@@XC"@@@@@@H00^B0@@@@@XC"PN@@@@@@@#E1<G@@@@C"PNF@@RG @@@@ [A0@@H@8OF@@@AQD @A<UH!!T@
H@8[@@@@@@\YFA WHR@GH@8[@@@@@@@@A14YHR@ H@8[@@@@@@@@@@@GEQTRH@8 A @@@@@@@@@@@@@A@P8 G1 L@@@@@@@@@AXAE $AD1 \D1P@@@@@@AXA
E $B@P@QD10PA@@@@AXAE (B@QX@@A$SF!!LC@@@AE 4B@QX@@@@@D1PCDP@@@P4B@QX@@@@@@@@CDP@@@@4A@QX@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 47 80 128 95 136 184 111 104 96 111 104 104 112 112 104 112 112 120 127 120 120 127 128 120 127 160 200 127 168 208 128 128 120 128 128 128 128 168 208 143 136 128 143 136 136 159 144 144 159 152 144 159 152 160 160 160 160 160 160 168 175 168 168 175 200 240 176 168 168 176 176 176 191 184 184 192 184 184 192 192 184 192 192 200 207 200 200 208 200 208 208 208 208 223 216 216 224 224 216 224 224 224 239 232 224 240 240 240 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@NA0<OA8=#''''^8_?@?8A? A?@_>C=<_39>G''0L^@@b');
                            yourself);
                yourself
        ]
!

settings16x16icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self settings16x16icon inspect
     ImageEditor openOnClass:self andSelector:#settings16x16icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary settings16x16icon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@3HCL@@A,GF0@@@@@@@@@5G1<"J0@TI@LL@@@@@@@@H H @@@@@AX@J@0@@@@@B LBC0@MM @@C# (L0@@@AD#H3P#ER,@@@@ID" 3@@,$
I2D$EQH@@@@@@@$RG1,WHS\EL!!$@@@@@@@@@@CT4M2D%@@@@@@@@@@@@@CXWI0L*JP@@@@@@@@@@@AP#@PT-G XD@@@@@@@@@APUK"\]JQ0^G"0@@@@@@@4!!
K @]@@@&GA8XK@@@@@4WK D2@@@@@B$HA!! /@@@5GPTQ@@@@@@@@F  FFAL@E2@Q@@@@@@@@@@@0G@ P@A4R@@@@@@@@@@@@@AXVLP@a') ; colorMapFromArray:#[94 94 94 68 72 75 235 237 237 201 201 201 242 218 221 119 119 119 236 182 45 239 239 239 217 164 40 252 252 252 197 198 199 242 247 250 237 242 246 212 206 212 250 250 250 200 201 201 226 217 187 150 151 153 129 129 129 216 171 95 223 225 218 150 150 151 212 216 210 172 173 173 237 203 50 176 176 177 170 172 173 213 212 210 197 149 41 162 162 163 249 222 55 214 216 216 195 192 192 139 139 139 182 183 186 161 161 160 191 192 193 191 190 190 227 228 227 106 106 105 220 222 223 212 167 152 206 175 122 239 240 239 195 140 101 171 136 90 59 60 60 193 113 46 221 177 180 255 255 255 143 143 144 234 238 240 207 207 209 169 168 169 235 235 236 128 128 128 126 122 111]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@A3 O/@8^G,<_1;>C?0C8@_ C?@_>C9<_C98G7@OX@\b') ; yourself); yourself]
!

showCodeCoverage16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self showCodeCoverage16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#showCodeCoverage16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary showCodeCoverage16x16Icon'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@AUUUUPZ**UTEUUUUAZ*)UPUUUUTE**)UAUUUUPUU?=TEUUUUAUW?5PUUUUTE***UAUUUUPUUUUT@@@@@@@a') colorMapFromArray:#[0 0 0 255 255 255 140 247 115 255 0 0]; yourself]
!

smalllintError16x16
    "I want all icons to be named *icon* - ever tried to search an icon,
     if there is no consistent naming?"
    ^ self smalllintErrorIcon16x16
!

smalllintErrorIcon16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smalllintErrorIcon16x16 inspect
     ImageEditor openOnClass:self andSelector:#smalllintErrorIcon16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class smalllintErrorIcon16x16'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@DA@PDA@@@@@@@@@@@@@@DB@0PC@ D@@@@@@@@@@@DBAPXFA TE@P@@@@@@@@@AA0XHA  FA0D@@@@@@@@@@P$JB0,KA 0A
@PD@@@@@@@DIB 4NCP(IC1@Q@P@@@@@@D!!LT@QPSD!!@UD@D@@@@@@@DVE0DXE <YF!!$O@P@@@@@@@Q,\GPDPFQ(YD@D@@@@@@@D^@Q< HQ$"FRD @P@@@@@A
H2P%DA$&F"XYD@D@@@@@@R\(JR(+KB4,J2(A@@@@@@@A@PD.J"(*J"(.@@@@@@@@@@@@@PDA@PDA@P@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 255 248 252 240 98 96 239 58 56 239 64 64 240 106 96 255 184 176 239 66 56 255 179 168 240 74 56 255 192 176 255 207 200 239 74 56 255 240 240 255 229 224 239 136 141 224 88 98 239 160 167 255 144 136 240 94 64 255 197 184 255 219 208 255 147 128 255 112 96 255 99 88 255 139 128 80 0 8 191 125 120 207 227 240 176 134 120 128 208 200 80 136 134 224 120 126 239 106 96 208 61 56 128 184 174 176 181 184 95 136 135 239 120 120 176 200 194 79 120 119 202 200 208 207 48 63 255 157 144 240 154 136 176 86 80 224 162 160]
            mask:((Depth1Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@_@C>@_<A?0G?0_? ?>C?<G?0_?!!?>G?8O?@G<@@@b'); yourself); yourself]
!

smalllintInformationIcon16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smalllintInformationIcon16x16 inspect
     ImageEditor openOnClass:self andSelector:#smalllintInformationIcon16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary smalllintInformationIcon16x16'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@DA@PDA@@@@@@@@@@@@@@DB@0PC@ D@@@@@@@@@@@DBAPXFA TE@P@@@@@@@@@AA0XHA  FA0D@@@@@@@@@@P$JB0,KA 0A
@PD@@@@@@@DIB 4NCP(IC1@Q@P@@@@@@D!!LT@QPSD!!@UD@D@@@@@@@DVE0DXE <YF!!$O@P@@@@@@@Q,\GPDPFQ(YD@D@@@@@@@D^@Q< HQ$"FRD @P@@@@@A
H2P%DA$&F"XYD@D@@@@@@R\(JR(+KB4,J2(A@@@@@@@A@PD.J"(*J"(.@@@@@@@@@@@@@PDA@PDA@P@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 248 255 254 96 166 240 56 145 239 64 152 239 96 158 240 176 207 255 56 137 239 168 200 255 56 130 240 176 199 255 200 220 255 56 129 239 240 248 255 224 234 255 136 193 239 88 166 224 160 207 239 136 187 255 64 122 240 184 206 255 208 220 255 128 172 255 96 159 255 88 160 255 128 180 255 0 48 80 120 150 191 240 236 207 120 134 176 208 160 128 136 106 80 120 178 224 96 157 239 56 127 208 184 146 128 184 183 176 136 115 95 120 179 239 200 182 176 120 99 79 202 208 200 48 143 207 144 186 255 136 170 240 80 122 176 160 190 224]
            mask:((Depth1Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@_@C>@_<A?0G?0_? ?>C?<G?0_?!!?>G?8O?@G<@@@b'); yourself); yourself]
!

smalllintWarningIcon16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smalllintWarning16x16 inspect
     ImageEditor openOnClass:self andSelector:#smalllintWarning16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary smalllintWarning16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@DA@PDA@@@@@@@@@@@@@@DB@0PC@ D@@@@@@@@@@@DBAPXFA TE@P@@@@@@@@@AA0XHA  FA0D@@@@@@@@@@P$JB0,KA 0A
@PD@@@@@@@DIB 4NCP(IC1@Q@P@@@@@@D!!LT@QPSD!!@UD@D@@@@@@@DVE0DXE <YF!!$O@P@@@@@@@Q,\GPDPFQ(YD@D@@@@@@@D^@Q< HQ$"FRD @P@@@@@A
H2P%DA$&F"XYD@D@@@@@@R\(JR(+KB4,J2(A@@@@@@@A@PD.J"(*J"(.@@@@@@@@@@@@@PDA@PDA@P@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 248 248 240 184 96 239 168 56 239 168 64 240 192 96 255 232 176 239 176 56 255 232 168 240 184 56 255 240 176 255 240 200 239 184 56 255 248 240 255 248 224 239 192 136 224 160 88 239 200 160 255 216 136 240 200 64 255 240 184 255 248 208 255 224 128 255 208 96 255 200 88 255 216 128 80 40 0 191 168 120 207 208 240 176 168 120 128 168 208 80 104 136 224 176 120 239 192 96 208 152 56 128 160 184 176 176 184 95 112 136 239 192 120 176 192 200 79 96 120 207 200 208 207 128 48 255 224 144 240 216 136 176 144 80 224 200 160]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@_@C>@_<A?0G?0_? ?>C?<G?0_?!!?>G?8O?@G<@@@b') ; yourself); yourself]
!

snapshot16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self snapshot16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#snapshot16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary snapshot16x16Icon'
        ifAbsentPut:[(Depth4Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@G\0@@@@@0M0\3A7L0@CL3@3LCL3@@@@@@@@@@@@@@@@&Y@@@@@@L@&X&P@@@@@0BX&Y@@@@@CLI"Y$@@@@@@@&Y&P@@@@@@
@I&P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 255 0 0 0 212 208 200 255 255 255 128 128 0 255 255 0 128 128 128 0 255 255 138 138 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@C G?<??;??/?>??;??/?>??;??/?>??9??@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

sortByLineNumber16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sortByLineNumber16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#sortByLineNumber16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary sortByLineNumber16x16Icon'
        ifAbsentPut:[(Depth4Image width:16 height:16) bits:(ByteArray fromPackedString:'
L3L3L3L3L3L3L3L3L3L3L3QTL3L3L3L3MFP3L3MAMAL4]CL3L4D4D3PTL3L4EDECMAP4DQDQDQD4ECMDPSPTQCPTL3MAMAL3MAP4DQDQDQD4ECMDEDEDQCPT
L4D4D3L3DA@SPSPSL3L!!DRL3L3L3L3HRL3L3L3L3L3L3L3L3L3Lb')
            colorMapFromArray:#[63 63 95 0 0 0 159 159 159 159 191 191 191 191 191 1 1 3 3 0 2 0 1 0]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@G@@\CY0M''A>]?=377CX]?=3?7M >6C8@G@@@@@b'); yourself); yourself]
!

sortByName16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sortByName16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#sortByName16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary sortByName16x16Icon'
        ifAbsentPut:[(Depth8Image width:16 height:16) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8MCP8@@@@@@@@@@0<C@@@MC @MC @@@@@@@@LP@0@@@@@@CP(@@@@@@@@CA@L@@AHMB 4J@@@@@@@@@0TC@@8MC @M
B @@@@@@@@LE@0@NCP@@CP(@@@@@@@@CAPL@@@(MCP8BB @@@@@@@0TC@@@@@@@@@@@@@@@@@@LE@0@@@@@@@@\GA0\GA0@CAPL@@@@@@@@IA @KA00@@0TC
@@@@@@@@A @KA00@APDE@PT@@@@@@@@KA00@@ADEAPTQ@@@@@@@KA00@@@X@DPTQ@@@@@@@@C@\@@@XI@@@Q@@@@@@@@@@\GA0\GA0@a')
            colorMapFromArray:#[159 191 191 63 63 95 63 63 159 191 191 191 0 1 0 0 0 0 191 159 159 127 63 127 255 255 255 159 63 127 63 127 191 223 191 191 159 95 127 63 95 191 127 159 159 1 1 3 3 0 2 159 159 159 63 159 191]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@C8GM \FA78G] ].A7<G@@\C=0M7@.>A38NW@3HC<b'); yourself); yourself]
!

start16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self start16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#start16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class start16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@Q@@@@DP@@@Q$@@@@Q@@@QSP@@@AD@@QSI@@@@DP@QSH$QDQ@Q@QSH"M&X4ADQSH"H"H!!PDQ#H"H"H"E@QD@RH"H"HTADA@D"HQDQPDP@
PAH$QDQ@Q@@D@RP@@@AD@@A@E@@@@DP@@@PD@@@@@@@@@DP@@@@b');
                colorMapFromArray:#[ 0 64 64 0 128 128 0 192 192 0 255 255 0 0 0 255 255 255 192 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@0LG@0<CG0L?>7?;??/?>??;_?,?>1<CC0LG@@L@b');
                            yourself);
                yourself
        ]
!

stop16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stop16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#stop16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class stop16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@"H"H"@@@@@$QDQDP @@@$P3L3L1H@@$P3L3L3LR@$P0@3L0@3D"P3@@L0@CLRICL0@@@CL1H$L3L@@CL3D"P3L0@@L3LRICL0@@@CL1H$L0@CL@@3D"P3
@CL3@CLR@!!L3L3L3LR@@HSL3L3LR@@@BDQDQDR@@@@@"H"H"@@@b');
                colorMapFromArray:#[ 255 255 255 128 0 0 0 0 0 192 0 0 255 192 192 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'C?@_>C?<_?;?????????????????????_?8??A?8C?@b');
                            yourself);
                yourself
        ]
!

stopPoint16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stopPoint16x16 inspect
     ImageEditor openOnClass:self andSelector:#stopPoint16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary stopPoint16x16'
        ifAbsentPut:[(Depth4Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[4]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
L3L3L3L3L3L3L3L3L3L3L3L3L3L0@3L3L3L3@3L@L3L3LCA''U6@3L3L0C+ X/ L3L3@7$QFWL3L3L3WP@MT3L3L3M<DQ13L3L3@N.$J>@3L3L3A''U6@CL3L3
L@L3@3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3@@@b') ; colorMapFromArray:#[255 255 255 196 96 86 164 75 67 176 176 176 182 74 66 79 34 26 193 90 78 96 47 37 171 87 78 158 77 70 165 75 67 88 43 32 148 68 60 159 65 56 184 74 65]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@\@C8@_0C? O>@?8A?@C8@G@@@@@@@@@@@@b') ; yourself); yourself]
!

structsOnly16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self structsOnly16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#structsOnly16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary structsOnly16x16Icon'
        ifAbsentPut:[(Depth4Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
QDQDQDQDQDQDQDQDQDQDQ@A@QR@BT@@@@DQPP@@E@@@@QCQD@@L@@@ADEDP@@P@@@DTDQ@@@T@@@P@@D@@@@@@A@ADP@@@@@@DTDQ@@@T@@@QAQD@@D@@@AD
EDP@@P@@@DQPP@@E@@ADQDTTPUQDQDQDQDQDQDQDQDQDQDQDQDPb') ; colorMapFromArray:#[63 63 95 0 0 0 3 0 2 0 1 0 159 191 191 191 191 191]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@Y CC@HD@ PFA XFA XFA HD@ PCC@FX@@@@@@b') ; yourself); yourself]
!

terminal16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self terminal16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#terminal16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary terminal16x16Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PJB (JB (JB (JB (JB PJGQ4\F1,[F!!$YFA WE!!XJB!!4B@ HB@ HB@ HB@ HVB ([@  HB@ HB@ HB@ BE@(JF0HGA0\GA0\G
A0\G@!!PJB!!(AA!!4FA XFA XFA DQB (Y@PXFGPXFA XFA XADP(JF@@EAQ4EAPTEAPTE@A@JB!! @AA4DAA4]GPPDA@@OB (V@@LC@0LC@0LC@0L@CP(JE @@
@@@@@@@@@@@@@@0JB!!TTEALQDQDPC0<MCP0KB (TEAHQDQ@PC08MB $KB0(DB (JB (JB (JB (JB (DA@PDA@PDA@PDA@PDA@PDA@@a');
                colorMapFromArray:#[ 95 96 104 95 96 120 95 104 120 95 120 168 95 128 168 95 128 176 96 136 184 96 144 200 111 144 200 127 120 120 143 136 136 176 176 176 191 184 176 191 184 184 192 184 184 192 192 184 192 192 200 207 200 200 207 200 208 208 200 208 208 208 208 223 208 208 223 216 216 224 224 216 224 224 224 239 232 224 239 232 240 240 240 240 255 240 248 255 248 248 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@A??/???????????????????????????????7?>@@@b');
                            yourself);
                yourself
        ]
!

top16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self top16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#top16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class top16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
AUUUUUUUUP@EUUUUUUUU@@@@@EAP@@@@@@@EYCT@@@@@@EYBD5@@@@@EYBH!!MP@@@EYBH"HST@@EYBH"H"D5@EABH"H"H!!MPUUUTH"EUUU@@@E@"HU@@@@@@
TBH!!T@@@@@APH"EP@@@@@EPQDU@@@@@@UUUUT@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 192 255 255 0 128 128 0 192 192 0 64 64 0 255 255 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?1??@N@A<@O8A?0O?!!??O?>??8O8@? C>@O8@? @@@b');
                            yourself);
                yourself
        ]
!

undent16x16Icon
    <resource:#programImage>
    ^ self undent16x16Icon1

    "Modified: / 06-04-2011 / 18:38:05 / cg"
!

undent16x16Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self undent16x16Icon1 inspect
     ImageEditor openOnClass:self andSelector:#undent16x16Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary undent16x16Icon1'
        ifAbsentPut:[(Depth2Image width:16 height:16) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@D@@@@E@@@@EU@@@@T@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 0 0 128]
            mask:((ImageMask width:16 height:16) bits:(ByteArray fromPackedString:'@@@?8@@@O>@@@BG?X_?8@FG?H_<@@C?@@@@?0@@@@@@b'); yourself); yourself]
!

undent16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self undent16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#undent16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary undent16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"H"H"H"H@@"H"H@@@@@@BD"H"H"H"@@DRH"@@@@@@DQDQH"H"H @AD"H @@@@@@HRH"H"H"H@@"
H"H@@@@@@BH"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 34 110 181 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@O?8??#?>O?8??''?>O?8??#?>O?8?? @@@@@b');
                            yourself);
                yourself
        ]
!

undo16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self undo16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#undo16x16Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class undo16x16Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@<BLHM@P8AC0DO  @B@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 128 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@<BLHM@P8AC0DO  @B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

undo16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self undo16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#undo16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class undo16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@CL3@@@@@@@3@@@3@@L@@0@@H"H0@2@0@BH3D"LC@0@BL0@3D0L@@BL@@@@1L0@@L@@@@CL3@@@0@@@@L3L"H"H@@@@3L3L3L3@@@CL@@@
@@@@@CL0@@@@@@@CL0@@@@@@@3L0@@@@@@@3L@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 192 0 0 64 0 0 128 0 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A8@_8#?3_?/>^? _<A?0G? _?A @N@A0@^@C @@@b');
                            yourself);
                yourself
        ]
!

up16x16Icon
    <resource: #programImage>

    ^ self up16x16Icon2
!

up16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self up16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#up16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class up16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@F@@@@@@@@@FE @@@@@@@FATX@@@@@@FASIF@@@@@FASL2Q @@@FASL3L$X@@FASL3L3IF@FESL3L3L2Q Y&Y%L3I&Y&@@@FD3L&@@@@@@
XSL2X@@@@@A!!L3I @@@@@FT"H&@@@@@@Y&Y&X@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 255 255 192 255 255 0 128 128 0 192 192 0 64 64 0 255 255 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A@@N@A<@O8A?0O?!!??O?>??8O8@? C>@O8@? @@@b');
                            yourself);
                yourself
        ]
!

upRight16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self upRight16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#upRight16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class upRight16x16Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@T@@@@@@@@@AU@@@@@@@@@EAP@@@EUUUUT T@@@T@@BL3HE@@APL3L3L2AP@E@3L3L3MAT@TCL3L3MAT@APMDQCMAT@@E@4UUUAT@@@TC
QPAQT@@@APME@ET@@@@E@4T@T@@@@@UUUP@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 192 255 255 0 64 64 0 255 255 0 192 192 0 128 128 0 0 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@ @C@@NA?<G?8_?1??''?<_?!!?<G3 _LA< G0@@@@b');
                            yourself);
                yourself
        ]
!

viewDetails16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewDetails16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#viewDetails16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class viewDetails16x16Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@]+X@@@@@]+X@@@@@]+X@@@@@]+X@@@@@@@@b');
                            yourself);
                yourself
        ]
!

viewNoDetails16x16Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewNoDetails16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#viewNoDetails16x16Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class viewNoDetails16x16Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A<@@@@@@A<@@@@@@A<@@@@@@A<@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

viewTimeDetails16x16Icon
    <resource: #programImage>

    ^ self clock16x16Icon
!

zoomIn16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self zoomIn16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#zoomIn16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary zoomIn16x16Icon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+:)79KI@@@@@@@@@@@@,JO@+.J:->@@@@@@@@@@@L!!Z Z3T"INP*0@@@@@@@L^-+8" ''9SF.Y,@@@@@@@B="Y;R
8>RW"=W^@@@@@@@@/LVG.K.%3L.L!! @@@@@@@NV*(^FU/;N&"-@@@@@@@@C&''MZ"5;F2 - @@@@@@@CQ&,:]1IGS2+8@@@@@@@C]6=*$@I"M M$@@@@@@@CO
&]25@@@@@@@@ 0@@@@CC-HRN@@@@@@@@@HL@@@BE)8R6@@@@@@@@ 8NC 8L@0,F(@@@@@@@@@@@@3P@@@@BO@@@@@@@@@@@@@HL@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 1 2 3 7 11 14 18 22 24 15 23 28 15 24 29 16 25 31 37 37 37 30 41 48 29 45 55 31 47 57 37 57 69 41 58 70 45 58 66 57 63 65 45 69 85 48 73 89 67 74 79 55 79 93 72 79 83 55 83 101 55 85 103 75 81 86 61 85 101 57 86 105 58 87 106 61 91 110 86 86 86 60 92 112 85 90 93 69 99 117 70 103 123 92 104 110 78 110 127 79 113 131 110 110 110 97 113 120 86 116 131 109 113 115 113 114 115 85 121 140 95 123 138 100 123 134 110 122 130 96 129 145 120 124 127 93 132 151 126 126 126 103 132 146 101 138 156 132 132 132 105 139 156 102 140 159 113 138 149 134 134 134 135 135 135 127 137 143 130 138 140 111 142 157 129 139 143 108 148 167 108 149 168 108 149 169 108 150 170 141 156 162 150 156 158 155 155 155 163 163 163 164 168 170 164 170 173 172 172 172 174 174 174 188 188 188 195 195 195 202 202 202 203 203 203 204 204 204 210 210 210 211 211 211 215 215 215 225 225 225 227 227 227 229 229 229 232 232 232 235 235 235 236 236 236 243 243 243 247 247 247 250 250 250 254 254 254 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 203 209 224 216 238 252 241 244 246 2 2 2 199 118 74 242 203 145 162 178 206 170 223 253 174 221 252 185 233 251 208 237 242 217 252 252 220 254 254 199 204 222 152 118 144 178 175 180 158 196 228 184 221 233 170 188 219 196 246 255 202 251 253 214 253 252 191 193 219 220 253 253 193 199 219 252 169 69 211 196 161 145 159 196 141 158 204 162 181 214 165 219 254 195 244 253 192 240 253 189 241 255 203 255 255 203 210 227 194 190 196 231 251 253 254 255 255 255 170 66 157 121 143 157 186 217 167 205 233 171 173 202 173 220 251 196 233 245 206 249 255 203 240 253 199 201 222 230 255 255 240 255 255 248 251 251 252 170 69 154 123 141 153 119 144 154 199 233 187 240 252 198 248 253 193 241 254 207 253 253 184 189 220 190 194 223 181 190 214 231 251 252 242 250 254 168 104 70 185 176 155 253 205 132 160 192 219 182 230 246 198 247 252 181 192 218 185 200 226 184 187 218 188 216 229 230 251 252 239 253 253 18 18 18 144 157 174 252 205 132 159 167 195 251 211 149 181 235 252 192 229 237 168 215 252 208 253 254 182 221 242 213 255 255 186 195 216 205 208 225 184 113 69 253 169 62 200 117 75 253 205 131 167 193 213 161 193 223 160 173 211 194 243 251 186 236 255 205 253 253 215 254 253 191 192 218 214 217 225]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@?@G>@_<C?0O?@?<C?0O>A?0O^A8DO@Q8G7@DH@Pb') ; yourself); yourself]
!

zoomOut16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self zoomOut16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#zoomOut16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary zoomOut16x16Icon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+:)7)KI@@@@@@@@@@@@,JO@+.F:-=<@@@@@@@@@@L!!Q Z3S"INP*0@@@@@@@L^-+8" ''9SF.Y,@@@@@@@B="Y;Q
8.NW"=S]@@@@@@@@/LVG.K.%3L.L!! @@@@@@@NR*(^BU/;N&",<@@@@@@@C%''MV"5+F2 -\@@@@@@@CP&,6]1IGR2+8@@@@@@@C\6-&$@I"M M @@@@@@@CN
&].5@@@@@@@@@@@@@@CC-HRN@@@@@@@@@@@@@@BE)8R6@@@@@@@@ 8NC 8L@0,F(@@@@@@@@@@@@@@@@@@BO@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 1 2 2 8 12 14 19 21 24 15 23 28 15 24 29 16 25 30 37 37 37 31 41 49 30 45 55 31 47 57 37 57 69 41 58 70 45 59 68 57 63 65 46 70 85 48 74 90 68 75 80 55 79 94 73 79 84 55 83 101 55 85 103 76 82 86 61 85 101 57 86 105 58 87 106 61 91 110 86 86 86 60 92 112 85 90 93 69 99 117 70 104 123 92 103 110 78 110 127 79 113 131 97 112 120 86 116 130 109 113 115 113 115 116 85 121 140 94 123 137 100 123 134 111 123 130 120 124 128 97 130 146 93 132 151 104 131 146 101 138 156 132 132 132 105 139 156 102 140 159 113 138 149 134 134 134 127 137 143 130 137 140 111 142 157 130 139 143 108 148 167 108 149 168 108 149 169 108 150 170 141 156 162 150 155 158 155 155 155 163 168 169 164 170 173 172 172 172 188 188 188 195 195 195 202 202 202 204 204 204 210 210 210 211 211 211 225 225 225 227 227 227 232 232 232 235 235 235 247 247 247 248 248 248 250 250 250 254 254 254 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 203 209 224 216 238 252 241 244 246 2 2 2 199 118 74 242 203 145 162 178 206 170 223 253 174 221 252 185 233 251 208 237 242 217 252 252 220 254 254 199 204 222 152 118 144 178 175 180 158 196 228 184 221 233 170 188 219 196 246 255 202 251 253 214 253 252 191 193 219 220 253 253 193 199 219 252 169 69 211 196 161 145 159 196 141 158 204 162 181 214 165 219 254 195 244 253 192 240 253 189 241 255 203 255 255 203 210 227 194 190 196 231 251 253 254 255 255 255 170 66 157 121 143 157 186 217 167 205 233 171 173 202 173 220 251 196 233 245 206 249 255 203 240 253 199 201 222 230 255 255 240 255 255 248 251 251 252 170 69 154 123 141 153 119 144 154 199 233 187 240 252 198 248 253 193 241 254 207 253 253 184 189 220 190 194 223 181 190 214 231 251 252 242 250 254 168 104 70 185 176 155 253 205 132 160 192 219 182 230 246 198 247 252 181 192 218 185 200 226 184 187 218 188 216 229 230 251 252 239 253 253 144 157 174 252 205 132 159 167 195 251 211 149 181 235 252 192 229 237 168 215 252 208 253 254 182 221 242 213 255 255 186 195 216 205 208 225 184 113 69 253 169 62 200 117 75 253 205 131 167 193 213 161 193 223 160 173 211 194 243 251 186 236 255 205 253 253 215 254 253 191 192 218 214 217 225]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@?@G>@_<C?0O?@?<C?0O>A?0O^A8@O@A8G7@@H@@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-17x17'!

radioOff17x17Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOff17x17Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOff17x17Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary radioOff17x17Icon'
        ifAbsentPut:[(Depth8Image width:17 height:17) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C!!IOC@.MS @@@@@@@@@@EPVM0-RFBT9BRXR@@@@@@AFPD, HB@ HB@ R20M@@@@@CP*@ HB@ HB@ HBG3P@@@@''P!!8^
G!!8^G!!8^G!!8^C"H@@C0PL3L3L3L3L3L3L3L$JP@@H0<A@PDA@PDA@PDA@T(J@@@TN#8>O#8>O#8>O#8>DR @@A]VO3<?O3<?O3<?O3<=E@@@@D0QR$)JR$)J
R$)JDPTU@@AER@0>TEAPTEAPTEHLQDT@@@AAK2DDS%@OTD8DT$MU@@@@@D4YV@YRG  ^T YYQ1,@@@@@@@\]L"<6M#,/KSD\@@@@@@@@@@@ZJ5]ZTQLZ@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[164 165 162 243 243 241 248 248 248 235 235 235 245 245 244 215 217 213 225 227 222 219 219 218 247 247 247 186 187 184 154 156 152 221 222 220 239 240 238 226 226 226 176 178 175 235 235 233 213 213 211 242 242 240 227 227 227 146 147 144 145 147 143 162 164 161 180 181 178 148 149 145 246 246 246 134 135 132 192 192 191 220 220 220 218 218 218 138 140 136 246 246 245 214 215 213 250 250 250 240 241 238 206 207 205 155 157 153 214 215 212 240 240 240 179 181 178 206 207 206 146 148 143 173 175 172 210 211 209 147 148 145 167 168 165 168 170 164 175 177 173 206 209 203 171 173 169 137 139 136 167 169 165 245 245 243 171 172 169 189 190 187 212 216 208 185 187 184 212 212 211 221 222 221 240 240 238 212 216 209 175 177 174 234 235 233 241 241 239 239 239 237 168 170 166 146 148 144 174 176 173 206 208 202 172 175 170 198 199 197 226 227 226 134 136 132 172 173 169 189 191 188 237 237 235 215 216 214 214 216 213 221 221 220 239 239 238 236 236 236 236 236 234 122 123 120 240 240 239 237 237 237 227 227 226 145 147 144 234 234 233 122 124 120 204 207 201 204 208 200 116 118 114]
            mask:((ImageMask width:17 height:17) bits:(ByteArray fromPackedString:'@@A?A?A?G?1?O?9?O?9?_?=?_?=?_?=?_?=?_?=?_?=?_?=?O?9?O?9?G?1?A?A?@@A?'); yourself); yourself]
!

radioOffDisabled17x17Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOffDisabled17x17Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOffDisabled17x17Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary radioOffDisabled17x17Icon'
        ifAbsentPut:[(Depth8Image width:17 height:17) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C!!IOC@.MS @@@@@@@@@@EPVM0-RFBT9BRXR@@@@@@AFPD, HB@ HB@ R20M@@@@@CP*@ HB@ HB@ HBG3P@@@@''P!!8^
G!!8^G!!8^G!!8^C"H@@C0PL3L3L3L3L3L3L3L$JP@@H0<A@PDA@PDA@PDA@T(J@@@TN#8>O#8>O#8>O#8>DR @@A]VO3<?O3<?O3<?O3<=E@@@@D0QR$)JR$)J
R$)JDPTU@@AER@0>TEAPTEAPTEHLQDT@@@AAK2DDS%@OTD8DT$MU@@@@@D4YV@YRG  ^T YYQ1,@@@@@@@\]L"<6M#,/KSD\@@@@@@@@@@@ZJ5]ZTQLZ@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[164 165 162 243 243 241 248 248 248 235 235 235 245 245 244 215 217 213 225 227 222 219 219 218 247 247 247 186 187 184 154 156 152 221 222 220 239 240 238 226 226 226 176 178 175 235 235 233 213 213 211 242 242 240 227 227 227 146 147 144 145 147 143 162 164 161 180 181 178 148 149 145 246 246 246 134 135 132 192 192 191 220 220 220 218 218 218 138 140 136 246 246 245 214 215 213 250 250 250 240 241 238 206 207 205 155 157 153 214 215 212 240 240 240 179 181 178 206 207 206 146 148 143 173 175 172 210 211 209 147 148 145 167 168 165 168 170 164 175 177 173 206 209 203 171 173 169 137 139 136 167 169 165 245 245 243 171 172 169 189 190 187 212 216 208 185 187 184 212 212 211 221 222 221 240 240 238 212 216 209 175 177 174 234 235 233 241 241 239 239 239 237 168 170 166 146 148 144 174 176 173 206 208 202 172 175 170 198 199 197 226 227 226 134 136 132 172 173 169 189 191 188 237 237 235 215 216 214 214 216 213 221 221 220 239 239 238 236 236 236 236 236 234 122 123 120 240 240 239 237 237 237 227 227 226 145 147 144 234 234 233 122 124 120 204 207 201 204 208 200 116 118 114]
            mask:((ImageMask width:17 height:17) bits:(ByteArray fromPackedString:'@@A?A?A?G?1?O?9?O?9?_?=?_?=?_?=?_?=?_?=?_?=?_?=?O?9?O?9?G?1?A?A?@@A?'); yourself); yourself]
!

radioOn17x17Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOn17x17Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOn17x17Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary radioOn17x17Icon'
        ifAbsentPut:[(Depth8Image width:17 height:17) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@J<5K#@<MS @@@@@@@@@@LTNBS$%FH=4 U0R@@@@@@@MKH8 HB@ HB@ 0I=T@@@@@F2C@ HB@ HB@ HB\7(@@@BV118^
G)]8&W]%G!!8^^Z\@@H&:!!XU.&IFS0<*J!!XV(C @@_74A@\FZ3Y.?2:,A@["M@@@TN#9J\H/D^9JK.\0>''AP@@JT=O6>F_FOHYF6P\S>-XP@@!!8R1C562%F*L
Y6Z=DV 2@@A^(@1R]YWB\(Z&]#;LL+X@@@@(W94D(;B^ZZPD''JE"@@@@@G;NX@Z)G  ^T+V"G\X@@@@@@K.@,:3IM,%X*+2H@@@@@@@@@@B./&.B-H67@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[164 165 162 243 243 241 248 248 248 235 235 235 245 245 244 215 217 213 225 227 222 219 219 218 247 247 247 186 187 184 154 156 152 221 222 220 239 240 238 226 226 226 176 178 175 235 235 233 213 213 211 242 242 240 227 227 227 146 147 144 145 147 143 162 164 161 180 181 178 148 149 145 246 246 246 134 135 132 192 192 191 220 220 220 218 218 218 138 140 136 246 246 245 214 215 213 250 250 250 240 241 238 206 207 205 155 157 153 214 215 212 240 240 240 179 181 178 206 207 206 146 148 143 173 175 172 210 211 209 147 148 145 167 168 165 168 170 164 175 177 173 206 209 203 171 173 169 137 139 136 167 169 165 245 245 243 171 172 169 189 190 187 212 216 208 185 187 184 212 212 211 221 222 221 240 240 238 212 216 209 175 177 174 234 235 233 241 241 239 239 239 237 168 170 166 146 148 144 174 176 173 206 208 202 172 175 170 198 199 197 226 227 226 134 136 132 172 173 169 189 191 188 237 237 235 215 216 214 214 216 213 221 221 220 239 239 238 236 236 236 236 236 234 122 123 120 240 240 239 237 237 237 227 227 226 145 147 144 234 234 233 122 124 120 204 207 201 204 208 200 116 118 114 0 0 0 178 179 176 156 175 194 199 199 197 203 207 201 203 205 199 149 151 148 149 150 147 136 174 215 137 175 215 191 205 222 161 179 195 69 114 171 212 214 210 215 218 211 153 186 221 130 132 128 171 173 170 125 163 206 181 197 215 233 234 231 56 104 165 234 235 231 55 103 165 211 211 210 223 224 222 225 226 222 225 227 223 89 129 179 87 127 179 174 175 171 174 176 172 128 169 211 127 165 208 235 236 233 222 222 221 153 155 152 142 143 140 184 186 183 123 125 121 213 213 212 215 217 214 244 244 243 76 119 173 164 166 163 224 225 224 174 175 173 186 201 218 129 169 212 131 168 209 155 157 154 215 216 215 245 245 245 80 122 174 118 157 202 115 159 207 163 191 222 134 170 210 155 175 194 207 207 205 187 202 220 64 111 170 64 110 169 104 148 198 180 204 229 238 239 237 239 240 237 212 215 208 168 170 167 171 174 168 202 205 199 202 204 198 230 231 228 231 232 228 148 149 146 158 177 195 209 210 208 210 211 208 240 241 239 160 162 158 85 125 176 205 208 201 232 233 230 199 200 199 210 211 210 215 218 212 241 241 240 70 116 173 163 165 160 130 132 129 224 226 222 201 202 201 201 201 200 232 232 231 58 106 166 213 214 212 222 222 222 143 145 142 236 237 234 154 156 153 145 180 217 214 214 213 79 121 173 76 119 174 115 154 201 114 159 207 225 226 225 224 224 224 177 179 175 131 171 213 211 215 208 63 110 169 102 147 198 238 239 236 148 182 218 137 139 135]
            mask:((ImageMask width:17 height:17) bits:(ByteArray fromPackedString:'@@A?A?A?G?1?O?9?O?9?_?=?_?=?_?=?_?=?_?=?_?=?_?=?O?9?O?9?G?1?A?A?@@A?'); yourself); yourself]
!

radioOnDisabled17x17Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOnDisabled17x17Icon inspect
     ImageEditor openOnClass:self andSelector:#radioOnDisabled17x17Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary radioOnDisabled17x17Icon'
        ifAbsentPut:[(Depth8Image width:17 height:17) bits:(ByteArray fromPackedString:'
M3\7M3\7M3\7M3\7M3\7M3\7M3\7M51MP#1CSU<7M3\7M3\7M7IDR&*J%II-RTY7M3\7M3]5NVZW%9^W%9^WYS-6M3\7M35#%)ZV%)ZV%)ZVWTD7M3]YQYNS
%KR ''<B0%INSO5(7M4A$$IB,+96[&)>''$IA[QC\7KHBO#;F<''+R".I&O#7(/M3\%"H2B.Z.]*;6+.8NL!!BT7M2!!>!!W2(/**X+)2-_XU;J3\7NF^M_:&3&KZ+
)Y:A#&@:M3]OO(^I-:&:(Z""]X2CN%H7M3\''U(ZQ^F%!!ZG&Q!!EP*M3\7M6, UWNK$9VS"WASH&87M3\7M60#MU!!^X%9WL2Q/M3\7M3\7M3]PK!!(UF2=QM3\7
M3\7M3\7M3\7M3\7M3\7M3\7M0@a')
            colorMapFromArray:#[55 103 165 56 104 165 58 106 166 63 110 169 64 110 169 64 111 170 69 114 171 70 116 173 76 119 173 76 119 174 79 121 173 80 122 174 85 125 176 87 127 179 89 129 179 102 147 198 104 148 198 114 159 207 115 154 201 115 159 207 118 157 202 123 125 121 125 163 206 127 165 208 128 169 211 129 169 212 130 132 128 130 132 129 131 168 209 131 171 213 134 170 210 136 174 215 137 139 135 137 175 215 138 140 136 142 143 140 143 145 142 145 147 143 145 180 217 146 148 143 148 149 146 148 182 218 149 150 147 149 151 148 153 155 152 153 186 221 154 156 153 155 157 154 155 175 194 156 175 194 158 177 195 160 162 158 161 179 195 163 165 160 163 191 222 164 165 162 164 166 163 167 168 165 167 169 165 168 170 167 171 173 169 171 173 170 171 174 168 174 175 171 174 175 173 174 176 172 175 177 173 175 177 174 176 178 175 177 179 175 178 179 176 180 204 229 181 197 215 184 186 183 186 187 184 186 201 218 187 202 220 189 190 187 191 205 222 199 199 197 199 200 199 201 201 200 201 202 201 202 204 198 202 205 199 203 205 199 203 207 201 204 207 201 205 208 201 207 207 205 209 210 208 210 211 208 210 211 210 211 211 210 211 215 208 212 212 211 212 214 210 212 215 208 212 216 208 213 213 212 213 214 212 214 214 213 215 216 215 215 217 214 215 218 211 215 218 212 221 222 221 222 222 221 222 222 222 223 224 222 224 224 224 224 225 224 224 226 222 225 226 222 225 226 225 225 227 222 225 227 223 226 226 226 227 227 226 227 227 227 230 231 228 231 232 228 232 232 231 232 233 230 233 234 231 234 235 231 234 235 233 235 235 233 235 236 233 236 237 234 237 237 235 238 239 236 238 239 237 239 239 237 239 240 237 239 240 238 240 240 238 240 240 239 240 240 240 240 241 239 241 241 239 241 241 240 242 242 240 243 243 241 244 244 243 245 245 244 245 245 245 246 246 245 246 246 246 247 247 247 248 248 248 250 250 250 163 163 163 118 118 118 147 147 147 186 186 186 156 156 156 150 150 150 175 175 175 102 102 102 120 120 120 95 95 95 173 173 173 175 175 175 246 246 246 106 106 106 150 150 150 198 198 198 111 111 111 171 171 171 167 167 167 161 161 161 194 194 194 115 115 115 168 168 168 103 103 103 202 202 202 114 114 114 161 161 161 108 108 108 199 199 199 102 102 102 180 180 180 225 225 225 139 139 139 96 96 96 112 112 112 98 98 98 140 140 140 151 151 151 158 158 158 171 171 171 122 122 122]
            mask:((ImageMask width:17 height:17) bits:(ByteArray fromPackedString:'@@A?A?A?G?1?O?9?O?9?_?=?_?=?_?=?_?=?_?=?_?=?_?=?O?9?O?9?G?1?A?A?@@A?'); yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-20x20'!

bookmarks20x20
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bookmarks20x20 inspect
     ImageEditor openOnClass:self andSelector:#bookmarks20x20
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class bookmarks20x20'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
??????????????????????????????????????<1S/???????????????????????6BAD/????????????????????<]#I8*?????????????????????3^_
''U''?????????????????????YI2[_!!C??????????????????16F&)&WLO????????<&Q$YFQ$YETI"V%YI*U$D?OS4=K4YT#9RT$9FP#(6K"(VB_718]U0%
?4X:^X&H!!8RC G57]GE/ZVU@A_????<*Y''-:]''M2\F5(X%=UK G???????<QSF9,Z6]#WU!!SQBW???????????<VU6E^V%EMRTL"?????????????2%[T$=J
Q389NB#?????????????M$-HP#,3KB\ZE07??????????145OCP-IA0UC ,JG_??????????GSH+G!!,@?1HOA LSQO???????14!!H1$G?????1@T@ $H????
????GQ< AO????????<]C@ ]??????<]G_??????????????GQ7??0@a');
                colorMapFromArray:#[ 143 162 38 146 165 38 153 167 24 155 168 21 149 168 39 149 169 39 156 169 21 151 170 40 151 171 40 156 171 30 159 173 22 160 174 20 156 174 34 154 175 41 162 176 20 159 176 32 156 176 41 156 177 41 157 177 41 159 178 37 159 178 38 163 179 26 158 179 42 163 180 27 159 180 42 162 180 35 166 181 20 160 181 40 161 181 39 160 181 42 165 181 28 162 181 37 161 181 40 162 181 38 161 181 41 168 181 23 162 182 36 161 182 41 161 182 43 168 183 20 163 183 35 162 183 41 162 183 42 170 184 22 169 185 20 169 185 23 164 185 38 164 185 40 164 185 42 164 185 43 171 186 24 171 187 21 172 187 22 170 187 29 168 187 35 165 187 44 171 188 19 173 190 19 168 189 44 174 190 21 174 190 22 170 192 37 176 192 20 170 192 38 171 193 33 171 193 38 177 193 21 176 194 19 174 194 26 172 193 47 172 193 48 178 195 20 179 195 21 179 197 19 180 197 20 180 197 21 176 197 38 181 199 19 177 199 46 183 201 20 179 200 50 184 202 19 185 202 21 184 203 18 180 201 50 183 204 21 181 203 37 184 204 27 185 205 18 181 204 45 187 205 19 187 205 21 183 206 27 187 208 18 189 208 20 189 210 17 186 208 51 191 210 20 190 211 17 190 211 19 187 209 53 191 213 17 190 211 43 193 213 19 193 214 17 194 216 16 192 215 38 195 216 20 196 217 25 196 218 18 196 217 28 196 219 17 198 220 18 199 221 17 200 222 23 201 222 28 201 224 17 200 225 16 203 223 33 203 225 20 202 226 16 202 223 51 204 224 38 204 224 41 203 227 16 204 226 26 203 226 47 204 229 16 206 227 34 203 227 53 206 230 21 207 228 39 208 228 43 207 231 26 207 228 60 209 229 48 209 229 51 210 229 52 209 232 33 210 232 39 209 231 58 211 233 46 212 234 52 213 233 63 213 234 56 214 235 59 214 237 41 215 235 62 215 235 64 215 238 49 217 238 55 217 240 46 218 239 61 219 242 53 220 242 59 222 245 56 223 245 62 224 248 57 224 248 58 224 248 64 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@F@@@G@@@O@@@O@@@O @@_ @???0???0_?? G??@C?<@A?8@A?8@A?<@C?<@C=>@G0>@G O@F@C@');
                            yourself);
                yourself
        ]
!

browseIt20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self browseIt20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#browseIt20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class browseIt20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3L3L3L@@@@@@@M&Y&Y D@@@@@@CY&Y&@P@@@@@@ATQDPAD@@@@@@@@@@@DS@@@@@@
@@@@@QL1D @@@@@@@AD3DR@@@@@@@@@@@QH@@@@@@@@@@@D L3L5@@@@@@@BA7]7]@@@@@@@HDQDQDP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 248 252 128 208 220 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@P@_?0@_? @_? @_? @_? @_?<@@?8@A?0@C?? @_? @_? @_? @_? @0@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

copy20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copy20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#copy20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class copy20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
QDQDQDQDQDQDQDQADQDTQDQDQDQDPTQDDDQDQDQDQDECMAPDQDQDQDQAQDPP@DQDQDQDPTL3P3ADQDQDQDEDQADQDTQDQDQAP3LTQDDDQDQDPTQBECMAPDQD
QDECL1QDPP@DQDQAP$HTL3P3ADQDPRP"EDQDI@QDQDD@@AP3L3HDQDQDQDPTQBP"ADQDQDQDECL3L QDQDQDQAP$H"HDQDQDQDPRP"H"ADQDQDQD@@@@@@QD
QDQDQDQDQDQDQDQDQDQDQDQDQDPb');
                colorMapFromArray:#[ 0 0 0 64 64 64 168 228 240 208 212 208 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@G8@@G<@@G>@@G?@@G?@@G?0@G?8@G?<@G?>@G?>@G?>@G?>@@O>@@O>@@O>@@O>@@O>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

cut20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#cut20x20Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class cut20x20Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@F@@@@@@@@@@@@@@@@@@@@@G0@@]H@@%H@@%H@@$0@@$@@@X@B@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 248 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@PP@@PP@@PP@@PP@@H @@H @@M @@E@@@G@@@B@@@G0@@]H@@%H@@%H@@$0@@$@@@X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

cut20x20Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut20x20Icon2 inspect
     ImageEditor openOnClass:self andSelector:#cut20x20Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class cut20x20Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@DQDQ@@@@@@@@@AQDPP@@@@@@@@@TL4E@@@@@@@@@EDQA@@@@@@@@@AP3MCL@@@@@@@@TQDP$@@@@@@@@ECL3L @@@@@@@AQDIBH@@@@@@@
@TL3L2@@@@@@@@EBP"H @@@@@@@AIBH"H@@@@@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 64 64 64 168 228 240 208 212 208 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@_ @@_1A@_9A@_=A@_=A@_<"@_<"@_<6@_<T@_<\@_<H@_<_@@A4 @BT @BT @BS@@BP@@A @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

debugIt20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self debugIt20x20 inspect
     ImageEditor openOnClass:self andSelector:#debugIt20x20"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class debugIt20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@@@@@@AP@@@3@@@@@@@E@@@3DS@@@@@@UP@@LSL2@@
@@AUD@@@L3L @@@ETQUU@3L2@@@@UQEUTCL3H @@@@@EUP@BH @@@@@@AT@@@@@@@@@@@@P@@@@@@@@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 128 0 0 248 0 0 208 220 0 248 252 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@D@@@L#@@Z_ @9? A7?@C3?@G??@O?> _?>@_;=@C14@C @@G@@@F@@@L@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

doIt20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self doIt20x20 inspect
     ImageEditor openOnClass:self andSelector:#doIt20x20"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class doIt20x20Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@D@@@@@AP@@@@@W@@@@@E=X@@@A_V@@@@@E @@@@@X@@@@@B@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 248 252 128 208 220 0 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@P@@@0@@A @@C @@G@@@O@@@_<@@?8@A?0@C? @@O@@@N@@@\@@@X@@@0@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

doItMultiple20x20Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self doItMultiple20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#doItMultiple20x20Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class doItMultiple20x20Icon'
        ifAbsentPut:[(Depth2Image width:20 height:20) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D@P@@@A@D@@@@TAP@@@E0@@@@A_VMX@@W5#V@@@AXE @@@F@X@@@@ B@@@@H@ @@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 248 252 128 208 220 0 255 255 255]
            mask:((ImageMask width:20 height:20) bits:(ByteArray fromPackedString:'
@@@@@@@@@AB@@CF@@FL@@N\@@\8@@=8@A?? C??@G?>@O?<@@=8@@90@A3 @A#@@CF@@BD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a'); yourself); yourself]
!

documents20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self documents20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#documents20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class documents20x20Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E)FG@$J[!!:WWX]PGP@@@@@@@@@@QAA"MR]%PF!!<E39Q@@@@@@@@@@AXJ7.QO8 F
%IT1 YP0L0@@@@@@@F1''E%IBM8P OC0<OC2S@@@@@@@@ B):@"53$EVB (JBOF,@@@@@@@@H#PH=K@=Y%RL_HY%$F @@@@@@@B<)J@DDM)AUQ7:CFFQV@@@@
@@@@F7&LN1U^VYUJCE1-YF(@@@@@@@@[^G\@S''JPUXJB (H<PP@@@@@@@E^K@H)MC%&UW5=_W31=@@@@@@@@_1N]XQFE$EVB (JBO@T@@@@@@@@GIX$8]I!!Y
%U=_W5<<U@@@@@@@@B95II-KCYAU (JB #2O@@@@@@@@K&AL&"IHL ,RD#$9I!!$@@@@@@@BRQYY0RSQ#S0NNT6$Y[0@@@@@@@I1[P6Y6!!''D:@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 121 174 168 117 164 171 112 155 176 142 153 154 145 184 186 154 154 154 161 162 162 87 181 134 86 176 134 84 167 135 83 160 137 200 200 200 159 207 255 73 134 146 70 129 149 67 122 152 94 152 159 124 183 164 238 238 238 122 175 167 252 252 252 136 182 178 108 147 180 145 185 187 93 194 255 160 160 160 168 168 168 87 178 134 85 170 136 163 185 209 78 147 140 154 198 251 213 213 213 202 230 247 126 194 164 199 225 255 125 185 164 122 179 166 242 242 242 105 152 170 115 161 174 113 157 175 109 148 180 106 142 183 147 184 190 148 181 193 87 182 134 86 177 134 179 179 179 187 187 187 197 197 197 207 207 207 74 137 145 86 147 151 68 123 151 66 119 153 124 184 164 237 237 237 241 241 241 119 169 170 255 255 255 114 159 174 136 177 182 130 168 185 141 177 188 159 159 159 149 179 197 183 217 203 85 172 135 96 180 141 99 176 145 137 189 255 73 136 145 116 185 158 205 237 255 125 191 164 125 189 164 123 180 165 122 177 167 120 131 130 88 131 169 85 127 171 110 150 178 141 149 153 151 151 151 162 161 158 166 166 166 87 179 134 86 173 135 186 186 186 101 179 146 211 234 223 194 239 255 71 130 148 69 125 150 227 227 227 125 186 164 123 181 165 117 171 166 120 132 130 254 254 254 114 149 164 151 197 183 107 144 181 144 181 188 153 157 160 163 163 163 170 170 170 86 174 135 146 215 254 81 154 138 201 201 201 108 181 153 217 217 217 70 126 149 66 120 152 125 187 164 124 183 165 120 174 165 119 170 169 118 166 171 116 161 173 110 151 178 106 144 182 145 183 188 156 156 156 27 119 255 87 180 134 86 175 135 185 185 185 194 193 189 173 227 255 209 209 209 71 131 148 85 143 148 67 121 152 65 117 154 123 182 165 122 177 166 119 171 169 117 165 171 111 152 177 140 150 153 149 149 149 159 158 155 140 172 193 88 183 134 174 174 174 182 182 182 190 190 190 102 178 147 75 139 144 72 132 147 216 244 248 125 192 164 125 188 164 238 246 242 122 178 166 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O@@@OG?8OG?8OG?>OG?>OG?>OG?>OG?>OG?>OG?>OG?>OG?>OG?>OG?>OG?>OG?>OG>@O@@@O@@@O');
                            yourself);
                yourself
        ]
!

dos20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self dos20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#dos20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class dos20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@L3L3L3L3L3L3@CDQDQDQDQDQDP@1H"H"H"H"H#D@LRIDH"H"H"H1@CD$H"IBIBH"LP@1IBH"H"IBH#D@LRP"H"H"IBH1@CD$H"IBH$H"LP
@1H$P"H"P"H#D@LSL3L3L3L3L1@CDQDQDQDQDQDP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? @@@@@ @@C&L@D)P@D)H@D)D@C&X@@@@@');
                            yourself);
                yourself
        ]
!

dosWithoutText20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self dosWithoutText20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#dosWithoutText20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class dosWithoutText20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3L3L3L3L3L3L@LQDQDQDQDQDQ@CD"H"H"H"H"LP@1H$P"H"H"H#D@LRP"P"H"P"H1@CD$H"H$H"P"LP
@1IBH"H"H"P#D@LRP"H"H"H"P1@CD$H"H$H"IBLP@1IBIBH"H$H#D@LRIDH"H"P"H1@CD"H"H"H"H"LP@1L3L3L3L3L3D@@QDQDQDQDQDQ@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@_?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? O?? @@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

downArrow20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self downArrow20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#downArrow20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class downArrow20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@@@@@H"H"H"H"@"H"HBH"H"H"H HQDR@"H"H"H"HBDQD H"H"H"H"@!!DQHBH"H"H"H HQDR@"H"H"H"HBDQD H"H"
H@@@@!!DQH@@@@"HBDQDQDQDQHBH"HBDQDQDQD H"H"HBDQDQDR@"H"H"HBDQDQHBH"H"H"HBDQD H"H"H"H"HBDR@"H"H"H"H"HBHBH"H"H"H"H"H@H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"Hb');
                colorMapFromArray:#[ 0 0 0 100 128 255 128 128 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@?0E@?0@@?0G@?0@@?0B@?0@@?0@_?? O??MG?>@C?<@A?8C@?0H@_ @@O@@@F@C@@@A@@@@');
                            yourself);
                yourself
        ]
!

download20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self download20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#download20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class download20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
H"H"H"H"H"H"H"H"H @@@@@"H"H"H"HBH"H H"H"H"H"@!!DQHBH"H"H"H HQDR@"H"H"H"HBDQD H"H"H"H"@!!DQHBH"H"H"H HQDR@"H"H @@@BDQD @@@B
H@HQDQDQDQD @"H@HQDQDQDR@BH"H@HQDQDQH@H"H"H@HQDQD @"H"H"H@HQDR@BH"H"H"H@HQH@H"H"@"H"H@H @"H"H@H"H"H@@BH"H"@BH"H"H@H"H"H 
@"H"H"H"H"H"H@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 100 128 255 128 128 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@?0@@?0E@?0@@?0G@?0@@?0B@?0@_?? _?? O??MG?>@C?<@A?8C@?0H0_ 00O@00F@3???1???0');
                            yourself);
                yourself
        ]
!

edit20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self edit20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#edit20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class edit20x20Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H@@@HB@ HB@ HB@ HB@ HB@ HB@@\F@@HB@ HB@ HB@ HB@ HB@ H@A0XI@@HB@ HB@ HB@ HB
@ HB@@\FA $@@ HB@ HB@ HB@ HB@ H@A0XI@@HB@ HB@ HB@ @@@@@@@@\FA $@@ HB@ HB@ H@@0LN@00@A0XI@@HB@ HB@ HB@@LC@08N@@\FA $@@@HB
@ HB@ @C@0@@@0L@A0XI@A@@@ HB@ H@@0L@C 8@@@(FA $@DP@@@ HB@@LC@@8P@@L@B DF@ALCC @B@ @C@0@@@@TC@0@A@P4@@0<C@@H@@@LC@0LC@@LC
@@@M@@LE@0L@@ @@@@@@C 8C@0L@@@@CC0LC@@HB@ HB@ H@@@@NC @@@1DC@0@@@ HB@ HB@ HB@ @@C LE@0L@@ HB@ HB@ HB@ HB@ H@D@LC@@HB@ HB
@ HB@ HB@ HB@ H@@@@B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ @a');
                colorMapFromArray:#[ 0 0 0 166 126 78 0 255 51 255 255 255 153 153 153 102 102 102 255 204 0 255 255 102 248 3 8 236 152 0 253 202 138 102 102 102 204 204 204 110 74 32 181 181 181 125 125 125 117 117 117 162 162 162 254 12 17 214 214 214 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@F@@@O@@@O @@_ @@_@@_?@@?>@A?>@C??@G?? O?? _?? _?? O??@A?>@@O<@@C8@@A0@@@@@');
                            yourself);
                yourself
        ]
!

empty1x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self empty1x20Icon inspect
     ImageEditor openOnClass:self andSelector:#empty1x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class empty1x20Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:1;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@F #L#!!LG 8H@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 255 255 0 0 0 ];
                mask:((ImageMask new)
                            width:1;
                            height:20;
                            bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

erase20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self erase20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#erase20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class erase20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QDQD@@@@@@@@@EDQAD@@@@@@@@@P3PTD@@@@@@@@@QDDQ@@@@@@@@@@L4L@@@@@@@@A@@Q@@P@@@@@@@T@@@BD@@@
@@@@ED@@H!!@@@@@@@AP@@@HP@@@@@@@P@BH@D@@@@@@@@@H"H@@@@@@@@@@QDQD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 64 64 64 168 228 240 208 212 208 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@?@@@? @C?2@C?<@A?8@@?8@@?8@@?8@@?8@@?8@@?8@A?8@C0D@C @@A@B@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

erase20x20Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self erase20x20Icon2 inspect
     ImageEditor openOnClass:self andSelector:#erase20x20Icon2"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class erase20x20Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QDQD@@@@@@@@@EUUQD@@@@@@@@@UDTUD@@@@@@@@@UUDQ@@@@@@@@@@QEH@@@@@@@@A@@UP@P@@@@@@@U@@@CD@@@
@@@@EU@@L1@@@@@@@AT@@@LP@@@@@@@P@CL@D@@@@@@@@@L3L@@@@@@@@@@QDQD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 0 0 64 64 64 168 172 168 168 228 240 208 212 208 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@?@@@? @C?2@C?<@A?8@@?8@@?8@@?8@@?8@@?8@@?8@A?8@C0D@C @@A@B@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

eraseOverlay20x20
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self eraseOverlay20x20 inspect
     ImageEditor openOnClass:self andSelector:#eraseOverlay20x20
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class eraseOverlay20x20'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F@@@@@@@@@@@@XF@@@@@@@@@@@@Y @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 0 0 64 64 64 168 172 168 168 228 240 208 212 208 255 255 255 255 128 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@C B@C0L@A8X@@\0@@O @@G@@@O @@\0@@8X@A0L@C0N@C F@A@B@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

executeMethod20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self executeMethod20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#executeMethod20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary executeMethod20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L@@@@@@EUUUU@0UUUR@@ATQDPCLDQDQ@@@UDQ@L5@@@DP@
@EQD@3USLPQD@@ATPCMUL1ADQ@@@U@@@@3DDQDP@@EQDQ@LPQDQD@@@&Y&XAA&Y&Y @@@@@@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 208 220 0 170 170 170 248 252 128 0 255 127 255 255 255 127 127 127 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@P@@@0@@A @_?? _?? _?? _?? _?? _?? _?? _?? _?? _?? @X@@@0@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fileIn20x20Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileIn20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#fileIn20x20Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileIn20x20Icon'
        ifAbsentPut:[(Depth4Image new) width:20; height:21; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@Y&Y&Y&@@@@@@@FL3M&Y @@Y DFA"H"Y&X@DFXA@@Y"Y&Y&@A@@@P@FX&Y&Y @QDQD@M&I%UUX@DP@AA#M"H"H&@ADFD3L3L&Y&YJ
@@@@L3L3M&Y&X@@@@CL3L2YDQF@@@@@@@3X"H"I @@@@@@M&Y&Y&X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 129 129 129 63 63 36 255 0 0 194 194 0 0 127 0 194 194 194]; mask:((ImageMask new) width:20; height:21; bits:(ByteArray fromPackedString:'@G?0@G?0?7?0???0?7?0?7?0?7?0???0???0_??0@??0@G?0@G?0@G?0J H@P @@R&I R)JP:/JPR(JPR&JP') ; yourself); yourself]
!

fileIn20x20Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileIn20x20Icon2 inspect
     ImageEditor openOnClass:self andSelector:#fileIn20x20Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileIn20x20Icon2'
        ifAbsentPut:[(Depth4Image new) width:20; height:21; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@G]7]0@@Y&Y&Y&A;.;\@@FL3M&Y ^:*7,FA"H"Y&XG.;-0@@Y"Y&Y&A;**.H@FX&Y&Y ^;.;&0M&I%UUXG.**J$CM"H"H&A;.9,3L3L&Y&YJ
^:"(L3L3M&Y&XG.[&SL3L2YDQFA9.Y&Y@3X"H"I \@@@@@M&Y&Y&X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 129 129 129 63 63 36 255 0 0 194 194 0 0 127 0 194 194 194 64 64 64 168 172 168 168 228 240 208 212 208 255 255 255]; mask:((ImageMask new) width:20; height:21; bits:(ByteArray fromPackedString:'@G?0?G?0?''?0???0???0???0???0???0???0???0???0???0???0@G?0J H@P @@R&I R)JP:/JPR(JPR&JP') ; yourself); yourself]
!

fileIn20x20Icon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileIn20x20Icon3 inspect
     ImageEditor openOnClass:self andSelector:#fileIn20x20Icon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileIn20x20Icon3'
        ifAbsentPut:[(Depth4Image new) width:20; height:21; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CL3L0@@A&Y&Y&@8"HL@@@Y7]6Y NFZC @@FH"I&XC"H 0@@A&I&Y&@8Y&!!&@@Y"Y&YJ
NH"HR@A6X&DQXC!!&Y&P@]6H"H&@8"D]7]7]2Y&Y NFY'']7]7]6Y&XC!!HQ7]7]7I%UV@4!!DQD@G]"H"I L@@@@@A6Y&Y&X@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 127 0 63 63 36 64 64 64 168 228 240 194 194 0 208 212 208 255 0 0 255 255 255]; mask:((ImageMask new) width:20; height:21; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@C?0?C?0?#?0?3?0?;?0?;?0?;?0?;?0???0???0???0?;?0?;?0@C?0@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

fileNew20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileNew20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#fileNew20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class fileNew20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
Y&Y&Y&Y&Y&Y&Y&Y&Y&Y%Y&U&YVY&Y&Y&Y%Y%Y%Y&Y&Y!!DQDUYVU&Y&Y&XTQDDEUVY&Y&Y&EDQUUUUUU&Y&Y!!QDPTUUY&Y&Y&XTQDEPTEY&Y&Y&EDQEH%A%Y&
Y&Y!!QDUDMPY%Y&Y&XTQDP4LFY&Y&Y&EDQCP3A&Y&Y&Y!!QDMCL0Y&Y&Y&XTP4L3LFY&Y&Y&ECP3L3A&Y&Y&Y!!MCL3L0Y&Y&Y&XP@@@@@FY&Y&Y&Y&Y&Y&Y&Y&
Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Xb');
                colorMapFromArray:#[ 0 0 0 64 64 64 168 172 168 168 228 240 248 252 248 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@DQ@@BR@A?T@A?8@A??@A?8@A?<@A?:@A?9@A?8@A?8@A?8@A?8@A?8@A?8@A?8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fileOpen20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileOpen20x20 inspect
     ImageEditor openOnClass:self andSelector:#fileOpen20x20"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class fileOpen20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CL0@@@@@@@@@@L@@0L@@@@@@@@@@@@3@@@BH"@@@@@CL0@@HQDRH"H @@@@
@BEUTQDQD @@@@@!!UUUUUUH@@@@@HUT"H"H"H"H@@BERQDQDQDP @@@!!IDQDQDQB@@@@H$QDQDQDH@@@@BH"H"H"H @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 255 255 248 252 248 0 0 0 0 0 128 128 128 0 248 252 184 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@8@@AE@@@C@G G@O? @O?0@O?0@O??@O?>@O?<@O?8@O?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fileSave20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileSave20x20 inspect
     ImageEditor openOnClass:self andSelector:#fileSave20x20"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class fileSave20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L3H"H"H"@@@@@C]7H"QDIB@@@@@7QBH$QBQB@@@@M4P"IDP$P @@@C]DH"H"QDH@@@@7QDQDQDQB@@
@@M4Y&Y&Y$P @@@C]!!DQDQU$H@@@@7XQDQEQYB@@@@M6DQDUEVP @@@C]!!DQTUU$H@@@@7XQEQUUX"@@@@M6DUEUUVD @@@BH"H"H"H"H@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 255 255 248 252 248 0 0 0 64 64 64 168 172 168 168 228 240 96 96 96 208 212 208 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@G?8@G?<@G?>@G?>@G?>@G?>@G?>@G?>@G?>@G?>@G?>@G?>@G?>@G?>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fitImageSizeToView20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fitImageSizeToView20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#fitImageSizeToView20x20Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class fitImageSizeToView20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@DQDQDQDQDP@@@PDQDQDQDQ@P@A@ADQDQDQDP@PD@@PDQDQDPD@@QDQ@ADQDQ@@DQDQD@@@@@@@@@DQDQDPQDQDQ@DQDQDQDDQUUTPADQDQDQAEUUUT@QDQ
DQDPQEUUQ@DQDQDQDDQFQDPADQDQDQADQ$QD@QDQDQDPL3X3Q@DQDQDQDCL3L3LADQDQD@@@@@@@@@DQDQD@DQDQDP@QDQ@@DADQDQDA@@DA@ADQDQDQDP@P
@@@QDQDQDQDA@@@ADQDQDQDQD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 0 0 137 0 174 218 230 0 206 0 133 60 36 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
8@A00@@0(@APE@J@C@L@G?>@A?8@A?8@A?8@A?8@A?8@A?8@A?8@A?8@G?>@C@L@E@J@(@AP0@@08@A0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

history20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self history20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#history20x20Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class history20x20Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@J** @@@@IVU @@@@J**"@@@@IVU"@@@@J**"H@@@IVU"H@@@J**"H @@IVU"H @@J**"H @@@@@BH @@@***H @
@@@@@H @@@B**( @@@@@@@ @@@@J** @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 129 194 194 194 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@G?0@G?0@G?<@G?<@G??@G??@G??0G??0G??0G??0G??0A??0A??0@_?0@_?0@G?0@G?0@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

inspectIt20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self inspectIt20x20 inspect
     ImageEditor openOnClass:self andSelector:#inspectIt20x20"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class inspectIt20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
"H"H"H"H"H"H"H"H"H @@H"H"H"H"H @M&D@"H"H"H"@M&]&XP"H"H"H FXWY&XH"H"H"@E!!]FY&DH"H"H AEWQFY&BH"H"H@[]$Y&Y "H"H"@.7Y&Y&LH"H
"HB;Q1DWY "H"H K-D.:]&LH"H"@.4R;)1L@&X"H @@K. @@"@JX"H"HB:BH"H"@JX"H"@(H"H"H"@JX"HB "H"H"H"@JX"@BH"H"H"H"@BH@H"H"H"H"H"H
"@"H"H"H"H"H"H"H"H"H"H"H"H b');
                colorMapFromArray:#[ 0 0 0 128 132 128 168 172 168 208 212 208 248 252 248 248 252 128 152 204 216 64 64 64 255 255 255 128 64 64 208 220 0 248 252 0 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@O@@@?0@A?8@A?8@C?<@C?<@C?<@C?<@G?8@O?8@_?<@_?N@C0G@C C G@A0F@@0L@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

inspectLocals20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self inspectLocals20x20 inspect
     ImageEditor openOnClass:self andSelector:#inspectLocals20x20"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class inspectLocals20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"H"H"H"H"H@@BEDQDQDQDDR@@@$P"H$QDQDP @@H"%&T"DQDWH@@B%&Y&YRDQ\R@@@& VY&X!!E1\ @B%!!DX"FT''E7H@
@&Y!!Y&Y&HW]2@@I&"F"HY"]7\ @BU(!!&Y&$'']7H@@BY&Y&Y"H"H"@@@%Y&Y&$ @@@@@@@"U&$"L0@@@@@@@BH"@BT0@@@@@@@@@@@BT0@@@@@@@@@@@BT0@@
@@@@@@@@@BT0@@@@@@@@@@@BH@@b');
                colorMapFromArray:#[ 255 255 255 248 252 248 0 0 0 128 64 64 0 0 248 168 172 168 152 204 216 168 228 240 112 156 160 208 212 208 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@O??@O??@O??@O??@O??@O??@_??@_??@_??@_??@O??@O?@@G? @A90@@@8@@@\@@@N@@@F@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

left2Arrow20x20Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self left2Arrow20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#left2Arrow20x20Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary left2Arrow20x20Icon'
        ifAbsentPut:[(Depth4Image new) width:20; height:20; bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"HB@"H"H"H"H"H @@H"H"H"H"H"@ HBH"H"H"H"HB@!!@"H"H"H"H HBDPH"H"H"H"@ HQD@@@@@H"HB@!!DQH"H"HBH HBDQDQDQDR@"
@ HQDQDQDQD H HBDQDQDQDQHBH HBDQDQDQDR@"H HBDQD"H"H H"H HBDQ@@@@@BH"H HBDPH"H"H"H"H HBDBH"H"H"H"H HB@"H"H"H"H"H @@H"H"H"
H"H"H HBH"H"H"H"H"H"H"H"H"Hb') ; colorMapFromArray:#[0 0 0 100 128 255 128 128 128]; mask:((ImageMask new) width:20; height:20; bits:(ByteArray fromPackedString:'@@@M@J@@@^@J@>@@A>@JC>@@G??@O??@_??O???@???@_??@O??@G??EC>@HA>@@@>@@@^@N@J@A@@@@') ; yourself); yourself]
!

leftArrow20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self leftArrow20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#leftArrow20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class leftArrow20x20Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@HB@ HB@ HB@ HB@ HB@ HB@ @@@ HB@ HB@ HB@ HB@ HB@ H@@ @B@ HB@ HB@ HB@ HB@ HB@@HA
@@HB@ HB@ HB@ HB@ HB@ @B@PD@@ HB@ HB@ HB@ HB@ H@@ DA@P@@@@@@@@@@@ HB@ HB@@HA@PDA@ HB@ HB@ @B@ HB@ @B@PDA@PDA@PDA@PDB@@HB
@ H@@ DA@PDA@PDA@PDA@PH@@ HB@ @B@PDA@PDA@PDA@PDA@ @B@ HB@ @B@PDA@PDA@PDA@PDB@@HB@ HB@ @B@PDA@PHB@ HB@ H@@ HB@ HB@ @B@PDA
@@@@@@@@@@@B@ HB@ HB@ @B@PD@@ HB@ HB@ HB@ HB@ HB@ @B@P@B@ HB@ HB@ HB@ HB@ HB@ @B@@HB@ HB@ HB@ HB@ HB@ HB@ @@@ HB@ HB@ HB
@ HB@ HB@ HB@ @B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ @a');
                colorMapFromArray:#[ 0 0 0 100 128 255 128 128 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@M@B@@@F@J@N@@@^@J@>@@A??@C??@G??OO??@O??@G??@C??@A??E@>@H@^@@@N@@@F@N@B@A@@@@');
                            yourself);
                yourself
        ]
!

newDirectory20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newDirectory20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#newDirectory20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class newDirectory20x20Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PDA@PDA@P@@@@@@@@@@@@@@@@@A@ HB@ HA@@@@@@@@@@@@@@@@@PHB@ HB@ HA
@@@@@@@@@@@@@@DA@PDA@PDA@P@@@@@@@@@@@@D@@PHB@ HB@ HB@ HB@@@@@ HB@P@A@ HB@ HB@ HB@ @B@@H@@ HA@@DB@ HB@ HB@ H@@ H@@ H@@ D@
@PHB@ HB@ HB@@HB@ @B@ H@@P@A@ HB@ HB@ HB@ HB@ HB@ HA@@DB@ HB@ HB@ HB@ HB@ HB@ D@@PHB@ HB@ HB@ HB@ HB@ HB@P@A@ HB@ HB@ HB
@ HB@ HB@ HA@@DB@ HB@ HB@ HB@ HB@ HB@ D@@PHB@ HB@ HB@ HB@ HB@ HB@P@A@ HB@ HB@ HB@ HB@ HB@ HA@@DA@PDA@PDA@PDA@PDA@PDA@PD@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 0 0 0 0 0 255 255 0 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@DQ@O:R@O9T@_<8@??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? @@@@@@@@');
                            yourself);
                yourself
        ]
!

paste20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self paste20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#paste20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class paste20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@3L@@@@@@@@@L3&YH3@@@@@@@5T9&RUR@@@@@CUG&UURP2@@@@@5Q2H"H$L @@@@MTQDQDQCH@@@@CUDQCL3L2@@@@@5QDP1DQL @@
@@MTQDLX SD @@@CUDQCDQD2H @@@5QDP1"HFHH@@@MTQDLQDQXR@@@CUDQCFH"HX @@@5QDP1DVE&H@@@MTQDLX"H!!"@@@@H"H#E!!Y&X @@@@@@@6E&Y&H@
@@@@@@L"H"H"@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 255 255 248 252 248 0 0 0 64 64 64 128 132 128 168 172 168 168 228 240 96 96 96 208 212 208 248 252 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@N@@A?0@C?8@G?<@G?<@G?<@G?<@G?<@G?>@G??@G??@G??@G??@G??@G??@C??@@G?@@G?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

printIt20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self printIt20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#printIt20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class printIt20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@L3L3L3L0@@@@@CDQDQDQL@@@@@@1DQLQDS@@@@@@LQD3DQD @@@@@CDSLQDQH@@@@@@1ND&Y&R@@@@@@L8NY&Y$ @@@@@B"C&Y&YH@
@@@@JHD3L9&R@@@@@( Q"GLQD @@@B"AFH\1DQH@@@H"H(!!3DQDR@@@@@@JGLQDQD @@@@@B\"H"H"H@@@@@I2@@@@@@@@@@@BH@@@@@@@@@@@H @@@@@@@@
@@@B@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 255 255 248 252 248 0 0 0 64 64 64 128 132 128 168 172 168 168 228 240 208 220 0 248 252 128 32 220 32 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@_?@@_?@@_?@@_?@@_?@@_?@@_?@@_?@@??@A??@C??@G??@@_?@@_?@@8@@@0@@A @@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

profileIt20x20Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self profileIt20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#profileIt20x20Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class profileIt20x20Icon'
        ifAbsentPut:[(Depth2Image width:20 height:20) bitsPerSample:(#[2]); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@P@@@@@E@@@@@A\@@@@@S4@@@@D<@@@@AO0@A@@S??G5@D??13=@@C<_O=@@OG<?0@G1?0C@@MS??<@@TW??4@A@W?=@@@@W?P
@@@@PD@@@@@@@@@a')
            mask:((ImageMask width:20 height:20) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@F@@@N@@@^@@@>@@A<@@C?>@G??@O?? O??0@??0A??0A??0A7?0A#? @A?@@@>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a'); yourself); yourself]
!

redo20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redo20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#redo20x20Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class redo20x20Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@<@@ACD@B@,@B@\@B@<@AA<@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@<@@ACD@B@,@B@\@B@<@AA<@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

rightArrow20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self rightArrow20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#rightArrow20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class rightArrow20x20Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H@@ HB@ HB@ HB@ HB@ HB@ HB@ @@@ HB@ HB@ HB@ HB@ HB@ HB@@H@@ HB@ HB@ HB@ HB@ HB@ H@
@PH@@ HB@ HB@ HB@ HB@ HB@ @A@PH@@ HB@ HB@ H@@@@@@@@@@@DA@PH@@ HB@ HB@ @B@ HB@ HB@PDA@PH@@ HB@ HB@@HA@PDA@PDA@PDA@PH@@ HB
@ H@@ DA@PDA@PDA@PDA@PH@@ HB@ @B@PDA@PDA@PDA@PDA@ @B@ HB@@HA@PDA@PDA@PDA@PH@@ HB@ H@@ HB@ HB@ DA@PDB@@HB@ HB@ @@@@@@@@@@
@PDA@ @B@ HB@ HB@ HB@ HB@ @A@PH@@ HB@ HB@ HB@ HB@ HB@@DB@@HB@ HB@ HB@ HB@ HB@ H@@ @B@ HB@ HB@ HB@ HB@ HB@ @@@ HB@ HB@ HB
@ HB@ HB@ HB@@HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ @a');
                colorMapFromArray:#[ 0 0 0 100 128 255 128 128 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@D@@@F@H@G@@@G @@G0@O?8AO?<@O?>@O??@O??DO?>DO?<@O?8@@G0@@G @@G@@@F@@@D@J@@@@');
                            yourself);
                yourself
        ]
!

search20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self search20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#search20x20Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class search20x20Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@B@@@@@@@@@@@@@@@@@H@H@@@@@@@@@@DAA@@@@PHD@@@B@@ @@@@@@@@@A@@@P@@H@@B@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 212 208 200 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@A10@A10@A10@C;8@C;8@G?<@O?>@O?>@O?>@O;>@O >@O >@O >@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

shell20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self shell20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#shell20x20Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class shell20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@3L3L3L3L3L3L@LQDQDQDQDQDQ@CD"H"H"H"H"LP@1H"H"H"H"H#D@LRIDH"H"H"H1@CD$P"H"H"H"LP@1IDH"H"H"H#D@LRIDH"H"H"H1@CD"QBH"H"H"LP
@1IDH$QBQDH#D@LRH"H"H"H"H1@CD3L3L3L3L3LP@1DQDQDQDQDQD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'_?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? @@@@@ B F82 H%J D%: B%B L$2 ');
                            yourself);
                yourself
        ]
!

shell20x20WithoutTextIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self shell20x20WithoutTextIcon inspect
     ImageEditor openOnClass:self andSelector:#shell20x20WithoutTextIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class shell20x20WithoutTextIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3L3L3L3L3L3L@LQDQDQDQDQDQ@CD"H"H"H"H"LP@1H"P"H"H"H#D@LRIDP"H"H"H1@CD$IBP"H"H"LP
@1ICP"H"H"H#D@LRIDP"H"H"H1@CD"MBP"H"H"LP@1IBP$H"H"H#D@LRIDP"H"H"H1@CD"IBH$QBQDLP@1L3L3L3L3L3D@@QDQDQDQDQDQ@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@_?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? O?? @@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

shellWithoutText20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self shellWithoutText20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#shellWithoutText20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class shellWithoutText20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3L3L3L3L3L3L@LQDQDQDQDQDQ@CD"H"H"H"H"LP@1H"P"H"H"H#D@LRIDP"H"H"H1@CD$IBP"H"H"LP
@1ICP"H"H"H#D@LRIDP"H"H"H1@CD"MBP"H"H"LP@1IBP$H"H"H#D@LRIDP"H"H"H1@CD"IBH$QBQDLP@1L3L3L3L3L3D@@QDQDQDQDQDQ@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@_?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? _?? O?? @@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

tableViewWidget20x20
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self tableViewWidget20x20 inspect
     ImageEditor openOnClass:self andSelector:#tableViewWidget20x20
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary tableViewWidget20x20'
        ifAbsentPut:[
            (Depth2Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C?O<?0@N,:3+@@?3?O<@@@@@@@@O<?3?@@:3+N,@C?O<?0@@@@@@@@?3?O<@C+N,:0@O<?3?@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O@@@OA#FO@@@OG??/G??/7??/G??/G??/G??/7??/G??/G??/G??/7??/G??/G??/@@@O@@@O@@@O');
                            yourself);
                yourself
        ]
!

undo20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self undo20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#undo20x20Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class undo20x20Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@C0@BLH@CPD@C D@C0D@C8H@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@C0@BLH@CPD@C D@C0D@C8H@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

upArrow20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self upArrow20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#upArrow20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class upArrow20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H H H"H"H"H"H"@!!D H"H"H"H"HBDQD H"H"H"H HQDQD H"H"H"@!!DQDQD H"H"HBDQDQDQD H"
H HQDQDQDQD H"@@@@HQDR@@@@H"H"HBDQD H"H"H"H"@!!DQHBH"H"H"H HQDR@"H"H"H"HBDQD H"H"H"H"@!!DQHBH"H"H"H H"H"@"H"H"H"H@@@@@H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"Hb');
                colorMapFromArray:#[ 0 0 0 100 128 255 128 128 128 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@J@@@@@F@@@O@@@_ O@?0@A?8@C?<@G?>@O??E_??(@?0@@?0@@?0N@?0A@?0@@?0@@?0K@@@A@@@@');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-22x22'!

addTab22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self addTab22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#addTab22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary addTab22x22Icon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@HB@ @@@@@@@@@@@@@@@@@@@@@@@@@B@ H@@@@@@@@@@@@@@@@@
@@@@@@@@@ HB@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@ H@@@@@@@@@@@@@@@HB@ HB@ HB@ HB@@@@@@@@@@@@@@@B@ HB@ HB@ HB@ @@@@@@@@@@@@@@
@@@@@@HB@ @@@@@@@@@@@@@@@@@@@@@@@@@B@ H@@@@@@@@@@@@A@@@@@@@@@@@@@ HB@@@@@@@@@@@@@@@@@@@@@@@@@@HB@ @@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 0 0 0 127 127 127]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@C @@C @@C @@C @@?>@@?>B@?>@@C @@C @@C @@C @@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

backward22x22_3DIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self backward22x22_3DIcon inspect
     ImageEditor openOnClass:self andSelector:#backward22x22_3DIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary backward22x22_3DIcon'
        ifAbsentPut:[(Depth2Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@B* @@@@@BUP@@@@@BUP@@@@@BUP@@@@@BUP@@@@@BUP@@@@@IUT@@@@@IUT@@@@@IUT@@@@@%UU@@@@@%UU@@@@@%UU@@@@J%UU@@@
@IUUUT@@@B%UU@@@@@JUP@@@@@@(@@@@@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 0 0 0 127 0 255 255 255] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@@@@@@O @@O0@@O0@@O0@@O0@@O0@@_8@@_8@@_8@@?<@@?<@@?<@C??@C??@A?>@@_8@@G @@@@@@@@@@@@@'); yourself); yourself]
!

clearConsole22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self clearConsole22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#clearConsole22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary clearConsole22x22Icon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@PDA@PDA@PD@@@@@@@@@@@@@@@@@@@DB@ HB@ HC@P@@@@@@@@@@@@@@@@@D@ HB@ HBAPLD@@@@@@@@@@@@@@@@A \HBP(KC@4EC <@@@@@@@@@@@@@
@A@QDQDQDQDQDQDP@@@@@@@@@@@@@@@RD1PUE  IB ,WF@@@@@@@@@@@@@@@FQ(ZF1(ZF!!(ZF!!0@@@@@@@@@@@@@@A4^EATVB@$UG0H @@@@@@@@@@@@@@@!!
H"H"H"H"DRL$IP@#I"L@@@@@@@@@I2 TEQXHBR$*J2T@IR0*@@@@@@@@@B4.K"8.K"8LH2<+J#@/H0@@@@@@@@@1K!!XHBP(KF#H3IBL$M@@@@@@@@@@@MSX6
M#X6M!!(#@C\8M3$#@@@@@@@@@C(:N#(:N#,<NC4#@BL7N@@@@@@@@@@@@@@@@@@@@BL>IP@?NC<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[84 82 80 200 182 110 248 250 250 212 178 110 196 180 120 220 190 120 192 178 120 244 248 250 156 172 200 148 166 200 140 160 190 136 154 190 248 248 250 224 200 140 212 178 100 196 178 120 188 176 120 244 246 250 184 172 120 240 246 250 172 188 210 168 184 210 164 180 210 240 244 250 184 174 120 180 170 130 236 242 250 240 242 250 200 192 160 176 166 130 236 240 250 216 224 230 236 234 230 172 164 130 232 238 250 116 114 110 100 100 100 116 116 120 92 94 90 168 162 140 228 236 250 192 202 220 96 94 90 136 136 140 136 134 130 164 158 140 224 234 250 88 90 90 128 126 130 156 156 140 224 224 230 84 86 90 84 84 80 156 154 140 220 232 250 112 110 110 80 80 80 80 82 80 152 152 150 180 178 170 224 224 220 112 112 110 80 78 80 112 114 110]; mask:((Depth1Image new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@A? @A?0@A?8@A?<@A?<@A?<@A?<@A?<@A?=0A?=0A??0A?? A??0A?=0@@]0@@@@@@@@@@@@') ; yourself); yourself]
!

close22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self close22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#close22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class close22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@ H@@@@@@@@@@@@B@ @@@@@@@@@@@@HB@ @@@@@@@@@B@ H@@@@@@@@@@@@@@ HB@@@@@@@B@ H@@@@@@@@@@@@@@@@B@ H@@@@B@ H@@@@@@@@@@@@@
@@@@@@HB@ @B@ H@@@@@@@@@@@@@@@@@@@@@@ HB@ H@@@@@@@@@@@@@@@@@@@@@@@@B@ H@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ @@@@@@@@@@@@@@@@@@
@@@B@ H@@ HB@@@@@@@@@@@@@@@@@@@B@ H@@@@B@ H@@@@@@@@A@@@@@@@B@ H@@@@@@@HB@ @@@@@@@@@@@@@B@ H@@@@@@@@@@ HB@@@@@@@@@@@@@ H@
@@@@@@@@@@@B@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 255 255 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@A C@A0G@@8N@@\\@@N8@@G0@@C B@G0@@N8@@\\@@8N@A0G@A C@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

console22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self console22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#console22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary console22x22Icon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@ HB@ HB@ HB@ D@@@@@@@@@@@@CA@PDA@PDA@PDA@PC@@@@@@@@@@@@@0TFA XFA XFA XE@0@@@@@@@@@@
@@LGA  HB@ HB@ HA0L@@@@@@@@@@@@IB XKC@4NC1@PD@(I@@@@@@@@@@@@DP(FDA@RDA@PDAHJDP@@@@@@@@@@@ALTA ,KEQXWF@<REAL@@@@@@@@@@@@S
FPXZF!!(ZF!!(ZF!!,S@@@@@@@@@@@@GA4FF!!(ZF!!(ZF!!(]G@@@@@@@@@@@@A8_G1<_G1<_G1<_G18@@@@@@@@@@@@ @@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@
@B@@@@@ @@@@@@@@@@@@@@@@@@@ HRD!!HRD!!HRD!!H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[47 88 144 95 128 176 47 112 200 47 104 184 80 96 128 95 104 128 208 232 248 95 104 136 255 248 248 47 104 176 96 112 136 111 128 176 95 112 168 80 96 144 64 88 136 63 72 128 240 240 248 47 96 176 239 240 248 47 96 168 111 120 144 96 120 168 95 104 160 79 96 144 64 80 136 112 128 144 224 232 248 112 120 144 47 96 160 112 128 160 47 88 160 127 136 160 79 112 168 47 88 136]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@C@@@C@@@C@@@C@@@CA??CA??CA??CA??CA??CA??CA??CA??CA??CA??CA??C@G0C@?>C@@@C@@@C@@@C@@@C') ; yourself); yourself]
!

copy22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copy22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copy22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class copy22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@AUUUW@@@A???>@@@A???>O@@A???>@@@A???>@@@@@@?>@EUUU\?>@G???8?>@G???8?>@G???8?>@G???8?>@G???8?>IG???8?>@G???8**M
G???8@@@G???8@@KG???8@@@G???8@@@G???8@@HN***(@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@_?<@_?<@_?<@_?<@_?<@_?<???<???<???<???<???<???<???<???<???<???<??8@??8@??8@??8@??8@??8@');
                            yourself);
                yourself
        ]
!

copyMenuItem22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyMenuItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#copyMenuItem22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class copyMenuItem22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O@@@@@@@@@@AUUUW@@@@@@?>@EUUU\?>@G???8?>@G???8?>@G???8?>@G???8**@G???8@@IN***(@@@@@@@@@@M
@@@@@@@@G???8@@KG???8@@@G???8@@@G???8@@HN***(@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@_?<@_?<???<???<???<???<???<???<???<??8@??8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

currentDirectoryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self currentDirectoryIcon inspect
     ImageEditor openOnClass:self andSelector:#currentDirectoryIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class currentDirectoryIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bitsPerSample:(#[8]); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@@@@@@@@@@@@DQ@@@@@@@@@@@@DQDP@@@@@@@@@@DQ@QD@@@@@@@@@DQIBDQ@@@@@@@@DQIDP!!DP@@@@@@DQIDQDHQD@@@@@
DQIDQDQBDQ@@@@DQIDQDQDP!!DP@@DQIDQDQDQDHQD@D"IDQDQDQDQ@@A@RH$QDQDQDQD@@D@@@QDQDQDQDP@@@@@ADQD@@QDQ@@@@@@DQDP@ADQD@@@@@@QD
Q@@DQDP@@@@@ADQDQDQDQ@@@@@@DQDQDQDQD@@@@@@QDQDQDQDP@@@@@ADQDQDQDQ@@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 192 0 0 64 0 0 73 73 73 192 192 192]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@A@@@C @A''0@A/8@A?<@A?>@A??@C?? G??0O??8_??<_??<_??<C?? C?? C?? C?? C?? C?? C?? C?? C?? '); yourself); yourself]
!

cut22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#cut22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class cut22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@DQDQDP0AL@@L@@@SL3L3CBL @B0@@AL3L3LL0B@@3@@@D3L3L0KB@@KB@@@SL3L3LL0@CL@@@AL3L3L0KB@,H@@@D3L3L3LL0L0@@@@S
L3L3L0K@0 @@@AL3L3L3LL3@@@@@D3L3L3L03L@@@@@SL3L3L0CL0@@@@AL3L3L3@,CB@@@@D3L3L3@L0L0@@@@2H"H H"0 KBH @@@@@@KL3@@L3LH@@@@@
CBCB@@K@K@@@@@@L@LH@@,@L@@@@@@0@0 @B0@0@@@@@CBC@@@C@K@@@@@@@3@@@@@3@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_?<@_=\P_=<0_=,0_=50_>5 _>; _?[@_?[@_?.@_?.@_?N@_?[@_>[@_;;8_75<@F1,@D1$@D1$@F ,@C@X@@@@');
                            yourself);
                yourself
        ]
!

cutMenuItem22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cutMenuItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#cutMenuItem22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class cutMenuItem22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@ADP0@@@@L@@@CL3L3CB@@@B0@@@L3L3LL0@@@3@@@@@@@@@KB@@KB@@@QDQDQDL0ACL@@@AL3L3L0KB@,H@@@D3L3L3LL0L0@@@@S
L3L3L0K@0 @@@AL3L3L3LL3@@@@@D3L3L3L03L@@@@@2H"H"H"CL0@@@@@@@@@@@@,CB@@@@@@@@@@@L0L0@@@@@@@@@H"0 KBH @@@@@@KL3@@L3LH@@@@@
CBCB@@K@K@@@@@@L@LH@@,@L@@@@@@0@0 @B0@0@@@@@CBC@@@C@K@@@@@@@3@@@@@3@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@A@P@A 0@A 0_=50_>5 _>; _?[@_?[@_?.@_?.@_?.@_?[@@@[@@C;8@G5<@F1,@D1$@D1$@F ,@C@X@@@@');
                            yourself);
                yourself
        ]
!

debug22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self debug22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#debug22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class debug22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HB@ HB@ @@@@@@@@@@@@@@@@@@@ HBAPTEAPTB@@@@@@@@
@@@B@ @B@ HEAPTEAPTEAPH@@@@@@@HBAPTE@@HEAPTEAPTEAPTE@ @@@@@B@ TEAP@BAPTEAPTEAPTEAPH@@@@@@@HEAPT@@@@@@@@@@@@@@@@@@@@@@@HB
APTE@@HBAPTEAPTEAPTE@ @@@@@@@ HB@ @B@ TEAPTEAPTE@ H@@@@@@@@@@@@@@@HBAPTEAPTE@ @@@@@@@@@@@@@@@@@@@@@B@ HB@ @@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 127 127 127 128 0 0 161 161 165 194 194 194 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@BA0@Q''H@L? @E?0@??8Q??<O??<C??<C??<O??<S??<@??8@G?0@L? @Q#X@FA @@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

debug22x22IconForBlackBackgound
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self debug22x22IconForBlackBackgound inspect
     ImageEditor openOnClass:self andSelector:#debug22x22IconForBlackBackgound
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class debug22x22IconForBlackBackgound'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@X@@@@@@@@FA X@@@@@
@@@@@@@F@@@@A X@@@XFA @@A @@@@@@@@@@@@XF@@@FA XFA XF@@@@@@@@@@@@@@@@A @FA HB@ HB@ X@@@@@@@@@@@XFA XF@ HBAPTEAPTBA @@A @@
@@XB@ XB@ HEAPTEA XEAPHF@@@FA HBAPTEA HEA XEAPXFAPTE@ @@@@@B@ XEAPXBAPXFAPTEAPTEAPH@@@@@A HEAPTFA XFA XFA XFA XF@@@FA HB
A TEA HBAPTEAPTEA XE@ @F@@@F@ HB@ XB@ TEA XEAPXF@ X@@@@@@@@FA XFA HBAPXFAPTE@ X@@@@@@@@@@@@@A XFA XB@ HB@ X@@@@@@@@@@@@@
A X@@@XFA XFA X@@@@@@@@@@@@@A @@@@XF@@@@A X@A X@@@@@@@@@@@@@A X@@@@@@@@FA @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 127 127 127 128 0 0 161 161 165 194 194 194 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@BA0@Q''H@L? @E?0@??8Q??<O??<C??<C??<O??<S??<@??8@G?0@L? @Q#X@FA @@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

delete22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self delete22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#delete22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class delete22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@DQDQDQDQL@@@@@@SL3L3L3L @@@@@AL3L3L3L2@@@@@@D3L3L3L3H@@@H@@SL3L3L3L @@H@@AL3L3L3L2@@@@@@D3L3L3L3@@@@@@@S
L3L3L0@ @@@ @AL3L3L3@@@@@@@@D3L3L3L@D@@@H@@SL3L3L0@QL3H @AL3L3L3@A@3LB@@D3L3L3L@DC@0H@@2H"H"H @PLC@ @@@@@@@@@A@0LB@@@@@@
@@@@DC@0H@@@@@@@@@@PLC@ @@@@@@@@@A@0LB@@@@@@@@@@DS@2H@@@@@@@@@HAL3HB@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_?<@_?<@_?<P_?<P_?<X_?<X_?<H_?0H_?O<_?XL_?_<_?_<_?_<_?_<_?_<_?_<@@_<@@_<@@_<@@_<@@_<@@G0');
                            yourself);
                yourself
        ]
!

displayScreen22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self displayScreen22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#displayScreen22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class displayScreen22x22Icon'
        ifAbsentPut:[(Depth4Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y&Y&Y&Y&Y&&P@@A&Y&Y&Y&Y&ZY@@@FXXUUV***)9$0@@Y!!H"H+.AF''&S@@A&,"H"H+DZ^YL@@F
Z2H"H",Q)9$0@@Y(H"J;-QF''&S@@A&E[.HUQDZ^YL@@FXUUUUUDQ*)$0@@Y!!UUUUTQF*&S@@A&(QF$*$QD^YL@@I&Y&Y&Y&Y&Y$0@@&Y&Y&Y&Y&Y&S@@@@L3
M)&YL3L3L@@@@@@F&Y$3@@@@@@@@ZY&Y&Y&S@@@@@@A)&Y&Y&YL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 64 80 96 80 112 112 64 64 64 48 64 80 64 96 96 128 128 128 48 80 80 80 96 96 112 112 112 64 80 80 80 96 112]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@G??0G??0G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8A??8@G<@@??@@??@@@@@@@@@') ; yourself); yourself]
!

down22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self down22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#down22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class down22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUT@AUUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUP
UT@*$AUPUV***%UPUU***UUPUUZ*)UUPUUV*%UUPUUU*UUUPUUUYUUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 0 127 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@A?>@A?>@@?<@@_8@@O0@@G @@C@@');
                            yourself);
                yourself
        ]
!

downRight22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self downRight22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#downRight22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class downRight22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUPP@EUUUUPR*UUUUUPR*UUUUUPR*UUUUUPR*UUUUUPR*UUUUUPR*UUUUUPR*UUUUUPR*UUUUUPR*UUT%UPR*UUT)UPR*UUT*UPR*P@@*%PR*****)P
R******PR*****)PR*****%PQUUUU*UPUUUUT)UPUUUUT%UPUUUUTUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 0 127 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_ @@_ @@_ @@_ @@_ @@_ @@_ @@_ @@_ @@_ L@_ N@_ O@_?? _??0_??8_??8_??0_?? @@O@@@N@@@L@');
                            yourself);
                yourself
        ]
!

editor22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self editor22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#editor22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class editor22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
*******************************("H"H"H"H"J(@**"EUUU%UUUU@@^**HUUUVUUUU@@]:*(!!UUUYUUUT@A7**"FY&Y&Y&X@]7^**HUUUVUU@@]7\Z*(
!!UUUYU@@]7\R**"EUUU%T@A7]1J**HY&Y&XC]7\Q&**(!!UUU(3M7\Y&***"EUUU#L3L2QJ***HY&Z#L3L6)D***(!!&Y*L3L6Z$R***"EUUP3M&ZEQJ***HUU
RRY(UUUD***("*)J*****$R***"J)J******QJ***HUUUZUUUUUD***TQDQDQDQDQDR***************(b');
                colorMapFromArray:#[ 240 160 80 192 80 0 64 0 0 240 208 160 0 0 0 240 240 240 192 192 192 240 128 0 208 208 208 48 48 48 160 160 160 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@G??LG??<G??<G??<G??<G??<G??<G??<G??8G??0G??0G??0G??0G??0G??0G??0G??0G??0O??0@@@@');
                            yourself);
                yourself
        ]
!

font22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self font22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#font22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class font22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@!!X @@@@@@@!!X @@@6H@@@@@@DP6H@@@Y!!H@@@@@QDY"@@@BY"@@@@ADQBY"@@@FX @@@@@DQCX @@@6H@@@@@QEP6H@@@@ @@@@
ADUDP @C@@@@@@@DQSH@@@L @@@@@@QEL @@@2@@@@@@ADT2@@@CH@@@@@@DQSH@@@L @@@@@@QEL @@@2@@@@@@QDT2@@@CH@@@@@QDQSH@@@@ @@@@@DQE
P @@@@@@@@@@@DQ@@@@@@@@@@@@@@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 150 150 150 213 213 213 215 48 48 134 54 54 240 240 240 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@G @OG0@O''<@O7>@O<?@A>? A?? A??@A<?@A<>@A<>@A<>@A=>@C?>@G<>@C<\@@8D@@H@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

forward22x22_3DIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self forward22x22_3DIcon inspect
     ImageEditor openOnClass:self andSelector:#forward22x22_3DIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary forward22x22_3DIcon'
        ifAbsentPut:[(Depth2Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@@@@@B%@@@@@@)UT@@@@JUUUP@@@H@UP@@@@@BUP@@@@@BUP@@@@@BUP@@@@@IUT@@@@@IUT@@@@@IUT@@@@@%UU@@@
@@%UU@@@@BUUUP@@@BUUUP@@@IUUUT@@@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 0 0 0 127 0 255 255 255] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@C@@@O0@@?<@C??@C??@@O0@@O0@@O0@@_8@@_8@@_8@@?<@@?<@A?>@A?>@C??@A??@@@@@@@@@'); yourself); yourself]
!

help22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self help22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#help22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class help22x22Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@O0A@_8@@?<@@8\C@8\A@@\@@@8@@A8@@C0@@G @@G@@@G@@@G@C@@@@@@@@@G@@@G@@@G@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 127 0 127 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@O0@@_8@@?<@@8\@@8\@@@\@@@8@@A8@@C0@@G @@G@@@G@@@G@@@@@@@@@@@G@@@G@@@G@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

home22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self home22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#home22x22Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class home22x22Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@@@@@@@@@@@@DQ@@@@@@@@@@@@DQDP@@@@@@@@@@DQ@QD@@@@@@@@@DQH2DQ@@@@@@@@DQH4L!!DP@@@@@@DQH4QCHQD@@@@@
DQH4QDP2DQ@@@@DQH4QDQDL!!DP@@DQH4QDQDQCHQD@D"H4QBH"ADP0@A@RH#QBH"H QC@@D@@@MDIUUUADL@@@@@@4P%UUTDP0@@@@@CQBUUUPQC@@@@@@MD
IUUUADL@@@@@@4P%UUTDP0@@@@@CQBUUUPQC@@@@@@MDIUUUADL@@@@@@4P%UUTDP0@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 192 0 0 64 0 0 128 128 128 192 192 192 100 128 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@A@@@C @A''0@A/8@A?<@A?>@A??@C?? G??0O??8_??<_??<_??<C?? C?? C?? C?? C?? C?? C?? C?? C?? ');
                            yourself);
                yourself
        ]
!

keyboardMapping22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self keyboardMapping22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#keyboardMapping22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class keyboardMapping22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@N@@@@@@@@@@@@@@@@@@@@@@@@@@@*@@@@@@B%P@@@@@JUT@@@@@)TE@@H@BUTQP@@@ETTQ\@@@JTTU?@@@J$@W<@@@B)U_0@@@@*U?@@@@@J''<@@@
@@B''0@@@@@@''@@@O@@@D@@@@@@@@@@@K@@@@@@@@@@@@@@@M@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 128 128 128 192 192 192 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@G@@@O @@_0@@?8@A?<@C?>@G??@G?? G??@C?>@A?<@@?8@@_0@@O @@G@@@B@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

languages22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self languages22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#languages22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary languages22x22Icon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FA @@@@@@@@@@@@@@@@XF@@@@@@@@@B (JB (JB (JB (F!!(Z@@@@@@@@@@@ZJB (JA0\GA0(JB ZF @@@@@@@@@@
F" (JA0\GA0\GB (F!!(@@@@@@@@@@A((JA0\GA0\GA0\JB Z@@@@@@@@@@@ZJB \GA0\GA0\GB (J@@@@@@@@@@@F" (GA0\GA0\GA0(JB B@@@@@@@@@A((
J@X@A LC@0LC@0LC@ @@@@X@@@@ZJB @@@@@@0@@@@@@@@@C@@@@@@@@F" (@@X@@@@@@@@@@@@@@@@E@@@@@ATZF @]DQDQGP8[F1,SE1\WE0$@@@XF@@@@
GQ<_G1<[F1,[D1<_E1\I@@@@@@@@@AL]GQDSD!!H[F1,[F1,[BP@@@@@@@@@TFQ$YFQ$YEAPTEAPTE@@@@@@@@@@@FQ$"H"HYFQ$YFQ$YFRH@@@@@@@@@@BH"
H!!$"H"H"H"H"H"H"@@@@@@@@@@@"H"H"H"H"H"HYFQ$YFPX@@@@@@@@F@@@@@@@@@@@@@@@@@@@F@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 0 0 0 32 32 32 48 48 48 49 48 49 54 54 54 69 69 69 75 67 22 82 82 82 85 14 14 89 89 89 105 105 105 106 88 25 110 19 19 113 19 19 131 129 131 134 122 39 149 25 25 149 26 26 158 27 27 158 140 45 164 161 164 164 161 172 165 43 43 177 161 52 196 175 0 197 194 197 204 36 36 204 75 75 205 36 36 205 113 38 212 66 66 216 81 81 223 72 72 227 202 66 231 120 120 231 123 123 255 129 0 255 238 162 255 251 229 255 255 255]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@_?>@_?>@_?>@_?>@_?>@_?>@_?>@_??8_??8_??8_??8_??8A??8A??8A??8A??8A??8A??8@@@@@@@@@@@@') ; yourself); yourself]
!

left22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self left22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#left22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class left22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUPUTUUUUUPURUUUUUPUJUUUUUPT*P@@@@PR******PJ******P*******PZ******PV*UUUUUPU*UUUUUP
UZUUUUUPUVUUUUUPUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 0 127 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@A @@C @@G @@O??<_??<???<???<_??<O??<G @@C @@A @@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

leftDown22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self leftDown22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#leftDown22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class leftDown22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUPU@@@@@@PUJ****)PUJ****)PUJ****)PUJ****)PUJ)UUUUPUJ)UUUUPUJ)UUUUPUJ)UUUUPUJ)UUUUPUJ)UUUUPUJ)UUUUPUJ)UUUUP@J*@UUUP
***)UUUPZ**%UUUPV**UUUUPU*)UUUUPUZ%UUUUPUVUUUUUPUUUUUUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 0 127 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@G??8G??8G??8G??8G??8G??8G8@@G8@@G8@@G8@@G8@@G8@@G8@@??@@??@@_>@@O<@@G8@@C0@@A @@@@@@');
                            yourself);
                yourself
        ]
!

load22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self load22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#load22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class load22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUPUUUUU?UPUUUUW*5PU???>*/PU:****)PUUUUUUZPP@@@@@EPS?????&PS?????%PS?????&PS?????%PT?????9PT?????9PT?????9PT?????9P
T?????9PT?????9PUO????>PUO????>PUO????>PU:*****PUUUUUUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@G@@@O G??8O??<O??<_??<???<???<???<???<???<_??<_??<_??<_??<_??<_??<O??<O??<O??<O??<O??<');
                            yourself);
                yourself
        ]
!

loadFromMethod22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self loadFromMethod22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#loadFromMethod22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class loadFromMethod22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
DQDQDQDQDQDQDQDQDQDQDQDQD3LQDQDQDQDQDQD2H#DQDQL3L3L3L2H"H3DQD2H"H"H"H"H"DQDQDQDQDQDQDQH!!D@@@@@@@@@@@@QDPL3L3L3L3L3L!!HQ@3
L3L3L3L3L2DQDCL:(3L3N*L3HRDPL3**(3N*(3L!!DQDCL:*#N*N*L3HQDPL3**(:L:(3L!!DQ@3N*N*(3*#L2DQDCL:(3(3N*L3HQDPL3*#L3L:(3L!!DQ@3N*
L3L3*#L2DQDPL3*#L3N*(3L!!DQ@3N*L3L3*#L2DQDCL3L3L3L3L3HQDSH"H"H"H"H"H!!DQDQDQDQDQDQDQDb');
                colorMapFromArray:#[ 255 255 255 0 0 0 127 127 127 170 170 170 255 0 0 255 255 0 0 255 0 0 0 255 0 255 255 255 0 255 127 127 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@G@@@O G??8O??<O??<_??<???<???<???<???<???<_??<_??<_??<_??<_??<_??<O??<O??<O??<O??<O??<');
                            yourself);
                yourself
        ]
!

loadImage22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self loadImage22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#loadImage22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class loadImage22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
DQDQDQDQDQDQDQDQDQDQDQDQD3LQDQDQDQDQDQD2H#DQDQL3L3L3L2H"H3DQD2H"H"H"H"H"DQDQDQDQDQDQDQH!!D@@@@@@@@@@@@QDPL3L3L3L3L3L!!HQ@3
L3L3L3L3L2DQDCMDY''\3L3L3HRDPL4Q&]3L3L3L!!DQDCMU&X 3L3L3HQDPL5VY"CL3L3L!!DQ@3QFY7L3L3L2DQDCMDY''\3L3L3HQDPL5VY"CL3L3L!!DQ@3UY
&HL3L3L2DQDPL4Q&]3L3L3L!!DQ@3QFY7L3L3L2DQDCL3L3L3L3L3HQDSH"H"H"H"H"H!!DQDQDQDQDQDQDQDb');
                colorMapFromArray:#[ 255 255 255 0 0 0 127 127 127 170 170 170 255 0 0 255 255 0 0 255 0 0 0 255 0 255 255 255 0 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@G@@@O G??8O??<O??<_??<???<???<???<???<???<_??<_??<_??<_??<_??<_??<O??<O??<O??<O??<O??<');
                            yourself);
                yourself
        ]
!

make22x22Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self make22x22Icon1 inspect
     ImageEditor openOnClass:self andSelector:#make22x22Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary make22x22Icon1'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@G\@@@@@@@@@]7@GUW@@]0@@@@]UU7UUU7YR\@@@A5UUUUUUUUI0@@@AEUUUUUUUI&@@A7]7UUI!!EUU&]7A2UUUUI!!@AUUUUU7UU
UUT!!X!!EUUUUVE7]UUUY&X%UVY&DQDWUUUUUUUVXQDQDWUUUUUUUUT&DQ@WUUUUUUUUUUU1@CQUT3UUUTQEUW@@@RHQE5UWDQ]7D@@ADQDWUU\QDQDP@@DQDQ
\%I1@QDQ@@@ADP@W]1@@DQ@@@@@@@ADQD@@@@@@@@@@@DQDP@@@@@@@@@@@ADP@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 48 48 48 192 192 192 56 59 56 88 92 88 248 252 248 128 128 128 160 160 160]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@C@@C''#@G?? G?? G?? _??8???<???<???<???<???<_??8_??0O??0O??0O?70GO# @O @@O @@G@@@@@@') ; yourself); yourself]
!

make22x22Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self make22x22Icon2 inspect
     ImageEditor openOnClass:self andSelector:#make22x22Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary make22x22Icon2'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!L!!H@@@@@@@@CHSD"D!!H @@@@@@L3H#L"L"@@@@@@
@@H3H#L @@@@@@@3L3H@H#L"@@@@@DPCL0@3HCL@@@@@PDL3L3H3@0@@@@@BP3L3L3M@@@@@@@I@LCLD@4@@@@@@@ I@L0Q@P@@@@@@@@$ADAD@@@@@@@@@B
PCLDP@@@@@@@@@@@L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 88 88 88 184 252 248 0 192 192 0 128 128]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@O0@A?>@C??@C??@C??@G?? G?? G?? G?? C??@C??@C??@@?<@@?<@@G @@@@@@@@@@@@@') ; yourself); yourself]
!

makeYellow22x22Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self makeYellow22x22Icon1 inspect
     ImageEditor openOnClass:self andSelector:#makeYellow22x22Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary makeYellow22x22Icon1'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@G\@@@@@@@@@]7@GDW@@]0@@@@\QE7DQE7XS\@@@A1DQDQDQDQM0@@@BHQDQDQDQM&@@A7]7DQM"HQE&]7A3DQDQM"@BDQDQE7DQ
DQD2X2HQDQDVI7\QDQY&X1DVY&H"H''DQDQDQDVX"H"H''DQDQDQDQD6H"@''DQDQDQDQDQE2@DTQEDDQDUUQDW@@@#L"I1DWH"]7H@@BH"H''DQ\"H"H @@H"H"
\1M2@"H"@@@BH @'']2@@H"@@@@@@@BH"H@@@@@@@@@@@H"H @@@@@@@@@@@BH @@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 211 107 48 48 48 192 192 192 56 59 56 88 92 88 128 128 128 160 160 160]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@C@@C''#@G?? G?? G?? _??8???<???<???<???<???<_??8_??0O??0O??0O?70GO# @O @@O @@G@@@@@@') ; yourself); yourself]
!

memory22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self memory22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#memory22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class memory22x22Icon'
        ifAbsentPut:[(Depth4Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@?0@@@@@@@@@@@L;8;!!0@@@@@@@@@VL0W\,@@@@@@@L<T,W]43@@@@@@I,"8Z(R-10@@@@I<,,Z**Q78P@@@L24DZ****E0H@@@
<,EM7Z**E00P@LTR9M7]7ZE0H50@=RE0C]7]E0BF?0<,E0@@C]Q0HREPBK-0@@@@Q0T?H\@KTA4@@@^-4_=\@@H A@@@^ JOG<@@@ID@P@^ GE3O@@@@AP@D
R EO:O0@@@@@T@4PT%3,@@@@@@@E4G_58%@@@@@@@@AZ\QGL0@@@@@@@@@@@1<@@@@@@@@@@@@@D@@@@@@@b') ; colorMapFromArray:#[0 0 0 80 80 80 160 160 160 240 240 240 64 64 64 144 144 144 224 224 224 48 48 48 128 128 128 208 208 208 32 32 32 112 112 112 192 192 192 16 16 16 96 96 96 176 176 176]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@A @@G>@@G?@@_? @??0A??0C??8C??8O??<O??<_??8_??8_??0_?? O??@G??@C?<@A?8@@?8@@C @@A@@') ; yourself); yourself]
!

new22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self new22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#new22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class new22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@AUUUUP@@A????2@@A????2 @A????0@@A?????8@A?????8@A?????8@A?????8@A?????8@A?????8@A?????8@A?????8@A?????8@A?????8@
A?????8@A?????8@A?????8@A?????8@A?????8@C*****(@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@_??@_?? _??0_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8');
                            yourself);
                yourself
        ]
!

newMenuItem22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newMenuItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#newMenuItem22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class newMenuItem22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@ADP@@@@@@@@@CL3L3@@@@@@@@@@L3L3L@@@@@@@@@@@@@@@@H@@ @B@@QDQDQDQFAFAJ@@AL3L3L3L3 8N@@@D3L3L3L3L8"B@@@S
L3L3L3"H"H"H@AL3L3L3L3NH  @@D3L3L3L3NC 8@@@2H"H"H"JBJBJ@@@@@@@@@B@@H@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@_??<_??8_??8_??8_??<_??8_??8_??8_??<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

openBreakpointBrowser22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self openBreakpointBrowser22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#openBreakpointBrowser22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary openBreakpointBrowser22x22Icon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A,[F1,[@@@@@@@@@@@@@@@@
@@@@F1,[F1,[F1,[@@@@@@@@@@@@@@@@F1,[F2,C@ XRE3D@@@@@@@@@@@@@@A,[F0$TK3X7MB(UC30@@@@@@@@@@A,[F1 =N#)@PDA@PAXFO@@@@@@@@@@[
F1$:N$A@PDA@PDA@J L@@@@@@@@@F24)N$A@PDA@PDA@PC(*G @@@@@@@A, L$@:N#(:N#(:PD@:J D@@@@@@@@[FS]@N#(:N#(:N$A@N#,E@@@@@@@@@A$;
PDA@PDA@PDA@PC(;B0@@@@@@@@@YM4A@PDA@PDA@PD@:N0,@@@@@@@@@F#A@PDA@PDA@PD@:N#,B@@@@@@@@@B0"PDA@PDA@PDA@N#(.B@@@@@@@@@@@CR)@
PDA@PD@:N#(:B#0@@@@@@@@@@ADMLC(:N#(:N#(:G2X@@@@@@@AEO3$PA@4#L3(:N"8.G2\@@@@@@@ADP$D8C @@D \LD2D_JCT@@@@@@@ADP4D>IA4@@@@@
@@@@@@@@@@@@@@@@P4D>IQ0@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 159 192 159 160 192 159 160 207 159 160 208 160 64 64 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 191 191 208 191 223 239 191 224 240 191 224 255 192 192 208 192 239 255 192 240 255 207 143 95 207 207 191 207 223 239 207 255 255 208 208 223 208 224 239 223 128 63 240 207 144 233 88 88 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@_@@A?0@C?8@C?>@G??@G??@G?? G?? G?? C?? C?? C?? C?? A?? A??@O?>@_O<@?@@@>@@@') ; yourself); yourself]
!

openBreakpointBrowserIcon
    <resource:#programImage>
    ^ self openBreakpointBrowser22x22Icon
!

openBugBrowser22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self openBugBrowser22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#openBugBrowser22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary openBugBrowser22x22Icon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CDGAP(VF3\@@@@@@@@@@@@@@@@@@@4XMS4>N3@YD4TFA @@@@@@@@@@@A1FP$H@S4=OS1(JQT8F@@@@@@@@
@A5BP D_G4=OS4=OL@]NS X@@@@@@CL/P$=O@T=OS4=OS4H0H49NA @@@@@%NT=OS1=OS4=OS4=OL@QNS X@@@@@GS9OS4<_S4=OS4=OS4PI@@@@@@@@@A5D
S4=OS4=OS4=OS4=DC49NA @@@@@]O!!<_G1<A@PDA@PDAQ@=NA X@@@@@G#YOS4=OS4=OS4=OS4PEA @@@@@@@CH''S4=OG4=OS4=OS4<4C@@@@@@@@@@@DSAO
S0EOS4=OS4=BC$T@@@@@@@@@@ATQM!!<AG1=OS4=BIB0@@@@@@@AVSTDTBAD(N$IBP#P4IB4@@@@@@@AUT5I@D @@E ,PE2X$K#0@@@@@@@AUUEIIJ"H@@@@@
@@@@@@@@@@@@@@@@UEIIJ2D@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 64 64 64 64 64 64 127 127 127 127 127 175 127 128 175 128 0 0 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 159 192 159 160 192 159 160 207 159 160 208 160 64 64 160 64 64 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 161 161 165 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 192 192 208 192 239 255 192 240 255 194 194 194 207 143 95 207 207 191 207 223 239 207 239 240 207 255 255 208 208 223 208 224 239 208 255 255 217 217 217 223 128 63 223 255 255 239 239 240 239 255 255 240 207 144 255 0 0 255 64 64 255 64 64 255 64 64 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@BA0@Q''H@O? @_?0@??8Q??<O??<C??<C??<O??<S??<C??8C??0A?? A??XO?? _O<@?@@@>@@@') ; yourself); yourself]
!

paste22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self paste22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#paste22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class paste22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@KLH@@@@@@@@@@@CL3@@@@@@@@@@@CBH"0@@@@@@@@QD,3L3BDQ@@@@@ADQDQDQDQD@@@@@DQDQDQDQDP@@@@@@@@@@DQDQ@ADQDQDQDS@QDQD@D3
L3L3L3HADQDP@SL3L3L3L DQDQ@AL3L3L3L2@QDQD@D3L3L3L3HADQDP@SL3L3L3L DQDQ@AL3L3L3L2@QDQD@D3L3L3L3HADQDP@SL3L3L3L DQDQ@AL3L3
L3L2@QDQD@D3L3L3L3HADQDP@SL3L3L3L DQDQ@AL3L3L3L2@@@@@@L"H"H"H"H@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@<@@@<@@??<@??<@??<@??<???<???<???<???<???<???<???<???<???<???<???<???<???<???<??8@??8@');
                            yourself);
                yourself
        ]
!

pasteMenuItem22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self pasteMenuItem22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#pasteMenuItem22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class pasteMenuItem22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@KLH@@@@@@@@@@@CL3@@@@@@@@@@@CBH"0@@@@@@@@QD,3L3BDQ@@@@@ADQDQDQDQD@@@@@DQDQDQDQDP@@@@@@@@@@DQDQ@ADQDQDQDS@QDQD@D3
L3L3L3HADQDP@SL3L3L3L DQDQ@AL3L3L3L2@QDQD@D3L3L3L3HADQDP@SL3L3L3L DQDQ@CH"H"H"H"@QDQD@@@@@@@@@@ADQDP@@@@@QDQDQDQDQ@@@@@A
DQDQDQDQD@@@@@DQDQDQDQDP@@@@@QDQDQDQDQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@<@@@<@@??<@??<@??<@??<???<???<???<???<???<???<???<???<???<@??<@??<@??<@??<@??<@@@@@@@@');
                            yourself);
                yourself
        ]
!

pickWindowIcon
    <resource: #programImage>

    ^ self pickWindowIcon2
!

pickWindowIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self pickWindowIcon1 inspect
     ImageEditor openOnClass:self andSelector:#pickWindowIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary pickWindowIcon1'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@DB@0PEA \HBP(KC@4NC1@QD!!LTEPDVE1 YF!!,\GQ8_HBD"H2P%I"X&I2 )J!!\WFQ([J20-K"<0LSH$IRX&I#L4MSX6M#X6M#X6M#X6M#\7NC$:N30=O#<6
M#X6M#X6M#X6M#\7M3 9N#,<OT@?M#X6M#X6M#X6M#X7M3\8NS(;OC5@PSX6M#X6M#X6M#X6M#\7NC$:N30:PDH6M#X6M#X6M$MCP3X6M3\8NS(;ODQEM#X6
M#X6P4L6P3YCP3\8NS(;ODYDQSX6M#X6P3X6P4MCM3]CNS(;OC%GRD$6M#X6M$L6M3]CNS\7P3$:N309Q4!!JM#X6M$L6P3\7P3\7P3%CN31KN41MR#X6M#YC
P4MCP4MCP4MCP3,<N31NST<6M#X6P3YCM3]CM3!!CN$MGQ3,<S$5PM#X6M#YCM#\7P3\8NTL;Q4]GQ5EMT#X6M#X6P3X7P4MCNC%CN4]GQ4]SSUP6M#X6M#YC
P3]CNDMCN31GQ4]GT45UM#X6M#X6U#]CP4L:N31GQ4]GQ5]MVE$6M#X7M3 9N#,<N#,<Q4]GQ4]ZSU!!YM#X6M3\8NS(;OC(;OD]GQ4]GV$5[VSX6M3\8NS(;
OC$:N31GQ4]GQ5M\V55^W6A!!X&M$YVY''ZD!!MST5MST5MW@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[56 150 230 68 158 230 76 160 230 72 156 230 68 150 230 64 144 230 60 138 220 56 132 220 52 126 220 44 120 220 40 114 210 36 108 210 32 102 210 28 96 210 24 90 200 20 84 200 16 78 200 12 72 200 8 66 190 4 64 190 4 56 180 0 50 160 140 208 255 132 202 255 124 194 255 116 186 255 108 178 255 100 170 255 92 162 255 84 154 255 76 144 255 68 136 255 56 128 255 48 118 255 40 110 255 32 100 255 20 92 255 12 82 255 4 74 255 4 64 240 0 50 170 76 164 240 132 200 255 88 158 255 80 150 255 72 142 255 64 132 255 56 124 255 44 116 255 36 106 255 28 98 255 4 68 250 0 50 180 92 168 240 255 255 255 244 244 250 240 242 250 240 240 250 240 238 240 236 236 240 236 234 240 240 240 240 28 72 180 108 176 240 56 94 180 104 174 230 104 172 230 0 0 0 56 92 180 104 170 230 232 234 240 232 232 240 52 90 180 104 168 230 100 166 230 236 238 240 228 228 240 52 88 180 224 226 230 100 164 230 100 162 230 224 222 230 100 160 230 220 220 230 96 160 230 96 158 220 248 246 250 220 218 230 96 154 220 252 250 250 212 212 220 52 128 210 12 60 170 88 146 220 84 140 210 80 136 210 80 132 210 76 126 200 72 122 200 68 118 200 68 114 190 64 108 190 60 104 190 60 100 180 56 96 180]; mask:((Depth1Image new) width:22; height:22; bits:(ByteArray fromPackedString:'????????????????????????????????????????????????????????????????????????????????????????') ; yourself); yourself]
!

pickWindowIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self pickWindowIcon2 inspect
     ImageEditor openOnClass:self andSelector:#pickWindowIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::ViewTreeInspectorApplication pickWindowIcon2'
        ifAbsentPut:[(Depth8Image new) width:21; height:23; bits:(ByteArray fromPackedString:'
@@DB@0PEA \HBP(KC@4NC1@QD!!LT@QTVE1 YF!!,\GQ8_HBD"H2P$IBT&I2 )E1 YJ",,KR8/LCD"H2P$ICH3MCT5MST5MST5MST5MSX7NC$:N30=O#T5MST5
MST?O3<?O3X7NC$:N31@O#T5MST5O3<5MS<5M#<?NC$:N31@PST5MST?MST?O3<?O3X7O3$:N3%@P#T5MS<5MST5MS<6M#\8NS<:N31CQCT5O3T5MST?O3<?
O3\8NS(?N31CQCT5O3T5MST5M#<6M3 9N#(?N31EQ#T?MS<5O3T5O3<?M3 ?N#<:O31EQ3T?MS<5O3T?M#X7O3$?N#<:O31HQ3T?O3<?O3<?M#X7O3<?O3<?
O31HRST?MS<5O3X?M#X7O3$?NC<:O31HR#T?MS<5O3X6O3<?N#$?NC<:O31HR3T5O3T5M#X6M3<9N#$:NC$?N31HSCT5O3T6M#X?O3<?O3$:ST4?ST9HS3T5
MS<6M#X6M3<9N#$:SS=MSUAHTUH5MSX?M#X?O3<?O3-MO45MSUMHTUH5M#X6O3<9N#<9N#<?ST5MSUMHUEH5M#X7NC$?O3<?O3-MST5MST9UUCT5MST5MST5
MST5MSX7NC$:N31UUEYWVE%ZV51]W%= QT!!HRD!!HRD!!U') ; colorMapFromArray:#[56 150 230 68 158 230 72 156 230 68 150 230 64 144 230 60 138 220 56 132 220 52 126 220 44 120 220 40 114 210 36 108 210 32 102 210 28 96 210 24 90 200 20 84 200 16 78 200 12 72 200 8 66 190 4 64 190 4 56 180 0 50 160 140 208 255 124 194 255 116 186 255 108 178 255 100 170 255 92 162 255 84 154 255 76 144 255 68 136 255 56 128 255 48 118 255 40 110 255 32 100 255 20 92 255 12 82 255 4 74 255 4 64 240 0 50 170 76 164 240 132 200 255 132 202 255 88 158 255 80 150 255 72 142 255 64 132 255 56 124 255 44 116 255 36 106 255 28 98 255 4 68 250 0 50 180 92 168 240 255 255 255 244 244 250 240 242 250 240 240 250 240 238 240 236 236 240 236 234 240 240 240 240 28 72 180 108 176 240 0 0 0 56 94 180 104 174 230 104 172 230 56 92 180 104 170 230 52 90 180 104 168 230 100 166 230 52 88 180 100 164 230 100 162 230 100 160 230 96 160 230 232 232 240 220 220 230 96 158 220 220 218 230 96 154 220 252 250 250 212 212 220 52 128 210 12 60 170 88 146 220 80 136 210 80 132 210 76 126 200 72 122 200 68 118 200 68 114 190 64 108 190 60 104 190 60 100 180 56 96 180]; mask:((Depth1Image new) width:21; height:23; bits:(ByteArray fromPackedString:'???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8???8') ; yourself); yourself]
!

printer22x22Icon
    <resource:#programImage>
    ^ self printer22x22Icon1
!

printer22x22Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self printer22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#printer22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class printer22x22Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@@@@@@@@@@D@@@@@@@@@@@@@@@@A@@@@@@@@@@@A@@@A@PDA@@@A@PD@@P@@@@@@
@@@A@@@@@@@@@@@@@@@@@P@@@@@@@@@@@P@A@PD@@PD@@PD@@PDA@P@@@@@@@P@@@@@@@@@@@@@@@@DD@PPA@@@@@PDA@PDA@PDA@PDA@PDD@PPA@P@@@PPD
A@PDA@PDA@PDA@PD@PPAAPD@@@DA@PDA@PDA@PDA@PDA@PDAAPTA@@@AAPTEAPTEAPTEAPTEAPTE@PTE@P@@@PTEAPTEAPTEAPTB@ HEAPDEAPD@@@DEAPTE
APTEAPTE@ HBAPTAAPTA@@@AAPTEAPTEAPTEAPTEAPTE@PTA@@@@@PTEAPTEAPTEAPTEAPTEAPDA@@@@@@DA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 255 255 0 0 0 255 255 0 129 129 129 194 194 194 105 133 190 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@??0A?? A?? C??@C??0G??8O??8_??8_??8_??8_??8_??8_??0_?? _??@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

printer22x22Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class printer22x22Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
QDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ@@@@@@@@@ADQDQ@QDQDQDQDADQDQDAD@@AD@@PDQDQD
ADQDQDQDPDQDQDPD@@P@P@P@@DQDPDQDQDQDQ@DAADP@@@@@@@@@DA@DPADQDQDQDQDA@0Q@@@@@@@@@@@@3AD@3L3L3L2H#LCADPCL3L3L3H"L0ADQ@@@@@
@@@@@@ADQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDPb');
                colorMapFromArray:#[ 0 0 0 194 194 194 255 255 0 105 133 190 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@??0A?? A?? C??@C??0G??8O??8_??8_??8_??0_?? _??@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

reload22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self reload22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#reload22x22Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class reload22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@UT@@@@@EU@D@@@@UT@@@H@AUP@@@@@EU@@@@@@EU@@@@E@EU@@@@@@EU@@@@@AUUT@@@@@UUP@@@@@EU@@@@@@AT@@@@@@@P@@@@H@@@@@@@@
@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@G@@@@@@@J@@@@@@@I@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 129 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@G<C@_?C@??#A?C3C>@;G<@KG<@CG<@C??$C_?NCO>_CG<?#C9?3A3?;@''??@@?#P@?C\A?COC>CG?<CC?8C@? C');
                            yourself);
                yourself
        ]
!

removeTab22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self close22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#close22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class removeTab22x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@ H@@@@@@@@@@@@B@ @@@@@@@@@@@@HB@ @@@@@@@@@B@ H@@@@@@@@@@@@@@ HB@@@@@@@B@ H@@@@@@@@@@@@@@@@B@ H@@@@B@ H@@@@@@@@@@@@@
@@@@@@HB@ @B@ H@@@@@@@@@@@@@@@@@@@@@@ HB@ H@@@@@@@@@@@@@@@@@@@@@@@@B@ H@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ @@@@@@@@@@@@@@@@@@
@@@B@ H@@ HB@@@@@@@@@@@@@@@@@@@B@ H@@@@B@ H@@@@@@@@A@@@@@@@B@ H@@@@@@@HB@ @@@@@@@@@@@@@B@ H@@@@@@@@@@ HB@@@@@@@@@@@@@ H@
@@@@@@@@@@@B@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 255 255 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@A C@A0G@@8N@@\\@@N8@@G0@@C B@G0@@N8@@\\@@8N@A0G@A C@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

right22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self right22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#right22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class right22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUPUUUUUIUPUUUUUJUPUUUUUJ%P@@@@@J)PJ******PJ****** J******PJ*****)PEUUUUZ%PUUUUUJUP
UUUUUIUPUUUUUEUPUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 0 127 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@F@@@G@@@G ???0???8???<???<???8???0@@G @@G@@@F@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

save22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self save22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#save22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class save22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
AL3L3L@PM3L3L0?PML3L3L=PM3L3L0=PML3L3L?PM3L3L0?PML3L3L?PM3L3L0?PML3L3L?PM3L3L0?PML3L3L?PM@@@@@?PO??????PO??????PO??????P
O=UUUU?PO=???[?PO=5O?Z?PO=6O?Z?PO=6O?Z?PO=0O?Z?P5U***U5P');
                colorMapFromArray:#[ 255 255 255 0 0 0 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???8');
                            yourself);
                yourself
        ]
!

saveAsMethod22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveAsMethod22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#saveAsMethod22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class saveAsMethod22x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@A@0LC@0LC@0@@DCD0LC@0LC@0@3LPLPLD@0LCP0LCLQ@1LCQ@LCQ@L@L1DCDCADPCQDLC@3LPLS@4QDQDPC@CL1@1@0QCQ@QC@0L3DCD0MD@0MD@0@3LPLP
LDP0LDP0LCL1@1LCQ@LCQ@L@L3DCDC@0LC@0LC@3LPLP@@@@@@@@@CL1@3L3L3L3L3L3L3DCL3L3L3L3L3L3LPL3L3L3L3L3L3L1@3L1DQDQDQDQL3DCL3D3
L3L3LRL3LPL3LSDPL3L1H#L1@3L1LR@3L3D"L3DCL3D1HCL3LRH3LPL3LS@@L3L1H#L1LQDQH"H"H"DQLQDb');
                colorMapFromArray:#[ 255 255 255 0 0 0 127 127 127 170 170 170 127 127 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???8');
                            yourself);
                yourself
        ]
!

scrollLock22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self scrollLock22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#scrollLock22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary scrollLock22x22Icon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@PDA@PDA@PDA@PDA@PD@@@@@@@@@@@HC@0LC@0LC@0DC@0LA@@@@@@@@@@@B@0PDA@PDA@PE@0XGAP@@@@@@@@@@B@LIBP$IBP$IB L@@@(@@@@@@@@@
@@,CC@0LC@0LC@4MCP4M@@@@@@@@@@@NC0@@@@@LC@0PDQDQD@@@@@@@@@@@@AHSD1PUEP0LE PDAAX@@@@@@@@@@A\XFQ$XF!!TU@A,DA@P[@@@@@@@@@@@\
GQ8^G10 G!!T!!@0$IHP@@@@@@@@@"H1H"H!!H#H!!8^IBP$IBP@@@@@@@@@IRX''JB$*J2T^G"0C@0L-@@@@@@@@@B8*K3@1K2,.G!!82@0XGL @@@@@@@@@3J#P5
MSP+L18^M L^G#X@@@@@@@@@M3 9N#(9NC\;OC46M#X6@@@@@@@@@BH#H2L#H2L"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[240 240 248 175 152 96 160 152 104 208 232 248 224 232 248 144 144 120 79 104 160 191 200 216 159 144 104 239 232 248 127 128 128 175 168 136 239 240 248 111 112 144 191 184 168 224 240 248 111 112 128 160 176 200 207 176 136 192 152 56 208 192 160 240 248 248 144 152 168 192 168 120 207 160 64 240 232 224 208 192 144 143 152 168 191 144 40 223 208 168 255 248 248 223 208 184 224 224 208 128 144 168 192 176 128 175 120 24 127 136 168 176 144 40 255 224 136 255 240 208 223 192 136 240 224 176 255 240 200 255 224 160 112 136 168 112 128 168 176 136 24 255 240 184 175 136 56 191 152 64 111 128 168 176 128 24 224 208 144 127 88 16 96 120 168 175 128 24 240 216 136 255 224 144 223 184 104 175 184 208 159 168 200 128 144 184]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@C@@@C@@@C@@@CA??#A??#A??#A??#A??#A??#@??#A??#A??#C??#C??#C??#C??#C??#C?@C@@@C@@@C@@@C') ; yourself); yourself]
!

start22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self start22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#start22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary start22x22Icon'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@N8@@@@@@@@@@@@N<^@@@@@@@@@@@@;.;.;.;.@@@@@@C/G @@@@8^@@@@@N<^@@@@@A@@@@@@;18@@@@@D@@@@@C.;.;.; @P@@@@@N
<^@@@@@@@@@@@@;18@@@C!!G.@@@@C/G @@@@G>@@@@@N;.;.; @_8@@@@@;18@@@@A? @@@@C/G @@@@G>@@@@@N<^@@@@@_8@@@@@;.;.;.@A? @@@@C/GJ
@@@@G>@@@@@N<^@@@@@_8@@@@@;18@@@@@@@@@@@C.; @@@@DQ@@@@C ; 8@@@A&X@@@C 8@8N@@@"H@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@AC@DAG DAG?<@G N@G N@G N@G?.@G N@G _@G _@G?_@G _@G _@G _@G?_@G ? G!!?0G!!?0G!!.PKQNPT(_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

startNewSystemBrowserIcon22x22
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self startNewSystemBrowserIcon22x22 inspect
     ImageEditor openOnClass:self andSelector:#startNewSystemBrowserIcon22x22
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary startNewSystemBrowserIcon22x22'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
NP(JB (JB (JB (9@@@@@@@@@@@@@@*Q$YFQ$YFQ$YFQB @@@@@@@@@@@@@J$V1,[F1,[F1,[@(@@@@@@@@@@@@@B)E,[F1,[F1,[F0J@@@@@@@@@@@@@@*Q
[F1,[F1,[F1,B @@@@@@@@@@@@@JNQHRD!!HRD!!HRD (@@@@@@@@@@@@@NP(JB (JB (JB (9@@@@@@@@@@@@@@@@@@@@@@@@QATTIR)P@@@@@@@@@@@@@@@@
@@@@F2]HVEQ@JBI''@@@@@@@@@@@@@@@@J6&Q XFA UT)FF\JB (JB @@@@@@KFI[B0,H@ LGA TU_9FQ$S$@@@@@L5I1V0,CB@XMCPXMAQLA@PDR@@@@@B1Y
VT8KB@4NC 8NCPTW@PDAD @@@@@,Y$-CB0XMC0<OC08EGQHRD!!H@@@@@KE%UP0,LC!!DQDQ@OAQ4JB (J@@@@@B5IVT4KB0,KB0,KB0,T@@@@@@@@@@AEMU%M
B0,KB0,KB0-GF (JB (@@@@@@A=@ST5MS$9NS$9+GF^Q$YD9@@@@@@@$G4%&Y&)1]XV@L#1/[6=/D @@$HI]H1X_M%M&Z&MQL#6B[6=/[1H@#86LWBD@@BTY
G#P2O%^B[6=/[6<R@@BL[P@@@@@@@@@/K1HRD!!HRD!!HRD @a');
                colorMapFromArray:#[ 0 0 0 32 223 32 40 255 124 50 255 112 51 255 109 54 229 139 62 255 87 62 255 88 62 255 91 62 255 136 64 64 64 73 255 115 83 255 62 91 255 73 94 255 74 101 255 84 105 255 85 112 255 96 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 170 170 170 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 176 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 183 183 183 190 190 190 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 196 196 196 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 217 217 217 223 32 32 223 128 63 223 192 255 223 223 32 223 223 224 223 255 255 224 224 224 224 224 239 224 239 240 224 255 255 231 207 255 231 208 255 238 191 255 238 192 255 239 159 232 239 191 255 239 223 255 239 224 255 239 239 224 239 239 239 239 239 240 239 255 255 240 207 144 240 239 223 240 240 239 240 255 255 246 176 255 247 175 255 247 207 255 247 239 255 254 160 255 254 191 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'??@@??@@??@@??@@??@@??@@??@@@O0@@_<@@??<A??<C??<C??<C??<C??<C??@C??<A??<A??<O??<_O?<LA?<');
                            yourself);
                yourself
        ]
!

stop22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stop22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#stop22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class stop22x22Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A?>@A?>@A?>@A?>@A?>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@?<@A?>@C??@G?? O??0_??8_??8_??8_??8_??8_??8_??8_??8_??8O??0G?? C??@A?>@@?<@@@@@@@@@');
                            yourself);
                yourself
        ]
!

up22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self up22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#up22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class up22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUURUUUPUUUJ%UUPUUT*)UUPUUR**UUPUUJ**%UPUT***)UPUVU*%UUPUUT*%UUPUUT*%UUP_UT*%UUP_UT*%UUP_5T*%UUPWUT*%UUPWWT*%UUPWUT*%UUP
UUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUT*%UUPUUTUUUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 0 127 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@C@@@G @@O0@@_8@@?<@A?>@A?>@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@@O0@');
                            yourself);
                yourself
        ]
!

upRight22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self upRight22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#upRight22x22Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class upRight22x22Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUT%UPUUUUT)UPUUUUT*UPP@@@@*%PR*****)PR******PR*****)PR*****%PR*UUU*UPR*UUT)UPR*UUT%UPR*UUTUUPR*UUUUUPR*UUUUUPR*UUUUUP
R*UUUUUPR*UUUUUPR*UUUUUPR*UUUUUPR*UUUUUPYU%UUUUPUUUUUUUP');
                colorMapFromArray:#[ 255 255 255 0 0 0 0 127 0 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@L@@@N@@@O@_?? _??0_??8_??8_??0_?? _ O@_ N@_ L@_ @@_ @@_ @@_ @@_ @@_ @@_ @@_ @@_ @@@@@@');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-24x24'!

baseImage24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self baseImage24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#baseImage24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class baseImage24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@BY&H!!DQ&Y&XFX@@@BY&H!!DQ&
Y&XFX@@@BY&H!!DQ&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@BY&H!!DQ&Y&XFX@@@BY&H!!DQ&Y&XFX@@@BY&H!!DQ&Y&XFX@@@
A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XF@@@@BY&H!!DQ&Y&XF@@@@BY&H!!DQ&Y&XF@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 255 0 127 127 0 255 0 0 255 255 127 127 127 170 170 170 255 0 0 255 0 255 255 255 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:41:08 / cg"
!

baseMenu24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self baseMenu24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#baseMenu24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class baseMenu24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QDQDQDQDQ@@@@@@@RH"H"H"H"TE@@@@@R\"H"H''H"TE@@@@@R]7\"]7\"TE@@@@@RH"H"H"
H"TE@@@@@P@@@@@@@@TE@@@@@QDQDQDQDQTE@@@@@RH"H"H"H"TE@@@@@R\"I2H"H"TE@@@@@R]2I7\''\"TE@@@@@RH"H"H"H"TE@@@@@P@@@@@@@@TE@@@@
@QDQDQDQDQTE@@@@@RH"H"H"H"TE@@@@@R]2I7H'']2TE@@@@@RH"H"H"H"TE@@@@AUUUUUUUUUTE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 255 0 0 127 127 127 127 127 255 0 0 100 100 100 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:41:06 / cg"
!

baseWindowSpec24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self baseWindowSpec24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#baseWindowSpec24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class baseWindowSpec24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADQDQDQDQDP@@@@@@@@@@@@@@@@@@@@@AUUUT UUUUH@@@@@AUUUT TQTUH@@@@@APTQT UU
UUH@@@@@AUUUT TQDUH@@@@@APTQT UUUUH@@@@@AUUUT TUDUH@@@@@APTQT UUUUH@@@@@AUUUT UUUUH@@@@@AUUUT T"H%H@@@@@AUUUT T"H%H@@@@@
AUUUT T"H%H@@@@@ARH"T T"H%H@@@@@ARH"T T"H%H@@@@@AUUUT UUUUH@@@@@@"H"H H"H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 200 200 0 0 127 127 127 127 127 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:41:03 / cg"
!

bigCrossHairIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bigCrossHairIcon inspect
     ImageEditor openOnClass:self andSelector:#bigCrossHairIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary bigCrossHairIcon'
        ifAbsentPut:[(Depth1Image new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@F0@@XL@@>>@A8O@A>?@B,Z B(J @@@@B(J B,Z A>?@A8O@@>>@@XL@@F0@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[255 255 255 0 0 0]; mask:((Depth1Image new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@G0@@_<@@?>@A??@C?? C?? G??0G<_0G<_0G<_0G??0C?? C?? A??@@?>@@_<@@G0@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

bugReporter24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bugReporter24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#bugReporter24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary bugReporter24x24Icon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@QDQDQDQDP@@@@@@@@@@@@@@@P@@@@@ADQDQDQDQ@P@@@@@@@@@@@@@A@P@@@@QDQDQDQDPA@P@@@@@@@@@@@@PA@P@@ADQDQDP@
Q@PA@@@@AADQQ@QD@@P@@@@@ADQDQD@DP@@@@@@@ADEAPTPD@BH"H @@ADPTD@P@H"L3L2@@ADEA@"@"H3L3L3H@@@@BH3LBL3L3L3L @@@BH3LBL3L3L3LJ
@@@@H3L@@@@@@@@@@@@BH3LBH3L3L3L @@@@H#HBH#L3L3H @@@@@@@@H"H"H"@@@@@@@@@@@@H"H @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 170 170 170 128 0 0 255 0 0 255 255 255]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@??8@??8C??8C??8O??8O??8???8???8???<???0???8???<???>???>???>A??>_??>O??>@[?<@B?8@F_0@H1,@C@0@@@@') ; yourself); yourself]
!

changesBrowser24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self changesBrowser24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#changesBrowser24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class changesBrowser24x24Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C????@@@@@@@C@@@????3@@@@@@@3@@EUUUT3@@@@@@D3@AUUUUD3@A?5UUD0@AUUUUD0@A]7UUD@@
AW]7UD@@A]7]U@@@AUUUU@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@_?<@_?<A??<A??<G??<G??<_??<_??<_??<_??0_??0_??@_??@_?<@_?<@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:59 / cg"
!

class24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self class24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#class24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
DQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQDQDQDQL"H"H"H"LQDQDQDQIDQDQDQCHQDQDQDQI@@@@@@AHQDQDQDQI@@@@@@AHQDQDQDQI@@@@@@AHQDQDQDQH1DQDQDQHQDQ
DQDQL"H"H"H"LQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQDQ');
                colorMapFromArray:#[ 32 223 32 127 127 127 64 64 64 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?? @?? @?? @?? @?? @?? @?? @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

dart24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self dart24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#dart24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary dart24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@A@ L@@@@@@@@@@@@@@@@@@@@@@@@@@@PEA XG@@@@@@@@@@@@@@@@@@@@@@@HBPXJB0,JC@@@@@@@@@@@@@@@@@@@@@4NC0XKB0,KA L@
@@@@@@@@@@@@@@@@D@(JB0,KB0,KDP<R@@@@@@@@@@@@@@@SEATVEQTUE!!TUEQ\XFP@@@@@@@@@@@A([GA4^G!!8^G!!8^G!!8^G2@@@@@@@@@@@BD"H2P^IRT%
IRT%IRT%I"\(@@@@@@@@JRD"B0,$G"T%IRT%IRT%IR(+K@@@@@@-K"T"B0,KIA8%IRT%IRT%IR<*J" @@@@!!IRT0H0,KB2P^IRT%IRT%IRX*J"\1@CH.IRT"
B0,KB0,$G"T%IRT%IRT*J"(3MBT%IQ8"B0,KB0,KIA8%IRT%IRT/J2(,MRT%IQ8"B0,KB0,KB2P^IRT%IRT.J"(3@CX.IQ8"H0,KB0,KB0,$G"T%IRT%J"(3
@@@7HRT"B0,KB0,KB0,KIA8%IRT%K2,3@@@@NC$"B0XKB0,KB0,KB2P^IRT%K"(3@@@@@B4:B XFA ,KB0,FB0,$G"T%IR(,@@@@@@@;OC4QA XFA XKA ,K
O!!8%K"(*@@@@@@@@O1@POC4QA XKB0XKB38^J$AA@@@@@@@@@@$PBP$PODHFA XKA )CQDT@@@@@@@@@@@@IDA@PBP%FATHFQ4!!I@@@@@@@@@@@@@@@@BQ@P
DA@IBP$RDA@;@@@@@@@@@@@@@@@@@D(PDA@PDA@ID@$@@@@@');
                colorMapFromArray:#[ 0 0 0 176 216 240 48 208 200 15 216 184 144 216 224 48 216 200 0 208 184 31 216 200 191 216 240 95 216 208 0 216 184 0 208 176 16 216 184 143 216 224 32 216 200 0 224 200 80 216 208 15 208 184 79 216 200 47 176 200 0 168 208 0 152 200 0 152 184 0 160 200 16 168 200 112 192 240 95 160 216 0 192 208 15 168 184 0 112 200 0 120 200 0 160 240 31 176 240 0 128 208 0 184 184 0 216 176 0 160 184 0 128 200 0 144 208 0 168 240 15 168 240 32 144 208 0 160 224 0 168 224 15 168 224 95 168 216 0 136 208 0 152 216 0 176 184 16 168 224 47 144 208 15 160 224 47 152 208 15 128 200 31 136 208 16 136 208 16 144 208 0 136 216 31 184 200 160 224 224 63 216 200 32 208 184 0 168 184 111 216 208 0 176 240 31 168 224 31 208 184 15 176 200 79 184 224 143 208 240 79 216 208 16 208 184 47 216 200 112 224 216 96 216 208 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@A0@@C8@@O<@@_>@@??@A?? C??0C??8G??<O??>O???_???????????_???O???G???C???A???@???@_?>@O?8@G?8@C?0');
                            yourself);
                yourself
        ]
!

deleteClass24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self deleteClass24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#deleteClass24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary deleteClass24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH @@@@@B@@@@@@@BH"@@
@@H @@@@@@@@H"H@@BH@@@@@@@@@E"H&X"Y&D@@@@@@@X@H"H @AX@@@@@@@XDP"IDQCX@@@@@@@XDH"H$QCX@@@@@@@XBH$P"QCX@@@@@@@X"H3L2H3X@@@
@@@@H"Y&Y&I6D@@@@@@BH"@@@@\''@@@@@@@BH @@@@A7@@@@@@@@H@@@@@@B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 255 255 255 170 170 170 255 0 0 127 127 127 223 223 32 240 240 240 64 64 64 255 128 128 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@A0A@A8F@@<L@@?? @?? @?? @?? @?? @?? @?? A8G@A0C@@ A@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

deleteClassFromStart24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self deleteClassFromStart24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#deleteClassFromStart24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class deleteClassFromStart24x24Icon'
        ifAbsentPut:[(Depth4Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"@@@@@@@@@@@@@@@"@@@@@@@@@@@@@@H"H@@@@@@@@@@@@@H"H@@@BH @@@@@B@@@@@@@BH"@@
@@H @@@@@@@@H"H@@BH@@@"@@@@@E"H&X"Y&D@"@@@@@X@H"H @AXH"H@@@@XDP"IDQCXH"H@@@@XDH"H$QCX@@@@@@@XBH$P"QCX@@@@@@@X"H3L2H3X@@@
@@@@H"Y&Y&I6D@@@@@@BH"@@@@\''@@@@@@@BH @@@@A7@@@@@@@@H@@@@@@B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[255 255 255 170 170 170 255 0 0 127 127 127 223 223 32 240 240 240 64 64 64 255 128 128 0 0 0]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@F@@@F@@@O@@@OA0A@A8F@@<LF@??&@??/@??/@?? @?? @?? @?? A8G@A0C@@ A@@@@@@@@@@@@@@@@@@@@@'); yourself); yourself]
!

deleteClassToEnd24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self deleteClassToEnd24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#deleteClassToEnd24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class deleteClassToEnd24x24Icon'
        ifAbsentPut:[(Depth4Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH @@@@@B@@@@@@@BH"@@
@@H @@@@@@@@H"H@@BH@@@@@@@@@E"H&X"Y&D@@@@@@@X@H"H @AX@@@@@@@XDP"IDQCX@@@@@@@XDH"H$QCXH"H@@@@XBH$P"QCXH"H@@@@X"H3L2H3X@"@
@@@@H"Y&Y&I6D@"@@@@BH"@@@@\''@@@@@@@BH @@@@A7@@@@@@@@H@@@@@@B@H"H@@@@@@@@@@@@@H"H@@@@@@@@@@@@@@"@@@@@@@@@@@@@@@"@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[255 255 255 170 170 170 255 0 0 127 127 127 223 223 32 240 240 240 64 64 64 255 128 128 0 0 0]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@A0A@A8F@@<L@@?? @?? @?? @??/@??/@??&@??&A8G@A0C@@ AO@@@O@@@F@@@F@@@@@@@@'); yourself); yourself]
!

desktop24x24Icon
    <resource: #programImage>

    ^self desktop24x24Icon2
!

desktop24x24Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self desktop24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#desktop24x24Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class desktop24x24Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@K^7-;^7-5" (J@&J$EAI*A2KTP@K AD@K^7-;]AI*A2KTP@K AD"BXSD085X3$N@CH2A7-;G!!,[Y:9?*5AP&9.COV>"(#U/@CJ$)WZSSI\JB&@FRYA5#X6M
^J"(\C&(@G,YRYP"H"H"G0",R$(3R!!0E_S\KV3$7@G-I%BJ2 KIQCB@8HS  H@$IY(E)E :A@A8F%BJ@ F"-HC !!NB@ T%J0&V%)VP9)@A- %2J2ZJ4LNBD!!
HB@MT%J0&V%)#@9)@A- B"I(TP08HRD!!HB@MT%J0&V&\#@9)@F]LB"IQ,S !!HRD!!HBART+B0&V&\E09)@J9L%1>RHBD!!HRD!!HBART+B0&V&DWP9)@G=L%8JU
HRE*HRD H@5RT+B0T6&D.&1)@G= %@ \OF)"HRD HEIRT+A: Y2D@F2\@J- +:0%R6)"HRD HEIR,KA> XRD@V2D@EA _ET%R6(!!HS8 CUIR,KA> XRD@V2D
@E@F^J0%R6(!!HR@ T%IR,KA> XRD@ :D@I-II1@P-FH!!HR@ T%J0,G9> XRD@ :D@I.])(=E]8U-[UYVO3<?O2"E!!QDQ@ 8Q@AJ5Q)9B")5_W5=_W4!!HMCP4
GQ4]K08]@HNFQZLXJ5=.EAPTEK"!!(ZF!!"8&IF :I@HLC\U]@JWN6-+Z6V%)CP4MCEV9.F 9.@F-+Z35T''8]/[:J"\GA[E%&L@A(ZF 8Z@KV5NP:9(E1D@@B:
KWH&D08NC 8NC 8N@H:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N');
                colorMapFromArray:#[ 239 239 240 239 239 255 240 240 255 111 112 128 64 112 191 48 112 208 79 112 191 95 111 176 64 112 208 63 127 223 95 128 207 95 144 223 63 112 223 48 112 224 175 176 191 144 160 207 112 159 208 159 175 191 143 144 207 191 191 207 47 63 95 47 48 80 208 208 224 223 224 240 255 208 64 48 95 176 255 255 255 96 127 176 48 111 208 127 143 160 96 112 176 80 127 208 48 112 223 47 111 223 95 128 208 95 144 224 95 160 240 47 96 208 192 207 208 111 144 208 144 160 176 16 143 191 192 192 208 15 127 191 32 48 80 223 223 224 239 240 240 240 255 255 48 111 191 112 143 160 80 111 176 47 111 207 112 128 160 160 175 176 80 128 207 80 144 223 48 111 223 160 175 191 79 128 223 79 143 240 47 96 223 160 175 208 47 112 223 143 159 176 0 175 224 192 192 207 96 176 31 32 48 64 224 224 224 47 128 191 63 143 191 32 80 175 112 128 144 64 111 191 48 111 207 32 96 208 95 127 191 79 128 207 80 143 223 95 159 224 127 143 191 79 127 223 63 127 224 80 159 240 160 176 208 48 96 207 143 159 191 15 159 208 207 208 208 208 223 224 32 47 64 207 208 224 223 223 223 224 224 240 64 127 191 111 127 144 80 127 191 80 143 207 32 111 223 159 175 176 79 127 207 79 143 223 80 144 224 111 127 191 80 128 223 96 160 240 32 96 223 159 175 208 176 176 191 128 159 191 47 63 80 176 191 223 192 207 224 48 111 144 208 208 223 64 80 111 48 111 176 48 96 176 64 111 176 79 128 176 63 111 191 64 127 207 64 143 224 95 112 176 64 112 207 79 128 208 79 143 224 112 128 191 95 143 223 95 159 240 79 127 208 143 159 207 111 175 255 144 160 191 144 144 175 175 191 223 208 223 223 63 79 95 31 112 175 63 64 95 223 223 240 47 96 176 0 0 0 63 144 208 63 96 176 48 96 191 64 127 208 80 112 191 80 127 207 63 112 208 64 128 223 95 127 207 95 127 208 80 144 240 79 144 240 128 144 207 96 160 255 144 159 176 224 48 0 175 176 208 207 207 208 48 64 95 191 192 223 15 160 240 31 79 160 47 95 175 96 144 176 47 96 191 79 127 191 63 127 208 63 112 207 112 143 191 63 111 207 64 127 223 111 128 191 79 112 207 64 128 224 64 112 223 95 128 223 144 160 208 95 143 224 159 160 176 31 47 64 208 208 208 48 63 95 191 192 207 224 239 240 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>@@@@');
                            yourself);
                yourself
        ]
!

desktopOSX24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self desktopOSX24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#desktopOSX24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary desktopOSX24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU#5UUUUUUUUUUUUUUUUUUUUUU
UUUUUUVOUUQ02''Y6X&J5-[TYKB0]GQ4,KB0]\GA>UURN(A$Y4]D5VE G)JP5VE G)JP5(7@YUXSFWU4B*06X&"\TEGE1I2\TI7E-CR<*UZZ(*J!!K$9M[6]%R
^G!!80<NV/;=:TECPUZZ&*JZS$9N9D!!IQ 8M9TUDRD+&94MCPUZ4-WBHD-KSC^[-$R"AJZ8!!Q ;03)P@_UPXF (HVP$IC4=NA1<\+IRU+-;_P3<?UUP$IB ) 
QDQ*H2MG2<,XFGM3HRF?JR$0US(OIFV.VP-_M43DRYBP20!!^!!$T9!!7.TUUUA_G2,#H3M2\$W$)J:RVZU.K C"UV)UUV"]ETU5MR_GA3N[)I''Y+L(/UU5#UV\
USP<XQLPU"Y=Q)4^O8A#,7]HPKY?''@DAUUVYAUTZ"5VWDUV*,UV\''EU?UUT21UTNUUT[M%V2+5U(3ETL0T?ROS5)&<C@ZUUZUWIM5);B+36ON<#HS4:E[6>>
5:_@C 8NUUUW'')9,T5L.O#81")FQ6M"!!,KB0''%UW#5UUUUUUNET8NET8NET8NET8NET8UUVOUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU');
                colorMapFromArray:#[ 96 64 64 31 16 31 48 32 48 191 80 160 127 64 143 0 32 63 96 64 128 223 192 208 223 143 191 112 95 160 127 95 144 192 80 176 15 0 31 64 48 63 15 15 16 159 112 207 63 32 111 47 32 64 144 96 127 47 31 96 95 64 80 144 79 176 175 95 176 255 160 240 240 175 208 192 176 191 15 47 64 0 47 48 144 95 144 191 160 176 95 48 127 112 79 96 176 112 143 176 128 160 128 79 144 176 96 175 143 96 175 208 144 176 64 32 96 95 63 80 160 47 143 160 80 143 63 32 48 223 159 191 192 175 191 96 63 128 96 96 128 64 47 63 192 111 175 112 112 143 31 15 31 112 95 96 16 16 48 207 191 207 0 47 63 191 80 175 0 0 15 191 95 160 160 144 223 64 176 224 16 31 64 160 176 208 128 127 143 223 143 224 64 31 64 160 143 208 160 95 160 144 80 143 192 96 191 144 79 128 143 80 144 239 159 207 80 16 63 255 176 240 176 112 144 64 48 64 239 144 223 16 32 48 80 111 176 96 143 223 111 79 95 160 112 143 144 111 127 95 111 143 159 159 160 0 0 0 64 32 111 15 0 15 208 191 207 160 79 175 31 0 16 112 80 111 111 63 128 47 32 48 224 144 207 207 80 191 143 79 144 31 31 80 175 159 175 128 64 143 191 127 160 143 96 176 224 112 208 255 207 255 64 64 64 16 15 16 160 79 144 191 128 160 80 96 143 80 48 64 255 176 255 159 207 255 143 127 143 80 63 64 16 32 63 192 128 175 64 47 128 96 32 96 175 159 176 95 31 64 143 96 127 159 111 128 112 80 95 175 95 160 176 128 223 79 32 96 207 191 191 47 16 47 223 144 208 208 143 191 112 64 143 160 111 128 31 31 47 111 111 111 160 95 143 223 111 191 191 143 160 160 95 175 128 112 160 31 47 80 159 64 175 63 31 63 175 175 176 111 111 127 255 176 224 112 96 111 255 192 255 95 63 96 144 127 160 175 64 144 144 111 128 32 32 80 79 48 64 0 32 48 80 63 80 47 47 47 32 16 47 111 95 144 95 112 127 144 63 144 79 63 96 112 96 127 63 47 127 223 207 208 208 192 208 96 79 80 80 48 96 79 79 80 64 48 80 80 64 111 96 96 144 63 47 63 160 95 191 79 63 127 144 95 175 64 95 144 111 96 111 128 95 160 80 112 208 95 32 80 112 64 111 191 160 191 48 16 48 176 127 144 176 64 144 127 95 111 255 191 255 176 111 143 159 112 128 160 47 128 112 111 127 128 80 111 96 96 127 112 127 128 48 95 191 143 95 127 240 159 208 16 15 31 32 32 47 208 143 176 111 111 128 223 112 207 80 79 80 240 160 208 95 128 176 176 79 160 255 144 240 127 80 96 128 96 111 191 176 191 16 0 15 176 112 160 160 80 207 175 96 144 16 31 48 47 47 48 127 127 143 128 95 111 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@????????????????????????????????????????????????????????????????????????@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

documents24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self documents24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#documents24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class documents24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@V%)FG@$IB&8^%9]]!!5APGP@@@@@@@@@@QDPPX#T5I6U@ZF!!<E38>
TP@@@@@@@@@@QDPPX#T5I6U@ZF!!<E38>TP@@@@@@@@@@VE +^9FQO8 F%IRULXFA%C@3L0@@@@@@[F1''E%IRP#^DHB@<OC0<OC2S$0@@@@@@ H@*^ HBKWNP
UUVB (JB #1+Z0@@@@@@ H@*^ HBKWNPUUVB (JB #1+Z0@@@@@@B@"M@#4=K@=Y%YT#G2D!!&VPZF @@@@@@K2<)J@DAACZPUUUG_(NCFFQVU @@@@@@F1-9
#C,;EU9Y%YUJCE1\[VQ*Z @@@@@@F1-8]0@@S''JPUUVB (JB #1APP@@@@@@F1-8]0@@S''JPUUVB (JB #1APP@@@@@@U5^K@H*JSP9Y%YU_W5=_W31=_P@@
@@@@_7<S''VE!!DXVPUUVB (JB #0EAP@@@@@@A0\%"S 8]I!!Y%YU_W5=_W31TU@@@@@@@A0\%"S 8]I!!Y%YU_W5=_W31TU@@@@@@@K"95II.[R06PUUVB (JB
 #2O#0@@@@@@K"9 SI*ZH$ 2B0,RD#$9NRXYFP@@@@@@$)IE%''A0RSQ#S4<C#%MSZQ%/[0@@@@@@$)IE%''A0RSQ#S4<C#%MSZQ%/[0@@@@@@''I1[P6Y&](Y1
N#(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 121 174 168 117 164 171 112 155 176 142 153 154 145 184 186 154 154 154 161 162 162 87 181 134 86 176 134 84 167 135 83 160 137 200 200 200 159 207 255 73 134 146 70 129 149 67 122 152 94 152 159 124 183 164 238 238 238 122 175 167 252 252 252 136 182 178 108 147 180 145 185 187 93 194 255 160 160 160 168 168 168 87 178 134 85 170 136 163 185 209 78 147 140 154 198 251 213 213 213 202 230 247 126 194 164 199 225 255 125 185 164 122 179 166 242 242 242 105 152 170 115 161 174 113 157 175 109 148 180 106 142 183 147 184 190 148 181 193 87 182 134 86 177 134 179 179 179 187 187 187 197 197 197 207 207 207 74 137 145 86 147 151 68 123 151 66 119 153 124 184 164 237 237 237 241 241 241 119 169 170 255 255 255 114 159 174 136 177 182 130 168 185 141 177 188 159 159 159 149 179 197 183 217 203 85 172 135 96 180 141 99 176 145 137 189 255 73 136 145 116 185 158 205 237 255 125 191 164 125 189 164 123 180 165 122 177 167 120 131 130 88 131 169 85 127 171 110 150 178 141 149 153 151 151 151 162 161 158 166 166 166 87 179 134 86 173 135 186 186 186 101 179 146 211 234 223 194 239 255 71 130 148 69 125 150 227 227 227 125 186 164 123 181 165 117 171 166 120 132 130 254 254 254 114 149 164 151 197 183 107 144 181 144 181 188 153 157 160 163 163 163 170 170 170 86 174 135 146 215 254 81 154 138 201 201 201 108 181 153 217 217 217 70 126 149 66 120 152 125 187 164 124 183 165 120 174 165 119 170 169 118 166 171 116 161 173 110 151 178 106 144 182 145 183 188 156 156 156 27 119 255 87 180 134 86 175 135 185 185 185 194 193 189 173 227 255 209 209 209 71 131 148 85 143 148 67 121 152 65 117 154 123 182 165 122 177 166 119 171 169 117 165 171 111 152 177 140 150 153 149 149 149 159 158 155 140 172 193 88 183 134 174 174 174 182 182 182 190 190 190 102 178 147 75 139 144 72 132 147 216 244 248 125 192 164 125 188 164 238 246 242 122 178 166 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@G?? G?? G?? G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G??<G?0@@@@@');
                            yourself);
                yourself
        ]
!

dos24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self dos24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#dos24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class dos24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@L3L3L3L3L3L3@@@@LQDQDQDQDQDQ@@@@LRH"H"H"H"H1@@@@LRH"H"H"H"H1@@@@LRP"H"H"H"H1@@@@LRIBH"H"H"H1@@@@LRH$H"
H"H"H1@@@@LRH"P"H"H"H1@@@@LRH$H"H"H"H1@@@@LRIBH"H"H"H1@@@@LRP"H"H"H"H1@@@@LRH"H"QDIDP1@@@@LSL3L3L3L3L1@@@@@QDQDQDQDQDQ@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8C??8@@@@@D@@@D@@@\1 @%J@@%I@@%H @\3@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:56 / cg"
!

fileBrowser24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileBrowser24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#fileBrowser24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileBrowser24x24Icon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3@Y&Y&Y&Y&@@@@@@3@X@@@@@@F@@@@@@3@XN;.;.8F@@@@@@3@XN; @@@@@@@@@@3@XN;J
=/[6=/@@@@3@X@; [6=/[6@@@@3@XAC =/@@A/@@@@3@X@D@[6A/C6@@@@3@X@@P=/[6=/@@@@3@X@@@[6=/[6@@@@3@XO@@=/[6=/@@@@3@XF<@@@@@@@@@
@@3@XOX@@@@@@@@@@@3@XF=/[6<F@@@@@@3@XO[6=/XF@@@@@@3@X@@@@@@F@@@@@@3@Y&Y&Y&Y&@@@@@@C@Y&Y&Y&Y&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@O?? O?? O?? O?? O??<O??<O??<O??<O??<O??<O??<O??<O??<O?? O?? O?? O?? O?? G?? C?? @@@@@@@@') ; yourself); yourself]
!

fileIn24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileIn24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#fileIn24x24Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class fileIn24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A&Y&Y&XF@@@@@@@@A#L2Y&XF@@A&Y X@A#L2Y&XF@AA&Y D@A"H"Y&XF@AA&Y DCA&I&Y&XF@AA&Y DC
M&I%URXF@A@@@3L3L6I%URXF@ADQD3L3L3H"H"XF@AD@@3L3L6I&Y&XF@AD@Y DCM&I$QBXF@AD@Y DCA&I$QBXF@@@@@@@@A&H"H"XF@@@@X@@@A&Y&Y&XF
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 129 129 129 63 63 36 255 0 0 194 194 0 0 127 0 194 194 194 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@?>@@?>_>?>_>?>_>?>_??>_??>_??>_??>_??>_??>_??>O>?>@ ?>@@?>@@@@EPD@HP@@ISD0IT%H]W%HITEHISEH');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:51 / cg"
!

garbageCollect24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self garbageCollect24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#garbageCollect24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary garbageCollect24x24Icon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@ADQ@@@@@@@@@@@@@ADQDQ@@@K.;,QF1DQDQDQ@@B;.;.1.0@@DQDQ@@.;@@.;.1@@@ADQ@@.0@@F;.1@2@ADQ@@.0@@.;.1DCHADQ@K.;@@
DQDQDPL DQB0.0,@DQDP@@@0DQ,K@KB0DQ@BH"H@DQ@@@@@@DQ@P@@@0DP@@@@8N@@@QDSL0D@@@C.;.8@@PL3@ @@@@@NC @@@PLC@ @@@@;.;.@@@PLC@J
@@@@C 8@@@@PLC@ @@B (@@AD@@PLC@ @J*** CA0@@PLC@ @@(J@L3L3@@PLC@ B***(@0L@Q@SLCL @JB CL3L0Q@CH"H@@ADQDLCADQDP@@@Q@ADQD@@@
@QD@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@O"@@_6@@8>8@0^<@0>^A8@OB4A?EJG?@@G?@EG?@_''?@JG?@?G?@TG?B G?O2''?EO7?_%G?J_''?@JA<@@@@@@@@') ; yourself); yourself]
!

historyBackInTextIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self historyBackInTextIcon inspect
     ImageEditor openOnClass:self andSelector:#historyBackInTextIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary historyBackInTextIcon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
%IRT%IRT%@@@@@@@@@AO$$>T%IRT%IRT%@@@@@@@@@@@@@@@@@@@@@@@@@@@@IRT%)X@@@@@@@@@@@@@@@@@%)ZV%P@@@IVV%)ZX&I"X&I"X&I"X&I"X&I"X
&I @@IVV%)ZX&IVV%)ZU%P@@@@@@%YZV%Y @@IVV%)ZX&I"X&I"X&@@@@@@@@@@@@I @@IVV%)ZX&IVV%)X@@@BI@@@@@@@@@I"U@IVV%)ZX&IVV@@@@@@@@
@@@@@E0K@I"U@@BV%)ZX&I"X&I"X&@@@@@@@S 8F!!Y"U@@BV%)ZX&@@@@@@@@@@@@H4#D''4@!!XAO@@AO%YVX&@@@@@@@@@@@#P8]"X8@@@@@@@BD%YVX&I"X
&I"X&H=<@3^N^(:N]7]7[0B@%T>X&@@@@@@@@@A4@0(6[6<,H!!(5ZPB@%P"X&@@@@@@@@@@@!! 4DE6<@@@@@AQF@%P"X&I"X&I"X&@@@@H \@ 0@ HB@ HB@
%W&X&@@@@@@@@@@@@@BOPPD@ I @@@AO%PBX&AAYX@@@@@@@@@@@$%0K I (@@AO%PBX&I"X&I"X&@@@@@@@@D)JQ9!!D@D=O%@BX&D=OS4=O@@@@@@@@@D=O
S9!!O@D=O%@BX&IQOS4=OQ @@@@@@@D=OS9!!O@D=O%@BX&I"X&I"X&I"X&I"X&I"X&I!!O@IIO%@@@%IRT%D=OS4=OS4=O$$>T%@@@@IRT%IP@@@@@@@@@@@@@
@@@@@@@@@@@@@IRT%IRT%IRT%IRTS4=OS4=O$$>T%IRT%IRT')
            colorMapFromArray:#[0 146 0 0 150 0 0 158 0 8 150 8 8 170 8 16 150 16 16 154 16 24 154 24 24 158 24 24 162 24 24 182 24 33 154 33 33 211 24 41 158 41 41 162 41 41 166 41 41 174 41 49 162 49 49 166 49 57 166 57 57 199 49 66 178 57 66 190 57 66 227 57 74 199 66 74 203 66 74 227 74 74 231 66 82 174 82 82 182 74 82 190 74 82 203 66 82 207 74 82 215 74 82 231 82 90 182 90 90 207 82 90 211 74 90 211 82 90 215 74 90 215 82 90 223 82 90 227 82 90 231 82 90 235 82 90 235 90 99 211 90 99 215 82 99 215 90 99 219 82 99 219 90 99 223 82 99 223 90 99 227 99 99 235 90 107 195 99 107 211 99 107 223 90 107 227 90 107 235 90 107 235 99 107 235 107 107 239 90 107 239 99 115 142 222 115 186 107 115 211 99 115 227 99 115 235 99 115 235 107 115 239 99 115 239 107 123 190 123 123 195 123 123 239 107 123 239 115 123 239 123 123 243 107 132 199 132 132 239 107 132 239 123 132 243 107 132 243 115 132 243 123 132 247 123 140 203 140 140 215 132 140 243 115 140 243 123 140 243 132 140 247 115 140 247 123 148 199 148 148 243 123 148 243 132 148 247 123 148 247 132 148 251 123 148 251 132 156 203 156 156 243 132 156 243 140 156 251 123 156 251 132 165 251 140 165 251 156 173 170 156 173 215 173 173 235 156 173 251 148 173 251 156 173 251 165 181 239 165 181 251 156 181 251 165 181 251 173 189 215 181 189 247 173 189 251 173 189 255 173 189 255 181 198 223 198 198 251 173 198 255 181 206 227 206 206 243 181 206 255 189 214 207 206 214 211 214 214 255 189 214 255 198 222 219 214 222 219 222 222 223 222 222 227 214 222 227 222 222 231 214 222 251 206 222 255 198 222 255 206 231 227 231 231 239 231 231 255 214 239 235 231 239 235 239 239 243 239 247 239 239 247 239 247 247 243 239 247 243 247 247 247 247 255 255 255 127 127 127]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@G??0D@@PE<@PDA@PD@CPE<G0D@_0D@??E???DA??D@??E<_?D@O0D@G0E<@PD@@PD@@PG??0@@@@@@@@@@@@'); yourself); yourself]
!

imageEditor24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageEditor24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#imageEditor24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class imageEditor24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@JB A7\3LQE&Y&XFXJB A7\3LQE&Y&XFXJB A7\3LQE&Y&XFX@@@BY&H!!DQ&Y&XFX@@@BY&H!!DQ&
Y&XFX@@@BY&H!!DQ&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@BY&H!!DQ&Y&XFXI* BY&H!!DQ&Y&XFX@@@BY&H!!DQ&Y&XFX@(@
A7\3LQE&Y&XFX@(@A7\3LQE&Y&XFX@(@A7\3LQE&Y&XFXI& BY&H!!DQ&Y&XFXI* BY&H!!DQ&Y&XFXI* @@@@@@@@@@@@@I* @@@@@@@@@@@@@I& @@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 255 0 127 127 0 255 0 0 255 255 127 127 127 170 170 170 255 0 0 255 0 255 255 255 0 100 100 100 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>N??>N??>N??>D??>D??>D??>D??>D??>D??>N??>_??>_??>N??>N??>N??>_??>_??>_??>_@@@_@@@N@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:45 / cg"
!

installAsWebPage24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self installAsWebPage24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#installAsWebPage24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class installAsWebPage24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"H"H"H"H"H@BYBP@%UUUUUUUU$@BYBP@%UUUUUUUU$@BYBP@%UUUUUUUU$@@@@@@%UU.;.5UU$@@@@@@%U[.;.;
UU$@@@@@@%V;.;.;-U$@@@@@@%.*.;**.5$@@@@@@%.**;.**5$@@@@@@%.**;***5$@@@@@@%.:*;***5$@@H&P@%.:*;**.5$@@@@@@%V;.;*+-U$@@@$@
@%U[.;.;UU$@@@$@@%UU.;.5UU$@@@$@@%UUUUUUUU$@@H"P@%UUUUUUUU$@@H&P@%UUUUUUUU$@@H&P@%UUUUUUUU$@@H&P@)&Y&Y&Y&Y$@@H"P@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 200 200 0 0 127 127 191 191 191 255 0 0 240 240 0 255 255 0 100 100 100 0 255 0 0 0 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@??>@??>N??>N??>N??>D??>D??>D??>D??>D??>D??>N??>_??>_??>N??>N??>N??>_??>_??>_??>_??>_??>N@@@@');
                            yourself);
                yourself
        ]
!

left2Arrow24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self left2Arrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#left2Arrow24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary left2Arrow24x24Icon'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@P@@@@@@@@@@@@@@@@@@@@@@@@@A@ @A@ @@@@@@
@@@@@@@@@@@@@@@@@@DC@PDC@P@@@@@@@@@@@@@@@@@@@@@@@PPE@PPE@ @@@@@@@@@@@@@@@@@@@@@AA @AA @G@P@@@@@@@@@@@@@@@@@@@@DH@@DH@@$J
@ ,C@0DA@P,@@@@@@@@@@P0@@P0@@@4NC1@@@@@Q@1H@@@@@@@@AA @AA @@D1PUC!!@QDQXWA1H@@@@@@@DDDPDDDQDSEATUEP8XBQLYB!!H@@@@@@@,JE@,J
EA,\EATUEQ4]GQ4]B!!H@@@@@@@@RB!!PRB!!P^GAPTF1<_G1, B!!H@@@@@@@@@D (ND (NG2@]GP(JB (JHP,@@@@@@@@@@AHJC!!HJC!!8J@QHRD!!HRD ,@@@@@
@@@@@@@RB!!4RB!!4"@ @@@@@@@@@@@@@@@@@@@@@@D (!!D (!!@P@@@@@@@@@@@@@@@@@@@@@@@@,A@ ,A@ @@@@@@@@@@@@@@@@@@@@@@@@@K@P@K@P@@@@@@
@@@@@@@@@@@@@@@@@@@@B0@@B0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[224 224 224 0 32 64 0 32 96 32 64 96 96 128 160 64 96 128 128 160 192 32 96 128 128 160 160 160 192 224 0 96 128 0 0 0 128 128 160 64 192 192 32 160 192 64 128 192 128 192 224 192 224 224 0 0 32 96 192 224 0 160 192 0 128 192 160 224 224 96 160 192 128 192 192 64 160 192 192 192 192 32 192 192 0 192 224 0 128 160 32 192 224 64 192 224 0 192 192 0 64 96 0 64 128]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@D @@M @@_ @@? @A? @C??0G??0O??0_??0_??0O??0G??0C??0A? @@? @@_ @@M @@D @@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

leftArrow24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self leftArrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#leftArrow24x24Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class leftArrow24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PH@@@@@@@@@
@@@@@@@@@@@@@@@@@@@A@0D@@@@@@@@@@@@@@@@@@@@@@@@@@@DDAPH@@@@@@@@@@@@@@@@@@@@@@@@@@PX@A0D@@@@@@@@@@@@@@@@@@@@@@@@AB@@IB HK
@0LA@PDK@@@@@@@@@@@@@@DL@@@MC <P@@@@DPLR@@@@@@@@@@@@@PX@@ALTEP8PDQDVE0\R@@@@@@@@@@@AAADQD1PUEQTNF@$SFP(R@@@@@@@@@@@KB!!P[
GAPUEQT]GQ4]GP(R@@@@@@@@@@@@D (TG!!0TEA,_G1<[H@(R@@@@@@@@@@@@@AHJC!!< GQ4JB (JB"DK@@@@@@@@@@@@@@@RB 8^B DRD!!HRD!!HK@@@@@@@@
@@@@@@@@D (]H H@@@@@@@@@@@@@@@@@@@@@@@@@@AHJHPD@@@@@@@@@@@@@@@@@@@@@@@@@@@@K@PH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B0D@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 224 224 224 0 32 64 0 32 96 32 64 96 96 128 160 64 96 128 128 160 192 32 96 128 128 160 160 160 192 224 0 96 128 0 0 0 128 128 160 64 192 192 32 160 192 64 128 192 128 192 224 192 224 224 0 0 32 96 192 224 0 160 192 0 128 192 160 224 224 96 160 192 128 192 192 64 160 192 192 192 192 32 192 192 0 192 224 0 128 160 32 192 224 64 192 224 0 192 192 0 64 96 0 64 128 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@B@@@F@@@N@@@^@@@>@@A??@C??@G??@O??@O??@G??@C??@A??@@>@@@^@@@N@@@F@@@B@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:42 / cg"
!

leftArrow24x24disabledIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self leftArrow24x24disabledIcon inspect
     ImageEditor openOnClass:self andSelector:#leftArrow24x24disabledIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class leftArrow24x24disabledIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PH@@@@@@@@@
@@@@@@@@@@@@@@@@@@@A@0D@@@@@@@@@@@@@@@@@@@@@@@@@@@DDAPH@@@@@@@@@@@@@@@@@@@@@@@@@@PX@A0D@@@@@@@@@@@@@@@@@@@@@@@@AB@@IB HK
@0LA@PDK@@@@@@@@@@@@@@DL@@@FCP8O@@@@D@LQ@@@@@@@@@@@@@PX@@AHND04ODA@TEP\Q@@@@@@@@@@@AAA@PD 8SD1LME $RE0(Q@@@@@@@@@@@KB 8U
F@8SD1LYFQ$YFP(Q@@@@@@@@@@@@DP(NF!! NC!!T[F1,UE0(Q@@@@@@@@@@@@@ADJCQ,WFQ$JB (JB!!0K@@@@@@@@@@@@@@@QB 4ZB DQDQDQDQDK@@@@@@@@
@@@@@@@@DP(YGPH@@@@@@@@@@@@@@@@@@@@@@@@@@ADJG@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@K@PH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B0D@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 224 224 224 25 25 25 28 28 28 57 57 57 121 121 121 89 89 89 153 153 153 80 80 80 150 150 150 185 185 185 70 70 70 0 0 0 131 131 131 124 124 124 115 115 115 176 176 176 214 214 214 3 3 3 166 166 166 96 96 96 204 204 204 144 144 144 172 172 172 134 134 134 137 137 137 92 92 92 147 147 147 156 156 156 48 48 48 51 51 51 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@B@@@F@@@N@@@^@@@>@@A??@C??@G??@O??@O??@G??@C??@A??@@>@@@^@@@N@@@F@@@B@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

lint24x24Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lint24x24Icon1 inspect
     ImageEditor openOnClass:self andSelector:#lint24x24Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary lint24x24Icon1'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
??????????????????????????????????????????????????????????????????????????=_W?????>-@:7?????????????????????MF7???<4+_??
????????????????????+TW???<L?????????????????????????2AG?4HY????????????????????????K65[()A-!!????????????????:7?????[\W>
?/;0[XS???<ZR???????JZ6-??=-0?3<?O3<F&7??0*-??????????<GO:5-6-+Z6-+,9+U-A:4@????????????+PE-^G!!<>-262/O1[_??????????????
+V4PR4/I):+J+8+Q,_??????????+P(]I1,,N=7J;?W27-ZO>94NS4??????B @@[RH(PN2#9>+%5[:@8L>D????????????[Q<-S_BU6=/W3)Y:.]??????
????@@AEI1<>W^:$1,"2X6I(6]IP_@C?????+QHN[RL0U>&6&(-1Y6)(=:$@@D??????N @@[QUDXKO;(HM6^7M,<G @@@AO????????MB(2ZUZX>;.&*NG:
/:6D??????????<)+V4SXEY?2?S<>.Y-/;V-?????????1&-??=-RU)/]8JMT&7?@K>5#O???????:7?????[RX+NBX&[_????>:/;T@?????????????65-
[V5-????????6OF5????????????????????????????@MK?') ; colorMapFromArray:#[0 1 0 0 2 0 1 4 0 3 6 2 30 1 0 6 9 5 34 2 2 10 12 8 43 4 2 13 15 12 15 17 13 77 0 0 16 18 15 35 14 12 17 19 16 67 6 1 19 20 18 75 7 10 21 23 20 86 9 4 25 27 24 111 4 7 103 7 10 96 10 12 32 29 28 29 30 28 31 33 30 153 2 0 33 35 33 35 36 34 110 16 16 173 0 1 36 38 35 41 37 36 165 4 0 155 7 7 128 15 14 39 41 39 157 12 16 51 42 42 207 0 4 43 45 42 58 41 39 141 19 15 199 4 0 210 3 0 221 1 4 48 49 47 231 0 12 211 7 8 172 19 10 172 19 18 52 54 51 53 55 53 234 5 23 59 54 53 176 24 21 56 57 55 57 59 56 204 19 22 195 22 24 103 47 48 227 16 9 60 61 59 198 25 19 216 20 21 61 63 60 119 48 45 228 20 20 63 65 62 211 30 27 68 69 67 69 71 68 212 32 34 242 25 29 72 74 71 74 76 74 191 45 50 245 31 38 76 78 75 77 79 76 79 80 78 138 66 66 248 36 40 240 41 43 83 85 82 216 50 52 241 43 50 195 58 61 86 88 85 244 46 46 87 89 86 89 91 88 214 58 58 193 65 67 92 93 91 248 51 49 109 90 87 185 68 87 194 67 80 87 95 125 250 54 57 173 74 96 202 67 84 159 78 103 253 56 52 188 72 90 87 99 135 129 89 121 99 101 98 73 104 148 255 59 60 159 83 106 175 81 94 94 102 132 187 78 98 215 71 85 255 61 67 169 84 104 251 66 66 104 106 103 90 106 147 151 92 119 200 81 93 107 108 106 140 99 131 162 94 119 255 72 76 144 100 128 96 112 153 228 80 83 159 97 120 111 113 110 191 90 111 206 87 104 113 115 112 87 118 163 115 117 114 83 122 166 179 100 117 118 120 117 199 99 101 231 91 88 138 113 147 120 122 119 196 101 119 123 125 122 115 123 167 213 100 113 119 123 162 180 109 128 127 129 126 208 108 109 115 131 173 185 115 140 158 122 154 173 119 144 131 133 130 130 130 163 178 122 124 181 119 147 106 139 178 136 138 135 120 139 175 126 138 175 204 121 132 132 139 172 113 146 186 136 143 176 144 146 143 121 149 184 153 142 173 135 150 181 148 150 147 125 153 188 130 153 182 179 140 167 150 152 149 205 136 148 181 145 146 136 159 189 155 157 154 140 163 193 159 161 158 161 163 160 143 166 196 162 164 161 148 167 192 164 166 163 165 165 187 197 159 173 167 169 166 152 171 196 191 163 180 157 172 191 169 171 168 216 159 166 171 173 170 208 163 179 187 169 190 217 162 175 174 176 173 159 178 203 186 173 174 207 167 175 163 178 198 213 166 176 179 181 178 198 176 192 169 185 204 183 185 182 216 175 184 209 177 189 212 180 192 204 183 198 208 183 193 188 190 187 180 192 206 194 196 193 215 191 201 187 199 213 204 198 197 211 196 210 199 201 198 190 202 216 191 203 217 201 202 212 202 204 201 208 203 201 219 201 210 205 207 203 217 203 217 206 208 205 213 207 206 223 205 214 203 211 220 211 213 210 211 212 222 214 216 213 221 215 227 217 219 216 219 221 218 228 218 224 217 222 225 221 223 220 231 221 227 216 225 233 220 226 228 224 226 223 221 229 238 231 233 230 228 234 236 233 235 232 235 238 234 249 251 248 255 255 255]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@LN@@FL@@FH@@CX@@G<@BG>LGO>XA??0@?? @?? G??>D??8@??0A??<G??2D??1@??8A??8CO>\BG<N@C8G@@@B') ; yourself); yourself]
!

make24x24Icon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self make24x24Icon3 inspect
     ImageEditor openOnClass:self andSelector:#make24x24Icon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary make24x24Icon3'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@0PE@@@@@@@@@@@@@@@@@@@@@@@@@@XGB@HABP(@@@@@@@@@@@@@@@@@@@@@@@@@@@ KA00J
@@@@@@@@@@@@@@@@@@@@@@@@@@@MC  OD@@@@@@@@@@@@@@@@@@@@@@@@@@CBADBA!!H@@@@@@@@@@@@@@@@@@@@@@@@S@ XOE@XO@@@@@@@@@@@@@@@@@@@@
@@PFC1PACAT@@@@@@@@@@@@@@@@@@@@@@@0O@00UD!!HTB @@@@@@@@@@@@@@@@@@BPLLCAT@@A@QE P@@@@@@@@@@@@@@@@WE@L@@@@@@@$XC1$L@@@@@@@@
@@@@F TAEP@@@@@@@@@CFAL@@@@@@@@@@@@[GA4R@@@@@@@@@@@@G @@@@@@@@@@@A0\F1,\@@@@@@@@@@@@@@@@@@@@@@@_F"@[F1<@@@@@@@@@@@@@@@@@
@@@@@A<ZF1,[G0@@@@@@@@@@@@@@@@@@@@@@@A0[F1,_@@@@@@@@@@@@@@@@@@@@@@@@GB@[F1<@@@@@@@@@@@@@@@@@@@@@@@@ HA,[G0@@@@@@@@@@@@@@
@@@@@@@@GBD F1,_@@@@@@@@@@@@@@@@@@@@@@@@HR@[F1<@@@@@@@@@@@@@@@@@@@@@@@@@@A,[G2H@@@@@@@@@@@@@@@@@@@@@@@@@@@@_H @@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 248 250 160 152 140 192 184 180 160 152 160 128 120 130 112 112 100 176 176 180 192 192 200 208 200 200 128 120 120 96 88 90 224 216 220 144 144 140 208 200 210 224 208 210 176 168 170 96 96 100 192 192 180 128 128 130 176 160 170 160 160 160 144 136 140 224 224 220 112 112 120 112 104 100 240 232 240 48 48 50 32 32 40 48 40 40 64 64 60 160 160 170 32 32 20 48 32 40 48 40 50 16 8 10]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@C8@@C>@@@_@@@O @@O0@@O8@@_0@@_<@@>^@A0_@G N@O@D@_@@A>@@C<@@C8@@G0@@O @@?@@@>@@@^@@@L@@@@@@@') ; yourself); yourself]
!

menuEditor24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuEditor24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#menuEditor24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class menuEditor24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GA0@QDQDQDQDQ@@@GA0@RH"H"H"H"TEAWA0@R\"H"H''H"TEAP@@@R]7\"]7\"TEAP@@@RH"H"H"
H"TEAP@@@P@@@@@@@@TEAP@@@QDQDQDQDQTEAP@@@RH"H"H"H"TEAP@@@R\"I2H"H"TEAP@@@R]2I7\''\"TE@C]0@RH"H"H"H"TE@@@@@P@@@@@@@@TEAP\@
@QDQDQDQDQTEAP\@@RH"H"H"H"TEAP\@@R]2I7H'']2TE@CM0@RH"H"H"H"TE@C]0AUUUUUUUUUTE@C]0@@@@@@@@@@@@@C]0@@@@@@@@@@@@@CM0@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 255 0 0 127 127 127 127 127 255 0 0 100 100 100 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>N??>N??>N??>D??>D??>D??>D??>D??>D??>N??>_??>_??>N??>N??>N??>_??>_??>_??>_@@@_@@@N@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:40 / cg"
!

method24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self method24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#method24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary method24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
DQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQDQDQDQL"H"H"H"LQDQDQDQIDQDQDQCHQDQDQDQI@@@@@@AHQDQDQDQI@@@@@@AHQDQDQDQI@@@@@@AHQDQDQDQH1DQDQDQHQDQ
DQDQL"H"H"H"LQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQDQ');
                colorMapFromArray:#[ 223 32 32 127 127 127 64 64 64 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?? @?? @?? @?? @?? @?? @?? @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

methodFinder24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self methodFinder24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#methodFinder24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary methodFinder24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADEQPX
IR)P@@@@@@@@@@@@@@@@@@@@@A,''RE!!YUD@(H&\@@@@@@@@@@@@@@@@@J6&Q XFA XEUJQ!!''B (JB (9@@@@@@@,X%,KB0 C@ LGA TU_9FQ$S$J@@@@@DX?
 U,K[F1,[F1,[@X LV1,[AHJ@@@@@CMR\U,K[F1,[F1,[F0ED61,[AHJ@@@@@B1YVT8K[F1,[F1,[F0EE61,[AHJ@@@@@B1&R4LK[F1,[F1,[F0EGQHRD!!HJ
@@@@@B1YUTLK[F1,[F1,[F0EGP(JB (9@@@@@B5IVT4K[F1,[F1,[F0KE@@@@@@@@@@@@DT5VT4KB0,KB0,KB0-GF @@@@@@@@@@@@@_PD5MST9NS$9NS&,\
Y0@@@@@@@@@@@@@$G4%&Y&)1\WVE CH<@@@@@@@@@@BP %4#E!!<6T6Y1Z&MQL#4@@@@@@@@@@H>M#E0!!@@@%FQ8&MCH>U0@@@@@@@@@@#8:L[S(0@@@@@@@@
@@@@@@@@@@@@@@@@#(1-N2<@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 32 223 32 255 40 124 255 51 109 255 51 109 229 54 139 255 62 88 255 62 88 255 62 91 255 62 136 64 64 64 255 72 115 255 83 62 255 91 73 255 94 74 255 101 84 255 105 85 255 112 96 127 127 127 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 143 175 208 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 159 159 192 159 160 192 159 160 207 159 160 208 159 192 239 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 160 208 255 160 223 255 170 170 170 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 175 223 255 176 175 207 176 176 176 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 176 223 255 176 224 255 176 239 255 183 183 183 190 190 190 191 175 143 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 239 255 191 240 255 192 192 208 192 239 255 192 240 255 192 255 255 196 196 196 207 143 95 207 207 191 207 207 207 207 207 208 207 207 223 207 208 223 207 223 239 207 239 240 207 239 255 207 240 255 207 255 255 208 208 223 208 208 224 208 224 239 208 255 255 217 217 217 223 32 32 223 128 63 223 192 255 223 223 32 223 223 224 223 255 255 224 224 224 224 224 239 224 239 240 224 255 255 231 207 255 231 208 255 238 191 255 238 192 255 239 159 232 239 191 255 239 223 255 239 224 255 239 239 224 239 239 239 239 239 240 239 255 255 240 207 144 240 239 223 240 240 239 240 255 255 246 176 255 247 175 255 247 207 255 247 239 255 254 160 255 254 191 255 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O8@@_>@@???A???C???C???C???C???C???C?? C?? A?? A??@O?>@_O<@?@@@>@@@');
                            yourself);
                yourself
        ]
!

newClassWizardIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newClassWizardIcon inspect
     ImageEditor openOnClass:self andSelector:#newClassWizardIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class newClassWizardIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@8B@ HB@ HB@ HB@ 8@@@@@@@@@@@@@@@H:^''):^''):^''):S H@@@@@@@@@@@@@@@H:PXFA XFA XFA!!8H@@@@@@@@@@@@@@@H:PXFA XFA XF
A!!91RF$@@@@@@@@@@@@H:PXFA ZB^G(FA&5/&38@@@@@@@@@@@@HNA8^G!!97,)EXT&KC%DL@@@@@@@@@@@@8B@ HB@!!9%.^-#;''#]V,@@@@@@@@@@@@@@@@@
@@B5V[C)9^S^V#\@@@@@@@@@@@@@@@@@@@@@TIO&7]_V)5\!!QP@@@@@@@@@@@@@@@@A-W;_!!5=SS6-F"O2 @@@@@@@@@@@@@@GM,7NO_5]OA&&)ILCT@@@@@
@@@@@@@@@D^]%WY +="IDC,V_P@@@@@@@@@@@@@@@F!!@PV\.X=Q.A0>DFP@@@@@@@@@@@@@@@@@@@@@@H*9VBP@Q 1L@@@@@@@@@@@@@@@@@@@@@P$P2$ 0@
D(D$@@@@@@@@@@@@@@@@@@@@@BL4@@@K@AP3I@@@@@@@@@@@@@@@@@@@@@@@@@@@I HXLRX@@@@@@@@@@@@@@@@@@@@@@@@@@BPBGR<1@@@@@@@@@@@@@@@@
@@@@@@@@@@@*@!!<W@@@@@@@@@@@@@@@@@@@@@@@@@@@@JPTJ');
                colorMapFromArray:#[ 0 0 0 3 3 3 4 4 4 4 8 8 11 16 17 12 12 12 32 223 32 33 4 8 64 64 64 67 27 35 69 69 69 75 80 80 80 93 92 90 19 2 94 95 110 107 120 120 109 13 19 109 107 107 111 110 110 111 115 115 112 112 112 116 117 116 120 76 87 120 120 120 121 121 121 121 132 132 122 120 120 122 122 122 125 57 47 125 125 125 127 127 127 133 133 133 140 70 60 144 32 17 145 28 14 158 75 75 158 158 158 159 36 2 159 159 159 160 34 3 161 79 79 161 161 161 162 162 162 163 59 29 163 63 34 164 164 164 165 76 76 166 166 166 167 46 5 167 167 167 168 46 6 168 168 168 169 89 89 169 91 91 169 171 171 170 86 86 170 170 170 171 79 75 173 90 77 173 125 137 173 173 173 174 85 83 175 49 40 176 68 12 177 50 40 177 67 67 177 111 111 179 70 70 180 72 11 180 117 117 180 180 180 181 26 10 181 28 13 181 80 16 181 179 180 181 186 191 183 70 49 183 88 19 184 69 48 184 186 186 185 55 55 185 183 184 186 56 56 190 50 30 190 52 32 190 104 94 191 87 23 192 94 18 193 37 20 193 38 17 193 88 18 193 108 101 194 81 72 194 85 77 195 165 162 196 67 35 196 92 19 196 144 142 197 68 34 197 99 19 197 147 144 198 80 57 198 81 55 198 128 128 199 96 93 199 102 100 200 105 21 202 136 136 203 82 39 203 107 107 203 109 25 204 83 37 204 85 46 204 102 102 205 88 47 205 104 103 205 172 171 207 111 32 208 116 34 210 44 27 210 44 29 211 86 86 211 93 93 211 138 29 214 83 58 215 201 202 216 87 60 216 142 31 216 183 183 217 217 217 218 66 59 218 218 218 218 225 224 219 65 39 220 134 134 220 140 140 220 188 188 221 141 25 222 168 168 223 32 32 223 157 52 223 170 170 223 223 32 224 136 74 224 160 53 225 125 88 225 214 215 226 139 77 226 165 73 226 167 74 227 133 95 227 143 29 228 151 118 228 157 124 229 149 33 229 159 68 230 185 185 232 162 71 232 187 187 237 201 113 239 203 111 239 236 236 240 177 48 240 190 95 241 154 38 241 192 97 242 195 195 242 200 38 243 203 45 243 236 237 244 202 202 244 212 212 244 215 215 245 211 166 246 182 50 246 204 39 246 215 174 246 218 162 247 202 143 247 224 224 247 226 163 247 228 228 247 241 241 248 224 165 248 233 233 249 228 166 249 230 230 249 244 244 249 245 245 250 228 195 250 247 247 251 232 48 251 239 239 252 215 48 252 249 249 253 245 165 253 247 247 253 249 249 253 251 251 253 252 252 253 253 253 254 229 48 254 233 48 254 247 200 254 248 202 254 253 253 254 254 254 255 214 57 255 233 52 255 239 67 255 240 51 255 241 49 255 242 70 255 245 68 255 246 68 255 246 122 255 248 62 255 248 94 255 249 62 255 249 93 255 249 166 255 251 176 255 252 111 255 253 112 255 254 171 255 254 180 255 255 171 255 255 174 255 255 180 255 255 214 255 255 216 255 255 251 255 255 253 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@O?8@O?8@O?8@O?>@O?>@O?>@O?>@@O>@@G? @O?0@_?0@_? @_? @@?0@@?8@@Y<@@@>@@@_@@@O@@@G');
                            yourself);
                yourself
        ]
!

newDataSet24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self newDataSet24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#newDataSet24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary newDataSet24x24Icon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QDPDQDADQ@@@@@@@RH D"HAH"TE@@@@@RH D"HAH"TE@@@@@RH D"HAH"TE@@@@@RH D"HA
H"TE@@@@@P@@@@@@@@TE@@@@@QDPDQDADQTE@@@@@RH D"HAH"TE@@@@@RH D"HAH"TE@@@@@RH D"HAH"TE@@@@@RH D"HAH"TE@@@@@P@@@@@@@@TE@@@@
@QDPDQDADQLE@0@C@RH D"HAH"T5@0@0@RH D"HAH"TC@0L@@RH D"HAH"TEL3@@@RH D"HAH"L3L3L3AUUPUUTEUUT@L3@@@@@@@@@@@@@C@0L@@@@@@@@@
@@@0@0@0@@@@@@@@@@L@@0@C') ; colorMapFromArray:#[0 0 0 255 255 255 170 170 170 255 255 0 0 127 127 127 127 127]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>Q??>R???T??>8??????>8???T@@BR@@DQ') ; yourself); yourself]
!

newFileBrowser24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self newFileBrowser24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#newFileBrowser24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary newFileBrowser24x24Icon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@DQ@@@@@@@@@@@@@ADAD@@@3@Y&Y&Y&@QDADP@@3@X@@@@@@P@@@P@@3@XN;.;.@QDADP@@3@XN; @@@ADAD@@@3@XN;J
=/[0DQ@@@@3@X@; [6=/@@@@@@3@XAC =/@@A/@@@@3@X@D@[6A/C6@@@@3@X@@P=/[6=/@@@@3@X@@@[6=/[6@@@@3@XO@@=/[6=/@@@@3@XF<@@@@@@@@@
@@3@XOX@@@@@@@@@@@3@XF=/[6<F@@@@@@3@XO[6=/XF@@@@@@3@X@@@@@@F@@@@@@3@Y&Y&Y&Y&@@@@@@C@Y&Y&Y&Y&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@8@@A<O??>O???O???O???O??>O??<O??<O??<O??<O??<O??<O??<O??<O?? O?? O?? O?? O?? G?? C?? @@@@@@@@') ; yourself); yourself]
!

newImage24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newImage24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#newImage24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class newImage24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@BY&H!!DQ&Y&XFX@@@BY&H!!DQ&
Y&XFX@@@BY&H!!DQ&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@A7\3LQE&Y&XFX@@@BY&H!!DQ&Y&XFX@@@BY&H!!DQ&Y&XFX@@@BY&H!!DQ&Y&XFX@@@
A7\3LQE&Y&$FZP@IA7\3LQE&Y&ZVZPBPA7\3LQE&Y&XIBP$@BY&H!!DQ&Y&XF&Y@@BY&H!!DQ&Y&&Y&Y&Y@@@@@@@@@@@@&Y@@@@@@@@@@@@@IBP$@@@@@@@@@
@@BPBPBP@@@@@@@@@@$@BP@I');
                colorMapFromArray:#[ 0 0 0 0 0 255 0 127 127 0 255 0 0 255 255 127 127 127 170 170 170 255 0 0 255 0 255 255 255 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>Q??>R???T??>8??????>8@@AT@@BR@@DQ');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:31 / cg"
!

newMenu24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self newMenu24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#newMenu24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary newMenu24x24Icon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QDQDQDQDQ@@@@@@@RH"H"H"H"TE@@@@@R\"H"H''H"TE@@@@@R]7\"]7\"TE@@@@@RH"H"H"
H"TE@@@@@P@@@@@@@@TE@@@@@QDQDQDQDQTE@@@@@RH"H"H"H"TE@@@@@R\"I2H"H"TE@@@@@R]2I7\''\"TE@@@@@RH"H"H"H"TE@@@@@P@@@@@@@@TE@@@@
@QDQDQDQDQLE@0@C@RH"H"H"H"T5@0@0@R]2I7H'']2TC@0L@@RH"H"H"H"TEL3@@AUUUUUUUUUL3L3L3@@@@@@@@@@@@L3@@@@@@@@@@@@@C@0L@@@@@@@@@
@@@0@0@0@@@@@@@@@@L@@0@C') ; colorMapFromArray:#[0 0 0 255 255 255 170 170 170 255 255 0 0 127 127 127 127 127 255 0 0 100 100 100]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>Q??>R???T??>8??????>8@@AT@@BR@@DQ') ; yourself); yourself]
!

newSystemBrowser24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self newSystemBrowser24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#newSystemBrowser24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary newSystemBrowser24x24Icon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y&@@@@@@@@@@@@@FXFX@@FY&Y&Y#@@A&XFY @FQDQDQB@@A @@A @FQDQDQB@@A&XFY @CH"H"H"@@@FXFX@@@@@@@@@
@@@@Y&@@@@@@H@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@@A&Y&Y&X0@@@@XBH"A!!DQDQD @@@@@@@@@2H"H"HJ
@@@@H@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@@A&Y&Y&X0@@@@XBH"A%UUUUT @@@@@@@@@2H"H"H @@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 255 0 127 127 127 170 170 170 255 0 0 255 255 0 255 255 255]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@8@@A<_?#>_?''?_?''?_?''?_?#>_?!!<@ @8@ @@@ @@@ ??A0??A???A0??@ ??@ @@@ ??A0??A???A0??@@??@@@@@@@@') ; yourself); yourself]
!

newWindowSpec24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self newWindowSpec24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#newWindowSpec24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class newWindowSpec24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADQDQDQDQDP@@@@@@@@@@@@@@@@@@@@@AUUUT UUUUH@@@@@AUUUT TQTUH@@@@@APTQT UU
UUH@@@@@AUUUT TQDUH@@@@@APTQT UUUUH@@@@@AUUUT TUDUH@@@@@APTQT UUUUH@@@@@AUUUT UUUUH@@@@@AUUUT T"H%H@@@@@AUUUT T"H%H@@@@@
AUUUT T"H%X@A @FARH"T T"H%I A A ARH"T T"H%HFA X@AUUUT UUUUH@Y&@@@"H"H H"H"Y&Y&Y&@@@@@@@@@@@@Y&@@@@@@@@@@@@@FA X@@@@@@@@@
@@A A A @@@@@@@@@@X@A @F');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 200 200 0 0 127 127 127 127 127 255 255 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>@??>Q??>R???T??>8??????>8@@AT@@BR@@DQ');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:22 / cg"
!

new_24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self new_24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#new_24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class new_24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@
@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@@@@@@@@@@@@FX@@@
@@@@@@@@@@$FZP@I@@@@@@@@@@BVZPBP@@@@@@@@@@@IBP$@@@@@@@@@@@@F&Y@@@@@@@@@@@@&Y&Y&Y@@@@@@@@@@@@&Y@@@@@@@@@@@@@IBP$@@@@@@@@@
@@BPBPBP@@@@@@@@@@$@BP@I');
                colorMapFromArray:#[ 0 0 0 0 0 255 0 127 127 0 255 0 0 255 255 127 127 127 170 170 170 255 0 0 255 0 255 255 255 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DQ@@BR@@AT@@@8@@G?@@@8@@AT@@BR@@DQ');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:20 / cg"
!

packageIn24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self packageIn24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#packageIn24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary packageIn24x24Icon'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT,KB0,KAE]IRT%IRT%IRT%IRT%IRT%IRT,KB0,KAE]IRT
%IRT%IRT%IRT%IRT%IRT,KB0,KAEA)RT%IRT%IRT%IRT%IRT%IRT,K@),KAE]IRT%IRT%IRT%IRT%IRTDV(S LT:1\VG!!2Y.%IRT%IRT%IRT%IRT%E(WZC^3
IBPTL"JT%IRT%IRT%IRT%IRT%IR:AP!!;J>Q8;YRT%IRT%IRT%IRT%IRT%IRT8Q&Y-(= %IRT%IRT%IRT%IRT%IP]UJ\#H6P-#W+''9=+Z^Z@!!%IRT%IRTKD$3
5:0*9>]MN^_''#$_'')M[(,YRT%IQ7 X"#Y*F;T)(*J._''93?I_>[B2)RT%IPA+\ =FFDJE)\1%]9V:7D''''HS"]YRT%IP ]) \C^UKO+2/"($DM%6EP@CN.YRT
%IP<*AJ))-%NW11O9[V]$6J.853\)YRT%IR705]01IZ+X$Z*Z72QK2 ZK-MD%IRT%IRTMLE2''+5''6D@K_VVLU>%^ 63*%IRT%IRTP66_[^CK$L3ME]H00DFB
TQ=Y%IRT%IRT,.0I;N3_;M<N60M,Z]CF7V>R%IRT%IRTRCU3R$*>SMSG@ <;T; [A:JT%IRT%IRT%I.4TE,8"4IX_!!9UCL>F%IRT%IRT%IRT%IRT@PD%IRWU
/6LP4YRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT') ; colorMapFromArray:#[220 170 60 238 212 149 215 159 53 206 154 55 248 206 99 145 207 140 177 181 168 126 115 98 128 218 120 222 166 61 249 212 116 225 175 64 158 109 29 251 206 88 219 165 60 215 159 52 128 116 97 174 193 173 241 194 77 129 218 121 98 209 89 157 116 45 249 211 118 142 222 137 252 212 110 125 216 119 216 165 58 153 106 27 250 204 86 240 229 207 213 155 51 167 115 31 228 184 77 235 193 90 157 180 156 187 145 62 89 208 81 193 187 180 121 207 115 247 203 93 219 169 60 86 207 77 167 126 53 122 217 115 236 227 207 132 193 128 169 124 40 227 178 66 156 111 33 245 211 123 107 212 99 216 166 74 177 131 52 215 160 56 246 203 92 115 214 108 213 157 53 163 184 162 91 208 83 165 113 30 227 180 69 253 212 106 253 209 92 252 210 102 224 174 63 177 125 36 215 158 52 207 155 59 167 122 45 72 176 65 233 184 71 92 57 7 196 143 49 215 173 93 218 161 56 253 209 91 217 159 54 177 194 176 247 201 83 250 205 87 203 148 50 167 116 32 232 212 151 163 112 30 212 174 102 161 110 29 254 213 105 222 172 62 214 157 52 151 108 38 177 196 177 208 153 51 215 164 57 238 191 79 167 122 39 248 202 84 159 181 158 251 212 112 231 182 69 184 133 47 175 194 174 144 103 39 244 210 125 220 169 60 136 220 131 176 124 36 142 206 138 233 187 78 178 128 37 225 170 65 154 177 153 161 112 30 223 173 63 249 207 98 179 134 49 217 161 56 169 178 167 208 159 56 246 200 83 241 226 190 126 209 120 112 73 12 159 181 157 125 217 118 157 117 51 219 174 76 214 156 51 245 201 92 122 216 115 243 205 111 173 122 34 176 126 37 234 186 75 233 185 72 127 115 97 92 207 83 247 211 119 219 181 98 254 211 98 214 158 53 175 137 64 129 200 123 53 32 3 117 215 110 207 156 58 195 156 74 128 98 47 240 194 81 0 0 0 243 210 129 227 177 66 246 211 122 249 203 85 119 214 112 240 201 102 165 145 115 239 193 82 238 198 99 199 151 53 225 171 65 170 128 44 243 210 128 195 195 195 246 211 121 245 202 95 221 199 159 244 198 80 208 160 72 239 191 75 242 195 78 234 186 71 229 180 68 197 151 65 251 208 99 227 177 65 254 211 95 85 206 76 236 217 172 206 151 55 99 210 90 169 134 80 196 158 81 116 214 109 214 181 116 159 110 29 201 150 51 177 197 177 242 213 143 254 211 94 214 164 58 217 160 55 167 129 71 170 121 36 177 132 49 231 183 73 203 155 55 226 176 65 92 208 83 166 115 31 216 159 53 254 212 104 250 208 100 210 167 74 217 164 62 175 129 46 166 120 42 212 161 56 130 93 31 168 118 32 194 194 194 155 111 39 162 116 35 216 159 54 168 156 140 250 208 99 206 158 69 221 171 61 245 199 81 69 43 5 208 156 56 196 148 52 164 113 30 241 212 143 221 166 60 224 170 65 177 197 175 223 174 64 219 168 59 119 215 112 252 207 89 241 196 87 131 91 25 239 196 90 196 148 50 160 116 42 253 211 103 221 166 61 158 181 156]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@G<@@G<@@G<@@G<@@??@@_>@@O<@@G8@A??8G??<O??<O??<O??<O??<O??8G??8G??8G??8G??0C??@@?<@@@@@') ; yourself); yourself]
!

packageOpen24x24Icon
    <resource:#programImage>
    ^ self packageOpen24x24Icon2
!

packageOpen24x24Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self packageOpen24x24Icon1 inspect
     ImageEditor openOnClass:self andSelector:#packageOpen24x24Icon1
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class packageOpen24x24Icon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@OB (JB (JB (J
B (JB @@@@@@@@@@@@<JA XFA XFA XFA LHC@@@@@@@@@@@C1,FA XFA XFA XFA XIE0(@@@@@@@@[B XFA XFA XFA XFA@T^GA J@@@@@AHJA XFA XF
A XFA XBA1(_GQ0J@@@@EQ4F@PXFA XFA XFA XEF2$#G (@@@@UC2@ HB@_G!!<_GQ<_G14/L"0 B @@@@@OK2<,KB,+J2$)JR$)GP(%MB<JB @@@@<0MST3
L3L0LB</K20$EQ(JJ0(PB @@@@<OCP4MCP0LC@0JB (JFQ LB 8TB @@@@@@B!!(ZF!!(ZF!!(ZF!!(ZFQ PC!!@TB @@@@@@C14^G!!8]GQ4]GA,[F1$VEQTTB @@
@@@@DA8_G!!8\GA0\GA0\F1$VEQTTB @@@@@@D!!8!!HQ<_G1<]GA0\F1$VEQTTB @@@@@@D"D%IRT"H!!4]GQ4]GQ$VEQTJ@@@@@@@@D"\*JBX&I!!8^G!!8^GQ$V
EQ@@@@@@@@@@D280J"(''I2@ HA8^GQ$VD@@@@@@@@@@@D3P4LS@-KR4%IBD!!H@,J@@@@@@@@@@@@DP,KB0,KB0,KB0,KB0,@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 24 40 4 56 100 4 60 110 24 86 40 36 60 80 44 44 40 48 70 50 88 46 10 108 56 10 108 58 10 112 58 0 116 60 10 124 66 10 124 72 20 132 74 20 132 76 20 140 78 20 140 82 30 144 82 20 144 86 30 148 92 40 152 96 40 152 98 40 160 104 50 164 106 50 172 116 60 180 124 70 180 128 70 188 132 70 192 140 80 196 140 80 196 142 80 196 150 90 200 154 90 204 148 90 204 150 90 204 158 90 204 162 100 208 158 100 208 166 100 212 156 90 212 170 110 216 162 100 216 164 110 216 174 110 216 178 120 220 170 120 220 182 120 220 186 130 224 184 140 228 190 150 228 200 160 244 224 200 ];
                mask:((ImageMask new)
                            width:24;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@O?<@_?<@??>A???C???G??>O??<O??<_??<_??<G??<G??<G??<G??<G??8G??0G?? G??@G?>@');
                            yourself);
                yourself
        ]
!

packageOpen24x24Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self packageOpen24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#packageOpen24x24Icon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class packageOpen24x24Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
TUEQTUEQTUEQTTR3TUEQTUEQTUEQTUEQTUEQTUEQTUEQ3;=MTUEQ63]QTUEQTUEQTUEQTUEQTUF3V#V@W%EQFXECTUEQTUEQTUEQTUEQ,08B\7>$%H9^V7M(
)%EQTUEQTUEQTPZ3W0<4\6"$/+6[Y6"L+MYQTUEQTUEQ/21K*@=[''\4;.:-5''V"XDJCITUEQTUEQG#GQ*A)&4+,0R-<<%QL\!!UW^"UEQTUEQT\,G)47F8K1V
$!!^/$70:*T#R5UMQTV(8Z%6CP@/T.<]#-;@#B$$T.YX.]4EQTUD8NV,3^!!^0E"H/[:LVX2JF4JGD&UEQTUEQ "Z.2+ZWOT*GJ&OSR)>RXLU0_V%6TUEQTXJ"
P+5WX)KB"6I;3):*7FE-VBBOTUEQTUER)W I[,!!.6,LECLA\Q%SLO%EQTUEQTUF=/P@X,U#CDZEEEV"P"A=NTUEQTUEQTUE5%*T@I[!!17R$RID_]\%PCTUEQ
TUEQTUDA!!XV5-[U>^]7]7P$I[P"4TUEQTUEQTUDADA@PDABJ-T^EXVE!!*R64TUEQTUEQTUFMGDIB]GR:DACA0YFQAI24TUEQTUEQTUEQSFWYZF U HAOS2"D
[M!!QTUEQTUEQTUEQTZ5YY6][)JRLJEA$&%EQTUEQTUEQTUEQTUDMJ0HO\94!!SI+WTUEQTUEQTUEQTUEQTUEQL#X]C40[&))QTUEQTUEQTUEQTUEQTUEQT[H?
I9*ZTUEQTUEQTUEQTUEQTUEQTUEQTUFZ&%EQTUEQTUEQTUEQ');
                colorMapFromArray:#[ 240 158 10 244 178 40 255 254 150 188 168 150 255 222 60 156 108 10 252 204 100 255 252 180 212 126 30 255 208 50 204 168 0 184 134 0 232 174 60 212 134 60 255 232 110 255 255 160 255 228 70 148 90 0 252 240 150 248 216 70 228 144 10 255 254 130 212 182 0 192 148 0 248 184 30 252 204 60 255 244 130 180 104 60 255 234 80 248 214 150 252 186 50 208 112 10 196 94 20 255 244 110 220 196 0 200 162 0 248 230 110 236 148 10 255 212 70 180 106 60 255 240 90 240 204 120 255 255 0 252 234 130 255 216 110 212 128 30 255 192 20 228 210 0 208 176 0 255 240 170 204 138 90 255 230 100 255 255 150 255 246 100 216 120 40 248 200 110 252 184 40 255 222 120 244 196 50 255 198 30 188 142 0 216 190 0 200 198 200 204 104 30 255 180 10 180 168 160 255 236 80 232 188 110 255 246 230 236 180 80 240 194 50 228 168 50 255 204 40 196 156 0 224 204 0 255 252 190 220 138 40 255 186 20 180 158 140 255 242 90 248 204 80 0 0 0 252 174 20 200 118 40 212 124 20 255 210 50 212 184 0 184 136 0 232 146 10 236 178 60 255 204 50 255 255 140 255 248 100 248 182 40 252 204 70 255 252 170 220 138 20 255 216 60 220 198 0 216 192 0 208 116 30 244 192 60 255 216 70 255 255 130 255 254 110 208 112 40 252 182 30 255 254 170 204 116 30 255 206 40 180 134 10 248 248 0 224 140 20 228 130 0 255 188 20 255 255 120 255 238 80 248 178 30 204 110 50 200 116 30 252 212 50 255 212 50 180 130 0 224 208 0 232 148 10 212 120 30 255 228 90 255 255 110 255 244 90 248 190 50 244 186 60 255 218 100 252 230 80 255 218 60 220 200 0 232 222 0 216 120 10 220 124 10 255 234 100 252 242 10 255 250 100 232 158 40 236 184 80 184 120 80 244 216 80 255 224 70 228 214 0 184 140 0 248 182 20 236 158 20 255 200 40 204 164 0 255 246 90 208 196 180 204 158 130 255 244 140 212 132 30 255 254 120 204 180 10 224 210 0 248 194 40 220 126 10 255 212 60 212 178 0 255 252 100 248 182 30 228 160 60 255 216 90 255 255 170 255 214 50 164 116 20 168 114 0 248 200 50 212 136 50 255 252 130 196 152 0 200 158 0 240 156 10 204 148 110 255 194 50 188 166 150 255 220 60 180 134 0 232 226 0 224 130 0 252 206 50 255 242 110 204 166 0 208 172 0 248 176 20 252 174 10 255 190 40 252 250 100 255 226 70 236 232 0 152 96 0 208 108 10 220 128 10 255 190 20 212 180 0 216 192 10 224 140 30 252 180 20 255 196 50 188 104 40 255 238 90 228 220 0 252 216 140 224 148 30 255 255 190 255 196 30 220 194 0 192 146 0 232 144 10 228 150 40 176 124 100 180 96 50 255 244 100 156 98 0 252 196 90 240 182 40 212 114 10 255 202 40 188 140 0 200 160 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@C@@@GF@@O''@@?? C??0G??8G??<C??>_??>O??<G???C???A??<A??8A??8A??8A??8A??8@??0@_? @O?@@G>@@C8@@A @');
                            yourself);
                yourself
        ]
!

packageOut24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self packageOut24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#packageOut24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary packageOut24x24Icon'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(YN%XZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!)*NX9ZF!!(ZF
!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF$E%TO4*V!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZPO@!!:^%>#%(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!&>''[#</N3,// RF!!(ZF!!(ZF!!(ZF!!(ZF&!!,HVUAP
TEAPTAH.!!(ZF!!(ZF!!(ZF!!(ZF!!(ZFEC,;[F1Q!!XZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZFDCT@XVF%NHZF!!(ZF!!(ZF!!(ZF!!(YO@* ]EHIVB0.\JBH"/8-G!!(ZF!!(ZFN*0\
%H= ]:Z5HKB+.JI%R8^:Y(ZF!!(Y0G2T%_G1[\''UDCRMZ@Y.G([)WSXZF!!(XZ!!;Y1\WD%IRT*_CBX.U1''J3DG@8ZF!!(Y>_V^Q+0)@PEN6-(%FY1VCA2EBE8ZF
!!(ZSER.WA"ZR$)F/B)&HJ4E3E&''A#XZF!!(X6!!L@GWWNSPU]RSA"7\2FJ#I<4!!(ZF!!(ZFD1L>KV$!!K@\''.1$^0LE6BSN*!!(ZF!!(ZF,&I-X&I),*9U/P89Z &@
Z6,E!!(ZF!!(ZF]@18C@0LC@0L,)83)HE+,;QE!!(ZF!!(ZF+QEH,[DQ_7=?_7>3*Z@OIF"F!!(ZF!!(ZF!!$''B^[1XW%9^OS^ (G,$!!(ZF!!(ZF!!(ZF!!(ZF!!#H2L#IC
JVP$''XZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF') ; colorMapFromArray:#[84 202 80 240 202 100 212 174 100 208 160 60 156 180 160 152 108 40 244 198 80 224 174 60 128 218 120 176 126 40 252 208 90 72 180 60 220 166 60 100 144 90 156 112 40 152 106 30 68 174 60 216 160 60 120 208 120 176 132 50 68 164 60 240 192 80 220 168 60 200 150 50 156 118 50 144 104 40 240 212 150 144 206 140 216 166 70 188 146 60 176 138 60 244 206 110 64 168 60 220 170 60 68 44 10 72 130 70 128 116 100 248 212 120 244 200 80 224 176 60 56 34 0 168 130 70 244 212 120 240 194 80 220 172 60 200 152 50 156 178 150 100 210 90 240 212 140 236 186 80 192 188 180 180 128 40 168 122 50 84 204 80 216 182 120 212 156 50 176 182 170 156 112 30 236 228 210 88 208 80 144 208 140 216 156 50 180 134 50 116 214 110 252 210 90 232 182 70 212 162 60 168 156 140 156 172 120 128 98 50 248 206 100 236 194 90 216 162 60 164 146 120 116 216 110 244 202 100 232 188 80 212 168 70 176 194 180 240 230 210 92 208 80 72 176 70 236 186 70 255 212 90 120 214 110 168 120 40 76 186 70 232 184 70 212 158 50 124 216 120 164 174 80 244 214 140 248 208 100 228 176 70 216 158 50 120 216 110 168 126 50 84 200 70 224 170 70 128 200 120 184 134 50 132 92 30 236 218 170 248 204 90 196 196 200 216 164 60 172 122 40 168 116 30 84 206 80 224 172 70 136 220 130 176 196 180 240 226 190 252 212 110 232 212 150 228 178 70 208 152 60 180 188 130 168 122 40 60 154 60 224 166 60 204 148 50 124 218 120 132 94 30 244 210 130 248 200 80 228 184 80 216 160 50 172 122 30 168 118 30 76 188 70 232 186 70 204 156 60 168 178 170 0 0 0 252 208 100 240 198 100 220 182 100 216 166 60 172 128 40 168 124 40 220 200 160 132 194 130 196 152 70 176 198 180 252 204 90 248 202 80 228 180 70 208 158 70 164 184 160 160 182 160 244 196 80 255 214 110 196 158 80 176 194 170 252 210 100 64 164 60 196 194 190 208 154 60 164 116 40 160 110 30 244 202 90 92 58 10 128 210 120 176 124 40 76 180 70 72 178 60 144 222 140 208 160 70 164 112 30 160 116 40 60 152 50 216 174 90 196 144 50 176 130 50 252 206 90 64 166 60 220 162 60 208 156 60 164 114 30 160 112 30 68 172 60 255 212 100 196 156 70 52 32 0 252 212 100 240 196 90 220 174 80 208 154 50 156 116 50 108 212 100 112 74 10 224 172 60 196 148 50 168 134 80]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@A @@C0@@G8@@O<@@_>@@??@@G<@@G<@A??8G??<O??<O??<O??<O??<O??8G??8G??8G??8G??0C??@@_<@@@@@') ; yourself); yourself]
!

photoAreaIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self photoAreaIcon inspect
     ImageEditor openOnClass:self andSelector:#photoAreaIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class photoAreaIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
QTUEQTT@@@@@@@@@@@@@@@@@@@@@@@@@QTUEQTT@@@@@@@@@@@@@@@@@@@@@@@@@QTT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QTT@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@QTT@@C !!NC 8NC 8@@@@@@@@@@@@@@@@@@@@NQ]CP4L*@@@@@@@@@@@@@@@AI @@@@ACI!!P.JR$#JR$)JR$)JR$)JR$%I @@@@ACI#<.J2$#H2L#
H2L#H2L#H2$TI @@@@ACEATTA"L#H2LJB (JB"XJA",+I @@@@ACI!!TTDDH#IS8FJR$)JRX&IPX+I @@@@ACEATKH2L&B"$)IRD JR$)I (+I @@@@ACI#<T
D@X&J3(5CAX1MST)N"X+I @@@@ACI#<&DB$&HRPVLS01LSTUN"X+I @@@@ACB!!4JD@4&CQ(VOA8^KCDUN"X+I @@@@ACIR8JJ2$&JQ(NKC(1KCDUN"X+I @@
@@ACIP(\J3,&A#<<LP81LT@:A!!PFI @@@@ACMRT%A X:MR$0C 8NF#(!!MQPFI @@@@ACBST=A XFA#<)LC@0HS(?I XFI @@@@@[BR<)HRD!!HRD:N#(:N#(!!
N#(:I @@@@@[F1(ZF!!(ZF!!)CL#H2P4PZF!!)D@DUE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DUE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DUE@@@@@@@@@@@@@@@@
@@@@@@@@@DUEQTUE@@@@@@@@@@@@@@@@@@@@@@@@@DUEQTUE');
                colorMapFromArray:#[ 143 143 143 162 162 162 23 41 73 195 195 195 212 212 212 222 222 222 236 236 236 242 242 243 255 255 255 138 138 138 161 161 161 179 179 179 37 53 82 208 208 209 72 84 105 235 235 235 243 243 243 254 254 254 123 131 145 158 158 158 178 178 178 193 194 194 39 61 99 92 92 92 221 225 233 240 241 244 122 122 122 135 135 135 155 155 155 168 173 182 169 179 200 77 77 77 219 219 219 229 229 229 239 241 243 248 248 248 133 133 133 153 153 153 174 174 174 190 190 190 205 205 205 216 217 217 100 100 100 240 240 240 85 107 141 152 152 152 171 171 172 187 187 187 202 202 202 44 68 111 98 98 98 237 237 237 247 248 248 150 150 150 161 164 172 186 186 186 201 201 201 215 215 215 215 217 228 238 236 234 74 97 140 145 145 146 167 167 167 184 184 184 192 196 204 85 85 85 225 225 225 108 108 108 116 116 116 25 25 25 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'>@@@>@@@0@@@0@@@3?@@G??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??;@@@C@@@C@@@_@@@_');
                            yourself);
                yourself
        ]
!

photoIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self photoIcon inspect
     ImageEditor openOnClass:self andSelector:#photoIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class photoIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@C !!NC 8NC 8@@@@@@@@@@@@@@@@@@@@NQ]CP4L*@@@@@@@@@@@@@@@AI @@@@ACI!!P.JR$#JR$)JR$)JR$)JR$%I @@@@ACI#<.J2$#H2L#
H2L#H2L#H2$TI @@@@ACEATTA"L#H2LJB (JB"XJA",+I @@@@ACI!!TTDDH#IS8FJR$)JRX&IPX+I @@@@ACEATKH2L&B"$)IRD JR$)I (+I @@@@ACI#<T
D@X&J3(5CAX1MST)N"X+I @@@@ACI#<&DB$&HRPVLS01LSTUN"X+I @@@@ACB!!4JD@4&CQ(VOA8^KCDUN"X+I @@@@ACIR8JJ2$&JQ(NKC(1KCDUN"X+I @@
@@ACIP(\J3,&A#<<LP81LT@:A!!PFI @@@@ACMRT%A X:MR$0C 8NF#(!!MQPFI @@@@ACBST=A XFA#<)LC@0HS(?I XFI @@@@@[BR<)HRD!!HRD:N#(:N#(!!
N#(:I @@@@@[F1(ZF!!(ZF!!)CL#H2P4PZF!!)D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 143 143 143 162 162 162 23 41 73 195 195 195 212 212 212 222 222 222 236 236 236 242 242 243 255 255 255 138 138 138 161 161 161 179 179 179 37 53 82 208 208 209 72 84 105 235 235 235 243 243 243 254 254 254 123 131 145 158 158 158 178 178 178 193 194 194 39 61 99 92 92 92 221 225 233 240 241 244 122 122 122 135 135 135 155 155 155 168 173 182 169 179 200 77 77 77 219 219 219 229 229 229 239 241 243 248 248 248 133 133 133 153 153 153 174 174 174 190 190 190 205 205 205 216 217 217 100 100 100 240 240 240 85 107 141 152 152 152 171 171 172 187 187 187 202 202 202 44 68 111 98 98 98 237 237 237 247 248 248 150 150 150 161 164 172 186 186 186 201 201 201 215 215 215 215 217 228 238 236 234 74 97 140 145 145 146 167 167 167 184 184 184 192 196 204 85 85 85 225 225 225 108 108 108 116 116 116 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@C?@@G??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??8@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

redoXP24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redoXP24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#redoXP24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class redoXP24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A,WEEKUE5-@@@@@@@@@@@@@@@@@@@@@E0>D!!</HQ%@VF4@@@@@
@E!!BQ&L@@@@@W@HXHBT(KS@2F$U''@@@@@C-RT40@@@A(O1 [FA@OEB\.LR8FV0@@@C)MS4(@@@APDQ,X@%]"VTPPKB</CE,@@C%GRT(@@@@?F1,GV0@@@@AV
@2H.LP9[@@,8PT(@@F EF1-C@@@@@@@@X#8]J2<MV0(6M4(@@FDKF1-K@@@@@@@@@FT>GB -CP 4MT(@@FPGF1-H@@@@@@@@@@A&O!!,%J"\1L4(@@@@AF1,E
Z @@@@A)X&I!!VP@WIBX,K4(@@@ANE!!,OU@@@@FT?B0,KB0,UGBD%JT(@@@A[A1,[@V(@@EXQF1,[F1,[F1,^H4(@@@@@P1X[D4,@@E<DD1LSD1LSD1LSD4(@
@@@@W T[F0%U@@@@@@@@@@@@@@@@@@@@@@@@@D(QF1,BV @@@@@@@@@@@@@@@@@@@@@@@F,=E!!,X@%(@@@@@@@@@@@@@@@@@@@@@@@A @!! [F@IZ@@@@@@@@
@@@@@@@@@@@@@@@@V HXF05P@@@@@@@@@@@@@@@@@@@@@@@@@E(BDT!!+@@@@@@@@@@@@@@@@@@@@@@@@@@AZOF,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 1 55 156 1 58 159 1 62 163 1 64 165 1 65 166 1 68 169 1 69 170 1 71 172 1 74 174 1 74 175 1 75 176 1 78 179 1 79 180 1 81 182 1 82 182 1 84 185 1 86 187 1 87 188 1 88 189 1 90 191 1 92 193 1 93 194 1 97 198 1 98 199 1 100 201 1 101 201 1 102 203 1 103 204 1 104 205 1 105 206 1 106 207 1 109 210 1 110 211 1 111 212 1 112 213 1 114 215 1 115 216 1 116 217 1 118 219 1 119 219 1 119 220 1 120 221 1 123 223 1 123 224 1 126 226 1 127 227 1 128 228 1 129 229 1 129 230 1 130 231 1 135 236 1 138 240 1 140 242 1 143 245 1 149 251 1 153 255 3 154 255 6 79 179 13 82 179 15 76 172 16 64 158 16 66 161 16 67 162 16 70 164 16 75 169 20 160 255 23 78 172 31 79 166 31 80 167 31 81 168 33 82 171 34 164 255 46 87 167 54 171 255 61 98 171 61 99 171 61 99 172 68 176 255 76 110 176 85 181 255 91 122 180 91 123 181 99 186 255 102 174 242 106 134 185 120 145 189 120 145 190 120 146 190 121 146 191 135 156 194 150 168 196 150 168 198 151 169 198 151 169 199 165 180 201 165 180 203 180 192 205 180 192 207 180 192 208 181 193 208 195 203 212 195 203 213 195 204 212 196 205 213 210 214 216 210 214 217 210 215 217 225 226 219 226 228 222 226 228 223 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@A?@@C?0^G?8^O?<^O?>^O!!?^_@?>_@_>_@O>O!!?>O#?>O3?>G3?>G8@@C<@@C>@@A?@@@?@@@_@@@N@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

reload24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self reload24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#reload24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary reload24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
\GA0\GA0\GA0\GA0\GA0\GA0[6=/[6=/\GA0\GA0\GA+N <@B0@OJU1+[6=/W@I+\GA0\GA0Z3(MJ4)YV%9RMAXIWF-\B Y+\GA0\GA+C2EXR346K3!!DT%9P
DQ\JTP-+\GA0\G@_H%\<IBT&KR</NC9YW")QX -+\GA0\FXMTTH4MSX6K"<0NC 9SFI^Z@-+\GA0\@<4U5D4MC-RW$0>NC >O$1EZ@-+\GA0Z05CD DD@0@A
DCQ^VS8>O#=EZ@-+\GA0N!!$FEA UBD]+Z!!0MR&EEO$UEZ@-+[6=/C0D#L#H\W6-+Z6,MTVELSD5SZ@-+[6=/@SMUU$%%Z6-+[ 1PXVI(ZF!!(Z@-+[6=/Z6-+
Z6-+Z6-+B @@@@@@@@@@@@E+[0H@@@@@@@@@@@@JZ6-+Z6-+Z6-+Z6-+[0-(ZF!!(ZFI"T@))Z6-+Z5-''Y4@AZ6-+[0-(T5MMT6IQCVM+Z6-,LTEHL0DNZ6-/
[0-(QTUESFIPCQ9-Z6@SGR@[BQ$(Z6-/[0-(QTUEO4QYW#PP@ @EA0DRP05$Z6-/[0-(QUMEO#8>QEM^VC04MEEWM@1+Z6-/[0-(X&!!SO#8>NC\6OS45MTIQ
CUQ+Z6=/[0-(U2)!!V#88NC\.K"0,OED"F&-+Z6=/[0-QB!!LQTVISQC8=OS5QVBDLZ6-+[6=/[0XJQ&-OBQ$;VU9^WT(+CR]+Z6-/[6=/[0ENZ6-+Z4<\C@@K
@@0''Z6-+Z6-/[6=/[6-+Z6-/Z6-+Z6-+Z6-+Z6-+Z6=/[6=/');
                colorMapFromArray:#[ 0 79 191 15 80 191 15 80 192 15 95 191 16 95 176 16 95 191 16 95 192 31 95 176 31 95 191 31 95 192 31 96 192 31 111 207 32 96 192 32 111 207 47 96 192 47 111 192 47 112 207 47 112 208 47 127 208 48 111 192 48 112 176 48 112 191 48 127 208 63 112 192 63 127 176 63 128 208 64 112 192 64 127 191 79 127 192 79 128 191 79 128 192 79 128 207 79 143 191 79 144 223 79 159 223 80 143 191 80 175 239 80 176 239 80 176 240 95 128 192 95 143 192 95 143 207 95 160 224 95 175 224 95 176 239 95 176 240 95 191 240 95 191 255 95 192 255 96 143 208 96 144 191 96 144 192 96 176 239 96 191 239 96 191 240 96 192 240 96 192 255 96 207 255 111 144 208 111 176 239 111 191 239 111 192 240 111 207 255 111 208 255 112 159 207 112 160 207 112 192 239 112 192 240 112 207 255 112 208 255 127 159 192 127 159 207 127 160 192 127 160 207 127 207 240 127 208 240 127 208 255 127 223 255 128 159 207 128 160 207 128 207 240 128 208 240 128 208 255 128 223 255 143 160 207 143 175 192 143 176 207 143 208 240 143 208 255 143 223 255 143 224 255 144 176 208 144 176 223 144 223 255 144 224 255 159 175 207 159 176 223 159 224 255 159 239 255 160 176 207 160 191 207 160 191 208 160 191 224 160 192 208 160 239 255 175 191 207 175 191 208 176 192 208 176 207 224 191 192 223 192 208 224 240 240 239 240 240 240 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@G>F@_?.@??>A??>C??>C??>C??>G>?>G<O>G8?>@@?>_?@@_?C8_>O8_?_8_??8_??0_??0_?? _??@]?>@X_8@@@@@');
                            yourself);
                yourself
        ]
!

rightArrow24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self rightArrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#rightArrow24x24Icon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class rightArrow24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PH@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@0PB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PTF@ @@@@@@@@@@@@@@@@@@@@@@@@@@@0\@A@H@@@@@@@@@@@@@@@@A@PDA@PDH@P\I
@@XB@@@@@@@@@@@@@@@AA0(@@@@@B ,LB @D@ @@@@@@@@@@@@@MB \NB ,ODADRD0(@A H@@@@@@@@@@@@M@@TTEQLQE!!\WD 0K@@PB@@@@@@@@@@@MB <W
E1\WD!!\WD!!LYDQ(B@@@@@@@@@@@AB <[D10[GQ8QG!!$QF H@@@@@@@@@@@@AA!!(ZF!!(ZE1H^FQDZ@ @@@@@@@@@@@@@A@ HB@ HB@1DYDQ(B@@@@@@@@@@@@
@@@@@@@@@@@@@QXQF H@@@@@@@@@@@@@@@@@@@@@@@@@@0PZ@ @@@@@@@@@@@@@@@@@@@@@@@@@@@Q(B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0H@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 224 224 224 0 32 64 0 0 0 0 64 96 32 128 160 128 160 192 32 96 128 128 192 192 0 64 64 160 192 192 192 224 224 160 192 224 96 192 224 32 64 96 160 224 224 128 192 224 96 160 192 0 160 192 0 128 192 64 192 192 64 160 192 96 192 192 32 160 192 0 128 160 192 192 192 64 224 224 0 96 128 32 192 192 64 192 224 0 192 224 0 192 192 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@D@@@F@@@G@@@G @@G0@O?8@O?<@O?>@O??@O??@O?>@O?<@O?8@@G0@@G @@G@@@F@@@D@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:15 / cg"
!

rightArrow24x24disabledIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self rightArrow24x24disabledIcon inspect
     ImageEditor openOnClass:self andSelector:#rightArrow24x24disabledIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class rightArrow24x24disabledIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PH@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@0PB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PTF@ @@@@@@@@@@@@@@@@@@@@@@@@@@@0\@A@H@@@@@@@@@@@@@@@@A@PDA@PDH@P\I
@@XB@@@@@@@@@@@@@@@AA0(@@@@@B ,LB @D@ @@@@@@@@@@@@@MB \NB ,ODADRAP(@A H@@@@@@@@@@@@M@@TSE@TQEQXVD 0K@@PB@@@@@@@@@@@MB <V
E!!XVD!!XVD TODQ\B@@@@@@@@@@@AB <PAQ PFQLQD0<QE0H@@@@@@@@@@@@AA!!\WE1\WE!!HSC1DW@ @@@@@@@@@@@@@A@ HB@ HB@1DODQ\B@@@@@@@@@@@@
@@@@@@@@@@@@@QTQE0H@@@@@@@@@@@@@@@@@@@@@@@@@@0PW@ @@@@@@@@@@@@@@@@@@@@@@@@@@@Q\B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0H@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 224 224 224 25 25 25 0 0 0 48 48 48 102 102 102 153 153 153 80 80 80 172 172 172 44 44 44 182 182 182 214 214 214 185 185 185 166 166 166 57 57 57 204 204 204 176 176 176 144 144 144 115 115 115 96 96 96 134 134 134 163 163 163 124 124 124 92 92 92 70 70 70 156 156 156 137 137 137 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@D@@@F@@@G@@@G @@G0@O?8@O?<@O?>@O??@O??@O?>@O?<@O?8@@G0@@G @@G@@@F@@@D@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

sUnit24x24BaseIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sUnit24x24BaseIcon inspect
     ImageEditor openOnClass:self andSelector:#sUnit24x24BaseIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary sUnit24x24BaseIcon'
        ifAbsentPut:[(Depth2Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@EUUUUUU@EUUUUUV@EUUUUUZ@EUUUUU*DEUUUUV*@EUUUUZ*AEUUUU**@EUUUV**@EUUUZ**@EUUU***@EUUV***@EUUZ***@EUU****KEUV****I
EUZ****@EU*****DEV*****@EZ*****@E******@F******@@@@@@@@K') colorMapFromArray:#[0 0 0 255 0 0 0 255 0]; yourself]
!

sUnit24x24DebugIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sUnit24x24DebugIcon inspect
     ImageEditor openOnClass:self andSelector:#sUnit24x24DebugIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary sUnit24x24DebugIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@)#@BH"H"H"JRH"(@* H"H"H)$#H"(@* @"H"H"H#$("H^ XBH"JEH"NR"Y"0Y H"H( "IP^UVX P@"H"HHH(,HUU&A@BH"H"@H"HBEVXD@H"
H"JH&Y,0"XDP@%H"JH%U"I";DQ@BH".H%U"EVX@V@@T@.H%U"EUY 3@P@EV;%U"EUU&:DQ@EUX!!U!!%UU&@A!!D@UU"E"EUUVX@@@PARUT"EUUVXB!!D1@BH"Y9
UUVXB!!DQD@H"HQRH"H@JDQDP@"HQDVY&Y DQDQ@BHQDQDQDV@QDQD@HQDQDQDV@QDQDP@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 0 255 0 255 0 0 44 44 44 152 49 49 248 0 0 110 110 110 100 72 72 108 0 0 209 0 0 148 148 148 52 0 0]; yourself]
!

sUnit24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sUnit24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#sUnit24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary sUnit24x24Icon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@BH"H"H"H"H"H"H@H"H"H"H"H"H"H0@"H"H"H"H"H"H3@BH"H"H"H"H"H3L@H"H"H"H"H!!DCL0@"H"H @@@!!D@L3@BH"H ???1D@L3L@H"
HQ???1D@L3L0@"H D_?1D@@3L3@BH"@AG1D@<CL3L@H"H@@QD@?0L3L0@"H <@D@??@3L3@BH"C?@@??<CL3L@H"H ?0??<CL3L0@"H"HO??<CL3L3@BH"H3
@@@CL3L3L@H"H3L3L3L3L3L0@"H3L3L3L3L3L3@BH3L3L3L3L3L3L@H3L3L3L3L3L3L0@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; yourself]
!

saveImage24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveImage24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#saveImage24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class saveImage24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DP@@@@@@@@@@@@@@DPL"H"H"H"H"H3D@DPL$QDQDQDQDH1D@DPL$EAQAQAEDH1D@DPL$EAQAPTQDH3D@DPL$EADQ
PTQDH3D@DPL$EAQAPTDTH3D@DPL$EAQAPTPTH3D@DPL$EAQAPTPTH3D@DPL$EAQAQADTH3D@DPL$QDQDQDQDH3D@DPL"H"H"H"H"H3D@DPL3L3L3L3L3L3D@
DPL3DQDQDQDQL3D@DPL3D3L3L3D#L3D@DPL3DQ@3L3D"L3D@DPL3D"@3L3D"L3D@DPL3D@@3L3D"L3D@DSDQD"H"H"DQLQD@DP@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 255 255 255 0 0 0 127 127 127 170 170 170 200 200 200 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??8@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:12 / cg"
!

shell24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self shell24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#shell24x24Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class shell24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@L3L3L3L3L3L3@@@@LQDQDQDQDQDQ@@@@LRH"H"H"H"H1@@@@LRH$H"H"H"H1@@@@LRIDP"H"H"H1@@@@LRP$IBH"H"H1@@@@LRP4H"
H"H"H1@@@@LRIDP"H"H"H1@@@@LRH4IBH"H"H1@@@@LRP$IBH"H"H1@@@@LRIDP"H"H"H1@@@@LRH$H"QDIDP1@@@@LSL3L3L3L3L1@@@@@QDQDQDQDQDQ@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8C??8@@@@@H@(@H@(A/L(BIR(AI^(@)P(CIL(@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:09 / cg"
!

snapshot24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self snapshot24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#snapshot24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class snapshot24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")J>/)BH@@@@@@@@@@@@@[&9?_7<@@D@\CP4MCQ1@
@@@@@@@@@CEJR$)JR$)%YZ.O"S 8"X>O#8>O#8<A@E9JR$)JR$)JN389B+.;B#$^BEI;L8=?@D&TG6MJR$)JM3\EFA XF@T7,X,!!Z(>/@@,B-QXFR$)PM3@@
[6=/[0ALULB))8>B@KYN&)</R$*X[66Y!!!!PT!!*M-''I"HZ79X@KYN]QX/R$)YI"Q&P%EQP&X$I%%8^YIX@KYN&)<#R$*>Q44.ZR\''ZTTRE;8C#H4#@KYN]QX#
R$(FC(:U]JJ"]IVNC Z7[KJ=@KYN]QX#R$)3Y1-H"(*J"$ [Y5>(,B"]@KYN&)<#R$(=O0$  XFA R@IO1Y=!!3QO@KYN]QX#R'' *GTL,+YBP+R2:PWX6IX#A
@KYN&)<#R&J4+A6E 4YF 723] \G^+''A@@,B&!!X5R%5 DZ@]GQ4]GQ56**)1\+<D@IFS%2%JR!!@PZJV.+*:.+*F****8OG\Z@LEKEY98)!!A$ZE]W+*:.+%]W
V*)$ZEXO@@2[T6M#T5M0\GB[J6E!!XVDSWGA0\I,L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 199 201 201 152 154 156 116 118 120 201 203 205 135 137 140 238 237 236 141 143 145 190 197 206 217 219 220 84 161 232 134 201 255 110 112 114 152 154 155 255 254 253 201 197 193 135 137 139 180 182 186 168 170 173 101 148 198 132 137 143 49 118 196 219 221 221 137 139 141 179 177 176 255 250 246 255 255 255 135 137 138 91 167 239 195 195 196 190 187 186 217 219 219 115 117 119 145 178 243 137 205 255 179 181 183 143 145 147 170 177 186 189 191 194 153 153 154 133 193 249 217 218 220 132 135 137 142 144 147 134 139 141 140 174 245 233 233 233 108 172 233 143 144 146 216 216 217 153 155 157 249 249 249 190 191 191 213 214 216 142 144 146 188 193 198 214 215 216 179 227 255 224 222 219 255 255 254 216 218 219 180 182 185 137 138 139 217 218 219 213 208 205 169 171 172 188 189 190 125 184 241 144 184 222 251 251 251 108 171 233 184 184 252 180 178 176 125 177 240 105 107 109 213 214 215 196 198 200 215 216 217 94 144 198 117 119 121 139 141 143 212 213 214 149 206 255 191 192 192 132 134 136 213 214 214 223 223 223 184 186 189 183 185 188 144 146 148 193 195 196 181 185 192 234 234 234 133 135 138 186 188 190 155 157 161 138 139 142 184 186 188 129 145 150 198 200 202 131 133 135 181 183 186 234 234 233 67 128 198 213 209 204 182 184 187 134 194 250 211 209 208 206 207 209 198 200 201 158 158 158 177 178 180 176 177 179 133 135 137 182 185 187 182 184 186 138 139 141 122 184 243 121 123 125 140 147 156 185 187 190 204 205 207 203 204 206 187 191 197 182 179 176 89 158 226 192 193 197 238 238 239 148 150 153 252 252 252 142 178 241 146 148 151 175 181 250 241 241 241 89 157 225 58 124 196 192 193 196 207 208 210 179 228 255 128 178 240 212 210 209 200 202 204 230 231 232 94 161 227 205 203 202 158 180 244 107 109 111 234 235 235 113 115 117 109 111 114 123 187 247 254 254 254 118 120 122 210 211 213 174 177 183 178 181 182 134 136 138 176 176 179 140 142 145 221 222 222 154 157 159 142 143 145 145 149 154 121 184 243 174 177 181 147 149 153 166 169 171 188 190 192 230 230 230 194 196 198 248 245 243 181 184 187 223 222 221 145 145 145 159 180 245 147 150 152 147 149 152 193 196 198 215 215 216 226 227 228 221 219 216 163 165 166 177 181 181 111 113 115 199 201 202 179 181 185 201 204 207 143 184 223 135 201 255 242 242 242 141 143 146 163 164 167 190 192 194 231 231 231 138 140 142 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@A>@G3?@_???_???_???_???_???_???_???_???_???_???_???_???_???_???_???_???@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

systemBrowser24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self systemBrowser24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#systemBrowser24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class systemBrowser24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADQDQDR@@@@@@@@@AL3L3L4@@@@@@@@@AL3L3L4@@@@@@@@@BQDQDQD@@@@@@@@@@@@@@@@
@@@@@@@@@@@@P@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@@@@QDQDQD @@@@DDQD@UUUUUU@@@@@@@@@@$QDQDP@
@@@@P@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@@@@QDQDQD @@@@DDQD@VY&Y&Y@@@@@@@@@@$QDQDQ@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 172 170 170 255 0 0 128 128 130 0 255 0 255 255 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@_? @_? @_? @_? @_? @_? @@ @@@ @@@ @@@ ??A0??A???A0??@ ??@ @@@ ??A0??A???A0??@@??@@@@@@@@');
                            yourself);
                yourself
        ]
!

uiPainter24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#uiPainter24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class uiPainter24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BYBPADQDQDQDQDP@BYBP@@@@@@@@@@@@BYBPAUUUT UUUUH@@@@@AUUUT TQTUH@@@@@APTQT UU
UUH@@@@@AUUUT TQDUH@@@@@APTQT UUUUH@@@@@AUUUT TUDUH@@@@@APTQT UUUUH@@@@@AUUUT UUUUH@@H&PAUUUT T"H%H@@@@@AUUUT T"H%H@@@$@
AUUUT T"H%H@@@$@ARH"T T"H%H@@@$@ARH"T T"H%H@@H"PAUUUT UUUUH@@H&P@"H"H H"H"H@@H&P@@@@@@@@@@@@@H&P@@@@@@@@@@@@@H"P@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 200 200 0 0 127 127 127 127 127 255 0 0 240 240 0 255 255 0 100 100 100 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@??>N??>N??>N??>D??>D??>D??>D??>D??>D??>N??>_??>_??>N??>N??>N??>_??>_??>_??>_@@@_@@@N@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:06 / cg"
!

undoXP24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self undoXP24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#undoXP24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class undoXP24x24Icon'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E5TR5E\@@@@@@@@@FMFP% @@@@@@@AXPA$!!K1<R
O%0@@@@@@D1ST#,@@@@@Y4TZL#@-JBT F@I\@@@@@D)OSS(@@@A[A"81K"\TC1@XF1 ?@@@@@D)IQ3$@@E,LK2<,DDQYX%\BFA,QT@@@@D)AN@,@V081K"HC
U @@@@A[A1,[O0@@@D(7M )[CR<+GS9"@@@@@@@@P1,[AP@@@D(5M@ MKR \O&T@@@@@@@@@R1,[B0@@@D(3LR\*IQ,>Y @@@@@@@@@@RA,[A0@@@D(/KBX$
E0AY@@@@@@@@@@@@AQ,[@P@@@D()IRD\EP,KB0,KO6T@@@ATC1,VS @@@D(#G!!,[F1,[F1,[DUX@@@@AF1,GV0@@@D(SD1LSD1LSD1LSAE<@@D,SF1YC@@@@
@@@@@@@@@@@@@@@@@@@@UP$[F0U^@@@@@@@@@@@@@@@@@@@@@@AZ@!!,[DT(@@@@@@@@@@@@@@@@@@@@@@E(BFA,VOP@@@@@@@@@@@@@@@@@@@@@@V HXF1 B
X@@@@@@@@@@@@@@@@@@@@@@@T@4[F@IZ@@@@@@@@@@@@@@@@@@@@@@@@@D Q@%(@@@@@@@@@@@@@@@@@@@@@@@@@@@@<V @@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[1 55 156 1 58 159 1 62 163 1 64 165 1 65 166 1 68 169 1 69 170 1 71 172 1 74 174 1 74 175 1 75 176 1 78 179 1 79 180 1 81 182 1 82 182 1 84 185 1 86 187 1 87 188 1 88 189 1 90 191 1 92 193 1 93 194 1 97 198 1 98 199 1 100 201 1 101 201 1 102 203 1 103 204 1 104 205 1 105 206 1 106 207 1 109 210 1 110 211 1 111 212 1 112 213 1 114 215 1 115 216 1 116 217 1 118 219 1 119 219 1 119 220 1 120 221 1 123 223 1 123 224 1 126 226 1 127 227 1 128 228 1 129 229 1 129 230 1 130 231 1 135 236 1 138 240 1 140 242 1 143 245 1 149 251 1 153 255 3 154 255 6 79 179 13 82 179 15 76 172 16 64 158 16 66 161 16 67 162 16 70 164 16 75 169 20 160 255 23 78 172 31 79 166 31 80 167 31 81 168 33 82 171 34 164 255 46 87 167 54 171 255 61 98 171 61 99 171 61 99 172 68 176 255 76 110 176 85 181 255 91 122 180 91 123 181 99 186 255 102 174 242 106 134 185 120 145 189 120 145 190 120 146 190 121 146 191 135 156 194 150 168 196 150 168 198 151 169 198 151 169 199 165 180 201 165 180 203 180 192 205 180 192 207 180 192 208 181 193 208 195 203 212 195 203 213 195 204 212 196 205 213]
            mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@_@^A?0^G?8^O?8^_?<^?!!<_?@<_>@<_<@<_8@<_?1<_?1<_?38@@G8@@O0@@_ @@? @@?@@@^@@@L@@@@@@@@@'); yourself); yourself]
!

upArrow24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self upArrow24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#upArrow24x24Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class upArrow24x24Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PH@@@@@@@@@
@@@@@@@@@@@@@@@@@@@A@0PE@@@@@@@@@@@@@@@@@@@@@@@@@@DFA0 DAP@@@@@@@@@@@@@@@@@@@@@@@P$@A0(HA@T@@@@@@@@@@@@@@@@@@@@AB0@@C@4N
C0PE@@@@@@@@@@@@@@@@@@DF@@@LB@ MD@<DAP@@@@@@@@@@@@@@@PLGDQHHD1LHE@8UA@H@@@@@@@@@@@@AE!!\XA@<SD1LHEPPYF DB@@@@@@@@@@D\@Q0A
GA4OD1LJEPD\@Q0A@ @@@@@@@@@@@@@@@!!8^C1T_A@T@@@@@@@@@@@@@@@@@@@@@E @GHATRA@T@@@@@@@@@@@@@@@@@@@@@E @GDQT_A@T@@@@@@@@@@@@@
@@@@@@@@@P@!!H!!TJA@T@@@@@@@@@@@@@@@@@@@@@@P\#IATTA@T@@@@@@@@@@@@@@@@@@@@@@QXXFPPDF H@@@@@@@@@@@@@@@@@@@@@@ TEAPTE@ H@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 224 224 224 0 32 64 0 0 0 96 128 160 0 96 128 0 0 32 128 160 192 192 224 224 0 160 192 128 128 160 32 192 192 128 160 160 96 192 224 0 192 224 32 192 224 32 160 192 64 224 224 160 192 224 64 192 192 0 128 192 0 192 192 0 128 160 32 64 96 64 96 128 32 96 128 0 64 128 0 64 96 192 192 192 0 32 96 32 128 192 128 192 224 64 192 224 128 192 192 160 224 224 96 192 192 96 160 192 64 160 192 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@F@@@O@@@_ @@?0@A?8@C?<@G?>@O??@_?? @?0@@?0@@?0@@?0@@?0@@?0@@?0@@@@@@@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 06-02-2007 / 19:40:02 / cg"
!

windowInspectIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self windowInspectIcon inspect
     ImageEditor openOnClass:self andSelector:#windowInspectIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class windowInspectIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@E!!0[E1LOC@(HA TDA@PDA@PD@@@@@@@@GDP;L" $HA(UCP$IBP$IBP$N@@@@@@@@HTL9J2X#G1 RB0\GA0\GA0\N@@@@@@@@I7)4Y&U$X5YUUEQT
UEQTUEPN@@@@@@@@NHZF!!(ZF!!(ZF!!(ZF!!(ZF!!(XN@@@@@@@@M8ZJ"(*J"(ZJ"(*J"(*J!!(XN@@@@@@@@M(ZJ!!(ZF!!#*F!!(*F!!(X:!!(XN@@@@@@@@MXY.O#5A
S5]5!!(*F!!(X:!!(XN@@@@@@@@MDYQ\''1=^V5RSHNF!!(X:!!(XN@@@@@@@@VHQST5MST5M8T4FCN#(:!!(XN@@@@@@AY G!!8^G!!8^G!!8^F4>!!(ZF!!(XN@@@@@GA,
#G!!ST5MST5MST81-WS(:#8XN@@@@@E=7K7!!S^G!!8^G!!8^G!!-OH:F#8XN@@@@@E%=K''!!S^G!!8^G!!8^G"BPH:F#8XN@@@@@E&BKW!!S^G!!8^G!!8^G"BRH:F#8XN
@@@@@E%=KG!!S^G!!8^G!!8^G"BRH>F#8XN@@@@@E)3J''!!S^G!!8^G!!8^G"BOXZF#8XB@@@@@F=!!JW!!S^G!!8^G!!8^G!!1QX>O#8XN@@@@@@AJ[W!!8^G!!8^G!!8^G!!G
 8ZF!!(XN@@@@@@ANR''NB!!''!!8^G!!8"59)!!(ZF!!(XN@@BT#W=MO4)"^HJI!!XE6W&(NC 8NC 8C@INQ$G9K@@AOP$%PXE9+^0@@@@@@@@@@$9JP"F]\@@@@@@@@
@@@@@@@@@@@@@@@@$)BHZE,@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 0 7 66 194 12 59 167 23 89 204 27 95 206 32 101 209 36 106 255 36 107 211 39 109 255 41 113 214 45 115 255 45 119 216 48 118 255 50 87 176 50 125 219 52 90 178 53 127 212 54 123 255 54 131 221 55 95 181 57 127 255 57 149 229 58 137 224 63 132 255 66 113 193 66 135 255 67 149 229 68 157 232 69 117 196 72 122 199 72 141 255 75 144 255 77 163 236 78 131 206 80 149 255 84 153 255 87 145 215 88 157 255 91 168 235 93 161 255 94 154 222 96 157 223 96 165 255 97 159 225 98 160 225 98 162 226 99 163 227 100 165 228 101 166 229 101 170 255 102 167 230 103 169 231 104 170 232 105 172 233 105 174 234 106 175 235 112 180 255 116 116 120 117 186 255 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 132 200 255 139 207 255 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 149 184 255 153 188 255 157 192 255 159 159 192 159 160 192 159 160 207 159 160 208 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 162 196 255 166 200 255 170 204 255 174 208 255 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 181 215 255 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 225 255 192 192 208 192 239 255 192 240 255 207 143 95 207 207 191 207 223 239 207 239 240 207 255 255 208 208 223 208 224 239 208 255 255 212 211 224 217 217 217 223 128 63 223 255 255 237 236 242 239 239 240 239 255 255 240 207 144 245 244 247 247 246 249 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@???@???@???@???@???@???@???@???@???@???A???C???C???C???C???C???C???C???A???A???O???_O<@?@@@>@@@');
                            yourself);
                yourself
        ]
!

windowInspectIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self windowInspectIcon2 inspect
     ImageEditor openOnClass:self andSelector:#windowInspectIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class windowInspectIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@AXVE1LOC@(HA TDA@PDA@PD@@@@@@@@@A0\L" $HA(UCP$IBP$IBP$N@@@@@@@@@BD!!J2X#G1 RB0\GA0\GA0\N@@@@@@@@@B\''Y&U$X5YUUEQT
UEQTUEPN@@@@@@@@@C 8!!(ZF!!(ZF!!(ZF!!(ZF!!(XN@@@@@@@@@C\7"(*J"(ZJ"(*J"(*J!!(XN@@@@@@@@@CX6!!(ZF!!#*F!!(*F!!(X:!!(XN@@@@@@@@@CT5O#5A
S5]5!!(*F!!(X:!!(XN@@@@@@@@@DYQ\''1=^V5RSHNF!!(X:!!(XN@@@@@@@@VHQST5MST5M8T4FCN#(:!!(XN@@@@@@AYJW!!8^G!!8^G!!8^F4>!!(ZF!!(XN@@@@@GA,
JW!!ST5MST5MST81-WS(:#8XN@@@@@E=7JW!!S^G!!8^G!!8^G!!-OH:F#8XN@@@@@E%=JW!!S^G!!8^G!!8^G"BPH:F#8XN@@@@@E&BJW!!S^G!!8^G!!8^G"BRH:F#8XN
@@@@@E%=JW!!S^G!!8^G!!8^G"BRH>F#8XN@@@@@E)3JW!!S^G!!8^G!!8^G"BOXZF#8XN@@@@@F=!!JW!!8^G!!8^G!!8^G!!1QP8NC 8N@@@@@@AJ[R%8^G!!8^G!!8^G!!G
@@@@@@@@@@@@@@ANR''L)JR$)JR$)"59)@@@@@@@@@@BT#W=MO4)"^HJI!!XE6W&(@@@@@@@@@@INQ$G9K@@AOP$%PXE9+^0@@@@@@@@@@$9JP"F]\@@@@@@@@
@@@@@@@@@@@@@@@@$)BHZE,@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 0 0 7 66 194 12 59 167 23 89 204 27 95 206 32 101 209 36 106 255 36 107 211 39 109 255 41 113 214 45 115 255 45 119 216 48 118 255 50 87 176 50 125 219 52 90 178 53 127 212 54 123 255 54 131 221 55 95 181 57 127 255 57 149 229 58 137 224 63 132 255 66 113 193 66 135 255 67 149 229 68 157 232 69 117 196 72 122 199 72 141 255 75 144 255 77 163 236 78 131 206 80 149 255 84 153 255 87 145 215 88 157 255 91 168 235 93 161 255 94 154 222 96 157 223 96 165 255 97 159 225 98 160 225 98 162 226 99 163 227 100 165 228 101 166 229 101 170 255 102 167 230 103 169 231 104 170 232 105 172 233 105 174 234 106 175 235 112 180 255 116 116 120 117 186 255 127 127 175 127 128 175 128 128 175 128 143 175 128 143 176 128 143 191 128 144 191 132 200 255 139 207 255 143 143 176 143 143 191 143 144 191 143 159 191 143 159 192 143 159 207 144 143 143 144 144 191 144 159 160 144 159 191 144 159 192 144 160 192 144 160 207 144 160 208 144 191 239 149 184 255 153 188 255 157 192 255 159 159 192 159 160 192 159 160 207 159 160 208 160 128 144 160 144 159 160 160 191 160 175 207 160 175 208 160 176 208 160 191 224 160 192 224 162 196 255 166 200 255 170 204 255 174 208 255 175 111 80 175 111 95 175 160 192 175 175 192 175 175 207 175 191 223 175 208 240 176 176 207 176 176 208 176 191 208 176 208 224 176 208 239 176 223 240 181 215 255 191 191 208 191 207 224 191 223 239 191 224 240 191 224 255 191 225 255 192 192 208 192 239 255 192 240 255 207 143 95 207 207 191 207 223 239 207 239 240 207 255 255 208 208 223 208 224 239 208 255 255 212 211 224 217 217 217 223 128 63 223 255 255 237 236 242 239 239 240 239 255 255 240 207 144 245 244 247 247 246 249 255 175 79 255 191 80 255 191 95 255 207 144 255 208 159 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@O??@O??@O??@O??@O??@O??@O??@O??@_??@???A???C???C???C???C???C???C???C???A??@A??@O?>@_O<@?@@@>@@@');
                            yourself);
                yourself
        ]
!

workspace24x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self workspace24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#workspace24x24Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class workspace24x24Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A&Y&Y&Y&Y&Y&Y&Y @@@@@@@@@@@@@@@@@QDQDQDQDQDQDQAP@TPDQDQ@Q@PQDQ@ @TPDQDQ@
P@@QDQ@ @P@D@@Q@Q@PQDQ@ @PPDA@Q@Q@PQDQ@ @P@D@@Q@Q@@QDQ@ @QDQDQDQDQD1DQ@ @QDQDQDQDQD3DQ@ @QDQDQDQDQD3LQ@ @QDQDQDQDQD3DQ@G
@QDQDQDQDQDQLQ@ @QDQDQDQDQDQLQ@ @QDQDQDQDQDQDQAP@@@@@@@@@@@@@@@@ARH"H"H"H"H"H%AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 0 0 0 255 0 127 127 127 0 127 127 127 0 0 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@????????????????????????????????????????????????????????????????????????????@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-28x28'!

bug28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bug28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#bug28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class bug28x28Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUUT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O?0@@@@@@?*+@@@@C3>**,@@@O*N***
0@@C:#***,@@@N(@@@@@@@O*O***0@@@>3>**<@@@@@O??0@@@@@@C?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 192 192 192 255 0 0 128 0 0 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0L@@@#F0@@F_1@@@/>@@A/?0@@??>@G??? BG??8@A??>@G??? @???8@@[?<@@@/>@@@Y?D@@H1,@@@0L@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

bugReporter28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bugReporter28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#bugReporter28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class bugReporter28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@EUUUUUUUU@@@@@@@@@@@@@@@@@@T@@@@@@@@EUUUUUUUUAP@@@@@@@@@@@@@@@@TE@@@@@@@ADQDQDQDQAPT@@@@@@@@@
@@@@@@DEAP@@@@@ADQDQDQDQ@PTE@@@@@@@@@@@@@@DAAP@@@@@DQDQDQDQD@PDE@@@@@@@@@@@@@@PA@P@@@@@DQDQDQ@ADA@D@@@@@@@PQDTPDQ@@D@@@@
@@@@ADQDQD@DP@@@@@@@@@@DPTEAQ@P@H"H"@@@@@@QDEA@D@BH#L3L @@@@ADEA@"@"H3L3L3H@@@@@@@H#L0H3L3L3L2@@@@@@@"L3@#L3L3L3H@@@@@@@
H3L@@@@@@@@@@@@@@@H#L0H#L3L3L2@@@@@@@BH2@"H3L3L2H@@@@@@@@@@@H"H"H"@@@@@@@@@@@@@@@"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 170 170 170 128 0 0 255 0 0 255 255 255 127 127 127 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@??8@@O?>@@O?? @C??8@C??>@@??? @???8@O??>@O??? C??? C???8@???8@O???@C???D@???8@O???@C???8@???>@O??? @G??8@_??>@C??? @A/
?0@@B?8@@A''<P@@#F0@@C@0@@@@@@@@a');
                            yourself);
                yourself
        ]
!

bugReporterIcon
    <resource:#programImage>
    ^ self bugReporter28x28Icon
!

changesBrowser28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self changesBrowser28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#changesBrowser28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class changesBrowser28x28Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@B****@@@@@@@@@ @@@B****H@@@@@@@@"@@@C????H @@@@@@@2H@@C????L"@@@@@@@3H@@AUUUUL2@@@@@@@SL@@AUUUUD3@@@_=UUQL@
@@EUUUTS@@@A]7UUD@@@@U7]5Q@@@@E7]5T@@@@AUUUU@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH@@@@@@@@LB@L@@@@@@@@@@@@@@@@J@@@@@@@@@@@
@@@@@@@H@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@??8@@O?>@@O?? @C??8@C??>@@??? @???8@O??>@O??? C??? C???8@???8@O??>@C??>@@??? @O?? @C??8@@??8@@O?>@@@@@@@@@@@@@Z.$7LH+-
YDBJ+TQ@#.=WHH*+UABJ*5PPZ*$7X@@a');
                            yourself);
                yourself
        ]
!

copy28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copy28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#copy28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class copy28x28Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@O????8@@@C****)@@@@:****P@@@N****$@@@C****)@@@@:****P@@@@@@**$C????>J*)@:****R**PN****$**$C****)J*
)@:****R**PN****$**$C****)J*)@:****R**PN****$**$C****)J*)@:****QUUPN****$@@@C****)@@@@:****P@@@N****$@@@C****)@@@@:****Q
@@@IUUUUT@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@???@@O??0@C??<@@???@@O??0@C??<@@???A????0_???<G????A????0_???<G????A????0_???<G????A????0_???<G????A????0_?? @G??
8@A??>@@_?? @G??8@A??>@@_?? @@@a');
                            yourself);
                yourself
        ]
!

cut28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self cut28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#cut28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class cut28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@DQDQDQDQDQDS@@@@@@@SL3L3L3L<L3H@@@0@@AL3L3L3L303L @@C@@@D3L3L3L3OLL2@@CL@@@SL3L3L3L303H@@L@@@AL3L3L3
L3OLL @L0@@@D3L3L3L3L302@@0@@@@SL3L3L3L3OLH@3@@@@AL3L3L3L3L<0 CL@@@@D3L3L3L3L3OB@L@@@@@SL3L3L3L3L<H@0@@@@AL3L3L3L3L33L3@
@@@@D3L3L3L3L3L<3@@@@@@SL3L3L3L3L33L@@@@@AL3L3L3L3L3OL0@@@@@D3L3L3L3L3L<3@@@@@@SL3L3L3L3L33L@@@@@AL3L3L3L3L33@3@@@@@L"H"
H"H"H"3B@,0@@@@@@@@@@@CL3@@@CL3@@@@@@@@@C@C@@@@@0@0@@@@@@@@L@L@@@@C@C@@@@@@@@@0@0@@@@L@L@@@@@@@@C@C@@@@@0@0@@@@@@@@L@L@@
@@C@C@@@@@@@@@CL@@@@@@3@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
_??8@G??>@A???!!@_??8PG??>LA???"@_??9 G??>PA???,@_??;@G??> A???(@_??>@G???@A???0@_??<@G???@A???0@_??>@G???0A???'' @@R@$@@D
 I@@AHBP@@R@$@@D I@@@0A @@@@@@@a');
                            yourself);
                yourself
        ]
!

delete28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self delete28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#delete28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class delete28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADQDQDQDQDQL@@@@@@@D3L3L3L3L3L @@@@@@@SL3L3L3L3L2@@@@@@@AL3L3L3L3L3H@@@@@@@D3L3L3
L3L3L @@@B@@@SL3L3L3L3L2@@@B@@@AL3L3L3L3L3H@@@@@@@D3L3L3L3L3L @@@@@@@SL3L3L3L3L2@@@@@@@AL3L3L3L3L3@@@@@ @@D3L3L3L3L0@@@@
@@@@@SL3L3L3L3@P@@@@H@@AL3L3L3L3LADSL3H @@D3L3L3L3L0DQL3L"@@@SL3L3L3L3@Q@3L0H@@AL3L3L3L3LADC@3@ @@D3L3L3L3L0DPLCLB@@@2H"
H"H"H"@Q@0L0H@@@@@@@@@@@@ADC@3@ @@@@@@@@@@@@DPLCLB@@@@@@@@@@@@@Q@0L0H@@@@@@@@@@@@ADC@3@ @@@@@@@@@@@@DPLCLB@@@@@@@@@@@@@Q
D0L2H@@@@@@@@@@@@ DSL3HB@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@C??>@@??? @O??8PC??>D@???!!@O??8XC??>F@???  O??8HC??>B@????0O?? LC????@????0O???<C????@????0O???<C????@????0@@A?<@@@
_?@@@G?0@@A?<@@@_?@@@G?0@@@_0@@a');
                            yourself);
                yourself
        ]
!

desktop28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self desktop28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#desktop28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class desktop28x28Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@XFA ]FA XFA4]FA XFA XGQ4]@@@@@@@@@@@@FA XGQ4]FA XFA XFA XGQ4]GQ XFA XF@@@@A XGP,RB!! QFA ]GQ4]GQ4XGQ XFA XFA @@@@XFA D
A@PDC@LKC!!HQDQ XFA4]GR@]HA X@@@]FA ]C@4DCPPMAA( HB@]GQ XDQ QFB@]F@@@GQ4XF@PDC@PGA@4SHA8^HA8 G"@^HA$ GQ @@A4]FA4MCPPMA@4D
EA8 HA8 G"@ HA8^HA4X@@@]GQ4XA@PGA@ DB@\^GQ8^GQ8^HA4^GR@XF@@@FA XG!!PMA04HCP MF!!8^G"@^HA8 G"@]GQ @@A XGQ8^CP$MBP4ICQPZGA(\
F!!8^G!!8 GQ ]@@@XFA4YFPPLBP0DC@$TD1LZD1(YF!!$^GQ4XGP@@GQ4]F!!(MBP0ICP0MCAPWD1(WF!!(WG"@]FA4@@A4XGQLOC@0DC@PLA@0LCAPOEALWE!!8]
GQ ]@@@]FA$LA0PG@00CC@LLA@PLA00LE@<^GQ4XF@@@FA SD@4LA00CC@LL@00LA04GCP0THB@XFA @@A XFA4YA LL@0,CB0LKC@LG@00GEA4 FA4]@@@X
FA XFA4]FQLK@0LF@ LF@0XCA1L]GQ ]GP@@FA XGQ4]GQ4]GQ4]FQ$K@0,CA0LZGR@XGQ4@@A XFA4XFA4]GQ4]FA XGQ4YFP,KFQ4XGQ4]@@@@FA4]FA X
FA ]GR@]GQ4]GQ4]GR@]GQ ]GP@@@@@]FA4QFA XFA XGQ XGQ4 GQ4]HA4XFA4@@@@@@A4XGQ4]GQ4]GQ4]FADXFA4]HB@]DQD]@@@@@@@QFA4]FA4]GQ4]
GQ4]FA4XFADXDQDQ@@@@@@@@GQD]GQ4]HA4 GR@ GR@]GQ4XGQ4QDP@@@@@@@A4XDQ4]GQ4]GR@]GQ4]HA QFA ]DP@@@@@@@@@]@A QFA ]GR@]HB@]FADX
FA QGQ4@@@@@@@@@GQ4XDQ4QFA QFADQDQD]GQ QDQ4@@@@@@@@@@A4@@@@@@@@@@@@@@@@@@@@XDQD]@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 0 0 0 0 102 0 0 153 0 0 204 0 0 255 0 51 153 0 51 204 0 51 255 51 0 204 51 51 102 51 51 153 51 51 204 51 51 255 51 102 153 51 102 204 51 102 255 102 102 102 102 102 153 102 102 204 102 102 255 102 153 51 102 153 204 102 153 255 153 153 153 153 153 204 153 153 255 153 204 204 153 204 255 204 204 204 204 204 255 204 255 255 255 255 255 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
G?@@@A??<@@_???@G???8A???>@???? O???8C???>@???? O???8C???>A???? _???8G???<A????@_???0G???<@_???@C???0@G??<@G??>@C??? @??
?0@O??8@A??<@@O?>@@@?>@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

dos28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self dos28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#dos28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class dos28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H"H"H"H"H"H"H"H"H @#L3L3L3L3L3L3L3L3@BMDQDQDQDQDQDQDQBL@H4QDQDQDQDQDQDQDH0@#QDQDQD
QDQDQDQDP#@BMDEDQDQDQDQDQDQBL@H4QAQDQDQDQDQDQDH0@#QDPTQDQDQDQDQDP#@BMDQDEDQDQDQDQDQBL@H4QDEDQDQDQDQDQDH0@#QDEDQDQDQDQDQD
P#@BMDEDQADQHQDTDQEBL@H4QDQDQDQDQDQDQDH0@#QDQDQDQDQDQDQDP#@BL"H"H"H"H"H"H"H"L@@3L3L3L3L3L3L3L3L0@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 194 222 222 222 125 125 125 194 194 194 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G???>@???? @@@@@@@P@@@@D@@@@GLX@@BT
(@@@%I@@@IRH@@A3L@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

extract28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self extract28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#extract28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class extract28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CL3L3L0@@@@@@@@@@@@MDP4QC@@@@@@UUTE@@@3L3L3L@@B@AAUUPD@@CQDMDP0
@@H DEUU@P@@L3L3L2H"H"HPUUTA@@@4QCQDH"H"H"@@@@D@@CL3L3L"H"H"DQDQDP@@MDP4QC@@@"@Q@@@A@@@3L3L3L@@B@AD@UPD@@CQDMDP0@@@@DPAU
@P@@L3L3L3@@@@@@@@@@@@@4QCQDL@@@@@@@@@@@@CL3L3L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 129 129 129 255 0 0 255 255 255 105 133 190 194 194 194 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@A?<@@@_?A?8G?0_>A?<W? _?G?8G???>A???? _???8G?1?>A?<W? _?A?8G?0O>A?<@@@_?@@@G?0@@@@@@@@@@@@@@@@@@@@D@A@MED3PD*:
UNA9D%Q@P)ITPCQZL6@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fileBrowser28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileBrowser28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#fileBrowser28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class fileBrowser28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@CLA&Y&Y&Y&X@@@@@@@@L0F@@@@@@A @@@@@@@@3@XN;.;.8F@@@@@@@@CLA ;.@@@@@@@@@@@@@L0FC.8O[6=/[0@@@@@@3@X@
; [6=/[6@@@@@@CLA DNC6<@@F<@@@@@@L0F@A@F= [0= @@@@@@3@X@@P=/[6=/@@@@@@CLA @@A/[6=/X@@@@@@L0FC0@O[6=/[0@@@@@@3@XF<@@@@@@@
@@@@@@CLA = @@@@@@@@@@@@@L0FA/[6=/A @@@@@@@@3@XO[6=/XF@@@@@@@@CLA @@@@@@X@@@@@@@@L0FY&Y&Y&Y @@@@@@@@C@Y&Y&Y&Y&@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C @b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
A??<@@_??@@G??0@A??<@@_??8@G??>@A??? @_??8@G??>@A??? @_??8@G??>@A??? @_??@@G??0@A??<@@_??@@G??0@@??<@@G??@@@@@@@G.P=0AAD
HP@PQBD@GDP8 AADHD@PQBA@DN^=0@@a');
                            yourself);
                yourself
        ]
!

fileIn28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileIn28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#fileIn28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class fileIn28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A&Y&Y&Y&@@@FY&A @@@FL3L&Y&X@@PY&XA@@@@X3L2Y&Y @AA&Y D@
@0A"H"I&Y&@@DFY&@P@CLFY"Y&Y&X@@P@@@3L3L3Y&I%UUI @ADQDSL3L3L6X&UUT&@@DP@@L3L3L6Y"H"H"X@@Q@FXA@@L0Y&I&Y&Y @AD@Y D@@0A&X&QD
P&@@@@@@@@@@@FY"YDQBX@@@@F@@@@@@Y&H"H"I @@@@@@@@@@A&Y&Y&Y&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 129 129 129 63 63 36 255 0 0 194 194 0 0 127 0 194 194 194 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@_?0_>G?<G?!!??A?8_?0_>W?<G?''??A????0_???<G????A?9??0_>W?<C?!!??@B@_?0@@G?<@@A??@@@@@@@@@@@@U@D@@HP@@@BT0S@@%R
EH@]W!!R@BU@T @%LEH@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

garbageCollect28x28Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self garbageCollect28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#garbageCollect28x28Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary garbageCollect28x28Icon'
        ifAbsentPut:[(Depth4Image new) width:28; height:28; bits:(ByteArray fromPackedString:'
DQD@@@.;.1D[DQDQD@@QDP@@.;.;,[,@@ADP@ADQ@@.;@@.;.1@@@A@@DQD@B;@@@[.;DCH@D@@QDP@K,@@K.;,Q@2@P@ADQ@K.;@@DQDQDPL @@DQDKB;B0
@QDQ@@@C@@@QD[B0B0,ADP@"H"@@@ADQ@@@@@@DQ@P@@@0@@DQ@@@@C 8@@ADQL3@@@Q@@@@;.;.@@DCL0H@@@@@@@@NC @@@PLC@ @@@@@@C.;.8@@A@0LB
@@@@@@@@8N@@@@DC@0H@@@@@B (@@AD@@PLC@ @@@@****@LG@@A@0LB@@@@@JB CL3L0@DC@0H@@@B***(@0L@Q@SLCL @@@@(J@L3L3AD@L"H @@@@@QDQ
C@0QDQD@@@DP@@@ADQD@@@@QD@@@@@@@@ @B@ @B@@HB@ H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@@H@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@H@@@H@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0]; mask:((ImageMask new) width:28; height:28; bits:(ByteArray fromPackedString:'
@G1@@@C>0@@A1=0@@XO^@@FG30@C0@^@AZ@? @)P?8@@@O>@@B#? @C<?8@@TO>@@_#? @B ?8@E@O>@G9S? @)>?8@?JO>@EO3? @APO @@@@@@]7]7\DUU
UDAEUUQ@U7]5\EUUUTAUUUU@]U]W\@@a') ; yourself); yourself]
!

help28x28Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self help28x28Icon1 inspect
     ImageEditor openOnClass:self andSelector:#help28x28Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary help28x28Icon1'
        ifAbsentPut:[(Depth2Image new) width:28; height:28; bits:(ByteArray fromPackedString:'
@@@@@@E@@@@@@J*(D@@@@@***)P@@@@@@J*E@@@@K.,J(T@@@;.>8*E@@@K.:;"(T@@J;..;JE@@K; N;"!!P@C+ B;,(T@@/ @K.JE@@N,@C.2E@@B>@@.3!!
P@@@@@.8!!T@@@@@+.1P@@@@@/.1P@@@@@N.0P@@@@@N>2D@@@@@B:8!!@@@@@@;8(P@@@@@K+HP@@@@@@@BA@@@@@@J*HP@@@@@@@JD@@@@@C/"!!@@@@@@.,(
@@@@@@N>H@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 63 79 96 255 255 0 255 255 255]; mask:((ImageMask new) width:28; height:28; bits:(ByteArray fromPackedString:'
@@?8@@@??@@@_?8@@O??@@G??8@C??>@@???0@_??<@O???@C>O?0@?C?<@O0?>@C<O? @?G?8@@C?8@@A?<@@@_>@@@O? @@C?8@@@?>@@@O?@@@C?8@@@_
>@@@O? @@C?8@@@?<@@@O>@@@C?@@@@a') ; yourself); yourself]
!

help28x28Icon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self help28x28Icon2 inspect
     ImageEditor openOnClass:self andSelector:#help28x28Icon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class help28x28Icon2'
        ifAbsentPut:[(Depth4Image new) width: 28; height: 28; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@3H@@@@@@@@@@@@@@@@CL2@@@@@@@@@@@@@@@@L3L @@@@@@@@@@@@@@@3L3@@@@@@@@@@@@@BLCL3
L0@@@@L3@@@@@CL0L3L3@@H3L3L0@@A@L3@3L3LBH#L3L3A@@D@3LCL3L0H"L3L3LD@@PCL0L3L3@"D3L1L0P@A@L3@3L3LBH!!L1L3A@@D@3LCL3L0H"HQL3
LD@@PCL0L3L3@"H#D3L0P@A@L3@3L3LBH"D1L3A@A@L3LBL3L0H"D3LSLD@D@3L0H#L3@"D#L3D0P@PCL3LBH#LBHRL3L3A@A@L3L3@"H0H"H3L3LD@D@3L3
L H"@"H#L3L0P@PCL3L"@"HBH"L3L3A@A@H"H"H H H"H#L2HD@D@@H"H"HB@"H"H"H@P@ADP@H"H HBH"H @DQ@@@@DP@@"H@H"H@Q@@@@@@@@@Q@@B@ @D
P@@@@@@@@@@@AD@@Q@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 0 128 92 192 192 192 253 253 253 191 191 0]; mask:((ImageMask new) width: 28; height: 28; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@X@@@@G @@@A<@@@@_ @@@G<@@@G?@\@C?9? C????A????0_???<G????A????0_???<G????A????0????<O????C????0????<O????C????0????<O??
??C????0O???8@_?? @@?? @@A?@@@@a') ; yourself); yourself]
!

help28x28Icon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self help28x28Icon3 inspect
     ImageEditor openOnClass:self andSelector:#help28x28Icon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class help28x28Icon3'
        ifAbsentPut:[(Depth2Image new) width: 28; height: 28; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@0@@@@@@@@E0@@@@@@@AW@@@@@@@@U\@@@@@@@EU@@@@@@CQUT@@U@@ATUU@5UP@HUEUS=UWHBEQUT?UUR@!!TUUO5UT HUEUS=UUHBEQUT?5U
R@!!TUUO=UT HUEUS?UUHH5QUT?5URBETMUO=UT !!UTMS?UUHHUU<4?5URBEU_3O=UT  @W?C?U@HH?0O<?0O2B@?<CLC?0 J ??@?<B(@B O??0(@@@@(C<B
 @@@@@J@(@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 253 253 253 191 191 0 192 192 192]; mask:((ImageMask new) width: 28; height: 28; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@X@@@@G @@@A<@@@@_ @@@G<@@@G?@\@C?9? C????A????0_???<G????A????0_???<G????A????0????<O????C????0????<O????C????0????<O??
??C????0O???8@_?? @@?? @@A?@@@@a') ; yourself); yourself]
!

history28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self history28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#history28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class history28x28Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@0@@@@@@@@@B**(@@@@@@%YV@@@@@@J**"@@@@@BU%X @@@@@***H @@@@IVU"H@@@@B**("H@@@@%YVH"@@@@J**"H @@@@@@@"H@@@@B**("@@
@@@@@@H @@@@@***H@@@@@@@@B@@@@@@J** @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 0 129 194 194 194 255 255 255 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@C?8@@@?>@@@O?8@@C?>@@@??8@@O?>@@C??8@@??>@@O?? @C??8@@??>@@C?? @@??8@@C?>@@@?? @@C?8@@@?>@@@@@@@H@H@@BDB@@@<M3IHITI
KRBT"R$ %D$)8IVD2B@@@@G @@@@@@@a');
                            yourself);
                yourself
        ]
!

home28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self home28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#home28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class home28x28Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@DA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HCA@H@@@@@@@@@@@@@@@@@@@@@@@@@A@D@@@H@@0LD@ @@@@@@@@@@@@@@@@@@@@@@@@HA@@H@
@0TEAPPA@@@@@@@@@@@@@@@@@@@@@@@D@PH@@0XFA XGB@D@@@@@@@@@@@@@@@@@@@@@BP$@@0PDA@PDA@XD@P@@@@@@@@@@@@@@@@@@@@H@@0PDAP(CAPPD
A PA@@@@@@@@@@@@@@@@@@H@@0PDAP(@@@LEA@PDA@D@@@@@@@@@@@@@@@H@APPDAP@@@@@@@@TDA@XD@P@@@@@@@@@@@@HCA0PDAP@@@@@@@@@@APPDA@PA
@@@@@@@@@@HCAPPDAPL@@@@@@@@@@@LEA@PFA@D@@@@@@@@@@ HKA L@@@@LCP8O@@@@APXB@ D@@@@@@@@@@@@@@P\C@@@MDADRD0<@@@LF@ @@@@@@@@@@
@@@@@@HG@0@@EATVE1\N@@@CA H@@@@@@@@@@@@@@@@AA0L@@A QFQ([C @@@0\B@@@@@@@@@@@@@@@@@P\C@@@XE!!0]F08@@@LG@ @@@@@@@@@@@@@@@@DG
@0@@FAHWGQ,N@@@CA0H@@@@@@@@@@@@@@@@AA0L@@A ^E14[C @@@0\B@@@@@@@@@@@@@@@@@P\C@@@_GA4 F08@@@LG@ @@@@@@@@@@@@@@@@DG@0@@G2D[
F2HN@@@CA0H@@@@@@@@@@@@@@@@AA0TC@1<"H"H"C LCARLB@@@@@@@@@@@@@@@@C0DA@PDA@PDA@PDA@PDAC0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 224 224 224 0 0 0 32 32 32 192 192 192 64 64 64 160 160 160 96 96 96 128 128 128 96 64 96 64 32 64 224 192 224 32 0 0 160 96 64 128 64 32 96 32 0 64 0 0 160 128 128 224 192 192 192 160 160 160 64 32 128 96 96 224 224 192 224 192 160 192 128 64 128 64 64 224 160 128 192 128 32 160 64 0 192 128 96 192 96 0 192 160 128 96 32 32 192 64 0 160 96 32 128 32 0 128 96 128 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@C0@@@@<@@@@O@@X@C0@O@@<A''8@O@[?@C0G?8@<A??@O@_?8C0O??@<G??8OC???C1???8<O??<O@??<C0O??@<C??0O@??<C0O??@<C??0O@??<C0O?
?@<C??0O@??<C0@@@@<@@@@O@@@@C0@a');
                            yourself);
                yourself
        ]
!

imageEditor28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageEditor28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#imageEditor28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class imageEditor28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@M7]7]7]7]7]7]@@@@@@@@@@@@@@@@@@@@@@@@@"H"H"HDQEUVY @@@@@BH"H3L QDUUY&@@@@@@HA@#L2ADQUU&X@@@@@@"H"H"HH
"I&W]0@@@@@BL3L3L "H&Y]7@@@@@@H"H"H"BH"Y%7\@@@@@@#L3L3HDQEUVY @@@@@BH"H"H QDUUY&@@@@@@H3L3L2ADQUU&X@@@@@@"H"H"HH"I&W]0@@
@@@BL#L3L "H&Y]7@@@@@@H2L3L2BH"Y%7\@@@@@@"H"H"HBH"H"H @@@@@@@@@@@@@@@@@@@@@@@@H"H"H"H"H"H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@0@0@0L@L@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 127 127 127 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
???8@O??>@C??? @???8@O??>PC???&@???90O??>^C???''0???90O??>TC???  ???8HO??>AC??? P???8@O??>@C??? @???8@@@@@@@@@@@@;[7/@D>%
J@AJ)P @RK5.@D"%J@AH)R @:JW/@@@a');
                            yourself);
                yourself
        ]
!

menuEditor28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuEditor28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#menuEditor28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class menuEditor28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@DQDQDQDQDQDQD@@@@@@@@@@@@@@@@@@@@@@@@@QH"H DQHQD"H @@@@@ATBH"@RHBH H"@@@@@@H@H"HAT%UUUUT@@@@@@%H"H D%
IRT%IP@@@@@BUQIU@UIRT%IR@@@@@@IRHBHAIRT%IRT@@@@@@%H"H ERT%IRT @@@@@BUQIU@RT%IRT%@@@@@@IRHBHAT%IRT%H@@@@@@%H"H D%IRT%IP@@
@@@BUQIU@UIRT%IR@@@@@@H"HBHAIRT%IRT@@@@@@"H"H IRT%IRT @@@@@@@@@@@@@@@@@@@@@@@@H"H"H"H"H"H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@APT@@@@@@@@@@@@@@@@@T@@@@@@@@@@@@@@@@@@@@@@@@@T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@T@T@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 255 0 0 127 127 127 127 127 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
???8@O??>@C??? @???8@O??>PC???&@???90O??>^C???''0???90O??>TC???  ???8HO??>AC??? P???8@O??>@C??? @???8@@@@@@@@@@@@6=D$@O(Y
I@B*GRP@"9T$@H(WI@BJD2P@"=D<@@@a');
                            yourself);
                yourself
        ]
!

paste28x28Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self paste28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#paste28x28Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary paste28x28Icon'
        ifAbsentPut:[(Depth4Image new) width:28; height:28; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@!!DR@@@@@@@@@@@@@@@BDQH@@@@@@@@@@@@@@@DQDP@@@@@@@@@@@@@AD"H"D@@@@@@@@@ADQBDQDQDRQDP@@@@@@DQDHQDQDQIDQ@@@@@@@QD
QDQDQDQDQD@@@@@@ADQDQDQDQDQDP@@@@@@@@@@@@@ADQDQ@@DQDQDQDQDQDLDQDQD@@P3L3L3L3L3L QDQDP@ACL3L3L3L3L2ADQDQ@@DL3L3L3L3L3HDQD
QD@@P3L3L3L3L3L QDQDP@ACL3L3L3L3L2ADQDQ@@DL3L3L3L3L3HDQDQD@@P3L3L3L3L3L QDQDP@ACL3L3L3L3L2ADQDQ@@DL3L3L3L3L3HDQDQD@@P3L3
L3L3L3L QDQDP@ACL3L3L3L3L2ADQDQ@@DL3L3L3L3L3HDQDQD@@P3L3L3L3L3L QDQDP@ACL3L3L3L3L2ADQDQ@@DL3L3L3L3L3HDQDQD@@P3L3L3L3L3LJ
@@@@@@@2H"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 0 0 127 127 127 127 170 170 170 255 255 255]; mask:((ImageMask new) width:28; height:28; bits:(ByteArray fromPackedString:'
@@C8@@@@>@@@@O @@O??<@C???@@???0@O??<@C???A????0_???<G????A????0_???<G????A????0_???<G????A????0_???<G????A????0_???<G??
??A????0_???<G????A???@@_??0@@@a') ; yourself); yourself]
!

reloadFromFile28x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self reloadFromFile28x22Icon inspect
     ImageEditor openOnClass:self andSelector:#reloadFromFile28x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class reloadFromFile28x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@TEAPTEAPTEAP@@@@@@@@LC@0L@@0@@
@@@@@@@E@PDAAPDA@PT@@@@@@ @C@0LC@@H@@@@@A@@@APTEAPTEAPTE@@@@@@H@@0LC@0@B@@@@@@PD@@TA@PDE@PDAAP@@@@@B@@LC@0L@A@PDA@PDA@PE
APTEAPTEAPT@@@@@@ @@@@@@@@HDA@PDA@PDA@DA@PTA@PDE@@@@@@HB@ HB@ HDA@PDA@PDA@TEAPTEAPTEAP@@@@@B@ @@@@@@@ @@@@@DA@@E@PDAAPDA
@PT@@@@@@ H@@@LC@@H@@@@@A@@@APTEAPTEAPTE@@@@@@HB@@@C@0@B@@@@@@@@@@TA@PDE@PDAAP@@@@@@@@@@@@@@@@@@@@@@@@@EAPTEAPTEAPT@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 105 133 190 129 129 129 194 194 194 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:28;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@?>A?8O? _>C?8G?"?>A?8?? _???8G???>A???? _>O?8G?"?>A?8O? O>C?8@@@?>@@@@@@@@@@@@@@@@$@@@@G@@@@@@@@a');
                            yourself);
                yourself
        ]
!

reloadTextFromFile28x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self reloadTextFromFile28x22Icon inspect
     ImageEditor openOnClass:self andSelector:#reloadTextFromFile28x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class reloadTextFromFile28x22Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@TEAPTEAPTEAP@@@@@@@@LC@0L@@0@@
@@@@@@@E@PDAAPDA@PT@@@@@@ @C@0LC@@H@@@@@A@@@APTEAPTEAPTE@@@@@@H@@0LC@0@B@@@@@@PD@@TA@PDE@PDAAP@@@@@B@@LC@0L@A@PDA@PDA@PE
APTEAPTEAPT@@@@@@ @@@@@@@@HDA@PDA@PDA@DA@PTA@PDE@@@@@@HB@ HB@ HDA@PDA@PDA@TEAPTEAPTEAP@@@@@B@ @@@@@@@ @@@@@DA@@E@PDAAPDA
@PT@@@@@@ H@@@LC@@H@@@@@A@@@APTEAPTEAPTE@@@@@@HB@@@C@0@B@@@@@@@@@@TA@PDE@PDAAP@@@@@@@@@@@@@@@@@@@@@@@@@EAPTEAPTEAPT@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 105 133 190 129 129 129 194 194 194 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:28;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@?>A?8O? _>C?8G?"?>A?8?? _???8G???>A???? _>O?8G?"?>A?8O? O>C?8@@@?>@@@@@@@@@@@@@@@@$@@@@G@@@@@@@@a');
                            yourself);
                yourself
        ]
!

sUnit28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sUnit28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#sUnit28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class sUnit28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O??C???????C?<O?0@@??<O??????<O?0??@@@@@@@@@@@@@@@@@@@@@BH"H"H"
H"H"H#L3L0@@H"H"H"H"H"H#L3L3@@@"H"H"H"H"H#L3L3L@@BH"H"H"H"H#L3L3L0@@H"H"H"H@@@L1L3L3@@@"H"H"HO??<A@3L3L@@BH"H"HO???1@3L3
L0@@H"H"HO???1@@L3L3@@@"H"H <_?1@O@3L3L@@BH"H"C0G1@O<CL3L0@@H"H"HO@A@O?0L3L3@@@"H"H ?0@O??@3L3L@@BH"H#LO<O??@3L3L0@@H"H#
L3C???@3L3L3@@@"H#L3L0@@@3L3L3L@@BH#L3L3L3L3L3L3L0@@H#L3L3L3L3L3L3L3@@@#L3L3L3L3L3L3L3L@@CL3L3L3L3L3L3L3L0@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G??
?>A???? _???8G???>@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

saveImage28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveImage28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#saveImage28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class saveImage28x28Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UPSL3L0A@ET7L3L0?PAUML3L3OT@US\3L3C5@ET43L3L?PAUM3L3LO4@USSL3L3=@ET7L3L0?PAUML3L3O4@US\3L3C=@ET43L3L?PAUM@@@@O4@US?????=
@ET?UUUU?PAUO7??6?4@US=T?=+=@ET?ZO?Z?PAUO4C?6/4@U]U**)WU@ET@@@@@@@AUUUUUUUUU%Y%UUUTE%%UUUUTU)UEUUUUEUUUUUUVYUUTEUTUUUUDU
AUUUUUUQUPUUVUUUUUTU%P@a');
                colorMapFromArray:#[ 255 255 255 0 0 0 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
C???@@???0@O??<@C???@@???0@O??<@C???@@???0@O??<@C???@@???0@O??<@C???@@???0@O??<@C???@@???0@O??<@C??>@@@@@@@@@@@@;*9R<H*(
W)BJ*E:@S.9R,B)HT)@*REJP:$9R<@@a');
                            yourself);
                yourself
        ]
!

saveTextToFile28x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveTextToFile28x22Icon inspect
     ImageEditor openOnClass:self andSelector:#saveTextToFile28x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class saveTextToFile28x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3L3L3L@@@@@@@@@@@@CQDMDP0
@@@@@EUUAP@@L3L3L3@@@ @PUUTA@@@4QCQDL@@BHAAUUPD@@CL3L3L"H"H"DEUU@P@@MDP4QCH"H"H @@@A@@@3L3L3H"H"H!!DQDQD@@CQDMDP0@@H DP@@
@P@@L3L3L3@@@ @Q@ETA@@@4QCQDL@@@@AD@UPD@@CL3L3L0@@@E@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 129 129 129 255 0 0 255 255 255 105 133 190 194 194 194 ];
                mask:((ImageMask new)
                            width:28;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@G?0@@A?<G? _?A?8G?1_>A?<_? _???8G???>A???? _?G?8G?1_>A?<G? _?@?8G?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

saveToFile28x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveToFile28x22Icon inspect
     ImageEditor openOnClass:self andSelector:#saveToFile28x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class saveToFile28x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3L3L3L@@@@@@@@@@@@CQDMDP0
@@@@@EUUAP@@L3L3L3@@@ @PUUTA@@@4QCQDL@@BHAAUUPD@@CL3L3L"H"H"DEUU@P@@MDP4QCH"H"H @@@A@@@3L3L3H"H"H!!DQDQD@@CQDMDP0@@H DP@@
@P@@L3L3L3@@@ @Q@ETA@@@4QCQDL@@@@AD@UPD@@CL3L3L0@@@E@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 129 129 129 255 0 0 255 255 255 105 133 190 194 194 194 ];
                mask:((ImageMask new)
                            width:28;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@@@@@@@@@@@G?0@@A?<G? _?A?8G?1_>A?<_? _???8G???>A???? _?G?8G?1_>A?<G? _?@?8G?0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

search28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self search28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#search28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class search28x28Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@J @@@@H@@B(@@@@B@@@*@@@@@@@@@@@@@@@@@@@@@@@H@@B@@@@@B@@@ @@@@@ @@H@@@@@@@@@@@
@@AT@D@P@@@@U@B@D@@@@EP@ A@@@@AT@H@P@@@@*@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@P@@H@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 40 40 80 212 208 200 255 255 255 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@_A<@@G0_@@A<G0@@_A<@@G0_@@O>?8@C?/>@@?;? @O>?8@G???0O???>C???? ????8O???>C???? ??/?8O?;?>C?>?? ?8@?8O>@
O>C? C? ?8@?8O>@O>@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

shell28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self shell28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#shell28x28Icon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class shell28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L3L3L3L3L3L3L3L3L0@1DQDQDQDQDQDQDQDQ@CD"H"H"H"H"H"H"H#D@LRH"H"H"H"H"H"H"LP@1H"P"H"
H"H"H"H"H1@CD"QDH"H"H"H"H"H#D@LRP$IBH"H"H"H"H"LP@1ICP"H"H"H"H"H"H1@CD"QDH"H"H"H"H"H#D@LRH4IBH"H"H"H"H"LP@1IBP$H"H"H"H"H"
H1@CD"QDH"H"H"H"H"H#D@LRH$H"QDP$QDIDQBLP@1H"H"H"H"H"H"H"H1@CD3L3L3L3L3L3L3L3D@@QDQDQDQDQDQDQDQDP@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 125 125 125 194 194 194 222 222 222 0 0 194 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G???>A???? _???8G???>@???? @@@@@@A@E@@@PAP@@7&T@@QJ
U@@BR=P@@T(T@@YI%@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

systemBrowserClassHistory28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self systemBrowserClassHistory28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#systemBrowserClassHistory28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class systemBrowserClassHistory28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@ADQDQDQG0@@@@@@@@@@D"H"H"H.@@@@@@@@@@@RH"H"H"8@@@@@@@@@@O;.;.;.; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8@@@
@@@@@@@@@@@@@@C @@@@@@@@@@@@@@@@@N@@@@@@@@@@@@@@@@@@@@@@@@DQ@@@QG0@@@@@P;.;.@SL@@CL>@@@@@@@@@@@O; @@;.8@@@@@8@@@@@@@@@@@
@@@@@@C @@@@@@@@@@@@@@@@@N@@@@@@@@@@@@@@@@@@@@@@@@DQ@@@QG0@@@@@P;.;.@VX@@FY.@@@@@@@@@@@O8@@@C.8@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C @@@@8@8@@N@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8@@@8@8@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
??0^@O?<O0C??FF@??1!! O?<XXC??CF@@ @C@@H@A @B@>7 A0O[8@_?6>@G@=/ @ O[8@H@@@@B@<O A0O[8@_??>@G@;7 @@NY8@@@@@@@@@@@%]7/TITI
JUBUBR%P=H$/TIQIJRBTRR$ %\'')P@@a');
                            yourself);
                yourself
        ]
!

uiPainter28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self uiPainter28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#uiPainter28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class uiPainter28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@DQDQDQDQDQDQD@@@@@@@@@@@@@@@@@@@@@@@@@3H"H DQHQD"H @@@@@CLBH"@RHBH H"@@@@@@H@H"HAT%UUUUT@@@@@@%H"H D%
IRT%IP@@@@@BUSMU@UIRT%IR@@@@@@IRLBHAIRT%IRT@@@@@@%H"H ERT%IRT @@@@@BUSMU@RT%IRT%@@@@@@IRLBHAT%IRT%H@@@@@@%H"H D%IRT%IP@@
@@@BUSMU@UIRT%IR@@@@@@H"LBHAIRT%IRT@@@@@@"H"H IRT%IRT @@@@@@@@@@@@@@@@@@@@@@@@H"H"H"H"H"H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@T@AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@T@@@AP@E@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 255 0 0 127 127 127 127 127 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
???8@O??>@C??? @???8@O??>PC???&@???90O??>^C???''8???90O??>TC???  ???8HO??>A#??? X???8@O??>@C??? @???8@@@@@@@@@@@@>QN@@H$Q
@@BADP@@.QD@@H$Q@@BIDP@@>_N@@@@a');
                            yourself);
                yourself
        ]
!

workspace28x28Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self workspace28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#workspace28x28Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary workspace28x28Icon'
        ifAbsentPut:[(Depth4Image new) width:28; height:28; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@M7]7]7]7]7]7]7]@@@@@@@@@@@@@@@@@@@@@@@QDQDQDQDQDQDQ@0@@@AUPUUUUAUAQDQDB@@@@EUAUUUTE@@DQDPH@@@@P@E@@UP
UPTQDQ@ @@@AAPTEAUAUAQDQDB@@@@D@AP@ETET@DQDPH@@@@QDQDQDQDQEADQ@ @@@ADQDQDQDQDTPQDB@@@@DQDQDQDQDQQDDPH@@@@QDQDQDQDQEDDQ@J
@@@ADQDQDQDQDQEADB@@@@DQDQDQDQDQDTDPH@@@@QDQDQDQDQDQDQ@0@@@@@@@@@@@@@@@@@@@@@@L"H"H"H"H"H"H0L@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@@L@@C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@@L@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255 170 170 170 127 127 127 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127]; mask:((ImageMask new) width:28; height:28; bits:(ByteArray fromPackedString:'
????@O???0C???<@????@O???0C???<@????@O???0C???<@????@O???0C???<@????@O???0C???<@????@O???0C???<@????@@@@@@@@@@@@ //R@HJJ
T BB"%P@$(/X@IJJU@BR"%H@[O)R@@@a') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-28x28-XP'!

eraseXP28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self eraseXP28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#eraseXP28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class eraseXP28x28Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GNB!!GL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A="H"F[0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@^(VE!!XM/@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@A8^7-;_F<@@@@@@@@@@@@@ H%3@@@@@@@@@@@@@GQ5]WU6ZP@@@@@@@@A%_8^B@@@@@@@@@@@@@@@@[WA0\GE)@@@@@@A)
_(E9@@@@@@@@@@@@@@@@@@A$Y&Y&Y5(@@@A.]7]2@@@@@@@@@@@@@@@@@@@@@E%GQ4]HV A([F1-@@@@@@@@@@@@@@@@@@@@@@@@R3(:N#-IVE!!$@@@@@@@@
@@@@@@@@@@@@@@@@@@ALLB</K3)J@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C\(JB *SP@@@@@@@@@@@@@@@@@@@@@@@@@@S2,%IRD!!HRX?@@@@@@@@@@@@@@@@
@@@@@@@@O"H\GA04H1,[GS8@@@@@@@@@@@@@@@@@@@@@LQ(WE1\5@@@_E!!XXO @@@@@@@@@@@@@@@@@@IALSD1L-@@@@@B@SD1T=@@@@@@@@@@@@@@@@E@4M
CP4-@@@@@@@@G!!DQD#0@@@@@@@@@@@@@B0$IBP,2@@@@@@@@@@@,C 8PO@@@@@@@@@@@K PDA@\6@@@@@@@@@@@@@B\JB <8@@@@@@@@@@@B@@H3@@@@@@@@
@@@@@@@@K XCA#X@@@@@@@@@NR$9@@@@@@@@@@@@@@@@@@@8APDH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CXLFP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 209 43 1 210 43 1 211 55 15 212 43 1 212 44 1 212 55 15 214 55 15 214 56 15 214 68 29 215 44 1 216 44 1 217 56 15 217 91 57 218 44 1 218 45 1 218 56 15 219 56 15 220 45 1 221 57 15 222 45 1 222 81 43 223 57 15 224 46 1 225 46 1 225 58 15 225 140 112 226 58 15 227 47 1 228 47 1 228 58 15 228 118 85 229 95 58 229 118 85 230 47 1 230 70 29 230 83 44 230 131 99 231 47 1 231 59 15 231 165 140 232 47 1 232 190 168 233 59 15 233 107 72 233 166 140 233 166 141 233 190 168 234 48 1 234 60 15 234 166 142 234 190 168 234 201 182 235 154 128 235 166 142 235 201 182 236 120 86 236 201 182 236 214 196 237 49 1 237 60 15 237 201 182 237 202 182 237 202 184 238 203 184 238 227 210 238 236 222 238 236 223 238 236 224 238 237 222 238 237 223 238 237 224 239 49 1 239 61 15 239 85 44 239 133 100 239 167 142 239 179 156 239 203 184 239 227 210 239 227 213 239 236 223 239 237 223 239 237 224 239 238 223 239 238 224 239 238 225 239 238 226 239 238 227 240 49 1 240 155 128 240 203 184 240 227 213 240 237 223 240 238 223 240 238 226 240 239 226 240 239 227 240 239 228 240 240 226 240 240 227 241 121 86 241 227 213 242 49 1 242 61 15 242 121 86 242 203 184 242 227 213 242 229 214 243 49 1 243 121 86 243 167 142 243 205 185 244 50 1 244 62 15 244 121 86 244 206 185 245 86 44 246 50 1 246 62 15 247 50 1 247 86 44 247 122 86 247 134 101 248 51 1 248 63 15 248 122 86 249 75 29 249 98 58 249 147 114 250 51 1 250 111 72 251 63 15 251 99 58 252 51 1 252 63 15 253 52 1 254 52 1 255 52 1 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@A8@@@@_@@@@G8@@@@?@C @G8C0@@?A8@@G8<@@@?^@@@G?@@@@? @@@G8@@@G?@@@C?8@@A>_@@@?C8@@_ _@@O0C8@G8@_@@<@
C8@N@@^@@@@C @@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

redoXP28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redoXP28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#redoXP28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class redoXP28x28Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[E1QR5Q][P@@@@@@@@@@@@@@@@@@@@@@@@@@WC8RG2<!!
FTAX[P@@@@@@VDIFX0@@@@@@@@@@W@HXHBT(KS@2F$U''@@@@@C-RT40@@@@@@@@@ZC<XF1 PC1P''K#D.A%,@@@@:ST=J@@@@@@@@@E@QF1 BU6IYQA@,K2<L
V0@@NT]IR @@@@@@@@@?F1,GV0@@@@AV@2H.LP9[@@,8PT(@@@@@@@A(AQ,[P0@@@@@@@FH>GR,/CU,JM#]J@@@@@@@@XP,[F4,@@@@@@@@@YS8\JB4MBCP5
R @@@@@@@FPGF1-H@@@@@@@@@@A&O!!,%J"\1L4(@@@@@@@@@@Q,[AV(@@@@@ZVI"XU$@E2P&KB=J@@@@@@@@@D8VF0=T@@@@YS<KB0,KB1T\HRT)R @@@@@@
@@A[A1,[@V(@@EXQF1,[F1,[F1,^H4(@@@@@@@@@@DLVF1MK@@A_AALSD1LSD1LSD1MJ@@@@@@@@@@A^AQ,[BUT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D(Q
F1,BV @@@@@@@@@@@@@@@@@@@@@@@@@@@@A+OQX[F@IZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F@BFA,X@%(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@V HXF05P
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AZ@!!EHZ0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E(<Z0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 1 55 156 1 58 159 1 62 163 1 64 165 1 65 166 1 68 169 1 69 170 1 71 172 1 74 174 1 74 175 1 75 176 1 78 179 1 79 180 1 81 182 1 82 182 1 84 185 1 86 187 1 87 188 1 88 189 1 90 191 1 92 193 1 93 194 1 97 198 1 98 199 1 100 201 1 101 201 1 102 203 1 103 204 1 104 205 1 105 206 1 106 207 1 109 210 1 110 211 1 111 212 1 112 213 1 114 215 1 115 216 1 116 217 1 118 219 1 119 219 1 119 220 1 120 221 1 123 223 1 123 224 1 126 226 1 127 227 1 128 228 1 129 229 1 129 230 1 130 231 1 135 236 1 138 240 1 140 242 1 143 245 1 149 251 1 153 255 3 154 255 6 79 179 13 82 179 15 76 172 16 64 158 16 66 161 16 67 162 16 70 164 16 75 169 20 160 255 23 78 172 31 79 166 31 80 167 31 81 168 33 82 171 34 164 255 46 87 167 54 171 255 61 98 171 61 99 171 61 99 172 68 176 255 76 110 176 85 181 255 91 122 180 91 123 181 99 186 255 102 174 242 106 134 185 120 145 189 120 145 190 120 146 190 121 146 191 135 156 194 150 168 196 150 168 198 151 169 198 151 169 199 165 180 201 165 180 203 180 192 205 180 192 207 180 192 208 181 193 208 195 203 212 195 203 213 195 204 212 196 205 213 210 214 216 210 214 217 210 215 217 225 226 219 226 228 222 226 228 223 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@A?@@@@?<G @_?!!8@O?<^@C??'' @>G=8@_@?>@G0G? A<@?8@O!!?>@C8?? @?O?8@G3?>@A>@@@@O0@@@C>@@@@_0@@@C<
@@@@_@@@@C @@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

undoXP28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self undoXP28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#undoXP28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class undoXP28x28Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F5]UD-QWF0@@@@@@@@@@@@@X4YBV@@@@@@@
[U!!@FRD/G1H>W@@@@@@@@@@@@D1ST#,@@@@@Y4TZL#@-JBT F@I\@@@@@@@@@@AJS44:@@@@V0X.LR8''E@<PFA,XO6 @@@@@@@@@R$%GNP@@V00/K20PQE%"
U0HXF1EP@@@@@@@@@D)AN@,@V081K"HCU @@@@A[A1,[O0@@@@@@@@AJM3XJV04/J14>X @@@@@@@DL[F0U(@@@@@@@@R#T4B@4-JA0>YP@@@@@@@@AKF1,K
XP@@@@@@@D(3LR\*IQ,>Y @@@@@@@@@@RA,[A6P@@@@@@@AJK20&IA\@VVE"X&$@@@@@Z T[F0D@@@@@@@@@R"$%HQ0UB0,KB0,?YP@@@EPOF1YN@@@@@@@@
@D(#G!!,[F1,[F1,[DUX@@F(AF1,GV0@@@@@@@@AJD1LSD1LSD1LSD0Q_@@AKD1,VP0@@@@@@@@@@@@@@@@@@@@@@@@@@@@AUBQ,[AU8@@@@@@@@@@@@@@@@@
@@@@@@@@@@AZ@!!,[DT(@@@@@@@@@@@@@@@@@@@@@@@@@@@AZ@!! [E#5+@@@@@@@@@@@@@@@@@@@@@@@@@@AZ@!! [F@I @@@@@@@@@@@@@@@@@@@@@@@@@@@@
T@4[F@IZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F-HDPIZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Z31Z@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 1 55 156 1 58 159 1 62 163 1 64 165 1 65 166 1 68 169 1 69 170 1 71 172 1 74 174 1 74 175 1 75 176 1 78 179 1 79 180 1 81 182 1 82 182 1 84 185 1 86 187 1 87 188 1 88 189 1 90 191 1 92 193 1 93 194 1 97 198 1 98 199 1 100 201 1 101 201 1 102 203 1 103 204 1 104 205 1 105 206 1 106 207 1 109 210 1 110 211 1 111 212 1 112 213 1 114 215 1 115 216 1 116 217 1 118 219 1 119 219 1 119 220 1 120 221 1 123 223 1 123 224 1 126 226 1 127 227 1 128 228 1 129 229 1 129 230 1 130 231 1 135 236 1 138 240 1 140 242 1 143 245 1 149 251 1 153 255 3 154 255 6 79 179 13 82 179 15 76 172 16 64 158 16 66 161 16 67 162 16 70 164 16 75 169 20 160 255 23 78 172 31 79 166 31 80 167 31 81 168 33 82 171 34 164 255 46 87 167 54 171 255 61 98 171 61 99 171 61 99 172 68 176 255 76 110 176 85 181 255 91 122 180 91 123 181 99 186 255 102 174 242 106 134 185 120 145 189 120 145 190 120 146 190 121 146 191 135 156 194 150 168 196 150 168 198 151 169 198 151 169 199 165 180 201 165 180 203 180 192 205 180 192 207 180 192 208 181 193 208 195 203 212 195 203 213 195 204 212 196 205 213 210 214 216 210 214 217 210 215 217 225 226 219 226 228 222 226 228 223 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@? @G ?<@A8_? @^O?<@G''??@A;>G0@_?@>@G? O A?0C8@_?!!<@G?<_@A??O0@_?38@@@A>@@@@?@@@@_0@@@O8@@@C
<@@@@>@@@@G@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-32x32'!

desktop32x32Icon
    <resource:#programImage>
    ^ self desktop32x32Icon2
!

desktop32x32Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self desktop32x32Icon1 inspect
     ImageEditor openOnClass:self andSelector:#desktop32x32Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary desktop32x32Icon1'
        ifAbsentPut:[(Depth8Image new) width:32; height:32; bits:(ByteArray fromPackedString:'
.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*7 G>W@@B3.+*:.+*:.+*:.+*:.+*:.+*:DHA?%89"##VTAY$"
#3F3.+*:.+*:.+*:.(@O%6T@#$1LAP.YNZ(B"V\$IBROP'':&.+*:&I\[@JQ#SIPK&P5PBQ$Y$W&T,QXV*S\7M8=U_)>:.#J,B9$9NR@FFSBQ+IR1E+*:.+*:
.+(V]#P7#5U>'';*:R3$7MCP]$[F:.+*:.+*:.+*:.+*:.+(P\#Q7UW:_.+*LHA4]GU._!!8^G!!8^G!!8^G!!39PMB^G!!8\P\#AVNI>:.(07W5>F+(^G!!8^G-KDJ
RE=HHC$ $Y2G!!8^VJ1P8'';*:#BB"F)FG!!8^GW4 7TC::.''@VE 6Q''H^G!!8\+!!BF2@K*$HA)2&8NC 8M_.+*:.+)0E!!X*CYF\ 8NCT3= $ \:@JQ''[8BC 8NC
 5>:.+*:\AXVJ"*A$Y2[%+!!Y[PN''*0QS#F]I 8NC 8NCW;*:.''@VE"(*I8FQWE2QCT9>G)N((G:PM:2C 8NC 8M_.+)0E!!X*J"^/]#A(O" $LF2ZZ+U8,9A''
^8NC 8NC 5>:\AXVJ"(''XS@(O(E(LDT5"C,.NKL@^&]; 8NC 8NCW7@VE"(*I7D<ZHF-.K!!=&8NHDW"3.+):_A^C 8NC 8M_E!!X*J"]D(6&8.DEQ 8NC 7J]
R+N:.''*)]BT%IRT%IU<VJ"(''I2A_+)ZA$P %IRT%]@98,;*:^*$WIRT%IRT%W2(*I2\SO%=_Y06QBBT%IRU\C''"3.+)?#4&\''I2\''I1_J"\''D38>TA47Y9DH
''I2\Y(TN^KN:.)!!7E92\''I2\''E<''I1L>O#8MY3]P$P"\''HH+!!P98,;*:C268''I2\''I2\W2\SO#8>CP6ATEBQBI2\L8VEC''"3.+(OKR.\''I2\''I1_O#8>O 4J
M55FK8(#''FZH"H N^KN:. <-.I2\''I2\''E=_W5>K\2<XYBLL''I2BQV9.[ 98,;*:."5ERXJ\''I2\,A0ASP #T)2\''I1QS8=WV$AXZ7"3.+*:P2-WWEQRT%IR
CEIRT%ITY#V%U5]@C!!D)&"18_ B:.+*MEU]WJ9URT%IR%T<3.U]ZD!!DTJ[T.^CX8O[L@.+*:.%)5V%)Z(W,5)U]ZPE QZ9(,W'' 6_%N3@@B:.+*:.+*:P7U@
PDA@PAHN!!BZ5KE8_NC5S,0@@@K*:.+*:.+*:.+*LU1IXDXR6(B98M )S,;N_.+*:.+*:.+*:.+*:.+*:.)9DQ21^^C!!>T;L@@K*:.+*:.+*:.+*:.+*:.+*:
.+*:@KM>[UN3@JZ:.+*:.+*:.+*:.+*:.+*:.+*:. @@@@@a') ; colorMapFromArray:#[80 128 180 208 192 110 96 176 220 144 32 30 144 96 100 144 208 220 96 176 240 176 32 20 255 224 140 128 192 240 192 192 180 160 208 240 255 240 180 176 224 255 16 64 130 192 192 220 208 224 240 32 64 130 0 48 140 208 224 255 48 64 130 16 96 190 240 240 255 80 160 210 240 208 100 80 160 220 48 160 255 96 128 180 176 208 180 80 176 255 160 128 130 160 144 140 128 208 255 160 80 100 176 240 255 255 224 160 144 192 255 255 255 210 64 80 100 208 240 255 176 208 255 64 80 110 224 240 255 16 112 210 112 112 110 32 96 190 112 112 130 192 192 130 64 144 220 128 144 160 80 112 180 80 144 210 96 192 255 112 160 210 160 160 160 112 192 255 176 176 180 160 224 255 192 176 180 32 64 110 80 112 110 192 192 210 192 224 255 80 112 130 0 64 160 48 128 190 80 96 130 16 80 180 112 128 140 32 112 210 144 192 180 96 96 130 80 192 255 96 160 210 160 160 140 80 112 190 96 144 210 240 208 130 144 160 190 144 176 210 144 208 255 192 208 210 255 240 190 208 208 210 224 224 210 80 96 110 48 80 130 0 80 180 16 48 140 80 128 160 0 64 180 32 128 220 48 128 210 112 192 210 128 128 130 64 176 255 144 48 50 112 160 190 96 128 190 80 128 210 255 224 130 112 128 190 176 208 210 128 192 255 128 176 240 128 112 60 80 80 80 48 80 110 64 112 140 208 192 210 0 96 190 16 128 220 240 255 255 144 128 100 48 144 220 144 176 160 64 144 210 16 96 210 48 128 220 48 112 210 144 144 140 112 176 220 112 144 190 128 176 210 96 144 220 160 192 210 192 192 190 144 160 210 192 208 220 160 208 255 240 240 210 255 255 220 48 64 110 0 112 210 32 144 220 255 255 240 0 96 210 64 160 220 224 208 110 128 192 190 48 96 180 16 64 180 80 128 190 64 128 210 64 96 180 96 160 220 208 80 30 160 16 20 144 192 220 192 208 190 160 192 220 128 144 210 176 192 220 192 240 255 80 96 100 240 240 220 255 240 210 16 64 140 208 208 220 240 240 240 112 96 100 0 80 190 48 176 255 16 16 0 64 112 180 64 128 190 255 240 255 208 96 30 144 16 20 80 144 220 128 208 240 192 48 20 128 176 220 112 176 240 176 208 220 144 192 240 224 240 210 192 224 240 208 176 180 224 224 220 224 240 240 96 96 100 80 80 100 224 224 240 32 128 210 32 112 190 255 255 255]; mask:((ImageMask new) width:32; height:32; bits:(ByteArray fromPackedString:'
@@@@@@@@A?@@@??8@_??>G????#????8????>O????#????8?????O????;????????????????????>?????O????3????<?????O????3????<?????O??
??3????<_????G????!!????0_???@G??<@A??8@@_>@@@C8@@@@b') ; yourself); yourself]
!

desktop32x32Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self desktop32x32Icon2 inspect
     ImageEditor openOnClass:self andSelector:#desktop32x32Icon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class desktop32x32Icon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N@@BN#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N
#(:N#(8@@H:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N# @@-;^7-;^7VJB (BX*PTD&(GH-Q@@.@DRHI!!LNMVL9@@@2L ];^18[F6^._:-PTI.[ 8LO
,6,=UI>G[6>"(#T@@CJ$)WZSSI\JB&@FRYA5#X6M]WU4^G DAE:(*J!!0NP@@A4^PA)\JB (J%G18$YF''$S@0^J**_G%$ST46XW@9@@A;FT&TH"H"H!!<H+D)J
L4(\AYV)$)I=_VUNS#\KV3$@@G.P+9 " HA(TYT\GA0\AR@IBZ6VN&U>Y&X#S4=[C @@^4&TH+J@,%DLHC !!NB@ BP&0,G9>Y&ZY XFAZQXN@@@^A)P" HA(
+R@8HS  HEIR,KA:_#.Y&XFAIF%)VP8@@A- %2J2ZJ4LNBD!!HB@MT%J0,G9>&Y&Y XE)ZV&LC @@F6@JH&!!QCC !!HRD H@5RT+B0_'':Y&XFA V%)''H0N@@A''
S@("T[D8HRD!!HR@ T%J0,G)>N9&Y XFAZV&\E08@@J9L%1>RHBD!!HRD!!HBART+B0_'':Z&Y&A V%)ZXQ]C @@_42W )T!!HV(!!HR@ CUIR,KA>_)&YT8FAZV%)
!!K),@@A?XIPHGC1*X"D!!HBART%J0^''8;&Y&A XE)ZY2D@F0@@J- +:0%R6)"HRD HEIR,KA>_)*Y&XFAZV%)!!HPA[@@@TFA<URUKZ"D!!O"@MT%J0,G9>&Y%S
 XE)ZV&D!!@E,@@APA''",IT-*HRD HEIRT+B0_'':Y&XFA V%)''HRD@ 8@@I-II1@P-FH!!HR@ T%J0,G9>&)&Y XE)ZV&D!!HPBC @@&96&#4U7!!V5-U%X?O3<?
JHVE!!XVE!!QDQDQDQDPHN@@@R-TZ^P(*]W5=_W5=HRCP4MCP4LSD]GQ4]GQ4]K08@@HNFQZLXJ5=.EAPTEK"!!(ZF!!(ZF!!(X.K"X&I"X$ZC @@ 0M1U4@)\;Z6
-+YZV$MCP4MCP20UEV9.[&9.[!!(N@@A+Z6,=UI>G[6>"(''A0V1YY#A]]W[(@@PHB@!!(ZF 8@@KV5NP:9(E1D@@B:KWH&D08NC 8NC 8NC 8NC 8NC @@#(:N
#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N@@BN#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(8@@H:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 239 239 240 239 239 255 240 240 255 111 112 128 64 112 191 48 112 208 79 112 191 95 111 176 64 112 208 63 127 223 95 128 207 95 144 223 63 112 223 48 112 224 175 176 191 144 160 207 112 159 208 159 175 191 143 144 207 191 191 207 47 63 95 47 48 80 208 208 224 223 224 240 255 208 64 48 95 176 255 255 255 96 127 176 48 111 208 127 143 160 96 112 176 80 127 208 48 112 223 47 111 223 95 128 208 95 144 224 95 160 240 47 96 208 192 207 208 111 144 208 144 160 176 16 143 191 192 192 208 15 127 191 32 48 80 223 223 224 239 240 240 240 255 255 48 111 191 112 143 160 80 111 176 47 111 207 112 128 160 160 175 176 80 128 207 80 144 223 48 111 223 160 175 191 79 128 223 79 143 240 47 96 223 160 175 208 47 112 223 143 159 176 0 175 224 192 192 207 96 176 31 32 48 64 224 224 224 47 128 191 63 143 191 32 80 175 112 128 144 64 111 191 48 111 207 32 96 208 95 127 191 79 128 207 80 143 223 95 159 224 127 143 191 79 127 223 63 127 224 80 159 240 160 176 208 48 96 207 143 159 191 15 159 208 207 208 208 208 223 224 32 47 64 207 208 224 223 223 223 224 224 240 64 127 191 111 127 144 80 127 191 80 143 207 32 111 223 159 175 176 79 127 207 79 143 223 80 144 224 111 127 191 80 128 223 96 160 240 32 96 223 159 175 208 176 176 191 128 159 191 47 63 80 176 191 223 192 207 224 48 111 144 208 208 223 64 80 111 48 111 176 48 96 176 64 111 176 79 128 176 63 111 191 64 127 207 64 143 224 95 112 176 64 112 207 79 128 208 79 143 224 112 128 191 95 143 223 95 159 240 79 127 208 143 159 207 111 175 255 144 160 191 144 144 175 175 191 223 208 223 223 63 79 95 31 112 175 63 64 95 223 223 240 47 96 176 0 0 0 63 144 208 63 96 176 48 96 191 64 127 208 80 112 191 80 127 207 63 112 208 64 128 223 95 127 207 95 127 208 80 144 240 79 144 240 128 144 207 96 160 255 144 159 176 224 48 0 175 176 208 207 207 208 48 64 95 191 192 223 15 160 240 31 79 160 47 95 175 96 144 176 47 96 191 79 127 191 63 127 208 63 112 207 112 143 191 63 111 207 64 127 223 111 128 191 79 112 207 64 128 224 64 112 223 95 128 223 144 160 208 95 143 224 159 160 176 31 47 64 208 208 208 48 63 95 191 192 207 224 239 240 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@G????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''??
??9????>_????''????9????>_???? @@@@@@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

error32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self error32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#error32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class error32x32Icon'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@A@PDA@PDA@PD@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@A@PDA@PDA@PDA@PDA@PDA@P@@
@@@@@@@@@@@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@A@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@P@@@@@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@@@DA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@@PDA@PHB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@PDA@P@A@PDA@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HA@PDA@@DA
@PDB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ DA@PD@@PDA@PHB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@PDA@P@A@PDA@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HA
@PDA@@DA@PDB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ DA@PD@@PDA@PHB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@PDA@P@A@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@@@A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@DA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@P@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@PD@@@@@@@@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@
@@@@@PDA@PDA@PDA@PDA@PDA@PD@@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PD@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@PDA@PDA@PD@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 0 0 255 255 255]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@A?0@@A??@@A??<@@??? @_??<@O??? G???<C???? ????8_????G????3????>?????/????;????>?????/????;????>?????/????9????<_????C??
?? ????8G???<@???>@G???@@??? @G??0@@_?0@@A?0@@@@@@@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-misc'!

DirectoryUp22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self DirectoryUp22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#DirectoryUp22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary DirectoryUp22x22Icon'
        ifAbsentPut:[(Depth4Image width:28 height:28) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@QD@@@@@@@@@@@@@@@@QDQ@@@@@@@@@@@@@@@QDQ
DP@@@@@@@@@@@@@QDQDQD@@@@@@@@@@@@@@ADQ@@@@@@@@@@@@@"H DQD@@@@@@@@@@@@@@@@QDP@@@@@@@@@@@@@@@ADQ@@@@@@@@@@@@@"H DQD@H"H"H"
H@@@@BH"@QDP@"H"H"H @@@@H"HADQ@@@@@@@B@@@@@"H DQDQDQDQD@H@@@@BH"@QDQDQDQDP@ @@@@H"HADQDQDQDQ@B@@@@@"H DQDQDQDQD@H@@@@BH"
@@@@@@@@@@@ @@@@H"H@@@@@@@@@@B@@@@@"H"H"H"H"H"H"H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 255 0 0 255 255 0] mask:((ImageMask width:28 height:28) bits:(ByteArray fromPackedString:'
@@@@@@@0@@@@^@@@@O0@@@G>@@@C?0@@A?>@@@??0@@_?>@@G?8@@C???>@???? O???8C???>@???? O???8C???>@???? O???8C???>@???? O???8C??
?>@???? @@@@@@@@@@@@@@@@@@@@@@@a'); yourself); yourself]
!

desktop30x30Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self desktop30x30Icon inspect
     ImageEditor openOnClass:self andSelector:#desktop30x30Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary desktop30x30Icon'
        ifAbsentPut:[(Depth8Image new) width:30; height:30; bits:(ByteArray fromPackedString:'
.+*:.+*:.+*:.+*:.+*:.+*3T788,5MST5N^.+*:.+*:.+*:.+*:.+*_,;MSB#Z3T788,5MST5MS@K*:.+*:.+*: @>3T34@,;MSB#Z3T788^E8,Q4QS@JZ:
&I\[@KMS_#X@T348,;MSB#Y8K*B6!!AEXD%^L@@B:+C48M AS_#Y8T348G58,-RZDC!!I@PDA@PGUC@@B:^C48M''!!S_#Y8W"2ZZ1EXPE)W)SU;%YVU%WUZ@@B:
^C4=NG .-R$TDQIZU;$3S9URT%IRT%IRT!!VM@@B:^G ,&!!DNPE]W)SU&UEIRT%HLT%IRT%IRT"-C@I>:U5]WPH>OS5F\T%IRT%HH""@ $YF\!!8^G!!2.DH[H@
U5^O 8NC 8MRT%HH"%APO#8VCYF\ 8NCT3= $ \:U5]/ 8NC 8M_RC]PO+)0E!!X*CYF\&9Z8VV4C):,DU5^O 8NC 8M_.+*:\AXVJ"('' YE\WIDMS''8^$:"J
U5^O 8NC 8M_.+)0E!!X*J"^/]#A(O" $LF2ZZ+T@U5^O 8NC 8M_.''@VE"(*I6D0JC:AZCAEMX ;@@@@U5^O 8NC 8M_\AXVJ"(''\S1( Z68.G6[ 8 Q@@@@
U5^O 8NC 8M_E!!X*J"]D(6&8.DEQ 8NC 7J]@@B:U5^OIRT%IRU_E"(*I2\ W::V YDHIRT%IWPN@@B:U5^OIRT%IRU_J"(''I1L>W5=''CYDHIRVCIU0N@@B:
U5^O''I2\''I1_J"\''D38>TA47Y9DH''I2C 8TN@@B:U5^O''I2\''I1_I1L>O#8MCXEPTIDH''I2B 8TN@@B:U5^8''I2\''I1_O#8>O 5_M5=FK8(#''I2C 8TN@@B:
KR4+''I2\''I1_O#9_"7L/FFP#CI2\ %EQ[&8N@@B:KR68T%J\''I1_W5=MBBMRT%IRCEEO#5]ZPE!!+@@B:P4L+T%IRT%IRCEIRT%ITY#V%U5]@C!!D)&"18@@B:
#X4UT%IRT%IRT)UOL;%WV!!HQEB&5K'' 6NC58@@B:V%)5%YVU^3V%U5)@VAE+&"1^^CY>T;L6NC4@@K*:P4M5PDA@PAHN!!BZ5KE8_NC5S,3Y>T;L@@K*:.+*:
#H1WD!!FD-*@.^CXJT;N3''35S,0@@@K*:.+*:.+*:'')9DQ598NG9S,3XJT;N3'';*:.+*:.+*:.+*:.+*:''+N3_%N3NG9S,0@@.+*:.+*:.+*:.+*:.+*:@@@@
') ; colorMapFromArray:#[80 128 180 208 192 110 96 176 220 144 32 30 144 96 100 144 208 220 96 176 240 176 32 20 255 224 140 128 192 240 192 192 180 160 208 240 255 240 180 176 224 255 16 64 130 192 192 220 208 224 240 32 64 130 0 48 140 208 224 255 48 64 130 16 96 190 240 240 255 80 160 210 240 208 100 80 160 220 48 160 255 96 128 180 176 208 180 80 176 255 160 128 130 160 144 140 128 208 255 160 80 100 176 240 255 255 224 160 144 192 255 255 255 210 64 80 100 208 240 255 176 208 255 64 80 110 224 240 255 16 112 210 112 112 110 32 96 190 112 112 130 192 192 130 64 144 220 128 144 160 80 112 180 80 144 210 96 192 255 112 160 210 160 160 160 112 192 255 176 176 180 160 224 255 192 176 180 32 64 110 80 112 110 192 192 210 192 224 255 80 112 130 0 64 160 48 128 190 80 96 130 16 80 180 112 128 140 32 112 210 144 192 180 96 96 130 80 192 255 96 160 210 160 160 140 80 112 190 96 144 210 240 208 130 144 160 190 144 176 210 144 208 255 192 208 210 255 240 190 208 208 210 224 224 210 80 96 110 48 80 130 0 80 180 16 48 140 80 128 160 0 64 180 32 128 220 48 128 210 112 192 210 128 128 130 64 176 255 144 48 50 112 160 190 96 128 190 80 128 210 255 224 130 112 128 190 176 208 210 128 192 255 128 176 240 128 112 60 80 80 80 48 80 110 64 112 140 208 192 210 0 96 190 16 128 220 240 255 255 144 128 100 48 144 220 144 176 160 64 144 210 16 96 210 48 128 220 48 112 210 144 144 140 112 176 220 112 144 190 128 176 210 96 144 220 160 192 210 192 192 190 144 160 210 192 208 220 160 208 255 240 240 210 255 255 220 48 64 110 0 112 210 32 144 220 255 255 240 0 96 210 64 160 220 224 208 110 128 192 190 48 96 180 16 64 180 80 128 190 64 128 210 64 96 180 96 160 220 208 80 30 160 16 20 144 192 220 192 208 190 160 192 220 128 144 210 176 192 220 192 240 255 80 96 100 240 240 220 255 240 210 16 64 140 208 208 220 240 240 240 112 96 100 0 80 190 48 176 255 16 16 0 64 112 180 64 128 190 255 240 255 208 96 30 144 16 20 80 144 220 128 208 240 192 48 20 128 176 220 112 176 240 176 208 220 144 192 240 224 240 210 192 224 240 208 176 180 224 224 220 224 240 240 96 96 100 80 80 100 224 224 240 32 128 210 32 112 190 255 255 255]; mask:((ImageMask new) width:30; height:30; bits:(ByteArray fromPackedString:'
@@@@@@@@A>@@@G? @@??8@A??>@G??? O???8G???>A????8_????G????1????<_???>G???>A???? _???8G???>A???? _???8G???>A???? _???8G??
?>A???? _???0G??? A??>@@_?<@@G?@@@@<@@@@') ; yourself); yourself]
!

documents26x26Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self documents26x26Icon inspect
     ImageEditor openOnClass:self andSelector:#documents26x26Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class documents26x26Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:26;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E)ZQ!!0IBP).
G)^WWX]PTA4@@@@@@@@@@@@@QDPPX#T5I6U@ZF!!<E38>TP@@@@@@@@@@@@ADQAA"MST''YTA(ZG0WO#9Q@@@@@@@@@@@@@E!!XJ7.Q$S>HA)RT%SFA YP0L3L@
@@@@@@@@[F1''E%IRP#^DHB@<OC0<OC2S$0@@@@@@@@B@ B):@ H-\9AUUXJB (JBOF-+@@@@@@@@@HB@J''(B@"53$EUU (JB (H<Z6,@@@@@@@@@B@"M@#4=
K@=Y%YT#G2D!!&VPZF @@@@@@@@@/K2$(@PDDM)AUUT]> 8LXYEYV@@@@@@@@@A,[^X0;N1U^VYVUR 1\WF5$Z&(@@@@@@@@@F1-8]0@@S''JPUUVB (JB #1A
PP@@@@@@@@@[F7!!7@@AN\)AUUXJB (JBODEA@@@@@@@@@E]W"0BJ"$4NVYVUW5=_W5<<_W4@@@@@@@@@_7<S''VE!!DXVPUUVB (JB #0EAP@@@@@@@@@GA2VI
NC!!4&E&U%U=_W5=_OEQT@@@@@@@@@@\GIX$8NGRXVYVUW5=_W5<<UEP@@@@@@@@@K"95II.[R06PUUVB (JB #2O#0@@@@@@@@@.K&AL&)("RCHKB1HRNS$9
I!!$Y@@@@@@@@@IJRQYY0\D$4X4=O@89ST6$Y[6<@@@@@@@@@$)IE%''A0RSQ#S4<C#%MSZQ%/[0@@@@@@@@B\''E-CY&Y6!!''D:N @@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 121 174 168 117 164 171 112 155 176 142 153 154 145 184 186 154 154 154 161 162 162 87 181 134 86 176 134 84 167 135 83 160 137 200 200 200 159 207 255 73 134 146 70 129 149 67 122 152 94 152 159 124 183 164 238 238 238 122 175 167 252 252 252 136 182 178 108 147 180 145 185 187 93 194 255 160 160 160 168 168 168 87 178 134 85 170 136 163 185 209 78 147 140 154 198 251 213 213 213 202 230 247 126 194 164 199 225 255 125 185 164 122 179 166 242 242 242 105 152 170 115 161 174 113 157 175 109 148 180 106 142 183 147 184 190 148 181 193 87 182 134 86 177 134 179 179 179 187 187 187 197 197 197 207 207 207 74 137 145 86 147 151 68 123 151 66 119 153 124 184 164 237 237 237 241 241 241 119 169 170 255 255 255 114 159 174 136 177 182 130 168 185 141 177 188 159 159 159 149 179 197 183 217 203 85 172 135 96 180 141 99 176 145 137 189 255 73 136 145 116 185 158 205 237 255 125 191 164 125 189 164 123 180 165 122 177 167 120 131 130 88 131 169 85 127 171 110 150 178 141 149 153 151 151 151 162 161 158 166 166 166 87 179 134 86 173 135 186 186 186 101 179 146 211 234 223 194 239 255 71 130 148 69 125 150 227 227 227 125 186 164 123 181 165 117 171 166 120 132 130 254 254 254 114 149 164 151 197 183 107 144 181 144 181 188 153 157 160 163 163 163 170 170 170 86 174 135 146 215 254 81 154 138 201 201 201 108 181 153 217 217 217 70 126 149 66 120 152 125 187 164 124 183 165 120 174 165 119 170 169 118 166 171 116 161 173 110 151 178 106 144 182 145 183 188 156 156 156 27 119 255 87 180 134 86 175 135 185 185 185 194 193 189 173 227 255 209 209 209 71 131 148 85 143 148 67 121 152 65 117 154 123 182 165 122 177 166 119 171 169 117 165 171 111 152 177 140 150 153 149 149 149 159 158 155 140 172 193 88 183 134 174 174 174 182 182 182 190 190 190 102 178 147 75 139 144 72 132 147 216 244 248 125 192 164 125 188 164 238 246 242 122 178 166 ];
                mask:((ImageMask new)
                            width:26;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@C??0@@??<@@O??@@C??>@@??? @O??8@C??>@@??? @O??8@C??>@@??? @O??8@C??>@@??? @O??8@C??>@@??? @O??8@C??>@@??
? @O? @@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

fileOpenIcon
    <resource: #programImage>

    ^ self loadFromFileIcon
!

greenThumbUnknownSmallIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self greenThumbUnknownSmallIcon inspect
     ImageEditor openOnClass:self andSelector:#greenThumbUnknownSmallIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary greenThumbUnknownSmallIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@B @@@@(U@@@!!E@@@*IP@@J)P@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 76 76 76 153 153 153 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@@@C @_8A?0O?@?8C?@O8@@@@@a');
                            yourself);
                yourself
        ]
!

greenThumbUpIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self greenThumbUpIcon inspect
     ImageEditor openOnClass:self andSelector:#greenThumbUpIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class greenThumbUpIcon'
        ifAbsentPut:[(Depth4Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@A)<@@@@@@@@G( @@@@@@@@^/@@@@@@@@A9@@@@@@@@C)$@@@@@@@A)+<>]BM]0BZ(->&E''3&@I**J&DN];@@VZ*''G^DV] C%&Y8AY7,@@MQU
P]8QY6@@@MSPE''XP@@@@@CL0!!''X@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 64 0 77 242 77 0 128 0 0 160 32 8 215 50 50 173 50 45 210 45 0 32 0 40 247 40 77 242 118 0 64 32 22 105 22 18 141 18 13 178 13 45 210 86]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'G@@>@C8@O @<@G?<??;??/?>??;??O?<?? ?>@?0') ; yourself); yourself]
!

greenThumbUpSmallIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self greenThumbUpSmallIcon inspect
     ImageEditor openOnClass:self andSelector:#greenThumbUpSmallIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class greenThumbUpSmallIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@P@@@@D@@@@A@@L@@P@B@@U*@@@UZ@@@UV @@EV @@@@@@B@@@@B@b');
                colorMapFromArray:#[ 0 0 0 0 255 0 0 127 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'C@@N@@8@C @_8A?0O?@?8C?@O8@@@@@a');
                            yourself);
                yourself
        ]
!

greyThumbRightIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self greyThumbRightIcon inspect
     ImageEditor openOnClass:self andSelector:#greyThumbRightIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary greyThumbRightIcon'
        ifAbsentPut:[(Depth4Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@LC\@@@@@@CA2M0@@@@@0\#]&@@@@@GH7I7T@@@@@L2\#L@@@@@AWH3@&@@@@@@L2X#P@@@@@IV@#E0@@@@@ T7E2@GQ0@BY''EF]DDT@@A''
\QPT]7L@@F]1DTL@@@@@A''PQL@@@@@@FM4P@@@@@') ; colorMapFromArray:#[0 0 0 224 224 224 64 64 64 128 128 128 192 192 192 32 32 32 96 96 96 160 160 160]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A8@_0G?@?<C?0O?@?<C?0O?\??;??''?>_?0?0C>@') ; yourself); yourself]
!

greyThumbUpIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self greyThumbUpIcon inspect
     ImageEditor openOnClass:self andSelector:#greyThumbUpIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class greyThumbUpIcon'
        ifAbsentPut:[(Depth4Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@ @@4\@@@@@@@@GE@@@@@@@@@\W@@@@@@@@A4@@@@@@@@@4P@@@@@@H@4E2]FAV]0AAEF\SH7X3@DDQPSHC]2@@]ADWI#H#\0@7]7LBM7H@@FY7
YVL"M3@@@FY T7L @@@@@BH T7L@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 224 224 224 64 64 64 128 128 128 192 192 192 32 32 32 96 96 96 160 160 160]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'G@@>@C8@O @<@G?<??;??/?>??;??O?<?? ?>@?0') ; yourself); yourself]
!

hideToolBarIcon
    <resource: #programImage>

    ^ self hideToolbar8x24Icon

    "Created: / 18-02-2007 / 14:52:15 / cg"
!

hideToolbar24x8Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideToolbar24x8Icon inspect
     ImageEditor openOnClass:self andSelector:#hideToolbar24x8Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class hideToolbar24x8Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:24;
                height:8;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@J@B(@* @HPB%@"D@AP@U@ET@@@@@ @J@@B$@*PH)@BT@IPA%@@T@AP@E');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:24;
                            height:8;
                            bits:(ByteArray fromPackedString:'@@@@XFA TEAPLC@0@@@@A XFAPTE@0LC');
                            yourself);
                yourself
        ]
!

hideToolbar8x24Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideToolbar8x24Icon inspect
     ImageEditor openOnClass:self andSelector:#hideToolbar8x24Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class hideToolbar8x24Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:8;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@(@BD@AP@@@@@)@BT(AR$@JP@%J@T)@BT(JR$!!IPTEJB )HRT%AR$@IR EJP@%');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:8;
                            height:24;
                            bits:(ByteArray fromPackedString:'@FAPL@@FAPL@XE@0@@XE@0A TC@@A TC');
                            yourself);
                yourself
        ]
!

hideToolbarIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideToolbarIcon inspect
     ImageEditor openOnClass:self andSelector:#hideToolbarIcon"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class hideToolbarIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:10;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@HB @HBD@D@T@@@@(@@@!!@@@ELB @HBD@A@T@@@@(B@@!!@@@ELB @@BD@@@T@H@@(@@@!!@@@EHB @HBD@N@T@@@@(B@@!!@@@EB@@@C');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:10;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@@@@@a');
                            yourself);
                yourself
        ]
!

hideToolbarIcon10x26
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideToolbarIcon inspect
     ImageEditor openOnClass:self andSelector:#hideToolbarIcon"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class hideToolbarIcon10x26'
        ifAbsentPut:[
            (Depth2Image new)
                width:10;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@HB @HBD@D@T@@@@(@@@!!@@@ELB @HBD@A@T@@@@(B@@!!@@@ELB @@BD@@@T@H@@(@@@!!@@@EHB @HBD@N@T@@@@(B@@!!@@@EB@@@C');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:10;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 18-02-2007 / 14:52:07 / cg"
!

hideToolbarIconH14
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideToolbarIconH14 inspect
     ImageEditor openOnClass:self andSelector:#hideToolbarIconH14"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class hideToolbarIconH14'
        ifAbsentPut:[
            (Depth2Image new)
                width:10;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@B @@BD@@@T@@@@(@@@!!@@@E@B @@BD@@@T@@@@(@@@!!@@@E@@@@@');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:10;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@@@@@a');
                            yourself);
                yourself
        ]
!

hideToolbarIconH20
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideToolbarIconH20 inspect
     ImageEditor openOnClass:self andSelector:#hideToolbarIconH20"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class hideToolbarIconH20'
        ifAbsentPut:[
            (Depth2Image new)
                width:10;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@B @@BD@@@T@@@@(@@@!!@@@E@B @@BD@@@T@@@@(@@@!!@@@E@B @@BD@@@T@@@@(@@@!!@@@E@@@@@');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:10;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@@@@@a');
                            yourself);
                yourself
        ]
!

hideToolbarIconH26
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hideToolbarIconH26 inspect
     ImageEditor openOnClass:self andSelector:#hideToolbarIconH26"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class hideToolbarIconH26'
        ifAbsentPut:[
            (Depth2Image new)
                width:10;
                height:26;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@HB @HBD@D@T@@@@(@@@!!@@@ELB @HBD@A@T@@@@(B@@!!@@@ELB @@BD@@@T@H@@(@@@!!@@@EHB @HBD@N@T@@@@(B@@!!@@@EB@@@C');
                colorMapFromArray:#[ 0 0 0 68 68 68 255 255 255 ];
                mask:((ImageMask new)
                            width:10;
                            height:26;
                            bits:(ByteArray 
                                        fromPackedString:'@@@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@0@B @F@@C@@J@@X@@@@@a');
                            yourself);
                yourself
        ]
!

languages20x12Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self languages20x12Icon inspect
     ImageEditor openOnClass:self andSelector:#languages20x12Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary languages20x12Icon'
        ifAbsentPut:[(Depth4Image width:20 height:12) bits:(ByteArray fromPackedString:'
PDL3L4@DL3L4PEP@P3M@ACL3Q D3Q@P3P@P3Q@DQL3U@AT@DU@@QDTQDQDQ@ADQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DQDQDQ@@@@@@@@3M@A2H"H"H"H"
M@ABH"H"H"H"H$A"H"H"H"H"H"HBH"H"H"H"H"H"') colorMapFromArray:#[255 0 0 0 0 0 255 204 0 0 0 99 255 255 255 167 167 205 255 63 63 168 208 173]; yourself]
!

loadFromFileIcon
    <resource: #programImage>

    ^ self load22x22Icon
!

loadImageFromFileIcon
    <resource: #programImage>

    ^ self loadFromFileIcon
!

redThumbDownIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self redThumbDownIcon inspect
     ImageEditor openOnClass:self andSelector:#redThumbDownIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class redThumbDownIcon'
        ifAbsentPut:[(Depth4Image new) width: 15; height: 15; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@L3@!!;\@@@C6<J^7(@@H=-5*<Z);\@@]UUDJ^;(@@MH3N:<Z);\@H3MC^ F;(@@#MO$7);8WB@\#'')K0#;,@@AH @@@@@@@@B2@@@@@@@@@K
NP@@@@@L@@,4@@@@@@T@A2$@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 191 20 1 255 44 33 255 131 65 255 84 65 255 88 33 160 40 0 184 67 40 32 27 0 223 99 33 64 22 0 223 52 33 128 13 0 224 56 0 112 16 31 152 35 8]; mask:((ImageMask new) width: 15; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C?@?>O?8??3??O?>??;??/?>_?0<@C8@O @>@A0@') ; yourself); yourself]
!

redThumbDownSmallIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redThumbDownSmallIcon inspect
     ImageEditor openOnClass:self andSelector:#redThumbDownSmallIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class redThumbDownSmallIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@B@@@@@@EV @@AUZ@@@EV C@@U*@@@A@@@@@P@@@@D@@@@A@@@@@@@@ b');
                colorMapFromArray:#[ 0 0 0 255 0 0 127 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@? C?@O>@?<A?0G>@N@@8@C @L@@@a');
                            yourself);
                yourself
        ]
!

redoIcon
    <resource: #programImage>

    View styleSheet name = #winXP ifTrue:[
        ^ self redoXP28x28Icon
    ].
    ^ self redo20x20Icon
!

saveToFileAsIcon
    <resource: #programImage>

    ^ self save22x22Icon
!

saveToFileIcon
    <resource: #programImage>

    ^ self save22x22Icon
!

smallBugIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self smallBugIcon inspect
     ImageEditor openOnClass:self andSelector:#smallBugIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class smallBugIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@@@@@@@@@@@3@@@@@@@@@@@3LS@@@@@@@@@@LSL2@@
@@@@@@@3LSL @@@@@@@@D3L2@@@@@@@@@CLSH @@@@@@@@@BH @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 128 0 0 248 0 0 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@#@@B_ @A? @O?@@C?@@G?@@G> @G>@@C=@@A4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

smiley_veryAngry
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self smiley_veryAngry inspect
     ImageEditor openOnClass:self andSelector:#smiley_veryAngry
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'GenericToolbarIconLibrary class smiley_veryAngry'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
3L3L3L3L3L3K/L2;.;3L.<,[.9X36;,[27(&H$QM6''/K(+IDQDR=*<V3HDQDPD6526I@ADP@SZ/KL  @P@ M><,4BHQD"@7;22Q@ADP@S_/K5DQDQDS-*<2=
Q@@@AM6<3K7PQDS 6+3L2=7]7]6+3L3L.???*;3L3L3L.;.<3L0b');
                colorMapFromArray:#[ 0 0 0 254 42 0 255 253 19 255 254 147 255 234 0 150 150 150 255 255 199 254 109 3 255 0 0 255 255 235 254 157 0 69 69 69 248 244 251 255 201 0 255 229 0 255 180 0 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@A#87??_?=??7??_?=??7??_?=??3?>O?8_?@?8@>@b');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools'!

addBufferIcon
    <resource: #programImage>

    ^ self addBuffer16x16Icon2
!

addTabIcon
    <resource: #programImage>

    ^ self addTab22x22Icon
!

browseItIcon
    <resource: #programImage>

    ^ self browseIt20x20Icon
!

bug2_25x25Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bug2_25x25Icon inspect
     ImageEditor openOnClass:self andSelector:#bug2_25x25Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary bug2_25x25Icon'
        ifAbsentPut:[(Depth4Image new) width:25; height:25; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@O0@@@@@@@@@@@AV( @@@@@@CL3 P@3D@DU @@@@@@@DX(@@P@QAX@@@@@@@Z"!!ATQIDET@ @@@@@B@(XQ7Q%UP@@@@@@B@VHBWH''QE@@
@@@@@@APAFABH''R@@C@@@H E@DQDABI4 @@A@@D@)$Q7]*AGPH@@@@@EDVQGH$Q4Y!!D@@0,@ AYD\"QBI4@XB@@H@ETTQ2IDH"]A(AT@BCMP!!GH$P"H''XX"@
@@@ATAP"QRH"]@DQB@@@@@@TIDH"H''P@TX@@@@@@"4P"H"]@F@@@@@D@@@"WH"I4@P@@@@@@@@@@"4QDP@D@@@@@C0@@@@!!UEUTH@@@@@@@@@@@@@@@UB@@@
@@@C@@@@@@@QTH@@@@@@A0@@@@@A @@@@@@@@@L@@@@@@@@@@@@C@@@@@@@@@@@@@@@@@@@@@P@a') ; colorMapFromArray:#[0 0 0 148 148 148 248 0 0 255 255 255 108 0 0 110 110 110 52 0 0 209 0 0 208 208 208 100 72 72 44 44 44 152 49 49]; mask:((ImageMask new) width:25; height:25; bits:(ByteArray fromPackedString:'@@@@@@@@O @@FG<@@G#?@@C;? @@7?0@@\?8@@C?>@@M?? @G??8@A??<@@???P@O??<@B??>@A/?? @C??8@@??0@@G?0@@@?<@@@G?@@@@C0@@@C(@@@AJ
@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

bugIcon
    <resource: #programImage>

    ^ self bug28x28Icon
!

copyIcon
    <resource: #programImage>

    ^ self copy20x20Icon
!

cutIcon
    <resource: #programImage>

    ^ self cut20x20Icon
!

debugItIcon
    <resource: #programImage>

    ^ self debugIt20x20Icon

    "Created: / 20-02-2007 / 15:46:24 / cg"
!

deleteIcon
    <resource: #programImage>

    ^ self delete16x16Icon
!

doItIcon
    <resource: #programImage>

    ^ self doIt20x20Icon
!

doItMultipleIcon
    <resource: #programImage>

    ^ self doItMultiple20x20Icon
!

downIcon
    <resource:#programImage>
    ^ self down22x22Icon
!

downRightIcon
    <resource:#programImage>
    ^ self downRight22x22Icon
!

inspectItIcon
    <resource: #programImage>

    ^ self inspectIt20x20Icon

    "Created: / 20-02-2007 / 15:44:34 / cg"
!

leftDownIcon
    <resource:#programImage>
    ^ self leftDown22x22Icon
!

printItIcon
    <resource: #programImage>

    ^ self printIt20x20Icon
!

profileItIcon
    <resource: #programImage>

    ^ self profileIt20x20Icon
!

removeTabEnteredIcon
    <resource: #programImage>

    ^ self removeTabIcon
!

removeTabIcon
    <resource: #programImage>

    ^ self removeTab22x22Icon
!

undoIcon
    <resource: #programImage>

    ^ self undo16x16Icon2
!

upIcon
    <resource:#programImage>
    ^ self up22x22Icon
!

upRightIcon
    <resource:#programImage>
    ^ self upRight22x22Icon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-ChangeSetDiffTool & TextDiffTool'!

mergeDiff3AToMergedArrow30x30
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeDiff3AToMergedArrow30x30.xpm"

    "
     self mergeDiff3AToMergedArrow30x30 inspect
     ImageEditor openOnClass:self andSelector:#mergeDiff3AToMergedArrow30x30
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeDiff3AToMergedArrow30x30'
        ifAbsentPut:[(Depth8Image new) width: 30; height: 30; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@A@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@A@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA
@PDA@PD@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@@@@@@@@@@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@@@@@@@DA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PD@@@@@@@@A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@A@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@@@@@@@A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@PDA@PDA@PDA@PDA
') ; colorMapFromArray:#[0 0 0 0 0 0]; mask:((ImageMask new) width: 30; height: 30; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O0@@@C?@@@@?<@@@O? @@C?>@@@A? @@@G<@@@@? @@@G<@@@@?
@@@@G0@@@A>@@@@O @@@C8@@@@>@@@@G0@@@A<@@') ; yourself); yourself]
!

mergeDiff3BToMergedArrow30x30
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self mergeDiff3BToMergedArrow30x30 inspect
     ImageEditor openOnClass:self andSelector:#mergeDiff3BToMergedArrow30x30
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeDiff3BToMergedArrow30x30'
        ifAbsentPut:[(Depth1Image new) width: 30; height: 30; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width: 30; height: 30; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@_@@@@G0@@@A<@@@@_@@@@G0@@@A<@@@@_@@@@G0@@@A<@@@@_@@@@G0@@@A<@@@@_@@O0G0@C?!!<@@?>_@@O??0@C??<@@@??@@@C?0@@@_<@@@C?@@@@_
0@@@G<@@@@?@@@@O0@@@C<@@@@?@@@@O0@@@@@@@') ; yourself); yourself]
!

mergeDiff3BaseToAArrow30x30
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self mergeDiff3BaseToAArrow30x30 inspect
     ImageEditor openOnClass:self andSelector:#mergeDiff3BaseToAArrow30x30
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeDiff3BaseToAArrow30x30'
        ifAbsentPut:[(Depth1Image new) width: 30; height: 30; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@L@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width: 30; height: 30; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@G @@@C<@@@@?@@@@O0@@@C<@@@@?@@@@O8@@@C?@@@@?8@@@O?@@@C?<@@@??<@@O??0@C=?<@@?G?@@O0_0@C<@\@@?@@@@O0@@@C<@@@@?@@@@O
0@@@C<@@@@?@@@@O0@@@C<@@@@?@@@@O0@@@C<@@') ; yourself); yourself]
!

mergeDiff3BaseToBArrow30x30
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self mergeDiff3BaseToBArrow30x30 inspect
     ImageEditor openOnClass:self andSelector:#mergeDiff3BaseToBArrow30x30
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeDiff3BaseToBArrow30x30'
        ifAbsentPut:[(Depth1Image new) width: 30; height: 30; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@D@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@L@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width: 30; height: 30; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@?@@@@O0@@@C<@@@@?@@@@G0@@@A<@@@@_ @@@C<@@@@?@@@@G8@@@@? @@@O<@@@A?<@@@O?0@@@?<@@@G?@@@@O0@@@@\@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

mergeMerge24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeMerge24x24.xpm"

    "
     self mergeMerge24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeMerge24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeMerge24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
RD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HE0-HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HJ$T&RD!!HRD!!HRD!!HRD!!H
RD!!HRD!!HRD!!HK$YFPA=HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HK$]FQ4\<E$!!HRD!!HRD!!HRD!!HRD!!HRD!!HNT]GQ4]GQ2 HRD!!HRD!!HRD!!HRD!!HRD!!HN$]GQ4]GQ4]D
I$!!HRD!!HRD!!HRD!!HRD!!HN4]GQ4]GQ4]GO %HRD!!HRD!!H@D!!HRD!!HK$]GQ4]GQ4L]RD!!HRD!!HR@T1ED!!HRD!!HK$]GQ4]GI0MHRD!!HRD AH$EBFD!!HRD!!HK$]G
Q34JRD!!HRD!!HRAD4P$IBF4!!HRD!!HJ4]@ET!!HRD!!HRD PL4IBP$IBHD!!HRD!!HJQ9HRD!!HRD!!HCCEBP$IBP$IBF4!!HRD!!H@$!!HRD!!HRD [M$IBP$IBP$IBF4!!H
RD!!HRD!!HRD!!HRD DH4EBP$IBP$IBHD!!HRD!!HRD!!HRD!!HRD!!HR@<2P$IBP$IBF4!!HRD!!HRD!!HRD!!HRD!!HRD!!HD#UBP$IBF4!!HRD!!HRD!!HRD!!HRD!!HRD!!HR@T!!
PTIBF4!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HA2QBFD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD MC$!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!H
RD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!H') ; colorMapFromArray:#[46 37 13 60 47 16 38 49 22 47 60 27 75 59 19 72 57 20 72 58 20 79 63 22 56 72 33 57 73 33 62 79 35 63 81 36 84 66 23 84 68 23 85 68 23 91 73 24 98 78 27 107 86 30 110 89 30 115 92 31 115 93 31 66 85 38 69 86 39 72 93 42 115 93 32 117 94 32 117 95 32 118 94 32 118 95 32 79 101 46 84 107 49 84 109 48 117 96 32 140 112 38 147 118 41 148 119 40 154 124 43 100 128 57 101 129 58 103 132 60 116 149 67 117 150 67 123 158 71 124 158 71 125 160 72 124 160 73 127 162 72 126 162 73 170 137 47 171 138 47 189 152 52 200 161 54 217 174 58 220 177 60 226 181 62 231 186 63 232 187 63 128 163 74 128 164 73 130 165 74 133 170 77 138 176 79 147 189 85 149 191 86 150 190 86 233 187 64 234 188 64 157 201 91 161 206 93 162 207 93 164 210 95 165 211 95 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@F@@@G@@@G0@@G<@@G?@@G? @G?0DG?@\G>A<G8C<G O<F@?<DA?<@A?<@@_<@@G<@@C<@@@<@@@L@@@@@@@@@@@@') ; yourself); yourself]
!

mergeMerge32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeMerge32x32.xpm"

    "
     self mergeMerge32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeMerge32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeMerge32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&HAX&I"X&I"X&I"X&I"X&I"X&I"X&I"
X&I"X&I"X&I"X#P*@&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"OFEWE&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&H>XVE!!PQQ"X&I"X&I"X&I"
X&I"X&I"X&I"X&I"X&I"X#9!!XVE!!WSHNX&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"P&E!!XVE!!XU01CFI"X&I"X&I"X&I"X&I"X&I"X&I"X&IBXVE!!XVE!!XVEY
GVI"X&I"X&I"X&I"X&I"X&I"X&I"X$U!!XVE!!XVE!!XVE!!PQQ"X&I"X&I"X&I"X&I"X&I"X&I"Q6E!!XVE!!XVE!!XVE!!WSDLX&I"X&I"X&I"X&I"X&I"X&IGXVE!!
XVE!!XVE!!XVE[G&I"X&I"X&I"X&H@X&I"X&I"X$U!!XVE!!XVE!!XVE_LP1"X&I"X&I"X&HYRRM"X&I"X&I"P&E!!XVE!!XVE!!P ="X&I"X&I"X&HIN5YZH6I"X&I"
X&IBXVE!!XVE!!VAY"X&I"X&I"X&HDKEIZV%(+X&I"X&I"X$E!!XVE!!W28CX&I"X&I"X&I"F45ZV%)ZV"1"X&I"X&I"OVE!!XSLLX&I"X&I"X&I"FT!!ZV%)ZV%)Z
JVI"X&I"X&H=XTHTX&I"X&I"X&I"AC%TV%)ZV%)ZV%(5X&I"X&I"X#L\X&I"X&I"X&I"X"IPV%)ZV%)ZV%)ZV#]"X&I"X&I"@VI"X&I"X&I"X UJV%)ZV%)Z
V%)ZV%)ZM6I"X&I"X&I"X&I"X&I"X&I"X!!)MU%)ZV%)ZV%)ZV%(7X&I"X&I"X&I"X&I"X&I"X&I"X&H TE)ZV%)ZV%)ZV#]"X&I"X&I"X&I"X&I"X&I"X&I"
X&HGN%QZV%)ZV%)ZKFI"X&I"X&I"X&I"X&I"X&I"X&I"X&I"FT-ZV%)ZV%()X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X!!=NV%)ZV"Y"X&I"X&I"X&I"X&I"
X&I"X&I"X&I"X&I"X X!!TU)VIVI"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&HIM5P#X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"DAE"X&I"X&I"
X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"
X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X @a') ; colorMapFromArray:#[29 23 8 22 28 13 26 34 14 29 35 17 43 35 11 41 33 12 49 40 13 55 43 15 56 45 15 56 46 15 32 41 18 33 40 19 32 42 18 33 42 19 36 45 21 37 47 21 57 46 16 59 47 16 38 48 21 38 49 22 39 49 23 45 58 25 46 58 27 63 51 18 64 53 18 65 53 18 72 57 20 75 60 20 52 67 30 57 72 33 62 81 35 88 71 24 91 73 25 99 80 27 105 85 29 110 88 29 111 88 30 112 90 30 113 92 31 116 92 31 116 93 31 117 93 31 68 87 40 113 91 32 115 93 32 117 95 32 75 96 43 76 97 44 77 97 44 77 98 45 78 100 44 88 112 51 93 121 55 120 96 32 121 96 32 121 98 33 122 99 33 126 101 35 128 102 34 144 115 39 109 139 62 109 140 63 110 141 64 111 142 64 111 143 64 113 144 64 112 144 65 114 145 65 114 146 66 116 148 66 116 148 67 116 150 68 170 136 46 171 137 46 175 140 47 184 148 50 191 153 52 194 156 53 208 167 57 216 173 59 217 174 59 219 176 60 223 179 61 228 184 62 229 184 63 231 186 63 232 187 63 133 170 76 138 177 80 139 178 80 234 188 64 153 195 88 155 198 89 157 201 91 158 202 91 160 205 92 163 209 94 165 211 95 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@H@@@@C @@@@<@@@@O0@@@C?@@@@?<@@@O? @@C?>@@@??8@@O?<@HC?>@N@?>@O O>@O8C?@G>@?@G? O@G?8C@C?>@ C?? @@_?8@@A?>@@@
O? @@@?8@@@C>@@@@_ @@@A8@@@@F@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

mergeMergeExternal24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeMergeExternal24x24.xpm"

    "
     self mergeMergeExternal24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeMergeExternal24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeMergeExternal24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUT@@@@A@@@@@@@A@@@@@@@A@@@@@EUUUPLIBP$IBP$IBP$IBP$IBP$IBP$IBPEUUPLIBP$IBP$IBP$JB $IBP(I
BP$IBPEUUPLFA XFA XFA XFA XFA XFA XFA QUUP]TUD%LUEQTUEQTUEQTUEQTUEQTU@!!UUP]TUC0YJ45TUEQTUEQTUEQTUEQTU@!!UUP]TUC0*J!!\/UEQT
UEQTUEQTUEQTU@!!UUP]TUC0*J"(&GDUTUEQTUEQTUEQTU@!!UUP]TUCD*J"(*J!! ]R%QTUEQTUEQTU@!!UUP]TUCD*J"(*J"(*B4ATUEQTST1TU@!!UUP]TUCD*
J"(*J" ^PUQTUED.ECYTU@!!UUP]TUCD*J"(*H3%QUEQTO!!TOISQTU@!!UUP]TUCD*J!!(,SEQTUD [CBT%ISQTU@!!UUP]TUC0&G4]TUEQNH"PQDRT%ISQTU@!!U
UP]TUD@=UEQTUDPRDRT%DRT%ISMTU@!!UUP]TUEQTUEQTUEP4D!!D%IRT%ISQTU@!!UUP]TUEQTUEQTUEQTS24VIRT%ISQTU@!!UUP]TUEQTUEQTUEQTUEQFH@4%
ISQTU@!!UUP]TUEQTUEQTUEQTUEQTUDH!!C3QTU@!!UUP]TUEQTUEQTUEQTUEQTUEQQL3=TU@!!UUP]QUEQQTUEQUEEQTUEQUEEQTUQTTP!!UUUTEAPTEAPTEAPTE
APTEAPTEAPTEAUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU') ; colorMapFromArray:#[31 31 31 37 37 37 44 44 44 46 46 46 48 48 48 70 70 70 77 77 77 93 93 93 98 98 98 101 101 101 102 102 102 117 141 80 208 168 62 214 174 62 226 181 62 226 182 63 229 184 63 231 186 63 157 134 70 153 132 74 166 140 70 163 140 78 187 154 65 134 161 93 145 183 87 144 178 92 149 187 91 158 142 101 131 148 103 133 147 110 134 154 104 140 157 115 161 144 98 166 148 96 160 149 120 143 173 98 192 159 68 234 188 64 153 194 90 155 197 90 160 204 93 164 210 95 165 211 95 151 164 132 153 167 130 172 161 129 175 166 144 162 170 151 168 175 158 168 175 159 177 170 151 180 172 150 177 171 152 178 171 153 177 171 154 178 172 154 178 172 155 172 181 159 169 175 160 170 175 160 170 175 161 171 177 161 181 176 161 189 186 175 190 193 187 191 194 186 197 194 183 192 196 186 200 198 192 201 204 196 210 208 200 214 216 210 221 219 216 219 220 216 221 223 220 226 225 222 229 230 227 240 241 240 242 242 241 244 244 243 250 250 250 251 251 251 252 252 252 254 254 254 255 255 255 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@O??<_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>O??<@@@@') ; yourself); yourself]
!

mergeMergeExternal32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeMergeExternal32x32.xpm"

    "
     self mergeMergeExternal32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeMergeExternal32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeMergeExternal32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2@PHB@ HB@ HB@ HB@ HB@ HB@ HB@ HB
@ HB@GI2\''HEC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<E\''I2\ TOC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0U2\''I2@ \GA0\GA0\GA0\GA0\GA0\G
A0\GA0\GA0\G@''I2\''HHVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU$O\''I2\!!I1\WEUY7E1\WE1\WE1\WE1\WE1\WE1\WE1\UA2\''I2TF51\RX]TV-1\WE1
\WE1\WE1\WE1\WE1\WE1TGI2\''HR\WE1I4=LGE]1\WE1\WE1\WE1\WE1\WE1\WEP\''I2\!!I1\WD%S4=OP2A!!\WE1\WE1\WE1\WE1\WE1\UA2\''I2D''E1\RUO
S4=OS18+Y7E1\WE1\WE1\WE1\WE1TGI2\''HR\WE1H$=OS4=OS44[TV51\WE1\WE1\WE1\WEP\''I2\!!I1\WD!!S4=OS4=OS4=DCE51\WE1\WE1\WE1\UA2\''I2
D''E1\REOS4=OS4=OS4=@DV51\WE1\V@Q\WE1TGI2\''HR\WE1HT=OS4=OS4=AG6I1\WE1\VPWKS=1\WEP\''I2\!!I1\WD!!S4=OS4=KB511\WE1\V%GKD%IO7E1
\UA2\''I2D''E1\RUOS4=OFR))\WE1\WEXESEIR$$?\WE1TGI2\''HR\WE1HT=OF!!A%\WE1\WE^E#AJR$)JR#-1\WEP\''I2\!!I1\WD%PP)_\WE1\WE&FB9IRT)J
R$)JO7E1\UA2\''I2D''E1\P%T[''E1\WE-T1P2RT)JR$)JR$$7\WE1TGI2\''HR\WE1\WE1\WE1\WEXO3MIRT%JR$)JRS]1\WEP\''I2\!!I1\WE1\WE1\WE1\WE+
RCYIRT)JR$)IN7E1\UA2\''I2D''E1\WE1\WE1\WE1\WE1X4T/R$)JR#P;\WE1TGI2\''HR\WE1\WE1\WE1\WE1\WE1\U,ULT%IR#=1\WEP\''I2\!!I1\WE1\WE1
\WE1\WE1\WE1\V5VD3H4O7E1\UA2\''I2D''E1\WE1\WE1\WE1\WE1\WE1\WE''Q20=\WE1TGI2\''HR\WE1\WE1\WE1\WE1\WE1\WE1\WE1XA!!1\WEP\''I2\!!I1
\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UA2\''I2AP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MA''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2
\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\''I2\ @a') ; colorMapFromArray:#[24 24 24 26 26 26 41 41 41 42 42 42 53 53 53 55 55 55 60 60 60 75 75 75 90 90 90 100 107 89 105 116 87 105 120 81 109 126 85 97 97 97 101 101 101 102 102 102 115 124 101 126 121 106 127 127 127 139 118 64 142 122 66 141 123 77 139 124 84 128 118 90 134 123 97 113 138 75 123 153 77 116 139 81 120 139 91 124 149 86 125 154 80 118 129 101 119 130 100 122 139 97 123 139 97 123 139 98 123 140 99 124 140 99 123 139 100 124 141 100 125 141 100 121 128 110 126 133 115 127 137 112 156 130 59 175 144 57 178 147 62 194 158 62 208 168 61 219 176 61 227 182 62 228 183 62 232 187 63 159 133 64 159 133 65 147 129 82 147 129 83 147 130 84 147 131 85 148 131 84 148 131 85 148 131 86 151 132 84 148 132 86 130 160 84 139 175 84 139 176 82 142 178 87 149 191 87 143 131 100 141 133 113 145 136 114 151 144 124 233 187 64 234 188 64 151 194 88 158 202 92 162 208 94 164 209 94 165 211 95 138 138 138 139 145 128 139 145 130 158 153 138 154 159 146 156 159 151 162 157 141 162 165 156 175 171 162 175 175 175 176 171 162 177 172 163 175 178 170 179 182 174 198 196 191 199 200 196 207 206 201 211 212 210 216 217 215 221 220 218 223 222 221 226 227 226 232 231 230 238 238 238 239 239 238 242 242 242 246 246 246 247 247 247 249 249 249 250 250 250 252 252 252 253 253 253 254 254 254 255 255 255 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@????<O????C????0????<O????C????0????<O????C????0????<O????C????0????<O????C????0????<O????C????0????<O????C??
??0????<O????C????0????<O????C????0????<@@@@@@@@@@@b') ; yourself); yourself]
!

mergeNext24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeNext24x24.xpm"

    "
     self mergeNext24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeNext24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeNext24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
DQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQA \GA0\GA0\GA0\FDQDQDQDQDQDQDQDQBQ@PDA@P
DA@PDA@IDQDQDQDQDQDQDQDQDP8PDA@PDA@PD@8QDQDQDQDQDQDQDQDQDPTPDA@PDA@PD@TQDQDQDQDQDQDQDQDQDQDKDA@PDA@PB1DQDQDQDQDQDQDQDQDQ
DQDBDA@PDA@P@!!DQDQDQDQDQDQDQDQDQDQDQB!!@PDA@JDQDQDQDQDQDQDQDQDQDQDQDQ@P<PD@<ADQDQDQDQDQDQDQDQDQDQDQDQDP PD@ QDQDQDQDQDQDQ
DQDQDQDQDQDQDQDLCADQDQDQDQDQDQDQDQDQDQDQDQDQDQDC@1DQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ
DQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQ') ; colorMapFromArray:#[0 41 72 0 43 72 0 52 88 0 60 101 0 63 108 0 63 109 0 67 115 0 71 120 0 75 129 0 76 129 0 98 167 0 112 190 0 121 207 0 124 214 0 125 214 0 132 226 0 136 232 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@??@@??@@_>@@_>@@O<@@O<@@G8@@G8@@C0@@A @@A @@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

mergeNext32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeNext32x32.xpm"

    "
     self mergeNext32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeNext32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeNext32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8@@0LC@0LC
@0LC@0LC@0LC@0@^G!!8^G!!8^G!!8^G!!8^G!!8RGQ4]GQ4]GQ4]GQ4]GQ4RG!!8^G!!8^G!!8^G!!8^G!!8^G T\GQ4]GQ4]GQ4]GQ4]G@T^G!!8^G!!8^G!!8^G!!8^G!!8^
G!!@]GQ4]GQ4]GQ4]GQ4OG!!8^G!!8^G!!8^G!!8^G!!8^G!!8^@Q(]GQ4]GQ4]GQ4]F H^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^B14]GQ4]GQ4]GQ4LG!!8^G!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^E14]GQ4]GQ4]E18^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8HGQ4]GQ4]GQ4HG!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8TGQ4]GQ4]D!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^G!!8^G!!8^G T\GQ4]GQ0EG!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G <\GQ4]C18^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^@Q(]GQ AG!!8^
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^B!!4]B!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^E!!X^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8G
A18^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G @a') ; colorMapFromArray:#[0 20 32 0 27 47 0 27 48 0 30 52 0 33 56 0 33 57 0 34 57 0 38 65 0 41 69 0 51 87 0 52 87 0 54 91 0 53 92 0 68 115 0 68 116 0 70 119 0 71 121 0 89 152 0 90 153 0 94 160 0 94 161 0 102 174 0 103 174 0 111 189 0 119 205 0 121 208 0 123 210 0 132 225 0 132 226 0 136 232 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A??>@@O??@@C??0@@_?8@@G?>@@@??@@@G? @@A?8@@@O<@@@C?@@@@_ @@@G8@@@@<@@@@F@@@@A
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

mergeNextConflict24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeNextConflict24x24.xpm"

    "
     self mergeNextConflict24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeNextConflict24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeNextConflict24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,DADQDQDQDQDQDQ@P
KB0,KB0,KB0,KB0,I",+J2,+J2,+J2,UKB0,KB0,KB0,KB0,@B(+J2,+J2,+J2$,KB0,KB0,KB0,KB0,KAP+J2,+J2,+J1H,KB0,KB0,KB0,KB0,KB0(J2,+
J2,+I20,KB0,KB0,KB0,KB0,KB0PJ2,+J2,+C"0,KB0,KB0,KB0,KB0,B!!\KCQLSD1LLBQ\VKB0,KB0,KB0,KB0,FBT%IRT%IRT%IRTYKB0,KB0,KB0,KB0,
KBD%IRT%IRT%IRH,KB0,KB0,KB0,KB0,K@X%IRT%IRT%IP(,KB0,KB0,KB0,KB0,KB0^IRT%IRT%G"0,KB0,KB0,KB0,KB0,KB0CIRT%IRT%AB0,KB0,KB0,
KB0,KB0,KB0,F2T%IRT\KB0,KB0,KB0,KB0,KB0,KB0,@RL%IRPBKB0,KB0,KB0,KB0,KB0,KB0,KA$%IQ(,KB0,KB0,KB0,KB0,KB0,KB0,KB0!!HR0,KB0,
KB0,KB0,KB0,KB0,KB0,KB0EA"0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,
KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,') ; colorMapFromArray:#[0 37 62 87 14 0 92 14 0 104 16 0 108 17 0 118 18 0 120 18 0 123 19 0 125 19 0 121 20 3 125 20 0 120 20 4 94 42 48 93 44 50 0 51 87 0 52 89 0 54 91 0 56 96 0 62 107 91 56 72 0 65 111 0 74 127 128 20 0 132 20 0 143 22 0 146 23 0 149 24 0 184 29 0 189 29 0 208 33 0 210 33 0 228 36 0 230 36 0 231 36 0 236 37 0 247 39 0 250 39 0 255 40 0 0 79 136 0 111 189 0 114 195 0 123 210 0 125 215 0 136 232 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@??@@??@@?>@@_>@@O<@@O<@@??@@??@@_>@@_>@@O<@@O<@@G8@@G8@@C0@@A @@A @@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

mergeNextConflict32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeNextConflict32x32.xpm"

    "
     self mergeNextConflict32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeNextConflict32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeNextConflict32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEA
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPQ4]GQ4]GQ4]GQ4]GQ4]GQ5APTEAPTEAPTEAPTEAPTEANTA@PDA@PDA@PDA@
PDA@NDEAPTEAPTEAPTEAPTEAPTDQO4A@PDA@PDA@PDA@PC8OPTEAPTEAPTEAPTEAPTEAPTD7PDA@PDA@PDA@PDA@H4EAPTEAPTEAPTEAPTEAPTEAPP<=PDA@
PDA@PDA@PC0NPTEAPTEAPTEAPTEAPTEAPTEAPRI@PDA@PDA@PDA@HTEAPTEAPTEAPTEAPTEAPTEAPTEACS-@PDA@PDA@PC-APTEAPTEAPTEAPTEAPTEAPTEA
PTEAG4A@PDA@PDA@G$EAPTEAPTEAPTEAPTEAPTEAPTDHB@ GD2@ HB@ HAHGB@ H@DEAPTEAPTEAPTEAPTEAPR\6M#X6M#X6M#X6M#X6M"%APTEAPTEAPTEA
PTEAPTEACCP6M#X6M#X6M#X6M#X5CDEAPTEAPTEAPTEAPTEAPTEAICX6M#X6M#X6M#X6M"YAPTEAPTEAPTEAPTEAPTEAPTDDLCX6M#X6M#X6M#X2ADEAPTEA
PTEAPTEAPTEAPTEAPTDZM#X6M#X6M#X6M!!-APTEAPTEAPTEAPTEAPTEAPTEAPTD-M#X6M#X6M#X.@TEAPTEAPTEAPTEAPTEAPTEAPTEAPQX6M#X6M#X6M!!]A
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPR 6M#X6M#X*PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEABCP6M#X6M@1APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAGCX6
M#X$PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTDAK3X6L@QAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTDXM#XYPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEA
PTEAPTD+KDEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPQPUPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEA
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEA
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPP@a') ; colorMapFromArray:#[35 6 0 45 6 0 47 7 0 50 8 0 52 8 0 53 8 0 50 10 5 50 11 6 58 9 0 58 10 0 61 9 0 62 9 0 62 10 0 0 26 47 0 29 50 0 32 53 0 33 55 0 35 60 41 36 50 40 37 53 65 11 0 69 10 0 73 11 0 78 12 0 88 13 0 94 14 0 98 15 0 104 16 0 124 19 0 0 37 64 0 45 77 0 48 82 40 49 72 0 58 99 0 61 104 0 73 124 128 20 0 130 20 0 135 21 0 164 26 0 171 28 0 174 28 0 180 28 0 189 29 0 198 31 0 202 32 0 209 33 0 224 35 0 229 36 0 230 36 0 235 37 0 245 38 0 247 39 0 248 39 0 255 40 0 0 78 133 0 92 156 0 96 165 0 112 191 0 116 198 0 125 214 0 128 218 0 132 226 0 134 228 0 136 232 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@C??0@@??<@@O??@@A?? @@_?8@@C?<@@@?>@@@G? @@O?? @C??0@@??<@@G?>@@A?? @@O?0@@A?<@@@_>@@@C?@@@@?0@@@G
8@@@A>@@@@O@@@@A @@@@X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

mergeNextConflictAutoAdvance24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeNextConflictAutoAdvance24x24.xpm"

    "
     self mergeNextConflictAutoAdvance24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeNextConflictAutoAdvance24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeNextConflictAutoAdvance24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@LS(:N#(:N#(:N#(1PDA@PDA@PDA@PDA@D3<?O3<?O3<?O38QPDA@PDA@PDA@PDA@PCD?O3<?O3<?O2=@
PDA@PDA@PDA@PDA@P@8;O3<?O3<?N09@PDA@PDA@PDA@PDA@PD@WN#(:N#(:E$A@PDA@PDA@PDA@PDA@KCP4MSX6M#X5MCP*PDA@PDA@PDA@PDA@ES<?O#<?
O3<?O#<TPDA@PDA@PDA@PDA@PC\?O3<?O3<?O3Q@PDA@PDA@PDA@PDA@PAD>O3<?O3<?N1A@PDA@PDA@PDA@PDA@PD@-O#<?O38?KDA@PDA@PDA@PDA@PDA@
PD@ANS(:N#(9@DA@PDA@PDA@PDA@PDA@F"H"HR@ HB@!!H"H[PDA@PDA@PDA@PDA@BR$)JR$)JR$)JR$KPDA@PDA@PDA@PDA@PA8)JR$)JR$)JQ=@PDA@PDA@
PDA@PDA@P@\(JR$)JR$)J@]@PDA@PDA@PDA@PDA@PD@XJR$)JR$)FTA@PDA@PDA@PDA@PDA@PD@BIR$)JR$%ADA@PDA@PDA@PDA@PDA@PDA@CB$)JR$MPDA@
PDA@PDA@PDA@PDA@PDA@PBL)JRQ@PDA@PDA@PDA@PDA@PDA@PDA@P@$)JP)@PDA@PDA@PDA@PDA@PDA@PDA@PD@\GTA@PDA@PDA@PDA@PDA@PDA@PDA@PD@C
ATA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@') ; colorMapFromArray:#[0 31 55 0 33 57 69 11 0 71 12 0 73 11 0 78 12 0 82 12 0 82 13 0 95 14 0 95 15 0 96 15 0 105 16 0 119 19 0 126 20 0 0 44 74 0 44 75 0 45 78 0 47 81 0 47 82 0 49 85 0 56 95 0 61 103 0 65 110 0 66 112 147 24 0 153 24 0 158 25 0 163 26 0 169 27 0 174 27 0 178 27 0 182 28 0 190 37 12 192 33 5 201 32 0 207 33 0 213 33 0 240 38 0 243 38 0 250 39 0 251 39 0 255 40 0 0 78 133 0 81 138 0 81 139 0 85 144 0 90 155 0 92 155 0 91 156 0 91 157 0 97 165 0 97 166 0 98 167 0 99 169 0 100 170 0 101 172 0 111 189 0 113 192 0 118 201 0 132 226 0 133 227 0 134 229 0 135 231 0 136 232 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@??@@??@@_>@@_>@@O<@@??@@??@@_>@@_>@@O<@@O<@@??@@??@@_>@@_>@@O<@@O<@@G8@@C0@@C0@@A @@A @@@@@') ; yourself); yourself]
!

mergeNextConflictAutoAdvance32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeNextConflictAutoAdvance32x32.xpm"

    "
     self mergeNextConflictAutoAdvance32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeNextConflictAutoAdvance32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeNextConflictAutoAdvance32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
V%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)Z@RT)JR$)JR$)JR$)JR$)JRTAV%)ZV%)ZV%)ZV%)ZV%)ZI5!!YVU%YVU%YVU%YVU%YJE)Z
V%)ZV%)ZV%)ZV%)ZV%(OUE%YVU%YVU%YVU%YVUHOV%)ZV%)ZV%)ZV%)ZV%)ZV%(#VU%YVU%YVU%YVU%YH5)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)NVU%YVU%YVU%Y
VT5ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV!!MXVU%YVU%YVU%XD5)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV"5TUEQTUEQTUB1ZV%)ZV%)ZV%)ZV%)ZV%)ZV%(LQT!!HQ$-K
R4-KR4-KQ$!!HK@1ZV%)ZV%)ZV%)ZV%)ZV%(%VU%YVU%YVU%YVU%YVU$$V%)ZV%)ZV%)ZV%)ZV%)ZV%)PVU%YVU%YVU%YVU%YS5)ZV%)ZV%)ZV%)ZV%)ZV%)Z
V"EYVU%YVU%YVU%YVU$SV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV$-YVU%YVU%YVU%YRE)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZDUYYVU%YVU%YVUTQV%)ZV%)ZV%)ZV%)Z
V%)ZV%)ZV%)ZJ5%YVU%YVU%YJ%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%(NSUAPTEAPTD0LV%)ZV%)ZV%)ZV%)ZV%)ZV%)Z@"86M#X5MCP4MCP4MSX6M#@CV%)Z
V%)ZV%)ZV%)ZV%)ZF$MCP4MCP4MDQDQDP4MCGE)ZV%)ZV%)ZV%)ZV%)ZV%)ZNTMCP4MCP4QDQDQCP3)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%(XP4MCP4MCQDQDQDMC
FE)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%(2P4MCP4MDQDQDQCMZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV $?P4MCP4QDQDQ@BU)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV!!=CP4MC
QDQDQBAZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZAC-CP4MDQDP<A%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZFTMCP4MCP11ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)Z
V%)ZM4MCP4L9V%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%(UP$MCP1!!ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%(0P4L1V%)ZV%)ZV%)ZV%)ZV%)ZV%)Z
V%)ZV%)ZV%)ZV X=O %ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV!!4^V%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV QZV%)ZV%)ZV%)ZV%)Z
V%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV @a') ; colorMapFromArray:#[0 17 27 0 17 29 41 7 0 42 6 0 51 8 0 51 9 0 53 8 0 54 10 0 57 9 0 59 9 0 59 10 0 0 20 33 0 20 34 0 20 35 0 21 36 0 23 41 0 32 53 0 32 55 0 36 61 0 36 62 0 37 63 67 11 0 68 10 0 70 10 0 71 11 0 86 13 0 89 15 0 93 14 0 94 14 0 106 16 0 111 18 0 114 18 0 123 19 0 0 40 68 0 45 78 0 46 78 0 52 87 0 54 93 0 55 94 0 59 99 0 58 100 0 62 106 0 65 111 0 70 120 0 72 122 0 72 123 134 21 0 139 22 0 140 22 0 148 23 0 151 24 0 158 25 0 159 31 10 160 27 3 166 26 0 182 29 0 189 30 0 191 30 0 193 30 0 226 35 0 230 36 0 235 37 0 239 37 0 241 38 0 244 38 0 250 39 0 252 40 0 254 40 0 255 40 0 0 75 128 0 83 141 0 85 145 0 87 147 0 90 154 0 91 154 0 91 155 0 98 167 0 101 172 0 102 175 0 104 177 0 109 185 0 109 186 0 116 198 0 116 199 0 118 201 0 130 222 0 132 226 0 135 230 0 135 231 0 136 232 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@G??8@@??<@@O??@@A?? @@O?0@@C?<@@@_>@@A??>@@O??@@A?? @@_?8@@C?<@@@??@@@G? @@A?8@@G??8@@??<@@G?>@@A?? @@O?0@@C?<@@@_
>@@@G? @@@?0@@@G8@@@A>@@@@O@@@@C0@@@@X@@@@B@@@@@@@@b') ; yourself); yourself]
!

mergePrev24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergePrev24x24.xpm"

    "
     self mergePrev24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergePrev24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergePrev24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
EQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTU
EQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTH
BATUEQTUEQTUEQTUEQTUEQTUEQTUEQTPDATUEQTUEQTUEQTUEQTUEQTUEQTUEP4TE@4UEQTUEQTUEQTUEQTUEQTUEQTU@!!LTEALCEQTUEQTUEQTUEQTUEQTU
EQTUC!!PTEAPNEQTUEQTUEQTUEQTUEQTUEQTFEAPTEAPTAQTUEQTUEQTUEQTUEQTUEQTOEAPTEAPTC1TUEQTUEQTUEQTUEQTUEP(TEAPTEAPTE@(UEQTUEQTU
EQTUEQTU@QHTEAPTEAPTEADAEQTUEQTUEQTUEQTUB1PTEAPTEAPTEAPKEQTUEQTUEQTUEQTUAP\GA0\GA0\GA0\EEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTU
EQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTU
EQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTU') ; colorMapFromArray:#[0 38 64 0 38 65 0 46 78 0 46 80 0 54 91 0 55 91 0 54 92 0 56 96 0 61 104 0 65 110 0 66 111 0 78 134 0 79 134 0 80 136 0 98 167 0 117 201 0 126 216 0 128 218 0 129 220 0 134 229 0 136 232 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A @@A @@C0@@G8@@G8@@O<@@O<@@_>@@??@@??@@??@@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

mergePrev32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergePrev32x32.xpm"

    "
     self mergePrev32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergePrev32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergePrev32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!B (!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRDYFRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!C"@ CRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HPP\HB@[@2D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!D"@ HB@RHRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HP ^HB@ HA8FHRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!E"@ HB@ HAT!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HP, HB@ HB@ H@,!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HRD@F"@ HB@ HB@ F @!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HP< HB@ HB@ HB@ C2D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRDCGR@ HB@ HB@ HB@\
@2D!!HRD!!HRD!!HRD!!HRD!!HRD!!HQP HB@ HB@ HB@ HB@THRD!!HRD!!HRD!!HRD!!HRD!!HRDHG"@ HB@ HB@ HB@ HA8HHRD!!HRD!!HRD!!HRD!!HRD!!HQ  HB@ HB@ 
HB@ HB@ HA\!!HRD!!HRD!!HRD!!HRD!!HRD!!BP$IBP$IBP$HBP$IBP$IBRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HP@a') ; colorMapFromArray:#[0 26 45 0 30 52 0 30 53 0 30 54 0 32 54 0 34 58 0 35 58 0 34 59 0 35 60 0 37 64 0 39 69 0 43 72 0 43 73 0 53 90 0 54 92 0 57 96 0 57 97 0 73 124 0 73 125 0 75 129 0 76 130 0 94 160 0 94 161 0 95 162 0 99 168 0 109 187 0 117 200 0 125 213 0 126 216 0 127 217 0 134 228 0 134 229 0 136 232 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F@@@@A @@@@<@@@@_ @@@G8@@@C?@@@@?0@@@_>@@@O?0@@C?<@@A?? @@_?8@@O??@@C?
?0@@??<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

mergePrevConflict24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergePrevConflict24x24.xpm"

    "
     self mergePrevConflict24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergePrevConflict24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergePrevConflict24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0
LC@0LC@0LC@0LC@0LC@0LC@MB#@0LC@0LC@0LC@0LC@0LC@0LC@0LC@$H3@0LC@0LC@0LC@0LC@0LC@0LC@0LA8(JA00LC@0LC@0LC@0LC@0LC@0LC@0@2 (
JBXBLC@0LC@0LC@0LC@0LC@0LC@0HB (JB _LC@0LC@0LC@0LC@0LC@0LC@GJB (JB (AC@0LC@0LC@0LC@0LC@0LC@"JB (JB (HS@0LC@0LC@0LC@0LC@0
LA((JB (JB (J@40LC@0LC@0LC@0LC@0@BT(JB (JB (JBPALC@0LC@0LC@0LC@0GB (JB (JB (JB [LC@0LC@0LC@0LC@0B 4EC!!\WE1\OAP0JLC@0LC@0
LC@0LC@0LC@SK2</K2</ES@0LC@0LC@0LC@0LC@0LC@,K2</K2</KC@0LC@0LC@0LC@0LC@0LA /K2</K2</K1$0LC@0LC@0LC@0LC@0DB4/K2</K2</K28Q
LC@0LC@0LC@0LC@0JR</K2</K2</K2<*LC@0LC@0LC@0LC@0D1PVE!!XVE!!XVE!!XSLC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0
LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0') ; colorMapFromArray:#[74 11 0 75 12 0 96 15 0 100 15 0 108 17 0 109 21 4 110 20 4 112 18 0 117 18 0 118 18 0 119 18 0 124 19 0 123 20 0 126 20 0 82 44 55 81 46 57 0 38 66 0 41 70 0 52 89 0 53 91 0 54 91 0 55 96 0 56 96 79 61 83 0 65 111 0 66 112 128 20 0 147 23 0 152 24 0 153 24 0 157 24 0 184 29 0 190 30 0 219 35 0 222 35 0 234 37 0 238 37 0 242 38 0 251 39 0 253 40 0 255 40 0 0 79 133 0 83 141 0 117 199 0 118 202 0 127 217 0 129 220 0 136 232 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@A @@A @@C0@@G8@@G8@@O<@@O<@@_>@@??@@??@@??@@O<@@O<@@_>@@??@@??@@??@@@@@@@@@@@@@') ; yourself); yourself]
!

mergePrevConflict32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergePrevConflict32x32.xpm"

    "
     self mergePrevConflict32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergePrevConflict32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergePrevConflict32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEA
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPQ\VPTEA
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAKB-APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPQ,5MQ)APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTDH
LCT5K0MAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPRT5MST5H4EAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTDUMST5MST2BTEAPTEAPTEAPTEAPTEAPTEAPTEA
PTEAPR$5MST5MST''PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTDYMST5MST5MSTXPTEAPTEAPTEAPTEAPTEAPTEAPTEA@R85MST5MST5MR4BPTEAPTEAPTEAPTEA
PTEAPTEAPTD]MST5MST5MST5MQ1APTEAPTEAPTEAPTEAPTEAPTEABCD5MST5MST5MST5L@!!APTEAPTEAPTEAPTEAPTEAPTD&MST5MST5MST5MST5IDEAPTEA
PTEAPTEAPTEAPTEAESH5MST5MST5MST5MST2BTEAPTEAPTEAPTEAPTEAPTD*MST5MST5MST5MST5MST(PTEAPTEAPTEAPTEAPTEA@@ HB@TQHB@ HB@ D TH
B@!!APTEAPTEAPTEAPTEAPTEAPTEAG$A@PDA@PDA@G4EAPTEAPTEAPTEAPTEAPTEAPTEAPP(:PDA@PDA@PD@;CDEAPTEAPTEAPTEAPTEAPTEAPTEAHTA@PDA@
PDA@PD@"PTEAPTEAPTEAPTEAPTEAPTEAPP0<PDA@PDA@PDA@PC4NPTEAPTEAPTEAPTEAPTEAPTEAM$A@PDA@PDA@PDA@PC]APTEAPTEAPTEAPTEAPTEAPQ@?
PDA@PDA@PDA@PDA@O1AAPTEAPTEAPTEAPTEAPTEANDA@PDA@PDA@PDA@PDA@NTEAPTEAPTEAPTEAPTEAPTDKB0,KB0,KB0,KB0,KB00LPTEAPTEAPTEAPTEA
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEA
PTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPP@a') ; colorMapFromArray:#[36 6 0 52 7 0 50 8 0 54 8 0 50 10 5 50 11 6 56 9 0 58 9 0 59 9 0 62 9 0 0 30 50 0 31 54 0 32 53 0 32 55 0 34 57 0 36 61 0 36 62 41 36 50 40 36 53 64 11 0 66 10 0 67 11 0 69 10 0 74 11 0 76 12 0 83 13 0 92 14 0 100 15 0 102 16 0 112 18 0 0 46 81 0 49 85 40 49 72 0 60 102 0 65 110 131 20 0 135 21 0 140 22 0 145 23 0 170 27 0 174 27 0 182 28 0 187 29 0 202 31 0 211 33 0 214 33 0 221 35 0 232 36 0 238 37 0 242 38 0 249 39 0 250 39 0 252 40 0 255 40 0 0 78 133 0 82 141 0 100 171 0 104 178 0 118 201 0 120 207 0 129 220 0 131 224 0 135 230 0 135 231 0 136 232 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@X@@@@F@@@@C0@@@A>@@@@_ @@@O<@@@C?@@@A?8@@@??@@@O?0@@G?>@@A?? @@??<@@O??@@G??0@@G? @@C?<@@@?
?@@@_?8@@G?>@@C??0@@??<@@O??@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

mergeUsingA24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingA24x24.xpm"

    "
     self mergeUsingA24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingA24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingA24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAPTEAPTEAPTE
APTEAPTEAPPDA@PDAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAP@@@@TEAPTEAPTEAPTEAPPDA@PDAPTEAP@@
@@TEAPTEAPTEAPTEAPPDA@PDAPTEAP@@@@@EAPTEAPTEAPTEAPPDA@PDAPTE@@@E@@@EAPTEAPTEAPTEAPPDA@PDAPTE@@@EAP@EAPTEAPTEAPTEAPPDA@PD
APTE@@TEAP@@APTEAPTEAPTEAPPDA@PDAPT@@@TEAP@@APTEAPTEAPTEAPPDA@PDAPT@@@TEAPT@@@TEAPTEAPTEAPPDA@PDAP@@@@@@@@@@@@TEAPTEAPTE
APPDA@PDAP@@APTEAPT@@@TEAPTEAPTEAPPDA@PD@ @@APTEAPTE@@@EAPTEAPTEAPPDA@PD@P@EAPTEAPTE@@@EAPTEAPTEAPPDA@PDAPTEAPTEAPTEAPTE
APTEAPTEAPPDA@PDAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAPTEAPTEAPTEAPTEAPTEAPPDA@PDAPTEAPTE
APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTE') ; colorMapFromArray:#[0 0 0 18 23 10 70 90 40 165 211 94 165 211 95 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@_@@@_@@@_@@@_@@@_@@@_C @_C @_C0@_F0@_FP@_DX@_LX@_LL@__<@_XL@_8F@_0F@_@@@_@@@_@@@_@@@_@@@@@@@') ; yourself); yourself]
!

mergeUsingA32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingA32x32.xpm"

    "
     self mergeUsingA32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingA32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingA32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@LC@0LC@0PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@ HB@ HBA@PDA@PDA@PDA@PDA@PDA@PD
A@PDA@PDA@LB@ HB@ HDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@0HB@ HB@ PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@ HB@ HBA@PDA@PDA@PDA@PD
A@PDA@PDA@PDA@PDA@LB@ HB@ HDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@0HB@ HB@ PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@ HB@ HBA@PDA@PD
A@@@@@PDA@PDA@PDA@PDA@PDA@LB@ HB@ HDA@PDA@PD@@@@A@PDA@PDA@PDA@PDA@PD@0HB@ HB@ PDA@PDA@@@@@@@A@PDA@PDA@PDA@PDA@PC@ HB@ HB
A@PDA@PD@@@D@@@DA@PDA@PDA@PDA@PDA@LB@ HB@ HDA@PDA@@@@@P@@@PDA@PDA@PDA@PDA@PD@0HB@ HB@ PDA@PD@@@DA@P@@@PDA@PDA@PDA@PDA@PC
@ HB@ HBA@PDA@P@@@PDA@@@A@PDA@PDA@PDA@PDA@LB@ HB@ HDA@PD@@@@A@PD@@@@A@PDA@PDA@PDA@PD@0HB@ HB@ PDA@P@@@PDA@PD@@@DA@PDA@PD
A@PDA@PC@ HB@ HBA@PD@@@@A@PDA@P@@@PDA@PDA@PDA@PDA@LB@ HB@ HDA@P@@@@@@@@@@@@@@@PDA@PDA@PDA@PD@0HB@ HB@ PDA@@@@@@@@@@@@@@@
A@PDA@PDA@PDA@PC@ HB@ HBA@P@@@@DA@PDA@PD@@@@A@PDA@PDA@PDA@LB@ HB@ HDA@@@A@PDA@PDA@PD@@@DA@PDA@PDA@PD@0HB@ HB@ PD@@@DA@PD
A@PDA@P@@@PDA@PDA@PDA@PC@ HB@ HB@P@@@@PDA@PDA@PDA@@@@@PDA@PDA@PDA@LB@ HB@ HDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@0HB@ HB@ PD
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@ HB@ HBA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@LB@ HB@ HDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@0HB
@ HB@ PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@ HB@ HBA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@0LC@0LDA@PDA@PDA@PDA@PDA@PDA@PDA@PD
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@a') ; colorMapFromArray:#[0 0 0 96 122 55 165 211 95 165 211 96 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@C<@@@A?@@@@_0@@@G<@@@A?@@@@_0@@@G<@@@A?@\@@_0G@@G<C8@A?@6@@_0] @G<FL@A?A#@@_088@G<LF@A?GA @_1?<@G<_?@A?N@8@_3@F@G<0
A A?<@\@_0@@@G<@@@A?@@@@_0@@@G<@@@A?@@@@O0@@@@@@@@@b') ; yourself); yourself]
!

mergeUsingAAll24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingAAll24x24.xpm"

    "
     self mergeUsingAAll24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingAAll24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingAAll24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*1L8MC,;N34=OS5@PDAHPD!!HRD!!IRQZ+*2>O#9NS%Y"X(I"!!(ZF!!)*V&)*&**T*+*3RN#8>S$9VX&I"!!&JF!!(ZV%
)*Z&*T&+*3RI#8>O$9NU%Y"X(ZB!!(ZF&)*Z&*T"+*2:I"X&O#9VU&9"U&9. (JF!!(ZZ&)$^+*2:G"X>O#8>U%SPAEF*[&:B!!(ZF&)$&+*3RF!!8&I"X>O#00F
@U"[(JB!!(ZF&(T&+*2:F!!H&I#8&OVPD8@RBX&JB (JB!!(TB+*2:F!!(ZG!!8>NF !!\D05%&IV (JB!!(TB+*2>F_XZF"X%.AQ1$R0ET&I2X&:B!!(TB+*2U=_G2F
!!H%N@T>O^@T[^Y"X%ZB!!(DB+*295_G6D!!HPOB%6I#1 HVYVX&I" &36+*29<_G5=!!FDAGFE+Z44APIRU%Y"U&36+*2Y7]71=_Q<A@PDA@PDADV^U%YV[&36+
*2Y5]7]=]P$NSD=PT5LY@UZU%YVU%S6+*2Y5]WU7UPD/[XZD!!H%]@Q:G$9NU%S.+*2U1]WE7E0UW_W6D!!HRIC0- #8>S%S.+*2E1\WU7X%-(_W2F!!(RDZVA&
"X>O$3.+*2Y1\WE1]W]<_G5=!!''6D!!H&O#8:O#3.+*2U/[7E1]WU7_G1<_G2F!!HZI#8&O#3&+*2E,[611\WE5]7U<_XY<_XZF!!8&O#3.+*1@!!IRH&H2X&I"X.
K"8/K"8.MB8/MAF+*:.+*:.+*:.+*:.+*:.+*:.+*:.+*:.+') ; colorMapFromArray:#[0 0 0 1 1 0 1 2 1 4 5 2 5 6 3 6 6 3 7 8 4 7 9 4 9 11 5 13 16 7 15 18 8 18 21 10 20 23 11 24 28 13 29 35 16 31 37 17 31 41 18 37 43 20 36 44 20 37 44 20 38 45 21 39 45 21 43 47 22 44 54 24 46 55 26 48 57 27 54 65 30 59 69 32 64 76 35 64 77 35 69 81 37 69 84 40 77 89 42 74 95 43 76 96 43 76 96 44 77 96 44 77 97 44 78 97 45 80 99 44 80 98 45 81 98 45 81 99 45 80 99 46 80 100 46 81 100 46 82 100 46 83 102 47 84 100 46 84 100 47 84 102 46 86 102 47 87 102 47 86 101 48 85 102 48 87 102 48 86 103 48 88 102 48 88 103 48 89 103 48 89 104 48 90 105 49 91 105 49 90 106 49 92 105 49 92 106 49 93 106 49 93 106 50 94 106 50 94 107 51 95 107 51 95 108 51 96 108 51 97 109 52 98 109 52 98 115 54 99 119 55 102 119 56 102 122 56 107 128 59 108 129 59 109 130 59 109 131 59 110 131 60 112 131 61 118 145 66 125 147 69 129 158 72 134 156 73 139 165 78 143 168 78 139 172 78 145 171 80 145 172 80 146 174 81 147 175 81 148 175 82 151 181 83 149 183 83 152 182 84 158 186 87 157 184 88 159 190 88 164 194 90 160 196 89 167 200 92 173 201 95 173 206 96 167 213 96 173 209 97 175 208 97 168 212 96 169 213 96 171 214 97 172 214 97 173 215 98 174 215 98 175 215 98 175 216 98 175 216 99 178 210 98 180 210 98 176 216 99 176 217 99 177 217 99 178 217 100 178 218 100 179 218 100 180 218 100 180 219 101 181 219 101 182 219 101 182 220 101 183 220 101 183 220 102 185 219 102 185 220 102 185 221 102 185 221 103 186 221 103 186 222 103 187 222 103 188 222 103 188 223 104 189 223 104 190 223 104 190 224 104 191 224 104 191 224 105 192 225 105 193 225 105 193 225 107 194 225 107 194 226 107 195 226 107 196 226 107 196 227 107 197 227 107 198 227 107 198 228 107 199 228 108 200 229 108 201 229 108 201 229 109 202 230 109 203 230 109 204 231 110 205 231 110 206 232 111 207 232 111 209 233 111 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>@@@@') ; yourself); yourself]
!

mergeUsingAAll32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingAAll32x32.xpm"

    "
     self mergeUsingAAll32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingAAll32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingAAll32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+J0@"H"K#X:N%9^N%9^W%9:"%:J")JR$)J"(
*J"+*0B,+@BF"H.M#X:N#)^W%)^W'')Z"''JJ")JR$*J"(*J"+@J2,@HVE!!X"H#X6M#)^V%)ZV''):Y''*R$(*R((*"(*J @+J0@^(VE"8"H#X6N#(:V%)ZV%):Y
''):")I:((*"(*@B,+@BE!!XZF"H"K"8:N#)"V%)^V''):Y():$(:N"*J"(@J2,@G&E!!XZF"H.M#(:N#'')LSHJV&Y:Y''):#(:J"*J @+J0@^XU9"H"H"H"H"H:N
PP8@CIZW%*JW():#)JJ(*@B,+@A9]8!!9]8"E"H"J"(H/@@@@OIZV%92\''):")I:(@J2,@G]9^XE9"HZF"H"HQBD@FP@\#)^W%92W''):"(*P@+J0@]W]7]8U9
!!XZF"HX8@@T5A U*%)^V''I:^''):"( B,+@A7]7]7^XU:!!XVESR(@G$X$@B:U%YVU'')Z^''*J"@J2,@F95]7]9^W):!!XUBD0@:!!"<@D)VU%Y2V'')Z^'')8@+J0@
]V9.]7]9^''*F!!#@@B8ZMO@<@RX:N%)ZW'')Z"%0B,+@A.]WU.]7]:^'')FI @%"HYJI0@%#)VV%)^W%)Z"@J2,@F9.]V97]7]9^S I@D^E#XX1@@%:#)"U%YVX
&I0@+J0@[F9.]V9.]7%]J0@Q!!XVE!!S(W@CRJ%)JU%YVX&@B,+@A)[&9.[''U5]4@[@@$WE1\WE00@F(6N#)"U%Y"X@J2,@FY&[F9.]V95L0@@@@@@@@@@@@@@
SX6J#)VU%Y @+J0@Y&Y)ZV9.]T,(@A!!USUUUUUX:H@@)#X6N#)VU%PB,+@A&Y&Y)[&9)M1D@L'']9^XVE]7T,@ABH#X6N#)VU@J2,@FI&X&Y)[&X-@@U]]WU9
]7&E!!S(G@DNM"86M#)T@+J0@X&I&Y&Y)O2@@GV95]W%7^W^EQRH@HH.H#X6N# B,+@A"X&I"Y&Y[S$9)[''].^W]7^'')7UUU+!!XZH"H:N@J2,@E%"X&Y"Y&Y)
ZV%.[''].]7]:]7):!!W*E!!X"H#X8@+J0@X&I"X&I"ZVY)ZV%.[''].^W]7^''*E!!XVE!!XVF#PB,+@AYWE9"X&Y$X&Y)[&%.[''].]7]:^'')9!!XVE!!X6H@J2,@E%"
W%1"X&I&Y&Y)ZV%.[''U.]7]7^XU9!!XVE!!XT@+J0@VU1\W%1]X&I"ZVY)[&9.[&97]W]7^W)9!!XVE!!PB,+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+@@a') ; colorMapFromArray:#[0 0 0 1 1 0 1 1 1 3 3 2 3 4 1 5 7 3 7 8 4 9 11 5 10 11 5 11 13 6 11 14 6 12 15 7 14 17 8 16 19 8 17 19 9 17 20 9 20 23 11 22 27 12 26 30 14 30 36 16 30 36 17 31 36 17 30 37 17 31 37 17 34 42 19 38 44 21 39 46 22 46 55 25 48 56 26 49 60 27 50 59 28 51 62 28 52 61 29 56 67 31 58 69 32 62 73 34 65 76 35 67 79 36 70 83 39 73 86 39 75 92 42 84 99 47 85 101 47 90 108 50 93 111 51 94 117 53 98 114 54 101 118 55 105 126 58 109 128 60 110 132 61 115 138 64 119 140 66 125 146 68 127 149 69 127 156 72 130 154 72 132 157 73 135 158 72 133 157 74 135 157 74 134 159 74 136 159 74 131 160 73 133 160 74 138 163 75 136 163 76 140 166 78 146 171 80 146 175 80 148 173 82 148 177 81 149 178 82 154 181 85 159 186 87 154 188 86 168 196 92 168 199 94 164 201 92 164 202 92 169 200 92 169 204 94 170 204 94 171 204 94 171 205 94 171 205 95 172 205 95 172 206 95 172 207 95 166 211 95 167 213 95 170 210 95 167 213 96 172 209 96 168 212 96 168 213 96 169 213 96 170 213 97 171 214 97 172 214 97 172 215 98 173 215 98 174 215 98 175 215 98 175 216 98 175 216 99 179 210 98 181 215 100 176 216 99 176 217 99 177 217 99 178 217 99 178 217 100 178 218 100 179 218 100 181 217 101 180 218 100 180 219 101 181 219 101 182 219 101 182 220 101 183 220 101 183 220 102 185 216 102 187 218 102 188 217 102 185 220 102 185 221 102 185 220 103 185 221 103 187 220 103 186 221 103 186 222 103 187 222 103 188 222 103 189 222 103 188 223 104 189 223 104 190 223 104 190 224 104 191 224 104 191 224 105 192 224 105 192 225 105 193 225 105 193 225 107 194 224 106 194 225 107 194 226 107 195 226 107 196 226 107 196 227 107 197 227 107 198 227 107 198 228 107 198 228 108 199 228 108 200 228 108 200 229 108 201 229 108 201 229 109 202 229 109 202 230 109 203 230 109 204 230 109 204 231 110 205 231 110 206 232 110 207 232 111 208 233 111 209 233 112 210 234 112 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@G????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''??
??9????>_????''????9????>_????''????9????>_???? @@@@@b') ; yourself); yourself]
!

mergeUsingB24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingB24x24.xpm"

    "
     self mergeUsingB24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingB24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingB24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC
@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0L@@@@@@@@C@0LC@0LC@0LC@0HB@ HB@0L@@@LC
@@@@@0LC@0LC@0LC@0HB@ HB@0L@@0LC@0L@@@LC@0LC@0LC@0HB@ HB@0L@@0LC@0L@@@LC@0LC@0LC@0HB@ HB@0L@@0LC@0@@@0LC@0LC@0LC@0HB@ HB
@0L@@@@@@@@@@0LC@0LC@0LC@0HB@ HB@0L@@@LC@0@@@0LC@0LC@0LC@0HB@ HB@0L@@0LC@0L@@@LC@0LC@0LC@0HB@ HB@0L@@0LC@0L@@@LC@0LC@0LC
@0HB@ HB@0L@@0LC@0L@@@LC@0LC@0LC@0HB@ HB@0L@@@LC@@@@@@LC@0LC@0LC@0HB@ HB@0L@@@@@@@@C@0LC@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC
@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@0LC@0LC
@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC') ; colorMapFromArray:#[0 0 0 242 181 13 243 181 13 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@_@@@_@@@_@@@_@@@_@@@_O0@_L8@_HL@_HL@_HX@_O8@_LX@_HL@_HL@_HL@_L<@_O0@_@@@_@@@_@@@_@@@_@@@@@@@') ; yourself); yourself]
!

mergeUsingB32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingB32x32.xpm"

    "
     self mergeUsingB32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingB32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingB32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ HB@ LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB@ DA@PHB@0LC@0LC@0LC@0LC@0LC@0LC
@0LC@0LC@0HB@ DA@PHC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@ DA@PDA@PLC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB@PDA@PDA@0LC@0LC@0LC@0LC
@0LC@0LC@0LC@0LC@0HA@PDA@PDC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@ DA@PDA@PLC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB@ HA@PDA@0LC@@@@
@@@@@@@@@0LC@0LC@0LC@0LC@0HA@ DA@PDC@0L@@@@@@@@@@@@@@0LC@0LC@0LC@0LC@ DA@PDA@PLC@0@@@0LC@0LC@@@@@0LC@0LC@0LC@0LB@PDA@PDA
@0LC@@@C@0LC@0L@@@@C@0LC@0LC@0LC@0HA@PDA@PDC@0L@@@LC@0LC@0@@@@LC@0LC@0LC@0LC@ DA@PDA@PLC@0@@@0LC@0LC@@@@@0LC@0LC@0LC@0LB
@ DA@PDA@0LC@@@C@0LC@0@@@@LC@0LC@0LC@0LC@0HB@ DA@PDC@0L@@@@@@@@@@@@C@0LC@0LC@0LC@0LC@ DA@PDA@PLC@0@@@@@@@@@@@@@C@0LC@0LC
@0LC@0LB@PDA@PDA@0LC@@@C@0LC@0L@@@@C@0LC@0LC@0LC@0HA@PDA@PDC@0L@@@LC@0LC@0L@@@LC@0LC@0LC@0LC@ DA@PDA@PLC@0@@@0LC@0LC@0@@
@0LC@0LC@0LC@0LB@ HA@PDA@0LC@@@C@0LC@0LC@@@C@0LC@0LC@0LC@0HA@ DA@PDC@0L@@@LC@0LC@0@@@@LC@0LC@0LC@0LC@ DA@PDB@ LC@0@@@@@@
@@@@@@@@@0LC@0LC@0LC@0LB@PDA@PDB@0LC@@@@@@@@@@@@@0LC@0LC@0LC@0LC@0HA@PDA@PDC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@ DA@PDA@PLC
@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB@ DA@PDA@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0HB@ DA@PDC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@ HB
@PDA@PLC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB@PHA@PDA@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB@ HB@ HC@0LC@0LC@0LC@0LC@0LC@0LC@0LC
@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0@a') ; colorMapFromArray:#[0 0 0 243 181 13 243 181 14 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@C<@@@A?@@@@_0@@@G<@@@A?@@@@_0@@@G<@@@A?G?@@_1?8@G<XG@A?FA0@_1 \@G<XG@A?FC @_1?0@G<_>@A?FA0@_1 L@G<XC@A?F@0@_1 \@G<_
?@A?G?@@_0@@@G<@@@A?@@@@_0@@@G<@@@A?@@@@O0@@@@@@@@@b') ; yourself); yourself]
!

mergeUsingBAll24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingBAll24x24.xpm"

    "
     self mergeUsingBAll24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingBAll24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingBAll24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
6-+Z6-+Z6-+Z6-+Z6-+Z6-+Z6-+Z6-+Z6 89NS$?O3<?RD!!GQ4]MST5MTEAPT ?Z6#N.,[F7-;;A0\SH2,3N4MKU5]_X6EKZ6">.++F7-;^>/,GD2L+L3,?R
4-_W6EKZ6#N&+*:.,;^:.+;A1L#J3L/O5]WU55CZ6">$)*".++N7.+*>1LSH2,/K4MCU5UCZ6">^)J".+&D@@@@@A!!A.2L3L3\?O5UCZ6">Y(ZF&*E0@MVI#
O0$A[\#L2<7O347Z6".X(:N#)%0@Z;F7-74@H+?H2</N34/Z6""U&I&#)%0@Z;F1-9,@H[WH2L#K3$/Z6""R$)"#(5\@YI*\ AHA[K2?1L#H24_Z6""R#9JY
(5\@@@@@@@P9!![*</;?H24_Z6""K#9JU&E\@OF%)XADAW;":/K?D2D_Z6!!:K"8>R%U\@Y:N$+*$JA7:8.+2>1D_Z6!!:F"8*O%UP@Y:N#(*8S@F>7-;:>/#?Z
6!!:C!!(*O#5P@YI"#(:HH@721-;^7/#?Z6!!:C 8ZK"5L@G59^OP4@HG>.,;N;/$CZ6!!]4 8ZF"5L@@@@@AP0>^Z".++N3-3?Z6!!]4]GVF!!8E0]7Y:^G.](:"&
+*:1-3''Z6!!]3]GU5!!H^K"8>R%I&Y(ZF$*J*1,S''Z6!!Q2\7Q5 8ND"8.K$)JY&Y&#)*Z.+#_Z6!!Q2\''M4]WVC 8.K"9JR&Y&#(:Z(*S''Z6 ,TE1\WFQ8^G!!8%
IR (J",/J3L3L0;Z6-+Z6-+Z6-+Z6-+Z6-+Z6-+Z6-+Z6-+Z') ; colorMapFromArray:#[0 0 0 5 5 1 6 5 2 9 8 2 13 11 3 16 14 3 18 15 5 26 23 7 33 29 7 32 29 9 38 33 9 49 36 3 51 43 10 53 45 11 50 44 12 51 50 20 57 51 17 65 57 16 71 63 18 73 63 17 113 85 7 113 86 9 113 86 10 114 87 10 114 88 11 114 88 12 114 89 12 114 89 13 114 90 13 114 90 14 114 91 15 100 83 17 103 89 23 98 88 27 99 89 29 114 91 16 115 92 16 115 92 17 115 94 17 115 94 18 115 94 19 115 95 19 115 95 20 115 96 20 115 96 21 115 97 21 115 97 22 115 98 23 116 98 23 116 98 24 116 99 24 116 99 26 116 100 27 113 99 28 115 101 30 116 101 28 116 101 29 116 102 29 116 103 30 117 103 31 121 103 26 123 104 25 126 106 26 117 104 32 117 105 32 117 105 33 117 105 34 117 106 34 117 106 35 117 107 35 117 107 36 117 108 36 117 108 37 117 109 37 117 109 38 117 109 39 117 111 40 118 112 41 118 113 43 118 113 44 118 114 45 118 115 46 118 116 47 134 108 20 134 109 21 134 110 22 134 111 23 134 112 25 134 113 26 134 114 27 135 114 29 135 115 30 135 116 30 135 117 31 138 116 26 134 118 34 136 118 32 137 120 33 140 123 36 140 124 38 147 127 33 153 128 28 153 128 29 153 130 30 152 130 33 152 131 34 154 134 36 154 135 37 159 142 43 156 141 46 158 144 47 188 166 47 194 157 29 243 185 18 243 186 20 244 188 22 244 190 24 244 191 26 197 162 33 205 168 33 205 170 37 201 171 43 214 177 37 214 179 41 197 172 48 194 173 53 205 181 53 215 186 50 211 186 53 236 190 34 245 193 28 245 194 30 245 194 31 222 197 58 245 196 32 245 196 33 245 197 35 245 198 35 246 198 35 246 199 36 246 199 37 246 200 37 246 200 38 246 201 39 246 201 40 246 202 41 246 203 41 246 203 42 246 204 43 247 204 43 247 205 44 247 205 45 247 206 46 247 207 47 237 206 55 229 204 61 236 206 57 240 203 48 247 208 48 247 208 49 247 209 49 247 209 50 245 210 52 248 210 51 248 211 52 248 212 53 248 212 54 248 213 54 248 213 55 246 213 58 248 214 56 248 214 57 248 215 57 249 216 58 249 216 59 249 217 59 249 217 60 249 218 61 249 218 62 249 219 62 249 219 63 241 219 70 249 220 64 249 221 65 250 222 66 250 222 67 250 223 68 250 224 69 250 225 70 250 225 71 250 226 71 250 226 72 250 227 73 251 227 73 250 227 75 251 228 74 251 228 75 251 229 75 250 229 77 251 230 76 251 230 77 251 231 79 251 232 79 252 233 81 252 234 81 252 235 83 252 235 84 252 236 85 252 237 85 252 238 87 252 238 88 253 240 89 253 240 90 253 241 91 253 241 92 253 243 94 253 244 96 254 246 98 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>@@@@') ; yourself); yourself]
!

mergeUsingBAll32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingBAll32x32.xpm"

    "
     self mergeUsingBAll32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingBAll32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingBAll32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8.H@*J&,-KR4.+2<0,GA1,''I3-CR4=[X6-+Z
7=?!!8PC"8 B%*J&)-KR4.+*<0,GF1,''N3-CS4=[X6-+Z7=?!!@NK"@JN#*J")-KR8/K2<0LKD1L''I3,?R4-#Z6-+Z6-<@8.H@(JN(*J&)+KR4-K2<0LCD1L''I
3,?R4-WU6-+]7PC"8 B[(JB%*J&)-KR4-K2<0LKB1L''K4MCR4-WX6-+Z@NK"@I. (JB(*J&)%WU7]7%9^:?D2\SK3,;R4-WX6-(@8.H@&9.\''9>%)Z!!VEP@@
@@@@BQ8/.\''I2]CR4-#X6@C"8 BR&92Z'':V%*EXZ@A(''JBDM@@@Q,L''I3-CR4-OX@NK"@IJR&)*\''I2%U!!(@Q:&5.''06B0@11\''N3,;R4= @8.H@#)JX&I2\
''JUPF AF-KR5.'',2@BGB2\SK3,;S4 C"8 BN$)JR&I*\''EHX@DZ)-J25,3P@HLKB1L''I3,?R@NK"@H.N$)JX&I2\TA @Q*&)+KQ$K @+/LKB0,''I2<<@8.H@
"8.K$)JR&I!!PF@@7Y&]#O#@CAVV</\KB1L''D3 C"8 BH"8.K$)JX&D,U@@@@@@@@@BAX.+*</\KD1L/K@NK"@HRH"8.N#)JRR1(@D2X&JA(J@B&T.+2</LGA
1\$@8.H@ ("H"H.N$)IHE AB''9>_($X-@A*4-K*</[7A2PC"8 A?_8RH"H:K$$ Z@C>_''9>_)T8I@EF1-K*</LCA@NK"@GM? 8"H"H.KRAX@PY*Z''9>%T1(@
M[F4.+*<0L@@8.H@\(M?_8"H"8-HD0@?&)*_''9=OBP@>(+R4-K"<0@C"8 A/\''Q?_8"H"C0S@C&P&).XP"0@@6"(*[R4.KR<@NK"@FE/\7M? 8"DN1L@DBL#
H1@I@@@3*J")*[R4-K0@8.H@XF=/\7M? 8P:D@@@@@@@AP0*P9>_*J&)*[R4-@C"8 A"X&I/\''I?_75)ZV%,[&9>$I*\''I2''*J&)*[R4@NK"@E=_W6=/\''=?
 (ZF#8*K#9BZ&I*\''I>%)Z"),:$@8.H@WU= XV=/_7=?_8RF"H>O#9BX$I*Z''92%)ZV)-@C"8 A\WVA XVE"X''=?_8ZF"H&O$IBP&)*Z''I>%)Z")@NK"@E%\
WFA XFI"\''=2 8RD!!(>O#9BP&)*\''I2%)ZT@8.H@VU1\WFA X&I"\''JC 8RF!!("K#9BP&)*\''I>%)PC"8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@NK"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8.K"8 @a') ; colorMapFromArray:#[0 0 0 1 1 0 3 3 1 4 3 1 5 5 1 7 6 2 9 8 2 10 9 2 11 9 2 10 10 3 13 11 3 17 15 5 23 19 4 30 27 8 31 28 9 33 27 5 33 27 6 34 29 7 35 30 7 38 31 6 38 31 7 35 31 9 38 32 7 37 32 9 38 32 8 38 33 8 38 33 9 39 34 9 36 32 10 37 33 10 38 35 12 42 37 11 40 37 12 44 40 13 46 41 12 48 40 9 48 40 10 51 43 11 51 44 12 50 44 13 52 46 14 54 48 14 62 53 13 73 66 20 81 69 18 83 73 20 93 83 25 101 92 30 106 93 27 105 95 31 109 98 30 123 106 28 117 105 32 130 114 32 140 126 40 147 127 34 144 127 36 170 141 31 178 144 27 184 151 29 184 151 31 184 152 31 158 138 40 170 142 32 170 143 33 170 143 34 170 145 36 175 149 38 171 148 40 171 149 41 171 150 42 171 150 43 185 154 33 185 154 34 185 155 35 185 156 37 185 157 37 186 158 39 177 155 42 180 155 40 186 159 40 181 160 46 186 160 41 186 160 43 186 161 43 187 162 43 187 163 45 184 161 46 191 169 51 243 183 15 243 184 17 243 185 18 243 185 19 243 186 20 244 187 21 244 188 22 244 189 23 244 190 25 244 191 26 204 178 50 203 180 54 203 183 57 216 187 50 216 188 51 219 190 52 230 187 35 230 188 36 230 189 37 230 189 39 231 190 40 231 191 42 245 192 28 245 193 28 245 193 29 245 194 30 245 194 31 245 195 31 216 192 56 217 192 57 217 193 59 217 194 60 217 195 62 219 196 60 217 196 62 220 197 61 238 192 35 236 198 45 245 196 32 245 196 33 245 197 34 245 197 35 246 198 35 246 198 36 246 199 36 246 199 37 246 200 37 246 200 38 246 201 39 246 201 40 246 202 40 246 202 41 246 203 42 246 204 43 247 204 43 247 205 44 247 205 45 247 206 46 247 207 47 228 203 60 233 205 59 243 206 50 247 208 48 247 208 49 247 209 49 247 209 50 248 210 51 248 211 52 248 211 53 248 212 53 248 212 54 248 213 54 248 213 55 243 211 57 248 214 56 248 214 57 248 215 57 248 215 58 249 216 58 249 216 59 249 217 60 249 218 61 249 218 62 249 219 62 249 219 63 249 220 63 235 214 69 237 217 73 246 219 66 249 220 64 248 220 65 249 221 65 250 222 66 250 222 67 250 223 67 250 223 68 240 220 74 250 224 69 250 225 70 250 225 71 250 226 71 250 226 72 250 227 73 251 227 73 251 228 74 251 228 75 251 229 75 251 229 76 251 230 76 251 230 77 251 231 78 251 231 79 251 232 79 251 232 80 251 233 80 252 233 81 252 234 81 252 234 82 252 235 83 252 235 84 252 236 84 252 236 85 252 237 86 252 238 87 252 238 88 252 239 88 253 240 89 253 240 90 253 241 91 253 242 92 253 242 93 253 243 94 253 244 96 254 245 96 254 246 97 254 247 99 254 248 101 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@G????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''??
??9????>_????''????9????>_????''????9????>_???? @@@@@b') ; yourself); yourself]
!

mergeUsingBase24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingBase24x24.xpm"

    "
     self mergeUsingBase24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingBase24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingBase24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
EAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAHRD!!LREAPTEAPTEAPTEAPTEAPTEAPTEAHRD!!HREAPTEAPTEAPTEAPTEAPTEAPTEAHRD!!HREAPTEAPTEAPTEAPT
EAPTEAPTEAHRD!!HREAPTEAPTEAPTEAPTEAPTEAPTEALRD!!HREAPTEAPTEAPTEAPTEAPTEAPTEALH@@@@@@@@EAPTEAPTEAPTEAPTEAPTEALG@@TI@ @@@APT
EAPTEAPTEAPTEAPTEAHG@@0REAPT@@@TEAPTEAPTEAPTEAPTEAHG@@0REAPT@@@TEAP@@@@@@APTEAPTEAHG@@,QEAP@@APTEAP@EAPT@@@TEAPTEALG@@@@
@@@@@APTEAPTEAPTE@@@EAPTEALG@@XK@1P@@APTEAPT@@@@@@@@EAPTEALG@@0REAPT@@@TE@@@@APTE@@@EAPTEALG@@0REAPT@@@TE@@@EAPTE@@@EAPT
EALG@@0REAPT@@@TE@@@EAPTE@@@EAPTEALG@@TI@ @@@@@TE@@@EAPT@@@@EAPTEALG@@@@@@@@@APTEAP@@@@@E@@@EAPTEALPC <NEAPTEAPTEAPTEAPT
EAPTEAPTEALRD!!HREAPTEAPTEAPTEAPTEAPTEAPTEALRD!!HREAPTEAPTEAPTEAPTEAPTEAPTEAHRD!!HREAPTEAPTEAPTEAPTEAPTEAPTEAHRD!!HREAPTEAPT
EAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPT') ; colorMapFromArray:#[0 0 0 25 48 63 25 49 63 30 57 72 33 63 81 37 70 91 40 76 98 41 79 101 42 81 104 46 90 116 50 95 122 50 98 126 51 99 128 66 128 165 67 129 166 70 134 173 77 149 191 79 152 196 83 160 206 83 161 206 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@_@@@_@@@_@@@_@@@_@@@_8@@_<@@_F@@_FO _LH0_<@X_,G8_F\X_FXX_FXX_>X8_<OX_@@@_@@@_@@@_@@@_@@@@@@@') ; yourself); yourself]
!

mergeUsingBase32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingBase32x32.xpm"

    "
     self mergeUsingBase32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingBase32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingBase32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1TUEQTUEQ\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UE!!XVE!!XVE1\WE1\WE1\WE1\WE1\WE1\W
E1\WE1\WE1TVE!!XVE!!XWE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WEQXVE!!XVE!!\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UE!!XVE!!XVE1\WE1\WE1\WE1\W
E1\WE1\WE1\WE1\WE1TVE!!XVE!!XWE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WEQXSDQDQDQ@WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UE!!@H@@@@@@@@@@@W
E1\WE1\WE1\WE1\WE1\WE1\WE1TVD@$@B@0C@@@@@@@WE1\WE1\WE1\WE1\WE1\WE1\WEQXPBP@NE!!\WE1\@@@@WE1\WE1\WE1\WE1\WE1\WE1\UE!!@I@@8V
E1\WE0@@@A\WE1\WE1\WE1\WE1\WE1\WE1TVD@$@C!!XWE1\W@@@@E1\WE1\@@@@@@@@WE1\WE1\WEQXPBP@NE!!\WE1\@@@@WE1\W@@@@@@@@@@@WE1\WE1\U
E!!@I@@4QDA\W@@@@E1\WE1\@E1\WE1\@@@@WE1\WE1TVD@$@@@@@@@@@@A\WE1\WE1\WE1\WE1\@@A\WE1\WEQXPBP@EC@L@@@@@@A\WE1\WE1\W@@@@@@@@
@A\WE1\VE!!@I@@8VE1\WE0@@@A\WE1\@@@@@@@@@@@@@E1\WE1TVD@$@C!!XWE1\WE0@@E1\WE0@@@A\WE1\@@@@WE1\WEQXPBP@NE!!\WE1\W@@@@E1\@@@@W
E1\WE0@@@A\WE1\UE!!@I@@8VE1\WE1\@@@@WE0@@E1\WE1\W@@@@E1\WE1TVD@$@C!!XWE1\W@@@@E1\W@@@@E1\WE0@@@@@WE1\WEQXPBP@DB L@@@@@@@@W
E1\W@@@@@@@@@@@@@A\WE1\UE <E@@@@@@@@@@@WE1\WE1\W@@@@@@@W@@@@E1\WE1TVEAHRD!!HWE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WEQXVE!!XVE!!\W
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UE!!XVE!!XVE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1TVE!!XVE!!XWE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WEQXV
E!!XVE!!\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UE!!XVE!!XVE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\UEQTUEQTWE1\WE1\WE1\WE1\WE1\WE1\WE1\W
E1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE0@a') ; colorMapFromArray:#[0 0 0 8 16 20 9 17 21 9 17 22 11 21 27 11 21 28 11 22 29 12 23 29 12 22 30 13 24 32 16 31 40 17 32 42 17 33 42 43 83 107 50 96 123 62 119 153 62 120 154 72 139 179 77 149 192 80 154 198 81 157 202 84 159 205 83 160 206 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@C<@@@A?@@@@_0@@@G<@@@A?@@@@_0@@@G>@@@A?>@@@_?0@@G<N@@A?C @@_08O0G<NG>A?''AA0_? @LG?<@?!!?C!!?8_0X\NG<GNC!!?A3@8_088^G?>
G?!!?>@>8_0@@@G<@@@A?@@@@_0@@@G<@@@A?@@@@O0@@@@@@@@@b') ; yourself); yourself]
!

mergeUsingBaseAll24x24
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingBaseAll24x24.xpm"

    "
     self mergeUsingBaseAll24x24 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingBaseAll24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingBaseAll24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
5-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5!!9ST5MVV%)ZV%9^W&I"X&Q$[V5-[2GV5$.=/\GC1\WI2L''I3L3N3<?R4-OU5V7V5$&=/\GA0<WE2\#I3L3N3,?O
4-KR5V7V5$&9.<F=0\GG1<_H2\''L3,;O3=KR46;V5$&9.[.=/\F>0<_G2\''I3L3N3=KQ4&7V5$YY@@@@@@8 _\OG1<#I2<3N3,?O4&/V5$YY@CQ)ZULW@8OC
1\#H2\/L3L?O36KV5$YY@G*9.[6N@COC0<_G2L''K3L;N36/V5$IU@G*4.K&(@CCC09@(EPLSI8/L3&KV5$IQ@F&Z&(0#@8F=/'',/^XI0GANU3&KV5#5M@@@@
@@@IQKGA/+7D1<WH. Y&3E7V5$IM@D6D!!GH#@6^=/[% F 8C@0@13FGV5#5M@G^/-KR4FAVV/R(BMHFG!!0(-2VGV5#1M@GV,+KR4I BJ.P *+,GC/0@-2E7V
5#1M@GV++KJ-E0ZM.@ //[?A^P@-1U+V5#)A@CI2]FT_@B:''.RHQ_:9?DPX)1%7V5#)A@@@@@@([SYR4-I %B X]^@8)1U+V5#&Y"H&R$96]+J>2-KV5&(>&
.9*U05+V5#* (ZF$)J&+*:>/-KR7.[&9.<F;0U+V5#Z\(JF!!(*R)*Z2/+[R4-[V9.[7A0T7V5#Z\(ZF!!(ZR)*Z&++J24-KR4.[&9/EOV5!!,6M3$:N#(;N3-B
P#5FP$YIRT%MT1;V5-[V5-[V5-[V5-[V5-[V5-[V5-[V5-[V') ; colorMapFromArray:#[0 0 0 1 1 2 2 3 3 2 4 5 3 4 5 3 5 6 3 6 7 4 6 8 5 7 9 6 10 11 6 10 12 7 11 13 7 12 14 8 13 15 9 14 16 9 15 19 9 16 19 10 16 20 11 17 20 11 18 21 11 19 23 13 20 23 15 23 29 14 24 29 17 28 33 18 31 39 20 32 38 17 32 41 23 35 41 22 36 44 23 37 45 23 41 50 25 40 48 29 43 48 30 49 59 30 50 60 30 50 61 31 51 61 32 53 65 36 56 65 36 57 67 39 63 76 41 64 76 41 65 77 42 66 77 42 66 78 40 67 83 43 69 82 43 70 84 46 72 84 41 72 89 46 73 88 47 77 93 49 78 94 39 74 97 40 75 97 40 77 97 41 77 98 43 78 98 44 79 98 44 79 99 45 80 99 46 80 100 46 81 100 47 81 100 45 83 104 46 83 104 47 84 105 50 82 99 48 82 101 49 83 101 50 83 102 50 84 102 51 84 102 52 85 103 52 86 103 53 86 103 49 84 104 48 84 105 49 85 106 50 86 106 51 87 107 53 86 104 54 87 104 55 87 105 51 88 107 55 88 105 53 88 107 52 88 108 53 88 108 56 89 105 57 89 105 57 90 106 58 90 106 60 91 107 61 92 107 57 92 110 61 92 108 62 94 108 63 94 109 63 95 109 55 94 116 63 96 113 59 98 118 60 102 125 62 102 124 63 102 124 64 95 109 65 96 109 65 96 111 66 97 111 67 98 111 65 101 119 67 107 127 63 106 129 60 105 130 60 105 131 61 107 133 62 107 133 63 108 133 66 107 128 68 108 128 67 111 136 70 112 133 67 112 136 71 114 136 71 114 137 70 114 138 71 115 139 72 116 138 76 118 139 74 119 141 69 117 144 69 118 145 80 127 151 82 129 153 74 134 169 76 136 171 83 137 166 92 141 165 86 142 173 85 143 174 89 143 173 89 146 177 95 150 179 95 152 182 82 147 184 84 149 185 91 155 190 102 157 183 96 158 191 98 159 191 94 157 192 87 159 201 95 160 194 95 160 195 86 162 207 91 161 200 92 161 201 88 164 208 89 165 209 91 166 210 92 167 211 94 168 211 95 170 212 97 160 194 101 165 199 99 166 203 104 169 204 97 171 213 98 172 214 99 173 215 101 174 215 103 175 214 108 175 211 102 175 216 109 176 211 109 177 213 102 176 216 104 177 217 105 178 218 107 178 218 107 179 219 108 180 219 110 181 220 111 183 221 115 179 212 113 183 220 113 184 222 114 185 223 115 186 223 117 185 220 116 185 221 117 187 224 119 189 224 118 188 225 118 189 225 120 190 226 121 191 226 123 192 227 124 193 228 126 194 229 126 195 229 127 196 230 129 197 230 130 198 231 131 199 232 133 200 233 134 202 234 136 203 234 137 204 235 139 205 236 140 206 237 142 208 238 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>_??>@@@@') ; yourself); yourself]
!

mergeUsingBaseAll32x32
"      Loaded from: /home/jv/work/icons/merge-tool-icons/mergeUsingBaseAll32x32.xpm"

    "
     self mergeUsingBaseAll32x32 inspect
     ImageEditor openOnClass:self andSelector:#mergeUsingBaseAll32x32
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary mergeUsingBaseAll32x32'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
VE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@VE @ST5OS4=OTEEPTUEQTUIRT%ITUEQTUUUU
U%YVU0AXV@AMST5OS4=OTEAQTUEQT%IRT%MTUEQUUUUUUUYV@E!!X@D1LST5OS4=OS5AQTUEQTUIST5MTUEQTUUUUUUX@VE @SD1MST5OS4=PS5APTUEQT%ER
T%MTUEQTUUUUU AXV@AJSD1MST5OS4=OTEAQTUEQTUMRT5MTUEUUUUUU@E!!X@D)BLSD1L#H2MT-PS5APTUERTUEST%MTUEQUUUT@VE @R#DI@@@@@@@BBQUA
S5APTUEQTUIRT%ITUEQUUPAXV@AJLP$@A0,KC@X@@@]GTEAQTUEQT%IRT%ISUEQU@E!!X@D$1BP@&SD1MSRHD@AUPTEAPTUERT%IRT%QTUEP@VE @RSDI@BYJ
R$1MSQT@B$=OTEEQS$@5MTART%QTU@AXV@AILP @I$)JSD=LG@@IS4=OPRXTB P@AQD/T%IT@E!!X@DX1B@@&R$)LR#$T@AAOS4<5B @GC 8F@@@''T%P@VE @
RC@I@A(0LSD*E0@AM$5OS3<^QUEPT$8[@@UQT AXV@AFL@$@@@@@@@@@A3IJS45OS49PTEANT$TQ@CMR@E!!X@C80B@@GB04MB@D@B3]MST5OSB<!!F1\VF@0@
H%H@VE @Q"8H@BUIRD%JM1H@A45MSS<\A@@@@@@@@@@[T AXV@@>L@ @IT!!IRT)JLPD@JD1LH @AF3YKTD,U@A-Q@E!!X@C80B@@%RD!!IRT$1BP@WR$\T@A)O
S5EONAH@FUD@VE @O"4H@BUFRD!!IR"(A@A5JQAD@H$5MS$<)@ @YTPAXV@@>KP @HC,;N3\*D0@AM4)JE@@KP$5GJ <@@A%Q@E!!X@C8+B@@GB0,KBPD@@A5J
R$(,@0@EC0<CAAD@FU@@VE @OR4E@@@@@@@AAP<.RT%JR$(.DPTAAAMDDP@[T@AXV@@=O#4>O#9FQ$YFQ$%IRT%JR$)JSD1MST5OST=P@E!!X@C0=OS8>O#9F
Q$YFQ$!!IRT)JR$)LR$1MST5OS4<@VE @OS0=OS4>O#8>Q$YFQ$%IR$%JR$)JST1LST5MS0AXV@@:OS0=OS4>O#9FQ$YFRT!!IRT)JR$)MSD1MST5O@E!!X@C(<
OC4=OS4>O#8>Q$YFQ$!!IRT)JR$)LSD)MST4@VE @N#(<OS0=OS8>O#9FQ$YFRD!!IRT%IR$)JSD5MSPAXV@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@E!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XV@@a') ; colorMapFromArray:#[0 0 0 4 7 9 5 9 10 8 12 15 9 14 17 10 17 21 14 22 26 15 24 29 15 26 33 17 28 34 20 32 38 22 36 44 25 38 45 23 39 48 27 43 51 28 47 57 30 50 60 32 50 60 33 54 64 35 58 70 39 62 75 43 69 82 47 73 86 47 76 92 50 78 93 51 80 95 47 79 98 52 83 98 54 87 105 53 89 109 60 95 112 63 96 114 55 96 120 62 100 121 64 102 122 66 106 127 59 103 129 60 104 129 65 108 131 75 114 135 71 115 139 76 120 143 75 124 150 70 127 159 74 126 154 70 126 160 75 129 159 85 132 156 77 131 161 81 134 163 84 136 164 90 139 162 89 142 169 93 145 171 92 148 178 92 154 188 100 156 186 97 159 192 85 162 207 93 161 201 87 163 208 90 165 210 94 169 212 101 163 195 106 165 193 106 168 199 100 165 200 103 169 205 107 172 205 112 173 204 99 173 214 109 174 209 102 175 216 103 176 217 107 180 219 114 180 214 112 183 221 114 185 223 120 185 218 117 188 224 121 190 226 125 194 228 129 197 231 131 199 232 134 201 233 138 205 236 143 208 238 144 209 238 0 0 0]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@G????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''????9????>_????''??
??9????>_????''????9????>_????''????9????>_???? @@@@@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-FileBrowser'!

addTabEnteredIcon
    <resource: #programImage>

    ^ self addTabEntered14x14Icon
!

changesBrowserIcon
    <resource: #programImage>

    ^ self changesBrowser24x24Icon
!

copyFileIcon
    <resource: #programImage>

    ^ self copy20x20Icon
!

cutFileIcon
    <resource: #programImage>

    ^ self cut20x20Icon2
!

deleteFileIcon
    <resource: #programImage>

    ^ self erase20x20Icon
!

desktopIcon
    <resource: #programImage>

    ^ self desktop24x24Icon
!

diffIcon
    <resource: #programImage>

    ^ self diff16x16Icon2
!

directoryBookmarks20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self directoryBookmarks20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#directoryBookmarks20x20Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class directoryBookmarks20x20Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@X&I"X&I"X&I"X&I"X&I"X&I"X A"X&I"X&I"X&I"B0,KB0,KB6I"@FI"X&I"X&I"X&HKW5=_W5<KX&H@X&H@@@@@@@@@
X -_W5=_W0-"X A"X A#X6M#X0A"B5=_W5=_B6I"@FH@X6M#X6M#X0@KW5=_W5<KX&H@@@@@@@@@@@@@@@-_W5=_W0,@@@@@X6M#X6M#X6M#B5=_W5=_B6L@
@@A#X6M#X6M#X6LKW5=_W5<KX0@@@FM#X6M#X6M#X0-_W5=_W0-#@@@@X6M#X6M#X6M#B5=_W5=_B6L@@@A#X6M#X6M#X6LKW5=_W5<KX0@@@FM#X6M#X6M#
X0-_W5=_W0-#@@@@X6M#X6M#X6M#B5< B1=_B6L@@@A#X6M#X6M#X6LKW0-#B5<KX0@@@FM#X6M#X6M#X0,KX6M#B0-#@@@@X6M#X6M#X6M#B6M#X6M#B6L@
@@A#X6M#X6M#X6M#X6M#X6M#X0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 71 169 0 71 170 0 74 172 0 78 174 0 83 177 0 100 189 0 106 193 0 107 193 0 112 196 0 118 201 0 122 205 0 128 208 0 128 209 0 132 212 0 133 212 0 137 215 0 138 215 0 141 218 0 144 220 18 78 164 19 80 169 19 81 168 20 79 165 22 138 207 23 81 167 23 91 173 23 138 207 26 92 173 39 141 229 41 141 229 42 134 204 43 135 204 43 142 209 48 144 209 51 192 255 59 166 231 59 195 255 61 166 231 61 166 232 66 198 255 72 171 234 73 200 255 74 172 234 75 172 234 82 204 255 84 176 236 87 177 237 88 178 238 89 207 255 97 209 255 98 182 239 100 182 239 101 183 240 104 213 255 109 187 241 111 156 203 112 216 255 113 188 243 121 191 244 121 221 255 123 193 245 125 194 245 126 221 255 131 196 246 135 197 247 136 198 248 136 226 255 140 200 248 140 228 255 144 202 250 146 203 250 148 203 250 149 232 255 150 233 255 151 189 220 153 205 252 153 206 252 154 207 252 156 194 223 159 209 253 160 237 255 162 209 253 163 238 255 168 241 255 173 243 255 174 243 255 181 201 223 182 206 226 183 248 255 186 249 255 191 251 255 195 252 255 201 220 238 201 255 255 202 216 231 210 226 242 211 229 247 255 0 0 226 226 111 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@A?@@A?@G=?@G=?@O??@_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0');
                            yourself);
                yourself
        ]
!

directoryBookmarksIcon
    <resource: #programImage>

    ^ self directoryBookmarks20x20Icon
!

directoryUpIcon
    <resource: #programImage>

    ^ self upArrow20x20Icon
!

documentsIcon
    <resource: #programImage>

    ^ self documents26x26Icon

    "Created: / 25-10-2010 / 09:21:23 / cg"
!

dosShellTerminalIcon
    <resource: #programImage>

    ^ self dosWithoutText20x20Icon
!

editApplicationIcon
    <resource: #programImage>

    ^ self editIcon
!

editFileIcon
    <resource: #programImage>

    ^ self edit20x20Icon
!

editIcon
    <resource: #programImage>

    ^ self edit20x20Icon
!

encodingLockIcon
    <resource: #programImage>

    ^ self padLockRedMiniIcon
!

fileContents14x17Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileContents14x17Icon inspect
     ImageEditor openOnClass:self andSelector:#fileContents14x17Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class fileContents14x17Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:14;
                height:17;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@APTEAPTEAPTEAP@@@@@E@@@@AP@@@@TE@@@@@@TEAPTEAPTEAPT@@@@@APT@@@T@@@TEAP@@@@@EAPTE
APTEAPTE@@@@@@T@@@@E@@TEAPT@@@@@APTEAPTEAPTEAP@@@@@E@@T@AP@@@@TE@@@@@@TEAPTEAPTEAPT@@@@@AP@@@@T@@@@EAP@@@@@EAPTEAPTEAPTE
@@@@@@T@AP@E@@@@APT@@@@@APTEAPTEAPTEAP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 105 133 190 129 129 129 194 194 194 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:17;
                            bits:(ByteArray 
                                        fromPackedString:'@@A?>G?8_?!!?>G?8_?!!?>G?8_?!!?>G?8_?!!?>G?8_? @@@@a');
                            yourself);
                yourself
        ]
!

fileContentsIcon
    <resource: #programImage>

    ^ self fileContents14x17Icon
!

fileImageContents14x17Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileImageContents14x17Icon inspect
     ImageEditor openOnClass:self andSelector:#fileImageContents14x17Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class fileImageContents14x17Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:14;
                height:17;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@ HB@ HB@@@@@@HA0\GA0\GA0 H@@@@@@\GA0\IA0$GA0 @@@@@A0\GA0\GA0\GB@@@@@@GA0\G
A0\GA0\H@@@@@@\GA0$GA0\GA0 @@@@@A0\GA0\GA0\GB@@@@@@HA0\GA0\IA0\H@@@@@@\GA0\GA0\GA0 @@@@@B@\GA0XGA0 HB@@@@@@HB@ HA  HB@ H
@@@@@@ HB@ FB@ HB@ @@@@@BP$IBPXIBP$IBP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 105 133 190 129 129 129 194 194 194 255 0 0 255 255 255 133 60 36 0 206 0 174 218 230 0 137 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:17;
                            bits:(ByteArray 
                                        fromPackedString:'@@A?>G?8_?!!?>G?8_?!!?>G?8_?!!?>G?8_?!!?>G?8_? @@@@a');
                            yourself);
                yourself
        ]
!

fileImageContentsIcon
    <resource: #programImage>

    ^ self fileImageContents14x17Icon

    "Created: / 01-06-2010 / 17:35:40 / cg"
!

fileInIcon
    <resource: #programImage>

    ^ self fileIn20x20Icon3
!

fitImageSizeToViewIcon
    <resource: #programImage>

    ^ self fitImageSizeToView20x20Icon
!

hexToggle14x17Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self hexToggle14x17Icon inspect
     ImageEditor openOnClass:self andSelector:#hexToggle14x17Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class hexToggle14x17Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:14;
                height:17;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@APTEAPTEAPTEAP@@@@@E@@@@AP@@@@TE@@@@@@TEAP@E@@TEAPT@@@@@APT@@@T@@@TEAP@@@@@EAPT@
AP@EAPTE@@@@@@T@@@@E@@TEAPT@@@@@APTEAPTEAPTEAP@@@@@E@@@@AP@@@@TE@@@@@@T@AP@E@@T@APT@@@@@AP@@@@T@@@@EAP@@@@@E@@T@AP@E@@TE
@@@@@@T@AP@E@@@@APT@@@@@APTEAPTEAPTEAP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 105 133 190 129 129 129 194 194 194 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:17;
                            bits:(ByteArray 
                                        fromPackedString:'@@A?>G?8_?!!?>G?8_?!!?>G?8_?!!?>G?8_?!!?>G?8_? @@@@a');
                            yourself);
                yourself
        ]
!

hexToggleIcon
    <resource: #programImage>

    ^ self hexToggle14x17Icon
!

historyBackIcon
    <resource: #programImage>

    ^ self leftArrow20x20Icon
!

historyBackInGlobalListIcon
    <resource: #programImage>

    ^ self left2Arrow20x20Icon

    "Created: / 02-07-2011 / 18:41:50 / cg"
!

historyForwardIcon
    <resource: #programImage>

    ^ self rightArrow20x20Icon
!

historyIcon
    <resource: #programImage>

    ^ self history20x20Icon
!

homeIcon
    <resource: #programImage>

    ^ self home28x28Icon
!

homeIcon2
    <resource: #programImage>

    ^ self home22x22Icon2
!

makeIcon
    <resource: #programImage>

    ^ self make22x22Icon2
!

newDirectoryIcon
    <resource: #programImage>

    ^ self newDirectory20x20Icon
!

newFileIcon
    <resource: #programImage>

    ^ self fileNew20x20Icon

    "Created: / 31-03-2011 / 10:57:39 / cg"
!

pasteFileIcon
    <resource: #programImage>

    ^ self paste20x20Icon
!

printerIcon
    <resource: #programImage>

    ^ self printer22x22Icon
!

reloadIcon
    <resource: #programImage>

    ^ self reload24x24Icon
!

reloadTextFromFileIcon
    <resource: #programImage>

    ^ self reloadTextFromFile28x22Icon
!

saveAsToFile32x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self saveAsToFile32x22Icon inspect
     ImageEditor openOnClass:self andSelector:#saveAsToFile32x22Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class saveAsToFile32x22Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:32;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L3L3L3@@@@@@@@@@@@@@@CQDMDP0@@@@@EUUAP@@@@@3L3L3L@@B@AAUUPD@@@@@MDP4QC@@@"@P
UUTA@@@@@CL3L3L"H"H"DEUU@P@@@@@4QCQDL"H"H"@@@@D@@@@@L3L3L2H"H"HQDQDQ@@@@@CQDMDP0@@H DP@@@P@@@@@3L3L3L@@B@AD@UPD@@@@@MDP4
QC@@@@@Q@ETA@@@@@CL3L3L0@@@E@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 129 129 129 255 0 0 255 255 255 105 133 190 194 194 194 ];
                mask:((ImageMask new)
                            width:32;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@G?0@@A?<G? _?A?8G?1_>A?<_? _???8G???>A???? _?G?8G?1_>A?<G? _?@?8G?0@@@@@@@@@@@@@C''RX\9BT)IPL%K"S@)L $I13FG\@@@@@@@@a');
                            yourself);
                yourself
        ]
!

saveImageToFileAsIcon
    <resource: #programImage>

    ^ self saveToFileAsIcon
!

saveTextToFileIcon
    <resource: #programImage>

    ^ self saveTextToFile28x22Icon
!

searchFileIcon
    <resource: #programImage>

    ^ self search20x20Icon
!

searchIcon
    <resource: #programImage>

    ^ self search20x20Icon
!

shellTerminalIcon
    <resource: #programImage>

    OperatingSystem isMSDOSlike ifTrue:[
        ^ self dosShellTerminalIcon
    ].
    ^ self unixShellTerminalIcon
!

stxHomeIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxHomeIcon inspect
     ImageEditor openOnClass:self andSelector:#stxHomeIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class stxHomeIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bitsPerSample:(#[8]); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@@@@@@@@@@@@DQ@@@@@@@@@@@@DQDP@@@@@@@@@@DQ@QD@@@@@@@@@DQIBDQ@@@@@@@@DQICP!!DP@@@@@@DQICL4HQD@@@@@
DQICL3MBDQ@@@@DQIFX3L3P!!DP@@DQICY#L3L6HQD@D"ICM&L3M&M@@A@RH$L3Y#M&L4@@D@@@P3L6L6L3P@@@@@ACL3Y&L3M@@@@@@DL3L6L3L4@@@@@@P3
L6X3L3P@@@@@ACL6L6L3M@@@@@@DM&L3M#L4@@@@@@Q&L3L3X3P@@@@@A&YDQDQ$Q@@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 192 0 0 64 0 0 73 73 73 192 192 192 100 128 255 0 200 48]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@A@@@C @A''0@A/8@A?<@A?>@A??@C?? G??0O??8_??<_??<_??<C?? C?? C?? C?? C?? C?? C?? C?? C?? '); yourself); yourself]
!

unixShellTerminalIcon
    <resource: #programImage>

    ^ self shellWithoutText20x20Icon
!

viewDetailsIcon
    <resource: #programImage>

    ^ self viewDetails16x16Icon
!

viewNoDetailsIcon
    <resource: #programImage>

    ^ self viewNoDetails16x16Icon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-FileBrowser-Filetypes'!

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
        constantNamed:'GenericToolbarIconLibrary fileTypeAddOnLinked'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@A<@@X@@  CC@G>@@0@B@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@?@C>@O<XA10G? O?@_8@G@@X@@@@@@@@@@@b') ; yourself); yourself]
!

fileTypeAddOnLocked
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeAddOnLocked inspect
     ImageEditor openOnClass:self andSelector:#fileTypeAddOnLocked
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeAddOnLocked'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A A#@LFA LL@Y @<@A @O@A&@LLA XL@1 A @@@@@b') ; colorMapFromArray:#[0 0 0 255 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A A#@LFA LL@Y @<@A @O@A&@LLA XL@1 A @@@@@b') ; yourself); yourself]
!

fileTypeApplicationBinaryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeApplicationBinaryIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeApplicationBinaryIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeApplicationBinaryIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4AQXET@T_A?<EEPUUAQTG?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeApplicationJavaArchiveIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A @F?([>1/8F?>[?9/? ?>C?8@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?>O?<??;?????????????G?<_?0@@@@@b') ; yourself); yourself]
!

fileTypeApplicationLibraryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeApplicationLibraryIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeApplicationLibraryIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeApplicationLibraryIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4AQXET@T_A?<EEPUUAQTG?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
!

fileTypeApplicationPdfIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeApplicationPdfIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeApplicationPdfIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeApplicationPdfIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XD\@U?AE$E60TQA5,GF0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
!

fileTypeApplicationPostscriptIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeApplicationPostscriptIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeApplicationPostscriptIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeApplicationPostscriptIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XD\@U?AFLE;0W#A?,G00@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
!

fileTypeApplicationRtfIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeApplicationRtfIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeApplicationRtfIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeApplicationRtfIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XD<@W?A[$E.0TQA;,G&0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeApplicationSharedLibraryIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4AQXET@T_A?<EEPUUAQTG?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:' @@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeAudioIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A7XG\@]/AF<D;0^OA9<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeBinaryFileIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4AQXET@T_A?<EEPUUAQTG?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeCPlusPlusSourceIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@Y?A],E PW[A''<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeCSourceIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@Y?A_<E?0W?A''<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
!

fileTypeCompressedArchiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeCompressedArchiveIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeCompressedArchiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeCompressedArchiveIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@J @@@B(@@@B* @@@J @@@@ @@UUQ@@E@@@@AQUUD@TUUQPEEUT@@AUUUP@@H@@@@J @@@J*@@@@*@@@@J @@@a') ; colorMapFromArray:#[0 0 0 255 255 255 0 0 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@\@A0@O @\C?0O? ??#??O?>?????1??@\@C8@G@@\@b') ; yourself); yourself]
!

fileTypeDeviceFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self deviceFile inspect
     ImageEditor openOnClass:self andSelector:#deviceFile
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeDeviceFileIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_?!!?>D2(UZ!!T*EV(SM!!?>G?8@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?<??3??O?<??3??O?<??3??O?<??0@@@@@@@@b') ; yourself); yourself]
!

fileTypeDigitalNotepadIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDigitalNotepadIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDigitalNotepadIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeDigitalNotepadIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4AAXE4@W\A] DDP_3AA\G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@??G?>;??O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeDirectoryGrayIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@<@@@@UU@**EUPJ*!!UTB*(@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@O@A>@O?<??3??O?<??3??O?<??0@@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeDirectoryIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@<@@@@_?!!?>G?8_?!!?>G?8@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@O@A>@O?<??3??O?<??3??O?<??0@@@@@@@@b') ; yourself); yourself]
!

fileTypeDirectoryLinkIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryLinkIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryLinkIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeDirectoryLinkIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@J(@@@B* @@DB(UPAUJ B@UR**(EUJ**AUT@B@UUUU@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 0 255 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@O @?@O?<??3??/???????/?<??0@@@@@@@@b') ; yourself); yourself]
!

fileTypeDirectoryLockedIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryLockedIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryLockedIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeDirectoryLockedIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@B @@B J@@B @)PB @B B @EZV%PAU*%T@UV%U@EV*UPAV%)T@V%V%@B @J@B @@(B @@B @@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 0 255 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@L@L_A!!>LO?<??3??O?<??3??O?<??1 FL@L@@@b') ; yourself); yourself]
!

fileTypeDirectoryNetworkIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeDirectoryNetworkIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeDirectoryNetworkIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeDirectoryNetworkIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@UP@@@@@@@@EUUUPAUUUT@UUUU@EUUUPAUJET@UR!!U@@@(@@@@J@@@@B @B*****@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 0 255 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@A8@O0A??''?>_?9??''?>_?9??''?>@<C???????<b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeDirectoryOpenGrayIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@"@@@@"H@@@BH"H B@@@@@ QDQ@@QDQD@QDQD@QDQD@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 0 178 178 178]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@O@A>@O?<??3???????;??/?<??0@@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeDirectoryOpenIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@* @@@**@@@J*** B@@@@@!!UUUPAUUUT@UUUT@UUUU@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 0 179 179 179]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@O@A>@O?<??3???????;??/?<??0@@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeExecutableFileIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@J**(@B***@@@@@@@EUUT@AUUU@@UUUP@EUUT@AUUU@@UUUP@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 255 174 218 230]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@@@@b') ; yourself); yourself]
!

fileTypeExpeccoLogfileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeExpeccoLogfileIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeExpeccoLogfileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeExpeccoLogfileIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
F#@0LC@0LC@0LC@-F!!(ZF!!(0N3,;N3,;N3,;NR4ZF!!(ZLC,;K2</K2</K2<9KQ(ZF#@;JR0;N3,;N3,;N3\@F!!(0N2P&KC,/K2</K3(7@A(ZLC,1GRL,N3,;
N#T(H@@ZF#@;M!!$VH"08L2(RE00@F!!(0N3X''C!!D_IQTIC00,@A(ZLC,;K!!@KA0(KBA ,M0@ZF#@;K3PTA XFAAL,N3\@F!!(0N3,6G@TECQ,,N3,7@A(ZLC,/
N2,C@"D,N2<;M0@ZF#@;N3,2@Q8,N3,;N3\@F!!(0N2</N20,N2</K3,7@A(ZLC,;N3,;N3,;N3,;M0@ZF"4-KR4-KR4-KR4-KR4@F @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 0 129 0 0 174 0 0 182 0 0 206 0 0 209 0 0 222 0 0 223 0 0 225 0 0 226 0 0 228 0 0 234 0 1 191 1 1 194 1 1 235 1 1 242 1 2 209 2 2 216 2 5 199 5 6 156 6 14 179 14 14 195 14 17 226 17 18 232 18 19 167 19 26 194 26 27 202 27 28 148 28 32 147 32 35 191 35 39 137 39 45 167 45 45 202 45 47 141 47 49 178 49 50 181 50 54 175 54 55 163 55 55 177 55 56 184 56 60 183 60 71 185 71 71 187 71 75 147 75 84 146 84 85 85 85 110 178 110 112 204 224 134 134 134 136 206 136 141 185 141 155 207 155 157 198 157 161 216 161 187 223 187 204 204 204 229 242 229 231 231 214 241 250 241 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?A?>G?<_?9??''?>_?9??''?>_?9??''?>_?9??''?>_?8b') ; yourself); yourself]
!

fileTypeExpeccoSuiteIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeExpeccoSuiteIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeExpeccoSuiteIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeExpeccoSuiteIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@B8.K"8.K"8.K"8,@@@@@@@.NS$9NS$9NS$9M20@@@@@K#$9NS$9NS$9NS$7K@@@@B89JB,9NS$9NS$9NST@@@@.NRL%J3$9NS$9NS 5@@@@K#$/GBH+NS$9
NCL''G0@@@B89MA$VHR,6LR$RE00@@@@.NSP&C!!D^IATIC00+@@@@K#$9KQ@KA0(KBA +MP@@@B89NSHTA XFAAL+NST@@@@.NS$4F0TECQ(+NS$5@@@@K#$9
NR(C@"@+NS$9MP@@@B89NS$0@Q4+NS$9NST@@@@.NS$9NR,+NS$9NS$5@@@@K#$9NS$9NS$9NS$9MP@@@B0,KB0,KB0,KB0,KB0@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 0 129 0 0 174 0 0 182 0 0 206 0 0 209 0 0 222 0 0 223 0 0 225 0 0 226 0 0 228 0 0 234 0 1 191 1 1 194 1 1 235 1 1 242 1 2 209 2 2 216 2 5 199 5 6 156 6 14 179 14 14 195 14 17 226 17 18 232 18 19 167 19 26 194 26 28 148 28 32 147 32 35 191 35 39 137 39 45 167 45 45 202 45 47 141 47 49 178 49 50 181 50 54 175 54 55 163 55 55 177 55 56 184 56 60 183 60 71 185 71 71 187 71 75 147 75 84 146 84 85 85 85 110 178 110 134 134 134 136 206 136 141 185 141 155 207 155 157 198 157 161 216 161 187 223 187 204 204 204 229 242 229 231 231 214 241 250 241 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?A?>G?<_?9??''?>_?9??''?>_?9??''?>_?9??''?>_?8b') ; yourself); yourself]
!

fileTypeFileArchiveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeFileArchiveIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeFileArchiveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeFileArchiveIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A @F?([>1/8F?>[?9/? ?>C?8@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?>O?<??;?????????????G?<_?0@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeFileIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@_?A?<G?0_?A?<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeFileLinkIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@*H@AUR" @UUH@@@ER(@@(U@D@JEUUPB(UUT@* @D@J** @@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@G? _?C?>O?<_?1??G?>_?9??G?<_?0@@@@@@@@b') ; yourself); yourself]
!

fileTypeFileLockedIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeFileLockedIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeFileLockedIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeFileLockedIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@B @@B JUTR A)UF @V%R @EZV%@AU*%P@UV%T@EV*U@AV%)P@V%V$@B @J@B @@(B @@B @@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?L??#?<O?8??#?>O?8??#?>O?8??!! FL@L@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeHeaderFileIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@V?A[<DO0V?A[<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
!

fileTypeHomeDirectoryIcon
    <resource: #programImage>

    ^ self fileTypeDirectoryIcon
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
        constantNamed:'GenericToolbarIconLibrary fileTypeImageFileIcon'
        ifAbsentPut:[(Depth4Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DQDQDQDQ@@@QDQADQQD@@ADQADQDTP@@DQDPQDTQ@@@QDQDIDQD@@ADQDP$QDP@@CMCL2L4Q@@@L3
L3L3L3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 0 205 0 133 62 38 0 139 0 173 216 230]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@??3??O?<??3??O?<??3??O?<??0@@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeJavaScriptSourceIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@Q''A5<G[0U7A$<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeJavaSourceIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@Q?A7<G_0U?A''<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeLispSourceIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@[?A7<G_0Z?A-<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeSmalltalkSourceIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4A?XG<@XOA]<F70]_AM<G?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
!

fileTypeSpecialFileIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeSpecialFileIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeSpecialFileIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeSpecialFileIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G?@<^C18OG <^C18O? <^C18G?@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?8_?1??G?<_?1??G?<_?1??G?<_?0?>@@@@@@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeTextHtmlIcon'
        ifAbsentPut:[(Depth4Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@H"H"HB@@@@@"H"H H @@@BH"H"@@@@@@H#L3LBH @@@%TVL6X"@@@FY!!X1E H@@@Y&T3DV@@@@L1DSM!!M @@@CDVL6XS@@@@LQ
L1Y!!L@@@@3D3DVD0@@@@L3L3E@@@@@@@L3L@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 160 160 0 255 255 255 10 110 230 0 128 128 128 128 128 128 128 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@C?0O? ??C?>O?8??#?>O?(??#?>O?8_?A?8C?@C0@b') ; yourself); yourself]
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
        constantNamed:'GenericToolbarIconLibrary fileTypeTextIcon'
        ifAbsentPut:[(Depth1Image new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_4AAXG<@P_A?<D@P_?A@DG?0@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@O?@?>C?<O?8??#?>O?8??#?>O?8?? @@@@@@@@b') ; yourself); yourself]
!

fileTypeVideoIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileTypeVideoIcon inspect
     ImageEditor openOnClass:self andSelector:#fileTypeVideoIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary fileTypeVideoIcon'
        ifAbsentPut:[(Depth2Image new) width:16; height:16; bits:(ByteArray fromPackedString:'B***(@X@@Y@JJ*& A"*)$@(**Z@FJ*&PB%UU(@Z**)@J@@F A"*)$@(**Z@FJ*&PB"*)(@YUUY@J*** @@@@@@@a') ; colorMapFromArray:#[0 0 0 255 255 255 125 125 125]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?9??''?>_?9??''?>_?9??''?>_?9??''?>_?9??''?>@@@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-ImageEditor'!

loadImageFromMethodIcon
    <resource: #programImage>

    ^ self loadFromMethodIcon
!

newImageIcon
    <resource: #programImage>

    ^ self newImage24x24Icon
!

saveImageAsMethodAsIcon
    <resource: #programImage>

    ^ self saveAsMethodAsIcon
!

saveImageAsMethodIcon
    <resource: #programImage>

    ^ self saveAsMethodIcon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-Launcher'!

displayScreenIcon
    <resource: #programImage>

    ^ self displayScreen22x22Icon
!

editorIcon
    <resource: #programImage>

    ^ self editor22x22Icon
!

fontIcon
    <resource: #programImage>

    ^ self font22x22Icon
!

garbageCollectIcon
    <resource: #programImage>

    ^ self garbageCollect24x24Icon
    "/ ^ self garbageCollect28x28Icon
!

helpIcon1
    <resource: #programImage>

    ^ self help28x28Icon1
!

helpIcon2
    <resource: #programImage>

    ^ self help28x28Icon2
!

helpIcon3
    <resource: #programImage>

    ^ self help28x28Icon3
!

imageEditorIcon
    <resource:#programImage>
    ^ self imageEditor24x24Icon

    "Created: / 31-03-2011 / 11:07:30 / cg"
!

keyboardMappingIcon
    <resource: #programImage>

    ^ self keyboardMapping22x22Icon
!

languagesIcon
    <resource: #programImage>

    "/ ^ self languages20x12Icon
    ^ self languages22x22Icon
!

memoryIcon
    <resource: #programImage>

    ^ self memory22x22Icon
!

projectBuilderIcon
    <resource: #programImage>

"/    ^ self packageOpen24x24Icon
    ^ self packageIn24x24Icon

    "Modified: / 01-02-2012 / 15:09:43 / cg"
!

saveImageIcon
    <resource: #programImage>

    ^ self saveImage24x24Icon
    "/ ^ self saveImage28x28Icon
!

startChangesBrowserIcon
    <resource: #programImage>

    ^ self changesBrowser24x24Icon
    "/ ^ self changesBrowser28x28Icon
!

startFileBrowserIcon
    <resource: #programImage>

    ^ self fileBrowser24x24Icon
    "/ ^ self fileBrowser28x28Icon
!

startImageEditorIcon
    <resource: #programImage>

    ^ self imageEditor24x24Icon
    "/ ^ self imageEditor28x28Icon
!

startMenuEditorIcon
    <resource: #programImage>

    ^ self menuEditor24x24Icon
    "/ ^ self menuEditor28x28Icon
!

startNewFileBrowserIcon
    <resource: #programImage>

    ^ self newFileBrowser24x24Icon
!

startNewSystemBrowserIcon
    <resource: #programImage>

    ^ self newSystemBrowser24x24Icon
!

startSystemBrowserIcon
    <resource: #programImage>

    ^ self systemBrowser24x24Icon
"/    ^ SystemBrowser defaultIcon
!

startSystemBrowserOnHistoryClassIcon
    <resource: #programImage>

    ^ self systemBrowserClassHistory28x28Icon
!

startUIPainterIcon
    <resource: #programImage>

    ^ self uiPainter24x24Icon
    "/ ^ self uiPainter28x28Icon
!

startWorkspaceIcon
    <resource: #programImage>

    ^ self workspace24x24Icon
    "/ ^ self workspace28x28Icon
!

stxHelpIcon
    <resource: #programImage>

    ^ self helpIcon2
!

stxSettings24x24Icon
    <resource: #programImage>

    ^ self stxSettings24x24Icon1
!

stxSettings24x24Icon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stxSettings24x24Icon1 inspect
     ImageEditor openOnClass:self andSelector:#stxSettings24x24Icon1
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class stxSettings24x24Icon1'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GA0@@@@@@@@@@@@@GA0@@@@@@@@@@@EAWA0BH"H"H"H"H@EAP@@BH"I*H"H"H@EAP@@BH"I&H"H
"X@EAP@@BH"I&H"H&H@EAP@@BH"H&("I"H@EAP@@BH"H"X"X"H@EAP@@BH"H"Z&H"H@EAP@@BH"H"I"H"H@E@C]0BH"H"Y"H"H@E@@@@BH"H&H&H"H@EAP\@
BH")"H"("H@EAP\@BH*X"H"("H@EAP\@BI&H"H"I"H@E@CM0BH"H"H"H"H@E@C]0@@@@@@@@@@@E@C]0@@@@@@@@@@@@@C]0@@@@@@@@@@@@@CM0@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 255 0 0 127 127 127 127 127 255 0 0 100 100 100 25 25 25 0 204 51 0 168 39 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@N@@@N_?<N_?<D_?<D_?<D_?<D_?<D_?<D_?<N_?<__?<__?<N_?<N_?<N_?<__?<__?<_@@@_@@@_@@@N@@@@');
                            yourself);
                yourself
        ]
!

stxSettings24x24Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stxSettings24x24Icon2 inspect
     ImageEditor openOnClass:self andSelector:#stxSettings24x24Icon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class stxSettings24x24Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EAP@@@@@@@@@@@@@EAPB;.;.;.;.;,FA%APB;.;.;.;.;,FA @@B;.1F;.;.;,FA @@B;.1F;.;
,[,FA @@B;.1F;.;F;,FA @@B;.;D[.1.;,FA @@B;.;,[,[.;,FA @@B;.;,QF;.;,FA @@B;.;.1.;.;,F@IUPB;.;,Q.;.;,F@@@@B;.;F;F;.;,FA T@
B;,Q.;,[.;,FA T@B;D[.;,[.;,FA T@B1F;.;.1.;,F@I%PB;.;.;.;.;,F@IUPB;.;.;.;.;,F@IUP@@@@@@@@@@@@@IUP@@@@@@@@@@@@@I%P@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 0 127 127 0 168 39 0 204 51 25 25 25 100 100 100 127 127 127 170 170 170 255 0 0 255 255 0 255 255 255 184 231 231 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@@@N@@@N_?<N_?<D_?<D_?<D_?<D_?<D_?<D_?<N_?<__?<__?<N_?<N_?<N_?<__?<__?<_@@@_@@@_@@@N@@@@');
                            yourself);
                yourself
        ]
!

systemBrowserIcon
    <resource: #programImage>

    ^ self systemBrowser24x24Icon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-MenuEditor'!

copyMenuItemIcon
    <resource: #programImage>

    ^ self copyMenuItem22x22Icon
!

cutMenuItemIcon
    <resource: #programImage>

    ^ self cutMenuItem22x22Icon
!

newMenuIcon
    <resource: #programImage>

    ^ self newMenu24x24Icon
!

pasteMenuItemIcon
    <resource: #programImage>

    ^ self pasteMenuItem22x22Icon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-SystemBrowser'!

addBreakPointIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addBreakPointIcon2 inspect
     ImageEditor openOnClass:self andSelector:#addBreakPointIcon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class addBreakPointIcon2'
        ifAbsentPut:[
            (Depth2Image new)
                width:12;
                height:21;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'****/??>/:+>/%V>.TA..P@..P@..@@./ B>/:+>/??>/:+>/**>.)V..%U..%U..UU./%V>/:+>/??>****');
                colorMapFromArray:#[ 255 0 0 63 63 63 0 0 0 127 127 127 ];
                mask:((ImageMask new)
                            width:12;
                            height:21;
                            bits:(ByteArray 
                                        fromPackedString:'??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0');
                            yourself);
                yourself
        ]
!

addBuffer13x11Icon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self addBuffer13x11Icon1 inspect
     ImageEditor openOnClass:self andSelector:#addBuffer13x11Icon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary addBuffer13x11Icon1'
        ifAbsentPut:[(Depth4Image width:13 height:11) bits:(ByteArray fromPackedString:'@@@@@@@@@@;.;.;.; @N???/??8@C.;.;.;.@@Y&Y&Y&XP@FY&Y&Y&D@A&Y&Y&Y!!@@Y&Y&Y&XP@FY&Y&Y&D@@QDQDQDQ@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; yourself]
!

addBuffer16x16Icon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addBuffer16x16Icon2 inspect
     ImageEditor openOnClass:self andSelector:#addBuffer16x16Icon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class addBuffer16x16Icon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@ADQDPDQDQ@@D3L>@SL38@@SL38AL3O @@@@@@@@@@@@L3L3L3L3L@@3L3L3L3L0@CL3L6L3X3A L3L3M#M#M @3L3L3X6M @@@@@@@FY @@@@
@@Y&Y&Y&@@@@@@Y&Y&@@@@@@A Y&@@@@@@A Y&A @@@@A @F@@Xb');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 192 192 192 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'??;??/?>??;??/?>??;????>??;?? G?@C @U@BR@QDb');
                            yourself);
                yourself
        ]
!

breakpointBlueDisabled
    <resource: #programImage>

    ^ self breakpointBlueDisabled9x9
!

breakpointBlueEnabled
    <resource: #programImage>

    ^ self breakpointBlueEnabled9x9
!

breakpointDisabled
    <resource: #programImage>
    ^ self breakpointDisabled9x9
!

breakpointDisabledWithWarning
    <resource: #programImage>
    ^ self breakpointDisabledWithWarning9x9

    "Created: / 16-02-2015 / 06:20:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

breakpointRedDisabled
    <resource: #programImage>
    ^ self breakpointDisabled
!

breakpointRedDisabledWithWarning
    <resource: #programImage>

    ^ self breakpointDisabledWithWarning
!

breakpointRedEnabled
    <resource: #programImage>

    ^ self breakpointRedEnabled9x9

    "Modified: / 16-02-2015 / 06:29:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

breakpointRedEnabledWithWarning
    <resource: #programImage>

    ^ self breakpointRedEnabledWithWarning9x9

    "Created: / 16-02-2015 / 06:29:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatCodeAndAcceptIcon
    <resource: #programImage>

    ^ self formatCodeAndAccept16x16Icon
!

formatCodeIcon
    <resource: #programImage>

    ^ self formatCode16x16Icon
!

padLockBlackMiniIcon
    <resource: #programImage>

    ^ self padLockBlack12x12Icon
!

padLockBlueMiniIcon
    <resource: #programImage>

    ^ self padLockBlue12x12Icon
!

padLockGrayMiniIcon
    <resource: #programImage>

    ^ self padLockGray12x12Icon
!

padLockGreenMiniIcon
    <resource: #programImage>

    ^ self padLockGreen12x12Icon
!

padLockRedMiniIcon
    <resource: #programImage>

    ^ self padLockRed12x12Icon
!

removeBreakPointBlueIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self removeBreakPointBlueIcon2 inspect
     ImageEditor openOnClass:self andSelector:#removeBreakPointBlueIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary removeBreakPointBlueIcon2'
        ifAbsentPut:[(Depth2Image new) width:12; height:21; bits:(ByteArray fromPackedString:'****/??>/:+>/**>.)V..%U..%U..UU./%V>/:+>/??>/:+>/%V>.PA..@@..@@..@@./ B>/:+>/??>****') ; colorMapFromArray:#[158 158 255 63 63 63 0 0 0 127 127 127]; mask:((ImageMask new) width:12; height:21; bits:(ByteArray fromPackedString:'??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0') ; yourself); yourself]
!

removeBreakPointIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self removeBreakPointIcon2 inspect
     ImageEditor openOnClass:self andSelector:#removeBreakPointIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary removeBreakPointIcon2'
        ifAbsentPut:[(Depth2Image new) width:12; height:21; bits:(ByteArray fromPackedString:'****/??>/:+>/**>.)V..%U..%U..UU./%V>/:+>/??>/:+>/%V>.PA..@@..@@..@@./ B>/:+>/??>****') ; colorMapFromArray:#[0 255 0 63 63 63 0 0 0 127 127 127]; mask:((ImageMask new) width:12; height:21; bits:(ByteArray fromPackedString:'??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0??C?<O?0') ; yourself); yourself]
!

tracepointBlue
    <resource: #programImage>

    ^ self tracepointBlue9x9
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-SystemBrowser-classIcons'!

abstractClassIcon
    <resource: #programImage>

    ^ self abstractClassIcon2
!

abstractClassIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self abstractClassIcon1 inspect
     ImageEditor openOnClass:self andSelector:#abstractClassIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary abstractClassIcon1'
        ifAbsentPut:[(Depth4Image width:13 height:11) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@EBIA@@@@@BH"H @@@AH"H"H!!@@ABH#L"I@@@H"L@L"H@@BH#@CH"@@ABH#L"I@@@D"H"H"D@@@@"H"H@@@@@EBIA@@@b') colorMapFromArray:#[214 177 82 229 207 148 204 159 42 226 201 136 207 165 55] mask:((ImageMask width:13 height:11) bits:(ByteArray fromPackedString:'@@@O0A? O?@?<C30OO@?<C?0G>@O0@@a'); yourself); yourself]
!

abstractClassIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self abstractClassIcon2 inspect
     ImageEditor openOnClass:self andSelector:#abstractClassIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class abstractClassIcon2'
        ifAbsentPut:[(Depth2Image width:13 height:11) bits:(ByteArray fromPackedString:'@@ @H@@Y@@@@I @ @B8@@@A]P@@@''X@@@V*P@@I3X@@B0N@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 163 163 255 127 127 255 255 255 255]
            mask:((ImageMask width:13 height:11) bits:(ByteArray fromPackedString:'@ @G@@\@A0@O @>@G<@]0A#@@@@@@@@a'); yourself); yourself]
!

abstractContainerClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self abstractContainerClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#abstractContainerClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class abstractContainerClassBrowserIcon'
        ifAbsentPut:[(Depth4Image width:13 height:11) bits:(ByteArray fromPackedString:'@QD@L@DQ@@D@C3<@@P@A@@O3@@D@@P@CH0@A@@D@?2?0@P@A@C</L@D@@P<3L3<A@@DC< K3@P@A@2@@H0D@@P@@@@@A@@DQ@@@ADP@b')
            colorMapFromArray:#[0 0 0 0 127 127 255 255 255 127 127 255 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 127 127 0 127 0 127 127 127 127 170 170 170 163 163 255]
            mask:((ImageMask width:13 height:11) bits:(ByteArray fromPackedString:'\''AGDD\PQ1AO$D>PW=A]4E#PPAA0\@@a'); yourself); yourself]
!

abstractWindowClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self abstractWindowClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#abstractWindowClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class abstractWindowClassBrowserIcon'
        ifAbsentPut:[(Depth4Image width:13 height:11) bits:(ByteArray fromPackedString:'H"H1PSH"HBL3MDP3LR@#L3PTL3D H3L4ECL1HBL3QAQCLR0#L4QDP3D H3QCL4P1HBL4L3L4LR@#L3L3L3D HQDQDQDQH"H"H"H"H",b')
            colorMapFromArray:#[0 0 0 255 255 255 127 127 127 220 220 220 127 127 255]; yourself]
!

announcementClassIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self announcementClassIcon inspect
     ImageEditor openOnClass:self andSelector:#announcementClassIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary announcementClassIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:12;
                height:12;
                bits:(ByteArray 
                            fromPackedString:'
@A@C@PDA@PDA@P4@C1P9N3,;N3,;N1XI@#(8M#H/KB$$IS,KA#,4LR8+JBP!!G3,NA#,0KR,''H2D^GC,N@#(6J"X"HA4ZF3,LC1P:N3,;KQ$6N1XI@A@B@PDR
N3,7D (@@@@@@@@HL1HDEP@@@@@@@ALQAQ\@@@@@@@@@MP\X@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 88 135 184 90 136 185 92 138 186 93 139 186 95 140 187 108 149 192 110 151 193 111 151 194 112 152 194 117 156 196 123 160 199 125 162 200 133 167 203 137 170 205 139 172 206 147 177 209 153 182 212 157 184 213 163 189 216 169 193 218 173 196 220 180 201 223 181 202 224 190 208 227 208 227 253 208 228 253 209 228 252 209 228 253 211 230 253 212 230 253 213 230 253 214 231 253 215 232 253 217 233 253 218 233 253 219 234 253 220 234 253 220 235 253 221 235 254 221 236 254 222 236 254 223 236 254 224 237 254 225 238 254 226 238 254 227 239 254 228 239 254 229 240 254 230 240 254 230 241 254 231 238 245 232 241 254 233 239 246 233 242 254 239 243 248 240 246 254 251 252 253 253 254 254 255 255 255 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'_>????????????????=?;0_OC0<\C0@O');
                            yourself);
                yourself
        ]
!

applicationDefinitionClassIcon
    <resource: #programImage>

    ^ self smallGrayPackageIcon
!

autoloadedClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self autoloadedClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#autoloadedClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary autoloadedClassBrowserIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                bits:(ByteArray 
                            fromPackedString:'UUUUXEUUUTAY?=% V_?YPE''?6TAZUU%@V**)PE)UVTAZU=%@U%_YPEUUUT@b');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'_?A?<G?0_?A?<G?0_?A?<G?0_?@?<@@a');
                            yourself);
                yourself
        ]
!

containerClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self containerClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#containerClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary containerClassBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                bits:(ByteArray 
                            fromPackedString:'@QDP@ADQ@@DQD@@QDP@AD@@@@AD@@Q@@@@@Q@@DP@@@@DP@AD@@@@AD@@Q@@@@@Q@@DP@@@@DP@AD@@@@AD@@QDP@ADQ@@DQD@@QDP@b');
                colorMapFromArray:#[ 0 0 0 0 127 127 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'^OA8<F@0XCA LF@0XCA LF@0^OA8<@@a');
                            yourself);
                yourself
        ]
!

dart13x11Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self dart13x11Icon inspect
     ImageEditor openOnClass:self andSelector:#dart13x11Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary dart13x11Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@H @@@@@@@BH @@@@@@H2H@@@@HH!!H2@@@@@BH!!H0@@@@@BH!!H @@@@@@@BH @@@@@@@BI@@@@@@@@DQ@@@@@@@@DP@AP@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 57 93 0 115 187 127 185 221 238 191 43 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'F@@\@C0@?@C<@G8@A0@C @G@@L@@H@@a');
                            yourself);
                yourself
        ]
!

dartClassBrowserIcon
    <resource: #programImage>

    ^ self dart12x12Icon
"/    ^ self dart13x11Icon
!

enumTypeBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self enumTypeBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#enumTypeBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class enumTypeBrowserIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'(@@@NJ@@@C" @@@@(@@@@J(@J BB@B@@  @ NJ@@@@B @@@@(@@@@J@@@@@b');
                colorMapFromArray:#[ 0 0 0 127 127 127 255 0 0 255 255 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@F60[[@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

errorClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self errorClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#errorClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class errorClassBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@BH@@@@@@@@"@@@@@@@BH"@@@@@@@"H @@@@@@H"H@@@@@@BH"@@@@@@@"H @@@@@@@"@@@@@@@@@@@@@@@@@BH@@@@@@@@"@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'A @F@@<@C0@O@@<@C0@F@@@@A @F@@@a');
                            yourself);
                yourself
        ]
!

exceptionClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self exceptionClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#exceptionClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class exceptionClassBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@BH@@@@@@@@"@@@@@@@BH"@@@@@@@"H @@@@@@H"H@@@@@@BH"@@@@@@@"H @@@@@@@"@@@@@@@@@@@@@@@@@BH@@@@@@@@"@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 110 110 110 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'A @F@@<@C0@O@@<@C0@F@@@@A @F@@@a');
                            yourself);
                yourself
        ]
!

guiApplicationDefinitionClassIcon
    <resource: #programImage>

    ^ self smallGreenPackageIcon
!

javascriptClassBrowserIcon
    <resource: #programImage>

    ^ self javascript12x12Icon
!

libraryDefinitionClassIcon
    <resource: #programImage>

    ^ self smallYellowPackageIcon
!

nameSpaceBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self nameSpaceBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#nameSpaceBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'GenericToolbarIconLibrary class nameSpaceBrowserIcon'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@AO8C?DS:"?1D:(/<QN*J?DS*"/1D:(+<QN*J/DR*"+1AJ(*!!@DJJA@@T@E@@@UT@@@a') ; colorMapFromArray:#[0 0 0 190 190 0 194 194 194 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G#1??7??_?=??7??_?=??7??O?8_?@?8@>@b') ; yourself); yourself]
!

notificationClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self notificationClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#notificationClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class notificationClassBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@BH@@@@@@@@"@@@@@@@BH"@@@@@@@"H @@@@@@H"H@@@@@@BH"@@@@@@@"H @@@@@@@"@@@@@@@@@@@@@@@@@BH@@@@@@@@"@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 127 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'A @F@@<@C0@O@@<@C0@F@@@@A @F@@@a');
                            yourself);
                yourself
        ]
!

queryClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self queryClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#queryClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class queryClassBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@BH@@@@@@@@"@@@@@@@BH"@@@@@@@"H @@@@@@H"H@@@@@@BH"@@@@@@@"H @@@@@@@"@@@@@@@@@@@@@@@@@BH@@@@@@@@"@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 61 173 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'A @F@@<@C0@O@@<@C0@F@@@@A @F@@@a');
                            yourself);
                yourself
        ]
!

sharedPoolBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self sharedPoolBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#sharedPoolBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class sharedPoolBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@H"H"H"H @BH"H"H"H@@"H"H"H"@@H"H"H"H @BH"H"H"H@@"H"H"H"@@H"H"H"H @BH"H"H"H@@"H"H"H"@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 127 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@A?<G?0_?A?<G?0_?A?<G?0_?@@@@@a');
                            yourself);
                yourself
        ]
!

smallGrayPackageIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self smallGrayPackageIcon inspect
     ImageEditor openOnClass:self andSelector:#smallGrayPackageIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class smallGrayPackageIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@ADP@@DQ@@DPDP@Q@P@AD@DQD@D@@ADQDQDQ@@@@HRH D@@@@@D@@ @@@@H!!H H@@@@BHRHB@@@@@"D"@ @@@@H!!H @@@@@@@P@@@@@b');
                colorMapFromArray:#[ 0 0 0 132 0 132 153 153 153 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'NGA,4F^PO?@_8C? O>@?8C? O<@? @@a');
                            yourself);
                yourself
        ]
!

smallGreenPackageIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self smallGreenPackageIcon inspect
     ImageEditor openOnClass:self andSelector:#smallGreenPackageIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class smallGreenPackageIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@BH @@H"@@H H @"@ @BH@H"H@H@@BH"H"H"@@@@D!!DPH@@@@@H@@P@@@@DRDPD@@@@AD!!DA@@@@@QHQ@P@@@@DRDP@@@@@@@ @@@@@b');
                colorMapFromArray:#[ 0 0 0 0 255 0 132 0 132 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'NGA,4F^PO?@_8C? O>@?8C? O<@? @@a');
                            yourself);
                yourself
        ]
!

smallOrangePackageIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self smallOrangePackageIcon inspect
     ImageEditor openOnClass:self andSelector:#smallOrangePackageIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class smallOrangePackageIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@ADP@@DQ@@DPDP@Q@P@AD@DQD@D@@ADQDQDQ@@@@HRH D@@@@@D@@ @@@@H!!H H@@@@BHRHB@@@@@"D"@ @@@@H!!H @@@@@@@P@@@@@b');
                colorMapFromArray:#[ 0 0 0 132 0 132 255 139 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'NGA,4F^PO?@_8C? O>@?8C? O<@? @@a');
                            yourself);
                yourself
        ]
!

smallYellowPackageIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self smallYellowPackageIcon inspect
     ImageEditor openOnClass:self andSelector:#smallYellowPackageIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'GenericToolbarIconLibrary class smallYellowPackageIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@ADP@@DQ@@DPDP@Q@P@AD@DQD@D@@ADQDQDQ@@@@HRH D@@@@@D@@ @@@@H!!H H@@@@BHRHB@@@@@"D"@ @@@@H!!H @@@@@@@P@@@@@b');
                colorMapFromArray:#[ 0 0 0 132 0 132 255 255 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'NGA,4F^PO?@_8C? O>@?8C? O<@? @@a');
                            yourself);
                yourself
        ]
!

standaloneStartupHeadlessIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self standaloneStartupHeadlessIcon inspect
     ImageEditor openOnClass:self andSelector:#standaloneStartupHeadlessIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary standaloneStartupHeadlessIcon'
        ifAbsentPut:[(Depth8Image width:13 height:11) bits:(ByteArray fromPackedString:'
@@@A@ @@@@@@@@@@@@@@@0PEA @@@@@@@@@@@@LGB@$J@@@@@@@@@@@AB00MC <P@@@@@@@@@1DRD1PUE!!\X@@@@@@LYF!!([D10]G @@@@@CG2@!!DRHDE0@@
@@@@@2LTIBT&G @@@@@@@@L''J@P\JP@@@@@@@@@CJ",X@@@@@@@@@@@@@0H@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 74 74 74 212 212 212 88 88 88 83 83 83 152 152 152 228 228 228 209 209 209 132 132 132 78 78 78 172 172 172 190 190 190 191 191 191 181 181 181 106 106 106 111 111 111 194 194 194 167 167 167 162 162 162 162 162 162 179 179 179 163 163 163 95 95 95 124 124 124 202 202 202 150 150 150 150 150 150 149 149 149 152 152 152 81 81 81 185 185 185 172 172 172 182 182 182 178 178 178 143 143 143 187 187 187 170 170 170 105 105 105 96 96 96 175 175 175 137 137 137 228 228 228 99 99 99 150 150 150] mask:((ImageMask width:13 height:11) bits:(ByteArray fromPackedString:'L@@<@C8@O8@?8C? O<@? C<@O@@0@@@a'); yourself); yourself]
!

standaloneStartupIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self standaloneStartupIcon inspect
     ImageEditor openOnClass:self andSelector:#standaloneStartupIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary standaloneStartupIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@A@ @@@@@@@@@@@@@@@0PEA @@@@@@@@@@@@LGB@$J@@@@@@@@@@@AB00MC <P@@@@@@@@@1DRD1PUE!!\X@@@@@@LYF!!([D10]G @@@@@CG2@!!DRHDE0@@
@@@@@2LTIBT&G @@@@@@@@L''J@P)J @@@@@@@@@CJ20X@@@@@@@@@@@@@0H@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 32 104 24 208 216 208 47 120 24 47 112 24 128 168 128 224 232 224 191 224 176 95 160 80 47 104 24 159 184 144 159 216 136 160 216 136 144 208 136 64 136 56 79 136 64 191 200 176 127 200 96 111 200 88 112 200 88 143 208 120 127 192 104 63 120 48 96 144 88 207 200 200 96 192 64 95 192 64 95 192 56 111 184 88 48 104 48 176 192 176 112 216 88 127 224 96 128 216 104 96 176 88 143 224 104 128 200 120 64 136 48 64 120 56 128 208 120 95 168 80 143 160 136 239 224 224 47 136 40 127 168 120 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'L@@<@C8@O8@?8C? O<@? C<@O@@0@@@a');
                            yourself);
                yourself
        ]
!

startableClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self startableClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#startableClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class startableClassBrowserIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'**J*NJ*"*#"*!!J(@*!!T*@J(DJ B*DR(@*!!T*NJ(*J B*O2(@*+.*@J*** @b');
                colorMapFromArray:#[ 0 0 0 127 127 127 255 0 0 255 255 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@ @B@@\@C8@O @>@C8@H @>@A0@G@@@a');
                            yourself);
                yourself
        ]
!

testCaseClassIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self testCaseClassIcon inspect
     ImageEditor openOnClass:self andSelector:#testCaseClassIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class testCaseClassIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@H @@@@@@@"D@@@@@@@HP@@@@@ @"D@@@@@H HP@@@@@AH"D@@@@@@AHP@@@@@@@A@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 56 142 51 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@C@@\@A AN@F0@_@@8@A@@@@@@a');
                            yourself);
                yourself
        ]
!

testCaseErrorIcon
    <resource: #programImage>

    ^ self ledGrayedRed10x11
"/    ^ self ledDarkRed10x11
"/    ^ self redThumbDownSmallIcon
!

testCaseFailedIcon
    <resource: #programImage>

    ^ self ledRed10x11
"/    ^ self testCaseErrorIcon
!

testCasePassedIcon
    <resource: #programImage>

    ^ self ledGreen10x11
"/    ^ self greenThumbUpSmallIcon
!

testCaseSkippedIcon
    <resource: #programImage>

    ^ self ledGrey10x11
    "/ ^ self greenThumbUnknownSmallIcon
!

timeClassBrowserIcon
    <resource: #programImage>

    ^ self clockPink13x13Icon    
!

utilityClassIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self utilityClassIcon inspect
     ImageEditor openOnClass:self andSelector:#utilityClassIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary utilityClassIcon'
        ifAbsentPut:[(Depth2Image width:13 height:11) bits:(ByteArray fromPackedString:'@ @ H@K@8@@B0N@ @,C @@K@8@@A0M@@@W=P@@A*P@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 160 160 255 127 127 255 255 255 255] mask:((ImageMask width:13 height:11) bits:(ByteArray fromPackedString:'DD@X0A#@FL@X0A#@G<@O @@@@@@@@@@a'); yourself); yourself]
!

visualStartableClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self visualStartableClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#visualStartableClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary visualStartableClassBrowserIcon'
        ifAbsentPut:[(Depth4Image width:13 height:11) bits:(ByteArray fromPackedString:'@@@A@P@@@@9&XPE&XP@NY!!C E&D@C&DN; E!!@@9!!@N@AXP@NXP8N@VD@C&DN; E!!@@9!!A&XAXP@NXPY&@VD@C1DVI!!DQ@@@@D"HP@@@b') colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; yourself]
!

warningClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self warningClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#warningClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class warningClassBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@BH@@@@@@@@"@@@@@@@BH"@@@@@@@"H @@@@@@H"H@@@@@@BH"@@@@@@@"H @@@@@@@"@@@@@@@@@@@@@@@@@BH@@@@@@@@"@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 127 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'A @F@@<@C0@O@@<@C0@F@@@@A @F@@@a');
                            yourself);
                yourself
        ]
!

webServiceClassBrowserIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self webServiceClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#webServiceClassBrowserIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'GenericToolbarIconLibrary class webServiceClassBrowserIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@ADQD@@@@@DQDQD@@@@QDQDQD@@ACMDP3MD@@P3MDP3M@@DL3QCL3P@ADL4P3L4@@QCMDL3Q@@@QDQCMD@@@@QDQDP@@@@@QDQ@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'C8@_0C? _?A?<G?0_?A?<C? G<@O @@a');
                            yourself);
                yourself
        ]
!

windowClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self windowClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#windowClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary windowClassBrowserIcon'
        ifAbsentPut:[(Depth2Image width:13 height:11) bits:(ByteArray fromPackedString:'@@@@@R***P@/??4@K??=@B???PD/??4@K??=@R???P@/??4AEUUU@@@@@@@b') colorMapFromArray:#[0 0 0 255 255 255 127 127 127 170 170 170]; yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-SystemBrowser-java'!

javaClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary javaClassBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
VU%YVU\OF@4YC5]YVU%YVU%YVP$MO4YFQ#<ABU%YVU%YVP$[R5YTUUQRQ0(IVU%YVU\MRUAXVE!!XVD=H@U]YVU$GPEEXVEMMS%!!LR$@PVU%YASYBVDMAPTEE
QDP>AU%YVPDVI5 (EALSEA\\H@1YVU$EGQ)XJQ8"H!!H.C"PEVU%YDBD3M5 /I!!=XOR4*@E%YVU\JLC(4VE!!XMS02B%]YVU%YDP,#NC$;NS 1@!!EYVU%YVU$Q
ERT+KB,%EQEYVU%YVU%YVU\F@0PCBE]YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVU%YVP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[108 168 129 51 130 77 54 131 79 64 137 88 66 139 90 70 143 94 84 152 106 90 155 112 92 156 113 130 179 146 36 118 62 46 124 70 51 129 75 57 134 80 88 156 109 93 158 113 99 162 119 129 178 144 162 201 174 45 124 68 46 125 69 47 125 70 48 126 70 51 129 73 75 146 96 74 144 94 119 174 135 50 128 71 54 132 74 59 135 79 63 137 82 142 189 154 62 136 79 62 136 80 62 135 80 70 142 87 71 143 88 82 150 98 107 167 122 143 190 154 195 221 201 226 239 229 82 150 96 86 154 100 86 153 100 93 156 106 171 207 179 188 216 194 84 151 97 87 153 100 88 153 100 94 156 106 218 234 221 230 241 232 82 150 94 241 247 242 96 160 105 124 178 132 121 174 129 133 184 140 140 188 147 240 247 241 89 153 97 104 164 111 97 160 103 96 158 102 158 198 161 220 234 221 103 162 106 109 166 112 119 174 120 128 179 128 123 177 122 121 174 119 135 184 133 129 179 125 225 239 224 145 190 140 179 210 176 188 217 185 190 218 187 159 199 154 160 199 155 187 216 183 194 220 191 198 222 195 176 208 171 201 208 199 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?<_?0?>A?0C>@@@@@@@@@b') ; yourself); yourself]
!

javaExceptionBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaExceptionBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaExceptionBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaExceptionBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
D!!HRD!!HC@@DRD!!HRD!!HRD!!HRD!!HR@0@AD!!HRD!!HRD!!HRD!!HRD L@@QHRA $IA!!HRD!!HRD!!HC@@DRD $EAP$RD!!HRD!!HR@0@AD!!HIAPTID!!HRD!!HRD L@@QHR
B ,KB!!HRD!!HR@0HB@@HRD  PD@ RD!!HRD LA@@HRD!!HLDQDLD!!HRD!!HRD!!HRD!!HRA0<OA1HRD!!HRD!!HRD!!HRD!!HNC!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HR
D!!HRD!!HRA $IA!!HRD!!HRD!!HRD!!HRD $MA@$RD!!HRD!!HRD!!HRD!!HNCPPND!!HRD!!HRD!!HRD!!HRA 8NA!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[40 98 150 81 128 170 110 150 185 194 211 226 255 223 95 255 234 145 228 221 192 218 204 156 184 149 37 190 156 40 188 153 39 255 226 134 180 143 35 255 223 127 170 130 30 207 167 62 254 215 119 254 207 108 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A0@G@@\<A30GO@\<G30^O@@<@A @@@@<@C0@O@@<@@@b') ; yourself); yourself]
!

javaPrivateClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaPrivateClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaPrivateClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaPrivateClassBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
XVE!!XQHWHAX!!E1I!!XVE!!XVE!!XQ@VPD]GQ4@JDFE!!XVE!!XQ@$SE]UU%USRALPXVE!!XQHVR%E XFA XEAIB!!I!!XVDNPUI XEQNS6AMR4DXXVE!!CC%CXDQBP$IF
QTT?CFE!!XP(^K6@1GA,[GA<%JQU!!XVDLI"I L"\+J1$4F" QXVE!!FB(7N&@5K%)ZV%)ZV%)!!XRLSM#48XFAYWE1\WE1YXVE!!C1P,N30>V51^W%9\V6E!!XVDO
GR43L@HGA TFA0I!!XVE!!XQHMB0$CW54@@E<AXVE!!XVE!!XVE!!AE!!XVE!!XAFE!!XVE!!XVE!!XP HB@ HB@!!!!XVE!!XVE!!XVE!!XVE!!XVE!!XP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[231 96 97 200 41 48 200 48 52 200 41 49 200 29 44 242 77 92 241 77 92 245 118 128 200 25 42 152 195 167 51 130 77 64 137 88 70 143 94 84 152 106 90 155 112 126 179 144 129 181 146 155 198 169 205 226 212 36 118 62 46 124 70 51 129 75 57 134 80 93 158 113 99 162 119 162 201 174 166 204 178 45 124 68 46 125 69 47 125 70 48 126 70 51 129 73 75 146 96 74 144 94 119 174 135 216 233 221 50 128 71 54 132 74 59 135 79 63 137 82 155 198 166 62 136 79 62 136 80 62 135 80 70 142 87 82 150 98 107 167 122 143 190 154 164 203 173 195 221 201 226 239 229 86 154 100 171 207 179 188 216 194 84 151 97 94 156 106 218 234 221 82 150 94 241 247 242 96 160 105 124 178 132 121 174 129 167 204 172 89 153 97 104 164 111 97 160 103 96 158 102 158 198 161 220 234 221 103 162 106 109 166 112 119 174 120 128 179 128 123 177 122 121 174 119 135 184 133 129 179 125 225 239 224 145 190 140 179 210 176 188 217 185 190 218 187 159 199 154 160 199 155 187 216 183 194 220 191 198 222 195 176 208 171 231 147 139 201 67 60 201 71 62 201 62 58 246 146 142 231 96 96 245 124 124 237 131 131 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?>_?8??!!?>C?8@? C>@@@b') ; yourself); yourself]
!

javaPrivateEnumBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaPrivateEnumBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaPrivateEnumBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaPrivateEnumBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
QDQDQC\#F1PZH3]DQDQDQDQDQB0TI"@ HBXRKDQDQDQDQB0PJ#D1LSD1I 0,QDQDQC\TJR%BP$IBP#H D#]DQDP!!IBP$P$H6K2<''IBP%QDQDFQ0"H$IBKRH"
H"T FTQDQAHOCP5BP$IBP" SE!!EDQDPYEQTUP$H0NC JL3L5QDQDIQX\GDIBB30<OC0<OC1DQC\LG!!9BP$L<O#8>O#8;QDQDJ04XK"89OS9@PD@>OTQDQDP+
C!!4 BPHGA TFA0IDQDQDQC\_E3PCPS<@@DDAQDQDQDQDQDQDAC(:N#(:BDQDQDQDQDQDQ@ HB@ HB@!!DQDQDQDQDQDQDQDQDQDQDQ@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[231 96 97 200 41 48 200 48 52 200 41 49 200 29 44 242 77 92 241 77 92 245 118 128 200 25 42 217 201 182 219 204 186 230 219 206 140 89 32 142 92 36 142 93 37 143 93 38 144 94 39 144 95 40 145 96 41 146 97 43 147 99 45 147 100 47 148 101 48 149 103 50 152 107 56 153 108 57 154 109 60 155 111 62 158 115 67 158 116 68 159 117 69 160 118 71 161 119 73 163 123 77 165 125 81 165 126 81 166 127 83 169 131 88 170 133 91 176 141 102 178 144 106 180 147 110 185 154 119 186 156 122 187 157 124 190 161 129 194 167 137 199 174 146 204 182 157 206 184 160 209 188 165 212 193 172 213 195 174 214 196 176 216 199 180 225 211 196 226 213 199 231 220 208 231 147 139 201 67 60 201 71 62 201 62 58 246 146 142 231 96 96 245 124 124 237 131 131 255 254 254 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?>_?8??!!?>C?8@? C>@@@b') ; yourself); yourself]
!

javaPrivateInterfaceBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaPrivateInterfaceBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaPrivateInterfaceBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaPrivateInterfaceBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
TUEQTTPVCP,NE$QQTUEQTUEQTS<KD!!TUEQHKO5EQTUEQTS<3OQ-GQ4\[OSL?TUEQTRD,NQ1PTEAPB!!0;KBEQTUDVD3 8FEAPBS 8NAPYTUEQC4XLC@1PTDLL
CCT5C5EQTR<(J"\''TE@ I2\*IB9QTUDOKR,&I%APPT@^GQ5BTUEQFSH0LTUPTD)JR$)JR$)QTRH#M#)PTEAJSD1LSD1ITUEQF"TQOC0_R41NS$9LR5EQTUDZ
JS\PO HGA TFA0IQTUEQTTPWMA<CS44@@D<ATUEQTUEQTUEQAD!!HRD!!HBEEQTUEQTUEQTP HB@ HB@!!QTUEQTUEQTUEQTUEQTUEQTP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[231 96 97 200 41 48 200 48 52 200 41 49 200 29 44 242 77 92 241 77 92 245 118 128 200 25 42 197 188 224 215 209 233 112 94 176 111 93 174 114 96 177 113 95 176 115 97 177 117 100 177 120 102 180 125 108 184 125 108 183 130 114 185 143 128 194 151 136 198 149 135 197 158 145 203 156 143 201 159 146 203 165 153 207 168 156 208 168 156 207 167 155 205 171 160 209 174 164 209 220 215 236 226 222 240 85 66 159 90 71 159 93 74 164 90 72 159 89 71 158 92 73 160 94 75 164 93 74 161 93 75 161 97 79 167 96 79 166 97 79 166 98 80 167 98 80 165 96 79 162 101 83 168 101 84 169 108 91 173 107 91 172 111 94 174 117 100 178 131 116 188 137 122 191 134 120 187 139 125 191 138 124 190 142 128 193 154 142 199 161 149 204 167 156 207 174 165 210 181 172 216 185 176 218 204 198 228 94 78 161 105 89 172 174 165 212 231 147 139 201 67 60 201 71 62 201 62 58 246 146 142 231 96 96 245 124 124 237 131 131 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?>_?8??!!?>C?8@? C>@@@b') ; yourself); yourself]
!

javaProtectedClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaProtectedClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaProtectedClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaProtectedClassBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
X6M#X0(PE 8WD@)#X6M#X6M#X0\NM34=OS\@A6M#X6M#X0\\P$5KSD-IO ,GX6M#X0(NPD]"X&I"X$X?@@)#X6LEND!!"X$)DQVICPS QX6M#@2<:X#,9NS$<
LSD6@6M#X0@UIVH(D1HRD1 _I 5#X6LCGQ)"JQ8!!HP<(T%HHX6M#DR@-LFH+IA%"T$9NT&M#X1,KKCP.X&I"T5APTD=TX6M#A 0"L#L5VUUZV%)ZUUE#X6LF
EBL*I5!!_XVE!!XU=WX6M#X0(D@PHIW&A XFAVX6M#X6M#X6M#X6M\XFA]X6M#X6M#X6M#X6M#X5-[X6M#X6M#X6M#X6M#X6M#X6M#X0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[51 130 77 64 137 88 66 139 90 70 143 94 84 152 106 90 155 112 126 179 144 129 181 146 155 198 169 180 212 191 205 226 212 36 118 62 46 124 70 51 129 75 57 134 80 79 149 101 93 158 113 99 162 119 45 124 68 46 125 69 47 125 70 48 126 70 75 146 96 74 144 94 83 151 103 109 168 126 119 174 135 216 233 221 50 128 71 59 135 79 63 137 82 144 191 156 62 136 80 62 135 80 70 142 87 82 150 98 107 167 122 143 190 154 150 194 161 164 203 173 195 221 201 226 239 229 86 154 100 188 216 194 84 151 97 94 156 106 218 234 221 82 150 94 241 247 242 84 151 94 96 160 105 124 178 132 121 174 129 167 204 172 89 153 97 104 164 111 97 160 103 96 158 102 158 198 161 220 234 221 109 166 112 119 174 120 128 179 128 123 177 122 121 174 119 135 184 133 129 179 125 225 239 224 145 190 140 179 210 176 188 217 185 190 218 187 159 199 154 160 199 155 187 216 183 194 220 191 198 222 195 176 208 171 255 242 176 255 233 145 255 234 145 183 147 37 190 156 40 187 152 39 187 153 39 255 230 152 174 135 31 179 141 34 178 141 34 184 147 36 255 222 125 167 126 28 170 129 29 170 130 30 174 135 32 254 219 140 254 222 150 254 207 108 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?<_?8??1??C?8@O@@X@@@b') ; yourself); yourself]
!

javaProtectedEnumBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaProtectedEnumBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaProtectedEnumBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaProtectedEnumBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
Q4]GQ4P-IQ4$KTQGQ4]GQ4]GQ3\]LB(*J#@\M4]GQ4]GQ3\ZMS4=OS4=LAX7Q4]GQ4P]L3MFQ$YFQ#8*GDQGQ4\+K"8.Q$YCN3,1K"8/Q4]GH2X,KDYFNB0,
KB<*H4]GQ10YE1]FQ$YFQ#H?PQ-GQ4\#G!!8^Q$X<MCPUA@QBQ4]GK1<&I$YFNRYCA@@@AD]GQ4PVJB!!FQ$YFAPHB@ DFQ4]GM!!\"N#)EB0\LC@0LA0MGQ4\6
FB\*E@(QD1LSD1DIQ4]GQ4P)HBE@DAHRD!!HHQ4]GQ4]GQ4]GQ4\ND!!HOQ4]GQ4]GQ4]GQ4]GQ04MQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 242 176 255 233 145 255 234 145 183 147 37 190 156 40 187 152 39 187 153 39 255 230 152 174 135 31 179 141 34 178 141 34 184 147 36 255 222 125 167 126 28 170 129 29 170 130 30 174 135 32 254 219 140 254 222 150 254 207 108 217 201 182 219 204 186 140 89 32 142 92 36 142 93 37 143 93 38 144 94 39 144 95 40 145 96 41 147 99 45 147 100 47 148 101 48 149 103 50 151 104 53 152 107 56 153 108 57 154 109 60 155 111 62 158 115 67 158 116 68 159 117 69 160 118 71 161 119 73 163 123 77 165 125 81 165 126 81 166 127 83 169 131 88 170 133 91 176 141 102 178 144 106 180 147 110 182 150 114 185 154 119 186 156 122 187 157 124 190 161 129 192 164 133 194 167 137 199 174 146 204 182 157 206 184 160 209 188 165 211 192 170 213 194 173 212 193 172 214 196 176 216 199 180 225 211 196 231 220 208 255 254 254 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?<_?8??1??C?8@O@@X@@@b') ; yourself); yourself]
!

javaProtectedInterfaceBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaProtectedInterfaceBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaProtectedInterfaceBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaProtectedInterfaceBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
U%YVU#4MA@HECS5VU%YVU%YVU# BBP0LC@$BNEYVU%YVU# -M1I@PD@RM248U%YVU!!0&L1QUUUUU@QP5I!!1VU%XMB#H2C5UU@CH2L ,PU%YVA#<C@0MUUS0C
@2</A%YVU"$"IBD!!UUTYHRDUD2!!VU%XFI2T HEUUN"@VQTT;U%YVDB0*J39UUQ(9QTEAQUYVU!!4^LCQUUUUUQ$MCP4IGU%YVDQ<HM#XWSD!!MST5MRDQVU%XQ
H3DGF4-RUEQTUEIJU%YVU#4NK"\XTUMST5MIU%YVU%YVU%YVU%YOT5MPU%YVU%YVU%YVU%YVU$9NU%YVU%YVU%YVU%YVU%YVU%YVU @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[197 188 224 215 209 233 112 94 176 111 93 174 114 96 177 113 95 176 115 97 177 117 100 177 120 102 180 125 108 184 125 108 183 130 114 185 143 128 194 151 136 198 149 135 197 158 145 203 156 143 201 159 146 203 165 153 207 167 155 207 168 156 208 168 156 207 167 155 205 171 160 209 178 167 213 174 164 209 177 167 212 183 173 216 220 215 236 226 222 240 85 66 159 93 74 164 90 72 159 89 71 158 92 73 160 94 75 164 93 74 161 93 75 161 97 79 167 96 79 166 97 79 166 98 80 167 98 80 165 96 79 162 101 83 168 101 84 169 108 91 173 107 91 172 111 94 174 117 100 178 131 116 188 137 122 191 134 120 187 139 125 191 138 124 190 142 128 193 161 149 204 169 159 207 174 165 210 181 172 216 185 176 218 204 198 228 94 78 161 105 89 172 174 165 212 255 242 176 255 233 145 255 234 145 183 147 37 190 156 40 187 152 39 187 153 39 255 230 152 174 135 31 179 141 34 178 141 34 184 147 36 255 222 125 167 126 28 170 129 29 170 130 30 174 135 32 254 219 140 254 222 150 254 207 108 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?<_?8??1??C?8@O@@X@@@b') ; yourself); yourself]
!

javaPublicClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #programImage>

    ^self javaClassBrowserIcon

    "Created: / 23-10-2011 / 14:41:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaPublicEnumBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaPublicEnumBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaPublicEnumBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaPublicEnumBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
LC@0LB8ZD@ OF"80LC@0LC@0LBTHGQXVE!!4FIS@0LC@0LBTDH2,+J2,+GP@%LC@0LB8HHRD/K2</K20VA"80LC@WF1,[K2<-JR$_F1,\LC@0C!!DYFR</I!!$Y
FQ0VC#@0L@XC@PD/K2</K2@GB T0LC@NBP$IK2<*H"H[BP$NLC@0G@(QDR</I1DQDQDQG#@0LB8@D1L/K2</K20V@B80LC@0I@DMJB (JB ]A2P0LC@0LC@$
@!!HVEQXR@"P0LC@0LC@0LB8TB00KFB80LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0L@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[140 89 32 142 92 36 142 93 37 143 93 38 144 94 39 144 95 40 145 96 41 146 97 43 147 99 45 147 100 47 148 101 48 149 103 50 151 104 53 152 107 56 153 108 57 154 109 60 155 111 62 158 115 67 158 116 68 159 117 69 160 118 71 161 119 72 161 119 73 163 123 77 164 124 79 165 125 81 165 126 81 166 127 83 169 131 88 170 133 91 175 139 100 176 141 102 178 144 106 180 147 110 182 150 114 185 154 119 186 156 122 187 157 124 190 161 129 192 164 133 194 167 137 199 174 146 204 182 157 206 184 160 209 188 165 216 199 180 225 211 196 255 254 254 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?<_?0?>A?0C>@@@@@@@@@b') ; yourself); yourself]
!

javaPublicInterfaceBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaPublicInterfaceBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaPublicInterfaceBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaPublicInterfaceBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
P4MCP38NAPLFC#9CP4MCP4MCP3,CB 4MCP(CN4MCP4MCP3,.N!!UAPTDUN"8;P4MCP1$%M!!YBP$IB@!!X8IQ%CP4LNB3T5DTIB@CT5MP0RP4MCA4@DA@QBP#4D
AC@0A4MCP2  H!!<_P$HWG1<"GB]CP4LGI"P^G$IBOA8_H"LGP4MCD"4*J3=BP!! ?J2,,EDMCP1([L3]BP$IB@S\2F1%CP4MCD14INS$9NS$1JQMCP4MCP4LS
HSPHB@ 4HQMCP4MCP4MCP38OK2X/DC9CP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[197 188 224 197 189 222 215 209 233 112 94 176 111 93 174 114 96 177 113 95 176 115 97 177 117 100 177 120 102 180 125 108 184 125 108 183 130 114 185 143 128 194 151 136 198 149 135 197 152 138 199 158 145 203 156 143 201 159 146 203 162 150 204 165 153 207 168 156 208 174 164 209 177 167 212 220 215 236 226 222 240 85 66 159 90 71 159 93 74 164 90 72 159 89 71 158 92 73 160 94 75 164 93 74 161 92 74 160 93 75 161 97 79 167 96 79 166 97 79 166 98 80 167 100 82 168 98 80 165 96 79 162 100 82 167 101 83 168 101 84 169 108 91 173 107 91 172 108 92 172 113 96 177 111 94 174 117 100 178 131 116 188 137 122 191 134 120 187 139 125 191 138 124 190 142 128 193 161 149 204 174 165 210 185 176 218 204 198 228 94 78 161 105 89 172 174 165 212 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?<_?0?>A?0C>@@@@@@@@@b') ; yourself); yourself]
!

javaRuntimeExceptionBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaRuntimeExceptionBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaRuntimeExceptionBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class javaRuntimeExceptionBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
D1LSD1LMB ,SD1LSD1LSD1LSD1LSCP(KD1LSD1LSD1LSD1LSD04JB1LSB@8NBALSD1LSD1LMB ,SD08OC08SD1LSD1LSCP(KD1LND!!DND1LSD1LSD04JB1LS
D@@@DALSD1LSCP0LB 0SD0DB@0DSD1LSD04KB 0SD1LGAPPGD1LSD1LSD1LSD1LSA 8NA!!LSD1LSD1LSD1LSD1LGA1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LS
D1LSD1LSBP8NBQLSD1LSD1LSD1LSD08QDP8SD1LSD1LSD1LSD1LGDQDGD1LSD1LSD1LSD1LSB@\GBALSD1LSD1LSD1LSD1LSD1LSD0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[244 120 123 200 39 47 244 102 111 243 103 111 243 88 99 242 87 99 233 164 170 200 25 42 242 197 202 244 208 212 40 98 150 81 128 170 110 150 185 194 211 226 201 71 62 246 146 142 201 58 56 246 136 134 246 135 135 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A0@G@@\<A30GO@\<G30^O@@<@A @@@@<@C0@O@@<@@@b') ; yourself); yourself]
!

javaUndeclaredClassBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self javaUndeclaredClassBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#javaUndeclaredClassBrowserIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary javaUndeclaredClassBrowserIcon'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@DB@0PE@ D@@@@@@@@@@@XDA0 HB@\IA @@@@@@@@XJB00MC 4OB1@F@@@@@@DDDQH@@@@@@ALTBPD@@@@UE!!\@@A YF @[GAX]@@@@G!!< @BD"H"H#
IBP%G @@@@$&I0@(JR(*JR,,KR8@@@@^K3@@LSH3L3P5M#\^@@@@GS 9N @;OC4@O#=@PP@@@@DPP#AC@@@@QDT%D@D@@@@@Q$]HRT)KR$%LSTX@@@@@@@AF
S$<%TBUOS$X@@@@@@@@@@@EQT%MRU@D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 205 205 205 134 134 134 119 119 119 105 105 105 118 118 118 161 161 161 140 140 140 152 152 152 101 101 101 98 98 98 158 158 158 194 194 194 209 209 209 212 212 212 182 182 182 87 87 87 152 152 152 206 206 206 205 205 205 155 155 155 131 131 131 135 135 135 182 182 182 204 204 204 171 171 171 197 197 197 233 233 233 164 164 164 138 138 138 116 116 116 124 124 124 182 182 182 228 228 228 133 133 133 143 143 143 138 138 138 128 128 128 97 97 97 172 172 172 211 211 211 95 95 95 94 94 94 100 100 100 102 102 102 108 108 108 100 100 100 106 106 106 153 153 153 234 234 234 109 109 109 107 107 107 186 186 186 193 193 193 130 130 130 115 115 115 108 108 108 132 132 132 244 244 244 205 205 205 144 144 144 171 171 171 244 244 244 132 132 132 124 124 124 146 146 146 125 125 125 227 227 227 236 236 236 169 169 169 159 159 159 95 95 95 114 114 114 135 135 135 157 157 157 164 164 164 127 127 127 102 102 102 96 96 96 124 124 124 127 127 127 127 127 127 110 110 110 112 112 112 132 132 132]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'C>@_<C?8_?1??G?<_?1??G?<_?0?>A?0C>@@@@@@@@@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-UIPainter'!

copyWidgetIcon
    <resource: #programImage>

    ^ self copy22x22Icon
!

cutWidgetIcon
    <resource: #programImage>

    ^ self cut22x22Icon
!

deleteWidgetIcon
    <resource: #programImage>

    ^ self delete22x22Icon
!

gridAlignIcon
    <resource: #programImage>

    ^ self gridAlign16x16Icon
!

gridIcon
    <resource: #programImage>

    ^ self grid16x16Icon
!

loadFromMethodIcon
    <resource: #programImage>

    ^ self loadFromMethod22x22Icon
!

moveWidgetDownIcon
    <resource: #programImage>

    ^ self down22x22Icon
!

moveWidgetDownRightIcon
    <resource: #programImage>

    ^ self downRight22x22Icon
!

moveWidgetLeftDownIcon
    <resource: #programImage>

    ^ self leftDown22x22Icon
!

moveWidgetUpIcon
    <resource: #programImage>

    ^ self up22x22Icon
!

newWindowSpecIcon
    <resource: #programImage>

    ^ self newWindowSpec24x24Icon
!

pasteWidgetIcon
    <resource: #programImage>

    ^ self paste22x22Icon
!

saveAsMethodAsIcon
    <resource: #programImage>

    ^ self saveAsMethod22x22Icon
!

saveAsMethodIcon
    <resource: #programImage>

    ^ self saveAsMethod22x22Icon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-tools-misc'!

errorIcon
    <resource: #programImage>

    ^ self error32x32Icon
!

newDataSetIcon
    <resource: #programImage>

    ^ self newDataSet24x24Icon
!

newRowIcon
    <resource: #programImage>

    ^ self newMenuItem22x22Icon
!

removeRowIcon
    <resource: #programImage>

    ^ self cutMenuItem22x22Icon
!

warnIcon
    <resource: #programImage>

    ^ self warn32x32Icon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-versions'!

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
        constantNamed:'GenericToolbarIconLibrary versionA12x12'
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
        constantNamed:'GenericToolbarIconLibrary versionA16x16'
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
        constantNamed:'GenericToolbarIconLibrary versionA24x24'
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
        constantNamed:'GenericToolbarIconLibrary versionAB12x12'
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
        constantNamed:'GenericToolbarIconLibrary versionABBase12x12'
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
        constantNamed:'GenericToolbarIconLibrary versionABase12x12'
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
        constantNamed:'GenericToolbarIconLibrary versionB12x12'
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
        constantNamed:'GenericToolbarIconLibrary versionB16x16'
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
        constantNamed:'GenericToolbarIconLibrary versionB24x24'
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
        constantNamed:'GenericToolbarIconLibrary versionBBase12x12'
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
        constantNamed:'GenericToolbarIconLibrary versionBase16x16'
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
        constantNamed:'GenericToolbarIconLibrary versionBase24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@!!LNDADQE!!XVF!!0_H2D$H2@ H18"H!!8AO=SZ6]''\7^C"8.[&9.#*;N?2;_W6>]HXU^''.;.;.<OS4=OS4=?_8>O#;?O;=?>\RTMOM3L3K2<3M3<?Q5=/^8^W)
9.[1:=T]Q<N:.[&8.K?A/\GA1LSG1<+J5-#$7<8VR*:.,+N6-+&9.[2<0LC@0LC@0<#B4L$ON:J*****+:.+*;N1-[V5-;.;0LB=1+8VN*J\)JF!!)JR#*J"+
*:6-,[V5-+&9/;@MNIBQ$)JY$)JY''):^(:N#*J"/)+J/-I4LNXNK#H.N!!)JT$)JR%).[&Y.&)*J&*YLTM6&H"H"H"H.N#(:N#9BP$IZV&*JZ&8(UMU5,\8E9
 V=2^XRH"8.K"8:O#9*V%''4UMT%HV6I1\WE1\W9/^XNC (NH"H.K#G@YM$EAP45_W&11[7E1^GM8\7M: (M3"VLULDMCRDMAP45[V6I"X&I"[F1,X''91_5 K
LDMQUEEMRDMCPUQTW6!!+]&I,[HE5[D0KLU)ST5M(W5)TTT5MTUEQUE)SW6-SYC4JL65ST5MST5MST5MSS$9NS$9HQD9DRC8JLVI1[FI"X&I WE1ST5M[ZF!!_
UEQNS30GLFI,\V11\W!!,X&I"Y&I!!W%9^T5MSWS0HLH]:^&93[798[G9/\V1,X&I!!WFA\Y30EMIF,%9RK_G%9\&=/[6=1[&91[GV@]DHDJ9>6+)2P"8"A!!7=?
_7=?_7=?\7Q.^4@CA"X-I2\''I2</JR$)JR (JB (K"4,J"T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[1 10 28 0 14 26 0 23 36 0 29 57 1 32 55 0 32 58 0 34 61 3 34 57 0 35 56 0 36 63 0 37 64 0 41 63 3 45 67 0 47 68 5 46 69 6 47 70 0 50 72 0 51 73 15 48 60 17 47 65 9 49 72 0 51 79 0 53 74 0 53 75 25 47 61 2 53 81 13 51 74 1 55 77 4 57 79 15 55 72 23 55 68 7 59 81 19 58 76 12 61 83 25 59 67 21 60 77 23 61 79 5 67 94 6 75 114 0 78 122 0 80 124 0 80 130 0 82 120 25 76 110 0 84 122 17 80 119 0 85 123 20 80 125 2 85 129 0 86 135 0 88 137 0 90 139 26 85 125 1 97 141 22 92 137 9 99 143 16 104 142 31 100 139 22 107 145 26 109 147 16 117 155 0 123 166 22 117 161 73 108 128 48 114 148 0 126 187 40 118 156 0 128 189 0 128 196 0 129 190 0 130 191 31 124 162 0 131 192 0 132 187 32 125 163 0 131 198 20 129 172 4 132 193 0 133 200 3 134 189 57 122 156 9 133 194 0 135 202 0 137 204 13 134 196 66 123 152 0 138 199 0 138 206 41 130 168 0 139 207 17 135 197 0 140 201 0 140 208 16 137 192 0 141 202 20 136 198 0 141 209 0 142 203 0 143 204 45 133 171 23 137 199 0 144 205 0 144 211 23 139 194 26 138 200 0 146 201 2 145 206 29 139 201 7 146 208 31 140 202 5 148 203 0 150 210 52 138 176 13 147 209 0 151 211 11 149 204 33 143 199 18 146 214 36 142 204 0 152 212 17 148 210 0 153 213 15 150 205 33 146 195 0 154 214 47 143 187 21 149 211 39 146 202 41 145 208 24 150 212 22 152 207 25 153 208 28 152 214 28 154 209 1 162 216 47 150 207 31 155 211 45 152 202 65 148 187 33 156 212 32 159 208 35 158 213 38 159 214 40 160 215 42 161 216 55 158 208 40 163 211 73 155 194 44 162 217 42 164 213 46 163 218 28 168 223 44 165 214 47 166 215 49 165 221 62 163 214 51 166 222 87 159 193 50 168 217 83 160 206 64 165 215 51 169 218 55 168 224 53 170 219 67 167 217 58 170 227 68 168 218 56 172 221 58 173 223 80 168 213 71 170 220 60 174 224 62 173 229 61 175 225 64 174 231 74 172 223 96 168 202 63 176 226 75 173 224 76 174 225 85 173 218 65 178 228 78 175 226 67 180 229 77 178 222 80 177 228 82 178 229 70 182 231 83 179 230 81 181 226 105 176 211 92 179 225 85 181 233 93 180 226 84 184 228 75 186 235 95 181 227 87 183 234 94 184 223 98 184 230 89 188 232 106 188 222 102 188 234 100 190 229 101 191 230 104 193 232 116 191 219 105 194 233 107 196 235 114 196 229 149 189 203 102 199 244 137 196 220 135 198 215 113 202 241 128 199 234 114 203 242 126 201 229 134 199 228 130 201 236 128 203 231 131 205 234 134 204 240 117 209 242 133 208 236 128 209 243 143 208 238 145 209 239 123 215 247 133 213 247 146 211 240 161 210 223 148 213 243 144 214 250 156 215 239 155 218 235 158 217 241 163 217 235 142 223 255 161 220 245 149 223 252 154 223 246 170 220 246 151 225 254 153 227 255 170 224 243 176 225 238 161 230 253 163 232 255 181 231 244 166 235 255 172 236 253 190 240 253 184 242 254 193 243 255 193 248 253]; yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-widgets'!

colonBitmap
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self colonBitmap inspect
     ImageEditor openOnClass:self andSelector:#colonBitmap
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary colonBitmap'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@DQD@@PQDD@AADD@AD@DP@DB@P@DR(Q@@P*A@@QBAD@A@@D@AADPP@ADQ@@DDQA@@P@A@@QBAD@AB(D@AD*DP@DB@P@DP@Q@@PQA@@PQDD@@QDP@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led0
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led0 inspect
     ImageEditor openOnClass:self andSelector:#led0
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led0'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@***@@"**H@JJ*J@B(@J @*@B(@J @*@B(@J @*@B(@J@@J@BADP!!TADQ@@HDQB@B @B @*@B(@J @*@B(@J @*@B(@J @*@B"*" @"**H@B**(@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led1 inspect
     ImageEditor openOnClass:self andSelector:#led1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led1'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@DQD@@PQDH@AADJ@AD@J @D@B(@DP@*EPP@J @Q@B(@A@@J@AADP @ADQ@@DDQB@@P@B @Q@B(@A@@*@AD@J @D@B(@DP@*@@PQB @PQDH@@QDP@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led2 inspect
     ImageEditor openOnClass:self andSelector:#led2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led2'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@***@@R**H@AJ*J@AD@J @D@B(@DP@*@@P@J @Q@B(@A@@J@AJ*( @J** @H**!!@B @A@@*@AD@J @D@B(@DP@*@@P@J @Q@B"*!!@@"**D@B**(@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led3 inspect
     ImageEditor openOnClass:self andSelector:#led3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led3'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@***@@R**H@AJ*J@AD@J @D@B(@DP@*@@P@J @Q@B(@A@@J@AJ*( DJ** @D**"@@P@B @Q@B(@A@@*@AD@J!!LD@B(@DP@*@@R*" @R**H@B**(@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led4
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led4 inspect
     ImageEditor openOnClass:self andSelector:#led4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led4'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@DQD@@ QDH@JADJ@B(@J!!P*@B(@J @*@B(@J @*@B(@J@@J@BJ*( @J** @D**"@@P@B @Q@B(@A@@*@AD@J HD@B(@DP@*@@PQB @PQDH@@QDP@@@@
@APb') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led5
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led5 inspect
     ImageEditor openOnClass:self andSelector:#led5
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led5'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@***@@"**D@JJ*D@B(@DP@*@@P@J @QER(@A@@*@AD@J@@D@BJ*(P@J** @D**"@@P@B @Q@B(@A@@*@AD@J @D@B(@DP@*@@R*" @R**H@B**(@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led6
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led6 inspect
     ImageEditor openOnClass:self andSelector:#led6
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led6'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@B ***@@"**DJJJ*D@B(@DP(*@@P@J @Q@B(@A@@*@AD@J@@D@BJ*(P@J** @H**"B" @B @*@B(JJ @*@B(@J @*@B(@J @*@B"*" @"**H@B**(@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led7
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led7 inspect
     ImageEditor openOnClass:self andSelector:#led7
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led7'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@***@@R**HJAJ*J@AD@J (D@B(@DP@*@@P@J @Q@B(@A@@J@AADP (ADQ@@DDQB@@P@B @Q@B(@A@@*@AD@J @D@B(@DP@*@@PQB @PQDHK@QDP@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led8
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led8 inspect
     ImageEditor openOnClass:self andSelector:#led8
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led8'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@UUU@@QUUDTEEUE@AT@EP@U@AT@EP@U@AT@EP@U@AT@E@@E@AEUTP@EUUP@DUUQ@AP@AP@U@AT@EP@U@AT@EP@U@AT@EP@U@AQUQP@QUUDTAUUT@@@@
@@@b') colorMapFromArray:#[0 0 0 255 0 0]; yourself]
!

led9
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led9 inspect
     ImageEditor openOnClass:self andSelector:#led9
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary led9'
        ifAbsentPut:[(Depth2Image width:13 height:23) bits:(ByteArray fromPackedString:'@@@@@@***@@"**H@JJ*J@B(@J @*@B(@J @*@B(@J @*@B(UJ@@J@BJ*( @J** @D**"@@P@B @Q@B(@A@@*@AD@J @D@B(@DP@*@@R*" @R**H@B**(@@@@
@@@b') colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

meterBitmaps

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self meterBitmaps inspect
     ImageEditor openOnClass:self andSelector:#meterBitmaps
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class meterBitmaps'
        ifAbsentPut:[(Depth8Image new) width: 260; height: 27; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@J@@@@@@@@@@@@
@@@@@@@@@@@@@@(@@@@@@@@@@@@@@@@@@@@@@@@@B @@@@@@@@@@@@@@@@@@@@@@@@@J@@@@@@@@@@@@@@@@@@@@@@@@@@(@@@@@@@@@@@@@@@@@@@@@@@@@
B @@@@@@@@@@@@@@@@@@@@@@@@@J@@@@@@@@@@@@@@@@@@@@@@@@@@(@@@@@@@@@@@@@@@@@@@@@@@@@H0@@@@@@@@@@@@@@@@@@@@@@@@@J@@@@@@@@@@@@
@@@@@@@@@@@@@@(@@@@@@@@@@@@@@@@@@@@@@@@@H0@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@(@APTEAPT@@@@@@@TEAPTEAP@@
B @EAPTEAPT@@@@EAPTEAPTE@@@J@@TEAPTE@@@@@@@EAPTEAPT@@@(@APTEAPT@@@@@@@@EAPTEAP@@B @EAPTEAPTEAPT@@@TEAPTE@@@J@@TEAP@@@@@@
@@@@@@TEAPT@@@(@APTEAPT@@@@@@@@EAPTEAP@@B @EAPT@@@@@@@@@@@@@@@TE@@@#@@TEAPTE@@@@@@@EAPTEAPT@@@(@APTEAPT@@@@@@@TEAPTEAP@@
B @EAPTEAPT@AP@EAPTEAPTE@@@#@@TEAPTEAP@E@@TEAPTEAPT@@BL@APTEAPTE@@T@APTEAPTEAP@@B @OC0<EEQP+BR,TG@TOB0<KAP@J@@,KB0,KAQ0[
A@,KB0,KB0,@@@(@C0,OAP,JH LCF10EB0,OB0T@B TKC0,EEQPCCP4+C!!0EB0<KAP@J@@<KC0,OB0<EEP(AB0,KB0<@@@(@C0,K@RH+J0LI@0L[C0,OB0T@
B TKC0,KAPP+CP4"@P,KB0<KAP@J@@,KERL#H2L#H2L#H2L\B0,@@BLEC0<OAP,AEBH_EB@KB0,OB0T@B @OC0,EC0(_J2HTG@TKB0<KAP@J@@,EB0,EB0,K
AP,KB0,EB0,@@BLEB0TKB0TKB0,EB0,KB0TKB0T@H0@KAP,KAP,KB0TKB0,KAP,K@@@JB0<OB1PHFQ$YFQ$RG0<OC0<E@@(EC0<OC0<OHQ$YB ,OC0<OC0T@
B TOC0,AG!!$YFQ$YD!!<KC0<OAP@JAP<OB1PHFQ$YFQ$YB@(KC0<E@@(EC0<OC0<OB2L*FQ$IB0<OC0T@B TOC1TBFQ$YFQ$YFQ$_B0<OAP@JAP<OC1TIFQ$Y
FQ$YF"@KC0<E@@(EC1PRFQ$YFQ$YFQ$YFQ$"C0T@H0TOC0,JHQ$YFQ$YFQL B0<OAP@JB0<OB08BFQ$YFQ$RJ0<OC0<E@@(EC0<OC0<KC0,KC0,OC0<OC0T@
H0TOC0<OC0,OB0,OB0<OC0<OAP@#AP<OC0<OB0<KB0<KC0<OC0<E@@(KG@<+FQ$YFQ$YFQ$YD1TUEPT@B ,\EQTOEP$YFQ$IC1TUEQTUAP@JB10OEA$YFQ$Y
FQ$YFP$UEQTE@@(KG@<"FQ$YFQ$YFQ$YFQPOG@T@B ,\EQ0UG@<#BA$YFQ$NC10UAP@JB10OB!!$YFQ$YFQ$YFP4OEQTE@@(KGAT\JQ$YFQ$YFQ$YC@(UEPT@
B!!X\D!!$YFQ$YFQ$YFQ$YFQH\@@@#B2PU@1$YFQ$YFQ$YFP0JEQTE@@(KEQTCFQ$YFQ$YFQ$YF!!TUEPT@B ,\EQTOC0<OC0<OC1TUEQTUAP@#B10UEP<OC0<O
C0<OEQTUEQTE@BLKGATUC0<OC0<OC0<UEQTUEPT@B <\EA$YFQ$HF"(YFQ$YCQ0 AP@JC2@\H0$HFQ$YFQL\GB@ HB@E@@(OG@DRFQ$Y@!!(*FQ$YFQ<\H@T@
B <\@QHYFQ$SF2H*FQ$YFPP\AP@JC2@ GB@\HB(YFQ$YFP$UHB@E@@(OHATCFQ$RHQ8!!HRDSAA0 H@T@B < EP4YFQ$HBR,ZFQ$YD D\AP@JC10CD!!$YFQ$Y
FQ$YFQ$YD10E@BLOEQ,YFQ$YF",I@!!$YFQHDG@T@B <\J1$YFQ$!!D18YFQ$YCQ0 B0@JC2@\H10\GA0\GA0\GB@ HB@E@BLOHA0#GA0\GA0\GA0\HB@ H@T@
H0< HBL\GA0\GA0\GA0 HB@ AP@JEPDHFQ$YHRL\HB,YFQ$YF2@K@@(OH10MFQ$YFQ$YIR@ H2@ H@,@B!!T H!!$YFPH#GB@ZFQ$YB@D B0@JER@[FQ$YG!!0\
I DHFQ$YH"@K@@(UH2@#H10IFQ$YFQ$YD10FH0,@B!!T#HBDYFQ8 HB@ HA0 H2@#B0@JER@DFQ$YD (UGA0IFQ$YEB@K@@(UH10DH",+H",_F!!$YFQHDH@,@
H1T#HQ$YFP$UGATABA$YFR, B0@JC0(YFQ$YCR@\GBHYFQ$YEB@K@@(OH0DA@PDA@PDA@R@ H2@ H@,@H1T#@PDA@PDA@PDAHB@#HB@ B0@#C2LA@PDA@PDA
@PD HBL HB@K@@(U@1$YFP0DH0DAH1(YFQ$^H0,@B!!0AH18YFQ$YFQ$ZH0DA@PDAB0@JGBLIFQ$YJ2@AH0(RFQ$YF2LK@@(\@Q,YFQ$TH0DAH1LYFQ$CH0,@
B!!0A@PD#H!!$YFQHYFQ$SH0DAB0@JG@DJD!!$Y@2@AH0DA@PDA@PDK@@(\H0$YFQ$CHBL#H2LMD!!8D@P,@B!!TD@PD H2@#G@(HFQ$YF2LAB0@#EP(YFQ$YB"LA
@RLMFQ$YBRLK@@(UBQ$YFR(A@PDAH1LYFQ$SH0,@B!!0AH0DA@PD#@PD#H0DA@PDAB0@#EPD#@PDA@RLA@RL#@PDA@PDK@BL\@PDA@PDAH0DA@RLA@PDA@P,@
B"@*FQ$YCPPJB (JC 0YFQHTB0@JH@8JF1(!!BA$YFQ8DB (JB (O@@( B"HYFP0NB (JB  YFQ$+A@<@B"@JC!!LBCP(JB (DJ!!$YFPLDC0@JH@8JB LYFQ$*
BQ$YFQ(DB (O@@( B"HYFQ$[B!!<"F0(JB (NB <@B"@TCA$YD!!<"@0L"C PNB (JC0@JH@8JB (JB (TBA$YFP4DB (O@BL C HYFQ$TB (JAA8YFQ$CA@<@
B!!0^FQ$YBPPJB (JC!!HYFP NB0@JH@8JB (JB (JB (JB (JB (O@BL C (+J2,+J2,+J2,+J2,JB <@H2@NB (JB (JB (JB (JB (JC0@JAAHYFQ$+G1<_
G1<[J!!$YFPLO@@(DA1<[F1PIFQ$YJ!!,_G1<_G1T@B P"F1(BBQ<_G1<"D!!$YFP$[EP@JABH_F1<[G1<_G1LYFQ$RH!!<U@@(DH!!,"D!!$YFRHIFQ$YHQ,_G1T@
B P_D1$YD!!LLFQ$YJ L[G1<_EP@J@P$YFQ$RCA$YFQ$RD1,[G1<U@@(DA1<_G1<_F0HYFQ$LG1<_G1T@H0P[F!!$YFRD_G1,CD!!$YD"H_EP@JAB(YFQ$IF1<_
G1<_D!!$YFRHU@@(DA1<[F1P_G1<_G1<_G1<_G1T@H0P[G!!HRD!!HRD!!HRD!!HRD!!8_EP@#A@\_F1,TG1<_G1<_G1<_G1<U@@("FQ$YD!!(ZF!!(ZF!!LHFQ$YJ!!0@
B!!,^F"TZD2DYFQ$HD2TZF!!(ZG@@JG18ZD1LSF!!(ZD0HYFQ$LF!!( @@(_G!!LZD1(SHP0YFQ$YBA(ZF!!0@B!!<ZF!!HYFQ$!!D2(YFQ$BD1(ZG@@JG1(HFQ$YFQ$Y
FQ$YFP SF!!(\@@(]@!!$YFQ$YFQ$YFQ$YD!!8ZF"@@B!!<^F!!(ZF!!L*FQ$YFQ8SF!!(ZG@@#G18ZBA$YFQHRD!!$YFQH^F!!( @@([BA$YFP SF!!(ZD2(YFQ$YG!!0@
B!!,^F"TZHRDZF!!(ZD2TZF!!(ZG@@#G18^FQ$YFQ$YFQ$YFQ$YG!!( @BL[G!!(%F"D!!F!!(ZF!!L%F!!(ZF!!0@A@8YFQ$HG1<_G1<_F18YFQ$SC0@JABH_G1<[BQ$Y
FRD[G1<_G1<U@@(DH!!<_G1<_KA,SFQ$YFPL_G1T@B P"G1<_G1,!!FQ$YFQHSF1<_EP@JABHBFQ$YG!!,[CQ$YFRD[G1<U@@(DG2DYFQ$YD!!HYFQ$YFQ8_G1T@
B D^FQ$YFQ$R@  YFQ$YCB,_EP@JA@\_G1<_H 0YFQ$MF1<_G1<U@BLDH!!,^FQ$YFQ$YFQ$YCBH_G1T@B PSFQ$YFQL[F1<IFQ$YFQ$CC0@JABH_G1<[G1<_
G1<[G1<_G1<U@BLDH!!8RFQ$YFQ$YFQ$YD!!H^G1T@H0P"G1<_F1<_G1<_F1<_G1<_EP@JAA$YFP TEAPTEAPNF!!$YFP4K@@(#EAPTE@8CFQ$YHP8TEAPTE@<@
B"LTEAPTE@8THQ$YFQ$ZC!!PTC0@JH1,TEAPTC"HHFQ$YFQ$^C!!PO@@( F!!$YFPHTE@8IFQ$YF 8TE@<@B"LTJ1$YC@$[EA<!!FQ$YFR,NC0@JHA(YFQ$YBA<T
C"HRFQ$YF 8O@@(#F1PTE@8MFQ$Y@ 8TEAPTE@<@H0DN@1$YFQ$YFQ$YFQ$YBA,TC0@JH1P*FQ$YFPH!!J!!$YFQ$YFRHO@@(#EAPTE@8TEAPTE@8TEAPTE@<@
H2LTG!!$YFQ$YFQ$YFQ$YD!!8TC0@#H1PTEAPNEAPTEAPNEAPTEAPO@@(AFQ$YC@8JC (NB PZFQ$YBP,@B"@NB (JABHYFQ$^B (JB (JC0@JH08NB 8DEB(Y
FQ$YHP8JB 8O@@( C (JB (NB 8_BQHYFQ$CB <@B"LLFQ$HF0(JB"HYFQ$ZA@(JC0@JE08JH LTA@(JB 8BFQ$YF (O@@(\CQ$YFQ$CA@(NABHRFQ$HC <@
B"@NB (JB HYFQ$CB (JB 8JC0@#HA,LFQ$YG!!<NE@$LFQ$YD0(O@@(#B!!,LFQ$YFQ$YFQ$YFQ$YF0,@B"@NB (JB (JB (JB (JB (JC0@#H@8DG!!8^G!!8^
G!!8^G!!8^A@(O@BL C (JB (JB (JB (JB (JB <@B"@HFQ$YC DDA@PD@RDYFQ$_AP@JH@PDA@PAH!!$YFQ(AA@PDA@PK@@(\A@PD@Q<LFQ$YD LD@PPDA@,@
B"@DAAPN@PPDA@D#@1$YFR(DB0@JH1$YFP0!!J"(*BA$YFP0*F (K@@(\A@8[A@DDA@PD@RHYFQ$!!@P,@B!!TCFQ$YC@PDA@PD@RDYFQHJB0@JH@PDA@D_FQ$Y
B@PDA@PDA@PK@BLUBQ$YFRDA@PPDH1,LFQ$HA@,@B!!0J@QPBFQ$YFQ$YBAHYFQHJB0@JH@PDA@PDA@PDA@PAA@PDA@PK@BL A@PDA@PDA@PDA@PDA@PDA@,@
H2@DA@PDA@PDA@PD@PPDA@PDB0@JERDYFQ$IH0DA@PDACA$YFP(K@@(U@PDA@RL_FQ$YF"L#@PDA@P,@B!!0A@RLIFQ$YFP0TH@DA@PDAB0@JG@DIFQH[H0DA
@RLNFQ$YB@DK@@(\D!!$YFQ$YFQ$YFQ$YFQ$YH T@B!!TNCA$ZH0DA@PD#EA$YFQ8AB0@JEQ,YFQ$)@PDA@PD#F!!$YD PK@@(U@PDAH2(YFQ$MH@DA@PDA@P,@
H1T^FQ$YG2LAA@DAH18YFQ$JB0@JG@D#H0DTCRD!!CQ,DCA$YJ DK@@(U@PDA@PDA@PDA@PDA@PDA@P,@H1TA@PDA@PDA@PDA@PDA@PDAB0@#EPDA@PDA@PDA
@PDA@PDA@PDK@@(OBQ$YFPH#H2L#HBHYFQ$BH0,@B!!TAH2L#HA,YFQ$SHBL#H2L#B0@JEPD G1$YFQ$^B!!0#H2L#H2LK@@(OB!!$YFP AHBL#HB,YFQ$B@PT@
B <"BA$YFQ$YFQ$YFQ$YFQ$TAP@JC2HYFQ$THBL#H10IFQ$YF"@K@@(UA@0YFP0AH2L#H2LBFQ$L@PT@B!!TAH2LNFQ$YFQ, H2L#H2L#B0@#C1(YFQ$"GBL#
H2L HQ$YFPPE@@(UH1P*D0D\H2L GBHYFQ$SH@,@B!!TAH2L#HBLA@PDAHBL#H2L#B0@#ERL#H2L#H2L#H2L#H2L#H2LE@BLUH2L#H2L#H2L#H2L#H2L#H0,@
B <DD!!$YFR,\GATJCA$YFPL\AP@JC2@ HB@\F1$YFQ( HB@ HB@E@@(OH@(RFQ$RJ2@ H2L#HB@ H@,@B <DD!!$YFQ(#HA0NCA$YFQ8 B0@JER@#EBH"H"H"
D1$YFRD[C"@K@@(OEA$YFPH#GA0\F1HYFQ$_G@T@B <\H!!$YFP4\GA0\CQ$YFQ8 B0@JC2L GB,YFQ$YAB@ HB@ H2@V@BLKBQ$YFPHAGB@\GBHYFQ$HH0,@
B <#BA$Y@ D$HA0ABA$YFQP AP@JC2@ HB@\H!!,[F2H HB@ HB@E@BLOHB@ HA0 GB@\GB@ HB@ H@,@H0< HB@ GB@\HA0\HB@ HB@ AP@JC1T_FQ$YFQ("
BP0YFQ$HH10K@@(OHB@ GA0NFQ$YD1T\HB@ H@T@B <\F!!$YFP0!!J"(*@  BBR@ AP@JC10CFQ$YFP ^HQ$YFQ$YEATE@@(OHA0\EQTUEP<[FQ$Y@0,\H@T@
B < J!!$YFP IBQ(YFQ$YG!!0\B0@JC2@ BA$YFQ8NC"DYFQ$YEATE@@(OHA0UCQ$YFP0#GB@ HB@ HB\@H0,DFQ$YFP "AAP^FQ$YFP$UAP@JC2@*FQ$YBA, 
E@HYFQ$MGA0K@@(OHB@ GA0NFQ$YD1T\HB@ H@T@H0< HB@\GB@ HB@ EQ0 HB@ AP@#C2@ HA0\HB@ HB@UGB@ HB@E@@(OGA0!!FQ$YFQ$YFQ$YD PUG@T@
B ,\GA0\EP(YFQ$MEQ0\GA0\AP@JB0DYFQ$YFQ$YFQ$YFQ$YH <E@@(OGB@BFQ$YFQ$YFQ$YFR,UG@T@B ,\GA0\GA0\EQ,YFQ$CC10\AP@JB1TDD!!$YFQ$Y
FQ$YFPH#EQ0E@@(OGATTFQ$YFQ$YFQ$YFPLUG@T@B ,\GATZFQ$Y@!!0\GA0\GA0\AP@#C1T_FQ$YFQ$YFQ$YFQ$!!HA0E@@(OEQPYFQ$YFQHYFQ$YBBLUG@T@
B ,\GA0\EP(YFQ$MEQ0\GA0\AP@#B10\GA0UGA0\GA0UGA0\GA0E@BLKGA0\GAT\GA0\GAT\GA0\G@T@B ,\ER@ZFQ$YFQ$YFP JC1TUAP@JB1TUEQTUH@0Y
FRHKEQTUEQTE@@(KEP4YFQ$YFQ$YFQ$YFQ$_C0T@B ,UC2LZD!!$YFQ$YFR(TC1TUAP@JB10UEQTUEQTO@Q$YFQPOEQTE@@(KG@<AG!!HYFQ$YFQHMH@<UEPT@
B ,UEP<T@!!$YFQ$YFP0_C1TUAP@JB1TUC2HYFQ$+C1TUEQTUEQTE@BLKEP<T@!!$YFQ$YFQ$R@1TUEPT@B ,UC1PHFQ$YFQ$YFR(AC1TUAP@JB1TUEQTUH@0Y
FRHKEQTUEQTE@BLKEQTUEQTUEQTUEP,UEQTUEPT@H0,UEQTUEQTUEQTUB1TUEQTUAP@JAQTOC0<DBP0YD!!8[G@,UEQTE@@(EEP<OC0<KAA(IEP<OC0<OC0T@
B ,OC0D[H"H"H"H"F1,_C!!0OAP@JAQTUC0<#F0LSBQ<DEP,UC1TE@@(KC1TOEQTUEQTKG00SC0<OEPT@B TUC0,OH1,ICPLTH@<OEQTUAP@JAQTUEP,UC 4)
BAL[H@,OEQTE@@(EEQTOC0LLBQTOC1TOEP<UC0T@H0,UC0,UAB,!!@ HMF2LKC0<UAP@JB1TOB10ND1HRD!!(NEP,UEQTE@@(EEP<OC0<KAA(IEP<OC0<OC0T@
H0TUC0<OC0<OC0<OC0<OC0<OAP@#AQTOC0<OC0<OC0<OC0<OC0<E@@(EC0<OC0,KER@\C0TOC0<OC0T@B TOC0<OC0<KB0,KC0<OC0<O@@@JAP<OB0TEAPTE
APTKAP,EC0<E@@(EC0<OC0,KAP,EAP,KC0<OC0@@B TOC0<OC0<OC0<KEP,OC0<O@@@JAP<OC0<KAPTKAQ KC0<OC0<@@@(EC0<OC1@KAQTQB0TKC0<OC0T@
B TOC0<OB1TKB0<OC0<OC0<O@@@#AP<OC0<KB0,UC0,EB0<OC0<E@@(EC0<OB0,KGB@\B0TOC0<OC0T@B TOC0<OC0<KB0,KC0<OC0<O@@@#AP<OC0<OB0,U
C0,OC0<OC0<E@BLEC0<OC0<KB1TOB0<OC0<OC0@@B @KB0,KB0,EAPTKB0,KB0,K@@@J@@,KB0,KB0,KJ@,KB0,KB0,@@@(@B0,KB0,KB0,KB0,KB0,KB0@@
B @KB0,KB0,KB0,KB0,KB0,K@@@J@@,KB0,KB0,KB0,KB0,KB0,@@@(@B0,KB0,KB0,KB0,KB0,KB0@@B @KB0,KB0,KB0TKB0,KB0,K@@@J@@,KB0,''E ,K
B0,KB0,KB0,@@BL@B0,KB0,KB0TKB0,KB0,KB0@@B @KB0,KB0,EAP,KB0,KB0,K@@@J@@,KB0,KB0,KJ@,KB0,KB0,@@BL@B0,KB0,KB0TKB0,KB0,KB0@@
H0@KB0,KB0,KAP,KB0,KB0,K@@@NEA<_F1<[G1<_G1<[G1<[G1<A@@8NG1,[F1,[F1,[F1,[F1,[G0D@C!!P_F1<[G1,_F1<[KA<[G1,_@P@NEA<[G1,_F1<[
G1,_F1<[G1<A@@8TG1,_F1,[F1,_F1,_F1<[G0D@C!!P_F1<[G1<[G1,_F1<[F1,_@P@NEA<[G14_F1<]G14_G1,_G1<A@@8TG1,[F1<[G1,_F1,[F1,[G0D@
@PPNC (NC (NC (NC 8JC 8NG@@NEA<_G1<[G1<_F1<[G1<[G1<A@@8NG1,[F1,[F1,[F1,[F1,[G0D@@PPNC (NC (NC (NC 8JC 8NG@@AA@8NB 8NB 8N
B 8NC (NC 8\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
') ; colorMapFromArray:#[0 0 0 66 66 66 206 206 206 140 140 140 74 74 74 8 8 8 49 49 57 123 115 115 214 214 214 148 148 148 82 82 82 16 16 16 222 222 222 156 156 156 90 90 90 24 24 24 22 22 22 25 25 25 231 231 231 165 165 165 99 99 99 33 33 33 8 16 8 57 49 57 8 8 16 239 239 239 173 173 173 107 107 107 41 41 41 109 109 109 181 181 181 115 115 115 49 49 49 189 189 189 123 123 123 57 57 57 41 33 33 173 165 165 33 33 41 16 8 16 16 16 8 197 197 197 198 198 198 132 132 132 115 107 107]; yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-widgets-tree'!

closeIndicatorInTree
    <resource: #programImage>

    ^ self closeIndicatorInTree9x9Icon

    "Created: / 19-12-2010 / 09:03:52 / cg"
!

collapsedIconInTree
    <resource: #programImage>

    ^ self fileTypeDirectoryIcon
!

emptyIconInTree
    <resource: #programImage>

    ^ self fileTypeFileIcon
!

expandedIconInTree
    <resource: #programImage>

    ^ self fileTypeDirectoryOpenIcon
!

openIndicatorInTree
    <resource: #programImage>

    ^ self openIndicatorInTree9x9Icon

    "Created: / 19-12-2010 / 09:04:06 / cg"
! !

!GenericToolbarIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GenericToolbarIconLibrary initialize!
