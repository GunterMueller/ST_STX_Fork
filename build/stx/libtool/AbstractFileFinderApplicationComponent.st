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

AbstractFileApplicationNoteBookComponent subclass:#AbstractFileFinderApplicationComponent
	instanceVariableNames:'findFileView searchResultTable resultList enableStop enableSearch
		stopSignal accessLock searchTask expanded searchRecursively
		selectionHolder hasListEntries targetApplication matchedFilesList
		shownListHolder autoSelectInBrowserHolder filesSearchedCount'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!AbstractFileFinderApplicationComponent class methodsFor:'documentation'!

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
    abstract superclass of file-search appliations which are embedded in the file browserV2
"
! !

!AbstractFileFinderApplicationComponent class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == AbstractFileFinderApplicationComponent.
! !

!AbstractFileFinderApplicationComponent methodsFor:'accessing'!

accessLock
    ^ accessLock
!

stopSignal

    stopSignal isNil ifTrue:[
        stopSignal := Signal new.
    ].
    ^ stopSignal
!

targetApplication:anApplication
    targetApplication := anApplication.

    "Modified (format): / 11-01-2012 / 22:41:01 / cg"
! !

!AbstractFileFinderApplicationComponent methodsFor:'actions'!

changeInformationTo:aString

    self changeInformationTo:aString toTab:false
!

changeInformationTo:aString toTab:aBoolean
    masterApplication isNil ifTrue:[
        findFileView label:aString
    ] ifFalse:[
        aBoolean ifTrue:[
            masterApplication tabStringChangeTo:aString for:self
        ] ifFalse:[
            masterApplication notify:aString.
        ].
    ].

    "Modified: / 03-08-2011 / 17:56:21 / cg"
!

clearShownList
    self shownList removeAll.
!

copySelectedFileNamesToClipboard
    |sel list stream|

    sel := self selectionHolder value.
    list := self shownList.
    (sel notEmptyOrNil) ifTrue:[
        stream := CharacterWriteStream new.
        sel do:[: key |
            stream nextPutAll:(list at:key).
            stream cr.
        ].
        self window setClipboardText:stream contents.
    ].
!

openInNewBrowser
    |sel|

    sel := self selectionHolder value.
    (sel notEmptyOrNil) ifTrue:[
        FileBrowserV2 openOn:(self shownList at:sel first) asFilename
    ].
!

selectInBrowser
    |sel entry application|

    sel := self selectionHolder value.
    (sel notEmptyOrNil) ifTrue:[
        entry := self shownList at:sel first.
        entry asFilename exists ifFalse:[ ^ self].
        application := targetApplication ? self masterApplication.
        application notNil ifTrue:[
            application gotoFile:(entry asFilename).
        ].
    ].
!

startSearchTask:aBlock name:taskName
    |thisSearchTask|

    searchTask := thisSearchTask :=
        [
            |message time nFound|

            [    
                (self stopSignal) catch:[
                    self enableStop value:true.
                    self resultList removeAll.
                    self matchedFilesList removeAll.
                    self notify:'Searching...'.
                    filesSearchedCount := 0.

                    "/ self changeInformationTo:'Find File ' , '- searching ' toTab:true.
                    time := Time millisecondsToRun:[
                        aBlock value.
                    ].
                    time > 100 ifTrue:[
                        time := ((time / 1000) asFixedPoint:2) printString , ' s'
                    ] ifFalse:[
                        time := time printString , ' ms'
                    ].
                    nFound := resultList size.
                    message := resources 
                                    string:((nFound == filesSearchedCount) 
                                            ifTrue:['Found %1 file%2 in %3.'] 
                                            ifFalse:['Found %1 file%2 in %3 (%4 files visited).']) 
                                    with:nFound 
                                    with:(nFound == 1 ifTrue:'' ifFalse:'s') 
                                    with:time
                                    with:filesSearchedCount.
                    self enableStop value:false.
                    self enableSearch value:true.
                    self changeInformationTo:'Find File ' , '- done.' toTab:true.
                ].
            ] ensure:[
                thisSearchTask == searchTask ifTrue:[
                    searchTask := nil.
                    self enableStop value:false.
                    self notify:message.
                ].
            ]
        ] newProcess.

    searchTask priorityRange:(Processor userBackgroundPriority to:Processor userSchedulingPriority).
    searchTask name:taskName.
    searchTask resume.
    ^ searchTask

    "Created: / 12-01-2012 / 01:52:17 / cg"
