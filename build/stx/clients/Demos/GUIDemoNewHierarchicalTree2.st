"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoNewHierarchicalTree2
	instanceVariableNames:'listOfItems'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

HierarchicalItem subclass:#Item
	instanceVariableNames:'toggle'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoNewHierarchicalTree2
!


!GUIDemoNewHierarchicalTree2 class methodsFor:'interface - specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoNewHierarchicalTree2 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree2 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree2 open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Hierarchical Tree'
          #name: 'Hierarchical Tree'
          #min: #(#Point 10 10)
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 545 427 845 727)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#HierarchicalListViewSpec
              #name: 'HierarchicalListView1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #model: #selectionHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #listModel: #listOfItems
              #useIndex: false
              #highlightMode: #label
              #doubleClickSelector: #indicatorClicked:
              #indicatorSelector: #indicatorClicked:
            )
           )
         
        )
      )
! !

!GUIDemoNewHierarchicalTree2 methodsFor:'actions'!

indicatorClicked:anIndex
    |item|

    item := listOfItems at:anIndex ifAbsent:nil.
    item ifNotNil:[ item toggleExpand ].
! !

!GUIDemoNewHierarchicalTree2 methodsFor:'aspects'!

listOfItems

    listOfItems isNil ifTrue:[
        listOfItems := HierarchicalList new.
        listOfItems root:(Item new).
    ].
    ^ listOfItems.
! !

!GUIDemoNewHierarchicalTree2::Item class methodsFor:'constants'!

textInset
    ^ 8
! !

!GUIDemoNewHierarchicalTree2::Item class methodsFor:'image specs'!

toggleOffIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self toggleOffIcon inspect
     ImageEditor openOnClass:self andSelector:#toggleOffIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'CodingExamples_GUI::GUIDemoNewHierarchicalTree2::Item class toggleOffIcon'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ HB@ HB@ HB@@HA@PDA@PDA@PDA@0@B@P@@@@@@@@@@@@L@@ D@@@@@@@@@@@@C@@HA@@@@@@@@@@@@@0@B@P@@@@@@@@@@@@L@@ D@@@@@@@@@@@@C
@@HA@@@@@@@@@@@@@0@B@P@@@@@@@@@@@@L@@ D@@@@@@@@@@@@C@@HA@@@@@@@@@@@@@0@B@0LC@0LC@0LC@0L@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 0 0 0 128 128 128 192 192 192]; yourself]
!

toggleOnIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self toggleOnIcon inspect
     ImageEditor openOnClass:self andSelector:#toggleOnIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'CodingExamples_GUI::GUIDemoNewHierarchicalTree2::Item class toggleOnIcon'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ HB@ HB@ HB@@HA@PDA@PDA@PDA@0@B@P@@@@@@@@@@@@L@@ D@@@@@@@@@@P@C@@HA@@@@@@@@@PD@@0@B@P@A@@@@@PDA@@L@@ D@@PD@@PDA@@@C
@@HA@@DA@PDA@@@@@0@B@P@@@PDA@@@@@@L@@ D@@@@A@@@@@@@C@@HA@@@@@@@@@@@@@0@B@0LC@0LC@0LC@0L@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[255 255 255 0 0 0 128 128 128 192 192 192]; yourself]
! !

!GUIDemoNewHierarchicalTree2::Item methodsFor:'accessing'!

children
    "auto creation of children
    "
    |size|

    children isNil ifTrue:[
        size := 5 - (self level).

        size > 0 ifTrue:[
            size     := size max:3.
            children := Array new:size.

            1 to:size do:[:i|
                children at:i put:(self class new parent:self)
            ].
        ] ifFalse:[
            children := #()
        ].
    ].
    ^ children
!

label
    "returns my label, same for all items
    "
    ^ 'Item'
! !

!GUIDemoNewHierarchicalTree2::Item methodsFor:'displaying'!

displayOn:aGC x:x y:y h:h
    "draw myself in the graphicsContext, aGC.
    "
    |inset|

    toggle displayOn:aGC x:x y:(h - toggle height // 2 + y).
    inset := (self class textInset) + toggle width.

    super displayOn:aGC x:(x + inset) y:y h:h
!

heightOn:aGC
    "return the height on aGC including the toggle height
    "
    height isNil ifTrue:[
        height := (self label heightOn:aGC) max:(toggle height)
    ].
    ^ height
!

widthOn:aGC
    "return the height on aGC including the toggle width
    "
    width isNil ifTrue:[
        width  := self label widthOn:aGC.
        width  := width + (toggle width) + (self class textInset).
    ].
    ^ width
! !

!GUIDemoNewHierarchicalTree2::Item methodsFor:'event processing'!

processButtonPress:button x:x y:y
    "a mouse button was pressed in my label.
     Return true, if I have eaten the event.
    "
    |onIcon offIcon|

    "/ test whether toggle is pressed
    x > toggle width ifTrue:[^ false].

    onIcon  := self class toggleOnIcon.
    offIcon := self class toggleOffIcon.

    toggle == onIcon ifTrue:[ toggle := offIcon ]
                    ifFalse:[ toggle := onIcon  ].
    self changed:#redraw.
  ^ true
! !

!GUIDemoNewHierarchicalTree2::Item methodsFor:'initialization'!

initialize
    super initialize.
    toggle := self class toggleOnIcon.
! !

!GUIDemoNewHierarchicalTree2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoNewHierarchicalTree2.st,v 1.1 2002-10-18 11:58:03 ca Exp $'
! !
