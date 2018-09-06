"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017-2018 Jan Vrany
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

ApplicationModel subclass:#Inspector2
	instanceVariableNames:'tabViewAspect navigationHistoryHolder navigationStateAspect
		browser currentObjectHolder colorProfileHolder
		toolbarBackgroundHolder evaluationLanguageHolder
		evaluationLanguageList operationsMenuEnabledHolder'
	classVariableNames:'LastExtent ColorProfiles EvaluationLanguageMap'
	poolDictionaries:''
	category:'Interface-Inspector2'
!

Model subclass:#NavigationState
	instanceVariableNames:'inspector theObject index tabs selectionIndex displayString'
	classVariableNames:'LastSelectionIndexMap'
	poolDictionaries:''
	privateIn:Inspector2
!

!Inspector2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017-2018 Jan Vrany
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
    an application for a multitab inspector
    extendable by the inspected object itself, by providing additional
    tabs via the inspector2XXX methods

    Interface for objects:
        redefine 
            inspectorExtraAttributes (to get additional pseudo-attributes into the left field list)
            inspectorExtraTabs (to get additional tabs into the tab list)
            inspectorExtraMenuOperations(to get additional operations menu items into the operations menu)
        
    the operations menu is invisible, if there are no operations.
    
    [author:]
        Jan Vrani
"
! !

!Inspector2 class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)


    ColorProfiles := Dictionary new.
    ColorProfiles 
        at: #default put: nil; "default color"
        at: #red put: Color red lighter lighter;
        at: #green put: Color green lighter;
        at: #blue put: Color blue lighter;
        at: #yellow put: Color yellow lighter;
        at: #gray put: Color gray.       

    EvaluationLanguageMap :=  Dictionary new.

    "Modified: / 25-05-2018 / 10:46:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2 class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::Inspector2    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#backwardInVisitingHistory
'Move backward in the history of previously visited objects'

#browseClassOfShownObject
'Open a SystemBrowser on the inspected object''s class'

#browseFile
'Open a FileBrowser on the file represented by the shown object'

#editImage
'Open an ImageEditor on the bitmap/image represented by the shown object'

#forwardInVisitingHistory
'Move forward in the history of previously visited objects'

#colorProfile
'Change the color profile'

#refresh
'Refresh for changed object'

)

    "Created: / 19-08-2011 / 08:52:33 / cg"
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::Inspector2    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#colorProfile
''

#evaluationLanguage
'Language used for evaluating expressions in code panes'

)
! !

!Inspector2 class methodsFor:'image specs'!

settingsIcon

    <resource: #image>

    ^self settingsIcon6

    "Modified: / 19-01-2012 / 14:00:35 / cg"
    "Modified: / 28-02-2012 / 21:59:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settingsIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self settingsIcon1 inspect
     ImageEditor openOnClass:self andSelector:#settingsIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::Inspector2 settingsIcon1'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
