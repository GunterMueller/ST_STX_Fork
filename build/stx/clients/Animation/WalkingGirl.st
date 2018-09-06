"{ Package: 'stx:clients/Animation' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#WalkingGirl
	instanceVariableNames:'view'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Animations'
!

SimpleView subclass:#AnimationView
	instanceVariableNames:'form girl process'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WalkingGirl
!

Object subclass:#Girl
	instanceVariableNames:'view sequence index image bounds damage'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WalkingGirl
!


!WalkingGirl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WalkingGirl andSelector:#windowSpec
     WalkingGirl new openInterface:#windowSpec
     WalkingGirl open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: #WalkingGirl
          #name: #WalkingGirl
          #min: #(#Point 10 10)
          #max: #(#Point 1600 1200)
          #bounds: #(#Rectangle 9 131 809 431)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #hasBorder: false
              #component: #view
            )
           )
         
        )
      )
! !

!WalkingGirl methodsFor:'accessing'!

view
    "
    "
    ^ view
! !

!WalkingGirl methodsFor:'initialization'!

initialize
    "
    "
    super initialize.

    view := WalkingGirl::AnimationView new.
! !

!WalkingGirl::AnimationView class methodsFor:'image'!

background
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self background inspect
     ImageEditor openOnClass:self andSelector:#background
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Playground class background'
        ifAbsentPut:[(Depth24Image new) width: 94; height: 94; photometric:(#rgb); bitsPerSample:(#(8 8 8 )); samplesPerPixel:(3); bits:(ByteArray fromPackedString:'
[]Y:[]Q9[-U:[=Y;\-%=]M6@]^BB]NJA]>FE^>RH_^RK_.JJ^.FH^NJH]^RF\^RE\>]<\.U=\NM>[>FA\.FB]NJC^^NA^.RB_>ZM .&P!!^2S"N>V"_BW"/FX
"/FX!!>:U!!>.S >^O N^N .&N ^*N_>"L_.&K N.M .ZN N^N_.^K_>"L N&M >2O!!.6Q!!>:R".:T"^6S"N2R!!>.Q!!.*P >^M NRJ_>NI_NFE_NFE^.FE^^JE
^.NG^>NJ_NJL_NJN_^RI NRJ_.JH_^FI_^FI NRL .ZN .ZN!!^*L!!>2N"N6Q!!>2P!!..O!!..M"N6M"^:N">6V!!.&O_>JH^]:B\=)>[=!!9[]Y7Z-U5Z]I5ZMM5
ZMM5Z]]8Z]]8[-%;\M%=[=!!<[=Y;[-U:[-U9[-]:[=)<\M-=]M6A^M>F_NBH_]>J_NBJ^NBG]NFF\^BB\.I>\^E=[]==[=9?[=:@\=6A]]:B]=:B^.FF_^RI
 ^"M!!N.P"N>T"/FV"_BU!!>:S"N2T!!^&Q ^"O ^"M N&M_.&K_>*L_>6N >*O >2O .6O .6O .6O .6M!!^:O!!.>P"_BT"/FU"/FU"_BT"N>S!!.6R >*O ^"M
_>NM_>NK_NNH^>RG^>RG^>RG_NNH_^FG_NNH_^RI_^RI_.JH_.JH_>NK_>NK_>NK ^VM .ZP!!N"R!!^"U!!^&S!!^&S!!.*R!!>.S">6V!!>*P .ZL_^RI^.FE]]:A
[=):Z=Y6Z=Q7Z-U7ZMY7Z=%:[M);[-1=[=1?\]-?\--?\]!!=[=Y:[]Q8[]Q8[MU8\]U=]]^@^M*E_]2J_M:K^=>I]-:E\-2B\M6@[-5?[]1>[]1>[])=\M*@
\]&B\=&C]M.@^^BE_NNH_>ZK!!N.P!!.6R!!.6R"N>T".:V!!.6T >*O_>"L_^^K_.&K_^.L_^.L ^2L ^>N ?FP /JN _FM /BM /BM!!_FN!!^:O"OFR"_JU"OFT
"OFT"N>S!!.6Q >*N >ZS ^VO_^RK^.NF^>RE_NRE_.NE_^JD^.FF_NNH_^RI_^RI_^RI_^RI_NNH^>JG^>JI_NJL_.RN ."T >&U ."R ."R!!N.R!!>.S!!.*R
 >*O!!^2Q!!^:R >2O_.&K^.VG[=)<[-%;Z]]8Z-%:Z-%:[-1=[]1>[=1?\=6A]]:B]]2A]M!!>\]U;[]Q9[=E:\=I>]-VC^-&G_M.I^=6J^M2F]M.B\].C\M*@
[-1=[]-:[-%;[=!!<[=U?[=VA[-]:]M6@]>BC^^JE_NVH_.^J N&L!!^:Q"^6S!!>:S!!N.P N&M_^"J_N*K^.*H^^&G^.*D^.6F_N>H_/FJ ONL ONL ?NM!!ONM
!!N>O!!?JR"ONS!!?JR!!?BS"OFT"OFT!!.>R!!>.U!!N"P_.VJ_NNG_NNG_.NG_>RH_>JH_NBH_NBH_^FG_.JH_NNH_^RI_NNH_NNH^>ND^.FE_NNH N^L ^"M N^L
 ^"L!!N.O!!N.R!!N.R!!N.R!!N6Q!!^:R!!^:R .2P N*N^^NG].BD[-->Z-%;ZM]9[M%<[M-=[]1>\-2@]]:B^M>D^]6C]]%?\-Y<\-I;\-E=\=J@]]RB^M^E]=&F
]]&C]]&A\M!!?\M%=[-%9[-)7[]%6[]Y9[]Q9[-I<[MU9[=!!<\--?]]:B^^JF^>RH_NVI N&M .&N!!N.P >2O N.M_^.L^>.I^N*H]^^E]N&A]^*B]^2D]>:F
__JJ_?RL ONL /JL ^>N ?FP ?FP >:P >:P!!^:Q!!.>S!!.>S"^:R!!>2P .&M N^K N^L ^VM ^NP .FO_.BK_]>H_M:G^=>G^=>G_NBF_^FG_NNH_.NG_NFE
_NBF_>NK NRL_>NK ^VK!!N"N >*Q!!N.R!!N.R!!N.R .*Q .*Q .*Q >.R ^.O_."L].NF\M6@Z-]:[M%<[]1>[-->\M)>\=2@]-6B^]6C]]2C]M.B\=U>\]M<
[=E<\MI?\MN@\]U?\]U=\]U=[=Y;[=Y;[-]:[]Y7[]Y7[]Q8[]I6[]E7[MM8Z=I7[]Q9\=)?^M>D^>JG^>JG^.FF_NNH_>ZJ N&L N.M_N2J^.2J]>.H]^&D
\>*B\>*B\>*B]N6F^N>I_OBK_/FL_/FL_>>M_>6L_.2M_>*L_>&M N&M ^&P >*Q"N6Q"N6Q!!>2P!!^2Q!!>.S!!."U!!^NU >FU .FO M>M_-6K^-2G^].F^].D
^]6E^=>G_]>J_M:K^=2K_M6L_M6N_M6N_]:M NFP ^VM ^"O >*Q!!N.R!!N*T!!^.U!!>6W"N:X >2P >2P_."L^NJF\M)>[=%=\M9?\=6A]M6A]]2A]]2A]-6D
]-6D]]6D]]%?\-Y>[]Q;[MI<[MI<[MM:[MM:[]Q9\]U;\]U=[=Y=\MZ@[=U?[=Y=\MQ:[=M9\MQ<[MA8[-I:\=]?]]&A^]6E_NBH^=>G^.FE^>RG_^ZI_N*I
^>.I^^.I]>.F]^2F]^2F]^2F\>2E\>.G]N.G]>.H^.2L^>6M N:M_^.L_N*K_."L_.ZM_.VL_.RN_>VO .ZP >^O!!N"P!!^&Q!!^&S!!."U!!.RV!!^FT!!.FR >BP
 ]:N M6L_]2J^=*F^M*E^].F^].F^-2I^=2K^=2M^-.L^]*K^-.L^=2M_NBJ_.JL NRN .ZP!!N"R!!^&S!!.*T!!>.U >*Q!!^2S >.R_>^N]-:E\-*A]M>A]]>C
^NFE^M>D]=:E]-6D]-:E]=>F]]2A\]!!=[]U<[MQ;Z=M:Z=M:[MM8[]Q9\-Y>\=^A\-"E\-^G\-^G\-"D]M"B]]!!>\-Z@[]E;[=M=\]U?\MQ>]M"B_NBJ_^FK
^.FE^.NF^>ZH^."G^^&G].*G]^2F].6G]^2H]^6I]^6I\>.I\."G]N"G]>&J_N.M_^.L^^^H^.RH^>VI^>NJ^]>I^M:J^=:K_M>O_M>M_^BM_>JO ^VO >VR
!!.VS!!>RT!!.FT!!^BS!!M>R >BP ]:M_]2J^-&G^-&E]=]=^-*A_]6F_]2H_M.G^=*F^=*F^-&E^].F^].F^=6H_^FK ^VO!!N"R!!^"U!!^"U!!>.S"N>V"N>V!!^6T
_NRK^M>F^.RL^^FJ^NBI^.JK_NJL^.BJ^M:H]=6G^M2F\-&@[]Y:Z-U5Y-Q3YMI1Y]M4ZMY7[]M=[=M=\]N@]MNB]-NC^MVE^]ZF^M^F]MVD\]N@[=I?[=M=
[-U:[=Y:\]);]->@_>NM_^RK_^ZJ^>&J^N*H].6E]^:D]N>D]N>E]N>G].>H].:J].:J].2K]^.J]N*I]>&G]>&G^^"I^>VI_NRK_^FK_M:K_M.I^M*G^M*G
^=*H^=*I_-.K M2O -6P!!M>R =:Q -6P -6N =:N -6M_=*J^-^F^MVD]]^D]]^B]]&A]=.A]-*@]]&A]]&C]=*G]=&F\=VB]MZA^-2E_^FK_>JO ^RR ^RT
 .ZN >*Q!!N2S!!>>X ^&R ^&P ^&R_.ZO_NRM_NRM_^NM_NJL^>FK^.BJ^-:H]=:E]M6A\M-=Z=%8Z]]6Y=U6Y-Q5Z-I9Z=E;[-E>\]JA]]RC^MVE^]ZE^]"F
^-&H^M^F]]^D]MZA\]U=[-U:\])=]->B_NBH_NNJ_.^K_.&K_N2J^>:I^.:I^_BH]?BI]?BI]?BI^_BJ^_BL^N>K^N:M]>6L^^.I^^.I^>*K_."L_>^N_.RN
_>FL_.BM_]>L^=6J_M.I^=*I^="H^-^G^=ZI^=ZI]-JE]MBC\=JA]]RB]-VA]MZA\=VB\-RA\]N@\-Q?\=]?]M"@]]&A]]&A]-*D]=*G]=&F\-Q?\=U>]-"A
]=.C^]6G^=:L^=:L_^FI_>ZM >*Q!!.:W .*S!!N.R >.T >&S ^^Q NZP NZP_.RN_^NM_>NM_.JJ_^RK^>RH].FC\]>@[=5>[M);Z-U7Y-M6Y=E7Z\=9[L=<
\-E?]MNA]=RC^MZB^-VF^]ZF^-^F^]"F]MZA\MQ<[-U:[=!!<]]2A^.FF_.^K ..N >:P ^>N OBN _FO_OBK^>>J^>>J^>>J_OBM_OBM_OBM^>>L_N:L_N:L
_>:O N6P >.R >*Q >^Q .ZP NJM_>FL_-6K_]2J_M&I^="H^-VF^]RE\\>A[,5<Z,19Z,17Z,98Z<=9Z-A<Z=E=[-A=\MI=\=V@\=]?]M"@]]&C]-*D]-&F
]=&D\=V@\-Q=\=U>\=U>\=^A]]"E]-&F^M2F_NBJ NZP .&P .&P!!^.U ."R ."R >&S!!^&S!!N"R >^Q ^VO ^VO ^VM_>ZK_NVI^NJF].FC]^BB\=:@\]1>
Z]!!:Y=Q7ZMA7Z,98[\=:\-E=]]M?]=VA_MRF^-VF^=ZF_]*I^-2G]-*D\=]?\M]>\=)>]=:B_^RH >*O!!.6R!!.>S!!.>S!!^:R OBN_>>M_.:L_.:L_>>M_^>M
_^>M_N:L_^>M_>>M N>P ^:Q!!N:R!!^6T!!.6T!!.2V!!.*T!!^^R >VP .FO M>M_-.J_M&I^-VF^MRG]]JB\L==[L99[L99Z<=9Z-A:Z=E;[=E<\-Q?]MZA]MZA
]M"B]-*D]-*D]M"B]-"C]MZA\-Q=\-Q=\-Q=\-Q?\]U?\=^A]MZA]=.E_NBJ^.FH_.VL!!^&S ^VO >^Q!!^&S!!^&S!!^&S!!N"R!!N"R >^Q >^M_>ZK_^ZJ^>RH
^NJF]]>C]]:B]]:A\M9?[]];Z]E8Z,98Z<58[,59\]A<\=M<^MNC^MNC^]RD^="G_M.G^-2G^].F^M2F]-*@^M2B_NBF ^VK!!^&O"N2R"^6U"N2T!!^:R!!N6P
 .6O ^2N_>6N_>6L_.:L_^6K_.:L_.6N_>:O N6P >6Q!!^>U!!>>V"OBW"N>V"N2T!!.*T!!."S!!NZQ >JP M>M_-6K_-&J^=ZG]=RC]]M?]MQ=\=M<\]M>\]M>
\MI=\=V@]]^B]]^D]=&F]=.E]-*D]M"B]-VA]-VA]MZA]MZA\=V@\]M>\MI=\MI;\]N@]MZC]-*D]-*B^=>G ^VO ^NN >VP!!NZQ!!NZQ!!NZQ >^Q!!^&S!!^&S
!!^*N ^"M N^L_.ZM_NRK]=>F]]2A]]2@]M:B\M%=Z=I9Z<58Z<)8Z,%5Z<)6[\18\L9:\-A<]-R@^M^C^M^C^]"D^=*F_]2H^]6E^]6E^]6E^=>G NRL!!N"P
!!>.S"^6U".2W"N2T!!>.S!!N.P ..O N.M N.M_.2K_N.L_^2M_^2M_.2M_>2O ^:Q!!N:R!!^>U"OBW"OBW"N>V"N>V"^6W"N2V!!>&V!!^^T -6N_=2K_M*F^=&C
^-"B^MZ@]-Q>]-R@\-Q?\=V@]MZC]-"E]=&F^M*G]=.E]]&C]=ZB^M^E^M^E]]^D]MZC\MI=[-A;[-A9[<9=\]N@\=V@\=]?]=.C_M:I_M.I_=:L .FO NJO
 NJO ^NP .VR >ZS!!N&M .&N .&P N"O_.ZO^.JI^M>D]=:B]=:C]]&A\]M>\]A>[,5;Z,%7ZL)7Z\-6Z,15[\=8\]M<]MQ=]]R@]=VA^-"D_M*F^-2G^-2G
^-2G^-:F_NBH NRL!!N"P!!>.Q">*X">*X"N*U!!.*T .&P N&M_>*L_>*L^>*K^>*K_N.L_^.L_^*M_^*M_..N_>2O"OJV"OJV"_NY"/JY"_FX"^>Y!!>6W!!>.U
!!^^T .RQ NJM_.BI_]6F^-*C^M"A^M"A^M"A]-VA]MZC]-^F^M&H^M*G^M*E^M*C^]"F^=*I^-&H^]^I]-^F\=VB\MI=\MI;[,1>\-F@\MI=\-Q=]MY?]]^B
]MNA^M^E_]2J_-6K_M:K_.BM_>FN_>JO .^K .&M .&P N"Q_.ZO_>ZM_^RI_NFE_]>H^-2E^]"D]=ZD]MNA[<9<Z<5:Z<9;Y<93ZL12ZL12Z\-4[\56\\=9
]-I?^MRA]=&F^].H^=6H^=>I_NBH_.JJ N^L >*O".^W">"X".&W!!."U >^Q_>ZM_.^K_."L^.&J^>*K^>*K^>*K^>&J^.^J^.^J^>"K N6P ^:Q ?BS!!?FW
"_FX"_FZ"^>Y"N:X!!.:Y!!N2W ."R .ZN_>NI_]>H^-2E_M2E_M2E^]"D]]^D]="G^M&H^M*G^].F^-2E_M.I_-6L_].M^=&K^]*K]="G]MZA]MZA\L1?\-F@
[\=:\]M<\MI;\MI=[=A?\-NB]]ZE]=&F^].H^=6J_.BK NJM NRL ^VM .ZN .ZN >^O >^O NRL_^FI_=>H M>K_=:L_]2J^=*H^M^E]-VA\=M<\]N@[\=<
Z,98Y\%1X,Q-Y<]0[<57\=E=]-"E]MZC^]"F_-.J_=2K ]2L"NFQ".NS".VV".VV">ZV">"W".&U!!."Q .RM_>NK_^ZJ_.^K_.^K_NZJ^>VI^NVH^NVH^NVH
].NF^>"K >6Q!!?FU"_FX"_FX"/FX"/FX"_FX!!>>V!!.6T!!^.U!!.*T!!NZS ^NP ^BN_=:L_M.I^=*H_M.J_M.J_M.J_]2K M:P_]>L_]>L_]>L_]>J_]>H^=6F
^-2E^M.A]-NC]MFA\=B@]MFA\=B@\,=?\=JA\=JA]MNB]]RC]-VC^M^E^=*H_-6K_^BM_>JO NNP NNP NNP ^RQ ^RQ ^RQ ^NL ^NN NJO_>FN_.BM_]>L
_M:I^-2E^]6G]]&A\=]?\]U;[]E7[L97[L15Z\]3Y\]4\]N@]-VC]-VC^="G_-&I M.K".NS#N^X".VU"NVT"NZR!!>ZR!!^^P >VN_>NK_NNJ_NNJ_NRK_NRK
^>VK^NVJ].NH]^JG]^JE].NF^.RH_."L!!N2S!!>>V"_BW"_BW"OBW!!>>V!!.:U!!.6T!!>.U!!^&S >VR ^NP ^BN_=:L_=:L M>M_=:L_M.I_M.I_-6K_=:M M>N
 ^BN .FO .FO ^BN_=:L_]2H]=ZD]-VC]MNA]]RB\-E?\-E?\=JA\-F@\-F@\]A?\-F@]MNA]-VC^M^E^-.J_->N .NR >RS .NR ^JQ .NR .NR NJK NJM
 NJM NJO NJO NJM_.BK_M:G^=>E]-6B]M-?]]2@]]2A]M!!>[\=8Y<Y2W[=*ZL)5[L99[,59]MI>]=VA_]&F!!>NP">ZV"NVT!!.NR >JN .FM_>FJ_>FJ_^FI
^=>G^=>G^^BG^^FH^.JI^^NI]^JG]NFF]NFD\->B\=6A]]>E^>VK ^&P!!^6T!!.:U!!/BT"OFU"OBW!!.6T!!^2S!!.*T!!N"R .ZP >JQ .FP .FP >JP .FO M>K
 M>K ^BL ->N ->N >BO!!NFQ!!NFQ!!NFQ >BP ->O_M.I^-&G]=ZD]-VC\=J@\=J@\=JA\-F@\-F@\-F@\-F@\=JA]MNA]MNA]MZC^].H_>FN ^NP .RQ >VR
!!^^T!!."U ^NL >VP >VP >VR .RQ .RO ^NN NJK^^FB]]9?\=1=]M5>]->B]-6B\-Y>[\=:Y<-5X\U/X<U0Y<%4Z<)6[,59]-VA_].G ->N!!NJN!!NNO .FM
^=6H]=&B]=&B]=.C^].D^].D^M2D]=:E]=>F]>FG]>FG]^JG]]>C]M:B\=6C\-2B\=6C]=>F_NRK N"O .2P!!.>S!!?BT!!N2S!!N.R!!N.R!!N"R .ZP!!^RS!!NNR
 ^NP ^NP NJM_>FJ NJK ^NL >NL .JK ^BL ^BL ^BN .FO .FO .FP_>FL_]>J^].F^M*E]MZA]MZA]=ZD]-VC]MNA]MNA]MNA]MNA]MNA]MNA[=E:\]M<
\=U>]MY?]]^@^M*C^=6F_M:G NJK .RM!!NZQ!!NZQ >VP!!NZQ!!."Q!!>&R!!^:O!!N6N ..L_>*J N&L_.VJ_^FI^-:H^=>G[=M;ZL14ZL14Z\-4Z<56[=E:\]M<
^M^C_M.G ^BL_>FL^=6H]-"A\-Y>\]U=]MY?]]^@]]&A]-*B]]2C]-6D]-:E]=>F]M2C]]6D]M2C\-*A[=]>\M!!?\=.D]=>H^>RH_>"L ..O .&P ^"O ."R
 >^Q ^VO!!NVT >VR >VR .RO NJK_NBH_NBF_NBF_^VF_NNG^>JF^>JF^>JG_NNH_^RK_^RK NJM_>FL_]>J_]>J^].F^M*E^-2E^M*C]]^B\=V@\=V@\=V@
\=V@\=VB\=!!<\=!!<\-];\-];\=!!<]M%=]M%=\=!!<]-"A^=6F NJM .RO >VP!!NZQ!!."Q!!>&R!!.>R!!?BS!!?BS!!?BS!!.>R >*O .ZN .ZP ^"O N^N]=.C[-I:
\]U=\]U=[]E9[-I:\-Q=]]^@^].D_M:G_]>H^-2E]M"B\MQ>[=M;\]U=]M"@]]&A]]&A]]&A]-*B]=.C]M.B]M.B\=*A\]!!?[=Y=[=U?[-Q>[=U?\-&@]=:E
^.FH^>FK_.JL NRN ^RQ NNP!!NZQ!!NZQ!!NZQ!!NZO .ZN NRL^>JG^.FF^.ND^.ND^.ND^>RE_NVF_NVH_NVH^>RG_^FI_.JJ_.JJ_>NK_NBH^-:F^-:D^M2B
]-*@]M"@\=]?\=]?\=^A\=^A[=Y:\M];\]!!<\-%=]M-?]]2@]M-?\-%=]M]=^M*C_M:I_>FL .RO!!NZQ!!^^P!!^"N .&P!!N2S!!^:R!!?BS"_JU"_BU"^6S">6V
 ^"M!!^2Q_^RI]M.@]-6B]-6B\]!!=[=Y;]MY?]MY?]]^@^].D_NBH_NBH^]6G]]&C[=Y=\M]>\=]?]]^@]-"A^M"A^]&B^-"B]=.C]]&A]M"@\=]?\-Z@\]U?
[=M=[]E;[-I:\]U?]M"B]=.E^]2I^=:K_^BM_.FO ^NL .RM >VN!!N"P!!^&Q >*Q ^"O_>ZM^>JG^>JF^>JF_NNG_NNG_NNG_NRE^>ND_NBH_NBH_NBH_.JJ
_NBH^-:F]]2@]]2@]M.@]M.@\=)?\-&@\]!!?\]!!?\M%=\])>\])>\--?\=2@]]:B]->C]]:B]=.A]=.C]=.E]=.E^-:H_.JL ^VM .ZL ^^Q ."R ^&P >2P
"_BU#_FW#_BV#^>X"_BU!!^2Q!!N.P ^"M_^RI_NNH^.FF]-6B]]&A]M"@\=]?]]&A^]6E_NBH^=>I^-:H]M2E\=&C\=^A]MZA^M^C^-"D_M"E_]&F^M*C]=&B
]-"A]]^@\=V@\-Q?[=M=[-I<[\=:[-A;\]N@]MZC]-"E^M&H^=2K_]:M_.FG_>JH NNI ^VK >^O >*Q .&P N"O_>NM_.JJ_^FI_NBH_NBF_NFE_NFE_NFE
^>JI^^BG]=:E^M>F]=:E]-6D]=.A]]%?\=]=\=]=]M!!>\=]=\=]=\=]=\-Y<\]U;\MQ:\]U;\-%>]]2A]-6B]-6B^M2F]-*B]M!!>]M%=]=2@^=>E_^FI_^FK
_>NK_>NK_>NK .ZL >*O!!^2Q!!>:R!!>:R!!?BS!!^:Q!!?BS"_JU!!^:Q N&L N^K_>ZJ^^RF^NFE]->C]M6A]M.B]=.C^-:F_NBH^-2E^M*C]]^@\=U>\-Q=]]U>
]]U>]-Y?^=RD^-VE^-VE^MVD]]RB]MNA\]N@[-A=Z<=7[\=8[-A9\MI=]]R@^M^C^=*H_]2J >JN NJK_^FG^^BE^.FF_.VJ ^"O >^Q >^M >^M N^N_.VL
^>JI^.FF^.FE^>JF_NBH_.JJ^=>G^M2D]=.C^M2D]M!!>\-Y<\MQ:\MQ:\MQ:\MQ:\MQ:\MQ:\=]=\=]=\-Y<[=M9[MM8[MM8\M]<]M.@]]%?]=.A^M6A]--=
]])<]=2@^]6C^-:D^-:F^-:F^=>G_NBF_NNH_^RI_>ZK N^K >2O!!N6P!!.>R!!^:Q >2O!!^:Q!!^:Q N.M N.M_^ZJ^.NG^.NG^.FF^]6E^M2D^-:F^-:F^M2D
]=&B]MY?\]M<\MI;\MI;\]M<^]JB^-NC_MVE^]RD^]RD^MNC]MF@\\9=[L97[=E<\-Q?]MZA]=ZB^]"F_]2J M>M_]>J NJK ^VK_.VJ^>JG^.FF_^RK >^Q
 >^M!!N"N >*Q .&P N^N_.VJ_NNG^>JF_NBH_.JJ_NBH^=>G^]6E^]6E^M2B]]%?\-Y<\MQ:[-I8[MA6Z<=5Z<=5[MA6[-I8[=M9[-I8Z]A5Z]A5[]Q9\M]<
]M%=]=1>^->A^]9>]=1<]--=]=1>^M6A^]6E^]6E^-:F^-:D^^BE^>JG_.VJ N^L N^K .&M ..N ..N .6O!!OJS!!OJS N:O!!.>S ^*N_.^K ^"M N^L^.FF
^M2D]=.C^M2D^M2D]=.C]]&A\]U=\MI;[=E:[=E:]\5?]<>A^-JD_MRF_]VG_]VG^-JD^MBB[=E<\MI=]MM?]-VC]=ZD^]"F_M.I_-6K NJK_>NK N^L!!N.P
 ..O_>ZK_NNJ_.JJ >^M!!N"N!!N.R!!^2S!!^2S!!N.P ^"L_>ZJ_.JJ_>NK_.JJ_.JJ_^FI^=>G NRJ_NBF^M2B]]%?\-Y<[-I8Z<=5Z,94Z\53Z\53Z,94Z<=5
Z-E6[MM8[-U:[=Y;\]Y:\=!!<]M%=]])>]--?]--?]])>]M%=\-Y<\=]=\=]=\-Y<[=Y;\]!!=]]2A^M>D_NNG^>JF_NVH ^*M >:P /BQ _BQ _BQ!!.>S >2P
 >2P!!.6R!!^2Q N^L^.FF^M>D]=.C]=.C]-*B]]&A\=]?\MQ<[-A9[\=8\L5=\\9>]MFA^MND^=ZG_]"I_M^H_]VG\=J@\]A>\L==\]A>]-VC^-&G_]2J_]2J
