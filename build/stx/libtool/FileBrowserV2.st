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

AbstractFileBrowser subclass:#FileBrowserV2
	instanceVariableNames:'fileEntryFieldHolder pathEntryField previewProcess
		listOfDeviceDrives selectedDeviceDrive imgView lineLabel
		bookmarkBarVisibleHolder bookmarkHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileBrowserV2 class methodsFor:'documentation'!

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
    FileBrowserV2 is based on Filebrowser

    WARNING: files edited with FileBrowser will have leading spaces (multiple-8)
	     being replaced by tabs. If tabs are to be preserved at other
	     positions (for example, sendmail-config files) they will be
	     corrupt after being written.

    [instance variables]:

	checkDelta      <Integer>       number of seconds of check interval
					(looks ever so often if shown directory
					 has changed). You may make this number
					higher, if your network-times are
					incorrect and thus, the filebrowser
					checks too often.

	compressTabs    <Boolean>       if true, leading spaces will be
					replaced by tabs when saving text

    some of the defaults (long/short list etc.) can be set by the resource file;
    see FileBrowser>>initialize for more details..

    [author:]
	Christian Penk

    [start with:]
	FileBrowserV2 open
"
!

toDo
"
    - the tab for the directory description text editor is not changed if the
      directory description changes to a normal text editor
    - FileDialog should get a file history
    - directorycontentsItem isDirectory fails if it is a symbolic link
    - on sort order change in directory contents browser the columnspec shouldnt not reloaded
    - check all windowspecs with different font types
    - multiple select with mouse moving is flickering (see bestFilename in FilenameEditField)
    - too many system calls on update cycle
    - stop monitoring task for DirectoryTreebrowser and DirectoryContentsBrowser
"
! !

!FileBrowserV2 class methodsFor:'instance creation'!

on:aDirectoryPath
    "return a new FileBrowserV2 in a pathname"

    |instance|

    instance := self new.
    instance onDirectory:aDirectoryPath.
    ^ instance
!

open
    "start a new FileBrowserV2"

    | instance |
    instance := self new.
    instance open.
    ^ instance

    "
     FileBrowserV2 openOn:(OrderedCollection with:(Filename currentDirectory asAbsoluteFilename)) withExtent:800@600
    "
!

openIn:aDirectoryPath
    "backward compatibility"

    ^ self openOn:aDirectoryPath
!

openOn:aFileOrDirectoryPath
    "start a new FileBrowserV2 in a pathname"

    |fn|

    fn := aFileOrDirectoryPath asFilename.
    fn isDirectory ifFalse:[
	^ self openOnFileNamed:aFileOrDirectoryPath
    ] ifTrue:[
	^ self openOn:fn withExtent:nil
    ].

    "
     FileBrowserV2 openOn:(Filename currentDirectory asAbsoluteFilename)
     FileBrowserV2 openOn:'Makefile'
    "

    "Modified (comment): / 06-09-2012 / 14:46:54 / cg"
!

openOn:aDirectoryPath withExtent:extentOrNil
    "start a new FileBrowserV2 in a pathname"

    |instance builder|

    instance := self on:aDirectoryPath.
    builder := instance open.
    extentOrNil notNil ifTrue:[
	builder window extent:extentOrNil.
    ].
    ^ instance

    "
     FileBrowserV2 openOn:(OrderedCollection with:(Filename currentDirectory asAbsoluteFilename)) withExtent:800@600
    "
!

openOnDirectory:aDirectoryPath
    "start a new FileBrowserV2 in a pathname"

    ^ self openOn:aDirectoryPath withExtent:nil

    "
     FileBrowserV2 openOn:(OrderedCollection with:(Filename currentDirectory asAbsoluteFilename)) withExtent:800@600
    "
!

openOnFileNamed:aFilename
    "start a new FileBrowserV2 on a aFilename.
     The browser looks for an appropriate viewer and uses that if one is found;
     otherwise, the file is opened for text editing."

    ^ self openOnFileNamed:aFilename editing:true

    "
     FileBrowserV2 openOnFileNamed:'Makefile'
    "
!

openOnFileNamed:aFilename editing:editing
    "start a new FileBrowserV2 on a aFilename;
     If editing is true, the browser opens the document as text to be edited;
     if false, it looks for an appropriate viewer and uses that if one is found."

    |browser|

    browser := self new.
    browser openOnFileNamed:aFilename editing:editing.
    ^ browser

    "
     FileBrowserV2 openOnFileNamed:'Makefile'
    "
!

openWithAspects:someAspects withExtent:extent
    "start a new FileBrowserV2 in a pathname"

    |dir clone|

    dir := someAspects at:#currentFileNameHolder ifAbsent:nil.
    clone := self openOn:(dir value) withExtent:extent.
    ^ clone
! !

!FileBrowserV2 class methodsFor:'class initialization'!

initialize
    "/ self installInLauncher.            - now done in phase 2
    ObjectMemory addDependent:self.
!

installInLauncher
    "add myself to the launcher menu and toolBar"

    |menuItem icon action currentLauncher|

    FileBrowserV2 isNil ifTrue:[^ self].

    "JV@2012-04-03: Changed to reflect UserPreferences"
    "/action := (MessageSend receiver:(Smalltalk at:self name) selector:#open).
    action := [ UserPreferences fileBrowserClass open].

    icon := [self defaultIcon]. "/ self defaultIcon magnifiedTo:28@28.

