"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

ApplicationModel subclass:#SettingsDialog
	instanceVariableNames:'requestor subCanvasApplicationHolder help doReload doSave
		enableReload enableHelp enableOK selectedItem applicationList
		categoryIcons lastSelection whyDisabledInfoHolder
		quickSearchStringHolder quickSearchFieldShownHolder
		highlightedWidgetsOriginalAttributes'
	classVariableNames:'ApplicationList IconList'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

HierarchicalList subclass:#HierarchicalApplicationList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SettingsDialog
!

HierarchicalItemWithLabelAndIcon subclass:#ApplicationItem
	instanceVariableNames:'application applicationClass nameString'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SettingsDialog::HierarchicalApplicationList
!

AbstractSettingsApplication subclass:#SettingsFilenameAppl
	instanceVariableNames:'settingsFilenameHolder infoLabelHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SettingsDialog
!

!SettingsDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    This is an application which presents a hierarchy of settings applications.
    It is used (among others) in the launcher's and filebrowser's settings-dialogs.

    However, it is rather generic and can be setup for any application's setting dialog.
    The actual contents (i.e. the organization tree and tab contents) is provided
    by a spec-array (the settingsList).
    You will find a default settings list here, but in theory, applications may provide
    their own one, or modify a copy of that list for specialized settings dialogs.
    See class >> examples, #defaultSettingsApplicationList
    and AbstractLauncherApplication >> settingsList for more info.

    [author:]
        Christian Penk, eXept Software AG

    [see also:]
        AbstractLauncherApplication defaultSettingsApplicationList 
"
!

examples

"
  start a Settings Dialog with a language Settings Application under root
                                                                [exBegin]
    | settingsApp |

    settingsApp := self new.
    settingsApp addApplClass:#'AbstractSettingsApplication::LanguageSettingsAppl' 
                withName:'Language'.
    settingsApp open.
                                                                [exEnd]


  start a Settings Dialog with a language Settings Application under root/Test
                                                                [exBegin]
    | settingsApp |

    settingsApp := self new.
    settingsApp addApplClass:#'AbstractSettingsApplication::LanguageSettingsAppl' 
                withName:'Test/Language'.
    settingsApp open.
                                                                [exEnd]

  start a Settings Dialog with a language Settings Application under root/Test
  with an other category test icon
                                                                [exBegin]
    | settingsApp |

    settingsApp := self new.
    settingsApp addApplClass:#'AbstractSettingsApplication::LanguageSettingsAppl' 
                withName:'Test/Language'.
    settingsApp addIcon:ToolbarIconLibrary start22x22Icon forCategory:'Test'.
    settingsApp open.
                                                                [exEnd]

  start a Settings Dialog with a language and memory Settings Application 
  in different categories
                                                                [exBegin]
    | settingsApp |

    settingsApp := self new.
    settingsApp addIcon:ToolbarIconLibrary start22x22Icon forCategory:'Test'.
    settingsApp addApplClass:#'AbstractSettingsApplication::LanguageSettingsAppl' 
                withName:'Test/Language'.
    settingsApp addApplClass:#'AbstractSettingsApplication::MemorySettingsAppl' 
                withName:'Test2/Memory'.
    settingsApp open.
                                                                [exEnd]
"
! !

!SettingsDialog class methodsFor:'initialization'!

initialize
    AbstractSettingsApplication autoload.
! !

!SettingsDialog class methodsFor:'accessing'!

itemClass

    ^ SettingsDialog::HierarchicalApplicationList::ApplicationItem
! !

!SettingsDialog class methodsFor:'application icons'!

defaultSettingsAppIcon

    ^ self settingsIcon2
!

settingsFolderIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self settingsIcon inspect
     ImageEditor openOnClass:self andSelector:#settingsIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SettingsDialog class settingsIcon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@BP#8>O#8>M  @@@@@@@@@@@@@@@@BJ%9&Y&Y&Y%R^B@@@@@@@@@@@@@@BI&J^(*J"(*JZTIIFQ$YFQ$YH@@@@@ JN#(:N#(:N#(9.V%)ZV%)ZKZP@@@HOU
