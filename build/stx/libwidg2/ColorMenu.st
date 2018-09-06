"{ Encoding: utf8 }"

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

MenuPanel subclass:#ColorMenu
	instanceVariableNames:'overwriteDefaultToggleChannel enabledChannel labelsAreColored
		color colorName allowSymbolicColors showDefaultToggle
		acceptAction useDefaultColorToggleVisibleHolder allowNilColor
		hasNilColorHolder'
	classVariableNames:'ColorMenuSpec RecentlyUsedColors'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

!ColorMenu class methodsFor:'documentation'!

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
    A simple ColorMenu used by the UIPainter

    [see also:]
        UIPainter
        ColorMenuSpec

    [author:]
        Claus Atzkern
"
!

examples
"
  very simple example
                                                                                [exBegin]                                      
    |tool top channel|

    top := StandardSystemView new.
    top extent:250@30.

    channel := (Color red) asValue.
    tool := self origin:0.0@0.0 corner:1.0@1.0 in:top.
    tool model:channel.

    top open.
                                                                                [exEnd]
"
! !

!ColorMenu class methodsFor:'instance creation'!

colorMenu:labelsAreColored value:aValue
    "returns a color menu"

    |menu|

    menu := Menu new.

    self colorMenu itemsDo:[:el|
        menu addItem:(self resolveMenuItem:el value:aValue labelsAreColored:labelsAreColored).
    ].
    ^ menu

    "
     (ColorMenu colorMenu:true  value:nil) startUp
     (ColorMenu colorMenu:false value:#aSelector:) startUp
    "

    "Modified: / 23-01-2011 / 14:58:32 / cg"
! !

!ColorMenu class methodsFor:'adding & removing user defined items'!

addUserDefinedColors:aColors labels:labelsOrNil title:aTitle
    "add user colors to ALL colormenus"

    "cg: I think this is a bad hack, as it is too global."

    |size submenu item label fgColor bgColor labels defLabel|

    submenu := self userDefinedSubmenu.
    size    := aColors size.

    size == 0 ifTrue:[  "/ separator
        submenu addSeparator.
        ^ self
    ].

    labels   := labelsOrNil ? #().
    bgColor  := aColors first.
    defLabel := '        '.

    fgColor := bgColor contrastingBlackOrWhite.

    aTitle isEmptyOrNil ifTrue:[ label := labels at:1 ifAbsent:defLabel ]
                       ifFalse:[ label := aTitle ].

    label := Text string:(' ', label, ' ') foregroundColor:fgColor backgroundColor:bgColor.
    item  := MenuItem label:label.
    submenu addItem:item.

    size == 1 ifTrue:[
        item argument:bgColor.
    ] ifFalse:[
        item submenu:(submenu := Menu new).

        aColors keysAndValuesDo:[:idx :aBgColor|
            fgColor := aBgColor contrastingBlackOrWhite.

            label := labels at:idx ifAbsent:defLabel.
            label := Text string:(' ', label, ' ') foregroundColor:fgColor backgroundColor:aBgColor.
            item  := MenuItem label:label.
            item argument:aBgColor.
            
            submenu addItem:item.
        ].
    ].

"
    ColorMenu  removeAllUserDefinedColors.

    #(
        #(  Black       16r000000 )
        #(  Red         16rff0000 )
        nil
        #(  Rust        16rff6600 16rff8533 16rffa366 16rffc299 16rffe0cc )
        #(  Tangerine   16rff9933 16rffad5c 16rffc285 16rffd6ad 16rffebd6 )
        #(  Sunflower   16rffcc00 16rfed633 16rfee066 16rffeb99 16rfff5cc )  
        #(  Mango       16rffcc99 16rffd6ad 16rffe0c2 16rffebd6 16rfff5eb )
        #(  Buttercup   16rffff66 16rffff85 16rffffa3 16rffffc2 16rffffe0 )
        #(  Lemon       16rffffcc 16rffffd6 16rffffe0 16rffffeb 16rfffff5 )

    ) do:[:aDef| |colors title labels percentage|
        aDef isEmptyOrNil ifTrue:[
            colors := labels := title := nil.
        ] ifFalse:[
            title      := aDef first.
            colors     := OrderedCollection new.
            labels     := OrderedCollection new.
            percentage := 100.

            aDef from:2 do:[:rgb|
                colors add:(Color rgbValue:rgb).
                labels add:('%1    %2 %%' bindWith:title with:percentage).
                percentage := percentage - 20.
            ].
        ].
        ColorMenu addUserDefinedColors:colors labels:labels title:title.
    ].
