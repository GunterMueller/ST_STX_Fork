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

AbstractDirectoryBrowser subclass:#DirectoryContentsBrowser
	instanceVariableNames:'modificationTime directory columnDescriptors iconIndex
		fileDescriptionIndex iconExtent tableColumns previewIndex
		draggedItem viewBrowserMenu updateContentsSelection
		selectionInFileList browserItemList matchBlock updateTask
		directoryChangeFlag directoryContentsChangeFlag filterChangeFlag
		sortBlockChangeFlag isBusy changeSema filteredItems allItems
		diskUsageInfo diskUsageUpdateProcess multipleSelect
		doubleClickAction updateCycleSemaphore updatingColumns accessLock
		enterActionBlock updateCurrentFileNameHolderWhenSelectionChanges'
	classVariableNames:'Debug'
	poolDictionaries:''
	category:'Interface-Tools-File'
!

Object subclass:#DirectoryContentsItem
	instanceVariableNames:'fileName fileInfo icon fileType
		contentsBrowserChangeModificationTime suffix preview group owner
		timeAndDate mimeType iconKey mimeTypeForContents baseName'
	classVariableNames:'LastUIDToUserNameMapping LastGIDToGroupNameMapping'
	poolDictionaries:''
	privateIn:DirectoryContentsBrowser
!

!DirectoryContentsBrowser class methodsFor:'documentation'!

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
    An application for displaying a directories' contents flat (or as a tree, alternatively).
    To be used as a building block in file browsers and fileSelection dialogs.
    This is used as the top-right component in the new fileBrowser.

    [author:]
        Christian Penk (penk@bierfix)

    [see also:]
        FileBrowserV2
"
!

examples
"
                                                                [exBegin]
    DirectoryContentsBrowser openIn:Filename currentDirectory
                                                                [exEnd]
"
! !

!DirectoryContentsBrowser class methodsFor:'instance creation'!

openIn:aDirectory
    "open a standalone broser for a directory"

    self openIn:aDirectory withDirectories:false

    "
      self openIn:'.cvsignore' asFilename
    "
!

openIn:aDirectory withDirectories:withDirectoriesBoolean
    "open a broswer (standalone) for a directory"

    |browser|

    browser := self new.
    browser open.
    aDirectory notNil ifTrue:[
        browser currentFileNameHolder value:(OrderedCollection with:aDirectory asFilename)
    ].
    browser viewDirsInContentsBrowser value:withDirectoriesBoolean.
    ^ browser

    "
      self openIn:Filename currentDirectory withDirectories:true
    "
! !

!DirectoryContentsBrowser class methodsFor:'classAccess'!

itemClass

    ^ DirectoryContentsItem


"
self itemClass
"
! !

!DirectoryContentsBrowser class methodsFor:'constant'!

updateTaskCyleTime
    "time to check for changed directories or changed columns
     (unless triggered by an action)"

    ^ 10 seconds

    "Modified (comment): / 20-03-2012 / 12:26:40 / cg"
!

updateTaskPriority
    "priority of the update task"

    ^ Processor userSchedulingPriority
! !

!DirectoryContentsBrowser class methodsFor:'image specs'!

detailsMenuIconDown
    <resource: #programImage>

    ^ DataSetLabel sortReverseIndicator
!

detailsMenuIconR
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self detailsMenuIconR inspect
     ImageEditor openOnClass:self andSelector:#detailsMenuIconR
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DirectoryContentsBrowser detailsMenuIconR'
        ifAbsentPut:[(Depth1Image width:5 height:7) bits:(ByteArray fromPackedString:'@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0]
            mask:((ImageMask width:5 height:7) bits:(ByteArray fromPackedString:' DB TJA@ @@a'); yourself); yourself]
!

detailsMenuIconUp
    <resource: #programImage>

    ^ DataSetLabel sortIndicator
! !

!DirectoryContentsBrowser class methodsFor:'interface specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:DirectoryContentsBrowser andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: ''
         labelIsImage: true
         labelButtonType: Group
         width: 22
         minWidth: 22
         height: 16
         model: icon
         menuFromApplication: false
         printSelector: icon
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Filename'
         labelAlignment: left
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'baseName'
         minWidth: 150
         height: heightOfFirstRow
         model: baseName
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Suffix'
         labelAlignment: left
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'suffix'
         usePreferredWidth: true
         width: 40
         height: heightOfFirstRow
         model: suffix
         canSelect: false
         isResizeable: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Inode'
         labelAlignment: left
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'inodeNumber'
         usePreferredWidth: true
         width: 75
         height: heightOfFirstRow
         model: inodeNumber
         canSelect: false
         isResizeable: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Perm'
         labelAlignment: left
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'permissions'
         usePreferredWidth: true
         width: 75
         height: heightOfFirstRow
         model: permissions
         canSelect: false
         isResizeable: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Owner'
         labelAlignment: left
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'owner'
         usePreferredWidth: true
         width: 50
         height: heightOfFirstRow
         model: owner
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Group'
         labelAlignment: left
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'group'
         usePreferredWidth: true
         width: 40
         height: heightOfFirstRow
         model: group
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Size'
         labelAlignment: right
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'fileSize'
         columnAlignment: right
         usePreferredWidth: true
         minWidth: 65
         height: heightOfFirstRow
         model: sizeString
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'KB'
         labelAlignment: right
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'fileSize'
         columnAlignment: right
         usePreferredWidth: true
         minWidth: 55
         height: heightOfFirstRow
         model: sizeInKiloBytesString
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Bytes'
         labelAlignment: right
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'fileSize'
         columnAlignment: right
         usePreferredWidth: true
         minWidth: 65
         height: heightOfFirstRow
         model: sizeInBytesString
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Date & Time'
         labelAlignment: right
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'modificationTime'
         columnAlignment: right
         usePreferredWidth: true
         width: 140
         height: heightOfFirstRow
         model: timeAndDate
         writeSelector: date:
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'File Info'
         labelAlignment: left
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'fileType'
         width: 250
         height: heightOfFirstRow
         model: fileInfoString
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Pre +/-'
         labelButtonType: Button
         labelActionSelector: doResizeImage
         labelActionArgument: ''
         columnAlignment: center
         width: 45
         height: 16
         model: preview
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DirectoryContentsBrowser andSelector:#windowSpec
     DirectoryContentsBrowser new openInterface:#windowSpec
     DirectoryContentsBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Directory ContentsBrowser'
          name: 'Directory ContentsBrowser'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 588 478)
          menu: menu
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'browser'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              model: selectionInFileList
              menu: directoryContentsBrowserMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: false
              miniScrollerVertical: false
              dataList: browserItemList
              useIndex: false
              has3Dsepartors: false
              doubleClickSelector: doubleClickedAt:
              columnHolder: tableColumns
              multipleSelectOk: true
              verticalSpacing: 0
              columns: 
             (OrderedCollection
                
               (DataSetColumnSpec
                  labelButtonType: Group
                  width: 22
                  minWidth: 22
                  height: 16
                  model: icon
                  canSelect: false
                  showRowSeparator: false
                  showColSeparator: false
                ) 
               (DataSetColumnSpec
                  label: 'file name'
                  labelAlignment: left
                  labelButtonType: Button
                  model: baseName
                  canSelect: false
                  showRowSeparator: false
                  showColSeparator: false
                )
                
               (DataSetColumnSpec
                  label: '+/-'
                  labelButtonType: Button
                  labelActionSelector: doResizeImage
                  labelActionArgument: ''
                  columnAlignment: center
                  width: 30
                  height: 16
                  model: preview
                  canSelect: false
                  showRowSeparator: false
                  showSelectionHighLighted: false
                  showColSeparator: false
                )
              )
              doubleClickChannel: doDoubleClick:
              postBuildCallback: postBuildBrowser:
              properties: 
             (PropertyListDictionary
                dropSelector: doDrop:
                dragArgument: contentsbrowser
                startDragSelector: doStartDrag:in:
                displayObjectSelector: getDisplayObjects:
                dropObjectSelector: getDropObjects:
                overSelector: dropOver:
                dropArgument: browser
                canDropSelector: canDrop:
                leaveSelector: dropLeave:
                enterSelector: dropEnter:
              )
            )
           )
         
        )
      )
! !

!DirectoryContentsBrowser class methodsFor:'menu specs'!

directoryContentsBrowserMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:DirectoryContentsBrowser andSelector:#directoryContentsBrowserMenu
     (Menu new fromLiteralArrayEncoding:(DirectoryContentsBrowser directoryContentsBrowserMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasSelection
            label: 'Open'
            itemValue: doShowFileContents
            translateLabel: true
          )
         (MenuItem
            enabled: hasSelection
            label: 'FileIn'
            itemValue: fileFileIn
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'SourceCodeManagement'
            translateLabel: true
            submenuChannel: scmMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'New'
            translateLabel: true
            submenuChannel: newMenu
            keepLinkedMenu: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Cut'
            itemValue: doCut
            translateLabel: true
            shortcutKey: Cut
          )
         (MenuItem
            label: 'Copy'
            itemValue: doCopy
            translateLabel: true
            shortcutKey: Copy
          )
         (MenuItem
            enabled: canPaste
            label: 'Paste'
            itemValue: pasteFiles
            translateLabel: true
            shortcutKey: Paste
          )
         (MenuItem
            label: 'Delete'
            itemValue: doDelete
            nameKey: delete
            translateLabel: true
            shortcutKey: Delete
          )
         (MenuItem
            label: 'Erase'
            itemValue: doErase
            nameKey: erase
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Rename...'
            itemValue: renameSelection
            translateLabel: true
            shortcutKey: Rename
          )
         (MenuItem
            enabled: hasSelection
            label: 'Move To...'
            itemValue: moveSelectionTo
            translateLabel: true
          )
         (MenuItem
            enabled: hasSelection
            label: 'Copy To...'
            itemValue: copySelectionTo
            translateLabel: true
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
            label: 'More'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Select All'
                  itemValue: selectAll
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: fileListIsNotEmpty
                  label: 'Copy Filenames'
                  itemValue: copyFileList
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'FileIn to Namespace...'
                  itemValue: fileFileInToNameSpace
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasTwoFilesSelected
                  label: 'Compare with Each Other'
                  itemValue: doCompareTwoFiles
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Tools'
            translateLabel: true
            submenuChannel: toolsMenuSpec
            keepLinkedMenu: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'View'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Details'
                  nameKey: View
                  translateLabel: true
                  submenuChannel: viewBrowserMenu
                )
               (MenuItem
                  label: 'Sort'
                  nameKey: Sort
                  translateLabel: true
                  submenuChannel: sortMenu
                )
               (MenuItem
                  label: 'Show'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'Hidden Files'
                        translateLabel: true
                        indication: showHiddenFiles
                      )
                     (MenuItem
                        label: 'Directories'
                        translateLabel: true
                        indication: viewDirsInContentsBrowser
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
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update'
            itemValue: updateCurrentDirectoryWithReread
            translateLabel: true
          )
         )
        nil
        nil
      )
