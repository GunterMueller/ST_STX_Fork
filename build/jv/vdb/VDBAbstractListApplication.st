"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBAbstractListApplication
	instanceVariableNames:'internalListHolder internalListView internalSelectionHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Abstract'
!

!VDBAbstractListApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBAbstractListApplication class methodsFor:'interface specs'!

columnsSpec
    ^ #()

    "Created: / 02-06-2017 / 07:26:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBAbstractListApplication andSelector:#windowSpec
     VDBAbstractListApplication new openInterface:#windowSpec
     VDBAbstractListApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: '0f7dc3f0-3c2f-11e8-93ae-0021ccd5e3d3'
       window: 
      (WindowSpec
         label: 'VDBAbstractListApplication'
         name: 'VDBAbstractListApplication'
         uuid: '0f7dc3f1-3c2f-11e8-93ae-0021ccd5e3d3'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SelectionInListModelViewSpec
             name: 'SelectionInListModelView1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             uuid: '0f7dc3f2-3c2f-11e8-93ae-0021ccd5e3d3'
             model: internalSelectionHolder
             menu: contextMenu
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             listModel: internalListHolder
             useIndex: false
             highlightMode: line
             doubleClickSelector: doDoubleClick
             selectConditionSelector: internalCanSelect:
             postBuildCallback: postBuildInternalListView:
           )
          )
        
       )
     )

    "Modified: / 09-04-2018 / 20:52:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication class methodsFor:'menu specs'!

contextMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBAbstractListApplication andSelector:#contextMenu
     (Menu new fromLiteralArrayEncoding:(VDBAbstractListApplication contextMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
          (MenuItem
            label: 'Appl Menu Slice'
            isVisible: true
            submenuChannel: contextMenuApplSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Item Menu Slice'
            isVisible: true
            submenuChannel: contextMenuItemSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Copy Menu Slice'
            isVisible: true
            submenuChannel: contextMenuCopySlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Inspect Menu Slice'
            isVisible: true
            submenuChannel: contextMenuInspectSlice
            isMenuSlice: true
          )
         )
        nil
        nil
      )

    "Modified: / 01-09-2018 / 14:36:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contextMenuApplSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBAbstractListApplication andSelector:#contextMenuSlice
     (Menu new fromLiteralArrayEncoding:(VDBAbstractListApplication contextMenuSlice)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        nil nil
        nil
      )

    "Created: / 01-09-2018 / 14:36:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contextMenuCopySlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBAbstractListApplication andSelector:#contextMenuCopySlice
     (Menu new fromLiteralArrayEncoding:(VDBAbstractListApplication contextMenuCopySlice)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Copy Contents To Clipboard'
            itemValue: doCopyContents
            isVisible: true
          )
         (MenuItem
            enabled: hasSelection
            label: 'Copy Selection To Clipboard'
            itemValue: doCopySelection
            isVisible: true
          )
         )
        nil
        nil
      )
!

contextMenuInspectSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBAbstractListApplication andSelector:#contextMenuInspectSlice
     (Menu new fromLiteralArrayEncoding:(VDBAbstractListApplication contextMenuInspectSlice)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasSelection
            label: 'Inspect Model'
            itemValue: doInspectModel
            isVisible: true
          )
         (MenuItem
            label: 'Inspect Presenter'
            itemValue: doInspectPresenter
            isVisible: true
          )
         (MenuItem
            label: 'Inspect Application'
            itemValue: doInspectApplication
            isVisible: true
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            label: 'Update'
            itemValue: duUpdateList
            isVisible: true
          )
         )
        nil
        nil
      )
! !

!VDBAbstractListApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #debuggerHolder
      ).

! !

!VDBAbstractListApplication class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == VDBAbstractListApplication.
! !

!VDBAbstractListApplication methodsFor:'aspects'!

