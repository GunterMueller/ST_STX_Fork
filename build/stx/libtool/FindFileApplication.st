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

AbstractFileFinderApplicationComponent subclass:#FindFileApplication
	instanceVariableNames:'searchDirectories searchDirectoryHolder notSearchForSameContents
		namePatternHolder excludedNamePatternHolder ignoreCaseInName
		ignoreCaseInExcludedName contentsPatternHolder
		ignoreCaseInContents notContentsPatternHolder
		ignoreCaseInNotContents sameContentsAsHolder useLocate useGrep
		rememberInCache searchOnlyInCache searchForSameContents
		contentsInfoCache contentsInfoCacheAccessLock
		fileSizeOperatorHolder fileSizeHolder enableFileSizeFilter
		fileSizeUnitHolder modificationTimeOperatorHolder
		modificationTimeHolder enableModificationTimeFilter
		showUnreadableFilesAndDirectoriesHolder
		modificationTimeOperatorIndexHolder'
	classVariableNames:'ContentsInfoCache ContentsInfoCacheAccessLock LastRememberInCache
		LastSearchIgnoredCaseInContents LastSearchIgnoredCaseInFilename
		SearchStringHistory LastSearchIgnoredCaseInExcludedFilename
		LastShowUnreadableFilesAndDirectories'
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FindFileApplication class methodsFor:'documentation'!

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
! !

!FindFileApplication class methodsFor:'instance creation'!

open
    ^ self openInDirectory:(Filename currentDirectory)

    "
     self open
    "
!

openInDirectory:aFilename
    ^ self openOnFileName:(aFilename asFilename asAbsoluteFilename)

    "
     self openInDirectory:'/etc'
    "
!

openOnFileName:aFileName
    ^ self openOnFileName:aFileName for:nil
!

openOnFileName:aFileName for:aTargetApplicationOrNil

    | instance builder|

    builder := super open.
    instance := builder application.
    instance item:(DirectoryContentsBrowser itemClass fileName:aFileName).
    aTargetApplicationOrNil notNil ifTrue:[
        instance targetApplication:aTargetApplicationOrNil.
    ].
    ^ builder
! !

!FindFileApplication class methodsFor:'defaults'!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'Find in %1'

    "Modified: / 01-03-2007 / 21:47:54 / cg"
! !

!FindFileApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FindFileApplication    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#contentsPattern
'Search for files containing this. Can be matchPatterns, separated by ";"'

#namePattern
'Filename(s) to search for. Can be matchPatterns, separated by ";"'

#excludedNamePattern
'Filename(s) to skip. Can be matchPatterns, separated by ";"'

#notContentsPattern
'Search for files NOT containing this. Can be matchPatterns, separated by ";"'

#searchDirectory
'Folder, where the search starts'

#searchRecursive
'Recursively search in sub-folders'

#ignoreCase
'Ignore upper/lowercase differences (be case-insensitive)'

#sameContents
'Search for files with same contents as the other file'

#fileSize
'Search for files with a specific size constraint ("~" means: +/- 10%)'

#modificationTime
'Search for files which are newer or older'
)

    "Modified: / 28-03-2012 / 23:03:39 / cg"
! !

!FindFileApplication class methodsFor:'history'!

addToSearchStringHistory:aString
    self searchStringHistory 
        remove:aString ifAbsent:[];
        addFirst:aString.
    self searchStringHistory size > 25 ifTrue:[
        self searchStringHistory removeLast
    ].
!

searchStringHistory
    SearchStringHistory isNil ifTrue:[
        SearchStringHistory := OrderedCollection new 
    ].
    ^ SearchStringHistory
! !

!FindFileApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FindFileApplication andSelector:#windowSpec
     FindFileApplication new openInterface:#windowSpec
     FindFileApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'File Search'
         name: 'File Search'
         min: (Point 377 131)
         bounds: (Rectangle 0 0 759 420)
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar1'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
             level: 0
             menu: searchMenu
             textDefault: true
           )
          (ProgressIndicatorSpec
             name: 'ProgressIndicator1'
             layout: (LayoutFrame 125 0 11 0 231 0 21 0)
             visibilityChannel: enableStop
             backgroundColor: (Color 0.0 67.0 67.0)
             showPercentage: false
             isActivityIndicator: true
           )
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0.0 32 0 0 1.0 231 0)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Directory:'
                   name: 'DirectoryLabel'
                   layout: (LayoutFrame 2 0 7 0 180 0 24 0)
                   activeHelpKey: searchDirectory
                   translateLabel: true
                   adjust: right
                 )
                (FilenameInputFieldSpec
                   name: 'DirectoryEntryField'
                   layout: (LayoutFrame 180 0 4 0 -350 1 24 0)
                   activeHelpKey: searchDirectory
                   model: searchDirectoryHolder
                   immediateAccept: true
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Search Files Named:'
                   name: 'FileNameLabel'
                   layout: (LayoutFrame 2 0 31 0 180 0 48 0)
                   activeHelpKey: namePattern
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'FileNameEntryField'
                   layout: (LayoutFrame 180 0 28 0 -350 1 48 0)
                   activeHelpKey: namePattern
                   tabable: true
                   model: namePatternHolder
                   immediateAccept: true
                   acceptOnLeave: false
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'But not Named:'
                   name: 'Label1'
                   layout: (LayoutFrame 2 0 55 0 180 0 72 0)
                   activeHelpKey: excludedNamePattern
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   layout: (LayoutFrame 180 0 52 0 -350 1 72 0)
                   activeHelpKey: excludedNamePattern
                   tabable: true
                   model: excludedNamePatternHolder
                   immediateAccept: true
                   acceptOnLeave: false
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Containing:'
                   name: 'ContentsLabel'
                   layout: (LayoutFrame 2 0 79 0 180 0 96 0)
                   activeHelpKey: contentsPattern
                   translateLabel: true
                   adjust: right
                 )
                (ComboBoxSpec
                   name: 'ComboBox1'
                   layout: (LayoutFrame 180 0 76 0 -350 1 96 0)
                   activeHelpKey: contentsPattern
                   enableChannel: notSearchForSameContents
                   tabable: true
                   model: contentsPatternHolder
                   immediateAccept: true
                   acceptOnPointerLeave: false
                   comboList: searchStringHistory
                   useIndex: false
                 )
                (LabelSpec
                   label: 'Not Containing:'
                   name: 'NotContentsLabel'
                   layout: (LayoutFrame 2 0 103 0 180 0 120 0)
                   activeHelpKey: notContentsPattern
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'NotContentsEntryField'
                   layout: (LayoutFrame 180 0 100 0 -350 1 120 0)
                   activeHelpKey: notContentsPattern
                   enableChannel: notSearchForSameContents
                   tabable: true
                   model: notContentsPatternHolder
                   immediateAccept: true
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Same Contents As:'
                   name: 'SameContentsAsLabel'
                   layout: (LayoutFrame 2 0 127 0 180 0 144 0)
                   activeHelpKey: sameContents
                   translateLabel: true
                   adjust: right
                 )
                (InputFieldSpec
                   name: 'SameContentsAsEntryField'
                   layout: (LayoutFrame 180 0 124 0 -367 1 144 0)
                   activeHelpKey: sameContents
                   enableChannel: searchForSameContents
                   tabable: true
                   model: sameContentsAsHolder
                   immediateAccept: true
                   acceptOnPointerLeave: false
                 )
                (CheckToggleSpec
                   name: 'EnableSameContentsCheckToggle'
                   layout: (LayoutOrigin -366 1 128 0)
                   activeHelpKey: sameContents
                   translateLabel: true
                   model: searchForSameContents
                   isTriggerOnDown: true
                   showLamp: false
                   lampColor: (Color 100.0 100.0 0.0)
                 )
                (LabelSpec
                   label: 'File Size:'
                   name: 'FileSizeLabel'
                   layout: (LayoutFrame 2 0 151 0 180 0 168 0)
                   activeHelpKey: fileSize
                   translateLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'PopUp List'
                   name: 'FileSizeOperatorPopUpList'
                   layout: (LayoutFrame 180 0 148 0 260 0 168 0)
                   activeHelpKey: fileSize
                   translateLabel: true
                   tabable: true
                   model: fileSizeOperatorHolder
                   enableChannel: enableFileSizeFilterAndNotSearchForSameContents
                   menu: 
                  (Array
                     ' >' ' < '
                     ' !!= ' ' = '
                     ' ~ '
                   )
                 )
                (InputFieldSpec
                   name: 'FileSizeEntryField'
                   layout: (LayoutFrame 260 0 148 0 -367 1 168 0)
                   activeHelpKey: fileSize
                   enableChannel: enableFileSizeFilterAndNotSearchForSameContents
                   tabable: true
                   model: fileSizeHolder
                   type: fileSize
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                 )
                (CheckToggleSpec
                   name: 'EnableSizeCheckToggle'
                   layout: (LayoutOrigin -366 1 151 0)
                   activeHelpKey: fileSize
                   translateLabel: true
                   model: enableFileSizeFilter
                   enableChannel: notSearchForSameContents
                   isTriggerOnDown: true
                   showLamp: false
                   lampColor: (Color 100.0 100.0 0.0)
                 )
                (LabelSpec
                   label: 'Modified:'
                   name: 'Label2'
                   layout: (LayoutFrame 2 0 175 0 180 0 192 0)
                   activeHelpKey: modificationTime
                   translateLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'PopUp List'
                   name: 'PopUpList1'
                   layout: (LayoutFrame 180 0 172 0 260 0 192 0)
                   activeHelpKey: modificationTime
                   translateLabel: true
                   tabable: true
                   model: modificationTimeOperatorIndexHolder
                   enableChannel: enableModificationTimeFilter
                   menu: modificationTimeOperatorLabelList
                   useIndex: true
                 )
                (InputFieldSpec
                   name: 'ModifiedEntryField'
                   layout: (LayoutFrame 260 0 172 0 -367 1 192 0)
                   activeHelpKey: modificationTime
                   enableChannel: enableModificationTimeFilter
                   tabable: true
                   model: modificationTimeHolder
                   type: timestamp
                   immediateAccept: false
                   acceptOnLeave: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                 )
                (CheckToggleSpec
                   name: 'CheckToggle1'
                   layout: (LayoutOrigin -366 1 175 0)
                   activeHelpKey: modificationTime
                   translateLabel: true
                   model: enableModificationTimeFilter
                   isTriggerOnDown: true
                   showLamp: false
                   lampColor: (Color 100.0 100.0 0.0)
                 )
                (CheckBoxSpec
                   label: 'Use ''locate'' Cmd'
                   name: 'UseLocateCheckBox'
                   layout: (LayoutFrame -350 1 5 0 -167 1 28 0)
                   activeHelpKey: useLocate
                   visibilityChannel: canUseLocate
                   tabable: true
                   model: useLocate
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Recursive'
                   name: 'RecursiveSearchCheckBox'
                   layout: (LayoutFrame -200 1 5 0 -4 1 28 0)
                   activeHelpKey: recursiveSearch
                   tabable: true
                   model: searchRecursively
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Directories'
                   name: 'SearchDirectoriesCheckBox'
                   layout: (LayoutFrame -350 1 29 0 -167 1 52 0)
                   enableChannel: notSearchForSameContents
                   tabable: true
                   model: searchDirectories
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Ignore Case'
                   name: 'IgnoreCaseInNameCheckBox'
                   layout: (LayoutFrame -200 1 29 0 -4 1 52 0)
                   activeHelpKey: ignoreCase
                   tabable: true
                   model: ignoreCaseInName
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Ignore Case'
                   name: 'CheckBox1'
                   layout: (LayoutFrame -200 1 53 0 -4 1 76 0)
                   activeHelpKey: ignoreCase
                   tabable: true
                   model: ignoreCaseInExcludedName
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Use ''grep'' Cmd'
                   name: 'UseGrepCheckBox'
                   layout: (LayoutFrame -350 1 77 0 -167 1 100 0)
                   visibilityChannel: canUseGrep
                   enableChannel: notSearchForSameContents
                   tabable: true
                   model: useGrep
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Ignore Case'
                   name: 'IgnoreCaseInContentsCheckBox'
                   layout: (LayoutFrame -200 1 77 0 -4 1 100 0)
                   activeHelpKey: ignoreCase
                   enableChannel: notSearchForSameContents
                   tabable: true
                   model: ignoreCaseInContents
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Ignore Case'
                   name: 'IgnoreCaseInNotContentsCheckBox'
                   layout: (LayoutFrame -200 1 101 0 -4 1 124 0)
                   activeHelpKey: ignoreCase
                   enableChannel: notSearchForSameContents
                   tabable: true
                   model: ignoreCaseInNotContents
                   translateLabel: true
                 )
                (CheckBoxSpec
                   label: 'Cache Info'
                   name: 'RememberInCacheCheckBox'
                   layout: (LayoutFrame -350 1 125 0 -167 1 148 0)
                   visibilityChannel: canUseGrep
                   enableChannel: searchForSameContents
                   tabable: true
                   model: rememberInCache
                   translateLabel: true
                 )
                (ActionButtonSpec
                   label: 'Clear Cache'
                   name: 'ClearCacheButton'
                   layout: (LayoutFrame -169 1 125 0 -21 1 147 0)
                   translateLabel: true
                   model: clearCache
                 )
                (CheckBoxSpec
                   label: 'Show Unreadable Files and Folders'
                   name: 'CheckBox2'
                   layout: (LayoutFrame -350 1 149 0 0 1 172 0)
                   tabable: true
                   model: showUnreadableFilesAndDirectoriesHolder
                   translateLabel: true
                 )
                )
              
             )
           )
          (SequenceViewSpec
             name: 'List1'
             layout: (LayoutFrame 0 0.0 238 0 0 1.0 0 1)
             model: selectionHolder
             menu: menu
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             isMultiSelect: true
             doubleClickSelector: fileDoubleClick:
             valueChangeSelector: fileSelected:
             useIndex: true
             sequenceList: shownListHolder
             properties: 
            (PropertyListDictionary
               dropObjectSelector: getDropObjects:
               displayObjectSelector: getDisplayObjects:
               startDragSelector: doStartDrag:in:
               dragArgument: findFileList
             )
           )
          )
        
       )
     )

! !

!FindFileApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FindFileApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FindFileApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasOneFileSelected
            label: 'Open in New File Browser'
            itemValue: openInNewBrowser
          )
         (MenuItem
            enabled: hasOneFileSelected
            label: 'Select in Browser'
            itemValue: selectInBrowser
            isVisible: isEmbeddedApplication
          )
         (MenuItem
            label: 'Autoselect in Browser'
            indication: autoSelectInBrowserHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasOneFileSelected
            label: 'FileIn'
            itemValue: fileInInBrowser
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionInResultList
            label: 'Copy Selected Filenames to Clipboard'
            itemValue: copySelectedFileNamesToClipboard
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete Selected File(s)...'
            itemValue: deleteSelectedFiles
          )
         (MenuItem
            enabled: hasListEntries
            label: 'Delete all Files...'
            itemValue: deleteAllFiles
            isVisible: false
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Touch Selected File(s)...'
            itemValue: touchSelectedFiles
          )
         (MenuItem
            enabled: hasListEntries
            label: 'Touch all Files...'
            itemValue: touchAllFiles
            isVisible: false
          )
         (MenuItem
            label: '-'
            isVisible: cvsMenusAreShown
          )
         (MenuItem
            enabled: hasSelection
            label: 'Commit Selected File(s) to CVS...'
            itemValue: commitSelectedFilesToCVS
            isVisible: cvsMenusAreShown
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete Selected File(s) and CVS Container(s)...'
            itemValue: deleteSelectedFilesAndCVSContainers
            isVisible: cvsMenusAreShown
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Remove Selected from Resultlist'
            itemValue: removeSelectedFilesFromResultList
          )
         (MenuItem
            enabled: hasListEntries
            label: 'Clear Resultlist'
            itemValue: clearResultList
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Show Matched Files (After SameContents-Search)'
            itemValue: showMatchedFiles:
            isVisible: notShowingMatchedFiles
            argument: true
          )
         (MenuItem
            label: 'Show Matching Files (After SameContents-Search)'
            itemValue: showMatchedFiles:
            isVisible: showingMatchedFiles
            argument: false
          )
         (MenuItem
            enabled: hasTwoFilesSelected
            label: 'Compare with Each Other'
            itemValue: doCompareTwoFiles
            argument: false
          )
         )
        nil
        nil
      )