!

viewBrowserMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DirectoryContentsBrowser andSelector:#viewBrowserMenu
     (Menu new fromLiteralArrayEncoding:(DirectoryContentsBrowser viewBrowserMenu)) startUp
    "

    <resource: #programMenu>

    ^ Menu decodeFromLiteralArray:self viewBrowserMenuSpec

    "Modified: / 27-03-2007 / 08:46:24 / cg"
!

viewBrowserMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DirectoryContentsBrowser andSelector:#viewBrowserMenuSpec
     (Menu new fromLiteralArrayEncoding:(DirectoryContentsBrowser viewBrowserMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Show Details'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewDetails
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Icon'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewIcon
          )
         (MenuItem
            enabled: viewDetails
            label: 'Suffix'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewType
          )
         (MenuItem
            enabled: viewDetails
            label: 'Inode'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewInodeNumber
          )
         (MenuItem
            enabled: viewDetails
            label: 'Permissions'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewPermissions
          )
         (MenuItem
            enabled: viewDetails
            label: 'Owner'
            translateLabel: true
            isVisible: userContextAvailable
            hideMenuOnActivated: false
            indication: viewOwner
          )
         (MenuItem
            enabled: viewDetails
            label: 'Group'
            translateLabel: true
            isVisible: userContextAvailable
            hideMenuOnActivated: false
            indication: viewGroup
          )
         (MenuItem
            enabled: viewDetails
            label: 'Size'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewSize
          )
         (MenuItem
            enabled: viewDetails
            label: 'Size (KByte)'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewSizeInKiloBytes
          )
         (MenuItem
            enabled: viewDetails
            label: 'Size (Byte)'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewSizeInBytes
          )
         (MenuItem
            enabled: viewDetails
            label: 'Date && Time'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewTime
          )
         (MenuItem
            enabled: viewDetails
            label: 'File Info'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewDescription
          )
         (MenuItem
            enabled: viewDetails
            label: 'Preview'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewPreview
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            label: 'Show Hidden Files'
            translateLabel: true
            isVisible: false
            indication: showHiddenFiles
          )
         (MenuItem
            label: 'Update'
            itemValue: updateCurrentDirectoryWithReread
            translateLabel: true
            isVisible: false
          )
         )
        nil
        nil
      )
! !

!DirectoryContentsBrowser methodsFor:'accessing'!

allItems
    allItems isNil ifTrue:[
        ^ OrderedCollection new.
    ].
    ^ allItems

    "Modified: / 20-03-2012 / 14:31:02 / cg"
!

allItems:something
    allItems := something.
!

browserFileList
    ^ self browserItemList collect:[:item | item fileName]
!

columnDescriptors
    "get the column description
    "
    ^ columnDescriptors
!

columnDescriptors:aListOfColumns
    "set the column description
    "
    columnDescriptors = aListOfColumns ifTrue:[
        ^ self
    ].

    columnDescriptors    := OrderedCollection new.
    previewIndex         := 0.
    iconIndex            := 0.
    fileDescriptionIndex := 0.
    iconExtent           := nil.

    aListOfColumns keysAndValuesDo:[:anIndex :aDesc| 
        |col readSelector|

        col := aDesc isSequenceable 
                ifTrue:[DataSetColumnSpec decodeFromLiteralArray:aDesc]
                ifFalse:[aDesc].
        columnDescriptors add:col.

        "/ cg: UGLY CODE NOTIFICATION
        readSelector := col readSelector.
        readSelector == #preview ifTrue:[
            previewIndex := anIndex.
            iconExtent := Point x:(col width) y:(col height).
        ] ifFalse:[
            readSelector == #fileInfoString ifTrue:[
                fileDescriptionIndex := anIndex.
            ] ifFalse:[
                readSelector == #icon ifTrue:[
                    iconIndex  := anIndex.
                ]
            ]
        ]
    ].

    "Modified: / 27-03-2007 / 08:46:33 / cg"
!

directory
    "returns the current directory or nil
    "
    ^ directory

!

directory:aDirectory
    "change the current directory and read the items
    "

    aDirectory ~= directory ifTrue:[
        directory notNil ifTrue:[
            AbstractFileBrowser directoryHistory setPosition:(browser firstLineShown) for:(directory pathName).
        ].
        directory := aDirectory.
        self wakeUpForDirectoryChanged.
    ]

    "Modified: / 07-01-2012 / 16:41:20 / cg"
!

directoryChangeFlag
    ^ directoryChangeFlag

    "Modified: / 07-01-2012 / 16:34:39 / cg"
!

directoryChangeFlag:aBoolean
    directoryChangeFlag := aBoolean.

    "Modified: / 01-10-2007 / 19:22:35 / cg"
    "Modified (format): / 07-01-2012 / 16:34:46 / cg"
!

directoryContentsChangeFlag
    "return the value of the instance variable 'directoryContentsChangeFlag' (automatically generated)"

    ^ directoryContentsChangeFlag

    "Modified: / 07-01-2012 / 16:34:51 / cg"
!

directoryContentsChangeFlag:aBoolean
    "set the value of the instance variable 'directoryContentsChangeFlag' (automatically generated)"

    directoryContentsChangeFlag := aBoolean.

    "Modified (format): / 07-01-2012 / 16:35:01 / cg"
!

doubleClickAction

    ^ doubleClickAction
!

doubleClickAction:aBlock

    " aBlock is a one arg block with selected index as argument "

    doubleClickAction := aBlock
!

enterActionBlock
    ^ enterActionBlock
!

enterActionBlock:aBlock
    enterActionBlock := aBlock.
!

filterChangeFlag
    "return the value of the instance variable 'filterChangeFlag' (automatically generated)"

    ^ filterChangeFlag

    "Modified: / 07-01-2012 / 16:35:07 / cg"
!

filterChangeFlag:aBoolean
    "set the value of the instance variable 'filterChangeFlag' (automatically generated)"

    filterChangeFlag := aBoolean.

    "Modified (format): / 07-01-2012 / 16:35:12 / cg"
!

isBusy
    "return the value of the instance variable 'isBusy' (automatically generated)"

    isBusy isNil ifTrue:[
        isBusy := false.
    ].
    ^ isBusy
!

isBusy:something
    "set the value of the instance variable 'isBusy' (automatically generated)"

    isBusy := something.
!

matchBlock
    "return the value of the instance variable 'matchBlock' (automatically generated)"

    ^ matchBlock
!

matchBlock:filterBlock

    matchBlock := filterBlock.
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

sortBlockChangeFlag
    "return the value of the instance variable 'sortBlockChangeFlag' (automatically generated)"

    ^ sortBlockChangeFlag

    "Modified: / 07-01-2012 / 16:35:20 / cg"
!

sortBlockChangeFlag:aBoolean
    "set the value of the instance variable 'sortBlockChangeFlag' (automatically generated)"

    sortBlockChangeFlag := aBoolean.

    "Modified (format): / 07-01-2012 / 16:35:25 / cg"
!

updateContentsSelection
    "return the value of the instance variable 'updateToExternFileHolder' (automatically generated)"

    updateContentsSelection isNil ifTrue:[
        updateContentsSelection := self class newLock.
    ].
    ^ updateContentsSelection
!

updateCurrentFileNameHolderWhenSelectionChanges
    ^ updateCurrentFileNameHolderWhenSelectionChanges
!

updateCurrentFileNameHolderWhenSelectionChanges:aBoolean
    updateCurrentFileNameHolderWhenSelectionChanges := aBoolean.
! !

!DirectoryContentsBrowser methodsFor:'actions'!

browserItemListAdd:addItemCol remove:remItemCol
    | browserList selection|

    (addItemCol isEmpty and:[remItemCol isEmpty]) ifTrue:[ ^ self].
    selection := self selectedItemsWithoutDotDotDirectory.
    remItemCol notEmpty ifTrue:[
        self browserItemList removeAllFoundIn:remItemCol        
    ].
    addItemCol notEmpty ifTrue:[
        browserList := self browserItemList copy.
        addItemCol do:[: aNewItem |
            (browserList includes:aNewItem) ifFalse:[
                browserList add:aNewItem.
                browserList := self sortBlockHolder value sortItemList:browserList.
                self browserItemList add:aNewItem beforeIndex:(browserList indexOf:aNewItem).
            ]
        ].
    ].
    self selectItems:selection.
!

currentSortOrderChanged

"/    self wakeUpForSortBlockChanged.

    "/ have to reread the columns to set the icon for sort direction
    "/ very expensive. Need to change table label directly
    self viewedColumnsChanged.
!

doResizeImage
    |column w h selection|

    previewIndex == 0 ifTrue:[^ self].

    column := columnDescriptors at:previewIndex.
    w := iconExtent  x.
    h := iconExtent y.

    w == column width ifTrue:[
        w := w * 2.
        h := h * 2.
    ].
    column width:w.
    column height:h.

"/Processor activeProcess ~~ self windowGroup process ifTrue:[self halt].
    selection := self selectedItems.
    browserItemList do:[:el| el resetImageFile ].
    browser columnDescriptors:(self tableColumns value).
    self selectItems:selection.
    self wakeUp.
!

doUpdate
"/    DirectoryContents flushCache.
    self wakeUpForDirectoryChanged.
    self updateDiskUsage.
    "/ updateCycleSemaphore wait.
!

doUpdateDirectoryContents
"/    DirectoryContents flushCache.
    self wakeUpForDirectoryContentsChanged.
    self updateDiskUsage.
    "/ updateCycleSemaphore wait.
!

doubleClickedAt:anItemIndex
    |action|

"/    self withWaitCursorDo:[
        (action := self doubleClickAction) notNil ifTrue:[
            action value:anItemIndex.
        ].
        self enterActionFor:(self browserItemList at:anItemIndex). "/ anItemIndex.
"/    ]

    "Modified: / 25-07-2006 / 09:07:55 / cg"
!

enterActionFor:anItem
    | filename info targetItem linkFile targetFile|

    enterActionBlock notNil ifTrue:[ 
        enterActionBlock value: anItem.
        ^ self.
    ].

    filename := anItem fileName.

    filename baseName = '..' ifTrue:[
        self setCurrentFileName:(self directory directory).
        ^ self.
    ].
    targetItem := anItem.
    targetFile := filename.

    [
       (info := targetFile linkInfo) notNil 
       and:[ info isSymbolicLink ]
    ] whileTrue:[
        targetItem := nil.
        info path isNil ifTrue:[^ self].
        linkFile := info path asFilename.   
        linkFile isRelative ifTrue:[
            targetFile := filename directory construct:info path.
        ] ifFalse:[
            targetFile := linkFile            
        ]
    ].

    filename := targetFile.

    (filename isDirectory) ifTrue:[
        self setCurrentFileName:filename.
        ^ self.
    ].

    targetItem isNil ifTrue:[
        targetItem := anItem class fileName:filename.
    ].

