"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

SelectionBrowser subclass:#FileSelectionBrowser
	instanceVariableNames:'selectedFileFilter directoryView listOfFileFilters directory'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Dialogs'
!

!FileSelectionBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    The FileSelectionBrowser allows you to browse in file directories
    and to select files in order to load file contents or to save
    something to files.

    [start with:]
        FileSelectionBrowser open

    [author:]
        Thomas Zwick, eXept Software AG
"
! !

!FileSelectionBrowser class methodsFor:'instance creation'!

request: aTitle fileName: aFileName inDirectory: dir withFileFilters: fileFilters
    "ask for a file in some directory,
     using a fileFilter (list of mathcPatterns).
     Initial selection is aFileName.
     return the pathName or nil if canceled."

    ^self new
        title: aTitle;
        fileName: aFileName;
        directory: dir;
        listOfFileFilters: fileFilters;
        open

    "
     self 
         request: 'Select Your Profile File' 
         fileName: '.profile' 
         inDirectory: Filename homeDirectory 
         withFileFilters: #('.*')
    "

    "Modified: / 17.8.1998 / 10:15:50 / cg"
!

request:aTitle fileName:aFileName withFileFilters:fileFilters
    "ask for a file in some directory,
     using a fileFilter (list of mathcPatterns).
     Initial selection is aFileName.
     return the pathName or nil if canceled."

    ^ self new
        title: aTitle;
        fileName: aFileName;
        listOfFileFilters: fileFilters;
        open

    "
     self 
         request: 'Select Your Profile File' 
         fileName: '/etc/fstab' 
         withFileFilters: #('*')  
    "

    "Modified: / 17.8.1998 / 10:15:50 / cg"
!

request:aTitle inDirectory:aPath withFileFilters:fileFilters 
    "ask for a file in some directory,
     using a fileFilter (list of mathcPatterns)
     return the pathName or nil if canceled."

    ^ (self new)
        title:aTitle;
        directory:aPath;
        listOfFileFilters:fileFilters;
        open

    "
     self 
         request: 'Select A File' 
         inDirectory: '/etc' 
         withFileFilters: #('*.conf')
    "

    "Modified: / 17.8.1998 / 10:15:50 / cg"
!

request:aTitle pathName:aPath withFileFilters:fileFilters 
    "ask for a file in some directory,
     using a fileFilter (list of mathcPatterns)
     return the pathName or nil if canceled.
     Obsolete - for backward compatibility."

    ^ self
        request:aTitle inDirectory:aPath withFileFilters:fileFilters

    "
     self 
         request: 'Select A File' 
         pathName: '/etc' 
         withFileFilters: #('*.conf')
    "

    "Modified: / 17.8.1998 / 10:15:50 / cg"
!

request:aTitle withFileFilters:fileFilters 
    "ask for a file in the current directory,
     using a fileFilter (list of mathcPatterns)
     return the pathName or nil if canceled"

    ^ (self new)
        title:aTitle;
        listOfFileFilters:fileFilters;
        open

    "
     self request:'Select A File' withFileFilters:#('.*')
     self request:'Select A File' withFileFilters:#('*.mak;*.st')
    "

    "Modified: / 17.8.1998 / 10:15:49 / cg"
!

requestFileName
    "ask for a file in the current directory;
     return the pathName or nil if canceled"

    ^ self new 
        title:'Select A File';
        open

    "
     self requestFileName
    "

    "Modified: / 17.8.1998 / 10:15:48 / cg"
!

requestFileNameInDirectory:aPath
    "ask for a file in a directory;
     return the pathName or nil if canceled"

    ^ self new 
        title:'Select A File'; 
        directory:aPath; 
        open

    "
     self requestFileNameInDirectory:'/etc' 
    "

    "Modified: / 17.8.1998 / 10:15:48 / cg"
! !

!FileSelectionBrowser class methodsFor:'accessing'!

