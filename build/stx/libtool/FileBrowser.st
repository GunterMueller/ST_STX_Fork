"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

StandardSystemView subclass:#FileBrowser
	instanceVariableNames:'menuPanel labelView filterField fileListView subView
		currentDirectory fileList checkBlock checkDelta timeOfLastCheck
		myName killButton pauseToggle compressTabs lockUpdate
		previousDirectory currentFileName timeOfFileRead tabSpec
		commandView commandIndex fileEncoding tabRulerView scrollView
		icons matchedIcons listUpdateProcess currentFileInFileName
		lastFileDiffDirectory sortByWhat sortCaseless showingDetails
		showingTimeAndDate showingHiddenFiles showingBigImagePreview
		imagePreviewView imageRenderProcess dosEOLMode doAutoUpdate
		doNotShowFontDialog lastEnforcedNameSpace'
	classVariableNames:'HistorySize DefaultIcon CommandHistory CommandHistorySize
		DefaultCommandPerSuffix VisitedFileHistory LastEnforcedNameSpace'
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    this used to be a very simple demo application,
    but migrated into a quite nice tool, includes all kinds of 
    warning and information boxes, background processes for directory-
    reading and internationalized strings. A good example for beginners,
    on how to do things .... (and maybe how not to do things ;-, since some
    stuff is historic and was implemented at times when better mechanisms
    were not available)

    See additional information in 'doc/misc/fbrowser.doc'.

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
        Claus Gittinger

    [start with:]
        FileBrowser open
"
! !

!FileBrowser class methodsFor:'instance creation'!

on:aDirectoryPath
    "return a new FileBrowser in a pathname"

    ^ (self new currentDirectory:aDirectoryPath)

    "
     (FileBrowser on:'/usr/local/bin') open
     (FileBrowser on:'/etc'          ) open
     (FileBrowser on:'..'            ) open
     (FileBrowser on:'.'             ) open
    "
!

openOn:aDirectoryPath
    "start a new FileBrowser in a pathname"

    ^ (self on:aDirectoryPath) open

    "
     FileBrowser openOn:'/etc'
     FileBrowser openOn:'..'
     FileBrowser openOn:'.'
    "
!

openOn:aDirectoryPath withExtent:extent
    "start a new FileBrowser in a pathname"

    ^ (self on:aDirectoryPath) openWithExtent:extent

    "
     FileBrowser openOn:'/etc'           withExtent:200@300
     FileBrowser openOn:'..'             withExtent:200@300
     FileBrowser openOn:'.'              withExtent:200@300
    "
!

openOnFileNamed:aFilename
    "start a new FileBrowser on a file"

    |f browser|

    f := aFilename asFilename.
    f isDirectory ifTrue:[
        ^ self openOn:aFilename
    ].

    browser := self on:f directoryName.
    browser updateCurrentDirectory.
    browser showFile:f baseName.

    browser open.
    ^ browser

    "
     FileBrowser openOnFileNamed:'Makefile'
     FileBrowser openOnFileNamed:'../Makefile'
     FileBrowser openOnFileNamed:'/tmp/foo'
    "

    "Modified: / 17.6.1998 / 11:25:29 / cg"
! !

!FileBrowser class methodsFor:'aspects'!

directoryBookmarks
    ^ AbstractFileBrowser directoryBookmarks.
!

directoryHistory

    ^ AbstractFileBrowser directoryHistory.
! !

!FileBrowser class methodsFor:'defaults'!

default
    ^ UserPreferences current fileBrowserClass 

    "   
     FileBrowser default open
    "
!

defaultIcon
    "return the file browsers default window icon"

    <resource: #programImage>
    <resource: #style (#FILEBROWSER_ICON #FILEBROWSER_ICON_FILE)>

    |nm i res|

    (i := DefaultIcon) isNil ifTrue:[
        res := self classResources.
        i := res at:'FILEBROWSER_ICON' default:nil.
        i isNil ifTrue:[
            nm := res at:'FILEBROWSER_ICON_FILE' default:'FBrowser.xbm'.
            i := Smalltalk imageFromFileNamed:nm forClass:self.
            i isNil ifTrue:[
                i := StandardSystemView defaultIcon
            ]
        ].
        i notNil ifTrue:[
            DefaultIcon := i := i onDevice:Display
        ]
    ].
    ^ i

    "Modified: / 19-03-1997 / 20:48:34 / ca"
    "Modified: / 17-09-2007 / 11:36:12 / cg"
! !

!FileBrowser class methodsFor:'fileList user interaction'!

goodRenameDefaultForFile:oldName lastOld:lastOldName lastNew:lastNewName
    ^ DoWhatIMeanSupport goodRenameDefaultForFile:oldName lastOld:lastOldName lastNew:lastNewName
! !

!FileBrowser class methodsFor:'history'!

addToCommandHistory:aCommandString for:aFilename
    |cmd suffix|

    (aCommandString notEmptyOrNil) ifTrue:[
        CommandHistory notNil ifTrue:[
            CommandHistory addFirst:aCommandString.
            CommandHistory size > CommandHistorySize ifTrue:[
                CommandHistory removeLast
            ]
        ].
        aFilename notNil ifTrue:[
            cmd := aCommandString copyTo:(aCommandString indexOf:Character space ifAbsent:[aCommandString size + 1])-1.
            DefaultCommandPerSuffix isNil ifTrue:[
                DefaultCommandPerSuffix := Dictionary new.
            ].
            suffix := aFilename asFilename suffix.
            suffix notNil ifTrue:[
                DefaultCommandPerSuffix at:suffix put:cmd.
            ]
        ]
    ]

    "Created: 14.11.1996 / 14:58:13 / cg"
!

addToVisitedFileHistory:path
    |idx|

    idx := VisitedFileHistory indexOf:path.
    idx == 0 ifTrue:[
        VisitedFileHistory size >= HistorySize ifTrue:[
            VisitedFileHistory removeLast.
        ]
    ] ifFalse:[
        "already been there before; move the entry to
         the beginning, so it will fall out later."

        VisitedFileHistory removeIndex:idx.
    ].
    VisitedFileHistory addFirst:path.
! !

!FileBrowser class methodsFor:'interface specs'!

fileSearchDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowser andSelector:#fileSearchDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: fileSearchDialogSpec
        window: 
       (WindowSpec
          label: 'File Search'
          name: 'File Search'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 326 346)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Search for files named:'
              name: 'Label1'
              layout: (LayoutFrame 0 0 10 0 0 1 32 0)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField1'
              layout: (LayoutFrame 10 0 36 0 305 0 58 0)
              tabable: true
              model: namePatternHolder
              acceptOnPointerLeave: false
            )
           (CheckBoxSpec
              label: 'Ignore case'
              name: 'CheckBox1'
              layout: (LayoutFrame 7 0 66 0 143 0 88 0)
              tabable: true
              model: ignoreCaseInName
              translateLabel: true
            )
           (LabelSpec
              label: 'Containing the string:'
              name: 'Label2'
              layout: (LayoutFrame 0 0.0 107 0 0 1.0 129 0)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField2'
              layout: (LayoutFrame 10 0 133 0 305 0 155 0)
              enableChannel: notSearchForSameContents
              tabable: true
              model: contentsPatternHolder
              acceptOnPointerLeave: false
            )
           (CheckBoxSpec
              label: 'Ignore case'
              name: 'CheckBox2'
              layout: (LayoutFrame 6 0 163 0 142 0 185 0)
              enableChannel: notSearchForSameContents
              tabable: true
              model: ignoreCaseInContents
              translateLabel: true
            )
           (LabelSpec
              label: 'Containing same contents as selected:'
              name: 'Label3'
              layout: (LayoutFrame 0 0.0 223 0 -30 1.0 245 0)
              translateLabel: true
              adjust: left
            )
           (DividerSpec
              name: 'Separator1'
              layout: (LayoutFrame 0 0.0 97 0 0 1.0 101 0)
            )
           (CheckToggleSpec
              name: 'CheckToggle1'
              layout: (LayoutOrigin -25 1 225 0)
              tabable: true
              model: searchForSameContents
              enableChannel: searchForSameContentsEnabled
              isTriggerOnDown: true
              showLamp: false
              lampColor: (Color 100.0 100.0 0.0)
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -30 1 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: centerMax
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    tabable: true
                    model: cancel
                    extent: (Point 151 25)
                  )
                 (ActionButtonSpec
                    label: 'Search'
                    name: 'Button2'
                    translateLabel: true
                    tabable: true
                    model: accept
                    isDefault: true
                    extent: (Point 152 25)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!FileBrowser class methodsFor:'menu specs'!

baseBookmarksMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#baseBookmarksMenuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser baseBookmarksMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Add Bookmark'
                #translateLabel: true
                #value: #addBookmark
            )
             #(#MenuItem
                #label: 'Remove Bookmark'
                #translateLabel: true
                #value: #removeBookmark
                #enabled: #hasBookmarksToRemove
            )
          ) nil
          nil
      )

    "Created: / 4.8.1998 / 17:21:16 / cg"
    "Modified: / 14.8.1998 / 19:19:06 / cg"
!

baseDirectoryMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#directoryMenuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser directoryMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Copy Path'
                #translateLabel: true
                #value: #copyPath
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Up'
                #translateLabel: true
                #value: #changeToParentDirectory
                #enabled: #currentDirectoryIsNotTop
            )
             #(#MenuItem
                #label: 'Back'
                #translateLabel: true
                #value: #changeToPreviousDirectory
            )
             #(#MenuItem
                #label: 'Home'
                #translateLabel: true
                #value: #changeToHomeDirectory
            )
             #(#MenuItem
                #label: 'Default'
                #translateLabel: true
                #value: #changeToDefaultDirectory
            )
             #(#MenuItem
                #label: 'Goto...'
                #translateLabel: true
                #value: #changeCurrentDirectory
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Bookmarks'
                #translateLabel: true
                #submenuChannel: #bookmarksMenuSpec
              )
          ) nil
          nil
      )

    "Created: / 4.8.1998 / 17:21:16 / cg"
    "Modified: / 14.8.1998 / 19:19:06 / cg"
!

bookmarksMenuSpec
    <resource: #programMenu>

    |menu bookmarks|

    menu := self baseBookmarksMenuSpec decodeAsLiteralArray.

    "/ add the history items ...

    bookmarks := self directoryBookmarks.
    bookmarks size > 0 ifTrue:[
        menu addSeparator.
        bookmarks do:[:dirName |
            menu addItem:((MenuItem 
                            label:(dirName asFilename pathName) 
                            itemValue:#changeDirectoryTo:
                            argument:dirName)
                                translateLabel:false).
        ].
    ].
    ^ menu

    "Modified: / 17.8.1998 / 10:13:05 / cg"
!

cvsMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
              (
               (MenuItem
                  enabled: hasSelection
                  label: 'Update Selected Files/Directories'
                  itemValue: cvsUpdateSelection
                  translateLabel: true
                )
               (MenuItem
                  label: 'Update Directory Local'
                  itemValue: cvsUpdateDirectoryLocal
                  translateLabel: true
                )
               (MenuItem
                  label: 'Update Directory Recursive'
                  itemValue: cvsUpdateDirectoryRecursive
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Commit...'
                  itemValue: cvsCommitSelection
                  translateLabel: true
                )
               (MenuItem
                  label: 'Add && Commit...'
                  itemValue: cvsAddAndCommitSelection
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: canRemoveCVSContainer
                  label: 'Remove File && CVS Container...'
                  itemValue: cvsRemoveFileAndContainer
                  translateLabel: true
                )
               )
              nil
              nil
            )
!

directoryMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#directoryMenuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser directoryMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Bookmarks'
            #translateLabel: true
            #submenuChannel: #bookmarksMenuSpec
          )
         #(#MenuItem
            #label: 'Visited Directories'
            #translateLabel: true
            #submenuChannel: #historyMenuSpec
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Copy Path'
            #itemValue: #copyPath
            #translateLabel: true
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Cut'
            #itemValue: #cutSelection
            #translateLabel: true
            #sendToOriginator: true
          )
         #(#MenuItem
            #label: 'Copy'
            #itemValue: #copySelection
            #translateLabel: true
            #sendToOriginator: true
          )
         #(#MenuItem
            #label: 'Paste'
            #itemValue: #pasteSelection
            #translateLabel: true
            #sendToOriginator: true
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #enabled: #currentDirectoryIsNotTop
            #label: 'Up'
            #itemValue: #changeToParentDirectory
            #translateLabel: true
          )
         #(#MenuItem
            #label: 'Goto...'
            #itemValue: #changeCurrentDirectory
            #translateLabel: true
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Back'
            #itemValue: #changeToPreviousDirectory
            #translateLabel: true
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Default'
            #itemValue: #changeToDefaultDirectory
            #translateLabel: true
          )
         #(#MenuItem
            #label: 'Home'
            #itemValue: #changeToHomeDirectory
            #translateLabel: true
          )
         )
        nil
        nil
      )
!

editMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
              (
               (MenuItem
                  label: 'Visited Files'
                  translateLabel: true
                  submenuChannel: visitedFileMenuSpec
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Edit File'
                  itemValue: fileGet
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Insert File'
                  itemValue: fileInsert
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Copy File List'
                  itemValue: copyFileList
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Copy Selected Filename'
                  itemValue: copySelectedFileName
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Copy Selected Pathname'
                  itemValue: copySelectedPathName
                  translateLabel: true
                )
               (MenuItem
                  label: 'Copy Command History'
                  itemValue: copyCommandHistory
                  translateLabel: true
                )
               )
              nil
              nil
            )
!

fileMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileBrowser andSelector:#fileMenuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser fileMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Spawn'
            itemValue: fileSpawn
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Open'
            itemValue: menuOpen
            isVisible: false
          )
         (MenuItem
            enabled: hasFilenameSelectionInCodeView
            label: 'Open selected Filename'
            itemValue: openSelectedFilename
            isVisible: hasFilenameSelectionInCodeView
          )
         (MenuItem
            enabled: hasSelection
            label: 'FileIn'
            itemValue: fileFileIn
          )
         (MenuItem
            enabled: hasSelection
            label: 'FileInTo NameSpace...'
            itemValue: fileFileInToNameSpace
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'New'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Directory...'
                  itemValue: newDirectory
                )
               (MenuItem
                  label: 'File...'
                  itemValue: newFile
                )
               (MenuItem
                  label: 'Hard Link...'
                  itemValue: newHardLink
                )
               (MenuItem
                  label: 'Symbolic Link...'
                  itemValue: newSoftLink
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: hasSelection
            label: 'Remove'
            itemValue: fileRemove
          )
         (MenuItem
            enabled: hasSelection
            label: 'Rename'
            itemValue: fileRename
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Properties...'
            itemValue: fileGetLongInfo
          )
         (MenuItem
            label: '-'
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canAddToClassPath
            label: 'Add to Java ClassPath'
            itemValue: fileAddToJavaClassPath
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canRemoveFromClassPath
            label: 'Remove from Java ClassPath'
            itemValue: fileRemoveFromJavaClassPath
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canAddToSourcePath
            label: 'Add to Java SourcePath'
            itemValue: fileAddToJavaSourcePath
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canRemoveFromSourcePath
            label: 'Remove from Java SourcePath'
            itemValue: fileRemoveFromJavaSourcePath
            isVisible: javaSupportLoaded
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Exit'
            itemValue: menuExit
          )
         )
        nil
        nil
      )
!

helpMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
              (
               (MenuItem
                  label: 'FileBrowser Documentation'
                  itemValue: openHTMLDocument:
                  translateLabel: true
                  argument: 'tools/fbrowser/TOP.html'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About FileBrowser...'
                  itemValue: openAboutThisApplication
                  translateLabel: true
                )
               )
              nil
              nil
            )
!

historyMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#directoryMenuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser directoryMenuSpec)) startUp
    "

    <resource: #programMenu>

    |m|

    "/ add the history items ...

    self directoryHistory size > 0 ifTrue:[
        m := Menu new.

        self directoryHistory do:[:item |
            | dirName |
            dirName := item path.
            m addItem:((MenuItem 
                            label:dirName 
                            itemValue:#changeDirectoryTo:
                            argument:dirName)
                                translateLabel:false).
        ].
    ].

    ^ m

    "Modified: / 17.8.1998 / 10:13:05 / cg"
!

menuPopUp
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileBrowser andSelector:#menuPopUp
     (Menu new fromLiteralArrayEncoding:(FileBrowser menuPopUp)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Spawn'
            itemValue: fileSpawn
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Edit File'
            itemValue: fileGet
          )
         (MenuItem
            enabled: hasSelection
            label: 'Insert File'
            itemValue: fileInsert
          )
         (MenuItem
            enabled: hasSelection
            label: 'FileIn'
            itemValue: fileFileIn
            shortcutKey: Accept
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'New'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Directory...'
                  itemValue: newDirectory
                )
               (MenuItem
                  label: 'File...'
                  itemValue: newFile
                )
               (MenuItem
                  label: 'Hard Link...'
                  itemValue: newHardLink
                )
               (MenuItem
                  label: 'Symbolic Link...'
                  itemValue: newSoftLink
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: hasSelection
            label: 'Remove...'
            itemValue: fileRemove
            shortcutKey: Cut
          )
         (MenuItem
            enabled: hasSelection
            label: 'Rename...'
            itemValue: fileRename
            shortcutKey: Rename
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Properties...'
            itemValue: fileGetLongInfo
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Tools'
            submenuChannel: toolsMenuSpec
            shortcutKey: Ctrl
            keepLinkedMenu: true
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
!

menuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenuChannel: fileMenuSpec
            keepLinkedMenu: true

          )
         (MenuItem
            label: 'Directory'
            translateLabel: true
            submenuChannel: directoryMenuSpec
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Edit'
            translateLabel: true
            submenuChannel: editMenuSpec
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'View'
            translateLabel: true
            submenuChannel: viewMenuSpec
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Tools'
            translateLabel: true
            submenuChannel: toolsMenuSpec
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'CVS'
            translateLabel: true
            submenuChannel: cvsMenuSpec
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            label: 'Help'
            translateLabel: true
            submenuChannel: helpMenuSpec
            keepLinkedMenu: true
          )
         )
        nil
        nil
      )
!

toolsMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#toolsMenuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser toolsMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Unix Command...'
            #translateLabel: true
            #isVisible: #systemIsUnix
            #value: #menuOSCommand
          )
         #(#MenuItem
            #label: 'DOS Command...'
            #translateLabel: true
            #isVisible: #systemIsDOS
            #value: #menuOSCommand
          )
         #(#MenuItem
            #label: 'VMS Command...'
            #translateLabel: true
            #isVisible: #systemIsVMS
            #value: #menuOSCommand
          )
         #(#MenuItem
            #label: 'Shell Terminal'
            #translateLabel: true
            #isVisible: #canDoTerminalAndSystemIsUnix
            #value: #openTerminal
            #enabled: #canDoTerminal
          )
         #(#MenuItem
            #label: 'DOS Terminal'
            #translateLabel: true
            #isVisible: #canDoTerminalAndSystemIsDOS
            #value: #openTerminal
            #enabled: #canDoTerminal
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Changes Browser'
            #translateLabel: true
            #value: #openChangesBrowser
            #enabled: #hasSelection
          )
         #(#MenuItem
            #label: 'Snapshot Image Browser'
            #translateLabel: true
            #value: #openSnapshotImageBrowser
            #enabled: #hasSnapshotSelection
          )
         #(#MenuItem
            #label: 'Create Smalltalk Project'
            #translateLabel: true
            #value: #createProjectAndOpenProjectBrowser
            #enabled: #canCreateNewProject
          )
         #(#MenuItem
            #label: 'Install Autoloaded'
            #translateLabel: true
            #value: #readAbbrevFile
            #enabled: #canReadAbbrevFile
          )
         #(#MenuItem
            #label: 'Install All as Autoloaded'
            #translateLabel: true
            #value: #installAllAsAutoloaded
            #enabled: #anySTFilesPresent
          )
         #(#MenuItem
            #label: 'Editor'
            #translateLabel: true
            #value: #openEditor
            #enabled: #hasSelection
          )
         #(#MenuItem
            #label: 'HTML Reader'
            #translateLabel: true
            #value: #openHTMLReader
            #enabled: #hasSelection
          )
         #(#MenuItem
            #label: 'ASN1 Browser'
            #translateLabel: true
            #isVisible: #hasASN1
            #value: #openASN1Browser
            #enabled: #hasASN1AndSelection
          )
         #(#MenuItem
            #label: 'C Browser'
            #translateLabel: true
            #isVisible: #hasCBrowser
            #value: #openCBrowser
            #enabled: #hasCBrowser
          )
         #(#MenuItem
            #label: 'Applet Viewer'
            #translateLabel: true
            #isVisible: #hasJava
            #value: #openAppletViewer
            #enabled: #hasJavaAndSelection
          )
         #(#MenuItem
            #label: 'Image Inspector'
            #translateLabel: true
            #value: #openImageInspector
            #enabled: #hasSelection
          )
         #(#MenuItem
            #label: 'Image'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Image Inspector'
                  #translateLabel: true
                  #value: #openImageInspector
                  #enabled: #hasSelection
                )
               #(#MenuItem
                  #label: 'Image Preview'
                  #translateLabel: true
                  #value: #openImagePreview
                  #enabled: #hasSelection
                )
               #(#MenuItem
                  #label: 'Image Editor'
                  #translateLabel: true
                  #value: #openImageEditor
                  #enabled: #hasSelection
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'Convert to GIF'
                  #value: #convertImageToGIF
                  #enabled: #hasSelection
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: 'MP3 Player'
            #translateLabel: true
            #isVisible: #hasMP3Player
            #value: #openMP3Player
            #enabled: #hasMP3PlayerAndSelection
          )
         #(#MenuItem
            #label: 'ZipFile Tool'
            #translateLabel: true
            #value: #openZipTool
            #enabled: #hasZipFileSelectedHolder
          )
         #(#MenuItem
            #label: 'SlideShow'
            #translateLabel: true
            #isVisible: #hasSlideShow
            #value: #openSlideShow
          )
         #(#MenuItem
            #label: 'File Differences...'
            #translateLabel: true
            #value: #openDiffView
          )
         #(#MenuItem
            #label: 'Find'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Find Duplicate Files'
                  #translateLabel: true
                  #value: #fileFindDuplicates
                )
               #(#MenuItem
                  #label: 'Find All Duplicate Files (Recursive)'
                  #translateLabel: true
                  #value: #fileFindAllDuplicates
                )
               #(#MenuItem
                  #label: 'Find a File...'
                  #translateLabel: true
                  #value: #fileFindFile
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: 'Hex Dump'
            #translateLabel: true
            #value: #fileHexDump
            #enabled: #hasSelection
          )
         )
        nil
        nil
      )

    "Modified: / 14-02-2011 / 17:17:33 / cg"
!

viewMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileBrowser andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(FileBrowser menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
              (
               (MenuItem
                  label: 'Show Details'
                  translateLabel: true
                  indication: showingDetails
                )
               (MenuItem
                  enabled: showingDetails
                  label: 'Show Time && Date'
                  translateLabel: true
                  indication: showingTimeAndDate
                )
               (MenuItem
                  label: 'Show Hidden Files'
                  translateLabel: true
                  indication: showingHiddenFiles
                )
               (MenuItem
                  label: 'Show Big Image Preview'
                  translateLabel: true
                  indication: showingBigImagePreview
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Sort by Name'
                  translateLabel: true
                  choice: sortByWhat
                  choiceValue: name
                )
               (MenuItem
                  label: 'Sort by Type'
                  translateLabel: true
                  choice: sortByWhat
                  choiceValue: type
                )
               (MenuItem
                  label: 'Sort by Time'
                  translateLabel: true
                  choice: sortByWhat
                  choiceValue: time
                )
               (MenuItem
                  label: 'Ignore Case in Sort'
                  translateLabel: true
                  indication: sortCaseless
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Encoding...'
                  itemValue: fileEncoding
                  translateLabel: true
                )
               (MenuItem
                  label: 'DOS EndOfLine Mode'
                  translateLabel: true
                  indication: dosEOLMode
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Update'
                  itemValue: updateCurrentDirectory
                  translateLabel: true
                )
               (MenuItem
                  label: 'AutoUpdate'
                  translateLabel: true
                  indication: autoUpdate
                )
               )
              nil
              nil
            )
!

