"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#PrintingDialog
	instanceVariableNames:'doSetup selectedPrinterHolder selectedOrientationHolder
		numberOfCopiesHolder printerListHolder printers
		setupActionEnabledHolder orientationImageLabel
		numberOfCopiesTextEnabledHolder
		orientationRadioButtonEnabledHolder okButtonEnabledHolder
		paperSizeListHolder selectedPaperSizeHolder collateHolder
		collateImageLabel collateActionEnabledHolder
		paperSizeEnabledHolder statusLabel commentLabel locationLabel
		driverNameLabel answer'
	classVariableNames:'PrintersSettings LastUsedPrinterSettings
		AskForConfirmUsageOfDefaultPrinterSettings'
	poolDictionaries:''
	category:'Interface-Printing'
!

!PrintingDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    Opens a dialog to let user ask for a printer.

    [author:]
        Felix Madrid (fm@exept.de)

    See more example in PrinterContext.
"
!

examples
"
                                                        [exBegin]
    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := PrinterContext fromPrinterInfo: printerInfo.
    printer startPrintJob: 'Some printJob from ST/X'.
    printer endPrintJob.
                                                        [exEnd]
    see more example in PrinterContext.

"
! !

!PrintingDialog class methodsFor:'initialization'!

initialize
    AskForConfirmUsageOfDefaultPrinterSettings := true.
! !

!PrintingDialog class methodsFor:'accessing'!

askForConfirmUsageOfDefaultPrinterSettings:something
    AskForConfirmUsageOfDefaultPrinterSettings := something.
! !

!PrintingDialog class methodsFor:'image specs'!