loadImageFileNameFilters
    ^ OrderedCollection 
        withAll: #(
                    '*.png ; *.gif ; *.bmp ; *.tif ; *.tiff ; *.xpm ; *.xbm ; *.jpeg ; *.jpg'
                    '*'
                  )

    "Modified: / 12.9.1998 / 17:23:42 / cg"
!

projectFileNameFilters
    ^Array withAll: #(
                      '*.st ; *.*o ; *.s ; *.c ; Make* ; *.project'
                      '*'
                     )

    "Modified: / 12.9.1998 / 17:23:22 / cg"
!

saveImageFileNameFilters
    ^ OrderedCollection 
        withAll: #(
                    '*.png ; *.gif ; *.jpg ; *.bmp ; *.tif ; *.tiff ; *.xpm ; *.xbm'
                    '*'
                  )

    "Modified: / 12.9.1998 / 17:23:54 / cg"
! !

!FileSelectionBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileSelectionBrowser andSelector:#windowSpec
     FileSelectionBrowser new openInterface:#windowSpec
     FileSelectionBrowser open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'File Selection Browser'
          #name: 'File Selection Browser'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 18 51 618 401)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#VariableHorizontalPanelSpec
              #name: 'panel'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -40 1.0)
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ViewSpec
                    #name: 'view1'
                    #component: 
                   #(#SpecCollection
                      #collection: #(
                       #(#FileSelectionTreeSpec
                          #name: 'directoryTreeView'
                          #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
                          #model: #selectionOfDirectory
                          #menu: #treeMenu
                          #hasHorizontalScrollBar: true
                          #hasVerticalScrollBar: true
                          #miniScrollerHorizontal: true
                          #showDirectoryIndicatorForRoot: false
                          #showDirectoryIndicator: true
                          #valueChangeSelector: #readDirectory
                          #hierarchicalList: #rootOfDirectory
                          #highlightMode: #line
                          #itemClass: 'Directory'
                        )
                       #(#InputFieldSpec
                          #name: 'directoryInputField'
                          #layout: #(#LayoutFrame 2 0.0 -22 1 0 1.0 0 1)
                          #model: #selectionOfDirectory
                          #immediateAccept: false
                          #acceptOnPointerLeave: false
                        )
                       )
                     
                    )
                  )
                 #(#ViewSpec
                    #name: 'view2'
                    #component: 
                   #(#SpecCollection
                      #collection: #(
                       #(#InputFieldSpec
                          #name: 'EditField'
                          #layout: #(#LayoutFrame 1 0.0 -22 1 -2 1.0 0 1)
                          #model: #valueOfFileName
                          #acceptOnReturn: false
                          #acceptOnTab: false
                          #acceptOnPointerLeave: false
                        )
                       #(#SubCanvasSpec
                          #name: 'subCanvas1'
                          #layout: #(#LayoutFrame 1 0.0 0 0.0 0 1.0 -25 1.0)
                          #clientHolder: #directoryView
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              #handles: #(#Any 0.5 1.0)
            )
           #(#UISubSpecification
              #name: 'SubSpecification'
              #layout: #(#LayoutFrame 2 0.0 -32 1 0 1.0 0 1.0)
              #majorKey: #ToolApplicationModel
              #minorKey: #windowSpecForCommitWithoutChannels
            )
           )
         
        )
      )
! !

!FileSelectionBrowser class methodsFor:'menu specs'!

treeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileSelectionBrowser andSelector:#treeMenu
     (Menu new fromLiteralArrayEncoding:(FileSelectionBrowser treeMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Goto Home Directory'
            #translateLabel: true
            #value: #menuGotoHomeDirectory
          )
         #(#MenuItem
            #label: 'Goto Default Directory'
            #translateLabel: true
            #value: #menuGotoDefaultDirectory
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Create directory...'
            #translateLabel: true
            #value: #menuCreateDirectory
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Update'
            #translateLabel: true
            #value: #menuUpdate
          )
         )
        nil
        nil
      )
