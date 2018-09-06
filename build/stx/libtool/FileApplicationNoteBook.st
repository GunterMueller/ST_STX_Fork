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

AbstractFileBrowser subclass:#FileApplicationNoteBook
	instanceVariableNames:'canvasHolder selectedEditorPage listOfApplications tabMenuIndex
		tabList selectionHistoryList privateTabList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

AbstractFileApplicationNoteBookComponent subclass:#ArchiveViewApplication
	instanceVariableNames:'archiveFileList enableStopButton fileTable currentSortOrder
		selectionHolder tableColumns commandProcess errorListHolder
		viewErrorList temporaryDirectory enableRemoveErrorOutput
		errorListVisibilityHolder hasListEntriesHolder archiver process
		terminateByMe columnDescriptors inDropMode'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

Object subclass:#ArchivItem
	instanceVariableNames:'fileName size dateAndTime permissions icon ownerGroup method crc
		compressSize ratio version type isDirectory'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook::ArchiveViewApplication
!

AbstractFileApplicationNoteBookComponent subclass:#CommandResult
	instanceVariableNames:'resultStream enableStopButton process labelHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

AbstractFileApplicationNoteBookComponent subclass:#DigitalNotepadFileViewApplication
	instanceVariableNames:'imageView image fitSize fitMode'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

AbstractFileApplicationNoteBookComponent subclass:#HtmlViewApplication
	instanceVariableNames:'htmlView labelHolder infoLabelHolder webBrowserPage'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

AbstractFileApplicationNoteBookComponent subclass:#ImageViewApplication
	instanceVariableNames:'imageFile imageView image fitSize fitMode'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

AbstractFileApplicationNoteBookComponent subclass:#Terminal
	instanceVariableNames:'terminalView scrollLockedHolder'
	classVariableNames:'DefaultLineLimit'
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

AbstractFileApplicationNoteBookComponent subclass:#TextEditor
	instanceVariableNames:'fileContentsModel modifiedChannel editView enableSave
		enableReload presentation changeItemProcess closeApplication
		semaChangeItem wantToPrintAsHexDump printAsHexDump itemChanged
		itemRemoved enableHexToggle md5CheckSum
		md5HashValueComputationProcess viewModifiedChannel
		textEditorModificationTime checkModifiedBlock fileEncodingHolder
		doNotShowFontDialog lockFileEncodingHolder enableSelectInBrowser
		tagsBrowserVisibleHolder tagsBrowser editorToolBarVisibleHolder
		editorOperationsToolBarVisibleHolder
		editorOperationsMenuSpecHolder'
	classVariableNames:'DefaultTagsBrowserVisible MaxFileSizeLoadedWithoutAsking
		DefaultEditorToolBarVisible DefaultEditorOperationsToolBarVisible'
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

AbstractFileApplicationNoteBookComponent subclass:#XMLViewApplication
	instanceVariableNames:'xmlTreeApp labelHolder infoLabelHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

AbstractFileApplicationNoteBookComponent subclass:#XViewApplication
	instanceVariableNames:'xView xFile vncServerPID vncPortNr vncConnection viewerPID
		vncLock vncServerIsTerminated xItem ext'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileApplicationNoteBook
!

!FileApplicationNoteBook class methodsFor:'documentation'!

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
    [Author:]
        Christian Penk
"
! !

!FileApplicationNoteBook class methodsFor:'application list'!

applicationList
    " returns a list of all applications to start by the NoteBookApplication with 
                #className                         #type                    

            example:
            #(  #'FooEditor'                       nil                      )
    "

    ^ #(
            #(  #'TextEditor'                        #file                    )
            #(  #'TextEditor'                        #directoryDescription    )
            #(  #'HtmlViewApplication'               nil                      )
            #(  #'FindFileApplication'               nil                      )
            #(  #'Terminal'                          nil                      )
            #(  #'ImageViewApplication'              nil                      )
            #(  #'ArchiveViewApplication'            nil                      )
            #(  #'CommandResult'                     nil                      )
            #(  #'XViewApplication'                  nil                      )
            #(  #'DigitalNotepadFileViewApplication' nil                      )
            #(  #'XMLViewApplication'                nil                      )
       )

    "Modified: / 21-02-2011 / 17:21:54 / cg"
!

classFor:aApplicationListItem
    |rawName cls|

    rawName := aApplicationListItem at:1.
    (cls := self privateClassesAt:rawName) isNil ifTrue:[
        cls := Smalltalk at:rawName.
    ].
    ^ cls
!

