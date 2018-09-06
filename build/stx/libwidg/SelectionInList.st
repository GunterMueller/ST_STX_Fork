"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

ValueHolder subclass:#SelectionInList
	instanceVariableNames:'listHolder selectionIndexHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!SelectionInList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Instances of SelectionInList can be used as model for
    a SelectionInListView or a PopUpList. 
    They keep two values: a list value and a selection value; 
    both are referred to via valueHolders.

    If any of those two changes, the selectionInList notifies its 
    dependents via a change notification, 
    using #list or #selectionIndex as update aspect respectively.

    A popupList also knows how to deal with a selectionInList model;
    this makes it possible to have popupLists be somewhat exchangable
    with selectionInListViews.

    SelectionInLists only support a single selection within the list;
    use MultiSelectionInList, if multiple selections are needed.

    [instance variables:]
        listHolder              <ValueHolder>           holds the list
        selectionIndexHolder    <ValueHolder>           holdes the selectionIndex


    [see also:]
        SelectionInListView PopUpList
        MultiSelectionInList Model ValueHolder

    [author:]
        Claus Gittinger
"
!

examples
"
  basic setup using a selectionInList as model of a selectionInListView:
                                                                        [exBegin]
    |m v|

    m := SelectionInList new.
    m list:#('one' 'two' 'three' 'four').
    m selectionIndex:2.

    v := SelectionInListView on:m.
    v open
                                                                        [exEnd]


  similar, a selectionInList as model of a popUpList:
                                                                        [exBegin]
    |m v|

    m := SelectionInList new.
    m list:#('one' 'two' 'three' 'four').
    m selectionIndex:2.

    v := PopUpList on:m.
    v open
                                                                        [exEnd]


  using a combination-instance creation method:
                                                                        [exBegin]
    |m v|

    m := SelectionInList 
                with:#('one' 'two' 'three' 'four')
                initialSelection:2.

    v := PopUpList on:m.
    v open
                                                                        [exEnd]


  two different views on the same selectionInList model:
                                                                        [exBegin]
    |m v1 v2|

    m := SelectionInList new.
    m list:#('one' 'two' 'three' 'four').
    m selectionIndex:2.

    v1 := PopUpList on:m.
    v1 open.

    v2 := SelectionInListView on:m.
    v2 open
                                                                        [exEnd]


  two views on the same selectionInList:
  and a button, which adds an item to the list.
                                                                        [exBegin]
    |m v1 v2 b numItems|

    numItems := 4.

    m := SelectionInList new.
    m list:((1 to:numItems) collect:[:i | i printString]).
    m selectionIndex:2.

    v1 := ScrollableView forView:(SelectionInListView on:m).
    v1 open.

    v2 := ScrollableView forView:(SelectionInListView on:m).
    v2 open.

    b := Button label:'add item'.
    b action:[numItems := numItems + 1.
              m list:((1 to:numItems) collect:[:i | i printString]).
             ].
    b open
                                                                        [exEnd]
"
! !

!SelectionInList class methodsFor:'instance creation'!

with:aList
    "return a new instance holding aList"

    ^ self new listHolder:(ValueHolder with:aList)

    "Modified: / 21.5.1998 / 03:17:16 / cg"
!

with:aList initialSelection:index
    "return a new instance holding aList and initially selecting
     the item at index."

    ^ (self with:aList) 
        selectionIndexHolder:(ValueHolder with:index)

    "Created: / 24.4.1996 / 08:47:33 / cg"
    "Modified: / 21.5.1998 / 03:17:31 / cg"
! !

!SelectionInList methodsFor:'accessing-holders'!

listHolder
    "return the valueHolder which holds the list"

    ^ listHolder

    "Modified: 24.4.1996 / 08:39:44 / cg"
!

listHolder:aValueHolder
    "set the valueHolder which holds the list.
     Q: should we forward a change-notification ?"

    listHolder notNil ifTrue:[
        listHolder removeDependent:self
    ].
    listHolder := aValueHolder.
    listHolder addDependent:self

    "Modified: 24.4.1996 / 08:39:59 / cg"
!

selectionHolder
    "return someone holding on the selection itself (not the index). 
     Since we have no one, create an adapter, to get up-to-date values."

    ^ AspectAdaptor 
        subject:self 
        sendsUpdates:false
        accessWith:#selection 
        assignWith:#'selection:' 
        aspect:#selectionIndex

    "Modified: 24.4.1996 / 08:40:19 / cg"
!

selectionIndexHolder
    "return the valueHolder which holds the index"

    ^ selectionIndexHolder

    "Modified: 24.4.1996 / 08:40:31 / cg"
!

selectionIndexHolder:aValueHolder
    "set the valueHolder which holdes the index.
     Q: should we forward a change-notification ?"

    selectionIndexHolder notNil ifTrue:[
        selectionIndexHolder removeDependent:self
    ].
    selectionIndexHolder := aValueHolder.
    selectionIndexHolder addDependent:self

    "Modified: 24.4.1996 / 08:40:42 / cg"
! !

!SelectionInList methodsFor:'accessing-values'!

list
    "return the list - that's the thingy held by the listHolder"

    ^ listHolder value

    "Modified: 24.4.1996 / 08:41:05 / cg"
