"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#FractalGeneratorDemo
	instanceVariableNames:'fractalDefinitionView fractalDisplayView modeHolder depthHolder
		showHelperLines'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

DrawView subclass:#FractalDefinitionView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:FractalGeneratorDemo
!

!FractalGeneratorDemo class methodsFor:'documentation'!

documentation
"
    not yet complete fractal drawings generator.

    [author:]
        Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!FractalGeneratorDemo class methodsFor:'image specs'!

infinityIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self infinityIcon inspect
     ImageEditor openOnClass:self andSelector:#infinityIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Demos::FractalGeneratorDemo class infinityIcon'
        ifAbsentPut:[(Depth1Image new) width: 16; height: 8; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((Depth1Image new) width: 16; height: 8; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@<ODIB XFA TIBOC0@@@@a') ; yourself); yourself]
!

invisibleLine
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self infinityIcon inspect
     ImageEditor openOnClass:self andSelector:#infinityIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Demos::FractalGeneratorDemo class infinityIcon'
        ifAbsentPut:[(Depth1Image new) width: 16; height: 8; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((Depth1Image new) width: 16; height: 8; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@<ODIB XFA TIBOC0@@@@a') ; yourself); yourself]
!

invisibleLineIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self invisibleLineIcon inspect
     ImageEditor openOnClass:self andSelector:#invisibleLineIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Demos::FractalGeneratorDemo class invisibleLineIcon'
        ifAbsentPut:[(Depth1Image new) width: 16; height: 8; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((Depth1Image new) width: 16; height: 8; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@A&Y @@@@@@@@@a') ; yourself); yourself]
!

lineIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lineIcon inspect
     ImageEditor openOnClass:self andSelector:#lineIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Demos::FractalGeneratorDemo class lineIcon'
        ifAbsentPut:[(Depth1Image new) width: 16; height: 8; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((Depth1Image new) width: 16; height: 8; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@A?? @@@@@@@@@a') ; yourself); yourself]
!

selectIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self selectIcon inspect
     ImageEditor openOnClass:self andSelector:#selectIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Demos::FractalGeneratorDemo class selectIcon'
        ifAbsentPut:[(Depth1Image new) width: 16; height: 8; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((Depth1Image new) width: 16; height: 8; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C8@N@@8@BP@H @A@@B@@@@@a') ; yourself); yourself]
! !

!FractalGeneratorDemo class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::FractalGeneratorDemo andSelector:#windowSpec
     Demos::FractalGeneratorDemo new openInterface:#windowSpec
     Demos::FractalGeneratorDemo open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Demos::FractalGeneratorDemo'
          #name: 'Demos::FractalGeneratorDemo'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 16 46 875 486)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#ArbitraryComponentSpec
              #name: 'FractalDefinitionView'
              #layout: #(#LayoutFrame 0 0 0 0 0 0.5 -30 1)
              #hasBorder: false
              #component: #FractalDefinitionView
              #postBuildCallback: #fractalDefinitionView:
            )
           #(#ArbitraryComponentSpec
              #name: 'FractalDisplayView'
              #layout: #(#LayoutFrame 0 0.5 0 0 0 1 -30 1)
              #hasBorder: false
              #component: #View
              #postBuildCallback: #fractalDisplayView:
            )
           #(#HorizontalPanelViewSpec
              #name: 'DefinitionButtonPanel'
              #layout: #(#LayoutFrame 0 0 -30 1 0 0.5 0 1)
              #horizontalLayout: #leftMax
              #verticalLayout: #center
              #horizontalSpace: 3
              #verticalSpace: 3
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ToggleSpec
                    #label: 'lineIcon'
                    #name: 'LineButton'
                    #hasCharacterOrientedLabel: false
                    #translateLabel: true
                    #tabable: true
                    #model: #lineModeHolder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 28 28)
                  )
                 #(#ToggleSpec
                    #label: 'invisibleLineIcon'
                    #name: 'InvisibleLineButton'
                    #hasCharacterOrientedLabel: false
                    #translateLabel: true
                    #tabable: true
                    #model: #invisibleLineModeHolder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 28 28)
                  )
                 #(#ToggleSpec
                    #label: 'selectIcon'
                    #name: 'SelectButton'
                    #hasCharacterOrientedLabel: false
                    #translateLabel: true
                    #tabable: true
                    #model: #selectModeHolder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 28 28)
                  )
                 )
               
              )
            )
           #(#HorizontalPanelViewSpec
              #name: 'DrawButtonPanel'
              #layout: #(#LayoutFrame 0 0.5 -30 1 0 1 0 1)
              #horizontalLayout: #fitSpace
              #verticalLayout: #center
              #horizontalSpace: 3
              #verticalSpace: 3
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ToggleSpec
                    #label: '1'
                    #name: 'Button1'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth1Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 29 21)
                  )
                 #(#ToggleSpec
                    #label: '2'
                    #name: 'Button2'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth2Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 21)
                  )
                 #(#ToggleSpec
                    #label: '3'
                    #name: 'Button3'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth3Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 21)
                  )
                 #(#ToggleSpec
                    #label: '4'
                    #name: 'Button4'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth4Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: '5'
                    #name: 'Button5'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth5Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: '6'
                    #name: 'Button6'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth6Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: '7'
                    #name: 'Button7'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth7Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 29 22)
                  )
                 #(#ToggleSpec
                    #label: '8'
                    #name: 'Button8'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth8Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: '9'
                    #name: 'Button9'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth9Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: '10'
                    #name: 'Button10'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth10Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: '11'
                    #name: 'Button11'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth11Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: '12'
                    #name: 'Button12'
                    #translateLabel: true
                    #tabable: true
                    #model: #depth12Holder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 #(#ToggleSpec
                    #label: 'infinityIcon'
                    #name: 'ButtonInf'
                    #hasCharacterOrientedLabel: false
                    #translateLabel: true
                    #tabable: true
                    #model: #depthInfHolder
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #extent: #(#Point 30 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!FractalGeneratorDemo class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated by the CodeGeneratorTool."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Demos::FractalGeneratorDemo andSelector:#mainMenu
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
                #label: 'Help'
                #translateLabel: true
                #startGroup: #right
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
                          #label: 'About this Application'
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
! !