defaultApplication
" returns the application to be started if no itemQuery returns true or no supportedSuffix is supported
"

    ^ self applicationList detect:[: applItem|
        (((self classFor:applItem) == self textEditorClass)
        and:[(self typeFor:applItem) == #file])
    ] ifNone:[nil].
!

typeFor:aApplicationListItem

    ^ aApplicationListItem at:2
! !

!FileApplicationNoteBook class methodsFor:'classAccess'!

textEditorClass

    ^ TextEditor
! !

!FileApplicationNoteBook class methodsFor:'defaults'!

openAnotherApplicationOnSameItem

    ^ false
! !

!FileApplicationNoteBook class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook andSelector:#windowSpec
     FileApplicationNoteBook new openInterface:#windowSpec
     FileApplicationNoteBook open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'FileBrowserV2TextEditor'
          name: 'FileBrowserV2TextEditor'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (NoteBookViewSpec
              name: 'CommandAndTextEditor'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              model: selectedEditorPage
              menu: tabList
              useIndex: true
              accessTabMenuAction: tabMenuAt:
              destroyTabAction: destroyTabAt:
              canvas: canvasHolder
              keepCanvasAlive: true
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook class methodsFor:'menu specs'!

tabMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook andSelector:#tabMenu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook tabMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add Text Editor'
            itemValue: newTextEditor
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Select in Filelist'
            itemValue: doSelectInList
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Rename Tab...'
            itemValue: doRenameTab
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Close Tab'
            itemValue: doCloseApplication
            translateLabel: true
          )
         (MenuItem
            enabled: closeAllApplicationsEnabled
            label: 'Close all Tabs'
            itemValue: doCloseAllApplications
            translateLabel: true
          )
         (MenuItem
            enabled: closeAllApplicationsEnabled
            label: 'Close all but this Tab'
            itemValue: doCloseAllOtherApplications
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 27-03-2007 / 11:13:52 / cg"
! !

!FileApplicationNoteBook methodsFor:'accessing'!

listOfApplications
    "return the value of the instance variable 'listOfApplications' (automatically generated)"

    listOfApplications isNil ifTrue:[
        listOfApplications := OrderedCollection new.
    ].
    ^ listOfApplications
!

selectionHistoryList

    selectionHistoryList isNil ifTrue:[
        selectionHistoryList := OrderedCollection new.
    ].
    ^ selectionHistoryList
!

selectionHistoryList:aCol

    selectionHistoryList := aCol 
! !

!FileApplicationNoteBook methodsFor:'accessing-applications'!

getAllApplicationsByClass:aClass andType:aType
    ^ self listOfApplications 
        select:[ : appl  | 
            ((appl class = aClass)
            "and:[appl type = aType]")
        ].

    "Modified (format): / 29-11-2011 / 19:08:20 / cg"
!

getApplicationByType:aType

    ^ self listOfApplications detect:[ : appl  | 
        (appl type == aType)
    ] ifNone:[nil].
!

getIndexFor:aApplication

    | index |

    index := self listOfApplications indexOf:aApplication.
    index ~~ 0 ifTrue:[
        ^ index.
    ].
    ^ nil.
!

getSameApplicationsFor:anApplication

    ^ self listOfApplications 
        select:[:appl |
            ( (appl ~= anApplication)    
            and:[ (appl isKindOf:(anApplication class)) 
            and:[ (appl item = (anApplication item)) 
            and:[ (appl type == anApplication type) ]]])
        ].
! !

!FileApplicationNoteBook methodsFor:'actions-app-common'!

changeItem:anItem for:anAppl
    | applIndex string isDirectory iconOrNil tabItem|

    anItem notNil ifTrue:[
        isDirectory := anItem isDirectory or:[anItem linkTargetIsDirectory ].

        isDirectory ifFalse:[
            (anAppl changeItem:anItem) ifFalse:[ ^ self].
            self fileHistory addFirst:anItem.
            self enableFileHistory value:true.
        ].
    ].
    string := anAppl getTabString.
    tabItem := Text string:string.

    iconOrNil := anAppl getTabIcon.
    iconOrNil notNil ifTrue:[
        tabItem := LabelAndIcon icon:iconOrNil string:tabItem.
    ].
    applIndex := self getIndexFor:anAppl.
    self privateTabList at:applIndex put:tabItem.
    "/ self doSelect:anAppl.
!

changeModified:aSymbol for:anAppl
    |text stream|

    stream := WriteStream with:anAppl getTabString.
    aSymbol ~~ #unchanged ifTrue:[
        stream space.
        stream nextPut:$[.
        stream nextPutAll:aSymbol asString.
        stream nextPut:$].
        text := stream contents asText.
        text emphasizeAllWith:UserPreferences current emphasisForModifiedBuffer.
    ] ifFalse:[
        text := stream contents asText.
    ].

    self tabStringChangeTo:text for:anAppl.
!

closeSubCanvas:aApplication

    | applIndex historyList localHistoryList selectedPage|

    applIndex := self getIndexFor:aApplication.
    applIndex notNil ifTrue:[
"/        "/ UPDATE THE LAST SELECTION BECAUSE SEL INDEX IS DECREMENTED FOR HIGHER INDEXES
"/        self lastSelection:applIndex.

        historyList := self selectionHistoryList.
        historyList remove:applIndex ifAbsent:nil.
        localHistoryList := OrderedCollection new.
        historyList notEmpty ifTrue:[
            selectedPage := historyList last.
        ] ifFalse:[
            selectedPage := 1.
        ].  
        self selectedEditorPage value:selectedPage.

        historyList do:[ : index |
            index <= applIndex ifTrue:[
                localHistoryList add:index
            ] ifFalse:[
                localHistoryList add:(index - 1)
            ]
        ].
        self selectionHistoryList:localHistoryList.
        self listOfApplications removeIndex:applIndex.
        self privateTabList removeIndex:applIndex.
        self privateTabList isEmpty ifTrue:[
            self viewNoteBookApplicationHolder value:false.
            self enableViewNoteBookApplication value:false.
            self changeFileBrowserTitleTo:'FileBrowser V2'.

        ] ifFalse:[
            historyList notEmpty ifTrue:[
                self selectedEditorPage value:(self selectionHistoryList last).
            ]
        ]
    ].

    "/ because subCanvas was configured to keep its view,
    "/ we must destroy it here.
    aApplication window destroy.
!

destroyTab:tabIndex
    (self listOfApplications at:tabIndex) doClose
!

doCloseAllApplications
    | appl |

    (Dialog confirm:(resources string:'Really close all Tabs ?')) ifFalse:[^ self].

    appl := self listOfApplications copy do:[:eachApp | eachApp doClose.].
!

doCloseAllOtherApplications
    | appl currentApp |

"/    (Dialog confirm:(resources string:'Really close all Tabs ?')) ifFalse:[^ self].

    currentApp := self currentTabMenusApplication.
    appl := self listOfApplications copy do:
        [:eachApp | 
            eachApp ~~ currentApp ifTrue:[
                eachApp doClose.
            ].
        ]
!

doCloseApplication
    self currentTabMenusApplication doClose.
!

doRenameTab
    | newLabel |

    newLabel := Dialog 
                    request:'New Tab Label:' 
                    initialAnswer:(self privateTabList at:tabMenuIndex).
    newLabel size == 0 ifTrue:[^ self ].
    self privateTabList at:tabMenuIndex put:newLabel
!

doSelectInList
    | fileName|

    fileName := self currentTabMenusApplication fileName.
    fileName notNil ifTrue:[
        self gotoFile:fileName.
    ].
!

openApplByFileItem:anItem
    "open a new embedded app, or a standard system command (for example pdf reader).
     return the new app or nil, if none was embedded.
     Uses the default class list for open of applications by item "

    | applList applItem itemClass itemType appl|

    anItem isNil ifTrue:[ ^ nil ].
    anItem isDirectory ifTrue:[
        self warn:'No Application to open for directory:', anItem fileName asString, ' found'.
        ^ nil.
    ].

    self openAlwaysInTextEditor value ifFalse:[
        applList := self applicationList.
        applItem := applList 
                        detect:[:eachApplItem|
                            itemClass := self class classFor:eachApplItem.
                            (itemClass canOpenItem:anItem).
                        ] ifNone:[nil].

        applItem notNil ifTrue:[ 
            itemType := self class typeFor:applItem.
            itemClass := self class classFor:applItem.
            Error handle:[:ex |
                "/ catching the error, so we can still show text
            ] do:[
                appl := self openApplicationClass:itemClass withItem:anItem withType:itemType.
                appl notNil ifTrue:[ ^ appl].
            ].
        ].
        self alwaysUseSmalltalkTools value ifFalse:[
            ((anItem fileName mimeTypeOfContents ? '') startsWith:'text') ifFalse:[
                "/ fallback: open a system utility
                OperatingSystem 
                    openApplicationForDocument:anItem fileName 
                    operation:#open
                    mimeType:nil 
                    ifNone:[self openDefaultApplicationByItem:anItem].
                ^ nil.
            ].            
        ].
    ].

    ^ self openDefaultApplicationByItem:anItem.

    "Modified: / 16-09-2011 / 16:17:58 / cg"
!

openApplicationClass:aClass withItem:anItem withType:aType

    ^ self 
        openApplicationClass:aClass 
        withItem:anItem 
        withType:aType 
        checkExisting:true

    "Modified (format): / 12-01-2012 / 01:10:50 / cg"
!

openApplicationClass:aClass withItem:anItem withType:aType checkExisting:checkExisting 
    ^ self 
        openApplicationClass:aClass
        withItem:anItem
        withType:aType
        checkExisting:checkExisting
        preSetItem:nil

    "Modified (format): / 29-11-2011 / 19:06:27 / cg"
!

openApplicationClass:aClass withItem:anItem withType:aType checkExisting:checkExisting preSetItem:aBlock
    |existingAppl newAppl|

    "do not open unreadable items"
    checkExisting ifTrue:[
        (anItem notNil and:[anItem isDirectory not and:[anItem fileName isReadable not]]) ifTrue:[
            Dialog warn:(resources string:'Can not open unreadable file "%1"' with:anItem fileName baseName).
            AbortOperationRequest raise.
        ].
        existingAppl := self tryToGetExistingApplFor:aClass withItem:anItem withType:aType preSetItem:aBlock.
        existingAppl notNil ifTrue:[
            self doSelect:existingAppl.
            ^ existingAppl
        ].
    ].

    newAppl := aClass new.
    newAppl masterApplication:self.
    aBlock notNil ifTrue:[
        aBlock value:newAppl.    
    ].
    newAppl type:aType.

    newAppl isTextEditor ifTrue:[
        newAppl fileEncoding:(self fileEncodingHolder value).    
        newAppl lockFileEncoding:(self lockFileEncodingHolder value).    
    ].
    (newAppl item:anItem) ifFalse:[ ^ nil ].
    (anItem notNil and:[(anItem isDirectory not) and:[aType ~= #directoryDescription]]) ifTrue:[
        self fileHistory addFirst:anItem.
        self enableFileHistory value:true.
    ].
    self setSameFileIndexFor:newAppl.
    self startApplication:newAppl.
    ^ newAppl

    "Modified (format): / 29-11-2011 / 19:06:47 / cg"
!

openDefaultApplicationByItem:anItem
" open the default application if no application for item is available or the start of the
  available application failed
"
    | applItem |

    applItem := self class defaultApplication.
    applItem notNil ifTrue:[
        |  itemType itemClass|
        itemType := self class typeFor:applItem.
        itemClass := self class classFor:applItem.
        ^ self openApplicationClass:itemClass withItem:anItem withType:itemType.
    ].
    ^ nil
!

setSameFileIndexFor:anAppl
    |sameFiles index item|

    self class openAnotherApplicationOnSameItem ifFalse:[
        anAppl sameFileIndex:nil.
        ^ self.
    ].

    item := anAppl item.
    item notNil ifTrue:[
        sameFiles := self getSameApplicationsFor:anAppl.
        (sameFiles notEmpty) ifTrue:[
            (sameFiles size == 1 and:[sameFiles first sameFileIndex isNil]) ifTrue:[
                anAppl sameFileIndex:1.
            ] ifFalse:[
                index :=  (sameFiles collect:[:el | (el sameFileIndex ? 1)]) max.
                anAppl sameFileIndex:index + 1.
            ].
            ^ self
        ]. 
        anAppl sameFileIndex:nil.
    ].

    "Modified (format): / 24-07-2011 / 08:22:03 / cg"
!

startApplication:anApplication
    "start a subapplication in the lower panel (terminal, finder, archive viewer or text editor)"

    | window tabItem iconOrNil|

    anApplication window isNil ifTrue:[
        window := ApplicationSubView new.
        anApplication createBuilder.
        window client:anApplication.
    ].
    self listOfApplications add:anApplication.

    tabItem := Text string:(anApplication getTabString).
    iconOrNil := anApplication getTabIcon.
    iconOrNil notNil ifTrue:[
        tabItem := LabelAndIcon icon:iconOrNil string:tabItem.
    ].
    self privateTabList add:tabItem.
    self viewNoteBookApplicationHolder value:true.
    self enableViewNoteBookApplication value:true.
    self withWaitCursorDo:[
        self doSelect:anApplication.
    ].
    anApplication postOpenWith:anApplication builder.
!

tabStringAdd:aString for:anAppl
    | index text stream|

    index := self getIndexFor:anAppl.
    index isNil ifTrue:[ ^ self].
    text := self privateTabList at:index.
    stream := CharacterWriteStream new.
    stream nextPutAll:text string.
    stream space.
    stream nextPutAll:aString.
    self privateTabList at:index put:(Text string:(stream contents)).
!

tabStringChangeTo:aString for:anAppl

    | index text tabItem |

    index := self getIndexFor:anAppl.
    index isNil ifTrue:[ ^ self].

    text := Text string:aString.

    tabItem := self privateTabList at:index.
    tabItem class == LabelAndIcon ifTrue:[
        text := LabelAndIcon icon:(tabItem icon) string:text.
    ].

    self privateTabList at:index put:text.
    self selectedEditorPage value == index ifTrue:[
        self changeFileBrowserTitleTo:aString.
    ].
!

tryToGetExistingApplFor:aClass withItem:anItem withType:aType preSetItem:aBlock
    | sameAppls changeAppl selAppl|

    aClass wantNewApplicationAnyway ifTrue:[^ nil].
    sameAppls := self getAllApplicationsByClass:aClass andType:aType.
    sameAppls isEmpty ifTrue:[^ nil].
    ((aType == #directoryDescription) or:[aType == #commandResult]) ifTrue:[
"/        sameAppls := sameAppl first.
    ] ifFalse:[
        (self openMultipleApplicationsForType value) ifTrue:[
        "/ open more than one application for a class and a type
            (self class openAnotherApplicationOnSameItem) ifTrue:[
                "/ open a new application anyway, no matters if item already open
                ^ nil
            ] ifFalse:[
                "/ if item already changed select the application
                selAppl := sameAppls detect:[:appl | (appl item = anItem) ] ifNone:[nil].
            ].
        ] ifFalse:[
            "/ keep in same application change the first application of the same class and type - if item not changed otherwise open new
            sameAppls := sameAppls reject:[:appl | appl isModified ].
        ].
    ].
    sameAppls size ~~ 0 ifTrue:[
        " take first all applications which have nil items 
          second the selected 
          third the first
        "
        | nilItemAppls |

        nilItemAppls := sameAppls select:[:appl| appl item == nil ].
        nilItemAppls notEmpty ifTrue:[sameAppls := nilItemAppls].
        (sameAppls includes:self selectedApplication) ifTrue:[
            changeAppl := self selectedApplication.
        ] ifFalse:[
            changeAppl := sameAppls first.
        ].
        aBlock notNil ifTrue:[
            aBlock value:changeAppl.
        ].
        changeAppl type:aType.
        self changeItem:anItem for:changeAppl.
        selAppl := changeAppl.
    ].
    ^ selAppl.

    "Modified (format): / 29-11-2011 / 19:07:57 / cg"
! !

!FileApplicationNoteBook methodsFor:'actions-app-spec'!

addTerminalIn:aDirectory
    |item|

    item := DirectoryContentsBrowser itemClass fileName:aDirectory.
    self openTerminalApplication:item.
!

changeDirectoryDescription

    | aInfoItem|

    aInfoItem := self getInfoItem.
    aInfoItem isNil ifTrue:[ ^ self closeDirectoryDescription ].
    self openDirectoryDescription.
!

closeAllApplicationsEnabled
    ^ tabList value size > 1
!

closeDirectoryDescription

    | dirContApll |

    dirContApll := self getApplicationByType:#directoryDescription.
    dirContApll notNil ifTrue:[
        dirContApll doClose.
    ].
!

doAddArchiverOn:aFilename
    |item|

    item := DirectoryContentsBrowser itemClass fileName:aFilename.
    self openArchiveViewApplication:item.

    "Created: / 29-11-2011 / 19:05:49 / cg"
!

newTextEditor

    ^ self openApplicationClass:TextEditor withItem:nil withType:#file checkExisting:false 
!

openArchiveViewApplication:anItem
    | result |

    result := self openApplicationClass:ArchiveViewApplication withItem:anItem withType:nil.
    result isNil ifTrue:[
        Dialog warn:'file type of ', anItem fileName baseName, ' not yet supported'.
        ^ self.
    ].

    "Modified (format): / 29-11-2011 / 18:57:21 / cg"
!

openCommandResultApplication


    ^ self openApplicationClass:CommandResult withItem:nil withType:#commandResult
!

openCompareDirectory:directory1 with:directory2
    |newAppl|

    newAppl := DirectoryDifferenceViewApplication new.
    newAppl masterApplication:self.
    newAppl directory1:directory1 directory2:directory2.

    self setSameFileIndexFor:newAppl.
    self startApplication:newAppl.
    ^ newAppl

    "Created: / 12-01-2012 / 01:10:05 / cg"
!

openDirectoryDescription

    | appl aInfoItem|

    aInfoItem := self getInfoItem.
    aInfoItem notNil ifTrue:[
        appl := self openTextEditorOn:aInfoItem type:#directoryDescription.
    ].
!

openNewTextEditorOn:anItem 

    ^ self openApplicationClass:TextEditor withItem:anItem withType:#file checkExisting:false.
!

openSearchFileOn:anItem

    ^ self 
        openApplicationClass:FindFileApplication 
        withItem:anItem 
        withType:nil 
        checkExisting:false

    "Modified (format): / 12-01-2012 / 01:02:30 / cg"
!

openTerminalApplication:anItem

    ^ self openApplicationClass:Terminal withItem:anItem withType:nil
!

openTextEditor

    ^ self openTextEditorOn:nil 
!

openTextEditorForFile:aFilename 

    ^ self openTextEditorOn:(DirectoryContentsBrowser itemClass fileName:aFilename) type:#file 
!

openTextEditorOn:anItem 

    ^ self openTextEditorOn:anItem type:#file 
!

openTextEditorOn:anItem type:aDirDescrOrFile

    ^ self openApplicationClass:TextEditor withItem:anItem withType:aDirDescrOrFile
!

openTextEditorWithHexPresentationOn:anItem 

    ^ self  openApplicationClass:TextEditor 
            withItem:anItem 
            withType:#file 
            checkExisting:true 
            preSetItem:[:aTextEditor | aTextEditor presentation:#hexDump].
! !

!FileApplicationNoteBook methodsFor:'applicationlist access'!

applicationList
    ^ self class applicationList
! !

!FileApplicationNoteBook methodsFor:'aspects'!

canvasHolder

    canvasHolder isNil ifTrue:[
        canvasHolder := ValueHolder new.
        canvasHolder addDependent:self.
    ].
    ^ canvasHolder.
!

cursorColLabelHolder
    ^ self 
        aspectFor:#cursorColLabelHolder 
        ifAbsent:[
            IndirectValue for:(' ' asValue)
        ]
!

cursorLineAndColumnLabelHolder
    ^ self 
        aspectFor:#cursorLineAndColumnLabelHolder 
        ifAbsent:[
            IndirectValue for:(' ' asValue)
        ]
!

cursorLineLabelHolder
    ^ self 
        aspectFor:#cursorLineLabelHolder 
        ifAbsent:[
            IndirectValue for:(' ' asValue)
        ]
!

fileEncodingHolder
    ^ self 
        aspectFor:#fileEncodingHolder 
        ifAbsent:[
            IndirectValue for:('iso8859-1' asValue)
        ]
!

inputTabColumnConversionHolder
    ^ self 
        aspectFor:#inputTabColumnConversionHolder 
        ifAbsent:[
            IndirectValue for:(8 asValue)
        ]

    "Created: / 06-01-2012 / 15:26:32 / cg"
!

lineEndConventionHolder
    ^ self 
        aspectFor:#lineEndConventionHolder 
        ifAbsent:[
            IndirectValue for:(#'nl' asValue)
        ]

    "Created: / 06-01-2012 / 13:03:24 / cg"
!

lockFileEncodingHolder
    ^ self 
        aspectFor:#lockFileEncodingHolder 
        ifAbsent:[
            IndirectValue for:(false asValue)
        ]
!

modeLabelHolder
    ^ self 
        aspectFor:#modeLabelHolder 
        ifAbsent:[
            IndirectValue for:(' ' asValue)
        ]
!

modeLabelMenu       
    |app|

    (app := self selectedApplication) notNil ifTrue:[
        ^ app modeLabelMenu
    ].
    ^ nil

    "Created: / 11-09-2006 / 12:33:27 / cg"
!

modeLabelMenuHolder
    ^ self 
        aspectFor:#modeLabelMenuHolder 
        ifAbsent:[
            IndirectValue for:(nil asValue)
        ]

    "Created: / 11-09-2006 / 12:28:08 / cg"
!

privateTabList

    privateTabList isNil ifTrue:[
        privateTabList := List new.
        privateTabList addDependent:self.
    ].
    ^ privateTabList.
!

selectedEditorPage

    selectedEditorPage isNil ifTrue:[
        selectedEditorPage := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
       selectedEditorPage addDependent:self.
"/       selectedEditorPage onChangeSend:#selectedEditorPageChanged to:self.
    ].
    ^ selectedEditorPage.
!

tabList

    tabList isNil ifTrue:[
        tabList := (List new) asValue.
    ].
    ^ tabList.
!

tabList:aValue

    tabList := aValue.
! !

!FileApplicationNoteBook methodsFor:'change & update'!

canvasChanged
    "invoked when the contentsView has been changed"

    |app|

    app := self selectedApplication.

    self cursorLineLabelHolder valueHolder: (app cursorLineLabelHolder).
    self cursorColLabelHolder valueHolder: (app cursorColLabelHolder).
    self cursorLineAndColumnLabelHolder valueHolder: (app cursorLineAndColumnLabelHolder).
    self modeLabelHolder valueHolder: (app modeLabelHolder).
    self fileEncodingHolder valueHolder: (app fileEncodingHolder).

    app lockFileEncodingHolder isBoolean ifTrue:[
        self breakPoint:#cg
    ] ifFalse:[
        self lockFileEncodingHolder valueHolder: (app lockFileEncodingHolder).
    ].

    "Modified: / 11-09-2006 / 12:44:07 / cg"
!

update:something with:aParameter from:changedObject
    | appl sel|

    changedObject == canvasHolder ifTrue:[
        self canvasChanged.
        ^ self.
    ].
    changedObject == self currentDirectories ifTrue:[
        self viewDirectoryDescription value ifTrue:[
            self changeDirectoryDescription.  
        ].
        ^ self.
    ].
    changedObject == self viewDirectoryDescription ifTrue:[
        self viewDirectoryDescriptionChanged.
        ^ self.
    ].
    changedObject == self privateTabList ifTrue:[
        | privateListOfTabs |
        privateListOfTabs := changedObject.
        privateListOfTabs size > 1 ifTrue:[
            self tabList value:privateListOfTabs.
            self tabList changed.
        ] ifFalse:[
            self tabList value:nil.
        ].
        ^ self
    ].
    changedObject == self selectedEditorPage ifTrue:[
        | listOfEdits indexOfLastSel list |

        sel := changedObject value.
        "/ don't want the tabs with one application - that's why i have to change my tablist
        "/ sel goes to if - i want select the last selection
        sel = 0 ifTrue:[
            ^ self.
        ].
        list := self selectionHistoryList.
        (list includes:sel) ifTrue:[
            list remove:sel
        ].
        list add:sel.
        self selectionHistoryList:list.
        appl := self listOfApplications at:sel.
        self doSelect:appl.
    ].

    ^ super update:something with:aParameter from:changedObject
!

viewDirectoryDescriptionChanged


    |viewDirDescr|

    viewDirDescr := self viewDirectoryDescription value.
    viewDirDescr ifTrue:[
        self openDirectoryDescription.
    ] ifFalse:[
        self closeDirectoryDescription.
    ].
    ^ self.
! !

!FileApplicationNoteBook methodsFor:'menu & actions'!

destroyTabAt:idx
    |app|

    app := listOfApplications at:idx.
    self closeSubCanvas:app.        
    app release.

    "Created: / 11-01-2012 / 23:46:09 / cg"
!

tabMenuAt:aTab
    |menu|

    menu :=  Menu decodeFromLiteralArray:self class tabMenu.
    tabMenuIndex := aTab.
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 27-03-2007 / 10:57:25 / cg"
! !

!FileApplicationNoteBook methodsFor:'queries'!

getSameFilesModifiedFor:aAppl

    | sameFileAppl colOfChanged |

    sameFileAppl := self getSameApplicationsFor:aAppl.
    sameFileAppl notEmpty ifTrue:[
        colOfChanged := OrderedCollection new.
        sameFileAppl do:[ : el |
            el modifiedChannel value ifTrue:[
                colOfChanged add:el.
            ]
        ]
    ].
    ^ colOfChanged
! !

!FileApplicationNoteBook methodsFor:'selection'!

currentTabMenusApplication
    "only valid within menu processing"

    ^ self listOfApplications at:tabMenuIndex
!

doSelect:anAppl

    | index fileName additionalInfo|

    fileName := anAppl fileName.
    index := self getIndexFor:anAppl.
    self changeFileBrowserTitleTo:(self privateTabList at:index ifAbsent:nil).
    
    additionalInfo := anAppl additionalInfo.
    self notify:(fileName isNil 
                    ifTrue:[additionalInfo] 
                    ifFalse:[(fileName asString contractAtBeginningTo:80),' ',additionalInfo]).
"/        self gotoFile:fileName.
    index notNil ifTrue:[
        canvasHolder value:(anAppl window).
        self selectedEditorPage value:index.
    ]

    "Modified: / 24-10-2006 / 12:32:53 / cg"
!

selectedApplication
    | canvas |

    canvas := self canvasHolder value.
    canvas isNil ifTrue:[ ^ nil].
    ^ canvas application.
! !

!FileApplicationNoteBook methodsFor:'startup & release'!

closeRequest
    "asks for permission before closing"

    self tryCloseApplications ifTrue:[
        super closeRequest.
        ^ true
    ].
    ^ false.
!

makeDependent

    self viewDirectoryDescription addDependent:self.
    self currentDirectories addDependent:self.
!

postOpenAsSubcanvasWith:aBuilder

    self viewDirectoryDescriptionChanged.
    super postOpenAsSubcanvasWith:aBuilder.
!

postOpenWith:aBuilder
    "only invoked if the application not started from a master"

    self openTextEditorOn:(DirectoryContentsBrowser itemClass fileName:(Filename homeDirectory construct:'.bashrc')).
    super postOpenWith:aBuilder
!

preBuildWith:aBuilder

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
    ].
    super preBuildWith:aBuilder.
!

tryCloseApplications

    self listOfApplications do:[:appl|
        appl doClose ifFalse:[
            ^ false.
        ].
    ].
    ^ true
! !

!FileApplicationNoteBook::ArchiveViewApplication class methodsFor:'defaults'!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'Archive %1'

    "Modified: / 01-03-2007 / 21:43:13 / cg"
! !

!FileApplicationNoteBook::ArchiveViewApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::ArchiveViewApplication    
    "

    <resource: #help>

    ^super flyByHelpSpec addPairsFrom:#(

#closeTabButton
'Close Archiver Tab'

#extractItem
'Extract...'

#removeOutputButton
'Remove Error Output'

#stopButton
'Stop'

)
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::ArchiveViewApplication    
    "

    <resource: #help>

    ^super helpSpec addPairsFrom:#(

#closeButton
'Close Archiver'

#extractItem
'Extract...'

#removeOutputButton
'Remove Error Output'

#stopButton
'Stop'

)
! !

!FileApplicationNoteBook::ArchiveViewApplication class methodsFor:'image specs'!

extract28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self extract28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#extract28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'FileApplicationNoteBook::ArchiveViewApplication class extract28x28Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3L3L3L@@@@@@@@@@@@CQDMDP0@@@@@EUUAP@@L3L3L3@@@ @PUUTA@@@4QCQDL@@BHAAUUPD@@CL3L3L"H"H"DEUU
@P@@MDP4QBH"H"H @@@A@@@3L3L3H"H"H!!DQDQD@@CQDMDP0@@H DP@@@P@@L3L3L3@@@ @Q@ETA@@@4QCQDL@@@@AD@UPD@@CL3L3L0@@@@@@@@@@@@MDP4
QC@@@@@@@@@@@@@3L3L3L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 129 129 129 255 0 0 255 255 255 105 133 190 194 194 194 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G?0@@A?<G? _?A?8G?1_>A?<_? _???8G???>A???? _?G?8G?1_>A?<G? _?@?0G?0@@A?<@@@_?@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

removeBug28x28Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self removeBug28x28Icon inspect
     ImageEditor openOnClass:self andSelector:#removeBug28x28Icon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'FileApplicationNoteBook::ArchiveViewApplication class removeBug28x28Icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUUT@@@@@@@@@@@@@@@@@@@B*@@@@@J(@J(@@@@J(@@* @@@J(@@B*@@@J(@@@J(@@J(@@@@* @J(@@@@B(@J+0@@@@J :*+@@@@B*:**,@@@O*****
0@@C:****,@@@N**@@@@@@O*****0@@@>+***<@@@B(N*?0@@@B*@J+0@@@B*@@* @@@B*@@B*@@@B*@@@J(@@B*@@@@* @B*@@@@B*@B*@@@@@J(@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 192 192 192 255 0 0 128 0 0 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@O@@C0A8@A8@O@@<@A80^@@O#O0@A>_1@@N/>@@A??0@@??>@G??? BG??8@A??>@G??? @???8@@_?<@@O/>@@G9?D@C83<@A80^@@<@
C0@^@@^@O@@C0@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

removeError
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self removeError inspect
     ImageEditor openOnClass:self andSelector:#removeError
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'FileApplicationNoteBook::ArchiveViewApplication class removeError'
        ifAbsentPut:[
            (Depth8Image new)
                width:28;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@FA @@@@@@@@XF@@@@@@@@@@@@@@@@@@@@@@@@@@XF@@@@@@XF@@@@@@@@@@@@@@@@@@@@@@@@@@@@A X@@@XF@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@FA XF@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@XF@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@XFA X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@XF
@@@FA @@@@@@@@@@@@@@@@@@@@@@@@@@@@XF@@@@@@XF@@@@@@@@@@@@@@@@@@@@@@@@@@XF@@@@@@@@A X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 8 4 8 105 133 190 121 133 157 129 129 129 194 194 194 255 0 0 ];
                mask:((ImageMask new)
                            width:28;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@LC@@@A!! @@@L0@@@A8@@@@L@@@@G @@@CL@@@A!! @@@0L@@@@@@@BY=5LAIUUT S5UU8D!!UUPAFU\#@@@@@@@LR9@@D)J @A:R(@@P$*@@CIN @@@@@@@@@a');
                            yourself);
                yourself
        ]
! !

!FileApplicationNoteBook::ArchiveViewApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::ArchiveViewApplication andSelector:#windowSpec
     FileApplicationNoteBook::ArchiveViewApplication new openInterface:#windowSpec
     FileApplicationNoteBook::ArchiveViewApplication open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Archive Application'
          #name: 'Archive Application'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 16 46 692 538)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'MenuArchive'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              #level: 0
              #menu: #menu
              #textDefault: true
            )
           #(#'FileBrowserV2UISpecifications::PanelSpec'
              #name: 'VerticalPanel'
              #layout: #(#LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
              #level: 0
              #whichView: #last
              #orientation: #vertical
              #visibility: #errorListVisibilityHolder
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#DataSetSpec
                    #name: 'Table1'
                    #model: #selectionHolder
                    #menu: #fileListMenu
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #dataList: #archiveFileList
                    #useIndex: false
                    #has3Dsepartors: false
                    #doubleClickSelector: #dblClick
                    #columnHolder: #tableColumns
                    #multipleSelectOk: true
                    #verticalSpacing: 0
                    #postBuildCallback: #postBuildFileTable:
                    #properties: 
                   #(#PropertyListDictionary
                      #enterSelector: #dropEnter:
                      #dragArgument: #archivApplication
                      #startDragSelector: #doStartDrag:in:
                      #displayObjectSelector: #getDisplayObjects:
                      #dropObjectSelector: #getDropObjects:
                      #overSelector: nil
                      #dropArgument: #archivApplication
                      #canDropSelector: #canDrop:
                      #leaveSelector: #dropLeave:
                      #dropSelector: #doDrop:
                    )
                  )
                 #(#SequenceViewSpec
                    #name: 'ErrorList'
                    #initiallyDisabled: true
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #backgroundColor: #(#Color 100.0 100.0 100.0)
                    #isMultiSelect: true
                    #useIndex: false
                    #sequenceList: #errorListHolder
                  )
                 )
               
              )
              #handles: #(#Any 0.5 1.0)
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::ArchiveViewApplication class methodsFor:'menu specs'!

fileListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook::ArchiveViewApplication andSelector:#fileListMenu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::ArchiveViewApplication fileListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #enabled: #hasListEntriesHolder
            #label: 'Select All'
            #itemValue: #selectAll
            #translateLabel: true
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #enabled: #hasSelectionInList
            #label: 'Copy Filenames'
            #itemValue: #copyFilesToClipboard
            #translateLabel: true
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #enabled: #hasSelectionInList
            #label: 'Extract to Directory...'
            #itemValue: #extractSelection
            #translateLabel: true
          )
         #(#MenuItem
            #label: 'Extract All to Directory...'
            #itemValue: #extractAll
            #translateLabel: true
          )
         #(#MenuItem
            #enabled: #canDelete
            #label: 'Delete from Archive'
            #itemValue: #removeFilesFromArchive
            #translateLabel: true
            #shortcutKey: #Delete
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #enabled: #canViewFile
            #label: 'Show Contents'
            #itemValue: #viewFile
            #translateLabel: true
            #isVisible: #closeButtonShown
          )
         )
        nil
        nil
      )

    "Modified: / 12-01-2012 / 00:34:13 / cg"
!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook::ArchiveViewApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::ArchiveViewApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #activeHelpKey: #stopButton
            #enabled: #enableStopButton
            #label: 'Stop'
            #itemValue: #doStopProcess
            #nameKey: #Stop
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #stop22x22Icon)
          )
         #(#MenuItem
            #activeHelpKey: #extractItem
            #enabled: #hasListEntriesHolder
            #label: 'Extract'
            #itemValue: #extractAll
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever #'FileApplicationNoteBook::ArchiveViewApplication' #extract28x28Icon)
          )
         #(#MenuItem
            #activeHelpKey: #removeOutputButton
            #enabled: #enableRemoveErrorOutput
            #label: 'Remove Output'
            #itemValue: #removeErrorOutput
            #translateLabel: true
            #isButton: true
            #labelImage: #(#ResourceRetriever #'FileApplicationNoteBook::ArchiveViewApplication' #removeBug28x28Icon)
          )
         #(#MenuItem
            #activeHelpKey: #closeTabButton
            #label: 'Close'
            #itemValue: #doClose
            #translateLabel: true
            #isButton: true
            #startGroup: #right
            #isVisible: #closeButtonShown
            #hideMenuOnActivated: false
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #removeTabIcon)
          )
         )
        nil
        nil
      )

    "Modified: / 12-01-2012 / 00:34:06 / cg"
! !

!FileApplicationNoteBook::ArchiveViewApplication class methodsFor:'queries'!

canOpenItem:anItem
    |suffix mimeType|