P$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IU@@@@@@@@@@@/B#FV''9>_%#DJUTIBP$HJ(ZF!!V1V@_*UO*RQ-FGIA
R2%N^DIBP$HJ_Z1:E32BEU$3(1PTEAPTEAQ''''4IBP$HJ)A%@+*9@PD@Y$&$T''I2\''I0IJ4IBP$I8Q%04 8NC 8L?]B)$L  HB@ PT4IBP$I8&6(SN#(:N#A7
WR\2B@ HB@ RT4IBP$JVT#\7M3\7M209"7&J"(*J"(*''W$IBP$JVUE]WU5]WU6D]^X*J"()+"((>_DIBP$JV"DUEQTUEQPE&K(*J"+A K(*ET4IBP$H+] 0L
C@2MH NMR"ZTI(]1ZGFXC$IBP$H+G8<5!!CU5*7T!!MT13SCV (CV Q4IBP$H+JJ-VAUZ+%IQV!!AX=E$$V\FU0J4IBP$H+[J.+F*.T%IRT$1,[F1,[F1-CJ4IB
P$HN+7-Q^5EQTUEPW9^W%9^W%9].C$IBP$HN(''-QTUEQTRVUX&I"X&I"X&HKC$IBP$I<#HZ*****''U"Y&Y&Y&Y&Y&Y@M_DIBP$I<V(Z****** HF#(:N#(:N
HBB^_DIBP$I<_8Z*******(Q#(:N#(8OC0R-_DIBP$JZ$ZZA*J ;X8$-RF=/G#X8A11D&$IBP$H#&)*Z&)*Z&)*Z&)*Z&)*Z&)*ZSTIBP$IBP$IBP$IBP$IB
P$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IB') ; colorMapFromArray:#[102 126 156 94 131 167 114 143 168 89 127 166 127 156 177 89 130 167 125 154 175 112 141 173 184 184 184 111 137 168 101 125 155 94 142 177 92 130 167 93 143 177 97 121 151 127 157 177 104 131 163 122 151 174 100 127 161 113 142 172 164 173 181 142 161 180 91 133 170 140 160 179 122 145 171 134 154 177 85 122 161 99 140 174 109 140 173 95 128 164 120 145 174 90 121 160 128 156 177 88 128 167 88 126 165 98 112 130 134 153 175 105 139 168 83 119 159 98 126 160 91 120 159 125 148 173 108 134 165 98 122 152 105 137 169 119 145 172 86 121 159 102 125 156 113 142 171 100 123 154 163 172 180 140 159 179 124 148 173 89 129 167 117 144 174 105 138 169 114 142 173 101 133 166 114 143 172 111 137 167 142 160 179 91 132 169 92 124 160 122 147 173 135 155 177 119 143 170 0 0 0 99 139 173 108 139 173 95 132 168 126 149 174 98 121 152 122 147 174 90 133 170 87 123 163 121 145 171 87 127 165 96 110 128 131 153 176 146 163 180 97 134 167 181 181 181 107 136 168 97 120 151 102 131 166 108 122 140 85 124 163 99 134 168 118 149 173 143 161 180 108 135 167 139 159 180 125 149 173 106 135 167 96 119 150 106 143 173 86 120 159 98 132 168 117 151 177 112 138 167 96 123 157 92 134 170 92 128 164 121 145 172 88 126 164 119 141 168 115 142 171 82 112 152 93 122 160 127 148 172 94 139 174 121 146 174 91 134 170 88 125 164 120 143 170 86 125 164 118 143 170 83 121 161 94 124 162 111 140 170 100 124 154 162 171 179 138 158 179 160 169 177 96 120 150 132 155 178 146 163 181 110 138 170 144 162 180 109 136 167 142 161 179 123 148 174 90 131 168 90 126 163 159 168 176 86 123 162 97 127 164 114 140 169 183 183 183 95 126 161 106 133 166 90 128 166 128 157 177 87 127 166 123 154 177 112 140 172 129 150 174 95 135 171 182 182 182 114 149 175 99 123 153 108 145 175 89 127 165 124 154 177 95 119 149 116 142 171 185 185 185 102 134 164 96 143 177 99 122 153 90 130 168 137 158 180 102 130 165 135 154 176 131 153 177 147 164 181 110 137 169 96 125 160 110 137 167 141 159 178 180 180 180 161 170 178 135 156 179 102 142 176 135 156 177 97 125 162 84 117 156]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<@@@@@@@@') ; yourself); yourself]
!

settingsIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self settingsIcon2 inspect
     ImageEditor openOnClass:self andSelector:#settingsIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::Inspector2 settingsIcon2'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!_UEQTUEQTUERLCGQVU%YVU''PLW7!!8^G L\''I2NQ@0VHEX"!!)USP4W
M253CG!!8^G L"4(AT!!$YDABJZ$MCP4MCP4M^U''!!8^G L\6)*T5M*Z&)*J5]CA XFA XHU''!!8^G LB24-O#8>O#9>E7(,OV=/[6=BO7!!8^G LC5%9 HB@ AFB
V L=[6=/[6<[O7!!8^G!!VBS,;N3,;N6I[]%5/[6=/[6<#AW!!8^G!!VJVM#X6M#X7-LWV=/[6=0[6<%O7!!8^G!!VB&1,[F1,[H5EA6=/[2\GA6=?O7!!8^G!!V!!FU%
YVVFC!!VFK)EH$R85C#TNO7!!8^G!!VGD9.]V8 E"A.[$^OQ695]V95OG!!8^G!!VAAY@Y4@VRD!!@]RP^IBP$[TQ-U''!!8^G!!VWAXVXAYHRD!!H_ALSD1LSD1L3U''!!8
^G ?J#YHM$!!HRD!!$ 4%IRT%IRT%KO7!!8^G ?D#YHRD!!HRC,1JB (JB (JB"EO7!!8^G ?TQ=1\WE1@&!!7]7]7]7]7]2>NO7!!8^G ?@A=1\WE1\REOGQ4]GQ4]
GQ5+O7!!8^G ?"Q=1\WE1\WD&GQ4]GQ5FQ$X2O7!!8^G"H$@!!)PTEAXQ!!&EG5=MH^@$E@8"G!!8^G :"H"H"H"H"H"H"H"H"H"H"H"HH''!!8^G!!8^G!!8^G!!8^G!!8
^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8') ; colorMapFromArray:#[139 152 168 154 164 174 136 152 167 134 148 165 130 145 164 133 144 160 220 220 220 128 145 164 140 153 169 138 153 169 133 148 167 148 159 172 135 147 162 145 156 170 129 148 167 143 156 170 156 165 175 141 156 170 136 150 167 134 155 172 146 158 172 129 148 168 165 170 174 144 156 170 142 155 169 156 165 174 152 161 172 135 148 165 130 145 165 149 163 173 130 151 169 164 169 173 126 145 165 142 156 169 133 140 149 133 147 165 130 151 170 131 147 165 146 160 172 127 143 163 143 160 173 136 150 168 133 147 166 149 160 172 133 146 163 147 159 171 128 146 166 146 162 173 157 166 175 142 159 172 136 156 173 134 154 171 145 157 172 129 147 167 165 169 173 145 157 170 139 154 171 154 164 175 134 141 150 137 154 169 134 145 161 166 171 175 146 159 172 133 145 160 127 147 166 140 153 168 137 150 166 209 214 218 131 152 170 131 149 167 148 163 173 128 148 167 218 218 218 139 157 172 152 163 174 132 154 172 132 149 167 146 157 170 128 148 168 147 162 172 139 155 171 138 151 168 155 165 174 152 163 173 136 148 163 148 159 171 134 146 161 144 155 169 158 166 175 142 156 170 138 152 168 135 151 168 131 146 165 166 170 174 145 157 171 139 146 155 127 146 165 141 154 168 137 153 169 134 152 169 133 152 168 131 150 168 144 157 171 129 150 168 144 159 171 139 153 168 152 162 173 133 156 173 132 151 169 130 152 170 129 149 168 219 219 219 126 141 161 217 217 217 153 164 175 150 161 173 135 146 162 130 150 169 132 148 165 147 162 173 85 85 85 141 156 171 139 152 167 134 151 169 132 152 170 145 158 172 146 158 171 130 148 166 142 156 171 158 167 175 140 155 170 138 156 171 132 147 166 132 156 173 130 149 168 143 157 172 132 144 159 140 154 170 155 164 174 151 162 174 136 147 163 132 150 168 131 156 173 128 147 167 141 155 171 126 144 164]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<@@@@@@@@') ; yourself); yourself]
!

settingsIcon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self settingsIcon3 inspect
     ImageEditor openOnClass:self andSelector:#settingsIcon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::Inspector2 settingsIcon3'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
V%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%(YS$9NS$9NS$:_Z4ZT&)*Z%DY+FU)ZV%)+[F1,M$TUTJL9Q1)$_%&L
[QXPQ%)ZV%)+Y),)Q8JBQW]GH51\WE1\WE2F&%)ZV%)+PQI@$IA@PD@RORI\@ HB@ I_[5)ZV%)FZAXOB@ HB@ ,\WL8"2X&I"X[''%)ZV%)F[)5"!!HRD!!C<]
D7JKI"X&I"XK''%)ZV%*T"T=OS4=OS3I IWAJR$)JR$)]@5)ZV%*TZ"@ HB@ HEES\D)JR$(>R$)U@5)ZV%*T"*B (JB (A=MN4)JR%!!BN4)^''%)ZV%)/]FM#
X6NQY8"Q @5TCR!!LK40N%5)ZV%)/QCE? W>\#Y0I_3E<LW<GA7<G!!5)ZV%)/)H58GG"MUEQ8 PD+@S(A^$%:[5)ZV%)/!!X6MKX5TUEQTEADQDQDQDQE!![5)Z
V%*WMU\7U3\7M3^CJ)VU%YVU%YT^%5)ZV%*WI5\7M3\7M4<JP4MCP4MCP4L0%5)ZV%(C&@ZS$9NSU)%[V5-[V5-[V6T<@5)ZV%(CM@ZS$9NS$4,E(*J"(*J"
%)Z!!@5)ZV%(CE0ZS$9NS$9L@(*J"(*H!!HRE9@5)ZV%*OZU==FA!!_ABPLK''U5T''ZD#$"R#5)ZV%(3#8>O#8>O#8>O#8>O#8>O#8>O^5)ZV%)ZV%)ZV%)ZV%)Z
V%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)Z') ; colorMapFromArray:#[139 210 255 54 187 255 255 255 255 72 156 255 113 188 255 149 215 255 207 233 255 52 182 255 142 201 255 47 179 255 118 210 255 85 168 255 134 197 255 23 159 255 49 176 255 145 201 255 161 208 255 78 198 255 169 209 255 99 181 255 66 190 255 191 224 255 147 202 255 109 186 255 108 187 255 81 160 255 170 209 255 95 176 255 50 184 255 112 195 255 63 199 255 65 181 255 78 185 255 151 218 255 133 191 255 172 210 255 118 189 255 69 171 255 255 253 253 89 173 255 37 163 255 180 215 255 96 204 255 56 186 255 141 200 255 32 164 255 139 200 255 43 177 255 62 207 255 42 178 255 96 192 255 55 142 255 104 182 255 73 162 255 181 221 255 255 244 244 69 162 255 193 226 255 52 189 255 33 161 255 61 211 255 156 204 255 16 137 255 116 197 255 171 212 255 161 213 255 33 158 255 127 212 255 51 158 255 188 224 255 85 163 255 183 221 255 108 190 255 57 190 255 255 250 250 116 200 255 43 169 255 60 177 255 90 167 255 96 195 255 195 223 255 77 178 255 135 196 255 70 173 255 254 248 248 60 165 255 91 187 255 209 234 255 25 154 255 135 193 255 0 0 0 145 216 255 220 240 255 73 166 255 55 170 255 110 185 255 83 180 255 78 197 255 114 193 255 59 180 255 152 202 255 143 215 255 165 217 255 45 170 255 149 203 255 113 189 255 88 175 255 88 166 255 177 215 255 137 197 255 123 194 255 79 161 255 215 237 255 131 195 255 81 167 255 103 180 255 66 165 255 138 197 255 126 196 255 190 220 255 33 167 255 87 201 255 54 190 255 46 142 255 38 176 255 107 185 255 139 197 255 50 181 255 42 164 255 52 185 255 188 219 255 73 188 255 119 194 255 63 160 255 139 196 255 79 158 255 50 171 255 101 182 255 75 167 255 218 239 255 132 195 255 213 236 255 114 190 255 69 156 255 171 218 255 57 177 255 105 187 255 255 242 242 80 162 255 102 206 255 154 218 255 76 162 255 100 177 255 131 210 255 80 159 255 173 212 255 20 163 255 120 192 255 76 159 255 90 164 255 69 185 255 67 205 255 154 221 255 197 224 255 55 155 255]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<@@@@@@@@') ; yourself); yourself]
!

settingsIcon4
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self settingsIcon4 inspect
     ImageEditor openOnClass:self andSelector:#settingsIcon4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::Inspector2 settingsIcon4'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4ZHB@ HB@ HB@VE3T^C0<OG#TWF!!4]GQ4WB0,KB"<S@B$$F3PPKATX
L!!PGMQ4]GQ4WHPX1F2</K2 [MCP,KB0,KB0,C14]GQ4WA08+J2,+J2,NI"\''I2\''G1<_D!!4]GQ45IQP-LC@0LC@0LB(*J"(#H2L#AA4]GQ45BP4LFQ$0LC@0
H"8.K"8HB@ HAA4]GQ4^L3L3L3L3L3L3L3L3L3L3L3L3@Q4]GQ4^L3L3L3L3L3L3L3L3L3L3L3L3@Q4]GQ4^L3L3L3L3L3L3L3L3L3L3L3L3AA4]GQ4RL3L3
L3L3L3L3L3L3L3L3L3L3@!!4]GQ4RL3L3L3L3L3L3L3L3L3L3L3L3@14]GQ4RL3L3L3L3L3L3L3L3L3L3L3L3D!!4]GQ4RL3L3L3L3L3L3L3L3L3L3L3L3D!!4]
GQ4BL3L3L3L3L3L3L3L3L3L3L3L3@!!4]GQ4BL3L3L3L3L3L3L3L3L3L3L3L3@!!4]GQ4AL3L3L3L3L3L3L3L3L3L3L3L3@Q4]GQ4AL3L3L3L3L3L3L3L3L3L3
L3L3@Q4]GQ4AL3L3L3L3L3L3L3L3L3L3L3L3@Q4]GQ4EL3L3L3L3L3L3L3L3L3L3L3L3AQ4]GQ4QAPTEAPTEAPTEAPTEAPTEAPTEGA4]GQ4]GQ4]GQ4]GQ4]
GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]GQ4]') ; colorMapFromArray:#[255 255 195 72 156 255 76 162 255 79 158 255 76 159 255 69 156 255 255 255 173 255 255 160 255 255 85 255 255 123 255 255 181 255 255 177 255 255 113 255 255 120 255 255 169 80 159 255 255 255 152 55 142 255 79 161 255 255 255 191 255 255 147 255 255 134 90 164 255 88 166 255 255 255 131 255 255 118 81 160 255 255 255 183 46 142 255 0 0 0 80 162 255 255 255 109 90 167 255 255 255 165 255 255 99 255 255 95 255 255 193 255 255 149 255 255 156 255 255 132 255 255 190 255 255 197 255 255 102 255 255 171 255 255 138 255 255 145 254 255 80 255 255 188 254 254 142 255 255 180 255 255 136 101 182 255 255 255 170 85 163 255]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<@@@@@@@@') ; yourself); yourself]
!

settingsIcon5

    <resource: #image>

    ^ GenericToolbarIconLibrary palette16x16Icon

    "Created: / 19-01-2012 / 14:00:24 / cg"
    "Modified: / 18-02-2012 / 16:28:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settingsIcon6
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self settingsIcon6 inspect
     ImageEditor openOnClass:self andSelector:#settingsIcon6
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::Inspector2 settingsIcon6'
        ifAbsentPut:[(Depth8Image new) width:25; height:25; bits:(ByteArray fromPackedString:'
(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:IWY&Y&Y&Y1(!!8*J"4*J#""JCX6M3X6PJJ"YG]7]7]7]:H$O#8>O#8>(#MBP$IBP$J"(FA5]WU5]WV G3(:N#(:
N*@+PTEAPTEA(I=X[7A/\F=/''1X1LSD1LSF_H34=OC0<OI>^T6-+Z6-+Z98QI2\''I2\''''!!,5MST5MSV^''T=''Y6]''Y6^]B2D!!HRD!!HY4TLC@0LB<0''Y1VX&I"
X&I"''@<XFA XFA"\FRX&I"X&I)2[&9.[&9.[&9.[&9.[&9.[&9.[&9.[&9.[&V9;^7-;^8NY_(2L#H2L&I$]KB0.KB09&Y!!8#8>O#8>O&H&!!(ZF!!(ZFXIS<?
O3<?O9"V](.K"8.K"9ZF''Y6]''Y6]%"@;N3,;N3.V%WRD!!XRD!!HRU_9&Y&Y&Y&YTWL#P2L#H2%YQ- HB@ HB@%G6U%YVU%YVTD"$)JR$)JYRSZW1<_G1<_IM9
$YFQ$YFQ$00"H"H"H"JS$WI:^''):^''*Q X:N#(:N#)DPF!!(ZF!!(Z$YBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBNTU=_W5=_Z(9FTEAPTEA]# \JB 4JB!!VN
#U-3\7M3\7NMSFU%YVU%YX4IGA0\GA0\#X)U[F1,[F1,"$%!!XVE!!XVFJA!!LSD1LSD8*IT&!!(ZF!!(ZH%GVU1YWE%Y"PPNC 8NC :I"D-#X6M#X6NHQEQTUEQT
UH BB@ HB@ H"H]HW%9^W%9^!!4MNS$9NS$:G@@TEAPTEAX^BSU)ZV%)ZV(IER$)JR$)J  DC@0LC@0NB (JB (JB (JB (JB (JB (JB (JB (JB  @a') ; colorMapFromArray:#[88 88 211 89 89 220 91 91 215 94 94 231 96 96 219 97 97 234 99 99 224 100 100 217 101 101 239 103 103 227 105 105 229 211 88 88 170 88 211 105 106 229 106 106 243 220 89 89 176 89 220 215 91 91 174 91 215 110 110 248 211 88 170 111 111 242 219 96 96 178 96 219 231 94 94 220 89 176 185 94 231 215 91 174 114 114 252 177 100 217 217 100 100 224 99 99 182 99 224 234 97 97 189 97 234 219 96 178 227 103 103 186 103 227 231 94 185 239 101 101 217 100 177 193 101 239 229 105 105 224 99 182 188 105 229 229 106 105 188 106 229 234 97 188 234 97 189 243 106 106 197 106 243 227 103 186 198 106 243 239 101 193 229 105 188 229 106 188 242 111 111 198 111 242 248 110 110 202 110 248 243 106 197 243 106 198 252 114 114 206 114 252 242 111 198 248 110 202 252 114 206 88 170 211 91 174 215 89 176 220 100 177 217 96 178 219 88 197 88 99 182 224 94 185 231 91 201 91 103 186 227 89 205 89 97 189 234 211 170 88 105 188 229 100 204 100 96 206 96 215 174 91 101 193 239 99 209 99 220 176 89 217 177 100 219 178 96 106 197 243 94 216 94 103 213 103 106 198 243 111 198 242 97 219 97 105 216 105 224 182 99 110 202 248 231 185 94 101 223 101 227 186 103 114 206 252 229 188 105 234 189 97 106 228 106 170 211 88 111 228 111 239 193 101 110 232 110 174 215 91 177 217 100 243 197 106 243 198 106 242 198 111 176 220 89 114 236 114 178 219 96 248 202 110 182 224 99 252 206 114 186 227 103 211 211 211 185 231 94 188 229 105 189 234 97 215 215 215 217 217 217 219 219 219 193 239 101 220 220 220 223 223 223 198 242 111 197 243 106 198 243 106 224 224 224 225 225 225 226 226 226 227 227 227 228 228 228 202 248 110 229 229 229 230 230 230 231 231 231 206 252 114 233 233 233 234 234 234 235 235 235 236 236 236 237 237 237 239 239 239 240 240 240 241 241 241 242 242 242 243 243 243 244 244 244 245 245 245 246 246 246 248 248 248 249 249 249 250 250 250 251 251 251 252 252 252 253 253 253 254 254 254]; yourself]
! !

