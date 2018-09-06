"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#PenDemo2
	instanceVariableNames:'bic drawView actionHolder listOfActions listOfActionSelectors
		listOfActionComments infoLabelHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!PenDemo2 class methodsFor:'documentation'!

documentation
"
    rewritten little demo showing pen turtle graphics.
    The Pen class is described in Smalltalk-80, the language & implementation.
    Also, the use of buttons and panels is demonstrated somewhat.

    [author:]
        Claus Gittinger

    [see also:]
        PenDemo CommanderDemo Commander Pen
        GraphicsContext

    [start with:]
        PenDemo open
"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Demos::PenDemo2 open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!PenDemo2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::PenDemo2 andSelector:#windowSpec
     Demos::PenDemo2 new openInterface:#windowSpec
     Demos::PenDemo2 open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Demos::PenDemo2'
         name: 'Demos::PenDemo2'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 694 675)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar1'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 36 0)
             menu: toolbarMenu
             textDefault: true
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 36 0 -4 1 66 0)
             horizontalLayout: rightFit
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ComboListSpec
                   name: 'ComboList1'
                   model: actionHolder
                   comboList: listOfActions
                   useIndex: true
                   extent: (Point 563 20)
                 )
                (ActionButtonSpec
                   label: 'GO'
                   name: 'Button1'
                   translateLabel: true
                   model: doAction
                   extent: (Point 125 22)
                 )
                )
              
             )
           )
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 1 0 66 0 0 1 -26 1)
             level: 1
             postBuildCallback: postBuildDrawView:
           )
          (ViewSpec
             name: 'InfoBox'
             layout: (LayoutFrame 0 0 -26 1 0 1 0 1)
             level: 1
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'InfoLabel'
                   name: 'Label2'
                   layout: (LayoutFrame 0 0 -26 1 -1 1 0 1)
                   level: -1
                   translateLabel: true
                   labelChannel: infoLabelHolder
                   adjust: left
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!PenDemo2 class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Demos::PenDemo2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Demos::PenDemo2 mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
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
!

toolbarMenu
    "This resource specification was automatically generated by the CodeGeneratorTool."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Demos::PenDemo2 andSelector:#toolbarMenu
    "

    <resource: #menu>

    ^ #(Menu ((MenuItem label: 'Reload' itemValue: menuReload isButton: true labelImage: (ResourceRetriever ToolbarIconLibrary reload24x24Icon))) nil nil)
! !

!PenDemo2 methodsFor:'actions'!

actionHolderChanged
    |index sel info|

    index := actionHolder value.    
    sel := listOfActionSelectors at:index.
    info := listOfActionComments at:index.
    self infoLabelHolder value:info.
!

doAction
    |index sel|

    index := actionHolder value. 
    index == 0 ifTrue:[^ self].
    
    sel := listOfActionSelectors at:index.

    self perform:sel
! !

!PenDemo2 methodsFor:'aspects'!

actionHolder
    <resource: #uiAspect>

    actionHolder isNil ifTrue:[
        actionHolder := 0 asValue.
        actionHolder onChangeSend:#actionHolderChanged to:self.
    ].
    ^ actionHolder.
!

infoLabelHolder
    <resource: #uiAspect>

    infoLabelHolder isNil ifTrue:[
        infoLabelHolder := nil asValue.
    ].
    ^ infoLabelHolder.
!

listOfActions
    <resource: #uiAspect>

    |order|
    
    listOfActions isNil ifTrue:[
        listOfActions := List new.
        listOfActionSelectors := OrderedCollection new.  
        listOfActionComments := OrderedCollection new.  
        self class selectorsAndMethodsDo:[:sel :m |
            |a label comment|
            
            (m hasAnnotation:#action:info:) ifTrue:[
                a := m annotationAt:#action:info:.
                label := a argumentAt:1.
                comment := a argumentAt:2.
                listOfActions add:label.
                listOfActionSelectors add:sel.
                listOfActionComments add:comment.
            ].    
        ].
        order := (1 to:listOfActions size) asOrderedCollection.
        listOfActions sortWith:order.
        listOfActionSelectors := order collect:[:idx | listOfActionSelectors at:idx].
        listOfActionComments := order collect:[:idx | listOfActionComments at:idx].
    ].
    ^ listOfActions.
! !

!PenDemo2 methodsFor:'geometric patterns'!

cCurve
    <action: 'C-Curve' info: 'Draw a C-Curve'>
    
    "draw a c-pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. 
            bic up.
            bic west. bic go:(drawView width // 5).
            bic north. bic go:(drawView height // 5).
            bic down.
            bic east. bic cCurve:10 side:8
        ]
    ].

    Transcript showCR:'cCurve: time to draw: ' , t printString , ' ms'
!

dragon
    <action: 'Dragon-Curve' info: 'Draw a Dragon-Curve'>

    "draw a dragon pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. 
            bic up; north; go:100; down.
            bic east.
            bic dragon:10
        ]
    ].

    Transcript showCR:'dragon: time to draw: ' , t printString , ' ms'
!

fastSpiralAnimation
    <action: 'Spiral Animation (Fast)' info: 'Fast-Spiral Animation at full Speed'>

    "draw multiple spirals in myself - full speed"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            200 to:359 by:2 do:[:angle |
                self spiral:angle.
            ].
            359 to:200 by:-2 do:[:angle |
                self spiral:angle.
            ].
        ]
    ].

    Transcript showCR:'fastSpiral: time to draw: ' , t printString , ' ms'

    "Modified: 30.8.1996 / 20:35:49 / cg"
    "Created: 17.1.1997 / 17:04:56 / cg"
!

