"
 COPYRIGHT (c) 1990 by Claus Gittinger
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

StandardSystemView subclass:#ChangesBrowser
	instanceVariableNames:'changesReader changeInfoList changeListView codeView diffView
		changeFileName anyChanges changeNrShown changeNrProcessed
		multipleApply autoCompare changeFileSize changeFileTimestamp
		checkBlock tabSpec autoUpdate editingClassSource lastSearchType
		lastSearchString applyInOriginalNameSpace lastSaveFileName
		readOnly enforcedPackage enforcedNameSpace updateChangeSet
		showingDiffs diffViewBox autoloadAsRequired
		classesNotToBeAutoloaded encodingIfKnown
		ignorePublicPrivateCategories changeListSelectionHolder
		defaultApplicationForVAGEClasses infoHolder'
	classVariableNames:'CompressSnapshotInfo NoColoring ShowWarningDialogs
		DefaultAutoCompare DefaultShowingDiffs LastEnforcedNameSpace
		KeepEnforcedNameSpace'
	poolDictionaries:''
	category:'Interface-Browsers'
!

Object subclass:#ChangeFileReader
	instanceVariableNames:'browser enforcedNameSpace changeFileName changeFileSize
		changeFileTimestamp changeInfo changeChunks changeClassNames
		changeHeaderLines changePositions changeTimeStamps
		changeIsFollowupMethodChange autoCompare autoloadAsRequired
		tabSpec anyChanges inStream thisIsAClassSource chunkText
		chunkPosition sawExcla fullChunkText noColoring timeStampInfo
		changeString changeType changeDelta headerLine maxLen'
	classVariableNames:'NoColoring'
	poolDictionaries:''
	privateIn:ChangesBrowser
!

Object subclass:#ChangeInfo
	instanceVariableNames:'position chunk className selector headerLine timestamp
		isFollowupChange'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangesBrowser
!

!ChangesBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    this implements a browser for the changes-file 
    (actually, it can display any sourceFile's contents).
    See the extra document 'doc/misc/cbrowser.doc' for how to use this browser.

    written jan 90 by claus

    This is a very old leftover class (it was one of the very first apps in ST/X
    and the Merovingian has not yet detected this one ;-)
    It will be completely replaced by the ChangeSetBrowser class in the near future.


    [Class variables:]
        CompressSnapshotInfo            if true (the default), snapshot entries
                                        are also compressed in the compress function.
                                        Some users prefer them to be not compressed.
                                        Set it to false for this.

    Notice:
        this needs a total rewrite, to build up a changeSet from the file
        (which did not exist when the ChangesBrowser was originally written)
        and manipulate that changeSet.

        This way, we get a browser for any upcoming incore changeSets for
        free. Also, this will put the chunk analysation code into Change and
        subclasses (where it belongs) and give a better encapsulation and
        overall structure. Do not take this as an example for good style ;-)

        The Change hierarchy is currently been completed, and the changes browser
        should be adapted soon.

    [author:]
        Claus Gittinger

    [start with:]
        ChangesBrowser open

    [see also:]
        ( Using the ChangesBrowser :html: tools/cbrowser/TOP.html )

"
! !

!ChangesBrowser class methodsFor:'instance creation'!

openOn:aFilename
    "create & open a changes browser on a change file"

    |fileName browser|

    fileName := aFilename asFilename pathName.

    (self isXMLFile:fileName) ifTrue:[
        browser := ChangeSetBrowser new
    ] ifFalse:[
        browser := self new
    ].

    browser label:(self defaultLabel , ': ', fileName).
    browser changeFileName:fileName.
    browser open.
    ^ browser

    "Modified: / 18-07-2010 / 10:32:18 / cg"
! !

!ChangesBrowser class methodsFor:'behavior'!

autoSelectNext
    "returning true here, makes a Delete operation automatically
     select the next change"

    ^ true
! !

!ChangesBrowser class methodsFor:'defaults'!

defaultIcon
    "return the browsers default window icon"

    <resource: #programImage>

    ^ ToolbarIconLibrary startChangesBrowserIcon    
!

defaultLabel
    ^ self classResources string:'Changes Browser'
!

isVisualStartable
    "return true, if this application can be started via #open.
     (to allow start of a change browser via double-click in the browser)"

    ^ true

    "Created: / 27.9.1999 / 12:28:27 / cg"
! !

!ChangesBrowser class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ Dictionary new 
        addPairsFrom:#(

#applyChange
'Apply (install) the selected change'

deleteAllForClass
'Delete all changes for the selected change''s class'

deleteForClassFromBegin
'Delete all previous changes for the selected change''s class'

deleteForClassToEnd
'Delete this and all following changes for the selected change''s class'
)
! !

!ChangesBrowser class methodsFor:'menu specs'!

menuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenuChannel: menuSpecFile
          )
         (MenuItem
            label: 'CHANGE'
            submenuChannel: menuSpecChange
          )
         (MenuItem
            label: 'Search'
            submenuChannel: menuSpecSearch
          )
         (MenuItem
            label: 'Browse'
            submenuChannel: menuSpecBrowse
          )
         (MenuItem
            label: 'Settings'
            submenuChannel: menuSpecSettings
          )
         (MenuItem
            label: 'MENU_Help'
            submenuChannel: menuSpecHelp
          )
         )
        nil
        nil
      )

    "Modified: / 21-11-2016 / 23:46:22 / cg"
!

menuSpecBrowse
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#menuSpecBrowse
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser menuSpecBrowse)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasSingleSelection
            label: 'Class'
            itemValue: doBrowse
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Senders...'
            itemValue: doBrowseSenders
          )
         (MenuItem
            label: 'Implementors...'
            itemValue: doBrowseImplementors
          )
         )
        nil
        nil
      )
!

menuSpecChange
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#menuSpecChange
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser menuSpecChange)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasSelection
            label: 'Apply'
            itemValue: doApply
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Apply to End'
            itemValue: doApplyRest
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Apply from Begin'
            itemValue: doApplyFromBeginning
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Apply for Class to End'
            itemValue: doApplyClassRest
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Apply for Class from Begin'
            itemValue: doApplyClassFromBeginning
          )
         (MenuItem
            enabled: hasNoSelection
            label: 'Apply All'
            itemValue: doApplyAll
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Apply to Conflict or End'
            itemValue: doApplyToConflictOrEnd
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete'
            itemValue: doDelete
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Delete to End'
            itemValue: doDeleteRest
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Delete from Begin'
            itemValue: doDeleteFromBeginning
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Delete for Class to End'
            itemValue: doDeleteClassRest
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Delete for Class from Begin'
            itemValue: doDeleteClassFromBeginning
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete all for Class'
            itemValue: doDeleteClassAll
            isVisible: hasNoMultiSelection
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete all for Class && its Private Classes'
            itemValue: doDeleteClassAndPrivateClassesAll
            isVisible: hasNoMultiSelection
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete all for Namespace'
            itemValue: doDeleteAllForNamespace
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete all for Classes'
            itemValue: doDeleteClassAll
            isVisible: hasMultiSelection
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete all for Classes && their Private Classes'
            itemValue: doDeleteClassAndPrivateClassesAll
            isVisible: hasMultiSelection
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete older Versions of Selected Method'
            itemValue: doDeleteClassSelectorOlder
            isVisible: hasNoMultiSelectionHolder
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete older Versions of all Selected Methods'
            itemValue: doDeleteClassSelectorOlder
            isVisible: hasMultiSelectionHolder
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete all Versions of Selected Method'
            itemValue: doDeleteClassSelectorAll
            isVisible: hasNoMultiSelectionHolder
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete all Versions of all Selected Methods'
            itemValue: doDeleteClassSelectorAll
            isVisible: hasMultiSelectionHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Compare with Current'
            itemValue: doCompare
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Copy to Clipboard'
            itemValue: doCopyToClipboard
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Make Change a Patch'
            itemValue: doMakePatch
          )
         )
        nil
        nil
      )

    "Modified: / 21-11-2016 / 23:46:42 / cg"
!

menuSpecFile
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#menuSpecFile
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser menuSpecFile)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Compress'
            itemValue: doCompress
            isVisible: notEditingClassSource
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Compress for Class'
            itemValue: doCompressClass
            isVisible: notEditingClassSource
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Compress for Class && Selector'
            itemValue: doCompressSelector
            isVisible: notEditingClassSource
          )
         (MenuItem
            label: 'Compare and Compress'
            itemValue: doCompareAndCompress
            isVisible: notEditingClassSource
          )
         (MenuItem
            label: '-'
            isVisible: notEditingClassSource
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Fileout && Delete all Changes for Class'
            itemValue: doFileoutAndDeleteClassAll
            isVisible: notEditingClassSource
          )
         (MenuItem
            enabled: hasSelection
            label: 'CheckIn && Delete all Changes for Class'
            itemValue: doCheckinAndDeleteClassAll
            isVisible: notEditingClassSource
          )
         (MenuItem
            label: '-'
            isVisible: notEditingClassSource
          )
         (MenuItem
            enabled: hasSelection
            label: 'Save In...'
            itemValue: doSave
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Save to End In...'
            itemValue: doSaveRest
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Save for Class to End In...'
            itemValue: doSaveClassRest
          )
         (MenuItem
            enabled: hasSingleSelection
            label: 'Save all for Class In...'
            itemValue: doSaveClassAll
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Writeback ClassFile'
            itemValue: doWriteBack
            isVisible: editingClassSource
          )
         (MenuItem
            label: 'Writeback ChangeFile'
            itemValue: doWriteBack
            isVisible: notEditingClassSource
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update'
            itemValue: doUpdate
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

menuSpecHelp
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#menuSpecHelp
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser menuSpecHelp)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'ChangesBrowser Documentation'
            itemValue: openHTMLDocument:
            argument: 'tools/cbrowser/TOP.html'
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'About ChangesBrowser...'
            itemValue: openAboutThisApplication
          )
         )
        nil
        nil
      )
!

menuSpecSearch
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#menuSpecSearch
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser menuSpecSearch)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Class...'
            itemValue: findClass
          )
         (MenuItem
            enabled: hasSelection
            label: 'First for Class'
            itemValue: findFirstForClass
          )
         (MenuItem
            enabled: hasSelection
            label: 'Previous for Class'
            itemValue: findPreviousForClass
          )
         (MenuItem
            enabled: hasSelection
            label: 'Next for Class'
            itemValue: findNextForClass
          )
         (MenuItem
            enabled: hasSelection
            label: 'Last for Class'
            itemValue: findLastForClass
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Selector...'
            itemValue: findSelector
          )
         (MenuItem
            enabled: hasSelection
            label: 'Previous for Selector'
            itemValue: findPreviousForSelector
          )
         (MenuItem
            enabled: hasSelection
            label: 'Next for Selector'
            itemValue: findNextForSelector
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'String...'
            itemValue: findString
          )
         (MenuItem
            enabled: hasSelection
            label: 'Previous with String'
            itemValue: findPreviousForString
          )
         (MenuItem
            enabled: hasSelection
            label: 'Next with String'
            itemValue: findNextForString
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Previous Difference'
            itemValue: findPreviousDifference
          )
         (MenuItem
            enabled: hasSelection
            label: 'Next Difference'
            itemValue: findNextDifference
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Previous Snapshot'
            itemValue: findPreviousSnapshot
          )
         (MenuItem
            enabled: hasSelection
            label: 'Next Snapshot'
            itemValue: findNextSnapshot
          )
         (MenuItem
            label: 'Last Snapshot'
            itemValue: findLastSnapshot
          )
         )
        nil
        nil
      )
!

menuSpecSettings
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#menuSpecSettings
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser menuSpecSettings)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Auto Compare'
            indication: autoCompare
          )
         (MenuItem
            label: 'Autoload As Required'
            indication: autoloadAsRequired
          )
         (MenuItem
            label: 'Show Diffs'
            indication: showingDiffs
          )
         (MenuItem
            label: 'Auto Update'
            indication: autoUpdate
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Add to ChangeSet when Applying'
            indication: updateChangeSet
          )
         (MenuItem
            label: 'Ignore Public/Private in Categories (Dolphin code)'
            itemValue: ignorePublicPrivateCategories:
            isVisible: false
            indication: ignorePublicPrivateCategories
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Apply into Package...'
            itemValue: setEnforcedPackage
          )
         (MenuItem
            label: 'Apply into NameSpace...'
            itemValue: setEnforcedNameSpace
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Settings...'
            itemValue: openSettingsDialog
          )
         )
        nil
        nil
      )
!

toolbarMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ChangesBrowser andSelector:#toolbarMenuSpec
     (Menu new fromLiteralArrayEncoding:(ChangesBrowser toolbarMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: applyChange
            enabled: hasSelectionHolder
            label: 'Apply'
            itemValue: doApply
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary executeMethod20x20Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: deleteAllForClass
            enabled: hasSelectionHolder
            isVisible: canDeleteChanges
            label: 'Delete all for Class'
            itemValue: doDeleteClassAll
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteClass24x24Icon)
          )
         (MenuItem
            activeHelpKey: deleteForClassFromBegin
            enabled: hasSelectionHolder
            isVisible: canDeleteChanges
            label: 'Delete for Class from Beginning'
            itemValue: doDeleteClassFromBeginning
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteClassFromStart24x24Icon)
          )
         (MenuItem
            activeHelpKey: deleteForClassToEnd
            enabled: hasSelectionHolder
            isVisible: canDeleteChanges
            label: 'Delete for Class to End'
            itemValue: doDeleteClassRest
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary deleteClassToEnd24x24Icon)
          )
         )
        nil
        nil
      )
! !

!ChangesBrowser class methodsFor:'private-changeFile access'!

readXMLChangesFrom:aStream inBackground:inBackground
    "read an XML source file (format as in campSmalltalk DTD)"

    |changeSet|

    (XML isNil or:[XML::SourceNodeBuilder isNil or:[XML::XMLParser isNil]]) ifTrue:[
	Smalltalk loadPackage:'stx:goodies/xml/vw'.
	(XML isNil or:[XML::SourceNodeBuilder isNil or:[XML::XMLParser isNil]]) ifTrue:[
	    self error:'Could not load XML package(s) from ''stx:goodies/xml/vw'''.
	]
    ].

    changeSet := ChangeSet new.
    XML::SourceScannerNodeBuilder new
	scanFile:aStream
	do:[:eachChange |
		changeSet addChange:eachChange.
	].
    ^ changeSet

"/    builder := XML::SourceScannerNodeBuilder new.
"/    parser := XML::XMLParser on:aStream.
"/    parser builder:builder.
"/    parser validate:false.
"/    parser scanDocument.
!

readXMLChangesFromFile:changeFileName inBackground:inBackground
    |set|

    changeFileName asFilename readingFileDo:[:s|
        set := self readXMLChangesFrom:s inBackground:false.
    ].
    ^ set.
! !

!ChangesBrowser class methodsFor:'utilities'!

isXMLFile:aFilename
    |stream first|

    stream := aFilename asFilename readStreamOrNil.
    stream isNil ifTrue:[^ false].

    stream skipSeparators.
    first := stream peek.
    stream close.
    ^ first == $<
!

methodDefinitionSelectors
     ^ #(
           #'methodsFor:'
           #'privateMethodsFor:'
           #'publicMethodsFor:'
           #'ignoredMethodsFor:'
           #'protectedMethodsFor:'
           #'methodsFor:stamp:'           "/ Squeak support
           #'commentStamp:prior:'         "/ Squeak support
           #methodsFor                    "/ Dolphin support
           #categoriesForClass            "/ Dolphin support
           #'categoriesFor:'              "/ Dolphin support
           #methods                       "/ STV support
           #publicMethods                 "/ STV / V'Age support
           #privateMethods                "/ STV / V'Age support
           #'methodsForUndefined:'
        )
! !

!ChangesBrowser methodsFor:'aspects'!

applyInOriginalNameSpace
    ^ applyInOriginalNameSpace
!

applyNotInOriginalNameSpace
    ^ BlockValue forLogicalNot:self applyInOriginalNameSpace
!

autoCompare
    ^ autoCompare
!

autoUpdate
    "enabled/disable automatic update from the change-file (for monitoring)"

    ^ autoUpdate

    "Created: 3.12.1995 / 14:14:24 / cg"
    "Modified: 3.12.1995 / 14:20:45 / cg"
!

autoloadAsRequired
    ^ autoloadAsRequired
!

canDeleteChanges
    "makes the delete buttons in the toolbar visible"

    ^ true.
!

changeListSelectionHolder
    changeListSelectionHolder isNil ifTrue:[
        changeListSelectionHolder := nil asValue.
    ].
    ^ changeListSelectionHolder

    "Created: / 03-01-2012 / 15:19:25 / cg"
!

editingClassSource
    ^ editingClassSource ? false
!

hasMultiSelection
    ^ self hasSelection and:[self hasSingleSelection not]
!

hasMultiSelectionHolder
    ^ [ self hasMultiSelection ]

    "Created: / 25-12-2011 / 11:21:52 / cg"
!

hasNoMultiSelection
    ^ self hasMultiSelection not
!

hasNoMultiSelectionHolder
    ^ [ self hasNoMultiSelection ]

    "Created: / 25-12-2011 / 11:21:20 / cg"
!

hasNoSelection
    ^ self hasSelection not
!

hasSelection
    ^ changeListView hasSelection
!

hasSelectionHolder
    ^ BlockValue
        with:[:v | v notEmptyOrNil ]
        argument:(self changeListSelectionHolder)

    "Created: / 03-01-2012 / 15:15:47 / cg"
!

hasSingleSelection
    changeListView multipleSelectOk ifTrue:[
	^ changeListView selection size == 1
    ].
    ^ changeListView hasSelection
!

ignorePublicPrivateCategories
    ^ ignorePublicPrivateCategories

    "Created: / 23-09-2011 / 19:42:46 / cg"
!

notEditingClassSource
    ^ self editingClassSource not
!

notEditingClassSourceAndNotReadOnly
    ^ (self editingClassSource or:[readOnly == true]) not
!

notReadOnly
    ^ (readOnly ~~ true)
!

readOnly:aBoolean
    readOnly := aBoolean
!

showingDiffs
    showingDiffs isNil ifTrue:[
	showingDiffs := self showingDiffsDefault asValue.
	showingDiffs
	    onChangeEvaluate:[
		showingDiffs value ifTrue:[
		    self updateDiffView.
		    self makeDiffViewVisible
		] ifFalse:[
		    self makeDiffViewInvisible
		].
		DefaultShowingDiffs := showingDiffs value.
	    ]
    ].
    ^ showingDiffs
!

showingDiffsDefault
    ^ (DefaultShowingDiffs ? true)
!

theSingleSelection
    |sel|

    sel := changeListView selection.
    changeListView multipleSelectOk ifTrue:[
	sel size == 1 ifTrue:[
	    ^ sel first
	].
	^ nil
    ].
    ^ sel.
!

updateChangeSet
    ^ updateChangeSet
! !

!ChangesBrowser methodsFor:'compiler interface'!

wantChangeLog
    "sent by the compiler to ask if a changeLog entry should
     be written when compiling. Return false here."

    ^ false
! !

!ChangesBrowser methodsFor:'compiler interface-error handling'!

correctableError:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of an error - this should really not happen since
     changes ought to be correct (did someone edit the changes file ??).
     Show the bad change in the codeView and let codeView hilight the error;
     no corrections allowed here therefore return false"

    ShowWarningDialogs == true ifTrue:[
        self error:aString position:relPos to:relEndPos from:aCompiler.
    ] ifFalse:[
        Transcript showCR:aString.
    ].
    ^ false
!

correctableSelectorWarning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a warning"

    ^ false

    "Modified: / 19.1.2000 / 16:25:31 / cg"
    "Created: / 19.1.2000 / 16:27:23 / cg"
!

correctableWarning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of an error - this should really not happen since
     changes ought to be correct (did someone edit the changes file ??).
     Show the bad change in the codeView and let codeView hilight the error;
     no corrections allowed here therefore return false"

    ^ self correctableError:aString position:relPos to:relEndPos from:aCompiler

    "Created: / 02-11-2010 / 13:29:52 / cg"
!

error:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of an error - this should really not happen since
     changes ought to be correct (did someone edit the changes file ??).
     Show the bad change in the codeView and let codeView hilight the error"

    |action|

    (changeNrProcessed ~~ changeNrShown) ifTrue:[
        self changeSelection:changeNrProcessed
    ].

    "if more than a single change is applied,
     ask the user if he wants to abort the whole sequence of operations..."
    multipleApply == true ifTrue:[
        codeView highlightingErrorPosition:relPos to:relEndPos do:[
            |box|

            "
             start dialog - make certain cleanup is done
            "
            action := OptionBox
                          request:aString
                          label:'Error'
                          image:(WarningBox iconBitmap)
                          buttonLabels:#('Cancel All' 'Skip this Change' " 'Shut up' " 'Continue')
                          values:#(abortAll skip "shutUp" continue)
                          default:#continue
                          onCancel:#abort.
        ].

"/        action == #shutUp ifTrue:[
"/            aCompiler ignoreWarnings.
"/            ^  false
"/        ].

        action == #abortAll ifTrue:[
            AbortAllOperationRequest raise.
            ^ false
        ].
        action == #skip ifTrue:[
            AbortOperationRequest raise.
            ^ false
        ].
        ^  false
    ].
    ^ codeView error:aString position:relPos to:relEndPos from:aCompiler

    "Modified: / 16.11.2001 / 17:38:10 / cg"
!

unusedVariableWarning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a (or some) unused variables;
     hilight the error (relPos to relEndPos) and show a Box asking for continue/correct/abort;
     this method should return true to the compiler if user wants the error
     to be corrected; false otherwise"

    ^ false
!

warning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a warning - ignore it"

    ^ self
! !

!ChangesBrowser methodsFor:'event handling'!

