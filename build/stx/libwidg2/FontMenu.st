"
 COPYRIGHT (c) 1995 by eXept Software AG
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

MenuPanel subclass:#FontMenu
	instanceVariableNames:'fontAspects enabledChannel labelsAreEmphasized
		fontIsSymbolicHolder fontSymbol allowSymbolicFontsHolder
		applicationClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-UIPainter'
!

!FontMenu class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by eXept Software AG
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
    FontMenu used by UIPainter

    [author:]
        Claus Atzkern

    [see also:]
        UIPainter
        FontMenuSpec
"


!

examples
"
    simple example
                                                                                [exBegin]                                      
    |top menu model|

    model := #labelFont asValue.

    top := StandardSystemView new.
    top extent:250@200.
    menu  := FontMenu origin:0.0@0.4 extent:1.0@30 in:top.
    menu allowSymbolicFonts:true.
    menu fontIsSymbolic:true.
    menu model:model.
    top open.
    top waitUntilVisible.

    [ |new old|

      old := model value.
      [ top shown] whileTrue:[
        new := model value.
        new ~= old ifTrue:[
            old := new.
            old notNil ifTrue:[ Transcript showCR:(old userFriendlyName) ]
                      ifFalse:[ Transcript showCR:'---------' ]
        ].
        Delay waitForSeconds:0.2.
      ]

    ] forkAt:8.
                                                                                [exEnd]
"
! !

!FontMenu class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FontMenu    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#openFontChooser
''

)
! !

