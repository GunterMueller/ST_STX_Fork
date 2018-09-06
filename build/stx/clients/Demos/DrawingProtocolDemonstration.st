"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#DrawingProtocolDemonstration
	instanceVariableNames:'selectedOperation selectedOperationChanged executeSelectedCode
		codeHolder selectedOperationPathHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Tutorial'
!

Object subclass:#SingleDrawDemo
	instanceVariableNames:'view gc'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration
!

Object subclass:#Examples
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#ExponentialGrow
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Examples
!

Object subclass:#Drawing
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Colors
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Drawing
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#GeometricFigures
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Drawing
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Images
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Drawing
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Lines
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Drawing
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Pens
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Drawing
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Text
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Drawing
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Transformations
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Drawing
!

Object subclass:#View
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Background
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::View
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Border
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::View
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Level
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::View
!

Object subclass:#Widgets
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration
!

DrawingProtocolDemonstration::SingleDrawDemo subclass:#Button
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DrawingProtocolDemonstration::Widgets
!

!DrawingProtocolDemonstration class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    DrawingProtocolDemonstration open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
!

history
    "Created: / 28.2.2003 / 14:49:10 / cg"
! !

!DrawingProtocolDemonstration class methodsFor:'help'!

aboutThisApplicationText
    ^ (super aboutThisApplicationText 
        , '\\Tutorial on Draw Operations.'
        , '\Contains code fragments to demonstrate various low level drawing' 
        , '\widget and window APIs.'
        , '\\Select a demo and press execute.'
        , '\Change the code in the textview (and accept) for experiments') withCRs

    "Modified: / 01-08-2013 / 14:46:41 / cg"
! !

!DrawingProtocolDemonstration class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::DrawingProtocolDemonstration andSelector:#windowSpec
     CodingExamples_GUI::DrawingProtocolDemonstration new openInterface:#windowSpec
     CodingExamples_GUI::DrawingProtocolDemonstration open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Draw Protocol Demo'
         name: 'Draw Protocol Demo'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 604 469)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'VariableHorizontalPanel1'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box2'
                         component: 
                        (SpecCollection
                           collection: (
                            (SelectionInTreeViewSpec
                               name: 'operationTreeList'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
                               model: selectedOperation
                               menu: treeMenu
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               showRoot: false
                               showDirectoryIndicator: true
                               valueChangeSelector: selectedOperationChanged
                               doubleClickSelector: executeSelectedCode
                               hierarchicalList: operationTree
                               highlightMode: line
                             )
                            (LabelSpec
                               name: 'Label1'
                               layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
                               level: -1
                               translateLabel: true
                               labelChannel: selectedOperationPathHolder
                             )
                            )
                          
                         )
                       )
                      (ViewSpec
                         name: 'Box1'
                         component: 
                        (SpecCollection
                           collection: (
                            (TextEditorSpec
                               name: 'TextEditor1'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
                               model: codeHolder
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               acceptCallBack: codeAccepted:
                               hasKeyboardFocusInitially: false
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel1'
                               layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
                               horizontalLayout: center
                               verticalLayout: center
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Execute'
                                     name: 'ExecuteButton'
                                     translateLabel: true
                                     model: executeSelectedCode
                                     extent: (Point 125 22)
                                   )
                                  )
                                
                               )
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   handles: (Any 0.354305 1.0)
                 )
                (FramedBoxSpec
                   label: 'Result'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'paintView'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         level: -1
                         backgroundColor: (Color 100.0 100.0 100.0)
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.441365 1.0)
           )
          )
        
       )
     )
! !

!DrawingProtocolDemonstration class methodsFor:'list specs'!

addTreeFrom:aClass to:aTreeItem
    (aClass privateClasses asOrderedCollection copy sort:[:a :b | a nameWithoutPrefix < b nameWithoutPrefix])
    do:[:eachClass |
        |childItem|

       (eachClass ~~ SingleDrawDemo) ifTrue:[
            childItem := TreeItem new.
            childItem readChildren:true.
            childItem name:(eachClass nameWithoutPrefix).
            childItem contents:eachClass.
            aTreeItem add:childItem.
            self addTreeFrom:eachClass to:childItem.
       ].
    ].

    (aClass isSubclassOf:SingleDrawDemo) ifTrue:[
        (aClass methodDictionary keys asOrderedCollection copy sort
        collect:[:sel | sel -> (aClass compiledMethodAt:sel)])
        do:[:selectorMethodPair |
            |selector childItem|

            selector := selectorMethodPair key.
            childItem := TreeItem new.
            childItem name:selector.
            childItem readChildren:true.
            childItem contents:(Array with:aClass name with:selector).
            aTreeItem add:childItem.
        ]
    ].
!

operationTree
    |root|

    root := TreeItem new.
    root name:'Root'.
    root hide.true.
    "/ root readChildren.true.

    self addTreeFrom:self to:root.
    ^ root.
! !

!DrawingProtocolDemonstration class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::DrawingProtocolDemonstration andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::DrawingProtocolDemonstration mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'File'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Update Tree'
                  #itemValue: #updateOperationTree
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'Exit'
                  #itemValue: #closeRequest
                  #translateLabel: true
                )
               )
              nil
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
                  #itemValue: #openDocumentation
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'About this Application'
                  #itemValue: #openAboutThisApplication
                  #translateLabel: true
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

treeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::DrawingProtocolDemonstration andSelector:#treeMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::DrawingProtocolDemonstration treeMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: addItemEnabledHolder
            label: 'Add Category...'
            itemValue: addCategoryItem
            translateLabel: true
          )
         (MenuItem
            enabled: addItemEnabledHolder
            label: 'Add Example...'
            itemValue: addExampleItem
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Browse'
            itemValue: browseExampleClass
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            itemValue: updateOperationTree
            label: 'Update'
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!DrawingProtocolDemonstration methodsFor:'actions'!

addItem
    |item name childItem|

    name := Dialog request:'Name:'.
    name isEmptyOrNil ifTrue:[^ self].

    item := self selectedOperation value.
    item collapse.
        
    childItem := TreeItem new.
    childItem readChildren:true.
    childItem name:name.
    item add:childItem.

    ^ childItem
!

codeAccepted:newCode
    |mthd cls sel code|

    mthd := self selectedOperationsMethod.
    cls := mthd mclass.
    sel := mthd selector.

    code := sel , (Character cr asString) , newCode asStringCollection asString string.
    cls compile:code classified:(mthd category).
!

selectedOperationChanged
    |code key mclass op|

    key := self selectedOperationsMethod.
    key notNil ifTrue:[
        key isMethod ifTrue:[
            (mclass := key mclass) isNil ifTrue:[
                self information:'Please update the tree - found an obsolete method.'.
            ] ifFalse:[
                self selectedOperationPathHolder value:(mclass name copyFrom:self class name size + 1 + 2).
                code := self codeFor:key.
            ].
        ]
    ] ifFalse:[
        "/ expand
        op := selectedOperation value.
        op notNil ifTrue:[
            op tree expand:op
        ].
    ].
    self codeHolder value:code.
! !

!DrawingProtocolDemonstration methodsFor:'aspects'!

addItemEnabled
    |sel|

    sel := self selectedOperation value.
    ^ sel notNil and:[ self selectedOperationsMethod isNil ].
!

addItemEnabledHolder
    ^ [ self addItemEnabled].
!

codeHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    codeHolder isNil ifTrue:[
        codeHolder := '' asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       codeHolder addDependent:self.
"/       codeHolder onChangeSend:#codeHolderChanged to:self.
    ].
    ^ codeHolder.
!

hasSelectionHolder
    ^ BlockValue
        with:[:m | m notNil]
        argument:self selectedOperation.
!

selectedOperationPathHolder
    selectedOperationPathHolder isNil ifTrue:[
        selectedOperationPathHolder := '' asValue.
    ].
    ^ selectedOperationPathHolder.
! !

!DrawingProtocolDemonstration methodsFor:'code'!

codeFor:method
    |source|

    method isNil ifTrue:[^ nil].

    source := SyntaxHighlighter formatMethod:method source in:(method mclass).
    ^ source asCollectionOfLines copyFrom:2
! !

!DrawingProtocolDemonstration methodsFor:'initialize'!

initialize
    super initialize.

    Pen isNil ifTrue:[
        Smalltalk
            recursiveInstallAutoloadedClassesFrom:(Smalltalk packageDirectoryForPackageId:'stx:goodies')
            rememberIn:(Set new)
            maxLevels:1
            noAutoload:false
            packageTop:nil
            showSplashInLevels:0.
    ].
! !

!DrawingProtocolDemonstration methodsFor:'menu actions'!

addCategoryItem
    |name item childItem class subClass|

"/    childItem := self addItem.
"/
"/    item := childItem parent.
"/    class := item contents.
"/    subClass := 
"/        SingleDrawDemo
"/            subclass:childItem name asSymbol
"/            instanceVariableNames:''
"/            classVariableNames:''
"/            poolDictionaries:''
"/            privateIn:class.
"/
"/    childItem contents:subClass.
"/    self selectedOperation value:childItem.
"/    item expand.

    name := Dialog request:'Name:'.
    name isEmptyOrNil ifTrue:[^ self].

    item := self selectedOperation value.
    class := item contents.
    subClass := 
        SingleDrawDemo
            subclass:name asSymbol
            instanceVariableNames:''
            classVariableNames:''
            poolDictionaries:''
            privateIn:class.
    self updateOperationTree
!

addExampleItem
    |name item childItem class method selector|

"/    childItem := self addItem.
"/
"/    item := childItem parent.
"/    class := item contents.
"/    selector := childItem name asSymbol.
"/    method := Compiler
"/                compile:(selector , '\"add code below and accept"' withCRs)
"/                forClass:class
"/                install:true.
"/
"/    childItem contents:(Array with:class name with:selector).
"/    item expand.
"/    self selectedOperation value:childItem.

    name := Dialog request:'Name:'.
    name isEmptyOrNil ifTrue:[^ self].

    item := self selectedOperation value.
    class := item contents.
    selector := name asSymbol.
    method := Compiler
                compile:(selector , '\"add code below and accept"' withCRs)
                forClass:class
                install:true.
    self updateOperationTree
!

browseExampleClass
    |mthd item class|

    mthd := self selectedOperationsMethod.
    mthd notNil ifTrue:[
        UserPreferences current systemBrowserClass
            openInClass:mthd mclass selector:mthd selector.
        ^ self.
    ].

    item := self selectedOperation value.
    class := item contents.
    class browse
!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'programming/viewintro.html'.
!

updateOperationTree
    |previousSelection item previousSelectionPath newRoot wasExpanded|

    previousSelection := self selectedOperation value.
    wasExpanded := previousSelection notNil and:[previousSelection isExpanded].

    previousSelectionPath := OrderedCollection new.
    item := previousSelection.
    [item notNil] whileTrue:[
        previousSelectionPath addFirst:item name.
        item := item parent.
    ].

    (builder componentAt:#operationTreeList)
        root:(newRoot := self class operationTree).

    previousSelectionPath notEmpty ifTrue:[
        item := newRoot.
        previousSelectionPath from:2 do:[:childName |
            |childItem|

            childItem := item detectChild:[:child | child name = childName].
            childItem isNil ifTrue:[
                self selectedOperation value:item.
                ^ self.
            ].
            item := childItem
        ].
        self selectedOperation value:item.
        wasExpanded ifTrue:[ item tree expand:item ].
    ].
! !

!DrawingProtocolDemonstration methodsFor:'misc'!

executeSelectedCode
    |executor paintView stub|

    paintView := builder componentAt:#paintView.
    paintView subViews copy do:[:sub |
        sub destroy.
    ].
    paintView viewBackground:Color white.
    paintView clear.
    paintView windowGroup processExposeEvents.

    paintView paint:Color black.
    paintView lineWidth:0.
    paintView lineStyle:#solid.
    paintView transformation:nil.

    executor := self selectedOperationsMethod.
    executor isNil ifTrue:[
        Dialog warn:'No code for this example (yet)'.
        ^ self.
    ].

    stub := executor mclass new.
    stub view:paintView.
    stub gc:paintView.
    self withWaitCursorDo:[
        stub perform:(executor selector).
    ].
!

selectedCategoryClass
    |item method classNameAndSelector class selector|

    item := self selectedOperation value.
    item notNil ifTrue:[
        classNameAndSelector := item contents.
        classNameAndSelector isArray ifTrue:[
            class := Smalltalk at:classNameAndSelector first.
            selector := classNameAndSelector second.
            method := class compiledMethodAt:selector.
        ]
    ].
    ^ method
!

selectedOperation
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    selectedOperation isNil ifTrue:[
        selectedOperation := ValueHolder new.
    ].
    ^ selectedOperation.
!

selectedOperationsMethod
    |item method classNameAndSelector class selector|

    item := self selectedOperation value.
    item notNil ifTrue:[
        classNameAndSelector := item contents.
        classNameAndSelector isArray ifTrue:[
            class := Smalltalk at:classNameAndSelector first.
            selector := classNameAndSelector second.
            method := class compiledMethodAt:selector.
        ]
    ].
    ^ method
! !

!DrawingProtocolDemonstration::SingleDrawDemo methodsFor:'accessing'!

gc
    "return the value of the instance variable 'gc' (automatically generated)"

    ^ gc
!

gc:something
    "set the value of the instance variable 'gc' (automatically generated)"

    gc := something.
!

view
    "return the value of the instance variable 'view' (automatically generated)"

    ^ view
!

view:something
    "set the value of the instance variable 'view' (automatically generated)"

    view := something.
! !

!DrawingProtocolDemonstration::Examples::ExponentialGrow methodsFor:'code'!

peopleGrow
|countLabel nextGenButton startButton
 einwohner geburt zeichnen|

countLabel := Label label:'Einwohner: ' in:view. countLabel origin:400@10 extent:200@30; adjust:#left; realize.
nextGenButton := Button label:'Nächste Generation' in:view. nextGenButton origin:400@40; realize.
startButton := Button label:'Reset' in:view. startButton origin:400@70; realize.

geburt := 
    [|p| 
        p := Point x:(0 to:299) atRandom
                   y:(0 to:299) atRandom.
        einwohner add:p
    ].
zeichnen := 
    [
        countLabel label:('Einwohner: ',einwohner size asString).
        view clear.
        einwohner do:[:p |
            view fillRectangleOrigin:p extent:2@2
        ].
    ].
einwohner := OrderedCollection new.
geburt value.
view viewBackground:Color white.
view paint:Color red.

startButton action:[
    einwohner := Set new.
    geburt value.
    zeichnen value.
].

nextGenButton action:[
    view windowGroup withWaitCursorDo:[
        einwohner size timesRepeat:[
            geburt value
        ].
        zeichnen value.
    ].
].
! !

!DrawingProtocolDemonstration::Drawing::Colors methodsFor:'code'!

foreground1
"painting rectangles with a solid color"

view paint:(Color red).
view fillRectangleX:10 y:10 width:50 height:50.

view paint:(Color green).
view fillRectangle:(80@80 corner:110@110)
!

foreground2
"painting with multiple solid colors"

view paint:(Color green).
view fillCircleX:50 y:50 radius:10.

view paint:(Color green darkened).
view fillCircle:(100 @ 150) radius:20.
!

foreground3
"painting with multiple solid colors"

view paint:(Color green).
view displayLineFromX:10 y:50 toX:250 y:50.

view paint:(Color blue).
view displayLineFromX:50 y:10 toX:50 y:100.

view paint:(Color red).
view displayString:'Hello World (descenders: gaga)' x:50 y:50.
!

foreground4
"painting with a bitmap image"

|image|

image := Image fromFile:'banner8.xpm'.
image := image magnifiedTo:75@100.
view paint:image.

view displayLineFromX:10 y:50 toX:250 y:50.
view displayLineFromX:50 y:10 toX:50 y:100.

view displayString:'Hello World (descenders: gaga)' x:50 y:50.

view fillCircle:50@100 radius:20.
view fillRectangle:(80@120 extent:(40@20)).
! !

!DrawingProtocolDemonstration::Drawing::GeometricFigures methodsFor:'code'!

arrow1
|anArrow|

anArrow := Arrow from:10@10 to:100@120.

anArrow displayOn:view.
!

arrow2
|anArrow|

anArrow := Arrow from:10@10 to:100@120.

anArrow displayFilledOn:view.
!

filledPolygon1
|controlPoints aPolygon|

"/
"/ the grid
"/
view paint:Color red.
view displayLineFromX:20 y:5 toX:20 y:250.
view displayLineFromX:100 y:5 toX:100 y:250.
view displayLineFromX:5 y:20 toX:150 y:20.
view displayLineFromX:5 y:120 toX:150 y:120.
view displayLineFromX:5 y:220 toX:150 y:220.

"/
"/ the actual polygon code
"/
controlPoints := OrderedCollection new.
controlPoints add:(20 @ 20).
controlPoints add:(100 @ 120).
controlPoints add:(20 @ 220).

aPolygon := Polygon vertices:controlPoints.

view paint:Color green.
aPolygon displayFilledOn:view.
!

filledRectangle1
|aRectangle|

aRectangle := Rectangle left:10 top:20 width:50 height:100.

view fillRectangle:aRectangle.
!

filledRectangle2
view fillRectangleX:10 y:10 width:100 height:50.
!

filledRectangle3
view fillRectangleOrigin:(10 @ 20) extent:(100 @ 50).
!

polygon1
|controlPoints aPolygon|

"/
"/ the grid
"/
view paint:Color red.
view displayLineFromX:20 y:5 toX:20 y:250.
view displayLineFromX:100 y:5 toX:100 y:250.
view displayLineFromX:5 y:20 toX:150 y:20.
view displayLineFromX:5 y:120 toX:150 y:120.
view displayLineFromX:5 y:220 toX:150 y:220.

"/
"/ the actual polygon code
"/
controlPoints := OrderedCollection new.
controlPoints add:(20 @ 20).
controlPoints add:(100 @ 120).
controlPoints add:(20 @ 220).

aPolygon := Polygon vertices:controlPoints.

view paint:Color black.
aPolygon displayOn:view.
!

rectangle1
|aRectangle|

aRectangle := Rectangle left:10 top:20 width:50 height:100.

view displayRectangle:aRectangle.
!

rectangle2
view displayRectangleX:10 y:10 width:100 height:50.
!

rectangle3
view displayRectangleOrigin:(10 @ 20) extent:(100 @ 50).
!

rectangle4
view displayRectangleOrigin:(10 @ 20) corner:(100 @ 150).
!

spline1
|controlPoints aSpline|

"/
"/ the grid
"/
view paint:Color red.
view displayLineFromX:20 y:5 toX:20 y:250.
view displayLineFromX:100 y:5 toX:100 y:250.
view displayLineFromX:5 y:20 toX:150 y:20.
view displayLineFromX:5 y:120 toX:150 y:120.
view displayLineFromX:5 y:220 toX:150 y:220.
view paint:Color black.

"/
"/ the actual spline code
"/
controlPoints := OrderedCollection new.
controlPoints add:(20 @ 20).
controlPoints add:(100 @ 120).
controlPoints add:(20 @ 220).

aSpline := Spline controlPoints:controlPoints.

aSpline displayOn:view.
! !

!DrawingProtocolDemonstration::Drawing::Images methodsFor:'code'!

bitmap1
|form|

view paint:Color red.
view displayLineFromX:10 y:5 toX:10 y:150.
view displayLineFromX:5 y:10 toX:150 y:10.
view paint:Color black.

"/
"/ construct a bitmap containing a cross
"/
form := Form width:100 height:100.
form clear.

form displayLineFromX:0 y:0 toX:99 y:99.
form displayLineFromX:99 y:0 toX:0 y:99.
form displayLineFromX:0 y:0 toX:99 y:0.
form displayLineFromX:99 y:0 toX:99 y:99.
form displayLineFromX:99 y:99 toX:0 y:99.
form displayLineFromX:0 y:99 toX:0 y:0.

view displayForm:form x:10 y:10.
!

image1
|image|

"/
"/ draws the grid
"/
view paint:Color red.
view displayLineFromX:10 y:5 toX:10 y:850.
view displayLineFromX:5 y:10 toX:850 y:10.


image := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.

view displayImage:image x:10 y:10.
!

image2
|image magnifiedImage|

image := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.

(0.1 to:1.5 by:0.1),(1.4 downTo:0.1 by:0.1) do:[:mag |
    Delay waitForSeconds:0.1.
    magnifiedImage := image magnifiedBy:mag.    
    view clear.
    view displayImage:magnifiedImage x:10 y:10.
].

    "Created: / 01-08-2013 / 14:33:51 / cg"
!

image3
|image rotatedImage|

image := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.

0 to:360 by:10 do:[:rot |
    Delay waitForSeconds:0.1.
    rotatedImage := (image rotated:rot).
    view clear.
    view displayImage:rotatedImage x:10 y:10.
].

    "Created: / 01-08-2013 / 14:39:41 / cg"
!

smoothingImage1
|image magnifiedImage smoothMagnifiedImage|

image := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
magnifiedImage := image magnifiedBy:0.4.
smoothMagnifiedImage := image magnifiedBy:0.4 smooth:true.

view clear.
view displayImage:image lightened x:5 y:5.
view displayString:'original' x:image width-50 y:20.

view displayImage:magnifiedImage x:0 y:0.
view displayString:'magnified' x:0 y:(magnifiedImage height-10).

view displayImage:smoothMagnifiedImage x:(image width-smoothMagnifiedImage width + 5 + 5)
                                       y:(image height-smoothMagnifiedImage height + 5 + 5).
view displayString:'magnified + smooth' x:image width-smoothMagnifiedImage width+10  y:(image height+10-10).
!

smoothingImage2
|image magnifiedImage smoothMagnifiedImage|

"/ create a grid image
image := Depth24Image width:101 height:101.
image createPixelStore.
image fillRectangle:(0@0 corner:100@100) withColor:(Color white).
0 to:100 by:10 do:[:offs |
    image drawLineFrom:(offs@0) to:(offs@99) withColor:Color black.
    image drawLineFrom:(0@offs) to:(99@offs) withColor:Color black.
].


magnifiedImage := image magnifiedBy:0.4.
smoothMagnifiedImage := image magnifiedBy:0.4 smooth:true.

view clear.
view displayImage:image lightened x:5 y:5.
view displayString:'original' x:image width-50 y:20.

view displayImage:magnifiedImage x:0 y:0.
view displayString:'magnified' x:0 y:(magnifiedImage height-10).

view displayImage:smoothMagnifiedImage x:(image width-smoothMagnifiedImage width + 5 + 5)
                                       y:(image height-smoothMagnifiedImage height + 5 + 5).
view displayString:'magnified + smooth' x:image width-smoothMagnifiedImage width+10  y:(image height+10-10).
! !

!DrawingProtocolDemonstration::Drawing::Lines methodsFor:'code'!

lineStyle
view lineStyle:#solid.
view displayLineFromX:20 y:20 toX:100 y:20.

view lineStyle:#dashed.
view displayLineFromX:20 y:30 toX:20 y:120.

view lineStyle:#dotted.
view displayLineFromX:30 y:30 toX:120 y:120.

view lineStyle:#doubleDashed.
view paint:(Color red) on:(Color yellow).
view displayLineFromX:30 y:130 toX:120 y:130.
!

lineWidth
view lineWidth:5.
view displayLineFromX:20 y:20 toX:100 y:20.

view lineWidth:15.
view displayLineFromX:20 y:30 toX:20 y:120.

view lineWidth:1.
view displayLineFromX:30 y:30 toX:120 y:120.

view lineWidth:0.
view displayLineFromX:30 y:130 toX:120 y:130.
! !

!DrawingProtocolDemonstration::Drawing::Pens methodsFor:'* uncategorized *'!

motion6b_manyTriangles
"many triangles"

|pen toTriangle|

pen := Pen in:view.
pen home.
pen east.

toTriangle := [
        pen go:100.
        pen turn:120.
        pen go:100.
        pen turn:120.
        pen go:100.
        pen turn:120.
    ].

360 / 5 timesRepeat:[
    toTriangle value.
    pen turn:5.
]
!

motion6c_manyTriangles
"many triangles"

|pen toTriangle side|

pen := Pen in:view.
pen home.
pen east.

toTriangle := [:side | 
        pen go:side.
        pen turn:120.
        pen go:side.
        pen turn:120.
        pen go:side.
        pen turn:120.
    ].

side := 10.
360 / 5 timesRepeat:[
    toTriangle value:side.
    pen turn:5.
    side := side + 5.
]
! !

!DrawingProtocolDemonstration::Drawing::Pens methodsFor:'code'!

interactive
"manual control"

|panel opListView goHolder turnHolder pen history|

pen := Pen in:view.

opListView := ScrollableView for:TextView in:view.
opListView layout:((LayoutFrame rightFrame:200) topOffset:30).
opListView scrolledView model:(history := List new).
opListView realize.

panel := HorizontalPanelView in:view.
panel horizontalLayout:#leftSpace.
panel layout:(LayoutFrame topFrame:30).

goHolder := 100 asValue.
turnHolder := 90 asValue.

{
    {   'Clear'   .  [ view clear. pen home. history removeAll ]    } .
    {   'Home'    .  [ pen home . history add:'pen home' ]                } .
    {   ''    .  nil                             } .
    {   'Down'    .  [ pen down . history add:'pen down']                } .
    {   'Up'      .  [ pen up . history add:'pen up']                  } .
    {   ''    .  nil                             } .
    {   'North'   .  [ pen north . history add:'pen north']               } .
    {   'South'   .  [ pen south . history add:'pen south']               } .
    {   'East'    .  [ pen east . history add:'pen east']                } .
    {   'West'    .  [ pen west . history add:'pen west']                } .
    {   ''    .  nil                             } .
} do:[:spec |
    spec first isEmpty 
        ifTrue:[ (View in:panel) width:10]
        ifFalse:[ Button label:spec first action:spec second in:panel ]
].
Button label:'Go'  action:[ pen go:goHolder value . history add:'pen go: ',goHolder value printString] in:panel.
(EditField in:panel) width:50; model:(TypeConverter onNumberValue:goHolder); immediateAccept:true.
Button label:'Turn'  action:[ pen turn:turnHolder value . history add:'pen turn: ',turnHolder value printString] in:panel.
(EditField in:panel) width:50; model:(TypeConverter onNumberValue:turnHolder); immediateAccept:true.

panel realize.
!

motion1_oneLine
"one line"

|pen|

pen := Pen in:view.
pen home.
pen south.
pen down.
pen go:100.
!

motion1a_oneLine
"one line"

|pen|

pen := Pen in:view.
pen down.
pen go:100.
!

motion1b_anotherLine
"one line"

|pen|

pen := Pen in:view.
pen south.
pen down.
pen go:100.
!

motion2_twoLines
"two lines"

|pen|

pen := Pen in:view.
pen south.
pen down.
pen go:100.
pen turn:90.
pen go:100.
!

motion3_aSquare
"a square"

|pen|

pen := Pen in:view.
pen south.
pen down.
4 timesRepeat:[
  pen go:100.
  pen turn:90.
].
!

motion3a_square
"a square"

|pen|

pen := Pen in:view.
pen down.

pen go:100.
pen turn:90.

pen go:100.
pen turn:90.

pen go:100.
pen turn:90.

pen go:100.
pen turn:90.
!

motion3b_square_loop
"a square"

|pen|

pen := Pen in:view.
pen down.
4 timesRepeat:[
  pen go:100.
  pen turn:90.
].
!

motion3c_square_named
"a square"

|pen toSquare|

pen := Pen in:view.
pen down.
toSquare :=
    [
        pen go:100.
        pen turn:90.
        pen go:100.
        pen turn:90.
        pen go:100.
        pen turn:90.
        pen go:100.
        pen turn:90.
    ].

toSquare value.
!

motion4_manySquares
"a pen-classic"

|pen oneRect|

oneRect := 
    [
        4 timesRepeat:[
          pen go:100.
          pen turn:90.
        ].
    ].

pen := Pen in:view.
pen down.
72 timesRepeat:[
    oneRect value.
    pen turn:5.
].
!

motion5_randomWalk
"random walk"

|pen rand|

rand := Random new.

pen := Pen in:view.
pen home.
pen south.

1000 timesRepeat:[
    pen turn:(rand nextIntegerBetween:0 and:360).
    pen go:(rand nextIntegerBetween:0 and:40).
].
!

motion5b_randomWalk_slowedDown
"random walk"

|pen rand|

rand := Random new.

pen := Pen in:view.
pen home.
pen south.

100 timesRepeat:[
    pen turn:(rand nextIntegerBetween:0 and:360).
    pen go:(rand nextIntegerBetween:0 and:40).
    Delay waitForSeconds:0.01
].
!

motion6_triangle
"triangle"

|pen|

pen := Pen in:view.

pen go:100.
pen turn:120.
pen go:100.
pen turn:120.
pen go:100.
pen turn:120.
!

motion6a_square
"square"

|pen|

pen := Pen in:view.

pen go:100.
pen turn:90.
pen go:100.
pen turn:90.
pen go:100.
pen turn:90.
pen go:100.
pen turn:90.
!

motion6a_triangle
"triangle"

|pen|

pen := Pen in:view.
pen home.
pen east.

pen go:100.
pen turn:120.
pen go:100.
pen turn:120.
pen go:100.
pen turn:120.
!

motion7_nSided
"n-sided figures"

|drawNSided pen|

"/ a function to draw
drawNSided := 
    [:n :length |
       n timesRepeat:[
           pen go:length.
           pen turn:(360 / n).
       ].
    ].

pen := Pen in:view.

pen up; goto:25@25; down.
drawNSided value:3 value:100.

pen up; goto:175@25; down.
drawNSided value:4 value:90.

pen up; goto:325@25; down.
drawNSided value:5 value:60.

pen up; goto:475@25; down.
drawNSided value:6 value:50.

pen up; goto:60@150; down.
drawNSided value:7 value:40.

pen up; goto:200@150; down.
drawNSided value:8 value:35.

pen up; goto:340@150; down.
drawNSided value:9 value:30.

pen up; goto:485@150; down.
drawNSided value:10 value:28.
!

motion7a_nSided
"n-sided figures"

|drawNSided pen side|

"/ a function to draw
drawNSided := 
    [:n :length |
       n timesRepeat:[
           pen go:length.
           pen turn:(360 / n).
       ].
    ].

pen := Pen in:view.
side := 80.
pen home; north; down.
drawNSided value:3 value:side.

pen home; north; down.
drawNSided value:4 value:side.

pen home; north; down.
drawNSided value:5 value:side.

pen home; north; down.
drawNSided value:6 value:side.

pen home; north; down.
drawNSided value:7 value:side.

pen home; north; down.
drawNSided value:8 value:side.

pen home; north; down.
drawNSided value:9 value:side.

pen home; north; down.
drawNSided value:10 value:side.
!

motion7b_nSided
"n-sided figures"

|drawNSided pen|

"/ a function to draw
drawNSided := 
    [:n :length |
       n timesRepeat:[
           pen go:length.
           pen turn:(360 / n).
       ].
    ].

pen := Pen in:view.

pen up; goto:25@25; down.
drawNSided value:3 value:100.

pen up; goto:175@25; down.
drawNSided value:4 value:90.

pen up; goto:325@25; down.
drawNSided value:5 value:60.

pen up; goto:475@25; down.
drawNSided value:6 value:50.

pen up; goto:60@150; down.
drawNSided value:7 value:40.

pen up; goto:200@150; down.
drawNSided value:8 value:35.

pen up; goto:340@150; down.
drawNSided value:9 value:30.

pen up; goto:485@150; down.
drawNSided value:10 value:28.
! !

!DrawingProtocolDemonstration::Drawing::Text methodsFor:'code'!

drawing1
view paint:Color red.
view displayLineFromX:0 y:15 toX:50 y:15.
view paint:Color black.
"/
"/ notice: string is drawn ON the baseline
"/
view displayString:'hello' x:0 y:15.
!

drawing2
view paint:Color red.
view displayLineFromX:5 y:20 toX:50 y:20.
view paint:Color black.

view displayString:'hello' x:10 y:20.
!

drawing3
view paint:Color red.
view displayLineFromX:5 y:20 toX:50 y:20.
view paint:Color black.

"/
"/ notice: to draw below the baseline, 
"/ we have to ask the string about its ascent above the baseline...
"/
view displayString:'hello' x:10 y:(20 + ('hello' ascentOn:view)).
!

drawing4_angle
view paint:Color red.
view displayLineFromX:5 y:5 toX:50 y:50.
view paint:Color black.

"/
"/ notice: we still draw along the baseline
"/
view 
    displayString:'hello' 
    x:15 y:15
    angle:45.

    "Created: / 01-08-2013 / 14:48:21 / cg"
!

drawing5_angle
view paint:Color red.
view displayLineFromX:15 y:55 toX:15 y:0.
view paint:Color black.

"/
"/ notice: we still draw along the baseline
"/
view 
    displayString:'hello' 
    x:15 y:35
    angle:-90.

    "Created: / 01-08-2013 / 14:48:12 / cg"
!

drawing6_emphasis
view displayString:('hello') x:15 y:20.
view displayString:('hello' allBold) x:15 y:50.
view displayString:('hello' allItalic) x:15 y:80.
view displayString:('hello' asText emphasizeAllWith:#underwave) x:15 y:110.
view displayString:('hello' asText emphasizeFrom:2 to:4 with:#underline) x:15 y:140.
view displayString:('hello' colorizeAllWith:Color blue) x:15 y:170.
view displayString:(('hello' asText colorizeAllWith:Color white) backgroundColorizeAllWith:Color blue) x:15 y:170.

    "Created: / 01-08-2013 / 14:51:16 / cg"
!

labelAndIcon1_stringHigherThanIcon
|image labelAndIcon|

image := Form 
            width:16 height:8 
            fromArray:#(
                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000

                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111
            ).

"/ notice: LabelAndIcon is drawn ABOVE baseline

labelAndIcon := LabelAndIcon icon:image string:'hello'.

view paint:Color blue.
view displayLineFromX:0 y:20-(labelAndIcon ascentOn:view) toX:50 y:20-(labelAndIcon ascentOn:view).
view paint:Color red.
view displayLineFromX:0 y:20 toX:50 y:20.
view paint:Color black.

labelAndIcon displayOn:view x:20 y:20
!

labelAndIcon2_iconHigherThanString
|image labelAndIcon|

image := Form 
            width:16 height:16 
            fromArray:#(
                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000

                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111

                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000

                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111
            ).

"/ notice: LabelAndIcon is drawn ABOVE baseline

labelAndIcon := LabelAndIcon icon:image string:'hello'.

view paint:Color blue.
view displayLineFromX:0 y:20-(labelAndIcon ascentOn:view) toX:50 y:20-(labelAndIcon ascentOn:view).
view paint:Color red.
view displayLineFromX:0 y:20 toX:50 y:20.
view paint:Color black.


labelAndIcon displayOn:view x:20 y:20
! !

!DrawingProtocolDemonstration::Drawing::Transformations methodsFor:'code'!

scaleArcs
view paint:Color red.
view displayCircle:(100@100) radius:20.
Delay waitForSeconds:2.

view paint:Color green.
view transformation:(WindowingTransformation scale:0.5 translation:0).
view displayCircle:(100@100) radius:20.
Delay waitForSeconds:2.

view paint:Color blue.
view transformation:(WindowingTransformation scale:2 translation:0).
view displayCircle:(100@100) radius:20.
!

scaleLines
view paint:Color red.
view displayLineFromX:10 y:10 toX:50 y:100.
Delay waitForSeconds:2.

view paint:Color green.
view transformation:(WindowingTransformation scale:0.5 translation:0).
view displayLineFromX:10 y:10 toX:50 y:100.
Delay waitForSeconds:2.

view paint:Color blue.
view transformation:(WindowingTransformation scale:2 translation:0).
view displayLineFromX:10 y:10 toX:50 y:100.

view transformation:nil.
!

scaleStrings
view paint:Color red.
view displayString:'hello' x:30 y:30.
Delay waitForSeconds:2.

view paint:Color green.
view transformation:(WindowingTransformation scale:0.5 translation:0).
view displayString:'hello' x:30 y:30.
Delay waitForSeconds:2.

view paint:Color blue.
view transformation:(WindowingTransformation scale:2 translation:0).
view displayString:'hello' x:30 y:30.
!

translateArcs
view paint:Color red.
view displayCircle:(100@100) radius:20.
Delay waitForSeconds:2.

view paint:Color green.
view transformation:(WindowingTransformation scale:1 translation:(100@0)).
view displayCircle:(100@100) radius:20.
Delay waitForSeconds:2.

view paint:Color blue.
view transformation:(WindowingTransformation scale:1 translation:(-100@0)).
view displayCircle:(100@100) radius:20.
! !

!DrawingProtocolDemonstration::View methodsFor:'others'!

bb
"add code below and accept"
! !

!DrawingProtocolDemonstration::View::Background methodsFor:'code'!

imageFromFile
|image|

image := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
view viewBackground:image.
view clear.
!

imageGenerated1
|form|

form := Form width:16 height:16.
form clear.

"/ be careful: endPoint style default is #butt
"/ therefore, we draw one pixel more.
form displayLineFromX:0 y:0 toX:16 y:16.

view viewBackground:form.
view clear.
!

imageGenerated2
|form|

form := Form 
            width:16 height:16
            fromArray:#(
                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111

                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000

                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111
                2r00001111 2r00001111

                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000
                2r11110000 2r11110000
            ).

view viewBackground:form.
view clear.
!

solidColor
view viewBackground:(Color red).
view clear.
! !

!DrawingProtocolDemonstration::View::Border methodsFor:'code'!

solidBorder1
|subView|

subView := View origin:10@10 corner:100@100.
subView border:(SimpleBorder new color:Color red).
view addSubView:subView.
subView realize.
!

solidBorder1_to_10
|subView|

subView := View origin:10@10 corner:100@100.
subView border:(SimpleBorder new color:Color red; width:1).
view addSubView:subView.
subView realize.
1 to:10 do:[:bw |
    subView borderWidth:bw.
    Delay waitForSeconds:0.2.
].
!

solidBorder5
|subView|

subView := View origin:10@10 corner:100@100.
subView border:(SimpleBorder new color:Color red; width:5).
view addSubView:subView.
subView realize.
! !

!DrawingProtocolDemonstration::View::Level methodsFor:'code'!

flat
|subView|

subView := View new.
view addSubView:subView.
subView origin:10@10 extent:100@100.

subView level:0.
subView realize.
!

negative
|subView|

subView := View new.
view addSubView:subView.
subView origin:10@10 extent:100@100.

subView level:-1.
subView realize.
!

positive
|subView|

subView := View new.
view addSubView:subView.
subView origin:10@10 extent:100@100.

subView level:1.
subView realize.
! !

!DrawingProtocolDemonstration::Widgets methodsFor:'others'!

aaa
"add code below and accept"
!

ex1
"add code below and accept"
! !

!DrawingProtocolDemonstration::Widgets::Button methodsFor:'code'!

button01
|button|

button := Button new.
button label:'Press me'.

view addSubView:button.
button origin:10@10 extent:100@100.

button realize.
!

button02
|button|

button := Button new.
button label:'Press me'.
button action:[ Transcript flash ].

view addSubView:button.
button origin:10@10 extent:100@100.

button realize.
!

button03
|button|

button := Button new.
button label:'Press me'.
button action:[ Transcript flash ].
button foregroundColor:(Color red).
button backgroundColor:(Color yellow).

view addSubView:button.
button origin:10@10 extent:100@100.

button realize.
! !

!DrawingProtocolDemonstration::Widgets::Button methodsFor:'others'!

vvv
"add code below and accept"
! !

!DrawingProtocolDemonstration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/DrawingProtocolDemonstration.st,v 1.29 2017-10-12 17:44:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/DrawingProtocolDemonstration.st,v 1.29 2017-10-12 17:44:24 cg Exp $'
! !