!Inspector2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::Inspector2 andSelector:#windowSpec
     Tools::Inspector2 new openInterface:#windowSpec
     Tools::Inspector2 open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Inspector2'
         name: 'Inspector2'
         labelChannel: windowTitleAspect
         min: (Point 0 0)
         bounds: (Rectangle 0 0 490 654)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar'
             layout: (LayoutFrame 0 0 0 0 0 1 40 0)
             backgroundChannel: toolbarBackgroundHolder
             menu: toolbarMenu
             textDefault: true
           )
          (NoteBookViewSpec
             name: 'NoteBook'
             layout: (LayoutFrame 0 0 40 0 0 1 0 1)
             model: tabSelectionIndexAspect
             menu: tabLabelsAspect
             useIndex: true
             fitLastRow: false
             canvas: tabViewAspect
             keepCanvasAlive: true
           )
          (ComboListSpec
             name: 'EvaluationLanguageCombo'
             layout: (LayoutFrame -200 1 7 0.0 -40 1 32 0)
             activeHelpKey: evaluationLanguage
             visibilityChannel: evaluationLanguageComboVisibleHolder
             model: evaluationLanguageHolder
             comboList: evaluationLanguageList
             useIndex: false
             postBuildCallback: postBuildEvaluationLanguageCombo:
           )
          )
        
       )
     )