hilbert
    <action: 'Hilbert-Curve' info: 'Draw a Hilbert-Curve'>

    "draw a hilbert pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home.
            bic up.
            bic west. bic go:(drawView width // 5).
            bic north. bic go:(drawView height // 5).
            bic down.
            bic east. bic hilbert:5 side:8
        ]
    ].

    Transcript showCR:'hilbert: time to draw: ' , t printString , ' ms'
!

koch
    <action: 'Koch-Curve' info: 'Draw a Koch-Curve'>

    "draw a koch pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home.
            bic up.
            bic west. bic go:(drawView width // 4).
            bic north. bic go:(drawView height // 5).
            bic down.
            bic east.
            bic koch:4 side:2.
            bic turn:120.
            bic koch:4 side:2.
            bic turn:120.
            bic koch:4 side:2
        ]
    ].

    Transcript showCR:'koch: time to draw: ' , t printString , ' ms'
!

mandala
    <action: 'Mandala-Curve' info: 'Draw a Mandala-Curve'>

    "draw a mandala in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. bic east. bic mandala:10 radius:200
        ]
    ].

    Transcript showCR:'mandala: time to draw: ' , t printString , ' ms'
!

mandala2
    <action: 'Mandala2-Curve' info: 'Draw a Mandala-Curve'>

    "draw a mandala in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. bic east. bic mandala:20 radius:200
        ]
    ].

    Transcript showCR:'mandala: time to draw: ' , t printString , ' ms'
!

pythagoras
    <action: 'Pythagoras-Curve' info: 'Draw a Pythagoras-Curve'>

    "draw a pythagoras pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home.
            bic south; up; go:200.
            bic west; go:50.
            bic north; down.
            bic pythagoras:12 side:100
        ]
    ].

    Transcript showCR:'pythagoras: time to draw: ' , t printString , ' ms'

    "Modified: / 3.8.1998 / 16:58:21 / cg"
!

pythagorasBuffered
    "draw a pythagoras pattern in myself,
     using a buffering pen (i.e. first record all drawing,
     then draw it all).
     This is an experiment, added since I wondered where the time goes;
     Now, I know, that most is spent in the X-lib/Xserver)"

    self drawAction:[
        |bic|

        bic := RecordingPen in:drawView.

        bic clear.
        bic home.
        bic south; up; go:200.
        bic west; go:50.
        bic north; down.
        bic pythagoras:12 side:100.

        bic replay.
    ]

    "Modified: / 3.8.1998 / 16:58:49 / cg"
    "Created: / 3.8.1998 / 16:59:01 / cg"
!

rosetta
    <action: 'Rosatta-Curve' info: 'Draw a Rosatta-Curve'>

    "draw a c-pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. 
            10 timesRepeat:[
                bic turn:36.
                5 timesRepeat:[
                    bic go:54.
                    bic turn:72
                ]
            ]    
        ]
    ].

    Transcript showCR:'rosetta: time to draw: ' , t printString , ' ms'
!

spiral:angle
    "draw a spiral pattern in myself"

    self drawAction:[
        bic clear.
        bic home. bic east. bic spiral:400 angle:angle
    ]
!

spiralAnimation
    <action: 'Spiral-Animation (Slow)' info: 'Draw a Spiral-Animation with Delay'>

    "draw multiple spirals in myself"

    self drawAction:[
        bic clear.
        200 to:359 by:2 do:[:angle |
            self spiral:angle.
            Delay waitForSeconds:0.05
        ].
        359 to:200 by:-2 do:[:angle |
            self spiral:angle.
            Delay waitForSeconds:0.05
        ].
    ]

    "Modified: 17.1.1997 / 17:04:45 / cg"
!

spiralAnimation:angle count:count
    "draw multiple spirals in myself"

    self drawAction:[
        bic clear.
        count timesRepeat:[
            drawView paint:(Color black).
            bic home. bic east. bic spiral:400 angle:angle.
            drawView paint:(Color white).
            bic home. bic east. bic spiral:400 angle:angle
        ].
        drawView paint:(Color black)
    ]
!

spiralGreying:angle
    "draw multiple spirals in myself"

    self drawAction:[
        bic clear.
        0 to:100 by:10 do:[:grey |
            drawView paint:(Color grey:grey).
            bic home. bic east. bic spiral:400 angle:angle
        ].
        drawView paint:(Color black)
    ]
! !

!PenDemo2 methodsFor:'helpers'!

drawAction:aBlock
    bic clear.
    bic home.
    drawView topView withExecuteCursorDo:aBlock.
    bic destForm ~~ drawView ifTrue:[
        self refreshMyself
    ].
! !

!PenDemo2 methodsFor:'initialization & release'!

postBuildDrawView:aView
    <resource: #uiCallback>

    drawView := aView
!

postOpenWith:aBuilder
    bic := Pen in:drawView.
    ^ super postOpenWith:aBuilder
! !

!PenDemo2 methodsFor:'menu actions'!

openAboutThisApplication
    "This method was generated by the Browser/CodeGeneratorTool.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser/CodeGeneratorTool.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    self openDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ self openDocumentationFile:'help/<MyApplication>/TOP.html'.
! !

!PenDemo2 methodsFor:'private queries'!

hasUnsavedChanges
    "Return true, if any unsaved changes are present 
     (i.e. the contents needs to be saved or else will be lost)"

    "/ add real code as required (or remove the halt and always return false)...
    "/ self halt:'check this code'.
    ^ false.
! !

!PenDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Demos__PenDemo2.st,v 1.1 2016-01-04 01:56:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/Demos__PenDemo2.st,v 1.1 2016-01-04 01:56:29 cg Exp $'
! !

