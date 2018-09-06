"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

AbstractDirectoryBrowser subclass:#DirectoryTreeBrowser
	instanceVariableNames:'oldDropItem expandItemTimedBlock updateTreeSelection
		doubleClickAction newVisibilityHolder allowFileOperations
		multipleSelect treeSelectionHolder sortInTreeVisibilityHolder
		sortPropertyInTree sortCaselessInTreeBrowser'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

HierarchicalFileList subclass:#DirTreeBrowserHFL
	instanceVariableNames:'draggedItem grayDirectoryIcon'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DirectoryTreeBrowser
!

!DirectoryTreeBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    An application for displaying directories as a tree.
    To be used as a building block in file browsers and fileSelection dialogs.
    This is used as the top-left component in the new fileBrowser.

    [author:]
        Christian Penk (penk@bierfix)

    [see also:]
        FileBrowserV2
"
!

examples
"
                                                                [exBegin]
    DirectoryTreeBrowser open
                                                                [exEnd]
"
! !

!DirectoryTreeBrowser class methodsFor:'instance creation'!

openOn:aFileName
    | file |

    file := aFileName asFilename.
    file exists ifTrue:[
        ^ self openOn:aFileName withFiles:(file isDirectory not)
    ].
    ^ self open

"
    DirectoryTreeBrowser openOn:Filename homeDirectory   
    DirectoryTreeBrowser openOn:(Filename homeDirectory construct:'.bashrc')  
"
!

openOn:aFileName withFiles:aBoolean

    |instance|

    instance := self new.
    instance open.
    instance viewFilesInDirectoryTree value:aBoolean.
    instance currentFileNameHolder value:(OrderedCollection with:aFileName).
    ^ instance

"
    DirectoryTreeBrowser openOn:Filename homeDirectory  
    DirectoryTreeBrowser openOn:(Filename homeDirectory construct:'.bashrc') withFiles:false  
"
! !

!DirectoryTreeBrowser class methodsFor:'defaults'!

timeForExpandOnDropInMilliseconds

    ^ 1500
! !

!DirectoryTreeBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DirectoryTreeBrowser andSelector:#windowSpec
     DirectoryTreeBrowser new openInterface:#windowSpec
     DirectoryTreeBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'DirectoryTreeBrowser'
          name: 'DirectoryTreeBrowser'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'HierarchicalListView'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              model: treeSelectionHolder
              menu: menu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: false
              miniScrollerVertical: false
              listModel: fileList
              multipleSelectOk: true
              useIndex: false
              highlightMode: label
              doubleClickSelector: doDoubleClick:
              indicatorSelector: doIndicatorClick:
              autoScrollHorizontal: false
              postBuildCallback: postBuildDirBrowser:
              properties: 
             (PropertyListDictionary
                enterSelector: dropEnter:
                dragArgument: directoryTreeBrowser
                startDragSelector: doStartDrag:in:
                displayObjectSelector: getDisplayObjects:
                dropObjectSelector: getDropObjects:
                overSelector: dropOver:
                dropArgument: directoryTreeBrowser
                canDropSelector: canDrop:
                leaveSelector: dropLeave:
                dropSelector: doDrop:
              )
            )
           )
         
        )
      )
! !