visitedFileMenuSpec

    <resource: #programMenu>

    |m|

    VisitedFileHistory size == 0 ifTrue:[^ nil].

    m := Menu new.

    "/ add the history items ...

    VisitedFileHistory do:[:pathName |
        m addItem:((MenuItem 
                        label:pathName asFilename baseName 
                        itemValue:#revisitFile:)
                            argument:pathName;
                            yourself).
    ].
    ^ m
! !

!FileBrowser class methodsFor:'queries'!

isVisualStartable
    "return true, if this application can be started via #open.
     (to allow start of a change browser via double-click in the browser)"

    ^ true
! !

!FileBrowser methodsFor:'aspects'!

anyFilesPresentWithSuffix:suffix
    ^ currentDirectory notNil
      and:[currentDirectory exists
      and:[currentDirectory directoryContents contains:[:f| f asFilename suffix = suffix]]]
!

anySTFilesPresent
    ^ self anyFilesPresentWithSuffix:'st'
!

autoUpdate
    ^ doAutoUpdate

    "Created: / 6.5.1999 / 11:37:25 / cg"
    "Modified: / 6.5.1999 / 11:39:38 / cg"
!

canAddToClassPath
    ^ [ |f|

        (Java isNil or:[Java isLoaded not]) ifTrue:[
            false
        ] ifFalse:[
            f := self singleSelectedFileOrCurrentDirectory.
            f notNil
            and:[(Java classPath includes:f pathName) not
            and:[f isDirectory
                 or:[(f hasSuffix:'jar')
                 or:[(f hasSuffix:'zip')]]]].
        ]
      ]

    "Modified: / 1.2.1999 / 20:38:42 / cg"
!

canAddToSourcePath
    ^ [ |f|

        (Java isNil or:[Java isLoaded not]) ifTrue:[
            false
        ] ifFalse:[
            f := self singleSelectedFileOrCurrentDirectory.
            f notNil
            and:[(Java sourcePath isNil
                 or:[(Java sourcePath includes:f pathName) not])
            and:[f isDirectory
                 or:[(f hasSuffix:'jar')
                 or:[(f hasSuffix:'zip')]]]].
        ]
      ]

    "Modified: / 1.2.1999 / 20:38:42 / cg"
!

canCreateNewProject
    ^ [ 
        currentDirectory notNil
        and:[(self anyFilesPresentWithSuffix:'prj') not
        and:[(self anyFilesPresentWithSuffix:'st')]]
      ]
!

canDoTerminal
    ^ OperatingSystem isUNIXlike
      or:[OperatingSystem isMSWINDOWSlike]

    "Created: / 4.8.1998 / 13:37:13 / cg"
    "Modified: / 28.4.1999 / 11:54:17 / cg"
!

canDoTerminalAndSystemIsDOS
    ^ self canDoTerminal and:[OperatingSystem isMSWINDOWSlike]

    "Created: / 10.11.2001 / 13:10:32 / cg"
!

canDoTerminalAndSystemIsUnix
    ^ self canDoTerminal and:[OperatingSystem isUNIXlike]

    "Created: / 10.11.2001 / 13:10:46 / cg"
!

canReadAbbrevFile
    ^ [|sel f fn suff ok|

        sel := fileListView selection.
        sel size == 1 ifTrue:[
            f := fileList at:sel first ifAbsent:nil.
            ok := (f = 'abbrev.stc').
        ].
        ok ifFalse:[
            ok := currentDirectory notNil
                  and:[(currentDirectory construct:'abbrev.stc') exists].
        ].
        ok
      ]

    "Modified: / 30.1.1999 / 19:05:59 / cg"
    "Created: / 29.1.2000 / 13:00:57 / cg"
!

canRemoveCVSContainer
    ^ [ |cvsDir|

        currentDirectory notNil
        and:[fileListView selection size > 0
        and:[(cvsDir := currentDirectory construct:'CVS') exists
        and:[cvsDir isDirectory]]]]
!

canRemoveFromClassPath
    ^ [ |f|

        (Java isNil or:[Java isLoaded not]) ifTrue:[
            false
        ] ifFalse:[
            f := self singleSelectedFileOrCurrentDirectory.
            f notNil
            and:[(Java classPath includes:f pathName)
            and:[f isDirectory
                 or:[(f hasSuffix:'jar')
                 or:[(f hasSuffix:'zip')]]]]
          ]
      ]

    "Modified: / 1.2.1999 / 20:39:25 / cg"
!

canRemoveFromSourcePath
    ^ [ |f|

        (Java isNil or:[Java isLoaded not]) ifTrue:[
            false
        ] ifFalse:[
            f := self singleSelectedFileOrCurrentDirectory.
            f notNil
            and:[(Java sourcePath isNil
                 or:[(Java sourcePath includes:f pathName)])
            and:[f isDirectory
                 or:[(f hasSuffix:'jar')
                 or:[(f hasSuffix:'zip')]]]]
          ]
      ]

    "Modified: / 1.2.1999 / 20:39:25 / cg"
!

currentDirectoryIsNotTop
    ^ [currentDirectory notNil and:[currentDirectory isRootDirectory not]]

    "Modified: / 4.8.1998 / 14:10:57 / cg"
    "Created: / 14.8.1998 / 12:07:10 / cg"
!

directoryHistory

    ^ self class directoryHistory
!

dosEOLMode
    ^ dosEOLMode

    "Created: / 6.5.1999 / 11:37:25 / cg"
    "Modified: / 6.5.1999 / 11:39:38 / cg"
!

hasASN1
    ^ [ OSI::ASN1Parser notNil 
        and:[OSI::ASN1Parser isLoaded]]

!

hasASN1AndSelection
    ^ [ fileListView selection size > 0
        and:[OSI::ASN1Parser notNil 
        and:[OSI::ASN1Parser isLoaded]]]
!

hasBookmarks
    ^ AbstractFileBrowser hasBookmarks

    "Created: / 14.8.1998 / 19:17:02 / cg"
    "Modified: / 14.8.1998 / 19:17:17 / cg"
!

hasBookmarksToRemove
    |bookmarks|

    bookmarks := self class directoryBookmarks.
    ^ bookmarks size > 0
      and:[ bookmarks includes:(currentDirectory pathName) ]

    "Created: / 14.8.1998 / 19:17:02 / cg"
    "Modified: / 14.8.1998 / 19:17:17 / cg"
!

hasCBrowser
    ^ [ CBrowser::Browser notNil ]
!

hasFilenameSelectionInCodeView
    ^ [ |val sel|

        val := false.
        sel := subView selection.
        sel notNil ifTrue:[
            sel := sel asString withoutSeparators.
            sel asFilename exists ifTrue:[
                val := sel asFilename isReadable
            ]
        ].
        val
    ]

    "Created: / 4.2.1999 / 17:34:57 / cg"
    "Modified: / 4.2.1999 / 17:39:32 / cg"
!

hasJava
    ^ [ JavaClassReader notNil 
        and:[JavaClassReader isLoaded]]

    "Modified: / 17.10.1998 / 16:57:14 / cg"
    "Created: / 17.10.1998 / 22:58:25 / cg"
!

hasJavaAndSelection
    ^ [ fileListView selection size > 0
        and:[JavaClassReader notNil 
        and:[JavaClassReader isLoaded]]]

    "Modified: / 17.10.1998 / 16:57:14 / cg"
    "Created: / 17.10.1998 / 22:58:03 / cg"
!

hasMD5
    ^ [ MD5Stream notNil and:[MD5Stream isLoaded]]
!

hasMP3Player
    ^ [ MP3PlayerApplication notNil
        or:[SaugFix::MP3PlayerApplication notNil ]]
!

hasMP3PlayerAndSelection
    ^ [ fileListView selection size > 0
        and:[ self hasMP3Player value]]
!

hasSelection
    ^ [fileListView selection size > 0]

    "Created: / 4.8.1998 / 14:10:31 / cg"
    "Modified: / 4.8.1998 / 14:10:57 / cg"
!

hasSnapshotSelection
    ^ [ |fn|

        (fileListView selection size == 1)
        and:[ ((fn := fileListView selectionValue first string withoutSeparators asFilename) hasSuffix:'img')
              or:[fn hasSuffix:'sav'] ]
      ]

    "Created: / 4.8.1998 / 14:10:31 / cg"
    "Modified: / 4.8.1998 / 14:10:57 / cg"
!

hasVisitHistory
    ^ [self directoryHistory size > 0]

    "Created: / 14.8.1998 / 19:17:02 / cg"
    "Modified: / 14.8.1998 / 19:17:17 / cg"
!

hasZipFileSelected
    |sel fileName suff|

    sel := fileListView selectionValue.
    sel size == 1 ifFalse:[^ false].

    fileName := sel first.
    fileName isNil ifTrue:[^ false].
    fileName := fileName string withoutSeparators asFilename.

    suff := fileName suffix asLowercase.
    (suff = 'zip' or:[suff = 'jar']) ifTrue:[^ true].

    ^ fileName mimeTypeOfContents = 'application/x-zip-compressed'

    "Modified: / 14-02-2011 / 17:21:37 / cg"
!

hasZipFileSelectedHolder
    ^ [ self hasZipFileSelected ]

    "Created: / 14-02-2011 / 17:21:18 / cg"
!

javaSupportLoaded
    ^ [ JavaClassReader notNil 
        and:[JavaClassReader isLoaded]]

    "Created: / 9.11.1998 / 05:33:17 / cg"
!

showingBigImagePreview
    ^ showingBigImagePreview

    "Created: / 14.8.1998 / 14:15:44 / cg"
!

showingDetails
    ^ showingDetails

    "Created: / 14.8.1998 / 14:15:15 / cg"
!

showingHiddenFiles
    ^ showingHiddenFiles

    "Created: / 14.8.1998 / 14:15:44 / cg"
!

showingTimeAndDate
    ^ showingTimeAndDate

    "Created: / 14.8.1998 / 14:15:44 / cg"
!

singleSelectedFile
    |f sel|

    sel := fileListView selection.
    sel size ~~ 1 ifTrue:[
        ^ nil
    ].
    f := fileList at:sel first ifAbsent:nil.
    f notNil ifTrue:[
        ^ currentDirectory construct:f
    ].
    ^ nil

    "Created: / 29.1.2000 / 13:09:09 / cg"
!

singleSelectedFileOrCurrentDirectory
    |f sel|

    sel := fileListView selection.
    sel size > 1 ifTrue:[
        ^ nil
    ].
    sel size == 0 ifTrue:[
        ^ currentDirectory
    ].
    f := fileList at:sel first ifAbsent:nil.
    f notNil ifTrue:[
        ^ currentDirectory construct:f
    ].
    ^ nil
!

sortByWhat
    ^ sortByWhat

    "Created: / 14.8.1998 / 15:55:18 / cg"
    "Modified: / 14.8.1998 / 15:56:08 / cg"
!

sortCaseless
    ^ sortCaseless

    "Created: / 14.8.1998 / 14:21:21 / cg"
!

systemIsDOS
    ^ OperatingSystem isMSDOSlike

    "Created: / 4.8.1998 / 13:37:28 / cg"
!

systemIsUnix
    ^ OperatingSystem isUNIXlike

    "Created: / 4.8.1998 / 13:37:13 / cg"
!

systemIsVMS
    ^ OperatingSystem isVMSlike

    "Created: / 4.8.1998 / 13:37:37 / cg"
! !

!FileBrowser methodsFor:'drag & drop'!

canDropObjects:aCollectionOfDropObjects
    "I accept file- and textObjects only"

    ^ (aCollectionOfDropObjects 
        conform:[:aDropObject | (aDropObject isFileObject or:[aDropObject isTextObject])])

    "Created: / 13-10-2006 / 16:00:49 / cg"
!

dropObjects:aCollectionOfDropObjects at:aPoint
    "handle drops"

    "/ for now ... only allow single drop
    aCollectionOfDropObjects size > 1 ifTrue:[
        (self confirm:'Drop the last file only ?') ifFalse:[
            ^ self
        ].
        self dropSingleObject:aCollectionOfDropObjects first at:aPoint.
        ^ self
    ].

    aCollectionOfDropObjects do:[:aDropObject |
        self dropSingleObject:aDropObject at:aPoint
    ]

    "Created: / 13-10-2006 / 16:01:00 / cg"
!

dropSingleObject:someObject at:aPoint
    "handle drops; if its a directory, change to it.
     If its a file, change to its directory and select the file.
     If its text, paste it into the codeView."

    |newDir newFile realObject|

    realObject := someObject theObject.

    someObject isFileObject ifTrue:[
        someObject isDirectory ifTrue:[
            newDir := realObject pathName.
        ] ifFalse:[
            newDir := realObject directoryName.
            newFile := realObject baseName.
        ].

        newDir notNil ifTrue:[
            newDir ~= currentDirectory pathName ifTrue:[
                self changeDirectoryTo:newDir.
            ]
        ].
        newFile notNil ifTrue:[
            newFile ~= currentFileName ifTrue:[
                fileListView selection:(fileList indexOf:newFile).
                self doFileGet:false.
            ]
        ].
        ^ self
    ].

    someObject isTextObject ifTrue:[
        subView paste:realObject.
        ^ self
    ].

    "Modified: 6.4.1997 / 14:46:44 / cg"
! !

!FileBrowser methodsFor:'events'!

handlesKeyPress:key inView:view
    "this method is reached via delegation: are we prepared to handle
     a keyPress in some other view ?"

    <resource: #keyboard (#GotoLine #InspectIt #CmdI #Cmdu 
                          #DoIt #Delete #BackSpace #Accept #CmdF #CmdD
                          #CursorLeft #CursorRight
                         )>

    view == fileListView ifTrue:[
        (key == #Delete 
        or:[key == #BackSpace
        or:[key == #Accept
        or:[key == #CmdI
        or:[key == #CmdF
        or:[key == #CmdD
        or:[key == #Cmdu
        or:[key == #Cut
        or:[key == #Rename
        or:[key == #InspectIt
        or:[key == #GotoLine
        or:[key == #CursorLeft
        or:[key == #CursorRight
        or:[key == #DoIt]]]]]]]]]]]]]) ifTrue:[^ true].
    ].
    ^ false

    "Created: / 28.1.1997 / 14:03:20 / stefan"
    "Modified: / 20.6.1997 / 16:35:01 / cg"
    "Modified: / 16.1.1998 / 16:50:39 / stefan"
!

keyPress:key x:x y:y view:view
    "this method is reached via delegation from the fileListView"

    <resource: #keyboard (#GotoLine #InspectIt  
                          #CmdI #Cmdu #DoIt #Delete #BackSpace #Accept
                          #Cmdr #Cut #CursorLeft #CursorRight)>

    (key == #Delete 
    or:[key == #Cut
    or:[key == #BackSpace]]) ifTrue:[
        self fileRemove.
        ^ self
    ].
    "/ cg: removed; too dangerous, because it depends on which view has
    "/ the focus - in the codeView, it is a save; in the list, it is a fileIn.
    "/ this is confusing to newcomers.
    "/    (key == #Accept) ifTrue:[
    "/        self fileFileIn.
    "/        ^ self
    "/    ].
    (key == #GotoLine) ifTrue:[
        self fileGet.
        ^ self
    ].
    (key == #DoIt) ifTrue:[
        self fileExecute.
        ^ self
    ].
    (key == #InspectIt) ifTrue:[
        self fileGetInfo.
        ^ self
    ].
    (key == #CmdI) ifTrue:[
        self fileGetLongInfo.
        ^ self
    ].
    (key == #Cmdu) ifTrue:[
        self updateCurrentDirectory.
        ^ self
    ].
    (key == #CmdF) ifTrue:[
        self newFile.
        ^ self
    ].
    (key == #CmdD) ifTrue:[
        self newDirectory.
        ^ self
    ].
    (key == #Rename) ifTrue:[
        self fileRename.
        ^ self
    ].
    (key == #CursorLeft) ifTrue:[
        self changeToParentDirectory.
        ^ self
    ].
    (key == #CursorRight) ifTrue:[
        self changeToPreviousDirectory.
        ^ self
    ].
    fileListView keyPress:key x:x y:y

    "Created: / 28.1.1997 / 14:03:56 / stefan"
    "Modified: / 20.6.1997 / 16:35:08 / cg"
    "Modified: / 16.1.1998 / 16:51:38 / stefan"
!

mapped 
    super mapped.
    "
     whant to know about changed history
    "
    self updateCurrentDirectory
!

visibilityChange:how
    |wasVisible|

    wasVisible := shown.
    super visibilityChange:how.
    (wasVisible not and:[shown]) ifTrue:[
        "
         start checking again
        "
        self scheduleCheckBlock.
    ]

    "Modified: / 18.2.1998 / 17:57:44 / cg"
! !

!FileBrowser methodsFor:'fileList user interaction'!

bigImagePreviewSettingChanged
    "invoked, when big image preview flag changed"

    |fh|

    (showingBigImagePreview value == true 
    and:[showingDetails value == true]) ifTrue:[
        fh := fileListView font height.
        fileListView lineSpacing:(34 - fh max:0).
    ] ifFalse:[
        fileListView clearView.
        self updateCurrentDirectory.
        fileListView lineSpacing:2.
    ].
    fileListView clearView.
    self updateCurrentDirectory

    "Modified: / 4.8.1998 / 13:43:54 / cg"
    "Created: / 14.8.1998 / 14:17:49 / cg"
!

changeDisplayMode
    "toggle from long to short listing (and vice-versa)"

    showingDetails value:(showingDetails value not).
    "/ showLongList := showLongList not.
    self showOrHideTabView.
    self updateCurrentDirectory

    "Modified: / 4.8.1998 / 13:43:54 / cg"
!

changeDotFileVisibility
    "turn on/off visibility of files whose name starts with '.'"

    showingHiddenFiles value:(showingHiddenFiles value not).
    "/ showDotFiles := showDotFiles not.
    self updateCurrentDirectory

    "Modified: / 4.8.1998 / 13:45:46 / cg"
!

confirmAndRemove:fileNames
    "remove fileNames with user confirmation.
     TODO: Should be enhanced, to look for a ~/.trash directory 
           and move files there if it exists (without asking in this case)."

    |q doRemove|

    "/ do not ask, if shift is pressed
    fileNames size > 1 ifTrue:[
        q := resources string:'Remove %1 selected files ?' with:(fileNames size).
        doRemove := Dialog 
                        confirmWithCancel:q
                        labels:(resources array:#('Cancel' 'Confirm Each' 'Remove'))
                        values:#(false #confirm true)
                        default:3.
        doRemove isNil ifTrue:[^ self].
        doRemove == #confirm ifTrue:[
            fileNames do:[:eachFileName |
                self confirmAndRemove:(Array with:eachFileName).
            ].
            ^ self.
        ].
    ] ifFalse:[
        q := resources string:'Remove ''%1'' ?' with:(fileNames first allBold).
        doRemove := self ask:q yesButton:'Remove'.
    ].

    doRemove ifTrue:[
        self doRemove:fileNames
    ]
!

convertImageToGIF
    |img path tempFileXPM tempFilePPM tempFileGIF|

    self selectedFilesDo:[:fileName |
        path := currentDirectory filenameFor:fileName.
        path isDirectory ifFalse:[
            img := Image fromFile:(path pathName).
            img notNil ifTrue:[
                tempFileXPM  := Filename newTemporary withSuffix:'xpm'.
                tempFilePPM := tempFileXPM withSuffix:'ppm'.
                tempFileGIF := tempFileXPM withSuffix:'gif'.
                [
                    img saveOn:tempFileXPM using:XPMReader.

                    
                    (OperatingSystem 
                            executeCommand:('xpmtoppm %1 > %2' 
                                                bindWith:tempFileXPM pathName
                                                with:tempFilePPM pathName))
                    ifFalse:[
                        self warn:'Cannot convert to ppm format'.
                    ] ifTrue:[
                        (OperatingSystem 
                                executeCommand:('ppmtogif %1 > %2' 
                                                    bindWith:tempFilePPM pathName
                                                    with:tempFileGIF pathName))
                        ifFalse:[
                            self warn:'Cannot convert to gif format'.
                        ] ifTrue:[
                            tempFileGIF moveTo:(path withSuffix:'gif').
                        ].
                    ].
                ] ensure:[
                    tempFileXPM delete.
                    tempFilePPM delete.
                    tempFileGIF delete.
                ]
            ] ifFalse:[
                self warn:'Unknown format/not an image: ' , fileName
            ]
        ]
    ].
!

detailsSettingChanged
    "invoked, when detail (i.e. long / short) listing flag changed"

    self showOrHideTabView.
    self bigImagePreviewSettingChanged

    "Modified: / 4.8.1998 / 13:43:54 / cg"
    "Created: / 14.8.1998 / 14:17:49 / cg"
!

fileDoubleClick:lineNr
    "double click on a file - get its contents"

    self fileSelect:lineNr.
    self fileGet:true
!

fileEncoding
    "open a dialog to allow change of the file's character encoding.
     Files are converted to internal encoding when read, and converted back
     to this encoding when saved.
     The default encoding is nil, which means that files are already in
     the internal encoding (which is iso8859).
     Notice: currently, not too many encodings are supported by the system."

    |dialog list descr encodings encodingNames idx|

    list := SelectionInList new.

    descr := CharacterEncoder supportedExternalEncodings.
    encodings := descr collect:[:d | d first].
    encodingNames := descr collect:[:d | d second].

    list list:encodingNames.
    list selectionIndex:(encodings indexOf:fileEncoding ifAbsent:1).

    dialog := Dialog new.

    dialog addTextLabel:(resources stringWithCRs:'Specify the files encoding.\\The default (a 1-to-1 encoding) works for 7bit ascii\and iso8859 (= ANSI) encoded text files.\').

    dialog addVerticalSpace.
    dialog addListBoxOn:list withNumberOfLines:5.

    dialog addAbortAndOkButtons.
    dialog open.

    dialog accepted ifTrue:[
        idx := list selectionIndex.
        fileEncoding := encodings at:idx.
        subView externalEncoding:fileEncoding.
        subView validateFontEncodingFor:fileEncoding ask:true.
    ].

    "Modified: 30.6.1997 / 14:41:12 / cg"
!

fileExecute
    "if text was modified show a queryBox,
     otherwise pop up execute box immediately"

    |action sel fileName|

    "
     this replaces everything by the commands output ...
    "
    action := [:command | 
                self class addToCommandHistory:command for:fileName.
                self doExecuteCommand:command replace:true
              ].

    (self askIfModified:'Contents has not been saved.\\Modifications will be lost when command is executed.'
              yesButton:'Execute') ifFalse:[^ self].

"/    "
"/     this inserts the commands output ...
"/    "
"/    action := [:command| self doExecuteCommand:command replace:false].
"/

    sel := fileListView selection.
    sel size == 1 ifTrue:[
        fileName := fileList at:sel first
    ].
    self askForCommandFor:fileName thenDo:action

    "Modified: 14.11.1996 / 14:59:34 / cg"
!

fileFileIn
    "fileIn the selected file(s)"

    self fileFileInLazy:false 
!

fileFileIn:fileName lazy:lazy
    "fileIn fileName"

    |aStream path wasLazy prevCurrentFileName dontAskSignals|

    path := currentDirectory filenameFor:fileName.
    path isRegularFile ifFalse:[
        ^ self.
    ].

    [
        prevCurrentFileName := currentFileInFileName.
        currentFileInFileName := fileName.

        (ObjectFileLoader notNil
        and:[ObjectFileLoader hasValidBinaryExtension:fileName]) ifTrue:[
            AbortOperationRequest catch:[
                |p|

                "/
                "/ look if already loaded ...  then unload first
                "/
                p := path pathName.
                (ObjectFileLoader loadedObjectFiles includes:p) ifTrue:[
                    (Dialog confirm:(resources 
                                        string:'%1 is already loaded; load anyway ?'
                                        with:p)) ifFalse:[
                        ^ self
                    ].
                    Transcript showCR:'unloading old ' , p , ' ...'.
                    ObjectFileLoader unloadObjectFile:p. 
                ].

                Transcript showCR:'loading ' , p , ' ...'.
                (ObjectFileLoader loadObjectFile:p) isNil ifTrue:[
                    Transcript showCR:'Error: could not load ' , p.
                ] ifFalse:[
                    Class addInfoRecord:('fileIn ' , fileName).
                ].
            ]
        ] ifFalse:[ ((path hasSuffix:'cls') 
                     and:[((path mimeTypeOfContents ? '') startsWith:'application/x-smalltalk-source') not ]) ifTrue:[
            "/ loading a binary class file
            aStream := path readStreamOrNil.
            aStream notNil ifTrue:[
                aStream fileInBinary.
            ]
        ] ifFalse:[
            ((path hasSuffix:'class')
              or:[(path hasSuffix:'cla')]) ifTrue:[
                "/ loading a java class file
                JavaClassReader notNil ifTrue:[
                    JavaClassReader loadFile:path
                ]
            ] ifFalse:[ (path hasSuffix:'sif') ifTrue:[
                "/ loading a sif (smalltalk interchange format) file
                SmalltalkInterchangeSTXFileInManager autoload.    
                SmalltalkInterchangeFileManager newForFileIn
                    fileName: path pathName;
                    fileIn.
            ] ifFalse:[ (path hasSuffix:'js') ifTrue:[
                "/ loading a javaScript file
                JavaScriptSourceReader new fileIn:path.
            ] ifFalse:[ (path hasSuffix:'pcl') ifTrue:[
                Parcel isNil ifTrue:[
                    self warn:'Parcel support not loaded.'
                ] ifFalse:[
                    Parcel loadParcelFrom: path pathName
                ]
            ] ifFalse:[
                "/ loading a regular (chunk) or xml source file
                aStream := path readStreamOrNil.
                aStream notNil ifTrue:[
                    [
                        Class withoutUpdatingChangesDo:[
                            wasLazy := Compiler compileLazy:lazy.
                            aStream fileIn.
                        ].
                        Class addInfoRecord:('fileIn ' , fileName) 
                    ] ensure:[
                        Compiler compileLazy:wasLazy.
                        aStream close
                    ]
                ]
            ]]]]
        ]]
    ] on:Error, HaltInterrupt, Class packageRedefinitionNotification do:[:ex| 
        |sig msg label labels values action proceedValue isRedef|

        isRedef := false.
        sig := ex creator.
        sig == Class methodRedefinitionNotification ifTrue:[
            msg := 'trying to overwrite method:\\    ' , ex oldMethod whoString , '\\in package ''' 
                   , ex oldPackage , ''' with method from package ''' , ex newPackage , ''''.
            label := 'Method redefinition in fileIn'.
            isRedef := true.
        ] ifFalse:[sig == Class classRedefinitionNotification ifTrue:[
            msg := 'trying to redefine class: ' , ex oldClass name allBold , '\\in package ''' 
                   , ex oldPackage , ''' with new definition from package ''' , ex newPackage , ''''.
            label := 'Class redefinition in fileIn'.
            isRedef := true.
        ] ifFalse:[sig == HaltInterrupt ifTrue:[ |sender|
            label := 'Breakpoint/Halt in fileIn'.
            sender := ex suspendedContext.
            msg := msg , '\\in ' , sender receiver class name , '>>' , sender selector
        ] ifFalse:[
            label := 'Error in fileIn'.
            msg := 'error in fileIn: %1'
        ]]].

        msg := msg bindWith:ex description.

        isRedef ifTrue:[
              labels := #('Cancel' 'Skip' 'Debug' 'Continue' 'ContinueForAll').
              values := #(abort     skip  debug   continue   continueForAll).
        ] ifFalse:[
              labels := #('Cancel' 'Skip' 'Debug' 'Continue').
              values := #(abort    skip   debug   continue).
        ].

        AbortAllOperationWantedQuery query ifTrue:[
              labels := #('Cancel All') , labels.
              values := #(cancelAll) , values.
        ].

        action := OptionBox 
                      request:(msg withCRs) 
                      label:label
                      image:(WarningBox iconBitmap)
                      buttonLabels:labels
                      values:values
                      default:#continue
                      onCancel:#abort.

        action == #continueForAll ifTrue:[
            dontAskSignals isNil ifTrue:[
                dontAskSignals := IdentityDictionary new.
            ].
            dontAskSignals at:sig put:#continue.
            action := #continue.
        ].

        action == #continue ifTrue:[
            ex proceedWith:(isRedef ifTrue:[#keep] ifFalse:[#continue]).
        ].
        action == #abort ifTrue:[
            AbortOperationRequest raise.
            ex return
        ].
        action == #cancelAll ifTrue:[
            AbortAllOperationRequest raise.
            ex return
        ].
        action == #skip ifTrue:[
            ex proceedWith:nil
        ].
        action == #debug ifTrue:[
            Debugger enter:ex returnableSuspendedContext 
                     withMessage:ex description 
                     mayProceed:true.
            ex proceedWith:nil. "skip this change"
        ].
        ex reject
    ].
    currentFileInFileName := prevCurrentFileName

    "Modified: / 19-09-1997 / 23:42:22 / stefan"
    "Modified: / 09-02-2011 / 13:53:41 / cg"
!

fileFileInLazy
    "fileIn the selected file(s). Do a quick load (no compilation)"

    self fileFileInLazy:true 
!

fileFileInLazy:lazy
    "fileIn the selected file(s)"


    fileListView selection size > 1 ifTrue:[
        AbortAllOperationRequest catch:[
            self selectedFilesDo:[:fileName |
                AbortOperationRequest catch:[
                    self fileFileIn:fileName lazy:lazy.
                ]
            ]
        ].
        ^ self.
    ].

    self selectedFilesDo:[:fileName |
        self fileFileIn:fileName lazy:lazy.
    ]

    "Modified: / 19.9.1997 / 23:42:22 / stefan"
    "Modified: / 16.11.2001 / 17:38:34 / cg"
!

fileFileInToNameSpace
    "fileIn the selected file(s)<into a nameSpace"

    |ns listOfKnownNameSpaces|

    listOfKnownNameSpaces := Set new.
    NameSpace 
        allNameSpaces 
            do:[:eachNameSpace | 
                listOfKnownNameSpaces add:eachNameSpace name
            ].
    listOfKnownNameSpaces := listOfKnownNameSpaces asOrderedCollection sort.

    ns := Dialog 
                request:'During fileIn, new classes are created in nameSpace:'
                initialAnswer:(lastEnforcedNameSpace ? LastEnforcedNameSpace ? Class nameSpaceQuerySignal query name)
                list:listOfKnownNameSpaces.
    ns isEmptyOrNil ifTrue:[^ self].

    LastEnforcedNameSpace := lastEnforcedNameSpace := ns.
    ns := NameSpace name:ns.

    Class nameSpaceQuerySignal 
        answer:ns
        do:[ self fileFileInLazy:false ] 
!

fileFindAllDuplicates
    "scan directory and all subdirs for duplicate files"

    |fileNames dir infoDir filesBySize
     result info dirPrefix|

    (self askIfModified:'contents has not been saved.\\Modifications will be lost when you proceed.'
              yesButton:'proceed') ifFalse:[^ self].

    self withWaitCursorDo:[
        result := Dictionary new.

        dir := currentDirectory asFilename.
        self label:myName , '- gathering file names ...'.
        fileNames := dir recursiveDirectoryContentsAsFilenames reject:[:fn | fn isDirectory ].

        self label:myName , '- gathering sizes ...'.
        infoDir := Dictionary new.
        fileNames do:[:fn |
            infoDir at:fn put:(fn fileSize)
        ].

        "/ for each, get the file's size.
        "/ in a first pass, look for files of the same size and
        "/ compare them ...

        self label:myName , '- preselect possible duplicates ...'.
        filesBySize := Dictionary new.
        infoDir keysAndValuesDo:[:fn :sz |
            |entry|

            entry := filesBySize at:sz ifAbsentPut:[Set new].
            entry add:fn.
        ].

        "/ any of same size ?

        self label:myName , '- checking for duplicates ...'.
        filesBySize do:[:entry |
            |files|

            entry size > 1 ifTrue:[
                files := entry asArray.
                1 to:files size-1 do:[:idx1 |
                    idx1+1 to:files size do:[:idx2 |
                        |fn1 fn2|

                        fn1 := files at:idx1.
                        fn2 := files at:idx2.

"/                        self label:myName , '- checking ' , fn1 baseName , ' vs. ' , fn2 baseName , ' ...'.
                        (result at:fn2 ifAbsent:nil) ~= fn1 ifTrue:[
                            "/ compare the files
                            (fn1 sameContentsAs:fn2) ifTrue:[
"/                                Transcript show:'Same: '; show:fn1 baseName; show:' and '; showCR:fn2 baseName.
                                result at:fn1 put:fn2.
                            ]
                        ]
                    ]
                ]
            ]
        ].

        self label:myName , '- sorting ...'.
        dirPrefix := currentDirectory asFilename pathName.
        result := result associations.
        result := result collect:[:assoc |
                                        |f1 f2|

                                        f1 := assoc key name.
                                        f2 := assoc value name.
                                        (f1 startsWith:dirPrefix) ifTrue:[
                                            f1 := f1 copyFrom:dirPrefix size + 2.
                                        ].
                                        (f2 startsWith:dirPrefix) ifTrue:[
                                            f2 := f2 copyFrom:dirPrefix size + 2.
                                        ].
                                        f1 < f2 ifTrue:[
                                            f2 -> f1
                                        ] ifFalse:[
                                            f1 -> f2
                                        ]
                                ].
        result sort:[:f1 :f2 | f2 value < f1 value].

        info := OrderedCollection new.
        result do:[:assoc |
            info add:(assoc key , ' same as ' , assoc value)
        ].
        info isEmpty ifTrue:[
            info := 'No duplicate files found.'
        ].
    ].

    subView contents:info.
    self label:myName.

    "Created: / 28.11.1998 / 17:47:53 / cg"
    "Modified: / 10.12.1998 / 17:13:14 / cg"
!

fileFindDuplicates
    "scan directory for duplicate files"

    |fileNames dir infoDir filesBySize
     result info|

    (self askIfModified:'contents has not been saved.\\Modifications will be lost when you proceed.'
              yesButton:'Proceed') ifFalse:[^ self].

    self withWaitCursorDo:[
        result := Dictionary new.

        dir := currentDirectory asFilename.
        fileNames := dir directoryContentsAsFilenames reject:[:fn | fn isDirectory ].

        infoDir := Dictionary new.
        fileNames do:[:fn |
            infoDir at:fn put:(fn info)
        ].

        "/ for each, get the file's size.
        "/ in a first pass, look for files of the same size and
        "/ compare them ...

        filesBySize := Dictionary new.
        infoDir keysAndValuesDo:[:fn :info |
            |sz entry|

            sz := info size.
            entry := filesBySize at:sz ifAbsentPut:[Set new].
            entry add:fn.
        ].

        "/ any of same size ?

        filesBySize do:[:entry |
            |files|

            entry size > 1 ifTrue:[
                files := entry asArray.
                1 to:files size-1 do:[:idx1 |
                    idx1+1 to:files size do:[:idx2 |
                        |fn1 fn2|

                        fn1 := files at:idx1.
                        fn2 := files at:idx2.

                        (result at:fn2 ifAbsent:nil) ~= fn1 ifTrue:[
                            "/ compare the files
                            (fn1 sameContentsAs:fn2) ifTrue:[
"/                                Transcript show:'Same: '; show:fn1 baseName; show:' and '; showCR:fn2 baseName.
                                result at:fn1 put:fn2.
                            ]
                        ]
                    ]
                ]
            ]
        ].

        result := result associations.
        result := result collect:[:assoc |
                                        |f1 f2|

                                        f1 := assoc key baseName.
                                        f2 := assoc value baseName.
                                        f1 < f2 ifTrue:[
                                            f2 -> f1
                                        ] ifFalse:[
                                            f1 -> f2
                                        ]
                                ].
        result sort:[:f1 :f2 | f2 value < f1 value].

        info := OrderedCollection new.
        result do:[:assoc |
            |fn1 fn2|

            fn1 := assoc key.
            fn2 := assoc value.
            (fn1 includes:Character space) ifTrue:[
                fn1 := '"' , fn1 , '"'
            ].
            (fn2 includes:Character space) ifTrue:[
                fn2 := '"' , fn2 , '"'
            ].
            info add:(fn1 , ' same as ' , fn2)
        ].
        info isEmpty ifTrue:[
            info := 'No duplicate files found.'
        ].
    ].

    subView contents:info

    "Created: / 3.10.1998 / 17:59:00 / cg"
    "Modified: / 3.10.1998 / 19:29:19 / cg"
!

fileFindFile
    |sel bindings
     namePatternHolder contentsPatternHolder
     ignoreCaseInName ignoreCaseInContents
     namePattern namePatterns contentsPattern 
     searchForSameContentsEnabled searchForSameContents|

    (self askIfModified:'contents has not been saved.\\Modifications will be lost when you proceed.'
              yesButton:'proceed') ifFalse:[^ self].

    subView contents:nil; scrollToTop.

    bindings := IdentityDictionary new.
    bindings at:#namePatternHolder put:(namePatternHolder := '' asValue).
    bindings at:#contentsPatternHolder put:(contentsPatternHolder := '' asValue).
    bindings at:#ignoreCaseInName put:(ignoreCaseInName := false asValue).
    bindings at:#ignoreCaseInContents put:(ignoreCaseInContents := false asValue).

    searchForSameContentsEnabled := false.
    sel := fileListView selectionValue.
    sel size == 1 ifTrue:[
        searchForSameContentsEnabled := true.
        sel := sel first string withoutSeparators
    ].
    bindings at:#searchForSameContentsEnabled put:(searchForSameContentsEnabled := searchForSameContentsEnabled asValue).
    bindings at:#searchForSameContents put:(searchForSameContents := false asValue).
    bindings at:#notSearchForSameContents put:(BlockValue forLogicalNot:searchForSameContents).


    (SimpleDialog new 
        openFor:self
        interfaceSpec:(self class fileSearchDialogSpec)
        withBindings:bindings) ifTrue:[

        namePattern := namePatternHolder value.
        namePattern size == 0 ifTrue:[
            namePatterns := nil
        ] ifFalse:[
            ignoreCaseInName value ifTrue:[
                namePattern := namePattern asLowercase
            ].
            namePatterns := namePattern asCollectionOfSubstringsSeparatedBy:$;
        ].
        contentsPattern := contentsPatternHolder value.
        contentsPattern size == 0 ifTrue:[
            contentsPattern := nil
        ] ifFalse:[
            ignoreCaseInContents value ifTrue:[
                contentsPattern := contentsPattern asLowercase
            ]
        ].

        self withWaitCursorDo:[
            |stopSignal access myProcess lowerFrameView|

            myProcess := Processor activeProcess.

            access := Semaphore forMutualExclusion name:'accessLock'.
            stopSignal := Signal new.

            "
             The following is tricky: 
             the pauseToggle & killButton will
             be handled by their own windowGroup process.
             This means, that they respond to events even though
             I myself am reading the commands output.
            "

            commandView beInvisible.

            "
             must take kill & pauseButtons out of my group
            "
            killButton windowGroup:nil.

            "
             bring them to front, and turn hidden-mode off
            "
            killButton label:(resources string:'Stop').
            killButton raise; beVisible.

            "
             kill will make me raise the stopSignal when pressed
            "
            killButton 
                action:[
                    access critical:[
                        myProcess interruptWith:[stopSignal raiseRequest].
                    ]
                ].

            "
             start kill button under its own windowgroup
            "
            killButton openAutonomous.
            killButton windowGroup process processGroupId:(Processor activeProcessId).

            lowerFrameView := subView superView.

            [
                stopSignal catch:[
                    searchForSameContents value ifTrue:[
                        self 
                            doFindFileNamed:namePatterns
                            ignoreCase:ignoreCaseInName value
                            containingString:nil
                            ignoreCaseInContents:ignoreCaseInContents value
                            sameContentsAsFile:(currentDirectory asFilename construct:sel) 
                            sameContentsAs:nil 
                            in:currentDirectory.
                    ] ifFalse:[
                        (contentsPattern size > 0 or:[namePatterns size > 0]) ifTrue:[
                            self 
                                doFindFileNamed:namePatterns
                                ignoreCase:ignoreCaseInName value
                                containingString:contentsPattern
                                ignoreCaseInContents:ignoreCaseInContents value
                                sameContentsAsFile:nil 
                                sameContentsAs:nil 
                                in:currentDirectory.
                        ]
                    ]
                ]
            ] ensure:[
                |wg|

                self label:myName; iconLabel:myName.

                "
                 hide the button, and make sure it will stay
                 hidden when we are realized again
                "
                killButton beInvisible.

                commandView beVisible.

                "
                 remove the killButton from its group
                 (otherwise, it will be destroyed when we shut down the group)
                "
                wg := killButton windowGroup.
                killButton windowGroup:nil.

                "
                 shut down the kill buttons windowgroup
                "
                wg notNil ifTrue:[
                    wg process terminate.
                ].
                "
                 clear its action (actually not needed, but
                 releases reference to thisContext earlier)
                "
                killButton action:nil.
                killButton label:(resources string:'kill').

                "/    
                "/ allow interaction with the codeView
                "/ (bring it back into my group)
                "/
                lowerFrameView windowGroup:(self windowGroup).
            ].

        ].
        self label:myName.
        currentFileName isNil ifTrue:[
            subView modified:false.
        ].
    ].

    "Created: / 15.10.1998 / 11:32:57 / cg"
    "Modified: / 15.10.1998 / 12:41:09 / cg"
!

fileGet
    "get contents of selected file into subView.
     If text was modified show a queryBox,
     otherwise get it immediately"

    self fileGet:false

    "Modified: 19.6.1996 / 09:38:45 / cg"
!

fileGet:viaDoubleClick
    "get contents of selected file into subView.
     If text was modified show a queryBox,
     otherwise get it immediately"

    |fileName msg label|

    (subView modified not or:[subView contentsWasSaved]) ifTrue:[
        self doFileGet:viaDoubleClick.
        ^ self
    ].
    fileName := self getSelectedFileName.
    fileName notNil ifTrue:[
        (currentDirectory filenameFor:fileName) isDirectory ifTrue:[
            msg := 'Contents has not been saved.\\Modifications will be lost when directory is changed.'.
            label := 'Change'.
        ] ifFalse:[
            msg := 'Contents has not been saved.\\Modifications will be lost when new file is read.'.
            label := 'Get'.
        ].
        (self ask:(resources string:msg) yesButton:label) ifTrue:[
            subView modified:false.
            self doFileGet:viaDoubleClick
        ]
    ]

    "Created: 19.6.1996 / 09:38:35 / cg"
    "Modified: 23.4.1997 / 13:04:11 / cg"
    "Modified: 18.9.1997 / 16:27:34 / stefan"
!

fileGetInfo
    "show short file (stat)-info"

    self fileGetInfo:false
!

fileGetInfo:longInfo
    "get info on selected file - show it in a box"

    |string box updater|

    string := self getFileInfoString:longInfo.
    string notNil ifTrue:[
        box := InfoBox title:string.
        updater := [
            [true] whileTrue:[
                Delay waitForSeconds:2.
                string := self getFileInfoString:longInfo.
                box title:string
            ] 
        ] fork.

        box show.
        updater terminate.
        box destroy
    ]
!

fileGetLongInfo
    "show long stat (file)-info"

    self fileGetInfo:true
!

fileHexDump
    "show a hex dump (similar to od -x)
     Only needed with non-Unix systems."

    (self askIfModified:'Contents has not been saved.\\Modifications will be lost when hex dump is shown.'
              yesButton:'HexDump') ifFalse:[^ self].

    self withReadCursorDo:[
        |fileName f lines|

        fileName := self getSelectedFileName.
        fileName notNil ifTrue:[
            f := currentDirectory construct:fileName.
            subView list:nil.
            lines := AbstractFileBrowser contentsOfFileAsHexDump:f.
            self show:lines.
        ]
    ]

    "Modified: / 7.9.1998 / 15:37:47 / cg"
!

fileInsert
    "insert contents of file at the cursor position"

    |fileName|

    fileName := self getSelectedFileName.
    fileName notNil ifTrue:[
        self showFile:fileName insert:true encoding:fileEncoding
    ]

    "Modified: 23.4.1997 / 13:06:06 / cg"
!

fileListMenu
    "return the menu to show in the fileList"

    <resource: #programMenu>

    |spec|

    self sensor ctrlDown ifTrue:[
        spec := self class toolsMenuSpec.
    ] ifFalse:[
        spec := self class menuPopUp.
    ].
    ^ self menuFromSpec:spec.
"/    |m|
"/
"/    self sensor ctrlDown ifTrue:[
"/        m := self class toolsMenuSpec.
"/    ] ifFalse:[
"/        m := self class menuPopUp.
"/    ].
"/    m := m decodeAsLiteralArray.
"/    m receiver:self.
"/    m findGuiResourcesIn:self.
"/    ^ m.

    "Modified: / 14.8.1998 / 14:09:12 / cg"
!

fileListMenu_old
    "return the menu to show in the fileList"

    <resource: #programMenu>

    |items m sel ns|

    items := #(
                 ('Spawn'            fileSpawn        )
                 ('-'                nil              )  
                 ('get contents'     fileGet          GotoLine)      
                 ('Insert contents'  fileInsert       )            
                 ('Show info'        fileGetInfo      InspectIt)
                 ('Show full info'   fileGetLongInfo  CmdI)
               ).

    ((ns := Project current defaultNameSpace) notNil 
    and:[ns ~~ Smalltalk]) ifTrue:[
        items := items copyWith:(Array 
                                    with:(resources string:'fileIn (into ''%1'')' with:(Project current defaultNameSpace name))
                                    with:#fileFileIn
                                    with:#Accept)
                                
    ] ifFalse:[
        items := items copyWith:#( 'fileIn'  #fileFileIn  #Accept)
    ].

    items := items , #(
                 ('-'                                                   )
                 ('Update'                    updateCurrentDirectory    Cmdu)
                 ('-'                                                   )
                 ('Execute unix command ...'  fileExecute               DoIt)
                 ('ST/X tools'                stxTools                  )
                 ('-'                                                   )
                 ('Remove'                    fileRemove                Delete)
                 ('Rename ...'                fileRename                )
                 ('-'                                                   )
                 ('Display long list'         changeDisplayMode         )
                 ('Show all files'            changeDotFileVisibility   )
                 ('Encoding ...'              fileEncoding              )
                 ('-'                                                   )
                 ('Create directory ...'      newDirectory              CmdD)
                 ('Create file ...'           newFile                   CmdF)
               ).             

    m := PopUpMenu 
            itemList:items
            resources:resources.

    showingHiddenFiles value "showDotFiles" ifTrue:[
        m labelAt:#changeDotFileVisibility put:(resources string:'Hide hidden files')
    ].
    showingDetails value "showLongList" ifTrue:[
        m labelAt:#changeDisplayMode put:(resources string:'Display short list')
    ].

    items := #(
                              ('Changes Browser'       openChangesBrowser  )
                              ('Editor'                openEditor          )
                              ('HTML Reader'           openHTMLReader      )
                              ('Image Inspect'         openImageInspector  )
                              ('Show File Differences' openDiffView        )
                  ).

    OperatingSystem isUNIXlike ifTrue:[
        items := items , #( ('Terminal'              openTerminal )).
    ].

    JavaInterpreter notNil ifTrue:[
        items := items , #( ('Java Applet Viewer' openAppletViewer)).
    ].

    m subMenuAt:#stxTools 
            put:(PopUpMenu
                    itemList:items
                    resources:resources).

    ((sel := fileListView selection) isNil 
    or:[sel isEmpty]) ifTrue:[
        m disableAll:#(fileGet fileInsert
                       fileGetInfo fileGetLongInfo
                       fileFileIn fileFileInLazy
                       fileRemove fileRename).
        (m subMenuAt:#stxTools)
            disableAll:#(openChangesBrowser openEditor openHTMLReader openImageInspector)
    ] ifFalse:[
        fileListView selection size > 1 ifTrue:[
            m disableAll:#( fileGet fileInsert fileGetInfo fileGetLongInfo fileRename )
        ]
    ].

    ^m

    "Modified: / 16.1.1998 / 16:42:59 / stefan"
    "Modified: / 4.8.1998 / 13:45:56 / cg"
    "Created: / 13.8.1998 / 20:51:38 / cg"
!

filePrint
    "send a files contents to the printer (not in the menu)"

    |fileName path inStream printStream line|

    self withWaitCursorDo:[
        fileName := self getSelectedFileName.
        fileName notNil ifTrue:[
            path := currentDirectory filenameFor:fileName.
            (path type == #regular) ifTrue:[
                inStream := path readStreamOrNil.
                inStream notNil ifTrue:[
                    printStream := PrinterStream new.
                    printStream notNil ifTrue:[
                        [inStream atEnd] whileFalse:[
                            line := inStream nextLine.
                            printStream nextPutLine:line.
                        ].
                        printStream close
                    ].
                    inStream close
                ]
            ]
        ].
        0 "compiler hint"
    ]

    "Modified: 23.4.1997 / 13:05:40 / cg"
    "Modified: 18.9.1997 / 16:29:17 / stefan"
!

fileRemove
    "remove the selected file(s).
     Query if user really wants to remove the file, except if
     shift-key is pressed.
     TODO: Should be enhanced, to look for a ~/.trash directory 
           and move files there if it exists (without asking in this case)."

    |sel|

    sel := fileListView selection.
    sel size > 0 ifTrue:[
        sel := sel collect:[:rawIndex | fileList at:rawIndex].
        "/ do not ask, if shift is pressed
        self sensor shiftDown ifTrue:[
            self doRemove:sel
        ] ifFalse:[
            self confirmAndRemove:sel
        ].
    ]
!

fileRename
    "rename the selected file(s)"

    |queryBox b lastNewName lastOldName initialText|

    queryBox := FilenameEnterBox new.
    queryBox okText:(resources string:'Rename').
    fileListView selection size > 1 ifTrue:[
        b := queryBox addAbortButtonLabelled:(resources string:'Cancel All').
        b action:[^ self ].
    ].

    self selectedFilesDo:[:oldName |
        queryBox title:(resources string:'Rename ''%1'' to:' with:oldName).

        lastNewName notNil ifTrue:[
            "/ intelligent default ...
            initialText := self class goodRenameDefaultForFile:oldName lastOld:lastOldName lastNew:lastNewName
        ].
        queryBox initialText:(initialText ? oldName).
        queryBox 
            action:[:newName | 
                fileListView removeFromSelection:(fileList indexOf:oldName).
                self doRename:oldName to:newName. 
                lastOldName := oldName.
                lastNewName := newName.
            ].
    
        queryBox show.
        queryBox destroy.
    ]
!

fileSelect:lineNr
    "selected a file - do nothing here"

    |fn|

    imagePreviewView notNil ifTrue:[
        self stopImageRenderProcess.

        fn := self getSelectedFileName.
        (Image isImageFileSuffix:(fn asFilename suffix)) ifTrue:[
            imageRenderProcess := [
                self loadImageThenDo:[:img | 
                                                imagePreviewView beVisible.
                                                imagePreviewView image:img
                                         ]
            ] forkAt:(Processor activePriority - 1).
        ] ifFalse:[
            imagePreviewView beInvisible
        ].
    ]

    "Modified: 23.4.1997 / 13:04:55 / cg"
!

fileSpawn
    "start another FileBrowser on the selected directory or
     on the same directory if none is selected."

    |any path|

    any := false.
    self selectedFilesDo:[:fileName |
        path := currentDirectory filenameFor:fileName.
        path isDirectory ifTrue:[
            self class openOn:(path pathName).
            any := true
        ]
    ].
    any ifFalse:[
        "/ access by name, to get most up-to-date version 
        "/ (if changed in the browser, and the running one is old)
        (Smalltalk at:(self class name))
            openOn:currentDirectory withExtent:self topView extent
    ]

    "Modified: 18.9.1997 / 16:32:39 / stefan"
!

hasSlideShow
    ^ [CodingExamples_GUI::SlideShow notNil]

    "Created: / 29.12.2001 / 21:58:47 / cg"
    "Modified: / 29.12.2001 / 21:59:01 / cg"
!

installAllAsAutoloaded
    "install all classes found here as autoloaded classes"

    currentDirectory directoryContentsDo:[:fileNameString |
        |fn|

        fn := (currentDirectory construct:fileNameString).
        (fn hasSuffix:'st') ifTrue:[
            self installAsAutoloaded:fn
        ]
    ].
!

installAsAutoloaded:aFilename
    "install aFilename as autoloaded class"

    |chunks filename|

    filename := aFilename asFilename.
    filename 
        readingFileDo:[:inStream |
            chunks := ChangeSet fromStream:inStream.
        ].

    chunks 
        select:[:eachChunk | eachChunk isClassDefinitionChange]
        thenDo:[:eachClassChunk | 
            eachClassChunk installAsAutoloadedClassIfPublicWithFilename:(filename withoutSuffix baseName)
        ].

    "Modified: / 02-11-2010 / 09:10:15 / cg"
!

loadImageThenDo:aBlock
    |img path|

    self selectedFilesDo:[:fileName |
        path := currentDirectory filenameFor:fileName.
        path isDirectory ifFalse:[
            img := Image fromFile:(path pathName).
            img notNil ifTrue:[
                aBlock value:img
            ] ifFalse:[
                self warn:'Unknown format: ' , fileName
            ]
        ]
    ].

    "Modified: / 17.9.1995 / 17:41:24 / claus"
    "Modified: / 18.9.1997 / 17:05:04 / stefan"
    "Created: / 26.8.1998 / 16:20:18 / cg"
!

newDirectory
    "ask for and create a new directory"

    |queryBox|

    queryBox := FilenameEnterBox 
                    title:(resources stringWithCRs:'Create new directory:') 
                    okText:(resources string:'Create')
                    action:[:newName | self doCreateDirectory:newName].
    queryBox show.
    queryBox destroy.

    "Modified: 23.4.1997 / 13:04:27 / cg"
!

newFile
    "ask for and create a new file"

    |sel queryBox|

    queryBox := FilenameEnterBox 
                    title:(resources stringWithCRs:'Create new file:')
                    okText:(resources string:'Create')
                    action:[:newName | newName notEmpty ifTrue:[
                                           self doCreateFile:newName.
                                           self selectFile:newName.
                                       ]
                           ].
    sel := subView selection.
    sel notNil ifTrue:[
        queryBox initialText:(sel asString)
    ].
    queryBox show.
    queryBox destroy.

    "Modified: / 23.4.1997 / 13:04:38 / cg"
    "Modified: / 16.1.1998 / 16:54:00 / stefan"
!

newHardLink
    "ask for and create a hard link (unix only)"

    self newLinkWithType:#hard.
!

newLinkWithType:hardOrSoftSymbol
    "ask for and create a link (unix only)"

    |sel box ok lbl orgName1 name1 name2 f1 f2 err if1 if2|

    sel := self getSelectedFileName.

    orgName1 := ''.
    (sel size > 0) ifTrue:[
        hardOrSoftSymbol == #soft ifTrue:[
            orgName1 := sel
        ] ifFalse:[
            (currentDirectory construct:sel) isDirectory ifFalse:[
                orgName1 := sel
            ]
        ]
    ].

    name1 := ValueHolder with:orgName1.
    name2 := ValueHolder with:''.

    box := DialogBox new.
    lbl := hardOrSoftSymbol == #soft 
            ifTrue:['Create symbolic link to:']
            ifFalse:['Create hard link from:'].
    box addTextLabel:(resources string:lbl) adjust:#left.
    if1 := box addFilenameInputFieldOn:name1 in:currentDirectory tabable:true.

    lbl := hardOrSoftSymbol == #soft 
            ifTrue:['as']
            ifFalse:['to:'].
    box addTextLabel:(resources string:lbl) adjust:#left.
    if2 := box addFilenameInputFieldOn:name2 in:currentDirectory tabable:true.

    box addAbortAndOkButtons.

    orgName1 size > 0 ifTrue:[
        box focusOnField:if2.
    ].
    box show.
    ok := box accepted.
    box destroy.

    ok ifTrue:[
        name1 := name1 value.
        (name1 size == 0) ifTrue:[
            err := 'no name entered'.
        ] ifFalse:[
            f1 := name1 asFilename.
            name2 := name2 value.
            (name2 size == 0) ifTrue:[
                err := 'no name entered'.
            ] ifFalse:[
                f2 := name2 asFilename.
                f2 exists ifTrue:[
                    err := '''%2'' already exists'.
                ] ifFalse:[
                    f1 exists ifFalse:[
                        err := '''%1'' does not exist'.
                    ] ifTrue:[
                        f1 isDirectory ifTrue:[
                            err := '''%1'' is a directory'.
                        ] ifFalse:[
                            Error handle:[:ex |
                                err := ex description
                            ] do:[
                                hardOrSoftSymbol == #soft ifTrue:[
                                    f2 createAsSymbolicLinkTo:f1.
                                ] ifFalse:[
                                    f2 createAsHardLinkTo:f1.
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ].

        err notNil ifTrue:[
            self warn:(resources string:err with:(name1 ? '') allBold with:(name2 ? '') allBold).
            ^ self
        ].
    ].

    "Modified: / 13.8.1998 / 21:47:01 / cg"
!

newSoftLink
    "ask for and create a soft link (unix only)"

    self newLinkWithType:#soft.

    "Modified: / 13.8.1998 / 21:26:59 / cg"
    "Created: / 13.8.1998 / 21:47:14 / cg"
!

openASN1Browser
    self openTool:OSI::ASN1Browser 

    "Modified: / 7.9.1998 / 21:31:58 / cg"
!

openAppletViewer
    |numItems|

    (numItems := fileListView selection size) > 2 ifTrue:[
        (self 
            confirm:(resources string:'open for each of the %1 items ?' 
                                 with:numItems)) ifFalse:[^ self].
    ].

    Java startupJavaSystem.
"/    Java markAllClassesUninitialized.
"/    Java initAllStaticFields.
"/    Java initAllClasses.

    self selectedFilesDo:[:fileName |
        |p path|

        path := currentDirectory filenameFor:fileName.
        path isDirectory ifFalse:[
            p := Java 
                    javaProcessForMainOf:(Java classForName:'sun.applet.AppletViewer')
                    argumentString:path pathName.
            p resume.
        ]
    ].

    "Modified: / 18.9.1997 / 17:00:59 / stefan"
    "Modified: / 17.10.1998 / 17:00:43 / cg"
!

openCBrowser
    self withWaitCursorDo:[
        CBrowser::Browser openIn:currentDirectory.
    ]
!

openChangesBrowser
    "open a change browser on the selected file(s)"

    self openTool:(UserPreferences current changesBrowserClass)

    "Modified: / 17.10.1998 / 14:39:15 / cg"
!

openDiffView
    "open a diff-view"

    |sel box ok orgName1 name1 name2 text1 text2 f d err nm here l1|

    sel := fileListView selection.
    (sel size == 2) ifTrue:[
        name1 := fileList at:sel first.
        name2 := fileList at:sel last.
    ] ifFalse:[
        sel := self getSelectedFileName.

        orgName1 := ''.
        (sel size > 0
        and:[lastFileDiffDirectory notNil
        and:[lastFileDiffDirectory asFilename isDirectory]]) ifTrue:[
            f := lastFileDiffDirectory asFilename construct:sel.
            f isReadable ifTrue:[
                orgName1 := f name
            ]
        ].
        name1 := ValueHolder with:orgName1.
        name2 := ValueHolder with:self getSelectedFileName.
    ].

    here := currentDirectory pathName.

    box := DialogBox new.
    box addTextLabel:'Show difference between:\\file1 (empty for views contents):' withCRs adjust:#left.
    box addFilenameInputFieldOn:name1 in:here tabable:true.
    box addTextLabel:'and file2:' adjust:#left.
    box addFilenameInputFieldOn:name2 in:here tabable:true.

    box addAbortAndOkButtons.

    box show.
    ok := box accepted.
    box destroy.

    ok ifTrue:[
        name1 := name1 value.
        (name1 isEmptyOrNil) ifTrue:[
"/            text1 := subView contents.
            text1 := subView list asStringCollection withTabs.
            text1 := text1 collect:[:l | l isNil ifTrue:[' '] ifFalse:[l string]].
            name1 := nil.
            l1 := 'browser contents'
        ] ifFalse:[
            name1 := currentDirectory filenameFor:name1.
            name1 isReadable ifFalse:[
                nm := name1.
                name1 exists ifFalse:[
                    err := '%1 does not exist'.
                ] ifTrue:[
                    err := '%1 is not readable'
                ].
            ].
            l1 := name1 pathName
        ].

        name2 := currentDirectory filenameFor:name2 value.
        err isNil ifTrue:[
            name2 isReadable ifFalse:[
                nm := name2.
                name2 exists ifFalse:[
                    err := '%1 does not exist'.
                ] ifTrue:[
                    err := '%1 is not readable'
                ].
            ].
        ].
        err notNil ifTrue:[
            self warn:(resources string:err with:nm pathName).
            ^ self
        ].

        self withWaitCursorDo:[
            (name1 notNil and:[name1 name ~= orgName1]) ifTrue:[
                lastFileDiffDirectory := name1 directoryName
            ].
            name1 notNil ifTrue:[
                text1 := name1 contents.
            ].
            text2 := name2 contents.
            text1 = text2 ifTrue:[
                self information:'same contents'
            ] ifFalse:[
                d := DiffTextView 
                        openOn:text1 label:l1
                        and:text2 label:name2 pathName.
                d label:'file differences'.
            ]
        ]
    ].

    "Created: / 7.12.1995 / 20:33:58 / cg"
    "Modified: / 18.9.1997 / 17:31:46 / stefan"
    "Modified: / 5.5.1999 / 16:04:10 / cg"
!

openEditor
    self openTool:EditTextView
!

openHTMLReader
    self openTool:HTMLDocumentView ignoreDirectories:false

    "Modified: / 7.9.1998 / 21:31:58 / cg"
!

openImageEditor
    [
        self loadImageThenDo:[:img | img edit]
    ] fork

    "Modified: / 17.9.1995 / 17:41:24 / claus"
    "Modified: / 18.9.1997 / 17:05:04 / stefan"
    "Created: / 13.8.1998 / 22:07:09 / cg"
    "Modified: / 7.9.1998 / 21:31:41 / cg"
!

openImageInspector
    [
        self loadImageThenDo:[:img | img inspect]
    ] fork

    "Modified: / 17.9.1995 / 17:41:24 / claus"
    "Modified: / 18.9.1997 / 17:05:04 / stefan"
    "Modified: / 7.9.1998 / 21:31:30 / cg"
!

openImagePreview
    [
        self loadImageThenDo:
            [:img |
                |i top viewer imgFileName|

                top := StandardSystemView new.

                viewer := ImageView origin:0.0@0.0 corner:1.0@1.0 in:top.
                i := img.
                top extent:200@200.
                imgFileName := img fileName asFilename.
                top label:(imgFileName directoryName asFilename baseName , '/' , imgFileName baseName).
                top openAndWait.

                (i width > 200 or:[i height > 200]) ifTrue:[
                    i := i magnifiedPreservingRatioTo:200@200.
                ].
                viewer image:i.
            ].
    ] fork

    "Modified: / 4.12.1998 / 15:49:03 / cg"
!

openMP3Player
    |file|

    file := self getSelectedFileName.
    (file isNil) ifTrue:[
        ^ self.
    ].
    file := currentDirectory filenameFor:file.
    (MP3PlayerApplication ? SaugFix::MP3PlayerApplication) playSong:file.
!

openSelectedFilename
    |sel|

    sel := subView selection.
    sel notNil ifTrue:[
        sel := sel asString withoutSeparators.
        sel asFilename exists ifTrue:[
            self doOpenFile:sel viaDoubleClick:false
        ]
    ].

    "Created: / 4.2.1999 / 17:40:42 / cg"
    "Modified: / 4.2.1999 / 17:47:06 / cg"
!

openSlideShow
    CodingExamples_GUI::SlideShow openIn:currentDirectory

    "Created: / 29.12.2001 / 21:56:34 / cg"
!

openSnapshotImageBrowser
    "Sorry, for now, only the old browser can handle snapShotImages."

    ^ self openTool:SystemBrowser with:#openOnSnapShotImage: ignoreDirectories:true
!

openTerminal
    TerminalApplication notNil ifTrue:[
        TerminalApplication openIn:currentDirectory.
    ] ifFalse:[
        VT100TerminalView openShellIn:currentDirectory
    ]

    "Created: / 20.7.1998 / 18:18:15 / cg"
    "Modified: / 20.7.1998 / 18:32:28 / cg"
!

openTool:aToolClass
    "open a tool on the selected file(s)"

    ^ self openTool:aToolClass ignoreDirectories:true

    "Modified: / 7.9.1998 / 19:32:10 / cg"
!

openTool:aToolClass ignoreDirectories:ignoreDirs
    "open a tool on the selected file(s)"

    ^ self
        openTool:aToolClass 
        with:#openOn: 
        ignoreDirectories:ignoreDirs
!

openTool:aToolClass with:aSelector ignoreDirectories:ignoreDirs
    "open a tool on the selected file(s)"

    |numItems path tool|

    aToolClass isNil ifTrue:[
        self warn:'Sorry, that tool seems to be not available'.
        ^ nil.
    ].

    (numItems := fileListView selection size) > 2 ifTrue:[
        (self 
            confirm:(resources string:'open for each of the %1 items ?' 
                                 with:numItems)) ifFalse:[^ self].
    ].

    self withWaitCursorDo:[
        self selectedFilesDo:[:fileName |
            path := currentDirectory filenameFor:fileName.
            (ignoreDirs not or:[path isDirectory not]) ifTrue:[
                path isAbsolute ifTrue:[
                    path := path name.
                ] ifFalse:[
                    path := path pathName.
                ].
                tool := aToolClass perform:aSelector with:path.
            ]
        ].
    ].
    ^ tool

    "Created: / 07-09-1998 / 19:31:49 / cg"
    "Modified: / 25-05-1999 / 16:30:35 / cg"
    "Modified: / 19-01-2017 / 16:57:15 / stefan"
!

openZipTool
    |zipTool|

    (zipTool := self openTool:ZipTool) notNil ifTrue:[
        zipTool initialExtractDirectory:currentDirectory
    ].

    "Created: / 26.8.1998 / 16:20:55 / cg"
    "Modified: / 25.5.1999 / 16:30:54 / cg"
!

readAbbrevFile
    "read the abbrev file and install classes found there as autoloaded classes"

    |sel|

    sel := fileListView selection.
    sel size == 0 ifTrue:[
        Smalltalk installAutoloadedClassesFrom:(currentDirectory construct:'abbrev.stc').
        ^ self
    ].
    sel do:[:eachIndex |
        |f|

        f := fileList at:eachIndex ifAbsent:nil.
        f := currentDirectory construct:f.
        f isDirectory ifTrue:[
            f := f construct:'abbrev.stc'
        ].
        Smalltalk installAutoloadedClassesFrom:f.
    ].
!

revisitFile:aFileName
    |lineNr|

    (self askIfModified:'contents has not been saved.\\Modifications will be lost when you proceed.' 
         yesButton:'proceed') ifFalse:[ ^self ].

    self doChangeCurrentDirectoryTo:aFileName asFilename directory updateHistory:false.
    lineNr := fileList indexOf:aFileName asFilename baseName.
    fileListView selection:lineNr.
    self fileGet:true.

!

showOrHideTabView
    "depending on the showLongList setting, show or hde the tabSpec view"

    showingDetails value "showLongList" ifTrue:[
        tabRulerView isNil ifTrue:[
            self createTabRulerIn:scrollView superView.
        ].
        tabRulerView beVisible.
        
        false "self is3D" ifTrue:[
            scrollView topInset:(tabRulerView superView height).
            tabRulerView superView leftInset:(fileListView originRelativeTo:scrollView) x.
        ] ifFalse:[
            scrollView topInset:(tabRulerView height).
            tabRulerView leftInset:(fileListView originRelativeTo:scrollView) x.
        ].
        tabRulerView hiddenTabs:#(1).
        tabRulerView fixedTabs:#(1).
    ] ifFalse:[
        tabRulerView notNil ifTrue:[
            tabRulerView beInvisible.
        ].
        scrollView topInset:0
    ].
    tabSpec := nil.

    "Created: / 19.4.1997 / 09:50:02 / cg"
    "Modified: / 4.8.1998 / 13:44:14 / cg"
! !

!FileBrowser methodsFor:'help'!

helpTextFor:aComponent
    |s|

    aComponent == subView ifTrue:[
        s := 'HELP_SUBVIEW'
    ].
    aComponent == fileListView ifTrue:[
        s := 'HELP_FILELIST'
    ].
    aComponent == filterField ifTrue:[
        s := 'HELP_FILTER'
    ].
    aComponent == labelView ifTrue:[
        s := 'HELP_PATHFIELD'
    ].
    aComponent == commandView ifTrue:[
        s := 'HELP_COMMANDVIEW'
    ].
    s notNil ifTrue:[
        ^ resources string:s
    ].
    ^ nil
! !

!FileBrowser methodsFor:'initialization & release'!

createTabRulerIn:topFrame
    |v|

    false "self is3D" ifTrue:[
        v := View in:topFrame.
        v level:-1.
        tabRulerView := TabSpecRuler in:v.
        tabRulerView level:1.
        v origin:(0.0@0.0) corner:(1.0@10).
        tabRulerView origin:(0.0@0.0) corner:(1.0@1.0).
    ] ifFalse:[
        tabRulerView := TabSpecRuler in:topFrame.
        tabRulerView origin:(0.0@0.0) corner:(1.0@10).
    ].
    tabRulerView borderWidth:0.
    tabRulerView beSynchronous.
    tabRulerView masterView:scrollView scrolledView

    "Created: / 27.7.1998 / 20:23:10 / cg"
    "Modified: / 27.7.1998 / 20:30:10 / cg"
!

currentDirectory:aDirectoryPath
    "set the directory to be browsed"

    |newDirectory|

    newDirectory := aDirectoryPath asFilename.
    newDirectory = currentDirectory ifTrue:[
        ^ self
    ].

    currentDirectory := newDirectory.
    self changed:#path.

    "
     tell my subview (whatever that is) to start its file-dialog
     (i.e. save-as etc.) in that directory
    "
    (subView respondsTo:#directoryForFileDialog:) ifTrue:[
        subView directoryForFileDialog:currentDirectory
    ]

    "Modified: 16.9.1997 / 14:56:17 / stefan"
    "Modified: 21.9.1997 / 11:28:49 / cg"
!

destroy
    "destroy view and boxes"

    ObjectMemory removeDependent:self.
    self stopUpdateProcess.
    self stopImageRenderProcess.
    checkBlock := nil.
    super destroy

    "Modified: 19.4.1997 / 13:51:48 / cg"
!

initEvents
    super initEvents.
    self enableEvent:#visibilityChange.
!

initialize
    |frame spacing halfSpacing v topFrame labelFrame filterModel
     mH lowerFrame|

    super initialize.

    fileEncoding := #'iso8859-1'.        "/ native ST/X encoding

    "if true, will replace leading spaces by tabs on
     file write. If false, they will be written as spaces
    "
    compressTabs := resources at:'COMPRESS_TABS' default:true.

    "
     showing long or short by default
    "
    showingDetails := ValueHolder with:false.
    showingDetails onChangeSend:#detailsSettingChanged to:self.

    "
     show hidden files or not ?
    "
    "/ showDotFiles := resources at:'SHOW_DOT_FILES' default:false.
    showingHiddenFiles := ValueHolder with:false.
    showingHiddenFiles onChangeSend:#updateCurrentDirectory to:self.

    "
     showing small icons by default
    "
    showingBigImagePreview := ValueHolder with:false.
    showingBigImagePreview onChangeSend:#bigImagePreviewSettingChanged to:self.

    showingTimeAndDate := ValueHolder with:false.
    showingTimeAndDate onChangeSend:#updateCurrentDirectory to:self.

    sortByWhat := ValueHolder with:#name.
    sortByWhat onChangeSend:#sortChanged to:self.

    sortCaseless := ValueHolder with:(Filename isCaseSensitive not).
    sortCaseless onChangeSend:#updateCurrentDirectory to:self.

    dosEOLMode := ValueHolder with:false.

    lockUpdate := false.

    CommandHistory isNil ifTrue:[
        CommandHistory := OrderedCollection new.
        CommandHistorySize := 50
    ].
    VisitedFileHistory isNil ifTrue:[
        VisitedFileHistory := OrderedCollection new.
    ].
    HistorySize isNil ifTrue:[
        HistorySize := 15
    ].
    commandIndex := 0.

    icons := Dictionary new.
    matchedIcons := OrderedCollection new.

    myName := (resources string:self class name).
    self label:myName.

    menuPanel := MenuPanel in:self.
    "/ menuPanel level:1.
    menuPanel verticalLayout:false.
    menuPanel receiver:self.
    menuPanel menu:(self pullDownMenu).

    mH := menuPanel preferredHeight.
    menuPanel origin:(0.0 @ 0.0) corner:(1.0 @ (mH)).

    labelFrame := View 
                        origin:(0.0 @ mH)
                        corner:(1.0 @ (gc font height * 1.8 + mH) rounded)
                        in:self.

    (styleSheet name = #st80 or:[styleSheet isWindowsStyle]) ifTrue:[
        labelFrame level:1.
"/        labelFrame rightInset:-1.
    ].

    spacing := ViewSpacing.
    halfSpacing := spacing // 2.

    "
      checkBlock is executed by the Processor every checkDelta seconds.
      We use #pushEvent: to perform the directory update
      in our windowgroups process.
    "
    checkBlock := [self pushEvent:#checkIfDirectoryHasChanged].
    checkDelta := resources at:'FILEBROWSER_UPDATE_CHECK_DELTA' default:10.
    doAutoUpdate := ValueHolder with:true.

    currentDirectory := Filename currentDirectory.

    filterModel := ValueHolder with:'*'.
    filterField := EditField in:labelFrame.
    filterField 
        origin:[((width // 4 * 3) + halfSpacing) @ (halfSpacing)]
        corner:(1.0 @ (filterField heightIncludingBorder + halfSpacing) ).
    filterField rightInset:(ViewSpacing - halfSpacing).
    filterField model:filterModel.

    labelFrame corner:(1.0 @ (mH + ViewSpacing + filterField height + halfSpacing)).

    self initializeFilterPattern.
    filterModel onChangeSend:#filterPatternChanged to:self.
"/    filterField leaveAction:[:key | fileListView scrollToTop. self updateCurrentDirectory].

"/    labelView := Label in:labelFrame.
"/    labelView origin:(halfSpacing @ halfSpacing)
"/              extent:[((width // 4 * 3) - spacing - self borderWidth)
"/                       @
"/                       (filterField heightIncludingBorder)
"/                       "(font height + font descent)"
"/                     ].
"/    labelView adjust:#right.
"/    labelView borderWidth:0.
"/    labelView model:self; menu:#labelMenu; aspect:#path; labelMessage:#path.
"/    labelFrame model:self; menu:#labelMenu.

    labelView := FilenameEditField in:labelFrame.
    labelView 
        origin:(halfSpacing @ (halfSpacing))
        extent:[((width // 4 * 3) - spacing - self borderWidth)
                @
                (filterField heightIncludingBorder)
                "(font height + font descent)"
               ].
    labelView menu:#labelMenu; 
            aspect:#path; changeMessage:#pathChanged:.
    labelView model:self.
    labelView acceptOnExpand:true.
    labelView backgroundColor:(labelFrame viewBackground).
    labelFrame model:self; menu:#labelMenu.
    labelView cursorType:#solidCaret; cursorTypeNoFocus:#none.
    labelView level:0.
    labelView borderWidth:0.

    killButton := Button label:(resources string:'kill') in:self.
"/    killButton origin:(halfSpacing @ halfSpacing)
"/               extent:(killButton width @ filterField height).
    killButton origin:(halfSpacing @ 1.0).
    killButton topInset:(killButton height negated).
    killButton beInvisible.

    pauseToggle := Toggle label:(resources string:'pause') in:self.
"/    pauseToggle origin:((killButton corner x + 50) @ halfSpacing)
"/                extent:(pauseToggle width @ filterField height).
    pauseToggle origin:((killButton corner x + ViewSpacing + 20) @ 1.0).
    pauseToggle topInset:(pauseToggle height negated).
    pauseToggle beInvisible.

    self initializeCommandViewIn:self.

"/    frame := VariableVerticalPanel
"/                 origin:[frame borderWidth negated 
"/                         @ 
"/                         labelFrame height
"/                         "/ (labelView height + labelView origin y + spacing)
"/                        ]
"/                 corner:(1.0 @ 1.0)
"/                     in:self.

    frame := VariableVerticalPanel origin:0.0@mH corner:1.0@1.0 in:self.
    frame snapMode:#both.
    frame topInset:labelFrame height.
    commandView notNil ifTrue:[
        frame bottomInset:(commandView height + halfSpacing)
    ].

    topFrame := View in:frame.
    topFrame origin:(0.0 @ 0.0) corner:(1.0 @ 0.3).

false ifTrue:[
    self createTabRulerIn:topFrame.
].

    scrollView := ScrollableView in:topFrame.
    scrollView 
        verticalScrollable:true;
        verticalMini:false;
        horizontalScrollable:true;
        horizontalMini:true;
        autoHideHorizontalScrollBar:true;
        autoHideVerticalScrollBar:false;
        origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).

    fileListView := SelectionInListView new.
    scrollView scrolledView:fileListView.
    fileListView action:[:lineNr | self fileSelect:lineNr].
    fileListView doubleClickAction:[:lineNr | self fileDoubleClick:lineNr].
    fileListView multipleSelectOk:true.
    fileListView delegate:self.
    fileListView menuHolder:self; menuPerformer:self; menuMessage:#fileListMenu.
    fileListView allowDrag:true.
    fileListView dragObjectConverter:[:obj | 
                                        |dir nm path idx|

                                        nm := obj theObject asString.
                                        idx := fileListView list indexOf:nm.
                                        idx == 0 ifTrue:[
                                            "/ cannot happen ...
                                            nil
                                        ] ifFalse:[
                                            nm := fileList at:idx.
                                            dir := currentDirectory pathName asFilename.
                                            path := dir constructString:nm.
                                            DropObject newFile:path.
                                        ]
                                     ].

    "/ sigh - must be delayed - origin is not yet fixe
"/    tabRulerView leftInset:(fileListView originRelativeTo:scrollView) x.
"/    self showOrHideTabView.

    lowerFrame := View in:frame.
    lowerFrame origin:(0.0 @ 0.3) corner:(1.0 @ 1.0).

    v := self initializeSubViewIn:lowerFrame.

    subView := v scrolledView.
    (subView respondsTo:#directoryForFileDialog:) ifTrue:[
        subView directoryForFileDialog:currentDirectory
    ].

"/    buttonPanel := HorizontalPanelView in:self.
"/    buttonPanel horizontalLayout:#leftSpace.
"/    buttonPanel verticalSpace:0.
"/    "/ buttonPanel verticalLayout:#top.
"/    buttonPanel borderWidth:0.
"/
"/    buttonPanel 
"/        origin:(0.5 @ halfSpacing)
"/        extent:[((width // 4) - spacing - self borderWidth)
"/                @
"/                (buttonPanel preferredExtent y max:(labelView height))
"/               ].
"/    "/ buttonPanel level:-1.
"/
"/    upButton := Button in:buttonPanel.
"/    img := Image fromFile:'bitmaps/xpmBitmaps/document_images/tiny_yellow_dir_up.xpm'.
"/    upButton label:(img ? 'up').
"/    upButton action:[self changeToParentDirectory].

    ObjectMemory addDependent:self.

    "Modified: / 6.9.1995 / 20:26:06 / claus"
    "Modified: / 16.9.1997 / 14:52:46 / stefan"
    "Modified: / 12.7.1999 / 12:59:47 / cg"
!

initializeCommandViewIn:frame 
    "set up the command view - can be redefined in subclasses as empty,
     if no commandView is wanted"
    
    |layout|

    commandView := EditField in:frame.

    layout := LayoutFrame
        leftFraction:0 offset:1
        rightFraction:1 offset:-1
        topFraction:1 offset:(commandView preferredHeight + 1) negated
        bottomFraction:1 offset:-1.

    commandView layout:layout.
    
    "/    commandView contents:'** no commands which require input here **'.
    commandView 
        entryCompletionBlock:[ :contents | 
            |newString|

            newString := self entryCompletion:contents.
            newString notNil ifTrue:[ 
                commandView contents:newString.
                commandView cursorToEndOfLine.
            ].
        ].
    commandView 
        leaveAction:[ :key | 
            |cmd nCmd empty|

            (key == #CursorDown or:[ key == #CursorUp ]) ifTrue:[ 
                nCmd := CommandHistory size.
                nCmd == 0 ifTrue:[ 
                    empty := true
                ] ifFalse:[ 
                    key == #CursorUp ifTrue:[ 
                        commandIndex == nCmd ifTrue:[ 
                            commandView flash.
                        ].
                        commandIndex := (commandIndex + 1) min:nCmd
                    ] ifFalse:[ 
                        commandIndex == 1 ifTrue:[ 
                            commandView flash.
                            empty := true.
                        ].
                        commandIndex := (commandIndex - 1) max:1.
                    ].
                ].
                empty == true ifTrue:[ 
                    commandView contents:nil
                ] ifFalse:[ 
                    commandView contents:(CommandHistory at:commandIndex).
                ]
            ].
            key == #Return ifTrue:[ 
                cmd := commandView contents string.
                subView insertLine:(Text string:('>> ' , cmd)
                            emphasis:(Array 
                                    with:#bold
                                    with:#underline
                                    with:(#color -> Color blue)))
                    before:(subView cursorLine).
                subView cursorDown:1.
                
                "/            subView insertStringAtCursor:cmd.
                "/            subView insertCharAtCursor:(Character cr).
                (cmd notEmptyOrNil) ifTrue:[ 
                    self class addToCommandHistory:cmd for:nil.
                    self doExecuteCommand:cmd replace:false.
                    commandView contents:nil.
                    commandIndex := 0
                ]
            ]
        ].

    "Modified: / 7.9.1995 / 15:48:45 / claus"
    "Modified: / 18.9.1997 / 16:55:01 / stefan"
    "Modified: / 10.12.2001 / 23:57:25 / cg"
!

initializeFilterPattern
    "set an initial matchpattern - can be redefined in subclasses"

    filterField model value:'*'
!

initializeInfoViewsFor:aTextView 
    "set up the contents view - can be redefined in subclasses for
     different view types (SoundFileBrowser/ImageBrowsers etc.)"
    
    |lineNrView colView modeView|

    commandView layout:(commandView layout rightOffset:(commandView layout rightOffset - 60)).

    modeView := Label in:commandView superView.
    modeView level:-1.
    modeView label:'m'.
    modeView layout:
        (LayoutFrame
            leftFraction:1 offset:-60
            rightFraction:1 offset:-50
            topFraction:1 offset:(commandView layout topOffset)
            bottomFraction:1 offset:0).

    modeView labelChannel:aTextView modeLabelHolder.
    modeView font:(Font family:'helvetica' face:'medium' style:'roman' size:10 encoding:nil).
    modeView sizeFixed:true.

    lineNrView := Label in:commandView superView.
    lineNrView level:-1.
    lineNrView label:'l'.
    lineNrView layout:
        (LayoutFrame
            leftFraction:1 offset:-50
            rightFraction:1 offset:-20
            topFraction:1 offset:(commandView layout topOffset)
            bottomFraction:1 offset:0).

    lineNrView labelChannel:(TypeConverter onNumberValue:aTextView cursorLineHolder).
    lineNrView font:(Font family:'helvetica' face:'medium' style:'roman' size:10 encoding:nil).
    lineNrView sizeFixed:true.

    colView := Label in:commandView superView.
    colView level:-1.
    colView label:'c'.
    colView layout:
        (LayoutFrame
            leftFraction:1 offset:-20
            rightFraction:1 offset:0
            topFraction:1 offset:(commandView layout topOffset)
            bottomFraction:1 offset:0).

    colView labelChannel:(TypeConverter onNumberValue:aTextView cursorColHolder).
    colView font:(Font family:'helvetica' face:'medium' style:'roman' size:10 encoding:nil).
    colView sizeFixed:true.
!

initializeSubViewIn:frame 
    "set up the contents view - can be redefined in subclasses for
     different view types (SoundFileBrowser/ImageBrowsers etc.)"
    
    |textView|

    textView := HVScrollableView 
                for:CodeView
                miniScrollerH:true
                miniScrollerV:false
                in:frame.
    textView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).

    "/    imagePreviewView := HVScrollableView 
    "/        for:ImageView 
    "/        miniScrollerH:true 
    "/        miniScrollerV:false 
    "/        in:frame.
    "/    imagePreviewView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    "/
    "/    imagePreviewView beInvisible.
    textView 
        doItAction:[ :theCode | 
            PositionableStream currentFileInDirectoryQuerySignal 
                answer:currentDirectory
                do:[ 
                    Compiler 
                        evaluate:theCode
                        in:nil
                        receiver:nil
                        notifying:textView
                        logged:true
                        ifFail:nil
                ]
        ].

    self initializeInfoViewsFor:textView.
    ^ textView.
!

postRealize
    super postRealize.
    self showOrHideTabView.

    "Created: 24.7.1997 / 18:13:46 / cg"
! !

!FileBrowser methodsFor:'menu actions'!

addBookmark
    self addBookmark:currentDirectory asFilename pathName
!

addBookmark:path
    AbstractFileBrowser addBookmark:path
!

copyCommandHistory
    "copy the command history to the clipBoard"

    self setClipboardText:(CommandHistory asStringCollection asString).

    "Modified: / 29.10.1998 / 12:17:14 / cg"
!

copyFileList
    "copy fileList to the clipBoard"

    self setClipboardText:(fileListView list 
                              collect:[:l | |ll|
                                        ll := l string withoutSeparators.
                                        (ll endsWith:' ...') ifTrue:[
                                            ll copyButLast:4
                                        ] ifFalse:[
                                            ll
                                        ]
                                      ]) 
                                asStringCollection asString.

    "Modified: / 17.8.1998 / 10:13:10 / cg"
!

copySelectedFileName
    "copy the selected filename to the clipBoard (for easy paste)"

    |sel fileName|

    sel := fileListView selection.
    sel size == 1 ifTrue:[
        fileName := fileList at:sel first.
        self setClipboardText:fileName
    ].
!

copySelectedPathName
    "copy the selected files pathname to the clipBoard (for easy paste)"

    |sel fileName|

    sel := fileListView selection.
    sel size == 1 ifTrue:[
        fileName := currentDirectory constructString:(fileList at:sel first).
        self setClipboardText:fileName
    ].
!

createProjectAndOpenProjectBrowser
    |nm f s|

    nm := currentDirectory baseName.
    f := (currentDirectory construct:nm) withSuffix:'prj'.
    f exists ifTrue:[
        self warn:'A file named ' , f baseName , ' alredy exists.'.
        ^ self.
    ].
    s := f writeStream.
    s nextPutAll:'
name            ''' , nm , '''
type            #classLibrary
package         #''private:' , nm , '''
prerequisites   nil

classes      #( )
'.
    s close.
    ProjectBrowser openOnFile:f.
!

menuExit
    self closeRequest

    "Created: / 4.8.1998 / 13:41:38 / cg"
!

menuOSCommand
    self fileExecute

    "Created: / 4.8.1998 / 14:06:54 / cg"
!

menuShowFileBrowserDocumentation

    "Created: / 4.8.1998 / 14:03:57 / cg"
!

openAboutThisApplication
    "opens an about box for this application."

    Dialog aboutClass:self class.

    "Modified: / 12-09-2006 / 17:20:41 / cg"
!

openHTMLDocument:relativeDocPath
    HTMLDocumentView openFullOnDocumentationFile:relativeDocPath

    "Created: / 4.8.1998 / 14:06:10 / cg"
!

pullDownMenu
    "return the top (pullDown) menu"

    <resource: #programMenu>

    ^ self menuFromSpec:self class menuSpec.
"/    |m|
"/
"/    m := self class menuSpec.
"/    m := m decodeAsLiteralArray.
"/    m receiver:self.
"/    m findGuiResourcesIn:self.
"/    ^ m.

    "Modified: / 14.8.1998 / 14:09:12 / cg"
    "Created: / 14.8.1998 / 14:14:16 / cg"
!

removeBookmark
    AbstractFileBrowser removeBookmark:(currentDirectory asFilename pathName)
!

showAboutSTX
    ToolApplicationModel openAboutSTX

    "Created: / 14.8.1998 / 13:18:41 / cg"
!

sortChanged
"/ Transcript show:'fBrowser:'; showCR:sortByWhat value.
    self updateCurrentDirectory

    "Created: / 14.8.1998 / 16:17:20 / cg"
    "Modified: / 14.8.1998 / 16:44:00 / cg"
! !

!FileBrowser methodsFor:'menu actions-cvs'!

cvsAddAndCommitSelection
    "add files (or all in current directory) and commit"

    self cvsAddSelectionWithCommit:true
!

cvsAddSelection
    "add files (or all in current directory)"

    self cvsAddSelectionWithCommit:false
!

cvsAddSelectionWithCommit:withCommit
    "add files (or all in current directory) with optional commit"

    |sel log|

    log := Dialog
        requestText:(resources string:'Enter initial log message')
        lines:10
        columns:70
        initialAnswer:nil.

    log notNil ifTrue:[
        sel := fileListView selection.
        sel size > 0 ifTrue:[
            sel := sel collect:[:rawIndex | fileList at:rawIndex].
            sel do:[:fn |
                self
                    doExecuteCommand:('cvs add -m ''' , log , ''' ' , fn) replace:false
            ]
        ] ifFalse:[
            self
                doExecuteCommand:('cvs add -l -m ''' , log , ''' *') replace:false
        ].
        withCommit ifTrue:[
            self doExecuteCommand:('cvs commit -l -m ''' , log , '''') replace:false
        ]
    ]
!

cvsCommitSelection
    "commit files (or all in current directory)"

    |nSel sel log msg|

    nSel := fileListView selection size.
    nSel == 1 ifTrue:[
        msg := resources string:'Enter log message for checkIn of "%1"' with:(fileList at:fileListView selection first) allBold
    ] ifFalse:[
        nSel > 1 ifTrue:[
            msg := resources string:'Enter log message for %1 files to checkIn' with:nSel printString
        ] ifFalse:[
            msg := resources string:'Enter log message for checkIn'
        ]
    ].

    log := Dialog
        requestText:msg
        lines:10
        columns:70
        initialAnswer:nil.

    log notNil ifTrue:[
        sel := fileListView selection.
        sel size > 0 ifTrue:[
            sel := sel collect:[:rawIndex | fileList at:rawIndex].
            sel do:[:fn |
                self
                    doExecuteCommand:('cvs commit -m ''' , log , ''' ' , fn) replace:false
            ]
        ] ifFalse:[
            self
                doExecuteCommand:('cvs commit -l -m ''' , log , '''') replace:false
        ].
    ]

    "Modified: / 16.12.1998 / 17:30:31 / cg"
!

cvsRemoveFileAndContainer
    "remove the selected file(s) and their CVS containers.
     Query if user really wants to really remove them."

    |sel q|

    sel := fileListView selection.
    sel size > 0 ifTrue:[
        sel := sel collect:[:rawIndex | fileList at:rawIndex].
        sel size > 1 ifTrue:[
            q := resources string:'Remove %1 selected files and their CVS containers ?' with:(sel size)
        ] ifFalse:[
            q := resources string:'Remove ''%1'' and its CVS container ?' with:(sel first allBold)
        ].
        (self sensor shiftDown
        or:[self ask:q yesButton:'Remove']) ifTrue:[
            self withCursor:(Cursor wait) do:[
                self doRemoveAndRemoveFromCVS:sel
            ]
        ]
    ]

    "Modified: / 16.12.1998 / 17:30:31 / cg"
!

cvsUpdateDirectoryLocal
    "update this directory"

    self
        doExecuteCommand:'cvs upd -l' replace:false

    "Modified: / 16.12.1998 / 17:30:31 / cg"
!

cvsUpdateDirectoryRecursive
    "update this directory"

    self
        doExecuteCommand:'cvs upd -d' replace:false

    "Modified: / 16.12.1998 / 17:30:31 / cg"
!

cvsUpdateSelection
    "update selected files"

    |sel|

    sel := fileListView selection.
    sel size > 0 ifTrue:[
        sel := sel collect:[:rawIndex | fileList at:rawIndex].
        sel do:[:fn |
            self
                doExecuteCommand:('cvs upd ' , fn) replace:false
        ]
    ].
!

doRemoveAndRemoveFromCVS:filesToRemove
    "remove the selected file(s) and their CVS containers - no questions asked"

    |msg idx needUpdate toRemove updateRunning yesToAll|

    updateRunning := listUpdateProcess notNil.
    self stopUpdateProcess.
    toRemove := OrderedCollection new.

    "/
    "/ did the directory change in the meanwhile ?
    "/
    needUpdate := (currentDirectory modificationTime > timeOfLastCheck).

    yesToAll := false.
    lockUpdate := true.
    [
        filesToRemove do:[:fileName |
            |f|

            f := currentDirectory construct:fileName.
            OsError handle:[:ex|
                "was not able to remove it"
                msg := (resources string:'cannot remove ''%1'' !!' with:fileName).
                self showAlert:msg with:(ex description)
            ] do:[
                |answer contents|

                f isSymbolicLink ifFalse:[
                    self
                        doExecuteCommand:('cvs remove -f ' , f baseName)
                        replace:false.

"
                self show:nil
"
                    idx := fileList indexOf:fileName.
                    idx ~~ 0 ifTrue:[
                        toRemove add:idx.
                    ]
                ]
            ].
        ].
    ] ensure:[
        lockUpdate := false.
        fileListView setSelection:nil.

        "/
        "/ remove reverse - otherwise indices are wrong
        "/
        toRemove sort.
        toRemove reverseDo:[:idx |
            fileList removeIndex:idx.
            fileListView removeIndex:idx.
        ].

        updateRunning ifTrue:[
            self updateCurrentDirectory
        ] ifFalse:[
            "
             install a new check after some time
            "
            needUpdate ifFalse:[timeOfLastCheck := Timestamp now].
            self scheduleCheckBlock.
        ]
    ].

    self
        doExecuteCommand:('cvs commit -m ''removed via FileBrowser''')
        replace:false.

    "Modified: / 21.10.1998 / 17:02:11 / cg"
! !

!FileBrowser methodsFor:'misc user interaction'!

closeRequest
    "asks for permission before closing"

    (self askIfModified:'Contents has not been saved.\\Modifications will be lost when FileBrowser is closed.'
              yesButton:'Close') 
    ifTrue:[
        "/ self windowGroup closeDownViews.
        super closeRequest
    ]

    "Created: / 3.8.1998 / 19:55:06 / cg"
    "Modified: / 4.8.1998 / 18:21:03 / cg"
!

discardChangesDialog
    "ask the user if changes should be discarded,
     return true if changes should be discarded, false otherwise"

    ^ self askIfModified:'Contents has not been saved.\\Modifications will be lost when directory is changed.'
               yesButton:'Change'

    "Created: 2.10.1997 / 14:08:37 / stefan"
!

entryCompletion:contents
    |newString lastWord expandedWord idx onlyOne addSpace fn|

    "/ find the last word.
    "/ used to be 'contents asCollectionOfWords last',
    "/ but we have to care for escaped spaces here (unix) ...

    idx := contents size.
    OperatingSystem isUNIXlike ifFalse:[
        "/ under MSDOS, the backslash is a directory separator
        idx := contents lastIndexOf:Character space startingAt:idx.
    ] ifTrue:[
        "/ under UNIX, the backslash is a special character escape
        idx := idx + 1.
        [
            idx := contents lastIndexOf:Character space startingAt:idx-1.
        ] doWhile:[
            idx > 1 and:[ (contents at:idx-1) = $\ ]
        ].
    ].
"/    idx == 0 ifTrue:[
"/        commandView flash.
"/        ^ nil.
"/    ].

    lastWord := contents copyFrom:idx + 1.
    OperatingSystem isUNIXlike ifTrue:[
        (lastWord includes:$\) ifTrue:[
            lastWord := lastWord copyReplaceAll:$\ withAll:''.
        ].
    ].

    onlyOne := true.
    expandedWord := Filename 
                    filenameCompletionFor:lastWord 
                    directory:currentDirectory 
                    directoriesOnly:false 
                    filesOnly:false 
                    ifMultiple:[:dir | onlyOne := false. commandView flash.].

    addSpace := false.
    onlyOne ifTrue:[
        fn := currentDirectory construct:expandedWord.
        (fn exists and:[fn isDirectory not]) ifTrue:[
            addSpace := true.
        ].
    ].

    OperatingSystem isUNIXlike ifTrue:[
        expandedWord := expandedWord copyReplaceAll:(Character space) withAll:'\ '.
        expandedWord := expandedWord copyReplaceAll:($') withAll:'\'''.
        expandedWord := expandedWord copyReplaceAll:($() withAll:'\('.
        expandedWord := expandedWord copyReplaceAll:($)) withAll:'\)'.
        expandedWord := expandedWord copyReplaceAll:($[) withAll:'\['.
        expandedWord := expandedWord copyReplaceAll:($]) withAll:'\]'.
        expandedWord := expandedWord copyReplaceAll:($&) withAll:'\&'.
        expandedWord := expandedWord copyReplaceAll:($|) withAll:'\|'.
        expandedWord := expandedWord copyReplaceAll:($;) withAll:'\;'.
    ].

    addSpace ifTrue:[
        expandedWord := expandedWord , ' '
    ].
    newString := (contents copyTo:idx) ,  expandedWord.

    ^ newString
!

filterPatternChanged
    fileListView scrollToTop.
    fileListView deselect.
    self updateCurrentDirectory

    "Modified: / 3.10.1998 / 18:23:34 / cg"
!

update:what with:someArgument from:changedObject
    realized ifFalse:[^ self].

    (what == #aboutToQuit) ifTrue:[
        "system wants to shut down this
         - if text was modified, pop up, and ask user and save if requested."

        (subView modified and:[subView contentsWasSaved not]) ifTrue:[
            self raiseDeiconified.

            (self 
                ask:(resources string:'FileBrowser:\\contents has not been saved.\\Save before exiting ?')
                yesButton:'save'
                noButton:'don''t save')
            ifTrue:[
                subView acceptAction notNil ifTrue:[
                    subView accept
                ] ifFalse:[
                    subView save
                ]
            ]
        ].
        ^ self
    ].
    changedObject == tabSpec ifTrue:[
        fileListView invalidate
    ].

    "Modified: 29.5.1996 / 16:13:43 / cg"
! !

!FileBrowser methodsFor:'pathField user interaction'!

addDirToJavaClassPath
    "add the current path to javas classPath
     (only available with ST/J System"

    Java addToClassPath:currentDirectory pathName

    "Modified: 14.12.1996 / 15:37:47 / cg"
    "Created: 1.8.1997 / 21:25:22 / cg"
!

addDirToJavaSourcePath
    "add the current path to java's sourcePath
     (only available with ST/J System"

    Java addToSourcePath:currentDirectory pathName

    "Modified: 14.12.1996 / 15:37:47 / cg"
    "Created: 2.8.1997 / 14:11:19 / cg"
!

bookmarksMenu
    "return the bookmarksMenu for the path label"

    <resource: #programMenu>

    ^ self menuFromSpec:(self class bookmarksMenuSpec).
!

changeCurrentDirectory
    "if text was modified show a queryBox, 
     otherwise ask for & change to that directory"

"/    self discardChangesDialog ifTrue:[
        self queryForDirectoryToChange
"/    ]

    "Modified: 21.9.1997 / 23:45:35 / cg"
    "Modified: 2.10.1997 / 14:09:02 / stefan"
!

changeDirectoryTo:aDirectoryName
    "sent from label menu to change back to a previous directory"

    self discardChangesDialog ifTrue:[
        self doChangeCurrentDirectoryTo:aDirectoryName updateHistory:true "/false.
    ].

    "Modified: / 2.10.1997 / 14:09:24 / stefan"
    "Modified: / 21.7.1998 / 16:38:03 / cg"
!

changeToDefaultDirectory
    "if text was modified show a queryBox, 
     otherwise change immediately to the default directory"

    self discardChangesDialog ifTrue:[
         self doChangeToDefaultDirectory
    ]

    "Modified: 21.9.1997 / 23:45:04 / cg"
    "Modified: 2.10.1997 / 14:09:33 / stefan"
!

changeToHomeDirectory
    "if text was modified show a queryBox, 
     otherwise change immediately to the home directory"

    self discardChangesDialog ifTrue:[
         self doChangeToHomeDirectory
    ]

    "Modified: 21.9.1997 / 23:45:10 / cg"
    "Modified: 2.10.1997 / 14:09:42 / stefan"
!

changeToParentDirectory
    "if text was modified show a queryBox, 
     otherwise change immediately to the parent directory"

    self discardChangesDialog ifTrue:[
         self doChangeToParentDirectory
    ]

    "Modified: 21.9.1997 / 23:45:15 / cg"
    "Modified: 2.10.1997 / 14:09:55 / stefan"
!

copyPath
    "copy current path into cut & paste buffer"

    self setClipboardText:currentDirectory pathName

    "Modified: 14.12.1996 / 15:37:47 / cg"
!

fileAddToJavaClassPath
    "add the current path to javas classPath
     (only available with ST/J System"

    |f|

    f := self getSelectedFileName.
    f isNil ifTrue:[
        ^ self addDirToJavaClassPath
    ].
    f := currentDirectory construct:f.
    Java addToClassPath:(f pathName)

    "Created: / 9.11.1998 / 05:41:34 / cg"
    "Modified: / 9.11.1998 / 05:56:00 / cg"
!

fileAddToJavaSourcePath
    "add the current path to java's sourcePath
     (only available with ST/J System"

    |f|

    f := self getSelectedFileName.
    f isNil ifTrue:[
        ^ self addDirToJavaSourcePath
    ].
    f := currentDirectory construct:f.
    Java addToSourcePath:(f pathName)

    "Created: / 9.11.1998 / 05:41:34 / cg"
    "Modified: / 9.11.1998 / 05:56:00 / cg"
!

fileRemoveFromJavaClassPath
    "remove the current path from javas classPath
     (only available with ST/J System"

    |f|

    f := self getSelectedFileName.
    f isNil ifTrue:[
        ^ self removeDirFromJavaClassPath
    ].
    f := currentDirectory construct:f.
    Java removeFromClassPath:(f pathName)

    "Created: / 9.11.1998 / 05:42:05 / cg"
    "Modified: / 9.11.1998 / 05:56:14 / cg"
!

fileRemoveFromJavaSourcePath
    "remove the current path from javas sourcePath
     (only available with ST/J System"

    |f|

    f := self getSelectedFileName.
    f isNil ifTrue:[
        ^ self removeDirFromJavaSourcePath
    ].
    f := currentDirectory construct:f.
    Java removeFromSourcePath:(f pathName)

    "Created: / 9.11.1998 / 05:42:05 / cg"
    "Modified: / 9.11.1998 / 05:56:14 / cg"
!

historyMenuSpec
    "return the historyMenu for the path label"

    <resource: #programMenu>

    ^ self menuFromSpec:(self class historyMenuSpec).
!

labelMenu
    "return the popUpMenu for the path label"

    <resource: #programMenu>

    |m|

    m := self menuFromSpec:(self class directoryMenuSpec).
    ^ m
!

labelMenu_old
    "return the popUpMenu for the path label"

    <resource: #programMenu>

    |items menu currentIndex directoryHistory currentDirectoryPathName|

    items := #(
                   ('copy path'                   copyPath                  )
                   ('-'                                                     )
                   ('up'                          changeToParentDirectory   )
                   ('back'                        changeToPreviousDirectory )
                   ('change to home-directory'    changeToHomeDirectory     )
                   ('change to default-directory' changeToDefaultDirectory  )
                   ('change directory ...'        changeCurrentDirectory    )
               ).             

    (JavaClassReader notNil and:[JavaClassReader isLoaded]) ifTrue:[
        items := items , #(
                            ( '-')
                            ( 'add to JavaClassPath'       addDirToJavaClassPath)
                            ( 'add to JavaSourcePath'      addDirToJavaSourcePath)
                            ( 'remove from JavaClassPath'  removeDirFromJavaClassPath)
                            ( 'remove from JavaSourcePath' removeDirFromJavaSourcePath)
                          ).
    ].

    (directoryHistory := self class directoryHistory) size > 0 ifTrue:[
        items := items copyWith:#('-').
        items := items ,
                 (directoryHistory 
                        collect:[:dirName |
                                    Array 
                                        with:dirName 
                                        with:#changeDirectoryTo:
                                        with:nil
                                        with:dirName
                                ]
                 ).
        currentDirectoryPathName := currentDirectory pathName.
        currentIndex := items findFirst:[:i | (i at:1) = currentDirectoryPathName].
        currentIndex == 0 ifTrue:[currentIndex := nil].
    ].

    menu := PopUpMenu 
                itemList:items
                resources:resources.

    previousDirectory isNil ifTrue:[
        menu disable:#changeToPreviousDirectory.
    ].
    currentIndex notNil ifTrue:[
        menu disable:currentIndex
    ].
    (JavaClassReader notNil and:[JavaClassReader isLoaded]) ifTrue:[
        (Java classPath includes:currentDirectory pathName) ifTrue:[
            menu disable:#addDirToJavaClassPath
        ] ifFalse:[
            menu disable:#removeDirFromJavaClassPath
        ].
        (Java sourcePath includes:currentDirectory pathName) ifTrue:[
            menu disable:#addDirToJavaSourcePath
        ] ifFalse:[
            menu disable:#removeDirFromJavaSourcePath
        ].
    ].
    ^menu.

    "Modified: / 21.7.1998 / 16:43:25 / cg"
    "Created: / 14.8.1998 / 12:10:02 / cg"
!

pathChanged:newPath
    "change directory to newPath. If newPath is a filename, change
     to its directory and get get the file."

    |f name lcName idx|

    self discardChangesDialog ifTrue:[
        f := newPath asFilename.
        (f isDirectory) ifTrue:[
            self changeDirectoryTo:newPath
        ] ifFalse:[
            self changeDirectoryTo:(f directoryName).
"/            self changed:#path.
            name := f baseName.
            idx := fileList indexOf:name.
            idx = 0 ifTrue:[
                lcName := name asLowercase.
                f class isCaseSensitive ifFalse:[
                    idx := fileList findFirst:[:nm | nm asLowercase = lcName].
                ]
            ].
            fileListView selection:idx.
            self fileSelect:name.
            self fileGet:true.
        ].
    ] ifFalse:[
        self changed:#path.
    ].

    "Created: / 21.9.1997 / 10:43:12 / cg"
    "Modified: / 7.10.1997 / 14:10:39 / stefan"
    "Modified: / 30.4.1999 / 11:19:29 / cg"
!

queryForDirectoryToChange
    "query for new directory"

    |queryBox dirName|

    queryBox := FilenameEnterBox 
                    title:(resources stringWithCRs:'Change directory to:')
                    okText:(resources string:'Change')
                    action:[:newName | dirName := newName].
"/    queryBox initialText:''.
    queryBox show.
    queryBox destroy.
    dirName size == 0 ifTrue:[^ self].

    self discardChangesDialog ifTrue:[
        self doChangeCurrentDirectoryTo:dirName updateHistory:true.
    ].

    "Modified: 28.4.1997 / 19:50:52 / cg"
    "Modified: 28.4.1997 / 22:30:40 / dq"
!

removeDirFromJavaClassPath
    "remove the current path from javas classPath
     (only available with ST/J System"

    Java removeFromClassPath:currentDirectory pathName

    "Modified: 14.12.1996 / 15:37:47 / cg"
    "Created: 1.8.1997 / 21:25:36 / cg"
!

removeDirFromJavaSourcePath
    "remove the current path from javas sourcePath
     (only available with ST/J System"

    Java removeFromSourcePath:currentDirectory pathName

    "Modified: 14.12.1996 / 15:37:47 / cg"
    "Created: 2.8.1997 / 14:11:41 / cg"
! !

!FileBrowser methodsFor:'private'!

ask:question yesButton:yesButtonText
    "common method to ask a yes/no question; return true or false"

    ^ self ask:question yesButton:yesButtonText noButton:'Cancel' 
!

ask:question yesButton:yesButtonText noButton:noButtonText
    "common method to ask a yes/no question"

    ^ Dialog 
        confirm:question withCRs
        yesLabel:(resources string:yesButtonText)
        noLabel:(resources string:noButtonText)

    "Modified: 21.2.1996 / 01:19:21 / cg"
!

askForCommandFor:fileName thenDo:aBlock
    "setup and launch a querybox to ask for unix command.
     Then evaluate aBlock passing the command-string as argument."

    |box osName commandString|

    osName := OperatingSystem platformName.

    box := FilenameEnterBox 
                title:(resources string:'Execute %1 command:' with:osName)
               okText:(resources string:'Execute')
               action:[:cmd | commandString := cmd].

    fileName notNil ifTrue:[
        self initialCommandFor:fileName into:box.
    ].
    box directory:currentDirectory.
    box show.
    box destroy.

    commandString notNil ifTrue:[
        aBlock value:commandString
    ].

    "Modified: / 7.9.1995 / 10:31:54 / claus"
    "Modified: / 16.9.1997 / 15:35:10 / stefan"
    "Modified: / 14.8.1998 / 14:12:52 / cg"
!

askIfModified:question yesButton:yesButtonText
    "tell user, that code has been modified - let her confirm"

    (subView modified not or:[subView contentsWasSaved]) ifTrue:[
        ^ true
    ].
    (self ask:(resources string:question) yesButton:yesButtonText) ifTrue:[
        "/ reset modified flag so question is asked only once
        subView modified:false.
        ^ true
    ].
    ^ false

    "Modified: 2.10.1997 / 14:23:47 / stefan"
!

getSelectedFileName
    "returns the currently selected file; shows an error if
     multiple files are selected"

    |sel|

    sel := fileListView selection.
    (sel size > 1) ifTrue:[
        self onlyOneSelection
    ] ifFalse:[
        sel size > 0 ifTrue:[
            ^ fileList at:sel first ifAbsent:nil
        ]
    ].
    ^ nil

    "Modified: / 3.10.1998 / 18:21:23 / cg"
!

onlyOneSelection
    "show a warning, that only one file must be selected for
     this operation"

    self warn:'exactly one file must be selected !!'
!

scheduleCheckBlock
    Processor removeTimedBlock:checkBlock.
    self windowGroup isNil ifTrue:[
        "/ not yet opened
        Processor 
            addTimedBlock:checkBlock 
            afterSeconds:checkDelta
    ] ifFalse:[
        Processor 
            addTimedBlock:checkBlock 
            for:(self windowGroup process)
            afterSeconds:checkDelta
    ]
!

selectFile:aFilename
    (currentDirectory filenameFor:aFilename) exists ifTrue:[
        fileListView selection:(fileList indexOf:aFilename).
        self fileDoubleClick:fileListView selection.
    ].
!

selectedFilesDo:aBlock
    "evaluate aBlock on all selected files;
     show a wait cursor while doing this"

    |sel action|

    sel := fileListView selection.
    sel notNil ifTrue:[
        sel := sel collect:[:aSelectionIndex | 
            |nm|

            nm := fileList at:aSelectionIndex ifAbsent:nil.
            nm notNil ifTrue:[
                nm := nm string.
                (nm endsWith:' ...') ifTrue:[
                    nm := (nm copyButLast:4) withoutSpaces
                ].
            ].
            nm
        ].
        action := [
            sel do:[:nm |
                nm notNil ifTrue:[
                    aBlock value:nm
                ]
            ]
        ].
        Processor activeProcess == self windowGroup process ifTrue:[
            self withWaitCursorDo:action
        ] ifFalse:[
            action value
        ]
    ]

    "Modified: / 16.12.1998 / 17:30:57 / cg"
!

show:something
    "show something in subview and undef acceptAction"

    subView contents:something.
    subView acceptAction:nil.
    subView modified:false.
    currentFileName := nil
!

showAlert:aString with:anErrorString
    "show an alertbox, displaying the last Unix-error"

    |msg|

    anErrorString isNil ifTrue:[
        msg := aString
    ] ifFalse:[
        msg := aString , '\\(' , anErrorString , ')'
    ].
    self warn:msg withCRs
!

withoutHiddenFiles:aCollection
    "remove hidden files (i.e. those that start with '.') from
     the list in aCollection"

    showingHiddenFiles value ifTrue:[
        ^ aCollection
    ].
    ^ aCollection reject:[:fn | fn asFilename isHidden].
! !

!FileBrowser methodsFor:'private-actions & command execution'!

binaryFileAction:aFilename
    "for some binary files, if double clicked, we can do some useful
     action ..."

    |cmd|

    (aFilename asFilename hasSuffix:'pdf') ifTrue:[
        cmd := MIMETypes defaultCommandPerMIME at:'application/pdf' ifAbsent:nil.
        cmd notNil ifTrue:[
            (OperatingSystem 
                executeCommand:(cmd bindWith:aFilename with:Screen current displayName) 
                inDirectory:currentDirectory)
            ifTrue:[^true].
        ].
    ].

    (currentDirectory construct:aFilename) isExecutableProgram ifTrue:[
        (OperatingSystem executeCommand:aFilename inDirectory:currentDirectory)
        ifTrue:[^true].
    ].
    ^ self imageAction:aFilename

    "Modified: 19.6.1996 / 09:44:07 / cg"
    "Modified: 18.9.1997 / 17:18:04 / stefan"
!

doExecuteCommand:commandArg replace:replace
    "execute a unix command inserting the output of the command.
     If replace is true, all text is replaced by the commands output;
     otherwise, its inserted as selected text at the cursor position."

    |command stream line lnr myProcess startLine startCol stopSignal
     pauseSignal access stillReplacing pauseHolder lowerFrameView
     buttonWindowGroup|

    command := commandArg asString.

    access := Semaphore forMutualExclusion name:'accessLock'.
    stopSignal := Signal new.
    pauseSignal := Signal new.

    "
     The following is tricky: 
     the pauseToggle & killButton will
     be handled by their own windowGroup process.
     This means, that they respond to events even though
     I myself am reading the commands output.
    "

    commandView beInvisible.

    "
     must take kill & pauseButtons out of my group
    "
    killButton windowGroup:nil.
    pauseToggle windowGroup:nil.

    "
     bring them to front, and turn hidden-mode off
    "
    killButton raise; beVisible.
    pauseToggle raise; beVisible.

    "
     kill will make me raise the stopSignal when pressed
    "
    killButton 
        action:[
            stream notNil ifTrue:[
                access critical:[
                    myProcess interruptWith:[stopSignal raiseRequest].
                ]
            ]
        ].

    "
     pause makes me stop reading the commands output
    "
    pauseHolder := false asValue.
    pauseToggle model:pauseHolder.
    pauseToggle pressAction:[
        stream notNil ifTrue:[
            access critical:[
                myProcess interruptWith:[pauseSignal raiseRequest].
            ]
        ]
    ].


    "
     start kill button under its own windowgroup
    "
    killButton openAutonomous.
    buttonWindowGroup := killButton windowGroup.
    buttonWindowGroup process name:'FileBrowser sub'.
    buttonWindowGroup process processGroupId:(Processor activeProcessId).

    "
     and add the pauseToggle to its windowGroup
    "
    pauseToggle windowGroup:buttonWindowGroup.


    lowerFrameView := subView superView.

    "
     go fork a pipe and read it
    "
    self label:(myName , ': executing ' , (command copyTo:(20 min:command size)) , ' ...').
    [
      self withWaitCursorDo:[
        stopSignal catch:[
            pauseSignal handle:[:ex|
                |noPauseSema|

                "/    
                "/ allow interaction with
                "/ the codeView via the other windowGroup
                "/
                lowerFrameView windowGroup:buttonWindowGroup.

                "/
                "/ wait for pause to be turned off
                "/
                noPauseSema := Semaphore new.
                pauseHolder onChangeSend:#signal to:noPauseSema.
                noPauseSema wait.

                "/    
                "/ no interaction with the codeView ...
                "/
                lowerFrameView windowGroup:(self windowGroup).
                ex proceed.
            ] do:[
                startLine := subView cursorLine.
                startCol := subView cursorCol.

                "
                 this can be a time consuming operation; therefore lower my priority
                "
                myProcess := Processor activeProcess.
"/                myPriority := myProcess priority.
"/                myProcess priority:(Processor userBackgroundPriority).

                stream := PipeStream 
                            readingFrom:command
                            errorDisposition:#inline
                            inDirectory:currentDirectory.
                stream notNil ifTrue:[
                    [
                        |codeView lines noPauseSema enc|

                        enc := fileEncoding.
                        enc == #iso8859 ifTrue:[
                            enc := nil
                        ].

                        codeView := subView.
                        codeView unselect.

                        replace ifTrue:[
                            codeView list:nil.
                            lnr := 1.
                        ].

                        stillReplacing := replace.

                        [
                            stream readWaitWithTimeout:1.
                            stream atEnd not
                        ] whileTrue:[
                            "
                             data available; read up to 100 lines
                             and insert as a single junk. This speeds up
                             display of long output (less line-scrolling).
                            "
                            lines := OrderedCollection new:100.

                            [
                                line := stream nextLine.
                                line notNil ifTrue:[
                                    enc notNil ifTrue:[
                                        line := line decodeFrom:enc
                                    ].
                                    lines add:line
                                ].
                            ] doWhile:[
                                stream pid notNil
                                and:[stream canReadWithoutBlocking
                                and:[stream atEnd not
                                and:[lines size < 100]]]
                            ]. 

                            "
                             need this critical section; otherwise,
                             we could get the signal while waiting for
                             an expose event ...
                            "
                            access critical:[                        
                                lines size > 0 ifTrue:[
                                    stillReplacing ifTrue:[
                                        lines do:[:line |
                                            codeView at:lnr put:line withTabsExpanded.
                                            codeView cursorToBottom; cursorDown:1.
                                            lnr := lnr + 1.
                                            lnr > codeView list size ifTrue:[
                                                stillReplacing := false
                                            ]
                                        ].
                                    ] ifFalse:[
                                        codeView insertLines:lines before:codeView cursorLine.
                                        codeView cursorDown:lines size.
                                    ]
                                ].
                            ].

                            "
                             give others running at same prio a chance too
                             (especially other FileBrowsers doing the same)
                            "
                            Processor yield
                        ].
                    ] ensure:[
                        stream abortAndClose. stream := nil.
                    ].

                    "/
                    "/ the command could have changed the directory
                    "/
                    self updateCurrentDirectoryIfChanged
                ].
                replace ifTrue:[
                    subView modified:false.
                ].
            ]
        ]
      ]
    ] ensure:[
        |wg|

        self label:myName; iconLabel:myName.
"/        myProcess notNil ifTrue:[myProcess priority:myPriority].

        "
         hide the button, and make sure it will stay
         hidden when we are realized again
        "
        killButton beInvisible.
        pauseToggle beInvisible.

        commandView beVisible.

        "
         remove the killButton from its group
         (otherwise, it will be destroyed when we shut down the group)
        "
        wg := killButton windowGroup.
        killButton windowGroup:nil.
        pauseToggle windowGroup:nil.

        "
         shut down the kill buttons windowgroup
        "
        wg notNil ifTrue:[
            wg process terminate.
        ].
        "
         clear its action (actually not needed, but
         releases reference to thisContext earlier)
        "
        killButton action:nil.
        pauseToggle pressAction:nil.
        "/    
        "/ allow interaction with the codeView
        "/ (bring it back into my group)
        "/
        lowerFrameView windowGroup:(self windowGroup).
    ].

    currentFileName isNil ifTrue:[
        subView modified:false.
    ].

    subView size > 10000 ifTrue:[
        self warn:'text quite large now - please cut off some lines'
    ]

    "Modified: / 21.9.1995 / 11:18:46 / claus"
    "Modified: / 6.3.1998 / 17:32:03 / stefan"
    "Modified: / 15.10.1998 / 12:37:52 / cg"
!

imageAction:aFilename
    "for some image files, if double clicked, we can do some useful
     action ..."

    |file img errmsg|

    file := currentDirectory construct:aFilename.

    (Image isImageFileSuffix:(file suffix))
    ifTrue:[
        Image imageLoadErrorSignal handle:[:ex | 
"/            ex signal ~~ Image badImageFormatQuerySignal 
"/            ifTrue:[
                errmsg := ex description
"/            ]
        ] do:[
            img := Image fromFile:file.
        ].
        img notNil ifTrue:[
            ImageEditor openOnImage:img.
"/            img inspect.
            ^ true
        ].
        errmsg notNil ifTrue:[
            self warn:errmsg.
        ]
    ].
    ^ false

    "Created: / 19.6.1996 / 09:43:50 / cg"
    "Modified: / 18.9.1997 / 16:35:48 / stefan"
    "Modified: / 18.5.1999 / 15:45:06 / cg"
!

initialCommandFor:fileName into:aBox
    "set a useful initial command in execute-command box."

    AbstractFileBrowser initialCommandFor:fileName in:currentDirectory intoBox:aBox.
!

nonBinaryFileAction:aFilename
    "for some nonBinary files, if double clicked, we can do some useful
     action ..."

    |fullPath|

    fullPath := currentDirectory filenameFor:aFilename.
    ((fullPath hasSuffix:'htm')
    or:[(fullPath hasSuffix:'HTM') 
    or:[(fullPath hasSuffix:'html')
    or:[(fullPath hasSuffix:'HTML')]]]) ifTrue:[
        HTMLDocumentView openOn:fullPath pathName.
        ^ true
    ].
    ((fullPath hasSuffix:'prj')  
    and:[ProjectBrowser notNil]) ifTrue:[
        ProjectBrowser openOnFile:fullPath pathName.
        ^ true
    ].

    OperatingSystem isUNIXlike ifTrue:[
        (#('.man' '.1' '.2' '.3') findFirst:[:suff | fullPath hasSuffix:suff]) ~~ 0 
        ifTrue:[
            HTMLDocumentView openFullOnText:(HTMLDocGenerator manPageForFile:fullPath pathName).
            ^ true
        ].
    ].
    ^ self imageAction:aFilename

    "Created: 19.6.1996 / 09:36:38 / cg"
    "Modified: 4.4.1997 / 10:49:00 / cg"
    "Modified: 18.9.1997 / 16:58:40 / stefan"
! !

!FileBrowser methodsFor:'private-directory stuff'!

changeToPreviousDirectory
    "if text was modified show a queryBox, 
     otherwise change immediately to previous directory."

    previousDirectory isNil ifTrue:[^ self].
    self discardChangesDialog ifTrue:[
        self doChangeCurrentDirectoryTo:previousDirectory updateHistory:false 
    ]

    "Modified: 2.10.1997 / 14:13:40 / stefan"
!

checkIfDirectoryHasChanged
    "every checkDelta secs, check if directoy has changed and update the list if so.
     Also, we check if the file shown has been touched in the meanwhile (for example,
     from another browser) and say 'outdated' in the label if so. 
     This avoids confusion if the same file is being edited by two browsers. (or other editors).
     If the text shown in the codeView has been edited, 'modified' is shown.
    "

    |oldSelection nOld newState msg newLabel t|

    shown ifTrue:[
        currentDirectory notNil ifTrue:[
            (lockUpdate or:[doAutoUpdate value not]) ifTrue:[
                self scheduleCheckBlock.
                ^ self
            ].

            subView modified ifTrue:[
                newState := ' (modified)'
            ].

            (currentDirectory isReadable) ifTrue:[
                Processor removeTimedBlock:checkBlock.

                t := currentDirectory modificationTime.
                (t notNil and:[t > timeOfLastCheck]) ifTrue:[
                    nOld := fileListView numberOfSelections.
                    oldSelection := fileListView selectionValue.
                    self updateCurrentDirectory.
                    nOld ~~ 0 ifTrue:[
                        nOld > 1 ifTrue:[
                            oldSelection do:[:element  |
                                fileListView addElementToSelection:element
                            ]
                        ] ifFalse:[
                            fileListView selectElementWithoutScroll:oldSelection
                        ]
                    ].
                ] ifFalse:[
                    self scheduleCheckBlock.
                ].

                currentFileName notNil ifTrue:[
                    |f mod|
                    f := currentDirectory construct:currentFileName.
                    (f exists not or:[(mod := f modificationTime) isNil]) ifTrue:[
                        newState := ' (removed)'.
                    ] ifFalse:[
                        mod > timeOfFileRead ifTrue:[
                            newState := ' (outdated)'.
                            subView modified ifTrue:[
                                newState := ' (modified & outdated)'
                            ]
                        ].
                    ].
                ].
            ] ifFalse:[         
                "
                 if the directory has been deleted, or is not readable ...
                "
                (currentDirectory exists) ifFalse:[
                    msg := 'FileBrowser:\\directory %1 is gone ?!!?'
                ] ifTrue:[
                    msg := 'FileBrowser:\\directory %1 is no longer readable ?!!?'
                ].
                "/ sigh - avoid translating backslashes in WIN-filenames
                msg := resources stringWithCRs:msg with:currentDirectory pathName allBold.
                Dialog warn:msg.

                fileListView contents:nil.
                newLabel := myName , ': directory is gone !!'.
            ].

            newState notNil ifTrue:[
                newLabel := myName.
                currentFileName notNil ifTrue:[
                    newLabel := newLabel , ': ' , currentFileName
                ].
                newLabel := newLabel , newState.
            ].
            newLabel notNil ifTrue:[
                self label:newLabel.
            ]
        ]
    ]

    "Modified: / 28.4.1997 / 22:31:02 / dq"
    "Modified: / 16.9.1997 / 15:17:15 / stefan"
    "Modified: / 15.11.2001 / 21:27:05 / cg"
!

doChangeCurrentDirectoryTo:fileName updateHistory:updateHistory 
    "verify argument is name of a readable & executable directory
     and if so, go there"

    |msg path f pos|

    self label:myName; iconLabel:myName.
    fileName notNil ifTrue:[
        (f := fileName asFilename) isAbsolute ifFalse:[
            f := currentDirectory filenameFor:fileName.
        ].
        f := f asAbsoluteFilename.
        (f isDirectory) ifTrue:[
            (f isReadable) ifTrue:[
                (f isExecutable) ifTrue:[
                    path := currentDirectory pathName.
                    previousDirectory := path.

                    "
                     remember where we are positioned in the fileList
                     (in case we want to return)
                    "
                    self directoryHistory setPosition:(fileListView firstLineShown) for:path.

                    updateHistory ifTrue:[
                        self directoryHistory addToHistory:path.
                    ].

                    self setCurrentDirectory:(f pathName).

                    "/ fetch the new path.
                    path := currentDirectory pathName.

                    "
                     if we have already been there, look for the
                     position offset, and scroll the fileList
                    "
                    pos := self directoryHistory getPositionFor:path.
                    pos notNil ifTrue:[
                        fileListView scrollToLine:pos.
                    ].

                    updateHistory ifTrue:[
                        self directoryHistory addToHistory:path.
                    ].

                    ^ self
                ].
                msg := 'cannot change directory to ''%1'' !!'
            ] ifFalse:[
                msg := 'cannot read directory ''%1'' !!'
            ]
        ] ifFalse:[
            OperatingSystem isVMSlike ifTrue:[
                "/ cannot tell if it exists or is simply invisible ...
                msg := '''%1'' is not a directory or unreadable !!'
            ] ifFalse:[
                msg := '''%1'' is not a directory !!'
            ]
        ].
        msg := resources stringWithCRs:msg with:fileName allBold.
        Dialog warn:msg.
    ]

    "Modified: / 18.9.1997 / 18:22:30 / stefan"
    "Modified: / 27.4.1999 / 17:10:14 / cg"
!

doChangeToDefaultDirectory
    "go to parent directory"

    self doChangeCurrentDirectoryTo:(Filename currentDirectory pathName) updateHistory:true

    "Created: 21.9.1997 / 23:45:59 / cg"
!

doChangeToHomeDirectory
    "go to home directory"

    self doChangeCurrentDirectoryTo:(OperatingSystem getHomeDirectory) updateHistory:true
!

doChangeToParentDirectory
    "go to parent directory"

    self doChangeCurrentDirectoryTo:'..' updateHistory:true
!

doCreateDirectory:newName
    |f|

    f := currentDirectory filenameFor:newName.
    f exists ifTrue:[
        self warn:'%1 already exists.' with:newName.
        ^ self
    ].

    f makeDirectory ifTrue:[
        self updateCurrentDirectory
    ] ifFalse:[
        self showAlert:(resources string:'cannot create directory ''%1'' !!' with:newName)
                  with:(OperatingSystem lastErrorString)
    ]

    "Modified: / 18.9.1997 / 17:21:25 / stefan"
    "Modified: / 30.1.1999 / 16:24:12 / cg"
!

setCurrentDirectory:aPathName
    "setup for another directory"

    |newDirectory|

    aPathName isEmpty ifTrue:[^ self].
    newDirectory := currentDirectory filenameFor:aPathName.
    newDirectory isDirectory ifTrue:[
        self currentDirectory:newDirectory.
        currentFileName notNil ifTrue:[
            fileListView contents:nil.
            currentFileName := nil.
        ] ifFalse:[
            fileListView setSelection:nil.
            fileListView scrollToTop.
        ].
        self updateCurrentDirectory.
        self showInfo.
    ]

    "Modified: 21.9.1995 / 11:22:45 / claus"
    "Modified: 25.5.1996 / 12:27:01 / cg"
    "Modified: 18.9.1997 / 17:08:07 / stefan"
!

updateCurrentDirectoryIfChanged
    |t|

    OperatingSystem isMSDOSlike ifTrue:[
        "/ workaround: DOS has no directory modifiation time ...
        self updateCurrentDirectory.
        ^ self
    ].

    ((t := currentDirectory modificationTime) isNil
    or:[t > timeOfLastCheck]) ifTrue:[
        self updateCurrentDirectory
    ]

    "Modified: / 16.9.1997 / 15:35:52 / stefan"
    "Modified: / 16.12.1998 / 22:55:44 / cg"
! !

!FileBrowser methodsFor:'private-file I/O'!

readFile:fileName
    "read in the file, answer its contents as StringCollection"

    ^ self readFile:fileName lineDelimiter:Character cr encoding:nil

    "Modified: 22.2.1996 / 14:57:08 / cg"
!

readFile:fileName lineDelimiter:aCharacter encoding:encoding
    "read in the file, return its contents as StringCollection. 
     The file's lines are delimited by aCharacter.
     If encoding is nonNil, the file is assumed to be coded according to
     that symbol, and #decodeString: should be able to convert it."

    |f stream text msg sz|

    (f := fileName asFilename) isAbsolute ifFalse:[
        f := (currentDirectory construct:fileName)
    ].
    stream := f readStreamOrNil.
    stream isNil ifTrue:[
        msg := (resources string:'cannot read file ''%1'' !!' with:fileName).
        self showAlert:msg with:(FileStream lastErrorString).
        ^ nil
    ].

    "
     for very big files, give ObjectMemory a hint, to preallocate more
    "
    (sz := stream fileSize) > (1024*1024) ifTrue:[
        Processor activeProcess withUserBackgroundPriorityDo:[
            ObjectMemory announceSpaceNeed:(sz + (sz // 5)) "/ add 20% for tab expansion
        ].
    ].

    text := self readStream:stream lineDelimiter:aCharacter encoding:encoding.
    stream close.
    ^ text

    "Created: / 22.2.1996 / 14:56:48 / cg"
    "Modified: / 18.9.1997 / 17:06:54 / stefan"
    "Modified: / 4.2.1999 / 17:52:18 / cg"
!

readStream:aStream
    "read in from aStream, answer its contents as StringCollection"

    ^ self readStream:aStream lineDelimiter:Character cr encoding:nil

    "Modified: 22.2.1996 / 14:58:40 / cg"
!

readStream:aStream lineDelimiter:aCharacter encoding:fileEncodingArg 
    "read from aStream, answer its contents as StringCollection. 
     The file's lines are delimited by aCharacter.
     If encoding is nonNil, the file is assumed to be coded according to
     that symbol, and #decodeString: should be able to convert it."

    |text line fileEncoding editorsEncoding encoder|

    editorsEncoding := subView characterEncoding ? #'unicode'.
    fileEncoding := fileEncodingArg ? #'iso8859-1'.
    encoder := CharacterEncoder encoderToEncodeFrom:fileEncoding into:editorsEncoding.

    text := StringCollection new.

    aCharacter == Character cr ifTrue:[
        FileStream lineTooLongErrorSignal handle:[:ex |
            |s partialLine|

            s := ex parameter at:1.
            partialLine := ex parameter at:2.
            ex proceedWith:(partialLine , (s upTo:aCharacter))
        ] do:[
            [aStream atEnd] whileFalse:[
                line := aStream nextLine withTabsExpanded.
                text add:(encoder encodeString:line)
            ].
        ].
    ] ifFalse:[
        [aStream atEnd] whileFalse:[
            line := (aStream upTo:aCharacter) withTabsExpanded.
            text add:(encoder encodeString:line)
        ].
    ].
    ^ text

    "Created: / 22.2.1996 / 14:58:25 / cg"
    "Modified: / 5.2.1999 / 00:53:22 / cg"
!

showFile:fileName
    "show contents of fileName in subView"

    fileList notNil ifTrue:[
        fileListView selection:(fileList indexOf:fileName).
    ].
    self fileGet

    "Modified: / 17.6.1998 / 11:26:13 / cg"
!

showFile:fileName insert:insert encoding:encoding
    "show/insert contents of fileName in subView"

    ^ self 
        showFile:fileName insert:insert encoding:encoding doubleClick:false

    "Modified: 19.6.1996 / 09:40:19 / cg"
!

showFile:fileNameString insert:insert encoding:encoding doubleClick:viaDoubleClick
    "show/insert contents of fileName in subView"

    |path ok convert text msg eol guess action enc 
     fontsEncoding pref failWarning f answer fileName|

    fileName := fileNameString asFilename.

    fileName isAbsolute ifFalse:[
        path := currentDirectory filenameFor:fileNameString.
    ] ifTrue:[
        path := fileName asAbsoluteFilename
    ].

    (path type == #regular) ifFalse:[
        "asked for a non-file  - ignore it ..."
        path exists ifFalse:[
            msg := '''%1'' does not exist !!'.
        ] ifTrue:[
            msg := '''%1'' is not a regular file !!'.
        ].
        msg := resources stringWithCRs:msg with:fileNameString allBold.
        Dialog warn:msg.
        ^ self
    ].

    enc := encoding.
    ok := true.
    guess := CharacterEncoder guessEncodingOfFile:path asFilename.
    guess := guess ? fileEncoding ? #binary.

    guess == #binary ifTrue:[
        ok := false.
        viaDoubleClick ifTrue:[
            (self binaryFileAction:fileNameString) ifTrue:[^ self].
        ].
        answer := self confirmWithCancel:(resources string:'''%1'' seems to be a binary file (or unsupported format) - show anyway ?' with:fileNameString).
        answer == false ifTrue:[^ self].
        answer isNil ifTrue:[AbortOperationRequest raise].
    ] ifFalse:[
        viaDoubleClick ifTrue:[
            (self nonBinaryFileAction:fileNameString) ifTrue:[^ self].
        ].

        fontsEncoding := subView font encoding ? 'iso8859-1'.
        pref := FontDescription preferredFontEncodingFor:guess.
        ok := CharacterEncoder isEncoding:pref subSetOf:fontsEncoding.

        ok ifTrue:[
            fileEncoding := guess.    
            enc := guess.
        ] ifFalse:[
            doNotShowFontDialog == true ifTrue:[
                action := #show
            ] ifFalse:[
                action := Dialog choose:(resources string:'''%1'' seems to require a %2 font (file encoding is %3).' 
                                                     with:fileNameString with:pref allBold with:guess)
                               labels:(resources array:#('Cancel' 'Show' 'Don''t Ask Again' 'Change Font'))
                               values:#(nil #show #showAlways #encoding)
                               default:#encoding.
            ].
            action == #showAlways ifTrue:[
                doNotShowFontDialog := true.
                action := #show.
            ].
            action isNil ifTrue:[^ self].
            action == #encoding ifTrue:[
                fileEncoding := guess asSymbol.
                subView validateFontEncodingFor:fileEncoding ask:false.
            ] ifFalse:[
                doNotShowFontDialog ~~ true ifTrue:[
                    self information:(resources string:'Individual characters may be invisible/wrong in this font.')
                ]
            ].
            enc := fileEncoding.
        ].
        subView externalEncoding:fileEncoding.
    ].

    insert ifFalse:[
        "/ release old text first 
        "/ - we might need the memory in case of huge files
        "/  (helps if you have a 4Mb file in the view, 
        "/   and click on another biggy)

        subView contents:nil.
    ].

    convert := false.
"/    ok ifTrue:[
"/        "/
"/        "/ check if line delimiter is a cr
"/        "/
"/        i := buffer indexOf:Character cr.
"/        i == 0 ifTrue:[
"/            "/
"/            "/ no newline found - try cr
"/            "/
"/            i := buffer indexOf:(Character value:13).
"/            i ~~ 0 ifTrue:[
"/                convert := self confirm:(resources string:'''%1'' seems to have CR as line delimiter - convert to NL ?' with:fileNameString).
"/            ]
"/        ]
"/    ].

    convert ifTrue:[
        eol := Character value:13
    ] ifFalse:[
        eol := Character cr
    ].

    failWarning := false.
    CharacterArray decodingFailedSignal handle:[:ex |
        |errStr|

        failWarning ifFalse:[
            errStr := resources string:ex description.
            (self confirm:(resources 
                                string:'An error occurred while decoding:\%1\\The file has either a different encoding or is corrupted.\\Continue ?'
                                with:errStr) withCRs)
            ifFalse:[
                ^ self
            ].
            failWarning := true.
        ].
        ex proceed.
    ] do:[
        text := self readFile:fileNameString lineDelimiter:eol encoding:enc.
    ].

    insert ifFalse:[
        (f := fileName) isAbsolute ifFalse:[
            f := (currentDirectory construct:fileNameString)
        ].
        self class addToVisitedFileHistory:f pathName.

        self show:text
    ] ifTrue:[
        subView insertSelectedStringAtCursor:text asString
    ].

    "Created: / 19.6.1996 / 09:39:52 / cg"
    "Modified: / 18.9.1997 / 17:10:20 / stefan"
    "Modified: / 15.11.2001 / 17:15:27 / cg"
!

writeFile:fileName text:someText encoding:encoding
    |stream msg startNr nLines string encoder|

    encoder := CharacterEncoder encoderToEncodeFrom:(subView characterEncoding) into:encoding.

    [
        stream := (currentDirectory filenameFor:fileName) writeStream.
    ] on:FileStream openErrorSignal do:[:ex|
        msg := (resources string:'cannot write file ''%1'' !!' with:fileName).
        self showAlert:msg with:ex description.
        ^ self.
    ].

    dosEOLMode value == true ifTrue:[
        stream eolMode:#crlf.
        "/ must do it lineWise ...
        someText asStringCollection do:[:line |
            line notNil ifTrue:[
                encoder encodeString:line on:stream
            ].
            stream cr
        ]
    ] ifFalse:[
        (someText isString) ifTrue:[
            encoder encodeString:someText on:stream.
        ] ifFalse:[
            "/
            "/ on some systems, writing linewise is very slow (via NFS)
            "/ therefore we convert to a string and write it in chunks.
            "/ To avoid creating huge strings, we do it in blocks of 1000 lines.
            "/
            startNr := 1.
            nLines := someText size.
            [startNr <= nLines] whileTrue:[
                string := someText 
                                asStringWithCRsFrom:startNr
                                to:((startNr + 1000) min:nLines)
                                compressTabs:compressTabs.
                encoder encodeString:string on:stream.
                startNr := startNr + 1000 + 1.
            ].
        ].
    ].

    stream close.
    subView modified:false

    "Created: / 22.2.1996 / 15:03:10 / cg"
    "Modified: / 18.9.1997 / 17:12:44 / stefan"
    "Modified: / 6.5.1999 / 11:45:50 / cg"
! !

!FileBrowser methodsFor:'private-file stuff'!

doCreateFile:newName
    "create an empty file"

    |aStream f|

    f := currentDirectory filenameFor:newName.
    f exists ifTrue:[
        (self
            ask:(resources string:'%1 already exists\\truncate ?' with:newName)
            yesButton:'truncate'
        ) ifFalse:[^ self].
    ].

    FileStream openErrorSignal handle:[:ex|
        ^ self showAlert:(resources string:'Cannot create file ''%1'' !!' with:newName)
                    with:(FileStream lastErrorString)
    ] do:[    
        aStream := f newReadWriteStream.
    ].
    aStream close.
    self updateCurrentDirectoryIfChanged

    "Modified: / 18.9.1997 / 17:21:45 / stefan"
    "Modified: / 16.11.2001 / 00:44:49 / cg"
!

doFileGet:viaDoubleClick
    "get selected file - show contents in subView.
     This is invoked either by the 'get file' menu item, or via double click.
     When invoked via the menu (viaDoubleClick argument is false),
     the automatic file action is not performed - instead, the file is always
     shown in the codeView (if possible).
     This distinction was done to allow xpm or xbm files (which have an automatic
     action) to be edited."

    |fileName|

    fileName := self getSelectedFileName.
    fileName notNil ifTrue:[
        self doOpenFile:fileName viaDoubleClick:viaDoubleClick
    ]

    "Created: / 19.6.1996 / 09:39:07 / cg"
    "Modified: / 18.9.1997 / 17:35:31 / stefan"
    "Modified: / 4.2.1999 / 17:43:51 / cg"
!

doFindFileNamed:namePatterns ignoreCase:ignCaseInName containingString:contentsString ignoreCaseInContents:ignCaseInString sameContentsAsFile:filenameToCompareContentsOrNil sameContentsAs:bytesToCompareContentsOrNil in:aDirectory
    |dir subDirs nameMatches contentsMatches lines contentsToCompare|

    bytesToCompareContentsOrNil notNil ifTrue:[
        contentsToCompare := bytesToCompareContentsOrNil
    ].

    subDirs := OrderedCollection new.

    dir := aDirectory asFilename.
    self label:myName , '- searching ' , dir name.
    (dir directoryContents ? #()) sort do:[:fn |
        |f|

        f := dir construct:fn.
        f isDirectory ifTrue:[
            f isSymbolicLink ifFalse:[
                subDirs add:f
            ]
        ] ifFalse:[
            (nameMatches := namePatterns isNil) ifFalse:[
                ignCaseInName ifTrue:[
                    nameMatches := namePatterns contains:[:aPattern | aPattern match:(fn asLowercase)]
                ] ifFalse:[
                    nameMatches := namePatterns contains:[:aPattern | aPattern  match:fn]
                ]
            ].
            nameMatches ifTrue:[
                filenameToCompareContentsOrNil notNil ifTrue:[
                    "/ contents compare ...
                    contentsMatches := false.
                    f pathName ~= filenameToCompareContentsOrNil pathName ifTrue:[
                        f fileSize == filenameToCompareContentsOrNil fileSize ifTrue:[
                            contentsToCompare isNil ifTrue:[
                                filenameToCompareContentsOrNil fileSize < (512*1024) ifTrue:[
                                    contentsToCompare := filenameToCompareContentsOrNil binaryContentsOfEntireFile
                                ]
                            ].
                            contentsToCompare isNil ifTrue:[
                                "/ too large - compare block-wise ...
                                contentsMatches := (filenameToCompareContentsOrNil sameContentsAs:f).
                            ] ifFalse:[
                                contentsMatches := contentsToCompare = (f binaryContentsOfEntireFile).
                            ]
                        ].
                    ] ifFalse:[
                        f isSymbolicLink ifTrue:[
                            subView insertLine:(f name , ' is a symbolic link to ' , f pathName)  before:subView cursorLine.
                            subView cursorDown.
                        ]
                    ]
                ] ifFalse:[
                    "/ string search ...
                    (contentsMatches := contentsString isNil) ifFalse:[
                        (f exists and:[f isReadable]) ifFalse:[
                            subView insertLine:('*** ' , f pathName , ' skipped - unreadable or bad symbolic link ***') before:subView cursorLine.
                            subView cursorDown.
                        ] ifTrue:[
                            f fileSize > (4024*1024) ifTrue:[
                                subView insertLine:('*** ' , f pathName , ' skipped - too large ***') before:subView cursorLine.
                                subView cursorDown.
                            ] ifFalse:[
                                Stream lineTooLongErrorSignal handle:[:ex |
                                    |cont|

                                    "/ this typically happens, when a binary file is read linewise ...
                                    cont := f readStream binary contentsOfEntireFile asString.
                                    ignCaseInString ifTrue:[
                                        contentsMatches := cont asLowercase includesString:contentsString
                                    ] ifFalse:[
                                        contentsMatches := cont includesString:contentsString
                                    ].
                                ] do:[    
                                    lines := f contents ? #().
                                    ignCaseInString ifTrue:[
                                        contentsMatches := (lines findFirst:[:l | l asLowercase includesString:contentsString]) ~~ 0
                                    ] ifFalse:[
                                        contentsMatches := (lines findFirst:[:l | l includesString:contentsString]) ~~ 0
                                    ].
                                ].
                            ].
                        ].
                    ].
                ].
                contentsMatches ifTrue:[
                    subView insertLine:f pathName before:subView cursorLine.
                    subView cursorDown.
                ]
            ]
        ]
    ].

    subDirs do:[:dir |
        self
            doFindFileNamed:namePatterns 
            ignoreCase:ignCaseInName 
            containingString:contentsString 
            ignoreCaseInContents:ignCaseInString 
            sameContentsAsFile:filenameToCompareContentsOrNil 
            sameContentsAs:contentsToCompare
            in:dir
    ].

    "Created: / 15.10.1998 / 11:37:15 / cg"
    "Modified: / 15.10.1998 / 12:50:48 / cg"
!

doOpenFile:fileName viaDoubleClick:viaDoubleClick
    "get selected file - show contents in subView.
     This is invoked either by the 'get file' menu item, or via double click.
     When invoked via the menu (viaDoubleClick argument is false),
     the automatic file action is not performed - instead, the file is always
     shown in the codeView (if possible).
     This distinction was done to allow xpm or xbm files (which have an automatic
     action) to be edited."

    |iconLbl winLbl f|

    self withReadCursorDo:[
        (f := fileName asFilename) isAbsolute ifFalse:[
            f := currentDirectory construct:fileName.
        ].
        f isDirectory ifTrue:[
            self doChangeCurrentDirectoryTo:fileName updateHistory:true.
            winLbl := myName.
            iconLbl := myName
        ] ifFalse:[
            f exists ifFalse:[
                Dialog warn:(resources stringWithCRs:'oops, ''%1'' is gone or unreadable.' with:f pathName allBold).
                ^ self
            ].
            timeOfFileRead := f modificationTime.
            self showFile:fileName insert:false encoding:fileEncoding doubleClick:viaDoubleClick.
            currentFileName := fileName.

            self fileTypeSpecificActions.

            subView acceptAction:[:theCode |
                |filesModificationTime|

                filesModificationTime := f modificationTime.
                (filesModificationTime isNil
                or:[filesModificationTime <= timeOfFileRead
                or:[(self 
                        ask:(resources string:'FileBrowser:\\The file has changed somehow in the meanwhile.\(Hint: use the file-difference menu function to see what has changed)\\Do you really want to save ?')
                        yesButton:(resources string:'Save')
                        noButton:(resources string:'Cancel'))]]) 
                ifTrue:[
                    self withWriteCursorDo:[
                        self writeFile:fileName text:theCode encoding:fileEncoding.
                        timeOfFileRead := f modificationTime.
                        self label:myName , ': ' , currentFileName
                    ]
                ]
            ].

            winLbl := myName , ': ' , fileName.
            f isWritable ifFalse:[
                winLbl := winLbl , ' (readonly)'
            ].
            iconLbl := fileName
        ].
        self label:winLbl.
        self iconLabel:iconLbl.
    ]

    "Created: / 04-02-1999 / 17:43:26 / cg"
    "Modified: / 03-05-1999 / 20:32:27 / ps"
    "Modified: / 27-07-2012 / 09:45:56 / cg"
!

doRemove:filesToRemove
    "remove the selected file(s) - no questions asked"

    |msg needUpdate toRemove updateRunning yesToAll mTime|

    self withWaitCursorDo:[
        updateRunning := listUpdateProcess notNil.
        self stopUpdateProcess.
        toRemove := OrderedCollection new.

        "/
        "/ did the directory change in the meanwhile ?
        "/
        mTime := currentDirectory modificationTime.
        needUpdate := mTime notNil and:[mTime > timeOfLastCheck].

        yesToAll := false.
        lockUpdate := true.
        [
            filesToRemove keysAndValuesDo:[:idx :fileName |
                |f|

                f := currentDirectory construct:fileName.
                OsError handle:[:ex|
                    "was not able to remove it"
                    msg := (resources string:'Cannot remove ''%1'' !!' with:fileName).
                    self showAlert:msg with:(ex description)
                ] do:[
                    |answer i|

                    (f isSymbolicLink not and:[f isDirectory]) ifTrue:[
                        f isNonEmptyDirectory ifTrue:[
                            yesToAll ifFalse:[
                                idx == filesToRemove size ifTrue:[
                                    answer := Dialog
                                                confirmWithCancel:(resources stringWithCRs:'Directory ''%1'' is not empty\remove anyway ?' with:fileName allBold) 
                                                labels:(resources array:#('Cancel' 'Remove'))
                                                values:#(false true) 
                                                default:2.
                                ] ifFalse:[
                                    answer := Dialog
                                                confirmWithCancel:(resources stringWithCRs:'Directory ''%1'' is not empty\remove anyway ?' with:fileName allBold)
                                                labels:(resources array:#('Cancel' 'Remove All' 'Remove'))
                                                values:#(false #removeAll true) 
                                                default:3.
                                ].
                                answer == false ifTrue:[
                                    ^ self
                                ].
                                answer == #removeAll ifTrue:[
                                    yesToAll := true
                                ].
                            ].
                            f recursiveRemove
                        ] ifFalse:[
                            f remove
                        ]. 
                    ] ifFalse:[
                        f removeFile.
                    ].
    "
                    self show:nil
    "
                    i := fileList indexOf:fileName.
                    i ~~ 0 ifTrue:[
                        toRemove add:i.
                    ]
                ].
            ].
        ] ensure:[
            lockUpdate := false.
            fileListView setSelection:nil.

            "/
            "/ remove reverse - otherwise indices are wrong
            "/
            toRemove sort.
            toRemove reverseDo:[:idx |
                fileList removeIndex:idx.
                fileListView removeIndex:idx.
            ].

            updateRunning ifTrue:[
                self updateCurrentDirectory
            ] ifFalse:[
                "
                 install a new check after some time
                "
                needUpdate ifFalse:[timeOfLastCheck := Timestamp now].
                self scheduleCheckBlock.
            ]
        ]
    ]

    "Modified: / 20.11.1997 / 17:39:14 / stefan"
    "Modified: / 16.11.2001 / 00:43:40 / cg"
!

doRename:oldName to:newName
    "rename a file (or directory)"

    |old new sameFile|

    (oldName isNil or:[newName isNil]) ifTrue:[ ^ self ].
    (oldName isBlank or:[newName isBlank]) ifTrue:[ ^ self ].
    (oldName = newName) ifTrue:[ ^ self ].

    sameFile := Filename isCaseSensitive not and:[ oldName sameAs: newName ].

    old := currentDirectory filenameFor:oldName.
    new := currentDirectory filenameFor:newName.

    OsError handle:[:ex|
        self showAlert:(resources string:'Cannot rename file ''%1'' to %2 !!' 
                                  with:oldName with:newName)
                  with:(OperatingSystem lastErrorString)
    ] do:[
        sameFile ifFalse:[
            new exists ifTrue:[
                (self confirm:(resources string:'''%1'' already exists - rename (i.e. overwrite) anyway ?' with:new baseName allBold))
                ifFalse:[
                    ^ self
                ]
            ].
        ].
        old renameTo:new.
    ].

    self updateCurrentDirectory
    "/ self updateCurrentDirectoryIfChanged.

    "Modified: / 24-09-1997 / 09:20:00 / stefan"
    "Modified: / 21-09-2006 / 18:34:45 / cg"
! !

!FileBrowser methodsFor:'private-file type & info'!

fileTypeSpecificActions
    "any special fileTypeSpecific actions are done here,
     when a new file is selected"

    |commentStrings parentesisSpec|

    commentStrings := MIMETypes 
                        commentStringsForFilename:currentFileName
                        ifUnknown:[
                                "/ st:
                                #('"/' ('"' '"'))
                          ].
    commentStrings notNil ifTrue:[
        subView perform:#commentStrings: with:commentStrings ifNotUnderstood:nil
    ].

    parentesisSpec := MIMETypes 
                        parenthesisSpecForFilename:currentFileName 
                        ifUnknown:[
                            |spec|
                            spec := IdentityDictionary new.       
                            spec at:#open        put:'([{' "#( $( $[ ${)" .
                            spec at:#close       put:')]}' "#( $) $] $})".
                            spec
                        ]. 

    parentesisSpec notNil ifTrue:[
        subView perform:#parenthesisSpecification: with:parentesisSpec ifNotUnderstood:nil
    ].

    "Modified: / 10-04-2007 / 15:26:40 / cg"
!

getFileInfoString:longInfo
    "get stat info on selected file - return a string which can be
     shown in a box"

    |fileName f text info fileOutput modeBits modeString s ts md5Hash|

    fileName := self getSelectedFileName.
    fileName isNil ifTrue:[^ nil].

    f := currentDirectory construct:fileName.
    info := f linkInfo.

    info isNil ifTrue:[
        self showAlert:(resources string:'Cannot get info of ''%1'' !!' with:fileName)
                  with:(OperatingSystem lastErrorString).
        ^ nil
    ].

    text := StringCollection new.
    info isSymbolicLink ifTrue:[
        text add:(resources string:'symbolic link to: %1' with:(info path)).
        "get info of link target"
        info := f info.
    ].

    (longInfo and:[info isRegular]) ifTrue:[
        fileOutput := f fileType.
    ].

    s := (resources string:'type:   ').
    fileOutput isNil ifTrue:[
        s := s ,  info type asString
    ] ifFalse:[
        s := s , 'regular (' , fileOutput , ')'
    ].
    text add:s.
    text add:(resources string:'size:   %1' with:(info size) printString).

    info isRegular ifTrue:[
        md5Hash := MD5Stream hashValueOfFile:f.
        s := String streamContents:[:s | md5Hash do:[:byte | s nextPutAll:(byte hexPrintString)]].
        text add:(resources string:'md5:   %1' with:s).
    ].

    modeBits := info mode.
    modeString := self getModeString:modeBits.
    longInfo ifTrue:[
        text add:(resources string:'access: %1 (%2)'
                              with:modeString 
                              with:(modeBits printStringRadix:8))
    ] ifFalse:[
        text add:(resources string:'access: %1' with:modeString)
    ].
    text add:(resources string:'owner:  %1'
                          with:(OperatingSystem getUserNameFromID:(info uid))).
    longInfo ifTrue:[
        text add:(resources string:'group:  %1'
                              with:(OperatingSystem getGroupNameFromID:(info gid))).

        ts := info accessTime.
        text add:(resources string:'last access:       %1 %2' 
                              with:(ts asTime printString)
                              with:(ts asDate printString)).

        ts := info modificationTime.
        text add:(resources string:'last modification: %1 %2'
                              with:(ts asTime printString)
                              with:(ts asDate printString)).
    ].
    ^ text asString

    "Modified: / 8.9.1995 / 11:59:28 / claus"
    "Modified: / 18.9.1997 / 16:34:31 / stefan"
    "Modified: / 16.11.2001 / 00:45:11 / cg"
!

getInfoFile
    "get filename of a description-file (.dir.info, README etc.);
     This file is automatically shown when a directory is entered.
     You can add more names below if you like."

    #(
       '.dir.info'
       'README'
       'ReadMe'
       'Readme'
       'readme'
       'read.me'
       'Read.me'
       'READ.ME'
       'README.TXT'
       'readme.txt'
       'Readme.txt'
       'Info.txt'
       'info.txt'
       'INFO.TXT'
    ) do:[:f |
        |n|
        n := currentDirectory construct:f.
        (n isReadable and:[n isDirectory not]) ifTrue:[
            ^ f.
        ]
    ].
    ^ nil

    "Modified: 3.8.1997 / 16:50:33 / cg"
    "Modified: 16.9.1997 / 15:26:53 / stefan"
!

getModeString:modeBits
    "convert file-mode bits into a more user-friendly string.
     This is wrong here - should be moved into OperatingSystem."

    ^ self getModeString:modeBits 
                    with:#( 'owner:' $r $w $x 
                            ' group:' $r $w $x 
                            ' others:' $r $w $x )
!

getModeString:modeBits with:texts
    "convert file-mode bits into a more user-friendly string.
     This is wrong here - should be moved into OperatingSystem."

    |bits modeString|

    bits := modeBits bitAnd:8r777.
    modeString := ''.

    #( nil 8r400 8r200 8r100 nil 8r040 8r020 8r010 nil 8r004 8r002 8r001 ) 
    with: texts do:[:bitMask :access |
        |ch|

        bitMask isNil ifTrue:[
            modeString := modeString , (resources string:access)
        ] ifFalse:[
            (bits bitAnd:bitMask) == 0 ifTrue:[
                ch := $-
            ] ifFalse:[
                ch := access
            ].
            modeString := modeString copyWith:ch 
        ]
    ].
    ^ modeString
!

showInfo
    "show directory info when dir has changed"

    |info txt|

    info := self getInfoFile.
    info notNil ifTrue:[
        txt := self readFile:info
    ].
    self show:txt.
!

sizePrintString:size
    "helper for update-directory to return a string with a files size.
     This one gives the size in byte, Kb or Mb depending on size.
     If you don't like this, just uncomment the first statement below."

    |unitString n|

"
    ^ size printString.
"
    unitString := ''.
    size < (500 * 1024) ifTrue:[
        size < 1024 ifTrue:[
            n := size
        ] ifFalse:[
            n := (size * 10 // 1024 / 10.0).
            unitString := ' Kb'
        ]
    ] ifFalse:[
        n := (size * 10 // 1024 // 1024 / 10.0).
        unitString := ' Mb'
    ].
    ^ (n printStringLeftPaddedTo:5) , unitString.
! !

!FileBrowser methodsFor:'private-presentation'!

defineTabulatorsForLongList
    "define the tabs for the long list"

    tabSpec := TabulatorSpecification new.
    tabSpec unit:#inch.
"/  tabSpec positions:#(0     0.25    2.3   4.3    5.3    6.0      6.5).
    tabSpec widths:   #(0.25   2      2.0     1      0.5  0.5      1"any").
    "                   icon  name   mode  owner  group  size     type"
    tabSpec align:    #(#left #left  #left #right #right #decimal #left).
    tabSpec addDependent:self.

    tabRulerView tabulatorSpecification:tabSpec.

    "Modified: 17.4.1997 / 02:56:07 / cg"
!

defineTabulatorsForShortList
    "define the tabs for the short list"

    tabSpec := TabulatorSpecification new.
    tabSpec unit:#inch.
"/  tabSpec positions:#(0     0.25 ).
    tabSpec widths:   #(0.25   2   ).
    "                   icon  name"
    tabSpec align:    #(#left #left).
    tabSpec addDependent:self.

    tabRulerView notNil ifTrue:[
        tabRulerView tabulatorSpecification:tabSpec.
    ].

    "Created: / 17.4.1997 / 02:51:41 / cg"
    "Modified: / 27.7.1998 / 20:23:34 / cg"
!

iconForFile:aFilename
    "given a fileName, return an appropriate icon"

    |icn|

    icn := self iconForKeyMatching:(MIMETypeIconLibrary iconKeyForFile:aFilename).
    ^ MIMETypeIconLibrary addOnIconsFor:aFilename to:icn.
!

iconForKeyMatching:mimeTypeOrKey
    |assoc icn|

    icn := icons at:mimeTypeOrKey ifAbsent:nil.
    icn notNil ifTrue:[^ icn].
    assoc := matchedIcons detect:[:assoc | assoc key match:mimeTypeOrKey] ifNone:nil.
    assoc notNil ifTrue:[^ assoc value].

    "/ global icons

    icn := MIMETypeIconLibrary iconForKey:mimeTypeOrKey.
    icn notNil ifTrue:[
        icn := icn copy onDevice:self graphicsDevice.
        icons at:mimeTypeOrKey put:icn.
        ^ icn
    ].

    assoc := MIMETypeIconLibrary iconForMatchKey:mimeTypeOrKey.
    assoc notNil ifTrue:[
        icn := assoc value.
        icn notNil ifTrue:[
            icn := icn copy onDevice:self graphicsDevice.
            matchedIcons add:(assoc key -> icn).
            ^ icn
        ].
    ].

    ^ nil
!

stopImageRenderProcess
    imageRenderProcess notNil ifTrue:[
        imageRenderProcess terminate.
        imageRenderProcess := nil
    ].

    "Created: 19.4.1997 / 13:51:34 / cg"
!

stopUpdateProcess
    Processor removeTimedBlock:checkBlock.
    listUpdateProcess notNil ifTrue:[
        listUpdateProcess terminate.
        listUpdateProcess := nil.
    ].

    "Created: 19.4.1997 / 13:51:34 / cg"
!

updateCurrentDirectory
    "update listView with directory contents"

    "the code below may look somewhat complex -
     it reads the directory first for the names,
     then (in followup sweeps over the files) gets the
     files type, info and icon in a forked subprocess. 
     This makes the Filebrowsers list update faster, since the fileInfo 
     (i.e. stat-calls) may take long - especially on NFS-mounted directories.
     The file reading is done at lower priority, to let user continue
     his work in other views. However, to be fair to other fileBrowser,
     which may also read directories at low prio, give up the processor
     after every entry. This shares the cpu among all fileBrowsers;
     Therefore, browsers which read short directories will finish first.
     ST/X users love this behavior ;-)
    "

    |files matchPattern list passDone oldSelection newSelection times types|

    self withReadCursorDo:[
        self stopUpdateProcess.

        timeOfLastCheck := currentDirectory modificationTime.
        [
            files := currentDirectory asFilename fullDirectoryContents.
        ] on:FileStream openErrorSignal do:[:ex|
            files := nil.
        ].

"/        (files includes:(Filename parentDirectoryName)) ifTrue:[
"/            upButton enable.
"/        ] ifFalse:[
"/            upButton disable.
"/        ].

        "/ show files which are either directories
        "/ or match the current pattern

        matchPattern := filterField contents.
        (matchPattern notNil 
        and:[ matchPattern notEmpty 
        and:[ matchPattern ~= '*']]) 
        ifTrue:[
             files := files select:[:aName | 
                         ((currentDirectory construct:aName) isDirectory)
                         or:[matchPattern compoundMatch:aName caseSensitive:(Filename isCaseSensitive)]
                      ].
        ].

        files size == 0 ifTrue:[
            Dialog warn:(resources stringWithCRs:'Directory ''%1'' is gone.' with:currentDirectory pathName allBold).
            ^ self
        ].
        (sortByWhat value == #name) ifTrue:[
            sortCaseless value == true ifTrue:[
                files sort:[:a :b | a asLowercase < b asLowercase]
            ] ifFalse:[
                files sort.
            ]
        ] ifFalse:[
            (sortByWhat value == #time) ifTrue:[
                times := Dictionary new.
                files do:[:fn | |t f|
                                f := currentDirectory construct:fn. 
                                t := f linkInfo modificationTime. 
                                t isNil ifTrue:[t := Timestamp now].
                                times at:fn put:t.
                         ].
                files sort:[:a :b | |f1 f2 t1 t2|
                                t1 := times at:a.
                                t2 := times at:b.

"/                                f1 := (currentDirectory construct:a).
"/                                f2 := (currentDirectory construct:b).
"/                                t1 := f1 isSymbolicLink 
"/                                        ifFalse:[f1 modificationTime]
"/                                        ifTrue:[f1 linkInfo modificationTime].
"/                                t2 := f2 isSymbolicLink 
"/                                        ifFalse:[f2 modificationTime]
"/                                        ifTrue:[f2 linkInfo modificationTime].
"/                                t1 := t1 ? (Timestamp now).
"/                                t2 := t2 ? (Timestamp now).
                                t1 > t2
                           ]
            ] ifFalse:[
                (sortByWhat value == #type) ifTrue:[
                    types := Dictionary new.
                    files do:[:fn | |t f|
                                    f := currentDirectory construct:fn. 
                                    t := f type ? #xbadLink. 
                                    types at:fn put:t.
                             ].
                    files sort:[:a :b | |f1 f2 t1 t2 suff1 suff2|
                                    t1 := types at:a.
                                    t2 := types at:b.
"/                                    f1 := (currentDirectory construct:a).
"/                                    f2 := (currentDirectory construct:b).
"/                                    t1 := f1 type ? #xbadLink. 
"/                                    t2 := f2 type ? #xbadLink. 
                                    t1 = t2 ifTrue:[
                                        f1 := (currentDirectory construct:a).
                                        f2 := (currentDirectory construct:b).
                                        suff1 := f1 suffix.
                                        suff2 := f2 suffix.
                                        suff1 = suff2 ifTrue:[
                                            sortCaseless value == true ifTrue:[
                                                a asLowercase < b asLowercase
                                            ] ifFalse:[
                                                a < b
                                            ]
                                        ] ifFalse:[
                                            suff1 asLowercase = suff2 asLowercase ifTrue:[
                                                sortCaseless value == true ifTrue:[
                                                    a asLowercase < b asLowercase
                                                ] ifFalse:[
                                                    a < b
                                                ]
                                            ] ifFalse:[
                                                suff1 asLowercase < suff2 asLowercase
                                            ]
                                        ]
                                    ] ifFalse:[
                                        t1 < t2
                                    ]
                               ]
                ]
            ]
        ].

        files := self withoutHiddenFiles:files.
        fileList := files copy.

        tabSpec isNil ifTrue:[
            showingDetails value "showLongList" ifTrue:[
                self defineTabulatorsForLongList
            ] ifFalse:[
                self defineTabulatorsForShortList
            ].
        ].

        "/
        "/ first show all the names - this can be done fast ...
        "/
        list := files collect:[:fileName |
                    |entry|

                    entry := MultiColListEntry new.
                    entry tabulatorSpecification:tabSpec.
                    entry colAt:1 put:nil.
                    entry colAt:2 put:fileName.
                ].

        oldSelection := fileListView selectionValue.
        fileListView setList:list expandTabs:false.
        newSelection := oldSelection collect:[:nm | list indexOf:nm].
        fileListView selectWithoutScroll:newSelection.

        passDone := Array new:list size withAll:0.

        "
         this is a time consuming operation (especially, if reading an
         NFS-mounted directory); therefore, start a low prio process,
         which fills in the remaining fields in the fileList ...
        "

        listUpdateProcess := [
            |prevUid prevGid fileNameString nameString groupString 
             modeString info line len
             anyImages lineIndex aFileName
             entry f p typeString done endIndex 
             state stopAtEnd nextState img prevFirstLine prevLastLine
             numVisible dirSuffix prevWidth t|

            dirSuffix := Filename directorySuffix.
            dirSuffix size > 0 ifTrue:[
                dirSuffix := '.' , dirSuffix asLowercase.
            ].

            "/
            "/ then walk over the files, adding more info
            "/ (since we have to stat each file, this may take a while longer)
            "/ Visible items are always filled first.

            "/
            "/ the state machine
            "/
            nextState := IdentityDictionary new.
            showingDetails value "showLongList" ifTrue:[
                nextState add:(#visibleIcons -> #visibleAttributes).
                nextState add:(#visibleAttributes -> #visibleTypes).
                nextState add:(#visibleTypes -> #visibleImages).
                nextState add:(#visibleImages -> #nextPageIcons).

                nextState add:(#nextPageIcons -> #nextPageAttributes).
                nextState add:(#nextPageAttributes -> #nextPageTypes).
                nextState add:(#nextPageTypes -> #nextPageImages).
                nextState add:(#nextPageImages -> #previousPageIcons).

                nextState add:(#previousPageIcons -> #previousPageAttributes).
                nextState add:(#previousPageAttributes -> #previousPageTypes).
                nextState add:(#previousPageTypes -> #previousPageImages).
                nextState add:(#previousPageImages -> #remainingIcons).

                nextState add:(#remainingIcons -> #remainingAttributes).
                nextState add:(#remainingAttributes -> #remainingTypes).
                nextState add:(#remainingTypes -> #remainingImages).
                nextState add:(#remainingImages -> nil).
            ] ifFalse:[
                nextState add:(#visibleIcons -> #nextPageIcons).
                nextState add:(#nextPageIcons -> #previousPageIcons).
                nextState add:(#previousPageIcons -> #remainingIcons).
                nextState add:(#remainingIcons -> nil).
            ].

            anyImages := false.

            lineIndex := prevFirstLine := fileListView firstLineShown.
            endIndex := prevLastLine := fileListView lastLineShown.
            endIndex := endIndex min:(files size).
            state := #visibleIcons.

            done := false.
            [done] whileFalse:[
                "/
                "/ if multiple FileBrowsers are reading, let others
                "/ make some progress too
                "/
                Processor yield.

                "/
                "/ could be destroyed in the meanwhile ...
                "/
                realized ifFalse:[
                    listUpdateProcess := nil.
                    Processor activeProcess terminate
                ].

                ((prevFirstLine ~~ fileListView firstLineShown)
                or:[prevLastLine ~~ fileListView lastLineShown]) ifTrue:[
                    "/ start all over again
                    lineIndex := prevFirstLine := fileListView firstLineShown.
                    endIndex := prevLastLine := fileListView lastLineShown.
                    endIndex := endIndex min:(files size).
                    state := #visibleIcons.
                ].

                showingDetails value ifTrue:[
                    prevWidth := fileListView widthOfContents.
                ].

                (lineIndex between:1 and:(files size)) ifTrue:[

                    "/
                    "/ expand the next entry ...
                    "/
                    aFileName := files at:lineIndex.
                    entry := fileListView at:lineIndex.
                    f := currentDirectory construct:aFileName.

                    (state endsWith:'Icons') ifTrue:[
                        "/
                        "/ pass 1 - icons
                        "/
                        (passDone at:lineIndex) < 1 ifTrue:[
                            (f isDirectory
                              and:[(aFileName ~= '..') and:[aFileName ~= '.']]
                            ) ifTrue:[

                                "/ the following suffix cutOff is not really required, 
                                "/ but makes the list look better on VMS ...
                                fileNameString := aFileName.
                                dirSuffix notNil ifTrue:[
                                    (aFileName asLowercase endsWith:dirSuffix) ifTrue:[
                                        fileNameString := aFileName copyButLast:(dirSuffix size).
                                    ]
                                ].
                                fileNameString := fileNameString , ' ...'
                            ] ifFalse:[
                                fileNameString := aFileName.
                                OperatingSystem isVMSlike ifTrue:[
                                    (aFileName endsWith:'.') ifTrue:[
                                        aFileName ~= '..' ifTrue:[
                                            fileNameString := aFileName copyButLast:1
                                        ]
                                    ]
                                ]
                            ].

                            showingDetails value "showLongList" ifTrue:[
                                len := fileNameString size.
                                (len > 20) ifTrue:[
                                    fileNameString := (fileNameString contractTo:20)
                                ].
                            ].

                            entry colAt:1 put:(self iconForFile:(currentDirectory construct:aFileName)).
                            entry colAt:2 put:fileNameString.

                            "/fileListView at:lineIndex put:entry.
                            fileListView withoutRedrawAt:lineIndex put:entry.
                            fileListView invalidateLine:lineIndex.

                            anyImages ifFalse:[
                                (Image isImageFileSuffix:(aFileName asFilename suffix))
                                ifTrue:[
                                    anyImages := true
                                ]
                            ].
                            passDone at:lineIndex put:1
                        ]
                    ].

                    (state endsWith:'Attributes') ifTrue:[
                        "/
                        "/ pass 2 - everything except fileType (which takes very long)
                        "/
                        (passDone at:lineIndex) < 2 ifTrue:[
                            info := f linkInfo.
                            info isNil ifTrue:[
                                "not accessible - usually a symlink,
                                 to a nonexisting/nonreadable file"

                                info := f linkInfo.
                                (info notNil and:[info isSymbolicLink]) ifTrue:[
                                    typeString := 'broken symbolic link to ' , info path
                                ] ifFalse:[
                                    typeString := 'unknown'
                                ].
                            ] ifFalse:[
                                modeString := self getModeString:(info at:#mode)
                                                            with:#( '' $r $w $x 
                                                                    '  ' $r $w $x 
                                                                    '  ' $r $w $x ).
                                entry colAt:3 put:modeString.

                                showingTimeAndDate value ifTrue:[
                                    t := info modificationTime.
                                    entry colAt:4 put:t asDate printString.
                                    entry colAt:5 put:t asTime printString.
                                ] ifFalse:[
                                    ((info uid) ~~ prevUid) ifTrue:[
                                        prevUid := (info uid).
                                        nameString := OperatingSystem getUserNameFromID:prevUid.
                                        nameString := nameString contractTo:10.
                                        nameString := nameString , (String new:(10 - nameString size))
                                    ].
                                    nameString isNil ifTrue:[nameString := '???'].
                                    entry colAt:4 put:nameString withoutSpaces.

                                    ((info gid) ~~ prevGid) ifTrue:[
                                        prevGid := info gid.
                                        groupString := OperatingSystem getGroupNameFromID:prevGid.
                                        groupString := groupString contractTo:10.
                                        groupString := groupString , (String new:(10 - groupString size))
                                    ].
                                    groupString isNil ifTrue:[groupString := '???'].
                                    entry colAt:5 put:groupString withoutSpaces.
                                ].

                                info isRegular ifTrue:[
                                    entry colAt:6 put:(self sizePrintString:(info size)).
                                ] ifFalse:[info isSymbolicLink ifTrue:[
                                    f exists ifTrue:[
                                        typeString := 'symbolic link to ' , info path
                                    ] ifFalse:[
                                        typeString := 'broken symbolic link to ' , info path
                                    ]
                                ] ifFalse:[
                                    typeString := info type asString
                                ]].
                            ].
                            entry colAt:7 put:typeString.

                            "/ fileListView at:lineIndex put:entry.
                            fileListView withoutRedrawAt:lineIndex put:entry.
                            fileListView invalidateLine:lineIndex.
                        
                            passDone at:lineIndex put:2.
                        ].
                    ].

                    (state endsWith:'Types') ifTrue:[
                        "/
                        "/ pass 3: add fileType
                        "/
                        (passDone at:lineIndex) < 3 ifTrue:[
                            info := f linkInfo.
                            info notNil ifTrue:[
                                info isSymbolicLink ifFalse:[
                                    (Image isImageFileSuffix:(f suffix)) ifFalse:[
                                        typeString := f fileType.

                                        entry colAt:7 put:typeString.
                                        "/ fileListView at:lineIndex put:entry
                                        fileListView withoutRedrawAt:lineIndex put:entry.
                                        fileListView invalidateLine:lineIndex.
                                    ].
                                ].
                            ].

                            passDone at:lineIndex put:3
                        ].
                    ].

                    (state endsWith:'Images') ifTrue:[
                        "/
                        "/ pass 4: read images
                        "/
                        (passDone at:lineIndex) < 4 ifTrue:[
                            (Image isImageFileSuffix:(f suffix)) ifTrue:[
                                f isDirectory ifFalse:[
                                    img := Image fromFile:(f pathName).
                                    img notNil ifTrue:[
                                        showingBigImagePreview value == true ifTrue:[
                                            img := img magnifiedTo:32@32.
                                        ] ifFalse:[
                                            img := img magnifiedTo:16@16.
                                        ].
                                        img := img onDevice:self device.
                                        entry colAt:7 put:img.
                                        "/ fileListView at:lineIndex put:entry
                                        fileListView withoutRedrawAt:lineIndex put:entry.
                                        fileListView invalidateLine:lineIndex.
                                    ]
                                ]
                            ].
                            passDone at:lineIndex put:4
                        ].
                    ].
                ].

                showingDetails value ifTrue:[
                    fileListView widthOfContents ~~ prevWidth ifTrue:[
                        fileListView contentsChanged.    
                    ]
                ].

                "/
                "/ advance to the next line
                "/
                lineIndex := lineIndex + 1.
                lineIndex > endIndex ifTrue:[
                    "/ finished this round ...
                    "/ see what we are going for ...
                    numVisible := (fileListView lastLineShown - fileListView firstLineShown + 1).

                    state := nextState at:state ifAbsent:nil.

                    state isNil ifTrue:[
                        done := true
                    ] ifFalse:[
                        (state startsWith:'visible') ifTrue:[
                            lineIndex := fileListView firstLineShown.
                            endIndex := fileListView lastLineShown.
                            endIndex := endIndex min:(files size).
                        ] ifFalse:[
                            (state startsWith:'nextPage') ifTrue:[
                                lineIndex := fileListView lastLineShown + 1.
                                endIndex := lineIndex + numVisible.
                                endIndex := endIndex min:(files size).
                                lineIndex := lineIndex min:(files size).
                            ] ifFalse:[
                                (state startsWith:'previousPage') ifTrue:[
                                    endIndex := fileListView firstLineShown - 1.
                                    lineIndex := endIndex - numVisible.
                                    lineIndex := lineIndex max:1.
                                    endIndex := endIndex min:(files size).
                                    endIndex := endIndex max:1.
                                ] ifFalse:[ 
                                    "/ remaining
                                    lineIndex := 1.
                                    endIndex := files size.
                                ]
                            ]
                        ]
                    ]
                ]
            ].

            listUpdateProcess := nil.

        ] forkAt:(Processor activePriority - 1).

        "
         install a new check after some time
        "
        self scheduleCheckBlock.
    ]

    "Modified: / 21.9.1995 / 11:40:23 / claus"
    "Modified: / 28.4.1997 / 22:30:30 / dq"
    "Modified: / 18.9.1997 / 18:28:30 / stefan"
    "Modified: / 15.11.2001 / 23:49:03 / cg"
! !

!FileBrowser methodsFor:'queries'!

fileName
    "return my current fileName - during fileIn, the file
     which is being loaded is returned.
     This is provided for VW fileIn scripts, which walk the
     context hierarchy and ask the fileBrowser for the name."

    |f|

    f := currentFileInFileName ? currentFileName.
    f isNil ifTrue:[^ nil].
    ^ self path asFilename construct:f

    "
     (FileBrowser openOnFileNamed:'Makefile') fileName
    "

    "Modified: / 18.6.1998 / 15:27:35 / cg"
!

path
    "return my currentDirectories pathName;
     sent from the pathField to acquire the pathname when I changed directory"

    "/ somewhat tricky: first ask it for the full pathName,
    "/ then convert it to a directory name
    "/ (which only makes a difference on VMS)

    ^ currentDirectory pathName "/ asFilename osNameForDirectory

    "Modified: / 12.8.1998 / 14:45:48 / cg"
! !

!FileBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