^]6E]=:E^^BE_>"L!!^:R"N>T!!.6T!!>.S!!.*P!!^&O!!N.R!!.6T"N>V"N>T!!.6Q!!^2P >^M .ZL NRJ .ZL ^VK_>NI ^"M_>ZK_NNH^.FF]=:C\=)?[=Y;[]Q9
[=M9[]E7Z<=5Z<=5Z=I7[-U:[=Y;[=Y;\MQ<\]U=\]U=\-Y>]M"@]-*B]]&A\=]?\-%>\-%>\M]<[]Q9[]E7[-I8\]U;]]%?^M6A]-6A^M>C^>RG_.&K_.2M
_>:O _BQ!!N6Q!!^:R!!>:S!!>:S!!>:S!!.6R!!^2Q >*O_NBH^-:F^M2D]-*B]M"@\=U>\MI;[-A9[]A>[\9=[,=>\MF@\=RC^M^F^]"G^]"G]]^D\=VB\]N@\-RA
]]^D^M*G^].H^-2I^M>F^>JG^>RH^.NF^.NF_^ZJ >*O"N2T".:T"^6S!!.6T!!>:U"_BW"_BU"N>S!!>:R!!.6R!!.6R >*O!!N.P!!N.P .&N!!N.P .&N ^"M N^L
_.VJ^.FF]]2A\=)?]M!!>\=]=\]U;\]U;[=Y;\M]<\M]<\]!!=\-Y>]M"@]M"B]M"B]M"B]]&C]-*B]]&A\-%>\]!!=[=Y;[MM8[MA6[MA8\MQ<\=]?]--?^^BD
^^BD]M6@]->B^>ZH_>*L_^.L ^"M >*O!!N.P >*O!!N.O!!>:R"/FU"/FU"^6W!!."S ^NN_.BK^=6H^].F]=&D]]^B\-VB[=I?[-E>[-E>[=I?\MN@\]RA\=ZC
]MZC]]^D]]&C]]&C]]&C]-*D]=.E^M2F]-:E^>RH_NZJ^^RF]>JD^>RH N^L!!^&Q"N2R"N2R!!.6T!!>:U"_BW"/FV"N>S!!>:R"_BU"_BU!!>:S"N>T"N>T!!>:S
"N>T!!>:S!!.6R!!.6R!!N.P N^L_NNH^.FF^]6C^M2B]=.A]=.A]]2A]M.@\=)?\-%>\=!!<]]%?]=.C]-*D]]&C]]&A]]%?]--?\-%=\-%>\M]<[-U:[=M9\MQ<
\-Y>]M"@]M-?^>JF^.FE]M-?\=)>]=:B^^JE^>RG_.VJ_>ZK_>ZK N^L .&M!!^2P!!?BS"OFT#?F\#^>Z".2W"^"T!!.VQ >JN ^BL M>K_]2H^-&E]]^B\=V@
\-Q?\MQ>\MQ>\]U?[=M=\-Z@\=&C]].E]]2C]-6D^NBG^.JI^NBG^.NG^.VG_N^I_^"J_>"K N^L ^VM .ZL >^M .&P!!N.R!!.6T!!>:S!!.6Q!!^2P!!.6R"N>T
"N>T"_BU"/FV"_BU"/FV"_BU"_BU"/FV"_BU!!.6R .&N N^L NRJ_^FG^-:D^M2B]-6B]=:C]-6B]]2A]=1>^]:B^-:D^-:D^]6C^]6C^]:B^M5?]M-?\=)>
\]!!=[=Y;\MQ:\MQ<\]U=\-Y>]M-?^M>C^^BD]=:B]]2@]])>^M6A_^JF_^RI_NNH_.VJ ^"M!!N.O!!N.O!!N6P!!^:O#^2X#.6Y#>:Z#.6Y".&U!!>VQ!!^NO!!NJN
!!.JO =>L_=6I_].G^]"D]MZA\=V@\=^A\=&C]M*D]]2C]]6D]-:E]>BD]>FE^NJF^>NJ^^NG^^RF_N^I_^"J_^ZI_>ZK ^"O NRJ NRJ N^N ^"O ^"O ^"M
 .&M .&M ^"M!!^2Q!!>:S"_BU"/FV"N>T!!?JT"/NV"/FU"?BT#OFU"/FU!!?BS!!^:Q >*O_>ZK^>JG^^BE^]6C^]6C^]:B^>BD^NBA^^BD^^BD^^BD^>JG_NNJ
_NNJ^.FH^M:H]-2F\=*A\M]>[=Y=[-U:[]Q9[MM8[]Q9[-U:\-%>]=:C^.FF^>JG^.FF]-6B^^JE_^ZI N&M ..O >2P!!^:R!!.>S!!^:R"^6S">>U#/JX#_FY
#OBX".:V"N2T!!.*R!!.ZO >VN ^NL_>FJ_^FI^=>G^]6E]=.C^-&G_M.I_-6L_=6O_]2K_M.I_].G_-2F^-:F^^BG^.FH^.NG^.NG^.VG_N^I_^"J_."P_."N
_>^N_>^N N&M ^*N_>ZK_NNG_^RI_>ZK ^"M!!N.P!!>:S!!>:S!!N:R"_JV#ONX#/JX#/JX#_FW"/FV"_JV"_BU!!.6R .&N_>ZK_>NI_NBF^>BD^>BD^NBA^>ND
_^RH N^K .&N!!N.P .&P_>ZM_.RN_NNJ^^BG]=:E]]2C\=)?\]!!=[=Y;[MM8[MM8[-U:\-%>]]2A^^BE_NNH^>JG^>RG_NVH_^ZJ_.^K_>"L ..O!!^:R!!.>S
".:T#OBV#_FW#OBX">>W">>W">>W">>W"^.T!!>&R!!^^P >VN ^VM_>NK_^FI^=>G_M:I_=:L ^BN .FP .FP >BO ]>K ]>K_.BM_>FL_>FL_.JL_^FI_.JJ
_^RI_.VJ N^L N^L N^L_.^J_>"K_>"K_^ZG^>RE].U?]>Z@^^"B^.&C_^2F_^2F_.VL >*Q"^6U#N:W#?FZ#?FZ#/JZ#/JZ#_RY"/FV!!>:S!!^2Q!!^&O ^VK
_.NG_^JF^>ND_NRE_^RH_>ZJ .&N!!^2Q!!.6R!!.6R!!^2S!!N.R ^"O_>ZM_^RI^.FF^M>D]-6B\-%>[=Y;[-U:[-U:[=Y;\=)?^^BE^>JG^>RG^.NF^.NG^>RH
_NVI_>"L ..O!!N6Q!!.6R"N>T"_BU"_BW"_BW"/FX"?JY"?JY">6V"^.T!!>&R!!^^P >VN NRL_.JJ_^FI^=>G_M:G_]>J ^BN >JQ!!^JR!!^JQ!!^BP ]2M M.L
 M.L_=2L ]:M >BO!!^JQ!!>RS!!^"N!!N"N >"L_>ZJ_.VI_^ZG_NVF^.ND]^Q>].U?].U?]>Z@^N^A^N^A^-:H_NBJ_>NM!!^^R#N:Y#?F\$OJ]$OJ]#_RY#ONX
"/FV"N>T"N2R!!^&O .^K NVI_.ZG_^VF_NNG_NNG_>ZJ >*N!!>:S"_BU"_BW"N>T!!>:S!!^2Q!!N.P .&N N^L_.VJ^.FF]=:C]M.@\]!!=[-U:\M]<]]2A]=:C
^.FE^^BD^^BE^>JG_^RI_^RI_>ZK ^"M .&N!!^2Q!!>:S"N>V"_BW"/FX"?JY"?JY#/BY#^>X">6V"^.T!!>&R!!^^P ^VM_>NK_NBF^=>G^-:F^=6H_-6K ]:N
 >BP!!M>P"NBT!!=>S!!-:R!!-2Q!!].P!!M*O =&N =&N!!.RN!!^VN!!NRM NJK_.JH_NNH^>RG^.VG]]2A]-6B]-6B]]2A]]2A]]2A]-"C]=.E^M2F_NBJ!!NZQ".2W
#^>Z$/F]#?NY#?NY#/JX#OBV"N>T!!.6R >*N ^"L ^ZH NVG NVG ^ZH >"L!!..O"^:R"?BT">>U">>U">>U">>U".:T".:T"^6S"^6S .&N_>ZK_^RI^^BE
]]2A]]2A]=:C]=:C^.FE^^BD^^BE^>JG_NNH_NNH_NNH_.VJ_>ZK .&N!!^2Q!!>:U"N>V"_BW"/FX"/FX#_FY#_FY#^>X#N:W".2U!!>&R!!NZO .RM_.VJ_.JH
_NBH^-2E^].F^-&G_]*J_-.K =.O!!]6Q"NBT">FV#NJY".BW"-6U"M.S ]2M ]2M M6M_=:L_]>L^.BL^.BJ^.JK^-:F^]6E^M2D]-*B]]&A]-*B\-Q?\=^A
\=^A]]&C^M2F_NBJ >VP">*V#_FW#?NY#?NY#/JX"/FV"N>T!!.6Q!!N.O >"J .^I .^I >"J!!^*L!!..M"^:P".>Q"?BT"?BT">>U#OBV#OBV#_FW#_FW#_FY
!!>:U!!^2S!!N.R .&P_.VL_NNJ^>JI^^BG^>JF^.FE^.FF^.FF^.FF^.FF^>JG_^RI_>ZK ^"M >*O!!N.R!!^2S!!>:U"_BW"_BW">>W#OBX#OBX#^>X">6V"N*S
!!^^P >VN NRL_>NK_^FI^=6F^M*C]]^B]]^D]]^D^]ZE^-^F_]"H_-&J ]&M -*N =&P =&P =.Q ].Q ]2O M2O_=6O^=2K^]2J]-2I]]:A\=1?\M%<[-]:
[-]:[=!!;\MI=\MQ>[-Q>[-Q>[=U?\=^A^].F .FM!!N"N"N2R#OBV#/JX"?JW"/FV"_BT!!>:R!!>2N!!^*L >"J >"J >"J!!N&K!!..M"^:P".>S".>S".>S">>U
">>U">>U">>W">>W">>W"^6U"N2T"N2T!!^&Q >^O ^VM_^FI_NNG_NNG^>JG^^BE^M>D^^BE^>JG^>JG NRJ .ZL >^M >^O!!N"P!!.*R"N2T"^6U">>W#OBX
#_FY#_FY#^>X">6V"^.T"N*S ^NN NJM_]>H^-6C]=.A]]&A\=^A\-Z@]]%?]]%?]]^@]=ZB^M^E^-^G_-&J M.L -*N M.N M.N M6M_-6L^-&H]]^D\=VB
\=*A\]!!?\M]>\M]>\M]>\M]>\MQ<[=M;[MM:Z=M:[-Y=\M]>]]^@^-2E^]6C NRJ!!>.Q">>U"?JW#ONX"?JV"/FU".>Q!!>2N!!^*L!!N&K!!N&K >"H!!N&I!!..K
"^:R"^:R"^:R"^6S"^6S"N2R!!>.S!!>.S"N2T!!.*R!!.*R!!>.S!!.*R!!^&Q!!N"P NRL^>JF_NNG_NNH^^BE^M>D^^BE^.FF^.FF_.JH NRJ .ZL .ZN .ZN!!N"P
!!^&Q!!^&Q!!>.S"N2T".:V".:V">6V".2U"^.T">.T"^"V!!^RP_.BI^=:D^M2B]M.@\]!!?\MZ@[-]:[=!!;\]!!=\=]=\=U>]]R@]-VC]=RC^=ZG^=ZG_M^H_]*I
_M&H^MZB\=I>\-E=\,:A\,:A\<>B]-JE]=NF]]FD^-ZI]-RF]MNB\-RA\]RA\]U?\]^A\=*A]-*@^M6A^^BD_>^H!!^6N"_FR"?NT"?JV"?BR".>Q"N6O!!>2N
!!^*L!!N&K >"J >"J ..L >2M!!.>R!!?BS!!.>R!!^:R >2P >2P .&M >*O!!N.R!!^2S!!^2S >*Q >^M .^K_>ZK_.VJ_NNH^>JG^.FE^.FE^.FE^.JC_NNH_NNH
_^RI_.VJ_>ZK .ZL >^O >^O!!N"R!!^&S!!>&T"N*U"^.X">*X">*X">*X#N&X"^"V!!.VS .FO_.BM_M:I^-2G]=&D]=ZB]MZA\-Q?[=M=[=M=[]M=[-Q>[-R@
\-Q?\=V@\=V@\=V@\=V@\-Q?\-Q?\]M>[-A=\=J@]]RB^]ZE^]ZE_M&H_-&J_M^H^=ZG^]ZF^M^E^M^E]-"C]=&D]=.A]=2@]-6A^^FB_^VD .*K!!.:O"_BT
#OFS#OFS"?BR".>Q"N6O!!>2N!!^*L!!N&K .*K .*K >*N!!N.O!!N.O!!N.P >*O >*O ^"L ^"M .&P .&P .&P ^"O .ZL ^ZJ_.VJ_^RI_NNH_NNH_NNG_NNG
^>JF^>JF^.FF^>JG_NNH_^RI ^VK .ZL .ZN >^O >^Q!!N"R!!^^R!!."S"N^U"^"V"^"V"^"V".^V".^V!!>ZT!!^RR .RQ .RQ NJM_.BK_M:I^-2G]=&D]M"B
\MZ@\MZ@[=^@\M"A\-Z@\]U?\-Q?\-Q?\-Q?\-Q?\-Q?\-Q?\MI?\]N@]MNA^]ZE^-^F_M&H_]RF_-VG_]VG_]VG_M^H_M&I_M&I^="H^-:D^]:B]=:B]=>@
^NA?_NRC N"I >.L"OBQ"OBQ"_FR"_FR"_FR"OBQ!!.:O!!.:O!!N2M >.L .*K .&M .&M .&N .&N .&N ^"L N^L N^N_>ZM_>ZM_.VL NRJ NVI_NNH_NNH
^>JG_NNH_^RH_^RH_NNG^.FE^^BE^.FF^.FF^>JG_>NI NRL ^VM .ZN .ZP >VP >VP >VP!!.VS!!.VS!!.VS!!>RS"NVT"^ZU"^"V"N^U"N^U!!."U!!^^T!!NZQ
!!^^R!!NZQ ^VO_>NM^>FK^.JK^^FJ^NBI]].G\=&E\]^C\-VB\=VB]MZC]-VC]-VC\]N@\]N@\-E?]-NB^MVD^-^F]=B@^]JB]=JB^MND^]ZF_]*J_-*M_M*L
^-:D^-:D^^BD^.JC^>NB_NRC_.ZE N"I >.J!!N2K!!.:M!!>>N"OBO"_FP"_FP"_FP".>Q"^:P!!>2N!!^*N!!^*N!!N&M!!N"N >^M ^"L ^"M N^N_>ZM_.VL_NNJ
_^FG_^JF^>JG^.FF^^BE^.FF^>JG^>JG^.FF^^BE^^BE^^BE^^BE_NBF_NBH_^FI_.JJ_>NK ^NN ^NN ^NN ^NN >JP >JP!!NFP!!NFP!!.NS!!>RT"^ZU"^"V
"^"V!!>&V!!>&V!!."U"N*U!!>.U!!>.U!!^.U!!^.U >.T ^&R_>&Q_^ZQ_NRO^NBK]-2H]=*G]=&F]=ZD]-VC\MN@\MI?\]A>\=J@]]JA]MNA\=J@\=J@\=J@\-E?
\-NB]="G^]*I^]*I]=.A]-*@]]2@]==>^>NB_.ZE N"G N"G .*I .*I!!N2K!!^6L!!.:M!!>>N"_FP"/JQ"/JS"_FR"OBQ!!>>P!!.6Q!!N.O .&N ^"M N^K N^L
 N^N N^N_>ZM_^RK_^FG_NFE^.FF^M>D]-6B]-6B]=:C]=:C]=:C]-6B]=:C^]6C^]6C^]6E^-:F^-:F^=>G_NBH_]>H_.BI_.BK ^BL ^BN M>M ]:N ]:N
 ]:N >BP!!^JR!!.VS!!>ZT!!>ZT!!."U!!>&V!!."U!!.&V!!>*W!!.2V!!.2V!!^6V!!^6V!!^6T!!^>W >6U N"Q_.RN_.JL_M:I^].F^]"D\-VB\]RA\]N@\=J@\-E?\L==
[=I?[-E>[L=<Z<9;[L=<\MN@]M^D]M*F]]&A\=]=[=Y:\]%8]]5:^.I?_^VB_>^D!!N2K!!N2K!!^6L!!^6L!!^6L!!.:M!!>>N"OBO"_FP"_FR"_FR"_FR"N>S!!.6Q
!!N.O >*O N^K N^L N^N N^N N^N_>ZM_>NI_^JF^^BE]=:C]]2A]M.@]M.@]M.@\=*A\=*A]M!!>]M!!>]]&A]]&A]-*B]=.C^].D^].D^M*C^].D^-2G_M.G
_]2J_-.J_]*J_]*J^="H_M&I_-.K M6M .FO!!NNQ!!.VS!!>&V!!."U!!>&V!!>&V!!>.U!!>.U!!>6W"/FX"?NZ!!?FY!!/BX!!.:W!!N2U!!N*T!!N"R .ZP NRN^.BL^M.H
]]^D\]N@\]A>[-A=\MN@[-E>[MA:Z,98Z,96Z<=7[=M;\-Y>]]&A\=]=[=Y:\M!!7\-)7]-9;^.I?_NRA >.J!!N2K!!^6L!!.:M!!.:M!!.:M!!>>N"OBO!!?FO"OJP
"_JS"OFR!!?BS!!.>R!!^:Q!!N6P .&M ^"M N^N N^N_>ZM_.VL_.JH_^JF^^BD^M>D]-6B]M.@\=)?\-&@\]!!?\M]>[=M;\MQ<\MQ<\]U=\-Y>\=U>]MZA]MZA
\=U>\=U>]-Y?]=ZB]=ZD^]ZF^]ZF^]ZF^MND]=RD]=RD^]ZF^-&H_M.I M>M .FO!!^RR!!>ZT"N^U!!>&T!!.*T"^6U"/FX#_R["_FX"_FX"OBW!!.:U!!^6T!!N2S
!!N.R >*Q NZR_.FN^=6J]=&F]-"E]MZC^M*G]]^D\]M>[-A9Z<56Z,53[L=4\MM8\=]?\=]=\-%=\=-:]]5:]==<^.I?_NRA N"G .*I!!^6L!!.:M!!>>N!!>>N
"OBO"_FP!!?NP"ORQ"ONS"ONS!!?JR!!_BR!!N>Q!!N>Q!!^2P >*O N^N_.VL_.VL_^RK_^FG_NFE^.FE^^BE^M>D]-6B]M.B\]!!?[=Y=[-U<[]E9[]E9[-I:[-I:
\MI;\MI;[=E<[=E<[=E:[=E:\-I;\=I>\=J@]]JB]-NC]-NC^MND]-FB\=B@]MFA]MNB]]RB^M^E^=*H_-.K ]:M >JP!!^RP!!NZQ!!^&Q"N2T">>W#OVY"/NW
"OFU!!^:R ..O_>"L_.^K_^ZJ_.RP_.FN NNP ^NP ^NP^=6J^]"F]-"E]]^D\=VB[=I?[MA:Z\57Y<-5ZME2[MQ5\M!!7\=-8]-=:]>E<^NQ>^^U?^>2B_?BF
 N>H /FK >>J >>I"_NN"/VM!!?NP!!/RS!!/RS!!/RU!!_NT!!/BT!!?BT"N>T!!^2S!!^2S!!N.R .&N N^L_^RI^>JG^>JG^.FE^M>C]-6A]]2@]M-?\-%=\M];[=Y:
[=M9[]E7[]E9\MQ<\MQ<\MQ>\MQ>[-I<\=E=\=E=\=A?\=A?\-E?\]A>\-E?\=J@]L>B]L>B\<9?\\1=\,5>]-FA^MNC^MNC^MVD_M&I_-2N_>BQ .VS!!N*V
!!.:U!!.>S"/NV"?RW#OVY"/NW!!N6Q_.^K_NVI^>RH_NBJ^-:H^=6H^=6H^=6H^M*E\-Q?\-Q?\=V@\-Z@\]U?[MI<Z]A7Y<95Y\9/ZME2[]U6\]%8]M19].A<
]>M>^NQ?_^2E N>H _BJ ?FN!!_FN >>J!!/BL!!N:I"_VR!!?VR!!?VT!!?VT!!/RU!!?JT"OFU!!?BT"_BW"N>V!!>:S!!>:S!!.6R!!.6R!!N.P >*O N^K_^RH^.FE^^BD
]-6A\=)>\]!!<\M];\MQ:[-I8[-I:\]U=\-Y>]]&C]=.E]=.E^]"D^M^C]]R@\=J@\-E?\-E?\-E?\]A>\,:A\=B@\,=?\\9>\\9>\=A?]]JA]=RC]=RC^M^E
^-&H^]*I^=:K_.RN .*Q!!N6Q!!.>R"_JU#_ZZ#/^[#OVY"OFU!!^:R ..O_^NM_NBJ^=6H]=&D]]^B\=V@[=M;\MQ<\MQ<[=Y=[=Y=[MU9Z-M7ZME5Y\91ZME4
[]Q8\-);]-9?^.JC^.ND^.ND^>^B_^&F_>*J!!_BP"_RT"?ZV#_^U"?VS"ORQ!!/RQ!!_NP!!ORP!!/RS!!/RS"ONU"OFT"/FV"_BU"N>T"N>T"/FV"/FV"/FV".:T
!!>:S!!^2Q >*O ^"M_^RI^M>D]M.@\]!!=\-Y<[=M9[-I:\MQ<\-Y>]]&A^]6E^=>G_.JL_^FK^-:H]=&D]]^B]MZC]MNA\]A>\,=?\,=?\\9>\L5=[<1;\L5<
\,=>]-NB]=ZB^M^E]=&F]=&F^M2F^.FH_^ZJ N&L .6O!!_BR"_NW"/RX"?VY"/RX!!?FU!!N:R!!^.U!!N"R NRN^-2G]-"C]M"B^M>D]=:C]-6B]M6A\=2@\])=
[-%;[M]9Y=I4Z]I5[MM8\]!!=]=.A^^BE^>JF^.NF_.^H_>"K_.^J ^*N!!^:R!!.>R"OFR!!?BQ!!ONM ?JL _FM _FM _FM /JN!!OJO!!/FQ"_JV"OFU"OFU"/FV
#ONX#_RY#?NY#/JX#ONX"?JW"?JW"/FV"_BU!!>:S!!N.P .&N^=>G]-*B\]U=\MQ<[=M;\=]?^]6E_NBH_NRK_>^N N^N_>NM_NBJ^=6H^-&E]-VA]MNA\-E?
\L==[<9<[,5;[\1:[,5;\]A>\=I>\=V@]MZA]M"@]M"@]M.@]]:A]>BC^NNE_N^I N*N ^.O!!N:R!!?FU"OJV!!?FU"N>V"N2T!!^&Q NJK_M:G^]6E_.VJ_NNH
^^JE]>BC]]:A\-5?[=)<[M]9[M]7Z=Y8[MU9[=Y=]M"B^M2D^-:F^M>D^^BE^>JG^.FH_^VL N"O >2P"OFT"ONU!!_RN!!ONM OBL_N>J_N>J_.:J_.:J_>6J
 ^2N >2O!!^:Q!!?BT"_BU"/FV#/JX#?NY#?Z[#?Z[#/VZ#/VZ#/VZ#/VZ#/VZ#_RY"?JY >*Q^>JI]M.B\M]<\]!!=]]2A]=:C^.JI_>^N!!N.R .&P .ZN .RM
_>FL_]>J^=*F]=ZD\=J@\-E?\L==[,5;[\1:[,5;[\=:[-A;\]M<\]U;\-Y<\]!!<\=)>\=1?\-5?]>JD_NZJ_>&M ^.O!!N:R!!^>S!!/BT"_BW!!>:U"N2T!!."Q
!!NZO NRL >*O .&M N&L_>"K_.^J^^RF]M>A\]1>[]-8[]!!:[]Y:[]M=\MN@\-Q?\-Y>\=]?]-*B^]6E^-:H_NJL_.VL_>^N!!^:R!!/FS!!/RQ!!ORP_?JM__BK
^>:I^^2G^N.F^^&E^^RF^>ZH_>"K ^*M >*O!!^2Q".:V#OBX#_RY#/VZ$O^\$O^\$O^\$O^\#/VZ#ONX#_R[!!>:U >*Q_>ZK^.FF]=:C]=:C]-6B^.FF_>ZK
 >*O >*O!!N"P!!N"P!!NZO!!NZO ^NN_]>J^].F]-"C]MZA\]N@[-A=[L9;[\=<[MA:[]E9[=M9[=Y:\]!!<\=)>]]2A\=1?^NFD_>"L >2P!!^:R!!N6Q!!N6Q!!N6Q
"_BW!!>:U"^6U"N2T"N2T!!^&Q!!N.P!!N.P!!N.P >2O ..N_>"K^^RF]^BB[=98\M-;\M%=[-Q>[=E>[-A=[-A;[-A9[=E<\-Q?]MZA]=.E^M:H^^FH_^^K_.&K
 ^>N OBN_?FO__FN^>>J^^6H^N.F].&D^^^F^>ZF^>ZH_NVH_.VJ_>ZK!!N"P!!^&Q >*O!!>:S"/FV#_RY$O^\$/&^$/&^$_"]!!^2S .&P ^"O ^"M N^L_>ZK
