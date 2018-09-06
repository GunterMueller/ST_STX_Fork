"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserDialog subclass:#VariableTypeDialog
	instanceVariableNames:'classNameHolder classList model'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings UI'
!


!VariableTypeDialog class methodsFor:'interface specs'!

windowSpec
        RBParser isSmalltalkX ifTrue:[
            ^ self windowSpecSTX
        ].
        ^ self windowSpecVW
!

windowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VariableTypeDialog andSelector:#windowSpecSTX
     VariableTypeDialog new openInterface:#windowSpecSTX
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecSTX
        #window: 
       #(#WindowSpec
          #label: 'Select class'
          #name: 'Select class'
          #bounds: #(#Rectangle 16 46 335 343)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: #classList
              #layout: #(#LayoutFrame 5 0 30 0 -5 1 -100 1)
              #model: #classList
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #useModifierKeys: true
            )
           #(#InputFieldSpec
              #name: #classNameHolder
              #layout: #(#LayoutFrame 5 0 -70 1 -65 1 -45 1)
              #model: #classNameHolder
              #type: #symbol
              #acceptOnPointerLeave: true
            )
           #(#DividerSpec
              #name: 'Separator1'
              #layout: #(#LayoutFrame 0 0 -98 1 0 1 -96 1)
            )
           #(#DividerSpec
              #name: 'Separator2'
              #layout: #(#LayoutFrame 0 0 -37 1 0 1 -35 1)
            )
           #(#LabelSpec
              #label: 'Select classes to move to:'
              #name: 'Label1'
              #layout: #(#Point 5 7)
            )
           #(#ActionButtonSpec
              #label: 'Add'
              #name: #addClassToList
              #layout: #(#AlignmentOrigin -5 1 -46 1 1 1)
              #model: #addClassToList
              #defaultable: true
            )
           #(#LabelSpec
              #label: 'Add class to list:'
              #name: 'Label2'
              #layout: #(#LayoutOrigin 5 0 -91 1)
            )
           #(#HorizontalPanelViewSpec
              #name: 'HorizontalPanel1'
              #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
              #horizontalLayout: #fitSpace
              #verticalLayout: #center
              #horizontalSpace: 3
              #verticalSpace: 3
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ActionButtonSpec
                    #label: 'OK'
                    #name: #accept
                    #model: #accept
                    #isDefault: true
                    #defaultable: true
                    #extent: #(#Point 154 21)
                  )
                 #(#ActionButtonSpec
                    #label: 'Cancel'
                    #name: #cancel
                    #model: #cancel
                    #extent: #(#Point 155 21)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpecVW
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VariableTypeDialog andSelector:#windowSpecVW
     VariableTypeDialog new openInterface:#windowSpecVW
     VariableTypeDialog open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Select class'
          #name: 'Select class'
          #bounds: #(#Rectangle 16 46 335 343)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: #classList
              #layout: #(#LayoutFrame 5 0 30 0 -5 1 -100 1)
              #model: #classList
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #useModifierKeys: true
            )
           #(#InputFieldSpec
              #name: #classNameHolder
              #layout: #(#LayoutFrame 5 0 -70 1 -65 1 -40 1)
              #model: #classNameHolder
              #type: #symbol
              #acceptOnPointerLeave: true
            )
           #(#DividerSpec
              #name: 'Separator1'
              #layout: #(#LayoutFrame 0 0 -98 1 0 1 -96 1)
            )
           #(#DividerSpec
              #name: 'Separator2'
              #layout: #(#LayoutFrame 0 0 -37 1 0 1 -35 1)
            )
           #(#LabelSpec
              #label: 'Select classes to move to:'
              #name: 'Label1'
              #layout: #(#Point 5 7)
            )
           #(#ActionButtonSpec
              #label: 'OK'
              #name: #accept
              #layout: #(#AlignmentOrigin 0 0.333333 -3 1 0.5 1)
              #model: #accept
              #defaultable: true
            )
           #(#ActionButtonSpec
              #label: 'Cancel'
              #name: #cancel
              #layout: #(#AlignmentOrigin 0 0.666666 -3 1 0.5 1)
              #model: #cancel
              #defaultable: true
            )
           #(#ActionButtonSpec
              #label: 'Add'
              #name: #addClassToList
              #layout: #(#AlignmentOrigin -5 1 -40 1 1 1)
              #model: #addClassToList
              #defaultable: true
            )
           #(#LabelSpec
              #label: 'Add class to list:'
              #name: 'Label2'
              #layout: #(#LayoutOrigin 5 0 -91 1)
            )
           )
         
        )
      )
! !

!VariableTypeDialog class methodsFor:'querying'!

chooseClassesFromList: aCollection initialSelections: selectedItems cancel: cancelBlock 
	| dialog |
	dialog := self new.
	dialog chooseClassesFromList: aCollection initialSelections: selectedItems.
	^dialog open ifTrue: [dialog classList selections] ifFalse: [cancelBlock value]
!

chooseClassesFromList: aCollection initialSelections: selectedItems model: aRBNamespace cancel: cancelBlock 
	| dialog |
	dialog := self new.
	dialog model: aRBNamespace.
	dialog chooseClassesFromList: aCollection initialSelections: selectedItems.
	^dialog open 
		ifTrue: [dialog classList selections]
		ifFalse: [cancelBlock value]
! !

!VariableTypeDialog methodsFor:'actions'!

addClassToList
	| class |
	class := self getClassForName.
	class isNil ifTrue: [^self].
	(self classList list includes: class) not 
		ifTrue: [self classList list add: class]
! !

!VariableTypeDialog methodsFor:'aspects'!

classList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^classList isNil
		ifTrue:
			[classList := MultiSelectionInList new]
		ifFalse:
			[classList]
!

classNameHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^classNameHolder isNil
		ifTrue:
			[classNameHolder := nil asValue]
		ifFalse:
			[classNameHolder]
! !

!VariableTypeDialog methodsFor:'initialize-release'!

chooseClassesFromList: aCollection initialSelections: selectedItems 
        |classList|

        classList := self classList.
        classList list: aCollection asList.
        classList selections: selectedItems
!

initialize
	super initialize.
	model := RBNamespace new
!

model: aRBNamespace 
	model := aRBNamespace
! !

!VariableTypeDialog methodsFor:'private'!

getClassForName
	^model classNamed: self classNameHolder value
! !

!VariableTypeDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/VariableTypeDialog.st,v 1.9 2003-09-23 10:43:30 cg Exp $'
! !