!FractalGeneratorDemo methodsFor:'aspects'!

depth10Holder
    ^ self depthAdaptorFor:10
!

depth11Holder
    ^ self depthAdaptorFor:11
!

depth12Holder
    ^ self depthAdaptorFor:12
!

depth13Holder
    ^ self depthAdaptorFor:13
!

depth1Holder
    ^ self depthAdaptorFor:1
!

depth2Holder
    ^ self depthAdaptorFor:2
!

depth3Holder
    ^ self depthAdaptorFor:3
!

depth4Holder
    ^ self depthAdaptorFor:4
!

depth5Holder
    ^ self depthAdaptorFor:5
!

depth6Holder
    ^ self depthAdaptorFor:6
!

depth7Holder
    ^ self depthAdaptorFor:7
!

depth8Holder
    ^ self depthAdaptorFor:8
!

depth9Holder
    ^ self depthAdaptorFor:9
!

depthAdaptorFor:aNumberOrNil
    ^ (PluggableAdaptor on:self depthHolder)
            getBlock:[:m | m value == aNumberOrNil]
            putBlock:[:m :v | m value:aNumberOrNil]
            updateBlock:[:m :a :p | true]
!

depthHolder
    depthHolder isNil ifTrue:[
        depthHolder := 1 asValue.
        depthHolder addDependent:self.
    ].
    ^ depthHolder
!

depthHolder:something
    |oldValue newValue|

    depthHolder notNil ifTrue:[
        oldValue := depthHolder value.
        depthHolder removeDependent:self.
    ].
    depthHolder := something.
    depthHolder notNil ifTrue:[
        depthHolder addDependent:self.
    ].
    newValue := depthHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:depthHolder.
    ].