"/    "avoid autoloading the archiver if its definitely not an archive"
"/    OperatingSystem isUNIXlike ifFalse:[
"/        "until Archiver supports windows archives..."
"/        ^ false.
"/    ].

    suffix := anItem fileName suffix asLowercase.
    ( #('c' 'h' 'bat' 'sh') includes:suffix) ifTrue:[^ false].

    ( #('xlsx' 'ets') includes:suffix) ifTrue:[^ true].

    mimeType := anItem mimeType.
    ( #('application/x-make') includes:mimeType) ifTrue:[^ false].

    Archiver isNil ifTrue:[^ false].
    ^ (Archiver classForMimeType:mimeType fileName:anItem fileName) notNil

    "Modified: / 29-11-2011 / 18:59:35 / cg"
!

wantNewApplicationAnyway

    ^ false
! !

!FileApplicationNoteBook::ArchiveViewApplication class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:FileApplicationNoteBook::ArchiveViewApplication andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         labelButtonType: Button
         labelActionSelector: sortFileListsBy:
         labelActionArgument: 'directory'
         width: 25
         minWidth: 20
         height: 16
         model: icon
         canSelect: false
         isResizeable: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'File Name'
         id: 'fileName'
         labelAlignment: left
         labelButtonType: Button
         model: fileName
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Perm'
         id: 'permissions'
         labelButtonType: Button
         usePreferredWidth: true
         width: 75
         model: permissions
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Version'
         id: 'version'
         labelButtonType: Button
         columnAlignment: right
         width: 100
         minWidth: 50
         model: version
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Type'
         id: 'type'
         labelButtonType: Button
         columnAlignment: right
         width: 100
         minWidth: 50
         model: type
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Owner/Group'
         id: 'ownerGroup'
         labelButtonType: Button
         columnAlignment: right
         width: 100
         minWidth: 50
         model: ownerGroup
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Size'
         id: 'size'
         labelButtonType: Button
         columnAlignment: right
         width: 80
         model: size
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Date & Time'
         id: 'dateAndTime'
         labelAlignment: right
         labelButtonType: Button
         columnAlignment: right
         usePreferredWidth: true
         width: 140
         model: dateAndTime
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Method'
         id: 'method'
         labelButtonType: Button
         columnAlignment: center
         usePreferredWidth: true
         width: 140
         model: method
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'CRC'
         id: 'crc'
         labelButtonType: Button
         usePreferredWidth: true
         width: 140
         model: crc
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Compress Size'
         id: 'compressSize'
         labelButtonType: Button
         columnAlignment: right
         usePreferredWidth: true
         width: 140
         model: compressSize
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Ratio'
         id: 'ratio'
         labelButtonType: Button
         columnAlignment: right
         usePreferredWidth: true
         width: 140
         model: ratio
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'accessing'!

archiver
    "return the value of the instance variable 'archiver' (automatically generated)"

    ^ archiver
!

archiver:something
    "set the value of the instance variable 'archiver' (automatically generated)"

    archiver := something.
!

columnDescriptors
    "return the value of the instance variable 'columnDescriptors' (automatically generated)"

    ^ columnDescriptors
!

columnDescriptors:aListOfColumns
    "set the value of the instance variable 'columnDescriptors' (automatically generated)"

    columnDescriptors = aListOfColumns ifTrue:[
        ^ self
    ].

    columnDescriptors    := OrderedCollection new.

    aListOfColumns keysAndValuesDo:[:anIndex :aDesc| |col|
        col := aDesc isSequenceable ifTrue:[DataSetColumnSpec decodeFromLiteralArray:aDesc]
                                   ifFalse:[aDesc].
        columnDescriptors add:col.
    ].

    "Modified: / 27-03-2007 / 08:46:06 / cg"
!

item:anItem
    super item:anItem.

    self removeErrorOutput.
    archiver := Archiver newFor:self fileName.

    archiver notNil ifTrue:[
        self 
            makeProcessFor:[
                self archiver:archiver.
                self setColumnsForArchiver.
            ] 
            with:'Setup archive'.
        ^ true
    ]. 
    ^ false
!

temporaryDirectory
    "return the value of the instance variable 'temporaryDirectory' (automatically generated)"

    temporaryDirectory isNil ifTrue:[
        temporaryDirectory := Filename newTemporaryDirectory.
    ].
    ^ temporaryDirectory
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'actions'!

changeItem:anItem 
    self item:anItem.
    self clearFileList.
    self listAllFiles.
    ^ true
!

clearFileList

    self archiveFileList value removeAll.
!

copyFilesToClipboard
    |sel list stream|

    sel := self selectionHolder value.
    list := self archiveFileList.
    (sel notEmptyOrNil) ifTrue:[
        stream := CharacterWriteStream new.
        sel do:[: key |
            stream nextPutAll:(key fileName asString).
            stream cr.
        ].
        self window setClipboardText:stream contents.
    ].

    "Modified (format): / 29-11-2011 / 18:57:40 / cg"
!

dblClick

    self viewFile.
!

doStopProcess
    | archiver |

    self stopProcess.
    archiver := self archiver.
    archiver notNil ifTrue:[
        self archiver stopProcess.
    ].
    self enableStopButton value:false.

    "Modified (format): / 29-11-2011 / 18:57:50 / cg"
!

removeErrorOutput

    self viewErrorList value:false.
    self errorListHolder removeAll.
!

removeTemporaryDirectory

    temporaryDirectory notNil ifTrue:[
        temporaryDirectory removeDirectory.
        temporaryDirectory := nil.
    ].
!

selectAll

    | sel listOfFiles|

    sel := OrderedCollection new.
    listOfFiles := self archiveFileList value.
    1 to:(listOfFiles size) do:[ : el |
        sel add:el
    ].
    self selectionHolder value:sel.
!

updateFileBrowserIfPresentWith:aDirectory

    | master|

    master := self masterApplication.
    master notNil ifTrue:[
        master updateAndSelect:(OrderedCollection with:aDirectory).
    ].
!

viewFile

    | master item file tempDir|

    self canViewFile ifFalse:[^ self].
    master := self masterApplication.
    self selectionHolder value size = 1 ifFalse:[
        Dialog warn:'only one file have to be selected'.
        ^ self.
    ].
    tempDir := self temporaryDirectory.
    self extractSelectedFilesTo:tempDir askForExtractOptions:false.
    process notNil ifTrue:[
        process waitUntilTerminated.
    ].
    file := tempDir construct:self selectionHolder value first fileName.
    file exists ifTrue:[
        item := DirectoryContentsBrowser itemClass fileName:file.
    ].
    master notNil ifTrue:[
        master openApplByFileItem:item.
    ].
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'aspects'!

archiveFileList

    archiveFileList isNil ifTrue:[
        archiveFileList := List new.
        archiveFileList addDependent:self.
    ].
    ^ archiveFileList.
!

enableRemoveErrorOutput
    "return/create the 'enableRemoveErrorOutput' value holder (automatically generated)"

    enableRemoveErrorOutput isNil ifTrue:[
        enableRemoveErrorOutput := false asValue.
    ].
    ^ enableRemoveErrorOutput
!

enableStopButton

    enableStopButton isNil ifTrue:[
        enableStopButton := false asValue.
    ].
    ^ enableStopButton
!

errorListHolder

    errorListHolder isNil ifTrue:[
        errorListHolder := List new.
    ].
    ^ errorListHolder.
!

errorListVisibilityHolder

    errorListVisibilityHolder isNil ifTrue:[
        errorListVisibilityHolder := false asValue.
    ].
    ^ errorListVisibilityHolder
!

hasSelectionInList
    | sel |

    sel := self selectionHolder value.
    ^ sel notEmptyOrNil
!

selectionHolder
    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
        selectionHolder addDependent:self.
    ].
    ^ selectionHolder.
!

tableColumns

    tableColumns isNil ifTrue:[
        tableColumns := self class tableColumns asValue.
    ].
    ^ tableColumns.
!

viewErrorList
    "return/create the 'viewErrorList' value holder (automatically generated)"

    viewErrorList isNil ifTrue:[
        viewErrorList := false asValue.
        viewErrorList onChangeSend:#viewErrorListChanged to:self.
    ].
    ^ viewErrorList
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == self archiveFileList ifTrue:[
        self hasListEntriesHolder value:(changedObject notEmpty).
        ^ self
    ].
    super update:something with:aParameter from:changedObject
!

viewErrorListChanged

    | viewListValue|

    viewListValue := self viewErrorList value.
    self enableRemoveErrorOutput value:viewListValue.
    self errorListVisibilityHolder value:viewListValue.
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'command execution'!

getErrorBlock

    ^
    [: x |
        self viewErrorList value:true.
        self errorListHolder value add:x.
    ]
!

getErrorStream

    |errStream|

    errStream := ActorStream new.
    errStream nextPutLineBlock:(self getErrorBlock).
    ^ errStream
!

getOutBlock
    |archiveOutputParser|

    archiveOutputParser := archiver listFilesReader.

    ^ [: line | |item|
        item := archiveOutputParser parseLine:line forItemClass:ArchivItem.
        item notNil ifTrue:[
            self archiveFileList value add:item
        ].
    ]
!

getOutStream

    |outStream|

    outStream := ActorStream new.
    outStream nextPutLineBlock:(self getOutBlock).
    ^ outStream
!

makeProcessFor:aBlock
    self makeProcessFor:aBlock with:''
!

makeProcessFor:aBlock with:string
    process notNil ifTrue:[
        (process waitUntilTerminatedWithTimeout:10) ifTrue:[
            (Dialog confirm:'Terminate the current active archive operation ?') ifFalse:[^ self].
            process terminate.
        ].
        terminateByMe ifTrue:[
            terminateByMe := false.
            ^ self
        ].
    ].

    process := [   [        
                        self notify:string.
                        aBlock value.
                        self notify:nil.
                    ] ensure:[ 
                        process := nil.
                        self enableStopButton value:false.
                    ] 
                ] newProcess.
    process priority:(Processor userBackgroundPriority).
    process name:'ArchiveApplicationProcess'.
    process resume.
    self enableStopButton value:true.
!

setColumnsForArchiver

    | newColumns archiverColumns allColumns iconColumn|

    archiverColumns := archiver columns collect:[:el| el first].
    allColumns := OrderedCollection new.
    newColumns := OrderedCollection new.
    self class tableColumns do:[:el|
        allColumns add:(DataSetColumnSpec decodeFromLiteralArray:el).
    ].
    iconColumn := allColumns detect:[: col | (col readSelector asSymbol) = #icon] ifNone:[nil].
    iconColumn notNil ifTrue:[
        newColumns add:iconColumn.
    ].
    allColumns do:[:col|
        (archiverColumns includes:(col readSelector asSymbol)) ifTrue:[
            newColumns add:col.
        ].
    ].
    self tableColumns value:newColumns.
    self columnDescriptors:(self tableColumns value).

    "Modified: / 27-03-2007 / 08:46:03 / cg"
!

stopProcess

    |task|

    terminateByMe := true.
    (task := process) notNil ifTrue:[
        process := nil.

        Error handle:[:ex|
            Dialog warn:ex description.
        ] do:[
            task isDead ifFalse:[
                task terminateWithAllSubprocessesInGroup.
                task waitUntilTerminated.
            ]
        ]
    ].
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'command helper'!

selectDirectoryDialog

    | dir directory haveDirectory|

    directory := self fileName directory.
    haveDirectory := false.
    [haveDirectory] whileFalse:[
        dir := Dialog requestDirectoryName:'Which directory ?' default:dir.
        dir isEmpty ifTrue:[ ^ nil].
        dir := dir asFilename.
        (dir isExecutable not or:[dir isWritable not]) ifTrue:[
            Dialog warn:'cant write to: ', dir asString.
        ].
        haveDirectory := true.
    ].
    ^ dir
!

selectDirectoryDialog:message
    |dir haveDirectory answer|

    dir := self masterApplication currentDirectory.
    dir isNil ifTrue:[
        dir := archiver fileName withoutSuffix.        
"/        (fn exists and:[fn isDirectory]) ifTrue:[
"/            dir := fn        
"/        ] ifFalse:[
"/            dir := fn directory       
"/        ].
    ].

    haveDirectory := false.
    [haveDirectory] whileFalse:[
        dir := Dialog requestDirectoryName:message default:dir.
        dir isEmpty ifTrue:[ ^ nil].

        dir := dir asFilename.
        dir exists ifFalse:[
            answer := Dialog confirm:(resources stringWithCRs:'Directory %1 does not exist.\\Create ?' with:(dir asString allBold)).
            answer isNil ifTrue:[
                ^ nil
            ].
            answer ifTrue:[
                dir makeDirectory.
                dir exists ifFalse:[
                    Dialog warn:(resources stringWithCRs:'Cannot create directory %1 !!' with:(dir asString allBold)).
                ]
            ].
        ].
        dir exists ifTrue:[
            (dir isExecutable not or:[dir isWritable not]) ifTrue:[
                Dialog warn:(resources stringWithCRs:'Cannot write into directory %1 !!' with:dir asString allBold).
            ] ifFalse:[
                haveDirectory := true.
            ].
        ].
    ].
    ^ dir
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'commands add'!

addFilesToArchive:colOfFiles 
    self archiver 
        outStream:nil
        errorStream:(self getErrorStream)
        synchron:true.

"/    self 
"/        makeProcessFor:[ 
"/            self archiver addFilesToArchive:colOfFiles.
"/        ]
"/        with:'Adding files to archive'.
    "/ synchronous - otherwise list below fails
    self archiver addFilesToArchive:colOfFiles.

    "/ ugly code alarm.
    (self archiver class == Archiver zipArchive) ifTrue:[
        self listAllFiles
    ] ifFalse:[
        self listFiles:colOfFiles
    ].
    ^ true
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'commands extract'!

extractAll

    self extractSelectedFilesTo:nil withSelection:#all
!

extractSelectedFilesTo:aDirectory askForExtractOptions:askForExtractOptionsBoolean

    self extractSelectedFilesTo:aDirectory withSelection:#selection askForExtractOptions:askForExtractOptionsBoolean
!

extractSelectedFilesTo:aDirectory withSelection:selectOrAll

    self extractSelectedFilesTo:aDirectory withSelection:selectOrAll askForExtractOptions:true.
!

extractSelectedFilesTo:aDirectory withSelection:selectOrAll askForExtractOptions:askForExtractOptionsBoolean

    | dir|

    aDirectory isNil ifTrue:[
        dir := self selectDirectoryDialog:'Extract into Directory?'.
        dir isNil ifTrue:[^ self].
    ] ifFalse:[
        dir := aDirectory.
    ].
    selectOrAll == #all ifTrue:[
       self extractAllTo:dir.
    ].
    selectOrAll == #selection ifTrue:[
        self extractSelectionTo:dir askForExtractOptions:askForExtractOptionsBoolean
    ].
"/    self updateFileBrowserIfPresentWith:dir.
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'commands extract private'!

extractAllTo:aDirectory 

    self archiver 
        outStream:nil 
        errorStream:(self getErrorStream) 
        synchron:true.
    self 
        makeProcessFor:[ self archiver extractFilesTo:aDirectory ] 
        with:'Extracting all files'.
    ^ true.
!

extractSelection
    self extractSelectedFilesTo:nil withSelection:#selection askForExtractOptions:true
!

extractSelectionTo:aDirectory askForExtractOptions:askForExtractOptionsBoolean
    |  sel index extractWithDirectoryPart extractAllFilesInSelectedDirectories extractFiles|

    extractWithDirectoryPart := true.
    extractAllFilesInSelectedDirectories := false.
    sel := self selectionHolder value.
    (sel isEmptyOrNil) ifTrue:[
        sel := self archiveFileList value.
    ].
    sel := sel do:[:item|
        item fileName: item fileName
    ].
    (askForExtractOptionsBoolean and:[self archiver class ~= Archiver zipArchive]) ifTrue:[
        extractFiles := self selRemoveFilesForDirs:sel.
    ] ifFalse:[
        extractFiles := sel.
    ].
    
    askForExtractOptionsBoolean ifTrue:[
        index := extractFiles findFirst:[: el | el hasDirectoryPart].
        index ~= 0 ifTrue:[
            extractWithDirectoryPart := (Dialog confirmWithCancel:'Extract with directory part ?\\(I.e. create empty directories as required to preserve relative path)' withCRs default:true).
            extractWithDirectoryPart isNil ifTrue:[^ false].
        ].
    ].
    extractWithDirectoryPart ifTrue:[
        self extractWithDirectoryPartTo:aDirectory with:extractFiles.
    ] ifFalse:[
        self extractWithOutDirectoryPartTo:aDirectory with:extractFiles.
    ].
    ^ true

    "Modified (format): / 29-11-2011 / 18:57:54 / cg"
!

extractWithDirectoryPartTo:aDirectory with:extractFiles
    self archiver 
        outStream:nil 
        errorStream:(self getErrorStream) 
        synchron:true.
    self 
        makeProcessFor:[ self archiver extractFiles:extractFiles to:aDirectory ] 
        with:('Extracting files to %1' bindWith:aDirectory asString).
    ^ true.

    "Modified (format): / 29-11-2011 / 18:57:58 / cg"
!

extractWithOutDirectoryPartTo:aDirectory with:extractFiles
    self archiver 
        outStream:nil 
        errorStream:(self getErrorStream) 
        synchron:true.
    self 
        makeProcessFor:[
            self archiver 
                extractFiles:(extractFiles collect:[:item| item fileName])
                withoutDirectoryTo:aDirectory.
        ] 
        with:('Extracting files to %1' bindWith:aDirectory asString).
    ^ true.

    "Modified (format): / 29-11-2011 / 18:58:01 / cg"
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'commands list'!

listAllFiles
    self archiveFileList value removeAll.
    self listFiles:nil
!

listFiles:aColOfFilesOrNil 
    process notNil ifTrue:[
        process waitUntilTerminated
    ].

    archiver notNil ifTrue:[
        self archiver 
            outStream:(self getOutStream)
            errorStream:(self getErrorStream)
            synchron:true.

        self 
            makeProcessFor:[self archiver listFiles:aColOfFilesOrNil]
            with:'List files'
    ]
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'commands remove'!

removeFilesFromArchive
    |sel realSel list firtsPre stringCol stringRealSel|

    sel := self selectionHolder value.
    stringCol := sel collect:[:item | item fileName].
    firtsPre := stringCol at:1.
    stringCol from:2 do:[:el | firtsPre := firtsPre commonPrefixWith:el].
    list := self archiveFileList value.
"/    realSel := OrderedCollection new.
"/    list do:[:item | 
"/        ((item fileName) startsWith:firtsPre) ifTrue:[
"/            realSel add:item
"/        ]
"/    ].
    realSel := list select:[:item | (item fileName) startsWith:firtsPre].
    stringRealSel := realSel collect:[:item | item fileName].

    self archiver 
        outStream:nil
        errorStream:(self getErrorStream)
        synchron:true.
    self 
        makeProcessFor:[ self archiver removeFilesFromArchive:stringCol ]
        with:'Remove files'.
    self archiveFileList value removeAllFoundIn:realSel
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'drag & drop'!

canDrop:aContext

    ^ inDropMode
!

doDrop:aContext 
    |col source arg objects|

    source := aContext dropSource.
    arg := source argument.
    objects := aContext dropObjects.
    col := objects collect:[:dropObject | dropObject theObject].
    ^ self addFilesToArchive:col
!

doStartDrag:aDropSource in:aView
    "set the cursors before starting the drag & drop operation"

    archiver class canDragnDrop ifFalse:[^ self].
    super doStartDrag:aDropSource in:aView
!

dropEnter:aContext
    | dropObjects|

    inDropMode := false.
    (aContext dropSource receiver == self) ifTrue:[^ self].
    dropObjects := aContext dropObjects.

    dropObjects do:[:aObject| |checkObject checkObjectString|
        aObject isFileObject ifFalse:[^ self].
        checkObject := aObject theObject.
        checkObject isFilename ifFalse:[^ self].
        checkObject isSpecialFile ifTrue:[^ self].
    ].
    inDropMode := true.
!

dropLeave:aContext

    inDropMode := false.
!

getDisplayObjects:anArgument
    "retrieve the objects displayed during a drag"

    | sel string size fnName stream|

    sel := self selectionHolder value.
    size := sel size.
    size == 0  ifTrue:[^ ''].

    stream := CharacterWriteStream new.
    stream nextPutAll:(sel first fileName asFilename baseName asString).
    size == 1 ifTrue:[
        fnName := 'ui_menuitem.xpm'.
    ] ifFalse:[
        fnName := 'ui_submenu_open.xpm'.
        stream nextPutAll:' ... '.
        stream nextPutAll:(sel last fileName asFilename baseName asString).
    ].
    string := stream contents.

    ^ Array with:(LabelAndIcon 
                    icon:(Image fromFile:fnName)
                    string:(Text string:string emphasis:#bold))
!

getDropObjects:anArgument
    "common code, used in subclasses"

    |sel|

    sel := self selectionHolder value.
    ^ sel collect:[:el| DropObject newFileInArchive:(el fileName asFilename) ].
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'event handling'!

processEvent:anEvent 
    "filter keyboard events.
     Return true, if I have eaten the event"

    <resource: #keyboard (#Delete )>

    |focusView key rawKey|

    anEvent isKeyPressEvent ifTrue:[
        focusView := anEvent targetView.
        key := anEvent key.
        rawKey := anEvent rawKey.
        (focusView isSameOrComponentOf:self window) ifTrue:[
            (key == #Delete) ifTrue:[
                self removeFilesFromArchive.
                ^ true
            ]
        ]
    ].
    ^ false
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'initialization & release'!

postBuildFileTable:aWidget

    fileTable := aWidget scrolledView.
    fileTable wantsFocusWithPointerEnter.
"/    FileBrowser icons keysAndValuesDo:[:aKey :anIcon|
"/        fileTable registerImage:anIcon key:aKey.
"/    ].
    self columnDescriptors:(self class tableColumns).
!

postOpenWith:aBuilder 
    |currentDir contents suffix fileName file archivItem|

    self windowGroup addPreEventHook:self.
    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
        currentDir := Filename homeDirectory.
        contents := currentDir directoryContents.
        fileName := contents 
                    detect:[:file | 
                        suffix := file asFilename suffix asLowercase.
                        suffix = 'tgz'
                    ]
                    ifNone:[nil].
        fileName isNil ifTrue:[
            Dialog warn:'cant find a Zip file in ' , currentDir asString.
            ^ self
        ].
        file := currentDir construct:fileName.
        archivItem := DirectoryContentsBrowser itemClass fileName:file.
        (self item:archivItem) ifFalse:[
            Dialog warn:'file type of ' , item fileName asString , ' not supported'.
            ^ self
        ]
    ].
    self listAllFiles.
    super postOpenWith:aBuilder
!

release
    self archiver release.
    super release.
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'queries'!

canDelete

    ^ (self hasOneSelectionInList and:[archiver class canRemoveFiles])
!

canViewFile

    ^ self archiver class canViewFile and:[self hasOneSelectionInList]
!

hasListEntriesHolder
    "return/create the 'hasListEntriesHolder' value holder (automatically generated)"

    hasListEntriesHolder isNil ifTrue:[
        hasListEntriesHolder := false asValue.
    ].
    ^ hasListEntriesHolder
!

hasOneSelectionInList

    | sel |
    sel := self selectionHolder value.
    ^ (sel notNil and:[sel notEmpty and:[sel size = 1]])
!

selRemoveFilesForDirs:aSel

    |stringCol newSel string|

    stringCol := (aSel collect:[: item| item fileName]).
    newSel := aSel copy.
    aSel do:[:item |
        item isDirectory ifTrue:[
            string := item fileName.
            stringCol doWithIndex:[:filename : index|
                (filename ~= string and:[filename startsWith:string]) ifTrue:[
                    newSel remove:(aSel at:index) ifAbsent:[nil].
                ]
            ]
        ].
    ].
    ^ newSel.
! !

!FileApplicationNoteBook::ArchiveViewApplication methodsFor:'sorting'!

generateSortBlock:instanceName

    | aSymbol cmpOp sortCaselessLocal|

    aSymbol := instanceName asSymbol.
    sortCaselessLocal := self sortCaseless value.
    currentSortOrder isNil ifTrue:[
        currentSortOrder := aSymbol.
        currentSortOrder := Dictionary new.
        currentSortOrder at:#column put:aSymbol.
        currentSortOrder at:#reverse put:false.
        currentSortOrder at:#sortCaseless put:sortCaselessLocal.
    ] ifFalse:[
        (currentSortOrder at:#column) = aSymbol ifTrue:[
            "/ same column like before - change sort order
            | isReverse |
            isReverse := currentSortOrder at:#reverse.
            currentSortOrder at:#reverse put:(isReverse not).
        ] ifFalse:[
            "/ another column - remark column
            currentSortOrder at:#column put:aSymbol.
        ]
    ].
    (currentSortOrder at:#reverse) ifTrue:[
        cmpOp := #'>'
    ] ifFalse:[
        cmpOp := #'<'
    ].
    ^ [:a :b | 
            |entry1 entry2|

            entry1 := (a perform:aSymbol).
            entry2 := (b perform:aSymbol).
            aSymbol = #fileName ifTrue:[
                sortCaselessLocal ifTrue:[
                    entry1 := entry1 asString asLowercase.
                    entry2 := entry2 asString asLowercase.
                ] ifFalse:[
                    entry1 := entry1 asString.
                    entry2 := entry2 asString.
                ].
            ].
            entry1 perform:cmpOp with:entry2
    ].
!

sortList:instanceName 


    |sortBlock fileList sortCol|

    sortBlock := self generateSortBlock:instanceName.
    fileList := self archiveFileList value.
    sortCol := SortedCollection sortBlock:sortBlock.
    sortCol addAll:fileList.
    fileList removeAll.
    fileList addAll:sortCol.
! !

!FileApplicationNoteBook::ArchiveViewApplication::ArchivItem methodsFor:'accessing'!

compressSize
    "return the value of the instance variable 'compressSize' (automatically generated)"

    ^ compressSize
!

compressSize:something
    "set the value of the instance variable 'compressSize' (automatically generated)"

    compressSize := something.
!

crc
    "return the value of the instance variable 'crc' (automatically generated)"

    ^ crc
!

crc:something
    "set the value of the instance variable 'crc' (automatically generated)"

    crc := something.
!

dateAndTime
    "return the value of the instance variable 'dateAndTime' (automatically generated)"

    ^ dateAndTime
!

dateAndTime:something
    "set the value of the instance variable 'dateAndTime' (automatically generated)"

    dateAndTime := something.
!

day:day
    |ts|

    dateAndTime isNil ifTrue:[
        ts := Timestamp now.
    ] ifFalse:[
        ts := dateAndTime
    ].

    dateAndTime := Timestamp 
                        year:ts year 
                        month:ts month 
                        day:day
                        hour:ts hour
                        minute:ts minutes
                        second:ts minutes
!

dayString:dayString
    self day:(Integer readFrom:dayString)
!

fileName
    "return the value of the instance variable 'fileName' (automatically generated)"

    ^ fileName
!

fileName:something
    "set the value of the instance variable 'fileName' (automatically generated)"

    fileName := something withoutSpaces.
!

icon
    "return the value of the instance variable 'icon' (automatically generated)"

    ^ icon
!

icon:something
    "set the value of the instance variable 'icon' (automatically generated)"

    icon := something.
!

isDirectory
    "return the value of the instance variable 'directory' (automatically generated)"

    ^ isDirectory
!

isDirectory:something
    "set the value of the instance variable 'isDirectory' (automatically generated)"

    isDirectory := something.
!

method
    "return the value of the instance variable 'method' (automatically generated)"

    ^ method
!

method:something
    "set the value of the instance variable 'method' (automatically generated)"

    method := something.
!

month:month
    |ts|

    dateAndTime isNil ifTrue:[
        ts := Timestamp now.
    ] ifFalse:[
        ts := dateAndTime
    ].

    dateAndTime := Timestamp 
                        year:ts year 
                        month:month 
                        day:ts day
                        hour:ts hour
                        minute:ts minutes
                        second:ts minutes
!

monthName:monthName
    self month:(Date indexOfMonth:monthName)
!

ownerGroup
    "return the value of the instance variable 'owner' (automatically generated)"

    ^ ownerGroup
!

ownerGroup:something
    "set the value of the instance variable 'owner' (automatically generated)"

    ownerGroup := something.
!

permissions
    "return the value of the instance variable 'permissions' (automatically generated)"

    ^ permissions
!

permissions:something
    "set the value of the instance variable 'permissions' (automatically generated)"

    permissions := something.
!

ratio
    "return the value of the instance variable 'ratio' (automatically generated)"

    ^ ratio
!

ratio:something
    "set the value of the instance variable 'ratio' (automatically generated)"

    ratio := something.
!

size
    "return the value of the instance variable 'size' (automatically generated)"

    ^ size
!

size:something
    "set the value of the instance variable 'size' (automatically generated)"

    size := something.
!

sizeAsNumber
    "return the value of the instance variable 'size' (automatically generated)"

    ^ size asInteger
!

time:time
    |ts|

    dateAndTime isNil ifTrue:[
        ts := Timestamp now.
    ] ifFalse:[
        ts := dateAndTime
    ].

    dateAndTime := Timestamp 
                        year:ts day 
                        month:ts day 
                        day:ts day
                        hour:time hours
                        minute:time minutes
                        second:time seconds
!

timeString:timeString
    self time:(Time readFrom:timeString)
!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    type := something.
!

version
    "return the value of the instance variable 'version' (automatically generated)"

    ^ version
!

version:something
    "set the value of the instance variable 'version' (automatically generated)"

    version := something.
!

year:year
    |ts|

    dateAndTime isNil ifTrue:[
        ts := Timestamp now.
    ] ifFalse:[
        ts := dateAndTime
    ].

    dateAndTime := Timestamp 
                        year:year 
                        month:ts month 
                        day:ts day
                        hour:ts hour
                        minute:ts minutes
                        second:ts minutes
!

yearString:yearString
    self year:(Integer readFrom:yearString)
! !

!FileApplicationNoteBook::ArchiveViewApplication::ArchivItem methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:self fileName asString
! !

!FileApplicationNoteBook::ArchiveViewApplication::ArchivItem methodsFor:'queries'!

hasDirectoryPart

    ^ self fileName asFilename components size ~= 1
! !

!FileApplicationNoteBook::CommandResult class methodsFor:'defaults'!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'Command Output'

    "Modified: / 01-03-2007 / 21:43:31 / cg"
!

wantNewApplicationAnyway

    ^ false
! !

!FileApplicationNoteBook::CommandResult class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::CommandResult andSelector:#windowSpec
     FileApplicationNoteBook::CommandResult new openInterface:#windowSpec
     FileApplicationNoteBook::CommandResult open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'NoteBookApplication::CommandResult'
          #name: 'NoteBookApplication::CommandResult'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 220 193 723 546)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'ToolBar1'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              #level: 0
              #menu: #menu
              #textDefault: true
            )
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent1'
              #layout: #(#LayoutFrame 0 0.0 32 0 0 1.0 0 1)
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #hasBorder: false
              #component: #TextCollector
              #postBuildCallback: #postBuildTextCollector:
            )
           #(#ProgressIndicatorSpec
              #name: 'ProgressIndicator1'
              #layout: #(#LayoutFrame 125 0 11 0 231 0 21 0)
              #visibilityChannel: #enableStopButton
              #backgroundColor: #(#Color 0.0 66.9993 66.9993)
              #showPercentage: false
              #isActivityIndicator: true
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::CommandResult class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook::CommandResult andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::CommandResult menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Stop'
            #translateLabel: true
            #isButton: true
            #nameKey: #Stop
            #value: #doStopProcess
            #enabled: #enableStopButton
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #stop22x22Icon 'Stop')
          )
         #(#MenuItem
            #activeHelpKey: #closeTabButton
            #label: 'Close'
            #translateLabel: true
            #isButton: true
            #nameKey: #Close
            #isVisible: #closeButtonShown
            #startGroup: #right
            #value: #doClose
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #removeTabIcon)
          )
         )
        nil
        nil
      )

    "Modified: / 12-01-2012 / 00:33:56 / cg"
