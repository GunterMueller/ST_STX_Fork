"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemo
	instanceVariableNames:'selectedClass'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"

!

documentation
"
    A wrapper for all other GUIDemos found in this category.
    I provide a frame, and load one of the other demos
    as a subApplication into that frame.
    (the demos can also be started without me !!)
    Also, the demos documentation string is extracted and
    shown in the upper frame.

    See my popUpMenu to select individual demos.

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemo open
"
! !

!GUIDemo class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemo andSelector:#windowSpec
     CodingExamples_GUI::GUIDemo new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemo open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'GUI Demos'
          #name: 'GUI Demos'
          #min: #(#Point 10 10)
          #max: #(#Point 1160 870)
          #bounds: #(#Rectangle 490 420 1158 1099)
          #menu: #menu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#VariableVerticalPanelSpec
              #name: 'Panel'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#TextEditorSpec
                    #name: 'Transcript'
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #miniScrollerHorizontal: true
                  )
                 #(#SubCanvasSpec
                    #name: 'Canvas'
                    #clientHolder: #demoCanvas
                    #postBuildCallback: #postBuildCanvas:
                  )
                 )
               
              )
              #handles: #(#Any 0.297376 1.0)
            )
           )
         
        )
      )
! !

!GUIDemo class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemo andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemo menu)) startUp
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
                  label: 'Quit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: hasSelection
            label: 'Tools'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'UIPainter'
                  itemValue: doOpenGUIbuilder
                )
               (MenuItem
                  label: 'Browser'
                  itemValue: doOpenClassBrowser
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Show'
            submenuChannel: submenuDemos
          )
         )
        nil
        nil
      )
!

submenuDemos
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemo andSelector:#submenuDemos
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemo submenuDemos)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Arbitrary Component'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Dynamic'
                  itemValue: doStart:
                  argument: 'ArbitraryComponentDemo2'
                )
               (MenuItem
                  label: 'Static'
                  itemValue: doStart:
                  argument: 'ArbitraryComponentDemo'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Buttons, Sliders...'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Buttons'
                  itemValue: doStart:
                  argument: 'GUIDemoButtons'
                )
               (MenuItem
                  label: 'RadioButton Group'
                  itemValue: doStart:
                  argument: 'GUIDemoRadioButtonGroup'
                )
               (MenuItem
                  label: 'RadioButton + Others'
                  itemValue: doStart:
                  argument: 'GUIDemoRadioButtonGroupPlusOthers'
                )
               (MenuItem
                  label: 'Sliders'
                  itemValue: doStart:
                  argument: 'GUIDemoSliders'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Channels'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Enable Channel'
                  itemValue: doStart:
                  argument: 'GUIDemoEnableChannels'
                )
               (MenuItem
                  label: 'Visibility Channel'
                  itemValue: doStart:
                  argument: 'GUIDemoVisibility'
                )
               (MenuItem
                  label: 'Color Channels'
                  itemValue: doStart:
                  argument: 'GUIDemoColorChannels'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'DataSet'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'DataSet 1'
                  itemValue: doStart:
                  argument: 'GUIDemoDataSetView'
                )
               (MenuItem
                  label: 'DataSet 2'
                  itemValue: doStart:
                  argument: 'GUIDemoDataSet2'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Drag && Drop'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Example'
                  itemValue: doStart:
                  argument: 'GUIDemoDragAndDrop'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Extended ComboBox'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Simple Example'
                  itemValue: doStart:
                  argument: 'GUIDemoExtendedComboBox2'
                )
               (MenuItem
                  label: 'Including Applications'
                  itemValue: doStart:
                  argument: 'GUIDemoExtendedComboBox'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Geometry'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Panels'
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'Toggle Visibility'
                        itemValue: doStart:
                        argument: 'GUIDemoVisibilityToggleInPanel'
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
          )
         (MenuItem
            label: 'HierarchicalTree'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Models && Actions'
                  itemValue: doStart:
                  argument: 'GUIDemoNewHierarchicalTree'
                )
               (MenuItem
                  label: 'Create on DoubleClick'
                  itemValue: doStart:
                  argument: 'GUIDemoNewHierarchicalTree3'
                )
               (MenuItem
                  label: 'Toggles in Tree'
                  itemValue: doStart:
                  argument: 'GUIDemoNewHierarchicalTree2'
                )
               (MenuItem
                  label: 'Drag && Drop'
                  itemValue: doStart:
                  argument: 'GUIDemoNewHierarchicalTree4'
                )
               (MenuItem
                  label: 'File Browser'
                  itemValue: doStart:
                  argument: 'GUIDemoFileBrowser'
                )
               (MenuItem
                  label: 'Table in Tree'
                  itemValue: doStart:
                  argument: 'GUIDemoTableTreeView'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Menu'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Menus'
                  itemValue: doStart:
                  argument: 'GUIDemoMenu'
                )
               (MenuItem
                  label: 'Toolbar / Menu'
                  itemValue: doStart:
                  argument: 'GUIDemoToolBar'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Notebook'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Notebook'
                  itemValue: doStart:
                  argument: 'GUIDemoNoteBook'
                )
               (MenuItem
                  label: 'Tabs only'
                  itemValue: doStart:
                  argument: 'GUIDemoTabs'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'SequenceableList'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Models && Actions'
                  itemValue: doStart:
                  argument: 'GUIDemoSelectionInListModelView'
                )
               (MenuItem
                  label: 'Define Visual Presentation'
                  itemValue: doStart:
                  argument: 'GUIDemoSelectionInListModelView2'
                )
               (MenuItem
                  label: 'Presentation and Selectability'
                  itemValue: doStart:
                  argument: 'GUIDemoSelectionInListModelView3'
                )
               (MenuItem
                  label: 'Table in List 1'
                  itemValue: doStart:
                  argument: 'GUIDemoTableListView'
                )
               (MenuItem
                  label: 'Table in List 2'
                  itemValue: doStart:
                  argument: 'GUIDemoTableListView2'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'SubCanvas'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Dynamic'
                  itemValue: doStart:
                  argument: 'GUIDemoSubCanvasDynamic'
                )
               (MenuItem
                  label: 'Static'
                  itemValue: doStart:
                  argument: 'GUIDemoSubCanvasStatic'
                )
               (MenuItem
                  label: 'Embedded FileDialog'
                  itemValue: doStart:
                  argument: 'GUIDemoSubCanvasWithEmbeddedFileDialog'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'SubSpecification'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Loading a Specification'
                  itemValue: doStart:
                  argument: 'GUIDemoSubSpecification'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'TextEditor'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'TextEditor 1'
                  itemValue: doStart:
                  argument: 'GUIDemoTextEditor'
                )
               (MenuItem
                  label: 'TextEditor 2'
                  itemValue: doStart:
                  argument: 'GUIDemoTextEditor2'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'UIGallery'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Create a Gallery'
                  itemValue: doStart:
                  argument: 'GUIDemoGallery'
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

    "Modified: / 01-08-2013 / 14:26:26 / cg"
! !

!GUIDemo methodsFor:'aspects'!

demoCanvas
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#demoCanvas) isNil ifTrue:[
        builder aspectAt:#demoCanvas put:(holder :=  ValueHolder new).
    ].
    ^ holder