!

searchMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FindFileApplication andSelector:#searchMenu
     (Menu new fromLiteralArrayEncoding:(FindFileApplication searchMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Search'
            itemValue: doSearch
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary searchFileIcon)
          )
         (MenuItem
            enabled: enableStop
            label: 'Stop'
            itemValue: stop
            translateLabel: true
            isButton: true
            isVisible: enableStop
            labelImage: (ResourceRetriever XPToolbarIconLibrary stop22x22Icon)
          )
         (MenuItem
            label: 'Close'
            itemValue: doClose
            translateLabel: true
            isButton: true
            startGroup: right
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         )
        nil
        nil
      )
! !

!FindFileApplication class methodsFor:'startup & release'!

releaseContentsInfoCache
    ContentsInfoCache := ContentsInfoCacheAccessLock := nil.
! !

!FindFileApplication class methodsFor:'tableColumns specs'!

searchResultTable
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:FindFileApplication andSelector:#searchResultTable
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Filename'
         id: 'FileName'
         labelButtonType: Button
         model: fileName
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
! !

!FindFileApplication methodsFor:'actions'!

clearCache
    contentsInfoCache := nil
!

clearResultList
    self resultList removeAll.
    self matchedFilesList removeAll.
!

deleteAllFiles
    |files|

    files := self shownList copy.
    self deleteFiles:files confirm:true.
    self removeFilesFromResultList:files

    "Modified: / 29-03-2012 / 10:06:09 / cg"
!

deleteFiles:colOfFiles confirm:confirm
    "delete current selected files/directories
    "
    |delete result|

"/    self windowGroup withWaitCursorDo:[
        delete := FileOperation deleteFiles:(colOfFiles asSet) confirm:confirm.
        result := delete result.
        result notNil ifTrue:[
            result ifFalse:[
                self notify:delete errorString.
            ] ifTrue:[
"/                masterApplication notNil ifTrue:[
"/                    masterApplication updateListAfterDelete:colOfFiles.
"/                ]
            ]
        ].
"/    ].
    ^ result.

    "Modified: / 25-07-2006 / 09:11:09 / cg"
!

deleteSelectedFiles
    |sel files result|

    sel := self selectionHolder value.
    sel isEmptyOrNil ifTrue:[^ self].

    files := sel collect:[:idx | self shownList at:idx].
    self deleteFiles:files confirm:true.
    result == true ifTrue:[
        self removeFilesFromResultList:files
    ].

    "Modified: / 29-03-2012 / 10:05:39 / cg"
!

doCompareTwoFiles
    |sel entry1 entry2|

    sel := self selectionHolder value.
    sel size == 2 ifFalse:[^ self].

    entry1 := self shownList at:sel first.
    (entry1 := entry1 asFilename) exists ifFalse:[
        self warn:'Oops - file is gone: ',entry1 pathName
    ].
    entry2 := self shownList at:sel second.
    (entry2 := entry2 asFilename) exists ifFalse:[
        self warn:'Oops - file is gone: ',entry2 pathName
    ].
    masterApplication openDiffViewOn:entry1 and:entry2
!

doSearch
    |namePatterns excludedNamePatterns contentsPattern notContentsPattern 
     dir dirs fn fileToCompareAgainst ignoreCaseInName ignoreCaseInExcludedName 
     ignoreCaseInContents ignoreCaseInNotContents|

"/    self changeExtentToSeeSearchResult.

    dir := self searchDirectoryHolder value.
    dir isNil ifTrue:[
        Dialog warn:(resources string:'Missing directory name').
        ^ self.
    ].
    dir asString includesMatchCharacters ifTrue:[
        dirs := Filename filesMatchingGLOB:dir.
        dirs isEmpty ifTrue:[
            Dialog warn:(resources string:'No matching directory: ''%1''' with:dir allBold).
            ^ self.
        ].    
    ] ifFalse:[    
        dir asFilename exists ifFalse:[
            Dialog warn:(resources string:'No such directory: ''%1''' with:dir allBold).
            ^ self.
        ].
        dirs := { dir }
    ].

    LastShowUnreadableFilesAndDirectories := showUnreadableFilesAndDirectoriesHolder value.
    LastSearchIgnoredCaseInFilename := ignoreCaseInName := self ignoreCaseInName value.
    LastSearchIgnoredCaseInExcludedFilename := ignoreCaseInExcludedName := self ignoreCaseInExcludedName value.
    LastSearchIgnoredCaseInContents := ignoreCaseInContents := self ignoreCaseInContents value.
    ignoreCaseInNotContents := self ignoreCaseInNotContents value.

    self stopSearchTaskOrAbort.

    namePatterns := self namePatternsFor:(self namePatternHolder value) ignoringCase:ignoreCaseInName.
    excludedNamePatterns := self namePatternsFor:(self excludedNamePatternHolder value) ignoringCase:ignoreCaseInExcludedName.

    contentsPattern := self contentsPatternHolder value.
    contentsPattern size == 0 ifTrue:[
        contentsPattern := nil
    ] ifFalse:[
        self class addToSearchStringHistory:contentsPattern.
        ignoreCaseInContents ifTrue:[
            contentsPattern := contentsPattern asLowercase
        ].
    ].
    notContentsPattern := self notContentsPatternHolder value.
    notContentsPattern size == 0 ifTrue:[
        notContentsPattern := nil
    ] ifFalse:[
        ignoreCaseInNotContents ifTrue:[
            notContentsPattern := notContentsPattern asLowercase
        ]
    ].
    searchForSameContents value ifTrue:[
        fileToCompareAgainst := (self sameContentsAsHolder value ? '') withoutSeparators.
        fileToCompareAgainst isEmpty ifTrue:[
            fileToCompareAgainst := nil.
        ] ifFalse:[
            fileToCompareAgainst includesMatchCharacters ifFalse:[
                (fn := fileToCompareAgainst asFilename) exists ifFalse:[
                    Dialog warn:('No such file: %1' bindWith:fileToCompareAgainst allBold).
                    ^ self.
                ].
                fn isReadable ifFalse:[
                    Dialog warn:('Cannot read: %1' bindWith:fileToCompareAgainst allBold).
                    ^ self.
                ]
            ].
        ].
    ].

    self 
        startSearchTask:[
            self changeInformationTo:'Find File ' , '- searching ' toTab:true.
            self 
                doFindFileNamed:namePatterns
                directories:(self searchDirectories value)
                ignoreCaseInName:ignoreCaseInName
                excludeFilesNamed:excludedNamePatterns
                ignoreCaseInExcludedName:ignoreCaseInExcludedName
                containingString:contentsPattern
                ignoreCaseInContents:ignoreCaseInContents
                notContainingString:notContentsPattern
                ignoreCaseInNotContents:ignoreCaseInNotContents
                sameContentsAsFile:fileToCompareAgainst  
                sameContentsAs:nil 
                in:dirs.

        ]
        name:('FindFile[', dir asFilename baseName, ']')

    "Modified: / 16-03-2012 / 09:37:13 / cg"