! !

!FileApplicationNoteBook::CommandResult methodsFor:'accessing'!

resultStream
    "return the value of the instance variable 'resultStream' (automatically generated)"

    ^ resultStream
!

resultStream:something
    "set the value of the instance variable 'resultStream' (automatically generated)"

    resultStream := something.
! !

!FileApplicationNoteBook::CommandResult methodsFor:'actions'!

changeTabTo:aString 

    | masterApplication |

    masterApplication := self masterApplication.
    masterApplication isNil ifFalse:[
        masterApplication tabStringChangeTo:aString for:self.
    ].
!

doStopProcess

    | myProcess |

    myProcess := self process value.
    myProcess notNil ifTrue:[
        self notify:('kill ', myProcess name).
        myProcess terminate.    
    ].
! !

!FileApplicationNoteBook::CommandResult methodsFor:'aspects'!

enableStopButton

    enableStopButton isNil ifTrue:[
        enableStopButton := false asValue.
    ].
    ^ enableStopButton
!

process
    "return/create the 'process' value holder (automatically generated)"

    process isNil ifTrue:[
        process := ValueHolder new.
        process addDependent:self.
    ].
    ^ process
! !

!FileApplicationNoteBook::CommandResult methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == self process ifTrue:[
        self enableStopButton value:changedObject value notNil.
        ^ self
    ].
    super update:something with:aParameter from:changedObject
! !

!FileApplicationNoteBook::CommandResult methodsFor:'initialization & release'!

postBuildTextCollector:aBuilder

    self resultStream:aBuilder scrolledView.
!

postOpenWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked right after the applications window has been opened.
     Add any app-specific actions here (starting background processes etc.).
     See also #postBuildWith:, which is invoked before opening."

    "/ add any code here ...

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
    ].
    super postOpenWith:aBuilder
!

release

    self doStopProcess.
    super release
! !

!FileApplicationNoteBook::CommandResult methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'CommandResult Application'.
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication class methodsFor:'defaults'!

tabStringFor:anApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'Note in %1'

    "Modified: / 01-03-2007 / 21:43:23 / cg"
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication class methodsFor:'documentation'!

documentation
"
    a previewer-plugin for digital-notepad recordings as
    provided by the waltop (tevion) MD85276 digital ink notepad.
"
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::HtmlViewApplication    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#'fitImageSize'
'Shrink to Fit View'

)
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::DigitalNotepadFileViewApplication andSelector:#windowSpec
     FileApplicationNoteBook::DigitalNotepadFileViewApplication new openInterface:#windowSpec
     FileApplicationNoteBook::DigitalNotepadFileViewApplication open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'NotepadViewer'
          name: 'NotepadViewer'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 676 492)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'Menu'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              level: 0
              visibilityChannel: isEmbeddedApplication
              menu: menu
              textDefault: true
            )
           (ArbitraryComponentSpec
              name: 'TOPFileView'
              layout: (LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: false
              miniScrollerVertical: false
              hasBorder: false
              component: TOPFileViewer
              postBuildCallback: postBuildImageView:
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook::ImageViewApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::ImageViewApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
"/         #(#MenuItem
"/            #label: 'Edit'
"/            #itemValue: #editImage
"/            #nameKey: #EditImage
"/            #translateLabel: true
"/            #isButton: true
"/            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #startImageEditorIcon)
"/          )
"/         #(#MenuItem
"/            #label: '-'
"/          )
         #(#MenuItem
            #activeHelpKey: #fitImageSize
            #label: 'FitSize'
            #translateLabel: true
            #isButton: true
            #triggerOnDown: true
            #indication: #fitSize
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #fitImageSizeToViewIcon)
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #activeHelpKey: #closeTabButton
            #label: 'Close'
            #itemValue: #doClose
            #translateLabel: true
            #isButton: true
            #startGroup: #right
            #hideMenuOnActivated: false
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #removeTabIcon)
          )
         )
        nil
        nil
      )
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication class methodsFor:'queries'!

canOpenItem:anItem
    ^ anItem mimeType = 'application/x-waltop-digital-notepad'
!

wantNewApplicationAnyway

    ^ false
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication methodsFor:'accessing'!

imageView
    ^ imageView
!

imageView:something
    imageView := something.
!

updateImageInfo
"/    |fn msg|
"/
"/    image notNil ifTrue:[
"/        fn := image fileName.
"/        fn isNil ifTrue:[
"/            fn := 'unnamed'
"/        ] ifFalse:[
"/            fn :=  fn asFilename baseName.
"/        ].
"/        msg := '%1  %2x%3 depth:%4'
"/                bindWith:fn allBold
"/                with:image width
"/                with:image height
"/                with:image depth.
"/    ].
"/    self notify:msg.
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication methodsFor:'actions'!

changeItem:anItem

    self item:anItem.
    self setupImageView.
    ^ true
!

setupImageView
    imageView readFile:self fileName
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication methodsFor:'aspects'!

fitSize
    "return/create the 'fitSize' value holder (automatically generated)"

    fitSize isNil ifTrue:[
        fitSize := ValueHolder new.
        fitSize addDependent:self.
    ].
    ^ fitSize
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == self fitSize ifTrue:[
        changedObject value ifTrue:[
            imageView adjust:#fit.
        ] ifFalse:[
            imageView adjust:nil.
        ].
        ^ self
    ].
    super update:something with:aParameter from:changedObject
! !

!FileApplicationNoteBook::DigitalNotepadFileViewApplication methodsFor:'initialization & release'!

postBuildImageView:aWidget

    self imageView: aWidget scrolledView.
"/    self imageView wantsFocusWithPointerEnter.
!

postOpenWith:aBuilder 
    "only invoked if the application is not started from a master"

    |currentDir contents fileName|

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
        currentDir := Filename currentDirectory.
        contents := currentDir directoryContents.
        fileName := contents 
                    detect:[:file | 
                        file asFilename mimeTypeOfContents = 'application/x-waltop-digital-notepad'
                    ]
                    ifNone:[nil].
        fileName isNil ifTrue:[
            Dialog warn:'Cant find a TOP-file in ' , currentDir asString.
            ^ self
        ].
        self item:(DirectoryContentsBrowser itemClass fileName:(currentDir construct:fileName))
    ].
    self setupImageView.
    super postOpenWith:aBuilder
! !

!FileApplicationNoteBook::HtmlViewApplication class methodsFor:'defaults'!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'HTML View for %1'

    "Modified: / 01-03-2007 / 21:43:18 / cg"
! !

!FileApplicationNoteBook::HtmlViewApplication class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::HtmlViewApplication    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#'Edit Source'
''

)
! !

!FileApplicationNoteBook::HtmlViewApplication class methodsFor:'interface specs'!

windowSpec

    | webKitView |

    ^((webKitView := (Smalltalk at:#WebKitView)) notNil 
        and:[webKitView isAvailable])
        ifTrue:[self windowSpec_WebBrowserPage]
        ifFalse:[self windowSpec_HTMLView]

    "Modified: / 11-08-2011 / 00:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec_HTMLView
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::HtmlViewApplication andSelector:#windowSpec
     FileApplicationNoteBook::HtmlViewApplication new openInterface:#windowSpec
     FileApplicationNoteBook::HtmlViewApplication open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'NoteBookApplication::HtmlView'
          #name: 'NoteBookApplication::HtmlView'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 16 42 692 534)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'MenuHtml'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              #level: 0
              #visibilityChannel: #isEmbeddedApplication
              #menu: #menu
              #textDefault: true
            )
           #(#ArbitraryComponentSpec
              #name: 'HTMLView'
              #layout: #(#LayoutFrame 0 0.0 32 0.0 0 1.0 0 1)
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: false
              #miniScrollerVertical: false
              #hasBorder: false
              #component: #HTMLDocumentView
              #postBuildCallback: #postBuildHtmlView:
            )
           #(#LabelSpec
              #label: 'FileLabel'
              #name: 'FileLabel'
              #layout: #(#LayoutFrame 212 0 2 0 -73 1 30 0)
              #level: -1
              #translateLabel: true
              #labelChannel: #labelHolder
              #adjust: #left
            )
           )
         
        )
      )

    "Created: / 11-08-2011 / 00:19:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec_WebBrowserPage
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::HtmlViewApplication andSelector:#windowSpec_WebBrowserPage
     FileApplicationNoteBook::HtmlViewApplication new openInterface:#windowSpec_WebBrowserPage
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: #'windowSpec_WebBrowserPage'
        window: 
       (WindowSpec
          label: 'NoteBookApplication::HtmlView'
          name: 'NoteBookApplication::HtmlView'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 676 492)
          menu: menuJustClose
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'MenuClose'
              layout: (LayoutFrame -25 1 0 0 0 1.0 30 0)
              level: 0
              visibilityChannel: isEmbeddedApplication
              menu: menuJustClose
              textDefault: true
            )
           (SubCanvasSpec
              name: 'ToolBar'
              layout: (LayoutFrame 0 0 0 0 -25 1 30 0)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              minorKey: toolBarSpec
              clientKey: webBrowserPage
              createNewBuilder: false
            )
           (SubCanvasSpec
              name: 'Content'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              minorKey: contentSpec
              clientKey: webBrowserPage
              createNewBuilder: false
            )
           )
         
        )
      )

    "Modified: / 11-08-2011 / 00:34:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileApplicationNoteBook::HtmlViewApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook::HtmlViewApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::HtmlViewApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Reload'
            itemValue: doReload
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadTextFromFileIcon)
          )
         (MenuItem
            label: 'Back'
            itemValue: doGoBack
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary historyBackIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Print'
            itemValue: doPrint
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary printerIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: #'Edit Source'
            label: 'Edit'
            itemValue: doEdit
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary editFileIcon)
          )
         (MenuItem
            activeHelpKey: closeTabButton
            label: 'Close'
            itemValue: doClose
            translateLabel: true
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         )
        nil
        nil
      )
!

menuJustClose
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook::HtmlViewApplication andSelector:#menuJustClose
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::HtmlViewApplication menuJustClose)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: closeTabButton
            label: 'Close'
            itemValue: doClose
            translateLabel: true
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         )
        nil
        nil
      )
! !

!FileApplicationNoteBook::HtmlViewApplication class methodsFor:'queries'!

canOpenItem:anItem

    ^ (anItem hasMimeType and:[anItem mimeType isHtmlType])
!

wantNewApplicationAnyway

    ^ false
! !

!FileApplicationNoteBook::HtmlViewApplication methodsFor:'accessing'!

htmlView
    "return the value of the instance variable 'imageView' (automatically generated)"

    ^ htmlView
!

htmlView:something
    "set the value of the instance variable 'imageView' (automatically generated)"

    htmlView := something.
!

item:anItem 

    |retVal|

    self labelHolder value:anItem fileName asString.
    retVal := super item:anItem.
    self setupHtmlView.
    ^ retVal
! !

!FileApplicationNoteBook::HtmlViewApplication methodsFor:'accessing-subApps'!

webBrowserPage

    webBrowserPage isNil ifTrue:[
        webBrowserPage := Tools::WebBrowserPage new.
        webBrowserPage urlHolder: self labelHolder
    ].
    ^webBrowserPage

    "Created: / 11-08-2011 / 00:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileApplicationNoteBook::HtmlViewApplication methodsFor:'actions'!

doEdit
    self masterApplication 
        openTextEditorForFile:(htmlView currentDocument)
"/        openTextEditorOn:item.

    "Modified: / 24-11-2006 / 11:14:51 / cg"
!

doGoBack

    self htmlView menu_back.
!

doGoHome

    self htmlView menu_home.
!

doHelp

    self htmlView menu_help.
!

doPrint

    self htmlView menu_print.
!

doReload

    self htmlView menu_reload.
!