! !

!Inspector2 class methodsFor:'menu specs'!

fileMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::Inspector2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::Inspector2 mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
!

helpMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::Inspector2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::Inspector2 mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
              (
               (MenuItem
                  label: 'Inspector Documentation'
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
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::Inspector2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::Inspector2 mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenuChannel: fileMenu
          )
         (MenuItem
            label: 'View'
            submenuChannel: viewMenu
          )
         (MenuItem
            label: 'Operations'
            isVisible: operationsMenuEnabledHolder
            submenuChannel: operationsMenu
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            submenuChannel: helpMenu
          )
         )
        nil
        nil
      )
!

settingsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::Inspector2 andSelector:#settingsMenu
     (Menu new fromLiteralArrayEncoding:(Tools::Inspector2 settingsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Default'
            nameKey: Default
            hideMenuOnActivated: false
            choice: colorProfileHolder
            choiceValue: default
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Red'
            nameKey: Red
            hideMenuOnActivated: false
            choice: colorProfileHolder
            choiceValue: red
          )
         (MenuItem
            label: 'Green'
            nameKey: Green
            hideMenuOnActivated: false
            choice: colorProfileHolder
            choiceValue: green
          )
         (MenuItem
            label: 'Blue'
            nameKey: Blue
            hideMenuOnActivated: false
            choice: colorProfileHolder
            choiceValue: blue
          )
         (MenuItem
            label: 'Yellow'
            nameKey: Yellow
            hideMenuOnActivated: false
            choice: colorProfileHolder
            choiceValue: yellow
          )
         (MenuItem
            label: 'Gray'
            nameKey: Gray
            hideMenuOnActivated: false
            choice: colorProfileHolder
            choiceValue: gray
          )
         )
        nil
        nil
      )
