"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ToolApplicationModel subclass:#AbstractLauncherApplication
	instanceVariableNames:'transcript'
	classVariableNames:'NotifyingEmergencyHandler OpenLaunchers RegisteredMenuHandlers
		OpenSettingsDialog SettingsList UserSettingsList
		LastSettingsPageName'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

Object subclass:#LauncherDialogs
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractLauncherApplication
!

ApplicationModel subclass:#PackageLoadDialog
	instanceVariableNames:'hierarchicalListView packageIdByItem pathByItem packageDirPath
		packageIcon greyPackageIcon folderIcon greyFolderIcon
		alreadyLoadedString applicationIcon greyApplicationIcon root
		itemsByPath getItemByPath myHierarchicalItemWithLabelAndIcon
		filterHolder masterRoot infoTextHolder loadButton
		loadAndBrowseButton selectedPackageHolder monticelloRoot
		backgroundPackageFindProcess itemsMatchingFilter'
	classVariableNames:'PreviousPackageDialogItems PreviousPackageDialogExtent'
	poolDictionaries:''
	privateIn:AbstractLauncherApplication
!

HierarchicalItemWithLabelAndIcon subclass:#MyHierarchicalItem
	instanceVariableNames:'type info'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractLauncherApplication::PackageLoadDialog
!

!AbstractLauncherApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
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
    This is an abstract class, providing mechanisms and common functionality
    for launcher-type applications. Subclasses may implement their GUI either
    with or without the UIPainter framework, and still use the common functions
    provided here.

    [author:]
        Claus Gittinger, eXept Software AG
"


! !

!AbstractLauncherApplication class methodsFor:'accessing'!

closeAllLaunchers
    "close all opened launchers"

    self openLaunchers copy do:[:eachLauncher |
        eachLauncher closeRequest
    ].

    "
     self closeAllLaunchers.
     NewLauncher open
    "
!

current
    "return the launcher running on the current screen.
     (for access via addMenu/ removeMenu)"

    |currentScreen|

    OpenLaunchers size > 0 ifTrue:[
        currentScreen := Screen current.
        ^ OpenLaunchers detect:[:eachLauncher | eachLauncher graphicsDevice == currentScreen] ifNone:nil
    ].
    ^ nil.

    "
     NewLauncher current
    "

    "Modified: / 9.9.1996 / 22:41:36 / stefan"
    "Modified: / 13.10.1998 / 16:09:50 / cg"
!

openLaunchers
    "return all opened launchers"

    OpenLaunchers isNil ifTrue:[
        OpenLaunchers := IdentitySet new
    ].
    ^ OpenLaunchers
! !

!AbstractLauncherApplication class methodsFor:'defaults'!

notifyingEmergencyHandler
    "return a block (used as an emergency handler
     for exceptions), which does errorNotification before going
     into the debugger."

    "Remember the handlerBlock, to be able to determine if the current
     handler is the notifying one."

    NotifyingEmergencyHandler isNil ifTrue:[
        NotifyingEmergencyHandler := NoHandlerError notifyingEmergencyHandler
    ].
    ^ NotifyingEmergencyHandler

    "Created: 7.1.1997 / 22:18:19 / cg"
    "Modified: 15.1.1997 / 21:15:38 / cg"
! !

!AbstractLauncherApplication class methodsFor:'image specs'!

communicationIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self communicationIcon inspect
     ImageEditor openOnClass:self andSelector:#communicationIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractLauncherApplication communicationIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@W%@@@@@@A^T@@@V2/@@@@@CKJ5@@V?!!>T@@@A[=W9PV?!!<R5@@A[=W1KVR<.S@$@@IC28UJ];?IR- @@7"<%>6NW?2/C&Y%)$/><$3A0/J$A@C$IAL*Y3^