setupHtmlView

    | html file directory|

    html := self htmlView.
    html isNil ifTrue:[^ self].

    file := self fileName.
    directory := file directoryName.
    html homeDocument:(file asString).
    html setTopDirectoryName:directory.
    html uriHolder:self labelHolder.
    html infoHolder:self notifyChannel.
    html linkButtonPanel:nil.
    ^ html

    "Modified: / 17-02-2011 / 14:01:35 / cg"
! !

!FileApplicationNoteBook::HtmlViewApplication methodsFor:'aspects'!

labelHolder

    labelHolder isNil ifTrue:[
        labelHolder := '' asValue.
    ].
    ^ labelHolder.
! !

!FileApplicationNoteBook::HtmlViewApplication methodsFor:'initialization & release'!

postBuildHtmlView:aWidget

    self htmlView: aWidget scrolledView.
    self htmlView wantsFocusWithPointerEnter.
!

postOpenWith:aBuilder 
    "only invoked if the application not started from a master"

    |currentDir contents suffix fileName|

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
        currentDir := Filename homeDirectory.

        contents := currentDir directoryContents.
        fileName := contents 
                    detect:[:file | 
                        suffix := file asFilename suffix asLowercase.
                        suffix = 'html'
                    ]
                    ifNone:[nil].
        fileName isNil ifTrue:[
            Dialog warn:'cant find a HTML file in ' , currentDir asString.
            ^ self
        ].
        self item:(DirectoryContentsBrowser itemClass 
                        fileName:('../../doc/online/english/TOP.html') asFilename asAbsoluteFilename).
    ].
    self setupHtmlView.
    super postOpenWith:aBuilder

    "Modified: / 17-02-2011 / 13:27:12 / cg"
! !

!FileApplicationNoteBook::ImageViewApplication class methodsFor:'defaults'!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'Image in %1'

    "Modified: / 01-03-2007 / 21:43:23 / cg"
! !

!FileApplicationNoteBook::ImageViewApplication class methodsFor:'documentation'!

documentation
"
    a previewer-plugin for bitmap images (jpg, xpm, tiff, gif, etc.)
    Offers edit and adjust-size button functions.
"
! !

!FileApplicationNoteBook::ImageViewApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::HtmlViewApplication    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#'fitImageSize'
'Shrink image to fit view'

#'showHex'
'Show a hex dump of the file''s contents'

)
! !

!FileApplicationNoteBook::ImageViewApplication class methodsFor:'image specs'!

fitSize20x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fitSize20x20Icon inspect
     ImageEditor openOnClass:self andSelector:#fitSize20x20Icon"
    
    ^ Icon 
        constantNamed:#'FileApplicationNoteBook::ImageViewApplication class fitSize20x20Icon'
        ifAbsentPut:[
            (Depth4Image new)
                width:20;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@DQDQDQDQDP@@@PDQDQDQDQ@P@A@ADQDQDQDP@PD@@PDQDQDPD@@QDQ@ADQDQ@@DQDQD@@@@@@@@@DQDQDPQDQDQ@DQDQDQDDQUUTPADQDQDQAEUUUT@QDQ
DQDPQEUUQ@DQDQDQDDQFQDPADQDQDQADQ$QD@QDQDQDPL3X3Q@DQDQDQDCL3L3LADQDQD@@@@@@@@@DQDQD@DQDQDP@QDQ@@DADQDQDA@@DA@ADQDQDQDP@P
@@@QDQDQDQDA@@@ADQDQDQDQD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 0 0 0 137 0 174 218 230 0 206 0 133 60 36 ];
                mask:((ImageMask new)
                            width:20;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'
8@A00@@0(@APE@J@C@L@G?>@A?8@A?8@A?8@A?8@A?8@A?8@A?8@A?8@G?>@C@L@E@J@(@AP0@@08@A0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
! !

!FileApplicationNoteBook::ImageViewApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::ImageViewApplication andSelector:#windowSpec
     FileApplicationNoteBook::ImageViewApplication new openInterface:#windowSpec
     FileApplicationNoteBook::ImageViewApplication open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ImageViewer'
          #name: 'ImageViewer'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 16 42 692 534)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'MenuImage'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              #level: 0
              #visibilityChannel: #isEmbeddedApplication
              #menu: #menu
              #textDefault: true
            )
           #(#ArbitraryComponentSpec
              #name: 'ImageView'
              #layout: #(#LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: false
              #miniScrollerVertical: false
              #hasBorder: false
              #component: #ImageView
              #postBuildCallback: #postBuildImageView:
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::ImageViewApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileApplicationNoteBook::ImageViewApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::ImageViewApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Edit'
            itemValue: editImage
            nameKey: EditImage
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startImageEditorIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fitImageSize
            label: 'FitSize'
            isButton: true
            triggerOnDown: true
            indication: fitSize
            labelImage: (ResourceRetriever ToolbarIconLibrary fitImageSizeToViewIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: showHex
            label: 'ShowHex'
            itemValue: showHex
            isButton: true
            triggerOnDown: true
            labelImage: (ResourceRetriever ToolbarIconLibrary hexToggleIcon)
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            activeHelpKey: closeTabButton
            label: 'Close'
            itemValue: doClose
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         )
        nil
        nil
      )
! !

!FileApplicationNoteBook::ImageViewApplication class methodsFor:'queries'!

canOpenItem:anItem

    ^ (anItem hasMimeType and:[anItem mimeType isImageType])
!

wantNewApplicationAnyway

    ^ false
! !

!FileApplicationNoteBook::ImageViewApplication methodsFor:'accessing'!

image:something
    image := something.
    self updateImageInfo.
!

imageView
    ^ imageView
!

imageView:something
    imageView := something.
!

updateImageInfo
    |fn msg|

    image notNil ifTrue:[
        fn := image fileName.
        fn isNil ifTrue:[
            fn := 'unnamed'
        ] ifFalse:[
            fn :=  fn asFilename baseName.
        ].
        msg := '%1  %2x%3 depth:%4'
                bindWith:fn allBold
                with:image width
                with:image height
                with:image depth.
    ].
    self notify:msg.
! !

!FileApplicationNoteBook::ImageViewApplication methodsFor:'actions'!

changeItem:anItem

    self item:anItem.
    self setupImageView.
    ^ true
!

editImage
    |img|

    img := self image.
    img notNil ifTrue:[
"/        self withWaitCursorDo:[
            img edit.
"/        ]
    ].

    "Modified: / 25-07-2006 / 09:09:20 / cg"
!

image
    |img fn e|

    fn := self fileName.
    Image badImageFormatQuerySignal handle:[:ex |
        e := ex description.
        "/ ex mayProceed ifTrue:[ ex proceed ].
    ] do:[
        img := Image fromFile:fn.
    ].
    img isNil ifTrue:[
        e isNil ifTrue:[
            fn exists ifTrue:[
                e := 'Unknown/unsupported image format'
            ] ifFalse:[
                e := 'No such image'
            ].
        ].
        Dialog warn:('Error while reading image:\n%s' printfWith:e).
        ^ nil
    ].
    e notNil ifTrue:[
        Dialog information:'An error occurred while decoding some parts of the image.\However, some image data was retrieved...' withCRs.
    ].
    ^ img.
!

showHex
    masterApplication openTextEditorWithHexPresentationOn:item
! !

!FileApplicationNoteBook::ImageViewApplication methodsFor:'aspects'!

fitSize
    "return/create the 'fitSize' value holder (automatically generated)"

    fitSize isNil ifTrue:[
        fitSize := ValueHolder new.
        fitSize addDependent:self.
    ].
    ^ fitSize
! !

!FileApplicationNoteBook::ImageViewApplication methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == self fitSize ifTrue:[
        changedObject value ifTrue:[
            imageView adjust:#fitBig.
        ] ifFalse:[
            imageView adjust:nil.
        ].
        ^ self
    ].
    super update:something with:aParameter from:changedObject
! !

!FileApplicationNoteBook::ImageViewApplication methodsFor:'event handling'!

processEvent:anEvent
    |view rawKey key|

    view := anEvent view.
    anEvent isKeyPressEvent ifTrue:[
        (imageView notNil 
            and:[view notNil
            and:[(view == imageView)]]
        ) ifTrue:[
            rawKey := anEvent rawKey.
            key := anEvent key.
            (rawKey == #CursorDown) ifTrue:[
                masterApplication selectNextFile; enterAction.
                ^ true.
            ].
            (rawKey == #CursorUp) ifTrue:[
                masterApplication selectPreviousFile; enterAction.
                ^ true.
            ].
            key == $q ifTrue:[
                self doClose.
                ^ true.
            ].
            ((key == #Escape) or:[key == $x]) ifTrue:[
                self topView collapse.
                ^ true.
            ].
            ((key == #Cut) 
              or:[(key == #BackSpace)
              or:[key == #Delete]]) ifTrue:[
                masterApplication deleteFiles.
                ^ true
            ].
            ^ false
        ]
    ].
    ^ false
! !

!FileApplicationNoteBook::ImageViewApplication methodsFor:'initialization & release'!

postBuildImageView:aWidget

    self imageView: aWidget scrolledView.
    self imageView wantsFocusWithPointerEnter.
!

postOpenAsSubcanvasWith:aBuilder 
    "invoked if the application is embedded in some other view"

    |wg|
    
    (wg := self imageView windowGroup) notNil ifTrue:[
        wg addPreEventHook:self.
    ].
    super postOpenAsSubcanvasWith:aBuilder
!

postOpenWith:aBuilder 
    "only invoked if the application is not started from a master"

    |currentDir contents suffix fileName|

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
        currentDir := Filename currentDirectory.
        contents := currentDir directoryContents.
        fileName := contents 
                    detect:[:file | 
                        suffix := file asFilename suffix asLowercase.
                        Image isImageFileSuffix:suffix
                    ]
                    ifNone:[nil].
        fileName isNil ifTrue:[
            Dialog warn:'cant find a Image in ' , currentDir asString.
            ^ self
        ].
        self item:(DirectoryContentsBrowser itemClass fileName:(currentDir construct:fileName))
    ].
    self setupImageView.
    self imageView windowGroup addPreEventHook:self.
    super postOpenWith:aBuilder
!

setupImageView
    [
        |img|

"/        imageView withCursor:(Cursor wait) do:[
            img := self image.
            img notNil ifTrue:[
                self image:img.
                imageView image:img
            ].
"/        ].
    ] fork.

    "Modified: / 25-07-2006 / 09:09:33 / cg"
! !

!FileApplicationNoteBook::Terminal class methodsFor:'defaults'!

defaultLineLimit
    "the number of buffered lines"

    ^ DefaultLineLimit ? TextCollector defaultLineLimit

    "
     DefaultLineLimit := 30000
    "

    "Modified: / 05-04-2007 / 17:03:11 / cg"
!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'Terminal'

    "Modified: / 01-03-2007 / 21:43:38 / cg"
! !

!FileApplicationNoteBook::Terminal class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::Terminal    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#closeTabButton
''

)
! !

!FileApplicationNoteBook::Terminal class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::Terminal andSelector:#windowSpec
     FileApplicationNoteBook::Terminal new openInterface:#windowSpec
     FileApplicationNoteBook::Terminal open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Terminal'
          name: 'Terminal'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 692 537)
          "/ menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'MenuTerminal'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              level: 0
              menu: toolbarMenu
              textDefault: true
            )
           (ArbitraryComponentSpec
              name: 'TerminalView'
              layout: (LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              miniScrollerVertical: false
              autoHideScrollBars: false
              hasBorder: false
              component: terminalView
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::Terminal class methodsFor:'menu specs'!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileApplicationNoteBook::Terminal andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::Terminal toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Save As...'
            itemValue: saveAs
            nameKey: Save
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveToFileAsIcon)
          )
         (MenuItem
            activeHelpKey: closeTabButton
            label: 'Close'
            itemValue: doClose
            isButton: true
            startGroup: right
            isVisible: closeButtonShown
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         (MenuItem
            label: 'Scroll Lock'
            itemValue: scrollLockedChanged
            isButton: true
            startGroup: right
            indication: scrollLockedHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary scrollLockIcon)
          )
         (MenuItem
            label: 'Clear Console Output'
            itemValue: menuClearConsole
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary clearConsoleIcon)
          )
         )
        nil
        nil
      )
! !

!FileApplicationNoteBook::Terminal methodsFor:'accessing'!

terminalView

    terminalView isNil ifTrue:[
        (OperatingSystem isUNIXlike 
                "/ mhm - xterm embedding seems to no longer work; the default from user prefs is therefore false
                and:[UserPreferences current useXTermViewIfAvailable 
                and:[XTermView notNil 
                and:[XTermView isAvailable]]]) ifTrue:[
            terminalView := XTermView new.
            terminalView workingDirectory: item fileName pathName.
            terminalView lineLimit:(self class defaultLineLimit).
        ] ifFalse:[
            VT100TerminalView isNil ifTrue:[
                Dialog warn:('Missing class: ' , 'VT100TerminalView' allBold).
                AbortOperationRequest raise 
            ].
            terminalView := VT100TerminalView new.
        ].
    ].
    ^ terminalView.

    "Modified: / 05-04-2012 / 15:58:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileApplicationNoteBook::Terminal methodsFor:'actions'!

menuClearConsole
    terminalView clear.
!

saveAs
    "open a save-as dialog"

    self terminalView save.
!

scrollLockedChanged
    terminalView scrollLock:scrollLockedHolder value.
!

scrollLockedHolder
    scrollLockedHolder isNil ifTrue:[
        scrollLockedHolder := false asValue
    ].
    ^ scrollLockedHolder.
! !

!FileApplicationNoteBook::Terminal methodsFor:'initialization & release'!

doClose
    terminalView closeDownShell.
    ^ super doClose.
!

shellFinished
    | master text string|

    master := self masterApplication.
    master notNil ifTrue:[
        string := ' - closed'.
        master tabStringAdd:string for:self.
    ].
    self notify:'shell in ' , self fileName asString, ' finished'.
    terminalView cr.

    text := '>> shell terminated.' allBold withColor:#red.
    terminalView nextPutAll:text.
!

startShell
    |vt100|

    vt100 := self terminalView.
    vt100 shellTerminateAction:[ self shellFinished ].
    vt100 startShellIn:(self fileName).
! !

!FileApplicationNoteBook::Terminal methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'Terminal on:'.
    self fileName baseName printOn:aStream.
! !

!FileApplicationNoteBook::Terminal methodsFor:'queries'!

getTabIcon
    "the item shown in a tab"

    ^ ToolbarIconLibrary console13x13Icon
!

getTabValueString
    "the item shown in a tab (not language translated)"

    ^ nil

    "Created: / 01-03-2007 / 21:39:56 / cg"
! !

!FileApplicationNoteBook::Terminal methodsFor:'startup & release'!

postOpenWith:aBuilder
    "only invoked if the application not started from a master"

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
        self item:(DirectoryContentsBrowser itemClass fileName:(Filename currentDirectory asAbsoluteFilename)).
    ].
    self startShell.
    super postOpenWith:aBuilder.
    terminalView requestFocus.
! !

!FileApplicationNoteBook::TextEditor class methodsFor:'defaults'!

checkModifiedDelayTime
    ^ 30    "seconds"
!

defaultTagsBrowserVisible
    ^ DefaultTagsBrowserVisible ? true

    "Created: / 06-10-2011 / 12:45:58 / cg"
!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    aApplicationType == #directoryDescription ifTrue:[
        ^ 'Directory Description of %1'
    ].
    ^ '%1'

    "Modified: / 01-03-2007 / 21:46:24 / cg"
!

wantNewApplicationAnyway

    ^ false
! !

!FileApplicationNoteBook::TextEditor class methodsFor:'documentation'!

documentation
"
    a previewer-plugin for plain text
    Offers edit, hex-display and diff functions.
"
! !

!FileApplicationNoteBook::TextEditor class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::TextEditor    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#closeTabButton
'Close this tab'

#hideEditorOperationsToolBar
'Hide the additional editor operations menu'

#indentCode
'Indent the selected lines (or the cursor line) by 4'

#showEditOperationsToolBar
'Show the additional editor operations menu'

#undentCode
'Undent the selected lines (or the cursor line) by 4'

#toggleBold
'Toggle the selection''s bold attribute (if bold, turn off; if not, turn on)'

#toggleItalic
'Toggle the selection''s italic attribute (if italic, turn off; if not, turn on)'

#toggleCode
'Toggle the selection''s code+pre attribute (if code, turn off; if not, turn on)'

#toggleEscape
'Escape the selected characters with &; escape sequences.\(i.e. change "<" into "&lt;")'

#addAnchor
'Make the selection an an anchor element'

#addImage
'Insert a bitmap image element'


)
! !

!FileApplicationNoteBook::TextEditor class methodsFor:'image specs'!

hideToolBarIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary hideToolBarIcon

    "Created: / 02-08-2013 / 16:03:09 / cg"
! !

!FileApplicationNoteBook::TextEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::TextEditor andSelector:#windowSpec
     FileApplicationNoteBook::TextEditor new openInterface:#windowSpec
     FileApplicationNoteBook::TextEditor open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'TextEditor'
         name: 'TextEditor'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 650 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableHorizontalPanelSpec
             name: 'Panel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             showHandle: true
             snapMode: max
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'EditorBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (MenuPanelSpec
                         name: 'MenuTextEditor'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 30 0)
                         level: 1
                         menu: menu
                         textDefault: true
                       )
                      (ViewSpec
                         name: 'EditorOperationsToolBar'
                         layout: (LayoutFrame 0 0 30 0 0 1 60 0)
                         level: 0
                         visibilityChannel: editorOperationsToolBarVisibleHolder
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'hideToolBarIcon'
                               name: 'HideEditorOperationsToolBarButton'
                               layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                               activeHelpKey: hideEditorOperationsToolBar
                               level: 1
                               hasCharacterOrientedLabel: false
                               translateLabel: true
                               model: hideEditorOperationsToolBar
                               postBuildCallback: hideEditorOperationsToolBarButtonCreated:
                             )
                            (MenuPanelSpec
                               name: 'EditorOperationsToolBarMenu'
                               layout: (LayoutFrame 13 0 0 0 0 1 30 0)
                               level: 1
                               menu: editorOperationsMenuSpecHolder
                               textDefault: true
                             )
                            )
                          
                         )
                       )
                      (TextEditorSpec
                         name: 'TextEditor'
                         layout: (LayoutFrame 0 0.0 59 0 0 1.0 0 1.0)
                         model: fileContentsModel
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         modifiedChannel: viewModifiedChannel
                         acceptCallBack: accept
                         allowDoIt: true
                         hasKeyboardFocusInitially: false
                         postBuildCallback: postBuildTextEditor:
                         viewClassName: 'getEditorClass'
                       )
                      (ActionButtonSpec
                         label: '...'
                         name: 'Button1'
                         layout: (LayoutFrame -56 1 5 0 -36 1 27 0)
                         activeHelpKey: showEditOperationsToolBar
                         visibilityChannel: editorOperationsToolBarNotVisibleHolder
                         translateLabel: true
                         model: showEditorOperationsToolBar
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 1.0)
           )
          )
        
       )
     )
!

xwindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::TextEditor andSelector:#windowSpec
     FileApplicationNoteBook::TextEditor new openInterface:#windowSpec
     FileApplicationNoteBook::TextEditor open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'TextEditor'
          #name: 'TextEditor'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 16 42 666 342)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'MenuTextEditor'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              #level: 0
              #menu: #menu
              #textDefault: true
            )
           #(#TextEditorSpec
              #name: 'TextEditor'
              #layout: #(#LayoutFrame 0 0.0 32 0 0 1.0 0 1.0)
              #model: #fileContentsModel
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #modifiedChannel: #viewModifiedChannel
              #acceptCallBack: #accept
              #allowDoIt: true
              #postBuildCallback: #postBuildTextEditor:
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::TextEditor class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileApplicationNoteBook::TextEditor andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::TextEditor menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: saveFile
            enabled: enableSave
            label: 'Save'
            itemValue: accept
            nameKey: Save
            isButton: true
            isVisible: saveButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary saveTextToFileIcon)
          )
         (MenuItem
            activeHelpKey: saveFileAs
            enabled: enableSaveAs
            label: 'Save As...'
            itemValue: saveFileAs
            nameKey: SaveAs
            isButton: true
            isVisible: saveAsButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary saveToFileAsIcon)
          )
         (MenuItem
            activeHelpKey: reloadFile
            enabled: enableReload
            label: 'Reload'
            itemValue: reload
            nameKey: Reload
            isButton: true
            isVisible: reloadButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadTextFromFileIcon)
          )
         (MenuItem
            activeHelpKey: findInBrowser
            enabled: enableSelectInBrowser
            label: 'Select in Browser'
            itemValue: selectInBrowser
            nameKey: SelectInBrowser
            isButton: true
            isVisible: selectInBrowserButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary searchFileIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: print
            enabled: enableHexToggle
            label: 'Print'
            itemValue: doPrint
            nameKey: Print
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary printerIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: showDifferences
            label: 'Diff to Current'
            itemValue: openDiffView
            isButton: true
            isVisible: diffTextButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary diffIcon)
          )
         (MenuItem
            activeHelpKey: toggleHexDisplay
            enabled: enableHexToggle
            label: 'Hex'
            isButton: true
            indication: printAsHexDump
            labelImage: (ResourceRetriever ToolbarIconLibrary hexToggleIcon)
          )
         (MenuItem
            label: ''
            isVisible: diffTextButtonVisible
          )
         (MenuItem
            activeHelpKey: closeTabButton
            label: 'Close'
            itemValue: doClose
            isButton: true
            startGroup: right
            isVisible: closeButtonShown
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         )
        nil
        nil
      )
