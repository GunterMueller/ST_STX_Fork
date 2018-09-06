"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

SourceCodeManagerUtilities subclass:#PerforceSourceCodeManagerUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

SimpleDialog subclass:#P4CheckinInfoDialog
	instanceVariableNames:'descriptionHolder logMessageHolder isStableHolder tagHolder
		quickCheckInHolder quickCheckInVisibleHolder allowEmptyLogMessage
		warningMessageHolder logHistory logHistoryHeadLineSelectionHolder
		submitHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PerforceSourceCodeManagerUtilities
!

SimpleDialog subclass:#SubmitInfoDialog
	instanceVariableNames:'descriptionHolder logMessageHolder isStableHolder tagHolder
		quickCheckInHolder quickCheckInVisibleHolder allowEmptyLogMessage
		warningMessageHolder filesHolder tagItInHolder'
	classVariableNames:'LastSourceLogMessage'
	poolDictionaries:''
	privateIn:PerforceSourceCodeManagerUtilities
!

Object subclass:#WorkSpace
	instanceVariableNames:'client host owner root views perforceSettings temporaryWorkSpace
		tempDirectory'
	classVariableNames:'PerforceCommandSemaphore'
	poolDictionaries:''
	privateIn:PerforceSourceCodeManagerUtilities
!

Object subclass:#View
	instanceVariableNames:'depot local workspace type'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PerforceSourceCodeManagerUtilities::WorkSpace
!

!PerforceSourceCodeManagerUtilities class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PerforceSourceCodeManagerUtilities class methodsFor:'class access'!

checkInInfoDialogClass

    ^P4CheckinInfoDialog
!

submitInfoDialogClass

    ^ SubmitInfoDialog

    "Created: / 01-06-2012 / 11:09:15 / cg"
!

workSpaceClass
    ^ WorkSpace

    "Created: / 01-06-2012 / 11:13:49 / cg"
! !

!PerforceSourceCodeManagerUtilities methodsFor:'utilities-cvs'!

askForContainer:boxText title:title note:notice initialModule:initialModule initialPackage:initialPackage initialFileName:initialFileName forNewContainer:forNewContainer
    "open a dialog asking for a source container;
     return a dictionary containing module, package and filename,
     or nil if canceled."

    |box y component answer
     moduleHolder packageHolder fileNameHolder
     module package fileName
     knownContainers knownPackages packageUpdater
     packageBoxComponent fileNameBoxComponent fileNameUpdater|

    knownContainers := Set new.
    Smalltalk allClassesDo:[:cls | |pckg|
        pckg := cls package.
        pckg size > 0 ifTrue:[
            knownContainers add:(pckg upTo:$:)
        ]
    ].
    knownContainers := knownContainers asOrderedCollection reject:[:module | module isBlank].
    knownContainers sort.

    packageUpdater := [
        |theModulePrefix|

        theModulePrefix := moduleHolder value , ':'.

        Cursor wait showWhile:[
            knownPackages := Set new.
            Smalltalk allClassesDo:[:cls | |pckg idx|
                pckg := cls package.
                pckg size > 0 ifTrue:[
                    (pckg startsWith:theModulePrefix) ifTrue:[
                        idx := pckg indexOf:$:.
                        knownPackages add:(pckg copyFrom:idx + 1)
                    ]
                ]
            ].
            knownPackages := knownPackages asOrderedCollection.
            knownPackages := knownPackages select:[:package | package isBlank not].
            knownPackages sort.
            packageBoxComponent list:knownPackages.
        ].
    ].

    fileNameUpdater := [
        |module package files|

        Cursor read showWhile:[
            module := moduleHolder value ? (PackageId noProjectID).
            package := packageHolder value ? (PackageId noProjectID).

            files := PerforceSourceCodeManager getExistingContainersInModule:module directory:package.
            files := files asOrderedCollection.
            files := files select:[:eachFile | eachFile asFilename hasSuffix:'st'].
            files sort.
            fileNameBoxComponent list:files.
        ].
    ].

    moduleHolder := initialModule asValue.
    packageHolder := initialPackage asValue.
    fileNameHolder := initialFileName asValue.

    "/
    "/ open a dialog for this
    "/
    box := DialogBox new.
    box label:title.

    component := box addTextLabel:boxText withCRs.
    component adjust:#left; borderWidth:0.
    box addVerticalSpace.
    box addVerticalSpace.

    y := box yPosition.
    component := box addTextLabel:(resources string:'Module:').
    component width:0.4; adjust:#right.
    box yPosition:y.
    component := box addComboBoxOn:moduleHolder tabable:true.
    component list:knownContainers.

"/    component := box addInputFieldOn:moduleHolder tabable:true.
    component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.

    box addVerticalSpace.
    y := box yPosition.
    component := box addTextLabel:(resources string:'Package:').
    component width:0.4; adjust:#right.
    box yPosition:y.
    packageBoxComponent := component := box addComboBoxOn:packageHolder tabable:true.
"/    component := box addInputFieldOn:packageHolder tabable:true.
    component width:0.6; left:0.4; "immediateAccept:true; "acceptOnLeave:true; cursorMovementWhenUpdating:#beginOfLine.
    packageUpdater value.
    moduleHolder onChangeEvaluate:packageUpdater.

    box addVerticalSpace.
    y := box yPosition.
    component := box addTextLabel:(resources string:'Filename:').
    component width:0.4; adjust:#right.
    box yPosition:y.

    forNewContainer ifTrue:[
        component := box addInputFieldOn:fileNameHolder tabable:true.
        component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
    ] ifFalse:[
        fileNameBoxComponent := component := box addComboBoxOn:fileNameHolder tabable:true.
        component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        fileNameUpdater value.
        packageHolder onChangeEvaluate:fileNameUpdater.
    ].

    box addVerticalSpace.

    notice notNil ifTrue:[
        component := box addTextLabel:notice.
        component adjust:#left; borderWidth:0.
    ].

    box addVerticalSpace.
    box addAbortAndOkButtons.

    (YesToAllNotification notNil and:[YesToAllNotification isHandled]) ifTrue:[
        component := Button label:(resources string:'Yes to All').
        component action:[
                            YesToAllNotification queryWith:true.
                            box doAccept.
                            box okPressed.
                         ].
        box addButton:component.
    ].
    (AbortAllSignal isHandled) ifTrue:[
        component := Button label:(resources string:'Cancel All').
        component action:[
                            box hide.
                            AbortAllSignal raiseSignal.
                         ].
        box addButton:component before:nil.
    ].

    (YesToAllQuery notNil and:[YesToAllQuery isHandled]) ifTrue:[
        answer := YesToAllQuery query.
    ].

    answer isNil ifTrue:[
        box showAtPointer.
        answer := box accepted
    ].

    box destroy.
    answer ifFalse:[
        ^ nil
    ].

    module := moduleHolder value withoutSpaces.
    package := packageHolder value withoutSpaces.
    fileName := fileNameHolder value withoutSpaces.
    ^ Dictionary new
        at:#module put:module;
        at:#package put:package;
        at:#fileName put:fileName;
        yourself

    "
     self
        askForContainer:'enter container' title:'container' note:'some note'
        initialModule:'foo' initialPackage:'bar' initialFileName:'baz'
    "

    "Modified: / 29-08-2013 / 12:26:55 / cg"
!

checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClass usingManager:managerOrNil
    "check a class into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for log-message.
     If doCheckClass is true, the class is checked for send of halts etc."

    |logMessage checkinInfo mgr pri doSubmit|

    doSubmit := false.

    aClass isLoaded ifFalse:[
        self information:(resources string:'Cannot checkin unloaded classes (%1)' with:aClass name).
        ^ false.
    ].

    mgr := managerOrNil.
    mgr isNil ifTrue:[
        mgr := self sourceCodeManagerFor:aClass.
        mgr isNil ifTrue:[
            ^ false
        ]
    ].

    self ensureCorrectVersionMethodsInClass:aClass usingManager:mgr.
    mgr supportsCheckinLogMessages ifTrue:[
        (self
            getLogMessageForClassCheckinTakingDefaultsFromPreviousLogInfo:aLogInfoOrNil
            forClass:aClass
            valuesInto:[:logMessageRet :checkinInfoRet |
                logMessage := logMessageRet.
                checkinInfo := checkinInfoRet.
                checkinInfo notNil ifTrue:[
                    doSubmit := checkinInfo submitHolder value.
                ].
            ]
        ) ifFalse:[^ false].
    ].

    (self classIsNotYetInRepository:aClass withManager:mgr) ifTrue:[
        (self createSourceContainerForClass:aClass usingManager:mgr) ifFalse:[
"/            self warn:'did not create a container for ''' , aClass name , ''''.
            ^ false
        ].
        ^ true.
    ].

    self activityNotification:(resources string:'PerforceSourceCodeManager [info]: checking in %1' with:aClass name).
    pri := Processor activePriority.
    Processor activeProcess withPriority:pri-1 to:pri
    do:[
        |revision aborted|



        aborted := false.
        AbortOperationRequest handle:[:ex |
            aborted := true.
            ex return.
        ] do:[
            |checkinState cause|
            checkinState := false.
            cause := ''.
            [
                checkinState := mgr checkinClass:aClass logMessage:logMessage submit:doSubmit
            ] on:SourceCodeManagerError do:[:ex|
                cause := ex description.
                ex proceed.
            ].

            checkinState ifFalse:[
                Transcript showCR:'checkin of ''' , aClass name , ''' failed - ', cause.
                self warn:(resources stringWithCRs:'Checkin of "%1" failed\\' with:aClass name allBold),cause.
                ^ false.
            ].
            checkinInfo notNil ifTrue:[
                checkinInfo isStable ifTrue:[
                    "set stable tag for class that has been checked in"
                    self tagClass:aClass as:#stable.
                ].
                checkinInfo tagIt ifTrue:[
                    "set an additional tag for class that has been checked in"
                    self tagClass:aClass as:(checkinInfo tag).
                ].
            ].
        ].
        aborted ifTrue:[  |con|
            Transcript showCR:'Checkin of ''' , aClass name , ''' aborted'.

            AbortAllOperationWantedQuery query ifTrue:[
                (Dialog
                    confirm:(resources stringWithCRs:'Checkin of "%1" aborted.\\Cancel all ?' with:aClass name)
                    default:false)
                ifTrue:[
                    AbortAllOperationRequest raise.
                ]
            ].
            ^ false.
        ].
    ].
    ^ true

    "Created: / 21-12-2011 / 18:19:14 / cg"
!

defineSourceContainerForClass:aClass usingManager:mgr title:title text:boxText createDirectories:createDirs createContainer:createContainer
    "let user specify the source-repository values for aClass"

    |className
     "oldModule oldPackage" oldFileName
     module directory fileName nameSpace nameSpacePrefix
     info project nm creatingNew msg
     answer doCheckinWithoutAsking forceCheckIn rslt note
     requiredPackage projectDefinitionClass packageId|

    mgr isNil ifTrue:[^  false].

    aClass isLoaded ifFalse:[
        self warn:(resources string:'Please load the %1-class first' with:aClass name).
        ^ false.
    ].

    className := aClass name.

    aClass isProjectDefinition ifTrue:[
        "/ no way - their package is already known and fix.
        module := aClass module.
        directory := aClass moduleDirectory.
    ] ifFalse:[
        "/
        "/ defaults, if nothing at all is known
        "/
        projectDefinitionClass := aClass projectDefinitionClass.
        projectDefinitionClass notNil ifTrue:[
            packageId := PackageId from:projectDefinitionClass package.
            module := packageId module.
            directory := packageId directory.
        ] ifFalse:[
            (module := LastModule) isNil ifTrue:[
                module := (OperatingSystem getLoginName).
            ].
            (directory := LastPackage) isNil ifTrue:[
                directory := 'private'.
            ].
        ].
    ].

    "/
    "/ try to extract some useful defaults from the current project
    "/
    (Project notNil and:[(project := Project current) notNil]) ifTrue:[
        directory isNil ifTrue:[
            (nm := project repositoryDirectory) isNil ifTrue:[
                nm := project name
            ].
            directory := nm.
        ].
        module isNil ifTrue:[
            (nm := project repositoryModule) notNil ifTrue:[
                module := nm
            ]
        ].
    ].

    "/
    "/ ask the sourceCodeManager if it knows anything about that class
    "/ if so, take that as a default.
    "/
    info := mgr sourceInfoOfClass:aClass.
    info notNil ifTrue:[
        true "module ~= LastModule" ifTrue:[
            (info includesKey:#module) ifTrue:[
                module := (info at:#module).
            ].
        ].
"/        true "package ~= LastPackage" ifTrue:[
"/            (info includesKey:#directory) ifTrue:[
"/                package := (info at:#directory).
"/            ].
"/        ].
        fileName := mgr containerFromSourceInfo:info.
        (nameSpace := aClass nameSpace) ~~ Smalltalk ifTrue:[
            nameSpacePrefix := nameSpace name , '::'.
            (fileName startsWith:nameSpacePrefix) ifTrue:[
                fileName := fileName copyFrom:(nameSpacePrefix size + 1).
            ]
        ].
"/        (info includesKey:#fileName) ifTrue:[
"/            fileName := (info at:#fileName).
"/        ] ifFalse:[
"/            (info includesKey:#expectedFileName) ifTrue:[
"/                fileName := (info at:#expectedFileName).
"/            ] ifFalse:[
"/                (info includesKey:#classFileNameBase) ifTrue:[
"/                    fileName := (info at:#classFileNameBase) , '.st'.
"/                ]
"/            ]
"/        ]
    ].

    fileName isNil ifTrue:[
        fileName := (Smalltalk fileNameForClass:aClass) , '.st'.
    ].

    OperatingSystem isMSDOSlike ifTrue:[
        module replaceAll:$\ with:$/.
        directory replaceAll:$\ with:$/.
    ].

    "/
    "/ check for conflicts (i.e. if such a container already exists) ...
    "/
    doCheckinWithoutAsking := false.
"/false ifTrue:[
"/    (mgr checkForExistingContainer:fileName inModule:module directory:directory) ifTrue:[
"/        answer := Dialog confirmWithCancel:(resources
"/                            string:'About to change the source container.
"/
"/Notice: there is a container for %1 in:
"/
"/    %2 / %3 / %4
"/
"/Do you want to change it or check right into that container ?'
"/                            with:className
"/                            with:module
"/                            with:directory
"/                            with:fileName)
"/                labels:(resources array:#('Cancel' 'Check in' 'Change')).
"/        answer isNil ifTrue:[AbortSignal raise].
"/        answer ifTrue:[
"/            doCheckinWithoutAsking := false.
"/            oldModule := module.
"/            oldPackage := directory.
"/            oldFileName := fileName
"/        ] ifFalse:[
"/            doCheckinWithoutAsking := true.
"/            creatingNew := false.
"/        ].
"/    ].
"/].
    mgr isContainerBased ifTrue:[
        doCheckinWithoutAsking ifFalse:[
            "/
            "/ open a dialog for this
            "/
            (mgr checkForExistingContainer:fileName inModule:module directory:directory) ifFalse:[
                note := 'Notice: class seems to have no container yet.'.
                creatingNew := true.
            ] ifTrue:[
                creatingNew := false.
            ].

            rslt := self
                    askForContainer:boxText title:title note:note
                    initialModule:module initialPackage:directory initialFileName:fileName
                    forNewContainer:true.

            rslt isNil ifTrue:[
                ^ false
            ].

            module := rslt at:#module.
            directory := rslt at:#package.
            fileName := rslt at:#fileName.
        ].
        (fileName endsWith:',v') ifTrue:[
            fileName := fileName copyButLast:2
        ].
        (fileName endsWith:'.st') ifFalse:[
            fileName := fileName , '.st'
        ].

    ].

    "/ we require the packageID to be <module>:<container-dir>
    "/ check for this ...

    requiredPackage := ((module ? '') , ':' , (directory ? '')) asSymbol.
    requiredPackage ~= aClass package ifTrue:[
"/        doCheckinWithoutAsking ifFalse:[
"/            (self confirm:'Change the classes packageID to: ''', requiredPackage , ''' ?')
"/            ifFalse:[
"/                ^ false
"/            ]
"/        ].
        aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | mthd setPackage:requiredPackage].
        aClass package:requiredPackage.
    ].

    info := aClass revisionInfo.
    info notNil ifTrue:[
        (info repositoryPathName isNil) ifTrue:[
            info := nil
        ].
"/        (info includesKey:#repositoryPathName) ifFalse:[
"/            info := nil
"/        ]
    ].

    info isNil ifTrue:[
        true "doCheckinWithoutAsking" ifFalse:[
            answer := Dialog
                 confirmWithCancel:(resources string:'%1 does not have any (usable) revision info (#version method)\\Shall I create one ?' with:className) withCRs
                 labels:(resources array:#( 'Cancel' 'No' 'Yes')).
            answer isNil ifTrue:[^ false].
        ] ifTrue:[
            answer := true.
        ].
        answer ifTrue:[
            mgr
                updateVersionMethodOf:aClass
                for:(mgr initialRevisionStringFor:aClass
                         inModule:module
                         directory:directory
                         container:fileName).
        ].
    ].

    (self checkForExistingModule:module usingManager:mgr allowCreate:(createDirs or:[creatingNew]))
        ifFalse:[^ false].
    LastModule := module.

    (self checkForExistingModule:module directory:directory usingManager:mgr allowCreate:(createDirs or:[creatingNew]))
        ifFalse:[^ false].
    LastPackage := directory.

    "/
    "/ check for the container itself
    "/
    (mgr isContainerBased not
    or:[ mgr checkForExistingContainer:fileName inModule:module directory:directory ]) ifTrue:[
"/            (oldModule notNil
"/            and:[(oldModule ~= module)
"/                 or:[oldPackage ~= package
"/                 or:[oldFileName ~= fileName]]])
"/            ifFalse:[
"/                self warn:(resources string:'no change').
"/                ^ false.
"/            ].

        mgr isContainerBased ifTrue:[
            creatingNew ifTrue:[
                self warn:(resources string:'Container for %1 already exists in %2/%3.' with:fileName with:module with:directory) withCRs.
            ].

            doCheckinWithoutAsking ifFalse:[
                (Dialog
                    confirm:(resources string:'check %1 into the existing container

    %2 / %3 / %4  ?'
                                    with:className
                                    with:module
                                    with:directory
                                    with:fileName) withCRs
                    noLabel:'Cancel')
                ifFalse:[
                    ^ false.
                ].
            ].
        ].
        oldFileName notNil ifTrue:[
            msg := ('forced checkin / source container change from ' , oldFileName).
        ] ifFalse:[
            msg := 'defined source container'
        ].

        (forceCheckIn := doCheckinWithoutAsking) ifFalse:[
            (mgr
                checkinClass:aClass
                fileName:fileName
                directory:directory
                module:module
                logMessage:msg)
            ifFalse:[
                doCheckinWithoutAsking ifFalse:[
                    (Dialog
                        confirm:'No easy merge seems possible; force checkin (no merge) ?'
                        noLabel:'Cancel')
                    ifFalse:[
                        ^ false.
                    ].
                ].
                forceCheckIn := true.
            ]
        ].
        forceCheckIn ifTrue:[
            (mgr
                checkinClass:aClass
                fileName:fileName
                directory:directory
                module:module
                logMessage:msg
                force:true)
            ifFalse:[
                self warn:(resources string:'Failed to check into existing container.').
                ^ false.
            ].
        ].
        ^ true
    ] ifFalse:[
        (createContainer or:[creatingNew]) ifFalse:[
            (Dialog
                 confirm:(resources string:'No container exists for %1 in %2/%3\\create ?'
                                      with:fileName with:module with:directory) withCRs
                 noLabel:'Cancel') ifFalse:[
                ^ false
            ]
        ]
    ].

    aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | mthd setPackage:requiredPackage].
    aClass package:requiredPackage.

    (mgr
        createContainerFor:aClass
        inModule:module
        package:directory
        container:fileName
    ) ifFalse:[
        self warn:(resources string:'Failed to create container.').
        ^ false.
    ].
    ^ true

    "Created: / 21-12-2011 / 18:34:02 / cg"
! !

!PerforceSourceCodeManagerUtilities methodsFor:'utilities-p4'!

submit
    self defaultManager submit
! !

!PerforceSourceCodeManagerUtilities methodsFor:'utilities-p4-interaction'!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswerOrNil withQuickOption:withQuickOption
    "ask for a log message for checking in a class (plus checkinQuick state info),
     and other info (mark as stable, for example).
     Return the info-object (actually: the dialog) or nil if aborted."

    |logMsg infoDialog|

    infoDialog := self defaultManager checkInInfoDialogClass 
                getCheckinInfoFor:aClassNameOrPackageNameString 
                initialAnswer:(initialAnswerOrNil ? LastSourceLogMessage)
                withQuickOption:withQuickOption.
    infoDialog notNil ifTrue:[
        logMsg := infoDialog logMessage.
        logMsg notEmptyOrNil ifTrue:[
            LastSourceLogMessage := logMsg
        ].
    ].
    ^ infoDialog

    "
     SourceCodeManagerUtilities getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 06-07-2010 / 11:21:28 / cg"
! !

!PerforceSourceCodeManagerUtilities::P4CheckinInfoDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    checkin-dialog.
    used to be private in SourceCodeManagerUtilites.
    moved to libtool because libbasic3 should not contain code inheriting from GUI classes.

    [author:]

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!PerforceSourceCodeManagerUtilities::P4CheckinInfoDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PerforceSourceCodeManager::P4CheckinInfoDialog andSelector:#windowSpec
     PerforceSourceCodeManager::P4CheckinInfoDialog new openInterface:#windowSpec
     PerforceSourceCodeManager::P4CheckinInfoDialog open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Enter Log Message'
          name: 'Enter Log Message'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 800 327)
        )
        component: 
       (SpecCollection
          collection: (
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel2'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              horizontalLayout: left
              verticalLayout: center
              horizontalSpace: 0
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Enter checkIn log-message for:'
                    name: 'Label1'
                    translateLabel: true
                    resizeForLabel: true
                    useDefaultExtent: true
                  )
                 (LabelSpec
                    name: 'Label2'
                    translateLabel: true
                    labelChannel: descriptionHolder
                    useDefaultExtent: true
                  )
                 )
               
              )
            )
           (TextEditorSpec
              name: 'TextEditor1'
              layout: (LayoutFrame 2 0.0 38 0 -2 1 -125 1)
              model: logMessageHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              hasKeyboardFocusInitially: false
            )
           (LabelSpec
              name: 'Label4'
              layout: (LayoutFrame 0 0.0 -119 1 0 1.0 -97 1)
              translateLabel: true
              labelChannel: warningMessageHolder
            )
           (CheckBoxSpec
              label: 'Quick Checkin (Only Classes in ChangeSet)'
              name: 'CheckInChangedOnlyCheckbox'
              layout: (LayoutFrame 3 0 -95 1 -3 0.5 -73 1)
              visibilityChannel: quickCheckInVisibleHolder
              model: quickCheckInHolder
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Mark as Stable'
              name: 'MarkStableCheckBox'
              layout: (LayoutFrame 3 0 -68 1 -3 1 -46 1)
              model: isStableHolder
              translateLabel: true
            )
           (LabelSpec
              label: 'Tag:'
              name: 'Label3'
              layout: (LayoutFrame -40 0.5 -67 1 0 0.5 -45 1)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'TagEntryField'
              layout: (LayoutFrame 0 0.5 -68 1 -3 1 -46 1)
              enableChannel: tagItInHolder
              model: tagHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel1'
              layout: (LayoutFrame 0 0.0 -40 1 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 2
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 395 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button1'
                    translateLabel: true
                    model: doAccept
                    extent: (Point 396 22)
                  )
                 )
               
              )
            )
           (CheckBoxSpec
              label: 'Immediate Submit'
              name: 'CheckBox1'
              layout: (LayoutFrame 3 0.5 -95 1 -3 1 -73 1)
              model: submitHolder
              translateLabel: true
            )
           )
         
        )
      )
! !

!PerforceSourceCodeManagerUtilities::P4CheckinInfoDialog class methodsFor:'opening'!

getCheckinInfoFor:aString initialAnswer:initialAnswer
    ^ self 
        getCheckinInfoFor:aString 
        initialAnswer:initialAnswer 
        withQuickOption:false

    "
      self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified (format): / 12-03-2012 / 12:38:48 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer withQuickOption:withQuickOption
    ^ self
        getCheckinInfoFor:aClassNameOrPackageNameString 
        initialAnswer:initialAnswer 
        withQuickOption:withQuickOption
        logHistory:#()

    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 12-03-2012 / 12:39:00 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer withQuickOption:withQuickOption logHistory:logHistoryArg
    |dialog warnMessage|

    warnMessage := nil.

    [
        dialog := self new.
        dialog 
            description:aClassNameOrPackageNameString; 
            logMessage:initialAnswer;
            withQuickOption:withQuickOption;
            logHistory:logHistoryArg.

        dialog warningMessageHolder value:warnMessage.
        dialog open.
        dialog accepted ifFalse:[ ^ nil ].
    ] doUntil:[
        |stopAsking|

        stopAsking := dialog allowEmptyLogMessage 
                      or:[ dialog logMessage withoutSeparators notEmptyOrNil ].
        stopAsking ifFalse:[
            warnMessage := (self resources 
                                string:'Please enter a description of your changes!!') 
                                    withColor:Color red.
        ].
        stopAsking
    ].
    ^ dialog    


    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Created: / 12-03-2012 / 12:36:26 / cg"
! !

!PerforceSourceCodeManagerUtilities::P4CheckinInfoDialog methodsFor:'accessing'!

allowEmptyLogMessage
    ^ allowEmptyLogMessage ? false

    "Created: / 06-07-2010 / 11:23:18 / cg"
!

allowEmptyLogMessage:aBoolean 
    allowEmptyLogMessage := aBoolean

    "Created: / 06-07-2010 / 11:23:31 / cg"
!

description
    ^ self descriptionHolder value
!

description:aString
    self descriptionHolder value:aString allBold
!

isStable
    ^ self isStableHolder value
!

isStable:aBoolean
    self isStableHolder value:aBoolean
!

logHistory:something
    logHistory := something.
!

logMessage
    ^ self logMessageHolder value
!

logMessage:aString
    self logMessageHolder value:aString
!

quickCheckIn
    ^ self quickCheckInHolder value
!

quickCheckIn:aBoolean
    self quickCheckInHolder value:aBoolean
!

tag
    ^ self tagHolder value withoutSeparators
!

tag:aStringOrNil
    self tagHolder value:aStringOrNil

    "Modified: / 12-09-2006 / 12:03:50 / cg"
!

tagIt
    ^ self tag notEmptyOrNil

    "Created: / 12-09-2006 / 13:06:49 / cg"
!

withQuickOption:aBoolean
    ^ self quickCheckInVisibleHolder value:aBoolean
! !

!PerforceSourceCodeManagerUtilities::P4CheckinInfoDialog methodsFor:'aspects'!

descriptionHolder
    descriptionHolder isNil ifTrue:[
        descriptionHolder := ValueHolder new.
    ].
    ^ descriptionHolder
!

isStableHolder
    isStableHolder isNil ifTrue:[
        isStableHolder := false asValue.
    ].
    ^ isStableHolder.

    "Modified: / 16-01-2007 / 16:00:26 / cg"
!

logHistoryHeadLineSelectionHolder
    logHistoryHeadLineSelectionHolder isNil ifTrue:[
        logHistoryHeadLineSelectionHolder := nil asValue.
        logHistoryHeadLineSelectionHolder 
            onChangeEvaluate:
                [
                    self logMessageHolder value:(logHistory at:logHistoryHeadLineSelectionHolder value)
                ].
    ].
    ^ logHistoryHeadLineSelectionHolder

    "Created: / 12-03-2012 / 12:40:36 / cg"
!

logHistoryHeadLines
    ^ (logHistory ? #())
        collect:[:msg |
            msg withoutLeadingSeparators asCollectionOfLines first , '...'
        ]

    "Created: / 12-03-2012 / 12:39:35 / cg"
!

logMessageHolder
    logMessageHolder isNil ifTrue:[
        logMessageHolder := '' asValue.
    ].
    ^ logMessageHolder.

    "Modified: / 12-03-2012 / 12:34:13 / cg"
!

quickCheckInHolder
    quickCheckInHolder isNil ifTrue:[
        quickCheckInHolder := true asValue.
    ].
    ^ quickCheckInHolder
!

quickCheckInVisibleHolder
    quickCheckInVisibleHolder isNil ifTrue:[
        quickCheckInVisibleHolder := false asValue.
    ].
    ^ quickCheckInVisibleHolder
!

submitHolder
    submitHolder isNil ifTrue:[
        submitHolder := false asValue.
    ].
    ^ submitHolder
!

tagHolder
    tagHolder isNil ifTrue:[
        tagHolder := '' asValue.
    ].
    ^ tagHolder
!

warningMessageHolder
    warningMessageHolder isNil ifTrue:[
        warningMessageHolder := nil asValue.
    ].
    ^ warningMessageHolder.

    "Created: / 06-07-2010 / 11:30:29 / cg"
! !

!PerforceSourceCodeManagerUtilities::SubmitInfoDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    checkin-dialog.
    used to be private in SourceCodeManagerUtilites.
    moved to libtool because libbasic3 should not contain code inheriting from GUI classes.

    [author:]

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!PerforceSourceCodeManagerUtilities::SubmitInfoDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:PerforceSourceCodeManager::SubmitInfoDialog andSelector:#windowSpec
     PerforceSourceCodeManager::SubmitInfoDialog new openInterface:#windowSpec
     PerforceSourceCodeManager::SubmitInfoDialog open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Enter Log Message'
          name: 'Enter Log Message'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 563 561)
        )
        component: 
       (SpecCollection
          collection: (
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel2'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              horizontalLayout: left
              verticalLayout: center
              horizontalSpace: 0
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Enter checkIn log-message for:'
                    name: 'Label1'
                    translateLabel: true
                    resizeForLabel: true
                    useDefaultExtent: true
                  )
                 (LabelSpec
                    name: 'Label2'
                    translateLabel: true
                    labelChannel: descriptionHolder
                    useDefaultExtent: true
                  )
                 )
               
              )
            )
           (VerticalPanelViewSpec
              name: 'VerticalPanel1'
              layout: (LayoutFrame 0 0.0 38 0 0 1.0 -80 1)
              horizontalLayout: fit
              verticalLayout: topFit
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Files:'
                    name: 'Label4'
                    translateLabel: true
                    adjust: left
                    extent: (Point 563 23)
                  )
                 (TextEditorSpec
                    name: 'TextEditor1'
                    enableChannel: false
                    model: filesHolder
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    hasKeyboardFocusInitially: false
                    extent: (Point 563 146)
                  )
                 (LabelSpec
                    label: 'Log Message:'
                    name: 'Label5'
                    translateLabel: true
                    adjust: left
                    extent: (Point 563 23)
                  )
                 (TextEditorSpec
                    name: 'TextEditor2'
                    model: logMessageHolder
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    hasKeyboardFocusInitially: false
                    extent: (Point 563 242)
                  )
                 )
               
              )
            )
           (CheckBoxSpec
              label: 'Mark as Stable'
              name: 'MarkStableCheckBox'
              layout: (LayoutFrame 3 0 -68 1 -3 1 -46 1)
              model: isStableHolder
              translateLabel: true
            )
           (LabelSpec
              label: 'Tag:'
              name: 'Label3'
              layout: (LayoutFrame -40 0.5 -67 1 0 0.5 -45 1)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'TagEntryField'
              layout: (LayoutFrame 0 0.5 -68 1 -3 1 -46 1)
              enableChannel: tagItInHolder
              model: tagHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel1'
              layout: (LayoutFrame 0 0.0 -40 1 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 2
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 277 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button1'
                    translateLabel: true
                    model: doAccept
                    extent: (Point 277 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!PerforceSourceCodeManagerUtilities::SubmitInfoDialog class methodsFor:'opening'!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer withFileList:fileList
    |dialog warnMessage|

    warnMessage := nil.

    [
        dialog := self new.
        dialog 
            description:aClassNameOrPackageNameString; 
            logMessage:initialAnswer;
            files:fileList.

        dialog warningMessageHolder value:warnMessage.
        dialog open.
        dialog accepted ifFalse:[ ^ nil ].
    ] doUntil:[
        |stopAsking|

        stopAsking := dialog allowEmptyLogMessage 
                      or:[ dialog logMessage withoutSeparators notEmptyOrNil ].
        stopAsking ifFalse:[
            warnMessage := (self resources 
                                string:'Please enter a description of your changes!!') 
                                    withColor:Color red.
        ].
        stopAsking
    ].
    ^ dialog    


    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 06-07-2010 / 11:40:00 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer withQuickOption:withQuickOption
    |dialog warnMessage|

    warnMessage := nil.

    [
        dialog := self new.
        dialog 
            description:aClassNameOrPackageNameString; 
            logMessage:initialAnswer;
            withQuickOption:withQuickOption.

        dialog warningMessageHolder value:warnMessage.
        dialog open.
        dialog accepted ifFalse:[ ^ nil ].
    ] doUntil:[
        |stopAsking|

        stopAsking := dialog allowEmptyLogMessage 
                      or:[ dialog logMessage withoutSeparators notEmptyOrNil ].
        stopAsking ifFalse:[
            warnMessage := (self resources 
                                string:'Please enter a description of your changes!!') 
                                    withColor:Color red.
        ].
        stopAsking
    ].
    ^ dialog    


    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 06-07-2010 / 11:40:00 / cg"
! !

!PerforceSourceCodeManagerUtilities::SubmitInfoDialog methodsFor:'accessing'!

allowEmptyLogMessage
    ^ allowEmptyLogMessage ? false

    "Created: / 06-07-2010 / 11:23:18 / cg"
!

allowEmptyLogMessage:aBoolean 
    allowEmptyLogMessage := aBoolean

    "Created: / 06-07-2010 / 11:23:31 / cg"
!

description
    ^ self descriptionHolder value
!

description:aString
    self descriptionHolder value:aString allBold
!

files
    ^ self filesHolder value
!

files:aString
    self filesHolder value:aString
!

isStable
    ^ self isStableHolder value
!

isStable:aBoolean
    self isStableHolder value:aBoolean
!

logMessage
    ^ self logMessageHolder value
!

logMessage:aString
    self logMessageHolder value:aString
!

quickCheckIn
    ^ self quickCheckInHolder value
!

quickCheckIn:aBoolean
    self quickCheckInHolder value:aBoolean
!

tag
    ^ self tagHolder value withoutSeparators
!

tag:aStringOrNil
    self tagHolder value:aStringOrNil

    "Modified: / 12-09-2006 / 12:03:50 / cg"
!

tagIt
    ^ self tag notEmptyOrNil

    "Created: / 12-09-2006 / 13:06:49 / cg"
!

withQuickOption:aBoolean
    ^ self quickCheckInVisibleHolder value:aBoolean
! !

!PerforceSourceCodeManagerUtilities::SubmitInfoDialog methodsFor:'aspects'!

descriptionHolder
    descriptionHolder isNil ifTrue:[
        descriptionHolder := ValueHolder new.
    ].
    ^ descriptionHolder
!

filesHolder
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    filesHolder isNil ifTrue:[
        filesHolder := '' asValue.
    ].
    ^ filesHolder.
!

isStableHolder
    isStableHolder isNil ifTrue:[
        isStableHolder := false asValue.
    ].
    ^ isStableHolder.

    "Modified: / 16-01-2007 / 16:00:26 / cg"
!

logMessageHolder
    logMessageHolder isNil ifTrue:[
        logMessageHolder := LastSourceLogMessage asValue.
    ].
    ^ logMessageHolder.
!

quickCheckInHolder
    quickCheckInHolder isNil ifTrue:[
        quickCheckInHolder := true asValue.
    ].
    ^ quickCheckInHolder
!

quickCheckInVisibleHolder
    quickCheckInVisibleHolder isNil ifTrue:[
        quickCheckInVisibleHolder := false asValue.
    ].
    ^ quickCheckInVisibleHolder
!

tagHolder
    tagHolder isNil ifTrue:[
        tagHolder := '' asValue.
    ].
    ^ tagHolder
!

tagItInHolder
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    tagItInHolder isNil ifTrue:[
        tagItInHolder := true asValue.
    ].
    ^ tagItInHolder.
!

warningMessageHolder
    warningMessageHolder isNil ifTrue:[
        warningMessageHolder := nil asValue.
    ].
    ^ warningMessageHolder.

    "Created: / 06-07-2010 / 11:30:29 / cg"
! !

!PerforceSourceCodeManagerUtilities::WorkSpace class methodsFor:'instance creation'!

newWorkSpaceFor:aSettingsString  
    "
        get the workspace definition from perforce client command output
    "
    
    |workSpace|

    aSettingsString isEmptyOrNil ifTrue:[ ^nil].
    workSpace := self new initialize.
    ^ workSpace newWorkSpaceFor:aSettingsString
!

newWorkSpaceForSettings:settingsDict
    "
        get the workspace definition from perforce client command output"
    
    |workSpace|

    workSpace := self new initialize.
    ^ workSpace newWorkSpaceForSettings:settingsDict
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'accessing'!

client
    ^ client
!

client:something
    client := something.
!

host
    ^ host
!

host:something
    host := something.
!

owner
    ^ owner
!

owner:something
    owner := something.
!

perforceSettings

    perforceSettings isNil ifTrue:[
        perforceSettings := Dictionary new.
    ].
    ^ perforceSettings
!

perforceSettings:something
    perforceSettings := something.
    self owner:(perforceSettings at:#user ifAbsent:nil).
    self client:(perforceSettings at:#client ifAbsent:nil).
!

root
    ^ root
!

root:something
    root := something.
!

tempDirectory

    tempDirectory isNil ifTrue:[
        tempDirectory := PerforceSourceCodeManager createTempDirectory:nil forModule:nil.
    ].
    ^ tempDirectory
!

temporaryWorkSpace
    ^ temporaryWorkSpace
!

views
    views isNil ifTrue:[
        views := OrderedCollection new.
    ].
    ^ views
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'actions'!

addCheckIn:checkInDefinition submit:doSubmit

    | packagePath fullFilename s perforceCommand outputStream errorStream result tmpFilename binRevision newRevisionString number|

    " create container for class initial check in"
    checkInDefinition isClassCheckin ifTrue:[
        binRevision := checkInDefinition getBinaryRevisionNumber.
        (binRevision notNil and:[binRevision ~= 0]) ifTrue:[
            (Dialog confirm:('Someone seems to have removed the source container for ',checkInDefinition definitionObjectString,'\\Force new checkin ?') withCRs) ifTrue:[
                checkInDefinition definitionClass setBinaryRevision:nil.
            ] ifFalse:[
                ^false
            ].
        ].
    ].
    "initial checkin here"
    self activityNotification:'adding ' , checkInDefinition definitionObjectString , ' to perforce repository...'.
    self getTemporaryWorkspaceFor:checkInDefinition.
    self temporaryWorkSpace isNil ifTrue:[
        self perforceError raiseErrorString:('Error getting temporary workspace when adding ', checkInDefinition definitionObjectString, '.').
        ^false
    ].
    number := self getChangeListNumber.
    number isNil ifTrue:[
        self perforceError raiseErrorString:('Error when getting a change list for ', checkInDefinition definitionObjectString, '.').
        ^false
    ].
    packagePath := Smalltalk getPackageDirectoryForPackage:checkInDefinition package.
    fullFilename := (packagePath construct:checkInDefinition packageDir) construct:checkInDefinition fileName.
    tmpFilename := self getTemporaryFilenameFor:fullFilename pathName.
    tmpFilename directory recursiveMakeDirectory.
    s := tmpFilename writeStream.
    checkInDefinition isClassCheckin ifTrue:[
        newRevisionString := self initialRevisionStringFor:checkInDefinition.
        PerforceSourceCodeManager updateVersionMethod:(PerforceSourceCodeManager nameOfVersionMethodInClasses) 
            of:checkInDefinition definitionClass 
            for:newRevisionString.
    ].
    checkInDefinition isClassCheckin ifTrue:[
        PerforceSourceCodeManager fileOutSourceCodeOf:checkInDefinition definitionClass on:s.
    ] ifFalse:[
        s nextPutAll:checkInDefinition fileContents.
    ].
    s close.
    perforceCommand := ('add  -t +ko -c ' , number printString, ' "', tmpFilename pathName, '"').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root 
        inputFrom:nil outputTo:outputStream 
        errorTo:errorStream
        logHeader:('adding ', checkInDefinition definitionObjectString, '.').
    result ifFalse:[
        checkInDefinition isClassCheckin ifTrue:[
            Class withoutUpdatingChangesDo:[
                checkInDefinition definitionClass class removeSelector:PerforceSourceCodeManager nameOfVersionMethodInClasses    
            ].
        ].
        ^ false
    ].
    result := self changeChangeDescriptionTo:checkInDefinition logMessage asStringCollection changeNumber:number printString.
    doSubmit ifTrue:[
        result := self submitChangeNumber:number printString.
        checkInDefinition isClassCheckin ifFalse:[
            " checkout in real workspace "
            perforceCommand := ('sync ' , number printString, ' "', fullFilename pathName, '"').
            outputStream := ReadWriteStream on:''.
            errorStream := ReadWriteStream on:''.
            result := self executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root 
                inputFrom:nil outputTo:outputStream 
                errorTo:errorStream
                logHeader:('sync in my workspace ', checkInDefinition definitionObjectString, '.').
            result ifFalse:[
                ^ false
            ].        
        ].
    ].

    self activityNotification:''.
    ^result

    "Modified: / 28-06-2016 / 07:55:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

askForMergedSource:mergedSource 
    localSource:mySource 
    changesDict:changesDict 
    haveRevision:haveRevision 
    changesAsLogged:changesAsLogged 
    pathName:pathName
    definitionClass:definitionClass

    |msg answer checkInRepaired emphasizedText emSep diffTextComment didAccept editor repairedText resultSource|

    (changesDict notNil and:[(changesDict at:#conflicting) > 0]) ifTrue:[
        "ooops must resolve conflicts"
        msg := self messageForConflictsInClass:definitionClass revision:haveRevision.
        answer := self checkinTroubleDialog:'Version conflict'
             message:msg
             log:changesAsLogged
             abortable:false
             option:'show conflicts'
             option2:'resolve conflicts'.

        answer == #option ifTrue:[
            "/
            "/ show conflicts in a 3-way DiffTextView ...
            "/
            Diff3TextView
                openOnMergedText:mergedSource
                label:'your version (checkin attempt)'
                label:'original (base version)'
                label:'newest repository version'.
        ].

        checkInRepaired := false.
        answer == #option2 ifTrue:[
            "/
            "/ allow checkin of repair version
            "/ this is error prone ...
            "/
            "/
            "/ show merged version in an editor ...
            "/ ... accept will check it in.
            "/
            emphasizedText := mergedSource asStringCollection.
            emSep := (Array with:(#color->Color black) with:(#backgroundColor->Color green)).
            emphasizedText := Diff3TextView
                        emphasizeMergedDiff3TextFromPerforce:emphasizedText
                        origEmphasis:(Array with:(#color->Color black) with:(#backgroundColor->Color yellow))
                        otherEmphasis:(Array with:(#color->Color white) with:(#backgroundColor->Color red))
                        yourEmphasis:(Array with:(#color->Color white) with:(#backgroundColor->Color red))
                        separatorEmphasis:emSep.

            diffTextComment := self diffTextComment.
            diffTextComment := (Text string:diffTextComment emphasis:emSep) asStringCollection.
            emphasizedText := diffTextComment , emphasizedText.

            didAccept := false. checkInRepaired := true.
            [didAccept not and:[checkInRepaired]] whileTrue:[
                editor := RCSConflictEditTextView
                            setupWith:emphasizedText
                            title:'Resolve conflicts in ' , pathName asFilename baseName , ', then accept & close to checkin'.

                editor acceptAction:[:dummy |
                    repairedText := editor list.
                    didAccept := true.
                ].
                didAccept := false.
                editor topView openModal.

                didAccept ifFalse:[
                    (Dialog confirm:'You did not accept the new text. Edit again ?')
                    ifFalse:[
                        checkInRepaired := false.
                    ]
                ] ifTrue:[
                    "/ check if all green-stuff (separators) have been removed
                    (repairedText findFirst:[:line | line notNil and:[line notEmpty and:[(line emphasisAt:1) = emSep]]]) ~~ 0 ifTrue:[
                        self warn:'You have to look at ALL conflicts, and remove ALL green lines as a confirmation !!'.
                        didAccept := false.
                    ]
                ].
            ].
            resultSource := repairedText asString string.
        ].

        checkInRepaired ifTrue:[
            Transcript showCR:'PerforceSourceCodeManager [info]: checking in ' , pathName asFilename baseName , ' (manually repaired version) ...'
        ] ifFalse:[
            'PerforceSourceCodeManager [warning]: cannot (for now) checkin; conflicts found' infoPrintCR.
            Transcript showCR:'checkin of ' , pathName asFilename baseName , ' aborted (conflicting changes; repository unchanged)'.
            ^ nil.
        ]
    ] ifFalse:[
        mySource = mergedSource ifTrue:[
            msg := self messageForNoChangesInClass:definitionClass.
            self checkinTroubleDialog:'Merging versions'
                           message:msg
                           log:changesAsLogged
                           abortable:false
                           option:nil.
        ] ifFalse:[
            msg := self messageForChangesInClass:definitionClass revision:haveRevision.
            answer := self checkinTroubleDialog:'Merging versions'
                           message:msg
                           log:changesAsLogged
                           abortable:true
                           option:'Stop - see first'.
            answer ~~ true ifTrue:[
                answer == #option ifTrue:[
                    DiffCodeView
                        openOn:mySource
                        label:'current version'
                        and:mergedSource
                        label:'merged version'.

                ].
                Transcript showCR:'checkin aborted - (no merge; repository unchanged)'.
                ^ nil.
            ].
            resultSource := mergedSource.
        ].
    ].
    ^ resultSource

    "Modified (format): / 01-06-2012 / 10:45:09 / cg"
!

changeChangeDescriptionTo:logLines changeNumber:changeNumber

    |perforceCommand outputStream errorStream changeListFile result changeFileContents changeListFileStream firstIndex oldLogFileLines writeNextLine newLogFileLines currentTokenLineParts currentToken|

    self temporaryWorkSpace isNil ifTrue:[
	self perforceError raiseErrorString:('Error getting temporary workspace when change the change description for ', changeNumber printString, '.').
	^false.
    ].
    perforceCommand := 'change -o ', (changeNumber ? '').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self temporaryWorkSpace executePerforceCommand:perforceCommand
			inDirectory:self tempDirectory
			inputFrom:nil
			outputTo:outputStream
			errorTo:errorStream
			logHeader:('get change desription for change ', changeNumber printString, '.').
    result ifFalse:[
	^ false
    ].
    changeFileContents := outputStream contents.
    changeFileContents isEmptyOrNil ifTrue:[
	^false
    ].
    changeListFile := self tempDirectory construct:'change'.
    changeListFileStream := changeListFile writeStream.
    changeFileContents := changeFileContents asStringCollection.
    firstIndex := changeFileContents indexOfLineStartingWith:'Description:'.
    firstIndex == 0 ifTrue:[
	^false
    ].
    oldLogFileLines := StringCollection new.
    changeFileContents from:firstIndex do:[:aLine|
	((aLine size > 1) and:[aLine first ~= $# and:[aLine first isSeparator not]]) ifTrue:[
	    currentTokenLineParts := aLine asCollectionOfSubstringsSeparatedBy:$:.
	    currentTokenLineParts size > 1 ifTrue:[
		currentToken := currentTokenLineParts first.
	    ].
	].
	((aLine size > 1) and:[aLine first isSeparator and:[currentToken = 'Description']]) ifTrue:[
	    oldLogFileLines add:(aLine copyFrom:2).
	].
    ].
    newLogFileLines := StringCollection new.
    changeNumber isNil ifTrue:[
	newLogFileLines := logLines.
    ] ifFalse:[
	(oldLogFileLines asString includesString:logLines asString) ifTrue:[
	    newLogFileLines := oldLogFileLines.
	] ifFalse:[
	    newLogFileLines := oldLogFileLines.
	    newLogFileLines addAll:logLines
	].
    ].
    writeNextLine := true.
    changeFileContents do:[:aLine|
	writeNextLine ifFalse:[
	    (aLine notEmpty and:[aLine first isSeparator not]) ifTrue:[
		writeNextLine := true.
	    ].
	].
	writeNextLine ifTrue:[
	    (aLine startsWith:'Description:') ifTrue:[
		changeListFileStream nextPutLine:aLine.
		newLogFileLines do:[:logLine|
		    changeListFileStream nextPut:Character tab.
		    changeListFileStream nextPutLine:logLine.
		].
		writeNextLine := false.
	    ] ifFalse:[
		changeListFileStream nextPutLine:aLine
	    ].
	].
    ].
    changeListFileStream close.
    perforceCommand := ('change -i < "', changeListFile pathName, '"').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self temporaryWorkSpace executePerforceCommand:perforceCommand
			inDirectory:self tempDirectory
			inputFrom:nil
			outputTo:outputStream
			errorTo:errorStream
			logHeader:('write change desription for change ', changeNumber printString, '.').
    result ifFalse:[
	^false
    ].
    ^ true
!

checkForExistingContainer:checkInDefinition


    |perforceCommand outputStream errorStream result packagePath fullFilename depotPath|

    packagePath := Smalltalk getPackageDirectoryForPackage:checkInDefinition package.
    fullFilename := packagePath construct:checkInDefinition packageDir.
    depotPath := self getDepotPathForLocalPath:fullFilename pathName.
    perforceCommand := ('dirs "' ,depotPath , '"').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    self getTemporaryWorkspaceFor:checkInDefinition.
    self temporaryWorkSpace isNil ifTrue:[
        self perforceError raiseErrorString:('Error getting temporary workspace when check for existing container ', checkInDefinition definitionObjectString, '.').
        ^false.
    ].
    result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
        inputFrom:nil outputTo:outputStream
        errorTo:errorStream
        logHeader:('dirs in checkForExistingContainer for ', depotPath, '.').
    result ifFalse:[
        ^ false
    ].
    errorStream contents notEmpty ifTrue:[
        ^false
    ].
    ^ true

    "Modified: / 28-06-2016 / 07:55:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkIn:checkInDefinition submit:doSubmit

    | packagePath fullFilename s perforceCommand outputStream errorStream result tmpFilename fileNameAndRev tmpFilenameAndRev
      haveChange nextVersionMethod diffOutput number baseRevision cls newestInRepository newVersionString openChangeNumber|

    self activityNotification:'checkin ' , checkInDefinition definitionObjectString , ' to perforce repository...'.
    [
        cls := checkInDefinition definitionClass.
        self getTemporaryWorkspaceFor:checkInDefinition.
        self temporaryWorkSpace isNil ifTrue:[
            self perforceError raiseErrorString:('Error getting temporary workspace when check in ', checkInDefinition definitionObjectString, '.').
            ^false.
        ].
        baseRevision := checkInDefinition getLocalRevisionNumber.
        newestInRepository := checkInDefinition getReposRevisionNumberBeforeCheckin.
        (checkInDefinition isClassCheckin and:[baseRevision isNil]) ifTrue:[
            (Dialog confirm:('The version-info of ',checkInDefinition definitionObjectString allBold,' not exists. \Patch the version info?') withCRs)
            ifTrue:[
                newVersionString := self updatedRevisionStringOf:cls
                                        forRevision:newestInRepository printString with:(cls revisionStringOfManager:PerforceSourceCodeManager).
                PerforceSourceCodeManager updateVersionMethod:(PerforceSourceCodeManager nameOfVersionMethodInClasses)
                        of:cls
                        for:newVersionString.
                baseRevision := checkInDefinition getLocalRevisionNumber.
                baseRevision notNil ifTrue:[
                        (Dialog confirm:('Check in ', checkInDefinition definitionObjectString allBold, 'based on version ', baseRevision printString, '?') withCRs)
                        ifFalse:[
                            ^false.
                        ].
                ].
            ] ifFalse:[
                ^false
            ].
        ].
        packagePath := Smalltalk getPackageDirectoryForPackage:checkInDefinition package.
        fullFilename := (packagePath construct:checkInDefinition packageDir) construct:checkInDefinition fileName.
        tmpFilename := self getTemporaryFilenameFor:fullFilename pathName.
        tmpFilename directory recursiveMakeDirectory.
        checkInDefinition isClassCheckin ifTrue:[
            baseRevision > newestInRepository ifTrue:[
                openChangeNumber := self getOpenChangeFor:checkInDefinition.
                openChangeNumber isNil ifTrue:[
                    (Dialog confirm:('The version-info of ',checkInDefinition definitionObjectString allBold,' is wrong \(The class version (',baseRevision printString allBold,') is newer than the newest version in the repository (',newestInRepository printString allBold,').\\Patch the version and checkin ?') withCRs)
                    ifTrue:[
                        newVersionString := self updatedRevisionStringOf:cls
                                                    forRevision:newestInRepository printString with:(cls revisionStringOfManager:PerforceSourceCodeManager).
                        PerforceSourceCodeManager updateVersionMethod:(PerforceSourceCodeManager nameOfVersionMethodInClasses)
                            of:cls
                            for:newVersionString.

                        cls updateVersionMethodFor:newVersionString.
                    ].
                ].
            ].
        ].
        checkInDefinition isClassCheckin ifTrue:[
            fileNameAndRev := checkInDefinition fileName, '#', baseRevision printString.
        ] ifFalse:[
            fileNameAndRev := checkInDefinition fileName, '#', newestInRepository printString.
        ].
        tmpFilenameAndRev := tmpFilename directory construct:fileNameAndRev.

        openChangeNumber notNil ifTrue:[
            s := tmpFilename writeStream.
            checkInDefinition isClassCheckin ifTrue:[
                PerforceSourceCodeManager fileOutSourceCodeOf:cls on:s.
            ] ifFalse:[
                s nextPutAll:checkInDefinition fileContents.
            ].
            s close.
            self changeChangeDescriptionTo:checkInDefinition logMessage asStringCollection changeNumber:openChangeNumber printString.
            doSubmit ifTrue:[
                self submitChangeNumber:openChangeNumber printString
            ].
            ^true
        ].
        perforceCommand := ('revert "' , tmpFilename pathName, '"').
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
            inputFrom:nil outputTo:outputStream
            errorTo:errorStream
            logHeader:('sync ', checkInDefinition definitionObjectString, ' to revision ', baseRevision printString, '.').
        result ifFalse:[
            ^ false
        ].
        perforceCommand := ('sync -f "' , tmpFilenameAndRev pathName, '"').
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
            inputFrom:nil outputTo:outputStream
            errorTo:errorStream
            logHeader:('sync ', checkInDefinition definitionObjectString, ' to revision ', baseRevision printString, '.').
        result ifFalse:[
            ^ false
        ].

        number := self getChangeListNumber.
        number isNil ifTrue:[
            self perforceError raiseErrorString:('Error when getting a change list for ', checkInDefinition definitionObjectString, '.').
            ^false
        ].
        perforceCommand := ('edit -c ' ,number printString, ' "', tmpFilename pathName, '"').
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
            inputFrom:nil outputTo:outputStream
            errorTo:errorStream
            logHeader:('edit ', checkInDefinition definitionObjectString, '.').
        result ifFalse:[
            ^ false
        ].
        s := tmpFilename writeStream.
        checkInDefinition isClassCheckin ifTrue:[
            PerforceSourceCodeManager fileOutSourceCodeOf:cls on:s.
        ] ifFalse:[
            s nextPutAll:checkInDefinition fileContents.
        ].
        s close.
        perforceCommand := ('diff -db -dw -dl "' , tmpFilename pathName, '"').
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
            inputFrom:nil outputTo:outputStream
            errorTo:errorStream
            logHeader:('diff ', checkInDefinition definitionObjectString, '.').
        diffOutput := outputStream contents asStringCollection.
        haveChange := diffOutput isEmptyOrNil or:[diffOutput notEmptyOrNil and:[diffOutput size > 1]].
        haveChange ifFalse:[
            self information:checkInDefinition definitionObjectString, ' not changed for revision ', baseRevision printString.
            newestInRepository ~= baseRevision ifTrue:[
                newVersionString := self updatedRevisionStringOf:cls
                                            forRevision:newestInRepository printString with:(cls revisionStringOfManager:PerforceSourceCodeManager).
                PerforceSourceCodeManager updateVersionMethod:(PerforceSourceCodeManager nameOfVersionMethodInClasses)
                        of:cls
                        for:newVersionString.
            ].
            perforceCommand := ('revert "' , tmpFilename pathName, '"').
            outputStream := ReadWriteStream on:''.
            errorStream := ReadWriteStream on:''.
            result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
                inputFrom:nil outputTo:outputStream
                errorTo:errorStream
                logHeader:('revert ', checkInDefinition definitionObjectString, '.').
            ^true
        ].
        checkInDefinition isClassCheckin ifTrue:[
            nextVersionMethod := self nextRevisionStringFor:checkInDefinition.
            nextVersionMethod isNil ifTrue:[
                self perforceError raiseErrorString:('Cant get next version method string for ', checkInDefinition definitionObjectString, ' revision ', baseRevision printString, '.').
                ^false
            ].
            PerforceSourceCodeManager updateVersionMethod:(PerforceSourceCodeManager nameOfVersionMethodInClasses)
                    of:cls
                    for:nextVersionMethod.
        ].
        result := self changeChangeDescriptionTo:checkInDefinition logMessage asStringCollection changeNumber:number printString.
        doSubmit ifTrue:[
            result := self submitChangeNumber:number printString
        ].
    ] ensure:[
        self activityNotification:''.
    ].
    ^result

    "Modified: / 28-06-2016 / 07:55:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createChange

    ^self changeChangeDescriptionTo:('' asStringCollection) changeNumber:nil
!

createWorkSpaceClientSpecFor:checkInDefinition

    |ws myView|

    ws := WriteStream on:''.
    ws nextPutAll:'Client: '.
    ws nextPutAll:(self client).
    ws cr.
    ws nextPutAll:'Owner: '.
    ws nextPutAll:(self owner).
    ws cr.
    ws nextPutAll:'Host: '.
    ws nextPutAll:(self host).
    ws cr.
    ws nextPutAll:'Description: '.
    ws nextPutAll:'Used temporary for Smalltalk/X'.
    ws cr.
    ws nextPutAll:'Root: '.
    ws nextPutAll:(self root asFilename pathName).
    ws cr.
    ws nextPutAll:'Options: '.
    ws nextPutAll:'allwrite noclobber nocompress unlocked nomodtime normdir'.
    ws cr.
    ws nextPutAll:'SubmitOptions: '.
    ws nextPutAll:'submitunchanged'.
    ws cr.
    ws nextPutAll:'LineEnd: '.
    ws nextPutAll:'local'.
    ws cr.
    ws nextPutAll:'View: '.
    myView := checkInDefinition workSpace getViewForPackage:checkInDefinition package.
    ws nextPutAll:myView depot.
    ws space.
    ws nextPutAll:'//', self client, '/...'.
    ws cr.
    ws close.
    ^ws contents
!

delete:checkInDefinition submit:doSubmit

    | packagePath fullFilename perforceCommand outputStream errorStream result tmpFilename number newestInRepository|

    self activityNotification:'delete ' , checkInDefinition definitionObjectString , ' from perforce repository...'.
    [
        newestInRepository := checkInDefinition getReposRevisionNumberBeforeCheckin.
        newestInRepository isNil ifTrue:[
            self information:(checkInDefinition definitionObjectString, ' not exists in repository.').
            ^true
        ].
        self getTemporaryWorkspaceFor:checkInDefinition.
        self temporaryWorkSpace isNil ifTrue:[
            self perforceError raiseErrorString:('Error getting temporary workspace when check in ', checkInDefinition definitionObjectString, '.').
            ^false.
        ].
        packagePath := Smalltalk getPackageDirectoryForPackage:checkInDefinition package.
        fullFilename := (packagePath construct:checkInDefinition packageDir) construct:checkInDefinition fileName.
        tmpFilename := self getTemporaryFilenameFor:fullFilename pathName.
        tmpFilename directory recursiveMakeDirectory.

        number := self getChangeListNumber.
        number isNil ifTrue:[
            self perforceError raiseErrorString:('Error when getting a change list for ', checkInDefinition definitionObjectString, '.').
            ^false
        ].
        perforceCommand := ('delete -c ' ,number printString, ' "', tmpFilename pathName, '"').
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root 
            inputFrom:nil outputTo:outputStream 
            errorTo:errorStream
            logHeader:('Error delete ', checkInDefinition definitionObjectString, '.').
        result ifFalse:[
            ^ false
        ].
        result := self changeChangeDescriptionTo:checkInDefinition logMessage asStringCollection changeNumber:number printString.
        doSubmit ifTrue:[
            result := self submitChangeNumber:number printString
        ].
    ] ensure:[
        self activityNotification:''.
    ].
    ^result

    "Modified: / 28-06-2016 / 07:55:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deleteWorkSpaceFromServer

    |perforceCommand outputStream errorStream result tmpWorkSpace|

    tmpWorkSpace := self temporaryWorkSpace.
    tmpWorkSpace isNil ifTrue:[ ^true].
    perforceCommand := ('client -df ', client).
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
	inputFrom:nil outputTo:outputStream
	errorTo:errorStream
	logHeader:('delete client ', client).
    result ifFalse:[
	^ false
    ].
    ^true
!

getChangeDespriptionInfoFor:changeNumber

    |valuePairs startLineIndex keyEndIndex changeContents cmd outputStream errorStream result keyValues beginLine endLine keyName keyValue|

    self temporaryWorkSpace isNil ifTrue:[
        self perforceError raiseErrorString:('Error getting temporary workspace when try to get change description for ', changeNumber printString, '.').
        ^nil.
    ].
    valuePairs := OrderedCollection new.
    cmd := 'change -o ', (changeNumber ? '').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self temporaryWorkSpace executePerforceCommand:cmd
                        inDirectory:self tempDirectory
                        inputFrom:nil
                        outputTo:outputStream
                        errorTo:errorStream
                        logHeader:('getting change description ', (changeNumber ? ''), '.').
    result ifFalse:[
        ^ nil
    ].
    changeContents := outputStream contents asStringCollection.
    changeContents doWithIndex:[:aLine :index|
        startLineIndex isNil ifTrue:[
            (aLine isEmpty or:[(aLine startsWith:$#) or:[aLine first isSeparator]]) ifFalse:[
                keyEndIndex := aLine indexOf:$:.
                keyEndIndex ~~ 0 ifTrue:[
                    startLineIndex := index.
                    valuePairs add:(Array with:index with:nil with:(aLine copyTo:keyEndIndex - 1)).
                ].
            ].
        ] ifFalse:[
            (aLine isEmpty or:[aLine startsWith:$#]) ifTrue:[
                valuePairs last at:2 put:index.
                startLineIndex := nil.
            ].
        ].
    ].
    keyValues := Dictionary new.
    valuePairs do:[:each|
        beginLine := each first.
        endLine := each second.
        keyName := each last.
        (beginLine == (endLine - 1)) ifTrue:[
            keyValue := (changeContents at:beginLine) copyFrom:(keyName size + 2).
            keyValue := (keyValue withoutLeadingSeparators withoutTrailingSeparators) asStringCollection.
        ] ifFalse:[
            keyValue := changeContents copyFrom:(beginLine + 1) to:(endLine - 1).
            keyValue := keyValue collect:[:each | each withoutLeadingSeparators withoutTrailingSeparators].
        ].
        keyValues at:keyName put:keyValue.
    ].
    ^ keyValues.
!

getChangeListNumber

    |numbers|

    numbers := self getCurrentChangeListNumbers.
    numbers notEmptyOrNil ifTrue:[
        ^numbers first.
    ].
    self createChange ifTrue:[
        numbers := self getCurrentChangeListNumbers.
        numbers notEmptyOrNil ifTrue:[
            ^numbers first.
        ].
        
    ].
    ^nil
!

getCurrentChangeListNumbers

    |perforceCommand outputStream errorStream result pendingChangesOutput words numbers number|

    self temporaryWorkSpace isNil ifTrue:[
	self perforceError raiseErrorString:('Error getting temporary workspace when try to get change numbers.').
	^nil.
    ].
    perforceCommand := 'changes -s pending -u ', owner.
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self temporaryWorkSpace executePerforceCommand:perforceCommand
			inDirectory:self tempDirectory
			inputFrom:nil
			outputTo:outputStream
			errorTo:errorStream
			doLog:false.
    result ifFalse:[
	^ nil
    ].
    numbers := OrderedCollection new.
    pendingChangesOutput := outputStream contents asStringCollection.
    pendingChangesOutput do:[:eachLine|
	words := eachLine asCollectionOfWords.
	words size > 1 ifTrue:[
	    number := Number readFrom:(ReadStream on:(words at:2)) onError:nil.
	    numbers add:number.
	].
    ].
    ^numbers
!

getFileStatForPathname:aPathname


    |perforceCommand outputStream errorStream result fileStatDict endOfKeywordIndex keyWord keyValue|

    perforceCommand := ('fstat  "' , aPathname, '"').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self executePerforceCommand:perforceCommand inDirectory:self root 
        inputFrom:nil outputTo:outputStream 
        errorTo:errorStream
        logHeader:('getting file status from ', aPathname, '.').
    result ifFalse:[
        ^ nil
    ].
    fileStatDict := Dictionary new.
    outputStream contents asStringCollection do:[:aLine|
        endOfKeywordIndex := aLine indexOfSeparatorStartingAt:5.
        keyWord := aLine copyFrom:5 to:(endOfKeywordIndex - 1).
        keyValue := aLine copyFrom:endOfKeywordIndex + 1.
        fileStatDict at:keyWord put:keyValue.
    ].
    ^ fileStatDict

"
     | workSpace tempWorkSpace dict|
    workSpace := PerforceSourceCodeManager getWorkSpaceForPackage:'applistx'.
    tempWorkSpace := workSpace temporaryWorkSpace.
    dict := tempWorkSpace getFileStatForPathname:'C:\Dokumente und Einstellungen\gds2180\Lokale Einstellungen\Temp\stx_tmp\st6120368\applistx\util\libDataType\ActionLQualifier.st'.
    dict includesKey:'unresolved'
"
!

getOpenChangeFor:checkInDefinition

    |numbers changeDescr files versionInfo|

    numbers := self getCurrentChangeListNumbers.
    numbers notEmptyOrNil ifTrue:[
        numbers do:[:changeNumber|
            changeDescr := self getChangeDespriptionInfoFor:changeNumber printString.
            files := changeDescr at:#Files ifAbsent:[nil].
            files notNil ifTrue:[
                versionInfo := PerforceSourceCodeManager versionInfoClass fromRCSString:checkInDefinition getLocalRevisionString.
                files do:[:aFileAndAction|
                    (aFileAndAction startsWith:versionInfo repositoryPathName) ifTrue:[
                        ^changeNumber
                    ].
                ].
            ].
        ].
    ].
    ^nil
!

getTemporaryWorkspaceFor:checkInDefinition
    "
        create an temporary workspace for handle checkin
    "

    |workSpaceName workSpaceDefinitionFilename ws perforceCommand result readStream  directory 
     settingsTemporary myView outputStream errorStream lineStream clientSpec index words|

    directory := self tempDirectory.
    workSpaceName := self temporaryClientName.
    perforceCommand := 'clients -u ' , (self perforceSettings at:#user).
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self executePerforceCommand:perforceCommand
                        inDirectory:directory pathName
                        inputFrom:nil
                        outputTo:outputStream
                        errorTo:errorStream
                        doLog:false
                        logHeader:('check for existing workspace client.').
    result ifFalse:[
        temporaryWorkSpace := nil.
    ]. 
    index := outputStream contents asStringCollection findFirst:[:aLine|
        words := aLine asCollectionOfWords.
        words size > 1 and:[words second = workSpaceName]
    ].
    index = 0 ifTrue:[
        temporaryWorkSpace := nil.   
    ].
    temporaryWorkSpace isNil ifTrue:[
        directory exists ifFalse:[
            self perforceError raiseErrorString:('Perforce temporary workspace directory ', directory pathName, ' not exists.').
            ^nil
        ].
        settingsTemporary := self perforceSettings copy.
        settingsTemporary at:#client put:workSpaceName.
        temporaryWorkSpace := self class newWorkSpaceForSettings:settingsTemporary.
        temporaryWorkSpace root:directory asFilename pathName.
        temporaryWorkSpace host:self host.
        myView := self getViewForPackage:checkInDefinition package.
        lineStream := WriteStream on:''.
        lineStream nextPutAll:myView depot.
        lineStream space.
        lineStream nextPutAll:'//', workSpaceName, '/...'.
        temporaryWorkSpace views add:(View newFromLine:lineStream contents workspace:temporaryWorkSpace).
        workSpaceDefinitionFilename := directory asFilename construct:workSpaceName.
        clientSpec := temporaryWorkSpace createWorkSpaceClientSpecFor:checkInDefinition.
        ws := workSpaceDefinitionFilename writeStream.
        ws nextPutAll:clientSpec.
        ws close.

        readStream := ReadStream on:clientSpec.
        perforceCommand := 'client -i < "', workSpaceDefinitionFilename pathName, '"'.
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := temporaryWorkSpace executePerforceCommand:perforceCommand
                            inDirectory:directory pathName
                            inputFrom:nil
                            outputTo:outputStream 
                            errorTo:errorStream
                            doLog:false
                            logHeader:('writing temporary workspace definition.').
        result ifFalse:[
            temporaryWorkSpace := nil.
        ]. 
    ].
    ^temporaryWorkSpace
!

mergeOrResolveConflictsForChangeNumber:aNumber

    | tmpFilename perforceCommand outputStream errorStream result s
      changesAsLogged inStream line changesDict chunksPart words mergedSource mySource
      localRevision resultSource definitionClass descriptionInfo resolveFiles depotPath localPath checkInDefinition fileStatDict|

    self temporaryWorkSpace isNil ifTrue:[
        self perforceError raiseErrorString:('Error getting temporary workspace when try to merge or resolve conflicts for ', aNumber printString, '.').
        ^false.
    ].
    descriptionInfo := (self getChangeDespriptionInfoFor:aNumber printString).
    descriptionInfo isNil ifTrue:[
        ^false.
    ].
    resolveFiles := descriptionInfo at:#Files ifAbsent:nil.
    resolveFiles isNil ifTrue:[
        ^false.
    ].
    resolveFiles do:[:aFileLine|
        depotPath := (aFileLine copyTo:((aFileLine lastIndexOf:$#) - 1 )) withoutTrailingSeparators.
        localPath := self temporaryWorkSpace getLocalPathForDepotPath:depotPath.
        fileStatDict := self temporaryWorkSpace getFileStatForPathname:localPath.
        (fileStatDict includesKey:'unresolved') ifTrue:[
            definitionClass := Smalltalk at:(localPath asFilename withoutSuffix baseName asSymbol) ifAbsent:nil.
            checkInDefinition := PerforceSourceCodeManager getCheckInDefinitionForClass:definitionClass.
            localRevision := checkInDefinition getLocalRevisionNumber.
            tmpFilename := localPath asFilename.
            perforceCommand := ('resolve -af  "' , tmpFilename pathName, '"').
            outputStream := ReadWriteStream on:''.
            errorStream := ReadWriteStream on:''.
            result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
                inputFrom:nil outputTo:outputStream
                errorTo:errorStream
                logHeader:('resolving ', tmpFilename pathName, '.').
            result ifFalse:[
                ^ false
            ].
            "check for conflicts"
            changesAsLogged := StringCollection new.
            inStream := ReadStream on:(outputStream contents).

            [inStream atEnd not] whileTrue:[
                line:= inStream nextLine.
                line notNil ifTrue:[
                    (line startsWith:'Diff chunks:') ifTrue:[
                        changesAsLogged add:line.
                        changesDict := Dictionary new.
                        chunksPart := line copyFrom:('Diff chunks:' size + 1).
                        (chunksPart asCollectionOfSubstringsSeparatedBy:$+) do:[:eachElement|
                            words := eachElement asCollectionOfWords.
                            changesDict at:words second asSymbol put:words first asNumber.
                        ].
                    ].
                ].
            ].
            s := WriteStream on:''.
            PerforceSourceCodeManager fileOutSourceCodeOf:definitionClass on:s.
            mergedSource := tmpFilename readStream contents asString.
            mySource := s contents asString.
            resultSource := self askForMergedSource:mergedSource
                    localSource:mySource
                    changesDict:changesDict
                    haveRevision:(fileStatDict at:'haveRev' ifAbsent:nil)
                    changesAsLogged:changesAsLogged
                    pathName:tmpFilename pathName
                    definitionClass:definitionClass.
            resultSource isNil ifTrue:[
                ^false.
            ].
            "now we have a merge - lets get latest revision and write on it "
            perforceCommand := ('revert "' , tmpFilename pathName, '"').
            outputStream := ReadWriteStream on:''.
            errorStream := ReadWriteStream on:''.
            result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
                inputFrom:nil outputTo:outputStream
                errorTo:errorStream
                logHeader:('revert after resolving ', tmpFilename pathName, '.').
            result ifFalse:[
                ^ false
            ].

            tmpFilename remove.

            perforceCommand := ('sync -f "' , tmpFilename pathName, '"').
            outputStream := ReadWriteStream on:''.
            errorStream := ReadWriteStream on:''.
            result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
                inputFrom:nil outputTo:outputStream
                errorTo:errorStream
                logHeader:('sync after resolving ', tmpFilename pathName, '.').
            result ifFalse:[
                ^ false
            ].

            perforceCommand := ('edit -c ', aNumber printString, ' "' , tmpFilename pathName, '"').
            outputStream := ReadWriteStream on:''.
            errorStream := ReadWriteStream on:''.
            result := self temporaryWorkSpace executePerforceCommand:perforceCommand inDirectory:self temporaryWorkSpace root
                inputFrom:nil outputTo:outputStream
                errorTo:errorStream
                logHeader:('edit after resolving ', tmpFilename pathName, '.').
            result ifFalse:[
                ^ false
            ].

            "write my result"
            resultSource notNil ifTrue:[
                s := tmpFilename writeStream.
                s nextPutAll:resultSource.
                s close.
            ].
        ].
    ].
    ^true
!

releaseWorkSpace

    temporaryWorkSpace notNil ifTrue:[
        temporaryWorkSpace deleteWorkSpaceFromServer.   
    ].
    tempDirectory notNil ifTrue:[
        tempDirectory recursiveRemove.
    ].
!

revisionLogOf:clsOrNil 
        fromRevision:firstRev toRevision:lastRef numberOfRevisions:numRevisions 
        fileName:classFileName directory:packageDir module:aPackage

    "actually do return a revisionLog. The main worker method."

    |atEnd line inHeaderInfo info record revisionRecords headerOnly msg revArg infoAndLogString elements 
     foundView outputStream errorStream inStream packagePath fullFilename depotPath perforceCommand result labelLineElements tags label revision|

    [
        revArg := ''.
        headerOnly := false.
        (firstRev notNil or:[lastRef notNil]) ifTrue:[
            (firstRev == 0 and:[lastRef == 0]) ifTrue:[
                headerOnly := true.
            ]
        ].
        foundView := self getViewForPackage:aPackage.
        headerOnly ifTrue:[
            msg := 'fetching revision info '
        ] ifFalse:[
            msg := 'reading revision log '
        ].
        clsOrNil isNil ifTrue:[
            foundView notNil ifTrue:[            
                msg := msg , 'in ', foundView local.
            ].
        ] ifFalse:[
            msg := msg , 'of ', clsOrNil name.
        ].
        self activityNotification:msg,'...'.
        packagePath := Smalltalk getPackageDirectoryForPackage:aPackage.
        fullFilename := (packagePath construct:packageDir) construct:classFileName.
        depotPath := foundView getDepotPathForLocalPath:fullFilename pathName.
        perforceCommand := ('filelog "' , depotPath, '"').
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := self executePerforceCommand:perforceCommand inDirectory:self root 
            inputFrom:nil outputTo:outputStream 
            errorTo:errorStream
            logHeader:('getting filelog ', depotPath, '.').
        result ifFalse:[
            ^ nil
        ].

        "/
        "/ read the commands pipe output and extract the container info
        "/
        info := IdentityDictionary new.
        inHeaderInfo := true.
        revisionRecords := OrderedCollection new.
        info at:#revisions put:revisionRecords.
        inStream := ReadStream on:(outputStream contents).
        [inHeaderInfo and:[inStream atEnd not]] whileTrue:[
            line:= inStream nextLine.
            line notNil ifTrue:[
                |gotIt|

                gotIt := false.
                infoAndLogString := line asCollectionOfSubstringsSeparatedBy:$'.
                elements := infoAndLogString size.
                elements > 1 ifTrue:[
                    record := self readRevisionLogEntryFromString:line.
                    ((record at:#state ifAbsent:'') = 'delete') ifTrue:[
                        info at:#newestRevision put:#deleted.
                    ] ifFalse:[
                        info at:#newestRevision put:(record at:#revision).
                    ].
                    info at:#numberOfRevisions put:((record at:#revision) asNumber).
                    revisionRecords add:record.
                    inHeaderInfo := false
                ].
            ]
        ].

        info isEmpty ifTrue:[
            ('PerforceSourceCodeManager [warning]: no log for ', depotPath) errorPrintCR.
            ^ nil
        ].

        "/ strip selected revisions from the total-revisions entry
        headerOnly ifFalse:[
            "/
            "/ continue to read the commands pipe output
            "/ and extract revision info records
            "/
            atEnd := false.
            [atEnd or:[inStream atEnd]] whileFalse:[
                record := self readRevisionLogEntryFromStream:inStream.
                record isNil ifTrue:[
                    atEnd := true.
                ] ifFalse:[
                    revisionRecords add:record.
                ].
                (numRevisions notNil and:[revisionRecords size >= numRevisions]) ifTrue:[
                    atEnd := true
                ]
            ].
        ].
    ] ensure:[
        outputStream notNil ifTrue:[outputStream close].
        self activityNotification:nil.
    ].
    perforceCommand := ('labels "' , depotPath, '"').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self executePerforceCommand:perforceCommand inDirectory:self root 
        inputFrom:nil outputTo:outputStream 
        errorTo:errorStream
        logHeader:('getting labels ', depotPath, '.').
    result ifFalse:[
        ^ nil
    ].
    inStream := ReadStream on:(outputStream contents).
    tags := Dictionary new.
    [inStream atEnd not] whileTrue:[
        line:= inStream nextLine.
        line notEmptyOrNil ifTrue:[
            labelLineElements := line asCollectionOfWords.
            elements := labelLineElements size.
            elements > 1 ifTrue:[
                label := labelLineElements second withoutSeparators.
                revision := self getRevisionForLabel:label depotPath:depotPath.
                tags at:(labelLineElements second withoutSeparators) put:revision.
            ].
        ]
    ].
    info at:#symbolicNames put:tags.

    ^ info

    "Modified: / 28-06-2016 / 07:54:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSymbolicName:symbolicNameArg revision:rev overWrite:overWriteBool pathes:pathsInRepository
    "set a symbolicName for revision rev.
     If rev is nil, set it for the head (most recent) revision.
     If rev is 0, delete the symbolic name.
     If overWriteBool is true, the symbolicName will be changed, even if it has already been set.
     If overWriteBool is false, an error will be raised if symbolicName has already been set.

     If filename is nil, the symbolicName for a whole package is set.
     If multiple paths are given, the revision MUST be nil."

    |argumentString result errorStream moduleDirs symbolicName perforceCommand outputStream|

    symbolicName := (symbolicNameArg includes:Character space)
                        ifTrue:[ '"',symbolicNameArg,'"' ]
                        ifFalse:[ symbolicNameArg ].

    pathsInRepository size > 1 ifTrue:[
        self assert:(rev isNil or:[rev == 0]) "revision must be nil (for head) or 0 (for delete) with multiple paths"
    ].

    moduleDirs := pathsInRepository
                    collect:[:pathInRepository |
                        (pathInRepository asCollectionOfSubstringsSeparatedByAny:'/\') first.
                    ].
    moduleDirs do:[:moduleDir |
        |pathsInModule pathsInModuleAsArgument|

        pathsInModule := pathsInRepository
                    select:[:pathInRepository |
                        |moduleOfThisPath|

                        moduleOfThisPath := (pathInRepository asCollectionOfSubstringsSeparatedByAny:'/\') first.
                        moduleOfThisPath = moduleDir
                    ].

        rev = 0 ifTrue:[
            argumentString := ' -d '.
        ] ifFalse:[
            argumentString := ' -r ', (rev ? 'HEAD').
            overWriteBool ifTrue:[
                argumentString := argumentString, ' -F'
            ].
        ].

        pathsInModuleAsArgument := pathsInModule
                                        collect:[:eachPath |
                                            (eachPath includes:Character space) ifTrue:[
                                                '"',eachPath,'"'
                                            ] ifFalse:[
                                                eachPath
                                            ].
                                        ].
        pathsInModuleAsArgument := pathsInModuleAsArgument asStringCollection asStringWith:Character space.

        self activityNotification:'setting symbolic name for: ', pathsInModuleAsArgument.

        self information:'Implementation not finished yet'.
        ^self.

        perforceCommand := ('label "' , pathsInRepository, '"').
        outputStream := ReadWriteStream on:''.
        errorStream := ReadWriteStream on:''.
        result := self executePerforceCommand:perforceCommand inDirectory:self root
            inputFrom:nil outputTo:outputStream
            errorTo:errorStream
            logHeader:('set label ', pathsInRepository, '.').
        result ifFalse:[
            ^ nil
        ].
    ].

    "
     self setSymbolicName:'stable' revision:nil overWrite:false path:'stx/libbasic/Array.st'
     self setSymbolicName:'stable' revision:nil overWrite:true path:'stx/libbasic/Array.st'

     self
        setSymbolicName:'test1'
        revision:nil
        overWrite:true
        path:'bosch/dapasx/datenbasis/DAPASX__HierarchicalList.st'

     self
        setSymbolicName:'test2'
        revision:nil
        overWrite:true
        pathes:#( 'bosch/dapasx/datenbasis/DAPASX__HierarchicalList.st'
                  'bosch/dapasx/datenbasis/DAPASX__ProjectSearch.st' )

     self
        setSymbolicName:'test2'
        revision:0
        overWrite:true
        pathes:#( 'bosch/dapasx/datenbasis/DAPASX__HierarchicalList.st'
                  'bosch/dapasx/datenbasis/DAPASX__ProjectSearch.st' )
    "

    "Created: / 12-09-2006 / 12:36:44 / cg"
!

streamFor:checkInDefinition revision:revision cache:doCache
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    |cacheIt cacheDir classFileName fullName cachedSourceFilename cacheSubDir cachedFile tempdir checkoutName
     checkoutNameLocal revMsg fullTempName fullCachedName stream tempFile outStream
     line modulDir lineNr result outputStream errorStream inStream cls module packageDir packagePath fullFilename perforceCommand|

    cacheIt := doCache.
    (cacheIt and:[revision ~~ #newest and:[revision notNil]]) ifTrue:[
        (cacheDir := PerforceSourceCodeManager sourceCacheDirectory) isNil ifTrue:[
            'PerforceSourceCodeManager [warning]: no source cache directory' errorPrintCR.
        ]
    ].
    self getTemporaryWorkspaceFor:checkInDefinition.
    cls := checkInDefinition definitionClass.
    classFileName := checkInDefinition fileName.
    classFileName isNil ifTrue:[classFileName := cls classBaseFilename].

    (classFileName endsWith:',v') ifTrue:[
        classFileName := classFileName copyButLast:2.
    ].
    (classFileName endsWith:'.st') ifTrue:[
        cls notNil ifTrue:[
            classFileName := classFileName copyButLast:3.
        ]
    ].
    module :=  checkInDefinition package.
    packageDir := checkInDefinition packageDir.
    fullName := module , '/' , packageDir , '/' , classFileName.
    cls notNil ifTrue:[
        fullName := fullName , '.st'.
    ].

    (revision isNil or:[revision == #newest]) ifTrue:[
        cachedSourceFilename := classFileName, '_p4'.
        revMsg := ''.
    ] ifFalse:[
        cachedSourceFilename := classFileName , '_p4_' , revision.
        revMsg := ' (' , revision , ')'.
    ].                                               

    cacheDir notNil ifTrue:[
        cacheSubDir := cacheDir construct:module.
        cacheSubDir := cacheSubDir construct:packageDir.
        cachedFile := cacheSubDir construct:cachedSourceFilename.
        cachedFile exists ifTrue:[
            ^ cachedFile readStream
        ].
    ].

    "/
    "/ first, create a temporary work tree
    "/ Do not make module and package directories, their existence cause cvs checkout to fail in server mode
    "/
    tempdir := self tempDirectory.


    "/
    "/ check it out there
    "/
    checkoutName :=  fullName.

    modulDir := module asFilename construct:packageDir.
    checkoutNameLocal := modulDir constructString:(fullName asFilename baseName).

    self activityNotification:'checking out source ' , checkoutName , revMsg.

    packagePath := Smalltalk getPackageDirectoryForPackage:checkInDefinition package.
    fullFilename := (packagePath construct:checkInDefinition packageDir) construct:checkInDefinition fileName.
    fullTempName := self getTemporaryFilenameFor:fullFilename pathName.

    perforceCommand := ('print "' , fullFilename pathName, '#', revision, '"').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self executePerforceCommand:perforceCommand inDirectory:self root 
        inputFrom:nil outputTo:outputStream 
        errorTo:errorStream
        logHeader:('get contents of ', fullFilename pathName, ' for revision ', revision, '.').
    result ifFalse:[
        ^ nil
    ].
    errorStream contents notEmpty ifTrue:[
        ^nil
    ].
    FileStream openErrorSignal handle:[:ex|
        ('PerforceSourceCodeManager [error]: can not create ', fullTempName pathName) errorPrintCR.
        ^ nil.
    ] do:[
        fullTempName directory recursiveMakeDirectory.
        outStream := fullTempName writeStream.
    ].
    lineNr := 1.
    inStream := ReadStream on:(outputStream contents).
    [inStream atEnd not] whileTrue:[
        line:= inStream nextLine.
        line notNil ifTrue:[
            lineNr = 1 ifTrue:[
            ] ifFalse:[
                outStream nextPutLine:line.
            ].
        ].
        lineNr := lineNr + 1.
    ].
    outStream close.

    (cacheSubDir isNil) ifTrue:[
        cacheIt := false
    ] ifFalse:[
        cacheSubDir recursiveMakeDirectory.
        fullCachedName := cacheSubDir constructString:cachedSourceFilename.
    ].
    (cacheIt
    and:[cachedFile notNil
    and:[fullTempName exists]])
    ifTrue:[
        (OsError catch:[
            fullTempName moveTo:fullCachedName
        ]) ifTrue:[
            ('PerforceSourceCodeManager [error]: failed to rename ', fullTempName pathName, ' to ', cachedSourceFilename) errorPrintCR.
            ^ nil
        ].
        fullCachedName asFilename exists ifTrue:[
            stream := fullCachedName asFilename readStream.
        ].
    ] ifFalse:[
        checkInDefinition fileName = 'extensions.st' ifTrue:[
            self activityNotification:'Not cached - please check your settings and/or the version method in the projectDefinition.'.
        ] ifFalse:[
            self activityNotification:'Not cached - please check your settings.'.
        ].
        OperatingSystem isUNIXlike ifFalse:[
            "/ cannot remove files which are still open ...
            "/ sigh - need a delete-on-close flag in FileStream.
            "/
            tempFile := Filename newTemporary.
            fullTempName copyTo:tempFile.
            stream := tempFile readStream.
            stream notNil ifTrue:[
                stream removeOnClose:true.
            ].
        ] ifTrue:[
            stream := fullTempName readStream.
        ]
    ].

    ^ stream

    "Modified: / 28-06-2016 / 07:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

submit

    |numbers|

    numbers := self getCurrentChangeListNumbers.
    numbers isEmptyOrNil ifTrue:[
        ^false
    ].
    numbers do:[:aNumber|
        (self submitChangeNumber:aNumber) ifFalse:[
            ^false
        ].
    ].
    ^true
!

submitChangeNumber:changeNumber

    |cmd outputStream errorStream result changeListDescription infoDialog logMsg|


    self temporaryWorkSpace isNil ifTrue:[
	self perforceError raiseErrorString:('Error getting temporary workspace when try to submot ', changeNumber printString, '.').
	^false.
    ].
    changeListDescription := self getChangeDespriptionInfoFor:changeNumber printString.
    infoDialog := PerforceSourceCodeManager submitInfoDialogClass
	    getCheckinInfoFor:'Perforce submit message check'
	    initialAnswer:((changeListDescription at:#Description ifAbsent:'') copy)
	    withFileList:(changeListDescription at:#Files ifAbsent:'').
    infoDialog notNil ifTrue:[
	logMsg := infoDialog logMessage.
	(changeListDescription at:#Description ifAbsent:'') ~= logMsg asStringCollection ifTrue:[
	    self changeChangeDescriptionTo:logMsg asStringCollection changeNumber:changeNumber printString
	].
    ].
    cmd := ('submit -c ', changeNumber printString).
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self temporaryWorkSpace executePerforceCommand:cmd
			inDirectory:self tempDirectory
			inputFrom:nil
			outputTo:outputStream
			errorTo:errorStream
			doLog:false.
    result ifFalse:[
	result := self mergeOrResolveConflictsForChangeNumber:changeNumber.
	result ifTrue:[
	    cmd := ('submit -c ', changeNumber printString).
	    outputStream := ReadWriteStream on:''.
	    errorStream := ReadWriteStream on:''.
	    result := self temporaryWorkSpace executePerforceCommand:cmd
				inDirectory:self tempDirectory
				inputFrom:nil
				outputTo:outputStream
				errorTo:errorStream
				logHeader:('submit change ', changeNumber printString, ' after resolve.').
	    result ifFalse:[
		^ false
	    ].
	].
    ].
    ^true
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'basic administration'!

initialRevisionInfo:checkInDefinition
    "return a string usable as initial revision string"

    |version workSpace foundView packagePath fullFilename depotPath|

    checkInDefinition definitionClass isPrivate ifTrue:[
        PerforceSourceCodeManager reportError:'refuse to get revision for private classes.'.
        ^ nil.
    ].

    "/
    "/ first, create a temporary work tree
    "/
"/    tempdir := checkInDefinition tempDirectory.


    workSpace := PerforceSourceCodeManager getWorkSpaceForPackage:(checkInDefinition packageString).
    workSpace isNil ifTrue:[
        ('PerforceSourceCodeManager [error]: failed to create workspace for', checkInDefinition definitionObjectString)  errorPrintCR.
        ^ nil
    ].
    checkInDefinition workSpace:workSpace.
    version := PerforceSourceCodeManager versionInfoClass new.
    foundView := workSpace getViewForPackage:checkInDefinition package.
    packagePath := Smalltalk getPackageDirectoryForPackage:checkInDefinition package.
    fullFilename := (packagePath construct:checkInDefinition packageDir) construct:checkInDefinition fileName.
    depotPath := foundView getDepotPathForLocalPath:fullFilename pathName.

    version repositoryPathName:depotPath.
    version user:workSpace owner.
"
    s := CharacterWriteStream on:(String basicNew:40).    
    Date today printOn:s format:'%d-%m-%y' language:nil.
    version date:s contents.
    s := CharacterWriteStream on:(String basicNew:40).    
    Timestamp now printOn:s format:'%h-%m-%s.%i'.
    version time:s contents.
"
    version revision:'1'.
    ^ version.

"
self initialRevisionStringFor:RTDBInspectorStartup inModule:'applistx' directory:'util/rtdb' container:'RTDBInterfaceInspector.st'
"

    "Modified: / 28-06-2016 / 07:54:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialRevisionStringFor:checkInDefinition
    "return a string usable as initial revision string"

    |info|

    info := self initialRevisionInfo:checkInDefinition.
    info notNil ifTrue:[
        ^info getVersionString
    ].
    ^nil
"
self initialRevisionStringFor:RTDBInspectorStartup inModule:'applistx' directory:'util/rtdb' container:'RTDBInterfaceInspector.st'
"
!

nextRevisionStringFor:checkInDefinition

    |versionInfo s newestRevisionNumber versionMethod versionString|

    versionMethod := checkInDefinition definitionClass findVersionMethodOfManager:PerforceSourceCodeManager.
    versionMethod notNil ifTrue:[
        versionString := (versionMethod valueWithReceiver:(checkInDefinition definitionClass theNonMetaclass) arguments:#()).
        versionString notNil ifTrue:[
            versionInfo := PerforceSourceCodeManager versionInfoClass fromRCSString:versionString.
        ].
    ].
    versionInfo isNil ifTrue:[
        versionInfo := self initialRevisionInfo:checkInDefinition.
    ] ifFalse:[
        versionInfo user:checkInDefinition workSpace owner.
        s := CharacterWriteStream on:(String basicNew:40).    
        Date today printOn:s format:'%d-%m-%y' language:nil.
        versionInfo date:s contents.
        s := CharacterWriteStream on:(String basicNew:40).    
        Timestamp now printOn:s format:'%h-%m-%s.%i'.
        versionInfo time:s contents.
    ].
    versionInfo isNil ifTrue:[
        ^nil.
    ].
    newestRevisionNumber := checkInDefinition getReposRevisionNumberBeforeCheckin.
    newestRevisionNumber isNil ifTrue:[
        ^nil.
    ].
    versionInfo revision:((newestRevisionNumber + 1) printString).
    ^versionInfo getVersionString
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'command execution'!

executePerforceCommand:perforceCommand inDirectory:dirArg 
        inputFrom:inputStream outputTo:outputStream 
        errorTo:errorStream 
    "execute command and prepend perforce command name and global options.
     execute command in the dirArg directory.
     The doLog argument, if false supresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    ^self executePerforceCommand:perforceCommand inDirectory:dirArg 
        inputFrom:inputStream outputTo:outputStream 
        errorTo:errorStream
        doLog:true
!

executePerforceCommand:perforceCommand inDirectory:dirArg 
        inputFrom:inputStream outputTo:outputStream 
        errorTo:errorStream
        doLog:doLog
    "execute command and prepend perforce command name and global options.
     execute command in the dirArg directory.
     The doLog argument, if false supresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    ^self executePerforceCommand:perforceCommand inDirectory:dirArg 
            inputFrom:inputStream outputTo:outputStream 
            errorTo:errorStream
            doLog:doLog
            logHeader:nil
!

executePerforceCommand:perforceCommand inDirectory:dirArg 
        inputFrom:inputStream outputTo:outputStream 
        errorTo:errorStream
        doLog:doLog
        logHeader:logHeader
    "execute command and prepend perforce command name and global options.
     execute command in the dirArg directory.
     The doLog argument, if false supresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    |command rslt pathOfDir errorString  timeout errorMsgStream executeStream|

    dirArg notNil ifTrue:[
        pathOfDir := dirArg asFilename pathName.
    ].

    command := self getCommandOptionsForCommand:perforceCommand.
    Processor isDispatching ifFalse:[
        rslt := OperatingSystem executeCommand:command
                        inputFrom:inputStream
                        outputTo:outputStream
                        errorTo:errorStream
                        auxFrom:nil
                        inDirectory:pathOfDir
                        lineWise:true
                        onError:[:status| false].
    ] ifTrue:[
        PerforceCommandSemaphore critical:[
            |p |

            p := [
                rslt := OperatingSystem executeCommand:command
                                inputFrom:inputStream
                                outputTo:outputStream
                                errorTo:errorStream
                                auxFrom:nil
                                inDirectory:pathOfDir
                                lineWise:true
                                onError:[:status| false].
            ] fork.

            timeout := (p waitUntilTerminatedWithTimeout:300). 
            timeout ifTrue:[
                ('PerforceSourceCodeManager [info]: command timeout: ' , command) errorPrintCR.
                rslt := false.
                errorString := 'Perforce command timeout'.
            ] ifFalse:[
                rslt ifFalse:[
                    errorString := ('PerforceSourceCodeManager [info]: command failed: ' , command).
                ].
            ].
        ].
    ].

    PerforceSourceCodeManager verboseSourceCodeAccess == true ifTrue:[
        executeStream := WriteStream on:''.
        executeStream nextPutAll:Timestamp now printString.
        executeStream cr.
        executeStream nextPutAll:('Command <', command, '>').
        executeStream cr.
        executeStream nextPutAll:('StdErr Output: <', errorStream contents, '>').
        executeStream cr.
        executeStream nextPutAll:('StdOut Output: <', outputStream contents, '>').
        executeStream cr.
        executeStream nextPutAll:('##############################').
        Transcript showCR:executeStream contents.
    ].
    rslt ifFalse:[
        doLog ifTrue:[
            errorMsgStream := WriteStream on:''.
            logHeader notNil ifTrue:[
                errorMsgStream nextPutAll:'Error '.
                errorMsgStream nextPutAll:logHeader.
                errorMsgStream cr.
            ].
            timeout ifTrue:[
                errorMsgStream nextPutAll:('Timeout command <', command, '>').
                errorMsgStream cr.
            ] ifFalse:[
                errorMsgStream nextPutAll:('Command <', command, '>').
                errorMsgStream cr.
                errorMsgStream nextPutAll:('Error output: ', errorStream contents).
                outputStream contents notEmpty ifTrue:[
                    errorMsgStream nextPutAll:('Output: ', outputStream contents).
                ].
            ].
            self perforceError raiseErrorString:errorMsgStream contents.
            SourceCodeManagerError isHandled ifTrue:[
                SourceCodeManagerError raiseErrorString:errorMsgStream contents.
            ].
        ].
    ].
    ^ rslt.
!

executePerforceCommand:perforceCommand inDirectory:dirArg 
        inputFrom:inputStream outputTo:outputStream 
        errorTo:errorStream 
        logHeader:logHeader
    "execute command and prepend perforce command name and global options.
     execute command in the dirArg directory.
     The doLog argument, if false supresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    ^self executePerforceCommand:perforceCommand inDirectory:dirArg 
        inputFrom:inputStream outputTo:outputStream 
        errorTo:errorStream
        doLog:true
        logHeader:logHeader.
!

getCommandOptionsForCommand:perforceCommand

    |commandStream executable port user password clientString|

    commandStream := WriteStream on:''.
    executable := PerforceSourceCodeManager perforceExecutable.
    (executable includes:Character space) ifTrue:[
        commandStream nextPut:$".
        commandStream nextPutAll:executable.
        commandStream nextPut:$".
    ] ifFalse:[
        commandStream nextPutAll:executable.
    ].
    commandStream space.
    port := self perforceSettings at:#port ifAbsent:nil.
    port notNil ifTrue:[
        commandStream space.
        commandStream nextPutAll:'-p '.
        commandStream nextPutAll:port.
        commandStream space.
    ].
    clientString := self perforceSettings at:#client ifAbsent:nil.
    clientString notNil ifTrue:[
        commandStream space.
        commandStream nextPutAll:'-c '.
        commandStream nextPutAll:clientString.
        commandStream space.
    ].
    user := self perforceSettings at:#user ifAbsent:nil.
    user notNil ifTrue:[
        commandStream space.
        commandStream nextPutAll:'-u '.
        commandStream nextPutAll:user.
        commandStream space.
    ].
    password := self perforceSettings at:#password ifAbsent:nil.
    password notNil ifTrue:[
        commandStream space.
        commandStream nextPutAll:'-P '.
        commandStream nextPutAll:password.
        commandStream space.
    ].
    commandStream nextPutAll:perforceCommand.

    ^ commandStream contents.
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'dialogs & helpers'!

checkinTroubleDialog:title message:message log:log abortable:abortable option:optionTitle
    "trouble checking in - open a dialog"

    ^ self
        checkinTroubleDialog:title
        message:message
        log:log
        abortable:abortable
        option:optionTitle
        option2:nil

    "Created: 10.12.1995 / 17:34:33 / cg"
    "Modified: 12.9.1996 / 02:39:06 / cg"
!

checkinTroubleDialog:title message:message log:log abortable:abortable option:optionTitle option2:optionTitle2
    ^self
        checkinTroubleDialog:title
        message:message
        log:log
        abortable:abortable
        option:optionTitle
        option2:optionTitle2
        option3:nil
!

checkinTroubleDialog:title message:message log:log abortable:abortable option:optionTitle option2:optionTitle2 option3:optionTitle3
    "trouble checking in - open a dialog"

    |l box list listView optionPressed option2Pressed option3Pressed|

    l := log collect:[:line | line withTabsExpanded].
    list := SelectionInList with:l.

    box := Dialog new.
    box label:(title).

    (box addTextLabel:message) borderWidth:0.

    l asString notEmptyOrNil ifTrue:[
        listView := SelectionInListView on:list.
        listView disable.
        listView height:(listView heightOfContents max:250).
        box addComponent:(HVScrollableView forView:listView miniScrollerH:true) tabable:false.
        box addVerticalSpace.
    ].

    abortable ifTrue:[
        box addAbortButton
    ].
    optionTitle notNil ifTrue:[
        box addOkButton:(Button label:optionTitle action:[optionPressed := true. box hide]).
    ].
    optionTitle2 notNil ifTrue:[
        box addOkButton:(Button label:optionTitle2 action:[option2Pressed := true. box hide]).
    ].
    optionTitle3 notNil ifTrue:[
        box addOkButton:(Button label:optionTitle3 action:[option3Pressed := true. box hide]).
    ].
    box addOkButton.

    box extent:(box preferredExtent).
    box minExtent:box extent.
    box maxExtent:box extent.

    box open.
    box destroy.
    optionPressed == true ifTrue:[^ #option].
    option2Pressed == true ifTrue:[^ #option2].
    option3Pressed == true ifTrue:[^ #option3].
    ^ box accepted

"
| changesAsLogged |
changesAsLogged := OrderedCollection new.
1 to:10 do:[:each|
    changesAsLogged add:('Hallo', each printString).
].
changesAsLogged := OrderedCollection new.
self checkinTroubleDialog:'Version conflict'
             message:'Message Message Message Message Message Message Message Message Message Message Message Message Message Message'
             log:changesAsLogged
             abortable:false
             option:'show conflicts'
             option2:'resolve conflicts'
"
!

diffTextComment

    |ws|

    ws := WriteStream on:''.
    ws nextPutLine:'"/ ***************************************************************'.
    ws nextPutLine:'"/ This text contains your current versions code (blue)'.
    ws nextPutLine:'"/ merged with the conflicting code as found in the repository (red) which resulted'.
    ws nextPutLine:'"/ from some other checkin.'.
    ws nextPutLine:'"/ Each such conflict is surrounded by green text (like this paragraph).'.
    ws nextPutLine:'"/ '.
    ws nextPutLine:'"/ Please have a look at ALL the conflicts and fix things as appropriate.'.
    ws nextPutLine:'"/ Delete the green lines as a confirmation - I will not checkin the changed text,'.
    ws nextPutLine:'"/ unless no more green parts are present. This includes this comment at the top.'.
    ws nextPutLine:'"/ ***************************************************************'.
    ^ ws contents
!

getRevisionForLabel:label depotPath:depotPath


    |perforceCommand outputStream errorStream result inStream line depotAndRevision|

    perforceCommand := ('files "@' , label, '"').
    outputStream := ReadWriteStream on:''.
    errorStream := ReadWriteStream on:''.
    result := self executePerforceCommand:perforceCommand inDirectory:self root 
        inputFrom:nil outputTo:outputStream 
        errorTo:errorStream
        logHeader:('getting revision for label ', label, '.').
    result ifFalse:[
        ^ nil
    ].
    inStream := ReadStream on:(outputStream contents).
    [inStream atEnd not] whileTrue:[
        line:= inStream nextLine.
        line notEmptyOrNil ifTrue:[
            (line startsWith:depotPath) ifTrue:[
                depotAndRevision := line asCollectionOfWords first.
                depotAndRevision := depotAndRevision asCollectionOfSubstringsSeparatedBy:$#.
                ^ depotAndRevision second
            ].
        ].
    ].
    ^nil
!

messageForChangesInClass:class revision:revisionNumber

    |msgStream|

    msgStream := WriteStream on:''.
    msgStream nextPutAll:'The source of '; nextPutAll:class className; nextPutAll:'has been changed in the meanwhile as listed below.'.
    msgStream cr.
    msgStream nextPutAll:'If you continue, your new changes (based upon rev. '; nextPutAll:revisionNumber printString; nextPutAll:') will be MERGED'.
    msgStream nextPutAll:'into the newest revision. This will combine the other version with your changes'.
    msgStream nextPutAll:'into a new common revision which may be different from both.'.
    msgStream nextPutAll:'Although this is a nice feature, it may fail to create the expected result in certain situations.'.
    msgStream cr.
    msgStream nextPutAll:'You should carefully check the result - by comparing the current version with the'.
    msgStream nextPutAll:'most recent version in the repository. If that does not contain an acceptable version,'.
    msgStream nextPutAll:'change methods as required and check in again.'.
    msgStream nextPutAll:'Be aware, that after that, the actual repository version is different from your current classes,'.
    msgStream nextPutAll:'and you should update your class from the repository.'.
    msgStream cr.
    msgStream nextPutAll:'Continue ?'.
    ^ msgStream contents
!

messageForConflictsInClass:definitionClass revision:revisionNumber

    |msgStream|

    msgStream := WriteStream on:''.
    msgStream nextPutAll:'The source of '; nextPutAll:definitionClass className; nextPutAll:' has been changed in the meanwhile as listed below.'.
    msgStream cr.
    msgStream nextPutAll:'Your new changes (based upon rev. '; nextPutAll:revisionNumber printString; nextPutAll:') CONFLICT with those changes'.
    msgStream cr.
    msgStream nextPutAll:'You should fix things by comparing your class with the most recent repository version'.
    msgStream nextPutAll:'and change your methods avoiding conflicts. The checkin again.'.
    msgStream cr.
    ^ msgStream contents
!

messageForNoChangesInClass:class

    |msgStream|

    msgStream := WriteStream on:''.
    msgStream nextPutAll:'The source of '; nextPutAll:class className; nextPutAll:'has been changed in the meanwhile as listed below.'.
    msgStream cr.
    msgStream nextPutAll:'I have merged your version with the newest repository version,'.
    msgStream nextPutAll:'and found no differences between the result and your current version'.
    msgStream nextPutAll:'(i.e. your version seemed up-to-date).'.
    ^ msgStream contents
!

updatedRevisionStringOf:aClass forRevision:newRevision with:originalVersionString
    "update a revision string"

    |versionInfo packageID module foundView packagePath fullFilename depotPath sourceInfo classFileName|

    originalVersionString isEmptyOrNil ifTrue:[
        packageID := PackageId from:aClass package.
        module := packageID module.
        foundView := self getViewForPackage:module.
        packagePath := Smalltalk getPackageDirectoryForPackage:module.
        sourceInfo := PerforceSourceCodeManager sourceInfoOfClass:aClass.
        sourceInfo isNil ifTrue:[
            PerforceSourceCodeManager reportError:('no sourceInfo for class: ' , aClass name).
            ^ nil
        ].
        classFileName := PerforceSourceCodeManager containerFromSourceInfo:sourceInfo.
        fullFilename := (packagePath construct:packageID directory) construct:classFileName.
        depotPath := foundView getDepotPathForLocalPath:fullFilename pathName.

        versionInfo := PerforceSourceCodeManager versionInfoClass fromRepositoryPathName:depotPath.        
    ] ifFalse:[
        versionInfo := PerforceSourceCodeManager versionInfoClass fromRCSString:originalVersionString.
    ].
    versionInfo revision:newRevision printString.
    ^ versionInfo getVersionString.



"
    self updatedRevisionStringOf:nil
            forRevision:'6'
            with:'$','Header','$'
"

    "Modified: / 28-06-2016 / 07:53:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'initialization'!

initialize

    PerforceCommandSemaphore := Semaphore new:10.
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'queries'!

getDepotPathForLocalPath:aFilename
    |view|

    view := self getViewForPath:aFilename.
    view isNil ifTrue:[
        ^nil
    ].             
    ^view getDepotPathForLocalPath:aFilename
!

getLocalPathForDepotPath:depotPath

    |view|

    view := self getViewForDepotPath:depotPath.
    view notNil ifTrue:[
        ^view getLocalPathForDepotPath:depotPath.
    ].
    ^nil
"
     | workSpace tempWorkSpace |
    workSpace := PerforceSourceCodeManager getWorkSpaceForPackage:'applistx'.
    tempWorkSpace := workSpace temporaryWorkSpace.
    tempWorkSpace getLocalPathForDepotPath:'//depot/applistx/util/libDataType/ActionLQualifier.st'
"
!

getTemporaryFilenameFor:aFilename

    |myView checkInPart fullTempFilename|

    myView := self getViewForPath:aFilename.
    self temporaryWorkSpace isNil ifTrue:[
	self perforceError raiseErrorString:('Error getting temporary workspace when try to get temporaryFilename.').
	^nil.
    ].
    self temporaryWorkSpace views do:[:aView|
	myView depot = aView depot ifTrue:[
	    checkInPart := PerforceSourceCodeManager getTrailungPathNameFrom:aFilename with:myView localPathName.
	    fullTempFilename := aView localPathName asFilename construct:checkInPart.
	    ^fullTempFilename
	].
    ].
    ^nil
!

getTemporaryViewForPackage:aPackage

    |myView|

    myView := self getViewForPackage:aPackage.
    self temporaryWorkSpace isNil ifTrue:[
	self perforceError raiseErrorString:('Error getting temporary workspace when try to get temporary view').
	^nil.
    ].
    self temporaryWorkSpace views do:[:aView|
	myView depot = aView depot ifTrue:[
	    ^ aView
	].
    ].
!

getViewForDepotPath:depotPath

    |myHostName|

    myHostName := OperatingSystem getHostName.
    (myHostName endsWith:OperatingSystem getDomainName) ifTrue:[
        myHostName := myHostName copyTo:(myHostName size - (OperatingSystem getDomainName size + 1)).
    ].

    (myHostName asLowercase startsWith:(self host asLowercase)) ifFalse:[
        self perforceError raiseErrorString:('Client ', (perforceSettings at:#client), ' is made for host ', self host, ' and not for ', myHostName).
        ^ nil
    ].
    self views do:[:aView |
        (aView hasViewForDepotPath:depotPath) ifTrue:[
            ^aView
        ].
    ].
    self perforceError raiseErrorString:('Client ', (perforceSettings at:#client), ' have no View for depot path ', depotPath).
    ^ nil
!

getViewForPackage:aPackage 

    |locPackage packagePath|

    aPackage isNil ifTrue:[                              
        locPackage := Smalltalk package.
    ] ifFalse:[
        locPackage := aPackage.
    ].
    packagePath := self packageDirectoryForPackageId:locPackage.
    packagePath notNil ifTrue:[
        packagePath := packagePath pathName.
    ] ifFalse:[
        self perforceError raiseErrorString:('no package path for ', aPackage printString).
        ^nil
    ].
    ^self getViewForPath:packagePath

"
    PerforceSourceCodeManager perforceWorkspaces first value getViewForPackage:'applistx:application/rtdbInspector/builder'
"
!

getViewForPath:aPathName

    |myHostName|

    myHostName := OperatingSystem getHostName.
    (myHostName endsWith:OperatingSystem getDomainName) ifTrue:[
        myHostName := myHostName copyTo:(myHostName size - (OperatingSystem getDomainName size + 1)).
    ].

    (myHostName asLowercase startsWith:(self host asLowercase)) ifFalse:[
        self perforceError raiseErrorString:('Client ', (perforceSettings at:#client), ' is made for host ', self host, ' and not for ', myHostName).
        ^ nil
    ].
    self views do:[:aView |
        (aView hasViewForPath:aPathName) ifTrue:[
            ^aView
        ].
    ].
    self perforceError raiseErrorString:('Client ', (perforceSettings at:#client), ' have no View for path ', aPathName).
    ^ nil
!

hasViewForPackage:aPackage 

    ^(self getViewForPackage:aPackage) notNil
!

hasViewForPath:aPathName

    ^(self getViewForPath:aPathName) notNil
!

packageDirectoryForPackageId:package

    ^self packageDirectoryForPackageId:package checkParents:true

"
    PerforceSourceCodeManager perforceWorkspaces first value getViewForPackage:'applisddtx:application/rtdbInspector/builder'
"
!

packageDirectoryForPackageId:package checkParents:checkParents

    |locPackage packagePath|

    locPackage := package copyReplaceAll:$: with:$/.
    [ packagePath isNil ] whileTrue:[
        packagePath := Smalltalk getPackageDirectoryForPackage:locPackage.
        packagePath notNil ifTrue:[
            ^packagePath
        ].
        locPackage := locPackage asFilename directoryName.
    ].
    ^nil

"
    PerforceSourceCodeManager perforceWorkspaces first value getViewForPackage:'applisddtx:application/rtdbInspector/builder'
"

    "Modified: / 28-06-2016 / 07:54:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

perforceError

    ^ PerforceSourceCodeManager perforceError
!

perforceSettingsString

    ^ PerforceSourceCodeManager getStringFromPerforceSettings:self perforceSettings
!

readRevisionLogEntryFromStream:inStream
    "read and parse a single revision info-entry from the cvs log output.
     Return nil on end.

     The returned information is a structure (IdentityDictionary)
     filled with:
              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #logMessage            -> the checkIn log message
    "

    |revLine1 atEnd|

    atEnd := false.

    revLine1 := inStream nextLine.
    ^ self readRevisionLogEntryFromString:revLine1.
!

readRevisionLogEntryFromString:revLine1
    "read and parse a single revision info-entry from the cvs log output.
     Return nil on end.

     The returned information is a structure (IdentityDictionary)
     filled with:
              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #logMessage            -> the checkIn log message
    "

    | record revisionLineElements noOfRevisionLineElements posText|

    (revLine1 notNil) ifTrue:[
        record := IdentityDictionary new.
        revisionLineElements := revLine1 asCollectionOfWords.
        noOfRevisionLineElements := revisionLineElements size.
        noOfRevisionLineElements > 1 ifTrue:[
            record at:#revision put:((revisionLineElements at:2) copyFrom:2).
        ].
        noOfRevisionLineElements > 8 ifTrue:[
            record at:#author put:(revisionLineElements at:9).
        ].
        noOfRevisionLineElements > 6 ifTrue:[
            record at:#date put:(revisionLineElements at:7).
        ].
        noOfRevisionLineElements > 4 ifTrue:[
            record at:#state put:(revisionLineElements at:5).
        ].
        noOfRevisionLineElements > 10 ifTrue:[
            posText := 0.
            1 to:9 do:[:ele| posText := posText + (revisionLineElements at:ele) size + 1].
            record at:#logMessage put:(revLine1 copyFrom:posText).
        ].
    ].
    ^record.
!

temporaryClientName

    ^ 'stxCheckinWorkSpace_', self owner, self host.
! !

!PerforceSourceCodeManagerUtilities::WorkSpace methodsFor:'read'!

getDefinitionFromServer
    |cmd myBaseDirectory outputStream errorStream rslt clients inStream line words|

    cmd := 'clients -u ' , (self perforceSettings at:#user).
    myBaseDirectory := (Filename currentDirectory asAbsoluteFilename) pathName.
    outputStream := WriteStream on:''.
    errorStream := WriteStream on:''.
    rslt := self  
                executePerforceCommand:cmd
                inDirectory:myBaseDirectory
                inputFrom:nil
                outputTo:outputStream
                errorTo:errorStream
                logHeader:('getting workspaces ').
    rslt ifFalse:[
        self perforceError raiseErrorString:(outputStream contents, errorStream contents).
        ^false
    ].
    clients := OrderedCollection new.
    inStream := ReadStream on:(outputStream contents).
    [ inStream atEnd not ] whileTrue:[
        line := inStream nextLine.
        line notEmptyOrNil ifTrue:[
            words := line asCollectionOfWords.
            words size > 1 ifTrue:[
                clients add:(words at:2).
            ].
        ].
    ].
    (clients includes:(self perforceSettings at:#client ifAbsent:nil)) ifFalse:[
        self perforceError raiseErrorString:('No workspace ', (self perforceSettings at:#client ifAbsent:'?'), ' for user ', (self perforceSettings at:#user ifAbsent:'?'), ' on ', (self perforceSettings at:#port ifAbsent:'?'), ' available.').
    ].

    cmd := 'client -o'.
    myBaseDirectory := (Filename currentDirectory asAbsoluteFilename) pathName.
    outputStream reset.
    errorStream reset.
    rslt := self 
                executePerforceCommand:cmd
                inDirectory:myBaseDirectory
                inputFrom:nil
                outputTo:outputStream
                errorTo:errorStream
                logHeader:('getting empty workspace definition ').
    rslt ifFalse:[
        self perforceError raiseErrorString:(outputStream contents, errorStream contents).
        ^false
    ].
    inStream := ReadStream on:(outputStream contents).
    self getWorkSpaceFromClientSpecFrom:inStream.
    ^true

"
(PerforceSourceCodeManager getWorkSpaceForPackage:'applistx') getDefinitionFromServer
"
!

getWorkSpaceFromClientSpecFrom:inStream
    "
        get the workspace definition from perforce client command output
    "

    |line nextKey |

    [inStream atEnd not] whileTrue:[
        line:= inStream nextLine.
        line notEmptyOrNil ifTrue:[
                line first = $# ifFalse:[
                (line startsWith:'Owner:') ifTrue:[
                    self owner:line asCollectionOfWords second.
                ].
                (line startsWith:'Host:') ifTrue:[
                    self host:line asCollectionOfWords second.
                ].
                (line startsWith:'Client:') ifTrue:[
                    self client:(line asCollectionOfWords second).
                ].
                (line startsWith:'Root:') ifTrue:[
                    self root:((line copyFrom:('Root:' size + 1)) withoutLeadingSeparators).
                ].
                (line startsWith:'View:') ifTrue:[
                    nextKey := false.
                    [nextKey not and:[inStream atEnd not]] whileTrue:[
                        line:= inStream nextLine.
                        line notEmptyOrNil ifTrue:[
                            line first isSeparator ifTrue:[
                                self views add:(View newFromLine:line workspace:self).
                            ] ifFalse:[
                                nextKey := true.
                            ].
                        ].
                    ].
                ].
            ].
        ].
    ].
!

newWorkSpaceFor:settingsString 
    settingsString isNil ifTrue:[
        ^ nil
    ].
    self perforceSettings:(PerforceSourceCodeManager 
                getPerforceSettingsFromString:settingsString).
    self getDefinitionFromServer ifTrue:[
        ^self
    ].
    ^nil
!

newWorkSpaceForSettings:settingsDict 

    settingsDict isNil ifTrue:[
        self perforceError raiseErrorString:('nil settings when creating workspace').
        ^ self
    ].
    self perforceSettings:settingsDict.
! !

!PerforceSourceCodeManagerUtilities::WorkSpace::View class methodsFor:'instance creation'!

newFromLine:aLine workspace:aWorkspaceDefinition

    |instance|

    instance := self new.
    instance newFromLine:aLine.
    instance workspace:aWorkspaceDefinition.
    ^instance
! !

!PerforceSourceCodeManagerUtilities::WorkSpace::View methodsFor:'accessing'!

depot
    ^ depot
!

depot:something
    depot := something.
!

local
    ^ local
!

local:something
    local := something.
!

type

    " there special types for views 
      + for added to the same directory
      - exclude this view
        and standard view
    "

    ^ type
!

type:something
    type := something.
!

workspace
    ^ workspace
!

workspace:something
    workspace := something.
! !

!PerforceSourceCodeManagerUtilities::WorkSpace::View methodsFor:'queries'!

getDepotPathForLocalPath:aFilename
    |depotPath restPath unixRestPath|

    (self hasViewForPath:aFilename) ifFalse:[
        ^nil
    ].                     
    depotPath := depot.
    (depot endsWith:'...') ifTrue:[
        depotPath := depot copyTo:(depot size - 3).
    ] ifFalse:[
        depotPath := depot.
    ].
    restPath := PerforceSourceCodeManager getTrailungPathNameFrom:aFilename with:self localPathName.
    unixRestPath := (UnixFilename fromComponents:(restPath asFilename components)) pathName.
    depotPath := depotPath, unixRestPath.
    ^depotPath.
!

getLocalPathForDepotPath:depotPath
    |viewDepotPath restPath|

    (self hasViewForDepotPath:depotPath) ifFalse:[
        ^nil
    ].                     
    viewDepotPath := depot.
    (depot endsWith:'...') ifTrue:[
        viewDepotPath := depot copyTo:(depot size - 3).
    ] ifFalse:[
        viewDepotPath := depot.
    ].
    restPath := PerforceSourceCodeManager getTrailungPathNameFrom:depotPath with:viewDepotPath.
    ^ (self localPathName asFilename construct:restPath) pathName.
!

hasViewForDepotPath:depotPath

    |viewDepotPath|

    depotPath isEmptyOrNil ifTrue:[
        ^ false.
    ].
    viewDepotPath := depot.
    (depot endsWith:'...') ifTrue:[
        viewDepotPath := depot copyTo:(depot size - 3).
    ] ifFalse:[
        viewDepotPath := depot.
    ].
    (PerforceSourceCodeManager path:depotPath hasSamePrefixLikePath:viewDepotPath) ifFalse:[
        ^false
    ].
    ^true
!

hasViewForPath:aPathname

    aPathname isEmptyOrNil ifTrue:[
        ^ false.
    ].
    (PerforceSourceCodeManager path:aPathname hasSamePrefixLikePath:self localPathName) ifFalse:[
        ^false
    ].
    ^true
!

localPathName

    |indexOfClientString localPathName|

    (local endsWith:'...') ifTrue:[
        localPathName := local copyTo:(local size -3).
    ] ifFalse:[
        localPathName := local.
    ].
    indexOfClientString := local findString:workspace client.
    indexOfClientString == 0 ifTrue:[
        ^workspace root.
    ].
    localPathName := workspace root asFilename construct:(localPathName copyFrom:(indexOfClientString + workspace client size)).
    ^localPathName pathName 
! !

!PerforceSourceCodeManagerUtilities::WorkSpace::View methodsFor:'reading'!

newFromLine:aLine

    |words firstIndex secondIndex theLine|

    theLine := aLine withoutLeadingSeparators.
    theLine := theLine withoutTrailingSeparators.
    theLine isEmpty ifTrue:[
        ^self
    ].
    theLine first == $+ ifTrue:[
        type := #+.
        theLine := theLine copyFrom:2.
    ].
    theLine first == $- ifTrue:[
        type := #-.
        theLine := theLine copyFrom:2.
    ].
    (theLine includes:$") ifTrue:[
        "oops we have space directories search for quotes"

        firstIndex := theLine indexOf:$" startingAt:1.
        firstIndex == 1 ifTrue:[
            secondIndex := theLine indexOf:$" startingAt:firstIndex + 1.
            depot := theLine copyFrom:firstIndex + 1 to:secondIndex - 1.
            firstIndex := theLine indexOf:$" startingAt:secondIndex + 1.
            secondIndex := theLine indexOf:$" startingAt:firstIndex + 1.
            local := theLine copyFrom:firstIndex + 1  to:secondIndex - 1.
        ] ifFalse:[
            depot := (theLine copyTo:firstIndex - 1) withoutTrailingSeparators.            
            local := theLine copyFrom:firstIndex + 1 to:(theLine size - 1).
        ].
    ] ifFalse:[
        words := theLine asCollectionOfWords.
        depot := words first.
        local := words second.
    ].

"
    View newFromLine:ws contents.
"
! !

!PerforceSourceCodeManagerUtilities class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

