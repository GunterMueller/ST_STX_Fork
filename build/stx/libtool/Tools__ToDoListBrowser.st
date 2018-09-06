"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#ToDoListBrowser
	instanceVariableNames:'toDoList shownCopyOfToDoList selectionIndexHolder
		currentSortOrder'
	classVariableNames:'TheOneAndOnlyToDoListBrowser'
	poolDictionaries:''
	category:'Interface-Smalltalk-ToDo'
!

!ToDoListBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    documentation to be added.

    [author:]
        cg (cg@FUSI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    ToDoListBrowser open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!ToDoListBrowser class methodsFor:'class initialization'!

current
    ^ TheOneAndOnlyToDoListBrowser

    "Created: / 21-10-2006 / 20:37:48 / cg"
!

current:aBrowser
    TheOneAndOnlyToDoListBrowser := aBrowser.

    "Created: / 21-10-2006 / 20:38:08 / cg"
!

new
    |b|

    b := super new.
    TheOneAndOnlyToDoListBrowser isNil ifTrue:[
        TheOneAndOnlyToDoListBrowser := b.
    ].
    ^ b

    "Created: / 21-10-2006 / 20:39:03 / cg"
! !

!ToDoListBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ToDoListBrowser andSelector:#windowSpec
     ToDoListBrowser new openInterface:#windowSpec
     ToDoListBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'ToDoListBrowser'
          name: 'ToDoListBrowser'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 577 395)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'Table'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: selectionIndexHolder
              menu: itemMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              dataList: shownCopyOfToDoList
              doubleClickSelector: itemDoubleClicked:
              columnHolder: tableColumns
            )
           )
         
        )
      )

    "Modified: / 18-02-2007 / 12:55:32 / cg"
! !

!ToDoListBrowser class methodsFor:'menu specs'!

itemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ToDoListBrowser andSelector:#itemMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ToDoListBrowser itemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browse'
            itemValue: browseItem
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Remove'
            itemValue: removeItem
            translateLabel: true
          )
         (MenuItem
            label: 'Remove all Items for this Class'
            itemValue: removeItemsForClass
            translateLabel: true
          )
         (MenuItem
            label: 'Remove all Items for this Class and its Private Classes'
            itemValue: removeItemsForClassOrPrivateClass
            translateLabel: true
          )
         )
        nil
        nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ToDoListBrowser andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ToDoListBrowser mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'List'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Clear'
                  itemValue: clearList
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            translateLabel: true
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )

    "Modified: / 23-10-2006 / 23:22:45 / cg"
! !

!ToDoListBrowser class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:ToDoListBrowser andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Type'
         labelButtonType: Button
         width: 32
         model: severityString
         canSelect: false
         labelActionSelector: sortBy:
         labelActionArgument: 'severity'
       )
      (DataSetColumnSpec
         label: 'Prio'
         labelButtonType: Button
         width: 30
         model: priorityString
         canSelect: false
         labelActionSelector: sortBy:
         labelActionArgument: 'priority'
       )
      (DataSetColumnSpec
         label: 'Time'
         labelButtonType: Button
         width: 50
         model: time
         canSelect: false
         labelAlignment: left
         labelActionSelector: sortBy:
         labelActionArgument: 'timestamp'
       )
      (DataSetColumnSpec
         label: 'Message'
         labelButtonType: Button
         model: message
         canSelect: false
         labelAlignment: left
         labelActionSelector: sortBy:
         labelActionArgument: 'message'
       )
      (DataSetColumnSpec
         label: 'Where'
         labelButtonType: Button
         model: methodOrClassName
         canSelect: false
         labelAlignment: left
         labelActionSelector: sortBy:
         labelActionArgument: 'methodOrClassName'
       )
      )

    "Modified: / 25-10-2006 / 01:05:50 / cg"
! !

!ToDoListBrowser methodsFor:'accessing'!