!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::Inspector2 andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::Inspector2 toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: backwardInVisitingHistory
            enabled: backButtonEnabledHolder
            label: 'Back'
            itemValue: backButtonAction
            translateLabel: true
            isButton: true
            hideMenuOnActivated: false
            submenuChannel: backButtonMenuChannel
            labelImage: (ResourceRetriever ToolbarIconLibrary historyBackIcon)
          )
         (MenuItem
            activeHelpKey: forwardInVisitingHistory
            enabled: forwardButtonEnabledHolder
            label: 'Forward'
            itemValue: forwardButtonAction
            translateLabel: true
            isButton: true
            hideMenuOnActivated: false
            submenuChannel: forwardButtonMenuChannel
            labelImage: (ResourceRetriever ToolbarIconLibrary historyForwardIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: browseClassOfShownObject
            enabled: browseButtonEnabledHolder
            label: 'Browse'
            itemValue: browseClassAction
            translateLabel: true
            isButton: true
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary startNewSystemBrowserIcon)
          )
         (MenuItem
            activeHelpKey: browseFile
            label: 'Browse File'
            itemValue: browseFileAction
            translateLabel: true
            isButton: true
            isVisible: currentObjectIsFilename
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary startNewFileBrowserIcon)
          )
         (MenuItem
            activeHelpKey: editImage
            label: 'Edit the Image'
            itemValue: editImageAction
            translateLabel: true
            isButton: true
            isVisible: currentObjectIsImage
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary startImageEditorIcon)
          )
         (MenuItem
            activeHelpKey: refresh
            label: 'Refresh for Changed Object'
            itemValue: refreshTabs
            translateLabel: true
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadIcon)
          )
         (MenuItem
            activeHelpKey: colorProfile
            label: 'Settings'
            translateLabel: true
            isButton: true
            isVisible: false
            submenuChannel: settingsMenu
            labelImage: (ResourceRetriever #'Tools::Inspector2' settingsIcon)
          )
         )
        nil
        nil
      )
!

viewMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::Inspector2 andSelector:#viewMenu
     (Menu new fromLiteralArrayEncoding:(Tools::Inspector2 viewMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Expand Arrays in "all xxx"-Lists'
            itemValue: expandArraysInAllList:
            indication: expandArraysInAllList
          )
         (MenuItem
            label: 'Alphabetical'
            itemValue: showAlphabeticalHolderChanged
            indication: showAlphabeticalHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Color Setting'
            submenuChannel: settingsMenu
          )
         )
        nil
        nil
      )
! !

!Inspector2 class methodsFor:'startup'!

openOn: anObject

    ^ self new openOn: anObject.

    "Modified: / 17-02-2008 / 10:29:45 / janfrog"
    "Modified (format): / 11-07-2011 / 22:28:03 / cg"
!

openOn: anObject title:aString

    ^ self new 
        openOn: anObject;
        windowTitle:aString

    "
     self openOn:(Array new:3)
     self openOn:(Array new:3) title:'my array'
    "
! !

!Inspector2 class methodsFor:'testing'!

testSimpleShow
    |ins|

    ins := Inspector2 openOn:4.
    ins inspect:10.
    ins inspect:42.
    ins inspect:'dead one'.
    ins inspect:'rolled back'.
    
    "/ins inspectItem: (ins history at: 3).  "/ Rollback history, zustanou jen prvni 3
    
    ins inspect:'xFuj'.

    "Modified: / 11-01-2008 / 20:36:37 / janfrog"
! !

!Inspector2 methodsFor:'accessing'!

backButtonEnabled:value 
    ^ self backButtonEnabledHolder value:value

    "Created: / 12-01-2008 / 19:14:35 / janfrog"
    "Modified (format): / 19-08-2011 / 08:59:41 / cg"
!

currentObject
    ^ self navigationState theObject

    "Created: / 13-01-2008 / 10:14:47 / janfrog"
    "Modified: / 17-02-2008 / 09:49:01 / janfrog"
!

currentState
    ^ self navigationHistoryHolder currentItem

    "Created: / 21-02-2008 / 19:39:45 / janfrog"
    "Modified: / 27-02-2008 / 11:56:55 / janfrog"
!

forwardButtonEnabled:value 
    ^ self forwardButtonEnabledHolder value:value

    "Created: / 12-01-2008 / 19:14:48 / janfrog"
    "Modified (format): / 19-08-2011 / 08:59:45 / cg"
!

navigationState
    ^ self navigationHistoryHolder value currentItem

    "Created: / 17-02-2008 / 09:49:01 / janfrog"
    "Modified: / 21-02-2008 / 19:34:14 / janfrog"
    "Modified: / 22-07-2011 / 19:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

navigationState:historyItem 
    self navigationHistoryHolder "subjectChannel:" value currentItem:historyItem.

    "/self fixNavigation. "Nevola se kvuli problemu s prekreslovanim"
    "/self updateTabs.

    "Created: / 17-02-2008 / 09:49:11 / janfrog"
    "Modified: / 21-02-2008 / 19:47:26 / janfrog"
    "Modified: / 22-07-2011 / 19:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-08-2011 / 09:16:38 / cg"
! !

!Inspector2 methodsFor:'aspects'!