4=OS4=OL3,''I0<B;/]F3*TE?@@BC5MKR4-KM,\^:.MJ:-;21/:1D_@@@ =SR4-KM3<+K/<J01,R20+R+QG0@@HOT4-KR/,^?-\[H1(Q^WW"1*4Q<@@BC5MKR
,-CO1<>/+(X*F1(S,Z1D_@@@ =SR4-J:2,[J0X  TU!!BE+F$GS!!=@HOT,+WK.\J/28\&TV=EKAV1RELG  BC5L7H0-KB/HT TV-CKA8>TG@=_H8M ;[H1+::
-;8\TWECKBD9)T=0]R40AXOE2;F5-;:/G6)EKBD?ZF5KV#ITJ0M>''*B_''ZF]''5,(KA8)X8ENU#XR@ )L^1$YFQ$YFQ$WBA PE@QMVSDON82S@@@@@@@@@@@@
@@A_@F)IU#DQMWH@@@@@@@@@@@@@@@@@@F1JWC\LMJI''^ @@@@@@@@@@@@@@@F9GU28ROGI%+VY4@@@@@@@@@@@@@GIFXC(IL9(@^VR*X''\@@@@@@@@@@@AU
IPXKP@@@@@A3XZ4#@@@@@@@@@@@@# 8AK90@@@@@@GX"T @a') ; colorMapFromArray:#[0 0 0 0 60 60 0 84 84 4 45 45 21 20 15 38 38 38 38 192 192 43 43 43 45 45 45 45 151 151 46 99 99 46 147 147 46 151 151 47 47 47 47 88 88 47 151 151 48 48 48 48 144 144 48 145 145 56 53 38 57 57 49 59 52 40 62 56 43 65 65 53 65 65 65 67 67 54 68 68 68 70 70 70 72 64 47 72 72 35 72 72 72 73 69 48 73 73 73 74 74 74 80 44 10 80 62 43 81 81 24 84 132 132 85 85 76 86 86 36 86 86 86 87 87 49 87 87 77 87 193 193 88 88 88 91 101 101 92 193 193 94 117 117 97 97 97 97 193 193 98 195 195 99 120 120 101 75 31 101 107 89 101 193 193 102 193 193 103 103 103 104 86 69 106 193 193 107 120 120 107 121 121 109 109 109 110 96 70 111 78 42 111 119 119 113 113 60 113 113 113 115 115 115 116 116 56 116 116 116 116 145 145 118 147 147 119 121 85 121 150 150 122 151 151 122 152 148 124 124 124 124 146 139 124 151 149 127 118 78 127 119 78 128 128 128 129 120 112 133 157 157 135 216 216 137 137 137 139 207 207 140 206 206 141 141 141 141 201 201 141 202 202 142 136 75 142 201 201 143 128 88 143 143 88 144 144 144 144 204 204 145 85 24 146 126 100 147 82 13 148 83 17 148 86 24 148 123 91 148 127 98 149 122 89 150 150 150 151 151 151 152 152 152 152 155 155 153 129 100 154 154 154 156 156 156 156 199 199 157 157 157 158 158 158 159 159 159 160 160 160 162 179 179 163 161 159 163 163 162 164 151 101 164 160 156 164 163 161 165 165 150 165 165 165 168 168 168 169 169 62 171 171 171 172 172 71 174 117 58 177 177 177 178 178 89 185 174 113 186 178 115 186 186 115 189 179 116 189 189 115 189 189 132 190 190 139 192 192 142 192 192 192 193 193 154 194 194 194 196 196 155 197 197 159 200 200 168 202 202 174 202 202 202 204 204 102 205 205 97 206 206 149 210 210 144 210 210 149 213 213 103 213 213 213 215 215 164 215 215 215 227 212 124 227 213 140 227 217 124 227 220 124 227 227 124 234 156 79 236 236 197 239 214 144 243 201 148 243 243 146 243 243 155 244 244 147 245 232 157 247 165 83 248 215 149 248 231 149 255 170 86 255 227 156 255 228 156 255 229 156 255 230 156 255 231 156 255 233 168 255 234 156 255 235 156 255 235 193 255 236 156 255 237 156 255 238 156 255 239 156 255 239 168 255 240 156 255 240 168 255 241 156 255 242 156 255 242 168 255 243 156 255 244 156 255 244 168 255 245 156 255 245 193 255 246 156 255 247 156 255 248 156 255 248 168 255 249 156 255 250 156 255 250 168 255 251 156 255 251 168 255 252 156 255 253 156 255 253 168 255 255 156 255 255 168 255 255 193 255 255 200]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'O<@@_>@@???@??? ???0???0???0???0???0???8???8???<???<???<???<???8@B? @A?0@C?8@G=<@G0<@G0\') ; yourself); yourself]
!

settingsIcon
    ^ self settingsIcon2
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
        constantNamed:'SettingsDialog settingsIcon2'
        ifAbsentPut:[(Depth8Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BDW%58@@@@@@@@@@@@@@@@
@@@@@@BFJ!!,ZD0@@@@@@@@@@@@@@@@@@@@BHHEEXP!!X@@A48@@@@@@@@@@@@@@BGI%E/QR0U@D!!SA0@@@@@@@@@@@@BEHEE+P20^O%A0OW0@@@@@@@@@@@@@
GEE1P20!!NPAO\GT-L@T@@@@@@@@@@A=*QR0!!O6!!-R5(2UB,C@@@@@@@@@@A[JB0^JVNAS%X6D HJS@@@@@@@@@@@E0 XDAPDSU$1C3.L$0@@@@@@@@@@@@@@
W0A*RUX1DSU2@@@@@@@@@@@@@@@@@@A,R%07CCR"Y7(@@@@@@@@@@@@@@@A.Q5\.D#12YZ5&]@@@@@@@@@@@@@A2Q&@:BSNZ@G%$*&I7@@@@@@@@@@@@URTF
B4@@@@@@\6F-H0@@@@@@@@@@@H8N@R>\@@@@@@A6H%H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') colorMapFromArray:#[0 0 0 0 60 60 0 84 84 4 45 45 21 20 15 38 38 38 38 192 192 43 43 43 45 45 45 45 151 151 46 99 99 46 147 147 46 151 151 47 47 47 47 88 88 47 151 151 48 48 48 48 144 144 48 145 145 56 53 38 57 57 49 59 52 40 62 56 43 65 65 53 65 65 65 67 67 54 68 68 68 70 70 70 72 64 47 72 72 35 72 72 72 73 69 48 73 73 73 74 74 74 80 44 10 80 62 43 81 81 24 84 132 132 85 85 76 86 86 36 86 86 86 87 87 49 87 87 77 87 193 193 88 88 88 91 101 101 92 193 193 94 117 117 97 97 97 97 193 193 98 195 195 99 120 120 101 75 31 101 107 89 101 193 193 102 193 193 103 103 103 104 86 69 106 193 193 107 120 120 107 121 121 109 109 109 110 96 70 111 78 42 111 119 119 113 113 60 113 113 113 115 115 115 116 116 56 116 116 116 116 145 145 118 147 147 119 121 85 121 150 150 122 151 151 122 152 148 124 124 124 124 146 139 124 151 149 127 118 78 127 119 78 128 128 128 129 120 112 133 157 157 135 216 216 137 137 137 139 207 207 140 206 206 141 141 141 141 201 201 141 202 202 142 136 75 142 201 201 143 128 88 143 143 88 144 144 144 144 204 204 145 85 24 146 126 100 147 82 13 148 83 17 148 86 24 148 123 91 148 127 98 149 122 89 150 150 150 151 151 151 152 152 152 152 155 155 153 129 100 154 154 154 156 156 156 156 199 199 157 157 157 158 158 158 159 159 159 160 160 160 162 179 179 163 161 159 163 163 162 164 151 101 164 160 156 164 163 161 165 165 150 165 165 165 168 168 168 169 169 62 171 171 171 172 172 71 174 117 58 177 177 177 178 178 89 185 174 113 186 178 115 186 186 115 189 179 116 189 189 115 189 189 132 190 190 139 192 192 142 192 192 192 193 193 154 194 194 194 196 196 155 197 197 159 200 200 168 202 202 174 202 202 202 204 204 102 205 205 97 206 206 149 210 210 144 210 210 149 213 213 103 213 213 213 215 215 164 215 215 215 227 212 124 227 213 140 227 217 124 227 220 124 227 227 124 234 156 79 236 236 197 239 214 144 243 201 148 243 243 146 243 243 155 244 244 147 245 232 157 247 165 83 248 215 149 248 231 149 255 170 86] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@O@@@_@@@?L@A?\@C?<@C>?@C??@C??@C?>@@/8@@_<@@?>@A?_@A<O@A<G@@@@@@@@@@@@@@@@@'); yourself); yourself]
!

wheelIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self wheelIcon inspect
     ImageEditor openOnClass:self andSelector:#wheelIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SettingsDialog wheelIcon'
        ifAbsentPut:[(Depth4Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CT@@@@@@@@@@@@@@CT@@@@@@@@@@@T0@2H0@5@@@@@@@@D#L"
H#L!!@@@@@@@@ARH"H"IP@@@@@@@@@2IQURH0@@@@@@@@L"TP@UH#@@@@@@@3H"DDPAH"L0@@@@@QH"TDPEH"DP@@@@@@URH0@2IU@@@@@@@@ARH#L"IP@@@@
@@@@@2H"H"H0@@@@@@@@L!!T"H%D#@@@@@@@@TP@2H0@U@@@@@@@@@@@BH@@@@@@@@@@@@@@BH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 0 0 127 127 127 194 194 194 255 255 255 236 233 216 161 161 165] mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@A @@C0@@33@A?? A?? @??@@??@C??0G??8G??8C??0@??@@??@A?? A?? @33@@C0@@A @@@@@@@@@@@@@'); yourself); yourself]
! !

!SettingsDialog class methodsFor:'default settingslist'!

defaultSettingsApplicationList
    "unless the settingsDialog is opened with an explicit settings list,
     this one is used (it is also the one used by the ST/X IDE"

    ^ OrderedCollection new
        addAll:#(          
                #('Language'                            #'AbstractSettingsApplication::LanguageSettingsAppl'            )
                #('Keyboard Mappings'                   #'AbstractSettingsApplication::KbdMappingSettingsAppl'          )
                #('ViewStyle'                           #'AbstractSettingsApplication::MiscDisplaySettingsAppl'         )
                #('ViewStyle/Style'                     #'AbstractSettingsApplication::StyleSettingsAppl'               )
                #('ViewStyle/Other'                     #'AbstractSettingsApplication::MiscDisplay2SettingsAppl'        )
                #('ViewStyle/Fonts'                     #'Tools::FontSettingsApplication'                               )
                #('System/System Messages'                     #'AbstractSettingsApplication::SystemMessageSettingsAppl'       )
                #('System/Memory'                              #'AbstractSettingsApplication::MemorySettingsAppl'              )
                #('System/Processor & Scheduler'               #'AbstractSettingsApplication::ProcessorSchedulerSettingsAppl'  )
                #('System/Autoloaded Packages'                 #'AbstractSettingsApplication::AutoloadedPackagesSettingsAppl'  )
                #('System/Package Path'                 #'AbstractSettingsApplication::PackagePathSettingsAppl'  )
                #('Tools'                               #'AbstractSettingsApplication::ToolsSettingsAppl'               )
                #('Tools/Toolbox'                       #'AbstractSettingsApplication::ToolboxSettingsAppl'             )
                #('Tools/Editor'                        #'AbstractSettingsApplication::EditSettingsAppl'                )
                #('Tools/Editor/Code Editor 2'          #'Tools::CodeView2SettingsAppl'                                 )
                #('Tools/Editor/Syntax Color'           #'AbstractSettingsApplication::SyntaxColorSettingsAppl'         )
                #('Tools/Editor/Code Format'            #'AbstractSettingsApplication::SourceCodeFormatSettingsAppl'    )
                #('Tools/System Browser'                #'AbstractSettingsApplication::SystemBrowserSettingsAppl'       )
                #('Tools/System Browser/Code Generator' #'AbstractSettingsApplication::CodeGeneratorSettingsAppl'       )
                #('Tools/Changes'                       #'AbstractSettingsApplication::ChangeFileSettingsAppl'          )
                #('Tools/Debugger'                      #'AbstractSettingsApplication::DebuggerSettingsAppl'            )
                #('Tools/Terminal'                      #'AbstractSettingsApplication::TerminalViewSettingsAppl'        )
                #('Tools/Compiler'                      #'AbstractSettingsApplication::GeneralCompilerSettingsAppl'     )
                #('Tools/Compiler/ByteCode'             #'AbstractSettingsApplication::ByteCodeCompilerSettingsAppl'    )
                #('Tools/Compiler/STC'                  #'AbstractSettingsApplication::STCCompilerSettingsAppl'         )
                #('Tools/Compiler/Build'                #'AbstractSettingsApplication::BuildSettingsAppl'               )
                #('Workspace'                           #'AbstractSettingsApplication::WorkspaceSettingsAppl'               )
                #('Source Code Management'              #'AbstractSettingsApplication::SourceCodeManagementSettingsAppl')
            );
        add:
            "/ see initializeSettingsList for how the following is expanded...
            { 'Source Code Management/[% managerTypeName]' .     
                                                 [ AbstractSourceCodeManager availableManagers 
                                                     collect:[:each | each settingsApplicationClass] ] .    
                                                                                              '[% defaultIcon]' };
        addAll: 
            #(
                #('Printer'                             #'AbstractSettingsApplication::PrinterSettingsAppl'             )
                #('Display'                             #'AbstractSettingsApplication::DisplaySettingsAppl'             )
                #('Communication'                       nil                                           #communicationIcon)

                #('Communication/Logging'               #'AbstractSettingsApplication::CommunicationLoggingSettingsAppl')
                #('Communication/RDoIt & Telnet'        #'AbstractSettingsApplication::RDoItServerSettingsAppl'         )
                #('Communication/Misc'                  #'AbstractSettingsApplication::MiscCommunicationSettingsAppl'   )
                #('Communication/Misc/Bridges'          #'AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl'   )
                #('Communication/Misc/Smalltalk'        #'AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl'   )
                #('Communication/Misc/OSI Protocol'     #'AbstractSettingsApplication::OsiSettingsAppl'                 )
                "/#('Communication/SQLServer'             #'AbstractSettingsApplication::SQLServerSettingsAppl'           )
                #('Communication/HTTPServer'            #'AbstractSettingsApplication::HTTPStartServerSettingsApplication'   )
            );
        yourself

    "Modified: / 16-12-2002 / 18:12:28 / penk"
    "Modified: / 25-11-2011 / 15:28:42 / cg"
    "Modified: / 13-04-2016 / 22:49:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SettingsDialog class methodsFor:'defaults'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary stxSettings24x24Icon
!

expandParents

    ^ true
!

resourcePackName
    "return the name which is used as the fileNameBase of my resource file.
     Here, use the same resources as the Launcher"

    ^ AbstractLauncherApplication resourcePackName
! !

!SettingsDialog class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#acceptChangedSettings
'Accept changed settings for the current ST/X session.\Notice, that these affect the current session only.\To make the current settings the default in the future, save them to the settings file (using the "Save" button).\Also notice, that some values affect new opened windows/tools only.'

#discardChangedSettings
'Discard changes and revert to the current active settings values'

#helpOnSettings
'Show the online documentation on the shown values in an HTML viewer'

#loadSettingsFromFile
'Load the settings from a file.\At initial startup, the "settings.stx" file is read automatically.'

#saveSettingsToFile
'Save the current settings into a file.\The "settings.stx" file is automatically read upon every fresh start of ST/X.'

#quickSearchString
'Quick search pattern.\Highlights settings which contain the entered string (in the label or its tooltip).\Searches both in the presented text AND in the english original version.\\Prefix with a space to search for words starting with it;\append a space, to search for words ending with it.\(i.e. surround with spaces to search for free standing words only.)\Notice, that without a separator, it will often find strange partial strings\(such as "update", when searching for "date", or "amount" when searching for "mou[se]")'

)

    "Modified: / 30-04-2016 / 14:38:46 / cg"
! !

!SettingsDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SettingsDialog andSelector:#windowSpec
     SettingsDialog new openInterface:#windowSpec
     SettingsDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Settings Dialog'
         name: 'Settings Dialog'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 850 656)
         menu: mainMenu
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             showHandle: true
             snapMode: both
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel1'
                         layout: (LayoutFrame 0 0 0 0 0 1 -34 1)
                         horizontalLayout: fit
                         verticalLayout: topFit
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'QuickSearchBox'
                               visibilityChannel: quickSearchFieldShownHolder
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Quick Search:'
                                     name: 'Label1'
                                     layout: (LayoutFrame 0 0 0 0 150 0 0 1)
                                     activeHelpKey: quickSearchString
                                     translateLabel: true
                                     adjust: left
                                   )
                                  (InputFieldSpec
                                     name: 'QuickSeachEntryField'
                                     layout: (LayoutFrame 150 0 0 0 0 1 0 1)
                                     activeHelpKey: quickSearchString
                                     model: quickSearchStringHolder
                                     immediateAccept: true
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnPointerLeave: true
                                   )
                                  )
                                
                               )
                               extent: (Point 249 30)
                             )
                            (HierarchicalListViewSpec
                               name: 'HierarchicalListView1'
                               model: selectedItem
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               listModel: applicationList
                               useIndex: false
                               highlightMode: label
                               showLeftIndicators: false
                               indicatorSelector: doIndicatorClick:
                               extent: (Point 249 589)
                             )
                            )
                          
                         )
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel2'
                         layout: (LayoutFrame 0 0.0 -34 1 0 1.0 0 1)
                         visibilityChannel: loadAndSaveSettingsItemVisible
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Save'
                               name: 'Button3'
                               activeHelpKey: saveSettingsToFile
                               translateLabel: true
                               tabable: true
                               model: saveSettingsWithoutAskingForFile
                               extent: (Point 118 28)
                             )
                            (ActionButtonSpec
                               label: 'Load From...'
                               name: 'Button2'
                               activeHelpKey: loadSettingsFromFile
                               translateLabel: true
                               tabable: true
                               model: loadSettingsFromFile
                               extent: (Point 119 28)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'Box2'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'DisabledSettingsBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         initiallyInvisible: true
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'whyDisabledLabel'
                               name: 'whyDisabledLabel'
                               layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                               translateLabel: true
                               labelChannel: whyDisabledInfoHolder
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'SubCanvas'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -34 1)
                         level: -1
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: false
                         miniScrollerVertical: false
                         clientHolder: subCanvasApplicationHolder
                         createNewBuilder: false
                         postBuildCallback: postBuildSubCanvas:
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel1'
                         layout: (LayoutFrame 0 0.0 -34 1 -16 1.0 0 1)
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         reverseOrderIfOKAtLeft: true
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Help'
                               name: 'Help'
                               activeHelpKey: helpOnSettings
                               translateLabel: true
                               tabable: true
                               model: help
                               enableChannel: enableHelp
                               extent: (Point 138 28)
                             )
                            (ActionButtonSpec
                               label: 'Close'
                               name: 'Button4'
                               activeHelpKey: closeRequest
                               visibilityChannel: closeButtonVisibleHolder
                               translateLabel: true
                               model: closeRequest
                               extent: (Point 138 28)
                             )
                            (ActionButtonSpec
                               label: 'Discard'
                               name: 'Reload'
                               activeHelpKey: discardChangedSettings
                               translateLabel: true
                               tabable: true
                               model: doReload
                               enableChannel: enableReload
                               extent: (Point 138 28)
                             )
                            (ActionButtonSpec
                               label: 'Apply'
                               name: 'Apply'
                               activeHelpKey: acceptChangedSettings
                               translateLabel: true
                               tabable: true
                               model: doSave
                               enableChannel: enableOK
                               extent: (Point 139 28)
                             )
                            )
                          
                         )
                         keepSpaceForOSXResizeHandleH: true
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.29999999999999999 1.0)
           )
          )
        
       )
     )
