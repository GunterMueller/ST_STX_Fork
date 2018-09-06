"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#MultipleItemSelectionWidget
	instanceVariableNames:'possibleItemsLabelHolder possibleItemListSelection
		listOfPossibleItems selectedItemListSelection
		removeButtonLabelHolder addButtonLabelHolder
		selectedItemsLabelHolder listOfSelectedItems
		canAddItemToSelection canRemoveItemFromSelection
		canAddAllItemsToSelection canRemoveAllItemsFromSelection
		enableChannel accepted addAllButtonLabelHolder
		removeAllButtonLabelHolder removeAllButtonVisibleHolder
		addAllButtonVisibleHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Lists'
!

!MultipleItemSelectionWidget class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Replacement for a multiSelectionInList widget;
    allows construction of a list by adding/removing items.

    For use in a UI-spec, add a subCanvas, and bind the exported aspects to
    your applications aspects.

    [author:]
	 (cg@smc1)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"
								[exBegin]
	|box|

	box := MultipleItemSelectionWidget new.
	box listOfPossibleItems value:#('one' 'two' 'three' 'four' 'five').  
	box listOfSelectedItems value:#().  
	box open.
	box listOfSelectedItems inspect
								[exEnd]


								[exBegin]
	|box|

	box := MultipleItemSelectionWidget new.
	box listOfPossibleItems value:#('one' 'two' 'three' 'four' 'five') asSortedCollection.  
	box listOfSelectedItems value:#() asSortedCollection.  
	box open.
	box listOfSelectedItems inspect
								[exEnd]
"
! !

!MultipleItemSelectionWidget class methodsFor:'interface specs'!

dialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MultipleItemSelectionWidget andSelector:#dialogSpec
     MultipleItemSelectionWidget new openInterface:#dialogSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #dialogSpec
        #window: 
       #(#WindowSpec
          #label: 'dialogSpec'
          #name: 'dialogSpec'
          #min: #(#Point 10 10)
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 16 46 316 346)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#UISubSpecification
              #name: 'SubSpecification1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
              #minorKey: #windowSpec
            )
           #(#HorizontalPanelViewSpec
              #name: 'HorizontalPanel1'
              #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
              #horizontalLayout: #center
              #verticalLayout: #center
              #horizontalSpace: 3
              #verticalSpace: 3
              #reverseOrderIfOKAtLeft: true
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ActionButtonSpec
                    #label: 'Cancel'
                    #name: 'CancelButton'
                    #translateLabel: true
                    #model: #doCancel
                    #extent: #(#Point 125 22)
                  )
                 #(#ActionButtonSpec
                    #label: 'OK'
                    #name: 'OkButton'
                    #translateLabel: true
                    #model: #doAccept
                    #extent: #(#Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MultipleItemSelectionWidget andSelector:#windowSpec
     MultipleItemSelectionWidget new openInterface:#windowSpec
     MultipleItemSelectionWidget open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'NewApplication'
         name: 'NewApplication'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Selected'
             name: 'SelectedLabel'
             layout: (LayoutFrame 0 0.5 0 0 0 1 25 0)
             translateLabel: true
             labelChannel: selectedItemsLabelHolder
           )
          (SequenceViewSpec
             name: 'SelectedList'
             layout: (LayoutFrame 20 0.5 25 0 0 1 0 1)
             enableChannel: enableChannel
             tabable: true
             model: selectedItemListSelection
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             miniScrollerVertical: true
             isMultiSelect: true
             doubleClickSelector: removeItemsFromSelection
             valueChangeSelector: showInfoForItem:
             useIndex: false
             sequenceList: listOfSelectedItems
           )
          (LabelSpec
             label: 'Not Selected'
             name: 'NotSelectedLabel'
             layout: (LayoutFrame 0 0 0 0 0 0.5 25 0)
             translateLabel: true
             labelChannel: possibleItemsLabelHolder
           )
          (SequenceViewSpec
             name: 'NotSelectedList'
             layout: (LayoutFrame 0 0 25 0 -20 0.5 0 1)
             enableChannel: enableChannel
             tabable: true
             model: possibleItemListSelection
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             miniScrollerVertical: true
             isMultiSelect: true
             doubleClickSelector: addItemsToSelection
             valueChangeSelector: showInfoForItem:
             useIndex: false
             sequenceList: listOfPossibleItems
           )
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame -20 0.5 25 0 20 0.5 5 0.5)
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: '>'
                   name: 'AddButton'
                   translateLabel: true
                   labelChannel: addButtonLabelHolder
                   resizeForLabel: false
                   tabable: true
                   model: addItemsToSelection
                   enableChannel: canAddItemToSelection
                   actionValue: ''
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: '<'
                   name: 'RemoveButton'
                   translateLabel: true
                   labelChannel: removeButtonLabelHolder
                   resizeForLabel: false
                   tabable: true
                   model: removeItemsFromSelection
                   enableChannel: canRemoveItemFromSelection
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame -20 0.5 5 0.5 20 0.5 -10 1)
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'All'
                   name: 'AddAllButton'
                   visibilityChannel: addAllButtonVisibleHolder
                   translateLabel: true
                   labelChannel: addAllButtonLabelHolder
                   resizeForLabel: false
                   tabable: true
                   model: addAllItemsToSelection
                   enableChannel: canAddAllItemsToSelection
                   useDefaultExtent: true
                 )
                (ActionButtonSpec
                   label: 'None'
                   name: 'RemoveAllButton'
                   visibilityChannel: removeAllButtonVisibleHolder
                   translateLabel: true
                   labelChannel: removeAllButtonLabelHolder
                   resizeForLabel: false
                   tabable: true
                   model: removeAllItemsFromSelection
                   enableChannel: canRemoveAllItemsFromSelection
                   actionValue: ''
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!MultipleItemSelectionWidget class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #addButtonLabelHolder
        #enableChannel
        #listOfPossibleItems
        #listOfSelectedItems
        #possibleItemsLabelHolder
        #removeButtonLabelHolder
        #selectedItemsLabelHolder
      ).