"/    self withWaitCursorDo:[
        self openApplByFileItem:targetItem.
"/    ]

    "Modified: / 25-07-2006 / 09:08:00 / cg"
    "Modified: / 27-08-2014 / 20:22:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

noOfShownFiles:noOfShownFiles noOfFiles:noOfFiles

    |info filterBox clr|

    info := (noOfShownFiles == 1 ifTrue:['%1 file'] ifFalse:['%1 files']).
    noOfShownFiles = noOfFiles ifFalse:[
        info := info,' (%2 total)'.
    ].
    self shownFiles 
        value:(resources 
                string:info 
                with:noOfShownFiles 
                with:noOfFiles).

    filterBox := self filterValueBox value.
    filterBox isNil ifTrue:[^ self ].

    noOfShownFiles ~= noOfFiles ifTrue:[
        clr := Color red lightened lightened lightened.
        [ 
            View drawingOnClosedDrawableSignal catch:[ 
                filterBox flash 
            ] 
        ] fork.                 
    ] ifFalse:[
        clr := self filterBackgroundColor value.
    ].
    filterBox backgroundColor:clr.

    "Created: / 20-03-2012 / 12:08:57 / cg"
!

setBrowserItemList:aFilteredItems

    |showDir showDirsOnTop directoryUpItem locItems browserList|

    showDir := self viewDirsInContentsBrowser value.
    showDirsOnTop := self showDirectoriesOnTop value.

    (showDir and:[self directory notNil and:[self directory isRootDirectory not]]) ifTrue:[
        locItems := OrderedCollection new.
        directoryUpItem := self class itemClass fileName:(self directory construct:'..').
        directoryUpItem notNil ifTrue:[
            locItems add:directoryUpItem.
        ].
        locItems addAll:(aFilteredItems ? #()).
    ] ifFalse:[
        locItems := aFilteredItems.
    ].
    (showDir and:[showDirsOnTop]) ifTrue:[ 
        locItems := (locItems select:[ :e | e isDirectory ]) , (locItems reject:[ :e | e isDirectory])
    ].
    self updateToExternFileHolderLock doLocked:[
        browserList := self browserItemList.

        (browserList sameContentsAs: locItems) ifTrue:[
            "/ same
        ] ifFalse:[
            "/ bugfix - first remove all entries in list
            browserList removeAll.
            browserList contents:locItems.
        ].
    ].
    self selectCurrentFiles.

    "Modified: / 20-03-2012 / 12:17:14 / cg"
    "Modified: / 12-08-2014 / 13:14:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateDiskUsage
    directory notNil ifTrue:[
        self flushRememberedDiskUsageInfoFor:directory.
    ] ifFalse:[
        self flushRememberedDiskUsageInfo.
    ].
    self startDiskUsageInfoProcess.
! !

!DirectoryContentsBrowser methodsFor:'aspects'!

browserItemList

    browserItemList isNil ifTrue:[
        browserItemList := List new.
    ].
    ^ browserItemList
!

currentDirectoryDisplayed
    "Return a directory as Filename that is currently displayed in the browser"

    ^ directory

    "Modified: / 15-01-2013 / 11:42:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionInFileList

    selectionInFileList isNil ifTrue:[
        selectionInFileList := ValueHolder new.
        selectionInFileList addDependent:self.
    ].
    ^ selectionInFileList
!

tableColumns

    tableColumns isNil ifTrue:[
        tableColumns := self class tableColumns asValue.
    ].
    ^ tableColumns.
!

valueHolderForColumn:id
    "xlate #suffix -> viewType, etc...
     i.e. for a columns readSelector, return my valueHolder"

    ^ self perform:('view' , id asUppercaseFirst) asSymbol
!

viewFileInfoString
    ^ self viewDescription
!

viewSizeInBytesString
    ^ self viewSizeInBytes
!

viewSizeInKiloBytesString
    ^ self viewSizeInKiloBytes
!

viewSizeString
    ^ self viewSize
!

viewSuffix
    ^ self viewType
!

viewTimeAndDate
    ^ self viewTime
! !

!DirectoryContentsBrowser methodsFor:'aspects-visibility'!

colVisibilityAspectFor:aKey ifAbsent:absentBlock
    "aspect for a columns visibility"

    |holder|

    holder := self aspectFor:aKey ifAbsent:absentBlock.
    holder onChangeSend:#viewedColumnsChanged to:self.
    ^ holder
!

viewDescription
    "aspect for show file description"

    ^ self colVisibilityAspectFor:#viewDescription ifAbsent:[ false asValue ].
!

viewDetails
    "aspect for show more file properties 
    "

    ^ self colVisibilityAspectFor:#viewDetails ifAbsent:[ true asValue ].

    "Modified: / 04-09-2006 / 09:46:43 / cg"
!

viewGroup
    " aspect for show group information "

    ^ self colVisibilityAspectFor:#viewGroup ifAbsent:[ false asValue ].
!

viewIcon
    " aspect for show file-type icon"

    ^ self colVisibilityAspectFor:#viewIcon ifAbsent:[ true asValue ].
!

viewInodeNumber
    " aspect for show inode number "

    ^ self colVisibilityAspectFor:#viewInodeNumber ifAbsent:[ false asValue ].
!

viewOwner
    " aspect for show owner information "

    ^ self colVisibilityAspectFor:#viewOwner ifAbsent:[ true asValue ].
!

viewPermissions
    " aspect for show permission information "

    ^ self colVisibilityAspectFor:#viewPermissions ifAbsent:[ false asValue ].

    "Modified: / 04-09-2006 / 09:46:12 / cg"
!

viewPreview

    " aspect for show image previev "

    ^ self colVisibilityAspectFor:#viewPreview ifAbsent:[ false asValue ].
!

viewSize
    " aspect for show-size information "

    ^ self colVisibilityAspectFor:#viewSize ifAbsent:[ true asValue ].
!

viewSizeInBytes
    " aspect for show size-in-bytes information "

    ^ self colVisibilityAspectFor:#viewSizeInBytes ifAbsent:[ false asValue ].
!

viewSizeInKiloBytes
    " aspect for show size-in-kilobytes information "

    ^ self colVisibilityAspectFor:#viewSizeInKiloBytes ifAbsent:[ false asValue ].
!

viewTime

    " aspect for show time information "

    ^ self colVisibilityAspectFor:#viewTime ifAbsent:[ true asValue ].
!

viewType
    " aspect for show suffix (type) information "

    ^ self colVisibilityAspectFor:#viewType ifAbsent:[ false asValue ].
! !

!DirectoryContentsBrowser methodsFor:'change & update'!

currentFileNameHolderChanged
    "filename changed
    "
    |newDir currentDir aColOfFiles|

    aColOfFiles := self currentSelectedObjects.
    aColOfFiles isEmpty ifTrue:[
        "/ selection is gone keep the current directory list
        ^ self
    ].
    (self currentFilesAreInSameDirectory) ifFalse:[
        self directory:nil.
        ^ self
    ].
    self currentSelectedDirectories size > 1 ifTrue:[
        self directory:nil.
        ^ self
    ].
    aColOfFiles size == 1 ifTrue:[
        self startDiskUsageInfoProcess.
    ].
    newDir := (self directoriesForFiles:aColOfFiles) first asCanonicalizedFilename. 
    currentDir := self directory.
    (currentDir notNil and:[newDir = currentDir asCanonicalizedFilename]) ifTrue:[
        self selectFiles:aColOfFiles.
        ^ self.
    ].
    "/ change of the directory filename 
    self directory:newDir.

    "Modified: / 04-12-2006 / 13:15:32 / cg"
!

filterBlockHolderChanged

    self matchBlock:(self filterBlockHolder value).
    self wakeUpForFilterChanged.
!

selectionChanged

    | selection newCurrentFilename |

    self directory isNil ifTrue:[^ self].   

    selection := self selectedFiles.
    selection isEmpty ifTrue:[
        newCurrentFilename := OrderedCollection with:self directory.
    ] ifFalse:[
        newCurrentFilename := selection.
    ].
    updateCurrentFileNameHolderWhenSelectionChanges ifTrue:[ 
        self currentSelectedObjects ~= newCurrentFilename ifTrue:[
             self currentFileNameHolder value:newCurrentFilename withoutNotifying:self
        ].
    ]

    "Modified: / 04-12-2006 / 13:15:37 / cg"
    "Modified: / 13-02-2015 / 20:57:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "one of my models changed
    "

    changedObject == self currentFileNameHolder ifTrue:[
        super update:something with:aParameter from:changedObject.
        self updateContentsSelection doIfUnLocked:[
            self currentFileNameHolderChanged.
        ].
        ^ self.
    ].             
    changedObject == self selectionInFileList ifTrue:[
        (changedObject value ? #()) do:[:eachSelectedItem |
            |fn|
            
            (eachSelectedItem modificationTime notNil
              and:[ (fn := eachSelectedItem fileName) notNil
              and:[ fn exists
              and:[ fn modificationTime > eachSelectedItem modificationTime ]]]
            ) ifTrue:[
                "/ the file was modified in the meantime.
                "/ flush its info.
                eachSelectedItem resetItem
            ].    
        ].

        self updateToExternFileHolderLock doIfUnLocked:[
            self updateContentsSelection doLocked:[
                self selectionChanged.
            ]
        ].
        ^ self.
    ].
    changedObject == self currentSortOrder ifTrue:[
        self currentSortOrderChanged.
        ^ self.
    ].
    changedObject == self filterBlockHolder ifTrue:[
        self filterBlockHolderChanged.
        ^ self.
    ].             
    changedObject == self sortBlockHolder ifTrue:[
        self wakeUpForSortBlockChanged.
        ^ self.
    ].             
    changedObject == self viewDirsInContentsBrowser ifTrue:[
        self sortBlockHolder value directoriesBeforeFiles:(self sortDirectoriesBeforeFiles value and:[self viewDirsInContentsBrowser value]).
        self wakeUpForFilterChanged.
        ^ self
    ].
    changedObject == self sortDirectoriesBeforeFiles ifTrue:[
        self sortBlockHolder value directoriesBeforeFiles:(self sortDirectoriesBeforeFiles value and:[self viewDirsInContentsBrowser value]).
        ^ self
    ].
    changedObject == self showDiskUsageHolder ifTrue:[
        self notify:''.
        changedObject value ifTrue:[
            self startDiskUsageInfoProcess.
        ] ifFalse:[
            self flushRememberedDiskUsageInfo
        ].
        ^ self
    ].

    super update:something with:aParameter from:changedObject
!

updateListAfterDelete:collectionOfFiles
    |indices firstIndex lastIndex nextIndex nextItem|

    collectionOfFiles size > 100 ifTrue:[
        super updateListAfterDelete:collectionOfFiles.
        ^ self
    ].

    indices := collectionOfFiles collect:[:eachFile | browserItemList findFirst:[:item | item fileName = eachFile]].
    lastIndex := indices max.
    firstIndex := indices min.
    nextIndex := lastIndex+1.
    nextIndex > browserItemList size ifTrue:[ nextIndex := firstIndex-1].
    nextItem := browserItemList at:nextIndex ifAbsent:nil.

    accessLock critical:[
        indices asSortedCollection 
            reverseDo:[:eachIndexToRemove |
                eachIndexToRemove ~~ 0 ifTrue:[
                        browserItemList removeIndex:eachIndexToRemove
                    ]
                ].
    ].

    self directoryContentsChanged. "/ to force update of the numberOfShown files.
    nextItem notNil ifTrue:[
        self
            enqueueDelayedAction:[ 
                self selectionInFileList value:(OrderedCollection with:nextItem).
                self selectItems:(OrderedCollection with:nextItem)  ].
"/        self selectionInFileList value:(OrderedCollection with:nextItem).
"/        self selectItems:(OrderedCollection with:nextItem).
    ].

    "Modified: / 20-03-2012 / 13:22:48 / cg"
!

viewPreviewChanged

    browserItemList do:[:el| el resetImageFile ].
    self viewedColumnsChanged.
!

viewedColumnsChanged

    |columns buffer currentSortOrder currentSortOrderColumn currentSortOrderReverse selection holder|

    selection := self selectedItems.
    buffer := self class tableColumns 
                collect:[:col| (DataSetColumnSpec decodeFromLiteralArray:col)].

    columns := buffer asOrderedCollection.
    self viewDetails value = false ifTrue:[
        browser showLabels:false.
        buffer do:[:col |
            (col readSelector = #baseName or:[col readSelector = #icon]) ifFalse:[
                columns remove:col.                
            ]
        ]
    ] ifFalse:[
        browser showLabels:true.
        currentSortOrder := self currentSortOrder value.
        currentSortOrderColumn := currentSortOrder at:#column ifAbsent:nil.
        currentSortOrderReverse := currentSortOrder at:#reverse ifAbsent:nil.
        buffer do:[:col |
            | id label icon |

            id := col readSelector.
            id notNil ifTrue:[
                (col labelActionArgument notNil and:[col labelActionArgument asSymbol == currentSortOrderColumn]) ifTrue:[
                    label := col label.
                    icon := currentSortOrderReverse 
                                ifTrue:[ self class detailsMenuIconDown] 
                                ifFalse:[ self class detailsMenuIconUp].
                    col label:(LabelAndIcon label:label icon:icon).
                ].  

                ((id == #baseName) or:[id == #baseNameWithOutSuffix]) ifTrue:[
                    self viewType value ifTrue:[
                        col readSelector:#baseNameWithOutSuffix
                    ] ifFalse:[
                        col readSelector:#baseName
                    ].
                ] ifFalse:[
                    holder := self valueHolderForColumn:id.
                    holder value ifFalse:[
                        columns remove:col. 
                    ].
                ]
            ]
        ]
    ].
    self updateToExternFileHolderLock doLocked:[
        self tableColumns value:columns.
    ].
    self columnDescriptors:(self tableColumns value).
    self selectItems:selection.
    self wakeUp.

    "Modified: / 27-03-2007 / 08:46:28 / cg"
! !

!DirectoryContentsBrowser methodsFor:'drag & drop'!

doStartDrag:aDropSource in:aView
    "set the cursors before starting the drag & drop operation"

    |selectedFiles|

    selectedFiles := self selectedFiles.
    (selectedFiles isEmpty) ifTrue:[
        ^ self.
    ].
    ^ super doStartDrag:aDropSource in:aView
!

dropDestinationPath
    |destinationPath|

    draggedItem isNil ifTrue:[
        destinationPath := self directory.
    ] ifFalse:[
        destinationPath := self getDirWithoutFileName:(draggedItem fileName).
        destinationPath baseName = '..' ifTrue:[
            destinationPath := self directory directory.
        ]
    ].

    ^ destinationPath
!

dropObjects:aCollectionOfDropObjects
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefined in order for drop to work."

    ^ self shouldImplement
!

dropOver:aDropContext 
    "called during drag & drop while moving over the widget."

    |lineNr newDest destinationFile|

    inDropMode ifFalse:[^ self].

    lineNr  := self getLineNumberFor:aDropContext.
    lineNr notNil ifTrue:[
        newDest := browserItemList at:lineNr.
        (newDest notNil and:[newDest isDirectory]) ifTrue:[
            destinationFile := newDest fileName.
            destinationFile baseName = '..' ifTrue:[
                destinationFile := self directory directory.
            ]
        ].
    ].

    newDest == draggedItem ifTrue:[
        "/ beyond last contents-line
        newDest isNil ifTrue:[
            canDropItem := self canDropFiles:(aDropContext dropObjects) for:self directory.
        ].
        ^ self
    ].

    destinationFile isNil ifTrue:[
        destinationFile := self directory.
    ].

    newDest ~~ draggedItem ifTrue:[
        aDropContext dropSource argument == #archivApplication ifTrue:[
            canDropItem := true.
        ] ifFalse:[
            canDropItem := self canDropFiles:(aDropContext dropObjects) for:destinationFile.
        ].
    ].
    self dropTargetItemChangedTo:newDest in:aDropContext.
!

dropTargetItemChangedTo:anItem in:aDropContext

    | current |

    
"/    (anItem notNil and:[anItem isDirectory]) ifTrue:[ self halt].
    current := draggedItem.
"/    Transcript showCR:'current:', (current isNil ifTrue:['nil'] ifFalse:[current fileName baseName]).
"/    Transcript showCR:'anItem:', (anItem isNil ifTrue:['nil'] ifFalse:[anItem fileName baseName]).
    current == anItem ifTrue:[^ self].
    draggedItem := anItem.

    aDropContext contentsWillChange.

    current notNil ifTrue:[
        current isDirectory ifTrue:[
            current icon:(self getIconFor:current).
        ].
    ].

    anItem notNil ifTrue:[
        anItem isDirectory ifTrue:[
            anItem icon:(MIMETypeIconLibrary iconForKeyMatching:#directoryOpenGray)
                        "/ (self class iconForKeyMatching:#directoryOpenGray).
        ].
    ].
    browser shown ifTrue:[
        browser invalidateVisibleRow:current colAt:iconIndex.
        browser invalidateVisibleRow:anItem colAt:iconIndex.
        browser repairDamage.
    ].

    "Modified: / 08-08-2010 / 14:41:53 / cg"
!

getDisplayObjects:anArgument
    |selectedItems string fnName stream|

    selectedItems := self selectedFiles.
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

    ^ Array with:(LabelAndIcon icon:(Image fromFile:fnName)
                             string:(Text string:string emphasis:#bold)
                 )
! !

!DirectoryContentsBrowser methodsFor:'event handling'!

processEvent:anEvent
    "filter keyboard events.
     Return true, if I have eaten the event"

    <resource: #keyboard (#Accept #Paste #CursorLeft #Cut #Copy #Delete 
                          #Return #Rename)>

    |focusView key rawKey|

    anEvent isKeyPressEvent ifFalse:[^ false].

    focusView := anEvent targetView.
    (focusView isNil or:[focusView ~~ browser]) ifTrue:[ ^ false].

    key := anEvent key.
    rawKey := anEvent rawKey.

   "/ (key ~= #'Alt_L') ifTrue:[self halt.].
   "/ cg: removed; too dangerous, because it depends on which view has
   "/ the focus - in the codeView, it is a save; in the list, it is a fileIn.
   "/ this is confusing to newcomers.
"/    key == #Accept ifTrue:[
"/        self withActivityIndicationDo:[
"/            self fileFileIn.
"/        ].
"/        ^ true.
"/    ].
    key == #Paste ifTrue:[
        self pasteFiles.
        ^ true.
    ].
"/ strange feeling, because behavior is different depending on
"/ where the mouse pointer is (treeView vs. contentsView)
"/
    (key == #CursorLeft) ifTrue:[
        self doGoDirectoryUp.
        ^ true
    ].
"/    (key == #CursorRight) ifTrue:[
"/        self doBack.
"/        ^ true
"/    ].
    browserItemList size == 0 ifTrue:[
        ^ false
    ].

    key == #Cut ifTrue:[
        self doCut.
        ^ true.
    ].
    key == #Copy ifTrue:[
        self doCopy.
        ^ true.
    ].
    ((key == #Delete) or:[key == #BackSpace]) ifTrue:[
        self doDelete.
        ^ true.
    ].
    (key == #Return) ifTrue:[
        self enterAction.
        ^ true.
    ].
    key == #Rename ifTrue:[
        self renameSelection.
        ^ true.
    ].

    ^ false

    "Modified: / 25-07-2006 / 09:08:16 / cg"
