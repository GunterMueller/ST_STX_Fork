"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoTableListView2
	instanceVariableNames:'tableWidget itemList'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

Object subclass:#Item
	instanceVariableNames:'name address phone'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoTableListView2
!

!GUIDemoTableListView2 class methodsFor:'documentation'!

documentation
"
    This demo shows a table list with multiple columns. The implicit first
    column is not shown. The columns resize automatically with the view.

    [author:]
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
    CodingExamples_GUI::GUIDemoTableListView2 open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!GUIDemoTableListView2 class methodsFor:'interface specs'!

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

!GUIDemoTableListView2 class methodsFor:'tableColumns specs'!

columnsDescription
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:CodingExamples_GUI::GUIDemoTableListView2 andSelector:#columnsDescription
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Name'
         labelButtonType: Button
         width: 0.3
         minWidth: 100
         model: name
         menuFromApplication: false
       )
      (DataSetColumnSpec
         label: 'Address'
         labelButtonType: Button
         width: 0.7
         minWidth: 100
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
      )
    
! !

!GUIDemoTableListView2 methodsFor:'accessing'!

tableWidget
    ^ tableWidget
! !

!GUIDemoTableListView2 methodsFor:'aspects'!

itemList
    itemList isNil ifTrue:[
        itemList := List new.
        itemList 
            add: (Item new name: 'Joe Doe' address: 'Berkeley, CA' phone: '123456789');
            add: (Item new name: 'Hamish MacDough' address: 'Uig' phone: '+44 123456789');
            add: (Item new name: 'Ivan Zimovic Zimov' address: 'Poljanka' phone: 'N/A').
    ].
    ^ itemList

    "Modified: / 24-04-2013 / 12:20:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView2 methodsFor:'initialization & release'!

postBuildListView: theWidget
    |renderer|

    tableWidget := theWidget.
    tableWidget delegate: self.
    renderer := tableWidget setupTableRenderer.
    renderer
        showItemInAdditionToColumns: false;
        columnDescriptors:(self class columnsDescription).

    "Created: / 22-04-2013 / 11:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-04-2013 / 13:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GUIDemoTableListView2::Item methodsFor:'accessing'!

address
    ^ address
!

address:something
    address := something.
!

name
    ^ name
!

name:something
    name := something.
!

name:nameArg address:addressArg phone:phoneArg 
    name := nameArg.
    address := addressArg.
    phone := phoneArg.
!

phone
    ^ phone
!

phone:something
    phone := something.
! !

!GUIDemoTableListView2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoTableListView2.st,v 1.3 2014-03-15 10:32:29 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoTableListView2.st,v 1.3 2014-03-15 10:32:29 vrany Exp $'
! !

