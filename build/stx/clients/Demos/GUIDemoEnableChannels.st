"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoEnableChannels
	instanceVariableNames:'enableChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoEnableChannels class methodsFor:'documentation'!

documentation
"
    The example demonstrates how to use a boolean valueHolder as enableChannel,
    which controls multiple other widget's enableStates.

    [author:]
        Claus Gittinger

    [see also:]
        GUIDemoVisibility 

    [start with:]
        GUIDemoEnableChannels open
        GUIDemo open
"
! !

!GUIDemoEnableChannels class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoEnableChannels andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoEnableChannels new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoEnableChannels open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'NewApplication'
          #name: 'NewApplication'
          #min: #(#Point 0 0)
          #max: #(#Point 1152 815)
          #bounds: #(#Rectangle 13 23 431 350)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#ActionButtonSpec
              #label: 'Button'
              #name: 'Button1'
              #layout: #(#LayoutFrame 6 0 17 0 131 0 39 0)
              #translateLabel: true
              #enableChannel: #enableChannel
            )
           #(#RadioButtonSpec
              #label: 'Radio Button'
              #name: 'RadioButton1'
              #layout: #(#LayoutFrame 8 0.0 46 0 109 0 68 0)
              #translateLabel: true
              #enableChannel: #enableChannel
              #isTriggerOnDown: true
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#ToggleSpec
              #label: 'Toggle'
              #name: 'Toggle1'
              #layout: #(#LayoutFrame 136 0 18 0 256 0 40 0)
              #translateLabel: true
              #enableChannel: #enableChannel
              #isTriggerOnDown: true
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#CheckBoxSpec
              #label: 'Check Box'
              #name: 'CheckBox2'
              #layout: #(#LayoutFrame 115 0 47 0 211 0 69 0)
              #enableChannel: #enableChannel
              #translateLabel: true
            )
           #(#CheckToggleSpec
              #name: 'CheckToggle1'
              #layout: #(#LayoutOrigin 229 0 80 0)
              #enableChannel: #enableChannel
              #isTriggerOnDown: true
              #showLamp: false
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#PopUpListSpec
              #label: 'PopUp List'
              #name: 'PopUpList1'
              #layout: #(#LayoutFrame 8 0 75 0 133 0 97 0)
              #enableChannel: #enableChannel
            )
           #(#ComboListSpec
              #name: 'ComboList1'
              #layout: #(#LayoutFrame 9 0 101 0 134 0 121 0)
              #enableChannel: #enableChannel
              #useIndex: false
            )
           #(#ExtendedComboBoxSpec
              #name: 'ExtendedComboBox1'
              #layout: #(#LayoutFrame 9 0 127 0 134 0 147 0)
              #enableChannel: #enableChannel
              #miniScrollerHorizontal: true
            )
           #(#ArrowButtonSpec
              #name: 'ArrowButton1'
              #layout: #(#LayoutFrame 144 0 75 0 166 0 99 0)
              #enableChannel: #enableChannel
              #isTriggerOnDown: true
              #direction: #right
            )
           #(#UpDownButtonSpec
              #name: 'UpDownButton1'
              #layout: #(#LayoutFrame 176 0 77 0 221 0 99 0)
              #enableChannel: #enableChannel
              #orientation: #horizontal
            )
           #(#TextEditorSpec
              #name: 'TextEditor1'
              #layout: #(#LayoutFrame 143 0 104 0 264 0 151 0)
              #enableChannel: #enableChannel
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
            )
           #(#InputFieldSpec
              #name: 'EntryField1'
              #layout: #(#LayoutFrame 140 0 158 0 266 0 180 0)
              #enableChannel: #enableChannel
              #acceptOnReturn: true
              #acceptOnTab: true
              #acceptOnLostFocus: true
              #acceptOnPointerLeave: false
            )
           #(#CheckBoxSpec
              #label: 'Enable'
              #name: 'EnableCheckBox'
              #layout: #(#LayoutFrame 103 0 290 0 239 0 312 0)
              #model: #enableChannel
              #translateLabel: true
            )
           )
         
        )
      )
! !

!GUIDemoEnableChannels methodsFor:'aspects'!

enableChannel
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    enableChannel isNil ifTrue:[
        enableChannel := true asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       enableChannel addDependent:self.
"/       enableChannel onChangeSend:#enableChannelChanged to:self.
    ].
    ^ enableChannel.
! !

!GUIDemoEnableChannels class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoEnableChannels.st,v 1.1 2001-12-08 13:43:23 cg Exp $'
! !
