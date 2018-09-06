"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

ChangesBrowser subclass:#ChangeSetBrowser
	instanceVariableNames:'changeSet originalChangeSet'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers'
!

!ChangeSetBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    like a changesBrowser, but manipulates the per-project change-lists.

    This is operating on changes as a list of Change-instances 
    as opposed to the ChangesBrowser which is doing it completely non-object oriented,
    as a list of text-chunks.

    ChangeSetBrowser is going to completely replace the ChangesBrowser class in the near
    future.
"
! !

!ChangeSetBrowser class methodsFor:'instance creation'!

open
    "open a changes browser on the current change set"

    ^ self openOn:(ChangeSet current)

    "
     ChangeSetBrowser open
    "

    "Modified: / 17-02-2011 / 10:29:26 / cg"
!

openOn:aChangeSet
    "open a changes browser on a given change set"

    ^ ((self new label:'ChangeSet Browser') changeSet:aChangeSet) open

    "Modified: / 17-02-2011 / 10:29:35 / cg"
!

openOnFile:aFileName
    "open a changes browser on a file"

    |changeSet|

    changeSet := ChangeSet fromFile:aFileName.
    ^ self openOn:changeSet

    "
     self openOnFile:'st.chg'
     self openOnFile:'c:\Users\cg\work\stx\goodies\soap\spray5.2\Steve Waring\Spray WebServices\Spray\Auth\SWT Spray Auth Tests.pac'
     ChangeSet fromFile:'c:\Users\cg\work\stx\goodies\soap\spray5.2\Steve Waring\Spray WebServices\Spray\Auth\SWT Spray Auth Tests.pac'
    "

    "Modified: / 17-02-2011 / 10:29:50 / cg"
! !

!ChangeSetBrowser class methodsFor:'defaults'!

defaultLabel
    ^ self classResources string:'ChangeSet Browser'

    "Created: / 6.2.1998 / 13:25:47 / cg"
! !

!ChangeSetBrowser class methodsFor:'menu specs'!

menuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ChangeSetBrowser andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(ChangeSetBrowser menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Compress'
                  itemValue: doCompress
                  translateLabel: true
                  isVisible: notEditingClassSourceAndNotReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Compress for Class'
                  itemValue: doCompressClass
                  translateLabel: true
                  isVisible: notEditingClassSourceAndNotReadOnly
                )
               (MenuItem
                  label: 'Compare and Compress'
                  itemValue: doCompareAndCompress
                  translateLabel: true
                  isVisible: notEditingClassSourceAndNotReadOnly
                )
               (MenuItem
                  label: '-'
                  isVisible: notEditingClassSourceAndNotReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Fileout && Delete all Changes for Class'
                  itemValue: doFileoutAndDeleteClassAll
                  translateLabel: true
                  isVisible: notEditingClassSourceAndNotReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'CheckIn && Delete all Changes for Class'
                  itemValue: doCheckinAndDeleteClassAll
                  translateLabel: true
                  isVisible: notEditingClassSourceAndNotReadOnly
                )
               (MenuItem
                  label: '-'
                  isVisible: notEditingClassSourceAndNotReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Save In...'
                  itemValue: doSave
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Save to End In...'
                  itemValue: doSaveRest
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Save for Class to End In...'
                  itemValue: doSaveClassRest
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Save all for Class In...'
                  itemValue: doSaveClassAll
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Saveback ChangeSet'
                  itemValue: doSaveBack
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  label: '-'
                  isVisible: notReadOnly
                )
               (MenuItem
                  label: 'Update'
                  itemValue: doUpdate
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  label: '-'
                  isVisible: notReadOnly
                )
               (MenuItem
                  label: 'Exit'
                  itemValue: menuExit
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Change'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Undo (undelete Method)'
                  itemValue: doUndoRemoveMethod
                  translateLabel: true
                  isVisible: hasUndoableRemoveMethodChangeSelected
                )
               (MenuItem
                  label: 'Undo (previous Version)'
                  itemValue: doUndoMethodChange
                  translateLabel: true
                  isVisible: hasUndoableMethodChangeSelected
                )
               (MenuItem
                  enabled: false
                  label: 'Undo'
                  itemValue: doUndoMethodChange
                  translateLabel: true
                  isVisible: hasNotUndoableChangeSelected
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Apply'
                  itemValue: doApply
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Apply to End'
                  itemValue: doApplyRest
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Apply for Class to End'
                  itemValue: doApplyClassRest
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasNoSelection
                  label: 'Apply All'
                  itemValue: doApplyAll
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Delete'
                  itemValue: doDelete
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Delete to End'
                  itemValue: doDeleteRest
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Delete for Class to End'
                  itemValue: doDeleteClassRest
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Delete for Class from Begin'
                  itemValue: doDeleteClassFromBeginning
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Delete all for Class'
                  itemValue: doDeleteClassAll
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Delete all for Class && its Private Classes'
                  itemValue: doDeleteClassAndPrivateClassesAll
                  translateLabel: true
                  isVisible: notReadOnly
                )
               (MenuItem
                  label: '-'
                  isVisible: notReadOnly
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Compare with Current'
                  itemValue: doCompare
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Browse'
                  itemValue: doBrowse
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Make Change a Patch'
                  itemValue: doMakePatch
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Search'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Class...'
                  itemValue: findClass
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Previous for Class'
                  itemValue: findPreviousForClass
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Next for Class'
                  itemValue: findNextForClass
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Selector...'
                  itemValue: findSelector
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Previous for Selector'
                  itemValue: findPreviousForSelector
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Next for Selector'
                  itemValue: findNextForSelector
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'String...'
                  itemValue: findString
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Previous with String'
                  itemValue: findPreviousForString
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Next with String'
                  itemValue: findNextForString
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Previous Snapshot'
                  itemValue: findPreviousSnapshot
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'Next Snapshot'
                  itemValue: findNextSnapshot
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Next Difference'
                  itemValue: findNextDifference
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Browse'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasSingleSelection
                  label: 'Class'
                  itemValue: doBrowse
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Senders...'
                  itemValue: doBrowseSenders
                  translateLabel: true
                )
               (MenuItem
                  label: 'Implementors...'
                  itemValue: doBrowseImplementors
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Settings'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Auto Compare'
                  translateLabel: true
                  indication: autoCompare
                )
               (MenuItem
                  label: 'Auto Update'
                  translateLabel: true
                  isVisible: notReadOnly
                  indication: autoUpdate
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Add Applies to ChangeSet'
                  translateLabel: true
                  indication: updateChangeSet
                )
               (MenuItem
                  label: 'Apply in Original NameSpace'
                  translateLabel: true
                  indication: applyInOriginalNameSpace
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Apply into Package...'
                  itemValue: setEnforcedPackage
                  translateLabel: true
                )
               (MenuItem
                  label: 'Apply in NameSpace...'
                  itemValue: setEnforcedNameSpace
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            translateLabel: true
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'ChangesBrowser Documentation'
                  itemValue: openHTMLDocument:
                  translateLabel: true
                  argument: 'tools/cbrowser/TOP.html'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About ChangesBrowser...'
                  itemValue: openAboutThisApplication
                  translateLabel: true
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
! !

!ChangeSetBrowser methodsFor:'aspects'!

canDeleteChanges
    "makes the delete buttons in the toolbar visible"

    ^ false.
! !

!ChangeSetBrowser methodsFor:'initialization & release'!

askIfChangesAreToBeWrittenBack
    |action|

    anyChanges ifFalse:[^ self].

    action := OptionBox
                      request:(resources string:'The modified changeSet has not been saved.\\Update the changeSet before closing ?') withCRs
                      label:'ChangesBrowser'
                      image:(WarningBox iconBitmap)
                      buttonLabels:(resources array:#('Cancel' 'Don''t Update' 'Update'))
                      values:#(#abort #ignore #save)
                      default:#save
                      onCancel:#abort.

    action == #abort ifTrue:[^ self].
    action  == #save ifTrue:[
        self saveBackChanges
    ].
!

changeListMenu
    <resource: #programMenu >

    |items m|

    items := #(
                             ('Apply'                              doApply)
                             ('Apply to End'                       doApplyRest)
                             ('Apply all changes'                  doApplyAll)
                             ('-'                                  )
                             ('Delete'                             doDelete)
                             ('Delete to End'                      doDeleteRest)
                             ('Delete for Class to End'            doDeleteClassRest)
                             ('Delete all for Class'               doDeleteClassAll)
                             ('-'                                  )
"/                             ('Compress'                          doCompress)
                             ('Compare with Current'               doCompare)
                             ('-'                                  )
                             ('Make Change a Patch'                doMakePatch)
                             ('-'                                  )
                             ('Saveback ChangeSet'                 doSaveBack)
                             ('-'                                  )
                             ('Update'                             doUpdate)
                ).

    self device ctrlDown ifTrue:[
        items := #(
                                 ('Inspect Change'                 doInspectChange)
                  ).
    ].

    m := PopUpMenu 
         itemList:items
         resources:resources.

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

    "Created: 3.12.1995 / 18:06:35 / cg"
    "Modified: 3.12.1995 / 18:13:06 / cg"
