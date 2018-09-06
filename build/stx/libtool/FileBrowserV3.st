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

FileBrowserV2 subclass:#FileBrowserV3
	instanceVariableNames:'bookmarkBarVisibleHolder bookmarkHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileBrowserV3 class methodsFor:'documentation'!

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
! !

!FileBrowserV3 class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileBrowserV3    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#copyFile
''

#cutFile
''

#deleteFile
''

#editFile
''

#fileGotoBookmark
''

#fileHistory
''

#fileIn
''

#pasteFile
''

)
! !

!FileBrowserV3 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowserV3 andSelector:#windowSpec
     FileBrowserV3 new openInterface:#windowSpec
     FileBrowserV3 open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: FileBrowser
          name: FileBrowser
          min: (Point 10 10)
          bounds: (Rectangle 0 0 800 600)
          menu: mainMenu
          icon: defaultIcon
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'ToolbarBox'
              layout: (LayoutFrame 0 0 0 0 0 1 40 0)
              level: 0
              visibilityChannel: toolBarVisibleHolder
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'hideToolBarIcon'
                    name: 'HideToolBarButton'
                    layout: (LayoutFrame 0 0 0 0 13 0 40 0)
                    activeHelpKey: hideToolBar
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideToolbar
                    postBuildCallback: hideToolBarButtonCreated:
                  )
                 (MenuPanelSpec
                    name: 'ToolBar'
                    layout: (LayoutFrame 13 0 0 0 0 1 40 0)
                    level: 1
                    menu: toolBarMainMenu
                    textDefault: true
                  )
                 )
               
              )
            )
           (ViewSpec
              name: 'BookmarkBar'
              layout: (LayoutFrame 0 0 40 0 0 1 66 0)
              visibilityChannel: bookmarkBarVisibleHolder
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'hideToolBarIcon'
                    name: 'Button1'
                    layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                    activeHelpKey: hideToolBar
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideBookmarkBar
                  )
                 (SubCanvasSpec
                    name: 'Bookmarks'
                    layout: (LayoutFrame 13 0 0 0 0 1 0 1)
                    level: 1
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    miniScrollerHorizontal: false
                    majorKey: BookmarkBar
                    subAspectHolders: 
                   (Array
                      
                     (SubChannelInfoSpec
                        subAspect: bookmarkHolder
                        aspect: bookmarkHolder
                      ) 
                     (SubChannelInfoSpec
                        subAspect: bookmarksHolder
                        aspect: bookmarkListHolder
                      )
                    )
                    createNewApplication: true
                    createNewBuilder: true
                  )
                 )
               
              )
            )
           (ViewSpec
              name: 'FilenameEntryFieldBox'
              layout: (LayoutFrame 0 0 67 0 0 1 92 0)
              level: 0
              visibilityChannel: filenameEntryFieldVisibleHolder
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'hideFilenameEntryFieldIcon'
                    name: 'HideFilenameEntryFieldButton'
                    layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                    activeHelpKey: hideFilenameEntryField
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideFilenameEntryField
                    postBuildCallback: hideFilenameEntryFieldButtonCreated:
                  )
                 (HorizontalPanelViewSpec
                    name: 'HorizontalPanel1'
                    layout: (LayoutFrame 13 0.0 0 0.0 0 1.0 0 1.0)
                    level: 1
                    horizontalLayout: leftFit
                    verticalLayout: fit
                    horizontalSpace: 3
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (ComboListSpec
                          name: 'ComboList1'
                          visibilityChannel: driveSelectorVisible
                          model: selectedDeviceDrive
                          comboList: listOfDeviceDrives
                          useIndex: false
                          hidePullDownMenuButton: false
                          extent: (Point 53 23)
                        )
                       (VariableHorizontalPanelSpec
                          name: 'VariableHorizontalPanel1'
                          level: 0
                          showHandle: true
                          component: 
                         (SpecCollection
                            collection: (
                             (NonScrollableArbitraryComponentSpec
                                name: 'NonScrollableArbitraryComponent1'
                                component: FilenameEditFieldV2
                                postBuildCallback: postBuildEditField:
                              )
                             (ViewSpec
                                name: 'FilterBox'
                                component: 
                               (SpecCollection
                                  collection: (
                                   (LabelSpec
                                      label: 'Filter:'
                                      name: 'Filter'
                                      layout: (LayoutFrame 0 0 0 0 40 0 0 1)
                                      translateLabel: true
                                      adjust: left
                                      postBuildCallback: postBuildPathViewBox:
                                    )
                                   (ComboBoxSpec
                                      name: 'FilterSelectionBox'
                                      layout: (LayoutFrame 40 0 0 0 0 1 0 1)
                                      model: filterModel
                                      immediateAccept: true
                                      acceptOnPointerLeave: false
                                      comboList: filterListModel
                                    )
                                   )
                                 
                                )
                                postBuildCallback: postBuildPathViewBox:
                              )
                             )
                           
                          )
                          handles: (Any 0.774936 1.0)
                          postBuildCallback: postBuildPathViewBox:
                          useDefaultExtent: true
                        )
                       )
                     
                    )
                    postBuildCallback: postBuildPathViewBox:
                  )
                 )
               
              )
            )
           (#'FileBrowserV2UISpecifications::PanelSpec'
              name: 'BrowserBox'
              layout: (LayoutFrame 0 0.0 92 0.0 0 1.0 -26 1.0)
              level: 0
              showHandle: true
              snapMode: both
              whichView: last
              orientation: vertical
              visibility: viewNoteBookApplicationHolder
              component: 
             (SpecCollection
                collection: (
                 (#'FileBrowserV2UISpecifications::PanelSpec'
                    name: 'HorizontalPanel'
                    level: 0
                    snapMode: both
                    whichView: first
                    orientation: horizontal
                    visibility: showDirectoryTree
                    component: 
                   (SpecCollection
                      collection: (
                       (SubCanvasSpec
                          name: 'DirectoryTreeBrowser'
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          majorKey: DirectoryTreeBrowser
                          createNewApplication: true
                          createNewBuilder: true
                          postBuildCallback: postBuildDirectoryTree:
                        )
                       (SubCanvasSpec
                          name: 'DirectoryContentsBrowser'
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          majorKey: DirectoryContentsBrowser
                          createNewApplication: true
                          createNewBuilder: true
                        )
                       )
                     
                    )
                    handles: (Any 0.225 1.0)
                  )
                 (SubCanvasSpec
                    name: 'FileApplicationNoteBook'
                    tabable: false
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    majorKey: FileApplicationNoteBook
                    createNewApplication: true
                    createNewBuilder: true
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           (ViewSpec
              name: 'InfoBox'
              layout: (LayoutFrame 0 0 -26 1 0 1 0 1)
              level: 0
              visibilityChannel: infoBarVisibleHolder
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'NotifyLabel'
                    name: 'NotifyLabel'
                    layout: (LayoutFrame 0 0 1 0.0 -220 1 1 1.0)
                    level: -1
                    translateLabel: true
                    labelChannel: notifyChannel
                    adjust: left
                  )
                 (LabelSpec
                    label: 'encoding'
                    name: 'EncodingLabel'
                    layout: (LayoutFrame -318 1 2 0.0 -235 1 0 1.0)
                    activeHelpKey: encodingLabel
                    level: 0
                    labelChannel: fileEncodingHolder
                    adjust: right
                    menu: encodingMenu
                  )
                 (LabelSpec
                    name: 'FileEncodingLockedLabel'
                    layout: (LayoutFrame -235 1 2 0.0 -220 1 20 0.0)
                    activeHelpKey: encodingLockedLabel
                    level: 0
                    labelChannel: fileEncodingLockImageHolder
                    adjust: right
                    menu: encodingMenu
                  )
                 (LabelSpec
                    label: 'Shown Files'
                    name: 'ShownFilesLabel'
                    layout: (LayoutFrame -220 1 1 0.0 -65 1 1 1.0)
                    activeHelpKey: numberOfFiles
                    level: -1
                    translateLabel: true
                    labelChannel: shownFiles
                    adjust: right
                  )
                 (ViewSpec
                    name: 'ProgressIndicatorBox'
                    layout: (LayoutFrame -220 1 1 0.0 -65 1 1 1.0)
                    level: -1
                    visibilityChannel: activityVisibilityChannel
                    component: 
                   (SpecCollection
                      collection: (
                       (ProgressIndicatorSpec
                          name: 'ProgressIndicator1'
                          layout: (LayoutFrame 5 0.0 -7 0.5 -5 1.0 7 0.5)
                          backgroundColor: (Color 0.0 66.6666666666667 66.6666666666667)
                          isActivityIndicator: true
                        )
                       )
                     
                    )
                  )
                 (LabelSpec
                    name: 'BusyLabel'
                    layout: (LayoutFrame -220 1 1 0.0 -65 1 1 1.0)
                    activeHelpKey: modeLabel
                    level: -1
                    visibilityChannel: busyLabelVisibleHolder
                    translateLabel: true
                    labelChannel: busyLabelHolder
                    adjust: right
                  )
                 (LabelSpec
                    label: 'M'
                    name: 'ModeLabel'
                    layout: (LayoutFrame -65 1 1 0.0 -55 1 1 1.0)
                    activeHelpKey: modeLabel
                    level: -1
                    translateLabel: true
                    labelChannel: modeLabelHolder
                    adjust: right
                    postBuildCallback: postBuildEditModeInfoLabel:
                  )
                 (LabelSpec
                    label: 'L'
                    name: 'LineLabel'
                    layout: (LayoutFrame -55 1 1 0.0 -20 1 1 1.0)
                    activeHelpKey: lineLabel
                    level: -1
                    translateLabel: true
                    labelChannel: cursorLineLabelHolder
                    adjust: right
                  )
                 (LabelSpec
                    label: 'C'
                    name: 'ColLabel'
                    layout: (LayoutFrame -20 1 1 0.0 0 1 1 1.0)
                    activeHelpKey: columnLabel
                    level: -1
                    translateLabel: true
                    labelChannel: cursorColLabelHolder
                    adjust: right
                  )
                 )
               
              )
            )
           (LabelSpec
              label: 'Preview'
              name: 'PreviewLabel'
              layout: (LayoutFrame 0 0.5 93 0 100 0.5 115 0)
              level: 0
              borderWidth: 1
              visibilityChannel: previewVisibleHolder
              backgroundColor: (Color 86.9993133440147 86.9993133440147 86.9993133440147)
              translateLabel: true
            )
           (ArbitraryComponentSpec
              name: 'Preview'
              layout: (LayoutFrame 0 0.5 116 0 -147 1 -266 1)
              level: 1
              visibilityChannel: previewVisibleHolder
              hasBorder: false
              component: ImageView
            )
           (ActionButtonSpec
              label: 'closePreviewButtonImage'
              name: 'ClosePreviewButton'
              layout: (LayoutFrame -169 1 94 0 -147 1 116 0)
              visibilityChannel: previewVisibleHolder
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           )
         
        )
      )
