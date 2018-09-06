"
 COPYRIGHT (c) 2014 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

AbstractSettingsApplication subclass:#FontSettingsApplication
	instanceVariableNames:'filter allOfThem labelDef buttonDef listDef menuDef textDef
		othersDef allFontLabelHolder buttonsFontLabelHolder
		textFontLabelHolder labelsFontLabelHolder listsFontLabelHolder
		menusFontLabelHolder otherFontLabelHolder allLabel buttonsLabel
		textLabel labelLabel listsLabel menuLabel inputFieldLabel
		inputFieldDef inputFieldFontLabelHolder otherLabel
		linuxFontWorkaround otherDef tooltipDef tooltipFontLabelHolder
		tooltipLabel useXftFontsOnly fontSizeSelectionHolder
		lookSelectionHolder useXFontsOnly'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!FontSettingsApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
! !

!FontSettingsApplication class methodsFor:'instance creation'!

fontForEncoding:encodingMatch

    | inst |

    inst := self new.
    inst encodingMatch:encodingMatch.
    self initialize.
    self open.
! !

!FontSettingsApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FontSettingsAppl    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

changeCodeFont
'Open a font dialog to change the font used in code views only'

changeInputFieldFont
'Open a font dialog to change the font used in input fields only'

changeLabelFont
'Open a font dialog to change the font used in labels only'

changeListFont
'Open a font dialog to change the font used in lists only'

changeMenuFont
'Open a font dialog to change the font used in menus only'

changeButtonFont
'Open a font dialog to change the font used in buttons only'

changeTooltipFont
'Open a font dialog to change the font used in tooltips only'

changeAllFont
'Open a font dialog to change the font used in all views'

#resetToDefault
'Reset fonts back to original default values (as specified in the window style-file and OS settings)'

#changeToHighContrast
'Change settings for higher contrast.\Useful for presentations and outdor operation (bright sunlight)'

#changeToNormalContrast
'Change settings for normal contrast.'

#changeToBigFonts
'Change settings for bigger fonts.\Useful for presentations'

#changeToHugeFonts
'Change settings for huge fonts.\Useful for presentations'

#changeToSmallFonts
'Change settings for small fonts.\Useful on smaller screens (13 or 15 inch)'

#changeToNormalFonts
'Change settings for default font sizes.'

#changeToSTXLook
'Change settings for an ST/X-like look with fixed-width code fonts'

#changeToSTXLookXft
'Change settings for an ST/X-like look with fixed-width code fonts).\Uses better looking Xft fonts if avaiable (XWindow only)'

#changeToSqueakLook
'Change settings for a Squeak-like look with variable code fonts'

#changeToVisualAgeLook
'Change settings for a VisualAge-like look with bold variable code fonts'

#useXftFontsOnly
'Don''t try to use and don''t offer non-Xft fonts in font selection dialogs (XWindow only).\If checked, ST/X will use the much nicer looking, but sometimes slower Xft fonts.'

#useXFontsOnly
'Don''t try to use and don''t offer Xft fonts in font selection dialogs (XWindow only).\Check this, if you are working with remote displays via a slow communication line,\to suppress any Xft font usage.\(Xft font rendering requires a much higher bandwidth.)'

)

    "Created: / 17-03-2012 / 11:37:51 / cg"
! !

!FontSettingsApplication class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary fontIcon
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
    
    ^ Icon constantNamed:#'FontSettingsAppl class defaultIcon2'
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
! !

!FontSettingsApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::FontSettingsApplication andSelector:#windowSpec
     Tools::FontSettingsApplication new openInterface:#windowSpec
     Tools::FontSettingsApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Font Settings'
         name: 'Font Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 643 810)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fitSpace
             verticalLayout: topSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (TextEditorSpec
                   name: 'TextEditor1'
                   style: labelFont
                   model: infoText
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   miniScrollerHorizontal: true
                   miniScrollerVertical: true
                   isReadOnly: true
                   hasKeyboardFocusInitially: false
                   extent: (Point 637 132)
                   postBuildCallback: postBuildHelpLabel:
                   viewClassName: 'ListView'
                 )
                (DividerSpec
                   name: 'Separator14'
                   extent: (Point 637 4)
                 )
                (ViewSpec
                   name: 'CodeBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Code'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'Button1'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         activeHelpKey: changeCodeFont
                         translateLabel: true
                         tabable: true
                         model: changeTextFont
                       )
                      (LabelSpec
                         label: 'Text Font'
                         name: 'Label2'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         translateLabel: true
                         labelChannel: textFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildTextFontLabel:
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'InputFieldsBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Input Fields'
                         name: 'Input Fields'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'ChangeText'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         activeHelpKey: changeInputFieldFont
                         translateLabel: true
                         tabable: true
                         model: changeInputFieldFont
                       )
                      (LabelSpec
                         label: 'InputFields Font'
                         name: 'InputFieldsFont'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         translateLabel: true
                         labelChannel: inputFieldFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildInputFieldFontLabel:
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'ListsBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Lists'
                         name: 'Lists'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'ChangeLists'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         activeHelpKey: changeListFont
                         translateLabel: true
                         tabable: true
                         model: changeListsFont
                       )
                      (LabelSpec
                         label: 'Lists Font'
                         name: 'ListsFont'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         translateLabel: true
                         labelChannel: listsFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildListsFontLabel:
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'MenusBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Menus'
                         name: 'Menus'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'ChangeMenus'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         activeHelpKey: changeMenuFont
                         translateLabel: true
                         tabable: true
                         model: changeMenusFont
                       )
                      (LabelSpec
                         label: 'Menus Font'
                         name: 'MenusFont'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         translateLabel: true
                         labelChannel: menusFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildMenuesFontLabel:
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'LabelsBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Labels'
                         name: 'Labels'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'ChangeLabels'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         activeHelpKey: changeLabelFont
                         translateLabel: true
                         tabable: true
                         model: changeLabelsFont
                       )
                      (LabelSpec
                         label: 'Labels'
                         name: 'LabelsFont'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         translateLabel: true
                         labelChannel: labelsFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildLabelsFontLabel:
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'ButtonsBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Buttons'
                         name: 'Buttons'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'Change Buttons'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         activeHelpKey: changeButtonFont
                         translateLabel: true
                         tabable: true
                         model: changeButtonsFont
                       )
                      (LabelSpec
                         label: 'Buttons Font'
                         name: 'ButtonsFont'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         translateLabel: true
                         labelChannel: buttonsFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildButtonsFontLabel:
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'ToolTipsBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Tooltips'
                         name: 'Label7'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'Button11'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         activeHelpKey: changeTooltipFont
                         translateLabel: true
                         tabable: true
                         model: changeTooltipFont
                       )
                      (LabelSpec
                         label: 'Label'
                         name: 'Label8'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         translateLabel: true
                         labelChannel: tooltipFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildTooltipFontLabel:
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'OtherBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'All Others'
                         name: 'Label5'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'Button9'
                         layout: (LayoutFrame 100 0.0 15 0 205 0 37 0)
                         translateLabel: true
                         tabable: true
                         model: changeOtherFont
                       )
                      (LabelSpec
                         label: 'Label'
                         name: 'Label6'
                         layout: (LayoutFrame 210 0 15 0 -2 1 37 0)
                         activeHelpKey: changeOtherFont
                         translateLabel: true
                         labelChannel: otherFontLabelHolder
                         adjust: left
                         postBuildCallback: postBuildOtherFontLabel:
                       )
                      (DividerSpec
                         name: 'Separator13'
                         layout: (LayoutFrame 0 0.0 -3 1 0 1.0 0 1)
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (ViewSpec
                   name: 'AllBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'All'
                         name: 'All'
                         layout: (LayoutFrame 0 0.0 4 0 0 1.0 24 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ActionButtonSpec
                         label: 'Change...'
                         name: 'ChangeAll'
                         layout: (LayoutFrame 100 0.0 11 0 205 0 33 0)
                         activeHelpKey: changeAllFont
                         translateLabel: true
                         tabable: true
                         model: changeAllFont
                       )
                      (DividerSpec
                         name: 'Separator1'
                         layout: (LayoutFrame 0 0.0 -3 1 0 1.0 0 1)
                       )
                      )
                    
                   )
                   extent: (Point 637 45)
                 )
                (CheckBoxSpec
                   label: 'Only Use Xft Fonts / Suppress Ugly X-Fonts (Unix Only)'
                   name: 'CheckBox1'
                   activeHelpKey: useXftFontsOnly
                   visibilityChannel: useXftFontsOnlyVisible
                   enableChannel: useXftFontsOnlyEnabled
                   model: useXftFontsOnly
                   translateLabel: true
                   extent: (Point 637 30)
                 )
                (CheckBoxSpec
                   label: 'Only Use X Fonts / Suppress Slow Xft-Fonts (Unix Only)'
                   name: 'CheckBox2'
                   activeHelpKey: useXFontsOnly
                   visibilityChannel: useXFontsOnlyVisible
                   enableChannel: useXFontsOnlyEnabled
                   model: useXFontsOnly
                   translateLabel: true
                   extent: (Point 637 30)
                 )
                (DividerSpec
                   name: 'Separator12'
                   visibilityChannel: linuxFontWorkaroundVisible
                   extent: (Point 637 3)
                 )
                (ViewSpec
                   name: 'SpecialsBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Default'
                         name: 'Button2'
                         layout: (LayoutFrame 0 0.0 13 0 130 0 35 0)
                         activeHelpKey: resetToDefault
                         translateLabel: true
                         tabable: true
                         model: changeToDefault
                       )
                      (LabelSpec
                         label: 'Font Size:'
                         name: 'Label9'
                         layout: (LayoutFrame 148 0.0 13 0 298 0 35 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ComboListSpec
                         name: 'ComboList1'
                         layout: (LayoutFrame 256 0 13 0 0 1 35 0)
                         model: fontSizeSelectionHolder
                         comboList: fontSizeListLabels
                         useIndex: true
                       )
                      (ActionButtonSpec
                         label: 'High Contrast'
                         name: 'Button13'
                         layout: (LayoutFrame 256 0.0 77 0 386 0 99 0)
                         activeHelpKey: changeToHighContrast
                         translateLabel: true
                         tabable: true
                         model: changeToHighContrast
                       )
                      (LabelSpec
                         label: 'Look:'
                         name: 'Label10'
                         layout: (LayoutFrame 148 0.0 45 0 298 0 67 0)
                         translateLabel: true
                         adjust: left
                       )
                      (ComboListSpec
                         name: 'ComboList2'
                         layout: (LayoutFrame 256 0 45 0 0 1 67 0)
                         model: lookSelectionHolder
                         comboList: lookListLabels
                         useIndex: true
                       )
                      (ActionButtonSpec
                         label: 'Use Xft Fonts'
                         name: 'Button10'
                         layout: (LayoutFrame 0 0.0 77 0 130 0 99 0)
                         activeHelpKey: changeToSTXLookXft
                         translateLabel: true
                         tabable: true
                         model: changeToUseXft
                         enableChannel: hasXftFonts
                       )
                      (ActionButtonSpec
                         label: 'Normal Contrast'
                         name: 'Button14'
                         layout: (LayoutFrame 400 0.0 77 0 530 0 99 0)
                         activeHelpKey: changeToNormalContrast
                         translateLabel: true
                         tabable: true
                         model: changeToNormalContrast
                       )
                      )
                    
                   )
                   extent: (Point 637 124)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!FontSettingsApplication methodsFor:'accessing'!

