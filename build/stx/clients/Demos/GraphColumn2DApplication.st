"{ Encoding: utf8 }"

"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GraphColumn2DApplication
	instanceVariableNames:'stepX'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Graph'
!


!GraphColumn2DApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GraphColumn2DApplication andSelector:#windowSpec
     CodingExamples_GUI::GraphColumn2DApplication new openInterface:#windowSpec
     CodingExamples_GUI::GraphColumn2DApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Demo 2D'
         name: 'Demo 2D'
         min: (Point 10 10)
         max: (Point 1280 1024)
         bounds: (Rectangle 0 0 749 560)
         menu: menu
       )
       component: 
      (SpecCollection
         collection: (
          (DataSetSpec
             name: 'DataSet'
             layout: (LayoutFrame 0 0.0 30 0.0 200 0 -200 1.0)
             level: 1
             model: selectionHolder
             menu: dataSetMenu
             hasHorizontalScrollBar: false
             hasVerticalScrollBar: false
             dataList: listHolder
             has3Dseparators: true
             multipleSelectOk: true
             beDependentOfRows: true
             columns: 
            (Array
               
              (DataSetColumnSpec
                 labelButtonType: Button
                 height: heightOfFirstRow
                 rendererType: rowSelector
                 backgroundSelector: foregroundColor
               ) 
              (DataSetColumnSpec
                 label: 'Shown'
                 labelButtonType: Button
                 height: heightOfFirstRow
                 editorType: CheckToggle
                 rendererType: CheckToggle
                 model: shown
               )
               
              (DataSetColumnSpec
                 label: 'Name'
                 labelButtonType: Button
                 height: heightOfFirstRow
                 model: name
                 canSelect: false
               )
             )
           )
          (MenuPanelSpec
             name: 'menuPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 29 0)
             menu: menuToolbar
           )
          (FramedBoxSpec
             label: 'Settings'
             name: 'SettingsFrame'
             layout: (LayoutFrame 0 0.0 -200 1.0 200 0 0 1.0)
             level: 1
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Number of Rows Y:'
                   name: 'WindowSzLbl'
                   layout: (Point 17 25)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ArrowButtonSpec
                   name: 'WindowSizeMinus'
                   layout: (LayoutFrame 34 0 45 0 56 0 67 0)
                   translateLabel: true
                   model: doChangeWindowSize:
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: '-'
                   direction: left
                 )
                (LabelSpec
                   name: 'WindowSizeLblHolder'
                   layout: (LayoutFrame 58 0 45 0 116 0 67 0)
                   translateLabel: true
                   labelChannel: windowSizeLabel
                 )
                (ArrowButtonSpec
                   name: 'WindowSzPlus'
                   layout: (LayoutFrame 117 0 45 0 139 0 67 0)
                   translateLabel: true
                   model: doChangeWindowSize:
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: '+'
                   direction: right
                 )
                (LabelSpec
                   label: 'Zoom Y:'
                   name: 'ZoomYLbl'
                   layout: (Point 17 82)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (ArrowButtonSpec
                   name: 'ZoomYMinus'
                   layout: (LayoutFrame 34 0 103 0 56 0 125 0)
                   translateLabel: true
                   model: doZoomY:
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: '-'
                   direction: left
                 )
                (LabelSpec
                   name: 'ZoomYLblHolder'
                   layout: (LayoutFrame 58 0 103 0 116 0 125 0)
                   translateLabel: true
                   labelChannel: zoomYLabel
                 )
                (ArrowButtonSpec
                   name: 'ZoomYPlus'
                   layout: (LayoutFrame 117 0 103 0 139 0 125 0)
                   translateLabel: true
                   model: doZoomY:
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: '+'
                   direction: right
                 )
                (CheckBoxSpec
                   label: 'Spread Graphs'
                   name: 'SpreadColumns'
                   layout: (LayoutFrame -4 0 142 0 0 1 164 0)
                   model: spread
                   translateLabel: true
                 )
                )
              
             )
           )
          (GraphColumnView2DSpec
             name: 'Graph2D'
             layout: (LayoutFrame 200 0.0 30 0.0 0 1.0 0 1.0)
             level: 1
             model: listHolder
             showGrid: true
             showDefaultMenu: true
             zoomY: zoomY
             windowSize: windowSize
             gridX: 2
             gridY: 2
             actionBlock: clickOn:atX:deltaY:
             menuAccessBlock: menuFor:atX:deltaY:
           )
          )
        
       )
     )
! !

!GraphColumn2DApplication class methodsFor:'menu specs'!