!

fileInInBrowser
    |sel entry application|

    sel := self selectionHolder value.
    (sel notEmptyOrNil) ifTrue:[
        entry := self shownList at:sel first.
        entry asFilename exists ifFalse:[ ^ self].

        application := targetApplication ? self masterApplication.
        application notNil ifTrue:[
            application fileIn:(entry asFilename).
        ].
    ].

    "Created: / 20-09-2006 / 14:30:37 / cg"
!

namePatternsFor:namePatternArg ignoringCase:ignoringCase
    |namePattern|

    namePattern := namePatternArg.
    namePattern size == 0 ifTrue:[
        ^ nil
    ].
    ignoringCase ifTrue:[
        namePattern := namePattern asLowercase
    ].
    ^ (namePattern asCollectionOfSubstringsSeparatedBy:$;)
        collect:[:each | each withoutSeparators].

    "Created: / 03-08-2011 / 18:19:20 / cg"
!

removeFilesFromResultList:listOfFiles 
    |list|

    list := self shownList.
    (listOfFiles notEmptyOrNil) ifTrue:[
        listOfFiles reverseDo:[: key |
            list removeAtIndex:key
        ]
    ].

    "Created: / 29-03-2012 / 10:04:58 / cg"
!

removeSelectedFilesFromResultList
    self removeFilesFromResultList:(self selectionHolder value)

    "Modified: / 29-03-2012 / 10:05:11 / cg"
!

showMatchedFiles:aBoolean
    aBoolean ifTrue:[
        self shownListHolder valueHolder:(self matchedFilesList)
    ] ifFalse:[
        self shownListHolder valueHolder:(self resultList)
    ].
!

touchAllFiles
    |files|

    files := self shownList copy.
    self touchFiles:files.
!

touchFiles:colOfFiles
    "touch current selected files/directories
    "
    colOfFiles asSet do:[:each |
        OperatingSystem executeCommand:('touch %1' bindWith:each asFilename pathName).
    ].
!

touchSelectedFiles
    |sel files|

    sel := self selectionHolder value.
    sel isEmptyOrNil ifTrue:[^ self].

    files := sel collect:[:idx | self shownList at:idx].
    self touchFiles:files.
! !

!FindFileApplication methodsFor:'actions-CVS'!

commitSelectedFilesToCVS
    |sel files|

    sel := self selectionHolder value.
    files := sel collect:[:idx | (self shownList at:idx) asFilename ].
    masterApplication commitFilesToCVS:files
!

deleteSelectedFilesAndCVSContainers
    |sel files|

    sel := self selectionHolder value.
    files := sel collect:[:idx | (self shownList at:idx) asFilename ].
    masterApplication removeFilesAndCVSContainers:files
! !

!FindFileApplication methodsFor:'aspects'!

canUseGrep
    "grep command is much faster, but:
        - not under MSDOS
    "

    ^ OperatingSystem isUNIXlike and:[ OperatingSystem canExecuteCommand:'egrep' ]
!

canUseLocate
    "locate command is much faster, but:
        - only if searching recursively,
        - no case ignore
        - no contents matching
    "

    ^ OperatingSystem isUNIXlike and:[ OperatingSystem canExecuteCommand:'locate' ]
!

contentsPatternHolder

    contentsPatternHolder isNil ifTrue:[
        contentsPatternHolder := nil asValue.
        self class searchStringHistory size > 0 ifTrue:[
            contentsPatternHolder value:(self class searchStringHistory first).    
        ].
    ].
    ^ contentsPatternHolder.
!

enableFileSizeFilter
    enableFileSizeFilter isNil ifTrue:[
        enableFileSizeFilter := false asValue.
    ].
    ^ enableFileSizeFilter.
!

enableFileSizeFilterAndNotSearchForSameContents
    ^ BlockValue forLogical:self notSearchForSameContents and:self enableFileSizeFilter
!

enableModificationTimeFilter
    enableModificationTimeFilter isNil ifTrue:[
        enableModificationTimeFilter := false asValue.
    ].
    ^ enableModificationTimeFilter.

    "Created: / 28-03-2012 / 23:11:58 / cg"
!

excludedNamePatternHolder
    excludedNamePatternHolder isNil ifTrue:[
        excludedNamePatternHolder := '' asValue.
    ].
    ^ excludedNamePatternHolder.

    "Created: / 03-08-2011 / 18:03:14 / cg"
!

fileSizeHolder
    fileSizeHolder isNil ifTrue:[
        fileSizeHolder := 0 asValue.
    ].
    ^ fileSizeHolder.
!

fileSizeOperatorHolder
    fileSizeOperatorHolder isNil ifTrue:[
        fileSizeOperatorHolder := '>' asValue.
    ].
    ^ fileSizeOperatorHolder.
!

fileSizeUnitHolder
    fileSizeUnitHolder isNil ifTrue:[
        fileSizeUnitHolder := 'b' asValue.
    ].
    ^ fileSizeUnitHolder.
!

ignoreCaseInContents
    ignoreCaseInContents isNil ifTrue:[
        ignoreCaseInContents := (LastSearchIgnoredCaseInContents notNil
                                    ifTrue:[ LastSearchIgnoredCaseInContents ]
                                    ifFalse:[ TextView lastSearchIgnoredCase ? true]) asValue.
    ].
    ^ ignoreCaseInContents.

    "Modified: / 03-08-2011 / 18:05:02 / cg"
!

ignoreCaseInExcludedName

    ignoreCaseInExcludedName isNil ifTrue:[
        ignoreCaseInExcludedName := (LastSearchIgnoredCaseInExcludedFilename notNil 
                                        ifTrue:[ LastSearchIgnoredCaseInExcludedFilename ]
                                        ifFalse:[ OperatingSystem caseSensitiveFilenames not]) asValue.
    ].
    ^ ignoreCaseInExcludedName.

    "Created: / 03-08-2011 / 18:03:38 / cg"
!

ignoreCaseInName
    ignoreCaseInName isNil ifTrue:[
        ignoreCaseInName := (LastSearchIgnoredCaseInFilename notNil
                                ifTrue:[LastSearchIgnoredCaseInFilename]
                                ifFalse:[ OperatingSystem caseSensitiveFilenames not ]) asValue.
    ].
    ^ ignoreCaseInName.

    "Modified (format): / 03-08-2011 / 18:05:49 / cg"
!

ignoreCaseInNotContents
    ignoreCaseInNotContents isNil ifTrue:[
        ignoreCaseInNotContents := (LastSearchIgnoredCaseInContents 
                                    ? TextView lastSearchIgnoredCase 
                                    ? true) asValue.
    ].
    ^ ignoreCaseInNotContents.
!

modificationTimeHolder
    modificationTimeHolder isNil ifTrue:[
        modificationTimeHolder := (Timestamp now subtractDays:1) asValue.
    ].
    ^ modificationTimeHolder.

    "Created: / 28-03-2012 / 23:08:25 / cg"
!

modificationTimeOperatorHolder
    modificationTimeOperatorHolder isNil ifTrue:[
        modificationTimeOperatorHolder := 'after' asValue.
        modificationTimeOperatorHolder onChangeSend:#modificationTimeOperatorChanged to:self.
    ].
    ^ modificationTimeOperatorHolder.

    "Created: / 28-03-2012 / 23:04:44 / cg"
!

modificationTimeOperatorIndexHolder
    modificationTimeOperatorIndexHolder isNil ifTrue:[
        modificationTimeOperatorIndexHolder := 1 asValue.
        modificationTimeOperatorIndexHolder onChangeSend:#modificationTimeOperatorChanged to:self.
    ].
    ^ modificationTimeOperatorIndexHolder.

    "Created: / 28-03-2012 / 23:04:44 / cg"