"
!

removeAllUserDefinedColors
    "flush user defined colors"

    ColorMenuSpec := nil.
!

userDefinedSubmenu
    <resource: #programMenu >

    "answer the menu entry under which the userdefined color entries are placed"

    |menu submenu item icon|

    menu := self colorMenu.
    item := menu detectItem:[:el| (el nameKey == #userDefined and:[el submenu notNil]) ]
                     ifNone:nil.

    item isNil ifTrue:[
        icon := ToolbarIconLibrary colorHistory16x16Icon.
        item := MenuItem label:icon.
        item nameKey:#userDefined.
        item activeHelpKey:#userDefinedColors.
        menu addItem:item beforeIndex:1.
    ].

    (submenu := item submenu) isNil ifTrue:[
        submenu := Menu new.
        item submenu:submenu.
    ].
    ^ submenu
! !

!ColorMenu class methodsFor:'history'!

rememberRecentlyUsedColor:aColor
    aColor notNil ifTrue:[
        RecentlyUsedColors isNil ifTrue:[
            RecentlyUsedColors := OrderedCollection new.
        ].
        RecentlyUsedColors remove:aColor ifAbsent:[].
        RecentlyUsedColors addFirst:aColor.
        RecentlyUsedColors size > 20 ifTrue:[
            RecentlyUsedColors removeLast
        ].
    ].
! !

!ColorMenu class methodsFor:'menu specs'!

colorMenuSpec
    "color definitions used to build a color menu
    "
"because it is cached, you have to:
    ColorMenuSpec := nil.
when changing
"
  ^ #(
        #(  gray
            gray:
            #(  white
                veryLightGray
                lightGray
                gray 
                darkGray 
                veryDarkGray 
                black 
             )
        )
"/ nil                         "/ separator
        #(  red
            red:
            #( veryLight lightened 100 87 67 50 33 25)
         )
        #(  green
            green:
            #( veryLight lightened 100 87 67 50 33 25)
         )
        #(  blue
            blue:
            #( veryLight lightened 100 87 67 50 33 25)
         )
"/ nil                         "/ separator
        #(  cyan
            cyan:
            #( veryLight lightened 100 87 67 50 33 25)
        )
        #(  magenta
            magenta:
            #( veryLight lightened 100 87 67 50 33 25)
        )
        #(  yellow
            yellow:
            #( veryLight lightened 100 87 67 50 33 25)
        )
        #(  brown
            brown:
            #( veryLight lightened brown darkened veryDark)
        )
    )

    "Modified: / 23-01-2011 / 16:33:33 / cg"
! !

!ColorMenu class methodsFor:'private'!

colorMenu
    <resource: #programMenu >

    |menu menuItem subItem baseColor color label getColSel submenu colorId|

    "
     ColorMenuSpec := nil
    "

    ColorMenuSpec notNil ifTrue:[ ^ ColorMenuSpec ].

    menu := Menu new.
    self colorMenuSpec do:[:aSlice|
        menu addItem:(menuItem := MenuItem new).

        aSlice notNil ifTrue:[
            colorId   := aSlice at:1.
            getColSel := aSlice at:2.
            baseColor := Color perform:colorId.

            menuItem label:(Text string:' ' emphasis:(#backgroundColor->baseColor)).
            menuItem submenu:(submenu := Menu new).
            menuItem isButton:true.
            menuItem activeHelpKey:('shadesOf',colorId asUppercaseFirst) asSymbol.

            aSlice last do:[:el|         
                color := label := nil.

                el isSymbol ifTrue:[
                    el == #veryLight ifTrue:[ 
                        color := baseColor lightened lightened
                    ] ifFalse:[ el == #lightened ifTrue:[ 
                        color := baseColor lightened 
                    ] ifFalse:[ el == #darkened ifTrue:[ 
                        color := baseColor darkened 
                    ] ifFalse:[ el == #veryDark ifTrue:[ 
                        color := baseColor darkened darkened 
                    ] ifFalse:[ 
                        color := Color perform:el 
                    ]]]].
                    colorId == #gray ifTrue:[ label := el ].
                ] ifFalse:[
                    el isNumber ifTrue:[
                        color := Color perform:getColSel with:el.
                    ].
                ].
                color notNil ifTrue:[
                    label isNil ifTrue:[
                        label := getColSel, ' ', el printString.
                    ].
                    subItem := MenuItem label:' ',label,' '.
                    subItem argument:color.
                    submenu addItem:subItem.
                ].
            ]
        ].
    ].
    ColorMenuSpec := menu.
    ^ menu

    "Modified: / 23-01-2011 / 16:34:45 / cg"