!

depthInfHolder
    ^ self depthAdaptorFor:nil
!

invisibleLineModeHolder
    ^ self modeAdaptorFor:#invisibleLine
!

lineModeHolder
    ^ self modeAdaptorFor:#line
!

modeAdaptorFor:aSymbolOrNil
    ^ (PluggableAdaptor on:self modeHolder)
            getBlock:[:m | m value == aSymbolOrNil]
            putBlock:[:m :v | m value:aSymbolOrNil]
            updateBlock:[:m :a :p | true]
!

modeHolder
    modeHolder isNil ifTrue:[
        modeHolder := #line asValue.
        modeHolder addDependent:self.
    ].
    ^ modeHolder
!

selectModeHolder
    ^ self modeAdaptorFor:#select
! !

!FractalGeneratorDemo methodsFor:'change & update'!

depthChanged
    |depth|

    depth := self depthHolder value.
    self redrawFractal.
!

modeChanged
    |mode|

    mode := self modeHolder value.

    mode == #select ifTrue:[
        fractalDefinitionView setupStandardActions.
        ^ self.
    ].
    mode == #line ifTrue:[
        fractalDefinitionView createObjectWithClass:DrawArrow.
        ^ self.
    ].
    mode == #invisibleLine ifTrue:[
        fractalDefinitionView createObjectWithClass:DrawArrow.
        ^ self.
    ].
 self halt.
!

update:something with:aParameter from:changedObject
    changedObject == self modeHolder ifTrue:[
        self modeChanged.
        ^ self
    ].
    changedObject == self depthHolder ifTrue:[
        self depthChanged.
        ^ self
    ].
    changedObject == fractalDefinitionView ifTrue:[
        something == #createObject ifTrue:[
            self createdObject:aParameter.
            ^ self
        ].
        something == #objectLayout ifTrue:[
            self changedObject:aParameter.
            ^ self
        ].
        something == #removeObject ifTrue:[
            self changedObject:aParameter.
            ^ self
        ].
        something == #selection ifTrue:[
            ^ self
        ].
"/ Transcript showCR:something.
        ^ self
    ].
    ^ super update:something with:aParameter from:changedObject
! !

!FractalGeneratorDemo methodsFor:'drawing'!

computeLineVectorsFor:lines relativeTo:overallOrigin withOverallLength:overallLength
    ^ lines collect:[:eachLine |
        |p1 p2 oV len0 theta0 len theta|

        p1 := overallOrigin.                   "/ vector from origin to startPoint
        p2 := eachLine startPoint.
        oV := (p2 x - p1 x) @ (p2 y - p1 y).
        len0 := oV r.
        theta0 := oV theta.

        p1 := eachLine startPoint.             "/ lines vector itself
        p2 := eachLine endPoint.
        oV := (p2 x - p1 x) @ (p2 y - p1 y).
        len := oV r.
        theta := oV theta.
        Array 
            with:len0 with:theta0 
            with:len with:theta 
            with:(len / overallLength).
      ].
!

drawFractal:vectors from:org angle:angle scale:scale depth:depth
    vectors do:[:eachVector |
        |len0 theta0 len theta relativeLength p1 p2|

        len0 := eachVector at:1.
        theta0 := eachVector at:2.
        len := eachVector at:3.
        theta := eachVector at:4.
        relativeLength := eachVector at:5.

        p1 := org + (Point r:len0*scale theta:theta0+angle) rounded.
        p2 := p1 + (Point r:len*scale theta:theta+angle) rounded.

        (depth <= 1 or:[p1 = p2]) ifTrue:[
            fractalDisplayView displayLineFrom:p1 to:p2.
        ] ifFalse:[
            showHelperLines == true ifTrue:[
                fractalDisplayView paint:Color red.
                fractalDisplayView displayLineFrom:p1 to:p2.
                fractalDisplayView paint:Color black.
            ].
            self drawFractal:vectors from:p1 angle:(angle+theta) scale:(scale * relativeLength) depth:depth-1
        ].

        p1 := p2.
    ].