_.VI_NNG_>NI ^VK!!N"N!!.*P!!.*P!!^&O!!^&Q!!^&Q!!NZO!!NZO ^NN_>FL_M:I^-2G]-"E\=VB[=J@[]A=[MA8[]E7[MM7[-U9\M]<\-%>\]!!<\=)>^M>D_>ZK
 >*O!!N.P!!^2Q!!>:S!!.6T!!^2S"N2T"^6U"^6U!!.*R">>U"N>T"N>T"N>T!!?BS!!N6P ^*M_^"J^N^A^NZC^^JF^]6G]-"E\=VB\-Q?\-Q=\-E=]MM?\-Q?\=^A
\=&C]M2C^NFD^NNE^^^F^>.I_N:L_/JO__FN^>>L^^6J^N.F^>&H^>ZF^NNE]>BC^M>D^M>D^=>G^=>G_NNH_.VJ_>ZK ^"M!!^2Q"?JW$O^\$/&^#ONZ!!.6T
 ^"O_.VJ_NNH_^RI_.VI_.VI >ZK!!N^L!!.&O"N.Q"N2R!!>.Q!!^&O >^M!!NZO!!."Q!!>&R!!^^R >VP ^NN_.BM^=6J]=*H]M^D\]U=[-U:[-U9[-U:[=Y;\M]>
\-%=[=Y:\M]<]]2A^.FF_^RI ^"M!!^2Q!!>:U!!>:U">>W#_FY#/JZ"^6U#N:W">>W">>W"_BU"N>T!!^:R!!N6Q >2P ^2L N&L_>VO_.FO_M6L^]*I]]"E\=^A
]]RC\=JA\=J@\-Q?\=V@\-Y>]M!!>]-*@]NA=]NI?\>Y?\>*B].6E^?BH_N>J_N2J^.:C^..C^>ZF^.FF^-:F^M2F]]2C\=*A]=.C^M2D^M2D]=:E^.FH_NNJ
 ^"M"_BU#/JX#/JX#OBV!!.6R ^"L_NVH^.NF^.NF_>NM .ZN!!^&O!!.*P!!>.Q!!>.Q!!.*R!!^&S ^"M N^L N^L .&N >*O .&P ^"O ^"O_^RK^>JI^M>F]M.B
]M"@\=]=\=]=\=]=]M!!>\=]=\=]=\-%>]M.@]->C^.NG_.^K .*Q!!^2S"_BW#?N[#/JZ#/V\#OBX#OBX#OBX"_BU"_BU"OFU"OFU"OFU!!_BP >2O ."R >ZS
 .NR_>BO^-6J^M2F^]"F^M^E]=ZD]=ZB]]^B]MZA]MY?]]^@\]!!<\])=[===[.I=\^Y>]^*B^^2E_N2H_N6C^>*D^>RE_^FG_]>H_]6F^-*C]]^@]-"C]-"C
]]^@]]&A]=.C]-6D^^BG N^N!!.*P!!.*P!!>.Q!!.6R!!>:S!!N6P N&L_NVH^-:H_NBH_^FG_>NI NRJ >^M!!.*R!!.*T >*O .&N ^"M .&N >*O .&P .&P .&P
 ^"O ^"O_>ZM_^RK_NBH^-:D^M2B]=.A]-*@]-*@]-*@]]2A]-6B^M>D^^JF^.NG N"O ^"O >*Q"N2T"N2T"_BW#_FY#OBX#OBX"/FV"_BU"_BU"_JV"_JV
"/NV!!?BT!!.2V"N.X"N&X!!N^T NRN_.JL^-2I^=*H^-&G^-&G^-&G^]"F^]ZE^]ZE]]R@]MY?\M%=[-1;[M=:[.M;]^"A^^2E_.6F_.*E_.ZG ^RI!!NRM >FK
 M2I_M"E^MZB]=VA]]M?]MM?\=V@\-Y>\-&@]-6D_^FI_NBF_^FG_>ZK >*O!!^2Q ..O N&M_>NK_>NK_.JH_NBF_^FG NRJ >^O!!N"P N^L_>ZK_>ZK N^L
 N^L N^N N^N ^"O .&P .&P ^"O N^N NRL_^FG^=>E^]6C]=.A]=.A^M2B^M>D^>JG^>JG^>JG^>JG .*Q >*Q >*Q!!>.S!!.*R"N>V!!^&Q!!.*R"N2T"N>T
"_BU"/FV"/FV"/NW"/NV"/FV"^>Y".6Z"^2Y!!>*W!!N"R NZP_.BK_]>J_M:I_-6K_=:L M6L M6L_=2L^=ZG]=RC\]U=[-]:Z]%5Y=)3Z>A7\NU<]>^A^NZC
^>ZF_.VI ^RJ >FK ]6J ]*H_]ZF^=RD^MRA]-R@]-VA\=V@\]U?\-Z@]-*B]=.C^M2D^-:F^.FF_^RI N^L ^*N!!^&Q!!N"P ^VK_^FG^=>E^=>E_NBH_^FI
^>JG^>JG_NNH_.VJ_.VJ_>ZM_>ZM N^N N^N_>ZM_>ZM_.VL_>NK_.JH_NBF^=>E]=.A]-*@]=.A^^BE_^RI_>ZK_>ZK_>ZK_^ZJ N^L .&N!!N"N ^VK .&N
 .&P .&P >*Q!!^2Q!!.6R"N>T"_BU"_BU"OFU"?JY#_FY".:X"^6W"^6W!!>6W!!N*T >^Q .ZP ^VO .RO >VR!!.VS!!^RR!!^RR!!M>P_=:L^].D]M6@[=5:[M16
Z=97[NE9[>I=\^NA]^VC^.VG_NNH_.BI ]>K ]6J =*K M&I_-^G_M^G^]ZE]=ZD\=V@\-Q?\=U>]M"@]=.C^M2D]-6D^M>F^.FF_^RI .ZN .ZL .ZL NVI
_.NG_^FG_NBF^=>G^^BE^>JG_^RI_.VJ N^L N^N N^N N^N_>ZM_>ZM_>ZM_>ZM ^VM NRJ_.JH_^FG]-6B]M.@\=)?^M2B_NBF_>NI ^VK >^M_>"L >*O
!!^2Q"N2R!!^&O!!^2Q!!.6T!!^2S >*Q .&N .&N .&N!!N.P!!^2Q!!.6T"_BW">>W"^6W"N2V".:X"N:X!!>6W!!N2S!!N.R >*Q ^"O ^^Q ."R >^Q .ZP .ZP_>NK
^.FE^NFB]NI?\^E=[^A;[M=:[.B@\NJ@]^VC]>VF^.NF_NBH_.BK ->N!!]6O =.M M.L_=*J^="G^]ZE^MVD]]JA\=V@]MZA]M"B]]&A]-*B]]2C]-6D]=:E
^=>G_.JH NRJ NVI NVI_>NI_^FG_NBH^.FF^>JG_^RI_.VJ_>ZK N^N_>ZM_.VL_>ZM_>ZM N^N ^"O >^O ^VK_.JH_NBF^^BE]]2A\=)?]]%?]=.A^]6C
_NBF_>NI_>"L N^L .&N!!.*P!!.*P!!>:S >*Q .&P_>ZM_.VJ_^RI_>ZK ^"M .&N ^^Q ^^Q!!N"P!!^&Q!!>.S"N2V!!.2V!!^6V!!N2U >6S .2R N*P N*N N*N
_>&M_N*K_.2M_^.J_N*I^>&F^>&F^."G^N^H].VF]^BB]>JD^NNC^NNC^^JE^=>E_-6I_=2K ]:N M6M_=2L_-.K_M^H^=ZG^=ZF^-VE]=&D]-"C]]^B]M"B
]]&A]M.B]]2C]]2C]=.C^-:D_NFE_^JF_^JF_^JF_NBF^-:F^.FF^>JG^>JG_NNH_^RI_>ZM_>ZM_.VL_^RK_^RK_^RK_.VL ^VM NRJ_.JH_NBF^.FF]=:C
]M.@]M!!>]M!!>]]%?^-6C_^BF_.^K_.VJ_^RI ^VK .ZL!!N.P ^"O_>ZM_^RK^>JG^.FF^.FF^>JG_.JH_NJL^=>I_NBH .ZN!!.*R!!^&S ."R .*S .2T >6S
 .>T ^:Q_>:P N>P_>>M_N:L^N6E^>:G_^6G_N2F_^.H_.2M_^*M^>"M_.VJ_.VI_.VI_.ZG_>RH_>JH M:J M.K_-2N_].M_-.K_]*J^=ZG_M^H_-&J_=^I
^].F^].F^-2G^]6G^M2F]]2C]]2C]-6D^]6E^=>E_^JF_^JF_.NG_.NG_.JH_.JJ^>JG^>JG^>JG^>JG_^RI N^N ^"O N^N_NNJ^>JI^.FH^>JI_.JJ_>NI
_.JH_.JH^.FF^M>D]]2A]]%?]M!!>]-%?^]2B_^BF^>RH_NNH^>JG_.JH_.JH N^L^NBG]=>F^M>F^M>F^M>F^-:F^-:F^]6E]=6G^-6J_M>M_.BK_^FG_>NI
_>ZM_>^R_>&O_..P_>2O_>:O_/BN__BK_OBK_OFI^_BJ]^:D\.:@\>=?].>E^.:I_>2O .2T!!N*T!!.*T!!."S!!>ZT!!.VS .RQ_>JO_^BN^^BE^M>D]-6A\-%=
\M];\=!!<]M!!>]]!!>]=.C]=.C^M2D^]6E^.FF_^RI_^RI_NNH_NNH_NNH^>JG^.FF^>JG_^RI_^RH_^RH^>JG^>JG^>JG^>JI_NNJ_.VL N^N ^"O .&N_.VJ
^.FF^-:F^=>G^=>G^=>I^-:H^=>E^-:D^]6C^M2B]-*@]]%?^M2B_^BF^.FH^^BG^-:F^=>G^=>G^=>G\=2@\--?\=)?\=)?\=)?]]%?]]%?]]%?]M"@]]&C
^M*G^].F^].D^-:D^=>I^>FN_^^M_N&N_>2O_>:O_/BN__FL_OFI_OFI^OFG]_FC\_A?[>=>\N:@]N6C^^6H_^>M!!^2S!!>.S"N*U">&U".^V"NVT!!.NS!!NFQ
 M>K_]>H^].D\=]=\]U;\]U;\]U;\]U;]]&A]=.C^M>F^.FF_NNH N^L .&N .&N >*N >*N .&M N^K_.VI_>ZJ N"I N"I_.VI_.VI_^RH_NNG_NNH_NNH
_^RI_.VJ_.VJ_.VJ_.VJ_NNJ^=>G^]6E^M2F^M2F]=:C]]2A]-*@]=.A]=.A]-*@]]%?]-*@]]2A\=)?]]%?]]%?]-*@]-*@\])=\]!!<\]!!<\]!!<\]!!<\]!!<
\=!!<\-];\]Y:\-Q=\=V@]-VA^M"A]=&B^].H^]2L^NJF^^ZI_^.L_>:O_?FO_?JM_?RL_?RL^_VE]?NC\/JA\OA?[.9=[>5?\>>A]?FD .6O >2O!!>.Q">.T
#N"U#^ZV">NU".JT"NBR!!M>P M.K^]^C]]R@\]M<[=M;[MM8[=Y=\-&@]-6B^^BE^.NG_.^K ..O!!^:R!!?BQ"OFR"OJP!!/BN!!N:L >6K >6K >6K ^.I ^.I
_>"I_.^H_^ZG_NVF_NVF_NVF_^RH_>ZK ^"M N^L_.JJ^]6E]-*B]]&C\-%>\M]<[=Y;\-Y<\-Y<\]U;[=M9[=M9[MM7[-U9\]Y:\-];\=!!<\=!!<[-Y5[=]6
[=]6\M!!7\M!!7[=]6[-Y5[]U4[MA0[L=5[,59[<9<\-A<]MM?]-VD]-^H].BD^^NG^>&J_>6N OBN_?JM ORO _VP_/ZJ_OZI^/VJ]/RH\?FE\/BB\>=?]_A>
^>:I_^6K .6O!!^2Q"^.T#N&X#^VW#^RV#>NX#NJW"M:S =.M^="G]MZA\MQ<[MM:Z=Q8[-];\])>]M6A]>BD^>RH N*N!!N>Q!!?NN"_VP"/ZQ"/ZQ"_VP"ORO
!!?NM!!_FK!!OBK >>J .:I ^6H N2I_>.H_>.H_>.H_>ZJ_>ZJ_>ZK_>ZK_>ZK_.JJ^-:F^M2D\-%>\]!!=\M]<[]Q9[]E7Z<=5Z<=5[MA6Z]E2[MQ5\MU7\-U8
\=Y9\-]9[-Y3[=]4\M!!5\]%6\]%6\M!!5[-Y3[MY2[]M0[]A5[,59\L5<\,=>]MI>]]RC]-RF]M6A]>BD^.RH_^"J_N*K_^6K_^>M_?FO /VN /VP _VR _VR
_/VO_ONK^_FG]>>C]^:E]>:H^.:K_>:O!!N6Q"N2V".&W">"W#>ZX#.VW#^NX".JV =:O^=*H\-Z@[MM:Z=Q8[MU9[]Y:[=!!<\=2@^^JE_.&K >:P!!/JM"ORO
"_VP"/ZQ"?^Q"?^Q"/ZP"ORN!!?NN!!/JM!!OBK .:I ^6H ^6H .:K .:K .&M N^K_.VI_>ZJ N^L ^"M_>ZM NRL^>JG^^BE]=:C\=)?\]U;[=M9[]E7[]E7
Z-I1[-M3[=Q4\MQ4\]U5\]Y6\M!!5\]%6\-)7]M19\=59\-18\M)6[-!!4[-Q1[]I6[L99[\1;[,-:[<59[<9<[<9=\MQ<\]!!?]]2C]>BD^NJF^NZG_N*K_>6N
 N>P _BQ ?JS!!_VS!!?^U!!OZT /RR_?FO].>F].>H]>:H^^6J_^2M ^.O >*Q!!^&Q"^^S".^V">ZW#NRV!!.FR_-6K]]^B\]U=[MM8Z=I7Z=I7[]Q9[=!!;]]:A
^>RG_>"K!!_FL!!/JM!!?NN!!?NN"ORO"_VP"_VP"ORN!!?NN!!_FL >>J ^6J N2I N2I N2I ^6J!!N6N >2M >*N ^"L ^"L ^"M .&N .&N >*Q ^"O_.VL^>JI
^.FH^M2D\=]?[-I:Z-I1[-M3[=Q4\-Y6\=]7\-]7\]%6\-)7\=-8\=59\=59\-18\M)6[-)5\]%8\-Y<\]N@\-F@\L==[<9:[,59[,5;Z<58[-A;\]U?\-&@
]M.B]-:E^^NI_^^K^^.K_N:N _FM ?NM!!_VQ!!?^U!!?ZW!!_RV_?JM__BK^.:I^^6J^.2J_^.L_>*L N&M .&M!!N"N!!>ZR"NVT!!.FR_=2K^M*C]M!!>\]U;[=M9
[MM8[MM8[-U9\]!!<]-6A^.FE ^*K >6K!!^>M!!^>M!!^>M!!^>M!!^>M!!^>M!!^>M!!N:L .2J ^*K_>"I_>"I_>"I_>"I >2M!!N6N!!^:O!!^2P >*N .&N .&N >*O
!!^2S!!N.R >*Q .&P ^"O_>ZM^=>G]-*B[-Y5\MU5\-Y6]M!!8]]%9]M!!8]]5:]]5:]-9;]]=;].A<]]=;\==:\-99\M)8\]!!=\-VC\-ND\-E?\L=;[,59Z<58
[\18\L=;\]M>\-Z@\MZ@\-"B]M2C^NBG\>&H^N2I__BI_/JG /NK!!_VQ!!_^W!!/^["?^T!!/RQ /JN_>>M_.:L_.2K N.K ^*K_^.H_.&I .ZL!!^RP!!NFP M6L
^=.D^]2B]-*@]M!!>\=]=\-];[-U9[=Y:\=)>^M>C^>RE_>"I >2M!!N6N ..L ^*K N*H ^.I >2M ..L ^*K N&J_>"K_.^J_.^J_.^J_^ZG N&J!!N6N!!.>R
!!>:R!!.6Q!!^2Q!!^2Q >.R!!^2S!!.6T!!.6T!!^2S!!N.R ^"O_.VL^]:@]M%;\-U8\=Y9]M]:]]!!;^M5=]==<]^E<]NM<]NU;]NU9]^U9]NQ6\NQ5\.I>\-2B\M!!?
[-Y7[-M3[-E7[L5<[L5>\L:@\]A?\=J@\]M>\]U=\-&@]M.@^^JE^>ZH_^.J_>>M_/FL ONN /VN!!O^P"/"W"_^V"OZW"_RV"_JV"OFU"N>T!!>:S .*S ."R
 ^VO NJM ^BL ^BL_>FL_]>J^^BD^NFD]->B]M5>\]5:\]5:\-99\^A:]->@^>VC N*H ^.I ^&H N"G N"I ^ZJ_.VJ_>ZK N^L_>ZJ_^RH_NNG_NNG_NNG
^^JC^.NF_NVH ^*M!!.6Q"N>S"N>S!!>:R!!>.Q!!^2Q >2P!!N6Q!!.>S"_BU">:T".*Q!!N^L^>BD]=>@]]9?[=!!9\-);]=1<]==<]>M>^N^@^N%?]>!!<].];]NY7
\>%;]N^B]NJI\->F\=1?\-);[=Y=[=JB[\9?[\9=[,5<\L==\MI=\MQ<\]!!?\=)?]]:A]>JD^^^F^.2J_N>J_/JM OVM ?ZO!!/ZT!!?^U"/"W"/"Y"?ZX"/VW
"_JV"OFU!!^6T!!^6T!!N.R!!N"P >VN ^NL_>FJ^=>G_^RH^.NF^NFD]>BA]^B@]^E>]^E>].I?^NRA^NRA^^VB_NZB_>&E ^.I N"I_^VF_NNH^>JG^>JG_NNG
_^RH_NNG^>JF^.FE^M>C^M>C^.FE_NNG N^K >*N!!.6R!!>:S".:T"_BU"N>T!!.>S"N>T"/FV#/FW#_BV">:S!!N&M_>^H_NVF]>BA^^FB^^F@^NI>]>M>]>Y?
^N%?^N2A^^6@^.:A]>>A]>:H^N.N]>"L]>ZG]^ND]M:D\]"E\-VC\MF@[=E>\MI?\=V@]M"@]-*B]]2C\]1>]M>A]NND]."F^^6H_OBK_/NK OVM /VP!!O^R
"O"T"/*X"?&X#O^Y"?ZX"?ZX"_NW"_JV"N>T"N2R!!>.Q!!.*P!!N"N N^L N^K_.VI^.NF^NFB]>BA].FA].I?].I?]NI?]NI?]^Q>^^V@_N"C_^&F_^^E_NVF
_NBF^-:D^]6C^-:D_^FG_^FG_NBF^-:D^]:B^M6A]=2@]-6A]=:B^>RH_>"L >2P"^6S"_BU"_BU"_BU"/FV#ONX$_V[%O^]$OVY"?BT"OBQ!!>>N .*I .*K
!!^6L .2J_^&D^N^@]>!!>].)?]>5?^^>A^ORB^ONH^_FM^^>N^.:K^^.I]>RG]NFH\=&E\-VB\MQ>\-Q?]]^B]-"A]=.C]-6D\=:@\]>@\.FB\.RB]N"E]>.F
^.:I^?BH_?RL OVM ?ZQ!!_"S!!?^S"_^V"?&X#O*Y#?&]#/"\#_ZZ#ONX"?JW"/FV!!>:S!!N6Q!!N.O ^"L_NVH^^JE^NFB].FA]M=?\=9>[]59[==9\.E;]NM<
].U?^^V@^>^D_N^G_^JF^->C^M2B]=.A^]6C^=>E^=>E^-:D^-6B^]2A]=2@]])>\-%>\=2@^NFE^.RH!!N"N!!N.P!!>:S"_BU"?JW#/VZ$?^]%_&_#?RX"/JS
"?NT#ORS"_FP"OBQ"/JQ!!?FO!!N:J ^6H_^:F^.:C^N:@].:@^OU?^_VC^OZJ^/VK^/NJ^?BH^.*F^NZE]=>H]-2F\=&C]M"B]]^B]-"A^M2D^=>G^NFE].FC
]NJC\^NA\.RB]N"C].*E^N2G^?BH__JJ_?NN _RO!!ORP!!/ZT"_^V"?&X"?ZX#/^Z$O&\$/&]$/&]$O^[#OVX"_JU"_BT!!.6Q ^"L_^ZI^>RG^.NF].FC]^BB
[=5:[M-5Z-%3Z=)4\M17]NA;^NRA^.ND_.NG_NFE^]6C]-*@]]%?]=.A^]6E^-:F_M2B^-6B^]2A]--?\]!!=\M]<\])>\--?^.FF_.JH >^M"N2R#OBV#?NY
#?Z[$O^\"/JS"OBQ"OBO"?NR"?NR"_FP"OBO"OBO"OBM!!?FM!!/JL /NI_/NH^?NE^_Z@^/^B^_"G^/VJ^?RK__JJ_^6G^>&F_^^M^>NJ^M>F]=.C]]&A]-"A
^]6G_NBJ_.VJ_NVI^NZG]>ZG]^^E]>*E^^2G^.6H^N6E^.>G__BK_?JM /JP ?NQ!!_NR!!/RS!!?BT"_JV#_RY#?Z[$O^\$/&^$_*^$O&]#?ZZ#ONW"_BT!!^:Q
 >2O ^*M_.&K_N^I^NNC]NA=[=-8Z=U1Z]M1Z=U3\]%:]]2@_M>D_M>D^-6C]-%?]M]=]MY?]-"A^].D^]2A^-6B^-6B]=.A]M!!>\M]<[=Y;[-U:\-%>]]%?
^-:D ^VK!!>.Q">>U#ONX#_ZZ"OFR!!>>N!!^6L"^>L"/BM"_FP"?BR"?BP".>O"OBM!!?FL!!ONJ_?RI__VG_O^E__"F_O"J^?ZK_OVN_/JO N:M N2I_N&L^>VI
^^JF]=:E]-*B]-"C]-*D^M2F_NNH_^RI_N^I^>&J^>.I_N2J_^6I_^6I^N2G^.6H_N>J_>>M OBN ^>N /BQ /BQ"_BU"/FV#OBV">>U">>U"?JW#_ZZ#?"\
$_"\$O^[#/VY#ONX"OFU!!.>S!!N6Q .2P ^&J_>^H_NRC]-9=\MU5[ME3[ME5\]Q9]]!!=]-%>]=*@]-%?]MY?\-Q=\=U>]MZA]])>]--?]=.A]=.A]-*@]M!!>
\-Y<\]U;[-U:\MQ:\=]=^]2B_.JH >^M!!^:R"_JV"_JS!!?FO!!.:K!!>6J"N:K!!>>L"N.N"^6M".:N"/BM"OJM!!_RK _VJ__VG_/ZJ_/"K__"M_O^O_ORR OJS
 .>R!!N6P_.2M_N&L_^ZJ_NNH_NBH^].F]=&D]]&C^M2B^M>D^.NF_N^I^>&H_N*I_N*G_N*G^>:I^>:I^>6K_.:L_>>M N:O ^>P >:P!!.6T!!>:U"^6U!!>.S
!!>.S!!>:U"?JY#_V\$?"\$_"\$O^\#/VZ"_JV!!.>S!!^:R >6Q!!..O!!N&K >"J .^I_>JE]=)?\]E7[\54[-E6\]Q9]M]=]]!!>]MY?\-Q=\MI=[=E<\-Y<\=]=
]]%?]-*@]=*@]=*@]]!!>]MY?\M]<\MQ:\]Q:\=Y<]-%?^-:D_.^K >6Q"ORQ"OJP!!>>L"N:K"N:K!!>>L >6I N*F ^.G!!^6J!!.:K!!/BL!!/JM!!_FL /NK /VM
 _VP ORQ ORS _NS!!OJS!!N>Q >2O ^*N N^L_.VJ_.JJ^=>G^M*C]]^B]]!!>\-Y<]-*@^^BE^^JF^.VG_^"J_>*L ^&P .*Q N*N ^.O ^>P .6O ^2L!!N6N
 ..N >2O!!N.P!!N.P!!.*R"^.V">6X#^>Z"/FV"?JW#/VZ#_ZZ"/NV!!^:Q ^2N N.K >VN .JK >NJ"NZN"NRM >BG_=&A^]M;\<56\\-4\,15\<=8]]E:]]M;