backgroundColorFor: aVDBPresenter
    "Returns an backgdound color for for given presenter.               
     If `nil` returned, a default is used"

    ^ nil

    "Created: / 01-02-2018 / 09:06:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-06-2018 / 13:02:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foregroundColorFor: aVDBPresenter
    "Returns an foreground (text) color for given presenter.
     If `nil` returned, a default is used"

    ^ nil

    "Created: / 26-06-2018 / 13:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'aspects-private'!

internalListHolder
    "return/create the 'listHolder' value holder (automatically generated)"

    internalListHolder isNil ifTrue:[
        internalListHolder := ValueHolder new.
    ].
    ^ internalListHolder

    "Created: / 27-02-2015 / 15:55:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

internalSelectionHolder
    "return/create the 'internalSelectionHolder' value holder (automatically generated)"

    internalSelectionHolder isNil ifTrue:[
        internalSelectionHolder := ValueHolder new.
        internalSelectionHolder addDependent:self.
    ].
    ^ internalSelectionHolder
! !

!VDBAbstractListApplication methodsFor:'change & update'!

enqueueDelayedInvalidateInternalList
    internalListView notNil ifTrue:[
        self enqueueDelayedUpdate: #delayedInvalidateInternalList
    ]

    "Created: / 06-02-2018 / 12:43:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enqueueDelayedUpdateInternalList
   self enqueueDelayedUpdate: #delayedUpdateInternalList

    "Created: / 20-09-2014 / 23:05:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2018 / 06:51:55 / jv"
!

enqueueDelayedUpdateSelection
    self enqueueDelayedUpdate: #delayedUpdateSelection

    "Created: / 27-02-2015 / 15:35:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2018 / 06:52:09 / jv"
!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."
    sender == internalSelectionHolder ifTrue:[ 
        self enqueueDelayedUpdateSelection.
        ^ self
    ].

    super update:aspect with:param from:sender

    "Created: / 27-02-2015 / 15:44:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'change & update-delayed'!

delayedInvalidateInternalList
    internalListView notNil ifTrue:[ 
        internalListView scrolledView invalidateRepairNow: true
    ].

    "Created: / 06-02-2018 / 12:43:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 22:24:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateInternalList
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

delayedUpdateSelection
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!VDBAbstractListApplication methodsFor:'help'!

activeHelpViewFor:text onDevice:aDevice
    | view |

    view := super activeHelpViewFor:text onDevice:aDevice.
    view font: self textFont.
    view subViews do:[:each | each font: self textFont ].
    view resizeToFit.
    ^ view

    "Created: / 01-09-2018 / 12:15:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'help texts'!

flyByHelpTextFor:aView at: aPoint
    | line item |

    line := internalListView yVisibleToLineNr: aPoint y.
    line notNil ifTrue:[ 
        item := internalListView list at: line ifAbsent:[ nil ].
        item notNil ifTrue:[
            | tooltip |

            tooltip := item tooltip.
            tooltip notNil ifTrue:[ ^ tooltip ]
        ].
    ].

    ^ super flyByHelpTextFor:aView

    "Created: / 29-07-2018 / 21:30:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'hooks'!

commonPostOpen
    "a common hook for postOpenWith:, postOpenAsSubcanvasWith: and postOpenAsDialogWith:."

    self enqueueDelayedUpdateInternalList

    "Created: / 18-09-2014 / 00:29:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2014 / 23:50:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildInternalListView: aView
    <resource: #uiCallback>

    | columns |

    internalListView := aView.
    internalListView font: self textFont.

    columns := self class columnsSpec.
    columns notEmptyOrNil ifTrue:[
        | renderer |

        renderer := aView setupTableRenderer.
        renderer columnDescriptors: columns.
        renderer columnDescriptors do:[:c|
            c dataSetColumnSpec foregroundSelector isNil ifTrue:[ 
                c dataSetColumnSpec foregroundSelector: #foregroundColor
            ].
        ].


    ].

    "Modified: / 20-08-2018 / 10:17:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'menu'!

contextMenu
    ^ [
        (Menu decodeFromLiteralArray: self class contextMenu)
            receiver:self;
            findGuiResourcesIn:self;
            yourself
    ]

    "Created: / 16-01-2018 / 14:29:05 / jv"
    "Modified: / 16-01-2018 / 22:02:37 / jv"
    "Modified (comment): / 16-01-2018 / 23:26:46 / jv"