"/ already there
"/    menuItem := MenuItem new
"/                    translateLabel: true;
"/                    value: action;
"/                    isButton: false;
"/                    label:'File Browser' icon:icon;
"/                    nameKey: #fileBrowserV2;
"/                    activeHelpKey: #fileBrowserV2;
"/                    submenuChannel: #menuFileHistory;
"/                    showBusyCursorWhilePerforming:true.
"/
"/    NewLauncher
"/        addMenuItem:menuItem
"/        from:self
"/        in:'menu.file'
"/        position:#( #before #fileBrowser)
"/        space:true.

    menuItem := MenuItem new
                    itemValue: action;
                    isButton: true;
                    "label:'File Browser'" icon:icon;
                    nameKey: #fileBrowserV2;
                    activeHelpKey: #fileBrowserV2;
                    submenuChannel: #menuFileHistory;
                    showBusyCursorWhilePerforming:true.

    NewLauncher
        addMenuItem:menuItem
        from:self
        in:'toolbar'
        position:#( #before #fileBrowser)
        space:false.

    currentLauncher := NewLauncher current.
    currentLauncher notNil ifTrue:[
        currentLauncher fileBrowserItemVisible value:false
    ].
    NewLauncher addSettingsApplicationByClass:#'FileBrowserV2SettingsAppl'
                withName:'Tools/FileBrowserV2'
                icon:nil.

    "
     self installInLauncher
     self removeFromLauncher
    "

    "Modified: / 03-04-2012 / 11:06:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeFromLauncher
    "remove myself from the launcher's menu & settings dialog"

    |currentLauncher|

    NewLauncher isNil ifTrue:[^ self].
    NewLauncher removeUserTool:#fileBrowserV2.
    currentLauncher := NewLauncher current.
    currentLauncher notNil ifTrue:[
        currentLauncher fileBrowserItemVisible value:false
    ].
    NewLauncher removeSettingsApplicationByClass:#'FileBrowserV2SettingsAppl'.

    "
     self removeFromLauncher
    "
!

update:something with:aParameter from:changedObject
    something == #initialized ifTrue:[
	changedObject == ObjectMemory ifTrue:[
	    self installInLauncher.
	    ObjectMemory removeDependent:self.
	]
    ].
! !

!FileBrowserV2 class methodsFor:'defaults'!

entryFieldEndStringForMultipleSelection

    ^ ('[*]')
! !

!FileBrowserV2 class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileBrowserV2
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#columnLabel
'The text-cursor''s column number'

#lineAndColumnLabel
'The text-cursor''s line and column number'

#encodingLabel
'The file''s encoding (Right-click to change)'

#encodingLockedLabel
'Lock the file-encoding (do not try to guess from the file''s contents)'

#fileFilter
'Only show files matching the pattern.\Separate multiple patterns by ";".\Patterns starting with "~" are excluding.'

#lineLabel
'The text-cursor''s line number. Double-click to change'

#modeLabel
'The editing mode (Insert vs. overwrite)'

#numberOfFiles
'Number of files shown (Total number of files in directory)'

)

    "Modified: / 06-10-2011 / 14:37:12 / cg"
! !

!FileBrowserV2 class methodsFor:'image specs'!

applicationIcon

    ^ self defaultIcon
!

closePreviewButtonImage
      ^ ToolbarIconLibrary removeTabIcon
!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary startNewFileBrowserIcon
!

encodingLockIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary encodingLockIcon
!

hideFilenameEntryFieldIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary hideToolbarIconH14
!

hideToolBarIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary hideToolbarIconH26
! !

!FileBrowserV2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowserV2 andSelector:#windowSpec
     FileBrowserV2 new openInterface:#windowSpec
     FileBrowserV2 open
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
                   activeHelpKey: hideBookmarks
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: hideBookmarkBar
                   postBuildCallback: hideToolBarButtonCreated:
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
                         extent: (Point 53 21)
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
                         handles: (Any 0.77493599999999996 1.0)
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
                   handles: (Any 0.22500000000000001 1.0)
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
             layout: (LayoutFrame 0 0 -26 1 -16 1 0 1)
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
                   translateLabel: true
                   labelChannel: fileEncodingHolder
                   adjust: right
                   menu: encodingMenu
                 )
                (LabelSpec
                   name: 'FileEncodingLockedLabel'
                   layout: (LayoutFrame -235 1 2 0.0 -220 1 20 0.0)
                   activeHelpKey: encodingLockedLabel
                   level: 0
                   translateLabel: true
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
                         backgroundColor: (Color 0.0 66.75 66.75)
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
                   label: 'L : C'
                   name: 'LineAndColumnLabel'
                   layout: (LayoutFrame -55 1 1 0.0 0 1 1 1.0)
                   activeHelpKey: lineAndColumnLabel
                   level: -1
                   labelChannel: cursorLineAndColumnLabelHolder
                   adjust: left
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          (LabelSpec
             label: 'Preview'
             name: 'PreviewLabel'
             layout: (LayoutFrame 0 0.5 93 0 100 0.5 115 0)
             level: 0
             borderWidth: 1
             visibilityChannel: previewVisibleHolder
             backgroundColor: (Color 87.0 87.0 87.0)
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

!FileBrowserV2 class methodsFor:'menu specs'!

editModeInfoLabelMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#editModeInfoLabelMenu
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser editModeInfoLabelMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Insert'
	    itemValue: editModeInsert
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Overwrite'
	    itemValue: editModeOverwrite
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Insert Selecting'
	    itemValue: editModeInsertAndSelect
	    translateLabel: true
	  )
	 )
	nil
	nil
      )

    "Created: / 11-09-2006 / 12:23:59 / cg"
!

encodingMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowserV2 andSelector:#encodingMenu
     (Menu new fromLiteralArrayEncoding:(FileBrowserV2 encodingMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Encoding...'
	    itemValue: fileEncodingDialog
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    label: 'Locked'
	    translateLabel: true
	    indication: lockFileEncodingHolder
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
     MenuEditor new openOnClass:FileBrowserV2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(FileBrowserV2 mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browser'
            submenuChannel: browserMenu
          )
         (MenuItem
            label: 'Directory'
            submenuChannel: directoryMenu
          )
         (MenuItem
            label: 'File'
            submenuChannel: fileMenu
          )
         (MenuItem
            label: 'Edit'
            submenuChannel: editMenu
          )
         (MenuItem
            label: 'View'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Details'
                  submenuChannel: viewInContentsBrowserMenu
                )
               (MenuItem
                  label: 'Sort'
                  submenuChannel: sortMenu
                )
               (MenuItem
                  label: 'Show'
                  submenuChannel: showMenuSpec
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Toolbar'
                  hideMenuOnActivated: false
                  indication: toolBarVisibleHolder
                )
               (MenuItem
                  label: 'Bookmarks'
                  hideMenuOnActivated: false
                  indication: bookmarkBarVisibleHolder
                )
               (MenuItem
                  label: 'Path Entry && Filter'
                  hideMenuOnActivated: false
                  indication: filenameEntryFieldVisibleHolder
                )
               (MenuItem
                  label: 'Info'
                  hideMenuOnActivated: false
                  indication: infoBarVisibleHolder
                )
               (MenuItem
                  label: 'Tags'
                  hideMenuOnActivated: false
                  indication: tagsBrowserVisibleHolder
                )
               (MenuItem
                  label: 'Preview'
                  hideMenuOnActivated: false
                  indication: previewVisibleHolder
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Update'
                  itemValue: updateCurrentDirectory
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Tools'
            submenuChannel: toolsMenuSpec
          )
         (MenuItem
            label: 'Source Code Management'
            submenuChannel: scmMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Extras'
            submenuChannel: extraMenu
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'FileBrowser Documentation'
                  itemValue: openHTMLDocument:
                  argument: 'tools/fbrowserV2/TOP.html'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About FileBrowser...'
                  itemValue: openAboutThisApplication
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
!

previewLabelMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowserV2 andSelector:#previewLabelMenu
     (Menu new fromLiteralArrayEncoding:(FileBrowserV2 previewLabelMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Close Preview'
	    #itemValue: #closePreview
	    #translateLabel: true
	  )
	 )
	nil
	nil
      )
!

toolBarMainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileBrowserV2 andSelector:#toolBarMainMenu
     (Menu new fromLiteralArrayEncoding:(FileBrowserV2 toolBarMainMenu)) startUp
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
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryUpIcon)
          )
         (MenuItem
            activeHelpKey: fileDesktop
            enabled: enableGotoDesktopDirectory
            label: 'Desktop'
            itemValue: doGotoDesktopDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary desktopIcon)
          )
         (MenuItem
            activeHelpKey: fileHome
            enabled: enableHome
            label: 'Home'
            itemValue: doGotoHomeDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary homeIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoDefaultDirectory
            enabled: enableGotoDefaultDirectory
            label: 'Current'
            itemValue: doGotoDefaultDirectory
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary currentDirectoryIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoSmalltalkDirectory
            enabled: enableGotoSmalltalkDirectory
            label: 'ST/X Default'
            itemValue: doGotoSmalltalkDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary stxHomeIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoBookmark
            label: 'Bookmarks'
            isButton: true
            isVisible: false
            submenuChannel: gotoBookmarksMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryBookmarksIcon)
          )
         (MenuItem
            activeHelpKey: fileHistory
            enabled: enableFileHistory
            label: 'File History'
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
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary cutFileIcon)
          )
         (MenuItem
            activeHelpKey: copyFile
            enabled: hasSelection
            label: 'Copy'
            itemValue: copyFiles
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary copyFileIcon)
          )
         (MenuItem
            activeHelpKey: pasteFile
            enabled: canPaste
            label: 'Paste'
            itemValue: pasteFiles
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary pasteFileIcon)
          )
         (MenuItem
            activeHelpKey: deleteFile
            enabled: hasSelection
            label: 'Delete'
            itemValue: deleteFiles
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
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary editFileIcon)
          )
         (MenuItem
            activeHelpKey: fileIn
            label: 'File In'
            itemValue: fileFileIn
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary fileInIcon)
          )
         (MenuItem
            activeHelpKey: openChangeBrowser
            enabled: hasFileSelection
            label: 'Changes Browser'
            itemValue: openChangesBrowser
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
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary shellTerminalIcon)
          )
         (MenuItem
            activeHelpKey: make
            enabled: canMake
            label: 'Make'
            itemValue: doMake
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary make24x24Icon3)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            indication: viewDetails
            labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
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
!

