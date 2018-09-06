"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoTableTreeView
	instanceVariableNames:'tableWidget itemList'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

HierarchicalItemWithLabel subclass:#Item
	instanceVariableNames:'index indices'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoTableTreeView
!

!GUIDemoTableTreeView class methodsFor:'documentation'!

documentation
"
    This demo shows a table tree with multiple columns. The last column
    (the yellowish with green balls) is drawn by custom drawing code, which
    is specified in the column spec by #drawSelector property.

    It also demostrates how to how to do a custom handling of events,
    in this case button presses. If you click inside last column,
    the corresponding cell should flash. This is implemented in

        GUIDemoTableTreeView::Item>>processButtonPress:button x:x y:y on: view

    [author:]
        Claus Atzkern
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    CodingExamples_GUI::GUIDemoTableTreeView open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!GUIDemoTableTreeView class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ExTableWidget andSelector:#windowSpec
     ExTableWidget new openInterface:#windowSpec
     ExTableWidget open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'ExTableWidget'
          name: 'ExTableWidget'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 762 300)
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'HierarchicalListView1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: itemList
              useIndex: false
              highlightMode: line
              postBuildCallback: postBuildTreeView:
            )
           )
         
        )
      )
! !

!GUIDemoTableTreeView class methodsFor:'tableColumns specs'!

columnsDescription
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:ExTableWidget andSelector:#columnsDescription
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Address'
         labelButtonType: Button
         width: 200
         model: address
         menuFromApplication: false
       )
      (DataSetColumnSpec
         label: 'Phone'
         labelButtonType: Button
         width: 200
         model: phone
         menuFromApplication: false
       )
      (DataSetColumnSpec
         label: 'Balls'
         labelButtonType: Button
         menuFromApplication: false
         canSelect: false
         model: phone
         drawSelector: displayBallsOn:x:y:width:height:
       )
      )

    "Modified: / 17-04-2013 / 15:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableTreeView methodsFor:'accessing'!

tableWidget
    ^ tableWidget
! !

!GUIDemoTableTreeView methodsFor:'aspects'!

itemList
    itemList isNil ifTrue:[
        itemList := HierarchicalList new.
        itemList application: self.
        itemList root:( Item indices:#( 1 ) ).
    ].
    ^ itemList
! !

!GUIDemoTableTreeView methodsFor:'initialization & release'!

postBuildTreeView: theWidget
    |renderer|

    tableWidget := theWidget.
    renderer := tableWidget setupTableRenderer.
    renderer
        columnDescriptors:(self class columnsDescription).

    "Modified: / 17-04-2013 / 15:55:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableTreeView::Item class methodsFor:'instance creation'!

indices:aSeqCollOfIntegers
    ^ self indices:aSeqCollOfIntegers parent:nil
!

indices:aSeqCollOfIntegers parent:aParent
    |item|
    item := self parent: aParent.
    item indices:aSeqCollOfIntegers.
    ^ item
! !

!GUIDemoTableTreeView::Item methodsFor:'accessing'!

indices: aSeqCollOfIntegers
    indices := aSeqCollOfIntegers ? #().
! !

!GUIDemoTableTreeView::Item methodsFor:'displaying'!

address
    |item list|

    list := OrderedCollection new.
    item := self.
    
    [item isHierarchicalItem ] whileTrue:[
        list add: (item label).
        item := item parent.
    ].
    ^ list
!

children
    children notNil  ifTrue:[ ^ children ].
    indices size > 4 ifTrue:[ ^ children := #() ].

    children := OrderedCollection new.
    1 to: 4 do:[:i||subitem|
        subitem := self class indices:(indices copyWith: i) parent:self.
        children add:subitem.
    ].
    ^ children
!

displayBallsOn:aGC x:x y:y width:w height:h
   ^self displayBallsOn:aGC x:x y:y width:w height:h fg: Color green bg: Color yellow

    "Created: / 17-04-2013 / 15:12:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-04-2013 / 16:23:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayBallsOn:aGC x:x y:y width:w height:h fg: fg bg: bg
    | h3 |

    h3 := ((h min: w) / 3) rounded.    
    aGC paint: bg.
    aGC fillRectangleX: x y: y width: w height: h.

    aGC paint: fg.
    aGC fillCircleX: x + h3 + 2 y: y + h3 + 2 radius: h3.
    aGC fillCircleX: x + w - h3 - 2 y: y + h - h3 - 2 radius: h3.

    "Created: / 17-04-2013 / 16:23:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

heightOn: aGC
    height isNil ifTrue:[ |lnHeight|
        lnHeight := 'DUMMY' heightOn: aGC.
        height := lnHeight * (indices size max:1).
    ].
    ^ height
!

label
    label isNil ifTrue:[ |stream|
        stream := '' writeStream.
        stream nextPutAll:'N'.
        indices do:[:i| stream nextPut: $_. i printOn: stream. ].
        label := stream contents.
    ].
    ^ label
!

phone
    ^ indices collect:[:e | e asString ].
! !

!GUIDemoTableTreeView::Item methodsFor:'protocol-event processing'!

processButtonPress:button visibleX:x visibleY:y on: view
    "a mouse button was pressed in my label.
     Return true, if the event is eaten (ignored by the gc).
     By default, false is returned (should be handled by the gc)."

    (view listRenderer xVisibleToColumnIndex: x) == 4 "balls" ifTrue:[ 
        | bbox |

        bbox := view listRenderer boundingBoxForCellAtXVisible:x yVisible:y.
        bbox isNil ifTrue:[
            self error: 'Should not happen'
        ].
        self displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height fg: Color yellow bg: Color green.
        Delay waitForMilliseconds: 200.
        self displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height fg: Color blue bg: Color cyan.
        Delay waitForMilliseconds: 200.
        self displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height.

        ^ true 
    ].

    ^ false

    "Created: / 18-04-2013 / 09:57:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableTreeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoTableTreeView.st,v 1.2 2013-04-18 09:11:24 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoTableTreeView.st,v 1.2 2013-04-18 09:11:24 vrany Exp $'
! !