!

modificationTimeOperatorLabelList
    ^ self modificationTimeOperatorSpecList collect:#first
!

modificationTimeOperatorSpecList
    ^ #(
        ('before'   #before)
        ('after'    #after)
        ('in day'   #inDay)
        ('in month' #inMonth)
        ('in year'  #inYear)
    )
!

modificationTimeOperatorValueList
    ^ self modificationTimeOperatorSpecList collect:#second
!

namePatternHolder

    namePatternHolder isNil ifTrue:[
        namePatternHolder := '*' asValue.
    ].
    ^ namePatternHolder.
!

notContentsPatternHolder
    notContentsPatternHolder isNil ifTrue:[
        notContentsPatternHolder := nil asValue.
    ].
    ^ notContentsPatternHolder.
!

notSearchForSameContents
    ^ BlockValue forLogicalNot:self searchForSameContents
!

notShowingMatchedFiles
    ^ self shownList == self resultList
!

rememberInCache
    rememberInCache isNil ifTrue:[
        rememberInCache := (LastRememberInCache ? false) asValue.
    ].
    ^ rememberInCache.
!

sameContentsAsHolder
    |sel|

    sameContentsAsHolder isNil ifTrue:[
        sameContentsAsHolder := ValueHolder new.
        masterApplication notNil ifTrue:[
            sel := masterApplication currentSelectedFiles.
            sel size > 0 ifTrue:[
                sameContentsAsHolder value:(sel first asFilename pathName).
            ].
        ].
    ].
    ^ sameContentsAsHolder.
!

searchDirectories
    searchDirectories isNil ifTrue:[
        searchDirectories := false asValue.
    ].
    ^ searchDirectories.
!

searchDirectoryHolder

    searchDirectoryHolder isNil ifTrue:[
        searchDirectoryHolder := ValueHolder new.
    ].
    ^ searchDirectoryHolder.
!

searchForSameContents
    searchForSameContents isNil ifTrue:[
        searchForSameContents := false asValue.
    ].
    ^ searchForSameContents.
!

searchOnlyInCache
    searchOnlyInCache isNil ifTrue:[
        searchOnlyInCache := false asValue.
    ].
    ^ searchOnlyInCache.
!

showUnreadableFilesAndDirectoriesHolder
    showUnreadableFilesAndDirectoriesHolder isNil ifTrue:[
        showUnreadableFilesAndDirectoriesHolder := (LastShowUnreadableFilesAndDirectories ? false) asValue.
    ].
    ^ showUnreadableFilesAndDirectoriesHolder.
!

showingMatchedFiles
    ^ self shownList == self matchedFilesList
!

useGrep
    useGrep isNil ifTrue:[
        useGrep := false asValue.
    ].
    ^ useGrep.
!

useLocate
    useLocate isNil ifTrue:[
        useLocate := false asValue.
    ].
    ^ useLocate.
! !

!FindFileApplication methodsFor:'change & update'!

modificationTimeOperatorChanged
    |timeEditField converter realModel idx operator|

    timeEditField := (self componentAt:'ModifiedEntryField').
    converter := timeEditField model.
    realModel := converter model.
    self assert:(self modificationTimeHolder == realModel).
    idx := self modificationTimeOperatorIndexHolder value.
    operator := self modificationTimeOperatorValueList at:idx.
    
    ((operator == #after) or:[operator = #before]) ifTrue:[
        realModel setValue:(realModel value asTimestamp).    
        converter timeOfClass:Timestamp withFormat:nil orDefault:Timestamp now    
    ] ifFalse:[    
        operator = #inDay ifTrue:[
            realModel setValue:(realModel value asDate).    
            converter timeOfClass:Date withFormat:'%y-%m-%d' orDefault:Date today    
        ] ifFalse:[    
            operator = #inMonth ifTrue:[
                realModel setValue:(realModel value asDate).    
                converter monthAndYear    
            ] ifFalse:[    
                operator = #inYear ifTrue:[
                    realModel setValue:(realModel value asDate).    
                    converter year    
                ] ifFalse:[
                    self halt.
                ].    
            ].    
        ].    
    ].    
    realModel changed.
! !

!FindFileApplication methodsFor:'private'!

changeExtentToSeeSearchResult
    
    | extent window|

    expanded isNil ifTrue:[
        window := self builder window.
        window notNil ifTrue:[
            window := window topView.
            extent := window extent.
            window extent:((extent x) @ (extent y + 300)).
            expanded := true.
            window containerChangedSize.
        ].
    ].

    "Modified: / 08-08-2010 / 14:42:40 / cg"
! !

!FindFileApplication methodsFor:'private - searching'!

cachedFileSizeOf:aFilenameString
    |cache cacheLine fileSize|

    cache := self contentsInfoCache.
    cache isNil ifTrue:[
        fileSize := aFilenameString asFilename fileSize
    ] ifFalse:[
        ContentsInfoCacheAccessLock critical:[
            cacheLine := cache at:aFilenameString ifAbsent:nil.
            cacheLine isNil ifTrue:[
                cache at:aFilenameString put:(cacheLine := Array new:2).
            ] ifFalse:[
                fileSize := (cacheLine at:1).
            ].

            fileSize isNil ifTrue:[
                fileSize := aFilenameString asFilename fileSize.
                cacheLine at:1 put:fileSize.
            ].
        ].
    ].
    ^ fileSize
!

cachedHashValueOfFile:aFilenameString
    |cache cacheLine hashValue|

    cache := self contentsInfoCache.
    cache isNil ifTrue:[
        hashValue := MD5Stream hashValueOfFile:aFilenameString asFilename
    ] ifFalse:[
        ContentsInfoCacheAccessLock critical:[
            cacheLine := cache at:aFilenameString ifAbsent:nil.
            cacheLine isNil ifTrue:[
                cache at:aFilenameString put:(Array new:2).
            ] ifFalse:[
                hashValue := (cacheLine at:2).
            ].

            hashValue isNil ifTrue:[
                hashValue := MD5Stream hashValueOfFile:aFilenameString asFilename.
                cacheLine at:2 put:hashValue.
            ].
        ].
    ].
    ^ hashValue
!

contentsInfoCache
    contentsInfoCache isNil ifTrue:[
        ContentsInfoCache isNil ifTrue:[
            ContentsInfoCache := Dictionary new.    
            ContentsInfoCacheAccessLock := Semaphore forMutualExclusion.
        ].
        contentsInfoCache := ContentsInfoCache
    ].
    ^ contentsInfoCache
!

doFindFileNamed:namePatterns directories:searchDirectories ignoreCase:ignCaseInName 
    containingString:contentsStringArg ignoreCaseInContents:ignCaseInContents 
    notContainingString:notContentsStringArg ignoreCaseInNotContents:ignCaseInNotContents 
    sameContentsAsFile:filenameToCompareContentsOrNil sameContentsAs:bytesToCompareContentsOrNil in:aDirectory

    "/ only for backward compatibility...
    ^ self
        doFindFileNamed:namePatterns directories:searchDirectories ignoreCaseInName:ignCaseInName
        excludeFilesNamed:'' ignoreCaseInExcludedName:false
        containingString:contentsStringArg ignoreCaseInContents:ignCaseInContents 
        notContainingString:notContentsStringArg ignoreCaseInNotContents:ignCaseInNotContents 
        sameContentsAsFile:filenameToCompareContentsOrNil sameContentsAs:bytesToCompareContentsOrNil in:aDirectory

    "Modified: / 03-08-2011 / 18:16:42 / cg"
!

doFindFileNamed:namePatterns directories:searchDirectories ignoreCaseInName:ignCaseInName
    excludeFilesNamed:excludedNamePatterns ignoreCaseInExcludedName:ignoreCaseInExcludedName
    containingString:contentsStringArg ignoreCaseInContents:ignCaseInContents 
    notContainingString:notContentsStringArg ignoreCaseInNotContents:ignCaseInNotContents 
    sameContentsAsFile:filenameToCompareContentsOrNil 
    sameContentsAs:bytesToCompareContentsOrNil 
    in:aDirectoryOrCollectionOfDirectories

    "the main workhorse for searching files.
     Creates optimized search blocks, depending on how we search,
     and passes these to the recursive directory walker.
     (got too big, and may need some splitting/refactoring"

    |theSingleDirectory lines contentsToCompare resultList inStream
     doesFileMatch contentsString notContentsString check checkNot 
     grepCommand nameMatch nameExcludedMatch realNameMatch 
     fileSizesToSearchFor filesToSearchFor fileMD5sToSearchFor 
     setOfFilesToSearchFor remember cache fn dirSearchedRelative easyCheck|

    (aDirectoryOrCollectionOfDirectories isFilename
    or:[aDirectoryOrCollectionOfDirectories isString]) ifTrue:[
        theSingleDirectory := aDirectoryOrCollectionOfDirectories asFilename
    ] ifFalse:[
        (aDirectoryOrCollectionOfDirectories size == 1) ifTrue:[
            theSingleDirectory := aDirectoryOrCollectionOfDirectories first asFilename
        ].
    ].
    
    "/ dir := aDirectory asFilename.
    contentsString := contentsStringArg.
    (contentsString notEmptyOrNil and:[ ignCaseInContents ]) ifTrue:[ 
        contentsString := contentsString asLowercase
    ].
    notContentsString := notContentsStringArg.
    (notContentsString notEmptyOrNil and:[ ignCaseInNotContents ]) ifTrue:[ 
        notContentsString := notContentsString asLowercase    
    ].
    filenameToCompareContentsOrNil notEmptyOrNil ifTrue:[
        fileSizesToSearchFor := OrderedCollection new.
        filesToSearchFor := OrderedCollection new.
        fileMD5sToSearchFor := OrderedCollection new.

        filenameToCompareContentsOrNil includesMatchCharacters ifTrue:[
            |dir|
            
            dir := filenameToCompareContentsOrNil asFilename.
            [dir pathName includesMatchCharacters] whileTrue:[
                dir := dir directory
            ].
            dir recursiveDirectoryContentsDo:[:relName |
                |path fn|

                fn := dir construct:relName.
                (filenameToCompareContentsOrNil match:fn name) ifTrue:[
                    fn isDirectory ifFalse:[
                        fileSizesToSearchFor add:(self cachedFileSizeOf:fn).
                        filesToSearchFor add:(fn name).
                        fileMD5sToSearchFor add:(self cachedHashValueOfFile:fn).
                    ]
                ]
            ].
        ] ifFalse:[
            fn := filenameToCompareContentsOrNil asFilename.
            fileSizesToSearchFor add:(self cachedFileSizeOf:fn).
            filesToSearchFor add:(fn pathName).
            fileMD5sToSearchFor add:(self cachedHashValueOfFile:fn).
        ].

        remember := LastRememberInCache := self rememberInCache value.
        remember ifTrue:[
            cache := self contentsInfoCache.
        ].
        setOfFilesToSearchFor := filesToSearchFor asSet.
    ].    
    
"/    dirSearchedRelative := (dir name) copyFrom:(self searchDirectoryHolder value asString size + 1).
"/    dirSearchedRelative notEmpty ifTrue:[
"/        self changeInformationTo:('Find File - searching %1' bindWith:dirSearchedRelative) toTab:false.
"/    ] ifFalse:[
        self changeInformationTo:'Find File - searching' toTab:false.
"/    ].

    resultList := self resultList.

    filenameToCompareContentsOrNil notEmptyOrNil ifTrue:[
        doesFileMatch := 
            [:f |
                |contentsMatches mustValidateExistance 
                 fileMD5 fileName fileSize cacheLine idxInList matchedFile|

                "/ contents compare ...
                contentsMatches := false.
                fileName := f name.
                (setOfFilesToSearchFor includes:fileName) ifFalse:[
                    mustValidateExistance := false.

                    cache notNil ifTrue:[
                        ContentsInfoCacheAccessLock critical:[
                            cacheLine := cache at:fileName ifAbsent:nil.
                            cacheLine notNil ifTrue:[
                                fileSize := cacheLine at:1.    
                                fileMD5 := cacheLine at:2.
                                mustValidateExistance := true.
                            ].
                        ].
                    ].

                    fileSize isNil ifTrue:[
                        fileSize := f fileSize.
                    ].
                    remember ifTrue:[
                        ContentsInfoCacheAccessLock critical:[
                            cacheLine := cache at:fileName ifAbsentPut:[Array new:2].
                            cacheLine at:1 put:fileSize.
                        ]
                    ].
                    (idxInList := fileSizesToSearchFor indexOf:fileSize) ~~ 0 ifTrue:[
                        fileMD5 isNil ifTrue:[
                            OpenError handle:[:ex |
                                ObjectMemory garbageCollect.
                                fileMD5 := MD5Stream hashValueOfFile:f.
                            ] do:[
                                fileMD5 := MD5Stream hashValueOfFile:f.
                            ].
                            remember ifTrue:[
                                cacheLine at:2 put:fileMD5
                            ].
                        ].
                        contentsMatches := (fileMD5 = (fileMD5sToSearchFor at:idxInList)).
                        contentsMatches ifTrue:[
                            mustValidateExistance ifTrue:[
                                fileName asFilename exists ifFalse:[
                                    ContentsInfoCacheAccessLock critical:[
                                        cache removeKey:fileName.
                                    ].
                                    contentsMatches := false.
                                ].
                            ].
                            contentsMatches ifTrue:[
                                matchedFile := filesToSearchFor at:idxInList.
                                self matchedFilesList add:matchedFile.
                            ].
                        ].
"/                        contentsToCompare isNil ifTrue:[
"/                            filenameToCompareContentsOrNil fileSize < (512*1024) ifTrue:[
"/                                contentsToCompare := filenameToCompareContentsOrNil binaryContentsOfEntireFile
"/                            ]
"/                        ].
"/                        contentsToCompare isNil ifTrue:[
"/                            "/ too large - compare block-wise ...
"/                            contentsMatches := (filenameToCompareContentsOrNil sameContentsAs:f).
"/                        ] ifFalse:[
"/                            contentsMatches := contentsToCompare = (f binaryContentsOfEntireFile).
"/                        ]
                    ].
                ] ifTrue:[
                    f isSymbolicLink ifTrue:[
                        resultList add: (f name , ' is a symbolic link to ' , f pathName).
                    ]
                ].
                contentsMatches
            ].
    ] ifFalse:[
        (contentsString isEmptyOrNil and:[notContentsString isEmptyOrNil]) ifTrue:[
            doesFileMatch := [:f | true].
        ] ifFalse:[
            (self canUseGrep and:[self useGrep value]) ifTrue:[
                (ignCaseInContents not and:[ignCaseInNotContents not]) ifTrue:[
                    contentsString notEmptyOrNil ifTrue:[
                        notContentsString notEmptyOrNil ifTrue:[
                            grepCommand := '(grep "',contentsString,'" %1) && (grep -v "',notContentsString,'" %1)'.
                        ] ifFalse:[
                            grepCommand := 'grep "' , contentsString , '" %1'.
                        ].
                    ] ifFalse:[
                        grepCommand := 'grep -v "' , notContentsString , '" %1'.
                    ].
                    doesFileMatch := [:f | |cmd ret|
                                            cmd := grepCommand bindWith:f pathName.
                                            ret := OperatingSystem executeCommand:cmd.
                                            ret
                                     ].
                ]
            ].

            doesFileMatch isNil ifTrue:[
                contentsString notEmptyOrNil ifTrue:[
                    ignCaseInContents ifTrue:[
                        check := easyCheck := [:l | l includesString:contentsString caseSensitive:false]
                    ] ifFalse:[
                        check := easyCheck := [:l | l includesString:contentsString]
                    ].
                ].
                notContentsString notEmptyOrNil ifTrue:[
                    ignCaseInNotContents ifTrue:[
                        checkNot := [:l | (l includesString:notContentsString caseSensitive:false)]
                    ] ifFalse:[
                        checkNot := [:l | (l includesString:notContentsString)]
                    ].
                ].

                doesFileMatch := 
                    [:f |
                        |realFile contentsMatches contentsNotMatches sz hugeFile bigFile isBadFile|

                        "/ string search ...
                        contentsMatches := true.
                        (f exists and:[f isReadable]) ifFalse:[
                            showUnreadableFilesAndDirectoriesHolder value ifTrue:[
                                resultList add: (('*** "',f pathName,'" skipped - unreadable or bad symbolic link ***') withColor:(Color red darkened)).
                            ].
                            contentsMatches := false.
                        ] ifTrue:[
                            isBadFile := false.
                            realFile := f.
                            f isSymbolicLink ifTrue:[ 
                                realFile := f linkInfo linkTargetPath asFilename. 
                                (realFile exists and:[realFile isReadable]) ifFalse:[
                                    showUnreadableFilesAndDirectoriesHolder value ifTrue:[
                                        resultList add: (('*** "',f pathName,'"->"',realFile pathName,'" skipped - unreadable or bad symbolic link destination ***') withColor:(Color red darkened)).
                                    ].
                                    contentsMatches := false.
                                    isBadFile := true.
                                ].    
                            ].
                            isBadFile ifFalse:[
                                realFile isDirectory ifTrue:[
                                    contentsMatches := false.
                                ] ifFalse:[    
                                    sz := realFile fileSize.
                                    sz isNil ifTrue:[
                                        contentsMatches := false.
                                    ] ifFalse:[
                                        hugeFile := (sz ? 0) > (4024*1024).
                                        bigFile := (sz ? 0) > (512*1024).

                                        hugeFile ifTrue:[
                                            showUnreadableFilesAndDirectoriesHolder value ifTrue:[
                                                resultList add: (('*** ' , f pathName , ' skipped - too large ***') withColor:(Color red darkened)).
                                            ].
                                            contentsMatches := false.
                                        ] ifFalse:[
                                            Stream lineTooLongErrorSignal handle:[:ex |
                                                |cont|

            "/                                    "/ this typically happens, when a binary file is read linewise ...
                                                showUnreadableFilesAndDirectoriesHolder value ifTrue:[
                                                    resultList add: (('*** ' , f pathName , ' skipped - binary/long line ***') withColor:(Color red darkened)).
                                                ].
                                                contentsMatches := false.
                                            ] do:[
                                                bigFile ifTrue:[
                                                    Stream lineTooLongErrorSignal handle:[:ex |
                                                        showUnreadableFilesAndDirectoriesHolder value ifTrue:[
                                                            resultList add: (('*** ' , f pathName , ' skipped - too large ***') withColor:(Color red darkened)).
                                                        ].
                                                        contentsMatches := false.
                                                    ] do:[
                                                        contentsMatches := false.
                                                        (check == easyCheck 
                                                        and:[ realFile size < (128*1024) ]) ifTrue:[
                                                            check notNil ifTrue:[
                                                                contentsMatches := realFile contentsAsString includesString: contentsString caseSensitive:ignCaseInContents not.
                                                                (contentsMatches and:[ checkNot notNil ]) ifTrue:[
                                                                    contentsMatches := (realFile contentsAsString includesString: notContentsString caseSensitive:ignCaseInNotContents not) not.
                                                                ].
                                                            ] ifFalse:[
                                                                checkNot notNil ifTrue:[
                                                                    contentsMatches := (realFile contentsAsString includesString: notContentsString caseSensitive:ignCaseInNotContents not) not.
                                                                ].
                                                            ].
                                                        ] ifFalse:[
                                                            contentsNotMatches := false.
                                                            realFile readingFileDo:[:stream |
                                                                [contentsMatches or:[contentsNotMatches or:[stream atEnd]]] whileFalse:[
                                                                    |line|

                                                                    line := stream nextLine.
                                                                    check notNil ifTrue:[
                                                                        contentsMatches := check value:line
                                                                    ].
                                                                    checkNot notNil ifTrue:[
                                                                        contentsNotMatches := checkNot value:line
                                                                    ].
                                                                ]
                                                            ].
                                                        ].
                                                    ].
                                                ] ifFalse:[
                                                    lines := realFile contents ? #().
                                                    check notNil ifTrue:[
                                                        contentsMatches := lines contains:check
                                                    ].
                                                    (contentsMatches and:[ checkNot notNil ]) ifTrue:[
                                                        contentsMatches := (lines contains:checkNot) not
                                                    ]
                                                ]
                                            ].
                                        ].    
                                    ].
                                ].
                            ].
                        ].
                        contentsMatches
                    ].
            ].
        ].
        doesFileMatch := self fileSizeWrapperFor:doesFileMatch.
    ].

    doesFileMatch := self modificationTimeWrapperFor:doesFileMatch.

    namePatterns isNil ifTrue:[
        nameMatch := [:fn | true]
    ] ifFalse:[
        ignCaseInName ifTrue:[
            nameMatch := [:fn | namePatterns contains:[:aPattern | aPattern match:(fn asLowercase)]].
        ] ifFalse:[
            nameMatch := [:fn | namePatterns contains:[:aPattern | aPattern match:fn]].
        ].
    ].

    excludedNamePatterns isNil ifTrue:[
        nameExcludedMatch := [:fn | true]
    ] ifFalse:[
        ignoreCaseInExcludedName ifTrue:[
            nameExcludedMatch := [:fn | excludedNamePatterns contains:[:aPattern | aPattern match:(fn asLowercase)]].
        ] ifFalse:[
            nameExcludedMatch := [:fn | excludedNamePatterns contains:[:aPattern | aPattern match:fn]].
        ].
    ].

    "/ combine
    namePatterns isNil ifTrue:[
        excludedNamePatterns isNil ifTrue:[
            realNameMatch := [:fn | true]
        ] ifFalse:[
            realNameMatch := [:fn | (nameExcludedMatch value:fn) not]
        ].
    ] ifFalse:[
        excludedNamePatterns isNil ifTrue:[
            realNameMatch := nameMatch
        ] ifFalse:[
            realNameMatch := [:fn | (nameMatch value:fn) and:[ (nameExcludedMatch value:fn) not ]]
        ].
    ].

    (self canUseLocate 
    and:[self useLocate value
    and:[searchDirectories not
    and:[theSingleDirectory notNil]]])
    ifTrue:[
        [
            |updateInfo cmd line f|

            updateInfo :=
                [
                    self 
                        changeInformationTo:('%1 found' bindWith:resultList size) 
                        toTab:false.
                ].

            self window shown ifTrue:[
                updateInfo value.
            ].
            
            cmd := 'locate '.
            ignCaseInName ifTrue:[
                "/ cmd := cmd , '--ignore-case '
                cmd := cmd , '-i '
            ].

            cmd := cmd , ((namePatterns 
                            collect:[:nm | '"',nm,'"'])
                                asStringCollection asStringWith:Character space).
            inStream := PipeStream readingFrom:cmd inDirectory:theSingleDirectory.
            [inStream atEnd] whileFalse:[
                line := inStream nextLine.

                f := line asFilename.
                (doesFileMatch value:f) ifTrue:[
                    resultList add:line.
                    updateInfo value.
                ]
            ].
        ] ensure:[
            inStream notNil ifTrue:[inStream close].
        ].
        ^ self.
    ].

    bytesToCompareContentsOrNil notNil ifTrue:[
        contentsToCompare := bytesToCompareContentsOrNil
    ].

    filenameToCompareContentsOrNil notEmptyOrNil ifTrue:[
        self searchOnlyInCache value ifTrue:[
            cache notEmptyOrNil ifTrue:[
                cache keysAndValuesDo:[:fn :info |
                    |filesSize filesMD5 idxInList|

                    filesSize := info at:1.
                    filesSize isNil ifTrue:[
                        filesSize := fn asFilename fileSize.
                        info at:1 put:filesSize.
                    ].
                    (idxInList := fileSizesToSearchFor indexOf:filesSize) ~~ 0 ifTrue:[
                        (setOfFilesToSearchFor includes:fn) ifFalse:[
                            fn asFilename exists ifFalse:[
                                info at:1 put:nil.    
                                info at:2 put:nil.    
                            ] ifTrue:[
                                filesMD5 := info at:2.
                                filesMD5 isNil ifTrue:[
                                    filesMD5 := MD5Stream hashValueOfFile:fn asFilename.
                                    info at:2 put:filesMD5.
                                ].
                                filesMD5 = (fileMD5sToSearchFor at:idxInList) ifTrue:[
                                    resultList add:fn.
                                ]
                            ]
                        ]
                    ]
                ].
            ].
            ^ self.
        ].
    ].

    filesSearchedCount := 0.

    aDirectoryOrCollectionOfDirectories do:[:eachDir |
        self 
            doFindFileNamed:namePatterns 
            directories:searchDirectories
            nameMatch:realNameMatch 
            contentsMatch:doesFileMatch 
            in:eachDir.
    ]
    
    "Created: / 03-08-2011 / 18:16:02 / cg"
!

doFindFileNamed:namePatterns directories:searchDirectories nameMatch:nameMatch contentsMatch:doesFileMatch in:aDirectory
    "the recursive walker. Searches for files matching namematch-block,
     and contents matching doesFileMatch-block"

    |dir subDirs list directoryContents updateInfo|

    dir := aDirectory asFilename.

    updateInfo :=
        [
            self 
                changeInformationTo:('%1 found - searching %2' 
                                        bindWith:resultList size
                                        with:((dir name) copyFrom:(self searchDirectoryHolder value asString size + 1))) 
                toTab:false.
        ].

    self window shown ifTrue:[
        updateInfo value.
    ].
    list := self resultList.

    subDirs := OrderedCollection new.

    [
        directoryContents := dir directoryContents.
    ] on:FileStream openErrorSignal do:[:ex|
        self showUnreadableFilesAndDirectoriesHolder value ifTrue:[
            list add:((ex pathName , ' -> ' , ex description) withColor:Color red darkened).
        ].
        "/        self warn:('Cannot access %1\(%2)'
        "/                        bindWith:ex parameter printString
        "/                        with:ex description) withCRs.
        ^ self
    ].

    directoryContents sort do:[:fn |
        |f isDirectory|

        f := dir construct:fn.

        isDirectory := f isDirectory.
        isDirectory ifTrue:[
            f isSymbolicLink ifFalse:[
                subDirs add:f
            ]
        ].
        (searchDirectories or:[isDirectory not]) ifTrue:[
            (nameMatch value:fn) ifTrue:[
                filesSearchedCount := (filesSearchedCount ? 0) + 1.
                (isDirectory or:[ doesFileMatch value:f ])
                ifTrue:[
                    updateInfo value.
                    list add:(f asString).
                ]
            ]
        ]
    ].

    self searchRecursively value ifTrue:[
        subDirs do:[:dir |
            self
                doFindFileNamed:namePatterns 
                directories:searchDirectories 
                nameMatch:nameMatch 
                contentsMatch:doesFileMatch 
                in:dir
        ].
    ]

    "Modified: / 22-05-2015 / 11:42:17 / cg"
!

fileSizeWrapperFor:aFileMatchBlock
    "possibly wrap the search-match block into a file-size matcher"

    |fileSizeToCompare sizeMatch op compare|

    self enableFileSizeFilter value ifFalse:[ ^ aFileMatchBlock ].

    fileSizeToCompare := self fileSizeHolder value.
    op := self fileSizeOperatorHolder value withoutSeparators.
    op = '~' ifTrue:[
        compare := [:sz | sz between:(fileSizeToCompare*0.9) and:(fileSizeToCompare*1.1) ].
    ] ifFalse:[
        op := op asSymbol.
        compare := [:sz | sz perform:op with:fileSizeToCompare ].
    ].

    sizeMatch := [:f | 
                    |sz| 

                    sz := f fileSize. 
                    sz notNil and:[ compare value:sz ]
                 ].

    ^ [:f | (sizeMatch value:f) and:[ aFileMatchBlock value:f ]]

    "Created: / 11-01-2012 / 23:17:02 / cg"
!

modificationTimeWrapperFor:aFileMatchBlock
    "possibly wrap the search-match block into a modification time matcher"

    |timeToCompare timeMatch idx op compare|

    self enableModificationTimeFilter value ifFalse:[ ^ aFileMatchBlock ].

    timeToCompare := self modificationTimeHolder value.
    idx := self modificationTimeOperatorIndexHolder value.
    op := self modificationTimeOperatorValueList at:idx.
    op = #after ifTrue:[
        compare := [:t | t > timeToCompare ].
    ] ifFalse:[
        op = #before ifTrue:[
            compare := [:t | t < timeToCompare ].
        ] ifFalse:[
            op = #inDay ifTrue:[
                timeToCompare := timeToCompare asDate.
                compare := [:t | t asDate = timeToCompare ].
            ] ifFalse:[
                op = #inMonth ifTrue:[
                    timeToCompare := timeToCompare asDate.
                    compare := [:t | t month = timeToCompare month
                                     and:[t year = timeToCompare year] ].
                ] ifFalse:[
                    op = #inYear ifTrue:[
                        timeToCompare := timeToCompare asDate.
                        compare := [:t | t year = timeToCompare year ].
                    ] ifFalse:[
                        self halt.
                    ].    
                ].    
            ].    
        ].
    ].

    timeMatch := [:f | 
                    |t| 

                    t := f modificationTime. 
                    t notNil and:[ compare value:t ]
                 ].

    ^ [:f | (timeMatch value:f) and:[ aFileMatchBlock value:f ]]

    "Created: / 28-03-2012 / 23:18:32 / cg"
