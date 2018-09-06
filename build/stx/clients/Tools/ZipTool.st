"{ Package: 'stx:clients/Tools' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#ZipTool
	instanceVariableNames:'zipFileName zipArchive zipEntryContents zipEntryList
		zipEntryListSelection lastOpenDirectory'
	classVariableNames:'LastOpenDirectory'
	poolDictionaries:''
	category:'demos-Tools-System'
!


!ZipTool class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ZipTool andSelector:#windowSpec
     ZipTool new openInterface:#windowSpec
     ZipTool open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'ZipTool'
         name: 'ZipTool'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 579 476)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (SequenceViewSpec
                   name: 'zipEntryList'
                   model: zipEntryListSelection
                   menu: zipEntryListMenu
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   miniScrollerHorizontal: true
                   doubleClickSelector: zipEntryDoubleClicked:
                   valueChangeSelector: zipEntrySelectionChanged
                   useIndex: false
                   sequenceList: zipEntryList
                 )
                (TextEditorSpec
                   name: 'TextEditor1'
                   model: zipEntryContents
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   miniScrollerHorizontal: true
                   isReadOnly: true
                   hasKeyboardFocusInitially: false
                 )
                )
              
             )
             handles: (Any 0.65966400000000025 1.0)
           )
          )
        
       )
     )
! !

!ZipTool class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ZipTool andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(ZipTool mainMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'File'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Open...'
                          #translateLabel: true
                          #value: #menuOpen
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Exit'
                          #translateLabel: true
                          #value: #closeRequest
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Archive'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Extract all into...'
                          #translateLabel: true
                          #value: #extractAllEntriesInto
                          #enabled: #hasZipFileOpened
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Extract Selected into...'
                          #translateLabel: true
                          #value: #extractSelectedZipEntryInto
                          #enabled: #hasZipEntrySelected
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Help'
                #translateLabel: true
                #startGroup: #right
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Documentation'
                          #translateLabel: true
                          #value: #openDocumentation
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'About ZipTool...'
                          #translateLabel: true
                          #value: #openAboutThisApplication
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )

    "Modified: / 23.8.1998 / 18:22:37 / cg"
!

zipEntryListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ZipTool andSelector:#zipEntryListMenu
     (Menu new fromLiteralArrayEncoding:(ZipTool zipEntryListMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Extract into..'
                #translateLabel: true
                #value: #extractSelectedZipEntryInto
                #enabled: #hasZipEntrySelected
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Show Contents'
                #translateLabel: true
                #value: #showSelectedZipEntryContents
                #enabled: #hasZipEntrySelected
            )
          ) nil
          nil
      )

    "Modified: / 23.8.1998 / 18:25:17 / cg"
! !

!ZipTool class methodsFor:'startup'!

openOn:aZipFileName
    |builder app|

    builder := super open.
    (app := builder application) openZipFile:aZipFileName.
    ^ app

    "Created: / 23.8.1998 / 18:32:24 / cg"
    "Modified: / 23.8.1998 / 18:34:47 / cg"
! !

!ZipTool methodsFor:'accessing'!

initialExtractDirectory:aDirectory
    lastOpenDirectory := aDirectory
! !

!ZipTool methodsFor:'actions'!

zipEntryDoubleClicked:fileName

    self showSelectedZipEntryContents.
!

zipEntrySelectionChanged
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': action for zipEntrySelectionChanged ...'.

    "Created: / 23.8.1998 / 17:47:48 / cg"
! !

!ZipTool methodsFor:'aspects'!

hasZipEntrySelected
    ^ [ zipEntryListSelection value notNil ]

    "Created: / 24.8.1998 / 10:38:32 / cg"
!

hasZipFileOpened
    ^ [ zipArchive value notNil ]

    "Created: / 24.8.1998 / 10:39:30 / cg"
!

zipEntryContents
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    zipEntryContents isNil ifTrue:[
        zipEntryContents :=  ValueHolder new.
    ].
    ^ zipEntryContents.

    "Created: / 23.8.1998 / 17:48:51 / cg"