! !

!SettingsDialog class methodsFor:'menu actions'!

askForFileAndSaveSettings
    |fileName resources|

    resources := self classResources.

    fileName := Dialog 
        requestFileNameForSave:(resources string:'Save Settings in File') 
        default:'settings.stx'
        ok:(resources string:'Save') 
        abort:(resources string:'Cancel') 
        pattern:'*.stx'
        fromDirectory:'.'.

    fileName size ~~ 0 ifTrue:[
        "not canceled"
        self saveSettingsTo:fileName.
    ]

    "Modified: / 27-10-2010 / 11:24:54 / cg"
!

currentSettingsFilename
    | file |

    "JV@2012-02-07: Changed to save preferences back to file from which
     they have been loaded (if known). If no such file is known,
     save to DEFAULT USER SETTINGS file (default ~/.smalltalk/settings.rc)"

    file := UserPreferences current at: #settingsFilename ifAbsent:[nil].
    file isNil ifTrue:[
        file := UserPreferences defaultUserSettingsFile.
    ].
    ^ file.
!

saveSettingsAsDefaultSettings
    self saveSettingsTo:(self currentSettingsFilename).

    "Modified: / 07-02-2012 / 00:45:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveSettingsTo:file
    [
        UserPreferences current saveIn:file.
    ] on:StreamError do:[:ex|
        self warn:(self resources 
                stringWithCRs:'Cannot save settings into: %1\(%2)' 
                with:(file asAbsoluteFilename asString) 
                with:ex description).
    ]
!

saveSettingsWithoutAskingForFile
    self saveSettingsAsDefaultSettings.
! !

