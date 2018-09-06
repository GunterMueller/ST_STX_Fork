"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoExtendedComboBox2
	instanceVariableNames:'textHolder comboList'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!


!GUIDemoExtendedComboBox2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoExtendedComboBox2 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoExtendedComboBox2 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoExtendedComboBox2 open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'GUIDemoExtendedComboBox2'
          #name: 'GUIDemoExtendedComboBox2'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 871 269 1222 480)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#LabelSpec
              #label: 'Change Selection on double-click or return'
              #name: 'Label1'
              #layout: #(#LayoutFrame 5 0 20 0 347 0 42 0)
              #adjust: #left
            )
           #(#ExtendedComboBoxSpec
              #name: 'ExtendedComboBox1'
              #layout: #(#LayoutFrame 5 0.0 48 0 -5 1.0 68 0)
              #model: #textHolder1
              #menuWidget: #listView1
              #menuHeight: 300
              #miniScrollerVertical: true
              #miniScrollerHorizontal: true
            )
           #(#LabelSpec
              #label: 'Change Selection immediately (keep menu open)'
              #name: 'Label2'
              #layout: #(#LayoutFrame 5 0 80 0 347 0 102 0)
              #adjust: #left
            )
           #(#ExtendedComboBoxSpec
              #name: 'ExtendedComboBox2'
              #layout: #(#LayoutFrame 5 0.0 109 0 -5 1.0 129 0)
              #model: #textHolder2
              #menuWidget: #listView2
              #menuHeight: 300
              #closeOnSelect: false
              #miniScrollerVertical: true
              #miniScrollerHorizontal: true
            )
           #(#LabelSpec
              #label: 'Change Selection immediately (close menu)'
              #name: 'Label3'
              #layout: #(#LayoutFrame 5 0 144 0 347 0 166 0)
              #adjust: #left
            )
           #(#ExtendedComboBoxSpec
              #name: 'ExtendedComboBox3'
              #layout: #(#LayoutFrame 5 0.0 173 0 -5 1.0 193 0)
              #model: #textHolder3
              #menuWidget: #listView3
              #menuHeight: 300
              #miniScrollerVertical: true
              #miniScrollerHorizontal: true
            )
           )
         
        )
      )
! !

!GUIDemoExtendedComboBox2 methodsFor:'accessing-components'!

listView1
    |view|

    view := SelectionInListModelView new.

    view list:comboList.
    view selectElement:(self textHolder1 value).

    view doubleClickAction:[:i|
        self textHolder1 value:(view selectedElement)
    ].
    ^ view
!

listView2
    |view|

    view := SelectionInListModelView new.
    view useIndex:false.
    view list:comboList.

    view model:(self textHolder2).

    ^ view
!

listView3
    |view|

    view := SelectionInListModelView new.
    view useIndex:false.
    view list:comboList.

    view model:(self textHolder3).

    ^ view
! !

!GUIDemoExtendedComboBox2 methodsFor:'aspects'!

textHolder1
    |holder|

    (holder := builder bindingAt:#textHolder1) isNil ifTrue:[
        holder := ValueHolder new.
        holder value:(comboList first).
        builder aspectAt:#textHolder1 put:holder.
    ].
    ^ holder
!

textHolder2
    |holder|

    (holder := builder bindingAt:#textHolder2) isNil ifTrue:[
        holder := ValueHolder new.
        holder value:(comboList first).
        builder aspectAt:#textHolder2 put:holder.
    ].
    ^ holder
!

textHolder3
    |holder|

    (holder := builder bindingAt:#textHolder3) isNil ifTrue:[
        holder := ValueHolder new.
        holder value:(comboList first).
        builder aspectAt:#textHolder3 put:holder.
    ].
    ^ holder
! !

!GUIDemoExtendedComboBox2 methodsFor:'startup & release'!

initialize

    comboList := List new.
    1 to:50 do:[:i| comboList add:( i printString, ' text') ].

    super initialize.
! !

!GUIDemoExtendedComboBox2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoExtendedComboBox2.st,v 1.1 2002-12-12 14:47:19 ca Exp $'
! !
