"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

Object subclass:#VDBIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Support'
!

!VDBIconLibrary class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBIconLibrary class methodsFor:'initialization'!

initialize

    MenuEditor addNewImageRetriever:self name

    "
        self initialize 
    "

    "Created: / 02-07-2008 / 11:55:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!VDBIconLibrary class methodsFor:'icons-16x16-actions'!

actionContinue16x16
    <resource: #image>
    ^ self resume_co

    "Created: / 22-09-2014 / 22:20:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionRestart6x16
    <resource: #image>
    ^ self restart_co

    "Created: / 22-09-2014 / 22:22:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionRun16x16
    <resource: #image>
    "      Loaded from: /home/jv/work/debug-icons/14089.start_task.gif"
    "
     self i14089_start_task inspect
     ImageEditor openOnClass:self andSelector:#i14089_start_task
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'VDBIconLibrary i14089_start_task'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                bits:(ByteArray 
                            fromPackedString:'
J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+EAPSJ2,+J2,+J2,+J2,+J1P*J!!TRJ2,+J2,+J2,+J2,RJB (JQDQ
J2,+J2,+J2,+DBT%IRT$I@8OJ2,+J2,+J00 HB@ HRD!!G04MJ2,+J2,KE1\WE1\WFQXVF@(+J2,+AQ(ZF!!([F10[BP$+J2,+J0\]GQ4]G!!8FBB,+J2,+J2,C
H2H"H0PDJ2,+J2,+J2,+@R\&@PH+J2,+J2,+J2,+J0@@@B,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 22 107 69 24 109 70 25 110 71 27 111 72 28 112 73 34 118 80 31 115 75 31 114 75 32 114 75 34 118 78 37 120 81 39 122 82 42 125 86 41 122 83 44 126 86 44 127 86 46 128 87 47 128 87 50 131 90 51 132 92 52 132 92 50 131 89 87 171 114 88 171 113 88 171 114 88 170 113 77 167 102 77 167 101 77 166 101 97 175 97 97 176 96 131 190 129 131 189 128 131 189 129 109 181 95 109 181 94 147 197 135 147 197 134 120 186 94 121 186 93 162 203 139 163 203 138 172 207 142 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@G@@_@A?@G?@_?A?>G?0_<A?@G0@\@@@@@@@b');
                            yourself);
                yourself
        ]

    "Created: / 22-09-2014 / 22:20:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionStepInto6x16
    <resource: #image>
    ^ self stepinto_co

    "Created: / 22-09-2014 / 22:22:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionStepOver6x16
    <resource: #image>
    ^ self stepover_co

    "Created: / 22-09-2014 / 22:21:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionStepReturn6x16
    <resource: #image>
    ^ self stepreturn_co

    "Created: / 22-09-2014 / 22:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionStop16x16
    <resource: #image>
    ^ self suspend_co

    "Created: / 22-09-2014 / 22:21:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionTerminate6x16
    <resource: #image>
    ^ self terminate_co

    "Created: / 22-09-2014 / 22:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionTerminateAndRun6x16
"      Loaded from: /home/jv/work/debug-icons/18776.term_restart.gif"

    "
     self i18776_term_restart inspect
     ImageEditor openOnClass:self andSelector:#i18776_term_restart
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary i18776_term_restart'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<:K#@/K2<0K#(?O3<?O3<?L#,8NS$9NC,2O3<?O3<?O3LKA \GA0XKL3<?O3<?O3<5CA@QDQDPCCX?O3<?O3<?O@(NC0<OC $4O3<?O3<?O0 REATUEPTJ
M3<?O3<?O3<[@@PEAPTM@3D?O3<?O3<?E#4A@ HBO!!4]G#<?O3<?O10WFQ XF!!L]KQ4"G3<?O3<?O3<?O3<?GR0,J14!!O3<?O3<?O3<?O14%I2P$I!!4?O3<?
O3<?O3<]JB$(GRL?O3<?O3<?O3<?GR(]HA<?O3<?O3<?O3<?O14]G#<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[230 109 110 247 136 138 246 139 141 243 187 188 231 34 43 230 42 50 231 58 64 230 67 72 199 70 74 239 98 103 240 99 103 232 132 135 221 127 131 242 144 148 231 40 50 232 47 56 234 58 67 232 66 74 242 84 93 233 170 174 231 28 43 232 35 49 199 42 55 204 46 58 204 52 65 203 53 65 218 109 117 203 55 69 207 81 96 31 132 78 194 222 207 199 224 211 61 150 100 68 154 105 86 166 120 115 179 143 87 171 114 88 171 113 88 171 114 88 170 113 77 167 101 77 166 101 97 176 96 131 190 129 131 189 129 147 197 135 209 105 90 210 111 97 210 112 97 238 195 189 210 98 84 206 95 85 206 81 74 203 87 79 202 87 79 211 99 92 244 146 140 245 149 143 213 137 132 254 176 172 195 76 74 244 173 172 251 201 201 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?8C? O>@?8C? O>@?<C?<@G8@_0A>@G0@\@@@@@@b') ; yourself); yourself]

    "Created: / 22-09-2014 / 22:25:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBIconLibrary class methodsFor:'icons-16x16-objects'!

frameRunning16x16
    ^ self stckframe_running_obj

    "Created: / 22-09-2014 / 22:04:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

frameStopped16x16
    ^ self stckframe_obj

    "Created: / 22-09-2014 / 22:05:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadGroupRunning16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self threadGroupRunning16x16 inspect
     ImageEditor openOnClass:self andSelector:#threadGroupRunning16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary threadGroupRunning16x16'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I"TEB0XFC@\GA0\GA0\G@BXQDP8OD!!@SEB (JB (J@\&APTKA XLA0\JB \GA0\GI"HVE!!XVE!!XVE!!XVE!!XVH"X"E!!\WE1\WE1\WE1\WE2H&H!!X''I2\''I2\''
I2\''E1\"I"LVJ"(+E1\WE1\WE1\WH2X]E"(.J"0+I2\''I2\WE14&HAX*K"8.J"4WFA\WE1 _I!!,VJ"</K2</J!! XFA XF2X\E"(/K2<*LQ XFA XFA0&GAX*
LB(,J1 XFA XFA $I!!8VJ"(+FA XFA XFA XG"XZE"T%IRT%IRT%IRT%IQ$&HRD!!HRD!!HRD!!HRD!!HRD!!I"X&I"X&I"X&I"X&I"X&I @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[136 152 192 144 160 192 152 168 200 160 176 200 168 184 208 40 80 136 48 88 144 56 96 152 64 104 160 136 160 192 64 104 152 40 88 144 48 96 144 160 184 208 80 152 208 88 160 216 104 168 216 72 152 208 96 168 216 120 176 216 128 184 224 144 192 224 208 240 248 232 248 248 240 248 248 97 95 61 97 95 65 120 108 54 113 102 58 135 114 50 105 95 61 128 108 50 128 108 54 97 89 65 150 121 47 143 114 47 113 95 58 255 255 255 255 255 255 232 248 248 144 192 224 56 96 152 31 132 78 194 222 207 86 166 120 68 154 105 147 197 135 88 171 113 97 176 96 115 179 143]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?9??7??_?=??7??_?=??7??_?=??7??_?=??7??@@@b') ; yourself); yourself]
!

threadGroupStopped16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self threadGroupStopped16x16 inspect
     ImageEditor openOnClass:self andSelector:#threadGroupStopped16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary threadGroupStopped16x16'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I"TEB0XFC@\GA0\GA0\G@BXQDP8OD!!@SEB (JB (J@\&APTKA XLA0\JB \GA0\GI"HVE!!XVE!!XVE!!XVE!!XVH"X"E!!\WE1\WE1\WE1\WE2H&H!!X''I2\''I2\''
I2\''E1\"I"LVE1\WE1\WE1\WE1\WH2X]E!!\''I2\''I2\''I2\WE14&HAXXI1\WFA\WFA\WE1 _I!!,VFB\''I2\''I1 XFA XF2X\E!! XFA XFA XFA XFA0&GAXX
FA XFA XFA XFA $I!!8VFA XFA XFA XFA XG"XZE"T%IRT%IRT%IRT%IQ$&HRD!!HRD!!HRD!!HRD!!HRD!!I"X&I"X&I"X&I"X&I"X&I @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[136 152 192 144 160 192 152 168 200 160 176 200 168 184 208 40 80 136 48 88 144 56 96 152 64 104 160 136 160 192 64 104 152 40 88 144 48 96 144 160 184 208 80 152 208 88 160 216 104 168 216 72 152 208 96 168 216 120 176 216 128 184 224 144 192 224 208 240 248 232 248 248 240 248 248 97 95 61 97 95 65 120 108 54 113 102 58 135 114 50 105 95 61 128 108 50 128 108 54 97 89 65 150 121 47 143 114 47 113 95 58 255 255 255 255 255 255 232 248 248 144 192 224]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?9??7??_?=??7??_?=??7??_?=??7??_?=??7??@@@b') ; yourself); yourself]
!

threadGroupTerminated16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self threadGroupTerminated16x16 inspect
     ImageEditor openOnClass:self andSelector:#threadGroupTerminated16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary threadGroupTerminated16x16'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@A@ LCA@TEAPTEAPTEA @GA0 IA (KC@4MCP4MCPT@@PDB@0LDAPTNC TEAPTE@@<PDA@PDA@PDA@PDA@PC0@ODADQDQDQDQDQDQDQDP<@C1@QDQDQDQDQ
DQDQDQDO@AHPDQDQDQDQDQDQDQDQD @SDADQDQDQDQDQDQDQDQL@EA@UDQDQEQDQEQDQDQTV@A\PEQDQDQDQDQTUEQTUE0@XDATUEQTUEQTUEQTUEQ @FA@U
EQTUEQTUEQTUEQTY@A(PEQTUEQTUEQTUEQTUF @[D@@@@@@@@@@@@@@@@A0@GQ4]GQ4]GQ4]GQ4]GQ4]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 73 73 73 79 79 79 81 81 81 86 86 86 89 89 89 151 151 151 133 133 133 136 136 136 144 144 144 153 153 153 163 163 163 171 171 171 180 180 180 96 96 96 122 122 122 231 231 231 243 243 243 116 116 116 113 113 113 108 108 108 245 245 245 108 108 108 106 106 106 100 100 100 96 96 96 94 94 94 92 92 92 92 92 92 89 89 89]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?9??7??_?=??7??_?=??7??_?=??7??_?=??7??@@@b') ; yourself); yourself]
!

threadRunning16x16
    ^ self thread_obj

    "Created: / 22-09-2014 / 21:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadStopped16x16
    ^ self threads_obj

    "Created: / 22-09-2014 / 21:59:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadTerminated16x16
    ^ self threadt_obj

    "Created: / 22-09-2014 / 21:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBIconLibrary class methodsFor:'icons-eclipse.platform.debug-cview16'!

console_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/cview16/console_view.gif"

    "
     self console_view inspect
     ImageEditor openOnClass:self andSelector:#console_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary console_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
S$9NS$9NS$9NS$9NS$9NS$9NI3@0LC@0LC@0LC@0I49NS#DKB0,KB0,KB0,KB3ENS$82CD5MST5MST5MSP02S$9NL1MMSBDAHT,MHP4NMD9NS#XOSP(IA PB
K4$@C3UNS$87DD4.K$(.K"8.F!!@8S$9NNQQMB (HA0TC@!!$UN$9NS#,[SQ  HA XHA -E#1NS$8=JD4,DQ<^DQHQG!!\>S$9NO2$)GR$\J"$+RB$)H$9NS"YB
P$EBP$E@P"MBPRYNS$9NS$9NI"QCQBYNS$9NS$9NS"YFQ4YGQ2UEIRT&S$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[243 245 251 247 248 251 58 78 129 65 86 136 67 88 139 74 96 146 80 102 152 86 109 158 96 119 168 93 117 166 102 127 175 84 100 131 87 103 134 246 248 252 91 107 137 95 111 140 100 116 144 225 233 248 225 233 247 90 107 136 105 122 149 105 121 148 110 126 152 115 131 156 229 236 248 233 239 249 237 242 250 110 127 152 119 135 159 119 135 158 225 234 248 225 234 247 228 236 248 246 248 251 43 92 156 43 90 151 43 88 147 43 87 144 70 115 173 90 127 175 114 131 155 118 135 159 119 136 159 118 135 158 224 234 247 229 237 248 238 243 250 243 246 250 41 111 196 41 110 194 41 108 190 41 107 186 42 106 186 41 104 181 42 104 181 41 102 176 42 102 177 42 99 172 42 100 171 42 97 166 43 97 166 42 95 161 43 95 161 43 92 155 42 90 151 42 91 151 43 91 151 42 88 147 42 89 147 42 87 144 43 88 144 43 87 143 118 136 159 242 246 251 237 243 250 246 249 252 246 249 251 207 237 251 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@??#?>O?8??#?>O?8??#?>O?8??#?>@>@_?@@@@@@b') ; yourself); yourself]
! !

!VDBIconLibrary class methodsFor:'icons-eclipse.platform.debug-dtool16'!