!

zipEntryList
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    zipEntryList isNil ifTrue:[
        zipEntryList :=  ValueHolder new.
    ].
    ^ zipEntryList.

    "Created: / 23.8.1998 / 17:48:51 / cg"
!

zipEntryListSelection
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    zipEntryListSelection isNil ifTrue:[
        zipEntryListSelection :=  ValueHolder new.
    ].
    ^ zipEntryListSelection.

    "Created: / 23.8.1998 / 17:48:51 / cg"
!

zipFileName
    zipFileName isNil ifTrue:[
        zipFileName :=  ValueHolder new.
        zipFileName onChangeSend:#zipFileNameChanged to:self.
    ].
    ^ zipFileName.

    "Created: / 23.8.1998 / 17:57:09 / cg"
! !

!ZipTool methodsFor:'changes'!

zipFileNameChanged
    |zar|

    zar := ZipArchive oldFileNamed:(zipFileName value).
    zar notNil ifTrue:[
        zipArchive := zar.
        self zipEntryList value:(zipArchive entries asOrderedCollection sort)
    ].

    "Created: / 23.8.1998 / 17:58:54 / cg"
    "Modified: / 26.8.1998 / 16:25:00 / cg"
! !

!ZipTool methodsFor:'hooks'!

postBuildWith:aBuilder
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the widgets have been built, but before the view is opened"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    lastOpenDirectory isNil ifTrue:[
        lastOpenDirectory := LastOpenDirectory.
    ].
    super postBuildWith:aBuilder

    "Created: / 23.8.1998 / 16:49:51 / cg"
!

postOpenWith:aBuilder
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the topView has been opened, but before events are dispatched for it"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    super postOpenWith:aBuilder

    "Created: / 23.8.1998 / 16:49:51 / cg"
! !

!ZipTool methodsFor:'menu actions'!

doOpen:anArgument
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': menu action for doOpen:' , anArgument printString , ' ...'.
    self withWaitCursorDo:[
        self zipFileName value:anArgument
    ].

    "Created: / 23.8.1998 / 18:11:11 / cg"
    "Modified: / 23.8.1998 / 18:19:15 / cg"
!

extractAllEntriesInto
    |dir f s data|

    dir := Dialog 
                requestDirectoryName:'Directory to extract into:'
                default:lastOpenDirectory.
    dir size > 0 ifTrue:[
        self withCursor:Cursor read do:[
            dir := dir asFilename.
            zipArchive members do:[:e |
                |name|

                e uncompressed_size ~~ 0 ifTrue:[
                    name := e name.
                    self activityNotification:('extracting ' , name , ' ...').
                    f := dir construct:name.
                    f directory recursiveMakeDirectory.
                    s := f writeStream binary.
                    data := zipArchive extract:name.
                    s nextPutAll:data.
                    s close.
                ]
            ].
        ].
        self activityNotification:nil.
    ]

    "Modified: / 24.8.1998 / 20:58:01 / cg"
!

extractSelectedZipEntryInto
    |dir f s data name|

    dir := Dialog 
                requestDirectoryName:'Directory to extract into:'
                default:lastOpenDirectory.
    dir size > 0 ifTrue:[
        self withCursor:Cursor read do:[
            name := zipEntryListSelection value.
            self activityNotification:('extracting ' , name , ' ...').
            dir := dir asFilename.
            f := dir construct:name.
            f directory recursiveMakeDirectory.
            s := f writeStream binary.
            data := zipArchive extract:name.
            s nextPutAll:data.
            s close.
        ]
    ]

    "Modified: / 24.8.1998 / 20:57:39 / cg"
!