! !

!DirectoryContentsBrowser methodsFor:'initialization'!

initialize
    changeSema := Semaphore new. 
    updateCycleSemaphore := Semaphore new.
    accessLock := RecursionLock new.

    filterChangeFlag := false.
    sortBlockChangeFlag := false.
    directoryChangeFlag := false.
    directoryContentsChangeFlag := false.

    enterActionBlock := nil.
    updateCurrentFileNameHolderWhenSelectionChanges := true.

    super initialize.

    "Modified: / 07-01-2012 / 16:34:25 / cg"
    "Modified: / 13-02-2015 / 20:56:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DirectoryContentsBrowser methodsFor:'menu accessing'!

viewBrowserMenu

    <resource: #programMenu >

    |menu|

    viewBrowserMenu isNil ifTrue:[
        viewBrowserMenu :=  self class viewBrowserMenu.
    ].
    viewBrowserMenu isNil ifTrue:[ ^ nil ].
    viewBrowserMenu findGuiResourcesIn:self.

    menu := viewBrowserMenu.
    menu receiver:self.
    ^ menu
! !

!DirectoryContentsBrowser methodsFor:'menu actions'!

doShowFileContents

    | selectedFileItems|

    selectedFileItems := self selectedFileItems.
    (selectedFileItems size == 1) ifTrue:[ 
        self openNewTextEditorOn:(selectedFileItems first).
    ].
!

enterAction

    | selectedItems|

    selectedItems := self selectedItems.
    (selectedItems size == 1) ifTrue:[ 
        self enterActionFor:(selectedItems first).
    ].
! !

!DirectoryContentsBrowser methodsFor:'queries'!

allItemsOfCurrentDirectory
    self viewDirsInContentsBrowser value ifTrue:[
        ^ browserItemList copyFrom:2.      "/ remove the '..' item
    ].
    ^ browserItemList.
!

fileListIsEmpty

    ^ browserItemList isEmpty
!

getAllFilesAsStrings
    browserItemList isEmpty ifTrue:[
        ^ #()
    ].
    ^ browserItemList 
        select:[:anItem | anItem isDirectory not]
        thenCollect:[:eachItem | eachItem fileName asString].