!

resolveMenuItem:aMenuItem value:aValue labelsAreColored:labelsAreColored
    <resource: #programMenu >

    |menuItem label color fgColor submenu|

    label    := aMenuItem rawLabel ? ''.
    menuItem := MenuItem label:label.
    menuItem isButton:(aMenuItem isButton).
    menuItem activeHelpKey:(aMenuItem activeHelpKey).

    aMenuItem hasSubmenu ifFalse:[
        color := aMenuItem argument.
        menuItem argument:color.

        (color isColor and:[label isText not]) ifTrue:[
            labelsAreColored ifTrue:[
                label := Text string:label color:color.
            ] ifFalse:[
                fgColor := color contrastingBlackOrWhite.
                label := Text string:label foregroundColor:fgColor backgroundColor:color.
            ].
            menuItem label:label itemValue:aValue.
        ].
        ^ menuItem
    ].

    submenu := Menu new.
    aMenuItem submenu itemsDo:[:el|
        submenu addItem:(self resolveMenuItem:el value:aValue labelsAreColored:labelsAreColored).
    ].
    menuItem submenu:submenu.
    ^ menuItem

    "Created: / 23-01-2011 / 14:59:19 / cg"
! !

!ColorMenu methodsFor:'accepting'!

accept
    "must be ignored, as sent by dialogBox's doAccept
     and is defined in superclass to call accept: with nil argument"

    "Created: / 26-07-2013 / 20:43:26 / cg"
!