;B*QF:''F_,J)G*"R(#G;8W(Y*"$S,)J(G4.CN2&*U@.[$(G5_K1)82U!!@K\86O=[*&93!!DD@)KP7G?>+9T-JPP@@DC\H>$+,@P+%@@@@%@6K(''0@3,@@@@AE
E9H";@3,@@@@@L5Z$"+,3,@@@@@@19"Z)H3,@@@@@@@L%=)F%<@@@@@@@@B.]H@@@@@@@@@@@@18@@@@@@@b') colorMapFromArray:#[0 0 0 148 148 148 224 224 224 52 52 52 128 128 128 180 180 180 32 32 32 84 84 84 160 160 160 64 64 64 212 212 212 116 116 116 192 192 192 20 20 20 96 96 96 244 244 244] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'G@C O G0_0O8?8_<?(W<?8_<???<=:^<???<???<???<_??<O??<O??<B?=\@?<8@?=0@?? @??@@_>@@O @@G@@'); yourself); yourself]
!

cross2Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self cross2Icon inspect
     ImageEditor openOnClass:self andSelector:#cross2Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractLauncherApplication cross2Icon'
        ifAbsentPut:[(Depth1Image width:32 height:32) bits:(ByteArray fromPackedString:'
@@@@@@@F0@@@@H@@@@@@@@@@0@@@@H@@@@@@@@@N<@@@LH0@@D@B@@B@8P@@ HD@@P@@ @D 0HIIIHBB[[X@@@@@[[YA@RRRPPLD @D@@H@@ PD@@H\A@@A@
@ @@LP0@@@=0@@@@@@@@@P@@@@L@@@@@@@@@@P@@@@M @@@@@@@b') colorMapFromArray:#[0 0 0 255 255 255] mask:((ImageMask width:32 height:32) bits:(ByteArray fromPackedString:'
@@_@@@@G0@@@@X@@@@G@@@@A0@@@@X@@@@?0@@@??@@@\X8@@LG#@@FA8X@A XF@@0G@0@M!!0LO[[XCC???????????C@[[[00NF0@LC L@A XF@@X^A @CG
 0@@\X8@@C?<@@@O<@@@@X@@@@N@@@@C @@@@X@@@@O @@@C8@@b'); yourself); yourself]
!

httpServerIcon
    <resource: #programImage>

    ^ AbstractSettingsApplication::HTTPStartServerSettingsApplication defaultIcon
!

systemBrowser24x24Icon
    <resource: #programImage>

    ^ ToolbarIconLibrary systemBrowser24x24Icon
! !

!AbstractLauncherApplication class methodsFor:'queries'!

isAbstract
    ^ self == AbstractLauncherApplication
! !

!AbstractLauncherApplication class methodsFor:'settings application list'!

addSettingsApplicationByClass:aClass withName:aName icon:anIcon

    | userSetList addItem|

    userSetList := self userSettingsList.
    addItem := Array with:aName with:aClass with:anIcon.

    "Ignore existing entries found in SettingsList for that name"
    (SettingsList ? #()) do:[:entry |
        entry first = aName ifTrue: [
            ('Settings named "%1" already exists in "%2" with settings app class "%3"' 
                bindWith:aName
                    with:self name printString
                    with:entry second
            ) infoPrintCR.
            ^ self
        ].    
    ].

    "/ remove existing entries in UserSettingsList for that name
    userSetList copy do:[:entry |
        entry first = aName ifTrue:[
            userSetList remove:entry.
        ]
    ].
    userSetList add:addItem.
    OpenSettingsDialog notNil ifTrue:[
        OpenSettingsDialog installSettingsEntry:addItem
    ].
!

allSettingsList
    ^ self settingsList, self userSettingsList
!

defaultSettingsApplicationList
    "/ cg: moved it to SettingsDialog - everyone is expecting it there and had to search it...
    "/ left here for backw. compatibility.

    ^ SettingsDialog defaultSettingsApplicationList
!

expandSettingsList:rawList
    "this expands a raw settings list,
     by looking for entries with a block in their class name.
     If any such is present, it is evaluated, returning
     a collection of actual entries to use. Then, also % entries in
     the name and icon are evaluated by sending corresponding messages
     to the collected classes.
     This allows for easy dynamic construction of more complicated
     lists, for example to adapt to the set of loaded classes dynamically."

    "I am not sure. if this is is a good idea; although it makes heavy use of
     Smalltalk's dynamic features, it is probably better done differently
     (letting the caller do this).
     The code here is harder to debug, and understand"
    
    |cookedList settingsList|

    cookedList := OrderedCollection new.

    rawList do:[:eachEntry|
        |treeName classNameOrBlock newEntry code classList name nameCode nameBlock nameList iconCode iconBlock|

        classNameOrBlock := eachEntry at:2 ifAbsent:nil.
        classNameOrBlock isBlock ifTrue:[
            classList := classNameOrBlock value select:[:clsOrNil | clsOrNil notNil].
            name := eachEntry at:1.
            self assert:(name includesString:'[').

            nameCode := name copyFrom:(name indexOf:$[)+1 to:(name indexOf:$])-1.
            nameCode := '^ [:each | ' , (nameCode copyReplaceString:'%' withString:'each') ,']'.
            nameBlock := Parser evaluate:nameCode.

            nameList := classList collect:nameBlock.
            nameList sortWith:classList.
            nameList with:classList do:[:eachName :eachClass |
                |newEntry|

                newEntry := eachEntry copy.
                newEntry at:1 put:(name copyTo:(name indexOf:$[)-1),eachName.
                newEntry at:2 put:eachClass name.
                cookedList add:newEntry.
            ].
        ] ifFalse:[
            (classNameOrBlock isNil "a directory entry"
            or:[ (Smalltalk at:classNameOrBlock) notNil "a valid entry"]) ifTrue:[
                cookedList add:eachEntry.
            ] ifFalse:[
                classNameOrBlock notNil ifTrue:[
                    Transcript showCR:'Launcher: missing settings class: ',classNameOrBlock.
                ].
            ].
        ].
    ].

    settingsList := 
        cookedList collect:[:eachEntry |
            |iconCodeOrSelector iconCode iconBlock newEntry|

            iconCodeOrSelector := eachEntry at:3 ifAbsent:nil.
            iconCodeOrSelector isNil ifTrue:[
                newEntry := eachEntry
            ] ifFalse:[
                newEntry := eachEntry copy.
                (iconCodeOrSelector startsWith:$[) ifTrue:[
                    iconCode := iconCodeOrSelector copyFrom:(iconCodeOrSelector indexOf:$[)+1 to:(iconCodeOrSelector indexOf:$])-1.
                    iconCode := '^ [:each | ' , (iconCode copyReplaceString:'%' withString:'each') ,']'.
                    iconBlock := Parser evaluate:iconCode.
                    newEntry at:3 put:(iconBlock value:(Smalltalk classNamed:(eachEntry at:2))).
                ] ifFalse:[
                    newEntry at:3 put:(self perform:iconCodeOrSelector).
                ].
            ].
            newEntry.
        ].

    ^ settingsList.

    "
     self withAllSubclassesDo:[:cls | cls initializeSettingsList ]
    "
!

initializeSettingsList
    SettingsList := self expandSettingsList:(self defaultSettingsApplicationList).
    ^ SettingsList.

    "
     self withAllSubclassesDo:[:cls | cls initializeSettingsList ]
    "

    "Modified: / 16-12-2002 / 18:12:50 / penk"
    "Modified: / 20-04-2011 / 17:03:33 / cg"
!

removeSettingsApplicationByClass:aClass

    | userSetList remItem|

    userSetList := self userSettingsList.
    remItem := userSetList detect:[:item| (item at:2) = aClass] ifNone:[nil].
    remItem notNil ifTrue:[
        userSetList remove:remItem.
        OpenSettingsDialog notNil ifTrue:[
            self removeSettingsEntry:remItem forSettingsApp:OpenSettingsDialog.
        ].
    ].
!

removeSettingsEntry:entry forSettingsApp:aSettingsApp

    |applName applClass|

    applName := entry at:1.
    applClass := entry at:2.
    aSettingsApp remApplClassByName:applName.
!

settingsList
    "/ do NOT cache SettingsList
    "/ use UserSettingsList to add settings from loaded libraries

    SettingsList := nil.
    SettingsList isNil ifTrue: [
        SettingsList := self initializeSettingsList
    ].
    ^ SettingsList

    "Modified: / 19-04-2011 / 12:08:17 / cg"
!

userSettingsList

    UserSettingsList isNil ifTrue: [
        UserSettingsList := OrderedCollection new.
    ].
    ^ UserSettingsList
! !

!AbstractLauncherApplication class methodsFor:'settings dialog'!

openSettings
    ^ self openSettingsFor: nil

    "Created: / 08-10-2014 / 23:42:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openSettingsAndSelect: selectedPageName
    ^ self openSettingsFor: nil andSelect: selectedPageName

    "Created: / 08-10-2014 / 23:43:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openSettingsFor: requestor
    ^ self openSettingsFor: requestor andSelect: LastSettingsPageName

    "Created: / 08-10-2014 / 23:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openSettingsFor: requestor andSelect: selectedPageName
    |settingsApp wg proc|

    OpenSettingsDialog notNil ifTrue:[
        (wg := OpenSettingsDialog windowGroup) notNil ifTrue:[
            (proc := wg process) notNil ifTrue:[
                proc isDead ifFalse:[
                    OpenSettingsDialog window raiseDeiconified.
                    ^ self.
                ]
            ]
        ].
        OpenSettingsDialog := nil.
    ].

    settingsApp := SettingsDialog new.
    settingsApp resources:(AbstractLauncherApplication resources).
    settingsApp requestor:requestor.
    settingsApp installSettingsEntries:(self allSettingsList).
    "/ settingsApp requestor:self.
    OpenSettingsDialog := settingsApp.
    settingsApp allButOpen.
    "/ settingsApp showNonDefaultSettingsMenuItemVisibleHolder value:true.
    settingsApp window label:(self classResources string:'ST/X Settings').
    settingsApp openWindow.

    selectedPageName notNil ifTrue:[
        settingsApp selectItemWithName:selectedPageName
    ].

    "Created: / 08-10-2014 / 23:42:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractLauncherApplication class methodsFor:'utilities'!

openLoadPackageDialog
    "open a dialog showing wellknown packages (listed in the packages directory)
     and offer to load the selected one(s).
     TODO: make this a little app instead of an ad-hoc dialog, 
     add remote packages (central goody repository?)"    

    PackageLoadDialog open
! !

!AbstractLauncherApplication methodsFor:'drag & drop'!

canDropObjects:aCollectionOfDropObjects
    "Any object can be dropped into workspace..."

    ^ aCollectionOfDropObjects
        contains:[:someObject| (someObject isTextObject or:[ someObject isFileObject ])].
!

dropFileObject:aFilename
    |suffix|

    suffix := aFilename asFilename suffix.
    suffix = 'st' ifTrue:[
        ChangesBrowser openOn:aFilename.
        ^ self.
    ].
    UserPreferences fileBrowserClass openOn:aFilename.

!

dropObjects:aCollectionOfObjects
    "Any object can be dropped:
        text: open a workspace
        file:
            .st - open a cange-browser
            other - open a fileBrowser
    "

    aCollectionOfObjects do:[:dropObject|
        |theObject|

        theObject := dropObject theObject.
        dropObject isTextObject ifTrue:[
            self dropTextObject:theObject
        ] ifFalse:[
            dropObject isFileObject ifTrue:[
                self dropFileObject:theObject
            ] ifFalse:[
            ].
        ].
    ].
!

dropTextObject:aDropContext
    WorkspaceApplication openWith:aDropContext.
! !

!AbstractLauncherApplication methodsFor:'menu actions - tools'!

clearAllCoverageInfo
    "clear all coverage information"

    self withWaitCursorDo:[
        InstrumentedMethod cleanAllInfoWithChange:false
    ].
    Smalltalk changed:#coverageInfo.
!

startSUnitTestRunner2
    "open the SUnit test runner"

    self openApplication:#Tools::TestRunner2
! !

!AbstractLauncherApplication methodsFor:'oldStyle-user actions-settings'!

communicationsSettings
    "open a dialog on misc other settings"

    self settingsDialog:[:handler | handler communicationsSettings]

    "Modified: / 31.7.1998 / 22:46:56 / cg"
!

compilerSettings
    "open a dialog on compiler related settings"

    self settingsDialog:[:handler | handler compilerSettings]
!

displaySettings
    "open a dialog on display related settings"

    self settingsDialog:[:handler | handler displaySettings]

    "Modified: / 31.7.1998 / 22:45:38 / cg"
!

editSettings
    "open a dialog on edit settings"

    self settingsDialog:[:handler | handler editSettings]

    "Modified: / 31.7.1998 / 22:46:56 / cg"
    "Created: / 6.1.1999 / 14:14:48 / cg"
!

fontSettings
    "open a dialog on font related settings"

    self settingsDialog:[:handler | handler fontSettingsFor:self]

    "Modified: / 31.7.1998 / 22:45:44 / cg"
!

javaSettings
    "open a dialog on java-subsystem related settings"

    self settingsDialog:[:handler | handler javaSettings]

    "Modified: / 31.7.1998 / 22:46:13 / cg"
!

keyboardSetting
    "open a dialog on keyboard related settings"

    self settingsDialog:[:handler | handler keyboardSettings]

    "Modified: / 31.7.1998 / 22:45:56 / cg"
!

languageSetting
    "open a dialog on language related settings"

    self settingsDialog:[:handler | handler languageSettingsFor:self]

    "Modified: / 31.7.1998 / 22:46:13 / cg"
!

loadSettings
    "restore settings from a settings-file."

    "a temporary kludge - we need a central systemSettings object for this,
     which can be saved/restored with a single store/read."

    |fileName|

    fileName := Dialog
        requestFileName:(resources string:'Load Settings From:')
        default:'settings.stx'
        ok:(resources string:'Load')
        abort:(resources string:'Cancel')
        pattern:'*.stx'
        fromDirectory:nil.

    fileName isEmptyOrNil ifTrue:[
        "/ canceled
        ^ self
    ].

    self withWaitCursorDo:[
        Smalltalk fileIn:fileName.
        self reOpen
    ].
!

memorySettings
    "open a dialog on objectMemory related settings"

    self settingsDialog:[:handler | handler memorySettings]

    "Modified: / 31.7.1998 / 22:46:33 / cg"
!

messageSettings
    "open a dialog on infoMessage related settings"

    self settingsDialog:[:handler | handler messageSettings]

    "Modified: / 31.7.1998 / 22:46:45 / cg"
!

miscSettings
    "open a dialog on misc other settings"

    self settingsDialog:[:handler | handler miscSettings]

    "Modified: / 31.7.1998 / 22:46:56 / cg"
!

printerSettings
    "open a dialog on printer related settings"

    self settingsDialog:[:handler | handler printerSettings]

    "Modified: / 31.7.1998 / 22:47:05 / cg"
!

saveSettings
    "save settings to a settings-file."

    self settingsDialog:[:handler | handler saveSettings]

    "Modified: / 31.7.1998 / 22:48:38 / cg"
!

settingsDialog:symbolOrBlock
    |handler|

    RegisteredMenuHandlers notNil ifTrue:[
        handler := RegisteredMenuHandlers at:symbolOrBlock ifAbsent:nil.
    ].
    handler isNil ifTrue:[
        handler := LauncherDialogs
    ].
    symbolOrBlock isBlock ifTrue:[
        symbolOrBlock value:handler
    ] ifFalse:[
        handler perform:symbolOrBlock with:self.
    ]

    "Modified: / 24-02-2007 / 09:40:48 / cg"
!

sourceAndDebuggerSettings
    "open a dialog on misc other settings"

    self settingsDialog:[:handler | handler sourceAndDebuggerSettings]

    "Modified: / 31.7.1998 / 22:47:21 / cg"
!

toolSettings
    "open a dialog on tool settings"

    self settingsDialog:[:handler | handler toolSettings]

    "Modified: / 31.7.1998 / 22:46:56 / cg"
    "Created: / 13.10.1998 / 15:50:53 / cg"
!

viewStyleSetting
    "open a dialog on viewStyle related settings"

    self settingsDialog:[:handler | handler viewStyleSettingsFor:self]

    "Modified: / 31.7.1998 / 22:47:33 / cg"
! !

!AbstractLauncherApplication methodsFor:'private'!

allTopViewsAndLabelsSortedFilteringWindowGroups: windowGroupFilterOrNil
    "helper returning all windows on all screens sorted by a label to suite"

    |knownTopViewsAndLabels|

    knownTopViewsAndLabels := OrderedCollection new.
    self allTopViewsFilteringWindowGroups: windowGroupFilterOrNil withLabelsDo: [:v :lbl |
        knownTopViewsAndLabels add:(lbl -> v)
    ].
    knownTopViewsAndLabels sort:[:a :b | a key < b key].
    ^ knownTopViewsAndLabels

    "Created: / 27-04-2012 / 13:04:21 / cg"
!

allTopViewsFilteringWindowGroups: windowGroupFilterOrNil withLabelsDo: aBlock
    "helper enumerating all windows on all screens with a label to suite"

    |knownTopViews genLabel|


    genLabel := [:v | 
                    |app appName busyOrNot iconifiedOrNot 
                     sensor pending process|

                    app := v application.
                    appName := (app isNil 
                                    ifTrue:[''] 
                                    ifFalse:[app class nameWithoutPrefix,': ']).
                    busyOrNot := ''.
                    (sensor := v windowGroup sensor) notNil ifTrue:[
                        (pending := sensor pendingEvent) notNil ifTrue:[
                            (Timestamp now secondDeltaFrom: pending timeStamp) > 1 ifTrue:[
                                ((process := v windowGroup process) notNil and:[ process isDebugged]) ifTrue:[
                                    busyOrNot := ' [debug]'
                                ] ifFalse:[
                                    busyOrNot := ' [busy]'
                                ].
                                busyOrNot := busyOrNot allBold withColor:Color red
                            ]
                        ]
                    ].
                    iconifiedOrNot := ''.
                    v topView isCollapsed ifTrue:[
                        iconifiedOrNot := ' (iconified)' withColor:Color blue.
                    ].
                    appName,'"',(v label ? 'aView'),'"',busyOrNot,iconifiedOrNot
                ].

    knownTopViews := IdentitySet new.
    Screen allScreens do:[:aScreen |
        aScreen allViewsDo:[:aView |
            |top showIt wg|

            aView notNil ifTrue:[
                top := aView topView.
                (knownTopViews includes:top) ifFalse:[
                    (top isDebugView) ifTrue:[
                        "/ although modal, show it.
                        showIt := top realized
                    ] ifFalse:[
                        (top isKindOf:TopView) ifTrue:[
                            wg := top windowGroup.
                            showIt := (wg notNil and:[wg isModal not]).
                            showIt ifTrue:[
                                windowGroupFilterOrNil notNil ifTrue:[
                                    showIt := windowGroupFilterOrNil includes:wg
                                ]
                            ]
                        ] ifFalse:[
                            showIt := false
                        ].
                    ].
                    showIt ifTrue:[
                        aBlock value: top value:(genLabel value:top).
                        knownTopViews add: top.
                    ]
                ]
            ]
        ]
    ].

    "Created: / 27-04-2012 / 12:56:53 / cg"
!

findApplicationClass:classOrClassName nameSpace:aNameSpace
    "find some application, given the classes name.
     Look for it in Smalltalk and the given nameSpace"

    |findClass cls classNameSymbol|

    classOrClassName isBehavior ifTrue:[
        ^ classOrClassName.
    ].
    findClass :=
        [
            (classNameSymbol := classOrClassName asSymbolIfInterned) notNil ifTrue:[
                cls := Smalltalk at:classNameSymbol.
                cls isNil ifTrue:[
                    "/ look if its in the nameSpace
                    aNameSpace notNil ifTrue:[
                        cls := aNameSpace at:classNameSymbol
                    ].
                ].
            ].
        ].
    findClass value.
    cls isNil ifTrue:[
        (Dialog confirm:(resources
                    stringWithCRs:'Sorry, the ''%1''-class is not available.\\Shall I try to autoload it?'
                    with:classOrClassName allBold)) ifFalse:[
            ^ AbortOperationRequest raise
        ].
        self withWaitCursorDo:[
            #(
                'stx:doc/coding'
                'stx:clients'
                'stx:goodies/demos'
                'stx:libwidg3'
            ) do:[:pkg |
                Processor activeProcess withPriority:(Processor userSchedulingPriority) do:[
                    Smalltalk recursiveInstallAutoloadedClassesFrom:(Smalltalk projectDirectoryForPackage:pkg).
                ].
            ].
        ].
        findClass value.
        cls isNil ifTrue:[
            Dialog warn:(resources stringWithCRs:'Autoload failed.\\Sorry, please check the "stx:clients/demos" & "stx:goodies/clients" directories and load manually.').
            ^ nil
        ].
        "/ self halt.
    ].
    ^ cls
!

findWindow:title
    "a helper for find & destroy and find & raise operations;
     let user choose a view and return it; return nil on cancel"

    ^ self findWindow:title windowGroupFilter:nil

!

findWindow:title windowGroupFilter:windowGroupFilterOrNil
    "a helper for find & destroy and find & raise operations;
     let user choose a view and return it; return nil on cancel"

    |knownTopViewsAndLabels nameList box|

    knownTopViewsAndLabels := OrderedCollection new.
    self allTopViewsFilteringWindowGroups: windowGroupFilterOrNil withLabelsDo: [:v :lbl |
        knownTopViewsAndLabels add:(lbl -> v)
    ].
    knownTopViewsAndLabels sort:[:a :b | a key < b key].

    nameList := knownTopViewsAndLabels collect:[:lblAndView |
                                        |v l isDead wg p|

                                        l := lblAndView key.
                                        v := lblAndView value.
                                        v device == Display ifFalse:[
                                            l := l , ' [' , (v device displayName ? '?') , ']'
                                        ].
                                        ((wg := v windowGroup) notNil
                                        and:[(p := wg process) notNil
                                        and:[p state ~~ #dead]]) ifTrue:[
                                            l
                                        ] ifFalse:[
                                            l , ' (dead ?)'
                                        ]
                                      ].

    box := ListSelectionBox new.
    box selectionChangeCallback:[:selectionIndex |   |v|
                                    v := (knownTopViewsAndLabels at:box selectionIndex) value.
                                    v raise. box raise
                                ].
    box noEnterField.
    box list:nameList.
    box label:(resources string:'View Selection').
    box title:(resources stringWithCRs:title).
    box action:[:selection |
        |v|

        box selectionIndex isNil ifTrue:[
            ^ nil.
        ].

        v := (knownTopViewsAndLabels at:box selectionIndex) value.
        box destroy.
        ^ v
    ].
    box extent:400@300.
    box open.
    ^ nil

    "Modified: / 27-04-2012 / 12:59:37 / cg"
!

openApplication: classOrClassName
     "open an application, given by the classe name."

    self openApplication:classOrClassName nameSpace:nil
!

openApplication:classOrClassName nameSpace:aNameSpace
    "open some application, given the classes name.
     Look for it in Smalltalk and the given nameSpace"

    self openApplication:classOrClassName nameSpace:aNameSpace with:#open
!

openApplication:classOrClassName nameSpace:aNameSpace with:aSelector
    "open some application, given the classes name.
     Look for it in Smalltalk and the given nameSpace"

    |cls|

    cls := self findApplicationClass:classOrClassName nameSpace:aNameSpace.
    cls isNil ifTrue:[
        Dialog information:'Could not find class: '
                            ,(classOrClassName isBehavior
                                ifTrue:[classOrClassName name]
                                ifFalse:[classOrClassName]).
        ^ self
    ].

    Autoload autoloadFailedSignal handle:[:ex |
        self warn:(resources string:'Sorry, the %1 class seems to be not available (failed to load).' with:cls name)
    ] do:[
        self withWaitCursorDo:[
            cls perform:aSelector
        ]
    ]
!

openFileBrowser
     "open a fileBrowser"

    self openApplication:UserPreferences fileBrowserClass nameSpace:nil

    "Created: / 05-11-2007 / 11:16:17 / cg"
!

pickAView
    "let user pick a view and return it"

    |v|

    (Delay forSeconds:1) wait.
    v := Screen current viewFromUser.
    v isNil ifTrue:[
        self warn:'Sorry, this is not a smalltalk view'.
        ^ nil
    ].
    ^ v

!

saveScreenImage:anImage defaultName:defaultName
    "ask user for filename, then save an image into a file"

    Dialog
        imageSaveDialog:(resources string:'Save hardcopy image in:')
        image:anImage 
        default:(defaultName , '.png')
        pattern:'*.png;*.tiff;*.bmp;*.gif'

"/    |fileName|
"/
"/    fileName := Dialog
"/                    requestFileName:(resources string:'Save hardcopy image in:')
"/                    default:(defaultName , '.png')
"/                    ok:(resources string:'Save')
"/                    abort:(resources string:'Cancel')
"/                    pattern:'*.png;*.tiff;*.bmp'
"/                    fromDirectory:nil
"/                    forSave:true
"/                    whenBoxCreatedEvaluate:[:box |
"/                        |editButton paintButton copyButton|
"/                        "/ UserPreferences current useNewFileDialog ifFalse:[
"/                            editButton := Button label:(resources string:'Edit').
"/                            editButton
"/                                action:[
"/                                    box hide; destroy.
"/                                    ImageEditor openOnImage:anImage.
"/                                ].
"/                            box addButton:editButton.
"/
"/                            paintButton := Button label:(resources string:'OS Editor').
"/                            paintButton
"/                                action:[
"/                                    |tempStream|
"/
"/                                    tempStream := FileStream newTemporaryWithSuffix:'png'.
"/                                    box hide; destroy.
"/                                    PNGReader save:anImage onStream:tempStream.
"/                                    tempStream close.
"/                                    OperatingSystem
"/                                        openApplicationForDocument:tempStream fileName operation:#edit mimeType:'image/png'.
"/                                ].
"/                            box addButton:paintButton.
"/
"/                            copyButton := Button label:(resources string:'Copy to Clipboard').
"/                            copyButton
"/                                action:[
"/                                    self window setClipboardObject:anImage.
"/                                    box hide; destroy.
"/                                ].
"/                            box addButton:copyButton.
"/                        "/ ]
"/                   ].
"/
"/    fileName notEmptyOrNil ifTrue:[
"/        anImage saveOn:fileName.
"/        ImageEditView lastSaveDirectory:fileName asFilename directory pathName.
"/    ].

    "Created: / 29-01-1998 / 23:20:36 / cg"
    "Modified: / 08-02-2011 / 21:51:11 / cg"
!

showDocumentation:aRelativeDocFilePath
    "open an HTML browser on some document"

    "
     although that one is not yet finished,
     its better than nothing ...
    "
    HTMLDocumentView notNil ifTrue:[
        self withWaitCursorDo:[
            "
             temporary kludge;
             not all machines can autoload binaries;
             however, on my SGI (which can) we want it
             to load automatically.
            "
            HTMLDocumentView isLoaded ifFalse:[
                Error catch:[HTMLDocumentView autoload]
            ].
            HTMLDocumentView isLoaded ifTrue:[
                HTMLDocumentView openFullOnDocumentationFile:aRelativeDocFilePath.
                ^ self
            ].
        ]
    ].

    self warn:'Sorry, the ST/X HTML reader is not
included in this release.

Please use firefox, konqueror, internet explorer or any
other HTML viewer to see the documentation.

The documentation is found in the ''doc/online'' directory.'.

    "Modified: / 25.2.1998 / 21:24:20 / cg"
! !

!AbstractLauncherApplication methodsFor:'private-settings callBacks'!

changeViewStyleTo:newStyle

    newStyle notNil ifTrue:[
        self withWaitCursorDo:[
            (transcript ? Transcript) showCR:'change style to ' , newStyle , ' ...'.
            View defaultStyle:newStyle asSymbol.
        ].
        self reopenLauncher.
        DebugView newDebugger.
    ]
!

fontBoxForEncoding:encodingMatch
    "open a fontBox, showing fonts which match some encoding
     (used when changing to japanese ...)"

    ^ LauncherDialogs fontBoxForEncoding:encodingMatch

"/    |box y b
"/     labelDef buttonDef listDef menuDef textDef
"/     models labels allOfThem filter|
"/
"/    encodingMatch notNil ifTrue:[
"/        filter := [:f | f encoding notNil
"/                        and:[encodingMatch match:f encoding]].
"/    ].
"/
"/    models := OrderedCollection new.
"/    labels := OrderedCollection new.
"/
"/    models add:(allOfThem := nil asValue).
"/    models add:(labelDef := Label defaultFont asValue).
"/    models add:(buttonDef := Button defaultFont asValue).
"/    models add:(listDef := SelectionInListView defaultFont asValue).
"/    models add:(menuDef := MenuView defaultFont asValue).
"/    models add:(textDef := TextView defaultFont asValue).
"/
"/    box := Dialog new.
"/    box label:(resources string:'Font settings').
"/
"/    models
"/    with:(resources array:#('all' 'labels' 'buttons' 'lists' 'menus' 'edit text'))
"/    do:[:model :title |
"/        |y2 lbl f i|
"/
"/        f := model value.
"/
"/        (box addTextLabel:title) adjust:#left.
"/
"/        y := box yPosition.
"/        b := box addComponent:(Button label:(resources string:'change ...')) tabable:true.
"/        b relativeExtent:nil; extent:(b preferredExtent).
"/        y2 := box yPosition.
"/        box yPosition:y.
"/        i := box leftIndent.
"/        box leftIndent:(b widthIncludingBorder + View viewSpacing).
"/        (lbl := box addTextLabel:'')
"/            adjust:#left;
"/            font:(model value);
"/            labelChannel:(BlockValue
"/                            with:[:v | |f|
"/                                f := v value.
"/                                f isNil ifTrue:[
"/                                    ''
"/                                ] ifFalse:[
"/                                    f userFriendlyName
"/                                ]
"/                            ]
"/                            argument:model).
"/        labels add:lbl.
"/
"/        box leftIndent:i.
"/        box yPosition:(box yPosition max:y2).
"/        box addVerticalSpace.
"/        box addHorizontalLine.
"/        box addVerticalSpace.
"/
"/        b action:[
"/            |f|
"/
"/            f := FontPanel
"/                fontFromUserInitial:(model value)
"/                              title:(resources string:'font for %1' with:title)
"/                             filter:filter.
"/            f notNil ifTrue:[
"/                model == allOfThem ifTrue:[
"/                    models do:[:m | m value:f].
"/                    labels do:[:l | l font:f]
"/                ] ifFalse:[
"/                    model value:f.
"/                    lbl font:f.
"/                ].
"/            ]
"/        ].
"/        model == allOfThem ifTrue:[
"/            box addVerticalSpace
"/        ]
"/    ].
"/
"/    box addAbortButton; addOkButton.
"/    (box addButton:(Button label:(resources string:'defaults')) before:nil)
"/        action:[
"/            "/ fetch defaults
"/            View readStyleSheetAndUpdateAllStyleCaches.
"/            labelDef value: Label defaultFont.
"/            buttonDef value: Button defaultFont.
"/            listDef value: SelectionInListView defaultFont.
"/            menuDef value: MenuView defaultFont.
"/            textDef value: TextView defaultFont.
"/        ].
"/
"/    box open.
"/    box accepted ifTrue:[
"/        Label defaultFont:labelDef value.
"/        Button defaultFont:buttonDef value.
"/        Toggle defaultFont:buttonDef value.
"/        SelectionInListView defaultFont:listDef value.
"/        MenuView defaultFont:menuDef value.
"/        PullDownMenu defaultFont:menuDef value.
"/        TextView defaultFont:textDef value.
"/        EditTextView defaultFont:textDef value.
"/        CodeView defaultFont:textDef value.
"/    ].
"/    box destroy.
"/    ^ box accepted

    "Modified: / 15.9.1998 / 22:04:56 / cg"
!

reopenLauncher
    "reopen a new launcher.
     for now (since style & language settings currently do
     not affect living views ...)
     WARNING: bad design: Message known in LauncherDialogs"

    |oldOrigin contents builder newLauncher|

    oldOrigin := self window origin.
    transcript notNil ifTrue:[contents := transcript endEntry; list].
    builder := self class openAt:oldOrigin.
    builder window waitUntilVisible; origin:oldOrigin.
    newLauncher := builder application.
    transcript notNil ifTrue:[
        newLauncher transcript list:contents; hideCursor; scrollToBottom; cursorToEnd; showCursor.
    ].
    ^ newLauncher

    "Modified: / 4.8.1998 / 17:08:33 / cg"
! !

!AbstractLauncherApplication methodsFor:'queries'!

bugReporterAvailable
    ^ BugGUI notNil
    or:[ Expecco::ExpeccoNetAPI notNil ]
!

hasPDALauncher
    ^ PDALauncher notNil
!

monticelloRepositoryAvailable
    ^ true "MCRepositoryBrowser notNil" "/ - will install, if required.

    "Created: / 25-11-2011 / 17:54:37 / cg"
!

processName
    "for monitors only - my name"

    ^ 'ST/X Launcher'

!

remoteImageBrowserAvailable
    ^ SmalltalkShareClient notNil and:[RemoteImage notNil]
!

transcript
    "my transcript"

    transcript isNil ifTrue:[
        ^ Transcript current
    ].
    ^ transcript
!

windowTreeViewAvailable
    ^ false "/ WindowTreeView notNil
! !

!AbstractLauncherApplication methodsFor:'settings dialog'!

openSettings
    ^ self class openSettingsFor: self.

    "Modified: / 08-10-2014 / 23:40:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settingsClosed
    LastSettingsPageName := OpenSettingsDialog selectedItemsName.
    OpenSettingsDialog := nil.
! !

!AbstractLauncherApplication methodsFor:'startup & release'!

addTopViewsToCurrentProject
    "ignored here - the launcher is always global (i.e. not project private)."

    ^ self

!

closeDownViews
    OpenLaunchers remove:self ifAbsent:nil.
    super closeDownViews
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.

    OpenLaunchers isNil ifTrue:[
        OpenLaunchers := IdentitySet new.
    ].
    OpenLaunchers add:self

!

reOpen
    "reopen a new launcher.
     for now (since style & language settings currently do
     not affect living views ...)"

    self reopenLauncher "/ WARNING: bad design: Message known in LauncherDialogs

    "Modified: / 31.7.1998 / 22:48:12 / cg"
!

requestForWindowClose
    "close request from windowing system (window close);
     confirm and ask if closing of launcher only or
     a Smalltalk-exit is wanted"

    |answer|

    answer := Dialog
                confirmWithCancel:(resources string:'Close %1 only or Exit Smalltalk (Close all) ?' with:self class name)
                labels:(resources array:#('Cancel' 'Close' 'Exit'))
                default:3.
    answer isNil ifTrue:[
        "/ cancel
        ^ false
    ].

    answer ifFalse:[
        ^ true
    ].

    self exit.
    "/ not reached
    ^ false

    "Modified: / 20.5.1999 / 17:24:47 / cg"
!

saveAndTerminateRequest
    "some windowManagers can send this, to shutDown an application
     but let it save its state before, for later restart.
     Although I have not yet encountered such a windowManager,
     we are already prepared for this ;-)"

    self snapshot.
    super saveAndTerminateRequest

! !

!AbstractLauncherApplication methodsFor:'user actions-about'!

openLicenseConditions
    "open an HTML browser on the 'LICENCE' document"

    self withWaitCursorDo:[
        |rel lang doc doc_De doc_En|

        rel := Smalltalk releaseIdentification.
        ((rel = 'ST/X_free_vsn') or:[rel = 'ST/X_demo_free_vsn']) ifTrue:[
            doc_En := 'english/LICENCE_FREE_STX.html'.
            doc_De := 'german/LICENCE_FREE_STX.html'.
        ] ifFalse:[
            doc_En := 'english/LICENCE_STX.html'.
            doc_De := 'german/LICENCE_STX.html'.
        ].    
        ((lang := UserPreferences current language) = 'de'
        or:[lang = 'german']) ifTrue:[
            doc := doc_De
        ] ifFalse:[
            doc := doc_En
        ].
        doc := resources at:'LICENCEFILE' default:doc.
        self showDocumentation:('../' , doc)
    ]

    "Created: / 5.2.1998 / 21:43:19 / cg"
    "Modified: / 23.4.1998 / 11:45:53 / cg"
! !

!AbstractLauncherApplication methodsFor:'user actions-classes'!

browseAllBreakAndTracePoints
    "open a browser showing all breakPointed/traced methods
     (but, to get rid of them, there is also a menu itme to remove them all)"

    |filter|

    "/ only methods which are still anchored in the class are relevant here
    "/ (i.e. allInstances may return too many)
    filter := [:m | m mclass notNil].

    UserPreferences systemBrowserClass
        browseMethods:(Set new
                        addAll:(WrappedMethod allWrappedMethods select:filter);
                        addAll:(MethodWithBreakpoints allBreakpointedMethods select:filter);
                        yourself)
        title:'All breakPointed/traced methods'
!

browseContainingString
    "open a browser after asking for a string"

    |browserClass|

    browserClass := UserPreferences systemBrowserClass.
    self withWaitCursorDo:[
        browserClass new browseMenuMethodsWithString
    ].
!

browseImplementors
    "open an implementors- browser after asking for a selector"

    |browserClass selector dialog|

    browserClass := UserPreferences systemBrowserClass.

    Tools::SearchDialog notNil ifTrue:[
        "/ use a better dialog
        dialog := Tools::SearchDialog new
            setupToAskForMethodSearchTitle:(resources string:'Selector to browse implementors of:\(TAB for completion; matchPattern allowed)')
            forBrowser:nil
            searchWhat:#selector searchArea:#everywhere
            withCaseIgnore:true withMatch:true
            withMethodList:false
            allowFind:false allowBuffer:false allowBrowser:true
            withTextEntry:true.

        dialog askThenDo:[
            |classes methods isMethod selector ignoreCase match|

            (classes := dialog classesToSearch) notEmptyOrNil ifTrue:[
                (selector := dialog selectorToSearch) notEmptyOrNil ifTrue:[
                    browserClass 
                        browseImplementorsOf:selector 
                        in:classes
                        ignoreCase:(dialog searchIgnoringCase)
                        match:(dialog searchWithMatch)    
                        title:(SystemBrowser classResources string:'implementors of: %1' with:selector).
                ].
            ].
        ].
        ^ self.
    ].

    "/ the simple dialog
    selector := Dialog
                    requestSelector:(resources string:'Browse implementors of (Tab for completion):')
                    okLabel:(resources string:'Browse')
                    initialAnswer:''.

    selector notEmptyOrNil ifTrue:[
        self withWaitCursorDo:[
            browserClass browseImplementorsMatching:selector
        ]
    ].

    "Modified: / 14-02-2012 / 14:17:51 / cg"
!

browseReferencesToClass
    "open a browser after asking for a class"

    |browserClass class|

    browserClass := UserPreferences systemBrowserClass.

    class := Dialog
                    requestClassName:(resources string:'Browse References to Class named (Tab for Completion):')
                    okLabel:(resources string:'Browse')
                    initialAnswer:''.
    class notNil ifTrue:[
        self withWaitCursorDo:[
            browserClass browseReferendsOf:class
        ]
    ].

    "Modified: / 14-02-2012 / 14:20:56 / cg"
!

browseResources
    "open a resource- browser after asking for a resource string"

    |box resourceHolder valueHolder component rsrc value t anyString|

    anyString := resources string:'* any *'.

    resourceHolder := ValueHolder newString.
    valueHolder := '*' asValue.

    box := DialogBox new.
    box label:(resources string:'Resource search:').
    component := box 
                    addTextLabel:(resources stringWithCRs:'Search for methods which contain a\particular resource specification')
                    adjust:#left.
    box addVerticalSpace:10.

    component := box 
                    addTextLabel:(resources stringWithCRs:'Resource symbol (empty for any; no matchPattern allowed):')
                    adjust:#left.
    component :=  box addComboBoxOn:resourceHolder tabable:true.
    component list:((Array with:anyString) , #('canvas' 'menu' 'keyboard' 'style' 'image' 'programMenu' '-' 'obsolete' 'needsFix')).

    component := box 
                    addTextLabel:(resources stringWithCRs:'Resource value (* for any; matchPattern is allowed):')
                    adjust:#left.
    box addInputFieldOn:valueHolder tabable:true.

    box addVerticalSpace:10.
    box addHelpButtonFor:'programming/language.html#RESOURCEDEFS'.
    box addAbortAndOkButtons.

    box open.
    box destroy.

    box accepted ifTrue:[
        rsrc := resourceHolder value.
        value := valueHolder value.

        (rsrc size == 0 or:[rsrc = '*' or:[rsrc = anyString]]) ifTrue:[
            t := 'methods with any resource'.
            rsrc := nil
        ] ifFalse:[
            t := 'methods with #' , rsrc , '-resource'.
            rsrc := rsrc withoutSeparators asSymbol
        ].
        (value size == 0 or:[value = '*']) ifTrue:[
            t := t , ' and any value'.
            value := nil
        ] ifFalse:[
            t := t , ' and value ' , value.
        ].
        self withWaitCursorDo:[
            UserPreferences systemBrowserClass
                browseForResource:rsrc
                containing:value
                in:(Smalltalk allClasses)
                title:t
        ]
    ].
!

browseSenders
    "open a senders- browser after asking for a selector"

    |browserClass dialog selector|

    browserClass := UserPreferences systemBrowserClass.

    Tools::SearchDialog notNil ifTrue:[
        "/ use a better dialog
        dialog := Tools::SearchDialog new
            setupToAskForMethodSearchTitle:(resources string:'Selector to browse senders of:\(TAB for completion; matchPattern allowed)')
            forBrowser:nil
            searchWhat:#selector searchArea:#everywhere
            withCaseIgnore:true withMatch:true
            withMethodList:false
            allowFind:false allowBuffer:false allowBrowser:true
            withTextEntry:true.

        dialog askThenDo:[
            |classes methods isMethod selector ignoreCase match|

            (classes := dialog classesToSearch) notEmptyOrNil ifTrue:[
                (selector := dialog selectorToSearch) notEmptyOrNil ifTrue:[
                    browserClass 
                        browseAllCallsOn:selector 
                        in:classes
                        ignoreCase:(dialog searchIgnoringCase)
                        match:(dialog searchWithMatch)    
                        title:(SystemBrowser classResources string:'senders of: %1' with:selector).
                ].
            ].
        ].
        ^ self.
    ].

    selector := Dialog
                    requestSelector:(resources string:'Browse Senders of (Tab for Completion):')
                    okLabel:(resources string:'Browse')
                    initialAnswer:''.
    selector size > 0 ifTrue:[
        self withWaitCursorDo:[
            browserClass browseAllCallsOn:selector
        ]
    ].

    "Modified: / 14-02-2012 / 14:20:56 / cg"
!

browseUnboundGlobals
    "open a browser on methods refering to unbound global variables"

    self withWaitCursorDo:[
        UserPreferences systemBrowserClass
            browseReferendsOfUnboundGlobalsWithTitle:(resources string:'References to unbound global variables')
            warnIfNone:true
    ]
!

browseUndeclared
    "open a browser on methods refering to undeclared variables"

    self withWaitCursorDo:[
        UserPreferences systemBrowserClass
            browseReferendsOf:(Smalltalk undeclaredPrefix , '*')
            title:(resources string:'References to undeclared variables')
            warnIfNone:true
    ]
!

clearUndeclaredVariables
    "remove all undeclared variables"

    Smalltalk clearUndeclaredVariables
!

newSystemBrowserClass
    |newSystemBrowserClass|

    newSystemBrowserClass := Tools::NewSystemBrowser ? NewSystemBrowser.
    newSystemBrowserClass isNil ifTrue:[
        self warn:'This needs the NewSystemBrowser to be loaded.'.
        AbortOperationRequest raise.
    ].
    ^ newSystemBrowserClass
!

removeAllBreakAndTracePoints
    "remove all break- and trace points"

    self
        withCursor:Cursor execute
        do:[ 
            MessageTracer cleanup.
            MethodWithBreakpoints allBreakpointedMethods do:[:m | m restoreOriginalMethod]
        ]
!

startClassBrowser
    "open a classBrowser; asks for class"

    UserPreferences systemBrowserClass askThenBrowseClass
!

startClassBrowserOnChangedClasses
    "open a classBrowser on the changeSet"

    self newSystemBrowserClass openOnClassesInChangeSet
!

startClassBrowserOnChangedMethods
    "open a classBrowser on the changeSet"

    self newSystemBrowserClass openOnMethodsInChangeSet
!

startClassBrowserOnChanges
    "open a classBrowser on the changeSet"

    ^ self startClassBrowserOnChangedClasses
!

startClassHierarchyBrowser
    "open a classHierarchyBrowser; asks for class"

    UserPreferences systemBrowserClass askThenBrowseClassHierarchy
!

startFullClassBrowser
    "open a fullClass systemBrowser; asks for class"

    UserPreferences systemBrowserClass askThenBrowseFullClassProtocol
!

startMonticelloRepositoryBrowser
    "open a monticello repository browser. Unfinished & experimental."

    MCRepositoryBrowser isNil ifTrue:[
        Smalltalk loadPackage:'stx:goodies/monticello'
    ].

    MCRepositoryBrowser open.

    "Created: / 25-11-2011 / 17:55:18 / cg"
!

startRemoteImageBrowser
    "open a remoteImage browser; asks for hostname.
     The remote host must have an st/x running with remote browsing enabled.
     Sorry, for now, only the old browser supports remote browsing."

    |hostName|

    hostName := Dialog request:'Remote Host:'.
    hostName isEmptyOrNil ifTrue:[^ self].

    SystemBrowser openOnRemoteImageOnHost:hostName port:nil.
!

startSnapshotImageBrowser
    "open a snapshotImage browser; asks for filename.
     Sorry, for now, only the old browser supports remote browsing."

    |imageFileName|

    imageFileName := Dialog requestFileName:'Name of Snapshot Image File:' default:'st.img' pattern:'*.img;*.sav'.
    imageFileName isEmptyOrNil ifTrue: [^ self ].

    SystemBrowser openOnSnapShotImage:imageFileName
! !

!AbstractLauncherApplication methodsFor:'user actions-demos'!

startPDALauncher
    self startRemoteLauncherWithSetup:[:newDisplay | newDisplay bePDA].
!

startRemoteLauncher
    self startRemoteLauncherWithSetup:[:newDisplay | ].
!

startRemoteLauncherWithSetup:aSetupBlock
    |host remoteDisplay remoteDisplayClass|

    host := Dialog
                request:(resources string:'Remote Launcher on which display:')
                initialAnswer:'{hostName}:0'
                initialSelection:(1 to:10).
    host size > 0 ifTrue:[
        (host includes:$:) ifFalse:[
            host := (host , ':0')
        ].

        remoteDisplayClass := XWorkstation.

"/        "/ Q: should we allow GL graphics on the remote display
"/        "/ (Problem: the GL library is not threadsafe, when multiple-display connections
"/        "/ are open - leading to mixing output between views ...)
"/
"/        "/ only simulated GL can be done remote (i.e. not on SGI)
"/        (Screen current supportsGLDrawing
"/        and:[Screen current isTrueGL not])
"/        ifTrue:[
"/            remoteDisplayClass := GLXWorkstation.
"/        ].

        [
            remoteDisplay := remoteDisplayClass newDispatchingFor:host.
        ] on:Screen deviceOpenErrorSignal do:[:ex|
            self warn:'Could not connect to display: ''' , host , '''.'.
            ^ self
        ].
        aSetupBlock value:remoteDisplay.
        Screen currentScreenQuerySignal
            answer:remoteDisplay
            do:[
                self class open.
            ]
    ].

    "Created: / 10.9.1998 / 11:48:42 / cg"
! !

!AbstractLauncherApplication methodsFor:'user actions-file'!

exit
    "saves a snapshot image and exits, after asking for a fileName"

    |fileName saveAndExit box|

    box := EnterBox2 title:(resources string:'Save image before exiting?')
        okText:(resources string:'Exit')
        abortText:(resources string:'Cancel')
        action:[:str | saveAndExit := false].
    box label: (resources string:'Exiting ST/X').
    box initialText: ObjectMemory nameForSnapshot.
    box okText2:(resources string:'Save & Exit') action2:[:str|fileName := str. saveAndExit := true].
    box showAtPointer.

    saveAndExit notNil ifTrue:[
        [
            saveAndExit ifTrue:[
                self saveImageAs:fileName
            ].
            Smalltalk exit.
        ] on:SnapshotError do:[:ex|
            "do not exit when snapshot writing fails"
            self warn:ex description.
        ]
    ].
    
    saveAndExit ~~ true ifTrue:[
        "/ not saved - see if settings changed
        UserPreferences current isModified ifTrue:[
            (Dialog confirm:(resources string:'Save changed settings before exiting?')) ifTrue:[
                SettingsDialog saveSettingsAsDefaultSettings 
            ]
        ]
    ].
    

    "Modified: / 23.4.1998 / 18:37:46 / cg"
!

fileLoadPackage
    "open a dialog showing wellknown packages (listed in the packages directory)
     and offer to load the selected one(s).
     TODO: make this a little app instead of an ad-hoc dialog, 
     add remote packages (central goody repository?),
     add a description text view, showing more info about the package (from where?)"    

    self class openLoadPackageDialog.
!

saveImageAs: aFileName
    "save image in aFilename.
     Sender has to handle SnapshotError"

    aFileName notNil ifTrue:[
        self withWriteCursorDo:[
            ObjectMemory snapShotOn:aFileName
        ].
    ].

    "Modified: / 27-07-2012 / 09:46:19 / cg"
! !

!AbstractLauncherApplication methodsFor:'user actions-help'!

showBookPrintDocument
    "open an HTML browser on the 'book'-printing document"

    self showDocumentation:'BOOK.html'
!

showCredits
    self showDocumentation:'credits.html'

    "Modified: / 17-02-2014 / 21:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showPortInfo
    |portNr url|

    portNr := Dialog request:'Port Number:'.
    portNr isEmptyOrNil ifTrue:[^ self].

    url := 'http://www.grc.com/port_' , portNr printString , '.htm'.
    self withWaitCursorDo:[
        HTMLDocumentView openFullOnURL:url.
    ]
!

showRFC
    |rfc url|

    rfc := Dialog request:'RFC Number ("index" for list):'.
    rfc isEmptyOrNil ifTrue:[^ self].

    rfc = 'index' ifTrue:[
        url := 'http://www.faqs.org/rfcs/'.
    ] ifFalse:[
        url := 'http://www.faqs.org/rfcs/rfc' , rfc printString , '.html'.
    ].
    self withWaitCursorDo:[
        HTMLDocumentView openFullOnURL:url.
    ]
!

showTipOfTheDay
    "open a tip-of-the-day window"

    DidYouKnowTipViewer open
!

startClassDocumentation
    "open an HTML browser on the 'classDoc/TOP' document"

    self showDocumentation:'classDoc/TOP.html'

!

startDocumentationIndex
    "open an HTML browser on the 'index' document"

    self showDocumentation:'index.html'
!

startDocumentationTool
    "open an HTML browser on the 'TOP' document"

    self showDocumentation:'TOP.html'

!

startLauncherDocumentation
    "open an HTML browser on the launcher section in the 'tools/TOP' document"

    self showDocumentation:'tools/misc/TOP.html#LAUNCHER'
!

startProgrammersGuide
    "open an HTML browser on the 'programers guide' document"

    self showDocumentation:'programming/TOP.html'
!

startSmalltalkTutorial
    "open an HTML browser on 'doc\books\JoyOfST\IntroToST.html' document"

    self showDocumentation:'books/JoyOfST/IntroToST.html'
!

startToolsDocumentation
    "open an HTML browser on the 'tools/TOP' document"

    self showDocumentation:'tools/TOP.html'
!

startTutorial
    "open an HTML browser on the 'getstart/tutorial.html' document"

    self showDocumentation:'getstart/tutorial.html'
!

startWhatsNewDocumentation
    "open an HTML browser on the 'whatsNew.html' document"

    self showDocumentation:'whatsNew.html'

!

startWhatsNewSTX
    "open an HTML browser on the 'relNotes.html' document"

    self showDocumentation:'newFeatures.html'

! !

!AbstractLauncherApplication methodsFor:'user actions-system'!

compressingGarbageCollect
    "perform a compressing garbageCollect"

    self withWaitCursorDo:[ObjectMemory verboseGarbageCollect]

!

flushCachedResources
    "flush all cached resources (e.g. translations)."

    Smalltalk changed:#Language.  "this flushes everything"
!

garbageCollect
    "perform a non-compressing garbageCollect"

    self withWaitCursorDo:[ObjectMemory reclaimSymbols]

!

objectModuleDialog
    "opens a moduleInfo dialog"

    Tools::ObjectModuleInformation notNil ifTrue:[
        self openApplication:#'Tools::ObjectModuleInformation'.
        ^ self.
    ].

    ^ LauncherDialogs objectModuleDialog

    "Modified: / 31.7.1998 / 17:33:24 / cg"
!

startStopEventTrace
    "start/stop event tracing for a particular view"

    |v wg|

    v := Screen current viewFromUser.
    v notNil ifTrue:[
        v := v topView.
        wg := v windowGroup.
        wg notNil ifTrue:[
            "/
            "/ toggle eventTrace in its windowGroup
            "/
            wg traceEvents:(wg traceEvents not)
        ]
    ]
! !

!AbstractLauncherApplication methodsFor:'user actions-tools'!

inspectGlobalVariables
    "inspect globals"

    WorkspaceApplication notNil ifTrue:[
        "/ looks nicer...
        WorkspaceApplication openWithGlobalsInspector.
        ^ self.
    ].
    Smalltalk inspect
!

inspectWorkspaceVariables
    "inspect workspace variables"

    WorkspaceApplication notNil ifTrue:[
        "/ looks nicer...
        WorkspaceApplication openWithWorkspaceVariableInspector.
        ^ self.
    ].
    "/ Workspace workspaceVariables inspect
!

newProject
    "creates a new project & opens a projectView for it"

    Project notNil ifTrue: [(ProjectView for: Project new) open]
!

openEvaluationWorkspace
    WorkspaceApplication notNil ifTrue:[
        ^ WorkspaceApplication openEvaluationWorkspace
    ].
    ^ self openApplication:Workspace
!

openMyWorkspace
    WorkspaceApplication notNil ifTrue:[
        ^ WorkspaceApplication openMyWorkspace
    ].
    ^ self openApplication:Workspace
!

openRegularWorkspace
    WorkspaceApplication notNil ifTrue:[
        ^ WorkspaceApplication openRegularWorkspace
    ].
    ^ self openApplication:Workspace
!

openSystemWorkspace
    WorkspaceApplication notNil ifTrue:[
        ^ WorkspaceApplication openSystemWorkspace
    ].
    ^ self openApplication:Workspace
!

openTerminal
    TerminalApplication notNil ifTrue:[
        ^ TerminalApplication open
    ].
    self openApplication:#VT100TerminalView
!

openTextDiffTool
    Tools::TextDiff2Tool isNil ifTrue:[
        Dialog warn:'Tools::TextDiff2Tool is missing'.
        ^ self        
    ].
    ^Tools::TextDiff2Tool 
        openOn:'Paste some text here' label:'text1'
        and:'Paste the other text text here' label:'text2'
!

openWorkspace
    WorkspaceApplication notNil ifTrue:[
        ^ WorkspaceApplication open
    ].
    ^ self openApplication:Workspace
!

removeAllWorkspaceVariables
    "remove workspace variables"

    Workspace removeAllWorkspaceVariables
!

selectProject
    "asks for and switch to another project"

    |list box|

    Project notNil ifTrue:[
        list := Project allInstances.
        box := ListSelectionBox new.
        box list:(list collect:[:p | p name]).
        box title:(resources string:'Select a project').
        box action:[:selection |
            |project|

            project := list detect:[:p | p name = selection] ifNone:[nil].
            project isNil ifTrue:[
                transcript notNil ifTrue:[
                    transcript showCR:'No such project.'
                ]
            ] ifFalse:[
                project showViews.
                Project current:project
            ]
        ].
        box open.
        box destroy
    ]
!

startBugMessages
    "open the bug reporter"

    Expecco::ExpeccoNetAPI notNil ifTrue:[
        Expecco::ExpeccoNetAPI reportCodeReview.
        ^ self
    ].

    BugGUI notNil ifTrue:[
        self openApplication:#BugGUI
    ].

    "Modified: / 17.10.1998 / 14:38:18 / cg"
!

startChangeSetBrowser
    "open a change Set Browser on the changes in the system"

    ^ UserPreferences current changeSetBrowserClass open

    "Created: / 05-11-2001 / 18:04:05 / cg"
    "Modified: / 05-03-2015 / 06:57:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startChangesBrowser
    "open a changebrowser on the change file - either new or old GUI, depending on userPrefs"

    self openApplication:(UserPreferences current changesBrowserClass)

    "Modified: / 17.10.1998 / 14:38:18 / cg"
!

startInternationalLanguageTranslationEditor
    "open the language-string editor (english/german/spanish etc.)"

    self openApplication:#'Tools::InternationalLanguageTranslationEditor'
!

startNewChangesBrowser
    "opens the new changeBrowser"

    self openApplication:#NewChangesBrowser

    "Created: / 6.6.1998 / 19:47:26 / cg"
!

startNewLauncher
    "opens the new launcher"

    NewLauncher isNil ifTrue:[
        ^ self warn:'The NewLauncher is not available in this release.'
    ].
    Display withoutExitingOnLastCloseDo:[
        NewLauncher openAt:(self window origin)
    ].
!

startOldChangesBrowser
    "opens the old changeBrowser"

    self openApplication:#ChangesBrowser

    "Created: / 6.6.1998 / 19:47:26 / cg"
!

startOldLauncher
    "opens the old launcher"

    Launcher isNil ifTrue:[
        ^ self warn:'The (Old)Launcher is not available in this release.'
    ].
    Launcher openAt:(self window origin)

!

startSUnitTestRunner
    "open the configured SUnit test runner"

    self openApplication:(UserPreferences current testRunnerClass)

    "Modified: / 17.10.1998 / 14:38:18 / cg"
!

startSUnitTestRunner1
    "open the SUnit test runner"

    self openApplication:#TestRunner

    "Modified: / 17.10.1998 / 14:38:18 / cg"
!

startSmaCCParserGenerator
    "open the SmaCC-ParserGenerator UI"

    self openApplication:#'SmaCC::SmaCCParserGenerator'

    "Modified: / 17.10.1998 / 14:38:18 / cg"
! !

!AbstractLauncherApplication methodsFor:'user actions-windows'!

allTopViewsDo:aBlock
    |setOfViews currentScreen|

    setOfViews := Project current views asIdentitySet.
    setOfViews addAll:(Project defaultProject views).

    currentScreen := Screen current.
    setOfViews do:[:eachTopView |
        eachTopView device == currentScreen ifTrue:[
            aBlock value:eachTopView
        ]
    ]
!

askForAnotherDisplay
    "ask for some other display"

    |displayName|

    displayName := Dialog request:'Display:' initialAnswer:(Screen default displayName).
    displayName isEmptyOrNil ifTrue:[^ nil].

    ^ XWorkstation newDispatchingFor:displayName.
!

bringAllWindowsOntoScreen
    self allTopViewsDo:[:eachTopView | self bringWindowOntoScreen:eachTopView]

    "
     Transcript topView application bringAllWindowsOntoScreen
    "
!

bringWindow:aWindow intoBounds:bounds
    "shift & resize a view to be completely inside bounds."

    |topView oldOrg newOrg oldCorner newCorner delta|
    
    topView := aWindow topView.
    oldOrg := newOrg := topView origin.
    oldCorner := newCorner := topView corner. 

    (bounds containsPoint:oldOrg) ifFalse:[
        newOrg := bounds origin + (10@10).
        delta := newOrg - oldOrg.
        newCorner := oldCorner + delta.
    ].    
    (bounds containsPoint:newCorner) ifFalse:[
        newCorner := bounds corner - (10@10).
        delta := newCorner - oldCorner.
        newOrg = oldOrg ifTrue:[
            newOrg := newOrg + delta.
            (bounds containsPoint:newOrg) ifFalse:[
                newOrg := bounds origin + (10@10).
            ].
        ].
    ].
    topView 
        raiseDeiconified;
        origin:newOrg corner:newCorner.
!

bringWindowOntoScreen:aWindow 
    "shift & resize a view to be visible.
     If there are multiple screens,bring them all onto the screen where the launcher is"
    
    |allBounds bounds myDevice|

    myDevice := self device.
    allBounds := myDevice monitorBounds. "At:aWindow center"
    allBounds notEmptyOrNil ifTrue:[
        bounds := allBounds 
                detect:[:bounds | bounds containsPoint:self window center ]
                ifNone:[ nil ].
    ].
    bounds isNil ifTrue:[
        bounds := 0@0 extent:myDevice usableExtent.
    ].
    self bringWindow:aWindow intoBounds:bounds
!

deIconifyAllWindows
    self allTopViewsDo:[:eachTopView | eachTopView expand; raise].
    self window raise.

    "
     Transcript topView application deIconifyAllWindows
    "
!

findAndDestroyWindow
    "find a window (by name) and destroy it"

    |v|
    v := self findWindow:'Select window to close:'.
    v notNil ifTrue:[v destroy]
!

findAndMigrateWindow
    "find a window (by name) and migrate it to some other display"

    |possibleGroups v|

    possibleGroups := WindowGroup allInstances select:[:eachGroup |
                                        eachGroup graphicsDevice == Screen current
                                        and:[eachGroup isModal not
                                        and:[eachGroup topViews size > 0]]].
    possibleGroups isEmpty ifTrue:[
        self information:'No windows found which could be migrated to some other display.'.
        ^ self
    ].

    v := self findWindow:'Select window to migrate:' windowGroupFilter:possibleGroups.
    v notNil ifTrue:[
        self migrateWindow:v topView
    ]
!

findAndMigrateWindowBack
    "find a window (by name) and migrate it back to this display"

    |possibleGroups v|

    possibleGroups := WindowGroup allInstances select:[:eachGroup |
                                        eachGroup graphicsDevice ~~ Screen current
                                        and:[eachGroup isModal not
                                        and:[eachGroup topViews size > 0]]].
    possibleGroups isEmpty ifTrue:[
        self information:'No windows are open on any other display.'.
        ^ self
    ].

    v := self findWindow:'Select window to migrate back:' windowGroupFilter:possibleGroups.
    v notNil ifTrue:[
        v windowGroup migrateTo:(Screen current)
    ]
!

findAndRaiseWindow
    "find a window (by name) and raise it"

    |v|

    v := self findWindow:'Select window to raise deiconified:'.
    v notNil ifTrue:[v raiseDeiconified; setForegroundWindow]
!

fullScreenHardcopy
    "after a second (to allow redraw of views under menu ...),
     save the contents of the whole screen."
    
    |mySensor|

    mySensor := self window sensor.
    mySensor ctrlDown ifTrue:[
        ^ self fullScreenHardcopyUngrabbed
    ].
    Processor 
        addTimedBlock:[ self saveScreenImage:(Image fromScreen) defaultName:'screen' ]
        afterSeconds:(mySensor shiftDown ifTrue:5 ifFalse:1)
!

fullScreenHardcopyUngrabbed
    "after a second (to allow redraw of views under menu ...),
     save the contents of the whole screen."

    Processor
        addTimedBlock:[
                        |display image|

                        display := Screen current.
                        image := Image
                            fromScreen:(0@0 corner:(display extent))
                            on:display
                            grab:false.

                        self
                            saveScreenImage:image
                            defaultName:'screen'
                      ]
        afterSeconds:(self window sensor shiftDown ifTrue:5 ifFalse:1)
!

hardcopyOfView: aView
    "after a second (to allow redraw of views under menu ...),
     save a view's contents as bitmap image."

    |top|

    top := aView topView.
    top raiseDeiconified; makeFullyVisible.

    "do a pushEvent, in case its me myself and I have to redraw first..."
    self enqueueDelayedAction:[
        Delay waitForSeconds:1.   "/ give view a chance to redraw itself.
        self saveScreenImage:(Image fromView:top) defaultName:'hardcopy'
    ].
    aView windowGroup processExposeEvents

    "Created: / 27-04-2012 / 13:23:40 / cg"
!

iconifyAllWindows
    self allTopViewsDo:[:eachTopView | eachTopView collapse]
!

migrateAllWindows
    "migrate all views to some other display"

    |anotherDisplay toMigrate|

    [
        anotherDisplay := self askForAnotherDisplay.
        anotherDisplay isNil ifTrue:[
            ^ self.
        ].
    ] on:Screen deviceOpenErrorSignal do:[:ex|
        ^ self warn:'Cannot open display: ', ex parameter.
    ].

    toMigrate := WindowGroup allInstances
        select:[:each | each graphicsDevice == Screen current
                        and:[each topViews size > 0
                        and:[each isModal not]]
               ].
    toMigrate do:[:eachGroup |
        eachGroup migrateTo:anotherDisplay
    ]
!

migrateWindow:aWindow
    "migrate a view to some other display"

    aWindow isModal ifTrue:[
        self warn:'Sorry - I cannot migrate a modalBox; please migrate the owning View.'.
        ^ self
    ].
    self 
        migrateWindow:aWindow 
        withBackOption:(self confirm:'Show ''Return Back'' Button on the other display ?')

    "Modified (format): / 27-04-2012 / 13:15:23 / cg"
!

migrateWindow:aWindow withBackOption:withBackOption
    "migrate a view to some other display"

    |anotherDisplay wg here b|

    aWindow isTopView ifFalse:[
        self information:'Cannot migrate this window'.
        ^ self
    ].

    [
        anotherDisplay := self askForAnotherDisplay.
        anotherDisplay isNil ifTrue:[
            ^ self.
        ].
    ] on:Screen deviceOpenErrorSignal do:[:ex|
        ^ self warn:'Cannot open display: ', ex parameter.
    ].

    wg := aWindow windowGroup.
    wg migrateTo:anotherDisplay.

    withBackOption ifTrue:[
        here := Screen current.
        b := Button onDevice:anotherDisplay.
        b label:'Return window back to ' , here displayName.
        b action:[ wg migrateTo:here. b destroy. ].
        b origin:0@0.
        b open.
    ].
!

openWindowTreeInspector
    Tools::ViewTreeInspectorApplication isNil ifTrue:[
        Dialog warn:'Missing class: Tools::ViewTreeInspectorApplication'.
        ^ self.
    ].
    Tools::ViewTreeInspectorApplication openInPickModeAndRelease

    "Modified: / 12-05-2011 / 10:15:39 / cg"
!

screenHardcopy
    "after a second (to allow redraw of views under menu ...),
     let user specify a rectangular area on the screen
     and save its contents."

    Processor
        addTimedBlock:[
                        |area|

                        [Screen current leftButtonPressed] whileTrue:[Delay waitForSeconds:0.05].

                        area := Rectangle fromUser.
                        (area width > 0 and:[area height > 0]) ifTrue:[
                            Delay waitForSeconds:2.
                            self saveScreenImage:(Image fromScreen:area) defaultName:'hardcopy'
                        ]
                      ]
        afterSeconds:(self window sensor shiftDown ifTrue:5 ifFalse:0.5)

    "Modified: / 18.8.1998 / 15:00:42 / cg"
!

screenHardcopyWithDelay
    "after some time (to allow user to pull menu or similar...),
     let user specify a rectangular area on the screen
     and save its contents."

    |area|

    [Screen current leftButtonPressed] whileTrue:[Delay waitForSeconds:0.05].

    Delay waitForSeconds:0.2. "/ to allow redraw under the menu area just uncovered
    area := Rectangle fromUser.
    (area width > 0 and:[area height > 0]) ifTrue:[
        [
            |oldLabel|

            oldLabel := self window label.
            10 to:4 by:-1 do:[:secs |
                self window label:(resources string:'%1 seconds until making a screenshot...' with:secs).
                Screen current beep. 
                Delay waitForSeconds:1. 
            ].
            3 to:1 by:-1 do:[:secs |
                self window label:(resources string:'%1 seconds until making a screenshot...' with:secs).
                Screen current beep. 
                Delay waitForSeconds:0.5. 
                Screen current beep. 
                Delay waitForSeconds:0.5.
            ].        
            self window label:oldLabel.
            self saveScreenImage:(Image fromScreen:area) defaultName:'hardcopy'
        ] fork
    ]
!

showFlyByWindowInformation
    "show infos about window under the mouse pointer"

    FlyByWindowInformation notNil ifTrue:[
        [
            FlyByWindowInformation shownInformationOfViewUnderMouseUntilButtonIsPressed
        ] fork.
    ]
!

startWindowTreeView
    "open a windowTree (on a picked topView)"

    |v|

    WindowTreeView isNil ifTrue:[
        ^ self warn:'The WindowTreeView is not available in this release.'
    ].

    v := self pickAView.
    v notNil ifTrue:[
        WindowTreeView openOn:v topView
    ]

!

startWindowTreeViewForAll
    "open a windowTree on all views in the system"

    WindowTreeView isNil ifTrue:[
        ^ self warn:'The WindowTreeView is not available in this release.'
    ].

    WindowTreeView openOnAll
!

viewBrowse
    "let user pick a view and browse its Application class. 
     Of course, only Smalltalk views are allowed"

    |v app appClass browser|

    (v := self pickAView) notNil ifTrue:[
        browser := UserPreferences browserClass.
        (app := v application) notNil ifTrue:[
            appClass := app class theMetaclass.
            (appClass includesSelector:#windowSpec) ifTrue:[
                browser openInMethod:(appClass compiledMethodAt:#windowSpec)
            ]
        ] ifFalse:[
            (app ? v) browse
        ]
    ]

    "Created: / 30-06-2011 / 22:59:03 / cg"
!

viewDestroy
    "let user pick a view and destroy it.
     Even allow destroying non-Smalltalk views
     (also for views which I forgot due to some error)"

    |screen v id i c|

    Delay waitForSeconds:1.

    i := self class cross2Icon.
    i isNil ifTrue:[
        c := Cursor crossHair
    ] ifFalse:[
        c := Cursor fromImage:i
    ].

    screen := Screen current.
    id := screen viewIdFromPoint:(screen pointFromUserShowing:c).
    (v := screen viewFromId:id) notNil ifTrue:[
        v topView destroy.
        ^ self
    ].
    id = screen rootView id ifTrue:[
        ^ self
    ].
    (Dialog confirm:'This may not be a smalltalk view\(or I somehow forgot about it).\Destroy anyway?' withCRs)
    ifTrue:[
        screen destroyView:nil withId:id
    ].
!

viewHardcopy
    "after a second (to allow redraw of views under menu ...),
     let user specify a view and save its contents."

    Processor
        addTimedBlock:[
                        |v|
                        (v := Screen current viewFromUser) notNil ifTrue:[
                            self hardcopyOfView: v
                        ]
                      ]
        afterSeconds:(self window sensor shiftDown ifTrue:5 ifFalse:1)

    "Modified: / 27-04-2012 / 13:24:23 / cg"
!

viewInspect
    "let user pick a view and inspect it. 
     Of course, only Smalltalk views are allowed"

    |v|

    (v := self pickAView) notNil ifTrue:[
        v inspect
    ]
!

viewMigrate
    "let user pick a view and migrate it to some other display.
     Only Smalltalk views are allowed"

    |v|

    (v := self pickAView) notNil ifTrue:[
        self migrateWindow:v topView
    ]
!

viewSelectAndShrink
    "let user pick a view and shrink it to a reasonable size
     Added for stupid mac, to get windows back onto the screen,
     which have their resize handle hidden or unreachable."

    |v|

    (v := self pickAView) notNil ifTrue:[
        v topView 
            origin:50@50 extent:200@200;
            raise
    ]
!

widgetHardcopy
    "after a second (to allow redraw of views under menu ...),
     let user specify a widget and save its contents."

    Processor
        addTimedBlock:
            [
                |v|
                (v := Screen current viewFromUser) notNil ifTrue:[
                    self saveScreenImage:(Image fromView:v) defaultName:'hardcopy'
                ]
            ]
        afterSeconds:(self window sensor shiftDown ifTrue:5 ifFalse:1)

    "Created: / 21.8.1998 / 20:44:12 / cg"
! !

!AbstractLauncherApplication::LauncherDialogs class methodsFor:'dialogs'!

communicationsSettings
    "open a dialog on communications settings.
     Obsoleted by the settings application"

    |box check in resources y acceptChannel
     hasRDoitServer rDoitServerPort
     rDoitsEnabled rDoitLogging rDoitErrorLogging rDoitErrorDebugging
     org_rDoitsEnabled org_rDoitLogging org_rDoitErrorLogging org_rDoitErrorDebugging org_rDoitServerPort

     hasRemoteBrowsingSupport remoteBrowsingEnabled org_remoteBrowsingEnabled

     hasWindowMigrationServer windowMigrationAuthenticate windowMigrationPassword
     windowMigrationEnabled
     org_windowMigrationEnabled org_windowMigrationAuthenticate org_windowMigrationPassword

     hasHTTPServer httpServerRunning httpServerFileRoot httpServerHomeURL
     httpServerPort httpServerLogFile hasSwiki swikiEnabled swikiRoot
     allowEmbedded hasSoap soapEnabled
     org_httpServerRunning org_httpServerFileRoot org_httpServerHomeURL
     org_httpServerPort org_swikiRoot org_swikiEnabled org_httpServerLogFile
     org_allowEmbedded org_soapEnabled

     osiACSEPresent osiROSEPresent osiCMISEPresent
     osiACSEErrorLogging osiACSEConnectionLogging osiACSEDataLogging
     osiROSEErrorLogging osiROSEResponseLogging osiROSEInvokationLogging
     osiCMISEErrorLogging osiCMISEMessageLogging defaultServer
    |

    self warn:'Please use HTTPServer Settings in the new SettingsDialog'.
    acceptChannel := false asValue.

    resources := self owningClass classResources.
    defaultServer := HTTPServer defaultServer.
    "/
    "/ extract relevant remoteBrowsing settings ...
    "/
    remoteBrowsingEnabled := false.
    (hasRemoteBrowsingSupport := SmalltalkShareServer notNil) ifTrue:[
        SmalltalkShareServer isLoaded ifTrue:[
            remoteBrowsingEnabled := SmalltalkShareServer serverRunning.
        ].
    ].
    org_remoteBrowsingEnabled := remoteBrowsingEnabled.
    remoteBrowsingEnabled := remoteBrowsingEnabled asValue.

    "/
    "/ extract relevant windowMigration settings ...
    "/
    windowMigrationEnabled := windowMigrationAuthenticate := false.
    (hasWindowMigrationServer := WindowMigrationServer notNil) ifTrue:[
        WindowMigrationServer isLoaded ifTrue:[
            windowMigrationEnabled := WindowMigrationServer serverRunning.
        ].
        windowMigrationPassword := WindowMigrationServer password.
        windowMigrationAuthenticate := windowMigrationPassword notNil.
    ].
    org_windowMigrationEnabled := windowMigrationEnabled.
    windowMigrationEnabled := windowMigrationEnabled asValue.
    org_windowMigrationAuthenticate := windowMigrationAuthenticate.
    windowMigrationAuthenticate := windowMigrationAuthenticate asValue.
    org_windowMigrationPassword := windowMigrationPassword.
    windowMigrationPassword := windowMigrationPassword asValue.

    "/
    "/ extract relevant rdoit settings ...
    "/
    rDoitsEnabled := rDoitLogging := rDoitErrorLogging := false.
    (hasRDoitServer := RDoItServer notNil) ifTrue:[
        RDoItServer isLoaded ifTrue:[
            rDoitsEnabled := RDoItServer serverRunning.
            rDoitLogging := RDoItServer isLogging.
            rDoitErrorLogging := RDoItServer isErrorLogging.
            rDoitErrorDebugging := RDoItServer isErrorCatching not.
            rDoitServerPort := RDoItServer defaultPortNumberOrPath.
        ]
    ].
    org_rDoitsEnabled := rDoitsEnabled.
    org_rDoitLogging := rDoitLogging.
    org_rDoitErrorLogging := rDoitErrorLogging.
    org_rDoitErrorDebugging := rDoitErrorDebugging.
    org_rDoitServerPort := rDoitServerPort.

    rDoitServerPort := rDoitServerPort asValue.
    rDoitsEnabled := rDoitsEnabled asValue.
    rDoitLogging := rDoitLogging asValue.
    rDoitErrorLogging := rDoitErrorLogging asValue.
    rDoitErrorDebugging := rDoitErrorDebugging asValue.

    "/
    "/ extract http-server settings
    "/
    hasHTTPServer := httpServerRunning := false.
    (hasHTTPServer := HTTPServer notNil) ifTrue:[
        HTTPServer isLoaded ifTrue:[
            httpServerRunning := HTTPServer isRunning.
            "/ httpServerFileRoot := HTTPServer fileRoot.
            httpServerHomeURL := HTTPServer homeURL.
            httpServerPort := HTTPServer port.
            httpServerLogFile := HTTPServer logFile.
        ].
    ].
    org_httpServerRunning := httpServerRunning.
    httpServerRunning := httpServerRunning asValue.
    org_httpServerFileRoot := httpServerFileRoot.
    httpServerFileRoot := httpServerFileRoot asValue.
    org_httpServerHomeURL := httpServerHomeURL.
    httpServerHomeURL := httpServerHomeURL asValue.
    org_httpServerPort := httpServerPort.
    httpServerPort := httpServerPort asValue.
    org_httpServerLogFile := httpServerLogFile.
    httpServerLogFile := httpServerLogFile asValue.

    httpServerRunning
        onChangeEvaluate:[
            "/ httpServerFileRoot value:(HTTPServer fileRoot).
            httpServerHomeURL value:(HTTPServer homeURL).
            httpServerPort value:(HTTPServer port).
            httpServerLogFile value:(HTTPServer logFile)
        ].

    hasSwiki := false.
    swikiEnabled := false.
    soapEnabled := false.

    (hasSwiki := PWS::SwikiAction notNil) ifTrue:[
        PWS::SwikiAction isLoaded ifTrue:[
            (HTTPServer notNil and:[HTTPServer isLoaded]) ifTrue:[
                swikiEnabled := (defaultServer notNil and:[defaultServer hasServiceForServiceClass:SwikiAction]).
                swikiRoot := PWS::SwikiAction serverDirectory.
            ]
        ].
    ].
    (hasSoap := SOAP::SoapHttpModule notNil) ifTrue:[
        SOAP::SoapHttpModule isLoaded ifTrue:[
            (HTTPServer notNil and:[HTTPServer isLoaded]) ifTrue:[
                soapEnabled := HTTPServer soapEnabled.
            ]
        ].
    ].

    org_swikiRoot := swikiRoot.
    org_swikiEnabled := swikiEnabled.
    org_soapEnabled := soapEnabled.
    swikiRoot := swikiRoot asValue.
    swikiEnabled := swikiEnabled asValue.
    soapEnabled := soapEnabled asValue.

    swikiEnabled
        onChangeEvaluate:[
            swikiRoot value:(PWS::SwikiAction serverDirectory).
        ].


    allowEmbedded := defaultServer notNil and:[defaultServer hasServiceForServiceClass:HTTPEmbeddedApplicationService].
    org_allowEmbedded := allowEmbedded.
    allowEmbedded := allowEmbedded asValue.

    "/
    "/ osi settings ...
    "/
    osiACSEPresent := OSI::ACSE notNil and:[OSI::ACSE isLoaded].
    osiROSEPresent := OSI::ROSE notNil and:[OSI::ROSE isLoaded].
    osiCMISEPresent := OSI::CMISE notNil and:[OSI::CMISE isLoaded].

    osiACSEPresent ifTrue:[
        osiACSEErrorLogging := OSI::ACSE errorLogging asValue.
        osiACSEConnectionLogging := OSI::ACSE connectionLogging asValue.
        osiACSEDataLogging :=  OSI::ACSE dataLogging asValue.
    ].
    osiROSEPresent ifTrue:[
        osiROSEErrorLogging := OSI::ROSE errorLogging asValue.
        osiROSEInvokationLogging := OSI::ROSE invocationLogging asValue.
        osiROSEResponseLogging :=  OSI::ROSE responseLogging asValue.
    ].
    osiCMISEPresent ifTrue:[
        osiCMISEErrorLogging := OSI::CMISE errorLogging asValue.
        osiCMISEMessageLogging := OSI::CMISE messageLogging asValue.
    ].

    "/
    "/ create a box on those values ...
    "/
    box := DialogBox new.
    box label:(resources string:'Communication settings').

    box addTextLabel:(resources string:'Remote browsing').

    check := box addCheckBox:(resources string:'Remote browsing enabled') on:remoteBrowsingEnabled.
    hasRemoteBrowsingSupport ifFalse:[
        check disable
    ].
    box addHorizontalLine.

    box addTextLabel:(resources string:'Window migration').

    check := box addCheckBox:(resources string:'Window migration enabled') on:windowMigrationEnabled.
    hasWindowMigrationServer ifFalse:[
        check disable
    ].
    check := box addCheckBox:(resources string:'Password check') on:windowMigrationAuthenticate.
    check enableChannel:windowMigrationEnabled.
    hasWindowMigrationServer ifFalse:[
        check disable
    ].
    box leftIndent:20.
    in := box
            addLabelledInputField:(resources string:'Password:')
            adjust:#right
            on:nil
            tabable:true
            separateAtX:0.3.
    in bePassword.
    in model:windowMigrationPassword.
    in acceptChannel:acceptChannel.
    in enableChannel:windowMigrationAuthenticate.
    box leftIndent:0.

    box addHorizontalLine.

    box addTextLabel:'RDoIt Server'.

    check := box addCheckBox:(resources string:'Remote doits enabled') on:rDoitsEnabled.
    hasRDoitServer ifFalse:[
        check disable
    ].
    box leftIndent:20.
    rDoitsEnabled onChangeEvaluate:[ rDoitsEnabled value ifTrue:[
                                        rDoitServerPort value isNil ifTrue:[
                                            rDoitServerPort value:(RDoItServer defaultPortNumberOrPath printString).
                                        ]
                                     ]
                                   ].

    in := box
            addLabelledInputField:(resources string:'Port:')
            adjust:#right
            on:nil
            tabable:true
            separateAtX:0.3.
    "/ in converter:(PrintConverter new initForNumber).
    in model:rDoitServerPort.
    in acceptChannel:acceptChannel.
    in enableChannel:rDoitsEnabled.

    y := box yPosition.
    check := box addCheckBox:(resources string:'Log errors') on:rDoitErrorLogging.
    check width:0.4.
    check enableChannel:rDoitsEnabled.
    hasRDoitServer ifFalse:[
        check disable
    ].
    box yPosition:y.
    check := box addCheckBox:(resources string:'Log requests') on:rDoitLogging.
    check left:0.4; width:0.4.
    check enableChannel:rDoitsEnabled.
    hasRDoitServer ifFalse:[
        check disable
    ].
    check := box addCheckBox:(resources string:'Debug errors') on:rDoitErrorDebugging.
    check width:0.4.
    check enableChannel:rDoitsEnabled.
    hasRDoitServer ifFalse:[
        check disable
    ].
    box leftIndent:0.

    box addHorizontalLine.

    box addTextLabel:'HTTP Server'.

    check := box addCheckBox:(resources string:'Serving HTTP Requests') on:httpServerRunning.
    hasHTTPServer ifFalse:[
        check disable
    ].
    box leftIndent:20.
    in := box
            addLabelledInputField:(resources string:'Port:')
            adjust:#right
            on:nil
            tabable:true
            separateAtX:0.3.
    in converter:(PrintConverter new initForNumber).
    in model:httpServerPort.
    in acceptChannel:acceptChannel.
    in enableChannel:httpServerRunning.

    in := box
            addLabelledInputField:(resources string:'Log File:')
            adjust:#right
            on:httpServerLogFile
            tabable:true
            separateAtX:0.3.
    in acceptChannel:acceptChannel.
    in enableChannel:httpServerRunning.

"/    in := box
"/            addLabelledInputField:(resources string:'File Root:')
"/            adjust:#right
"/            on:httpServerFileRoot
"/            tabable:true
"/            separateAtX:0.3.
"/    in acceptChannel:acceptChannel.
"/    in enableChannel:httpServerRunning.

    in := box
            addLabelledInputField:(resources string:'Home URL:')
            adjust:#right
            on:httpServerHomeURL
            tabable:true
            separateAtX:0.3.
    in acceptChannel:acceptChannel.
    in enableChannel:httpServerRunning.

    check := box addCheckBox:(resources string:'Swiki enabled') on:swikiEnabled.
    hasHTTPServer ifFalse:[
        check disable
    ].
    check enableChannel:httpServerRunning.

"/    box leftIndent:40.

    in := box
            addLabelledInputField:(resources string:'SwikiRoot:')
            adjust:#right
            on:swikiRoot
            tabable:true
            separateAtX:0.3.
    in acceptChannel:acceptChannel.
    in enableChannel:(BlockValue forLogical:httpServerRunning and:swikiEnabled).

    check := box addCheckBox:(resources string:'Allow embedded ST applications') on:allowEmbedded.
    hasHTTPServer ifFalse:[
        check disable
    ].
    check enableChannel:httpServerRunning.

    check := box addCheckBox:(resources string:'Soap enabled') on:soapEnabled.
    hasHTTPServer ifFalse:[
        check disable
    ].
    check enableChannel:httpServerRunning.

    box leftIndent:0.
    box addHorizontalLine.

    box addTextLabel:(resources string:'OSI Protocols (addOn package)').

    y := box yPosition.
    check := box addCheckBox:(resources string:'Log %1 Errors' with:'ACSE') on:osiACSEErrorLogging.
    check width:0.33.
    osiACSEPresent ifFalse:[
        check disable
    ].

    box yPosition:y.
    check := box addCheckBox:(resources string:'Connections') on:osiACSEConnectionLogging.
    osiACSEPresent ifFalse:[
        check disable
    ].
    check left:0.33; width:0.33.

    box yPosition:y.
    check := box addCheckBox:(resources string:'Data Xfer') on:osiACSEDataLogging.
    osiACSEPresent ifFalse:[
        check disable
    ].
    check left:0.66; width:0.34.


    box addVerticalSpace.

    y := box yPosition.
    check := box addCheckBox:(resources string:'Log %1 Errors' with:'ROSE') on:osiROSEErrorLogging.
    osiROSEPresent ifFalse:[
        check disable
    ].
    check width:0.33.

    box yPosition:y.
    check := box addCheckBox:(resources string:'Invoactions') on:osiROSEInvokationLogging.
    osiROSEPresent ifFalse:[
        check disable
    ].
    check left:0.33; width:0.33.

    box yPosition:y.
    check := box addCheckBox:(resources string:'Responses') on:osiROSEResponseLogging.
    osiROSEPresent ifFalse:[
        check disable
    ].
    check left:0.66; width:0.34.

    box addVerticalSpace.

    y := box yPosition.
    check := box addCheckBox:(resources string:'Log %1 Errors' with:'CMISE') on:osiCMISEErrorLogging.
    osiCMISEPresent ifFalse:[
        check disable
    ].
    check width:0.33.

    box yPosition:y.
    check := box addCheckBox:(resources string:'Messages') on:osiCMISEMessageLogging.
    osiCMISEPresent ifFalse:[
        check disable
    ].
    check left:0.33; width:0.33.


    box addHorizontalLine.
    box
        addHelpButtonFor:'Launcher/communicationsSettings.html';
        addAbortAndOkButtons.

    "/
    "/ show the box ...
    "/
    box open.

    "/
    "/ update system settings
    "/
    box accepted ifTrue:[
        acceptChannel value:false; value:true.

        hasRemoteBrowsingSupport ifTrue:[
            remoteBrowsingEnabled := remoteBrowsingEnabled value.
            (remoteBrowsingEnabled ~~ org_remoteBrowsingEnabled) ifTrue:[
                remoteBrowsingEnabled ~~ SmalltalkShareServer serverRunning ifTrue:[
                    remoteBrowsingEnabled ifFalse:[
                        SmalltalkShareServer killAll
                    ] ifTrue:[
                        SmalltalkShareServer start.
                        "/ must wait a bit; give it a chance to
                        "/ really start (before checking)
                        Delay waitForSeconds:0.5.
                        SmalltalkShareServer serverRunning ifFalse:[
                            self warn:'SmalltalkShareServer startup failed (see stderr).'
                        ]
                    ]
                ].
            ]
        ].

        hasWindowMigrationServer ifTrue:[
            windowMigrationEnabled := windowMigrationEnabled value.
            windowMigrationAuthenticate := windowMigrationAuthenticate value.
            windowMigrationPassword := windowMigrationPassword value.
            (windowMigrationEnabled ~~ org_windowMigrationEnabled
            or:[windowMigrationAuthenticate ~~ org_windowMigrationAuthenticate
            or:[windowMigrationPassword ~~ org_windowMigrationPassword]])  ifTrue:[
                windowMigrationAuthenticate ~~ org_windowMigrationAuthenticate ifTrue:[
                    windowMigrationAuthenticate ifFalse:[
                        WindowMigrationServer password:nil
                    ] ifTrue:[
                        WindowMigrationServer password:windowMigrationPassword
                    ].
                ].
                windowMigrationEnabled ~~ WindowMigrationServer serverRunning ifTrue:[
                    windowMigrationEnabled ifFalse:[
                        WindowMigrationServer stop
                    ] ifTrue:[
                        WindowMigrationServer start.
                        "/ must wait a bit; give it a chance to
                        "/ really start (before checking)
                        Delay waitForSeconds:0.5.
                        WindowMigrationServer serverRunning ifFalse:[
                            self warn:'WindowMigrationServer startup failed (see stderr).'
                        ]
                    ]
                ].
            ]
        ].

        hasRDoitServer ifTrue:[
            (rDoitLogging value ~~ org_rDoitLogging
            or:[rDoitErrorDebugging value ~~ org_rDoitErrorDebugging
            or:[rDoitErrorLogging value ~~ org_rDoitErrorLogging
            or:[rDoitsEnabled value ~~ org_rDoitsEnabled
            or:[rDoitServerPort value ~~ org_rDoitServerPort]]]]) ifTrue:[
                (Integer readFrom:rDoitServerPort value onError:nil) isNil ifTrue:[
                    RDoItServer defaultPortNumberOrPath:rDoitServerPort value.
                ] ifFalse:[
                    RDoItServer defaultPortNumberOrPath:(Integer readFrom:rDoitServerPort value onError:nil).
                ].
                RDoItServer logging:(rDoitLogging value).
                RDoItServer errorLogging:(rDoitErrorLogging value).
                RDoItServer errorCatching:(rDoitErrorDebugging value not).
                rDoitsEnabled := rDoitsEnabled value.
                rDoitsEnabled ~~ RDoItServer serverRunning ifTrue:[
                    rDoitsEnabled ifFalse:[
                        RDoItServer stop
                    ] ifTrue:[
                        RDoItServer start.
                        "/ must wait a bit; give it a chance to
                        "/ really start (before checking)
                        Delay waitForSeconds:0.5.
                        RDoItServer serverRunning ifFalse:[
                            self warn:'RDoit startup failed (see stderr).'
                        ]
                    ]
                ].
            ].
        ].

        (hasHTTPServer and:[HTTPServer isLoaded]) ifTrue:[
            httpServerPort := httpServerPort value.
            org_httpServerPort ~= httpServerPort ifTrue:[
"/                HTTPServer port:httpServerPort.
            ].

            httpServerFileRoot := httpServerFileRoot value.
            httpServerFileRoot size == 0 ifTrue:[
                httpServerFileRoot := nil
            ].
            org_httpServerFileRoot ~= httpServerFileRoot ifTrue:[
"/                HTTPServer fileRoot:httpServerFileRoot.
            ].

            httpServerLogFile := httpServerLogFile value.
            httpServerLogFile size == 0 ifTrue:[
                httpServerLogFile := nil
            ].
"/            org_httpServerLogFile ~= httpServerLogFile ifTrue:[
"/                HTTPServer logFile:httpServerLogFile.
"/            ].

            httpServerHomeURL := httpServerHomeURL value.
            httpServerHomeURL size == 0 ifTrue:[
                httpServerHomeURL := nil
            ].
            org_httpServerHomeURL ~= httpServerHomeURL ifTrue:[
"/                HTTPServer defaultHomeURL:httpServerHomeURL.
            ].

            httpServerRunning value ~~ org_httpServerRunning ifTrue:[
                httpServerRunning value ifTrue:[
                    HTTPServer startServer
                ] ifFalse:[
                    HTTPServer stopServer
                ]
            ].
        ].

        hasSwiki ifTrue:[
            swikiRoot := swikiRoot value.
            swikiRoot size == 0 ifTrue:[
                swikiRoot := nil
            ].
            org_swikiRoot ~= swikiRoot ifTrue:[
                PWS::ServerAction serverDirectory:swikiRoot.
            ].

            swikiEnabled value ~~ org_swikiEnabled ifTrue:[
                swikiEnabled value ifTrue:[
                    HTTPServer setupMySwiki
                ] ifFalse:[
                    HTTPServer disableMySwiki
                ]
            ].
            allowEmbedded value ~~ org_allowEmbedded ifTrue:[
                defaultServer notNil ifTrue:[
                    HTTPEmbeddedApplicationService registerServiceOn:defaultServer.
                ].
            ].
        ].
        hasSoap ifTrue:[
            soapEnabled value ~~ org_soapEnabled ifTrue:[
                defaultServer notNil ifTrue:[
                    soapEnabled value ifTrue:[
                        defaultServer setupSoap
                    ] ifFalse:[
                        defaultServer disableSoap
                    ]
                ]
            ].
        ].

        osiACSEPresent ifTrue:[
            OSI::ACSE errorLogging:osiACSEErrorLogging value.
            OSI::ACSE connectionLogging:osiACSEConnectionLogging value.
            OSI::ACSE dataLogging:osiACSEDataLogging value.
        ].
        osiROSEPresent ifTrue:[
            OSI::ROSE errorLogging:osiROSEErrorLogging value.
            OSI::ROSE invocationLogging:osiROSEInvokationLogging value.
            OSI::ROSE responseLogging:osiROSEResponseLogging value.
        ].
        osiCMISEPresent ifTrue:[
            OSI::CMISE errorLogging:osiCMISEErrorLogging value.
            OSI::CMISE messageLogging:osiCMISEMessageLogging value.
        ].
    ].
    box destroy

    "Modified: / 28.6.1999 / 15:44:35 / stefan"
    "Modified: / 20.1.2000 / 19:14:18 / cg"
!

compilerSettings
    "open a dialog on compiler related settings.
     Obsoleted by the settings application"

    |box warnings warnSTX warnUnderscore warnDollar warnParagraph warnOldStyle warnUnusedVars
     allowDollar allowParagraph allowUnderscore allowSqueakExtensions allowQualifiedNames
     allowDolphinExtensions allowOldStyleAssignment allowReservedWordsAsSelectors
     immutableArrays
     warnSTXBox warnUnderscoreBox warnOldStyleBox warnCommonMistakes warnCommonMistakesBox
     warnCompatibility warnCompatibilityBox warnDollarBox warnParagraphBox warnUnusedVarsBox
     stcCompilation compilationList stcCompilationOptions
     historyLines fullHistoryUpdate
     catchMethodRedefs catchClassRedefs keepSourceOptions keepSource
     constantFoldingOptions constantFolding justInTimeCompilation
     warnEnabler check component oldIndent supportsJustInTimeCompilation y
     y2 fullDebugSupport yMax
     compileLazy loadBinaries canLoadBinaries strings idx
     resources stcSetupButt|

    resources := self owningClass classResources.

    canLoadBinaries := ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles].
    loadBinaries := Smalltalk loadBinaries asValue.
    compileLazy := Autoload compileLazy asValue.

    warnings := ParserFlags warnings asValue.

    warnSTX := ParserFlags warnSTXSpecials asValue.
    warnUnderscore := ParserFlags warnUnderscoreInIdentifier asValue.
    warnDollar := ParserFlags warnDollarInIdentifier asValue.
    warnParagraph := ParserFlags warnParagraphInIdentifier asValue.
    warnOldStyle := ParserFlags warnOldStyleAssignment asValue.
    warnCommonMistakes := ParserFlags warnCommonMistakes asValue.
    warnCompatibility := ParserFlags warnPossibleIncompatibilities asValue.
    warnUnusedVars := ParserFlags warnUnusedVars asValue.
    allowUnderscore := ParserFlags allowUnderscoreInIdentifier asValue.
    allowDollar := ParserFlags allowDollarInIdentifier asValue.
    allowParagraph := ParserFlags allowParagraphInIdentifier asValue.
    allowSqueakExtensions := ParserFlags allowSqueakExtensions asValue.
    allowDolphinExtensions := ParserFlags allowDolphinExtensions asValue.
    allowQualifiedNames := ParserFlags allowQualifiedNames asValue.
    allowOldStyleAssignment := ParserFlags allowOldStyleAssignment asValue.
    allowReservedWordsAsSelectors := ParserFlags allowReservedWordsAsSelectors asValue.
    immutableArrays := ParserFlags arraysAreImmutable asValue.

    constantFoldingOptions := #( nil #level1 #level2 #full ).
    constantFolding := SelectionInList new list:(resources array:#('disabled' 'level1 (always safe)' 'level2 (usually safe)' 'full')).
    constantFolding selectionIndex:3.

    stcCompilationOptions := #(default never).
    strings := #('primitive code only' 'never').
    idx := (stcCompilationOptions indexOf:(ParserFlags stcCompilation) ifAbsent:1).

    stcCompilation := SelectionInList new list:(resources array:strings).
    stcCompilation selectionIndex:idx.

    (supportsJustInTimeCompilation := ObjectMemory supportsJustInTimeCompilation)
    ifTrue:[
        justInTimeCompilation := ObjectMemory justInTimeCompilation.
        fullDebugSupport := ObjectMemory fullSingleStepSupport.
    ] ifFalse:[
        justInTimeCompilation := false.
        fullDebugSupport := (ParserFlags fullLineNumberInfo) asValue.
    ].
    justInTimeCompilation := justInTimeCompilation asValue.
    fullDebugSupport := fullDebugSupport asValue.

    catchMethodRedefs := Class catchMethodRedefinitions asValue.
    catchClassRedefs := Class catchClassRedefinitions asValue.
    historyLines := HistoryManager notNil and:[HistoryManager isLoaded and:[HistoryManager isActive]].
    historyLines ifFalse:[
        fullHistoryUpdate := false asValue
    ] ifTrue:[
        fullHistoryUpdate := HistoryManager fullHistoryUpdate asValue.
    ].
    historyLines := historyLines asValue.

    keepSourceOptions := #( keep reference absReference sourceReference discard ).
    keepSource := SelectionInList new
                        list:(resources array:#('Keep as String' 'Reference to Filename' 'Reference to Full Path' 'Append and Ref in `st.src''' 'Discard' )).
    keepSource selectionIndex:1.

    warnEnabler := [
              warnings value ifTrue:[
                warnSTXBox enable.
                warnOldStyleBox enable.
                warnCommonMistakesBox enable.
                warnCompatibilityBox enable.
                warnUnusedVarsBox enable.
                warnUnderscoreBox enabled:allowUnderscore.
                warnDollarBox enabled:allowDollar.
                warnParagraphBox enabled:allowParagraph.
              ] ifFalse:[
                warnSTXBox disable.
                warnUnderscoreBox disable.
                warnDollarBox disable.
                warnOldStyleBox disable.
                warnCommonMistakesBox disable.
                warnCompatibilityBox disable.
                warnUnusedVarsBox disable.
                warnParagraphBox disable.
              ]].

    warnings onChangeEvaluate:warnEnabler.
    allowUnderscore onChangeEvaluate:warnEnabler.
    allowDollar onChangeEvaluate:warnEnabler.
    allowParagraph onChangeEvaluate:warnEnabler.
"/    allowSqueakExtensions onChangeEvaluate:warnEnabler.
"/    allowQualifiedNames onChangeEvaluate:warnEnabler.

    box := DialogBox new.
    box label:(resources string:'Compiler Settings').

    y := box yPosition.
    check := box addCheckBox:(resources string:'Catch Method Redefinitions') on:catchMethodRedefs.
    check width:0.5.

    box yPosition:y.
    check := box addCheckBox:(resources string:'Catch Class Redefinitions') on:catchClassRedefs.
    check left:0.5; width:0.5.

    y := box yPosition.
    check := box addCheckBox:(resources string:'Keep History Line in Methods') on:historyLines.
    check width:0.5.
    HistoryManager isNil ifTrue:[check disable].
    box yPosition:y.
    check := box addCheckBox:(resources string:'Keep Full Class History') on:fullHistoryUpdate.
    check left:0.5; width:0.5.
    HistoryManager isNil ifTrue:[check disable] ifFalse:[check enableChannel:historyLines].

    box addPopUpList:(resources string:'FileIn Source Mode:') on:keepSource.
    keepSource selectionIndex:( keepSourceOptions indexOf:(ClassCategoryReader sourceMode) ifAbsent:1).

    box addHorizontalLine.

    box addCheckBox:(resources string:'Lazy Compilation when Autoloading') on:compileLazy.
    check := box addCheckBox:(resources string:'If Present, Load Binary Objects when Autoloading') on:loadBinaries.
    canLoadBinaries ifFalse:[
        loadBinaries value:false.
        check disable
    ].
    supportsJustInTimeCompilation ifTrue:[
        component := box
                        addCheckBox:(resources string:'Just in Time Compilation to Machine Code')
                        on:justInTimeCompilation.
    ].

    box addHorizontalLine.

    ObjectFileLoader notNil ifTrue:[
        compilationList := box addPopUpList:(resources string:'Stc Compilation to Machine Code') on:stcCompilation.
        stcCompilation selectionIndex:( stcCompilationOptions indexOf:(Compiler stcCompilation) ifAbsent:1).
        stcSetupButt := box addComponent:(Button label:(resources string:'Stc Compilation Parameters...')
                   action:[|manager|

                           self stcCompilerSettings.
                          ]).

        box addHorizontalLine.

        "/ if there is no compiler around,
        "/ change to compile nothing, and disable the checkBoxes
        Compiler canCreateMachineCode ifFalse:[
            stcCompilation selectionIndex:(3 min:stcCompilationOptions size).
            compilationList disable.
        ].
    ].

    y := box yPosition.

    component := box addCheckBox:(resources string:'Allow Underscore in Identifiers') on:allowUnderscore.
    component width:0.4.

    component := box addCheckBox:(resources string:'Allow Dollar in Identifiers') on:allowDollar.
    component width:0.4.

    component := box addCheckBox:(resources string:'Allow Paragraph in Identifiers') on:allowParagraph.
    component width:0.4.

    component := box addCheckBox:(resources string:'Allow VW3 QualifiedNames') on:allowQualifiedNames.
    component width:0.4.

    component := box addCheckBox:(resources string:'Allow Squeak Extensions') on:allowSqueakExtensions.
    component width:0.4.

    component := box addCheckBox:(resources string:'Allow Dolphin Extensions') on:allowDolphinExtensions.
    component width:0.4.

    y2 := box yPosition.

    box yPosition:y.
    box leftIndent:0.

    component :=box addPopUpList:(resources string:'Constant Folding:') on:constantFolding.
    component superView left:0.5; width:0.5.
    constantFolding selectionIndex:( constantFoldingOptions indexOf:(Compiler foldConstants) ifAbsent:1).

    component := box addCheckBox:(resources string:'Allow OldStyle Assignment (_)') on:allowOldStyleAssignment.
    component left:0.5; width:0.4.

    component := box addCheckBox:(resources string:'Allow Reserved Words as Selector (self)') on:allowReservedWordsAsSelectors.
    component left:0.5; width:0.4.

    component := box addCheckBox:(resources string:'Full Debug Info') on:fullDebugSupport.
    component left:0.5; width:0.4.

    component := box addCheckBox:(resources string:'Literal Arrays are Immutable') on:immutableArrays.
    component left:0.5; width:0.4.

    box yPosition:(box yPosition max:y2).


    box addHorizontalLine.

    box addCheckBox:(resources string:'Warnings') on:warnings.
"/    box addVerticalSpace.
    oldIndent := box leftIndent.
    box leftIndent:30.

    y := box yPosition.

    warnSTXBox := box addCheckBox:(resources string:'ST/X Extensions') on:warnSTX.
    warnSTXBox width:0.4.

    warnUnderscoreBox := box addCheckBox:(resources string:'Underscores in Identifiers') on:warnUnderscore.
    warnUnderscoreBox width:0.4.

    warnDollarBox := box addCheckBox:(resources string:'Dollars in Identifiers') on:warnDollar.
    warnDollarBox width:0.4.

    warnParagraphBox := box addCheckBox:(resources string:'Paragraphs in Identifiers') on:warnParagraph.
    warnParagraphBox width:0.4.

    warnUnusedVarsBox := box addCheckBox:(resources string:'Unused Method Variables') on:warnUnusedVars.
    warnUnusedVarsBox width:0.4.

    yMax := box yPosition.

    box yPosition:y.
    box leftIndent:0.
    warnOldStyleBox := box addCheckBox:(resources string:'OldStyle Assignment') on:warnOldStyle.
    warnOldStyleBox left:0.5; width:0.4.

    warnCommonMistakesBox := box addCheckBox:(resources string:'Common Mistakes') on:warnCommonMistakes.
    warnCommonMistakesBox left:0.5; width:0.4.

    warnCompatibilityBox := box addCheckBox:(resources string:'Possible Incompatibilities') on:warnCompatibility.
    warnCompatibilityBox left:0.5; width:0.4.

    box leftIndent:oldIndent.
    box yPosition:(yMax max: box yPosition).

    box addHorizontalLine.
    box
        addHelpButtonFor:'Launcher/compilerSettings.html';
        addAbortAndOkButtons.

    warnEnabler value.
    box open.

    box accepted ifTrue:[
        HistoryManager notNil ifTrue:[
            HistoryManager fullHistoryUpdate:fullHistoryUpdate value.
            historyLines value ifTrue:[
                HistoryManager activate
            ] ifFalse:[
                HistoryManager deactivate
            ].
        ].
        Class catchMethodRedefinitions:catchMethodRedefs value.
        Class catchClassRedefinitions:catchClassRedefs value.
        ClassCategoryReader sourceMode:(keepSourceOptions at:keepSource selectionIndex).
        Compiler warnings:warnings value.
        Compiler warnSTXSpecials:warnSTX value.
        Compiler warnOldStyleAssignment:warnOldStyle value.
        Compiler warnUnderscoreInIdentifier:warnUnderscore value.
        Compiler warnDollarInIdentifier:warnDollar value.
        Compiler warnCommonMistakes:warnCommonMistakes value.
        Compiler warnPossibleIncompatibilities:warnCompatibility value.
        Compiler warnUnusedVars:warnUnusedVars value.
        Compiler allowUnderscoreInIdentifier:allowUnderscore value.
        Compiler allowDollarInIdentifier:allowDollar value.
        Compiler allowSqueakExtensions:allowSqueakExtensions value.
        Compiler allowDolphinExtensions:allowDolphinExtensions value.
        Compiler allowQualifiedNames:allowQualifiedNames value.
        Compiler allowOldStyleAssignment:allowOldStyleAssignment value.
        Compiler allowReservedWordsAsSelectors:allowReservedWordsAsSelectors value.

        Compiler arraysAreImmutable:immutableArrays value.
        ParserFlags lineNumberInfo:(fullDebugSupport value ifTrue:[#full] ifFalse:[true]).

        ParserFlags stcCompilation:(stcCompilationOptions at:stcCompilation selectionIndex).
        Compiler foldConstants:(constantFoldingOptions at:constantFolding selectionIndex).

        supportsJustInTimeCompilation ifTrue:[
            justInTimeCompilation := justInTimeCompilation value.
            justInTimeCompilation ifTrue:[
                Smalltalk allMethodsDo:[:m | m checked:false].
            ].
            ObjectMemory justInTimeCompilation:justInTimeCompilation.
            ObjectMemory fullSingleStepSupport:fullDebugSupport value.
        ].
        Autoload compileLazy:compileLazy value.
        Smalltalk loadBinaries:loadBinaries value.
    ].
    box destroy

"
    self compilerSettings
"

    "Modified: / 10-09-1995 / 19:19:18 / claus"
    "Modified: / 09-09-1996 / 22:42:47 / stefan"
    "Modified: / 16-11-2016 / 22:37:24 / cg"
!

displaySettings
    "open a dialog on display related settings.
     Obsoleted by the settings application."

    |box listOfSizes sizeInfos
     sizes sizeNames sizeList sizeX sizeY deepIcons
     isColorMonitor useFixPalette useFixGrayPalette idx ditherStyles ditherSyms ditherList
     y component screen visual clipEncodings clipEncodingSyms clipEncodingList resources
     |

    resources := self owningClass classResources.

    listOfSizes := resources at:'LIST_OF_OFFERED_SCREEN_SIZES' default:#default.
    listOfSizes == #default ifTrue:[
        "/ nothing in resource file; offer at least some.
        sizeInfos := #(
                           ( '11.3'' (235mm x 175mm) LCD'   (235 175)    )
                           ( '17''   (325mm x 245mm)'       (325 245)    )
                           ( '19''   (340mm x 270mm)'       (340 270)    )
                           ( '20''   (350mm x 280mm)'       (350 280)    )
                           ( '21''   (365mm x 285mm)'       (365 285)    )
                       ).
    ] ifFalse:[
        sizeInfos := resources array:listOfSizes.
    ].
    sizeNames := sizeInfos collect:[:entry | entry at:1].
    sizes := sizeInfos collect:[:entry | entry at:2].

    screen := Screen current.
    visual := screen visualType.

    isColorMonitor := screen hasColors asValue.
    deepIcons := screen supportsDeepIcons asValue.
    useFixPalette := screen fixColors notNil asValue.
    useFixGrayPalette := screen fixGrayColors notNil asValue.

    sizeList := SelectionInList with:sizeNames.
    sizeX := screen widthInMillimeter asValue.
    sizeY := screen heightInMillimeter asValue.

    clipEncodingSyms := #(nil #iso8859 #jis #jis7 #sjis #euc #big5).
    clipEncodings := resources array:#('untranslated' 'iso8859' 'jis' 'jis7' 'shift-JIS' 'EUC' 'big5').
    clipEncodingList := SelectionInList new.
    clipEncodingList list:clipEncodings.
    clipEncodingList selectionIndex:(clipEncodingSyms indexOf:screen clipboardEncoding ifAbsent:1).

    ditherList := SelectionInList new.

    (visual == #StaticGray or:[visual == #GrayScale]) ifTrue:[
        ditherStyles := #('threshold' 'ordered dither' 'error diffusion').
        ditherSyms := #(threshold ordered floydSteinberg).
    ] ifFalse:[
        visual ~~ #TrueColor ifTrue:[
            ditherStyles := #('nearest color' 'error diffusion').
            ditherSyms := #(ordered floydSteinberg).
        ]
    ].
    ditherSyms notNil ifTrue:[
        ditherList list:ditherStyles.
        ditherList selectionIndex:(ditherSyms indexOf:(Image ditherAlgorithm) ifAbsent:#threshold).
    ].

    box := DialogBox new.
    box label:(resources string:'Display Screen Settings').

    box addTextLabel:(resources string:'Actual Visible Screen Area:') adjust:#left.

    (box addPopUpList:(resources string:'Common Sizes:') on:sizeList)
        label:'monitor size'.

    idx := sizes findFirst:[:entry |
                                ((entry at:1) = sizeX value)
                                and:[((entry at:2) = sizeY value)]
                           ].
    idx ~~ 0 ifTrue:[
        sizeList selectionIndex:idx
    ].

    sizeList onChangeEvaluate:[
                                        |idx|

                                        idx := sizeList selectionIndex.
                                        sizeX value:((sizes at:idx) at:1).
                                        sizeY value:((sizes at:idx) at:2).
                                    ].

    y := box yPosition.
    component := box addTextLabel:(resources string:'Screen Size:').
    component width:0.3; adjust:#right; borderWidth:0.

    box yPosition:y.
    component := box addInputFieldOn:nil tabable:true.
    component width:0.25; left:0.3;
              immediateAccept:false; acceptOnLeave:false;
              cursorMovementWhenUpdating:#beginOfLine;
              converter:(PrintConverter new initForInteger);
              model:sizeX.

    box yPosition:y.
    component := box addTextLabel:(' x ').
    component width:0.1; left:0.55; adjust:#center; borderWidth:0.

    box yPosition:y.
    component := box addInputFieldOn:nil tabable:true.
    component width:0.25; left:0.65;
              immediateAccept:false; acceptOnLeave:false;
              cursorMovementWhenUpdating:#beginOfLine;
              converter:(PrintConverter new initForInteger);
              model:sizeY.

    box yPosition:y.
    component := box addTextLabel:('(mm)').
    component width:0.1; left:0.9; adjust:#center; borderWidth:0.

    box addVerticalSpace; addHorizontalLine; addVerticalSpace.

    (box addTextLabel:(resources string:'Screen: Depth: %1 Visual: %2  (%3)'
                                 with:screen depth printString
                                 with:screen visualType
                                 with:screen serverVendor))
        adjust:#left.

    box addVerticalSpace; addHorizontalLine; addVerticalSpace.

    box addCheckBox:(resources string:'Color Monitor') on:isColorMonitor.

    visual == #PseudoColor ifTrue:[
        box addVerticalSpace.
        component := box addCheckBox:(resources string:'Use Fix Color Palette %1' with:'(4x8x4)') on:useFixPalette.

        box addVerticalSpace.
        component := box addCheckBox:(resources string:'Use Fix Gray Color Palette %1' with:'(32)') on:useFixGrayPalette.
    ].

    ditherSyms notNil ifTrue:[
        box addVerticalSpace.
        component := box addPopUpList:(resources string:'Image Display:') on:ditherList.
        component defaultLabel:'image display'.
        component superView horizontalLayout:#leftSpace.
    ].

    box addVerticalSpace.
    box addCheckBox:(resources string:'Allow Colored/Grayscale Icons') on:deepIcons.

    box addVerticalSpace; addHorizontalLine; addVerticalSpace.

    component := box addPopUpList:(resources string:'ClipBoard Encoding:') on:clipEncodingList.
    component superView horizontalLayout:#leftSpace.

    box addHorizontalLine.
    box
        addHelpButtonFor:'Launcher/screenSettings.html';
        addAbortAndOkButtons.
    box open.

    box accepted ifTrue:[
        Image flushDeviceImages.

        screen visualType == #PseudoColor ifTrue:[
            useFixPalette value ifTrue:[
                Color colorAllocationFailSignal handle:[:ex |
                    self warn:'Could not allocate colors.'.
                ] do:[
                    Color getColorsRed:4 green:8 blue:4 on:screen
                ]
            ] ifFalse:[
                screen releaseFixColors
            ].

            useFixGrayPalette value ifTrue:[
                Color colorAllocationFailSignal handle:[:ex |
                    self warn:'Could not allocate colors.'.
                ] do:[
                    Color getGrayColors:32 on:screen
                ]
            ] ifFalse:[
                screen releaseFixGrayColors
            ]
        ].
        screen hasColors:isColorMonitor value.
        screen widthInMillimeter:sizeX value.
        screen heightInMillimeter:sizeY value.

        screen supportsDeepIcons:deepIcons value.
        ditherSyms notNil ifTrue:[
            Image ditherAlgorithm:(ditherSyms at:ditherList selectionIndex).
        ].

        WindowGroup activeGroup withWaitCursorDo:[
            View defaultStyle:(View defaultStyle).
        ].

        screen clipboardEncoding:(clipEncodingSyms at:clipEncodingList selectionIndex).
    ].
    box destroy

    "Modified: / 9.9.1996 / 22:43:04 / stefan"
    "Modified: / 20.5.1999 / 18:35:21 / cg"
!

editSettings
    "open a dialog on edit settings"
    "OBSOLETE - this functionality is no longer used - see AbstractSettingsApplication"

    |box st80EditMode st80SelectMode resources
     tabsIs4 prevTabsIs4 searchDialogIsModal startTextDragWithControl
     currentPrefs|

    currentPrefs := UserPreferences current.
    resources := self owningClass classResources.

    "/
    "/ extract relevant system settings ...
    "/
    st80EditMode := currentPrefs st80EditMode asValue.
    st80SelectMode := currentPrefs st80SelectMode asValue.
    prevTabsIs4 := (ListView userDefaultTabPositions = ListView tab4Positions).
    tabsIs4 := prevTabsIs4 asValue.
    searchDialogIsModal := currentPrefs searchDialogIsModal asValue.
    startTextDragWithControl := currentPrefs startTextDragWithControl asValue.

    "/
    "/ create a box on those values ...
    "/
    box := DialogBox new.
    box label:(resources string:'Edit settings').

    box addCheckBox:(resources string:'Cursor has ST80 Line-end Behavior') on:st80EditMode.
    box addCheckBox:(resources string:'Double Click Select Behavior as in ST80') on:st80SelectMode.
    box addCheckBox:(resources string:'Tab Stops in Multiples of 4') on:tabsIs4.
    box addCheckBox:(resources string:'SearchBox is Modal') on:searchDialogIsModal.
    box addCheckBox:(resources string:'CTRL-Key to Start TextDrag') on:startTextDragWithControl.

    box addHorizontalLine.

    box
        addHelpButtonFor:'Launcher/editSettings.html';
        addAbortAndOkButtons.

    "/
    "/ show the box ...
    "/
    box open.

    "/
    "/ update system settings
    "/
    box accepted ifTrue:[
        currentPrefs st80EditMode:(st80EditMode value).
        currentPrefs st80SelectMode:(st80SelectMode value).
        tabsIs4 value ~~ prevTabsIs4 ifTrue:[
            ListView userDefaultTabPositions:(tabsIs4 value
                                                ifTrue:[ListView tab4Positions]
                                                ifFalse:[ListView tab8Positions]).
            ListView allSubInstancesDo:[:eachKindOfListView |
                tabsIs4 value
                    ifTrue:[eachKindOfListView setTab4]
                    ifFalse:[eachKindOfListView setTab8]
            ].
        ].
        currentPrefs searchDialogIsModal:searchDialogIsModal value.
        currentPrefs startTextDragWithControl:startTextDragWithControl value.
    ].
    box destroy

    "Created: / 06-01-1999 / 14:12:09 / cg"
    "Modified: / 03-07-2006 / 16:35:03 / cg"
!

fontSettingsFor:requestor
    "open a dialog on font related settings"

    (self fontBoxForEncoding:nil) ifTrue:[
        requestor reopenLauncher.
    ]
"
    self fontSettingsFor:nil
"
    "Created: 26.2.1996 / 22:52:51 / cg"
    "Modified: 8.1.1997 / 14:52:49 / cg"
!

javaSettings
    "open a dialog on settings related to the java subsystem.
     Obsoleted by the settings application."

    |box audio javaHome classPath oldJavaHome oldClassPath resources component
     extraFileSecurityChecks extraSocketSecurityChecks
     supportsJustInTimeCompilation
     javaJustInTimeCompilation javaNativeCodeOptimization
     showJavaByteCode exceptionDebug nullPointerExceptionDebug pathSep|

    resources := self owningClass classResources.

    audio := JavaVM audioEnabled asValue.
    extraFileSecurityChecks := JavaVM fileOpenConfirmation asValue.
    extraSocketSecurityChecks := JavaVM socketConnectConfirmation asValue.
    (supportsJustInTimeCompilation := ObjectMemory supportsJustInTimeCompilation) ifTrue:[
        javaJustInTimeCompilation := ObjectMemory javaJustInTimeCompilation asValue.
        javaNativeCodeOptimization := ObjectMemory javaNativeCodeOptimization asValue.
    ] ifFalse:[
        javaJustInTimeCompilation := javaNativeCodeOptimization := false
    ].
    showJavaByteCode := JavaMethod forceByteCodeDisplay asValue.
    exceptionDebug := JavaVM exceptionDebug asValue.
    nullPointerExceptionDebug := JavaVM nullPointerExceptionDebug asValue.

    classPath := (Java classPath ? '').
    OperatingSystem isUNIXlike ifTrue:[
        pathSep := $;.
    ] ifFalse:[
        pathSep := $:.
    ].
    classPath := (classPath asStringWith:pathSep) asValue.
    oldClassPath := classPath copy.
    classPath := classPath asValue.

    javaHome := (Java javaHome ? '').
    oldJavaHome := javaHome copy.
    javaHome := javaHome asValue.

    box := DialogBox new.
    box label:(resources string:'Java').

    box addCheckBox:(resources string:'Audio Enabled') on:audio.
    box addCheckBox:(resources string:'Confirm file open for write') on:extraFileSecurityChecks.
    box addCheckBox:(resources string:'Confirm socket connect') on:extraSocketSecurityChecks.
    box addCheckBox:(resources string:'Debug Exceptions') on:exceptionDebug.
    box addCheckBox:(resources string:'Debug Null Pointer Exceptions') on:nullPointerExceptionDebug.
    box addHorizontalLine.
    supportsJustInTimeCompilation ifTrue:[
        box
            addCheckBox:(resources string:'java just in time compilation to machine code')
            on:javaJustInTimeCompilation.
        box
            addCheckBox:(resources string:'optimize native code')
            on:javaNativeCodeOptimization.
    ].
    box addHorizontalLine.
    box addCheckBox:(resources string:'Display java byteCode (i.e. not source)') on:showJavaByteCode.
    box addHorizontalLine.
    component := box
                    addLabelledInputField:(resources string:'classPath:')
                    adjust:#right
                    on:classPath
                    tabable:true
                    separateAtX:0.3.
    component acceptOnLeave:false.
    component := box
                    addLabelledInputField:(resources string:'java home:')
                    adjust:#right
                    on:javaHome
                    tabable:true
                    separateAtX:0.3.
    component acceptOnLeave:false.

    box addVerticalSpace.
    box addComponent:(Button
                        label:(resources string:'Reinit VM now')
                        action:[
                                box windowGroup withWaitCursorDo:[
"/                                    Java classPath size == 0 ifTrue:[
"/                                        Java initialize.
"/                                    ].
"/                                    Java classPath size == 0 ifTrue:[
"/                                        self warn:'No JDK found'.
"/                                    ] ifFalse:[
                                        JavaVM initializeVM
"/                                    ]
                                ]
                               ]).

    box addComponent:(Button
                        label:(resources string:'Remove all Java classes now')
                        action:[
                                box windowGroup withWaitCursorDo:[
                                    Java flushAllJavaResources
                                ]
                               ]).

    "/ box addHorizontalLine.

"/    box addHelpButtonFor:'Launcher/javaSettings.html'.
    box addAbortAndOkButtons.
    box open.

    box accepted ifTrue:[
        classPath value ~= oldClassPath ifTrue:[
            OperatingSystem isUNIXlike ifTrue:[
                classPath := (classPath value asCollectionOfSubstringsSeparatedBy:$:)
            ] ifFalse:[
                classPath := (classPath value asCollectionOfSubstringsSeparatedBy:$;)
            ].
            Java classPath:classPath
        ].
        Java javaHome:javaHome value.

        JavaMethod forceByteCodeDisplay:showJavaByteCode value.
        JavaVM audioEnabled:audio value.
        JavaVM exceptionDebug:exceptionDebug value.
        JavaVM nullPointerExceptionDebug:nullPointerExceptionDebug value.
        JavaVM fileOpenConfirmation: extraFileSecurityChecks value.
        JavaVM socketConnectConfirmation: extraSocketSecurityChecks value.

        javaJustInTimeCompilation value ~~ ObjectMemory javaJustInTimeCompilation ifTrue:[
            ObjectMemory javaJustInTimeCompilation:javaJustInTimeCompilation value.
            javaJustInTimeCompilation value ifTrue:[
                JavaMethod allSubInstancesDo:[:m | m checked:false].
            ].
        ].
        javaNativeCodeOptimization value ~~ ObjectMemory javaNativeCodeOptimization ifTrue:[
            ObjectMemory javaNativeCodeOptimization:javaNativeCodeOptimization value.
        ].
    ].
    box destroy
"
    self javaSettings
"
    "Created: / 18.7.1998 / 22:32:58 / cg"
    "Modified: / 27.1.1999 / 20:16:03 / cg"
!

keyboardSettings
    "open a dialog on keyboard related settings.
     Obsoleted by the settings application"

    |mappings listOfRawKeys listOfFunctions
     box l
     list1 list2 listView1 listView2
     frame selectionForwarder macroForwarder macroTextView y resources|

    resources := self owningClass classResources.

    mappings := Screen current keyboardMap.

    listOfRawKeys := (mappings keys collect:[:key | key asString] as:Array) sort.
    listOfFunctions := (mappings values asSet collect:[:key | key asString] as:Array) sort.

    selectionForwarder := Plug new.
    selectionForwarder respondTo:#showFunction
                  with:[
                        |raw|
                        raw := list1 selection.
                        list2 retractInterestsFor:selectionForwarder.
                        list2 selection:(mappings at:raw asSymbol) asString.
                        list2 onChangeSend:#showRawKey to:selectionForwarder.
                       ].
    selectionForwarder respondTo:#showRawKey
                  with:[
                        |f raw|

                        f := list2 selection.
                        list1 retractInterestsFor:selectionForwarder.
                        raw := mappings keyAtValue:f asString.
                        raw isNil ifTrue:[
                            raw := mappings keyAtValue:f first.
                            raw isNil ifTrue:[
                                raw := mappings keyAtValue:f asSymbol.
                            ]
                        ].
                        list1 selection:raw.
                        list1 onChangeSend:#showFunction to:selectionForwarder.
                       ].

    macroForwarder := [
                        |f macro indent|
                        f := list2 selection.
                        (f startsWith:'Cmd') ifTrue:[
                            f := f copyFrom:4
                        ].
                        macro := UserPreferences current functionKeySequences
                                    at:(f asSymbol) ifAbsent:nil.
                        macro notNil ifTrue:[
                            macro := macro asStringCollection.
                            indent := macro
                                         inject:99999 into:[:min :element |
                                             |stripped|

                                             stripped := element withoutLeadingSeparators.
                                             stripped isEmpty ifTrue:[
                                                 min
                                             ] ifFalse:[
                                                 min min:(element size - stripped size)
                                             ]
                                         ].
                            indent ~~ 0 ifTrue:[
                                macro := macro collect:[:line |
                                             line size > indent ifTrue:[
                                                line copyFrom:indent+1
                                             ] ifFalse:[
                                                line
                                             ].
                                        ]
                            ].
                        ].
                        macroTextView contents:macro.
                       ].

    list1 := SelectionInList with:listOfRawKeys.
    list1 onChangeSend:#showFunction to:selectionForwarder.

    list2 := SelectionInList with:listOfFunctions.
    list2 onChangeSend:#showRawKey to:selectionForwarder.
    list2 onChangeEvaluate:macroForwarder.

    box := Dialog new.
    box label:(resources string:'Keyboard Mappings').

    l := box addTextLabel:(resources at:'KEY_MSG' default:'keyboard mapping:') withCRs.
    l adjust:#left; borderWidth:0.

    frame := View new.
    frame extent:300 @ 300.
    frame borderWidth:0.

    listView1 := ScrollableView for:SelectionInListView in:frame.
    listView1 model:list1.
    listView1 origin:0.0@0.0 corner:0.5@1.0; inset:2.

    listView2 := ScrollableView for:SelectionInListView in:frame.
    listView2 model:list2.
    listView2 origin:0.5@0.0 corner:1.0@1.0; inset:2.

    frame topInset:box yPosition.
    box addComponent:frame withExtent:350@200.
    box makeTabable:listView1.
    box makeTabable:listView2.
    frame origin:0.0@0.0 corner:1.0@0.6.

    box addVerticalSpace.

    l := box addTextLabel:(resources string:'Macro text (if any):') withCRs.
    l adjust:#left; borderWidth:0.
    l origin:0.0@0.6 corner:1.0@0.6.
    l topInset:(View viewSpacing).
    l bottomInset:(l preferredHeight negated - View viewSpacing).

    macroTextView := HVScrollableView for:TextView miniScroller:true.
    box addComponent:macroTextView tabable:true.
    macroTextView origin:0.0@0.6 corner:1.0@1.0.
    y := box yPosition.

    box
        addHelpButtonFor:'Launcher/keyboardSetting.html';
        "addAbortButton;"
        addOkButtonLabelled:(resources string:'Close' "'Dismiss'").

    macroTextView topInset:(l preferredHeight + 5).
    macroTextView bottomInset:(box preferredHeight - y).

    box open.

    box accepted ifTrue:[
        "no action yet ..."
    ].
    box destroy

    "Modified: / 9.9.1996 / 22:43:17 / stefan"
    "Modified: / 4.5.1998 / 12:40:02 / cg"
!

languageSettings
    self languageSettingsFor:nil
!

languageSettingsFor:requestor
    "open a dialog on language related settings.
     Obsoleted by the settings application"

    |listOfLanguages translatedLanguages switch box languageList flags resources|

    resources := self owningClass classResources.

    "
     get list of supported languages from the launchers resources ...
    "

    listOfLanguages := resources at:'LIST_OF_OFFERED_LANGUAGES' default:#('default').
    listOfLanguages := listOfLanguages asOrderedCollection.

    translatedLanguages := listOfLanguages collect:[:lang | |item|
                                        item := resources string:lang.
                                        item isString ifTrue:[
                                            item
                                        ] ifFalse:[
                                            item at:1
                                        ]
                                ].
    flags := listOfLanguages collect:[:lang | |item|
                                        item := resources string:lang.
                                        item isArray ifTrue:[
                                            item at:2
                                        ] ifFalse:[
                                            nil
                                        ]
                                ].
    flags := flags collect:[:nm | |img d| nm notNil ifTrue:[
                                            img := Image fromFile:nm.
                                            img isNil ifTrue:[
                                                d := Smalltalk getPackageDirectoryForPackage:'stx:goodies'.
                                                img := Image fromFile:(d construct:nm).
                                            ].
                                        ] ifFalse:[
                                            nil
                                        ]
                           ].
    listOfLanguages := listOfLanguages collect:[:nm | nm copyFrom:'LANG_' size + 1].
    languageList := translatedLanguages with:flags collect:[:lang :flag | LabelAndIcon icon:flag string:lang.].

    box := ListSelectionBox title:(resources at:'LANG_MSG' default:'Select a Language') withCRs.
    box label:(resources string:'Language Selection').
    box list:languageList.
    box initialText:(Smalltalk language , '-' , Smalltalk languageTerritory).
    box action:[:newLanguage |
        WindowGroup activeGroup withWaitCursorDo:[
            |fontPref idx language oldLanguage territory enc
             answer matchingFonts l screen|

            idx := translatedLanguages indexOf:newLanguage withoutSeparators.
            idx ~~ 0 ifTrue:[
                language := listOfLanguages at:idx
            ] ifFalse:[
                language := newLanguage
            ].
            (language includes:$-) ifTrue:[
                l := language asCollectionOfSubstringsSeparatedBy:$-.
                language := l at:1.
                territory := l at:2.
            ].
            territory isNil ifTrue:[
                territory := language copyTo:2
            ].

            "/ check if the new language needs a differently encoded font;
            "/ ask user to switch font and allow cancellation.
            "/ Otherwise, you are left with unreadable menu & button items ...

            oldLanguage := UserPreferences current language.
            Smalltalk setLanguage:language asSymbol.
            ResourcePack flushCachedResourcePacks.
            "/ refetch resources ...
            resources := self owningClass classResources.
            fontPref := resources at:'PREFERRED_FONT_ENCODING' default:'iso8859*'.
            fontPref := fontPref asLowercase.
            Smalltalk setLanguage:oldLanguage.

            switch := true.
            enc := MenuView defaultFont encoding.
            (fontPref match:enc asLowercase) ifFalse:[
                "/ look if there is one at all.
                screen := Screen current.
                matchingFonts := screen listOfAvailableFonts select:[:f | fontPref match:f encoding asLowercase].
                matchingFonts isEmpty ifTrue:[
                    "/ flush and try again - just in case, the font path has changed.
                    screen flushListOfAvailableFonts.
                    matchingFonts := screen listOfAvailableFonts select:[:f | fontPref match:f encoding asLowercase].
                ].
                matchingFonts isEmpty ifTrue:[
                    (Dialog
                        confirm:(resources
                                    string:'Your display does not offer any %1-encoded font.\\Change the language anyway ?\ (texts will probably be unreadable then)'
                                      with:fontPref) withCRs)
                    ifFalse:[
                        switch := false
                    ]
                ] ifFalse:[
                    answer := Dialog
                                confirmWithCancel:(resources
                                                        string:'menu font is not %1-encoded.\\Change it ?'
                                                        with:fontPref) withCRs
                                           labels:(resources
                                                        array:#('Cancel' 'No' 'Yes'))
                                           default:3.
                    answer isNil ifTrue:[
                        switch := false
                    ] ifFalse:[
                        answer ifTrue:[
                            switch := (requestor fontBoxForEncoding:fontPref)
                        ]
                    ].
                ].
            ].

            switch ifTrue:[
                Transcript showCR:'change language to ' , newLanguage , ' ...'.
                Smalltalk language:language asSymbol territory:territory asSymbol.
                "/ ResourcePack flushCachedResourcePacks - already done by language-change
            ].
        ].
        switch ifTrue:[
            requestor reopenLauncher.
            DebugView newDebugger.
        ]
    ].
    box
        addHelpButtonFor:'Launcher/languageSetting.html'.
    box open.
    box destroy

    "Modified: / 09-09-1996 / 22:43:27 / stefan"
    "Modified: / 19-10-2006 / 22:17:01 / cg"
!

memorySettings
    "open a dialog on objectMemory related settings.
     Obsoleted by the settings application"

    |box igcLimit igcFreeLimit igcFreeAmount newSpaceSize
     compressLimit
     oldIncr component fields codeLimit codeTrigger stackLimit resources
     fastMoreLimit maxOldSpace models info acceptChannel|

    acceptChannel := false asValue.

    resources := self owningClass classResources.

    "/
    "/ extract relevant system settings ...
    "/
    igcLimit := ObjectMemory incrementalGCLimit asValue.
    igcFreeLimit := ObjectMemory freeSpaceGCLimit asValue.
    igcFreeAmount := ObjectMemory freeSpaceGCAmount asValue.
    newSpaceSize := ObjectMemory newSpaceSize asValue.
    oldIncr := ObjectMemory oldSpaceIncrement asValue.
    compressLimit := ObjectMemory oldSpaceCompressLimit asValue.
    codeLimit := ObjectMemory dynamicCodeLimit asValue.
    codeTrigger := ObjectMemory dynamicCodeGCTrigger asValue.
    stackLimit := Process defaultMaximumStackSize asValue.
    fastMoreLimit := (ObjectMemory fastMoreOldSpaceLimit:-1) asValue.
    maxOldSpace := ObjectMemory maxOldSpace asValue.

    models := OrderedCollection new.
    info := OrderedCollection new.
    models add:newSpaceSize.    info add:#(number      'Size of newSpace where objects are created'                    'Size of NewSpace:' ).
    models add:fastMoreLimit.   info add:#(number      'Quickly allocate more memory (suppress GC) up to this limit'   'Quick Allocation Limit:').
    models add:maxOldSpace.     info add:#(number      'Never allocate more than this amount of memory'                'Maximum Memory Limit:').
    models add:igcLimit.        info add:#(number      'Start IGC whenever this amount has been allocated'             'Incremental GC Allocation Trigger:').
    models add:igcFreeLimit.    info add:#(number      'Start IGC whenever freespace drops below this'                 'Incremental GC Freespace Trigger:').
    models add:igcFreeAmount.   info add:#(number      'Try to keep this amount for peak requests'                     'Incremental GC Amount:').
    models add:oldIncr.         info add:#(number      'Increase oldSpace in chunks of this size'                      'Oldspace Increment:').
    models add:compressLimit.   info add:#(number      'Use 2-pass compressing GC if > 0 and more memory is in use'    'Oldspace Compress Limit:').
    models add:stackLimit.      info add:#(number      'Trigger recursionInterrupt if more stack is used by a process' 'Stack Limit:').
    models add:codeLimit.       info add:#(numberOrNil 'Flush dynamic compiled code to stay within this limit'         'Dynamic code Limit:').
    models add:codeTrigger.     info add:#(numberOrNil 'Start incremental GC whenever this amount of code has been allocated' 'Dynamic Code GC Trigger:').

    "/
    "/ create a box on those values ...
    "/
    fields := OrderedCollection new.

    box := DialogBox new.
    box label:(resources string:'Memory Manager Settings').

    box 
        addTextLabel:'Warning - invalid settings may result in failures or poor performance
' , 'You have been warned' allBold , '.' 
        adjust:#left.
    box addHorizontalLine.

    models with:info do:[:m :i |
        |lbl descr conv|

        conv := i at:1.
        lbl := i at:3.
        descr := i at:2.

        component := box
                    addLabelledInputField:(resources string:lbl)
                    adjust:#right
                    on:nil "/ newSpaceSize
                    tabable:true
                    separateAtX:0.7.
        component acceptOnLeave:false.
"/        component converter:(PrintConverter new perform:conv).
        component model:((TypeConverter on:m) perform:conv).
        component acceptChannel:acceptChannel.
        fields add:component.

        box addTextLabel:descr adjust:#left.
        box addHorizontalLine.
    ].

    ObjectMemory supportsJustInTimeCompilation ifFalse:[
        (fields at:9) disable.
        (fields at:10) disable.
    ].

    box addAbortAndOkButtons.
    box
        addHelpButtonFor:'Launcher/memorySettings.html'.

    "/
    "/ show the box ...
    "/
    box open.

    "/
    "/ update system settings
    "/
    box accepted ifTrue:[
        acceptChannel value:true.

        igcFreeAmount value ~~ ObjectMemory freeSpaceGCAmount ifTrue:[
            ObjectMemory freeSpaceGCAmount:igcFreeAmount value.
        ].
        igcFreeLimit value ~~ ObjectMemory freeSpaceGCLimit ifTrue:[
            ObjectMemory freeSpaceGCLimit:igcFreeLimit value.
        ].
        igcLimit value ~~ ObjectMemory incrementalGCLimit ifTrue:[
            ObjectMemory incrementalGCLimit:igcLimit value.
        ].
        newSpaceSize value ~~ ObjectMemory newSpaceSize ifTrue:[
            ObjectMemory newSpaceSize:newSpaceSize value.
        ].
        oldIncr value ~~ ObjectMemory oldSpaceIncrement ifTrue:[
            ObjectMemory oldSpaceIncrement:oldIncr value.
        ].
        stackLimit value ~~ Process defaultMaximumStackSize ifTrue:[
            Process defaultMaximumStackSize:stackLimit value.
        ].
        fastMoreLimit value ~~ (ObjectMemory fastMoreOldSpaceLimit:-1) ifTrue:[
            ObjectMemory fastMoreOldSpaceLimit:fastMoreLimit value.
        ].
        maxOldSpace value ~~ ObjectMemory maxOldSpace ifTrue:[
            ObjectMemory maxOldSpace:maxOldSpace value.
        ].
        ObjectMemory oldSpaceCompressLimit:compressLimit value.
        ObjectMemory dynamicCodeLimit:codeLimit value.
        ObjectMemory dynamicCodeGCTrigger:codeTrigger value.
    ].
    box destroy

    "Modified: 27.2.1997 / 16:50:12 / cg"
!

messageSettings
    "open a dialog on infoMessage related settings.
     Obsoleted by the settings application"

    |box vmInfo vmErrors displayErrors classInfos resources|

    resources := self owningClass classResources.

    vmInfo := ObjectMemory infoPrinting asValue.
    vmErrors := ObjectMemory debugPrinting asValue.
    classInfos := Object infoPrinting asValue.
    displayErrors := DeviceWorkstation errorPrinting asValue.

    box := DialogBox new.
    box label:(resources string:'Messages').

    box addCheckBox:(resources string:'VM Info Messages') on:vmInfo.
    box addCheckBox:(resources string:'VM Error Messages') on:vmErrors.
    box addHorizontalLine.

    box addCheckBox:(resources string:'Display Error Messages (Xlib, Xtlib, WinAPI ...)') on:displayErrors.
    box addCheckBox:(resources string:'Other Info Messages') on:classInfos.
    box addHorizontalLine.

    box addHelpButtonFor:'Launcher/messageSettings.html'.
    box addAbortAndOkButtons.
    box open.

    box accepted ifTrue:[
        ObjectMemory infoPrinting:vmInfo value.
        ObjectMemory debugPrinting:vmErrors value.
        Object infoPrinting:classInfos value.
        DeviceWorkstation errorPrinting:displayErrors value.
    ].
    box destroy

    "Modified: 27.1.1997 / 17:46:01 / cg"
!

miscSettings
    "open a dialog on misc other settings.
     Obsoleted by the settings application"

    |box pos pos2 check butt shadows takeFocus focusFollowsMouse returnFocus
     hostNameInLabel showAccelerators
     preemptive dynamicPrios hostNameInLabelHolder resources
     activateOnClick opaqueVariablePanelResize opaqueTableColumnResize currentUserPrefs
     beepEnabled newWindowLabelFormat|

    resources := self owningClass classResources.
    currentUserPrefs := UserPreferences current.

    "/
    "/ extract relevant system settings ...
    "/
    shadows := PopUpView shadows asValue.
    beepEnabled := currentUserPrefs beepEnabled asValue.

    hostNameInLabel := StandardSystemView includeHostNameInLabel.
    hostNameInLabelHolder := hostNameInLabel asValue.
    returnFocus := StandardSystemView returnFocusWhenClosingModalBoxes asValue.
    takeFocus := StandardSystemView takeFocusWhenMapped asValue.
    focusFollowsMouse := currentUserPrefs focusFollowsMouse asValue.
    activateOnClick := (Screen current activateOnClick:nil) asValue.
    opaqueVariablePanelResize := currentUserPrefs opaqueVariablePanelResizing asValue.
    opaqueTableColumnResize := currentUserPrefs opaqueTableColumnResizing asValue.

    showAccelerators := MenuView showAcceleratorKeys asValue.
    preemptive := Processor isTimeSlicing asValue.
    dynamicPrios := Processor supportDynamicPriorities asValue.

    "/
    "/ create a box on those values ...
    "/
    box := DialogBox new.
    box label:(resources string:'Other settings').

    box addCheckBox:(resources string:'Shadows under PopUp Views') on:shadows.
    box addCheckBox:(resources string:'Beeper enabled') on:beepEnabled.
    box addCheckBox:(resources string:'Boxes Return Focus to Previously Active View') on:returnFocus.
    box addCheckBox:(resources string:'Views Catch Focus when Mapped') on:takeFocus.
    pos := box yPosition.
    check := box addCheckBox:(resources string:'Hostname in Window Labels') on:hostNameInLabelHolder.
    check width:0.6.
    pos2 := box yPosition.
    box yPosition:pos.
    butt := box addComponent:(Button label:(resources string:'Format...')
               action:[
                       |newFormat|

                       newFormat := Dialog request:
                                        'Define the Format of Window Labels:\\  %1 - Label\  %2 - Hostname\  %3 - Username\  %4 - ProcessId\'
                                           withCRs initialAnswer:StandardSystemView windowLabelFormat.

                       newFormat size > 0 ifTrue:[
                           newWindowLabelFormat := newFormat
                       ].
                      ]).
    box makeTabable:butt.
    butt left:0.6; width:0.4.
    box yPosition:(box yPosition max:pos2).

    box addCheckBox:(resources string:'Show Accelerator Keys in Menus') on:showAccelerators.
    box addCheckBox:(resources string:'Raise & Activate Windows on Click') on:activateOnClick.
    box addCheckBox:(resources string:'Focus Follows Mouse') on:focusFollowsMouse.
    box addCheckBox:(resources string:'Opaque Variable Panel Resizing') on:opaqueVariablePanelResize.
    box addCheckBox:(resources string:'Opaque Table Column Resizing') on:opaqueTableColumnResize.

    box addHorizontalLine.

    box addCheckBox:(resources string:'Preemptive Scheduling') on:preemptive.
    box leftIndent:20.
    check := box addCheckBox:(resources string:'Dynamic Priorities') on:dynamicPrios.
    check enableChannel:preemptive.
    box leftIndent:0.

    box addHorizontalLine.
    box
        addHelpButtonFor:'Launcher/miscSettings.html';
        addAbortAndOkButtons.

    "/
    "/ show the box ...
    "/
    box open.

    "/
    "/ update system settings
    "/
    box accepted ifTrue:[
        PopUpView shadows:shadows value.
        (hostNameInLabelHolder value ~= hostNameInLabel
        or:[newWindowLabelFormat ~= StandardSystemView windowLabelFormat]) ifTrue:[
            StandardSystemView includeHostNameInLabel:hostNameInLabelHolder value.
            newWindowLabelFormat notNil ifTrue:[
                StandardSystemView windowLabelFormat:newWindowLabelFormat
            ].

            Screen allScreens do:[:aDisplay |
                aDisplay allViewsDo:[:aView |
                    |l|

                    aView isTopView ifTrue:[
                        l := aView label.
                        l notNil ifTrue:[
                            aView label:(l , ' '); label:l.  "/ force a change
                        ]
                    ]
                ]
            ]
        ].

        currentUserPrefs opaqueVariablePanelResizing:opaqueVariablePanelResize value.
        currentUserPrefs opaqueTableColumnResizing:opaqueTableColumnResize value.

        currentUserPrefs beepEnabled:beepEnabled value.

        StandardSystemView returnFocusWhenClosingModalBoxes:returnFocus value.
        StandardSystemView takeFocusWhenMapped:takeFocus value.
        currentUserPrefs focusFollowsMouse:focusFollowsMouse value.
        Screen current activateOnClick:(activateOnClick value).

        MenuView showAcceleratorKeys:showAccelerators value.
        Processor isTimeSlicing ~~ preemptive value ifTrue:[
            preemptive value ifTrue:[
                Processor startTimeSlicing
            ] ifFalse:[
                Processor stopTimeSlicing
            ]
        ].
        Processor supportDynamicPriorities ~~ dynamicPrios value ifTrue:[
            Processor supportDynamicPriorities:dynamicPrios value
        ].
    ].
    box destroy

    "Modified: / 9.9.1996 / 22:43:36 / stefan"
    "Modified: / 20.5.1999 / 18:33:55 / cg"
    "Modified: / 3.12.1999 / 17:11:38 / ps"
!

printerSettings
    "open a dialog on printer related settings; returns true if accepted.
     Obsoleted by the settings application"

    |box accepted
     possiblePrinters possibleTypes printerType printCommand printFile
     pageFormat landscape updater
     formatLabel formatComponent landscapeLabel landscapeComponent
     topMargin leftMargin rightMargin bottomMargin unitList unit
     topMarginComponent leftMarginComponent
     rightMarginComponent
     bottomMarginComponent supportsColor supportsColorComponent
     y y1 commandListPop printOutField component commandList row resources|

    resources := self owningClass classResources.

    possiblePrinters := PrinterStream withAllSubclasses asArray.
    possibleTypes := possiblePrinters collect:[:cls | cls printerTypeName].

    printerType := SelectionInList new list:(resources array:possibleTypes).
    printerType selectionIndex:(possiblePrinters identityIndexOf:Printer).
    printCommand := Printer printCommand asValue.
    printFile := (Printer printFilename ? '') asValue.

    pageFormat := SelectionInList new list:(Printer defaultPageFormats).
    pageFormat selection:(Printer pageFormat).
    landscape := Printer landscape asValue.

    topMargin := Printer topMargin asValue.
    leftMargin := Printer leftMargin asValue.
    rightMargin := Printer rightMargin asValue.
    bottomMargin := Printer bottomMargin asValue.
    supportsColor := Printer supportsColor asValue.

    box := DialogBox new.
    box label:(resources string:'Printer Settings').

"/ either use a popUpList ...
"/    box addPopUpList:(resources string:'printer type:') on:printerType.

"/ or a comboList;
"/ which one looks better ?
    y := box yPosition.
    component := box addTextLabel:(resources string:'Printer Type:').
    component width:0.25; adjust:#right; borderWidth:0.
    box yPosition:y.
    component := box addComboListOn:printerType tabable:true.
    component aspect:#selectionIndex; changeMessage:#selectionIndex:; useIndex:true.
    component width:0.75; left:0.25.
"/ end of question

    y := box yPosition.
    component := box addTextLabel:(resources string:'Print Command:').
    component width:0.25; adjust:#right; borderWidth:0.
    box yPosition:y.
    commandListPop := box addComboBoxOn:printCommand tabable:true.
"/    commandListPop := box addInputFieldOn:printCommand tabable:true.
    commandListPop width:0.75; left:0.25; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
    "/ some common print commands ...

    commandList := resources string:'PRINT_COMMANDS' default:nil.
    commandList isNil ifTrue:[
        commandList := PrinterStream defaultCommands.
        commandList isNil ifTrue:[
            commandList := #('lpr'
                             'lp'
                            ).
        ]
    ].

    commandListPop list:commandList.

    y := box yPosition.
    component := box addTextLabel:(resources string:'Print to File:').
    component width:0.25; adjust:#right; borderWidth:0.
    box yPosition:y.

    printOutField := box addInputFieldOn:printFile tabable:true.
    printOutField width:0.75; left:0.25; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
    printFile
        onChangeEvaluate:
            [
                printFile value size > 0 ifTrue:[
                    commandListPop disable.
                ] ifFalse:[
                    commandListPop enable.
                ]
            ].
    printFile changed.

    box addVerticalSpace; addHorizontalLine; addVerticalSpace.

    row := OrderedCollection new.
    row add:(formatLabel := Label label:(resources string:'Page Format:')).
    formatLabel borderWidth:0.
    row add:(formatComponent := PopUpList on:pageFormat).
    formatComponent label:'unknown'.

    row add:(landscapeLabel := Label label:(resources string:'Landscape:')).
    landscapeLabel borderWidth:0.
    row add:(landscapeComponent := CheckToggle on:landscape).

    y := box yPosition.
    box
        addRow:(1 to:2)
        fromX:0
        toX:0.5
        collect:[:idx | row at:idx]
        tabable:false
        horizontalLayout:#leftSpace
        verticalLayout:#center.
    y1 := box yPosition.
    box yPosition:y.

    box
        addRow:(3 to:4)
        fromX:0.5
        toX:1.0
        collect:[:idx | row at:idx]
        tabable:false
        horizontalLayout:#leftSpace
        verticalLayout:#center.

    box yPosition:(box yPosition max:y1).

    box makeTabable:(formatComponent).
    box makeTabable:(landscapeComponent).

    box addVerticalSpace; addHorizontalLine; addVerticalSpace.

    y := box yPosition.

    topMarginComponent := box
        addLabelledInputField:(resources string:'Top Margin:')
        adjust:#right
        on:nil "/ topMargin
        tabable:true
        from:0.0 to:0.5
        separateAtX:0.6.
    topMarginComponent converter:(PrintConverter new initForNumber).
    topMarginComponent model:topMargin.
    y1 := box yPosition.

    box yPosition:y.
    unitList := SelectionInList with:#('inch' 'mm').
    unitList selectionIndex:1.

    component := box addComponent:(PopUpList on:unitList).
    component
        left:0.6;
        width:0.3.

    box yPosition:y1.

    leftMarginComponent := box
        addLabelledInputField:(resources string:'Left Margin:')
        adjust:#right
        on:nil "/ leftMargin
        tabable:true
        from:0.0 to:0.5
        separateAtX:0.6.
    leftMarginComponent converter:(PrintConverter new initForNumber).
    leftMarginComponent model:leftMargin.

    rightMarginComponent := box
        addLabelledInputField:(resources string:'Right Margin:')
        adjust:#right
        on:nil "/ rightMargin
        tabable:true
        from:0.0 to:0.5
        separateAtX:0.6.
    rightMarginComponent converter:(PrintConverter new initForNumber).
    rightMarginComponent model:rightMargin.

    bottomMarginComponent := box
        addLabelledInputField:(resources string:'Bottom Margin:')
        adjust:#right
        on:nil "/ bottomMargin
        tabable:true
        from:0.0 to:0.5
        separateAtX:0.6.
    bottomMarginComponent converter:(PrintConverter new initForNumber).
    bottomMarginComponent model:bottomMargin.

    box addHorizontalLine.
    supportsColorComponent := box addCheckBox:(resources string:'Color Printer') on:supportsColor.
    box addVerticalSpace.

    updater := [ |p fg hasPageSize hasMargins|

                       printerType selectionIndex ~~ 0 ifTrue:[
                           p := possiblePrinters at:(printerType selectionIndex).
                           hasPageSize := p supportsPageSizes.
                           hasMargins := p supportsMargins.
                       ] ifFalse:[
                           hasPageSize := false.
                           hasMargins := false.
                       ].
                       hasPageSize ifTrue:[
                          fg := Button new foregroundColor.
                          formatComponent enable.
                          landscapeComponent enable.

                          formatComponent label:p pageFormat.
                          pageFormat value:(p pageFormat).
                          landscape value:(p landscape).
                       ] ifFalse:[
                          fg := Button new disabledForegroundColor.
                          formatComponent disable.
                          landscapeComponent disable.

                          formatComponent label:'unknown'.
                          landscape value:nil.
                       ].
                       hasMargins ifTrue:[
                          unitList selectionIndex == 2 ifTrue:[
                              unit := #mm
                          ] ifFalse:[
                              unit := #inch
                          ].

                          topMargin value:(UnitConverter convert:p topMargin from:#inch to:unit).
                          leftMargin value:(UnitConverter convert:p leftMargin from:#inch to:unit).
                          rightMargin value:(UnitConverter convert:p rightMargin from:#inch to:unit).
                          bottomMargin value:(UnitConverter convert:p bottomMargin from:#inch to:unit).

                          topMarginComponent enable.
                          leftMarginComponent enable.
                          rightMarginComponent enable.
                          bottomMarginComponent enable.
                       ] ifFalse:[
                          topMarginComponent disable.
                          leftMarginComponent disable.
                          rightMarginComponent disable.
                          bottomMarginComponent disable.
                       ].
                       formatLabel foregroundColor:fg.
                       landscapeLabel foregroundColor:fg.

                       p notNil ifTrue:[
                           commandList := p defaultCommands.
                           commandList notNil ifTrue:[
                                commandListPop list:commandList
                           ].

                           printCommand value:(p printCommand).
                       ].
                       p supportsPostscript ifFalse:[
                           supportsColorComponent disable.
                           supportsColor value:false
                       ] ifTrue:[
                           supportsColorComponent enable.
                           supportsColor value:(Printer supportsColor).
                       ]
                     ].
    unitList onChangeEvaluate:updater.
    printerType onChangeEvaluate:updater.
    updater value.

    box addHorizontalLine.
    box addVerticalSpace;
        addHelpButtonFor:'Launcher/printerSettings.html';
        addAbortAndOkButtons.
    box open.

    (accepted := box accepted) ifTrue:[
        Printer := possiblePrinters at:(printerType selectionIndex).
        Printer printCommand:printCommand value.
        Printer printFilename:(printFile value isEmptyOrNil ifTrue:[nil] ifFalse:[printFile value]).

        Printer supportsPageSizes ifTrue:[
            Printer pageFormat:(pageFormat selection).
            Printer landscape:(landscape value).
        ].
        Printer supportsMargins ifTrue:[
            unitList selectionIndex == 2 ifTrue:[
                unit := #mm
            ] ifFalse:[
                unit := #inch
            ].
            Printer topMargin:(UnitConverter convert:topMargin value from:unit to:#inch).
            Printer leftMargin:(UnitConverter convert:leftMargin value from:unit to:#inch).
            Printer rightMargin:(UnitConverter convert:rightMargin value from:unit to:#inch).
            Printer bottomMargin:(UnitConverter convert:bottomMargin value from:unit to:#inch).
        ].
        Printer supportsPostscript ifTrue:[
            Printer supportsColor:supportsColor value.
        ].
    ].
    box destroy.
    ^ accepted

    "Modified: 9.9.1996 / 22:43:51 / stefan"
    "Modified: 28.2.1997 / 14:00:13 / cg"
!

saveSettings
    SettingsDialog saveSettingsWithoutAskingForFile.
!

sourceAndDebuggerSettings
    "open a dialog on source&debugger other settings.
     Obsoleted by the settings application"

    |box check butt setupButt logDoits updChanges changeFileName
     useManager hasManager cvsIsSetup
     repository repositoryHolder localSourceFirst
     sourceCacheDir cacheEntry
     component localCheck oldIndent nm fn manager
     showErrorNotifier showVerboseStack
     syntaxColoring fullSelectorCheck autoFormat
     resources pos currentUserPrefs checkClassesWhenCheckingIn checkClassesBox|

    currentUserPrefs := UserPreferences current.

    resources := self owningClass classResources.

    "/
    "/ extract relevant system settings ...
    "/
    logDoits := Smalltalk logDoits asValue.
    updChanges := Class updatingChanges asValue.
    changeFileName := ObjectMemory nameForChanges asValue.

    AbstractSourceCodeManager notNil ifTrue:[
        AbstractSourceCodeManager autoload.
    ].

    hasManager := AbstractSourceCodeManager notNil
                  and:[AbstractSourceCodeManager isLoaded].

    repositoryHolder := '' asValue.
    hasManager ifTrue:[
        useManager := (manager := Smalltalk at:#SourceCodeManager) notNil asValue.
        localSourceFirst := Class tryLocalSourceFirst asValue.
        manager notNil ifTrue:[
            manager forgetDisabledModules.
            repository := manager repositoryName.
            repository notNil ifTrue:[
                repositoryHolder := repository asValue.
            ] ifFalse:[
                repositoryHolder := '' asValue.
            ].
        ].
        cvsIsSetup := true.
    ] ifFalse:[
        useManager := false.
        localSourceFirst := false.
        cvsIsSetup := false.
    ].
    cvsIsSetup := cvsIsSetup asValue.
    showErrorNotifier := (NoHandlerError emergencyHandler == AbstractLauncherApplication notifyingEmergencyHandler) asValue.
    showVerboseStack := (currentUserPrefs verboseBacktraceInDebugger) asValue.
    syntaxColoring := currentUserPrefs syntaxColoring asValue.
    fullSelectorCheck := currentUserPrefs fullSelectorCheck asValue.
    autoFormat := currentUserPrefs autoFormatting asValue.

    sourceCacheDir := nil asValue.
    checkClassesWhenCheckingIn := (currentUserPrefs at:#checkClassesWhenCheckingIn ifAbsent:true) asValue.

    "/
    "/ create a box on those values ...
    "/
    box := DialogBox new.
    box label:(resources string:'Source & Debugger Settings').

    box addCheckBox:(resources string:'Log compiles in Changefile') on:updChanges.
    box addCheckBox:(resources string:'Log doIts in Changefile') on:logDoits.

    component := box
                    addLabelledInputField:(resources string:'Changefile Name:')
                    adjust:#right
                    on:changeFileName
                    tabable:true
                    separateAtX:0.4.
    component immediateAccept:true; acceptOnLeave:false.

"/    y := box yPosition.
"/    component := box addTextLabel:(resources string:'change file name:').
"/    component width:0.5; adjust:#right; borderWidth:0.
"/    box yPosition:y.
"/    component := box addInputFieldOn:changeFileName tabable:true.
"/    component width:0.5; left:0.5; immediateAccept:true; acceptOnLeave:false.

    box addHorizontalLine.

    hasManager ifTrue:[
        pos := box yPosition.
        check := box addCheckBox:(resources string:'Sourcecode Management') on:useManager.
        check enableChannel:cvsIsSetup.
        box makeTabable:check.

        CVSSourceCodeManager notNil ifTrue:[
            check width:0.6.
            box yPosition:pos.
            setupButt := box addComponent:(Button label:(resources string:'Setup...')
                       action:[|manager|

                               self cvsConfigurationDialog.
                               manager := (Smalltalk at:#SourceCodeManager).
                               cvsIsSetup value:manager notNil.
                               manager notNil ifTrue:[
                                    repositoryHolder value: manager repositoryName.
                                    sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).
                               ].
                              ]).
            setupButt enableChannel:useManager.
            box makeTabable:setupButt.
            setupButt left:0.6; width:0.4.
        ].
        oldIndent := box leftIndent.
        box leftIndent:30.

        box addVerticalSpace:10.
"/        component := box
"/                        addLabelledInputField:(resources string:'CVS repository:')
"/                        adjust:#right
"/                        on:repositoryHolder
"/                        tabable:true
"/                        separateAtX:0.5.
"/        component immediateAccept:true; acceptOnLeave:false.
"/        component enableChannel:useManager.
"/        component readOnly:true.
"/
        cacheEntry := box
                        addLabelledInputField:(resources string:'Source Cache Dir:')
                        adjust:#right
                        on:sourceCacheDir
                        tabable:true
                        separateAtX:0.5.
        cacheEntry immediateAccept:true; acceptOnLeave:false.
        cacheEntry enableChannel:useManager.

        pos := box yPosition.
        butt := Button label:(resources string:'Flush Cache now').
        butt action:[ box withWaitCursorDo:[ AbstractSourceCodeManager flushSourceCache ] ].
        box addComponent:butt tabable:true.
        butt left:0.6; width:0.4; leftInset:0.
        butt enableChannel:useManager.

        butt := Button label:(resources string:'Condense Cache now').
        butt action:[ box withWaitCursorDo:[ AbstractSourceCodeManager condenseSourceCache ] ].
        box addComponent:butt tabable:true.
        butt left:0.6; width:0.4; leftInset:0.
        butt enableChannel:useManager.

        localCheck := box addCheckBox:(resources string:'If Present, Use Local Source (Suppress Checkout)') on:localSourceFirst.
        localCheck enableChannel:useManager.

        checkClassesBox := box addCheckBox:(resources string:'Check for halt/error-Sends when Checking in') on:checkClassesWhenCheckingIn.
        checkClassesBox enableChannel:useManager.

        box leftIndent:oldIndent.

        (AbstractSourceCodeManager isNil
        or:[AbstractSourceCodeManager defaultManager isNil]) ifTrue:[
            useManager value:false.
            "/ cacheEntry disable.
            "/ localCheck enable.
        ] ifFalse:[
            sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).
        ].
        box addHorizontalLine.
    ].

    pos := box yPosition.
    check := box addCheckBox:(resources string:'Syntax Coloring') on:syntaxColoring.
    check width:0.6.
    box yPosition:pos.
    butt := box addComponent:(Button label:(resources string:'Configure...') action:[self syntaxColorConfigurationDialog]).
    box makeTabable:butt.
    butt enableChannel:syntaxColoring.
    butt left:0.6; width:0.4.

    check := box addCheckBox:(resources string:'Immediate Selector Check') on:fullSelectorCheck.
    check enableChannel:syntaxColoring.

    pos := box yPosition.
    check := box addCheckBox:(resources string:'Auto Format') on:autoFormat.
    check width:0.6.
    box yPosition:pos.
    butt := box addComponent:(Button label:(resources string:'Configure...') action:[self formattingConfigurationDialog]).
    box makeTabable:butt.
    butt left:0.6; width:0.4.

    box addHorizontalLine.


    box addCheckBox:(resources string:'Show Error Notifier before Opening Debugger') on:showErrorNotifier.
    box addCheckBox:(resources string:'Verbose Backtrace by Default in Debugger') on:showVerboseStack.

    box addHorizontalLine.
    box
        addHelpButtonFor:'Launcher/sourceSettings.html';
        addAbortAndOkButtons.

    box maxExtent:1000@600.

    "/
    "/ show the box ...
    "/
    box open.

    "/
    "/ update system settings
    "/
    box accepted ifTrue:[
        Smalltalk logDoits:logDoits value.
        Class updateChanges:updChanges value.
        ObjectMemory nameForChanges:(changeFileName value).

        (hasManager and:[useManager value]) ifTrue:[
            manager isNil ifTrue:[
                Smalltalk at:#SourceCodeManager put:(AbstractSourceCodeManager defaultManager).
                manager := Smalltalk at:#SourceCodeManager.
            ].
            Class tryLocalSourceFirst:(localSourceFirst value).

            manager notNil ifTrue:[
"/                localSourceFirst value ifFalse:[

                    nm := sourceCacheDir value.
                    nm size > 0 ifTrue:[
                        (fn := nm asFilename) exists ifFalse:[
                            (self confirm:('CVS cache directory ''' , nm , ''' does not exist\create ?' withCRs)) ifTrue:[
                                fn makeDirectory;
                                   makeReadableForAll;
                                   makeWritableForAll;
                                   makeExecutableForAll.
                            ]
                        ].
                        (fn isWritableDirectory and:[fn isReadable]) ifTrue:[
                            AbstractSourceCodeManager cacheDirectoryName:(sourceCacheDir value).
                        ] ifFalse:[
                            self warn:'Invalid sourceCache directory.'
                        ]
                    ]
"/                ]
            ].

            repositoryHolder notNil ifTrue:[
                repositoryHolder value size > 0 ifTrue:[
                    manager notNil ifTrue:[
                        manager initializeForRepository:repositoryHolder value.
                    ]
                ].
            ].
        ] ifFalse:[
            Smalltalk at:#SourceCodeManager put:nil
        ].

        showErrorNotifier value ifFalse:[
            NoHandlerError emergencyHandler:nil
        ] ifTrue:[
            NoHandlerError emergencyHandler:(AbstractLauncherApplication notifyingEmergencyHandler)
        ].
        currentUserPrefs verboseBacktraceInDebugger:(showVerboseStack value).
        currentUserPrefs syntaxColoring:syntaxColoring value.
        currentUserPrefs at:#fullSelectorCheck put:fullSelectorCheck value.
        currentUserPrefs autoFormatting:autoFormat value.

        currentUserPrefs at:#checkClassesWhenCheckingIn put:checkClassesWhenCheckingIn value.
    ].
    box destroy

    "Modified: / 09-09-1996 / 22:43:36 / stefan"
    "Created: / 17-01-1997 / 17:39:33 / cg"
    "Modified: / 16-04-1998 / 17:18:47 / ca"
    "Modified: / 09-02-2011 / 20:32:56 / cg"
!

stcCompilerSettings
    "open an extra dialog on stc-compiler related settings.
     Obsoleted by STCCompilerSettingsApp"

    |box
     stcIncludes stcDefines stcOptions
     stcLibraries stcLibraryPath cc stc ccOptions
     linkCommand linkArgs
     component
     canLoadBinaries
     resources|

    resources := self owningClass classResources.

    canLoadBinaries := ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles].

    stcIncludes := ParserFlags stcCompilationIncludes asValue.
    stcDefines := ParserFlags stcCompilationDefines asValue.
    stcOptions := ParserFlags stcCompilationOptions asValue.
    ccOptions := ParserFlags ccCompilationOptions asValue.

    cc := ParserFlags ccPath asValue.
    stc := ParserFlags stcPath asValue.
    linkCommand := ParserFlags linkCommand asValue.
    linkArgs := ParserFlags linkArgs asValue.

    ObjectFileLoader notNil ifTrue:[
        | t |
        (t := ParserFlags searchedLibraries) notNil ifTrue:[
            stcLibraries := (String fromStringCollection:t separatedBy:' ') asValue.
        ].
        (t := ParserFlags libPath) notNil ifTrue:[
            stcLibraryPath := t asValue.
        ]
    ].

    box := DialogBox new.
    box label:(resources string:'STC Compilation Settings').

    ObjectFileLoader notNil ifTrue:[
        component := box
                        addLabelledInputField:(resources string:'stc Command:')
                        adjust:#right
                        on:stc
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(100 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

        component := box
                        addLabelledInputField:(resources string:'stc Options:')
                        adjust:#right
                        on:stcOptions
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(250 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

        component := box
                        addLabelledInputField:(resources string:'cc Command:')
                        adjust:#right
                        on:cc
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(150 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

        component := box
                        addLabelledInputField:(resources string:'cc Options:')
                        adjust:#right
                        on:ccOptions
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(250 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

        component := box
                        addLabelledInputField:(resources string:'Include Directories:')
                        adjust:#right
                        on:stcIncludes
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(250 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

"/        box addVerticalSpace.

        component := box
                        addLabelledInputField:(resources string:'Defines:')
                        adjust:#right
                        on:stcDefines
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(250 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

"/        box addVerticalSpace.

"/        box addVerticalSpace.

        component := box
                        addLabelledInputField:(resources string:'Link Command:')
                        adjust:#right
                        on:linkCommand
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(250 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

        component := box
                        addLabelledInputField:(resources string:'Link Args:')
                        adjust:#right
                        on:linkArgs
                        tabable:true
                        separateAtX:0.3.
        component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        component preferredExtent:(250 @ component preferredHeight).
        canLoadBinaries ifFalse:[component disable].

        stcLibraries notNil ifTrue:[
"/            box addVerticalSpace.

            component := box
                            addLabelledInputField:(resources string:'C-libraries:')
                            adjust:#right
                            on:stcLibraries
                            tabable:true
                            separateAtX:0.3.
            component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
            component preferredExtent:(250 @ component preferredHeight).
            canLoadBinaries ifFalse:[component disable].
        ].

        stcLibraryPath notNil ifTrue:[
"/            box addVerticalSpace.

            component := box
                            addLabelledInputField:(resources string:'stc LibPath:')
                            adjust:#right
                            on:stcLibraryPath
                            tabable:true
                            separateAtX:0.3.
            component immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
            component preferredExtent:(250 @ component preferredHeight).
            canLoadBinaries ifFalse:[component disable].
        ].
    ].

    box
        addHelpButtonFor:'Launcher/compilerSettings.html';
        addAbortAndOkButtons.

    box open.

    box accepted ifTrue:[
        ParserFlags stcCompilationIncludes:stcIncludes value.
        ParserFlags stcCompilationDefines:stcDefines value.
        ParserFlags stcCompilationOptions:stcOptions value.
        ParserFlags ccCompilationOptions:ccOptions value.
        ParserFlags ccPath:cc value.
        stc value ~= ParserFlags stcPath ifTrue:[
            ParserFlags stcPath:stc value
        ].
        ParserFlags linkCommand:linkCommand value.
        ParserFlags linkArgs:linkArgs value.

        ObjectFileLoader notNil ifTrue:[
            stcLibraries notNil ifTrue:[
                ParserFlags searchedLibraries:(stcLibraries value asCollectionOfWords).
            ].
            stcLibraryPath notNil ifTrue:[
                ParserFlags libPath:(stcLibraryPath value).
            ]
        ].
    ].
    box destroy
"
    self stcCompilerSettings
"
    "Modified: / 10.9.1995 / 19:19:18 / claus"
    "Modified: / 9.9.1996 / 22:42:47 / stefan"
    "Created: / 2.10.1998 / 16:27:49 / cg"
    "Modified: / 21.10.1998 / 19:15:10 / cg"
!

toolSettings
    "open a dialog on tool settings.
     Obsoleted by the settings application"

    |box resources currentUserPrefs in acceptChannel
     useNewInspector useNewChangesBrowser useNewSystemBrowser useNewVersionDiffBrowser
     useNewFileBrowser showClockInLauncher showClock launcher
     transcriptBufferSize useNewFileDialog useNewSettingsApplication useProcessMonitorV2
     currentTranscript|

    currentTranscript := Transcript current.
    currentUserPrefs := UserPreferences current.

    resources := self owningClass classResources.

    "/
    "/ extract relevant system settings ...
    "/
    useNewInspector := currentUserPrefs useNewInspector asValue.
    useNewChangesBrowser := currentUserPrefs useNewChangesBrowser asValue.
    useNewSystemBrowser := currentUserPrefs useNewSystemBrowser asValue.
    showClockInLauncher := currentUserPrefs showClockInLauncher asValue.
    useNewVersionDiffBrowser := currentUserPrefs useNewVersionDiffBrowser asValue.
    useNewFileBrowser := currentUserPrefs useNewFileBrowser asValue.
    useNewFileDialog := currentUserPrefs useNewFileDialog asValue.
    useNewSettingsApplication := currentUserPrefs useNewSettingsApplication asValue.
    useProcessMonitorV2 := currentUserPrefs useProcessMonitorV2 asValue.
    currentTranscript isExternalStream ifTrue:[
        transcriptBufferSize := TextCollector defaultLineLimit
    ] ifFalse:[
        transcriptBufferSize := currentTranscript lineLimit printString asValue.
    ].
    acceptChannel := false asValue.

    "/
    "/ create a box on those values ...
    "/
    box := DialogBox new.
    box label:(resources string:'Tool Settings').


    box addCheckBox:(resources string:'Use the New System Browser') on:useNewSystemBrowser.
    box addHorizontalLine.
    box addCheckBox:(resources string:'Use the New VersionDiff Browser') on:useNewVersionDiffBrowser.
    box addHorizontalLine.
    (Smalltalk at:#FileBrowserV2) isBehavior ifTrue:[
        box addCheckBox:(resources string:'Use the New File Browser') on:useNewFileBrowser.
        box addHorizontalLine.
    ].
    (Smalltalk at:#FileDialog) isBehavior ifTrue:[
        box addCheckBox:(resources string:'Use the New File Dialog') on:useNewFileDialog.
        box addHorizontalLine.
    ].
    (Smalltalk at:#SettingsDialog) isBehavior ifTrue:[
        box addCheckBox:(resources string:'Use the New Settings Dialog') on:useNewSettingsApplication.
        box addHorizontalLine.
    ].
    (Smalltalk at:#ProcessMonitorV2) isBehavior ifTrue:[
        box addCheckBox:(resources string:'Use the New ProcessMonitor') on:useProcessMonitorV2.
        box addHorizontalLine.
    ].
    box addCheckBox:(resources string:'Use the New Changes Browser') on:useNewChangesBrowser.
    box addHorizontalLine.
    box addCheckBox:(resources string:'Use Hierarchical Inspector') on:useNewInspector.
    box addHorizontalLine.
    box addCheckBox:(resources string:'Show Clock in Launcher') on:showClockInLauncher.
    box addHorizontalLine.
    in := box
            addLabelledInputField:(resources string:'Transcripts Buffer Size:')
            adjust:#right
            on:transcriptBufferSize
            tabable:true
            separateAtX:0.6.
    in acceptChannel:acceptChannel.
    box addHorizontalLine.

    box
        addHelpButtonFor:'Launcher/toolSettings.html';
        addAbortAndOkButtons.

    "/
    "/ show the box ...
    "/
    box open.

    "/
    "/ update system settings
    "/
    box accepted ifTrue:[
        acceptChannel value:false; value:true.

        currentUserPrefs useNewInspector:useNewInspector value.
        currentUserPrefs useNewChangesBrowser:useNewChangesBrowser value.
        currentUserPrefs useNewSystemBrowser:useNewSystemBrowser value.
        currentUserPrefs useNewVersionDiffBrowser:useNewVersionDiffBrowser value.
        currentUserPrefs useNewFileBrowser:useNewFileBrowser value.
        currentUserPrefs useNewFileDialog:useNewFileDialog value.
        currentUserPrefs useProcessMonitorV2:useProcessMonitorV2 value.
        currentUserPrefs useNewSettingsApplication ~= useNewSettingsApplication value ifTrue:[
            currentUserPrefs useNewSettingsApplication:useNewSettingsApplication value.
            NewLauncher open.
        ].
        (Smalltalk at:#FileBrowserV2) isBehavior ifTrue:[
            useNewFileBrowser value ifTrue:[
                FileBrowserV2 installInLauncher.
            ] ifFalse:[
                FileBrowserV2 isLoaded ifTrue:[
                    FileBrowserV2 removeFromLauncher.
                ]
            ].
        ].
        showClock := showClockInLauncher value.
        currentUserPrefs showClockInLauncher ~= showClock ifTrue:[
            currentUserPrefs showClockInLauncher:showClock.
            currentTranscript isExternalStream ifFalse:[
                launcher := Transcript application.
                (launcher isKindOf:ToolApplicationModel) ifTrue:[
                    showClock ifTrue:[
                        launcher startClock
                    ] ifFalse:[
                        launcher stopClock
                    ]
                ]
            ]
        ].

        Inspector := currentUserPrefs inspectorClassSetting.

        transcriptBufferSize := Integer readFrom:transcriptBufferSize value onError:currentTranscript lineLimit.
        currentTranscript lineLimit:transcriptBufferSize.

    ].
    box destroy

"
    self toolSettings
"
    "Modified: / 9.9.1996 / 22:43:36 / stefan"
    "Modified: / 16.4.1998 / 17:18:47 / ca"
    "Created: / 13.10.1998 / 15:44:36 / cg"
    "Modified: / 12.11.2001 / 15:48:54 / cg"
!

viewStyleSettings
    self viewStyleSettingsFor:nil
!

viewStyleSettingsFor:requestor
    "open a dialog on viewStyle related settings.
     Obsoleted by the settings application"

    |resourceDir dir box
     list listView scrView infoLabel infoForwarder newStyle
     someRsrcFile didApply resources listUpdater showStandardStylesOnly standardStyles|

    showStandardStylesOnly := true asValue.
    standardStyles := #(
                        'decWindows'
                        'iris'
                        'motif'
                        'mswindows95'
                        'mswindowsXP'
                        'mswindowsVista'
                        'next'
                        'normal'
                        'os2'
                        'st80'
                       ).

    resources := self owningClass classResources.

    "
     search resources directory for a list of .style files ...
    "
    someRsrcFile := Smalltalk getSystemFileName:('resources' asFilename constructString:'normal.style').
    someRsrcFile isNil ifTrue:[
        someRsrcFile := Smalltalk getResourceFileName:'normal.style' forPackage:'stx:libview'.
        someRsrcFile isNil ifTrue:[
            someRsrcFile := Smalltalk getResourceFileName:'styles/normal.style' forPackage:'stx:libview'.
        ].
    ].
    someRsrcFile notNil ifTrue:[
        resourceDir := someRsrcFile asFilename directoryName
    ] ifFalse:[
        resourceDir := Smalltalk getSystemFileName:'resources'.
    ].

    resourceDir isNil ifTrue:[
        self warn:'no styles found (missing ''resources'' directory)'.
        ^ self
    ].
    dir := resourceDir asFilename directoryContents.

    list := SelectionInList new.

    listUpdater := [
        |listOfStyles lastSelection|

        lastSelection := list selection.
        listOfStyles := dir select:[:aFileName | aFileName asFilename hasSuffix:'style'].
        listOfStyles := listOfStyles collect:[:aFileName | aFileName asFilename nameWithoutSuffix].
        Filename isCaseSensitive ifFalse:[
            listOfStyles := listOfStyles collect:[:aStyleName | aStyleName asLowercase].
        ].
        listOfStyles remove:'generic' ifAbsent:nil; remove:'mswindows3' ifAbsent:nil.
        showStandardStylesOnly value ifTrue:[
            listOfStyles := listOfStyles select:[:aStyleName | standardStyles includes:aStyleName].
        ].

        listOfStyles sort.
        list list:listOfStyles.
        list selection:lastSelection.
    ].
    listUpdater value.

    showStandardStylesOnly onChangeEvaluate:listUpdater.

    infoForwarder := [
                        |nm sheet comment|

                        comment := ''.
                        nm := list selection.
                        nm notNil ifTrue:[
                            sheet := ViewStyle fromFile:(nm , '.style').
                            comment := (sheet at:#comment ifAbsent:'') withoutSeparators.
                        ].
                        comment := comment withCRs asStringCollection.
                        comment size == 1 ifTrue:[
                            comment := comment first
                        ].
                        infoLabel label:comment
                       ].

    list onChangeEvaluate:infoForwarder.

    box := Dialog new.
    box label:(resources string:'Style Selection').

    box addTextLabel:(resources at:'STYLE_MSG' default:'Select a Style') withCRs adjust:#left.
    listView := SelectionInListView on:list.
    listView doubleClickAction:[:sel | box acceptChannel value:true. box hide].
    box addCheckBox:(resources string:'standard styles only') on:showStandardStylesOnly.
    scrView := box addComponent:(ScrollableView forView:listView) tabable:true.

    box addVerticalSpace.

    infoLabel := box addTextLabel:'\\' withCRs adjust:#centerLeft.

    box addAbortAndOkButtons.
"/ mhmh - the newLauncher does not yet handle apply (without close) correctly
"/    b := box addButton:(Button label:(resources string:'apply')).
"/    b action:[didApply := true. requestor changeViewStyleTo:(list selection)].

    (standardStyles includes:View defaultStyle) ifFalse:[
        showStandardStylesOnly value:false
    ].
    list selection:(View defaultStyle).

    box stickAtBottomWithVariableHeight:scrView.
    box stickAtBottomWithFixHeight:infoLabel.
    didApply := false.
    box open.

    box destroy.
    box accepted ifTrue:[
        ((newStyle := list selection) ~= View defaultStyle
        or:[didApply ~~ true]) ifTrue:[
            requestor notNil ifTrue:[requestor changeViewStyleTo:newStyle].
        ].
    ].

    "
     self viewStyleSettingsFor:nil
    "

    "Modified: / 07-11-2006 / 13:58:06 / cg"
! !

!AbstractLauncherApplication::LauncherDialogs class methodsFor:'dialogs-file'!

objectModuleDialog
    "opens a moduleInfo dialog"

    self objectModuleDialogReadOnly:false

    "Modified: / 19-09-2006 / 19:14:20 / cg"
!

objectModuleDialogReadOnly
    "opens a moduleInfo dialog"

    self objectModuleDialogReadOnly:true

    "Created: / 19-09-2006 / 19:14:27 / cg"
!

objectModuleDialogReadOnly:readOnly
    "opens a moduleInfo dialog"

    |allModules moduleNames
     allObjects methodObjects methodNames
     cObjects cObjectNames
     otherObjects otherObjectNames
     box l handles unloadButton unloadAndRemoveButton
     list1 list2 listView1 listView2
     y panel
     showBuiltIn showModules showMethods showCObjects showOthers
     moduleListUpdater check canDoIt menu
     resources middleLabel device screenW screenH|

    resources := self owningClass classResources.

    showBuiltIn := true asValue.
    canDoIt := ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles].

    showModules := canDoIt asValue.
    showMethods := canDoIt asValue.
    showCObjects := canDoIt asValue.
    showOthers := canDoIt asValue.

    list1 := SelectionInList new.
    list2 := SelectionInList new.

    moduleListUpdater := [
            |l|

            list2 list:nil.

            l := #().
            handles := #().

            (showModules value or:[showBuiltIn value]) ifTrue:[
                allModules := ObjectMemory binaryModuleInfo asOrderedCollection.
                (showBuiltIn value and:[showModules value]) ifFalse:[
                    allModules := allModules select:[:i |
                        |wantToSee|

                        wantToSee := i dynamic.
                        showBuiltIn value ifTrue:[
                            wantToSee := wantToSee not
                        ].
                        wantToSee
                    ]
                ].

                "/ sorting by reverse id brings newest ones to the top (a side effect)
                allModules sort:[:a :b | (a id) > (b id)].
                moduleNames := allModules collect:[:entry | entry name].
                l := l , moduleNames.
                handles := handles , allModules.
            ].

            showMethods value ifTrue:[
                allObjects := ObjectFileLoader loadedObjectHandles.
                methodObjects := (allObjects select:[:h | h isMethodHandle]) asArray.
                methodNames := methodObjects collect:[:mH | mH method isNil ifTrue:[
                                                                'compiled method - removed' " , ' (in ' , mH pathName , ')' "
                                                            ] ifFalse:[
                                                                'compiled method ' , mH method whoString  " , ' (in ' , mH pathName , ')' "
                                                            ].
                                                     ].
                l := l , methodNames.
                handles := handles , methodObjects.
            ].

            showCObjects value ifTrue:[
                allObjects := ObjectFileLoader loadedObjectHandles.
                cObjects := (allObjects select:[:h | h isFunctionObjectHandle]) asArray.
                cObjectNames := cObjects collect:[:entry | entry pathName].
                l := l , cObjectNames.
                handles := handles , cObjects.
            ].

            showOthers value ifTrue:[
                allObjects := ObjectFileLoader loadedObjectHandles.
                otherObjects := (allObjects reject:[:h | (h isFunctionObjectHandle
                                                         or:[h isMethodHandle
                                                         or:[h isClassLibHandle]])]) asArray.
                otherObjectNames := otherObjects collect:[:entry | entry pathName].
                l := l , otherObjectNames.
                handles := handles , otherObjects.
            ].

            showBuiltIn value ifTrue:[
                l := #('VM') , l.
                handles := #(VM) , handles.
                allModules := #(VM) , allModules.
            ].

            list1 list:l.
            readOnly ifFalse:[
                unloadButton disable.
                unloadAndRemoveButton disable.
            ]
        ].

    showBuiltIn onChangeEvaluate:moduleListUpdater.
    showModules onChangeEvaluate:moduleListUpdater.
    showMethods onChangeEvaluate:moduleListUpdater.
    showCObjects onChangeEvaluate:moduleListUpdater.
    showOthers onChangeEvaluate:moduleListUpdater.

    box := Dialog new.
    box label:(resources string:'ST/X & Module Version Information').

    listView1 := HVScrollableView for:SelectionInListView miniScrollerH:true.
    listView1 model:list1.
    listView1 origin:0.0@0.0 corner:1.0@0.4. "/ ; inset:2.
    listView1 action:[:sel |
        |info classNames tabs module|

        listView1 middleButtonMenu:nil.

        box withWaitCursorDo:[
            |nm fileName addr entry1 entry2 entry3 method l|

            tabs := TabulatorSpecification unit:#inch positions:#(0 2.6 3.5).

            (showModules value or:[showBuiltIn value]) ifTrue:[
                info := allModules at:sel ifAbsent:nil.
            ].
            info isNil ifTrue:[
                "/ selected a method, cObject or unknown

                module := handles at:sel.
                fileName := module pathName.

                module isMethodHandle ifTrue:[
                    middleLabel label:'contains method:'.

                    (method := module method) isNil ifTrue:[
                        nm := '** removed **'.
                    ] ifFalse:[
                        menu := PopUpMenu
                                    labels:#('Inspect' 'Browse')
                                    selectors:#(inspect browse).
                        menu actionAt:#inspect put:[ method inspect ].
                        menu actionAt:#browse put:[ |who|
                                                    who := method who.
                                                    UserPreferences systemBrowserClass
                                                        openInClass:(who methodClass)
                                                        selector:(who methodSelector)
                                                  ].
                        listView1 middleButtonMenu:menu.

                        nm := (method whoString) withColor:(Color blue).
                    ].
                    entry1 := MultiColListEntry new:2 tabulatorSpecification:tabs.
                    entry1 colAt:1 put:'compiled method'; colAt:2 put:nm.

                    entry2 := MultiColListEntry new:2 tabulatorSpecification:tabs.
                    entry2 colAt:1 put:'path'; colAt:2 put:fileName.

                    entry3 := MultiColListEntry new:2 tabulatorSpecification:tabs.
                    entry3 colAt:1 put:'address'; colAt:2 put:('(16r) ' , (method code address hexPrintString leftPaddedTo:8 with:$0)).

                    list2 list:(Array with:entry1 with:entry2 with:entry3).
                ] ifFalse:[
                    (module isFunctionObjectHandle
                    and:[module functions notEmpty]) ifTrue:[
                        middleLabel label:'contains function:'.

                        menu := PopUpMenu
                                    labels:#('Inspect')
                                    selectors:#(inspect).
                        menu actionAt:#inspect put:[ module functions inspect  ].
                        listView1 middleButtonMenu:menu.

                        list2 list:((module functions select:[:f | f notNil])
                                        collect:[:f | |entry|
                                                        entry := MultiColListEntry new:2 tabulatorSpecification:tabs.
                                                        entry colAt:1 put:(f name withColor:Color blue).
                                                        entry colAt:2 put:('address: (16r) ' , (f code address hexPrintString leftPaddedTo:8 with:$0)).
                                                        entry
                                                ]).
                    ] ifFalse:[
                        list2 list:#('nothing known about contents (no functions have been extracted)').
                    ]
                ].

                readOnly ifFalse:[
                    unloadButton enable.
                    unloadAndRemoveButton disable.
                ]
            ] ifFalse:[
                info == #VM ifTrue:[
                    "/ dummy entry for VM;
                    "/ show file versions in lower view.

                    middleLabel label:'contains modules:'.
                    l := (ObjectMemory getVMIdentificationStrings).
                    l := l select:[:entry | entry includesString:'$Header'].
                    l := l select:[:entry | entry includesString:',v'].
                    l := l collect:[:entry |
                        |i1 i2 file revision date listEntry|

                        listEntry := MultiColListEntry new:3 tabulatorSpecification:tabs.

                        i1 := entry indexOfSubCollection:'librun'.
                        i1 ~~ 0 ifTrue:[
                            i2 := entry indexOfSubCollection:',v' startingAt:i1.
                            i2 ~~ 0 ifTrue:[
                                file := entry copyFrom:i1+7 to:(i2-1).
                                listEntry colAt:1 put:file.

                                i1 := i2+3.
                                i2 := entry indexOfSeparatorStartingAt:i1.
                                revision := entry copyFrom:i1 to:(i2-1).
                                listEntry colAt:2 put:revision.

                                i1 := i2+1.
                                i2 := entry indexOfSeparatorStartingAt:i1.
                                date := entry copyFrom:i1 to:(i2-1).
                                listEntry colAt:3 put:date.
                            ].
                        ].
                        listEntry.
                        "/ entry
                    ].
                    list2 list:l.

                    readOnly ifFalse:[
                        unloadButton disable.
                        unloadAndRemoveButton disable.
                    ]
                ] ifFalse:[
                    "/ selected a package

                    "/ fill bottom list with class-info

                    middleLabel label:'contains classes:'.
                    classNames := info classNames asSortedCollection.
                    classNames := classNames select:[:cName |
                                    |cls|

                                    cls := Smalltalk classNamed:cName.
                                    cls isNil ifTrue:[
                                        true "a removed class"
                                    ] ifFalse:[
                                        cls isPrivate not
                                    ].
                                  ].

                    classNames := classNames collect:[:cName |
                                    |cls entry rev listEntry|

                                    listEntry := MultiColListEntry new:2 tabulatorSpecification:tabs.
                                    listEntry colAt:1 put:cName.

                                    cls := Smalltalk classNamed:cName.
                                    cls isNil ifTrue:[
                                        listEntry colAt:2 put:'(class removed)'.
                                    ] ifFalse:[
                                        rev := cls binaryRevision.
                                        rev notNil ifTrue:[
                                            cls isLoaded ifFalse:[
                                                entry := '(stub for: ' , rev.
                                            ] ifTrue:[
                                                entry :='(bin: ' , rev.
                                            ].
                                            cls revision ~= rev ifTrue:[
                                                entry := entry , ' / src: ' , (cls revision printString)
                                            ].
                                            listEntry colAt:2 put:entry , ')'
                                        ] ifFalse:[
                                           cls revision notNil ifTrue:[
                                                listEntry colAt:2 put:'(overloaded by: ' , cls revision , ')'
                                           ]
                                        ]
                                    ].
                                    listEntry
                                  ].
                    list2 list:classNames.
                    readOnly ifFalse:[
                        info dynamic ifTrue:[
                            unloadButton enable.
                            unloadAndRemoveButton enable.
                        ] ifFalse:[
                            unloadButton disable.
                            unloadAndRemoveButton disable.
                        ].
                    ].
                ].
            ]
        ]
    ].


    panel := HorizontalPanelView new.

    panel add:(l := Label label:'Show:').
    l adjust:#left; borderWidth:0.
    panel add:(check := CheckBox label:'Builtin' model:showBuiltIn).
    box makeTabable:check.
    panel add:(check := CheckBox label:'ClassLibs' model:showModules).
    canDoIt ifFalse:[
        check disable
    ] ifTrue:[
        box makeTabable:check.
    ].
    panel add:(check := CheckBox label:'Methods' model:showMethods).
    canDoIt ifFalse:[
        check disable
    ] ifTrue:[
        box makeTabable:check.
    ].
    panel add:(check := CheckBox label:'C-objects' model:showCObjects).
    canDoIt ifFalse:[
        check disable
    ] ifTrue:[
        box makeTabable:check.
    ].
    panel add:(check := CheckBox label:'Others' model:showOthers).
    canDoIt ifFalse:[
        check disable
    ] ifTrue:[
        box makeTabable:check.
    ].

    panel horizontalLayout:#fitSpace.
    "/ panel horizontalLayout:#leftSpace.

    box addComponent:panel tabable:false.

    box addVerticalSpace.
    box addComponent:listView1 tabable:true.
    listView1 topInset:(View viewSpacing + panel preferredHeight).
    listView1 origin:0.0@0.0 corner:1.0@0.4. "/ ; inset:2.

    l := box addTextLabel:(resources string:'Contains:').
    l adjust:#left; borderWidth:0.
    l origin:0.0@0.4 corner:1.0@0.4.
    l topInset:(View viewSpacing).
    l bottomInset:((l preferredHeight) negated - View viewSpacing).
    middleLabel := l.

    listView2 := HVScrollableView for:SelectionInListView  miniScrollerH:true.
    listView2 model:list2; printItems:false.
    box addComponent:listView2 tabable:true.
    listView2 origin:0.0@0.4 corner:1.0@1.0. "/ ; inset:2.
    listView2 disable.

    menu := PopUpMenu
                itemList:#(
                    ('Copy List'    copyList  )
                )
                resources:resources.
    menu
        actionAt:#copyList
        put:[ listView2 setClipboardText:((listView2 list collect:[:l | l string]) asStringCollection asString)  ].
    listView2 middleButtonMenu:menu.

    readOnly ifFalse:[
        unloadButton := Button label:(resources string:'Unload').
        unloadButton action:[
            box withWaitCursorDo:[
                |handle idx|

                idx := list1 selectionIndex.
                list1 selectionIndex:nil.

                handle := handles at:idx.
                handle notNil ifTrue:[
                    handle unload.
                ].
                moduleListUpdater value.
                unloadButton disable.
            ]
        ].

        unloadAndRemoveButton := Button label:(resources string:'Remove Classes & Unload').
        unloadAndRemoveButton action:[
            box withWaitCursorDo:[
                |info idx pathName|

                idx := list1 selectionIndex.
                info := allModules at:idx ifAbsent:nil.

                list1 selectionIndex:nil.

                info isNil ifTrue:[
                    "/ selected a method
                    "/ idx := idx - allModules size.
                    pathName := (handles at:idx) pathName.

                ] ifFalse:[
                    "/ selected a package
                    pathName := info pathName.
                ].
                ObjectFileLoader unloadObjectFileAndRemoveClasses:pathName.
                moduleListUpdater value.
                unloadAndRemoveButton disable.
            ]
        ].
    ].

    moduleListUpdater value.

    readOnly ifFalse:[
        box addButton:unloadButton.
        box addButton:unloadAndRemoveButton.
    ].
    box addAbortButtonLabelled:(resources string:'Dismiss').

    y := box yPosition.
    listView2 topInset:(l preferredHeight + 5).
    listView2 bottomInset:(box preferredHeight - y).

    device := box device.
    screenW := device width.
    screenH := device height.   
    box width:(400 min:(screenW * 2 // 3));
        height:(450 min:(screenH - 50)).

"/  box sizeFixed:true.
    box extent:(600 min:(screenW * 2 // 3))
               @
               (500 min:(screenH - 50)) .
    box openModeless.
"/    box destroy.
"
    self objectModuleDialog
"

    "Modified: / 17-09-1995 / 16:47:50 / claus"
    "Created: / 19-09-2006 / 19:14:06 / cg"
! !

!AbstractLauncherApplication::LauncherDialogs class methodsFor:'dialogs-private'!

cvsConfigurationDialog
    |cvsRootHolder resources defaultsList bindings dialog
     listOfModules selectedPerModuleRoot rootsPerModule acceptChannel
     removeEnabled cvsExecutableHolder|

    resources := self owningClass classResources.

    OperatingSystem getDomainName = 'bh.exept.de' ifTrue:[
        defaultsList := #(
                            'cvs.bh.exept.de:/cvs/stx'
                         ).
        defaultsList := defaultsList copyWith:(':pserver:' , OperatingSystem getLoginName , '@cvs.bh.exept.de:/cvs/stx')
    ] ifFalse:[
        defaultsList := #(
                            ':pserver:user@CVSHOST:/cvs/stx'
                         ).
        defaultsList := defaultsList copyWith:(':pserver:' , OperatingSystem getLoginName , '@CVSHOST:/cvs/stx')
    ].

    OperatingSystem isUNIXlike ifTrue:[
        defaultsList := defaultsList , #(
                          '/cvs/stx'
                         ).
    ] ifFalse:[
        OperatingSystem isMSDOSlike ifTrue:[
            defaultsList := defaultsList , #(
                              ':local:c:\cvs\stx'
                             ).
        ] ifFalse:[
            "there might be more here in the future"
        ]
    ].

    cvsRootHolder := CVSSourceCodeManager repositoryName ? '/cvs/stx'.
    cvsRootHolder := cvsRootHolder asValue.
    rootsPerModule := Dictionary new.
    rootsPerModule addAll:(CVSSourceCodeManager repositoryInfoPerModule).
    cvsExecutableHolder := CVSSourceCodeManager cvsExecutable asValue.

    bindings := IdentityDictionary new.
    bindings at:#acceptChannel put:(acceptChannel := TriggerValue new).

    bindings at:#cvsRootPrototypeList put:defaultsList.
    bindings at:#cvsRootHolder put:cvsRootHolder.
    bindings at:#perModuleRootModule put:nil asValue.
    bindings at:#perModuleRoot put:nil asValue.
    bindings at:#removeEnabled put:(removeEnabled := false asValue).
    bindings at:#listOfModules put:(listOfModules := rootsPerModule keys asList).
    bindings at:#cvsExecutableHolder put:cvsExecutableHolder.
    listOfModules sort.

    bindings at:#selectedPerModuleRoot put:(selectedPerModuleRoot := nil asValue).
    selectedPerModuleRoot
             onChangeEvaluate:[
                            |module cvsRoot|

                            acceptChannel value:true.
                            module := selectedPerModuleRoot value.
                            removeEnabled value:true.
                            cvsRoot := rootsPerModule at:module ifAbsent:''.
                            (bindings at:#perModuleRootModule) value:module.
                            (bindings at:#perModuleRoot) value:cvsRoot.
             ].

    bindings at:#help put:[
                            WindowGroup activeGroup withWaitCursorDo:[
                                HTMLDocumentView openFullOnHelpFile:'Launcher/cvsSetup.html'
                            ]
                          ].

    bindings at:#addPerModuleRoot put:[
                            |module cvsRoot|

                            acceptChannel value:true.
                            module := (bindings at:#perModuleRootModule) value.
                            cvsRoot := (bindings at:#perModuleRoot) value.
                            (listOfModules includes:module) ifFalse:[
                                listOfModules add:module.
                                listOfModules sort.
                            ].
                            cvsRoot size > 0 ifTrue:[
                                rootsPerModule at:module put:cvsRoot.
                            ].
                          ].
    bindings at:#removePerModuleRoot put:[
                            |module|

                            acceptChannel value:true.
                            module := (bindings at:#perModuleRootModule) value.
                            listOfModules remove:module ifAbsent:nil.
                            rootsPerModule removeKey:module ifAbsent:nil.
                            (bindings at:#perModuleRootModule) value:nil.
                            (bindings at:#perModuleRoot) value:nil.
                          ].

    dialog := SimpleDialog new.
    dialog resources:resources.
    (dialog openSpec:(self cvsSetupSpec) withBindings:bindings) ifFalse:[
        ^ self
    ].

    acceptChannel value.

    "/
    "/ update system settings
    "/
    CVSSourceCodeManager cvsExecutable:cvsExecutableHolder value.
    CVSSourceCodeManager initializeForRepository:cvsRootHolder value.
    CVSSourceCodeManager repositoryInfoPerModule:rootsPerModule.

    "
     self cvsConfigurationDialog
    "

    "Modified: / 21-09-2006 / 16:54:20 / cg"
!

fontBoxForEncoding:encodingMatch
    "open a fontBox, showing fonts which match some encoding
     (used when changing to japanese ...)"

    |box y b
     labelDef buttonDef listDef menuDef textDef
     models labels allOfThem filter resources defaultButton|

    resources := self owningClass classResources.

    encodingMatch notNil ifTrue:[
        filter := [:f | f encoding notNil
                        and:[encodingMatch match:f encoding]].
    ].

    models := OrderedCollection new.
    labels := OrderedCollection new.

    models add:(allOfThem := nil asValue).
    models add:(labelDef := Label defaultFont asValue).
    models add:(buttonDef := Button defaultFont asValue).
    models add:(listDef := SelectionInListView defaultFont asValue).
    models add:(menuDef := MenuView defaultFont asValue).
    models add:(textDef := TextView defaultFont asValue).

    box := Dialog new.
    box label:(resources string:'Font Settings').

    models
    with:(resources array:#('All' 'Labels' 'Buttons' 'Lists' 'Menus' 'Edited Text'))
    do:[:model :title |
        |y2 lbl f i|

        f := model value.

        box addTextLabel:title adjust:#left.

        y := box yPosition.
        b := box addComponent:(Button label:(resources string:'Change ...')) tabable:true.
        b relativeExtent:nil; extent:(b preferredExtent).
        y2 := box yPosition.
        box yPosition:y.
        i := box leftIndent.
        box leftIndent:(b widthIncludingBorder + View viewSpacing).
        (lbl := box addTextLabel:'')
            adjust:#left;
            font:(model value);
            labelChannel:(BlockValue
                            with:[:v | |f|
                                f := v.
                                f isNil ifTrue:[
                                    ''
                                ] ifFalse:[
                                    f userFriendlyName
                                ]
                            ]
                            argument:model).
        labels add:lbl.

        box leftIndent:i.
        box yPosition:(box yPosition max:y2).

        box addVerticalSpace; addHorizontalLine; addVerticalSpace.

        b action:[
            |f|

            f := FontPanel
                    fontFromUserInitial:(model value)
                    title:(resources string:'Font for %1' with:title)
                    filter:filter
                    encoding:encodingMatch.
            f notNil ifTrue:[
                model == allOfThem ifTrue:[
                    models do:[:m | m value:f].
                    labels do:[:l | l font:f]
                ] ifFalse:[
                    model value:f.
                    lbl font:f.
                ].
            ]
        ].
        model == allOfThem ifTrue:[
            box addVerticalSpace
        ]
    ].

    box addAbortAndOkButtons.
    defaultButton := Button label:(resources string:'Defaults').

    box addButton:defaultButton.
    defaultButton
        action:[
            "/ fetch defaults
"/            View readStyleSheetAndUpdateAllStyleCaches.
            labelDef value: Label defaultFont.
            buttonDef value: Button defaultFont.
            listDef value: SelectionInListView defaultFont.
            menuDef value: MenuView defaultFont.
            textDef value: TextView defaultFont.
        ].

    box open.
    box accepted ifTrue:[
        Label defaultFont:labelDef value.
        Button defaultFont:buttonDef value.
        Toggle defaultFont:buttonDef value.
        TextView withAllSubclasses do:[:cls | cls defaultFont:textDef value].
        SelectionInListView withAllSubclasses do:[:cls | cls defaultFont:listDef value].
        MenuView defaultFont:menuDef value.
        MenuPanel defaultFont:menuDef value.
        NoteBookView defaultFont:menuDef value.
        PullDownMenu defaultFont:menuDef value.
    ].
    box destroy.
    ^ box accepted

    "Created: / 27-02-1996 / 01:44:16 / cg"
    "Modified: / 17-06-1996 / 13:38:48 / stefan"
    "Modified: / 29-08-2013 / 12:20:48 / cg"
!

formattingConfigurationDialog
    |dialog
     resources exampleText formattedText reformatAction
     reformatLocked
     oldUserPreferences
     currentUserPrefs
     tabIndent
     spaceAroundTemporaries emptyLineAfterTemporaries
     spaceAfterReturnToken spaceAfterKeywordSelector cStyleBlocks
     blockArgumentsOnNewLine
     maxLengthForSingleLineBlocks resetValue bindings|

    RBFormatter isNil ifTrue:[
        ^ self warn:'Sorry, no RBFormatter class'.
    ].

    RBFormatter isLoaded ifFalse:[
        WindowGroup activeGroup withWaitCursorDo:[
            RBFormatter autoload
        ]
    ].

    resources := self owningClass classResources.
    currentUserPrefs := UserPreferences current.

    exampleText :=
'methodSelector:methodArg
    "method comment:
     some stupid code to show the current settings"

    |index|

    "/ another comment ...
    self at:index.                      "/ a message
    self at:index put:methodArg.        "/ a two arg message
    self from:1 to:index put:methodArg. "/ a three arg message
    methodArg ifTrue:[
        Transcript showCR:''hello''.      "/ condition
    ].
    methodArg ifTrue:[
        Transcript showCR:''hello''.      "/ condition
    ] ifFalse:[
        Transcript showCR:''world''.
    ].
    [methodArg] whileTrue:[
        Transcript showCR:''hello''.      "/ looping
    ].
    [self aVeryLongConditionBlock and:[self toMakeBlockLonger]] whileTrue:[
        Transcript showCR:''hello''.      "/ long blocks
    ].
    methodArg do:[:element |
        Transcript showCR:''hello''.      "/ looping
    ].
    1 to:methodArg size do:[:index |
        Transcript showCR:''hello''.      "/ looping
    ].
    methodArg keysAndValuesDo:[:index |
        Transcript showCR:''hello''.      "/ looping
    ].
    Object errorSignal handle:[:ex |
        ex return
    ] do:[                                "/ exception handling
        self someAction                   "/ blocks
    ].
    ^ self.
'.

    formattedText := '' asValue.
    reformatLocked := false.

    reformatAction := [ |tree
                         s_tabIndent s_spaceAroundTemporaries s_emptyLineAfterTemporaries
                         s_spaceAfterReturnToken s_spaceAfterKeywordSelector s_cStyleBlocks
                         s_maxLengthForSingleLineBlocks s_blockArgumentsOnNewLine|

                        reformatLocked ifFalse:[
                            "/
                            "/ temporary change the RBFormatters settings ...
                            "/
                            s_tabIndent := RBFormatter tabIndent.
                            s_spaceAroundTemporaries := RBFormatter spaceAroundTemporaries.
                            s_emptyLineAfterTemporaries := RBFormatter emptyLineAfterTemporaries.
                            s_spaceAfterReturnToken := RBFormatter spaceAfterReturnToken.
                            s_spaceAfterKeywordSelector := RBFormatter spaceAfterKeywordSelector.
                            s_cStyleBlocks := RBFormatter cStyleBlocks.
                            s_blockArgumentsOnNewLine := RBFormatter blockArgumentsOnNewLine.
                            s_maxLengthForSingleLineBlocks := RBFormatter maxLengthForSingleLineBlocks.

                            RBFormatter
                                tabIndent:tabIndent value;
                                spaceAroundTemporaries:spaceAroundTemporaries value;
                                emptyLineAfterTemporaries:emptyLineAfterTemporaries value;
                                spaceAfterReturnToken:spaceAfterReturnToken value;
                                spaceAfterKeywordSelector:spaceAfterKeywordSelector value;
                                cStyleBlocks:cStyleBlocks value;
                                blockArgumentsOnNewLine:blockArgumentsOnNewLine value;
                                maxLengthForSingleLineBlocks:maxLengthForSingleLineBlocks value.

                            tree := RBParser
                                        parseMethod:exampleText
                                        onError: [:aString :position | nil].
                            tree do:[:node |
                                (node ~~ tree and:[node parent isNil]) ifTrue:[
                                    self error:'No parent for node'.
                                ]
                            ].
                            formattedText value:tree printString.

                            RBFormatter
                                tabIndent:s_tabIndent;
                                spaceAroundTemporaries:s_spaceAroundTemporaries;
                                emptyLineAfterTemporaries:s_emptyLineAfterTemporaries;
                                spaceAfterReturnToken:s_spaceAfterReturnToken;
                                spaceAfterKeywordSelector:s_spaceAfterKeywordSelector;
                                cStyleBlocks:s_cStyleBlocks;
                                blockArgumentsOnNewLine:s_blockArgumentsOnNewLine;
                                maxLengthForSingleLineBlocks:s_maxLengthForSingleLineBlocks.
                          ].
                      ].

    bindings := IdentityDictionary new.
    bindings at:#formattedText put:formattedText.

    oldUserPreferences := currentUserPrefs copy.

    tabIndent := RBFormatter tabIndent asValue.
    tabIndent onChangeEvaluate:reformatAction.
    bindings at:#tabIndent put:tabIndent.

    spaceAroundTemporaries := RBFormatter spaceAroundTemporaries asValue.
    spaceAroundTemporaries onChangeEvaluate:reformatAction.
    bindings at:#spaceAroundTemporaries put:spaceAroundTemporaries.

    emptyLineAfterTemporaries := RBFormatter emptyLineAfterTemporaries asValue.
    emptyLineAfterTemporaries onChangeEvaluate:reformatAction.
    bindings at:#emptyLineAfterTemporaries put:emptyLineAfterTemporaries.

    spaceAfterReturnToken := RBFormatter spaceAfterReturnToken asValue.
    spaceAfterReturnToken onChangeEvaluate:reformatAction.
    bindings at:#spaceAfterReturnToken put:spaceAfterReturnToken.

    spaceAfterKeywordSelector := RBFormatter spaceAfterKeywordSelector asValue.
    spaceAfterKeywordSelector onChangeEvaluate:reformatAction.
    bindings at:#spaceAfterKeywordSelector put:spaceAfterKeywordSelector.

    cStyleBlocks := RBFormatter cStyleBlocks asValue.
    cStyleBlocks onChangeEvaluate:reformatAction.
    bindings at:#cStyleBlocks put:cStyleBlocks.

    blockArgumentsOnNewLine := RBFormatter blockArgumentsOnNewLine asValue.
    blockArgumentsOnNewLine onChangeEvaluate:reformatAction.
    bindings at:#blockArgumentsOnNewLine put:blockArgumentsOnNewLine.

    maxLengthForSingleLineBlocks := RBFormatter maxLengthForSingleLineBlocks asValue.
    maxLengthForSingleLineBlocks onChangeEvaluate:reformatAction.
    bindings at:#maxLengthForSingleLineBlocks put:maxLengthForSingleLineBlocks.

    bindings at:#resetList   put:#( 'ST/X default' 'RB default' ).
    bindings at:#resetValue  put:(resetValue := nil asValue).
    resetValue onChangeEvaluate:
        [
            resetValue value == 1 ifTrue:[
                "/ ST/X defaults
                reformatLocked := true.
                tabIndent value: 4.
                spaceAfterReturnToken value: true.
                spaceAfterKeywordSelector value: false.
                spaceAroundTemporaries value: false.
                emptyLineAfterTemporaries value: true.
                cStyleBlocks value: true.
                blockArgumentsOnNewLine value:false.
                maxLengthForSingleLineBlocks value: 20.
                reformatLocked := false.
                reformatAction value.
            ].
            resetValue value == 2 ifTrue:[
                "/ RBParser defaults
                reformatLocked := true.
                tabIndent value: 8.
                spaceAfterReturnToken value: false.
                spaceAfterKeywordSelector value: true.
                spaceAroundTemporaries value: true.
                emptyLineAfterTemporaries value: false.
                cStyleBlocks value: false.
                blockArgumentsOnNewLine value:false.
                maxLengthForSingleLineBlocks value: 20.
                reformatLocked := false.
                reformatAction value.
            ].
            resetValue value:nil. "/ to force default label
        ].

    reformatAction value.

    "/
    "/ create a box on those ...
    "/
    dialog := SimpleDialog new.
    dialog postBuildBlock:[:builder |
                                (builder componentAt:#sampleTextView)
                                    cursorMovementWhenUpdating:nil;
                                    scrollWhenUpdating:nil.
                          ].
    (dialog openFor:nil
        spec:(self formatterDialogSpec)
        withBindings:bindings)
    ifTrue:[
        currentUserPrefs at:#'formatter.tabIndent' put:tabIndent value.
        currentUserPrefs at:#'formatter.spaceAroundTemporaries' put:spaceAroundTemporaries value.
        currentUserPrefs at:#'formatter.emptyLineAfterTemporaries' put:emptyLineAfterTemporaries value.
        currentUserPrefs at:#'formatter.spaceAfterReturnToken' put:spaceAfterReturnToken value.
        currentUserPrefs at:#'formatter.spaceAfterKeywordSelector' put:spaceAfterKeywordSelector value.
        currentUserPrefs at:#'formatter.cStyleBlocks' put:cStyleBlocks value.
        currentUserPrefs at:#'formatter.blockArgumentsOnNewLine' put:blockArgumentsOnNewLine value.
        currentUserPrefs at:#'formatter.maxLengthForSingleLineBlocks' put:maxLengthForSingleLineBlocks value.
        RBFormatter
            tabIndent:tabIndent value;
            spaceAroundTemporaries:spaceAroundTemporaries value;
            emptyLineAfterTemporaries:emptyLineAfterTemporaries value;
            spaceAfterReturnToken:spaceAfterReturnToken value;
            spaceAfterKeywordSelector:spaceAfterKeywordSelector value;
            cStyleBlocks:cStyleBlocks value;
            blockArgumentsOnNewLine:blockArgumentsOnNewLine value;
            maxLengthForSingleLineBlocks:maxLengthForSingleLineBlocks value.
    ] ifFalse: [
        (UserPreferences reset; current) addAll: oldUserPreferences
    ].
"
    self formattingConfigurationDialog
"
!

syntaxColorConfigurationDialog
    |box frame exampleView y
     resources exampleText coloredText recolorAction
     syntaxColor syntaxColors colorMenu oldUserPreferences
     syntaxEmphasises syntaxColorSelector syntaxEmphasisSelector syntaxColoringBox
     syntaxEmphasisesBox syntaxColoringResetButton b resetList
     resetListBox currentUserPrefs|

    resources := self owningClass classResources.
    currentUserPrefs := UserPreferences current.

    exampleText :=
'methodSelector:methodArg
    "method comment:
     some stupid code to show the current settings"

    |methodVar|

    "/ another comment ...
    self at:methodArg.        "/ a message
    self fooBarBaz:methodVar. "/ a bad message
    methodVar := Array new:1.
    unknonVar := 1.           "/ a bad variable
    UnknonVar := 1.           "/ another bad variable
    "self bar:methodVar.  detect commented code easily"
    1 to:5 do:[:i | self at:i + 1].
    Transcript showCR:''some string'' , #someSymbol.
    ^ self.
'.

    coloredText := '' asValue.
    recolorAction := [ coloredText value:(SyntaxHighlighter formatMethodSource:exampleText in:nil) ].
    recolorAction value.

    "/
    "/ create a box on those values ...
    "/
    box := DialogBox new.
    box label:(resources string:'Syntax Colors').

    frame := View new.
    frame extent:1.0 @ 200.
    frame borderWidth:0.

    exampleView := HVScrollableView for:TextView in:frame.
    exampleView model:coloredText.
    exampleView origin:0.0@0.0 corner:1.0@1.0; inset:2.

    frame topInset:box yPosition.
    box addComponent:frame withExtent:1.0@200.
    box makeTabable:exampleView.
    frame width:1.0.

    box addVerticalSpace.

    oldUserPreferences := currentUserPrefs copy.

    syntaxColoringBox := box addComboListOn: (syntaxColors := SelectionInList with:UserPreferences syntaxColorNames initialSelection:1).
    syntaxColorSelector    := [(syntaxColors selection replChar:$  withString: '') asLowercaseFirst asSymbol].
    syntaxEmphasisSelector := [((syntaxColorSelector value upToAll: 'Color'), 'Emphasis') asLowercaseFirst asSymbol].
    syntaxColor := (currentUserPrefs perform: syntaxColorSelector value) asValue.
    colorMenu := ColorMenu new.
    colorMenu model: syntaxColor.
    syntaxColor onChangeEvaluate:
        [currentUserPrefs at:  syntaxColorSelector value put: syntaxColor value.
         recolorAction value.].
    syntaxColors onChangeEvaluate:
        [|eVal|
         syntaxColor value: (currentUserPrefs perform:syntaxColorSelector value).
         eVal := currentUserPrefs perform: syntaxEmphasisSelector value.
         eVal isArray ifTrue:[
            eVal = (Array with:#underwave with:#underlineColor->(Color red:100.0 green:0.0 blue:0.0)) ifTrue:[
                eVal := #'red underwave'
            ].
            eVal = (Array with:#bold with:#underwave with:#underlineColor->(Color red:100.0 green:0.0 blue:0.0)) ifTrue:[
                eVal := #'bold+red underwave'
            ].
            eVal = (Array with:#bold with:#underlineColor->(Color red:100.0 green:0.0 blue:0.0)) ifTrue:[
                eVal := #'bold+red underline'
            ].
            eVal = (Array with:#italic with:#underwave with:#underlineColor->(Color red:100.0 green:0.0 blue:0.0)) ifTrue:[
                eVal := #'italic+red underwave'
            ].
            eVal = (Array with:#italic with:#underlineColor->(Color red:100.0 green:0.0 blue:0.0)) ifTrue:[
                eVal := #'italic+red underline'
            ].
         ].
         syntaxEmphasises selection: eVal.
         recolorAction value.].

    syntaxEmphasises := SelectionInList
                            with:#(
                                    normal
                                    underline
                                    #'red underline'
                                    underwave
                                    #'red underwave'
                                    bold
                                    boldUnderline
                                    #'bold+red underline'
                                    boldUnderwave
                                    #'bold+red underwave'
                                    italic
                                    italicUnderline
                                    #'italic+red underline'
                                    italicUnderwave
                                    #'italic+red underwave'
                                    reverse
                                  )
                            initialSelection:1.
    syntaxEmphasisesBox := box addComboListOn:syntaxEmphasises.
    syntaxEmphasises
        onChangeEvaluate:[ |em|
            em := syntaxEmphasises selection.
            em notNil ifTrue:[
                em := em asSymbol.
                em == #'red underline' ifTrue:[ em := Array with:#underline with:(#underlineColor->Color red)].
                em == #'red underwave' ifTrue:[ em := Array with:#underwave with:(#underlineColor->Color red)].
                em == #'bold+red underline' ifTrue:[ em := Array with:#bold with:#underline with:(#underlineColor->Color red)].
                em == #'bold+red underwave' ifTrue:[ em := Array with:#bold with:#underwave with:(#underlineColor->Color red)].
                em == #'italic+red underline' ifTrue:[ em := Array with:#italic with:#underline with:(#underlineColor->Color red)].
                em == #'italic+red underwave' ifTrue:[ em := Array with:#italic with:#underwave with:(#underlineColor->Color red)].

                currentUserPrefs at: syntaxEmphasisSelector value put:em.
            ].
            recolorAction value
        ].
    syntaxColors changed:#value. "/ to force initial update of emphasis
    box addComponent:colorMenu tabable:true.

    y := box yPosition.

    b := Button new label: (resources string:'reset to:').
    b action:[
        |resetSelector|

        resetSelector := (currentUserPrefs listOfPredefinedSyntaxColoringSchemes
                             collect:[:eachEntry | eachEntry first])
                                 at:resetList selectionIndex.
        currentUserPrefs perform:resetSelector.
        recolorAction value.
    ].
    syntaxColoringResetButton := box addComponent:b.
    box makeTabable:syntaxColoringResetButton.

    box yPosition:y.

    resetList := SelectionInList
                            with:(currentUserPrefs listOfPredefinedSyntaxColoringSchemes
                                        collect:[:eachEntry | eachEntry second])
                            initialSelection:1.
    resetListBox := box addComboListOn:resetList.
    box makeTabable:resetListBox.

    syntaxColoringBox enable.
    colorMenu enable.
    syntaxEmphasisesBox enable.
    syntaxColoringResetButton enable.

    box
"/        addHelpButtonFor:'Launcher/sourceSettings.html';
        addAbortAndOkButtons.

    box stickAtBottomWithVariableHeight:frame.
    box stickAtBottomWithFixHeight:syntaxColoringBox.
    box stickAtBottomWithFixHeight:syntaxEmphasisesBox.
    box stickAtBottomWithFixHeight:colorMenu.
    box stickAtBottomWithFixHeight:syntaxColoringResetButton left:0.0 right:0.5.
    box stickAtBottomWithFixHeight:resetListBox left:0.5 right:1.0.

    "/
    "/ show the box ...
    "/
    box extent:600@400.
    box openModal.

    "/
    "/ update system settings
    "/
    box accepted ifFalse: [
        (UserPreferences reset; current) addAll:oldUserPreferences
    ].
    box destroy

    "Modified: / 16.4.1998 / 17:18:16 / ca"
    "Modified: / 7.7.1999 / 00:27:02 / cg"
! !

!AbstractLauncherApplication::LauncherDialogs class methodsFor:'interface specs'!

cvsSetupSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractLauncherApplication::LauncherDialogs andSelector:#cvsSetupSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: cvsSetupSpec
        window:
       (WindowSpec
          label: 'CVS Setup'
          name: 'CVS Setup'
          min: (Point 436 316)
          bounds: (Rectangle 14 46 450 400)
        )
        component:
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'CVS BinDirectory:'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 36 0 40 0.25 53 0)
              level: 0
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'BinDirectoryField'
              layout: (LayoutFrame 44 0.25 34 0 -1 1 56 0)
              tabable: true
              model: cvsBinDirectoryHolder
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (DividerSpec
              name: 'Separator3'
              layout: (LayoutFrame 0 0.0 60 0 0 1.0 64 0)
            )
           (LabelSpec
              label: 'CVS SourceCodeManager setup'
              name: 'label'
              layout: (LayoutFrame 1 0.0 3 0 -1 1.0 20 0)
              translateLabel: true
              adjust: left
            )
           (LabelSpec
              label: 'CVSRoot default:'
              name: 'defaultCvsRootLabel'
              layout: (LayoutFrame 0 0.0 71 0 40 0.25 88 0)
              level: 0
              translateLabel: true
              adjust: right
            )
           (ComboBoxSpec
              name: 'cvsRootComboBox'
              layout: (LayoutFrame 44 0.25 71 0 -1 1.0 93 0)
              tabable: true
              model: cvsRootHolder
              immediateAccept: true
              acceptOnLeave: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
              comboList: cvsRootPrototypeList
            )
           (DividerSpec
              name: 'Separator1'
              layout: (LayoutFrame 0 0.0 96 0 0 1.0 100 0)
            )
           (LabelSpec
              label: 'CVSRoot per Module:'
              name: 'knownModulesLabel'
              layout: (LayoutFrame 0 0.0 109 0 40 0.25 126 0)
              translateLabel: true
              adjust: right
            )
           (SequenceViewSpec
              name: 'List1'
              layout: (LayoutFrame 44 0.25 104 0 -1 1 202 0)
              tabable: true
              model: selectedPerModuleRoot
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              useIndex: false
              sequenceList: listOfModules
            )
           (LabelSpec
              label: 'Module:'
              name: 'moduleLabel'
              layout: (LayoutFrame 0 0.0 209 0 40 0.25 226 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'perModuleRootModuleEntryField'
              layout: (LayoutFrame 44 0.25 205 0 -1 1 227 0)
              tabable: true
              model: perModuleRootModule
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'CVSRoot:'
              name: 'cvsRootLabel'
              layout: (LayoutFrame 0 0.0 236 0 40 0.25 253 0)
              translateLabel: true
              adjust: right
            )
           (ComboBoxSpec
              name: 'perModuleRootComboBox'
              layout: (LayoutFrame 44 0.25 232 0 -1 1.0 254 0)
              tabable: true
              model: perModuleRoot
              immediateAccept: true
              acceptOnLeave: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
              comboList: cvsRootPrototypeList
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 44 0.25 258 0 -1 1 289 0)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component:
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Add/Apply'
                    name: 'addButton'
                    translateLabel: true
                    tabable: true
                    model: addPerModuleRoot
                    extent: (Point 136 22)
                  )
                 (ActionButtonSpec
                    label: 'Remove'
                    name: 'removeButton'
                    translateLabel: true
                    tabable: true
                    model: removePerModuleRoot
                    enableChannel: removeEnabled
                    extent: (Point 137 22)
                  )
                 )

              )
            )
           (DividerSpec
              name: 'Separator2'
              layout: (LayoutFrame 0 0.0 -45 1 0 1.0 -34 1)
            )
           (HorizontalPanelViewSpec
              name: 'buttonPanel'
              layout: (LayoutFrame 0 0.0 -29 1.0 0 1.0 -3 1.0)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              ignoreInvisibleComponents: true
              reverseOrderIfOKAtLeft: true
              component:
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'cancelButton'
                    translateLabel: true
                    tabable: true
                    model: cancel
                    extent: (Point 141 21)
                  )
                 (ActionButtonSpec
                    label: 'Help'
                    name: 'helpButton'
                    translateLabel: true
                    tabable: true
                    model: help
                    extent: (Point 141 21)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'okButton'
                    translateLabel: true
                    tabable: true
                    model: accept
                    isDefault: true
                    extent: (Point 142 21)
                  )
                 )

              )
            )
           )

        )
      )
!

formatterDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractLauncherApplication::LauncherDialogs andSelector:#formatterDialogSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: formatterDialogSpec
        window:
       (WindowSpec
          label: 'Formatting parameters'
          name: 'Formatting parameters'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 610 629)
        )
        component:
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Sample output:'
              name: 'Label2'
              layout: (LayoutFrame 0 0.0 4 0 0 1.0 26 0)
              translateLabel: true
              adjust: left
            )
           (TextEditorSpec
              name: 'sampleTextView'
              layout: (LayoutFrame 0 0.0 30 0.0 0 1.0 -234 1.0)
              level: -1
              model: formattedText
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
            )
           (FramedBoxSpec
              label: 'Parameters'
              name: 'FramedBox1'
              layout: (LayoutFrame 0 0.0 -225 1 0 1.0 -30 1)
              labelPosition: topLeft
              translateLabel: true
              component:
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Max length for single line blocks:'
                    name: 'Label1'
                    layout: (LayoutFrame 185 0.0 127 0 66 0.7 153 0)
                    level: 0
                    adjust: right
                  )
                 (CheckBoxSpec
                    label: 'Space around temporaries '
                    name: 'checkBox'
                    layout: (LayoutFrame 2 0 3 0 260 0 32 0)
                    level: 0
                    tabable: true
                    model: spaceAroundTemporaries
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Blank line after local var declaration'
                    name: 'CheckBox1'
                    layout: (LayoutFrame 267 0 3 0 567 0 32 0)
                    level: 0
                    tabable: true
                    model: emptyLineAfterTemporaries
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Space after ''^'''
                    name: 'CheckBox2'
                    layout: (LayoutFrame 2 0 31 0 260 0 60 0)
                    level: 0
                    tabable: true
                    model: spaceAfterReturnToken
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Space after '':'' in keywords'
                    name: 'CheckBox3'
                    layout: (LayoutFrame 267 0 31 0 567 0 60 0)
                    level: 0
                    tabable: true
                    model: spaceAfterKeywordSelector
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'C-Style blocks'
                    name: 'CheckBox4'
                    layout: (LayoutFrame 2 0 59 0 260 0 88 0)
                    level: 0
                    tabable: true
                    model: cStyleBlocks
                    translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'editField'
                    layout: (LayoutFrame 74 0.7 93 0 -38 1.0 119 0)
                    level: -1
                    tabable: true
                    model: tabIndent
                    type: number
                    immediateAccept: false
                    acceptOnLeave: true
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    acceptOnPointerLeave: true
                  )
                 (LabelSpec
                    label: 'Indent:'
                    name: 'label'
                    layout: (LayoutFrame 242 0.0 93 0 66 0.7 119 0)
                    level: 0
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'EntryField1'
                    layout: (LayoutFrame 74 0.7 127 0 -38 1.0 153 0)
                    level: -1
                    tabable: true
                    model: maxLengthForSingleLineBlocks
                    type: number
                    immediateAccept: false
                    acceptOnLeave: true
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    acceptOnPointerLeave: true
                  )
                 (PopUpListSpec
                    label: 'Reset to...'
                    name: 'PopUpList1'
                    layout: (LayoutFrame 2 0 129 0 127 0 151 0)
                    tabable: true
                    model: resetValue
                    menu: resetList
                    useIndex: true
                  )
                 (CheckBoxSpec
                    label: 'Block args on new line'
                    name: 'CheckBox5'
                    layout: (LayoutFrame 267 0 59 0 567 0 88 0)
                    level: 0
                    tabable: true
                    model: blockArgumentsOnNewLine
                    translateLabel: true
                  )
                 )

              )
            )
           (HorizontalPanelViewSpec
              name: 'horizontalPanelView'
              layout: (LayoutFrame 0 0.0 -35 1.0 0 1.0 0 1.0)
              level: 0
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 4
              verticalSpace: 4
              ignoreInvisibleComponents: true
              component:
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'button'
                    translateLabel: true
                    tabable: true
                    model: cancel
                    useDefaultExtent: true
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button1'
                    translateLabel: true
                    tabable: true
                    model: accept
                    isDefault: true
                    useDefaultExtent: true
                  )
                 )

              )
            )
           )

        )
      )
! !

!AbstractLauncherApplication::PackageLoadDialog class methodsFor:'documentation'!

documentation
"
    handwritten q&d dialog to load packages.
    TODO:
        rewrite using UI builder
"
! !

!AbstractLauncherApplication::PackageLoadDialog class methodsFor:'opening'!

open
    self new openLoadPackageDialog
!

openModal
    self new openLoadPackageDialogModal:true
! !

!AbstractLauncherApplication::PackageLoadDialog methodsFor:'initialize & release'!

initializeIcons
    folderIcon := ToolbarIconLibrary directoryOpen18x18Icon.
    "/ folderHalfGreyIcon := ToolbarIconLibrary directoryOpenHalfGrey18x18Icon.
    packageIcon := ToolbarIconLibrary packageOpen24x24Icon.
    applicationIcon := ToolbarIconLibrary makeYellow22x22Icon1.
    greyFolderIcon := folderIcon asGrayImageDepth:8.
    greyPackageIcon := packageIcon asGrayImageDepth:8.
    greyApplicationIcon := applicationIcon asGrayImageDepth:(applicationIcon depth min:8).
!

release
    |p|
    
    (p := backgroundPackageFindProcess) notNil ifTrue:[
        backgroundPackageFindProcess := nil.
        p isDead ifFalse:[
            p terminate
        ]
    ].
    super release
! !

!AbstractLauncherApplication::PackageLoadDialog methodsFor:'menu'!

itemMenu
    |item m itemType package defClass|

    hierarchicalListView selectionValue notEmptyOrNil ifTrue:[
        item := hierarchicalListView selectionValue first.

        itemType := item type.
        ( 
            #( #localRoot #monticelloRoot #compiledPackagesRoot ) includes:itemType
        ) ifFalse:[

            package := packageIdByItem at:item ifAbsent:nil.
            package notNil ifTrue:[
                defClass := package asPackageId projectDefinitionClass.
            ].

            m := Menu new.
            m addItem:(MenuItem 
                        label: (resources string:'Load')
                        itemValue: 
                            [
                                package notNil ifTrue:[
                                    self loadPackageAndUpdate:package browse:false subPackages:false item:item.
                                    "/ loadPackageAndUpdate value:package value:false value:item.
                                ].
                            ]
                        enabled:package notNil).
            m addItem:(MenuItem 
                        label: (resources string:'Load with All Subpackages')
                        itemValue: 
                            [
                                package notNil ifTrue:[
                                    self loadPackageAndUpdate:package browse:false subPackages:true item:item.
                                    "/ loadPackageAndUpdate value:package value:false value:item.
                                ].
                            ]
                        enabled:package notNil).
            m addItem:(MenuItem 
                        label: (resources string:'Load PackageDefinition Only')
                        itemValue: 
                            [
                                package notNil ifTrue:[
                                    self loadPackageDefinition:package browse:false subPackages:false item:item.
                                ].
                            ]
                        enabled:package notNil).
            m addSeparator. 
            m addItem:(MenuItem 
                        label: (resources string:'Open File Browser on Package''s Folder')
                        itemValue: 
                            [
                                |dir|

                                package notNil ifTrue:[
                                    dir := Smalltalk packageDirectoryForPackageId:package.
                                    dir notNil ifTrue:[
                                        FileBrowser default openOn:dir.
                                    ] ifFalse:[
                                        Dialog warn:(resources string:'Project directory of "%1" is not present/readable' with:package)
                                    ]
                                ].
                            ]
                        enabled:package notNil).
            m addSeparator. 
            m addItem:(MenuItem 
                        label: (resources string:'Browse Package Definition')
                        itemValue: 
                            [
                                defClass notNil ifTrue:[
                                    SystemBrowser default openInClass:defClass class
                                ].
                            ]
                        enabled:defClass notNil).
            m addItem:(MenuItem 
                        label: (resources string:'Browse Package')
                        itemValue: 
                            [
                                Tools::NewSystemBrowser openOnPackage:package
                            ]
                        enabled:defClass notNil).

            item type == #monticelloPackage ifTrue:[
                m addItem:(MenuItem 
                            label: (resources string:'Browse Monticello Package')
                            itemValue: [
                                |repos|

                                repos := item parent info.                    
                                MCRepositoryBrowser openOnRepository:repos forPackage:item label.
                            ]).
            ].
        ].
    ].
    ^ m

    "Modified: / 18-11-2016 / 11:11:07 / cg"
! !

!AbstractLauncherApplication::PackageLoadDialog methodsFor:'opening'!

openLoadPackageDialog
    "open a dialog showing wellknown packages (listed in the packages directory)
     and offer to load the selected one(s).
     TODO: make this a little app instead of an ad-hoc dialog, 
     add remote packages (central goody repository?)"    

    self openLoadPackageDialogModal:false.
!

openLoadPackageDialogModal:modal
    "open a dialog showing wellknown packages (listed in the packages directory)
     and offer to load the selected one(s).
     TODO: make this a little app instead of an ad-hoc dialog, 
     add remote packages (central goody repository?)"    

    |list dialog filter v   
     browse selectionChangeAction 
     selectedPackageLabel infoView monticelloLabel|

    alreadyLoadedString := (resources string:' (already loaded)') allItalic.

    self initializeIcons.

    selectedPackageHolder := ValueHolder with:nil.
    infoTextHolder := ValueHolder with:nil.
    filterHolder := ValueHolder with:nil.
    itemsByPath := Dictionary new.
    packageIdByItem := IdentityDictionary new.
    pathByItem := IdentityDictionary new.  

    list := HierarchicalList new.

    masterRoot := MyHierarchicalItem new.
    masterRoot icon:(ToolbarIconLibrary stxHomeIcon).
    masterRoot label:(resources string:'local ').
    masterRoot type:#localRoot.

    root := MyHierarchicalItem new.
    root icon:folderIcon.
    root label:((resources string:'[Compiled Packages]') asText allItalic withColor:Color grey).
    root type:#compiledPackagesRoot.
    masterRoot add:root.

    monticelloRoot := MyHierarchicalItem new.
    monticelloLabel := ((resources string:'[Monticello Packages]') asText allItalic withColor:Color grey).
    monticelloRoot type:#monticelloRoot.

    (MCRepositoryGroup isNil or:[MCRepositoryGroup isLoaded not]) ifTrue:[
        monticelloRoot icon:greyFolderIcon.
        monticelloRoot label:monticelloLabel, (' (Monticello Support not Loaded)' withColor:Color grey).
    ] ifFalse:[
        monticelloRoot icon:folderIcon.
        monticelloRoot label:monticelloLabel.
        self getMonticelloRepositories.
    ].
    masterRoot add:monticelloRoot.

    self readPackageTree.
    self readOtherPackageTreesInBackground.
    masterRoot expand.
    root expand.
    list root:masterRoot.

    PreviousPackageDialogItems notNil ifTrue:[
        PreviousPackageDialogItems keysAndValuesDo:[:path :prevItem |
            |newItem|

            newItem := itemsByPath at:path ifAbsent:nil.
            newItem notNil ifTrue:[
                prevItem isExpanded ifTrue:[ newItem expand ]
            ].
        ].
    ].

    selectionChangeAction :=
        [:selectionIndices | self selectionChangeAction:selectionIndices].

    dialog := Dialog new.
    dialog label:(resources string:'Load Package').
    dialog addButton:(loadButton := Button label:(resources string:'Load') action:[self loadAction:false]) beReturnButton. 
    dialog addButton:(loadAndBrowseButton := Button label:(resources string:'Load & Browse') action:[self loadAction:true]).
    dialog addAbortButtonLabelled:(resources string:'Close').

    loadButton enabled:false.
    loadAndBrowseButton enabled:false.

    filter := EditField new.
    filter emptyFieldReplacementText:(resources string:'Filter Pattern').
    filter immediateAccept:true.
    filter model: filterHolder.
    filterHolder onChangeEvaluate:[self filterChangedAction].
    dialog
        addLabelledField:filter
        label:(resources string:'Quick Find:') 
        adjust:#left tabable:true from:0.0 to:1.0 separateAtX:150.

    "/ dialog addComponent:filter.

    v := HVScrollableView for:HierarchicalListView.
    hierarchicalListView := v scrolledView.
    hierarchicalListView multipleSelectOk:true.
    hierarchicalListView preferredExtent:(400 @ 300).
    hierarchicalListView doubleClickAction:[:index | self loadAction:false. dialog okPressed].
    hierarchicalListView list:list.
    hierarchicalListView action:selectionChangeAction.
    hierarchicalListView menuHolder:[ self itemMenu].

    dialog addComponent:v.
    selectedPackageLabel := dialog addTextLabelOn:(selectedPackageHolder) adjust:#left.
    infoView := dialog addTextBoxOn:infoTextHolder class:TextView withNumberOfLines:5 hScrollable:true vScrollable:true.

    dialog stickAtBottomWithVariableHeight:v.
    dialog stickAtBottomWithFixHeight:selectedPackageLabel.
    dialog stickAtBottomWithFixHeight:infoView.

    PreviousPackageDialogExtent notNil ifTrue:[
        dialog extent:PreviousPackageDialogExtent
    ].

    browse := false.
    dialog application:self.
    modal ifTrue:[
        dialog openModalAtPointer.
    ] ifFalse:[
        dialog openModelessAtPointer.
    ].

    "/ remember the expand/collapse status
    PreviousPackageDialogItems := itemsByPath.
    PreviousPackageDialogExtent := dialog extent.
! !

!AbstractLauncherApplication::PackageLoadDialog methodsFor:'private'!

addItemWithPackagePath:path target:target asApplication:isApplication toRoot:aRoot
    |item isAlreadyLoaded defClass packageID|

    "/ see if already loaded

    packageID := (path size > 1) 
                    ifTrue:[ path first , ':' , ((path copyFrom:2) asStringWith:$/) ]
                    ifFalse:[ path first ].

    item := self getItemByPath:path packageID:packageID under:aRoot.

    isAlreadyLoaded := false.
    Error handle:[:ex |
        item label:(item label , (' ERROR - please rebuild!!' withColor:Color red)).
    ] do:[    
        isAlreadyLoaded := 
            (defClass := ProjectDefinition definitionClassForPackage:packageID) notNil
            and:[ defClass isLoaded
            and:[ defClass isFullyLoaded ]].
    ].

    target notNil ifTrue:[
        ((target startsWith:'lib ') or:[(target startsWith:'app ')]) ifTrue:[
            pathByItem at:item put:(target copyFrom:(target indexOfSeparator + 1)) withoutSeparators.
        ].
    ].

    "/ do not overwrite an app by a lib with the same name (happens in expecco/application)
    (isApplication or:[ item icon isNil or:[item icon == folderIcon or:[item icon == greyFolderIcon]]]) ifTrue:[
        isAlreadyLoaded ifTrue:[
            item icon:(isApplication ifTrue:[greyApplicationIcon] ifFalse:[greyPackageIcon]). 
            item label:(item label , alreadyLoadedString)
        ] ifFalse:[
            item icon:(isApplication ifTrue:[applicationIcon] ifFalse:[packageIcon]). 
        ].
    ].

    "/ if it is not already loaded, make all parents non-grey
    isAlreadyLoaded ifFalse:[
        path size-1 to:1 by:-1 do:[:n |
            |parentPath parentItem|

            parentPath := path copyTo:n.
            parentItem := self getItemByPath:parentPath packageID:packageID under:aRoot.
            parentItem icon == greyFolderIcon ifTrue:[
                parentItem icon:folderIcon.
"/                        ] ifFalse:[
"/                            parentItem icon == greyApplicationIcon ifTrue:[
"/                                parentItem icon:applicationIcon.
"/                            ].
            ].
        ]
    ].
!

filterChangedAction
    |newMatchingItems filterPattern isMatch firstMatchingItem|

    filterPattern := filterHolder value.
    filterPattern isEmptyOrNil ifTrue:[
        itemsMatchingFilter notEmptyOrNil ifTrue:[ 
            "/ nothing
            root recursiveDo:[:item |
                item label:(item label copy asText allNonBold withoutAnyColorEmphasis).
            ].
        ].
        itemsMatchingFilter := #().
        ^ self.
    ].
    
    filterPattern := filterPattern asLowercase.
    isMatch := filterPattern includesMatchCharacters.

    newMatchingItems := OrderedCollection new.
    masterRoot recursiveDo:[:item |
        |itemLabel itemPackage|

        itemLabel := item label.
        itemPackage := packageIdByItem at:item ifAbsent:''.

        ((isMatch and:[itemLabel matches:filterPattern caseSensitive:false])
            or:[ (isMatch not and:[ itemLabel asLowercase includesString:filterPattern ])
            or:[ (isMatch and:[itemPackage matches:filterPattern caseSensitive:false])
            or:[ isMatch not and:[ itemPackage asLowercase includesString:filterPattern ]]]])
        ifTrue:[ 
            newMatchingItems add:item.
        ]
    ].
    (newMatchingItems sameContentsAs:itemsMatchingFilter) ifTrue:[
        ^ self
    ].    
    
    newMatchingItems isEmpty ifTrue:[
        "/ nothing found
        root recursiveDo:[:item |
            item label:(item label copy asText allNonBold withoutAnyColorEmphasis).
        ].
        Screen current beep.
    ] ifFalse:[
        "/ collapse all and fully expand all matching items
        masterRoot recursiveDo:[:item |
            item collapse.
            item label:(item label copy asText allNonBold withColor:Color grey).
        ].
        firstMatchingItem := nil.
        newMatchingItems do:[:item |
            item label:(item label copy asText allBold withoutAnyColorEmphasis).
            item makeVisible.
            firstMatchingItem := firstMatchingItem ? item.
        ].
        hierarchicalListView makeLineVisible:firstMatchingItem listIndex.
    ].
    itemsMatchingFilter := newMatchingItems.
!

getItemByPath:path packageID:packageID under:aRoot
    "/ ensures an item for a path and returns it.
    "/ if not already present, the item is created as a folder

    |item parent subPackageID|

    item := path isEmpty   
            ifTrue:[aRoot]
            ifFalse:[ itemsByPath at:( {aRoot label},path) ifAbsent:nil ].
    item isNil ifTrue:[
        parent := self getItemByPath:(path copyButLast) packageID:packageID under:aRoot.
        item := MyHierarchicalItem new
                children:#();
                icon:greyFolderIcon; 
                label:path last.
        parent add:item.
        itemsByPath at:( {aRoot label},path) put:item.
        subPackageID := path size > 1 
                        ifTrue:[ path first , ':' , ((path copyFrom:2) asStringWith:$/) ]
                        ifFalse:[ path first ].
        packageIdByItem at:item put:subPackageID.
    ].
    ^ item
!

getMonticelloRepositories
    (MCRepositoryGroup default repositories 
        asSortedCollection:[:a :b |a displayString < b displayString])
            do:[:each |
                |reposItem|

                reposItem := MyHierarchicalItem new.
                reposItem icon:folderIcon.
                reposItem label:each displayString , ((resources string:' [MC Repository]') asText allItalic withColor:Color grey).
                reposItem type:#monticelloRepository.
                reposItem info:each.
                monticelloRoot add:reposItem.

                each allPackageNames asSortedCollection do:[:eachPackage |
                    |packageItem|

                    packageItem := MyHierarchicalItem new.
                    packageItem icon:packageIcon.
                    packageItem label:eachPackage.
                    packageItem type:#monticelloPackage.
                    reposItem add:packageItem.
                ]
            ].
!

"Modified: / 28-06-2016 / 07:55:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
loadAction:doBrowse 
    "the button's load action"
    
    (hierarchicalListView selectionValue) do:[:eachSelectedItem |
        |package repos|

        eachSelectedItem type == #monticelloRepository ifTrue:[
            repos := eachSelectedItem info.                    
            MCRepositoryBrowser openOnRepository:repos forPackage:nil.
        ] ifFalse:[
            eachSelectedItem type == #monticelloPackage ifTrue:[
                repos := eachSelectedItem parent info.                    
                MCRepositoryBrowser openOnRepository:repos forPackage:eachSelectedItem label.
            ] ifFalse:[
                package := packageIdByItem at:eachSelectedItem ifAbsent:[nil].
                package notNil ifTrue:[
                    self loadPackageAndUpdate:package browse:doBrowse subPackages:false item:eachSelectedItem
                ].
            ].
        ].
    ].
!

loadPackageAndUpdate:package browse:doBrowse subPackages:subPackages item:someItem
    |defClass updateAction|

    self withWaitCursorDo:[
        updateAction := 
            [:whatChanged :parameter | 
                self updateAction:whatChanged parameter:parameter
            ].
            
        Smalltalk onChangeSend:#value:value: to:updateAction.
        [
            |packageTried|
            packageTried := package.
            ((package includes:$:) not and:[(package includes:$/) not]) ifTrue:[
                packageTried := package,':'
            ].        
            [
                Smalltalk loadPackage:packageTried
            ] on:PackageLoadError do:[:ex |
                |path|

                path := pathByItem at:someItem ifAbsent:nil.
                path isNil ifTrue:[
                    Dialog information:('package load failed: %1' bindWith:ex description).
                ] ifFalse:[    
                    "/ try to load the file as is (i.e. not via package-id
                    Dialog information:('package load failed: %1\\Loading file directly...' bindWith:ex description).
                    Smalltalk fileIn:(packageDirPath asFilename / path).
                ].
            ]
        ] ensure:[
            Smalltalk retractInterestsFor:updateAction.
        ].
    ].
    ((defClass := package asPackageId projectDefinitionClass) notNil
        and:[ defClass isLoaded
        and:[ defClass isFullyLoaded ]])
    ifFalse:[
        defClass isNil ifTrue:[
            Dialog warn:(resources string:'Load failed: definition class for packageID (%1) not present after package load.' with:package)
        ] ifFalse:[
            defClass verbose:true.
            defClass isLoaded.
            defClass isFullyLoaded.
            defClass verbose:false.
            Dialog warn:(resources string:'Load failed: definition class /%1) not fully loaded after package load.' with:defClass name)
        ]
    ] ifTrue:[
        doBrowse ifTrue:[
            Tools::NewSystemBrowser openOnPackage:package
        ].
        someItem icon == packageIcon ifTrue:[
            someItem icon:greyPackageIcon.
            someItem label:(someItem label , alreadyLoadedString).
        ] ifFalse:[
            someItem icon == applicationIcon ifTrue:[
                someItem icon:greyApplicationIcon.
                someItem label:(someItem label , alreadyLoadedString).
            ].
        ].
    ].
    
    subPackages ifTrue:[
        someItem children do:[:eachChild |
            |subPackageID|

            subPackageID := packageIdByItem at:eachChild.
            self loadPackageAndUpdate:subPackageID browse:false subPackages:true item:eachChild.
        ].
    ].
!

loadPackageDefinition:package browse:doBrowse subPackages:subPackages item:someItem
    |defClass updateAction|

    self withWaitCursorDo:[
        updateAction := 
            [:whatChanged :parameter | 
                self updateAction:whatChanged parameter:parameter
            ].
            
        Smalltalk onChangeSend:#value:value: to:updateAction.
        
        [
            |packageTried dir className fileName|

            packageTried := package.
            ((package includes:$:) not and:[(package includes:$/) not]) ifTrue:[
                packageTried := package,':'
            ].        

            dir := Smalltalk packageDirectoryForPackageId:package.
            dir notNil ifTrue:[
                "/ is there a project definition class's source?
                className := ProjectDefinition projectDefinitionClassNameForDefinitionOf:package.
                fileName := dir / ((Smalltalk fileNameForClass:className),'.st').
                fileName exists ifTrue:[
                    ParseError handle:[:ex |
                        Dialog warn:(resources string:'An error happened while loading the project definition:\  %1\\Maybe the project depends on some other package.\Please check this manually.' with:ex description)
                    ] do:[    
                        Smalltalk fileIn:fileName.
                    ].
                ] ifFalse:[
                    Dialog warn:(resources string:'Project definition class file not present: "%1"' with:fileName)
                ]
            ] ifFalse:[
                Dialog warn:(resources string:'Project directory for "%1" is not present/readable' with:package).
                ^ self.
            ]
        ] ensure:[
            Smalltalk retractInterestsFor:updateAction.
        ].
    ].
    ((defClass := package asPackageId projectDefinitionClass) notNil and:[ defClass isLoaded ])
    ifFalse:[
        defClass isNil ifTrue:[
            Dialog warn:(resources string:'Load failed: definition class for packageID (%1) not present after package load.' with:package)
        ]
    ] ifTrue:[
        doBrowse ifTrue:[
            Tools::NewSystemBrowser openOnPackage:package
        ].
"/        someItem icon == packageIcon ifTrue:[
"/            someItem icon:greyPackageIcon.
"/            someItem label:(someItem label , alreadyLoadedString).
"/        ] ifFalse:[
"/            someItem icon == applicationIcon ifTrue:[
"/                someItem icon:greyApplicationIcon.
"/                someItem label:(someItem label , alreadyLoadedString).
"/            ].
"/        ].
    ].
    
    subPackages ifTrue:[
        someItem children do:[:eachChild |
            |subPackageID|

            subPackageID := packageIdByItem at:eachChild.
            self loadPackageAndUpdate:subPackageID browse:false subPackages:true item:eachChild.
        ].
    ].

    "Created: / 18-11-2016 / 11:13:03 / cg"
!

readOtherPackageTrees
    |packagePath|
    
    packagePath := Smalltalk packagePath.
    packagePath do:[:eachDirName |
        |folderRoot eachDir|
        
        eachDir := eachDirName asFilename.
        eachDir isDirectory ifTrue:[
            selectedPackageHolder value isNil ifTrue:[
                infoTextHolder value:(resources string:'searching %1...' with:eachDirName).
            ].    
            eachDir
                recursiveDirectoryContentsWithPrefix:'' 
                filesDo:nil 
                directoriesDo:[:subDir |
                    |dfnBasename expectedDfnFilename|
    
                    (eachDir /  subDir / 'abbrev.stc') exists ifTrue:[
                        "/ see if there is a project definition file in this dir
                        dfnBasename := subDir copyReplaceAll:(Filename separator) with:$_.
                        expectedDfnFilename := (eachDir /  subDir / dfnBasename) withSuffix:'st'.
                        expectedDfnFilename exists ifTrue:[
                            |path|
                            
                            path := subDir asFilename components.
                            (itemsByPath at:( {root label},path) ifAbsent:nil) isNil ifTrue:[
                                folderRoot isNil ifTrue:[
                                    folderRoot := MyHierarchicalItem new.
                                    folderRoot icon:folderIcon.
                                    folderRoot label:((resources string:'[%1]' with:eachDirName) asText allItalic withColor:Color grey).
                                    folderRoot type:#compiledPackagesRoot.
                                ].    
                                self 
                                    addItemWithPackagePath:path
                                    target:nil
                                    asApplication:false
                                    toRoot:folderRoot.
                            ].
                        ]
                    ].
                ].
            folderRoot notNil ifTrue:[
                masterRoot add:folderRoot.
            ].
        ].
        selectedPackageHolder value isNil ifTrue:[
            infoTextHolder value:(resources string:'Done searching other package folders.').
        ].    
    ]
        
    "/    packageDirPath isNil ifTrue:[
"/        root label:root label,((resources string:' (no "packages" folder found)') colorizeAllWith:Color red).
"/    ] ifFalse:[
"/        packageDirPath asFilename directoryContentsAsFilenames sort do:[:fn |
"/            |item base nm path parentPath parent isLibrary isApplication isAlreadyLoaded 
"/             defClass target packageID|
"/
"/            ((fn suffix = 'mcz') 
"/            or:[ fn isDirectory   
"/            or:[ (fn baseName startsWith:'.')   
"/            or:[ (fn baseName = 'README') ]]]) ifFalse:[    
"/                base := fn withoutSuffix baseName.
"/                (base startsWith:'lib') ifTrue:[
"/                    nm := (base copyFrom:4).
"/                    fn suffix notEmptyOrNil ifTrue:[
"/                        isLibrary := true.
"/                        isApplication := false.
"/                    ] ifFalse:[
"/                        isLibrary := false.
"/                        isApplication := true.
"/                    ]
"/                ] ifFalse:[
"/                    nm := base.
"/                    isLibrary := false.
"/                    isApplication := true.
"/                ].
"/
"/                path := nm asCollectionOfSubstringsSeparatedBy:$_.
"/                "/ see if already loaded
"/
"/                packageID := (path size > 1) 
"/                                ifTrue:[ path first , ':' , ((path copyFrom:2) asStringWith:$/) ]
"/                                ifFalse:[ path first ].
"/
"/                item := self getItemByPath:path packageID:packageID.
"/
"/                isAlreadyLoaded := false.
"/                Error handle:[:ex |
"/                    item label:(item label , (' ERROR - please rebuild!!' colorizeAllWith:Color red)).
"/                ] do:[    
"/                    isAlreadyLoaded := 
"/                        (defClass := ProjectDefinition definitionClassForPackage:packageID) notNil
"/                        and:[ defClass isLoaded
"/                        and:[ defClass isFullyLoaded ]].
"/                ].
"/
"/                target := fn contents first.
"/                ((target startsWith:'lib ') or:[(target startsWith:'app ')]) ifTrue:[
"/                    pathByItem at:item put:(target copyFrom:(target indexOfSeparator + 1)) withoutSeparators.
"/                ].
"/
"/                "/ do not overwrite an app by a lib with the same name (happens in expecco/application)
"/                (isApplication or:[ item icon isNil or:[item icon == folderIcon or:[item icon == greyFolderIcon]]]) ifTrue:[
"/                    isAlreadyLoaded ifTrue:[
"/                        item icon:(isApplication ifTrue:[greyApplicationIcon] ifFalse:[greyPackageIcon]). 
"/                        item label:(item label , alreadyLoadedString)
"/                    ] ifFalse:[
"/                        item icon:(isApplication ifTrue:[applicationIcon] ifFalse:[packageIcon]). 
"/                    ].
"/                ].
"/
"/                "/ if it is not already loaded, make all parents non-grey
"/                isAlreadyLoaded ifFalse:[
"/                    path size-1 to:1 by:-1 do:[:n |
"/                        |parentPath parentItem|
"/
"/                        parentPath := path copyTo:n.
"/                        parentItem := self getItemByPath:parentPath packageID:packageID.
"/                        parentItem icon == greyFolderIcon ifTrue:[
"/                            parentItem icon:folderIcon.
"/"/                        ] ifFalse:[
"/"/                            parentItem icon == greyApplicationIcon ifTrue:[
"/"/                                parentItem icon:applicationIcon.
"/"/                            ].
"/                        ].
"/                    ]
"/                ].
"/            ].
"/        ].
"/    ].

    "Modified: / 05-01-2017 / 21:33:18 / jv"
!

readOtherPackageTreesInBackground
    backgroundPackageFindProcess := 
        [
            [
                self readOtherPackageTrees.
            ] ensure:[
                backgroundPackageFindProcess := nil.
            ].    
        ] forkAt:(Processor userBackgroundPriority).    
!

readPackageTree
    packageDirPath := Smalltalk getSystemFileName:'packages'.
    packageDirPath isNil ifTrue:[
        root label:root label,((resources string:' (no "packages" folder found)') withColor:Color red).
    ] ifFalse:[
        packageDirPath asFilename directoryContentsAsFilenames sort do:[:fn |
            |item base nm path parentPath parent isLibrary isApplication isAlreadyLoaded 
             defClass target packageID|

            ((fn suffix = 'mcz') 
            or:[ fn isDirectory   
            or:[ (fn baseName startsWith:'.')   
            or:[ (fn baseName = 'README') ]]]) ifFalse:[    
                base := fn withoutSuffix baseName.
                (base startsWith:'lib') ifTrue:[
                    nm := (base copyFrom:4).
                    fn suffix notEmptyOrNil ifTrue:[
                        isLibrary := true.
                        isApplication := false.
                    ] ifFalse:[
                        isLibrary := false.
                        isApplication := true.
                    ]
                ] ifFalse:[
                    nm := base.
                    isLibrary := false.
                    isApplication := true.
                ].

                path := nm asCollectionOfSubstringsSeparatedBy:$_.
                target := fn contents first.

                self 
                    addItemWithPackagePath:path 
                    target:target 
                    asApplication:isApplication 
                    toRoot:root.
false ifTrue:[
                "/ see if already loaded

                packageID := (path size > 1) 
                                ifTrue:[ path first , ':' , ((path copyFrom:2) asStringWith:$/) ]
                                ifFalse:[ path first ].

                item := self getItemByPath:path packageID:packageID.

                isAlreadyLoaded := false.
                Error handle:[:ex |
                    item label:(item label , (' ERROR - please rebuild!!' withColor:Color red)).
                ] do:[    
                    isAlreadyLoaded := 
                        (defClass := ProjectDefinition definitionClassForPackage:packageID) notNil
                        and:[ defClass isLoaded
                        and:[ defClass isFullyLoaded ]].
                ].

                ((target startsWith:'lib ') or:[(target startsWith:'app ')]) ifTrue:[
                    pathByItem at:item put:(target copyFrom:(target indexOfSeparator + 1)) withoutSeparators.
                ].

                "/ do not overwrite an app by a lib with the same name (happens in expecco/application)
                (isApplication or:[ item icon isNil or:[item icon == folderIcon or:[item icon == greyFolderIcon]]]) ifTrue:[
                    isAlreadyLoaded ifTrue:[
                        item icon:(isApplication ifTrue:[greyApplicationIcon] ifFalse:[greyPackageIcon]). 
                        item label:(item label , alreadyLoadedString)
                    ] ifFalse:[
                        item icon:(isApplication ifTrue:[applicationIcon] ifFalse:[packageIcon]). 
                    ].
                ].

                "/ if it is not already loaded, make all parents non-grey
                isAlreadyLoaded ifFalse:[
                    path size-1 to:1 by:-1 do:[:n |
                        |parentPath parentItem|

                        parentPath := path copyTo:n.
                        parentItem := self getItemByPath:parentPath packageID:packageID.
                        parentItem icon == greyFolderIcon ifTrue:[
                            parentItem icon:folderIcon.
"/                        ] ifFalse:[
"/                            parentItem icon == greyApplicationIcon ifTrue:[
"/                                parentItem icon:applicationIcon.
"/                            ].
                        ].
                    ]
                ].
].
            ].
        ].
    ].
!

selectionChangeAction:selectionIndices
    |selectedItem p itemType info|

    loadButton enabled:(selectionIndices notEmpty).
    loadAndBrowseButton enabled:(selectionIndices notEmpty).

    selectionIndices size == 1 ifTrue:[
        selectedItem := hierarchicalListView selectionValue first.
        itemType := selectedItem type.

        itemType == #monticelloRepository ifTrue:[
            info := 'Monticello repository. Double click to browse its contents.'.
        ] ifFalse:[
            itemType == #monticelloPackage ifTrue:[
                info := 'Monticello package. Double click to browse its contents.'.
            ] ifFalse:[
                p := packageIdByItem at:selectedItem ifAbsent:nil.
                p notNil ifTrue:[
                    selectedPackageHolder value:(resources string:'Selected Package: "%1"' with:p allBold).
                    self showPackageInfoAction:p.
                ] ifFalse:[
                    selectedItem == masterRoot ifTrue:[
                        info := 'Packages found on the local machine.'
                    ] ifFalse:[
                        selectedItem == monticelloRoot ifTrue:[
                            info := 'Monticello packages\found on the local machine.'
                        ] ifFalse:[
                            selectedItem == root ifTrue:[
                                info := 'Class library packages\found in the "packages" folder.'
                            ] ifFalse:[
                                info := 'Other packages\found along the package-path.'
                            ].
                        ].
                    ].
                ].
            ].
            info notNil ifTrue:[ infoTextHolder value:(resources stringWithCRs:info)].
        ].
    ] ifFalse:[
        selectedPackageHolder value:(resources string:'Selected %1 packages.' with:selectionIndices size).
    ].
!

showPackageInfoAction:package
    |projectDef comment info projectDir className projectDefinitionFile readMeFile|

    info := resources string:'Sorry, could not find any package documentation'.
    projectDef := package asPackageId projectDefinitionClass.
    projectDef notNil ifTrue:[
        comment := projectDef commentOrDocumentationString.
        comment isNil ifTrue:[
            info := info, 
                    (resources stringWithCRs:'\\The project''s definition class (%1)\has no documentation method.' with:projectDef class name).
        ].
    ] ifFalse:[
        "/ try to find the package's source
        projectDir := Smalltalk getPackageDirectoryForPackage:package.
        projectDir notNil ifTrue:[
            |docChange|
            
            "/ is there a project definition class's source?
            className := ProjectDefinition projectDefinitionClassNameForDefinitionOf:package.
            projectDefinitionFile := projectDir / ((Smalltalk fileNameForClass:className),'.st').
            projectDefinitionFile exists ifTrue:[
                projectDefinitionFile readingFileDo:[:s |
                    ChangeSet 
                        fromStream:s 
                        while:[:change |
                            (change isMethodCodeChange
                            and:[ change selector == #documentation
                            and:[ change isForMeta ]]) ifTrue:[
                                docChange := change.
                                false "/ stop reading
                            ] ifFalse:[
                                true
                            ].
                        ].
                ].
                docChange notNil ifTrue:[
                    comment := Parser methodCommentFromSource:docChange source.
                ] ifFalse:[
                    info := info ,
                            (resources stringWithCRs:'\\The project''s definition class (%1) is present,\but has no documentation method.\\In file: %2'
                                    with:className
                                    with:projectDefinitionFile pathName).
                ].
            ] ifFalse:[
                info := info , 
                        (resources stringWithCRs:'\\No definition class was found in the project.\In folder: %1'
                                with:projectDir pathName).
            ].
        ].
    ].
    comment notEmptyOrNil ifTrue:[
        comment := comment asStringCollection.
        [ comment size > 0 and:[comment first isEmpty]] whileTrue:[ comment removeFirst ].
        (comment conform:[:line | line isEmpty or:[line startsWith:'    ']]) ifTrue:[
            comment := comment collect:[:line | 
                        (line startsWith:'    ') ifTrue:[
                            line copyFrom:5
                        ] ifFalse:[
                            line
                        ]].
        ].
        info := comment asString.
    ] ifFalse:[ 
        info := info withColor:Color red.
        (projectDir notNil and:[ (readMeFile := projectDir / 'README') exists]) ifTrue:[
            info := info , '\\The README file there says:\\' withCRs , (readMeFile contents asString).
        ].            
    ].
    infoTextHolder value:info.

    "Modified: / 28-06-2016 / 07:55:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAction:whatChanged parameter:parameter
    |item isLoaded packageID|

    "/ update the corresponding tree item
    (whatChanged == #postPackageLoad or:[whatChanged == #postLoad]) ifTrue:[
        parameter notNil ifTrue:[
            packageID := parameter asSymbol.
            item := self getItemByPath:(packageID splitByAny:':/') packageID:packageID under:root.
            item notNil ifTrue:[
                isLoaded := (ProjectDefinition definitionClassForPackage:packageID) notNil.
                isLoaded ifTrue:[
                    (item icon == applicationIcon or:[item icon == packageIcon]) ifTrue:[
                        item icon:((item icon == applicationIcon) ifTrue:[greyApplicationIcon] ifFalse:[greyPackageIcon]). 
                        item label:(item label , alreadyLoadedString)
                    ].
                ].
            ].
        ].
    ].
! !

!AbstractLauncherApplication::PackageLoadDialog::MyHierarchicalItem methodsFor:'accessing'!

info
    ^ info
!

info:something
    info := something.
!

type
    ^ type
!

type:something
    type := something.
! !

!AbstractLauncherApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

