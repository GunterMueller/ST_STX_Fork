"{ NameSpace: CodingExamples_GUI }"

GUIDemoWidgets subclass:#GUIDemoMenuWidgets
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Widgets'
!


!GUIDemoMenuWidgets class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoMenuWidgets andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoMenuWidgets new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoMenuWidgets open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Menu Widgets'' Test Suite'
         name: 'Menu Widgets'' Test Suite'
         min: (Point 10 10)
         max: (Point 1152 900)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'VariableHorizontalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (VerticalPanelViewSpec
                   name: 'VerticalPanel1'
                   horizontalLayout: fit
                   verticalLayout: fit
                   horizontalSpace: 3
                   verticalSpace: 3
                   component: 
                  (SpecCollection
                     collection: (
                      (MenuPanelSpec
                         name: 'ToolBar1'
                         enableChannel: enableChannel
                         tabable: true
                         menu: menuToolbar
                         extent: (Point 146 40)
                       )
                      (PopUpListSpec
                         label: 'Popup List'
                         name: 'PopUpList1'
                         style: (FontDescription helvetica medium roman 10)
                         translateLabel: true
                         model: listModel
                         enableChannel: enableChannel
                         menu: 
                        (Array
                           'A' 'B'
                           'C'
                         )
                         extent: (Point 146 41)
                       )
                      (ComboListSpec
                         name: 'ComboList1'
                         enableChannel: enableChannel
                         tabable: true
                         model: listModel
                         foregroundColor: (Color 77.0 77.0 77.0)
                         backgroundColor: (Color 100.0 50.0 0.0)
                         comboList: 
                        (Array
                           'A' 'B'
                           'C'
                         )
                         useIndex: false
                         extent: (Point 144 39)
                       )
                      (ComboBoxSpec
                         name: 'ComboBox1'
                         enableChannel: enableChannel
                         tabable: true
                         model: listModel
                         type: symbolOrNil
                         comboList: 
                        (Array
                           'A' 'B'
                           'C'
                         )
                         useIndex: false
                         isFilenameBox: false
                         extent: (Point 144 39)
                       )
                      (TabViewSpec
                         name: 'TabHeader1'
                         enableChannel: enableChannel
                         model: listModel
                         menu: tabList
                         backgroundColor: (Color 100.0 50.0 0.0)
                         translateLabel: true
                         extent: (Point 146 40)
                       )
                      (NoteBookViewSpec
                         name: 'NoteBook1'
                         enableChannel: enableChannel
                         tabable: true
                         model: listModel
                         menu: tabList
                         backgroundColor: (Color 100.0 50.0 0.0)
                         translateLabel: true
                         extent: (Point 146 41)
                       )
                      (UIGalleryViewSpec
                         name: 'Gallery1'
                         model: listModel
                         backgroundColor: (Color 100.0 50.0 0.0)
                         translateLabel: true
                         extent: (Point 146 40)
                       )
                      )
                    
                   )
                 )
                (VerticalPanelViewSpec
                   name: 'VerticalPanel2'
                   horizontalLayout: fit
                   verticalLayout: fit
                   horizontalSpace: 3
                   verticalSpace: 3
                   component: 
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Enable All'
                         name: 'ActionButton2'
                         translateLabel: true
                         model: enable
                         extent: (Point 144 34)
                       )
                      (ActionButtonSpec
                         label: 'Disable All'
                         name: 'ActionButton3'
                         translateLabel: true
                         model: disable
                         extent: (Point 144 34)
                       )
                      (ActionButtonSpec
                         label: 'Label 1'
                         name: 'ActionButton4'
                         translateLabel: true
                         model: setLabel:
                         actionValue: '''ABDEFGHIJKLMNOPQRSTUVWXYZ
abdefghijklmnopqrstuvwxyz'''
                         extent: (Point 144 33)
                       )
                      (ActionButtonSpec
                         label: 'Label 2'
                         name: 'ActionButton5'
                         translateLabel: true
                         model: setLabel:
                         actionValue: '!!@#$%^&*()_+-=
{}[]|:;"''<,>.?'
                         extent: (Point 144 34)
                       )
                      (ActionButtonSpec
                         label: 'Set FG to red'
                         name: 'ActionButton6'
                         translateLabel: true
                         model: setFG:
                         actionValue: 'red'
                         extent: (Point 144 34)
                       )
                      (ActionButtonSpec
                         label: 'Set FG to green'
                         name: 'ActionButton7'
                         translateLabel: true
                         model: setFG:
                         actionValue: 'green'
                         extent: (Point 144 34)
                       )
                      (ActionButtonSpec
                         label: 'Set BG to blue'
                         name: 'ActionButton8'
                         translateLabel: true
                         model: setBG:
                         actionValue: 'blue'
                         extent: (Point 144 33)
                       )
                      (ActionButtonSpec
                         label: 'Set BG to yellow'
                         name: 'ActionButton9'
                         translateLabel: true
                         model: setBG:
                         actionValue: 'yellow'
                         extent: (Point 144 34)
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          )
        
       )
     )

! !

!GUIDemoMenuWidgets class methodsFor:'menu specs'!

menuToolbar
    "this window spec was automatically generated by the ST/X MenuEditor"

    "do not manually edit this - the builder may not be able to
     handle the specification if its corrupted."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoMenuWidgets andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoMenuWidgets menuToolbar)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Item 1'
                #isButton: true
            )
             #(#MenuItem
                #label: 'Item 2'
            )
             #(#MenuItem
                #label: 'Item 3'
                #isButton: true
            )
             #(#MenuItem
                #label: 'Item 4'
            )
          ) nil
          nil
      )
! !

!GUIDemoMenuWidgets methodsFor:'aspects'!

listModel
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#listModel) isNil ifTrue:[
        builder aspectAt:#listModel put:(holder :=  ValueHolder new).
    ].
    ^ holder
!

tabList
    ^ #('A' 'B' 'C')
! !

!GUIDemoMenuWidgets class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoMenuWidgets.st,v 1.2 2015-10-28 11:25:34 cg Exp $'
! !