! !

!FindFileApplication methodsFor:'queries'!

getTabValueString
    "the item shown in a tab (not language translated)"

    ^ self fileName directory baseName

    "Created: / 01-03-2007 / 21:39:54 / cg"
! !

!FindFileApplication methodsFor:'startup & release'!

initialize
    super initialize.

    self enableStop value:false.
    self enableSearch value:true.

    "Created: / 12-01-2012 / 01:38:29 / cg"
!

item:anItem

    |file newPattern|

    super item:anItem.

    file := self fileName.
    self searchDirectoryHolder value:(self getDirWithoutFileName:file).

    file isDirectory ifTrue:[
        newPattern := '*'.
    ] ifFalse:[
        anItem suffix isEmptyOrNil ifTrue:[
            newPattern := '*'.
        ] ifFalse:[
            newPattern := '*.', anItem suffix.
        ].
    ].
    self namePatternHolder value:newPattern.
    ^ true.

    "Modified: / 12-01-2012 / 01:38:14 / cg"
!

postOpenWith:aBuilder
    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
    ].
    findFileView := aBuilder window.
    self windowGroup addPreEventHook:self.
    super postOpenWith:aBuilder.

    "Modified (format): / 12-01-2012 / 01:40:44 / cg"
!

release
    self stopSearchTask.
    contentsInfoCache := nil.
    super release
! !

!FindFileApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