accept:anItem
    "accept the current selected item (called from my pulldown menus)"

    |holder colorAccepted|

    super accept:anItem.

    (anItem notNil and:[((anItem nameKey ? '') startsWith:'pseudo') not]) ifTrue:[
        holder := self colorHolder.
        holder == anItem ifTrue:[
            self overwriteDefaultToggleChannel value ifTrue:[
                colorAccepted := self color.
            ] ifFalse:[
                holder label:'   '.
                model value:nil withoutNotifying:self
            ].
        ] ifFalse:[  
            anItem value == #hasNilColorHolder: ifTrue:[
                self overwriteDefaultToggleChannel value ifFalse:[
                    model value:nil withoutNotifying:self
                ].
            ] ifFalse:[
                colorAccepted := anItem argument.
                holder label:(Text string:'   ' emphasis:(#backgroundColor->colorAccepted)).
                self chooseColor:colorAccepted.
            ].
        ].
        self class rememberRecentlyUsedColor:colorAccepted.
        acceptAction notNil ifTrue:[
            acceptAction value:colorAccepted
        ].
    ]

    "Modified: / 17-08-2011 / 08:57:12 / cg"
    "Modified (comment): / 26-07-2013 / 20:43:19 / cg"
!

chooseColor:aColor
    "accept the current selected item"

    (model notNil 
    and:[ model isSymbol not]) ifTrue:[
        model value:aColor.
    ].
    aColor isNil ifTrue:[
        hasNilColorHolder value:true
    ] ifFalse:[
        color := aColor.
    ].
! !

!ColorMenu methodsFor:'accessing'!

acceptAction:something
    acceptAction := something.
!

allowNilColor
    ^ allowNilColor
!

allowNilColor:aBoolean
    allowNilColor ~~ aBoolean ifTrue:[
        allowNilColor := aBoolean.
        allowNilColor ifTrue:[      
            self overwriteDefaultToggleChannel value:true.
            self hasNilColorHolder value:(color notNil).
        ].
        self setupMenu.
    ].

    "Created: / 24-01-2011 / 10:02:25 / cg"
    "Modified: / 24-01-2011 / 20:06:28 / cg"
!

allowSymbolicColors
    ^ allowSymbolicColors
!

allowSymbolicColors:aBoolean
    allowSymbolicColors := aBoolean.
!

color
    "get current color"

    self overwriteDefaultToggleChannel value ifFalse:[^ nil].
    ^ color

    "Modified: / 24-01-2011 / 20:14:27 / cg"
!

color:aColor
    "set current color"

    |label newColor|

"/    aColor isNil ifTrue:[
"/        color notNil ifTrue:[
"/            self halt
"/        ]
"/    ].
    
    self hasNilColorHolder setValue:aColor isNil.

    (aColor isColor or:[aColor isSymbol]) ifFalse:[
        self overwriteDefaultToggleChannel value:false.
        self colorHolder label:'   '.
        (aColor isNil and:[allowNilColor]) ifTrue:[
            self chooseColor:aColor
        ]
    ] ifTrue:[
        newColor := aColor.
        aColor isSymbol ifTrue:[
            allowSymbolicColors ifTrue:[
                label  := aColor.
            ] ifFalse:[
                "our caller does not handle symbolic colors (UIPainter does) - convert now.
                 Be careful - for security reasons - do not perform arbitrary symbols here 
                (could be #halt, #error)!!"

                newColor := Color name:aColor ifIllegal:[color "keep old"].
            ].
        ].
        newColor isSymbol ifFalse:[
            "show the selected color in the label"
            label  := Text string: '   ' emphasis:(#backgroundColor->newColor).
        ].
        color := newColor.
        self disabledRedrawDo:[
            self overwriteDefaultToggleChannel value:true.
            self colorHolder label:label.
            self chooseColor:aColor
        ]
    ]

    "Modified: / 24-01-2011 / 20:09:39 / cg"
!

colorHolder
    "returns the item which keeps the selected color in its label"

    ^ self itemAt:#selection
!

contents
    ^ self color
!

enableChannel:aValueHolder
    super enableChannel:aValueHolder.
    self updateEnableChannel

    "Created: / 23-01-2011 / 16:08:52 / cg"
!

enabledChannel
    ^ self overwriteDefaultToggleChannel
"/    ^ enabledChannel

    "Modified: / 23-01-2011 / 16:24:12 / cg"
!

hasNilColorHolder
    hasNilColorHolder isNil ifTrue:[
        hasNilColorHolder := false asValue.
        hasNilColorHolder onChangeSend:#hasNilColorHolderChanged to:self.
    ].
    ^ hasNilColorHolder

    "Created: / 24-01-2011 / 19:22:49 / cg"
!

labelsAreColored
    "controls if labels or their backgrounds will be colored"

    ^ labelsAreColored
!

labelsAreColored: aBoolean
    "sets whether labels or their backgrounds will be colored"

    |bool|

    bool := aBoolean ? false.

    labelsAreColored ~~ bool ifTrue:[
        labelsAreColored := bool.
        self setupMenu
    ].
!

overwriteDefaultToggleChannel
    overwriteDefaultToggleChannel isNil ifTrue:[
        overwriteDefaultToggleChannel := false asValue.
    ].
    ^ overwriteDefaultToggleChannel

    "Modified: / 23-01-2011 / 16:24:00 / cg"
!

useDefaultColorToggleVisibleHolder
    useDefaultColorToggleVisibleHolder isNil ifTrue:[
        useDefaultColorToggleVisibleHolder := true asValue
    ].
    ^ useDefaultColorToggleVisibleHolder

    "Created: / 18-12-2010 / 13:03:48 / cg"
! !

!ColorMenu methodsFor:'accessing-channels'!

model:aValueHolder
    "set my color channel"

    super model:aValueHolder.
    model notNil ifTrue:[
        self updateFromModel
    ]
! !

!ColorMenu methodsFor:'accessing-dimensions'!

preferredExtent
    "workaround: will change the preferredExtent !!!!
        same in FontMenu"

    |extent|

    preferredExtent notNil ifTrue:[
        ^ super preferredExtent.
    ].
    extent := super preferredExtent.
    preferredExtent := nil.

    ^ extent
! !

!ColorMenu methodsFor:'change & update'!

hasNilColorHolderChanged
    |hasNoColor|

    hasNoColor := self hasNilColorHolder value.    
    self overwriteDefaultToggleChannel value:(hasNoColor not).
    allowNilColor ifTrue:[
        hasNoColor ifTrue:[
            model value:nil withoutNotifying:self
        ] ifFalse:[
            color isNil ifTrue:[
                color := self whiteColor.
                self chooseColor:color.
            ].    
            model value:color withoutNotifying:self
        ].
    ].

    "Modified: / 23-03-2011 / 20:02:18 / cg"
!

updateFromModel
    self color:(model value)
! !

!ColorMenu methodsFor:'help'!

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

#useDefaultColorToggle
'Turn on, to specify the color here. Turn off to use the default'

#toggleSymbolicColor
'Turn on, to specify a symbolic color. Turn off to specify a concrete color'

#recentlyUsedColors
'Recently used colors'

#openColorEditor
'Open a color editor'

#pickColorFromScreen
'Pick a color from the screen'

)
! !

!ColorMenu methodsFor:'initialization'!

colorHistorySubmenu
    <resource: #programMenu >

    |menu|

    RecentlyUsedColors isEmptyOrNil ifTrue:[^ nil].

    menu := Menu new.

    RecentlyUsedColors do:[:eachRecentlyUsedColor |
        |label fgColor item|

        eachRecentlyUsedColor isSymbol ifTrue:[
            label := eachRecentlyUsedColor  .
        ] ifFalse:[
            fgColor := eachRecentlyUsedColor contrastingBlackOrWhite.

            label := eachRecentlyUsedColor htmlPrintString.
            label := Text string:(' ', label, ' ') foregroundColor:fgColor backgroundColor:eachRecentlyUsedColor.
        ].

        item := MenuItem label:label.
        item argument:eachRecentlyUsedColor.

        menu addItem:item.
    ].

    ^ menu.
!

destroy
    "release color channel dependency"

    self model:nil.
    super destroy

!

initialize
    super initialize.
    labelsAreColored    := false.
    verticalLayout      := false.
    allowSymbolicColors := false.
    allowNilColor       := true.

    self fitFirstPanel:false.
    "/ enabledChannel := ValueHolder with:false.
    self setupMenu.

    "Modified: / 17-07-2011 / 11:02:07 / cg"
!

setupMenu
    |menu toggleItem|

    menu := self class colorMenu:labelsAreColored value:nil.

    menu 
        addItem:(
            (MenuItem 
                    label:nil
                    itemValue:[ self openColorEditDialog ] 
            ) 
                labelImage:(ToolbarIconLibrary palette16x16Icon);
                nameKey:#pseudoDef;
                activeHelpKey:#openColorEditor;
                isButton: true) 
        beforeIndex:1.

    menu 
        addItem:(
            (MenuItem 
                label:nil
                itemValue:[ self pickColorFromScreen ] 
            ) 
                labelImage:(ToolbarIconLibrary pipette16x16Icon);
                nameKey:#pseudoPick;
                activeHelpKey:#pickColorFromScreen;
                isButton: true) 
        beforeIndex:1.

    menu 
        addItem:(
            (MenuItem 
                label:nil
                submenuChannel:[ self colorHistorySubmenu ] 
            )
                labelImage:(ToolbarIconLibrary colorHistory16x16Icon);
                nameKey:#pseudoHistory;
                activeHelpKey:#recentlyUsedColors;
                isButton: true) 
        beforeIndex:1.

    "/ menu addItem:(MenuItem label:'') beforeIndex:1.
"/    (showDefaultToggle ? true) ifTrue:[
        toggleItem := MenuItem 
                        label:(Text string:' ' emphasis:(#backgroundColor->DefaultViewBackgroundColor))
                        itemValue:#selection.
        toggleItem isButton: false.
        toggleItem activeHelpKey:#useDefaultColorToggle.    
        toggleItem isVisible:(self useDefaultColorToggleVisibleHolder).    
        menu addItem:toggleItem beforeIndex:1.
"/    ].

    allowNilColor ifTrue:[
        toggleItem := MenuItem 
                        label:'No Color'
                        itemValue:#'hasNilColorHolder:'.
        toggleItem isButton:false.
        toggleItem activeHelpKey:#noColor.    
        toggleItem indication:self hasNilColorHolder.
        menu addItem:toggleItem.
    ].

    self menu:menu.
    self updateEnableChannel

    "Modified: / 09-09-2012 / 13:27:15 / cg"
!

updateEnableChannel
    self do:[:anItem|
        anItem value == #selection ifTrue:[
            anItem indication:self overwriteDefaultToggleChannel.
            "/ anItem enabled:enabledChannel.
        ] ifFalse:[
            anItem value == #hasNilColorHolder: ifTrue:[
            ] ifFalse:[
                anItem enabled:self overwriteDefaultToggleChannel.
            ]
        ]
    ]

    "Created: / 23-01-2011 / 16:08:06 / cg"
    "Modified: / 24-01-2011 / 19:35:52 / cg"
! !

!ColorMenu methodsFor:'user actions'!

keepColorHolderIndicationAlwaysEnabled
    self colorHolder indication:true.
    self colorHolder isButton:true.
!

openColorEditDialog
    |defineColorDialog|

    defineColorDialog := ColorEditDialog new color: self color.
    defineColorDialog open.
    defineColorDialog accept value ifTrue: [
        self color:defineColorDialog color
    ]
!

pickColorFromScreen
    |color|

    color := Color fromUser.
    color notNil ifTrue:[
        self color:color.
    ]
! !

!ColorMenu class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

