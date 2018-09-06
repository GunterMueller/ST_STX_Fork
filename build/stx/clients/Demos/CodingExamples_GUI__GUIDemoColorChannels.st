"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoColorChannels
	instanceVariableNames:'fgChannel bgChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoColorChannels class methodsFor:'documentation'!

documentation
"
    The example demonstrates how to use valueHolders as colorChannel,
    which controls another widget's appearance.

    [author:]
        Claus Gittinger

    [see also:]
        GUIDemoEnableChannel GUIDemoVisibility 

    [start with:]
        GUIDemoEnableChannels open
        GUIDemo open
"
! !

!GUIDemoColorChannels class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoColorChannels andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoColorChannels new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoColorChannels open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'NewApplication'
         name: 'NewApplication'
         min: (Point 0 0)
         max: (Point 1152 815)
         bounds: (Rectangle 0 0 418 327)
       )
       component: 
      (SpecCollection
         collection: (
          (ActionButtonSpec
             label: 'Button'
             name: 'Button1'
             layout: (LayoutFrame 6 0 17 0 131 0 39 0)
             backgroundChannel: bgChannel
             translateLabel: true
             foregroundChannel: fgChannel
           )
          (RadioButtonSpec
             label: 'Radio Button'
             name: 'RadioButton1'
             layout: (LayoutFrame 8 0.0 46 0 109 0 68 0)
             backgroundChannel: bgChannel
             translateLabel: true
             foregroundChannel: fgChannel
             isTriggerOnDown: true
             lampColor: (Color 100.0 100.0 0.0)
           )
          (ToggleSpec
             label: 'Toggle'
             name: 'Toggle1'
             layout: (LayoutFrame 136 0 18 0 256 0 40 0)
             backgroundChannel: bgChannel
             translateLabel: true
             foregroundChannel: fgChannel
             isTriggerOnDown: true
             lampColor: (Color 100.0 100.0 0.0)
           )
          (CheckBoxSpec
             label: 'Check Box'
             name: 'CheckBox2'
             layout: (LayoutFrame 115 0 47 0 211 0 69 0)
             backgroundChannel: bgChannel
             foregroundChannel: fgChannel
             translateLabel: true
           )
          (CheckToggleSpec
             name: 'CheckToggle1'
             layout: (LayoutOrigin 229 0 80 0)
             backgroundChannel: bgChannel
             isTriggerOnDown: true
             showLamp: false
             lampColor: (Color 100.0 100.0 0.0)
           )
          (ComboListSpec
             name: 'ComboList1'
             layout: (LayoutFrame 14 0 103 0 139 0 123 0)
             backgroundChannel: bgChannel
             comboList: testList
             useIndex: false
           )
          (ArrowButtonSpec
             name: 'ArrowButton1'
             layout: (LayoutFrame 144 0 75 0 166 0 99 0)
             backgroundChannel: bgChannel
             foregroundChannel: fgChannel
             isTriggerOnDown: true
             direction: right
           )
          (UpDownButtonSpec
             name: 'UpDownButton1'
             layout: (LayoutFrame 176 0 77 0 221 0 99 0)
             backgroundChannel: bgChannel
             foregroundChannel: fgChannel
             orientation: horizontal
           )
          (InputFieldSpec
             name: 'EntryField1'
             layout: (LayoutFrame 157 0 102 0 283 0 124 0)
             backgroundChannel: bgChannel
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: false
           )
          (LabelSpec
             label: 'FG Color:'
             name: 'Label1'
             layout: (LayoutFrame 0 0 262 0 143 0 284 0)
             translateLabel: true
             adjust: left
           )
          (ColorMenuSpec
             name: 'ColorMenu1'
             layout: (LayoutFrame 87 0 262 0 0 1.0 284 0)
             model: fgChannel
             labelsAreColored: true
           )
          (LabelSpec
             label: 'BG Color:'
             name: 'Label2'
             layout: (LayoutFrame 0 0 292 0 143 0 314 0)
             translateLabel: true
             adjust: left
           )
          (ColorMenuSpec
             name: 'ColorMenu2'
             layout: (LayoutFrame 87 0 292 0 0 1.0 314 0)
             model: bgChannel
             labelsAreColored: true
           )
          (RectangleMorphSpec
             name: 'RectangleMorph1'
             layout: (LayoutFrame 21 0 148 0 84 0 211 0)
             foregroundColor: (Color 100.0 100.0 0.0)
             line: true
             lineWidth: 3
             fill: true
             lineColor: (Color 100.0 0.0 0.0)
             foregroundColorChannel: bgChannel
             lineColorChannel: fgChannel
           )
          (LineSegmentMorphSpec
             name: 'LineSegmentMorph1'
             foregroundColor: (Color 100.0 100.0 0.0)
             lineWidth: 3
             fill: true
             lineColor: (Color 100.0 0.0 0.0)
             lineColorChannel: fgChannel
             startPoint: (Point 155 164)
             endPoint: (Point 195 214)
             showArrow: true
           )
          )
        
       )
     )
! !

!GUIDemoColorChannels methodsFor:'aspects'!

bgChannel
    bgChannel isNil ifTrue:[
        bgChannel := nil asValue.
    ].
    ^ bgChannel.

    "Created: / 01-08-2013 / 14:21:39 / cg"
!

fgChannel
    fgChannel isNil ifTrue:[
        fgChannel := nil asValue.
    ].
    ^ fgChannel.

    "Created: / 01-08-2013 / 14:21:29 / cg"
!

testList
    ^ #('aaa' 'bbb' 'ccc')

    "Created: / 01-08-2013 / 14:24:20 / cg"
! !

!GUIDemoColorChannels class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoColorChannels.st,v 1.1 2013-08-01 12:38:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoColorChannels.st,v 1.1 2013-08-01 12:38:23 cg Exp $'
! !

