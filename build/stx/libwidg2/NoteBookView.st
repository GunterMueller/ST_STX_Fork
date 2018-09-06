"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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

View subclass:#NoteBookView
	instanceVariableNames:'list listHolder foregroundColor backgroundColor selection enabled
		action useIndex direction numberOfLines selectConditionBlock
		accessTabMenuAction canvas canvasInset canvasHolder
		halfLightColor halfShadowColor fitLastRow tabModus
		lastComputedExtent keepCanvas activeForegroundColor
		activeBackgroundColor drawLightColor edgeStyle tabInset
		tabLabelInset disabledForegroundColor tabLevel tabTopMargin
		tabBottomMargin selectionInsetX selectionInsetY translateLabel
		buttonPrev buttonNext tabRightMargin tabLeftMargin
		showDestroyTabButton destroyTabAction activeTabMarkerColor
		activeTabMarkerFGColor tabWasActiveWhenPressed removeTabIcon
		removeTabEnteredIcon removeTabDisabledIcon
		showingEnteredRemoveTabButton lastUserSelection minimumTabWidth
		addTabAction addTabIcon addTabEnteredIcon addTabDisabledIcon
		showingEnteredAddTabButton canvasLevel
		showDestroyTabButtonOnSingleTab'
	classVariableNames:'DefaultForegroundColor DefaultBackgroundColor
		DefaultActiveForegroundColor DefaultActiveBackgroundColor
		DefaultShadowColor DefaultHalfShadowColor DefaultLightColor
		DefaultHalfLightColor DefaultEdgeStyle DisabledForegroundColor
		DefaultActiveTabMarkerColor DefaultActiveTabMarkerFgColor
		RemoveTabIcon RemoveTabEnteredIcon AddTabIcon AddTabEnteredIcon'
	poolDictionaries:''
	category:'Views-Layout'
!

Object subclass:#Tab
	instanceVariableNames:'label tabItem printableLabel disabledLabel lineNr
		unselectedLayout selectedLayout layout extent accessCharacter
		lastFocusViewId'
	classVariableNames:''
	poolDictionaries:''
	privateIn:NoteBookView
!

!NoteBookView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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
    implements the noteBook.

    [author:]
        Claus Atzkern

    [see also:]
        TabView
"
!

examples
"
  tabs at top & bottom
                                                                                [exBegin]                                      
    |top tab1 tab2|

    top := StandardSystemView extent:300@100.
    tab1 := NoteBookView origin:0.0 @ 0.0 corner:1.0 @ 0.5 in:top.
    tab1 direction:#top.
    tab1 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).

    tab2 := NoteBookView origin:0.0 @ 0.5 corner:1.0 @ 1.0 in:top.
    tab2 direction:#bottom.
    tab2 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).
    top open.
                                                                                [exEnd]


  tabs at left & right
                                                                                [exBegin]                                      
    |top tab1 tab2|

    top := StandardSystemView extent:100@300.
    tab1 := NoteBookView origin:0.0 @ 0.0 corner:0.5 @ 01.0 in:top.
    tab1 direction:#left.
    tab1 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).

    tab2 := NoteBookView origin:0.5 @ 0.0 corner:1.0 @ 1.0 in:top.
    tab2 direction:#right.
    tab2 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).
    top open.
                                                                                [exEnd]

  tabs at top & bottom, with add-tab button
                                                                                [exBegin]                                      
    |top tab1 tab2|

    top := StandardSystemView extent:300@100.
    tab1 := NoteBookView origin:0.0 @ 0.0 corner:1.0 @ 0.5 in:top.
    tab1 addTabAction:[ self halt ].
    tab1 direction:#top.
    tab1 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).

    tab2 := NoteBookView origin:0.0 @ 0.5 corner:1.0 @ 1.0 in:top.
    tab2 addTabAction:[ self halt ].
    tab2 direction:#bottom.
    tab2 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).
    top open.
                                                                                [exEnd]

  tabs at left & right, with add-tab button
                                                                                [exBegin]                                      
    |top tab1 tab2|

    top := StandardSystemView extent:100@300.
    tab1 := NoteBookView origin:0.0 @ 0.0 corner:0.5 @ 01.0 in:top.
    tab1 addTabAction:[ self halt ].
    tab1 direction:#left.
    tab1 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).

    tab2 := NoteBookView origin:0.5 @ 0.0 corner:1.0 @ 1.0 in:top.
    tab2 addTabAction:[ self halt ].
    tab2 direction:#right.
    tab2 list:#( 'Foo' 'Bagr' 'Baz' 'Bgar' 'Baqz'  ).
    top open.
                                                                                [exEnd]

"
! !

!NoteBookView class methodsFor:'defaults'!

