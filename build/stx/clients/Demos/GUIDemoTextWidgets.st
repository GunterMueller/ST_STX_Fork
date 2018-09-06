"{ NameSpace: CodingExamples_GUI }"

GUIDemoWidgets subclass:#GUIDemoTextWidgets
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Widgets'
!


!GUIDemoTextWidgets class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoTextWidgets andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoTextWidgets new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoTextWidgets open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Menu Widgets'' Test Suite'
              #layout: #(#LayoutFrame 25 0 207 0 324 0 506 0)
              #label: 'Menu Widgets'' Test Suite'
              #min: #(#Point 10 10)
              #max: #(#Point 1152 900)
              #bounds: #(#Rectangle 25 207 325 507)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#VariableHorizontalPanelSpec
                    #name: 'VariableHorizontalPanel1'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#VerticalPanelViewSpec
                              #name: 'VerticalPanel1'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#TextEditorSpec
                                        #name: 'TextEditor1'
                                        #tabable: true
                                        #menu: #menu
                                        #hasHorizontalScrollBar: true
                                        #hasVerticalScrollBar: true
                                        #extent: #(#Point 150 72)
                                    )
                                     #(#InputFieldSpec
                                        #name: 'EntryField2'
                                        #extent: #(#Point 150 71)
                                    )
                                     #(#HTMLViewSpec
                                        #name: 'HTMLBrowser1'
                                        #tabable: true
                                        #menu: #menu
                                        #hasHorizontalScrollBar: true
                                        #hasVerticalScrollBar: true
                                        #extent: #(#Point 150 72)
                                    )
                                     #(#LabelSpec
                                        #name: 'Label1'
                                        #label: 'Label'
                                        #foregroundColor: #(#Color 100.0 0.0 0.0)
                                        #backgroundColor: #(#Color 0.0 0.0 100.0)
                                        #foregroundChannel: #fgChannel
                                        #backgroundChannel: #bgChannel
                                        #level: 5
                                        #borderWidth: 5
                                        #adjust: #right
                                        #resizeForLabel: true
                                        #extent: #(#Point 150 66)
                                    )
                                  )
                              )
                              #horizontalLayout: #fit
                              #verticalLayout: #fit
                              #horizontalSpace: 3
                              #verticalSpace: 3
                          )
                           #(#VerticalPanelViewSpec
                              #name: 'VerticalPanel2'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton2'
                                        #label: 'Enable All'
                                        #model: #enable
                                        #extent: #(#Point 150 48)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton10'
                                        #label: 'Disable All'
                                        #model: #disable
                                        #extent: #(#Point 150 47)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton6'
                                        #label: 'Set FG to red'
                                        #model: #setFG:
                                        #actionValue: 'red'
                                        #extent: #(#Point 150 48)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton7'
                                        #label: 'Set FG to green'
                                        #model: #setFG:
                                        #actionValue: 'green'
                                        #extent: #(#Point 150 47)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton8'
                                        #label: 'Set BG to blue'
                                        #model: #setBG:
                                        #actionValue: 'blue'
                                        #extent: #(#Point 150 48)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton9'
                                        #label: 'Set BG to yellow'
                                        #model: #setBG:
                                        #actionValue: 'yellow'
                                        #extent: #(#Point 150 47)
                                    )
                                  )
                              )
                              #horizontalLayout: #fit
                              #verticalLayout: #fit
                              #horizontalSpace: 3
                              #verticalSpace: 3
                          )
                        )
                    )
                    #handles: #(#Any 0.5 1.0)
                )
              )
          )
      )
! !

!GUIDemoTextWidgets class methodsFor:'menu specs'!

menu
    "this window spec was automatically generated by the ST/X MenuEditor"

    "do not manually edit this - the builder may not be able to
     handle the specification if its corrupted."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoTextWidgets andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoTextWidgets menu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Item 1'
            )
             #(#MenuItem
                #label: 'Item 2'
            )
             #(#MenuItem
                #label: 'Item 3'
            )
             #(#MenuItem
                #label: 'Item 4'
            )
          ) nil
          nil
      )
! !

!GUIDemoTextWidgets class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoTextWidgets.st,v 1.1 1998-03-24 00:03:32 tz Exp $'
! !