handlesKeyPress:key inView:view
    "this method is reached via delegation: are we prepared to handle
     a keyPress in some other view ?"

    <resource: #keyboard (#Delete #BackSpace #Accept #Find #FindPrev #FindNext)>

    view == changeListView ifTrue:[
	(key == #Delete
	or:[key == #BackSpace
	or:[key == #Accept
	or:[key == #Find
	or:[key == #FindPrev
	or:[key == #FindNext]]]]]) ifTrue:[^ true].
    ].
    ^ false

    "Modified: 8.4.1997 / 11:01:42 / cg"
!

keyPress:key x:x y:y view:view
    "this method is reached via delegation from the changeListView"

    <resource: #keyboard (#Delete #BackSpace #Accept #Find #FindPrev #FindNext)>

    (key == #Delete) ifTrue:[
        self sensor shiftDown ifTrue:[
            self doDeleteAndSelectPrevious.
        ] ifFalse:[
            self doDelete.
        ].
        ^ self
    ].
    (key == #BackSpace) ifTrue:[
        self doDelete. "/ doDeleteAndSelectPrevious.
        ^ self
    ].
    (key == #Accept) ifTrue:[
        self doApply.
        ^ self
    ].
    (key == #Find) ifTrue:[
        self findClass.
        ^ self
    ].
    (key == #FindPrev) ifTrue:[
        self findPrevious.
        ^ self
    ].
    (key == #FindNext) ifTrue:[
        self findNext.
        ^ self
    ].
    changeListView keyPress:key x:x y:y

    "Modified: / 18.6.1998 / 22:15:36 / cg"
! !

!ChangesBrowser methodsFor:'help'!

flyByHelpSpec
    ^ self class flyByHelpSpec
!

showActivity:someMessage
    "some activityNotification to be forwarded to the user;
     show it in the windows title area here."

    someMessage isNil ifTrue:[
        self newLabel:''
    ] ifFalse:[
        self label:someMessage
    ].

    "Created: 24.2.1996 / 19:35:42 / cg"
    "Modified: 23.4.1996 / 21:39:36 / cg"
! !

!ChangesBrowser methodsFor:'initialization & release'!

autoCompareChanged
    "sent from the compare-toggle"

    |doCompare|

    self askIfChangesAreToBeWrittenBack.

    doCompare := autoCompare value.
    DefaultAutoCompare := doCompare.
    self setupTabSpec.
    doCompare ifTrue:[
        self doUpdate
    ] ifFalse:[
        changeListView invalidate. "/ clear; redraw.
    ]
!

changeListMenu
    "return the menu for the change (upper) list"

    <resource: #keyboard ( #Accept #Delete ) >
    <resource: #programMenu >

    |items m replNext replPrev sel|

    self sensor ctrlDown ifTrue:[
        "/ notice - findNext/prev shortKeys will search for the same thing again.
        items := #(
                          ('Search Class...'              findClass               #Find       )
                          ('Previous for this Class'      findPreviousForClass    #FindPrevClass      )
                          ('Next for this Class'          findNextForClass        #FindNextClass      )
                          ('-'                                                                )
                          ('Search Selector...'           findSelector                        )
                          ('Previous with this Selector'  findPreviousForSelector #FindPrevSelector   )
                          ('Next with this Selector'      findNextForSelector     #FindNextSelector   )
                          ('-'                                                                )
                          ('Search String...'             findString                        )
                          ('Previous with this String'    findPreviousForString   #FindPrevString   )
                          ('Next with this String'        findNextForString       #FindNextString   )
                          ('-'                                                                )
                          ('Previous Snapshot'            findPreviousSnapshot    #FindPrevSnapshot   )
                          ('Next Snapshot'                findNextSnapshot        #FindNextSnapshot   )
                 ).

        lastSearchType == #selector ifTrue:[
            replNext := #FindNextSelector.
            replPrev := #FindPrevSelector.
        ] ifFalse:[
            lastSearchType == #snapshot ifTrue:[
                replNext := #FindNextSnapshot.
                replPrev := #FindPrevSnapshot.
            ] ifFalse:[
                lastSearchType == #string ifTrue:[
                    replNext := #FindNextString.
                    replPrev := #FindPrevString.
                ] ifFalse:[
                    replNext := #FindNextClass.
                    replPrev := #FindPrevClass.
                ]
            ]
        ].
        items := items deepCopy.
        items do:[:each |
                        each replaceAll:replNext with:#FindNext.
                        each replaceAll:replPrev with:#FindPrev.
                        each replaceAny:#(FindNextClass FindPrevClass
                                          FindNextSelector FindPrevSelector
                                          FindNextSnapshot FindPrevSnapshot
                                          FindNextString FindPrevString)
                             with:nil.
                 ].

        ^ PopUpMenu itemList:items resources:resources.
    ].

    items := #(
                      ('Apply'                        doApply                    Accept)
                      ('Apply to End'                 doApplyRest                      )
                      ('Apply from Begin'             doApplyFromBeginning             )
                      ('Apply for Class to End'       doApplyClassRest                 )
                      ('Apply for Class from Begin'   doApplyClassFromBeginning        )
                      ('Apply All'                    doApplyAll                       )
                      ('-'                                                             )
                      ('Delete'                       doDelete                   Delete)
                      ('Delete to End'                doDeleteRest                     )
                      ('Delete for Class to End'      doDeleteClassRest                )
                      ('Delete for Class from Begin'  doDeleteClassFromBeginning       )
             ).

    (self hasSelection and:[self hasSingleSelection not]) ifTrue:[
        items := items ,
                 #(
                          ('Delete all for Classes'         doDeleteClassAll                 )
                          ('Delete all for Classes & their Private Classes' doDeleteClassAndPrivateClassesAll )
                 ).
    ] ifFalse:[
        items := items ,
                 #(
                          ('Delete all for Class'         doDeleteClassAll                 )
                          ('Delete all for Class & its Private Classes' doDeleteClassAndPrivateClassesAll )
                 ).
    ].

    items := items ,
             #(
                      ('-'                                                             )
                      ('Compress'                     doCompress                       )
                      ('Compress for Class'           doCompressClass                  )
                      ('Compare and Compress'         doCompareAndCompress             )
                      ('-'                                                             )
                      ('Compare with current Version' doCompare                        )
                      ('Browse Class'                 doBrowse                         )
                      ('-'                                                             )
                      ('Make Change a Patch'          doMakePatch                      )
             ).

    editingClassSource ifFalse:[
        items := items , #(
                      ('Fileout & Delete all for Class' doFileoutAndDeleteClassAll     )
                      ('CheckIn & Delete all for Class' doCheckinAndDeleteClassAll     )
                          )
    ].

    items := items , #(
                      ('-'                                            )
                      ('Save in...'                  doSave           )
                      ('Save to End In...'           doSaveRest       )
                      ('Save for Class to End In...' doSaveClassRest  )
                      ('Save all for Class In...'    doSaveClassAll   )
                      ('-'                                            )
                     ).

    editingClassSource ifTrue:[
        items := items , #(
                      ('Writeback ClassFile'  doWriteBack )
                     )
    ] ifFalse:[
        items := items , #(
                      ('Writeback ChangeFile' doWriteBack )
                     )
    ].

    items := items , #(
                  ('-'                                                             )
                  ('Update'                       doUpdate                         )
                 ).

    m := PopUpMenu itemList:items resources:resources.

    "/
    "/ disable those that require a selected entry
    "/
    self hasSelection ifFalse:[
        m disableAll:#(doApply doApplyClassRest doApplyRest doDelete doDeleteRest doDeleteClassRest
                       doDeleteClassFromBeginning doDeleteClassAll doDeleteClassAndPrivateClassesAll
                       doCompare doCompressClass doMakePatch doSaveChangeInFile doMakePermanent
                       doSave doSaveRest doSaveClassAll doSaveClassRest doBrowse
                       doFileoutAndDeleteClassAll doCheckinAndDeleteClassAll)
    ] ifTrue:[
        sel := self theSingleSelection.
        sel isNil ifTrue:[
            "/ multiple selections
            m disableAll:#(doApplyClassRest doApplyRest doDeleteClassRest doDeleteRest
                           doDeleteClassFromBeginning
                           doCompressClass doCompare
                           doSaveClassAll doSaveClassRest doSaveRest doBrowse
                           doFileoutAndDeleteClassAll)
        ] ifFalse:[
            (self classNameOfChange:sel) isNil ifTrue:[
                m disableAll:#(doApplyClassRest doDeleteClassRest
                               doDeleteClassFromBeginning doDeleteClassAll doDeleteClassAndPrivateClassesAll
                               doCompressClass doCompare doMakePatch
                               doSaveClassAll doSaveClassRest doBrowse
                               doFileoutAndDeleteClassAll doCheckinAndDeleteClassAll)
            ]
        ]
    ].

    "/
    "/ disable those that do not make sense with autoUpdate
    "/ ('cause this would be overwritten by next update operation)
    "/
    autoUpdate value ifTrue:[
        m disableAll:#(doDelete doDeleteRest doDeleteClassRest doDeleteClassAll
                       doDeleteClassAndPrivateClassesAll doCompress
                       doFileoutAndDeleteClassAll doCheckinAndDeleteClassAll
                       doWriteBack)
    ].
    readOnly == true ifTrue:[
        m disableAll:#(doDelete doDeleteRest doDeleteClassRest doDeleteClassAll
                       doDeleteClassAndPrivateClassesAll doCompress
                       doFileoutAndDeleteClassAll doCheckinAndDeleteClassAll
                       doWriteBack doSaveBack doUpdate
                       doApplyAll doApplyRest)
    ].

    self hasSelection ifTrue:[
        m disable:#doApplyAll
    ].

    ^ m

    "Modified: / 06-09-1995 / 17:14:22 / claus"
    "Modified: / 06-10-2006 / 11:17:06 / cg"
!

destroy
    "destroy the receiver; make certain, that boxes are destroyed too"

    Processor removeTimedBlock:checkBlock.
    ObjectMemory removeDependent:self.
    super destroy
!

initialize
    |panel infoLabel v upperFrame buttonPanel menuPanel mH toolbarMenu tmH
     checkBox oldStyle codeViewBox lbl applyInOriginal|

    "/ oldStyle := true.
    oldStyle := false.

    super initialize.

    changeFileName := ObjectMemory nameForChanges.
    encodingIfKnown := nil.
    autoCompare := (DefaultAutoCompare ? false) asValue.
    autoCompare onChangeSend:#autoCompareChanged to:self.
    autoUpdate := false asValue.
    autoloadAsRequired := false asValue.
    ignorePublicPrivateCategories := false asValue.

    applyInOriginal := true.
    KeepEnforcedNameSpace == true ifTrue:[
        enforcedNameSpace := LastEnforcedNameSpace.
        applyInOriginal := false.
    ].

    applyInOriginalNameSpace := applyInOriginal asValue.
    applyInOriginalNameSpace
        onChangeEvaluate:[
            autoCompare value ifTrue:[
                self doUpdate
            ].
        ].

    updateChangeSet := true "false" asValue.
    classesNotToBeAutoloaded := Set new.

    "
      checkBlock is executed by the Processor.
      We use #pushEvent: to perform the update
      in our windowgroups process.
    "
    checkBlock := [self pushEvent:#checkIfFileHasChanged].

    oldStyle ifFalse:[
        menuPanel := MenuPanel in:self.
        "/ menuPanel level:1.
        menuPanel verticalLayout:false.
        menuPanel receiver:self.
        menuPanel menu:(self pullDownMenu).

        mH := menuPanel preferredHeight.
        menuPanel origin:(0.0 @ 0.0) corner:(1.0 @ (mH)).
        mH := mH + 1.

        toolbarMenu := MenuPanel in:self.
        toolbarMenu verticalLayout:false.
        toolbarMenu receiver:self.
        toolbarMenu menu:(self toolbarMenu).
        toolbarMenu flyByHelpSpecProvider:self. "/ for helpTexts

        tmH := toolbarMenu preferredHeight.
        toolbarMenu origin:(0.0 @ mH) corner:(1.0 @ (mH+tmH)).
        mH := mH + tmH + 1.
    ] ifTrue:[
        mH := 0.0
    ].

    panel := VariableVerticalPanel in:self. 
    "/ panel origin:(0.0 @ mH) corner:(1.0 @ 1.0)
    panel layout:(LayoutFrame
                    leftFraction:0.0 offset:0
                    rightFraction:1.0 offset:0
                    topFraction:0.0 offset:mH
                    bottomFraction:1.0 offset:-30).
    panel borderWidth:0.
    
    infoLabel := Label in:self.
    infoLabel layout:(LayoutFrame
                    leftFraction:0.0 offset:0
                    rightFraction:1.0 offset:0
                    topFraction:1.0 offset:-28
                    bottomFraction:1.0 offset:-2).
    infoLabel borderWidth:0.
    infoLabel sizeFixed:true.
    infoLabel level:-1.
    infoLabel adjust:#left.
    infoLabel labelChannel:(infoHolder := '' asValue).
    
    upperFrame := panel.
    oldStyle ifTrue:[
        upperFrame := VariableHorizontalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 0.3) in:panel.
    ].

    v := HVScrollableView for:SelectionInListView miniScrollerH:true in:upperFrame.
    oldStyle ifTrue:[
        v origin:(0.0 @ 0.0) corner:(0.75 @ 1.0).
    ] ifFalse:[
        v origin:(0.0 @ 0.0) corner:(1.0 @ 0.3).
    ].

    changeListView := v scrolledView.
    changeListView delegate:self.
    changeListView menuHolder:self; menuPerformer:self; menuMessage:#changeListMenu.
    changeListView doubleClickAction:[:line | self doubleClickOnChange:line].
    oldStyle ifFalse:[
        changeListView multipleSelectOk:true.
    ].

    oldStyle ifTrue:[
        buttonPanel := VerticalPanelView in:upperFrame.
        buttonPanel origin:(0.75 @ 0.0) corner:(1.0 @ 1.0).
        buttonPanel verticalLayout:#topSpace; horizontalLayout:#leftSpace.

        checkBox := CheckBox new model:autoCompare.
        checkBox label:(resources string:'Auto Compare').
        checkBox action:[:val | autoCompare value:val].
        buttonPanel addSubView:checkBox.

        checkBox := CheckBox new model:autoUpdate.
        checkBox label:(resources string:'Auto Update').
        checkBox action:[:val | autoUpdate value:val].
        buttonPanel addSubView:checkBox.

        checkBox := CheckBox new.
        checkBox label:(resources stringWithCRs:'Apply in original NameSpace').
        checkBox model:applyInOriginalNameSpace.
        buttonPanel addSubView:checkBox.
    ].

"/    protectExistingMethods := CheckBox new.
"/    protectExistingMethods label:(resources string:'Protect existing code' withCRs).
"/    protectExistingMethods model:protectExistingMethods.
"/    buttonPanel addSubView:protectExistingMethods.

    codeViewBox := View in:panel.
    codeViewBox origin:(0.0 @ 0.3) corner:(1.0 @ 1.0).

    v := HVScrollableView for:CodeView miniScrollerH:true miniScrollerV:false in:codeViewBox.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    codeView := v scrolledView.
    codeView readOnly:true.

    diffViewBox := View in:codeViewBox.
    diffViewBox origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).

    lbl := Label label:'Current' in:diffViewBox.
    lbl layout:(LayoutFrame
                        leftFraction:0.0 offset:0
                        rightFraction:0.5 offset:0
                        topFraction:0.0 offset:0
                        bottomFraction:0.0 offset:20).
    lbl := Label label:'Change' in:diffViewBox.
    lbl layout:(LayoutFrame
                        leftFraction:0.5 offset:0
                        rightFraction:1.0 offset:0
                        topFraction:0.0 offset:0
                        bottomFraction:0.0 offset:20).

"/    diffView := DiffTextView in:diffViewBox.
"/    diffView layout:(LayoutFrame
"/                        leftFraction:0.0 offset:0
"/                        rightFraction:1.0 offset:0
"/                        topFraction:0.0 offset:20
"/                        bottomFraction:1.0 offset:0).

    v := HVScrollableView for:DiffCodeView miniScrollerH:true miniScrollerV:false in:diffViewBox.
    v layout:(LayoutFrame
                        leftFraction:0.0 offset:0
                        rightFraction:1.0 offset:0
                        topFraction:0.0 offset:20
                        bottomFraction:1.0 offset:0).
    diffView := v scrolledView.

    self showingDiffs value ifFalse:[
        self makeDiffViewInvisible
    ].

    anyChanges := false.
    ObjectMemory addDependent:self.   "to get shutdown-update"

    tabSpec := TabulatorSpecification new.
    tabSpec unit:#inch.
    tabSpec positions:#(-1      0        5      8.5 ).
    "                   +/-    cls>>sel  type   info"
    tabSpec align:    #(#left  #left     #left  #left).

    "Modified: / 27-03-1997 / 11:07:07 / stefan"
    "Modified: / 03-01-2012 / 15:28:45 / cg"
!

postRealize
    self setupTabSpec.
    self readChangesFileInBackground:true.
    self setChangeList.
    changeListView action:[:lineNrOrCollection | self changeSelection:lineNrOrCollection].
    Processor addTimedBlock:checkBlock afterSeconds:5.

    "Created: 24.7.1997 / 18:06:12 / cg"
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
!

setupTabSpec
    autoCompare value ifTrue:[
        tabSpec positions:#(0  0.15  7   9.5 ).
    ] ifFalse:[
        "/
        "/ set tabs to hide compare-column
        "/
        tabSpec positions:#(-1  0    7   9.5 ).
    ]

    "Modified: / 10-07-2010 / 10:59:49 / cg"
!

toolbarMenu
    "return the top (pullDown) menu"

    <resource: #programMenu>

    ^ self menuFromSpec:self class toolbarMenuSpec.

    "Created: / 07-09-2011 / 16:03:41 / cg"
!

update:what with:aParameter from:changedObject
    |box|

    (what == #aboutToQuit) ifTrue:[
        "
         smalltalk is about to shut down -
         - if change list was modified, ask user and save if requested.
        "
        anyChanges ifTrue:[
            self raiseDeiconified.

            box := YesNoBox new.
            box title:('The modified changelist has not been written back to the change file.\\Write change file before exiting ?') withCRs.
            box okText:(resources string:'Write') noText:(resources string:'Don''t write').
            box yesAction:[self writeBackChanges]
                 noAction:[].
            box showAtPointer.
            box destroy
        ].
        ^ self
    ].

    super update:what with:aParameter from:changedObject

    "Created: / 15-06-1996 / 15:26:30 / cg"
    "Modified: / 24-08-1999 / 09:45:06 / stefan"
    "Modified: / 03-01-2012 / 15:23:13 / cg"
! !

!ChangesBrowser methodsFor:'menu actions'!

doApply
    "user wants a change to be applied"

    self withSelectedChangesDo:[:changeNr |
        (self applyChange:changeNr) ifFalse:[
            ^ self "/ cancel
        ].
        self autoSelect:(changeNr + 1)
    ]
!

doApplyAll
    "user wants all changes to be applied"

    self withExecuteCursorDo:[
        |lastNr "{ Class: SmallInteger }" |

        self clearCodeView.
        lastNr := self numberOfChanges.

        "if we apply multiple changes, and an error occurs,
         ask the user if all operations should be aborted..."
        multipleApply := lastNr > 1.

        1 to:lastNr do:[:changeNr |
            changeListView setSelection:changeNr.
            self applyChange:changeNr
        ].
        self autoSelectLast
    ]

    "Modified: 21.1.1997 / 22:26:30 / cg"
!

doApplyClassFromBeginning
    "user wants all changes for this class from 1 to changeNr to be applied"

    self withSingleSelectedChangeDo:[:changeNr |
        |thisClassName classNameToApply lastChange
         lastNr "{ Class: SmallInteger }" |

        classNameToApply := self classNameOfChange:changeNr.
        classNameToApply notNil ifTrue:[
            self clearCodeView.

            "if we apply multiple changes, and an error occurs,
             ask the user if all operations should be aborted..."
            multipleApply := changeNr ~= 1.

            1 to:changeNr do:[:changeNr |
                thisClassName := self classNameOfChange:changeNr.
                thisClassName = classNameToApply ifTrue:[
                    changeListView setSelection:changeNr.
                    self applyChange:changeNr.
                    lastChange := changeNr
                ].
            ].
            self autoSelect:changeNr+1.
        ]
    ]

    "Modified: 21.1.1997 / 22:26:04 / cg"
!

doApplyClassRest
    "user wants all changes for this class from changeNr to be applied"

    self withSingleSelectedChangeDo:[:changeNr |
        |thisClassName classNameToApply lastChange
         lastNr "{ Class: SmallInteger }" |

        classNameToApply := self classNameOfChange:changeNr.
        classNameToApply notNil ifTrue:[
            self clearCodeView.

            lastNr := self numberOfChanges.

            "if we apply multiple changes, and an error occurs,
             ask the user if all operations should be aborted..."
            multipleApply := (lastNr - changeNr) > 1.

            changeNr to:lastNr do:[:changeNr |
                thisClassName := self classNameOfChange:changeNr.
                thisClassName = classNameToApply ifTrue:[
                    changeListView setSelection:changeNr.
                    self applyChange:changeNr.
                    lastChange := changeNr
                ].
            ].
            self autoSelect:lastChange.
        ]
    ]

    "Modified: 21.1.1997 / 22:26:04 / cg"
!

doApplyFromBeginning
    "user wants all changes from 1 to changeNr to be applied"

    self withSingleSelectedChangeDo:[:changeNr |
        |lastNr "{ Class: SmallInteger }" |

        self clearCodeView.

        "if we apply multiple changes, and an error occurs,
         ask the user if all operations should be aborted..."
        multipleApply := changeNr ~= 1.

        1 to:changeNr do:[:changeNr |
            changeListView setSelection:changeNr.
            self applyChange:changeNr
        ].
        self autoSelect:changeNr+1.
    ]
!

doApplyRest
    "apply all changes from changeNr to the end"

    self withSingleSelectedChangeDo:[:changeNr |
        |lastNr "{ Class: SmallInteger }" |

        self clearCodeView.

        lastNr := self numberOfChanges.

        "if we apply multiple changes, and an error occurs,
         ask the user if all operations should be aborted..."
        multipleApply := (lastNr - changeNr) > 1.
        AbortAllOperationRequest handle:[:ex |
            ex return
        ] do:[
            changeNr to:lastNr do:[:changeNr |
                changeListView setSelection:changeNr.
                self applyChange:changeNr
            ].
            self autoSelect:self numberOfChanges.
        ]
    ]

    "Modified: 21.1.1997 / 22:25:29 / cg"
!

doApplyToConflictOrEnd
    "apply all changes from changeNr to either a conflict (i.e. method exists)
     or the end."

    self withSingleSelectedChangeDo:[:changeNr |
        |lastNr "{ Class: SmallInteger }"|

        self clearCodeView.

        lastNr := self numberOfChanges.

        "if we apply multiple changes, and an error occurs,
         ask the user if all operations should be aborted..."
        multipleApply := (lastNr - changeNr) > 1.

        changeNr to:lastNr do:[:changeNr |
            | cls sel |
            changeListView setSelection:changeNr.

            ((cls := self classOfChange:changeNr ifAbsent:[:className| nil]) notNil
            and:[(sel := self selectorOfMethodChange:changeNr) notNil])
            ifTrue:[
                (cls includesSelector:sel) ifTrue:[
                    self autoSelect:changeNr.
                    ^ self
                ].
            ].
            self applyChange:changeNr
        ].
        self autoSelect:self numberOfChanges.
    ]
!

doBrowse
    "user wants a browser on the class of a change"

    self withSingleSelectedChangeDo:[:changeNr |
	|cls|

	cls := self classOfChange:changeNr.
	cls notNil ifTrue:[
	    UserPreferences systemBrowserClass
		openInClass:cls
		selector:(self selectorOfMethodChange:changeNr)
	]
    ]
!

doBrowseImplementors
    "open an implementors-browser"

    |changeNr initial selector|

    (changeNr := self theSingleSelection) notNil ifTrue:[
	initial := self selectorOfMethodChange:changeNr.
    ].

    selector := Dialog
		    request:'Selector to browse implementors of:'
		    initialAnswer:(initial ? '').
    selector size ~~ 0 ifTrue:[
	UserPreferences systemBrowserClass
	    browseImplementorsMatching:selector.
    ]
!

doBrowseSenders
    "user wants a browser on the class of a change"

    |changeNr initial selector|

    (changeNr := self theSingleSelection) notNil ifTrue:[
	initial := self selectorOfMethodChange:changeNr.
    ].

    selector := Dialog
		    request:'Selector to browse senders of:'
		    initialAnswer:(initial ? '').
    selector size ~~ 0 ifTrue:[
	UserPreferences systemBrowserClass
	    browseAllCallsOn:selector asSymbol.
    ]
!

doCheckinAndDeleteClassAll
    "first checkin the selected changes class then delete all changes
     for it."

    |classes answer logTitle checkinInfo|

"/    self theSingleSelection isNil ifTrue:[
"/        ^ self information:'Only possible if a single change is selected.'.
"/    ].

    self withExecuteCursorDo:[
        classes := IdentitySet new.

        self withSelectedChangesDo:[:changeNr |
            | className class |

            className := self classNameOfChange:changeNr.
            className notNil ifTrue:[
                class := Smalltalk classNamed:className.
                class isNil ifTrue:[
                    self error:'oops - no class: ', className mayProceed:true.
                ].
                class notNil ifTrue:[
                    class := class theNonMetaclass.
                    (classes includes:class) ifFalse:[
                        class isPrivate ifTrue:[
                            (classes includes:class owningClass) ifFalse:[
                                answer := self confirmWithCancel:('This is a private class.\\CheckIn the owner ''%1'' and all of its private classes ?'
                                                                    bindWith:class owningClass name allBold) withCRs.
                                answer isNil ifTrue:[^ self].
                                answer ifTrue:[
                                    classes add:class owningClass
                                ]
                            ]
                        ] ifFalse:[
                            classes add:class
                        ].
                    ]
                ]
            ]
        ].

        classes size == 1 ifTrue:[
            logTitle := classes first name.
        ] ifFalse:[
            logTitle := '%1 classes' bindWith:classes size.
        ].
        checkinInfo := SourceCodeManagerUtilities default
                        getCheckinInfoFor:logTitle
                        initialAnswer:nil.
        checkinInfo isNil ifTrue:[^ self ].

        changeListView setSelection:nil.
        classes do:[:eachClass |
            (SourceCodeManagerUtilities default checkinClass:eachClass withInfo:checkinInfo)
                ifTrue:[
                    self silentDeleteChangesForClassAndPrivateClasses:eachClass name
                           from:1 to:(self numberOfChanges).
                ]
        ].
        self setChangeList.
    ]

    "Modified: / 6.9.1995 / 17:11:16 / claus"
    "Modified: / 17.11.2001 / 14:21:13 / cg"
!

doCompare
    "compare change with current system version"

    classesNotToBeAutoloaded removeAll.

    self withSingleSelectedChangeDo:[:changeNr |
        self withExecuteCursorDo:[
            self compareChange:changeNr
        ].
        self newLabel:''
    ].

    "Modified: 24.2.1996 / 19:37:19 / cg"
!

doCompareAndCompress
    "remove all changes, which are equivalent to the current image version"

    |toDelete|

    classesNotToBeAutoloaded removeAll.
    toDelete := OrderedCollection new.
    self withExecuteCursorDo:[
        1 to:self numberOfChanges do:[:changeNr |
            (self compareChange:changeNr showResult:false) == true ifTrue:[
                toDelete add:changeNr
            ]
        ].
    ].

    toDelete reverseDo:[:changeNr |
        self silentDeleteChange:changeNr.
    ].
    self setChangeList.
    "
     scroll back a bit, if we are left way behind the list
    "
    changeListView firstLineShown > self numberOfChanges ifTrue:[
        changeListView makeLineVisible:self numberOfChanges
    ].
    self clearCodeView.

    self newLabel:''.
    classesNotToBeAutoloaded removeAll.
!

doCompress
    "compress the change-set; this replaces multiple method-changes by the last
     (i.e. the most recent) change"

    self compressForClass:nil

    "Modified: / 29.10.1997 / 01:03:26 / cg"
!

doCompressClass
    "compress changes for the selected class.
     this replaces multiple method-changes by the last (i.e. the most recent) change."

    self checkSingleSelectedChange.

    self selectedClassNames do:[:classNameToCompress |
        self compressForClass:classNameToCompress.
    ]

    "Created: / 29.10.1997 / 01:05:16 / cg"
    "Modified: / 19.11.2001 / 21:55:17 / cg"