!

menuEditorOperationsForHTML
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileApplicationNoteBook::TextEditor andSelector:#menuEditorOperationsForHTML
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::TextEditor menuEditorOperationsForHTML)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: toggleBold
            label: 'bold'
            itemValue: editOperationToggleBoldHTML
            labelImage: (ResourceRetriever ToolbarIconLibrary #'edit_bold_15x15')
          )
         (MenuItem
            activeHelpKey: toggleItalic
            enabled: canEdit
            label: 'italic'
            itemValue: editOperationToggleItalicHTML
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary #'edit_italic_15x15')
          )
         (MenuItem
            activeHelpKey: toggleCode
            enabled: canEdit
            label: 'code'
            itemValue: editOperationToggleCodeHTML
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary #'edit_code_15x15')
          )
         (MenuItem
            activeHelpKey: toggleEscape
            enabled: canEdit
            label: 'escape'
            itemValue: editOperationEscapeSpecialCharactersHTML
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary #'edit_escapeHTMLCharacters')
          )
         (MenuItem
            activeHelpKey: addAnchor
            enabled: canEdit
            label: 'anchor'
            itemValue: editOperationAddAnchorHTML
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary #'edit_anchor15x15')
          )
         (MenuItem
            activeHelpKey: addImage
            enabled: canEdit
            label: 'image'
            itemValue: editOperationAddImageHTML
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary #'edit_image_15x15')
          )
         )
        nil
        nil
      )
!

menuEditorOperationsForNormalText
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileApplicationNoteBook::TextEditor andSelector:#menuEditorOperationsForNormalText
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::TextEditor menuEditorOperationsForNormalText)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: undentCode
            enabled: canEdit
            label: 'Undent'
            itemValue: editOperationUndentCode
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary undent16x16Icon)
          )
         (MenuItem
            activeHelpKey: indentCode
            enabled: canEdit
            label: 'Indent'
            itemValue: editOperationIndentCode
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary indent16x16Icon)
          )
         )
        nil
        nil
      )

    "Modified: / 02-08-2013 / 18:21:42 / cg"
!

menuEditorOperationsForOther
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileApplicationNoteBook::TextEditor andSelector:#menuEditorOperationsForNormalText
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::TextEditor menuEditorOperationsForNormalText)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: undentCode
            enabled: canEdit
            label: 'Undent'
            itemValue: editOperationUndentCode
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary undent16x16Icon)
          )
         (MenuItem
            activeHelpKey: indentCode
            enabled: canEdit
            label: 'Indent'
            itemValue: editOperationIndentCode
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary indent16x16Icon)
          )
         )
        nil
        nil
      )

    "Created: / 02-08-2013 / 17:09:31 / cg"
!

menuEditorOperationsForSourceCode
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:FileApplicationNoteBook::TextEditor andSelector:#menuEditorOperationsForSourceCode
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::TextEditor menuEditorOperationsForSourceCode)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: #'help_doIt'
            label: 'DoIt'
            itemValue: doIt
            isButton: true
            isVisible: doItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary doItIcon)
          )
         (MenuItem
            activeHelpKey: #'help_printIt'
            label: 'PrintIt'
            itemValue: printIt
            isButton: true
            isVisible: printItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary printItIcon)
          )
         (MenuItem
            activeHelpKey: #'help_inspectIt'
            label: 'InspectIt'
            itemValue: inspectIt
            isButton: true
            isVisible: inspectItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary inspectItIcon)
          )
         (MenuItem
            activeHelpKey: undentCode
            enabled: canEdit
            label: 'Undent'
            itemValue: editOperationUndentCode
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary undent16x16Icon)
          )
         (MenuItem
            activeHelpKey: indentCode
            enabled: canEdit
            label: 'Indent'
            itemValue: editOperationIndentCode
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary indent16x16Icon)
          )
         )
        nil
        nil
      )

    "Modified: / 17-12-2013 / 16:37:59 / cg"
! !

!FileApplicationNoteBook::TextEditor methodsFor:'accessing'!

fileEncoding
    ^ self fileEncodingHolder value
!

fileEncoding:newEncoding
    self fileEncodingHolder value:newEncoding.

    editView notNil ifTrue:[
        self enableReload value:true.
        editView externalEncoding:newEncoding.
    ].
!

item:aDirContentsItem

    self releaseCheckModify.
    (self item = aDirContentsItem and:[(self presentation == #hexDump) == self printAsHexDump value]) ifTrue:[^ true].

    self askForChangeWithReload:false "true".

    super item:aDirContentsItem.
    self printAsHexDump value:(self presentation == #hexDump) withoutNotifying:self.
    self updateTagsBrowser.
    self setContents ifFalse:[ ^ false].

    self setUpTextView.

    textEditorModificationTime := self fileName modificationTime.
    self releaseCheckModify.
    self setupCheckModify.
    self changeInformation.
    ^ true

    "Modified: / 23-06-2011 / 16:45:13 / cg"
!

lockFileEncoding:aBoolean
    self lockFileEncodingHolder value:aBoolean.
!

presentation
    "return the value of the instance variable 'presentation' (automatically generated)"

    presentation isNil ifTrue:[
        presentation := #asText.
    ].
    ^ presentation
!

presentation:something
    "set the value of the instance variable 'presentation' (automatically generated)"

    presentation := something.
!

semaChangeItem
    ^ semaChangeItem
!

type:aType

    super type:aType.
    self changeInformation.
! !

!FileApplicationNoteBook::TextEditor methodsFor:'actions'!

accept
    self saveWithAskForFilename:false.
!

askForChangeWithReload:doReload
    "ask for save changes; 
     if modified and answered true, the current contents is written back (accepted)
    "

    self askForChangeWithReload:doReload forClose:false
!

askForChangeWithReload:doReload forClose:forClose
    "ask for save changes; 
     if modified and answered true, the current contents is written back (accepted)
    "

    |fn answer string arg|

    self modifiedChannel value ifFalse:[ ^ false].

    fn := self fileName.
    fn isNil ifTrue:[
        fn := 'unknown'
    ] ifFalse:[
        fn := fn baseName.
    ].
    arg := fn allBold.

    string := 'Save changed file "%1" ?'.

    forClose ifTrue:[
        self itemChanged value ifTrue:[
            string := 'Modified %1 was changed by someone else.\\Save your changes (overwrite someone''s changes) ?' 
        ] ifFalse:[
            self itemRemoved value ifTrue:[
                string := 'Modified %1 was removed by someone else.\\Save your changes (recreate the removed file) ?' 
            ]
        ].
    ] ifFalse:[
        self itemChanged value ifTrue:[
            string := '%1 was changed by someone else.\\Save your changes anyway (overwrite someon''es changes) ?' 
        ] ifFalse:[
            self itemRemoved value ifTrue:[
                string := '%1 was removed by someone else.\\Save your changes anyway (recreate the removed file) ?' 
            ]
        ].
    ].

    answer := OptionBox 
                request:(resources stringWithCRs:string with:arg) 
                buttonLabels:(resources array:#('Cancel' 'Show Diffs' 'No' 'Yes')) 
                values:#(nil showDiffs false true) 
                default:nil.

    answer isNil ifTrue:[^ AbortOperationRequest raise ].

    answer == #showDiffs ifTrue:[
        self openDiffView.
        AbortOperationRequest raise
    ].

    answer ifTrue:[
        self accept
    ] ifFalse:[
        doReload ifTrue:[
            self setContents.
        ]
    ].
    ^ answer

    "Modified: / 11-09-2010 / 13:07:37 / cg"
!

changeInformation 

    |string win|

    string := self getTabString.
    masterApplication isNil ifTrue:[
        win := self window.
        win notNil ifTrue:[
            self window label:string asString string.
        ].
    ] ifFalse:[
        masterApplication tabStringChangeTo:string for:self.
    ].
!

changeInformationForModified:aSymbol 
    masterApplication isNil ifTrue:[ ^ self].
    masterApplication changeModified:aSymbol for:self.
!

doClose

    self askForChangeWithReload:false forClose:true.
    self masterApplication notNil ifTrue:[
        ^ super doClose
    ].
    ^ true
!

doPrint
    "print the contents
    "
    (Dialog confirm:'Print contents of editView ?') ifTrue:[
        editView doPrint.
    ].
!

doSaveAs
    self saveWithAskForFilename:true.
!

editOperationAddAnchorHTML
    |sel new|

    sel := editView selectionAsString.
    sel isNil ifTrue:[^ self].

    new := '<A HREF="http://www.exept.de">',editView selectionAsString,'</A>'.
    editView 
        undoableDo:[
            editView replaceSelectionBy:new keepCursor:false select:true
        ]
        info:'Add Anchor'

    "Created: / 02-08-2013 / 18:16:44 / cg"
!

editOperationAddImageHTML
    |new|

    new := '<IMG NOPRINT ALIGN="middle" SRC="xxx.png">'.
    editView 
        undoableDo:[
            editView insertStringAtCursor:new
        ]
        info:'Add Image'

    "Created: / 02-08-2013 / 18:17:26 / cg"
!

editOperationEscapeSpecialCharactersHTML
    |sel escaped|

    sel := editView selectionAsString.
    sel isNil ifTrue:[^ self].

    escaped := HTMLUtilities withSpecialHTMLCharactersEscaped:sel.    
    editView 
        undoableDo:[
            editView replaceSelectionBy:escaped keepCursor:false select:true
        ]
        info:'Escape HTML characters'
!

editOperationIndentCode
    editView indentBy4

    "Created: / 02-08-2013 / 18:20:18 / cg"
!

editOperationToggleBoldHTML
    self editOperationToggleHTML:'Toggle Bold' start:'<b>' end:'</b>'

    "Created: / 02-08-2013 / 18:04:27 / cg"
!

editOperationToggleCodeHTML
    self editOperationToggleHTML:'Toggle Code' start:'<code><pre>' end:'</pre></code>'
!

editOperationToggleHTML:info start:whatStart end:whatEnd
    |sel new|

    sel := editView selectionAsString.
    sel isNil ifTrue:[^ self].

    (sel asLowercase startsWith:whatStart) ifTrue:[
        new := sel copyFrom: whatStart size+1.
        (new asLowercase endsWith:whatEnd) ifTrue:[
            new := new copyButLast:whatEnd size.
        ]
    ] ifFalse:[
        new := whatStart,editView selectionAsString,whatEnd
    ].
    editView 
        undoableDo:[
            editView replaceSelectionBy:new keepCursor:false select:true
        ]
        info:info

    "Created: / 02-08-2013 / 18:14:25 / cg"
!

editOperationToggleItalicHTML
    self editOperationToggleHTML:'Toggle Italic' start:'<i>' end:'</i>'

    "Created: / 02-08-2013 / 18:14:55 / cg"
!

editOperationUndentCode
    editView undentBy4

    "Created: / 02-08-2013 / 18:22:47 / cg"
!

getContents
    |file fileSize contents presentation alreadyConfirmed answer sizeLimit showLastPart
     dontAskAgainHolder|

    file := self fileName.
    file isNil ifTrue:[
        ^ nil
    ].
    fileSize := file fileSize.
    fileSize isNil ifTrue:[
        ^ nil
    ].

    self enableSelectInBrowser value:true.

    presentation := self presentation.
    presentation == #asText ifTrue:[
        fileSize > (MaxFileSizeLoadedWithoutAsking ? (8 * 1024 * 1024)) ifTrue:[
            dontAskAgainHolder := false asValue.    
            answer := Dialog
                        confirmWithCancel:(resources
                                    stringWithCRs:'%1 is very large (%2).\\Show all or only the first 8 Mb ?' 
                                    with:file baseName allBold 
                                    with:(UnitConverter fileSizeStringFor:fileSize))
                        labels:(resources array:#('Cancel' 'Show All' 'Show Last Part' 'Show First Part' )) 
                        values:#(#abort #all #last #first) 
                        default:#abort 
                        check:(resources string:'Don''t ask again up to this size') on:dontAskAgainHolder 
                        title:(resources string:'Large File').

            answer == #all ifTrue:[
                dontAskAgainHolder value ifTrue:[
                    MaxFileSizeLoadedWithoutAsking := fileSize + 4096
                ]
            ].

"/ old
"/            answer := OptionBox  
"/                        request:(resources
"/                                    stringWithCRs:'%1 is very large (%2).\\Show all or only the first 8 Mb ?' 
"/                                    with:file baseName allBold 
"/                                    with:(UnitConverter fileSizeStringFor:fileSize))
"/                        label:(resources string:'Large File')
"/                        buttonLabels:(resources array:#('Cancel' 'Show All' 'Show Last Part' 'Show First Part' ))
"/                        values:#(#abort #all #last #first)
"/                        default:#abort.

"/ very old
"/            answer := Dialog
"/                            confirmWithCancel:(resources
"/                                                stringWithCRs:'%1 is very large (%2).\\Show all or only the first 4 Mb ?' 
"/                                                with:file baseName allBold 
"/                                                with:(UnitConverter fileSizeStringFor:fileSize))
"/                            labels:#('Cancel' 'Show All' 'Show First Part' ).
"/            answer isNil ifTrue:[^ nil].
"/            answer ifTrue:[
"/                sizeLimit := 4 * 1024 * 1024
"/            ].
            answer == #abort ifTrue:[^ nil ].
            answer ~~ #all ifTrue:[
                sizeLimit := 4 * 1024 * 1024.
                showLastPart := (answer == #last).
            ].
        ].
    ].

    ExternalStream readErrorSignal handle:[:ex |
        (Dialog confirm:('Read Error.\\Retry ?' withCRs))    
        ifTrue:[
            ^ ex restart
        ].
    ] do:[    
        ExternalStream lineTooLongErrorSignal handle:[ :ex |
            (alreadyConfirmed==true
            or:[ Dialog confirm:(file asString, ' contains very long line(s).\\Load anyway ?' withCRs)])    
            ifTrue:[
                alreadyConfirmed := true.
                ^ ex parameter second , ex parameter first nextLine
            ].
            ^ nil.
        ] do:[
            presentation == #asText ifTrue:[
                contents := self getContentsAsTextWithSizeLimit:sizeLimit lastPart:showLastPart.
            ] ifFalse:[
                presentation == #hexDump ifTrue:[
"/                    self withWaitCursorDo:[
                        contents := AbstractFileBrowser 
                                        contentsOfFileAsHexDump:file
                                        withLimit:sizeLimit 
                                        lastPart:showLastPart.
"/                    ]
                ]
            ]
        ].
    ].
    ^ contents.

    "Modified: / 27-03-2007 / 13:41:35 / cg"
!

getContentsAsTextWithSizeLimit:sizeLimitOrNil
    "returns the contents as unicode"

    ^ self getContentsAsTextWithSizeLimit:sizeLimitOrNil lastPart:false
!

getContentsAsTextWithSizeLimit:sizeLimitOrNilArg lastPart:showLastPartOrNil
    "returns the contents as unicode"

    |text guessedEncoding s sizeLimitOrNil|

    sizeLimitOrNil := sizeLimitOrNilArg.
    (self lockFileEncodingHolder value ? false) ifFalse:[
        guessedEncoding := CharacterEncoder guessEncodingOfFile:item fileName asFilename.
        guessedEncoding := guessedEncoding ? #'iso8859-1' "(self fileEncoding)".
        self fileEncoding:guessedEncoding asSymbol.
    ].

    editView notNil ifTrue:[
"/        self validateEditViewsFontEncoding.
        editView externalEncoding:self fileEncoding.
    ].

    s := self fileName readStream.
    [
        showLastPartOrNil == true ifTrue:[
            s position:(s fileSize - sizeLimitOrNil).
            sizeLimitOrNil := nil.
        ].

        text := self 
                    readStream:s 
                    lineDelimiter:(Character cr) 
                    sizeLimit:sizeLimitOrNil
                    encoding:self fileEncoding.
    ] ensure:[
        s close.
    ].
    ^ text
!

getHashForContents:contents
    | hashStream|

    self hasMD5 ifFalse:[^ nil].

    hashStream := MD5Stream new.
    (contents isCollection and:[ contents isString not ]) ifTrue:[
        contents do:[:eachLine |
            eachLine notNil ifTrue:[
                hashStream nextPutAll:(eachLine string withTabs).
            ].
            hashStream nextPut:Character cr.
        ].
    ] ifFalse:[
        hashStream nextPutAll:(contents string).
    ].
    ^ hashStream hashValue.

    "Modified: / 27-02-2012 / 22:10:18 / cg"
!

hideEditorOperationsToolBar
    self editorOperationsToolBarVisibleHolder value:false

    "Created: / 02-08-2013 / 16:12:00 / cg"
!

openDiffView
    |fn diffView text1 l1 text2 l2|

    (fn := self fileName) notNil ifTrue:[
        text1 := editView contentsAsString "asText".
        l1 := 'Editor'.
        text2 := self getContents.
        l2 := 'File: ' , fn baseName.
        diffView := DiffTextView openOn:text1 label:l1 and:text2 label:l2.
        diffView topView label:'File ' , fn baseName , ' vs. Editor Contents'.
    ].
!

readStream:aStream lineDelimiter:aCharacter encoding:fileEncodingArg 
    "read from aStream, answer its contents as StringCollection. 
     The file's lines are delimited by aCharacter.
     If encoding is nonNil, the file is assumed to be coded according to
     that symbol, and #decodeString: should be able to convert it into unicode.
     Always returns a unicode string."

    ^ self readStream:aStream lineDelimiter:aCharacter sizeLimit:nil encoding:fileEncodingArg
!

readStream:aStream lineDelimiter:lineDelimiter sizeLimit:sizeLimitOrNil encoding:fileEncodingArg 
    "read from aStream, answer its contents as StringCollection. 
     The file's lines are delimited by aCharacter.
     If encoding is nonNil, the file is assumed to be coded according to
     that symbol, and #decodeString: should be able to convert it into unicode.
     Always returns a unicode string."

    |text fileEncoding decoder firstDecoderError line lineNr|

    fileEncoding := fileEncodingArg ? #'iso8859-1'.
    decoder := CharacterEncoder encoderFor:fileEncoding.

    text := StringCollection new.

    firstDecoderError := true.
    lineNr := 1.

    DecodingError handle:[:ex | 
        |msg answer labels values|

        firstDecoderError ifTrue:[
            msg := resources stringWithCRs:'Error in decoder: %1\In Line: %2\\%3' with:ex errorString with:lineNr with:line.
            ex mayProceed ifTrue:[
                labels := #('Cancel' 'Ignore' 'Ignore All' 'Inspect Line').
                values := #(nil ignore ignoreAll inspectLine).
            ] ifFalse:[
                labels := #('Cancel' 'Inspect Line').
                values := #(nil inspectLine).
            ].

            answer := Dialog 
                confirmWithCancel:msg
                labels:(resources array:labels)
                values:values
                default:1
                title:'Error during decode'.
            answer isNil ifTrue:[ AbortOperationRequest raise ].
            answer == #ignoreAll ifTrue:[ firstDecoderError := false ].
            answer == #inspectLine ifTrue:[ line inspect. AbortOperationRequest raise ].
        ].
        ex proceedWith:(ex defaultValue).
    ] do:[
        FileStream lineTooLongErrorSignal handle:[:ex |
            |s partialLine|

            s := ex parameter at:1.
            partialLine := ex parameter at:2.
            ex proceedWith:(partialLine , (s upTo:lineDelimiter))
        ] do:[
            (decoder characterSize:0) == 2 ifTrue:[
                "a TwoByte decoder. Decode first and then process line breaks."
            
                |buffer|

                buffer := line := aStream upToEnd.
                buffer := decoder decodeString:buffer.
                buffer asCollectionOfLines do:[:line |
                    text add:line withTabsExpanded.
                ].
            ] ifFalse:[
                [aStream atEnd] whileFalse:[
                    lineDelimiter == Character cr ifTrue:[
                        line := aStream nextLine.
                    ] ifFalse:[
                        line := aStream upTo:lineDelimiter.
                    ].

                    line := line withTabsExpanded.
                    text add:(decoder decodeString:line).
                    sizeLimitOrNil notNil ifTrue:[
                        aStream position > sizeLimitOrNil ifTrue:[
                            ^ text
                        ]
                    ].
                    lineNr := lineNr + 1.
                ]
            ].
        ].
    ].
    ^ text

    "Modified: / 02-03-2007 / 15:09:30 / cg"
    "Modified (comment): / 22-11-2012 / 13:06:03 / cg"
!

reload

    textEditorModificationTime := self fileName modificationTime.
"/    self withWaitCursorDo:[
        self setContents.
"/    ].
    self setUpTextView

    "Modified: / 25-07-2006 / 09:09:55 / cg"
!

saveFileAs
    self saveWithAskForFilename:true
!

saveWithAskForFilename:ask

    |answer fn master defaultDir dir base fnDir|

    master := self masterApplication.
    (fn := self fileName) notNil ifTrue:[
        dir := fn directory.
        base := fn baseName.
    ].

    ask ifTrue:[
        defaultDir := master notNil ifTrue:[ master currentDirectory ] ifFalse:[ nil ].
        defaultDir isNil ifTrue:[
            fn notNil ifTrue:[
                defaultDir := dir.
            ]
        ].
        answer := Dialog
            requestFileNameForSave:(resources string:'Save contents in:') 
            default:base 
            fromDirectory:defaultDir.
        answer isEmptyOrNil ifTrue:[^ self].
        fn := answer asFilename.
    ].

    (master notNil and:[master class openAnotherApplicationOnSameItem]) ifTrue:[
        (self updateSameFilesFor:fn) ifFalse:[ ^ self ].
    ].

    fnDir := fn directory.
    fnDir exists ifFalse:[
        [
            fnDir recursiveMakeDirectory.
        ] on:OsError do:[:ex|
            Dialog warn:(ex description).
            ^ self.
        ]
    ].

    (editView saveAs:fn doAppend:false compressTabs:master compressTabsOnSave eolMode:master lineEndConvention) ifFalse:[^ self].

    textEditorModificationTime := self fileName modificationTime.

    self hasMD5 ifTrue:[
        md5CheckSum := self getHashForContents:self fileContentsModel value.
    ].

    self enableReload value:false.
    self itemChanged value:false.
    self itemRemoved value:false.
    self modifiedChannel value:false.
    self notify:self fileName asString, ' saved'.
    tagsBrowser notNil ifTrue:[
        tagsBrowser updateTagList
    ].

    "Modified: / 27-10-2010 / 10:41:29 / cg"
!

searchForPattern:aContentsPattern ignoreCase:ign

    | pattern |

    pattern := aContentsPattern string withoutSeparators. "/ is that a good idea ?
    pattern notEmpty ifTrue:[
        editView perform:#cursorHome ifNotUnderstood:[].
        editView rememberSearchPattern:pattern.
        editView searchFwd:pattern ignoreCase:ign.
    ]
!

selectInBrowser
    |application|

    application := self masterApplication.
    application notNil ifTrue:[
        application gotoFile:(self fileName).
    ].
!

setContents
    |text|

    self withReadCursorDo:[
        text := self getContents.
    ].
    text isNil ifTrue:[ ^ false].
    self withWaitCursorDo:[
        self setContentsFor:text.
    ].
    ^ true
!

setContentsFor:aUnicodeText
    self itemChanged value:false.

    self validateEditViewsFontEncoding.

    self fileContentsModel value:aUnicodeText.

    self hasMD5 ifTrue:[
        md5CheckSum := self getHashForContents:aUnicodeText.
    ].
    self enableReload value:false.
    self itemChanged value:false.
    self modifiedChannel value:false.
    self notify:nil.
    ^ true


"/
"/        oldEncoding := editView characterEncoding.
"/        oldEncoding ~= newEncoding ifTrue:[
"/self halt.
"/            (lines := editView contents) size > 0 ifTrue:[
"/                (Dialog 
"/                    confirm:('Re-Encode contents (from %1 to %2) ?'
"/                                bindWith:oldEncoding
"/                                with:newEncoding)
"/                ) ifTrue:[
"/                    recoder := CharacterEncoder 
"/                                encoderToEncodeFrom:oldEncoding
"/                                into:newEncoding.
"/                    lines keysAndValuesDo:[:lineNr :line |
"/                        line notNil ifTrue:[
"/                            editView at:lineNr put:(recoder encodeString:line).
"/                        ].
"/                    ].
"/                ]
"/            ].
"/        ].
!

showEditorOperationsToolBar
    self editorOperationsToolBarVisibleHolder value:true

    "Created: / 02-08-2013 / 16:11:52 / cg"
!

tagSelected:aTag
    editView deselect.  "/ otherwise, it might jump back to show the selection
    editView cursorLine:(aTag lineNumber) col:1.

    "Created: / 23-06-2011 / 16:38:07 / cg"
!

updateSameFilesFor:aFilename
    | master modifiedApplications stream filename action|

    master := self masterApplication.
    master notNil ifTrue:[
        modifiedApplications := master getSameFilesModifiedFor:self.
        (modifiedApplications isEmptyOrNil) ifTrue:[^ true ].
        filename := aFilename asString.
        stream := CharacterWriteStream with:filename.
        stream nextPutAll:' is modified in tab'.
        modifiedApplications size > 1 ifTrue:[
            stream nextPutAll:'s'.
        ].
        stream cr.
        modifiedApplications do:[ : el |
            stream space.
            stream nextPutAll:filename.
            stream space.
            el sameFileIndex notNil ifTrue:[
                stream nextPutAll:el sameFileIndex asString.        
            ].
            stream cr.
        ].
        stream nextPutAll:'forget changes on other tab'.        
        modifiedApplications size > 1 ifTrue:[
            stream nextPutAll:'s'.
        ].
        stream nextPutAll:' ?'.        
        action := Dialog 
            choose:stream contents 
            labels:#('Cancel' 'No' 'Yes') 
            values:#(#cancel #no #yes) 
            default:#cancel. 

        stream close.
        action == #cancel ifTrue:[ ^ false ].
        action == #yes ifTrue:[
            "/ here force reload for other applications
            modifiedApplications do:[ : el |
                el reload.
            ]            
        ].
    ].
    ^ true.

    "Modified: / 29-08-2013 / 01:37:18 / cg"