menuOpen
    "automatically generated by UIPainter ..."

    "*** the code below opens a dialog for file selection"
    "*** and invokes the #doOpen: method with the selected file."
    "*** Please change as required and accept in the browser."

    |file|

    file :=
        (FileSelectionBrowser
            request: 'Open'
            fileName: ''
            inDirectory: lastOpenDirectory
            withFileFilters: #('*')).

    file notNil ifTrue:[
       LastOpenDirectory := lastOpenDirectory := file asFilename directory.
       self doOpen:file
    ]

    "Created: / 23.8.1998 / 18:11:13 / cg"
    "Modified: / 23.8.1998 / 18:18:34 / cg"
!

openAboutThisApplication
    "opens an about box for this application."

    "automatically generated by UIPainter ..."

    |rev box myClass clsRev image msg|

    rev := ''.
    myClass := self class.
    (clsRev := myClass revision) notNil ifTrue:[
       rev := '  (rev: ', clsRev printString, ')'].

    msg := Character cr asString , myClass name asBoldText, rev.
    msg := (msg , '

A little tool to view the contents
of a zip or jar file.

') withCRs.

    box := AboutBox title:msg.
    "/ *** add a #defaultIcon method in the class
    "/ *** and uncomment the following line:
    "/ image := self class defaultIcon.

    image notNil ifTrue:[
        box image:image
    ].
    box   label:(resources string:'About %1' with:myClass name).
    box   autoHideAfter:10 with:[].
    box   showAtPointer.

    "Created: / 23.8.1998 / 17:39:07 / cg"
    "Modified: / 24.8.1998 / 20:59:32 / cg"
!

openDocumentation
    self information:'No documentation on that little tool yet'.

    "Modified: / 24.8.1998 / 21:00:09 / cg"
!

showAbout
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': menu action for showAbout ...'.

    "Modified: / 23.8.1998 / 16:51:41 / cg"
!

showDocumentation
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': menu action for showDocumentation ...'.

    "Modified: / 23.8.1998 / 16:51:41 / cg"
!

showSelectedZipEntryContents
    |contents fileName suffix typeFromSuffix typeFromContents type img readerClass|

    fileName := zipEntryListSelection value.
    self withCursor:Cursor read do:[
        contents := zipArchive extract:fileName.
    ].

    suffix := fileName asFilename suffix.
    typeFromSuffix := (MIMETypes mimeTypeForSuffix:suffix).
    typeFromContents := (MIMETypes mimeTypeOfData:contents) ? ''.
    type := typeFromSuffix ? typeFromContents.

    ((typeFromSuffix ? '' startsWith:'text/') or:[typeFromContents ? '' startsWith:'text/']) ifFalse:[
        (type startsWith:'image/') ifTrue:[
            readerClass := MIMETypes imageReaderForSuffix:suffix.
            readerClass notNil ifTrue:[
                img := readerClass fromStream:(contents readStream).
                img notNil ifTrue:[
                    ^ img inspect
                ]
            ]
        ].
        ( #(
            'application/x-make'
            'application/batch-script'
            'application/x-smalltalk-source' 
           ) includes:type
        ) ifFalse:[
            (self confirm:'Contents could be binary. Show anyway ?') ifFalse:[
                ^ self
            ]
        ]
    ].
    zipEntryContents value:(contents asString)

    "Created: / 23.8.1998 / 18:35:47 / cg"
    "Modified: / 23.8.1998 / 20:14:13 / cg"
! !

!ZipTool methodsFor:'misc'!

showActivity:someMessage
    someMessage isNil ifTrue:[
        self window label:'ZipTool'
    ] ifFalse:[
        self window label:('ZipTool - ' , someMessage)
    ]

    "Created: / 24.8.1998 / 20:55:22 / cg"
    "Modified: / 24.8.1998 / 20:55:45 / cg"
! !

!ZipTool methodsFor:'startup'!

openZipFile:aFilename
    self zipFileName value:(aFilename asFilename)

    "Created: / 23.8.1998 / 18:34:38 / cg"
! !

!ZipTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Tools/ZipTool.st,v 1.10 2015-02-24 23:46:33 cg Exp $'
! !

