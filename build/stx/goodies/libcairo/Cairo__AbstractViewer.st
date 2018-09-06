"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

ApplicationModel subclass:#AbstractViewer
	instanceVariableNames:'workspace exampleCodeHolder exampleMethodHolder zoomHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!

!AbstractViewer class methodsFor:'interface specs'!

previewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Cairo::AbstractViewer andSelector:#previewSpec
     Cairo::AbstractViewer new openInterface:#previewSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: 'previewSpec'
       window: 
      (WindowSpec
         label: 'Preview'
         name: 'Preview'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 619 380)
       )
       component: 
      (SpecCollection
         collection: (
          (NonScrollableArbitraryComponentSpec
             name: 'NonScrollableArbitraryComponent1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             component: PluggableView
             postBuildCallback: postBuildOutput:
           )
          )
        
       )
     )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Cairo::AbstractViewer andSelector:#windowSpec
     Cairo::AbstractViewer new openInterface:#windowSpec
     Cairo::AbstractViewer open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Cairo Examples'
         name: 'Cairo Examples'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 619 380)
         menu: windowMenu
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             showHandle: true
             snapMode: both
             component: 
            (SpecCollection
               collection: (
                (TextEditorSpec
                   name: 'TextEditor1'
                   model: exampleCodeHolder
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   hasKeyboardFocusInitially: false
                   viewClassName: 'Tools::CodeView2'
                   postBuildCallback: postBuildWorkspace:
                 )
                (UISubSpecification
                   name: 'Preview'
                   minorKey: previewSpec
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          )
        
       )
     )
! !

!AbstractViewer class methodsFor:'menu specs'!

windowMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Cairo::AbstractViewer andSelector:#windowMenu
     (Menu new fromLiteralArrayEncoding:(Cairo::AbstractViewer windowMenu)) startUp
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
            label: 'Edit'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Cut'
                  itemValue: editMenuCut
                  nameKey: Cut
                  shortcutKey: Cut
                  ignoreShortcutKeys: true
                )
               (MenuItem
                  label: 'Copy'
                  itemValue: editMenuCopy
                  nameKey: Copy
                  shortcutKey: Copy
                  ignoreShortcutKeys: true
                )
               (MenuItem
                  label: 'Paste'
                  itemValue: editMenuPaste
                  nameKey: Paste
                  shortcutKey: Paste
                  ignoreShortcutKeys: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Accept'
                  itemValue: editMenuAccept
                  nameKey: Accept
                  shortcutKey: Accept
                  ignoreShortcutKeys: true
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
                  label: 'Refresh'
                  itemValue: menuViewRefresh
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Examples'
            submenuChannel: menuExamples
          )
         (MenuItem
            label: 'Zoom'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Larger'
                  itemValue: menuZoomLarger
                  shortcutKey: #'Ctrl='
                )
               (MenuItem
                  label: 'Smaller'
                  itemValue: menuZoomSmaller
                  shortcutKey: #'Ctrl-'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: '100%'
                  itemValue: menuZoomSet:
                  argument: 100
                )
               (MenuItem
                  label: '200%'
                  itemValue: menuZoomSet:
                  argument: 200
                )
               (MenuItem
                  label: '400%'
                  itemValue: menuZoomSet:
                  argument: 400
                )
               (MenuItem
                  label: '800%'
                  itemValue: menuZoomSet:
                  argument: 800
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

!AbstractViewer class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == Cairo::AbstractViewer.
! !

!AbstractViewer methodsFor:'aspects'!

exampleCodeHolder
    "return/create the 'exampleCodeHolder' value holder (automatically generated)"

    exampleCodeHolder isNil ifTrue:[
        exampleCodeHolder := ValueHolder new.
        exampleCodeHolder addDependent:self.
    ].
    ^ exampleCodeHolder
!

exampleCodeHolder:something
    "set the 'exampleCodeHolder' value holder (automatically generated)"

    |oldValue newValue|

    exampleCodeHolder notNil ifTrue:[
        oldValue := exampleCodeHolder value.
        exampleCodeHolder removeDependent:self.
    ].
    exampleCodeHolder := something.
    exampleCodeHolder notNil ifTrue:[
        exampleCodeHolder addDependent:self.
    ].
    newValue := exampleCodeHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:exampleCodeHolder.
    ].
!

exampleMethodHolder
    "return/create the 'exampleMethodHolder' value holder (automatically generated)"

    exampleMethodHolder isNil ifTrue:[
        exampleMethodHolder := ValueHolder new.
        exampleMethodHolder addDependent:self.
    ].
    ^ exampleMethodHolder
!

