"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoTextEditor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoTextEditor class methodsFor:'documentation'!

documentation
"
    example demonstrating the textEditors modifiedChannel.
    Change the text and see the modifiedHolders value changing.

    [start with:]
        GUIDemoTextEditor open
        GUIDemo open
"
! !

!GUIDemoTextEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoTextEditor andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoTextEditor new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoTextEditor open
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
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 16 42 316 342)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#TextEditorSpec
              #name: 'TextEditor1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1)
              #model: #textHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #modifiedChannel: #modifiedHolder
            )
           #(#CheckBoxSpec
              #label: 'ModifiedChannel'
              #name: 'CheckBox1'
              #layout: #(#LayoutFrame 0 0 -25 1 0 1 0 1)
              #model: #modifiedHolder
              #translateLabel: true
            )
           )
         
        )
      )
! !

!GUIDemoTextEditor methodsFor:'aspects'!

modifiedHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#modifiedHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#modifiedHolder put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.
!

textHolder
    |holder|

    (holder := builder bindingAt:#textHolder) isNil ifTrue:[
        holder := '' asValue.
        builder aspectAt:#textHolder put:holder.
    ].
    ^ holder.
! !

!GUIDemoTextEditor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoTextEditor.st,v 1.3 2002-10-01 08:02:22 cg Exp $'
! !