toolBarMainMenu_new
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileBrowserV2 andSelector:#toolBarMainMenu_new
     (Menu new fromLiteralArrayEncoding:(FileBrowserV2 toolBarMainMenu_new)) startUp
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
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryUpIcon)
          )
         (MenuItem
            activeHelpKey: fileHome
            enabled: enableGotoHomeDirectory
            label: 'Home'
            itemValue: doGotoHomeDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary homeIcon)
          )
         (MenuItem
            activeHelpKey: gotoDesktop
            enabled: enableGotoDesktopDirectory
            label: 'Desktop'
            itemValue: doGotoDesktopDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary desktopIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoDefaultDirectory
            enabled: enableGotoDefaultDirectory
            label: 'Current'
            itemValue: doGotoDefaultDirectory
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary currentDirectoryIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoSmalltalkDirectory
            enabled: enableGotoSmalltalkDirectory
            label: 'ST/X Default'
            itemValue: doGotoSmalltalkDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary stxHomeIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoBookmark
            label: 'Bookmarks'
            isButton: true
            isVisible: false
            submenuChannel: gotoBookmarksMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryBookmarksIcon)
          )
         (MenuItem
            activeHelpKey: fileHistory
            enabled: enableFileHistory
            label: 'File History'
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
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary cutFileIcon)
          )
         (MenuItem
            activeHelpKey: copyFile
            enabled: hasSelection
            label: 'Copy'
            itemValue: copyFiles
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary copyFileIcon)
          )
         (MenuItem
            activeHelpKey: pasteFile
            enabled: canPaste
            label: 'Paste'
            itemValue: pasteFiles
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary pasteFileIcon)
          )
         (MenuItem
            activeHelpKey: deleteFile
            enabled: hasSelection
            label: 'Delete'
            itemValue: deleteFiles
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
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary editFileIcon)
          )
         (MenuItem
            activeHelpKey: fileIn
            label: 'File In'
            itemValue: fileFileIn
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary fileInIcon)
          )
         (MenuItem
            activeHelpKey: openChangeBrowser
            enabled: hasFileSelection
            label: 'Changes Browser'
            itemValue: openChangesBrowser
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
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary shellTerminalIcon)
          )
         (MenuItem
            activeHelpKey: make
            enabled: canMake
            label: 'Make'
            itemValue: doMake
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary make24x24Icon3)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            indication: viewDetails
            labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
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
!