! !

!MultipleItemSelectionWidget methodsFor:'actions'!

accept
    "only invoked if opened as modal box..."

    accepted := true.
    self closeRequest.
!

addAllItemsToSelection
    "add all items from unselected to the selected list"

    |newSel|

    newSel := self listOfSelectedItems value asOrderedCollection
	      , self listOfPossibleItems value asOrderedCollection.

    self listOfSelectedItems value:newSel asSortedCollection.
    self listOfPossibleItems value:(#() asSortedCollection).
!

addItemsToSelection
    "add selected items from left list to the right list"

    |sel t selectedItemList possibleItemList|

    sel := self possibleItemListSelection value.
    sel notEmptyOrNil ifTrue:[
        selectedItemList := self listOfSelectedItems. 
        t := selectedItemList value copy.
        t addAll:sel.
        selectedItemList value:t.

        possibleItemList := self listOfPossibleItems. 
        t := possibleItemList value copy.
        t removeAll:sel.
        possibleItemList value:t.

        self possibleItemListSelection value:#()
    ]
!

cancel
    "only invoked if opened as modal box..."

    accepted := false.
    self closeRequest.
!

removeAllItemsFromSelection
    "remove all items from selected to the unselected list"

    |newRem|

    newRem := self listOfSelectedItems value asOrderedCollection
	      , self listOfPossibleItems value asOrderedCollection.

    self listOfPossibleItems value:newRem asSortedCollection.
    self listOfSelectedItems value:(#() asSortedCollection).
!

removeItemsFromSelection
    "remove selected items from right list to the left list"

    |sel t selectedItemList possibleItemList|

    sel := self selectedItemListSelection value.
    sel size > 0 ifTrue:[
        possibleItemList := self listOfPossibleItems. 
        t := possibleItemList value copy.
        t addAll:sel.
        possibleItemList value:t.

        selectedItemList := self listOfSelectedItems. 
        t := selectedItemList value copy.
        t removeAll:sel.
        selectedItemList value:t.

        self selectedItemListSelection value:#()
    ]
!

showInfoForItem:anArgument
! !

!MultipleItemSelectionWidget methodsFor:'aspects'!

accepted
    ^ accepted == true
!

addAllButtonVisibleHolder
    <resource: #uiAspect>

    addAllButtonVisibleHolder isNil ifTrue:[
        addAllButtonVisibleHolder := true asValue.
    ].
    ^ addAllButtonVisibleHolder.
!

canAddAllItemsToSelection
    canAddAllItemsToSelection isNil ifTrue:[
       canAddAllItemsToSelection := BlockValue with:[:m | m size > 0]
                                    argument:self listOfPossibleItems 
    ].
    ^ canAddAllItemsToSelection.

    "Modified: / 08-03-2007 / 22:59:51 / cg"
!

canAddItemToSelection
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    canAddItemToSelection isNil ifTrue:[
        canAddItemToSelection := BlockValue 
                                    with:[:m | m size > 0]
                                    argument:self possibleItemListSelection 
    ].
    ^ canAddItemToSelection.

    "Modified: / 08-03-2007 / 22:59:54 / cg"
!

canRemoveAllItemsFromSelection
    canRemoveAllItemsFromSelection isNil ifTrue:[
       canRemoveAllItemsFromSelection := BlockValue with:[:m | m size > 0]
                                    argument:self listOfSelectedItems 
    ].
    ^ canRemoveAllItemsFromSelection.

    "Modified: / 08-03-2007 / 22:59:58 / cg"
!

canRemoveItemFromSelection
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    canRemoveItemFromSelection isNil ifTrue:[
        canRemoveItemFromSelection := BlockValue 
                                        with:[:m | m size > 0]
                                        argument:self selectedItemListSelection 
    ].
    ^ canRemoveItemFromSelection.

    "Modified: / 08-03-2007 / 23:00:01 / cg"
!

enableChannel
    enableChannel isNil ifTrue:[
       enableChannel := true asValue 
    ].
    ^ enableChannel.
!

enableChannel:aChannel
    enableChannel := aChannel
!

listOfPossibleItems
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    listOfPossibleItems isNil ifTrue:[
        listOfPossibleItems := #() asValue.
    ].
    ^ listOfPossibleItems.
!

listOfPossibleItems:aValueHolder
   listOfPossibleItems := aValueHolder.
!

listOfSelectedItems
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    listOfSelectedItems isNil ifTrue:[
        listOfSelectedItems := #() asValue.
    ].
    ^ listOfSelectedItems.
!

listOfSelectedItems:aValueHolder
   listOfSelectedItems := aValueHolder.
!

possibleItemListSelection
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    possibleItemListSelection isNil ifTrue:[
        possibleItemListSelection := #() asValue.
    ].
    ^ possibleItemListSelection.
!

removeAllButtonVisibleHolder
    <resource: #uiAspect>

    removeAllButtonVisibleHolder isNil ifTrue:[
        removeAllButtonVisibleHolder := true asValue.
    ].
    ^ removeAllButtonVisibleHolder.
!

selectedItemListSelection
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    selectedItemListSelection isNil ifTrue:[
       selectedItemListSelection := #() asValue.
    ].
    ^ selectedItemListSelection.
! !

!MultipleItemSelectionWidget methodsFor:'aspects-look'!

addAllButtonLabelHolder
    addAllButtonLabelHolder isNil ifTrue:[
       addAllButtonLabelHolder := 'All' asValue.
    ].
    ^ addAllButtonLabelHolder.
!

addButtonLabelHolder
    addButtonLabelHolder isNil ifTrue:[
       addButtonLabelHolder := '>>>' asValue.
    ].
    ^ addButtonLabelHolder.
!

addButtonLabelHolder:aValueHolder
    addButtonLabelHolder := aValueHolder

!

possibleItemsLabelHolder
    possibleItemsLabelHolder isNil ifTrue:[
       possibleItemsLabelHolder :=  ValueHolder new.
    ].
    ^ possibleItemsLabelHolder.
!

possibleItemsLabelHolder:aValueHolder
    possibleItemsLabelHolder := aValueHolder

!

removeAllButtonLabelHolder
    removeAllButtonLabelHolder isNil ifTrue:[
       removeAllButtonLabelHolder := 'None' asValue.
    ].
    ^ removeAllButtonLabelHolder.
!

removeButtonLabelHolder
    removeButtonLabelHolder isNil ifTrue:[
       removeButtonLabelHolder := '<<<' asValue
    ].
    ^ removeButtonLabelHolder.
!

removeButtonLabelHolder:aValueHolder
    removeButtonLabelHolder := aValueHolder

!

selectedItemsLabelHolder
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    selectedItemsLabelHolder isNil ifTrue:[
       selectedItemsLabelHolder :=  ValueHolder new.
    ].
    ^ selectedItemsLabelHolder.
!

selectedItemsLabelHolder:aValueHolder
    selectedItemsLabelHolder := aValueHolder
! !

!MultipleItemSelectionWidget class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