!

doCompressSelector
    "compress changes for the selected class & selector.
     this replaces multiple method-changes by the last (i.e. the most recent) change."

    |classSelectorPairs|

    self checkSingleSelectedChange.

    classSelectorPairs := Set new.
    self withSelectedChangesDo:[:changeNr |
        | classNameToCompress selector |

        classNameToCompress := self classNameOfChange:changeNr.
        classNameToCompress notNil ifTrue:[
            selector := self selectorOfMethodChange:changeNr.
            selector notNil ifTrue:[
                classSelectorPairs add:(classNameToCompress -> selector).
            ]
        ]
    ].

    classSelectorPairs do:[:pair |
        self compressForClass:pair key selector:pair value.
    ]

    "Created: / 19.11.2001 / 21:50:59 / cg"
    "Modified: / 19.11.2001 / 22:10:08 / cg"
!

doCopyToClipboard
    "user wants a change text to be copied to the clipboard"

    |text|

    self withSingleSelectedChangeDo:[:changeNr |
        text := self sourceOfMethodChange:changeNr.
    ].
    text notEmptyOrNil ifTrue:[
        self window setClipboardText:text
    ]

    "Created: / 21-11-2016 / 23:38:11 / cg"
!

doDelete
    "delete currently selected change(s)"

    |rangeEnd rangeStart firstDeleted|

    changeListView selection size <= 5 ifTrue:[
        self withSelectedChangesReverseDo:[:changeNr |
            self deleteChange:changeNr.
            self autoSelectOrEnd:changeNr
        ].
        self showNumberOfChanges.
        ^ self
    ].

    self withSelectedChangesReverseDo:[:changeNr |
        rangeEnd isNil ifTrue:[
            rangeEnd := rangeStart := changeNr
        ] ifFalse:[
            (changeNr = (rangeEnd + 1)) ifTrue:[
                rangeEnd := changeNr
            ] ifFalse:[
                (changeNr = (rangeStart - 1)) ifTrue:[
                    rangeStart := changeNr
                ] ifFalse:[
                    self deleteChangesFrom:rangeStart to:rangeEnd.
                    firstDeleted := (firstDeleted ? rangeStart) min:rangeStart.
                    rangeStart := rangeEnd := nil.
                ].
            ].
        ].
    ].
    rangeStart notNil ifTrue:[
        self deleteChangesFrom:rangeStart to:rangeEnd.
        firstDeleted := (firstDeleted ? rangeStart) min:rangeStart.
    ].
    self autoSelectOrEnd:firstDeleted.
    self showNumberOfChanges
!

doDeleteAllForNamespace
    "delete all changes for classes with same namespace as currently selected change"

    |namespacesToDelete lastChangeNr overAllNumDeletedBefore|

    lastChangeNr := -1.
    namespacesToDelete := Set new.
    self withSelectedChangesDo:[:changeNr |
        |namespaceToDelete|

        namespaceToDelete := self namespaceOfChange:changeNr.
        namespaceToDelete notNil ifTrue:[
            namespacesToDelete add:namespaceToDelete
        ].
        lastChangeNr := lastChangeNr max:changeNr.
    ].
    namespacesToDelete isEmpty ifTrue:[^ self].

    overAllNumDeletedBefore := 0.
    changeListView setSelection:nil.

    self withExecuteCursorDo:[
        namespacesToDelete do:[:namespaceToDelete |
            |numDeletedBefore|

            self 
                silentDeleteChangesForNamespace:namespaceToDelete
                from:lastChangeNr
                to:(self numberOfChanges).
            numDeletedBefore := self
                                   silentDeleteChangesForNamespace:namespaceToDelete
                                   from:1
                                   to:(lastChangeNr-1).
            lastChangeNr := lastChangeNr - numDeletedBefore.
            overAllNumDeletedBefore := overAllNumDeletedBefore + numDeletedBefore.
        ].
    ].

    self setChangeList.
    self autoSelectOrEnd:lastChangeNr.
!

doDeleteAndSelectPrevious
    "delete currently selected change(s)"

    self withSelectedChangesReverseDo:[:changeNr |
        self deleteChange:changeNr.
        self autoSelectOrEnd:changeNr-1
    ].
    
    "/mh - don't we need a 
    "/  self setChangeList
    "/ here?
    self showNumberOfChanges
!

doDeleteClassAll
    "delete all changes with same class as currently selected change"

    |classNamesToDelete lastChangeNr overAllNumDeletedBefore|

    lastChangeNr := -1.
    classNamesToDelete := Set new.
    self withSelectedChangesDo:[:changeNr |
        |classNameToDelete|

        classNameToDelete := self classNameOfChange:changeNr.
        classNameToDelete notNil ifTrue:[
            classNamesToDelete add:classNameToDelete.
        ].
        lastChangeNr := lastChangeNr max:changeNr.
    ].

    overAllNumDeletedBefore := 0.
    changeListView setSelection:nil.

    self withExecuteCursorDo:[
        classNamesToDelete do:[:classNameToDelete |
            |numDeletedBefore|

            self silentDeleteChangesFor:classNameToDelete
                                   from:lastChangeNr
                                     to:(self numberOfChanges).
            numDeletedBefore := self
                                   silentDeleteChangesFor:classNameToDelete
                                   from:1
                                   to:(lastChangeNr-1).
            lastChangeNr := lastChangeNr - numDeletedBefore.
            overAllNumDeletedBefore := overAllNumDeletedBefore + numDeletedBefore.
        ].
    ].

    self setChangeList.
    self autoSelectOrEnd:lastChangeNr.

    "Created: / 13.12.1995 / 16:07:14 / cg"
    "Modified: / 28.1.1998 / 20:42:14 / cg"
!

doDeleteClassAndPrivateClassesAll
    "delete all changes with same class and private classes
     as currently selected change"

    |lastChangeNr classNamesToDelete overAllNumDeletedBefore|

    lastChangeNr := -1.
    classNamesToDelete := Set new.
    self withSelectedChangesDo:[:changeNr |
        |classNameToDelete|

        classNameToDelete := self ownerClassNameOfChange:changeNr.
        classNameToDelete notNil ifTrue:[
            classNamesToDelete add:classNameToDelete.
        ].
        lastChangeNr := lastChangeNr max:changeNr.
    ].

    overAllNumDeletedBefore := 0.
    changeListView setSelection:nil.

    self withExecuteCursorDo:[
        classNamesToDelete do:[:classNameToDelete |
            | changeNr numDeletedBefore|

            classNameToDelete notNil ifTrue:[
                changeListView setSelection:nil.
                self silentDeleteChangesForClassAndPrivateClasses:classNameToDelete
                                       from:lastChangeNr
                                         to:(self numberOfChanges).
                numDeletedBefore := self
                                       silentDeleteChangesForClassAndPrivateClasses:classNameToDelete
                                       from:1
                                       to:(lastChangeNr-1).
                lastChangeNr := lastChangeNr - numDeletedBefore.
                overAllNumDeletedBefore := overAllNumDeletedBefore + numDeletedBefore.
            ]
        ]
    ].
    self setChangeList.
    self autoSelectOrEnd:lastChangeNr.

    "Created: / 13.12.1995 / 16:07:14 / cg"
    "Modified: / 28.1.1998 / 20:42:14 / cg"
!

doDeleteClassFromBeginning
    "delete changes with same class as currently selected change from the beginning
     up to the selected change.
     Useful to get rid of obsolete changes before a fileout or checkin entry."

    self withSingleSelectedChangeDo:[:changeNr |
	|classNameToDelete prevSelection numDeleted|

	classNameToDelete := self classNameOfChange:changeNr.
	classNameToDelete notNil ifTrue:[
	    prevSelection := changeNr.
	    changeListView setSelection:nil.
	    numDeleted := self
				silentDeleteChangesFor:classNameToDelete
				from:1
				to:changeNr.
	    self setChangeList.
	    self autoSelectOrEnd:(changeNr + 1 - numDeleted)
	]
    ].

    "Created: 13.12.1995 / 15:41:58 / cg"
    "Modified: 25.5.1996 / 12:26:34 / cg"
!

doDeleteClassRest
    "delete rest of changes with same class as currently selected change"

    self withSingleSelectedChangeDo:[:changeNr |
	| classNameToDelete |

	classNameToDelete := self classNameOfChange:changeNr.
	classNameToDelete notNil ifTrue:[
	    changeListView setSelection:nil.
	    self silentDeleteChangesFor:classNameToDelete
				   from:changeNr
				     to:(self numberOfChanges).
	    self setChangeList.
	    self autoSelectOrEnd:changeNr
	]
    ]

    "Modified: / 18.5.1998 / 14:25:07 / cg"
!

doDeleteClassSelectorAll
    "delete all changes with same class and selector as currently selected change"

    |classNameSelectorPairsToDelete lastChangeNr overAllNumDeletedBefore|

    lastChangeNr := -1.
    classNameSelectorPairsToDelete := Set new.
    self withSelectedChangesDo:[:changeNr |
	|className selector|

	className := self classNameOfChange:changeNr.
	selector := self selectorOfMethodChange:changeNr.
	selector notNil ifTrue:[
	    (className notNil and:[selector notNil]) ifTrue:[
		classNameSelectorPairsToDelete add:(className -> selector).
	    ]
	].
	lastChangeNr := lastChangeNr max:changeNr.
    ].

    overAllNumDeletedBefore := 0.
    changeListView setSelection:nil.

    self withExecuteCursorDo:[
	classNameSelectorPairsToDelete do:[:pair |
	    |numDeletedBefore className selector|

	    className := pair key.
	    selector  := pair value.
	    self silentDeleteChangesFor:className selector:selector
				   from:lastChangeNr
				     to:(self numberOfChanges).
	    numDeletedBefore := self
				   silentDeleteChangesFor:className selector:selector
				   from:1
				   to:(lastChangeNr-1).
	    lastChangeNr := lastChangeNr - numDeletedBefore.
	    overAllNumDeletedBefore := overAllNumDeletedBefore + numDeletedBefore.
	].
    ].

    self setChangeList.
    self autoSelectOrEnd:lastChangeNr

    "Created: / 13.12.1995 / 16:07:14 / cg"
    "Modified: / 28.1.1998 / 20:42:14 / cg"
!

doDeleteClassSelectorOlder
    "delete older changes with same class and selector as currently selected change(s)"

    |classNameSelectorPairsToDelete upToPerClassAndSelector lastChangeNr overAllNumDeletedBefore|

    lastChangeNr := -1.
    classNameSelectorPairsToDelete := Set new.
    upToPerClassAndSelector := Dictionary new.
    
    "/ collect what is to be deleted
    self withSelectedChangesDo:[:changeNr |
        |className selector|

        className := self classNameOfChange:changeNr.
        selector := self selectorOfMethodChange:changeNr.
        selector notNil ifTrue:[
            (className notNil and:[selector notNil]) ifTrue:[
                classNameSelectorPairsToDelete add:(className -> selector).
                upToPerClassAndSelector at:(className -> selector) put:changeNr.
            ]
        ].
        lastChangeNr := lastChangeNr max:changeNr.
    ].
        
    overAllNumDeletedBefore := 0.
    changeListView setSelection:nil.

    self withExecuteCursorDo:[
        classNameSelectorPairsToDelete do:[:pair |
            |numDeletedBefore className selector lastToDelete|

            className := pair key.
            selector  := pair value.
            lastToDelete := (upToPerClassAndSelector at:pair) - 1.
            
            numDeletedBefore := self
                                   silentDeleteChangesFor:className selector:selector
                                   from:1
                                   to:lastToDelete.
            lastChangeNr := lastChangeNr - numDeletedBefore.
            overAllNumDeletedBefore := overAllNumDeletedBefore + numDeletedBefore.
        ].
    ].

    self setChangeList.
    self autoSelectOrEnd:lastChangeNr
!

doDeleteFromBeginning
    "delete all changes from 1 to the current"

    self withSingleSelectedChangeDo:[:changeNr |
	self deleteChangesFrom:1 to:changeNr.
	self clearCodeView.
	self autoSelectOrEnd:changeNr
    ]
!

doDeleteRest
    "delete all changes from current to the end"

    self withSingleSelectedChangeDo:[:changeNr |
	self deleteChangesFrom:changeNr to:(self numberOfChanges).
	self clearCodeView.
	self autoSelectOrEnd:changeNr-1
    ]
!

doFileoutAndDeleteClassAll
    "first fileOut the selected changes class then delete all changes
     for it."

    self withSingleSelectedChangeDo:[:changeNr |
	| className class |

	className := self classNameOfChange:changeNr.
	className notNil ifTrue:[
	    class := Smalltalk classNamed:className.
	    class notNil ifTrue:[
		Class fileOutErrorSignal handle:[:ex |
		    self warn:('fileout failed: ' , ex description).
		] do:[
		    class fileOut.
		    self doDeleteClassAll
		].
	    ].

	].
    ]

    "Modified: 6.9.1995 / 17:11:16 / claus"
!

doMakePatch
    "user wants a change to be made a patch
     - copy it over to the patches file"

    self withSelectedChangesDo:[:changeNr |
	self makeChangeAPatch:changeNr.
	self autoSelect:(changeNr + 1)
    ]
!

doMakePermanent
    "user wants a change to be made permanent
     - rewrite the source file where this change has to go"

    |yesNoBox|

    self checkSingleSelectedChange.

    yesNoBox := YesNoBox new.
    yesNoBox title:(resources string:'Warning: this operation cannot be undone').
    yesNoBox okText:(resources string:'continue') noText:(resources string:'abort').
    yesNoBox okAction:[   |changeNr|

                          changeNr := self theSingleSelection.
                          changeNr notNil ifTrue:[
                              self makeChangePermanent:changeNr.
                              self autoSelect:(changeNr + 1)
                          ]
                      ].
    yesNoBox showAtPointer.
    yesNoBox destroy

    "Modified: 7.1.1997 / 23:03:33 / cg"
!

doSave
    "user wants a change to be appended to a file"

    |fileName|

    fileName := Dialog
                    requestFileNameForSave:(resources string:'Append change to:')
                    default:(lastSaveFileName ? '')
                    ok:(resources string:'Append')
                    abort:(resources string:'Abort')
                    pattern:'*.chg'.
    fileName isEmptyOrNil ifTrue:[
        ^ self
    ].
    lastSaveFileName := fileName.

    self withWriteCursorDo:[
        self withSelectedChangesDo:[:changeNr |
            self appendChange:changeNr toFile:fileName.
            self autoSelect:(changeNr + 1)
        ].
    ]

    "Modified: / 27-07-2012 / 09:46:14 / cg"
!

doSaveClass
    "user wants changes for some class from current to end to be appended to a file"

    self checkSingleSelectedChange.
    self doSaveClassFrom:1
!

doSaveClassAll
    "user wants changes for some class from current to end to be appended to a file"

    self checkSingleSelectedChange.
    self doSaveClassFrom:1
!

doSaveClassFrom:startNr
    "user wants changes from current to end to be appended to a file"

    |changeNr classNameToSave|

    changeNr := self checkSingleSelectedChange.
    classNameToSave := self classNameOfChange:changeNr.
    classNameToSave notNil ifTrue:[
        self saveClass:classNameToSave from:startNr
    ]
!

doSaveClassRest
    "user wants changes for some class from current to end to be appended to a file"

    |changeNr|

    changeNr := self checkSingleSelectedChange.
    self doSaveClassFrom:changeNr.

    changeListView setSelection:changeNr.
    "/ self changeSelection:changeNr.
!

doSaveRest
    "user wants changes from current to end to be appended to a file"

    |changeNr fileName|

    (changeNr := self theSingleSelection) isNil ifTrue:[
        ^ self information:(resources string:'Only possible if a single change is selected.').
    ].

    fileName := Dialog
                    requestFileNameForSave:(resources string:'Append changes to:')
                    default:(lastSaveFileName ? '')
                    ok:(resources string:'Append')
                    abort:(resources string:'Abort')
                    pattern:'*.chg'.

    fileName notNil ifTrue:[
        lastSaveFileName := fileName.
        self withWriteCursorDo:[
            changeNr to:(self numberOfChanges) do:[:changeNr |
                changeListView setSelection:changeNr.
                (self appendChange:changeNr toFile:fileName) ifFalse:[
                    ^ self
                ]
            ]
        ]
    ]

    "Modified: / 27-07-2012 / 09:46:09 / cg"
!

doUpdate
    "reread the changes-file"

    self readChangesFileInBackground:true.
    self newLabel:''.
    realized ifTrue:[
	self setChangeList.
    ]
!

doWriteBack
    "write back the list onto the changes file"

    anyChanges ifTrue:[
        (self writeBackChanges) ifTrue:[
            realized ifTrue:[
                self readChangesFile.
                realized ifTrue:[
                    self setChangeList
                ]
            ]
        ]
    ]

    "Modified: 5.9.1996 / 17:19:46 / cg"
!

findClass
    "findClass menu action: let user enter a classes name, and select the next change for that class"

    |current|

    changeNrShown notNil ifTrue:[
        current := self classNameOfChange:changeNrShown.
    ].

    self
        askForSearch:'Class to search for:'
        initialAnswer:current
        thenSearchUsing:[:searchString :changeNr |
                            |thisClassName|

                            thisClassName := self classNameOfChange:changeNr.
                            thisClassName notNil
                            and:[
                                (thisClassName sameAs: searchString)
                                or:[searchString includesMatchCharacters and:[searchString match:thisClassName caseSensitive:false]]]
                        ]
        onCancel:[^ self].

    lastSearchType := #class.
    changeNrShown == 0 ifTrue:[changeNrShown := nil].
!

findFirstForClass
    "findNextForClass menu action: select the next change for the selected changes class"

    self findNextForClassStartingAt:1

    "Created: / 20-11-2006 / 16:37:56 / cg"
!

findFirstForClass:className
    "findNextForClass menu action: select the next change for the selected changes class"

    self findNextForClass:className startingAt:1
!

findLastForClass
    "findPreviousForClass menu action: select the previous change for the selected changes class"

    self findPreviousForClassStartingAt:(self numberOfChanges)

    "Created: / 20-11-2006 / 16:39:15 / cg"
!

findLastForClass:className
    "findPreviousForClass menu action: select the previous change for the selected changes class"

    self findPreviousForClass:className startingAt:(self numberOfChanges)

    "Created: / 20-11-2006 / 16:39:15 / cg"
!

findLastSnapshot
    "findLastSnapshot menu action: select the last change which is for a snapShot-image save action"

    "/ lastSearchType := #snapshot.

    self 
        findPreviousForWhich: [:changeNr | self changeIsSnapShotInfo:changeNr ]
        startingAt:(self numberOfChanges)

    "Created: / 06-10-2006 / 11:03:39 / cg"
!

findNext
    "findNext menu action: select the next change.
     Searches for what the last search was for; i.e. either same class or same selector"

    lastSearchType == #selector ifTrue:[
	^ self findNextForSelector
    ].
    lastSearchType == #snapshot ifTrue:[
	^ self findNextSnapshot
    ].
    lastSearchType == #string ifTrue:[
	^ self findNextForString
    ].
    lastSearchType == #difference ifTrue:[
	^ self findNextDifference
    ].

    ^ self findNextForClass

    "Created: / 18.6.1998 / 22:15:00 / cg"
    "Modified: / 18.6.1998 / 22:15:25 / cg"
!

findNextDifference
    lastSearchType := #difference.
    changeNrShown isNil ifTrue:[^ self].

    self findNextForWhich:[:changeNr |
	    (self compareChange:changeNr showResult:false) == true ifTrue:[
		"/ same
		false
	    ] ifFalse:[
		"/ different
		true
	    ]
	]
!

findNextForClass
    "findNextForClass menu action: select the next change for the selected changes class"

    self findNextForClassStartingAt: changeNrShown + 1

    "Modified: / 20-11-2006 / 16:37:49 / cg"
!

findNextForClass:className startingAt:startNr
    "findNextForClass menu action: select the next change for the selected changes class"

    lastSearchType := #class.

    self 
        findNextForWhich:[:changeNr |
                |thisClass|

                thisClass := self classNameOfChange:changeNr.
                (thisClass = className
                or:[className includesMatchCharacters 
                    and:[className match:thisClass]])]
        startingAt:startNr
!

findNextForClassStartingAt:startNr
    "findNextForClass menu action: select the next change for the selected changes class"

    |cls|

    lastSearchType := #class.
    changeNrShown isNil ifTrue:[^ self].

    cls := self classNameOfChange:changeNrShown.
    cls isNil ifTrue:[^ self].
    self findNextForClass:cls startingAt:startNr.

    "Created: / 20-11-2006 / 16:37:37 / cg"
!

findNextForSelector
    "findNextForSelector menu action: select the next change for the selected changes selector"

    |sel|

    lastSearchType := #selector.
    changeNrShown isNil ifTrue:[^ self].

    sel := self selectorOfMethodChange:changeNrShown.
    sel isNil ifTrue:[^ self].

    self findNextForWhich: [:changeNr |
		|thisSelector|

		thisSelector := self selectorOfMethodChange:changeNr.
		(thisSelector = sel or:[sel includesMatchCharacters and:[sel match:thisSelector]])
	]

!

findNextForString
    lastSearchString isNil ifTrue:[
	^ self findString
    ].
    self findNextWithString:lastSearchString
!

findNextForWhich:aBlock
    "helper: select the next change for which aBlock evaluates to true"

    ^ self findNextForWhich:aBlock startingAt:changeNrShown + 1

    "Modified: / 20-11-2006 / 16:34:23 / cg"
!

findNextForWhich:aBlock startingAt:changeNrToStartSearch
    "helper: select the next change for which aBlock evaluates to true"

    ^ self     
        findNextOrPrevious:#next 
        forWhich:aBlock startingAt:changeNrToStartSearch

    "Created: / 20-11-2006 / 16:34:06 / cg"
!

findNextOrPrevious:direction forWhich:aBlock startingAt:changeNrToStartSearch
    "helper: find and select the next or previous change for which aBlock evaluates to true"

    self withCursor:Cursor questionMark do:[
        Object userInterruptSignal handle:[:ex |
            self beep.
            ^ 0
        ] do:[
            |increment nr lastNr|

            increment := (direction == #previous) ifTrue:[-1] ifFalse:[1].
            lastNr := self numberOfChanges.
            nr := changeNrToStartSearch.
            [ (direction == #previous and:[nr >= 1])
              or:[ direction == #next and:[ nr <= lastNr]] 
            ] whileTrue:[
                (aBlock value:nr) ifTrue:[
                    changeListView setSelection:nr.
                    self changeSelection:nr.
                    ^ nr
                ].
                nr := nr + increment.
            ].
        ]
    ].
    self showNotFound.
    self windowGroup sensor flushKeyboard. "/ avoid multiple beeps, in case of type ahead
    ^ 0

    "Created: / 08-03-2012 / 11:57:26 / cg"
!

findNextSnapshot
    "findNextSnapshot menu action: select the next change which is for a snapShot-image save action"

    lastSearchType := #snapshot.
    changeNrShown isNil ifTrue:[^ self].

    self findNextForWhich: [:changeNr | self changeIsSnapShotInfo:changeNr ]
!

findNextWithString:searchString
    |includesMatchCharacters|

    lastSearchType := #string.

    lastSearchString := searchString.

    changeNrShown isNil ifTrue:[
        changeNrShown := 0.
    ].

    includesMatchCharacters := searchString includesMatchCharacters.

    self findNextForWhich:
        [:changeNr |
            |s|

            s := self sourceOfMethodChange:changeNr.
            s notNil and:[
                (includesMatchCharacters not and:[(s findString:searchString) ~~ 0])
                or:[ includesMatchCharacters and:[('*' , searchString , '*') match:s ]]]
        ].

    changeNrShown == 0 ifTrue:[changeNrShown := nil].

    codeView setSearchPattern:searchString.
    codeView
        searchFwd:searchString
        ignoreCase:false
        startingAtLine:1 col:0
        ifAbsent:nil.
!

findPrevious
    "findPrevious menu action: select the previous change.
     Searches for what the last search was for; i.e. either same class or same selector"

    lastSearchType == #selector ifTrue:[
	^ self findPreviousForSelector
    ].
    lastSearchType == #snapshot ifTrue:[
	^ self findPreviousSnapshot
    ].
    lastSearchType == #string ifTrue:[
	^ self findPreviousForString
    ].
    lastSearchType == #difference ifTrue:[
	^ self findPreviousDifference
    ].

    ^ self findPreviousForClass

    "Created: / 18.6.1998 / 22:15:15 / cg"
!

findPreviousDifference
    lastSearchType := #difference.
    changeNrShown isNil ifTrue:[^ self].

    self findPreviousForWhich:[:changeNr |
	    (self compareChange:changeNr showResult:false) == true ifTrue:[
		"/ same
		false
	    ] ifFalse:[
		"/ different
		true
	    ]
	]
!