encodingMatch:aEncodingMatch

    aEncodingMatch notNil ifTrue:[
        filter := [:f | f encoding notNil 
                        and:[aEncodingMatch match:f encoding]].
    ].
! !

!FontSettingsApplication methodsFor:'actions'!

basicReadFontSettings
    |prefs readFont sz lookIdx idx defaultTextFont|

    self readAspects:#(useXftFontsOnly useXFontsOnly) from:currentUserPrefs.
    
    prefs := currentUserPrefs fontPreferences.
    prefs isNil ifTrue:[
        prefs := Dictionary new.
    ].
    
    readFont := 
        [:key :default |
            |s fn|
            
            s := prefs at:key ifAbsent:nil.
            s notNil ifTrue:[
                fn := Object readFrom:s.
                self useXftFontsOnly value ifTrue:[
                    fn := XftFontDescription for:fn
                ].
            ].
            fn isNil ifTrue:[
                fn := default.
            ].
            fn
        ].
        
    self allOfThem value:View defaultFont.
    self otherDef value:(readFont value:#Other value:View defaultFont).
    self labelDef value:(readFont value:#Label value:Label defaultFont).
    self buttonDef value:(readFont value:#Button value:Button defaultFont).
    self listDef value:(readFont value:#List value:SelectionInListView defaultFont).
    self menuDef value:(readFont value:#Menu value:MenuView defaultFont).
    self textDef value:(readFont value:#Text value:TextView defaultFont).
    self inputFieldDef value:(readFont value:#InputField value:EditField defaultFont).
    self tooltipDef value:(readFont value:#Tooltip value:ActiveHelpView defaultFont).

    sz := TextView defaultFont size.
    idx := self fontSizeListValues indexOf:sz.
    idx ~~ 0 ifTrue:[
        self fontSizeSelectionHolder value:idx withoutNotifying:self.
    ].
    
    lookIdx := nil.
    defaultTextFont := TextView defaultFont.
    (defaultTextFont face = #bold) ifTrue:[
        lookIdx := self lookListValues indexOf:#vage.
    ] ifFalse:[
        (defaultTextFont onDevice:self device) isFixedWidth ifTrue:[
            lookIdx := self lookListValues indexOf:#stx.
        ] ifFalse:[    
            lookIdx := self lookListValues indexOf:#squeak.
        ].
    ].
    self lookSelectionHolder value:lookIdx withoutNotifying:self
    
    "Modified: / 10-10-2011 / 12:15:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 06-02-2012 / 12:22:39 / cg"
!

basicReadSettings
    self basicReadFontSettings.

    "Modified: / 06-02-2012 / 12:22:51 / cg"
    "Modified: / 20-04-2016 / 20:16:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings
    "/ |fn|

    self writeAspects: #( useXftFontsOnly useXFontsOnly) to: currentUserPrefs.
    currentUserPrefs fontPreferences:self fontSpecDictionary.
        
"/    fn := self otherDef value.
"/    SimpleView withAllSubclasses do:[:cls | cls defaultFont:fn].
"/
"/    fn := self labelDef value.
"/    Label defaultFont:fn.
"/    CheckBox defaultFont:fn.
"/
"/    fn := self buttonDef value.
"/    Button defaultFont:fn.
"/    Toggle defaultFont:fn.
"/
"/    fn := self textDef value.
"/    TextView withAllSubclasses do:[:cls | cls defaultFont:fn].
"/
"/    fn := self inputFieldDef value.
"/    EditField withAllSubclasses do:[:cls | cls defaultFont:fn].
"/
"/    fn := self listDef value.
"/    SelectionInListView withAllSubclasses do:[:cls | cls defaultFont:fn].
"/
"/    fn := self tooltipDef value.
"/    ActiveHelpView withAllSubclasses do:[:cls | cls defaultFont:fn].
"/
"/    fn := self menuDef value.
"/    ListView defaultFont:fn.
"/    MenuView defaultFont:fn.
"/    MenuPanel defaultFont:fn.
"/    NoteBookView defaultFont:fn.
"/    PullDownMenu defaultFont:fn.

    DebugView newDebugger.

    "Modified: / 20-04-2016 / 20:16:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeAllFont
    |f|

    self withWaitCursorDo:[
        f := FontPanel 
                fontFromUserInitial:(self allOfThem value) 
                title:(resources string:'Font for %1' with:'All')
                filter:filter.
    ].
    f notNil ifTrue:[
        "/ self allOfThem value:(f onDevice:allLabel device).
        self otherDef value:(f onDevice:otherLabel device).
        self labelDef value:(f onDevice:labelLabel device).
        self buttonDef value:(f onDevice:buttonsLabel device).
        self listDef value:(f onDevice:listsLabel device).
        self menuDef value:(f onDevice:menuLabel device).
        self textDef value:(f onDevice:textLabel device).
        self inputFieldDef value:(f onDevice:inputFieldLabel device).
        self tooltipDef value:(f onDevice:tooltipLabel device).
    ]
!

changeButtonsFont
    self changeFontFor:self buttonDef labelTitle:'Buttons'.
!

changeFontFor:aHolder labelTitle:labelTitle
    |f |

    self withWaitCursorDo:[
        f := FontPanel 
                fontFromUserInitial:(aHolder value) 
                title:(resources string:'Font for %1' with:labelTitle)
                filter:filter.
    ].
    f notNil ifTrue:[
        aHolder value:(f onDevice:self graphicsDevice).
    ].
!

changeInputFieldFont
    self changeFontFor:self inputFieldDef labelTitle:'Input Fields'.
!

changeLabelsFont
    self changeFontFor:self labelDef labelTitle:'Labels'.
!

changeListsFont
    self changeFontFor:self listDef labelTitle:'Lists'.
!

changeMenusFont
    self changeFontFor:self menuDef labelTitle:'Menus'.
!

changeOtherFont
    self changeFontFor:self otherDef labelTitle:'All Others'.
!

changeTextFont
    self changeFontFor:self textDef labelTitle:'Edited Text'.
!

changeTooltipFont
    self changeFontFor:self tooltipDef labelTitle:'Tooltops'.
!

defaultFontSpecDictionary
    ^ Dictionary new
        at:#Other put:View defaultFont storeString;
        at:#Label put:View defaultFont storeString;
        at:#Button put:Button defaultFont storeString;
        at:#Text put:TextView defaultFont storeString;
        at:#InputField put:EditField defaultFont storeString;
        at:#List put:SelectionInListView defaultFont storeString;
        at:#Tooltip put:ActiveHelpView defaultFont storeString;
        at:#Menu put:MenuView defaultFont storeString;
        yourself
!

fontSizeSelectionChanged
    |idx sz|
    
    idx := self fontSizeSelectionHolder value.
    sz := self fontSizeListValues at:idx ifAbsent:nil.
    sz notNil ifTrue:[
        self changeToFontsWithSize:sz
    ].    
!

fontSpecDictionary
    ^ Dictionary new
        at:#Other put:(self otherDef value storeString);
        at:#Label put:(self labelDef value storeString);
        at:#Button put:(self buttonDef value storeString);
        at:#Text put:(self textDef value storeString);
        at:#InputField put:(self inputFieldDef value storeString);
        at:#List put:(self listDef value storeString);
        at:#Tooltip put:(self tooltipDef value storeString);
        at:#Menu put:(self menuDef value storeString);
        yourself
!

lookSelectionChanged
    |idx look|
    
    idx := self lookSelectionHolder value.
    look := self lookListValues at:idx ifAbsent:nil.
    look notNil ifTrue:[
        look == #stx ifTrue:[
            self changeToSTXLook
        ] ifFalse:[
            look == #squeak ifTrue:[
                self changeToSqueakLook
            ] ifFalse:[
                look == #vage ifTrue:[
                    self changeToVisualAgeLook
                ]
            ]
        ].    
    ].    
!

readFontsFromWidgetDefaults
    |sz idx|

    self allOfThem value:View defaultFont.
    self otherDef value:(View defaultFont).
    self labelDef value:(Label defaultFont).
    self buttonDef value:(Button defaultFont).
    self listDef value:(SelectionInListView defaultFont).
    self menuDef value:(MenuView defaultFont).
    self textDef value:(TextView defaultFont).
    self inputFieldDef value:(EditField defaultFont).
    self tooltipDef value:(ActiveHelpView defaultFont).

    sz := TextView defaultFont size.
    idx := self fontSizeListValues indexOf:sz.
    idx ~~ 0 ifTrue:[
        self fontSizeSelectionHolder value:idx withoutNotifying:self.
    ].
! !

!FontSettingsApplication methodsFor:'actions-common looks'!

changeToBigFonts
    self changeToFontsWithSize:16
!

changeToDefault
    "/View readStyleSheetAndUpdateAllStyleCaches.
    SimpleView readStyleSheet.
    View updateAllStyleCaches.
    self readFontsFromWidgetDefaults.

    "Created: / 06-02-2012 / 12:06:00 / cg"
!

changeToFix:fixFont variable:variableFont
    self textDef value:fixFont.
    self inputFieldDef value:fixFont.

    self menuDef value:variableFont.
    self listDef value:variableFont.
    self labelDef value:variableFont.
    self buttonDef value:variableFont.
    self otherDef value:variableFont.
    self tooltipDef value:variableFont.

    self allOfThem value:variableFont.

    "Created: / 06-02-2012 / 12:18:34 / cg"
!

changeToFontsWithSize:points
    |f fixFont variableFont|

    f := TextView defaultFont.
    f := f asSize:points.
    TextView defaultFont:f.

    fixFont := (self textDef value "TextView defaultFont" asSize:points).
    variableFont := (self labelDef value "Label defaultFont" asSize:points).
    self changeToFix:fixFont variable:variableFont.
!

changeToHighContrast
    |fixFont variableFont|

    fixFont := (self textDef value "TextView defaultFont") asFace:'bold'.
    variableFont := (self labelDef value "Label defaultFont") asFace:'bold'.
    self changeToFix:fixFont variable:variableFont.

    "Created: / 06-02-2012 / 12:12:47 / cg"
!

changeToHugeFonts
    self changeToFontsWithSize:18
!

changeToNormalContrast
    |fixFont variableFont|

    fixFont := (self textDef value "TextView defaultFont") asFace:'medium'.
    variableFont := (self labelDef value "Label defaultFont") asFace:'medium'.
    self changeToFix:fixFont variable:variableFont.

    "Created: / 06-02-2012 / 12:12:47 / cg"
!

changeToSTXLook
    self changeToSTXLookWithSize:(TextView defaultFont size)
!

changeToSTXLookSmall
    |f|

    f := TextView defaultFont.
    f := f asSize:10.
    TextView defaultFont:f.
    
    self changeToSTXLook.
!

changeToSTXLookSmallXft
    |f|

    f := TextView defaultFont.
    f := f asSize:10.
    TextView defaultFont:f.

    self changeToSTXLookXft
!

changeToSTXLookWithSize:points
    |fixFont variableFont|

    fixFont := (Font family:'courier new' face:'medium' style:'roman' size:points).
    variableFont := (Font family:'arial' face:'medium' style:'roman' size:points).
    self changeToFix:fixFont variable:variableFont.

    "Created: / 17-03-2012 / 11:23:16 / cg"
!

changeToSTXLookXft
    |fixFont variableFont|

    self hasXftFonts ifFalse:[
        self changeToSTXLook.
        ^ self.
    ].

    fixFont := XftFontDescription family:'Courier' face:'regular' style:'roman' size:(TextView defaultFont size).
    variableFont := XftFontDescription family:'Arial' face:'regular' style:'roman' size:(TextView defaultFont size).
    self changeToFix:fixFont variable:variableFont.
!

changeToSmallFonts
    self changeToFontsWithSize:10
!

changeToSqueakLook
    |variableFont|

    variableFont := (Font family:'arial' face:'medium' style:'roman' size:(TextView defaultFont size)).
    self changeToFix:variableFont variable:variableFont.

    "Created: / 17-03-2012 / 11:22:59 / cg"
!

changeToUseXft

    |fixFont variableFont|

    self hasXftFonts ifFalse:[
        ^ self.
    ].

    TextView defaultFont:(XftFontDescription family:'Courier' face:'regular' style:'roman' size:(TextView defaultFont size)).
    Label defaultFont:(XftFontDescription family:'Arial' face:'regular' style:'roman' size:(Label defaultFont size)).
    
    fixFont := XftFontDescription family:'Courier' face:'regular' style:'roman' size:(TextView defaultFont size).
    variableFont := XftFontDescription family:'Arial' face:'regular' style:'roman' size:(TextView defaultFont size).
    self changeToFix:fixFont variable:variableFont.
!

changeToVisualAgeLook
    |variableFont variableBoldFont|

    variableBoldFont := (Font family:'arial' face:'bold' style:'roman' size:(TextView defaultFont size)).
    variableFont := (Font family:'arial' face:'medium' style:'roman' size:(TextView defaultFont size)).
    self changeToFix:variableBoldFont variable:variableBoldFont.

    self menuDef value:variableFont.

    "Created: / 17-03-2012 / 11:22:18 / cg"
! !

!FontSettingsApplication methodsFor:'aspects'!

allFontLabelHolder

    allFontLabelHolder isNil ifTrue:[
        allFontLabelHolder := '' asValue.
    ].
    ^ allFontLabelHolder.
!

allOfThem
    "return/create the 'allOfThem' value holder (automatically generated)"

    allOfThem isNil ifTrue:[
        allOfThem := ValueHolder new.
        allOfThem addDependent:self.
    ].
    ^ allOfThem
!

buttonDef
    "return/create the 'buttonDef' value holder (automatically generated)"

    buttonDef isNil ifTrue:[
        buttonDef := ValueHolder new.
        buttonDef addDependent:self.
    ].
    ^ buttonDef
!

buttonsFontLabelHolder

    buttonsFontLabelHolder isNil ifTrue:[
        buttonsFontLabelHolder := '' asValue.
    ].
    ^ buttonsFontLabelHolder.
!

fontSizeLabelsAndValues
    ^ #(
        ('Default (12)' 12)
        (nil nil)
        ('Tiny (8)' 8)
        ('Small (10)' 10)
        ('Big (16)' 16)
        ('Huge (18)' 18)
        ('<keep as is>' nil)
    )
!

fontSizeListLabels
    ^ self fontSizeLabelsAndValues collect:[:each | each first].
!

fontSizeListValues
    ^ self fontSizeLabelsAndValues collect:[:each | each second].
!

fontSizeSelectionHolder
    fontSizeSelectionHolder isNil ifTrue:[
        fontSizeSelectionHolder := nil asValue.
        fontSizeSelectionHolder onChangeSend:#fontSizeSelectionChanged to:self.
    ].
    ^ fontSizeSelectionHolder
!

infoText
    ^ (self resources 
        string:'FONT_SETTINGS_INFO'
        default:'Please notice that changes only affect new windows.
Existing  windows usually remember their initial font as created.
If required, reopen some of the views, including the Launcher itself.

Also notice: 
    unless you save your new settings, 
    only the current session is affected by changes here.') withCRs

    "Created: / 17-08-2010 / 10:52:00 / cg"
!

inputFieldDef
    inputFieldDef isNil ifTrue:[
        inputFieldDef := ValueHolder new.
        inputFieldDef addDependent:self.
    ].
    ^ inputFieldDef
!

inputFieldFontLabelHolder

    inputFieldFontLabelHolder isNil ifTrue:[
        inputFieldFontLabelHolder := '' asValue.
    ].
    ^ inputFieldFontLabelHolder.
!

labelDef
    "return/create the 'labelDef' value holder (automatically generated)"

    labelDef isNil ifTrue:[
        labelDef := ValueHolder new.
        labelDef addDependent:self.
    ].
    ^ labelDef
!

labelsFontLabelHolder
    labelsFontLabelHolder isNil ifTrue:[
        labelsFontLabelHolder := '' asValue.
    ].
    ^ labelsFontLabelHolder.
!

listDef
    "return/create the 'listDef' value holder (automatically generated)"

    listDef isNil ifTrue:[
        listDef := ValueHolder new.
        listDef addDependent:self.
    ].
    ^ listDef
!

listsFontLabelHolder

    listsFontLabelHolder isNil ifTrue:[
        listsFontLabelHolder := '' asValue.
    ].
    ^ listsFontLabelHolder.
!

lookLabelsAndValues
    ^ #(
        ('ST/X Look (monospace font for code)' #stx)
        ('Squeak Look (variable font for code)' #squeak)
        ('V''Age Look (variable bold font for code)' #vage)
        ('<keep as is>' nil)
    )
!

lookListLabels
    ^ self lookLabelsAndValues collect:[:each | each first].
!

lookListValues
    ^ self lookLabelsAndValues collect:[:each | each second].
!

lookSelectionHolder
    lookSelectionHolder isNil ifTrue:[
        lookSelectionHolder := nil asValue.
        lookSelectionHolder onChangeSend:#lookSelectionChanged to:self.
    ].
    ^ lookSelectionHolder
!

menuDef
    "return/create the 'menuDef' value holder (automatically generated)"

    menuDef isNil ifTrue:[
        menuDef := ValueHolder new.
        menuDef addDependent:self.
    ].
    ^ menuDef
!

menusFontLabelHolder

    menusFontLabelHolder isNil ifTrue:[
        menusFontLabelHolder := '' asValue.
    ].
    ^ menusFontLabelHolder.
!

otherDef
    otherDef isNil ifTrue:[
        otherDef := ValueHolder new.
        otherDef addDependent:self.
    ].
    ^ otherDef
!

otherFontLabelHolder

    otherFontLabelHolder isNil ifTrue:[
        otherFontLabelHolder := '' asValue.
    ].
    ^ otherFontLabelHolder.
!

textDef
    "return/create the 'textDef' value holder (automatically generated)"

    textDef isNil ifTrue:[
        textDef := ValueHolder new.
        textDef addDependent:self.
    ].
    ^ textDef
!

textFontLabelHolder

    textFontLabelHolder isNil ifTrue:[
        textFontLabelHolder := '' asValue.
    ].
    ^ textFontLabelHolder.
!

tooltipDef
    tooltipDef isNil ifTrue:[
        tooltipDef := ValueHolder new.
        tooltipDef addDependent:self.
    ].
    ^ tooltipDef
!

tooltipFontLabelHolder
    tooltipFontLabelHolder isNil ifTrue:[
        tooltipFontLabelHolder := '' asValue.
    ].
    ^ tooltipFontLabelHolder.
!

useXFontsOnly
    useXFontsOnly isNil ifTrue:[
        useXFontsOnly := false asValue.
        useXFontsOnly onChangeSend:#useXftSettingsChanged to:self
    ].
    ^ useXFontsOnly.
!

useXFontsOnlyEnabled
    ^ builder valueAspectFor:#useXFontsOnlyEnabled initialValue:true
!

useXFontsOnlyVisible

    ^ Screen platformName == #X11
!

useXftFontsOnly
    useXftFontsOnly isNil ifTrue:[
        useXftFontsOnly := false asValue.
        useXftFontsOnly onChangeSend:#useXftSettingsChanged to:self
    ].
    ^ useXftFontsOnly.
!

useXftFontsOnlyEnabled
    ^ builder valueAspectFor:#useXftFontsOnlyEnabled initialValue:true
!

useXftFontsOnlyVisible

    ^ Screen platformName == #X11
!

useXftSettingsChanged
    |enableUseXft enableUseX|
    
    self updateModifiedChannel.

    enableUseXft := enableUseX := true.
    
    self useXftFontsOnly value ifTrue:[
        enableUseX := false
    ].    
    self useXFontsOnly value ifTrue:[
        enableUseXft := false
    ].
    
    self useXFontsOnlyEnabled value:enableUseX.
    self useXftFontsOnlyEnabled value:enableUseXft
! !

!FontSettingsApplication methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    |whichLabel whichFontLabelHolder|

    builder notNil ifTrue:[
        changedObject == self allOfThem ifTrue:[
            whichLabel := allLabel.
            whichFontLabelHolder := self allFontLabelHolder.
        ].
        changedObject == self otherDef ifTrue:[
            whichLabel := otherLabel.
            whichFontLabelHolder := self otherFontLabelHolder.
        ].
        changedObject == self tooltipDef ifTrue:[
            whichLabel := tooltipLabel.
            whichFontLabelHolder := self tooltipFontLabelHolder.
        ].
        changedObject == self labelDef ifTrue:[
            whichLabel := labelLabel.
            whichFontLabelHolder := self labelsFontLabelHolder.
        ].
        changedObject == self buttonDef ifTrue:[
            whichLabel := buttonsLabel.
            whichFontLabelHolder := self buttonsFontLabelHolder.
        ].
        changedObject == self listDef ifTrue:[
            whichLabel := listsLabel.
            whichFontLabelHolder := self listsFontLabelHolder.
        ].
        changedObject == self menuDef ifTrue:[
            whichLabel := menuLabel.
            whichFontLabelHolder := self menusFontLabelHolder.
        ].
        changedObject == self textDef ifTrue:[
            whichLabel := textLabel.
            whichFontLabelHolder := self textFontLabelHolder.
        ].
        changedObject == self inputFieldDef ifTrue:[
            whichLabel := inputFieldLabel.
            whichFontLabelHolder := self inputFieldFontLabelHolder.
        ].
        whichLabel notNil ifTrue:[
            self updateFontOfLabel:whichLabel andFontNameHolder:whichFontLabelHolder from:changedObject.
            ^ self.
        ]
    ].
    super update:something with:aParameter from:changedObject
!

updateAllFontLabels
    self update:#value with:nil from:self allOfThem.
    self update:#value with:nil from:self otherDef.
    self update:#value with:nil from:self labelDef.
    self update:#value with:nil from:self buttonDef.
    self update:#value with:nil from:self listDef.
    self update:#value with:nil from:self menuDef.
    self update:#value with:nil from:self textDef.
    self update:#value with:nil from:self inputFieldDef.
    self update:#value with:nil from:self tooltipDef.
!

updateFontOfLabel:labelWidget andFontNameHolder:fontNameHolder from:changedObject 
    |f label|

    f := changedObject value.
    labelWidget font:f.
    label := f isNil ifTrue:[
                ''
            ] ifFalse:[
                f userFriendlyName
            ].
    fontNameHolder value:label.
    self updateModifiedChannel
! !

!FontSettingsApplication methodsFor:'help'!

helpFilename
    ^ 'Launcher/fontSettings.html'
! !

!FontSettingsApplication methodsFor:'initialization & release'!

postBuildAllFontLabel:aWidget

    allLabel := aWidget.
!

postBuildButtonsFontLabel:aWidget

    buttonsLabel := aWidget.
!

postBuildHelpLabel:aWidget
    aWidget level:0.
    aWidget scrolledView backgroundColor:self window viewBackground.
    aWidget font:(Label defaultFont).
!

postBuildInputFieldFontLabel:aWidget

    inputFieldLabel := aWidget.
!

postBuildLabelsFontLabel:aWidget

    labelLabel := aWidget.
!

postBuildListsFontLabel:aWidget

    listsLabel := aWidget.
!

postBuildMenuesFontLabel:aWidget

    menuLabel := aWidget.
!

postBuildOtherFontLabel:aWidget

    otherLabel := aWidget.
!

postBuildTextFontLabel:aWidget

    textLabel := aWidget.
!

postBuildTooltipFontLabel:aWidget

    tooltipLabel := aWidget.
!

postBuildWith:aBuilder 
"/    self readSettings.
    self updateAllFontLabels.
    super postBuildWith:aBuilder
! !

!FontSettingsApplication methodsFor:'queries'!

hasUnsavedChanges
    (currentUserPrefs fontPreferences ? self defaultFontSpecDictionary) ~= self fontSpecDictionary ifTrue:[^ true].
    (self hasChangedAspectIn: #(useXftFontsOnly) asComparedTo:currentUserPrefs) ifTrue:[^ true].

    ^ false

    "Modified: / 20-04-2016 / 20:14:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasXftFonts
    ^ self graphicsDevice supportsXftFonts
! !

!FontSettingsApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