!

showingDiffsDefault
    ^ "false" super showingDiffsDefault
! !

!ChangeSetBrowser methodsFor:'menu aspects'!

hasNotUndoableChangeSelected
    ^ (self hasUndoableMethodChangeSelected
      or:[self hasUndoableRemoveMethodChangeSelected]) not
!

hasUndoableMethodChangeSelected
    |nr chg|

    self hasSingleSelection ifTrue:[
        nr := self theSingleSelection.
        nr notNil ifTrue:[
            chg := changeSet at:nr.
            chg isMethodChange ifTrue:[
                chg isMethodRemoveChange ifFalse:[
                    chg previousVersion notNil ifTrue:[
                        ^ true
                    ]
                ]
            ]
        ]
    ].
    ^ false
!

hasUndoableRemoveMethodChangeSelected
    |nr chg|

    self hasSingleSelection ifTrue:[
        nr := self theSingleSelection.
        nr notNil ifTrue:[
            chg := changeSet at:nr.
            chg isMethodRemoveChange ifTrue:[
                chg previousVersion notNil ifTrue:[
                    ^ true
                ]
            ]
        ]
    ].
    ^ false
! !

!ChangeSetBrowser methodsFor:'private'!

applyChange:changeNr
    "fileIn a change"

    |nm applyAction aborted|

    nm := self classNameOfChange:changeNr.
    nm notNil ifTrue:[
        |cls|

        cls := Smalltalk at:(nm asSymbol) ifAbsent:[].
        cls notNil ifTrue:[
            cls isLoaded ifFalse:[
                cls autoload
            ]
        ]
    ].

    changeNrProcessed := changeNr.
    aborted := false.

    applyAction := [
"/        AbortOperationRequest handle:[:ex |
"/            ^ false.
"/        ] do:[
            ParseError handle:[:ex |       
                ex signal == UndefinedSuperclassError ifTrue:[
                    codeView error:(ex errorString) position:1 to:nil from:nil 
                ] ifFalse:[
                    codeView error:(ex description) position:(ex startPosition) to:(ex endPosition) from:(ex parser). 
                    ex mayProceed ifTrue:[ex proceed].
                ]
            ] do:[
                |nameSpace change package|

                change := changeSet at:changeNr.
                nameSpace := self nameSpaceForApply.
                change isDoIt ifTrue:[
                    package := enforcedPackage ? Class packageQuerySignal query.             
                ] ifFalse:[  
                    package := enforcedPackage ? change package ? Class packageQuerySignal query.             
                ].

                Class packageQuerySignal answer:package
                do:[    
                    "/ Class nameSpaceQuerySignal answer:nameSpace
                    "/ do:[
                        self applyPossiblyModifiedChange:change.
                    "/ ]
                ]
"/            ]
        ].
        changeNrProcessed := nil.
    ].

    "/
    "/ if I am showing the changes file, don't update it
    "/
    changeFileName = ObjectMemory nameForChanges ifTrue:[
        Class withoutUpdatingChangesDo:applyAction
    ] ifFalse:[
        applyAction value
    ].
    ^ aborted not

    "Created: / 07-02-1998 / 19:32:35 / cg"
    "Modified: / 29-01-2011 / 11:46:44 / cg"
!