!DirectoryTreeBrowser class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DirectoryTreeBrowser andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(DirectoryTreeBrowser menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Cut'
            itemValue: doCut
            translateLabel: true
            isVisible: allowFileOperations
            shortcutKey: Cut
          )
         (MenuItem
            label: 'Copy'
            itemValue: doCopy
            translateLabel: true
            isVisible: allowFileOperations
            shortcutKey: Copy
          )
         (MenuItem
            enabled: canPaste
            label: 'Paste'
            itemValue: pasteFiles
            translateLabel: true
            isVisible: allowFileOperations
            shortcutKey: Paste
          )
         (MenuItem
            label: 'Delete'
            itemValue: doDelete
            nameKey: delete
            translateLabel: true
            isVisible: allowFileOperations
            shortcutKey: Delete
          )
         (MenuItem
            label: '-'
            isVisible: allowFileOperations
          )
         (MenuItem
            label: 'New'
            translateLabel: true
            isVisible: newVisibilityHolder
            submenuChannel: newMenu
            keepLinkedMenu: true
          )
         (MenuItem
            label: '-'
            isVisible: newVisibilityHolder
          )
         (MenuItem
            enabled: hasSelection
            label: 'Rename'
            itemValue: renameFileInTreeView
            translateLabel: true
            isVisible: allowFileOperations
            shortcutKey: Rename
          )
         (MenuItem
            enabled: hasSelection
            label: 'Rename each to Include Directory in Name'
            itemValue: renameToIncludeDirectoryInNameInTreeView
            translateLabel: true
            isVisible: allowFileOperations
          )
         (MenuItem
            enabled: hasSelection
            label: 'Properties...'
            itemValue: doShowProperties
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: enableDirectoryUp
            label: 'Directory Up'
            itemValue: doGoDirectoryUp
            translateLabel: true
          )
         (MenuItem
            label: 'View'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Sort'
                  nameKey: Sort
                  translateLabel: true
                  submenuChannel: sortInTreeMenu
                )
               (MenuItem
                  label: 'Show'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'Files'
                        translateLabel: true
                        indication: viewFilesInDirectoryTree
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: selectedFilesIncludesNonRootDirectory
                  label: 'Make Selected Directory new Root'
                  itemValue: doSetSelectionToRoot
                  translateLabel: true
                )
               (MenuItem
                  label: 'Re-/ Expand Directory'
                  itemValue: toggleExpandSelectedItem
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update'
            itemValue: updateCurrentDirectory
            translateLabel: true
          )
         )
        nil
        nil
      )
!

sortInTreeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DirectoryTreeBrowser andSelector:#sortInTreeMenu
     (Menu new fromLiteralArrayEncoding:(DirectoryTreeBrowser sortInTreeMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'By Filename'
            translateLabel: true
            isVisible: sortInTreeVisibilityHolder
            hideMenuOnActivated: false
            choice: sortPropertyInTree
            choiceValue: baseName
          )
         (MenuItem
            label: 'By Type'
            translateLabel: true
            isVisible: sortInTreeVisibilityHolder
            hideMenuOnActivated: false
            choice: sortPropertyInTree
            choiceValue: suffix
          )
         (MenuItem
            label: 'By Size'
            translateLabel: true
            isVisible: sortInTreeVisibilityHolder
            hideMenuOnActivated: false
            choice: sortPropertyInTree
            choiceValue: fileSize
          )
         (MenuItem
            label: 'By Date && Time'
            translateLabel: true
            isVisible: sortInTreeVisibilityHolder
            hideMenuOnActivated: false
            choice: sortPropertyInTree
            choiceValue: modificationTime
          )
         (MenuItem
            label: '-'
            isVisible: sortInTreeVisibilityHolder
          )
         (MenuItem
            label: 'Ignore Case in Sort'
            translateLabel: true
            hideMenuOnActivated: false
            indication: sortCaselessInTreeBrowser
          )
         )
        nil
        nil
      )
! !

!DirectoryTreeBrowser class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        treeSelectionHolder
        rootHolder
        filterModel
        showFiles
        showHiddenFiles
      ).
! !

!DirectoryTreeBrowser methodsFor:'accessing'!

allowRenameOnOneClick

    ^ false
!

browser
    "return the value of the instance variable 'browser' (automatically generated)"

    ^ browser
!

doubleClickAction

    ^ doubleClickAction
!

doubleClickAction:aBlock

    " aBlock is a one arg block with selected index as argument "

    doubleClickAction := aBlock
!

updateTreeSelection
    updateTreeSelection isNil ifTrue:[
        updateTreeSelection := self class newLock.
    ].
    ^ updateTreeSelection
! !

!DirectoryTreeBrowser methodsFor:'actions'!

doDoubleClick:anIndex 
    "handle a doubleClick on a directory
    "
    | item file isDirectory|

    self doubleClickAction notNil ifTrue:[
        self doubleClickAction value:anIndex.
    ].
    item := self fileList at:anIndex ifAbsent:nil.
    item notNil ifTrue:[
        isDirectory := item isDirectory.
        file := item fileName.
        isDirectory ifTrue:[
            (file isReadable and:[file isExecutable]) ifTrue:[
                self doExpand:item.
            ]
        ] ifFalse:[
"/                      self openApplByFileItem:item.
        ]
    ]
!

doExpand:anItem
" expand the item; return true the item have expanded "

    (anItem notNil and:[anItem isDirectory and:[anItem isExpanded not]]) ifTrue:[
        anItem toggleExpand.
        ^ true.
    ].          
    ^ false