! !

!FileSelectionBrowser methodsFor:'accessing'!

directory: aDirectory

    directory := (aDirectory ? Filename currentDirectory) asFilename asAbsoluteFilename pathName

    "Modified: / 17.8.1998 / 10:15:53 / cg"
!

directoryView
    "return the directory view on the right side (a subcanvas)"

    ^directoryView ? (directoryView := DirectoryView new)

    "Modified: / 23.9.1998 / 16:46:50 / cg"
!

fileName: aFileName
    |prevDir|

    self valueOfFileName value: (aFileName ? '') asFilename baseName.
    prevDir := directory.
    directory := directory ? ((aFileName ? '') asFilename asAbsoluteFilename directoryName).

    "/ on systems with volumes, we might have to update the root here.
    (prevDir isNil
    or:[directory asFilename volume ~= prevDir asFilename volume]) ifTrue:[
        self setRootForFile:directory asFilename.
    ].

    "Modified: / 24.9.1998 / 23:41:08 / cg"
!

listOfFileFilters: anArray

    listOfFileFilters := anArray
! !

!FileSelectionBrowser methodsFor:'accessing-views'!

directoryInputField

    ^self componentAt: #directoryInputField
!

directoryTreeView

    ^self componentAt: #directoryTreeView
! !

!FileSelectionBrowser methodsFor:'aspects'!

rootOfDirectory

    |holder|
    (holder := builder bindingAt:#rootOfDirectory) isNil ifTrue:[
        builder 
            aspectAt:#rootOfDirectory 
            put: (holder :=  Filename rootDirectory name asValue).
    ].
    ^ holder

    "Modified: / 5.10.1998 / 12:46:10 / cg"
!

selectionOfDirectory

    |holder|
    (holder := builder bindingAt:#selectionOfDirectory) isNil ifTrue:[
        builder aspectAt:#selectionOfDirectory put: (holder := ValueHolder new)
    ].
    ^ holder

!

setRootForFile:aFilename
    |f root parent|

    f := aFilename asFilename.
    root := Filename rootDirectoryOnVolume:f volume.
    self directory:aFilename.

    "/ on some systems, the root itself is not readable,
    "/ but subdirs are (WIN32-network drives and VMS)
    "/ to avoid trouble in the treeView, search for the
    "/ last readable directory and fake that as the trees root.

    (root exists and:[root isDirectory and:[root isReadable]])
    ifFalse:[
        "/ search backward from aFilename for the last readable dir.
        root := f.
        parent := root directory.
        [parent ~= root
         and:[parent exists 
         and:[parent isDirectory 
         and:[parent isReadable]]]]
        whileTrue:[
            root := parent.
            parent := root directory.
        ].
    ].

    self rootOfDirectory value:root pathName

    "Created: / 23.9.1998 / 16:36:28 / cg"
    "Modified: / 5.10.1998 / 12:46:06 / cg"
!

valueOfFileName

    |holder|
    (holder := builder bindingAt:#valueOfFileName) isNil ifTrue:[
        builder aspectAt:#valueOfFileName put:(holder :=  ValueHolder new).
    ].
    ^ holder
! !

!FileSelectionBrowser methodsFor:'callbacks'!

fileDoubleClicked: aFileName

    self valueOfFileName value: aFileName.
    accept value: true.
    self closeRequest
!

menuCreateDirectory
    |newSubDirName currentDir|

    currentDir := self selectionOfDirectory value.
    currentDir isNil ifTrue:[
        self warn:'No directory selected.'.
        ^ self
    ].
    newSubDirName := Dialog 
                        request:(resources 
                                    stringWithCRs:'Create new directory in\\%1: ' 
                                    with:(currentDir asFilename pathName allBold)).
    (currentDir asFilename construct:newSubDirName) makeDirectory.
    self menuUpdate
!

menuGotoDefaultDirectory
    self selectionOfDirectory value:(Filename defaultDirectory pathName)