!

contextMenuItemSlice
    | item menu |

    item := self internalSelectionHolder value.
    item isNil ifTrue:[ 
        menu := Menu new.
    ] ifFalse:[ 
        menu := item contextMenu.
    ].
    ^ menu.

    "Created: / 16-01-2018 / 13:37:08 / jv"
    "Modified: / 16-01-2018 / 22:03:45 / jv"
! !

!VDBAbstractListApplication methodsFor:'menu actions'!

doCopy:aString 
    self window setClipboardText:aString

    "Created: / 15-06-2018 / 11:32:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCopyContents
    | contents |

    contents := String streamContents:[:s | self printItemsFrom: 1 to: self internalList size on:s. ].
    self doCopy:contents.

    "Modified: / 10-08-2018 / 12:52:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCopySelection
    | index contents |

    index := self internalList indexOf: self internalSelection.
    contents := String streamContents:[:s | self printItemsFrom: index to: index on:s. ].
    self doCopy:contents.

    "Modified: / 10-08-2018 / 12:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDoubleClick
    "Invoked when user double-clicks to list item."

    | selectedVarObjPresenter |
    
    selectedVarObjPresenter := self internalSelectionHolder value. 
    selectedVarObjPresenter notNil ifTrue:[
        selectedVarObjPresenter doDoubleClick
    ].

    "Created: / 13-06-2017 / 17:09:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-01-2018 / 23:33:12 / jv"
    "Modified: / 05-02-2018 / 13:02:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInspectModel
    | selection |

    selection := self internalSelectionHolder value.
    selection notEmptyOrNil ifTrue:[ 
        selection subject inspect
    ].

    "Modified: / 05-02-2018 / 13:07:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInspectPresenter
    self internalSelectionHolder value inspect

    "Modified: / 22-09-2014 / 01:17:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

duUpdateList
    <resource: #uiCallback>

    self enqueueDelayedUpdateInternalList

    "Modified: / 12-06-2017 / 12:00:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'private'!

internalCanSelect: index
    | item |

    item := internalListHolder value at: index.
    ^self canSelect: item

    "Created: / 09-04-2018 / 20:52:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

internalList
    ^ self internalListHolder value

    "Created: / 10-08-2018 / 12:51:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

internalSelection
    ^ self internalSelectionHolder value

    "Created: / 10-08-2018 / 12:54:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printItemsFrom: first to: last on:aStream  
    | list columns |

    list := self internalList.
    (internalListView listRenderer isKindOf:ListModelView::TableRenderer) ifTrue:[
        columns := internalListView listRenderer columnDescriptors.
    ] ifFalse:[
        columns := #().
    ].
    first to: last do:[:rownr |
        | item |

        item := list at: rownr.
        item isHierarchicalItem ifTrue:[
            aStream next:item level * 2 put:Character space.
            aStream nextPutAll:item label asString.
        ] ifFalse:[
            aStream nextPutAll:item asString.
        ].
        columns do:[:column | 
            | value |

            value := column 
                    extractColumnFrom:item
                    rowNr:rownr
                    on:internalListView.
            value notNil ifTrue:[
                aStream tab.
                aStream nextPutAll:value displayString.
            ].
        ].
        aStream cr.
    ].

    "Created: / 10-08-2018 / 12:50:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'queries'!

canSelect: anItem
    ^ true

    "Modified: / 09-04-2018 / 20:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelection
    ^ self internalSelectionHolder value notEmptyOrNil

    "Modified: / 22-09-2014 / 01:13:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication methodsFor:'scrolling'!

scrollToListItem: presenter
    | index |

    internalListView isNil ifTrue:[ ^ self ].
    index := (internalListHolder value ? #()) indexOf: presenter.
    index ~~ 0 ifTrue:[ 
        internalListView scrolledView scrollToLine: index.
    ].

    "Created: / 07-08-2018 / 13:35:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractListApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