!

doIndicatorClick:anIndex 
    "handle a click on the indicator
    "

    |indicatorItem selectedItemNotUnderIndicatorItem selection|

    indicatorItem := self fileList at:anIndex ifAbsent:nil.
    selection := self selectedItems asOrderedCollection.
    selectedItemNotUnderIndicatorItem := 
        selection 
            detect:[:anItem |
                (anItem fileName directory asString startsWith:(indicatorItem fileName asString)) not] 
            ifNone:[nil].
    selectedItemNotUnderIndicatorItem isNil ifTrue:[
        self setCurrentFileName:(indicatorItem fileName).
    ].
    self toggleExpand:indicatorItem.
!

doSetSelectionToRoot
    | selDir|

    selDir := self firstSelectedDirectory.
    selDir notNil ifTrue:[
        self rootHolder value asFilename = selDir ifTrue:[ ^ self].
        self rootHolder value:selDir.
        self setCurrentFileName:selDir.
    ].
!

doUpdate
"/    DirectoryContents flushCache.
    self fileList updateList.
"/    self updateSelectedItem
!

evaluateSortBlockWith:aBlock

    | sel model|

    model := self treeSelectionHolder.
    sel := model value.
    model setValue:nil.
    self fileList sortBlock:aBlock.
    model value:sel withoutNotifying:self.
!

expandEnforceSelectedItems
" expand the selected item if one directory selected"

    | items |

    items := self selectedDirectoryItems.
    items do:[:eachItem |
        eachItem enforcedExpand
    ].
!

expandSelectedItems
" expand the selected item if one directory selected"

    | items |

    items := self selectedDirectoryItems.
    items do:[:eachItem |
        eachItem expand
    ].
!

renameFileInTreeView
    self allowRenameOnOneClick ifTrue:[
        browser openEditor.
    ] ifFalse:[
        browser openEditorAction:self openEditorAction.
        [browser openEditor.] ensure:[
            browser openEditorAction:nil.
        ].
    ].
!

renameToIncludeDirectoryInNameInTreeView
    |numAffected|

    numAffected := 0.
    self withWaitCursorDo:[
        self selectedDirectories do:[:eachDirectory |
            |prefix|

            prefix := eachDirectory baseName , '_'.   
            eachDirectory directoryContentsAsFilenamesDo:[:eachFile |
                (eachFile baseName startsWith:prefix) ifFalse:[
                    numAffected := numAffected + 1.
                ].                              
            ].                              
        ].
    ].
    numAffected == 0 ifTrue:[
        Dialog information:(resources string:'No files to rename').
        ^ self.
    ].
    (Dialog confirm:(resources stringWithCRs:'Continue renaming %1 files?' with:numAffected)) ifFalse:[^ self].

    self withWaitCursorDo:[
        self selectedDirectories do:[:eachDirectory |
            |prefix|

            prefix := eachDirectory baseName , '_'.   
            eachDirectory directoryContentsAsFilenamesDo:[:eachFile |
                (eachFile baseName startsWith:prefix) ifFalse:[
                    eachFile renameTo:(eachDirectory construct:(prefix,eachFile baseName)).
                ].                              
            ].                              
        ].
    ].
!

setMatchBlockInList:list

    | selection matchBlock filterBlock viewFiles|

    selection := self selectedItems.
    filterBlock := self filterBlockHolder value.
    viewFiles := self viewFilesInDirectoryTree value.

    matchBlock := 
        [:fileName :isDir|
            |show|

            show := self showHiddenFiles value or:[fileName isHidden not].
            show
                and:[ isDir 
                      or:[viewFiles and:[filterBlock value:fileName value:fileName baseName]]]
        ].
    list matchBlock:matchBlock.
!