! !

!FileBrowserV3 class methodsFor:'menu specs'!

toolBarMainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileBrowserV3 andSelector:#toolBarMainMenu
     (Menu new fromLiteralArrayEncoding:(FileBrowserV3 toolBarMainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: directoryBack
            enabled: enableBack
            label: 'Back'
            itemValue: doBack
            translateLabel: true
            isButton: true
            submenuChannel: menuDirHistoryBack
            labelImage: (ResourceRetriever ToolbarIconLibrary historyBackIcon)
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            activeHelpKey: directoryForward
            enabled: enableForward
            label: 'Forward'
            itemValue: doForward
            translateLabel: true
            isButton: true
            submenuChannel: menuDirHistoryForward
            labelImage: (ResourceRetriever ToolbarIconLibrary historyForwardIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: directoryUp
            enabled: enableDirectoryUp
            label: 'DirectoryUp'
            itemValue: doGoDirectoryUp
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryUpIcon)
          )
         (MenuItem
            activeHelpKey: fileHome
            enabled: enableHome
            label: 'Home'
            itemValue: doGotoHomeDirectory
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary homeIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoDefaultDirectory
            enabled: enableGotoDefaultDirectory
            label: 'Current'
            itemValue: doGotoDefaultDirectory
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary currentDirectoryIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoSmalltalkDirectory
            enabled: enableGotoSmalltalkDirectory
            label: 'ST/X Default'
            itemValue: doGotoSmalltalkDirectory
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary stxHomeIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoBookmark
            label: 'Bookmarks'
            translateLabel: true
            isButton: true
            isVisible: false
            submenuChannel: gotoBookmarksMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryBookmarksIcon)
          )
         (MenuItem
            activeHelpKey: fileHistory
            enabled: enableFileHistory
            label: 'File History'
            translateLabel: true
            isButton: true
            isVisible: false
            submenuChannel: menuFileHistory
            labelImage: (ResourceRetriever ToolbarIconLibrary historyIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: searchFile
            label: 'Search File'
            itemValue: doOpenSearchFile
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary searchFileIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: cutFile
            enabled: hasSelection
            label: 'Cut'
            itemValue: cutFiles
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary cutFileIcon)
          )
         (MenuItem
            activeHelpKey: copyFile
            enabled: hasSelection
            label: 'Copy'
            itemValue: copyFiles
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary copyFileIcon)
          )
         (MenuItem
            activeHelpKey: pasteFile
            enabled: canPaste
            label: 'Paste'
            itemValue: pasteFiles
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary pasteFileIcon)
          )
         (MenuItem
            activeHelpKey: deleteFile
            enabled: hasSelection
            label: 'Delete'
            itemValue: deleteFiles
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteFileIcon)
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            activeHelpKey: editFile
            label: 'Edit File'
            itemValue: doShowFileContents
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary editFileIcon)
          )
         (MenuItem
            activeHelpKey: fileIn
            label: 'File In'
            itemValue: fileFileIn
            translateLabel: true
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary fileInIcon)
          )
         (MenuItem
            activeHelpKey: openChangeBrowser
            enabled: hasFileSelection
            label: 'Changes Browser'
            itemValue: openChangesBrowser
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startChangesBrowserIcon)
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            activeHelpKey: addTerminal
            label: 'VT100'
            itemValue: doAddTerminal
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary shellTerminalIcon)
          )
         (MenuItem
            activeHelpKey: make
            enabled: canMake
            label: 'Make'
            itemValue: doMake
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary make24x24Icon3)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
            translateLabel: true
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            indication: viewDetails
            labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
            translateLabel: true
            isButton: true
            startGroup: right
            isVisible: false
            indication: viewDetails
            submenuChannel: viewDetailsMenuSpec
            labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
          )
         (MenuItem
            activeHelpKey: selectDetails
            label: ''
            isButton: true
            startGroup: right
            submenuChannel: viewDetailsMenuSpec
            labelImage: (ResourceRetriever ToolbarIconLibrary empty1x20Icon)
          )
         )
        nil
        nil
      )