backButtonEnabledHolder
    "return/create the 'backButtonEnabledHolder' value holder (automatically generated)"

    ^(AspectAdaptor forAspect:#canGoBack)
        subjectChannel: self navigationHistoryHolder

    "Created: / 12-01-2008 / 19:13:49 / janfrog"
    "Modified: / 27-02-2008 / 12:11:30 / janfrog"
!

browseButtonEnabledHolder
    ^ BlockValue
        with:[:m | m notNil]
        argument:self navigationStateAspect

    "Created: / 19-08-2011 / 09:22:47 / cg"
!

colorProfileHolder
    "return/create the 'colorProfileHolder' value holder (automatically generated)"

    colorProfileHolder isNil ifTrue:[
        colorProfileHolder := ValueHolder with: #default.
    ].
    ^ colorProfileHolder

    "Modified: / 17-01-2012 / 12:54:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentObjectHolder
    currentObjectHolder isNil ifTrue:[
        currentObjectHolder := ValueHolder new.
        currentObjectHolder addDependent: self.
    ].
    ^ currentObjectHolder

    "Created: / 27-02-2008 / 12:05:22 / janfrog"
    "Created: / 19-08-2011 / 08:58:48 / cg"
    "Modified: / 26-10-2013 / 00:34:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentObjectIsFilename
    ^ BlockValue
        with:[:o | o isProtoObject not and:[o isFilename] ]
        argument:self currentObjectHolder

    "Created: / 19-08-2011 / 08:56:27 / cg"
!

currentObjectIsImage
    ^ BlockValue
        with:[:o | o isProtoObject not and:[o isImage] ]
        argument:self currentObjectHolder

    "Created: / 15-01-2012 / 10:06:28 / cg"
!

evaluationLanguageComboVisibleHolder
    <resource: #uiAspect>

    "/ Do not show language combo when language is Smalltalk.
    "/ For those not working with multiple languages is too disturbing.
    ^ BlockValue
        with:[:o | o class programmingLanguage notNil and:[o class programmingLanguage isSmalltalk not] ]
        argument:self currentObjectHolder

    "Modified (comment): / 25-10-2013 / 19:39:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluationLanguageHolder
    <resource: #uiAspect>

    evaluationLanguageHolder isNil ifTrue:[
        evaluationLanguageHolder := ValueHolder new.
       evaluationLanguageHolder addDependent:self.
    ].
    ^ evaluationLanguageHolder.

    "Modified: / 26-10-2013 / 00:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluationLanguageList
    <resource: #uiAspect>

    evaluationLanguageList isNil ifTrue:[
        evaluationLanguageList := ValueHolder new.
    ].
    ^ evaluationLanguageList.
!

expandArraysInAllList
    ^ InspectorView expandArraysInAllLists

    "Created: / 30-01-2012 / 16:52:46 / cg"
!

expandArraysInAllList:aBoolean
    InspectorView expandArraysInAllLists:aBoolean

    "Created: / 30-01-2012 / 16:53:15 / cg"
!

forwardButtonEnabledHolder
    "return/create the 'backButtonEnabledHolder' value holder (automatically generated)"

    ^(AspectAdaptor forAspect:#canGoForward)
        subjectChannel: self navigationHistoryHolder

    "Created: / 12-01-2008 / 19:13:49 / janfrog"
    "Modified: / 27-02-2008 / 12:11:26 / janfrog"
!

navigationHistoryHolder
    "return/create the 'currentItemHolder' value holder (automatically generated)"
    
    navigationHistoryHolder isNil ifTrue:[
        navigationHistoryHolder := Tools::NavigationHistory new.
    ].
    ^ navigationHistoryHolder

    "Created: / 21-02-2008 / 19:34:14 / janfrog"
!

navigationStateAspect
    navigationStateAspect isNil ifTrue:[
        navigationStateAspect := (AspectAdaptor forAspect:#currentItem) 
                    subjectChannel:self navigationHistoryHolder
    ].
    ^ navigationStateAspect

    "Created: / 27-02-2008 / 12:05:22 / janfrog"
    "Modified (format): / 19-08-2011 / 08:59:10 / cg"
!

operationsMenuEnabledHolder
    operationsMenuEnabledHolder isNil ifTrue:[
        operationsMenuEnabledHolder := false asValue.
    ].
    ^ operationsMenuEnabledHolder
!

showAlphabeticalHolder
      ^ builder booleanValueAspectFor:#showAlphabeticalHolder
!

sortOrderHolder
      ^ builder 
            valueAspectFor:#sortOrderHolder 
            initialValue:(InspectorView defaultSortOrder) 
!

tabLabelsAspect
    ^ (AspectAdaptor forAspect:#tabLabels) 
        subjectChannel:self navigationStateAspect

    "Created: / 16-01-2008 / 17:29:52 / janfrog"
    "Modified: / 27-02-2008 / 12:05:32 / janfrog"
    "Modified (format): / 19-08-2011 / 08:59:21 / cg"
!

tabSelectionIndexAspect
    ^ ((AspectAdaptor forAspect:#selectionIndex) 
        subjectChannel:self navigationStateAspect)
        onChangeEvaluate:[ self tabViewAspect changed ];
        yourself

    "Created: / 16-01-2008 / 17:29:29 / janfrog"
    "Modified: / 27-02-2008 / 12:06:05 / janfrog"
!

tabViewAspect
    tabViewAspect isNil ifTrue:[
        tabViewAspect := (AspectAdaptor forAspect:#selectionView) 
                    subjectChannel:self navigationStateAspect
    ].
    ^ tabViewAspect

    "Created: / 16-01-2008 / 17:30:05 / janfrog"
    "Modified: / 27-02-2008 / 12:05:46 / janfrog"
    "Modified (format): / 19-08-2011 / 08:59:35 / cg"
!

toolbarBackgroundHolder
    "return/create the 'toolbarBackgroundHolder' value holder (automatically generated)"

    toolbarBackgroundHolder isNil ifTrue:[
        toolbarBackgroundHolder := BlockValue
            with: [:profile| 
                | clr |    

                clr := ColorProfiles at: profile value.
                clr isNil ifTrue:[
                    clr := MenuPanel defaultBackgroundColor
                ].
                clr.            
            ] argument: self colorProfileHolder            
    ].
    ^ toolbarBackgroundHolder

    "Modified: / 17-01-2012 / 13:04:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2 methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == currentObjectHolder ifTrue:[
         self updateEvaluationLanguageList.
         self updateOperationsMenu.
         ^ self.
    ].
    changedObject == evaluationLanguageHolder  ifTrue:[
         self updateEvaluationLanguage.
         ^ self.
    ].  
    super update:something with:aParameter from:changedObject

    "Modified: / 26-10-2013 / 00:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateEvaluationLanguage
    | evaluationLanguage objectsLanguage lastLanguage |

    evaluationLanguage :=  self evaluationLanguageHolder value.
    "/ Remember user's selection for future...
    objectsLanguage := self currentObject class programmingLanguage.
    lastLanguage := EvaluationLanguageMap at: objectsLanguage ifAbsent: [ objectsLanguage ].
    lastLanguage ~~ evaluationLanguage ifTrue:[ 
        EvaluationLanguageMap at: objectsLanguage put: evaluationLanguage 
    ].
    "/ Update compiler class in all inspectors...
    self setDoItActionForLanguage: evaluationLanguage.

    "Created: / 26-10-2013 / 00:36:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2014 / 23:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateEvaluationLanguageList
    | currentObject currentObjectLanguage |

    currentObject := self currentObject.
    currentObjectLanguage := currentObject class programmingLanguage ? SmalltalkLanguage instance.
    currentObjectLanguage isSmalltalk ifTrue:[
        self evaluationLanguageList value: (Array with: currentObjectLanguage).
    ] ifFalse:[
        self evaluationLanguageList value: (Array with: currentObjectLanguage with: SmalltalkLanguage instance)
    ].

    self evaluationLanguageHolder value:(EvaluationLanguageMap at: currentObjectLanguage ifAbsent:[currentObjectLanguage])

    "Created: / 26-10-2013 / 00:40:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateOperationsMenu
    |items|

    currentObjectHolder value isProtoObject ifFalse:[
        items := currentObjectHolder value inspectorExtraMenuOperations.
    ].
    self operationsMenuEnabledHolder value:(items notEmptyOrNil).
! !

!Inspector2 methodsFor:'configuration'!

hideHashes:aBoolean
    "compatibiliy with InspectorView - must be implemented"

    #todo
!

hideMessages:aBoolean
    "compatibiliy with InspectorView - must be implemented"

    #todo
!

maxItemsInHistory:aNumber
    self navigationHistoryHolder value maxItemsInHistory:aNumber
!

suppressPseudoSlots:aBoolean
    "compatibiliy with InspectorView - must be implemented"

    #todo
! !


!Inspector2 methodsFor:'menu'!

backButtonMenuChannel
    ^ [ self navigationHistoryHolder goBackMenu ]

    "Created: / 12-01-2008 / 18:57:08 / janfrog"
    "Modified: / 22-02-2008 / 16:57:46 / janfrog"
!

forwardButtonMenuChannel
    ^ [ self navigationHistoryHolder goForwardMenu ]

    "Created: / 12-01-2008 / 18:57:30 / janfrog"
    "Modified: / 22-02-2008 / 16:58:11 / janfrog"
!

operationsMenu
    "return an inspected-object-specific operations menu"
    
    |items menu|
    
    items := currentObjectHolder value inspectorExtraMenuOperations.
    items isEmptyOrNil ifTrue:[^ nil].
    
    menu := Menu new.
    items do:[:eachPair |
        |xLatedLabel|

        "/ mhm - should the translation come from the inspected object's resources?
        xLatedLabel := resources string:eachPair first. 
        menu addItem:(MenuItem 
                        label:xLatedLabel
                        itemValue:eachPair second).
    ].
    ^ menu
!

settingsMenu
    |m|

    m := self class settingsMenu decodeAsLiteralArray.
    m itemsDo:[:eachItem |
        |lbl labelWithColor clr|

        lbl := resources string:eachItem label.
        (eachItem choiceValue ? #default) ~~ #default ifTrue:[
            clr := Color perform:eachItem choiceValue.
            labelWithColor := lbl asText backgroundColorizeAllWith:clr.
            clr brightness < 0.5 ifTrue:[
                labelWithColor := labelWithColor withColor:Color white.
            ].
            eachItem label:labelWithColor.
        ].
    ].
    ^ m
! !

!Inspector2 methodsFor:'menu actions'!

backButtonAction
    self navigationHistoryHolder goBack.
    self updateWindowLabel

    "Modified: / 21-02-2008 / 19:40:23 / janfrog"
    "Modified: / 15-07-2011 / 16:26:28 / cg"
!

browseClassAction
    "open a class browser, or try to add a tab to the previously opened class browser"

    | class |

    class := self currentObject class.

"/    browser notNil ifTrue:[
"/        "/ try to add a tab to the already opened browser
"/        (browser isKindOf:Tools::NewSystemBrowser) ifTrue:[
"/            browser spawnClassBrowserFor:(Array with:class) in:#newBuffer.
"/            "/ browser spawnSingleClassBrowserFor:class in:#newBuffer.
"/            browser window raise.
"/            ^ self.
"/        ].
"/    ].

    "/ if that fails, open a new one
    UserPreferences systemBrowserClass 
                    openInClass:class selector:nil "/ browseSingleClass: class

    "Modified: / 23-07-2011 / 11:28:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2013 / 15:36:51 / cg"
!

browseFileAction
    "open a filebrowser on the file represented by the current object"

    | fn |

    fn := self currentObject asFilename.
    UserPreferences fileBrowserClass openOn:fn

    "Created: / 19-08-2011 / 09:29:44 / cg"
!

changeColorAction: color

    self toolbarBackgroundHolder value: (Color perform: color asSymbol)

    "Created: / 17-01-2012 / 01:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editImageAction
    "open an imageEditor on the current object"

    | img |

    img := self currentObject.
    ImageEditor openOnImage:img.

    "Created: / 15-01-2012 / 10:08:29 / cg"
!

forwardButtonAction
    self navigationHistoryHolder goForward.
    self updateWindowLabel

    "Created: / 21-02-2008 / 19:52:03 / janfrog"
    "Modified: / 15-07-2011 / 16:26:33 / cg"
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#INSPECTOR'.
!

refreshTabs
    self navigationHistoryHolder currentItem refreshTabs.
    self tabViewAspect changed.

"/    sel := selectionIndex.
"/    self selectionIndex:nil.
"/    self selectionIndex:sel.

    "Created: / 21-08-2011 / 08:23:00 / cg"
!

showAlphabeticalHolderChanged
    self navigationHistoryHolder currentItem tabViews do:[:each |
        (each isKindOf:InspectorView) ifTrue:[
            each showAlphabetical:(self showAlphabeticalHolder value)
        ]
    ].
! !

!Inspector2 methodsFor:'opening'!

closeDownViews
    LastExtent := self window extent.
    super closeDownViews.

    "Created: / 11-07-2011 / 22:33:47 / cg"
!

inspect:anObject 
    | objectsLanguage |

    self navigationHistoryHolder currentItem:(self navigationStateFor: anObject).
    self window notNil ifTrue:[
        self updateWindowLabel
    ].
    objectsLanguage := anObject class programmingLanguage.
    self evaluationLanguageHolder value:(EvaluationLanguageMap at: objectsLanguage ifAbsent: [ objectsLanguage ]).
    "/ Must force update - it can happen that language doesn't change (value is the same)
    "/ but inspectors are new and thus would use default language for evaluation.
    self updateEvaluationLanguage.

    "Modified: / 27-02-2008 / 12:06:52 / janfrog"
    "Modified: / 15-07-2011 / 16:26:03 / cg"
    "Modified (format): / 19-08-2011 / 09:01:20 / cg"
    "Modified: / 04-02-2015 / 15:27:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openOn: anObject
    self createBuilder.
    self inspect: anObject.    
    self openWithExtent:LastExtent.

    "Modified: / 13-01-2008 / 13:55:27 / janfrog"
    "Modified: / 11-07-2011 / 22:31:42 / cg"
!

postBuildEvaluationLanguageCombo: aComboBoxView
"/    aComboBoxView font: (aComboBoxView font asSize: (aComboBoxView font size * 1.5) rounded)

    "Modified: / 26-10-2013 / 01:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    self updateWindowLabel.

    "Created: / 15-07-2011 / 16:25:36 / cg"
    "Modified: / 12-08-2014 / 20:01:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateWindowLabel
    "not only the label is updated; 
     also the current inspected object is fetched from the navigation state"

    |currentItem object windowLabel |

    (currentItem := self navigationHistoryHolder currentItem) notNil ifTrue:[
        object := currentItem theObject.
    ].
    self currentObjectHolder value:object.
    windowLabel := InspectorView commonLabelFor:object.
    "/ Contract window label if too long...
    (windowLabel includes: Character cr) ifTrue:[ 
        windowLabel := windowLabel upTo: Character cr.
    ].
    windowLabel size > 200 ifTrue:[
        windowLabel := (windowLabel contractAtEndTo: 200) , '...'
    ].
    self window label: windowLabel

    "Created: / 15-07-2011 / 16:25:42 / cg"
    "Modified: / 28-07-2015 / 05:49:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2 methodsFor:'private'!

navigationStateFor: anObject
    | current new |

    new := NavigationState for: anObject.
    new inspector:self.
    current := self currentState.
    (current notNil "and:[anObject isKindOf: current theObject class]") ifTrue:[ 
        | currentTabLabel newSelectionIndex |

        currentTabLabel := current tabLabels at: current selectionIndex.
        newSelectionIndex := new tabLabels indexOf: currentTabLabel.
        newSelectionIndex ~~ 0 ifTrue:[ 
            new selectionIndex: newSelectionIndex.
        ].
        new tabViews do:[:each |
            (each isKindOf:InspectorView) ifTrue:[
                each showAlphabetical:(self showAlphabeticalHolder value)
            ]
        ].
    ].
    ^ new

    "Created: / 04-02-2015 / 15:27:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2017 / 09:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setDoItActionForLanguage: language
    self currentState tabViews do:[:view | 
        (view respondsTo: #workspace) ifTrue:[
            view workspace 
                editedLanguage: language;
                doItAction: 
                    [:theCode |
                        |evaluator|

                        (evaluator := language evaluatorClass) notNil ifTrue:[
                            evaluator
                                evaluate:theCode in:nil 
                                receiver:self currentObject 
                                notifying:view workspace 
                                logged:true ifFail:nil
                        ] ifFalse:[
                            'object''s class provides no evaluator'
                        ]
                    ].
        ].
    ]

    "Created: / 26-10-2013 / 01:13:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-03-2015 / 09:46:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2::NavigationState class methodsFor:'creating classes'!

for:anObject 
    |item|

    item := self new.
    item theObject:anObject.
    ^ item.

    "Modified (format): / 19-08-2011 / 09:24:40 / cg"
! !

!Inspector2::NavigationState class methodsFor:'documentation'!

version
    ^'$Header$'
!

version_SVN
    ^'$Id$'
! !

!Inspector2::NavigationState class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    LastSelectionIndexMap := WeakIdentityDictionary new.

    "Modified: / 25-05-2018 / 10:48:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2::NavigationState methodsFor:'accessing'!

application:anInspectorApp
    <resource: #obsolete>
    inspector := anInspectorApp.
!

index
    ^ index
!

index:something
    index := something.
!

inspector
    ^ inspector

    "Created: / 09-02-2017 / 09:27:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector:anInspectorApp
    inspector := anInspectorApp.

    "Created: / 09-02-2017 / 09:27:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionIndex
    selectionIndex isNil ifTrue:[^1].
    selectionIndex < 1 ifTrue:[^1].
    selectionIndex > tabs size ifTrue:[^tabs size].
    ^selectionIndex

    "Created: / 16-01-2008 / 17:24:27 / janfrog"
    "Modified: / 17-02-2008 / 10:20:35 / janfrog"
    "Modified: / 18-11-2011 / 15:00:01 / cg"
!

selectionIndex: anInteger
    selectionIndex := anInteger.
    LastSelectionIndexMap at: theObject class put: anInteger.
    self changed:#selectionIndex

    "Created: / 16-01-2008 / 17:27:52 / janfrog"
    "Modified: / 17-02-2008 / 09:46:45 / janfrog"
    "Modified: / 25-05-2018 / 10:49:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionView

    |tab|

    tab := self tabs at:self selectionIndex ifAbsent:nil.
    ^ tab isNil ifTrue:[nil] ifFalse:[tab view].

    "Created: / 16-01-2008 / 17:31:19 / janfrog"
!

tabLabels

    ^self tabs collect:[:tab | tab label]

    "Created: / 16-01-2008 / 17:14:07 / janfrog"
!

tabViews

    ^self tabs collect:[:tab | tab viewOrNil]

    "Created: / 16-01-2008 / 17:14:13 / janfrog"
    "Modified: / 24-03-2014 / 18:23:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tabs

    tabs isNil ifTrue:[self initializeTabs].
    ^tabs

    "Created: / 16-01-2008 / 16:51:53 / janfrog"
    "Modified: / 18-11-2011 / 15:00:05 / cg"
!

theObject
    ^ theObject
!

theObject:anObject
    theObject := anObject.
    selectionIndex := LastSelectionIndexMap at: theObject class ifAbsent: nil.
    self changed

    "Modified: / 17-02-2008 / 08:38:44 / janfrog"
    "Modified: / 19-08-2011 / 09:16:25 / cg"
    "Modified: / 25-05-2018 / 10:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2::NavigationState methodsFor:'comparing'!

= anotherState

    ^self class == anotherState class 
        and:[self theObject == anotherState theObject]

    "Created: / 21-02-2008 / 19:39:01 / janfrog"
!

hash

    ^theObject hash

    "Created: / 21-02-2008 / 19:38:08 / janfrog"
! !

!Inspector2::NavigationState methodsFor:'initialization'!

initializeTab: selector
    "Initializes an extra tab specified by given selector"

    | tab |

    [
        (selector == #inspector2TabForBasicInspect and:[theObject isProtoObject]) ifTrue:[
            "kludge for ProtoObject, which does neither implement this selector
             nor #perform:"
            tab := Tools::Inspector2Tab new
            		inspector: inspector;
                        priority: 90;
                        label:'Basic';
                        view: (InspectorView new inspect:theObject);
                        yourself
        ] ifFalse:[
            tab := theObject perform:selector.
        ].
    ] on: Error do:[:ex|
        "/ for debugging:  
        "/ ex reject.
        Logger error:'inspector setup: %1' with:ex description.    
        tab := Tools::Inspector2Tab new
            inspector: inspector;
            label:selector;
            text:(ex description, Character cr, Character cr,
                  ex suspendedContext fullPrintAllString)
    ].

    (tab isKindOf:Tools::Inspector2Tab) ifTrue:[
        tabs add: tab.
        tab inspector: inspector.            
    ]

    "Created: / 03-02-2015 / 11:03:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeTabs
    | selectors |

    tabs := OrderedCollection new.        

    "/ Old style - tabs are specified by method #inspector2Tabs
    (theObject isProtoObject or:[theObject isNil or:[theObject isStructure]]) ifTrue:[
        "kludge for ProtoObject and Structure, which does not implement this selector
         nor #perform: -- see #initializeTab:"
        selectors := #(inspector2TabForBasicInspect).
    ] ifFalse:[
        selectors := theObject inspector2Tabs.
    ].
    selectors := selectors asSet.

    "/ New style - tab are defined by methods with <inspector2Tab> annotation
    theObject class withAllSuperclassesDo:[:eachClass| 
        eachClass selectorsAndMethodsDo:[:eachSelector :method |
            (selectors includes: eachSelector) ifFalse:[
                (method hasAnnotation: #inspector2Tab) ifTrue:[ 
                    selectors add: eachSelector.
                ].
            ].
        ].
    ].

    selectors do:[:eachSelector| self initializeTab: eachSelector ].

    tabs := tabs sort:[:a :b| a priority > b priority].

    "Created: / 16-01-2008 / 16:54:28 / janfrog"
    "Modified: / 17-02-2008 / 10:08:04 / janfrog"
    "Modified: / 03-02-2015 / 11:06:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

refreshTabs
    self initializeTabs.

    "Created: / 21-08-2011 / 08:23:11 / cg"
! !

!Inspector2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_CVS_jvrany
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


Inspector2 initialize!
Inspector2::NavigationState initialize!