\=E9[<55[-A;[-A9[=E:\-Q=\=]=]M!!>]M!!>\=)?]]!!>\-Q=\]U=\-Y>[=Y=[-U:]M.@_NNG!!N&I#OFQ"N6M"?BP!!..K!!..K!!^>K ^.G ^&F .*G >.H >6I
!!OBK!!_FL!!ONM!!_NP!!ORR _NS _NS!!ONU!!OJS!!_BR!!^:R!!N6Q .&N_>ZK_>NK_^FI_M:G^=6H^]2B]]%?]]%?]-6B]->C^^JF^>ZH_^"J ^"M ..O ..O ^.O
!!N6Q!!^:R!!.6Q"^:R!!>.Q!!^&O >^M .ZN >VN!!^^P"N*U">6X">>W">>W"/FV#ONX#ONX!!?BS >2O ^*M >VN ^NL!!NRK!!.ZM!!.RL!!NNI .FG_=:D^-Y?]]E:
[<55[\-3[\-3[<55\L96[,14[L97Z<56[L97[]E9[=M9[=M9\MQ:[=Y;\]Q:[-I8[=M;\]U=[=Y=[-U:[=Y;\=)>]=>@_^VF >.L!!>>P!!.:O!!.:O!!?FO!!N2K
 .*I ^&H N"G ^&H >6K .:K!!.>P!!?BQ!!?JT!!_JU!!_JU!!/NV!!?JT!!/FS!!?BT!!.>S!!^2Q .&P ^VM_.JJ_.BK_.BK_NBF]=.A]]%?]M.@]]2A]->C^NJF^^RF
_^RI ^"M .&N .&N!!N.R"N2T#N2U#^6V#N.W"^"T!!^RP >NL .JK ^NL!!NZO!!>&R"^.V"N2T"^6U#_FY#/VZ#_RY"_BU!!.>S">:T!!>*P!!^"N!!^"N .VK NNI
_^BE^-6B^M.A\-U;\MA7[\54[L13[\54[,95[L13Z,15Z\-4ZL14Z,96Z<=7Z<=5[MA6[]E7[]E7[]E7[-I:\]U=\M]>[=Y;[=Y:[]Y9\--<\=1=_^ZG N&J
 >2M!!.>P!!.>P!!N2M!!N2M!!^*L ^&J .*K ..L N.K!!N.O!!^2Q!!>:S"OBW"_FX"OJV"ONU"ONU"OFU!!?BT!!>:S!!^2S!!N"P ^VM_>FL_.BK_^FI^M2D]=.A]]2A
]]2A]M6A]>BD^NFE^>JG N^L ^"M .ZN!!^^P".&U">&U#^&V$N"Z">ZV"NNS!!^NO >FK NBI_.FG_>JH >VP >VP!!."S".:V#/JZ#?NY#_RY#/VZ$ONY">:T
!!.*P!!.*P!!>.Q >*O_>ZK^>JG]-6B\=)?\=]=\]U;\MM9[=I8[<=6[L13Z,96ZL14ZL14Z\55Z\55Z\55Z,94Z<=5Z<=5[MA6[]E9[]Q;[=Y=\]!!=\M%<\M%<
\-5=\]1<^NNC^^RD_.&I >:N ^*M ..N!!.6Q"N>S!!.6Q!!N6P .6O N.M ^"M .&N!!^2S"N>V"OBW"_JV"/NV"_RV"OFU!!?BT!!>:U!!>:U!!>.S!!^&S .RO_>FL
_.JJ^-:F^]6E^M>D]-6B]]2A]->C^NFE_^FG .ZL!!N"N >^O!!^^P"^"T">^T">^T#>VZ#NRV">NU!!>JR >FM_=6G_M2E^=.B^-2G_M:I NJM!!NZO!!^&Q!!>.Q
#OBV#/VZ#?NY#_FW"N>T!!>:S"/FV"/FV!!?BT!!N6Q ^*N_>ZK_NNH^=>E]-*@]M]=\-U;[-E7[]E7Z<=5Z,96Z\55Z\55Z\55Z\55Z\55ZL51Z<=5[]E7[MM:
[-U:[=!!<\-->\=1=\]1>\=:@]M>A^NNE_N^I_^"J_N^I_>*L!!^:Q"OFT"OFT!!?JT!!_BR N:O_^.J_>*L ^.O!!N6Q!!.:U"OFU"_JV"_RV"/NW"OFU!!>:U!!>:U
"^6U"N2V!!."S!!NZQ ^VM_^FI_NBH_NBH]=:C]-6B]=:C^M>D_NBF_>ZK ^"M N^L >^O!!^^P!!>^P"^^Q#>VZ#^VW#NRV"^RT!!.FQ .BL_=6I_M2E]=&D^].D
^=6F_NBH_NBF_.JH ^"M!!.6R"N>S"_BT"N>T!!.6R!!>:S"N>T"_BU"?JW#ONX"_BU!!>:S!!N.P ^VK_NBF^M2B]M!!>\M]<[-U:[MM8Z-E8Z<=7Z\55ZL14ZL14
Z\92[MA6[]Q9[-U<[-U:[=!!<\])=\--<\M9?]^ND\>FB].RE^NZG^NZG^>&H_>*J .6M!!N>O!!_BP!!OJQ!!OJQ _FO^>>J^>6K_.2M ^.O!!N6Q!!^:R!!?FU"_NW
"?RX"_FX"_BW!!>:U"N2V"N2V!!>&T!!>&T!!N"P_>NK_.JJ_.JJ_NBH]=:C]-6B]M.@]]%?]-6B^M>D^NFE^>JG_NNH_>RH .VJ".JT#NRV".VV"^RU"NNS!!.NR
 >BO_=2K^].D]=.C]-*@]=.A]-6B]=:B^.FE_^RH^>RG_>"K ^*M ^"M!!N.P!!.6R">>W#/JZ#?NY#/JX#/JX#_FW!!>:S >*O_>ZK^>JG^M>D]-6B\=)?\]!!=
\MQ<[]E9Z<=7Z,96Z,=3[MA6[MM8[-U:[]Y:[]Y9[=!!;\]);]M>A^NNE]>JD^^RF^^RF_N^I_^6K_.2K_>6L ^2L_>6L /BO /JP_/BN^?RK^_BH^>6K_.2M
 ^.O!!N2S!!/BV"_NW"/NW"/JY"/FX"_BW"N2V!!.*T!!."S!!^^T!!^&Q NRL_>NK ^VM NRL^=>E]-*@\]U;Z=I9[]Q;[]Y:[=!!<\]1>\=1?]]9?^.JC -6N!!.FR
"NNT!!>JS!!>JS!!>JS!!M>P_=*K^-:D]-*@\-Y<\]!!=\=)>]]2@]M6@]M5>]^BB^.VG_^ZI_>ZK >*O"N2R".2U#N:W$ONY#?JX#?JX#_FW"N>T!!.6R!!N.P N&M
_>"L_^RI^.FF]=:C]]&A\]U=[-I:[]E;Z,=3Y<92ZL=4Z-E6Z-M7Z-M6[MU8[-]8\-5?]^BB^^RF^>ZH^.VG_.&K N"I .&M >*N >2P .6O N:O_N:L^.:I
 N:K_^.L^>"M_^^K_^"J^>&H_^6K OJR!!OFX!!/NZ"OJX"OFU!!>:S!!^2Q!!N"N ^VM_>ZM_.VL_.VJ_.VI_.VI^.FF]]&A\MQ<\MI;Z\-4Z\-4Z,94Z-E6[-];
[=!!<\])>^M2F_M:I ^FH >FI!!NBK!!->O!!-2Q!!].R^-:H\=^A\-Y>\=]?]M!!>]--?]M-?]M1=]-*@_NBF NRJ >^M!!>.Q"^6S".>S#OFU"_BU"?JW"?JW"/FV
"_BU"N>T"N2R!!.*P ^"O .&P N^N_^RI^^BE]-6B]M!!>\]U;\MQ:Z<=5Y<95Y<95Y,52Y<93Z-E5Z=M4[=!!9\--<]]9?^^JC^>RE_^ZG_.^H N&L ^*M ..O
 ^2N N:O_.:L^>:I^.6F^^.I^.&K^.&J^^&G].&B].*E^N2I_N.O_>:R ?BS!!?JT"_JU"OFU!!.6T >*Q ^"O_>ZM_.VJ_NNG^.FE^M>D]=.C]]&A]-"A[]E9
[MA8[MA6Z=I7[=Y;\]!!=\=2@]-*B^M2D^-2E_-:G ]>I .BL =:N -6N^=>G]M"@\=]?\=]=\=]=]-*@]M-?]-6A]=.A^-:D_^FG ^VK!!>.Q"^6S"^:R".>S
"_BU"/FV"?JW"?JW"?JW"/FV".:T"N2R!!^2S!!^2S!!N.R .&N N^L_^RI^]6C]M!!>\-Y<[-I8Z=I9[MM:Z]A5Y<93ZL=3ZMA1[MU6\]);\=1=]->@^NFB^>RE
]>JB^^RF_^ZI_>"L N.M .6O N:M_.:J^.>F^.:I^>6M^.2L^.6H]>2D]N.E]N.G]^^G^N*J N>P!!?^U"/"Y"?VY"OBW!!^6T ^"O ^"O N^L_.VI_NNG^>JG
_NBH_NBH^.FH]M.B\=*A\-%>\-Y<\=]=]M!!>]-*@^M2B^]6E^-:F^=>I_>FL NJK NJK NBG_NBF]-*@]M!!>\=]=\-Y<\=]=\-%>]]2A^-:D^=>E_^FG NRJ
!!N"N >^M >"L!!..O"/FV"/FV"/FV#ONX#_RY#ONX#OBV#OBV"?JY"N>V!!^2S >*O >*O .&N_>NI^]6C^M2B]M!!>\-&@\]!!?[]Q9Z-E6Z-E5Z-I3[MU8\M%<
\-->]M6@]]:A^^JE]^NB^^RF^>ZH_.^K N&L N.M_.2K_^.H^>:G^>6M_N.M^>*L^>*K^^2G]>.H]^&H].*G\>^D\>VC]^^E^.&J_..N >6S!!/BX!!N.R!!^2S
!!.6R!!^2P!!N.O N^L_>NK_^FI_NNJ]-6D]M.B\-%>\-Y<]M!!>]-*@^]6C]=:B^^BE^>FK_^NM NRN ^VM_>RH_^JD_>RH^]6C]=.A]]%?\-Y<\]U=\M]>\-&@
]]%?]=.A^-:D_^FG_.JH_^FG_>RH!!N&M_>ZK_.VJ_>ZK!!N.P"N>T"/FV#/JX$ORZ"N>V!!>:U!!>:U!!>:S"_BU"N>T!!^&O NRJ^]6C]M!!>\M]>[=Y=[]Q9[MM8
[]Q8[-Y7[MU9[-];[=!!<\])>\--?]]:B\.A?].FC^NNE^>RH_^ZI_.&K_^.J_N*G_^.J_^*O_."P_^^O_^^K^>&J^^"J]>ZJ]N"E\.ZC\>VC]."F^>*K_..N
 ^.Q >6U!!^2S!!^2S!!>:S"_BT"/FU"_BU!!>.S!!N"P N^N^>JI_NNJ^>JG^-:D^]6C]-*@]=.A]M-?^M>D_^RK_>VO NZP ^"M ^"L ^&H!!N&M_.JH_^FG^=>E
]=.A]-*B\-&@]M.B]]%?]=.A^]6C_NBF_^FG^=>E_^JF .^K N^L_.VJ_^RI N^L >*O!!^2Q".:T#_FW"/FX"_BW!!.6T!!^2Q!!.6R!!>:S"^6S!!>.Q >^M_NBF
]M.B\-&@\M]<[=Y;[-U9[-Y7[MU9[MU9Z=Q8[=!!<\M%=\])>[]!!8\M-=]M6@]->C^NNE^.VG^^^F^N"D_>*L_."N_.^R_.ZQ_.ZM_NZJ^^ZI^NVJ\>VE\.RD
\>JC]NRB]>VF^>VI_>^N ^&P!!>:U!!.6T!!.6R"N>S"/FU"?JW">>W"N2T!!N.R_>ZM ^"O .&N ^VK_>NI^=>E^-:D^M>D_NNH N^N >^O!!N"P!!."Q"N.Q"^2R
!!>.Q ^VK ^VK NRJ_.JH_^FG^.FF^>JG]=.A^M2B^]6C^=>E_.JH_NBF^>BD_.NG_^RI^>JG^.FF^>JG_^RI_>ZK!!N"N!!^&O"/FX"_BW!!.6T!!N.P!!^2Q"N>T
#_FW#/JX">>U >^M^>JI^M>F]]2A\-%>\M];[-Y7Z]I5ZME4ZME4[MU8[]Y9[=!!;') ; yourself]
! !

!WalkingGirl::AnimationView methodsFor:'display'!

repair:aRect
    "
    "
    |
     pWidth   "{ Class:SmallInteger }"
     pHeight  "{ Class:SmallInteger }"
     xNum     "{ Class:SmallInteger }"
     yNum     "{ Class:SmallInteger }"
     wNum     "{ Class:SmallInteger }"
     hNum     "{ Class:SmallInteger }"
     xPos     "{ Class:SmallInteger }"
     yPos     "{ Class:SmallInteger }"
     pattern
    |
    pattern := self class background.
    pWidth  := pattern width.
    pHeight := pattern height.

    xNum    := aRect left   // pWidth.
    yNum    := aRect top    // pHeight.
    wNum    := aRect width  // pWidth  +1.
    hNum    := aRect height // pHeight +1.

    yNum to: (yNum+hNum) do:[
        :yIdx|
        yPos := yIdx * pHeight.
        xNum to: (xNum+wNum) do:[
            :xIdx|
            xPos := xIdx * pWidth.
            form displayForm:pattern
                           x:xPos
                           y:yPos.
        ].
    ].
! !

!WalkingGirl::AnimationView methodsFor:'initialization'!

initialize
    "
    "
    super initialize.

    self sampleGirl.
! !

!WalkingGirl::AnimationView methodsFor:'processing'!

animationLoop
    "
    "
    [
      self animationStep.
      Delay waitForMilliseconds:100.
    ] loop.
!

animationStep
    "
    "
    girl animateStep.

    self repair:girl damage.

    girl displayOn:form.

    self invalidate.
! !

!WalkingGirl::AnimationView methodsFor:'redrawing'!

buildForm
    "
    "
    form ifNotNil:[form destroy].

    form := Form extent:self extent 
                  depth:device depth 
               onDevice:device.

    form clear.

    self repair:(0@0 corner:self extent).

    girl displayOn:form.
!

create
    "
    "
    super create.

    self buildForm.
    self startProcess.
!

destroy
    "
    "
    process terminate.
    process := nil.

    super destroy.
!

redrawX:x y:y width:w height:h
    "
    "
    self copyFrom:form 
                x:x y:y 
              toX:x 
                y:y 
            width:w 
           height:h 
            async:true.
!

sizeChanged:how
    "
    "
    super sizeChanged:how.

    self shown ifFalse:[^ self].

    ((0@0 corner:self extent) intersects:self bounds) 
        ifFalse:[^ self].

    self buildForm.
!

startProcess
    "
    "
    process := [self animationLoop] newProcess.
    process name: self class nameWithoutPrefix.
    process priority:(Processor activePriority - 1).
    process resume.
! !

!WalkingGirl::AnimationView methodsFor:'samples'!

sampleGirl
    "
    "
    girl := WalkingGirl::Girl on:self
                              at:100@100.
! !

!WalkingGirl::Girl class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Martin Walser (martin@vercingetorix)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
    "
    Instance creation:
                                                                [exBegin]
    (WalkingGirl::Girl on:SimpleView new at:100@100)inspect.
                                                                [exEnd]

    Displaying:
                                                                [exBegin]
    |view girl|
    view := SimpleView extent:200@200.
    girl := WalkingGirl::Girl on:view 
                              at:100@100.

    view openAndWait.
    girl displayOn:view.
                                                                [exEnd]

    Animation step:
                                                                [exBegin]
    |view girl|
    view := SimpleView extent:500@200.
    girl := WalkingGirl::Girl on:view 
                              at:100@100.

    view openAndWait.
    girl displayOn:view.

    10 timesRepeat:[
        Delay waitForSeconds:0.5.
        girl animateStep.
        girl displayOn:view.
    ].
                                                                [exEnd]
    "
!

history
    "Created: / 6.8.2001 / 13:12:43 / martin"
! !

!WalkingGirl::Girl class methodsFor:'instance creation'!

on:aView at:aPosition
    "Create a new instance on a view at a position.
    "
    |instance|
    instance := self basicNew initialize.

    instance on:aView
             at:aPosition.

    ^ instance.
! !

!WalkingGirl::Girl class methodsFor:'walking left'!

