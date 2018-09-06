"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

AbstractSourceCodeManagementSettingsAppl subclass:#PerforceSourceCodeManagementSettingsAppl
	instanceVariableNames:'selectedPerModuleRoot perforceExecutableHolder
		listOfPerforceModules defaultSettingsHolder tableColumns
		defaultSettingsPrototypeList checkLabel'
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

ApplicationModel subclass:#ManagerPerModuleApp
	instanceVariableNames:'moduleHolder acceptChannel settingsHolder
		sourceCodeManagementSettingsApp acceptEnableChannel canceled
		defaultSettingsPrototypeList'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PerforceSourceCodeManagementSettingsAppl
!

Object subclass:#ModuleManager
	instanceVariableNames:'manager module settings app check checkIcon'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PerforceSourceCodeManagementSettingsAppl
!

!PerforceSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PerforceSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon4.
    "/ ^ self defaultIcon3

    "Created: / 21-12-2011 / 12:35:05 / cg"
!

defaultIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'PerforceSourceCodeManagementSettingsAppl class defaultIcon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHA@PHA@0D@@@D@@@@@@@@@@@@@@ TFA XFA \B@@@C@ HB@ @@@@@@
@@HIB (IBP(IA@LB@ $JBPH@@@@@@@@BBP(LCPXJB $N@!!@JB!!@B@@@@@@@@@!!@PCP@@D!!@PA (PBP(P@ @@@@@@@@HPDAH@@ALPDA@PD@(PD@H@@@@@@@@B
EQ@VB (WDA@PEQLMEP(B@@@@@@@@@!!TWEQ$ZE1\WEQ@@F1$S@ @@@@@@@@HZEQ@SF1TUEQT\@AXZA H@@@@@@@@BF!!4S@@4ZF!!4Q@@@^G00B@@@@@@@@@!!8^
D2@^F!!(G@@@QH"L$IPH@@@@@@@H''G!!TUG" )AR(EJ2L,KR4B@@@@@@@B@!!D/LBL"H#D1LRH2H3L4@ @@@@@@@@@BJ3L6KB0,KB0#H2L#H0H@@@@@@@@@@ HB
@ HB@ HBH#(-@ HB@@@@@@@@@@@@@@@@@@@@@#(4KPH@@@@@@@@@@@@@@@@@@@@@@@H=O H@@@@@@@@@@@@@@@@@@@@@@@@B@ HB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 240 240 240 224 232 250 208 232 250 224 240 250 160 192 210 128 176 200 144 176 200 160 192 220 144 176 210 112 160 180 128 160 180 160 200 220 128 168 200 160 184 210 208 224 240 176 208 220 112 152 180 176 200 220 144 184 210 144 168 200 192 216 240 112 144 170 128 152 180 112 144 180 128 168 180 96 136 170 112 136 170 144 168 180 192 216 220 96 136 160 96 128 160 48 112 140 176 192 220 144 184 220 16 96 130 32 96 130 144 200 220 192 232 250 176 216 250 96 120 140 80 120 140 80 128 160 112 168 200 80 136 170 32 104 140 96 152 180 128 184 210 96 144 170 48 104 140 16 88 120 32 104 130 16 88 130 0 80 100 176 224 250 32 96 140 144 192 220 160 208 240 160 208 220 16 80 120 80 144 170 80 144 180 0 64 100 0 72 100 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@G?H@G?O G?? G?? G''? G''? G?? G?7 G?7 G/'' G?O0G??0G??0A??0A??0@@_@@@^@@@^@@@@@@@@@');
                            yourself);
                yourself
        ]
!

defaultIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'PerforceSourceCodeManagementSettingsAppl class defaultIcon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AH@@@@@@@@@@@@@QUUV@@@@@@@@@@A%UUUUUX@@@@@@BUUUUUUUUUTP@@@HUUUUUUUUUUUU$@@@@@UUUU
UUUU$@@@@@@@@FUUUUT@@@@@@@@@@@AUUZ@@)B@@@@@@H@@BL@BUUV @@@BEUU @@HUUZP@@@@YUUUUQ!!%UY@@@@@@@$UUUUUUVP@@@@@@@@@BUUUU@@QUP@
@@@@@@@AU@B%UP@@@@@@A0@@@@EUP@@@@@@@UUU@@DUY@@@@@@@UUUUUUUV@@@@@@@JH$VUUUU @@@@@@@@@@@@HYY@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 255 248 248 240 200 104 255 216 160 255 248 240 240 192 64 240 168 24 240 176 48 255 240 224 255 224 176 255 208 136 255 232 208 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@A @@G8@@_?@C??0O??<@?? @O<@@C88@!!#<C<O0G??@C?>@@O8<@A30@PG @>O@C?>@G?<@@A8@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
!

defaultIcon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon3 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon3
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'PerforceSourceCodeManagementSettingsAppl class defaultIcon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHA@PHA@0D@@@D@@@@@@@@@@@@@@ PEAPTEAPXB@@@C@ HB@ @@@@@@
@@HGB@ GA0 GBPLB@ \HA0H@@@@@@@@BA0 JB0THB@\L@ 4HB@4B@@@@@@@@@ 4MB0@@C 4MAP MA0 M@ @@@@@@@@HMCP8@@@<MCP4MCP MCPH@@@@@@@@B
D@4QB@ RCP4MD@<KD@ B@@@@@@@@@!!@RDALTD!!HRD@4@EQLO@ @@@@@@@@HTM#X3L1@PDA@V@ADTAPH@@@@@@@@BL3X6M#X3EA\X@@@YF (B@@@@@@@@L#X6
C1,YECLF@@@XGA4^G0H@@@@@@CL4L1@PFRD"ABLDIA4%I"XB@@@@L3L6MSX7JA48GB$)JQ0*GR,,@ @@@@@3MSX3IB,8NC %IRT]GQ4]GPH@@@@@@CL<@ H8
N3,:N@HBGB8&@ HB@@@@@@@@@@@8NC$8NC @@"8,I H@@@@@@@@8@@@@@@@8N@@@@@H/L@H@@@@@@@@@@C 8NC 8NCD@@@@B@ HB@@@@@@@@@@@@NS 8NCD@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 247 247 247 239 243 252 231 243 252 239 247 252 191 215 227 199 215 227 207 223 237 183 207 217 191 207 217 207 223 232 191 211 227 207 219 232 231 239 247 183 203 217 199 219 232 199 211 227 183 199 212 191 203 217 183 199 217 175 195 212 183 195 212 199 211 217 223 235 237 175 195 207 215 227 237 175 191 207 151 183 197 215 223 237 135 175 192 143 175 192 199 227 237 223 243 252 175 187 197 167 187 197 167 191 207 183 211 227 167 195 212 143 179 197 175 203 217 175 199 212 151 179 197 135 171 187 143 179 192 135 171 192 127 167 177 143 175 197 135 167 187 127 159 177 127 163 177 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@G?H@G?O G?? G?? G''? G''? G?? G?7 G?7 G?'' G?O0G??0_??0O??0G??0@?_@HL^@G<^@C8@@@@@@');
                            yourself);
                yourself
        ]
!

defaultIcon4
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon4 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon4
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'PerforceSourceCodeManagementSettingsAppl class defaultIcon4'
        ifAbsentPut:[
            (Depth8Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AUUUUUU @@@@@@@@@@@@@@@@@@
@@@@U(F.+Y]QJ@@@FB\$(P@@@@@@@@@@@ET)H#U7JS]IFRX)S%\@@@@@@@@@@@@SO6B1E1F+$C5SJSYB@@@@@@@@@@@@D:>MW)>Y_P!!;#8HI\0@@@@@@@@@@
@D@)J!!R0& 0])J"CG!!0@@@@@@@@@@@AAJ08J^VM_(1TP_7 G@@@@@@@@@@@@-;^4-J2NM@=5$'':)@@@@@@@@@@@@-K^7-;^4^&T2@C1OK@@@@@@@@@@@,;^7
SBB''%+P@''HY/%E$K@@@@@@@@@KR5-@YPHR4A''X]0JU)DSZH@@@@@-KR7-+^8@D"9\WE[CTU!!K0L3@@@@@@B4-+^4@@B9.[$@@C@Z)X0@@@@@@@@@@KR=@@B9
/K2;.PBJWT]K@@@@@@@@@@@@@@B9.[*9.[$@@H,[@@@@@@@@@@B9@@@@@@B9.P@@@@@@@@@@@@@@@@@@@K&9.[&9.[H@@@@@@@@@@@@@@@@@@@@@.+&9.[H@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 207 52 214 168 55 233 238 244 117 121 125 215 219 225 217 222 228 166 169 170 185 189 193 118 113 66 175 127 29 172 137 46 183 143 46 186 146 50 149 132 77 212 161 47 102 106 106 233 202 75 244 197 63 237 243 249 253 208 64 244 197 65 116 121 116 236 242 248 141 145 139 212 219 146 193 198 148 232 179 53 146 149 152 164 168 171 127 97 27 138 106 37 200 204 209 180 136 36 187 140 37 209 152 33 214 218 223 219 166 45 223 228 234 240 194 60 240 194 64 138 131 107 230 183 62 239 191 65 230 184 63 120 122 121 213 164 49 232 237 244 104 109 109 251 215 73 225 231 235 162 166 166 180 184 188 153 111 25 175 126 27 185 134 29 186 141 39 223 228 223 217 221 226 223 227 230 232 237 235 255 235 80 227 199 81 236 241 247 232 185 63 253 216 78 253 217 79 131 135 134 230 234 240 215 159 40 232 182 60 216 221 223 96 97 95 154 158 159 178 183 183 144 110 31 199 204 209 163 130 45 175 133 40 205 150 34 203 156 46 134 121 82 223 172 50 228 233 234 232 183 60 236 243 248 253 216 79 254 241 108 123 127 129 233 184 62 255 196 50 232 182 57 118 122 120 216 220 226 211 164 51 161 167 160 102 81 27 139 107 33 147 120 48 166 132 45 167 134 50 212 217 221 94 100 98 227 233 231 224 229 234 228 183 56 253 208 63 237 243 247 238 243 250 231 235 242 234 239 246 254 208 63 240 194 65 216 168 53 114 120 119 217 221 227 148 152 153 227 232 238 178 182 180 143 110 31 171 125 28 118 105 65 173 137 46 205 150 33 214 159 37 224 166 38 221 167 46 223 170 49 231 179 56 235 239 244 245 203 72 238 190 64 233 181 58 232 184 62 128 131 126 255 230 77 215 162 44 117 121 122 222 227 232 203 152 38 150 153 155 172 176 177 132 102 33 154 121 40 147 118 49 101 101 82 228 233 221 255 235 71 227 233 230 211 164 52 228 233 237 227 181 61 244 196 63 237 242 248 233 182 59 234 184 60 236 241 248 255 205 50 214 166 51 222 226 230 195 202 151 229 233 240 153 156 155 168 172 176 138 101 24 157 117 33 119 99 56 219 225 216 184 158 61 139 130 81 100 101 96 144 149 103 225 175 53 149 154 112 245 200 66 246 202 71 232 184 63 233 183 61 131 134 130 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C@@@C@@@CA<@CA?OCA??CA??CA??CA??CA??CA?>CC?.CG??CG??#_/?#ON^CF_^C@?LCHL@CG<@CC8@C@@@C');
                            yourself);
                yourself
        ]
! !

!PerforceSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PerforceSourceCodeManagementSettingsAppl andSelector:#windowSpec
     PerforceSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     PerforceSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Source Code Manager Settings'
         name: 'Source Code Manager Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 706 596)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel3'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: topSpace
             horizontalSpace: 3
             verticalSpace: 4
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Perforce (P4) Sourcecode Manager Settings'
                   name: 'FramedBox3'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Show in Browser Menus'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 0 0 5 0 -150 1 35 0)
                         activeHelpKey: shownInBrowserMenus
                         model: shownInBrowserMenusHolder
                         translateLabel: true
                       )
                      (ActionButtonSpec
                         label: 'Check'
                         name: 'Button6'
                         layout: (LayoutFrame -150 1 5 0 -5 1 35 0)
                         translateLabel: true
                         labelChannel: checkLabel
                         model: checkPerforceSettings
                       )
                      (ViewSpec
                         name: 'Box3'
                         layout: (LayoutFrame 0 0 41 0 0 1 117 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Default P4 Root'
                               name: 'Label1'
                               layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                               level: 0
                               translateLabel: true
                               adjust: right
                             )
                            (LabelSpec
                               label: '(client:user:pass@host:port) '
                               name: 'Label18'
                               layout: (LayoutFrame 4 0.0 25 0 64 0.25 40 0)
                               style: (FontDescription helvetica medium roman 10)
                               level: 0
                               foregroundColor: (Color 33.0 33.0 33.0)
                               translateLabel: true
                               adjust: right
                             )
                            (ComboBoxSpec
                               name: 'cvsRootComboBox'
                               layout: (LayoutFrame 66 0.25 0 0 -5 1 30 0)
                               tabable: true
                               model: defaultSettingsHolder
                               immediateAccept: true
                               acceptOnLeave: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                               comboList: defaultSettingsPrototypeList
                             )
                            (LabelSpec
                               label: 'Perforce Command:'
                               name: 'Label22'
                               layout: (LayoutFrame 0 0.0 38 0 60 0.25 68 0)
                               level: 0
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'EntryField8'
                               layout: (LayoutFrame 66 0.25 38 0 -5 1 68 0)
                               tabable: true
                               model: perforceExecutableHolder
                               immediateAccept: false
                               acceptOnLostFocus: true
                               acceptChannel: acceptChannel
                               acceptOnPointerLeave: true
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 706 154)
                 )
                (ViewSpec
                   name: 'ManagerSetupBoxx'
                   component: 
                  (SpecCollection
                     collection: (
                      (FramedBoxSpec
                         label: 'Per Module Manager Setup'
                         name: 'PerModuleManagerSetup'
                         layout: (LayoutFrame 0 0 -1 0 0 1 -3 1)
                         labelPosition: topLeft
                         translateLabel: true
                         component: 
                        (SpecCollection
                           collection: (
                            (DataSetSpec
                               name: 'Table1'
                               layout: (LayoutFrame 5 0 5 0 0 1 -30 1)
                               model: selectedPerModuleRoot
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               dataList: listOfModules
                               useIndex: false
                               columnHolder: tableColumns
                               beDependentOfRows: true
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel11'
                               layout: (LayoutFrame 5 0 -30 1 -1 1 0 1)
                               horizontalLayout: fitSpace
                               verticalLayout: center
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Add/Apply'
                                     name: 'Button2'
                                     translateLabel: true
                                     tabable: true
                                     model: addPerModuleRoot
                                     extent: (Point 323 30)
                                   )
                                  (ActionButtonSpec
                                     label: 'Remove'
                                     name: 'Button3'
                                     translateLabel: true
                                     tabable: true
                                     model: removePerModuleRoot
                                     enableChannel: removeEnabled
                                     extent: (Point 323 30)
                                   )
                                  )
                                
                               )
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 706 250)
                 )
                (FramedBoxSpec
                   label: 'Source Cache'
                   name: 'FramedBox2'
                   visibilityChannel: false
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box4'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Source Cache Dir:'
                               name: 'Label23'
                               layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'EntryField9'
                               layout: (LayoutFrame 64 0.25 0 0 0 1 30 0)
                               model: sourceCacheDir
                               immediateAccept: false
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: true
                             )
                            )
                          
                         )
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel12'
                         layout: (LayoutFrame 44 0.25 33 0 0 1 63 0)
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Flush Cache now'
                               name: 'Button4'
                               translateLabel: true
                               tabable: true
                               model: flushSourceCache
                               extent: (Point 221 30)
                             )
                            (ActionButtonSpec
                               label: 'Condense Cache now'
                               name: 'Button5'
                               translateLabel: true
                               tabable: true
                               model: condenseSourceCache
                               extent: (Point 221 30)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 706 107)
                 )
                (ViewSpec
                   name: 'VerboseBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Verbose (Trace Access on Transcript)'
                         name: 'CheckBox6'
                         layout: (LayoutFrame 30 0 5 0 -5 1 35 0)
                         model: verboseSourceCodeAccess
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 706 25)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!PerforceSourceCodeManagementSettingsAppl class methodsFor:'menu specs'!

menuPerModule
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:PerforceSourceCodeManagementSettingsAppl andSelector:#menuPerModule
     (Menu new fromLiteralArrayEncoding:(PerforceSourceCodeManagementSettingsAppl menuPerModule)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Check'
            itemValue: checkPerforceSettings
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!PerforceSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ PerforceSourceCodeManager

    "Created: / 19-04-2011 / 12:52:02 / cg"
! !

!PerforceSourceCodeManagementSettingsAppl class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:PerforceSourceCodeManagementSettingsAppl andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Module'
         labelButtonType: Button
         usePreferredWidth: true
         width: 100
         minWidth: 100
         model: module
         menuFromApplication: false
       )
      (DataSetColumnSpec
         label: 'Settings'
         labelButtonType: Button
         editorType: InputField
         model: settings
         menuFromApplication: false
         isResizeable: false
       )
      (DataSetColumnSpec
         label: 'Check'
         labelButtonType: Button
         model: check
         menuFromApplication: false
         doubleClickedSelector: doubleClick
         isResizeable: false
       )
      )
    
