"{ Package: 'stx:doc/coding' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#RndVisualizer
	instanceVariableNames:'rndClass rndView infoLabelHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-rndVisualization'
!

!RndVisualizer class methodsFor:'documentation'!

documentation
"
    a little demo view showing the distribution of
    random numbers and hashes.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    RndVisualizer open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!RndVisualizer class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:RndVisualizer andSelector:#windowSpec
     RndVisualizer new openInterface:#windowSpec
     RndVisualizer open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'RndVisualizer'
         name: 'RndVisualizer'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 515 589)
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
          (MenuPanelSpec
             name: 'ToolBar2'
             layout: (LayoutFrame 0 0.0 36 0 0 1.0 72 0)
             menu: toolbarMenu2
             textDefault: true
           )
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0 72 0 512 0 548 0)
             level: 0
             backgroundColor: (Color 100.0 100.0 100.0)
             postBuildCallback: postBuildRndView:
             viewClassName: 'SimpleView'
           )
          (ViewSpec
             name: 'Box2'
             layout: (LayoutFrame 0 0 -26 1 0 1 0 1)
             level: 1
             model: infoLabelHolder
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

!RndVisualizer class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:RndVisualizer andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(RndVisualizer mainMenu)) startUp
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
            label: 'Help'
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
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:RndVisualizer andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(RndVisualizer toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'RG'
            itemValue: showRandom:
            isButton: true
            argument: RandomGenerator
          )
         (MenuItem
            label: 'Random'
            itemValue: showRandom:
            isButton: true
            argument: Random
          )
         (MenuItem
            label: 'TT800'
            itemValue: showRandom:
            isButton: true
            argument: RandomTT800
          )
         (MenuItem
            label: 'PM'
            itemValue: showRandom:
            isButton: true
            argument: RandomParkMiller
          )
         (MenuItem
            label: 'MT19937'
            itemValue: showRandom:
            isButton: true
            argument: RandomMT19937
          )
         (MenuItem
            label: 'KISS'
            itemValue: showRandom:
            isButton: true
            argument: RandomKISS
          )
         )
        nil
        nil
      )
!

toolbarMenu2
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:RndVisualizer andSelector:#toolbarMenu2
     (Menu new fromLiteralArrayEncoding:(RndVisualizer toolbarMenu2)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'H(Syms)'
            itemValue: showHashes:
            isButton: true
            argument: #'hashSymbols hash'
          )
         (MenuItem
            label: 'H(Nums)'
            itemValue: showHashes:
            isButton: true
            argument: #'hashNumbers hash'
          )
         (MenuItem
            label: 'h-sdbm(Syms)'
            itemValue: showHashes:
            isButton: true
            argument: #'hashSymbols hash_sdbm'
          )
         (MenuItem
            label: 'H-sdbm(Nums)'
            itemValue: showHashes:
            isButton: true
            argument: #'hashNumbers hash_sdbm'
          )
         (MenuItem
            label: 'h-java(Syms)'
            itemValue: showHashes:
            isButton: true
            argument: #'hashSymbols hash_java'
          )
         (MenuItem
            label: 'H-java(Nums)'
            itemValue: showHashes:
            isButton: true
            argument: #'hashNumbers hash_java'
          )
         )
        nil
        nil
      )
! !

!RndVisualizer methodsFor:'actions'!

postBuildRndView:anArgument
    rndView := anArgument
! !

!RndVisualizer methodsFor:'aspects'!

infoLabelHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    infoLabelHolder isNil ifTrue:[
        infoLabelHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       infoLabelHolder addDependent:self.
"/       infoLabelHolder onChangeSend:#infoLabelHolderChanged to:self.
    ].
    ^ infoLabelHolder.
! !

!RndVisualizer methodsFor:'initialization & release'!

initialize  
    rndClass := Random
! !

!RndVisualizer methodsFor:'menu actions'!

generateImage
    |rnd n1|

    rndView viewBackground:Color white.
    rndView clear.

    rnd := rndClass new.
    n1 := 0.
    rndView paint:Color black.
    0 to:511 do:[:y |
        0 to:511 do:[:x |
            (rnd nextBoolean) ifTrue:[
                rndView displayPointX:x y:y.
                n1 := n1 + 1.
            ]
        ]
    ].
    self infoLabelHolder value:('0:%1 1:%2' bindWith:(512*512-n1) with:n1)
!

hashNumbers
    ^ 1 to:100000 collect:[:i | i printString].
!

hashSymbols
    ^ Symbol allInstances
!

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
!

showHashes:howAndAlgo 
    |strings how algo|

    how := howAndAlgo asCollectionOfWords first asSymbol.
    algo := howAndAlgo asCollectionOfWords second asSymbol.

    strings := self perform:how.

    rndView viewBackground:Color white.
    rndView clear.

    rndView paint:Color black.
    self withWaitCursorDo:[
        strings do:[:each |
            |h x y|

            h := each perform:algo.
            x := h bitAnd:16r1FF.
            y := (h >> 9) bitAnd:16r1FF.
            rndView displayPointX:x y:y.
        ].
    ].
    self infoLabelHolder value:how
!

showRandom:rndClassName
    rndClass := Smalltalk at:rndClassName.
    self generateImage.
! !

!RndVisualizer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/RndVisualizer.st,v 1.3 2016-01-04 01:59:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/doc/coding/RndVisualizer.st,v 1.3 2016-01-04 01:59:15 cg Exp $'
! !