! !

!FileBrowserV3 methodsFor:'actions'!

hideBookmarkBar

    self bookmarkBarVisibleHolder value

    "Created: / 04-04-2012 / 12:08:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

switchToBookmarkEntry: bookmark

    self gotoFile: bookmark path asFilename

    "Created: / 20-04-2012 / 18:07:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileBrowserV3 methodsFor:'aspects'!

bookmarkBarVisibleHolder
    "return/create the 'bookmarkBarVisibleHolder' value holder (automatically generated)"

    bookmarkBarVisibleHolder isNil ifTrue:[
        bookmarkBarVisibleHolder := true asValue.
        bookmarkBarVisibleHolder addDependent:self.
    ].
    ^ bookmarkBarVisibleHolder

    "Modified: / 10-06-2011 / 23:56:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarkBarVisibleHolder:something
    "set the 'bookmarkBarVisibleHolder' value holder (automatically generated)"

    |oldValue newValue|

    bookmarkBarVisibleHolder notNil ifTrue:[
        oldValue := bookmarkBarVisibleHolder value.
        bookmarkBarVisibleHolder removeDependent:self.
    ].
    bookmarkBarVisibleHolder := something.
    bookmarkBarVisibleHolder notNil ifTrue:[
        bookmarkBarVisibleHolder addDependent:self.
    ].
    newValue := bookmarkBarVisibleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:bookmarkBarVisibleHolder.
    ].