findPreviousForClass
    "findPreviousForClass menu action: select the previous change for the selected changes class"

    self findPreviousForClassStartingAt:((changeNrShown ? 1) - 1)

    "Modified: / 20-11-2006 / 16:39:04 / cg"
!

findPreviousForClass:className startingAt:startNr
    "findPreviousForClass menu action: select the previous change for the selected changes class"

    lastSearchType := #class.

    self 
        findPreviousForWhich:
            [:changeNr |
                    |thisClass|

                    thisClass := self classNameOfChange:changeNr.
                    (thisClass = className
                    or:[className includesMatchCharacters 
                        and:[className match:thisClass]])]
        startingAt:startNr
!

findPreviousForClassStartingAt:startNr
    "findPreviousForClass menu action: select the previous change for the selected changes class"

    |cls|

    lastSearchType := #class.
    changeNrShown isNil ifTrue:[^ self].

    cls := self classNameOfChange:changeNrShown.
    cls isNil ifTrue:[^ self].

    self findPreviousForClass:cls startingAt:startNr

    "Created: / 20-11-2006 / 16:38:37 / cg"
!

findPreviousForSelector
    "findPreviousForSelector menu action: select the previous change for the selected changes selector"

    |sel|

    lastSearchType := #selector.
    changeNrShown isNil ifTrue:[^ self].

    sel := self selectorOfMethodChange:changeNrShown.
    sel isNil ifTrue:[^ self].

    self findPreviousForWhich:
	[:changeNr |
		|thisSelector|

		thisSelector := self selectorOfMethodChange:changeNr.
		(thisSelector = sel
		or:[sel includesMatchCharacters and:[sel match:thisSelector]])
	]

!

findPreviousForString
    lastSearchString isNil ifTrue:[
	^ self findString
    ].
    self findPreviousWithString:lastSearchString
!

findPreviousForWhich:aBlock
    "helper: select the previous change for which aBlock evaluates to true"

    ^ self findPreviousForWhich:aBlock startingAt:(changeNrShown - 1)

    "Modified: / 06-10-2006 / 11:01:38 / cg"
!

findPreviousForWhich:aBlock startingAt:changeNrToStartSearch
    "helper: select the previous change for which aBlock evaluates to true"

    ^ self     
        findNextOrPrevious:#previous 
        forWhich:aBlock startingAt:changeNrToStartSearch

    "Created: / 06-10-2006 / 11:01:09 / cg"
!

findPreviousSnapshot
    "findPreviousSnapshot menu action: select the previous change which is for a snapShot-image save action"

    lastSearchType := #snapshot.
    changeNrShown isNil ifTrue:[^ self].

    self findPreviousForWhich: [:changeNr | self changeIsSnapShotInfo:changeNr ]
!

findPreviousWithString:searchString
    |includesMatchCharacters|

    lastSearchType := #string.

    lastSearchString := searchString.

    changeNrShown isNil ifTrue:[
        changeNrShown := 0.
    ].

    includesMatchCharacters := searchString includesMatchCharacters.

    self findPreviousForWhich:
        [:changeNr |
            |s |

            s := self sourceOfMethodChange:changeNr.
            s notNil and:[
                (includesMatchCharacters not and:[(s findString:searchString) ~~ 0])
                or:[includesMatchCharacters and:[('*' , searchString , '*') match:s ]]]
        ].

    changeNrShown == 0 ifTrue:[changeNrShown := nil].

    codeView setSearchPattern:searchString.
    codeView
        searchFwd:searchString
        ignoreCase:false
        startingAtLine:1 col:0
        ifAbsent:nil.
!

findSelector
    "findSelector menu action: let user enter a selector, and select the next change for that selector"

    |current|

    changeNrShown notNil ifTrue:[
	current := self selectorOfMethodChange:changeNrShown.
    ].

    self
	askForSearch:'Selector to search for:'
	initialAnswer:current
	thenSearchUsing:[:searchString :changeNr |
			    |thisSelector|

			    thisSelector := self selectorOfMethodChange:changeNr.
			    (thisSelector = searchString
			    or:[searchString includesMatchCharacters and:[searchString match:thisSelector]])
			]
	onCancel:[^ self].

    lastSearchType := #selector.
    changeNrShown == 0 ifTrue:[changeNrShown := nil].
!

findString
    |searchString directionHolder|

    lastSearchType := #string.

    searchString := codeView selection.
    searchString size == 0 ifTrue:[searchString := lastSearchString].

    searchString := self
	askForSearchString:'String to search for:'
	initialAnswer:(searchString ? '')
	directionInto:(directionHolder := ValueHolder new).

    searchString size == 0 ifTrue:[
	^ self
    ].

    directionHolder value == #backward ifTrue:[
	self findPreviousWithString:searchString.
    ] ifFalse:[
	self findNextWithString:searchString.
    ]
!

ignorePublicPrivateCategories:aBoolean
    UserPreferences current ignorePublicPrivateCategories:aBoolean

    "Created: / 23-09-2011 / 19:52:21 / cg"
!

menuExit
    self closeRequest
!

openAboutThisApplication
    "opens an about box for this application."

    Dialog aboutClass:self class.

    "Modified: / 12-09-2006 / 17:20:22 / cg"
!

openHTMLDocument:relativeDocPath
    HTMLDocumentView openFullOnDocumentationFile:relativeDocPath
!

openSettingsDialog
    |settingsList|

    settingsList := 
        #(
            #('Editor'                  #'AbstractSettingsApplication::EditSettingsAppl'                )
"/            #('Syntax Color'            #'AbstractSettingsApplication::SyntaxColorSettingsAppl'         )
"/            #('Code Format'             #'AbstractSettingsApplication::SourceCodeFormatSettingsAppl'    )
"/            #('System Browser'          #'AbstractSettingsApplication::SystemBrowserSettingsAppl'       )
            #('Compiler'                #'AbstractSettingsApplication::GeneralCompilerSettingsAppl'     )
            #('Compiler/ByteCode'       #'AbstractSettingsApplication::ByteCodeCompilerSettingsAppl'    )
"/            #('Source Code Management'  #'AbstractSettingsApplication::SourceCodeManagementSettingsAppl')
        ).

    SettingsDialog 
        openWithList:settingsList 
        label:(resources string:'Change Browser Settings').
!

setEnforcedNameSpace
    |nsName listOfKnownNameSpaces keepAsDefaultHolder|

    listOfKnownNameSpaces := Set new.
    NameSpace
        allNameSpaces
            do:[:eachNameSpace |
                listOfKnownNameSpaces add:eachNameSpace name
            ].
    listOfKnownNameSpaces := listOfKnownNameSpaces asOrderedCollection sort.

    Dialog modifyingBoxWith:[:box |
        keepAsDefaultHolder := true asValue.
        box verticalPanel
            add:((CheckBox 
                    label:(resources string:'Use this as default in the future')) 
                    model:keepAsDefaultHolder).
    ] do:[
        nsName := Dialog
                request:(resources string:'When applying, new classes are created in nameSpace:')
                initialAnswer:(enforcedNameSpace ? LastEnforcedNameSpace ? Class nameSpaceQuerySignal query name)
                list:listOfKnownNameSpaces.
    ].
    nsName isNil ifTrue:[^ self].

    (nsName isEmpty or:[nsName = 'Smalltalk']) ifTrue:[
        applyInOriginalNameSpace value:true.
        LastEnforcedNameSpace := enforcedNameSpace := nil.
    ] ifFalse:[
        applyInOriginalNameSpace value:false.
        LastEnforcedNameSpace := enforcedNameSpace := NameSpace name:nsName.
        autoCompare value ifTrue:[
            self doUpdate
        ].
    ].
    KeepEnforcedNameSpace := keepAsDefaultHolder value.
    codeView nameSpaceForDoits:enforcedNameSpace.
    diffView textViews do:[:each | each nameSpaceForDoits:enforcedNameSpace].

    "Modified: / 26-07-2012 / 23:06:23 / cg"
!

setEnforcedPackage
    |pkg listOfKnownPackages|

    listOfKnownPackages := Smalltalk allPackageIDs.
"/    Smalltalk allClassesDo:[:eachClass |
"/                                |package|
"/
"/                                package := eachClass package.
"/                                package size > 0 ifTrue:[
"/                                    listOfKnownPackages add:package
"/                                ]
"/                           ].
    listOfKnownPackages := listOfKnownPackages asNewOrderedCollection sort.

    pkg := Dialog
                request:'When applying, changes go into package:'
                initialAnswer:(enforcedPackage ? Class packageQuerySignal query)
                list:listOfKnownPackages.
    pkg size ~~ 0 ifTrue:[
        enforcedPackage := pkg
    ]
!

showAboutSTX
    ToolApplicationModel openAboutSTX
! !

!ChangesBrowser methodsFor:'private'!

autoSelect:changeNr
    "select a change"

    self class autoSelectNext ifTrue:[
	(changeNr <= self numberOfChanges) ifTrue:[
	    changeListView setSelection:changeNr.
	    self changeSelection:changeNr.
	    ^ self
	]
    ].
    self clearCodeView.
    changeListView setSelection:nil.

    "Modified: / 18.5.1998 / 14:26:43 / cg"
!

autoSelectLast
    "select the last change"

    self autoSelect:(self numberOfChanges)
!

autoSelectOrEnd:changeNr
    "select the next change or the last"

    |last|

    last := self numberOfChanges.
    changeNr < last ifTrue:[
	self autoSelect:changeNr
    ] ifFalse:[
	last == 0 ifTrue:[
	    last := nil
	].
	changeListView setSelection:last .
	self changeSelection:last.
    ]

    "Modified: / 13.11.2001 / 13:00:45 / cg"
!

beep
    "output an audible beep or bell on my screen device"

    UserPreferences current beepInEditor ifTrue:[                
        super beep
    ]
!

changeChunkAt:index
    ^ (changeInfoList at:index) chunk
    "/ ^ changeChunks at:index

    "Created: / 01-05-2016 / 18:24:28 / cg"
!

changeClassNameAt:index
    ^ (changeInfoList at:index) className

    "Created: / 01-05-2016 / 18:28:13 / cg"
    "Modified: / 01-05-2016 / 19:32:42 / cg"
!

checkClassIsLoaded:aClass
    "check for and warn if a class is unloaded (helper for compare-change)"

    |cls answer|

    cls := aClass theNonMetaclass.
    cls isLoaded ifTrue:[
        ^ true.
    ].
    (classesNotToBeAutoloaded includes:#all) ifTrue:[
        ^ false.
    ].
    (classesNotToBeAutoloaded includes:cls) ifTrue:[
        ^ false.
    ].

    autoloadAsRequired value == true ifTrue:[
        answer := true
    ] ifFalse:[
        answer := Dialog 
                confirmWithCancel:(resources
                    stringWithCRs:'%1 is an autoloaded class.\I can only compare the method''s source if its loaded first.\\Shall the class be loaded now ?'
                    with:cls name allBold)
                labels:(resources array:#('Cancel' 'No for All' 'No' 'Yes'))
                values:#(nil #never false true)
                default:4.
        answer isNil ifTrue:[
            "cancel the operation"
            AbortAllOperationRequest raise.
            "not reached"
        ].
        answer == #never ifTrue:[
            classesNotToBeAutoloaded add:#all.
            ^ false.
        ].
    ].

    answer ifTrue:[
        Autoload autoloadFailedSignal catch:[
            ^ cls autoload isLoaded
        ]
    ].

    classesNotToBeAutoloaded add:cls.

    ^ false.
!

checkSingleSelectedChange
    "just a helper, check for a single selection"

    |changeNr|

    (changeNr := self theSingleSelection) isNil ifTrue:[
        self information:'Only possible if a single change is selected.'.
        AbortSignal raise.
        ^ nil.
    ].
    ^ changeNr
!

classFromEvaluatingTree:aParseTree
    |thisClass|

    Class nameSpaceQuerySignal answer:(self nameSpaceForApply)
    do:[
        thisClass := Parser undefinedVariableError handle:[:ex | ] do:[ aParseTree evaluate ]. 
    ].
    ^ thisClass

    "Created: / 05-03-2012 / 14:28:01 / cg"
!

clearCodeView
    "clear the (lower) code view."

    self unselect "changeListView deselect".
    codeView contents:nil.
    changeNrShown := nil
!

currentSourceForParseTree:parseTree
    |selector thisClass method mClass thisClassSym ownerClass receiver classGlobalNode|

    (parseTree isNil
    or:[parseTree == #Error
    or:[ parseTree isMessage not ]]) ifTrue:[
        ^ nil
    ].

    selector := parseTree selector.
    receiver := parseTree receiver.

    selector == #'removeSelector:' ifTrue:[
        thisClass := self classFromEvaluatingTree:receiver. 
        thisClass isBehavior ifTrue:[
            thisClass isLoaded ifTrue:[
                selector := (parseTree arg1 evaluate).
                (thisClass includesSelector:selector) ifTrue:[
                    ^ (thisClass compiledMethodAt:selector) source.
                ]
            ] ifFalse:[
                ^ 'Cannot compare this change\\(compare requires class to be loaded).' withCRs.
            ]
        ] ifFalse:[
            ^ 'Cannot compare this change (class not present)'.
        ].
    ].
    selector == #'comment:' ifTrue:[
        thisClass := self classFromEvaluatingTree:receiver. 
        thisClass isBehavior ifTrue:[
            thisClass isLoaded ifTrue:[
                ^ thisClass name , ' comment: ' , thisClass comment storeString.
            ] ifFalse:[
                ^ 'Cannot compare this change\\(compare requires class to be loaded).' withCRs.
            ]
        ] ifFalse:[
            ^ 'Cannot compare this change (class not present)'.
        ].
    ].

    (#(#'category:' #'package:') includes:selector) ifTrue:[
        receiver isMessage ifTrue:[
            receiver selector == #compiledMethodAt: ifTrue:[
"/                thisClass := self classFromEvaluatingTree:receiver receiver. 
"/                thisClass isNil ifTrue:[
"/                    ^ 'Class does not exist.'.
"/                ].

                classGlobalNode := receiver receiver.
                (classGlobalNode isMessage and:[classGlobalNode selector == #class]) ifTrue:[
                    classGlobalNode := classGlobalNode receiver
                ].
                classGlobalNode isUndeclared ifTrue:[
                    ^ 'Class does not exist.'.
                ].
                Error handle:[method := nil] do:[method := receiver evaluate].
                method isMethod ifFalse:[
                    ^ 'There is no such method'.
                ].
                mClass := method mclass.

                selector == #category: ifTrue:[
"/                    method category = parseTree arg1 evaluate ifFalse:[
                        ^ '(' , mClass name , ' compiledMethodAt: ' , method selector storeString , ') category: ' , method category storeString.
"/                    ].
                ] ifFalse:[
"/                    method package = parseTree arg1 evaluate ifFalse:[
                        ^ '(' , mClass name , ' compiledMethodAt: ' , method selector storeString , ') package: ' , method package storeString.
"/                    ].
                ].
                ^ nil
            ]
        ]
    ].

    selector == #'instanceVariableNames:' ifTrue:[
        receiver isMessage ifTrue:[
            receiver selector == #class ifTrue:[
                thisClass := self classFromEvaluatingTree:receiver. 
                thisClass isBehavior ifTrue:[
                    thisClass isLoaded ifTrue:[
"/                                varsHere := thisClass instanceVariableString asCollectionOfWords.
"/                                varsInChange := (parseTree arguments at:1) evaluate asCollectionOfWords.
                        ^ thisClass definition.
                    ] ifFalse:[
                        ^ 'Cannot compare this change\\(compare requires class to be loaded).' withCRs.
                    ].
                ] ifFalse:[
                    ^ 'Cannot compare this change (class not present)'.
                ]
            ].
        ]
    ].

    (Class definitionSelectors includes:selector)
    "/ selector == #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
    ifTrue:[
"/        Class nameSpaceQuerySignal 
"/            answer:(self nameSpaceForApply)
"/            do:[
"/                superClass := receiver evaluate.
"/            ]. 
"/        superClass isBehavior ifFalse:[
"/            self nameSpaceForApply classNamed:receiver name
"/        ].
"/        superClass isBehavior ifFalse:[
"/            |rest matchingKeys superClassName|
"/
"/            rest := '::' , receiver name.
"/            matchingKeys := Smalltalk keys select:[:nm | nm endsWith:rest].
"/            superClassName := Dialog choose:'Which Class ?' fromList:matchingKeys lines:10.
"/            superClassName notEmptyOrNil ifTrue:[
"/                superClass := Smalltalk at:superClassName asSymbol.    
"/            ].
"/        ].
"/        superClass isBehavior ifFalse:[
"/            ^ 'Cannot compare this change\\(no such superclass).' withCRs.
"/        ].
"/        superClass isLoaded ifFalse:[
"/            ^ 'Cannot compare this change\\(superclass not loaded).' withCRs.
"/        ].

        thisClassSym := (parseTree arguments at:1) evaluate.

        (selector endsWith:':privateIn:') ifTrue:[
            ownerClass := (parseTree arguments at:5).
            ownerClass isUndeclared ifFalse:[
                ownerClass := ownerClass evaluate.
            ] ifTrue:[
                ownerClass := nil.
            ].
            ownerClass isNil ifTrue:[
                ^ 'Cannot compare this change\\(owning class is not loaded).' withCRs.
            ].
            thisClass := ownerClass privateClassesAt:thisClassSym.
        ] ifFalse:[
            thisClass := (self nameSpaceForApply) at:thisClassSym ifAbsent:nil.
        ].
        thisClass notNil ifTrue:[
            thisClass isLoaded ifFalse:[
                ^ 'Cannot compare this change\\(compare requires class to be loaded).' withCRs.
            ] ifTrue:[
                ^ thisClass definition.
            ]
        ]
    ].

    ^ nil.

    "Created: / 15-02-2012 / 15:11:15 / cg"
!

isChangeSetBrowser
    ^ false
!

makeDiffViewInvisible
    diffViewBox lower
!

makeDiffViewVisible
    diffViewBox raise
!

nameSpaceForApply
    applyInOriginalNameSpace value ifFalse:[
	^ enforcedNameSpace ? Class nameSpaceQuerySignal query.
    ].
    ^ Smalltalk.
!

newLabel:how
    |l|

    l := self class defaultLabel.
    (changeFileName notNil and:[changeFileName ~= 'changes']) ifTrue:[
        l := l , ': ', changeFileName
    ].
    l := l , ' ' , how.
    self label:l

    "Created: / 08-09-1995 / 19:32:04 / claus"
    "Modified: / 12-11-2006 / 16:23:53 / cg"
!

parseExpression:chunk
    ^ self parseExpression:chunk inNameSpace:(self nameSpaceForApply).
!

parseExpression:text inNameSpace:nameSpace
    |parser p|

    "/ old:
    "/ does not care for VW qualified names
    "/ ^ Parser parseExpression:text inNameSpace:nameSpace.

(text includesString:'§') ifTrue:[self halt].

    "/ new:
    parser := Parser for:(ReadStream on:text).
    parser parserFlags allowQualifiedNames:true.
    parser parserFlags allowDollarInIdentifier:true.
    parser parserFlags allowParagraphInIdentifier:true.
    Error handle:[:ex |
        ^ nil
    ] do:[
        p := parser 
            parseExpressionWithSelf:nil 
            notifying:nil 
            ignoreErrors:true 
            ignoreWarnings:true 
            inNameSpace:nameSpace.
    ].
    ^ p

    "Modified: / 21-11-2016 / 23:25:48 / cg"
!

queryCloseText
    "made this a method for easy redefinition in subclasses"

    ^ 'Quit without updating changeFile ?'
!

selectedClassNames
    |classes|

    classes := Set new.
    self withSelectedChangesDo:[:changeNr |
	| classNameToCompress |

	classNameToCompress := self classNameOfChange:changeNr.
	classNameToCompress notNil ifTrue:[
	    classes add:classNameToCompress.
	]
    ].
    ^ classes

    "Created: / 19.11.2001 / 21:54:59 / cg"
!

setChangeList
    "update the selection-list;
     called after the changeList has been modified"

    |headerList|

    headerList := changeInfoList collect:[:info | info headerLine].
    changeListView setList:headerList expandTabs:false redraw:false.
    changeListView invalidate.
    self showNumberOfChanges.
    
    "/ changeListView deselect.

    "Modified: / 01-05-2016 / 19:27:35 / cg"
!

setSingleSelection:changeNr
    changeListView multipleSelectOk ifFalse:[
	changeListView setSelection:changeNr.
    ] ifTrue:[
	changeListView setSelection:(Array with:changeNr).
    ].
!

showNotFound
    self withCursor:(Cursor cross) do:[
        self beep.
        Delay waitForMilliseconds:300.
    ]

    "Modified: / 29.4.1999 / 22:36:54 / cg"
!

showNumberOfChanges
    infoHolder value:(resources string:'%1 changes.' with:changeInfoList size).
!

sourceOfChange:changeNr
    |aStream sawExcla chunk|

    aStream := self streamForChange:changeNr.
    aStream isNil ifTrue:[
	^ nil
    ].
    sawExcla := aStream peekFor:(aStream class chunkSeparator).
    chunk := aStream nextChunk.
    sawExcla ifTrue:[
	chunk := aStream nextChunk
    ].
    aStream close.
    ^ chunk
!

timeStampPrintStringOf:ts
    ^ ts printString
!

unselect
    "common unselect"

    changeListView setSelection:nil.

    "Modified: 25.5.1996 / 13:02:49 / cg"
!

withSelectedChangesDo:aBlock
    "just a helper, check for a selected change and evaluate aBlock
     with busy cursor"

    self withSelectedChangesInOrder:nil do:aBlock
!

withSelectedChangesInOrder:order do:aBlock
    "just a helper, check for a selected change and evaluate aBlock
     with busy cursor"

    |changeNrSelection|

    changeNrSelection := changeListView selection.

    "if we apply multiple changes, and an error occurs,
     ask the user if all operations should be aborted..."
    multipleApply := changeNrSelection size > 1.

    changeListView multipleSelectOk ifFalse:[
        changeNrSelection notNil ifTrue:[
            self withExecuteCursorDo:[
                aBlock value:changeNrSelection
            ]
        ]
    ] ifTrue:[
        changeNrSelection size > 0 ifTrue:[
            self withExecuteCursorDo:[
                |changeNumbers|

                changeNumbers := changeNrSelection copy sort.
                order == #reverse ifTrue:[
                    changeNumbers reverse
                ].
                changeNumbers do:aBlock
            ]
        ]
    ].
!

withSelectedChangesReverseDo:aBlock
    "just a helper, check for a selected change and evaluate aBlock
     with busy cursor"

    self withSelectedChangesInOrder:#reverse do:aBlock
!

withSingleSelectedChangeDo:aBlock
    "just a helper, check for a single selection, and evaluate aBlock
     with busy cursor"

    self theSingleSelection isNil ifTrue:[
	^ self information:'Only possible if a single change is selected.'.
    ].

    self withSelectedChangesInOrder:nil do:aBlock
! !

!ChangesBrowser methodsFor:'private-change access'!

changeIsFollowupMethodChange:changeNr
    "return true, if a change is a followup change (i.e. a followup change
     in a bunch of methodsFor-changes)"

    ^ (changeInfoList at:changeNr) isFollowupChange

    "Created: / 06-02-1998 / 13:03:39 / cg"
    "Modified: / 01-05-2016 / 19:32:06 / cg"
!

