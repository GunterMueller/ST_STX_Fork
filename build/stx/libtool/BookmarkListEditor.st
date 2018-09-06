"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#BookmarkListEditor
	instanceVariableNames:'selectionHolder bookmarkListHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Bookmarks'
!

!BookmarkListEditor class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!BookmarkListEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BookmarkListEditor andSelector:#windowSpec
     BookmarkListEditor new openInterface:#windowSpec
     BookmarkListEditor open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Bookmark Editor'
          name: 'Bookmark Editor'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 509 430)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBar'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              menu: toolbarMenu
              textDefault: true
            )
           (VariableHorizontalPanelSpec
              name: 'Panel'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              component: 
             (SpecCollection
                collection: (
                 (HierarchicalListViewSpec
                    name: 'BookmarkList'
                    model: selectionHolder
                    menu: contextMenu
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    listModel: bookmarkListHolder
                    useIndex: false
                    highlightMode: line
                    doubleClickSelector: menuRename
                    useDefaultIcons: false
                  )
                 )
               
              )
              handles: (Any 1.0)
            )
           )
         
        )
      )
! !

!BookmarkListEditor class methodsFor:'menu specs'!

contextMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:BookmarkListEditor andSelector:#contextMenu
     (Menu new fromLiteralArrayEncoding:(BookmarkListEditor contextMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'New...'
            itemValue: menuNewFolder
            translateLabel: true
            submenuChannel: newMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary newDirectory22x22Icon 'New...')
          )
         (MenuItem
            label: 'Rename'
            itemValue: menuRename
            translateLabel: true
            shortcutKey: Rename
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Remove'
            itemValue: menuRemove
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteIcon 'Remove')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move Up'
            itemValue: menuMoveUp
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetUpIcon 'Move Up')
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move Down'
            itemValue: menuMoveDown
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetDownIcon 'Move Down')
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move In'
            itemValue: menuMoveIn
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetDownRightIcon 'Move In')
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move Out'
            itemValue: menuMoveOut
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetLeftDownIcon 'Move Out')
          )
         )
        nil
        nil
      )
!

newMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:BookmarkListEditor andSelector:#newMenu
     (Menu new fromLiteralArrayEncoding:(BookmarkListEditor newMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'New Folder'
            itemValue: menuNew:
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary newDirectory22x22Icon 'New Folder')
            argument: #'Bookmark::Folder'
          )
         (MenuItem
            label: 'New Separator'
            itemValue: menuNew:
            translateLabel: true
            argument: #'Bookmark::Separator'
          )
         )
        nil
        nil
      )
!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:BookmarkListEditor andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(BookmarkListEditor toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: newItem
            label: 'New...'
            itemValue: menuNewFolder
            isButton: true
            submenuChannel: newMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary newDirectory22x22Icon)
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Remove'
            itemValue: menuRemove
            isButton: true
            shortcutKey: Delete
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Save'
            itemValue: menuSave
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveToFileIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move Up'
            itemValue: menuMoveUp
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetUpIcon)
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move Down'
            itemValue: menuMoveDown
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetDownIcon)
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move In'
            itemValue: menuMoveIn
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetDownRightIcon)
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Move Out'
            itemValue: menuMoveOut
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary moveWidgetLeftDownIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasFolderSelectedHolder
            label: 'Sort by Name'
            itemValue: menuSortByName
            labelImage: (ResourceRetriever ToolbarIconLibrary sortByName16x16Icon)
          )
         )
        nil
        nil
      )
! !

!BookmarkListEditor methodsFor:'accessing'!

bookmarkList

    ^self bookmarkListHolder value

    "Created: / 02-06-2011 / 10:40:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarkList: aBookmarkList

    self bookmarkListHolder value: aBookmarkList

    "Created: / 02-06-2011 / 10:40:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection

    ^self selectionHolder value

    "Created: / 02-06-2011 / 10:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection: anObject

    ^self selectionHolder value: anObject

    "Created: / 02-06-2011 / 11:46:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkListEditor methodsFor:'aspects'!

bookmarkListHolder
    <resource: #uiAspect>

    bookmarkListHolder isNil ifTrue:[
        bookmarkListHolder := ValueHolder new.
    ].
    ^ bookmarkListHolder.

    "Modified: / 02-06-2011 / 10:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFolderSelectedHolder

    ^BlockValue 
        with:[:selectionHolder|
                |sel|
                (sel := selectionHolder value) notNil
                and:[sel isFolderBookmark ]
             ]
        argument: self selectionHolder

    "Created: / 02-06-2011 / 10:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelectionHolder

    ^BlockValue 
        with:[:selectionHolder|selectionHolder value notNil]
        argument: self selectionHolder

    "Created: / 02-06-2011 / 10:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionHolder
    <resource: #uiAspect>

    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
    ].
    ^ selectionHolder.
! !

!BookmarkListEditor methodsFor:'hooks'!

commonPostOpen
    | root |

    self bookmarkList isNil ifTrue:[
        self bookmarkList: BookmarkList forSystemBrowser
    ].
    root := self bookmarkList root.
    root isExpanded ifFalse:[root expand].

    "Created: / 02-06-2011 / 10:41:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 13:33:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:32:36 / cg"
! !

!BookmarkListEditor methodsFor:'menu actions'!

menuMoveDown

    | sel |

    (sel := self selection) parent moveDown: sel.
    self selection: sel.

    "Modified: / 02-06-2011 / 11:45:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveIn

    | sel |

    (sel := self selection) parent moveIn: sel.
    self selection: sel.

    "Modified: / 03-06-2011 / 10:27:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveOut

    | sel |

    (sel := self selection) parent moveOut: sel.
    self selection: sel.

    "Modified: / 03-06-2011 / 10:28:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveUp

    | sel |

    (sel := self selection) parent moveUp: sel.
    self selection: sel.

    "Modified: / 02-06-2011 / 11:46:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuNew: className
    | folder new |

    folder := self selection.
    folder isNil ifTrue:[folder := self bookmarkList root].
    folder isFolderBookmark ifFalse: [folder := folder parent].
    new := (Smalltalk at: className) new.
    folder add: new.

    "Created: / 02-06-2011 / 11:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 13:24:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:32:49 / cg"
!

menuNewFolder

    self menuNew: #'Bookmark::Folder'

    "Modified: / 02-06-2011 / 12:00:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuRemove

    self selection parent remove: self selection.

    "Modified: / 02-06-2011 / 13:18:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuRename
    | sel name |

    sel := self selection.
    name := Dialog request: 'Enter new name' initialAnswer: sel label asString.
    name isNil ifTrue:[^self].
    sel label: name.

    "Modified: / 03-06-2011 / 10:43:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:33:00 / cg"
!

menuSave

    self bookmarkList save.

    "Modified: / 02-06-2011 / 22:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuSortByName

    | sel |

    ((sel := self selection) isNil or:[sel isFolderBookmark not]) ifTrue:[
        Dialog information:'Please select a folder item first'.
        ^ self.
    ].
    sel sortChildrenAlphabetically.
    self selection: sel.
! !

!BookmarkListEditor class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

