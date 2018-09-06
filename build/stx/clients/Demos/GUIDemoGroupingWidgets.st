"{ NameSpace: CodingExamples_GUI }"

GUIDemoWidgets subclass:#GUIDemoGroupingWidgets
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Widgets'
!


!GUIDemoGroupingWidgets class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoGroupingWidgets andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoGroupingWidgets new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoGroupingWidgets open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Grouping Widgets'' Test Suite'
              #layout: #(#LayoutFrame 129 0 355 0 428 0 657 0)
              #label: 'Grouping Widgets'' Test Suite'
              #min: #(#Point 10 10)
              #max: #(#Point 1152 900)
              #bounds: #(#Rectangle 129 355 429 658)
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
                                     #(#ViewSpec
                                        #name: 'Box1'
                                        #borderWidth: 5
                                        #level: 5
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#FramedBoxSpec
                                        #name: 'FramedBox1'
                                        #borderWidth: 5
                                        #level: 5
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #label: 'Framed Box'
                                        #labelPosition: #topLeft
                                        #style: #(#FontDescription #helvetica #bold #roman 14)
                                        #foregroundColor: #(#Color 0.0 0.0 100.0)
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#VariableHorizontalPanelSpec
                                        #name: 'VariableHorizontalPanel2'
                                        #borderWidth: 5
                                        #level: 5
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#VariableVerticalPanelSpec
                                        #name: 'VariableVerticalPanel1'
                                        #borderWidth: 5
                                        #level: 5
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#HorizontalPanelViewSpec
                                        #name: 'HorizontalPanel1'
                                        #borderWidth: 5
                                        #level: 5
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #horizontalLayout: #left
                                        #verticalLayout: #top
                                        #horizontalSpace: 3
                                        #verticalSpace: 3
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#VerticalPanelViewSpec
                                        #name: 'VerticalPanel3'
                                        #borderWidth: 5
                                        #level: 5
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #horizontalLayout: #left
                                        #verticalLayout: #top
                                        #horizontalSpace: 3
                                        #verticalSpace: 3
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#PanelViewSpec
                                        #name: 'Panel1'
                                        #borderWidth: 5
                                        #level: 5
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #horizontalLayout: #fitSpace
                                        #verticalLayout: #fitSpace
                                        #horizontalSpace: 3
                                        #verticalSpace: 3
                                        #extent: #(#Point 150 35)
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
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton3'
                                        #label: 'Disable All'
                                        #model: #disable
                                        #extent: #(#Point 150 36)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton4'
                                        #label: 'Label 1'
                                        #model: #setLabel:
                                        #actionValue: '''ABDEFGHIJKLMNOPQRSTUVWXYZ
abdefghijklmnopqrstuvwxyz'''
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton5'
                                        #label: 'Label 2'
                                        #model: #setLabel:
                                        #actionValue: '!!@#$%^&*()_+-=
{}[]|:;"''<,>.?'
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton6'
                                        #label: 'Set FG to red'
                                        #model: #setFG:
                                        #actionValue: 'red'
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton7'
                                        #label: 'Set FG to green'
                                        #model: #setFG:
                                        #actionValue: 'green'
                                        #extent: #(#Point 150 36)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton8'
                                        #label: 'Set BG to blue'
                                        #model: #setBG:
                                        #actionValue: 'blue'
                                        #extent: #(#Point 150 35)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton9'
                                        #label: 'Set BG to yellow'
                                        #model: #setBG:
                                        #actionValue: 'yellow'
                                        #extent: #(#Point 150 35)
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

!GUIDemoGroupingWidgets class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoGroupingWidgets.st,v 1.1 1998-03-24 00:02:12 tz Exp $'
! !