walkingLeft
    "Picture Sequence walking to the left.
     Retruns an array of arrays with picture name and offset.
    "
    ^ #(
        ( #walkingLeft001 -20) 
        ( #walkingLeft002 -20)
        ( #walkingLeft003 -20) 
        ( #walkingLeft004 -20)
        ( #walkingLeft005 -20) 
        ( #walkingLeft006 -20) 
    )
!

walkingLeft001
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingLeft001 inspect
     ImageEditor openOnClass:self andSelector:#walkingLeft001
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingLeft001'
        ifAbsentPut:[(Depth4Image new) width: 73; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H @@@@
@"H"H"H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H@@@@@@@@"H"H"H"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"@@@@@@@@@@H"H"H"H"H"H"H"H"H"
H"H"H @"H"H"H"H"H @"H@@@@@@@@@@@@"H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H@H @@@@@@@@@@@@H"H"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H@@@
@@I&X @@@@@@H"H"H"H"H"H"H"H"H"H"H @"H"H"H"H"H"@@@@I&Y&X @@@@@@H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H@@@@@I&Y @@@@@@@@@BH"H"
H"H"H"H"H"H"@BH"H"H"H"H"H"H"A&Y&Y&@@@@@@@@@@@BH"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"A&Y&Y&@@@@@@@@@@@BH"H"H"H"H"H"H"H@H"H"H"H"
H"H"H"H @&Y&H@@@@@@@@@@@@BH"H"H"H"H"H"H"@BH"H"H"H"H"H"H"@#@FY!!@@@@@@@ @@@@@"H"H"H"H"H"H"H @"H"H"H"H"H"H"H @@I&Y"I"@@@@H 
@@@@H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"A&@&Y&Y&A @@@"H"@@@@H"H"H"H"H"H"H"@BH"H"H"H"H"H"HFY&Y&Y&@@HP@@@"H@@@@BH"H"H"H"H"H"H @"
H"H"H"H"H"H"@FY&Y&Y&XFH@@"H"@@@@@"H"H"H"H"H"H"H@H"H"H"H"H"H"H"HFY&Y&Y&Y @BH"H"H@@@@"H"H"H"H"H"H"@BH"H"H"H"H"H"H"@&XFY&X@
@ H"H"H @@@@H"H"H"H"H"H"H @"H"H"H"H"H"H"H@@@Y&Y&Y&@"H"H"H@@@@"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H A&Y&Y&@ H"H"H"@@@@H"H"H"H"H"
H"H"@BH"H"H"H"H"H"H"H@Y&Y&D@@"H"H"H"@@@@H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H @BX$QD@"H"H"H @@@BH"H"H"H"H"H"H@H"H"H"H"H"H"H"H"
H"H@AD@D@BH"H"H @@H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"IR@@QDPBH"H"H"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"@@QDPD@"H"H"H"H"H"
H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"H ADQDA@H"H"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H ADQDQDA@H"H"H"H"H"H"H"H"H"H"H @"H"H"H"H"
H"H"H"H"HDADQDQDA@H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"A@QDQDPD@"H"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H@QDQDQDA@H"H"
H"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H A@@DQDPDP@H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"@$QDP@QDADPD@"H"H"H"H"H"H"H"H"H"@BH"
H"H"H"H"H"H"H P@QDPD@@Q@Q@H"H"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H@I ADP@PDPDPBH"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H Y&X$Q@@@
QD@@@"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H A&Y&XRQ@@DP@A @BH"H"H"H"H"H"H"H"H @"H"H"H"@BH"H A&Y&Y&ID@DQ@@FY&@BH"H"H"H"H"H"H"
H"H@H"H"H"@FX@@@A&Y&Y&Y"@@QDQ@@&Y&@BH"H"H"H"H"H"H"H"@BH"H"HFY&Y&Y&Y&Y&Y&X@@DQ@@ Y&Y&@BH"H"H"H"H"H"H"H @"H"H"A&Y&Y&Y&Y&X@
@@@DADQ@H@I&Y&@BH"H"H"H"H"H"H"H@H"H"H Y&Y&Y&Y&@@@@PDA@Q@@"H Y&Y&XBH"H"H"H"H"H"H"@BH"H"HFY&Y&Y&@@H@A@Q@ADQ@H"H A&Y&X@@BH"
H"H"H"H"H @"H"H"A&Y&Y&@@H"HDQDADAD@"H"H"@FY&Y&X@@"H"H"H"H"H@H"H"H"A&Y&X@H"H"ADQDADQD@"H"H"H@Y&Y&A&@"H"H"H"H"@BH"H"H"A&X@
H"H"H QDQ@QDP@H"H"H"H@Y&X@Y&@"H"H"H"H @"H"H"H"@@@"H"H"HDQDQ@Q@Y @"H"H"H@Y&@@Y H"H"H"H"H@H"H"H"H"H"H"H"H"ADQDQ@A#\ @BH"H"
HFY&@FXBH"H"H"H"@BH"H"H"H"H"H"H"H @@@@I7]2@QD@H"H"HFY&A&@"H"H"H"H @"H"H"H"H"H"H"H"HG]7]7]2@@DP@PH"H"HFY XBH"H"H"H"H@H"H"
H"H"H"H"H"H"I7]7\ @ADA@QDPH"H"H@@@H"H"H"H"H"@BH"H"H"H"H"H"H"H@@@@@@@DA@PD@@RH"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H!!DQ@PDADQ
DPDQ@"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"HADPDPDADPDPDPH"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"@QDA@A@A@ADADPH"H"H"H"H"H"H"H"
H @"H"H"H"H"H"H"H"H@@QDA@@@ADADAD@@@@"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H@D@DQDQDQDQ@QDQDPH"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H D@
DPDQ@Q@QDA@PDQ@BH"H"H"H"H"H"H @"H"H"H"H"H"H"H @Q@P@PDQDQDQDPDPDPH"H"H"H"H"H"H"H@H"H"H"H"H"H"H"@QDQ@P@PDA@Q@QDADA@BH"H"H"
H"H"H"H"@BH"H"H"H"H"H"H @QDP@@@A@QDQDQDADPH"H"H"H"H"H"H"H @"H"H"H"H"H"H"H @QDQD@@A@PDQ@QDQ@BH"H"H"H"H"H"H"H@H"H"H"H"H"H"
H"A @ADQDQ@@@@@QDQD@@"H"H"H"H"H"H"H"@BH"@@@"H"H"H"H Y @@DPDQDQ@ADQ@PA&@"H"H"H"H"H"H"H @"HG]0@"H"H"H"A&Y @ADQDQDQDP@A@FY&
@ H"H"H"H"H"H"H@H ]7]0@"H"H"H Y&H@@@@ADQDQDP@@@&Y&A0H"H"H"H"H"H"@BHG]7]0H"H"H"A&Y&@BH"H@@@@@@"@@A&XG]0H"H"H"H"H"H @"A7]7
]0H"H"H Y&X H"H"H"H"H"H"H@A ]7\@H"H"H"H"H"H@H ]7]7@BH"H"A&Y&@"H"H"H"H"H"H"H@@7]7@BH"H"H"H"H"@BHG]7]7@"H @FY&X@H"H"H"H"H"
H"H"HG]7\@@BH"H"H"H"H @"A7]7]0@"A0Y&Y @"H"H"H"H"H"H"H"A'']0@G@"H"H"H"H"H@H"A7]7XG@G]0A&@"H"H"H"H"H"H"H"H"@0@@]7@"H"H"H"H"
@BH A7@@@@@G]"X@H"H"H"H"H"H"H"H"H"@G]7]0H"H"H"H"H @"H @@@@@@I7\0@"H"H"H"H"H"H"H"H"H@@@A7\BH"H"H"H"H@H"H@@@@@@@A7] H"H"H"
H"H"H"H"H"H @@@@A7@"H"H"H"H"@BH"H@@@@@@@I3@BH"H"H"H"H"H"H"H@@@@@@@A0H"H"H"H"H @"H"H@@@A7\@@@H"H"H"H"H"H"H"H@Y7]7H@@@@"H"
H"H"H"H@H"H"H@@G]7L@@"H"H"H"H"H"H"H Y7]7]7@@@BH"H"H"H"H"@BH"H"H@@G]6@BH"H"H"H"H"H"H"H7]7]7]7H@@"H"H"H"H"H @"H"H"H@I7\0@"
H"H"H"H"H"H"H Y7]7]7\@@BH"H"H"H"H"H@H"H"H"H@A6@BH"H"H"H"H"H"H"HFM7]7]0\@@"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"H"H"H"H"H7H0X#A0
@BH"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"H"H"H"H@X@@@@@@@H"H"H"H"H"H"H@') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 66 255 132 132 255 255 255]; mask:((ImageMask new) width: 73; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A? @@@@@@@@@@C?<@@@@@@@@@@@??8@@@@@@@@@L_?? @@@@@@@@CO??8@@@@@@@@@_;/?@@@@@@@@@G;=?8@@@@@@
@@@_;??>@@@@@@@@@????0@@@@@@@@G???>@@@@@@@@A/_??0@@@@@@@@/??/<@@@@@@@@O^W9?@@@@@@@@G/?<G8@@@@@@@C??_#>@@@@@@@@??; ? @@@@
@@@C??0C<@@@@@@@@/?(A?@@@@@@@@_?<@_ @@@@@@@A?=@G8@@@@@@@@_? @?@@@@@@@@A5<@O0@@@@@@@@C?0A8@@@@@@@@@W>@@@@@@@@@@@G? @@@@@@
@@@@A?8@@@@@@@@@@A??@@@@@@@@@@@_?8@@@@@@@@@@G?<@@@@@@@@@@C??@@@@@@@@@@A??8@@@@@@@@@@/?? @@@@@@@@@O??8@@@@@@@@@C_?>@@@@@@
@@@A=?? @@@@@@@@A?7?>@@@@@@@FA?;??0@@@@@@G??>?=>@@@@@@C????=?0@@@@@@?????[>@@@@@@O????!!?0@@@@@C??_?8O?0@@@@@??C?<@?? @@@
@G?@?? C?<@@@@@?@O?8@_? @@@@G C?? C?8@@@@@@@??.@_>@@@@@@@O;78C? @@@@@@C?7?@_0@@@@@@@_/?8C8@@@@@@@_??>@@@@@@@@@A??? @@@@@
@@@@_??8@@@@@@@@@G???@@@@@@@@@C???? @@@@@@@@_???8@@@@@@@@O???>@@@@@@@@O????@@@@@@@@G????0@@@@@@@A????8@@@@@@@@O???>@@@@@
@@@G???? @@@@@<@A????<@@@@@_ @?????(@@@@O<@O_??=?@@@@C?@G>C?''?8@@@@?8A=@@@_?@@@@O>@? @@C?0@@@C?!!?8@@@_>@@@@?<?<@@@G? @@@
G??<@@@@?<@@@A??7@@@@G?@@@@O?_ @@@C?0@@@C??8@@@A?<@@@@_?^@@@C??@@@@C??@@@C?_ @@@@_? @@A??0@@@@C?0@@@_?\@@@@@[<@@@O?>@@@@
@C>@@@C?? @@@@@@@@@@[/0@@@@@@@@@@_?8@@@@') ; yourself); yourself]
!

walkingLeft002
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingLeft002 inspect
     ImageEditor openOnClass:self andSelector:#walkingLeft002
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingLeft002'
        ifAbsentPut:[(Depth4Image new) width: 64; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@@@@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@"H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@"H"@@@@
@@@@H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@@@"@@@@@@@@@BH"H"H"H"H"H"H"H"H"H"H @@@@@@@@@@@@@@@@@@@@@"H"H"H"H"H"H"H"H"H @"@@@@@@@@
@@@@@@@B@@@@@@H"H"H"H"H"H"H"H"H"@BH@@@@@@@@@@@@@@BH"H@@@@"H"H"H"H"H"H"H"H"H @@@@@EUU@@@@@@@BH"H"@@@@H"H"H"H"H"H"H"H"H"@@
@@AUUUUP@@@@@@H"H"H@@@@BH"H"H"H"H"H"H"H"H"@@@@@@UUT@@@@@@@H"H @@@@H"H"H"H"H"H"H"H"H"H"HEUUUUUP@@@@@@@"H"@@@@H"H"H"H"H"H"
H"H"H"H"H"AUUUUU@@@@@@@BH"H@@BH"H"H"H"H"H"H"H"H"H"H"H@AUUU@@@@@@@@H"H"@BH"H"H"H"H"H"H"H"H"H"H"H L@UUT@@@@@@@H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H @@AUUUAU@@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H UPAUUUUPAP@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H UUUUUUUP@E@@@BH"H"
H"H"H"H"H"H"H"H"H"H"H"H"@EUUUUUUTET@@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"AUUUUUUUT@@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@UPUUUP@G
@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@UUUUUU@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@AUUUUUA0H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H 
AUUUT@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@P@Q@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@QDPBH"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H ADQ@@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H QDP@ADPBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"ADPDQ@Q@@"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"HD@@QDPDPBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@QDQDA@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H QDADQDPD@BH"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"ADADQDQ@P@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"ADPDQDQDA@@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HDQ@QDQDPD
AD@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H QDADQDQ@PDPBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H QDPDQDQD@@P@@"H"H"H"H"H"H"H"H"H"H"H"@@@"H"@D
Q@@@QDP@A@Q@H"H"H"H"H"H"H"H"H"H"H"AUUPH"@DQ@ADP@A@A@QD@BH"H"H"H"H"H"H"H"H"H"AUUUTBHDADADQDQ@@@ADQ@H"H"H"H"H"H"H"H"H"H"AU
UUUU@@@DP@ADQDP@ADQD@"H"H"H"H"H"H"H"H"H"HEUUUUUUT@@@@@@@A@@DQDPBH"H"H"H"H"H"H"H"H"H UUUUUUUUUUUUUU@@@@QDPBH"H"H"H"H"H"H"
H"H"H"@EUUUUUUUUUUUUUP@@@DPBH"H"H"H"H"H"H"H"H"H"H UUT@@EUUUUUUUUT@P@@BH"H"H"H"H"H"H"H"H"H"H"H@@@@ @EUUUUUUT@PADP@"H"H"H"
H"H"H"H"H"H"H"H"H"H"H @EUUUUUP@D@QD@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@@@UUUP@D@QDA@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"A@@@@@@F@QDA
@PH"H"H"H"H"H"H"H"H"H"H"H"H"H"H@@@@@@F@QDQ@P@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@FA @F@@DA@PDBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H@A 
@@A @Q@PD@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@A@PD@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@DQDP@QDPDA@BH"H"H"H"H"H"H"H"H"H"H"H"
H"H"@@DADQDQ@PDA@BH @@H"H"H"H"H"H"H"H"H"H"H"H"HA@ADQDQDQDA@@@@Y&@BH"H"H"H"H"H"H"H"H"H"H"H DQDQDADPDA@@A A&X@@"H"H"H"H"H"
H"H"H"H"H"H"@ADQDQDPDA@@A X@Y&@@H"H"H"H"H"H"H"H"H"H"H"@ADPDQDPDP@@T@XF@F@@@"H"H"H"H"H"H"H"H"H"H"HADQDADQ@@@EUU@F@@@@@@H"
H"H"H"H"H"H"H"H"H"H @QDQDP@@UUUUUPA @@@@@"H"H"H"H"H"H"H"H"H"H"@QDQDP@EUUUUUUA&@@@@@@H"H"H"H"H"H"H"H"H"H"HADP@@AUUUUUT@@F
X@@@@@@"H"H"H"H"H"H"H"H"H"H DPAUUUUUUUT@@@X@@@@@X@H"H"H"H"H"H"H"H"H"H"@AAUUUUUUU@@@@@@@@A&Y&@"H"H"H"H"H"H"H"H"H"H@AUUUUU
UP@@@"H"HFY&Y&@BH"H"H"H"H"H"H"H"H"H"@EUUUUT@@@@"H"H A&Y&Y H"H"H"H"H"H"H"H"H"H"H"AUUP@@@@@"H"H"HFY&Y @"H"H"H"H"H"H"H"H"H"
H"H@@@@@@@@BH"H"H Y&Y XBH"H"H"H"H"H"H"H"H"H"H @@@@@@@@H"H"H"A&Y&X@H"H"H"H"H"H"H"H"H"H"H"H@@@@@@@H"H"H"HFY&X@H"H"H"H"H"H"
H"H"H"H"H"H Y&Y @@@"H"H"H"A X@H"H"H"H"H"H"H"H"H"H"H"H"H@Y&Y&Y H"H"H"H @BH"H"H"H"H"H"H"H"H"H"@@@BH"@@@FY @BH"H"H"H"H"H"H"
H"H"H"H"H"H"H"A&Y&@BH X@@@X@@"H"H"H"H"H"H"H"H"H"H"H"H"H"A&Y&Y&@@XFA XFX@H"H"H"H"H"H"H"H"H"H"H"H"H"HFY&Y&Y @@A XFY&@"H"H"
H"H"H"H"H"H"H"H"H"H"H Y&Y&Y&@@@@@@Y&XBH"H"H"H"H"H"H"H"H"H"H"H"H"A&Y&Y X@@@@@A&X@H"H"H"H"H"H"H"H"H"H"H"H"H"H @FA X@@@@@@@
X@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H@@@@@@@@@@@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 64; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@A @@@@@@@@@?0@@@@@@@@G? @@@@@O? ??@@@@@A??''?>@@@@@O????<@@@@L???>?8@@@@3???0_ @@@A???>@?@@@@G
???8C>@@@@G???8O8@@@@C??? ?@@@@@G??>C0@@@@@_??8F@@@@@A???@@@@@@@O??<@@@@@@A??? @@@@@@O??>@@@@@@@???0@@@@@@@??>@@@@@@@C??
0@@@@@@@O??@@@@@@@@_?8@@@@@@@A?? @@@@@@@A??@@@@@@@@A?>@@@@@@@@A?8@@@@@@@@O?0@@@@@@@@?? @@@@@@@C?>@@@@@@@@O?8@@@@@@@A??0@
@@@@@@G??@@@@@@@@??>@@@@@@@C??<@@@@@@@O??0@@@@@@A??? @@@@@<G???@@@@@G8???>@@@@@?3???8@@@@G????? @@@@_????>@@@@A?????0@@@
@G????>@@@@@O????0@@@@@_/??? @@@@@@O???@@@@@@@_??<@@@@@@@???8@@@@@@C??? @@@@@@G??>@@@@@@@_??8@@@@@@A??? @@@@@@G??>@@@@@@
@???18@@@@@C????0@@@@@O???? @@@@@?????@@@@@G????<@@@@@_????8@@@@A????? @@@@G?????@@@@@_????<@@@@A?????8@@@@G????? @@@@_?
? _>@@@@@??<A?8@@@@@?? C? @@@@C?>@O>@@@@@O?8@?8@@@@@_?@C?@@@@@A?<@G8@@@@@C?8@N@@@@@>G?0@@@@@@G>O? @@@@@@????@@@@@@C???<@
@@@@@O???0@@@@@@????@@@@@@A???<@@@@@@C??? @@@@@@@@@@@@@@') ; yourself); yourself]
!

walkingLeft003
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingLeft003 inspect
     ImageEditor openOnClass:self andSelector:#walkingLeft003
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingLeft003'
        ifAbsentPut:[(Depth4Image new) width: 63; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H @@@@@@@"H"H"H"H"H"H"
H"H"H"H H"H"H"H"H"H"H @@@@@@@@@"H"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H @@@@@@@@@@@BH"H"H"H"H"H"H"H"HBH"H"H"H"H @"@@@@@@@@@@@@@"
@@@@H"H"H"H"H"H H"H"H"H"H"@BH@@@@@@@@@@@@@@@@@@BH"H"H"H"H"@"H"H"H"H"H @@@@@EUU@@@@@@@@@@@@@"H"H"H"H"JBH"H"H"H"H"@@@@AUUU
UP@@@@@@@@@@@@H"H"H"H"H H"H"H"H"H"H"@@@@@@UUT@@@@@@@@@@@@BH"H"H"H"@"H"H"H"H"H"H"HEUUUUUP@@@@@@@@@@@@@"H"H"H"HBH"H"H"H"H"
H"H"AUUUUU@@@@@@@BH @@@BH"H"H"H H"H"H"H"H"H"H"H@AUUU@@@@@@@@H"H@@@H"H"H"H"@"H"H"H"H"H"H"H L@UUT@@@@@@@H"H"@@@"H"H"H"HBH"
H"H"H"H"H"H @@AUUUAU@@@@@"H"H@@BH"H"H"H H"H"H"H"H"H"H UPAUUUUPAP@@@"H"H @@@"H"H"H"@"H"H"H"H"H"H UUUUUUUP@E@@@BH"H"@@@BH"
H"H"HBH"H"H"H"H"H"@EUUUUUUTET@@BH"H"H @@@"H"H"H H"H"H"H"H"H"H"AUUUUUUUT@@BH"H"H"H@@BH"H"H"("H"H"H"H"H"H"H@UPUUUP@G@BH"H"
H"H"@BH"H"H"HBH"H"H"H"H"H"H @@UUUUUU@@H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H@AUUUUUA0H"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H"H AUUUT@
@@@"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H @@@@P@A@H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H @@@@QD@"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H"
H"H"H"@@QDA@H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"@DQDADPBH"H"H"H"H"H"H"H(H"H"H"H"H"H"H"H"H"HDQD@DQD@"H"H"H"H"H"H"H" "H"H"
H"H"H"H"H"H"H QDADP@PBH"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"A@ADQDPD@"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H@PDQDQD@BH"H"H"H"H"H"
H"("H"H"H"H"H"H"H"H"HDQ@QDQDP@H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H QDADQDQD@BH"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"ADPDQDQDP@@"H"
H"H"H"H"H"@"H"H"H"H"H"H"H"H"ADQDADQD@DPBH"H"H"H"H"H"HBH"H"H"H"H"H"H"H"HDQDP@QDADQD@"H"H"H"H"H"H H"H"H"H"H"H"H"H"H QDQDAD
ADQDQ@H"H"H"H"H"H"@"H"H"H"@@@BH"H"H QDQDQ@PDQD@@@"H"H"H"H"H"HBH"H"H"AUUU@"H"H"ADQDQ@@DQDAU@BH"H"H"H"H"H(H"H"H"HEUUUPH"H"
ADQDQDA@QDAUUPH"H"H"H"H"H"@"H"H"HEUU@ETBH"HDQDQDPD@@@EUUTBH"H"H"H"H"HBH"H"H UUTEUP@BH QDQDPDQ@@@UUUU@"H"H"H"H"H H"H"H"AU
UPUPUU@@PDQDQ@ADP@@EUUTBH"H"H"H"H"@"H"H"HEUU@EAUUUT@QDQDADPDAUUUUPH"H"H"H"H"HBH"H"H"AUUP@EUUUUTDQDP@PDAUUUUU@"H"H"H"H"H 
H"H"H"H @@@@AUUUUPQDQ@QDAUUUUU@"H"H"H"H"H"@"H"H"H"H"H"H AUUUADQD@@AUUUUU@"H"H"H"H"H"HBH"H"H"H"H"H"H AUTDQ@@@UUUUUU@BH"H"
H"H"H"H H"H"H"H"H"H"H"H AP@@UUUUUUUP@@H"H"H"H"H"H"@"H"H"H"H"H"H"H"H@AUUUUUUUT@@@@"H"H"H"H"H"J"H"H"H"H"H"H"H"H AUUUUUUP@@
@@@BH"H"H"H"H"H H"H"H"H"H"H"H"H"@EUUUUT@@@XF@@H"H"H"H"H"H"@"H"H"H"H"H"H"H"H UUUU@@A XF@@@BH"H"H"H"H"HBH"H"H"H"H"H"H @"AU
UU@@A X@@AD@H"H"H"H"H"H H"H"H"H"H"H"H DP@@UU@@@@@@@PD@@BH"H"H"H"H"@"H"H"H"H"H"H @ADQD@@A@@@@@PDA@@H"H"H"H"H"HBH"H"H"H"H"
H UU@QDPDA@PD@@@DQ@@@"H"H"H"H"H/H"H"H"H"H"H UUUPDQDQ@PDA@P@A@P@BH"H"H"H"H"@"H"H"H"H"H"AUUUT@DQDPDA@P@ADP@@H"H"H"H"H"HBH"
H"H"H"H"HEUUUU@PDQDQ@@@ADP@@@"H"H"H"H"H(H"H"H"H"H"H UUUPT@DADQDPDADP@@@BH"H"H"H"H"@"H"H"H"H"H"HEUU@A@ADQDQDQDPD@@BH"H"H"
H"H"JBH"H"H"H"H"H UUUP@P@A@QDQDPD@@@H"H"H"H"H"H H"H"H"H"H"H"HEUUT@@A@PDA@PD@@@H"H"H"H"H"H"@"H"H"H"H"H"H UUT@@@@@@A@PD@@@
H"H"H"H"H"H"HBH"H"H"H"H"H"HEUU@@@@@@@@@@@@@"H"H"H"H"H"H H"H"H"H"H"H"H UU@FX@@@@@@@@@H"H"H"H"H"H"H" "H"H"H"@@@BH"HEUPY&@@
@@@@@BH"H"H"H"H"H"H"HBH"H"H"A&Y&@"H"APXFX@D@@@H"H"H"H"H"H"H"H"H H"H"H"A&Y&Y H"@@@@Y&@@@@@"H"H"H"H"H"H"H"H"@"H"H"HFY&Y&@B
HFX@@FXEUP@@H"H"H"H"H"H"H"H"HBH"H"H Y&Y&Y @@Y&Y A&AUT@@"H"H"H"H"H"H"H"H H"H"H"A&Y&Y&X@A&Y&XFY UUUPH"H"H"H"H"H"H"H"@"H"H"
H@Y&Y&Y @@A&Y Y&XEUU@BH"H"H"H"H"H"H"HBH"H"H"@FY&Y&@@@@@@A&Y&@@A&@"H"H"H"H"H"H"H H"H"H"H@A Y&@@@@A @@Y&X@Y&XBH"H"H"H"H"H"
H" "H"H"H"@@XF@@@@A&X@@@@@A&@@@"H"H"H"H"H"H"HBH"H"H"H"@@A @@A&Y&A&@@@@@@@BH"H"H"H"H"H"H H"H"H"H"H"@@@@@FY&@FY @@A&Y @"H"
H"H"H"H"H"@"H"H"H"H"H"H@@@Y&XFY&@@@@Y&@BH"H"H"H"H"H"HBH"H"H"H"H"H"H@@@@FY&Y @@A&X@H"H"H"H"H"H"H(H"H"H"H"H"H"H X@A&Y&Y @@
@FX@@"H"H"H"H"H"H"@"H"H"H"H"H"H"H@@@@@@@@@@@@@@"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H ') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 63; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@A?<@@@@@@@@O?<@@@@@@@A??>@@@@@@A''??<?@@@@@F_???>@@@@@O????<@@@@@?????8@@@@@?????0@@@@@_???? @@@@
@???1>@@@@@C???C8@@@@@O??8G @@@@A??? ^@@@@@O??<A<@@@@A???0G0@@@@G??>@O @@@@G??0@^@@@@@_?>@@0@@@@A??8@@@@@@@C??@@@@@@@@O?
<@@@@@@@@O?8@@@@@@@@O? @@@@@@@@G?@@@@@@@@@?>@@@@@@@@C?<@@@@@@@@O?0@@@@@@@@?? @@@@@@@C?>@@@@@@@@_?8@@@@@@@A??0@@@@@@@G?? 
@@@@@@@??>@@@@@@@C??<@@@@@@@O??8@@@@G0A??? @@@@? G??>@@@@C?@???8@@@@_>C???0@@@A?>O??? @@@G?????>@@@@_?????8@@@@?????? @@
@A?????<@@@@@A???? @@@@@A???>@@@@@@A???8@@@@@@C??? @@@@@@O??>@@@@@@@???8@@@@@@A???0@@@@@A''???@@@@@@O???>@@@@@A????8@@@@@
O???? @@@@A????>@@@@@G????8@@@@@_???? @@@@A????>@@@@@C????0@@@@@O????@@@@@@_???8@@@@@A????@@@@@@C???<@@@@@@O???@@@@@G0_?
?0@@@@@? ??8@@@@@G?G?? @@@@@_>_??@@@@@A????<@@@@@G????8@@@@@_????0@@@@@????? @@@@C????>@@@@@G????<@@@@@G????0@@@@@G???? 
@@@@@C???>@@@@@@C???8@@@@@@O??? @@@@@@_??<@@@@@@@@@@@0@@') ; yourself); yourself]
!

walkingLeft004
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingLeft004 inspect
     ImageEditor openOnClass:self andSelector:#walkingLeft004
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingLeft004'
        ifAbsentPut:[(Depth4Image new) width: 73; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"JBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H @@@@@@@"H"H"H"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"@@@@@@@@@BH"H"H"H"H"H"H"H"H"
H"H"H"T"H"H"H"H"H"H"H@@@@@@@@@@@@"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H @"@@@@@@@@@@@@@"H"H"H"H"H"H"H"H"H"H"IRH"H"H"H"H"H@H 
@@@@@@@@@@@@@ @@H"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H@@@@@AUUP@@@@@@@@@@@@H"H"H"H"H"H"H"H$H"H"H"H"H"H"@@@@AUUUUP@@@@@@@@@@@@H"
H"H"H"H"H"H"IRH"H"H"H"H"H"H@@@@@AUUP@@@@@@@@@@@@H"H"H"H"H"H"H"@"H"H"H"H"H"H"H"AUUUUUT@@@@@@@@@@@@@H"H"H"H"H"H"H H"H"H"H"
H"H"H"H"AUUUUU@@@@@@@@@@@@@@H"H"H"H"H"H"KBH"H"H"H"H"H"H"H @EUUT@@@@@@@@@@@@@@BH"H"H"H"H"H"@"H"H"H"H"H"H"H"HC@EUU@@@@@@@B
H@@@@@@BH"H"H"H"H"H!!H"H"H"H"H"H"H"H @@AUUUAU@@@@@"@@@@@@@"H"H"H"H"H"HBH"H"H"H"H"H"H"AU@EUUUU@E@@@BH @@@@@@H"H"H"H"H"H"<"
H"H"H"H"H"H"HEUUUUUUT@AP@@@"H @@@@@@H"H"H"H"H"H''H"H"H"H"H"H"H"@EUUUUUUTET@@BH"H@@@@@@@H"H"H"H"H"HBH"H"H"H"H"H"H"HEUUUUUU
UP@@H"H"@@@@@@@BH"H"H"H"H"@"H"H"H"H"H"H"H"@ETEUUT@A0@"H"H"@@@@@@H"H"H"H"H"H!!H"H"H"H"H"H"H"H @@UUUUUU@BH"H"H"@B@@@BH"H"H"
H"H"HBH"H"H"H"H"H"H"H @EUUUUTG@"H"H"H"H"@@@"H"H"H"H"H"@"H"H"H"H"H"H"H"H@UUUU@@@D@"H"H"H"H"@BH"H"H"H"H"H H"H"H"H"H"H"H"H"
H @@@@@DQ@H"H"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"@@@@QD@@H"H"H"H"H"H"H"H"H"H"H","H"H"H"H"H"H"H"H"H"H QD@@Q@@"H"H"H"H"
H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"ADP@@@QD@"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H QD@DQDP@@"H"H"H"H"H"H"H"H"H"0"H"H"H"H"
H"H"H"H"H"HDP@QDQDPD@"H"H"H"H"H"H"H"H"H(H"H"H"H"H"H"H"H"H"H"@@PDQDQDQ@@BH"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H@ADADQDQDQ@
@BH"H"H"H"H"H"H"H"@"H"H"H"H"H"H"H"H"H PDQ@QDQDQDADPBH"H"H"H"H"H"H"H)H"H"H"H"H"H"H"H"H"HDADP@QDQDQ@QD@BH"H"H"H"H"H"H"HBH"
H"H"H"H"H"H"H"H Q@QDP@QDQDADP@@BH"H"H"H"H"H"H"X"H"H"H"H"H"H"H"H"@DADQDP@@@Q@QD@ETBH"H"H"H"H"H"H H"H"H"H"H"H"H"H"HE@@QDQD
@@@@ADP@UUTBH"H"H"H"H"H"J"H"H"H"H"H"H"H"H@UU@DQDQ@ADP@QDAUUUTBH"H"H"H"H"H"P"H"H"H"H"H"H"H UUUPADQDPDA@P@P@UUUUTBH"H"H"H"
H"H H"H"H"H"H"H"H AUUUT@QDQDPDA@P@@@UUUU@"H"H"H"H"H"HBH"H"H"H"H"H"AUUUUU@DQDQ@QDA@P@H@AUUU@"H"H"H"H"H" "H"H"H"H"H"@EUUUU
@BADQDQDQDA@PBH AUUU@ @"@"H"H"H H"H"H"H"H"@EUUUP@BH"ADQDADQDQ@@"H @EUUAU@E@BH"H"HBH"H"H"H@@EUUUP@"H"H"ADQDQDQDA@H"H"@EUU
UPUU@BH"H"@"H"H"H UUUUUP@"H"H"H QDQDQDQD@BH"H"@EUUUPUU@"H"H%H"H"H"AUUUUU@"H"H"H"H Q@QDQDPD@"H"H"@EUUT@UPH"H"HBH"H"H UUTE
TBH"H"H"H"HDQDQDQDP@H"H"H"@EUUUUTBH"H"D"H"H"HEUPAU@"H"H"H"H"HDQDQDA@PBH"H"H"@EUUUPH"H"H H"H"H"AUTEUPH"H"H"H"H"ADQ@PD@@@"
H"H"H"H@@@@"H"H"J2H"H"H UUAU@"H"H"H"H"H PD@@@@Y @"H"H"H"H"H"H"H"H"\"H"H"H UU@BH"H"H"H"H"H@@@A&Y&@@H"H"H"H"H"H"H"H"H H"H"
H"H @BH"H"H"H"H"H Y&Y&X@@@@PH"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H"H @@@@@ADA@PH"H"H"H"H"H"H"H"0"H"H"H"H"H"H"H"H"H"H"H@@A
@PDQDQ@PH"H"H"H"H"H"H"H%H"H"H"H"H"H"H"H"H"H"H"@@DA@Q@QDA@BH"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H"H D@DA@QDQDA@BH"H"H"H"H"H"
H"@"H"H"H"H"H"H"H"H"H"H"HAD@@ADQ@PDA@"H"H"H"H"H"H"H%H"H"H"H"H"H"H"H"H"H"H"@QDQ@ADQDPD@@"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"
H"HA@QDA@PDQ@PD@H"H"H"H"H"H"H"<"H"H"H"H"H"H"H"H"H"H"@QDQDADQDQ@P@@H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"HADQ@P@QDPDA@P@BH"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H DQDQ@ADQDPDQ@@@BH"H"H"H"H"H"@"H"H"H"H"H"H"H"H"H"@QDP@ADQDA@QD@@E@"H"H"H"H"H"H H"H"H"H"H"H"
H"H"H"HADQ@ADQDPDA@P@@AU@"H"H"H"H"H"JBH"H"H"H@@BH"H"H"H"@@DADPDA@PD@@@@EUPH"H"H"H"H"H"@"H"H"H Y&XBH"H"H"H @@@QDPDA@@@@@@
UUUPH"H"H"H"H"H H"H"H"A&Y&XBH"H"H"AUT@@A@PDADQ@@AUUUUPH"H"H"H"H"J"H"H"H A&Y&XBH"H"HEUUT@@A@@@Q@@H"AUUUUPH"H"H"H"H"("H"H"
HFY&Y&@"H"H"AUUUT@@@@@@@H"H"@EUUA H"H"H"H"H/H"H"H"@FY&Y H"H"HEUUUU@"H"H"H"H"H"HETFY H"H"H"H"HBH"H"H Y&Y&Y H"H UUUUTBH"H"
H"H"H"H"H@Y&X@H"H"H"H"@"H"H"H@Y&Y&@BH"AUUUT@H"H"H"H"H"H"H"HFY A H"H"H"H H"H"H"@@Y&A @BHFAUUPH"H"H"H"H"H"H"H"HF@FY H"H"H"
IBH"H"H A XF@@@@Y&AU@"H"H"H"H"H"H"H"H @@Y&Y H"H"H"T"H"H"H A X@@@A&Y&@BH"H"H"H"H"H"H"H"@@@@A&XBH"H"H H"H"H"H@A @@@@A&Y&@"
H"H"H"H"H"H"H@@@@@@@A&@"H"H"HBH"H"H"H@@@@@@@A&XBH"H"H"H"H"H"H Y&X@@@@@@@H"H"H"0"H"H"H"H@@@@@A A H"H"H"H"H"H"H"A&Y&Y @@@@
@"H"H"H H"H"H"H"H@@@@FY @"H"H"H"H"H"H"HFY&Y&Y @@@BH"H"H"HRH"H"H"H"H@@@Y&Y H"H"H"H"H"H"H"A&Y&Y&A @@H"H"H"H"@"H"H"H"H"H@A&
Y&@BH"H"H"H"H"H"H Y&Y&XF@@@"H"H"H"H''H"H"H"H"H"H@@FXF@"H"H"H"H"H"H"H@XFA XF@@H"H"H"H"I2H"H"H"H"H"H@@@XBH"H"H"H"H"H"H"H@@@
@@@@@"H"H"H"H"@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H ') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 73; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A?<@@@@@@@@@@@??0@@@@@@@@@@_?? @@@@@@@@A''??<@@@@@@@@@Y???/@@@@@@@@C?????@@@@@
@@@?????8@@@@@@@C?????@@@@@@@@G????8@@@@@@@@?????@@@@@@@@O????0@@@@@@@C??>_>@@@@@@@A???''? @@@@@@@???1?8@@@@@@@_??<O?@@@@
@@@G??>C?8@@@@@@@_??@?>@@@@@@@G?? G?@@@@@@@A??0@70@@@@@@@O?<@@<@@@@@@@C?? @F@@@@@@@@O?8@@@@@@@@@@@??@@@@@@@@@@@A?<@@@@@@
@@@@@?? @@@@@@@@@@O?<@@@@@@@@@@C?? @@@@@@@@@@??>@@@@@@@@@@_??0@@@@@@@@@O??>@@@@@@@@@C???0@@@@@@@@A???>@@@@@@@@@????0@@@@
@@@@_???>@@@@@@@@_????0@@@@@@@O????>@@@@@@@O????? @@@@@@G????_<@@@@@@G?7??1?, @@@@G?0??<O?>@@@@_? G??@??0@@@O? A??0G?<@@
@G? @O?<@??@@@A?0@C??@G?0@@@_<@@_?0@?8@@@G?@@G?<@C<@@@A? @A?? @@@@@@O0@@_?8@@@@@@A0@@O??@@@@@@@@@@A??8@@@@@@@@@@_??@@@@@
@@@@@G??0@@@@@@@@@A??>@@@@@@@@@@_?? @@@@@@@@@G??<@@@@@@@@@C???@@@@@@@@@@???8@@@@@@@@@_??>@@@@@@@@@O???0@@@@@@@@G???<@@@@
@@@@C???? @@@@@^@@????8@@@@@O0@O????@@@@@G>@G????8@@@@A?0C???G?@@@@@_<@???@?8@@@@G?@_<@@C?@@@@A?8O>@@@_8@@@@_>G?@@@C?@@@
@G?3?@@@@_8@@@A??? @@@O?@@@@O??0@@@G?0@@@C??<@@@_?<@@@@_?>@@@O??@@@@C??@@@G?? @@@@_? @@C??0@@@@C?8@@@??8@@@@@_>@@@O?<@@@
@@C? @@C??@@@@@@_0@@@_? @@@@@@@@@@@@@@@@') ; yourself); yourself]
!

walkingLeft005
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingLeft005 inspect
     ImageEditor openOnClass:self andSelector:#walkingLeft005
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingLeft005'
        ifAbsentPut:[(Depth4Image new) width: 59; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H%
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H 
H"H"H"H"H"@@@@@@@BH"H"H"H"H"H"H"H"H"H"H H"H"H"H"H @@@@@@@@@"H"H"H"H"H"H"H"H"H"H(H"H"H"H"H@@@@@@@@@@@@"H"H@@@@"H"H"H"H"H 
H"H"H"@BH@@@@@@@@@@@@BH @@@@@BH"H"H"H"H H"H"H"@BH@@@@@@@@@@@@@H@@@@@@@@"H"H"H"H H"H"H"H@@@@@AUUP@@@@@@@@@@@@@@@BH"H"H"H 
H"H"H"H@@@@EUUUU@@@@@@@@@@@@@@@@H"H"H"H(H"H"H"H"@@@@@@UUT@@@@@@@@"H@@@@@@"H"H"H H"H"H"H"H"AUUUUUT@@@@@@@@"H @@@@@BH"H"H 
H"H"H"H"H"HEUUUUT@@@@@@@H"H"@@@@@@H"H"H*H"H"H"H"H"H@AUUU@@@@@@@@H"H"H@@@@@H"H"H H"H"H"H"H"HC@EUU@@@@@@@BH"H"H @@@@H"H"H 
H"H"H"H"H"@@@EUUTET@@@@BH"H"H @@@BH"H"H H"H"H"H"H UPAUUUUPAP@@@"H"H"H @@@"H"H"H(H"H"H"H"HEUUUUUUT@AP@@@"H"H"H @@@"H"H"H)
H"H"H"H"H@UUUUUUUPUP@@H"H"H"H"@@H"H"H"H H"H"H"H"H"AUUUUUUUT@@BH"H"H"H"H"H"H"H"H H"H"H"H"H"@ETEUUT@A0@"H"H"H"H"H"H"H"H"H 
H"H"H"H"H"@@AUUUUUT@H"H"H"H"H"H"H"H"H"H%H"H"H"H"H"H@AUUUUUA0H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H@UUUU@@@BH"H"H"H"H"H"H"H"H"H 
H"H"H"H"H"H"@@@@@DQ@H"H"H"H"H"H"H"H"H"H*H"H"H"H"H"H"H @@ADP@@"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"HDQ@@@@BH"H"H"H"H"H"H"H"H 
H"H"H"H"H"H"H"ADPDQDA@H"H"H"H"H"H"H"H"H%H"H"H"H"H"H"H"ADAD@DQ@H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"A@ADQ@QD@"H"H"H"H"H"H"H"H 
H"H"H"H"H"H"H"@@QDQDAD@"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"A@QDQD@D@"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"A@QDQDP@@BH"H"H"H"H"H"H"H 
H"H"H"H"H"H"H"A@QDQDADPBH"H"H"H"H"H"H"H$H"H"H"H"H"H"H Q@QDQ@QDQ@H"H"H"H"H"H"H"H(H"H"H"H"H"H"H QDADPDQ@@@H"H"H"H"H"H"H"H 
H"H"H"H"H"H"H QDP@PDP@APH"H"H"H"H"H"H"H H"H"H"H"H"H"HDQDQ@AD@EUU@"H"H"H"H"H"H"H H"H"H"H"H"H"HDQDQDADAUUU@"H"H"H"H"H"H"H 
H"H"H"H@@@@"HDQDQ@P@@@UUTBH"H"H"H"H"H"H(H"H"H"AUAUT@HDQDQDA@UUUUTBH"H"H"H"H"H"H H"H"H UUAUTE@@QDQDPEUUUU@"H"H"H"H"H"H"H 
H"H"H UUT@AUAPADQDAUUUUU@"H"H"H"H"H"H"H H"H"H UUUUTEAUADQ@UUUUUP@"H"H"H"H"H"H"H H"H"H UUUU@EAP@DPEUUUU@@@"H"H"H"H"H"H"H(
H"H"H UUUU@E@@HDAUUUT@A@@"H"H"H"H"H"H"H"H"H"H"AUUP@@@"H@UUUP@@P@@BH"H"H"H"H"H"H H"H"H"H@@@H"H"HEUUT@ADA @@@"H"H"H"H"H"H 
H"H"H"H"H"H"H"HEUU@@A@XA@A@@H"H"H"H"H"H H"H"H"H"H"H"H"AUUUT@@F@PDPDA@"H"H"H"H"H H"H"H"H"H"H"H"AUUUUUA @ADA@@DBH"H"H"H"H 
H"H"H"H"H"H"H"AUUUUU@@DQ@P@@@BH"H"H"H"H H"H"H"H"H"H"H"HEUUUU@QDQDPDP@@H"H"H"H"H H"H"H"H"H"H"H"HEUUUP@@@A@ADA@@H"H"H"H"H&
H"H"H"H"H"H"H"H@UUT@@PDPDQ@PD@H"H"H"H"H H"H"H"H"H"H"H"H @@@@DPDQ@QDA@@H"H"H"H"H H"H"H"H"H"H"H"H @ADAD@@ADA@P@@H"H"H"H"H 
H"H"H"H"H"H"H"H"H@@@@@@@@PD@@P@@@"H"H"H H"H"H"H"H"H"H"H"HA@QDADQ@P@@D@A&XBH"H"H H"H"H"H"H"H"H"H"H@DADPDQ@A@A@@A&Y H"H"H$
H"H"H"H"H"H"H"H"@@DQDQDQDA@PD@A&Y H"H"H(H"H"H"H"H"H"H"H @QDQ@PDQ@PDA@@Y&Y H"H"H H"H"H"H"H"H"H"HADQDQDQDPDQ@P@@A @@H"H"H 
H"H"H"H"H"H"H"HADQDADQDQ@PD@@@@@@@H"H"H H"H"H"H"H"H"H"H@@QDQDQDQDA@@@@@@@@H"H"H H"H"H"H"H"H"H"HE@@@QDPDA@@@@@@@@@@@"H"H(
H"H"H"H"H"H"H"HEUP@@DA@P@BH"H @@@F@BH"H H"H"H"H"H"H"H"HEUUT@@@@@H"H"H @@A X@H"H H"H"H"H"H"H"H"H UUUUTA@BH"H"H"@@Y&A H"H 
H"H"H"H"H"H"H"H"AUUUUPH"H"H"H"@FY&XF@"H H"H"H"H"H"H"H"H"H@UUUU@"H"H"H"A&Y&Y @"H(H"H"H"H"H"H"H"H"H"@EUPXBH"H"H"HFY&XF@"H"
H"H"H"H"H"H"H"@@@BH@TFY H"H"H"HFY&Y @"H H"H"H"H"H"H"H@Y&Y H A&Y&@"H"H"H Y&X@@"H H"H"H"H"H"H"A&Y&Y&@@@FY @BH"H"H"@FA H"H 
H"H"H"H"H"H Y&Y&Y&X@@@@@Y H"H"H"H @BH"H H"H"H"H"H"H Y&Y&Y&Y @@A&Y H"H"H"H"H"H"H H"H"H"H"H"H Y&Y&Y&XF@@@FY H"H"H"H"H"H"H 
H"H"H"H"H"H"A&Y&Y&A @@@FX@H"H"H"H"H"H"H H"H"H"H"H"H"A XFA XF@@@F@@H"H"H"H"H"H"H&H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H 
') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 59; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G?0@@@@@@@@??0@@@@@@@G??8G8@@@@F_??1?0@@@@Y???/?0@@@@?
????? @@@C??????@@@@C???>O>@@@@A???8_<@@@@C???@?8@@@@O??<A? @@@@??? C>@@@@G??>@O0@@@@???0@>@@@@G???@C8@@@@_??8@G@@@@@_??
@@@@@@@A??8@@@@@@@G??@@@@@@@@O?<@@@@@@@@?? @@@@@@@@??@@@@@@@@@?>@@@@@@@@@?<@@@@@@@@G?8@@@@@@@@_? @@@@@@@A??@@@@@@@@G?<@@
@@@@@@_?0@@@@@@@A?? @@@@@@@G?>@@@@@@@@??<@@@@@@@C??0@@@@@@@O??@@@@@@@A??>@@@@@@@G??8@@@@@C<_??0@@@@@_=???@@@@@C????8@@@@
@O???? @@@@@????>@@@@@C????8@@@@@O?;?? @@@@@_>O??@@@@@@>@???@@@@@@@C???@@@@@@@_??>@@@@@@A???<@@@@@@G???0@@@@@@O??? @@@@@
@???>@@@@@@C???8@@@@@@G??? @@@@@@_??>@@@@@@@_??? @@@@@A????@@@@@@G???>@@@@@@????8@@@@@G???? @@@@@????>@@@@@C????8@@@@@O?
??? @@@@@?????@@@@@C??0O>@@@@@O?<@?<@@@@@_? A?0@@@@@?8@G? @@@@A?0@_>@@@@@A? @?8@@@@G3?@C? @@@A?''>@G>@@@@O??<@O0@@@A???8@
N@@@@G??? @@@@@@_??>@@@@@@@???8@@@@@@C??? @@@@@@@@@@@@@@') ; yourself); yourself]
!

walkingLeft006
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingLeft006 inspect
     ImageEditor openOnClass:self andSelector:#walkingLeft006
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingLeft006'
        ifAbsentPut:[(Depth4Image new) width: 54; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H @@@@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H@@@@@@@@@H"H"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@@@@@@H"H"H"H"H"H"H"H"H"H"H @"@@@@@@@@@@@@
@"H@@BH"H"H"H"H"H"H"H @"@@@@@@@@@@@@@B@@@@H"H"H"H"H"H"H"H"@@@@@@UUT@@@@@@@@@@@@"H"H"H"H"H"H"H"@@@@AUUUUP@@@@@@@@@@@BH"H"
H"H"H"H"H"H @@@@@EUU@@@@@@@@@@@BH"H"H"H"H"H"H"H"H UUUUUU@@@@@@@@@@@BH"H"H"H"H"H"H"H"H"AUUUUU@@@@@@@@@@@@H"H"H"H"H"H"H"H"
H"@@UUUP@@@@@@@B@@@@H"H"H"H"H"H"H"H"H"@0AUUP@@@@@@@"@@@@H"H"H"H"H"H"H"H"H @@AUUUAU@@@@@"@@@@H"H"H"H"H"H"H"H"HET@UUUUT@T@
@@H"H@@@H"H"H"H"H"H"H"H"AUUUUUUU@@T@@@H"H@@@H"H"H"H"H"H"H"H"@EUUUUUUTET@@BH"H@@@H"H"H"H"H"H"H"H"H UUUUUUUU@@@"H"H@@@H"H"
H"H"H"H"H"H"H AUAUUU@@\@H"H"H@@@H"H"H"H"H"H"H"H"H @@UUUUUU@BH"H"H@@@H"H"H"H"H"H"H"H"H"@@UUUUUP\BH"H"H@@BH"H"H"H"H"H"H"H"
H"@EUUUP@@@BH"H"H @"H"H"H"H"H"H"H"H"H"H @@@@P@Q@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@DQD@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@DQDP@
@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"HDQ@@DA@H"H"H"H"H"H"H"H"H"H"H"H"H"H"AD@DQ@PD@"H"H"H"H"H"H"H"H"H"H"H"H"H"A@P@ADA@@"H"H"H"H"
H"H"H"H"H"H"H"H"H"@DADQ@PD@"H"H"H"H"H"H"H"H"H"H"H"H"H Q@QDQDQ@PBH"H"H"H"H"H"H"H"H"H"H"H"H PDQDQD@D@BH"H"H"H"H"H"H"H"H"H"
H"H"HDPDQDQDA@PBH"H"H"H"H"H"H"H"H"H"H"H"HD@DQDQD@D@@H"H"H"H"H"H"H"H"H"H"H"H"HDADQDQDA@A@@"H"H"H"H"H"H"H"H"H"H"H"@DADQDQD
PD@D@"H"H"H"H"H"H"H"H"H"H"H"A@@DQDQ@A@ADPBH"H"H"H"H"H"H"H"H"H"H"A@Q@ADP@P@QDPBH"H"H"H"H"H"H"H"H"H"H"@DQDP@@DQ@Q@@BH"H"H"
H"H"H"@@@BH"H"H PDQDQ@A@P@P@UPH"H"H"H"H"H UUUPH"H"H @@ADQD@DQ@@EUU@"H"H"H"H"HEUUUU@@H @EUU@DQD@@P@AUUU@"H"H"H"H"HEUUUUUU
@EUUUUT@Q@@DQ@UUUU@"H"H"H"H"HEUUUUUUUUUUUUUP@@A@Q@AUUPH"H"H"H"H"HEUUUUUUUUUUUUUP@@PDQDAUTBH"H"H"H"H"HEUUUPUUUUUUUUUP@DA@
QD@E@"H"H"H"H"H"H UUT@@@UUUUUU@@A@PDQDP@H"H"H"H"H"H"H"@@@"H"@@@@@@A@@DADPDPBH"H"H"H"H"H"H"H"H"H"H"H"H@@DA@Q@QDXBH"H"H"H"
H"H"H"H"H"H"H"H"H A@@DADQF@BH"H"H"H"H"H"H"H"H"H"H"H"H @D@DQDX@DBH"H"H"H"H"H"H"H"H"H"H"H"H"@QDFY @ADPH"H"H"H"H"H"H"H"H"H"
H"H"H @@@@D@DQD@@"H"H"H"H"H"H"H"H"H"H"H"H@DAD@DQDP@A@BH"H"H"H"H"H"H"H"H"H"H@@ADQD@@@@Q@PD@H"H"H"H"H"H"H"H"H"H @@@QD@@@@@
@PDQ@PH"H"H"H"H"H"H"H"H @A@QDQDQDQDP@A@PDA@"H"H"H"H"H"H"H"HADQD@@QDADPDQ@@@AD@@"H"H"H"H"H"H"H"H@@QDP@QDQDQDADQD@D@@"H"H"
H"H"H"H"H"HET@DA@A@A@P@QDQD@@P@"H"H"H"H"H"H"H"AUUP@P@@D@DADQDQ@PD@@"H"H"H"H"H"H"H"AUUU@@@@@@@QDQ@PD@@P@"H"H"H"H"H"H"H"HE
UUT@@@@ADQDQDA@@D@H"H"H"H"H"H"H"H"HEUUUP@@@QDPDADP@A@@H"H"H"H"H"H"H"H"H UUT@@@DQDQ@P@A@P@BH"H"H"H"H"H"H@@BH"AUUP@@DA@P@@
@PD@@"H"H"H"H"H"H"A&Y @"HET@@@@@@@@@@@@@H"H"H"H"H"H"H Y&Y&XBH A&Y UUAP@@@@@"H"H"H"H"H"H"HFY&Y&Y H"A&Y UUUUUPH"H"H"H"H"H"
H"H"HFY&Y&Y H"A&Y AUUUUU@"H"H"H"H"H"H"H"HFY&Y&Y&@"HFY @EUUUUTBH"H"H"H"H"H"H"H@Y&Y&Y&@@H@@@@@AUUUTBH"H"H"H"H"H"H"H A&Y&A 
@@@@@@A&XEUPA H"H"H"H"H"H"H"H"@@A X@@@@@@@A&Y @FY&@"H"H"H"H"H"H"H"H@@@@@@@@@@@A&Y&A&Y&XBH"H"H"H"H"H"H"H"@@@@@@A&Y&XFY&XF
Y&Y H"H"H"H"H"H"H"H"H"@@@@Y&Y&Y @@@FY&X@@"H"H"H"H"H"H"H"H"H @FY&Y&Y&Y @@@@@@@"H"H"H"H"H"H"H"H"H"@FY&Y&Y&XF@@@@A&@"H"H"H"
H"H"H"H"H"H"HFY&Y&Y&Y @@@@Y&@"H"H"H"H"H"H"H"H"H"HFY&Y&Y&X@@@@@Y&@BH"H"H"H"H"H"H"H"H"H A&Y&Y&A @@@@Y @"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 54; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O? @@@@@@G?>@@@@@@C??<@@@@@L???#0@@@CO??=>@@@@_????0@@@G????>@@@@_???? @@@@????8@@@@G????
@@@@A???/0@@@@_??3<@@@@O??<?@@@@G??>G0@@@C???!!<@@@@???0_@@@@C??8G0@@@@??<A<@@@@O?>@_@@@@A?? G @@@@_?8@0@@@@A??@@@@@@@C?8
@@@@@@@_?@@@@@@@C?8@@@@@@A??@@@@@@@_?0@@@@@@G?<@@@@@@C?? @@@@@@??8@@@@@@_?>@@@@@@G??0@@@@@A??>@@@@@@??? @@@@@O??<@@@@@C?
??@@@@@@???0@@A<@_??>@@@? G???0@@_?O???<@@G??????@@A?????? @@_?????0@@G?????8@@@?????<@@@G ???>@@@@@@G?? @@@@@@??8@@@@@@
O?>@@@@@@A??0@@@@@@??>@@@@@@_??0@@@@@???>@@@@@???? @@@A????<@@@@?????@@@@O????0@@@C????<@@@A?????@@@@_????0@@@C????8@@@@
????>@@@@G????@@@C0???? @@A?G???0@@@?8???0@@@_?G??@@@@G?1??8@@@A?>O??@@@@_?;??0@@@C????>@@@@_????0@@@C????>@@@@O????0@@@
@_???>@@@@A???? @@@@O???8@@@@A???>@@@@@_???0@@@@C???8@@@@@@@@@@@') ; yourself); yourself]
! !

!WalkingGirl::Girl class methodsFor:'walking right'!

walkingRight
    "Picture Sequence walking to the right.
     Retruns an array of arrays with picture name and offset.
    "
    ^ #(
        ( #walkingRight001 20) 
        ( #walkingRight002 20)
        ( #walkingRight003 20) 
        ( #walkingRight004 20)
        ( #walkingRight005 20) 
        ( #walkingRight006 20) 
    )
!

walkingRight001
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingRight001 inspect
     ImageEditor openOnClass:self andSelector:#walkingRight001
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingRight001'
        ifAbsentPut:[(Depth4Image new) width: 73; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"H"
H"H"H @@@@@"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@@H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@@@BH"H"H"H"
H"H"H"@BH"H"H"H"H"H"H"H"H"H"H @@@@@@@@@@@BH @"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"H"H@@@@@@@@@@@@BH@H"H"H"H"H"H@H"H"H"H"H"H"H"
H"H"H"H @@@@@@I&X @@@@@"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"H"@@@@@@@&Y&Y"@@@@H"H"H"H"H"H @"H"H"H"H"H"H"H"H @@@@@@@@@FY&H@@@@@
H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"@@@@@@@@@@@FY&Y&XBH"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H@@@@@@@@@@@Y&Y&Y H"H"H"H"H"H"H"H @"H"H"H"
H"H"H"H @@@@@@@@@@@@I&Y"@BH"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H@@@@@H@@@@@@AY&@CHBH"H"H"H"H"H"H"@BH"H"H"H"H"H"H"@@@@@"@@@@I"I&
Y"@@@"H"H"H"H"H"H"H @"H"H"H"H"H"H"H@@@@"H"@@@FA&Y&Y"A&@"H"H"H"H"H"H"H@H"H"H"H"H"H"H"@@@@@"H@@@D @FY&Y&Y&@"H"H"H"H"H"H"@B
H"H"H"H"H"H"H @@@@H"H @BXFY&Y&Y&X@H"H"H"H"H"H"H @"H"H"H"H"H"H"@@@@H"H"H @FY&Y&Y&Y H"H"H"H"H"H"H"H@H"H"H"H"H"H"H @@@@H"H"
H H@A&Y&A&HBH"H"H"H"H"H"H"@BH"H"H"H"H"H"H @@@BH"H"H Y&Y&Y&@@@BH"H"H"H"H"H"H @"H"H"H"H"H"H"H@@@@"H"H"HBA&Y&Y&@BH"H"H"H"H"
H"H"H@H"H"H"H"H"H"H @@@BH"H"H"H@@VY&Y @"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H@@@@"H"H"H QDP&H@@"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H@
@BH"H"H A@AD@@H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"H"H"ADQ@@BT"H"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"H"H PDQD@@H"H"H"H"
H"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"H"HDADQD@BH"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"H"H PDQDQDP@H"H"H"H"H"H"H"H"H"@BH"H"H"H"
H"H"H"H"H"H"A@QDQDQ@PBH"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"H"A@QDQDPD@"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"H"H PDQDQDQ@
@"H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"H"@DPDQDP@A@@"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"A@QDADP@QDQB@"H"H"H"H"H"H"H"H@H"
H"H"H"H"H"H"H"H"H Q@Q@@DADQ@A@H"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H"HDPDPD@DQ@A"@BH"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H"H"@@AD
P@@DQBY&XBH"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"@@X@AD@@QBE&Y&X@H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H@Y&X@ADP@QBY&Y&Y @"H"H@H"H"
H"H @"H"H"H"H"H"H"H"H A&Y"@DQDP@@&Y&Y&Y&@@@@Y @"H"H"H@H"H"H"H"H"H"H"H"@FY&Y H@QD@@A&Y&Y&Y&Y&Y&Y&@"H"H"@BH"H"H"H"H"H"H"H@
Y&Y"@BADQ@P@@@@FY&Y&Y&Y&Y H"H"H @"H"H"H"H"H"H"H Y&Y&XBH"@DPDA@P@@@A&Y&Y&Y&XBH"H"H@H"H"H"H"H"H"@@A&Y&X@H"H QDP@Q@P@@ @FY&
Y&Y&@"H"H"@BH"H"H"H"H @FY&Y&X@H"H"H Q@Q@QDPBH"@@Y&Y&Y H"H"H @"H"H"H"H"A&A&Y&X@H"H"H"ADQDADQD@"H"H@Y&Y&@"H"H"H@H"H"H"H"HF
Y A&Y @"H"H"H ADQ@QDQ@H"H"H A&XBH"H"H"@BH"H"H"H"A&@@Y&@BH"H"H A&ADADQDPBH"H"H @@H"H"H"H @"H"H"H"H Y A&Y H"H"H @B\6@DQDQD
@"H"H"H"H"H"H"H"H@H"H"H"H"HFXFY&@"H"H @QDB]7\ @@@@H"H"H"H"H"H"H"H"@BH"H"H"H"HFA&XBH"H"@P@Q@@I7]7]7\BH"H"H"H"H"H"H"H @"H"
H"H"H"H@@@H"H"HADQ@PDP@B]7]7H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"D@@PDA@P@@@@@@@"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H"H DQ@QDQ
DA@PDQD"H"H"H"H"H"H"H"H @"H"H"H"H"H"H"H"H"HADADADPDADADPH"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H DQ@Q@A@A@A@QDBH"H"H"H"H"H"H"
H"@BH"H"H"H"H"H"H @@@ADADAD@@@DADP@BH"H"H"H"H"H"H"H @"H"H"H"H"H"H"HADQDQ@QDQDQDQD@D@H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"@ADP
DA@QDADADPDP@PH"H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"@Q@Q@QDQDQDQ@P@PDP@"H"H"H"H"H"H"H @"H"H"H"H"H"H"H @PDPDQ@Q@PDA@A@QDQ@"H"H"
H"H"H"H"H@H"H"H"H"H"H"H"H DQ@QDQDQDA@@@@DQD@H"H"H"H"H"H"H"@BH"H"H"H"H"H"H"H@DQDPDQ@PD@@ADQDP@"H"H"H"H"H"H"H @"H"H"H"H"H"
H"H"@@DQDQ@@@@@QDQDP@F@"H"H"H"H"H"H"H@H"H"H"H"H"H"H"HFX@DADQ@ADQDPDP@@Y H"H"H"H"H@@BH"@BH"H"H"H"H"H"@ Y&X@D@@QDQDQDQD@A&
Y H"H"H"H A7\BH @"H"H"H"H"H"HGA&Y"@@@ADQDQDP@@@@I&XBH"H"H"@G]7\BH@H"H"H"H"H"H ]7A&X@@BH@@@@@@"H"@FY&XBH"H"H ]7]7@"@BH"H"
H"H"H"@G]7A @BH"H"H"H"H"H"@&Y&@"H"H"A7]7]0H @"H"H"H"H"H A7]3@@H"H"H"H"H"H"H"A&Y&@"H"H A7]7\BH@H"H"H"H"H"@@A7]7@"H"H"H"H"
H"H"H A&Y&@@H"HG]7]7@"@BH"H"H"H"H \@A7] H"H"H"H"H"H"H"H A&Y&A0H A7]7]0H @"H"H"H"H"A7\@@C@"H"H"H"H"H"H"H"H"A&@G]0A0Y7]7@"
H@H"H"H"H"H ]7]7@BH"H"H"H"H"H"H"H"H A"Y7@@@@@G\@H"@BH"H"H"H"HG]0@@@BH"H"H"H"H"H"H"H"H @7]2@@@@@@@"H @"H"H"H"H"A7@@@@@BH"
H"H"H"H"H"H"H"HF]7@@@@@@@@H"H@H"H"H"H"H \@@@@@@@@"H"H"H"H"H"H"H"@C\ @@@@@@@"H"@BH"H"H"H"H @@@B]7]6@BH"H"H"H"H"H"H"@@@G]0
@@@BH"H @"H"H"H"H"H @@A7]7]7XBH"H"H"H"H"H"H"@@M7]0@@H"H"H@H"H"H"H"H"H@@'']7]7]7L"H"H"H"H"H"H"H"@F]7@@@"H"H"@BH"H"H"H"H"H@
@G]7]7]6@"H"H"H"H"H"H"H @7]2@BH"H"H @"H"H"H"H"H"@@\G]7]7M H"H"H"H"H"H"H"H A''@@H"H"H"H@H"H"H"H"H"H"@@\CI L''L"H"H"H"H"H"H"
H"H"H"H"H"H"H"@BH"H"H"H"H"H"@@@@@@@F@BH"H"H"H"H"H"H"H"H"H"H"H"H ') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 66 255 132 132 255 255 255]; mask:((ImageMask new) width: 73; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O<@@@@@@@@@@@G?8@@@@@@@@@@O?>@@@@@@@@@@O??1 @@@@@@@@C??>X@@@@@@@@A?;/<@@@@@@@@@?=>?@@@@
@@@@O??;?@@@@@@@@G???>@@@@@@@@C????@@@@@@@@A???^0@@@@@@@@_;??:@@@@@@@@G<?S7 @@@@@@@C<G?><@@@@@@@@?#=?? @@@@@@@O8N??8@@@@
@@@G8A??8@@@@@@@A?@K?:@@@@@@@@O0A??0@@@@@@@C<@W?0@@@@@@@A>@C?<@@@@@@@@_ A=\@@@@@@@@C0A?8@@@@@@@@@@@?4@@@@@@@@@@@O?@@@@@@
@@@@@C?0@@@@@@@@@@A??@@@@@@@@@@@??0@@@@@@@@@@G?<@@@@@@@@@@A?? @@@@@@@@@@??<@@@@@@@@@@??> @@@@@@@@@O??8@@@@@@@@@C??6@@@@@
@@@@@??70@@@@@@@@@??7?@@@@@@@@@_?>?<C@@@@@@@O7?/??<@@@@@@G?_???? @@@@@C>7????8@@@@@A?0????>@@@@@G?8O?=?? @@@@O?8A?>G?8@@
@@G?8@?? _<@@@@C?<@O?8A>@@@@@?>@O?>@O@@@@@O?@N?? @@@@@@C? O7/8@@@@@@@_0G?_>@@@@@@@C8C?>?@@@@@@@@@@???<@@@@@@@@@O??<@@@@@
@@@@C???@@@@@@@@@A???0@@@@@@@@O???>@@@@@@@@C????@@@@@@@@@????8@@@@@@@@G???? @@@@@@@A????<@@@@@@@@O????@@@@@@@@C???? @@@@
@@@@????<@@@@@@@@_????@@^@@@@@/????8@O0@@@@_7???^@G>@@@@O?3? ?0A? @@@G?0@@E<@?8@@@A?8@@@? O>@@@@?<@@@O?C? @@@O?@@@A?9?8@
@@G? @@@G??<@@@A?0@@@A7??@@@@_>@@@@O7? @@@G?0@@@C??8@@@A?? @@@=?<@@@@O7>@@@G?>@@@@A??0@@@??@@@@@]?<@@@G? @@@@C?? @@A>0@@
@@@??8@@@O8@@@@@G;,@@@@@@@@@@@??0@@@@@@@') ; yourself); yourself]
!

