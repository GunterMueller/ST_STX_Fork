"
 COPYRIGHT (c) 2008 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:clients/Demos/foxCalcApplication' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoFoxCalculatorClone
	instanceVariableNames:'operandStack firstOperand currentOperand lastOperand op
		angleFormat radix decimalPointFactor startNewNumber memory
		prevAngleFormat ledValue hypHolder invHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-foxCalc'
!

!GUIDemoFoxCalculatorClone class methodsFor:'documentation'!

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

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
!

documentation
"
    Simple example, how a simple calculator can be built using the UIPainter.
    Not so dump any more - actualy getting nicer and nicer...

    TODO:
	implement: '(', ')' and 'EXP' button behavior
	add more functions

    [author:]
	Claus Gittinger

    [start with:]
	GUIDemoCalculator open
"
! !

!GUIDemoFoxCalculatorClone class methodsFor:'defaults'!

hypMapping
    "if hyp is on, map function name through this mapping"

    ^ Dictionary
	    withAll:{
		'sin' -> 'sinh'.
		'cos' -> 'cosh'.
		'tan' -> 'tanh'.
	    }
!

invMapping
    "if inv is on, map function name through this mapping"

    ^ Dictionary
	    withAll:{
		'sin' -> 'arcSin'.
		'cos' -> 'arcCos'.
		'tan' -> 'arcTan'.
		'sinh' -> 'arcSinh'.
		'cosh' -> 'arcCosh'.
		'tanh' -> 'arcTanh'.
		'log' -> 'exp10'.
		'ln' -> 'exp'.
		'log2' -> 'exp2'.
		'sqrt' -> 'squared'.
		'\\' -> '//'.
		'raisedTo:' -> 'nthRoot:'.
		'factorial' -> 'invFactorial'
	    }
!

precedenceFor:operator
    ^ self precedenceMap at:operator ifAbsent:0

    "
     self precedenceFor:'+'
     self precedenceFor:'*'
    "
!

precedenceMap
    |d|

    d := Dictionary new.
    #(
	( '+'       50  )
	( '-'       50  )
	( '*'       70  )
	( '/'       70  )
    ) pairsDo:[:op :precedence |
	d at:op put:precedence
    ].
    ^ d.

    "
     self precedenceMap
    "
! !

!GUIDemoFoxCalculatorClone class methodsFor:'help specs'!

helpSpec
    <resource: #help>

    ^ super helpSpec addPairsFrom: self helpPairs
!

helpPairs
    <resource: #help>

    ^ #(

#shl
'Shift left (bit operation)'

#shr
'Shift right (bit operation)'
)
! !

!GUIDemoFoxCalculatorClone class methodsFor:'image specs'!

calcIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self calcIcon inspect
     ImageEditor openOnClass:self andSelector:#calcIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'CodingExamples_GUI::GUIDemoFoxCalculatorClone class calcIcon'
	ifAbsentPut:[(Depth24Image new) width: 31; height: 21; photometric:(#rgb); bitsPerSample:(#(8 8 8)); samplesPerPixel:(3); bits:(ByteArray fromPackedString:'
1K>;%8!!''''(5!!''H5&%(%''(Y!!7&)Y3%YE.%)A.''9U2%8)(&(=1%(=3$X=8#H=:%Y&H"89=$)NC#9A>$IQ=$)V@$8>D&)ZK$X>@%IVC$X>C%X9>''(=2''H-1()FJ
1K*;#8%)??>6<.Q;??>T=>5>??>\:>^F??:">_BS??2\=.^J??>,:-:V???K8.N7?_?Z8.OA???Z8M>/?_?@8.^$?/;B8M>&???L7>J+?_#N<NN/??^''>->P
,YI&EP@@'')]+;>I<2;4:3\@=1K(?/+]M1K9\0;5]/[MQ1;%L2;-L2K%RD  @B@\@B 4@@@X@@@X@@0X@B1D@A!!@@@P,@A@$@A00@@P(@@P$@B0 @D0 @4+)L
4;MB-YAJH@@@'')Y/??&M4\QD1K]W??>=??;O???Y??#N???LGP<@0;Q_.;A^E1H@0<V]-[>&.<*5.\&.0]F$++:M-LZ^-,^%/,&)0<:,+<B\.\")0\R11+:O
3K]B6[0<.9!!GF0@@&IA+>.:@1[X92;-&??[B4\R"2+:$3,F!!3[>RE@H@2K!!-2[-0CPT@<^;C;?KS8N[J:_OQ9N6>:?WC:OSP8.3Q:^;W9.+Q9N;L;OOR9N[N
3LVO4[-C6+0:,X0<G0@@''YQ-??6T4[=A3;]WF0D@E D@E@D@EPH@G@ @F0D@4KY)2[]%EPL@6\VF4+:C4,BB4LBD4<ZO2+>G3\NH2<BJ3<JX2+.P4,NJ4<"J
2,RF3<M15[\?7KU@.YEKG@@@%(5&=N]?3[%@3[MR2;E$2;Y52KY62;)*0*5^4;]82[A.1+U%2K]''0:--4KY;4[Y/3KM0.*Y31;ZB1+M.3K%7/*.A3;NK8KA2
3)5Z4[E44KM%6[QA7+MB/H=KGP@@''YM0??>#2[!!D2+Y ??;C??''SB0H@0[%1??:8??ORDP@@2LA7??.2??_TD0H@/:12???E???]C0T@1;U5??"<??;$FP@@
=Y5-&3HB!!#(#L@@@7[EF7+P>085CH@@@%81,;.A?3;9J1;M\??;@3\R]DP(@/+U*??>:3[6\D@H@/KQ)??>54LN D L@0KA4??"<2[>\CPD@1J=,??>=1[6Y
F0@@>I5&&3D@<*RMJ0@@6;IH7[Q@0(9BH@@@''IE1??>&2+U@3;YRFPL@DPL@DPL@2+Y_FPL@E P@E@H@1[Q\F $@D H@E L@4+!!+FPH@E0X@EPH@4[E$H@@@
E0L@H X@8*-XL @@K@$@F0D@5[UH6[UG.9EGF @@%81,<NFB4K-F4KYU2[I"1+-;/KE13[]$4+1)/:=32[%;2;]!!2;]!!3K:A.Z%.2;E&4+!!-/J540J=73;Q''
3;I"2KE-2+Q+4[Y[0*)P0[]23LA64+YK6[QI.IIIFP@@''YM/??>_3K-I1;I_???H?/#VB@H@1+]6??*<??+[B D@1[Y5??6:?O[VE@,@1[E<???G??#WB X@
/[!!8???F??3)CP@@2\I2??>3?//XCPD@4+QR7KQC.YICF @@%(5&>.6G2[UB3KY#??+B1+6^DP$@1[E2??*=4\Z*B0@@1+Q4??6;3\R%B @@1+E:??3C2K6]
B P@0K-7??2>2+:.B0@@0+Y,??>71[*^EPD@5+MO7+MB/IECGP@@'')U,??>W4;5C5+UTGP@@E@D@E L@4+M#G0@@E @@E D@4[Q$GPD@EP@@E0H@4;E''H@@@
EP@@EPH@4+%_G X@D D@EP@@5;E&I @@H @@H @@7;AD9KIC1H=IH0@@$H]^=N^A3[%@3Z=M5K])1[I71[M52:9^4;Y(1[A71;M82*5]4;%%1[I71+E83Z5
5[U(1[E61;M43+AV1Z)Q4LFF0[E>3J%/5J1/5KRC4J=,6+A@8KAA1X=IH @@''9Y/??>$2;%I2;Y#???E??+TB@L@1[]6??:???STC@H@1KY5??>>??''TB H@
2KU:??6??O_OB0P@2[U,??><??7]>_+(???*???"=O_ZC $@6\EU4*4:/X8>H@@@'')M3:]&A2+]N3[!!%??Z:2LB[B T@0;%4??6<4\R$C@D@1K)3??*12\BY
CPL@1+Y8??6<3L^]B0P@0;I,??*80+2\0K:/0,F//,J+/,&+A@\@1;AJ6[MD1Y]JH@@@&H16??>64K%S4KQSGPD@E0D@F0\@1[AUF0L@FP@@FP@@2+UXF@T@
FPD@G0T@2Z5YG@H@E@H@E@H@4K1&F0T@E@D@E P@E @@D @@B X@C0X@7K!!X8J=P/X%MG0@@(IJG;]&Z3[IW6[UW4Z-V3:5-3+E/5KQ]6[Y"7KU<4:115KY\
3J=S3:5-5J906KI]6[] 5+%52+E/3+M$2Z1^3[A,4Z=25J564;A:3K%?1+E.5:5W7J1Z/H9]FP@@%8^G((5X.9-P/YMI0YQS-8=^/)!!),85O-8=R-HUY/(=!!
.YMU.)]W.H9^0)Y''.H)L.H=Q+X%Y-YM&-)I -)IX.)QU/IMU0H9].8-[+X!!S.IYY/)QL-X9M-I!!1D@@@1+.?E@D@F@@@GP@@G0@@G @@FP@@H@@@G @@I@@@
GP@@F0@@FP@@G0@@GP@@H @@G @@GP@@E @@F@@@GP@@G@@@G @@H @@H0@@G @@F0@@GP@@F0@@C @@1;>2') ; yourself]
!

questIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self questIcon inspect
     ImageEditor openOnClass:self andSelector:#questIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'CodingExamples_GUI::GUIDemoFoxCalculatorClone class questIcon'
	ifAbsentPut:[(Depth8Image new) width: 24; height: 27; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@ P@@@@@@@@@@@@@@@@@@@@@@@@@@@<%H!!4]@@@@@@@@@@@@@@@@@@@@@@@@HB@%HA4"F @@@@@@@@@@@@@@@@@@@@H]H@8B
@@@WH@4E@@@@@@@@@@@@@@@@@@@@H X@@A4@GA<@@@@@@@@@@@@@@@@@@@@@@@@@@A CH0<@@@@@@@@@@@@@@@@@@@@@@@@@E0@\GP\B@@@@@@@@@@@@@@@@
@@@@@@@PABP&B@@@@@@@@@@@@@@@@@@@@@@@@A4@HQ I@P@@@@@@@@@@@@@@@@@@@@@@@@@MGP(B@@@@@@@@@@@@@@@@@@@@@@@@@@@^B0H@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@MC@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 0 8 0 8 8 0 8 16 8 16 16 8 32 40 32 40 40 32 128 128 120 144 144 136 152 160 144 152 160 152 160 168 160 168 168 160 176 176 168 176 176 176 184 184 176 184 192 184 192 192 176 192 192 184 192 200 184 192 200 192 200 192 184 200 200 192 200 208 192 200 208 200 208 200 192 208 208 200 208 216 200 208 216 208 216 216 208 216 216 216 216 224 216 224 224 216 224 232 224 232 232 224 232 240 224 232 240 232 240 240 232 240 248 232]; mask:((Depth1Image new) width: 24; height: 27; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@C8@@G<@@O>@@_?@@N_@@D_@@@?@@A>@@C<@@C8@@C0@@A @@@@@@A @@C0@@A @@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
! !

!GUIDemoFoxCalculatorClone class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoFoxCalculatorClone andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoFoxCalculatorClone new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoFoxCalculatorClone open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
	 label: 'Calculator'
	 name: 'Calculator'
	 min: (Point 475 240)
	 max: (Point 475 240)
	 bounds: (Rectangle 0 0 475 240)
	 backgroundColor: (Color 84.0 81.25 78.0)
	 forceRecursiveBackgroundOfDefaultBackground: true
       )
       component:
      (SpecCollection
	 collection: (
	  (ActionButtonSpec
	     label: 'calcIcon'
	     name: 'Button40'
	     layout: (LayoutFrame 2 0 11 0 48 0 41 0)
	     level: 0
	     hasCharacterOrientedLabel: false
	     backgroundColor: (Color 84.0 81.25 78.0)
	     translateLabel: true
	     resizeForLabel: true
	     model: openAboutThisApplication
	   )
	  (LabelSpec
	     label: 'ST/X Calculator'
	     name: 'Label2'
	     layout: (LayoutFrame 48 0 13 0 164 0 35 0)
	     backgroundColor: (Color 84.0 81.25 78.0)
	     translateLabel: true
	     adjust: left
	   )
	  (LabelSpec
	     name: 'ledValue'
	     layout: (LayoutFrame 179 0.0 10 0 -9 1.0 37 0)
	     style: (FontDescription Tahoma bold roman 10 #'ms-ansi' nil nil)
	     level: -1
	     foregroundColor: (Color 0.0 0.0 0.0)
	     backgroundColor: (Color 100.0 100.0 100.0)
	     translateLabel: true
	     labelChannel: ledValue
	     adjust: right
	   )
	  (HorizontalPanelViewSpec
	     name: 'RadixPanel'
	     layout: (LayoutFrame 9 0 49 0 263 0 73 0)
	     level: -1
	     backgroundColor: (Color 84.0 81.25 78.0)
	     horizontalLayout: fit
	     verticalLayout: fit
	     horizontalSpace: 0
	     verticalSpace: 0
	     component:
	    (SpecCollection
	       collection: (
		(ToggleSpec
		   label: 'Hex'
		   name: 'Toggle1'
		   backgroundColor: (Color 71.25 81.5 70.25)
		   translateLabel: true
		   model: radixIsHex
		   isTriggerOnDown: true
		   showLamp: false
		   extent: (Point 61 22)
		 )
		(ToggleSpec
		   label: 'Dec'
		   name: 'Toggle2'
		   backgroundColor: (Color 71.25 81.5 70.25)
		   translateLabel: true
		   model: radixIsDecimal
		   isTriggerOnDown: true
		   showLamp: false
		   lampColor: (Color 100.0 100.0 0.0)
		   extent: (Point 62 22)
		 )
		(ToggleSpec
		   label: 'Oct'
		   name: 'Toggle3'
		   backgroundColor: (Color 71.25 81.5 70.25)
		   translateLabel: true
		   model: radixIsOctal
		   isTriggerOnDown: true
		   showLamp: false
		   lampColor: (Color 100.0 100.0 0.0)
		   extent: (Point 62 22)
		 )
		(ToggleSpec
		   label: 'Bin'
		   name: 'Toggle4'
		   backgroundColor: (Color 71.25 81.5 70.25)
		   translateLabel: true
		   model: radixIsBinary
		   isTriggerOnDown: true
		   showLamp: false
		   lampColor: (Color 100.0 100.0 0.0)
		   extent: (Point 62 22)
		 )
		)

	     )
	   )
	  (HorizontalPanelViewSpec
	     name: 'AngleFormatPanel'
	     layout: (LayoutFrame 273 0 49 0 462 0 73 0)
	     level: -1
	     backgroundColor: (Color 84.0 81.25 78.0)
	     horizontalLayout: fit
	     verticalLayout: fit
	     horizontalSpace: 0
	     verticalSpace: 0
	     component:
	    (SpecCollection
	       collection: (
		(ToggleSpec
		   label: 'Deg'
		   name: 'DegToggle'
		   backgroundColor: (Color 84.75 58.75 59.25)
		   translateLabel: true
		   model: angleFormatDeg
		   isTriggerOnDown: true
		   showLamp: false
		   lampColor: (Color 100.0 100.0 0.0)
		   extent: (Point 61 22)
		 )
		(ToggleSpec
		   label: 'Rad'
		   name: 'RadToggle'
		   backgroundColor: (Color 84.25 59.25 59.25)
		   translateLabel: true
		   model: angleFormatRad
		   isTriggerOnDown: true
		   showLamp: false
		   lampColor: (Color 100.0 100.0 0.0)
		   extent: (Point 61 22)
		 )
		(ToggleSpec
		   label: 'Gra'
		   name: 'GraToggle'
		   backgroundColor: (Color 84.25 59.25 59.25)
		   translateLabel: true
		   model: angleFormatGra
		   isTriggerOnDown: true
		   showLamp: false
		   lampColor: (Color 100.0 100.0 0.0)
		   extent: (Point 61 22)
		 )
		)

	     )
	   )
	  (VerticalPanelViewSpec
	     name: 'verticalPanelView1'
	     layout: (LayoutFrame 4 0 80 0 232 0 230 0)
	     horizontalLayout: fit
	     verticalLayout: fitSpace
	     horizontalSpace: 3
	     verticalSpace: 4
	     component:
	    (SpecCollection
	       collection: (
		(HorizontalPanelViewSpec
		   name: 'horizontalPanelView1'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ToggleSpec
			 label: 'inv'
			 name: 'Toggle5'
			 backgroundColor: (Color 87.0 87.0 24.25)
			 translateLabel: true
			 model: invHolder
			 actionValue: 'inv'
			 showLamp: false
			 extent: (Point 50 20)
		       )
		      (ActionButtonSpec
			 label: 'pi'
			 name: 'piButton'
			 translateLabel: true
			 labelChannel: piButtonLabelHolder
			 model: piOrE
			 extent: (Point 51 20)
		       )
		      (ToggleSpec
			 label: 'hyp'
			 name: 'Toggle6'
			 backgroundColor: (Color 87.0 87.0 24.25)
			 translateLabel: true
			 model: hypHolder
			 actionValue: 'hyp'
			 showLamp: false
			 extent: (Point 51 20)
		       )
		      (ActionButtonSpec
			 label: 'A'
			 name: 'AButton'
			 backgroundColor: (Color 59.25 74.0 82.25)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsHex
			 actionValue: 10
			 extent: (Point 51 20)
		       )
		      )

		   )
		   extent: (Point 228 20)
		 )
		(HorizontalPanelViewSpec
		   name: 'horizontalPanelView2'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: '+/-'
			 name: 'negateButton'
			 translateLabel: true
			 model: unaryOp:
			 actionValue: 'negated'
			 extent: (Point 50 21)
		       )
		      (ActionButtonSpec
			 label: 'shl'
			 name: 'shlButton'
			 activeHelpKey: shl
			 translateLabel: true
			 model: binOp:
			 actionValue: 'bitShift:'
			 extent: (Point 51 21)
		       )
		      (ActionButtonSpec
			 label: 'sin'
			 name: 'sinButton'
			 activeHelpKey: sin
			 translateLabel: true
			 labelChannel: sinButtonLabelHolder
			 model: trigFunc:
			 actionValue: 'sin'
			 extent: (Point 51 21)
		       )
		      (ActionButtonSpec
			 label: 'B'
			 name: 'BButton'
			 backgroundColor: (Color 59.25 74.0 82.25)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsHex
			 actionValue: 11
			 extent: (Point 51 21)
		       )
		      )

		   )
		   extent: (Point 228 21)
		 )
		(HorizontalPanelViewSpec
		   name: 'horizontalPanelView3'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: '1/x'
			 name: 'reciprocalButton'
			 translateLabel: true
			 model: unaryOp:
			 actionValue: 'reciprocal'
			 extent: (Point 50 20)
		       )
		      (ActionButtonSpec
			 label: 'shr'
			 activeHelpKey: shr
			 name: 'shrButton'
			 translateLabel: true
			 model: binOp:
			 actionValue: 'rightShift:'
			 extent: (Point 51 20)
		       )
		      (ActionButtonSpec
			 label: 'cos'
			 activeHelpKey: cos
			 name: 'cosButton'
			 translateLabel: true
			 labelChannel: cosButtonLabelHolder
			 model: trigFunc:
			 actionValue: 'cos'
			 extent: (Point 51 20)
		       )
		      (ActionButtonSpec
			 label: 'C'
			 name: 'CButton'
			 backgroundColor: (Color 59.25 74.0 82.25)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsHex
			 actionValue: 12
			 extent: (Point 51 20)
		       )
		      )

		   )
		   extent: (Point 228 20)
		 )
		(HorizontalPanelViewSpec
		   name: 'horizontalPanelView4'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: 'x^y'
			 name: 'powerButton'
			 activeHelpKey: power
			 translateLabel: true
			 labelChannel: powerButtonLabelHolder
			 model: binOp:
			 actionValue: 'raisedTo:'
			 extent: (Point 50 20)
		       )
		      (ActionButtonSpec
			 label: 'x!!'
			 activeHelpKey: factorial
			 name: 'factorialButton'
			 translateLabel: true
			 labelChannel: factorialButtonLabelHolder
			 model: unaryOp:
			 actionValue: 'factorial'
			 extent: (Point 51 20)
		       )
		      (ActionButtonSpec
			 label: 'tan'
			 name: 'tanButton'
			 activeHelpKey: tan
			 translateLabel: true
			 labelChannel: tanButtonLabelHolder
			 model: trigFunc:
			 actionValue: 'tan'
			 extent: (Point 51 20)
		       )
		      (ActionButtonSpec
			 label: 'D'
			 name: 'DButton'
			 backgroundColor: (Color 59.25 74.0 82.25)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsHex
			 actionValue: 13
			 extent: (Point 51 20)
		       )
		      )

		   )
		   extent: (Point 228 20)
		 )
		(HorizontalPanelViewSpec
		   name: 'HorizontalPanel1'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: 'sqrt'
			 activeHelpKey: sqrt
			 name: 'sqrtButton'
			 translateLabel: true
			 labelChannel: sqrtButtonLabelHolder
			 model: unaryOp:
			 actionValue: 'sqrt'
			 extent: (Point 50 21)
		       )
		      (ActionButtonSpec
			 activeHelpKey: npr
			 label: 'nPr'
			 name: 'nPrButton'
			 translateLabel: true
			 model: specialFunction:
			 actionValue: 'npr'
			 extent: (Point 51 21)
		       )
		      (ActionButtonSpec
			 label: 'log'
			 activeHelpKey: log
			 name: 'logButton'
			 translateLabel: true
			 labelChannel: logButtonLabelHolder
			 model: unaryOp:
			 actionValue: 'log'
			 extent: (Point 51 21)
		       )
		      (ActionButtonSpec
			 label: 'E'
			 name: 'EButton'
			 backgroundColor: (Color 59.25 74.0 82.25)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsHex
			 actionValue: 14
			 extent: (Point 51 21)
		       )
		      )

		   )
		   extent: (Point 228 21)
		 )
		(HorizontalPanelViewSpec
		   name: 'HorizontalPanel2'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: '2log'
			 activeHelpKey: log2
			 name: 'log2Button'
			 translateLabel: true
			 labelChannel: log2ButtonLabelHolder
			 model: unaryOp:
			 actionValue: 'log2'
			 extent: (Point 50 20)
		       )
		      (ActionButtonSpec
			 label: 'nCr'
			 activeHelpKey: ncr
			 name: 'nCrButton'
			 translateLabel: true
			 model: specialFunction:
			 actionValue: 'ncr'
			 extent: (Point 51 20)
		       )
		      (ActionButtonSpec
			 label: 'ln'
			 activeHelpKey: ln
			 name: 'lnButton'
			 translateLabel: true
			 labelChannel: lnButtonLabelHolder
			 model: unaryOp:
			 actionValue: 'ln'
			 extent: (Point 51 20)
		       )
		      (ActionButtonSpec
			 label: 'F'
			 name: 'FButton'
			 backgroundColor: (Color 59.25 74.0 82.25)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsHex
			 actionValue: 15
			 extent: (Point 51 20)
		       )
		      )

		   )
		   extent: (Point 228 20)
		 )
		)

	     )
	   )
	  (VerticalPanelViewSpec
	     name: 'VerticalPanelView2'
	     layout: (LayoutFrame 240 0 80 0 468 0 230 0)
	     horizontalLayout: fit
	     verticalLayout: fitSpace
	     horizontalSpace: 3
	     verticalSpace: 4
	     component:
	    (SpecCollection
	       collection: (
		(HorizontalPanelViewSpec
		   name: 'HorizontalPanel3'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: 'MR'
			 name: 'Button9'
			 backgroundColor: (Color 73.0 81.25 88.75)
			 translateLabel: true
			 model: memorize
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'M+'
			 name: 'Button10'
			 backgroundColor: (Color 73.0 81.25 88.75)
			 translateLabel: true
			 model: memoryPlus
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'M-'
			 name: 'Button11'
			 backgroundColor: (Color 73.0 81.25 88.75)
			 translateLabel: true
			 model: memoryMinus
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'MC'
			 name: 'Button12'
			 backgroundColor: (Color 73.0 81.25 88.75)
			 translateLabel: true
			 model: memoryClear
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'C'
			 name: 'ClearButton'
			 backgroundColor: (Color 94.5 59.25 0.0)
			 translateLabel: true
			 model: clear
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'AC'
			 name: 'AllClearButton38'
			 backgroundColor: (Color 95.0 49.0 0.0)
			 translateLabel: true
			 model: clearAll
			 extent: (Point 33 25)
		       )
		      )

		   )
		   extent: (Point 228 25)
		 )
		(HorizontalPanelViewSpec
		   name: 'HorizontalPanel4'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: '7'
			 name: 'Button7'
			 backgroundColor: (Color 40.0 80.5 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo8
			 actionValue: 7
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '8'
			 name: 'Button8'
			 backgroundColor: (Color 39.25 80.75 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo10
			 actionValue: 8
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '9'
			 name: 'Button13'
			 backgroundColor: (Color 39.25 80.75 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo10
			 actionValue: 9
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '('
			 name: 'lParButton'
			 translateLabel: true
			 model: leftPar
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: ')'
			 name: 'rParButton'
			 translateLabel: true
			 model: rightPar
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'and'
			 name: 'Button39'
			 translateLabel: true
			 model: binOp:
			 actionValue: 'bitAnd:'
			 extent: (Point 33 25)
		       )
		      )

		   )
		   extent: (Point 228 25)
		 )
		(HorizontalPanelViewSpec
		   name: 'HorizontalPanel5'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: '4'
			 name: 'Button4'
			 backgroundColor: (Color 39.25 80.75 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo8
			 actionValue: 4
			 extent: (Point 32 26)
		       )
		      (ActionButtonSpec
			 label: '5'
			 name: 'Button5'
			 backgroundColor: (Color 39.25 80.75 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo8
			 actionValue: 5
			 extent: (Point 32 26)
		       )
		      (ActionButtonSpec
			 label: '6'
			 name: 'Button6'
			 backgroundColor: (Color 39.25 80.75 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo8
			 actionValue: 6
			 extent: (Point 32 26)
		       )
		      (ActionButtonSpec
			 label: '*'
			 name: 'Button20'
			 translateLabel: true
			 model: binOp:
			 actionValue: '*'
			 extent: (Point 32 26)
		       )
		      (ActionButtonSpec
			 label: '/'
			 name: 'Button35'
			 translateLabel: true
			 model: binOp:
			 actionValue: '/'
			 extent: (Point 32 26)
		       )
		      (ActionButtonSpec
			 label: 'or'
			 name: 'OrButton'
			 translateLabel: true
			 model: binOp:
			 actionValue: 'bitOr:'
			 extent: (Point 33 26)
		       )
		      )

		   )
		   extent: (Point 228 26)
		 )
		(HorizontalPanelViewSpec
		   name: 'HorizontalPanel6'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: '1'
			 name: 'Button1'
			 backgroundColor: (Color 37.25 81.5 79.25)
			 translateLabel: true
			 model: digit:
			 actionValue: 1
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '2'
			 name: 'Button2'
			 backgroundColor: (Color 35.75 82.25 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo8
			 actionValue: 2
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '3'
			 name: 'Button3'
			 backgroundColor: (Color 35.75 82.25 80.0)
			 translateLabel: true
			 model: digit:
			 enableChannel: radixIsGreaterOrEqualTo8
			 actionValue: 3
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '+'
			 name: 'PlusButton'
			 translateLabel: true
			 model: binOp:
			 actionValue: '+'
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '-'
			 name: 'MinusButton'
			 translateLabel: true
			 model: binOp:
			 actionValue: '-'
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'xor'
			 name: 'XorButton'
			 translateLabel: true
			 model: binOp:
			 actionValue: 'bitXor:'
			 extent: (Point 33 25)
		       )
		      )

		   )
		   extent: (Point 228 25)
		 )
		(HorizontalPanelViewSpec
		   name: 'HorizontalPanel7'
		   horizontalLayout: fitSpace
		   verticalLayout: fit
		   horizontalSpace: 4
		   verticalSpace: 3
		   component:
		  (SpecCollection
		     collection: (
		      (ActionButtonSpec
			 label: '0'
			 name: 'Button0'
			 backgroundColor: (Color 39.5 80.5 81.5)
			 translateLabel: true
			 model: digit:
			 actionValue: 0
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '.'
			 name: 'DotButton'
			 backgroundColor: (Color 39.25 80.5 81.25)
			 translateLabel: true
			 model: decimalPoint
			 actionValue: '0'
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'exp'
			 name: 'expButton'
			 translateLabel: true
			 model: exponent
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: '='
			 name: 'ResultButton'
			 backgroundColor: (Color 100.0 87.0 60.5)
			 translateLabel: true
			 model: result
			 actionValue: '+'
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'mod'
			 name: 'modButton'
			 translateLabel: true
			 labelChannel: modButtonLabelHolder
			 model: binOp:
			 actionValue: '\\'
			 extent: (Point 32 25)
		       )
		      (ActionButtonSpec
			 label: 'not'
			 name: 'NotButton'
			 translateLabel: true
			 model: unaryOp:
			 actionValue: 'bitInvert'
			 extent: (Point 33 25)
		       )
		      )

		   )
		   extent: (Point 228 25)
		 )
		)

	     )
	   )
	  )

       )
     )
! !

!GUIDemoFoxCalculatorClone methodsFor:'actions-helpers'!

computeResultFromPreviousOperand
    |rslt|

    op isNil ifTrue:[ ^ self].
    firstOperand isNil ifTrue:[
	firstOperand := 0.
    ].
    currentOperand isNil ifTrue:[
	currentOperand := lastOperand.
    ].
    Number divisionByZeroSignal handle:[:ex |
	self ledValue value:'0-Error'
    ] do:[
	rslt := self performBinaryOp:op.
	lastOperand := currentOperand.
	currentOperand := rslt.
	self updateDisplayValue
    ].
    op := nil.

    "Modified: / 16.10.1999 / 13:20:44 / cg"
!

performBinaryOp:op
    "/ sorry - for some ops, there is no corresponding method in Number

    op = 'nthRoot:' ifTrue:[
	"/ x ^ (1/y)
	^ firstOperand raisedTo:(1 / currentOperand).
    ].
    op = 'mod:' ifTrue:[
	^ firstOperand \\ currentOperand.
    ].
    ^ firstOperand perform:(op asSymbol) with:currentOperand.
!

performUnaryOp:op
    "/ special kludge: sorry for some ops, there are no corresponding methods in Number

    |invFac remains|

    "/ ouch - a switch - not very OO ;-(
    op = 'log2' ifTrue:[
       ^ currentOperand log:2.
    ].
    op = 'exp2' ifTrue:[
	^ 2 raisedTo:currentOperand.
    ].
    op = 'exp10' ifTrue:[
	^ 10 raisedTo:currentOperand.
    ].
    op = 'invFactorial' ifTrue:[
	"/ count up, keep on dividing, until we get a non-integral result.
	"/ consider that an error. Otherwise, stop when we reach 1
	invFac := 1.
	remains := currentOperand.
	[
	    remains ~= 1
	    and:[ remains isInteger ]
	] whileTrue:[
	    invFac := invFac + 1.
	    remains := remains / invFac.
	].
	remains = 1 ifFalse:[self error].
	^ invFac.
    ].
    [
	^ currentOperand perform:op asSymbol.
    ] valueWithWatchDog:[
	^ 'Error - Timeout'
    ] afterMilliseconds:10000.
!

startNewNumber
    "the next digit will start a new number"

    startNewNumber := true.
    decimalPointFactor := nil.

    "Modified: / 16.10.1999 / 13:19:18 / cg"
!

updateDisplayValue
    |s|

    "/ try to make it integer, if possible (i.1. 2.0 -> 2)
    currentOperand = currentOperand asInteger ifTrue:[
	currentOperand := currentOperand asInteger
    ].

    currentOperand isInteger ifTrue:[
	s := currentOperand printStringRadix:radix value.
	decimalPointFactor notNil ifTrue:[
	    s := s , '.'
	].
    ] ifFalse:[
	"/ floats are always shown as decimals
	self radix value:10.
	s := currentOperand asFloat printfPrintString:'%.16g'.
    ].
"/    "/ the LED cannot display B, D and e.
"/    s := s copyReplaceAll:$B with:$b.
"/    s := s copyReplaceAll:$D with:$d.
"/    s := s copyReplaceAll:$e with:$E.
    self ledValue value:(s contractTo:40).
! !

!GUIDemoFoxCalculatorClone methodsFor:'actions-memory'!

memorize
    memory := currentOperand ? 0.
    self startNewNumber.
!

memoryClear
    memory := currentOperand := 0.
    self startNewNumber.
    self updateDisplayValue.
!

memoryMinus
    memory := (memory ? 0) - currentOperand.
    currentOperand := memory.
    self startNewNumber.
    self updateDisplayValue.
!

memoryPlus
    memory := (memory ? 0) + currentOperand.
    currentOperand := memory.
    self startNewNumber.
    self updateDisplayValue.
! !

!GUIDemoFoxCalculatorClone methodsFor:'actions-number entry'!

backspace
    |base|

    base := self radix value.
    decimalPointFactor isNil ifTrue:[
	currentOperand := currentOperand // base.
    ] ifFalse:[
	decimalPointFactor := decimalPointFactor * base.
	decimalPointFactor = 1 ifTrue:[
	    decimalPointFactor := nil
	] ifFalse:[
	    currentOperand := currentOperand truncateTo: (decimalPointFactor * base).
	].
    ].
    self updateDisplayValue.
!

decimalPoint
    decimalPointFactor isNil ifTrue:[
	decimalPointFactor := 1 / (self radix value).
	self updateDisplayValue.
    ]
!

digit:digit
    (startNewNumber or:[currentOperand isNil]) ifTrue:[
	currentOperand := 0.
	startNewNumber := false.
    ].
    decimalPointFactor isNil ifTrue:[
	currentOperand := (currentOperand * (self radix value)) + digit.
    ] ifFalse:[
	currentOperand := currentOperand + (decimalPointFactor * digit).
	decimalPointFactor := decimalPointFactor / (self radix value).
    ].
    self updateDisplayValue.
! !

!GUIDemoFoxCalculatorClone methodsFor:'actions-operations'!

binOp:newOpArg
    |newOp oldOp|

    "/ inv mapping if required
    newOp := (self invHolder value)
	    ifTrue:[ self class invMapping at:newOpArg ifAbsent: newOpArg ]
	    ifFalse:[ newOpArg ].

    oldOp := op.
    oldOp notNil ifTrue:[
	(self class precedenceFor:oldOp) <  (self class precedenceFor:newOp) ifTrue:[
	    "/ push
	    operandStack addLast:firstOperand.
	    operandStack addLast:oldOp.
	] ifFalse:[
	    "/ compute
	    self computeResultFromPreviousOperand.

	    "/ pop needed ?
	    [
		operandStack notEmpty
		and:[ (self class precedenceFor:operandStack last) >= (self class precedenceFor:newOp) ]
	    ] whileTrue:[
		op := operandStack removeLast.
		firstOperand := operandStack removeLast.
		self computeResultFromPreviousOperand.
	    ].
	].
    ].

    op := newOp.
    firstOperand := currentOperand.
    self startNewNumber

    "Modified: / 16.10.1999 / 13:19:18 / cg"
!

const:selector
    currentOperand := Float perform:selector asSymbol.
    self startNewNumber.
    self updateDisplayValue.
!

piOrE
    invHolder value ifTrue:[
	self const:#e
    ] ifFalse:[
	self const:#pi
    ].
!

specialFunction:whichOne
    Dialog information:'Unimplemented: ',whichOne
!

trigFunc:opArg
    "care for the angleFormat (convert operand to radians firt)"

    |op toRad|

    toRad := self converterToRadiansFrom:angleFormat value.
    currentOperand := toRad value:(currentOperand ? 0).

    op := opArg.

    "/ hyp mapping if required (inv mapping is done in unaryOp:)
    self hypHolder value ifTrue:[
	op := self class hypMapping at:op ifAbsent: op.
    ].

    self unaryOp:op
!

unaryOp:opArg
    |op|

    "/ inv mapping if required
    op := (self invHolder value)
	    ifTrue:[ self class invMapping at:opArg ifAbsent: opArg ]
	    ifFalse:[ opArg ].

    Error handle:[:ex |
	self ledValue value:'Error'
    ] do:[
	Number divisionByZeroSignal handle:[:ex |
	    self ledValue value:'0-Error'
	] do:[
	    currentOperand := self performUnaryOp:op.
	    self updateDisplayValue
	].
    ].

    self startNewNumber.
! !

!GUIDemoFoxCalculatorClone methodsFor:'actions-other'!

clear
    currentOperand := 0.
    self startNewNumber.
    self updateDisplayValue.

    "Modified: / 28.10.1997 / 15:31:52 / cg"
!

clearAll
    operandStack := OrderedCollection new.

    currentOperand := 0.
    firstOperand := op := nil.
    self startNewNumber.

    self updateDisplayValue .

    "Modified: / 28.10.1997 / 15:31:52 / cg"
!

leftPar
    Dialog information:'Unimplemented: "("'
!

result
    operandStack notEmpty ifTrue:[
	(self class precedenceFor:operandStack last) < (self class precedenceFor:op) ifTrue:[
	    "/ compute
	    self computeResultFromPreviousOperand.
	    "/ then pop
	    op := operandStack removeLast.
	    firstOperand := operandStack removeLast.
	] ifFalse:[
	    "/ pop
	    op := operandStack removeLast.
	    firstOperand := operandStack removeLast.
	    "/ compute
	    self computeResultFromPreviousOperand.
	].
	self result
    ] ifFalse:[
	self computeResultFromPreviousOperand.
    ].
!

rightPar
    Dialog information:'Unimplemented: ")"'
!

showAbout
    self openAboutThisApplication
! !

!GUIDemoFoxCalculatorClone methodsFor:'aspects'!

angleFormat
    <resource: #uiAspect>

    angleFormat isNil ifTrue:[
	angleFormat := #rad asValue.
	prevAngleFormat := #rad.
	angleFormat onChangeSend:#angleFormatChanged to:self.
    ].
    ^ angleFormat.
!

angleFormatDeg
    "a helping aspect: converts (angleFormat == #deg) into a boolean aspect."

    <resource: #uiAspect>

    ^ (PluggableAdaptor on:self angleFormat)
	getBlock:[:m | m value == #deg]
	putBlock:[:m :newValue | newValue ifTrue:[ m value: #deg ] ]
	updateBlock:[:m :aspect :param | true ].
!

angleFormatGra
    "a helping aspect: converts (angleFormat == #gra) into a boolean aspect."

    <resource: #uiAspect>

    ^ (PluggableAdaptor on:self angleFormat)
	getBlock:[:m | m value == #gra]
	putBlock:[:m :newValue | newValue ifTrue:[ m value: #gra ] ]
	updateBlock:[:m :aspect :param | true].
!

angleFormatRad
    "a helping aspect: converts (angleFormat == #rad) into a boolean aspect."

    <resource: #uiAspect>

    ^ (PluggableAdaptor on:self angleFormat)
	getBlock:[:m | m value == #rad]
	putBlock:[:m :newValue | newValue ifTrue:[ m value: #rad ] ]
	updateBlock:[:m :aspect :param | true].
!

hypHolder
    <resource: #uiAspect>

    hypHolder isNil ifTrue:[
	hypHolder := false asValue.
    ].
    ^ hypHolder.
!

invHolder
    <resource: #uiAspect>

    invHolder isNil ifTrue:[
	invHolder := false asValue.
    ].
    ^ invHolder.
!

ledValue
    ledValue isNil ifTrue:[
	ledValue := '0' asValue.
    ].
    ^ ledValue
!

radix
    <resource: #uiAspect>

    radix isNil ifTrue:[
	radix := 10 asValue.
	radix onChangeSend:#radixChanged to:self.
    ].
    ^ radix.
!

radixIsBinary
    "a helping aspect: converts (radix value == 2) into a boolean aspect."

    <resource: #uiAspect>

    ^ (PluggableAdaptor on:self radix)
	getBlock:[:m | m value == 2]
	putBlock:[:m :newValue | newValue ifTrue:[ m value: 2 ] ]
	updateBlock:[:m :aspect :param | true ].
!

radixIsDecimal
    "a helping aspect: converts (radix value == 10) into a boolean aspect."

    <resource: #uiAspect>

    ^ (PluggableAdaptor on:self radix)
	getBlock:[:m | m value == 10]
	putBlock:[:m :newValue | newValue ifTrue:[ m value: 10 ] ]
	updateBlock:[:m :aspect :param | true ].
!

radixIsGreaterOrEqualTo10
    "a helping aspect: converts (radix >= 10) into a boolean aspect (for button-enable)."

    <resource: #uiAspect>

    ^ BlockValue
	with:[:v | v >= 10]
	argument:(self radix)
!

radixIsGreaterOrEqualTo8
    "a helping aspect: converts (radix >= 8) into a boolean aspect (for button-enable)."

    <resource: #uiAspect>

    ^ BlockValue
	with:[:v | v >= 8]
	argument:(self radix)
!

radixIsHex
    "a helping aspect: converts (radix value == 16) into a boolean aspect."

    <resource: #uiAspect>

    ^ (PluggableAdaptor on:self radix)
	getBlock:[:m | m value == 16]
	putBlock:[:m :newValue | newValue ifTrue:[ m value: 16 ] ]
	updateBlock:[:m :aspect :param | true ].
!

radixIsOctal
    "a helping aspect: converts (radix value == 8) into a boolean aspect."

    <resource: #uiAspect>

    ^ (PluggableAdaptor on:self radix)
	getBlock:[:m | m value == 8]
	putBlock:[:m :newValue | newValue ifTrue:[ m value: 8 ] ]
	updateBlock:[:m :aspect :param | true ].
! !

!GUIDemoFoxCalculatorClone methodsFor:'aspects-dynamic labels'!

cosButtonLabelHolder
    ^ BlockValue
	with:[:inv :hyp |
	    hyp
		ifTrue: [ inv ifTrue: 'acosh'  ifFalse: 'cosh' ]
		ifFalse:[ inv ifTrue: 'acos'   ifFalse: 'cos'  ]
	]
	argument:(self invHolder)
	argument:(self hypHolder)
!

factorialButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: 'n of n!!'  ifFalse: 'n!!'
	]
	argument:(self invHolder)
!

lnButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: 'e^x'  ifFalse: 'ln'
	]
	argument:(self invHolder)
!

log2ButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: '2^x'  ifFalse: '2log'
	]
	argument:(self invHolder)
!

logButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: '10^x'  ifFalse: 'log'
	]
	argument:(self invHolder)
!

modButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: 'div'  ifFalse: 'mod'
	]
	argument:(self invHolder)
!

piButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: 'e'  ifFalse: 'pi'
	]
	argument:(self invHolder)
!

powerButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: 'x^1/y'  ifFalse: 'x^y'
	]
	argument:(self invHolder)
!

sinButtonLabelHolder
    "a valueHolder for the sin-buttons labelChannel.
     takes the value of 'asinh', 'sinh', 'asin' or 'sin'
     dep'ing on the inv and hyp holder values"

    ^ BlockValue
	with:[:inv :hyp |
	    hyp
		ifTrue: [ inv ifTrue: 'asinh'  ifFalse: 'sinh' ]
		ifFalse:[ inv ifTrue: 'asin'   ifFalse: 'sin'  ]
	]
	argument:(self invHolder)
	argument:(self hypHolder)
!

sqrtButtonLabelHolder
    ^ BlockValue
	with:[:inv  |
	    inv ifTrue: 'x^2'  ifFalse: 'sqrt'
	]
	argument:(self invHolder)
!

tanButtonLabelHolder
    ^ BlockValue
	with:[:inv :hyp |
	    hyp
		ifTrue: [ inv ifTrue: 'atanh'  ifFalse: 'tanh' ]
		ifFalse:[ inv ifTrue: 'atan'   ifFalse: 'tan'  ]
	]
	argument:(self invHolder)
	argument:(self hypHolder)
! !

!GUIDemoFoxCalculatorClone methodsFor:'change & update'!

angleFormatChanged
    |prevFormatToRad radToNewFormat radians|

    prevFormatToRad := self converterToRadiansFrom:prevAngleFormat.
    radToNewFormat := self converterFromRadiansTo:angleFormat value.

    radians := (prevFormatToRad value:currentOperand ? 0).
    currentOperand := (radToNewFormat value:radians).

    self updateDisplayValue.
    prevAngleFormat := angleFormat value.
    self startNewNumber
!

radixChanged
    self updateDisplayValue.
    self startNewNumber
! !

!GUIDemoFoxCalculatorClone methodsFor:'event handling'!

processEvent:anEvent
    "filter keyboard edit-events typed into the listOfItemsView.
     Return true, if I have eaten the event"

    |rawKey key|

    anEvent isKeyPressEvent ifFalse:[^ false].

    key    := anEvent key.
    rawKey := anEvent rawKey.
    key isCharacter ifTrue:[
	(key between:$0 and:$9) ifTrue:[
	    self digit:(key - $0).
	    ^ true.
	].
	(key asLowercase between:$a and:$f) ifTrue:[
	    radix value == 16 ifTrue:[
		self digit:(key asLowercase - $a + 10).
	    ].
	    ^ true.
	].
	key == $. ifTrue:[
	    self decimalPoint.
	    ^ true.
	].
	(#($+ $- $* $/) includes:key) ifTrue:[
	    self binOp:(key asString).
	    ^ true.
	].
	key == $= ifTrue:[
	    self result.
	    ^ true.
	].
    ].

    (key == #Return) ifTrue:[
	self result.
	^ true.
    ].
    (key == #Delete or:[key == #BackSpace]) ifTrue:[
	self backspace.
	^ true.
    ].


    ^ false.
! !

!GUIDemoFoxCalculatorClone methodsFor:'info'!

aboutThisApplicationLabel
    ^ 'About Better Calc'
!

aboutThisApplicationText
    ^ 'A little demo showing the capabilities of the UI-Framework,\and of course, of Smalltalk !!' withCRs.
! !

!GUIDemoFoxCalculatorClone methodsFor:'initialization'!

initialize
    super initialize.

    currentOperand := 0.
    operandStack := OrderedCollection new.
    startNewNumber := true.
!

postOpenWith:aBuilder
    self windowGroup addPreEventHook:self.
    super postOpenWith:aBuilder.
! !

!GUIDemoFoxCalculatorClone methodsFor:'misc helpers'!

converterFromRadiansTo:angleFormat
    "/ sigh - a switch
    angleFormat == #rad ifTrue:[
	^ [:n | n].
    ].
    angleFormat == #deg ifTrue:[
	^ [:n | ((n radiansToDegrees) asFixedPoint:6) asFloat].
    ].
    angleFormat == #gra ifTrue:[
	^ [:n | ((n * (200.0 / Float pi)) asFixedPoint:6) asFloat].
    ].
    self error.
!

converterToRadiansFrom:angleFormat
    "/ sigh - a switch
    angleFormat == #rad ifTrue:[
	^ [:n | n].
    ].
    angleFormat == #deg ifTrue:[
	^ [:n | n degreesToRadians ].
    ].
    angleFormat == #gra ifTrue:[
	^ [:n | n * (Float pi / 200.0) ].
    ].
    self error.
! !

!GUIDemoFoxCalculatorClone class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/foxCalcApplication/CodingExamples_GUI__GUIDemoFoxCalculatorClone.st,v 1.11 2018-01-16 21:23:26 cg Exp $'
! !