!

hasSelection
    "automatically generated by UIPainter ..."

    ^ builder booleanValueAspectFor:#hasSelection
! !

!GUIDemo methodsFor:'initialization'!

postBuildCanvas:canvas
    canvas keepClientView:false.
!

postOpenWith:aBuilder
    super postOpenWith:aBuilder.
    self showInitialIntroduction.
! !

!GUIDemo methodsFor:'printing'!

showCR:someMessage
    "write warning or error message to status line
    "
    |edView|

    edView := self transcript.
    edView hideCursor.
    edView cursorToEnd.
    edView insertStringAtCursor:someMessage.
    edView cursorReturn.
!

showInitialIntroduction
    "show heneral documentation 
    "
    |intro trans start stop src|

    trans := self transcript.
    trans hideCursor.

    trans contents:'
This application demonstrates various widgets
and some of their special features.
It is meant for programmers, to see concrete examples,
which might be useful in real applications.

Use the ''Browser'' menu function in the ''tools'' menu,
to open a systemBrowser on the class, 
or the ''UIPainter'' menu function, to open the GUI painter
tool.

Beginners should have a look at how valueHolders are set up
in the class, and how they are connected in the GUI painter.
'.
!

showIntroduction
    "show documentation for the current selected class
    "
    |intro trans start stop src|

    trans := self transcript.
    trans hideCursor.

    (selectedClass notNil and:[(src := selectedClass class compiledMethodAt:#documentation) notNil]) ifTrue:[
        src := src source.

        (start := src indexOf:$") ~~ 0 ifTrue:[
            start := start + 1.

            (stop := src indexOf:$" startingAt:start) ~~ 0 ifTrue:[
                intro := src copyFrom:start to:(stop - 1).
            ]
        ]
    ].    
    intro size == 0 ifTrue:[
        ^ trans contents:nil
    ].
    intro := intro asStringCollection.

    intro addFirst:''.
    intro addFirst:'-------------------------- Introduction --------------------------'.
    intro addLast:''.
    intro addLast:'------------------------------------------------------------------'.
    intro addLast:''.

    trans contents:intro.
!

transcript
    "returns the transcript all messages are forward to
    "
    ^ builder componentAt:#Transcript
! !

!GUIDemo methodsFor:'user actions'!

doOpen:aClsName on:what
    "start a new demo application
    "
    |cls appl|
self halt.

    aClsName size == 0 ifTrue:[ cls := nil ]
                      ifFalse:[ cls := self resolveName:aClsName ].

    cls == selectedClass ifTrue:[^ self].

    selectedClass := cls.

    cls notNil ifTrue:[ appl := cls new ]
              ifFalse:[ appl := nil ].

    self hasSelection value:(appl notNil).
    self demoCanvas   value:appl.

    self showIntroduction.
!

doOpenClassBrowser

    selectedClass notNil ifTrue:[
        selectedClass browserClass openInClass:selectedClass
    ]
!

doOpenGUIbuilder

    selectedClass notNil ifTrue:[
        UIPainter new openOnClass:selectedClass
    ]
!

doStart:aClsName
    "start a new demo application
    "
    |cls appl|

    aClsName size == 0 ifTrue:[ cls := nil ]
                      ifFalse:[ cls := self resolveName:aClsName ].

    cls == selectedClass ifTrue:[^ self].

    selectedClass := cls.

    self withWaitCursorDo:[
        cls notNil ifTrue:[ appl := cls new ]
                  ifFalse:[ appl := nil ].

        self hasSelection value:(appl notNil).
        self demoCanvas   value:appl.

        self showIntroduction.
    ]
! !

!GUIDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemo.st,v 1.36 2015-10-04 10:20:18 cg Exp $'
! !

