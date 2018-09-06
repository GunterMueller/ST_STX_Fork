"
 COPYRIGHT (c) 2009 by eXept Software AG
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

SimpleDialog subclass:#NewClassWizardDialog
	instanceVariableNames:'compilerProviderBlock createdClass languageHolder indexType
		packageHolder classNameHolder instVarNamesHolder openClassChooser
		superclassNameHolder createRequiredMethodsHolder
		createPrintMethodHolder createAccessorsHolder
		createUpdateMethodHolder createInitializerHolder
		createInitialGUICodeHolder classInstVarNamesHolder
		classVarNamesHolder nameSpaceHolder categoryHolder
		stereotypeHolder isCreatingClassHolder listOfSuperclassesHolder
		canDisableTemplateCreationHolder'
	classVariableNames:'LastLanguage LastSuperclass LastPackage LastNamespace
		LastCategory'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!NewClassWizardDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
        cg (cg@CG-PC)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Tools::NewClassDialog open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for
    ... executable example here ...
                                                                [exEnd]
"
! !

!NewClassWizardDialog class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::NewClassDialog
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#chooseSuperclass
'Open a dialog for superclass selection'

#classInstVariableNames
'Special: instance variables of the CLASS object (separated by blanks)'

#stereotype
'Some often used class creation templates'

#className
'The name of the new class (without namespace prefix)'

#classVariableNames
'Special: class variables (separated by blanks)'

#createAccessors
'Create getters and setters for all instance variables'

#createInitializer
'Create an initial initialize method template'

#createPrintMethod
'Create an initial print method template'

#createRequiredMethods
'Create all methods which have been declared as required by a superclass (subclass responsibility)'

#createUpdateMethod
'Create an initial update method template'

#createInitialGUICode
'Create initial template code (mostly useful for applications)'

#instanceVariableNames
'Instance variables (separated by spaces)'

#namespace
'Optional namespace in which this class is to be created (default: Smalltalk).\Notice: namespaces are used to avoid name conflicts, not for organization\(that is what categries are for)'

#namespaceChooser
'Open a dialog for namespace selection'

#package
'Packages are units for deployment\(separately compiled & deployable libraries and applications).\For class creation, choose the package into which this class should be placed.\For package creation, define the packageID of the new package.\ID must be of the form: "<module>:<path>", for example: "myname:demos/myFirstDemoProgram"'

#project
'Project-ID (aka package) into which this class should be placed'

#category
'Category into which the new class should be organized (in the browser)'

#categoryChooser
'Open a dialog for category selection'

#packageChooser
'Open a dialog for package selection'

#programmingLanguage
'Programming Language to use for code in this class'

#superclass
'Superclass of the new class'

)

    "Modified: / 27-01-2012 / 14:41:44 / cg"
! !

!NewClassWizardDialog class methodsFor:'image specs'!

wizardIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self wizardIcon inspect
     ImageEditor openOnClass:self andSelector:#wizardIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'Tools::NewClassDialog class wizardIcon'
        ifAbsentPut:[
            (Depth8Image new)
                width:80;
                height:80;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_IX@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M8@@@@@@@@@@@@@@@BVU@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@NC^3 @@@@@@@@@@@@@@@IYT% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L/K2 @@@@@@@@@@@@@@%%ITZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@C,;N/^7,?+:N0@;N0@@@@@@@B-T%QT% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@M3(:>_''
9.[&9.[''9>_Z7P@@@@@@@J5BT%Q(2P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C^4=O(9.[&9^W%9.[''4=+Z
9.0@@@@@2DIRZF!!>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CS4>[%9]7\7M7]7];S4=L@@@@@@@CHSIOH
UF!!T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;N_&9]7\7M3[7]7^7]7(7P@@@@@@@@ALT%ITZG2V@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C(9.[]7M/]7]/(;^3]7.#,@@@@@@@@@D1@P%ITZEQR@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N#&9^W\7MO&6._,7-7^:N0@@@@@@@@@YTABT%QT_$H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C,9>#-9-/\3M;Z6=/\7];(@@@@@@@@@@A%PDARUEQ>%$H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@N#&9^#[6=/M4=+[6=7]9>$@@@@@@@@@@FU@PDIRUL"VZIX@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@C,:N[]7M3[6=OL7M3\7];N3>$@@@@@@@@@]4A@PEIT2\"-P%H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N3''9-7\6=/[
6,3]7M3]9-[_@@@@@@@@@@A7PDA@T%JV_*5TI@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4=;%7M3[6=/[4>[\7];''@@@@
@@@@@@@@@G\:PDABT%Q(ZL!!<T @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:MOS4=3\6>_Z6-. S6C&:N$@@@@@@@@@@@@@]3)L
N$ART%QT2N5@+P@@@@@@@@@@@@@@@@@@@@@@@N@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:MOS9]3];^#''6-,#N=;(@@@@@@@@@@@@@@BMN$1%PDIRUF"V;V!!R
@@@@@@@@@@@@@@@@@@@@@@C 50@@@@@@@@@@@@@@@@@@@@@@@@@@@@C(9=;]6=/-;]3[60YN#0@@@@@@@@@@@@@@@H42_C)@PEIR%$NV;RQB@L#H@@@@@@@@
@@@@@@@@@K2<@@@@8N$@@@@@@@@@@@@@@@@@@@@@@N3''9-7[6.[]7]/\GYQM@@@@@@@@@@@@@@@@#SI(N$A@P%JV;^7-$4ARZEI@PFT@@@@@@@@@@@@@-[VH
-]__70@@@@@@@@@@@@@@@@@@@@@@;N_&7M/[6=+[7M6N$T8@@@@@@@@@@@@@@@BMKT!!%PDABT&"/2J?-%"QR_EI@N''0@@@@@@@@@@NF5''[WP5=__@@@@@@@@
@@@@@@@@@@@@@@C,9>[\6=/[6-/\7\IO$P@@@@@@@@@@@@@@@H4-N#(:PDABUIY>%.7HP%I<P$@:$0@@@@@@@@@@1I*]-]CW6N$@@@@@@@@@@@@@@@@@@@@@
@N3&9-3[6=+[7M7^:@ZU+@@@@@@@@@@@@@A%L!! 2RC(:PDAR%*=(;Z=<%%I@PIL@@@@@@@@@@@B^!!I&66ND@@@@@@@@@@@@@@@@@@@@@@@@@;N[T3-/[6-3\
7-;,A$=N@@@@@@@@@@B-C0 WFCI_N#)@PDI<+YZV%%IBPDBS@@@@@@@@@@@@ZE.@ 0@@@@@@@@@@@@@@@@@@@@@@@@@@@@C,9,;J3-+[7M7^:@AOB#2,@@@@
@@@@HQ@OC102L$ :N$AL_IZSZDI@PDA$@@@@@@@@@@@@@M1;RZL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N3&5\+$6=/\7^_(@IPEXW$@@@@@@@@PDA@\HS(:
N$1LYW1<YUI@PDA@PL\@@@@@@@@@@@CH9*0=@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;N[&7]3[7M7^:N0@@GKPO@@@@@@@@A@PDA@PGBD9NS$9N$A@PBQA
P0DL1:,@@@@@@@@@+9[-2F @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C,9>[]7M3]3,;,@@CP5;7V50@@@@@@+S$PDA@PDA@SH"H!!HQTV/]]:%+7H*:0@@@@@
@ERV;^/GZ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N3''9-7]7]7J2 @@/-CW/[65@@@@@@@@@@CH2C4^FSMX 7M>ZV''P5=[P-,"T%@@@@EQ>;^7H7J)>@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N_&7]7]7-W''@@B>-]^54HP@@@@@@@@@@@@@S$5F[(NZ4G6.0;WP-\R,+IRT@@A>%.7-2ES[*YX@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@:N_^7]7^9> @@N*Z-XV2M@@@@@@@@@@@@@A9$XVC!!I&2-[V=:*OE:^7G%IUTUJ>/_"YBP-*O% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@C(9=O^7-;(;@@@@I6D[0(<@@@@@@@@@@@@@G%9%HR@!!I&Y2^6#-[WH+L"QUIZVP$IBP$IP6''*/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N#''7];^9> @
@@@@@K:DAYE(@@@@@@@@@@@@$VJQ%IVH!!JS-1:?-;^7H17-BP$IBP$IBP''OSPP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:N#''7-;'':P@@@@@@@HLY%S9T
@@@@@@@@@@CHX''&Q%J2++N6T1^7-;\#G^4IBP$IBP%J-#*E@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C):N_^9>#,@@@@@@@@@E%&MTK%*G8@@@@@@@@@
XW&Q$YR,2IR,2N7H+J1#N$A@PDA@PDCS\4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N3(9>_'':@@@@@@@@@BJI1D^I^7-;YY(P4IBP6 ?XW!!9^YSG%IFT
+IRT%D,:PDA@PDA@N-I@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N''(9>_(@@@@@@@@@D\''A#0T;^7-;^7H+:>V%%HNM&E9%J2,^YFT$YFTPC)@PDA@
PC(:4#)_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;N#(:N @@@@@@@@@I2\B$QG-7Y[H%%QBP$IBT"D[A0NQ%IQ9XWQ!!$Y@:N#(:N#(:N(&4N*4@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:N#(:P@@@@@@@@@*J@6TON#ST%I@PDA@PDA@PD@ C!!*Q$YE!!S''&Q^#(:N#)%N#*L5U:S@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@C):N#)@@@@@@@@+B(*J#6T7K%@PDA@PDA@PC(:PDA@BW&Q$YE9$YA@N#(:N#)L#[?UL @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@N''(:N0@@@@@@@BKJ"(*B9KS(C(:SC(:N#(:N#(:PD@RG9BP$IBP$C(:N#(:RH6''1*YL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;N'');@@@
@@@@@HEEQTT/N-JHN$1<N#(:N#(:N#(:PC$NAIFP$IA#N#)_@@@@+]Y0N @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:^$@@@@@@@C*[UUUQS@:
4%0:N$!!HSE=7NSD:N''0:PBDOA9BP]S(:S@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;@@@@@@@@LU+UUUUL%3NW'']_$0@@@@A%
LS(2N#(:N#([F6L:L''O\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C,@@@@@@@@/6-+Z6(:"+6MW< @@@@@@J42N#(:N#(:N#$[
NC)56-L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B%_61+Z4">#G\@@@@@@@@@7=>B!!GA\WGFI)N3+9.W@+P@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@I=?_7=-!!-H@@@@@@@@@@@CG09"3.K''Z6-/&1:1SP$MT@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-7=?_3G^@@@@@@@@@@@@+TBVPDA@PDIBUEQBP$JV+2Z-@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B7_7=?L @@@@@@@@@@@@A%SG1@PDA@%,#H+4IBP&#HI)X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@K>W%9\@@@@@@@@@@@@@@DA<PDA@PDJV2L"-P$H&P*=B_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@:+F0) @@@@@@@@@@@@BVYW1@PDA@P)[H2IYBP&"/%$I(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8^(@@@@@
@@@@@@@@2DA<YYY@PDIB%*>/UC=BUF!!>P%P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BSPFUR
%$A@P$JV+Z=TO$IBP''9BT @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C)%PDA@PDABP)ZV%$H.
O4IBZDIB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B-SFU@PDA@PDIB+YZVP",?P$IRP$H@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G]%T$A@PDA@%*7H%)YBJ#=BP%IBP@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N$1@PDA@PDAR+Z6V_DH''O4A@P$A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E=LN$A@PDA@P%I<_''9TP"\8PDA@PD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:N$A@PDA@PDA@ZG1<ZDH>JR9@PDA@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@C)LN$A@PDA@PDI(ZF!!TP#\)K$A@PDA@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@:N#(:PDA@PIY@P&!!(ZDIBU4T*PD@:N#*S@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B-N#(:N#)@PDA@
PDIRUEQTP"Y,UTQ@N#(:N#*V@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#(:N#(:N$A@PDA@P$IRUDIBPW=V
UU(:N$1@N#(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@IL:N#(:N#(:PDA@PDABP$IBP"YJ_61U LD9N#(2L,P@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AHN#(:N#(:N$ABPDA@P$IBP$H&(''=?[F1EKH#Z6]KR3U:S2@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BI3[-0NSH:N#(:PDA@PDA@P$IBY.I?_8FJ"9FQ]#H2N#H:%, @@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CHW3(:$-OL3Y-]N#(:PDA@PEB(7NKATYJR$)JU%YVV+Z6-+Z7H2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@N#)_"97L4]J[!!8%3"X:!!6.K#^TJR$)JR%YVU%YZ-+Z6-+\ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@IL:N#(:WX"\.[&:#(=PI"Y''^9JR$)JU%YVV+Z6-+Z6-@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
+YMLN#)@PDA@P%I;$)JR$)JR%YVU%*6-+Z6-1 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@N+H2J6-
+Z6-+Z6-+Z6-+Z7F2L#H2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C*2L#H2L#*
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 0 90 210 36 30 50 36 30 130 36 30 140 36 60 80 36 60 100 60 30 140 60 30 180 60 60 180 60 90 100 60 90 130 60 150 220 84 30 80 84 60 180 84 60 210 84 60 220 84 90 130 84 90 210 84 90 220 84 120 210 84 120 220 84 150 220 96 30 220 96 30 255 96 60 50 96 60 140 96 60 210 96 60 220 96 90 100 96 90 130 96 90 140 96 90 210 96 90 220 96 90 255 96 120 140 96 120 255 96 150 220 96 150 255 120 0 80 120 0 100 120 30 80 120 30 100 120 30 130 120 30 140 120 30 255 120 60 140 120 60 180 120 60 210 120 60 220 120 60 255 120 90 50 120 90 80 120 90 100 120 90 140 120 90 180 120 90 210 120 90 220 120 90 255 120 120 100 120 120 130 120 120 140 120 120 210 120 120 220 120 120 255 120 150 220 120 150 255 120 180 255 144 30 80 144 30 100 144 60 50 144 90 130 144 90 255 144 120 140 144 120 180 144 120 220 144 120 255 144 150 130 144 150 140 144 150 180 144 150 210 144 150 220 144 150 255 144 180 220 144 180 255 156 30 100 156 60 100 156 60 130 156 90 50 156 90 130 156 90 180 156 120 140 156 120 180 156 120 210 156 120 220 156 120 255 156 150 100 156 150 140 156 150 180 156 150 210 156 150 220 156 150 255 156 180 210 156 180 220 156 180 255 156 210 255 180 30 80 180 30 100 180 60 100 180 60 130 180 90 50 180 120 100 180 120 140 180 120 180 180 150 130 180 150 140 180 150 180 180 150 210 180 150 220 180 150 255 180 180 140 180 180 180 180 180 210 180 180 220 180 180 255 180 210 220 180 210 255 204 60 100 204 90 50 204 90 140 204 120 50 204 120 80 204 120 100 204 120 130 204 120 140 204 150 100 204 150 130 204 150 140 204 150 180 204 150 210 204 150 220 204 150 255 204 180 130 204 180 140 204 180 180 204 180 210 204 180 220 204 180 255 204 210 210 204 210 220 204 210 255 216 60 100 216 120 0 216 120 100 216 120 130 216 150 50 216 150 100 216 150 130 216 150 140 216 150 180 216 180 50 216 180 100 216 180 130 216 180 140 216 180 180 216 180 210 216 180 220 216 180 255 216 210 130 216 210 140 216 210 180 216 210 210 216 210 220 216 210 255 216 240 220 216 240 255 240 60 100 240 90 130 240 120 130 240 150 0 240 150 80 240 150 130 240 150 140 240 150 180 240 180 30 240 180 50 240 180 80 240 180 100 240 180 130 240 180 140 240 180 180 240 180 210 240 210 80 240 210 100 240 210 140 240 210 180 240 210 210 240 210 220 240 210 255 240 240 220 240 240 255 240 255 255 252 90 30 252 120 30 252 150 0 252 150 30 252 150 50 252 150 80 252 150 130 252 180 0 252 180 30 252 180 50 252 180 80 252 180 100 252 180 130 252 180 140 252 180 180 252 210 30 252 210 50 252 210 80 252 210 100 252 210 130 252 210 140 252 210 180 252 210 210 252 210 220 252 240 50 252 240 80 252 240 100 252 240 130 252 240 140 252 240 180 252 240 210 252 240 220 252 240 255 252 255 210 252 255 220 252 255 255 ];
                mask:((ImageMask new)
                            width:80;
                            height:80;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@@@@@@@@P@L@@@@@@@@@@\@C @@@@@@
@@@C @<@@@@@@@@@O>0O @@@@@@@@_?<C<@@@@@@@@O??0?@@@@@@@@A??0O8@@@@@@@@??<A?@@@@@@@@O??@_8@@@@@@@C??0G>@@@@@@@A??8A?0@@@@@
@@_?>@_>@@@@@@@O??0G?0@@@@@@C??8A?<@@@@@@@??8@_? @@@@@@??>@G?<@@B@@@G??@A??@@A @@A?? @_?;@@X0@@_?8@G??>@G<@@G?>@A???0C?@
@A?? @_??<@?0@@_?<@O??>@O0@@G??@O???@G @@A?=8G???@C0@@@_?^A???0A8@@@G?3 _??>@>@@@A?9<G???0_ @@@_<?@O??<_8@@@C?O0@???O>@@
@@?3<@O???? @@@O<_@C????8@@@C>C8@????<@@@@? _@O????@@@@O8C>@????0@@@C<A??????<@@@@_@_??????@@@@G0G??????0@@@@<A??????8@@
@@O@??????<@@@@C0O??????@@@@@<C?????G @@@@FA????? @@@@@@ _?!!??8@@@@@@HG?0_?>@@@@@@@A?0G?? @@@@@@@_0A??8@@@@@@@G8@???@@@@
@@@A<@O??0@@@@@@@^@C??<@@@@@@@G A???@@@@@@@@0@???0@@@@@@@@@O??<@@@@@@@@@C???@@@@@@@@@A???0@@@@@@@@@_??<@@@@@@@@@G???@@@@
@@@@@C???0@@@@@@@@A???<@@@@@@@@@_??? @@@@@@@@O???8@@@@@@@@O????@@@@@@@@G????0@@@@@@@C????>@@@@@@@A?????<@@@@@@A?????>@@@
@@@A?????? @@@@@@G?????0@@@@@@@_????8@@@@@@@@????<@@@@@@@@@_??<@@@@@@@@@@A?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
! !

!NewClassWizardDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NewClassWizardDialog andSelector:#windowSpec
     Tools::NewClassWizardDialog new openInterface:#windowSpec
     Tools::NewClassWizardDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Class Creation Wizard'
         name: 'Class Creation Wizard'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 592 639)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'wizardIcon'
             name: 'Label10'
             layout: (LayoutFrame 0 0 0 0 100 0 90 0)
             hasCharacterOrientedLabel: false
             translateLabel: true
           )
          (LabelSpec
             label: 'Class/Package Creation Wizard'
             name: 'Label11'
             layout: (LayoutFrame 100 0 10 0 390 0 50 0)
             translateLabel: true
           )
          (LabelSpec
             label: 'Stereotype:'
             name: 'Label13'
             layout: (LayoutFrame 10 0 91 0 180 0 113 0)
             activeHelpKey: stereotype
             translateLabel: true
             adjust: right
           )
          (ComboListSpec
             name: 'ComboList3'
             layout: (LayoutFrame 190 0 91 0 -32 1 113 0)
             activeHelpKey: stereotype
             model: stereotypeHolder
             comboList: listOfStereotypes
             useIndex: true
           )
          (LabelSpec
             label: 'Programming Language:'
             name: 'Label9'
             layout: (LayoutFrame 7 0 126 0 301 0 148 0)
             activeHelpKey: programmingLanguage
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (ComboListSpec
             name: 'ComboList1'
             layout: (LayoutFrame 308 0 126 0 -32 1 148 0)
             activeHelpKey: programmingLanguage
             visibilityChannel: isCreatingClassHolder
             model: languageHolder
             comboList: listOfLanguages
             useIndex: true
           )
          (LabelSpec
             label: 'Class Name:'
             name: 'Label1'
             layout: (LayoutFrame 10 0 172 0 180 0 194 0)
             activeHelpKey: className
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (LabelSpec
             label: '*'
             name: 'Label14'
             layout: (LayoutFrame 180 0 173 0 190 0 195 0)
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
           )
          (InputFieldSpec
             name: 'EntryField1'
             layout: (LayoutFrame 190 0 172 0 -32 1 194 0)
             activeHelpKey: className
             visibilityChannel: isCreatingClassHolder
             model: classNameHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'Superclass:'
             name: 'Label2'
             layout: (LayoutFrame 10 0 202 0 180 0 224 0)
             activeHelpKey: superclass
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (ComboBoxSpec
             name: 'ComboBox1'
             layout: (LayoutFrame 190 0 202 0 -32 1 224 0)
             activeHelpKey: superclass
             visibilityChannel: isCreatingClassHolder
             model: superclassNameHolder
             acceptOnLostFocus: true
             comboList: listOfSuperclassesHolder
             useIndex: false
           )
          (LabelSpec
             label: '*'
             name: 'Label15'
             layout: (LayoutFrame 180 0 202 0 190 0 224 0)
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
           )
          (ActionButtonSpec
             label: '...'
             name: 'Button1'
             layout: (LayoutFrame -22 1 202 0 -2 1 224 0)
             activeHelpKey: chooseSuperclass
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             model: openSuperClassChooser
           )
          (LabelSpec
             label: 'Package ID:'
             name: 'Label3'
             layout: (LayoutFrame 10 0 243 0 180 0 265 0)
             activeHelpKey: package
             translateLabel: true
             adjust: right
           )
          (LabelSpec
             label: '*'
             name: 'Label16'
             layout: (LayoutFrame 180 0 245 0 190 0 267 0)
             visibilityChannel: isCreatingPackageHolder
             translateLabel: true
           )
          (ComboBoxSpec
             name: 'ComboBox2'
             layout: (LayoutFrame 190 0 242 0 -32 1 264 0)
             activeHelpKey: package
             model: packageHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
             comboList: listOfPackages
           )
          (ActionButtonSpec
             label: '...'
             name: 'Button4'
             layout: (LayoutFrame -22 1 242 0 -2 1 264 0)
             activeHelpKey: packageChooser
             translateLabel: true
             model: openPackageChooser
           )
          (LabelSpec
             label: 'Namespace:'
             name: 'Label4'
             layout: (LayoutFrame 10 0 272 0 180 0 294 0)
             activeHelpKey: namespace
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (ComboListSpec
             name: 'ComboList2'
             layout: (LayoutFrame 190 0 272 0 -32 1 294 0)
             activeHelpKey: namespace
             visibilityChannel: isCreatingClassHolder
             model: nameSpaceHolder
             comboList: listOfNamespaces
           )
          (ActionButtonSpec
             label: '...'
             name: 'Button5'
             layout: (LayoutFrame -22 1 272 0 -2 1 294 0)
             activeHelpKey: namespaceChooser
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             model: openNamespaceChooser
           )
          (LabelSpec
             label: 'Category:'
             name: 'Label12'
             layout: (LayoutFrame 10 0 302 0 180 0 324 0)
             activeHelpKey: category
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (ComboBoxSpec
             name: 'ComboBox3'
             layout: (LayoutFrame 190 0 302 0 -32 1 324 0)
             activeHelpKey: category
             visibilityChannel: isCreatingClassHolder
             model: categoryHolder
             acceptOnLostFocus: true
             comboList: listOfCategories
           )
          (ActionButtonSpec
             label: '...'
             name: 'Button6'
             layout: (LayoutFrame -22 1 302 0 -2 1 324 0)
             activeHelpKey: categoryChooser
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             model: openCategoryChooser
           )
          (LabelSpec
             label: 'Instance Variables:'
             name: 'Label5'
             layout: (LayoutFrame 10 0 342 0 180 0 364 0)
             activeHelpKey: instanceVariableNames
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'EntryField4'
             layout: (LayoutFrame 190 0 342 0 -32 1 364 0)
             activeHelpKey: instanceVariableNames
             visibilityChannel: isCreatingClassHolder
             model: instVarNamesHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'Class Variables:'
             name: 'Label6'
             layout: (LayoutFrame 10 0 372 0 180 0 394 0)
             activeHelpKey: classVariableNames
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'EntryField5'
             layout: (LayoutFrame 190 0 372 0 -32 1 394 0)
             activeHelpKey: classVariableNames
             visibilityChannel: isCreatingClassHolder
             model: classVarNamesHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'Class InstVars:'
             name: 'Label7'
             layout: (LayoutFrame 10 0 402 0 180 0 424 0)
             activeHelpKey: classInstVariableNames
             visibilityChannel: isCreatingClassHolder
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'EntryField6'
             layout: (LayoutFrame 190 0 402 0 -32 1 424 0)
             activeHelpKey: classInstVariableNames
             visibilityChannel: isCreatingClassHolder
             model: classInstVarNamesHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'Create:'
             name: 'Label8'
             layout: (LayoutFrame 10 0 442 0 110 0 464 0)
             translateLabel: true
             adjust: right
           )
          (CheckBoxSpec
             label: 'Accessors'
             name: 'CheckBox1'
             layout: (LayoutFrame 120 0 442 0 280 0 464 0)
             activeHelpKey: createAccessors
             visibilityChannel: isCreatingClassHolder
             model: createAccessorsHolder
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Initial Template Code'
             name: 'CheckBox6'
             layout: (LayoutFrame 310 0 442 0 -36 1 464 0)
             activeHelpKey: createInitialGUICode
             enableChannel: canDisableTemplateCreationHolder
             model: createInitialGUICodeHolder
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Initializer'
             name: 'CheckBox2'
             layout: (LayoutFrame 120 0 472 0 0 1 494 0)
             activeHelpKey: createInitializer
             visibilityChannel: isCreatingClassHolder
             model: createInitializerHolder
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Update Method'
             name: 'CheckBox5'
             layout: (LayoutFrame 120 0 502 0 0 1 524 0)
             activeHelpKey: createUpdateMethod
             visibilityChannel: isCreatingClassHolder
             model: createUpdateMethodHolder
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Required Methods (Subclass responsibilities)'
             name: 'CheckBox3'
             layout: (LayoutFrame 120 0 532 0 0 1 554 0)
             activeHelpKey: createRequiredMethods
             visibilityChannel: isCreatingClassHolder
             model: createRequiredMethodsHolder
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Print Method'
             name: 'CheckBox4'
             layout: (LayoutFrame 120 0 562 0 0 1 584 0)
             activeHelpKey: createPrintMethod
             visibilityChannel: false
             model: createPrintMethodHolder
             translateLabel: true
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'Button3'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 125 22)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'Button2'
                   translateLabel: true
                   model: doAccept
                   extent: (Point 125 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!NewClassWizardDialog class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated by the CodeGeneratorTool."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewClassDialog andSelector:#mainMenu
    "

    <resource: #menu>

    ^ #(#Menu
           #(
             #(#MenuItem
                #label: 'File'
                #translateLabel: true
                #submenu:
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'New'
                          #translateLabel: true
                          #value: #menuNew
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Open...'
                          #translateLabel: true
                          #value: #menuOpen
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Save'
                          #translateLabel: true
                          #value: #menuSave
                      )
                       #(#MenuItem
                          #label: 'Save As...'
                          #translateLabel: true
                          #value: #menuSaveAs
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Exit'
                          #translateLabel: true
                          #value: #closeRequest
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
                #translateLabel: true
                #submenu:
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'Documentation'
                          #translateLabel: true
                          #value: #openDocumentation
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'About this Application...'
                          #translateLabel: true
                          #value: #openAboutThisApplication
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )
!

toolbarMenu
    "This resource specification was automatically generated by the CodeGeneratorTool."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewClassDialog andSelector:#toolbarMenu
    "

    <resource: #menu>

    ^ #(Menu ((MenuItem label: 'Reload' itemValue: menuReload translateLabel: true labelImage: (ResourceRetriever ToolbarIconLibrary reload24x24Icon))) nil nil)
! !

!NewClassWizardDialog methodsFor:'accessing'!

compilerProviderBlock:aBlock
    "/ see NewSystemBrowser on how to use this
    compilerProviderBlock := aBlock.
!

createdClass
    ^ createdClass
!

language                      
    |languageName languageClass|

    languageName := self listOfLanguages at:(languageHolder value).
    languageClass := ProgrammingLanguage allSubclasses 
        detect:[:l | l instance name = languageName]
        ifNone:[ SmalltalkLanguage].
    ^ languageClass instance

    "Created: / 30-01-2011 / 09:35:19 / cg"
    "Modified: / 30-01-2011 / 10:40:35 / cg"
! !

!NewClassWizardDialog methodsFor:'actions'!

doAccept
    self isCreatingPackageHolder value ifFalse:[
        self doAcceptForNewClass ifFalse:[^ self].
    ] ifTrue:[
        self doAcceptForNewPackage ifFalse:[^ self].
    ].    
    super doAccept.
!

doAcceptForNewClass
    |newClassName superclassName superclass package answer|

    newClassName := self classNameHolder value.
    newClassName isEmptyOrNil ifTrue:[
        self warn:('No Classname entered').
        ^ false.
    ].
    newClassName isValidSmalltalkIdentifier ifFalse:[
        self warn:'No valid Classname entered (must be alphaNumeric)'.
        ^ false.
    ].
    newClassName first isUppercase ifFalse:[
        self warn:'No valid Classname entered (first Character must be uppercase)'.
        ^ false.
    ].

    superclassName := self superclassNameHolder value.
    superclass := Smalltalk classNamed:superclassName.
    superclass isNil ifTrue:[
        (superclassName knownAsSymbol and:[Smalltalk includesKey:superclassName asSymbol]) ifFalse:[
            self warn:'No such Superclass'.
            ^ false.
        ].
        (Smalltalk at:superclassName asSymbol) isBehavior ifFalse:[
            self warn:'"%1" refers to a global which is not a class (%2)'
                        with:superclassName
                        with:superclass className.
            ^ false.
        ].
    ].

    package := self packageHolder value.
    package notEmptyOrNil ifTrue:[
        (package asPackageId module isEmptyOrNil
        or:[ package asPackageId directory isEmptyOrNil ]) ifTrue:[
            self warn:'The packageID "%1" must be of the form "module:directory" (for the source repository management)'
                        with:package.
            ^ false.
        ].

        (ProjectDefinition definitionClassForPackage:package) isNil ifTrue:[
            answer := Dialog
                        choose:('Create a new ProjectDefinition for "%1" ?

This can also be done later.
Create the definition as:
' bindWith:package)
                        fromList:nil values:nil
                        buttons:#('GUI Application' 'non-GUI Application' 'Library')
                        values:#(guiApplicationType #nonGuiApplicationType #libraryType)
                        lines:nil cancel:false.

            answer == false ifTrue:[^ false].

            ProjectDefinition
                definitionClassForPackage:package
                projectType: (ProjectDefinition perform:answer)
                createIfAbsent:true.
        ].
    ].

"/ done in caller (for undo handling...)
"/    createdClass :=
"/            superclass
"/                subclass: newClassName asSymbol
"/                instanceVariableNames: instVarNamesHolder value
"/                classVariableNames: classVarNamesHolder value
"/                poolDictionaries: ' '
"/                category: '* as yet uncategorized *'.
"/
"/    classInstVarNamesHolder value notEmptyOrNil ifTrue:[
"/        createdClass class instanceVariableNames: classInstVarNamesHolder value
"/    ].

    LastCategory := categoryHolder value.
    LastPackage := packageHolder value.
    LastLanguage := self listOfLanguages at:(languageHolder value).

    ^ true

    "Modified: / 30-01-2011 / 09:33:28 / cg"
    "Modified (comment): / 27-01-2012 / 14:53:02 / cg"
!

doAcceptForNewPackage
    |package projectType|

    package := self packageHolder value.
    package isEmptyOrNil ifTrue:[
        self warn:'Missing packageID'.
        ^ false.
    ].
    
    (package asPackageId module isEmptyOrNil
    or:[ package asPackageId directory isEmptyOrNil ]) ifTrue:[
        self warn:'The packageID "%1" must be of the form "module:directory" (for the source repository management)'
                    with:package.
        ^ false.
    ].

    (ProjectDefinition definitionClassForPackage:package) notNil ifTrue:[
        self warn:'Package already exists'.
        ^ false.
    ].    
    self stereotypeSymbol == #GUIProject ifTrue:[
        projectType := ProjectDefinition guiApplicationType
    ] ifFalse:[    
        self stereotypeSymbol == #NonGUIProject ifTrue:[
            projectType := ProjectDefinition nonGuiApplicationType
        ] ifFalse:[    
            self stereotypeSymbol == #LibraryProject ifTrue:[
                projectType := ProjectDefinition libraryType
            ] ifFalse:[
                self warn:'oops - what kind of package is this'.
                ^ false.
            ]
        ].    
    ].
    ProjectDefinition
        definitionClassForPackage:package
        projectType:projectType
        createIfAbsent:true.
            
    self doCancel. "/ hack - for now.
    ^ false.
!

doCancel
    self closeRequest.
!

openCategoryChooser
    |category|

    category := Dialog 
                    choose:(resources string:'Select a Category')
                    fromList:(Smalltalk allClassCategories asSortedCollection)
                    lines:15.
    category isNil ifTrue:[^ self].

    self categoryHolder value:category.
!

openNamespaceChooser
    "(mis)use the browser's namespace dialog"

    |browser namespaceString existing|

    (browser := masterApplication) isNil ifTrue:[
        browser := Tools::NewSystemBrowser basicNew
    ].

    namespaceString := browser 
                        askForNameSpace:(resources string:'Select or Enter a Namespace') 
                        title:(resources string:'Namespace selection') 
                        initialText:'Smalltalk'.
    namespaceString isNil ifTrue:[^ self].

    existing := Smalltalk classNamed:namespaceString.
    (existing notNil and:[existing isNameSpace]) ifTrue:[
        "/ exists
    ] ifFalse:[
        (existing notNil) ifTrue:[
            Dialog warn:('"%1" is already defined, but not a namespace' bindWith:namespaceString).
            ^ self
        ].
    ].
    Class withoutUpdatingChangesDo:[
        NameSpace name:namespaceString.
    ].
    self nameSpaceHolder value:namespaceString.

    "Modified: / 19-08-2011 / 01:00:52 / cg"
!

openPackageChooser
    "(mis)use the browser's package dialog"

    |browser package|

    (browser := masterApplication) isNil ifTrue:[
        browser := Tools::NewSystemBrowser basicNew
    ].

    package := browser askForProject:(resources string:'Select or Enter a Package-ID').
    package isNil ifTrue:[^ self].

    self packageHolder value:package.
!

openSuperClassChooser
    "(mis)use the browser's class dialog"

    |browser class classValid classNameOrNil|

    (browser := masterApplication) isNil ifTrue:[
        browser := Tools::NewSystemBrowser basicNew
    ].

    classValid := false.
    [ classValid ] whileFalse:[
        classNameOrNil := browser
            askForClassToSearch:nil
            single:true 
            msgTail:(resources string:'Select a Class') 
            resources:nil
            thenDo:nil.

        classNameOrNil isNil ifTrue:[^ self].
        class := Smalltalk classNamed:classNameOrNil.
        classValid := class notNil
    ].
    self superclassNameHolder value:class name.
!

stereotypeChanged
    |stereoTypeSymbol|

    self listOfSuperclassesHolder value:self listOfSuperclasses.
    
    stereoTypeSymbol := self stereotypeSymbol.
    
    (stereoTypeSymbol = #'GUIProject'
    or:[ stereoTypeSymbol = #'NonGUIProject'
    or:[ stereoTypeSymbol = #'LibraryProject' ]]) ifTrue:[
        self isCreatingClassHolder value:false. 
        self canDisableTemplateCreationHolder value:false.
        self createInitialGUICodeHolder value:true.
    ] ifFalse:[
        self isCreatingClassHolder value:true.    
        self canDisableTemplateCreationHolder value:true.
    ].    
    
    stereoTypeSymbol isNil ifTrue:[
        self createInitializerHolder value:true.
        self createPrintMethodHolder value:false.
        self createAccessorsHolder value:true.
        self createInitialGUICodeHolder value:false.
        self createUpdateMethodHolder value:false.
    ].

    stereoTypeSymbol = #'DataObject' ifTrue:[
        self superclassNameHolder value:'Model'.
        self createAccessorsHolder value:true.
        self createInitialGUICodeHolder value:false.
        self createUpdateMethodHolder value:false.
    ].
"/    stereoTypeSymbol = #'Enumeration' ifTrue:[
"/        self superclassNameHolder value:'Enumeration'.
"/        self createInitializerHolder value:true.
"/        self createAccessorsHolder value:false.
"/        self createInitialGUICodeHolder value:false.
"/    ].
    stereoTypeSymbol = #'GUIApplication' ifTrue:[
        self superclassNameHolder value:'ApplicationModel'.
        self createInitializerHolder value:false.
        self createPrintMethodHolder value:false.
        self createInitialGUICodeHolder value:true.
        self createUpdateMethodHolder value:true.
    ].
    stereoTypeSymbol = #'SharedPool' ifTrue:[
        self superclassNameHolder value:'SharedPool'.
        self createAccessorsHolder value:false.
        self createInitializerHolder value:true.
        self createPrintMethodHolder value:false.
        self createInitialGUICodeHolder value:false.
        self createUpdateMethodHolder value:false.
    ].
    (stereoTypeSymbol = #'StartupClass') ifTrue:[
        self superclassNameHolder value:'StandaloneStartup'.
        self createAccessorsHolder value:false.
        self createInitializerHolder value:true.
        self createPrintMethodHolder value:false.
        self createInitialGUICodeHolder value:true.
        self createUpdateMethodHolder value:false.
    ].
    stereoTypeSymbol = #'TestCase' ifTrue:[
        self superclassNameHolder value:'TestCase'.
        self createAccessorsHolder value:false.
        self createInitializerHolder value:false.
        self createPrintMethodHolder value:false.
        self createInitialGUICodeHolder value:true.
        self createUpdateMethodHolder value:false.
    ].
    stereoTypeSymbol = #'WebService' ifTrue:[
        self superclassNameHolder value:'HTTPService'.
        self createAccessorsHolder value:false.
        self createInitializerHolder value:false.
        self createPrintMethodHolder value:false.
        self createInitialGUICodeHolder value:true.
        self createUpdateMethodHolder value:false.
    ].
    stereoTypeSymbol = #'Widget' ifTrue:[
        self superclassNameHolder value:'View'.
        self createInitializerHolder value:false.
        self createPrintMethodHolder value:false.
        self createInitialGUICodeHolder value:false.
        self createUpdateMethodHolder value:true.
    ].

    "Modified: / 27-01-2012 / 14:47:20 / cg"
!

stereotypeSymbol
    |stereoTypeIndex stereoTypeSpec stereoTypeSymbol|

    stereoTypeIndex := self stereotypeHolder value.
    stereoTypeIndex isNil ifTrue:[^ nil].
    
    stereoTypeSpec := self stereotypeSpec at:stereoTypeIndex.
    stereoTypeSymbol := stereoTypeSpec first.
    ^ stereoTypeSymbol
! !

!NewClassWizardDialog methodsFor:'aspects'!

canDisableTemplateCreationHolder
    <resource: #uiAspect>

    canDisableTemplateCreationHolder isNil ifTrue:[
        canDisableTemplateCreationHolder := true asValue.
    ].
    ^ canDisableTemplateCreationHolder.
!

categoryHolder
    <resource: #uiAspect>

    categoryHolder isNil ifTrue:[
        categoryHolder := LastCategory asValue.
    ].
    ^ categoryHolder.
!

classInstVarNamesHolder
    <resource: #uiAspect>

    classInstVarNamesHolder isNil ifTrue:[
        classInstVarNamesHolder := ValueHolder new.
    ].
    ^ classInstVarNamesHolder.
!

classNameHolder
    <resource: #uiAspect>

    classNameHolder isNil ifTrue:[
        classNameHolder := ValueHolder new.
    ].
    ^ classNameHolder.
!

classNameVisibleHolder
    <resource: #uiAspect>

    ^ self isCreatingClassHolder
!

classVarNamesHolder
    <resource: #uiAspect>

    classVarNamesHolder isNil ifTrue:[
        classVarNamesHolder := ValueHolder new.
    ].
    ^ classVarNamesHolder.
!

createAccessors
    ^ self createAccessorsHolder value
!

createAccessorsHolder
    <resource: #uiAspect>

    createAccessorsHolder isNil ifTrue:[
        createAccessorsHolder := true asValue.
    ].
    ^ createAccessorsHolder.
!

createInitialGUICode
    ^ self createInitialGUICodeHolder value
!

createInitialGUICodeHolder
    <resource: #uiAspect>

    createInitialGUICodeHolder isNil ifTrue:[
        createInitialGUICodeHolder := true asValue.
    ].
    ^ createInitialGUICodeHolder.
!

createInitializer
    ^ self createInitializerHolder value
!

createInitializerHolder
    <resource: #uiAspect>

    createInitializerHolder isNil ifTrue:[
        createInitializerHolder := true asValue.
    ].
    ^ createInitializerHolder.
!

createPrintMethod
    ^ self createPrintMethodHolder value
!

createPrintMethodHolder
    <resource: #uiAspect>

    createPrintMethodHolder isNil ifTrue:[
        createPrintMethodHolder := true asValue.
    ].
    ^ createPrintMethodHolder.
!

createRequiredMethods
    ^ self createRequiredMethodsHolder value
!

createRequiredMethodsHolder
    <resource: #uiAspect>

    createRequiredMethodsHolder isNil ifTrue:[
        createRequiredMethodsHolder := true asValue.
    ].
    ^ createRequiredMethodsHolder.
!

createUpdateMethod
    ^ self createUpdateMethodHolder value
!

createUpdateMethodHolder
    <resource: #uiAspect>

    createUpdateMethodHolder isNil ifTrue:[
        createUpdateMethodHolder := true asValue.
    ].
    ^ createUpdateMethodHolder.
!

instVarNamesHolder
    <resource: #uiAspect>

    instVarNamesHolder isNil ifTrue:[
        instVarNamesHolder := ValueHolder new.
    ].
    ^ instVarNamesHolder.
!

isCreatingClassHolder
    <resource: #uiAspect>

    isCreatingClassHolder isNil ifTrue:[
        isCreatingClassHolder := true asValue
    ].
    ^ isCreatingClassHolder.
!

isCreatingPackageHolder
    ^ BlockValue forLogicalNot:self isCreatingClassHolder.
!

languageHolder
    <resource: #uiAspect>

    |idx|

    languageHolder isNil ifTrue:[
        (self listOfLanguages size == 1) ifTrue:[
            idx := 1.
        ] ifFalse:[
            idx := self listOfLanguages indexOf:(LastLanguage ? 'Smalltalk').
        ].
        languageHolder := idx asValue.

    ].
    ^ languageHolder.
!

listOfCategories
    ^ Smalltalk allClassCategories asNewOrderedCollection sort
!

listOfLanguages
    ^ ProgrammingLanguage allSubclasses collect:[:l | l instance name].
!

listOfNamespaces
    ^ ((NameSpace allNameSpacesIn:Smalltalk)
        asOrderedCollection
            collect:[:ns | ns name])
                sort
!

listOfPackages
    ^ Smalltalk allPackageIDs copy sort
!

listOfStereotypeSymbols
    "program readable list"
    ^ self stereotypeSpec collect:[:each | each isNil ifTrue:[nil] ifFalse:[each first]].
!

listOfStereotypes
    "human readable list"
    ^ self stereotypeSpec collect:[:each | each isNil ifTrue:[nil] ifFalse:[each second]].
!

listOfSuperclasses
    <resource: #uiAspect>

    |l superClassName
     stereoTypeSymbol more
     includeObject includeModel includeApplicationModel includeView
     includeStandaloneStartup|

    stereoTypeSymbol := self stereotypeSymbol.
    
    includeObject := includeModel := includeApplicationModel := includeView := true.
    includeStandaloneStartup := false.
    
    stereoTypeSymbol = #'DataObject' ifTrue:[
        includeApplicationModel := includeView := false.
    ].
    stereoTypeSymbol = #'Enumeration' ifTrue:[
        includeModel := includeApplicationModel := includeView := false.
    ].
    stereoTypeSymbol = #'GUIApplication' ifTrue:[
        includeModel := includeView := includeObject := false.
    ].
    stereoTypeSymbol = #'ConsoleProgram' ifTrue:[
        includeModel := includeApplicationModel := includeView := includeObject := false.
        includeStandaloneStartup := true.
    ].
    stereoTypeSymbol = #'SharedPool' ifTrue:[
        includeModel := includeApplicationModel := includeView := includeObject := false.
    ].
    (stereoTypeSymbol = #'StartupClass') ifTrue:[
        includeModel := includeApplicationModel := includeView := includeObject := false.
        includeStandaloneStartup := true.
    ].
    stereoTypeSymbol = #'TestCase' ifTrue:[
        includeModel := includeApplicationModel := includeView := includeObject := false.
    ].
    stereoTypeSymbol = #'WebService' ifTrue:[
        includeModel := includeApplicationModel := includeView := includeObject := false.
    ].
    stereoTypeSymbol = #'Widget' ifTrue:[
        includeModel := includeApplicationModel := includeObject := false.
    ].
    
    l := OrderedCollection new.
    (includeObject and:[superClassName ~= 'Object']) ifTrue:[
        l add:'Object'
    ].
    (includeModel and:[superClassName ~= 'Model']) ifTrue:[
        l add:'Model'
    ].
    (includeView and:[superClassName ~= 'View']) ifTrue:[
        l add:'View'
    ].
    (includeApplicationModel and:[superClassName ~= 'ApplicationModel']) ifTrue:[
        l add:'ApplicationModel'
    ].
    
    includeStandaloneStartup ifTrue:[
        superClassName ~= 'StandaloneStartup' ifTrue:[
            l add:'StandaloneStartup'
        ].
        superClassName ~= 'StandaloneStartupHeadless' ifTrue:[
            l add:'StandaloneStartupHeadless'
        ].
    ].
    
    more := UserPreferences systemBrowserClass visitedClassNamesHistory.
    more notEmptyOrNil ifTrue:[
        l add:'-'.
        l addAll:more.
    ].
    ^ l

    "Created: / 30-01-2011 / 10:34:44 / cg"
!

listOfSuperclassesHolder
    <resource: #uiAspect>

    listOfSuperclassesHolder isNil ifTrue:[
        listOfSuperclassesHolder := self listOfSuperclasses asValue.
    ].
    ^ listOfSuperclassesHolder.
!

nameSpaceHolder
    <resource: #uiAspect>

    nameSpaceHolder isNil ifTrue:[
        nameSpaceHolder := ValueHolder new.
"/       nameSpaceHolder addDependent:self.
"/       nameSpaceHolder onChangeSend:#nameSpaceHolderChanged to:self.
    ].
    ^ nameSpaceHolder.
!

packageHolder
    <resource: #uiAspect>

    packageHolder isNil ifTrue:[
        packageHolder := (LastPackage ? nil "PackageId noProjectID") asValue.
    ].
    ^ packageHolder.
!

recentlyVisitedClasses
    <resource: #uiAspect>

    ^ SystemBrowser visitedClassNamesHistory
!

stereotypeHolder
    <resource: #uiAspect>

    stereotypeHolder isNil ifTrue:[
        stereotypeHolder := ValueHolder new.
        stereotypeHolder onChangeSend:#stereotypeChanged to:self.
    ].
    ^ stereotypeHolder.
!

stereotypeSpec
    ^ #(
        ( nil '<none>' )
        ( DataObject 'Data Object' )
"/      ( Enumeration Enumeration )
        ( GUIApplication 'GUI Application')
        ( ConsoleProgram 'Console Program')
        ( SharedPool 'Shared Pool')
        ( TestCase TestCase )
        ( WebService 'Web Service' )
        ( Widget Widget)
        ( StartupClass 'Startup Class (main entry for standalone apps)' )
        nil
        ( GUIProject 'GUI Project')
        ( NonGUIProject 'Non-GUI Project')
        ( LibraryProject 'Library Project')
    )

    "Modified: / 27-01-2012 / 14:46:39 / cg"
!

superclassNameHolder
    <resource: #uiAspect>

    superclassNameHolder isNil ifTrue:[
        superclassNameHolder := (LastSuperclass ? ''"'Object'") asValue.
    ].
    ^ superclassNameHolder.

    "Modified: / 27-01-2012 / 14:49:43 / cg"
! !

!NewClassWizardDialog class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

