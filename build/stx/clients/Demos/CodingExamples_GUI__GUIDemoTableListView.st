"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoTableListView
	instanceVariableNames:'tableWidget itemList'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

HierarchicalItem subclass:#Item
	instanceVariableNames:'index indices label'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoTableListView
!

!GUIDemoTableListView class methodsFor:'documentation'!

documentation
"
    This demo shows a table list with multiple columns. The last column
    (the yellowish with green balls) is drawn by custom drawing code, which
    is specified in the column spec by #drawSelector property.

    It also demostrates how to how to do a custom handling of events,
    in this case button presses. If you click inside last column,
    the corresponding cell should flash. This is implemented in

        GUIDemoTableListView>>buttonPress:button x:x y:y view: view

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
    CodingExamples_GUI::GUIDemoTableListView open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!GUIDemoTableListView class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoTableListView andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoTableListView new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoTableListView open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Table List Demo'
          name: 'Table List Demo'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 762 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SelectionInListModelViewSpec
              name: 'SelectionInListModelView1'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: itemList
              useIndex: false
              highlightMode: line
              postBuildCallback: postBuildListView:
            )
           )
         
        )
      )
! !

!GUIDemoTableListView class methodsFor:'tableColumns specs'!

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

!GUIDemoTableListView methodsFor:'accessing'!

tableWidget
    ^ tableWidget
! !

!GUIDemoTableListView methodsFor:'aspects'!

itemList
    itemList isNil ifTrue:[
        itemList := List new.
        1 to: 5 do:[:i|
            itemList add: ( Item indices: (1 to: i) )
        ].
    ].
    ^ itemList

    "Modified: / 22-04-2013 / 12:00:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView methodsFor:'event processing'!

buttonPress:button x:x y:y view:view

    (view listRenderer xAbsoluteToColumnIndex: x) == 4 ifTrue:[
        | row item bbox |

        row := view yVisibleToRowNr: y.
        row isNil ifTrue:[ ^ self ].
        item := view at: row.

        bbox := view listRenderer boundingBoxForCellAtXVisible:x yVisible:y.
        item displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height fg: Color yellow bg: Color green.
        Delay waitForMilliseconds: 200.
        item displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height fg: Color blue bg: Color cyan.
        Delay waitForMilliseconds: 200.
        item displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height.
    ] ifFalse:[
        view buttonPress:button x:x y:y
    ]

    "Created: / 22-04-2013 / 12:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlesButtonPress:button inView:aView
    ^aView == tableWidget scrolledView

    "Created: / 22-04-2013 / 12:03:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView methodsFor:'initialization & release'!

postBuildListView: theWidget
    |renderer|

    tableWidget := theWidget.
    tableWidget scrolledView delegate: self.
    renderer := tableWidget setupTableRenderer.
    renderer columnDescriptors:(self class columnsDescription).

    "Created: / 22-04-2013 / 11:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-04-2013 / 13:11:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView::Item class methodsFor:'instance creation'!

indices:aSeqCollOfIntegers
    ^ self new indices:aSeqCollOfIntegers

    "Modified: / 22-04-2013 / 12:39:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView::Item methodsFor:'accessing'!

indices: aSeqCollOfIntegers
    indices := aSeqCollOfIntegers ? #().
! !

!GUIDemoTableListView::Item methodsFor:'displaying'!

address
    ^indices asArray

    "Modified: / 22-04-2013 / 12:44:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

displayOn:aGC x:x y:y 
   self label displayOn:aGC x:x y:y

    "Created: / 22-04-2013 / 12:43:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
!

widthOn: aGC
    ^0

    "Created: / 22-04-2013 / 13:01:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView::Item methodsFor:'protocol-event processing'!

processButtonPress:button x:x y:y on: view
    "a mouse button was pressed in my label.
     Return true, if the event is eaten (ignored by the gc).
     By default, false is returned (should be handled by the gc)."

    | x0 y0 |

    "/ x & y are RELATIVE to item's top-left corner.
    "/ boundingBoxForCellAtXAbsolute:x0 yAbsolute:y0 takes absolute values,
    "/ so compensate here...

    "/ is subtracted from the x. Compensate here, sigh.
    x0 := x + (view xVisibleOfTextAtLevel:self level).
    y0 := y + (view yAbsoluteOfLine: (view list indexOf: self)).
    (view listRenderer xAbsoluteToColumnIndex: x0) == 4 "balls" ifTrue:[ 
        | bbox |

        bbox := view listRenderer boundingBoxForCellAtXAbsolute:x0 yAbsolute:y0.
        self displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height fg: Color yellow bg: Color green.
        Delay waitForMilliseconds: 200.
        self displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height fg: Color blue bg: Color cyan.
        Delay waitForMilliseconds: 200.
        self displayBallsOn:view x: bbox left y: bbox top width: bbox width height: bbox height.

        ^ true 
    ].

    ^ false

    "Created: / 17-04-2013 / 16:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoTableListView.st,v 1.1 2013-04-22 11:12:05 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoTableListView.st,v 1.1 2013-04-22 11:12:05 vrany Exp $'
! !