aboutThisApplicationText
    |msg|

    msg := super aboutThisApplicationText.
    msg := msg , '\\Written by Claus Gittinger (cg@exept.de).'.
    ^msg withCRs.
!

addEntry:anEntry
    self toDoList add:anEntry

    "Created: / 21-10-2006 / 15:38:08 / cg"
    "Modified: / 21-10-2006 / 21:14:31 / cg"
!

selectedTodoListEntry
    ^ self todoListEntryAtIndex:(self selectionIndex).
!

selectionIndex
    ^ self selectionIndexHolder value
!

selectionIndexHolder
    selectionIndexHolder isNil ifTrue:[
        selectionIndexHolder := nil asValue.
    ].
    ^ selectionIndexHolder

    "Created: / 22-10-2006 / 02:00:41 / cg"
!

shownCopyOfToDoList
    shownCopyOfToDoList isNil ifTrue:[
        shownCopyOfToDoList := List new
    ].
    ^ shownCopyOfToDoList

    "Created: / 18-02-2007 / 12:53:01 / cg"
!

toDoList
    toDoList isNil ifTrue:[
        toDoList := ToDoList theOneAndOnlyToDoList.
    ].
    ^ toDoList

    "Created: / 21-10-2006 / 20:57:18 / cg"
!

todoListEntryAtIndex:idx
    ^ shownCopyOfToDoList at:idx
! !

!ToDoListBrowser methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    changedObject == toDoList ifTrue:[
        self updateShownToDoList.
        ^ self
    ].
!

update:something with:aParameter from:changedObject
    changedObject == toDoList ifTrue:[
        self enqueueDelayedUpdate:nil with:nil from:changedObject.
        ^ self
    ].
    ^ super update:something with:aParameter from:changedObject

    "Created: / 18-02-2007 / 12:54:32 / cg"
!

updateShownToDoList
    self shownCopyOfToDoList contents:(self toDoList).
    self resort.

    "Created: / 18-02-2007 / 12:54:58 / cg"
! !

!ToDoListBrowser methodsFor:'initialization & release'!

closeDownViews
    "This is a hook method generated by the Browser.
     It will be invoked when your app/dialog-window is really closed.
     See also #closeDownViews, which is invoked before and may suppress the close
     or ask the user for confirmation."

    "/ change the code below as required ...
    "/ This should cleanup any leftover resources
    "/ (for example, temporary files)
    "/ super closeRequest will initiate the closeDown

    "/ add your code here

    "/ do not remove the one below ...
    ^ super closeDownViews
!

closeRequest
    "This is a hook method generated by the Browser.
     It will be invoked when your app/dialog-window is about to be
     closed (this method has a chance to suppress the close).
     See also #closeDownViews, which is invoked when the close is really done."

    "/ change the code below as required ...
    "/ Closing can be suppressed, by simply returning.
    "/ The 'super closeRequest' at the end will initiate the real closeDown

    ("self hasUnsavedChanges" false) ifTrue:[
        (self confirm:(resources string:'Close without saving ?')) ifFalse:[
            ^ self
        ]
    ].

    ^ super closeRequest

    "Modified: / 21-10-2006 / 19:21:02 / cg"
!

postBuildWith:aBuilder
    self toDoList addDependent:self.
    self updateShownToDoList.

    ToDoList autoload.
    ToDoListEntry autoload.
    CompilerWarningToDoListEntry autoload.

    ^ super postBuildWith:aBuilder

    "Modified: / 18-02-2007 / 12:55:57 / cg"
!

postOpenWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked right after the applications window has been opened.
     Add any app-specific actions here (starting background processes etc.).
     See also #postBuildWith:, which is invoked before opening."

    "/ add any code here ...

    ^ super postOpenWith:aBuilder
!

release
    self toDoList removeDependent:self.
    self == TheOneAndOnlyToDoListBrowser ifTrue:[
        TheOneAndOnlyToDoListBrowser := nil
    ].
    super release.

    "Created: / 21-10-2006 / 20:40:31 / cg"
    "Modified: / 18-02-2007 / 12:57:07 / cg"