dataSetMenu
    "this window spec was automatically generated by the ST/X MenuEditor"

    "do not manually edit this - the builder may not be able to
     handle the specification if its corrupted."

    "
     MenuEditor new openOnClass:self andSelector:#dataSetMenu
     (Menu new fromLiteralArrayEncoding:(self dataSetMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #'label:' 'Colors'
                #'enabled:' #hasSelection
                #'submenuChannel:' #colorMenu
            )
             #(#MenuItem
                #'label:' 'Show'
                #'enabled:' #hasSelection
                #'submenu:' 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #'label:' 'Show'
                          #'value:' #'doShow:'
                          #'argument:' #on
                      )
                       #(#MenuItem
                          #'label:' 'Hide'
                          #'value:' #'doShow:'
                          #'argument:' #off
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )
!

menu
    "this window spec was automatically generated by the ST/X MenuEditor"

    "do not manually edit this - the builder may not be able to
     handle the specification if its corrupted."

    "
     MenuEditor new openOnClass:self andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(self menu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #'label:' 'File'
                #'submenu:' 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #'label:' 'Exit'
                          #'value:' #closeRequest
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )
!

menuToolbar
    "this window spec was automatically generated by the ST/X MenuEditor"

    "do not manually edit this - the builder may not be able to
     handle the specification if its corrupted."

    "
     MenuEditor new openOnClass:self andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(self menuToolbar)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #'label:' 'Move Graph Up'
                #'isButton:' true
                #'value:' #'doMoveUpOrDown:'
                #'activeHelpKey:' #editMoveUp
                #'argument:' #up
                #'labelImage:' #(#ResourceRetriever #ToolApplicationModel #upIcon)
            )
             #(#MenuItem
                #'label:' 'Move Graph Down'
                #'isButton:' true
                #'value:' #'doMoveUpOrDown:'
                #'activeHelpKey:' #editMoveDown
                #'argument:' #down
                #'labelImage:' #(#ResourceRetriever #ToolApplicationModel #downIcon)
            )
          ) nil
          nil
      )
! !

!GraphColumn2DApplication methodsFor:'aspects'!

listHolder
    "automatically generated by UIPainter ..."

    |list col x|

    (list := builder bindingAt:#listHolder) isNil ifTrue:[
        builder aspectAt:#listHolder put:(list :=  List new).

        col := GraphColumn name:( 'SIN' ).
        col foregroundColor:(Color black).
        col functionYblock:[:x0 :yData| x := (x0 - 1) * stepX. self sinX:x into:yData ].
        col scaleToHeight:10 maxY:1.0 minY:-1.0.
        col centerGraphMaxY:1.0 minY:-1.0.

        list add:col.

        col := GraphColumn name:( 'COS' ).
        col foregroundColor:(Color red).
        col functionYblock:[:x0 :yData| x := (x0 - 1) * stepX. self cosX:x into:yData ].
        col scaleToHeight:10 maxY:0.5 minY:-0.5.
        col centerGraphMaxY:0.5 minY:-0.5.

        list add:col.

        col := GraphColumn name:( 'SIN * COS' ).
        col foregroundColor:(Color blue).
        col functionYblock:[:x0 :yData| x := (x0 - 1) * stepX. self sinCosX:x into:yData ].
        col scaleToHeight:10 maxY:1.0 minY:-1.0.
        col centerGraphMaxY:1.0 minY:-1.0.

        list add:col.

        self spreadColumns.
    ].
    ^ list
!

