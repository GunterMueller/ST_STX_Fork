"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoSelectionInListModelView3
	instanceVariableNames:'list'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

HierarchicalItem subclass:#Item
	instanceVariableNames:'category label'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoSelectionInListModelView3
!


!GUIDemoSelectionInListModelView3 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoSelectionInListModelView2 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInListModelView2 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInListModelView2 open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Sequenceable List'
          #name: 'Sequenceable List'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 758 232 1058 532)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SelectionInListModelViewSpec
              #name: 'SelectionInListModelView1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #listModel: #list
              #useIndex: false
              #highlightMode: #line
            )
           )
         
        )
      )
! !

!GUIDemoSelectionInListModelView3 methodsFor:'aspects'!

list
    ||

    list notNil ifTrue:[^ list].

    list := List new.

    list add:(Item category:'Language' inList:list ).
    list add:(Item named:'english' inList:list ).
    list add:(Item named:'german'  inList:list ).
    list add:(Item named:'italian' inList:list ).

    list add:(Item category:'Style' inList:list ).
    list add:(Item named:'mswindows' inList:list ).
    list add:(Item named:'motif'     inList:list ).
    list add:(Item named:'iris'      inList:list ).

    list add:(Item category:'Font' inList:list ).
    list add:(Item named:'courier'   inList:list ).
    list add:(Item named:'helvetica' inList:list ).
    list add:(Item named:'lucida'    inList:list ).
    list add:(Item named:'times'     inList:list ).

    ^ list
! !

!GUIDemoSelectionInListModelView3::Item class methodsFor:'constants'!

horizontalInset
    "inset of label (not category)
    "
    ^ 100
!

verticalInset
    ^ 2
! !

!GUIDemoSelectionInListModelView3::Item class methodsFor:'instance creation'!

category:aCategory inList:aList
    ^ self category:aCategory named:nil inList:aList
!

category:aCategory named:aLabel inList:aList
    |item|

    item := self new.
    item category:aCategory named:aLabel.
    item parent:aList.
  ^ item
!

named:aLabel inList:aList
    ^ self category:nil named:aLabel inList:aList
! !

!GUIDemoSelectionInListModelView3::Item methodsFor:'accessing'!

category
    ^ category
!

label
    ^ label
! !

!GUIDemoSelectionInListModelView3::Item methodsFor:'displaying'!

displayOn:aGC x:x y:y h:h
    "draw myself in the graphicsContext, aGC.
    "
    |y0 vI hI|

    vI := self class verticalInset.
    y0 := y + vI + (aGC font ascent).
    hI := self class horizontalInset.

    category notNil ifTrue:[
        category allBold displayOn:aGC x:x y:y0.
    ].

    label notNil ifTrue:[
        label displayOn:aGC x:(x + hI) y:y0
    ].

    self isLastInCategory ifTrue:[
        y0 := y + h - vI.
        aGC displayLineFromX:x y:y0 toX:(aGC width - 4) y:y0.
    ].
!

heightOn:aGC

    height isNil ifTrue:[
        height := self label heightOn:aGC.
        height := self class verticalInset * 2 + height
    ].
    ^ height
!

widthOn:aGC
    width isNil ifTrue:[
        width := super widthOn:aGC.
        label notNil ifTrue:[
            width := width + self class horizontalInset.
        ]
    ].
    ^ width
! !

!GUIDemoSelectionInListModelView3::Item methodsFor:'instance creation'!

category:aCategory named:aLabel

    label    := aLabel.
    category := aCategory.
! !

!GUIDemoSelectionInListModelView3::Item methodsFor:'queries'!

isLastInCategory
    "returns true if i'am the last entry in a category
    "
    |listIdx sibling|

    parent isNil ifTrue:[^ false].

    listIdx := parent identityIndexOf:self.
    sibling := parent at:(listIdx + 1) ifAbsent:nil.

  ^ (sibling isNil or:[sibling category notNil])
!

isSelectable
    ^ label notNil
! !

!GUIDemoSelectionInListModelView3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoSelectionInListModelView3.st,v 1.1 2002-10-25 10:39:54 ca Exp $'
! !