!

hasFilesFiltered

    ^ self allItems size ~~ browserItemList size
! !

!DirectoryContentsBrowser methodsFor:'selection'!

selectAll

    | sel|

    sel := browserItemList copy.
    self viewDirsInContentsBrowser value ifTrue:[
        sel removeIdentical:(browserItemList first) ifAbsent:[nil]
    ].
    self selectionInFileList value:sel.
!

selectCurrentFiles

    |currentSelection|

    ((currentSelection := self currentSelectedObjects reject:[:file| file isDirectory]) notEmpty) ifTrue:[
        self selectFiles:currentSelection.
    ].

    "Modified: / 04-12-2006 / 13:15:34 / cg"
!

selectFiles:aColOfFilenames
    | curSel newSel|

    curSel := self selectedFiles.
    aColOfFilenames size = curSel size ifTrue:[
        "/ anything changed ?
        (curSel contains:[:file| (aColOfFilenames includes:file) not]) ifFalse:[^ self].
    ].
    newSel := OrderedCollection new.
    browserItemList do:[: item|
        (aColOfFilenames includes:(item fileName)) ifTrue:[
            newSel add:item.
        ].
    ].
    self updateToExternFileHolderLock doLocked:[
        self selectionInFileList value:newSel withoutNotifying:self.
    ].
!

selectItems:aColOfItems
    self selectFiles:(aColOfItems collect:[:eachItem | eachItem fileName]).

"/    | curSel newSel|
"/
"/    curSel := self selectedItems.
"/    aColOfItems size = curSel size ifTrue:[
"/        | index |
"/        index := curSel findFirst:[:item| (aColOfItems includes:item) not].
"/        index == 0 ifTrue:[ ^ self].
"/    ].
"/    newSel := OrderedCollection new.
"/    browserItemList do:[: item|
"/        (aColOfItems includes:item) ifTrue:[
"/            newSel add:item.
"/        ].
"/    ].
"/    self updateToExternFileHolderLock doLocked:[
"/        self selectionInFileList value:newSel withoutNotifying:self.
"/    ].
!

selectNextFile
    |sel idx nextIdx nextItem|

    sel := selectionInFileList value.
    sel isEmpty ifTrue:[
        idx := 0
    ] ifFalse:[
        idx := browserItemList indexOf:(selectionInFileList value last).
    ].
    nextIdx := idx == browserItemList size ifTrue:[1] ifFalse:[idx + 1].
    nextItem := browserItemList at:nextIdx.
    self selectItems:{ nextItem }.
!

selectPreviousFile
    |sel idx prevIdx prevItem|

    sel := selectionInFileList value.
    sel isEmpty ifTrue:[
        idx := browserItemList size + 1
    ] ifFalse:[
        idx := browserItemList indexOf:(selectionInFileList value first).
    ].
    prevIdx := idx == 1 ifTrue:[browserItemList size] ifFalse:[idx - 1].
    prevItem := browserItemList at:prevIdx.
    self selectItems:{ prevItem }.
!

selectedFileItems

    | sel |

    sel := self selectedItemsWithoutDotDotDirectory reject:[:item | item isDirectory].
    ^ sel
!

selectedFileNames
    ^ self selectedFileItems collect:[:item| item fileName].
!

selectedFiles

    ^ self selectedItemsWithoutDotDotDirectory collect:[:item| item fileName].
!