selectionHolder
    |holder|

    (holder := builder bindingAt:#selectionHolder) isNil ifTrue:[
        builder aspectAt:#selectionHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder
!

spread
    |holder|

    (holder := builder bindingAt:#spread) isNil ifTrue:[
        builder aspectAt:#spread put:(holder :=  true asValue).
        holder onChangeSend:#spreadColumns to:self
    ].
    ^ holder
!

windowSize
    |holder|

    (holder := builder bindingAt:#windowSize) isNil ifTrue:[
        builder aspectAt:#windowSize put:(holder :=  100 asValue).
        holder onChangeSend:#windowSizeChanged to:self
    ].
    ^ holder
!

windowSizeLabel
    |holder|

    (holder := builder bindingAt:#windowSizeLabel) isNil ifTrue:[
        builder aspectAt:#windowSizeLabel put:( holder := ValueHolder new ).
        holder value:(self windowSize value printString).
    ].
    ^ holder
!

zoomY
    |holder|

    (holder := builder bindingAt:#zoomY) isNil ifTrue:[
        builder aspectAt:#zoomY put:(holder :=  (1.0 / stepX) asValue).
        holder onChangeSend:#zoomYChanged to:self
    ].
    ^ holder
!

zoomYLabel
    |holder|

    (holder := builder bindingAt:#zoomYLabel) isNil ifTrue:[
        builder aspectAt:#zoomYLabel put:( holder := ValueHolder new ).
        holder value:(self zoomY value printString).
    ].
    ^ holder
! !

!GraphColumn2DApplication methodsFor:'change & update'!

windowSizeChanged
    "update the label
    "
    self windowSizeLabel value:(self windowSize value printString).
!

zoomYChanged
    "update the label
    "
    self zoomYLabel value:(self zoomY value printString).
! !

!GraphColumn2DApplication methodsFor:'functions'!

cosX:x0 into:anArray
    |x y|

    x := x0.

    1 to:(anArray size) do:[:i|
        y := x cos.
        anArray at:i put:y.
        x := x + stepX
    ].

  ^ anArray
!

sinCosX:x0 into:anArray
    |x y|

    x := x0.

    1 to:(anArray size) do:[:i|
        y := (x sin) * (x cos).
        anArray at:i put:y.
        x := x + stepX
    ].

  ^ anArray


!

sinX:x0 into:anArray
    |x y|

    x := x0.

    1 to:(anArray size) do:[:i|
        y := x sin.
        anArray at:i put:y.
        x := x + stepX
    ].
  ^ anArray

! !

!GraphColumn2DApplication methodsFor:'graph notifications'!

clickOn:aColumn atX:logX deltaY:deltaY
    "clicked on a graph
    "
    self handleActionFor:aColumn
                  deltaY:deltaY
                      do:nil
!

handleActionFor:aColumn deltaY:deltaY do:aBlock
    "evaluate the block on a column if the distance between the
     column and the click point (deltaY) is less than a number.
    "
    deltaY < 10 ifTrue:[
        self selectionHolder value:(self listHolder identityIndexOf:aColumn).
        aBlock value
    ]
!

menuFor:aColumn atX:logX deltaY:deltaY
    "returns middle button menu for a column or nil
    "
    self handleActionFor:aColumn
                  deltaY:deltaY
                      do:[^ aColumn middleButtonMenu ].
    ^ nil
! !

!GraphColumn2DApplication methodsFor:'initialization'!

initialize
    super initialize.
    stepX  := 0.2.
! !

!GraphColumn2DApplication methodsFor:'menu'!

colorMenu
    ^ ColorMenu colorMenu:true value:#doChangeColor:
! !

!GraphColumn2DApplication methodsFor:'private'!

spreadColumns
    "recompute relative X for each column in the list
    "
    |list dltX relX|

    list := self listHolder.

    list isEmpty ifTrue:[
        ^ self
    ].
    self spread value ifTrue:[
        dltX := 1.0 / (1 + list size).
        relX := 1.0.
        list reverseDo:[:aCol| aCol relativeXaxis:(relX := relX - dltX) ].    
    ] ifFalse:[
        list do:[:aCol|
            aCol relativeXaxis:0.5
        ]
    ]


! !

!GraphColumn2DApplication methodsFor:'queries'!

hasSelection
    ^ self selection size ~~ 0
!

selection
    ^ self selectionHolder value ? #()
! !

!GraphColumn2DApplication methodsFor:'user interactions'!

doChangeColor:aColor
    |list|

    list := self listHolder.
    self selection do:[:i| (list at:i) foregroundColor:aColor ].
!

doChangeWindowSize:how
    |sz|

    sz := self windowSize value.

    how = '+' ifTrue:[
        sz := (sz + 5) min:250.
    ] ifFalse:[
        sz := (sz - 5) max:20.
    ].
    self windowSize value:sz.
!

doMoveUpOrDown:what
    |size index list selection column|

    selection := self selection.
    selection size == 1 ifFalse:[^ self].

    index  := selection at:1.
    list   := self listHolder.
    size   := list size.
    column := list at:index.
    list removeIndex:index.

    what == #up ifTrue:[
        (index := index - 1) == 0 ifTrue:[
            index := size
        ]
    ] ifFalse:[
        (index := index + 1) > size ifTrue:[
            index := 1
        ]
    ].
    list add:column beforeIndex:index.
    self selectionHolder value:index.

    self spread value ifTrue:[
        self spreadColumns
    ]

!

doShow:what
    |list|

    list := self listHolder.
    self selection do:[:i| (list at:i) shown:(what == #on) ].
!

doZoomY:how
    |sz|

    sz := self zoomY value.

    how = '+' ifTrue:[
        sz := (sz + 0.4) min:20.0.
    ] ifFalse:[
        sz := (sz - 0.4) max:0.2.
    ].
    self zoomY value:sz.
! !

!GraphColumn2DApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GraphColumn2DApplication.st,v 1.2 2015-10-04 10:30:28 cg Exp $'
! !