sortFileListsBy:instanceName 

    | aSymbol cmpOp instanceSortBlock treeSortBlock locSortCaselessInTreeBrowser|

    locSortCaselessInTreeBrowser := self sortCaselessInTreeBrowser value.
    aSymbol := instanceName asSymbol.
    cmpOp := #'<'.
    instanceSortBlock := [:a :b | 
        |entry1 entry2|

        entry1 := (a perform:aSymbol).
        entry2 := (b perform:aSymbol).
        ((entry1 isNil) or:[entry2 isNil]) ifTrue:[
            true
        ] ifFalse:[
            (aSymbol = #baseName) ifTrue:[
                locSortCaselessInTreeBrowser ifTrue:[
                    entry1 := entry1 asString asLowercase.
                    entry2 := entry2 asString asLowercase.
                ] ifFalse:[
                    entry1 := entry1 asString.
                    entry2 := entry2 asString.
                ].
            ].
            entry1 perform:cmpOp with:entry2
        ]
    ].
    treeSortBlock := [ :a :b |
        |aIsDir bIsDir res|

        aIsDir := a isDirectory.
        bIsDir := b isDirectory.
        (aIsDir and:[bIsDir]) ifTrue:[
            | entry1 entry2 |
            entry1 := a baseName.
            entry2 := b baseName.
            locSortCaselessInTreeBrowser ifTrue:[
                entry1 := entry1 asString asLowercase.
                entry2 := entry2 asString asLowercase.
            ] ifFalse:[
                entry1 := entry1 asString.
                entry2 := entry2 asString.
            ].
            res := entry1 < entry2.
        ] ifFalse:[
            (aIsDir or:[bIsDir]) ifTrue:[
                res := aIsDir
            ] ifFalse:[
                res := instanceSortBlock value:a value:b.
            ]
        ].
        res
    ].
    self evaluateSortBlockWith:treeSortBlock.
!

toggleExpand:anItem
    (anItem notNil and:[anItem isDirectory]) ifTrue:[
"/        self withWaitCursorDo:[
            anItem toggleExpand
"/        ]
    ].

    "Modified: / 25-07-2006 / 09:09:05 / cg"
!

toggleExpandSelectedItem
    |selDir|

    selDir := self selectedDirectoryItems.
    selDir do:[:item|
        self toggleExpand:item.
    ].
!

updateSelectedItem
    | sel |

    sel := self selectedItems.
    sel isEmpty ifTrue:[ ^ self].
    sel do:[:item|
        item invalidateRepairNow:true.
    ]
! !

!DirectoryTreeBrowser methodsFor:'aspects'!

allowFileOperations
    "allowFileOperations
    "
    allowFileOperations isNil ifTrue:[
        allowFileOperations := true asValue.
    ].
    ^ allowFileOperations.
!

fileList
    "holder, which keeps the current list of file entries shown by the directory-browser
    "

    |list|

    (list := builder bindingAt:#fileList) isNil ifTrue:[
        list := DirTreeBrowserHFL new.
        list application:self.
        list showRoot:true.
        self setMatchBlockInList:list.
        "/ do not set the directory holder in startup
        "/ list directory:(self rootHolder value).
        builder aspectAt:#fileList put:list.
        "/ list monitoringTaskDelay:2
    ].
    ^ list

    "Modified: / 08-09-2006 / 13:29:17 / cg"
!

multipleSelect
    ^ multipleSelect ? false
!

multipleSelect:aBoolean
    multipleSelect := aBoolean.
    browser notNil ifTrue:[
        browser multipleSelectOk:aBoolean.
    ].
!

newVisibilityHolder
    "newVisibilityHolder"

    newVisibilityHolder isNil ifTrue:[
        newVisibilityHolder := true asValue.
    ].
    ^ newVisibilityHolder.
!

sortCaselessInTreeBrowser

    sortCaselessInTreeBrowser isNil ifTrue:[
        sortCaselessInTreeBrowser := self sortCaseless value asValue.
        sortCaselessInTreeBrowser addDependent:self.
    ].
    ^ sortCaselessInTreeBrowser.
!

sortInTreeVisibilityHolder
    "newVisibilityHolder
    "
    sortInTreeVisibilityHolder isNil ifTrue:[
        sortInTreeVisibilityHolder := self viewFilesInDirectoryTree value asValue.
    ].
    ^ sortInTreeVisibilityHolder.
!

sortPropertyInTree

    sortPropertyInTree isNil ifTrue:[
        sortPropertyInTree := #baseName asValue.
        sortPropertyInTree addDependent:self.
    ].
    ^ sortPropertyInTree.
!

sortPropertyInTree:aValueHolder
    sortPropertyInTree removeDependent:self.
    sortPropertyInTree := aValueHolder.
    sortPropertyInTree addDependent:self.
!

treeSelectionHolder
    treeSelectionHolder isNil ifTrue:[
        treeSelectionHolder := ValueHolder new.
        treeSelectionHolder addDependent:self.
    ].
    ^ treeSelectionHolder