debug_exc
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/dtool16/debug_exc.gif"

    "
     self debug_exc inspect
     ImageEditor openOnClass:self andSelector:#debug_exc
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debug_exc'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G1<_G1<_G1<_G1<_G1<_G1<_G1<_GQ<_G1<_G1<_G1<_G1<_G14_G1<]G1<_G1<_G1<_G14KGQ<_GQ<_G1<_G1<]GQ4GB@ ]GQ4_G1<_G1<_G1<]BP8[BP$]
G14]G1<_G1<_G14ZCA0RF!!4^G!!4]G1<]GQ<]A!!0NGA$SA!!4_G1<_G1<]B LRGAT[EAX]G1<_G1<_G14DF!!$[DA WAA4]G1<_G1<]G TSEA ODPT]G14_G1<_
GQ4]@QXWDP4]G1<_G1<_GQ<_G14B@A4]G1<_G1<_G1<_G1<]GQ4_G1<_G1<_G1<_G1<_GQ<_G1<_G1<_G1<_G1<_GQ<_G1<_G1<_G0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[146 158 152 149 161 154 146 158 151 157 169 162 154 166 159 151 163 156 159 171 164 142 147 144 167 178 171 165 176 169 141 145 142 144 148 145 149 158 146 156 165 153 241 243 240 168 175 164 182 188 178 195 201 191 229 232 227 212 216 209 210 214 207 204 209 200 202 207 198 200 205 196 207 211 203 223 226 220 221 224 218 220 223 217 234 236 232 194 193 193 208 208 208 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@D@@Q@C$A?0A?XC?9/>A?8C?8O?P?8D_@A0@D@@ @b') ; yourself); yourself]
!

environment_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/dtool16/environment_co.gif"

    "
     self environment_co inspect
     ImageEditor openOnClass:self andSelector:#environment_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary environment_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
PDA@PDA@PDA@PDA@PDA@PD@>O#8>O#8>O#8>O#8>O$A@O#,:M#T<NC43H3$(I39@PC8UF1(YF@<SD!!D^GQ0>PD@>DA@PDA@PDA@PDA@PO$A@O!!PHBC<TEAPT
EAPTEC9@PC8IC 8?BP$I@00LB0,>PD@>A@@?A@PDI (!!G1<!!O$A@O 4BO04MIP(_L"P$L!!<>PC8AO0DA@PT"K2D!!HRD/O$@>A3<GA0\*KQ<7M3\7LC9@O XF
A XFJQ\.J2,+J28>PC8>O#8>O#8_KCPVE#P,O$A@PDA@PDA@O",1HB@1J39@PDA@PDA@PD@>O#8>O#9@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[166 167 171 189 190 193 180 181 184 178 180 184 167 169 173 211 212 214 204 205 207 198 199 201 140 143 148 155 158 163 205 207 210 197 199 202 192 194 197 178 180 183 152 155 159 176 181 187 140 144 149 181 186 192 179 184 190 177 182 188 146 150 155 168 174 180 179 185 191 178 184 190 173 179 185 172 178 184 170 176 182 169 175 181 185 190 195 184 189 194 183 188 193 193 198 203 190 195 200 205 209 213 203 207 211 227 230 233 215 218 221 199 201 203 196 198 200 236 238 240 235 237 239 221 222 223 217 218 219 172 179 185 187 193 198 183 189 194 182 188 193 200 205 209 197 202 206 196 201 205 211 215 218 223 227 230 180 187 192 206 213 218 202 209 214 191 197 201 214 220 224 231 234 236 198 206 211 196 205 210 210 217 221 219 224 227 194 193 193 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A??''?>_?9??''?>_?9??''??_?=??7??_?<@?0A>@@@b') ; yourself); yourself]
!

profile_exc
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/dtool16/profile_exc.gif"

    "
     self profile_exc inspect
     ImageEditor openOnClass:self andSelector:#profile_exc
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary profile_exc'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
V5-WU5!!XVE]WV5-[V5-[V5-WL%ISTD-@ME][V5-[V5-WGTYGTT9LR$X5U5-[V5-[U31CNE%TST%EQU][V5-[V5 =O#)YVUQOQDDUV5-[V5-VO2L;VU%YRDH\
DU-[V5-[U!!8(M5%YNR,_I1E[V5-[V5\*HSYYN"H)KRAWV5-[V5-WF2<:NS@0LR9WV5]WU5]WV5\3I"P%KA)WU5-[V5-[V5-[U5]WU5]WV%][U5]WU5][V5\K
D00SD1IWV5-[V5-[V5-WC0$NC@$SU5-WU5]WU5-[U04JB (NEE][V5-[V5-[V5\LBP$IBP1WV5]WU5]WV5-[U5]WU5]WV5-[V5-[V0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[196 165 200 204 191 206 198 169 204 196 195 200 194 194 198 192 194 204 182 185 191 192 196 202 166 178 191 250 251 252 248 249 250 242 243 244 138 148 156 241 244 246 155 162 166 243 246 247 173 184 185 187 189 189 253 254 254 252 253 253 251 252 252 188 189 189 156 166 160 200 206 202 163 173 166 165 175 167 164 174 166 173 179 174 171 177 172 171 178 172 151 160 152 148 157 149 162 171 163 161 170 162 160 169 161 149 157 150 174 183 175 170 179 171 176 184 177 171 179 172 147 157 148 158 168 159 157 167 158 152 162 153 171 181 172 168 178 169 166 176 167 164 174 165 155 165 155 168 178 168 174 180 174 176 181 176 179 183 179 178 182 178 215 219 215 213 217 213 222 225 222 219 222 219 218 221 218 213 216 213 172 179 171 169 176 168 165 172 164 153 159 152 180 187 179 182 188 181 157 165 155 177 184 175 175 182 173 178 184 176 187 193 184 216 220 214 226 228 225 171 178 167 192 197 189 196 200 193 182 188 177 195 202 188 194 201 187 203 209 197 192 197 187 250 251 249 179 187 169 203 208 196 253 253 252 193 193 192 192 192 191 194 193 193 193 192 192 255 255 255 250 250 250 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O8A?0O? ?>C?8O? ?>C?8O?__<@?73?@O=<?0C?_G8@b') ; yourself); yourself]
!

run_exc
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/dtool16/run_exc.gif"

    "
     self run_exc inspect
     ImageEditor openOnClass:self andSelector:#run_exc
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary run_exc'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
J"(*J"(*J"(*J"(*J"(*J"(*J"((JB (JB (JB(*J"(*J"((A2X&HRP]E0D(J"(*J"((@1<&JRX%IRL#@2 *J"((A2@"F2$)I"H"H"HGJB(*J@$^G!!,)JR$&
G!!8^G" *J" \GA0[JR$)JRX\GA$(J"((FA XF"$)JR$)I1 YJB(*J@0LCA()JR$)F00L@" *J" PDA@ZJR$)F!!@PB08(J"((A (JF"$)F (JD0$@JB(*J@PI
EA()F!!DQEALNAB *J"((AP8ZF!!HUC1XNAR *J"(*J" DB@8MCP8HAB *J"(*J"(*JB (JB (JB *J"(*J"(*J"(*J"(*J"(*J"(*J @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[160 170 163 155 165 158 172 179 174 162 171 164 151 162 153 157 168 159 160 170 162 153 163 155 164 174 166 167 176 168 162 171 163 158 167 159 149 157 150 180 189 181 172 181 173 162 173 163 149 159 150 155 165 156 153 163 154 164 174 165 160 170 160 155 165 155 172 181 172 177 185 177 158 165 158 186 193 186 213 217 213 219 222 219 171 178 170 193 199 192 176 183 174 190 196 188 185 191 183 199 204 197 189 195 186 191 196 188 200 204 197 190 195 186 175 184 164 210 215 201 194 193 193 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@O<A?8O?1??''?>_?9??''?>_?9??''?>O?0_>@?0@@@b') ; yourself); yourself]
!

term_restart
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/dtool16/term_restart.gif"

    "
     self term_restart inspect
     ImageEditor openOnClass:self andSelector:#term_restart
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary term_restart'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
HB@_G1<_G1<_G1< HB@ HB@ G1TVE1\WE!!T_HB@ HB@ HA<[@0TEAPL[G2@ HB@ HB@_B0PEAPTDB1< HB@ HB@ G0\A@ HB@P _HB@ HB@ HA<FBP(JB DG
G2@ HB@ HB@_F@@A@PDLGQ< HB@ HB@ G10ZFQ$YG 4MG2@ HB@ HA<_G1<_G1<ME@4_G2@ HB@ HB@ HB@ G1LSD 4_HB@ HB@ HB@ HA<NC0<OC!!< HB@ 
HB@ HB@_DA@PCQ< HB@ HB@ HB@ G1DMG1< HB@ HB@ HB@ HA<_G2@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[193 169 170 195 172 173 197 174 175 199 178 179 200 179 180 201 181 182 209 190 191 212 195 196 211 194 195 192 167 169 194 170 172 212 200 201 223 211 212 145 157 151 175 185 178 174 184 177 169 180 172 179 189 179 193 201 193 193 200 193 198 205 197 234 225 224 223 211 210 224 213 212 211 196 196 224 211 211 223 210 210 217 205 205 231 222 222 234 227 227 241 235 235 194 193 193 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?8C? O>@?8C? O>@?<C?<@G8@_0A>@G0@\@@@@@@b') ; yourself); yourself]
!

watch_exp
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/dtool16/watch_exp.gif"

    "
     self watch_exp inspect
     ImageEditor openOnClass:self andSelector:#watch_exp
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary watch_exp'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@ HB@ HB@ HB@ HB@ HB@ HA@PHA@PHB@ HB@PHB@ DB@P@A@@DB@ DB@ DA@ DA@ HA@@DB@ HA@ HA@PHA@PHB@P@A@ DA@@DA@ DA@PHB@P@A@@DB@ DB
@ HA@@DB@ DA@ DA@ HA@ HB@PDB@ HB@ HB@ HB@ HB@ DA@ HB@ HB@ HA@PDA@ HA@ HB@ DA@PHB@PDA@PHB@ HB@ HB@ HB@ DB@ DB@ HB@ HB@PDA
@ HB@PDA@ HB@ HB@ HB@ HB@ DA@ HB@ HB@ HB@ HB@ HA@PHB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ DA@ HB@ HB@ @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[158 163 169 194 193 193 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A,DW2[NI,;;''2N[H0@C@OH\<@BPGG@@X@A @@@@X@b') ; yourself); yourself]
! !

!VDBIconLibrary class methodsFor:'icons-eclipse.platform.debug-elcl16'!

changevariablevalue_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/changevariablevalue_co.gif"

    "
     self changevariablevalue_co inspect
     ImageEditor openOnClass:self andSelector:#changevariablevalue_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary changevariablevalue_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I2\AA XFA D''I2\''I2\''I2\[A!!0\GA0FF2\''I2\''I2\IA!!0ZF!!(ZG@XKI2\''I2\''A!!XSD1LSD1LVA"\''I2\''I0TPC0<OC0<OD@T''I2\''I2\DH"H"H"H"H"HD
I2\''I2\''ABL#C 4MC"L#AB\''I2\''I0 CEADRDQDT@14''I2\''I2\''I@LUEQTW@2P''@BD@I2\''I2\]@0LC@14''I2DGHR\''I2\''I2\''I2\''I0@LA00@I2\''I2\''
I2\''I2\ @B@BHB\''I2\''I2\''I2\@G2\_B!!<@I2\''I2\''I2\''G @''@A8XG"\''I2\''I2\''@BX''I2\&FRX@I2\''I2\''I2T%IRT%IRT%IP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[179 179 197 209 220 236 123 152 187 53 103 157 68 114 164 71 116 166 97 135 179 118 149 184 127 158 194 133 163 197 129 158 190 190 208 228 60 114 167 91 140 189 91 140 188 96 143 190 101 147 192 115 156 198 115 157 198 125 163 202 128 166 203 138 172 208 137 172 207 138 172 207 135 165 196 141 170 200 154 183 213 160 188 216 174 197 221 180 202 224 30 97 158 40 104 161 50 110 164 66 118 168 75 130 182 96 144 190 131 169 205 9 87 153 18 93 155 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O0A? O?@?<C?0O?@?<C?0G>8O3 @_@A<@M8@7 FO@_<b') ; yourself); yourself]
!

clear_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/clear_co.gif"

    "
     self clear_co inspect
     ImageEditor openOnClass:self andSelector:#clear_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary clear_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
UST5MST5MST5UUUUUUUUUUT5B@ HB@ HOSUUUUUUUUUUM"TBBRTB@#8?M5UUUUUUUR4$DQ@KB!!<;O#08UUUUUUT/A1$#FPDYFQ$YK%UUUUUUNRHTD1HQD@,J
C3AUUUUUUSDXF@XXFA XFA 3UUUUUUT2G!!PSD!!DPC@4!!MEUUUUUUN"@WE1\WE0QER$P@QT1EUR,VEALRDQ@ER4AC@DQAR5T,GA0\GA0\@4UMPD-BSTUUJ!!,R
DQ@KB 8@S$%ERT<@UR$ZF!!TZEQ(]QUAHT$!!QQUT&I"X&I"X''JEIGQPAEREMUUUUUUUUUUUUEUDP@Q%IFUUUUUUUUUUUUUUUUUUUUUP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[224 223 227 243 245 251 248 249 252 246 248 253 242 245 252 191 201 221 238 242 250 242 245 251 249 250 252 248 249 251 134 154 190 140 159 194 169 183 209 217 223 234 237 242 251 240 244 251 147 166 198 154 172 203 162 179 207 168 184 211 172 188 213 221 231 247 228 236 249 231 238 249 237 242 250 243 246 251 220 231 247 223 233 248 225 234 248 236 242 251 234 240 249 246 248 251 230 238 249 246 249 253 240 245 251 242 246 251 245 248 251 247 249 251 152 152 145 178 178 173 223 223 221 154 153 143 157 155 142 166 161 135 162 158 138 193 178 116 189 175 119 189 176 119 185 173 122 180 169 125 175 166 129 199 191 158 236 234 226 199 181 113 197 179 115 197 180 115 194 177 117 185 172 122 171 163 132 224 200 143 212 178 104 212 178 105 218 189 124 213 178 105 135 135 135 134 134 134 126 126 126 116 116 116 115 115 115 114 114 114 113 113 113 111 111 111 110 110 110 100 100 100 99 99 99 94 94 94 93 93 93 89 89 89 85 85 85 83 83 83 82 82 82 81 81 81 80 80 80 79 79 79 78 78 78 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_8A?0G? _?A?<G?0_?A?<G??_?=??7??_?=??0A?@@@b') ; yourself); yourself]
!

collapseall
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/collapseall.gif"

    "
     self collapseall inspect
     ImageEditor openOnClass:self andSelector:#collapseall
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary collapseall'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0LC@0LC@0LC@0LCB0,KB0,CB (JB (JB (J@0,KB0,K@0(B@ HB@ HB@ HB@ ,KB0LJ@ (JB (J
B (JB HKB0,CB HJB@ HB@ HB@ BB0,K@0(BB $IBP$IBP$I@ ,KB0LJ@ (FA XFA XFA HKB0,CB HJA0\GA0\GA0XBB0,K@0(BB TJB (JB (J@ ,KB0LJ
@ (A@PDA@PDA@PHKB0,C@0HJA@PDA@PDA@PBB0,KB0,BB @@@@@@@@@@@ ,KB0,K@ HB@ HB@ HB@ HKB0,KB0,KB0,KB0,KB0,KB0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[252 252 255 249 250 255 140 148 172 166 175 196 250 252 255 246 250 255 241 248 255 4 69 124 236 247 255 238 248 255 213 240 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?8O? ??#?>O?8??#?>O?8??#?>O?8O? ?>@@@b') ; yourself); yourself]
!

copy_edit_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/copy_edit_co.gif"

    "
     self copy_edit_co inspect
     ImageEditor openOnClass:self andSelector:#copy_edit_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary copy_edit_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
N#(:N#(:N#(:N#(:N#(:N#(0LC@0LC@0LC@:N#(:N#(:LPTEAS@0LC@0LC@0N#(:N#H&@PX1APTEAPTEM3@:N#(3IQPQL"XAA"XA@S 9LC(:M@P[ICL%EADJ
A2D5NCX3N"8#E@<4AA,$F0@[F1,[MC(/F!!(CK"LTC1HMC@$BDB8:J"@TC2<ZF LZF!!(ZF!!(/N","FQ$*HAPOD 4LBPH J#(,FAPOJ2HYFQ$YFQ$"FR,:KQ<_
G20XE@<RCP0I@!! ,N" ]EAL-G1<_G1<_G1<_KS()GA0VJA4TD08KBA\^ER :I2\''I2$\GAX\E!!0VE!!0)N#(:N#(''I2\''I2\''I2\''I0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[243 245 251 248 249 252 99 122 167 238 242 250 242 245 251 249 250 252 248 249 251 94 118 163 102 126 168 106 130 172 109 132 173 113 136 177 115 137 178 124 146 184 126 147 186 140 160 195 240 244 251 129 151 188 132 154 191 137 158 193 145 165 199 222 232 248 221 231 247 223 232 247 228 236 249 231 238 249 237 242 250 243 246 251 220 231 247 223 233 248 222 232 247 225 234 248 234 240 249 246 248 251 230 238 249 240 245 251 242 246 251 245 248 251 247 249 251 154 154 143 160 157 139 157 155 142 175 167 129 171 164 132 168 162 134 163 159 138 183 172 123 180 170 126 199 181 113 197 179 114 195 178 116 191 176 118 188 174 121 224 200 143 212 178 104 212 178 105 218 189 124 213 178 105 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A?0G?8_?1??''??_?=??7??_?=??7??_?=??7??A?<b') ; yourself); yourself]
!

copyviewtoclipboard_tsk
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/copyviewtoclipboard_tsk.gif"

    "
     self copyviewtoclipboard_tsk inspect
     ImageEditor openOnClass:self andSelector:#copyviewtoclipboard_tsk
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary copyviewtoclipboard_tsk'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
W%9^W%8AE!!XAW%9^W%9^W%9^W%8FBP$BBPY^W%9^W%9^WT=O@@ GA0 @U4=]W%9^W$5IA@TEB TEAPMISU9^W%9MRT%IRT%IRT%IRT5^W%9^R4QHQ$QFQDYD
Q$QKW%9^W$1CP4ICP$MBP4ICS%9^W%9JN$@:PDUEQTUEQUI^W%9^TC0=NTDTEATPDP8OB01^W%D8NC\?HRD"H1<\FQHLW%9TLS@5O!!PTEQ@QC <KCE9^T28/
MC,(IRT%IRT%IR!!^W%T-KCL6JBT^G!!8^G!!8(W%9VQ2,*L"$%IB@WIA4ZJU9^WE%XV%,''IP4SF1,XF2]^W%9^W%9^I"X&I"X&I"X&W @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[115 128 161 143 153 177 176 184 205 97 114 151 98 114 151 130 146 181 131 143 171 152 165 193 153 165 193 175 184 205 129 146 181 109 142 190 113 145 192 238 245 255 96 133 183 103 138 187 81 124 177 88 128 179 212 226 244 238 245 254 70 117 171 74 120 173 172 191 213 236 245 255 239 246 254 200 220 241 235 245 255 238 246 254 181 211 238 235 245 254 233 245 255 158 202 235 236 246 254 106 177 225 118 183 227 136 191 231 235 246 254 209 238 255 131 127 112 147 135 105 184 155 88 169 146 96 242 196 115 241 195 115 242 199 123 241 198 123 242 202 132 242 203 132 242 206 143 242 207 143 244 210 148 242 198 123 243 202 132 243 206 143 245 211 154 244 210 154 243 210 155 244 214 166 244 218 177 246 213 162 245 213 166 244 213 166 246 216 170 247 219 178 245 218 177 247 223 188 246 222 187 245 222 187 246 225 195 247 226 196 245 225 195 216 172 110 246 224 195 246 227 201 207 167 120 212 172 124 209 170 122 213 174 125 219 190 153 198 152 99 203 163 118 200 160 116 227 203 176 194 153 110 197 156 113 191 150 109 189 148 108 174 127 84 180 139 101 182 142 105 197 163 132 210 182 158 213 191 176 228 211 199 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'A8@O0G?8_?!!?>G?8_?!!?>G?>_?9??''?>_?9??''?>@?8b') ; yourself); yourself]
!

debug_view_auto
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/debug_view_auto.gif"

    "
     self debug_view_auto inspect
     ImageEditor openOnClass:self andSelector:#debug_view_auto
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debug_view_auto'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<YFQ$YFQ$YFQ$YFQ$YFS<?FA8^G!!8^G!!8^G!!8^G!! YFQ\^GPP]G08N@24]AA4WFA8VG!!(@F!!<NEPL-F @ZE!!\^EA8@@@@&@0LCI @@@APVG!!H^KR4.KRX&
I"4-KR4REA8OC0<OC0<OC0<OC0<OC1H^K2<\@!!0)KB0*DC<?O3<PG"</@!!DBJ0DEBP<?O3<?C18/K10BGB ''I2\MO3<?O04^IRX&I"X&I"X&CC<?O3<LG!!0B
GBP"H"D"HP,?O3<?B18BDPH!!@PTID1,JO3<?O0(^G@H\H1< H1<#BC<?O3<HG"4-KR4-KR4-KP\?O3<?A XFA XFA XFA XFO3<?O0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[57 121 189 103 125 169 55 152 96 224 107 94 87 141 200 116 136 176 134 148 174 136 149 172 140 151 170 137 152 187 143 154 168 148 156 165 152 159 162 158 162 158 235 145 134 162 165 155 168 168 151 124 184 125 173 171 148 159 171 199 177 174 145 238 158 147 181 176 142 185 178 140 189 181 137 191 182 136 154 187 223 180 187 209 168 206 183 215 227 244 213 243 255 235 250 255 236 250 255 237 250 255 238 250 255 235 251 255 237 251 255 238 251 255 239 251 255 240 251 255 241 251 255 242 251 255 243 251 255 242 252 255 243 252 255 244 252 255 245 252 255 248 253 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O?<?????????????????<O?0??C?<O?0??C?<O?0??@b') ; yourself); yourself]
!

debug_view_compact
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/debug_view_compact.gif"

    "
     self debug_view_compact inspect
     ImageEditor openOnClass:self andSelector:#debug_view_compact
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debug_view_compact'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G1<_G1<_G1<_G1<_G1<_G1<LC@0LC@0LC@0LC@0LC@0_B0<OC0<OC0<OC0<OC0<KG0(OC HND@PD@QHN@ 8PB!!<IC04@CQ@DB@DRCP@MD@$_A0<@@@@Q@PDA
DP@@@ADGG0XOD!!HSD!!DQDQHRD!!HRA!!<EAPTEAPTEAPTEAPTEAPT_G1<_AQ<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_@1<_G1<_G1<_G1<_G1<_G1<_
G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[57 121 189 224 107 94 87 141 200 152 159 162 235 145 134 162 165 155 173 171 148 177 174 145 238 158 147 181 176 142 185 178 140 189 181 137 191 182 136 154 187 223 215 227 244 213 243 255 235 250 255 239 251 255 244 252 255 245 252 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A??7??_?=??7??_?=??0 @@@@ @@@@@@@@@@@@@@@b') ; yourself); yourself]
!

debug_view_tree
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/debug_view_tree.gif"

    "
     self debug_view_tree inspect
     ImageEditor openOnClass:self andSelector:#debug_view_tree
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debug_view_tree'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?KR4-KR4-KR4-KR4-KS<?O2,MCP4MCP4MCP4MCR,?O3<,CRL"H1,[D!!,[F1,,O3<?J 4"IBHK@0PA@ @[J#<?O2$MH2H#DRD_
DQD_HR$?O3<(CQXVE!!XVE!!DVE!!X(O3<?I04RD"L"H00ZF (ZI3<?O2XMD!!H"IBH^@0PADBX?O3<%CQHRH2H#DATUEQT%O3<?C04XFQ$YFQ$YFQ$YC3<?O0$M
H2H#G@8NE@8TC $?O3<HCRH$H!!PCA@DB@ALHO3<?A04#H"L E1L E2@SA3<?O0XME1\WE1\WE1\WE0X?O3<EAPTEAPTEAPTEAPTEO0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[180 187 209 137 152 187 159 171 199 103 125 169 116 136 176 134 148 174 136 149 172 140 151 170 143 154 168 148 156 165 243 251 255 246 252 255 242 251 255 213 243 255 238 250 255 152 159 162 241 251 255 245 252 255 248 253 255 236 250 255 237 250 255 240 251 255 244 252 255 235 250 255 238 251 255 239 251 255 243 252 255 247 253 255 237 251 255 241 252 255 242 252 255 246 253 255 235 251 255 245 253 255 55 152 96 168 206 183 124 184 125 158 162 158 162 165 155 168 168 151 173 171 148 177 174 145 181 176 142 189 181 137 185 178 140 191 182 136 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@??#?>O?8??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
!

debuglast_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/debuglast_co.gif"

    "
     self debuglast_co inspect
     ImageEditor openOnClass:self andSelector:#debuglast_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debuglast_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?O2L?O2P?O3<?O3<?O3<?O3<]O3<ZO3<?O3<?O3<?O1 QC0$E@3<?O3<?O3<?O3<?O0X)E!!TDN!!8&O3<?O3<?D"@AD20+IPH?
O3<?O3<?O3<?CQP-I2(NDBH?O3<?O3<?O1<@HR((BC<\O3<?O3<?O1,?A0(LB3T?O3$9O3<?O3<?O3<WO3$4NS<9LC$?O3<?O3<YO3<9LB89NS@3NS<?O3<?
O3<?NSH.K"8.K#D;O3<?O3<?O3<>M2</K2<7O#<?O3<?O3<?O30<OC 6OC<?O3<?O3<?O3<?O346OS<?O3<?O3<?O3<?O3<=OS<?O0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[67 117 135 74 109 120 89 126 138 75 111 122 74 119 130 69 105 114 94 144 155 184 197 200 108 150 157 89 140 148 30 78 83 80 131 134 60 121 122 25 68 67 59 119 115 79 128 119 94 119 108 94 117 106 129 146 138 157 198 177 156 199 175 151 197 171 160 201 177 94 114 101 124 144 131 149 166 155 111 129 117 154 169 159 158 168 161 149 156 151 120 142 125 102 119 105 160 168 161 147 193 152 187 191 187 183 187 183 197 199 197 154 195 152 195 199 194 151 191 127 123 171 79 163 196 127 180 210 137 211 229 181 231 244 208 213 230 181 248 237 177 248 229 153 248 245 232 240 213 129 248 221 137 240 221 169 254 250 239 168 133 45 248 206 98 248 213 122 248 213 129 177 129 28 142 141 139 177 123 23 162 109 18 155 103 18 170 116 23 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@R@AH@_ @_8G>@G>@_(B>XA]0I? G?@O<@_ @\@A b') ; yourself); yourself]
!

delete_config
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/delete_config.gif"

    "
     self delete_config inspect
     ImageEditor openOnClass:self andSelector:#delete_config
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary delete_config'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD0G"L1LSD1LRL^LCD1LSD0HR4!!H3D1LRL"KR@0LSD1IRP.J2P_IQ<$K2,$ISD1LSD#J@PBJ"X*
@0D''H3D1LSD1LQ0,DQ@OC <)GCD1LSD1LSD1@@(MCQXI@CD1LSD1LSD1LP LF1(ZC@ 1LSD1LSD1LQ0UFA XFA KGCD1LSD1LQ0SFA ED TXFQP\LSD1LQ4W
FA$WGA4\E1 YE141LSD0E0XWGCD1LQ0WA1\0LSD1LS@WGCD1LSD1GA\0LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[199 51 53 244 113 116 244 115 116 243 114 116 243 115 117 216 42 47 224 44 52 223 44 51 199 41 48 230 54 62 229 54 62 197 32 43 229 48 57 242 85 96 244 99 107 243 99 106 243 99 107 243 100 107 197 24 39 198 25 40 197 25 39 198 32 44 242 84 96 197 19 37 241 63 82 240 63 81 242 72 88 241 72 88 212 101 116 223 156 168 202 93 73 206 110 94 202 87 70 202 88 70 201 88 70 213 136 124 201 80 67 220 166 160 201 71 62 201 71 63 200 71 63 199 61 57 224 97 91 245 129 125 199 61 58 227 82 79 245 128 126 244 128 126 227 196 196 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@A0\O#8??!!?<C? G<@_0C? _?C?>O#8\G@@@@@@b') ; yourself); yourself]
!

det_pane_auto
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/det_pane_auto.gif"

    "
     self det_pane_auto inspect
     ImageEditor openOnClass:self andSelector:#det_pane_auto
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary det_pane_auto'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NCL3L3L3L3L8NC 8NC 8NC 0D!!HRD!!H0NC 8NC 8NC 8LQHGBP\_LS 8NC 8NC 8NB8RB 8JG288NC 8NC 8NC /
D 8NC"D-NC 8NC 8NC 8KA WH!!,[J3L3L3L3L3L3L3L3L3X5G"$3D!!HRD!!HRD!!HRD#L4MQT''L!!H$H2P\GA0\GA02M3TZI"(RH2T#G@HC@P@\J"@]GQP(D"P#
IA4]DQ4]GR LA1LMDAH[F1X[F1,[F1,PB0(YB@PDA@PDA@PDA@PDA@,NFPX8NC 8NC 8NC OD!!0\GA0ENC 8NC 8NC 8A@PDA@PDA@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[180 187 209 137 152 187 103 125 169 116 136 176 134 148 174 136 149 172 140 151 170 215 227 244 143 154 168 87 141 200 154 187 223 124 139 156 131 144 158 148 156 165 57 121 189 214 226 235 151 158 162 239 250 255 213 243 255 238 250 255 152 159 162 241 251 255 245 252 255 248 253 255 226 247 255 236 250 255 240 251 255 244 252 255 235 250 255 239 251 255 243 252 255 247 253 255 167 170 171 245 253 255 250 254 255 55 152 96 168 206 183 124 184 125 158 162 158 162 165 155 163 165 155 168 168 151 174 172 147 173 171 148 215 214 203 177 174 145 181 176 142 201 198 178 189 181 137 185 178 140 184 178 141 191 182 136 167 148 145 224 107 94 235 145 134 164 136 133 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@_0A?@G<@_0A?@G???????????????????0A?@G<b') ; yourself); yourself]
!

det_pane_hide
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/det_pane_hide.gif"

    "
     self det_pane_hide inspect
     ImageEditor openOnClass:self andSelector:#det_pane_hide
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary det_pane_hide'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
K"8.K"8.K"8.K"8.K"8.K"8.KR4-KR4-KR4-KR4-KR8.K",MCP4MCP4MCP4MCR,.K"8,CRL"H1,[D!!,[F1,,K"8.J 4"IBHK@0PA@ @[J"8.K"$MH2H#DRD_
DQD_HR$.K"8(CQXVE!!XVE!!DVE!!X(K"8.I04#H"LLF!!(JB!!(ZI28.K"XMH"P"G LD@PH@DBX.K"8%CRL"H1@UEQT]EQT%K"8.C04XFQ$YFQ$YFQ$YC28.K $M
H2H#G@8NE@8TC $.K"8HCRH$H!!PCA@DB@ALHK"8.A04#H"L E1L E2@SA28.K XME1\WE1\WE1\WE0X.K"8EAPTEAPTEAPTEAPTEK @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[180 187 209 137 152 187 159 171 199 103 125 169 116 136 176 134 148 174 136 149 172 140 151 170 143 154 168 148 156 165 243 251 255 246 252 255 242 251 255 213 243 255 238 250 255 152 159 162 241 251 255 245 252 255 248 253 255 236 250 255 237 250 255 240 251 255 244 252 255 235 250 255 238 251 255 239 251 255 243 252 255 247 253 255 237 251 255 241 252 255 242 252 255 246 253 255 235 251 255 245 253 255 55 152 96 168 206 183 124 184 125 158 162 158 162 165 155 168 168 151 173 171 148 177 174 145 181 176 142 189 181 137 185 178 140 191 182 136 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@??#?>O?8??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
!

det_pane_right
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/det_pane_right.gif"

    "
     self det_pane_right inspect
     ImageEditor openOnClass:self andSelector:#det_pane_right
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary det_pane_right'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
KR4-KR4-KR4-KR4-KR4-KR4-JR$)JR$)JR$)JR$)JR4-KR\KB0,KB2\KB0,KB2\-KR4(B1<^G1 (B0LE@1 (KR4-I ,^HA8II ,FB@XXI"4-KRTKG18_C2TK
B@ HGBT-KR4$B1LSD1L$B0<SD1L$KR4-H0,_G!!<JH0,,KB,WH24-KRHKG"@^F"HKKB(+C"H-KR4!!B1<^G08!!B2,+J1H!!KR4-CP,UE!!XVCP,VE!!XVCR4-KP\K
GQ8]FP\K@0TCC@\-KR4DB18 G!!DDB0XHA!!@DKR4-@ ,]G!!4[@ ,HB@ P@"4-KPDKEAPTE@DKEAPTE@D-KR4@@@@@@@@@@@@@@@@@KP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[134 148 174 136 149 172 140 151 170 215 227 244 143 154 168 87 141 200 154 187 223 148 156 165 57 121 189 246 252 255 242 251 255 213 243 255 238 250 255 152 159 162 241 251 255 245 252 255 236 250 255 237 250 255 240 251 255 244 252 255 235 250 255 238 251 255 239 251 255 243 252 255 247 253 255 237 251 255 242 252 255 235 251 255 245 253 255 147 197 178 55 152 96 168 206 183 124 184 125 158 162 158 162 165 155 168 168 151 173 171 148 177 174 145 181 176 142 189 181 137 185 178 140 191 182 136 238 158 147 224 107 94 235 145 134 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@??#?>O?8??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
!

det_pane_under
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/det_pane_under.gif"

    "
     self det_pane_under inspect
     ImageEditor openOnClass:self andSelector:#det_pane_under
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary det_pane_under'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!GQ4]GQ4]GQ4]GQ4]GRD!!HQ,KB0,KB0,KB0,KB1,!!HRD\B1LRD1@PDA@PDA@\HRD!!F ,REAHP@0PA@ @PF"D!!HQ$KD1HSDQDJ
DQDQDQ$!!HRDXB0<OCP<OC0<OC0<XHRD!!E0,NC 8NC 8NC 8NE2D!!HQXVE!!XVE!!XVE!!XVE!!X!!HRDUB0,KB0,KB0,KB0,UHRD!!C@,PDA@PDA@PDA@PCBD!!HP$K
HB@_DA@PDA@PD@$!!HRDHB2@^G1DCA@DB@ADHHRD!!A0,_G1<OC0<OC0<OA2D!!HPXKC 8NC 8NC 8NC X!!HRDEAPTEAPTEAPTEAPTEHP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[180 187 209 137 152 187 159 171 199 103 125 169 116 136 176 134 148 174 136 149 172 140 151 170 143 154 168 148 156 165 239 250 255 213 243 255 152 159 162 245 252 255 248 253 255 244 252 255 235 250 255 239 251 255 55 152 96 168 206 183 124 184 125 158 162 158 162 165 155 168 168 151 173 171 148 177 174 145 181 176 142 189 181 137 185 178 140 191 182 136 238 158 147 224 107 94 235 145 134 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@??#?>O?8??#?>O?8??#?>O?8??#?>O?8??#?>O?8b') ; yourself); yourself]
!

disabled_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/disabled_co.gif"

    "
     self disabled_co inspect
     ImageEditor openOnClass:self andSelector:#disabled_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary disabled_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0@@@@@@@@@@@@@@@@,KB0,@@ HB@ HB@ HB@ @KB0,K@@HC@0LC@0LC@0L@B0,KB0@BAPTEAPTE
APTE@@,KB0,@@ XFA XFA XFA @KB0,K@@HDA@PDA@PDA@P@B0,KB0@BA0\GA0\GA0\G@@,KB0,@@  HB@ HB@ HB@@KB0,K@@HA@PDA@PDA@PD@B0,KB0@B
BP$IBP$IBP$I@@,KB0,@@ (JB (JB (JB @KB0,K@@@@@@@@@@@@@@@@B0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[139 150 171 249 253 255 213 243 255 235 249 255 241 251 255 236 250 255 238 251 255 243 252 255 246 253 255 250 255 255 252 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

disconnect_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/disconnect_co.gif"

    "
     self disconnect_co inspect
     ImageEditor openOnClass:self andSelector:#disconnect_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary disconnect_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0L@@0\GA0\G@@\GA0\GA0LEAPTCA0\GA0@@A0\GA0\@A XF@@\GA0\@A0@GA0\G
@0PDA@LGA0\G@@\G@@\GA0\C@@LGA0\GA0@GA0HA@ \GA0@GA0\GA0\@A0\GA0\GA0\@A0\GA0\C@@LGA0\B@PHG@@\GA0\CAPTE@0\GA0\@A0@GA0\G@@XF
A @GA0\GA0@@A0\GA0LDA@PCA0\GA0\G@@\GA0\G@0@CA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[200 41 48 128 31 35 128 61 65 240 91 103 241 63 83 246 146 142 245 124 124 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@\DC8XO!!P>D!!0S"A@HNN!!<JG0X_@ 8@@@@@@@b') ; yourself); yourself]
!

display_selected_mb
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/display_selected_mb.gif"

    "
     self display_selected_mb inspect
     ImageEditor openOnClass:self andSelector:#display_selected_mb
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary display_selected_mb'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I"X&I"X&I"X&I"X&I"X&I"X&G1<_G1<&GQ4]GQ4&I"X&I!!< HB@_I!!4"H"H]I"X&I"X[HBP$F2X\H"T%GBX&I"X&FB@$IA &FRH%IQ$&I"X&I!! XFA XI!!$Y
FQ$YI"X&I"X&I"X&I"X&I"X&I"X&I"X&G!!8^G!!8&I 8IBP$NI"X&I!!8!!HRD^I $ME!!TPB $&I"XZHRL#F"XHCAXUD@(HI"X&E2D#H1\&A0<VEQ@EA2X&I!!\W
E1\WI LOE!!TPAPL&I"X&I"X&I"XBC1XUD@TBI"X&I"X&I"X&@P<VEQ@E@RX&I"X&I"X&I XDD!!PSA@X&I"X&I"X&I"X&B0@@@AD&I @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[90 120 171 98 128 177 106 135 183 109 139 187 105 134 180 126 155 202 123 148 189 112 143 190 115 145 191 117 147 193 128 155 195 136 162 199 145 169 203 144 168 202 148 171 204 151 173 206 152 174 206 155 175 206 166 185 213 121 150 191 154 176 207 197 212 232 224 232 240 124 114 79 164 157 132 190 185 167 134 120 75 171 161 129 195 188 165 201 191 164 147 126 72 180 165 127 255 215 138 255 197 87 255 226 171 249 180 77 251 203 131 252 218 166 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@>>C;8O/ >>C;8@@@>_C;>O/8>?#;>@O8@? C>@G0b') ; yourself); yourself]
!

dissolve_group
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/dissolve_group.gif"

    "
     self dissolve_group inspect
     ImageEditor openOnClass:self andSelector:#dissolve_group
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary dissolve_group'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<@O3<?O0DB@0HAO3<?O3<?O0@?O0DBA@DD@ D?O3<?O3<?@C<BA@TEAPPBO3<?O3<?O3<@@0XGB@\F@3<?O3<?O3<?O0@IA (F
BPH?O3<?O3<?O3<A@@$KBPHAO3<?O3<?O3<?O0D@@0HAO3<?O3<?O00MC 4LO0@?C1@QD@<?O1HSEATTD1H?@A@VC1XPC3<ME1 XFA\MO1@@FQ$YE!!@?C!!([
GA4ZC#<QG @_HA8QO04!!H"H"HP4?DBL^@A8#DC<RD2P%I!!LRO0<PI1$@D@<?O00MC 4LO3<?C1@QD@@?O3<?O3<?O3<?O3<?O3<?@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 252 203 181 176 95 165 160 54 255 250 168 249 246 189 234 230 145 214 210 132 204 199 118 237 232 151 247 243 163 255 252 198 180 195 204 51 94 135 36 74 110 255 191 191 170 58 58 114 0 0 168 188 199 44 82 123 152 185 208 180 209 229 239 143 143 130 172 200 152 193 219 255 168 168 108 165 203 90 154 194 83 149 190 89 154 192 239 131 131 214 98 98 221 115 115 107 159 195 115 169 204 226 122 122 131 175 205 145 188 215 130 174 204 224 132 132 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@AC8B_0E?@O<@_0A?@C8C:>_7=?_7=?_7=?_38>@@Db') ; yourself); yourself]
!

drop_to_frame
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/drop_to_frame.gif"

    "
     self drop_to_frame inspect
     ImageEditor openOnClass:self andSelector:#drop_to_frame
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary drop_to_frame'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
FQ$YFQ$YFQ$YFQ$YFQ$YFQ$@@@@@@@@@@@@@@@@YFQ$Y@PPD@ HB@0LCA@LDFQ$YFP\GA0\GA0\GA0\GA1$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$Y@@@@@@@@@@@@
@@@@FQ$YFPDDA@HB@ LC@0PCAA$YFQ$GA0\GA0\GA0\GA0\YFQ$YFQ$YFQ$YFQPYFQPTFQ$YFP@@@@@@AQPKE@ TB!!PYFQ$AA@PB@ XTB 0TE@(PEA$YA0\G
A0\IE@<LC@0LC@8UFQ$YFQ$YFQ$XD 4MCP4RFA$YFQ$YFQ$YFQXVE!!LQE!!$YFQ$YFQ$YFQ$YFQ\QE1$YFQ$YFQ$YFQ$YFQ$WE1$YFP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[16 92 156 87 140 186 86 140 185 87 140 185 87 141 185 173 199 221 198 216 231 206 222 234 215 228 238 231 239 245 248 248 232 254 253 239 248 240 176 248 232 152 240 216 128 248 224 136 240 224 168 248 208 96 248 216 120 248 216 128 176 131 25 176 124 20 161 110 15 154 104 15 169 117 20 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A?>G?8_? @@G?8_?!!?>@BX_?1??''??@O<@_ @\@A b') ; yourself); yourself]
!

edtsrclkup_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/edtsrclkup_co.gif"

    "
     self edtsrclkup_co inspect
     ImageEditor openOnClass:self andSelector:#edtsrclkup_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary edtsrclkup_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
EQTUEQTUEQTUEQTUEQTUEQT@@@@UEQTUEQTUEQTUEQTU@@D@EP@@@ATUEQTUEQTUEP@@@ATUEQTUEQTUEQTUEQTU@ATUEQTUEQTUEQTUEQTUEP@UEP@@@ATU
EQTUEQTUEQT@@@@@@P@UEQTUEP,HEQTU@ATU@@@@EQTUEP,HA \UEP@UEQTUEQTUEP(HA \LEQT@EQT@@@@UEP$HA \LEQTU@@@@@@D@EP0HA \LEQTUEQTU
EP@@@!!HHA \REQTUEQTUEQTUEQ@DA \QEQTUEQTUEQTUEQPOAPTMEQTUEQTUEQTUEQTCD08MEQTUEQTUEQTUEQTU@0LT@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[92 122 170 145 165 199 223 229 239 34 67 103 219 211 161 187 180 138 240 216 168 233 196 126 246 230 200 147 124 87 148 127 93 149 129 96 147 120 81 143 105 56 142 105 56 143 108 62 144 112 67 144 112 68 146 116 74 143 105 57 215 202 186 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A0@G\@\@@ @B\@O0X''C2@_I38?_@_8@_@C8@O@@?<b') ; yourself); yourself]
!

enabled_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/enabled_co.gif"

    "
     self enabled_co inspect
     ImageEditor openOnClass:self andSelector:#enabled_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary enabled_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I HB@ HB@ HB@ HB@"X&I"XBD!!HRD!!HRD!!HRD H&I"X&@!!H[D1LTD1LT@APBI"X&I HRFA YCQ$X
@@TX@"X&I"XBD!!TUGQ0Q@@T@G@H&I"X&@!!HAE"@ @PP@E!!XBI"X&I HAB@L^@0$@F!!(^@"X&I"XBD DKA \AC"D!!HPH&I"X&@!!HO@0(CC1\OC0<BI"X&I HR
G1<FG1<_H"H#@"X&I"XBD"TPDBTLCA@LI@H&I"X&@ HB@ HB@ HB@ HBI"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I"X&I @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[169 178 198 150 161 184 139 150 171 129 144 168 71 91 120 77 96 123 108 125 151 51 78 111 60 85 116 61 85 115 41 72 107 50 78 110 253 254 255 237 249 255 246 252 255 249 253 255 252 254 255 239 250 255 213 243 255 234 249 255 235 249 255 238 250 255 241 251 255 248 253 255 236 250 255 237 250 255 244 252 255 235 250 255 238 251 255 239 251 255 243 252 255 251 254 255 241 252 255 246 253 255 250 254 255 250 255 255 252 255 255 253 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

expandall
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/expandall.gif"

    "
     self expandall inspect
     ImageEditor openOnClass:self andSelector:#expandall
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary expandall'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
C0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0<OC0DA@PDA@PDA@PDAC0<OC0<AA@PDA@PDA@PD@P<OC0<O@PP@@@@@@@@@@@@@@@<OC0DD@@PDA@PD
A@PDA@@OC0<AA@@DA XF@ XFA X@C0<O@PP@A@\GA0HDA0\G@@<OC0DD@@PEAPTBA@TEAP@OC0<AA@@D@ HB@ HB@ T@C0<O@PP@A@ DA@HDA@PD@@<OC0DD
@@PC@0LBA@LC@0@OC0<A@P@DBP$I@ PIBP$@C0<OC0<@A@(JB (DB (J@@<OC0<O@@@@@@@@@@@@@@@OC0<OC0<OC0<OC0<OC0<OC0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[139 150 171 165 177 195 1 70 122 249 253 255 213 243 255 241 251 255 236 250 255 238 251 255 246 253 255 250 255 255 252 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?8O? ??#?>O?8??#?>O?8??#?>O?8O? ?>@@@b') ; yourself); yourself]
!

export_brkpts
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/export_brkpts.gif"

    "
     self export_brkpts inspect
     ImageEditor openOnClass:self andSelector:#export_brkpts
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary export_brkpts'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
E!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!TCA LUE!!XVE!!XVE!!XVE!!P@DQHQ@APVE!!XVE!!XVE!!XCC!!@PD@8CE!!XVE!!XVE!!XVA $SA0 IA!!XVE!!XVE!!XVE LJB0,KB LV
E!!XVE!!XVE!!XT@@0OCP@TE!!XVE!!XVE!!XVE!!TCA LUE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!TCA LUE!!XVE!!XVE!!XVE!!P@DQHQ@APVE!!XV
E!!XVE!!XCC!!@PD@8CE PAAPTVE!!XVA $SA0 IA!!XVA@DEE!!XVE LJB0,KB LVE!!XD@!!XVE!!XT@@0OCP@TE!!XVE PVE!!XVE!!TCA LUE @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[41 83 121 51 112 164 51 112 163 49 95 134 64 119 167 13 92 154 33 75 108 81 151 189 88 156 193 106 167 202 105 161 194 113 171 203 129 176 203 130 177 204 129 174 199 144 190 215 151 195 219 151 187 207 179 211 229 87 156 191 167 190 198 179 197 203 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@_@C>@O8@? C>@O8@_@@@@@C8@_0A?^G<8_1!!?BC8b') ; yourself); yourself]
!

filter_ps
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/filter_ps.gif"

    "
     self filter_ps inspect
     ImageEditor openOnClass:self andSelector:#filter_ps
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary filter_ps'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^@Q8^G L^G!!8^G!!8^G!!8^G DHG!!8CG!!8^G!!8^A \EA@DA@P ^@18^G!!8^G!!8^G!!8^@P ^G H^G!!8^G!!8^G!!8^G D^G!!8@
G <OG!!8^G!!8^G!!8^G!!8^G!!8OBP<^G!!8^G!!8^D1LSD1TSEP$IEA8^G!!8^D@(JCP,KCP(LB0,RG!!8^G!!8ZFQDXE10XC 8[G!!8^G!!8^G!!8^G!!8^E 8VG!!8^G!!8^
G D^G!!8@G!!4]G!!8^G!!8^G!!8ABA8^@!!8^G!!8^G XGAPPA@PDHG L^G!!8^G!!8^G!!8^G DHG!!8CG!!8^G!!8^G!!8^G!!8AG!!8^@18^G!!8^G @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[56 68 93 111 118 132 87 100 124 119 132 154 101 125 148 92 133 165 78 143 189 84 139 179 77 90 93 254 253 239 253 242 198 253 241 198 253 241 199 253 242 199 252 230 158 189 132 22 181 122 19 174 117 18 180 123 19 186 128 21 186 129 21 185 128 21 169 111 17 175 116 18 175 117 18 174 116 18 175 116 19 175 117 19 174 116 19 166 107 16 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@DP@Y@?4@FP@QX@A0G? ??A?8@G@QXA$C?P@Y@AD@b') ; yourself); yourself]
!

hierarchicalLayout
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/hierarchicalLayout.gif"

    "
     self hierarchicalLayout inspect
     ImageEditor openOnClass:self andSelector:#hierarchicalLayout
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary hierarchicalLayout'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@@@A0\GA0\GA0\GA0\GA0@C@@\FA XEA@HAA0\GA0\@@@@GA0\G
A0\GA0\GA0\GA0@GA0\GA0\GA0\GA0\GA0\@A0\@@@@GA0\GA0\GA0\G@@@@@@L@A0PB@P\GA0\GA0@GA0@@@@\GA0\GA0\GA0\@A0\GA0\GA0\GA0\GA0\G
@@\G@@@@A0\GA0\GA0\GA0@@@@@C@@\D@ DGA0\GA0\GA0\@@@@GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[92 122 170 96 126 173 102 131 177 145 165 199 108 138 183 114 144 186 118 148 190 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G@@]?A0@B@@I0@?\B\@H@@''@C=0A0@@@@@@b') ; yourself); yourself]
!

import_brkpts
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/import_brkpts.gif"

    "
     self import_brkpts inspect
     ImageEditor openOnClass:self andSelector:#import_brkpts
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary import_brkpts'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
E!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!TCA LUE!!XVE!!XVE!!XVE!!P@DQHQ@APVE!!XVE!!XVE!!XCC!!@PD@8CE!!XVE!!XVE!!XVA $SA0 IA!!XVE!!XVE!!XVE LJ
B0,KB LVE!!XVE!!XVE!!XT@@0OCP@TE!!XVE!!XVE!!XVE!!TCA LUE!!XVE!!XVE!!XVE!!XVE!!XVE!!XVE!!XU@0XCEQXVE!!XVE!!XVE!!XT@ADRDP@TE!!XVE!!XVE!!XV@08P
DA@N@1XVE!!XVE PVE XID0\HBPXVE!!XVE PAE!!XCB ,KB0(CE!!XVE PAAQXVE@@LC04@EAXVE PBAPTVE!!XU@0XCEQXVE!!XVE!!XVE @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[41 83 121 51 112 164 51 112 163 49 95 134 64 119 167 13 92 154 33 75 108 81 151 189 88 156 193 106 167 202 105 161 194 113 171 203 129 176 203 130 177 204 129 174 199 144 190 215 151 195 219 151 187 207 179 211 229 87 156 191 167 190 198 179 197 203 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@_@C>@O8@? C>@O8@_@@@O A?@G<B_0Y?C''<^O @b') ; yourself); yourself]
!

lock_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/lock_co.gif"

    "
     self lock_co inspect
     ImageEditor openOnClass:self andSelector:#lock_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary lock_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&Y&OC0<OC0<OC0<OC0<OC1&Y#43L3L3L3L3L303L3L<Y&X9L2L#H2L#H2L>L1$LO&Y&N#L$IBP$IBP$L#L]JSI&Y#,3J2,+J2,+
J0HB@ HBY&X8MBX&I"X%IRT @1LSHFY&M6EPTE<XFB0,KP8MER5&Y&ARYFQRW"8.I2(VE!!P"Y&IFVFU%X4YMK2 !!L1\WG6Y]V&E]WVEZWSD0F1DRGAE&S4!!E
U$@?R4<5LQ(3L3LPY$9CP%ESPT1N@P@GL1$LBFY[QE]YVU]JV3X6C3L^A@Y&WEUIUEQIQ50KB $EAPTEY%5ZV%)ZV%)]Y&Y&Y&Y&Y @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[252 252 254 253 253 254 104 118 146 164 176 200 248 250 254 94 120 168 99 124 168 106 128 168 106 128 167 126 147 185 152 169 199 173 186 210 186 199 223 225 233 248 225 233 247 98 124 168 114 134 167 123 140 167 124 140 167 164 177 199 222 232 248 224 233 248 223 232 247 231 238 250 244 247 252 75 110 162 114 135 167 123 141 167 124 141 167 242 246 252 248 250 253 132 147 167 108 118 131 132 147 166 139 151 166 228 237 248 230 238 248 234 241 250 241 246 252 240 245 251 243 247 252 242 246 251 139 152 166 232 240 249 237 243 250 144 155 166 245 249 253 247 250 253 246 249 252 249 251 253 122 129 133 207 237 251 225 244 253 251 253 253 253 254 254 195 196 187 185 183 168 160 152 108 155 149 112 172 168 143 167 156 104 164 154 106 149 144 117 253 243 203 244 230 182 253 239 189 253 240 194 253 242 199 253 242 201 253 243 206 182 146 36 245 218 136 252 225 143 252 228 154 252 230 158 252 230 159 252 230 160 229 224 207 177 139 33 180 143 35 193 158 56 166 137 56 199 164 69 184 153 68 216 189 109 240 215 142 217 196 135 229 209 149 220 207 172 120 91 19 167 126 28 174 134 31 171 131 31 197 176 125 210 192 148 209 193 155 194 170 115 201 182 137 214 203 178 217 208 188 243 237 225 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@??3??O?<??3??O?<??3??_?=??7??_?=??7??_8@b') ; yourself); yourself]
!

memoryreset_tsk
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/memoryreset_tsk.gif"

    "
     self memoryreset_tsk inspect
     ImageEditor openOnClass:self andSelector:#memoryreset_tsk
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary memoryreset_tsk'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
JB (JB (JB (JB (JB (JB (EP<OC1T(JB (JB (JB (C1L@F1\QC2 (JB (JB (J@8T@A,WDP8(JB (JB (JB ME @[E0\MJB (JB (JB (AQX@F1\GAR (
JB (JB (J@PV@A,WA0P(JBX&JB (JB CE @[E0\JJBX"I" (JB (@!!X@F1\GCBX"H"X&I" (J@$FF!! PFRX\GQ4]GQ<&JB (D DAB@,%G"@ HB@ HRT(JB (
JB (JB\$H2\''IBL''JB (JB (JB (I2P''JB\$I2 (JB (JB (JB ''I2 (I2 (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (J@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[224 229 240 92 119 172 100 126 178 104 129 182 108 133 184 111 137 188 107 132 181 128 153 203 124 146 190 125 146 190 131 152 196 156 173 207 165 181 212 114 141 191 117 143 192 119 145 194 123 148 192 129 153 196 137 160 200 145 166 203 146 167 204 149 169 205 152 171 207 153 172 207 155 174 208 168 184 214 167 183 213 198 210 232 249 229 149 251 237 181 249 218 124 241 215 132 251 230 159 241 209 117 254 250 239 251 219 134 249 203 97 176 126 26 183 132 28 161 108 21 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@>@G<@_0A?@G<@_3A?\G?<_?8??0C?@G\@L @@@@@b') ; yourself); yourself]
!

metharg_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/metharg_obj.gif"

    "
     self metharg_obj inspect
     ImageEditor openOnClass:self andSelector:#metharg_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary metharg_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O1$ZBA(YO3<?O3<?O3<?O3<?O1$?O3<?O3<?O3<?O3<?O3<YO3<?O3<?O3<?O3<?M#X6FSX6M#X6M#X6M#X7O3L/K1$/K2</K2</K2</K3<2K18YG"L\GA0*
J" (H2L?LR<)FQ<_JS,;N3,;N3,;N3@/J1$VIRT;APTEAPTEAS,,K28YFB4XOBDQD@<GA"D<F2<&FRX&AC4@@B\''@B\@OPLC@1$CBP,9HADPC0\F@#$?O3<Y
O3<?O!!\W@Q\WE1\>O3<?FS<?O3(NDQ@OA0XUN#<YF  ZFS<8D1P$CQP$D3 ?O3<?O3<?MA4QD@<GA 04O3<?O3<?O3TJD"HRD ("MP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[244 246 251 237 241 250 241 244 251 136 149 174 246 248 252 249 250 252 134 154 190 140 159 194 186 199 223 169 179 197 223 232 248 193 200 213 226 234 248 229 236 249 233 239 250 147 166 198 154 172 203 162 179 207 223 232 247 230 237 249 229 236 248 233 239 249 238 243 251 237 242 250 245 248 253 75 110 162 100 132 181 141 153 171 225 234 248 226 235 248 225 234 247 232 239 249 241 245 251 247 249 252 223 233 247 225 235 248 229 237 248 239 244 251 245 248 252 244 247 251 224 235 248 231 239 249 224 235 247 238 244 251 149 157 165 245 249 253 245 249 252 207 237 251 159 163 158 168 168 152 177 174 145 185 178 140 160 157 139 156 154 143 191 182 136 209 202 169 166 161 135 185 173 122 172 164 131 199 181 113 196 179 116 191 176 118 179 168 127 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_@@P@A@@??;??/?>?????????????1G?D_==?0G?@_<b') ; yourself); yourself]
!

monitorexpression_tsk
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/monitorexpression_tsk.gif"

    "
     self monitorexpression_tsk inspect
     ImageEditor openOnClass:self andSelector:#monitorexpression_tsk
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary monitorexpression_tsk'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,UEQTUJ2,+J2,+J2,+J2,+ER(*ER,+J2,+J2,+J2,+J1P)JAX+J2,+J2,+J2,+J2,RJR R
J2,+J2,+J2,SDQ@OI2\''I0<OC0<+J2,+C"H"I"P"I"T#H"HMJ2,+J00!!HR@]HBD^G1<_B2,+J2,FBP(JF10[F0(HA0\+J2,+J2,+J0TYF T+J2,+J2,+J2,+
J2,DFA\CJ2,+J2,+J2,+J2,+@Q W@",+J2,+J2,+J2,+J0@@@@@+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J2,+J0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[53 118 84 56 122 87 56 121 87 59 126 90 60 126 90 64 133 94 68 139 98 69 140 99 69 139 98 69 139 99 69 140 98 74 147 103 74 147 104 79 154 108 80 154 108 84 161 113 85 161 113 84 161 112 88 167 117 85 162 113 92 172 121 95 176 123 93 172 121 141 180 83 141 180 84 150 185 85 150 185 86 160 192 88 161 192 88 172 199 90 172 199 91 173 199 90 173 198 90 173 199 91 197 214 96 198 214 96 197 213 96 198 213 96 197 213 97 208 219 99 218 226 101 218 225 101 224 229 102 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@O@@<@C0@O@O?0??C?<O?0C0@O@@<@C0@@@@@@b') ; yourself); yourself]
!

new_con
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/new_con.gif"

    "
     self new_con inspect
     ImageEditor openOnClass:self andSelector:#new_con
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary new_con'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LC@0LB\0LC@0LC@_G1<_G1<XFB\VI3@0LC@0G0LC@0LB@"T&E"X&LC@0LB@QDQDQD"4^G"P$G"40LC@!!DA@PD@HB
KB0(J2(0LC@0H @@@@@@C@0)K"$0LC@0LBLNC 8NC 8OC2<SLC@0LC@[A0\GA0\GA0DAD3@0LC@0G@,KB0,KB0,KB100LC@0LA4MCP4MCP4MCPX]LC@0LC@W
APTEAPTEAPTEE3@0LC@0FP(JB (JB (JB!!$0LC@0LA(IBP$IBP$IBPPZLC@0LC@UB@ HB@ HB@ HES@0LC@0EAPTEAPTEAPTEAP0L@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[242 245 251 246 248 252 250 251 253 249 250 252 222 232 248 228 236 249 231 238 249 237 242 250 220 231 247 223 233 248 225 234 248 234 240 249 248 250 253 230 238 249 240 245 251 247 250 253 245 248 251 247 249 251 251 252 253 206 207 197 152 152 145 155 154 143 254 253 239 166 161 135 221 215 186 163 159 138 159 156 141 181 170 126 176 167 129 171 164 133 253 244 207 199 181 113 196 179 115 193 177 119 189 174 121 185 172 123 253 243 207 181 145 35 181 146 35 186 151 38 252 231 163 158 121 22 166 129 26 166 130 26 165 130 26 174 138 31 251 221 131 153 116 19 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@BA?<G?8_?1?>G?0_?A?<G?0_?A?<G?0_?A?<G?0b') ; yourself); yourself]
!

next_thread_nav
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/next_thread_nav.gif"

    "
     self next_thread_nav inspect
     ImageEditor openOnClass:self andSelector:#next_thread_nav
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary next_thread_nav'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G1<_@0LCG1<_G1<_G1<_G1<_@14]GPL_G1<_G1<_G1<_G0L\GA0CG1<_G1<_G1<_G1<AF1,[@1<_G0\@A1<_G1<_@!!\WE0L_A X@F@@FA!!<_G0LUEQTCG0<N
D1LSB X_@0PEEAPT@0LCFP$@BQL@A0LRD!!HRD!!HR@1X@F @PD@@_@1HRD!!HR@04QBP@ID@@GG1<CD!!HR@1<LB ,KB0(FG1<_G0LR@1<_G0 @B0@FA!!<_G1<_
@1<_G1<_A0@GG1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[131 112 107 173 114 18 175 117 19 177 120 19 180 122 19 180 122 20 148 126 100 179 144 132 176 161 142 178 169 152 202 181 117 224 181 117 197 187 173 203 196 194 216 201 155 210 201 191 245 202 117 247 216 155 251 221 131 245 224 138 251 224 142 251 228 157 250 233 198 253 240 195 245 245 181 250 242 206 245 242 235 254 245 212 254 249 229 254 253 239 0 0 0 0 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'G@@>@C8@O# >?#;>?????7??O/8\_  8@@@@@@@@@@@b') ; yourself); yourself]
!

pin
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/pin.gif"

    "
     self pin inspect
     ImageEditor openOnClass:self andSelector:#pin
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary pin'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC .K3H8NC 8NC 8NC 8NC 8J3@1L# 8NC 8NC 8NC 8K#@+LB<8N@TFA@ NC0,3
J3L3LB0.NC RD1TVE1$ZJ2<0L2,8NC 8AP\DBP(PCC@-K247NC 8NC\MCP4MCP4ALB43M3 8NC 7CRD\HRDAHRD!!HS\8NC 8M 4"GRH"GQP]GRL6NC 8NCPM
F2T$G"T^FBT%MS 8NC *CRX_I!!<_I!!<QG2$8NC 8@04''JB\ I2@ I2@BNC 8N@@@@@@@@@@@@@@@@C 8NC 8NC 8NC 8NC 8NC 8N@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[136 149 174 23 50 93 145 154 169 144 154 168 48 116 186 68 118 170 70 119 171 70 120 171 62 133 196 62 132 195 93 155 206 170 202 228 171 202 228 197 223 244 93 156 206 132 180 218 132 181 218 205 228 246 90 156 204 111 182 226 179 216 240 88 182 232 115 196 236 153 212 241 186 225 246 189 226 245 217 238 249 242 251 255 235 249 255 238 250 255 241 251 255 245 252 255 248 253 255 235 250 255 238 251 255 239 251 255 241 252 255 242 252 255 245 253 255 248 254 255 247 254 255 157 161 160 157 162 160 0 114 54 0 97 46 0 82 39 0 149 62 53 155 88 114 182 73 125 181 81 163 202 129 159 167 110 170 170 151 171 169 151 183 177 142 191 182 136 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@N@@<@G3??O?0??C?<O?0??C?<O?0??C?<@@@b') ; yourself); yourself]
!

pop
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/pop.gif"

    "
     self pop inspect
     ImageEditor openOnClass:self andSelector:#pop
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary pop'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JA HJB (JB HFB (JB (JA TF@ (JB HFAPXJB (J@@XA@PXE@@TF@PDF@@(JB (BA0HBA@\D
@ HG@ (JB (JB TH@0LC@0LHAP(JB (JB (JB@XDA@PFB@(JB (JB (JB $FA@PDA $JB (JB (JB TIAPTEAPTIAP(JB (JB TIAPTGBP\EAP$EB (JB @I
APTIAP@EBPTEBP@JB (JBP\IAP(JB TIA0$JB (JB (IAP(JB (JAP$JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[168 168 168 160 160 160 152 152 152 144 144 144 136 136 136 128 128 128 120 120 120 112 112 112 104 104 104 96 96 96 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@0XG#0??!!?<C? G<@_0C? _?C?>G#0LF@@@@@@b') ; yourself); yourself]
!

prev_thread_nav
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/prev_thread_nav.gif"

    "
     self prev_thread_nav inspect
     ImageEditor openOnClass:self andSelector:#prev_thread_nav
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary prev_thread_nav'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O3<?O0\@A3<?O3<?O3<CO3<?A X@FP@FA#<?O3<CH L?O0XJ
C0<OB X?O3<CG2@!!@04@C0$@BP<@A3<CGA8]F1,CE 0@F @LC@@CFA XE1\XF@LVBP@IC@@G@0PED1PU@0LCD ,KB0(FO3<?@1DPDPL?O0 @B0@FA#<?O0HN
C 8CO3<?A0@GO3<?O3<AC 8N@3<?O3<?O3<?O3<?@08NC L?O3<?O3<?O3<?O0LNC 8CO3<?O3<?O3<?O3<?@0LCO3<?O3<?O3<?O0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[131 112 107 173 114 18 175 117 19 177 120 19 180 122 19 180 122 20 148 126 100 179 144 132 176 161 142 178 169 152 202 181 117 224 181 117 245 202 117 223 209 204 251 221 131 245 224 138 251 224 142 252 224 142 233 224 198 251 228 157 251 229 157 252 229 157 250 233 198 253 240 194 253 240 195 245 245 181 245 242 235 253 245 212 254 245 212 254 245 213 253 246 213 254 249 229 254 250 228 254 250 229 254 253 239 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@C H?!!3>O?=???????8>_#88O @>@C8@G@@b') ; yourself); yourself]
!

printview_tsk
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/printview_tsk.gif"

    "
     self printview_tsk inspect
     ImageEditor openOnClass:self andSelector:#printview_tsk
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary printview_tsk'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
ST5MST5MST5MST5MST5MST5MST5GQ4]GQ4]MST5MST5MST5MQ34C@0MLQ4]MST5MST5MST 4MCP@R4)LRD5MST5MST5FBS$-KP$3BTYMST5MST5MRR0ZA0XE
AB1IST5MSPD @$L\J3\+GCH+P0H @T4 PDADJ!!(GA TDF4Q@PBAMG3<<QR &B@ (I0!!EN#8WSQX8N4IAPTEAPTEAP#,;ET4TJSD1M#X6M"$)M#X6M!!QMG#@5
ICT0LC@$IBT$MRTSSQH.H28.K"8#H"8#K2L.DT4PDA4PC0<PD@8]C0<PDAAM@P4YHRDYHQ YHQ YHP4AST4AB ,JB (JC@(LB (ASP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[245 247 252 166 181 213 54 85 146 249 250 252 94 118 163 108 131 172 122 144 184 136 156 193 220 230 248 240 244 251 89 120 171 90 120 171 89 120 170 92 123 173 96 127 177 96 126 176 96 127 176 100 131 180 100 130 179 105 134 182 108 138 186 112 142 189 112 141 188 115 145 192 126 155 203 126 155 202 145 165 199 225 234 249 230 237 249 95 127 176 104 135 183 115 145 191 117 147 193 126 156 202 183 201 228 183 201 227 197 211 232 197 211 231 219 231 248 219 230 247 220 231 248 211 221 236 224 234 249 229 237 249 235 241 250 240 244 250 182 201 227 183 202 227 197 212 232 212 222 236 230 238 249 239 244 251 244 247 251 197 212 231 211 222 236 229 238 249 224 231 240 240 245 251 235 239 244 224 232 240 235 239 243 248 250 252 236 240 243 235 240 243 243 245 246 152 152 145 156 155 143 175 167 129 168 162 134 161 157 138 189 175 119 199 181 113 195 178 115 183 171 124 218 194 124 228 207 157 208 171 91 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@O0@?0C? O>@?8_?=??7??_?=??7??_?=??7??O?8b') ; yourself); yourself]
!

prop_ps
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/prop_ps.gif"

    "
     self prop_ps inspect
     ImageEditor openOnClass:self andSelector:#prop_ps
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary prop_ps'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
RD!!HRD!!HRD!!HRD!!HRD!!HRD GA0 BCP8ODAH]ER,!!H$!!HQ$MCPP@7L#<>LS40K2IHR@\GBP,MF!!0QD1P_E"D"RD .Q4]GNT]GQ4]GQ4]GK$!!HKC(:N4LYJTUC
N!!$:P2MHRB5GQ4\<Q4]GQ4]GQ4\-RD  JDP(JCT(P" (MR 5HD!!HG$]GQ3YGQ4]GQ4]GQ1QHR@P4M@X''MC XFB\FMA *RD CQ4]GL$]GQ4]GQ4]GF4!!HCD@%
PD@WL2T3E0T$P@5HR@EGQ4\&Q4]GQ4]GQ4\JRD GA0\GA0\GA0\GA0\GA4!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HR@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[168 176 192 95 111 140 96 112 140 106 121 148 112 127 153 184 193 209 189 197 212 91 108 137 93 110 139 93 110 138 95 112 140 96 113 141 99 116 144 99 116 143 103 119 146 107 123 149 111 127 153 111 127 152 115 130 155 116 131 156 119 134 158 123 138 162 126 141 165 184 193 208 188 197 212 199 207 220 103 120 146 105 122 148 107 124 150 119 135 159 118 134 158 123 138 161 125 140 163 129 144 166 131 146 168 136 150 171 184 194 209 183 193 208 182 192 207 189 198 212 194 203 216 198 207 220 111 128 152 126 142 164 135 151 172 131 146 167 139 154 174 164 176 192 166 178 194 173 184 199 186 196 210 184 194 208 188 198 212 193 203 216 191 201 214 190 200 213 188 198 211 200 209 221 199 208 220 198 207 219 197 206 218 169 181 196 176 188 203 181 192 206 183 194 208 195 206 219 194 204 216 198 208 220 193 204 216 198 208 219 144 160 176 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A??''?>_?9??''?>_?9??''?>_?9??''?>_?9?? @@@@@b') ; yourself); yourself]
!

push
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/push.gif"

    "
     self push inspect
     ImageEditor openOnClass:self andSelector:#push
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary push'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
T%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRE!!<_E%IRT%IRT%IRT%IRD1$YE1$ST%IRT%IRT%ACP04UEAPUCT5CTEIRT%IHP 0RD!!DRD!!HKP$IRT%IRK2$HB@ H
B@ HBB]BT%IRK2P/HP HB@ HB@ ''Q5IRK3,(N2<!!B@(IBP$HI$ERK#89J3$>LA8GF!!(ZA2UDKCH*J"(*J"(-C $IBP@#Q%H8PC41OT@8A DA@PDAH$URT#\?
OC<6F@PJBP$IABAJT%IRMS(4GA@PDA@PDA@[RUIRT%H3AQ4]GQ4OC0<O@4-RT%IRS@HB@ HB@ HB@ INT%IRT%EOS4=OS4=OS4=OTP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[241 243 250 236 240 249 135 148 173 140 150 170 231 237 249 209 213 221 247 249 253 245 247 251 248 249 251 94 118 163 109 132 173 95 115 150 96 115 150 113 130 160 197 206 222 223 232 248 226 234 248 128 148 180 129 148 180 130 145 170 151 167 192 152 167 192 142 155 176 175 186 204 245 248 253 174 186 204 245 247 250 146 155 166 243 247 252 216 232 248 251 252 253 171 193 212 153 159 161 252 253 253 161 164 156 169 169 150 254 253 239 176 173 145 183 178 141 187 180 138 253 249 226 228 225 208 252 237 185 253 243 207 178 142 33 177 143 33 183 147 37 186 151 38 182 147 37 252 230 163 253 237 185 158 121 22 162 125 24 161 124 24 166 129 26 166 130 27 172 136 30 212 184 101 251 221 131 195 170 102 252 225 144 211 174 80 195 166 94 194 154 65 194 157 74 208 172 120 212 176 123 197 154 97 206 169 118 199 162 114 202 165 116 211 174 122 238 223 202 193 155 108 196 158 111 190 152 107 228 213 195 173 129 82 188 150 106 181 144 103 228 214 198 212 193 175 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@<@G8C?<O?0??G?<??7????=??3??G?<O?0??C?<b') ; yourself); yourself]
!

rem_all_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/rem_all_co.gif"

    "
     self rem_all_co inspect
     ImageEditor openOnClass:self andSelector:#rem_all_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary rem_all_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
C0<A@ <OC0<O@ DOC0<OC0<AB@DBC0<O@ DH@P<OC0<O@PLC@P DB@DC@0DDC0<OC0H@@0LG@@\C@0@BC0<OC0<OB@(C@0LC@0(HC0<OC0<OC0<J@PLKA0DJ
C0<OA0,OC0<HB0LKB ,GB0 OA0,JB0<HB0LEB0XFB0(EB ,FA ,OB0LCB0\LA0\IC@$GA00GC0,@B0 OB 4HB@ HB@4JC0<OB0 OC0<MB0$IBP,MC0<OC0<O
C0<JC (JB (JC (OC0<OC0<JC (JC@8LB (NB <OC0<EC (JC (EB 8JB 8OC0<OC08LC (OC0<JC 0NC0<OC0<OC (OC0<OC0(NC0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[136 136 128 144 144 136 168 168 160 216 216 216 176 176 176 168 168 168 160 160 160 152 152 152 144 144 144 136 136 136 128 128 128 120 120 120 112 112 112 104 104 104 96 96 96 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'LFA8<G?8_?@?8A?FO>=??7??^?81?@O>A?<O?0^O@0Xb') ; yourself); yourself]
!

rem_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/rem_co.gif"

    "
     self rem_co inspect
     ImageEditor openOnClass:self andSelector:#rem_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary rem_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JA HJB (JB HFB (JB (JA TF@ (JB HFAPXJB (J@@XA@PXE@@TF@PDF@@(JB (BA0HBA@\D
@ HG@ (JB (JB TH@0LC@0LHAP(JB (JB (JB@XDA@PFB@(JB (JB (JB $FA@PDA $JB (JB (JB TIAPTEAPTIAP(JB (JB TIAPTGBP\EAP$EB (JB @I
APTIAP@EBPTEBP@JB (JBP\IAP(JB TIA0$JB (JB (IAP(JB (JAP$JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[168 168 168 160 160 160 152 152 152 144 144 144 136 136 136 128 128 128 120 120 120 112 112 112 104 104 104 96 96 96 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@0XG#0??!!?<C? G<@_0C? _?C?>G#0LF@@@@@@b') ; yourself); yourself]
!

removememory_tsk
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/removememory_tsk.gif"

    "
     self removememory_tsk inspect
     ImageEditor openOnClass:self andSelector:#removememory_tsk
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary removememory_tsk'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JA HJB (JB HFB (JB (JA TF@ (JB HFAPXJB (J@@XA@PXE@@TF@PDF@@(JB (BA0HBA@\D
@ HG@ (JB (JB TH@0LC@0LHAP(JB (JB (JB@XDA@PFB@(JB (JB (JB $FA@PDA $JB (JB (JB TIAPTEAPTIAP(JB (JB TIAPTGBP\EAP$EB (JB @I
APTIAP@EBPTEBP@JB (JBP\IAP(JB TIA0$JB (JB (IAP(JB (JAP$JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[168 168 168 160 160 160 152 152 152 144 144 144 136 136 136 128 128 128 120 120 120 112 112 112 104 104 104 96 96 96 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@0XG#0??!!?<C? G<@_0C? _?C?>G#0LF@@@@@@b') ; yourself); yourself]
!

restart_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/restart_co.gif"

    "
     self restart_co inspect
     ImageEditor openOnClass:self andSelector:#restart_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary restart_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
N3,;N3,;N3,;N3,;N3,;N3,;N3,;N3,;KS(JN3,;N3,;N3,;N3,;N3(8N!!0LN3,;N3,;N3,;N3,:A@PDN#T;N3,;N3,;N3,;N TEEQTEN#,;N3,;N3,;N3(F
A X:M3,;N3,;N28;N3,:M#((CC,;N3,;N3$BHS,;N#(JN3,;N3,;N1<BK@H+N3,;N3,;N3,;N0,QA0\GDSP;N3,;N3,KN3,A@RLP@PDCN3,;N3,CD@L;N3,W
J!!L;N3,;N3,;D2@WN3,;JP<XIC,;N3,;IQ OLC,;N08''F!!$RBBXHD!!$ZGQ,;N3,;C 4I@@@@@@@ICQ8;N3,;N3,1L!!PVE!!P3K2H;N0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[252 229 166 172 121 25 249 242 219 173 121 25 128 184 128 88 168 112 72 160 96 253 246 222 166 114 23 239 212 145 192 216 200 175 123 26 192 224 208 176 130 52 213 190 148 252 235 188 253 243 212 249 240 212 167 114 23 170 118 24 163 110 22 80 168 112 163 110 21 171 119 24 239 217 163 239 215 153 252 232 176 217 194 155 80 160 120 177 131 52 216 194 155 176 125 26 253 239 200 177 126 26 215 193 155 172 120 25 172 123 35 172 124 35 166 114 22 177 130 53 56 144 96 168 116 23 252 239 200 177 125 27 253 248 229 69 153 108 179 128 27 185 144 76 169 116 23 212 189 147 187 147 82 164 110 22 175 123 25 64 152 104 96 176 96 112 176 136 144 192 128 178 127 26 24 128 72 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@8@C8@O0@? C<BO \8C8@_0I?A10GG <_?0?>A?0b') ; yourself); yourself]
!

resume_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/resume_co.gif"

    "
     self resume_co inspect
     ImageEditor openOnClass:self andSelector:#resume_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary resume_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HQ(YE!!XZHPHBHRD!!HRD!!HRD[D1LSF2DBD HBHRD!!HRD!!F1PTEA,!!@!!@P
DPHBHRD!!HQ<TEQP_HPHNC 8MCPDCHRD_FA0XG2DBA@PDA@PEA@D!!G1 \FA<!!@PXFA \GB@\AHQ<TE1P_HP@IBP$JB @CHRD]EAPTGRD@B0,L@@@!!HRD!!GQLS
D14!!@@<@@BD!!HRD!!HR@^G!!8 HP@@HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[37 117 80 45 124 88 54 130 94 65 158 99 88 171 113 88 170 113 77 167 102 77 167 101 77 166 101 97 175 97 97 176 96 109 181 95 109 181 94 147 197 135 147 197 134 120 186 94 162 203 139 163 203 138 172 207 142 248 248 232 248 240 176 248 232 152 184 152 40 248 224 136 240 224 168 190 156 40 208 184 104 184 144 32 248 216 128 168 128 24 160 120 24 176 136 32 192 160 96 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@_XA=8G78__9=?77?__9=>G7 _X@@@@@@@@@b') ; yourself); yourself]
!

runlast_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/runlast_co.gif"

    "
     self runlast_co inspect
     ImageEditor openOnClass:self andSelector:#runlast_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary runlast_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
ZF EPCPDEQ$NZF!!(ZF!!(ZF HIEAST$-AGP%(ZF!!(ZF PG4)MU%ENSD$\DV!!(ZF!!(E#5GJ&]US4!!DP1)(ZF!!(ZA,?O#)''Y5]TQSTJZF!!(ZF BK#D9Y6]''Q$HW
@F!!(ZF!!(A",&NF]''M2\#H@M(ZF!!(ZA ^KSY''K2 ,C1PLZF!!(ZF "D#H<M3L0C6HOC6I"ZF!!(Z@4SHRT)C6IYX#-"VFI(ZF!!(C0,G@P="VE)"X%!!^X&!!(ZF!!(
ZF!!(X%5ZV%)ZV%1#ZF!!(ZF!!(ZF!!&XE-[V5- Y&!!(ZF!!(ZF!!(ZFQ$YFE_YF!!(ZF!!(ZF!!(ZF!!(ZFU_YV!!(ZF!!(ZF!!(ZF!!(ZF!!%YV!!(Z@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[67 147 94 72 148 95 50 132 73 67 148 91 73 145 93 179 210 188 45 132 68 63 149 86 135 189 149 165 207 176 77 151 95 116 180 131 128 184 142 163 206 173 190 218 197 198 220 203 198 218 203 215 228 218 60 147 78 67 151 85 65 146 82 77 150 93 96 167 112 86 146 99 114 176 127 129 184 141 115 177 127 65 141 78 78 152 90 82 152 94 60 141 72 74 147 84 81 154 91 93 164 104 217 230 219 47 124 56 77 151 86 91 164 99 42 125 50 53 132 61 69 141 76 84 160 92 192 213 194 47 127 53 62 143 68 68 144 73 58 119 62 182 210 184 55 140 59 54 118 58 72 152 76 58 136 61 68 147 70 108 164 109 176 206 177 184 211 185 173 203 173 173 202 173 183 208 183 245 248 245 184 210 183 93 157 88 84 143 79 90 146 84 116 182 108 113 166 103 74 136 59 108 163 95 111 164 96 108 163 89 203 220 197 114 166 94 101 163 72 134 180 110 135 180 110 150 186 129 146 185 120 186 216 166 129 180 88 157 213 96 133 206 46 158 213 95 152 191 109 174 222 114 174 220 118 251 255 246 249 254 240 254 255 248 248 248 232 254 253 239 248 240 176 248 232 152 240 216 128 248 224 136 240 224 168 248 208 96 248 216 120 248 216 128 176 131 25 176 124 20 161 110 15 154 104 15 169 117 20 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O8A?0O? ?>C?8O? ?>C?8O?8_?0?? G?@O<@_ @\@A b') ; yourself); yourself]
!

runtoline_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/runtoline_co.gif"

    "
     self runtoline_co inspect
     ImageEditor openOnClass:self andSelector:#runtoline_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary runtoline_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
CP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4M@PH@@ DMCP4MCP4MCP4MCP4M@P4MCP4MCP4MCP4MCP4MCPDMCP4MCP4MCP4IBP4MCP4ACP4MCP4MCP4MBPLI
CP4M@P4MCP$IBP$IBP$C@0$MCPDMCP(DA@\EAP\DA TEB04ACP4MC@0LC@0LC@ HC@4M@P4MCP4MCP4MCP0HC@4MCPDMCP4MCP4MCP4LC@4MCP4ACP4MCP4M
CP4MCP4MCP4M@P4MCP4MCP4MCP4MCP4MCPDMCP4MCP4MCP4MCP4MCP4ACP4MCP4MCP4MCP4MCPDB@@HACP4MCP4MCP4MCP4MCP4MCP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[186 199 223 75 110 162 100 132 181 254 253 239 253 242 198 253 241 198 253 241 199 253 242 199 252 230 158 178 130 24 170 120 22 170 121 22 161 110 18 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@G0@D@@PA!!@GD_>S?=G?$@\PA!!@@D@@P@A@@_@@@b') ; yourself); yourself]
!

skip_brkp
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/skip_brkp.gif"

    "
     self skip_brkp inspect
     ImageEditor openOnClass:self andSelector:#skip_brkp
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary skip_brkp'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
FQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFP@AFQ$YFQ$YFQ$YFQ$YFQ$Y@@DYFQ$YFQ$YFQ$YFQ$YFQ$@@Q XFA XFQ$YFQ$YFQ$YFP@A@0TD
DA YFQ$YFQ$YFQ V@@DUC0HKFA$YFQ$YFQ$XAAH@@QLJAA YFQ$YFQ$YF@TFE0@ACPTXFQ$YFQ$YFQ DA0 N@@DCFA$YFQ$YFQ$XB0HICAD@@Q YFQ$YFQ$Y
FQ PA@TDE@@AFQ$YFQ$YFQ$YFA XFA Y@@DYFQ$YFQ$YFQ$YFQ$YFQ$@@Q$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFQ$YFP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 15 111 111 153 199 62 110 145 167 192 209 74 126 160 50 100 130 106 167 202 105 161 194 113 171 203 130 177 204 129 174 199 143 190 216 144 190 215 151 194 218 156 196 219 151 187 207 168 204 225 167 200 219 167 198 216 182 213 230 194 219 234 202 224 237 201 223 236 138 186 212 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C@@F@@O8@_0C? O>@?8C? O>@_8@>0@A @@@@@b') ; yourself); yourself]
!

stepbystep_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/stepbystep_co.gif"

    "
     self stepbystep_co inspect
     ImageEditor openOnClass:self andSelector:#stepbystep_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary stepbystep_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[EAP[F1,[F1,[F1,[F1,[F1HHD!!,[F1PTEAPTEALSD1LSDP SF1PKB0,KB0,KB1@PDA@PA!!T[EAPTEAPDB TV
E!!XOA!!X[F1,[F1,[E@(TF1,XA!! [F1,[F1,[F1PIEA,[E1\[F1,[F1,[F1,TC!!P[F1,[F1,[F1,[F1PTE@4TEAP[F1,[F1,[F1,YA 0LC@XYF1,[F1,[F1,[
F1(FA0XZF1,[F1,[F1,[F1,[F XZF1,[F1,[F0HA@PH[F1,ZF1,[F0HA@PHC@@@CF1,[F1,[F1,C@@@CF1,[F1,[F1,[F1,[F1,[F0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[58 67 95 103 124 149 86 137 180 79 89 95 214 192 125 210 186 119 252 225 150 252 229 167 252 231 173 254 245 219 254 248 231 254 250 239 252 232 179 253 236 192 253 240 207 254 243 215 254 246 225 254 248 233 178 127 26 176 126 26 179 128 27 175 124 26 174 122 25 170 118 24 172 120 25 171 120 25 162 109 21 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@F@@\_?;??7?>@90C&@N@C>@O8@_@@8C1C?@O@@@b') ; yourself); yourself]
!

stepinto_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/stepinto_co.gif"

    "
     self stepinto_co inspect
     ImageEditor openOnClass:self andSelector:#stepinto_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary stepinto_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HOC0<OC0<GD!!HRD!!HRD!!HOB0,KB0,KC0TRD!!HRD!!HRD <OC0<OA@(O
D!!HRD!!HRD!!HRD!!HRD <IC1HRD!!HRD!!HRD!!HRD!!HOC <RD!!HRD!!HRD!!HRD <OC04OC0<RD!!HRD!!HRD!!HPC@0LC@0PD!!HRD!!HRD!!HRD!!DHB@ QD!!HRD!!HRD!!HR
D!!HRDPXQD!!HRD!!HRD HA@PHRD!!HQD!!HR@ DA@!!HC@@@CD!!HRD!!HRD L@@@LRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[58 67 95 103 124 149 86 137 180 79 89 95 214 192 125 210 186 119 252 227 159 217 197 143 252 229 167 254 245 219 254 248 231 254 250 239 252 232 179 253 236 192 253 240 207 179 128 27 171 120 25 162 109 21 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@O8A?0C?@@\@A0@_0A?@C8@G@^H=8C0@@@@@b') ; yourself); yourself]
!

stepover_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/stepover_co.gif"

    "
     self stepover_co inspect
     ImageEditor openOnClass:self andSelector:#stepover_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary stepover_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
EQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUA1HPDA@PDAHGEQTUEQTUA1DNB0,KB0,NDPPUEQTUA1DJBQ@PDA@P
BP(QA!!TUEQ@JBQ@UEQTUEQ@IB!!@UEQTPC1@UEQTUEQTUD@<PEQTUD04SEQTUEQTPDA@MDA@PEQTTEQTUEQTUD0TLC@0ED1TUEQTUEQTUEQTTAP EEATUEQTU
EQTUEQTUEQPEEATUEQTUEQTB@PDBEQTUEATUEQTUEQTU@0@@@1TUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEP@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[58 67 95 103 124 149 86 137 180 79 89 95 210 186 119 252 227 159 216 196 138 217 197 143 252 229 167 234 216 167 254 245 219 254 250 239 252 232 179 253 236 192 237 224 190 253 240 207 179 128 27 190 142 46 197 151 58 171 120 25 162 109 21 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G?@?>G?<^C10GGA?HG<@O @\A8 G @@@@@\b') ; yourself); yourself]
!

stepreturn_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/stepreturn_co.gif"

    "
     self stepreturn_co inspect
     ImageEditor openOnClass:self andSelector:#stepreturn_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary stepreturn_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
F!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(QDQ(ZF!!(ZF!!(ZF!!(ZF!!(ZC0 OF!!(ZF!!(ZF!!(ZF TP
DA@NBA@ZF!!(ZF!!(ZF \RCP4MCP4HD!!(ZF!!(ZF!!(UC@PUEP0FEQ(ZF!!(ZF!!(ZE0,WF!!\FE1(ZF!!(ZF!!(ZF!!XJE!!(VE!!(ZF!!(ZF!!(ZF!!(SBQLZF!!(ZF!!(ZF!!(Z
F!!(ZE@ TF!!(ZF!!(ZF HA@PHZF!!$FFQ(Z@ DA@!!(C@@@CF!!(ZFA(ZF L@@@LZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[58 67 95 103 124 149 86 137 180 79 89 95 214 192 125 210 186 119 252 229 165 217 197 143 252 231 173 253 234 183 253 237 194 254 240 205 254 243 215 254 246 225 254 248 233 178 127 26 176 126 26 179 128 27 175 124 26 168 115 23 166 114 23 174 122 25 170 118 24 172 120 25 163 110 22 165 112 23 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@A @G@C>@_<A? G\@] A0@G@^\=8#0@@@@@b') ; yourself); yourself]
!

suspend_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/suspend_co.gif"

    "
     self suspend_co inspect
     ImageEditor openOnClass:self andSelector:#suspend_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary suspend_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$C08NC <$C08NC <$IBP$I@8A@@@NI@8A@@@NIBP$IBPL@@H@CBPL
@@H@CBP$IBP$CPTCA 4$CPTDA 4$IBP$I@,UEA8KI@,UBA8KIBP$IBPXGQD]FBPXGQ(]FBP$IBP$E1,YF1\$E1,YF1\$IBP$IAXSDA0VIAXSDA0VIBP$IBP 
BP\IHBP BQHIHBP$IBP$HP(JB"D$HP(JB"D$IBP$IBL_G1<"IBL_G1<"IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$I@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[254 254 244 254 254 247 254 253 239 253 247 217 253 246 217 254 249 228 254 249 229 252 236 180 252 237 185 253 242 203 254 246 217 184 148 37 189 154 39 186 151 38 190 156 40 210 186 105 252 227 151 251 227 152 253 236 181 253 236 182 253 237 185 253 242 206 175 137 32 178 141 34 182 145 35 251 221 131 252 227 153 252 231 168 253 235 183 253 235 184 254 242 206 167 126 28 173 133 31 170 130 30 194 166 97 194 165 97 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G70__A=<G70__A=<G70__A=<G70__@@@@@@b') ; yourself); yourself]
!

synced
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/synced.gif"

    "
     self synced inspect
     ImageEditor openOnClass:self andSelector:#synced
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary synced'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
C0<OC0@@C0<OC0<OC0<OC0<OC0@G@@<OC0<OC0<OC0<OC0@GA0@OC0<OC0<OC0<OC0@LCP,@@@@@@@@@C0<OC0@EA XEA TEA TEAPDOC0<O@P HB@DA@PDA
@PDOC0<OC0<AA@PAC0<OC0<OC0<OC0<OC0DD@P<OC0<@B <OC0<OC0<O@PDOC0<O@@@JC0<OC0<OC0<OC0<OC0@G@@@OC0<OC0<@@@@@@@@@BP$I@@<OC0<@
@08C@0LC@0LC@0L@C0<OC0HB@ HB@ HDA@PBC0<OC0<OC0<OC0<BA@PBC0<OC0<OC0<OC0<O@ PBC0<OC0<OC0<OC0<OC0HBC0<OC0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[189 132 22 170 111 16 166 107 16 252 236 177 251 229 151 252 241 195 253 241 195 254 253 239 252 234 169 253 246 213 186 151 38 254 248 222 254 248 221 253 248 221 251 236 177 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'C@@\@C0@_?C?>G?0O@@\L@08@C0O?!!??C?8@O@@8@C@b') ; yourself); yourself]
!

terminate_all_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/terminate_all_co.gif"

    "
     self terminate_all_co inspect
     ImageEditor openOnClass:self andSelector:#terminate_all_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary terminate_all_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
J"(*J"(*J"(*J"(*J"(*J"(&FA XFA XFA XI"(*J"(*E1$YFQ$YFQ$YFQ\*J"(*J!!\(IRT%IRT%IR ZJ"(*J"(]JPXFA XFA P)G"(*J"(*GR$EARPVE!!XV
E!!XVE!!X$J"D''@ HUF1,[F1,[F1,[ER(!!B0(JERL HB@ HB@ H1T*DR\B@!!0$B@ HB@ HBBP\J 8)@0L\I@\GA0\GA0\$GB(NJB (G2H@@@@@@@@@H!!0*E@8O
D!!<ICP4MCP4MCP$_J"(*J"(PH @@@@@@@@@"DB(*J"(*CBPA@PDA@PDAI@0*J"(*J 0#H2L#H2L#H2LLJ"(*J"(SC@0LC@0LC@0LD0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[232 48 56 232 56 64 244 161 164 244 164 167 244 165 168 244 167 170 244 170 173 232 64 72 232 72 80 240 104 112 244 155 161 249 192 195 192 16 32 232 32 48 198 38 52 203 57 70 200 40 56 205 59 74 226 144 152 208 96 112 212 110 125 200 80 64 200 88 72 205 96 81 205 103 89 252 222 218 209 110 97 248 176 168 200 64 56 205 81 74 227 158 154 184 56 56 232 80 80 190 74 74 240 120 120 248 168 168 216 152 152 244 173 173 220 161 161 249 198 198 252 218 218 239 212 212 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A?<G?0_?A?<G??_?=??7??_?=??7??A?<G?0_?A?<b') ; yourself); yourself]
!

terminate_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/terminate_co.gif"

    "
     self terminate_co inspect
     ImageEditor openOnClass:self andSelector:#terminate_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary terminate_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRDP(JB (JB (JB!!DRD!!HRD $KB0,KB0,KB0,ID!!HRD!!HID@8NC 8N
C 8PBQHRD!!HRCADC@0LC@0LCDP0RD!!HRD 0Q@ HB@ HB@!!DLD!!HRD!!HMC0@@@@@@@@@OCAHRD!!HRCPPFA XFA XFA@4RD!!HRD \O@@@@@@@@@@<GD!!HRD!!HE
DPDA@PDA@PDQAQHRD!!HRAQ@PDA@PDA@PD@TRD!!HRD  EAPTEAPTEAPTHD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[232 48 56 232 56 64 232 64 72 232 72 80 240 104 112 192 16 32 232 32 48 200 40 56 208 96 112 200 80 64 200 88 72 248 176 168 200 64 56 184 56 56 232 80 80 240 120 120 248 168 168 216 152 152 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G?0_?A?<G?0_?A?<G?0_?A?<G?0_?@@@@@@b') ; yourself); yourself]
!

terminate_rem_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/terminate_rem_co.gif"

    "
     self terminate_rem_co inspect
     ImageEditor openOnClass:self andSelector:#terminate_rem_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary terminate_rem_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
Q4]GQ4]GQ4]GQ4]GQ4]GQ4\-H2T$IBP%H25GQ4]GQ4]GI"8+KB0,J28&Q4]GQ4]GQ2\LAPXFA TLI4]GQ4]GQ4\)CQ@QDQDPCR)GQ4]GQ4]GK0$NC0<OC  (
Q4]GQ4]GQ0\REATUEQ(SB$]GQ4]GQ4\\@@LDA@,_M15GQ4\7G4]GE#@A@ H"N#L5Q4\5L3("Q18WFQ XF3 3L#$9L#L8Q4]GQ4]GQ4]GP#\4MC]BQ4]GQ4]G
Q4]GQ2D?M#X?HT]GQ4]GQ4]GQ4]EOC,;ODUGQ4]GQ4]GQ4]DO#5@PC4>QD]GQ4]GQ4\1Q$D>Q4\>PTX1Q4]GQ4]GQ2ACQ4]GQ4L Q0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[230 109 110 247 136 138 246 139 141 231 34 43 230 42 50 231 58 64 230 67 72 199 70 74 239 98 103 240 99 103 212 114 117 240 131 136 232 132 135 221 127 131 231 40 50 232 47 56 234 58 67 232 66 74 242 84 93 247 156 161 231 28 43 232 35 49 199 42 55 204 46 58 204 52 65 203 53 65 241 123 132 232 165 171 203 55 69 242 204 208 207 81 96 163 162 161 149 148 147 145 144 143 181 180 179 209 105 90 210 111 97 210 112 97 210 98 84 206 95 85 206 81 74 203 87 79 202 87 79 244 146 140 245 149 143 213 137 132 254 176 172 195 76 74 244 173 172 177 176 176 145 145 145 144 144 144 141 141 141 139 139 139 138 138 138 137 137 137 134 134 134 132 132 132 129 129 129 127 127 127 123 123 123 121 121 121 120 120 120 117 117 117 116 116 116 115 115 115 114 114 114 113 113 113 111 111 111 109 109 109 105 105 105 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A?0G?@_<A?0G?@_<A?1''?O_?8@?@C<@O0A? OO@XXb') ; yourself); yourself]
!

tnames_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/tnames_co.gif"

    "
     self tnames_co inspect
     ImageEditor openOnClass:self andSelector:#tnames_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary tnames_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
M#X6M#X6M#X6M#X6M#X6M#X6M 0HB#X6M#X6M#X6M#X6M 0OA0$6B <6M#X6M#X6M#XOA0\IB \HM#X6M#X6M#XHC00GC0\IM#X6M#X6M#X6B#@LA0\JKB(0
KR4-KR4-M#DFB \HAPXFA XFA XFKSX+A <GBPTLB@XFA XFA"86C@<GA0<IC0(@AAX@HBD(M <HC@\GA0 "D!!H_D!!H_K0(HC@LHA0 ]C!!0\C!!0B@"$6I!!(Z
G!!DQC!!PACQPAEAT$M#HPC0<YC0<YC0<YL3T4MCX%D0\GD0\GD0\GD3T4MCX6H1\[B1 [B1 [B1 4MCX6M"\''I2\''I2\''I2\''MCX6M @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[247 248 252 235 240 250 239 243 251 242 245 251 246 248 252 250 251 253 249 250 252 81 111 163 144 164 200 167 183 211 189 201 222 223 232 248 211 219 233 235 240 249 239 243 250 132 155 194 230 237 248 238 243 251 243 246 251 226 235 248 235 241 250 234 240 249 247 249 252 222 233 248 223 233 247 230 238 249 239 244 251 222 233 247 239 244 250 242 246 251 238 244 251 243 247 251 246 249 252 247 249 251 245 249 252 160 157 140 175 167 129 189 186 170 225 222 207 155 153 143 192 177 118 181 170 125 226 217 181 223 215 183 234 228 202 199 181 113 196 179 116 187 173 121 215 202 153 213 200 154 211 207 192 224 200 143 212 178 104 218 189 124 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@\@C6@O8A?@G??_?=??7??_????7??_?=??''?<_? b') ; yourself); yourself]
!

toggledetailpane_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/toggledetailpane_co.gif"

    "
     self toggledetailpane_co inspect
     ImageEditor openOnClass:self andSelector:#toggledetailpane_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary toggledetailpane_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I2T%IRT%IRT%IRT%IRT%IR\%EAPTEAPTIQPTEAPTEBT''I!!PZF!!(ZF"XTAPPA@A(&I2PTF!!(ZF!!($EA(ZF!!(ZIB\#EAT]E!!X]H1PEA@D@E"L''H!!PWE1\WE2HT
E1\WE1\"I2DTFA,XFA,!!E@TD@P@XHR\ EA0\GA0\HAP\GA0\GB@''D!!P^FQ$YFQHTAPPA@A$RI0\TD1<_G1<GEAL_G1<_A2\F@ HB@ HBA HB@ HB@ X''I2\''
I2\''I2\''I2\''I2\''I2\''C 8NI2\''I2\NC 8''I2\''I1@O@2\''I2\''@0<KI2\''I2\Q@1DJB@ HB!!DCDR\''I2\''I2\IB 4LC@(II2\''I0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[144 161 197 153 169 201 136 149 174 140 165 210 162 178 206 168 184 208 139 152 171 145 154 168 195 206 221 172 187 206 100 134 166 0 78 141 0 60 110 0 60 109 0 85 151 0 78 140 0 79 140 0 70 125 150 158 164 250 253 255 213 243 255 234 249 255 235 249 255 238 250 255 241 251 255 248 253 255 233 249 255 240 251 255 244 252 255 235 250 255 247 253 255 251 254 255 157 161 160 163 166 155 170 170 150 177 174 146 183 177 142 191 182 136 188 180 138 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??0@@GA0\GA?<A?@b') ; yourself); yourself]
!

var_cntnt_prvdr
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/var_cntnt_prvdr.gif"

    "
     self var_cntnt_prvdr inspect
     ImageEditor openOnClass:self andSelector:#var_cntnt_prvdr
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary var_cntnt_prvdr'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
EAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTA1PTEAPTEAPTEAPTEAPTB@PHEAPTEAPTEAPTEAPTE@HC@!!PJA TTEAPTB0,TE@$C
@0LIEAPTEAPTE@,OB1PTE@LTEAPTEAPKB0,KC0<KEAPCEAP@@@@TDQDNCQHQDQ@T@0LC@@D@EALSD1LLCALTE@LTE@@@@APTEAPSCALTEAPCEAPTEAPTEAPT
D1LTEAPT@1PT@@@@EAPTEAPTEAPTE@LC@0@A@APTEAPTEAPTEAPTEAP@@@@TEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTE@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[222 93 107 235 152 162 104 128 174 94 121 171 101 126 173 105 131 179 114 139 186 115 137 178 171 180 197 136 154 185 162 177 200 187 149 41 252 227 159 253 239 199 253 239 200 254 250 239 178 138 37 253 238 199 253 238 200 169 126 32 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@ @G@@]038C"A?I7>?_2\NH@0''@C<@A0@@@@@b') ; yourself); yourself]
!

writeerr_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/writeerr_co.gif"

    "
     self writeerr_co inspect
     ImageEditor openOnClass:self andSelector:#writeerr_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary writeerr_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8IBP$IBP$IBP$IBP$^G!!8\BQ@PDA@PDA@PDA@IG!!8RF0$P@ DH@PHHB@ HBQ8^FQ(ID@DB@@HAB@PCB@$^D!! YBQ@F@@H@
A XFA XIG!!\WF@$P@PH@@ DNA@LNBQ8KB00ID@HAAPDBAPTEAP$^B!!@QBQ@EAPTEAPTEAPTIG (PA0$IBP$IBP$IBP$IBQ8JD@4MCP<LE!!4]FA RG!!8^B!!@E
APTEB!!T]E1H^G!!8^G (JB (JB (TD18^G!!8^G!!8^G (JB!!8^G!!8^G!!8^G!!8^G (JB (JG!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[215 114 121 221 153 157 193 60 70 97 113 154 105 121 162 231 238 249 237 242 250 196 200 206 241 245 251 84 140 208 85 124 172 94 131 176 102 136 179 194 199 205 234 241 249 193 199 205 217 241 252 182 199 207 224 224 222 222 222 220 212 212 211 209 209 208 204 204 203 196 196 195 192 192 191 189 189 188 185 185 184 178 178 177 173 173 172 198 198 198 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@O?1??O?<??7??_?=??7??_?=??G?0_<@\@C8@@@@b') ; yourself); yourself]
!

writeout_co
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/elcl16/writeout_co.gif"

    "
     self writeout_co inspect
     ImageEditor openOnClass:self andSelector:#writeout_co
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary writeout_co'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
H2L#H2L#H2L#H2L#H2L#H2L#H2LMCP4MCP4MCP4MCP4#H2L!!CQPTEAPTEAPTEAPMH2LVH@4TC@0LC@0LC@0LCRL#G!!<ME@ GA@D@@@0LC@4#E!!4^CQPJB (J
B (JB (MH10\GP4TB@ FAPLB@@@RCRLOC1@ME@$IBP$IBP$IBP4#C!!PUCQPIBP$IBP$IBP$MH08TB04MCP4MCP4MCP4MCRLNEADQDQLPF2H"GQ4VH2L#C!!PI
BP$IC1("GA\#H2L#H08NC 8NC 8YFBL#H2L#H2L#H08NC"L#H2L#H2L#H2L#H08NC 8NH2L#H2L#H2L#H2L#H2L#H2L#H2L#H2L#H0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[97 113 154 105 121 162 103 120 160 110 128 168 115 133 173 120 138 177 128 146 185 125 145 184 133 153 191 231 238 249 237 242 250 196 200 206 241 245 251 84 140 208 85 124 172 94 131 176 102 136 179 194 199 205 234 241 249 193 199 205 217 241 252 182 199 207 224 224 222 222 222 220 220 220 218 212 212 211 209 209 208 204 204 203 196 196 195 192 192 191 189 189 188 185 185 184 178 178 177 173 173 172 198 198 198 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@O?1??O?<??7??_?=??7??_?=??G?0_<@\@C8@@@@b') ; yourself); yourself]
! !

!VDBIconLibrary class methodsFor:'icons-eclipse.platform.debug-eview16'!

breakpoint_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/breakpoint_view.gif"

    "
     self breakpoint_view inspect
     ImageEditor openOnClass:self andSelector:#breakpoint_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary breakpoint_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!DB@PHQD!!HRD!!HRD!!HRD!!@@B@$H@A@RD!!HRD!!HRD!!HBA08NC \BD!!HRD!!HRD!!HR@PLKB <C@QHR
D!!HRD!!HRD HDC@0LA@HRD!!HRD!!HRD!!HP@@TMA @PD!!DB@PHQD!!HRD!!DB@PHQD!!@@B@$H@A@RD!!HRD!!HRD!!HBA08NC \BD!!HRD!!HRD!!HR@PLKB <C@QHRD!!HR
D!!HRD HDC@0LA@HRD!!HRD!!HRD!!HP@@TMA @PD!!HRD!!HRD!!HRD!!DB@PHQD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[44 82 123 36 74 110 51 94 135 108 165 203 107 159 195 131 175 205 130 174 204 130 172 200 152 185 208 180 209 229 83 149 190 90 154 194 115 169 204 145 188 215 152 193 219 89 154 192 168 188 199 180 195 204 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C8@_0A?@G<@_0A?_C;>@O8@? C>@O8@_@@@@@@b') ; yourself); yourself]
!

debug_persp
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/debug_persp.gif"

    "
     self debug_persp inspect
     ImageEditor openOnClass:self andSelector:#debug_persp
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debug_persp'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
NS$9NS$UNS$9NS$9NS$9NS$9NS$9D#$9NQD9NS$9NS$9NS$9@A,@NS$XNS$9NS$9NQXREA$PD@@Z@C$9NS$9NS$9NP@PL#TPDA@9D1\9NS$9NS$9C#L_J3\/
C0@@G!!X9NQDQNP@MLSH+M"8L@C$9NS$9NQ ZB#@+H#P,I0,9NS$9NS$9G@$/M# #JRXID189NS$9NQ(@BB4*JBD$A0@9D#$9NS$T@@PFI2X%H@T9NS$9NS$V
NS$9D0DC@ D9NS$9NS$9NS$9NQ4@@C$9NS$9NS$9NS$9NS$YNS$9NS$9NS$9NS$9NS$VNS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[177 174 177 29 98 121 29 99 121 29 99 120 31 101 121 31 100 120 32 101 121 34 102 122 33 103 121 36 104 122 39 106 123 39 107 122 42 109 124 42 109 123 43 110 124 44 111 123 45 112 124 56 86 83 49 78 74 32 57 50 45 78 69 56 86 78 49 86 74 40 65 57 49 78 69 40 72 61 40 69 57 45 72 61 35 62 50 35 65 50 45 78 61 46 106 34 58 124 43 83 141 60 146 193 127 115 167 88 150 195 121 149 194 121 159 199 129 166 201 135 174 206 145 175 206 145 181 210 153 219 235 204 182 210 153 184 210 156 184 210 157 198 220 174 213 231 194 219 234 204 231 243 219 199 220 175 198 219 174 199 219 175 203 223 180 213 230 194 199 219 174 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'A@@DP@9@_<@_6@?>[? _>@?>C?4O>AG0@\@A@@H@@@@b') ; yourself); yourself]
!

debug_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/debug_view.gif"

    "
     self debug_view inspect
     ImageEditor openOnClass:self andSelector:#debug_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debug_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
NS$9NS$UNS$9NS$9NS$9NS$9NS$9D#$9NQD9NS$9NS$9NS$9@A,@NS$XNS$9NS$9NQXREA$PD@@Z@C$9NS$9NS$9NP@PL#TPDA@9D1\9NS$9NS$9C#L_J3\/
C0@@G!!X9NQDQNP@MLSH+M"8L@C$9NS$9NQ ZB#@+H#P,I0,9NS$9NS$9G@$/M# #JRXID189NS$9NQ(@BB4*JBD$A0@9D#$9NS$T@@PFI2X%H@T9NS$9NS$V
NS$9D0DC@ D9NS$9NS$9NS$9NQ4@@C$9NS$9NS$9NS$9NS$YNS$9NS$9NS$9NS$9NS$VNS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[177 174 177 29 98 121 29 99 121 29 99 120 31 101 121 31 100 120 32 101 121 34 102 122 33 103 121 36 104 122 39 106 123 39 107 122 42 109 124 42 109 123 43 110 124 44 111 123 45 112 124 56 86 83 49 78 74 32 57 50 45 78 69 56 86 78 49 86 74 40 65 57 49 78 69 40 72 61 40 69 57 45 72 61 35 62 50 35 65 50 45 78 61 46 106 34 58 124 43 83 141 60 146 193 127 115 167 88 150 195 121 149 194 121 159 199 129 166 201 135 174 206 145 175 206 145 181 210 153 219 235 204 182 210 153 184 210 156 184 210 157 198 220 174 213 231 194 219 234 204 231 243 219 199 220 175 198 219 174 199 219 175 203 223 180 213 230 194 199 219 174 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'A@@DP@9@_<@_6@?>[? _>@?>C?4O>AG0@\@A@@H@@@@b') ; yourself); yourself]
!

details_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/details_view.gif"

    "
     self details_view inspect
     ImageEditor openOnClass:self andSelector:#details_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary details_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
KB (JB (JB (JB (JB (JB0+E!!XVE!!XVE!!XVE!!XVE",,JQXYFQ$YFQ$YFQ$YFQ$)KB(VFQ$YFQ$YFQ$YFQ$YJ"0''E!!(ZF!!<_FA(ZFA<ZF"\,I!!X]GQ4]GQ4T
GQ4 GQ4&KBT$IBP$IBP$IBP$IBP$IR0$E!!XVE!!XVE!!XVE!!XVE"P,H1XYFQ$YFQ$YFQ$YFQ$#KBHVGA@MC0,JB@XEAA0WH"0RE!! XFA XFA XFA XG1H,DQX[
D@0IA0TCF1,[F1,QK@8VGQ4]GQ4]GQ4]GQ4]C"0BE!!T^D1TUD1L!!EQT!!EPH,@P@@@@@@@@@@@@@@@@@AKB0,KB0,KB0,KB0,KB0,K@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[104 118 146 107 119 144 110 121 143 111 133 175 114 136 177 116 138 179 121 143 182 124 145 184 126 147 185 132 153 190 130 151 188 135 155 192 140 160 196 142 162 197 113 123 141 139 160 195 145 165 199 117 125 137 122 128 135 247 252 255 243 251 255 246 252 255 213 243 255 235 249 255 238 250 255 233 249 255 237 250 255 240 251 255 234 250 255 243 252 255 247 253 255 237 251 255 242 252 255 246 253 255 127 131 131 132 135 127 137 137 124 142 140 120 148 144 117 153 147 113 167 156 104 161 152 108 157 149 111 165 154 105 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??@@@b') ; yourself); yourself]
!

memory_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/memory_view.gif"

    "
     self memory_view inspect
     ImageEditor openOnClass:self andSelector:#memory_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary memory_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I2\''I2\''I2\''I2\''I2\''I2\''I2\''DA0\GA0\DB\''I2\''I2\''I@,WI!!,WE@ $I2\''I2\''I14JE2X[E1PHAR\''I2\''I2\]@!!LQC0$C@Q4''I2\''I2\''G 4WI!!,W
E@P^I2\''I2\''I1<ME2X[E1PDG2\''I2\''I2\ CQ\&F1\TAB@''I2\''I2\''HP4WI!!,WE@P!!I2\''I2\''I1 ME2X[E1PDFB\''I2\''I2\"CQ\&F1\TABH''I2\''I2\''
H04WI!!,WE@P#I2\''I2\''I1$GD 8UB@\FFR\''I2\''I2\%@AHNEP GA"T''I2\''I2\''I1XZF!!(ZF 0''I2\''I2\''I2\''I2\''I2\''I2\''I0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[49 86 159 53 94 166 72 110 177 73 110 175 94 130 196 40 84 159 68 107 174 74 113 177 94 130 187 100 134 190 118 149 199 117 147 198 122 150 198 126 155 203 149 173 214 150 174 214 152 176 214 169 189 223 106 141 194 123 154 202 127 157 203 130 159 203 139 166 207 170 194 231 42 97 168 43 91 154 43 87 144 190 210 238 41 111 196 41 108 190 41 107 187 41 105 182 42 103 178 41 100 172 42 96 163 42 94 158 88 140 204 126 154 190 227 238 250 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@G<@?8C? O>@?8C? O>@?8C? O>@?8C? O>@_0@@@b') ; yourself); yourself]
!

module_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/module_view.gif"

    "
     self module_view inspect
     ImageEditor openOnClass:self andSelector:#module_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary module_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"E1@WH"H"H"H"H"H"H"H"H!!@KDBH"H"H"H"H"H"H"H"HUDA@WH"H"@PHCA@TFA0D"
E1@NDRH"H @@@@@@@@@@H"HUCAH"H"H"BP$IBP$IBP$IEQ@RE2H"H  JB (JB (JBA\SCQP"H"HHB@ HB@ HB@ "EP4UH"H]GQ4]GQ4]GQ4]GQTPFA\"GA,[
F1,[F1,[F10WE <VH!!8YFQ$ZFQ$ZFQ(^H!!XOE"H!!HRD_HB@ HR@_HBHVE!!X"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[23 71 124 0 101 184 54 124 174 47 128 179 40 131 185 24 139 197 16 143 202 5 149 211 5 128 72 46 149 96 120 184 124 240 200 40 240 192 32 232 184 32 240 192 40 232 176 24 224 160 16 224 152 16 216 144 16 208 136 16 216 136 16 208 128 16 200 120 16 240 216 184 208 120 16 212 138 75 211 138 75 218 161 113 189 104 52 193 114 63 182 88 36 177 73 20 176 72 20 176 73 20 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@8@C @OG><_90??#?>O>9??7??_?]?=0@@@@@b') ; yourself); yourself]
!

register_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/register_view.gif"

    "
     self register_view inspect
     ImageEditor openOnClass:self andSelector:#register_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary register_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@ L@A@DC@ PB@0@D@PLBA@@C@@PC@@LD@@L@A@L@@0P@@0@D@0@CA@@C@@PC@@LD@@L@A@L@@0P@
@0@D@0@CA@@C@@PB@0HD@@L@A@HC@ PDA@PDA@PDA@PDA@PDA@PD@PLBA@HC@@PA@0HD@ L@A@L@@0P@@0@D@0@CA@@C@@PC@@LD@@L@A@L@@0P@@0@D@0@C
A@@C@@PC@@LD@@L@A@HC@ P@@0@D@ LBA@@C@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[200 206 221 175 183 201 145 158 181 23 50 93 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@G]7]7]7]7]7]7\@@G]7]7]7]7]7]7\@@@@@@@@b') ; yourself); yourself]
!

variable_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/variable_view.gif"

    "
     self variable_view inspect
     ImageEditor openOnClass:self andSelector:#variable_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary variable_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@D@A@PDA@P@@PPDA@PDA@D@@PPDA@PD@P@AA@PDA@PC@@P@@PPA@@P@
@0PDA@PD@@LD@P@B@@DD@0@D@@@@@@@CA@PA@@DDA@L@A@PDA@P@@0PA@@H@@PPC@@P@@@@@@0@D@@DD@P@D@@LDA@PDA@D@@PPDA@PD@P@AA@PDA@PD@P@D
A@PDA@@AA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[51 76 111 139 152 170 157 166 178 101 124 153 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@XLC 8M- 76?NXM=/66C 8FC@@@@@@@@@@@@b') ; yourself); yourself]
!

watchlist_view
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/eview16/watchlist_view.gif"

    "
     self watchlist_view inspect
     ImageEditor openOnClass:self andSelector:#watchlist_view
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary watchlist_view'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B (JB (JB (JB (JB (JB (JB (C@0@JB (JB (JB (JB (E@@(CB (JB (@APLAB (E@@(JAP(JB (@AP(J@0(C@@(JB (JB (@AP(JB T@APTE@@TE@@TE
APDJB (JAP\HB@T@@@TGB@ EB (JB THBP$EB (EB@$IAP(JB (EA $@AP(JAPXI@@TJB (J@@TEAPDJB @EAPT@B (JB (JB (JB (JB (JB (JB (JB (J
B HJ@ (J@ HBB (JB (JB (D@ PJB PDA@(JB (JB (J@ (BB (B@ HJB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB (JB @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[169 178 198 139 150 171 23 50 93 85 108 135 174 185 198 50 78 110 228 232 236 213 243 255 235 250 255 252 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@N@A(OL!!% L_?0??C9<O''0>_@@@@T8A3 EN@@@@@@b') ; yourself); yourself]
! !

!VDBIconLibrary class methodsFor:'icons-eclipse.platform.debug-obj16'!

arraypartition_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/arraypartition_obj.gif"

    "
     self arraypartition_obj inspect
     ImageEditor openOnClass:self andSelector:#arraypartition_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary arraypartition_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
MST5MST5MST5MST5MST5MST0K2</K2</K2</K2<0MST5K0PDA@PDA@PDA@PDJ#T5MR(DBPPHA@\DA P@ASD5MST+C 8N@ 8OC HN@ H3MST5K@LC@0(JB (J
B (JB (5MR4A@PDJ@PDA@PDA@R JMST.E0$WF1\ZE1$WFA\)F3T5IQ0\GA4\GA0\GA0\IA45MRXMCP4^G!!8^G!!8^G!!8^MST''EAPTCAPLEAXTCAX4MST5H!!XI
E  VA1XFE @SL#T5MRLQEQDRDQTQB1DPB1<5MST!!HB@ HB@ HB@ HB@!!MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[106 128 171 242 245 251 246 248 252 245 247 251 249 250 252 248 249 251 114 136 177 124 145 184 132 154 190 135 156 192 111 141 185 222 232 247 226 235 248 232 239 249 247 249 252 246 248 251 222 233 248 224 234 248 223 233 247 224 234 247 229 237 248 222 233 247 226 236 248 239 244 250 71 115 165 74 119 168 80 124 172 86 128 177 236 242 249 52 112 166 27 99 158 129 118 78 126 116 79 165 158 132 135 121 76 130 118 78 207 195 157 151 130 70 146 127 72 140 123 74 210 196 158 209 196 158 177 143 62 173 141 63 168 138 65 163 135 67 157 132 68 180 144 61 203 178 120 131 100 50 103 86 59 101 70 40 85 63 45 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A??G?<_?1??G?>_?9??''?>_?9??G?<_?1??@@@@@@b') ; yourself); yourself]
!

brkp_grp
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/brkp_grp.gif"

    "
     self brkp_grp inspect
     ImageEditor openOnClass:self andSelector:#brkp_grp
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary brkp_grp'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?O3<?O0@A@ D@O3<?O3<?O3<?O0@A@0@C@P@?O3<?O3<?O3<A@0PDA@LAO3<?O3<?O3<?@ TFA0XE@#<?O3<?O3<?O0DHAP$E
B@D?O3<?O3<?O3<@@P JB@D@O3<?O3<?O3<?O0@A@ D@O3<?O3<?O0,LCP0KO3<?C <PC08?O1DRD1PSD!!D?C <UC!!TOC#<LE!!\WE1XLO0<UFA XEP<?CQ$Z
F10YCS<PGQ8_G!!4PO00 HRD!!H@0?C2H]GQ4"C3<QD"L$IQHQO08OI!! &C08?O0,LCP0KO3<?C <PC08?O3<?O3<?O3<?O3<?O3<?O0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 252 203 181 176 95 165 160 54 255 250 168 249 246 189 234 230 145 214 210 132 204 199 118 237 232 151 247 243 163 255 252 198 180 195 204 51 94 135 36 74 110 255 191 191 170 58 58 114 0 0 168 188 199 44 82 123 152 185 208 180 209 229 239 143 143 130 172 200 152 193 219 255 168 168 108 165 203 90 154 194 83 149 190 89 154 192 239 131 131 221 115 115 214 98 98 107 159 195 115 169 204 226 122 122 131 175 205 145 188 215 130 174 204 224 132 132 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@C8@_0A?@G<@_0A?@C8C8>_7=?_7=?_7=?_38>@@@b') ; yourself); yourself]
!

brkp_grp_disabled
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/brkp_grp_disabled.gif"

    "
     self brkp_grp_disabled inspect
     ImageEditor openOnClass:self andSelector:#brkp_grp_disabled
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary brkp_grp_disabled'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
C0<OC0<OB (JB (OC0<OC0<OC0<OB  FA@XHB <OC0<OC0<OB  CBP(I@0 JC0<OC0<OC0(BBP(JB $BB <OC0<OC0<J@@(JB (J@@(OC0<OC0<OB HIB (J
BPHJC0<OC0<OC0(GAP$JBPTGB <OC0<OB (JB \A@@DGB (JC0<OB  FA@XHB (HA PFB@(OB  CBP(I@0 H@0$JBPLHB (BBP(JB $B@ $JB (I@ (J@@(J
B (J@@@JB (JB @JB HIB (JBPHBBP(JB $BB (GAP$JBPTGA0TIB $EA0(OB \A@@DGB (G@P@AA0(OC0<JB (JB <OB (JB (@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[79 80 79 85 85 85 98 98 98 103 103 103 105 105 105 122 122 122 135 135 135 182 182 182 201 201 201 227 235 248 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@>@G<@?8C? O>@?8C? ??G?>?????????????7?>O''<b') ; yourself); yourself]
!

brkp_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/brkp_obj.gif"

    "
     self brkp_obj inspect
     ImageEditor openOnClass:self andSelector:#brkp_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary brkp_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
D1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LS@@@@@@@SD1LSD1LSD1LS@@(C@ LJ@ALSD1LSD1LS@@<ABP,I
@P<@D1LSD1LSD0@CBADQDP C@ALSD1LSD1L@@ PMCAHD@ @SD1LSD1LS@@LEC 8NAPL@D1LSD1LSD0@O@PXPA0DO@ALSD1LSD1LS@@(C@ LJ@ALSD1LSD1LS
D1L@@@@@@ALSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LS@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 252 255 46 85 127 38 78 114 54 98 139 108 165 203 107 159 195 131 175 205 130 174 204 130 172 200 152 185 208 169 202 225 180 209 229 83 149 190 90 154 194 115 169 204 144 188 216 145 188 215 152 193 219 89 154 192 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@>@G<@?8C? O>@?8C? G<@O @@@@@@@@@@<b') ; yourself); yourself]
!

brkp_type
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/brkp_type.gif"

    "
     self brkp_type inspect
     ImageEditor openOnClass:self andSelector:#brkp_type
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary brkp_type'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1@B@@HPG1<_G1<_G1<_G04ACADL@P4_G1<_G1<_G1<BBP<OC0$BG1<_G1<_G1<_@@\E@0PG@A<_G1<_G1<_G0HFB@ H
A H_G1<_G1<_G1<M@P,NB DMG1<_G1<_G1<_G1@B@@HPG1<_G1<_G1@B@@HPG1<_D@H@@!!@_G04ACADL@P4_CPDLDP0ACQ<BBP<OC0$BG0HIC0<OBPH_@@\E
@0PG@A<@A0TCA@\@G0HFB@ HA H_@ XHB@ F@!!<M@P,NB DMG04AB08J@P4_G1@B@@HPG1<_D@H@@!!@_G1<_G1<_G1<_G1<_G1<_G0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[38 78 114 46 85 127 54 98 139 83 149 190 89 154 192 90 154 194 107 159 195 108 165 203 115 169 204 130 172 200 130 174 204 131 175 205 152 185 208 144 188 216 145 188 215 152 193 219 169 202 225 180 209 229 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@C8@_0A?@G<@_0A?@C8C8>_7=?_7=?_7=?_38>@@@b') ; yourself); yourself]
!

brkpd_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/brkpd_obj.gif"

    "
     self brkpd_obj inspect
     ImageEditor openOnClass:self andSelector:#brkpd_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary brkpd_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,K@ HB@ HKB0,KB0,KB0,K@ LEA0TC@ ,KB0,KB0,K@ LH@@H@
B@LBB0,KB0,KB0HI@@HB@ @I@ ,KB0,KB0,B@PHB@ HB@PHKB0,KB0,K@ $@@ HB@@$BB0,KB0,KB0HDA @B@@XD@ ,KB0,KB0,K@ PJ@P(D@ ,KB0,KB0,K
B0,B@ HB@ ,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0,KB0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[227 235 248 79 80 79 255 255 255 201 201 201 182 182 182 135 135 135 122 122 122 105 105 105 103 103 103 98 98 98 85 85 85 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@>@G<@?8C? O>@?8C? G<@O @@@@@@@@@@@b') ; yourself); yourself]
!

build_tab
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/build_tab.gif"

    "
     self build_tab inspect
     ImageEditor openOnClass:self andSelector:#build_tab
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary build_tab'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
PDA@PDA@PDA@PDA@PDA@PDA@NC 8NC 8NC 8PDA@PDA@PC LC@0LC@0LOS!!@PDA@PD@8@PD&CP4.I#8?NDA@PDA@NP,]EAHOA2\;O#06PDA@PC\!!J"(*@B(D
@2(*N$A@PD@4B!!4\F1LQD@8FB#Q@PDA@MQ$YFQ$YFQ$YFQ$3PDA@PCH)JR$)JR$)JR$)L$A@PD@1IPTZFBTXF H%AQ(XPDA@LB4Z@!!(-@!!(BKQ(BF$A@PB<$
F HZI@HZ@"PZ@!!)@PD@+KA(BF"0BF H,F HZPDA@H" XF!! (@!!(BJA ZFDA@PA8#H2L#H2L#H2L G4A@PD@HBP WE1XWEQ\IBQY@P@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[244 246 252 248 249 252 200 206 221 245 247 252 244 246 251 175 183 201 103 125 169 106 128 171 133 147 174 134 147 174 242 245 251 246 248 252 249 250 252 248 249 251 109 131 173 116 138 179 115 137 178 122 143 183 128 149 187 129 150 187 138 158 194 133 148 175 133 148 174 134 148 174 145 158 181 239 243 250 23 50 93 135 156 192 141 162 196 145 165 199 137 150 172 178 189 207 222 232 248 243 246 251 141 152 169 222 232 247 229 237 249 234 240 249 247 249 252 246 248 251 224 234 248 236 242 250 244 247 251 145 155 167 226 236 247 231 239 248 248 250 252 151 158 163 161 164 156 166 168 153 171 170 149 176 173 146 181 176 143 177 173 145 188 181 138 185 179 140 191 182 136 188 180 137 186 178 140 224 200 143 212 178 104 212 178 105 218 189 124 213 178 105 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@?8C?0O? ??C?<O?0??C?<O?8??#?>O?8??#?<O?0b') ; yourself); yourself]
!

builder
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/builder.gif"

    "
     self builder inspect
     ImageEditor openOnClass:self andSelector:#builder
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary builder'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
PD@:N#(:N#(:N#)@PDA@PDA@N (JB (JB (=N$A@PDA@PC(A@Q<KB2X_O#<:PDA@PD@2BQ RD@4GHC$>OCM@PDA@MA,#H2L@H0PCH2L;PDA@PCTHFA\VDP<N
C@XHMTA@PD@6EAPTEAPTEAPTEC]@PDA@NBH"H"H"H"H"H"H''PDA@PC@^AQTSG!!LU@!!8EEQM@PD@1IQTBERTBEPH%EPHUPDA@K14U@!!T]@!!TBGQTBETA@PB0$
EPHUI@HU@"PU@!!U@PD@-HQLUD2DBEPH!!D1TSPDA@JQ0\GA0\GA0\GA(YPDA@PB,.J2(*JB((J"8.JDA@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[244 246 252 248 249 252 200 206 221 245 247 252 244 246 251 175 183 201 103 125 169 106 128 171 242 245 251 246 248 252 249 250 252 248 249 251 109 131 173 116 138 179 115 137 178 122 143 183 128 149 187 129 150 187 138 158 194 145 158 181 239 243 250 23 50 93 135 156 192 141 162 196 145 165 199 178 189 207 222 232 248 243 246 251 222 232 247 229 237 249 234 240 249 247 249 252 246 248 251 224 234 248 236 242 250 244 247 251 226 236 247 231 239 248 248 250 252 171 170 149 125 117 78 129 119 77 126 117 78 125 116 78 136 123 75 133 121 76 126 116 78 142 125 73 156 133 69 151 130 70 177 143 61 177 144 62 174 142 63 170 139 64 166 137 65 165 137 66 161 135 67 224 200 143 180 144 61 175 141 63 212 178 104 212 178 105 218 189 124 213 178 105 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O>@?<C?8O?0??C?<O?0??C?>O?8??#?>O?8??C?<@@@b') ; yourself); yourself]
!

classpath
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/classpath.gif"

    "
     self classpath inspect
     ImageEditor openOnClass:self andSelector:#classpath
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary classpath'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"E1@WH"H"H"H"H"H"H"H"H!!@KDBH"H"H"H"H"H"H"H"HUDA@WH"H"@PHCA@TFA0D"
E1@NDRH"H @@@@@@@@@@H"HUCAH"H"H"BP$IBP$IBP$IEQ@RE2H"H  JB (JB (JBA\SCQP"H"HHB@ HB@ HB@ "EP4UH"H]GQ4]GQ4]GQ4]GQTPFA\"GA,[
F1,[F1,[F10WE <VH!!8YFQ$ZFQ$ZFQ(^H!!XOE"H!!HRD_HB@ HR@_HBHVE!!X"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[23 71 124 0 101 184 54 124 174 47 128 179 40 131 185 24 139 197 16 143 202 5 149 211 5 128 72 46 149 96 120 184 124 240 200 40 240 192 32 232 184 32 240 192 40 232 176 24 224 160 16 224 152 16 216 144 16 208 136 16 216 136 16 208 128 16 200 120 16 240 216 184 208 120 16 212 138 75 211 138 75 218 161 113 189 104 52 193 114 63 182 88 36 177 73 20 176 72 20 176 73 20 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@8@C @OG><_90??#?>O>9??7??_?]?=0@@@@@b') ; yourself); yourself]
!

common_tab
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/common_tab.gif"

    "
     self common_tab inspect
     ImageEditor openOnClass:self andSelector:#common_tab
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary common_tab'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N  I@0HTA@,UE 0%E1 :N#(7L2L!!@R@-M!!8QKB,(N#(:B@@NC04EFQ,ZGA@]I3(:N"(9NS$.NS$9
NS$9NR(:N#(*H \8NBH8NCH8NCP*N#(:JS$9NQL9NS$9NS$9LC(:N"XFD XRA XFA XFA"X:N#($NS$9D#$9NS$9NS$$N#(:K3D5LQH1LSD1LSD1K3(:N (9
NS$_NS$9NS$9NP(:N#(HB@ HB@ HB@ HB@ HN#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N#(:N @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[129 141 164 168 176 192 98 114 143 96 112 140 104 120 148 138 150 171 188 196 211 198 205 218 91 108 137 94 111 139 107 123 150 108 124 150 119 135 160 134 148 170 130 143 165 132 145 166 152 164 183 170 180 196 187 196 211 193 201 214 101 118 144 111 128 153 115 132 157 127 143 166 131 146 168 140 153 173 146 159 178 143 156 175 149 162 181 156 168 185 173 183 198 182 192 207 185 194 208 192 201 214 196 205 218 195 204 217 120 137 160 123 140 163 128 144 166 131 147 169 131 147 168 135 150 171 139 154 174 164 176 192 166 178 194 180 190 204 200 209 221 113 131 154 135 150 169 176 187 200 196 207 220 198 208 220 198 207 218 176 188 201 175 187 200 144 160 176 196 207 218 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?>O?8??#?>O?8??#?>O?8??#?>O?8@@@@@@@@b') ; yourself); yourself]
!

debugt_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/debugt_obj.gif"

    "
     self debugt_obj inspect
     ImageEditor openOnClass:self andSelector:#debugt_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debugt_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
EAPTEAPTEAPTEAPTEAPTEAPTEAPB@0TTEAPRD1HTEAPTE@ @B@LAEA@PD0$SDA@TEAPDA0@TEAPPB0(JB ,PEAPTA XFEAPRD0(ND08JD1HTEAPTEAPTD04M
D00SCP4SEAPTD!!LREAHSCP8SC 4SD!!PPDALID1@QD@,OC0<KDAPTD@,JB (KDADPD0<SDA@TD!!LJC!!LNB!!LREAHSD!!PTEALMCQLLD04MD1PTEAPTEAPRD04N
D08MD1HTE@XFA!!PTEA@KC0<OB1@TEAP@A0PTEAPPDALOD1@PE@DCB@@HEAPTEAPRD1HTEAPE@0HTEAPTEAPTEAPTEAPTEAPTEAPTE@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[140 165 210 195 206 221 172 187 206 100 134 166 0 78 141 0 60 110 0 85 151 0 78 140 0 70 125 255 255 159 255 223 95 191 159 63 255 251 240 255 191 63 154 141 115 223 159 63 110 77 37 194 180 164 156 104 86 84 56 48 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@NNC;>NO89?0G?G_=??''?>?;#? O>\_11?_A10@@@b') ; yourself); yourself]
!

debugts_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/debugts_obj.gif"

    "
     self debugts_obj inspect
     ImageEditor openOnClass:self andSelector:#debugts_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debugts_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O#8>O#8>O#8>O#8>O#8>O#8>O#8CA@X>O#8<OS0>O#8>O (@B PBO#(:OP,=N#(>O#8EBP@>O#8:GP4MCQ4:O#8>B@ HO#8<OP48OS MOS0>O#8>O#8>OSL3
ORT=L3L=O#8>O#8>O#0=L3 =NCL=OC8>O#8>O#8>N149NS$]N#8>EAHRHQ\RD"4;OS$=N#(>O!!DNCA0SC 0+O#0=OC8>O#8[IAX)G2PVK#8>O#8>O#8>F"L"
J"@#H"<>O  HBC8>O!!$XER ^FAT4O#8@BPT>O#8''D@<2KA@OMPDDB @JO#8>LBX&M3D&I#XGA@L>O#8>O#8>O#8>O#8>O#8>O#8>O @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[140 165 210 233 237 243 195 206 221 172 187 206 100 134 166 0 78 141 0 60 110 209 220 229 0 85 151 0 78 140 0 70 125 255 255 159 253 247 217 255 223 95 254 249 228 252 236 180 253 242 203 186 151 38 190 156 40 198 170 77 210 186 105 252 227 151 251 227 152 218 198 132 253 236 182 175 137 32 178 141 34 182 145 35 140 112 34 191 159 63 189 158 72 195 165 75 192 162 74 156 135 79 251 221 131 252 231 168 253 235 184 255 251 240 167 126 28 173 133 31 132 102 30 137 108 32 135 105 32 153 120 41 188 155 71 168 144 87 150 116 39 147 113 39 194 165 97 205 181 126 132 99 29 255 191 63 145 110 37 144 108 37 174 146 88 145 122 74 154 141 115 223 159 63 110 77 37 152 129 100 156 104 86 84 56 48 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@NNC;>NO89?0G?@_<@?''?>_;!!? G>\_91??G?0@@@b') ; yourself); yourself]
!

debugtt_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/debugtt_obj.gif"

    "
     self debugtt_obj inspect
     ImageEditor openOnClass:self andSelector:#debugtt_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary debugtt_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
BP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$F@PXIBP$IBP$IBP$IBP G@P@AA0 IBP$IBP$IBP$G@@HB@ @GBP$IBP$IBP$F@PHEB@TB@PXIBP$IBP$I@P@B
B@LH@ @ABP$IA DFBPXA@ THAPHAA $HA0D@@P\DA0@B@ H@A0$IA0@B@ H@A0PG@P@AA0 IA DBAP E@ DFBPXAA $IBPD@@  CB@H@@P$IBP$IBP$F@PHE
B@TB@PXIBP$IBP$IBP\@@ HB@@\IBP$IBP$IBP$HA0D@@P\HBP$IBP$IBP$IBP$F@PXIBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[227 235 248 79 80 79 255 255 255 247 247 247 179 179 179 175 175 175 121 121 121 103 103 103 73 73 73 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@N@C>@O8A?0G?G_=??''?>?;#? O>@_0A?@A0@@@@b') ; yourself); yourself]
!

environment_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/environment_obj.gif"

    "
     self environment_obj inspect
     ImageEditor openOnClass:self andSelector:#environment_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary environment_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
W5=_W5=_W5=_W5=_W5=_W5<2L3P5IBTXJA$[J!!< E5=_RT5NS5AJR41GRC8+KBE_W3H#MCT$I!! (JQ(]G"@!!W5=SD1LSD1LSD1LSD1LST5=_UAPLC@@TEAPT
EAPTEEQ_W5TUBP$@EQTUE!!@PDQEXW5=VCPX@CP4MB0(\LC@''TU=_U08B@@8ND <0OC4=OC@"W5$G@@\GA0P6N#,;N3,:M%=ZB@@HB@ EK3$8NC 8Q"=_V0LC
@0LC@R9BO3<?O4H.W5IRT%I^WU00P4E@PDECLE=_W5=_W5=_H"5EQC]EKRI_W5=_W5=_W5<"LR4-LRI_W5=_W5=_W5=_W5=_W5=_W0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 252 255 194 196 209 121 126 150 162 167 185 174 179 197 186 190 205 93 103 133 131 141 167 149 157 178 64 81 118 118 132 162 142 154 180 42 62 104 88 106 141 110 125 155 128 142 170 136 149 176 144 157 182 148 160 184 36 64 112 47 74 119 65 89 129 108 126 157 111 144 191 88 128 180 95 133 183 99 137 186 99 136 185 81 111 151 103 139 187 105 141 189 106 141 188 109 143 190 111 145 191 204 217 234 72 118 172 81 124 176 84 126 178 84 126 177 86 126 173 92 131 181 95 134 183 102 139 186 207 223 243 212 226 244 23 78 141 36 89 147 45 96 152 62 109 161 63 110 161 70 117 171 72 119 172 74 120 173 77 122 174 83 125 172 79 132 184 85 136 186 88 138 187 108 152 195 121 161 200 136 171 207 148 179 212 199 220 242 31 100 163 50 113 172 56 118 174 58 119 175 72 128 181 80 133 183 96 144 190 99 146 191 180 211 239 190 216 240 92 154 205 148 197 233 158 202 235 170 207 236 112 180 226 119 183 227 128 187 229 136 192 231 196 188 149 131 127 112 184 155 88 180 152 90 175 150 93 168 146 95 162 143 98 214 189 131 155 139 102 148 135 105 141 131 108 213 192 148 197 178 140 171 157 129 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@A??''?>_?9??''?>_?9??''??_?=??7??_?<@?0A>@@@b') ; yourself); yourself]
!

envvar_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/envvar_obj.gif"

    "
     self envvar_obj inspect
     ImageEditor openOnClass:self andSelector:#envvar_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary envvar_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
EQTUEQTUEQTUEQTUEQTUEQTUEQPLC@0LEATUEQTUEQTUEQ@LDQDQDP0PEQTUEQTUEQLLDP<OC0<QCALUEQTUEQTLC@$IBP$IBP0LEQTUEQTUAPTC@0LC@0LE
AQTUEQTUEPP@@@@@@@@@@@PUEQTUEQTDA@PB@PDBA@PDEQTUEQTUD @JA0 FA0(@D!!TUEQTUEQTK@@4MCP8@B1TUEQTUEQTUEQH@@@@@D!!TUEQTUEQTUEQTU
EQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[28 101 162 48 114 171 48 114 170 54 118 173 54 119 173 60 123 175 77 134 183 78 134 183 78 135 182 90 143 187 94 146 189 99 150 191 106 154 194 107 154 195 107 154 194 127 168 203 135 174 206 152 185 213 160 191 216 172 199 221 196 215 231 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@_ C?@_>A?8G? _>A?8G? O<@_ @@@@@@@@@@@@@@b') ; yourself); yourself]
!

export_config_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/export_config_obj.gif"

    "
     self export_config_obj inspect
     ImageEditor openOnClass:self andSelector:#export_config_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary export_config_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
\WDADV@-F18Z\WE1\WE1\WE1DQ@M[B8F\AL$WGE1\WE1\V@MZP-0\GA[@"Q1\WE1\WD-[@-(BV,(@2,T\WE1\WE1GB10B&\HHR=XUTIXK7E1\Q<G\F4LY#UD
XVU"WUD5\WD]J"H%W P<U5Y0X5=YR''E1[!!I[AR\(PUQS\GA$V#51\WD#@"$&C3EFSGA0SU@0\WE1WBPS[087QT<@RD]CM''E1\WE1Z!!T MC=KT$9IPC!!1FAXY
FWE1\WD3N3$:O#I1\WDXE!!%1\WE1\WE1\WE1\WE1\Q W\WE1\WE1\WE1\WE1\WE1FGE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\WE1\P@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 254 255 45 43 79 58 72 103 176 182 194 214 220 232 50 68 101 50 68 100 55 71 101 173 181 195 48 70 106 49 71 106 50 72 107 50 71 106 53 74 108 223 226 231 222 225 230 56 78 110 184 195 208 37 110 190 41 113 191 169 198 229 45 116 190 51 112 164 51 112 163 64 119 167 13 92 154 55 132 190 60 133 187 61 134 188 62 135 187 63 136 188 66 137 188 180 209 229 250 253 255 247 252 255 79 152 191 83 154 192 246 252 255 249 254 255 248 254 255 254 255 255 164 197 192 164 195 190 219 232 230 211 233 229 209 231 227 210 233 228 186 217 195 63 142 84 50 131 69 148 196 159 164 206 174 201 223 206 213 230 217 84 158 100 87 159 102 175 208 182 63 148 80 66 150 83 98 167 111 107 170 119 80 149 92 90 164 103 53 143 67 63 150 76 72 143 83 97 158 106 67 148 76 82 154 91 49 134 57 39 113 44 53 135 59 150 190 153 70 153 74 110 169 113 144 189 146 142 183 144 154 190 156 57 139 60 152 191 153 61 130 62 93 159 93 156 195 156 157 191 156 76 134 71 90 163 78 179 205 175 100 159 84 128 188 108 112 164 95 108 162 88 204 237 191 203 233 191 136 178 114 232 237 229 115 175 75 234 238 231 151 204 103 144 190 95 196 231 156 205 233 169 206 236 159 252 255 229 255 255 198 255 255 213 255 255 219 253 253 250 193 191 149 201 196 152 197 193 151 237 236 226 228 224 204 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O8@?<C?0O?@??#??O?<??1??G?<G?7!!>N@@X@@ @@@@b') ; yourself); yourself]
!

expression_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/expression_obj.gif"

    "
     self expression_obj inspect
     ImageEditor openOnClass:self andSelector:#expression_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary expression_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
A0@CA0L@A0\GA0\@A0\G@@\D@@P@A@\G@ \G@@LG@0@GA0P@A@\GA0@GA0L@A0@CA0\D@@PG@ @@@@HG@@L@A0\D@@P@A@\G@@\GA0L@@0\G@@LG@0@GA0HG
A0\C@@\GA0\GA0\GA0\GA0\G@@LGA0\GA0\GA0T@@@TGA0@GA0\G@@@@A0\@APT@A0\GA0\GA0\GA0\GA@\G@@\GA0\GA0\@@@@GA0\E@PTGA0\GA0\GA0\G
A0\G@@TGA0\GA0\GA0\GA0\GA0@FA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@LGA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[57 101 149 102 147 197 116 157 202 145 177 213 171 196 223 200 216 234 213 225 239 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'[AE<&3"[N>9<#&2L@@0C2GO@@$A10@F@@X@@@@F@@@@b') ; yourself); yourself]
!

external_tools
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/external_tools.gif"

    "
     self external_tools inspect
     ImageEditor openOnClass:self andSelector:#external_tools
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary external_tools'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
ZV%)ZV%)ZV%)ZV%)ZV%)ZV%)M4$4E2HVLV%)ZV%)ZV%)E!!1YWE-TR"MAZV%)ZV%)S2)SU%=XU5URH4=)ZV%)ZQ5FTCE(W%!!QST0_ZV%)ZV$.RD]CZF!! WT8=
H6%)ZV%)DST9P&!!(ZD=KG!!%)ZV%)ZQP2KDE(ZC<-JBLYZV%)ZV$_ICP>ZC\.L2<ZE&%)ZV%)S1$:QS<;ND@)Y&Q$YFY)ZV%AFR\+LCX!!S6U''Y6]%ZV%)ZT<_
F!!08Y&Q$YFQ$YFQ&ZV%)ZV%)ZVE#YVM#X6U#XV%)ZV%)ZV%!!YVE%YVU!!YVE)ZV%)ZV%)XVI!!X&I"XVI!!ZV%)ZV%)ZVY!!XVE!!XVE!!Y @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[217 125 219 215 143 218 198 132 203 190 109 197 198 157 203 163 98 173 165 102 176 179 144 188 135 120 149 144 164 156 67 118 94 72 119 95 67 119 91 116 151 131 63 120 86 69 123 91 77 122 95 50 123 73 73 136 93 128 172 142 45 123 68 115 160 127 129 175 141 77 141 93 60 147 78 67 151 85 65 146 82 72 154 89 74 155 91 96 167 112 86 146 99 114 176 127 65 132 78 70 153 83 78 152 90 82 152 94 60 141 72 74 147 84 81 154 91 93 164 104 47 124 56 75 156 84 77 151 86 91 164 99 42 125 50 53 132 61 69 141 76 79 158 86 84 160 92 192 213 194 47 127 53 62 143 68 68 144 73 58 119 62 85 164 91 182 210 184 55 140 59 54 118 58 72 152 76 58 136 61 68 138 70 108 164 109 176 206 177 184 211 185 80 158 80 173 203 173 173 202 173 183 208 183 245 248 245 184 210 183 93 157 88 84 143 79 90 146 84 116 173 108 113 166 103 74 136 59 108 163 95 111 164 96 108 163 89 203 220 197 114 166 94 101 163 72 134 180 110 135 180 110 150 186 129 146 185 120 186 216 166 129 180 88 157 213 96 133 206 46 158 213 95 152 191 109 174 222 114 174 220 118 251 255 246 249 254 240 254 255 248 192 72 56 200 88 72 240 144 136 216 104 96 136 24 24 240 128 128 253 236 236 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@? G?@?>C?8O? ?>C?8O? ??1??C??@_<A?0G?@_<b') ; yourself); yourself]
!

file_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/file_obj.gif"

    "
     self file_obj inspect
     ImageEditor openOnClass:self andSelector:#file_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary file_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
N3,;N3,;N3,;N3,;N3,;N3,;N3T5MST5MST5N3,;N3,;N3,5B (JB (JNCT;N3,;N3,;L"$AB2$A@S$:MS,;N3,;N3P(D!!DMCBH6NS\3N3,;N3,1BQ0&G@@\
GA0\LC,;N3,;K2TUEALRDP4LDB<;N3,;N24[F0 [F1,[F1,.N3,;N3,,HQTTD1HQCP0!!KC,;N3,;J2PZF!!(ZF!!($F",;N3,;N2(YEQPSD!!DMCA$''N3,;N3,#
HB@ HB@ HB@ H3,;N3,;C18SD!!DMCA _E <;N3,;N08]GQ\]E14WE14DN3,;N3,BAP\FAP\GA \B@3,;N3,;N3,;N3,;N3,;N3,;N0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[243 245 251 248 249 252 131 145 177 131 145 176 135 147 174 131 146 177 130 145 176 131 146 176 238 242 250 242 245 251 249 250 252 248 249 251 134 154 190 140 159 194 134 148 174 139 150 171 240 244 251 147 166 198 154 172 203 162 179 207 168 184 211 172 188 213 222 232 248 221 231 247 223 232 247 228 236 249 231 238 249 237 242 250 243 246 251 220 231 247 223 233 248 222 232 247 225 234 248 234 240 249 246 248 251 144 154 168 230 238 249 240 245 251 242 246 251 150 157 164 245 248 251 247 249 251 149 157 164 155 161 161 161 164 156 167 168 152 167 168 153 173 171 149 178 175 146 178 174 146 187 180 139 183 177 142 183 177 143 191 182 136 224 200 143 212 178 104 212 178 105 218 189 124 213 178 105 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@_8A?0G? _?A?<G?0_?A?<G?0_?A?<G?0_?A?<@@@b') ; yourself); yourself]
!

fldr_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/fldr_obj.gif"

    "
     self fldr_obj inspect
     ImageEditor openOnClass:self andSelector:#fldr_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary fldr_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[C 8NC!!,[F1,[F1,[F1,[EA(ZF!!(TF1,[F1,[F1,[D0@@A@LICALS
D1LSF1,[F04A@PDA@PDA@PDACQ,[F1,R@ HB@ HB@ HB@!! [F1,[C0XFA XVE!!XVE!!XVE!!XVF1DJB (VAPTEAPTEAPTCE!!,PA0\VA0\GA0\GA0\CE!!,[E0 V
B0,KB0,KB0,CE!!,[F1$VB@ HB@ HB@ CE!!,[F1,[EQTUEQTUEQTUEQ,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[248 232 152 248 240 200 248 232 176 232 208 136 240 216 144 248 224 152 248 224 160 248 216 136 248 208 120 224 192 120 248 216 144 248 208 128 216 176 112 188 133 50 195 139 54 180 127 50 165 108 36 173 114 43 188 127 50 195 133 54 173 108 36 158 102 39 173 114 47 158 95 29 158 95 32 143 82 25 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G @?@G?8_?!!?>G??_?=??''?<_? ?<@@@@@@b') ; yourself); yourself]
!

genericreggroup_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/genericreggroup_obj.gif"

    "
     self genericreggroup_obj inspect
     ImageEditor openOnClass:self andSelector:#genericreggroup_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary genericreggroup_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G1<_G1<_G1<_G1<_G1<_G1<_C@PHG1<[GQ$_G00DBA<_G0<P@Q<_EQH]G1<OD@D_G1<H@P _G1$]FQ<_B@DHG1<LBPXDCA,VFA4[C@$FA@0_BP0LB0PVF1,Z
GP$LC@,DG0$QC@(EE!!0[D1\IDP0JAQ<G@@0HAQPRF1$WA0@LB@T_G!!8^G!!8^G!!8^G!!8^G!!8^G0LNCQ8MC H^@08MG 4N@!!<N@ 8^@ 8BG 8BC!!8BC H_C HN
G HN@!!8N@ 8^@ 8BG08BC!!8BC H^C HNG HN@!!<MC 4^@ 8BG 4NCQ8BC H_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G1<_G0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[196 200 224 33 57 124 200 206 221 175 183 201 40 69 126 55 92 163 47 75 130 87 115 174 130 149 188 73 103 157 100 126 173 141 162 200 157 174 204 145 158 181 23 50 93 77 110 165 196 211 232 170 193 222 251 240 180 214 180 41 203 171 39 190 160 37 180 152 35 171 144 33 138 116 27 221 193 76 224 199 94 227 204 109 232 213 134 143 108 24 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@93#''NN\9??7??_?=??7??_?=??7??_?=??0@@@@@b') ; yourself); yourself]
!

genericregister_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/genericregister_obj.gif"

    "
     self genericregister_obj inspect
     ImageEditor openOnClass:self andSelector:#genericregister_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary genericregister_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@ L@A@DC@ PB@0@D@PLBA@@C@@PC@@LD@@L@A@L@@0P@@0@D@0@CA@@C@@PC@@LD@@L@A@L@@0P@
@0@D@0@CA@@C@@PB@0HD@@L@A@HC@ PDA@PDA@PDA@PDA@PDA@PD@PLBA@HC@@PA@0HD@ L@A@L@@0P@@0@D@0@CA@@C@@PC@@LD@@L@A@L@@0P@@0@D@0@C
A@@C@@PC@@LD@@L@A@HC@ P@@0@D@ LBA@@C@@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[200 206 221 175 183 201 145 158 181 23 50 93 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@G]7]7]7]7]7]7\@@G]7]7]7]7]7]7\@@@@@@@@b') ; yourself); yourself]
!

genericvariable_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/genericvariable_obj.gif"

    "
     self genericvariable_obj inspect
     ImageEditor openOnClass:self andSelector:#genericvariable_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary genericvariable_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
D1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD0,KD1LSD1LSD1LSD1LSD0(OCP(SD1LSD1LSD1LSD0 OD@0I
BALSD1LSD1LSD0\ODADNC@$GD1LSD1LSD0TODADRC 8LBPTSD1LSD1LDA XFA @@@@@DD1LSD1LSD0LFA X@@@@CD1LSD1LSD1LS@ XF@@@BD1LSD1LSD1LS
D1LAA @AD1LSD1LSD1LSD1LSD0@@D1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[28 101 162 34 105 164 42 111 168 52 117 172 62 123 176 72 131 181 78 135 182 83 139 185 93 145 188 97 148 190 100 150 191 106 154 194 107 154 195 107 155 194 142 178 209 152 185 213 160 191 216 196 215 231 230 238 245 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@X@C0@_ C?@_>A?8C?@G8@O@@X@@@@@@@@@b') ; yourself); yourself]
!

hex_tree
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/hex_tree.gif"

    "
     self hex_tree inspect
     ImageEditor openOnClass:self andSelector:#hex_tree
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary hex_tree'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
UEQTUEQTUEQTUEQTUEQTUEQTUEQKR$)JR$)JR$-TUEQTUEQTR$AERD]MSEEJUEQTUEQTUD-NS49PS$=PR5QTUEQTUEP@B0$0T3 IB0ATUEQTUEPSCQ$\NS41
K!!$MD5QTUEQTA T+K3MRL0D[APYTUEQTU@PGFR02OSD,J \DUEQTUEPCC1TZK"<,F!!XO@5QTUEQT@"D(E (XE1X&HPITUEQTU@L-DP ''JQP$H24CUEQTUEPD
M1<!!DB@RH!!<7AEQTUEQTA#0>N3X%MS(?O@YTUEQTUAL4RTYBP4EDRSPSUEQTUEQTD00NGQ8]C 0SUEQTUEQTUEQTUEQTUEQTUEQTU@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[222 228 237 238 242 248 97 128 169 110 138 176 132 156 187 168 188 214 161 179 203 190 206 227 214 227 244 222 231 243 226 235 247 121 149 184 119 146 178 140 165 196 128 151 179 204 219 237 210 224 242 211 225 242 210 224 241 196 208 223 217 229 244 221 232 246 221 232 245 225 235 247 227 236 247 226 235 246 229 237 247 228 236 246 236 241 247 129 152 178 129 152 177 208 223 240 210 225 242 209 224 241 209 224 240 210 225 241 213 227 243 209 223 238 215 229 244 216 229 244 215 228 243 217 230 244 225 235 246 227 236 246 235 241 248 198 215 233 235 241 247 238 243 248 241 245 249 243 246 249 244 246 248 247 248 249 152 169 185 209 223 236 210 224 236 189 204 216 241 245 248 243 246 248 214 225 231 215 225 231 184 193 193 247 249 249 226 231 222 227 231 223 254 253 239 240 237 214 240 236 214 238 235 216 246 240 210 254 249 226 246 239 210 252 237 185 253 243 207 252 242 207 186 151 38 206 184 111 251 225 144 252 231 163 177 138 33 176 138 33 176 139 33 251 221 131 253 252 250 250 250 250 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@O>@?8C? O>A?<G?0_?A?<G?0_?A?<G?0_?@?8@@@b') ; yourself); yourself]
!

import_config_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/import_config_obj.gif"

    "
     self import_config_obj inspect
     ImageEditor openOnClass:self andSelector:#import_config_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary import_config_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
\PDQXB4[G!!)1\WE1\WE1\WDQD@5+K Y0D2Q\\WE1\WE1X@5)B7A0\E,BIGE1\WE1\R5+B6 IZ" CJ1Q1\WE1\WD\KG@JY0 !!K5!!UP% /\WE1G0]0[@1&MTQ!!
YVI]TSU1\Q4*H"U^AC1WU''A#W5%J\WE-D%,EI2!!AUEM0\FQZOWE1\RLBJRXOLTYL\GAMTCA1\WE\IAM.C#]ES0AHQ4L6\WE1\WE/ER@4O4-RS$%@NGE1\WE1
\WE1\SL;NS(>L''DX\WE1\WE1\WE1\WE1\WDXE''E1\WE1\WE1\WE1\WDXE!!%1\WE1\WE1\WE1\WDXE1$Y\WE1\WE1\WE1\WE1\WE1\P@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 254 255 45 43 79 58 72 103 176 182 194 214 220 232 50 68 101 50 68 100 55 71 101 173 181 195 48 70 106 49 71 106 50 72 107 50 71 106 53 74 108 223 226 231 222 225 230 56 78 110 184 195 208 37 110 190 41 113 191 169 198 229 45 116 190 51 112 164 51 112 163 64 119 167 13 92 154 55 132 190 60 133 187 61 134 188 62 135 187 63 136 188 66 137 188 180 209 229 250 253 255 247 252 255 79 152 191 83 154 192 246 252 255 249 254 255 248 254 255 254 255 255 164 197 192 164 195 190 219 232 230 211 233 229 209 231 227 210 233 228 186 217 195 63 142 84 50 131 69 148 196 159 164 206 174 201 223 206 213 230 217 84 158 100 87 159 102 175 208 182 63 148 80 66 150 83 98 167 111 107 170 119 80 149 92 90 164 103 53 143 67 63 150 76 72 143 83 97 158 106 67 148 76 82 154 91 49 134 57 39 113 44 53 135 59 150 190 153 70 153 74 110 169 113 144 189 146 142 183 144 154 190 156 57 139 60 152 191 153 61 130 62 93 159 93 156 195 156 157 191 156 76 134 71 90 163 78 179 205 175 100 159 84 128 188 108 112 164 95 108 162 88 204 237 191 203 233 191 136 178 114 232 237 229 115 175 75 234 238 231 151 204 103 144 190 95 196 231 156 205 233 169 206 236 159 252 255 229 255 255 198 255 255 213 255 255 219 193 191 149 201 196 152 197 193 151 237 236 226 228 224 204 244 240 227 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_0A?8G? _>A??G?>_?9??#?>O?8O? C=@@L@A0@O@@@b') ; yourself); yourself]
!

inst_ptr
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/inst_ptr.gif"

    "
     self inst_ptr inspect
     ImageEditor openOnClass:self andSelector:#inst_ptr
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary inst_ptr'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
APTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEA@TEAPTEAPTEAPTEAPTEA@DDAPTEAPTEAPTEAPPDA@P@@@PEAPTEAPTEAPTA@@@@@PL@A@TE
APTEAPTE@@PDA@PD@0@DAPTEAPTEAP@DA@PDA@PB@@PEAPTEAPT@A@PDA@PB@@PEAPTEAPTE@P@@@@DB@@PEAPTEAPTEAPPDA@P@@@PEAPTEAPTEAPTEAPTD
@PPEAPTEAPTEAPTEAPTEAPPEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAPTEAP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[16 92 156 45 112 167 110 157 195 187 209 227 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@ @G@C>@O<@?8C?0O>@?0C>@A0@B@@@@@@@@@@b') ; yourself); yourself]
!

inst_ptr_top
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/inst_ptr_top.gif"

    "
     self inst_ptr_top inspect
     ImageEditor openOnClass:self andSelector:#inst_ptr_top
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary inst_ptr_top'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ GA0 HB@ HB@ HB@ HB@ HA0DGB@ HB@ HB@ HB@\GA0\@@@\HB@ HB@ HB@ A@@@@@PP@A0 H
B@ HB@ H@@XFA XFA@@GB@ HB@ HB@@EAPTEAPTB@@\HB@ HB@ @@0LC@0LB@@\HB@ HB@ H@P@@@@DB@@\HB@ HB@ HB@\GA0\@@@\HB@ HB@ HB@ HB@ G
@P\HB@ HB@ HB@ HB@ HA0\HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[16 92 156 45 112 167 67 127 177 114 159 197 118 162 199 130 170 203 141 178 208 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@A @G@C>@O<@?8C?0O>@?0C>@A0@F@@@@@@@@@@b') ; yourself); yourself]
!

invalid_build_tool
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/invalid_build_tool.gif"

    "
     self invalid_build_tool inspect
     ImageEditor openOnClass:self andSelector:#invalid_build_tool
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary invalid_build_tool'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRLZFQ0YF"L%IRT%IRT%IRL\GRD[HQ4\H2T%IRT%IRL\G"P HB@$G!!0#IRT%IRTRBA<"IA<$
H!!<HD"T%IRT%CPPB@BP$H LBA@4%IRT%IQLQE!!\$IA\WE1DSIRT%IRTMD@<"IBPOC0<PCRT%IRT%D 8"I@$"I@$IC!!H%IRT%IQ UI@(JB"H$AP0XIRT%IRT%
F@,GA@DDA 0XIRT%IRT%IRTXD 4TCQHXIRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IRT%IP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[245 111 114 245 135 136 245 110 114 244 110 115 235 109 113 245 122 127 221 74 84 222 75 83 223 79 87 241 89 99 242 97 104 206 40 55 206 41 56 209 56 69 221 64 77 242 75 90 235 85 96 244 96 109 220 105 114 200 22 40 200 25 42 206 37 53 241 63 82 241 63 83 230 171 181 202 93 73 206 110 94 247 162 154 201 71 62 224 97 91 247 137 133 245 121 121 246 130 128 237 130 128 255 191 191 227 196 196 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@_0C? _?A?<G?0_?A?<G?0_?@?8A?@@@@@@@@@b') ; yourself); yourself]
!

jar_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/jar_obj.gif"

    "
     self jar_obj inspect
     ImageEditor openOnClass:self andSelector:#jar_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary jar_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
UEQTUEQTUEQTUEQTUEQTUEQTUEQKR$)JR$)JR$-TUEQTUEQTR$AERD]MSEEJUEQTUEQTUD-NS49PS$=PR5QTUEQTUEP@B0$0T3 IB0ATUEQTUEPSCQ$\NS41
K!!$MD5QTUEQTA T+K3MRL0D[APYTUEQTU@PGFR02OSD,J \DUEQTUEPCC1TZK"<,F!!XO@5QTUEQT@"D(E (XE1X&HPITUEQTU@L-DP ''JQP$H24CUEQTUEPD
M1<!!DB@RH!!<7AEQTUEQTA#0>N3X%MS(?O@YTUEQTUAL4RTYBP4EDRSPSUEQTUEQTD00NGQ8]C 0SUEQTUEQTUEQTUEQTUEQTUEQTU@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[222 228 237 238 242 248 97 128 169 110 138 176 132 156 187 168 188 214 161 179 203 190 206 227 214 227 244 222 231 243 226 235 247 121 149 184 119 146 178 140 165 196 128 151 179 204 219 237 210 224 242 211 225 242 210 224 241 196 208 223 217 229 244 221 232 246 221 232 245 225 235 247 227 236 247 226 235 246 229 237 247 228 236 246 236 241 247 129 152 178 129 152 177 208 223 240 210 225 242 209 224 241 209 224 240 210 225 241 213 227 243 209 223 238 215 229 244 216 229 244 215 228 243 217 230 244 225 235 246 227 236 246 235 241 248 198 215 233 235 241 247 238 243 248 241 245 249 243 246 249 244 246 248 247 248 249 152 169 185 209 223 236 210 224 236 189 204 216 241 245 248 243 246 248 214 225 231 215 225 231 184 193 193 247 249 249 226 231 222 227 231 223 254 253 239 240 237 214 240 236 214 238 235 216 246 240 210 254 249 226 246 239 210 252 237 185 253 243 207 252 242 207 186 151 38 206 184 111 251 225 144 252 231 163 177 138 33 176 138 33 176 139 33 251 221 131 253 252 250 250 250 250 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@O>@?8C? O>A?<G?0_?A?<G?0_?A?<G?0_?@?8@@@b') ; yourself); yourself]
!

launch
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/launch.gif"

    "
     self launch inspect
     ImageEditor openOnClass:self andSelector:#launch
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary launch'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I2\''I2\''I2\''I2\''I2\''I2\''I2\''DA0\GA0\DB\''I2\''I2\''I@,WI!!,WE@ $I2\''I2\''I14JE2X[E1PHAR\''I2\''I2\]@!!LQC0$C@Q4''I2\''I2\''G 4WI!!,W
E@P^I2\''I2\''I1<ME2X[E1PDG2\''I2\''I2\ CQ\&F1\TAB@''I2\''I2\''HP4WI!!,WE@P!!I2\''I2\''I1 ME2X[E1PDFB\''I2\''I2\"CQ\&F1\TABH''I2\''I2\''
H04WI!!,WE@P#I2\''I2\''I1$GD 8UB@\FFR\''I2\''I2\%@AHNEP GA"T''I2\''I2\''I1XZF!!(ZF 0''I2\''I2\''I2\''I2\''I2\''I2\''I0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[49 86 159 53 94 166 72 110 177 73 110 175 94 130 196 40 84 159 68 107 174 74 113 177 94 130 187 100 134 190 118 149 199 117 147 198 122 150 198 126 155 203 149 173 214 150 174 214 152 176 214 169 189 223 106 141 194 123 154 202 127 157 203 130 159 203 139 166 207 170 194 231 42 97 168 43 91 154 43 87 144 190 210 238 41 111 196 41 108 190 41 107 187 41 105 182 42 103 178 41 100 172 42 96 163 42 94 158 88 140 204 126 154 190 227 238 250 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@G<@?8C? O>@?8C? O>@?8C? O>@?8C? O>@_0@@@b') ; yourself); yourself]
!

ldebug_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/ldebug_obj.gif"

    "
     self ldebug_obj inspect
     ImageEditor openOnClass:self andSelector:#ldebug_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary ldebug_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
NS$9NS$XNS$9NS$9NS$9NS$9NS$9D#$9NQD9NS$9NS$9NS$9@A0@NS$YNS$9NS$9NQXRD1TPD@@[@C$9NS$9NS$9NP@PL#TPDA@9EA\9NS$9NS$9C#L J3\/
C0@@G!!X9NQDQNP@MLSH+M"8L@C$9NS$9NQ$[B#@+H#P,I0,9NS$9NS$9F $/M# #JRXIEA89NS$9NQ,@BB4*JBD$A0@9D#$9NS$S@@PFI2X%G0T9NS$9NS$V
NS$9E@DC@ D9NS$9NS$9NS$9NQ4@@C$9NS$9NS$9NS$9NS$UNS$9NS$9NS$9NS$9NS$VNS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[177 174 177 39 121 136 39 122 136 39 122 135 42 124 136 42 123 135 43 124 136 45 126 137 45 126 136 48 128 137 52 130 138 52 131 137 56 133 139 56 133 138 58 135 139 59 136 138 61 137 139 77 106 94 68 96 84 60 96 78 43 71 56 53 89 69 68 106 84 53 80 64 77 106 88 68 96 78 46 76 56 53 85 64 60 89 69 46 80 56 60 96 69 58 124 43 63 130 38 83 141 60 146 193 127 115 167 88 150 195 121 149 194 121 159 199 129 166 201 135 174 206 145 175 206 145 181 210 153 219 235 204 182 210 153 184 210 156 184 210 157 198 220 174 213 231 194 219 234 204 231 243 219 199 220 175 198 219 174 199 219 175 203 223 180 213 230 194 199 219 174 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'A@@DP@9@_<@_6@?>[? _>@?>C?4O>AG0@\@A@@H@@@@b') ; yourself); yourself]
!

lrun_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/lrun_obj.gif"

    "
     self lrun_obj inspect
     ImageEditor openOnClass:self andSelector:#lrun_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary lrun_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
K"8.K"8.K"8.K"8.K"8.K"8.K"8 A0TA@PTGHB8.K"8.K"8GA",+I"("G@TGK"8.K"8GBRT+KR,)JR (BP\.K"8 A"P''G24-J2\''I2\FHB8.A1H#H1<-KR4+
H2L#H0\.K X!!HRD_KR4-KR,!!HQ4FK"8FF1,[G"4-KR4-KA,]@R8.@@<OC18-KR4-G0<OA@@.K DTEAP^KR4-G!!PTDALAK"8GCADQG"4-G!!DQE1HCA28.H@ R
FQ8-G 8NFQ\SBB@.K"8GB1L^G!!TXE!!(SB0\.K"8.K \HB!!LMCQLJB@\.K"8.K"8.H@\B@PDBA2@.K"8.K"8.K"8.K"8.K"8.K"8.K @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[32 128 65 38 128 65 38 136 65 65 145 87 94 154 111 58 136 79 51 136 72 102 173 119 45 136 65 72 145 87 72 154 87 58 145 72 65 145 79 102 173 111 58 136 65 51 119 58 65 136 72 72 145 79 79 154 87 87 164 94 45 128 51 51 136 58 65 154 72 72 154 79 58 136 58 65 145 65 87 164 87 72 128 72 102 164 102 119 173 119 173 203 173 186 210 186 213 224 213 94 154 87 136 183 128 111 164 94 128 173 111 136 183 119 154 193 136 136 183 111 145 183 119 145 183 111 164 193 136 128 204 38 194 233 120 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@O<A?8O?1??''?>_?9??''?>_?9??''?>O?0_>@?0@@@b') ; yourself); yourself]
!

main_tab
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/main_tab.gif"

    "
     self main_tab inspect
     ImageEditor openOnClass:self andSelector:#main_tab
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary main_tab'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
I"TEB0XFC@\GB!!XTEAPTEBXQDP8OD!!@SEATHE!!XVE!!P&APTKA XLA0\JB  QDQDQI"HVE!!XVE!!XVE!!XVE!!XVH"X"E!!\WE1\WE1\WE1\WE2H&H!!XWA@PM@0HB
@P$@E1\"I"LVE1\WE1\WE1\WE1\WH2X]E!!\DA@4C@ HABP@WE14&HAXXE1\WFA\WFA\WE1 _I!!,VF@PDCPLBFA XFA XF2X\E!! XFA XFA XFA XFA0&GAXX
FA XFA XFA XFA $I!!8VFA XFA XFA XFA XG"XZE"T%IRT%IRT%IRT%IQ$&HRD!!HRD!!HRD!!HRD!!HRD!!I"X&I"X&I"X&I"X&I"X&I @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[136 152 192 144 160 192 152 168 200 160 176 200 168 184 208 40 80 136 48 88 144 56 96 152 64 104 160 136 160 192 64 104 152 40 88 144 48 96 144 160 184 208 80 152 208 88 160 216 104 168 216 72 152 208 96 168 216 120 176 216 128 184 224 144 192 224 208 240 248 232 248 248 240 248 248 97 95 61 97 95 65 120 108 54 113 102 58 135 114 50 105 95 61 128 108 50 128 108 54 97 89 65 150 121 47 143 114 47 113 95 58 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_?=??7??_?=??7??_?=??7??_?=??7??_?=??7??@@@b') ; yourself); yourself]
!

memory_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/memory_obj.gif"

    "
     self memory_obj inspect
     ImageEditor openOnClass:self andSelector:#memory_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary memory_obj'
        ifAbsentPut:[(Depth8Image new) width:8; height:16; bits:(ByteArray fromPackedString:'
C 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8N
C 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8NC 8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[63 63 159 95 95 159 127 127 191 63 95 191 63 95 159 63 95 127 127 159 191 166 202 240 63 127 159 95 159 191 159 191 191 191 223 191 223 223 191 255 251 240 255 255 255]; mask:((ImageMask new) width:8; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

memory_segment
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/memory_segment.gif"

    "
     self memory_segment inspect
     ImageEditor openOnClass:self andSelector:#memory_segment
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary memory_segment'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
O3<?O3<?O3<?O3<?O3<?O3<?O3<?O0@A@ D@O3<?O3<?O3<?O0@A@0@C@P@?O3<?O3<?O3<A@0PDA@LAO3<?O3<?O3<?@ TFA0XE@#<?O3<?O3<?O0DHAP$E
B@D?O3<?O3<?O3<@@P JB@D@O3<?O3<?O3<?O0@A@ D@O3<?O3<?O0,LCP0KO3<?C <PC08?O1DRD1PSD!!D?C <UC!!TOC#<LE!!\WE1XLO0<UFA XEP<?CQ$Z
F10YCS<PGQ8_G!!4PO00 HRD!!H@0?C2H]GQ4"C3<QD"L$IQHQO08OI!! &C08?O0,LCP0KO3<?C <PC08?O3<?O3<?O3<?O3<?O3<?O0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 252 203 181 176 95 165 160 54 255 250 168 249 246 189 234 230 145 214 210 132 204 199 118 237 232 151 247 243 163 255 252 198 180 195 204 51 94 135 36 74 110 255 191 191 170 58 58 114 0 0 168 188 199 44 82 123 152 185 208 180 209 229 239 143 143 130 172 200 152 193 219 255 168 168 108 165 203 90 154 194 83 149 190 89 154 192 239 131 131 221 115 115 214 98 98 107 159 195 115 169 204 226 122 122 131 175 205 145 188 215 130 174 204 224 132 132 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@C8@_0A?@G<@_0A?@C8C8>_7=?_7=?_7=?_38>@@@b') ; yourself); yourself]
!

memory_unit
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/memory_unit.gif"

    "
     self memory_unit inspect
     ImageEditor openOnClass:self andSelector:#memory_unit
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary memory_unit'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
D1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LS@@@@@@@SD1LSD1LSD1LS@@(C@ LJ@ALSD1LSD1LS@@<ABP,I
@P<@D1LSD1LSD0@CBADQDP C@ALSD1LSD1L@@ PMCAHD@ @SD1LSD1LS@@LEC 8NAPL@D1LSD1LSD0@O@PXPA0DO@ALSD1LSD1LS@@(C@ LJ@ALSD1LSD1LS
D1L@@@@@@ALSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LS@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 252 255 46 85 127 38 78 114 54 98 139 108 165 203 107 159 195 131 175 205 130 174 204 130 172 200 152 185 208 169 202 225 180 209 229 83 149 190 90 154 194 115 169 204 144 188 216 145 188 215 152 193 219 89 154 192 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@>@G<@?8C? O>@?8C? G<@O @@@@@@@@@@<b') ; yourself); yourself]
!

memorychanged_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/memorychanged_obj.gif"

    "
     self memorychanged_obj inspect
     ImageEditor openOnClass:self andSelector:#memorychanged_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary memorychanged_obj'
        ifAbsentPut:[(Depth8Image new) width:8; height:16; bits:(ByteArray fromPackedString:'
D1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LSD1LM@QLSD1LS@@\LD1LSD1LJBPX@D1LS
@AH@AP0SD1LH@ALKDPHS@1@SD0@OAALNC 8NC 8ND1LSD1LSD1L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[178 181 196 212 214 222 197 200 211 160 172 192 141 167 192 43 108 161 50 111 163 55 115 165 66 123 170 68 123 169 74 127 172 74 128 172 105 147 182 128 162 190 0 85 150 28 101 158 29 101 158 35 104 159 58 118 166 255 255 255]; mask:((ImageMask new) width:8; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@LGA8>M6]?@@@a') ; yourself); yourself]
!

note
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/note.gif"

    "
     self note inspect
     ImageEditor openOnClass:self andSelector:#note
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary note'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
?????????9II$-/?????????????@@@@@@@@@O????????<@@@@@@O?Z@@@@@O????<@@@@@@@C??=,@@@@@????@@@@@@@@?????0@@@O??@@@@@@@@@M,@
??<@@@@@?0@@@@@@@@C?@O?[@@@@@IH@@@@@@@@@?0@@?0@@@@AI@@@@@@@@@O<@@O<@@@@@$ @@@@@@@@C?@@C?@@@@@O<@@@@@@@@@60@@@@@@@@C?@@@@
@O????<@@@@@@@@@?=,@@BS??=,$@@@@@@@@6???@@@@??=-@@@@@@@@@O????<@@@@@@@@@@@@@@O????????<@@@@@@@@@6/???0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 0 0 85 0 0 170 0 0 255 0 36 0 0 36 85 0 36 170 0 36 255 0 73 0 0 73 85 0 73 170 0 73 255 0 109 0 0 109 85 0 109 170 0 109 255 0 146 0 0 146 85 0 146 170 0 146 255 0 182 0 0 182 85 0 182 170 0 182 255 0 219 0 0 219 85 0 219 170 0 219 255 0 255 0 0 255 85 0 255 170 0 255 255 36 0 0 36 0 85 36 0 170 36 0 255 36 36 0 36 36 85 36 36 170 36 36 255 36 73 0 36 73 85 36 73 170 36 73 255 36 109 0 36 109 85 36 109 170 36 109 255 36 146 0 36 146 85 36 146 170 36 146 255 36 182 0 36 182 85 36 182 170 36 182 255 36 219 0 36 219 85 36 219 170 36 219 255 36 255 0 36 255 85 36 255 170 36 255 255 73 0 0 73 0 85 73 0 170 73 0 255 73 36 0 73 36 85 73 36 170 73 36 255 73 73 0 73 73 85 73 73 170 73 73 255 73 109 0 73 109 85 73 109 170 73 109 255 73 146 0 73 146 85 73 146 170 73 146 255 73 182 0 73 182 85 73 182 170 73 182 255 73 219 0 73 219 85 73 219 170 73 219 255 73 255 0 73 255 85 73 255 170 73 255 255 109 0 0 109 0 85 109 0 170 109 0 255 109 36 0 109 36 85 109 36 170 109 36 255 109 73 0 109 73 85 109 73 170 109 73 255 109 109 0 109 109 85 109 109 170 109 109 255 109 146 0 109 146 85 109 146 170 109 146 255 109 182 0 109 182 85 109 182 170 109 182 255 109 219 0 109 219 85 109 219 170 109 219 255 109 255 0 109 255 85 109 255 170 109 255 255 146 0 0 146 0 85 146 0 170 146 0 255 146 36 0 146 36 85 146 36 170 146 36 255 146 73 0 146 73 85 146 73 170 146 73 255 146 109 0 146 109 85 146 109 170 146 109 255 146 146 0 146 146 85 146 146 170 146 146 255 146 182 0 146 182 85 146 182 170 146 182 255 146 219 0 146 219 85 146 219 170 146 219 255 146 255 0 146 255 85 146 255 170 146 255 255 182 0 0 182 0 85 182 0 170 182 0 255 182 36 0 182 36 85 182 36 170 182 36 255 182 73 0 182 73 85 182 73 170 182 73 255 182 109 0 182 109 85 182 109 170 182 109 255 182 146 0 182 146 85 182 146 170 182 146 255 182 182 0 182 182 85 182 182 170 182 182 255 182 219 0 182 219 85 182 219 170 182 219 255 182 255 0 182 255 85 182 255 170 182 255 255 219 0 0 219 0 85 219 0 170 219 0 255 219 36 0 219 36 85 219 36 170 219 36 255 219 73 0 219 73 85 219 73 170 219 73 255 219 109 0 219 109 85 219 109 170 219 109 255 219 146 0 219 146 85 219 146 170 219 146 255 219 182 0 219 182 85 219 182 170 219 182 255 219 219 0 219 219 85 219 219 170 219 219 255 219 255 0 219 255 85 219 255 170 219 255 255 255 0 0 255 0 85 255 0 170 255 0 255 255 36 0 255 36 85 255 36 170 255 36 255 255 73 0 255 73 85 255 73 170 255 73 255 255 109 0 255 109 85 255 109 170 255 109 255 255 146 0 255 146 85 255 146 170 255 146 255 255 182 0 255 182 85 255 182 170 255 182 255 255 219 0 255 219 85 255 219 170 255 219 255 255 255 0 255 255 85 255 255 170 255 255 255]; yourself]
!

osprc_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/osprc_obj.gif"

    "
     self osprc_obj inspect
     ImageEditor openOnClass:self andSelector:#osprc_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary osprc_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
PDA@PDA@KST5MST5MR5@PDA@PDA@PC8PHB@PD@@>PDA@PDA@PD@.C2 (C 8TK$A@PDA@PDA@LQD!!HP0LCCE@PDA@PDA@PCP4MCP4MCP1PDA@PDA@PD@7EQTU
EQTWM4A@PDA@PDA@NA KB@ HBC!!@PDA@PDA@PCL3L3L3L3L3PDA@FQ$ZPD@=B (JB (ROTA@PA$,FQ8[L!!LGA0\GD#Y@PD@YJ2,*FQ4MAPXFA!!H0PDA@FRL%
H"H$FPHC@0LRK4A@PA$&I2XYG1XAA@PDD#1@PD@YJQ$\F3$ID!!HRD!!H:PDA@FQ$ZPD@?N3,;N3,;O4A@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[207 208 213 198 203 217 213 217 228 172 180 201 174 182 202 202 207 220 180 188 205 184 191 207 168 173 184 176 181 192 205 210 221 167 171 180 172 175 182 227 230 237 209 213 221 221 224 230 222 225 231 205 207 211 156 162 173 202 208 219 172 176 183 214 218 225 224 228 235 200 203 208 198 202 208 31 132 78 194 222 207 199 224 211 61 150 100 68 154 105 86 166 120 115 179 143 166 199 179 122 166 138 87 171 114 88 171 113 88 171 114 88 170 113 77 167 101 77 166 101 80 160 98 97 176 96 131 190 129 131 189 129 147 197 135 198 201 193 168 173 159 147 153 134 149 155 137 166 171 156 218 220 214 157 162 145 164 169 153 171 175 162 152 157 139 162 166 151 159 163 148 215 217 210 144 149 129 143 148 128 146 151 132 155 159 142 170 173 160 180 183 170 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@?0C?@O<@?0C?@O<@?0C?GO<_?1??G?<_?1??GO<@@@b') ; yourself); yourself]
!

osprct_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/osprct_obj.gif"

    "
     self osprct_obj inspect
     ImageEditor openOnClass:self andSelector:#osprct_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary osprct_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
OC0<OC0<L"4-KR4-KSH<OC0<OC0<OC@PA0\PD@ 0OC0<OC0<OC0"C0TEC 8VH#0<OC0<OC0<I@$FA 0LCBP<OC0<OC0<OBL#H2L#H2L#OC0<OC0<OC0,E1\W
E1\RKC0<OC0<OC0<J1 SFQ$YFR,<OC0<OC0<OCP1J"X&I"X&OC0<@S\7M3\7@P(ZF!!(^K#0<OCX8NC 8NCXMGQ4]G"T<OC06MS(:N#T6EQ<_G18 OC0<NS,B
@ H;NQP[F1,^HS0<O@L5N#(:MPLKGA0\G"$<OC0CN@@@@@@CDQ8^G!!8''OC0<A@LC@0LCACL(JB (K30<OC0<OC0<OC0<OC0<OC0<O@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[248 166 169 216 150 153 232 71 82 193 16 35 209 95 114 237 26 72 195 124 144 225 187 203 208 206 213 206 205 212 230 229 238 215 215 228 173 173 183 220 220 231 210 210 221 221 221 230 222 222 231 206 206 214 201 201 209 168 169 181 213 214 228 217 218 230 173 174 184 214 215 225 199 200 209 169 171 185 206 208 221 173 178 202 175 180 203 185 189 208 157 160 174 181 186 206 150 153 138 148 151 135 169 171 160 165 167 154 167 169 157 153 155 140 158 160 146 145 147 130 144 146 129 147 149 133 186 187 178 160 161 149 163 164 152 172 173 163 156 157 143 181 181 171 171 171 161 206 206 201 199 199 194 200 199 192 220 219 216 248 169 158 201 79 66 201 87 74 248 174 169 201 63 58 242 111 109 244 131 130 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@?0C?@O<@?0C?@O<@?0C?G?<_?1??G?<_?1??G?<@@@b') ; yourself); yourself]
!

pda
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/pda.gif"

    "
     self pda inspect
     ImageEditor openOnClass:self andSelector:#pda
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary pda'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
@@@@@@@@@PH@@P@@@@@@@@@@@@@A@PHD@ DA@PD@@@@@@@DA@PHGA0\B@PDF@@@@@@DA@PHIBP$IB@HA@P@@@@@A@PHHC0<OC0(H@ DA@P@A@PHJB <O@PDA
B  B@PD@@PHEB DA@P<A@PDJB@HA@@HDAP(KC0<OC0<OC0(E@ @A@ TJB00LC@<LC@0J@ D@@PDBB ,LC@0OC@0L@ DF@@DA@PHOC@0LC00LC@DA@@@A@PDA
@ (JB (J@ DA@PX@@@DA@PDBB@ H@ DAA X@@@@@@PDA@PHE@ DA@PX@@@@@@@XF@PXF@ XFA X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 204 204 255 51 51 102 0 119 0 204 204 204 187 187 187 102 102 204 170 170 170 136 136 136 119 119 119 85 85 85 51 0 153 255 255 0 0 0 0 0 0 0 0 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@4@O>C?8_?!!??/?>??;??/?>??;??O?>_?0?>C?0@@@b') ; yourself); yourself]
!

persp_tab
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/persp_tab.gif"

    "
     self persp_tab inspect
     ImageEditor openOnClass:self andSelector:#persp_tab
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary persp_tab'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
P4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP00ZB1$IFA\TD1@NCTMCP4LMI"\(IB$!!G!!< H 5CP4MCCA,KB $XE!!TRDP<MP4MCP4H1LSD3LSD1
LSD1P$MCP4MBLR8.L28.K"8.K$ICP4MCM3D0K34/KB</J"(7P4MCP3 1KRTEO3<?O3<?NDMCP4L9MTEAAR,+J2,+H3)CP4MCN3DHBCX\GQ0\GP <P4MCP381
A XCA XGA XFO$MCP4L4LPP@APPDA@HAADACP4MCL#H2L#H2L#H2L#H2P4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP4MCP0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[250 249 255 249 249 255 250 250 255 138 139 145 249 250 255 132 136 149 247 249 255 246 249 255 244 248 255 45 93 161 45 90 154 45 88 149 45 85 142 44 110 197 44 108 194 44 109 194 45 107 190 45 106 189 44 105 184 45 105 185 44 102 179 45 102 179 45 99 173 45 98 172 45 96 166 45 91 155 45 87 146 45 87 145 243 248 255 244 249 255 188 218 250 199 225 253 209 230 254 176 212 247 216 235 255 241 248 255 154 201 243 238 247 255 130 188 237 136 191 239 144 196 240 165 208 245 235 246 255 240 248 255 234 246 255 237 247 255 233 246 255 235 247 255 234 247 255 213 240 255 102 101 94 172 158 119 108 104 92 154 148 132 146 144 138 155 130 70 147 126 74 137 120 79 136 120 79 127 114 83 127 115 84 168 155 123 116 108 88 162 152 127 109 104 92 154 148 133 161 132 68 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b') ; yourself); yourself]
!

prj_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/prj_obj.gif"

    "
     self prj_obj inspect
     ImageEditor openOnClass:self andSelector:#prj_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary prj_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5L#H2L#T5MST5MST5MST5L3P4MCP1MST5MST5MPDA@BT%I"$/L@@@@@@@@STBDB\''I2\''I2\''
I2\''D@H5MPL(JB (JB (JB (J@L5MSTHJ"(*J"(*J"(*J"(HMST5B"0,BPXEA XFA@\DA $FMP<+J2,LIBP$IBP$IBP$B3TSK"8NH2H!!H2D!!HRD#CST5FB4Q
G1<^HA< GR@ D#T5MQTVFQ$\F1([GA$\E3T5MST5EAPTEAPTEAPTECT5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MST5MP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[149 129 136 149 129 137 137 123 141 114 113 147 95 100 157 96 100 158 96 100 157 96 101 157 99 103 153 95 101 157 86 95 158 81 92 163 82 93 162 69 85 168 69 86 168 74 90 165 133 145 200 57 79 173 57 80 172 63 84 170 40 70 179 46 73 176 47 74 177 47 74 176 53 78 173 146 181 236 146 182 236 146 181 235 146 182 235 157 197 242 157 198 242 158 197 242 158 198 242 169 214 249 169 213 248 169 214 248 177 225 253 250 233 158 246 223 150 255 241 194 255 235 179 236 209 139 255 229 164 255 218 137 255 223 150 255 209 117 255 213 125 227 193 125 217 178 113 208 172 120 209 173 121 208 172 121 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@<@G8C??/?>_?1??G??_?=??''?<_? ?<@@@@@@b') ; yourself); yourself]
!

read_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/read_obj.gif"

    "
     self read_obj inspect
     ImageEditor openOnClass:self andSelector:#read_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary read_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
BP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IB@HB@@ IBP$IB@ HB@$IB@L@B@HHBP$IB@@C@ DIB@L@B@ CB@$I
B@@CB@ BB@H@B@ HB@ HB@@CB@$H@0@C@0L@@0L@@0LC@P IBP CAPXF@0@@@0TFA LHBP$I@0XGA0LHB@LFA0\CB@$IBPLDA0@CB@ CA@\@@0 IBP$@@0LC
@P H@@LC@0@HBP$IB@ HB@ IBP HB@ HBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[169 178 198 139 150 171 85 108 135 50 78 110 228 232 236 213 243 255 235 250 255 252 255 255 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G0<?G7<???/?>_?8??#?>O?8>_@@@@@@@@@b') ; yourself); yourself]
!

read_obj_disabled
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/read_obj_disabled.gif"

    "
     self read_obj_disabled inspect
     ImageEditor openOnClass:self andSelector:#read_obj_disabled
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary read_obj_disabled'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
BP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$I@@\GAP@IBP$I@@@@@@$I@@ E@@\@BP$I@@THA0XI@@ E@@@H@@$I
@@TH@@@G@@\E@@@@@@@@@@TH@@$@B@THB@ EB@ EB@ HA @IBP@H@0HBB@TEB@LB@  @BP$IB@HA@P @@@ B@PDH@@$IBP D@PTH@@@HA@DEB@@IBP$EB@ H
A @@AP HB@T@BP$I@@@@@@@IBP@@@@@@BP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP$IBP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 254 254 254 248 248 248 241 241 241 240 240 240 208 208 208 190 190 190 161 161 161 141 141 141 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@G0<?G7<???/?>_?8??#?>O?8>_@@@@@@@@@b') ; yourself); yourself]
!

readwrite_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/readwrite_obj.gif"

    "
     self readwrite_obj inspect
     ImageEditor openOnClass:self andSelector:#readwrite_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary readwrite_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G1<^A0XCBA8_G!!8^G!!<_G1<^@PHIG L^G \FA@ ^G1<^@@PIG!!8HG @BG!!8CG!!<_G DBA @B@@XB@Q8^BA8_G18FB ,FG XJB0X^G!!8^G1<^@ ,L@!!8BB00B
G!!8TDQ8_G  B@  ^B@HBBA8TDP<PG!!<^G!!8^G18^G!!8SDP<PEQ8_G1<_G1<_G18RDP<PEQ8_G1<_G1<_G18UDP<PEQ8_G1<_G1<_G18[DP<PF18_G1<_G1<_
G18YCP<PF!!8_G1<_G1<_G18]F@8NE!!8_G1<_G1<_G1<^AQ0WE!!8_G1<_G1<_G1<_G TEGQ8_G1<_G1<_G1<_G1<^G!!8_G1<_G1<_G0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[169 178 198 139 150 171 76 100 129 85 108 135 104 124 149 34 67 103 50 78 110 158 171 186 169 181 194 228 232 236 213 243 255 235 250 255 252 255 255 219 211 161 187 180 138 240 216 168 233 196 126 246 230 200 147 124 87 148 127 93 149 129 96 147 120 81 143 105 56 142 105 56 143 108 62 144 112 67 144 112 68 146 116 74 143 105 57 215 202 186 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O7!!??O?<??3??O?>??=;?0C>@_0C>@_0C>@O0@>@A0@b') ; yourself); yourself]
!

readwrite_obj_disabled
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/readwrite_obj_disabled.gif"

    "
     self readwrite_obj_disabled inspect
     ImageEditor openOnClass:self andSelector:#readwrite_obj_disabled
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary readwrite_obj_disabled'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
GA0@CA(TB @\@@@@@A0\GA0@C!!\D@AP@@@0ZC0(@GA0@BP<D@@@J@@$W@@@T@A0\@@8WF $WBQ(WC @@B @\G@@Z@0HZ@A(C@!!(@@@@@GA0@E0HAE0@W@ DW
@@@PAP@\@@(WE0(@B!!\WB @PAPXK@A0@@@@@G@@@@@@QAPXKD0@\GA0\GA0\G@@RAPXKD0@\GA0\GA0\G@@SAPXKD0@\GA0\GA0\G@@TAPXKE@@\GA0\GA0\
G@@VB@XKEP@\GA0\GA0\G@@GE04MFP@\GA0\GA0\GA0@F1 YFP@\GA0\GA0\GA0\@A,[A0@\GA0\GA0\GA0\GA0@@@@\GA0\GA0\G@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 253 253 253 246 246 246 236 236 236 234 234 234 226 226 226 208 208 208 204 204 204 195 195 195 189 189 189 187 187 187 185 185 185 179 179 179 169 169 169 163 163 163 136 136 136 132 132 132 131 131 131 128 128 128 125 125 125 121 121 121 118 118 118 117 117 117 114 114 114 112 112 112 111 111 111 94 94 94 83 83 83 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'O7!!??O?<??3??O?>??=;?0C>@_0C>@_0C>@O0@>@A0@b') ; yourself); yourself]
!

refresh_tab
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/refresh_tab.gif"

    "
     self refresh_tab inspect
     ImageEditor openOnClass:self andSelector:#refresh_tab
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary refresh_tab'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
EQTUEQTUEQTUC 8UEQTUEQTUEQTUEQTUC  NEQTUEQTUEQTUEQTUC  HC 8NEQTUEQTUEQTUC @A@PDA@08UEQTUEQTUEP4BAPTEAPTGCQTUEQTUEQTUD0,J
D1LKB!!LUEP8UEQTUEQTSB1LUD0,SEQTNC!!TUC 8UEQLSEQTSD1TUC  NEP8HC!!TUEQTUEP4UEP8HA 8NB@XNEQTUEQTUEQTNA@DA@PDA@00UEQTUEQTUEQDB
APTEAPHREQTUEQTUEQTUC1PTB $PEQTUEQTUEQTUEQTUD0$SEQTUEQTUEQTUEQTUEQLSEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[249 229 149 251 237 181 249 218 124 241 215 132 249 224 140 251 230 159 244 227 175 241 209 117 254 250 239 249 209 104 251 219 134 249 203 97 178 127 26 176 126 26 183 132 28 165 113 22 166 114 23 173 120 25 172 120 25 161 108 21 166 113 23 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@F@@8@G8@?0C? G>PN9&Y''\B_8A?0C?@G8@G@@X@@@@b') ; yourself); yourself]
!

rundebug
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/rundebug.gif"

    "
     self rundebug inspect
     ImageEditor openOnClass:self andSelector:#rundebug
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary rundebug'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
R$)JR$(NR$)JR$)JR$)JR$)JR$)JF$)JR"IJR$)JR$)JR$)J@@,@R$(YR$)JR$)JR!!4ZE0(_G0@S@D)JR$)JR$)JR @QRSP D!!EJG!!IJR$)JR$)JBCPHMS\3
E@@@CQ-JR"H"R @LM$%IMC@M@D)JR$)JR!! SE#]IA#\2J19JR$)JNC 9DBL3MC\OK"(''G!!UJR#!!HNC4:JB<1KP\$I AJHT(8Q4]FNC0IKB$$@PUJR$)JNDAB
O3=AN@HD@0MJR$)JR#!!CQDL8O"T@R$)JR$)JR$(8QS ;N$(JR$)JR$)JR$)JNC 9R$(\R$)JR$)JR$)JR$)JR$)JR$)JR$)JR$)JR @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[184 173 183 19 19 67 215 215 230 32 34 115 143 144 185 34 41 121 211 212 224 55 63 131 81 90 164 227 228 238 80 90 164 85 95 167 89 98 169 89 98 168 110 119 179 114 122 180 204 207 227 68 80 155 67 79 151 75 87 159 79 91 160 87 98 167 89 100 169 89 101 169 96 107 174 99 110 174 100 110 175 101 112 175 102 112 175 107 117 178 50 66 141 58 72 144 67 81 151 100 112 175 110 121 179 117 128 181 127 137 187 230 232 242 37 56 132 60 77 148 216 220 233 140 154 192 138 153 191 156 169 199 185 195 215 163 180 203 163 183 203 174 195 207 174 197 207 178 200 208 182 203 211 184 205 211 202 224 219 202 226 220 202 226 219 210 230 224 31 132 78 194 222 207 199 224 211 61 150 100 68 154 105 86 166 120 115 179 143 87 171 114 88 171 113 88 171 114 88 170 113 77 167 101 77 166 101 97 176 96 131 190 129 131 189 129 147 197 135 241 241 237 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'A@@DP@9@_<@_6@?>[? _>G?>_?5?>G?0_8A=@GH@@@@b') ; yourself); yourself]
!

stckframe_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/stckframe_obj.gif"

    "
     self stckframe_obj inspect
     ImageEditor openOnClass:self andSelector:#stckframe_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary stckframe_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
A XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA @@@@@@@@@@@@@@@@XFA XAA@PB@ HC@0LD@0PFA XFAPTEAPTEAPTEAPTEA XFA XFA XFA XF
A XFA XFA X@@@@@@@@@@@@@@@@FA XF@PPD@ HB@0LCA@LDA XFA TEAPTEAPTEAPTEAPXFA XFA XFA XFA XFA XFA XF@@@@@@@@@@@@@@@@A XFA DD
A@HB@ LC@0PCA@XFA XEAPTEAPTEAPTEAPTFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XFA XF@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[16 92 156 87 140 186 86 140 185 87 140 185 87 141 185 206 222 234 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@C?<O?0??@@@O?0??C?<@@@??C?<O?0@@@@@G?<b') ; yourself); yourself]
!

stckframe_running_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/stckframe_running_obj.gif"

    "
     self stckframe_running_obj inspect
     ImageEditor openOnClass:self andSelector:#stckframe_running_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary stckframe_running_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8A@PDA@PDA@PDA@PD^G!!8^@0TEA@LCAPLEAPPCG!!8^G $IBP$IBP$IBP$IBQ8^G!!8^G!!8^G!!8^
G!!8^G!!8^G!!8^@PDA@PDA@PDA@PDAG!!8^G @FAPPC@0TCAPTD@18^C@0OB0$IBP$IBP$IBP$^G 0]CAHNG!!8^G!!8^G!!8^G!!8LGA0[CADH@ DA@PDA@Q8^CATW
EAPVC@\E@0TEA@L^G 0XFQ LD0(KBP$IBP$IG!!8LF 0PC!!8^G!!8^G!!8^G!!8^C@0MG!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G!!8^G @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[171 197 220 16 92 156 85 139 185 87 140 186 86 140 185 87 141 185 136 174 205 195 214 230 194 214 230 206 222 234 220 232 240 230 239 244 31 132 78 194 222 207 199 224 211 213 232 222 61 150 100 68 154 105 86 166 120 115 179 143 87 171 114 88 171 113 88 171 114 88 170 113 77 167 101 77 166 101 97 176 96 131 190 129 131 189 129 147 197 135 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@A?>G?8_? @@G?8_?''?>_@A??''?>_?9<@G@@@@@b') ; yourself); yourself]
!

terminatedlaunch_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/terminatedlaunch_obj.gif"

    "
     self terminatedlaunch_obj inspect
     ImageEditor openOnClass:self andSelector:#terminatedlaunch_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary terminatedlaunch_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
D!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HDC0<OC0<OC0<OAAHRD!!HRC!!@PDA@PDA@PD@8RD!!HRD 8P@PDA@PDA@PLND!!HRD!!HQD@ HB@ H
B@ PDQHRD!!HRDPLGA0\GA0\GDADRD!!HRD @BAPTEAPTEAPHQD!!HRD!!H@B $IBP$IBP$J@AHRD!!HRC@HEAPTEAPTE@ 0RD!!HRD ,PA XFA XFA!!@KD!!HRD!!HK
D@LC@0LC@0LCB1HRD!!HRCP,KB0,KB0,KB04RD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD!!HRD @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[185 55 58 232 79 82 240 119 122 248 166 169 216 150 153 232 47 58 232 55 66 232 63 74 232 71 82 232 32 50 240 103 114 193 16 35 201 40 58 209 95 114 201 79 66 201 87 74 248 174 169 201 63 58 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@A?<G?0_?A?<G?0_?A?<G?0_?A?<G?0@@@@@@@@b') ; yourself); yourself]
!

thread_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/thread_obj.gif"

    "
     self thread_obj inspect
     ImageEditor openOnClass:self andSelector:#thread_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary thread_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,YF!!$[F1,[F1,[F1,[F1 XF!!DZFA [F1,[F1,[F1,XD1HRD!!LXF1,[F1,[F1,YF!!HV
F!!XRF!!$[F1,[F1,[F!!TUF!!PZEQTZF1,[F1,[F1$ZEQXZE!!TZFQ,[@@@AF1,[FALWE1\SFA,[F0@P@@TBF1 XF!!\ZFA [F1,@C0<N@@P[F1$ZFQ,[F1,[@@ J
A0\I@A,[F1,[F1,[F0@KC@,@A!!,[F1,[F1,[F1,@CP@C@!!,[F1,[F1,[F1,[@@@AF1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F1,[F0@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[31 132 78 194 222 207 199 224 211 61 150 100 68 154 105 86 166 120 115 179 143 87 171 114 88 171 113 88 171 114 88 170 113 77 167 101 77 166 101 97 176 96 131 190 129 131 189 129 147 197 135 255 255 159 255 223 95 191 159 63 255 251 240 255 191 63 154 141 115 223 159 63 110 77 37 156 104 86 84 56 48 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@A0@_0A?@O>@?8C?''G<__1>\G<@_ A<@G@@@@@b') ; yourself); yourself]
!

threads_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/threads_obj.gif"

    "
     self threads_obj inspect
     ImageEditor openOnClass:self andSelector:#threads_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary threads_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$9NS$5M3T9NS$9NS$9NS$9NSH2M0@7L#H9NS$9NS$9NS$2D HB@!!H2NS$9NS$9NS$5M0H/
M2<BM3T9NS$9NS$9M2$)M1(7JR$7NS$9NS$9NSX8K"\7K2$7MS$9BP\GE 0GA2H0LSDRL#$9NPXC@QDH@0D L3D7L#H9NS$PFP,^EA$KH3P7MS$9NS$9C1 W
G1TXE2P9NS$9NS$9NP8MB!!4SCP(*NS$9NS$9NS$\APP(HPTDJ3$9NS$9NS$9IQ,[KRX[F209NS$9NS$9NS$9NS$9NS$9NS$9NS$9NP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 159 253 247 217 255 223 95 254 249 228 252 236 180 253 242 203 186 151 38 190 156 40 198 170 77 210 186 105 252 227 151 251 227 152 218 198 132 253 236 182 175 137 32 178 141 34 182 145 35 140 112 34 191 159 63 189 158 72 195 165 75 192 162 74 156 135 79 251 221 131 252 231 168 253 235 184 255 251 240 167 126 28 173 133 31 132 102 30 137 108 32 135 105 32 153 120 41 188 155 71 168 144 87 150 116 39 147 113 39 194 165 97 205 181 126 204 198 185 132 99 29 255 191 63 145 110 37 144 108 37 174 146 88 145 122 74 255 232 186 154 141 115 247 231 206 223 159 63 110 77 37 212 205 202 230 217 212 156 104 86 220 201 195 84 56 48 194 184 181 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@A0@_0A?@O>@?8C?''?<_?1?<G>@_8A? G>@@@@b') ; yourself); yourself]
!

threadt_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/threadt_obj.gif"

    "
     self threadt_obj inspect
     ImageEditor openOnClass:self andSelector:#threadt_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary threadt_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0RD1H\GA0\GA0\GA0\G@8ND0TSC 8\GA0\GA0\GA0NB@XFA  NGA0\GA0\GA0RD0XL
D00FD1H\GA0\GA0\D0(JD0$SB (SGA0\GA0\GADPB00SC@(SD!!0\F1PTEAPTF0\MCP4HC!!0\GAPZF!!(ZF!!POD04SC 8\GA0UF1 XFA,UGAHSD!!0\GA0\E!!$C
@0LYE!!0\GA0\GA0\GA\[@PDAF1\\GA0\GA0\GA0@F!!(ZF!!(@GA0\GA0\GA0\A@HB@ HBAA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[194 38 44 232 56 64 192 16 32 232 32 48 208 96 112 255 255 159 255 223 95 232 221 186 191 159 63 255 251 240 255 191 63 255 232 186 154 141 115 223 159 63 110 77 37 229 223 216 224 220 217 237 228 224 156 104 86 84 56 48 200 88 72 199 79 67 198 66 60 196 52 52 232 80 80 240 120 120 248 168 168 216 152 152 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@A0@_0A?@O>@?8C?''?<_?1?\G<@_0A?@G<@@@@b') ; yourself); yourself]
!

workset
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/workset.gif"

    "
     self workset inspect
     ImageEditor openOnClass:self andSelector:#workset
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary workset'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
SR(*J"(*J$5MST5MST5MST4*APTEASH*ST5MST5MST5MJ0TEAPT6L#!!MST5MST5MSR4YB $@JSX2KD5MST5MST49@ HB@!!HA@Q)MST5MST5MK!! JB@\KQDQD
ST5MST5MSR<S@1XWR41LSD-MST5MST40DP(LPA,[G#4?QTA@QT5MLPXPEDH\GA0\GA0\GA1ASRTNB QCHBD GR@]G14]P44&CP4UQ"P"H2L"H2P"H$YMI2\''
C4$(JB (M2 7JC]IST5MST5JL3T4MS8>MC8>R$5MST5MQ3,:N3(<N#(:N$]MST5MST5HRD!!HRD!!HRD!!MST5MST5MST5MST5MST5MSP@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[247 248 252 249 250 253 244 246 251 235 240 250 239 243 251 249 250 252 227 235 249 153 171 202 164 181 208 165 181 208 172 188 213 185 198 220 198 209 227 221 231 247 224 233 248 201 209 222 227 235 248 231 238 249 243 246 251 235 241 250 241 245 251 237 243 251 235 241 249 245 248 252 239 244 250 247 249 251 227 223 204 250 233 158 255 245 204 255 241 193 246 223 150 255 240 193 255 240 194 255 241 194 255 234 178 255 235 178 255 235 179 149 124 63 145 122 64 143 121 65 255 227 160 224 200 143 187 144 51 184 142 51 180 140 53 180 140 54 170 136 56 165 132 58 160 129 60 155 127 61 212 178 105 255 219 142 255 220 142 255 220 143 218 189 124 255 227 161 185 142 51 177 137 54 255 213 127 255 213 128 255 214 128 227 193 125 255 219 143 217 178 113 201 138 45 200 137 45 199 137 45 197 135 44 203 139 46 201 138 46 194 132 44 187 125 40 183 122 39 191 129 42 189 127 42 187 118 32 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'_ A?@G>@_<A?0G?@_>A??''??_?=??7??A?<G?0O>@@@b') ; yourself); yourself]
!

write_obj
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/write_obj.gif"

    "
     self write_obj inspect
     ImageEditor openOnClass:self andSelector:#write_obj
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary write_obj'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
DA@PDA@PDA@PDA@PC0<PDA@PDA@PDA@PDA@PC04MC1@PDA@PDA@PDA@PC04FA 0ODA@PDA@PDA@PC04FA0 KC1@PDA@PDA@PC04FA0 FB <PDA@PDA@PC04F
A0 FC 4ODA@PDA@PC04FA0 FC $ODA@PDA@PC04FA0 FC $ODA@PDA@PC04FA0 FC $ODA@PDA@PC04FA0 FC $ODA@PDA@PC0DNB@PEC $ODA@PDA@PD@<I
A@PEC $ODA@PDA@PD@<@@0TEBP$ODA@PDA@PDA@O@0$CBP8ODA@PDA@PDA@PC0LC@ <ODA@PDA@PDA@PD@<OC0<PDA@PDA@PDA@PD@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[158 140 159 156 139 164 133 133 180 0 37 107 228 207 148 193 170 126 251 188 103 253 226 191 251 209 155 153 79 27 153 82 34 155 90 50 155 97 61 152 100 67 155 106 80 255 255 255 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@0@G @?@G<@?0G?@?8G?@?8G?@?8C?@_8A?@G8@^@@b') ; yourself); yourself]
!

write_obj_disabled
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/obj16/write_obj_disabled.gif"

    "
     self write_obj_disabled inspect
     ImageEditor openOnClass:self andSelector:#write_obj_disabled
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary write_obj_disabled'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
C 8NC 8NC 8NC 8N@@@NC 8NC 8NC 8NC 8N@@ H@@8NC 8NC 8NC 8N@@ DA@$@C 8NC 8NC 8N@@ D@PHJ@@8NC 8NC 8N@@ D@PHDB0@NC 8NC 8N@@ D
@PHDA0 @C 8NC 8N@@ D@PHDA00@C 8NC 8N@@ D@PHDA00@C 8NC 8N@@ D@PHDA00@C 8NC 8N@@ D@PHDA00@C 8NC 8N@@TG@ LEA00@C 8NC 8NC @L
@0LEA00@C 8NC 8NC @FCPTEC@0@C 8NC 8NC 8@CP0MC@\@C 8NC 8NC 8N@@4MA @@C 8NC 8NC 8NC @@@@@NC 8NC 8NC 8NC @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 231 231 231 216 216 216 206 206 206 197 197 197 184 184 184 182 182 182 154 154 154 150 150 150 148 148 148 145 145 145 139 139 139 136 136 136 113 113 113 255 255 255]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@0@G @?@G<@?0G?@?8G?@?8G?@?8C?@_8A?@G8@^@@b') ; yourself); yourself]
! !

!VDBIconLibrary class methodsFor:'icons-eclipse.platform.debug-ovr16'!

error
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/ovr16/error.gif"

    "
     self error inspect
     ImageEditor openOnClass:self andSelector:#error
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary error'
        ifAbsentPut:[(Depth8Image new) width:7; height:8; bits:(ByteArray fromPackedString:'@@@@@@@@@@@BAPDE@ @@APXDA T@@@DDA PA@@@AA@XD@P@@APXDA T@@@HE@PTC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[216 66 79 221 91 102 227 119 128 231 136 144 232 144 151 236 160 167 255 255 255]; mask:((ImageMask new) width:7; height:8; bits:(ByteArray fromPackedString:'?/;>?/;>?/8b') ; yourself); yourself]
!

skip_breakpoint_ov
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/ovr16/skip_breakpoint_ov.gif"

    "
     self skip_breakpoint_ov inspect
     ImageEditor openOnClass:self andSelector:#skip_breakpoint_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary skip_breakpoint_ov'
        ifAbsentPut:[(Depth8Image new) width:15; height:15; bits:(ByteArray fromPackedString:'
@@HCA@PDA@PDA@PDA@PD@P@B@0PDA@PDA@PDA@PD@0D@@ LDA@PDA@PDA@PDA@LA@@HCA@PDA@PDA@PDA@PC@P@B@0PDA@PDA@PDA@PD@0D@@ LDA@PDA@PD
A@PDA@LA@@HCA@PDA@PDA@PDA@PC@P@B@0PDA@PDA@PDA@PD@0D@@ LDA@PDA@PDA@PDA@LA@@HCA@PDA@PDA@PDA@PC@P@B@0PDA@PDA@PDA@PD@0D@@ LD
A@PDA@PDA@PDA@LA@@HCA@PDA@PDA@PDA@PC@P@BA@PDA@PDA@PDA@PD@0D@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 14 111 170 193 224 110 153 198 255 255 255 255 255 255]; mask:((ImageMask new) width:15; height:15; bits:(ByteArray fromPackedString:'8@C0@O @_@@>@A<@C8@G0@O @_@@>@A<@C8@G @N') ; yourself); yourself]
!

stcksync_ov
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/ovr16/stcksync_ov.gif"

    "
     self stcksync_ov inspect
     ImageEditor openOnClass:self andSelector:#stcksync_ov
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary stcksync_ov'
        ifAbsentPut:[(Depth8Image new) width:7; height:8; bits:(ByteArray fromPackedString:'A XF@0XFA XFAP@EA XF@P@@@@DFA XB@@HFA XC@@P@@0XFA XFA XFA XFA XFA XFA XFA X@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[237 26 70 255 127 127 255 158 158 255 191 191 255 199 199 255 206 206 255 255 255]; mask:((ImageMask new) width:7; height:8; bits:(ByteArray fromPackedString:'?/;>?/;>?/8b') ; yourself); yourself]
!

transparent
"      Loaded from: /home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full/ovr16/transparent.gif"

    "
     self transparent inspect
     ImageEditor openOnClass:self andSelector:#transparent
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'VDBIconLibrary transparent'
        ifAbsentPut:[(Depth8Image new) width:16; height:16; bits:(ByteArray fromPackedString:'
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ H
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 0 0 191 63 63 127 63 63 255 127 127 191 95 95 223 191 191 255 255 255 255 255 255 0 0 0]; mask:((ImageMask new) width:16; height:16; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
! !

!VDBIconLibrary class methodsFor:'utilities'!

loadAndCompileImagesFrom:aFilename categoryPrefix: prefix

    "
    self loadAndCompileImagesFrom:'/home/jv/work/eclipse-icons/eclipse.platform.debug/icons/full' categoryPrefix: 'icons-eclipse.platform.debug'
    "

    aFilename asFilename directoryContentsAsFilenames do: [:img|
        (img isDirectory and:[img baseName endsWith: '16']) ifTrue: [
            self 
                loadAndCompileImagesFrom:img 
                categoryPrefix: ((prefix ? '') notEmptyOrNil ifTrue:[ prefix ,'-', img baseName ] ifFalse:[ img baseName ]).  
        ] ifFalse: [
            (img suffix = 'gif') ifTrue:[
                | selector |

                selector := img withoutSuffix baseName asString.
                selector := selector asSymbol.
                SmalltalkCodeGeneratorTool
                    createImageSpecMethodFor:(GIFReader fromStream:img readStream)
                    comment:'"      Loaded from: ',img asString,'"'
                    in:self class
                    selector:selector.
                (self class compiledMethodAt: selector)
                    category: prefix.
            ]
        ]
    ]

    "Created: / 22-09-2014 / 21:46:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBIconLibrary class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


VDBIconLibrary initialize!