walkingRight002
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingRight002 inspect
     ImageEditor openOnClass:self andSelector:#walkingRight002
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingRight002'
        ifAbsentPut:[(Depth4Image new) width: 64; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H @@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@BH"H@@@
@@@@H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@@@"@@@@@@@@@BH"H"H"H"H"H"H"H"H"H"H @@@@@@@@@@@@@@@@@@@@@"H"H"H"H"H"H"H"H"H"H @@@@@B@@
@@@@@@@@@@@@@BH@H"H"H"H"H"H"H"H"H"@@@@H"H @@@@@@@@@@@@@@H @"H"H"H"H"H"H"H"H"@@@@H"H"H@@@@@@@UUT@@@@@@"H"H"H"H"H"H"H"H"@@
@@@"H"H @@@@@@UUUUT@@@@BH"H"H"H"H"H"H"H"H@@@@BH"H@@@@@@@UUT@@@@@@"H"H"H"H"H"H"H"H"H"@@@@H"H @@@@@@AUUUUUTBH"H"H"H"H"H"H"
H"H"H"H"@@@"H"@@@@@@@EUUUUTBH"H"H"H"H"H"H"H"H"H"H"H @"H"H@@@@@@@AUUU@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@EUU@C@"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H@@@@ETEUUT@@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@@E@EUUUU@ETBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H@@@T@AUUUUU
UU@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@AUAUUUUUUU@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H @@UUUUUUUU@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@
\@AUUUAU@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @EUUUUUP@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HGAUUUUU@@H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H @@@EUUUP@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H Q@A@@@@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H QDP@@@@BH"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"@@ADQ@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"ADP@ADQ@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@DPDQ@QD@"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"HDPDQD@@PBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H PDQDQ@@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H A@QDQDADPBH"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H"@DADQDQ@Q@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@PDQDQDADPBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"ADA@QDQD
PDQ@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HDPDADQDQ@QD@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H@A@@DQDQDADQ@H"H"H"H"H"H"H"H"H"H"H"H"H"H"HD
PD@@QDP@@DQ@@"H"@@@"H"H"H"H"H"H"H"H"H"H"H@QDA@A@@DQ@ADP@H"AUUPH"H"H"H"H"H"H"H"H"H"H QDP@@@QDQDPDPD@"AUUUTBH"H"H"H"H"H"H"
H"H"H"ADQD@@QDQD@@Q@@@AUUUUU@"H"H"H"H"H"H"H"H"H"HDQDP@A@@@@@@@@EUUUUUUTBH"H"H"H"H"H"H"H"H"H"ADQ@@@@EUUUUUUUUUUUUUPH"H"H"
H"H"H"H"H"H"H"H Q@@@@EUUUUUUUUUUUUUP@"H"H"H"H"H"H"H"H"H"H"H@@D@EUUUUUUUUT@@EUU@"H"H"H"H"H"H"H"H"H"H"H@DQA@AUUUUUUU@@H@@@
@"H"H"H"H"H"H"H"H"H"H"H@DQA@@EUUUUUP@BH"H"H"H"H"H"H"H"H"H"H"H"H"H DADPP@AUUU@@@BH"H"H"H"H"H"H"H"H"H"H"H"H"H DA@QDF@@@@@@
PBH"H"H"H"H"H"H"H"H"H"H"H"H"H"@A@QDQA @@@@@@H"H"H"H"H"H"H"H"H"H"H"H"H"H"HA@PDA@@X@A X@H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @PDA
D@X@@@X@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@@DA@P@@@@@@@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H@DA@QDP@QDQ@@H"H"H"H"H"H"H"H"H"H"H"H"H 
@@H"@A@PDADQDQ@P@BH"H"H"H"H"H"H"H"H"H"H"H A&X@@@@PDQDQDQDP@PH"H"H"H"H"H"H"H"H"H"H"H @FY A @@DA@QDADQDQ@"H"H"H"H"H"H"H"H"
H"H"H @FY A X@@A@PDQDQDQ@BH"H"H"H"H"H"H"H"H"H"H"@@A A X@T@@ADADQDADP@"H"H"H"H"H"H"H"H"H"H"@@@@@@X@UUT@@@DQDADQDBH"H"H"H"
H"H"H"H"H"H"H@@@@@X@UUUUUP@@DQDQD@H"H"H"H"H"H"H"H"H"H"H@@@@@A&AUUUUUUP@ADQDQ@"H"H"H"H"H"H"H"H"H"H @@@@@FX@@EUUUUUP@@@QDB
H"H"H"H"H"H"H"H"H"H A @@@@A @@AUUUUUUUT@DPH"H"H"H"H"H"H"H"H"H"A&Y&@@@@@@@@AUUUUUUU@P@"H"H"H"H"H"H"H"H"H"H@Y&Y&XBH"H @@AU
UUUUUP@BH"H"H"H"H"H"H"H"H"H Y&Y&X@H"H"H@@@AUUUUU@BH"H"H"H"H"H"H"H"H"H"@FY&Y H"H"H"@@@@@EUU@"H"H"H"H"H"H"H"H"H"H"HFA&Y&@"
H"H"H@@@@@@@@BH"H"H"H"H"H"H"H"H"H"H A&Y&XBH"H"H @@@@@@@@H"H"H"H"H"H"H"H"H"H"H"H@Y&Y H"H"H"H@@@@@@@H"H"H"H"H"H"H"H"H"H"H"
H"@FA H"H"H"H @@A&Y&@"H"H"H"H"H"H"H"H"H"H"H"H"@@H"H"H"H Y&Y&Y @"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H @FY @@@"H @@@"H"H"H"H"
H"H"H"H"H"H"H"H"H"H @F@@@F@"H@Y&Y H"H"H"H"H"H"H"H"H"H"H"H"H"H A&A XFA @FY&Y&XBH"H"H"H"H"H"H"H"H"H"H"H"H"A&Y XF@@@FY&Y&Y 
H"H"H"H"H"H"H"H"H"H"H"H"H"HFY&@@@@@@Y&Y&Y&@"H"H"H"H"H"H"H"H"H"H"H"H"H A&X@@@@@A Y&Y&XBH"H"H"H"H"H"H"H"H"H"H"H"H"@@X@@@@@
@@XFA @BH"H"H"H"H"H"H"H"H"H"H"H"H"H @@@@@@@@@@@@@BH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 64; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@X@@@@@@@@@O<@@@@@@@@A?8@@@@@@@@O?0_?@@@@@A??''?>@@@@@O????<@@@@A?7???3@@@@G8O???L@@@@?@_??? @@@G
<A???>@@@@_0_??? @@@@?A???0@@@@@<G??>@@@@@A _??8@@@@@@@??? @@@@@@C???@@@@@@@G??>@@@@@@@_??<@@@@@@@???0@@@@@@A??<@@@@@@@C
??0@@@@@@@O??@@@@@@@@_?8@@@@@@@A?? @@@@@@@O?8@@@@@@@A?>@@@@@@@@G? @@@@@@@@??@@@@@@@@G?<@@@@@@@@_?0@@@@@@@A??@@@@@@@@O?>@
@@@@@@@??8@@@@@@@G??0@@@@@@@???@@@@@@@C??<@@@@@@@_??8@@@@@@C??? <@@@@@_???G8@@@@A???<?0@@@@G????? @@@@_????>@@@@@?????8@
@@@A????? @@@@C????<@@@@@_???_ @@@@C???0@@@@@@O??>@@@@@@A???0@@@@@@G???@@@@@@@_??8@@@@@@A??? @@@@@@G??>@@@@@@@_??8@@@@@A
8???0@@@@@O????@@@@@A????<@@@@@O????0@@@@@????? @@@@G????>@@@@@_????8@@@@C????? @@@@O????>@@@@A?????8@@@@G????? @@@@_>A?
?>@@@@A?8C??0@@@@G?@G?<@@@@@_<@_?0@@@@A?0A??@@@@@C?@C?8@@@@@G8@O? @@@@@G@A?<@@@@@@@@O?!!<@@@@@@A?<_8@@@@@@O???0@@@@@@????
@@@@@@C???<@@@@@@O???0@@@@@@???>@@@@@@A???0@@@@@@@@@@@@@') ; yourself); yourself]
!

walkingRight003
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingRight003 inspect
     ImageEditor openOnClass:self andSelector:#walkingRight003
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingRight003'
        ifAbsentPut:[(Depth4Image new) width: 63; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H"@@@@@@@BH"H"H"
H"H"H"H H"H"H"H"H"H"H"H"H"H @@@@@@@@@"H"H"H"H"H"H"@"H"H"H"H"H"H"H"H"@@@@@@@@@@@@H"H"H"H"H"H"HBH"H"H"H"H"H@@@@"@@@@@@@@@@
@@@"@BH"H"H"H"H H"H"H"H"H"H@@@@@@@@@@@@@@@@@@BH@H"H"H"H"H"@"H"H"H"H"H@@@@@@@@@@@@EUU@@@@@@H"H"H"H"H"JBH"H"H"H"H@@@@@@@@@
@@@EUUUU@@@@@"H"H"H"H"H H"H"H"H"H@@@@@@@@@@@@EUU@@@@@@H"H"H"H"H"H"@"H"H"H"H@@@@@@@@@@@@@UUUUUU@"H"H"H"H"H"H"HBH"H"H"H @@
@BH @@@@@@AUUUUU@"H"H"H"H"H"H"H H"H"H"H"@@@BH"@@@@@@@@UUUP@BH"H"H"H"H"H"H"@"H"H"H"H@@BH"H @@@@@@AUUP@0H"H"H"H"H"H"H"HBH"
H"H"H @@H"H"@@@@AUAUUU@@@BH"H"H"H"H"H"H H"H"H"H @@@"H"H @@APAUUUUPAU@"H"H"H"H"H"H"@"H"H"H"@@@BH"H"@@@E@@UUUUUUUPH"H"H"H"
H"H"HBH"H"H"@@@BH"H"H @@UPUUUUUUUP@"H"H"H"H"H"H H"H"H"H@@BH"H"H"H@@EUUUUUUUPH"H"H"H"H"H"H"("H"H"H"@BH"H"H"H"@G@@UUUPUP@"
H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H@AUUUUUT@@BH"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"A0UUUUUP@BH"H"H"H"H"H"H"@"H"H"H"H"H"H"H"H"H@@@
AUUUT@H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"HD@@P@@@@BH"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H QD@@@@@"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H"
H"H PDQ@@BH"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H QDADQ@@"H"H"H"H"H"H"H"H"H(H"H"H"H"H"H"H"H QDP@QDPBH"H"H"H"H"H"H"H"H" "H"H"
H"H"H"H"H"A@ADPDQ@H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"A@QDQD@D@"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H@QDQDPD@BH"H"H"H"H"H"H"H"
H"("H"H"H"H"H"H"H ADQDQ@QD@"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H ADQDQDADPBH"H"H"H"H"H"H"H"H H"H"H"H"H"H"H @DQDQDPDQ@H"H"H"H"
H"H"H"H"H"@"H"H"H"H"H"H"AD@DQDPDQDPBH"H"H"H"H"H"H"H"HBH"H"H"H"H"H"ADQDADP@QDQ@H"H"H"H"H"H"H"H"H H"H"H"H"H"H"ADQDQ@Q@QDQD
@"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H@@DQDA@QDQDQ@H"H"H"@@@BH"H"H"HBH"H"H"H"H"H AUADQ@@DQDQD@"H"H"AUUU@"H"H"H(H"H"H"H"H"H"AUUP
QDA@QDQDQ@H"H"AUUUTBH"H"H"@"H"H"H"H"H"AUUU@@@DADQDQD@"H"AU@EUU@"H"H"HBH"H"H"H"H"AUUUT@@DQ@QDQDPBH @EUPUUTBH"H"H H"H"H"H"
H"HEUUT@@DQ@ADQDPD@@UUAUAUUPH"H"H"@"H"H"H"H"H UUUUTDADPDQDQ@AUUUTE@EUU@"H"H"HBH"H"H"H"H"AUUUUUA@P@QDQ@UUUUUP@EUU@"H"H"H 
H"H"H"H"H"H UUUUUPQDADQDAUUUUP@@@@@"H"H"H"@"H"H"H"H"H"HEUUUUT@@DQDPEUUT@H"H"H"H"H"H"HBH"H"H"H"H"H AUUUUUT@@DQ@UU@BH"H"H"
H"H"H"H H"H"H"H"H"H"@@AUUUUUUU@@AP@"H"H"H"H"H"H"H"@"H"H"H"H"H"H@@@AUUUUUUUT@@"H"H"H"H"H"H"H"J"H"H"H"H"H"H @@@@@EUUUUUU@B
H"H"H"H"H"H"H"H H"H"H"H"H"H"@@XF@@@EUUUUT@H"H"H"H"H"H"H"H"@"H"H"H"H"H"@@@FA X@@EUUUPH"H"H"H"H"H"H"H"HBH"H"H"H"H"H@DP@@XF
@@AUUU@"@BH"H"H"H"H"H"H H"H"H"H"H"H@@A@P@@@@@@UU@@@Q@"H"H"H"H"H"H"@"H"H"H"H"H @A@PD@@@@A@@@QDQ@@H"H"H"H"H"H"HBH"H"H"H"H"
@@@QD@@@DA@PDADQAUTBH"H"H"H"H"H/H"H"H"H"H"H@@PD@@PDA@PDQDQAUUU@"H"H"H"H"H"@"H"H"H"H"H @@DQ@@DA@PDQDPAUUUTBH"H"H"H"H"HBH"
H"H"H"H"@@@ADP@@@QDQDAAUUUUPH"H"H"H"H"H(H"H"H"H"H"H@@@@QDA@QDQDA@EAUUU@"H"H"H"H"H"@"H"H"H"H"H"@@@PDQDQDQDQ@A@EUU@"H"H"H"
H"H"JBH"H"H"H"H"H@@@DADQDQ@P@A@EUUTBH"H"H"H"H"H H"H"H"H"H"H"@@@A@PDA@PD@@EUUTBH"H"H"H"H"H"@"H"H"H"H"H"H @@@PDA@@@@@@AUUP
H"H"H"H"H"H"HBH"H"H"H"H"H"@@@@@@@@@@@@AUUPH"H"H"H"H"H"H H"H"H"H"H"H"H"@@@@@@@@@FX@UU@"H"H"H"H"H"H" "H"H"H"H"H"H"H"@@@@@@
@FY UU@"H"@@@BH"H"H"HBH"H"H"H"H"H"H"H"H@@@D@Y XE@"H"A&Y&@"H"H"H H"H"H"H"H"H"H"H"H @@@@Y&@@@@H"A&Y&Y H"H"H"@"H"H"H"H"H"H"
H"H @@UUA&@@A&@"@FY&Y&@"H"H"HBH"H"H"H"H"H"H"H"@@UUA&@FY&X@@FY&Y&XBH"H"H H"H"H"H"H"H"H"H"AUUUA&XFY&Y @FY&Y&Y H"H"H"@"H"H"
H"H"H"H"H"@EUUA&Y Y&X@@@Y&Y&Y @"H"H"HBH"H"H"H"H"H"H"A&@@A&Y&@@@@@@A&Y&Y @"H"H"H H"H"H"H"H"H"H"HFY&@FY&@@A @@@@Y&A @BH"H"
H" "H"H"H"H"H"H"H@@FX@@@@@A&X@@@@FA @BH"H"H"HBH"H"H"H"H"H"H @@@@@@A&A&Y&@@@F@@@"H"H"H"H H"H"H"H"H"H"H A&Y @@A&X@Y&X@@@@@
H"H"H"H"H"@"H"H"H"H"H"H"@FY @@@FY&A&Y @@@"H"H"H"H"H"HBH"H"H"H"H"H"H@Y&@@@FY&Y @@@@H"H"H"H"H"H"H(H"H"H"H"H"H"H @FX@@@A&Y&
Y @F@"H"H"H"H"H"H"@"H"H"H"H"H"H"H@@@@@@@@@@@@@@"H"H"H"H"H"H"HBH"H"H"H"H @"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H ') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 63; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@G?0@@@@@@@A?? @@@@@@@???@@@@@@_''??<0@@@@C????3@@@@@_????8@@@@C????? @@@@_????8@@@@C????<@@@@@O
1??? @@@@@>G??>@@@@@C0O??8@@@@@O@???0@@@@A<A??? @@@@G0G???@@@@@>@O??<@@@@C0@_??@@@@@F@@??<@@@@@@@C??0@@@@@@@G?>@@@@@@@@_
?8@@@@@@@C?>@@@@@@@@O? @@@@@@@A?0@@@@@@@@O? @@@@@@@A?>@@@@@@@@G?8@@@@@@@@?? @@@@@@@C?>@@@@@@@@O?<@@@@@@@A??0@@@@@@@O??@@
@@@@@@??>@@@@@@@G??8@@@@@@@??? @@@@@@C???@G0@@@@O??<@? @@@@???8G>@@@@G??? ?<@@@@???>O?0@@@C??????@@@@O?????<@@@@?????? @
@@A?????<@@@@C????@@@@@@O???0@@@@@@???<@@@@@@C??? @@@@@@O??>@@@@@@@???8@@@@@@G???@@@@@@@_??<0@@@@@C???? @@@@@O????@@@@@@
????>@@@@@C????<@@@@@O????0@@@@@?????@@@@@C????<@@@@@G???? @@@@@_???>@@@@@@????0@@@@@A????@@@@@@G???8@@@@@@G??? @@@@@@G?
?<G0@@@@@C?? ? @@@@@O??G?@@@@@A??<?<@@@@@G????0@@@@@?????@@@@@G????<@@@@@????? @@@@C????>@@@@@_????0@@@@A????<@@@@@O????
@@@@@@???? @@@@@C???8@@@@@@O??? @@@@@@_??<@@@@@A @@@@@@@') ; yourself); yourself]
!

walkingRight004
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingRight004 inspect
     ImageEditor openOnClass:self andSelector:#walkingRight004
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingRight004'
        ifAbsentPut:[(Depth4Image new) width: 73; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"JBH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@BH"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@@@BH"H"H"H"
H"H"H"T"H"H"H"H"H"H"H"H"H"H"H @@@@@@@@@@@BH"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"@@@@@@@@@@@@@"@BH"H"H"H"H"IRH"H"H"H"H"H"H"
H"H @@H@@@@@@@@@@@@@H @"H"H"H"H"H"@"H"H"H"H"H"H"H"@@@@@@@@@@@@AUUP@@@@@BH"H"H"H"H"H$H"H"H"H"H"H"H"H@@@@@@@@@@@@EUUUU@@@@
@"H"H"H"H"H"IRH"H"H"H"H"H"H @@@@@@@@@@@@UUT@@@@@@"H"H"H"H"H"H"@"H"H"H"H"H"H"@@@@@@@@@@@@@EUUUUUPH"H"H"H"H"H"H"H H"H"H"H"
H"H"H@@@@@@@@@@@@@AUUUUU@"H"H"H"H"H"H"H"KBH"H"H"H"H"H"@@@@@@@@@@@@@@AUUU@@H"H"H"H"H"H"H"H"@"H"H"H"H"H"H@@@@@@BH@@@@@@@UU
T@LBH"H"H"H"H"H"H"H!!H"H"H"H"H"H"@@@@@@@"@@@@AUAUUU@@@BH"H"H"H"H"H"H"HBH"H"H"H"H"H @@@@@@H"@@@E@EUUUU@ETBH"H"H"H"H"H"H"<"
H"H"H"H"H"@@@@@@@"H @@AP@EUUUUUUTBH"H"H"H"H"H"H''H"H"H"H"H"H@@@@@@@H"H @@UPUUUUUUUP@"H"H"H"H"H"H"HBH"H"H"H"H"@@@@@@@BH"H 
@@UUUUUUUU@"H"H"H"H"H"H"H"@"H"H"H"H"H"@@@@@@H"H"H A0@EUUTET@H"H"H"H"H"H"H"H!!H"H"H"H"H"H @@@ @"H"H"H AUUUUUT@@BH"H"H"H"H"
H"H"HBH"H"H"H"H"H@@BH"H"H"H"HGAUUUUU@@H"H"H"H"H"H"H"H"@"H"H"H"H"H"H@H"H"H"H"H P@@@UUUU@BH"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"
H"H"H"HDQ@@@@@@BH"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H"H @DQ@@@@BH"H"H"H"H"H"H"H"H","H"H"H"H"H"H"H"H"H"H AD@@QD@"H"H"H"H"
H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"ADP@@@QD@"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"H"H@ADQD@DQ@H"H"H"H"H"H"H"H"H"H"0"H"H"H"H"
H"H"H"H"H PDQDQD@DPBH"H"H"H"H"H"H"H"H"H(H"H"H"H"H"H"H"H"H @DQDQDQ@P@@"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"H"@@QDQDQDPDP@@"
H"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H"H"HDQ@QDQDQDADPD@"H"H"H"H"H"H"H"H"H)H"H"H"H"H"H"H"H ADPDQDQDP@QDA@H"H"H"H"H"H"H"H"H"HBH"
H"H"H"H"H"H"@@ADPDQDQ@ADQ@Q@H"H"H"H"H"H"H"H"H"X"H"H"H"H"H"H"HET@QDAD@@@DQDQ@P@H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H UUT@QD@@@@
ADQDP@APH"H"H"H"H"H"H"H"J"H"H"H"H"H"H"AUUUTDQ@ADP@QDQD@EUP@"H"H"H"H"H"H"H"P"H"H"H"H"H"HEUUUU@D@DA@PDQDQ@AUUU@"H"H"H"H"H"
H"H H"H"H"H"H"H"AUUUT@@@PDA@QDQDP@UUUU@BH"H"H"H"H"H"HBH"H"H"H"H"HEUUT@@ A@PDQ@QDQD@EUUUUTBH"H"H"H"H"H" "H"H"H H @ UUUP@"
HDA@QDQDQDQ@H@UUUUT@H"H"H"H"H"H H"H"H APAUAUUP@BH"@DQDQDADQD@"H @EUUUP@"H"H"H"H"HBH"H"@EUPUUUU@BH"H PDQDQDQDPBH"H"H@UUUU
@@@"H"H"H"@"H"H UUAUUUT@H"H"H@QDQDQDQD@"H"H"H AUUUUU@"H"H"H%H"H"HET@UUUP@"H"H"A@QDQDPDPBH"H"H"H"AUUUUU@"H"H"HBH"H"AUUUUU
@BH"H"H ADQDQDQD@"H"H"H"H"AUAUUPH"H"H"D"H"H"AUUUT@H"H"H"HDA@QDQDPBH"H"H"H"H UPAUTBH"H"H H"H"H"@@@@H"H"H"H"@@A@PDQD@"H"H"
H"H"HEUPUU@"H"H"J2H"H"H"H"H"H"H"H"H@Y @@@DA@H"H"H"H"H"HETEUPH"H"H"\"H"H"H"H"H"H"H"H"@@Y&Y @@@BH"H"H"H"H"H@UU@"H"H"H H"H"
H"H"H"H"H"H"HA@@@@Y&Y&XBH"H"H"H"H"H @BH"H"H"HBH"H"H"H"H"H"H"H DA@Q@@@@@@H"H"H"H"H"H"H"H"H"H"H"0"H"H"H"H"H"H"H"@PDQDQ@PD@
@BH"H"H"H"H"H"H"H"H"H"H%H"H"H"H"H"H"H"H @PDQ@Q@PD@@"H"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H"@A@QDQDA@P@PH"H"H"H"H"H"H"H"H"H"
H"@"H"H"H"H"H"H"H DA@PDQD@@ADBH"H"H"H"H"H"H"H"H"H"H%H"H"H"H"H"H"H"@@DADQDP@QDQ@"H"H"H"H"H"H"H"H"H"H"HBH"H"H"H"H"H"H @PDA
DPDA@QDA@"H"H"H"H"H"H"H"H"H"H"<"H"H"H"H"H"H"@@@PDQDQDADQDPH"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H @A@PDADQ@A@QDPH"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"@@@ADPDQDQ@ADQDPH"H"H"H"H"H"H"H"H"H"@"H"H"H"H"H"H T@@ADPDADQD@@QDPH"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"
AU@@@A@PDADQDP@QDPH"H"H"H"H"H"H"H"H"JBH"H"H"H"H"H UU@@@@@PDA@PDQ@P@BH"H"H"H"@@@"H"H"H"@"H"H"H"H"H"AUUU@@@@@@DA@QDP@@@"H"
H"H"HFY&@"H"H"H H"H"H"H"H"HEUUUU@@@QDPDA@P@@UU@"H"H"H Y&Y&@"H"H"J"H"H"H"H"H UUUUTBH @AD@@A@@AUUU@"H"H"A&Y&X@H"H"H"("H"H"
H"H"A UUT@H"H"@@@@@@@EUUUPH"H"H Y&Y&XBH"H"H/H"H"H"H"HFY UPH"H"H"H"H"H"AUUUUPH"H"HFY&Y @"H"H"HBH"H"H"H A&Y @"H"H"H"H"H"H"
AUUUUPH"H Y&Y&Y H"H"H"@"H"H"H"A A&XBH"H"H"H"H"H"H"@EUUUPH"H@Y&Y&@BH"H"H H"H"H"HFY A H"H"H"H"H"H"H"H"HEUUA H @FA&X@@"H"H"
IBH"H"H Y&Y @@H"H"H"H"H"H"H"H"HETFY @@@FA X@H"H"H"T"H"H"HFY @@@@H"H"H"H"H"H"H"H"H@Y&Y @@@FA @"H"H"H H"H"H"A&@@@@@@@@H"H"
H"H"H"H"H"A&Y&@@@@@F@@H"H"H"HBH"H"H @@@@@@A&Y H"H"H"H"H"H"H"A&X@@@@@@@@"H"H"H"0"H"H"H @@@@A&Y&Y H"H"H"H"H"H"H"A A @@@@@B
H"H"H"H H"H"H"H @@@FY&Y&Y H"H"H"H"H"H"H"@FY @@@@H"H"H"H"HRH"H"H"H @@XFY&Y&XBH"H"H"H"H"H"H Y&Y @@@"H"H"H"H"@"H"H"H"H @@XF
Y&Y&@"H"H"H"H"H"H"H@Y&Y @BH"H"H"H"H''H"H"H"H"H@A XFA X@H"H"H"H"H"H"H"A Y @@H"H"H"H"H"I2H"H"H"H"H@@@@@@@@"H"H"H"H"H"H"H"A 
@@@"H"H"H"H"H"@"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H ') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 73; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G?0@@@@@@@@@@G?>@@@@@@@@@@O??0@@@@@@@@@G??<0@@@@@@@A;???L@@@@@@@G????>@@@@
@@@C????? @@@@@@A????? @@@@@@@?????@@@@@@@@_???? @@@@@@@G????8@@@@@@@C?3??>@@@@@@@@?<???0@@@@@@@O?G??>@@@@@@@G?!!???0@@@@
@@C?8O??<@@@@@@@?>A??<@@@@@@@G?@O??@@@@@@@A= A??0@@@@@@@^@@_?8@@@@@@@C@@O?>@@@@@@@@@@C?>@@@@@@@@@@A?>@@@@@@@@@@A?<@@@@@@
@@@@@?? @@@@@@@@@@_?8@@@@@@@@@@O?>@@@@@@@@@@O?? @@@@@@@@@G??<@@@@@@@@@C??? @@@@@@@@A???8@@@@@@@@@????@@@@@@@@@_???8@@@@@
@@@O????@@@@@@@@G????<@@@@@@@C????? @@@@@@@?????>@@@@@@@_=????0@@@@@I/<_??_?@@@@@O?>G??!!?<@@@@G?>A??0C?<@@@A??@_?<@O? @@
@_? G?>@@?<@@@G?0A?? @G?@@@@?8@_?0@A?0@@@G8@G?<@@_<@@@@@@C??@@C?@@@@@@@??0@@_ @@@@@@_?>@@A0@@@@@@O??@@@@@@@@@@G??0@@@@@@
@@@A??<@@@@@@@@@@???@@@@@@@@@@O??0@@@@@@@@@G??<@@@@@@@@@A??? @@@@@@@@@???8@@@@@@@@@O???@@@@@@@@@G???8@@@@@@@@A????@@@@@@
@@@????8@@@@@@@@O???>@@<@@@@@G???? @_ @@@@C????<@O<@@@@A?1??? G?@@@@@?8G??8A?0@@@@_8@@G?@_<@@@@O<@@@?8O?@@@@G>@@@G?C?0@@
@C?@@@@_9?<@@@A?8@@@C???@@@@_?@@@@_?? @@@G??@@@G??8@@@A??8@@@??<@@@@O??@@@G?>@@@@A??8@@@??@@@@@O?>@@@O? @@@@A?? @@C?0@@@
@@_?8@@@?8@@@@@C?<@@@G<@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

walkingRight005
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingRight005 inspect
     ImageEditor openOnClass:self andSelector:#walkingRight005
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingRight005'
        ifAbsentPut:[(Depth4Image new) width: 59; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H%
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H 
H"H"H"H"H"H"H"H"H"H"H"@@@@@@@BH"H"H"H"H H"H"H"H"H"H"H"H"H"H"H@@@@@@@@@H"H"H"H"H(H"H"H"H"H"H@@@@"H"H@@@@@@@@@@@@"H"H"H"H 
H"H"H"H"H"@@@@@@H"@@@@@@@@@@@@@"@BH"H"H H"H"H"H"H@@@@@@@@ @@@@@@@@@@@@@"@BH"H"H H"H"H"H"@@@@@@@@@@@@@@@@UUT@@@@@@"H"H"H 
H"H"H"H @@@@@@@@@@@@@@@EUUUU@@@@@"H"H"H(H"H"H"H@@@@@@"H@@@@@@@AUUP@@@@@BH"H"H"H H"H"H"@@@@@@H"H@@@@@@@AUUUUUTBH"H"H"H"H 
H"H"H @@@@@BH"H @@@@@@AUUUUU@"H"H"H"H"H*H"H"H @@@@@"H"H @@@@@@@EUUT@@"H"H"H"H"H H"H"H @@@@H"H"H"@@@@@@@EUU@C@"H"H"H"H"H 
H"H"H"@@@@H"H"H"@@@@AUAUUU@@@BH"H"H"H"H H"H"H"H@@@H"H"H"H@@@T@UUUUT@UPH"H"H"H"H(H"H"H"H@@@H"H"H"H@@@T@AUUUUUUU@"H"H"H"H)
H"H"H"H @BH"H"H"H @@UPUUUUUUUP@"H"H"H"H H"H"H"H"H"H"H"H"H"@@AUUUUUUUTBH"H"H"H"H H"H"H"H"H"H"H"H"H"H@\@AUUUAU@BH"H"H"H"H 
H"H"H"H"H"H"H"H"H"H AUUUUUT@@BH"H"H"H"H%H"H"H"H"H"H"H"H"H"H \EUUUUT@@"H"H"H"H"H H"H"H"H"H"H"H"H"H"H"@@@EUUUP@"H"H"H"H"H 
H"H"H"H"H"H"H"H"H"H QD@@@@@BH"H"H"H"H"H*H"H"H"H"H"H"H"H"H"H@ADP@@@H"H"H"H"H"H"H H"H"H"H"H"H"H"H"H"@@@@QD@"H"H"H"H"H"H"H 
H"H"H"H"H"H"H"H"H PDQDADPBH"H"H"H"H"H"H%H"H"H"H"H"H"H"H"H QD@DPDPBH"H"H"H"H"H"H H"H"H"H"H"H"H"H"HDQ@QDP@PBH"H"H"H"H"H"H 
H"H"H"H"H"H"H"H"HDPDQDQ@@BH"H"H"H"H"H"H H"H"H"H"H"H"H"H"HD@DQDQ@PBH"H"H"H"H"H"H H"H"H"H"H"H"H"H"@@ADQDQ@PBH"H"H"H"H"H"H 
H"H"H"H"H"H"H"H"ADPDQDQ@PBH"H"H"H"H"H"H$H"H"H"H"H"H"H"H QDQ@QDQ@Q@H"H"H"H"H"H"H(H"H"H"H"H"H"H"H @@QDADPDQ@H"H"H"H"H"H"H 
H"H"H"H"H"H"H"H T@ADA@ADQ@H"H"H"H"H"H"H H"H"H"H"H"H"H"HEUU@DP@QDQD@"H"H"H"H"H"H H"H"H"H"H"H"H"HEUUTDPDQDQD@"H"H"H"H"H"H 
H"H"H"H"H"H"H"AUUP@@A@QDQD@"H@@@@"H"H"H(H"H"H"H"H"H"H"AUUUUPPDQDQD@ AUTETBH"H"H H"H"H"H"H"H"H"HEUUUUADQDQ@@EAUTEUPH"H"H 
H"H"H"H"H"H"H"HEUUUUTDQDP@TET@AUUPH"H"H H"H"H"H"H"H"H"H@UUUUUPQDPETEAUUUUPH"H"H H"H"H"H"H"H"H"H@@EUUUUAD@@TE@EUUUPH"H"H(
H"H"H"H"H"H"H"H@P@AUUUTD@ @E@EUUUPH"H"H"H"H"H"H"H"H"H"@@A@@@UUUP@"H@@@UUTBH"H"H H"H"H"H"H"H"H@@@XDP@AUUU@"H"H @@@"H"H"H 
H"H"H"H"H"H @A@AA P@@EUU@"H"H"H"H"H"H"H H"H"H"H"H"HA@PDPDF@@AUUUTBH"H"H"H"H"H"H H"H"H"H"H"@P@A@Q@@XEUUUUTBH"H"H"H"H"H"H 
H"H"H"H"H"@@@@DADP@EUUUUTBH"H"H"H"H"H"H H"H"H"H"H @@DPDQDQDEUUUU@"H"H"H"H"H"H"H H"H"H"H"H @A@Q@A@@@@UUUU@"H"H"H"H"H"H"H&
H"H"H"H"H @PDADPDPD@AUUP@"H"H"H"H"H"H"H H"H"H"H"H @A@QDADPDP@@@@H"H"H"H"H"H"H"H H"H"H"H"H @@DA@Q@@@Q@Q@@H"H"H"H"H"H"H"H 
H"H"H"H@@@D@@PD@@@@@@@@"H"H"H"H"H"H"H"H H"H"H"A&X@@P@@DADQ@QDA@"H"H"H"H"H"H"H"H H"H"H Y&X@@A@A@ADPDQ@P@"H"H"H"H"H"H"H"H$
H"H"H Y&X@@PDA@QDQDQDP@BH"H"H"H"H"H"H"H(H"H"H Y&Y @A@PDADPDADQD@H"H"H"H"H"H"H"H H"H"H @@X@@@DADPDQDQDQDQ@"H"H"H"H"H"H"H 
H"H"H @@@@@@@PDADQDQ@QDQ@"H"H"H"H"H"H"H H"H"H @@@@@@@A@QDQDQDQD@@"H"H"H"H"H"H"H H"H"H@@@@@@@@@@A@PDQD@@E@"H"H"H"H"H"H"H(
H"H"@F@@@@H"H"@@DA@P@@UU@"H"H"H"H"H"H"H H"H A X@@@H"H"H @@@@AUUU@"H"H"H"H"H"H"H H"H XFY @BH"H"H"@AAUUUUPH"H"H"H"H"H"H"H 
H"HFA&Y&@BH"H"H"H UUUUTBH"H"H"H"H"H"H"H H"H@Y&Y&XBH"H"H"HEUUUP@"H"H"H"H"H"H"H"H(H"HFA&Y&@"H"H"H"A UU@BH"H"H"H"H"H"H"H"H"
H"H@Y&Y&@"H"H"H Y&AP@"@@@BH"H"H"H"H"H"H H"H@A&Y H"H"H"HFY&X@H Y&Y @"H"H"H"H"H"H H"H XF@BH"H"H"@@Y&@@@FY&Y&XBH"H"H"H"H"H 
H"H"@@H"H"H"H Y @@@@A&Y&Y&Y H"H"H"H"H"H H"H"H"H"H"H"H Y&X@@@Y&Y&Y&Y H"H"H"H"H"H H"H"H"H"H"H"H Y&@@@FA&Y&Y&Y H"H"H"H"H"H 
H"H"H"H"H"H"H A&@@@@XFY&Y&XBH"H"H"H"H"H H"H"H"H"H"H"H @F@@@FA XFA XBH"H"H"H"H"H&H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H 
') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 59; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G?0@@@@@@@A?? @@@@@?@???@@@@@G?G??<0@@@A?>???3@@@@O
?????8@@@A?????? @@@O>O???8@@@A?0???<@@@@O>A??? @@@@?0G??>@@@@C>@O??8@@@@G8@???0@@@@O A??? @@@@>@G???@@@@A0@O??<@@@@@@@_
??@@@@@@@@??<@@@@@@@A??0@@@@@@@G?>@@@@@@@@O?8@@@@@@@A?>@@@@@@@@O? @@@@@@@A?8@@@@@@@@O?0@@@@@@@@??@@@@@@@@G?<@@@@@@@@_?0@
@@@@@@A??@@@@@@@@O?<@@@@@@@@??0@@@@@@@G?? @@@@@@@_?>@@@@@@@A??8@@@@@@@O??0@@@@@@@???@@@@@@@G??<_ @@@@@_??7?@@@@@@????>@@
@@@C????8@@@@@O???? @@@@@????>@@@@@C??/?8@@@@@_?>O?@@@@@G??8C8@@@@A??? @@@@@@O???@@@@@@A???<@@@@@@G???0@@@@@@???>@@@@@@C
???8@@@@@@O??? @@@@@@???<@@@@@@C???0@@@@@C???<@@@@@@_???0@@@@@C????@@@@@@O???>@@@@@@????<@@@@@C????8@@@@@O???? @@@@@????
>@@@@@G????8@@@@@?8G?? @@@@G? G?>@@@@@_<@O?0@@@@C?0@O>@@@@@O?@A?0@@@@@?8@O<@@@@@C? A?''0@@@@O<@O<?0@@@@_ A??? @@@@8@O???@
@@@@@@???<@@@@@@C???0@@@@@@O??>@@@@@@@???8@@@@@@@@@@@@@@') ; yourself); yourself]
!

walkingRight006
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self walkingRight006 inspect
     ImageEditor openOnClass:self andSelector:#walkingRight006
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WalkingGirl::Girl class walkingRight006'
        ifAbsentPut:[(Depth4Image new) width: 54; height: 84; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H @@@@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@@@BH"H"H"H"H"H"H"H"H"H"H"H"@@@@@@@@@@@@H"H"H"H"H"H"H"H"H"H@@BH @@@@@@@@@@@@
H @"H"H"H"H"H"H"H"@@@@H@@@@@@@@@@@@@H @"H"H"H"H"H"H"H @@@@@@@@@@@EUU@@@@@@H"H"H"H"H"H"H"H@@@@@@@@@@@AUUUUP@@@@H"H"H"H"H"
H"H"H@@@@@@@@@@@UUT@@@@@@"H"H"H"H"H"H"H"H@@@@@@@@@@@UUUUUU@"H"H"H"H"H"H"H"H"@@@@@@@@@@@@UUUUUPH"H"H"H"H"H"H"H"H"@@@@H@@@
@@@@AUUU@@H"H"H"H"H"H"H"H"H"@@@@H @@@@@@AUUP@0H"H"H"H"H"H"H"H"H"@@@@H @@@@UPUUUP@@@"H"H"H"H"H"H"H"H"@@@BH"@@@E@EUUUU@ETB
H"H"H"H"H"H"H"H"@@@BH"@@@E@@UUUUUUUPH"H"H"H"H"H"H"H"@@@BH"H@@ETEUUUUUUT@H"H"H"H"H"H"H"H"@@@BH"H @@UUUUUUUU@"H"H"H"H"H"H"
H"H"@@@BH"H"@G@@UUUPUP@"H"H"H"H"H"H"H"H"@@@BH"H"H@UUUUUU@@@"H"H"H"H"H"H"H"H"H@@BH"H"HGAUUUUU@@H"H"H"H"H"H"H"H"H"H @"H"H"
H@@@AUUUT@H"H"H"H"H"H"H"H"H"H"H"H"H"AD@D@@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H QDP@@@@"H"H"H"H"H"H"H"H"H"H"H"H"H"H@@DQDP@H"H"H"
H"H"H"H"H"H"H"H"H"H"H"A@P@ADPBH"H"H"H"H"H"H"H"H"H"H"H"H"H PDADP@Q@H"H"H"H"H"H"H"H"H"H"H"H"H"H A@Q@@DA@H"H"H"H"H"H"H"H"H"
H"H"H"H"H PDADQ@P@H"H"H"H"H"H"H"H"H"H"H"H"H"HDADQDQDAD@"H"H"H"H"H"H"H"H"H"H"H"H"H@P@QDQDPD@"H"H"H"H"H"H"H"H"H"H"H"H"HDA@
QDQDPDPBH"H"H"H"H"H"H"H"H"H"H"H"@@P@QDQDP@PBH"H"H"H"H"H"H"H"H"H"H"H A@A@QDQDQ@PBH"H"H"H"H"H"H"H"H"H"H"H P@PDQDQDQ@P@H"H"
H"H"H"H"H"H"H"H"H"HDQ@A@ADQDP@A@H"H"H"H"H"H"H"H"H"H"H"HDQD@D@DQ@ADA@H"H"H"H"H"H"H"H"H"H"H"H@ADADP@@DQDP@H"H"H"H"H"H"H"H"
H"H"H"AU@D@DA@ADQDPD@"H"H"H@@@H"H"H"H"H"H UUT@ADP@QDQ@@@@"H"H"AUUU@"H"H"H"H"H UUUP@D@@QDP@UUT@@"@@UUUUTBH"H"H"H"H UUUUAD
P@AD@EUUUUT@UUUUUUTBH"H"H"H"H"AUUPADA@@@AUUUUUUUUUUUUUTBH"H"H"H"H"HEUPQDPD@@AUUUUUUUUUUUUUTBH"H"H"H"H"H T@QDA@P@AUUUUUUU
UUAUUUTBH"H"H"H"H"H"@DQDPDA@@@UUUUUU@@@EUU@"H"H"H"H"H"H"HDPDQ@P@A@@@@@@@H"H @@H"H"H"H"H"H"H"HFQDADA@P@@BH"H"H"H"H"H"H"H"
H"H"H"H"H@YDQ@P@A@@"H"H"H"H"H"H"H"H"H"H"H"H"HA@FQDP@P@@"H"H"H"H"H"H"H"H"H"H"H"H"@QD@A&XADPH"H"H"H"H"H"H"H"H"H"H"H"H @ADQ
@A@@@@@"H"H"H"H"H"H"H"H"H"H"H"H@D@@QDQ@ADA@BH"H"H"H"H"H"H"H"H"H"H"@A@PDP@@@ADQD@@BH"H"H"H"H"H"H"H"H"H"@PDQ@P@@@@@ADP@@@"
H"H"H"H"H"H"H"H"H DA@PD@@QDQDQDQDPD@@"H"H"H"H"H"H"H"H @AD@@@DQ@QDADP@ADQDBH"H"H"H"H"H"H"H @A@ADQDADQDQDP@QDP@BH"H"H"H"H"
H"H"H @P@ADQDP@PD@D@DA@ETBH"H"H"H"H"H"H"H @A@PDQDQDA@A@@@PAUUPH"H"H"H"H"H"H"H @P@A@PDQDP@@@@@@UUUPH"H"H"H"H"H"H"H"@A@@DA
DQDQD@@@@EUUTBH"H"H"H"H"H"H"H"@@D@@QDA@QDP@@AUUUTBH"H"H"H"H"H"H"H"H@@PD@@PDQDQ@@@EUU@"H"H"H"H"H"H"H"H"H @A@P@@@PDA@@AUUP
H"H@@BH"H"H"H"H"H"H"@@@@@@@@@@@@@ETBH A&Y H"H"H"H"H"H"H"H @@@@APUUA&Y @"HFY&Y&@"H"H"H"H"H"H"H"H"AUUUUUA&Y H"A&Y&Y&XBH"H"
H"H"H"H"H"H UUUUUPA&Y H"A&Y&Y&XBH"H"H"H"H"H"H"HEUUUUT@A&XBH Y&Y&Y&XBH"H"H"H"H"H"H"HEUUUP@@@@@B@@Y&Y&Y&@BH"H"H"H"H"H"H"A 
AUTFY @@@@@@A Y&Y @"H"H"H"H"H"H"H Y&X@A&Y @@@@@@@FA @@H"H"H"H"H"H"H"HFY&Y Y&Y @@@@@@@@@@@BH"H"H"H"H"H"H"A&Y&XFY&XFY&Y @@
@@@@H"H"H"H"H"H"H"H @FY&X@@@A&Y&Y&@@@@H"H"H"H"H"H"H"H"H @@@@@@A&Y&Y&Y&X@@"H"H"H"H"H"H"H"H"H Y @@@@XFY&Y&Y&X@H"H"H"H"H"H"
H"H"H"H Y&@@@@A&Y&Y&Y&XBH"H"H"H"H"H"H"H"H"H@Y&@@@@@FY&Y&Y&XBH"H"H"H"H"H"H"H"H"H A&@@@@A Y&Y&Y @"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"') ; colorMapFromArray:#[0 0 0 0 0 255 132 132 0 132 255 255 255 0 0 255 132 132 255 255 255 255 132 66]; mask:((ImageMask new) width: 54; height: 84; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A?<@@@@@@A?? @@@@@C??<@@@@C1???L@@@A>???3@@@@????? @@@_????8@@@G????8@@@A????0@@@@????8@@
@@O7??>@@@@C<??? @@@@?O??<@@@@O!!??? @@@C8_??<@@@@>C???@@@@O _??@@@@C8C??0@@@@>@_?<@@@@G G?>@@@@@0A?? @@@@@@?? @@@@@@_?@@
@@@@@O? @@@@@@G?0@@@@@@C?>@@@@@@@?? @@@@@@O?8@@@@@@G??@@@@@@A??0@@@@@@_?>@@@@@@O?? @@@@@G??8@@@@@A???@@@@@@???0@@@@@O??<
@@@@@C???@@@@@A???8@>@@@???>@_0@@O???<?>@@C?????? @@_?????8@@C?????>@@@_????? @@C?????0@@@_???A8@@@G?? @@@@@A??0@@@@@@_?
<@@@@@@O?>@@@@@@G??0@@@@@C??>@@@@@A???<@@@@@_???0@@@@O???? @@@C????<@@@@?????@@@@O????0@@@C????>@@@@????? @@@G????0@@@A?
???<@@@@O???>@@@@A????C0@@@O???#>@@@@???1?0@@@@??8?>@@@@_?>O? @@@O??G?8@@@C??7?>@@@A?????@@@@????? @@@_????0@@@O????0@@@
G???? @@@A???? @@@@_???0@@@@G???8@@@@C???>@@@@@_???@@@@@@@@@@@@@') ; yourself); yourself]
! !

!WalkingGirl::Girl methodsFor:'accessing'!

damage
   "Return the actual damage.
    That is the rectangle to be restored in the view.
    The damage is the old, last generation bounds.
   "
   ^ damage.
! !

!WalkingGirl::Girl methodsFor:'action animate'!

animateStep
    "Do one step in animation.
     That means calculating the new picture index
     and setting the new picture (image).
     Also calculating the new position (bounds).
     Save the old bounds as damage area to repair.
     Detect collision with bounds of the view.
     On collision, sequence is changed to walk
     other direction.
    "
    |
     actual "{ Class:Array }"
    |

    "/ Calculate new index.
    index  := 1 + (index \\ sequence size).

    actual := sequence at:index.

    "/ Set new picture.
    image  := self class perform:actual first.

    "/ Remember old bounds as damage.
    damage := bounds copy.

    "/ Calculate and set new position.
    bounds setLeft:(bounds left + actual second).

    "/ Check for collision on right edge.
    (view width < bounds right)
         ifTrue:[
             sequence := self class walkingLeft.
         ].

    "/ Check for collision on left edge.
    (         0 > bounds left)
         ifTrue:[
             sequence := self class walkingRight.
         ].
! !

!WalkingGirl::Girl methodsFor:'displaying'!

displayOn:aDrawable
    "Draw the actual image on a drawable.
    "

    image displayOn:aDrawable
                  x:bounds left
                  y:bounds top.
! !

!WalkingGirl::Girl methodsFor:'initialization'!

initialize
    "Set defaults for instance variables.
    "
    super initialize.

    sequence := self class walkingRight.
    index    := 1.
    image    := self class walkingRight001.
    bounds   := image bounds.
    damage   := bounds.
! !

!WalkingGirl::Girl methodsFor:'private instance creation'!

on:aView at:aPosition
   "Put the Girl at a position on a view.
    Private - Only use for instance creation.
   "
   view := aView.

   bounds setLeft:(aPosition x - (bounds width  // 2)).
   bounds setTop: (aPosition y - (bounds height // 2)).
! !

!WalkingGirl class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Animation/WalkingGirl.st,v 1.4 2016-05-13 00:21:53 mawalch Exp $'
! !