defaultFont
    ^ MenuView defaultFont
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'noteBook.foregroundColor' #'noteBook.backgroundColor'
                       #'noteBook.activeForegroundColor' #'noteBook.activeBackgroundColor'
                       #'noteBook.lightColor' #'noteBook.halfLightColor' #'noteBook.shadowColor'
                       #'noteBook.halfShadowColor' #'noteBook.edgeStyle'
                       #'noteBook.activeTabMarkerColor'
                       #'noteBook.showRemoveTabIcon' 
                      )>

    DefaultForegroundColor := StyleSheet colorAt:#'noteBook.foregroundColor'.
    DefaultForegroundColor isNil ifTrue:[
        DefaultForegroundColor := StyleSheet colorAt:#'button.foregroundColor'.
    ].
    DefaultBackgroundColor := StyleSheet colorAt:#'noteBook.backgroundColor'.

    DefaultActiveForegroundColor := StyleSheet colorAt:#'noteBook.activeForegroundColor'.
    DefaultActiveForegroundColor isNil ifTrue:[
        DefaultActiveForegroundColor := StyleSheet colorAt:#'button.activeForegroundColor'
    ].
    DefaultActiveBackgroundColor := StyleSheet colorAt:#'noteBook.activeBackgroundColor'.

    DefaultLightColor := StyleSheet colorAt:#'noteBook.lightColor'.
    DefaultLightColor isNil ifTrue:[
        DefaultLightColor := StyleSheet colorAt:'button.lightColor'
    ].
    DefaultHalfLightColor := StyleSheet colorAt:#'noteBook.halfLightColor'.
    DefaultHalfLightColor isNil ifTrue:[
        DefaultHalfLightColor := StyleSheet colorAt:#'button.halfLightColor'
    ].    

    DefaultShadowColor := StyleSheet colorAt:#'noteBook.shadowColor'.
    DefaultShadowColor isNil ifTrue:[
        DefaultShadowColor := StyleSheet colorAt:'button.shadowColor'
    ].
    DefaultHalfShadowColor := StyleSheet colorAt:#'noteBook.halfShadowColor'.
    DefaultHalfShadowColor isNil ifTrue:[
        DefaultHalfShadowColor := StyleSheet colorAt:#'button.halfShadowColor'
    ].
    DefaultEdgeStyle := StyleSheet at:#'noteBook.edgeStyle'.
    DefaultEdgeStyle isNil ifTrue:[
        DefaultEdgeStyle := StyleSheet at:#'button.edgeStyle'
    ].

    DefaultEdgeStyle == #softWin95 ifFalse:[
        DefaultEdgeStyle := nil
    ].

    DefaultActiveTabMarkerColor := StyleSheet colorAt:#'noteBook.activeTabMarkerColor'.
    DefaultActiveTabMarkerColor isNil ifTrue:[
        DefaultActiveTabMarkerFgColor := nil.
    ] ifFalse:[
        DefaultActiveTabMarkerFgColor := Color redByte:255 greenByte:138 blueByte:41.
    ].

    ((StyleSheet at:#'noteBook.showRemoveTabIcon' default:true)
    and:[ ToolbarIconLibrary notNil ]) ifTrue:[
        RemoveTabIcon := ToolbarIconLibrary removeTabIcon.
        RemoveTabEnteredIcon := ToolbarIconLibrary removeTabEnteredIcon.   
    ] ifFalse:[
        RemoveTabIcon := RemoveTabEnteredIcon := nil.   
    ].
    AddTabIcon := ToolbarIconLibrary addTabIcon.
    AddTabEnteredIcon := ToolbarIconLibrary addTabEnteredIcon.   

    "
     self updateStyleCache
    "
! !

!NoteBookView class methodsFor:'image specs'!

tabBackgroundVista
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self tabBackgroundVista inspect
     ImageEditor openOnClass:self andSelector:#tabBackgroundVista
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NoteBookView class tabBackgroundVista'
        ifAbsentPut:[(Depth8Image new) width: 5; height: 25; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B@ HB@ NC 8NC 4MCP4MCP4MCP4LC@0LC@,KB0,KB0,KB0,JB (JB (JB (JBP$IBP$GA0\GA0@@@@@@@@@@@@@@@@@@@@@@@@@@@PDA@PDA@PDA@PHB@ HB
@0LC@0LDA@PDA@TEAPTEA XFA XGA0\GA0\GA0\GA0\GA0\b') ; colorMapFromArray:#[232 232 232 233 233 233 234 234 234 235 235 235 236 236 236 237 237 237 238 238 238 240 240 240 242 242 242 245 245 245 246 246 246 247 247 247 248 248 248 249 249 249 250 250 250]; yourself]
! !

!NoteBookView methodsFor:'accepting-items'!

tabAtIndex:tabIndex put:newLabelOrTabItem
    "called when the contents of a tab changed; 
     test whether the old layout can be reused;
     otherwise we must recompute the whole list
    "
    |tab tabLayout prefX prefY tabPrefExtent|

    "/ a single items label has changed
    tab := list at:tabIndex ifAbsent:nil.
    tab notNil ifTrue:[
        tab labelOrTabItem:newLabelOrTabItem on:self.

        "/ no resizing, if the new string fits
        "/ and is not too small for current tab-layout
        tabLayout := tab unselectedLayout.
        tabLayout isNil ifTrue:[
            "/ cg: just encountered this one - what does it mean?
            self invalidate.
            ^ self.
        ].
        tabPrefExtent := self preferredExtentForTab:tab.
        prefX := tabPrefExtent x.
        prefY := tabPrefExtent y.

        (prefX <= tabLayout width and:[prefY <= tabLayout height]) ifTrue:[
            "/ the new string fits into the current tab-layout

            numberOfLines == 1 ifTrue:[         "/ do not change the layout
                ^ self invalidateTab:tab
            ].

            "/ check whether the string is not too small for current tab-layout
            ((tabLayout width <= (prefX * 1.5)) and:[tabLayout height <= (prefY * 1.5)]) ifTrue:[
                ^ self invalidateTab:tab.      "/ do not change the layout
            ].
        ].
        self recomputeList.
        self invalidate.
        ^ self.
    ].
    "/ can this happen ?

    "Created: / 25-02-2000 / 14:13:59 / cg"
    "Modified: / 07-03-2012 / 17:49:37 / cg"
! !

!NoteBookView methodsFor:'accessing'!

canvas
    "returns the canvas; the containter view
    "
    ^ canvas
!

canvas:newCanvas
    "change the canvas; the container view"

    |oldCanvas hadFocus focusView|

    oldCanvas := canvas.
    hadFocus  := false.

    (shown and:[newCanvas notNil and:[oldCanvas notNil]]) ifTrue:[
        windowGroup notNil ifTrue:[
            focusView := windowGroup focusView.
        ].
        (focusView notNil and:[focusView ~~ self]) ifTrue:[
            (focusView isComponentOf:oldCanvas) ifTrue:[
                hadFocus := true.
            ].
        ].
    ].

    newCanvas ~~ oldCanvas ifTrue:[
        oldCanvas notNil ifTrue:[
            (keepCanvas or:[(oldCanvas objectAttributeAt:#isTabItem) == true]) ifTrue:[
                oldCanvas beInvisible.
            ] ifFalse:[
                oldCanvas destroy.
            ].
        ].
        canvas := newCanvas.

        newCanvas notNil ifTrue:[
            tabModus := false.

            self resizeCanvas.

            (subViews size == 0 or:[(subViews includesIdentical:newCanvas) not]) ifTrue:[
                self addSubView:newCanvas
            ].

            shown ifTrue:[
                newCanvas beVisible.
                newCanvas raise.
            ].
        ].
    ].
    (shown and:[hadFocus]) ifTrue:[
        self pushEvent:#updateFocusView
    ].

    "Modified: / 05-11-2007 / 14:23:58 / cg"
!

hierarchicalIndexOfChild:aView
    ^ aView hierarchicalIndexInList:subViews
!

lastUserSelection
    ^ lastUserSelection
!

lastUserSelection:something
    lastUserSelection := something
!

list
    "return the list of Tabs or Labels
    "
    ^ list collect:[:aTab| aTab label ]

!

list:newTabItemListOrNil
    "set the tab-list.
     warning: transforms the given list to a list of tabItems,
     where each holds on to a corresponding list element.
     When a new list comes in, the list elements are compared for identity.
     This may make problems, when strings come in.
     Q: should we compare for equality here?"

    |selectionName newList newTabItemList oldSelectedTab|

    newTabItemList := newTabItemListOrNil ? #().

    useIndex ifFalse:[
        selectionName := self selection.
    ].

    list do:[:eachTab| 
        |tabItem|

        ((tabItem := eachTab tabItem) notNil and:[(newTabItemList includesIdentical:tabItem)]) ifFalse:[
            tabItem notNil ifTrue:[tabItem view:nil].
            eachTab removeDependent:self
        ]
    ].

    newList := newTabItemList collect:
        [:eachNewItem| 
            |tab|

            (eachNewItem isNil or:[(tab := list detect:[:eachTab| eachTab tabItem == eachNewItem] ifNone:nil) isNil]) ifTrue:[
                tab := Tab labelOrTabItem:eachNewItem on:self.
                tab addDependent:self.
            ].
            tab
        ].

    selection notNil ifTrue:[
        oldSelectedTab := 
            useIndex 
                ifTrue:[ list at: selection ifAbsent:nil ]
                ifFalse:[ selection ].
    ].

    list            := newList.
    preferredExtent := nil.
    numberOfLines   := nil.

    selection notNil ifTrue:[
        useIndex ifTrue:[
            selection > list size ifTrue:[
                selection := nil.
                self selectionChanged.
            ] ifFalse:[
                (list at:selection) == oldSelectedTab ifTrue:[
                    "/ actually no change
                    "/ self halt
                ] ifFalse:[
                    model notNil ifTrue:[
                        "/ force a simulated selection change (so that the canvas gets updated)
                        model changed.
                    ]
                ]
            ].
        ] ifFalse:[
            selection := list findFirst:[:el| el label = selectionName ].
            selection == 0 ifTrue:[
                selection := nil.
                self selectionChanged.
            ] ifFalse:[
                model notNil ifTrue:[
                    "/ force a simulated selection change (so that the canvas gets updated)
                    model changed.
                ]
            ]
        ]
    ].
    self recomputeList.
    self invalidate.

    "Modified: / 16-07-2013 / 19:15:05 / cg"
!

listIndexOf:something
    "convert something to an index into the list;
     returns the index or nil if not found
    "
    |index|

    something isNil ifTrue:[^ nil ].

    something isNumber ifTrue:[
        index := something
    ] ifFalse:[
        index := list findFirst:[:aTab|aTab label = something].
        index == 0 ifTrue:[
            index := list findFirst:[:aTab|aTab printableLabel = something]
        ]
    ].
    ^ (index between:1 and:list size) ifTrue:[index] ifFalse:[nil]
!

numberOfLines
    numberOfLines isNil ifTrue:[
        self realized ifTrue:[
            self recomputeList.
        ].
    ].

    "assume one line at least"
    ^ numberOfLines ? 1.
!

useIndex
    "use index instead of tab name
    "
    ^ useIndex
!

useIndex:aBoolean
    "set/clear the useIndex flag. If set, both actionBlock and change-messages
     are passed the index(indices) of the selection as argument. 
     If clear, the value(s) (i.e. the selected string) is passed.
     Default is false."

    useIndex := aBoolean


! !

!NoteBookView methodsFor:'accessing-actions'!

accessTabMenuAction
    "callback to retrieve the menu for a specific tab.
     the argument to the block is the index of the tab
    "
    ^ accessTabMenuAction
!

accessTabMenuAction:aOneArgAction
    "callback to retrieve the menu for a specific tab.
     the argument to the block is the index of the tab
    "
    accessTabMenuAction := aOneArgAction.
!

action
    "get the action block to be performed on select; the argument to
     the block is the selected index or nil in case of no selection.
    "
    ^ action
!

action:oneArgBlock
    "set the action block to be performed on select; the argument to
     the block is the selected index or nil in case of no selection.
    "
    action := oneArgBlock.

! !

!NoteBookView methodsFor:'accessing-behavior'!

destroyTabAction
    ^ destroyTabAction
!

destroyTabAction:aOneArgBlockOrNil
    destroyTabAction := aOneArgBlockOrNil

    "Modified (format): / 05-07-2011 / 15:35:07 / cg"
!

disableDestroyButtonOfInactiveTabs
    ^ true
!

enabled
    "returns true if tabs are enabled"

    ^ enabled
!

enabled:aState
    "set the enabled state of tabs"

    |state|

    state := aState ? true.

    enabled ~~ state ifTrue:[
        enabled := state.
        self invalidate.
    ]
!

isEnabled
    "returns the enabled state"

    ^ enabled
!

keepCanvas:aBoolean
    "if false (the default), the previous canvas is destroyed, whenever
     a new canvas is set.
     if true, it is unmapped and kept.
     Set this flag, if the application changes the canvas but wants
     them to be kept for fast switching."

    keepCanvas := aBoolean.
!

selectConditionBlock
    "get the conditionBlock; this block is evaluated before a selection
     change is performed; the change will not be done, if the evaluation
     returns false. The argument to the block is the selection index."

    ^ selectConditionBlock
!

selectConditionBlock:aOneArgBlock
    "get the conditionBlock; this block is evaluated before a selection
     change is performed; the change will not be done, if the evaluation
     returns false. The argument to the block is the selection index."

    selectConditionBlock := aOneArgBlock
!

showDestroyButtonOfInactiveTabs
    ^ false

    "Created: / 01-03-2007 / 16:41:56 / cg"
!

translateLabel
    "true if labels are translated"

    ^ translateLabel ? true   
!

translateLabel:aBoolean
    "set to true if labels should be translated"

    translateLabel := aBoolean.
!

translateToDisplayLabel:aString
    "translate the label"

    |application builder string|

    aString isEmptyOrNil ifTrue:[ ^ aString ].

    application := self application.
    application isNil ifTrue:[^ aString ].

    builder := application builder.
    builder notNil ifTrue:[
        string := builder bindingAt:aString asSymbolIfInterned.
        string notNil ifTrue:[^ string].
    ].
    translateLabel ifFalse:[ ^ aString ].
    ^ builder resources string:aString.
! !

!NoteBookView methodsFor:'accessing-colors'!

activeBackgroundColor
    "returns the bg color used when drawing the active tabs label"

    ^ activeBackgroundColor
!

activeBackgroundColor:aColor
    "set the bg color used when drawing the active tabs label"

    aColor = activeBackgroundColor ifTrue:[
        ^ self
    ].
    activeBackgroundColor := aColor.
    self invalidate.
!

activeForegroundColor
    "returns the color used when drawing the active tab's label"

    ^ activeForegroundColor
!

activeForegroundColor:aColor
    "set the color used when drawing the active tab's label"

    aColor = activeForegroundColor ifTrue:[
        ^ self
    ].
    activeForegroundColor := aColor.
    self invalidate.
!

activeTabMarkerColor
    "win-XP style marker"

    ^ activeTabMarkerColor    
!

activeTabMarkerColor:aColor
    activeTabMarkerColor := aColor.
!

activeTabMarkerFgColor
    "win-XP style marker"

    ^ activeTabMarkerFGColor
!

backgroundColor
    "return the backgroundColor of the notebook view"

    ^ backgroundColor
!

destroyTabForegroundColor
    "returns the color used to draw the destroy button"

    ^ foregroundColor.

"/    foregroundColor brightness < 0.5 ifTrue:[
"/        ^ Color grey:40  
"/    ] ifFalse:[
"/        ^ Color grey:60  
"/    ].
!

disabledDestroyTabForegroundColor
    "returns the color used to draw a disabled destroy button"

    ^ disabledForegroundColor.

"/    foregroundColor brightness < 0.5 ifTrue:[
"/        ^ Color grey:40  
"/    ] ifFalse:[
"/        ^ Color grey:60  
"/    ].
!

disabledForegroundColor
    "returns the color used when drawing disabled tab labels"

    ^ disabledForegroundColor
!

drawLightColor
    "get the color to be used for lighted edges; 
     bug fix caused by common drawEdge"

    ^ drawLightColor
!

foregroundColor
    "return the color used for drawing text"

    ^ foregroundColor
!

foregroundColor:aColor
    "set the color to be used for drawing text"

    aColor ~= foregroundColor ifTrue:[
        foregroundColor := aColor.
        self invalidate
    ]
!

halfLightColor
    ^ halfLightColor
!

halfShadowColor
    ^ halfShadowColor
!

viewBackground:aColor
    aColor isColor ifFalse:[^ self ].

    (aColor isColor and:[viewBackground ~= aColor]) ifTrue:[
        super viewBackground:aColor.
        backgroundColor := viewBackground.
        activeBackgroundColor := backgroundColor.
        foregroundColor := backgroundColor contrastingBlackOrWhite.
        activeForegroundColor := foregroundColor.

        foregroundColor = Color white ifTrue:[
            disabledForegroundColor := Color veryLightGray.
        ] ifFalse:[
            disabledForegroundColor := backgroundColor darker.
        ].
    ].
! !

!NoteBookView methodsFor:'accessing-dimension'!

activeTabMarkerHeight
    ^ 3
!

destroyButtonFrameForTab:aTab
    |l bW bH dX dY bLeft bTop|

    bW := self destroyButtonWidth.
    bH := self destroyButtonHeight.
    dX := self destroyButtonSepX.
    dY := self destroyButtonSepY.

    l := aTab layout.

    bLeft := l right - bW - dX.
    bTop := l top + dY.

    (aTab == self selectedTab) ifTrue:[
        bTop := bTop + self activeTabMarkerHeight
    ].

    ^ (bLeft @ bTop) extent:(bW @ bH )
!

destroyButtonHeight
    RemoveTabIcon notNil ifTrue:[^ RemoveTabIcon height].
    ^ 8
!

destroyButtonSepX
    "separating space between tabs right and the destroyButton"

    ^ 4

    "Modified: / 01-03-2007 / 16:45:40 / cg"
!

destroyButtonSepY
    "separating space between tabs top and the destroyButton"

    RemoveTabIcon notNil ifTrue:[^ 2].
    ^ 3

    "Modified: / 01-03-2007 / 16:45:19 / cg"
!

destroyButtonUsedWidth
    "returns the additional width used for a destroy button
    "
    ^ self destroyButtonSepX + self destroyButtonWidth.
!

destroyButtonWidth
    RemoveTabIcon notNil ifTrue:[^ RemoveTabIcon width].
    ^ 8
!

preferredExtent
    "compute max extent x/y based on one line"

    |lvl size x y isHorizontal insetX insetY ext|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    x := y := 0.
    lvl := tabLevel abs "max:1".
    size  := list size.

    size ~~ 0 ifTrue:[
        list do:[:aTab|
            |tabExtent|

            tabExtent := self preferredExtentForTab:aTab.
            x := tabExtent x + x.
            y := tabExtent y max:y.
        ].
    ].
    y := y + selectionInsetY + lvl + tabTopMargin + tabBottomMargin.
    x := x + selectionInsetX + selectionInsetX + ((lvl + lvl) * size).

    isHorizontal := self isHorizontal.

    isHorizontal ifTrue:[
        x := x + self tabLeftMargin + self tabRightMargin
    ] ifFalse:[
        y := y + self tabLeftMargin + self tabRightMargin
    ].

    tabModus ifFalse:[
        canvasInset isPoint ifTrue:[
            insetX := canvasInset x.
            insetY := canvasInset y.
        ] ifFalse:[
            insetX := insetY := canvasInset.
        ].
        canvas notNil ifTrue:[ ext := canvas preferredExtent ]
                     ifFalse:[ ext := 100@100 ].

        y := y + insetY + insetY + ext y.
        x := x max:ext x.
        x := x + insetX + insetX + lvl + lvl.
    ].

    isHorizontal ifTrue:[ ^ x @ y ].
    ^ y @ x

    "Modified (format): / 16-11-2016 / 23:13:18 / cg"
!

preferredExtentForTab:aTab
    "returns the preferred extent of a specific tab"

    |tabExtent|

    tabExtent := aTab extent.

    minimumTabWidth notNil ifTrue:[
        tabExtent := Point x:(tabExtent x max:minimumTabWidth) y:(tabExtent y).
    ].
    tabExtent := tabExtent + tabLabelInset.

    (self showingDestroyButton) ifTrue:[
        tabExtent := tabExtent + ((self destroyButtonUsedWidth) @ 0).
    ].
    ^ tabExtent.
! !

!NoteBookView methodsFor:'accessing-mvc'!

canvasHolder
    "get the model, which keeps the canvas, a kind of SimpleView
    "
    ^ canvasHolder
!

canvasHolder:aValueHolder
    "set the model, which keeps the canvas, a kind of SimpleView
    "
    canvasHolder removeDependent:self. 

    (canvasHolder := aValueHolder) notNil ifTrue:[
        canvasHolder addDependent:self.
        self canvas:(canvasHolder value)
    ]


!

listHolder
    "get the model, which keeps the list of Tabs or Labels
    "
    ^ listHolder
!

listHolder:aValueHolder
    "set the model, which keeps the list of Tabs or Labels
    "
    listHolder removeDependent:self. 

    (listHolder := aValueHolder) notNil ifTrue:[
        listHolder addDependent:self.
        self list:listHolder value.
    ].
!

model:aValueHolder
    "set the model, which keeps the selection"

    super model:aValueHolder.

    model notNil ifTrue:[
        self selection:(model value)
    ]
! !

!NoteBookView methodsFor:'accessing-style'!

addTabAction:aBlockOrNil
    "if not nil, an add-tab button is shown beside the tab list,
     which calls aBlock"

    addTabAction := aBlockOrNil
!

canvasInset
    "inset of the canvas relative to my frame
        tabLevel + canvasInset == origin of canvas
    "
    ^ canvasInset
!

canvasInset:anInset
    "inset of the canvas relative to my frame
        tabLevel + canvasInset == origin of canvas
    "
    anInset ~~ canvasInset ifTrue:[
        canvasInset := anInset.
        self styleChanged.
    ].
!

direction
    "returns the direction of tabs as symbol. On default the value is
     set to #top. Valid symbols are:
        #top       arrange tabs to be on top of a view
        #bottom    arrange tabs to be on bottom of a view
        #left      arrange tabs to be on left of a view
        #right     arrange tabs to be on right of a view
    "
    ^ direction

!

direction:aDirection
    "change the direction of tabs. On default the value is set to #top.
     Valid symbols are:
        #top       arrange tabs to be on top of a view
        #bottom    arrange tabs to be on bottom of a view
        #left      arrange tabs to be on left of a view
        #right     arrange tabs to be on right of a view
    "
    direction ~~ aDirection ifTrue:[
        direction := aDirection.
        self styleChanged.
    ].
!

fitLastRow
    "in case of true, the last row is expanded to the view size like all
     other raws. In case of false all the tabs in the last raw keep their
     preferred extent (x or y) dependant on the direction.
    "
    ^ fitLastRow
!

fitLastRow:aBool
    "in case of true, the last row is expanded to the view size like all
     other raws. In case of false all the tabs in the last raw keep their
     preferred extent (x or y) dependant on the direction.
    "

    fitLastRow ~~ aBool ifTrue:[
        fitLastRow := aBool.
        self styleChanged.
    ].
!

hasScrollButtons
    ^ buttonNext notNil
!

hasScrollButtons:aBoolean
    |hasScrollButtons|

    hasScrollButtons := self hasScrollButtons.
    hasScrollButtons == aBoolean ifTrue:[^ self].

    hasScrollButtons ifTrue:[
        buttonNext destroy.
        buttonPrev destroy.
        buttonNext := buttonPrev := nil.
    ] ifFalse:[
        buttonNext := ArrowButton in:self.
        buttonPrev := ArrowButton in:self.

        buttonNext beInvisible.
        buttonPrev beInvisible.
        
"/        realized ifTrue:[
"/            buttonNext create. "/ realize.
"/            buttonPrev create. "/ realize.
"/        ].
        buttonNext action:[ self scrollButtonPressed:#scrollRight  ].
        buttonPrev action:[ self scrollButtonPressed:#scrollLeft  ].
        buttonNext autoRepeat:true.
        buttonPrev autoRepeat:true.
        buttonNext doubleClickAction:[ self scrollButtonPressed:#scrollFullRight ].
        buttonNext doubleClickAction:[ self scrollButtonPressed:#scrollFullLeft ].
    ].
    self styleChanged.
!

isHorizontal
    "returns true in case of direction is #top or #bottom
    "
    ^ direction == #top or:[direction == #bottom]
!

minimumTabWidth
    "answer the minimum required width of a tab or nil (use extent of tab only)"

    ^ minimumTabWidth
!

minimumTabWidth:aWidthOrNil
    "set the minimum required width of a tab or nil (use extent of tab only)"

    minimumTabWidth ~= aWidthOrNil ifTrue:[
        minimumTabWidth := aWidthOrNil.
        self styleChanged.
    ].
!

showDestroyTabButton
    "if true, a close-tab icon is shown"

    ^ showDestroyTabButton
!

showDestroyTabButton:aBoolean
    "if true, a close-tab icon is shown"

    showDestroyTabButton == aBoolean ifTrue:[^ self].
    showDestroyTabButton := aBoolean.

    self styleChanged.
!

showDestroyTabButtonOnSingleTab
    "if true, AND showDestroyTabButton is true,
     a close-tab icon is shown even for a single tab.
     Otherwise, it is hidden if there is only one tab-item left"

    ^ showDestroyTabButtonOnSingleTab
!

showDestroyTabButtonOnSingleTab:aBoolean
    "if true, AND showDestroyTabButton is true,
     a close-tab icon is shown even for a single tab.
     Otherwise, it is hidden if there is only one tab-item left"

    showDestroyTabButtonOnSingleTab == aBoolean ifTrue:[^ self].
    showDestroyTabButtonOnSingleTab := aBoolean.

    self styleChanged.
!

tabBottomMargin
    "returns the margin between the tabs and the canvas
    "
    ^ tabBottomMargin
!

tabBottomMargin:aMargin
    "set the margin between the tabs and the canvas
    "
    |margin|

    margin := aMargin max:0.

    margin ~~ tabBottomMargin ifTrue:[
        tabBottomMargin := margin.
        self styleChanged.
    ].
!

tabLabelInset
    "inset (a point) of the label relative to its frame
         preferredExtent of Tab: label extent + tabLabelInset
    "
    ^ tabLabelInset
!

tabLabelInset:aPoint
    "inset (a point) of the label relative to its frame
         preferredExtent of Tab: label extent + tabLabelInset
    "
    |p|

    aPoint isNumber ifTrue:[ p := Point x:aPoint y:aPoint ]
                   ifFalse:[ p := aPoint ].

    p ~= tabLabelInset ifTrue:[
        tabLabelInset := p.
        self styleChanged.
    ].
!

tabLeftMargin
    "margin to the first visible tab or scroller button
    "
    ^ tabLeftMargin
!

tabLeftMargin:aMargin
    "margin to the first visible tab or scroller button
    "
    |margin|

    margin := aMargin max:0.

    margin ~~ tabLeftMargin ifTrue:[
        tabLeftMargin := margin.
        self styleChanged.
    ].
!

tabLevel
    "the level of the tabs and noteBook frame
    "
    ^ tabLevel
!

tabLevel:aLevel
    "the level of the tabs and noteBook frame
    "
    aLevel ~~ tabLevel ifTrue:[
        tabLevel := aLevel.
        self styleChanged.
    ].
!

tabRightMargin
    "margin from the last visible tab or scroller button to the view
    "
    ^ tabRightMargin
!

tabRightMargin:aMargin
    "margin from the last visible tab or scroller button to the view
    "
    |margin|

    margin := aMargin max:0.

    margin ~~ tabRightMargin ifTrue:[
        tabRightMargin := margin.
        self styleChanged.
    ].
!

tabTopMargin
    "returns the margin between the tabs and the widget (not canvas)
    "
    ^ tabTopMargin
!

tabTopMargin:aMargin
    "set the margin between the tabs and the widget (not canvas)
    "
    |margin|

    margin := aMargin max:0.

    margin ~~ tabTopMargin ifTrue:[
        tabTopMargin := margin.
        self styleChanged.
    ].
! !

!NoteBookView methodsFor:'change & update'!

styleChanged
    "called if the tab style changed
     list must be recomputed
    "
    preferredExtent := nil.

    numberOfLines isNil ifTrue:[
        ^ self.         "/ layout not yet computed
    ].
    self recomputeList.
    self invalidate
!

update:something with:aParameter from:changedObject
    "one of my models changed its value"

    |idx tab|

    changedObject == model ifTrue:[ 
        useIndex ifTrue:[
            self selection:model value.
        ] ifFalse:[
            self selectTab:model value.
        ].
        ^ self
    ].
    changedObject == listHolder ifTrue:[
        something == #at: ifTrue:[
            self tabAtIndex:aParameter put:(listHolder value at:aParameter).
            ^ self.
        ].
        (self windowGroup notNil and:[Processor activeProcess ~~ self windowGroup process]) ifTrue:[
            self sensor pushAction:
                [ 
                    self list:(listHolder value) 
                ]
        ] ifFalse:[
            self list:(listHolder value).
        ].
        ^ self
    ].

    changedObject == enableChannel ifTrue:[^ self enabled:enableChannel value].
    changedObject == canvasHolder  ifTrue:[^ self canvas:canvasHolder value].

    (idx := list findFirst:[:aTab| aTab label == changedObject]) ~~ 0 ifTrue:[
        tab := list at:idx.

        idx == selection ifTrue:[
            tab isEnabled ifFalse:[
                ^ self selection:nil
            ]
        ].
        tab label:(tab label) on:self.
        self invalidateTab:tab.
        ^ self.
    ].

    ^ super update:something with:aParameter from:changedObject

    "Modified: / 06-09-2006 / 11:38:23 / cg"
! !

!NoteBookView methodsFor:'drawing'!

computeDrawingClipX:x y:y width:w height:h
    |xOrY wOrHInset|

    self hasScrollButtons ifFalse:[^ nil].

    xOrY      := self tabLeftMargin.
    wOrHInset := self tabRightMargin + xOrY.

    self isHorizontal ifTrue:[
        ^ Rectangle left:xOrY top:y width:(self width - wOrHInset) height:h.
    ].
    ^ Rectangle left:x top:xOrY width:w height:(self height - wOrHInset)
!

drawActiveTabMarker:aTab
    "draw a tabs focus-rectangle"

    |layout w h yRct yPnt xRct xPnt incY incX markerHeight fgColor bgColor|

    layout := aTab layout.
    markerHeight := self activeTabMarkerHeight.

    bgColor := self activeTabMarkerColor.
    fgColor := self activeTabMarkerFgColor.

    self isHorizontal ifTrue:[
        xPnt := layout left + 1.
        w := layout width - 2.
        h := markerHeight.

        direction == #top ifTrue:[
            yPnt := yRct := layout top.
            incY := 1.
        ] ifFalse:[
            incY := -1.
            yRct := layout bottom - h.
            yPnt := layout bottom - 1.
        ].
        bgColor notNil ifTrue:[
            gc paint:bgColor.
            gc fillRectangleX:xPnt y:yRct width:w height:h.
        ].
        fgColor notNil ifTrue:[
            gc paint:fgColor.
            gc displayLineFromX:xPnt y:yPnt toX:(xPnt + w - 1) y:yPnt.

            (markerHeight - 1) timesRepeat:[
                yPnt := yPnt + incY.
                gc displayPointX:(xPnt - 1) y:yPnt.
                gc displayPointX:(xPnt + w) y:yPnt.
            ].
        ].
    ] ifFalse:[
        w := markerHeight.
        h := layout height - 2.
        yRct := layout top + 1.

        direction == #left ifTrue:[
            incX := 1.
            xRct := xPnt := layout left.
        ] ifFalse:[
            incX := -1.
            xRct := layout right - w.
            xPnt := layout right - 1.
        ].

        bgColor notNil ifTrue:[
            gc paint:bgColor.
            gc fillRectangleX:xRct y:yRct width:w height:h.
        ].

        fgColor notNil ifTrue:[
            gc paint:fgColor.
            gc displayLineFromX:xPnt y:yRct toX:xPnt y:yRct + h - 1.

            (markerHeight - 1) timesRepeat:[
                xPnt := xPnt + incX.
                gc displayPointX:xPnt y:(yRct - 1).
                gc displayPointX:xPnt y:(yRct + h).
            ].
        ].
    ].
!

drawAddTabButton
    "redraw the add-tab button"

    |bFrame icon|

    bFrame := self frameForAddTabButton.

gc paint:(showingEnteredAddTabButton ifTrue:[Color green]ifFalse:[Color red]).
gc fillRectangle:bFrame.
gc paint:self blackColor.

    AddTabIcon notNil ifTrue:[
        addTabIcon isNil ifTrue:[
            addTabIcon := AddTabIcon onDevice:device.
            addTabEnteredIcon := AddTabEnteredIcon onDevice:device.
        ].
        showingEnteredAddTabButton 
            ifTrue:[icon := addTabEnteredIcon]
            ifFalse:[icon := addTabIcon].
        icon displayOn:self at:bFrame origin.
    ] ifFalse:[
        gc displayRectangle:bFrame.
        gc displayLineFrom:bFrame leftCenter+(1@0) to:bFrame rightCenter-(1@0).
        gc displayLineFrom:bFrame topCenter+(0@1) to:bFrame bottomCenter-(0@1).
    ]
!

drawBorderEdges
    |layout x0 x1 y0 y1 trans|

    "/ test whether TabView and not NoteBookView
    tabModus ifTrue:[^ self].

    layout := self computeBorderLayout.

    ((tabLevel ~~ 0) or:[canvasLevel ~~ 0]) ifTrue:[
        canvasLevel ~~ 0 ifTrue:[
            self drawEdgesForX:(layout left)
                             y:(layout top)
                         width:(layout width) 
                        height:(layout height)
                         level:tabLevel.
            ^ self
        ].
        "/only draw top-edge
        self drawTopEdgeLevel:tabLevel atY:layout top
             shadow:shadowColor light:lightColor 
             halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle.
        ^ self
    ].
    
    list isEmptyOrNil ifTrue:[^ self].

    true "canvasBorder ~~ 0" ifTrue:[
        gc paint:lightColor ? lightColor.
        
        trans := self transformation.

        (direction == #top or:[direction == #bottom]) ifTrue:[
            direction == #top ifTrue:[ y0 := layout top - 1 ]
                             ifFalse:[ y0 := layout bottom ].
            y1 := y0.
            x0 := 0.
            trans notNil ifTrue:[
                x0 := trans applyInverseToX:x0.
            ].
            x1 := x0 + self width.
        ] ifFalse:[
            direction == #left ifTrue:[ x0 := layout left - 1 ]
                              ifFalse:[ x0 := layout right    ].
            x1 := x0.
            y0 := 0.
            trans notNil ifTrue:[
                y0 := trans applyInverseToY:y0.
            ].
            y1 := y0 + self height.
        ].
        gc displayLineFromX:x0 y:y0 toX:x1 y:y1.
    ]
!

drawDestroyButtonForTab:aTab
    "redraw a tab's destroy button"

    |bFrame showEnabled icon|

    bFrame := self destroyButtonFrameForTab:aTab.
    showEnabled := (self disableDestroyButtonOfInactiveTabs not
                    or:[ aTab == self selectedTab ]).

    RemoveTabIcon notNil ifTrue:[
        removeTabIcon isNil ifTrue:[
            removeTabIcon := RemoveTabIcon onDevice:device.
            removeTabEnteredIcon := RemoveTabEnteredIcon onDevice:device.
            removeTabDisabledIcon := (removeTabIcon asGrayImageDepth:4) lightened lightened.
            removeTabDisabledIcon mask:(removeTabIcon mask copy).
            removeTabDisabledIcon := removeTabDisabledIcon onDevice:device.
        ].
        showEnabled ifTrue:[
            showingEnteredRemoveTabButton ifTrue:[icon := removeTabEnteredIcon]
                                         ifFalse:[icon := removeTabIcon].
        ] ifFalse:[
            icon := removeTabDisabledIcon.
        ].
        icon displayOn:self at:bFrame origin.
    ] ifFalse:[
        gc paint:(showEnabled 
                            ifTrue:[self destroyTabForegroundColor] 
                            ifFalse:[self disabledDestroyTabForegroundColor]).

        gc displayRectangle:bFrame.
        gc displayLineFrom:bFrame topLeft to:bFrame bottomRight-(1@1).
        gc displayLineFrom:bFrame topRight - (1@0) to:bFrame bottomLeft-(0@1).
    ]

    "Modified (comment): / 16-07-2013 / 19:22:12 / cg"
!

drawTabEdgesFor:aTab
    |layout absTabLevel leftFg leftHalfFg rightFg x0 x1 y0 y1 isSelected
     yT "{ Class:SmallInteger }"
     xL "{ Class:SmallInteger }"
     xR "{ Class:SmallInteger }"
     yB "{ Class:SmallInteger }"
    |

    absTabLevel := tabLevel.
    isSelected := (self selectedTab == aTab).

    absTabLevel <= 0 ifTrue:[
        isSelected ifFalse:[ ^ self ].

        absTabLevel == 0 ifTrue:[
            list size > 1 ifFalse:[^ self].
            absTabLevel := 1
        ] ifFalse:[
            absTabLevel := absTabLevel negated
        ].

        rightFg    := lightColor.
        leftFg     := shadowColor.
        leftHalfFg := halfShadowColor.
    ] ifFalse:[
        ((edgeStyle == #soft) and:[tabLevel > 1]) ifTrue:[ rightFg := halfShadowColor ]
                                                 ifFalse:[ rightFg := shadowColor ].
        leftFg     := lightColor.
        leftHalfFg := halfLightColor.
    ].

    (leftHalfFg notNil and:[edgeStyle == #soft and:[tabLevel > 0]]) ifTrue:[
        leftFg := leftHalfFg
    ].

    layout := aTab layout.
    xL := layout left.
    yT := layout top.
    xR := layout right  - 1.
    yB := layout bottom - 1.

    x0 := xL + absTabLevel.
    x1 := xR - absTabLevel.
    y0 := yT + absTabLevel.
    y1 := yB - absTabLevel.

    direction == #top ifTrue:[
        gc paint:rightFg.

        0 to:absTabLevel - 1 do:[:i|              "/ vertical: right
            gc displayLineFromX:xR - i y:yB toX:xR - i  y:y0 - i.
        ].

        gc paint:leftFg.

        0 to:absTabLevel - 1 do:[:i|              "/ horizontal: left       
            gc displayLineFromX:xL + i y:y0 - i toX:xL + i y:yB.
        ].

        0 to:absTabLevel - 1 do:[:i|              "/ horizontal: top
            gc displayLineFromX:x0 - i y:yT + i toX:x1 y:yT + i.
        ].
        (isSelected and:[absTabLevel > 1]) ifFalse:[^ self].
        (self isLastTabInLine:aTab)   ifTrue:[^ self].

        y0 := yB + 1.
        x1 := x1 + 1.

        1 to:absTabLevel - 1 do:[:i|              "/ horizontal line
            gc displayLineFromX:x1 + i y:y0 - i toX:xR  y:y0 - i.
        ].

        ^ self
    ].

    direction == #bottom ifTrue:[
        gc paint:leftFg.

        0 to:absTabLevel - 1 do:[:i|              "/ vertical : left
            gc displayLineFromX:xL + i y:yT toX:xL + i y:y1+i.
        ].

        gc paint:rightFg.

        0 to:absTabLevel - 1 do:[:i|              "/ horizontal: bottom
            gc displayLineFromX:x0 y:yB-i toX:x1 + i y:yB-i.
        ].

        0 to:absTabLevel - 1 do:[:i|              "/ vertical: right
            gc displayLineFromX:xR-i y:yT toX:xR-i y:y1+i.
        ].

        (isSelected and:[absTabLevel > 1]) ifFalse:[^ self].
        (self isFirstTabInLine:aTab)  ifTrue:[^ self].

        x0 := x0 - 1.
        y0 := yT - 1.

        1 to:absTabLevel - 1 do:[:i|              "/ selection shadow
            gc displayLineFromX:xL y:y0 + i toX:x0-i  y:y0 + i.
        ].
        ^ self
    ].

    direction == #right ifTrue:[
        gc paint:leftFg.

        0 to:absTabLevel - 1 do:[:i|              "/ horizontal: top
            gc displayLineFromX:xL y:yT + i toX:x1+i  y:yT + i.
        ].

        gc paint:rightFg.

        0 to:absTabLevel - 1 do:[:i|              "/ vertical: right
            gc displayLineFromX:xR-i y:y0 toX:xR-i  y:y1.
        ].

        1 to:absTabLevel do:[:i|              "/ horizontal: bottom
            gc displayLineFromX:xL y:y1+i toX:xR-i  y:y1+i.
        ].

        (isSelected and:[absTabLevel > 1]) ifFalse:[^ self].
        (self isFirstTabInLine:aTab)  ifTrue:[^ self].

        x0 := x0 - 1.
        y0 := yT - 1.

        1 to:absTabLevel - 1 do:[:i|              "/ selection shadow
            gc displayLineFromX:xL y:y0 + i toX:x0-i  y:y0 + i.
        ].
        ^ self
    ].

    "/ direction == #left
    gc paint:rightFg.

    x0 := xL + absTabLevel.
    x1 := xR - absTabLevel.
    y0 := yT + absTabLevel.
    y1 := yB - absTabLevel.

    0 to:absTabLevel - 1 do:[:i|      "/ horizontal: bottom
        gc displayLineFromX:x0 - i y:yB - i toX:xR  y:yB - i.
    ].

    self paint:leftFg.

    0 to:absTabLevel - 1 do:[:i|      "/ vertical: left
        gc displayLineFromX:xL + i y:y0 toX:xL + i y:y1.
    ].

    1 to:absTabLevel do:[:i|          "/ horizontal: top
        gc displayLineFromX:xL + i y:y0 - i toX:xR y:y0 - i.
    ].

    (isSelected and:[absTabLevel > 1]) ifFalse:[^ self].
    (self isLastTabInLine:aTab)   ifTrue:[^ self].

    x1 := x1 + 1.
    y0 := yB + 1.

    1 to:absTabLevel - 1 do:[:i|      "/ selection shadow
        gc displayLineFromX:x1+i y:yB + 1 - i toX:xR  y:yB + 1 - i.
    ].

    "Modified: / 31-10-2010 / 15:28:31 / cg"
!

drawTabFocus:aTab
    "draw a tabs focus-rectangle"

    |tabLyt extent top lft x y w h bW|

    self supportsFocusOnTab ifFalse:[ ^ self ].

    tabLyt := aTab layout.
    extent := aTab extent.
    top    := tabLyt top.
    lft    := tabLyt left.

    (self isDestroyTabButtonShownFor:aTab) ifTrue:[
        bW := self destroyButtonUsedWidth.
    ] ifFalse:[
        bW := 0.
    ].
    self isHorizontal ifTrue:[
        w := extent x + 4.
        h := extent y + 2.
        x := lft + ((tabLyt width  - w - bW) // 2).
        y := top + ((tabLyt height - h)      // 2).

        direction == #top ifTrue:[
            y := y + 1.
        ].
    ] ifFalse:[
        w := extent y + 2.
        h := extent x + 4.
        y := top + ((tabLyt height - h - bW) // 2).
        x := lft + ((tabLyt width  - w)      // 2).        

        direction == #left ifTrue:[
            x := x + 1.
        ].
    ].
    gc paint:(self blackColor).

    gc displayDottedRectangleX:(x max:lft) y:(y max:top) width:w height:h.
!

invalidateSelectedTab
    |selectedTab|

    selectedTab := self selectedTab.
    selectedTab notNil ifTrue:[
        self invalidateTab:selectedTab
    ].
!

invalidateTab:aTab
    "invalidate a tab (i.e. force it to be redrawn)"

    shown ifTrue:[
        self invalidate:(self computeLayoutForTab:aTab).
    ]
!

redrawTab:aTab 
    "redraw a tab"

    |isSelected fgColor buttonInset|

    isSelected := (self selectedTab == aTab).

    aTab layout isNil ifTrue:[^ self ].

    gc paint:(isSelected ifTrue:[self activeBackgroundColor] ifFalse:[self backgroundColor]).
    gc fillRectangle:(aTab layout).

    (enabled and:[aTab isEnabled]) ifFalse:[
        fgColor := disabledForegroundColor.
    ] ifTrue:[
        fgColor := aTab foregroundColor.
        fgColor isNil ifTrue:[
            fgColor := isSelected ifTrue:[activeForegroundColor] ifFalse:[foregroundColor].
        ]
    ].
    (self isDestroyTabButtonShownFor:aTab) ifTrue:[
        buttonInset := self destroyButtonUsedWidth.
    ] ifFalse:[
        buttonInset := 0.
    ].

    gc paint:fgColor.
    aTab displayOn:self inset:(tabLevel abs) direction:direction textRightInset:buttonInset.

    buttonInset > 0 ifTrue:[
        self drawDestroyButtonForTab:aTab.
    ].
    self drawTabEdgesFor:aTab.

    isSelected ifTrue:[
        self activeTabMarkerColor notNil ifTrue:[
            self drawActiveTabMarker:aTab.
        ].
        self hasFocus ifTrue:[
            self drawTabFocus:aTab
        ].
    ].
!

redrawX:x y:y width:w height:h
    "a region must be redrawn"

    |selectedTab line damage tabLayout clip borderLayout numLines|

    shown ifFalse:[ ^ self ].

    numberOfLines isNil ifTrue:[
        self recomputeList.
        "/ CA original: - should we redraw all below anyway?
        "/        numberOfLines notNil ifTrue:[
        "/            self invalidate
        "/        ].
        "/        ^ self
        numberOfLines isNil ifTrue:[
            ^ self
        ].
    ].

    selectedTab := self selectedTab.
    selectedTab notNil ifTrue:[
        (line := selectedTab lineNr) ~~ 1 ifTrue:[
            self makeToBaseLine:line.
            ^ self
        ]
    ].
    
    damage := Rectangle left:x top:y width:w height:h.

    "/ draw the damage intersects the tabs with my superViews background
    borderLayout := self computeBorderLayout.

    (borderLayout intersects:damage) ifTrue:[
        self clearRectangle:borderLayout.
    ].

"/ NEW CODE
    damage areasOutside:borderLayout do:[:r|
        gc paint:(superView viewBackground).
        gc fillRectangle:r.
    ].

    addTabAction notNil ifTrue:[
        (damage intersects:(self frameForAddTabButton)) ifTrue:[
            self drawAddTabButton
        ].
    ].
"/ OLD CODE    
"/    myRectangle := Rectangle origin:0@0 extent:self extent.
"/
"/    (myRectangle areasOutside:borderLayout) do:[:r|
"/        (r intersects:damage) ifTrue:[
"/            self paint:(superView viewBackground).
"/            self fillRectangle:r.
"/        ].
"/    ].
    (numberOfLines isNil or:[list size == 0]) ifTrue:[
        ^ self
    ].

    self drawBorderEdges.
    clip := self computeDrawingClipX:x y:y width:w height:h.

    "/ might happen that numberOfLines changed
    numLines := numberOfLines.
    numLines isNil ifTrue:[ ^ self ].

    numLines to:1 by:-1 do:[:aLnNr|
        list reverseDo:[:aTab|
            (aTab lineNr == aLnNr
             and:[aTab ~~ selectedTab
             and:[aTab intersects:damage]]
            ) ifTrue:[
                clip notNil ifTrue:[
                    self deviceClippingBounds:clip. "/ was: self clippingBounds:clip.
                    clip := nil.
                ].
                self redrawTab:aTab.
            ]
        ]
    ].
    selectedTab isNil ifTrue:[
        ^ self
    ].

    tabLayout := self computeLayoutForTab:selectedTab.
    (tabLayout intersects:damage) ifTrue:[
        clip notNil ifTrue:[
            self deviceClippingBounds:clip. "/ was: self clippingBounds:clip.
            clip := nil.
        ].
"/        selectedLayout := selectedTab layout.
"/        selectedTab layout:layout.
        self redrawTab:selectedTab.
"/        selectedTab layout:selectedLayout.
    ].
! !

!NoteBookView methodsFor:'event handling'!

buttonMotion:buttonState x:x y:y
    |tab mustShowEntered newEntered|

    "/ if we have to show a different icon while over the tab...
    tab := self tabContainingPointX:x y:y.
    (tab notNil and:[tab == self selectedTab]) ifTrue:[
        (self showingDestroyButton) ifTrue:[
            mustShowEntered := (self destroyButtonFrameForTab:tab) containsPoint:(x@y).
            mustShowEntered ~~ showingEnteredRemoveTabButton ifTrue:[
                showingEnteredRemoveTabButton := mustShowEntered.
                self drawDestroyButtonForTab:tab.    
            ]
        ].
    ].

    addTabAction notNil ifTrue:[
        newEntered := self frameForAddTabButton containsPoint:(x@y).
        (newEntered ~= showingEnteredAddTabButton) ifTrue:[
            showingEnteredAddTabButton := newEntered.
            self drawAddTabButton.   
        ].
    ].

    super buttonMotion:buttonState x:x y:y

    "Modified: / 01-03-2007 / 17:07:41 / cg"
!

buttonPress:button x:x y:y
    "a button is pressed; find tab under point and set the selection"

    |idx tab recv menu|

    tabWasActiveWhenPressed := false.

    enabled ifFalse:[ ^ self ].
    self updateFocusIdOnSelectedTab.
    list isEmpty ifTrue:[ ^ self ].

    idx := list findFirst:[:aTab| aTab containsPointX:x y:y ].
    idx == 0 ifTrue:[ ^ self ].
    tab := list at:idx.

    tabWasActiveWhenPressed := (tab == self selectedTab).

    tab isEnabled ifFalse:[ ^ self ].

    (button ~~ 2) ifTrue:[
        "/ change the selection
        tab ~~ self selectedTab ifTrue:[
            self userSelection:idx
        ].
        ^ self.
    ].

    accessTabMenuAction isNil ifTrue:[ ^ self ].
    menu := accessTabMenuAction value:idx.
    menu isNil ifTrue:[ ^ self ].

    menu isArray ifTrue:[
        menu := menu decodeAsLiteralArray
    ].

    menu receiver isNil ifTrue:[
        (recv := self application) isNil ifTrue:[
            recv := tab model
        ].
        recv notNil ifTrue:[
            menu receiver:recv
        ] ifFalse:[
            Transcript showCR:('%1 : Menu has no receiver' bindWith:(self class name)).
        ]
    ].
    self startUpMenu:menu
!

buttonRelease:button x:x y:y
    "a button is released; see if its the destroyTab button"
    |tab idx isDestroyAction|

    enabled     ifFalse:[ ^ self ].
    list isEmpty ifTrue:[ ^ self ].

    isDestroyAction := false.

    addTabAction notNil ifTrue:[
        (self frameForAddTabButton containsPoint:(x@y)) ifTrue:[
            addTabAction value.
            ^ self.
        ].
    ].

    tabWasActiveWhenPressed ifTrue:[    
        idx := list findFirst:[:aTab| 
                            (self isDestroyTabButtonShownFor:aTab)
                            and:[ aTab containsPointX:x y:y ]
                    ].
        idx ~~ 0 ifTrue:[
            tab := list at:idx ifAbsent:nil.
            tab notNil ifTrue:[
                (    tab == self selectedTab
                 or:[self disableDestroyButtonOfInactiveTabs not]
                ) ifTrue:[
                    ((self destroyButtonFrameForTab:tab) containsPointX:x y:y) ifTrue:[
                        tab destroyTabAction notNil ifTrue:[
                            tab destroyTabAction valueWithOptionalArgument:idx.
                        ] ifFalse:[
                            destroyTabAction value:idx.
                        ].
                        isDestroyAction := true.
                    ].
                ].
            ].
        ].
    ].
    isDestroyAction ifFalse:[
        super buttonRelease:button x:x y:y.
    ].
    shown ifTrue:[
        self pushEvent:#updateFocusView.
    ].
!

keyPress:aKey x:x y:y
    "selection might change; look for corresponding list entry"

    <resource: #keyboard (#CursorRight #CursorLeft #CursorUp #CursorDown)>

    self hasFocus ifFalse:[^ self].

    (enabled not or:[ list isEmptyOrNil]) ifTrue:[
        ^ super keyPress:aKey x:x y:y
    ].

    (self processAccessCharacter:aKey) ifTrue:[
        ^ self
    ].

    (self processShortcutKey:aKey) ifTrue:[
        ^ self
    ].

    ( aKey == #CursorRight 
    or:[ aKey == #CursorDown
    or:[ aKey == #CursorLeft
    or:[  aKey == #CursorUp]]] ) ifTrue:[
        self processCursorKey:aKey x:x y:y.
        ^ self
    ].

    ^ super keyPress:aKey x:x y:y

    "Modified: / 22-03-2011 / 13:29:46 / cg"
!

pointerLeave:state
    |tab|

    showingEnteredRemoveTabButton ifTrue:[
        showingEnteredRemoveTabButton := false.
        tab := self selectedTab.
        tab notNil ifTrue:[
            self drawDestroyButtonForTab:tab.    
        ]
    ].
    addTabAction notNil ifTrue:[ 
        showingEnteredAddTabButton ifTrue:[
            showingEnteredRemoveTabButton := false.
            self drawAddTabButton.   
        ].
    ].
    super pointerLeave:state
!

processAccessCharacter:aKey
    "a character is pressed; check for tab identified by the character
     select the tab and return true or if no tab detected return false"

    |j size char blck|

    (aKey isCharacter not or:[(size := list size) == 0]) ifTrue:[
        ^ false
    ].

    size == selection ifTrue:[
        size == 1 ifTrue:[^ false].
        j := 1
    ] ifFalse:[
        j := selection isNil ifTrue:[1] ifFalse:[selection + 1]
    ].

    char := aKey asLowercase.
    blck := [:i| ((list at:i) accessCharacter == char and:[self isSelectable:i]) ifTrue:[
                      self selection:i.
                    ^ true
                  ]        
            ].

    j to:size  do:blck.
    1 to:(j-1) do:blck.
  ^ false

    "Modified: / 22-03-2011 / 12:22:03 / cg"
!

processCursorKey:aKey x:x y:y
    "selection might change; look for corresponding list entry"

    <resource: #keyboard (#CursorRight #CursorLeft #CursorUp #CursorDown)>

    |sensor index nKeys selectNext selectPrev|

    selectNext := selectPrev := false.

    ((aKey == #CursorRight) or:[aKey == #CursorDown]) ifTrue:[
        selectNext := true.
    ] ifFalse:[ ((aKey == #CursorLeft) or:[aKey == #CursorUp]) ifTrue:[
        selectPrev := true.
    ]].

    "/ cg: this is rubbish - nobody needs key-compression here
    "/ (if you fall asleep on the CursorRight key, you are not really 
    "/  doing useful work, anyway) !!

    sensor := self sensor.
    sensor notNil ifTrue:[
        nKeys := 1 + (sensor compressKeyPressEventsWithKey:aKey).
        nKeys := (nKeys \\ list size) max:1.
    ] ifFalse:[
        nKeys := 1.
    ].
    index := selection ? 0.

    nKeys timesRepeat:[
        selectNext ifTrue:[
            index := self nextSelectableAfter:index wrapAtEnd:true.
        ] ifFalse:[
            index := self previousSelectableBefore:index wrapAtBegin:true.
        ].
        index == 0 ifTrue:[^ self].
    ].

    self userSelection:index.
!

processShortcutKey:aKey
    "if there is a short-key for that character, process it
     and return true. Otherwise, return false.
    "
    |j k size rawKey blck|

    (size := list size) == 0 ifTrue:[
        ^ false
    ].
    rawKey := device keyboardMap bindingForLogical:aKey.
    rawKey isNil ifTrue:[ rawKey := aKey ].

    size == selection ifTrue:[
        size == 1 ifTrue:[^ false].
        j := 1
    ] ifFalse:[
        j := selection isNil ifTrue:[1] ifFalse:[selection + 1]
    ].

    blck := [:i| k := (list at:i) shortcutKey.

                 (k notNil and:[(self isSelectable:i) and:[(k == aKey or:[k == rawKey])]]) ifTrue:[
                     self selection:i.
                   ^ true
                 ]
            ].

    j to:size  do:blck.
    1 to:(j-1) do:blck.
  ^ false

    "Modified: / 12-10-2017 / 00:25:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processShortcutKeyEvent:event
    ^ self processShortcutKey:(event key)
!

sizeChanged:how
    "size of my view changed" 

    super sizeChanged:how.

    (list notEmptyOrNil and:[numberOfLines notNil]) ifTrue:[
        lastComputedExtent ~= self extent ifTrue:[
            "/ during redraw we (forced by invalidate) we will
            "/ recompute the list; so if the event is raised n times
            "/ we only recompute the list once
            numberOfLines := nil.
        ].
    ].

    self resizeCanvas.
    self invalidate.
! !

!NoteBookView methodsFor:'focus handling'!

canTab
    "if the list of tabLabels is empty, we do not need the focus
     by tabing - give the focus to my included subviews."

    ^ list notEmpty and:[ super canTab ]

    "Modified: / 06-03-2007 / 16:55:01 / cg"
!

showFocus:explicit
    "got the keyboard focus"

    self supportsFocusOnTab ifTrue:[
        self invalidateSelectedTab
    ] ifFalse:[
        super showFocus:explicit
    ].
!

showNoFocus:explicit
    "lost the keyboard focus"

    self supportsFocusOnTab ifTrue:[
        self invalidateSelectedTab
    ] ifFalse:[
        super showNoFocus:explicit
    ].
!

supportsFocusOnTab
    "return true if the keyboard focus can ever be on the tab area
    "
    ^ (styleSheet at:#'focusHighlightStyle') == #win95
!

updateFocusIdOnSelectedTab
    "update the lastFocusId for the current selected tab"

    |tab focusView id|

    (canvas notNil and:[canvas shown]) ifFalse:[^ self].
    windowGroup isNil ifTrue:[^ self].

    focusView := windowGroup focusView.
    (focusView notNil and:[focusView shown]) ifFalse:[^ self ].

    tab := self selectedTab.
    tab isNil ifTrue:[^ self].

    id := focusView id.
    tab lastFocusViewId = id ifTrue:[^ self].

    (focusView isComponentOf:canvas) ifTrue:[
        tab lastFocusViewId:id.
    ].

    "Modified: / 05-11-2007 / 14:22:57 / cg"
!

updateFocusView
    "called when updating the focusView within my canvas"

    |focusView tab id keyBoardConsumer alternateFocusView toolbarFocusView|

    (canvas notNil and:[canvas shown]) ifFalse:[ ^ self ].

    tab := self selectedTab.
    windowGroup notNil ifTrue:[
        focusView := windowGroup focusView.
    ].
    (focusView notNil and:[focusView shown]) ifTrue:[
       (focusView isComponentOf:canvas) ifTrue:[
            tab notNil ifTrue:[
                tab lastFocusViewId:(focusView id).
            ].
            ^ self
        ].
    ].

    tab notNil ifTrue:[
        (id := tab lastFocusViewId) notNil ifTrue:[
            "/ show if last stored view with id within canvas exists
            focusView := canvas allVisibleSubViewsDetect:[:v| v id = id ] ifNone:nil.

            (focusView notNil and:[focusView shown]) ifTrue:[
                windowGroup notNil ifTrue:[ 
                    windowGroup focusView:focusView byTab:true 
                ].
                ^ self
            ].
            tab lastFocusViewId:nil.
        ].
    ].

    canvas focusNextForWhich:[:aView|
        aView shown ifTrue:[
            aView isKeyboardConsumer ifTrue:[
                keyBoardConsumer := aView.
            ] ifFalse:[
                alternateFocusView isNil ifTrue:[
                    (aView isMemberOf:MenuPanel) ifTrue:[
                        toolbarFocusView notNil ifTrue:[
                            toolbarFocusView := aView.
                        ]
                    ] ifFalse:[
                        alternateFocusView := aView
                    ].
                ].
            ].
        ].
        keyBoardConsumer notNil
    ].
    focusView := keyBoardConsumer ? alternateFocusView.

    focusView isNil ifTrue:[
        toolbarFocusView isNil ifTrue:[^ self].
        focusView := toolbarFocusView.
    ].
    tab notNil ifTrue:[
        tab lastFocusViewId:(focusView id)
    ].
    windowGroup notNil ifTrue:[ 
        windowGroup focusView:focusView byTab:true 
    ].

    "Modified: / 05-11-2007 / 14:24:23 / cg"
!

wantsFocusWithButtonPress
    "never wants the focus by button press
    "
    ^ false
! !

!NoteBookView methodsFor:'help'!

flyByHelpTextAt:srcPoint
    ^ self helpTextAt:srcPoint
!

helpText
    "return the helpText for the currently selected item (empty if none)"

    ^ self helpTextForItemAt:selection
!

helpTextAt:srcPoint
    "return the helpText for aPoint (i.e. when mouse-pointer is moved over an item)."

    |x y tab|

    x := srcPoint x.
    y := srcPoint y.
    tab := self tabContainingPointX:x y:y.

    tab notNil ifTrue:[
        (self showingDestroyButton) ifTrue:[
            (tab == self selectedTab
            or:[ self disableDestroyButtonOfInactiveTabs not ]) ifTrue:[
                ((self destroyButtonFrameForTab:tab) containsPointX:x y:y) ifTrue:[
                    ^ resources string:'Remove this Tab'
                ]
            ].
        ].
    ].

    ^ self helpTextForTab:tab
!

helpTextForItemAt:anIndex
    |tab|

    (     anIndex notNil
     and:[anIndex ~~ 0
     and:[(tab := list at:anIndex ifAbsent:nil) notNil]]
    ) ifTrue:[
        ^ self helpTextForTab:tab.
    ].
    ^ nil

    "Modified: / 06-09-2006 / 16:03:03 / cg"
!

helpTextForTab:aTab
    |tabItem|

    aTab notNil ifTrue:[
        (tabItem := aTab tabItem) notNil ifTrue:[
            ^ tabItem activeHelpText
        ].
    ].
    ^ nil

    "Modified: / 06-09-2006 / 16:03:03 / cg"
! !

!NoteBookView methodsFor:'initialization & release'!

destroy
    "remove dependencies"

    list removeDependent:self.

    listHolder    removeDependent:self. 
    canvasHolder  removeDependent:self.

    list notEmptyOrNil ifTrue:[
        list do:[:anItem| 
            |tabItem|

            tabItem := anItem tabItem.
            tabItem notNil ifTrue:[
                tabItem destroyCanvas.
            ]
        ]
    ].
    super destroy.

    "Modified: / 06-09-2006 / 16:04:32 / cg"
!

initStyle
    "setup style attributes
    "
    <resource: #style (#'noteBook.viewBackground' 
                       #'noteBook.tabTopMargin' 
                       #'noteBook.tabBottomMargin'
                       #'noteBook.tabLevel'
                       #'noteBook.tabLabelInset'
                       #'noteBook.canvasInset'
                       #'noteBook.canvasBorder'
                       #'noteBook.canvasLevel'
                       )>
    |clr graphicsDevice|

    super initStyle.
    graphicsDevice := device.
    tabModus  := false.
    edgeStyle := DefaultEdgeStyle.

    clr := styleSheet colorAt:#'noteBook.viewBackground'.
    clr notNil ifTrue:[ viewBackground := clr ].

    self font:self class defaultFont.
    drawLightColor := Color veryLightGray onDevice:graphicsDevice.

    clr := DefaultForegroundColor ? self blackColor.
    foregroundColor := clr onDevice:graphicsDevice.

    clr := DefaultBackgroundColor ? viewBackground.
    backgroundColor := clr onDevice:graphicsDevice.

    clr := DefaultActiveBackgroundColor ? backgroundColor.
    activeBackgroundColor := clr onDevice:graphicsDevice.

    clr := DefaultActiveForegroundColor ? foregroundColor.
    activeForegroundColor := clr onDevice:graphicsDevice.

"/    (clr := DefaultShadowColor) isNil ifTrue:[clr := viewBackground darkened].
"/    shadowColor := clr onDevice:graphicsDevice.
"/    (clr := DefaultLightColor) isNil ifTrue:[clr := viewBackground lightened].
"/    lightColor := clr onDevice:graphicsDevice.

    (clr := DefaultShadowColor) notNil ifTrue:[shadowColor := clr onDevice:graphicsDevice].
    (clr := DefaultLightColor) notNil ifTrue:[lightColor := clr onDevice:graphicsDevice].

    edgeStyle isNil ifTrue:[
        halfShadowColor := shadowColor.
        halfLightColor  := lightColor.
        drawLightColor  := lightColor.
    ] ifFalse:[
"/        (clr := DefaultHalfShadowColor) isNil ifTrue:[
"/            clr := shadowColor lightened
"/        ].
"/        halfShadowColor := clr onDevice:graphicsDevice.
"/
"/        (clr := DefaultHalfLightColor) isNil ifTrue:[
"/            clr := lightColor darkened.
"/        ].
"/        halfLightColor := clr onDevice:graphicsDevice.

        (clr := DefaultHalfShadowColor) notNil ifTrue:[
            halfShadowColor := clr onDevice:graphicsDevice.
        ].

        (clr := DefaultHalfLightColor) notNil ifTrue:[
            halfLightColor := clr onDevice:graphicsDevice.
        ].

        edgeStyle == #soft ifTrue:[
            drawLightColor := halfShadowColor
        ] ifFalse:[
            drawLightColor := Color veryLightGray onDevice:graphicsDevice.
        ]
    ].
    (clr := DisabledForegroundColor) notNil ifTrue:[
        disabledForegroundColor := clr onDevice:graphicsDevice
    ]ifFalse:[
        disabledForegroundColor := drawLightColor
    ].

    activeTabMarkerColor := DefaultActiveTabMarkerColor.
    activeTabMarkerFGColor := DefaultActiveTabMarkerFgColor.

    canvasInset      := styleSheet at:#'noteBook.canvasInset'      default:1@1.

    tabLevel         := styleSheet at:#'noteBook.tabLevel'         default:1.
    tabLabelInset    := styleSheet at:#'noteBook.tabLabelInset'    default:6@4.
    selectionInsetX  := (2 max:(tabLevel abs)) + 1.
    selectionInsetY  := (2 max:(tabLevel abs)) + 1.

    tabTopMargin    := styleSheet at:#'noteBook.tabTopMargin' default:4.
    tabBottomMargin := styleSheet at:#'noteBook.tabBottomMargin' default:1.

    canvasLevel := styleSheet at:#'noteBook.canvasLevel' default:tabLevel.
!

initialize

    "/must init first - these values might be overwritten by initStyle
    showDestroyTabButton := false.
    canvasInset      := 1@1.
    keepCanvas       := false.
    tabLevel         := 1.
    tabLabelInset    := 6@4.
    selectionInsetX  := (2 max:(tabLevel abs)) + 1.
    selectionInsetY  := (2 max:(tabLevel abs)) + 1.
    translateLabel   := false.

    tabRightMargin   := 0.
    tabLeftMargin    := 0.

    tabTopMargin     := 4.
    tabBottomMargin  := 1.
    canvasLevel      := tabLevel.

    showingEnteredRemoveTabButton := showingEnteredAddTabButton := false.
    tabWasActiveWhenPressed := false.

    super initialize.

    self enableMotionEvents.  "/ for flyByHelp
    self cursor:Cursor hand.

    list             := #().
    useIndex         := true.
    direction        := #top.
    fitLastRow       := true.
    enabled          := true.

    self lineWidth:0.

"/    canvas notNil ifTrue:[
"/        canvas := canvas in:self.
"/    ].
!

mapped

    super mapped.

    canvas notNil ifTrue:[
        canvas beVisible.
        canvas raise.
        self hasFocus ifTrue:[
            self pushEvent:#updateFocusView.
        ].
    ].
!

postRealize
    "automatically set the initially selected notebook tab;
     unless it has been set already (by setup code)"

    selection isNil ifTrue:[
        self setSelection:1.
    ].
    super postRealize.
!

realize

    ("canvas notNil ASK CA" true and:[numberOfLines isNil]) ifTrue:[
        self recomputeList
    ].
    super realize.
! !

!NoteBookView methodsFor:'layout'!

computeBorderLayout
    "returns the layout of the frame araound the canvas"

    |xL yT xR yB tab l|

    xL  := 0.
    yT  := 0.
    xR  := self width.
    yB  := self height.

    list notEmpty ifTrue:[
        tab := list detect:[:aTab| aTab lineNr == 1] ifNone:nil.

        tab notNil ifTrue:[
            l := tab unselectedLayout.

                      direction == #top    ifTrue:[ yT := l bottom ]
            ifFalse:[ direction == #bottom ifTrue:[ yB := l top    ]
            ifFalse:[ direction == #left   ifTrue:[ xL := l right  ]
            ifFalse:[
                xR := l left
            ]]]
        ]
    ].
    self buttonLayoutUpdate.        

    ^ Rectangle left:xL top:yT right:xR bottom:yB
!

computeLayoutForTab:aTab
    "calculate the effective bounds of a tab.
     This includes any size changes for the active tab (overlap etc.)."

    |unselectedLayout selectedLayout computedLayout bwAbs 
     tabLeft tabRight tabTop tabBottom|

    aTab isNil ifTrue:[^ nil].

    unselectedLayout := aTab unselectedLayout.
    (self hasTabSelected:aTab) ifFalse:[
        ^ unselectedLayout
    ].

    selectedLayout := aTab selectedLayout.
    selectedLayout notNil ifTrue:[
        ^ selectedLayout
    ].


    "/ compute and remember
    bwAbs     := tabLevel abs.
    tabLeft   := unselectedLayout left.
    tabRight  := unselectedLayout right.
    tabTop    := unselectedLayout top.
    tabBottom := unselectedLayout bottom.

    (direction == #top or:[direction == #bottom]) ifTrue:[
        tabLeft   := tabLeft - selectionInsetX.
        tabRight  := tabRight + selectionInsetX.

        bwAbs == 0 ifTrue:[
            tabLeft  == 0          ifTrue:[ tabLeft  := tabLeft  - 1 ].
            tabRight == self width ifTrue:[ tabRight := tabRight + 1 ].
        ].

        direction == #top  ifTrue:[
            tabBottom := tabBottom + bwAbs.
            tabTop    := tabTop - selectionInsetY.
        ] ifFalse:[
            tabTop    := tabTop    - bwAbs.
            tabBottom := tabBottom + selectionInsetY.
        ].
    ] ifFalse:[
        tabTop    := tabTop    - selectionInsetX.
        tabBottom := tabBottom + selectionInsetX.

        bwAbs == 0 ifTrue:[
            tabTop    == 0           ifTrue:[ tabTop    := tabTop    - 1 ].
            tabBottom == self height ifTrue:[ tabBottom := tabBottom + 1 ].
        ].

        direction == #left ifTrue:[
            tabRight := tabRight + bwAbs.
            tabLeft  := tabLeft  - selectionInsetY
        ] ifFalse:[
            tabLeft  := tabLeft  - bwAbs.
            tabRight := tabRight + selectionInsetY.
        ]
    ].
    computedLayout := Rectangle left:tabLeft top:tabTop right:tabRight bottom:tabBottom.
    aTab selectedLayout:computedLayout.
    ^ computedLayout
!

frameForAddTabButton
    |firstTab w h m frameHeight frameWidth|

    list isEmptyOrNil ifTrue:[^ nil].

    m := 2.

    w := h := 16.
    addTabIcon notNil ifTrue:[
        w := addTabIcon width.
        h := addTabIcon height
    ].

    firstTab := list first unselectedLayout.

    self isHorizontal ifTrue:[
        frameHeight := firstTab height.
        direction == #top ifTrue:[ 
            ^ Rectangle origin:( (width-w-m) @ (frameHeight-h))
                        extent:( w @ h )
        ].
        "/ bottom
        ^ Rectangle origin:( (width-w-m) @ (height-frameHeight))
                    extent:( w @ h)
    ] ifFalse:[
        frameWidth := firstTab width.
        direction == #right ifTrue:[ 
            ^ Rectangle origin:( (width-w-m) @ (height-20))
                        extent:( w @ h)
        ].
        "/ left
        ^ Rectangle origin:( m @ (height-20))
                    extent:( w @ h)
    ].
!

makeToBaseLine:aLnNr
    "rotate lines to make the line #aLnNr be the new base line (i.e.
     subtract (aLnNr-1) from all lines and take modulu the number of lines"

    |lineTopsOrLefts isHorizontal|

    isHorizontal := self isHorizontal.

    "collect per-lineNr offsets"
    lineTopsOrLefts := (1 to:self numberOfLines) collect:[:lnr |
                            |tabNr layout|

                            tabNr := list findFirst:[:aTab| aTab lineNr == lnr].
                            layout := (list at:tabNr) unselectedLayout.
                            isHorizontal ifTrue:[
                                layout top.
                            ] ifFalse:[
                                layout left.
                            ].
                       ].

    "change offsets of all tabs"
    list do:[:el |
        |layout topOrLeft nr newNr|

        nr := el lineNr.
        newNr := nr - aLnNr + 1.
        newNr <= 0 ifTrue:[ newNr := newNr + numberOfLines].
        newNr := ((newNr - 1) \\ numberOfLines) + 1.
        topOrLeft := lineTopsOrLefts at:newNr.

        layout := el unselectedLayout copy.
        isHorizontal ifTrue:[
            layout setTop:topOrLeft.
        ] ifFalse:[
            layout setLeft:topOrLeft.            
        ].
        el unselectedLayout:layout.
        el selectedLayout:nil.
        el layout:(self computeLayoutForTab:el).

        el lineNr:newNr.
    ].

    self invalidate.
!

recomputeList
    "recompute list"

    |tab|

    numberOfLines      := 1.
    lastComputedExtent := self extent.

    self transformation:nil.

    list size ~~ 0 ifTrue:[
        self isHorizontal ifTrue:[ self recomputeListHorizontal ]
                         ifFalse:[ self recomputeListVertical ].

        tab := self selectedTab.
        tab isNil ifTrue:[tab := list first].
        tab layout:(self computeLayoutForTab:tab).
    ].
    self validateVisibleCanvas.
    self resizeCanvas.

    self hasScrollButtons ifTrue:[
        self isHorizontal ifTrue:[
            buttonNext direction:#right.
            buttonPrev direction:#left.
        ] ifFalse:[
            buttonNext direction:#down.
            buttonPrev direction:#up.
        ].
        self makeVisible:tab.
    ].
!

recomputeListHorizontal
    "compute layouts for all tabs"

    |lastLyt tabExtent isScrollable
     xLeft       "{ Class:SmallInteger }"
     xRight      "{ Class:SmallInteger }"
     yTop        "{ Class:SmallInteger }"
     tabWidth    "{ Class:SmallInteger }"
     tabHeight   "{ Class:SmallInteger }"
     delta       "{ Class:SmallInteger }"
     first       "{ Class:SmallInteger }"
     border      "{ Class:SmallInteger }"
     lastLnNr    "{ Class:SmallInteger }"
     tabLvlAbs   "{ Class:SmallInteger }"
     minLeft     "{ Class:SmallInteger }"
     maxRight    "{ Class:SmallInteger }"
     leftMargin  "{ Class:SmallInteger }"
     rightMargin "{ Class:SmallInteger }"
     nLines
    |

    tabLvlAbs     := tabLevel abs "max:1".
    border        := tabLvlAbs * 2.
    tabHeight     := 0.
    leftMargin    := self tabLeftMargin.
    rightMargin   := self tabRightMargin.
    minLeft       := leftMargin + selectionInsetX.
    maxRight      := self width - rightMargin - selectionInsetX.
    addTabAction notNil ifTrue:[
        maxRight := maxRight - self horizontalMarginForAddTabButton
    ].
    xLeft         := minLeft.
    isScrollable  := self hasScrollButtons.

    list do:[:aTab|
        tabExtent := self preferredExtentForTab:aTab.
        tabWidth  := tabExtent x + border.
        tabHeight := tabExtent y max:tabHeight.
        xRight    := xLeft + tabWidth.

        aTab destroyTabButtonShown ifTrue:[
            xRight := xRight + self destroyButtonUsedWidth
        ].

        (isScrollable not and:[xRight > maxRight]) ifTrue:[
            xLeft ~~ minLeft ifTrue:[
                numberOfLines := numberOfLines + 1.
                xLeft  := minLeft.
                xRight := xLeft + tabWidth.
            ].
            xRight > maxRight ifTrue:[
                tabWidth := maxRight - minLeft.
                xRight   := maxRight.
            ].
        ].
        aTab lineNr:numberOfLines.
        aTab unselectedLayout:(Rectangle left:xLeft top:0 width:tabWidth height:tabHeight).
        xLeft := xRight.
    ].
    tabHeight := tabHeight + tabLvlAbs.
    yTop      := selectionInsetY + tabTopMargin.

    direction == #bottom ifTrue:[
        yTop  := self height - tabHeight - yTop.
        delta := tabHeight negated.
    ] ifFalse:[
        delta := tabHeight
    ].

    lastLnNr := nLines := self numberOfLines.

    list reverseDo:[:aTab|
        |tabLayout|

        aTab lineNr ~~ lastLnNr ifTrue:[
            lastLnNr := aTab lineNr.
            yTop := yTop + delta
        ].
        tabLayout := aTab unselectedLayout.
        tabLayout setTop:yTop.
        tabLayout height:tabHeight.
    ].

    tabModus ifTrue:[
        |firstTabLayout|

        firstTabLayout := list first unselectedLayout.
        delta  := direction == #top 
                        ifTrue:[self height - firstTabLayout bottom]
                        ifFalse:[firstTabLayout top negated].

        list do:[:aTab | |l|
                l := aTab unselectedLayout.
                l setTop:(l top + delta).
        ].
    ].

    "/ FIT LINES
    (numberOfLines ~~ 1 or:[fitLastRow]) ifTrue:[
        first := 1.

        1 to:numberOfLines do:[:aLnNr|
            |last|

            last    := list findLast:[:t|t lineNr == aLnNr].
            lastLyt := (list at:last) unselectedLayout.

            (delta := maxRight - lastLyt right) > 0 ifTrue:[
                xLeft := minLeft.
                delta := delta // (last - first + 1).

                delta ~~ 0 ifTrue:[
                    list from:first to:last do:[:aTab|
                        |tabLayout|

                        tabLayout := aTab unselectedLayout.
                        tabWidth := tabLayout width + delta.
                        tabLayout setLeft:xLeft.
                        tabLayout width:tabWidth.
                        xLeft := xLeft + tabWidth.
                    ]
                ].
                lastLyt width:(maxRight - lastLyt left)
            ].
            first := last + 1.
        ]
    ].

    list do:[:eachTab | eachTab layout:eachTab unselectedLayout; selectedLayout:nil ].

    "Modified: / 16-07-2013 / 19:30:36 / cg"
!

recomputeListVertical
    "compute layouts for all tabs"

    |lastLyt tabExtent isScrollable
     xTop        "{ Class:SmallInteger }"
     yTop        "{ Class:SmallInteger }"
     yBottom     "{ Class:SmallInteger }"
     tabWidth    "{ Class:SmallInteger }"
     tabHeight   "{ Class:SmallInteger }"
     delta       "{ Class:SmallInteger }"
     first       "{ Class:SmallInteger }"
     border      "{ Class:SmallInteger }"
     lastLnNr    "{ Class:SmallInteger }"
     tabLvlAbs   "{ Class:SmallInteger }"
     minTop      "{ Class:SmallInteger }"
     maxBottom   "{ Class:SmallInteger }"
     leftMargin  "{ Class:SmallInteger }"
     rightMargin "{ Class:SmallInteger }"
    |

    tabLvlAbs     := tabLevel abs "max:1".
    border        := tabLvlAbs * 2.
    tabHeight     := 0.
    leftMargin    := self tabLeftMargin.
    rightMargin   := self tabRightMargin.
    minTop        := leftMargin + selectionInsetX.
    maxBottom     := self height - rightMargin - selectionInsetX.    
    addTabAction notNil ifTrue:[
        maxBottom := maxBottom - self verticalMarginForAddTabButton
    ].
    yTop          := minTop.
    isScrollable  := self hasScrollButtons.

    list do:[:aTab| aTab layout:nil; unselectedLayout:nil; selectedLayout:nil].

    list do:[:aTab|
        tabExtent := self preferredExtentForTab:aTab.
        tabWidth  := tabExtent x + border.
        tabHeight := tabExtent y max:tabHeight.
        yBottom   := yTop + tabWidth.

        (isScrollable not and:[yBottom > maxBottom]) ifTrue:[
            yTop ~~ minTop ifTrue:[
                numberOfLines := numberOfLines + 1.
                yTop    := minTop.
                yBottom := yTop + tabWidth.
            ].
            yBottom > maxBottom ifTrue:[
                tabWidth := maxBottom - minTop.
                yBottom  := maxBottom.
            ].
        ].
        aTab lineNr:numberOfLines.
        aTab unselectedLayout:(Rectangle left:0 top:yTop width:tabHeight height:tabWidth).
        yTop := yBottom
    ].
    tabHeight := tabHeight + tabLvlAbs.
    xTop      := selectionInsetY + tabTopMargin.

    direction == #right ifTrue:[
        xTop  := self width - tabHeight - xTop.
        delta := tabHeight negated.
    ] ifFalse:[
        delta := tabHeight.
    ].

    lastLnNr := numberOfLines.

    list reverseDo:[:aTab|
        |tabLayout|

        aTab lineNr ~~ lastLnNr ifTrue:[
            lastLnNr := aTab lineNr.
            xTop := xTop + delta
        ].
        tabLayout := aTab unselectedLayout.
        tabLayout setLeft:xTop.
        tabLayout width:tabHeight.
    ].

    tabModus ifTrue:[
        |firstTabLayout|

        firstTabLayout := list first unselectedLayout.
        delta  := direction == #left 
                        ifTrue:[self width - firstTabLayout right]
                        ifFalse:[firstTabLayout left negated].

        list do:[:aTab | |l|
                l := aTab unselectedLayout.
                l setLeft:(l left + delta).
        ].
    ].

    "/ FIT LINES
    (numberOfLines ~~ 1 or:[fitLastRow]) ifTrue:[
        first := 1.

        1 to:numberOfLines do:[:aLnNr|
            |last|

            last    := list findLast:[:t|t lineNr == aLnNr].
            lastLyt := (list at:last) unselectedLayout.

            (delta := maxBottom - lastLyt bottom) > 0 ifTrue:[
                yTop  := minTop.
                delta := delta // (last - first + 1).

                delta ~~ 0 ifTrue:[
                    list from:first to:last do:[:aTab|
                        |tabLayout|

                        tabLayout := aTab unselectedLayout.
                        tabWidth := tabLayout height + delta.
                        tabLayout setTop:yTop.
                        tabLayout height:tabWidth.
                        yTop := yTop + tabWidth.
                    ]
                ].
                lastLyt height:(maxBottom - lastLyt top)
            ].
            first := last + 1.
        ].
    ].

    list do:[:aTab | aTab layout:aTab unselectedLayout; selectedLayout:nil ].
!

resizeCanvas
    |newLayout borderWd|

    canvas notNil ifTrue:[
        newLayout := self computeBorderLayout.

        list notEmpty ifTrue:[
            borderWd := tabLevel abs.
            newLayout := newLayout insetBy:(canvasInset + borderWd).

            tabBottomMargin > 0 ifTrue:[
                (direction == #top or:[direction == #bottom]) ifTrue:[
                    newLayout height:(newLayout height - tabBottomMargin).
                    direction == #top ifTrue:[
                        newLayout setTop:(newLayout top + tabBottomMargin)
                    ]
                ] ifFalse:[
                    newLayout width:(newLayout width - tabBottomMargin).

                    direction == #left ifTrue:[
                        newLayout setLeft:(newLayout left + tabBottomMargin)
                    ]
                ]
                
            ].
        ].
        newLayout ~= canvas layout ifTrue:[
            canvas layout:newLayout.
        ].
    ]
! !

!NoteBookView methodsFor:'obsolete'!

canvasFrameLevel
    <resource: #obsolete>
    "ignored"

    ^ 0
!

canvasFrameLevel:anInteger
    <resource: #obsolete>
    "ignored"
!

labels
    <resource: #obsolete>
    "return the list of labels"

    ^ self list
!

labels:aListOfLabels
    <resource: #obsolete>
    "set the list of labels
    "
    ^ self list:aListOfLabels
!

labelsHolder
    <resource: #obsolete>
    "get the model, which keeps the list of Tabs or Labels
    "
    ^ self listHolder
!

labelsHolder:aValueHolder
    <resource: #obsolete>
    "set the model, which keeps the list of Tabs or Labels
    "
    self listHolder:aValueHolder. 
! !

!NoteBookView methodsFor:'private'!

horizontalMarginForAddTabButton
    "should be changed to be style specific;
     some (win8) prefer an additional, empty short tab"

    ^ 20 
!

indexOfTab:aTab
    ^ list indexOf:aTab 
!

showingDestroyButton
     ^ showDestroyTabButton 
     and:[destroyTabAction notNil
     and:[(showDestroyTabButtonOnSingleTab ~~ false) or:[list size > 1]]]
!

tabContainingPointX:x y:y
    ^ list detect:[:aTab| aTab containsPointX:x y:y ] ifNone:nil.
!

verticalMarginForAddTabButton
    "should be changed to be style specific;
     some (win8) prefer an additional, empty short tab"

    ^ 20 
! !

!NoteBookView methodsFor:'private-buttons'!

buttonLayoutUpdate
    |tabLayout bW h y w x e|

    self hasScrollButtons ifFalse:[^ self].

    (numberOfLines isNil or:[list size == 0]) ifTrue:[
        self transformation:nil.
        self hideButton:buttonPrev.
        self hideButton:buttonNext.
        ^ self
    ].
    tabLayout := list first unselectedLayout.
    bW := self buttonWidth.

    self isHorizontal ifTrue:[
        y := tabLayout top.
        h := tabLayout height.
        e := bW @ h.
        buttonPrev origin:(self tabLeftMargin)@y extent:e.
        buttonNext origin:(self width - self tabRightMargin - bW) @ y extent:e.
    ] ifFalse:[
        x := tabLayout left.
        w := tabLayout width.
        e := w @ bW.
        buttonPrev origin:x@(self tabLeftMargin) extent:e.
        buttonNext origin:x@(self height - self tabRightMargin - bW) extent:e.
    ].
!

buttonWidth
    "returns the button extent x or y dependent on the layout
    "
    ^ 16
!

hideButton:aButton
    aButton controller buttonRelease:1 x:0 y:0.
    aButton unmap.
!

makeVisible:aTab
    "setup transformation to make the selection visible;
     returns true if the transformation has changed otherwise false.
    "
    |layoutLast isHorizontal max maxAllowed oldTrans newTrans nP leftMargin rightMargin|

    (numberOfLines isNil or:[self hasScrollButtons not]) ifTrue:[
        ^ false
    ].

    aTab isNil ifTrue:[
        list size == 0 ifTrue:[
            self hideButton:buttonPrev.
            self hideButton:buttonNext.
            self transformation:nil.
        ].
        ^ false.
    ].
    oldTrans     := self transformation.
    isHorizontal := self isHorizontal.
    layoutLast   := list last unselectedLayout.
    leftMargin   := self tabLeftMargin.
    rightMargin  := self tabRightMargin.

    isHorizontal ifTrue:[
        max        := layoutLast right.
        maxAllowed := self width - rightMargin.

        max > maxAllowed ifTrue:[
            self makeVisibleHorizontal:aTab.
        ] ifFalse:[
            self transformation:nil.
        ].
    ] ifFalse:[
        max        := layoutLast bottom.
        maxAllowed := self height - rightMargin.

        max > maxAllowed ifTrue:[
            self makeVisibleVertical:aTab.
        ] ifFalse:[
            self transformation:nil.
        ].
    ].                
    newTrans := self transformation.

    newTrans isNil ifTrue:[
        self hideButton:buttonPrev.
    ] ifFalse:[
        buttonPrev map.
        nP := newTrans transformPoint:(max @ max).
        max := isHorizontal ifTrue:[nP x] ifFalse:[nP y].
    ].

    max > maxAllowed ifTrue:[
        buttonNext map
    ] ifFalse:[
        self hideButton:buttonNext.
    ].
    ^ oldTrans ~~ newTrans
!

makeVisibleHorizontal:aTab
    "setup transformation to make the horizontal selection visible
    "
    |trans bounds nP xL xR xI minLeft maxRight|

    trans  := self transformation.
    bounds := self computeLayoutForTab:aTab.
    xL     := bounds left.
    xI     := self buttonWidth.

    trans notNil ifTrue:[ 
        nP := trans transformPoint:(xL @ 0).
        xL := nP x 
    ].

    minLeft := self tabLeftMargin.

    xL < (xI + minLeft) ifTrue:[
        list first == aTab ifTrue:[
            trans := nil.
        ] ifFalse:[
            trans := WindowingTransformation scale:nil translation:(((xI + minLeft) - bounds left) @ 0).
        ].
        self transformation:trans.
        ^ self
    ].
    xR       := xL + bounds width.
    maxRight := self width - self tabRightMargin.

    xR > (maxRight - xI) ifTrue:[
        list last == aTab ifTrue:[
            xI := 0.
        ].
        trans := WindowingTransformation scale:nil translation:((maxRight - xI - bounds right) @ 0).
        self transformation:trans.
    ].
!

makeVisibleVertical:aTab
    "setup transformation to make the vertical selection visible
    "
    |trans bounds xL xR pO xI minTop maxBot|

    trans   := self transformation.
    bounds  := self computeLayoutForTab:aTab.
    xL      := bounds top.
    xI      := self buttonWidth.

    trans notNil ifTrue:[
        pO := bounds origin.
        xL := (trans transformPoint:pO) x 
    ].
    minTop := self tabLeftMargin.

    xL < (xI + minTop) ifTrue:[
        list first == aTab ifTrue:[
            trans := nil
        ] ifFalse:[
            trans := WindowingTransformation scale:nil translation:(0@((minTop + xI) - bounds top)).
        ].
        self transformation:trans.
        ^ self
    ].
    xR := xL + bounds height.
    maxBot := self height - self tabRightMargin.

    xR > (maxBot - xI) ifTrue:[
        list last == aTab ifTrue:[
            xI := 0.
        ].
        trans := WindowingTransformation scale:nil translation:(0@ (maxBot - xI - bounds bottom)).
        self transformation:trans.
    ].
!

scrollButtonPressed:whichButton
    |trans idx isNext nIdx pIdx firstTabsLayout|

    list isEmptyOrNil ifTrue:[^ self].

    (whichButton == #scrollRight or:[whichButton == #scrollFullRight]) ifTrue:[
        isNext := true
    ] ifFalse:[
        (whichButton == #scrollLeft or:[whichButton == #scrollFullLeft]) ifFalse:[^ self].
        isNext := false.
    ].
    trans := self transformation.

    firstTabsLayout := list first unselectedLayout.

    self isHorizontal ifTrue:[ 
        |y xN xP|
        y  := firstTabsLayout top.
        xN := buttonNext origin x + 2.
        xP := buttonPrev corner x - 2.   

        trans notNil ifTrue:[
            xN := trans applyInverseToX:xN.
            xP := trans applyInverseToX:xP.
        ].
        nIdx := list findFirst:[:aTab| aTab containsPointX:xN y:y ].
        pIdx := list findFirst:[:aTab| aTab containsPointX:xP y:y ].
    ] ifFalse:[ 
        |x yN yP|
        x  := firstTabsLayout left.
        yN := buttonNext origin y + 2.
        yP := buttonPrev corner y - 2.

        trans notNil ifTrue:[
            yN := trans applyInverseToY:yN.
            yP := trans applyInverseToY:yP.
        ].
        nIdx := list findFirst:[:aTab| aTab containsPointX:x y:yN ].
        pIdx := list findFirst:[:aTab| aTab containsPointX:x y:yP ].
    ].
    idx := isNext ifTrue:[nIdx] ifFalse:[pIdx].

    idx == 0 ifTrue:[
        idx := isNext ifTrue:[list size] ifFalse:[1].
    ] ifFalse:[ |revIdx|
        revIdx := isNext ifTrue:[pIdx] ifFalse:[nIdx].

        revIdx == idx ifTrue:[
            isNext ifTrue:[
                idx := revIdx + 1 min:(list size).
            ] ifFalse:[
                idx := revIdx - 1 max:1.
            ]
        ].
    ].

    (self makeVisible:(list at:idx ifAbsent:nil)) ifTrue:[
        self invalidate.
    ].
! !

!NoteBookView methodsFor:'queries'!

hasTabSelected:aTab
    ^ aTab == self selectedTab
!

isDestroyTabButtonShownFor:aTab
    "returns true if the destroyButton for a tab is shown"

    aTab destroyTabButtonShown ifTrue:[^ true].

    (self showingDestroyButton) ifFalse:[
        ^ false
    ].
    self showDestroyButtonOfInactiveTabs ifTrue:[^ true].
    ^ self selectedTab == aTab
!

isFirstTabInLine:aTab
    "returns true if the tab is the first tab in the line
     used by drawing
    "
    |idx prevTab|

    idx := list identityIndexOf:aTab.
    prevTab := list at:(idx - 1) ifAbsent:nil.

  ^ prevTab isNil or:[prevTab lineNr ~~ aTab lineNr]
!

isLastTabInLine:aTab
    "returns true if the tab is the last tab in the line
     used by drawing
    "
    |index nextTab|

    index   := list identityIndexOf:aTab.
    nextTab := list at:(index + 1) ifAbsent:nil.

  ^ nextTab isNil or:[nextTab lineNr ~~ aTab lineNr]
! !

!NoteBookView methodsFor:'selection'!

isSelectable:anIndex
    "returns true if tab at an index is selectable
    "
    (anIndex notNil and:[anIndex between:1 and:list size]) ifTrue:[
        (list at:anIndex) isEnabled ifTrue:[
            ^ selectConditionBlock isNil ifTrue:[true]
                                        ifFalse:[selectConditionBlock value:anIndex]
        ]
    ].
    ^ false
!

nextSelectableAfter:anIndex wrapAtEnd:wrapAtEnd
    "return the index of the next selectable entry after the index;
     wrap at end if the wrapAtEnd flag is set to true.
    "
    |size idx|

    size := list size.

    size > 1 ifTrue:[
        idx := anIndex + 1.
        idx to:size do:[:i| (self isSelectable:i) ifTrue:[^ i] ].

        wrapAtEnd ifTrue:[
            idx := anIndex - 1.
            1 to:idx do:[:i| (self isSelectable:i) ifTrue:[^ i] ].
        ]
    ].
    ^ 0
!

previousSelectableBefore:anIndex wrapAtBegin:wrapAtBegin
    "return the index of the previous selectable entry before the index;
     wrap at begin if the wrapAtBegin flag is set to true.
    "
    |size idx|

    size := list size.

    size > 1 ifTrue:[
        idx := anIndex - 1.
        idx to:1 by:-1 do:[:i| (self isSelectable:i) ifTrue:[^ i] ].

        wrapAtBegin ifTrue:[
            idx := anIndex + 1.
            size to:idx by:-1 do:[:i| (self isSelectable:i) ifTrue:[^ i] ].
        ]
    ].
    ^ 0
!

selectTab:aTab
    "select aTab - which may be a tab label or a TabItem"

    |idx|

    idx := list findFirst:[:eachNotebookTab| eachNotebookTab label = aTab or:[eachNotebookTab tabItem = aTab]].
    self selection:(idx == 0 ifTrue:nil ifFalse:idx)
!

selectedTab
    "returns the selected tab or nil"

    (selection notNil and:[selection ~~ 0]) ifTrue:[
        ^ list at:selection ifAbsent:nil
    ].
    ^ nil
!

selection
    "return the selection or nil/o; caring for the useIndex setting.
    "
    selection isNil ifTrue:[
        ^ useIndex ifTrue:[0] ifFalse:[nil]
    ].
    ^ useIndex ifTrue:[selection] ifFalse:[self selectedTab labelOrTabItem]

    "Modified: / 06-09-2006 / 17:04:42 / cg"
!

selection:anIndexOrNil
    "change the selection to index or nil. The model and/or actionBlock is notified"

    |oldSel|

    anIndexOrNil ~~ selection ifTrue:[
        oldSel := selection.
        self setSelection:anIndexOrNil.
        oldSel ~~ selection ifTrue:[self selectionChanged]
    ]
!

selectionChanged
    "selection has changed; update the model and evaluate change action"

    |sel|

    sel := self selection.

    model notNil ifTrue:[
        "/ avoid infinite recursion,
        "/ due to selectionChanged -> model value -> model changes again -> selectionChanged...
        "/ ask cg before removing the withoutUdating:do: (had this in expecco)
        "/ model withoutUpdating:self do:[
            model value:sel
        "/ ].
    ].
    action notNil ifTrue:[action value:sel]

    "Modified: / 06-09-2006 / 11:36:34 / cg"
!

setSelection:anIndexOrNil
    "change the selection to anIndexOrNil. No notifications are raised"

    |newSelIndex newSelTab oldSelTab oldBounds newBounds|

    newSelIndex := self listIndexOf:anIndexOrNil.

    (newSelIndex notNil and:[(self isSelectable:newSelIndex) not]) ifTrue:[
        "/ newSelIndex := nil
        ^ self "/ no change
    ].
    selection == newSelIndex ifTrue:[^ self].

    numberOfLines isNil ifTrue:[
        selection := newSelIndex.
        ^ self.
    ].

    oldSelTab := self selectedTab.
    oldSelTab notNil ifTrue:[
        oldBounds := (self computeLayoutForTab:oldSelTab) merge:oldSelTab unselectedLayout.
        oldSelTab layout:(oldSelTab unselectedLayout).
    ].

    selection := newSelIndex.

    newSelTab := self selectedTab.
    newSelTab notNil ifTrue:[
        newBounds := self computeLayoutForTab:newSelTab.
        newSelTab layout:newBounds.
        newBounds := newSelTab selectedLayout merge:newSelTab unselectedLayout.
    ].

    (self makeVisible:newSelTab) ifTrue:[
        self invalidate.
    ] ifFalse:[
        shown ifTrue:[
            oldBounds notNil ifTrue:[
                self invalidate:oldBounds
            ].
            newBounds notNil ifTrue:[
                self invalidate:newBounds
            ]
        ].
    ].
    self validateVisibleCanvas.
!

userSelection:anIndexOrNil
    "user changed the selection to index or nil. The model and/or actionBlock is notified"

    lastUserSelection := anIndexOrNil.
    self selection:anIndexOrNil
!

validateVisibleCanvas
    |tabItem newCanvas selectedTab|

    selectedTab := self selectedTab.

    selectedTab notNil ifTrue:[
        tabItem := selectedTab tabItem.

        tabItem isNil ifTrue:[
            ^ self
        ].
"/        tabItem minorKey notNil ifTrue:[
"/            tabItem majorKey isNil ifTrue:[
"/                tabItem majorKey:(self application class).
"/            ].
"/        ].
        newCanvas := tabItem canvasView.
    ].

    newCanvas == canvas ifTrue:[
        ^ self
    ].

    canvas notNil ifTrue:[
        (canvas objectAttributeAt:#isTabItem) == true ifFalse:[
            ^ self.
        ]
    ].
    self canvas:newCanvas.

    canvasHolder notNil ifTrue:[
        canvasHolder value:newCanvas.
    ].

    "Modified: / 06-09-2006 / 16:02:10 / cg"
! !

!NoteBookView::Tab class methodsFor:'instance creation'!

label:aLabel on:aView
    ^ self basicNew label:aLabel on:aView

    "Modified: / 06-09-2006 / 16:20:45 / cg"
!

labelOrTabItem:aLabel on:aView
    ^ self basicNew labelOrTabItem:aLabel on:aView

    "Created: / 06-09-2006 / 16:54:03 / cg"
! !

!NoteBookView::Tab methodsFor:'accessing'!

accessCharacter
    "returns the access character or nil"

    ^ accessCharacter
!

destroyTabAction
    "if non-nil, this tab has its own private destroyButton.
     This can be used for individual tabs; for an overall tab-destroy capability,
     change the destroyTab: action of my owning tabView"

    tabItem notNil ifTrue:[
        ^ tabItem destroyTabAction
    ].
    ^ nil
!

destroyTabButtonShown
    "returns true, if this tab has its own private destroyButton.
     This can be used for individual tabs; for an overall tab-destroy capability,
     change the destroyTab: action of my owning tabView"

    tabItem notNil ifTrue:[
        ^ tabItem destroyTabAction notNil
    ].
    ^ false
!

foregroundColor
    "returns the foregroundColor or nil"

    tabItem notNil ifTrue:[
        ^ tabItem foregroundColor
    ].
    ^ nil

    "Modified: / 06-09-2006 / 16:00:27 / cg"
!

label
    "returns my original label"

    ^ label
!

label:aLabelOrTabItem on:aView
    "initialize attributes"

    label := aLabelOrTabItem.
    (aLabelOrTabItem isKindOf:TabItem) ifTrue:[
        tabItem := aLabelOrTabItem.
        printableLabel := tabItem rawLabel.
    ] ifFalse:[
        tabItem := nil.
        printableLabel := aLabelOrTabItem.
    ].

    self getPrintableLabelFor:aView.

    "Modified: / 06-09-2006 / 16:45:54 / cg"
!

labelOrTabItem
    "returns my original label"

    ^ label

    "Created: / 06-09-2006 / 16:42:16 / cg"
!

labelOrTabItem:aLabelOrTabItem on:aView
    "initialize attributes"

    label := aLabelOrTabItem.
    (aLabelOrTabItem isKindOf:TabItem) ifTrue:[
          "/ CG: iff the only need for the view in a tabItem is to get the attributes,
          "/ then we should do things here (see below).
          "/ Q to ca: is this correct ???
        tabItem := aLabelOrTabItem.
        aView application notNil ifTrue:[
            tabItem setAttributesWithBuilder:aView application builder.
        ].
        "/ CG: this is the old code, which makes UBSxxx tab-app reuse impossible
        "/ tabItem view:aView.
        printableLabel := tabItem rawLabel.
    ] ifFalse:[
        tabItem := nil.
        printableLabel := aLabelOrTabItem.
    ].

    self getPrintableLabelFor:aView.

    "Created: / 06-09-2006 / 16:53:53 / cg"
!

lastFocusViewId
    "get the id of the view which had the last focus or nil"

    ^ lastFocusViewId
!

lastFocusViewId:anIdOrNil
    "set the id of the view which has the last focus or nil"

    lastFocusViewId := anIdOrNil.
!

lineNr
    "get the line number within the noteBook view"

    ^ lineNr
!

lineNr:aLineNr
    "set the line number within the noteBook view"

    lineNr := aLineNr
!

model
    "returns the model, a TabItem or nil"
"/ self halt.
    ^ tabItem

    "Modified: / 06-09-2006 / 16:01:36 / cg"
!

printableLabel
    "get my printable label"

    ^ printableLabel
!

shortcutKey
    "get the  key to press to select the tab item from the keyboard"

    tabItem notNil ifTrue:[
        ^ tabItem shortcutKey
    ].
    ^ nil

    "Modified: / 06-09-2006 / 16:01:29 / cg"
!

string
    "access the printable string used for steping through a list
     searching for an entry starting with a character."

    ^ printableLabel perform:#string ifNotUnderstood:nil
!

tabItem
    "returns the model, a TabItem or nil"

    ^ tabItem

    "Created: / 06-09-2006 / 16:01:05 / cg"
! !

!NoteBookView::Tab methodsFor:'accessing-dimensions'!

extent
    "returns the extent of the label, the minimum size required by the tab"

    ^ extent
!

layout
    "get the tab's current layout, set by the noteBook view"

    ^ layout
!

layout:aLayout
    "set the tab's current layout"

    layout := aLayout.
!

selectedLayout
    "get the tab's selectedLayout, set by the noteBook view"

    ^ selectedLayout
!

selectedLayout:aLayout
    "set the tab's selectedLayout"

    selectedLayout := aLayout
!

unselectedLayout
    "get the tab's unselectedLayout, set by the noteBook view"

    ^ unselectedLayout
!

unselectedLayout:aLayout
    "set the tab's unselectedLayout"

    unselectedLayout := aLayout.
! !

!NoteBookView::Tab methodsFor:'accessing-mvc'!

addDependent:aGC 
    "make the noteBook be a dependent of the tab model"
    
    tabItem notNil ifTrue:[
        tabItem addDependent:aGC
    ]

    "Modified: / 06-09-2006 / 16:00:20 / cg"
!

removeDependent:aGC 
    "make the noteBook be independent of the tab model"
    
    tabItem notNil ifTrue:[
        tabItem destroyCanvas.
        tabItem removeDependent:aGC.
    ]

    "Modified: / 06-09-2006 / 16:01:17 / cg"
! !

!NoteBookView::Tab methodsFor:'drawing'!

displayOn:aGC inset:inset direction:aDirection textRightInset:aTextRightInset
    "redraw this tab"

    |dispObj lft wdt top hgt x y mustClip|

    mustClip := false.    

    "/ REDRAW LABEL
    (aGC isEnabled and:[self isEnabled]) ifTrue:[
        dispObj := printableLabel.
    ] ifFalse:[
        (dispObj := disabledLabel) isNil ifTrue:[
            (dispObj := printableLabel) isImageOrForm ifTrue:[
                disabledLabel := printableLabel lightened onDevice:(aGC device)
            ]
        ]
    ].

    (aDirection == #top or:[aDirection == #bottom]) ifTrue:[
        "/ horizontal drawing    
        wdt := layout width - inset - inset - aTextRightInset.
        wdt > 4 ifFalse:[^ self].
        lft := layout left  + inset.

        x := (wdt - extent x) // 2.
        x < 0 ifTrue:[
            dispObj isString ifTrue:[
                "/ dispObj := '...'.
                "/ dispObj := (dispObj copyTo:3),'...'.
            ].        
            x := 0.
            mustClip := true.    
        ].
        x := x + lft.
        y := layout top  + ((layout height - inset - extent y - 1) // 2).

        aDirection == #top ifTrue:[ y := y + inset ].

        y := y + (dispObj ascentOn:aGC).
        mustClip ifTrue:[
            aGC clippedTo:layout do:[
                dispObj displayOn:aGC x:x y:y.
            ]        
        ] ifFalse:[        
            dispObj displayOn:aGC x:x y:y.
        ]
    ] ifFalse:[
        "/ vertical drawing    
        hgt := layout height - inset - inset - aTextRightInset.
        hgt > 4 ifFalse:[^ self].
        top := layout top + inset.

        y := (hgt - extent x) // 2.
        y < 0 ifTrue:[
            dispObj := '...'.
            y := 0.
        ].
        y := y + top.
        x := layout left + ((layout width  - inset - extent y +2) // 2).

        aDirection == #left ifTrue:[ x := x + inset ].

        dispObj isImageOrForm ifFalse:[
            dispObj isString ifTrue:[ 
                x := x + aGC font descent.
            ].
            "/ workaround for a bug in display-with-angle,
            "/ iff displayed string is a labelAndIcon.
            "/ (In this case, display is always opaque, and the current
            "/  backgroundPaint color is used to fill the underlying rectangle)
            "/
            aGC backgroundPaint:aGC backgroundColor.
            aGC displayString:dispObj x:x y:y angle:90.
        ] ifTrue:[
            (dispObj rotated:90) displayOn:aGC x:x y:y.
        ].
    ]
! !

!NoteBookView::Tab methodsFor:'private'!

getPrintableLabelFor:aView
    printableLabel notNil ifTrue:[
        printableLabel isImageOrForm ifTrue:[
            printableLabel := printableLabel onDevice:(aView device)
        ] ifFalse:[
            printableLabel isString ifTrue:[
                printableLabel := self resolveDisplayStringFor:printableLabel on:aView.
            ] ifFalse:[
                printableLabel isLabelAndIcon ifTrue:[
                    printableLabel string:(self resolveDisplayStringFor:(printableLabel string) on:aView)
                ]
            ].
        ]
    ] ifFalse:[
        printableLabel := ''
    ].
    extent := (printableLabel widthOn:aView) @ (printableLabel heightOn:aView).

    "Created: / 06-09-2006 / 16:45:31 / cg"
!

resolveDisplayStringFor:aString on:aNoteBook
    |string size rest pos idx|

    accessCharacter := nil.
    string := aNoteBook translateToDisplayLabel:aString.
    size   := string size.
    pos    := 0.

    size == 0 ifTrue:[ ^ string ].

    (tabItem notNil and:[(pos := tabItem accessCharacterPosition) ~~ 0]) ifTrue:[
        pos > size ifTrue:[pos := 0]
    ] ifFalse:[
        idx := 1.

        [((idx := string indexOf:$& startingAt:idx) ~~ 0 and:[idx < size])] whileTrue:[
            rest := string copyFrom:(idx+1).

            idx == 1 ifTrue:[string := rest]
                    ifFalse:[string := (string copyFrom:1 to:(idx-1)), rest].

            (string at:idx) == $& ifTrue:[idx := idx + 1]
                                 ifFalse:[pos := idx].
            size := size - 1.
        ]
    ].

    size ~~ 0 ifTrue:[
        pos ~~ 0 ifTrue:[
            string isText ifFalse:[
                string := Text string:string
            ].
            string emphasisAt:pos add:#underline.
            accessCharacter := (string at:pos) asLowercase
        ].
    ].
    ^ string

    "Modified: / 22-03-2011 / 13:07:56 / cg"
! !

!NoteBookView::Tab methodsFor:'testing'!

containsPointX:x y:y
    "return true, if the point defined by x@y is contained in the tab."

    layout isNil ifTrue:[^ false].
    ^ layout containsPointX:x y:y
!

intersects:aRectangle
    "return true, if the intersection between the argument, aRectangle
     and the tab is not empty"

    layout isNil ifTrue:[^ false].
    ^ layout intersects:aRectangle
!

isEnabled
    "returne true if no model exists or the model is enabled"
    
    ^ (tabItem isNil or:[ tabItem isEnabled ])

    "Modified: / 06-09-2006 / 16:00:35 / cg"
! !

!NoteBookView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