applyPossiblyModifiedChange:aChange
    |ns superClass superClassName savedClassName|

    aChange isClassDefinitionChange ifTrue:[
        superClassName := aChange superClassName.
        superClassName notNil ifTrue:[
            superClassName := superClassName asSymbol.
            applyInOriginalNameSpace value ifFalse:[
                ns := Class nameSpaceQuerySignal query.
                superClass := ns at:superClassName.
                (superClass isNil and:[ superClass ~~ Smalltalk ]) ifTrue:[
                    superClass := Smalltalk at:superClassName.
                ].
            ] ifTrue:[
                superClass := Smalltalk at:superClassName.
            ].

            superClass isNil ifTrue:[
                |guess idx baseName nsName dontShowAgain|

                idx := superClassName lastIndexOf:$:.
                baseName := superClassName copyFrom:idx+1.
                nsName := superClassName copyTo:idx-2.
                guess := Smalltalk classNamed:baseName.
                guess isNil ifTrue:[
                    enforcedNameSpace notNil ifTrue:[
                        guess := enforcedNameSpace classNamed:baseName
                    ].
                    guess isNil ifTrue:[
                        guess := SystemBrowser classesWithNameSimilarTo:baseName.
                        guess notEmptyOrNil ifTrue:[ guess := guess first ] ifFalse:[ guess := nil ].
                    ].
                ].

                superClass := Dialog 
                            requestClass:'No superclass: ', superClassName allBold , ' enter a replacement:' 
                            initialAnswer:(guess ? superClassName).

                superClass isNil ifTrue:[AbortOperationRequest raise. ^ self ].
            ].
            
            superClass notNil ifTrue:[
                aChange superClassName:superClass name.
            ].
        ].
    ].
    (enforcedNameSpace notNil and:[(savedClassName := aChange className) notNil]) ifTrue:[
        [

            Error ignoreIn:[ aChange class:(enforcedNameSpace classNamed:savedClassName) ].
            aChange className:(enforcedNameSpace name,'::',savedClassName).
            "/ Class nameSpaceQuerySignal answer:enforcedNameSpace do:[
                aChange apply.
            "/ ].
        ] ensure:[
            aChange className:savedClassName
        ].
    ] ifFalse:[
        aChange apply.
    ].

    "Modified: / 29-01-2011 / 12:30:35 / cg"
!

changeIsFollowupMethodChange:changeNr
    ^ false

    "Created: / 6.2.1998 / 13:04:59 / cg"
    "Modified: / 7.2.1998 / 19:28:52 / cg"
!

changeSet:aChangeSet
    changeFileName := nil.
    originalChangeSet := aChangeSet.
    changeSet := OrderedCollection new.
    originalChangeSet notNil ifTrue:[
        originalChangeSet do:[:aChange |
            changeSet add:aChange
        ].
    ].
!

checkIfFileHasChanged
    Processor removeTimedBlock:checkBlock.
    changeSet size ~= originalChangeSet size ifTrue:[
        self newLabel:'(outdated)'.
        autoUpdate value ifTrue:[
            self doUpdate
        ]
    ] ifFalse:[
        "/ self newLabel:''
    ].
    Processor addTimedBlock:checkBlock afterSeconds:5.

    "Created: 3.12.1995 / 13:52:30 / cg"
    "Modified: 3.12.1995 / 14:15:06 / cg"
!

fullClassNameOfChange:nr
    ^ (changeSet at:nr) fullClassName

    "Created: / 6.2.1998 / 13:02:25 / cg"
    "Modified: / 6.2.1998 / 13:07:02 / cg"
!

isChangeSetBrowser
    ^ true
!

numberOfChanges
    ^ changeSet size

    "Created: 3.12.1995 / 18:15:56 / cg"
!

queryCloseText
	^ 'Quit without updating changeSet ?'
!

readChangesFileInBackground:dummy
    "read the changeSet, create a list of header-lines"

    self withCursor:(Cursor read) do:[
        changeInfoList := OrderedCollection new.

        changeSet size == 0 ifTrue:[
            changeFileName notNil ifTrue:[
                changeSet := self class readXMLChangesFromFile:changeFileName inBackground:false.
            ].
            changeSet size == 0 ifTrue:[ ^ nil ].
        ].

"/        tabSpec := TabulatorSpecification new.
"/        tabSpec unit:#inch.
"/        tabSpec positions:#(-1      0        5      8.5 ).
"/        "                   +/-    cls>>sel  type   info"
"/        tabSpec align:    #(#left  #left     #left  #left).

        changeSet do:[:aChange | 
            |info changeSource entry time 
             changeDelta changeClass changeClassName changeSelector|

            changeSource := aChange source "printString".
            changeClassName := aChange className.

            aChange isMethodCodeChange ifTrue:[
                changeClass := aChange changeClass.
                changeSelector := aChange selector.
                changeDelta := ChangeDeltaInformation 
                                changeDeltaFor:changeSource 
                                changeClass:changeClass 
                                selector:changeSelector.
            ] ifFalse:[
                changeDelta := ' '.
            ].

            "/ changeHeaderLines add:(aChange printString)
            entry := MultiColListEntry new.
            entry tabulatorSpecification:tabSpec.
            entry colAt:1 put:changeDelta.
            entry colAt:2 put:aChange printString.
            entry colAt:3 put:''. "/ changeType.
        
            (aChange respondsTo:#timeOfChangeIfKnown) ifTrue:[
                (time := aChange timeOfChangeIfKnown) notNil ifTrue:[
                    entry colAt:4 put:(self timeStampPrintStringOf:time).
                ]
            ].    
            info := ChangesBrowser::ChangeInfo new 
                        position:nil
                        chunk:changeSource
                        className:changeClassName
                        selector:changeSelector
                        headerLine:entry
                        timestamp:time
                        isFollowupChange:false.
            changeInfoList add:info.

        ].
        anyChanges := false
    ].

    "Created: 3.12.1995 / 18:02:39 / cg"