!

stop
    searchTask notNil ifTrue:[
        accessLock critical:[
            searchTask interruptWith:[stopSignal raiseRequest].
        ]
    ].
    self enableStop value:false.
    self enableSearch value:true.
    self changeInformationTo:'Find File ' , '- search stopped.' toTab:true.

    "Modified: / 11-01-2012 / 22:42:07 / cg"
!

stopSearchTask
    |task|

    (task := searchTask) notNil ifTrue:[
        searchTask := nil.

        Error handle:[:ex|
            Dialog warn:ex description.
        ]do:[
            task isDead ifFalse:[
                task terminateWithAllSubprocessesInGroup.
                task waitUntilTerminated.
            ]
        ]
    ].
! !

!AbstractFileFinderApplicationComponent methodsFor:'aspects'!

autoSelectInBrowser
    ^ self autoSelectInBrowserHolder value.
!

autoSelectInBrowserHolder
    autoSelectInBrowserHolder isNil ifTrue:[
        autoSelectInBrowserHolder := false asValue.
    ].
    ^ autoSelectInBrowserHolder.
!

enableSearch

    enableSearch isNil ifTrue:[
        enableSearch := true asValue.
    ].
    ^ enableSearch.
!

enableStop

    enableStop isNil ifTrue:[
        enableStop := true asValue.
    ].
    ^ enableStop.
!

hasListEntries

    hasListEntries isNil ifTrue:[
        hasListEntries := false asValue.
    ].
    ^ hasListEntries.
!

matchedFilesList

    matchedFilesList isNil ifTrue:[
        matchedFilesList := List new.
        matchedFilesList addDependent:self.
    ].
    ^ matchedFilesList.
!

resultList
    resultList isNil ifTrue:[
        resultList := List new.
        resultList addDependent:self.
    ].
    ^ resultList.
!

searchRecursively

    searchRecursively isNil ifTrue:[
        searchRecursively := true asValue.
    ].
    ^ searchRecursively.
!

searchResultTable

    searchResultTable isNil ifTrue:[
        searchResultTable := self class searchResultTable asValue.
    ].
    ^ searchResultTable.
!

selectionHolder

    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
        selectionHolder addDependent:self.
    ].
    ^ selectionHolder
!

shownList
    ^ self shownListHolder valueHolder.
!

shownListHolder
    shownListHolder isNil ifTrue:[
        shownListHolder := IndirectValue for:(self resultList).
        shownListHolder addDependent:self.
    ].
    ^ shownListHolder.
! !

!AbstractFileFinderApplicationComponent methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == self shownListHolder ifTrue:[
        self hasListEntries value:(changedObject valueHolder notEmpty).
        ^ self
    ].
    changedObject == self selectionHolder ifTrue:[
        self autoSelectInBrowser ifTrue:[
            self selectInBrowser.
        ].
        ^ self
    ].
    super update:something with:aParameter from:changedObject
! !

!AbstractFileFinderApplicationComponent methodsFor:'drag & drop'!