changeIsSnapShotInfo:changeNr
    "return true, if a change is a snapShot info chunk"

    |words chunk|

    (self classNameOfChange:changeNr) isNil ifTrue:[
        "
         get the chunk
        "
        chunk := self changeChunkAt:changeNr.
        "mhmh - empty ??"
        chunk notNil ifTrue:[
            (chunk startsWith:'''---') ifTrue:[
                words := chunk asCollectionOfWords.
                words size > 2 ifTrue:[
                    (words at:2) = 'snapshot' ifTrue:[
                        ^ true
                    ].
                ].
            ].
        ].
    ].
    ^ false

    "Modified: / 01-05-2016 / 18:25:25 / cg"
!

classNameFromAttributeChangeParseTree:aParseTree
    "mhmh - seems to always return the name of the nonMeta class - is this OK?"

    |recTree isMeta name|

    recTree := aParseTree receiver.

    (recTree notNil
    and:[recTree ~~ #Error
    and:[recTree isMessage
    and:[recTree selector == #compiledMethodAt:]]]) ifTrue:[
        isMeta := false.
        recTree := recTree receiver.
        recTree isUnaryMessage ifTrue:[
            (recTree selector ~~ #class) ifTrue:[^ nil].
            "id class "
            recTree := recTree receiver
        ].
        recTree isPrimary ifTrue:[
            name := recTree name.
            isMeta ifTrue:[
                ^ name , ' class'.
            ].
            ^ name
        ]
    ].
    "very strange"
    ^ nil

    "Created: / 08-03-2012 / 09:42:36 / cg"
!

classNameFromClassDefinitionChange:changeNr
    |changeStream chunk fullParseTree sel arg1Tree ownerTree ownerName name|

    "/ must parse the full changes text, to get privacy information.

    changeStream := self streamForChange:changeNr.
    changeStream isNil ifTrue:[ ^ nil].

    chunk := changeStream nextChunk.
    changeStream close.
    fullParseTree := self parseExpression:chunk.
    (fullParseTree isNil or:[fullParseTree == #Error]) ifTrue:[
        ^ nil
    ].
    fullParseTree isMessage ifFalse:[
        ^ nil
    ].

    sel := fullParseTree selector.
    arg1Tree := fullParseTree arg1.
    (arg1Tree notNil and:[arg1Tree isLiteral]) ifTrue:[
        name := arg1Tree value asString.

        "/ is it a private-class ?
        ('*privateIn:' match:sel) ifTrue:[
            ownerTree := fullParseTree args last.
            ownerName := ownerTree name asString.
            ^ ownerName , '::' , name
        ].
        ^ name
    ].
    "very strange"
    ^ nil

    "Created: / 08-03-2012 / 09:34:04 / cg"
!

classNameFromReceiverInParseTree:aParseTree
    "extrat the class name from a method-change, methodRemove or comment-change's
     parse tree"

    |recTree isMeta cls name|

    recTree := aParseTree receiver.
    (recTree isNil or:[recTree == #Error]) ifTrue:[
        "more strange things"
        ^ nil
    ].

    isMeta := false.
    recTree isUnaryMessage ifTrue:[
        (recTree selector ~~ #class) ifTrue:[^ nil].
        "id class methodsFor:..."
        recTree := recTree receiver.
        isMeta := true.
    ].
    recTree isPrimary ifTrue:[
        cls := self classFromEvaluatingTree:recTree.
        cls notNil ifTrue:[^ cls name].

        name := recTree name.
        isMeta ifTrue:[
            ^ name , ' class'.
        ].
        ^ name
    ].

    "more strange things"
    ^ nil

    "Created: / 08-03-2012 / 09:26:57 / cg"
!

classNameFromRemoveClassParseTree:aParseTree
    "tree is: Smalltalk removeClass: class"

    |recTree arg1Tree|

    recTree := aParseTree receiver.

    (recTree notNil
    and:[recTree ~~ #Error
    and:[recTree isPrimary
    and:[recTree name = 'Smalltalk']]]) ifTrue:[
        arg1Tree := aParseTree arg1.
        (arg1Tree notNil and:[arg1Tree isVariable]) ifTrue:[
            ^ arg1Tree name.
        ].
    ].
    "very strange"
    ^ nil

    "Created: / 08-03-2012 / 09:36:59 / cg"
!

classNameFromRenameClassParseTree:aParseTree
    "tree is: Smalltalk renameClass: oldClass to: 'newName'"

    |recTree arg1Tree arg2Tree oldName newName|

    recTree := aParseTree receiver.

    (recTree notNil
    and:[recTree ~~ #Error
    and:[recTree isPrimary
    and:[recTree name = 'Smalltalk']]]) ifTrue:[
        arg1Tree := aParseTree arg1.
        (arg1Tree notNil and:[arg1Tree isPrimary]) ifTrue:[
            oldName := arg1Tree name.
            arg2Tree := aParseTree arg2.
            (arg2Tree notNil and:[arg2Tree isLiteral]) ifTrue:[
                newName := arg2Tree evaluate.
                (Smalltalk classNamed:oldName) notNil ifTrue:[^ oldName ].
                (Smalltalk classNamed:newName) notNil ifTrue:[^ newName ].
            ].
        ].
    ].
    "very strange"
    ^ nil

    "Created: / 08-03-2012 / 11:42:25 / cg"
!

classNameOfChange:changeNr
    "return the classname of a change
     (for classChanges (i.e. xxx class), the non-metaClassName (i.e. xxx) is returned)"

    |name|

    name := self realClassNameOfChange:changeNr.
    name isNil ifTrue:[^ nil].
    (name endsWith:' class') ifTrue:[
        name := name copyButLast:6
    ].
    ^ name

    "Modified: / 5.11.2001 / 18:10:25 / cg"
!

extractSelectorOfMethodChange:changeNr
    "return a method-changes selector, or nil if its not a methodChange"

    |source parser sel chunk aParseTree |

    source := self sourceOfMethodChange:changeNr.
    source isNil ifTrue:[
        (self classNameOfChange:changeNr) notNil ifTrue:[
            chunk := self changeChunkAt:changeNr.
            chunk isNil ifTrue:[^ nil].       "mhmh - empty"

            aParseTree := self parseExpression:chunk.
            (aParseTree isNil
            or:[aParseTree == #Error
            or:[aParseTree isMessage not]]) ifTrue:[
                ^ nil        "seems strange ... (could be a comment)"
            ].
            sel := aParseTree selector.
            (#(
                #'removeSelector:'
            ) includes:sel) ifTrue:[
                sel := aParseTree arguments at:1.
                sel isLiteral ifTrue:[
                    sel := sel evaluate.
                    sel isSymbol ifTrue:[
                        ^ sel
                    ]
                ]
            ]
        ].
        ^ nil
    ].


    parser := Parser
                parseMethodArgAndVarSpecification:source
                in:nil
                ignoreErrors:true
                ignoreWarnings:true
                parseBody:false.

    (parser notNil and:[parser ~~ #Error]) ifTrue:[
        sel := parser selector.
    ].
    ^ sel

    "Created: / 24-11-1995 / 14:30:46 / cg"
    "Modified: / 01-05-2016 / 18:25:39 / cg"
!

fullClassNameOfChange:changeNr
    "return the full classname of a change
     (for classChanges (i.e. xxx class), a string ending in ' class' is returned."

    |chunk aParseTree sel name prevMethodDefNr words oldDollarSetting|

    changeNr isNil ifTrue:[^ nil].
    "
     first look, if not already known
    "
    name := self changeClassNameAt:changeNr.
    name notNil ifTrue:[
        name == #nil ifTrue:[^ nil].
        ^ name
    ].

    prevMethodDefNr := changeNr.
    [ (changeInfoList at:prevMethodDefNr) isFollowupChange ] whileTrue:[
        prevMethodDefNr := prevMethodDefNr - 1.
    ].

    "
     get the chunk
    "
    chunk := self changeChunkAt:prevMethodDefNr.
    chunk isNil ifTrue:[^ nil].       "mhmh - empty"

    (chunk startsWith:'''---') ifTrue:[
        words := chunk asCollectionOfWords.
        words size > 2 ifTrue:[
            (words at:2) = 'checkin' ifTrue:[
                name := words at:3.
                ^ name
            ]
        ].
    ].

    "/ fix it - otherwise, it cannot be parsed
    ((chunk endsWith:'primitiveDefinitions:')
    or:[(chunk endsWith:'primitiveFunctions:')
    or:[(chunk endsWith:'primitiveVariables:')]]) ifTrue:[
        chunk := chunk , ''''''
    ].

    "
     use parser to construct a parseTree
    "
    oldDollarSetting := Parser allowDollarInIdentifier.
    [
        Parser allowDollarInIdentifier:true.
"/        Class nameSpaceQuerySignal answer:(self nameSpaceForApply)
"/        do:[
            aParseTree := self parseExpression:chunk.
"/        ].

        aParseTree == #Error ifTrue:[
            (chunk includesString:'comment') ifTrue:[
                "/ could be a comment ...
                aParseTree := self parseExpression:chunk , ''''.
            ]
        ].
    ] ensure:[
        Parser allowDollarInIdentifier:oldDollarSetting
    ].
    (aParseTree isNil or:[aParseTree == #Error]) ifTrue:[
        ^ nil        "seems strange ... (could be a comment)"
    ].
    aParseTree isMessage ifFalse:[
        ^ nil        "very strange ... (whats that ?)"
    ].

    "
     ask parser for selector
    "
    sel := aParseTree selector.

    "
     is it a method-change, methodRemove or comment-change ?
    "
    (#(#'methodsFor:'
       #'privateMethodsFor:'
       #'protectedMethodsFor:'
       #'ignoredMethodsFor:'
       #'publicMethodsFor:'
       #'removeSelector:'
       #'comment:'
       #'primitiveDefinitions:'
       #'primitiveFunctions:'
       #'primitiveVariables:'
       #'renameCategory:to:'
       #'instanceVariableNames:'

       #'methodsFor:stamp:'          "/ Squeak support
       #'commentStamp:prior:'        "/ Squeak support
       #'addClassVarName:'           "/ Squeak support
       #methodsFor                   "/ Dolphin support
       #categoriesForClass           "/ Dolphin support
       #categoriesFor:               "/ Dolphin support
       #methods                      "/ STV support
    ) includes:sel) ifTrue:[
        "
         yes, the className is the receiver
        "
        ^ self classNameFromReceiverInParseTree:aParseTree
    ].

    "
     is it a change in a class-description ?
    "
    (('subclass:*' match:sel)
    or:[('variable*ubclass:*' match:sel)]) ifTrue:[
        "/ must parse the full changes text, to get
        "/ privacy information.
        ^ self classNameFromClassDefinitionChange:changeNr
    ].

    "
     is it a class remove ?
    "
    (sel == #removeClass:) ifTrue:[
        ^ self classNameFromRemoveClassParseTree:aParseTree
    ].

    "
     is it a method category change ?
    "
    ((sel == #category:)
    or:[sel == #package:
    or:[sel == #privacy:]]) ifTrue:[
        ^ self classNameFromAttributeChangeParseTree:aParseTree
    ].

    sel == #renameClass:to: ifTrue:[
        ^ self classNameFromRenameClassParseTree:aParseTree
    ].

    ^ nil

    "Modified: / 01-05-2016 / 19:29:14 / cg"
!

namespaceOfChange:changeNr
    "return the namespace of a change or nil"

    |className namespace idx|

    className := self classNameOfChange:changeNr.
    className isNil ifTrue:[ ^ nil ].

    idx := className indexOfSubCollection:'::'.
    idx == 0 ifTrue:[ ^ nil ].
    namespace := className copyTo:idx-1.
    ^  namespace
!

numberOfChanges
    ^ changeInfoList size

    "Created: / 03-12-1995 / 18:15:39 / cg"
    "Modified: / 01-05-2016 / 19:24:05 / cg"
!

ownerClassNameOfChange:changeNr
    "return the owner classname of a change
     For a normal class, this is the className;
     for a private class, this is the name of the owning class"

    |name "ns idx" cls|

    name := self classNameOfChange:changeNr.
    name isNil ifTrue:[^ nil].
    cls := Smalltalk at:name asSymbol.
    (cls notNil and:[cls isBehavior]) ifTrue:[
	cls owningClass notNil ifTrue:[
	    ^ cls owningClass name
	].
	^ cls name
    ].

"/    (name includes:$:) ifTrue:[
"/        idx := name indexOf:$:.
"/        ns := name copyTo:idx-1.
"/        ns := Smalltalk at:ns asSymbol.
"/        ns notNil ifTrue:[
"/
"/        ].
"/
"/        name := name copyFrom:idx+2.
"/        (Smalltalk at:ns asSymbol) notNil ifTrue:[
"/            cls
"/        ].
"/        ^ name copyButLast:6
"/    ].
    ^ name

    "Modified: 6.12.1995 / 17:06:31 / cg"
!

realClassNameOfChange:changeNr
    "return the classname of a change.
     - since parsing ascii methods is slow, keep result cached in
       changeClassNames for the next query"

    |name|

    name := self changeClassNameAt:changeNr.
    name isNil ifTrue:[
        name := self fullClassNameOfChange:changeNr.
        name isNil ifTrue:[
            (changeInfoList at:changeNr) className:#nil.
        ].
    ].
    name == #nil ifTrue:[^ nil].
    ^ name

    "Created: / 05-11-2001 / 18:09:46 / cg"
    "Modified: / 01-05-2016 / 19:24:53 / cg"
!

selectorOfMethodChange:changeNr
    "return a method-changes selector, 
     or nil if it's not a methodChange"

    |sel |

    changeInfoList size >= changeNr ifTrue:[
        sel := (changeInfoList at:changeNr) selector.
        sel notNil ifTrue:[ ^ sel ].
    ].

    sel := self extractSelectorOfMethodChange:changeNr.
    sel notNil ifTrue:[
        (changeInfoList at:changeNr) selector:sel.
    ].
    ^ sel

    "Modified: / 01-05-2016 / 19:26:21 / cg"
!

sourceOfMethodChange:changeNr
    "return a method-changes source code, or nil if its not a methodChange."

    |aStream chunk sawExcla parseTree sourceChunk sel|

    aStream := self streamForChange:changeNr.
    aStream isNil ifTrue:[^ nil].

    (self changeIsFollowupMethodChange:changeNr) ifFalse:[
        sawExcla := aStream peekFor:(aStream class chunkSeparator).
        chunk := aStream nextChunk.
    ] ifTrue:[
        chunk := self changeChunkAt:changeNr.
        sawExcla := true.
    ].

    sawExcla ifTrue:[
        parseTree := self parseExpression:chunk.
        (parseTree notNil
        and:[parseTree ~~ #Error
        and:[parseTree isMessage]]) ifTrue:[
            sel := parseTree selector.
            (#(
               #methodsFor:
               #privateMethodsFor:
               #publicMethodsFor:
               #ignoredMethodsFor:
               #protectedMethodsFor:

               #methodsFor:stamp:             "/ Squeak support
               #commentStamp:prior:           "/ Squeak support
               #methodsFor                    "/ Dolphin support
               #methods                       "/ STV support
              )
            includes:sel) ifTrue:[
                sourceChunk := aStream nextChunk.
            ]
        ].
    ].
    aStream close.
    ^ sourceChunk

    "Created: / 05-09-1996 / 17:11:32 / cg"
    "Modified: / 01-05-2016 / 18:25:53 / cg"
!

streamForChange:changeNr
    "answer a stream for change"

    |aStream encoding|

    (changeNr between:1 and:changeInfoList size) ifFalse:[^ nil].

    aStream := changeFileName asFilename readStreamOrNil.
    aStream isNil ifTrue:[^ nil].

    encodingIfKnown isNil ifTrue:[
        encoding := CharacterEncoder guessEncodingOfStream:aStream.
        encodingIfKnown := encoding ? #none
    ].
    (encodingIfKnown notNil and:[encodingIfKnown ~~ #none]) ifTrue:[
        aStream := EncodedStream stream:aStream encoding:encodingIfKnown.
    ].

    aStream position:((changeInfoList at:changeNr) position)-1.
    ^ aStream

    "Modified: / 01-05-2016 / 19:24:17 / cg"
! !

!ChangesBrowser methodsFor:'private-changeFile access'!

changeFileName:aFileName
    "set the name of the changeFile"

    changeFileName := aFileName.
    encodingIfKnown := nil.
!

checkIfFileHasChanged
    "check if the changeFile has been modified since the last check;
     install a timeout for rechecking after some time."

    |f info |

    Processor removeTimedBlock:checkBlock.
    f := changeFileName asFilename.
    (info := f info) isNil ifTrue:[
        self newLabel:'(unaccessible)'
    ] ifFalse:[
        (info modificationTime) > changeFileTimestamp ifTrue:[
            self newLabel:'(outdated)'.
            autoUpdate value ifTrue:[
                self doUpdate
            ]
        ] ifFalse:[
            self newLabel:''
        ]
    ].
    Processor addTimedBlock:checkBlock afterSeconds:5.

    "Created: 8.9.1995 / 19:30:19 / claus"
    "Modified: 8.9.1995 / 19:38:18 / claus"
    "Modified: 1.11.1996 / 20:22:56 / cg"
!

readChangesFile
    "read the changes file, create a list of header-lines (changeChunks)
     and a list of chunk-positions (changePositions)"

    self readChangesFileInBackground:false.
    self newLabel:''.
!

readChangesFileInBackground:inBackground
    "read the changes file, create a list of header-lines (changeChunks)
     and a list of chunk-positions (changePositions).
     Starting with 2.10.3, the entries are multi-col entries;
     the cols are:
        1   delta (only if comparing)
                '+' -> new method (w.r.t. current state)
                '-' -> removed method (w.r.t. current state)
                '?' -> class does not exist currently
                '=' -> change is the same as current methods source
                '~' -> change is almost the same as current methods source
        2   class/selector
        3   type of change
                doit
                method
                category change
        4   timestamp

     since comparing slows down startup time, it is now disabled by
     default and can be enabled via a toggle."

    |inStream i f askedForEditingClassSource myProcess myPriority myPrioRange|

    editingClassSource := false.
    askedForEditingClassSource := false.

"/    maxLen := 60.

    self newLabel:'updating ...'.

    (self class isXMLFile:changeFileName) ifTrue:[
        ^ self class readXMLChangesFromFile:changeFileName inBackground:inBackground
    ].

    f := changeFileName asFilename.
    f exists ifFalse:[^ self].
    inStream := EncodedStream decodedStreamFor:(f readStream).

    i := f info.
    changeFileSize := i fileSize.
    changeFileTimestamp := i modificationTime.

    self withReadCursorDo:[
        "
         this is a time consuming operation (especially, if reading an
         NFS-mounted directory; therefore lower my priority ...
        "
        inBackground ifTrue:[
            myProcess := Processor activeProcess.
            myPriority := myProcess priority.
            myPrioRange := myProcess priorityRange.
            myProcess priorityRange:(Processor userBackgroundPriority to:Processor activePriority).
        ].

        [
            |reader|

            reader := ChangeFileReader new.
            reader changeFileName:changeFileName.
            reader browser:self.
            reader enforcedNameSpace:enforcedNameSpace.
            reader autoCompare:autoCompare.
            reader autoloadAsRequired:autoloadAsRequired.
            reader tabSpec:tabSpec.
            reader inStream:inStream.
            reader noColoring:(NoColoring == true).
            
            reader readChangesFile.

            editingClassSource := reader thisIsAClassSource.
            changeInfoList := reader changeInfo.

            self showNumberOfChanges.
            anyChanges := false.
        ] ensure:[
            inStream close.
            inBackground ifTrue:[
                myProcess priority:myPriority.
                myProcess priorityRange:myPrioRange.
            ].
        ].
    ].

    self checkIfFileHasChanged

    "Modified: / 27-08-1995 / 23:06:55 / claus"
    "Modified: / 01-05-2016 / 19:13:09 / cg"
!

writeBackChanges
    "write back the changes file. To avoid problems when the disk is full
     or a crash occurs while writing (well, or someone kills us),
     first write the stuff to a new temporary file. If this works ok,
     rename the old change-file to a .bak file and finally rename the
     tempfile back to the change-file.
     That way, if anything happens, either the original file is left unchanged,
     or we have at least a backup of the previous change file."

    |inFilename inStream outStream stamp encoding tempFilename|

    editingClassSource ifTrue:[
        (self confirm:'You are editing a classes sourceFile (not a changeFile) !!\\Are you certain, you want to overwrite it ?' withCRs)
        ifFalse:[
            ^ false
        ]
    ].

    inFilename := changeFileName asFilename.
    [
        inStream := inFilename readStream.
    ] on:FileStream openErrorSignal do:[:ex|
        self warn:'Cannot open old changesFile.'.
        ^ false
    ].
    [
        [
            outStream := FileStream newTemporaryIn:inFilename directory.
            tempFilename := outStream fileName.
        ] on:FileStream openErrorSignal do:[:ex|
            self warn:'Cannot create temp file in current directory.'.
            ^ false
        ].

        outStream nextPutLine:'''---- encoding: utf8 ----''!!'.
        outStream := EncodedStream stream:outStream encoder:(CharacterEncoder encoderForUTF8).

        encoding := CharacterEncoder guessEncodingOfStream:inStream.
        encoding notNil ifTrue:[
            inStream := EncodedStream stream:inStream encoding:encoding.
        ].

        self withWriteCursorDo:[
            |excla sawExcla done first chunk
             nChanges "{Class:SmallInteger}" |

            Stream writeErrorSignal handle:[:ex |
                self warn:('Could not update the changes file.\\' , ex description) withCRs.
                outStream close.
                tempFilename remove.
                ^ false
            ] do:[
                excla := inStream class chunkSeparator.
                nChanges := self numberOfChanges.

                1 to:nChanges do:[:index |
                    inStream position:((changeInfoList at:index) position)-1.
                    sawExcla := inStream peekFor:excla.
                    chunk := inStream nextChunk.

                    (chunk notNil
                    and:[(chunk startsWith:'''---- snap') not]) ifTrue:[
                        (stamp := (changeInfoList at:index) timestamp) notNil ifTrue:[
                            outStream nextPutAll:'''---- timestamp ' , stamp , ' ----'''.
                            outStream nextPut:excla; cr.
                        ].
                    ].

                    sawExcla ifTrue:[
                        outStream nextPut:excla.
                        outStream nextChunkPut:chunk.
                        outStream cr; cr.
                        "
                         a method-definition chunk - output followups
                        "
                        done := false.
                        first := true.
                        [done] whileFalse:[
                            chunk := inStream nextChunk.
                            chunk isNil ifTrue:[
                                outStream cr; cr.
                                done := true
                            ] ifFalse:[
                                chunk isEmpty ifTrue:[
                                    outStream space; nextChunkPut:chunk; cr; cr.
                                    done := true.
                                ] ifFalse:[
                                    first ifFalse:[
                                        outStream cr; cr.
                                    ].
                                    outStream nextChunkPut:chunk.
                                ].
                            ].
                            first := false.
                        ].
                    ] ifFalse:[
                        outStream nextChunkPut:chunk.
                        outStream cr
                    ]
                ].
                outStream syncData; close.
            ].
            inStream close.

            inFilename renameTo:(inFilename withSuffix:'bak').
            tempFilename renameTo:changeFileName.
            anyChanges := false
        ].
    ] ensure:[
        inStream close.
    ].

    ^ true

    "Modified: / 02-12-1996 / 22:29:15 / stefan"
    "Modified: / 01-05-2016 / 19:30:34 / cg"
! !

!ChangesBrowser methodsFor:'private-user interaction ops'!

appendChange:changeNr toFile:aFileNameOrFileNameString
    "append change to a file. return true if ok."

    |fileName changeInStream outStream chunk chunk2 sawExcla separator encoding|

    changeInStream := self streamForChange:changeNr.
    changeInStream isNil ifTrue:[
        self warn:'Cannot read change'.
        ^ false
    ].
    changeInStream skipSeparators.

    separator := changeInStream class chunkSeparator.

    (self changeIsFollowupMethodChange:changeNr) ifTrue:[
        sawExcla := true.
        chunk := self changeChunkAt:changeNr.
    ] ifFalse:[
        sawExcla := changeInStream peekFor:separator.
        chunk := changeInStream nextChunk.
    ].
    chunk withoutSeparators isEmpty ifTrue:[
        self error:'Empty chunk - should not happen' mayProceed:true.
        ^ false.
    ].

    fileName := aFileNameOrFileNameString asFilename.

    [
        outStream := fileName readWriteStream.
    ] on:FileStream openErrorSignal do:[:ex|
        self warn:'Cannot update file: ''%1''' with:fileName.
        ^ false
    ].

    outStream fileSize = 0 ifTrue:[
        encoding := #utf8.
        outStream nextPutLine:'"{ Encoding: utf8 }" !!'.
    ] ifFalse:[
        encoding := CharacterEncoder guessEncodingOfStream:outStream.
    ].

    encoding notNil ifTrue:[
        outStream := EncodedStream stream:outStream encoding:encoding.
    ].
    outStream setToEnd.

    sawExcla ifTrue:[
        outStream nextPut:separator
    ].
    outStream nextChunkPut:chunk; cr.
    sawExcla ifTrue:[
        chunk2 := changeInStream nextChunk.
        chunk2 withoutSeparators isEmpty ifTrue:[
            self error:'Empty chunk - should not happen'.
        ].
        outStream nextChunkPut:chunk2; space
    ].
    sawExcla ifTrue:[
        outStream nextPut:separator
    ].
    outStream cr.

    changeInStream close.
    outStream close.
    ^ true

    "Modified: / 01-05-2016 / 18:25:00 / cg"
!

applyChange:changeNr
    "fileIn a change.
     Answer true, if everything went ok."

    |aStream applyAction nameSpace className changeClass ownerName ownerClass reader doItChunk methodsForChunk pkg
     alternativeClass shortName orgClassName nsClass aborted|

    aStream := self streamForChange:changeNr.
    aStream isNil ifTrue:[^ false].

    className := self classNameOfChange:changeNr.
    className notNil ifTrue:[
        className := className asSymbol.
        enforcedNameSpace notNil ifTrue:[
            changeClass := enforcedNameSpace at:className ifAbsent:nil.
        ] ifFalse:[
            changeClass := Smalltalk at:className ifAbsent:nil.
        ].
        changeClass isNil ifTrue:[
            changeClass := self classOfChange:changeNr.
        ].
        changeClass notNil ifTrue:[
            "load unloaded class. Otherwise a class definition change
             will create a class without methods"
            changeClass autoload.
        ].
    ].

    changeNrProcessed := changeNr.
    aborted := false.

    applyAction :=
        [
            AbortOperationRequest handle:[:ex |
                "catch the abort of a single apply here.
                 Send AbortAllOperationRequest to abort multiple operations"
                aborted := true.
                ex return.
            ] do:[
                nameSpace := self nameSpaceForApply.

                pkg := enforcedPackage ? Class packageQuerySignal query.
                Class packageQuerySignal answer:pkg
                do:[
                    Class nameSpaceQuerySignal answer:nameSpace
                    do:[
                        Class defaultApplicationQuerySignal handle:[:ex |
                            ex proceedWith:defaultApplicationForVAGEClasses
                        ] do:[
                            Class changeDefaultApplicationNotificationSignal handle:[:ex |
                                defaultApplicationForVAGEClasses := ex parameter.    
                            ] do:[

                                "/ a followup methodsFor: chunk ...
                                (self changeIsFollowupMethodChange:changeNr) ifTrue:[
                                    methodsForChunk := self changeChunkAt:changeNr.
                                ] ifFalse:[
                                    doItChunk := aStream nextChunk.   "/ an empty chunk sometimes ...
                                    doItChunk notEmpty ifTrue:[
                                        doItChunk first = (Character value:16rFEFF) ifTrue:[
                                            doItChunk := doItChunk copyFrom:2.
                                        ].
                                        Compiler evaluate:doItChunk notifying:self.
                                    ] ifFalse:[
                                        methodsForChunk := aStream nextChunk.   "/ the real one
                                    ]
                                ].
                                methodsForChunk notNil ifTrue:[
                                    changeClass isNil ifTrue:[
                                        orgClassName := className.

                                        (className includes:$:) ifTrue:[
                                            ownerName := className copyTo:(className lastIndexOf:$:) - 1.
                                            (ownerName endsWith:$:) ifTrue:[
                                                ownerName := ownerName copyButLast:1.
                                            ].

                                            ownerClass := Smalltalk at:(ownerName asSymbol) ifAbsent:[].
                                            ownerClass notNil ifTrue:[
                                                ownerClass autoload
                                            ].
                                        ].
                                        (nameSpace notNil and:[nameSpace ~~ Smalltalk]) ifTrue:[
                                            changeClass := nameSpace at:className ifAbsent:[].
                                        ].
                                        changeClass isNil ifTrue:[
                                            changeClass := Smalltalk at:className ifAbsent:[].
                                        ].
                                        [changeClass isNil] whileTrue:[
                                            (NameSpace allNameSpaces
                                                contains:[:ns | (nsClass := (ns at:className asSymbol)) notNil])
                                            ifTrue:[
                                                shortName := nsClass name.
                                            ] ifFalse:[
                                                shortName := className copyFrom:(className lastIndexOf:$:) + 1.
                                                shortName = className ifTrue:[
                                                     shortName := ''
                                                ].
                                            ].
                                            className := Dialog
                                                            request:'No class ''' , className , ''' for change. Add to which class? (enter empty string to skip this change)'
                                                            initialAnswer:shortName.

                                            className isNil ifTrue:[
                                                AbortAllOperationRequest raise.
                                            ].
                                            className isEmpty ifTrue:[
                                                ^ false
                                            ].
                                            alternativeClass := Smalltalk classNamed:className.
                                            alternativeClass notNil ifTrue:[
                                                changeClass := alternativeClass
                                            ]
                                        ].
                                        methodsForChunk := methodsForChunk copyFrom:(methodsForChunk indexOfSeparator).
                                        methodsForChunk := changeClass name , methodsForChunk.
                                    ].
                                    reader := Compiler evaluate:methodsForChunk notifying:self.
                                    reader fileInFrom:aStream notifying:self passChunk:false single:true.
                                ]
                            ]
                        ]
                    ]
                ]
            ].
            changeNrProcessed := nil.
        ].

    "/
    "/ if I am showing the changes file, don't update it
    "/
    changeFileName = ObjectMemory nameForChanges ifTrue:[
        Class withoutUpdatingChangesDo:[
            Class updateChangeListQuerySignal answer:updateChangeSet value do:applyAction
        ]
    ] ifFalse:[
        applyAction value
    ].
    aStream close.

    ^ aborted not

    "Modified: / 01-05-2016 / 18:25:18 / cg"
!

compareCategoryChange:parseTree
    |receiverExpression method thisClass|

    receiverExpression := parseTree receiver.
    receiverExpression isMessage ifTrue:[
        receiverExpression selector == #compiledMethodAt: ifTrue:[
            [
                thisClass := receiverExpression receiver evaluate.
            ] on:Parser undefinedVariableError do:[:ex| ].

            (thisClass isBehavior
             and:[(method := receiverExpression evaluate) isMethod]) ifTrue:[
                method category = parseTree arg1 evaluate ifTrue:[
                    ^ true -> 'Change has no effect\\(same category)'.
                ] ifFalse:[
                    ^ false -> ('Category is different (''' , method category , ''' vs. ''' , parseTree arg1 evaluate , ''')').
                ]
            ] ifFalse:[
                ^ nil -> 'There is no such method'.
            ]
        ]
    ].
    ^ nil -> 'Unhandled receiver'
!

compareChange:changeNr
    "compare a change with the current (in-image) version; show the result of the compare (as dialog)"

    ^ self compareChange:changeNr showResult:true
!

compareChange:changeNr showResult:doShowResult
    "compare a change with current version.
     Return the result of the compare (same -> true, different -> false, uncomparable -> nil).
     If doShowResult is true, the outcome is shown in a dialog/diffViewer."

    |aStream chunk sawExcla parseTree thisClass cat oldSource newSource outcome showDiff d selector isLoaded beep superClass thisClassSym varsHere varsInChange addedVars removedVars
     isSame ownerClass superClassHere superClassInChange sameAndOutcome|

    aStream := self streamForChange:changeNr.
    aStream isNil ifTrue:[^ nil].

    showDiff := false.

    (self changeIsFollowupMethodChange:changeNr) ifFalse:[
        sawExcla := aStream peekFor:(aStream class chunkSeparator).
        chunk := aStream nextChunk.
    ] ifTrue:[
        chunk := self changeChunkAt:changeNr.
        sawExcla := true.
    ].

    isSame := nil.

    beep := false.
    sawExcla ifFalse:[
        outcome := 'cannot compare this change\\(i.e. this is not a method change).'.

        Class nameSpaceQuerySignal answer:(self nameSpaceForApply)
        do:[
            parseTree := self parseExpression:chunk.
        ].
        (parseTree notNil and:[parseTree ~~ #Error and:[ parseTree isMessage ]]) ifTrue:[
            selector := parseTree selector.

            selector == #'removeSelector:' ifTrue:[
                sameAndOutcome := self compareRemoveSelectorChange:parseTree.
                isSame := sameAndOutcome key.
                outcome := sameAndOutcome value.
            ].
            selector == #'package:' ifTrue:[
                sameAndOutcome := self comparePackageChange:parseTree.
                isSame := sameAndOutcome key.
                outcome := sameAndOutcome value.
            ].
            selector == #'category:' ifTrue:[
                sameAndOutcome := self compareCategoryChange:parseTree.
                isSame := sameAndOutcome key.
                outcome := sameAndOutcome value.
            ].
            selector == #'comment:' ifTrue:[
                sameAndOutcome := self compareCommentChange:parseTree.
                isSame := sameAndOutcome key.
                outcome := sameAndOutcome value.
            ].

            selector == #'instanceVariableNames:' ifTrue:[
                sameAndOutcome := self compareInstanceVariableNamesChange:parseTree.
                isSame := sameAndOutcome key.
                outcome := sameAndOutcome value.
            ].

            (Class definitionSelectors includes:selector)
            "/ selector == #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
            ifTrue:[
                [
                    superClass := parseTree receiver evaluate.
                ] on:Parser undefinedVariableError do:[:ex| ].
                superClass isBehavior ifFalse:[
                    outcome := 'Cannot compare this change\\(superclass not loaded).'.
                    isSame := nil.
                ] ifTrue:[
                    (self checkClassIsLoaded:superClass) ifTrue:[
                        thisClassSym := (parseTree arguments at:1) evaluate.

                        (selector endsWith:':privateIn:') ifTrue:[
                            Parser undefinedVariableError catch:[
                                ownerClass := (parseTree arguments at:5) evaluate.
                                ownerClass isBehavior ifTrue:[
                                    thisClass := ownerClass privateClassesAt:thisClassSym.
                                ].
                            ].
                        ] ifFalse:[
                            thisClass := (self nameSpaceForApply) at:thisClassSym ifAbsent:nil.
                        ].
                        thisClass isNil ifTrue:[
                            outcome := 'Change defines the class: ' , thisClassSym allBold.
                            isSame := false.
                        ] ifFalse:[
                            (isLoaded := self checkClassIsLoaded:thisClass) ifFalse:[
                                outcome := 'Cannot compare this change\\(compare requires class to be loaded).'.
                                isSame := nil.
                            ] ifTrue:[
                                superClassHere := thisClass superclass name.
                                superClassInChange := parseTree receiver name.
                                superClassHere ~~ superClassInChange ifTrue:[
                                    outcome := 'Superclass is different.'.
                                    isSame := false.
                                ] ifFalse:[
                                    varsHere := thisClass instanceVariableString asCollectionOfWords.
                                    varsInChange := (parseTree arguments at:2) evaluate asCollectionOfWords.
                                    varsHere = varsInChange ifTrue:[
                                        thisClass classVariableString asCollectionOfWords = (parseTree arguments at:3) evaluate asCollectionOfWords ifTrue:[
                                            ((thisClass sharedPoolNames size == 0) and:[(parseTree arguments at:4) evaluate = '']) ifTrue:[
                                                ((selector endsWith:':category:')
                                                and:[thisClass category ~= (parseTree arguments at:5) evaluate]) ifTrue:[
                                                    outcome := 'Category is different'.
                                                    isSame := false.
                                                ] ifFalse:[
                                                    outcome := 'Change has no effect\\(same definition)'.
                                                    isSame := true.
                                                ]
    "/                                            thisClass category = (parseTree arguments at:5) evaluate ifTrue:[
    "/                                                outcome := 'Change has no effect\\(same definition)'.
    "/                                                isSame := true.
    "/                                            ] ifFalse:[
    "/                                                outcome := 'Category is different'.
    "/                                                isSame := false.
    "/                                            ]
                                            ] ifFalse:[
                                                outcome := 'SharedPool definition is different'.
                                                isSame := false.
                                            ].
                                        ] ifFalse:[
                                            outcome := 'ClassVariable definition is different'.
                                            isSame := false.
                                        ]
                                    ] ifFalse:[
                                        outcome := 'InstanceVariable definition is different'.
                                        isSame := false.
                                        addedVars := varsInChange reject:[:eachVar | (varsHere includes:eachVar)].
                                        removedVars := varsHere reject:[:eachVar | (varsInChange includes:eachVar)].
                                        addedVars isEmpty ifTrue:[
                                            removedVars isEmpty ifTrue:[
                                                outcome := 'Change reorders instanceVariable(s)'.
                                            ] ifFalse:[
                                                removedVars := removedVars collect:[:eachVar | '''' , eachVar , ''''].
                                                outcome := 'Change removes instanceVariable(s): ' , (removedVars asStringWith:Character space) allBold.
                                            ]
                                        ] ifFalse:[
                                            removedVars isEmpty ifTrue:[
                                                addedVars := addedVars collect:[:eachVar | '''' , eachVar , ''''].
                                                outcome := 'Change adds instanceVariable(s): ' , (addedVars asStringWith:Character space) allBold.
                                            ].
                                        ].
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ] ifTrue:[
        Class nameSpaceQuerySignal 
            answer:(self nameSpaceForApply)
            do:[
                parseTree := self parseExpression:chunk.
            ].

        (parseTree notNil
         and:[parseTree ~~ #Error
         and:[parseTree isMessage]]) ifTrue:[
            "/ Squeak support (#methodsFor:***)
            (#(
               #methodsFor:
               #privateMethodsFor:
               #publicMethodsFor:
               #ignoredMethodsFor:
               #protectedMethodsFor:

               #methodsFor:stamp:             "/ Squeak support
               #methodsFor                    "/ Dolphin support
               #methods                       "/ STV support
              )
            includes:parseTree selector) ifTrue:[
                [
                    thisClass := parseTree receiver evaluate.
                ] on:Parser undefinedVariableError do:[:ex|   
                    outcome := 'Cannot compare this change\\(compare requires class to be loaded).'.
                    isSame := nil.
                ].
                thisClass notNil ifTrue:[
                (thisClass isKindOf:UndefinedVariable) ifTrue:[
                    |thisName path|

                    thisName := thisClass name.
                    path := thisName asCollectionOfSubstringsSeparatedByAll:'::'.
                    1 to:path size do:[:length |
                        |ownerName owner|

                        ownerName := (path copyTo:length) asStringCollection asStringWith:'::'.
                        owner := Smalltalk loadedClassNamed:ownerName.
                        (owner notNil and:[owner isBehavior and:[owner isLoaded not]]) ifTrue:[
                            self checkClassIsLoaded:owner.
                        ].
                    ].
                    thisClass := parseTree receiver evaluate.
                ].

                thisClass isBehavior ifTrue:[
                    parseTree selector == #methodsFor ifTrue:[
                        cat := 'Dolphin methods'.
                    ] ifFalse:[
                        parseTree selector == #methods ifTrue:[
                            cat := 'STV methods'.
                        ] ifFalse:[
                            cat := parseTree arg1 evaluate.
                        ].
                    ].
                    newSource := aStream nextChunk.

                    isSame := self 
                                compareMethodSource:newSource 
                                withVersionInClass:thisClass 
                                into:[:outcomeResult :beepResult :oldSourceResult| 
                                    outcome := outcomeResult.
                                    beep := beepResult.
                                    oldSource := oldSourceResult.
                                ].

                    isSame isNil ifTrue:[
                        showDiff := false.
                    ] ifFalse:[
                        showDiff := isSame not.
                    ].

                    doShowResult ifTrue:[
                        (showDiff and:[oldSource notNil and:[newSource notNil]]) ifTrue:[
                            d := DiffCodeView
                                    openOn:oldSource label:(resources string:'Current version (in image)')
                                    and:newSource label:(resources string:'Change version').
                            d label:'method differences'.
                        ]
                    ]
                ] ifFalse:[
                    beep := true.
                    outcome := 'Class does not exist.'.
                    isSame := nil.
                ]
            ]] ifFalse:[
                beep := true.
                outcome := 'Not comparable.'.
                isSame := nil.
            ]
        ] ifFalse:[
            beep := true.
            outcome := 'Not comparable.'.
            isSame := nil.
        ]
    ].
    aStream close.

    doShowResult ifTrue:[
        showDiff ifFalse:[
            outcome := (resources stringWithCRs:outcome).
            beep ifTrue:[
                self warn:outcome.
            ] ifFalse:[
                self information:outcome.
            ]
        ].
    ].
    ^ isSame.

    "Created: / 24-11-1995 / 14:30:46 / cg"
    "Modified: / 01-05-2016 / 18:25:32 / cg"
!

compareCommentChange:parseTree
    |thisClass|

    [
        thisClass := parseTree receiver evaluate.
    ] on:Parser undefinedVariableError do:[:ex| ].

    thisClass isBehavior ifTrue:[
        (self checkClassIsLoaded:thisClass) ifTrue:[
            (thisClass comment = parseTree arg1 evaluate) ifTrue:[
                ^ true -> 'Change has no effect\\(same comment)'.
            ] ifFalse:[
                ^ false -> 'Comment is different'.
            ]
        ] ifFalse:[
            ^ nil -> 'Cannot compare this change (compare requires class to be loaded).'.
        ]
    ].
    ^ nil -> 'Cannot compare this change (class not present)'.
!

compareInstanceVariableNamesChange:parseTree
    |receiverExpression thisClass varsHere varsInChange |

    receiverExpression := parseTree receiver.
    receiverExpression isMessage ifTrue:[
        receiverExpression selector == #class ifTrue:[
            [
                thisClass := receiverExpression evaluate.
            ] on:Parser undefinedVariableError do:[:ex| 
                ^ nil -> 'Class is not loaded'.
            ].

            varsHere := thisClass instanceVariableString asCollectionOfWords.
            varsInChange := (parseTree arguments at:1) evaluate asCollectionOfWords.
            varsHere = varsInChange ifTrue:[
                ^ true -> 'Change has no effect\\(same definition)'.
            ] ifFalse:[
                ^ false -> 'Class-instanceVariable definition is different'.
            ].
        ].
    ].
    ^ nil -> 'Unhandled receiver'
!

compareMethodSource:newSource withVersionInClass:thisClass into:aThreeArgBlock
    "returns true/false/nil if same,different,undecided;
     also provides a message and a beep-boolean via the passed in block"

    |parser sel oldMethod oldSource outcome t1 t2 isLoaded|

    Class nameSpaceQuerySignal answer:(self nameSpaceForApply)
    do:[
        parser := Parser parseMethod:newSource in:thisClass.
    ].
    (parser isNil or:[parser == #Error]) ifTrue:[
        outcome := 'Change is unparsable (parse error).'.
        aThreeArgBlock value:outcome value:true "beep" value:nil.
        ^ nil.
    ].

    sel := parser selector.
    oldMethod := thisClass compiledMethodAt:sel.
    oldMethod isNil ifTrue:[
        (isLoaded := self checkClassIsLoaded:thisClass) ifFalse:[
            outcome := 'Cannot compare this change\\(compare requires class to be loaded).'.
        ] ifTrue:[
            outcome := 'Method does not exist.'.
        ].
        aThreeArgBlock value:outcome value:true "beep" value:nil.
        ^ nil.
    ].

    oldSource := oldMethod source.
    oldSource isNil ifTrue:[
        outcome := 'No source for compare.'.
        aThreeArgBlock value:outcome value:true "beep" value:nil.
        ^ nil.
    ].
    (oldSource = newSource) ifTrue:[
        outcome := 'Same source'.
        aThreeArgBlock value:outcome value:false "beep" value:oldSource.
        ^ true.
    ].

    "/
    "/ compare for tabulator <-> space changes
    "/ before showing diff ...
    "/
    t1 := oldSource asCollectionOfLines collect:[:s | s withTabsExpanded].
    t2 := newSource asCollectionOfLines collect:[:s | s withTabsExpanded].
    t1 = t2 ifTrue:[
        outcome := 'Same source'.
        aThreeArgBlock value:outcome value:false "beep" value:oldSource.
        ^ true.
    ].

    "/
    "/ check if only historyLine diffs
    "/
    (HistoryManager notNil
    and:[HistoryManager isActive]) ifTrue:[
        (HistoryManager withoutHistoryLines:newSource)
        =
        (HistoryManager withoutHistoryLines:oldSource)
        ifTrue:[
            outcome := 'Same source (history only)'.
            aThreeArgBlock value:outcome value:false "beep" value:oldSource.
            ^ true.
        ]
    ].

    outcome := 'Source changed.'.
    aThreeArgBlock value:outcome value:false "beep" value:oldSource.
    ^ false.
!

comparePackageChange:parseTree
    |receiverExpression method thisClass|

    receiverExpression := parseTree receiver.
    receiverExpression isMessage ifTrue:[
        receiverExpression selector == #compiledMethodAt: ifTrue:[
            [
                thisClass := receiverExpression receiver evaluate.
            ] on:Parser undefinedVariableError do:[:ex| ].
            (thisClass isBehavior
             and:[(method := receiverExpression evaluate) isMethod]) ifTrue:[
                method package = parseTree arg1 evaluate ifTrue:[
                    ^ true -> 'Change has no effect\\(same package)'.
                ] ifFalse:[
                    ^ false -> ('Package is different (''<1p>'' vs. ''<2p>'')' expandMacrosWith:method package with:parseTree arg1 evaluate).
                ]
            ] ifFalse:[
                ^ nil -> 'There is no such method'.
            ]
        ]
    ].
    ^ nil -> 'Unhandled receiver'
!

compareRemoveSelectorChange:parseTree
    |thisClass selector|

    [
        thisClass := parseTree receiver evaluate.
    ] on:Parser undefinedVariableError do:[:ex| ].

    thisClass isBehavior ifTrue:[
        (self checkClassIsLoaded:thisClass) ifTrue:[
            selector := (parseTree arg1 evaluate).
            (thisClass includesSelector:selector) ifTrue:[
                ^ false -> ('Change removes the #' , selector , ' method from ' , thisClass name).
            ] ifFalse:[
                ^ true -> ('Change has no effect\\(there is no method for #' , selector , ' in ' , thisClass name , ')').
            ]
        ] ifFalse:[
            ^ nil -> 'Cannot compare this change (compare requires class to be loaded).'.
        ]
    ].
    ^ nil -> 'Cannot compare this change (class not present)'.
!

compressForClass:aClassNameOrNil
    "compress the change-set;
     this replaces multiple method-changes by the last (i.e. the most recent) change.
     If the class argument is nil, compress for all classes.
     otherwise, only changes for that class are compressed."

    self
	compressForClass:aClassNameOrNil selector:nil

    "Modified: / 19.11.2001 / 22:04:12 / cg"
!

compressForClass:aClassNameOrNil selector:selectorToCompressOrNil
    "compress the change-set;
     this replaces multiple method-changes by the last (i.e. the most recent) change.
     If the class argument is nil, compress for all classes.
     otherwise, only changes for that class are compressed."

    |lbl aStream searchIndex anyMore deleteSet index
     str snapshotProto snapshotPrefix snapshotNameIndex|

    changeFileName notNil ifTrue:[
        aStream := changeFileName asFilename readStreamOrNil.
        aStream isNil ifTrue:[^ self].
    ].

    lbl := 'compressing'.
    aClassNameOrNil isNil ifTrue:[
        selectorToCompressOrNil notNil ifTrue:[
            lbl := lbl , ' for ' , selectorToCompressOrNil.
        ]
    ] ifFalse:[
        selectorToCompressOrNil isNil ifTrue:[
            lbl := lbl , ' for ' , aClassNameOrNil.
        ] ifFalse:[
            lbl := lbl , ' for ' , aClassNameOrNil , '>>' , selectorToCompressOrNil.
        ]
    ].
    lbl := lbl , '...'.
    self newLabel:lbl.

    CompressSnapshotInfo == true ifTrue:[
        "
         get a prototype snapshot record (to be independent of
         the actual format ..
        "
        str := WriteStream on:''.
        Class addChangeRecordForSnapshot:'foo' to:str.
        snapshotProto := str contents.
        snapshotPrefix := snapshotProto copyTo:10.
        snapshotNameIndex := snapshotProto findString:'foo'.
    ].

    self withExecuteCursorDo:[
        |numChanges classes selectors types excla sawExcla
         chunk aParseTree parseTreeChunk
         thisClass thisSelector codeChunk codeParser
         compressThis fileName|

        numChanges := self numberOfChanges.
        classes := Array new:numChanges.
        selectors := Array new:numChanges.
        types := Array new:numChanges.

        "starting at the end, get the change class and change selector;
         collect all in classes / selectors"

        aStream notNil ifTrue:[
            excla := aStream class chunkSeparator.
            numChanges to:1 by:-1 do:[:changeNr |
                aStream position:((changeInfoList at:changeNr) position)-1.
                sawExcla := aStream peekFor:excla.
                chunk := aStream nextChunk.
                sawExcla ifTrue:[
                    "optimize a bit if multiple methods for same category arrive"
                    (chunk = parseTreeChunk) ifFalse:[
                        aParseTree := self parseExpression:chunk.
                        parseTreeChunk := chunk
                    ].
                    (aParseTree notNil
                    and:[(aParseTree ~~ #Error)
                    and:[aParseTree isMessage]]) ifTrue:[
                        (#(
                           #methodsFor:
                           #privateMethodsFor:
                           #publicMethodsFor:
                           #ignoredMethodsFor:
                           #protectedMethodsFor:
                           #methodsFor:stamp:             "/ Squeak support
                           #methodsFor                    "/ Dolphin support
                           #methods                       "/ STV support
                          )
                        includes:aParseTree selector) ifTrue:[
                            codeChunk := aStream nextChunk.
                            [
                                thisClass := aParseTree receiver evaluate.
                                codeParser := Parser
                                                  parseMethodSpecification:codeChunk
                                                  in:thisClass
                                                  ignoreErrors:true
                                                  ignoreWarnings:true.
                                (codeParser notNil and:[codeParser ~~ #Error]) ifTrue:[
                                    selectors at:changeNr put:(codeParser selector).
                                    classes at:changeNr put:thisClass.
                                    types at:changeNr put:#methodsFor
                                ]
                            ] on:Parser parseErrorSignal do:[:ex|
                                "ignore chunk"        
                                ex return.
                            ].
                        ]
                    ]
                ] ifFalse:[
                    aParseTree := self parseExpression:chunk.
                    parseTreeChunk := chunk.
                    (aParseTree notNil
                    and:[(aParseTree ~~ #Error)
                    and:[aParseTree isMessage]]) ifTrue:[
                        (aParseTree selector == #removeSelector:) ifTrue:[
                            [
                                thisClass := aParseTree receiver evaluate.
                                selectors at:changeNr put:(aParseTree arg1 value).
                                classes at:changeNr put:thisClass.
                                types at:changeNr put:#removeSelector
                            ] on:Parser parseErrorSignal do:[:ex|
                                "ignore chunk"        
                                ex return.
                            ].
                        ]
                    ] ifFalse:[
                        CompressSnapshotInfo == true ifTrue:[
                            (chunk startsWith:snapshotPrefix) ifTrue:[
                                str := chunk readStream position:snapshotNameIndex-1.
                                fileName := str upTo:(Character space).
                                "
                                 kludge to allow use of match-check below
                                "
                                selectors at:changeNr put:snapshotPrefix.
                                classes at:changeNr put:fileName.
                            ]
                        ]
                    ]
                ].
            ].
            aStream close.
        ] ifFalse:[
            numChanges to:1 by:-1 do:[:changeNr |
                |change|

                classes at:changeNr put:(self classOfChange:changeNr ifAbsent:[:className| nil]).
                selectors at:changeNr put:(self selectorOfMethodChange:changeNr).
            ].
        ].

        "for all changes, look for another class/selector occurrence later
         in the list and, if there is one, add change number to the delete set"

        deleteSet := OrderedCollection new.
        1 to:self numberOfChanges-1 do:[:changeNr |
            thisClass := classes at:changeNr.

            compressThis := false.
            aClassNameOrNil isNil ifTrue:[
                compressThis := true
            ] ifFalse:[
                "/ skipping unloaded/unknown classes
                thisClass isBehavior ifTrue:[
                    compressThis := aClassNameOrNil = thisClass theNonMetaclass name.
                ]
            ].
            compressThis ifTrue:[
                thisSelector := selectors at:changeNr.
                compressThis := (selectorToCompressOrNil isNil or:[thisSelector == selectorToCompressOrNil]).
                compressThis ifTrue:[
                    searchIndex := changeNr.
                    anyMore := true.
                    [anyMore] whileTrue:[
                        searchIndex := classes indexOf:thisClass startingAt:(searchIndex + 1).
                        (searchIndex ~~ 0) ifTrue:[
                            ((selectors at:searchIndex) == thisSelector) ifTrue:[
                                thisClass notNil ifTrue:[
                                    deleteSet add:changeNr.
                                    anyMore := false
                                ]
                            ]
                        ] ifFalse:[
                            anyMore := false
                        ]
                    ].
                ].
            ].
        ].

        "finally delete what has been found"

        (deleteSet size > 0) ifTrue:[
            changeListView setSelection:nil.
            index := deleteSet size.
            [index > 0] whileTrue:[
                self silentDeleteChange:(deleteSet at:index).
                index := index - 1
            ].
            self setChangeList.
            "
             scroll back a bit, if we are left way behind the list
            "
            changeListView firstLineShown > self numberOfChanges ifTrue:[
                changeListView makeLineVisible:self numberOfChanges
            ].
            self clearCodeView
        ]
    ].
    self newLabel:''.

    "Created: / 19-11-2001 / 22:03:42 / cg"
    "Modified: / 01-05-2016 / 19:23:54 / cg"
!

deleteChange:changeNr
    "delete a change"

    self deleteChangesFrom:changeNr to:changeNr
!

deleteChangesFrom:start to:stop
    "delete a range of changes"

    changeListView setSelection:nil.
    stop to:start by:-1 do:[:changeNr |
	self silentDeleteInternalChange:changeNr.
    ].
    changeListView removeFromIndex:start toIndex:stop.

"/    changeListView contentsChanged.
"/    changeListView redrawFromLine:start.

"/    self setChangeList

    "Modified: / 18.5.1998 / 14:22:27 / cg"
!

makeChangeAPatch:changeNr
    "append change to patchfile"

    self appendChange:changeNr toFile:'patches'
!

makeChangePermanent:changeNr
    "rewrite the source file where change changeNr lies"

    self notify:'this is not yet implemented'
!

silentDeleteChange:changeNr
    "delete a change do not update changeListView"

    anyChanges := true.
    changeInfoList removeIndex:changeNr.
"/    changeChunks removeIndex:changeNr.
"/    changePositions size >= changeNr ifTrue:[ changePositions removeIndex:changeNr ].
"/    changeClassNames size >= changeNr ifTrue:[ changeClassNames removeIndex:changeNr ].
"/    changeSelectors size >= changeNr ifTrue:[ changeSelectors removeIndex:changeNr ].
"/    changeHeaderLines size >= changeNr ifTrue:[ changeHeaderLines removeIndex:changeNr ].
"/    changeTimeStamps size >= changeNr ifTrue:[ changeTimeStamps removeIndex:changeNr ].
"/    changeIsFollowupMethodChange size >= changeNr ifTrue:[ changeIsFollowupMethodChange removeIndex:changeNr ].

    "Modified: / 01-05-2016 / 19:20:40 / cg"
!

silentDeleteChangesFor:aClassName from:start to:stop
    "delete changes for a given class in a range.
     Return the number of deleted changes."

    |thisClassName index numDeleted|

    numDeleted := 0.
    index := stop.
    [index >= start] whileTrue:[
	thisClassName := self classNameOfChange:index.
	thisClassName = aClassName ifTrue:[
	    self silentDeleteChange:index.
	    numDeleted := numDeleted + 1.
	].
	index := index - 1
    ].
    ^ numDeleted

!

silentDeleteChangesFor:aClassName selector:selector from:start to:stop
    "delete changes for given class/selector in a range.
     Return the number of deleted changes."

    |thisClassName index numDeleted|

    numDeleted := 0.
    index := stop.
    [index >= start] whileTrue:[
	thisClassName := self classNameOfChange:index.
	thisClassName = aClassName ifTrue:[
	    (self selectorOfMethodChange:index) == selector ifTrue:[
		self silentDeleteChange:index.
		numDeleted := numDeleted + 1.
	    ]
	].
	index := index - 1
    ].
    ^ numDeleted
!

silentDeleteChangesForClassAndPrivateClasses:aClassName from:start to:stop
    "delete changes for a given class and its private classes in a range.
     Return the number of deleted changes."

    |thisClassName index numDeleted|

    numDeleted := 0.
    index := stop.
    [index >= start] whileTrue:[
	thisClassName := self ownerClassNameOfChange:index.
	thisClassName = aClassName ifTrue:[
	    self silentDeleteChange:index.
	    numDeleted := numDeleted + 1.
	].
	index := index - 1
    ].
    ^ numDeleted

!

silentDeleteChangesForNamespace:aNamespace from:start to:stop
    "delete changes for a given namespace in a range.
     Return the number of deleted changes."

    |thisNamespace index numDeleted|

    numDeleted := 0.
    index := stop.
    [index >= start] whileTrue:[
        thisNamespace := self namespaceOfChange:index.
        thisNamespace = aNamespace ifTrue:[
            self silentDeleteChange:index.
            numDeleted := numDeleted + 1.
        ].
        index := index - 1
    ].
    ^ numDeleted
!

silentDeleteInternalChange:changeNr
    "delete a change do not update changeListView"

    anyChanges := true.
    changeInfoList removeIndex:changeNr.
"/    changeChunks removeIndex:changeNr.
"/    changePositions size >= changeNr ifTrue:[changePositions removeIndex:changeNr].
"/    changeClassNames size >= changeNr ifTrue:[changeClassNames removeIndex:changeNr].
"/    changeSelectors size >= changeNr ifTrue:[ changeSelectors removeIndex:changeNr ].
"/    changeTimeStamps size >= changeNr ifTrue:[changeTimeStamps removeIndex:changeNr].
"/    changeIsFollowupMethodChange size >= changeNr ifTrue:[changeIsFollowupMethodChange removeIndex:changeNr].

    "Created: / 07-03-1997 / 16:28:32 / cg"
    "Modified: / 26-02-1998 / 18:20:48 / stefan"
    "Modified: / 01-05-2016 / 19:20:59 / cg"
!

updateDiffView
    self withSelectedChangesDo:[:changeNr |
	self updateDiffViewFor:changeNr.
	^ self.
    ].

    diffView text1:'' text2:''
!

updateDiffViewFor:changeNr
    |aStream chunk sawExcla parseTree thisClass cat oldSource newSource
     parser sel showDiff selector oldMethod i|

    aStream := self streamForChange:changeNr.
    aStream isNil ifTrue:[
        ^ self
    ].

    showDiff := false.

    (self changeIsFollowupMethodChange:changeNr) ifFalse:[
        sawExcla := aStream peekFor:(aStream class chunkSeparator).
        chunk := aStream nextChunk.
    ] ifTrue:[
        chunk := self changeChunkAt:changeNr.
        sawExcla := true.
    ].

    Class nameSpaceQuerySignal answer:(self nameSpaceForApply)
    do:[
        parseTree := self parseExpression:chunk.
        (parseTree notNil and:[parseTree ~~ #Error and:[ parseTree isMessage ]]) ifTrue:[
            selector := parseTree selector.
        ]
    ].

    selector isNil ifTrue:[
        newSource := chunk.
        oldSource := 'Not comparable.'.
    ] ifFalse:[
        sawExcla ifFalse:[
            "/ not a method-change
            newSource := chunk.
            oldSource := self currentSourceForParseTree:parseTree.
        ] ifTrue:[
            "/ a method-change

            (self class methodDefinitionSelectors includes:selector) ifTrue:[
                newSource := aStream nextChunk.
                thisClass := self classFromEvaluatingTree:parseTree receiver. 
"/                Error 
"/                    handle:[ ]
"/                    do:[
"/                        thisClass := parseTree receiver evaluate.
"/                    ].
                thisClass isBehavior ifFalse:[
                    thisClass := self classOfChange:changeNr.
                ].
                thisClass isBehavior ifTrue:[
                    (thisClass isLoaded
                    or:[ autoloadAsRequired value
                         and:[self checkClassIsLoaded:thisClass]]) ifFalse:[
                        oldSource := 'Cannot compare this change\\(compare requires class to be loaded).' withCRs.
                    ] ifTrue:[
                        selector numArgs == 0 ifTrue:[
                            cat := '* as yet uncategorized *'.
                            cat := selector.
                        ] ifFalse:[
                            cat := parseTree arg1 evaluate.
                        ].
                        Class nameSpaceQuerySignal answer:(self nameSpaceForApply)
                        do:[
                            parser := Parser new.
                            Error catch:[
                                parser 
                                    parseMethod:newSource in:thisClass
                                    ignoreErrors:true ignoreWarnings:true.
                            ]
                        ].
                        sel := parser selector.
                        (sel notNil) ifTrue:[
                            oldMethod := thisClass compiledMethodAt:sel.
                            oldMethod notNil ifTrue:[
                                (oldMethod category = cat) ifFalse:[
"/                                    Transcript showCR:'category changed.'.
                                ].
                                oldSource := oldMethod source.
                                (oldSource = newSource) ifFalse:[
                                    oldSource isNil ifTrue:[
                                        oldSource := 'No source for compare.'.
                                    ] ifFalse:[
                                        "/
                                        "/ compare for tabulator <-> space changes
                                        "/ before showing diff ...
                                        "/
                                        oldSource := oldSource asCollectionOfLines collect:[:s | s withTabsExpanded].
                                        newSource := newSource asCollectionOfLines collect:[:s | s withTabsExpanded].
                                        oldSource = newSource ifFalse:[
                                            "/
                                            "/ check if only historyLine diffs
                                            "/
                                            (HistoryManager notNil
                                            and:[HistoryManager isActive]) ifTrue:[
                                                oldSource := oldSource asStringCollection asString.
                                                newSource := newSource asStringCollection asString.
                                                (HistoryManager withoutHistoryLines:oldSource)
                                                =
                                                (HistoryManager withoutHistoryLines:newSource)
                                                ifTrue:[
                                                    oldSource := (HistoryManager withoutHistoryLines:oldSource).
                                                    newSource := (HistoryManager withoutHistoryLines:newSource).
                                                ]
                                            ].
                                        ]
                                    ]
                                ]
                            ] ifFalse:[
                                oldSource := 'Method does not exist.'.
                            ]
                        ] ifFalse:[
                            oldSource := 'Change is unparsable (parse error).'.
                        ].
                    ].
                ] ifFalse:[
                    oldSource := 'Class does not exist.'.
                ]
            ] ifFalse:[
                newSource := chunk. "/ aStream contents.
                oldSource := 'Not comparable.'.
            ]
        ]
    ].
    aStream close.

    oldSource := oldSource ? ''.
    newSource := newSource ? ''.

    oldSource := oldSource asStringCollection asString.
    newSource := newSource asStringCollection asString.

    "/ unify cr, crlf and lf into lf
    (oldSource includes:Character return) ifTrue: [
        i := oldSource indexOf:Character return.
        (oldSource at:i+1) == Character nl ifTrue:[
            "/ crnl endings
            oldSource := oldSource copyReplaceString:(String crlf) withString:(String lf).
        ] ifFalse:[
            "/ cr endings
            oldSource := oldSource copyReplaceAll:Character return with:Character nl.
        ].
    ].

    "/ unify cr, crlf and lf into lf
    (newSource includes:Character return) ifTrue: [
        i := newSource indexOf:Character return.
        (newSource at:i+1) == Character nl ifTrue:[
            "/ crnl endings
            newSource := newSource copyReplaceString:(String crlf) withString:(String lf).
        ] ifFalse:[
            "/ cr endings
            newSource := newSource copyReplaceAll:Character return with:Character nl.
        ].
    ].

    (oldSource = newSource
    or:[ oldSource asStringCollection withTabsExpanded = newSource asStringCollection withTabsExpanded]) ifTrue:[
        self makeDiffViewInvisible
    ] ifFalse:[
        self makeDiffViewVisible.
        diffView text1:oldSource text2:newSource.
    ].

    "Created: / 24-11-1995 / 14:30:46 / cg"
    "Modified: / 01-05-2016 / 18:26:01 / cg"
! !

!ChangesBrowser methodsFor:'termination'!

askIfChangesAreToBeWrittenBack
    |action again|

    anyChanges ifFalse:[^ self].

    again := true.
    [again] whileTrue:[
        action := OptionBox
                          request:(resources stringWithCRs:'The modified changelist has not been written back to the change file.\\Write change file before closing ?')
                          label:'ChangesBrowser'
                          image:(WarningBox iconBitmap)
                          buttonLabels:(resources array:#('Cancel' 'Don''t Write' 'Write'))
                          values:#(#abort #ignore #save)
                          default:#save
                          onCancel:#abort.

        again := false.
        action == #abort ifTrue:[AbortSignal raise. ^ self].
        action  == #save ifTrue:[
            again := self writeBackChanges not
        ].
    ].
!

closeRequest
    "window manager wants us to go away"

    self askIfChangesAreToBeWrittenBack.
    super closeRequest
!

saveAndTerminate
    "update the changes file and quit.
     Don't depend on this being sent, not all window managers
     send it; instead, they simply destroy the view."

    anyChanges ifTrue:[
        self writeBackChanges.
    ].
    super saveAndTerminate

    "Modified: / 3.8.1998 / 19:54:00 / cg"
! !

!ChangesBrowser methodsFor:'user interaction'!

askForSearch:msg initialAnswer:initial thenSearchUsing:searchBlock2 onCancel:cancelBlock
    |searchString directionHolder searchBlock|

    searchString := self
        askForSearchString:msg
        initialAnswer:initial
        directionInto:(directionHolder := ValueHolder new).

    searchString isNil ifTrue:[
        ^ cancelBlock value
    ].
    directionHolder value == #first ifTrue:[
        self findFirstForClass:searchString.
        ^ self.
    ].    
    directionHolder value == #last ifTrue:[
        self findLastForClass:searchString.
        ^ self.
    ].    
    
    searchBlock := [:changeNr | searchBlock2 value:searchString value:changeNr].

    directionHolder value == #backward ifTrue:[
        changeNrShown isNil ifTrue:[
            changeNrShown := self numberOfChanges.
        ].
        self findPreviousForWhich:searchBlock
    ] ifFalse:[
        changeNrShown isNil ifTrue:[
            changeNrShown := 0.
        ].
        self findNextForWhich:searchBlock
    ].
!

askForSearchString:msg initialAnswer:initial directionInto:aValueHolder
    "common code to open a search box"

    |searchString direction|

    direction := #forward.

    "/ take a normal request box, but add an additional 'previous' button
    Dialog modifyingBoxWith:[:box |
        |nextButton prevButton firstButton lastButton|

        nextButton := box okButton.

        firstButton := Button label:(resources string:'First').
        firstButton action:[direction := #first. box okPressed.].
        box addButton:firstButton after:nextButton.
        
        lastButton := Button label:(resources string:'Last').
        lastButton action:[direction := #last. box okPressed.].
        box addButton:lastButton after:nextButton.

        prevButton := Button label:(resources string:'Previous').
        prevButton action:[direction := #backward. box okPressed.].
        box addButton:prevButton after:nextButton.

        nextButton label:(resources string:'Next').
    ] do:[
        searchString := Dialog
                request:msg
                initialAnswer:initial
                onCancel:nil.
    ].

    searchString isNil ifTrue:[
        ^ nil
    ].
    aValueHolder value:direction.
    ^ searchString

    "
     self new askForSearchString:'foo' initialAnswer:'bla' directionInto:(false asValue)
    "
!

autoUpdate:aBoolean
    "enabled/disable automatic update from the change-file (for monitoring)"

    autoUpdate value:aBoolean

    "Created: 3.12.1995 / 14:14:24 / cg"
    "Modified: 3.12.1995 / 14:20:45 / cg"
!

autoloadAsRequired:aBoolean
    "enabled/disable automatic load of unloaded classes"

    autoloadAsRequired value:aBoolean
!

changeSelection:lineNrCollection
    "show a change in the codeView"

    |chunk lineNr lineNumbers|

    lineNrCollection isInteger ifTrue:[
        lineNr := lineNrCollection.
        lineNumbers := Array with:lineNr.
    ] ifFalse:[
        changeListView multipleSelectOk ifTrue:[
            lineNrCollection size == 1 ifTrue:[
                lineNr := lineNrCollection first.
            ]
        ] ifFalse:[
            lineNr := lineNrCollection
        ].
        lineNumbers := lineNrCollection.
    ].

    self changeListSelectionHolder value:lineNumbers.
    
    lineNr isNil ifTrue:[
        codeView contents:nil.
        codeView initializeDoITAction.
        changeNrShown := nil.
        infoHolder value:nil.
        ^ self
    ].

    changeNrShown := lineNr.
    self sensor
        enqueueMessage:#updateSourceCodeAfterChangedSelection for:self arguments:nil;
        enqueueMessage:#updateInfoAfterChangedSelection for:self arguments:nil.
^ self.

    "/ display the changes code
    chunk := self sourceOfChange:lineNr.
    chunk isNil ifTrue:[
        codeView initializeDoITAction.
        ^ self
    ].

    codeView contents:chunk.
    codeView acceptAction:[:theCode | self doApply "noChangesAllowed"].
    codeView doItAction:[:theCode |
        |clsName cls|

        clsName := self classNameOfChange:lineNr.
        clsName notNil ifTrue:[
            clsName := clsName asSymbolIfInterned.
            clsName notNil ifTrue:[
                cls := Smalltalk at:clsName ifAbsent:nil.
            ]
        ].
        Compiler
            evaluate:theCode
            in:nil
            receiver:cls
            notifying:self
            logged:true
            ifFail:nil
    ].
    changeNrShown := lineNr.

    self showingDiffs value ifTrue:[
        self withWaitCursorDo:[
            AbortOperationRequest catch:[
                self updateDiffViewFor:changeNrShown.
            ]
        ]
    ].

    "Modified: / 03-01-2012 / 15:30:23 / cg"
!

classOfChange:changeNr
    ^ self
        classOfChange:changeNr
        ifAbsent:[:className |
            |msg|

            className isNil ifTrue:[
                msg := 'Could not extract classname from change'.
            ] ifFalse:[
                msg := 'Class not found: ''' , className , ''''.
            ].
            Transcript showCR:msg.
"/            self warn:msg.
            nil
        ]
!

classOfChange:changeNr ifAbsent:exceptionBlock
    "answer the class that is subject to the chamge at changeNr.
     The classes owning class may be autoloaded, if autoloadAsRequired is true."

    |className cls isMeta nameSpaceForApply path ownerName owner|

    className := self realClassNameOfChange:changeNr.
    className isNil ifTrue:[
        ^ exceptionBlock value:nil
    ].

    isMeta := false.
    (className endsWith:' class') ifTrue:[
        className := className copyButLast:6.
        isMeta := true.
    ].

    autoloadAsRequired value ifTrue:[        
        path := className asCollectionOfSubstringsSeparatedByAll:'::'.
        path size >= 2 ifTrue:[
            1 to:path size-1 do:[:l |
                "/ ensure that the owningClass is loaded - this will load the private classes as well
                "/ Transcript showCR:'loading owner'.
                ownerName := (path copyTo:l) asStringCollection asStringWith:'::'.
                owner := Smalltalk classNamed:ownerName.
                owner notNil ifTrue:[
                    owner autoload.
                ].
            ].
        ].
    ].

    nameSpaceForApply := self nameSpaceForApply.
    autoloadAsRequired value ifTrue:[        
        cls := nameSpaceForApply classNamed:className.
    ] ifFalse:[
        cls := nameSpaceForApply loadedClassNamed:className
    ].
    (cls isNil and:[nameSpaceForApply ~~ Smalltalk]) ifTrue:[
        "if not found in special name space, fall back to the Smalltalk name space"
        autoloadAsRequired value ifTrue:[        
            cls := Smalltalk classNamed:className.
        ] ifFalse:[
            cls := Smalltalk loadedClassNamed:className
        ].
    ].

    cls isNil ifTrue:[
        ^ exceptionBlock value:className
    ].
    isMeta ifTrue:[
        cls := cls class
    ].
    ^ cls
!

doubleClickOnChange:lineNr
    "action performed when a change-list entry is doubleClicked"

    self doBrowse

    "Created: / 6.2.1998 / 13:08:49 / cg"
!

noChangesAllowed
    "show a warning that changes cannot be changed"

    self warn:'Changes are not allowed to be changed.'
!

saveClass:aClassName from:startNr
    "user wants changes from current to end to be appended to a file"

    |changeNr fileName|

    changeNr := changeListView selection.
    changeNr notNil ifTrue:[
        fileName := Dialog
                        requestFileNameForSave:(resources string:'Append changes for class to:')
                        default:(lastSaveFileName ? '')
                        ok:(resources string:'Append')
                        abort:(resources string:'Abort')
                        pattern:'*.chg'.

        fileName notNil ifTrue:[
            lastSaveFileName := fileName.
            self withWriteCursorDo:[
                startNr to:(self numberOfChanges) do:[:changeNr |
                    |thisClassName|

                    thisClassName := self classNameOfChange:changeNr.
                    thisClassName = aClassName ifTrue:[
                        self setSingleSelection:changeNr.
                        (self appendChange:changeNr toFile:fileName) ifFalse:[
                            ^ self
                        ]
                    ]
                ]
            ]
        ].
    ]

    "Modified: / 27-07-2012 / 09:46:04 / cg"
!

selectionChanged
    self halt:'should not be here'

    "Created: / 03-01-2012 / 15:26:36 / cg"
!

updateInfoAfterChangedSelection
    "update the info label"

    |selection lineNr selectorOrNil className nonMetaClassName metaClassName
     nClassChanges nMethodChanges uniqueSelectors
     lastLineNr firstLineNr 
     countForClassBeforeCurrent countForClassAfterLast countForClassAndSelectorAfterLast 
     moreInfo|

    selection := lineNr := changeListView selection.
    selection isNumber ifFalse:[
        lineNr := nil.
        selection notEmptyOrNil ifTrue:[
            lineNr := selection first
        ].
    ].

    lineNr isNil ifTrue:[
        infoHolder value:nil.
        ^ self
    ].

    "/
    "/ now, this info is computed so fast,
    "/ we can do it each time the selection changes
    "/ (can we?)
    className := self realClassNameOfChange:lineNr.
    className isNil ifTrue:[
        infoHolder value:nil.
        ^ self
    ].
    selectorOrNil := self selectorOfMethodChange:lineNr.
    
    nonMetaClassName := (className endsWith:' class')
                            ifTrue:[ className copyButLast:' class' size ]
                            ifFalse:[ className ].
    metaClassName := nonMetaClassName,' class'.
                            
    nClassChanges := nMethodChanges := 0.
    uniqueSelectors := Set new.
    lastLineNr := firstLineNr := nil.
    countForClassAfterLast := 0.
    countForClassBeforeCurrent := 0.
    countForClassAndSelectorAfterLast := 0.
    
    "/ count them all
    1 to:changeInfoList size do:[:i |
        |sel nameOfChange|
        
        nameOfChange := self realClassNameOfChange:i.
        ((nameOfChange = nonMetaClassName) or:[nameOfChange = metaClassName]) ifTrue:[
            sel := self selectorOfMethodChange:i.
            
            lastLineNr := i.
            firstLineNr := firstLineNr ? i.
            i > lineNr ifTrue:[ 
                countForClassAfterLast := countForClassAfterLast + 1.
                (nameOfChange = className 
                  and:[ selectorOrNil notNil 
                  and:[sel == selectorOrNil]]) ifTrue:[
                    countForClassAndSelectorAfterLast := countForClassAndSelectorAfterLast + 1.
                ].    
            ] ifFalse:[
                i < lineNr ifTrue:[
                    countForClassBeforeCurrent := countForClassBeforeCurrent + 1
                ]
            ].    
            nClassChanges := nClassChanges + 1.
            sel notNil ifTrue:[
                uniqueSelectors add:sel.
                nMethodChanges := nMethodChanges + 1.
            ].
        ].    
    ].
    lastLineNr == lineNr ifTrue:[
        firstLineNr == lineNr ifTrue:[
            moreInfo := resources string:'. This is the only one for this class '.
        ] ifFalse:[    
            moreInfo := resources string:'. This is the last for this class '.
        ]
    ] ifFalse:[
        firstLineNr == lineNr ifTrue:[
            moreInfo := resources string:'. This is the first for this class'.
        ].    
        countForClassAfterLast > 0 ifTrue:[
            moreInfo := (moreInfo ? ''),(resources string:'. %1 more for this class' with:countForClassAfterLast).
            countForClassAndSelectorAfterLast > 0 ifTrue:[
                moreInfo := moreInfo,(resources string:'. %1 more for method' with:countForClassAndSelectorAfterLast).
            ].    
        ].    
    ].
    
    infoHolder value:(resources 
                        string:'%1 changes. %2 for %3 (%4 methods / %5 selectors)%6'
                        with:(changeInfoList size)
                        with:nClassChanges
                        with:className
                        with:nMethodChanges
                        with:uniqueSelectors size
                        with:moreInfo).
!

updateSourceCodeAfterChangedSelection
    "show a change in the codeView"

    |selection lineNr chunk|

    selection := lineNr := changeListView selection.
    selection isNumber ifFalse:[
        lineNr := nil.
        selection notEmptyOrNil ifTrue:[
            lineNr := selection first
        ].
    ].

    lineNr isNil ifTrue:[
        ^ self
    ].

    "/ display the changes code
    chunk := self sourceOfChange:lineNr.
    chunk isNil ifTrue:[
        codeView initializeDoITAction.
        ^ self
    ].

    codeView contents:chunk.
    codeView acceptAction:[:theCode | self doApply "noChangesAllowed"].
    codeView doItAction:[:theCode |
        |clsName cls|

        clsName := self classNameOfChange:lineNr.
        clsName notNil ifTrue:[
            clsName := clsName asSymbolIfInterned.
            clsName notNil ifTrue:[
                cls := Smalltalk at:clsName ifAbsent:nil.
            ]
        ].
        Compiler
            evaluate:theCode
            in:nil
            receiver:cls
            notifying:self
            logged:true
            ifFail:nil
    ].


    changeNrShown := lineNr.

    self showingDiffs value ifTrue:[
        self withWaitCursorDo:[
            AbortOperationRequest catch:[
                self updateDiffViewFor:changeNrShown.
            ]
        ]
    ].
! !

!ChangesBrowser::ChangeFileReader methodsFor:'accessing'!

autoCompare:something
    autoCompare := something.
!

autoloadAsRequired
    ^ autoloadAsRequired
!

autoloadAsRequired:something
    autoloadAsRequired := something.
!

browser:something
    browser := something.
!

changeChunks
self halt.
    ^ changeChunks

    "Modified: / 01-05-2016 / 19:10:52 / cg"
!

changeClassNames
self halt.
    ^ changeClassNames

    "Modified: / 01-05-2016 / 19:10:47 / cg"
!

changeFileName
    ^ changeFileName
!

changeFileName:something
    changeFileName := something.
!

changeHeaderLines
self halt.
   ^ changeHeaderLines

    "Modified: / 01-05-2016 / 19:10:41 / cg"
!

changeInfo
    ^ changeInfo

    "Created: / 01-05-2016 / 19:10:05 / cg"
!

changeIsFollowupMethodChange
self halt.
    ^ changeIsFollowupMethodChange

    "Modified: / 01-05-2016 / 19:10:24 / cg"
!

changePositions
self halt.
    ^ changePositions

    "Modified: / 01-05-2016 / 19:10:29 / cg"
!

changeTimeStamps
self halt.
    ^ changeTimeStamps

    "Modified: / 01-05-2016 / 19:10:34 / cg"
!

enforcedNameSpace:something
    enforcedNameSpace := something.
!

inStream:something
    inStream := something.
!

noColoring:something
    noColoring := something.
!

tabSpec:something
    tabSpec := something.
!

thisIsAClassSource
    ^ thisIsAClassSource ? false

    "Modified: / 06-10-2006 / 11:18:49 / cg"
! !

!ChangesBrowser::ChangeFileReader methodsFor:'private'!

contractClass:className selector:selector to:maxLen
    "contract a class>>selector string (for display in the changeList)."

    |s l|

    s := className , ' ', selector.
    s size > maxLen ifTrue:[
        l := maxLen - 1 - selector size max:20.
        s := (className contractTo:l) , ' ' , selector.

        s size > maxLen ifTrue:[
            l := maxLen - 1 - className size max:20.
            s := className , ' ', (selector contractTo:l).

            s size > maxLen ifTrue:[
                s := (className contractTo:(maxLen // 2 - 1)) , ' ' , (selector contractTo:maxLen // 2)
            ]
        ]
    ].
    ^ s
!

extractClassAndClassNameFromParseTree:rec
    |isUnaryMessage className changeClass|

    isUnaryMessage := rec isUnaryMessage.

    Error 
        handle:[:ex | ^ '?' -> nil]
        do:[
            isUnaryMessage ifTrue:[
                className := rec receiver name.
            ] ifFalse:[
                className := rec name.
            ].
        ].

    enforcedNameSpace notNil ifTrue:[
        autoloadAsRequired value ifTrue:[
            changeClass := enforcedNameSpace classNamed:className.
        ] ifFalse:[
            changeClass := enforcedNameSpace loadedClassNamed:className.
        ].
    ].
    changeClass isNil ifTrue:[
        autoloadAsRequired value ifTrue:[
            changeClass := Smalltalk classNamed:className.
        ] ifFalse:[
            changeClass := Smalltalk loadedClassNamed:className.
        ].
    ].
    isUnaryMessage ifTrue:[
        changeClass notNil ifTrue:[
            changeClass := changeClass class.
        ].
        className := className , ' class'.
    ].

    ^ className -> changeClass

    "Modified: / 03-08-2006 / 14:02:31 / cg"
!

nameSpaceForApply
    ^ browser nameSpaceForApply
! !

!ChangesBrowser::ChangeFileReader methodsFor:'reading'!

addHeaderLineForChangeType:changeType changeString:changeString changeDelta:changeDelta timeStampInfo:timeStampInfo
    changeHeaderLines add:(self headerLineForChangeType:changeType changeString:changeString changeDelta:changeDelta timeStampInfo:timeStampInfo)

    "Modified: / 01-05-2016 / 19:07:49 / cg"
!

headerLineForChangeType:changeType changeString:changeString changeDelta:changeDelta timeStampInfo:timeStampInfo
    |entry|

    entry := MultiColListEntry new.
    entry tabulatorSpecification:tabSpec.
    entry colAt:1 put:changeDelta.
    entry colAt:2 put:changeString.
    entry colAt:3 put:changeType.
    timeStampInfo notNil ifTrue:[
        entry colAt:4 put:(browser timeStampPrintStringOf:timeStampInfo).
    ].
    ^ entry

    "Created: / 01-05-2016 / 19:07:20 / cg"
!

processChunk
    |info|

    (chunkText startsWith:'''---- timestamp ') ifTrue:[
        timeStampInfo := (chunkText copyFrom:16 to:(chunkText size - 6)) withoutSpaces.
        ^ self.
    ].
    (chunkText asLowercase startsWith:'''---- encoding: ') ifTrue:[
        ^ self.
    ].

    changeInfo add:(info := 
                        ChangesBrowser::ChangeInfo new 
                            position:chunkPosition chunk:chunkText className:nil selector:nil headerLine:nil
                            timestamp:timeStampInfo isFollowupChange:false).
"/    changeChunks add:chunkText.
"/    changeClassNames add:nil.
"/    changePositions add:chunkPosition.
"/    changeTimeStamps add:timeStampInfo.
"/    changeIsFollowupMethodChange add:false.

    headerLine := nil.
    changeDelta := ' '.

    sawExcla ifFalse:[
        self processNonMethodChunk
    ] ifTrue:[
        self processMethodChunkIfNone:
            [
                changeInfo removeLast.
"/                changeChunks removeLast.
"/                changeClassNames removeLast.
"/                changePositions removeLast.
"/                changeTimeStamps removeLast.
"/                changeIsFollowupMethodChange removeLast.
            ]
    ].

    changeString notNil ifTrue:[
        "/ self addHeaderLineForChangeType:changeType changeString:changeString changeDelta:changeDelta timeStampInfo:timeStampInfo.
        info headerLine:(self headerLineForChangeType:changeType changeString:changeString changeDelta:changeDelta timeStampInfo:timeStampInfo)
    ] ifFalse:[
        headerLine notNil ifTrue:[
            changeHeaderLines add:headerLine
            info headerLine:headerLine.
        ]
    ].

    "Modified: / 01-05-2016 / 19:13:59 / cg"
!

processMethodChunkIfNone:emptyBlock
    "sawExcla"

    |askedForEditingClassSource changeClass category anyMethod
     sel p rec clsName done first text methodPos
     singleJunkOnly methodChunks classCategoryChunks methodCategoryChunks singleInfo methodSelector nameAndClass
     info|

    singleJunkOnly := false.
    methodChunks := false.
    classCategoryChunks := methodCategoryChunks := false.
    singleInfo := false.
    anyMethod := false.

    "
     method definitions actually consist of
     two (or more) chunks; skip next chunk(s)
     up to an empty one.
     The system only writes one chunk,
     and we cannot handle more in this ChangesBrowser ....
    "
    clsName := nil.

(chunkText includesString:'§') ifTrue:[self halt].

    p := browser parseExpression:chunkText inNameSpace:(self nameSpaceForApply).
    (p notNil and:[p ~~ #Error and:[p isMessage]]) ifTrue:[
        rec := p receiver.
        sel := p selector.
        (ChangesBrowser methodDefinitionSelectors includes:sel) ifTrue:[
            methodChunks := true.
            nameAndClass := self extractClassAndClassNameFromParseTree:rec.
            clsName := nameAndClass key. changeClass := nameAndClass value.

            sel == #categoriesForClass ifTrue:[
                methodChunks := false.
                classCategoryChunks := true.
                changeType := '(class category change)'.
            ] ifFalse:[
                sel == #categoriesFor: ifTrue:[
                    methodChunks := false.
                    methodCategoryChunks := true.
                    changeType := '(category change)'.
                    methodSelector := (p args at:1) evaluate.
                ] ifFalse:[
                    (sel numArgs == 0) ifTrue:[
                        category := '* As yet uncategorized *'.
                        category := sel.
                    ] ifFalse:[
                        category := (p args at:1) evaluate.
                    ].
                ].
            ].

            sel == #'methodsFor:stamp:' ifTrue:[
                "/ Squeak timeStamp
                timeStampInfo := (p args at:2) evaluate.
                singleInfo := true
            ] ifFalse:[
                sel == #'commentStamp:prior:' ifTrue:[
                    singleJunkOnly := true.
                    methodChunks := false.
                ]
            ]
        ] ifFalse:[
            sel == #reorganize ifTrue:[
                singleJunkOnly := true.
                methodChunks := false.
            ]
        ].
    ].

    done := false.
    first := true.
    [done] whileFalse:[
        changeDelta := ' '.
        methodPos := inStream position + 1.

        text := inStream nextChunk.
        done := text isEmptyOrNil.

        done ifFalse:[
            anyMethod := true.
            first ifFalse:[
                info := ChangesBrowser::ChangeInfo new 
                            position:methodPos chunk:chunkText className:clsName 
                            selector:nil headerLine:nil timestamp:timeStampInfo isFollowupChange:true. 
                changeInfo add:info.

                askedForEditingClassSource ifFalse:[
                    thisIsAClassSource := (changeFileName asFilename hasSuffix:'st').
                    askedForEditingClassSource := true.
                ]
            ] ifTrue:[
                changeInfo last className:clsName
            ].

            first := false.

            (classCategoryChunks or:[methodCategoryChunks]) ifTrue:[
                text := text firstLine.
                classCategoryChunks ifTrue:[
                    changeClass isNil ifTrue:[
                        changeDelta := '?'.
                    ] ifFalse:[
                        changeClass category = text ifTrue:[
                            changeDelta := '='.
                        ]
                    ].
                    changeString := clsName , ' category: ' , text storeString.
                ]ifFalse:[
                    changeString := '(' , clsName , ' compiledMethodAt:' , methodSelector storeString , ') category: ' , text storeString.
                ].
            ] ifFalse:[
                "
                 try to find the selector
                "
                methodSelector := nil.
                clsName notNil ifTrue:[
                    methodChunks ifTrue:[
                        p := Parser for:(ReadStream on:text) in:nil.  
                        p ignoreErrors:true.
                        p ignoreWarnings:true.
                        p parserFlags allowDollarInIdentifier:true.
                        p parserFlags allowParagraphInIdentifier:true.
                        p parseMethodSpec.
                        methodSelector := p selector.
"/                        p := Parser
"/                                 parseMethodSpecification:text
"/                                 in:nil
"/                                 ignoreErrors:true
"/                                 ignoreWarnings:true.
"/                        (p notNil and:[p ~~ #Error]) ifTrue:[
"/                            methodSelector := p selector.
"/                        ]
                    ]
                ].

                methodSelector isNil ifTrue:[
                    changeString := (chunkText contractTo:maxLen).
                    changeType := '(change)'.
                    headerLine := chunkText , ' (change)'.
                ] ifFalse:[
                    changeString :=  self contractClass:clsName selector:methodSelector to:maxLen.
                    changeType := '{ ' , category , ' }'.
                    headerLine := clsName , ' ' , methodSelector , ' ' , '(change category: ''' , category , ''')'.
                ].

                autoCompare value ifTrue:[
                    changeDelta := ChangeDeltaInformation 
                                        changeDeltaFor:text changeClass:changeClass selector:methodSelector.
                ].
            ].
            changeInfo last 
                headerLine:(self headerLineForChangeType:changeType 
                                 changeString:changeString
                                 changeDelta:changeDelta
                                 timeStampInfo:timeStampInfo).
        ].
        changeString := nil.
        headerLine := nil.
        singleJunkOnly ifTrue:[done := true]
    ].
    singleInfo ifTrue:[
        timeStampInfo := nil
    ].
    anyMethod ifFalse:[
        emptyBlock value
    ].

    "Modified: / 21-11-2016 / 23:32:29 / cg"
!

processNonMethodChunk
    |s changeClass sel  cls p rec clsName ownerTree ownerName
     m nameAndClass args instVarsArg classVarsArg categoryArg|

    (chunkText startsWith:'''---- snap') ifTrue:[
        self processSnapshotChunk.
        ^ self
    ].

    headerLine := chunkText , ' (doIt)'.

    "
     first, assume doIt - then lets have a more detailed look ...
    "
    ((chunkText startsWith:'''---- file')
    or:[(chunkText startsWith:'''---- check')]) ifTrue:[
        changeType := ''.
        timeStampInfo := nil.
    ] ifFalse:[
        changeType := '(doIt)'.
    ].
    changeString := (chunkText contractTo:maxLen) withoutSeparators.

    p := browser parseExpression:fullChunkText inNameSpace:Smalltalk.
    (p notNil and:[p ~~ #Error]) ifTrue:[
        p isMessage ifTrue:[
            sel := p selector.
            rec := p receiver.
            args := p args.        
        ]
    ] ifFalse:[
        sel := nil.
        (Scanner new scanTokens:fullChunkText) size == 0 ifTrue:[
            "/ a comment only
            changeType := '(comment)'.
            NoColoring ~~ true ifTrue:[
                changeType := changeType allItalic.
                "/ changeString := changeString allItalic.
                changeType emphasisAllAdd:(#color -> UserPreferences current commentColor).
            ]
        ] ifFalse:[
            changeType := '(???)'.
        ]
    ].

    (sel == #comment:) ifTrue:[
        changeType := '(comment)'.
        clsName := rec name.
        changeClass := (self nameSpaceForApply) classNamed:clsName.
        (changeInfo last) className:clsName.
        "/ changeClassNames at:changeClassNames size put:clsName.
        NoColoring ~~ true ifTrue:[
            changeType := changeType allItalic.
            changeType emphasisAllAdd:(#color -> UserPreferences current commentColor).
            "/ changeString := clsName allItalic.
        ].
        autoCompare value ifTrue:[
            (changeClass isNil or:[changeClass isLoaded not]) ifTrue:[
                changeDelta := '?'
            ] ifFalse:[
                (changeClass comment = (args at:1) evaluate) ifTrue:[
                    changeDelta := '='.
                ]
            ]
        ].
        "/ sel := nil.
        ^ self.
    ].

    (sel == #removeSelector:) ifTrue:[
        nameAndClass := self extractClassAndClassNameFromParseTree:rec.
        clsName := nameAndClass key. changeClass := nameAndClass value.

        sel := (args at:1) evaluate.
        (changeInfo last) className:clsName.
        "/ changeClassNames at:changeClassNames size put:clsName.

        autoCompare value ifTrue:[
            (changeClass isNil or:[changeClass isLoaded not]) ifTrue:[
                changeDelta := '?'
            ] ifFalse:[
                (changeClass includesSelector:sel asSymbol) ifTrue:[
                    changeDelta := '-'.
                ] ifFalse:[
                    changeDelta := '='.
                ]
            ]
        ].
        changeType := '(remove)'.
        changeString := self contractClass:clsName selector:sel to:maxLen.
        "/ sel := nil.
        ^ self.
    ].

    (p notNil
    and:[p ~~ #Error
    and:[p isMessage
    and:[rec isMessage
    and:[rec selector == #compiledMethodAt:]]]]) ifTrue:[
        nameAndClass := self extractClassAndClassNameFromParseTree:rec receiver.
        clsName := nameAndClass key. changeClass := nameAndClass value.

        (sel == #category:) ifTrue:[
            sel := (rec args at:1) evaluate.
            changeType := '(category change)'.
            changeString := self contractClass:clsName selector:sel to:maxLen.
            (changeInfo last) className:clsName.
            "/ changeClassNames at:changeClassNames size put:clsName.
            autoCompare value ifTrue:[
                (changeClass isNil or:[changeClass isLoaded not]) ifTrue:[
                    changeDelta := '?'
                ] ifFalse:[
                    m := changeClass compiledMethodAt:sel asSymbol.
                    m notNil ifTrue:[
                        m category = (p args at:1) evaluate ifTrue:[
                            changeDelta := '='.
                        ]
                    ]
                ]
            ].
            ^ self.
        ].
        (sel == #privacy:) ifTrue:[
            sel := (rec args at:1) evaluate.
            changeType := '(privacy change)'.
            changeString := self contractClass:clsName selector:sel to:maxLen.
            (changeInfo last) className:clsName.
            "/ changeClassNames at:changeClassNames size put:clsName.
            autoCompare value ifTrue:[
                (changeClass isNil or:[changeClass isLoaded not]) ifTrue:[
                    changeDelta := '?'
                ] ifFalse:[
                    changeDelta := ' '
                ]
            ].
            ^ self.
        ].
        sel := nil.
    ].

    (Class definitionSelectors includes:sel) ifTrue:[
        changeType := '(class definition)'.
        clsName := (args at:1) evaluate.
        (changeInfo last) className:clsName.
        "/ changeClassNames at:changeClassNames size put:clsName.

        "/ is it a private-class ?
        ('*privateIn:' match:sel) ifTrue:[
            ownerTree := args last.
            ownerName := ownerTree name asString.
            clsName := ownerName , '::' , clsName
        ].

        changeString := clsName.
        NoColoring ~~ true ifTrue:[
            changeType := changeType allBold.
            changeString := changeString allBold.
        ].

        autoCompare value ifTrue:[
            cls := (self nameSpaceForApply) at:clsName asSymbol ifAbsent:nil.
            cls isNil ifTrue:[
                changeDelta := '+'.
            ] ifFalse:[
                (cls definitionSelector = sel
                or:[
                    "/ could be an ST/V, VAge or Dolphin definition
                    cls definitionSelector = (sel , 'category:')
                ])
                ifTrue:[
                    ((cls superclass isNil
                        and:[p receiver isLiteral
                        and:[p receiver evaluate isNil]])
                    or:[
                        cls superclass notNil
                        and:[p receiver isLiteral not
                        and:[cls superclass name = p receiver name]]
                    ]) ifTrue:[
                        (sel == #'variableByteSubclass:classVariableNames:poolDictionaries:category:')
                        ifTrue:[
                            "/ VSE definition message
                            instVarsArg := ''.
                            classVarsArg := (args at:2) evaluate.
                            categoryArg := (args at:4) evaluate.
                        ] ifFalse:[
                            instVarsArg := (args at:2) evaluate.
                            classVarsArg := (args at:3) evaluate.
                            categoryArg := (args at:5) evaluate.
                        ].
                        cls instanceVariableString asCollectionOfWords = instVarsArg asCollectionOfWords ifTrue:[
                            cls classVariableString asCollectionOfWords = classVarsArg asCollectionOfWords ifTrue:[
                                cls definitionSelector = (sel , 'category:')
                                ifTrue:[
                                    "/ ST/V, VAge or Dolphin definition
                                    changeDelta := '='.
                                ] ifFalse:[
                                    cls category = categoryArg ifTrue:[
                                        changeDelta := '='.
                                    ] ifFalse:[
                                        changeType := '(class category change)'.
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ].
        "/ sel := nil.
        ^ self.
    ].

    (#(
      #'primitiveDefinitions:'
      #'primitiveFunctions:'
      #'primitiveVariables:'
     ) includes:sel) ifTrue:[
        changeType := '(class definition)'.
        clsName := rec name.
        ^ self.    
    ].

    ((sel == #instanceVariableNames:)
    and:[rec isMessage
    and:[rec selector == #class]]) ifTrue:[
        clsName := rec receiver name.
        changeClass := (self nameSpaceForApply) classNamed:clsName.
        changeType := '(class definition)'.
        (changeInfo last) className:clsName.
        "/ changeClassNames at:changeClassNames size put:clsName.

        autoCompare value ifTrue:[
            changeClass isNil ifTrue:[
                changeDelta := '?'.
            ] ifFalse:[
                s := (p args at:1) evaluate.
                s = changeClass class instanceVariableString ifTrue:[
                    changeDelta := '='.
                ]
            ]
        ].
        ^ self.    
    ].

    "Modified: / 01-05-2016 / 19:19:54 / cg"
!

processSnapshotChunk
    changeType := ''.
    headerLine := chunkText.
    changeString := (chunkText contractTo:maxLen) withoutSeparators.
    timeStampInfo := nil.
!

readChangesFile
    "read the changes file, create a list of header-lines (changeChunks)
     and a list of chunk-positions (changePositions).
     Starting with 2.10.3, the entries are multi-col entries;
     the cols are:
        1   delta (only if comparing)
                '+' -> new method (w.r.t. current state)
                '-' -> removed method (w.r.t. current state)
                '?' -> class does not exist currently
                '=' -> change is the same as current methods source
                '~' -> change is almost the same as current methods source
        2   class/selector
        3   type of change
                doit
                method
                category change
        4   timestamp

     since comparing slows down startup time, it is now disabled by
     default and can be enabled via a toggle."

    |excla|

    changeInfo := OrderedCollection new.

"/    changeChunks := OrderedCollection new.
"/    changeClassNames := OrderedCollection new.
"/    changeHeaderLines := OrderedCollection new.
"/    changePositions := OrderedCollection new.
"/    changeTimeStamps := OrderedCollection new.
"/    changeIsFollowupMethodChange := OrderedCollection new.

    excla := inStream class chunkSeparator.
    maxLen := 100.

    [inStream atEnd] whileFalse:[
        "
         get a chunk (separated by excla)
        "
        inStream skipSeparators.
        chunkPosition := inStream position + 1.

        sawExcla := inStream peekFor:excla.
        chunkText := fullChunkText := inStream nextChunk.
        chunkText notEmptyOrNil ifTrue:[
            self processChunk.
        ]
    ].

    "Modified: / 27-08-1995 / 23:06:55 / claus"
    "Modified: / 01-05-2016 / 18:33:36 / cg"
! !

!ChangesBrowser::ChangeInfo methodsFor:'accessing'!

chunk
    ^ chunk
!

className
    ^ className
!

className:something
    className := something.
!

headerLine
    ^ headerLine
!

headerLine:something
    headerLine := something.
!

isFollowupChange
    ^ isFollowupChange
!

position
    ^ position
!

position:positionArg chunk:chunkArg className:classNameArg selector:selectorArg headerLine:headerLineArg 
    timestamp:timestampArg isFollowupChange:isFollowupChangeArg 

    position := positionArg.
    chunk := chunkArg.
    className := classNameArg.
    selector := selectorArg.
    headerLine := headerLineArg.
    timestamp := timestampArg.
    isFollowupChange := isFollowupChangeArg.

    "Created: / 01-05-2016 / 19:01:03 / cg"
!

selector
    ^ selector
!

selector:something
    selector := something.
!

timestamp
    ^ timestamp
! !

!ChangesBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