! !

!PerforceSourceCodeManagementSettingsAppl methodsFor:'actions'!

addModule:aModuleManager

    |detectedManager|

    detectedManager := self listOfModules detect:[:eachModuleManager| eachModuleManager module = aModuleManager module] ifNone:nil.
    detectedManager isNil ifTrue:[
        self listOfModules add:aModuleManager; sort.
        self updateModifiedChannel.
    ] ifFalse:[
        Dialog information:'Manager for Module ', aModuleManager module, ' already exists'.
    ].


    "Created: / 08-11-2006 / 19:25:21 / cg"
!

addModule:module withData:data
    (self listOfModules includes:module) ifFalse:[
        self listOfModules add:module; sort.
    ].

    self updateModifiedChannel.

    "Created: / 08-11-2006 / 19:25:21 / cg"
!

addPerModuleRoot

    |app moduleManager|

    app := ManagerPerModuleApp openFromSourceCodeManagementSettingsApp:self.
    app canceled ifFalse:[
        moduleManager := ModuleManager newForApplication:self.
        app moduleHolder value isEmptyOrNil ifTrue:[
            self information:'Adding without module name not allowed'.
            ^ self.
        ].
        moduleManager module:app moduleHolder value.
        moduleManager settings:app settingsHolder value.
        self listOfModules add:moduleManager.
        self updateModifiedChannel.
    ].
    "Modified: / 08-11-2006 / 19:27:39 / cg"