!

validateEditViewsFontEncoding
    |fileEncoding preferredFontEncoding fontsEncoding action|

    editView isNil ifTrue:[^ self].

    fileEncoding := self fileEncoding.

    fontsEncoding := editView font encoding ? #'iso8859-1'.

    preferredFontEncoding := FontDescription preferredFontEncodingFor:fileEncoding.
    (CharacterEncoder isEncoding:preferredFontEncoding subSetOf:fontsEncoding) ifFalse:[
            doNotShowFontDialog == true ifTrue:[
                action := #show
            ] ifFalse:[
                action := Dialog choose:(resources string:'''%1'' seems to require a %2 (or unicode) font (file encoding is %3).' 
                                                     with:self fileName baseName 
                                                     with:preferredFontEncoding allBold 
                                                     with:fileEncoding)
                               labels:(resources array:#('Cancel' 'Show' 'Don''t Ask Again' 'Change Font'))
                               values:#(nil #show #showAlways #encoding)
                               default:#encoding.
            ].
            action == #showAlways ifTrue:[
                doNotShowFontDialog := true.
                action := #show.
            ].
            action isNil ifTrue:[
                AbortOperationRequest raise
            ].
            action == #encoding ifTrue:[
                editView validateFontEncodingFor:fileEncoding ask:false.
            ].
    ].
! !

!FileApplicationNoteBook::TextEditor methodsFor:'aspects'!

canEdit
    ^ editView notNil and:[editView isReadOnly not]

    "Created: / 02-08-2013 / 16:45:34 / cg"
!

cursorColLabelHolder
    ^ BlockValue 
        with:[:v | v printString]
        argument:editView cursorColHolder.
!

cursorLineAndColumnLabelHolder
    ^ editView cursorLineAndColumnLabelHolder.
!

cursorLineLabelHolder
    ^ BlockValue 
        with:[:v | v printString]
        argument:editView cursorLineHolder.
!

editModeInsert
    editView editModeInsert

    "Created: / 11-09-2006 / 12:46:50 / cg"
!

editModeInsertAndSelect
    editView editModeInsertAndSelect

    "Created: / 11-09-2006 / 12:47:01 / cg"
!

editModeOverwrite
    editView editModeOverwrite

    "Created: / 11-09-2006 / 12:46:47 / cg"
!

editView
    ^ editView
!

editorOperationsMenuSpecHolder
    editorOperationsMenuSpecHolder isNil ifTrue:[
        editorOperationsMenuSpecHolder := self class menuEditorOperationsForNormalText asValue.
    ].
    ^ editorOperationsMenuSpecHolder

    "Created: / 02-08-2013 / 16:35:49 / cg"
!

editorOperationsToolBarNotVisibleHolder
    ^ BlockValue forLogicalNot:self editorOperationsToolBarVisibleHolder

    "Created: / 02-08-2013 / 16:11:02 / cg"
!

editorOperationsToolBarVisibleHolder
    editorOperationsToolBarVisibleHolder isNil ifTrue:[
        editorOperationsToolBarVisibleHolder := (DefaultEditorOperationsToolBarVisible ? true) asValue.
        editorOperationsToolBarVisibleHolder onChangeSend:#editorOperationsToolBarVisibilityChanged to:self.
    ].
    ^ editorOperationsToolBarVisibleHolder

    "Created: / 02-08-2013 / 15:59:43 / cg"
!

enableHexToggle
    enableHexToggle isNil ifTrue:[
        enableHexToggle := true asValue.
    ].
    ^ enableHexToggle
!

enableReload
    enableReload isNil ifTrue:[
        enableReload := false asValue.
    ].
    ^ enableReload.
!

enableSave
    enableSave isNil ifTrue:[
        enableSave := false asValue.
    ].
    ^ enableSave.
!

enableSaveAs
    ^ true.
!

enableSelectInBrowser
    enableSelectInBrowser isNil ifTrue:[
        enableSelectInBrowser := false asValue.
    ].
    ^ enableSelectInBrowser.
!

fileContentsModel
    fileContentsModel isNil ifTrue:[
        fileContentsModel := ValueHolder new.
    ].
    ^ fileContentsModel.
!

fileEncodingHolder
    fileEncodingHolder isNil ifTrue:[
        fileEncodingHolder := #'iso8859-1' asValue
    ].
    ^ fileEncodingHolder
!

itemChanged
    itemChanged isNil ifTrue:[
        itemChanged := false asValue.
        itemChanged addDependent:self.
    ].
    ^ itemChanged
!

itemRemoved
    itemRemoved isNil ifTrue:[
        itemRemoved := false asValue.
        itemRemoved addDependent:self.
    ].
    ^ itemRemoved
!

lockFileEncodingHolder
    lockFileEncodingHolder isNil ifTrue:[
        lockFileEncodingHolder := false asValue.
    ].
    ^ lockFileEncodingHolder
!

modeLabelHolder
    ^ editView modeLabelHolder.
!

modeLabelMenu
    ^ FileBrowserV2 editModeInfoLabelMenu

    "Created: / 11-09-2006 / 12:36:26 / cg"
!

modifiedChannel
    modifiedChannel isNil ifTrue:[
        modifiedChannel := false asValue.
        modifiedChannel addDependent:self.
    ].
    ^ modifiedChannel.
!

printAsHexDump
    printAsHexDump isNil ifTrue:[
        printAsHexDump := false asValue.
        printAsHexDump addDependent:self.
    ].
    ^ printAsHexDump.
!

viewModifiedChannel
    viewModifiedChannel isNil ifTrue:[
        viewModifiedChannel := false asValue.
        viewModifiedChannel addDependent:self.
    ].
    ^ viewModifiedChannel.
! !

!FileApplicationNoteBook::TextEditor methodsFor:'aspects-visibility'!

closeButtonShown
    ^ false.
"/    ^ self isEmbeddedApplication.

    "Created: / 12-01-2012 / 00:32:15 / cg"
!

diffTextButtonVisible
    ^ self fileName notNil "/ true
!

doItMenuButtonVisible
    ^true

    "Created: / 17-12-2013 / 16:31:40 / cg"
!

inspectItMenuButtonVisible
    ^true

    "Created: / 17-12-2013 / 16:31:49 / cg"
!

printItMenuButtonVisible
    ^true

    "Created: / 17-12-2013 / 16:31:45 / cg"
!

reloadButtonVisible
    ^ self fileName notNil "/ true
!

saveAsButtonVisible
    ^ true
!

saveButtonVisible
    ^ self fileName notNil "/ true
!

selectInBrowserButtonVisible
    ^ self masterApplication notNil
!

tagsBrowserVisibleHolder
    tagsBrowserVisibleHolder isNil ifTrue:[
        masterApplication notNil ifTrue:[
            tagsBrowserVisibleHolder := masterApplication tagsBrowserVisibleHolder.
        ] ifFalse:[
            tagsBrowserVisibleHolder := self class defaultTagsBrowserVisible asValue.
        ].
        tagsBrowserVisibleHolder addDependent:self.
    ].
    ^ tagsBrowserVisibleHolder

    "Created: / 23-06-2011 / 09:19:18 / cg"
    "Modified: / 06-10-2011 / 12:46:41 / cg"
! !

!FileApplicationNoteBook::TextEditor methodsFor:'change & update'!

changeTextColorForChanged
    |text prevCursorBehavior|

    prevCursorBehavior := editView cursorMovementWhenUpdating.
    editView cursorMovementWhenUpdating:nil.

    self itemChanged value ifTrue:[
        text := editView contents.
        self fileContentsModel 
            value:(text asText emphasizeAllWith:UserPreferences current emphasisForChangedCode).
        editView pushEvent:#flash.
    ] ifFalse:[
        "/ self fileContentsModel value:text string.
    ].
    editView cursorMovementWhenUpdating:prevCursorBehavior.
    "/ self fileContentsModel changed:#value.
!

editorOperationsToolBarVisibilityChanged
    |editorToolBar editorOperationsToolBar editor topOffset editorOperationsToolBarVisible|

    editorToolBar := self componentAt:#MenuTextEditor.

    editorOperationsToolBar := self componentAt:#EditorOperationsToolBar.
    editor := self componentAt:#TextEditor.

    topOffset := editorToolBar height.
    editorOperationsToolBarVisible := self editorOperationsToolBarVisibleHolder value.
    DefaultEditorToolBarVisible := editorOperationsToolBarVisible.
    editorOperationsToolBarVisible ifTrue:[
        topOffset := topOffset + editorOperationsToolBar height.
    ].

    topOffset := topOffset - 1.
    editor layout topOffset:topOffset.
    editor container notNil ifTrue:[
        editor containerChangedSize.
    ].

    "Created: / 02-08-2013 / 16:01:01 / cg"
!

itemModified

    | modified outDated removed|

    modified := self modifiedChannel value.
    outDated := self itemChanged value.    
    removed := self itemRemoved value.    

    (modified or:[outDated or:[removed]]) ifTrue:[
        modified ifTrue:[
            self changeInformationForModified:#modified.
        ].
        outDated ifTrue:[
            self changeInformationForModified:#outDated.
        ].
        removed ifTrue:[
            self changeInformationForModified:#removed.
        ].
    ] ifFalse:[
        self changeInformationForModified:#unchanged.
    ].

    self enableReload value:((modified or:[outDated]) and:[removed not]).
!

postBuildTagsBrowser:aTagsBrowserCanvas
    tagsBrowser := aTagsBrowserCanvas application.
    tagsBrowser action:[:selectedTag | self tagSelected:selectedTag ].
    self updateTagsBrowser.

    "Created: / 23-06-2011 / 16:30:00 / cg"
!

tagsBrowserVisibilityChanged
    |visible tagsBrowserCanvas|

    tagsBrowser notNil ifTrue:[
        tagsBrowserCanvas := tagsBrowser window.
    ].

    (visible := self tagsBrowserVisibleHolder value) ifTrue:[
        tagsBrowser isNil ifTrue:[
            tagsBrowserCanvas := ApplicationSubView new.

            tagsBrowser := Tools::TagsBrowser new.
            tagsBrowser window:tagsBrowserCanvas.
            tagsBrowser allButOpen.

            (self builder componentAt:#Panel) 
                addComponent:tagsBrowserCanvas;
                relativeCorners:#(0.75 1.0).
            tagsBrowserCanvas realize.
            self postBuildTagsBrowser:tagsBrowserCanvas.
        ] ifFalse:[
            tagsBrowserCanvas map.
            (self builder componentAt:#Panel) 
                relativeCorners:#(0.75 1.0).
        ].

        self updateTagsBrowser.
    ] ifFalse:[
        tagsBrowser notNil ifTrue:[
            tagsBrowserCanvas unmap.
            (self builder componentAt:#Panel) relativeCorners:#(1.0 1.0).
        ].
    ].
    DefaultTagsBrowserVisible := visible

    "Created: / 27-06-2011 / 16:06:00 / cg"
    "Modified: / 06-10-2011 / 12:45:20 / cg"
!

update:something with:aParameter from:changedObject
    |itemRem contMd5CheckSum viewModified p|

    changedObject == self viewModifiedChannel ifTrue:[
        viewModified := changedObject value.
        self hasMD5 ifTrue:[
            self viewModifiedChannel value:false withoutNotifying:self.
            viewModified ifTrue:[
                (p := md5HashValueComputationProcess) notNil ifTrue:[
                    p terminate.
                ].
                md5HashValueComputationProcess := 
                    [
                        contMd5CheckSum := self getHashForContents:(editView list).
                        self modifiedChannel value:(contMd5CheckSum ~= md5CheckSum).
                        md5HashValueComputationProcess := nil.
                    ] newProcess.
                md5HashValueComputationProcess priority:(Processor userBackgroundPriority).
                md5HashValueComputationProcess resume.
            ].
        ] ifFalse:[
            self modifiedChannel value:viewModified.
        ]
    ].
    changedObject == self modifiedChannel ifTrue:[
        self enableSave value:changedObject value.
        self itemModified.
        ^ self
    ].
    changedObject == self itemRemoved ifTrue:[
        itemRem := changedObject value.
        self enableSave value:(itemRem ? false).
        self enableHexToggle value:itemRem not.
        self itemModified.
        ^ self
    ].
    changedObject == self itemChanged ifTrue:[
        self enqueueMessage:#changeTextColorForChanged for:self arguments:#().
        self itemModified.
        ^ self
    ].

    changedObject == self printAsHexDump ifTrue:[
        AbortOperationRequest handle:[:ex |
            self printAsHexDump value:false withoutNotifying:self.
            ^ self.
        ] do:[
            self askForChangeWithReload:true. 
        ].
        self presentation:(changedObject value ifTrue:[#hexDump] ifFalse:[#asText]).
        self changeInformation.
        self setContents.
        editView notNil ifTrue:[
            editView readOnly:(self presentation == #hexDump).   
        ].
        ^ self
    ].
    changedObject == editView cursorLineHolder ifTrue:[
        tagsBrowser notNil ifTrue:[
            tagsBrowser updateForLine:(changedObject value).
        ].
        ^ self
    ].
    changedObject == tagsBrowserVisibleHolder ifTrue:[
        self tagsBrowserVisibilityChanged.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 29-06-2011 / 19:36:03 / cg"
!

updateTagsBrowser
    tagsBrowser notNil ifTrue:[
        self tagsBrowserVisibleHolder value ifTrue:[
            tagsBrowser editedFile:(self item isNil ifTrue:[nil] ifFalse:[self item fileName]).
        ]
    ]

    "Created: / 23-06-2011 / 16:32:44 / cg"
! !

!FileApplicationNoteBook::TextEditor methodsFor:'initialization'!

initialize
    super initialize.
    semaChangeItem := Semaphore forMutualExclusion.
! !

!FileApplicationNoteBook::TextEditor methodsFor:'printing'!

printOn:aStream
    |fn|

    aStream nextPutAll:'TextEditor for:'.
    (fn := self fileName) notNil ifTrue:[
        fn baseName printOn:aStream.
    ]
! !

!FileApplicationNoteBook::TextEditor methodsFor:'private-process'!

checkItemForChanges
    |exists fileModificationTime message|

    item isNil ifTrue:[
        ^ self
    ].

    exists := self item exists.
    self itemRemoved value:(exists not).
    exists ifTrue:[
        fileModificationTime := self fileName modificationTime.
        textEditorModificationTime isNil ifTrue:[
            textEditorModificationTime := fileModificationTime.
        ].
        message := '%1 was changed by someone else.'.
    ] ifFalse:[
        message := '%1 was removed by someone else.'.
    ].

    (textEditorModificationTime ~= fileModificationTime) ifTrue:[
        "file contents has been changed by someone else"
        message := (resources string:message with:item fileName baseName) allBold
                        emphasisAllAdd:(UserPreferences current emphasisForModifiedBuffer).
        message = self notifyChannel value ifFalse:[
            self notify:message.
            self itemChanged value:true.
        ].
    ].
!

checkItemForChangesWithNewSetup
    self checkItemForChanges.
    self setupCheckModify.
!

releaseCheckModify
    checkModifiedBlock notNil ifTrue:[
        Processor removeTimedBlock:checkModifiedBlock.
    ].
!

setupCheckModify

    checkModifiedBlock isNil ifTrue:[
        checkModifiedBlock := [
                self 
                    enqueueMessage:#checkItemForChangesWithNewSetup 
                    for:self 
                    arguments:#().
            ].
    ].
    Processor addTimedBlock:checkModifiedBlock afterSeconds:(self class checkModifiedDelayTime).
! !

!FileApplicationNoteBook::TextEditor methodsFor:'queries'!

additionalInfo
    ^ '[',editView numberOfLines printString , ' lines]'.

    "Created: / 24-10-2006 / 12:27:07 / cg"
!

hasMD5
    ^ ( MD5Stream notNil and:[MD5Stream isLoaded])
!

isModified
    self checkItemForChanges.
    ^ self modifiedChannel value 
        or:[ self itemChanged value or:[ self itemRemoved value ] ]
!

isTextEditor

    ^ true
! !

!FileApplicationNoteBook::TextEditor methodsFor:'startup & release'!

closeRequest
    "asks for permission before closing"

    (self doClose) ifTrue:[
        ^ super closeRequest.
    ].
!

editorOperationsMenuSpecForMimeType:mimeType
    mimeType isHtmlType ifTrue:[
        ^ self class menuEditorOperationsForHTML.
    ].
    mimeType isSmalltalkSourceType ifTrue:[
        ^ self class menuEditorOperationsForSourceCode.
    ].
    mimeType isTextType ifTrue:[
        ^ self class menuEditorOperationsForNormalText.
    ].

    ^ self class menuEditorOperationsForOther.

    "Created: / 02-08-2013 / 18:00:39 / cg"
!

getEditorClass
    UserPreferences current useCodeView2InTools ifTrue:[
        ^ Tools::CodeView2 ? CodeView
    ].
    ^ CodeView

    "Created: / 06-10-2011 / 11:21:43 / cg"
!

hideEditorOperationsToolBarButtonCreated:aButton
    aButton passiveLevel:(MenuPanel defaultLevel).
    aButton activeLevel:-1.
    aButton backgroundColor:(MenuPanel defaultBackgroundColor).

    "Created: / 02-08-2013 / 16:01:49 / cg"
!

postBuildTextEditor:aWidget
    editView := aWidget scrolledView.

    "/ I don't want any non-smalltalk code to be syntaxhighlighted!!
    (editView askFor: #isCodeView2) ifTrue:[
        editView languageHolder value:nil.
        editView services:#().
    ].
    editView saveAction:[ self doSaveAs ].
    editView cursorLineHolder addDependent:self.

    aWidget modifiedChannel:self viewModifiedChannel.

    editView externalEncoding:self fileEncoding.
    "/ editView characterEncoding:'unicode'. - that's the default anyway

    "Modified: / 06-10-2011 / 11:43:40 / cg"
    "Modified (comment): / 03-12-2011 / 10:27:47 / cg"
!

postOpenWith:aBuilder

"/    self item isNil ifTrue:[
"/        self item:(DirectoryContentsBrowser itemClass fileName:(Filename homeDirectory construct:'.bashrc')).
"/    ].
    (self componentAt:#EditorOperationsToolBar) menuHolder:self editorOperationsMenuSpecHolder.

    self setUpTextView.
    self changeInformation.
    self tagsBrowserVisibilityChanged.
    super postOpenWith:aBuilder

    "Modified: / 02-08-2013 / 17:57:50 / cg"
!

release
    "release my resources
    "                    
    self releaseCheckModify.
    checkModifiedBlock := nil.
    super release.
!

setUpTextView
    "care for any contents specific settings for the editor
     For example:
        - change the parenthesis-spec of the editor to include $< .. $> if the
          shown document is an html- or xml document,
        - change the editorOperationsMenu
    "

    |item mimeType suffix parenthesis commentStrings parentesisSpec col|

    editView notNil ifTrue:[
        item := self item.
        item notNil ifTrue:[
            item hasMimeType ifTrue:[
                mimeType := item mimeType.
                suffix := self fileName asFilename suffix.

                (mimeType isHtmlType or:[mimeType isXmlType]) ifTrue:[
                    parenthesis := editView parenthesisSpecification copy.
                    ((parenthesis at:#open) includes:$<) ifFalse:[
                        col := ((parenthesis at:#open) asOrderedCollection).
                        col add:$<.
                        parenthesis at:#open put:col.

                        col := ((parenthesis at:#close) asOrderedCollection).
                        col add:$>.
                        parenthesis at:#close put:col.

                        editView parenthesisSpecification:parenthesis
                    ].
                ].

                commentStrings := MIMETypes 
                                    commentStringsForMimeType:mimeType 
                                    suffix:suffix 
                                    ifUnknown:[
                                        "/ st:
                                        #('"/' ('"' '"'))
                                    ]. 

                commentStrings notNil ifTrue:[
                    editView perform:#commentStrings: with:commentStrings ifNotUnderstood:nil
                ].

                parentesisSpec := MIMETypes 
                                    parenthesisSpecForMimeType:mimeType 
                                    suffix:suffix 
                                    ifUnknown:[
                                        |spec|
                                        spec := IdentityDictionary new.       
                                        spec at:#open        put:'([{' "#( $( $[ ${)" .
                                        spec at:#close       put:')]}' "#( $) $] $})".
                                        spec
                                    ]. 

                parentesisSpec notNil ifTrue:[
                    editView perform:#parenthesisSpecification: with:parentesisSpec ifNotUnderstood:nil
                ].
                self setupEditorOperationsMenuForMimeType:mimeType.
            ] ifFalse:[
                self setupEditorOperationsMenuForMimeType:(MIMETypes mimeTypeFromString:'text/plain').
            ]
        ].
        editView externalEncoding:self fileEncoding.
    ]

    "Modified: / 02-08-2013 / 16:34:34 / cg"
!

setupEditorOperationsMenuForMimeType:mimeType
    |spec|

    spec := self editorOperationsMenuSpecForMimeType:mimeType.

    "/ does not work - why?
    "/ self editorOperationsMenuSpecHolder value:spec.

    (self componentAt:#EditorOperationsToolBarMenu) menu:spec.

    "Created: / 02-08-2013 / 16:35:21 / cg"
! !

!FileApplicationNoteBook::XMLViewApplication class methodsFor:'defaults'!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'XML View for %1'

    "Modified: / 17-02-2011 / 13:28:22 / cg"
! !

!FileApplicationNoteBook::XMLViewApplication class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileApplicationNoteBook::HtmlViewApplication    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(


)

    "Modified: / 17-02-2011 / 13:28:28 / cg"
! !

!FileApplicationNoteBook::XMLViewApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::XMLViewApplication andSelector:#windowSpec
     FileApplicationNoteBook::XMLViewApplication new openInterface:#windowSpec
     FileApplicationNoteBook::XMLViewApplication open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'NoteBookApplication::HtmlView'
          name: 'NoteBookApplication::HtmlView'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 676 492)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'MenuXml'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              level: 0
              visibilityChannel: isEmbeddedApplication
              menu: menu
              textDefault: true
            )
           (SubCanvasSpec
              name: 'XMLCanvas'
              layout: (LayoutFrame 0 0.0 32 0.0 0 1.0 0 1)
              level: 0
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'XML::XMLInspector'
              createNewApplication: true
              createNewBuilder: false
              postBuildCallback: postBuildXMLCanvas:
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::XMLViewApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileApplicationNoteBook::XMLViewApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(FileApplicationNoteBook::XMLViewApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: reloadFile
            isVisible: reloadButtonVisible
            enabled: enableReload
            label: 'Reload'
            itemValue: reload
            nameKey: Reload
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadTextFromFileIcon)
          )
         (MenuItem
            activeHelpKey: closeTabButton
            label: 'Close'
            itemValue: doClose
            translateLabel: true
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary removeTabIcon)
          )
         )
        nil
        nil
      )

    "Modified: / 17-02-2011 / 17:30:26 / cg"
! !

!FileApplicationNoteBook::XMLViewApplication class methodsFor:'queries'!

canOpenItem:anItem
    |mime|
    
    (Smalltalk at:#'XML::XMLInspector') isNil ifTrue:[^ false].
    ((mime := anItem mimeType) isNil or:[ mime == #unknown]) ifTrue:[^ false].
    
    ^ mime isXmlType

    "Modified: / 17-02-2011 / 13:34:08 / cg"
!

wantNewApplicationAnyway

    ^ false
! !

!FileApplicationNoteBook::XMLViewApplication methodsFor:'accessing'!

item:anItem 
    |retVal|

    self labelHolder value:anItem fileName asString.
    retVal := super item:anItem.
    xmlTreeApp notNil ifTrue:[
        self updateXMLTree
    ].
    ^ retVal

    "Modified: / 17-02-2011 / 13:38:53 / cg"
!

updateXMLTree
    |inStream dom|

    self withWaitCursorDo:[
        XML::XMLSignal handle:[:ex |
            Dialog 
                information:
                    (resources 
                        stringWithCRs:'Error reported by XML-Parser in line %1:\\%2\\Showing as regular text.' 
                        with:inStream lineNumber 
                        with:ex description).
            Error raise.
        ] do:[
            inStream := LineNumberReadStream on:(self fileName readStream).
            [
                dom := XML::XMLParser 
                        processDocumentStream:inStream
                        beforeScanDo:[:parser | parser validate:false. ].
                xmlTreeApp model:dom.
            ] ensure:[
                inStream close
            ]
        ].
    ].

    "Created: / 17-02-2011 / 13:39:07 / cg"
    "Modified: / 17-02-2011 / 17:39:15 / cg"
! !

!FileApplicationNoteBook::XMLViewApplication methodsFor:'actions'!

reload
    self updateXMLTree.

    "Created: / 17-02-2011 / 17:46:36 / cg"
! !

!FileApplicationNoteBook::XMLViewApplication methodsFor:'aspects'!

labelHolder

    labelHolder isNil ifTrue:[
        labelHolder := '' asValue.
    ].
    ^ labelHolder.
! !

!FileApplicationNoteBook::XMLViewApplication methodsFor:'initialization & release'!

postBuildXMLCanvas:aWidget
    xmlTreeApp := aWidget client.
    item notNil ifTrue:[self updateXMLTree].

    "Modified: / 17-02-2011 / 13:39:18 / cg"
! !

!FileApplicationNoteBook::XViewApplication class methodsFor:'defaults'!

maxNumberOfVNCRestarts

    ^ 10
!

mimeTypeUnixApplicationMapping

" here insert the application and mime type pairs to open by XviewApplication
"

    ^
    #(
        #(#'application/postscript'     'gv %1'           )
        #(#'application/pdf'            'acroread %1'     )
    )
!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ 'VNC for %1'

    "Modified: / 01-03-2007 / 21:43:43 / cg"
!

unixVNCCommand

    ^ 'Xvnc'
!

wantNewApplicationAnyway

    ^ true
! !

!FileApplicationNoteBook::XViewApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileApplicationNoteBook::XViewApplication andSelector:#windowSpec
     FileApplicationNoteBook::XViewApplication new openInterface:#windowSpec
     FileApplicationNoteBook::XViewApplication open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'XView'
          #name: 'XView'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 16 42 692 534)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'MenuVNC'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              #level: 0
              #visibilityChannel: #isEmbeddedApplication
              #menu: #menu
              #textDefault: true
            )
           #(#ArbitraryComponentSpec
              #name: 'VNCView'
              #layout: #(#LayoutFrame 0 0.0 32 0.0 0 1.0 0 1.0)
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: false
              #miniScrollerVertical: false
              #hasBorder: false
              #component: #VNCFrameBufferView
              #postBuildCallback: #postBuildXView:
            )
           )
         
        )
      )
! !

!FileApplicationNoteBook::XViewApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NoteBookApplication::ImageViewApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(NoteBookApplication::ImageViewApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #activeHelpKey: #closeTabButton
            #label: 'Close'
            #translateLabel: true
            #isButton: true
            #hideMenuOnActivated: false
            #startGroup: #right
            #value: #doClose
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #removeTabIcon)
          )
         )
        nil
        nil
      )
! !

!FileApplicationNoteBook::XViewApplication class methodsFor:'queries'!

canOpenItem:anItem
    | keySym|
    
    keySym := anItem mimeType asSymbol.
    OperatingSystem isUNIXlike ifFalse:[^ false].

    (self mimeTypeUnixApplicationMapping contains:[ : el | (el at:1) == keySym ]) ifFalse:[^ false].

    (OperatingSystem executeCommand:('which ', self unixVNCCommand)) ifFalse:[
        "/ Dialog warn:'Cannot start a viewer for ' , anItem fileName baseName.
        ^ false.
    ].

    VNCFrameBufferView notNil ifFalse:[
        Dialog warn:'VNC support classes are missing (package not loaded?)'.
        ^ false.
    ].
    ^ true
! !

!FileApplicationNoteBook::XViewApplication methodsFor:'accessing'!

xView
    "return the value of the instance variable 'imageView' (automatically generated)"

    ^ xView
!

xView:something
    "set the value of the instance variable 'imageView' (automatically generated)"

    xView := something.
! !

!FileApplicationNoteBook::XViewApplication methodsFor:'actions'!

changeInformation 
    |stream|

    stream := CharacterWriteStream with:'XView on: '.
    stream nextPutAll:self fileName baseName.
    masterApplication isNil ifTrue:[
        self window label:stream contents.
    ] ifFalse:[
        masterApplication tabStringChangeTo:stream contents for:self.
    ].
!

setupXView

    |xExt yExt mainView|

    self startVNCserver.
    xExt := self xView width asString.
    self masterApplication notNil ifTrue:[
        mainView := self builder windowGroup mainView.
        "/ if the mainView is a FileBrowser take them y extent because size of notebook can be changed
        (mainView application class == (Smalltalk at:#FileBrowserV2 ifAbsent:nil)) notNil ifTrue:[
            yExt := mainView height asString.
        ].
    ].
    yExt isNil ifTrue:[
        yExt := self xView height asString.
    ].
    ext := xExt, 'x', yExt.    
    self startViewer.
! !

!FileApplicationNoteBook::XViewApplication methodsFor:'actions VNC'!

setupView
    |  renderer view|

    view := xView.
    renderer := VNCRenderer for:vncConnection targetWindow:view device:xView device.

    view renderer:renderer.
    view connection:vncConnection.

    VNCException handle:[:ex|
        self stopViewer.
    ] do:[
        vncConnection 
            startMessageHandlerProcessForRenderer:renderer
            errorHandler:[:ex | self stopViewer].
    ].
!

startVNCserver
    |cmd blocked connected numberOfVncStarts|


    VNCAuthenticationFailure isNil ifTrue:[
        Dialog warn:'VNC Classes missing (package not laoded ?)'.
        ^ self.
    ].

    connected := false.
    numberOfVncStarts isNil ifTrue:[
        numberOfVncStarts := 1.
    ] ifFalse:[
        numberOfVncStarts := numberOfVncStarts + 1.
    ].

    vncLock isNil ifTrue:[vncLock := Semaphore forMutualExclusion].

    vncServerPID isNil ifTrue:[
        cmd := ('/usr/X11R6/bin/', self class unixVNCCommand).
        cmd asFilename exists ifFalse:[
            cmd := self class unixVNCCommand.
        ].
        vncPortNr isNil ifTrue:[
            vncPortNr := 29
        ].
        cmd := cmd , ' :' , vncPortNr printString , ' nologo -nevershared -localhost -depth 16 -geometry 1024x1024'.

        blocked := OperatingSystem blockInterrupts.

        vncServerPID := Processor
                   monitor:[
                      vncServerIsTerminated := false.
                      OperatingSystem
                          exec:'/bin/sh'
                          withArguments:(Array with:'sh' with:'-c' with:cmd)
                          environment:nil
                          fileDescriptors:#()
                          fork:true
                          newPgrp:true
                          inDirectory:nil
                          showWindow:false.
                   ]
                   action:[:status |
                      status stillAlive ifFalse:[
                          OperatingSystem closePid:vncServerPID.
                          vncLock critical:[  
                             vncServerPID := nil.
                             self vncServerTerminated.
                          ].
                      ].
                  ].

        blocked ifFalse:[
            OperatingSystem unblockInterrupts
        ].
    ].

    self waitForTerminationOfServer ifTrue:[
"/        Transcript showCR:'server has terminated really - try with next port'.
        (numberOfVncStarts < self class maxNumberOfVNCRestarts) ifTrue:[
            vncPortNr := vncPortNr + 1.
"/            Transcript showCR:'try next port ', vncPortNr asString.
            self startVNCserver.
        ] ifFalse:[
            Dialog warn:'have started servers from port '
                      , (vncPortNr - self class maxNumberOfVNCRestarts) asString
                      , ' to '
                      , vncPortNr
                      , ' - cant connect anyway'.
"/            Transcript showCR:'have started servers from port ', vncPortNr - self class maxNumberOfVNCRestarts, ' to ', vncPortNr.
        ].
    ] ifFalse:[
        vncLock critical:[  
            vncServerPID isNil ifTrue:[
                Dialog warn:'Cannot start Xvnc'.
            ] ifFalse:[
                VNCAuthenticationFailure handle:[:ex |
                    Dialog warn:'Wrong password'.
                ] do:[
                    connected := self vncConnect.
                ].
                connected ifTrue:[self setupView].
            ].
        ].
    ].
!

stopVNCServer
    |pid|

    (pid := vncServerPID) notNil ifTrue:[
        OperatingSystem terminateProcess:pid.
        Delay waitForSeconds:0.2.
        vncServerPID notNil ifTrue:[
            OperatingSystem killProcess:pid.
            vncServerPID := nil.
        ].
        OperatingSystem closePid:pid
    ].
    self vncServerTerminated.
!

vncConnect
    |  tryConnects|

    vncConnection notNil ifTrue:[
        vncConnection close
    ].

    vncConnection := VNCServerConnection new.
    tryConnects := 1.
    [tryConnects < 3] whileTrue:[
        VNCConnectionFailure handle:[:ex |
            Delay waitForSeconds:0.5.
            tryConnects := tryConnects + 1.
        ] do:[
            vncConnection connectTo:'localhost' port:vncPortNr.
            ^ true.
        ].
    ].
    ^ false
!

vncServerTerminated
"/    Transcript showCR:'vnc server has terminated'.
"/    'vnc server has terminated' errorPrintCR.
    "/ Dialog information:'vnc server has terminated'.

    self stopViewer.
    vncConnection notNil ifTrue:[
        vncConnection close.
        vncConnection := nil
    ].
    vncServerIsTerminated := true.
!

waitForTerminationOfServer
    | cycles |

    cycles := 1.
    [vncServerIsTerminated] whileFalse:[
        (cycles > 3) ifTrue:[^ false].
        cycles := cycles + 1.
        Delay waitForSeconds:0.5.
    ].
    ^ true
! !

!FileApplicationNoteBook::XViewApplication methodsFor:'actions viewer'!

startViewer
    |cmd keySym applItem |

    keySym := self item mimeType asSymbol.
    applItem := self class mimeTypeUnixApplicationMapping detect:[ : el | (el at:1) == keySym ] ifNone:[nil].
    applItem isNil ifTrue:[ ^ self].
    
    cmd := (applItem at:2) asString, ' -geometry ', ext, ' -display :' , vncPortNr printString , ' ' , self fileName asString.
    self startViewer:cmd
!

startViewer:viewerCommand
    |blocked|

    viewerPID notNil ifTrue:[
        ^ self
    ].

    blocked := OperatingSystem blockInterrupts.

    viewerPID := Processor
               monitor:[
                  OperatingSystem
                      exec:'/bin/sh'
                      withArguments:(Array with:'sh' with:'-c' with:viewerCommand)
                      environment:nil
                      fileDescriptors:#()
                      fork:true
                      newPgrp:true
                      inDirectory:nil
                      showWindow:false.
               ]
               action:[:status |
                  status stillAlive ifFalse:[
                      OperatingSystem closePid:viewerPID.
                      viewerPID := nil.
                      self viewerTerminated.
                  ].
               ].

    blocked ifFalse:[
        OperatingSystem unblockInterrupts
    ].

    viewerPID isNil ifTrue:[
        Dialog warn:'Cannot start ', viewerCommand.
    ].
!

startXterm
    |cmd|

    cmd := 'xterm -geometry 600x800 -display :' , vncPortNr printString.
    self startViewer:cmd
!

stopViewer
    |pid|

    (pid := viewerPID) notNil ifTrue:[
        OperatingSystem terminateProcess:pid.
        Delay waitForSeconds:0.2.
        viewerPID notNil ifTrue:[
            OperatingSystem killProcess:pid.
            viewerPID := nil.
        ].
        OperatingSystem closePid:pid
    ].
!

viewerTerminated
"/    Transcript showCR:'viewer has terminated'.
"/    'viewer has terminated' errorPrintCR.
    "/ Dialog information:'viewer has terminated'.
! !

!FileApplicationNoteBook::XViewApplication methodsFor:'initialization & release'!

postBuildXView:aWidget

    self xView:aWidget scrolledView.
    self xView wantsFocusWithPointerEnter.
    aWidget autoHideScrollBars:true.
!

postOpenWith:aBuilder 
    "only invoked if the application not started from a master"

    |currentDir contents suffix fileName|

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
        currentDir := Filename homeDirectory.
        contents := currentDir directoryContents.
        fileName := contents 
                    detect:[:file | 
                        suffix := file asFilename suffix asLowercase.
                        suffix = 'pdf'
                    ]
                    ifNone:[nil].
        fileName isNil ifTrue:[
            Dialog warn:'cant find a PDF File in ' , currentDir asString.
            ^ self
        ].
        self item:(DirectoryContentsBrowser itemClass fileName:(currentDir construct:fileName)).
    ].
    self changeInformation.
    self setupXView.
    super postOpenWith:aBuilder
!

release
"/Transcript showCR:'release'.
    self stopViewer.
    self stopVNCServer.
    super release
! !

!FileApplicationNoteBook class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

