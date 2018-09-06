"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoVisibility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoVisibility class methodsFor:'documentation'!

documentation
"
    The example demonstrates how to use a boolean valueHolder as visibilityChannel,
    which controls other widget's visibility.

    [author:]
        Claus Gittinger

    [see also:]
        GUIDemoEnableChannels

    [start with:]
        GUIDemoVisibility open
        GUIDemo open
"
! !

!GUIDemoVisibility class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NewApplication andSelector:#windowSpec
     NewApplication new openInterface:#windowSpec
     NewApplication open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'NewApplication'
          #name: 'NewApplication'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 12 22 780 564)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#ToggleSpec
              #label: 'Visible'
              #name: 'Toggle1'
              #layout: #(#LayoutFrame 10 0 10 0 140 0 32 0)
              #visibilityChannel: #''
              #translateLabel: true
              #model: #vis
              #isTriggerOnDown: true
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#ActionButtonSpec
              #label: 'Button'
              #name: 'Button1'
              #layout: #(#LayoutFrame 10 0 50 0 140 0 72 0)
              #visibilityChannel: #vis
              #translateLabel: true
            )
           #(#ActionButtonSpec
              #label: 'OK'
              #name: 'Button2'
              #layout: #(#LayoutFrame 10 0 80 0 140 0 102 0)
              #visibilityChannel: #vis
              #translateLabel: true
              #model: #accept
            )
           #(#ActionButtonSpec
              #label: 'Cancel'
              #name: 'Button3'
              #layout: #(#LayoutFrame 10 0 110 0 140 0 130 0)
              #visibilityChannel: #vis
              #translateLabel: true
              #model: #cancel
            )
           #(#ActionButtonSpec
              #label: 'Help'
              #name: 'Button4'
              #layout: #(#LayoutFrame 150 0 50 0 270 0 72 0)
              #visibilityChannel: #vis
              #translateLabel: true
              #model: #help
            )
           #(#ActionButtonSpec
              #label: 'Close'
              #name: 'Button5'
              #layout: #(#LayoutFrame 150 0 80 0 270 0 102 0)
              #visibilityChannel: #vis
              #translateLabel: true
              #model: #closeRequest
            )
           #(#ToggleSpec
              #label: 'Toggle'
              #name: 'Toggle2'
              #layout: #(#LayoutFrame 150 0 110 0 270 0 130 0)
              #visibilityChannel: #vis
              #translateLabel: true
              #isTriggerOnDown: true
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#RadioButtonSpec
              #label: 'Radio Button'
              #name: 'RadioButton1'
              #layout: #(#LayoutFrame 10 0.0 140 0 140 0 160 0)
              #visibilityChannel: #vis
              #translateLabel: true
              #isTriggerOnDown: true
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#CheckBoxSpec
              #label: 'Check Box'
              #name: 'CheckBox1'
              #layout: #(#LayoutFrame 150 0 140 0 270 0 162 0)
              #visibilityChannel: #vis
              #translateLabel: true
            )
           #(#CheckToggleSpec
              #name: 'CheckToggle1'
              #layout: #(#LayoutOrigin 10 0 170 0)
              #visibilityChannel: #vis
              #isTriggerOnDown: true
              #showLamp: false
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#ButtonSpec
              #label: 'Model Button'
              #name: 'ModelButton1'
              #layout: #(#LayoutFrame 10 0 200 0 140 0 222 0)
              #visibilityChannel: #vis
              #translateLabel: true
            )
           #(#UpDownButtonSpec
              #name: 'UpDownButton1'
              #layout: #(#LayoutFrame 40 0 170 0 85 0 192 0)
              #visibilityChannel: #vis
              #orientation: #horizontal
            )
           #(#ArrowButtonSpec
              #name: 'ArrowButton1'
              #layout: #(#LayoutFrame 100 0 170 0 122 0 192 0)
              #visibilityChannel: #vis
              #isTriggerOnDown: true
              #direction: #right
            )
           #(#PopUpListSpec
              #label: 'PopUp List'
              #name: 'PopUpList1'
              #layout: #(#LayoutFrame 150 0 200 0 270 0 222 0)
              #visibilityChannel: #vis
              #useIndex: false
            )
           #(#ComboListSpec
              #name: 'ComboList1'
              #layout: #(#LayoutFrame 10 0 230 0 140 0 250 0)
              #visibilityChannel: #vis
              #useIndex: false
            )
           #(#ComboBoxSpec
              #name: 'ComboBox1'
              #layout: #(#LayoutFrame 150 0 230 0 270 0 250 0)
              #visibilityChannel: #vis
              #acceptOnPointerLeave: false
            )
           #(#ExtendedComboBoxSpec
              #name: 'ExtendedComboBox1'
              #layout: #(#LayoutFrame 150 0 260 0 270 0 280 0)
              #visibilityChannel: #vis
              #miniScrollerHorizontal: true
            )
           #(#MenuPanelSpec
              #name: 'ToolBar1'
              #layout: #(#LayoutFrame 150 0 290 0 270 0 322 0)
              #visibilityChannel: #vis
              #textDefault: true
            )
           #(#MenuPanelSpec
              #name: 'ToolBar2'
              #layout: #(#LayoutFrame 150 0 330 0 270 0 350 0)
              #visibilityChannel: #vis
            )
           #(#TabViewSpec
              #name: 'TabHeader1'
              #layout: #(#LayoutFrame 150 0 360 0 270 0 400 0)
            )
           #(#NoteBookViewSpec
              #name: 'NoteBook1'
              #layout: #(#LayoutFrame 10 0 420 0 140 0 500 0)
              #visibilityChannel: #vis
            )
           #(#InputFieldSpec
              #attributes: 
             #(#'Entry Field'
                nil #EntryField1
                nil
              )
              #name: 'EntryField1'
              #layout: #(#LayoutFrame 150 0 410 0 270 0 432 0)
              #visibilityChannel: #vis
              #acceptOnPointerLeave: false
            )
           #(#LabelSpec
              #label: 'Label'
              #name: 'Label1'
              #layout: #(#LayoutFrame 150 0 440 0 270 0 460 0)
              #visibilityChannel: #vis
              #translateLabel: true
            )
           #(#TextEditorSpec
              #name: 'TextEditor1'
              #layout: #(#LayoutFrame 10 0 340 0 140 0 408 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
            )
           #(#SequenceViewSpec
              #name: 'List1'
              #layout: #(#LayoutFrame 10 0 260 0 140 0 330 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #useIndex: false
            )
           #(#HTMLViewSpec
              #name: 'HTMLBrowser1'
              #layout: #(#LayoutFrame 280 0 90 0 390 0 150 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
            )
           #(#SelectionInListModelViewSpec
              #name: 'SelectionInListModelView1'
              #layout: #(#LayoutFrame 280 0 160 0 390 0 220 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #useIndex: false
              #highlightMode: #line
            )
           #(#DataSetSpec
              #name: 'Table1'
              #layout: #(#LayoutFrame 280 0 230 0 390 0 290 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #has3Dsepartors: false
            )
           #(#SelectionInTreeViewSpec
              #name: 'TreeList1'
              #layout: #(#LayoutFrame 280 0 300 0 390 0 360 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #highlightMode: #line
            )
           #(#HierarchicalListViewSpec
              #name: 'HierarchicalListView1'
              #layout: #(#LayoutFrame 280 0 370 0 390 0 430 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #highlightMode: #line
            )
           #(#FileSelectionTreeSpec
              #name: 'FileTreeList1'
              #layout: #(#LayoutFrame 280 0 440 0 390 0 500 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #highlightMode: #line
            )
           #(#ViewSpec
              #name: 'Box1'
              #layout: #(#LayoutFrame 400 0 90 0 490 0 150 0)
              #visibilityChannel: #vis
              #backgroundColor: #(#Color 100.0 49.9992 49.9992)
            )
           #(#FramedBoxSpec
              #label: 'Framed Box'
              #name: 'FramedBox1'
              #layout: #(#LayoutFrame 400 0 160 0 510 0 230 0)
              #visibilityChannel: #vis
              #backgroundColor: #(#Color 100.0 49.9992 49.9992)
              #labelPosition: #topLeft
              #translateLabel: true
            )
           #(#VariableHorizontalPanelSpec
              #name: 'VariableHorizontalPanel1'
              #layout: #(#LayoutFrame 400 0 240 0 500 0 290 0)
              #visibilityChannel: #vis
              #backgroundColor: #(#Color 100.0 49.9992 49.9992)
            )
           #(#VariableVerticalPanelSpec
              #name: 'VariableVerticalPanel1'
              #layout: #(#LayoutFrame 400 0 300 0 500 0 360 0)
              #visibilityChannel: #vis
              #backgroundColor: #(#Color 100.0 49.9992 49.9992)
            )
           #(#HorizontalPanelViewSpec
              #name: 'HorizontalPanel1'
              #layout: #(#LayoutFrame 400 0 370 0 500 0 430 0)
              #visibilityChannel: #vis
              #backgroundColor: #(#Color 100.0 49.9992 49.9992)
              #horizontalLayout: #center
              #verticalLayout: #center
              #horizontalSpace: 3
              #verticalSpace: 3
            )
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent1'
              #layout: #(#LayoutFrame 520 0 90 0 610 0 150 0)
              #visibilityChannel: #vis
              #hasBorder: false
            )
           #(#UISubSpecification
              #name: 'SubSpecification1'
              #layout: #(#LayoutOrigin 510 0 160 0)
            )
           #(#SubCanvasSpec
              #name: 'SubCanvas1'
              #layout: #(#LayoutFrame 510 0 270 0 610 0 340 0)
              #visibilityChannel: #vis
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
            )
           #(#SliderSpec
              #name: 'Slider1'
              #layout: #(#LayoutFrame 510 0 380 0 610 0 398 0)
              #visibilityChannel: #vis
              #orientation: #horizontal
            )
           #(#ThumbWheelSpec
              #name: 'ThumbWheel1'
              #layout: #(#LayoutFrame 510 0 410 0 610 0 430 0)
              #visibilityChannel: #vis
              #orientation: #horizontal
            )
           #(#RoundProgressIndicatorSpec
              #name: 'RoundProgressIndicator1'
              #layout: #(#LayoutFrame 510 0 440 0 580 0 500 0)
              #level: 0
              #borderWidth: 1
              #visibilityChannel: #vis
            )
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent2'
              #layout: #(#LayoutFrame 620 0 80 0 680 0 140 0)
              #visibilityChannel: #vis
              #hasBorder: false
              #component: #ClockView
            )
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent3'
              #layout: #(#LayoutOrigin 620 0 160 0)
              #visibilityChannel: #vis
              #hasBorder: false
              #component: #DigitalLedDisplay
            )
           #(#MeterClackCounterSpec
              #name: 'MeterClackCounter1'
              #layout: #(#Rectangle 620 200 716 232)
              #visibilityChannel: #vis
              #model: #model
            )
           #(#SteppingSliderSpec
              #name: 'SteppingSlider1'
              #layout: #(#LayoutFrame 510 0 350 0 610 0 368 0)
              #visibilityChannel: #vis
              #orientation: #horizontal
            )
           )
         
        )
      )
! !

!GUIDemoVisibility methodsFor:'aspects'!

vis
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#vis) isNil ifTrue:[
	holder := true asValue.
	builder aspectAt:#vis put:holder.
    ].
    ^ holder.
! !

!GUIDemoVisibility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoVisibility.st,v 1.2 2001-12-08 13:42:06 cg Exp $'
! !