selectedItems
    | selection |

    selection := self selectionInFileList value copy.
    selection isNil ifTrue:[ ^ #()].
    selection isSequenceable ifFalse:[
        selection := OrderedCollection with:selection
    ].
    ^ selection.
!

selectedItemsWithoutDotDotDirectory
    | selection |

    selection := self selectionInFileList value.
    selection isNil ifTrue:[ ^ #()].
    selection isSequenceable ifFalse:[
        selection := OrderedCollection with:selection.
    ].
    selection := selection reject:[:e | e isNil].
    selection isEmpty ifTrue:[ ^ #()].
    selection := selection copyAsOrderedCollection.
    (self viewDirsInContentsBrowser value and:[browserItemList notEmpty]) ifTrue:[
        selection removeIdentical:(browserItemList first) ifAbsent:[nil]
    ].
    ^ selection.
! !

!DirectoryContentsBrowser methodsFor:'startup & release'!

makeDependent

    super makeDependent.
    self currentFileNameHolder addDependent:self.
    self currentSortOrder addDependent:self.
    self viewDirsInContentsBrowser addDependent:self.
    self sortDirectoriesBeforeFiles addDependent:self.
    self filterBlockHolder addDependent:self.
    self sortBlockHolder addDependent:self.
!

postBuildBrowser:aWidget

    browser       := aWidget scrolledView.
    browser wantsFocusWithPointerEnter.
"/ don't register icons anymore
"/    FileBrowser icons keysAndValuesDo:[:aKey :anIcon|
"/        browser registerImage:anIcon key:aKey.
"/    ].
"/    self columnDescriptors:(self tableColumns value).
!

postOpenFromMaster:fromMaster

    self sortFileListsBy:(self sortBlockProperty value) withReverse:(self currentSortOrder value).
    self matchBlock:(self filterBlockHolder value).
    fromMaster ifFalse:[
        self currentFileNameHolderChangedForCommon.
    ].
    self startUpdateTask.
    self currentFileNameHolderChanged.
    self viewedColumnsChanged.
    self windowGroup addPreEventHook:self.
!

release
    "release my resources
    "                    
    self stopUpdateTask.
    super release.
!

releaseAsSubCanvas

    self stopUpdateTask.
    ^ super releaseAsSubCanvas.
! !

!DirectoryContentsBrowser methodsFor:'update columns cycle'!

findNextItemFor:aConditionBlock
    |checkRowAndReturnItemIfConditionIsTrue 
     firstRowShown lastRowShown rLow rHigh numItems|

    checkRowAndReturnItemIfConditionIsTrue := 
        [:row | |item|
            item := browserItemList at:row ifAbsent:nil.
            item notNil ifTrue:[
                (aConditionBlock value:item) ifTrue:[
                    ^ item.
                ]
            ].
        ].

    firstRowShown := browser indexOfFirstRowShown.
    lastRowShown := browser indexOfLastRowShown.

    firstRowShown to:lastRowShown do:checkRowAndReturnItemIfConditionIsTrue.

    numItems := browserItemList size.

    rLow := firstRowShown - 1.
    rHigh := lastRowShown + 1.
    [(rLow >= 1) or:[ rHigh <= numItems]] whileTrue:[
        rLow >= 1 ifTrue:[
            checkRowAndReturnItemIfConditionIsTrue value:rLow.
            rLow := rLow - 1
        ].
        rHigh <= numItems ifTrue:[
            checkRowAndReturnItemIfConditionIsTrue value:rHigh.
            rHigh := rHigh + 1
        ].
    ].
    ^ nil.

"/    ^ self allItems detect:aBlock ifNone:[nil].
!

findNextVisibleItemFor:aConditionBlock
    |firstRow row item|

    firstRow := browser indexOfFirstRowShown.
    firstRow <= 0 ifTrue:[firstRow := 1].

    row := firstRow.
    [true] whileTrue:[
        ((row <= browserItemList size) and:[ (browser isRowVisible:row) ]) ifFalse:[
            ^ nil.
        ].
        item := browserItemList at:row ifAbsent:[^ nil "possible race condition - item removed from browserItemList"].
        (aConditionBlock value:item) ifTrue:[
            ^ item.
        ].
        row := row + 1.
    ]

    "Modified: / 18-07-2006 / 08:56:47 / cg"
!

getFileInfoFor:anItem

    | type|

    type := anItem fileName fileType.
    anItem fileType:type.
    ^ type
!

getIconFor:anItem
    |icon|

    icon := MIMETypeIconLibrary iconForKeyMatching:anItem iconKey.
    anItem isRemoteDirectory ifTrue:[
        ^ icon "/ do not query attributes
    ].
    ^ MIMETypeIconLibrary addOnIconsFor:(anItem fileName) to:icon.
!

getIconForMimeType:mime for:anItem
    |currentIcon newIcon images|

    newIcon := MIMETypeIconLibrary iconForKeyMatching:mime.
    currentIcon := anItem iconOrNil.

    (currentIcon notNil and:[currentIcon class == MultiImage]) ifTrue:[
        images := currentIcon images.
        images removeFirst.
        images addFirst:newIcon.
        ^ currentIcon.
    ].
    ^ newIcon.
!

getIconForMimeTypeByContents:anItem
    ^ self getIconForMimeType:(anItem mimeTypeForContents) for:anItem
!

getPreviewFor:anItem

    | column icon|   
    
    previewIndex == 0 ifTrue:[^ nil].
    previewIndex isNil ifTrue:[^ nil].

    column := browser columnDescriptorAt:previewIndex.
    column isNil ifTrue:[
        previewIndex := 0.
    ] ifFalse:[
        (anItem hasMimeType and:[anItem mimeType isImageType]) ifTrue:[
            Error handle:[:ex|
                icon := nil.
            ] do:[ |scale extent w h |
                icon := Image fromFile:(anItem fileName pathName).
                icon notNil ifTrue:[
                    extent := icon extent.
                    w := column width - 4.
                    h := column height.

                    (extent x > w or:[extent y > h]) ifTrue:[
                        scale := extent / (w@h).
                        scale := scale x max:(scale y).
                        icon  := icon magnifiedTo:((extent / scale max:8.0) asInteger).
                    ].
                    icon := icon onDevice:(browser device).
                ]
            ]
        ] ifFalse:[ icon := nil].
        anItem preview:(icon ? '').
    ].
    ^ icon
!

updateColumnsCycle
    "update items in the following order
        - update item if item properties are changed
        - update icon for visible items by suffix
        - update icon for visible items by contents
        - update file info for visible items if file info column is shown 
        - update preview for visible items if preview column is shown 

        - update icon for invisible items by suffix
        - update icon for invisible items by contents
        - update file info for invisible items if file info column is shown 
        - update preview for invisible items if preview column is shown 
        - update file info for invisible items if file info column is not shown
     Return true, if more is to be done.
    "

    |desc mime icon type preview|

    browserItemList notEmpty ifTrue:[
        "/ update item if item's properties have changed
"/        desc := self findNextVisibleItemFor:[:n| n accessFirstTime ].
"/        desc notNil ifTrue:[
"/            browser invalidateVisibleRow:desc.
"/            self debugMessage:'item properties are changed ', desc baseName.
"/            ^ true.
"/        ].

        "/ update icon for visible items by suffix
        desc := self findNextVisibleItemFor:[:n| n iconOrNil isNil ].
        desc notNil ifTrue:[  
            icon := self getIconFor:desc.
            icon notNil ifTrue:[
                icon ~= desc icon ifTrue:[
                    desc icon:icon.
                    (iconIndex ~~ 0) ifTrue:[
                        browser invalidateVisibleRow:desc colAt:iconIndex
                    ].
                    self debugMessage:'icon for visible items ', desc baseName.
                    ^ true
                ].
            ].
        ].
        "/ update icon for visible items by contents
        desc := self findNextVisibleItemFor:
                    [:n| 
                        (n iconKey == #file 
                        and:[(mime := n mimeTypeForContents asSymbol) ~= #unknown])
                    ].
        desc notNil ifTrue:[
            icon := self getIconForMimeType:mime for:desc.
"/            icon := self getIconForMimeTypeByContents:desc.
            icon ~= desc icon ifTrue:[
                desc icon:icon.
                (icon notNil and:[iconIndex ~~ 0]) ifTrue:[
                    browser invalidateVisibleRow:desc colAt:iconIndex
                ].
            ].
            ^ true
        ].
        "/ update file info for visible items if file info column is shown
        fileDescriptionIndex ~~ 0 ifTrue:[
            desc := self findNextVisibleItemFor:[:n| n fileType isEmpty ].
            desc notNil ifTrue:[
                type := self getFileInfoFor:desc.
                type notNil ifTrue:[
                    browser invalidateVisibleRow:desc colAt:fileDescriptionIndex
                ].
                self debugMessage:'file info for visible items if file info column is shown ', desc baseName.
                ^ true
            ]
        ].
        "/ update preview for visible items if preview column is shown
        previewIndex ~~ 0 ifTrue:[
            desc := self findNextVisibleItemFor:[:n| n preview isNil ].
            desc notNil ifTrue:[
                preview := self getPreviewFor:desc.
                preview notNil ifTrue:[
                    browser invalidateVisibleRow:desc colAt:previewIndex
                ].
                self debugMessage:'preview for visible items if preview column is shown ', desc baseName.
                ^ true
            ]
        ].
    ].

    "/ validate invisible items to make them available after scrolling
    self allItems notEmpty ifTrue:[
        "/ update icon for invisible items by suffix
        desc := self findNextItemFor:[:n| n iconOrNil isNil ].
        desc notNil ifTrue:[
            icon := self getIconFor:desc.
            icon notNil ifTrue:[
                desc icon:icon.
                browser invalidateVisibleRow:desc colAt:iconIndex.
                self debugMessage:'icon for invisible items by suffix ', desc baseName.
                ^ true
            ].
        ].
        "/ update icon for invisible items by contents
        desc := self findNextItemFor:[:n| (n iconKey == #file and:[n mimeTypeForContents ~= #unknown])].
        desc notNil ifTrue:[
            icon := self getIconForMimeTypeByContents:desc.
            desc icon:icon.
            browser invalidateVisibleRow:desc colAt:iconIndex.
            self debugMessage:'icon for invisible items by contents ', desc baseName.
            ^ true
        ].
        "/ update file info for invisible items if file info column is shown
        fileDescriptionIndex ~~ 0 ifTrue:[
            desc := self findNextItemFor:[:n| n fileType isNil ].
            desc notNil ifTrue:[
                self getFileInfoFor:desc.
                self debugMessage:'update file info for invisible items if file info column is shown ', desc baseName.
                ^ true
            ].
        ].
        "/ update preview for invisible items if preview column is shown 
        previewIndex ~~ 0 ifTrue:[
            desc := self findNextItemFor:[:n| n preview isNil ].
            desc notNil ifTrue:[
                self getPreviewFor:desc.
                self debugMessage:'update preview for invisible items if preview column is shown: ', desc baseName.
                ^ true
            ].
        ].
        "/ update file info for invisible items if file info column is not shown
        desc := self findNextItemFor:[:n| n fileType isNil ].
        desc notNil ifTrue:[
            self getFileInfoFor:desc.
            self debugMessage:'update file info for invisible items if file info column is not shown: ', desc baseName.
            ^ true
        ].
    ].
    ^ false

    "Modified: / 20-03-2012 / 13:05:28 / cg"
! !

!DirectoryContentsBrowser methodsFor:'update task'!

createItemList
    "reread the whole list of items"

    |rawFilteredItems|

    directory notNil ifTrue:[
        self allItems:self readDirectoryItems.
        rawFilteredItems := self evaluateFilter:(self allItems).
        filteredItems := self sortBlockHolder value sortItemList:rawFilteredItems.

"/        Transcript showCR:'getAllTime:', getAllTime asString.
"/        Transcript showCR:'filterTime:', filterTime asString.
"/        Transcript showCR:'sortTime:', sortTime asString.
"/        Transcript showCR:'time after sort', Timestamp now asString.
    ] ifFalse:[
        self allItems:OrderedCollection new.
        filteredItems := OrderedCollection new.
    ].
    self
        enqueueMessage:#setBrowserItemList: 
        arguments:(Array with:filteredItems).
!

debugMessage:aString
    Debug == true ifTrue:[
        Transcript showCR:aString
    ].

    "
     Debug := true
     Debug := false
    "

    "Modified (comment): / 07-01-2012 / 16:30:25 / cg"
!

directoryChanged
    "reread the whole list of items"

    |pos|

    self setBrowserItemList:#().
    directoryContentsChangeFlag := true.
"/ ^ self.

    self createItemList.

    directory notNil ifTrue:[
        pos := AbstractFileBrowser directoryHistory getPositionFor:(directory pathName).
"/ self halt.
        pos notNil ifTrue:[
            browser scrollToLine:pos.
        ]
    ].

    "Modified: / 20-03-2012 / 13:16:25 / cg"
!

directoryContentsChanged
    |oldItems itemsToAdd itemsToRemove newItems newAllItems oldAllItems|

    directory isNil ifTrue:[^ self].

    "/ updatingColumns := true.

    newAllItems := self readDirectoryItems.
    
    oldItems := filteredItems copy ? #().

    (oldItems isEmptyOrNil 
    or:[newAllItems size > 150]) ifTrue:[ 
        self createItemList.
        filterChangeFlag := false.
        ^ self
    ].

    newItems := self evaluateFilter:newAllItems.
    itemsToAdd := OrderedCollection new.
    itemsToRemove := OrderedCollection new.

    oldItems notEmptyOrNil ifTrue:[ 
        "/ MERGE WITH CURRENT CONTENTS
        oldItems copy do:[:anOldItem|
            "/ remove no longer valid files
            (newItems includes:anOldItem) ifFalse:[
                itemsToRemove add:anOldItem.
                oldItems removeIdentical:anOldItem
            ]
        ].
    ].
    "/ add new files
    newItems do:[:aNewItem|
        (oldItems includes:aNewItem) ifFalse:[
            itemsToAdd add:aNewItem.
        ]
    ].
    oldAllItems := self allItems.
    oldAllItems notEmpty ifTrue:[
        oldAllItems removeAllFoundIn:itemsToRemove        
    ].
    itemsToAdd do:[: aNewItem |
        (oldAllItems includes:aNewItem) ifFalse:[
            oldAllItems add:aNewItem.
        ]
    ].
    self
        enqueueDelayedAction:[ 
            self browserItemListAdd:itemsToAdd remove:itemsToRemove. 
            filterChangeFlag := false.
        ].
    filteredItems := newItems.

    "Modified: / 23-03-2012 / 14:42:32 / cg"
!

evaluateFilter:anItemsList
    "return filtered items from anItemsList"

    |showDir showHidden filterBlock newItemList noOfShownFiles noOfFiles showFiles|

    noOfFiles := 0.
    noOfShownFiles := 0.

    showHidden := self showHiddenFiles value.
    showDir := self viewDirsInContentsBrowser value.
    showFiles := self viewFilesInContentsBrowser value.
    
    filterBlock := self matchBlock ? [:v1 :v2 | true ].
    newItemList := anItemsList 
                        select:[:eachItem |
                            |isDir showIt|

                            isDir := eachItem isDirectory.
                            isDir ifFalse:[noOfFiles := noOfFiles + 1].

                            showIt := isDir 
                                        ifTrue:[ showDir and:[ showHidden or:[ eachItem fileName isHidden not ]]]
                                        ifFalse:[ showFiles and:[filterBlock 
                                                                    value:eachItem fileName 
                                                                    value:eachItem baseName]].

                            showIt ifTrue:[
                                isDir ifFalse:[noOfShownFiles := noOfShownFiles + 1].
                            ].
                            showIt
                        ].

    self noOfShownFiles:noOfShownFiles noOfFiles:noOfFiles.
    ^ newItemList

    "Modified: / 20-11-2012 / 14:28:33 / cg"
!

filterChanged
    |newFilteredItems|

    newFilteredItems := self evaluateFilter:self allItems copy.
    filterChangeFlag ifTrue:[^ self].

    newFilteredItems ~= filteredItems ifTrue:[
        filteredItems := newFilteredItems.
        filteredItems := self sortBlockHolder value sortItemList:filteredItems.
        self
            enqueueDelayedAction:[ self setBrowserItemList:filteredItems ].
    ].

    "Modified: / 20-11-2012 / 14:28:54 / cg"
!

modificationCycle
    | oldModificationTime  desc|

    directory isNil ifTrue:[^ self].

    directory exists ifFalse:[
        "/ directory vanished
        directoryContentsChangeFlag := true.
        ^ self
    ].
    directory isRootDirectory ifTrue:[
        ^ self
    ].

    oldModificationTime := modificationTime.
    modificationTime := directory modificationTime.

    oldModificationTime ~= modificationTime ifTrue:[
        directoryContentsChangeFlag := true.
        self wakeUpForDirectoryContentsChanged.
        ^ self
    ].

    desc := self findNextItemFor:[:n| n hasBeenModified ].

    desc notNil ifTrue:[
        desc resetItem.
        browser invalidateVisibleRow:desc.
        self debugMessage:'item is modified ', desc baseName.
        ^ self.
    ].

    "Modified: / 20-03-2012 / 12:24:38 / cg"
!

readDirectoryItems
    |list contents itemClass|

    list     := OrderedCollection new.
    contents := DirectoryContents directoryNamed:directory.

    contents notEmptyOrNil ifTrue:[
        itemClass := self class itemClass.
        modificationTime := contents modificationTime.

        contents itemsDo:[:eachItem|
            list add:(itemClass forInfoItem:eachItem).
        ].
    ].
    ^ list
!

sortBlockChanged

    filteredItems isNil ifTrue:[ ^ self].
    filteredItems := self sortBlockHolder value sortItemList:filteredItems.
    self
        enqueueDelayedAction:[ self setBrowserItemList:filteredItems ].
!

startUpdateTask
    (updateTask isNil or:[updateTask isDead]) ifTrue:[
        updateTask := [ 
                        [self isOpen] whileTrue:[
                            self updateStep
                        ] 
                      ] newProcess.
        updateTask name:'DirectoryContentsBrowser updateTask'.
        updateTask priorityRange:(Processor userBackgroundPriority to:Processor activePriority).
        updateTask restartable:true.
        updateTask resume.
    ].

    "Modified: / 10-08-2010 / 14:03:57 / sr"
!

stopUpdateTask

    updateTask notNil ifTrue:[
        updateTask terminate.
        updateTask := nil.
    ].
!

updateAfterTimeout:hereDueToTimeOut
    |mustCheckForModifiedDir|

    mustCheckForModifiedDir := hereDueToTimeOut.

"/    Transcript showCR:'START'.
    self isBusy:true.
    self debugMessage:'update cycle'.
    [
        [
            mustCheckForModifiedDir ifTrue:[
                self debugMessage:'evaluate modification'.
                mustCheckForModifiedDir := false.
                self modificationCycle
            ].
            directoryChangeFlag ifTrue:[ 
                directoryChangeFlag := false.
                self debugMessage:'directoryChanged'.
                self directoryChanged.
            ].
            directoryContentsChangeFlag ifTrue:[
                directoryContentsChangeFlag := false.
                self debugMessage:'directoryContentsChanged'.
                self directoryContentsChanged.
            ].
            filterChangeFlag ifTrue:[
                filterChangeFlag := false.
                self debugMessage:'filterChanged'.
                self filterChanged.
            ].
            sortBlockChangeFlag ifTrue:[
                sortBlockChangeFlag := false.
                self debugMessage:'sortBlockChanged'.
                self sortBlockChanged.
            ].
            (updatingColumns := self updateColumnsCycle) ifTrue:[
                self debugMessage:'next time another columns update'.
                changeSema signal.
                browser repairDamage.
            ] ifFalse:[
                self debugMessage:'next time no column update'.
            ].
        ] doWhile:[updatingColumns]
    ] ensure:[
        self isBusy:false.
        updateCycleSemaphore signalIf.
    ].
"/        Transcript showCR:'STOP'.

    "Created: / 07-01-2012 / 16:27:50 / cg"
!

updateStep
    |timedOut sensor|

    "/ Processor yield.

    sensor := self windowGroup sensor.
    (sensor anyButtonPressed or:[sensor shiftDown]) ifTrue:[
        Processor yield.

        "/ no update while scrolling
        timedOut := ( changeSema waitWithTimeoutMs:(self class updateTaskCyleTime milliseconds) ) isNil.
        timedOut ifFalse:[changeSema signal].
        ^ self 
    ].

    AbortOperationRequest handle:[
        "/ to get out of a debugger loop...
        self debugMessage:'got an abort signal'.
        self directoryContentsChangeFlag:false.
        self filterChangeFlag:false.
        self sortBlockChangeFlag:false.
    ] do:[
        (updatingColumns == true) ifTrue:[
            timedOut := false
        ] ifFalse:[
            self debugMessage:'sema wait'.
            timedOut := (changeSema waitWithTimeoutMs:(self class updateTaskCyleTime asMilliseconds)) isNil.
            self debugMessage:'timedOut:', timedOut asString.
        ].

        (filterChangeFlag 
        or:[ sortBlockChangeFlag
        or:[ directoryChangeFlag
        or:[ directoryContentsChangeFlag 
        or:[ updatingColumns == true 
        or:[ timedOut ]]]]]) ifTrue:[
            accessLock critical:[
                self updateAfterTimeout:timedOut.
            ].
        ].
    ].

    "Modified: / 20-03-2012 / 13:07:22 / cg"
! !

!DirectoryContentsBrowser methodsFor:'update task trigger'!

wakeUp
    self isOpen ifTrue:[
        "/ the updateTask might be nil or dead....
        self startUpdateTask
    ].
    changeSema signal.

    "Modified: / 10-08-2010 / 14:07:40 / sr"
!

wakeUpForDirectoryChanged
    self isBusy ifTrue:[
        self isBusy:false.
        updateTask interruptWith:[AbortSignal raise].
    ].
    directoryChangeFlag := true.
    self wakeUp.

    "Modified: / 07-01-2012 / 16:43:12 / cg"
!

wakeUpForDirectoryContentsChanged

    self directoryContentsChangeFlag:true.
    self wakeUp.
!

wakeUpForFilterChanged

    self filterChangeFlag:true.
    self wakeUp.
!

wakeUpForSortBlockChanged

    self sortBlockChangeFlag:true.
    self wakeUp.
! !

!DirectoryContentsBrowser methodsFor:'update task-disk usage'!

diskUsageInKiloBytesFor:aDirectory
    |line sum kb|

    OperatingSystem isUNIXlike ifTrue:[
        line := OperatingSystem getCommandOutputFrom:('du -s -k ' , aDirectory pathName).
        line notNil ifTrue:[
            kb := Number readFrom:line readStream.
        ].
        ^ kb
    ].

    sum := 0.
    aDirectory recursiveDirectoryContentsDo:[:fnString |
        |fn|

        fn := aDirectory construct:fnString.
        fn isDirectory ifFalse:[
            fn exists ifTrue:[     "/ cares for missing links in WinNT
                sum := sum + fn fileSize
            ].
        ].
    ].
    ^ sum / 1024

    "Modified: / 04-07-2006 / 11:27:38 / cg"
!

flushRememberedDiskUsageInfo
    diskUsageInfo := nil.
!

flushRememberedDiskUsageInfoFor:aDirectory
    |dirPath keysToRemove|

    diskUsageInfo isNil ifTrue:[ ^ self ].

    dirPath := aDirectory pathName.
    keysToRemove := diskUsageInfo keys 
                        select:[:key |
                            key startsWith:dirPath
                        ].
    diskUsageInfo removeAllKeys:keysToRemove.
!

isDiskUsageInfoStillValid:infoForDirectory for:aDirectoryPath
    |diskUsageRememberTime infoTimestamp infoKiloBytes infoMegaBytes|

    diskUsageRememberTime := 30.

    infoTimestamp := infoForDirectory key.
    infoKiloBytes := infoForDirectory value.
    infoMegaBytes := infoKiloBytes // 1024.

    "/ only update info every 30 seconds
    "/ plus another second for every 5 megabytes
    "/ (i.e. for 100 mb, keep info for 50seconds)

    diskUsageRememberTime := diskUsageRememberTime + (infoMegaBytes / 5). "/ another second for every megabyte

    (Timestamp now getSeconds - infoTimestamp getSeconds) > diskUsageRememberTime ifTrue:[
        ^ false
    ].
"/    (aDirectoryPath asFilename modificationTime > infoTimestamp) ifTrue:[
"/        ^ false
"/    ].
    ^ true
!

showDiskUsageInfoFor:aDirectory as:kiloBytes
    |kbString|

    kbString := UnitConverter fileSizeStringFor:(kiloBytes * 1024).
    self notify:('%2 in %1' 
                    bindWith:(aDirectory baseName "pathName" allBold) 
                    with:kbString "allBold").
!

startDiskUsageInfoProcess
    |aColOfFiles selectedFile info|

    aColOfFiles := self currentSelectedObjects.

    (aColOfFiles isEmpty or:[self currentFilesAreInSameDirectory not]) ifTrue:[
        ^ self
    ].
    aColOfFiles size == 1 ifTrue:[
        selectedFile := aColOfFiles first.
        info := selectedFile linkInfo.
        (info notNil and:[info isSymbolicLink]) ifTrue:[
"/            self notify:'Symbolic link to: ' , (info path ? '') allBold
        ] ifFalse:[
            self startDiskUsageInfoProcessFor:selectedFile.
        ].
    ].

    "Modified: / 04-12-2006 / 13:15:40 / cg"
!

startDiskUsageInfoProcessFor:selectedFile
    |directory dirPath infoForDirectory infoValue|

    self showDiskUsageHolder value ifFalse:[^ self].

    selectedFile isDirectory ifTrue:[
        directory := selectedFile
    ] ifFalse:[
        directory := selectedFile directory
    ].

    dirPath := directory pathName.
    diskUsageInfo isNil ifTrue:[
        diskUsageInfo := Dictionary new.
    ].
    infoForDirectory := diskUsageInfo at:dirPath ifAbsent:nil.
    infoForDirectory notNil ifTrue:[
        (self isDiskUsageInfoStillValid:infoForDirectory for:dirPath) ifTrue:[
            infoValue := infoForDirectory value.
        ].
    ].

    infoValue notNil ifTrue:[
        self showDiskUsageInfoFor:directory as:infoValue.
        ^ self.
    ].

    diskUsageUpdateProcess notNil ifTrue:[
        diskUsageUpdateProcess terminate
    ].
    diskUsageUpdateProcess :=
        [
            |kiloBytes|

            self notify:('collecting disk usage of %1...' bindWith:directory baseName).
            OpenError 
                handle:[:ex |
                    self notify:('cannot open %1 (%2)' 
                        bindWith:ex pathName asString 
                        with:ex description).
                ] 
                do:[
                    kiloBytes := self diskUsageInKiloBytesFor:directory.
                    kiloBytes notNil ifTrue:[
                        diskUsageInfo notNil ifTrue:[
                            diskUsageInfo at:dirPath put:(Timestamp now -> kiloBytes).
                            self showDiskUsageInfoFor:directory as:kiloBytes.
                        ].
                    ]
                ].

        ] fork.
! !

!DirectoryContentsBrowser::DirectoryContentsItem class methodsFor:'instance creation'!

fileName:aFilename 
    | instance fileItem|

    aFilename asString = '..' ifTrue:[
        instance := self new.
        instance fileName:aFilename.
        ^ instance.
    ].
    fileItem := DirectoryContents contentsItemForFileName:aFilename.
    fileItem isNil ifTrue:[^ nil].
    ^ self forInfoItem:fileItem.

    "
     DirectoryContentsItem fileName:'..'
    "
!

forInfoItem:anItem
    | instance |

    instance := self new.
    instance fileName:anItem fileName.
    anItem isRemoteDirectory ifTrue:[
        instance beRemoteDirectory.
    ] ifFalse:[
        instance fileInfo:anItem info.
    ].
    ^ instance
! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'accessing'!

fileInfo:something
    fileInfo := something.
!

fileName
    ^ fileName
!

fileName:aFilename
    "set fileName"

    fileName := aFilename asFilename.
    self assert:(fileName notNil).
!

fileType
    "returns the type of the file"

    fileType isNil ifTrue:[
        fileType := ''.
    ].
    ^ fileType 
!

fileType:aType
    fileType := aType.
!

icon
    "answer the icon displayed in the table widget; if the icon is unspecified,
     and the fileInfo is set a default icon is returned otherwise nil"

    |key|

    icon notNil ifTrue:[^ icon ].

    key := #file.   "/ default

    self isRemoteDirectory ifTrue:[
        key := #directory.
    ] ifFalse:[
        "do not fetch the fileInfo..."
        fileInfo isNil ifTrue:[ ^ nil ].

        self isDirectory ifTrue:[
            key := #directory.
        ] ifFalse:[
            self isSymbolicLink ifTrue:[
                key := #fileLink
            ] ifFalse:[
                key := #file
            ].
        ].
    ].
    ^ MIMETypeIconLibrary iconForKey:key.
!

icon:anIcon

    icon := anIcon.
!

iconKey
    iconKey isNil ifTrue:[
        self isRemoteDirectory ifTrue:[
            iconKey := MIMETypeIconLibrary iconKeyForRemoteDirectory:fileName.
        ] ifFalse:[
            iconKey := MIMETypeIconLibrary iconKeyForFile:fileName.
        ]
    ].
    ^ iconKey
!

iconOrNil
    "answer the icon or nil if unspecifed"

    ^ icon
!

isDirectory
    self isRemoteDirectory ifTrue:[^ true].

    self getFileInfo.
    fileInfo isNil ifTrue:[^ false].
    ^ fileInfo isDirectory
!

isSymbolicLink
    self isRemoteDirectory ifTrue:[^ false].

    self getFileInfo.
    fileInfo isNil ifTrue:[^ false].
    ^ fileInfo isSymbolicLink
!

lastButOneSuffix
    "returns the suffix of the file
    "

    ^ self suffixes at:2
!

lastSuffix
    "returns the suffix of the file
    "

    ^ self suffixes at:1
!

linkTargetIsDirectory
    self isSymbolicLink ifFalse:[^ false].

    ^ fileName info isDirectory
!

mimeType
    mimeType isNil ifTrue:[
        mimeType := MIMETypes mimeTypeForFilename:(self fileName).
        mimeType isNil ifTrue:[
            mimeType := #unknown
        ]
    ].
    ^ mimeType
!

preview

    ^ preview
!

preview:aLabel

    preview := aLabel.
!

suffix
    "returns the suffix of the file
    "
    self isDirectory ifTrue:[^''].
    suffix isNil ifTrue:[
        (OperatingSystem isUNIXlike and:[(self baseName at:1) == $.]) ifTrue:[
            suffix := ''.
        ] ifFalse:[
            suffix := fileName suffix.
        ]
    ].
    ^ suffix
!

suffixes

    | lastSuff lastButOneSuff|

    (fileName name occurrencesOf:$.) <= 1 ifTrue:[
        ^ Array with:(self suffix) with:nil.
    ].
    (fileName baseName occurrencesOf:$.) <= 1 ifTrue:[
        ^ Array with:(self suffix) with:nil.
    ].

    ((lastSuff := self suffix) isEmpty) ifTrue:[  
        lastSuff := nil.
    ] ifFalse:[
        lastSuff := lastSuff asLowercase. 
    ].

    ((lastButOneSuff := fileName withoutSuffix suffix) isEmpty) ifTrue:[  
        lastButOneSuff := nil.
    ] ifFalse:[
        lastButOneSuff := lastButOneSuff asLowercase. 
    ].

    (lastSuff notNil and:[lastButOneSuff notNil]) ifTrue:[
        (lastSuff = 'bak' or:[lastSuff = 'sav']) ifTrue:[
            lastSuff := lastButOneSuff.
            lastButOneSuff := nil.
        ]
    ].
    ^ Array with:lastSuff with:lastButOneSuff
!

type
    "returns the type of the file
    "
    ^ self valueAt:#type

! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'actions'!

resetImageFile
    " if the image preview extent is changed the icon will set to nil to force the update task to reload the image "

    (mimeType notNil and:[ mimeType isImageType]) ifTrue:[
        preview := nil
    ]
!

resetItem
    " don't know what someone else is doing with the file - read all item properties new "

    fileInfo := nil.
    icon := nil.
    fileType := nil.
    preview := nil.
    owner := nil.
    group := nil.
    iconKey := nil.
    mimeTypeForContents := nil.
    mimeType := nil.
! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'change queries'!

hasBeenModified
    "check if item modification time has changed"

    |info|

    self isRemoteDirectory ifTrue:[^ false].
    "/ root directories are not verified
    fileName isRootDirectory ifTrue:[ ^ false ].


    fileInfo isNil ifTrue:[
        "first time of invokation "
        info := self getFileInfo.
        info isNil ifTrue:[ ^ false].
        ^ true
    ].
    fileInfo isSymbolicLink ifTrue:[
        "/ symbolic links are not verified
        ^ false
    ].

    self modificationTime  ~= fileName modificationTime ifTrue:[
        ^ true
    ].
    ^ false
! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'comparing'!

= anItem

"/    Transcript showCR:(anItem species == self species).
    anItem species == self species ifFalse:[  ^ false].
    anItem isNil ifTrue:[ ^ false].
    ^ (self fileName = anItem fileName)
!

hash
    ^ fileName hash
! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'presentation'!

baseName
    "returns the baseName of the file"

    baseName isNil ifTrue:[
        baseName := fileName baseName.
        fileName isDirectory ifTrue:[
            baseName := baseName allBold.
        ].
    ].
    ^ baseName

    "Modified: / 09-08-2011 / 14:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

baseNameWithOutSuffix
    "returns the baseName of the file"

    | baseNameWithOutSuffix |

    self isDirectory ifTrue:[^ self baseName].
    baseNameWithOutSuffix := self baseName asFilename withoutSuffix asString.
    (baseNameWithOutSuffix isEmpty or:[baseNameWithOutSuffix = '.']) ifTrue:[
        ^ self baseName
    ].
    ^ baseNameWithOutSuffix.
!

date
    "returns the modTimeString"

    | modTime |

    modTime := self modificationTime.
    modTime isNil ifTrue:[
        ^ '???'
    ].
    ^ modTime asDate printString.
!

fileInfoString
    "get stat info on selected file - return a string which can be
     shown in a box"

    | afileType |

    fileName isNil ifTrue:[^ nil].
    afileType := self fileType.
    afileType isNil ifTrue:[
        ^ ''.
    ].
    ^ afileType
!

fileSize
    "returns the fileSize"

    self getFileInfo.
    fileInfo isNil ifTrue:[^ nil].

    ^ fileInfo fileSize
!

group
    "returns the printable group"

    |gid|

    group isNil ifTrue:[
        self getFileInfo.
        fileInfo isNil ifTrue:[^ '???'].

        gid := fileInfo gid.
        (LastGIDToGroupNameMapping notNil and:[gid == LastGIDToGroupNameMapping key]) ifTrue:[
            group := LastGIDToGroupNameMapping value
        ] ifFalse:[
            group := OperatingSystem getGroupNameFromID:gid.
            LastGIDToGroupNameMapping := gid -> group.
        ]
    ].
    ^ group
!

inodeNumber
    "returns the inode number"

    self getFileInfo.
    fileInfo isNil ifTrue:[^ nil].
    ^ fileInfo id
!

modificationTime
    "returns the absolute time of modification"

    self getFileInfo.
    fileInfo isNil ifTrue:[^ nil].

    ^ fileInfo modificationTime
!

owner
    "returns the printable owner"

    |uid|

    owner isNil ifTrue:[
        self getFileInfo.
        fileInfo isNil ifTrue:[^ '???'].

        uid := fileInfo uid.
        (LastUIDToUserNameMapping notNil and:[uid == LastUIDToUserNameMapping key]) ifTrue:[
            owner := LastUIDToUserNameMapping value
        ] ifFalse:[
            owner := OperatingSystem getUserNameFromID:uid.
            LastUIDToUserNameMapping := uid -> owner.
        ]
    ].
    ^ owner
!

permissions
    "returns the permissions as printable string"

    |mode permissionString|

    self getFileInfo.
    fileInfo isNil ifTrue:[^ '???'.].

    mode := fileInfo mode.
    permissionString := String new:9 withAll:$-.

    1 to:9 by:3 do:[:i|
        (mode bitAt:i    ) == 1 ifTrue:[permissionString at:10 - i put:$x].
        (mode bitAt:i + 1) == 1 ifTrue:[permissionString at:9  - i put:$w].
        (mode bitAt:i + 2) == 1 ifTrue:[permissionString at:8  - i put:$r].
    ].
    ^ permissionString
!

sizeInBytesString
    |locSize|

    locSize := self fileSize.
    locSize isNil ifTrue:[^ '???'].

    ^ locSize printString "/ leftPaddedTo:8.
!

sizeInKiloBytesString
    |locSize|

    locSize := self fileSize.
    locSize isNil ifTrue:[^ '???'].

    (locSize \\ 1024) == 0 ifTrue:[
        ^ (locSize // 1024) printString , '  '
    ].
    ^ ((locSize / 1024) asFixedPoint:1) printString
!

sizeString
    "returns the size of the file"

    | unitString locSize|

    locSize := self fileSize.
    locSize isNil ifTrue:[^ '???'].

    unitString := UnitConverter fileSizeStringFor:locSize.
    ^ unitString withoutSeparators "/ leftPaddedTo:8.
!

timeAndDate
    "returns the time- and date string"

    |resources format modTime date|

    modTime := self modificationTime.
    modTime isNil ifTrue:[
        ^  '???'
    ].

    resources := AbstractFileBrowser classResources.

"/    format := '%(year)-%(mon)-%(day) %h:%m:%s'.
    date := modTime asDate.
    date = Date today ifTrue:[
        format := (resources string:'Today') , ' %(yearOrTime)'
    ] ifFalse:[
        false "date = Date yesterday" ifTrue:[
            format := (resources string:'Yesterday') , ' %(yearOrTime)'
        ] ifFalse:[
            UserPreferences current languageTerritory == #us ifTrue:[
                format := '%(ShortMonthName), %(dayPadded) %(yearOrTime)'.
            ] ifFalse:[
                format :='%(day)-%(ShortMonthName) %(yearOrTime)'.
            ].
        ].
    ].

    ^ modTime printStringFormat:format.
! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'printing'!

printOn:aStream
    super printOn:aStream.
    aStream 
        nextPut:$[;
        nextPutAll:fileName asString;
        nextPut:$]. 
! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'private'!

getFileInfo
    fileInfo isNil ifTrue:[
        self isRemoteDirectory ifTrue:[
            "/ do not access, to avoid automount
        ] ifFalse:[
            fileInfo := fileName linkInfo.
        ].
    ].
    ^ fileInfo
! !

!DirectoryContentsBrowser::DirectoryContentsItem methodsFor:'queries'!

beRemoteDirectory
    fileType := #remoteDirectory.
!

exists
    ^ fileName exists 
!

hasMimeType

    ^ (self mimeType ~= #unknown)
!

isRemoteDirectory
    ^ fileType == #remoteDirectory
!

mimeTypeForContents

    mimeTypeForContents isNil ifTrue:[
        mimeTypeForContents := MIMETypes mimeTypeOfContents:(self fileName).
        mimeTypeForContents isNil ifTrue:[
            mimeTypeForContents := #unknown
        ] ifFalse:[
            " set mimeType to mimeType of contents if a better mimeType is found "
            mimeType := mimeTypeForContents.
            iconKey := mimeTypeForContents.
        ]
    ].
    ^ mimeTypeForContents
! !

!DirectoryContentsBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