!

redrawFractal
    |lines box w h scale vectors overallStart overallEnd overallLength oV|

    lines := fractalDefinitionView contents.
    box := lines first frame.
    lines do:[:eachLine |
        box := box merge:(eachLine frame).
    ].

    w := box width.
    h := box height.

    scale := (fractalDefinitionView width / w) min:(fractalDefinitionView height / h).
    scale := 1.

    overallStart := lines first startPoint.
    overallEnd := lines last endPoint.
    oV := (overallEnd x - overallStart x) @ (overallEnd y - overallStart y).
    overallLength := oV r.

    vectors := self computeLineVectorsFor:lines relativeTo:lines first startPoint withOverallLength:overallLength.

    fractalDisplayView clear.
    self drawFractal:vectors from:lines first startPoint angle:0 scale:scale depth:(depthHolder value ? 99).
! !

!FractalGeneratorDemo methodsFor:'initialization & release'!

fractalDefinitionView:aView
    fractalDefinitionView := aView scrolledView.
    self setupFractalDefinitionView.
    fractalDefinitionView addDependent:self.
!

fractalDisplayView:aView
    fractalDisplayView := aView scrolledView
!

postBuildWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked during the initialization of your app/dialog,
     after all of the visual components have been built, 
     but BEFORE the top window is made visible.
     Add any app-specific actions here (reading files, setting up values etc.)
     See also #postOpenWith:, which is invoked after opening."

    "/ add any code here ...

    ^ super postBuildWith:aBuilder
!

postOpenWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked right after the applications window has been opened.
     Add any app-specific actions here (starting background processes etc.).
     See also #postBuildWith:, which is invoked before opening."

    "/ add any code here ...

    ^ super postOpenWith:aBuilder
!

setupFractalDefinitionView
    fractalDefinitionView showGrid; alignOn.
    fractalDefinitionView createObjectWithClass:DrawArrow.
! !

!FractalGeneratorDemo methodsFor:'menu actions'!

menuNew
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'new' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''new'' available.'.
!

menuOpen
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'open' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''open'' available.'.
!

menuSave
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'save' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''save'' available.'.
!

menuSaveAs
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'saveAs' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''saveAs'' available.'.
!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
! !

!FractalGeneratorDemo methodsFor:'user actions'!

changedObject:anObject
    self redrawFractal
!

createdObject:anObject
    self redrawFractal
! !

!FractalGeneratorDemo::FractalDefinitionView methodsFor:'grid'!

gridParameters
    "used by defineGrid, and in a separate method for
     easier redefinition in subclasses. 
     Returns the grid parameters in an array of 7 elements,
     which control the appearance of the grid-pattern.
     the elements are:

        bigStepH        number of pixels horizontally between 2 major steps
        bigStepV        number of pixels vertically between 2 major steps
        littleStepH     number of pixels horizontally between 2 minor steps
        littleStepV     number of pixels vertically between 2 minor steps
        gridAlignH      number of pixels for horizontal grid align (pointer snap)
        gridAlignV      number of pixels for vertical grid align (pointer snap)
        docBounds       true, if document boundary should be shown

     if littleStepH/V are nil, only bigSteps are drawn.
    "
    |mmH mmV bigStepH bigStepV arr|

    mmH := self horizontalPixelPerMillimeter.
    mmV := self verticalPixelPerMillimeter.

    "dots every cm"
    bigStepH := mmH * 10.0.
    bigStepV := mmV * 10.0.

    arr := Array new:8.
    arr at:1 put:bigStepH.
    arr at:2 put:bigStepV.
    arr at:3 put:nil.
    arr at:4 put:nil.
    arr at:5 put:bigStepH.
    arr at:6 put:bigStepV.
    arr at:7 put:false.

    ^ arr
! !

!FractalGeneratorDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/FractalGeneratorDemo.st,v 1.1 2002-10-31 23:25:36 cg Exp $'
! !