!

realClassNameOfChange:nr
    ^ (changeSet at:nr) fullClassName "/ className.

    "Created: / 5.11.2001 / 18:10:38 / cg"
!

saveBackChanges
    "save back the change set"

    [originalChangeSet isEmpty] whileFalse:[
	originalChangeSet removeLast
    ].
    changeSet do:[:aChange |
	originalChangeSet add:aChange
    ]
!

selectorOfMethodChange:changeNr
    ^ (changeSet at:changeNr) selector

    "Created: / 6.2.1998 / 13:28:20 / cg"
    "Modified: / 6.2.1998 / 13:29:59 / cg"
!

silentDeleteChange:changeNr
    "delete a change do not update changeListView"

    changeSet removeIndex:changeNr.
    super silentDeleteChange:changeNr.

    "Created: / 3.12.1995 / 18:14:17 / cg"
    "Modified: / 7.2.1998 / 19:57:57 / cg"
!

silentDeleteInternalChange:changeNr
    "delete a change do not update changeListView"

    changeSet removeIndex:changeNr.
    super silentDeleteInternalChange:changeNr.

    "Modified: / 7.2.1998 / 19:44:45 / cg"
    "Created: / 7.2.1998 / 19:58:02 / cg"
!

sourceOfChange:changeNr
    "answer a changes source"

    |change|

    change := changeSet at:changeNr.
    change isNil ifTrue:[^nil].
    ^ change source

    "Modified: / 7.2.1998 / 19:52:44 / cg"
!

streamForChange:changeNr
    "answer a stream for change"

    |change str source|

    change := changeSet at:changeNr.
    change isNil ifTrue:[^nil].
    change isMethodDefinitionChange ifTrue:[
        str := WriteStream on:''.
        str nextPutChunkSeparator.
        str nextPutAll:(change className , ' methodsFor:''' , (change methodCategory ? '*** not categorized ***') , '''').
        str nextPutChunkSeparator.
        str cr.
        str nextPutAllAsChunk:change source.
        str nextPutChunkSeparator.
        str space.
        str nextPutChunkSeparator.
        str cr.
        source := str contents
    ] ifFalse:[
        source := change source
    ].
    ^ ReadStream on:source

    "Modified: / 7.2.1998 / 19:52:44 / cg"
! !

!ChangeSetBrowser methodsFor:'user actions'!

compareChange:changeNr showResult:doShowResult
    |change isSame outcome beep oldSource newSource showDiff d|

    change := changeSet at:changeNr.
    change isMethodCodeChange ifTrue:[
        newSource := change source.

        isSame := self 
                    compareMethodSource:newSource 
                    withVersionInClass:change changeClass 
                    into:[:outcomeResult :beepResult :oldSourceResult |
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
        ].
    ] ifFalse:[
        super compareChange:changeNr showResult:doShowResult
    ].
!

doInspectChange
    self withSelectedChangesDo:[:changeNr |
        (changeSet at:changeNr) inspect
    ].
!

doSaveBack
    anyChanges ifTrue:[
	self saveBackChanges.
	self doUpdate
    ]
!

doUpdate
    changeSet := OrderedCollection new.
    originalChangeSet notNil ifTrue:[
        originalChangeSet do:[:aChange |
            changeSet add:aChange
        ].
    ].
    super doUpdate

    "Created: 3.12.1995 / 13:54:14 / cg"
!

updateDiffViewFor:changeNr
    |change class selector oldMethod newSource oldSource|

    change := changeSet at:changeNr.
    (change isMethodChange and:[change isMethodCodeChange]) ifTrue:[
        newSource := change source.
        enforcedNameSpace notNil ifTrue:[
            class := enforcedNameSpace classNamed:change className.
        ] ifFalse:[
            class := change changeClass.
        ].
        class notNil ifTrue:[
            selector := change changeSelector.
            selector notNil ifTrue:[
                oldMethod := class compiledMethodAt:selector.
                oldMethod notNil ifTrue:[
                    oldSource := oldMethod source.
                    diffView text1:(oldSource ? '') text2:(newSource ? '').
                    ^ self.
                ]
            ].
        ]
    ].

    super updateDiffViewFor:changeNr.
! !

!ChangeSetBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