!

treeSelectionHolder:aValueHolder
    treeSelectionHolder removeDependent:self.
    treeSelectionHolder := aValueHolder.
    treeSelectionHolder addDependent:self.
! !

!DirectoryTreeBrowser methodsFor:'change & update'!

changeMatchBlock
    self setMatchBlockInList:(self fileList).
    self currentFileNameHolderChanged.
!

currentFileNameHolderChanged
    |filesToSelect viewFiles|

    viewFiles:= self viewFilesInDirectoryTree value.
    viewFiles ifTrue:[
        filesToSelect := self currentSelectedObjects.
    ] ifFalse:[
        filesToSelect := self currentSelectedDirectories.
    ].
    self rootHolder notNil ifTrue:[
        self selectFiles:filesToSelect.
    ].

    "Modified: / 04-12-2006 / 13:15:42 / cg"
!

rootHolderChanged
    |list file rootHolder|

    list := self fileList.
    rootHolder := self rootHolder.
    file := rootHolder value.
    file notNil ifTrue:[
        file := file asFilename.
        file isDirectory ifTrue:[
"/            self withWaitCursorDo:[
                list directory:file
"/            ].
        ]
    ].
    rootHolder value:(list directory asString) withoutNotifying:self.
    (list size = 1 and:[list first isDirectory]) ifTrue:[list first expand:true]

    "Modified: / 25-07-2006 / 09:08:59 / cg"
!

selectionChanged
    |sel currentFileDir|

    "if viewFiles is false i can't take my 
     selection to overwrite currentFileNameHolder"
    sel := self selectedFiles.
    self viewFilesInDirectoryTree value ifFalse:[
        (self currentFilesAreInSameDirectory 
         and:[sel size == 1 and:[self currentSelectedObjects notEmpty]]) ifTrue:[
            currentFileDir := self getDirWithoutFileName:(self currentSelectedObjects first).
            sel first = currentFileDir ifTrue:[
                ^ self.
            ].
        ].
    ].
    self setCurrentFileNames:sel.

    "Modified: / 04-12-2006 / 13:15:51 / cg"
!

update:something with:aParameter from:aModel 
    "one of my models changed"

    "the execution of selectionChanged and currentFileNameHolderChanged must
     lock against each other because values mustn't be the same (e.g. no files
     in tree view)"

    (aModel == self currentFileNameHolder or:[aModel == self currentDirectories]) ifTrue:[
        super update:something with:aParameter from:aModel.
        self updateTreeSelection doIfUnLocked:[
            self updateToExternFileHolderLock doLocked:[
                self currentFileNameHolderChanged.
            ].
        ].
        ^ self.
    ].
    aModel == self treeSelectionHolder ifTrue:[
        self updateToExternFileHolderLock doIfUnLocked:[
            self updateTreeSelection doLocked:[
                self selectionChanged.
            ]
        ].
        ^ self
    ].
    aModel == self rootHolder ifTrue:[
        self rootHolderChanged.
        ^ self.
    ].
    aModel == self viewFilesInDirectoryTree ifTrue:[
        self sortInTreeVisibilityHolder value:(aModel value).
        self updateToExternFileHolderLock doLocked:[
            self changeMatchBlock.
        ].
        ^ self.
    ].
    aModel == self sortPropertyInTree ifTrue:[
        self sortFileListsBy:aModel value.
        ^ self.
    ].
    aModel == self sortCaselessInTreeBrowser ifTrue:[
        self sortPropertyInTree setValue:#baseName. 
        self sortPropertyInTree changed.
    ].
    aModel == self filterBlockHolder ifTrue:[
        " filter goes only on fileNames not on directories 
          have to change the matchBlock only if files are shown"
        self viewFilesInDirectoryTree value ifTrue:[
            self changeMatchBlock.
        ].
        ^ self
    ].
    super update:something with:aParameter from:aModel.
    ^ self
! !

!DirectoryTreeBrowser methodsFor:'drag & drop'!

dropDestinationPath
    |destination|

    destination := self fileList draggedItem.
    destination isNil ifTrue:[^ nil].

    ^ destination fileName.
!