!FontMenu class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FontMenu andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FontMenu menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: useDefaultFontToggle
            label: 'enabled'
            itemValue: updateModel
            indication: enabledChannel
            labelImage: (ResourceRetriever SystemBrowser emptyIcon)
          )
         (MenuItem
            activeHelpKey: toggleSymbolicFont
            label: 'Symbolic'
            isVisible: allowSymbolicFontsAndEnabledHolder
            indication: fontIsSymbolicHolder
          )
         (MenuItem
            label: '-'
            isVisible: allowSymbolicFontsAndEnabledHolder
          )
         (MenuItem
            enabled: enabledChannel
            label: 'Symbolic Name'
            nameKey: fontSymbol
            isButton: true
            isVisible: allowSymbolicFontsAndFontIsSymbolicHolder
            submenuChannel: symbolicFontsMenu
          )
         (MenuItem
            activeHelpKey: openFontChooser
            enabled: enabledChannel
            label: 'Choose...'
            itemValue: openFontChooser
            isButton: true
            isVisible: enabledAndFontIsNotSymbolicHolder
            labelImage: (ResourceRetriever XPToolbarIconLibrary fontIcon)
          )
         (MenuItem
            activeHelpKey: concreteFontsFamily
            enabled: enabledChannel
            label: 'Family'
            nameKey: fontFamily
            isButton: true
            isVisible: fontIsNotSymbolicHolder
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'helvetica'
                  itemValue: fontFamily:
                  argument: helvetica
                )
               (MenuItem
                  label: 'courier'
                  itemValue: fontFamily:
                  argument: courier
                )
               (MenuItem
                  label: 'times'
                  itemValue: fontFamily:
                  argument: times
                )
               (MenuItem
                  label: 'clean'
                  itemValue: fontFamily:
                  argument: clean
                )
               (MenuItem
                  label: 'fixed'
                  itemValue: fontFamily:
                  argument: fixed
                )
               (MenuItem
                  label: 'lucida'
                  itemValue: fontFamily:
                  argument: lucida
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Other...'
                  itemValue: launchFontFamilyDialog
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            activeHelpKey: concreteFontsFace
            enabled: enabledChannel
            label: 'Face'
            nameKey: fontFace
            isButton: true
            isVisible: fontIsNotSymbolicHolder
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'bold'
                  itemValue: fontFace:
                  argument: bold
                )
               (MenuItem
                  label: 'medium'
                  itemValue: fontFace:
                  argument: medium
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Other...'
                  itemValue: launchFontFaceDialog
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            activeHelpKey: concreteFontsStyle
            enabled: enabledChannel
            label: 'Style'
            nameKey: fontStyle
            isButton: true
            isVisible: fontIsNotSymbolicHolder
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'roman'
                  itemValue: fontStyle:
                  argument: roman
                )
               (MenuItem
                  label: 'italic'
                  itemValue: fontStyle:
                  argument: italic
                )
               (MenuItem
                  label: 'oblique'
                  itemValue: fontStyle:
                  argument: oblique
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Other...'
                  itemValue: launchFontStyleDialog
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            activeHelpKey: concreteFontsSize
            enabled: enabledChannel
            label: 'Size'
            nameKey: fontSize
            isButton: true
            isVisible: fontIsNotSymbolicHolder
            submenu: 
           (Menu
              (
               (MenuItem
                  label: '6'
                  itemValue: fontSize:
                  argument: 6
                )
               (MenuItem
                  label: '8'
                  itemValue: fontSize:
                  argument: 8
                )
               (MenuItem
                  label: '10'
                  itemValue: fontSize:
                  argument: 10
                )
               (MenuItem
                  label: '12'
                  itemValue: fontSize:
                  argument: 12
                )
               (MenuItem
                  label: '14'
                  itemValue: fontSize:
                  argument: 14
                )
               (MenuItem
                  label: '16'
                  itemValue: fontSize:
                  argument: 16
                )
               (MenuItem
                  label: '18'
                  itemValue: fontSize:
                  argument: 18
                )
               (MenuItem
                  label: '24'
                  itemValue: fontSize:
                  argument: 24
                )
               (MenuItem
                  label: '32'
                  itemValue: fontSize:
                  argument: 32
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Other...'
                  itemValue: launchFontSizeDialog
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: enabledChannel
            label: 'Encoding'
            nameKey: fontEncoding
            isButton: true
            isVisible: fontIsNotSymbolicHolder
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'latin-1'
                  itemValue: fontEncoding:
                  argument: #'iso8859-1'
                )
               (MenuItem
                  label: 'unicode'
                  itemValue: fontEncoding:
                  argument: #'iso10646-1'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Other...'
                  itemValue: launchFontEncodingDialog
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

!FontMenu methodsFor:'accessing'!

allowSymbolicFonts
    ^ self allowSymbolicFontsHolder value
!

allowSymbolicFonts:aBoolean
    self allowSymbolicFontsHolder value:aBoolean.
!

fontDescription
    "get the current font description"

    |fontSize|

    enabledChannel value ifFalse:[^ nil].

    self fontIsSymbolic ifTrue:[
        ^ fontSymbol
    ].

    fontSize := fontAspects at:#fontSize.
    (fontSize isFloat and:[fontSize asInteger = fontSize]) ifTrue:[
        fontSize := fontSize asInteger
    ].

    ^ FontDescription 
        family:(fontAspects at:#fontFamily)
        face:(fontAspects at:#fontFace)
        style:(fontAspects at:#fontStyle)
        size:fontSize
        sizeUnit:#pt "(fontAspects at:#sizeUnit)"
        encoding:(fontAspects at:#fontEncoding)
!

fontDescription:aFontDesc
    "set the font description"

    |saveModel symbolic|

    aFontDesc isNil ifTrue:[
        enabledChannel value:false.
        ^ self
    ].

    self disabledRedrawDo:[
        saveModel := model.     "/ do not inform the model
        model     := nil.

        enabledChannel value:true.
        symbolic := (aFontDesc isSymbol or:[aFontDesc isString]).

        self fontIsSymbolicHolder value:symbolic.
        symbolic ifTrue:[
            self fontSymbol:aFontDesc asSymbol.
        ] ifFalse:[
            self fontFamily:(aFontDesc family).
            self fontFace:(aFontDesc face).
            self fontStyle:(aFontDesc style).
            self fontSize:(aFontDesc size).
            self fontEncoding:(aFontDesc encoding ? #'iso10646-1').
        ].
        model := saveModel.
    ]
!

fontIsSymbolic
    ^ self fontIsSymbolicHolder value
!

fontIsSymbolic:aBoolean
    self fontIsSymbolicHolder value:aBoolean.
!

fontSymbol
    ^ fontSymbol
!

fontSymbol:aSymbolOrMenuItem
    aSymbolOrMenuItem isSymbol ifTrue:[
        fontSymbol := aSymbolOrMenuItem.
    ] ifFalse:[
        fontSymbol := aSymbolOrMenuItem label asSymbol.
    ].

    (self itemAt:#fontSymbol) label:fontSymbol.
    self updateModel.
!

labelsAreEmphasized
    ^ labelsAreEmphasized
!

labelsAreEmphasized:aBoolean
    labelsAreEmphasized := aBoolean.
! !

!FontMenu methodsFor:'accessing-channels'!

allowSymbolicFontsAndEnabledHolder
    ^ self allowSymbolicFontsHolder & self enabledChannel
!

allowSymbolicFontsAndFontIsSymbolicHolder
    ^ self fontIsSymbolicHolder & self allowSymbolicFontsHolder
!

allowSymbolicFontsHolder
    allowSymbolicFontsHolder isNil ifTrue:[
        allowSymbolicFontsHolder := BooleanValueHolder with:false
    ].
    ^ allowSymbolicFontsHolder
!

enabledAndFontIsNotSymbolicHolder
    ^ self fontIsNotSymbolicHolder & self enabledChannel
!

enabledChannel
    ^ enabledChannel
!

enabledChannel:aValueHolder
    enabledChannel := aValueHolder.
!

fontIsNotSymbolicHolder
    ^ self fontIsSymbolicHolder logicalNot
!

fontIsSymbolicHolder
    fontIsSymbolicHolder isNil ifTrue:[
        fontIsSymbolicHolder := BooleanValueHolder with:false
    ].
    ^ fontIsSymbolicHolder
!

model:aValueHolder
    "set my model"

    super model:aValueHolder.
    model notNil ifTrue:[
        self updateFromModel
    ].

    "Modified: / 29-11-2011 / 11:27:31 / cg"
! !

!FontMenu methodsFor:'accessing-dimensions'!

preferredExtent
    "workaround: will change the preferredExtent !!!!
        same in ColorMenu"

    |extent|

    preferredExtent notNil ifTrue:[
        ^ super preferredExtent.
    ].
    extent := super preferredExtent.
    preferredExtent := nil.

    ^ extent
! !

!FontMenu methodsFor:'aspects'!

fontAspectAt:key put:value
    (value isNil or:[value = (fontAspects at:key)]) ifTrue:[
        ^ self
    ].
    fontAspects at:key put:value.
    (self itemAt:key) label:value.

    self updateModel.
!

fontEncoding
    ^ fontAspects at:#fontEncoding
!

fontEncoding:anEncodingSymbol
    ^ self fontAspectAt:#fontEncoding put:anEncodingSymbol
!

fontFace
    ^ fontAspects at:#fontFace
!

fontFace:aFace
    ^ self fontAspectAt:#fontFace put:aFace
!

fontFamily
    ^ fontAspects at:#fontFamily
!

fontFamily:aFamily
    ^ self fontAspectAt:#fontFamily put:aFamily
!

fontSize
    ^ fontAspects at:#fontSize
!

fontSize:aSize
    ^ self fontAspectAt:#fontSize put:aSize
!

fontStyle
    ^ fontAspects at:#fontStyle
!

fontStyle:aStyle
    ^ self fontAspectAt:#fontStyle put:aStyle
! !

!FontMenu methodsFor:'change & update'!

updateFromModel
    self fontDescription:(model value)
!

updateModel
    model notNil ifTrue:[
        model value:(self fontDescription) withoutNotifying:self
    ].

    "Modified: / 29-11-2011 / 11:27:35 / cg"
! !

!FontMenu methodsFor:'help'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ColorEditDialog    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#useDefaultFontToggle
'Turn on, to specify the font here. Turn off to use the default'

#toggleSymbolicFont
'Turn on, to specify a symbolic font. Turn off to specify a concrete font'

#openFontChooser
'Open a font dialog'

)
! !

!FontMenu methodsFor:'initialization'!

destroy
    "release dependencies"

    self model:nil.
    enabledChannel removeDependent:self.
    super destroy.
!

initialize
    "setup menu"

    super initialize.

    fontAspects    := IdentityDictionary new.
    enabledChannel := false asValue.
    labelsAreEmphasized := false.
    self allowSymbolicFonts:false.

    #(fontFamily fontFace fontStyle fontSize fontEncoding) do:[:k|
        fontAspects at:k put:(nil asValue)
    ].
    self verticalLayout:false.
    self menu:(self class menu).
    enabledChannel := false asValue.
    receiver := self.

    self fontDescription:self font.
    applicationClass := UIPainter applicationClassQuery query ? ApplicationModel.
! !

!FontMenu methodsFor:'menu spec'!

symbolicFontsMenu
    |symbolicFontSelectors bigFontSelectors smallFontSelectors normalFontSelectors
     selectors menu menuLabels menuItems|

    symbolicFontSelectors := (applicationClass methodsWithAnyResource:#(fontSpec)) 
                                collect:[:each| each selector].

    bigFontSelectors := (symbolicFontSelectors select:[:nm | nm endsWith:'Big']) sort.                            
    smallFontSelectors := (symbolicFontSelectors select:[:nm | nm endsWith:'Small']) sort.                            
    normalFontSelectors := (symbolicFontSelectors reject:[:nm | nm endsWithAnyOf:#('Small' 'Big')]) sort. 
    symbolicFontSelectors :=
        normalFontSelectors , #(nil) , smallFontSelectors , #(nil) , bigFontSelectors.    

    selectors := (Array new:normalFontSelectors size withAll:#fontSymbol:)
                 , #( nil )
                 , (Array new:smallFontSelectors size withAll:#fontSymbol:)
                 , #( nil )
                 , (Array new:bigFontSelectors size withAll:#fontSymbol:)
                 , #(nil launchFontSymbolDialog).
                 
    menuLabels := normalFontSelectors 
                  , #('-') 
                  , smallFontSelectors 
                  , #('-') 
                  , bigFontSelectors 
                  , #('-' 'Other...').

    menu := Menu labelArray:menuLabels values:selectors.
    menuItems := menu items.
    symbolicFontSelectors keysAndValuesDo:[:eachIndex :eachFontSelector|
        |font|
        eachFontSelector notNil ifTrue:[ font := applicationClass resolveFont:eachFontSelector ].
        font notNil ifTrue:[
            (menuItems at:eachIndex) font:font.
        ].
    ].

    ^ menu
! !

!FontMenu methodsFor:'user actions'!

launchFontEncodingDialog
    "launch dialog to get a font encoding"

    |string|

    string := EnterBox 
                request:(resources string:'Encoding:')
                initialAnswer:(self fontEncoding).

    string notEmptyOrNil ifTrue:[
        self fontEncoding:string asSymbol
    ].
!

launchFontFaceDialog
    "launch dialog to get a font face"

    |string|

    string := EnterBox 
                request:(resources string:'Face:')
                initialAnswer:(self fontFace).

    string notEmptyOrNil ifTrue:[
        self fontFace:string
    ].
!

launchFontFamilyDialog
    "launch dialog to get a font family"

    |string|

    string := EnterBox 
                request:(resources string:'Family:')
                initialAnswer:(self fontFamily).

    string notEmptyOrNil ifTrue:[
        self fontFamily:string
    ].
!

launchFontSizeDialog
    "launch dialog to get a font size"

    |size string|

    string := EnterBox 
                request:(resources string:'Size:')
                initialAnswer:(self fontSize printString).

    string notEmptyOrNil ifTrue:[
        size := SmallInteger readFrom:string onError:nil.

        (size notNil and:[size >= 1 and:[size <= 128]]) ifTrue:[
            self fontSize:size
        ]
    ].
!

launchFontStyleDialog
    "launch dialog to get a font style"

    |string|

    string := EnterBox 
                request:(resources string:'Style:')
                initialAnswer:(self fontStyle).

    string notEmptyOrNil ifTrue:[
        self fontFace:string
    ].
!

launchFontSymbolDialog
    "launch dialog to get a font symbol"

    |string|

    string := EnterBox 
                request:(resources string:'Symbol (message to app, which returns the font):')
                initialAnswer:(self fontSymbol).

    string notEmptyOrNil ifTrue:[
        self fontSymbol:string asSymbol
    ].
!

openFontChooser
    |choosenFont|

    choosenFont := FontPanel fontFromUserInitial:(self fontDescription).
    choosenFont notNil ifTrue: [
        self fontDescription:choosenFont.
        self updateModel.
    ]
! !

!FontMenu class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