!

menuGotoHomeDirectory
    self selectionOfDirectory value:(Filename homeDirectory pathName)
!

menuUpdate
    (self componentAt:#directoryTreeView) monitorCycle.
!

readDirectory
    self directoryTreeView selection notNil ifTrue: [
        directoryView directory: self selectionOfDirectory value.
        directoryView readDirectory.  
        self class lastSelection notNil ifTrue: [self class lastSelection: self selectionOfDirectory value]
    ]

    "Modified: / 24.9.1998 / 21:58:50 / cg"
! !

!FileSelectionBrowser methodsFor:'misc'!

entryCompletion
    |completedDirectory f dir treeView inputField|

    treeView := self directoryTreeView.
    inputField := self directoryInputField.

    f := inputField contents.
    f asFilename isRootDirectory ifTrue:[
        dir := f.
    ] ifFalse:[
        dir := f asFilename directoryName.
    ].

    completedDirectory := Filename 
        filenameCompletionFor:f
        directory:dir
        directoriesOnly:true 
        filesOnly:false 
        ifMultiple:
            [:dir | 
                treeView selection notNil ifTrue:[
                    treeView selectedNodeExpand: true
                ]
            ].

    completedDirectory asFilename exists ifTrue:[
        "/ volume changed ... (win32 or VMS)
"/        completedDirectory asFilename volume ~= directory asFilename volume ifTrue:[
"/        ].
        completedDirectory asFilename volume ~= treeView scrolledView directory asFilename volume ifTrue:[
            treeView scrolledView directory:completedDirectory asFilename volume
        ].
        treeView selectPathname: completedDirectory.
        inputField contents: completedDirectory.
        self readDirectory
    ] ifFalse: [
        inputField flash
    ]

    "Created: / 24.9.1998 / 21:33:37 / cg"
    "Modified: / 24.9.1998 / 22:20:23 / cg"
! !

!FileSelectionBrowser methodsFor:'startup & release'!

closeCancel

    directoryView release.
    super closeCancel
!

closeRequest

    directoryView release.
    super closeRequest

!

open
    super open.

    "return the selected file or nil"
    accept value ifTrue:[
        ^ (self selectionOfDirectory value ? '') asFilename 
                constructString:(self valueOfFileName value ? '')
    ].
    ^ nil

    "Modified: / 17.8.1998 / 10:15:55 / cg"
!

postBuildWith:aBuilder
    |nm file|

    directoryView listOfFileFilters: listOfFileFilters ? #('*').
    directoryView fileSelectAction: [:aFileName |self valueOfFileName value: aFileName asFilename baseName].
    directoryView fileDoubleClickAction: [:aFileName |self fileDoubleClicked: aFileName asFilename baseName].
    directoryView fileFilterSelectAction: [:fileFilter|
"/        CG: obscure code - isn't the code below the same as ?
"/        self valueOfFileName value:((self valueOfFileName value ? 'unknown') 
"/                                    asFilename
"/                                        withSuffix:(fileFilter asFilename suffix))
        self valueOfFileName value: (
            ((self valueOfFileName value ? 'unknown') readStream upTo: $.), '.',
            (fileFilter reversed readStream upTo: $.) reverse)
    ]. 
    nm := directory.
    nm isNil ifTrue:[
        nm := self class lastSelection.
        nm isNil ifTrue:[
            nm := Filename currentDirectory asAbsoluteFilename name.
        ].
    ].

    self directoryTreeView selectPathname:nm.

    self directoryInputField 
        entryCompletionBlock:[:f| self entryCompletion].

    file := self valueOfFileName value.
    directoryView selectionOfFile value: 
        (directoryView listOfFiles 
            detect: [:row | row baseName = file] 
            ifNone: nil).

    super postBuildWith:aBuilder

    "Modified: / 24.9.1998 / 23:41:29 / cg"
! !

!FileSelectionBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