! !

!ToDoListBrowser methodsFor:'menu actions'!

clearList
    toDoList removeAll

    "Created: / 22-10-2006 / 00:02:15 / cg"
!

openAboutThisApplication
    super openAboutThisApplication
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#TODOLIST'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
! !

!ToDoListBrowser methodsFor:'menu actions-item'!

browseItem
    self withWaitCursorDo:[
        (self todoListEntryAtIndex:self selectionIndexHolder value) browse
    ].

    "Created: / 22-10-2006 / 02:00:20 / cg"
    "Modified: / 18-02-2007 / 12:56:49 / cg"
!

removeItem
    toDoList remove:(self selectedTodoListEntry)

    "Created: / 22-10-2006 / 10:45:52 / cg"
    "Modified: / 18-02-2007 / 12:57:58 / cg"
!

removeItems:entriesToRemove
    entriesToRemove do:[:entryToRemove |
        toDoList remove:entryToRemove
    ].
!

removeItemsForClass
    |cls entriesToRemove|

    cls := self selectedTodoListEntry problemClass.
    entriesToRemove := toDoList select:[:entry | entry problemClass == cls].
    self removeItems:entriesToRemove
!

removeItemsForClassOrPrivateClass
    |cls entriesToRemove|

    cls := self selectedTodoListEntry problemClass.
    entriesToRemove := toDoList select:[:entry | entry problemClass == cls
                                                 or:[ entry problemClass topOwningClass == cls]].
    self removeItems:entriesToRemove
! !

!ToDoListBrowser methodsFor:'user actions'!

itemDoubleClicked:itemIndex
    self withWaitCursorDo:[
        (self selectedTodoListEntry) browse
    ].

    "Created: / 22-10-2006 / 01:49:13 / cg"
    "Modified: / 18-02-2007 / 12:56:30 / cg"
!

resort
    |sortBlock sortBlock1 col|

    currentSortOrder isNil ifTrue:[^ self ].

    col := currentSortOrder at:#column.

    sortBlock := sortBlock1 := [:a :b |
                                    |vA vB|

                                    vA := (a perform:col).
                                    vB := (b perform:col).
                                    vA = vB ifTrue:[
                                        col == #severity ifTrue:[
                                            vA := a priority.
                                            vB := b priority.
                                        ]
                                    ].
                                    vA < vB
                               ].

    (currentSortOrder at:#reverse) ifTrue:[
        sortBlock := [:a :b | (sortBlock1 value:a value:b) not ].
    ].

    "/ temporary hack - should make a copy of the real list
    self shownCopyOfToDoList sort:sortBlock

    "Created: / 25-10-2006 / 01:01:26 / cg"
    "Modified: / 18-02-2007 / 13:02:19 / cg"
!

sortBy:instanceName
    self sortBy:instanceName withReverse:true

    "Created: / 25-10-2006 / 00:53:55 / cg"
!

sortBy:instanceName withReverse:aBoolean
    |aSymbol|

    aSymbol := instanceName asSymbol.

    currentSortOrder isNil ifTrue:[
        currentSortOrder := Dictionary new.
        currentSortOrder at:#column put:aSymbol.
        currentSortOrder at:#reverse put:false.
    ] ifFalse:[
        (currentSortOrder at:#column) = aSymbol ifTrue:[
            "/ same column like before - change sort order ifReverse is true
            aBoolean ifTrue:[
                | isReverse |
                isReverse := currentSortOrder at:#reverse.
                currentSortOrder at:#reverse put:(isReverse not).
            ].
        ] ifFalse:[
            "/ another column - remark column
            currentSortOrder at:#column put:aSymbol.
        ]
    ].
    self resort.

    "Created: / 25-10-2006 / 00:54:59 / cg"
! !

!ToDoListBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ToDoListBrowser.st,v 1.18 2012-11-03 16:16:49 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