!

basicReadSettings
    |moduleManager moduleAndSettings|

    self initialize.

    self defaultSettingsHolder value:PerforceSourceCodeManager getPerforceDefaultSettingsString.
    self listOfModules removeAll.
    moduleAndSettings := PerforceSourceCodeManager repositoryInfoPerModule copy.
    moduleAndSettings notEmptyOrNil ifTrue:[
        moduleAndSettings keysAndValuesDo:[:module :settings|
            moduleManager := ModuleManager newForApplication:self.
            moduleManager module:module.
            moduleManager settings:settings.
            self listOfModules add:moduleManager.
        ].
    ].
    self listOfModules sort.

    self hasManager ifTrue:[
        self sourceCacheDir value:(PerforceSourceCodeManager cacheDirectoryName).
    ].

    self perforceExecutableHolder value:PerforceSourceCodeManager perforceExecutable.
    self verboseSourceCodeAccess value:PerforceSourceCodeManager verboseSourceCodeAccess.
    self shownInBrowserMenusHolder value:PerforceSourceCodeManager shownInBrowserMenus. 

"/    self selectedPerModuleRootChanged.

    "Modified: / 10-01-2012 / 00:21:00 / cg"
!

basicSaveSettings
    |client repositoryInfoPerModule|

    self hasManager ifTrue:[
        | nm fn|

        nm := self sourceCacheDir value.
        nm notEmptyOrNil ifTrue:[
            (fn := nm asFilename) exists ifFalse:[
                (self confirm:('Perforce cache directory ''' , nm , ''' does not exist\create ?' withCRs)) ifTrue:[
                    fn makeDirectory;
                       makeReadableForAll;
                       makeWritableForAll;
                       makeExecutableForAll.
                ]
            ].
            (fn isWritableDirectory and:[fn isReadable]) ifTrue:[
                PerforceSourceCodeManager cacheDirectoryName:nm.
            ] ifFalse:[
                self warn:'Invalid sourceCache directory.'
            ]
        ].
        repositoryInfoPerModule := Dictionary new.
        self listOfModules do:[:aModuleManager|
            repositoryInfoPerModule at:aModuleManager module put:aModuleManager settings.
        ].

        PerforceSourceCodeManager repositoryInfoPerModule:repositoryInfoPerModule.
        PerforceSourceCodeManager perforceExecutable:((self perforceExecutableHolder value ? '') withoutSeparators).
        client := self defaultSettingsHolder value.
        PerforceSourceCodeManager setDefaultPerforceSettingsFromString:client.
        PerforceSourceCodeManager verboseSourceCodeAccess:self verboseSourceCodeAccess value.
        PerforceSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value. 
    ].

    self acceptChannel value.

    "Modified: / 10-01-2012 / 00:21:59 / cg"
!

checkPerforceSettings

    |result icon|

    PerforceSourceCodeManager perforceError handle:[:ex|
        self warn:ex description.
        ^false
    ] do:[
        result := PerforceSourceCodeManager checkPerforceSettings:(self defaultSettingsHolder value) forPackage:nil.
        result ifTrue:[
            icon := GenericToolbarIconLibrary ledGreen14x14.
        ] ifFalse:[
            icon := GenericToolbarIconLibrary ledRed14x14.
        ].
        self checkLabel value:(LabelAndIcon label:'Check' icon:icon).
    ].
    ^false
!

condenseSourceCache
    self withWaitCursorDo:[ AbstractSourceCodeManager condenseSourceCache ].
    Method flushSourceStreamCache.

    "Modified: / 28-11-2006 / 12:21:33 / cg"
!

flushSourceCache
    self withWaitCursorDo:[ AbstractSourceCodeManager flushSourceCache ].

    "Modified: / 30-09-2011 / 13:33:51 / cg"
!

removePerModuleRoot

    |module|

    acceptChannel value:true.
    module := self selectedPerModuleRoot value.
    self listOfModules remove:module ifAbsent:nil.
    self updateModifiedChannel.
! !

!PerforceSourceCodeManagementSettingsAppl methodsFor:'aspects'!

checkLabel
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    checkLabel isNil ifTrue:[
        checkLabel := 'Check' asValue.
    ].
    ^ checkLabel.
!

defaultSettingsHolder

    defaultSettingsHolder isNil ifTrue:[
        defaultSettingsHolder := ValueHolder new.
        defaultSettingsHolder addDependent:self.
    ].
    ^ defaultSettingsHolder.
!

defaultSettingsPrototypeList

    defaultSettingsPrototypeList isNil ifTrue:[
        defaultSettingsPrototypeList := self perforcePrototypeList.
    ].
    ^ defaultSettingsPrototypeList.
!

initialListOfModules
    ^ List new.

    "Created: / 02-03-2012 / 14:41:40 / cg"
!

perforceExecutableHolder
    perforceExecutableHolder isNil ifTrue:[
        perforceExecutableHolder := ValueHolder new.
        perforceExecutableHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ perforceExecutableHolder.

    "Created: / 21-09-2006 / 15:37:06 / cg"
!

perforcePrototypeList

    |first client|

    client := PerforceSourceCodeManager perforceClient.
    client isEmptyOrNil ifTrue:[
        client := 'workspace'.
    ].
    first := (client ,':', PerforceSourceCodeManager perforceUser, ':',
                           (PerforceSourceCodeManager perforcePassword ? 'pass'), '@',
                           PerforceSourceCodeManager perforcePort).
    ^ Array with:first.
!

selectedPerModuleRoot
    selectedPerModuleRoot isNil ifTrue:[
        selectedPerModuleRoot := ValueHolder new.
        selectedPerModuleRoot addDependent:self.
    ].
    ^ selectedPerModuleRoot.
!

tableColumns
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    tableColumns isNil ifTrue:[
        tableColumns := self class tableColumns asValue.
    ].
    ^ tableColumns.
!

verboseSourceCodeAccess
    verboseSourceCodeAccess isNil ifTrue:[
        verboseSourceCodeAccess := false asValue.
        verboseSourceCodeAccess onChangeSend:#updateModifiedChannel to:self
    ].
    ^ verboseSourceCodeAccess.
! !

!PerforceSourceCodeManagementSettingsAppl methodsFor:'change & update'!

selectedPerModuleRootChanged

    self removeEnabled value:self selectedPerModuleRoot value notNil.
!

update:something with:aParameter from:changedObject

    changedObject == selectedPerModuleRoot ifTrue:[
        self selectedPerModuleRootChanged.
        ^ self
    ].

    changedObject == self listOfModules ifTrue:[
        self updateModifiedChannel.
    ].

    changedObject == defaultSettingsHolder ifTrue:[
        self updateModifiedChannel.
    ].


    super update:something with:aParameter from:changedObject

    "Modified: / 09-11-2006 / 14:41:10 / cg"
! !

!PerforceSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_PerforceSourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/perforceSetup.html'

    "Modified: / 05-08-2011 / 09:10:03 / cg"
! !

!PerforceSourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    sourceCacheDir := nil asValue.
    sourceCacheDir addDependent:self.

    super initialize.

    "Modified: / 08-11-2006 / 19:20:32 / cg"
! !

!PerforceSourceCodeManagementSettingsAppl methodsFor:'queries'!

hasManager
    "true if ANY source code management class is available"

    ^ PerforceSourceCodeManager notNil and:[PerforceSourceCodeManager isLoaded]
!

hasUnsavedChanges

    |repositoryInfoPerModule client settings|

    (PerforceSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    client := self defaultSettingsHolder value.
    client notNil ifTrue:[
        settings := PerforceSourceCodeManager getPerforceSettingsFromString:client.
        PerforceSourceCodeManager perforceClient ~= (settings at:#client ifAbsent:nil) ifTrue:[
            ^ true
        ].
        PerforceSourceCodeManager perforceUser ~= (settings at:#user ifAbsent:nil) ifTrue:[
            ^ true
        ].
        PerforceSourceCodeManager perforcePort ~= (settings at:#port ifAbsent:nil) ifTrue:[
            ^ true
        ].
        PerforceSourceCodeManager perforcePassword ~= (settings at:#password ifAbsent:nil) ifTrue:[
            ^ true
        ].
    ].

    repositoryInfoPerModule := Dictionary new.
    self listOfModules do:[:aModuleManager|
        repositoryInfoPerModule at:aModuleManager module put:aModuleManager settings.
    ].
    PerforceSourceCodeManager verboseSourceCodeAccess ~= self verboseSourceCodeAccess value ifTrue:[
        ^true
    ].

    PerforceSourceCodeManager repositoryInfoPerModule keysAndValuesDo:[:module :info |
        ((repositoryInfoPerModule includesKey:module) and:[info = (repositoryInfoPerModule at:module)])
        ifFalse:[^ true].
    ].
    repositoryInfoPerModule keysAndValuesDo:[:module :info|
        ((PerforceSourceCodeManager repositoryInfoPerModule includesKey:module) and:[(PerforceSourceCodeManager repositoryInfoPerModule at:module) = info])
        ifFalse:[^ true].
    ].
    self perforceExecutableHolder value ~= PerforceSourceCodeManager perforceExecutable ifTrue:[
        ^true
    ].
    ^ false

    "Modified: / 10-01-2012 / 00:31:38 / cg"
!

repositoryInfoPerModuleFor:sourceCodeManager

    |repositoryInfoPerModule|

    repositoryInfoPerModule := Dictionary new.
    self listOfModules do:[:aModuleManager|
        repositoryInfoPerModule at:aModuleManager module put:aModuleManager settings.
    ].
    ^ repositoryInfoPerModule
! !

!PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp class methodsFor:'instance creation'!

openFromSourceCodeManagementSettingsApp:something

    |inst|

    inst := self new.
    inst sourceCodeManagementSettingsApp:something.
    inst openModal.
    ^ inst
! !

!PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp andSelector:#windowSpec
     PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp new openInterface:#windowSpec
     PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Manager per Module'
          name: 'Manager per Module'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 653 100)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'VerticalPanel1'
              layout: (LayoutFrame 0 0 0 0 -5 1 -30 1)
              horizontalLayout: fit
              verticalLayout: topSpace
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (HorizontalPanelViewSpec
                    name: 'HorizontalPanel1'
                    horizontalLayout: leftFit
                    verticalLayout: center
                    horizontalSpace: 3
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Module:'
                          name: 'Label16'
                          translateLabel: true
                          adjust: right
                          extent: (Point 180 17)
                        )
                       (InputFieldSpec
                          name: 'EntryField7'
                          tabable: true
                          model: moduleHolder
                          acceptChannel: acceptChannel
                          acceptOnPointerLeave: true
                          extent: (Point 465 22)
                        )
                       )
                     
                    )
                    extent: (Point 648 23)
                  )
                 (HorizontalPanelViewSpec
                    name: 'HorizontalPanel4'
                    horizontalLayout: leftFit
                    verticalLayout: topSpace
                    horizontalSpace: 3
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (ViewSpec
                          name: 'Box1'
                          component: 
                         (SpecCollection
                            collection: (
                             (LabelSpec
                                label: 'Manager Info'
                                name: 'Label18'
                                layout: (LayoutFrame 0 0 0 0 149 0 16 0)
                                translateLabel: true
                                adjust: right
                              )
                             (LabelSpec
                                label: 'client:user:pass@host:port '
                                name: 'Label19'
                                layout: (LayoutFrame 0 0 14 0 180 0 29 0)
                                style: (FontDescription helvetica medium roman 10)
                                level: 0
                                translateLabel: true
                                adjust: right
                              )
                             )
                           
                          )
                          extent: (Point 180 35)
                        )
                       (ComboBoxSpec
                          name: 'ComboBox1'
                          model: settingsHolder
                          immediateAccept: false
                          acceptOnLostFocus: true
                          acceptOnPointerLeave: false
                          comboList: defaultSettingsPrototypeList
                          extent: (Point 465 20)
                        )
                       )
                     
                    )
                    extent: (Point 648 35)
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel2'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Add'
                    name: 'Button1'
                    translateLabel: true
                    model: doAccept
                    enableChannel: acceptEnableChannel
                    extent: (Point 322 22)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 322 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp methodsFor:'accessing'!

canceled
    ^ canceled
!

defaultSettingsPrototypeList

    defaultSettingsPrototypeList isNil ifTrue:[
        defaultSettingsPrototypeList := sourceCodeManagementSettingsApp perforcePrototypeList.
    ].
    ^ defaultSettingsPrototypeList.
!

sourceCodeManagementSettingsApp
    ^ sourceCodeManagementSettingsApp
!

sourceCodeManagementSettingsApp:something
    sourceCodeManagementSettingsApp := something.
! !

!PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp methodsFor:'aspects'!

acceptChannel
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    acceptChannel isNil ifTrue:[
        acceptChannel := TriggerValue new.
    ].
    ^ acceptChannel.
!

acceptEnableChannel
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    acceptEnableChannel isNil ifTrue:[
        acceptEnableChannel := true asValue.
    ].
    ^ acceptEnableChannel.
!

moduleHolder
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    moduleHolder isNil ifTrue:[
        moduleHolder := ValueHolder new.
        moduleHolder addDependent:self.
    ].
    ^ moduleHolder.
!

settingsHolder
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    settingsHolder isNil ifTrue:[
        settingsHolder := ValueHolder new.
    ].
    ^ settingsHolder.
! !

!PerforceSourceCodeManagementSettingsAppl::ManagerPerModuleApp methodsFor:'initialization & release'!

doCancel

    canceled := true.
    ^ super doCancel
!

postBuildWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked during the initialization of your app/dialog,
     after all of the visual components have been built,
     but BEFORE the top window is made visible.
     Add any app-specific actions here (reading files, setting up values etc.)
     See also #postOpenWith:, which is invoked after opening."

    "/ add any code here ...

    canceled := false.
    ^ super postBuildWith:aBuilder
! !

!PerforceSourceCodeManagementSettingsAppl::ModuleManager class methodsFor:'instance creation'!

newForApplication:anApplication
    |instance|

    instance := self new.
    instance app:anApplication.
    ^instance
! !

!PerforceSourceCodeManagementSettingsAppl::ModuleManager methodsFor:'accessing'!

app
    ^ app
!

app:something
    app := something.
!

check

    |icon|

    check isNil ifTrue:[
        ^'unchecked'
    ].
    check ifTrue:[
        icon := GenericToolbarIconLibrary ledGreen14x14.
    ] ifFalse:[
        icon := GenericToolbarIconLibrary ledRed14x14.
    ].

    ^icon
!

check:something
    check := something.
!

checkIcon
    ^ checkIcon
!

checkIcon:something
    checkIcon := something.
!

manager
    ^ manager
!

manager:something
    manager := something.
!

module
    ^ module
!

module:something
    module := something.
!

settings
    ^ settings
!

settings:something
    settings := something.
    app notNil ifTrue:[
        app listOfModules changed.
    ].
! !

!PerforceSourceCodeManagementSettingsAppl::ModuleManager methodsFor:'actions'!

doubleClick

    PerforceSourceCodeManager perforceError handle:[:ex|
        self warn:ex description.
        check := false.
    ] do:[
        check := PerforceSourceCodeManager checkPerforceSettings:settings forPackage:module.
    ].
    self changed.
! !

!PerforceSourceCodeManagementSettingsAppl::ModuleManager methodsFor:'comparing'!

< aModuleManager

    ^ self module < aModuleManager module
! !

!PerforceSourceCodeManagementSettingsAppl::ModuleManager methodsFor:'queries'!

availableManagerTypeNames
    ^ AbstractSourceCodeManager availableManagers collect:[:cls | cls managerTypeName].
!

managerClass

    ^ AbstractSourceCodeManager availableManagers detect:[:cls | cls managerTypeName = manager] ifNone:[nil].
! !

!PerforceSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