!SettingsDialog class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:SettingsDialog andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(SettingsDialog mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: '&File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: '&Load From...'
                  itemValue: loadSettingsFromFile
                  isVisible: loadAndSaveSettingsItemVisible
                )
               (MenuItem
                  label: '-'
                  isVisible: loadAndSaveSettingsItemVisible
                )
               (MenuItem
                  label: 'Save'
                  itemValue: saveSettingsWithoutAskingForFile
                  isVisible: loadAndSaveSettingsItemVisible
                )
               (MenuItem
                  label: '&Save As...'
                  itemValue: askForFileAndSaveSettings
                  isVisible: loadAndSaveSettingsItemVisible
                )
               (MenuItem
                  label: '-'
                  isVisible: loadAndSaveSettingsItemVisible
                )
               (MenuItem
                  label: 'E&xit'
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
                  label: 'Expand All'
                  itemValue: menuExpandAll
                  hideMenuOnActivated: false
                )
               (MenuItem
                  label: 'Collapse All'
                  itemValue: menuCollapseAll
                  hideMenuOnActivated: false
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Show Search Field'
                  hideMenuOnActivated: false
                  indication: quickSearchFieldShownHolder
                )
               (MenuItem
                  label: 'Show Non-Default Settings'
                  isVisible: showNonDefaultSettingsMenuItemVisibleHolder
                  hideMenuOnActivated: false
                  indication: showNonDefaultSettingsHolder
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
! !

!SettingsDialog class methodsFor:'startup'!

openWithList:settingsList label:label
    ^ self 
        openWithList:settingsList 
        label:label 
        initialSettingsClass:nil
!

openWithList:settingsList label:label initialSettingsClass:settingsClassToSelectOrNil
    "given a list of page-label/class pairs,
     open a settings dialog showing that set of items."

    |settingsApp|

    settingsApp := SettingsDialog new.
    settingsApp installSettingsEntries:settingsList.
    settingsApp allButOpen.
    settingsApp showRoot: false.
    settingsApp window label:label.
    settingsClassToSelectOrNil notNil ifTrue:[
        settingsApp selectItemWithClass: settingsClassToSelectOrNil.
    ].
    settingsApp openWindow.
    ^ settingsApp
! !

!SettingsDialog methodsFor:'accessing'!

requestor
    "return the 'requestor' of the SettingsDialog"

    ^ requestor
!

requestor:something
    requestor := something.
!

rootItem
    ^ self applicationList root.

    "Created: / 03-11-2007 / 14:23:01 / cg"
!

rootItemLabel
    ^ self rootItem label.

    "Modified: / 03-11-2007 / 14:23:18 / cg"
!

rootItemLabel:aString
    self rootItem label:aString.

    "Modified: / 03-11-2007 / 14:23:16 / cg"
!

selectedItemsName
    |sel|

    (sel := self selectedItem value) notNil ifTrue:[
        ^ sel value nameString
    ].
    ^ nil.
!

showRoot:aBoolean

    self applicationList showRoot:aBoolean.
    aBoolean ifFalse:[
        self applicationList root children do:[:e|e expand].
    ]

    "Modified: / 15-10-2011 / 12:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subCanvasApplication
    ^ self subCanvasApplicationHolder value
! !

!SettingsDialog methodsFor:'actions'!

changeLabelTo:aLabel application:aApplication
    | item |

    item := self getItemByApplication:aApplication.
    item notNil ifTrue:[
        item label:aLabel.
        item changed.
    ].
!

destroyAll
    self realApplicationsDo:[:app | app close ].
!

doIndicatorClick:index 
    "handle a click on the indicator"

    (self applicationList at:index) toggleExpand
!

doReload
    "discard button was pressed"
    
    |item|

    item := self selectedItem value.
    (item isNil or:[item isCategory or:[item application isNil]]) ifTrue:[
        ^ self
    ].
    item application discardChangesAndReadSettings
!

doSave
    "accept button was pressed"

    | item |

    item := self selectedItem value.
    (item isNil or:[item isCategory or:[item application isNil]]) ifTrue:[ ^ self].
    self withWaitCursorDo:[
        item application saveSettingsIfUnsavedChangesArePresent.
    ].
!

expandItemForApplication:aApplication
    | item |

    item := self applicationList detect:[:item | item application = aApplication] ifNone:[nil].
    item notNil ifTrue:[
        item expand
    ].
!

help
    |item |

    item := self selectedItem value.
    (item isNil or:[item isCategory or:[item application isNil]]) ifTrue:[ ^ self].
    item application help.
!

reopenLauncher
    "force the launcher to reopen an instance of itself.
     Done whenever relevant look&feel settings are changed
     (actually a workaround - a much better solution would be to teach
     all smalltalk applications/views to dynamically update their style)."

    |app|

    (app := self requestor) notNil ifTrue:[
        app reopenLauncher.
    ] ifFalse:[
        NewLauncher current reopenLauncher.
    ].
!

sendLoadRequestToAll
    "ask all subApps to reload their idea of the current settings.
     Do this, after userPrefs have been loaded from a file,
     while a settingsDialog is open"

    self realApplicationsDo:[:app |
        app readSettings.
        app clearDidModifySettings.
    ].

    "Modified: / 24-08-2010 / 18:41:36 / sr"
!

sendSaveRequestToAll
    "give all subapps a chance to apply any changes.
     No longer needed, as we do this at the time the subApp
     is changed; so only the current app needs this chance again,
     when about to close (seesendSaveRequestToCurrent) "

    self realApplicationsDo:[ :app |
        app saveRequest ifFalse:[
            ^ false
        ].
    ].
    ^ true
!

sendSaveRequestToCurrent
    "when about to close the dialog, give the current
     subapp a chance to apply any changes"

    | item currentApp |

    item := self selectedItem value.
    (item isNil 
        or:[item isCategory 
        or:[(currentApp := item application) isNil]]
    ) ifTrue:[ ^ true].

    self withWaitCursorDo:[
        ^ currentApp saveRequest.
    ].
    ^ true
! !

!SettingsDialog methodsFor:'application list access'!

addApplClass:aClassName forApplication:anApplication label:aLabel expand:aBoolean
    "add an application to the settingsTree, take the icon from the application classes defaultIcon method"

    | class |

    class := Smalltalk classNamed:aClassName.
    class isNil ifTrue:[
        ('SettingsDialog [warning]: can''t find ', aClassName asString, ' to register') infoPrintCR.
        aClassName isString ifFalse:[
            thisContext fullPrintAll.
        ].
        ^ nil
    ].
    class autoload.
    ^ self createItemForApplication:anApplication class:aClassName label:aLabel icon:class defaultIcon expandParent:aBoolean replaceExisting:false

    "Modified: / 14-02-2011 / 20:10:11 / cg"
!

addApplClass:aClass withName:aName
   "add an application to the settingsTree, take the icon from the application classes defaultIcon method"

    ^ self addApplClass:aClass withName:aName icon:nil.
!

addApplClass:aClass withName:aName expand:aBoolean
   "add an application to the settingsTree, take the icon from the application classes defaultIcon method"

    ^ self addApplClass:aClass withName:aName icon:nil expand:aBoolean.
!

addApplClass:aClass withName:aName icon:icon
    ^ self addApplClass:aClass withName:aName icon:icon expand:false
!

addApplClass:aClassName withName:aName icon:icon expand:doExpand
    |applicationLabel locIcon locClass|

"/    (self applicationNames includes:aName) ifTrue:[
"/        ^ self getItemForName:aName.
"/    ].
    
    aClassName isNil ifTrue:[ 
        self addIcon:icon forCategory:aName.
        ^ self 
    ].
    self addCategoriesFor:aName.

    locIcon := icon.
    locClass := Smalltalk classNamed:aClassName.
    locClass isNil ifTrue:[
        ('SettingsDialog [warning]: can''t find ', aClassName asString, ' to register') infoPrintCR.
        aClassName isString ifFalse:[
            thisContext fullPrintAll.
        ].
        ^ nil
    ].
    locClass autoload.

    (locIcon isNil and:[locClass respondsTo:#defaultIcon]) ifTrue:[ locIcon := locClass defaultIcon].
    applicationLabel := (aName asCollectionOfSubstringsSeparatedBy:$/) last.

    ^ self 
        createItemName:aName 
        label:applicationLabel 
        class:locClass 
        icon:locIcon 
        expandParent:doExpand 
        replaceExisting:false

    "Modified: / 14-02-2011 / 20:10:04 / cg"
!

addIcon:aIcon forCategory:aCategoryName
    "add a new category Icon for a category"

    |existingItem|

    self categoryIcons at:aCategoryName put:aIcon.
    existingItem := self getItemForName:aCategoryName.
    existingItem notNil ifTrue:[
        existingItem icon:aIcon
    ].
!

applicationNames
    ^ self applicationList collect:[:item | item nameString].
!

categoryIcons
    categoryIcons isNil ifTrue:[
        categoryIcons := Dictionary new.
    ].
    ^ categoryIcons 
!

childrenApplicationItemFor:aApplication fromItem:anItem
    anItem application = aApplication ifTrue:[
        ^ anItem
    ].
    anItem hasChildren ifTrue:[
        anItem children do:[:aChildItem |
            ^ self childrenApplicationItemFor:aApplication fromItem:aChildItem.
        ].
    ].
    ^ nil
!

getAllChildrenAppsForApplication:aApplication 
    ^ self getAllChildrenAppsForApplication:aApplication matchBlock:nil
!

getAllChildrenAppsForApplication:aApplication childrenClass:aClass 
    |matchBlock|

    matchBlock := [:aSubApplication | aSubApplication class == aClass ].
    ^ self getAllChildrenAppsForApplication:aApplication matchBlock:matchBlock
!

getAllChildrenAppsForApplication:aApplication matchBlock:aMatchBlock
    | children |

    children := self getAllChildrenByApplication:aApplication.
    aMatchBlock notNil ifTrue:[
        children := children select:[:aChild | aMatchBlock value:(aChild application)]
    ].
    ^ children collect:[:item | item application].
!

getAllChildrenByApplication:aApplication
    | item |

    item := self getItemByApplication:aApplication.
    item isNil ifTrue:[ ^ #()].
    ^ item children.
!

getApplicationsByClass:aClass
    | classEntries|

    self applicationList isNil ifTrue:[
        self initialize.
    ].
    classEntries := self applicationList select:[:aEntry | aEntry application class == aClass].
    ^ classEntries collect:[:aItem | aItem application].
!

getItemByApplication:anApplication
    |item|

    self applicationList do:[:anItem |
        item := self childrenApplicationItemFor:anApplication fromItem:anItem.
        item notNil ifTrue:[ ^ item ].
    ].
    ^ nil
!

getNameOfApplication:aApplication
    |item|

    self applicationList do:[:anItem |
        item := self childrenApplicationItemFor:aApplication fromItem:anItem.
        item notNil ifTrue:[ ^ item nameString].
    ].
    ^ ''
!

installSettingsEntries:aCollection
    aCollection do:[ :entry| 
        self installSettingsEntry:entry.
    ].
!

installSettingsEntries: entries expand: expand

    "Installs given settings list. If expand is true,
     dynamic settings list is expanded"
    
    entries do:[ :entry| 
        self installSettingsEntry:entry expand: expand
    ].

    "Created: / 15-10-2011 / 11:45:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

installSettingsEntry:entry
    |applName applClassOrNil iconHolderOrNil|

    applName := entry at:1.
    applClassOrNil := entry at:2.
    iconHolderOrNil := entry at:3 ifAbsent:nil.
    self addApplClass:applClassOrNil withName:applName icon:iconHolderOrNil value
!

installSettingsEntry:entry expand: expand

    | applName applClassOrNil iconHolderOrNil cookedList className code classList name nameCode nameBlock nameList|

    expand ifFalse:[
        applName := entry at:1.
        applClassOrNil := entry at:2.
        iconHolderOrNil := entry at:3 ifAbsent:nil.
        self addApplClass:applClassOrNil withName:applName icon:iconHolderOrNil value.
        ^self
    ].

    cookedList := OrderedCollection new.

    className := entry at:2 ifAbsent:nil.
    (className notNil and:[className startsWith:'[']) ifTrue:[
        code := className copyFrom:2 to:(className size - 1).
        classList := (Parser evaluate:code) select:[:clsOrNil | clsOrNil notNil].
        name := entry at:1.
        self assert:(name includesString:'[').

        nameCode := name copyFrom:(name indexOf:$[)+1 to:(name indexOf:$])-1.
        nameCode := '^ [:each | ' , (nameCode copyReplaceString:'%' withString:'each') ,']'.
        nameBlock := Parser evaluate:nameCode.

        nameList := classList collect:nameBlock.
        nameList sortWith:classList.
        nameList with:classList do:[:eachName :eachClass |
            |newEntry|

            newEntry := entry copy.
            newEntry at:1 put:(name copyTo:(name indexOf:$[)-1),eachName.
            newEntry at:2 put:eachClass name.
            cookedList add:newEntry.
        ].
    ] ifFalse:[
        (className isNil "a directory entry"
        or:[ (Smalltalk at:className) notNil "a valid entry"]) ifTrue:[
            cookedList add:entry.
        ].
    ].

    cookedList do:[:eachEntry |
        |iconCodeOrSelector iconCode iconBlock newEntry|

        iconCodeOrSelector := eachEntry at:3 ifAbsent:nil.
        iconCodeOrSelector isNil ifTrue:[
            newEntry := eachEntry
        ] ifFalse:[
            newEntry := eachEntry copy.
            (iconCodeOrSelector startsWith:'[') ifTrue:[
                iconCode := iconCodeOrSelector copyFrom:(iconCodeOrSelector indexOf:$[)+1 to:(iconCodeOrSelector indexOf:$])-1.
                iconCode := '^ [:each | ' , (iconCode copyReplaceString:'%' withString:'each') ,']'.
                iconBlock := Parser evaluate:iconCode.
                newEntry at:3 put:(iconBlock value:(Smalltalk classNamed:(eachEntry at:2))).
            ] ifFalse:[
                newEntry at:3 put:(self perform:iconCodeOrSelector).
            ].
        ].
        self installSettingsEntry:newEntry expand: false.
    ].

    "
     self withAllSubclassesDo:[:cls | cls initializeSettingsList ]
    "

    "Modified: / 16-12-2002 / 18:12:50 / penk"
    "Modified: / 20-04-2011 / 17:03:33 / cg"
    "Created: / 15-10-2011 / 11:49:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parentApplicationFor:aApplication
    |item parent|

    item := (self getItemByApplication:aApplication).
    parent := item parent.
    parent notNil ifTrue:[
        ^ parent application.
    ].
    ^ nil
!

remApplClassByName:aName 
    "remove an application from the settingsTree"

    |item|

    item := self getItemForName:aName.
    self removeItem:item 
!

removeAllApplicationsByClass:aClass
    |apps|

    apps := self getApplicationsByClass:aClass.
    apps do:[:aApp |
        self removeByApplication:aApp.
    ].
!

removeAllSubApplicationsFor:aApp
    |apps|

    apps := self getAllChildrenAppsForApplication:aApp.
    apps do:[:aApp |
        self removeByApplication:aApp.
    ].
!

removeApplicationByClass:aClass
    | classEntries|

    self applicationList isNil ifTrue:[
        self initialize.
    ].
    classEntries := self applicationList select:[:aEntry | aEntry application class == aClass].
    classEntries do:[:aItem |
        self removeItem:aItem.
    ].
!

removeApplicationFromTree:aApplication
    | classEntries|

    self applicationList isNil ifTrue:[
        self initialize.
    ].
    classEntries := self applicationList select:[:aEntry | aEntry application == aApplication].
    classEntries do:[:aItem |
        self removeItem:aItem.
    ].
    self applicationList removeAllFoundIn:classEntries.
!

removeByApplication:aApplication
    | item |

    item := self getItemByApplication:aApplication.
    item notNil ifTrue:[
        self removeItem:item.
    ]
!

sortSubApplicationsFor:anApplication
    |item|

    item := self getItemByApplication:anApplication.
    item sort:[:a :b| a label < b label].
! !

!SettingsDialog methodsFor:'application list access-private'!

addCategoriesFor:aName
    "create all the categories"

    (aName includes:$/) ifFalse:[ ^ self].
    self treeName:aName butLast:1 do:[:currentLabel :currentName| 
        |length icon|

        currentLabel notEmpty ifTrue:[
            icon := self categoryIcons at:currentName ifAbsent:[nil].
            self createItemName:currentName label:currentLabel icon:icon replaceExisting:true.
        ]
    ].
!

createItemForApplication:anApplication class:aClass label:aLabel icon:anIcon expandParent:expandParent replaceExisting:doReplaceExisting
    "create an application item in my application list"

    | newItem parent locIcon item|

    parent := self getItemByApplication:anApplication.
    parent isNil ifTrue:[
        ^ nil
    ].

    doReplaceExisting ifTrue:[
        parent children notNil ifTrue:[
            (item := parent children detect:[ :anItem | anItem application == anApplication] ifNone:[nil]) notNil ifTrue:[
                ^ item.
            ]
        ]
    ].

    newItem := self class itemClass new.  
    "/ newItem label:(resources string:aLabel) "allBold".
    newItem label:aLabel "allBold".
    newItem nameString:(anApplication itemPathName , aLabel).
    newItem applicationClass:aClass.
    locIcon := anIcon.
    locIcon isNil ifTrue:[ locIcon := self class defaultSettingsAppIcon].
    newItem icon:locIcon.
    parent add:newItem.
    expandParent ifTrue:[
        parent expand.
    ].
    ^ newItem
!

createItemName:aNameString label:aLabel class:aClass icon:anIcon
    ^ self createItemName:aNameString label:aLabel class:aClass icon:anIcon expandParent:false
!

createItemName:aNameString label:aLabel class:aClass icon:anIcon expandParent:expandParent
    ^ self
        createItemName:aNameString 
        label:aLabel 
        class:aClass 
        icon:anIcon 
        expandParent:expandParent
        replaceExisting:true
!

createItemName:aNameString label:untranslatedLabel class:aClass icon:anIcon expandParent:expandParent replaceExisting:doReplaceExisting
    "create an application item in my application list"

    |newItem parentsName parent locIcon item|

    (aNameString includes:$/) ifTrue:[
        parentsName := aNameString copyTo:(aNameString lastIndexOf:$/)-1.
        parent := self getItemForName:parentsName.
    ].
    parent isNil ifTrue:[
        parent := self rootItem.
    ].

    doReplaceExisting ifTrue:[
        parent children notNil ifTrue:[
            (item := parent children detect:[ :anItem | anItem nameString = aNameString] ifNone:[nil]) notNil ifTrue:[
                ^ item.
            ]
        ]
    ].

    newItem := self class itemClass new.  
    "/ newItem label:(resources string:aLabel) "allBold".
    newItem label:(resources string:untranslatedLabel) "allBold".
    newItem nameString:aNameString.
    newItem applicationClass:aClass.
    locIcon := anIcon.
    locIcon isNil ifTrue:[ locIcon := self class defaultSettingsAppIcon].
    newItem icon:locIcon.
    parent add:newItem.
    expandParent ifTrue:[
        parent expand.
    ].
    ^ newItem

    "Modified: / 03-11-2007 / 14:23:32 / cg"
!

createItemName:aNameString label:aLabel icon:anIcon
    "create an application item in my application list"

    self createItemName:aNameString label:aLabel class:nil icon:anIcon expandParent:false
!

createItemName:aNameString label:aLabel icon:anIcon replaceExisting:doReplaceExisting
    "create an application item in my application list"

    self createItemName:aNameString label:aLabel class:nil icon:anIcon expandParent:false replaceExisting:doReplaceExisting
!

getItemForName:aName
    | searchItem|

    searchItem := self rootItem.
    self treeName:aName do:[:currentLabel :currentName|
        searchItem children isNil ifTrue:[ ^ nil].
        searchItem := searchItem children detect:[: item | item nameString = currentName] ifNone:[nil].
        searchItem isNil ifTrue:[ ^ nil].
    ].
    ^ searchItem

    "Modified: / 03-11-2007 / 14:23:28 / cg"
!

realApplications
    "return a collection of all real (non-folder) applications.
     A helper to avoid code duplication"

    ^ self applicationList 
        select:[:appItem | appItem isCategory not and:[ appItem application notNil]]
        thenCollect:[:appItem | appItem application].
!

realApplicationsDo:aBlock
    "evaluate aBlock for all real (non-folder) applications.
     A helper to avoid code duplication"

    self realApplications do:aBlock.
!

removeItem:anItem 
    "remove an application from the settingsTree"

    |parent remParent|

    anItem application release.

    parent := anItem parent.
    parent isNil ifTrue:[" already removed " ^ self].
    parent remove:anItem.
    
    [parent isCategory and:[parent children isEmptyOrNil]] whileTrue:[
        remParent := parent.
        parent := remParent parent.
        parent remove:remParent.
    ].
    self applicationList remove:anItem ifAbsent:[nil].
    self selectedItem value:parent.
!

treeName:aName butLast:last do:aBlock 
    | tree  length|

    tree := aName asCollectionOfSubstringsSeparatedBy:$/.
    tree from:1 to:(tree size - last) keysAndValuesDo:[:idx :aCategory| | itemName |
        length := 0.
        tree from:1 to:idx keysAndValuesDo:[:idx2 : el | 
            length := length + el size.
            idx2 > 1 ifTrue:[length := length + 1].
        ].
        itemName := aName copyTo:length.
        aBlock value:aCategory value:itemName.
    ].
!

treeName:aName do:aBlock
    self treeName:aName butLast:0 do:aBlock
! !

!SettingsDialog methodsFor:'aspects'!

applicationList
    applicationList isNil ifTrue:[
        applicationList := SettingsDialog::HierarchicalApplicationList new.
    ].
    ^ applicationList.
!

closeButtonVisibleHolder
    ^ builder valueAspectFor:#'closeButtonVisibleHolder' initialValue:false
!

enableHelp
    enableHelp isNil ifTrue:[
        enableHelp := true asValue.
    ].
    ^ enableHelp.
!

enableOK
    enableOK isNil ifTrue:[
        enableOK := true asValue.
    ].
    ^ enableOK.
!

enableReload
    enableReload isNil ifTrue:[
        enableReload := true asValue.
    ].
    ^ enableReload.
!

loadAndSaveSettingsItemVisible
    "for now, only show these if I have a requestor 
     (i.e. I am a full settings Dialog as opposed to a DebugView, FileBrowser or other
     settingsDialog. I think this has to be reworked..."

    ^ requestor notNil "/ loadAndSaveSettingsItemVisible
!

quickSearchFieldShownHolder
    quickSearchFieldShownHolder isNil ifTrue:[
        quickSearchFieldShownHolder := false asValue
    ].
    ^ quickSearchFieldShownHolder.
!

quickSearchStringHolder
    <resource: #uiAspect>

    quickSearchStringHolder isNil ifTrue:[
        quickSearchStringHolder := ValueHolder new.
        quickSearchStringHolder onChangeSend:#quickSearchStringHolderChanged to:self.
    ].
    ^ quickSearchStringHolder.
!

selectedItem
    selectedItem isNil ifTrue:[
        selectedItem := ValueHolder new.
        selectedItem addDependent:self.
    ].
    ^ selectedItem.
!

showNonDefaultSettingsHolder
    |holder|

    holder := builder valueAspectFor:#'showNonDefaultSettingsHolder' initialValue:false.
    holder onChangeSend:#showNonDefaultSettingsHolderChanged to:self.
    ^ holder
!

showNonDefaultSettingsMenuItemVisibleHolder
    ^ builder valueAspectFor:#'showNonDefaultSettingsMenuItemVisibleHolder' initialValue:false
!

subCanvasApplicationHolder
    subCanvasApplicationHolder isNil ifTrue:[
        subCanvasApplicationHolder := ValueHolder new.
    ].
    ^ subCanvasApplicationHolder.
!

whyDisabledInfoHolder
    whyDisabledInfoHolder isNil ifTrue:[
        whyDisabledInfoHolder := '' asValue.
    ].
    ^ whyDisabledInfoHolder.

    "Created: / 25-01-2007 / 17:13:50 / cg"
! !

!SettingsDialog methodsFor:'change & update'!

modifiedChanged
    |modified|

    modified := self subCanvasApplication modifiedChannel value.
    self enableOK value:modified.
    self enableReload value:modified.
!

selectionChanged
    |item oldAppl noApp lbl window app itemLabel|

    self selectedItem value == lastSelection  ifTrue:[ ^ self].

    oldAppl := self subCanvasApplication.
    oldAppl notNil ifTrue:[
        oldAppl saveRequest ifFalse:[
            lastSelection notNil ifTrue:[
            self
                enqueueMessage:#value 
                for:[ self selectedItem value:lastSelection ]
                arguments:#().
            ].
            ^ self
        ].
        oldAppl modifiedChannel removeDependent:self.
        self unhighlightWidgets.
    ].

    item := self selectedItem value.

    item isNil ifTrue:[ item := applicationList root ].

    lastSelection := item.
    noApp := (item isNil) ifTrue:true ifFalse:[item isCategory].
    self enableOK value:(noApp not).
    self enableReload value:(noApp not).
    self enableHelp value:(noApp not).

    window := self window.
    window notNil ifTrue:[
        lbl := self rootItemLabel ? 'Settings Dialog'.
        item notNil ifTrue:[
            itemLabel := item label.
            itemLabel := itemLabel copyReplaceAll:(Character cr) with:(Character space) ifNone:itemLabel.
            itemLabel ~= lbl ifTrue:[
                lbl := lbl , ' [', itemLabel, ']'.
            ]
        ].
        window label:lbl.
    ].

    builder notNil ifTrue:[ |box|
        "hide the DisabledSettingsBox"
        box := builder componentAt:#DisabledSettingsBox.
        box notNil ifTrue:[
            box beInvisible; lower.
        ].
    ].

    noApp ifTrue:[
        self subCanvasApplicationHolder value:nil.
        ^ self
    ].

    app := item application.
    app isNil ifTrue:[
        app := item applicationClass basicNew.
        (app isEnabledInSettingsDialog:self) ifFalse:[
            "raise the DisabledSettingsBox above the settings window"
            self whyDisabledInfoHolder value:('These Settings are currently disabled, because\',app whyDisabledInSettingsDialogInfo) withCRs.
            builder notNil ifTrue:[ |box|
                box := builder componentAt:#DisabledSettingsBox.
                box notNil ifTrue:[
                    box beVisible; raise.
                ].
            ].
            self subCanvasApplicationHolder value:nil.
            ^ self
        ].

        item application:app.
        app settingsDialog:self.
        app basicInitialize.
        app createBuilder.
        app initialize.
    ].
    self withWaitCursorDo:[
        app settingsDialog:self.
        app readSettings.
    ].
    app modifiedChannel addDependent:self.
    self subCanvasApplicationHolder value:app.
    self modifiedChanged.
    
    self highlightWidgetsWithMatchingSearchString.
    "/ does not yet work fully
    false ifTrue:[
        self highlightWidgetsWithChangedSettings.
    ].
    
    "Modified: / 29-10-2010 / 11:51:13 / cg"
    "Modified: / 17-02-2012 / 10:24:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    |subCanvasApplication|

    changedObject == self selectedItem ifTrue:[
        super update:something with:aParameter from:changedObject.
        self selectionChanged.
        ^ self.
    ].
    subCanvasApplication := self subCanvasApplication.
    (subCanvasApplication notNil 
    and:[changedObject == subCanvasApplication modifiedChannel]) ifTrue:[
        self modifiedChanged.
    ].
    super update:something with:aParameter from:changedObject
! !

!SettingsDialog methodsFor:'changed settings highlighting'!

highlightWidgetsWithChangedSettings
    "whenever an app is selected AND a quick search string is present,
     go through the widgets and highlight those which match.
     This is done by looking at the helpkey and model aspects for a match"

    |app pattern widgetsToHighlight|
    
    highlightedWidgetsOriginalAttributes notNil ifTrue:[
        self unhighlightWidgets.
    ].
    
    (app := subCanvasApplicationHolder value) isNil ifTrue:[^ self].

    widgetsToHighlight := self widgetsWithChangedSettingsIn:app.
    self highlightWidgets:widgetsToHighlight.
!

showNonDefaultSettingsHolderChanged
    "the show-non-default settings check box has changed.
     remember the current selection, 
     update the highlighting of matching fields (and expand corresponding tree nodes),
     then reselect (because the treeView is too stupid in loosing the selection,
     when expanding/hiding)"
     
    |oldSelection pattern showNonDefault matchingTreeItems|
    
    oldSelection := self selectedItem value.
    self unhighlightFoundItemsFromSearch.
    
    (showNonDefault := self showNonDefaultSettingsHolder value) ifFalse:[^ self].

    self highlightApplicationsForWhich:[:app | app hasValuesDifferentFromDefault].
    
    oldSelection notNil ifTrue:[
        oldSelection makeVisible.
        self selectedItem value:oldSelection.
        self highlightWidgetsWithChangedSettings
    ].    
!

widgetsWithChangedSettingsIn:anApplication
    "helper:
     go through the widgets and find those which have a value different
     from the default settings.
     This is done by looking at model value (hope they have)"

    |  widgetsToHighlight |
    
    widgetsToHighlight := Set new.
    
    anApplication widgetsWithChangedSettingsDo:[:eachView |
        |alreadyIn|

        "/ check if a superview also has it (frames/framedboxes, etc.)
        alreadyIn := false.
        eachView allSuperViewsDo:[:sv | (widgetsToHighlight includes:sv) ifTrue:[ alreadyIn := true]].
        alreadyIn ifFalse:[ widgetsToHighlight add:eachView ].
    ].
    ^ widgetsToHighlight.
! !

!SettingsDialog methodsFor:'initialization & release'!

closeRequest
    "This is a hook method.
     It will be invoked when your app/dialog-window is about to be closed.
     This method has a chance to suppress the close by returning false.
     See also #closeDownViews, which is invoked when the close is really done."

    | req |

    (self sendSaveRequestToCurrent == false) ifTrue:[^ self].

    "/ if any of my subApps has made a change, ask user if he wants
    "/ to write the settings file
    (self realApplications contains:[:app | app didModifySettings]) ifTrue:[
        "D121136 - Filename doesnot understand allBold"
        (Dialog 
            confirm:(resources 
                        stringWithCRs:'Save your changed settings in the settings file?\(which is: "%1")\\If not saved, these changes only apply to your current session.'
                        with:self class currentSettingsFilename asString allBold))
        ifTrue:[
            self saveSettingsWithoutAskingForFile.
        ].
        "D122540 - Dialog opens twice"
        self realApplications do:[:each| each clearDidModifySettings ].
    ].

    self destroyAll.

    req := self requestor.
    req notNil ifTrue:[
        req settingsClosed.
    ].
    super closeRequest
!

createRootItem
    |rootItem lbl|

    "/ this is stupidly wrong!!
    "/ if the launcher thinks it needs this, it should set the resources
    "/ (otherwise, reuse of resource dialog is difficult eg. in expecco)
    "/ resources := AbstractLauncherApplication resources.
    rootItem := self class itemClass new.
    lbl := resources string:'Settings'.
    rootItem label:lbl "allBold".
    rootItem nameString:lbl.
    rootItem icon:self class settingsIcon.
    rootItem applicationClass: SettingsFilenameAppl.
    ^ rootItem

    "Created: / 03-11-2007 / 14:22:01 / cg"
    "Modified: / 07-02-2012 / 01:03:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    |rootItem|

    super initialize.
    rootItem := self createRootItem.
    self applicationList root:rootItem; showRoot:true "false".
    self selectedItem value:rootItem.

    "Modified: / 03-11-2007 / 14:22:18 / cg"
!

postBuildSubCanvas:aWidget
    aWidget keepClientView:true. 
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    self window isModal ifFalse:[
        self closeButtonVisibleHolder value:true
    ].    
!

postOpenWith:aBuilder
    |items|

    self rootItem expand.
    super postOpenWith:aBuilder.
    (items := self rootItem children) size == 1 ifTrue:[
        self selectedItem value: items anyOne.
    ]

    "Modified: / 03-11-2007 / 14:23:25 / cg"
    "Modified: / 03-10-2011 / 16:27:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SettingsDialog methodsFor:'menu actions'!

askForFileAndSaveSettings
    self class askForFileAndSaveSettings.
    self realApplicationsDo:[:app | app clearDidModifySettings].
!

loadSettingsFromFile
    "restore settings from a settings-file."

    "a temporary kludge - we need a central systemSettings object for this,
     which can be saved/restored with a single store/read."

    |oldFile dir fileName transcript launcher|

    (oldFile := UserPreferences current at:#settingsFilename) notNil ifTrue:[
        dir := oldFile asFilename directory.
    ].

    fileName := Dialog 
        requestFileName:(resources string:'Load Settings from File') 
        default:'settings.stx'
        ok:(resources string:'Load') 
        abort:(resources string:'Cancel') 
        pattern:'*.stx'
        fromDirectory:dir.

    (fileName size == 0) ifTrue:[
        "/ canceled
        ^ self
    ].

    self withWaitCursorDo:[
        Smalltalk fileIn:fileName.

        "/ Transcript current topView model reOpen.

        transcript := Transcript current.
        (transcript notNil and:[transcript isExternalStream not]) ifTrue:[
            launcher := transcript application.
            launcher notNil ifTrue:[
                launcher reopenLauncher.
            ]
        ].
        self sendLoadRequestToAll.
    ].

    "Modified: / 08-09-2006 / 19:23:15 / cg"
!

menuCollapseAll
    applicationList root children do:[:each | each collapse].
!

menuExpandAll
    applicationList root children do:[:each | each recursiveExpand].
!

saveSettingsWithoutAskingForFile
    self class saveSettingsWithoutAskingForFile.
    self realApplicationsDo:[:app | app clearDidModifySettings].
! !

!SettingsDialog methodsFor:'quick search support'!

getWordMatchPattern
    "pattern is needed at multiple places"

    |searchString plainWord pattern|

    searchString := self quickSearchStringHolder value.
    searchString isEmptyOrNil ifTrue:[^ nil].

    plainWord := searchString withoutSeparators.
    plainWord isEmpty ifTrue:[^ nil].

    searchString first isSeparator ifTrue:[
        searchString last isSeparator ifTrue:[
            pattern := plainWord.
        ] ifFalse:[
            pattern := plainWord,'*'.
        ].    
    ] ifFalse:[
        searchString last isSeparator ifTrue:[
            pattern := '*',plainWord.
        ] ifFalse:[    
            pattern := '*',searchString,'*'.
        ].
    ].
    ^ pattern.
!

highlightApplicationsForWhich:aBlock
    "common code for string search and changed-settings search.
     Enumerates all applications with aBlock;
     if it return true, it will be collectet and highlighted."
     
    |oldSelection pattern showNonDefault matchingTreeItems|
    
    applicationList root recursiveExpand.

    matchingTreeItems := OrderedCollection new.
    "/ now search all specs for this word
    applicationList root recursiveDo:[:eachSettingsAppItem |
        |appClass app words|
        
        (appClass := eachSettingsAppItem applicationClass) notNil ifTrue:[
            (app := eachSettingsAppItem application) isNil ifTrue:[
                eachSettingsAppItem application:(app := appClass new).
            ].
            
            (aBlock value:app) ifTrue:[
                matchingTreeItems add:eachSettingsAppItem.
            ].   
        ].
    ].
    
    applicationList root children do:[:c | c recursiveCollapse].
    "/ now expand all matches
    matchingTreeItems do:[:eachMatchingItem |
        eachMatchingItem label:(eachMatchingItem label string allBold withColor:Color red).
        applicationList itemChanged:#redraw with:nil from:eachMatchingItem.
        eachMatchingItem makeVisible
    ]. 
!

highlightWidgets:aSetOfWidget
    "highlight a matching widget"

    highlightedWidgetsOriginalAttributes := Dictionary new.
    aSetOfWidget do:[:w |
        |perWidget|
        
        highlightedWidgetsOriginalAttributes at:w put:(perWidget := Dictionary new).
        perWidget at:#borderWidth: put:w borderWidth.
        perWidget at:#borderColor: put:w borderColor.
        
        w borderWidth:1.
        w borderColor:Color red.
    ].
!

highlightWidgetsWithMatchingSearchString
    "whenever an app is selected AND a quick search string is present,
     go through the widgets and highlight those which match.
     This is done by looking at the helpkey and model aspects for a match"

    |app pattern widgetsToHighlight|
    
    highlightedWidgetsOriginalAttributes notNil ifTrue:[
        self unhighlightWidgets.
    ].
    
    (pattern := self getWordMatchPattern) isNil ifTrue:[^ self].

    (app := subCanvasApplicationHolder value) isNil ifTrue:[^ self].

    widgetsToHighlight := self widgetsWithMatchingSearchStringIn:app.
    self highlightWidgets:widgetsToHighlight.
!

quickSearchStringHolderChanged
    "the text in the quick search entry field has changed.
     remember the current selection, 
     update the highlighting of matching fields (and expand corresponding tree nodes),
     then reselect (because the treeView is too stupid in loosing the selection,
     when expanding/hiding)"
     
    |oldSelection pattern matchingTreeItems|
    
    oldSelection := self selectedItem value.
    self unhighlightFoundItemsFromSearch.
    
    (pattern := self getWordMatchPattern) isNil ifTrue:[^ self].

    self 
        highlightApplicationsForWhich:[:app |
            |ok words widgetsToHighlight|
            
            words := app quickSearchStrings.
            ok := false.
            (words contains:[:word | pattern match:word caseSensitive:false ])
            ifTrue:[
                app window isNil ifTrue:[
                    ok := true
                ] ifFalse:[                
                    widgetsToHighlight := self widgetsWithMatchingSearchStringIn:app.
                    ok := widgetsToHighlight notEmptyOrNil.
                ]    
            ].
            ok
        ].

    oldSelection notNil ifTrue:[
        oldSelection makeVisible.
        self selectedItem value:oldSelection.
        self highlightWidgetsWithMatchingSearchString.
    ].    
!

unhighlightFoundItemsFromSearch
    "undo any highlighting of matching fields (from the previous show matching items)"

    |oldSelection pattern showNonDefault matchingTreeItems|
    
    self unhighlightWidgets.

    "/ make all labels normal
    applicationList root recursiveDo:[:eachSettingsAppItem |
        |lbl|
        lbl := eachSettingsAppItem label.
        lbl hasChangeOfEmphasis ifTrue:[
            eachSettingsAppItem label:(lbl string).
            applicationList itemChanged:#redraw with:nil from:eachSettingsAppItem.
        ]. 
    ]. 
!

unhighlightWidgets
    "unhighlight all previously highligted widgets
     (restore their previous attributes)"

    highlightedWidgetsOriginalAttributes notNil ifTrue:[
        highlightedWidgetsOriginalAttributes keysAndValuesDo:[:widget :oldValues |
            oldValues keysAndValuesDo:[:sel :oldValue |
                widget perform:sel with:oldValue
            ].    
        ].    
        highlightedWidgetsOriginalAttributes := nil.
    ].  
!

widgetsWithMatchingSearchStringIn:anApplication
    "helper:
     go through the widgets and find those which match.
     This is done by looking at the helpkey and model aspects for a match"

    |pattern words widgetsToHighlight allWords|
    
    (pattern := self getWordMatchPattern) isNil ifTrue:[^ self].

    allWords :=
        [:text |

            |words xLatedText|
            words := Set new.
            text notNil ifTrue:[
                text asCollectionOfWordsDo:[:w | words add:w asLowercase].
                xLatedText := anApplication resources string:text.
                (xLatedText notNil and:[xLatedText ~= text]) ifTrue:[
                    xLatedText asCollectionOfWordsDo:[:w | words add:w asLowercase].
                ].    
            ]. 
            words
        ].    
    
    widgetsToHighlight := Set new.
    words := anApplication quickSearchStrings.
    
    (words contains:[:word | pattern match:word caseSensitive:false]) ifTrue:[
        "/ ok - there is a match in this app;
        "/ look which widget matches it in its helpKey or label
        
        anApplication window withAllSubViewsDo:[:eachView |
            |wordsInWidget widgetHasIt label helpKey xLatedText helpText tooltip|

            wordsInWidget := Set new.
             
            (helpKey := eachView helpKey) notNil ifTrue:[
                wordsInWidget add:helpKey.
                helpText := anApplication helpTextForKey:helpKey.
                wordsInWidget addAll:(allWords value:helpText).
                tooltip := anApplication flyByHelpTextForKey:helpKey.
                wordsInWidget addAll:(allWords value:tooltip).
            ].
            label := eachView perform:#label ifNotUnderstood:nil.
            (label notNil and:[label isString]) ifTrue:[
                label := label string.
                wordsInWidget addAll:(allWords value:label)
            ].
            
            widgetHasIt := wordsInWidget contains:[:w | pattern match:w caseSensitive:false ].
            widgetHasIt ifTrue:[
                |alreadyIn|
                
                "/ check if a superview also has it (frames/framedboxes, etc.)
                alreadyIn := false.
                eachView allSuperViewsDo:[:sv | (widgetsToHighlight includes:sv) ifTrue:[ alreadyIn := true]].
                alreadyIn ifFalse:[
                    ((eachView superView isKindOf:HorizontalPanelView)
                    or:[eachView superView class == View]) ifTrue:[
                        (widgetsToHighlight includes:eachView superView) ifFalse:[
                            eachView superView subViews size > 1 ifTrue:[
                                (eachView superView subViews contains:[:some | widgetsToHighlight includes:some])
                                ifTrue:[
                                    "/ multiple in a panel; highlight the panel, not the children.
                                    widgetsToHighlight add:eachView superView.
                                    widgetsToHighlight removeAllFoundIn:eachView superView subViews.
                                    alreadyIn := true.
                                ].    
                            ].    
                        ].    
                    ].    
                    alreadyIn ifFalse:[ widgetsToHighlight add:eachView ].
                ]    
            ].    
        ].   
    ].
    ^ widgetsToHighlight.
! !

!SettingsDialog methodsFor:'selection'!

selectItemWithClass:aClass
    "select an item based on the sub-settings application class"

    |entry|

    entry := applicationList root
                recursiveDetect:[:entry | entry applicationClass = aClass].
    entry notNil ifTrue:[
        entry makeVisible.
        self selectedItem value:entry
    ].

    "Created: / 29-10-2010 / 11:54:13 / cg"
!

selectItemWithName:aPathString
    "select an item based on the sub-settings page name.
     See standardRawSettingsList for a list of names"

    |entry|

    entry := applicationList root
                recursiveDetect:[:entry | entry nameString = aPathString].
    entry notNil ifTrue:[
        entry makeVisible.
        self selectedItem value:entry
    ].
! !

!SettingsDialog::HierarchicalApplicationList::ApplicationItem methodsFor:'accessing'!

application
    "return the value of the instance variable 'application' (automatically generated)"

    ^ application
!

application:something
    "set the value of the instance variable 'application' (automatically generated)"

    application := something.
!

applicationClass
    "return the value of the instance variable 'applicationClass' (automatically generated)"

    ^ applicationClass
!

applicationClass:something
    "set the value of the instance variable 'applicationClass' (automatically generated)"

    applicationClass := something.
!

label:something
    "reset the with in pixels..."
    width := nil.
    label := something.
!

nameString
    "return the value of the instance variable 'nameString' (automatically generated)"

    ^ nameString
!

nameString:something
    "set the value of the instance variable 'nameString' (automatically generated)"

    nameString := something.
! !

!SettingsDialog::HierarchicalApplicationList::ApplicationItem methodsFor:'menu'!

middleButtonMenu

    <resource: #programMenu >

    |application|

    (application := self application) isNil ifTrue:[ ^ nil].
    ^ application settingsDialogPopUpMenu
! !

!SettingsDialog::HierarchicalApplicationList::ApplicationItem methodsFor:'printing & storing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    super printOn:aGCOrStream.
    aGCOrStream nextPutAll:' ['.
    label printOn:aGCOrStream.
    aGCOrStream nextPut:$].
!

printOn:aStream
    aStream 
        nextPutAll:self class nameWithoutPrefix;
        space.
    self label printOn:aStream.

    "Created: / 24-08-2010 / 18:36:17 / sr"
! !

!SettingsDialog::HierarchicalApplicationList::ApplicationItem methodsFor:'queries'!

canCollapse
    "the rootItem cannot be collapsed"

    "/ first check if we are expanded, if not answer false
    ^ (self isExpanded and:[self isRootItem not])
!

isCategory

    ^ self applicationClass isNil
! !

!SettingsDialog::SettingsFilenameAppl class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#openSettingsFile
'Click to open a file browser on the settings file'

#reloadSettingsFile
'Reload the settings from the file'

#saveAsPrivateSettingsFile
'Save the settings into your private settings file'

)
! !

!SettingsDialog::SettingsFilenameAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SettingsDialog::SettingsFilenameAppl andSelector:#windowSpec
     SettingsDialog::SettingsFilenameAppl new openInterface:#windowSpec
     SettingsDialog::SettingsFilenameAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Settings File'
         name: 'Settings File'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 426 359)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             name: 'InfoLabel'
             layout: (LayoutFrame 0 0 -169 0.5 0 1 -45 0.5)
             translateLabel: true
             labelChannel: infoLabelHolder
           )
          (LabelSpec
             label: 'Preferences are stored in file:'
             name: 'Label1'
             layout: (LayoutFrame 0 0 -30 0.5 0 1 0 0.5)
             translateLabel: true
           )
          (LinkButtonSpec
             label: 'LinkButton'
             name: 'EditPreferences'
             layout: (LayoutFrame 0 0 0 0.5 0 1 30 0.5)
             activeHelpKey: openSettingsFile
             foregroundColor: (Color 0.0 0.0 100.0)
             translateLabel: true
             labelChannel: settingsFilenameHolder
             model: openSettingsFile
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 53 0.5 0 1 101 0.5)
             horizontalLayout: centerMax
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Reload'
                   name: 'Button2'
                   activeHelpKey: reloadSettingsFile
                   translateLabel: true
                   model: reloadSettingsFile
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'Save as Private'
                   name: 'Button3'
                   activeHelpKey: saveAsPrivateSettingsFile
                   translateLabel: true
                   model: saveAsPrivateSettingsFile
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'File Browser'
                   name: 'Button1'
                   activeHelpKey: openSettingsFile
                   translateLabel: true
                   model: openSettingsFile
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!SettingsDialog::SettingsFilenameAppl methodsFor:'actions'!

openSettingsFile
    self openSettingsFile: (self settingsFile)

    "Created: / 07-02-2012 / 11:15:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reloadSettingsFile
    self reloadSettingsFile: (self settingsFile)

    "Created: / 17-02-2012 / 10:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveAsPrivateSettingsFile
    |fn|

    fn := UserPreferences defaultUserSettingsFile pathName.
    SettingsDialog saveSettingsTo:fn.
    UserPreferences current at:#settingsFilename put:fn.
    settingsFilenameHolder value:fn.
! !

!SettingsDialog::SettingsFilenameAppl methodsFor:'aspects'!

infoLabelHolder
    infoLabelHolder isNil ifTrue:[
        infoLabelHolder := nil asValue.
        infoLabelHolder value:
                     (resources 
                        stringWithCRs:(
                            'Unless saved via the "Save"-Button,'
                            , '\changes affect the current session only.')).

    ].
    ^ infoLabelHolder
!

settingsFilenameHolder
    settingsFilenameHolder isNil ifTrue:[
        settingsFilenameHolder := nil asValue.
        self basicReadSettings.
    ].
    ^ settingsFilenameHolder

    "Created: / 07-02-2012 / 01:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SettingsDialog::SettingsFilenameAppl methodsFor:'private'!

openSettingsFile: filename 

    UserPreferences fileBrowserClass
        openOnFileNamed:filename editing:true

    "Created: / 07-02-2012 / 01:08:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reloadSettingsFile: filename 

    filename asFilename fileIn.
    UserPreferences current at: #settingsFilename put: filename asFilename pathName

    "Created: / 17-02-2012 / 10:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SettingsDialog::SettingsFilenameAppl methodsFor:'protocol'!

basicReadSettings
    |filename|

    filename := self settingsFile.
"/      filename := filename asText
"/        asActionLinkTo:[ self openSettingsFile: filename ].
    self settingsFilenameHolder value:filename.
!

basicSaveSettings
    ^self

    "Modified: / 07-02-2012 / 01:03:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings'
!

helpFilename
    "subclasses must return the relative name of a helpFile
     in the doc/online/<language>/help directory.
     Or nil, if no help is available."

    ^ nil.
! !

!SettingsDialog::SettingsFilenameAppl methodsFor:'queries'!

hasUnsavedChanges
    ^false

    "Modified: / 07-02-2012 / 01:03:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settingsFile
    ^ SettingsDialog currentSettingsFilename
! !

!SettingsDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


SettingsDialog initialize!