getDisplayObjects:anArgument
    "retrieve the objects displayed during a drag"

    | sel string size fnName stream|

    sel := self selectionHolder value.
    size := sel size.
    size == 0  ifTrue:[^ ''].

    stream := CharacterWriteStream with:((resultList at:sel first) asFilename baseName asString).
    size == 1 ifTrue:[
        fnName := 'ui_menuitem.xpm'.
    ] ifFalse:[
        fnName := 'ui_submenu_open.xpm'.
        stream nextPutAll:' ... '.
        stream nextPutAll:((resultList at:sel last) asFilename baseName asString).
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
    ^ sel 
        collect:[:idx|
            |el|

            el := resultList at:idx.
            DropObject newFile:(el asFilename) 
        ].
! !

!AbstractFileFinderApplicationComponent methodsFor:'event handling'!

fileDoubleClick:entries
    |file fn app openedAppl contentsPattern|

    file := self shownList at:entries first.
    fn := file asFilename.
    fn exists ifFalse:[
        Dialog warn:('File %1 does not (no longer ?) exist.' bindWith:file allBold).
        ^ self
    ].

    app := targetApplication ? self masterApplication.
    file asFilename isDirectory ifTrue:[
        app gotoFile:(file asFilename).
        ^ self.
    ].
    app notNil ifTrue:[
        openedAppl := app openApplForFile:file.
        (openedAppl notNil and:[openedAppl isTextEditor]) ifTrue:[
            openedAppl window assignKeyboardFocusToFirstKeyboardConsumer.    "/ should this be done in openApplForFile?
            contentsPattern := self contentsPatternHolder value.
            (contentsPattern notNil and:[ contentsPattern notEmpty and:[contentsPattern ~= '*']]) ifTrue:[
                openedAppl searchForPattern:contentsPattern ignoreCase:(self ignoreCaseInContents value).
            ]        
        ].
    ] ifFalse:[
        self openInNewBrowser.
    ]
!

fileSelected:entries
    |file fn|

    entries isEmptyOrNil ifTrue:[^ self].

    file := self shownList at:entries first.
    file isText ifTrue:[^ self].

    fn := file asFilename.
    fn exists ifFalse:[
        self notify:('%1 does not (no longer ?) exist or is not accessible.' bindWith:file allBold).
        ^ self
    ].
    fn isDirectory ifTrue:[
        self notify:nil.
        ^ self.
    ].

    self notify:('%1: %2.' bindWith:fn baseName allBold with:(UnitConverter fileSizeStringFor:fn fileSize)).

    "Created: / 04-07-2006 / 11:35:38 / cg"
!

processEvent:anEvent
    "filter keyboard events.
     Return true, if I have eaten the event"

    <resource: #keyboard (#Return )>

    |focusView key rawKey|

    anEvent isKeyPressEvent ifTrue:[
        focusView := anEvent targetView.
        key := anEvent key.
        rawKey := anEvent rawKey.

        (focusView isSameOrComponentOf:self window) ifTrue:[
            (key == #Return) ifTrue:[
                (focusView name ~= 'selectionInListView') ifTrue:[
                    self doSearch.
                ] ifFalse:[
                    self hasOneFileSelected ifTrue:[
                        self fileDoubleClick:(self selectionHolder value)
"/                        self isEmbeddedApplication ifTrue:[
"/                            self selectInBrowser.
"/                        ] ifFalse:[
"/                            self openInNewBrowser.
"/                        ]
                    ]
                ].
                ^ true
            ].
        ]
    ].
    ^ false
! !

!AbstractFileFinderApplicationComponent methodsFor:'initialization'!

initialize
    super initialize.
    accessLock := Semaphore forMutualExclusion name:'accessLock'.

    self enableStop value:false.
    self enableSearch value:true.

    "Modified: / 12-01-2012 / 01:39:27 / cg"
! !

!AbstractFileFinderApplicationComponent methodsFor:'queries'!

hasOneFileSelected
    ^ self selectionHolder value size == 1
!

hasSelectionInResultList
    ^ self selectionHolder value notEmptyOrNil
!

hasTwoFilesSelected
    ^ self selectionHolder value size == 2
! !

!AbstractFileFinderApplicationComponent methodsFor:'tasks'!

stopSearchTaskOrAbort
    searchTask isNil ifTrue:[ ^ self ].

    (Dialog 
            confirm:(resources stringWithCRs:'There is already another find-file task running !!')
            yesLabel:(resources string:'Stop other Task and Proceed')
            noLabel:(resources string:'Cancel'))
        ifFalse:[AbortSignal raise].
    self stop.

    "Created: / 12-01-2012 / 01:48:42 / cg"
! !

!AbstractFileFinderApplicationComponent class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