!

list:aCollection
    "set the list - that's the thingy held by the listHolder"

    aCollection == listHolder value ifTrue:[
        "/ same value set again - send change notification
        "/ manually (valueHolder does not ...)
        listHolder changed.
    ] ifFalse:[               
        aCollection isList ifTrue:[
            self listHolder:aCollection.
            listHolder changed.
        ] ifFalse:[
            listHolder isList ifTrue:[
                listHolder contents:aCollection.
            ] ifFalse:[
                listHolder value:aCollection.
            ]
        ]
"/        listHolder value:aCollection.
    ].

    "Modified: / 2.2.1998 / 13:05:56 / cg"
!

selection
    "return the selections value (i.e. the entry in the list - not its index).
     If nothing is selected, nil is returned."

    |idx|

    idx := self selectionIndex.
    (idx isNil or:[idx == 0]) ifTrue:[^ nil].
    ^ self list at:idx

    "Modified: 24.4.1996 / 08:53:23 / cg"
!

selection:anObject 
    "set the selection to be anObject.
     If anObject is not in the list, the selection is cleared"

    ^ self selectionIndex:(self list indexOf:anObject ifAbsent:0)
!

selectionIndex
    "return the selections index (1..). 
     That's the thingy held by the indexHolder.
     For ST-80 compatibility, 0 is returned if nothing is selected."

    ^ selectionIndexHolder value

    "Modified: 24.4.1996 / 08:53:45 / cg"
!

selectionIndex:newIndex
    "set the selectionIndex"

    selectionIndexHolder value ~= newIndex ifTrue:[
        selectionIndexHolder value:newIndex
    ]

    "Modified: 24.4.1996 / 08:42:04 / cg"
! !

!SelectionInList methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "whenever one of my holders value changes,
     tell my dependents about this"

    |oldSelection|

    changedObject == selectionIndexHolder ifTrue:[
        self changed:#selectionIndex
    ] ifFalse:[
        changedObject == listHolder ifTrue:[
            (something == #value 
            or:[ listHolder isList ])
            ifTrue:[
                oldSelection := selectionIndexHolder value.
                self clearSelection.  "/ clears without update
                self changed:#list.
                oldSelection ~= (selectionIndexHolder value) ifTrue:[
                    selectionIndexHolder changed:#value
                ]
            ]
        ]
    ]

    "Modified: 20.4.1996 / 13:08:32 / cg"
! !

!SelectionInList methodsFor:'initialization'!

initialize
    "initialize; create the valueHolders for the index and the list"

    self listHolder:(ValueHolder with:List new).
    self selectionIndexHolder:(ValueHolder with:self zeroIndex).

    "Modified: / 21.5.1998 / 03:17:56 / cg"
! !

!SelectionInList methodsFor:'obsolete-backward compatibility'!

index
    "return the selections index.
     This is an OBSOLETE backward compatibility interface"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #selectionIndex'.
    ^ self selectionIndex

    "Modified: 24.4.1996 / 08:43:10 / cg"
!

index:newIndex
    "set the selections index.
     This is an OBSOLETE backward compatibility interface"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #selectionIndex:'.
    ^ self selectionIndex:newIndex

    "Modified: 24.4.1996 / 08:43:06 / cg"
!

indexHolder
    "return the valueHolder of the selections index.
     This is an OBSOLETE backward compatibility interface"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #selectionIndexHolder'.
    ^ self selectionIndexHolder

    "Modified: 24.4.1996 / 08:43:35 / cg"
!

indexHolder:aValueHolder
    "set the valueHolder of the selections index.
     This is an OBSOLETE backward compatibility interface"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #selectionIndexHolder:'.
    ^ self selectionIndexHolder:aValueHolder

    "Modified: 24.4.1996 / 08:43:43 / cg"
! !

!SelectionInList methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPut:$(.
    self selectionIndex displayOn:aGCOrStream. 
    aGCOrStream nextPut:$)
! !

!SelectionInList methodsFor:'private'!

clearSelection
    "clear the selection.
     For ST-80 compatibility, a non-selection has an index of 0
     although, nil sounds more natural to me ... (sigh)"

    selectionIndexHolder setValue:self zeroIndex.

    "Modified: 24.4.1996 / 08:44:37 / cg"
! !

!SelectionInList methodsFor:'queries'!

hasSelection
    "return true, if there is a selection
    "
    ^ self numberOfSelections ~~ 0
!

numberOfSelections
    "return the number of selected entries
    "
    |s|

    s:= selectionIndexHolder value.
    ^ (s ~~ 0 and:[s notNil]) ifTrue:[1] ifFalse:[0]
!

zeroIndex
    "return the selections index returned when nothing
     is selected. This method is provided to allow applications
     to deal transparently with SelectionInList models AND with
     MultSelectionInList models, which use different no-selection values.
     Although I would prefer nil, ST-80 uses 0 to represent `no-selection'. (sigh)"

    ^ 0

    "Created: 20.4.1996 / 13:10:53 / cg"
    "Modified: 24.4.1996 / 08:46:18 / cg"
! !

!SelectionInList class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