dropOver:aDropContext 
    "called during drag & drop while moving over the widget."

    |lineNr newDest|

    inDropMode ifFalse:[^ self].

    lineNr  := self getLineNumberFor:aDropContext.
    lineNr notNil ifTrue:[
        newDest := self fileList at:lineNr ifAbsent:nil.
    ].
    (newDest isNil or:[newDest == self fileList draggedItem]) ifTrue:[
        ^ self
    ].
    newDest isDirectory ifFalse:[
        newDest := nil.
        canDropItem := false.
    ].
    self dropTargetItemChangedTo:newDest in:aDropContext.

    newDest notNil ifTrue:[
        aDropContext dropSource argument == #archivApplication ifTrue:[
            canDropItem := true.
        ] ifFalse:[
            canDropItem := self canDropFiles:(aDropContext dropObjects) for:newDest fileName.
        ].
    ].
!

dropTargetItemChangedTo:anItem in:aDropContext
     |current|

    current := self fileList draggedItem.
    current == anItem ifTrue:[^ self].

    self fileList draggedItem:anItem.

    aDropContext contentsWillChange.
    current notNil ifTrue:[
        current isDirectory ifTrue:[
            self removeExpandItemTimedBlock.
            current makeIconGray:false.
            current changed:#icon.
        ]
    ].

    anItem notNil ifTrue:[
        anItem isDirectory ifTrue:[
            anItem makeIconGray:true.
            anItem changed:#icon.
            (anItem notNil and:[anItem fileName isWritableDirectory]) ifTrue:[
                self 
                    setupAutoExpandItemTimedBlock:
                        [
                            self expandForDrop:anItem with:aDropContext.    
                        ].
            ]
        ].
    ].
    browser shown ifTrue:[
        browser repairDamage.
    ].

    "Modified: / 08-08-2010 / 14:42:21 / cg"
!

expandForDrop:item with:aDropContext

    aDropContext saveDraw:[
        (self doExpand:item) ifTrue:[
            self windowGroup processExposeEvents
        ].
    ]
!

