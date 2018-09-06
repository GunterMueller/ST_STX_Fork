"{ NameSpace: CodingExamples_GUI }"

GUIDemoWidgets subclass:#GUIDemoMiscWidgets
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Widgets'
!


!GUIDemoMiscWidgets class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoMiscWidgets andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoMiscWidgets new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoMiscWidgets open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Misc Widgets'' Test Suite'
              #layout: #(#LayoutFrame 67 0 215 0 432 0 640 0)
              #label: 'Misc Widgets'' Test Suite'
              #min: #(#Point 10 10)
              #max: #(#Point 1152 900)
              #bounds: #(#Rectangle 67 215 433 641)
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
                                     #(#ArbitraryComponentSpec
                                        #name: 'ArbitraryComponent1'
                                        #hasBorder: false
                                        #extent: #(#Point 183 51)
                                    )
                                     #(#UISubSpecification
                                        #name: 'SubSpecification1'
                                        #level: 10
                                        #borderWidth: 10
                                        #extent: #(#Point 183 40)
                                    )
                                     #(#SubCanvasSpec
                                        #name: 'SubCanvas1'
                                        #hasHorizontalScrollBar: true
                                        #hasVerticalScrollBar: true
                                        #level: 10
                                        #borderWidth: 10
                                        #extent: #(#Point 183 41)
                                    )
                                     #(#SliderSpec
                                        #name: 'Slider1'
                                        #tabable: true
                                        #orientation: #horizontal
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #extent: #(#Point 183 50)
                                    )
                                     #(#ThumbWheelSpec
                                        #name: 'ThumbWheel1'
                                        #tabable: true
                                        #orientation: #horizontal
                                        #stop: 36
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #level: 7
                                        #endlessRotation: true
                                        #extent: #(#Point 183 50)
                                    )
                                     #(#ProgressIndicatorSpec
                                        #name: 'ProgressIndicator1'
                                        #foregroundColor: #(#Color 0.0 100.0 0.0)
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #style: #(#FontDescription #courier #bold #roman 18)
                                        #extent: #(#Point 183 51)
                                    )
                                     #(#DividerSpec
                                        #name: 'Separator1'
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #extent: #(#Point 183 50)
                                    )
                                     #(#RegionSpec
                                        #name: 'Region1'
                                        #isOpaque: true
                                        #lineWidth: 10
                                        #regionType: #ellipse
                                        #backgroundColor: #(#Color 100.0 49.9992 0.0)
                                        #extent: #(#Point 183 51)
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
                                        #extent: #(#Point 183 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton3'
                                        #label: 'Disable All'
                                        #model: #disable
                                        #extent: #(#Point 183 50)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton4'
                                        #label: 'Label 1'
                                        #model: #setLabel:
                                        #actionValue: '''ABDEFGHIJKLMNOPQRSTUVWXYZ
abdefghijklmnopqrstuvwxyz'''
                                        #extent: #(#Point 183 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton5'
                                        #label: 'Label 2'
                                        #model: #setLabel:
                                        #actionValue: '!!@#$%^&*()_+-=
{}[]|:;"''<,>.?'
                                        #extent: #(#Point 183 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton6'
                                        #label: 'Set FG to red'
                                        #model: #setFG:
                                        #actionValue: 'red'
                                        #extent: #(#Point 183 50)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton7'
                                        #label: 'Set FG to green'
                                        #model: #setFG:
                                        #actionValue: 'green'
                                        #extent: #(#Point 183 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton8'
                                        #label: 'Set BG to blue'
                                        #model: #setBG:
                                        #actionValue: 'blue'
                                        #extent: #(#Point 183 50)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'ActionButton9'
                                        #label: 'Set BG to yellow'
                                        #model: #setBG:
                                        #actionValue: 'yellow'
                                        #extent: #(#Point 183 51)
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

!GUIDemoMiscWidgets class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoMiscWidgets.st,v 1.1 1998-03-24 00:03:17 tz Exp $'
! !