!

bookmarkHolder
    "return/create the 'bookmarkHolder' value holder (automatically generated)"

    bookmarkHolder isNil ifTrue:[
        bookmarkHolder := ValueHolder new.
    ].
    ^ bookmarkHolder
!

bookmarkListHolder

    ^BookmarkList forFileBrowser

    "Created: / 08-06-2011 / 12:16:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileBrowserV3 methodsFor:'change & update'!

currentFileNameHolderChanged
    super currentFileNameHolderChanged.
    self updateBookmark

    "Created: / 20-04-2012 / 18:04:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    "/ changedObject == someOfMyValueHolders ifTrue:[
    "/     self doSomethingApropriate.
    "/     ^ self.
    "/ ].
    super update:something with:aParameter from:changedObject
!

updateBookmark

    | file bookmark |
    file := fileEntryFieldHolder value.
    file notEmptyOrNil ifTrue:[
        bookmark := Bookmark forFile: file.
    ].
    self bookmarkHolder value: bookmark.

    "Created: / 13-04-2012 / 12:37:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateToolVisibility
    |builder toolBar bookmarkBar infoBar filenameEntryField vPanel topOffset bottomOffset
     toolBarVisible bookmarkBarVisible filenameEntryFieldVisible infoBarVisible d|

    builder := self builder.

    topOffset := 0.
    bottomOffset := 0.

    toolBarVisible := self toolBarVisibleHolder value.
    toolBarVisible ifTrue:[
        toolBar := builder componentAt:#ToolbarBox.
        topOffset := topOffset + toolBar height.
    ].

    bookmarkBarVisible := self bookmarkBarVisibleHolder value.
    bookmarkBarVisible ifTrue:[
        bookmarkBar := builder componentAt:#Bookmarks.
        topOffset := topOffset + (bookmarkBar height max: 25)
    ].

    filenameEntryFieldVisible := self filenameEntryFieldVisibleHolder value.
    filenameEntryFieldVisible ifTrue:[
        filenameEntryField := builder componentAt:#FilenameEntryFieldBox.
        d := filenameEntryField layout bottomOffset - filenameEntryField layout topOffset.
        filenameEntryField layout topOffset:topOffset bottomOffset:topOffset + d.
        topOffset := topOffset + filenameEntryField height.
        filenameEntryField container notNil ifTrue:[
            filenameEntryField containerChangedSize.
        ].
    ].

    infoBarVisible := self infoBarVisibleHolder value.
    infoBarVisible ifTrue:[
        infoBar := builder componentAt:#InfoBox.
        bottomOffset := bottomOffset - infoBar height.
    ].

    vPanel := builder componentAt:#BrowserBox.
    vPanel layout topOffset:topOffset+1.
    vPanel layout bottomOffset:bottomOffset-1.
    vPanel container notNil ifTrue:[
        vPanel containerChangedSize.
    ].

    "Modified: / 03-04-2012 / 22:23:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileBrowserV3 class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: FileBrowserV3.st 7985 2012-04-21 08:36:31Z vranyj1 $'
! !