toolBarMainMenu_old
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileBrowserV2 andSelector:#toolBarMainMenu_old
     (Menu new fromLiteralArrayEncoding:(FileBrowserV2 toolBarMainMenu_old)) startUp
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
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryUpIcon)
          )
         (MenuItem
            activeHelpKey: fileHome
            enabled: enableHome
            label: 'Home'
            itemValue: doGotoHomeDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary homeIcon)
          )
         (MenuItem
            activeHelpKey: gotoDesktop
            enabled: enableGotoDesktopDirectory
            label: 'Desktop'
            itemValue: doGotoDesktopDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary desktopIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoDefaultDirectory
            enabled: enableGotoDefaultDirectory
            label: 'Current'
            itemValue: doGotoDefaultDirectory
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary currentDirectoryIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoSmalltalkDirectory
            enabled: enableGotoSmalltalkDirectory
            label: 'ST/X Default'
            itemValue: doGotoSmalltalkDirectory
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary stxHomeIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoBookmark
            label: 'Bookmarks'
            isButton: true
            submenuChannel: gotoBookmarksMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryBookmarksIcon)
          )
         (MenuItem
            activeHelpKey: fileHistory
            enabled: enableFileHistory
            label: 'File History'
            isButton: true
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
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary cutFileIcon)
          )
         (MenuItem
            activeHelpKey: copyFile
            enabled: hasSelection
            label: 'Copy'
            itemValue: copyFiles
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary copyFileIcon)
          )
         (MenuItem
            activeHelpKey: pasteFile
            enabled: canPaste
            label: 'Paste'
            itemValue: pasteFiles
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary pasteFileIcon)
          )
         (MenuItem
            activeHelpKey: deleteFile
            enabled: hasSelection
            label: 'Delete'
            itemValue: deleteFiles
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteFileIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editFile
            label: 'Edit File'
            itemValue: doShowFileContents
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary editFileIcon)
          )
         (MenuItem
            activeHelpKey: fileIn
            label: 'File In'
            itemValue: fileFileIn
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary fileInIcon)
          )
         (MenuItem
            activeHelpKey: openChangeBrowser
            enabled: hasFileSelection
            label: 'Changes Browser'
            itemValue: openChangesBrowser
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
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary shellTerminalIcon)
          )
         (MenuItem
            activeHelpKey: make
            enabled: canMake
            label: 'Make'
            itemValue: doMake
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary makeIcon)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            indication: viewDetails
            labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
          )
         (MenuItem
            activeHelpKey: viewDetails
            label: 'viewDetails'
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

!FileBrowserV2 methodsFor:'actions'!

changeFileBrowserTitleTo:aString

    |string|

    string := 'FileBrowser: ', aString.
    self window label:string.
!

doSpawn

    self saveRuntimeAspectValues.
    self class openWithAspects:aspects withExtent:(self builder window extent).
!

hideBookmarkBar
    "hide the bookmarks - called when the button to the left of the toolbar is clicked"

    self bookmarkBarVisibleHolder value:false

    "Created: / 04-04-2012 / 12:08:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hideFilenameEntryField
    self filenameEntryFieldVisibleHolder value:false.
!

hideToolbar
    "hide the toolbar - called when the button to the left of the toolbar is clicked"

    self toolBarVisibleHolder value:false.
!

switchToBookmarkEntry: bookmark

    self gotoFile: bookmark path asFilename

    "Created: / 20-04-2012 / 18:07:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

toggleFileDetailsFor:anItem
    |viewDetails|

    viewDetails := self viewDetails value not.
    self viewDetails value:viewDetails.

    viewDetails ifTrue:[
	anItem activeHelpKey:#hideFileDetails.
	anItem label:(ToolbarIconLibrary viewNoDetailsIcon).
    ] ifFalse:[
	anItem activeHelpKey:#showFileDetails.
	anItem label:(ToolbarIconLibrary viewDetailsIcon).
    ].
! !

!FileBrowserV2 methodsFor:'aspects'!

bookmarkBarVisibleHolder
    "return/create the 'bookmarkBarVisibleHolder' value holder (automatically generated)"

    bookmarkBarVisibleHolder isNil ifTrue:[
        bookmarkBarVisibleHolder := ValueHolder with:true.
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
!

busyLabelHolder
    ^ self
        aspectFor:#busyLabelHolder
        ifAbsent:[ ValueHolder with:' ' ].

    "Created: / 25-07-2006 / 09:06:00 / cg"
!

canAddToClassPath
    ^ [
        |f|

        (Java isNil or:[Java isLoaded not]) ifTrue:[
            false
        ] ifFalse:[
            f := self currentFileNameHolder value.
            f size == 1
            and:[ f := f first. ((Java classPath ? #()) includes:f pathName) not
            and:[ f isDirectory
                 or:[(f hasSuffix:'jar')
                 or:[(f hasSuffix:'zip')]]]]
          ]
      ]
!

canAddToSourcePath
    ^ [
	|f|

	(Java isNil or:[Java isLoaded not]) ifTrue:[
	    false
	] ifFalse:[
	    f := self currentFileNameHolder value.
	    f size == 1
	    and:[ f:= f first. (Java sourcePath isNil
		 or:[(Java sourcePath includes:f pathName) not])
	    and:[f isDirectory
		 or:[(f hasSuffix:'jar')
		 or:[(f hasSuffix:'zip')]]]].
	  ]
      ]
!

canRemoveFromClassPath
    ^ [
        |f|

        (Java isNil or:[Java isLoaded not]) ifTrue:[
            false
        ] ifFalse:[
            f := self currentFileNameHolder value.
            f size == 1
            and:[ f:= f first. ((Java classPath ? #())includes:f pathName) not
            and:[ f isDirectory
                 or:[(f hasSuffix:'jar')
                 or:[(f hasSuffix:'zip')]]]]
          ]
      ]
!

currentDirectoryDisplayed
    "Return a directory that is currently displayed in the browser"

    ^(self builder componentAt: #DirectoryContentsBrowser) application currentDirectoryDisplayed

    "Modified: / 13-02-2014 / 16:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cursorColLabelHolder
    ^ self
	aspectFor:#cursorColLabelHolder
	ifAbsent:[
	    self
		applicationNamed:#FileApplicationNoteBook
		ifPresentDo:[:appl | appl cursorColLabelHolder].
	]
!

cursorLineAndColumnLabelHolder
    ^ self
        aspectFor:#cursorLineAndColumnLabelHolder
        ifAbsent:[
            self
                applicationNamed:#FileApplicationNoteBook
                ifPresentDo:[:appl | appl cursorLineAndColumnLabelHolder].
        ]
!

cursorLineLabelHolder
    ^ self
	aspectFor:#cursorLineLabelHolder
	ifAbsent:[
	    self
		applicationNamed:#FileApplicationNoteBook
		ifPresentDo:[:appl | appl cursorLineLabelHolder].
	]
!

fileEncodingLockImageHolder
    ^ self
	aspectFor:#fileEncodingLockImageHolder
	ifAbsent:[
	    BlockValue
		with:[:m | m == true ifTrue:[self class encodingLockIcon] ifFalse:[nil] ]
		argument:(self lockFileEncodingHolder)
	]

    "Modified: / 08-03-2007 / 22:59:12 / cg"
!

fileEntryFieldHolder

    fileEntryFieldHolder isNil ifTrue:[
	fileEntryFieldHolder := ValueHolder new.
	fileEntryFieldHolder addDependent:self.
    ].
    ^ fileEntryFieldHolder.
!

listOfDeviceDrives

    listOfDeviceDrives isNil ifTrue:[
	listOfDeviceDrives := Filename volumes.
    ].
    ^ listOfDeviceDrives
!

modeLabelHolder
    ^ self
	aspectFor:#modeLabelHolder
	ifAbsent:[
	    self
		applicationNamed:#FileApplicationNoteBook
		ifPresentDo:[:appl | appl modeLabelHolder].
	]
!

modeLabelMenuHolder
    ^ self
	applicationNamed:#FileApplicationNoteBook
	ifPresentDo:[:appl | appl modeLabelMenu].

    "Created: / 11-09-2006 / 12:26:44 / cg"
!

selectedDeviceDrive

    selectedDeviceDrive isNil ifTrue:[
        selectedDeviceDrive := ValueHolder with:(self listOfDeviceDrives firstIfEmpty:nil).
        selectedDeviceDrive addDependent:self.
    ].
    ^ selectedDeviceDrive
! !

!FileBrowserV2 methodsFor:'aspects-visibility'!

busyLabelVisibleHolder
    ^ self aspectFor:#busyLabelVisibleHolder ifAbsent:[ValueHolder with:false]

    "Created: / 25-07-2006 / 09:06:22 / cg"
!

driveSelectorVisible
    ^ self systemSupportsVolumes "/ systemIsDOS
!

filenameEntryFieldVisibleHolder
    " aspect for show FileEntryField "

    ^ self aspectFor:#filenameEntryFieldVisibleHolder ifAbsent:[ValueHolder with:true]
!

infoBarVisibleHolder
    " aspect for show infoBar "

    ^ self aspectFor:#infoBarVisibleHolder ifAbsent:[ValueHolder with:true]
!

previewVisibleHolder
    " aspect for show preview"

    ^ self aspectFor:#previewVisibleHolder ifAbsent:[ValueHolder with:false]
!

toolBarVisibleHolder
    " aspect for show toolbar"

    ^ self aspectFor:#toolBarVisibleHolder ifAbsent:[ValueHolder with:true]
! !

!FileBrowserV2 methodsFor:'change & update'!

currentFileNameHolderChanged
    |newEntryValue nSelected files volume dir|

    files := self currentSelectedObjects.
    nSelected := files size.

    nSelected == 0 ifTrue:[
        newEntryValue := ''.
    ] ifFalse:[
        nSelected == 1 ifTrue:[
            newEntryValue := files first.
        ] ifFalse:[
            newEntryValue := self commonPrefixOfSelectedFiles.
        ].
    ].
    self fileEntryFieldHolder value:(newEntryValue asString) withoutNotifying:self.

    OperatingSystem supportsVolumes ifTrue:[
        volume := (nSelected >= 1)
                    ifTrue:[files first volume]
                    ifFalse:[nil].
        self selectedDeviceDrive value:volume.
    ].
    self updatePreview.

    nSelected == 1 ifTrue:[
        (dir := self currentDirectory) notNil ifTrue:[
            self changeFileBrowserTitleTo:(dir baseName)
        ]
    ].
    self updateBookmark

    "Modified: / 06-07-2011 / 09:41:50 / cg"
    "Modified: / 05-02-2014 / 11:45:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileEntryFieldHolderChanged
    |fileName fileNameString dir|

    fileNameString := fileEntryFieldHolder value withoutSeparators.
    fileNameString isEmpty ifTrue:[
        pathEntryField flash.
        ^ self
    ].

    fileName := fileNameString asFilename.
    fileName exists ifFalse:[
        pathEntryField flash.

        dir := fileName directory.
        dir exists ifTrue:[
            self currentFileNameHolder
                value:(OrderedCollection with:dir)
                withoutNotifying:self.
        ].
        fileName baseName includesMatchCharacters ifTrue:[
            self fileEntryFieldHolder value:(fileName directoryName) withoutNotifying:self.
            self filterModel value:fileName baseName.
        ].

"/        answer := OptionBox
"/           request:(resources string:'No file or directory named "%1" exists.\\Create ?' with:fileNameString allBold) withCRs
"/           buttonLabels:#('Create as File' 'Create as Directory' 'Cancel')
"/           values:#(createFile createDirectory nil)
"/           default:nil.
"/
"/        answer isNil ifTrue:[
"/            ^ self.
"/        ].
"/
"/        [
"/            answer == #createFile ifTrue:[
"/                fileName directory recursiveMakeDirectory.
"/                fileName createAsEmptyFile.
"/            ] ifFalse:[
"/                answer == #createDirectory ifTrue:[
"/                    fileName recursiveMakeDirectory.
"/                ]
"/            ].
"/        ] on:OperatingSystem accessDeniedErrorSignal do:[:ex |
"/            Dialog warn:'Error: ' , ex description.
"/        ].
        ^ self
    ].
    self setCurrentFileName:fileName.
!

selectedDeviceDriveChanged
    | newDrive curSel newFile|

    newDrive := self selectedDeviceDrive value.
    curSel := self currentSelectedObjects.
    curSel notEmptyOrNil ifTrue:[
        curSel first volume = newDrive ifTrue:[ ^self].
    ].

    newDrive notNil ifTrue:[
        newFile := (OperatingSystem pathNameForDrive:newDrive) asFilename.

        newFile isReadable ifTrue:[
            self gotoFile:newFile.
            ^self.
        ].
    ].
    self selectedDeviceDrive
        value:(curSel notEmptyOrNil
                ifTrue:[curSel first volume]
                ifFalse:['C:']).

    "Modified: / 18-09-2007 / 09:41:30 / cg"
!

selectedImage
    |files selectedFile mime img|

    files := self currentSelectedFiles.
    files size >= 1 ifFalse:[
	^ nil
    ].
    selectedFile := files last.

    mime := MIMETypes mimeTypeForFilename:selectedFile.
    (mime notNil and:[mime startsWith:'image/']) ifTrue:[
	img := Image fromFile:selectedFile.
	^ img
    ].

    ^ nil.
!

showImagePreview:image
    |imgView|

    imgView := builder componentAt:#Preview.
    (imgView isNil or:[imgView scrolledView isNil]) ifTrue:[^ self].
    imgView adjust:#fitBig.
    imgView image:image.

    "Modified: / 05-02-2007 / 10:52:03 / cg"
!

showPreview
    |shownImage lbl previewLabel|

    shownImage := self selectedImage.
    lbl := shownImage isNil ifTrue:'Preview' ifFalse:[ shownImage fileName asFilename baseName ].

    previewLabel := builder componentAt:#PreviewLabel.
    previewLabel label:lbl; forceResizeHorizontally.
    self enqueueMessage:#'showImagePreview:' with:shownImage.
!

update:something with:aParameter from:changedObject
    changedObject == self selectedDeviceDrive ifTrue:[
        self selectedDeviceDriveChanged.
        ^ self.
    ].
    changedObject == self fileEntryFieldHolder ifTrue:[
        self fileEntryFieldHolderChanged.
        ^ self.
    ].
    changedObject == self currentFileNameHolder ifTrue:[
        super update:something with:aParameter from:changedObject.
        self currentFileNameHolderChanged.
        ^ self.
    ].
    (changedObject == self previewVisibleHolder) ifTrue:[
        self updatePreview.
        ^ self.
    ].
    (changedObject == self toolBarVisibleHolder
    or:[changedObject == self bookmarkBarVisibleHolder
    or:[changedObject == self filenameEntryFieldVisibleHolder
    or:[changedObject == self infoBarVisibleHolder]]]) ifTrue:[
        self updateToolVisibility.
        ^ self.
    ].
    (changedObject == self sortBlockProperty or:[changedObject == self sortDirectoriesBeforeFiles]) ifTrue:[
        self sortFileListsBy:(self sortBlockProperty value) withReverse:false.
        ^ self.
    ].

    ^ super update:something with:aParameter from:changedObject.

    "Modified: / 01-10-2007 / 19:21:35 / cg"
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

updatePreview
    |previewLabel shownImage plug closePreviewButton|

    self previewVisibleHolder value ifTrue:[
	shownImage := nil.
	imgView := builder componentAt:#Preview.
	previewLabel := builder componentAt:#PreviewLabel.
	closePreviewButton := builder componentAt:#ClosePreviewButton.

	plug := Plug new.
	plug respondTo:#closePreview with:[ self previewVisibleHolder value:false ].

	previewLabel menuHolder:(self class previewLabelMenu decodeAsLiteralArray).
	previewLabel menuPerformer:plug asValue.

	closePreviewButton action:[ self previewVisibleHolder value:false ].

	previewProcess notNil ifTrue:[
	    previewProcess terminate
	].
	previewProcess := [
				|imgView oldBg shownImage lbl|

				oldBg := previewLabel backgroundColor.
				previewLabel backgroundColor:(Color red lightened lightened).
				[
				    self showPreview.
				    previewProcess := nil.
				] ensure:[
				    previewLabel backgroundColor:oldBg.
				].
			  ] forkAt:7.
    ] ifFalse:[
	imgView notNil ifTrue:[
	    imgView image:nil.
	]
    ].
!

updateToolVisibility
    |bldr toolBar bookmarkBar infoBar filenameEntryField vPanel topOffset bottomOffset
     toolBarVisible bookmarkBarVisible filenameEntryFieldVisible infoBarVisible d|

    bldr := self builder.

    topOffset := 0.
    bottomOffset := 0.

    toolBarVisible := self toolBarVisibleHolder value.
    toolBarVisible ifTrue:[
        toolBar := bldr componentAt:#ToolbarBox.
        topOffset := topOffset + toolBar height.
    ].

    bookmarkBarVisible := self bookmarkBarVisibleHolder value.
    bookmarkBarVisible ifTrue:[
        bookmarkBar := bldr componentAt:#BookmarkBar.
        d := bookmarkBar height. "/ layout bottomOffset - bookmarkBar layout topOffset.
        bookmarkBar layout topOffset:topOffset bottomOffset:topOffset + d.
        "/ that's the consequence of modifying the layout, instead of sending #layout:
        "/ we have to tell the component that it changed here!!
        bookmarkBar layoutChanged.
        topOffset := topOffset + d
    ].

    filenameEntryFieldVisible := self filenameEntryFieldVisibleHolder value.
    filenameEntryFieldVisible ifTrue:[
        filenameEntryField := bldr componentAt:#FilenameEntryFieldBox.
        d := filenameEntryField layout bottomOffset - filenameEntryField layout topOffset.
        filenameEntryField layout topOffset:topOffset bottomOffset:topOffset + d.
        "/ that's the consequence of modifying the layout, instead of sending #layout:
        "/ we have to tell the component that it changed here!!
        filenameEntryField layoutChanged.
        topOffset := topOffset + filenameEntryField height.
    ].

    infoBarVisible := self infoBarVisibleHolder value.
    infoBarVisible ifTrue:[
        infoBar := bldr componentAt:#InfoBox.
        bottomOffset := bottomOffset - infoBar height.
    ].

    vPanel := bldr componentAt:#BrowserBox.
    vPanel layout topOffset:topOffset+1.
    vPanel layout bottomOffset:bottomOffset-1.
    vPanel container notNil ifTrue:[
        vPanel containerChangedSize.
    ].

    "Modified: / 03-04-2012 / 22:23:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileBrowserV2 methodsFor:'event handling'!

crPressedInPathField
    |path fn|

    path := fileEntryFieldHolder value.
    fn := path asFilename.
    (fn exists and:[ fn isDirectory not ]) ifTrue:[
	self openApplForFile:path.
    ]
!

processEvent:anEvent
    "filter keyboard events.
     Return true, if I have eaten the event"

    <resource: #keyboard (#Return )>

    |focusView key rawKey fileName|

    anEvent isKeyPressEvent ifTrue:[
        focusView := anEvent targetView.
        key := anEvent key.
        rawKey := anEvent rawKey.

        (focusView isSameOrComponentOf:self window) ifTrue:[

            (focusView == pathEntryField) ifFalse:[ ^ false].

            (key == #Return) ifTrue:[
                fileName := pathEntryField list first asFilename.
                (fileName exists and:[fileName isDirectory not]) ifTrue:[
                    self openApplForFile:fileName
                ].
            ].
        ]
    ].

    (anEvent isButtonPressEvent or:[anEvent isButtonMultiPressEvent]) ifTrue:[
        self
            applicationNamed:#FileApplicationNoteBook
            ifPresentDo:[:appl |
                |subApp editor eventView viewsName|

                subApp := appl selectedApplication.
                subApp notNil ifTrue:[
                    eventView := anEvent view.
                    viewsName := eventView name.

                    anEvent isButtonMultiPressEvent ifTrue:[
                        (viewsName = 'LineLabel' or:[viewsName = 'LineAndColumnLabel']) ifTrue:[
                            editor := subApp perform:#editView ifNotUnderstood:nil.
                            editor notNil ifTrue:[
                                editor gotoLine
                            ].
                        ].
                        viewsName = 'ModeLabel' ifTrue:[
                            eventView activateMenu
                        ].
                        viewsName = 'EncodingLabel' ifTrue:[
                            eventView activateMenu
                        ].
                    ] ifFalse:[
                        anEvent button == 2 ifTrue:[
                            eventView name = 'LineLabel' ifTrue:[
                                subApp editView gotoLine
                            ].
                        ].
                    ].
                ].
            ].
    ].

    ^ false

    "Modified: / 17-05-2007 / 09:12:53 / cg"
! !

!FileBrowserV2 methodsFor:'menu accessing'!

menuFileHistory
    "initialize the file history menu"

    <resource: #programMenu >

    |menu hist text removeItem removeCol|

    menu := Menu new receiver:self.

    hist := self fileHistory.
    hist isEmpty ifTrue:[^ nil].

    removeCol := OrderedCollection new.
    hist do:[:aFileItem|
        "aFileItem fileName exists" true ifTrue:[
            menu addItem:(MenuItem 
                            label: aFileItem fileName asString 
                            itemValue:
                                [
                                    self setCurrentFileName:(aFileItem fileName).
                                    self openApplByFileItem:aFileItem
                                ]
                            translateLabel:false).
        ] ifFalse:[
            removeCol add:aFileItem.
        ]
    ].
    "/ remove all not existing history entries
    removeCol do:[ : el |
        hist remove:el.
    ].
    removeItem := MenuItem new.
    text := resources string:'Clear History'.
    "/ text := LabelAndIcon icon:(self class clearHistoryIcon) string:text.
    removeItem label:text.
    removeItem
        itemValue:[
            self fileHistory removeAll.
            self enableFileHistory value:false.
        ].
    menu addSeparator.
    menu addItem:removeItem.
    ^ menu

    "Modified: / 09-09-2012 / 13:08:42 / cg"
! !

!FileBrowserV2 methodsFor:'queries'!

defaultWindowExtent
    "use nearly the full screen height, but at least 768px if available.
     Keep the width as defined in the windowSpec"

    |w maxHeight|

    w := self window.
    maxHeight := w device usableHeightAt:w origin.
    ^ Point x:nil y:(((maxHeight - 200) max:w extent y) min:maxHeight).
!

getAllFilesAsStrings
    ^ self directoryContentsBrowser getAllFilesAsStrings
! !

!FileBrowserV2 methodsFor:'startup & release'!

closeRequest
    "asks for permission before closing"

    self
	applicationNamed:#FileApplicationNoteBook
	ifPresentDo:[:appl | appl tryCloseApplications ifFalse:[^ self] ].

    super closeRequest.
!

hideFilenameEntryFieldButtonCreated:aButton

    aButton passiveLevel:(MenuPanel defaultLevel).
    aButton activeLevel:-1.
    aButton backgroundColor:(MenuPanel defaultBackgroundColor).
!

hideToolBarButtonCreated:aButton

    aButton passiveLevel:(MenuPanel defaultLevel).
    aButton activeLevel:-1.
    aButton backgroundColor:(MenuPanel defaultBackgroundColor).
!

initialize

    self masterApplication:nil.
    self directoryHistory resetForwardBackward.
!

makeDependent

    super makeDependent.
    self sortBlockProperty addDependent:self.
    self filenameEntryFieldVisibleHolder addDependent:self.
    self toolBarVisibleHolder addDependent:self.
    self infoBarVisibleHolder addDependent:self.
    self previewVisibleHolder addDependent:self.
!

onDirectory:aDirectoryPathOrNil
    |files|

    self createBuilder.
    aDirectoryPathOrNil notNil ifTrue:[
	aDirectoryPathOrNil isCollection ifTrue:[
	    files := aDirectoryPathOrNil
	] ifFalse:[
	    files := Array with:aDirectoryPathOrNil.
	].
	self currentFileNameHolder value:files.
    ].
!

openOnDirectory:aDirectoryPath
    self onDirectory:aDirectoryPath.
    self open
!

openOnFileNamed:aFilename editing:editing
    "start a new FileBrowserV2 on a aFilename;
     If editing is true, the browser opens the document as text to be edited;
     if false, it looks for an appropriate viewer and uses that if one is found."

    |f|

    f := aFilename asFilename asAbsoluteFilename.
    f isDirectory ifTrue:[
        self onDirectory:aFilename.
        self open.
        ^ self.
    ].

    self onDirectory:(f directory).
    self currentFileNameHolder setValue:(Array with:f).
    self openAndWaitUntilVisible.
    self enqueueDelayedAction:[
        editing ifTrue:[
            self openTextEditorForFile:f.
        ] ifFalse:[
            self openApplForFile:f.
        ].
    ].

    "
     FileBrowserV2 openOnFileNamed:'Makefile'
    "
!

postBuildDirectoryTree:aWidget
    aWidget application multipleSelect:true.
!

postBuildEditField:aWidget

    pathEntryField := aWidget.
    aWidget model:self fileEntryFieldHolder.
    aWidget listHolder:self directoryHistory.
    aWidget level:-1.
    aWidget acceptIfUnchanged:true.
    aWidget crAction:[ self crPressedInPathField ].
!

postBuildEditModeInfoLabel:aLabel
    aLabel menuHolder:self; menuMessage:#modeLabelMenuHolder.

    "Created: / 11-09-2006 / 12:24:54 / cg"
!

postBuildFilterBox:aWidget

    self filterValueBox value:aWidget.
    self filterBackgroundColor value:aWidget backgroundColor.
!

postBuildPathViewBox:aWidget

    aWidget backgroundColor:(MenuPanel defaultBackgroundColor).
!

postBuildWith:aBuilder

    | prefs |

    super postBuildWith:aBuilder.
    self updateToolVisibility.

    "Load user settings"
    prefs := UserPreferences current.
    AbstractFileBrowser userPreferencesAspectList keysAndValuesDo:[:aspect :default|
	| value |

	(prefs respondsTo: aspect) ifTrue:[
	    value := prefs perform: aspect
	] ifFalse:[
	    value := prefs at: aspect ifAbsent:[default].
	].
	(self perform: aspect) value: value
    ]

    "Modified: / 10-10-2011 / 10:54:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith:aBuilder

    super postOpenWith:aBuilder.

    self currentFileNameHolderChangedForCommon.
    self currentFileNameHolderChanged.

    self windowGroup addPreEventHook:self.
!

release

    self saveRuntimeAspectValues.
    super release
! !

!FileBrowserV2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


FileBrowserV2 initialize!
