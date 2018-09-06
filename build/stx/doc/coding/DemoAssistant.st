"{ Package: 'stx:doc/coding' }"

AssistantApplication subclass:#DemoAssistant
	instanceVariableNames:'text1Holder thisOrThatHolder chechAHolder checkAHolder
		checkBHolder anotherChoiceHolder theLastChoiceHolder
		editText2Holder'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!


!DemoAssistant class methodsFor:'page specs'!

page1Spec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DemoAssistant andSelector:#page1Spec
     DemoAssistant new openInterface:#page1Spec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: page1Spec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'This is Page1'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 5 0 0 1.0 27 0)
              translateLabel: true
            )
           (TextEditorSpec
              name: 'TextEditor1'
              layout: (LayoutFrame 0 0.0 29 0 -2 1.0 146 0)
              model: text1Holder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              hasKeyboardFocusInitially: false
            )
           (InputFieldSpec
              name: 'EntryField1'
              layout: (LayoutFrame 0 0.0 155 0 -2 1.0 177 0)
              model: editText2Holder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnPointerLeave: true
            )
           )
         
        )
      )
!

page2Spec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DemoAssistant andSelector:#page2Spec
     DemoAssistant new openInterface:#page2Spec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: page2Spec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'This is Page2'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 5 0 0 1.0 27 0)
              translateLabel: true
            )
           (RadioButtonSpec
              label: 'This'
              name: 'RadioButton1'
              layout: (LayoutFrame 8 0.0 79 0 144 0 101 0)
              translateLabel: true
              model: thisOrThatHolder
              isTriggerOnDown: true
              select: 'this'
            )
           (RadioButtonSpec
              label: 'That'
              name: 'RadioButton2'
              layout: (LayoutFrame 8 0.0 111 0 144 0 133 0)
              translateLabel: true
              model: thisOrThatHolder
              isTriggerOnDown: true
              select: 'that'
            )
           )
         
        )
      )
!

page3Spec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DemoAssistant andSelector:#page3Spec
     DemoAssistant new openInterface:#page3Spec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: page3Spec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'This is Page3'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 5 0 0 1.0 27 0)
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Check A'
              name: 'CheckBox1'
              layout: (LayoutFrame 15 0 95 0 151 0 117 0)
              model: checkAHolder
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Check B'
              name: 'CheckBox2'
              layout: (LayoutFrame 15 0 124 0 151 0 146 0)
              model: checkBHolder
              translateLabel: true
            )
           )
         
        )
      )
!

page4Spec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DemoAssistant andSelector:#page4Spec
     DemoAssistant new openInterface:#page4Spec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: page4Spec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'This is Page4'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 5 0 0 1.0 27 0)
              translateLabel: true
            )
           (PopUpListSpec
              label: 'Another Choice'
              name: 'PopUpList1'
              layout: (LayoutFrame 137 0 90 0 262 0 112 0)
              tabable: true
              model: anotherChoiceHolder
              menu: otherChoices
            )
           (ComboListSpec
              name: 'ComboList1'
              layout: (LayoutFrame 135 0 133 0 260 0 153 0)
              model: theLastChoiceHolder
              comboList: lastChoices
              useIndex: false
            )
           )
         
        )
      )
! !

!DemoAssistant methodsFor:'aspects'!

anotherChoiceHolder
    <resource: #uiAspect>

    anotherChoiceHolder isNil ifTrue:[
        anotherChoiceHolder := 'a' asValue.
    ].
    ^ anotherChoiceHolder.
!

checkAHolder
    <resource: #uiAspect>

    checkAHolder isNil ifTrue:[
        checkAHolder := true asValue.
    ].
    ^ checkAHolder.
!

checkBHolder
    <resource: #uiAspect>

    checkBHolder isNil ifTrue:[
        checkBHolder := false asValue.
    ].
    ^ checkBHolder.
!

editText2Holder
    <resource: #uiAspect>

    editText2Holder isNil ifTrue:[
        editText2Holder := 'text2' asValue.
    ].
    ^ editText2Holder.
!

lastChoices
    <resource: #uiAspect>

    ^ #('w' 'x' 'y' 'z').
!

otherChoices
    <resource: #uiAspect>

    ^ #('a' 'b' 'c' 'd').
!

text1Holder
    <resource: #uiAspect>

    text1Holder isNil ifTrue:[
        text1Holder := 'text1' asValue.
    ].
    ^ text1Holder.
!

theLastChoiceHolder
    <resource: #uiAspect>

    theLastChoiceHolder isNil ifTrue:[
        theLastChoiceHolder := 'w' asValue
    ].
    ^ theLastChoiceHolder.
!

thisOrThatHolder
    <resource: #uiAspect>

    thisOrThatHolder isNil ifTrue:[
        thisOrThatHolder := RadioButtonGroup new.
        thisOrThatHolder value:'this'.
    ].
    ^ thisOrThatHolder.
! !

!DemoAssistant methodsFor:'page specs'!

page1Spec
    ^ self class page1Spec
!

page2Spec
    ^ self class page2Spec
!

page3Spec
    ^ self class page3Spec
!

page4Spec
    ^ self class page4Spec
! !

!DemoAssistant methodsFor:'required protocol'!

assistantSpec
    ^ #(Array
        (AssistantPageSpec
            pageTitle: 'Step 1'
            windowSpecSelector: page1Spec
        )
        (AssistantPageSpec
            pageTitle: 'Step 2'
            windowSpecSelector: page2Spec
        )
        (AssistantPageSpec
            pageTitle: 'Step 3'
            windowSpecSelector: page3Spec
        )
        (AssistantPageSpec
            pageTitle: 'Step 4'
            windowSpecSelector: page4Spec
        )
    ) decodeAsLiteralArray
! !

!DemoAssistant class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/doc/coding/DemoAssistant.st,v 1.2 2009-10-20 17:07:37 cg Exp $'
! !