exampleMethodHolder:something
    "set the 'exampleMethodHolder' value holder (automatically generated)"

    |oldValue newValue|

    exampleMethodHolder notNil ifTrue:[
        oldValue := exampleMethodHolder value.
        exampleMethodHolder removeDependent:self.
    ].
    exampleMethodHolder := something.
    exampleMethodHolder notNil ifTrue:[
        exampleMethodHolder addDependent:self.
    ].
    newValue := exampleMethodHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:exampleMethodHolder.
    ].
!

zoomHolder
    "return/create the 'zoomHolder' value holder (automatically generated)"

    zoomHolder isNil ifTrue:[
        zoomHolder := ValueHolder with: 100.
        zoomHolder addDependent:self.
    ].
    ^ zoomHolder

    "Modified: / 28-02-2016 / 16:12:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

zoomHolder:something
    "set the 'zoomHolder' value holder (automatically generated)"

    |oldValue newValue|

    zoomHolder notNil ifTrue:[
        oldValue := zoomHolder value.
        zoomHolder removeDependent:self.
    ].
    zoomHolder := something.
    zoomHolder notNil ifTrue:[
        zoomHolder addDependent:self.
    ].
    newValue := zoomHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:zoomHolder.
    ].
! !

!AbstractViewer methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == exampleCodeHolder ifTrue:[
         self updateAfterExampleCodeChanged.
         ^ self.
    ].
    changedObject == exampleMethodHolder ifTrue:[
         self updateAfterExampleMethodChanged.
         ^ self.
    ].
    changedObject == zoomHolder ifTrue:[
         self updateAfterZoomChanged.
         ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 28-02-2016 / 16:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterExampleCodeChanged
    | code method |

    code := exampleCodeHolder value.
    code notEmptyOrNil ifTrue:[ 
        method := Compiler compile:( 'redrawOn: ',self exampleMethodParameterName,' ', code)  forClass: nil install: false.
        method notNil ifTrue:[   
            method source: code asString string.
        ].  
    ].
    self exampleMethodHolder value: method

    "Created: / 26-02-2016 / 21:32:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2016 / 08:57:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterExampleMethodChanged
    self subclassResponsibility

    "Created: / 26-02-2016 / 21:32:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterZoomChanged
    self redraw

    "Created: / 28-02-2016 / 16:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractViewer methodsFor:'hooks'!

postBuildWorkspace:aCodeView2
    <resource: #uiCallback>

    workspace := aCodeView2.
    workspace language: SmalltalkLanguage instance.
    workspace codeAspect: SyntaxHighlighter codeAspectStatements

    "Modified: / 26-02-2016 / 22:43:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractViewer methodsFor:'menu'!

menuExamples
    self subclassResponsibility

    "Created: / 26-02-2016 / 22:36:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2016 / 08:56:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuExamplesFromClass: aClass
    ^ self menuExamplesFromSuite: aClass buildSuite.

    "Created: / 26-02-2016 / 22:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 10:05:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuExamplesFromSuite: aTestSuite
    | examples menu |

    examples := aTestSuite tests.
    examples sort: [ :a :b | a name < b name ].
    menu := Menu new.
    examples do:[:example | 
        menu addItem: (MenuItem
                        label: example name
                        itemValue: #menuExampleShow: 
                        argument: example source)
    ].
    ^ menu

    "Created: / 01-03-2016 / 10:04:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractViewer methodsFor:'menu actions'!

menuExampleShow: code
    self exampleCodeHolder value: code.

    "Created: / 26-02-2016 / 22:27:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuExampleShowBrowser
    self halt.

    "Created: / 26-02-2016 / 22:30:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuExampleShowMethod: method
    | source |

    source := method source asStringCollection.
    source := source copyFrom: 2.
    source := source asString.
    self menuExampleShow: source.

    "Created: / 26-02-2016 / 22:28:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuViewRefresh
    self redraw.

    "Created: / 28-02-2016 / 16:10:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuZoomLarger
    self zoomHolder value: self zoomHolder value + 10.

    "Created: / 28-02-2016 / 16:13:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuZoomSet: aNumber
    self zoomHolder value: aNumber

    "Created: / 28-02-2016 / 16:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuZoomSmaller
    self zoomHolder value: self zoomHolder value - 10.

    "Created: / 28-02-2016 / 16:13:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractViewer methodsFor:'private'!

redraw
    self subclassResponsibility

    "Created: / 28-02-2016 / 16:21:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redraw:view using: method
    self subclassResponsibility

    "Created: / 26-02-2016 / 21:40:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redraw:view using: method with: gc
    method notNil ifTrue:[    
        method valueWithReceiver:nil arguments:(Array with: gc).    
    ]

    "Created: / 26-02-2016 / 21:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractViewer methodsFor:'private - templates'!

exampleMethodParameterName
    ^ self subclassResponsibility

    "Created: / 26-02-2016 / 21:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