collateImage
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self nonCollateImage inspect
     ImageEditor openOnClass:self andSelector:#nonCollateImage
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'PrintingDialog class collateImage'
        ifAbsentPut:[
            (Depth8Image new)
                width:61;
                height:34;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@<KF1,[F1,[F1,[F1D@@@@@@@@@@@@@@@@@@@@@@@<KF1,[F1,[F1,[F1D@@@@@@@@@@@@@@@@@
@@@@@@@KG0PSD1LSD1LSE!!XHDP@@@@@@@@@@@@@@@@@@@@@KG0PSD1LSD1LSE!!XHDP@@@@@@@@@@@@@@@@@@@@@@B1<DD1LSD1LSD1XVBAD@@@@@@@@@@@@@
@@@@@@@@B1<DD1LSD1LSD1XVBAD@@@@@@@@@@@@@@@@@@@@@@A,DHRDPDA@R@ 0SD1TWDP@@@@@@@@@@@@@@@@@@@A,DHRDPDA@R@ 0SD1TWDP@@@@@@@@@@
@@@@@@@@@@@[D0P!!G1<OB1,[F1,[F1,[F1,Q@@@@@@@@@@@@@@@[D0P!!G1<OB1,[F1,[F1,[F1,Q@@@@@@@@@@@@@@@@F1LDHQ<_C0,[F1,[F1,[F1,[DP@@
@@@@@@@@@@@@F1LDHQ<_C0,[F1,[F1,[F1,[DP@@@@@@@@@@@@@@@A,SHRDMCP,_AALSD1LSD1LVE  Q@@@@@@@@@@@@@A,SHRDMCP,_AALSD1LSD1LVE  Q
@@@@@@@@@@@@@@@[D0P!!D1L[ABD!!DA@PD HLD1LUE1D@@@@@@@@@@@@[D0P!!D1L[ABD!!DA@PD HLD1LUE1D@@@@@@@@@@@@@F1L_HQLSF1LDHQ<_C0,[F1,[
F1,[F1,[DP@@@@@@F1L_HQLSF1LDHQ<_C0,[F1,[F1,[F1,[DP@@@@@@@A,SHRDSD1,SABD_G0<KF1,[F1,[F1,[F1D@@@@@@A,SHRDSD1,SABD_G0<KF1,[
F1,[F1,[F1D@@@@@@@@[D1LSD1L[D2D!!CP4KG0PSD1LSD1LSE!!XHDP@@@@@[D1LSD1L[D2D!!CP4KG0PSD1LSD1LSE!!XHDP@@@@@@F1LSD1LSF1L!!AALSF0P!!
AA@PDAHBCALSEQ\Q@@@@F1LSD1LSF1L!!AALSF0P!!AA@PDAHBCALSEQ\Q@@@@@A,SD1LSD1,SHPPSD1,DHPPPDA@R@ 0SD1TWDP@@@A,SD1LSD1,SHPPSD1,D
HPPPDA@R@ 0SD1TWDP(@@@@[D1LSD1L[D2D!!D1L[D2DDG1<_@A(CD1LGF@XQ@@@[D1LSD1L[D2D!!D1L[D2DDG1<_@A(CD1LGF@XQ@@@@F1LSD1LSF1LSD1LS
F1L!!A@4MG0\IC!!LSD1LSF0@@F1LSD1LSF1LSD1LSF1L!!A@4MG0\IC!!LSD1LSF0@@@A,SD1LSD1,SD1LSD1,SHPPSD10VDAHEAPL^D1,@@A,SD1LSD1,SD1LS
D1,SHPPSD10VDAHEAPL^D1,@@@@[D1LSD1L[D1LSD1L[D2DDD1L\E!!@RAPTCG!!L[@@@[D1LSD1L[D1LSD1L[D2DDD1L\E!!@RAPTCG!!L[@@@@F1LSD1LSF1LS
D1LSF1L!!AALSD10VD@$I@!!PSF0@@F1LSD1LSF1LSD1LSF1L!!AALSD10VD@$I@!!PSF0@@@A,\D1LSD1,SD1LSD1,SD1LSD1LSGAXGA0@ID1,@@A,\D1LSD1,S
D1LSD1,SD1LSD1LSGAXGA0@ID1,@@@@[GALSD1L[D1LSD1L[D1LSD1LSD10VA0\@BQL[@@@[GALSD1L[D1LSD1L[D1LSD1LSD10VA0\@BQL[@@@@GQX\D1LS
F1LSD1LSF1LSD1LSD1LSA@4MA0\SF0@@GQX\D1LSF1LSD1LSF1LSD1LSD1LSA@4MA0\SF0@@@B@]F1,[F1,SD1LSD1,SD1LSD1LSD10MCP4VD1,@@B@]F1,[
F1,SD1LSD1,SD1LSD1LSD10MCP4VD1,@@@@ GQ,[F1,[D1LSD1L[D1LSD1LSD1L\CP4ME!!L[@@@ GQ,[F1,[D1LSD1L[D1LSD1LSD1L\CP4ME!!L[@@@@@@@@
@@@@F10SD1LSF1LSD1LSGA0\A@PDE!!XSF0@@@@@@@@@@F10SD1LSF1LSD1LSGA0\A@PDE!!XSF0@@@@@@@@@@@A4VGALSD1,SD1LSD10\A@PDA@PDD1,@@@@@
@@@@@A4VGALSD1,SD1LSD10\A@PDA@PDD1,@@@@@@@@@@@@ GQ,[F1,[D1LSD1LSGA0\GA0\GAL[@@@@@@@@@@@ GQ,[F1,[D1LSD1LSGA0\GA0\GAL[@@@@
@@@@@@@@HA4[F1,[F1LSD1LSD10\GA0\GA0SF0@@@@@@@@@@HA4[F1,[F1LSD1LSD10\GA0\GA0SF0@@@@@@@@@@@@@@@@@@@A,\D1LSD1LSD1LSD1LSGA,@
@@@@@@@@@@@@@@@@@A,\D1LSD1LSD1LSD1LSGA,@@@@@@@@@@@@@@@@@@@@]E!!0SD1LSD1LSD1LSGAXK@@@@@@@@@@@@@@@@@@@]E!!0SD1LSD1LSD1LSGAXK
@@@@@@@@@@@@@@@@@@@@GQX\D1LSD1LSD1LSD10VB0@@@@@@@@@@@@@@@@@@GQX\D1LSD1LSD1LSD10VB0@@@@@@@@@@@@@@@@@@@B@]F1,[F1,[F1,[F1,[
B2@@@@@@@@@@@@@@@@@@@B@]F1,[F1,[F1,[F1,[B2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@a');
                colorMapFromArray:#[ 243 243 243 254 254 254 239 239 239 234 234 234 250 250 250 236 236 236 195 195 195 246 246 246 192 192 192 242 242 242 253 253 253 204 204 204 233 233 233 249 249 249 235 235 235 227 227 227 245 245 245 223 223 223 241 241 241 252 252 252 237 237 237 231 231 231 248 248 248 193 193 193 244 244 244 255 255 255 240 240 240 201 201 201 251 251 251 203 203 203 230 230 230 247 247 247 226 226 226 40 40 40 ];
                mask:((ImageMask new)
                            width:61;
                            height:34;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@C?>@@C?>@@@O?<@@O?<@@@??0@@??0@@C?? @C?? @@O??8@O??8@@??? @??? @C???@C???@@O??>@O??>@@???? ???? C??
?>C???>@O???<O???<@????8????8C????#????0O????O????@????<????<C????3????0O????O????@????<????<C????3????0O????O????@????<
????<C????3????0O????O????@@???<@???<@C???0C???0@O???@O???@@???<@???<@@C??0@C??0@@O??@@O??@@@??<@@??<@@C??0@C??0@@@@@@@@
@@@b');
                            yourself);
                yourself
        ]

    "Created: / 01-08-2006 / 14:13:41 / fm"
!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon inspect
     ImageEditor openOnClass:self andSelector:#icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'PrintingDialog class icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@RB4QD1\VC#\@@@@@@@@@@@5< W9>_V0/H @@@@@@@@@T!!%9]U$>JW3T4@@@@@@@@D(Y XU!!S]G18B@@@@@@@@ABEY6!!]U4)F!!@,@@@@@WCXO &5*YE-O
SXLIFT,@\S5ZDW=0[&Y"UUF@CE@(V#-#]28.K"8.K"8.K"97T"P2#(9Y!!8^G!!8^G!!8]T#(8&LH.KQGMYVU%YVU%3PH.KF"1+Z31/S$9NS$9NZ3%+Z0T)RT$8
ZT]GQ4]GQ6T3RT$CI4UEN#D1J2TZEP\FITUE@"MAQSECSD1LSD1LP QEO @?J!! ]"G-:^WY5\($\@P(;@@@@GBD HB@_G!!8!!F0@@@@@a');
                colorMapFromArray:#[ 34 34 34 35 35 35 36 36 36 41 41 41 43 43 43 62 62 62 65 65 65 66 66 66 69 126 192 71 130 195 72 72 72 72 130 194 73 132 199 74 134 195 74 135 195 75 136 196 77 137 196 77 138 199 78 138 197 78 139 200 80 139 198 81 81 81 82 141 201 82 142 200 87 87 87 94 94 94 96 96 96 96 146 199 96 147 199 96 148 199 99 150 201 99 150 202 100 150 202 100 151 202 102 146 218 105 105 105 107 107 107 109 109 109 110 110 110 111 111 111 115 115 115 116 116 116 119 119 119 120 120 120 121 121 121 122 168 213 124 124 124 124 177 226 125 125 125 128 128 128 129 129 129 130 130 130 130 166 211 131 181 226 132 132 132 139 173 219 140 140 140 141 141 141 148 148 148 149 149 149 150 150 150 153 153 153 154 154 154 159 159 159 162 162 162 166 166 166 167 169 172 169 171 174 170 170 170 180 180 180 180 212 243 184 184 184 184 205 231 186 186 186 186 214 245 187 187 187 188 191 196 188 218 246 190 190 190 193 220 248 194 194 194 194 221 249 195 195 195 195 221 249 197 197 197 199 224 250 200 224 249 200 224 250 202 225 250 203 203 203 204 204 204 204 225 251 205 205 205 205 227 251 205 227 252 205 230 252 207 227 252 207 228 252 209 228 252 210 210 210 210 230 252 211 211 211 211 229 253 211 230 252 211 231 253 212 212 212 213 231 253 215 215 215 215 230 242 215 231 254 215 232 254 216 216 216 216 232 254 220 220 220 222 232 242 223 223 223 223 233 244 225 234 244 230 237 247 232 232 232 233 239 245 233 240 248 235 241 249 236 241 249 236 242 247 236 242 248 237 243 248 237 244 249 237 244 250 238 244 248 239 244 249 239 244 250 240 244 248 240 244 249 241 245 249 242 242 242 246 247 249 246 248 250 248 251 253 249 249 249 249 250 252 250 250 250 252 252 252 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'G>@_<A?8G? _>G?>????????????????????????G? b');
                            yourself);
                yourself
        ]

    "Modified: / 28-07-2006 / 16:35:25 / fm"
!

landscapeImage
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self landscapeImage inspect
     ImageEditor openOnClass:self andSelector:#landscapeImage
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'PrintingDialog class landscapeImage'
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
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@<[D1LSD1LSD1LSD1LSD1LSD0D@@@@@@@@@@@@OF1LSD1LSD1LSD1LSD1LSD1LA@@@@@@@@@@@@F0XKB0LC@0LC
@0LC@0LC@0LCE D@@@@@@@@@@ALK@0L]C @@@@@P@@@@@@LC@0 X@PD@@@@@@@@S@0LCGPXWE1\NB@(@@@@C@0LWCP\G@P@@@@@@D0LC@0LC@0LC@0LC@0LC
@0LCE0@GA0D@@@@@@ALCBPDA@PDA@PDA@PDA@PDA@Q\@@@\A@@@@@@@S@0@@@@@@@@@@@@@@@@@@@@@@@@X\G0@@@@@@D0LI@1P]A XFB14FA @BC@0LC@@@
GA<@@@@@@ALCBPDA@PDA@PDA@PDA@PDA@PDAGQ0_@@@@@@@S@0@@@@@@@@@@@@@@@@@@@@@@@@@\G0@@@@@@D0LI@0,KB0,K@0LC@0,FC 8N@@ ]GA<@@@@@
@ALCBPDA@PDA@PDA@PDA@PDA@PDAGQ0_@@@@@@@S@0$C@0,KB0,C@0LC@0,]GQ4]C!!4\G0@@@@@@D0LI@0LC@0LC@0LC@0LCEAPTGPX]GA<@@@@@@ALCBPDA
@PDA@PDA@PDA@PDA@PDAGQ0_@@@@@@@S@0$C@0LC@0LC@0LC@0LC@0LC@0L\G0@@@@@@D0,C@0LC@0LC@0LC@0LCB0,KEA4TGA<@@@@@@ALK@0LC@0LC@0LC
@0LC@0,KB1P]EA0_@@@@@@@DGA0\GA0\GA0\GA0\GA0\GA0\GA0\G0@@@@@@C1<_G1<_G1<_G1<_G1<_G1<_G1<_G18@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 245 245 245 223 223 223 241 241 241 252 252 252 203 203 203 232 232 232 248 248 248 193 193 193 244 244 244 255 255 255 240 240 240 251 251 251 236 236 236 231 231 231 247 247 247 226 226 226 243 243 243 254 254 254 239 239 239 201 201 201 250 250 250 235 235 235 194 194 194 246 246 246 192 192 192 242 242 242 253 253 253 204 204 204 233 233 233 249 249 249 227 227 227 150 150 150 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@A???@@_??0@G??>@A???8@_???@G???0A???<@_???@G???0A???<@_???@G???0A???<@_???@G???0A???<@_???@G???0A??
?<@_???@G???0@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Modified: / 01-08-2006 / 11:26:23 / fm"
!

nonCollateImage
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self collateImage inspect
     ImageEditor openOnClass:self andSelector:#collateImage
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'PrintingDialog class nonCollateImage'
        ifAbsentPut:[
            (Depth8Image new)
                width:70;
                height:29;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
EQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEQTUEP@@@@@@@@@@@ATIA PDA@PDA@PDA@PGEQTUEQTU
EQTUEP$FA@PDA@PDA@PDA@\UEQTUEQTUEQTUBPXDA@PDA@PDA@PDA1T@@@@@@@@@@@@UBPXDA@PDA@PDA@PDA0@@@@@@@@@@@@@IA PDA@PDA@PDA@PG@@@@
@@@@@@@@@@$FA@PDA@PDA@PDA@\U@@@@@@@@@@@@EPXYGA8^G!!8^G!!8ZF DGA1TUEQTUEQTUA!!$\G!!8^G!!8^G!!(Z@P\@@@@@@@@@@ATFFQ0^G!!8^G!!8^F!!(A
A0@@@@@@@@@@@ATDG@@_E1\WD1DLG!!8K@ \UEQTUEQTUEPP\@@@WE1\SDP0^G ,BA0@@@@@@@@@UAA0@@A\WE1LQCA8^B0HG@@@@@@@@@@@UAA8@G1$YBPXD
A@PDA@PDA@PDA1TUEQTDG!!0@FQ$IA PDA@PDA@PDA@P@@@@@@@P^G@@YFP$FA@PDA@PDA@PDA@\@@@@@EPP^@A<YFP$FA@PDA@PDA@PDA@\GEQTUAA8\@A$Y
BPXDA@PDA@PDA@PDA0@@@@@DG!!0@FQ$IA PDA@PDA@PDA@PG@@@@@ATDG @_F1,FFQ0^G!!8^G!!8^F!!(AA1TUEPP^@@@[F0XYGA8^G!!8^G!!8ZF DG@@@@AA8@
@A,[A!!$\G!!8^G!!8^G!!(Z@P\@@@@UAA8@G18^AA0@GA\WE1LQCA8^B0HGEQTDG @\G!!8DG@@@E1\WD1DLG!!8K@ \@@@P^G@@^G P\@@@WE1\SDP0^G ,BA0@@
EPP^@A<^G P\@A0WE1\SDP0^G ,BA0\UAA8@GA8^AA0\@A\WE1LQCA8^B0HGD0@DG!!<@G!!8DG!!0@E1\WD1DLG!!8K@ \@@ATDG @_G!!8DG @\FQ$YEQHMG!!8X
E LG@@P^@@@^G P^G@@YFQ$UD 4^G!! V@0\@AA8@@A8^AA8\@A$YFQTRCQ8^FAXCA0@UAA8^G!!8^AA8@GA,[FQ TC!!8^G!!8^A@@DG!!8^G!!8DG @@F1,YFAPN
G!!8^G!!8D@@P^G!!8^G P^@@@[F1$XE@8^G!!8^G P@EPP^G!!8^G P^@A0^G!!4ZE1LOC04JG P@AA8^G!!8^AA8@GA8^GQ(WD0<OCP(^A@@DG!!8^G!!8DG!!0@G!!8]
F!!\SC0<MB!!8D@ATDG!!8^G!!8DG @\G!!8]F!!\SC0<MB!!8D@@P^G!!8^G P^@A0^G!!4ZE1LOC04JG P@AA8^G!!8^AA8_@A8^GQ(WD0<OCP(^A@@UAA8^G!!8^AA8@
GA8^G!!4ZE1PTDQ@^A@@DG!!8^G!!8DG @@G!!8^GQ(WEAPQDA8D@@P^G!!8^G P^@@@^G!!8]F!!\TEADPG P@EPP^G!!8^G P^G!!8^G!!8^GQ(XFATTG P@AA8^G!!8^
AA8^G!!8^G!!8]F!! XEQP^A@@DG!!8^G!!8DG!!8^G!!8^G!!4ZFA UEA8D@ATDG!!8^G!!8DG!!8^G!!8^G!!4ZFA UEA8D@@P^G!!8^G P^G!!8^G!!8^GQ(XFATTG P@AA8^
G!!8^AA8^G!!8^G!!8]F!! XEQP^A@@UAA8^G!!8^AA8^G!!8^G!!8^GA,[FA ^A@@DG!!8^G!!8DG!!8^G!!8^G!!8\F1,XFA8D@@P^G!!8^G P^G!!8^G!!8^G!!0[F1 XG P@
EPP^G!!8^G P^G!!8^G!!8^G!!4[F1,ZG P@AA8^G!!8^AA8^G!!8^G!!8^GQ,[F1(^A@@DG!!8^G!!8DG!!8^G!!8^G!!8]F1,[F!!8D@ATDG!!8^G!!8DG!!8^G!!8^G!!8]F1,[
F!!8D@@P^G!!8^G P^G!!8^G!!8^G!!4[F1,ZG P@AA8^G!!8^AA8^G!!8^G!!8^GQ,[F1(^A@@UAA4^G!!8^AA8^G!!8^GQ4]GA0\F!!(^A@@DGQ8^G!!8DG!!8^G!!8]GQ4\
GA0ZF!!8D@@P]G!!8^G P^G!!8^G!!4]GQ0\GA(ZG P@EPTZGQ8^G P^G!!8^G!!4]GA0\GA0\G P@AQ(]G!!8^AA8^G!!8^GQ4\GA0\GA0^A@@EF!!4^G!!8DG!!8^G!!8]
GQ0\GA0\GA8D@ATHAPPDA@PDG!!8^G!!8^GQ4]GQ4]GQ8D@@ EA@PDA@P^G!!8^G!!8]GQ4]GQ4]G P@B@TDA@PDAA8^G!!8^G!!4]GQ4]GQ4^A@@UB@TDA@PDAA8^
G!!8^G!!4]GQ4]GQ4^A@@HAPPDA@PDG!!8^G!!8^GQ4]GQ4]GQ8D@@ EA@PDA@P^G!!8^G!!8]GQ4]GQ4]G P@EP@@@@@@@@P]G!!8^G!!8^G!!8^G!!8^GPP@@@@@@@@@
AA4^G!!8^G!!8^G!!8^G!!8]A@@@@@@@@@@DGQ8^G!!8^G!!8^G!!8^G!!4D@AT@EQTUEQTEF!!4^G!!8^G!!8^G!!8^GQ(F@@@@@@@@@@TZGQ8^G!!8^G!!8^G!!8]F X@@@@@
@@@@AQ(]G!!8^G!!8^G!!8^G!!4ZA @U@ATUEQTUAQ(]G!!8^G!!8^G!!8^G!!4ZA @@@@@@@@@EF!!4^G!!8^G!!8^G!!8^GQ(F@@@@@@@@@@TZGQ8^G!!8^G!!8^G!!8]F X@
EP@UEQTUEP EA@PDA@PDA@PDA@PDA  @@@@@@@@@B@TDA@PDA@PDA@PDA@PFB@@@@@@@@@@HAPPDA@PDA@PDA@PDA@XH@AT@EQTUEQTU@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@ATUEQTUEQT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 40 40 40 192 192 192 193 193 193 195 195 195 201 201 201 203 203 203 204 204 204 223 223 223 226 226 226 227 227 227 230 230 230 231 231 231 233 233 233 234 234 234 235 235 235 236 236 236 237 237 237 239 239 239 240 240 240 241 241 241 242 242 242 243 243 243 244 244 244 245 245 245 246 246 246 247 247 247 248 248 248 249 249 249 250 250 250 251 251 251 252 252 252 253 253 253 ];
                mask:((ImageMask new)
                            width:70;
                            height:29;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@_?0@?? A??@@_?0@?? A??@@_?<@??0A?? @_?<@??8A??0@_??0???A???@_??8???!!???@_??8???1??? _??<???9???0_??>???=???0
_??>???=???8_??>???=???8_??>???=???8_??>???=???8_??>???=???8_??>???=???8_??>???=???8_??>???=???8_??>???=???8_??>???=???8
_??>???=???8_??>???=???8_??>???=???8_??>???=???8@_?>@??<A??8@_?>@??<A??8@_?>@??<A??8@_?>@??<A??8@@@@@@@@@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 01-08-2006 / 14:13:28 / fm"
!

numberOfCopiesImage
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self numberOfCopiesImage inspect
     ImageEditor openOnClass:self andSelector:#numberOfCopiesImage
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'PrintingDialog class numberOfCopiesImage'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:25;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A<^G <OC0<OC04M@@@@@@@@@@@@@@@@@A8LC@$IBP$SAQTUE0@@@@@@@@@@@@@@@A8LC@$IBP$SAQTUE0@@@@@@
@@@@@@@@@@<IBPT A X]B@DAF \GCP@@@@@@@@@@@@<IBQX\@ HIBP$ID0TEEQ\@@@@@@@@@@@<IBQX\@ HIBP$ID0TEEQ\@@@@@@@@@@@<IBPH\BP$EH@XF
GP H@Q(GA04@@@@@@@<IBQLRBP$VG@HBBP$IBP$VE!!TM@@@@@@<IBQLRBP$VG@HBBP$IBP$VE!!TM@@@@@@<IBQLHBP$BG@$IAQDQ@A$IBP8\CP4@@@<IBQLH
BP$SD $IE 8NF0LIBP$IC0<@@@<IBQLHBP$SB@$ID1XVFA,TEA$IC0<@@@<IBQLHBP$SB@$ID1XVFA,TEA$IC0<@@@<IBQLRBP$SB@$IBQLSE 8QDP@IC0<@
@@<IBQLHBP$SB@$IBP$ID00NC"HIC0<@@@<IBQLHBP$SB@$IBP$ID00NC"HIC0<@@@4OC2LDBP$SD $IBP$IBPHLC@TIC0<@@@@@@@@#BP$SB@$IBP$IBQLB
@ HIC0<@@@@@@@@#BP$SB@$IBP$IBQLB@ HIC0<@@@@@@@@MC0<#A@$IBQLSD1LSD1LIC0<@@@@@@@@@@@@@H0$IBP$IBP$IBP$VB (@@@@@@@@@@@@@CP<O
C0<OC0<OC0<JB0,@@@@@@@@@@@@@CP<OC0<OC0<OC0<JB0,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 239 239 239 193 193 193 250 250 250 235 235 235 158 158 158 247 247 247 188 188 188 176 176 176 199 199 199 252 252 252 204 204 204 226 226 226 249 249 249 223 223 223 246 246 246 201 201 201 254 254 254 243 243 243 197 197 197 251 251 251 237 237 237 192 192 192 248 248 248 222 222 222 245 245 245 234 234 234 153 153 153 242 242 242 194 194 194 183 183 183 202 202 202 225 225 225 214 214 214 255 255 255 244 244 244 200 200 200 ];
                mask:((ImageMask new)
                            width:24;
                            height:25;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@_?@@_? @_? @_?<@_?>@_?>@_??0_??8_??8_??>_??>_??>_??>_??>_??>_??>_??>A??>A??>A??>@G?>@G?>@G?>@@@@');
                            yourself);
                yourself
        ]

    "Modified: / 28-07-2006 / 14:22:14 / fm"
!

portraitImage
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self portraitImage inspect
     ImageEditor openOnClass:self andSelector:#portraitImage
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'PrintingDialog class portraitImage'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E!!XR
@PDA@PDA@PDA@PDA@PDX@@@@@@@@@@@@@AHRAP,KF!!(ZF!!(ZF!!(ZGQ4]C1 X@@@@@@@@@@@A@P,_G1\WE1\WFP$B@!!(ZF!!0^G!! @@@@@@@@@@PDKG1<B@!!\W
E1$B@ HZF!!(\G!!8X@@@@@@@@@@DAF HB@ HB@ HB@ HB@ HBC!!<_CQ @@@@@@@@A@Q(B@ HB@ HB@ HB@ HZ@!!(ZF!!L @@@@@@@@@PDZ@ XFA XFA XFA XF
A XFA!!(SH@@@@@@@@@DAF HB@ HB@ HB@ H@@@@B@ @ZD2@@@@@@@@@A@Q(B@ HB@ HB@ HB@ HB@ HBF!!L @@@@@@@@@PDZF HB@ HZF H]GQ\PDA@IF1(S
H@@@@@@@@@DAF!!(FA XFA XFA XFA XFA XZD2@@@@@@@@@A@Q(Z@ HB@ HB@ HB@ HB@ HBF!!L @@@@@@@@@PDZF!!(ZF!!(ZF!!(ZF ,TEAPNC!!(SH@@@@@@@
@@DAF!!(ZF!!(ZF!!(ZF!!(BEAPTEA4ZD2@@@@@@@@@A@Q(ZFA XFA XFA XFA XFA XF!!L @@@@@@@@@PDZF!!(ZF!!(Z@ HKB0,KB0,KB1(SH@@@@@@@@@DAF!!(Z
F!!(ZF HBB0,KB0,KB0,ZD2@@@@@@@@@A@Q(ZF!!(ZF!!(B@ ,KB0,KB0,KF!!L @@@@@@@@@PDZF!! XFA XFA XFA XFA XFA(SH@@@@@@@@@DA@!!(ZF!!(ZF!!(Z
F!!(ZF!!(ZF!!(ZD2@@@@@@@@@C@14BF!!(ZF!!(ZF!!(ZF!!(ZF!!(ZF!!L @@@@@@@@@0LSD1LSD1LSD1LSD1LSD1LSD1LSH@@@@@@@@@XFHB@ HB@ HB@ HB@ HB@ 
HB@ H@X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 240 240 240 201 201 201 251 251 251 203 203 203 230 230 230 247 247 247 226 226 226 243 243 243 254 254 254 239 239 239 234 234 234 250 250 250 236 236 236 195 195 195 246 246 246 192 192 192 242 242 242 253 253 253 204 204 204 233 233 233 249 249 249 235 235 235 227 227 227 245 245 245 223 223 223 241 241 241 252 252 252 237 237 237 231 231 231 248 248 248 193 193 193 244 244 244 150 150 150 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@G??8@A??? @_??<@G???@A???8@_??>@G??? A???8@_??>@G??? A???8@_??>@G??? A???8@_??>@G??? A???8@_??>@G??? A??
?8@_??>@G??? A???8@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Modified: / 01-08-2006 / 11:26:17 / fm"
! !

!PrintingDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PrintingDialog andSelector:#windowSpec
     PrintingDialog new openInterface:#windowSpec
     PrintingDialog open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Printers '
          name: 'Printers '
          min: (Point 452 477)
          max: (Point 452 535)
          bounds: (Rectangle 0 0 452 477)
          icon: icon
        )
        component: 
       (SpecCollection
          collection: (
           (SequenceViewSpec
              name: 'PrintersList'
              layout: (LayoutFrame 10 0 32 0 445 0 177 0)
              model: selectedPrinterHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              valueChangeSelector: printerSelectionChanged
              useIndex: true
              sequenceList: printerListHolder
            )
           (LabelSpec
              label: 'Select a Printer:'
              name: 'Label1'
              layout: (AlignmentOrigin 9 0.0 14 0 0 0)
              translateLabel: true
              resizeForLabel: true
              adjust: left
            )
           (FramedBoxSpec
              label: 'Copies'
              name: 'CopiesFrame'
              layout: (LayoutFrame 5 0.0 323 0.0 228 0.0 431 0.0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'collateImage'
                    name: 'collateImage'
                    layout: (LayoutFrame 97 0 42 0 195 0 74 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    postBuildCallback: collateImagePostBuild:
                  )
                 (CheckBoxSpec
                    label: 'Collate'
                    name: 'CheckBox1'
                    layout: (LayoutFrame -6 0 47 0 90 0 69 0)
                    enableChannel: collateActionEnabledHolder
                    model: collateHolder
                    translateLabel: true
                  )
                 (LabelSpec
                    label: 'Number of Copies:'
                    name: 'Label2'
                    layout: (LayoutFrame -1 0.0 12 0.0 94 0.0 34 0.0)
                    translateLabel: true
                    adjust: left
                  )
                 (InputFieldSpec
                    name: 'numberOfCopiesEntryField'
                    layout: (LayoutFrame 97 0.0 12 0.0 196 0.0 34 0.0)
                    enableChannel: numberOfCopiesTextEnabledHolder
                    model: numberOfCopiesHolder
                    type: integerInRange
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    minValue: 1
                    maxValue: 999
                    acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'Orientation'
              name: 'OrientationFrame'
              layout: (LayoutFrame 227 0.0 323 0.0 453 0.0 430 0.0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (RadioButtonSpec
                    label: 'Portrait'
                    name: 'PortraitRadioButton'
                    layout: (LayoutFrame 0 0.0 10 0.0 104 0.0 32 0.0)
                    translateLabel: true
                    model: selectedOrientationHolder
                    enableChannel: orientationRadioButtonEnabledHolder
                    isTriggerOnDown: true
                    select: portrait
                  )
                 (RadioButtonSpec
                    label: 'Landscape'
                    name: 'LandscapeRadioButton'
                    layout: (LayoutFrame 0 0.0 43 0.0 105 0.0 65 0.0)
                    translateLabel: true
                    model: selectedOrientationHolder
                    enableChannel: orientationRadioButtonEnabledHolder
                    isTriggerOnDown: true
                    select: landscape
                  )
                 (LabelSpec
                    label: 'orientationImage'
                    name: 'orientationImage'
                    layout: (LayoutFrame 124 0.0 19 0.0 159 0.0 51 0.0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    postBuildCallback: orientationImagePostBuild:
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'Paper'
              name: 'PaperFrame'
              layout: (LayoutFrame 5 0.0 323 0.0 451 0.0 379 0.0)
              initiallyInvisible: true
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (ComboBoxSpec
                    name: 'paperSizeList'
                    layout: (LayoutFrame 97 0.0 2 0.0 406 0.0 22 0.0)
                    initiallyDisabled: true
                    enableChannel: paperSizeEnabledHolder
                    model: selectedPaperSizeHolder
                    type: string
                    acceptOnPointerLeave: false
                    comboList: paperSizeListHolder
                    isFilenameBox: false
                  )
                 (LabelSpec
                    label: 'Paper size:'
                    name: 'Label3'
                    layout: (LayoutFrame 0 0.0 2 0.0 87 0.0 24 0.0)
                    translateLabel: true
                    adjust: left
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: '__Information'
              name: 'FramedBox1'
              layout: (LayoutFrame 5 0.0 184 0.0 451 0.0 320 0.0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Status:'
                    name: 'Status'
                    layout: (LayoutFrame 0 0.0 6 0.0 64 0.0 28 0.0)
                    translateLabel: true
                    adjust: left
                  )
                 (LabelSpec
                    label: 'Status'
                    name: 'StatusLabel'
                    layout: (LayoutFrame 99 0.0 5 0.0 405 0.0 27 0.0)
                    translateLabel: true
                    adjust: left
                    postBuildCallback: statusLabelPostBuild:
                  )
                 (LabelSpec
                    label: 'Driver Name:'
                    name: 'DriverName'
                    layout: (LayoutFrame 0 0.0 29 0.0 64 0.0 51 0.0)
                    translateLabel: true
                    adjust: left
                  )
                 (LabelSpec
                    label: 'Location:'
                    name: 'Location'
                    layout: (LayoutFrame 0 0.0 54 0.0 64 0.0 76 0.0)
                    translateLabel: true
                    adjust: left
                  )
                 (LabelSpec
                    label: '__Comment:'
                    name: 'Comment'
                    layout: (LayoutFrame 0 0.0 80 0.0 64 0.0 102 0.0)
                    translateLabel: true
                    adjust: left
                  )
                 (LabelSpec
                    label: 'DriverName'
                    name: 'DriverNameLabel'
                    layout: (LayoutFrame 99 0 30 0 405 0 52 0)
                    translateLabel: true
                    adjust: left
                    postBuildCallback: driverNameLabelPostBuild:
                  )
                 (LabelSpec
                    label: 'Location'
                    name: 'LocationLabel'
                    layout: (LayoutFrame 99 0 54 0 405 0 76 0)
                    translateLabel: true
                    adjust: left
                    postBuildCallback: locationLabelPostBuild:
                  )
                 (LabelSpec
                    label: 'Comment'
                    name: 'CommentLabel'
                    layout: (LayoutFrame 99 0 80 0 405 0 102 0)
                    translateLabel: true
                    adjust: left
                    postBuildCallback: commentLabelPostBuild:
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -45 1 0 1.0 0 1)
              horizontalLayout: center
              verticalLayout: center
              horizontalSpace: 10
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Setup...'
                    name: 'SetupButton'
                    translateLabel: true
                    model: openSetup
                    enableChannel: setupActionEnabledHolder
                    extent: (Point 115 22)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'CancelButton'
                    translateLabel: true
                    model: close
                    extent: (Point 115 22)
                  )
                 (ActionButtonSpec
                    label: 'Print'
                    name: 'OKButton'
                    translateLabel: true
                    model: accept
                    enableChannel: okButtonEnabledHolder
                    isDefault: true
                    defaultable: true
                    extent: (Point 115 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!PrintingDialog class methodsFor:'opening'!

getPrinterInfo
    ^ self getPrinterInfoWithoutDialog:false
!

getPrinterInfoFromDialog
    "Opens the Printer Dialog and returns a PrinterInfo after selecting a printer and defining the printing settings"
    
    |dialog|

    dialog := self new.
    dialog openModal.
    ^ dialog answer.

    "Created: / 02-08-2006 / 16:46:50 / fm"
    "Modified: / 03-08-2006 / 11:28:12 / fm"
    "Modified: / 10-10-2006 / 17:44:56 / cg"
!

getPrinterInfoWithoutDialog:withoutDialog
    "Returns a PrinterInfo by opening the Printer Dialog or by using the lastUserPrinterSettings"
    
    |useDefaultPrinter|

    self lastUsedPrinterSettings notNil ifTrue:[
        withoutDialog ifFalse:[
            AskForConfirmUsageOfDefaultPrinterSettings ifTrue:[
                useDefaultPrinter := self confirmUsageOfDefaultPrinterSettings.
                useDefaultPrinter isNil ifTrue:[
                    ^ nil
                ].
            ] ifFalse:[
                useDefaultPrinter := true.
            ].
        ].

        useDefaultPrinter ifTrue:[
            ^ self lastUsedPrinterSettings
        ]
    ].
    ^ self getPrinterInfoFromDialog

    "Created: / 02-08-2006 / 16:46:50 / fm"
    "Modified: / 03-08-2006 / 11:28:12 / fm"
    "Modified: / 10-10-2006 / 17:44:51 / cg"
! !

!PrintingDialog class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!PrintingDialog class methodsFor:'queries'!

confirmUsageOfDefaultPrinterSettings
    "ask if printing should be done with the last printer.
     Return true, false or nil (for cancel)"

    ^ Dialog 
        confirmWithCancel:
            (self resources 
                string:'Do you want to print with current settings of printer: "%1" ?'
                with:self lastUsedPrinterSettings userFriendlyName allBold)
        labels:(self resources array:#( 'Cancel' 'Open Dialog' 'Print' ))
        default:3.

    "
     self confirmUsageOfDefaultPrinterSettings 
    "

    "Modified: / 10-10-2006 / 17:44:36 / cg"
! !

!PrintingDialog class methodsFor:'settings'!

lastUsedPrinterSettings
    ^ LastUsedPrinterSettings

    "Created: / 04-08-2006 / 13:24:18 / fm"
    "Modified: / 10-10-2006 / 17:45:00 / cg"
!

lastUsedPrinterSettings:aPrinterInfo 
    LastUsedPrinterSettings := aPrinterInfo

    "Created: / 04-08-2006 / 13:24:18 / fm"
    "Modified: / 10-10-2006 / 17:45:07 / cg"
!

printersSettings
    PrintersSettings isNil ifTrue:[
        PrintersSettings := Dictionary new
    ].
    ^ PrintersSettings

    "Created: / 04-08-2006 / 13:24:18 / fm"
    "Modified: / 10-10-2006 / 17:45:22 / cg"
!

printersSettingsAt:printerName 
    ^ self printersSettings at:printerName ifAbsent:[ nil ]

    "Created: / 04-08-2006 / 13:51:04 / fm"
    "Modified: / 10-10-2006 / 17:45:25 / cg"
!

printersSettingsAt:printerName ifAbsentPut:aPrinterInfo 
    self printersSettings at:printerName ifAbsentPut:aPrinterInfo

    "Created: / 04-08-2006 / 13:50:40 / fm"
    "Modified: / 10-10-2006 / 17:45:29 / cg"
!

printersSettingsAt:printerName put:aPrinterInfo 
    self printersSettings at:printerName put:aPrinterInfo

    "Created: / 04-08-2006 / 13:52:11 / fm"
    "Modified: / 10-10-2006 / 17:45:32 / cg"
! !

!PrintingDialog class methodsFor:'tables'!

orientationAt:anInteger 
    ^ self orientationTable at:anInteger ifAbsent:[ nil ]

    "Created: / 28-07-2006 / 16:48:24 / fm"
    "Modified: / 10-10-2006 / 17:45:13 / cg"
!

orientationTable
    ^ (Dictionary new)
        at:1 put:#portrait;
        at:2 put:#landscape;
        yourself

    "Created: / 28-07-2006 / 16:47:36 / fm"
    "Modified: / 10-10-2006 / 17:45:17 / cg"
! !

!PrintingDialog methodsFor:'accessing'!

answer
    "Returns aPrinterInfo with all choosen settings if the print button has been pressed. Otherwise returns nil"
    
    ^ answer

    "Created: / 02-08-2006 / 17:04:16 / fm"
    "Modified: / 10-10-2006 / 17:45:44 / cg"
!

collateImage
    ^ self collateHolder value 
        ifTrue:[ self class collateImage ]
        ifFalse:[ self class nonCollateImage ]

    "Created: / 31-07-2006 / 15:41:01 / fm"
    "Modified: / 01-08-2006 / 10:02:37 / fm"
    "Modified: / 10-10-2006 / 17:45:48 / cg"
!

defaultPrinter
    ^ self printers 
        detect:[:each | each printerName = PrinterContext defaultPrinterName ]
        ifNone:[ nil ]

    "Created: / 03-08-2006 / 15:26:07 / fm"
    "Modified: / 16-04-2007 / 13:04:49 / cg"
!

defaultPrinterIndex
    ^ self printers value indexOf:self defaultPrinter

    "Created: / 03-08-2006 / 15:20:04 / fm"
    "Modified: / 10-10-2006 / 17:45:55 / cg"
!

orientationImage
    ^ self isPortraitSelected 
        ifTrue:[ self class portraitImage ]
        ifFalse:[ self class landscapeImage ]

    "Modified: / 28-07-2006 / 14:51:45 / fm"
    "Modified: / 10-10-2006 / 17:45:58 / cg"
!

orientationSymbol

    self isSelectedPrinterAvailable ifFalse:[^ nil].
    ^ self class orientationAt: self selectedPrinter orientation

    "Created: / 01-08-2006 / 12:07:33 / fm"
    "Modified: / 10-10-2006 / 17:46:01 / cg"
!

paperSizeNameFromSelectedPrinter
    self isSelectedPrinterAvailable ifFalse:[
        ^ nil
    ].
    ^ self selectedPrinter paperSizeName

    "Created: / 31-07-2006 / 16:21:17 / fm"
    "Modified: / 10-10-2006 / 17:46:04 / cg"
!

paperSizeNames
    ^ AbstractOperatingSystem::PrinterInfo paperSizeNames

    "Created: / 31-07-2006 / 15:43:13 / fm"
    "Modified: / 10-10-2006 / 17:46:07 / cg"
!

printerUserFriendlyNames
    ^ self printers collect:[:each | each userFriendlyName ]

    "Created: / 28-07-2006 / 12:20:07 / fm"
    "Modified: / 03-08-2006 / 12:50:03 / fm"
    "Modified: / 10-10-2006 / 17:46:10 / cg"
!

printers
    printers isEmptyOrNil ifTrue:[
        Error handle:[:ex |
            printers := #().
        ] do:[    
            printers := OperatingSystem getPrinters
        ].
    ].
    ^ printers

    "Created: / 28-07-2006 / 12:01:52 / fm"
    "Modified: / 31-07-2006 / 16:22:39 / fm"
    "Modified: / 10-10-2006 / 17:46:13 / cg"
!

selectedPrinter
    self hasSelectedPrinter ifFalse:[
        ^ nil
    ].
    ^ self printers at:self selectedPrinterHolder value ifAbsent:[ nil ]

    "Created: / 28-07-2006 / 11:35:38 / fm"
    "Modified: / 10-10-2006 / 17:46:16 / cg"
! !

!PrintingDialog methodsFor:'aspects'!

collateActionEnabledHolder
    collateActionEnabledHolder isNil ifTrue:[
        collateActionEnabledHolder := false asValue.
    ].
    ^ collateActionEnabledHolder.

    "Created: / 01-08-2006 / 09:31:24 / fm"
    "Modified: / 10-10-2006 / 17:46:29 / cg"
!

collateHolder
    collateHolder isNil ifTrue:[
        collateHolder := false asValue.
        collateHolder onChangeSend:#collateHolderChanged to:self.
    ].
    ^ collateHolder.

    "Created: / 31-07-2006 / 15:39:48 / fm"
    "Modified: / 01-08-2006 / 09:54:25 / fm"
    "Modified: / 10-10-2006 / 17:46:35 / cg"
!

numberOfCopiesHolder
    numberOfCopiesHolder isNil ifTrue:[
        numberOfCopiesHolder := 0 asValue.
        numberOfCopiesHolder onChangeSend:#numberOfCopiesHolderChanged to:self.
    ].
    ^ numberOfCopiesHolder.

    "Created: / 28-07-2006 / 11:21:51 / fm"
    "Modified: / 01-08-2006 / 12:19:25 / fm"
    "Modified: / 10-10-2006 / 17:46:40 / cg"
!

numberOfCopiesTextEnabledHolder
    numberOfCopiesTextEnabledHolder isNil ifTrue:[
        numberOfCopiesTextEnabledHolder := false asValue.
    ].
    ^ numberOfCopiesTextEnabledHolder.

    "Created: / 31-07-2006 / 13:11:45 / fm"
    "Modified: / 10-10-2006 / 17:46:46 / cg"
!

okButtonEnabledHolder
    okButtonEnabledHolder isNil ifTrue:[
        okButtonEnabledHolder := false asValue.
    ].
    ^ okButtonEnabledHolder.

    "Created: / 31-07-2006 / 13:12:41 / fm"
    "Modified: / 10-10-2006 / 17:46:52 / cg"
!

orientationRadioButtonEnabledHolder
    orientationRadioButtonEnabledHolder isNil ifTrue:[
        orientationRadioButtonEnabledHolder := false asValue.
    ].
    ^ orientationRadioButtonEnabledHolder.

    "Created: / 31-07-2006 / 13:12:25 / fm"
    "Modified: / 10-10-2006 / 17:46:58 / cg"
!

paperSizeEnabledHolder
    paperSizeEnabledHolder isNil ifTrue:[
        paperSizeEnabledHolder := false asValue.
    ].
    ^ paperSizeEnabledHolder.

    "Created: / 01-08-2006 / 09:39:53 / fm"
    "Modified: / 10-10-2006 / 17:47:03 / cg"
!

paperSizeListHolder
    paperSizeListHolder isNil ifTrue:[
        paperSizeListHolder := List new asValue.
    ].
    ^ paperSizeListHolder.

    "Created: / 31-07-2006 / 15:29:40 / fm"
    "Modified: / 10-10-2006 / 17:47:10 / cg"
!

printerListHolder
    printerListHolder isNil ifTrue:[
        printerListHolder := ValueHolder new.
    ].
    ^ printerListHolder.

    "Created: / 28-07-2006 / 11:21:51 / fm"
    "Modified: / 31-07-2006 / 15:54:31 / fm"
    "Modified: / 10-10-2006 / 17:47:16 / cg"
!

selectedOrientationHolder
    selectedOrientationHolder isNil ifTrue:[
        selectedOrientationHolder := #portrait asValue.
        selectedOrientationHolder onChangeSend:#selectedOrientationHolderChanged
            to:self.
    ].
    ^ selectedOrientationHolder.

    "Created: / 28-07-2006 / 11:21:51 / fm"
    "Modified: / 28-07-2006 / 14:19:02 / fm"
    "Modified: / 10-10-2006 / 17:47:25 / cg"
!

selectedPaperSizeHolder
    selectedPaperSizeHolder isNil ifTrue:[
        selectedPaperSizeHolder := ValueHolder new.
        selectedPaperSizeHolder onChangeSend:#selectedPaperSizeHolderChanged to:self.
    ].
    ^ selectedPaperSizeHolder.

    "Created: / 31-07-2006 / 15:39:26 / fm"
    "Modified: / 01-08-2006 / 09:26:53 / fm"
    "Modified: / 10-10-2006 / 17:47:29 / cg"
!

selectedPrinterHolder
    selectedPrinterHolder isNil ifTrue:[
        selectedPrinterHolder := ValueHolder new.
    ].
    ^ selectedPrinterHolder.

    "Created: / 28-07-2006 / 11:21:51 / fm"
    "Modified: / 10-10-2006 / 17:47:34 / cg"
!

setupActionEnabledHolder
    setupActionEnabledHolder isNil ifTrue:[
        setupActionEnabledHolder := false asValue.
    ].
    ^ setupActionEnabledHolder.

    "Created: / 28-07-2006 / 12:14:48 / fm"
    "Modified: / 10-10-2006 / 17:47:38 / cg"
! !

!PrintingDialog methodsFor:'initialization & release'!

collateImagePostBuild:aLabel 
    collateImageLabel := aLabel

    "Created: / 31-07-2006 / 15:26:22 / fm"
    "Modified: / 10-10-2006 / 17:47:44 / cg"
!

commentLabelPostBuild:aLabel 
    commentLabel := aLabel

    "Created: / 01-08-2006 / 15:04:09 / fm"
    "Modified: / 10-10-2006 / 17:47:47 / cg"
!

driverNameLabelPostBuild:aLabel 
    driverNameLabel := aLabel

    "Created: / 01-08-2006 / 15:04:27 / fm"
    "Modified: / 10-10-2006 / 17:47:50 / cg"
!

locationLabelPostBuild:aLabel 
    locationLabel := aLabel

    "Created: / 01-08-2006 / 15:04:18 / fm"
    "Modified: / 10-10-2006 / 17:47:53 / cg"
!

orientationImagePostBuild:aLabel 
    orientationImageLabel := aLabel

    "Created: / 28-07-2006 / 14:24:51 / fm"
    "Modified: / 10-10-2006 / 17:47:56 / cg"
!

postBuildWith:aBuilder 
    super postBuildWith:aBuilder.
    self updatePrintersList.
    self updatePaperSizeList.
    self clearProperties.
    self selectDefaultPrinter.

    "Created: / 02-08-2006 / 16:41:26 / fm"
    "Modified: / 03-08-2006 / 15:28:56 / fm"
    "Modified: / 10-10-2006 / 17:47:59 / cg"
!

selectDefaultPrinter
    self selectedPrinterHolder value:self defaultPrinterIndex.
    self printerSelectionChanged.

    "Modified: / 03-08-2006 / 15:29:35 / fm"
    "Modified: / 10-10-2006 / 17:48:02 / cg"
!

statusLabelPostBuild:aLabel 
    statusLabel := aLabel

    "Created: / 01-08-2006 / 13:43:32 / fm"
    "Modified: / 10-10-2006 / 17:48:04 / cg"
! !

!PrintingDialog methodsFor:'queries'!

collateActionEnabled
    ^ self isSelectedPrinterAvailable and:[ self numberOfCopiesHolder value > 1 ]

    "Created: / 01-08-2006 / 09:32:48 / fm"
    "Modified: / 10-10-2006 / 17:48:10 / cg"
!

hasSelectedPrinter
    |printerIndex|

    printerIndex := self selectedPrinterHolder value.
    ^ printerIndex notNil and:[ printerIndex > 0]

    "Modified: / 28-07-2006 / 11:34:10 / fm"
    "Modified: / 17-08-2011 / 09:41:17 / cg"
!

isPortraitSelected
    ^ self selectedOrientationHolder value = #portrait

    "Created: / 28-07-2006 / 14:48:59 / fm"
    "Modified: / 10-10-2006 / 17:48:16 / cg"
!

isSelectedPaperSize
    |paperSize|

    paperSize := self selectedPaperSizeHolder value.
    ^ paperSize notEmptyOrNil 
      and:[ (paperSize ~= self unknownPaperSizeNameDescription)]

    "Created: / 31-07-2006 / 16:05:59 / fm"
    "Modified: / 01-08-2006 / 12:18:56 / fm"
    "Modified: / 17-08-2011 / 09:41:43 / cg"
!

isSelectedPrinterAvailable
    ^ self hasSelectedPrinter and:[ self selectedPrinter isAvailable ]

    "Created: / 31-07-2006 / 13:08:18 / fm"
    "Modified: / 10-10-2006 / 17:48:52 / cg"
!

numberOfCopiesTextEnabled
    ^ self isSelectedPrinterAvailable

    "Created: / 31-07-2006 / 13:17:55 / fm"
    "Modified: / 10-10-2006 / 17:48:54 / cg"
!

okButtonEnabled
    ^ self isSelectedPrinterAvailable

    "Created: / 31-07-2006 / 13:17:37 / fm"
    "Modified: / 10-10-2006 / 17:49:22 / cg"
!

orientationRadioButtonEnabled
    ^ self isSelectedPrinterAvailable

    "Created: / 31-07-2006 / 13:17:45 / fm"
    "Modified: / 10-10-2006 / 17:49:31 / cg"
!

paperSizeEnabled
    ^ self isSelectedPrinterAvailable

    "Created: / 01-08-2006 / 09:39:30 / fm"
    "Modified: / 10-10-2006 / 17:49:35 / cg"
!

setupActionEnabled
    ^ self isSelectedPrinterAvailable

    "Created: / 28-07-2006 / 12:16:56 / fm"
    "Modified: / 31-07-2006 / 13:17:19 / fm"
    "Modified: / 10-10-2006 / 17:49:39 / cg"
! !

!PrintingDialog methodsFor:'settings'!

addOrRecoverPrinterSettings
    |settings currentPrinter |

    currentPrinter := self selectedPrinter.
    currentPrinter notNil ifTrue:[
        settings := self class printersSettingsAt:currentPrinter printerName.
        settings notNil ifTrue:[
                currentPrinter orientation:settings orientation.
                currentPrinter paperSize:settings paperSize.
        ].
    ].
    ^ self updatePrinterInPrintersSettings

    "Created: / 04-08-2006 / 13:57:36 / fm"
    "Modified: / 10-10-2006 / 17:49:43 / cg"
!

updatePrinterInPrintersSettings
    |printer|

    self isSelectedPrinterAvailable ifFalse:[^ nil].

    printer := self selectedPrinter.
    self class 
        printersSettingsAt:printer printerName
        put:printer.

    "Created: / 04-08-2006 / 13:58:21 / fm"
    "Modified: / 17-08-2011 / 09:42:31 / cg"
! !

!PrintingDialog methodsFor:'unknownPaperSize'!

addUnknownPaperSize
    self paperSizeListHolder value add:self unknownPaperSizeNameDescription

    "Created: / 31-07-2006 / 16:24:18 / fm"
    "Modified: / 10-10-2006 / 17:49:54 / cg"
!

removeUnknownPaperSize
    self paperSizeListHolder value 
        remove:self unknownPaperSizeNameDescription
        ifAbsent:[ nil ]

    "Created: / 31-07-2006 / 15:50:01 / fm"
    "Modified: / 10-10-2006 / 17:49:57 / cg"
!

unknownPaperSizeNameDescription
    ^ 'Unknown - Size defined in Printer settings'.

    "Created: / 31-07-2006 / 15:50:18 / fm"
    "Modified: / 01-08-2006 / 11:42:31 / fm"
    "Modified: / 10-10-2006 / 17:50:00 / cg"
! !

!PrintingDialog methodsFor:'update'!

clearProperties
    self numberOfCopiesHolder value:0.
    self selectedPaperSizeHolder value:''.
    statusLabel label:''.
    driverNameLabel label:''.
    locationLabel label:''.
    commentLabel label:''.

    "Created: / 01-08-2006 / 12:17:46 / fm"
    "Modified: / 01-08-2006 / 15:07:19 / fm"
    "Modified: / 10-10-2006 / 17:50:18 / cg"
!

updateCollateImage
    collateImageLabel
        label:self collateImage;
        redraw.
    collateImageLabel flush

    "Created: / 01-08-2006 / 10:02:12 / fm"
    "Modified: / 10-10-2006 / 17:50:21 / cg"
!

updateInfo
    |printer|

    printer := self selectedPrinter.
    statusLabel label:printer status.
    driverNameLabel label:printer pDriverName.
    locationLabel label:printer location.
    commentLabel label:printer comment.

    "Created: / 01-08-2006 / 15:05:08 / fm"
    "Modified: / 17-08-2011 / 09:39:00 / cg"
!

updateLastUsedPrinterSettings
    self class lastUsedPrinterSettings:self selectedPrinter.

    "Modified: / 10-10-2006 / 17:50:26 / cg"
!

updateModifiedCollate

    self isSelectedPrinterAvailable ifFalse:[^ nil].

    self collateHolder value:self selectedPrinter collate.

    "Created: / 01-08-2006 / 11:50:10 / fm"
    "Modified: / 10-10-2006 / 17:50:28 / cg"
!

updateModifiedNumberOfCopies

    self isSelectedPrinterAvailable ifFalse:[^ nil].

    self numberOfCopiesHolder value:self selectedPrinter copies.

    "Created: / 01-08-2006 / 11:48:26 / fm"
    "Modified: / 10-10-2006 / 17:50:30 / cg"
!

updateModifiedOrientation
    self selectedOrientationHolder value:self orientationSymbol.

    "Created: / 01-08-2006 / 11:46:58 / fm"
    "Modified: / 10-10-2006 / 17:50:32 / cg"
!

updateModifiedPageSize
    |sizeName|

    self isSelectedPrinterAvailable ifFalse:[^ nil].

    sizeName := self selectedPrinter paperSizeName.
    sizeName isNil ifTrue:[
        self addUnknownPaperSize.
        sizeName := self unknownPaperSizeNameDescription
    ] ifFalse:[
        self removeUnknownPaperSize.
    ].
    self selectedPaperSizeHolder value:sizeName.

    "Created: / 01-08-2006 / 11:47:24 / fm"
    "Modified: / 10-10-2006 / 17:50:34 / cg"
!

updateModifiedProperties
    self isSelectedPrinterAvailable ifFalse:[
        ^ self clearProperties
    ].
    self updateModifiedOrientation.
    self updateModifiedPageSize.
    self updateModifiedNumberOfCopies.
    self updateModifiedCollate.
    self updateInfo.

    "Modified: / 01-08-2006 / 15:05:01 / fm"
    "Modified: / 10-10-2006 / 17:50:36 / cg"
!

updateOrientationImage
    orientationImageLabel
        label:self orientationImage;
        redraw.
    orientationImageLabel flush

    "Created: / 28-07-2006 / 14:38:31 / fm"
    "Modified: / 10-10-2006 / 17:50:38 / cg"
!

updatePaperSizeList
    self paperSizeListHolder value:self paperSizeNames

    "Created: / 31-07-2006 / 15:24:20 / fm"
    "Modified: / 31-07-2006 / 16:25:19 / fm"
    "Modified: / 10-10-2006 / 17:50:40 / cg"
!

updatePrintersList
    self printerListHolder value:self printerUserFriendlyNames

    "Created: / 28-07-2006 / 11:56:14 / fm"
    "Modified: / 10-10-2006 / 17:50:42 / cg"
!

updateValueHolders
    self setupActionEnabledHolder value:self setupActionEnabled.
    self okButtonEnabledHolder value:self okButtonEnabled.
    self orientationRadioButtonEnabledHolder value:self orientationRadioButtonEnabled.
    self numberOfCopiesTextEnabledHolder value:self numberOfCopiesTextEnabled.
    self collateActionEnabledHolder value:self collateActionEnabled.
    self paperSizeEnabledHolder value:self paperSizeEnabled

    "Created: / 28-07-2006 / 12:16:07 / fm"
    "Modified: / 01-08-2006 / 09:39:22 / fm"
    "Modified: / 10-10-2006 / 17:50:49 / cg"
! !

!PrintingDialog methodsFor:'update properties'!

updateCollate
    self isSelectedPrinterAvailable ifFalse:[
        ^ nil
    ].
    self selectedPrinter collate:self collateHolder value

    "Created: / 01-08-2006 / 09:55:30 / fm"
    "Modified: / 10-10-2006 / 17:51:01 / cg"
!

updateNumberOfCopies
    self isSelectedPrinterAvailable ifFalse:[
        ^ self
    ].
    self selectedPrinter copies:self numberOfCopiesHolder value

    "Created: / 31-07-2006 / 13:54:16 / fm"
    "Modified: / 10-10-2006 / 17:51:09 / cg"
!

updatePaperSize
    (self isSelectedPrinterAvailable and:[ self isSelectedPaperSize ]) ifFalse:[
        ^ self
    ].
    self selectedPrinter paperSizeName:self selectedPaperSizeHolder value

    "Created: / 31-07-2006 / 16:04:32 / fm"
    "Modified: / 02-08-2006 / 11:43:12 / fm"
    "Modified: / 10-10-2006 / 17:51:11 / cg"
!

updatePrinterOrientation
    |selectedPrinter|

    self isSelectedPrinterAvailable ifFalse:[
        ^ self
    ].
    selectedPrinter := self selectedPrinter.
    self isPortraitSelected ifTrue:[
        selectedPrinter setPortraitOrientation
    ] ifFalse:[
        selectedPrinter setLandscapeOrientation
    ]

    "Created: / 28-07-2006 / 15:47:37 / fm"
    "Modified: / 31-07-2006 / 13:53:32 / fm"
    "Modified: / 10-10-2006 / 17:52:46 / cg"
! !

!PrintingDialog methodsFor:'user actions'!

accept
    answer := self selectedPrinter.
    self updateLastUsedPrinterSettings.
    self close

    "Created: / 31-07-2006 / 13:52:48 / fm"
    "Modified: / 03-08-2006 / 15:31:17 / fm"
    "Modified: / 10-10-2006 / 17:53:13 / cg"
!

collateHolderChanged
    self updateCollate.
    self updateCollateImage.

    "Created: / 01-08-2006 / 09:55:10 / fm"
    "Modified: / 10-10-2006 / 17:53:17 / cg"
!

numberOfCopiesHolderChanged
    self updateNumberOfCopies.
    self updateValueHolders.

    "Created: / 01-08-2006 / 09:37:53 / fm"
    "Modified: / 01-08-2006 / 10:49:39 / fm"
    "Modified: / 10-10-2006 / 17:53:22 / cg"
!

openSetup
    self selectedPrinter isNil ifTrue:[
        ^ self
    ].
    self selectedPrinter openPropertiesDialog ifTrue:[
        self updatePrinterInPrintersSettings.
        self updateModifiedProperties
    ].

    "Created: / 28-07-2006 / 11:38:22 / fm"
    "Modified: / 04-08-2006 / 14:05:49 / fm"
    "Modified: / 10-10-2006 / 17:53:27 / cg"
!

printerSelectionChanged
    self addOrRecoverPrinterSettings.
    self updateModifiedProperties.
    self updateValueHolders.

    "Created: / 28-07-2006 / 11:32:41 / fm"
    "Modified: / 04-08-2006 / 13:55:06 / fm"
    "Modified: / 10-10-2006 / 17:53:30 / cg"
!

selectedOrientationHolderChanged
    self updateOrientationImage.
    self updatePrinterOrientation

    "Created: / 28-07-2006 / 14:19:25 / fm"
    "Modified: / 28-07-2006 / 15:46:15 / fm"
    "Modified: / 10-10-2006 / 17:53:36 / cg"
!

selectedPaperSizeHolderChanged
    self updatePaperSize.
    self removeUnknownPaperSize

    "Created: / 01-08-2006 / 09:27:24 / fm"
    "Modified: / 10-10-2006 / 17:53:38 / cg"
! !

!PrintingDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


PrintingDialog initialize!