getDisplayObjects:anArgument
    |selectedItems string fnName stream|

    selectedItems := self selectedItems.
    selectedItems isEmpty ifTrue:[ ^ ''].

    stream := CharacterWriteStream with:(selectedItems first baseName).
    selectedItems size == 1 ifTrue:[
        fnName := 'ui_menuitem.xpm'.
    ] ifFalse:[
        fnName := 'ui_submenu_open.xpm'.
        stream nextPutAll:' ... '.
        stream nextPutAll:(selectedItems last baseName).
    ].
    string := stream contents.
    stream close.

    fnName := 'ui_menuitem.xpm'.
    ^ Array with:(LabelAndIcon icon:(Image fromFile:fnName)
                             string:(Text string:string emphasis:#bold)
                 )
!

removeExpandItemTimedBlock
    |b|

    (b := expandItemTimedBlock) notNil ifTrue:[
        expandItemTimedBlock := nil.
        Processor removeTimedBlock:b.
    ]
!

setupAutoExpandItemTimedBlock:aBlock
    expandItemTimedBlock := aBlock.
    Processor 
        addTimedBlock:expandItemTimedBlock
        afterMilliseconds:(self class timeForExpandOnDropInMilliseconds).
! !

!DirectoryTreeBrowser methodsFor:'event handling'!

processEvent:anEvent
    "filter keyboard events.
     Return true, if I have eaten the event"

    <resource: #keyboard (#CursorLeft #FocusPrevious #FocusNext
                          #Cut #Copy #Delete #Replace #Paste )>

    |focusView key rawKey|

    anEvent isKeyPressEvent ifFalse:[^ false].

    focusView := anEvent targetView.
    (focusView isNil or:[focusView ~~ browser]) ifTrue:[ ^ false].

    key    := anEvent key.
    rawKey := anEvent rawKey.

    (key == #CursorLeft) ifTrue:[
        "go to last selection in selection history"
        (self rootSelected and:[(self fileList at:1) isExpanded not]) ifTrue:[
            self doGoDirectoryUp.
            ^ true
        ].
        ^ false
    ].
    (key == #FocusPrevious) ifTrue:[
        "go to last selection in selection history"
        self doBack.
        ^ true
    ].
    (key == #FocusNext) ifTrue:[
        "go to next selection in selection history"
        self doForward.
        ^ true
    ].
    (key == #Replace) ifTrue:[
        self renameFileInTreeView.
        ^ true
    ].
    (key == #Cut) ifTrue:[
        self doCut.
        ^ true
    ].
    (key == #Copy) ifTrue:[
        self doCopy.
        ^ true
    ].
    (key == #Delete) ifTrue:[
        self doDelete.
        ^ true
    ].
    (key == #Paste) ifTrue:[
        self pasteFiles.
        ^ true
    ].

    ^ false
! !

!DirectoryTreeBrowser methodsFor:'queries'!

hasOpenEditor

    ^ browser hasOpenEditor
!

masterIsFileBrowser

    ^ self masterApplication isKindOf: FileBrowserV2

    "Modified: / 04-05-2012 / 16:24:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedFilesIncludesNonRootDirectory
    ^ self selectedDirectories contains:[:aDir | (aDir asString) ~= (self rootHolder value)].

"/    |directories|
"/
"/    directories := self selectedDirectories.
"/    directories isEmpty ifTrue:[^ false].
"/    directories do:[:aDir|
"/        (aDir asString) ~= (self rootHolder value) ifTrue:[
"/            ^ true
"/        ]
"/    ].
"/    ^ false
! !

!DirectoryTreeBrowser methodsFor:'selection'!

firstSelectedDirectory

    | selection dirs dirIndices|

    selection := self selectedItems.
    selection isEmpty ifTrue:[ ^ nil ].

    dirs := selection collect:[:item| item isDirectory].
    dirs isEmpty ifTrue:[^ nil].
    dirIndices := selection 
                        collect:[:item | 
                            self fileList identityIndexOf:item.
                        ].
    ^ (self fileList at:(dirIndices min)) fileName.
!

rootSelected
    | selectedItems |

    selectedItems := self selectedItems.
    selectedItems isEmpty ifTrue:[^ false].
    ^ selectedItems includesIdentical:(self fileList root)
!

selectFiles:aColOfFileOrDirectory
    "selects a file; if the file is not included in my
     root directory, the root will be changed"

    |root items directory item newRoot rootDir|

    aColOfFileOrDirectory isEmpty ifTrue:[ self selectItems:#()].

    root := self fileList root. 
    root notNil ifTrue:[ rootDir := root fileName asAbsoluteFilename ].

    items := OrderedCollection new.
    aColOfFileOrDirectory do:[:eachFile|
        (eachFile notNil and:[eachFile exists]) ifTrue:[
            item := self fileList findLastForFile:eachFile inRoot:root directory:rootDir.
            item isNil ifTrue:[
                "/ set a new root directory
                newRoot := self commonPrefixOfSelectedFiles.
                newRoot := self getDirWithoutFileName:newRoot.
                newRoot := newRoot asAbsoluteFilename pathName.
                newRoot ~= self rootHolder value ifTrue:[
                    self rootHolder value:newRoot.
                ].
                item := self fileList root.

                eachFile isDirectory ifTrue:[ directory := eachFile ]
                                 ifFalse:[ directory := eachFile directory ]
                                  .
                directory == eachFile ifFalse:[
                    item := item detect:[:el| el fileName = eachFile ] ifNone:item.
                ].
            ].
            item notNil ifTrue:[
                "if it is a directory it should be expanded"
                "/ item enforcedExpand.
                items add:item.
            ].
        ].
    ].
    self selectItems:items

    "Modified: / 12-07-2012 / 11:31:20 / cg"
!

selectItems:aColOfItems
    |currentSelection newSelection|

    currentSelection := self selectedItems.
"/    aColOfItems do:[:anItem| anItem isDirectory ifTrue:[ anItem expand ]].

    self multipleSelect ifTrue:[
        currentSelection notNil ifTrue:[
            aColOfItems size == currentSelection size ifTrue:[
                (aColOfItems findFirst:[:item | (currentSelection includesIdentical:item) not ]) ~~ 0 ifFalse:[
                    ^ self
                ].
            ]
        ].
        newSelection := aColOfItems.
    ] ifFalse:[
        newSelection := aColOfItems isEmpty ifTrue:[nil] ifFalse:[aColOfItems first].
        newSelection == currentSelection ifTrue:[
            ^ self
        ]
    ].
            
    aColOfItems notEmpty ifTrue:[
        aColOfItems first makeVisible.
    ].
    self updateToExternFileHolderLock doLocked:[
        self treeSelectionHolder value:newSelection.
    ].
!

selectNextFile
    self halt:'unimplemented'.
!

selectPreviousFile
    self halt:'unimplemented'.
!

selectedDirectories
    ^ self selectedDirectoryItems collect:[: el | el fileName ].
!

selectedDirectoryItems
    ^ self selectedItems select:[: el | el isDirectory ].
!

selectedFilenameDirectories
    ^ self selectedItems 
        collect:[:item | self getDirWithoutFileName:(item fileName)] 
        as:Set
!

selectedItems
    | selection |

    selection := self treeSelectionHolder value.
    selection isNil ifTrue:[ ^ #() ].
    self multipleSelect ifTrue:[^ selection ].
    ^ Array with:selection. "Wrap single value into Array"
! !

!DirectoryTreeBrowser methodsFor:'startup & release'!

makeDependent

    super makeDependent.
    self currentFileNameHolder addDependent:self.
    self currentDirectories addDependent:self.
    self rootHolder addDependent:self.
    self viewFilesInDirectoryTree addDependent:self.
    self filterBlockHolder addDependent:self.
!

openEditorAction 
    ^ [:ln :aGC | 
                self openEditorIn:aGC forLine:ln
    ].
!

openEditorIn:aGC forLine:ln 
    |item alreadyAccepted filename field newFileString newFilename|

    alreadyAccepted := false.
    browser 
        closeEditorAction:[:editor | 
            alreadyAccepted ifFalse:[
                editor acceptAction value:(editor contents)
            ]
        ].

    self allowFileOperations value ifFalse:[^ nil].

    item := self fileList at:ln.
    item label isString ifFalse:[
        field := nil
    ] ifTrue:[
        field := EditField new.
        field level:0.
        field acceptOnReturn:true.
        field acceptOnLeave:true.
        field 
            acceptAction:[:x | 
                alreadyAccepted := true.
                filename := item fileName.
                newFileString := x asString withoutSeparators.
                filename baseName ~= newFileString ifTrue:[
                    (self 
                        renameFile:filename
                        to:newFileString
                        update:false) 
                    ifTrue:[
                        newFilename := filename directory construct:newFileString.
"/                        self withWaitCursorDo:[
                            self updateAndSelect:(OrderedCollection with:newFilename)
"/                        ]
                    ]
                ].
                aGC closeEditor.
                (field leaveKey == #CursorUp or:[field leaveKey == #CursorDown]) ifTrue:[
                    browser 
                        keyPress:field leaveKey
                        x:0
                        y:0
                ].
                field destroy.
                browser requestFocus    "/ takes it from my windowGroup; prevents it from shifting focus
            ].
        field font:(aGC font).
        field contents:(item label)
    ].
    ^ field

    "Modified: / 25-07-2006 / 09:08:45 / cg"
!

postBuildDirBrowser:aWidget 
    browser := aWidget scrolledView.
    "/ browser hasConstantHeight:true.
    self allowRenameOnOneClick ifTrue:[
        browser openEditorAction:self openEditorAction
    ].
    browser multipleSelectOk:self multipleSelect
!

postOpenFromMaster:fromMaster

"/    self windowGroup application class == FileBrowserV2 ifTrue:[
"/        self multipleSelect:true.
"/    ].
    self rootHolderChanged.
    fromMaster ifFalse:[
        self currentFileNameHolderChangedForCommon.
    ].
    self currentFileNameHolderChanged.
    self sortFileListsBy:self sortPropertyInTree value.
    self windowGroup addPreEventHook:self.
!

release
    self fileList stopMonitoringTask.
    ^ super release.
! !

!DirectoryTreeBrowser::DirTreeBrowserHFL methodsFor:'accessing'!

draggedItem

    ^ draggedItem
!

draggedItem:anItemOrNil

    draggedItem := anItemOrNil.
! !

!DirectoryTreeBrowser::DirTreeBrowserHFL methodsFor:'protocol'!

grayDirectoryIcon

    grayDirectoryIcon isNil ifTrue:[
        grayDirectoryIcon := (MIMETypeIconLibrary iconForKeyMatching:#directoryOpenGray).
    ].
    ^ grayDirectoryIcon
!

iconFor:anItem
    "returns the icon for an item
    "
    "/ Transcript showCR:'iconFor:anItem'.
    draggedItem == anItem ifTrue:[
        ^ self grayDirectoryIcon.
    ].
    ^ super iconFor:anItem.
! !

!DirectoryTreeBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

