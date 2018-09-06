"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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

ApplicationModel subclass:#AbstractSettingsApplication
	instanceVariableNames:'settingsString currentUserPrefs modifiedChannel settingsDialog
		requestor didModifySettings acceptChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

AbstractSettingsApplication subclass:#AllSettingsAppl
	instanceVariableNames:'buildDirectory localBuild selectedCompiler usedCompilerForBuild
		selectedSettingHolder settingsList'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#AutoloadedPackagesSettingsAppl
	instanceVariableNames:'possibleItemsLabelHolder listOfPossibleItems
		selectedItemsLabelHolder packageChooser listOfSelectedItems'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#BuildSettingsAppl
	instanceVariableNames:'buildDirectory localBuild selectedCompiler usedCompilerForBuild'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#ByteCodeCompilerSettingsAppl
	instanceVariableNames:'warnings warnSTX warnDollar warnOldStyle warnCommonMistakes
		warnUnderscore warnCompatibility warnUnusedVars
		warnAboutWrongVariableNames warnAboutBadComments
		warnInconsistentReturnValues
		warnAboutNonLowercaseLocalVariableNames allowQualifiedNames
		allowDollar allowReservedWordsAsSelectors allowOldStyleAssignment
		allowUnderscore allowDolphinExtensions allowSqueakExtensions
		allowVisualAgeESSymbolLiterals allowVisualAgePrimitives
		allowFixedPointLiterals justInTimeCompilation canLoadBinaries
		constantFoldingSelection keepSource constantFolding
		constantFoldingOptions fullDebugSupport immutableArrays
		immutableStrings enableUnderscore enableDollar
		allowEmptyStatements warnAboutPossibleSTCCompilationProblems
		warnAboutReferenceToPrivateClass warnAboutShortLocalVariableNames
		warnAboutPossiblyUnimplementedSelectors
		allowExtendedBinarySelectors warnAboutMissingMethodComment
		allowAssignmentToPoolVariable warnPlausibilityChecks
		allowParagraph enableParagraph'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#ChangeFileSettingsAppl
	instanceVariableNames:'classInfos vmInfo vmErrors displayErrors logDoits updChanges
		changeFileName beepForInfoDialog beepForWarningDialog
		beepForErrorDialog flyByHelp beepEnabled beepInEditor'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#CodeGeneratorSettingsAppl
	instanceVariableNames:'generateComments generateCommentsForGetters
		generateCommentsForSetters'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#CommunicationLoggingSettingsAppl
	instanceVariableNames:'logHTTPRequests logSOAPRequests'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#DebuggerSettingsAppl
	instanceVariableNames:'showErrorNotifier verboseBacktraceInDebugger
		allowSendMailFromDebugger useNewLayoutInDebugger
		hideSupportCodeInDebugger'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#DisplaySettingsAppl
	instanceVariableNames:'isColorMonitor useFixGrayPaletteLabel useFixPalette sizeY
		clipEncodingListSelection sizeX monitorList ditherList
		clipEncodingList ditherListSelection deepIcons monitorSelection
		useFixPaletteLabel visualIsPseudoColor ditherSymsNotNil
		useFixGrayPalette sizeInfos screen ditherStyles ditherSyms
		screenDepthVisualLabelHolder maxCopyBufferSize usedWidth
		usedHeight enableVMWareDrawingBugWorkaround'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#EditSettingsAppl
	instanceVariableNames:'st80EditingMode tabsIs4 st80DoubleClickSelectMode
		searchDialogIsModal startTextDragWithControl
		extendedWordSelectMode whitespaceWordSelectMode
		enforceContentsDropForFiles selectAllWhenClickingBeyondEnd
		showAcceptCancelBarInBrowser useCodeView2InTools
		autoIndentInCodeView immediateCodeCompletion
		codeCompletionOnControlKey codeCompletionOnTabKey
		selectionExtensionMode'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#GeneralCompilerSettingsAppl
	instanceVariableNames:'st80EditingMode tabsIs4 st80DoubleClickSelectMode
		searchDialogIsModal startTextDragWithControl catchClassRedefs
		fullHistoryUpdate historyLines keepSourceSelection keepSource
		hasHistoryManager canLoadBinaries loadBinaries catchMethodRedefs
		userNameInHistoryHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#HTTPStartServerSettingsApplication
	instanceVariableNames:'portNumberChannel informationLabel hasNoCreatedServerChannel
		hasCreatedServerChannel useFcgiHolder
		hasWebServerClassesNotLoadedHolder'
	classVariableNames:'CreatedServers'
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#KbdMappingSettingsAppl
	instanceVariableNames:'selectedRawKey macroTextHolder selectedFunctionKey
		labelTextHolder changeMapHolder currentKeyHolder functionKeyList
		rawKeyList mappings'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#LanguageSettingsAppl
	instanceVariableNames:'languageHolder languageIndexHolder languageList
		languageListHolder listOfLanguages translatedLanguages
		noticeLabelHolder currentFlagAndLanguageChannel
		currentLanguageLabel perLanguageResources useSystemLanguageHolder
		languageListEnabledHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#MemorySettingsAppl
	instanceVariableNames:'newSpaceSize maxOldSpace fastMoreLimit warningLabelHolder
		codeTrigger codeLimit oldIncr compressLimit igcFreeLimit igcLimit
		igcFreeAmount stackLimit supportsJustInTimeCompilation
		methodCodeSizeLimit'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#MiscBridgeCommunicationSettingsAppl
	instanceVariableNames:'smallTeamServerEnabled selectedSmallTeamHost listOfSmallTeamHosts
		smallTeamHostEntry dotNetBridgeVerbose dotNetBridgeRunsInIDE
		smalltalkBridgeEnabled smalltalkBridgeVerbose'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#MiscCommunicationSettingsAppl
	instanceVariableNames:'smtpServerName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#MiscDisplay2SettingsAppl
	instanceVariableNames:'nativeWidgets nativeDialogs shadows opaqueVariablePanelResize
		opaqueTableColumnResize lowerOnRightClickInTitle
		lowerOnShiftClickInTitle displaySupportsNativeFileDialogs
		nativeFileDialogs cartoonToolTipStyle'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#MiscDisplaySettingsAppl
	instanceVariableNames:'returnFocus focusFollowsMouse mouseWheelFocusFollowsMouse
		beepEnabled takeFocus activateOnClick
		formatHostNameinWindowLabels hostNameInLabelHolder
		showAccelerators newWindowLabelFormat formatHostNameWindowLabel
		selectOnRightClick popUpMenuOnRelease
		showRightButtonMenuOnRelease formatHostNameWindowLabel1
		formatHostNameWindowLabel2 allowMouseWheelZoom
		forceWindowsIntoMonitorBounds button2WithAltKey
		autoRaiseOnFocusIn menuPanelTakesFocusOnClick
		shouldRememberLastExtentHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#MiscSmalltalkCommunicationSettingsAppl
	instanceVariableNames:'remoteBrowsingEnabled windowMigrationEnabled
		windowMigrationPassword windowMigrationAuthenticate
		enablePasswordCheck smallTeamServerEnabled selectedSmallTeamHost
		listOfSmallTeamHosts smallTeamHostEntry addHostEnabled
		removeHostEnabled smalltalkBridgeEnabled smalltalkBridgeVerbose
		smallTeamViaXMPPEnabled selectedXMPPSmallTeamUser
		xmppSmallTeamUserEntry listOfXMPPSmallTeamUsers
		smallteamXMPPServer smallteamXMPPUser smallteamXMPPPassword'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#OsiSettingsAppl
	instanceVariableNames:'osiACSEConnectionLogging osiROSEErrorLogging osiCMISEErrorLogging
		osiACSEErrorLogging osiROSEPresent osiCMISEPresent
		osiCMISEMessageLogging osiACSEDataLogging
		osiROSEInvokationLogging osiACSEPresent osiROSEResponseLogging'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#PackagePathSettingsAppl
	instanceVariableNames:'listOfFoldersInPath selectedFolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#PrinterSettingsAppl
	instanceVariableNames:'selectedUnit supportsColor topMargin rightMargin bottomMargin
		landscape pageFormatList pageFormat unitList leftMargin
		possiblePrinters printerType printerTypeSelection
		printCommandList commandList printCommand printFilename
		enableFormat enablelandscape enableMargins enableColorBox
		printerIsDrivenByCommand printerSupportsPrintingToFile
		supportsPageFormatSetting supportsMarginSetting
		supportsColorSetting'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#ProcessorSchedulerSettingsAppl
	instanceVariableNames:'dynamicPrios preemptive'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#RDoItServerSettingsAppl
	instanceVariableNames:'rDoitLogging rDoitsEnabled rDoitErrorLogging hasRDoitServer
		rDoitErrorDebugging rDoitServerPortOrPath
		rDoitEnabledOnlyViaLocalConnection scriptingEnabled
		scriptingEnabledOnlyViaLocalConnection scriptingErrorDebugging
		scriptingErrorLogging scriptingLogging scriptingServerPortOrPath
		rDoitOnlyViaLocalConnection'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#SQLServerSettingsAppl
	instanceVariableNames:'sqlServerEnabled sqlSmalltalkServerEnabled sqlLogging
		sqlDataLogging sqlErrorLogging hasSQLServer sqlErrorDebugging
		sqlServerPort sqlStatementLogging'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#STCCompilerSettingsAppl
	instanceVariableNames:'cc ccOptions stcIncludes linkCommand stc linkArgs linkSharedArgs
		canLoadBinaries stcDefines stcLibraries stcOptions stcLibraryPath
		stcCompilationSelection stcCompilationList makeCommand
		stcKeepCIntermediate supportedCCompilerSelection verbose'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#SourceCodeFormatSettingsAppl
	instanceVariableNames:'spaceAfterKeywordSelector emptyLineAfterTemporaries tabIndent
		autoFormat cStyleBlocks editorText maxLengthForSingleLineBlocks
		blockArgumentsOnNewLine spaceAfterReturnToken
		spaceAroundTemporaries spaceAfterBlockStart spaceBeforeBlockEnd
		oldUserPreferences reformatLocked'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#SourceCodeManagementSettingsAppl
	instanceVariableNames:'sourceCacheDir useManager availableManagers condenseSourceCache
		setupSourceCodeManager checkClassesWhenCheckingIn
		formattingConfiguration flushSourceCache localSourceFirst
		repositoryHolder manager repository listOfModules
		managerTypePerModule addPerModuleRoot removeEnabled
		perModuleRootModule removePerModuleRoot perModuleRoot
		selectedPerModuleRoot rootsPerModule
		selectedManagerTypeIndexHolder managerIsCVSSourceCodeManager
		managerIsStoreSourceCodeManager perModuleFieldsEnableHolder
		managerIsSmallTeamSourceCodeManager verboseSourceCodeAccess
		keepMethodSource packageToAddHolder managerTypeIndexToAddHolder
		managerTypeToAddHolder managerPerMatchingModule
		selectedManagerPerMatchingModuleHolder'
	classVariableNames:'RecentlyUsedCVSRoots RecentlyUsedStoreHosts
		RecentlyUsedSmallTeamHosts LastStoreHost LastStoreUser
		LastStorePassword FillCacheProcess'
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

SimpleDialog subclass:#PerModuleManagerSettingDialog
	instanceVariableNames:'packageHolder managerNameHolder availableManagers'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication::SourceCodeManagementSettingsAppl
!

AbstractSettingsApplication subclass:#StyleSettingsAppl
	instanceVariableNames:'showStandardStylesOnly styleList selectedStyle
		styleDirectoryContents infoLabelHolder noticeLabelHolder
		previewVisibleHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#SyntaxColorSettingsAppl
	instanceVariableNames:'coloredText syntaxColor syntaxColors resetList resetListSelection
		fullSelectorCheck syntaxColoring oldUserPreferences
		syntaxFontSelector syntaxFonts syntaxElementList
		syntaxElementSelection syntaxEmphasisList syntaxEmphasisSelection
		emphasisDictionary resetListDictionary changedSettings'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#SystemBrowserSettingsAppl
	instanceVariableNames:'showAcceptCancelBarInBrowser useSearchBarInBrowser
		showMethodTemplate useCodeView2InTools
		showEmbeddedTestRunnerInBrowser showBookmarkBar
		webBrowserLikeLayout sortAndIndentClassesByInheritance
		showLocalHistory showGlobalHistory useInPlaceSearchInBrowserLists
		sourceCodeManagementMenuLayout confirmRefactorings
		smallLintRulesetDefault showMarqueeInfo'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#SystemMessageSettingsAppl
	instanceVariableNames:'classInfos vmInfo vmErrors displayErrors logDoits updChanges
		changeFileName beepForInfoDialog beepForWarningDialog
		beepForErrorDialog flyByHelp beepEnabled beepInEditor
		toolTipAutoHideDelay sendMessagesAlsoToTranscript
		onlyShowTooltipsForActiveWindow'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#TerminalViewSettingsAppl
	instanceVariableNames:'terminalOutputIsUTF8 terminalInputIsUTF8'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#ToolboxSettingsAppl
	instanceVariableNames:'changesBrowserClassName fileBrowserClassName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

ApplicationModel subclass:#ClassToolSetting
	instanceVariableNames:'optionValueHolder optionValueList optionLabelHolder
		optionSelectionHolder optionLabelList optionCustomValueHolder
		optionCustomValueVisibleHolder optionCustomValueBackgroundHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication::ToolboxSettingsAppl
!

AbstractSettingsApplication subclass:#ToolsSettingsAppl
	instanceVariableNames:'useNewVersionDiffBrowser transcriptBufferSize useNewInspector
		showClockInLauncher useNewChangesBrowser useNewFileBrowser
		useNewSystemBrowser useNewFileDialog useNewSettingsApplication
		useProcessMonitorV2 useSmalltalkDocumentViewer useTestRunner2
		showTipOfTheDayAtStartup autoRaiseTranscript eclipseStyleMenus
		useNewChangeSetBrowser useCodeView2InTools
		externalDiffCommandTemplate'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

AbstractSettingsApplication subclass:#WorkspaceSettingsAppl
	instanceVariableNames:'usersModuleName workspaceDirectory'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSettingsApplication
!

!AbstractSettingsApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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
    This is an abstract framework for settings applications.
    For a real settings dialog, you need a concrete settings dialog class to hold the pages
    (as an example, see SettingsDialog)
    and someone who specifies the hierarchy of settings-pages in a spec.
    (as an example, see SettingsDialog class>>defaultSettingsApplicationList)

    typical use:

        |settingsList settingsApp|

        settingsList := NewLauncher settingsList.

        settingsApp := SettingsDialog new.
        'settingsApp requestor:requestingApplication'.
        settingsApp installSettingsEntries:settingsList.
        settingsApp allButOpen.
        settingsApp window label:('ST/X Settings').
        settingsApp openWindow.

"
! !

!AbstractSettingsApplication class methodsFor:'defaults'!

classResources
    self package == AbstractLauncherApplication package ifTrue:[
        ^ AbstractLauncherApplication classResources
    ].
    ^ super classResources
!

resourcePackName
    "return the name which is used as the fileNameBase of my resource file.
     Here, use the same resources as the Launcher"

    self package == AbstractLauncherApplication package ifTrue:[
        ^ AbstractLauncherApplication resourcePackName
    ].
    ^ super resourcePackName
!

subEntryRawSettingsList
    "redefine if I have sub-settings entries"

    ^ #()

    "Created: / 25-10-2010 / 09:37:21 / cg"
! !

!AbstractSettingsApplication class methodsFor:'interface specs'!

windowSpec
    self subclassResponsibility
!

windowSpecForDialog
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication andSelector:#windowSpecForDialog
     AbstractSettingsApplication new openInterface:#windowSpecForDialog
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpecForDialog
       window:
      (WindowSpec
         label: 'NewApplication'
         name: 'NewApplication'
         labelChannel: settingsString
         min: (Point 10 10)
         bounds: (Rectangle 0 0 531 488)
       )
       component:
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'Content'
             layout: (LayoutFrame 7 0 0 0 -7 1 -40 1)
             level: 0
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             minorKey: windowSpec
             createNewBuilder: false
           )
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 5 0 -40 1 -7 1 0 1)
             horizontalLayout: right
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component:
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'CancelButton'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 159 25)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'OKButton'
                   translateLabel: true
                   model: doAccept
                   enableChannel: modifiedChannel
                   isDefault: true
                   defaultable: true
                   extent: (Point 159 25)
                 )
                )

             )
             keepSpaceForOSXResizeHandleH: true
           )
          )

       )
     )
! !

!AbstractSettingsApplication class methodsFor:'queries'!

isAbstract
    ^ (self == AbstractSettingsApplication)
!

quickSearchStrings
    "returns a set of words to match in the quickSearch.
     Here, as a fallback, the keys from the help spec,
     the widget names and label aspects are returned
     Notice that both all words and its current language translation are included
     in the set and will be matched against the word in the quick search field"

    |words helpKeys resources
     addSingleWord addEachWord addEachWordXLated|

    "/ translate
    resources := self classResources.

    addSingleWord :=
        [:word :origin|
            true "(w first isLetter)" ifTrue:[
                words add:word asLowercase.
            ].
        ].

    addEachWord :=
        [:aString :origin|
            aString asCollectionOfWordsDo:[:w |
                addSingleWord value:w value:origin
            ].
        ].

    addEachWordXLated :=
        [:aString :origin |
            |xlation|

            aString notNil ifTrue:[
                addEachWord value:aString value:origin.
                (xlation := resources string:aString) notNil ifTrue:[
                    xlation ~= aString ifTrue:[
                        addEachWord value:xlation value:origin.
                    ].
                ].
            ].
        ].

    words := Set new.
    helpKeys := Set new.

    self windowSpec decodeAsLiteralArray do:[:eachSpec |
        |helpKey label|

        label := eachSpec perform:#label ifNotUnderstood:nil.
        label notNil ifTrue:[
            addEachWordXLated value:label value:(#label->eachSpec).
        ].

        (helpKey := eachSpec activeHelpKey) notNil ifTrue:[
            helpKeys add:helpKey.
            "/ words add:helpKey string asLowercase.
            addSingleWord value:helpKey string value:(#helpKey->eachSpec)
        ].
    ].
    self flyByHelpSpec keys do:[:k |
        helpKeys add:k.
        addSingleWord value:k value:#helpKeyTop
    ].

    helpKeys do:[:eachKey |
        |helpText|

        helpText := self flyByHelpSpec at:eachKey ifAbsent:nil.
        addEachWordXLated value:helpText value:(#helpText->eachKey).
    ].
    ^ words

    "
     AbstractSettingsApplication::BuildSettingsAppl quickSearchStrings
    "
! !

!AbstractSettingsApplication methodsFor:'accessing'!

clearDidModifySettings
    "clear the flag that any settings was changed.
     Not to confuse with the modified flag, which means that a settings app's
     changes must be stored into the UserPreferences.
     This one tells if any UserPreferences has been changed, and the userPrefs
     should be saved back to the settings.rc file"

     didModifySettings := false.
!

didModifySettings
    "true, if any settings was changed.
     Not to confuse with the modified flag, which means that a settings app's
     changes must be stored into the UserPreferences.
     This one tells if any UserPreferences has been changed, and the userPrefs
     should be saved back to the settings.rc file"

     ^ didModifySettings
!

requestor:anotherApplication
    requestor := anotherApplication.

    "Modified: / 12-05-2010 / 17:16:37 / cg"
!

settingsDialog
    ^ settingsDialog
!

settingsDialog:aSettingsDialog
    settingsDialog := aSettingsDialog.

    "Modified: / 12-05-2010 / 18:44:09 / cg"
!

settingsString
    ^ settingsString
! !

!AbstractSettingsApplication methodsFor:'actions'!

accept
    self saveSettings

    "Created: / 14-10-2014 / 09:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

discardChangesAndReadSettings
    self readSettings.
!

evaluateModified
    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self updateModifiedChannel.
!

readSettings
    self basicReadSettings.

    self modifiedChannel value:false.
!

reopenToolsAfterChangedViewStyleSetting
    |app transcript|

    DebugView newDebugger.

    transcript := Transcript current.
    (transcript notNil and:[transcript isExternalStream not]) ifTrue:[
        app := transcript topView application.
        app perform:#reopenLauncher ifNotUnderstood:[].
    ].

    self window topView raise.
!

saveRequest
    ^ self saveRequestAsking:self askForChangeOnRelease
!

saveRequestAsking:askForChangeOnRelease
    |result|

    self hasUnsavedChanges ifTrue:[
        askForChangeOnRelease ifTrue:[
            result := self confirmWithCancel:(self resources
                                string:'Apply changes made in %1 ?'
                                with:(resources string:settingsString) allBold).
        ] ifFalse:[
            result := true.
        ].

        result isNil ifTrue:[
            ^ false
        ].
        result ifTrue:[
            self saveSettings
        ] ifFalse:[
            "/ reload current settings to show the right thing when re-entering.
            self readSettings
        ]
    ].
    ^ true

    "Modified: / 20-09-2006 / 23:56:25 / cg"
!

saveSettings
    self basicSaveSettings.
    didModifySettings := true.
    self modifiedChannel value:false.
!

saveSettingsIfUnsavedChangesArePresent
    self hasUnsavedChanges ifTrue:[
        self saveSettings.
        self modifiedChannel value:false
    ].
!

updateModifiedChannel
    self modifiedChannel value:self hasUnsavedChanges
! !

!AbstractSettingsApplication methodsFor:'aspects'!

aspects
    "if redefined to return a non-nil list of preference-key aspects,
     you can then use the basicSaveSettings/basicReadSettings/hasUnsavedChanges
     as inherited from here.
     Otherwise, if you do not want the aspect-list-keys to be read/saved in the settings,
     you MUST redefine all of the 3 above mentioned methods."

    ^ nil
!

modifiedChannel

    modifiedChannel isNil ifTrue:[
        modifiedChannel := false asValue.
    ].
    ^ modifiedChannel
! !

!AbstractSettingsApplication methodsFor:'helpers'!

hasChangedAspectIn:aListOfAspects asComparedTo:anAspectProvider
    "this code-sharing helper compares a bunch of aspect value against some object.
     The object is typically the current userPreferences object, or a flag-holder, such
     as ParserFlags.
     Using this, and a list of aspect selectors replaces code like:
        someone aspect1 ~= (self aspect1 value) ifTrue:[^ true].
        someone aspect2 ~= (self aspect2 value) ifTrue:[^ true].
        ...
        someone aspectN ~= (self aspectN value) ifTrue:[^ true].
        ^ false
     Prerequisite:
        local aspects must be named like corresponding aspect methods in the flag-provider.
    "

    aListOfAspects do:[:eachAspectSymbol |
        (self myAspectHolderFor:eachAspectSymbol) value ~= (anAspectProvider perform:eachAspectSymbol) ifTrue:[
            self debuggingCodeFor:#cg is:[
                Transcript showCR:'settings aspect is different: ',eachAspectSymbol.
                Transcript showCR:'  here: ',((self perform:eachAspectSymbol) value) printString.
                Transcript showCR:'  there: ',((anAspectProvider perform:eachAspectSymbol) value) printString.
            ].
            ^ true
        ].
    ].
    ^ false

    "Modified: / 23-03-2011 / 15:45:11 / cg"
!

myAspectHolderFor:aspectSymbol
    "/ used to be (self perform:aspectSymbol),
    "/ but I am tired of having to add all those aspect getters.

    ^ self
        perform:aspectSymbol
        ifNotUnderstood:[
            |holder|

            self createBuilder.
            (holder := builder bindingAt:aspectSymbol) isNil ifTrue:[
                builder aspectAt:aspectSymbol put:(holder := nil asValue).
                holder onChangeSend:#updateModifiedChannel to:self.
            ].
            holder
        ].
!

readAspects:aListOfAspects from:anAspectProvider
    "this code-sharing helper reads a bunch of aspect values from some object.
     The object is typically the current userPreferences object, or a flag-holder, such
     as ParserFlags.
     Using this, and a list of aspect selectors replaces code like:
        self aspect1 value:(someone aspect1).
        self aspect2 value:(someone aspect2).
        ...
        self aspectN value:(someone aspectN).
     Prerequisite:
        local aspects must be named like corresponding aspect methods in the flag-provider.
    "

    aListOfAspects do:[:eachAspectSymbol |
        (self myAspectHolderFor:eachAspectSymbol)
            value:(anAspectProvider perform:eachAspectSymbol)
            withoutNotifying:self
    ].

    "Modified: / 08-02-2011 / 09:11:03 / cg"
!

writeAspects:aListOfAspects to:anAspectProvider
    "this code-sharing helper writes a bunch of aspect values into some object.
     The object is typically the current userPreferences object, or a flag-holder, such
     as ParserFlags.
     Using this, and a list of aspect selectors replaces code like:
        someone aspect1:(self aspect1 value).
        someone aspect2:(self aspect2 value).
        ...
        someone aspectN:(self aspectN value).
     Prerequisite:
        local aspects must be named like corresponding aspect methods in the flag-provider.
    "

    aListOfAspects do:[:eachAspectSymbol |
        anAspectProvider
            perform:eachAspectSymbol asMutator
            with:(self myAspectHolderFor:eachAspectSymbol) value
    ].

    "Modified: / 24-08-2010 / 16:52:42 / sr"
! !

!AbstractSettingsApplication methodsFor:'hooks'!

preOpenWith: anUIBuilder
    self readSettings

    "Created: / 14-10-2014 / 09:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication methodsFor:'initialization'!

initialize
    super initialize.
    resources := self class classResources.
    currentUserPrefs isNil ifTrue:[ self initializeCurrentUserPreferences ].
    settingsString := (UISpecification from:(self class windowSpec)) window label.
    didModifySettings := false.

    "/ self readSettings.

    "Modified: / 12-05-2010 / 17:27:44 / cg"
!

initializeCurrentUserPreferences
    currentUserPrefs := UserPreferences current.
! !

!AbstractSettingsApplication methodsFor:'menu'!

settingsDialogPopUpMenu
    ^ nil
! !

!AbstractSettingsApplication methodsFor:'opening'!

open
    "open a standard interface.
     Sorry, but for visualworks compatibility, the builder is returned"

    ^ self openInterfaceModal: #windowSpecForDialog

    "Created: / 14-10-2014 / 09:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication methodsFor:'protocol'!

askForChangeOnRelease
    ^ true "/ false
!

basicReadSettings
    "utility to read aspects as listed in the aspects method.
     If that has not been redefined, an error will be reported,
     as you should then redefine this method in a subclass"

    |aspects|

    (aspects := self aspects) notNil ifTrue:[
        self
            readAspects: aspects
            from:currentUserPrefs.
        ^ self
    ].
    ^ self subclassResponsibility:'either basicReadSettings or aspects must be redefined'
!

basicSaveSettings
    "utility to save aspects as listed in the aspects method.
     If that has not been redefined, an error will be reported,
     as you should then redefine this method in a subclass"

    |aspects|

    (aspects := self aspects) notNil ifTrue:[
        self
            writeAspects:(self aspects)
            to:currentUserPrefs.
        ^ self
    ].
    ^ self subclassResponsibility
!

hasUnsavedChanges
    "utility to check for changed aspects as listed in the aspects method.
     If that has not been redefined, an error will be reported,
     as you should then redefine this method in a subclass"

    |aspects|

    (aspects := self aspects) notNil ifTrue:[
        ^ (self
            hasChangedAspectIn:(self aspects)
            asComparedTo:currentUserPrefs)
    ].
    ^ self subclassResponsibility
!

help
    |filename|

    filename := self helpFilename.
    filename isNil ifTrue:[
        self warn:(self resources string:'Sorry - no Help available here.').
        ^ self.
    ].
    self withWaitCursorDo:[
        HTMLDocumentView openFullOnHelpFile:filename
    ].
!

helpFilename
    "subclasses must return either the relative path of a helpFile
     in the doc/online/<language>/help directory,
     or an absolute path (typically in its packageDirectory).
     If an absolute filename is returned, the %(lang) sequence is replaced
     by the current user's language.
     Or nil, if no help is available."

    Smalltalk isStandAloneApp ifFalse:[
        self subclassResponsibility.
    ].
    ^ nil.
!

widgetsWithChangedSettingsDo:aBlock
    "/ to be redefined in subclasses...

    |mySpec|

    self hasValuesDifferentFromDefault ifTrue:[
        mySpec := self class windowSpec decodeAsLiteralArray.
        (self aspects ? #()) do:[:aspect |
            |subSpec widget|

            (UserPreferences default perform:aspect) ~= (currentUserPrefs perform:aspect) ifTrue:[
                subSpec := mySpec findSpecForWhich:[:spec | spec model = aspect].
                widget := self window
                            allSubViewsDetect:[:w | w name = subSpec name]
                            ifNone:nil.
                aBlock value:widget.
            ].
        ].
    ].
! !

!AbstractSettingsApplication methodsFor:'queries'!

hasValuesDifferentFromDefault
    |savedCurrent answer|

    self hasUnsavedChanges ifTrue:[^ true].

    savedCurrent := currentUserPrefs.
    [
        currentUserPrefs := UserPreferences default.
        answer := self hasUnsavedChanges
    ] ensure:[
        currentUserPrefs := savedCurrent
    ].
    ^ answer
!

isEnabledInSettingsDialog:aSettingsDialog
    ^ true

    "Created: / 25-01-2007 / 16:47:45 / cg"
!

itemPathName
    settingsDialog isNil ifTrue:[^ ''].
    ^ settingsDialog getNameOfApplication:self.
!

quickSearchStrings
    "returns a set of keywords to match in the quickSearch.
     Notice that both the word and its current language translation is matched against
     the text in the quick search field"

    ^ self class quickSearchStrings
! !

!AbstractSettingsApplication::AllSettingsAppl class methodsFor:'documentation'!

documentation
"
    this little app provides an alternative view on all settings keys.
    This offers a name-list of settings values, and thus allows for
    settings to be changed for which no 'real' UI has been programmed.
    (i.e. a fallback for missing things)
"
! !

!AbstractSettingsApplication::AllSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ByteCodeCompilerSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom: self helpPairs
!

helpPairs
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ByteCodeCompilerSettingsAppl
    "

    <resource: #help>

    ^ #(


)
! !

!AbstractSettingsApplication::AllSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ super defaultIcon
! !

!AbstractSettingsApplication::AllSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::AllSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::AllSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::AllSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'All Settings'
         name: 'All Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 659 242)
       )
       component:
      (SpecCollection
         collection: (
          (DataSetSpec
             name: 'Table1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             model: selectedSettingHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             dataList: settingsList
             columns:
            (OrderedCollection

              (DataSetColumnSpec
                 label: 'Name'
                 labelButtonType: Button
                 height: heightOfFirstRow
                 model: key
                 menuFromApplication: false
               )
              (DataSetColumnSpec
                 label: 'Value'
                 labelButtonType: Button
                 height: heightOfFirstRow
                 model: value
                 menuFromApplication: false
               )
             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::AllSettingsAppl methodsFor:'actions'!

basicReadSettings
    super basicReadSettings.

    usedCompilerForBuild value isNil ifTrue:[
        currentUserPrefs usedCompilerForBuild:(Tools::ProjectBuilder defaultUsedCompiler).
        usedCompilerForBuild value:(Tools::ProjectBuilder defaultUsedCompiler).
    ].

    "Modified: / 26-07-2012 / 23:16:52 / cg"
!

basicSaveSettings
    |buildDir|

    buildDir := buildDirectory value.
    buildDir notEmptyOrNil ifTrue:[
        buildDir := buildDir asFilename.
        buildDir isDirectory ifFalse:[
            (Dialog confirm:(resources
                        stringWithCRs:'Build directory %1 does not exist.\\Create?'
                        with:buildDir pathName allBold))
            ifTrue:[
                buildDir makeDirectory.
            ]
        ].
    ].

    super basicSaveSettings.

    "Modified: / 22-01-2012 / 10:50:09 / cg"
!

cleanupBuildDirectory
    |buildDir|

    buildDir := buildDirectory value.
    buildDir isEmptyOrNil ifTrue:[
        ^ self.
    ].
    buildDir := buildDir asFilename.
    (buildDir exists and:[Dialog confirm:('Really delete <1p> ?' expandMacrosWith:buildDir physicalPathName)]) ifTrue:[
        buildDir recursiveRemove.
        buildDir makeDirectory.
    ].
! !

!AbstractSettingsApplication::AllSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
          buildDirectory
          localBuild
          usedCompilerForBuild
      )
!

buildDirectory
    buildDirectory isNil ifTrue:[
        buildDirectory := ValueHolder new.
        buildDirectory onChangeSend:#updateModifiedChannel to:self
    ].
    ^ buildDirectory.
!

fetchSettingsList
    |list|

    list := List new.
    UserPreferences selectorsAndMethodsDo:[:sel :mthd|
        |setter getter getterMethod|

        sel numArgs == 1 ifTrue:[
            (sel endsWith:$:) ifTrue:[
                setter := sel.
                getter := sel copyButLast asSymbolIfInterned.
                getter notNil ifTrue:[
                    (UserPreferences implements:getter) ifTrue:[
                        getterMethod := UserPreferences compiledMethodAt:getter.
                        getterMethod isObsolete ifFalse:[
                            list add:(sel -> (UserPreferences current perform:getter)).
                        ].
                    ].
                ].
            ].
        ].
    ].
    list sortBySelector:#key.
    ^ list
!

hasSourceCodeManager
    ^ SourceCodeManager notNil
!

listOfPossibleCompilers
    ^ Tools::ProjectBuilder listOfPossibleCompilers

    "Created: / 21-01-2012 / 14:05:43 / cg"
!

localBuild
    localBuild isNil ifTrue:[
        localBuild := UserPreferences current localBuild asValue.
        localBuild onChangeSend:#updateModifiedChannel to:self
    ].
    ^ localBuild.
!

selectedSettingHolder
    <resource: #uiAspect>

    selectedSettingHolder isNil ifTrue:[
        selectedSettingHolder := ValueHolder new.
    ].
    ^ selectedSettingHolder.
!

settingsList
    <resource: #uiAspect>

    settingsList isNil ifTrue:[
        settingsList := self fetchSettingsList.

    ].
    ^ settingsList.
!

usedCompilerForBuild
    usedCompilerForBuild isNil ifTrue:[
        usedCompilerForBuild := nil asValue.
        usedCompilerForBuild onChangeSend:#updateModifiedChannel to:self
    ].
    ^ usedCompilerForBuild.

    "Created: / 22-01-2012 / 10:59:30 / cg"
! !

!AbstractSettingsApplication::AllSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/buildSetup.html'
! !

!AbstractSettingsApplication::AllSettingsAppl methodsFor:'initialization'!

postBuildDirectoryField:aField
    aField historyList value:(Array
        with:(OperatingSystem getHomeDirectory asFilename construct:'stx_build') pathName
        with:(Filename currentDirectory construct:'stx_build') pathName)
! !

!AbstractSettingsApplication::AllSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    (super hasUnsavedChanges) ifTrue:[^ true].
    ^ false

    "Modified: / 22-01-2012 / 10:50:15 / cg"
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl class methodsFor:'documentation'!

documentation
"
    I manage packages which are to be loade automatically
    whenever st/x ist started
"
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MemorySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(
#autoloadedPackages
'Select known packages from the left list, and click on ">>>" to add them to the autoloaded list.\These will be automatically loaded when ST/X is started without a snapshot image.\Packages are searched along the packagePath.'

)
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary packageOpen24x24Icon
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::AutoloadedPackagesSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::AutoloadedPackagesSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::AutoloadedPackagesSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Autoloaded Packages Settings'
         name: 'Autoloaded Packages Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 705 722)
       )
       component:
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Packages Automatically Loaded at Startup'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             labelPosition: topLeft
             translateLabel: true
             activeHelpKey: autoloadedPackages
             component:
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'SubCanvas1'
                   layout: (LayoutFrame 0 0 8 0 0 1 0 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: MultipleItemSelectionWidget
                   createNewApplication: true
                   createNewBuilder: false
                   postBuildCallback: postCreatePackageChooserWidget:
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl methodsFor:'actions'!

basicReadSettings
    packageChooser notNil ifTrue:[
        packageChooser listOfSelectedItems value:(UserPreferences current autoloadedPackages).
    ].
!

basicSaveSettings
    UserPreferences current
        autoloadedPackages:(packageChooser listOfSelectedItems value asArray collect:[:each | each asString string]).
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
                autoloadedPackages
    )
!

possibleItemsLabel
    ^ 'Available Packages'.
!

readPackageList
    "self basicNew readPackageList"

    |packageDirPath list setOfPackages setOfAlreadySelectedPckages|

    packageDirPath := Smalltalk getSystemFileName:'packages'.
    packageDirPath isNil ifTrue:[
        ^ #()
    ].

    list := OrderedCollection new.
    setOfPackages := Set new.
    setOfAlreadySelectedPckages := UserPreferences current autoloadedPackages asSet.

    packageDirPath asFilename directoryContentsAsFilenames sort do:[:fn |
        |item base nm path parentPath parent isLibrary isApplication isAlreadyLoaded
         defClass target packageID|

        ((fn suffix = 'mcz')
            or:[ fn isDirectory
            or:[ (fn baseName startsWith:'.')
            or:[ (fn baseName = 'README') ]]
        ]) ifFalse:[
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
            packageID := (path size > 1)
                            ifTrue:[ path first , ':' , ((path copyFrom:2) asStringWith:$/) ]
                            ifFalse:[ path first ].

            (setOfPackages includes:packageID) ifFalse:[
                (setOfAlreadySelectedPckages includes:packageID) ifFalse:[
                    setOfPackages add:packageID.
                    isAlreadyLoaded :=
                        (defClass := ProjectDefinition definitionClassForPackage:packageID) notNil
                        and:[ defClass isLoaded
                        and:[ defClass isFullyLoaded ]].

                    isAlreadyLoaded ifTrue:[
                        list add:(packageID,(' (currently loaded)' withColor:Color grey))
                    ] ifFalse:[
                        list add:packageID
                    ]
                ].
            ].
        ].
    ].
    list sort.
    ^ list
!

selectedItemsLabel
    ^ 'Packages Loaded at Startup'.
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/autoloadedPackagesSettings.html'
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl methodsFor:'initialization'!

postCreatePackageChooserWidget:aPackageChooser
    |availPackages selectedPackages setOfSelectedPackages|

    availPackages := self readPackageList.
    selectedPackages := UserPreferences current autoloadedPackages.
    setOfSelectedPackages := selectedPackages asSet.

    availPackages := availPackages reject:[:el | setOfSelectedPackages includes:el].

    packageChooser := aPackageChooser application.
    packageChooser addAllButtonVisibleHolder value:false.
    packageChooser removeAllButtonVisibleHolder value:false.
    packageChooser listOfPossibleItems value:availPackages asOrderedCollection.
    packageChooser listOfSelectedItems value:selectedPackages asOrderedCollection.
    packageChooser possibleItemsLabelHolder value:(resources string:self possibleItemsLabel).
    packageChooser selectedItemsLabelHolder value:(resources string:self selectedItemsLabel).

    packageChooser listOfSelectedItems onChangeSend:#updateModifiedChannel to:self.
! !

!AbstractSettingsApplication::AutoloadedPackagesSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    packageChooser notNil ifTrue:[
        packageChooser listOfSelectedItems value asArray = UserPreferences current autoloadedPackages asArray ifFalse:[^true].
    ].
    ^ false.
! !

!AbstractSettingsApplication::BuildSettingsAppl class methodsFor:'documentation'!

documentation
"
    I manage parameters for package building (for deployment)
"
! !

!AbstractSettingsApplication::BuildSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ByteCodeCompilerSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom: self helpPairs
!

helpPairs
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ByteCodeCompilerSettingsAppl
    "

    <resource: #help>

    ^ #(

#buildDirectory
'Temporary folder, where application packages are built for deployment.\If left unspecified, this defaults to the workspace folder or the current directory, if no workspace has been defined).'

#localBuild
'If checked, files are saved from the image to the build directory and compiled there.\If unchecked, files need to be checked into a repository and are fetched from there into a temporary for a build.'


)
! !

!AbstractSettingsApplication::BuildSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ AbstractSettingsApplication::ByteCodeCompilerSettingsAppl defaultIcon

    "Modified: / 17-09-2007 / 11:35:02 / cg"
! !

!AbstractSettingsApplication::BuildSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::BuildSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::BuildSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::BuildSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Build Settings'
         name: 'Build Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 659 242)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel3'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 4
             component:
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Build Directory'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'LocalBuild'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         activeHelpKey: localBuild
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Local Build (Do not use Repository)'
                               name: 'CheckBox4'
                               layout: (LayoutFrame 2 0 5 0 -5 1 27 0)
                               activeHelpKey: localBuild
                               enableChannel: hasSourceCodeManager
                               model: localBuild
                               translateLabel: true
                             )
                            )

                         )
                       )
                      (ViewSpec
                         name: 'Build Directory'
                         layout: (LayoutFrame 0 0 40 0 0 1 70 0)
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Build Directory:'
                               name: 'BuildDirDirLabel'
                               layout: (LayoutFrame 0 0.0 0 0 200 0 22 0)
                               activeHelpKey: buildDirectory
                               translateLabel: true
                               adjust: right
                             )
                            (FilenameInputFieldSpec
                               name: 'FilenameEntryField1'
                               layout: (LayoutFrame 202 0 0 0 0 1 22 0)
                               activeHelpKey: buildDirectory
                               enableChannel: localBuild
                               model: buildDirectory
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: true
                               postBuildCallback: postBuildDirectoryField:
                               viewClassName: FilenameWidgetWithHistory
                             )
                            )

                         )
                       )
                      (HorizontalPanelViewSpec
                         name: 'ActionsHorizontalPanel'
                         layout: (LayoutFrame 62 0.25 67 0 0 1 96 0)
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Cleanup Build Directory'
                               name: 'CleanupBuildDirectoryButton'
                               translateLabel: true
                               tabable: true
                               model: cleanupBuildDirectory
                               extent: (Point 390 26)
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 659 136)
                 )
                (ViewSpec
                   name: 'Box1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Compiler for Build:'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 0 0 150 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (ComboListSpec
                         name: 'ComboList1'
                         layout: (LayoutFrame 150 0 0 0 300 0 20 0)
                         model: usedCompilerForBuild
                         comboList: listOfPossibleCompilers
                         useIndex: false
                       )
                      )

                   )
                   extent: (Point 659 25)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::BuildSettingsAppl methodsFor:'actions'!

basicReadSettings
    super basicReadSettings.

    usedCompilerForBuild value isNil ifTrue:[
        currentUserPrefs usedCompilerForBuild:(Tools::ProjectBuilder defaultUsedCompiler).
        usedCompilerForBuild value:(Tools::ProjectBuilder defaultUsedCompiler).
    ].

    "Modified: / 26-07-2012 / 23:16:52 / cg"
!

basicSaveSettings
    |buildDir|

    buildDir := buildDirectory value.
    buildDir notEmptyOrNil ifTrue:[
        buildDir := buildDir asFilename.
        buildDir isDirectory ifFalse:[
            (Dialog confirm:(resources
                        stringWithCRs:'Build directory %1 does not exist.\\Create?'
                        with:buildDir pathName allBold))
            ifTrue:[
                buildDir makeDirectory.
            ]
        ].
    ].

    super basicSaveSettings.

    "Modified: / 22-01-2012 / 10:50:09 / cg"
!

cleanupBuildDirectory
    |buildDir|

    buildDir := buildDirectory value.
    buildDir isEmptyOrNil ifTrue:[
        ^ self.
    ].
    buildDir := buildDir asFilename.
    (buildDir exists and:[Dialog confirm:('Really delete <1p> ?' expandMacrosWith:buildDir physicalPathName)]) ifTrue:[
        buildDir recursiveRemove.
        buildDir makeDirectory.
    ].
! !

!AbstractSettingsApplication::BuildSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
          buildDirectory
          localBuild
          usedCompilerForBuild
      )
!

buildDirectory
    buildDirectory isNil ifTrue:[
        buildDirectory := ValueHolder new.
        buildDirectory onChangeSend:#updateModifiedChannel to:self
    ].
    ^ buildDirectory.
!

hasSourceCodeManager
    ^ SourceCodeManager notNil
!

listOfPossibleCompilers
    ^ Tools::ProjectBuilder listOfPossibleCompilers

    "Created: / 21-01-2012 / 14:05:43 / cg"
!

localBuild
    localBuild isNil ifTrue:[
        localBuild := UserPreferences current localBuild asValue.
        localBuild onChangeSend:#updateModifiedChannel to:self
    ].
    ^ localBuild.
!

usedCompilerForBuild
    usedCompilerForBuild isNil ifTrue:[
        usedCompilerForBuild := nil asValue.
        usedCompilerForBuild onChangeSend:#updateModifiedChannel to:self
    ].
    ^ usedCompilerForBuild.

    "Created: / 22-01-2012 / 10:59:30 / cg"
! !

!AbstractSettingsApplication::BuildSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/buildSetup.html'
! !

!AbstractSettingsApplication::BuildSettingsAppl methodsFor:'initialization'!

postBuildDirectoryField:aField
    aField historyList value:(Array
        with:(OperatingSystem getHomeDirectory asFilename construct:'stx_build') pathName
        with:(Filename currentDirectory construct:'stx_build') pathName)
! !

!AbstractSettingsApplication::BuildSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    (super hasUnsavedChanges) ifTrue:[^ true].
    ^ false

    "Modified: / 22-01-2012 / 10:50:15 / cg"
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl class methodsFor:'defaults'!

constantFoldingOptions

    ^ #( nil #level1 #level2 #full )
!

constantFoldingStrings

    ^ #('disabled' 'level1 (always safe)' 'level2 (usually safe)' 'full')
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl class methodsFor:'documentation'!

documentation
"
    I manage settings for bytecode compilation.
    Mostly controlling accepted syntax, warnings and errors.
"
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ByteCodeCompilerSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom: self helpPairs
!

helpPairs
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ByteCodeCompilerSettingsAppl
    "

    <resource: #help>

    ^ #(

#arraysAreImmutable
'Array and ByteArray literals are readonly objects, which cannot be modified.
Prevents constant arrays as returned from a method to be modified elsewhere by accident'

#fullDebugInfo
'Include more debug support in the generated code.
Especially restartability and returnability of methods in the debugger are improved'

#stringsAreImmutable
'String literals are readonly objects, which cannot be modified.
Prevents constant strings as returned from a method to be modified elsewhere by accident'

#allowAssignmentToPoolVariable
'Pool variables should only be initialized in the pool itself and not modified elsewhere later.\This flag makes pool variables writable.\May be required to fileIn code from Squeak and other Smalltalk dialects'

#allowDollarInIdentifier
'Check this to allow dollar characters in identifiers.\This may be required to filein old code for VAX Smalltalk,\but is not compatible to most other Smalltalk dialects.'

#allowParagraphInIdentifier
'Check this to allow paragraph characters in identifiers.\This is not compatible to other Smalltalk dialects.'

#allowDolphinExtensions
'Allow Dolphin-Smalltalk specific syntax extensions'

#allowEmptyStatements
'Allow empty statements'

#allowExtendedBinarySelectors
'Allow extended binary selectors (more than 2 characters, including "^", "|" and "#")'

#allowFixedPointLiterals
'Allow <v>s<n> fixed point literals (scaled or fixed-point decimal v with n digits precision)'

#allowOldStyleAssignment
'Allow "_" as assignment. May be required to filein Squeak code'

#allowQualifiedNames
'Allow Visualworks qualified names.\This enables ''dot''-notation for namespace prefixes and the {..} qualified name syntax.\May be required to filein Visualworks code'

#allowReservedWordsAsSelectors
'Allow "self", "super" as selectors. May be required to filein code from other Smalltalk dialects'

#allowSqueakExtensions
'Allow some Squeak extensions (primitive spec after locals, brace array construction, C style arguments'

#allowUnderscoreInIdentifier
'Allow underscore characters in identifiers. Not compatible with Squeak.'

#allowVisualAgeESSymbolLiterals
'Allow VisualAge ESsymbol literals (##xxx).\Will generate regular symbols when compiled'

#allowVisualAgePrimitives
'Allow VisualAge primitive specification syntax'
"/
"/#warnAboutPossibleSTCCompilationProblems
"/''
"/
#warnAboutPossiblyUnimplementedSelectors
'Warn about a possibly unimplemented selector in a message send'

#warnAboutReferenceToPrivateClass
'Warn when another classes private class is referenced.\This is considered "bad style" and should be replaced by a getter-call to the owning class or the privae class be made public'

#warnDollarInIdentifier
'Warn if an identifier contains a dollar character.\This is not allowed in most other Smalltalk dialects.'

#warnParagraphInIdentifier
'Warn if an identifier contains a paragraph character.\This is not allowed in other Smalltalk dialects.'

#warnOldStyleAssignment
'Warn if an old style assignment ("_" character) is used instead of the modern ":=".'

#warnPlausibilityChecks
'Perform plausibility checks and warn about any such possible problem'

#warnPossibleIncompatibilities
'Warn about other possible incompatibilities'
"/
#warnSTXSpecials
'Warn when ST/X special syntax is encountered.\Such constructs may be unportable to other Smalltalk dialects'
"/
#warnUnderscoreInIdentifier
'Warn if an identifier contains an underline character.\This is not allowed in some old Smalltalk dialects.'

#warnCommonMistakes
'Warn about code which is likely to be mistaken, based on heuristics'

#warnInconsistentReturnValues
'Warn if a method returns both boolean and non-boolean values (usually a ^self)'

#warnAboutMissingMethodComment
'Warn if a method has no comment'

#warnAboutBadComments
'Warn if a comment is empty or consists of whitespace only'

#warnAboutShortLocalVariableNames
'Warn if a variable''s name is too short to be descriptive'

#warnAboutNonLowercaseLocalVariableNames
'By convention, local variables should start with a lowercase character'

#warnAboutWrongVariableNames
'Checks for bad articles in variable names (eg. "anUser")'

#warnUnusedVars
'Warn if a local variable is never used'

#warnings
'Turn off all warnings'

)

    "Modified: / 16-11-2016 / 22:59:16 / cg"
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon5

    "Modified: / 17-09-2007 / 11:35:05 / cg"
!

defaultIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::ByteCodeCompilerSettingsAppl defaultIcon1'
        ifAbsentPut:[(Depth2Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@C??????@CUUUUUW@CZ(J@B''@CZ""(*''CCZ"*(*''@CV(J(*WKCV*"(*W@CU""()WJCU(J()W@CUZ**%W@CUZ**%WACUPJ(EW@CUR""QWDCUQ"!!UWI
CUPJ!!UWICUQR!!UWJCUQR!!QWACUPFTEW@CUUUUUW@C??????@@@@@@@@B') colorMapFromArray:#[0 0 0 255 255 255 255 189 23 127 127 127] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8@@@@'); yourself); yourself]
!

defaultIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::ByteCodeCompilerSettingsAppl defaultIcon2'
        ifAbsentPut:[(Depth4Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HP@CL3L3L3L3L0@RHP@@@3L3L3L0@0@RY!!@AHCL3L3LBD@E&Y&DVPCL3
L3LDXQY&Y&Y"@3L3L3L0I&Y&IBY!!@3L3L3L0E&IB@DI&D@L3L3@AY"P@UPQ&XQ@3L0DVY$AUUPI&YD@3L0QFY"AU@AY"H@L3L3@BI&D@DVY"@@L3L3L@I&XQ
Y&Y!!@@@3L3@@E&Y&Y&IFD@@3L3@AYBY&Y!!@DH@@CL0@BP@E&PP@@@@@CL0@@@@@TPP@@@@@@L@@@@@@T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 0 0 255 255 255 161 161 165 255 189 23 127 127 127 236 233 216 194 194 194] mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@0@@C9??79??7?????????????????????????????????''=??#9??3;??13?9!!1''8@ G0@@C@@@@@@@@@@@@'); yourself); yourself]
!

defaultIcon5
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon5 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon5
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::ByteCodeCompilerSettingsAppl defaultIcon5'
        ifAbsentPut:[(Depth4Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AH@@@@@@@@@@@@@@AH@@@@@@@@@@@HP@UTP@R@@@@@@@@MQEU
UQES@@@@@@@@@%UUUUT @@@@@@@@@UT#H%TP@@@@@@@@EUH0@2UQ@@@@@@@QUULDPCUUDP@@@@@3UUHDPBUUL0@@@@@@H%TP@UT"@@@@@@@@@%UQEUT @@@@
@@@@@UUUUUTP@@@@@@@@ESIUURMQ@@@@@@@@H0@UTP@2@@@@@@@@@@@AL@@@@@@@@@@@@@@AL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 0 0 255 255 255 161 161 165 127 127 127 236 233 216 194 194 194] mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@A @@C0@@33@A?? A?? @??@@??@C??0G??8G??8C??0@??@@??@A?? A?? @33@@C0@O5+<HT*DHTJDO7;<'); yourself); yourself]
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ByteCodeCompilerSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::ByteCodeCompilerSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::ByteCodeCompilerSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Byte Code Compiler Settings'
         name: 'Byte Code Compiler Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 665 706)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Just in Time Compilation to Machine Code'
                   name: 'JustInTimeCompilation'
                   model: justInTimeCompilation
                   translateLabel: true
                   extent: (Point 665 25)
                 )
                (DividerSpec
                   name: 'Separator3'
                   extent: (Point 665 3)
                 )
                (ViewSpec
                   name: 'Box1'
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel1_1'
                         layout: (LayoutFrame 0 0 0 0 -20 0.5 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 0
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Allow Underscore in Identifiers'
                               name: 'AllowUnderscoreInIdentifiers'
                               activeHelpKey: allowUnderscoreInIdentifier
                               model: allowUnderscoreInIdentifier
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow Dollar in Identifiers ($)'
                               name: 'AllowDollarInIdentifiers'
                               activeHelpKey: allowDollarInIdentifier
                               model: allowDollarInIdentifier
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow VW3 QualifiedNames'
                               name: 'AllowVW3QualifiedNames'
                               activeHelpKey: allowQualifiedNames
                               model: allowQualifiedNames
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow OldStyle Assignment (_)'
                               name: 'AllowOldStyleAssignment'
                               activeHelpKey: allowOldStyleAssignment
                               model: allowOldStyleAssignment
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow Reserved Words as Selector (self)'
                               name: 'AllowReservedWordsAsSelector'
                               activeHelpKey: allowReservedWordsAsSelectors
                               model: allowReservedWordsAsSelectors
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow Extended Binary Selectors'
                               name: 'CheckBox4'
                               activeHelpKey: allowExtendedBinarySelectors
                               model: allowExtendedBinarySelectors
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow Assignment to Pool Variable'
                               name: 'CheckBox6'
                               activeHelpKey: allowAssignmentToPoolVariable
                               model: allowAssignmentToPoolVariable
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            )

                         )
                       )
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel1_2'
                         layout: (LayoutFrame 0 0.5 0 0 0 1 0 1)
                         horizontalLayout: left
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 0
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Allow Squeak Extensions'
                               name: 'AllowSqueakExtensions'
                               activeHelpKey: allowSqueakExtensions
                               model: allowSqueakExtensions
                               translateLabel: true
                               extent: (Point 665 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow Dolphin Extensions'
                               name: 'AllowDolphinExtensions'
                               activeHelpKey: allowDolphinExtensions
                               model: allowDolphinExtensions
                               translateLabel: true
                               extent: (Point 665 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow VisualAge ES-Symbols'
                               name: 'AllowVisualAgeESSymbolLiterals'
                               activeHelpKey: allowVisualAgeESSymbolLiterals
                               model: allowVisualAgeESSymbolLiterals
                               translateLabel: true
                               extent: (Point 665 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow VisualAge Primitives'
                               name: 'CheckBox8'
                               activeHelpKey: allowVisualAgePrimitives
                               model: allowVisualAgePrimitives
                               translateLabel: true
                               extent: (Point 665 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow FixedPoint-Number Literals'
                               name: 'AllowFixedPointLiterals'
                               activeHelpKey: allowFixedPointLiterals
                               model: allowFixedPointLiterals
                               translateLabel: true
                               extent: (Point 665 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow Empty Statements'
                               name: 'AllowEmptyStatements'
                               activeHelpKey: allowEmptyStatements
                               model: allowEmptyStatements
                               translateLabel: true
                               extent: (Point 665 22)
                             )
                            (CheckBoxSpec
                               label: 'Allow Paragraph in Identifiers ()'
                               name: 'CheckBox10'
                               activeHelpKey: allowParagraphInIdentifier
                               model: allowParagraphInIdentifier
                               translateLabel: true
                               extent: (Point 665 22)
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 665 157)
                 )
                (DividerSpec
                   name: 'Separator4'
                   extent: (Point 665 1)
                 )
                (CheckBoxSpec
                   label: 'Warnings'
                   name: 'Warnings'
                   activeHelpKey: warnings
                   model: warnings
                   translateLabel: true
                   extent: (Point 665 22)
                 )
                (ViewSpec
                   name: 'Box2'
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel2_1'
                         layout: (LayoutFrame 20 0 0 0 0 0.5 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 0
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'ST/X Extensions'
                               name: 'STXExtensions'
                               activeHelpKey: warnSTXSpecials
                               enableChannel: warnings
                               model: warnSTXSpecials
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Reference to Private Class'
                               name: 'CheckBox1'
                               activeHelpKey: warnAboutReferenceToPrivateClass
                               enableChannel: warnings
                               model: warnAboutReferenceToPrivateClass
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Underscores in Identifiers'
                               name: 'UnderscoresInIdentifiers'
                               activeHelpKey: warnUnderscoreInIdentifier
                               enableChannel: enableUnderscore
                               model: warnUnderscoreInIdentifier
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Dollars in Identifiers'
                               name: 'DollarsInIdentifiers'
                               activeHelpKey: warnDollarInIdentifier
                               enableChannel: enableDollar
                               model: warnDollarInIdentifier
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'OldStyle Assignment'
                               name: 'OldStyleAssignment'
                               activeHelpKey: warnOldStyleAssignment
                               enableChannel: warnings
                               model: warnOldStyleAssignment
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Possible Incompatibilities'
                               name: 'PossibleIncompatibilities'
                               activeHelpKey: warnPossibleIncompatibilities
                               enableChannel: warnings
                               model: warnPossibleIncompatibilities
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Possible STC Compilation Problems'
                               name: 'PossibleSTCCompilationProblems'
                               activeHelpKey: warnAboutPossibleSTCCompilationProblems
                               enableChannel: warnings
                               model: warnAboutPossibleSTCCompilationProblems
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Possibly Unimplemented Selectors'
                               name: 'CheckBox3'
                               activeHelpKey: warnAboutPossiblyUnimplementedSelectors
                               enableChannel: warnings
                               model: warnAboutPossiblyUnimplementedSelectors
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            (CheckBoxSpec
                               label: 'Plausibility Checks'
                               name: 'CheckBox7'
                               activeHelpKey: warnPlausibilityChecks
                               enableChannel: warnings
                               model: warnPlausibilityChecks
                               translateLabel: true
                               extent: (Point 313 22)
                             )
                            )

                         )
                       )
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel2_2'
                         layout: (LayoutFrame -1 0.5 0 0 0 1 0 1)
                         horizontalLayout: left
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 0
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Unused Method Variables'
                               name: 'UnusedMethodVariables'
                               enableChannel: warnings
                               model: warnUnusedVars
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnUnusedVars
                             )
                            (CheckBoxSpec
                               label: 'Bad Variable Names (non-English article)'
                               name: 'BadVariableNames'
                               enableChannel: warnings
                               model: warnAboutWrongVariableNames
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnAboutWrongVariableNames
                             )
                            (CheckBoxSpec
                               label: 'Bad (Non-Lowercase) Local Variable Names'
                               name: 'BadLocalVariableNames'
                               enableChannel: warnings
                               model: warnAboutNonLowercaseLocalVariableNames
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnAboutNonLowercaseLocalVariableNames
                             )
                            (CheckBoxSpec
                               label: 'Bad (Short) Local Variable Names'
                               name: 'CheckBox2'
                               enableChannel: warnings
                               model: warnAboutShortLocalVariableNames
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnAboutShortLocalVariableNames
                             )
                            (CheckBoxSpec
                               label: 'Bad (empty) Comments'
                               name: 'BadComments'
                               enableChannel: warnings
                               model: warnAboutBadComments
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnAboutBadComments
                             )
                            (CheckBoxSpec
                               label: 'Method-Comment Missing '
                               name: 'CheckBox5'
                               enableChannel: warnings
                               model: warnAboutMissingMethodComment
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnAboutMissingMethodComment
                             )
                            (CheckBoxSpec
                               label: 'Inconsistent Return Values'
                               name: 'InconsistentReturnValues'
                               enableChannel: warnings
                               model: warnInconsistentReturnValues
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnInconsistentReturnValues
                             )
                            (CheckBoxSpec
                               label: 'Common Mistakes'
                               name: 'CommonMistakes'
                               enableChannel: warnings
                               model: warnCommonMistakes
                               translateLabel: true
                               extent: (Point 600 22)
                               activeHelpKey: warnCommonMistakes
                             )
                            (CheckBoxSpec
                               label: 'Paragraph in Identifier'
                               name: 'CheckBox11'
                               enableChannel: enableParagraph
                               model: warnParagraphInIdentifier
                               activeHelpKey: warnParagraphInIdentifier
                               translateLabel: true
                               extent: (Point 600 22)
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 665 206)
                 )
                (ViewSpec
                   name: 'Box4'
                   component:
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Reenable Suppressed Warnings Now'
                         name: 'Button1'
                         layout: (LayoutOrigin 0 0.5 0 0)
                         translateLabel: true
                         model: reenableSuppressedWarnings
                       )
                      )

                   )
                   extent: (Point 665 32)
                 )
                (DividerSpec
                   name: 'Separator5'
                   extent: (Point 665 2)
                 )
                (CheckBoxSpec
                   label: 'Literal Strings are Immutable'
                   name: 'LiteralStringsAreImmutable'
                   activeHelpKey: stringsAreImmutable
                   model: stringsAreImmutable
                   translateLabel: true
                   extent: (Point 665 22)
                 )
                (CheckBoxSpec
                   label: 'Literal Arrays are Immutable'
                   name: 'CheckBox9'
                   activeHelpKey: arraysAreImmutable
                   model: arraysAreImmutable
                   translateLabel: true
                   extent: (Point 665 22)
                 )
                (CheckBoxSpec
                   label: 'Full Debug Info'
                   name: 'FullDebugInfo'
                   activeHelpKey: fullDebugInfo
                   model: fullDebugSupport
                   translateLabel: true
                   extent: (Point 665 22)
                 )
                (DividerSpec
                   name: 'Separator6'
                   extent: (Point 665 2)
                 )
                (ViewSpec
                   name: 'Box3'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Constant Folding:'
                         name: 'ConstantFoldingLabel'
                         layout: (LayoutFrame 0 0 0 0 328 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (PopUpListSpec
                         label: 'PopUp List'
                         name: 'ConstantFolding'
                         layout: (LayoutFrame 330 0 0 0 -5 1 22 0)
                         translateLabel: true
                         tabable: true
                         model: constantFoldingSelection
                         menu: constantFolding
                         useIndex: true
                       )
                      )

                   )
                   extent: (Point 665 22)
                 )
                )

             )
           )
          )

       )
     )

    "Modified: / 16-11-2016 / 22:52:00 / cg"
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl methodsFor:'actions'!

basicReadSettings
    self
        readAspects:(self simpleAspects)
        from:ParserFlags.

    self constantFoldingSelection
        value:(self class constantFoldingOptions indexOf:Compiler foldConstants ifAbsent:3).

    self supportsJustInTimeCompilation ifTrue:[
        self fullDebugSupport value:(ObjectMemory fullSingleStepSupport ? false)
    ] ifFalse:[
        self fullDebugSupport value:(ParserFlags fullLineNumberInfo)
    ].

    self supportsJustInTimeCompilation ifTrue:[
        self justInTimeCompilation value:(ObjectMemory justInTimeCompilation ? false)
    ] ifFalse:[
        self justInTimeCompilation value:false
    ].

    self warnAboutMissingMethodComment value:(UserPreferences current enforceComment).

    "Modified: / 26-09-2012 / 14:16:32 / cg"
!

basicSaveSettings
    self
        writeAspects:(self simpleAspects)
        to:ParserFlags.

    ParserFlags lineNumberInfo:(self fullDebugSupport value ifTrue:[#full] ifFalse:[true]).

    Compiler foldConstants:(self class constantFoldingOptions at:self constantFoldingSelection value).

    self supportsJustInTimeCompilation ifTrue:[
        | justInTime |
        justInTime := self justInTimeCompilation value.
        justInTime ifTrue:[
            Smalltalk allMethodsDo:[:m | m checked:false].
        ].
        ObjectMemory justInTimeCompilation:justInTime.
        ObjectMemory fullSingleStepSupport:self fullDebugSupport value.
    ].

    UserPreferences current enforceComment:(self warnAboutMissingMethodComment value).

    "Modified: / 26-09-2012 / 13:32:34 / cg"
!

reenableSuppressedWarnings
    ParserFlags reenableAllSuppressedFlags

    "Created: / 28-02-2012 / 13:32:52 / cg"
!

simpleAspects
    ^
            #(
                warnings
                warnCommonMistakes
                warnPossibleIncompatibilities
                warnDollarInIdentifier
                warnParagraphInIdentifier
                warnOldStyleAssignment
                warnSTXSpecials
                warnUnderscoreInIdentifier
                warnUnusedVars
                warnAboutWrongVariableNames
                warnAboutBadComments
                warnInconsistentReturnValues
                warnAboutNonLowercaseLocalVariableNames
                warnAboutShortLocalVariableNames
                warnAboutPossibleSTCCompilationProblems
                warnAboutReferenceToPrivateClass
                warnAboutPossiblyUnimplementedSelectors
                warnPlausibilityChecks

                allowDollarInIdentifier
                allowParagraphInIdentifier
                allowDolphinExtensions
                allowOldStyleAssignment
                allowQualifiedNames
                allowReservedWordsAsSelectors
                allowSqueakExtensions
                allowUnderscoreInIdentifier
                allowVisualAgeESSymbolLiterals
                allowVisualAgePrimitives
                allowFixedPointLiterals
                allowEmptyStatements
                allowExtendedBinarySelectors

                arraysAreImmutable
                stringsAreImmutable
                allowAssignmentToPoolVariable
            )

    "Created: / 20-11-2006 / 22:37:17 / cg"
    "Modified: / 16-11-2016 / 22:40:51 / cg"
!

stcCompilerSettings

    AbstractLauncherApplication::LauncherDialogs stcCompilerSettings
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl methodsFor:'aspects'!

allowAssignmentToPoolVariable

    allowAssignmentToPoolVariable isNil ifTrue:[
        allowAssignmentToPoolVariable := ParserFlags allowAssignmentToPoolVariable asValue.
        allowAssignmentToPoolVariable onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowAssignmentToPoolVariable.

    "Created: / 12-09-2011 / 17:26:01 / cg"
!

allowDollarInIdentifier

    allowDollar isNil ifTrue:[
        allowDollar := ParserFlags allowDollarInIdentifier asValue.
        allowDollar onChangeSend:#updateModifiedChannel to:self.
        allowDollar addDependent:self.
    ].
    ^ allowDollar.
!

allowDolphinExtensions

    allowDolphinExtensions isNil ifTrue:[
        allowDolphinExtensions := ParserFlags allowDolphinExtensions asValue.
        allowDolphinExtensions onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowDolphinExtensions.
!

allowEmptyStatements

    allowEmptyStatements isNil ifTrue:[
        allowEmptyStatements := ParserFlags allowEmptyStatements asValue.
        allowEmptyStatements onChangeSend:#updateModifiedChannel to:self.
        "/ allowEmptyStatements addDependent:self.
    ].
    ^ allowEmptyStatements.

    "Created: / 20-11-2006 / 22:35:10 / cg"
!

allowExtendedBinarySelectors

    allowExtendedBinarySelectors isNil ifTrue:[
        allowExtendedBinarySelectors := (ParserFlags allowExtendedBinarySelectors ? false) asValue.
        allowExtendedBinarySelectors onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowExtendedBinarySelectors.
!

allowFixedPointLiterals

    allowFixedPointLiterals isNil ifTrue:[
        allowFixedPointLiterals := (ParserFlags allowFixedPointLiterals ? false) asValue.
        allowFixedPointLiterals onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowFixedPointLiterals.
!

allowOldStyleAssignment

    allowOldStyleAssignment isNil ifTrue:[
        allowOldStyleAssignment := ParserFlags allowOldStyleAssignment asValue.
        allowOldStyleAssignment onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowOldStyleAssignment.
!

allowParagraphInIdentifier

    allowParagraph isNil ifTrue:[
        allowParagraph := ParserFlags allowParagraphInIdentifier asValue.
        allowParagraph onChangeSend:#updateModifiedChannel to:self.
        allowParagraph addDependent:self.
    ].
    ^ allowParagraph.

    "Created: / 16-11-2016 / 22:38:18 / cg"
!

allowQualifiedNames

    allowQualifiedNames isNil ifTrue:[
        allowQualifiedNames := ParserFlags allowQualifiedNames asValue.
        allowQualifiedNames onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowQualifiedNames.
!

allowReservedWordsAsSelectors

    allowReservedWordsAsSelectors isNil ifTrue:[
        allowReservedWordsAsSelectors := ParserFlags allowReservedWordsAsSelectors asValue.
        allowReservedWordsAsSelectors onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowReservedWordsAsSelectors.
!

allowSqueakExtensions

    allowSqueakExtensions isNil ifTrue:[
        allowSqueakExtensions := ParserFlags allowSqueakExtensions asValue.
        allowSqueakExtensions onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowSqueakExtensions.
!

allowUnderscoreInIdentifier

    allowUnderscore isNil ifTrue:[
        allowUnderscore := ParserFlags allowUnderscoreInIdentifier asValue.
        allowUnderscore onChangeSend:#updateModifiedChannel to:self.
        allowUnderscore addDependent:self.
    ].
    ^ allowUnderscore.
!

allowVisualAgeESSymbolLiterals

    allowVisualAgeESSymbolLiterals isNil ifTrue:[
        allowVisualAgeESSymbolLiterals := ParserFlags allowVisualAgeESSymbolLiterals asValue.
        allowVisualAgeESSymbolLiterals onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowVisualAgeESSymbolLiterals.
!

allowVisualAgePrimitives

    allowVisualAgePrimitives isNil ifTrue:[
        allowVisualAgePrimitives := ParserFlags allowVisualAgePrimitives asValue.
        allowVisualAgePrimitives onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ allowVisualAgePrimitives.

    "Created: / 07-02-2012 / 17:06:19 / cg"
!

arraysAreImmutable

    immutableArrays isNil ifTrue:[
        immutableArrays := ParserFlags arraysAreImmutable asValue.
        immutableArrays onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ immutableArrays.
!

constantFolding

    constantFolding isNil ifTrue:[
        constantFolding := (resources array:(self class constantFoldingStrings)) asList.
    ].
    ^ constantFolding.
!

constantFoldingOptions

    constantFoldingOptions isNil ifTrue:[
        constantFoldingOptions := self class constantFoldingOptions.
    ].
    ^ constantFoldingOptions.
!

constantFoldingSelection

    constantFoldingSelection isNil ifTrue:[
        | index |
        index := self class constantFoldingOptions indexOf:Compiler foldConstants ifAbsent:3.
        constantFoldingSelection := index asValue.
        constantFoldingSelection onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ constantFoldingSelection.
!

enableDollar

    enableDollar isNil ifTrue:[
        enableDollar := true asValue.
        enableDollar addDependent:self.
    ].
    ^ enableDollar.
!

enableParagraph

    enableParagraph isNil ifTrue:[
        enableParagraph := true asValue.
        enableParagraph addDependent:self.
    ].
    ^ enableParagraph.

    "Created: / 16-11-2016 / 22:39:57 / cg"
!

enableUnderscore
    enableUnderscore isNil ifTrue:[
        enableUnderscore := true asValue.
    ].
    ^ enableUnderscore.
!

fullDebugSupport

    fullDebugSupport isNil ifTrue:[
        self supportsJustInTimeCompilation ifTrue:[
            fullDebugSupport := (ObjectMemory fullSingleStepSupport ? false) asValue.
        ] ifFalse:[
            fullDebugSupport := (ParserFlags fullLineNumberInfo) asValue.
        ].
        fullDebugSupport onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ fullDebugSupport.

    "Modified: / 26-09-2012 / 14:16:27 / cg"
!

justInTimeCompilation

    justInTimeCompilation isNil ifTrue:[
        self supportsJustInTimeCompilation ifTrue:[
            justInTimeCompilation := (ObjectMemory justInTimeCompilation ? false) asValue.
        ] ifFalse:[
            justInTimeCompilation := false asValue.
        ].
        justInTimeCompilation onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ justInTimeCompilation.
!

stringsAreImmutable

    immutableStrings isNil ifTrue:[
        immutableStrings := ParserFlags arraysAreImmutable asValue.
        immutableStrings onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ immutableStrings.
!

warnAboutBadComments
    warnAboutBadComments isNil ifTrue:[
        warnAboutBadComments := ParserFlags warnAboutBadComments asValue.
        warnAboutBadComments onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutBadComments.
!

warnAboutMissingMethodComment

    warnAboutMissingMethodComment isNil ifTrue:[
        warnAboutMissingMethodComment := UserPreferences current enforceComment asValue.
        warnAboutMissingMethodComment onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutMissingMethodComment.

    "Created: / 17-07-2010 / 14:39:25 / cg"
!

warnAboutNonLowercaseLocalVariableNames
    warnAboutNonLowercaseLocalVariableNames isNil ifTrue:[
        warnAboutNonLowercaseLocalVariableNames := ParserFlags warnAboutNonLowercaseLocalVariableNames asValue.
        warnAboutNonLowercaseLocalVariableNames onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutNonLowercaseLocalVariableNames.

    "Modified: / 22-10-2006 / 02:30:57 / cg"
!

warnAboutPossibleSTCCompilationProblems

    warnAboutPossibleSTCCompilationProblems isNil ifTrue:[
        warnAboutPossibleSTCCompilationProblems := ParserFlags warnAboutPossibleSTCCompilationProblems asValue.
        warnAboutPossibleSTCCompilationProblems onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutPossibleSTCCompilationProblems.

    "Created: / 20-11-2006 / 22:41:07 / cg"
!

warnAboutPossiblyUnimplementedSelectors

    warnAboutPossiblyUnimplementedSelectors isNil ifTrue:[
        warnAboutPossiblyUnimplementedSelectors := ParserFlags warnAboutPossiblyUnimplementedSelectors asValue.
        warnAboutPossiblyUnimplementedSelectors onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutPossiblyUnimplementedSelectors.

    "Created: / 20-11-2006 / 22:41:07 / cg"
!

warnAboutReferenceToPrivateClass
    warnAboutReferenceToPrivateClass isNil ifTrue:[
        warnAboutReferenceToPrivateClass := ParserFlags warnAboutReferenceToPrivateClass asValue.
        warnAboutReferenceToPrivateClass onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutReferenceToPrivateClass.
!

warnAboutShortLocalVariableNames
    warnAboutShortLocalVariableNames isNil ifTrue:[
        warnAboutShortLocalVariableNames := ParserFlags warnAboutShortLocalVariableNames asValue.
        warnAboutShortLocalVariableNames onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutShortLocalVariableNames.
!

warnAboutWrongVariableNames
    warnAboutWrongVariableNames isNil ifTrue:[
        warnAboutWrongVariableNames := ParserFlags warnAboutWrongVariableNames asValue.
        warnAboutWrongVariableNames onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnAboutWrongVariableNames.
!

warnCommonMistakes

    warnCommonMistakes isNil ifTrue:[
        warnCommonMistakes := ParserFlags warnCommonMistakes asValue.
        warnCommonMistakes onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnCommonMistakes.
!

warnDollarInIdentifier

    warnDollar isNil ifTrue:[
        warnDollar := ParserFlags warnDollarInIdentifier asValue.
        warnDollar onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnDollar.
!

warnInconsistentReturnValues
    warnInconsistentReturnValues isNil ifTrue:[
        warnInconsistentReturnValues := ParserFlags warnInconsistentReturnValues asValue.
        warnInconsistentReturnValues onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnInconsistentReturnValues.
!

warnOldStyleAssignment

    warnOldStyle isNil ifTrue:[
        warnOldStyle := ParserFlags warnOldStyleAssignment asValue.
        warnOldStyle onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnOldStyle.
!

warnPlausibilityChecks

    warnPlausibilityChecks isNil ifTrue:[
        warnPlausibilityChecks := ParserFlags warnPlausibilityChecks asValue.
        warnPlausibilityChecks onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnPlausibilityChecks.

    "Created: / 19-01-2012 / 10:57:29 / cg"
!

warnPossibleIncompatibilities
    "holds true, if possible incompatibilities (with other ST systems)
     are to be warned about"

    warnCompatibility isNil ifTrue:[
        warnCompatibility := ParserFlags warnPossibleIncompatibilities asValue.
        warnCompatibility onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnCompatibility.
!

warnSTXSpecials

    warnSTX isNil ifTrue:[
        warnSTX := ParserFlags warnSTXSpecials asValue.
        warnSTX onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnSTX.
!

warnUnderscoreInIdentifier

    warnUnderscore isNil ifTrue:[
        warnUnderscore := ParserFlags warnUnderscoreInIdentifier asValue.
        warnUnderscore onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnUnderscore.
!

warnUnusedVars

    warnUnusedVars isNil ifTrue:[
        warnUnusedVars := ParserFlags warnUnusedVars asValue.
        warnUnusedVars onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnUnusedVars.
!

warnings

    warnings isNil ifTrue:[
        warnings := ParserFlags warnings asValue.
        warnings addDependent:self.
        warnings changed.
        warnings onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ warnings.
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == self warnings ifTrue:[
        changedObject value ifTrue:[
            self enableUnderscore value:self allowUnderscoreInIdentifier value.
            self enableDollar value:self allowDollarInIdentifier value.
            self enableParagraph value:self allowParagraphInIdentifier value.
        ] ifFalse:[
            self enableUnderscore value:false.
            self enableDollar value:false.
            self enableParagraph value:false.
        ].
        ^ self
    ].
    (changedObject == self allowDollarInIdentifier
    or:[changedObject == self allowParagraphInIdentifier
    or:[changedObject == self allowUnderscoreInIdentifier]]) ifTrue:[
        self warnings changed.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 16-11-2016 / 22:39:32 / cg"
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/compilerSettings.html'
! !

!AbstractSettingsApplication::ByteCodeCompilerSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    (self
        hasChangedAspectIn:(self simpleAspects)
        asComparedTo:ParserFlags) ifTrue:[^ true].

    ((self supportsJustInTimeCompilation value ifTrue:[ObjectMemory fullSingleStepSupport ? false] ifFalse:[ParserFlags fullLineNumberInfo]) ~= self fullDebugSupport value) ifTrue:[^ true].
    ((Compiler foldConstants) ~= (self class constantFoldingOptions at:self constantFoldingSelection value)) ifTrue:[^ true].
    ((ObjectMemory justInTimeCompilation ? false) ~= self justInTimeCompilation value) ifTrue:[^ true].

    (UserPreferences current enforceComment ~= self warnAboutMissingMethodComment value) ifTrue:[^ true].

    ^ false

    "Modified: / 26-09-2012 / 14:16:14 / cg"
!

supportsJustInTimeCompilation

    ^ ObjectMemory supportsJustInTimeCompilation
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl class methodsFor:'documentation'!

documentation
"
    I manage where the change file is to be stored and what is to be written into it
"
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::DebuggerSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#changeFileName
'The name of the file in which changes are recorded (for the Changebrowser)'

#logDoits
'Also record doIt evaluations in the change file'

#updChanges
'Record code changes (classes and methods) in the change file'

)
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::ChangeFileSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@ADQDQDQDQDQD @@DTQDQDQDQDQBD@@QP3MDQDQDQDHP@AECQDQDQDQDP!!@@DTMDQDQDQDQBD@@QP3MDP3QDQDHP@AEDQDP3L4QDP!!@@DT
QDP3QCMDQBD@@QQDP3QDP3QDHP@AEDP3QDQDL4P!!@@DTP3QDQDQCMBD@@QQCL3L3L3L4@P@AEDDQDQDQDQPA@@DTQDQDQDQDQ@D@@QP3MDQDQDQD@P@AEDP4
QDQDQDPA@@DTQCQDQDQDQ@D@@QP3MDQDQDQD@P@AEDQDQDQDQDPA@@D @@@@@@@@@@D@@ADQDQDQDQDQDP@b') ; colorMapFromArray:#[0 0 0 208 208 208 48 48 48 160 160 160 240 240 240]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@_?? _??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0O??0') ; yourself); yourself]
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ChangeFileSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::ChangeFileSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::ChangeFileSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Changes Settings'
         name: 'Changes Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 561 478)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fitSpace
             verticalLayout: topSpace
             horizontalSpace: 5
             verticalSpace: 5
             component:
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Change File'
                   name: 'FramedBox2'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Log changed classes and methods in the Changefile'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 5 0 5 0 -5 1 35 0)
                         activeHelpKey: updChanges
                         model: updChanges
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Log doIts in the Changefile'
                         name: 'CheckBox2'
                         layout: (LayoutFrame 5 0 35 0 -5 1 65 0)
                         activeHelpKey: logDoits
                         model: logDoits
                         translateLabel: true
                       )
                      (ViewSpec
                         name: 'Box1'
                         layout: (LayoutFrame 5 0 73 0 -5 1 105 0)
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Changefile Name:'
                               name: 'ChangefileNameLabel'
                               layout: (LayoutFrame 21 0 0 0 236 0 30 0)
                               activeHelpKey: changeFileName
                               translateLabel: true
                               adjust: right
                             )
                            (FilenameInputFieldSpec
                               name: 'FilenameEntryField1'
                               layout: (LayoutFrame 237 0 0 0 0 1 30 0)
                               activeHelpKey: changeFileName
                               model: changeFileName
                               immediateAccept: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: true
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 551 147)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl methodsFor:'actions'!

basicReadSettings
    self changeFileName value:(currentUserPrefs changeFileName
                               ? ObjectMemory nameForChanges).
    self logDoits value:Smalltalk logDoits.
    self updChanges value:Class updatingChanges.

    "Modified: / 27-10-2010 / 10:16:48 / cg"
!

basicSaveSettings
    |chgFile|

    chgFile := self changeFileName value.
    chgFile := chgFile asNilIfEmpty.
    currentUserPrefs changeFileName isNil ifTrue:[
        "/ had the default
        chgFile = ObjectMemory nameForChanges ifFalse:[
            ObjectMemory nameForChanges:chgFile.
            currentUserPrefs changeFileName:chgFile
        ]
    ] ifFalse:[
        "/ had a value before
        chgFile = currentUserPrefs changeFileName ifFalse:[
            ObjectMemory nameForChanges:chgFile.
            currentUserPrefs changeFileName:chgFile
        ].
    ].
    Smalltalk logDoits:self logDoits value.
    Class updateChanges:self updChanges value.

    "Modified: / 09-02-2011 / 20:32:47 / cg"
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl methodsFor:'aspects'!

changeFileName
    changeFileName isNil ifTrue:[
        changeFileName := ObjectMemory nameForChanges asValue.
        changeFileName onChangeSend:#updateModifiedChannel to:self
    ].
    ^ changeFileName.

    "Modified (format): / 25-11-2011 / 15:43:37 / cg"
!

logDoits
    logDoits isNil ifTrue:[
        logDoits := Smalltalk logDoits asValue.
        logDoits onChangeSend:#updateModifiedChannel to:self
    ].
    ^ logDoits.

    "Modified (format): / 25-11-2011 / 15:43:41 / cg"
!

updChanges
    updChanges isNil ifTrue:[
        updChanges := Class updatingChanges asValue.
        updChanges onChangeSend:#updateModifiedChannel to:self
    ].
    ^ updChanges.

    "Modified (format): / 25-11-2011 / 15:43:45 / cg"
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/messageSettings.html'
! !

!AbstractSettingsApplication::ChangeFileSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self logDoits value ~= Smalltalk logDoits ifTrue:[^ true].
    self updChanges value ~= Class updatingChanges ifTrue:[^ true].
    currentUserPrefs changeFileName isNil ifTrue:[
        self changeFileName value ~= ObjectMemory nameForChanges ifTrue:[^ true].
    ] ifFalse:[
        self changeFileName value ~= currentUserPrefs changeFileName ifTrue:[^ true].
    ].
    ^ false

    "Modified: / 27-10-2010 / 10:17:21 / cg"
! !

!AbstractSettingsApplication::CodeGeneratorSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::CodeGeneratorSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
DQDQDQDQDQDQDQDRH"H"H"H"H"HADQH&Y&Y&Y&Y&Y IDD"XQE&Y&Y&Y&@$PRI!!Y&Y&Y&Y&XBQAH&E&Y&Y#Y&Y IDD"XQE&Y# 6Y&@$PRI&Y&L6N#X3XBQAH&
Y&M5M[T5\0IDD"Y&Y#&<7K$6@$PRI&Y&X57-T6XBPQH&Y&Y#W^5SY IAD"Y&Y#&<7K$6@!!DRI&Y#]SV5MWLBDQH&Y&X3X:M#M HQD"XQE&Y# 6Y&@!!DRI&XV
Y&X6Y&XBDQH&Y!!Y&Y&Y&Y HQD"XQE&Y&Y&Y&@!!DRI&Y&Y&Y&Y&XBDQH@@@@@@@@@@@HQDRH"H"H"H"H"H!!Db') ; colorMapFromArray:#[0 0 0 160 160 160 208 208 208 240 144 24 240 160 80 240 208 24 240 240 240 255 248 24 255 248 48 255 248 88 255 248 96 255 248 140 255 248 176 255 248 200 255 248 248]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@_?? _??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0O??0') ; yourself); yourself]
! !

!AbstractSettingsApplication::CodeGeneratorSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::CodeGeneratorSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::CodeGeneratorSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::CodeGeneratorSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Code Generator Settings'
         name: 'Code Generator Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 607 786)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 342 0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Generate Comments'
                   name: 'GenerateComments'
                   activeHelpKey: generateComments
                   model: generateComments
                   translateLabel: true
                   extent: (Point 607 30)
                 )
                (CheckBoxSpec
                   label: 'Generate Comments in Getters'
                   name: 'GenerateCommentsInGetters'
                   activeHelpKey: generateCommentsForGetters
                   enableChannel: generateComments
                   model: generateCommentsForGetters
                   translateLabel: true
                   extent: (Point 607 30)
                 )
                (CheckBoxSpec
                   label: 'Generate Comments in Setters'
                   name: 'GenerateCommentsInSetters'
                   activeHelpKey: generateCommentsForSetters
                   enableChannel: generateComments
                   model: generateCommentsForSetters
                   translateLabel: true
                   extent: (Point 607 30)
                 )
                )

             )
           )
          )

       )
     )

    "Modified: / 03-05-2017 / 20:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::CodeGeneratorSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        generateComments
        generateCommentsForGetters
        generateCommentsForSetters
    )
!

generateComments
    generateComments isNil ifTrue:[
        generateComments := UserPreferences current generateComments asValue.
        generateComments onChangeSend:#updateModifiedChannel to:self
    ].
    ^ generateComments.
!

generateCommentsForGetters
    generateCommentsForGetters isNil ifTrue:[
        generateCommentsForGetters := UserPreferences current generateCommentsForGetters asValue.
        generateCommentsForGetters onChangeSend:#updateModifiedChannel to:self
    ].
    ^ generateCommentsForGetters.
!

generateCommentsForSetters
    generateCommentsForSetters isNil ifTrue:[
        generateCommentsForSetters := UserPreferences current generateCommentsForSetters asValue.
        generateCommentsForSetters onChangeSend:#updateModifiedChannel to:self
    ].
    ^ generateCommentsForSetters.
! !

!AbstractSettingsApplication::CodeGeneratorSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/codeGeneratorSettings.html'
! !

!AbstractSettingsApplication::CommunicationLoggingSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon2
!

defaultIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::CommunicationLoggingSettingsAppl defaultIcon1'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@GY&Y&Y&Y&Y @0LB]UUUUUUUQG@C@0I5UUUUUUUD\@@@@''U&Y&YUUDQ0@@@B]UUUUUUTQG@@@@I5Y&Y&UUQD\@@@@''UUUUUUUDQ0@@@B]V
Y&Y%UDQG@@@@I5UUUUUTQD\@@@@''U&Y&YUQDQ0@SLB]UUUUUUDQGT@@@I5UUUUUTQD]P@0@''U&Y&YUQDQ0@C@B]UUUUUUDQG@@L@I5Y&Y&UDQD\@DS@''UUUU
UUQDQ0@SLB]UUUUUQDQG@AL0I7]7]7]7]7\@D3@"H"H"H"H"H@@QL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 255 255 0 192 192 192 100 100 100 224 224 224 240 240 240 0 80 128 80 80 80]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@_?<8??<8??<P??<P??<P??<P??<P??<P??<8??=<???<??>8??<8??<8??=<??=<??=<??=<??9<@@@8@@@@'); yourself); yourself]
!

defaultIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::CommunicationLoggingSettingsAppl defaultIcon2'
        ifAbsentPut:[(Depth8Image width:17 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@AP4MCP4MCP4MCP4MCP4M@@LE@ HB@ HB@ HB@ HJB T@@0TB@ HB@ HB@ HB@ (JAP@CAPHMCP4MCP4B@ HJB (E@@LE@ HB
@ HB@ HB@ (JB T@@0TBCP4MCP4M@ HBB (JAP@CAPHB@ HB@ HB@ HJB (E@@LE@ 4MCP4MCPHBB (JB T@@0TB@ HB@ HB@ HJB (JAP@CAPHMCP4MCP4B
@ (JB (E@@LE@ HB@ HB@ HBB (JB T@@0TB@ HB@ HB@ HJB (JAP@CAPHMCP4MCP4B@ (JB (E@@LE@ HB@ HB@ HBB (JB T@@0TBCP4MCP4M@ (JB (J
AP@CAPHB@ HB@ HB@ (JB (E@@LE@ HB@ HB@ HJB (JB T@@0TEAPTEAPTEAPTEAPTEAP@C@0LC@0LC@0LC@0LC@0L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@b'); colorMapFromArray:#[0 0 0 32 96 80 240 240 240 192 192 192 64 144 128 80 80 80 48 112 112 48 128 128 32 96 96 48 128 112 224 224 224 32 80 80 64 96 96 0 80 128]; mask:((ImageMask width:17 height:22) bits:(ByteArray fromPackedString:'@@@@_?<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??<@??8@@@@@@@@@'); yourself); yourself]
! !

!AbstractSettingsApplication::CommunicationLoggingSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::CommunicationLoggingSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::CommunicationLoggingSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::CommunicationLoggingSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Com-Logging settings'
         name: 'Com-Logging settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 445 401)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fitSpace
             verticalLayout: topSpace
             horizontalSpace: 5
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Log Outgoing HTTP Requests on Transcript'
                   name: 'LogHTTPRequests'
                   model: logHTTPRequests
                   translateLabel: true
                   extent: (Point 435 30)
                 )
                (CheckBoxSpec
                   label: 'Log Outgoing SOAP Requests on Transcript'
                   name: 'LogSOAPRequests'
                   model: logSOAPRequests
                   translateLabel: true
                   extent: (Point 435 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::CommunicationLoggingSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        logHTTPRequests
        logSOAPRequests
    )
!

logHTTPRequests
    logHTTPRequests isNil ifTrue:[
        logHTTPRequests := false asValue.
        logHTTPRequests onChangeSend:#updateModifiedChannel to:self
    ].
    ^ logHTTPRequests.
!

logSOAPRequests
    logSOAPRequests isNil ifTrue:[
        logSOAPRequests := false asValue.
        logSOAPRequests onChangeSend:#updateModifiedChannel to:self
    ].
    ^ logSOAPRequests.
! !

!AbstractSettingsApplication::CommunicationLoggingSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/comLoggingSettings.html'
! !

!AbstractSettingsApplication::DebuggerSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::DebuggerSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#allowSendingMail
'Show the "Send mail to Exept support team" button. Requires proper email setup'

#hideSupportCode
'Hide helper and support frames in the stack walkback display.\This includes the imlementation of collection, exception and block evaluation'

#showErrorNotifier
'Show a notifier dialog before opening the full debugger.\This displays an abbreviated walkback and provides buttons to continue, abort or debug'

#showVerboseStack
'Show the full stack walkback, including all of the tool and exception frames.\Often, this is too much information and may distract from your real problem'

#useNewLayout
'Use the new button layout with step/next buttons in the middle'

)
! !

!AbstractSettingsApplication::DebuggerSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary bugReporter24x24Icon
! !

!AbstractSettingsApplication::DebuggerSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::DebuggerSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::DebuggerSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::DebuggerSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Debugger Settings'
         name: 'Debugger Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 600 320)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 0
             component:
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'ShowErrorNotifierBox'
                   activeHelpKey: showErrorNotifier
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Show Error Notifier before Opening Debugger'
                         name: 'ShowErrorNotifierCheckBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         activeHelpKey: showErrorNotifier
                         model: showErrorNotifier
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 34)
                 )
                (ViewSpec
                   name: 'UseNewLayoutInDebuggerBox'
                   activeHelpKey: useNewLayout
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Use New Layout'
                         name: 'UseNewLayoutInDebuggerCheckBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         activeHelpKey: useNewLayout
                         model: useNewLayoutInDebugger
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 34)
                 )
                (ViewSpec
                   name: 'ShowVerboseStackBox'
                   activeHelpKey: showVerboseStack
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Verbose Backtrace by Default in Debugger'
                         name: 'ShowVerboseStackCheckBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         activeHelpKey: showVerboseStack
                         model: verboseBacktraceInDebugger
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 34)
                 )
                (ViewSpec
                   name: 'HideEnumerationCodeBox'
                   activeHelpKey: hideSupportCode
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Hide Support Code (Implementation of Enumerations, Exceptions, etc.)'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         activeHelpKey: hideSupportCode
                         model: hideSupportCodeInDebugger
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 34)
                 )
                (ViewSpec
                   name: 'AllowSendingMailFromDebuggerBox'
                   activeHelpKey: allowSendingMail
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Allow Sending of Error Reports from Debugger'
                         name: 'AllowSendingMailFromDebuggerCheckBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         activeHelpKey: allowSendingMail
                         model: allowSendMailFromDebugger
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 34)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::DebuggerSettingsAppl methodsFor:'actions'!

basicReadSettings
    self showErrorNotifier value:(NoHandlerError emergencyHandler == AbstractLauncherApplication notifyingEmergencyHandler).
    super basicReadSettings.

    "Modified: / 10-06-2012 / 21:23:24 / cg"
!

basicSaveSettings
    self showErrorNotifier value ifFalse:[
        NoHandlerError emergencyHandler:nil
    ] ifTrue:[
        NoHandlerError emergencyHandler:(AbstractLauncherApplication notifyingEmergencyHandler)
    ].
    super basicSaveSettings.
    Debugger newDebugger.

    "Modified: / 10-06-2012 / 21:23:32 / cg"
! !

!AbstractSettingsApplication::DebuggerSettingsAppl methodsFor:'aspects'!

allowSendMailFromDebugger

    allowSendMailFromDebugger isNil ifTrue:[
        allowSendMailFromDebugger := currentUserPrefs allowSendMailFromDebugger asValue.
        allowSendMailFromDebugger onChangeSend:#updateModifiedChannel to:self
    ].
    ^ allowSendMailFromDebugger.
!

aspects
    ^ #(
        allowSendMailFromDebugger
        verboseBacktraceInDebugger
        hideSupportCodeInDebugger
        useNewLayoutInDebugger
    )
!

hideSupportCodeInDebugger

    hideSupportCodeInDebugger isNil ifTrue:[
        hideSupportCodeInDebugger := (UserPreferences current hideSupportCodeInDebugger ? true) asValue.
        hideSupportCodeInDebugger onChangeSend:#updateModifiedChannel to:self
    ].
    ^ hideSupportCodeInDebugger.

    "Created: / 10-06-2012 / 21:23:40 / cg"
!

showErrorNotifier

    showErrorNotifier isNil ifTrue:[
        showErrorNotifier := (NoHandlerError emergencyHandler == AbstractLauncherApplication notifyingEmergencyHandler) asValue.
        showErrorNotifier onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showErrorNotifier.
!

useNewLayoutInDebugger

    useNewLayoutInDebugger isNil ifTrue:[
        useNewLayoutInDebugger := (UserPreferences current useNewLayoutInDebugger) asValue.
        useNewLayoutInDebugger onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewLayoutInDebugger.
!

verboseBacktraceInDebugger

    verboseBacktraceInDebugger isNil ifTrue:[
        verboseBacktraceInDebugger := (UserPreferences current verboseBacktraceInDebugger) asValue.
        verboseBacktraceInDebugger onChangeSend:#updateModifiedChannel to:self
    ].
    ^ verboseBacktraceInDebugger.
! !

!AbstractSettingsApplication::DebuggerSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/debuggerSettings.html'
! !

!AbstractSettingsApplication::DebuggerSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self showErrorNotifier value ~= (NoHandlerError emergencyHandler == AbstractLauncherApplication notifyingEmergencyHandler) ifTrue:[^ true].
    ^ super hasUnsavedChanges

    "Modified: / 10-06-2012 / 21:23:54 / cg"
! !

!AbstractSettingsApplication::DisplaySettingsAppl class methodsFor:'defaults'!

clipEncodingStrings

    ^ #('untranslated' 'iso8859' 'jis' 'jis7' 'shift-JIS' 'EUC' 'big5')
!

clipEncodingSyms

    ^ #(nil #iso8859 #jis #jis7 #sjis #euc #big5)
!

staticGrayOrGrayScaleDitherStrings

    ^ #('threshold' 'ordered dither' 'error diffusion')
!

staticGrayOrGrayScaleDitherSyms

    ^ #(threshold ordered floydSteinberg)
!

trueColorDitherStrings

    ^ #('nearest color' 'error diffusion')
!

trueColorDitherSyms

    ^ #(ordered floydSteinberg)
! !

!AbstractSettingsApplication::DisplaySettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:(self helpPairs)

    "Created: / 24-06-2014 / 19:39:38 / cg"
!

helpPairs
    <resource: #help>

    ^ #(

#enableVMWareDrawingBugWorkaround
'Enable a workaround for a redraw bug when the display is an XServer running inside a VMWare virtual machine.\If enabled, the number of buffered drawing operations is limited by performing an XFlush after every drawing operation.\\Only applies to X-Window display systems'

)

    "Created: / 24-06-2014 / 19:39:14 / cg"
! !

!AbstractSettingsApplication::DisplaySettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary displayScreenIcon
! !

!AbstractSettingsApplication::DisplaySettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::DisplaySettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::DisplaySettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::DisplaySettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Display Screen Settings'
         name: 'Display Screen Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 604 500)
       )
       component:
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Actual Visible Screen Area:'
             name: 'ActualVisibleScreenAreaLabel'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 30 0)
             translateLabel: true
             adjust: left
           )
          (LabelSpec
             label: 'Common Sizes:'
             name: 'CommonSizesLabel'
             layout: (LayoutFrame 0 0 39 0 277 0 69 0)
             translateLabel: true
             adjust: right
           )
          (PopUpListSpec
             label: 'monitor size'
             name: 'MonitorSelectionPopUpList'
             layout: (LayoutFrame 280 0 39 0 -5 1 69 0)
             translateLabel: true
             tabable: true
             model: monitorSelection
             menu: monitorList
             useIndex: true
           )
          (LabelSpec
             label: 'Screen Size:'
             name: 'ScreenSizeLabel'
             layout: (LayoutFrame 5 0 73 0 277 0 103 0)
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'SizeXEntryField'
             layout: (LayoutFrame 280 0 72 0 347 0 102 0)
             model: sizeX
             type: number
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: ' x '
             name: 'xLabel'
             layout: (LayoutFrame 348 0 72 0 369 0 102 0)
             translateLabel: true
           )
          (InputFieldSpec
             name: 'SizeYEntryField'
             layout: (LayoutFrame 370 0 72 0 437 0 102 0)
             model: sizeY
             type: number
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: '(mm)'
             name: 'mmLabel'
             layout: (LayoutFrame 439 0 72 0 485 0 102 0)
             translateLabel: true
             adjust: left
           )
          (LabelSpec
             label: 'Limit Usable Area To:'
             name: 'Label1'
             layout: (LayoutFrame 5 0 110 0 277 0 140 0)
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'EntryField1'
             layout: (LayoutFrame 280 0 110 0 347 0 140 0)
             model: usedWidth
             type: number
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: ' x '
             name: 'Label2'
             layout: (LayoutFrame 348 0 110 0 369 0 140 0)
             translateLabel: true
           )
          (InputFieldSpec
             name: 'EntryField2'
             layout: (LayoutFrame 370 0 110 0 437 0 140 0)
             model: usedHeight
             type: number
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: '(Pixel)'
             name: 'Label3'
             layout: (LayoutFrame 439 0 110 0 507 0 140 0)
             translateLabel: true
             adjust: left
           )
          (ActionButtonSpec
             label: 'Restore'
             name: 'Button1'
             layout: (AlignmentOrigin 512 0 124 0 0 0.5)
             translateLabel: true
             model: restoreUsableExtent
           )
          (DividerSpec
             name: 'Separator1'
             layout: (LayoutFrame 0 0.0 143 0 0 1.0 147 0)
           )
          (LabelSpec
             name: 'ScreenDepthVisualLabel'
             layout: (LayoutFrame 0 0.0 151 0.0 0 1.0 181 0)
             translateLabel: true
             labelChannel: screenDepthVisualLabelHolder
             adjust: left
           )
          (DividerSpec
             name: 'Separator2'
             layout: (LayoutFrame 0 0.0 182 0 0 1.0 186 0)
           )
          (CheckBoxSpec
             label: 'Color Monitor'
             name: 'ColorMonitorCheckBox'
             layout: (LayoutFrame 5 0 193 0 250 0 223 0)
             model: isColorMonitor
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Use Fix Color Palette'
             name: 'FixColorPaletteCheckBox'
             layout: (LayoutFrame 5 0 223 0 301 0 253 0)
             enableChannel: visualIsPseudoColor
             model: useFixPalette
             translateLabel: true
             labelChannel: useFixPaletteLabel
           )
          (CheckBoxSpec
             label: 'Use Fix Gray Color Palette'
             name: 'UseFixGrayPaletteCheckBox'
             layout: (LayoutFrame 5 0 257 0 301 0 287 0)
             enableChannel: visualIsPseudoColor
             model: useFixGrayPalette
             translateLabel: true
             labelChannel: useFixGrayPaletteLabel
           )
          (LabelSpec
             label: 'Image Display:'
             name: 'ImageDisplayLabel'
             layout: (LayoutFrame 5 0 294 0 227 0 324 0)
             translateLabel: true
             adjust: right
           )
          (PopUpListSpec
             label: 'image display'
             name: 'DitherListPopUpList'
             layout: (LayoutFrame 230 0 294 0 -30 1 324 0)
             translateLabel: true
             tabable: true
             model: ditherListSelection
             enableChannel: ditherSymsNotNil
             menu: ditherList
             useIndex: true
           )
          (CheckBoxSpec
             label: 'Allow Colored/Grayscale Icons'
             name: 'AllowColoredGrayscaleIconsCheckBox'
             layout: (LayoutFrame 5 0 334 0 301 0 364 0)
             model: deepIcons
             translateLabel: true
           )
          (DividerSpec
             name: 'Separator3'
             layout: (LayoutFrame 0 0.0 368 0 0 1.0 372 0)
           )
          (LabelSpec
             label: 'ClipBoard Encoding:'
             name: 'ClipBoardEncodingLabel'
             layout: (LayoutFrame 0 0 383 0 277 0 413 0)
             translateLabel: true
             adjust: right
           )
          (PopUpListSpec
             label: 'image display'
             name: 'ClipEncodingListPopUpList'
             layout: (LayoutFrame 278 0 383 0 -30 1 413 0)
             translateLabel: true
             tabable: true
             model: clipEncodingListSelection
             menu: clipEncodingList
             useIndex: true
           )
          (LabelSpec
             label: 'Max. CopyBuffer Size:'
             name: 'MaxCopyBufferSizeLabel'
             layout: (LayoutFrame 0 0 418 0 277 0 448 0)
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'MaxCopyBufferEntryField'
             layout: (LayoutFrame 278 0 418 0 373 0 448 0)
             model: maxCopyBufferSize
             type: fileSize
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (DividerSpec
             name: 'Separator4'
             layout: (LayoutFrame 0 0.0 454 0 0 1.0 458 0)
           )
          (CheckBoxSpec
             label: 'Enable VMWare Drawing Bug Workaround (Limit Number of Buffered Operations)'
             name: 'CheckBox1'
             layout: (LayoutFrame 5 0 464 0 0 1 486 0)
             activeHelpKey: enableVMWareDrawingBugWorkaround
             model: enableVMWareDrawingBugWorkaround
             translateLabel: true
           )
          )

       )
     )
! !

!AbstractSettingsApplication::DisplaySettingsAppl methodsFor:'actions'!

basicReadSettings
    self enableVMWareDrawingBugWorkaround value: currentUserPrefs enableVMWareDrawingBugWorkaround.

    self useFixPalette value:screen fixColors notNil.
    self useFixGrayPalette value:screen fixGrayColors notNil.
    self isColorMonitor value:screen hasColors.
    self sizeX value:screen widthInMillimeter.
    self sizeY value:screen heightInMillimeter.
    self usedWidth value:screen usableWidth.
    self usedHeight value:screen usableHeight.
    self deepIcons value:screen supportsDeepIcons.

    ditherSyms notNil ifTrue:[
        self ditherListSelection
            value:(ditherSyms indexOf:(Image ditherAlgorithm) ifAbsent:#threshold)
    ].
    self clipEncodingListSelection
        value:(self class clipEncodingSyms indexOf:screen clipboardEncoding
                ifAbsent:1).

    "Modified: / 19-11-2013 / 10:25:51 / cg"
!

basicSaveSettings

    currentUserPrefs enableVMWareDrawingBugWorkaround:self enableVMWareDrawingBugWorkaround value.
    Image flushDeviceImages.

    screen visualType == #PseudoColor ifTrue:[
        self useFixPalette value ifTrue:[
            Color colorAllocationFailSignal handle:[:ex |
                self warn:'Could not allocate colors.'.
            ] do:[
                Color getColorsRed:4 green:8 blue:4 on:screen
            ]
        ] ifFalse:[
            screen releaseFixColors
        ].

        self useFixGrayPalette value ifTrue:[
            Color colorAllocationFailSignal handle:[:ex |
                self warn:'Could not allocate colors.'.
            ] do:[
                Color getGrayColors:32 on:screen
            ]
        ] ifFalse:[
            screen releaseFixGrayColors
        ]
    ].
    screen hasColors:self isColorMonitor value.
    screen widthInMillimeter:self sizeX value.
    screen heightInMillimeter:self sizeY value.

    screen setUsableWidth:self usedWidth value.
    screen setUsableHeight:self usedHeight value.

    screen supportsDeepIcons:self deepIcons value.
    ditherSyms notNil ifTrue:[
        Image ditherAlgorithm:(ditherSyms at:self ditherListSelection value).
    ].

    WindowGroup activeGroup withWaitCursorDo:[
        View defaultStyle:(View defaultStyle).
    ].

    screen clipboardEncoding:(self class clipEncodingSyms at:self clipEncodingListSelection value).

    "Modified: / 19-11-2013 / 10:26:08 / cg"
!

restoreUsableExtent
    self usedWidth value:(screen queryWidth).
    self usedHeight value:(screen queryHeight).
! !

!AbstractSettingsApplication::DisplaySettingsAppl methodsFor:'aspects'!

clipEncodingList

    clipEncodingList isNil ifTrue:[
        clipEncodingList := (resources array:self class clipEncodingStrings) asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       clipEncodingList addDependent:self.
"/       clipEncodingList onChangeSend:#clipEncodingListChanged to:self.
    ].
    ^ clipEncodingList.
!

clipEncodingListSelection

    clipEncodingListSelection isNil ifTrue:[
        clipEncodingListSelection := (self class clipEncodingSyms indexOf:screen clipboardEncoding ifAbsent:1) asValue.
        clipEncodingListSelection onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ clipEncodingListSelection.
!

deepIcons

    deepIcons isNil ifTrue:[
        deepIcons := screen supportsDeepIcons asValue.
        deepIcons onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ deepIcons.
!

ditherList

    ditherList isNil ifTrue:[
        ditherList := ValueHolder new.
    ].
    ^ ditherList.
!

ditherListSelection

    ditherListSelection isNil ifTrue:[
        ditherSyms notNil ifTrue:[
            ditherListSelection := (ditherSyms indexOf:(Image ditherAlgorithm) ifAbsent:#threshold) asValue.
        ] ifFalse:[
            ditherListSelection := ValueHolder new.
        ].
        ditherListSelection onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ ditherListSelection.
!

ditherSymsNotNil

    ditherSymsNotNil isNil ifTrue:[
        ditherSymsNotNil := ditherSyms notNil asValue.
    ].
    ^ ditherSymsNotNil.
!

enableVMWareDrawingBugWorkaround

    enableVMWareDrawingBugWorkaround isNil ifTrue:[
        enableVMWareDrawingBugWorkaround := false asValue.
        enableVMWareDrawingBugWorkaround onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ enableVMWareDrawingBugWorkaround.

    "Created: / 19-11-2013 / 10:24:42 / cg"
!

isColorMonitor

    isColorMonitor isNil ifTrue:[
        isColorMonitor := screen hasColors asValue.
        isColorMonitor onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ isColorMonitor.
!

maxCopyBufferSize

    maxCopyBufferSize isNil ifTrue:[
        maxCopyBufferSize := (8*1024*1024) asValue.
        maxCopyBufferSize addDependent:self.
        maxCopyBufferSize changed.
        maxCopyBufferSize onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ maxCopyBufferSize.
!

monitorList

    monitorList isNil ifTrue:[
        monitorList := (resources array:(sizeInfos collect:[:entry | entry at:1])) asList.
    ].
    ^ monitorList.
!

monitorSelection

    monitorSelection isNil ifTrue:[
        monitorSelection := ValueHolder new.
        monitorSelection addDependent:self.
        monitorSelection onChangeSend:#updateModifiedChannel to:self.
        monitorSelection changed.
    ].
    ^ monitorSelection.
!

screenDepthVisualLabelHolder

    screenDepthVisualLabelHolder isNil ifTrue:[
        screenDepthVisualLabelHolder := (resources string:'Screen: Depth: %1 Visual: %2  (%3)'
                                 with:screen depth printString
                                 with:screen visualType
                                 with:screen serverVendor) asValue.
    ].
    ^ screenDepthVisualLabelHolder.
!

sizeX

    sizeX isNil ifTrue:[
        sizeX := screen widthInMillimeter asValue.
        sizeX addDependent:self.
        sizeX changed.
        sizeX onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ sizeX.
!

sizeY

    sizeY isNil ifTrue:[
        sizeY := screen heightInMillimeter asValue.
        sizeY addDependent:self.
        sizeY changed.
        sizeY onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ sizeY.
!

useFixGrayPalette

    useFixGrayPalette isNil ifTrue:[
        useFixGrayPalette := screen fixGrayColors notNil asValue.
        useFixGrayPalette onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ useFixGrayPalette.
!

useFixGrayPaletteLabel

    useFixGrayPaletteLabel isNil ifTrue:[
        useFixGrayPaletteLabel := (resources string:'Use Fix Gray Color Palette %1' with:'(32)') asValue.
    ].
    ^ useFixGrayPaletteLabel.
!

useFixPalette

    useFixPalette isNil ifTrue:[
        useFixPalette := screen fixColors notNil asValue.
        useFixPalette onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ useFixPalette.
!

useFixPaletteLabel

    useFixPaletteLabel isNil ifTrue:[
        useFixPaletteLabel := (resources string:'Use Fix Color Palette %1' with:'(4x8x4)') asValue.
    ].
    ^ useFixPaletteLabel.
!

usedHeight
    usedHeight isNil ifTrue:[
        usedHeight := screen usableHeight asValue.
        usedHeight addDependent:self.
        usedHeight changed.
        usedHeight onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ usedHeight.
!

usedWidth
    usedWidth isNil ifTrue:[
        usedWidth := screen usableWidth asValue.
        usedWidth addDependent:self.
        usedWidth changed.
        usedWidth onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ usedWidth.
!

visualIsPseudoColor

    visualIsPseudoColor isNil ifTrue:[
        visualIsPseudoColor := (screen visualType == #PseudoColor) asValue.
        visualIsPseudoColor onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ visualIsPseudoColor.
! !

!AbstractSettingsApplication::DisplaySettingsAppl methodsFor:'change & update'!

monitorSelectionChanged

    | sel sizeInfoEntry sizes|

    sel := self monitorSelection value.
    (sel notNil and:[sel ~~ 0]) ifTrue:[
        sizeInfoEntry := sizeInfos at:sel.
        sizes := sizeInfoEntry at:2.
        self sizeX value:(sizes at:1).
        self sizeY value:(sizes at:2).
    ].
!

sizeXorYChanged
    | sizes idx|

    sizes := sizeInfos collect:[:entry | entry at:2].
    idx := sizes findFirst:[:entry |
                                ((entry at:1) = sizeX value)
                                and:[((entry at:2) = sizeY value)]
                           ].
    idx ~~ 0 ifTrue:[
        self monitorSelection value:idx
    ].
!

update:something with:aParameter from:changedObject
    changedObject == self monitorSelection ifTrue:[
        self monitorSelectionChanged.
        ^ self.
    ].
    (changedObject == self sizeX or:[changedObject == self sizeY]) ifTrue:[
        self sizeXorYChanged.
        ^ self.
    ].

    super update:something with:aParameter from:changedObject
! !

!AbstractSettingsApplication::DisplaySettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/screenSettings.html'
! !

!AbstractSettingsApplication::DisplaySettingsAppl methodsFor:'initialization & release'!

initialize

    | listOfSizes visual|

    screen := Screen current.

    listOfSizes := self class classResources at:'LIST_OF_OFFERED_SCREEN_SIZES' default:#default.
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
    visual := screen visualType.
    (visual == #StaticGray or:[visual == #GrayScale]) ifTrue:[
        ditherStyles := self class staticGrayOrGrayScaleDitherStrings.
        ditherSyms := self class staticGrayOrGrayScaleDitherSyms.
    ] ifFalse:[
        visual ~~ #TrueColor ifTrue:[
            ditherStyles := self class trueColorDitherStrings.
            ditherSyms := self class trueColorDitherSyms.
        ]
    ].
    super initialize.

! !

!AbstractSettingsApplication::DisplaySettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self enableVMWareDrawingBugWorkaround value ~~ currentUserPrefs enableVMWareDrawingBugWorkaround ifTrue:[^ true].
    self useFixPalette value ~= screen fixColors notNil ifTrue:[^ true].
    self useFixGrayPalette value ~= screen fixGrayColors notNil ifTrue:[^ true].
    self isColorMonitor value ~= screen hasColors ifTrue:[^ true].
    self sizeX value ~= screen widthInMillimeter ifTrue:[^ true].
    self sizeY value ~= screen heightInMillimeter ifTrue:[^ true].
    self usedWidth value ~= screen usableWidth ifTrue:[^ true].
    self usedHeight value ~= screen usableHeight ifTrue:[^ true].

    self deepIcons value ~= screen supportsDeepIcons ifTrue:[^ true].
    ditherSyms notNil ifTrue:[
        self ditherListSelection value ~= (ditherSyms indexOf:(Image ditherAlgorithm) ifAbsent:#threshold) ifTrue:[^ true].
    ].
    self clipEncodingListSelection value ~= (self class clipEncodingSyms indexOf:screen clipboardEncoding ifAbsent:1) ifTrue:[^ true].
    ^ false

    "Modified: / 19-11-2013 / 10:26:34 / cg"
! !

!AbstractSettingsApplication::EditSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::EditSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

"/#resetToDefault
"/'Reset fonts back to original default values (as specified in the window style-file and OS settings)'
"/
"/#changeToHighContrast
"/'Change settings for higher contrast. Useful for presentations and outdor operation'
"/
"/#changeToBigFonts
"/'Change settings for bigger fonts. Useful for presentations'
"/
"/#changeToHugeFonts
"/'Change settings for huge fonts. Useful for presentations'
"/
"/#changeToSTXLook
"/'Change settings for an ST/X-like look (fixed-width code fonts)'
"/
"/#changeToSqueakLook
"/'Change settings for a Squeak-like look (variable fonts)'
"/
"/#changeToVisualAgeLook
"/'Change settings for a VisualAge-like look (bold variable fonts)'

#immediateCodeCompletion
'Show code completion suggestions as you type.\This is an experimental feature, please disable it if you encounter problems.'

#codeCompletionOnControlKey
'Show code completion suggestions when you hit the CTRL key, and the character before the cursor is non-blank.\This is an experimental feature, please disable it if you encounter problems.\(CTRL-Space still works as usual, even if this is disabled)'

#codeCompletionOnTabKey
'Show code completion suggestions when you hit the TAB key, and the character before the cursor is non-blank.\This is an experimental feature, please disable it if you encounter problems.'

#codeCompletionViewKeyboardNavigationNeedsModifier
'If on, cursor up/down are only passed to the floating completion view,\if a shift- or control modifier is pressed.\Check this, if you find it annoying, that cursor up/down is intercepted by a floating completion view.'

#alwaysPasteFileContents
'When pasting a file (from the Filebrowser or Explorer), always paste the file''s contents\without asking. If off, a dialog appears to ask the name or the contents of the file should be pasted'

#autoIndentInCodeView
'Automatically position the cursor to a reasonably indented position when pressing the return key.\This affects editors which show code'

#extendedWordSelectMode
'Controls if underlines will be treated as part of the word or not when selecting a word.\Many programming languages (including ST/X, but excluding Squeak and old ST80)\treat underline like a letter in identifiers'

#searchBoxIsModal
'If off, a text search box is non-modal, and can be left floating beside an editor to mix search and edit operations.\If modal, it behaves as usual, blocking interaction with the editor while open'

#selectAllWhenClickingBeyondEnd
'If on, a click beyond (i.e. below) the end of the text selects the whole text.\If off, use quadruple-click to select all (triple-click to select a full line)'

#showAcceptCancelBar
'Display an green-red-yellow accept-cancel bar to the left of the text.\Press green to accept, red to cancel, and yellow to compare against the original version.'

#st80DoubleClickSelectMode
'Enable the ST-80 mode for double-click on the character right after an opening parenthesis or string-quote,\to select the paranethized or quoted text.\Also, a double-click on the very first character selects the whole text'

#st80EditMode
'Enable the ST-80 line-end/text-end cursor behavior.\There, the cursor cannot be positioned beyond the end of text, and cursor movement leads to the next/previous line.\This is similar to the behavior of other editors, such as "vi" or "emacs".\If off, the page is treated like a piece of paper, where any position can be reached immediately ("Rand-Editor" behavior)'


#startTextDragWithCTRL
'Press CTRL to drag the selected text into another view'

#tabStops4
'Controls if tab stops are multiples of 4 or 8 while editing.\Notice that this only affects the cursor positioning while editing, and that tabs are never part of the text internally.\The external (file-) representation always uses tab stops in multiples of 8.\Thus, when saving, one leading tab is generated for every 8 leading spaces,\and when reading a file, each tab is replaced by 8 spaces.\For ST/X, using multiple of 4 is recommended (the whole system was written in this style)'

#useNewCodeView2
'Use the new advanced CodeView2, which supports line numbers, advanced variable and selector highlighting,\and other useful programmer features'

#whitespaceWordSelectMode
'Controls if non-whitespace separators (such as fullstop, parentheses etc.) are treated as separator when selecting a word via double-click.\If off, only whitespace is treated as such. Useful when editing plain text, or code written in Lisp or Scheme'

#selectionExtensionModelStandard
'Standard behavior - most text editors and text widgets behave like this.'

#selectionExtensionModelTraditional
'Traditional ST/X behavior (better but not standard).\Shift-End moves end of selection (if it is on the same line).\Shift-Home moves start of selection (if it is on the same line)'

)

    "Created: / 17-03-2012 / 11:37:51 / cg"
    "Modified: / 27-03-2014 / 10:19:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::EditSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary editorIcon
! !

!AbstractSettingsApplication::EditSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::EditSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::EditSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::EditSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Editor Settings'
         name: 'Editor Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 658 543)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Use the New Code Editor (v2)'
                   name: 'UserCodeView2'
                   activeHelpKey: useNewCodeView2
                   model: useCodeView2InTools
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Show Accept/Cancel Bar in Editor'
                   name: 'ShowAcceptCancelBarInBrowser'
                   activeHelpKey: showAcceptCancelBar
                   model: showAcceptCancelBarInBrowser
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'SearchBox is Modal'
                   name: 'SearchBoxModalCheckBox'
                   activeHelpKey: searchBoxIsModal
                   model: searchDialogIsModal
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (DividerSpec
                   name: 'Separator6'
                   extent: (Point 658 4)
                 )
                (CheckBoxSpec
                   label: 'Code Completion as you Type'
                   name: 'CheckBox5'
                   activeHelpKey: immediateCodeCompletion
                   model: immediateCodeCompletion
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (ViewSpec
                   name: 'Box1'
                   activeHelpKey: codeCompletionOnControlKey
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Code Completion on CTRL Key'
                         name: 'CheckBox6'
                         layout: (LayoutFrame 0 0 0 0 350 0 25 0)
                         activeHelpKey: codeCompletionOnControlKey
                         model: codeCompletionOnControlKey
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'On TAB Key'
                         name: 'CheckBox7'
                         layout: (LayoutFrame 380 0 0 0 658 0 25 0)
                         activeHelpKey: codeCompletionOnTabKey
                         model: codeCompletionOnTabKey
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Shift/CTRL for Navigation in Completion List'
                   name: 'CheckBox8'
                   activeHelpKey: codeCompletionViewKeyboardNavigationNeedsModifier
                   model: codeCompletionViewKeyboardNavigationNeedsModifier
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (DividerSpec
                   name: 'Separator5'
                   extent: (Point 658 4)
                 )
                (CheckBoxSpec
                   label: 'Tab Stops in Multiples of 4'
                   name: 'TabStopsMultiples4CheckBox'
                   activeHelpKey: tabStops4
                   model: tabsIs4
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (DividerSpec
                   name: 'Separator2'
                   extent: (Point 658 4)
                 )
                (CheckBoxSpec
                   label: 'CTRL-Key to Start TextDrag'
                   name: 'CTRLKeyStTextDragCheckBox'
                   activeHelpKey: startTextDragWithCTRL
                   model: startTextDragWithControl
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Always Paste the Contents when Dropping a File (Do not Ask) '
                   name: 'EnforceContentsDropForFiles'
                   activeHelpKey: alwaysPasteFileContents
                   model: enforceContentsDropForFiles
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (DividerSpec
                   name: 'Separator4'
                   extent: (Point 658 4)
                 )
                (CheckBoxSpec
                   label: 'Autoindent (Position Cursor on Return Key in Code Editors)'
                   name: 'CheckBox3'
                   activeHelpKey: autoIndentInCodeView
                   model: autoIndentInCodeView
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Cursor has Standard Line-End Behavior'
                   name: 'CursorST80LineEndBehaviorCheckBox'
                   activeHelpKey: st80EditMode
                   model: st80EditMode
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (DividerSpec
                   name: 'Separator3'
                   extent: (Point 658 4)
                 )
                (CheckBoxSpec
                   label: 'Select all when Clicking beyond the Text''s End'
                   name: 'CheckBox2'
                   activeHelpKey: selectAllWhenClickingBeyondEnd
                   model: selectAllWhenClickingBeyondEnd
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Double Click Select Behavior as in ST80'
                   name: 'DoubleClickSelectBehaviorST80CheckBox'
                   activeHelpKey: st80DoubleClickSelectMode
                   model: st80DoubleClickSelectMode
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Treat Underscore as Letter in Word-Select'
                   name: 'UnderscoreIsLetterCheckBox'
                   activeHelpKey: extendedWordSelectMode
                   model: extendedWordSelectMode
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Any non-Whitespace in Word-Select'
                   name: 'CheckBox1'
                   activeHelpKey: whitespaceWordSelectMode
                   model: whitespaceWordSelectMode
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (DividerSpec
                   name: 'Separator7'
                   extent: (Point 658 4)
                 )
                (RadioButtonSpec
                   label: 'Traditional ST/X Selection Mode'
                   name: 'RadioButton1'
                   activeHelpKey: selectionExtensionModelTraditional
                   translateLabel: true
                   model: selectionExtensionMode
                   enableChannel: selectionExtensionModeEnabled
                   isTriggerOnDown: true
                   select: traditional
                   extent: (Point 658 30)
                 )
                (RadioButtonSpec
                   label: 'Standard Selection Mode'
                   name: 'RadioButton2'
                   activeHelpKey: selectionExtensionModelStandard
                   translateLabel: true
                   model: selectionExtensionMode
                   enableChannel: selectionExtensionModeEnabled
                   isTriggerOnDown: true
                   select: standard
                   extent: (Point 658 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::EditSettingsAppl methodsFor:'actions'!

basicReadSettings
    super basicReadSettings.

    self st80DoubleClickSelectMode value:TextView st80SelectMode.
    self tabsIs4 value:(ListView userDefaultTabPositions = ListView tab4Positions).
    self enforceContentsDropForFiles value:(currentUserPrefs enforcedDropModeForFiles == #text).
!

basicSaveSettings
    super basicSaveSettings.

    currentUserPrefs enforcedDropModeForFiles:
        ( self enforceContentsDropForFiles value
            ifTrue:[ #text ]
            ifFalse:[ nil ] ).

    TextView st80SelectMode:(self st80DoubleClickSelectMode value).
    tabsIs4 value ~~ (ListView userDefaultTabPositions = ListView tab4Positions) ifTrue:[
        ListView userDefaultTabPositions:
            (self tabsIs4 value
                ifTrue:[ListView tab4Positions]
                ifFalse:[ListView tab8Positions]).

        ListView allSubInstancesDo:[:eachKindOfListView |
            self tabsIs4 value
                ifTrue:[eachKindOfListView setTab4]
                ifFalse:[eachKindOfListView setTab8]
        ].
    ].
!

commonAspects
    ^ #(
        #useCodeView2InTools
         #showAcceptCancelBarInBrowser
         #searchDialogIsModal
         #startTextDragWithControl
         #st80EditMode
         #extendedWordSelectMode
         #whitespaceWordSelectMode
         #selectAllWhenClickingBeyondEnd
         #autoIndentInCodeView
         #immediateCodeCompletion
         #codeCompletionOnControlKey
         #codeCompletionOnTabKey
         #codeCompletionViewKeyboardNavigationNeedsModifier
         #selectionExtensionMode
    )

    "Modified: / 07-03-2012 / 14:33:40 / cg"
    "Modified: / 27-03-2014 / 10:10:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::EditSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        #useCodeView2InTools
         #showAcceptCancelBarInBrowser
         #searchDialogIsModal
         #startTextDragWithControl
         #st80EditMode
         #extendedWordSelectMode
         #whitespaceWordSelectMode
         #selectAllWhenClickingBeyondEnd
         #autoIndentInCodeView
         #immediateCodeCompletion
         #codeCompletionOnControlKey
         #codeCompletionOnTabKey
         #codeCompletionViewKeyboardNavigationNeedsModifier
         #selectionExtensionMode
    )

    "Modified: / 07-03-2012 / 14:33:40 / cg"
    "Modified: / 27-03-2014 / 10:10:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

autoIndentInCodeView
    autoIndentInCodeView isNil ifTrue:[
        autoIndentInCodeView := false asValue.
        autoIndentInCodeView onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ autoIndentInCodeView.
!

codeCompletionOnControlKey
    codeCompletionOnControlKey isNil ifTrue:[
        codeCompletionOnControlKey := false asValue.
        codeCompletionOnControlKey onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ codeCompletionOnControlKey.
!

codeCompletionOnTabKey
    codeCompletionOnTabKey isNil ifTrue:[
        codeCompletionOnTabKey := false asValue.
        codeCompletionOnTabKey onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ codeCompletionOnTabKey.
!

enforceContentsDropForFiles
    enforceContentsDropForFiles isNil ifTrue:[
        enforceContentsDropForFiles := true asValue.
        enforceContentsDropForFiles onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ enforceContentsDropForFiles.
!

extendedWordSelectMode
    extendedWordSelectMode isNil ifTrue:[
        extendedWordSelectMode := true asValue.
        extendedWordSelectMode onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ extendedWordSelectMode.
!

immediateCodeCompletion
    immediateCodeCompletion isNil ifTrue:[
        immediateCodeCompletion := false asValue.
        immediateCodeCompletion onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ immediateCodeCompletion.
!

searchDialogIsModal
    searchDialogIsModal isNil ifTrue:[
        searchDialogIsModal := true asValue.
        searchDialogIsModal onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ searchDialogIsModal.
!

selectAllWhenClickingBeyondEnd
    selectAllWhenClickingBeyondEnd isNil ifTrue:[
        selectAllWhenClickingBeyondEnd := true asValue.
        selectAllWhenClickingBeyondEnd onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ selectAllWhenClickingBeyondEnd.

    "Created: / 07-03-2012 / 14:34:08 / cg"
!

selectionExtensionMode
    selectionExtensionMode isNil ifTrue:[
        selectionExtensionMode := #traditional asValue.
        selectionExtensionMode onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ selectionExtensionMode.

    "Created: / 27-03-2014 / 10:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionExtensionModeEnabled
    "/ Hack to detect whether current system has hacked EditTextView or not.
    "/ Once integrated, this method whould always return true.

    ^ true. "/ EditTextView methodDictionary includesKey: #extendSelectionToX:y:setPrimarySelection:

    "Created: / 27-03-2014 / 10:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showAcceptCancelBarInBrowser
    showAcceptCancelBarInBrowser isNil ifTrue:[
        showAcceptCancelBarInBrowser := false asValue.
        showAcceptCancelBarInBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showAcceptCancelBarInBrowser.
!

st80DoubleClickSelectMode
    st80DoubleClickSelectMode isNil ifTrue:[
        st80DoubleClickSelectMode := true asValue.
        st80DoubleClickSelectMode onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ st80DoubleClickSelectMode.
!

st80EditMode
    st80EditingMode isNil ifTrue:[
        st80EditingMode := true asValue.
        st80EditingMode onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ st80EditingMode.
!

startTextDragWithControl
    startTextDragWithControl isNil ifTrue:[
        startTextDragWithControl := true asValue.
        startTextDragWithControl onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ startTextDragWithControl.
!

tabsIs4
    tabsIs4 isNil ifTrue:[
        tabsIs4 := true asValue.
        tabsIs4 onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ tabsIs4.
!

useCodeView2InTools
    useCodeView2InTools isNil ifTrue:[
        useCodeView2InTools := ValueHolder new.
        useCodeView2InTools onChangeSend:#updateModifiedChannel to:self

    ].
    ^ useCodeView2InTools

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

whitespaceWordSelectMode
    whitespaceWordSelectMode isNil ifTrue:[
        whitespaceWordSelectMode := true asValue.
        whitespaceWordSelectMode onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ whitespaceWordSelectMode.
! !

!AbstractSettingsApplication::EditSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/editSettings.html'
! !

!AbstractSettingsApplication::EditSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self enforceContentsDropForFiles value ~= (currentUserPrefs enforcedDropModeForFiles == #text) ifTrue:[^ true].
    TextView st80SelectMode ~= (self st80DoubleClickSelectMode value) ifTrue:[^ true].
    tabsIs4 value ~~ (ListView userDefaultTabPositions = ListView tab4Positions) ifTrue:[
        ListView userDefaultTabPositions ~= (self tabsIs4 value
                                                ifTrue:[ListView tab4Positions]
                                                ifFalse:[ListView tab8Positions]) ifTrue:[^ true].
    ].

    ^ super hasUnsavedChanges

    "Modified: / 25-11-2011 / 15:23:02 / cg"
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl class methodsFor:'defaults'!

keepSourceOptions

    ^ #( keep reference absReference sourceReference discard )
!

keepSourceStrings

    ^ #('Keep as String' 'Reference to Filename' 'Reference to Full Path' 'Append and Ref in `st.src''' 'Discard' )
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::HTTPStartServerSettingsApplication
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#catchMethodRedefinition
'Warn if an existing method from another package is redefined'

#catchClassRedefinition
'Warn if an existing class from another package is redefined'

#historyLineInMethods
'If enabled, the compiler will maintain a method''s edit history inside the method.\This is done by appending a corresponding comment whenever a method is changed.'

#historyLineInClasses
'If enabled, the compiler will maintain a history method in the class.\This is done by appending a corresponding comment to a comment-only class method,\whenever a method is changed.\\This is disabled, if the HistoryManager class is not loaded.'

#userNameInHistoryLine
'Your name signature to be used in the history line.\If nothing is entere here, your login name will be used.'

#fileInSourceMode
'Controls how the source code information is stored when code is filed in.\This is probably no longer of interest, as machines nowadays have lots of memory.\\The possible settings are:\\- Keep as String (the full source is kept as a string in the method)\- Reference to File (remember the filename and position only)\- Reference to "st.img": (write source to a private source file and remember offset)\- Forget (no source is held)\\All file related settings introduce a possible danger when the loaded file changes\(i.e. is edited outside ST/X or a new version is checked out from a repository)\Therefore, we highly recommend to not change this settings.'

#loadBinaryObjectsWhenAutoloading
'Controls if binary packaged class libraries should be considered when autoloading,\or only source files are to be loaded.\A binary load may fail, if the file is not in sync with the ase-system''s version,\whereas source loading is usually safe.\\Notice that autoloading is a historic feature anyway, so you may not be interested in this setting anyway.'
)
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon3

    "Modified: / 17-09-2007 / 11:35:08 / cg"
!

defaultIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::GeneralCompilerSettingsAppl defaultIcon1'
        ifAbsentPut:[(Depth2Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@C??????@CUUUUUW@CZ****''@CZ****''CCZ****''@CV****WKCV****W@CU***)WJCU***)W@CUZ**%W@CUZ**%WACUV**UW@CUV**UWDCUU*)UWI
CUU*)UWICUUZ%UWJCUUZ%UWACUUVUUW@CUUUUUW@C??????@@@@@@@@B') colorMapFromArray:#[0 0 0 255 255 255 255 189 23 127 127 127] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8@@@@'); yourself); yourself]
!

defaultIcon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon3 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::GeneralCompilerSettingsAppl defaultIcon3'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@0PDA@PD
A@PDA@PDA@PDA@PDA@PDA@LDA LDA@PDA@PDA@PDA@PDA@PD@0LDA@LDA LDA@LCA@PDA@PDA@PDA@PCA PC@0PEAPPC@0PF@0PDA@PDA@PDA@PC@PTDA@TE
APTDA@TA@0PDA@PDA@PDA@PD@0XEAPTEAPTEAPXCA@PDA@PDA@PDA@PD@0PEAPXAA XEAPPCA@PDA@PDA@PDA@LCA@TEA DC@0DFAPTD@0LDA@PDA@PD@0PD
APTE@PLB@ LAAPTEA@PCA@P@A@PD@0DAAPTEA LB@ LFAPTE@PDCA@P@A@PDA@LCA XEAPPC@0PEAPXF@0LDA@PDA@PDA@PD@0XEAPTDA@TEAPXCA@PDA@PD
A@PDA@PD@0PEAPTEAPTEAPPCA@PDA@PDA@PDA@PCA@TAA TEAPTF@PTD@0PDA@PDA@PDA@PCA DC@0PEAPPC@0DF@0PDA@PDA@PDA@PD@0LDA@LD@PLDA@LC
A@PDA@PDA@PDA@PDA@PDA@LD@PLDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@0PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD') colorMapFromArray:#[255 189 23 127 127 127 236 233 216 0 0 0 255 255 255 194 194 194 161 161 165] mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@A @@C0@@33@A?? A?? @??@@??@C??0G??8G??8C??0@??@@??@A?? A?? @33@@C0@@A @@@@@@@@@@@@@'); yourself); yourself]
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::GeneralCompilerSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::GeneralCompilerSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::GeneralCompilerSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'General Compiler Settings'
         name: 'General Compiler Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 600 320)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Catch Method Redefinitions'
                   name: 'CatchMethodRedefinitions'
                   activeHelpKey: catchMethodRedefinition
                   model: catchMethodRedefs
                   translateLabel: true
                   extent: (Point 600 30)
                 )
                (CheckBoxSpec
                   label: 'Catch Class Redefinitions'
                   name: 'CatchClassRedefinitions'
                   activeHelpKey: catchClassRedefinition
                   model: catchClassRedefs
                   translateLabel: true
                   extent: (Point 600 30)
                 )
                (DividerSpec
                   name: 'Separator2'
                   extent: (Point 600 3)
                 )
                (CheckBoxSpec
                   label: 'Keep History Line in Methods'
                   name: 'KeepHistoryLineinMethods'
                   activeHelpKey: historyLineInMethods
                   model: historyLines
                   translateLabel: true
                   extent: (Point 600 30)
                 )
                (CheckBoxSpec
                   label: 'Keep Full Class History'
                   name: 'KeepFullClassHistory'
                   activeHelpKey: historyLineInClasses
                   enableChannel: hasHistoryManager
                   model: fullHistoryUpdate
                   translateLabel: true
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'Box2'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Username in History:'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 0 0 200 0 30 0)
                         activeHelpKey: userNameInHistoryLine
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         layout: (LayoutFrame 200 0 0 0 347 0 30 0)
                         activeHelpKey: userNameInHistoryLine
                         model: userNameInHistoryHolder
                         immediateAccept: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: false
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(empty for login-name)'
                         name: 'Label2'
                         layout: (LayoutFrame 354 0 0 0 0 1 30 0)
                         activeHelpKey: userNameInHistoryLine
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (DividerSpec
                   name: 'Separator3'
                   extent: (Point 600 3)
                 )
                (ViewSpec
                   name: 'Box1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'FileIn Source Mode:'
                         name: 'FileInSourceModeLabel'
                         layout: (AlignmentOrigin 282 0 15 0 1 0.5)
                         activeHelpKey: fileInSourceMode
                         translateLabel: true
                         adjust: right
                       )
                      (PopUpListSpec
                         label: 'PopUp List'
                         name: 'KeepSourceSelection'
                         layout: (LayoutFrame 279 0 1 0 -5 1 30 0)
                         activeHelpKey: fileInSourceMode
                         translateLabel: true
                         tabable: true
                         model: keepSourceSelection
                         menu: keepSource
                         useIndex: true
                       )
                      )

                   )
                   extent: (Point 600 32)
                 )
                (DividerSpec
                   name: 'Separator1'
                   extent: (Point 600 3)
                 )
                (CheckBoxSpec
                   label: 'If Present, Load Binary Objects when Autoloading'
                   name: 'LoadBinaryObjectsWhenAutoloading'
                   activeHelpKey: loadBinaryObjectsWhenAutoloading
                   enableChannel: canLoadBinaries
                   model: loadBinaries
                   translateLabel: true
                   extent: (Point 600 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl methodsFor:'actions'!

basicReadSettings
    self keepSourceSelection
        value:(self class keepSourceOptions
                indexOf:ClassCategoryReader sourceMode
                ifAbsent:1).
    self catchClassRedefs value:(Class catchClassRedefinitions ? false).
    self catchMethodRedefs value:(Class catchMethodRedefinitions ? false).

    self canLoadBinaries value ifTrue:[
        self loadBinaries value:Smalltalk loadBinaries
    ] ifFalse:[
        self loadBinaries value:false
    ].

    self hasHistoryManager ifTrue:[
        self fullHistoryUpdate value:(HistoryManager fullHistoryUpdate ? false)
    ] ifFalse:[
        self fullHistoryUpdate value:false
    ].
    self historyLines value:self hasHistoryManager.
    self userNameInHistoryHolder value:(UserPreferences current historyManagerSignature).

    "Modified: / 04-08-2010 / 18:34:15 / cg"
    "Modified: / 08-07-2011 / 10:26:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings
    |nm|

    ClassCategoryReader sourceMode:(self class keepSourceOptions at:self keepSourceSelection value).
    Class catchClassRedefinitions:(self catchClassRedefs value).
    Class catchMethodRedefinitions:(self catchMethodRedefs value).
    HistoryManager notNil ifTrue:[
        HistoryManager fullHistoryUpdate:(self fullHistoryUpdate value).
        self historyLines value ifTrue:[
            HistoryManager activate
        ] ifFalse:[
            HistoryManager deactivate
        ].
        UserPreferences current historyManagerEnabled:(self historyLines value).
        nm := (self userNameInHistoryHolder value ? '') withoutSeparators asNilIfEmpty.
        UserPreferences current historyManagerSignature:nm.
    ].
    Smalltalk loadBinaries:(self loadBinaries value).

    "Modified: / 04-08-2010 / 18:33:20 / cg"
    "Modified: / 08-07-2011 / 10:26:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl methodsFor:'aspects'!

canLoadBinaries

    canLoadBinaries isNil ifTrue:[
        canLoadBinaries := (ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles]) asValue.
    ].
    ^ canLoadBinaries.
!

catchClassRedefs

    catchClassRedefs isNil ifTrue:[
        catchClassRedefs := (Class catchClassRedefinitions ? false) asValue.
        catchClassRedefs onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ catchClassRedefs.
!

catchMethodRedefs

    catchMethodRedefs isNil ifTrue:[
        catchMethodRedefs := (Class catchMethodRedefinitions ? false) asValue.
        catchMethodRedefs onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ catchMethodRedefs.
!

fullHistoryUpdate

    fullHistoryUpdate isNil ifTrue:[
        self hasHistoryManager ifTrue:[
            fullHistoryUpdate := (HistoryManager fullHistoryUpdate ? false) asValue.
        ] ifFalse:[
            fullHistoryUpdate := false asValue.
        ].
        fullHistoryUpdate onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ fullHistoryUpdate.
!

hasHistoryManager

    ^ HistoryManager notNil and:[HistoryManager isLoaded and:[HistoryManager isActive]]
!

historyLines

    historyLines isNil ifTrue:[
        historyLines := self hasHistoryManager asValue.
        historyLines onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ historyLines.
!

keepSource

    keepSource isNil ifTrue:[
        keepSource := (resources array:(self class keepSourceStrings)) asList.
    ].
    ^ keepSource.
!

keepSourceSelection

    keepSourceSelection isNil ifTrue:[
        keepSourceSelection := (self class keepSourceOptions indexOf:ClassCategoryReader sourceMode ifAbsent:1) asValue.
        keepSourceSelection onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ keepSourceSelection.
!

loadBinaries

    loadBinaries isNil ifTrue:[
        self canLoadBinaries value ifTrue:[
            loadBinaries:=  Smalltalk loadBinaries asValue
        ] ifFalse:[
            loadBinaries:=  false asValue
        ].
        loadBinaries onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ loadBinaries.

    "Modified: / 04-08-2010 / 18:34:56 / cg"
!

userNameInHistoryHolder

    userNameInHistoryHolder isNil ifTrue:[
        userNameInHistoryHolder := '' asValue.
        userNameInHistoryHolder onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ userNameInHistoryHolder.

    "Modified: / 04-08-2010 / 18:37:53 / cg"
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/compilerSettings.html'
! !

!AbstractSettingsApplication::GeneralCompilerSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    ((HistoryManager fullHistoryUpdate ? false) ~= self fullHistoryUpdate value) ifTrue:[^ true].
    ((ClassCategoryReader sourceMode) ~= (self class keepSourceOptions at:self keepSourceSelection value)) ifTrue:[^ true].
    ((Class catchMethodRedefinitions ? false) ~= self catchMethodRedefs value) ifTrue:[^ true].
    ((Class catchClassRedefinitions ? false) ~= self catchClassRedefs value) ifTrue:[^ true].
    ((Smalltalk loadBinaries ? false) ~= self loadBinaries value) ifTrue:[^ true].
    ((self hasHistoryManager) ~= self historyLines value) ifTrue:[^ true].
    (UserPreferences current historyManagerSignature ~= self userNameInHistoryHolder value) ifTrue:[^ true].
    ^ false.

    "Modified: / 04-08-2010 / 18:31:55 / cg"
    "Modified: / 08-07-2011 / 10:25:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::HTTPStartServerSettingsApplication
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#createFCGIServer
'Create (but do not start) a new FCGI server.\FCGI allows for a Smalltalk server to run under a master server (such as Apache)'

#createServer
'Create (but do not start) a new web server on the specified port (usually 8080 or 80).'

#createServerFromSettingsFile
'Create (but do not start) a new server and all services as specified in a settings file'

#loadWebServerPackage
'Load the missing webserver class packages'

#removeAllServers
'Stop and remove all defined servers'

#serverPortNumber
'The port on which the created server should listen (usually 8080, 8081 or 80)'

)
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::HTTPStartServerSettingsApplication defaultIcon'
        ifAbsentPut:[(Depth8Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@DB@0PC@0HBAP@@@@@@@@@@@@@@@@TFA0 IB ,KB00E@@@@@@@@@@@@@@4NC1@QD!!LKB08KE@T@@@@@@@@@@@TUE!!\PDA@XFQ(NF10]AP@@@@@@@@DF
BQ8PDA@PDAH_E $HE"@@@@@@@@@BHP$VDA@PB00"H2P$IRX''J@@@@@@@JR(WG!!@PB2,+J2,+J2,+J2,+@@@@@@P,DA@PDB,-K"4-K2</K24(L@@@@@@1L#L3
DQ@+K"8.K"84MR86AS@@@@@@M3 IBP 9J28:N3,<OC4(O T0@@@@@C<*BP$IPB,6O#8>O#8>O#XEL@@@@@@APSHIBQ\+K"8.K"8.KR >AS@@@@@@K!!P2BQ8P
J28.K"8.K" (M T0@@@@@@@-EDHQDB-CP4MCP4MCP4PEL@@@@@@@@B9EQ!!@+KT\:N#(:N"4.AS@@@@@@@@@@K$!!IJ29JK2</K2<-M T0@@@@@@@@@@@@K",.
K2</K2</KSXEL@@@@@@@@@@@@@@+K"<AJB (JB46AS@@@@@@@@@@@@@@J28/@@@@@@@/M T0@@@@@@@@@@@@@B,.R41LSD1LSSXEL@@@@@@@@@@@@@@+K#8(
JB (JCX6AS@@@@@@@@@@@@@@J28AM#XAJCX(M T0@@@@@@@a')
            colorMapFromArray:#[0 0 0 144 144 144 112 144 112 16 96 16 0 80 0 128 128 128 0 144 0 0 112 64 0 224 16 0 240 0 0 64 160 16 16 224 64 64 192 128 144 128 0 160 0 0 208 32 0 0 240 0 32 208 0 112 128 0 0 224 48 48 96 0 128 32 0 96 128 0 80 160 0 16 224 0 208 0 64 112 64 32 128 32 0 96 112 48 48 112 0 96 144 0 192 32 48 48 64 0 192 0 64 112 144 64 96 144 64 192 64 64 160 96 64 128 112 80 96 80 160 160 160 16 32 64 0 48 192 96 96 96 0 160 80 208 208 208 192 192 192 224 224 224 48 48 48 0 16 48 0 64 176 0 176 64 192 176 192 176 192 176 176 176 176 0 0 80 0 144 80 0 32 192 16 16 16 208 192 208 208 144 144 96 192 96 176 160 176 48 48 128 0 112 112 0 0 144 0 144 64 160 160 64 144 144 80 48 112 48 0 0 208 208 208 224 48 48 80 32 32 144 224 208 224 176 176 224 176 176 240 192 176 208]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'C? @G?0@O?8@_?<@??<@??>@???@???@???@???@???@???@???@_??@O??@G??@A??@@??@@??@@??@@??@@??@'); yourself); yourself]
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::HTTPStartServerSettingsApplication andSelector:#windowSpec
     AbstractSettingsApplication::HTTPStartServerSettingsApplication new openInterface:#windowSpec
     AbstractSettingsApplication::HTTPStartServerSettingsApplication open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'HTTP Server Settings'
         name: 'HTTP Server Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 539 630)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (VerticalPanelViewSpec
                   name: 'VerticalPanel4'
                   horizontalLayout: fit
                   verticalLayout: topSpace
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'InfoMessageBox'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Label'
                               name: 'Label2'
                               layout: (LayoutFrame 5 0.0 0 0.0 -5 1 0 1.0)
                               translateLabel: true
                               labelChannel: informationLabel
                               resizeForLabel: false
                               adjust: left
                             )
                            (ActionButtonSpec
                               label: 'Load Missing WebServer Packages'
                               name: 'Button8'
                               layout: (AlignmentOrigin 0 0.5 0 1 0.5 1)
                               activeHelpKey: loadWebServerPackage
                               visibilityChannel: hasWebServerClassesNotLoadedHolder
                               translateLabel: true
                               tabable: true
                               model: loadWebServerPackages
                             )
                            )

                         )
                         extent: (Point 539 200)
                       )
                      (ViewSpec
                         name: 'Separator'
                         extent: (Point 539 20)
                       )
                      (ViewSpec
                         name: 'ActionButtonBox'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Port:'
                               name: 'Label1'
                               layout: (LayoutFrame 5 0 21 0 57 0 49 0)
                               activeHelpKey: serverPortNumber
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'EntryField1'
                               layout: (LayoutFrame 57 0 20 0 128 0 48 0)
                               activeHelpKey: serverPortNumber
                               enableChannel: hasWebServerClassesLoadedHolder
                               model: portNumberChannel
                               type: number
                               immediateAccept: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: false
                             )
                            (VerticalPanelViewSpec
                               name: 'VerticalPanel5'
                               layout: (LayoutFrame 136 0 14 0 -12 1 0 1)
                               horizontalLayout: fit
                               verticalLayout: topSpace
                               horizontalSpace: 3
                               verticalSpace: 3
                               component:
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Create new HTTP Server'
                                     name: 'Button4'
                                     activeHelpKey: createServer
                                     translateLabel: true
                                     tabable: true
                                     model: createServer
                                     enableChannel: hasWebServerClassesLoadedHolder
                                     useDefaultExtent: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Create new FastCGI Server'
                                     name: 'Button7'
                                     activeHelpKey: createFCGIServer
                                     translateLabel: true
                                     tabable: true
                                     model: createFcgiServer
                                     enableChannel: hasWebServerClassesLoadedHolder
                                     useDefaultExtent: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Create Server from Settings File...'
                                     name: 'Button6'
                                     activeHelpKey: createServerFromSettingsFile
                                     translateLabel: true
                                     tabable: true
                                     model: createServerFromFile
                                     enableChannel: hasWebServerClassesLoadedHolder
                                     useDefaultExtent: true
                                   )
                                  (ActionButtonSpec
                                     label: 'Remove all Servers'
                                     name: 'Button5'
                                     activeHelpKey: removeAllServers
                                     translateLabel: true
                                     tabable: true
                                     model: removeAllServers
                                     enableChannel: hasCreatedServerChannel
                                     useDefaultExtent: true
                                   )
                                  )

                               )
                             )
                            )

                         )
                         extent: (Point 539 160)
                       )
                      )

                   )
                   extent: (Point 539 620)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication class methodsFor:'servers access'!

addCreatedServer:aServer
    self createdServers add:aServer.
!

createdServers
    CreatedServers isNil ifTrue:[
        CreatedServers := Set new.
    ].
    ^ CreatedServers
!

removeAllCreatedServer
    self createdServers removeAll.
!

removeCreatedServer:aServer
    self createdServers remove:aServer ifAbsent:nil.
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication methodsFor:'actions'!

basicReadSettings
    |serverClass|

    serverClass := self serverClass.
    (serverClass notNil and:[serverClass isLoaded]) ifTrue:[
        self serverClass runningServers
            removeDependent:self;
            addDependent:self.
    ].
    self createServerSubApplicationsForRunningServers.
    self createdServerChanged.

    "Modified: / 25-01-2007 / 16:41:27 / cg"
!

basicSaveSettings
    "nothing done here"

    ^ self
!

createFcgiServer
    "create a FastCGI server"

    FCGIServer isNil ifTrue:[
        self warn:'The FCGIServer-class is missing - cannot create server.'.
        ^ self.
    ].
    ^ self createServerForClass:FCGIServer.

    "Modified: / 26-11-2006 / 13:12:14 / cg"
!

createServer
    "create a default server - i.e. a HTTP server"

    HTTPServer isNil ifTrue:[
        self warn:'The HTTPServer-class is missing - cannot create server.'.
        ^ self.
    ].
    ^ self createServerForClass:self serverClass.

    "Modified: / 09-04-2011 / 11:15:52 / cg"
!

createServerApplicationFor:aServerInstance
    |settingsApp itemPathName newItem openApps|

    "/ settingsDialog isNil ifTrue:[^ self].

    openApps := settingsDialog getAllChildrenAppsForApplication:self childrenClass:HTTPServerSettingsAppl.
    (openApps contains:[:app | app httpServerInstance == aServerInstance]) ifTrue:[
        " already have an Item for this application "
        ^ self
    ].
    HTTPServerSettingsAppl isNil ifTrue:[
        Smalltalk loadPackage:'stx:goodies/webServer/ui'.
        HTTPServerSettingsAppl isNil ifTrue:[
            self warn:'Missing settings application: HTTPServerSettingsAppl'.
            ^ self.
        ].
    ].

    settingsApp := HTTPServerSettingsAppl basicNew.
    settingsApp settingsDialog:settingsDialog.
    settingsApp httpServerInstance:aServerInstance.
    settingsApp defaultSettingsApplication:false.
    settingsApp basicInitialize.
    itemPathName := self itemPathName , '/', settingsApp nameInSettingsDialog.
    newItem := settingsDialog addApplClass:#'HTTPServerSettingsAppl' withName:itemPathName.
    newItem application:settingsApp.
    self createdServerChanged.
    settingsDialog expandItemForApplication:self.
    settingsApp readSettings.
    settingsApp initialize.

    "Modified: / 09-04-2011 / 11:17:44 / cg"
!

createServerForClass:serverClass

    |newServer port runningServers|

    serverClass isNil ifTrue:[
        self warn:'The server class is missing - cannot create server.'.
        ^ self.
    ].

    self withWaitCursorDo:[
        port := self portNumberChannel value.
        runningServers := serverClass runningServers.

        runningServers do:[:aServer |
            aServer port = port asInteger ifTrue:[
                Dialog warn:'There is already a server for port ', port asString.
                ^ self
            ]
        ].
        runningServers addDependent:self.

        (port = serverClass defaultPort) ifTrue:[
            newServer := serverClass newServerWithDefaultServiceListOn:port.
        ] ifFalse:[
            newServer := serverClass newServerOnPort:port.
        ].
        self class addCreatedServer:newServer.
        self createServerApplicationFor:newServer.
    ]
!

createServerFromFile
    |serverClass newServer fileName runningServers newServerPort answer|

    serverClass := self serverClass.
    fileName := Dialog requestFileName:'Select a Server Settings File'
            default:(serverClass settingsFilename)
            pattern:'*.xml'.

    fileName isEmptyOrNil ifTrue:[ ^ self].
    self withWaitCursorDo:[
        newServer := serverClass serverFromSettingsFile:(fileName asFilename).
        newServer notNil ifTrue:[
            newServerPort := newServer port.
            runningServers := serverClass runningServers.
            runningServers notEmpty ifTrue:[
                [self hasServerForPort:newServerPort] whileTrue:[
                    answer := Dialog
                        request:('There is already a server for port <1p>. Please select another one' expandMacrosWith:newServerPort)
                        initialAnswer:self portNumberChannel value printString.
                    answer isEmptyOrNil ifTrue:[
                        ^ self
                    ].
                    newServerPort := Number readFromString:answer.
                ]
            ].
            newServer port:newServerPort.
            runningServers addDependent:self.
            self class addCreatedServer:newServer.
            self createServerApplicationFor:newServer.
        ].
    ].

    "Modified: / 25-01-2007 / 16:40:57 / cg"
!

createServerSubApplicationsForRunningServers
    |serverToStart serverClass|

    serverClass := self serverClass.

    (serverClass notNil and:[ serverClass isLoaded ]) ifFalse:[
        ^ self
    ].

    serverToStart := serverClass runningServers asNewSet.
    serverToStart addAll:self class createdServers.
    serverToStart isEmpty ifTrue:[
        ^ self
    ].
    serverToStart := serverToStart select:[:s | s port notNil].
    serverToStart := serverToStart asSortedCollection:[:a :b | a port < b port].
    serverToStart do:[:eachServerInstance |
        self createServerApplicationFor:eachServerInstance.
    ]

    "Modified: / 26-08-2012 / 10:25:23 / cg"
!

hasServerForPort:newServerPort
    |serverClass|

    serverClass := self serverClass.
    ^ serverClass notNil
      and:[ serverClass runningServers
                contains:[:eachServer| eachServer port = newServerPort]].

    "Modified: / 25-01-2007 / 16:39:48 / cg"
!

loadWebServerPackages
    Smalltalk loadPackage:'stx:goodies/webServer'.
    Smalltalk loadPackage:'stx:goodies/webServer/htmlTree'.
    Smalltalk loadPackage:'stx:goodies/webServer/comanche'.
    Smalltalk loadPackage:'stx:goodies/webServer/ui'.
    self hasWebServerClassesNotLoadedHolder value:(self hasWebServerClassesLoaded not).
!

removeAllServerSubApplications
    "/ settingsDialog isNil ifTrue:[^ self].

    settingsDialog removeAllSubApplicationsFor:self
!

removeAllServers
    |serverClass|

    serverClass := self serverClass.
    serverClass isLoaded ifTrue:[
        serverClass terminateAllServers.
    ].
    self class removeAllCreatedServer.
    self removeAllServerSubApplications.
    self createdServerChanged.

    "Modified: / 25-01-2007 / 16:39:10 / cg"
!

setPortOnFreePort
    |serverClass highestUsedPortNr portToUse instances|

    "/ settingsDialog isNil ifTrue:[^ self].

    serverClass := self serverClass.
    (serverClass notNil and:[serverClass isLoaded]) ifTrue:[
        instances := serverClass runningServers asNewSet.
        instances addAll:((settingsDialog getAllChildrenAppsForApplication:self)
                          collect:[:aApp| aApp httpServerInstance]).
        instances := instances select:[:i | i port notNil].
        highestUsedPortNr := instances
                                inject:(serverClass defaultPort - 1)
                                into:[:maxSoFar :thisServer | thisServer port max:maxSoFar].

        portToUse := highestUsedPortNr + 1
    ] ifFalse:[
        portToUse := 8080
    ].
    self portNumberChannel value:portToUse.

    "Modified: / 26-08-2012 / 10:26:20 / cg"
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication methodsFor:'aspects'!

hasCreatedServerChannel
    hasCreatedServerChannel isNil ifTrue:[
        hasCreatedServerChannel := true asValue.
    ].
    ^ hasCreatedServerChannel.
!

hasWebServerClassesLoaded
    ^ self hasHTTPServerClass and:[self hasFCGIServerClass].
!

hasWebServerClassesLoadedHolder
    ^ BlockValue forLogicalNot:(self hasWebServerClassesNotLoadedHolder)
!

hasWebServerClassesNotLoadedHolder
    hasWebServerClassesNotLoadedHolder isNil ifTrue:[
        hasWebServerClassesNotLoadedHolder := true asValue.
        hasWebServerClassesNotLoadedHolder value:(self hasWebServerClassesLoaded not).
    ].
    ^ hasWebServerClassesNotLoadedHolder.
!

informationLabel
    |info|

    info := resources
        string:'HTTPSTARTINFO'
        default:
'This dialog enables you to create (possibly multiple) HTTP Server processes.
(i.e. it is possible to serve multiple ports)

Once created, select the individual server in the left tree,
configure its services, and finally start it up.'.

    self hasHTTPServerClass ifFalse:[
        info := info ,
                '\\' withCRs,
                (resources string:'ATTENTION: Disabled because HTTPServer class is missing.') allBold
    ].
    ^ info

    "Modified: / 14-05-2012 / 12:35:46 / cg"
!

portNumberChannel

    portNumberChannel isNil ifTrue:[
        portNumberChannel := ValueHolder new.
    ].
    ^ portNumberChannel.
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication methodsFor:'change & update'!

createdServerChanged

    self hasCreatedServerChannel value:self hasCreatedServer.
    self setPortOnFreePort.
!

runningServersChanged
    self createServerSubApplicationsForRunningServers.
    self setPortOnFreePort.
!

update:something with:aParameter from:changedObject
    |serverClass|

    serverClass := self serverClass.
    (serverClass isLoaded and:[changedObject == serverClass runningServers]) ifTrue:[
        self runningServersChanged.
        ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 25-01-2007 / 16:38:52 / cg"
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication methodsFor:'help'!

helpFilename
    ^ 'HTTPServer/index.html'
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication methodsFor:'initialization & release'!

release
    |serverClass|

    serverClass := self serverClass.
    (serverClass notNil and:[serverClass isLoaded]) ifTrue:[
        serverClass runningServers removeDependent:self.
    ].
    super release

    "Modified: / 25-01-2007 / 16:39:23 / cg"
! !

!AbstractSettingsApplication::HTTPStartServerSettingsApplication methodsFor:'queries'!

hasCreatedServer
    "/ settingsDialog isNil ifTrue:[^ false].
    ^ (settingsDialog getAllChildrenAppsForApplication:self childrenClass:HTTPServerSettingsAppl)
        notEmpty
!

hasFCGIServerClass
    ^ FCGIServer notNil

    "Created: / 25-01-2007 / 17:50:14 / cg"
!

hasHTTPServerClass
    ^ self serverClass notNil

    "Created: / 25-01-2007 / 17:50:03 / cg"
!

hasUnsavedChanges

    ^ false
!

isEnabledInSettingsDialog:aSettingsDialog
    ^ true
"/    ^ self serverClass notNil
"/    or:[ HTTPServer notNil
"/    or:[ FCGIServer notNil ]]

    "Created: / 25-01-2007 / 16:48:18 / cg"
    "Modified: / 25-01-2007 / 17:49:24 / cg"
!

serverClass
    "answer the default class for instantiating servers.
     Note that we may instantiate FCGIServer as well"

    ^ HTTPServer
!

whyDisabledInSettingsDialogInfo
    ^ 'there is no HTTPServer class in the system'

    "Created: / 25-01-2007 / 17:16:46 / cg"
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MemorySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#rawKeyList
'Select an entry from this list of keys, to see the associated function in the right list.\To change, check the "Change" toggle below, then select the function to assign,\and finally press the "Apply" button'

#functionKeyList
'Select an entry from this function list, to see the raw key which invokes this function.\To change, check the "Change" toggle below, select a rawkey+function combinarion,\and finally press the "Apply" button'

#'changeMap'
'Switch between "display" and "modify" mode.\If checked, you can select a combination and assign the key-function combination with the "Apply" button.\If not checked, either list show''s the other''s associated entry'

#'applyChange'
'Adds the current key-function combination to the keyboard map'

#saveMapAs
'Save the current keyboard map to an alternative keyboard setup file.\This can be loaded via fileIn or shared with other users.'

)
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary keyboardMappingIcon
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::KbdMappingSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::KbdMappingSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::KbdMappingSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Keyboard Mapping Settings'
         name: 'Keyboard Mapping Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 482 654)
       )
       component:
      (SpecCollection
         collection: (
          (TextEditorSpec
             name: 'Text'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 100 0)
             enableChannel: false
             model: labelTextHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             miniScrollerVertical: true
             isReadOnly: true
             hasKeyboardFocusInitially: false
             postBuildCallback: postBuildHelpLabel:
             viewClassName: 'TextView'
           )
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0.0 100 0 0 1.0 0 1.0)
             component:
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'VariableHorizontalPanel1'
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box2'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Key'
                               name: 'Label1'
                               layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                               translateLabel: true
                             )
                            (SequenceViewSpec
                               name: 'RawKeyList'
                               layout: (LayoutFrame 0 0 30 0 0 1 -30 1)
                               activeHelpKey: rawKeyList
                               model: selectedRawKey
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               useIndex: false
                               sequenceList: rawKeyList
                             )
                            (ViewSpec
                               name: 'Box4'
                               layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Modify'
                                     name: 'CheckBox1'
                                     layout: (LayoutFrame 0 0 7 0 136 0 29 0)
                                     activeHelpKey: changeMap
                                     model: changeMapHolder
                                     translateLabel: true
                                   )
                                  (InputFieldSpec
                                     name: 'EntryField1'
                                     layout: (LayoutFrame 136 0 7 0 0 1 29 0)
                                     visibilityChannel: changeMapHolder
                                     model: currentKeyHolder
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnPointerLeave: true
                                   )
                                  )

                               )
                             )
                            )

                         )
                       )
                      (ViewSpec
                         name: 'Box3'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Function'
                               name: 'Label2'
                               layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                               translateLabel: true
                             )
                            (SequenceViewSpec
                               name: 'FunctionKeyList'
                               layout: (LayoutFrame 0 0 30 0 0 1 -30 1)
                               activeHelpKey: functionList
                               model: selectedFunctionKey
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               useIndex: false
                               sequenceList: functionKeyList
                             )
                            (HorizontalPanelViewSpec
                               name: 'HorizontalPanel1'
                               layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
                               horizontalLayout: fitSpace
                               verticalLayout: center
                               component:
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Apply'
                                     name: 'Button1'
                                     activeHelpKey: applyChange
                                     visibilityChannel: changeMapHolder
                                     translateLabel: true
                                     model: applyMapChange
                                     extent: (Point 125 22)
                                   )
                                  (ActionButtonSpec
                                     label: 'Save As...'
                                     name: 'Button2'
                                     activeHelpKey: saveMapAs
                                     visibilityChannel: changeMapHolder
                                     translateLabel: true
                                     model: saveMapAs
                                     extent: (Point 125 22)
                                   )
                                  )

                               )
                             )
                            )

                         )
                       )
                      )

                   )
                   handles: (Any 0.5 1.0)
                 )
                (ViewSpec
                   name: 'Box1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Macro text (if any):'
                         name: 'MacroTextLabel'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 30 0)
                         translateLabel: true
                         adjust: left
                       )
                      (TextEditorSpec
                         name: 'MacroText'
                         layout: (LayoutFrame 0 0.0 30 0 0 1.0 0 1.0)
                         activeHelpKey: macroText
                         model: macroTextHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                       )
                      )

                   )
                 )
                )

             )
             handles: (Any 0.5 1.0)
           )
          )

       )
     )
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl methodsFor:'actions'!

applyMapChange
    |rawKey function|

    rawKey := self currentKeyHolder value asSymbol.
    function := self selectedFunctionKey value asSymbol.

    function = (resources string:'* unassigned *') ifTrue:[
        mappings removeKey:rawKey
    ] ifFalse:[
        mappings at:rawKey put:function.
    ].
    self updateModifiedChannel.
!

basicReadSettings
    |screenMap rawKeys logicalKeys|

    screenMap := Screen current keyboardMap.
    mappings := screenMap copy.

    rawKeys := (mappings mappedKeys collect:[:key | key asString] as:Array) sort.
    logicalKeys := (rawKeys collect:[:rawKey | (mappings mappingFor: rawKey asSymbol) asString] as:Set) asOrderedCollection sort.
    logicalKeys addFirst:(resources string:'* unassigned *').


    self rawKeyList contents: rawKeys.
    self functionKeyList contents: logicalKeys.

    self changeMapHolder value:false.

    "Modified: / 11-09-2017 / 14:47:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings
    self saveMapAs:(Filename applicationDataDirectory construct:'private_keyboard.rc')
!

saveMapAs
    "invoked via save as button"

    |fn|

    fn := Dialog
            requestFileName:'Save private keyboard settings in:'
            default:'private_keyboard.rc'
            fromDirectory:(Filename applicationDataDirectory).
    fn isEmptyOrNil ifTrue:[ ^ self ].
    self saveMapAs:fn asFilename.
!

saveMapAs:aFilename
    aFilename writingFileDo:[:s |
        s nextPutLine:'|map|'.
        s nextPutLine:'map := Screen current keyboardMap.'.
        mappings keysAndValuesDo:[:eachKey :eachFunction |
            s nextPutLine:('map at:%1 put:%2.' bindWith:eachKey storeString with:eachFunction storeString).
        ].
    ].
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl methodsFor:'aspects'!

changeMapHolder
    changeMapHolder isNil ifTrue:[
        changeMapHolder := false asValue.
    ].
    ^ changeMapHolder.
!

currentKeyHolder
    currentKeyHolder isNil ifTrue:[
        currentKeyHolder := nil asValue.
    ].
    ^ currentKeyHolder.
!

functionKeyList
    functionKeyList isNil ifTrue:[
        functionKeyList := List new.
    ].
    ^ functionKeyList.
!

labelTextHolder
    labelTextHolder isNil ifTrue:[
        labelTextHolder := ValueHolder new.
    ].
    ^ labelTextHolder.
!

macroTextHolder
    macroTextHolder isNil ifTrue:[
        macroTextHolder := ValueHolder new.
    ].
    ^ macroTextHolder.
!

rawKeyList

    rawKeyList isNil ifTrue:[
        rawKeyList := List new.
    ].
    ^ rawKeyList.
!

selectedFunctionKey

    selectedFunctionKey isNil ifTrue:[
        selectedFunctionKey := ValueHolder new.
        selectedFunctionKey addDependent:self.
    ].
    ^ selectedFunctionKey.
!

selectedRawKey

    selectedRawKey isNil ifTrue:[
        selectedRawKey := ValueHolder new.
        selectedRawKey addDependent:self.
    ].
    ^ selectedRawKey.
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl methodsFor:'change & update'!

changeFunctionKeySelection
    |raw|

    raw := self selectedRawKey value.
    self selectedFunctionKey value:(mappings mappingFor:raw asSymbol) asString  withoutNotifying:self.

    "Modified: / 11-11-2010 / 06:50:04 / cg"
    "Modified: / 24-05-2017 / 21:32:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMacroText

    |f macro indent|

    f := self selectedFunctionKey value.
    (f startsWith:'Cmd') ifTrue:[
        f := f copyFrom:4
    ].
    macro := currentUserPrefs functionKeySequences
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
    macroTextHolder value:macro.
!

changeRawKeySelection
    |logicalKey rawKey|

    logicalKey := self selectedFunctionKey value.
    rawKey := mappings bindingForLogical:logicalKey asSymbol.
    rawKey isNil ifTrue:[
        | aliases |

        aliases := mappings aliasesForLogical:logicalKey.
        aliases notEmptyOrNil ifTrue:[
            rawKey := aliases first.
        ].
    ].
    self selectedRawKey value:rawKey withoutNotifying:self.

    "Modified: / 11-11-2010 / 06:49:56 / cg"
    "Modified: / 24-05-2017 / 21:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    changedObject == self selectedFunctionKey ifTrue:[
        changeMapHolder value ifFalse:[
            self changeRawKeySelection.
        ].
        self changeMacroText.
        ^ self
    ].
    changedObject == self selectedRawKey ifTrue:[
        changeMapHolder value ifFalse:[
            self changeFunctionKeySelection.
        ].
        self currentKeyHolder value:changedObject value.
        ^ self
    ].
    super update:something with:aParameter from:changedObject
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/keyboardSetting.html'
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl methodsFor:'initialization & release'!

initialize

    super initialize.

    self labelTextHolder value:(resources at:'KEY_MSG' default:'keyboard mapping:') withCRs.
!

postBuildHelpLabel:aWidget
    aWidget level:0.
    aWidget scrolledView backgroundColor:self window viewBackground.
    aWidget font:(Label defaultFont).
! !

!AbstractSettingsApplication::KbdMappingSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    ^ mappings ~= Screen current keyboardMap.
! !

!AbstractSettingsApplication::LanguageSettingsAppl class methodsFor:'font specs'!

bigLabelFont
    <resource: #fontSpec>

    ^ Label defaultFont asBold
! !

!AbstractSettingsApplication::LanguageSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::LanguageSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#currentFlagAndLanguage
'Currently used language'

#useSystemLanguage
'If checked, the operating system locale is used and settings. If unchecked, the language set below us used (defaulting to system locale)'

)
! !

!AbstractSettingsApplication::LanguageSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary languagesIcon
! !

!AbstractSettingsApplication::LanguageSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::LanguageSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::LanguageSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::LanguageSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       uuid: '5d0ce99a-d630-4c46-88a5-7eaf9ed43a1b'
       window:
      (WindowSpec
         label: 'Language Settings'
         name: 'Language Settings'
         uuid: '14a0f0d8-7cac-48e9-91f7-3622e4fa7eff'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 571 734)
       )
       component:
      (SpecCollection
         collection: (
          (LabelSpec
             label: '  Language'
             name: 'LanguageLabel'
             layout: (LayoutFrame 0 0 0 0 0 1 66 0)
             style: (FontDescription helvetica medium roman 18 #'iso10646-1' nil nil)
             uuid: 'cfdca792-c3f4-40f9-9457-ecd53e0b6b35'
             backgroundColor: (Color 100.0 100.0 100.0)
             translateLabel: true
             adjust: left
           )
          (LabelSpec
             label: 'Label'
             name: 'CurrentLang'
             layout: (LayoutFrame -233 1 0 0 0 1 66 0)
             activeHelpKey: currentFlagAndLanguage
             style: bigLabelFont
             uuid: '8fdf278f-2c62-4850-92b8-064fb124fca6'
             backgroundColor: (Color 100.0 100.0 100.0)
             translateLabel: true
             labelChannel: currentFlagAndLanguageChannel
             adjust: right
           )
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 66 0 0 1 -37 1)
             uuid: '062e716f-660f-4d4a-8e1e-24695fe5af06'
             horizontalLayout: fit
             verticalLayout: topFit
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Use OS Language on Startup'
                   name: 'CheckBox1'
                   activeHelpKey: useSystemLanguage
                   uuid: '20460ac0-eee7-4865-bfac-fc0c75b172dd'
                   model: useSystemLanguageHolder
                   translateLabel: true
                   extent: (Point 571 30)
                 )
                (SequenceViewSpec
                   name: 'List1'
                   uuid: '41d303b2-4b79-43c1-9244-dacaa7b3d354'
                   enableChannel: languageListEnabledHolder
                   model: languageIndexHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   doubleClickSelector: doubleClick:
                   useIndex: true
                   sequenceList: languageListHolder
                   extent: (Point 571 598)
                 )
                (InputFieldSpec
                   name: 'EntryField1'
                   uuid: '0a4aecde-d99d-4ddf-aac7-e9e4f479874b'
                   initiallyInvisible: true
                   model: languageHolder
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: true
                   extent: (Point 567 30)
                 )
                (TextEditorSpec
                   name: 'TextEditor1'
                   uuid: '4d4d5451-7ea9-4b49-a483-ef897eb6b377'
                   initiallyInvisible: true
                   model: noticeLabelHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   miniScrollerHorizontal: true
                   autoHideScrollBars: true
                   isReadOnly: true
                   hasKeyboardFocusInitially: false
                   extent: (Point 571 208)
                   postBuildCallback: postBuildHelpLabel:
                   viewClassName: 'TextView'
                 )
                )

             )
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 0 0 -37 1 0 1 0 1)
             uuid: '51ac05d7-6c95-4d50-931e-216d2cd0fea9'
             horizontalLayout: rightSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Reread Language Resources'
                   name: 'RereadResourcesButton'
                   uuid: '7b6c3b3e-f21f-4775-984b-8c96059f0870'
                   translateLabel: true
                   resizeForLabel: true
                   model: rereadResourceFiles
                   useDefaultExtent: true
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::LanguageSettingsAppl methodsFor:'accessing'!

languageList
    "return the value of the instance variable 'languageList' (automatically generated)"

    ^ languageList
! !

!AbstractSettingsApplication::LanguageSettingsAppl methodsFor:'actions'!

basicReadSettings
    self useSystemLanguageHolder value:(currentUserPrefs useSystemLanguage).
    self languageIndexHolder value:self currentLanguageIndex.
    self languageHolder value:self currentLanguage.
    self currentFlagAndLanguageChannel value:self currentLanguage.

    "Modified: / 24-08-2010 / 18:52:48 / sr"
!

basicSaveSettings
    |fontPref fontPrefs language oldLanguage languageString territory enc
     answer matchingFonts l screen switch dialog anyWrong|

    currentUserPrefs useSystemLanguage:(self useSystemLanguageHolder value).

    self withWaitCursorDo:[
        languageString := translatedLanguages at:(self languageIndexHolder value ? self currentLanguageIndex).
        language := self languageHolder value asString string.
        (language includes:$-) ifTrue:[
            l := language asCollectionOfSubstringsSeparatedBy:$-.
            language := l at:1.
            territory := l at:2.
        ].
        territory isNil ifTrue:[
            territory := language string copyTo:2
        ].

        "/ check if the new language needs a differently encoded font;
        "/ ask user to switch font and allow cancellation.
        "/ Otherwise, you are left with unreadable menu & button items ...

        oldLanguage := currentUserPrefs language.
        currentUserPrefs language:language asSymbol.
        ResourcePack flushCachedResourcePacks.

        "/ refetch resources ...
        resources := AbstractLauncherApplication classResources.
        fontPrefs := resources at:'PREFERRED_FONT_ENCODINGS' default:nil.
        fontPrefs isNil ifTrue:[
            fontPref := resources at:'PREFERRED_FONT_ENCODING' default:nil.
            fontPref isNil ifTrue:[
                fontPrefs := #(#'iso10646-1')
            ] ifFalse:[
                fontPrefs := #(#'iso10646-1') , (Array with:fontPref).
            ]
        ].

        "/ 'normalize' names of encodings
        fontPrefs := fontPrefs collect:[:each | (CharacterEncoder encoderFor:each asLowercase asSymbol ifAbsent:nil)].
        fontPrefs := fontPrefs select:[:each | each notNil] thenCollect:[:each | each nameOfEncoding].
        fontPrefs isEmpty ifTrue:[
            fontPrefs := #(#'iso10464-1')
        ].
        fontPref := fontPrefs first.

        ResourcePack flushCachedResourcePacks.
        resources := AbstractLauncherApplication classResources.

        switch := true.
        anyWrong := false.
        (Array
            with:MenuView defaultFont
            "/ with:ListView defaultFont
            with:EditTextView defaultFont
            with:Button defaultFont)
        do:[:fn |
            enc := fn encoding.
            enc isNil ifFalse:[
                (fontPrefs contains:[:pref | CharacterEncoder isEncoding:pref subSetOf:enc])
                ifFalse:[
                    anyWrong := true
                ].
            ].
        ].
        anyWrong ifTrue:[
            "/ look if there is one at all.
            screen := Screen current.
            matchingFonts := screen listOfAvailableFonts
                                select:[:f | fontPrefs contains:[:pref |
                                                CharacterEncoder
                                                    isEncoding:pref subSetOf:(f encoding ? 'ascii')]].

            matchingFonts isEmpty ifTrue:[
                "/ flush and try again - just in case, the font path has changed.
                screen flushListOfAvailableFonts.
                matchingFonts := screen listOfAvailableFonts
                                    select:[:f | fontPrefs contains:[:pref |
                                                    CharacterEncoder
                                                        isEncoding:pref subSetOf:(f encoding ? 'ascii')]].
            ].
            matchingFonts isEmpty ifTrue:[
                (Dialog
                    confirm:(resources
                                string:'Your display does not seem to offer any appropriate font.\\Change the language anyway ?\ (Texts will probably be unreadable then)'
                                  with:fontPref) withCRs)
                ifFalse:[
                    switch := false
                ]
            ] ifFalse:[
                answer := Dialog
                            confirmWithCancel:(resources
                                                    string:'Some font(s) is not %1-encoded.\\Change it ?'
                                                    with:fontPref) withCRs
                                       labels:(resources
                                                    array:#('Cancel' 'No' 'Yes'))
                                       default:3.
                answer isNil ifTrue:[
                    switch := false
                ] ifFalse:[
                    answer ifTrue:[
                        switch := (AbstractLauncherApplication::LauncherDialogs fontBoxForEncoding:fontPref)
                    ]
                ].
            ].
        ].

        switch ifTrue:[
            currentUserPrefs language:language asSymbol; languageTerritory:(territory ? language) asSymbol.
            ResourcePack flushCachedResourcePacks.
        ].
    ].
    switch ifTrue:[
        (dialog := settingsDialog) notNil ifTrue:[
            dialog reopenLauncher.
        ] ifFalse:[
            NewLauncher current reopenLauncher.
        ].
        DebugView newDebugger.
    ].
    self updateForChangedLanguage.

    "Modified: / 19-10-2006 / 22:17:44 / cg"
    "Modified: / 28-11-2017 / 11:29:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doubleClick:aEntry
    self saveSettingsIfUnsavedChangesArePresent.
!

rereadResourceFiles
    ResourcePack flushCachedResourcePacks.
    perLanguageResources := nil.
    self withWaitCursorDo:[
        self updateForChangedLanguage.
    ].

"/    Smalltalk language:(Smalltalk language).
"/    Smalltalk languageTerritory:(Smalltalk languageTerritory).

    Smalltalk changed:#Language.
    Smalltalk changed:#LanguageTerritory.
!

updateForChangedLanguage
    self initializeLanguages.
    languageListHolder value:languageList.
    self languageListHolder value:languageList.
    self currentFlagAndLanguageChannel value:self currentLanguage.
    self setCurrentLanguageLabel.
    self setNoticeLabel.
!

updateModifiedChannel
    super updateModifiedChannel.
    self useSystemLanguageHolder value ifTrue:[
        self languageListEnabledHolder value: false.
        self languageIndexHolder value: nil
    ] ifFalse:[
        self languageListEnabledHolder value: true.
        self languageIndexHolder value isNil ifTrue:[
            self languageIndexHolder value: self currentLanguageIndex.
        ].
    ].

    "Created: / 19-11-2017 / 10:44:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::LanguageSettingsAppl methodsFor:'aspects'!

currentFlagAndLanguageChannel
    currentFlagAndLanguageChannel isNil ifTrue:[
        currentFlagAndLanguageChannel := self currentLanguage asValue.
    ].
    ^ currentFlagAndLanguageChannel.
!

currentLanguageLabel
    currentLanguageLabel isNil ifTrue:[
        currentLanguageLabel := ValueHolder new.
        self setCurrentLanguageLabel.
    ].
    ^ currentLanguageLabel.
!

languageHolder
    languageHolder isNil ifTrue:[
        languageHolder := self currentLanguage asValue.
        languageHolder onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ languageHolder.
!

languageIndexChanged
    |langIdx|

    langIdx := self languageIndexHolder value ? 1.
    self languageHolder value:(listOfLanguages at:langIdx).
    self updateModifiedChannel.
!

languageIndexHolder
    languageIndexHolder isNil ifTrue:[
        languageIndexHolder := nil asValue.
        self useSystemLanguageHolder value ifFalse:[
            languageIndexHolder := (self currentLanguageIndex) asValue.
        ].
        languageIndexHolder onChangeSend:#languageIndexChanged to:self.
    ].
    ^ languageIndexHolder.

    "Modified: / 19-11-2017 / 10:58:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageListEnabledHolder
    <resource: #uiAspect>

    languageListEnabledHolder isNil ifTrue:[
        languageListEnabledHolder := ValueHolder with: self useSystemLanguageHolder value not.
    ].
    ^ languageListEnabledHolder.

    "Modified: / 19-11-2017 / 10:46:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageListHolder
    languageListHolder isNil ifTrue:[
        languageListHolder := self languageList asValue.
    ].
    ^ languageListHolder.
!

noticeLabelHolder
    noticeLabelHolder isNil ifTrue:[
        noticeLabelHolder := ValueHolder new.
        self setNoticeLabel.
    ].
    ^ noticeLabelHolder.
!

setCurrentLanguageLabel
    currentLanguageLabel notNil ifTrue:[
        currentLanguageLabel value: (resources string:'Current Language:')
    ]

    "Modified: / 19-11-2017 / 11:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNoticeLabel
    noticeLabelHolder
        value: ((resources at:'LANG_MSG' default:'Select a Language') withCRs).
!

useSystemLanguageHolder
    useSystemLanguageHolder isNil ifTrue:[
        useSystemLanguageHolder := true asValue.
        useSystemLanguageHolder onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ useSystemLanguageHolder.
! !

!AbstractSettingsApplication::LanguageSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/languageSetting.html'
! !

!AbstractSettingsApplication::LanguageSettingsAppl methodsFor:'initialization & release'!

initialize
    self initializeLanguages.
    super initialize.
!

initializeLanguages
    |flags enResources enLanguages nativeLanguages
     languages listOfLanguageKeys readLanguagesFile rsc|

    resources := self class classResources.
    listOfLanguages := resources at:'LIST_OF_OFFERED_LANGUAGES' default:#('default' 'en' ).
    listOfLanguages := listOfLanguages asOrderedCollection.
    listOfLanguageKeys := listOfLanguages collect:[:l | l copyReplaceAll:$- with:$_ ].

    (perLanguageResources notNil
    and:[ (perLanguageResources includesKey:#en) not
    and:[ (perLanguageResources includesKey:#'en_us') not ]])
    ifTrue:[
        perLanguageResources := nil.
    ].

    perLanguageResources isNil ifTrue:[
        perLanguageResources := Dictionary new.

        "/ short languages.rs file present?
        rsc := ResourcePack forPackage:'stx:libtool' resourceFileName:'languages.rs' cached:false.
        readLanguagesFile := rsc notNil and:[(rsc at:#languageFileExists ifAbsent:false) == true].

        listOfLanguageKeys do:[:eachLang |
            | myProcess oldPrefs newPrefs lang terr |   

            readLanguagesFile ifFalse:[
                ResourcePack flushCachedResourcePacks.
            ].
            lang := terr := eachLang.
            (lang includes:$_) ifTrue:[
                terr := lang copyFrom:4.
                lang := lang copyTo:2.
            ].
            oldPrefs := UserPreferences current.
            newPrefs := UserPreferences new.
            myProcess := Processor activeProcess.
            newPrefs language: lang; languageTerritory: terr.                
            [
                UserPreferences setCurrent:[ Processor activeProcess == myProcess ifTrue:[ newPrefs ] ifFalse:[ oldPrefs value ] ].                
                readLanguagesFile ifTrue:[
                    rsc := ResourcePack forPackage:'stx:libtool' resourceFileName:'languages.rs' cached:false.
                ] ifFalse:[
                    rsc := ResourcePack for:(self class) cached:false.
                ].
                perLanguageResources at:eachLang asSymbol put:rsc.
            ] ensure:[
                UserPreferences setCurrent: oldPrefs.
            ].
        ].
        readLanguagesFile ifFalse:[
            ResourcePack flushCachedResourcePacks.
        ].
    ].

    enResources := perLanguageResources at:#en ifAbsent:[perLanguageResources at:#'en_us'].

    enLanguages :=
        listOfLanguageKeys
            collect:[:lang |
                |item|

                item := enResources at:('LANG_' , lang) default:nil.
                item isNil ifTrue:[
                    lang
                ] ifFalse:[
                    item isString ifTrue:[
                        item
                    ] ifFalse:[
                        item at:1
                    ]
                ]
            ].

    nativeLanguages :=
        listOfLanguageKeys
            collect:[:lang |
                |item enLang|

                item := enResources at:('LANG_' , lang) default:nil.
                item isNil ifTrue:[
                    enLang := lang
                ] ifFalse:[
                    item isString ifTrue:[
                        enLang := item
                    ] ifFalse:[
                        enLang := item at:1
                    ]
                ].
                item := (perLanguageResources at:lang asSymbol ifAbsent:enResources) at:enLang default:enLang.
            ].

    languages :=
        enLanguages
            collect:[:enLang |
                |item|

                item := resources at:enLang default:enLang.
            ].

    flags :=
        listOfLanguageKeys
            collect:[:lang |
                |item coll|

                item := resources at:('FLAG_' , lang) default:nil.
                item notNil ifTrue:[
                    item
                ] ifFalse:[
                    coll := lang asCollectionOfSubstringsSeparatedBy:$_.
                    (coll size > 1
                    and:[(item := resources at:('FLAG_' , coll last) default:nil) notNil])
                    ifTrue:[
                        item
                    ] ifFalse:[
                        item := resources string:('LANG_' , lang).
                        item isArray ifTrue:[
                            item at:2
                        ] ifFalse:[
                            nil
                        ]
                    ]
                ]
            ].

    flags :=
        flags
            collect:[:nm |
                |img d fn|

                nm notNil ifTrue:[
                    img := Image fromFile:nm.
                    img isNil ifTrue:[
                        d := Smalltalk getPackageDirectoryForPackage:'stx:goodies'.
                        (d notNil and:[ (fn := d construct:nm) exists]) ifTrue:[
                            img := Image fromFile:fn.
                        ] ifFalse:[
                            ('LanguageSettings [info]: missing flags file: ',nm) infoPrintCR.
                        ].
                    ].
                ] ifFalse:[
                    nil
                ]
            ].


    translatedLanguages :=
        (1 to:languages size)
            collect:[:idx |
                |lang englishLang nativeLang s|

                lang := languages at:idx.
                englishLang := enLanguages at:idx.
                nativeLang := nativeLanguages at:idx.

                s := nativeLang.
                englishLang ~= nativeLang ifTrue:[
                    s := s , ' / ' , englishLang
                ].
                (lang ~= nativeLang and:[lang ~= englishLang]) ifTrue:[
                    s := s , ' / ' , lang
                ].
                s
            ].

    languageList := translatedLanguages
                        with:flags
                        collect:[:lang :flag | LabelAndIcon icon:flag string:lang.].

    "Modified: / 18-09-2006 / 19:23:39 / cg"
    "Modified: / 28-11-2017 / 11:28:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildHelpLabel:aWidget
    aWidget level:0.
    aWidget scrolledView backgroundColor:self window viewBackground.
    aWidget font:(Label defaultFont).
! !

!AbstractSettingsApplication::LanguageSettingsAppl methodsFor:'queries'!

currentLanguage
    ^ languageList at:(self currentLanguageIndex)
!

currentLanguageCode
    ^ listOfLanguages at:(self currentLanguageIndex)
!

currentLanguageIndex
    | lang terr langIdx |

    lang := Smalltalk language.
    terr := Smalltalk languageTerritory.

    (lang ~= terr) ifTrue:[
        langIdx := listOfLanguages indexOf:(lang , '-' , terr) ifAbsent:nil.
    ].
    langIdx isNil ifTrue:[
        langIdx := listOfLanguages indexOf:lang ifAbsent:nil.
    ].
    langIdx isNil ifTrue:[
        langIdx := listOfLanguages indexOf:'en' ifAbsent:nil.
        langIdx isNil ifTrue:[
            langIdx := listOfLanguages indexOf:'en-us' ifAbsent:nil.

            langIdx isNil ifTrue:[
                langIdx := 1.
            ]
        ]
    ].
    ^ langIdx
!

hasUnsavedChanges
    useSystemLanguageHolder value ~= currentUserPrefs useSystemLanguage ifTrue:[^ true].
    ^ languageIndexHolder value ~= self currentLanguageIndex

    "Modified: / 17-10-2006 / 17:51:09 / cg"
    "Modified: / 24-08-2010 / 18:50:11 / sr"
!

quickSearchStrings
    "keywords to match in the quickSearch.
     Notice that both the word and its current language translation is matched against
     the text in the quick search field"

    ^ super quickSearchStrings
        addAll:#('language' 'english');
        yourself
! !

!AbstractSettingsApplication::MemorySettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MemorySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#codeLimit
'Flush dynamic compiled code to stay within this limit (never flush, if 0 or blank).\Because most of ST/X''s code is precompiled anyway (in contrast to other Smalltalk and Java systems),\this only affects code which is dynamically generated at execution time.\So a code limit is usually not neeeded/usefull at all, and disabled by default'

#codeTrigger
'Start incremental background GC whenever this amount of dynamic jitted code has been allocated.\This can be adjusted to reclaim unused dynamically generated jitted code earlier.\Only useful if an applications generates big amounts of throw-away/execute once methods,\which gest jitted and are unreferenced soon afterwards'

#compressLimit
'Use slower 2-pass compressing GC if > 0 and more memory is in use.\This compressing oldspace GC strategy is blocking and freezes the system for a noticable time period.\It is therefore disabled by default and should be regarded as a last-chance option when memory gets very fragmented.\Long running applications may want to trigger such compacting GCs explicitely at know-to-be-ok times (midnight or weekend)'

#fastMoreLimit
'Quickly allocate more memory (suppress GC) up to this limit.\If non-zero, the memory manager will allocate more virtual memory instead of performing a full garbage collect,\as long as less than this amount has been allocated. If zero, it will allocate up to the maximum without a full collect\(which is ok, as long as the background collector can keep up with the allocation rate).'

#igcFreeAmount
'Try to keep this amount of free space for peak requests.\If after an incremental GC cycle, less than this amount is found to be free,\more virtual memory is allocated to ensure this amount is available.\This prepares the memory system for future short peak memory requests, and avoids blocking then'

#igcFreeLimit
'Start incremental background GC whenever freespace drops below this'

#igcLimit
'Start incremental background GC whenever this amount has been allocated in oldSpace since last GC'

#maxOldSpace
'Never allocate more than this amount of memory (oldSpace limit).\Having a limit here prevents runaway programs from allocating virtually unlimited amounts of memory.\That could lead to thrashing the virtual memory system and make the whole system useless.\Notice that on 32bit systems, there is an implementation and OS dependent upper limit on this maximum.\Also notice, that your paging disk space must be big enough (Windows users must be especially careful)'

#methodCodeSizeLimit
'Do not JIT, if an individual method''s code size exceeds this'

#newSpaceSize
'Size of the space where new objects are created (newSpace).\The size determines the worst-case pause time of a scavenge operation.\For servers or other request-processing applications, a bigger newSpace will dramatically reduce the GC overhead (to almost 0%).\For interactive applications, a smaller newSpace reduces the worst case pause times.\Useful values are between 800KiB to 64MiB'

#oldIncr
'Increase oldSpace in chunks of this size'

#stackLimit
'Trigger a recursionInterrupt exception if more stack is used by a process'

)
! !

!AbstractSettingsApplication::MemorySettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary memoryIcon
! !

!AbstractSettingsApplication::MemorySettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::MemorySettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::MemorySettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::MemorySettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Memory Manager Settings'
         name: 'Memory Manager Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 705 722)
       )
       component:
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Label'
             name: 'Label1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 50 0)
             translateLabel: true
             labelChannel: warningLabelHolder
             adjust: left
           )
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 50 0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 0
             verticalSpace: 3
             ignoreInvisibleComponents: true
             component:
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Limits:'
                   name: 'Label54'
                   translateLabel: true
                   adjust: left
                   extent: (Point 705 22)
                 )
                (ViewSpec
                   name: 'StackLimitBox'
                   activeHelpKey: stackLimit
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Stack Limit:'
                         name: 'Label38'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: stackLimit
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField20'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: stackLimit
                         enableChannel: supportsJustInTimeCompilation
                         model: stackLimit
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Trigger recursionInterrupt if more stack is used by a process)'
                         name: 'Label39'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: stackLimit
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'NewSpaceSizeBox'
                   activeHelpKey: newSpaceSize
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Size of NewSpace:'
                         name: 'Label44'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: newSpaceSize
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField23'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: newSpaceSize
                         model: newSpaceSize
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Size of Space where new objects are created)'
                         name: 'Label45'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: newSpaceSize
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'MaximumMemoryLimitBox'
                   activeHelpKey: maxOldSpace
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Maximum Memory Limit:'
                         name: 'Label46'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: maxOldSpace
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField24'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: maxOldSpace
                         model: maxOldSpace
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Never allocate more than this amount of memory)'
                         name: 'Label47'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: maxOldSpace
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'QuickAllocationLimitBox'
                   activeHelpKey: fastMoreLimit
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Quick Allocation Limit:'
                         name: 'Label26'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: fastMoreLimit
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField14'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: fastMoreLimit
                         model: fastMoreLimit
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Quickly allocate more memory (suppress GC) up to this limit)'
                         name: 'Label27'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: fastMoreLimit
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'OldspaceIncrementBox'
                   activeHelpKey: oldIncr
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Oldspace Increment:'
                         name: 'Label34'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: oldIncr
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField18'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: oldIncr
                         model: oldIncr
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Increase oldSpace in chunks of this size)'
                         name: 'Label35'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: oldIncr
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'OldSpaceCompressLimitBox'
                   activeHelpKey: compressLimit
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Oldspace Compress Limit:'
                         name: 'Label36'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: compressLimit
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField19'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: compressLimit
                         model: compressLimit
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Use 2-pass compressing GC if > 0 and more memory is in use)'
                         name: 'Label37'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: compressLimit
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'CodeLimitBox'
                   activeHelpKey: codeLimit
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Dynamic code Limit:'
                         name: 'Label40'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: codeLimit
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField21'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: codeLimit
                         enableChannel: supportsJustInTimeCompilation
                         model: codeLimit
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Flush dynamic compiled code to stay within this limit)'
                         name: 'Label41'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: codeLimit
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'MethodSizeLimitBox'
                   activeHelpKey: methodCodeSizeLimit
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Method Code Size Limit:'
                         name: 'Label52'
                         layout: (LayoutFrame 0 0 5 0 265 0 25 0)
                         activeHelpKey: methodCodeSizeLimit
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField27'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: methodCodeSizeLimit
                         enableChannel: supportsJustInTimeCompilation
                         model: methodCodeSizeLimit
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Do not JIT, if an individual method''s code size exceeds this)'
                         name: 'Label53'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: methodCodeSizeLimit
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (LabelSpec
                   label: 'Triggers:'
                   name: 'Label55'
                   translateLabel: true
                   adjust: left
                   extent: (Point 705 22)
                 )
                (ViewSpec
                   name: 'IncrementalGCAllocationTriggerBox'
                   activeHelpKey: igcLimit
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Incremental GC Allocation Trigger:'
                         name: 'Label48'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: igcLimit
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField25'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: igcLimit
                         model: igcLimit
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Start IGC whenever this has been newly allocated)'
                         name: 'Label49'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: igcLimit
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'IncrementalGCFreespaceTriggerBox'
                   activeHelpKey: igcFreeLimit
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Incremental GC Freespace Trigger:'
                         name: 'Label50'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: igcFreeLimit
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField26'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: igcFreeLimit
                         model: igcFreeLimit
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Start IGC whenever freespace drops below this)'
                         name: 'Label51'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: igcFreeLimit
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'CodeTriggerBox'
                   activeHelpKey: codeTrigger
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Incremental GC Dynamic Code Trigger:'
                         name: 'Label42'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: codeTrigger
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField22'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: codeTrigger
                         model: codeTrigger
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Start incremental GC whenever this amount of code has been allocated)'
                         name: 'Label43'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: codeTrigger
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                (ViewSpec
                   name: 'GCAmountBox'
                   activeHelpKey: igcFreeAmount
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Incremental GC Amount:'
                         name: 'Label32'
                         layout: (LayoutFrame 0 0 5 0 265 0 27 0)
                         activeHelpKey: igcFreeAmount
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField17'
                         layout: (LayoutFrame 270 0 0 0 360 0 30 0)
                         activeHelpKey: igcFreeAmount
                         model: igcFreeAmount
                         type: fileSize
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: '(Try to keep this amount for peak requests)'
                         name: 'Label33'
                         layout: (LayoutFrame 364 0.0 5 0 0 1.0 27 0)
                         activeHelpKey: igcFreeAmount
                         translateLabel: true
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 705 34)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::MemorySettingsAppl methodsFor:'actions'!

basicReadSettings
    self
        readAspects:(self aspectsInObjectMemory)
        from:ObjectMemory.

    self igcLimit value:ObjectMemory incrementalGCLimit.
    self igcFreeLimit value:ObjectMemory freeSpaceGCLimit.
    self igcFreeAmount value:ObjectMemory freeSpaceGCAmount.
    self oldIncr value:ObjectMemory oldSpaceIncrement.
    self compressLimit value:ObjectMemory oldSpaceCompressLimit.
    self codeLimit value:ObjectMemory dynamicCodeLimit.
    self codeTrigger value:ObjectMemory dynamicCodeGCTrigger.
    self methodCodeSizeLimit value:(ObjectMemory codeSizeLimitForDynamicCompilation:-1).
    self fastMoreLimit value:(ObjectMemory fastMoreOldSpaceLimit:-1).

    self stackLimit value:Process defaultMaximumStackSize.

    "Modified: / 12-08-2010 / 15:34:24 / cg"
!

basicSaveSettings
    self
        writeAspects:(self aspectsInObjectMemory)
        to:ObjectMemory.

    ObjectMemory freeSpaceGCAmount:self igcFreeAmount value.
    ObjectMemory freeSpaceGCLimit:self igcFreeLimit value.
    ObjectMemory incrementalGCLimit:self igcLimit value.
    ObjectMemory oldSpaceIncrement:self oldIncr value.
    ObjectMemory fastMoreOldSpaceLimit:self fastMoreLimit value.
    ObjectMemory oldSpaceCompressLimit:self compressLimit value.
    ObjectMemory dynamicCodeLimit:self codeLimit value.
    ObjectMemory dynamicCodeGCTrigger:self codeTrigger value.
    ObjectMemory codeSizeLimitForDynamicCompilation:(self methodCodeSizeLimit value).

    Process defaultMaximumStackSize:self stackLimit value.

    "Modified: / 12-08-2010 / 15:34:47 / cg"
! !

!AbstractSettingsApplication::MemorySettingsAppl methodsFor:'aspects'!

aspectsInObjectMemory
    ^ #(
                newSpaceSize
                maxOldSpace
            )
!

codeLimit

    codeLimit isNil ifTrue:[
        codeLimit := ObjectMemory dynamicCodeLimit asValue.
        codeLimit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ codeLimit.
!

codeTrigger

    codeTrigger isNil ifTrue:[
        codeTrigger := ObjectMemory dynamicCodeGCTrigger asValue.
        codeTrigger onChangeSend:#updateModifiedChannel to:self
    ].
    ^ codeTrigger.
!

compressLimit

    compressLimit isNil ifTrue:[
        compressLimit := ObjectMemory oldSpaceCompressLimit asValue.
        compressLimit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ compressLimit.
!

fastMoreLimit

    fastMoreLimit isNil ifTrue:[
        fastMoreLimit := (ObjectMemory fastMoreOldSpaceLimit:-1) asValue.
        fastMoreLimit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ fastMoreLimit.
!

igcFreeAmount

    igcFreeAmount isNil ifTrue:[
        igcFreeAmount := ObjectMemory freeSpaceGCAmount asValue.
        igcFreeAmount onChangeSend:#updateModifiedChannel to:self
    ].
    ^ igcFreeAmount.
!

igcFreeLimit

    igcFreeLimit isNil ifTrue:[
        igcFreeLimit := ObjectMemory freeSpaceGCLimit asValue.
        igcFreeLimit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ igcFreeLimit.
!

igcLimit

    igcLimit isNil ifTrue:[
        igcLimit := ObjectMemory incrementalGCLimit asValue.
        igcLimit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ igcLimit.
!

maxOldSpace

    maxOldSpace isNil ifTrue:[
        maxOldSpace := ObjectMemory maxOldSpace asValue.
        maxOldSpace onChangeSend:#updateModifiedChannel to:self
    ].
    ^ maxOldSpace.
!

methodCodeSizeLimit

    methodCodeSizeLimit isNil ifTrue:[
        methodCodeSizeLimit := (ObjectMemory codeSizeLimitForDynamicCompilation:-1) asValue.
        methodCodeSizeLimit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ methodCodeSizeLimit.

    "Created: / 12-08-2010 / 15:31:56 / cg"
!

newSpaceSize

    newSpaceSize isNil ifTrue:[
        newSpaceSize := ObjectMemory newSpaceSize asValue.
        newSpaceSize onChangeSend:#updateModifiedChannel to:self
    ].
    ^ newSpaceSize.
!

oldIncr

    oldIncr isNil ifTrue:[
        oldIncr := ObjectMemory oldSpaceIncrement asValue.
        oldIncr onChangeSend:#updateModifiedChannel to:self
    ].
    ^ oldIncr.
!

stackLimit

    stackLimit isNil ifTrue:[
        stackLimit := Process defaultMaximumStackSize asValue.
        stackLimit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ stackLimit.
!

supportsJustInTimeCompilation

    ^ ObjectMemory supportsJustInTimeCompilation.
!

warningLabelHolder

    warningLabelHolder isNil ifTrue:[
        warningLabelHolder := ValueHolder new.
    ].
    ^ warningLabelHolder.
! !

!AbstractSettingsApplication::MemorySettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/memorySettings.html'
! !

!AbstractSettingsApplication::MemorySettingsAppl methodsFor:'initialization & release'!

initialize
    super initialize.
    self warningLabelHolder
        value:(StringCollection
                with:(resources string:'Warning - invalid settings may result in failures or poor performance.')
                with:(resources string:'You have been warned.') allBold
               ).
! !

!AbstractSettingsApplication::MemorySettingsAppl methodsFor:'queries'!

hasUnsavedChanges
     (self
        hasChangedAspectIn:(self aspectsInObjectMemory)
        asComparedTo:ObjectMemory) ifTrue:[^ true].

    ObjectMemory freeSpaceGCAmount ~= self igcFreeAmount value ifTrue:[^ true].
    ObjectMemory freeSpaceGCLimit ~= self igcFreeLimit value ifTrue:[^ true].
    ObjectMemory incrementalGCLimit ~= self igcLimit value ifTrue:[^ true].
    ObjectMemory oldSpaceIncrement ~= self oldIncr value ifTrue:[^ true].
    (ObjectMemory fastMoreOldSpaceLimit:-1) ~= self fastMoreLimit value ifTrue:[^ true].
    ObjectMemory oldSpaceCompressLimit ~= self compressLimit value ifTrue:[^ true].
    ObjectMemory dynamicCodeLimit ~= self codeLimit value ifTrue:[^ true].
    ObjectMemory dynamicCodeGCTrigger ~= self codeTrigger value ifTrue:[^ true].
    (ObjectMemory codeSizeLimitForDynamicCompilation:-1) ~= self methodCodeSizeLimit value ifTrue:[^ true].

    Process defaultMaximumStackSize ~= self stackLimit value ifTrue:[^ true].
    ^ false

    "Modified: / 12-08-2010 / 15:33:12 / cg"
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#dotNetBridge
'The dotNet bridge extension allows transparent access and message sending to .NET classes and instances.'

#smalltalkBridgeServer
'The smalltalk bridge server extension allows distributed processing\via transparent access and message sending from other ST/X systems.'
)
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@!!8@@@@@@BG @@@!!1]P@@@@AWE8@@!!1 '' @@@BGFB^@!!1 5Q8@@BCFCUG !!DWQPH@@BDQMHD \QFA] @@@1DXE6X"DQ]VY&Y"HQE5I&@!!]QI&Y&XBEED"TG
]QD&Y&IPL5ERQ5 !!TV@@ACVBEQIF$REXP@@DX1HU!!@$''HXP@@@T2L!!!!@@GI(@@@@AVL&!!@@@UGP@@@@G]TM@@@@@P@@@@@A5A@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 224 224 224 64 64 64 96 96 96 128 128 128 192 192 192 32 32 32 96 96 96 160 160 160 96 96 96] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'G@C O G0_0O8?8_<?(_<?8_<???<???<???<?8_<?8_<_0O8O G0O@G B@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'); yourself); yourself]
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Communication Settings'
         name: 'Communication Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 738 671)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: '.NET Bridge'
                   name: 'FramedBox1'
                   activeHelpKey: dotNetBridge
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel3'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         horizontalLayout: left
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'Box6'
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Verbose'
                                     name: 'CheckBox5'
                                     layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                                     enableChannel: hasDotNetBridge
                                     model: dotNetBridgeVerbose
                                     translateLabel: true
                                   )
                                  )

                               )
                               extent: (Point 696 25)
                             )
                            (ViewSpec
                               name: 'Box7'
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Bridge Runs in IDE'
                                     name: 'CheckBox6'
                                     layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                                     enableChannel: hasDotNetBridge
                                     model: dotNetBridgeRunsInIDE
                                     translateLabel: true
                                   )
                                  )

                               )
                               extent: (Point 696 25)
                             )
                            )

                         )
                       )
                      (ActionButtonSpec
                         label: 'Close all Connections'
                         name: 'Button1'
                         layout: (LayoutFrame -228 1 27 0 -3 1 49 0)
                         translateLabel: true
                         tabable: true
                         model: closeAllDotNetConnections
                         enableChannel: hasDotNetBridge
                       )
                      )

                   )
                   extent: (Point 738 92)
                 )
                (FramedBoxSpec
                   label: 'Smalltalk Bridge Server'
                   name: 'FramedBox2'
                   activeHelpKey: smalltalkBridgeServer
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel4'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         horizontalLayout: left
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'Box8'
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Bridge Server Enabled'
                                     name: 'CheckBox7'
                                     layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                                     enableChannel: hasSmalltalkBridge
                                     model: smalltalkBridgeEnabled
                                     translateLabel: true
                                   )
                                  )

                               )
                               extent: (Point 696 25)
                             )
                            (ViewSpec
                               name: 'Box9'
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Verbose'
                                     name: 'CheckBox8'
                                     layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                                     enableChannel: hasSmalltalkBridge
                                     model: smalltalkBridgeVerbose
                                     translateLabel: true
                                   )
                                  )

                               )
                               extent: (Point 696 25)
                             )
                            )

                         )
                       )
                      (ActionButtonSpec
                         label: 'Close all Connections'
                         name: 'Button2'
                         layout: (LayoutFrame -228 1 27 0 -3 1 49 0)
                         translateLabel: true
                         tabable: true
                         model: closeAllSmalltalkBridgeConnections
                         enableChannel: hasSmalltalkBridge
                       )
                      )

                   )
                   extent: (Point 738 101)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl methodsFor:'actions'!

aspects
    ^ #(
                smtpServerName
                dotNetBridgeRunsInIDE
                dotNetBridgeVerbose
            )
!

basicReadSettings
    super basicReadSettings.

    BRIDGE::SmalltalkBridge notNil ifTrue:[
        self smalltalkBridgeVerbose value:(BRIDGE::SmalltalkBridge verbose).
    ].
!

basicSaveSettings
    super basicSaveSettings.

    BRIDGE::SmalltalkBridge notNil ifTrue:[
        BRIDGE::SmalltalkBridge verbose:(self smalltalkBridgeVerbose value).
    ].
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl methodsFor:'aspects'!

acceptChannel

    acceptChannel isNil ifTrue:[
        acceptChannel := TriggerValue new.
    ].
    ^ acceptChannel.

    "Created: / 12-11-2006 / 19:04:09 / cg"
!

dotNetBridgeRunsInIDE

    dotNetBridgeRunsInIDE isNil ifTrue:[
        dotNetBridgeRunsInIDE := false asValue.
        dotNetBridgeRunsInIDE onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ dotNetBridgeRunsInIDE.
!

dotNetBridgeVerbose

    dotNetBridgeVerbose isNil ifTrue:[
        dotNetBridgeVerbose := false asValue.
        dotNetBridgeVerbose onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ dotNetBridgeVerbose.
!

hasDotNetBridge
    ^ DOTNET::DotNet notNil and:[ DOTNET::DotNet isLoaded ].
!

hasSmalltalkBridge
    ^ BRIDGE::SmalltalkBridge notNil and:[ BRIDGE::SmalltalkBridge isLoaded ].
!

smalltalkBridgeEnabled

    smalltalkBridgeEnabled isNil ifTrue:[
        smalltalkBridgeEnabled := false asValue.
        smalltalkBridgeEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smalltalkBridgeEnabled.
!

smalltalkBridgeVerbose

    smalltalkBridgeVerbose isNil ifTrue:[
        smalltalkBridgeVerbose := false asValue.
        smalltalkBridgeVerbose onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smalltalkBridgeVerbose.
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/communicationsSettings.html'
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl methodsFor:'initialization & release'!

initialize
    super initialize.
    self readSettings.
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl methodsFor:'queries'!

hasRemoteBrowsingSupport

    ^ SmalltalkShareServer notNil
!

hasUnsavedChanges
    (super hasUnsavedChanges) ifTrue:[^ true].

    BRIDGE::SmalltalkBridge notNil ifTrue:[
        BRIDGE::SmalltalkBridge verbose ~= (self smalltalkBridgeVerbose value) ifTrue:[^ true].
        BRIDGE::SmalltalkBridge defaultInstanceOrNil notNil ifTrue:[
            (self smalltalkBridgeEnabled value) ifFalse:[^ true].
        ] ifFalse:[
        (self smalltalkBridgeEnabled value) ifTrue:[^ true].
        ].
    ] ifFalse:[
        (self smalltalkBridgeEnabled value) ifTrue:[^ true].
    ].
    ^ false
! !

!AbstractSettingsApplication::MiscBridgeCommunicationSettingsAppl methodsFor:'user actions'!

closeAllDotNetConnections
    DOTNET::DotNet notNil ifTrue:[
        DOTNET::DotNet exitAllInstances
    ].
!

closeAllSmalltalkBridgeConnections
    BRIDGE::SmalltalkBridge notNil ifTrue:[
        BRIDGE::SmalltalkBridge exitAllInstances
    ].
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#smtpServer
'The host name of your SMTP (mail transfer) server.\This is only needed for the debugger''s "Send Error Report via Mail" menu function,\so you can leave this empty if you don''t need or want this function'

)
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::MiscCommunicationSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@!!8@@@@@@BG @@@!!1]P@@@@AWE8@@!!1 '' @@@BGFB^@!!1 5Q8@@BGFBUG !!DWQPH@@B@Q]HD \QFA] @@A1DXE6X"DQ]VY&Y"HQE5I&@ ]QHD@FHBAED"TG
]QD$Q5IVI5ERQ5 !!TVPW]BUBEQIF$REXPT^FY1HV!!@$''HXPXIWU"]!!!!%@GI(BAFGUV\&!!FT@UGQ"PQEW^D]EYP@@PFHHETU5A@U%@@@@I@BGTRT@U%@@@@AH
P"DQ]PU%@@@@@EBUHQU5U%@@@@@@@B !!YHU%@@@@@@@E@ UFY%@@@@@@@@APIH@@@@@@@@@@@@T@@@@@@@@b')
            colorMapFromArray:#[0 0 0 224 224 224 64 64 64 96 96 96 128 128 128 192 192 192 32 32 32 96 96 96 160 160 160 96 96 96]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'G@C O G0_0O8?8_<?(W<?8_<???<=:^<???<???<???<_??<O??<O??<B?=\@?<8@?=0@?? @O?@@W>@@K @@D@@'); yourself); yourself]
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::MiscCommunicationSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::MiscCommunicationSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::MiscCommunicationSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Communication Settings'
         name: 'Communication Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 738 671)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'SMTP (Mail) Server'
                   name: 'SMTPServerBox1'
                   activeHelpKey: smtpServer
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box5'
                         layout: (LayoutFrame 0 0 10 0 0 1 35 0)
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'SMTP Server:'
                               name: 'SMTPLabel'
                               layout: (LayoutFrame 0 0 0 0 150 0 22 0)
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'SMTPServer'
                               layout: (LayoutFrame 150 0 0 0 400 0 22 0)
                               model: smtpServerName
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: false
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 738 81)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl methodsFor:'actions'!

aspects
    ^ #(
                smtpServerName
            )
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl methodsFor:'aspects'!

acceptChannel

    acceptChannel isNil ifTrue:[
        acceptChannel := TriggerValue new.
    ].
    ^ acceptChannel.

    "Created: / 12-11-2006 / 19:04:09 / cg"
!

smtpServerName

    smtpServerName isNil ifTrue:[
        smtpServerName := '' asValue.
        smtpServerName onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smtpServerName.

    "Created: / 20-09-2007 / 16:04:39 / cg"
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/communicationsSettings.html'
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl methodsFor:'initialization & release'!

initialize
    super initialize.
    self readSettings.
! !

!AbstractSettingsApplication::MiscCommunicationSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    (super hasUnsavedChanges) ifTrue:[^ true].
    ^ false

    "Modified: / 20-09-2007 / 16:04:56 / cg"
! !

!AbstractSettingsApplication::MiscDisplay2SettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#nativeWidgets
'Use native widgets if possible (Scrollbars, Checktoggles, etc.)\Experimental and unfinished.\(Windows operating system ony)'

#nativeDialogs
'Use native dialogs if possible (WarnBox, InformationBox, etc.)\(Windows operating system ony)'

#nativeFileDialogs
'Use native file dialogs if possible (Load- and Save Dialogs)\(Windows operating system ony)'

#shadows
'Simulate shadows under popup menus and dialogs (by greyShading).\No longer needed, as modern systems nowadays do it automatically for us.'

#cartoonToolTipStyle
'Choose between normal and cartoon mode when showing tooltips.'

#opaqueVariablePanelResizing
'When moving a variable panels splitter handle, immediately resize the components.\Otherwise, show a dashed resize line above the view and resize when the mouse button is released.\Uncheck on a slow machine and/or a slow graphics engine'

#opaqueTableColumnResizing
'When moving a table-view''s column splitter handle, immediately resize the columns.\Otherwise, show a dashed resize line above the view and resize when the mouse button is released.\Uncheck on a slow machine and/or a slow graphics engine'

#lowerOnRightClickInTitle
'When right-clicking into a window''s title/caption area, lower the window.\(Windows operating system ony)'

#lowerOnShiftClickInTitle
'When shift-clicking into a window''s title/caption area, lower the window.\(Windows operating system ony)'

)
! !

!AbstractSettingsApplication::MiscDisplay2SettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::MiscDisplay2SettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@ H@@@@@@@@@@@@B@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.;.;.;.;.;@@@@:<;]!!I&W3.,@@@C+3-6D&Y_N:0@@@N/%
**DQ.>U[@@@@9,3L3L3LL3X@@@C&3L3L3L03M C2HN[L3L3L03L60@@@9,3L3L3CL3[@@ C&3L3L3LL3M @B@N[L3L3L03L6@@H@9,3L3L03L3X@?2C&3L3L
3LL3M C2HN[L3L3LL3L6@OH 9&Y&Y&Y&Y&X@<"C.;.;.;.;.8@C?H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 0 96 128 100 100 100 224 224 224 16 128 160 128 128 128 80 80 80 0 96 144 16 128 176 0 112 152 16 112 144 0 80 120 240 240 240 16 144 192 192 192 192 255 255 0]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@@@@8@@@8@@@P@@@P_?<P??<P??<P??<P??<8??=<???<??>8??<8??<8??=<??=<??=<??=<??9<@@@8@@@@') ; yourself); yourself]
! !

!AbstractSettingsApplication::MiscDisplay2SettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::MiscDisplay2SettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::MiscDisplay2SettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::MiscDisplay2SettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Display settings 2'
         name: 'Display settings 2'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 671 591)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fitSpace
             verticalLayout: topSpace
             horizontalSpace: 5
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Use Native Widgets (Experimental & Unfinished Feature)'
                   name: 'NativeWidgets'
                   activeHelpKey: nativeWidgets
                   enableChannel: displaySupportsNativeWidgets
                   model: nativeWidgets
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (CheckBoxSpec
                   label: 'Use Native Dialogs (Experimental & Unfinished Feature)'
                   name: 'NativeDialogs'
                   activeHelpKey: nativeDialogs
                   enableChannel: displaySupportsNativeDialogs
                   model: nativeDialogs
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (CheckBoxSpec
                   label: 'Use Native File Dialogs (Experimental & Unfinished Feature)'
                   name: 'CheckBox1'
                   activeHelpKey: nativeFileDialogs
                   enableChannel: displaySupportsNativeFileDialogs
                   model: nativeFileDialogs
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (ViewSpec
                   name: 'SeparatingSpace1'
                   extent: (Point 661 5)
                 )
                (DividerSpec
                   name: 'Separator1'
                   extent: (Point 661 4)
                 )
                (ViewSpec
                   name: 'SeparatingSpace2'
                   extent: (Point 661 5)
                 )
                (CheckBoxSpec
                   label: 'Shadows under PopUp Views'
                   name: 'shadows'
                   activeHelpKey: shadows
                   model: shadows
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (CheckBoxSpec
                   label: 'Cartoon Tooltip Style'
                   name: 'CheckBox2'
                   activeHelpKey: cartoonToolTipStyle
                   enableChannel: displaySupportsArbitraryShapedViews
                   model: cartoonToolTipStyle
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (CheckBoxSpec
                   label: 'Opaque Variable Panel Resizing'
                   name: 'opaqueVariablePanelResize'
                   activeHelpKey: opaqueVariablePanelResizing
                   model: opaqueVariablePanelResizing
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (CheckBoxSpec
                   label: 'Opaque Table Column Resizing'
                   name: 'opaqueTableColumnResize'
                   activeHelpKey: opaqueTableColumnResizing
                   model: opaqueTableColumnResizing
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (ViewSpec
                   name: 'SeparatingSpace3'
                   extent: (Point 661 4)
                 )
                (DividerSpec
                   name: 'Separator3'
                   extent: (Point 661 3)
                 )
                (ViewSpec
                   name: 'SeparatingSpace4'
                   extent: (Point 661 3)
                 )
                (CheckBoxSpec
                   label: 'Right-Click in Title brings Window to Back'
                   name: 'lowerOnRightClickInTitle'
                   activeHelpKey: lowerOnRightClickInTitle
                   enableChannel: isWindowsDisplay
                   model: lowerOnRightClickInTitle
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                (CheckBoxSpec
                   label: 'Shift-Click in Title brings Window to Back'
                   name: 'lowerOnShiftClickInTitle'
                   activeHelpKey: lowerOnShiftClickInTitle
                   enableChannel: isWindowsDisplay
                   model: lowerOnShiftClickInTitle
                   translateLabel: true
                   extent: (Point 661 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::MiscDisplay2SettingsAppl methodsFor:'actions'!

basicReadSettings
    |currentScreen|

    currentScreen := Screen current.

    self
        readAspects:
            #(
                nativeWidgets
                nativeDialogs
                nativeFileDialogs
            )
        from:currentScreen.

    super basicReadSettings.

    self shadows value:PopUpView shadows.
    self cartoonToolTipStyle value: (currentUserPrefs toolTipShapeStyle == #cartoon).

    currentScreen isWindowsPlatform ifTrue:[
        self lowerOnRightClickInTitle value:(currentScreen rightButtonIsLowerWindow:nil).
        self lowerOnShiftClickInTitle value:(currentScreen shiftedLeftButtonIsLowerWindow:nil).
    ].

    "Modified: / 24-08-2010 / 16:43:39 / sr"
!

basicSaveSettings
    |currentScreen mustReopenTools|

    mustReopenTools := false.

    currentScreen := Screen current.

    self displaySupportsNativeWidgets ifTrue:[
        currentScreen nativeWidgets ~= self nativeWidgets value ifTrue:[
            mustReopenTools := true.
            currentScreen nativeWidgets:self nativeWidgets value.
            currentUserPrefs nativeWidgets:self nativeWidgets value.
        ].
    ].
    self displaySupportsNativeDialogs ifTrue:[
        currentScreen nativeDialogs:self nativeDialogs value.
        currentUserPrefs nativeDialogs:self nativeDialogs value.
    ].
    self displaySupportsNativeFileDialogs ifTrue:[
        currentScreen nativeFileDialogs:self nativeFileDialogs value.
        currentUserPrefs nativeFileDialogs:self nativeFileDialogs value.
    ].

    currentUserPrefs toolTipShapeStyle:((self cartoonToolTipStyle value)
                                                ifTrue:[ #cartoon ]
                                                ifFalse:[ nil ]).
    PopUpView shadows:self shadows value.

    super basicSaveSettings.

    currentScreen isWindowsPlatform ifTrue:[
        currentScreen rightButtonIsLowerWindow:(self lowerOnRightClickInTitle value).
        currentScreen shiftedLeftButtonIsLowerWindow:(self lowerOnShiftClickInTitle value).
    ].

    mustReopenTools ifTrue:[
        self reopenToolsAfterChangedViewStyleSetting.
    ].

    "Modified: / 24-08-2010 / 17:27:25 / sr"
! !

!AbstractSettingsApplication::MiscDisplay2SettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        opaqueVariablePanelResizing
        opaqueTableColumnResizing
    )

    "Modified: / 24-08-2010 / 17:26:38 / sr"
!

cartoonToolTipStyle
    cartoonToolTipStyle isNil ifTrue:[
        cartoonToolTipStyle := false asValue.
        cartoonToolTipStyle onChangeSend:#updateModifiedChannel to:self
    ].
    ^ cartoonToolTipStyle.
!

displaySupportsNativeDialogs
    ^ Screen current supportsNativeDialogs
!

displaySupportsNativeFileDialogs
    ^ Screen current supportsNativeFileDialogs

    "Modified: / 24-08-2010 / 16:28:58 / sr"
!

displaySupportsNativeWidgets
    ^ Screen current supportsNativeWidgets
!

lowerOnRightClickInTitle
    lowerOnRightClickInTitle isNil ifTrue:[
        lowerOnRightClickInTitle := true asValue.
        lowerOnRightClickInTitle onChangeSend:#updateModifiedChannel to:self
    ].
    ^ lowerOnRightClickInTitle.
!

lowerOnShiftClickInTitle
    lowerOnShiftClickInTitle isNil ifTrue:[
        lowerOnShiftClickInTitle := true asValue.
        lowerOnShiftClickInTitle onChangeSend:#updateModifiedChannel to:self
    ].
    ^ lowerOnShiftClickInTitle.
!

nativeDialogs
    nativeDialogs isNil ifTrue:[
        nativeDialogs := Screen current nativeDialogs asValue.
        nativeDialogs onChangeSend:#updateModifiedChannel to:self
    ].
    ^ nativeDialogs.
!

nativeFileDialogs
    nativeFileDialogs isNil ifTrue:[
        nativeFileDialogs := Screen current nativeFileDialogs asValue.
        nativeFileDialogs onChangeSend:#updateModifiedChannel to:self
    ].
    ^ nativeFileDialogs

    "Modified: / 24-08-2010 / 16:43:08 / sr"
!

nativeWidgets
    nativeWidgets isNil ifTrue:[
        nativeWidgets := Screen current nativeWidgets asValue.
        nativeWidgets onChangeSend:#updateModifiedChannel to:self
    ].
    ^ nativeWidgets.
!

opaqueTableColumnResizing
    opaqueTableColumnResize isNil ifTrue:[
        opaqueTableColumnResize := true asValue.
        opaqueTableColumnResize onChangeSend:#updateModifiedChannel to:self
    ].
    ^ opaqueTableColumnResize.
!

opaqueVariablePanelResizing
    opaqueVariablePanelResize isNil ifTrue:[
        opaqueVariablePanelResize := true asValue.
        opaqueVariablePanelResize onChangeSend:#updateModifiedChannel to:self
    ].
    ^ opaqueVariablePanelResize.
!

shadows
    shadows isNil ifTrue:[
        shadows := PopUpView shadows asValue.
        shadows onChangeSend:#updateModifiedChannel to:self
    ].
    ^ shadows.
! !

!AbstractSettingsApplication::MiscDisplay2SettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/miscSettings.html'
! !

!AbstractSettingsApplication::MiscDisplay2SettingsAppl methodsFor:'queries'!

displaySupportsArbitraryShapedViews
    ^ Screen current supportsArbitraryShapedViews
!

hasUnsavedChanges
     |currentScreen|

     currentScreen := Screen current.

     (self
        hasChangedAspectIn:
            #(
                nativeWidgets
                nativeDialogs
                nativeFileDialogs
            )
        asComparedTo:currentScreen) ifTrue:[^ true].

     (super hasUnsavedChanges) ifTrue:[^ true].

    self shadows value ~= PopUpView shadows ifTrue:[^ true].
    (currentUserPrefs toolTipShapeStyle == #cartoon) ~= cartoonToolTipStyle value ifTrue:[^ true].

    currentScreen isWindowsPlatform ifTrue:[
        (currentScreen rightButtonIsLowerWindow:nil) ~= (self lowerOnRightClickInTitle value) ifTrue:[^ true].
        (currentScreen shiftedLeftButtonIsLowerWindow:nil) ~= (self lowerOnShiftClickInTitle value) ifTrue:[^ true].
    ].
    ^ false

    "Modified: / 24-08-2010 / 16:44:43 / sr"
!

isWindowsDisplay
     ^ Screen current isWindowsPlatform
! !

!AbstractSettingsApplication::MiscDisplaySettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#showAccelerators
'Show shortcut-key bindings (if any) in popup menus'

#focusFollowsMouse
'Keyboard focus follows the mouse position (no need to click into fields for focus)'

#'shouldRememberLastExtent'
'Applications remember their last window size when closed,\and take that as default when opened the next time.'

#menuPanelTakesFocusOnClick
'Menupanel takes the keyboard focus when clicked. If off, the focus remains unchanged'

#mouseWheelFocusFollowsMouse
'Mousewheel focus follows the mouse position (no need to click into fields for focus).\If Keyboard focus follows pointer is set to true, then this is always also true.'

#allowMouseWheelZoom
'Turning the mousewheel with CTRL- or ALT-key pressed will zoom in/out\(i.e. changes the view''s magnification if it supports zooming).\Note that on Mac-OSX systems, CTRL-Wheel is already handled by the window manager,\so you have to press the ALT key.'

#takeFocus
'Windows automatically fetch the focus when opened\(usually not needed, as done by window manager)'

#returnFocus
'Dialog boxes return the focus to the original view when closed\(usually not needed, as done by window manager)'

#activateOnClick
'Raise and activate a window when clicked into it\(usually not needed, as done by window manager)'

#button2WithAltKey
'Use with single button mice to get a right-button emulation'

#selectOnRightClick
'Right click changes the selection (before the menu is opened).\This is the Windows behavior.\Under X11, selection and menu activation are done by different mouse buttons.'

#showRightButtonMenuOnRelease
'Activate popup menus when the mouse button is released; not when pressed.\Usually better, as it allows for the mouse pointer to be moved away,\in case you change your mind.\However, some people prefer the menu to come up immediately.\\The combination of this off AND selectOnRightClick is hard to use.'

#hostNameInLabel
'Show additional session, host and user information in each of the ST/X windows.\Useful, if you have multiple, possibly remote ST/X sessions running on the same screen,\to not loose track of which window belongs to which session.'

#autoRaiseOnFocusIn
'Automatic raise of a window after a short delay, whenever it gets the focus (via the window manager).\Most useful on systems where the focus follows the mouse.\(sometimes not needed, as done by the window manager)'

#forceWindowsIntoMonitorBounds
'Restrict the position and size of windows to ensure they are (at least partially) within the screen''s bounds.\Especially useful when switching the screen''s resolution.'
)
! !

!AbstractSettingsApplication::MiscDisplaySettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::MiscDisplaySettingsAppl defaultIcon'
        ifAbsentPut:[(Depth8Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@DA@@@@@@@@@@@@@@@@@@@@@@@@@@DB@0D@@@@@@@@@@@@@@@@@@@@@@@DB@0LD@P@@@@@@@@@@@@@@@@@@@@DB@0LDA@DA@@@@@@@@@@@@
@@@@@@TB@ HDA@XF@PD@@@@@@@@@@@@@@@TB@ HB@ \FA  H@P@@@@@@@@@@@@TB@ HB@ HBB@XIB@ A@@@@@@@@@@TB@ HB@ HB@ (KB@ KB0DC@@@@@@TB
@ HB@ HB@ HB@ ,KB0LC@P@@@@@@APHB@ HB@ HBB (JB0LC@0HL@@4MCP4MCP4MCP4MCP4MCP4AC HE@@@MCPHCC0<PDQHRD1PB@0LM@ DE@@@@CP4B@0<O
DADRD!!LT@ LCCPHE@@@@@@4M@08UEQTVE!!XWE0LNC 4E@@@@@@@EAPHB@ HB@ HB@ HJB (E@@@@@@@@APTB@ HB@ HB@ HBB (JAP@@@@@@@@TE@ HB@ HB
@ HBB (JB T@@@@@@@@EAPHB@ HB@ HB@ (JB (E@@@@@@@@APTB@ HB@ HB@ HJB (JAP@@@@@@@@TE@ HB@ HB@ HBB (JB T@@@@@@@@EAPHB@ HB@ HB
B (JB (E@@@@@@@@APTEAPTEAPTEAPTEAPTEAP@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 32 96 80 240 240 240 192 192 192 64 144 128 80 80 80 48 112 112 48 128 128 32 96 96 48 128 112 224 224 224 32 80 80 64 96 96 0 80 128 128 128 128 16 144 192 16 128 176 16 128 160 0 112 160 0 112 144 0 96 144 16 112 144 0 96 128 0 80 112]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@C@@@G @@O0@@_8@@?<@A?>@C??@G??0O??0G??8???0??? ???@??>@??<@??<@??<@??<@??<@??<@??<@??<@'); yourself); yourself]
! !

!AbstractSettingsApplication::MiscDisplaySettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::MiscDisplaySettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::MiscDisplaySettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Display settings'
         name: 'Display settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 540 662)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fitSpace
             verticalLayout: topSpace
             horizontalSpace: 5
             verticalSpace: 1
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Beeper enabled'
                   name: 'beepEnabled'
                   visibilityChannel: false
                   model: beepEnabled
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Show Accelerator Keys in Menus'
                   name: 'showAccelerators'
                   activeHelpKey: showAccelerators
                   model: showAccelerators
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (ViewSpec
                   name: 'SeparatingSpace1'
                   extent: (Point 530 4)
                 )
                (DividerSpec
                   name: 'Separator1'
                   extent: (Point 530 3)
                 )
                (ViewSpec
                   name: 'SeparatingSpace2'
                   extent: (Point 530 3)
                 )
                (CheckBoxSpec
                   label: 'Keyboard Focus Follows Mouse'
                   name: 'focusFollowsMouse'
                   activeHelpKey: focusFollowsMouse
                   model: focusFollowsMouse
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'MouseWheel Focus Follows Mouse'
                   name: 'mouseWheelFocusFollowsMouse'
                   activeHelpKey: mouseWheelFocusFollowsMouse
                   enableChannel: mouseWheelFocusFollowsMouseEnabled
                   model: mouseWheelFocusFollowsMouse
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Zoom with CTRL- or ALT-Mousewheel'
                   name: 'CheckBox1'
                   activeHelpKey: allowMouseWheelZoom
                   model: allowMouseWheelZoom
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (ViewSpec
                   name: 'SeparatingSpace4'
                   extent: (Point 530 3)
                 )
                (DividerSpec
                   name: 'Separator2'
                   extent: (Point 530 3)
                 )
                (ViewSpec
                   name: 'SeparatingSpace5'
                   extent: (Point 530 3)
                 )
                (CheckBoxSpec
                   label: 'Menu Panels take Focus on Click'
                   name: 'CheckBox7'
                   activeHelpKey: menuPanelTakesFocusOnClick
                   model: menuPanelTakesFocusOnClick
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Views Catch Focus when Mapped'
                   name: 'takeFocus'
                   activeHelpKey: takeFocus
                   model: takeFocus
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Boxes Return Focus to Previously Active View'
                   name: 'returnFocus'
                   activeHelpKey: returnFocus
                   model: returnFocus
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Raise & Activate Windows on Click'
                   name: 'activateOnClick'
                   activeHelpKey: activateOnClick
                   model: activateOnClick
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Autoraise Windows on FocusIn'
                   name: 'CheckBox4'
                   activeHelpKey: autoRaiseOnFocusIn
                   model: autoRaiseOnFocusIn
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Force Windows into Monitor''s Bounds'
                   name: 'CheckBox2'
                   activeHelpKey: forceWindowsIntoMonitorBounds
                   model: forceWindowsIntoMonitorBounds
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Applications Remember Last Extent as Default'
                   name: 'CheckBox5'
                   activeHelpKey: shouldRememberLastExtent
                   model: shouldRememberLastExtentHolder
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (ViewSpec
                   name: 'SeparatingSpace5'
                   extent: (Point 530 4)
                 )
                (DividerSpec
                   name: 'Separator3'
                   extent: (Point 530 4)
                 )
                (ViewSpec
                   name: 'SeparatingSpace6'
                   extent: (Point 530 3)
                 )
                (CheckBoxSpec
                   label: 'Select on Right-Button-Press'
                   name: 'selectOnRightClick'
                   activeHelpKey: selectOnRightClick
                   model: selectOnRightClick
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'Menu on Right-Button-Release'
                   name: 'showRightButtonMenuOnRelease'
                   activeHelpKey: showRightButtonMenuOnRelease
                   model: showRightButtonMenuOnRelease
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (CheckBoxSpec
                   label: 'ALT-Leftclick is Rightclick'
                   name: 'CheckBox3'
                   activeHelpKey: button2WithAltKey
                   model: button2WithAltKey
                   translateLabel: true
                   extent: (Point 530 30)
                 )
                (ViewSpec
                   name: 'SeparatingSpace7'
                   extent: (Point 530 4)
                 )
                (DividerSpec
                   name: 'Separator4'
                   extent: (Point 530 4)
                 )
                (ViewSpec
                   name: 'SeparatingSpace8'
                   extent: (Point 530 4)
                 )
                (ViewSpec
                   name: 'Box1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Label'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 0 0 218 0 20 0)
                         activeHelpKey: hostNameInLabel
                         translateLabel: true
                         labelChannel: formatHostNameWindowLabel
                         adjust: right
                         useDefaultExtent: true
                       )
                      (LabelSpec
                         label: 'Label'
                         name: 'Label2'
                         layout: (LayoutFrame 0 0.30000000000000004 30 0 0 0.59999999999999998 0 1)
                         activeHelpKey: hostNameInLabel
                         translateLabel: true
                         labelChannel: formatHostNameWindowLabel1
                         adjust: left
                       )
                      (LabelSpec
                         label: 'Label'
                         name: 'Label3'
                         layout: (LayoutFrame 0 0.59999999999999998 30 0 0 1 0 1)
                         activeHelpKey: hostNameInLabel
                         translateLabel: true
                         labelChannel: formatHostNameWindowLabel2
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 530 92)
                 )
                (ViewSpec
                   name: 'WindowLabelBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Window Label Format'
                         name: 'hostNameInLabelHolder'
                         layout: (LayoutFrame 0 0 0 0 216 0 30 0)
                         activeHelpKey: hostNameInLabel
                         model: hostNameInLabelHolder
                         translateLabel: true
                       )
                      (InputFieldSpec
                         name: 'hostNameInLabelEntryField'
                         layout: (LayoutFrame 218 0 0 0 -5 1 30 0)
                         activeHelpKey: hostNameInLabel
                         enableChannel: hostNameInLabelHolder
                         model: newWindowLabelFormat
                         immediateAccept: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 530 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::MiscDisplaySettingsAppl methodsFor:'actions'!

basicReadSettings
    super basicReadSettings.

    self shouldRememberLastExtentHolder value:currentUserPrefs shouldRememberLastExtent.
    self newWindowLabelFormat value:StandardSystemView windowLabelFormat.
    self hostNameInLabelHolder value:StandardSystemView includeHostNameInLabel.
    self returnFocus value:StandardSystemView returnFocusWhenClosingModalBoxes.
    self takeFocus value:StandardSystemView takeFocusWhenMapped.
    self activateOnClick value:(Screen current activateOnClick:nil).
    self showAccelerators value:MenuView showAcceleratorKeys.

    self autoRaiseOnFocusIn value: (currentUserPrefs autoRaiseOnFocusInDelay notNil).
!

basicSaveSettings
    |currentScreen|

    currentScreen := Screen current.

    (self hostNameInLabelHolder value ~= StandardSystemView includeHostNameInLabel
    or:[self newWindowLabelFormat value ~= StandardSystemView windowLabelFormat]) ifTrue:[
        StandardSystemView includeHostNameInLabel:self hostNameInLabelHolder value.
        self newWindowLabelFormat value notNil ifTrue:[
            StandardSystemView windowLabelFormat:self newWindowLabelFormat value
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

    super basicSaveSettings.

    currentUserPrefs shouldRememberLastExtent:(self shouldRememberLastExtentHolder value).
    StandardSystemView returnFocusWhenClosingModalBoxes:self returnFocus value.
    StandardSystemView takeFocusWhenMapped:self takeFocus value.
    currentScreen activateOnClick:self activateOnClick value.

    MenuView showAcceleratorKeys:self showAccelerators value.

    self autoRaiseOnFocusIn value ~= (currentUserPrefs autoRaiseOnFocusInDelay notNil) ifTrue:[
        currentUserPrefs autoRaiseOnFocusInDelay:(
            self autoRaiseOnFocusIn value ifTrue:[ 750 ] ifFalse:[nil]).
    ].

    "Modified: / 16.12.2002 / 18:06:31 / penk"
!

formatHostNameinWindowLabels
    |newFormat|

    newFormat := Dialog
                request:'Define the Format of Window Labels:\\  %1 - Label\  %2 - Hostname\  %3 - Username\  %4 - ProcessId\'
                        withCRs
                initialAnswer:newWindowLabelFormat.
    newFormat size > 0 ifTrue:[
        newWindowLabelFormat := newFormat.
        self updateModifiedChannel
    ]
! !

!AbstractSettingsApplication::MiscDisplaySettingsAppl methodsFor:'aspects'!

activateOnClick
    activateOnClick isNil ifTrue:[
        activateOnClick := true asValue.
        activateOnClick onChangeSend:#updateModifiedChannel to:self
    ].
    ^ activateOnClick.
!

allowMouseWheelZoom
    allowMouseWheelZoom isNil ifTrue:[
        allowMouseWheelZoom := true asValue.
        allowMouseWheelZoom onChangeSend:#updateModifiedChannel to:self
    ].
    ^ allowMouseWheelZoom.
!

aspects
    ^ #(
        beepEnabled
        focusFollowsMouse
        mouseWheelFocusFollowsMouse
        showRightButtonMenuOnRelease
        selectOnRightClick
        allowMouseWheelZoom
        forceWindowsIntoMonitorBounds
        button2WithAltKey
        menuPanelTakesFocusOnClick
    )

    "Modified: / 31-07-2013 / 18:14:44 / cg"
!

autoRaiseOnFocusIn
    autoRaiseOnFocusIn isNil ifTrue:[
        autoRaiseOnFocusIn := true asValue.
        autoRaiseOnFocusIn onChangeSend:#updateModifiedChannel to:self
    ].
    ^ autoRaiseOnFocusIn.
!

beepEnabled
    beepEnabled isNil ifTrue:[
        beepEnabled := true asValue.
        beepEnabled onChangeSend:#updateModifiedChannel to:self
    ].
    ^ beepEnabled.
!

button2WithAltKey
    button2WithAltKey isNil ifTrue:[
        button2WithAltKey := false asValue.
        button2WithAltKey onChangeSend:#updateModifiedChannel to:self
    ].
    ^ button2WithAltKey.
!

displaySupportsNativeDialogs
    ^ Screen current supportsNativeDialogs
!

displaySupportsNativeWidgets
    ^ Screen current supportsNativeWidgets
!

focusFollowsMouse
    focusFollowsMouse isNil ifTrue:[
        focusFollowsMouse := true asValue.
        focusFollowsMouse onChangeSend:#updateModifiedChannel to:self
    ].
    ^ focusFollowsMouse.
!

forceWindowsIntoMonitorBounds
    forceWindowsIntoMonitorBounds isNil ifTrue:[
        forceWindowsIntoMonitorBounds := true asValue.
        forceWindowsIntoMonitorBounds onChangeSend:#updateModifiedChannel to:self
    ].
    ^ forceWindowsIntoMonitorBounds.

    "Created: / 22-10-2010 / 14:25:40 / cg"
!

formatHostNameWindowLabel
    formatHostNameWindowLabel isNil ifTrue:[
        formatHostNameWindowLabel :=
            (resources string:'Window Label Format:').
    ].
    ^ formatHostNameWindowLabel.

    "Created: / 16-12-2002 / 17:50:49 / penk"
    "Modified: / 22-08-2006 / 11:43:41 / cg"
!

formatHostNameWindowLabel1
    formatHostNameWindowLabel1 isNil ifTrue:[
        formatHostNameWindowLabel1 :=
            (resources stringWithCRs:'%1 - Label\%2 - Hostname\%3 - Username')
    ].
    ^ formatHostNameWindowLabel1.

    "Created: / 16-12-2002 / 17:50:49 / penk"
    "Modified: / 22-08-2006 / 11:43:41 / cg"
!

formatHostNameWindowLabel2
    formatHostNameWindowLabel2 isNil ifTrue:[
        formatHostNameWindowLabel2 :=
            (resources stringWithCRs:'%4 - ProcessId\%5 - TOP-Directory\%6 - TOP-Path').
    ].
    ^ formatHostNameWindowLabel2.

    "Created: / 16-12-2002 / 17:50:49 / penk"
    "Modified: / 22-08-2006 / 11:43:41 / cg"
!

hostNameInLabelHolder
    hostNameInLabelHolder isNil ifTrue:[
        hostNameInLabelHolder := true asValue.
        hostNameInLabelHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ hostNameInLabelHolder.
!

menuPanelTakesFocusOnClick
    menuPanelTakesFocusOnClick isNil ifTrue:[
        menuPanelTakesFocusOnClick := false asValue.
        menuPanelTakesFocusOnClick onChangeSend:#updateModifiedChannel to:self
    ].
    ^ menuPanelTakesFocusOnClick.
!

mouseWheelFocusFollowsMouse
    mouseWheelFocusFollowsMouse isNil ifTrue:[
        mouseWheelFocusFollowsMouse := true asValue.
        mouseWheelFocusFollowsMouse onChangeSend:#updateModifiedChannel to:self
    ].
    ^ mouseWheelFocusFollowsMouse.
!

mouseWheelFocusFollowsMouseEnabled
    ^ BlockValue
        forLogicalNot:(self focusFollowsMouse).
!

newWindowLabelFormat
    newWindowLabelFormat isNil ifTrue:[
        newWindowLabelFormat := true asValue.
        newWindowLabelFormat onChangeSend:#updateModifiedChannel to:self
    ].
    ^ newWindowLabelFormat.

    "Created: / 16.12.2002 / 17:50:49 / penk"
!

returnFocus
    returnFocus isNil ifTrue:[
        returnFocus := true asValue.
        returnFocus onChangeSend:#updateModifiedChannel to:self
    ].
    ^ returnFocus.
!

selectOnRightClick
    selectOnRightClick isNil ifTrue:[
        selectOnRightClick := true asValue.
        selectOnRightClick onChangeSend:#updateModifiedChannel to:self
    ].
    ^ selectOnRightClick.
!

shouldRememberLastExtentHolder
    shouldRememberLastExtentHolder isNil ifTrue:[
        shouldRememberLastExtentHolder := true asValue.
        shouldRememberLastExtentHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ shouldRememberLastExtentHolder.
!

showAccelerators
    showAccelerators isNil ifTrue:[
        showAccelerators := true asValue.
        showAccelerators onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showAccelerators.
!

showRightButtonMenuOnRelease
    showRightButtonMenuOnRelease isNil ifTrue:[
        showRightButtonMenuOnRelease := true asValue.
        showRightButtonMenuOnRelease onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showRightButtonMenuOnRelease.
!

takeFocus
    takeFocus isNil ifTrue:[
        takeFocus := true asValue.
        takeFocus onChangeSend:#updateModifiedChannel to:self
    ].
    ^ takeFocus.
! !

!AbstractSettingsApplication::MiscDisplaySettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/miscSettings.html'
! !

!AbstractSettingsApplication::MiscDisplaySettingsAppl methodsFor:'queries'!

hasUnsavedChanges
     (super hasUnsavedChanges) ifTrue:[^ true].

    self shouldRememberLastExtentHolder value ~= currentUserPrefs shouldRememberLastExtent ifTrue:[^ true].
    self newWindowLabelFormat value ~= StandardSystemView windowLabelFormat ifTrue:[^ true].
    self hostNameInLabelHolder value ~= StandardSystemView includeHostNameInLabel ifTrue:[^ true].
    self returnFocus value ~= StandardSystemView returnFocusWhenClosingModalBoxes ifTrue:[^ true].
    self takeFocus value ~= StandardSystemView takeFocusWhenMapped ifTrue:[^ true].
    self activateOnClick value ~= (Screen current activateOnClick:nil) ifTrue:[^ true].
    self showAccelerators value ~= MenuView showAcceleratorKeys ifTrue:[^ true].
    self autoRaiseOnFocusIn value ~= (currentUserPrefs autoRaiseOnFocusInDelay notNil) ifTrue:[^ true].
    ^ false
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#windowMigration
'The window migration service is available for X-display systems only.\It allows a window to be fetched from your screen and moved to another X-display'

#remoteBrowsing
'The remote browsing service allows for another ST/X system''s browser to request a classes source from your running system'

#smallTeamCommon
'The smallTeam framework distributes notifications to team members when code is changed in a browser.\This allows for team members to track and follow your changes in real time.'

#smallTeam
'This enables the smallteam server in a local network.\Changes are interchanged with the listed partner hosts'

#smallTeamHosts
'List of hosts with which change notifications are to be exchanged (local team members)'

#smallTeamHostToAdd
'Name of host to add (with button below)'

#addSmallTeamHost
'Add the above hostname to the list of team members'

#removeSmallTeamHost
'Remove the selected hostname from the list of team members'

#smallTeamViaXMPP
'This enables the smallteam server in a global network.\Changes are interchanged via XMPP with the listed XMPP partners'

#xmppServer
'The xmpp server which distributes your xmpp messages (you need a login account there)'

#xmppLoginUser
'Your login username on the above xmpp server'

#xmppLoginPassword
'Your login password on the above xmpp server'

#smallTeamXMPPUsers
'List of users with which change notifications are to be exchanged (global team members)'

#smallTeamXMPPUserToAdd
'Name of user to add (with button below)'

#addSmallTeamXMPPUser
'Add the above username to the list of team members'

#removeSmallTeamXMPPUser
'Remove the selected username from the list of team members'
)
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@!!8@@@@@@BG @@@!!1]P@@@@AWE8@@!!1 '' @@@BGFB^@!!1 5Q8@@BCFCUG !!DWQPH@@BDQMHD \QFA] @@@1DXE6X"DQ]VY&Y"HQE5I&@!!]QI&Y&XBEED"TG
]QD&Y&IPL5ERQ5 !!TV@@ACVBEQIF$REXP@@DX1HU!!@$''HXP@@@T2L!!!!@@GI(@@@@AVL&!!@@@UGP@@@@G]TM@@@@@P@@@@@A5A@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') colorMapFromArray:#[0 0 0 224 224 224 64 64 64 96 96 96 128 128 128 192 192 192 32 32 32 96 96 96 160 160 160 96 96 96] mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'G@C O G0_0O8?8_<?(_<?8_<???<???<???<?8_<?8_<_0O8O G0O@G B@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'); yourself); yourself]
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Smalltalk Communication Settings'
         name: 'Smalltalk Communication Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 751 766)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Window migration'
                   name: 'WindowMicrationSetupBox'
                   activeHelpKey: windowMigration
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel2'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         horizontalLayout: left
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'Box2'
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Window migration enabled'
                                     name: 'CheckBox2'
                                     layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                                     enableChannel: hasWindowMigrationServer
                                     model: windowMigrationEnabled
                                     translateLabel: true
                                   )
                                  )

                               )
                               extent: (Point 696 25)
                             )
                            (ViewSpec
                               name: 'Box3'
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Password check'
                                     name: 'CheckBox3'
                                     layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                                     enableChannel: enablePasswordCheck
                                     model: windowMigrationAuthenticate
                                     translateLabel: true
                                   )
                                  )

                               )
                               extent: (Point 696 25)
                             )
                            (ViewSpec
                               name: 'Box4'
                               component:
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Password:'
                                     name: 'Label3'
                                     layout: (LayoutFrame 0 0 0 0 150 0 25 0)
                                     translateLabel: true
                                     adjust: right
                                     enableDisableColorChannel: enablePasswordCheck
                                   )
                                  (InputFieldSpec
                                     name: 'EntryField1'
                                     layout: (LayoutFrame 150 0 0 0 400 0 25 0)
                                     enableChannel: windowMigrationAuthenticate
                                     model: windowMigrationPassword
                                     type: password
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                   )
                                  )

                               )
                               extent: (Point 696 25)
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 751 120)
                 )
                (FramedBoxSpec
                   label: 'Remote Browsing'
                   name: 'RemoteBrowsingSetupBox'
                   activeHelpKey: remoteBrowsing
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box1'
                         layout: (LayoutFrame 0 0 5 0 0 1 30 0)
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Remote browsing enabled'
                               name: 'CheckBox1'
                               layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                               enableChannel: hasRemoteBrowsingSupport
                               model: remoteBrowsingEnabled
                               translateLabel: true
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 751 70)
                 )
                (FramedBoxSpec
                   label: 'SmallTeam Change Distribution'
                   name: 'SmallTeamSetupBox'
                   activeHelpKey: smallTeamCommon
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'enableBox'
                         layout: (LayoutFrame 0 0 8 0 0 1 33 0)
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'SmallTeam Server enabled'
                               name: 'CheckBox4'
                               layout: (LayoutFrame 5 0 0 0 600 0 25 0)
                               enableChannel: smallTeamServerAvailable
                               model: smallTeamServerEnabled
                               translateLabel: true
                               activeHelpKey: smallTeam
                             )
                            )

                         )
                       )
                      (LabelSpec
                         label: 'SmallTeam Hosts:'
                         name: 'smallTeamHostsLabel'
                         layout: (LayoutFrame 0 0.0 37 0 60 0.25 62 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: smallTeamServerAvailable
                         activeHelpKey: smallTeamHosts
                       )
                      (SequenceViewSpec
                         name: 'smallTeamHostsList'
                         layout: (LayoutFrame 64 0.25 37 0 0 1 131 0)
                         enableChannel: smallTeamServerEnabled
                         tabable: true
                         model: selectedSmallTeamHost
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: true
                         useIndex: false
                         sequenceList: listOfSmallTeamHosts
                         activeHelpKey: smallTeamHosts
                       )
                      (LabelSpec
                         label: 'Host:'
                         name: 'hostLabel'
                         layout: (LayoutFrame 0 0.0 137 0 60 0.25 162 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: smallTeamServerEnabled
                         activeHelpKey: smallTeamHostToAdd
                       )
                      (InputFieldSpec
                         name: 'smallTeamHostEntryField'
                         layout: (LayoutFrame 64 0.25 138 0 0 1 163 0)
                         enableChannel: smallTeamServerEnabled
                         tabable: true
                         model: smallTeamHostEntry
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         activeHelpKey: smallTeamHostToAdd
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel2'
                         layout: (LayoutFrame 64 0.25 168 0 -1 1 193 0)
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Add'
                               name: 'addButton'
                               translateLabel: true
                               tabable: true
                               model: addSmallTeamHost
                               enableChannel: addHostEnabled
                               extent: (Point 226 22)
                               activeHelpKey: addSmallTeamHost
                             )
                            (ActionButtonSpec
                               label: 'Remove'
                               name: 'removeButton'
                               translateLabel: true
                               tabable: true
                               model: removeSmallTeamHost
                               enableChannel: removeHostEnabled
                               extent: (Point 226 22)
                               activeHelpKey: removeSmallTeamHost
                             )
                            )

                         )
                       )
                      (CheckBoxSpec
                         label: 'XMPP SmallTeam enabled'
                         name: 'CheckBox5'
                         layout: (LayoutFrame 5 0 197 0 600 0 222 0)
                         enableChannel: smallTeamViaXMPPAvailable
                         model: smallTeamViaXMPPEnabled
                         translateLabel: true
                         activeHelpKey: smallTeamViaXMPP
                       )
                      (LabelSpec
                         label: 'XMPP Team Members:'
                         name: 'Label4'
                         layout: (LayoutFrame 0 0.0 323 0 60 0.25 348 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: smallTeamViaXMPPEnabled
                         activeHelpKey: smallTeamXMPPUsers
                       )
                      (SequenceViewSpec
                         name: 'List1'
                         layout: (LayoutFrame 64 0.25 323 0 0 1 417 0)
                         enableChannel: smallTeamViaXMPPEnabled
                         tabable: true
                         model: selectedXMPPSmallTeamUser
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: true
                         useIndex: false
                         sequenceList: listOfXMPPSmallTeamUsers
                         activeHelpKey: smallTeamXMPPUsers
                       )
                      (LabelSpec
                         label: 'Member:'
                         name: 'Label5'
                         layout: (LayoutFrame 0 0.0 423 0 60 0.25 448 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: smallTeamViaXMPPEnabled
                         activeHelpKey: smallTeamXMPPUserToAdd
                       )
                      (InputFieldSpec
                         name: 'EntryField2'
                         layout: (LayoutFrame 64 0.25 424 0 0 1 449 0)
                         enableChannel: smallTeamViaXMPPEnabled
                         tabable: true
                         model: xmppSmallTeamUserEntry
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         activeHelpKey: smallTeamXMPPUserToAdd
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel3'
                         layout: (LayoutFrame 64 0.25 455 0 -1 1 480 0)
                         horizontalLayout: fitSpace
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Add'
                               name: 'Button3'
                               translateLabel: true
                               tabable: true
                               model: addSmallTeamHost
                               enableChannel: addXMPPUserEnabled
                               extent: (Point 226 22)
                               activeHelpKey: addSmallTeamXMPPUser
                             )
                            (ActionButtonSpec
                               label: 'Remove'
                               name: 'Button4'
                               translateLabel: true
                               tabable: true
                               model: removeSmallTeamHost
                               enableChannel: removeXMPPUserEnabled
                               extent: (Point 226 22)
                               activeHelpKey: removeSmallTeamXMPPUser
                             )
                            )

                         )
                       )
                      (LabelSpec
                         label: 'XMPP Server:'
                         name: 'Label6'
                         layout: (LayoutFrame 0 0.0 227 0 60 0.25 252 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: smallTeamViaXMPPEnabled
                         activeHelpKey: xmppServer
                       )
                      (InputFieldSpec
                         name: 'EntryField3'
                         layout: (LayoutFrame 64 0.25 228 0 0 1 253 0)
                         enableChannel: smallTeamViaXMPPEnabled
                         tabable: true
                         model: smallteamXMPPServer
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         activeHelpKey: xmppServer
                       )
                      (LabelSpec
                         label: 'XMPP Username:'
                         name: 'Label7'
                         layout: (LayoutFrame 0 0.0 258 0 60 0.25 283 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: smallTeamViaXMPPEnabled
                         activeHelpKey: xmppLoginUser
                       )
                      (InputFieldSpec
                         name: 'EntryField4'
                         layout: (LayoutFrame 64 0.25 259 0 0 1 284 0)
                         enableChannel: smallTeamViaXMPPEnabled
                         tabable: true
                         model: smallteamXMPPUser
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         activeHelpKey: xmppLoginUser
                       )
                      (LabelSpec
                         label: 'XMPP Password:'
                         name: 'Label8'
                         layout: (LayoutFrame 0 0.0 288 0 60 0.25 313 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: smallTeamViaXMPPEnabled
                         activeHelpKey: xmppLoginPassword
                       )
                      (InputFieldSpec
                         name: 'EntryField5'
                         layout: (LayoutFrame 64 0.25 289 0 0 1 314 0)
                         enableChannel: smallTeamViaXMPPEnabled
                         tabable: true
                         model: smallteamXMPPPassword
                         type: password
                         acceptChannel: acceptChannel
                         acceptOnPointerLeave: true
                         activeHelpKey: xmppLoginPassword
                       )
                      )

                   )
                   extent: (Point 751 521)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'actions'!

aspects
    ^ #(
                smallteamViaXMPPEnabled
                smallteamXMPPPassword
                smallteamXMPPUser
                smallteamXMPPServer
            )
!

basicReadSettings
    |pw auth|

    super basicReadSettings.

    SmallTeam notNil ifTrue:[
        self smallTeamServerEnabled value:(SmallTeam isLoaded and:[SmallTeam serverRunning]).
        self listOfSmallTeamHosts contents:(SmallTeam connectedHosts).
    ].

    self remoteBrowsingEnabled
        value:(self hasRemoteBrowsingSupport
               and:[SmalltalkShareServer isLoaded and:[SmalltalkShareServer serverRunning]]).

    self windowMigrationEnabled
        value:(self hasWindowMigrationServer
               and:[ WindowMigrationServer isLoaded
               and:[ WindowMigrationServer serverRunning ]]).


    pw := nil.
    auth := false.
    (self hasWindowMigrationServer and:[WindowMigrationServer isLoaded]) ifTrue:[
        pw := WindowMigrationServer password.
        auth := self windowMigrationPassword value notNil
    ].

    self windowMigrationPassword value:pw.
    self windowMigrationAuthenticate value:auth

    "Modified: / 20-09-2007 / 16:04:59 / cg"
!

basicSaveSettings
    super basicSaveSettings.
    self smallTeamServerAvailable ifTrue:[
        SmallTeam connectedHosts copy do:[:host |
            (self listOfSmallTeamHosts includes:host) ifFalse:[
                SmallTeam removeHost:host.
            ].
        ].
        self listOfSmallTeamHosts do:[:eachHost |
            SmallTeam addHost:eachHost.
        ].
        self smallTeamServerEnabled value ifTrue:[
            SmallTeam startServer
        ] ifFalse:[
            SmallTeam stopServer
        ].
    ].
    self smallTeamViaXMPPAvailable ifTrue:[
        SmallTeamXMPPRoboter listOfXMPPUsers copy do:[:user |
            (self listOfXMPPSmallTeamUsers includes:user) ifFalse:[
                SmallTeamXMPPRoboter removeUser:user.
            ].
        ].
        self listOfXMPPSmallTeamUsers do:[:eachUser |
            SmallTeamXMPPRoboter addUser:eachUser.
        ].
        currentUserPrefs smallteamXMPPServer:(self smallteamXMPPServer value).
        currentUserPrefs smallteamXMPPUser:(self smallteamXMPPUser value).
        currentUserPrefs smallteamXMPPPassword:(self smallteamXMPPPassword value).
        self smallTeamViaXMPPEnabled value ifTrue:[
            SmallTeamXMPPRoboter startServer
        ] ifFalse:[
            SmallTeamXMPPRoboter stopServer
        ].
    ].
    self hasRemoteBrowsingSupport ifTrue:[
        self remoteBrowsingEnabled value ifFalse:[
            SmalltalkShareServer serverRunning ifTrue:[
                SmalltalkShareServer killAll
            ].
        ] ifTrue:[
            SmalltalkShareServer serverRunning ifFalse:[
                SmalltalkShareServer start.

                "/ must wait a bit; give it a chance to
                "/ really start (before checking)

                Delay waitForSeconds:0.5.
                SmalltalkShareServer serverRunning ifFalse:[
                    self warn:'SmalltalkShareServer startup failed (see stderr).'
                ]
            ].
        ].
    ].
    self hasWindowMigrationServer ifTrue:[
        self windowMigrationAuthenticate value ifTrue:[
            WindowMigrationServer password:self windowMigrationPassword value.
        ] ifFalse:[
            WindowMigrationServer password:nil
        ].
        self windowMigrationEnabled value ifFalse:[
            WindowMigrationServer serverRunning ifTrue:[
                WindowMigrationServer stop
            ].
        ] ifTrue:[
            WindowMigrationServer serverRunning ifFalse:[
                WindowMigrationServer start.

                "/ must wait a bit; give it a chance to
                "/ really start (before checking)

                Delay waitForSeconds:0.5.
                WindowMigrationServer serverRunning ifFalse:[
                    self warn:'WindowMigrationServer startup failed (see stderr).'
                ]
            ].
        ].
    ].

    "Modified: / 20-09-2007 / 16:05:01 / cg"
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'aspects'!

acceptChannel

    acceptChannel isNil ifTrue:[
        acceptChannel := TriggerValue new.
    ].
    ^ acceptChannel.

    "Created: / 12-11-2006 / 19:04:09 / cg"
!

addHostEnabled
    ^ self smallTeamServerEnabled
!

addXMPPUserEnabled
    ^ self smallTeamViaXMPPEnabled
!

enablePasswordCheck

    enablePasswordCheck isNil ifTrue:[
        self hasWindowMigrationServer ifFalse:[
            enablePasswordCheck := false asValue.
        ] ifTrue:[
            enablePasswordCheck := self windowMigrationEnabled.
        ].
    ].
    ^ enablePasswordCheck.
!

listOfSmallTeamHosts

    listOfSmallTeamHosts isNil ifTrue:[
        listOfSmallTeamHosts := List new.
        listOfSmallTeamHosts onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ listOfSmallTeamHosts.

    "Created: / 12-11-2006 / 19:06:35 / cg"
!

listOfXMPPSmallTeamUsers

    listOfXMPPSmallTeamUsers isNil ifTrue:[
        listOfXMPPSmallTeamUsers := List new.
        listOfXMPPSmallTeamUsers onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ listOfXMPPSmallTeamUsers.
!

remoteBrowsingEnabled

    remoteBrowsingEnabled isNil ifTrue:[
        remoteBrowsingEnabled := true asValue.
        remoteBrowsingEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ remoteBrowsingEnabled.
!

removeHostEnabled
    ^ BlockValue
        forLogical:self smallTeamServerEnabled
        and:(BlockValue
                with:[:h | h notEmptyOrNil]
                argument:self selectedSmallTeamHost)

    "Created: / 12-11-2006 / 19:01:42 / cg"
    "Modified: / 08-03-2007 / 23:02:36 / cg"
!

removeXMPPUserEnabled
    ^ BlockValue
        forLogical:self smallTeamViaXMPPEnabled
        and:(BlockValue
                with:[:h | h notEmptyOrNil]
                argument:self selectedXMPPSmallTeamUser)
!

selectedSmallTeamHost

    selectedSmallTeamHost isNil ifTrue:[
        selectedSmallTeamHost := nil asValue.
        selectedSmallTeamHost onChangeSend:#selectedSmallTeamHostChanged to:self.
    ].
    ^ selectedSmallTeamHost.

    "Created: / 12-11-2006 / 19:11:01 / cg"
!

selectedXMPPSmallTeamUser

    selectedXMPPSmallTeamUser isNil ifTrue:[
        selectedXMPPSmallTeamUser := nil asValue.
        selectedXMPPSmallTeamUser onChangeSend:#selectedXMPPSmallTeamUserChanged to:self.
    ].
    ^ selectedXMPPSmallTeamUser.
!

smallTeamHostEntry

    smallTeamHostEntry isNil ifTrue:[
        smallTeamHostEntry := nil asValue.
        smallTeamHostEntry onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallTeamHostEntry.

    "Created: / 12-11-2006 / 19:07:06 / cg"
!

smallTeamServerAvailable
    ^ SmallTeam notNil.

    "Created: / 12-11-2006 / 18:56:20 / cg"
!

smallTeamServerEnabled

    smallTeamServerEnabled isNil ifTrue:[
        smallTeamServerEnabled := false asValue.
        smallTeamServerEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallTeamServerEnabled.

    "Created: / 12-11-2006 / 18:56:11 / cg"
!

smallTeamViaXMPPAvailable
    ^ SmallTeam notNil
        and:[ JBCClient notNil and:[ SmallTeamXMPPRoboter notNil ] ].
!

smallTeamViaXMPPEnabled

    smallTeamViaXMPPEnabled isNil ifTrue:[
        smallTeamViaXMPPEnabled := false asValue.
        smallTeamViaXMPPEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallTeamViaXMPPEnabled.
!

smalltalkBridgeEnabled

    smalltalkBridgeEnabled isNil ifTrue:[
        smalltalkBridgeEnabled := false asValue.
        smalltalkBridgeEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smalltalkBridgeEnabled.
!

smalltalkBridgeVerbose

    smalltalkBridgeVerbose isNil ifTrue:[
        smalltalkBridgeVerbose := false asValue.
        smalltalkBridgeVerbose onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smalltalkBridgeVerbose.
!

smallteamXMPPPassword

    smallteamXMPPPassword isNil ifTrue:[
        smallteamXMPPPassword := '' asValue.
        smallteamXMPPPassword onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallteamXMPPPassword.
!

smallteamXMPPServer

    smallteamXMPPServer isNil ifTrue:[
        smallteamXMPPServer := '' asValue.
        smallteamXMPPServer onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallteamXMPPServer.
!

smallteamXMPPUser

    smallteamXMPPUser isNil ifTrue:[
        smallteamXMPPUser := '' asValue.
        smallteamXMPPUser onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallteamXMPPUser.
!

windowMigrationAuthenticate

    windowMigrationAuthenticate isNil ifTrue:[
        windowMigrationAuthenticate := true asValue.
        windowMigrationAuthenticate onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ windowMigrationAuthenticate.
!

windowMigrationEnabled

    windowMigrationEnabled isNil ifTrue:[
        windowMigrationEnabled := true asValue.
        windowMigrationEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ windowMigrationEnabled.
!

windowMigrationPassword

    windowMigrationPassword isNil ifTrue:[
        windowMigrationPassword := ValueHolder new.
        windowMigrationPassword onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ windowMigrationPassword.
!

xmppSmallTeamUserEntry

    xmppSmallTeamUserEntry isNil ifTrue:[
        xmppSmallTeamUserEntry := nil asValue.
        xmppSmallTeamUserEntry onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ xmppSmallTeamUserEntry.
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'change & update'!

selectedSmallTeamHostChanged
    self acceptChannel value:true.
    self smallTeamHostEntry value:( self selectedSmallTeamHost value).

    "Created: / 12-11-2006 / 19:09:49 / cg"
!

selectedXMPPSmallTeamUserChanged
    self acceptChannel value:true.
    self xmppSmallTeamUserEntry value:( self selectedXMPPSmallTeamUser value).
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/communicationsSettings.html'
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'help specs'!

flyByHelpTextForKey:aKey
    |normalText|

    normalText := super flyByHelpTextForKey:aKey.
    aKey == #windowMigration ifTrue:[
        self hasWindowMigrationServer ifFalse:[
            ^ normalText , (resources stringWithCRs:'\\Disabled because the windowMigration package is not loaded')
        ]
    ].
    aKey == #remoteBrowsing ifTrue:[
        self hasWindowMigrationServer ifFalse:[
            ^ normalText , (resources stringWithCRs:'\\Disabled because the remoteBrowsing package is not loaded')
        ]
    ].
    (#(smallTeamCommon
       smallTeam smallTeamHosts
       addSmallTeamHost removeSmallTeamHost
       smallTeamViaXMPP
       xmppServer xmppLoginUser xmppLoginPassword
       smallTeamXMPPUsers smallTeamXMPPUserToAdd
       addSmallTeamXMPPUser removeSmallTeamXMPPUser
    ) includes:aKey) ifTrue:[
        self hasWindowMigrationServer ifFalse:[
            ^ normalText , (resources stringWithCRs:'\\Disabled because the smallTeam package is not loaded')
        ]
    ].
    ^ normalText
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'initialization & release'!

initialize
    super initialize.
    self readSettings.
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'queries'!

hasRemoteBrowsingSupport

    ^ SmalltalkShareServer notNil
!

hasUnsavedChanges
    (super hasUnsavedChanges) ifTrue:[
        ^ true
    ].
    (self smallTeamServerAvailable) ifTrue:[
        self smallTeamServerEnabled value
            ~= (SmallTeam isLoaded and:[ SmallTeam serverRunning ]) ifTrue:[ ^ true ].
        self listOfSmallTeamHosts asSet ~= (SmallTeam connectedHosts asSet) ifTrue:[
            ^ true
        ].
    ].
    (self smallTeamViaXMPPAvailable) ifTrue:[
        self smallTeamViaXMPPEnabled value ~= (SmallTeamXMPPRoboter isLoaded
                    and:[ SmallTeamXMPPRoboter serverRunning ]) ifTrue:[
            ^ true
        ].
        self listOfXMPPSmallTeamUsers asSet
            ~= ((SmallTeamXMPPRoboter listOfXMPPUsers ? #()) asSet) ifTrue:[ ^ true ].
        self smallteamXMPPServer value ~= (currentUserPrefs smallteamXMPPServer) ifTrue:[
            ^ true
        ].
        self smallteamXMPPUser value ~= (currentUserPrefs smallteamXMPPUser) ifTrue:[
            ^ true
        ].
        self smallteamXMPPPassword value
            ~= (currentUserPrefs smallteamXMPPPassword) ifTrue:[ ^ true ].
    ].
    (self hasRemoteBrowsingSupport and:[ SmalltalkShareServer isLoaded ]) ifTrue:[
        self remoteBrowsingEnabled value ~~ SmalltalkShareServer serverRunning ifTrue:[
            ^ true
        ].
    ].
    self hasWindowMigrationServer ifTrue:[
        WindowMigrationServer isLoaded ifFalse:[
            self windowMigrationEnabled value ifTrue:[
                WindowMigrationServer autoload.
            ].
        ].
        (self windowMigrationEnabled value ~~ WindowMigrationServer serverRunning) ifTrue:[
            ^ true
        ].
        (self windowMigrationPassword value ~= WindowMigrationServer password) ifTrue:[
            ^ true
        ].
        (self windowMigrationAuthenticate value
            ~= self windowMigrationPassword value notNil) ifTrue:[ ^ true ].
    ].
    ^ false

    "Modified: / 20-09-2007 / 16:04:56 / cg"
!

hasWindowMigrationServer

    ^ WindowMigrationServer notNil
! !

!AbstractSettingsApplication::MiscSmalltalkCommunicationSettingsAppl methodsFor:'user actions'!

addSmallTeamHost
    |host|

    acceptChannel value:true.

    host := self smallTeamHostEntry value.

    host size > 0 ifTrue:[
        self listOfSmallTeamHosts add:host
    ].

    "Modified: / 12-11-2006 / 19:06:22 / cg"
!

removeSmallTeamHost
    |host|

    acceptChannel value:true.

    host := self selectedSmallTeamHost value.

    host size > 0 ifTrue:[
        self selectedSmallTeamHost value:nil.
        self listOfSmallTeamHosts remove:host ifAbsent:[ self window beep ].
        self smallTeamHostEntry value:''.
    ].

    "Modified: / 12-11-2006 / 19:15:05 / cg"
! !

!AbstractSettingsApplication::OsiSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ AbstractSettingsApplication::MiscCommunicationSettingsAppl defaultIcon.
! !

!AbstractSettingsApplication::OsiSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::OsiSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::OsiSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::OsiSettingsAppl open
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: windowSpec
        window:
       (WindowSpec
          label: 'OSI Protocols Settings'
          name: 'OSI Protocols Settings'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 600 550)
        )
        component:
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'VerticalPanel2'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              component:
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'ACSE'
                    name: 'Label1'
                    translateLabel: true
                    extent: (Point 600 22)
                  )
                 (ViewSpec
                    name: 'Box1a'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Errors'
                          name: 'CheckBox1'
                          layout: (LayoutFrame 25 0 0 0 -2 0.33 22 0)
                          enableChannel: osiACSEPresent
                          model: osiACSEErrorLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 27)
                  )
                 (ViewSpec
                    name: 'Box1b'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Connections'
                          name: 'CheckBox10'
                          layout: (LayoutFrame 25 0 0 0 -2 0.66 22 0)
                          enableChannel: osiACSEPresent
                          model: osiACSEConnectionLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 26)
                  )
                 (ViewSpec
                    name: 'Box1c'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Data Transfer'
                          name: 'CheckBox14'
                          layout: (LayoutFrame 25 0 0 0 -2 1 22 0)
                          enableChannel: osiACSEPresent
                          model: osiACSEDataLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 26)
                  )
                 (DividerSpec
                    name: 'Separator1'
                    extent: (Point 600 4)
                  )
                 (LabelSpec
                    label: 'ROSE'
                    name: 'Label2'
                    translateLabel: true
                    extent: (Point 600 22)
                  )
                 (ViewSpec
                    name: 'Box4a'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Errors'
                          name: 'CheckBox4'
                          layout: (LayoutFrame 25 0 0 0 -2 0.33 22 0)
                          enableChannel: osiROSEPresent
                          model: osiROSEErrorLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 25)
                  )
                 (ViewSpec
                    name: 'Box4b'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Invoactions'
                          name: 'CheckBox16'
                          layout: (LayoutFrame 25 0 0 0 -2 0.66 22 0)
                          enableChannel: osiROSEPresent
                          model: osiROSEInvokationLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 25)
                  )
                 (ViewSpec
                    name: 'Box4c'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Responses'
                          name: 'CheckBox20'
                          layout: (LayoutFrame 25 0 0 0 -2 1 22 0)
                          enableChannel: osiROSEPresent
                          model: osiROSEResponseLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 25)
                  )
                 (DividerSpec
                    name: 'Separator2'
                    extent: (Point 600 3)
                  )
                 (LabelSpec
                    label: 'CMISE'
                    name: 'Label3'
                    translateLabel: true
                    extent: (Point 600 22)
                  )
                 (ViewSpec
                    name: 'Box7a'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Errors'
                          name: 'CheckBox7'
                          layout: (LayoutFrame 25 0 0 0 -2 0.33 22 0)
                          enableChannel: osiCMISEPresent
                          model: osiCMISEErrorLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 22)
                  )
                 (ViewSpec
                    name: 'Box7b'
                    component:
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Log Messages'
                          name: 'CheckBox22'
                          layout: (LayoutFrame 25 0 0 0 -2 0.66 22 0)
                          enableChannel: osiCMISEPresent
                          model: osiCMISEMessageLogging
                          translateLabel: true
                        )
                       )

                    )
                    extent: (Point 600 22)
                  )
                 )

              )
            )
           )

        )
      )
! !

!AbstractSettingsApplication::OsiSettingsAppl methodsFor:'actions'!

basicReadSettings
    self updateOSIPackagePresentHolders.
    self osiACSEPresent value ifTrue:[
        self osiACSEErrorLogging value:OSI::ACSE errorLogging.
        self osiACSEConnectionLogging value:OSI::ACSE connectionLogging.
        self osiACSEDataLogging value:OSI::ACSE dataLogging
    ].
    self osiROSEPresent value ifTrue:[
        self osiROSEErrorLogging value:OSI::ROSE errorLogging.
        self osiROSEInvokationLogging value:OSI::ROSE invocationLogging.
        self osiROSEResponseLogging value:OSI::ROSE responseLogging
    ].
    self osiCMISEPresent value ifTrue:[
        self osiCMISEErrorLogging value:OSI::CMISE errorLogging.
        self osiCMISEMessageLogging value:OSI::CMISE messageLogging
    ].
!

basicSaveSettings

    self osiACSEPresent value ifTrue:[
        OSI::ACSE errorLogging:self osiACSEErrorLogging value.
        OSI::ACSE connectionLogging:self osiACSEConnectionLogging value.
        OSI::ACSE dataLogging:self osiACSEDataLogging value.
    ].
    self osiROSEPresent value ifTrue:[
        OSI::ROSE errorLogging:self osiROSEErrorLogging value.
        OSI::ROSE invocationLogging:self osiROSEInvokationLogging value.
        OSI::ROSE responseLogging:self osiROSEResponseLogging value.
    ].
    self osiCMISEPresent value ifTrue:[
        OSI::CMISE errorLogging:self osiCMISEErrorLogging value.
        OSI::CMISE messageLogging:self osiCMISEMessageLogging value.
    ].
!

updateOSIPackagePresentHolders
    self osiACSEPresent value:(OSI::ACSE notNil and:[OSI::ACSE isLoaded]).
    self osiROSEPresent value:(OSI::ROSE notNil and:[OSI::ROSE isLoaded]).
    self osiCMISEPresent value:(OSI::CMISE notNil and:[OSI::CMISE isLoaded]).
! !

!AbstractSettingsApplication::OsiSettingsAppl methodsFor:'aspects'!

osiACSEConnectionLogging
    osiACSEConnectionLogging isNil ifTrue:[
        osiACSEConnectionLogging := true asValue.
    ].
    ^ osiACSEConnectionLogging.
!

osiACSEDataLogging

    osiACSEDataLogging isNil ifTrue:[
        osiACSEDataLogging := true asValue.
    ].
    ^ osiACSEDataLogging.
!

osiACSEErrorLogging
    osiACSEErrorLogging isNil ifTrue:[
        osiACSEErrorLogging := true asValue.
    ].
    ^ osiACSEErrorLogging.
!

osiACSEPresent
    osiACSEPresent isNil ifTrue:[
        osiACSEPresent := OSI::ACSE notNil asValue.
    ].
    ^ osiACSEPresent.
!

osiCMISEErrorLogging
    osiCMISEErrorLogging isNil ifTrue:[
        osiCMISEErrorLogging := true asValue.
    ].
    ^ osiCMISEErrorLogging.
!

osiCMISEMessageLogging
    osiCMISEMessageLogging isNil ifTrue:[
        osiCMISEMessageLogging := true asValue.
    ].
    ^ osiCMISEMessageLogging.
!

osiCMISEPresent
    osiCMISEPresent isNil ifTrue:[
        osiCMISEPresent := OSI::CMISE notNil asValue.
    ].
    ^ osiCMISEPresent.
!

osiROSEErrorLogging
    osiROSEErrorLogging isNil ifTrue:[
        osiROSEErrorLogging := true asValue.
    ].
    ^ osiROSEErrorLogging.
!

osiROSEInvokationLogging
    osiROSEInvokationLogging isNil ifTrue:[
        osiROSEInvokationLogging := true asValue.
    ].
    ^ osiROSEInvokationLogging.
!

osiROSEPresent

    osiROSEPresent isNil ifTrue:[
        osiROSEPresent := OSI::ROSE notNil asValue.
    ].
    ^ osiROSEPresent.
!

osiROSEResponseLogging

    osiROSEResponseLogging isNil ifTrue:[
        osiROSEResponseLogging := true asValue.
    ].
    ^ osiROSEResponseLogging.
! !

!AbstractSettingsApplication::OsiSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/communicationsSettings.html'
! !

!AbstractSettingsApplication::OsiSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self updateOSIPackagePresentHolders.

    (self osiACSEPresent value
        and:[
            self osiACSEErrorLogging value ~= OSI::ACSE errorLogging
            or:[ self osiACSEConnectionLogging value ~= OSI::ACSE connectionLogging
            or:[ self osiACSEDataLogging value ~= OSI::ACSE dataLogging]]]) ifTrue:[^ true].

    (self osiROSEPresent value
        and:[
            self osiROSEErrorLogging value ~= OSI::ROSE errorLogging
            or:[ self osiROSEInvokationLogging value ~= OSI::ROSE invocationLogging
            or:[ self osiROSEResponseLogging value ~= OSI::ROSE responseLogging]]]) ifTrue:[^ true].

    (self osiCMISEPresent value
        and:[
            self osiCMISEErrorLogging value ~= OSI::CMISE errorLogging
            or:[ self osiCMISEMessageLogging value ~= OSI::CMISE messageLogging]])ifTrue:[^ true].

    ^ false.
! !

!AbstractSettingsApplication::PackagePathSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MemorySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(


)
! !

!AbstractSettingsApplication::PackagePathSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary packageOpen24x24Icon
! !

!AbstractSettingsApplication::PackagePathSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::PackagePathSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::PackagePathSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::PackagePathSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Package Path Settings'
         name: 'Package Path Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 659 287)
       )
       component:
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'Package Path'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             labelPosition: topLeft
             translateLabel: true
             component:
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Folders in Package Path'
                   name: 'Label1'
                   layout: (LayoutFrame 0 0.0 10 0 0 1.0 40 0)
                   translateLabel: true
                 )
                (SequenceViewSpec
                   name: 'List1'
                   layout: (LayoutFrame 0 0 40 0 0 1 -40 1)
                   model: selectedFolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   useIndex: false
                   sequenceList: listOfFoldersInPath
                 )
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel1'
                   layout: (LayoutFrame 0 0.0 -36 1 0 1.0 4 1)
                   horizontalLayout: right
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Add...'
                         name: 'Button1'
                         translateLabel: true
                         model: addFolder
                         extent: (Point 93 31)
                         usePreferredWidth: true
                         usePreferredHeight: true
                       )
                      (ActionButtonSpec
                         label: 'Remove Selected'
                         name: 'Button2'
                         translateLabel: true
                         model: removeSelectedFolder
                         extent: (Point 144 31)
                         usePreferredWidth: true
                         usePreferredHeight: true
                       )
                      )

                   )
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::PackagePathSettingsAppl methodsFor:'actions'!

addFolder
    |folder|

    folder := Dialog requestDirectoryName:'Additional Folder with Packages:'.
    folder isEmptyOrNil ifTrue:[^ self].
    (self listOfFoldersInPath includes:folder) ifFalse:[
        self listOfFoldersInPath add:folder.
        self updateModifiedChannel.
    ].
!

basicReadSettings
    self listOfFoldersInPath contents:(Smalltalk packagePath).
!

basicSaveSettings
    Smalltalk packagePath:(self listOfFoldersInPath asOrderedCollection).
!

removeSelectedFolder
    self listOfFoldersInPath remove:(self selectedFolder value) ifAbsent:[].
    self updateModifiedChannel.
! !

!AbstractSettingsApplication::PackagePathSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
    )
!

listOfFoldersInPath
    listOfFoldersInPath isNil ifTrue:[
        listOfFoldersInPath := List new.
        listOfFoldersInPath addAll:Smalltalk packagePath
    ].
    ^ listOfFoldersInPath
!

selectedFolder
    selectedFolder isNil ifTrue:[
        selectedFolder := nil asValue.
    ].
    ^ selectedFolder
! !

!AbstractSettingsApplication::PackagePathSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/packagePathSettings.html'
! !

!AbstractSettingsApplication::PackagePathSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self listOfFoldersInPath asOrderedCollection ~= Smalltalk packagePath asOrderedCollection ifTrue:[^ true].
    ^ false.
! !

!AbstractSettingsApplication::PrinterSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary printerIcon
! !

!AbstractSettingsApplication::PrinterSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::PrinterSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::PrinterSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::PrinterSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Printer Settings'
         name: 'Printer Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 601 474)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'PrinterSelectBox'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Printer Type:'
                         name: 'PrinterTypeLabel'
                         layout: (LayoutFrame 0 0 5 0 181 0 35 0)
                         translateLabel: true
                         adjust: right
                       )
                      (ComboListSpec
                         name: 'PrinterTypeComboList'
                         layout: (LayoutFrame 183 0 5 0 -5 1 35 0)
                         model: printerTypeSelection
                         comboList: printerType
                         useIndex: true
                       )
                      (LabelSpec
                         label: 'Print Command:'
                         name: 'PrinterCommandLabel'
                         layout: (LayoutFrame 0 0 38 0 181 0 68 0)
                         visibilityChannel: printerIsDrivenByCommand
                         translateLabel: true
                         adjust: right
                       )
                      (ComboBoxSpec
                         name: 'CommandComboBox'
                         layout: (LayoutFrame 183 0 38 0 -5 1 68 0)
                         visibilityChannel: printerIsDrivenByCommand
                         enableChannel: printCommandEnabled
                         model: printCommand
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: false
                         comboList: printCommandList
                         useIndex: false
                       )
                      (LabelSpec
                         label: 'Print to File:'
                         name: 'PrinterFileLabel'
                         layout: (LayoutFrame 0 0 71 0 181 0 101 0)
                         visibilityChannel: printerSupportsPrintingToFile
                         translateLabel: true
                         adjust: right
                       )
                      (FilenameInputFieldSpec
                         name: 'PrinterFileEntryField'
                         layout: (LayoutFrame 183 0 71 0 -5 1 101 0)
                         visibilityChannel: printerSupportsPrintingToFile
                         model: printFilename
                         immediateAccept: true
                         acceptOnLeave: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: false
                       )
                      )

                   )
                   extent: (Point 601 108)
                 )
                (ViewSpec
                   name: 'FormatBox'
                   visibilityChannel: supportsPageFormatSetting
                   component:
                  (SpecCollection
                     collection: (
                      (DividerSpec
                         name: 'Separator1'
                         layout: (LayoutFrame 0 0 4 0 0 1 7 0)
                       )
                      (LabelSpec
                         label: 'Page Format:'
                         name: 'PageFormatLabel'
                         layout: (LayoutFrame 0 0 11 0 181 0 41 0)
                         translateLabel: true
                         adjust: right
                       )
                      (PopUpListSpec
                         label: 'PopUp List'
                         name: 'PageFormatPopUpList'
                         layout: (LayoutFrame 183 0 11 0 333 0 41 0)
                         translateLabel: true
                         tabable: true
                         model: pageFormat
                         enableChannel: enableFormat
                         menu: pageFormatList
                       )
                      (CheckBoxSpec
                         label: 'Landscape'
                         name: 'LandscapeCheckBox'
                         layout: (LayoutFrame 380 0 11 0 -5 1 41 0)
                         enableChannel: enablelandscape
                         model: landscape
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 601 43)
                 )
                (ViewSpec
                   name: 'MarginBox'
                   visibilityChannel: supportsMarginSetting
                   component:
                  (SpecCollection
                     collection: (
                      (DividerSpec
                         name: 'Separator5'
                         layout: (LayoutFrame 0 0 0 0 0 1 3 0)
                       )
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel2'
                         layout: (LayoutFrame 0 0.0 9 0.0 0 1.0 -16 1.0)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'Box1'
                               component:
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Top Margin:'
                                     name: 'TopMarginLabel'
                                     layout: (LayoutFrame 0 0 0 0 181 0 30 0)
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'TopMarginEntryField'
                                     layout: (LayoutFrame 183 0 0 0 283 0 30 0)
                                     enableChannel: enableMargins
                                     model: topMargin
                                     type: numberOrNil
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                   )
                                  (PopUpListSpec
                                     label: 'PopUp List'
                                     name: 'PopUpList2'
                                     layout: (LayoutFrame -155 1 0 0 -5 1 30 0)
                                     translateLabel: true
                                     tabable: true
                                     model: selectedUnit
                                     menu: unitList
                                     useIndex: true
                                   )
                                  )

                               )
                               extent: (Point 601 32)
                             )
                            (ViewSpec
                               name: 'Box2'
                               component:
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Left Margin:'
                                     name: 'LeftMarginLabel'
                                     layout: (LayoutFrame 0 0 0 0 181 0 30 0)
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'LeftMarginEntryField'
                                     layout: (LayoutFrame 183 0 0 0 283 0 30 0)
                                     enableChannel: enableMargins
                                     model: leftMargin
                                     type: numberOrNil
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                   )
                                  )

                               )
                               extent: (Point 601 32)
                             )
                            (ViewSpec
                               name: 'Box3'
                               component:
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Right Margin:'
                                     name: 'RightMarginLabel'
                                     layout: (LayoutFrame 0 0 0 0 181 0 30 0)
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'RightMarginEntryField'
                                     layout: (LayoutFrame 183 0 0 0 283 0 30 0)
                                     enableChannel: enableMargins
                                     model: rightMargin
                                     type: numberOrNil
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                   )
                                  )

                               )
                               extent: (Point 601 32)
                             )
                            (ViewSpec
                               name: 'Box4'
                               component:
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Bottom Margin:'
                                     name: 'BottomMarginLabel'
                                     layout: (LayoutFrame 0 0 0 0 181 0 30 0)
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'BottomMarginEntryField'
                                     layout: (LayoutFrame 183 0 0 0 283 0 30 0)
                                     enableChannel: enableMargins
                                     model: bottomMargin
                                     type: numberOrNil
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                   )
                                  )

                               )
                               extent: (Point 601 32)
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 601 164)
                 )
                (ViewSpec
                   name: 'ColorBox'
                   visibilityChannel: supportsColorSetting
                   component:
                  (SpecCollection
                     collection: (
                      (DividerSpec
                         name: 'Separator6'
                         layout: (LayoutFrame 0 0 0 0 0 1 3 0)
                       )
                      (CheckBoxSpec
                         label: 'Color Printer'
                         name: 'ColorPrinterCheckBox'
                         layout: (LayoutFrame 183 0 4 0 782 0 34 0)
                         enableChannel: enableColorBox
                         model: supportsColor
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 601 34)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::PrinterSettingsAppl methodsFor:'actions'!

basicReadSettings
    Printer notNil ifTrue:[
        self
            readAspects:
                #(
                    topMargin
                    bottomMargin
                    leftMargin
                    rightMargin
                    landscape
                    printCommand
                    printFilename
                    supportsColor
                )
            from:Printer.
    ].

    self printerTypeSelection value:(self possiblePrinters identityIndexOf:Printer ifAbsent:1).
    self pageFormatList notEmpty ifTrue:[ self pageFormat value:Printer pageFormat ].
    self printerTypeSelectionOrUnitListChanged.

    "Modified: / 07-08-2006 / 15:22:27 / fm"
!

basicSaveSettings

    Printer := self possiblePrinters at:(self printerTypeSelection value).

    Printer printCommand:self printCommand value.
    Printer printFilename:(printFilename value isEmptyOrNil ifTrue:[nil] ifFalse:[printFilename value]).

    Printer supportsPageSizes ifTrue:[
        Printer pageFormat:(self pageFormat value).
        Printer landscape:(self landscape value).
    ].
    Printer supportsMargins ifTrue:[
        | unit |
        self selectedUnit value == 2 ifTrue:[
            unit := #mm
        ] ifFalse:[
            unit := #inch
        ].
        Printer topMargin:(UnitConverter convert:(self topMargin value) from:unit to:#inch).
        Printer leftMargin:(UnitConverter convert:(self leftMargin value) from:unit to:#inch).
        Printer rightMargin:(UnitConverter convert:(self rightMargin value) from:unit to:#inch).
        Printer bottomMargin:(UnitConverter convert:(self bottomMargin value) from:unit to:#inch).
    ].
    Printer supportsPostscript ifTrue:[
        Printer supportsColor:self supportsColor value.
    ].
! !

!AbstractSettingsApplication::PrinterSettingsAppl methodsFor:'aspects'!

bottomMargin

    bottomMargin isNil ifTrue:[
        bottomMargin := Printer bottomMargin asValue.
        bottomMargin onChangeSend:#updateModifiedChannel to:self
    ].
    ^ bottomMargin.
!

enableColorBox

    enableColorBox isNil ifTrue:[
        enableColorBox := true asValue.
    ].
    ^ enableColorBox.
!

enableFormat

    enableFormat isNil ifTrue:[
        enableFormat := true asValue.
    ].
    ^ enableFormat.
!

enableMargins

    enableMargins isNil ifTrue:[
        enableMargins := true asValue.
    ].
    ^ enableMargins.
!

enablelandscape

    enablelandscape isNil ifTrue:[
        enablelandscape := true asValue.
    ].
    ^ enablelandscape.
!

landscape

    landscape isNil ifTrue:[
        landscape := (Printer isNil ifTrue:[ false ] ifFalse:[ Printer landscape])  asValue.
        landscape onChangeSend:#updateModifiedChannel to:self
    ].
    ^ landscape.

    "Modified: / 07-08-2006 / 15:22:44 / fm"
!

leftMargin

    leftMargin isNil ifTrue:[
        leftMargin := Printer leftMargin asValue.
        leftMargin onChangeSend:#updateModifiedChannel to:self
    ].
    ^ leftMargin.
!

pageFormat

    pageFormat isNil ifTrue:[
        self pageFormatList notEmpty ifTrue:[
            | index |
            (index := self pageFormatList indexOf:#a4) ~~ 0 ifTrue:[
                pageFormat := index asValue.
            ] ifFalse:[
                pageFormat := 1 asValue.
            ]
        ].
        pageFormat onChangeSend:#updateModifiedChannel to:self
    ].
    ^ pageFormat.
!

pageFormatList

    pageFormatList isNil ifTrue:[
        pageFormatList := (Printer isNil ifTrue:[ #() ] ifFalse: [Printer defaultPageFormats]) asList.
    ].
    ^ pageFormatList.

    "Modified: / 07-08-2006 / 15:23:19 / fm"
!

printCommand

    printCommand isNil ifTrue:[
        printCommand := Printer printCommand asValue.
        printCommand onChangeSend:#updateModifiedChannel to:self
    ].
    ^ printCommand.
!

printCommandEnabled
    ^ BlockValue
        with:[:m | m isEmptyOrNil]
        argument:(self printFilename).

    "Modified: / 08-03-2007 / 23:02:40 / cg"
!

printCommandList

    printCommandList isNil ifTrue:[
        printCommandList := self commandList asList.
    ].
    ^ printCommandList.
!

printFilename
    printFilename isNil ifTrue:[
        printFilename := (Printer isNil ifTrue:[''] ifFalse:[Printer printFilename ? '']) asValue.
        printFilename onChangeSend:#updateModifiedChannel to:self
    ].
    ^ printFilename.

    "Modified: / 07-08-2006 / 15:24:45 / fm"
!

printerIsDrivenByCommand
    printerIsDrivenByCommand isNil ifTrue:[
        printerIsDrivenByCommand := BlockValue
            with:[:m |
                |printer|

                printer := self possiblePrinters at:m value ifAbsent:nil.
                printer notNil ifTrue:[
                    printer isDrivenByCommand
                ] ifFalse:[
                    self breakPoint:#expecco.
                    false
                ]
            ]
            argument:self printerTypeSelection.
    ].
    ^ printerIsDrivenByCommand.

    "Created: / 10-10-2006 / 18:22:32 / cg"
    "Modified: / 08-03-2007 / 23:02:44 / cg"
!

printerSupportsPrintingToFile
    printerSupportsPrintingToFile isNil ifTrue:[
        printerSupportsPrintingToFile := BlockValue
                                        with:[:m | (self possiblePrinters at:m) supportsPrintingToFile ]
                                        argument:self printerTypeSelection.
    ].
    ^ printerSupportsPrintingToFile.

    "Created: / 10-10-2006 / 18:27:44 / cg"
    "Modified: / 08-03-2007 / 23:02:47 / cg"
!

printerType
    printerType isNil ifTrue:[
        printerType := (self possiblePrinters collect:[:cls | cls printerTypeName]) asList.
        printerType onChangeSend:#updateModifiedChannel to:self
    ].
    ^ printerType.

    "Modified: / 10-10-2006 / 18:09:43 / cg"
!

printerTypeSelection
    |printerIndex|

    printerTypeSelection isNil ifTrue:[
        printerIndex := self possiblePrinters identityIndexOf:Printer.
        printerIndex == 0 ifTrue:[
           self possiblePrinters isEmptyOrNil ifTrue:[self error:'no printer'].
           printerIndex := 1.
        ].
        printerTypeSelection := printerIndex asValue.

        printerTypeSelection addDependent:self.
        printerTypeSelection changed.
        printerTypeSelection onChangeSend:#updateModifiedChannel to:self
    ].
    ^ printerTypeSelection.

    "Modified: / 10-10-2006 / 18:22:58 / cg"
!

rightMargin

    rightMargin isNil ifTrue:[
        rightMargin := Printer rightMargin asValue.
        rightMargin onChangeSend:#updateModifiedChannel to:self
    ].
    ^ rightMargin.
!

selectedUnit

    selectedUnit isNil ifTrue:[
        selectedUnit := 1 asValue.
        selectedUnit addDependent:self.
        selectedUnit changed.
        selectedUnit onChangeSend:#updateModifiedChannel to:self
    ].
    ^ selectedUnit.
!

supportsColor

    supportsColor isNil ifTrue:[
        supportsColor := (Printer notNil and:[Printer supportsColor]) asValue.
        supportsColor onChangeSend:#updateModifiedChannel to:self
    ].
    ^ supportsColor.

    "Modified: / 07-08-2006 / 15:24:22 / fm"
!

supportsColorSetting
    supportsColorSetting isNil ifTrue:[
        supportsColorSetting := BlockValue
                                        with:[:m | (self possiblePrinters at:m) supportsColor ]
                                        argument:self printerTypeSelection.
    ].
    ^ supportsColorSetting.

    "Created: / 10-10-2006 / 18:35:47 / cg"
    "Modified: / 08-03-2007 / 23:02:50 / cg"
!

supportsMarginSetting
    supportsMarginSetting isNil ifTrue:[
        supportsMarginSetting := BlockValue
                                        with:[:m | (self possiblePrinters at:m) supportsMargins ]
                                        argument:self printerTypeSelection.
    ].
    ^ supportsMarginSetting.

    "Created: / 10-10-2006 / 18:35:33 / cg"
    "Modified: / 08-03-2007 / 23:02:54 / cg"
!

supportsPageFormatSetting
    supportsPageFormatSetting isNil ifTrue:[
        supportsPageFormatSetting := BlockValue
                                        with:[:m | (self possiblePrinters at:m) supportsPageSizes ]
                                        argument:self printerTypeSelection.
    ].
    ^ supportsPageFormatSetting.

    "Created: / 10-10-2006 / 18:36:33 / cg"
    "Modified: / 08-03-2007 / 23:02:56 / cg"
!

topMargin

    topMargin isNil ifTrue:[
        topMargin := (Printer isNil ifTrue:[ 0 ] ifFalse:[ Printer topMargin ]) asValue.
        topMargin onChangeSend:#updateModifiedChannel to:self
    ].
    ^ topMargin.

    "Modified: / 07-08-2006 / 15:21:50 / fm"
!

unitList

    unitList isNil ifTrue:[
        unitList := #('inch' 'mm') asList.
    ].
    ^ unitList.
! !

!AbstractSettingsApplication::PrinterSettingsAppl methodsFor:'change & update'!

printerTypeSelectionChanged
    | p hasPageSize hasMargins|

    self printerType selectionIndex ~~ 0 ifTrue:[
        p := self possiblePrinters at:(self printerType selectionIndex).
        hasPageSize := p supportsPageSizes.
        hasMargins := p supportsMargins.
    ] ifFalse:[
        hasPageSize := false.
        hasMargins := false.
    ].
!

printerTypeSelectionOrUnitListChanged
    | p hasPageSize hasMargins unit printerSupportsPostscript|

    self printerTypeSelection value ~~ 0 ifTrue:[
        p := self possiblePrinters at:(self printerTypeSelection value).
        hasPageSize := p supportsPageSizes.
        hasMargins := p supportsMargins.
    ] ifFalse:[
        hasPageSize := false.
        hasMargins := false.
    ].
    self enablelandscape value:hasPageSize.
    self enableFormat value:hasPageSize.
    hasPageSize ifTrue:[
        self pageFormat value:(p pageFormat).
        self landscape value:(p landscape).
    ] ifFalse:[
       self landscape value:false.
    ].
    hasMargins ifTrue:[
       self selectedUnit value == 2 ifTrue:[
           unit := #mm
       ] ifFalse:[
           unit := #inch
       ].

       self topMargin value:(UnitConverter convert:p topMargin from:#inch to:unit).
       self leftMargin value:(UnitConverter convert:p leftMargin from:#inch to:unit).
       self rightMargin value:(UnitConverter convert:p rightMargin from:#inch to:unit).
       self bottomMargin value:(UnitConverter convert:p bottomMargin from:#inch to:unit).

    ] ifFalse:[
    ].
    self enableMargins value:hasMargins.

    p notNil ifTrue:[
        | newCommandList |
        newCommandList := p defaultCommands.
        newCommandList notNil ifTrue:[
            self printCommandList
                contents:(newCommandList asList);
                changed.
        ].
        self printCommand value:(p printCommand).
        self printFilename value:(p printFilename ? '').
    ].
    printerSupportsPostscript := p notNil and:[p supportsPostscript].
    self enableColorBox value:printerSupportsPostscript.
    printerSupportsPostscript ifFalse:[
        self supportsColor value:false
    ] ifTrue:[
        self supportsColor value:(Printer supportsColor).
    ]

    "Modified: / 07-08-2006 / 15:24:06 / fm"
!

unitListChanged
!

update:something with:aParameter from:changedObject
    (changedObject == self selectedUnit or:[changedObject == self printerTypeSelection]) ifTrue:[
        self printerTypeSelectionOrUnitListChanged.
        ^ self.
    ].

    super update:something with:aParameter from:changedObject
! !

!AbstractSettingsApplication::PrinterSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/printerSettings.html'
! !

!AbstractSettingsApplication::PrinterSettingsAppl methodsFor:'queries'!

commandList
    commandList isNil ifTrue:[
        commandList := resources string:'PRINT_COMMANDS' default:nil.
        commandList isNil ifTrue:[
            commandList := PrinterStream defaultCommands.
            commandList isNil ifTrue:[
                commandList := #('lpr' 'lp').
            ].
            (commandList includes:self printCommand value) ifFalse:[
                commandList := commandList copyWith:self printCommand value.
            ].
        ].
    ].
    ^ commandList
!

hasUnsavedChanges
    | printer unit|

    Printer isNil ifTrue:[^ false].

    self selectedUnit value == 2 ifTrue:[
        unit := #mm
    ] ifFalse:[
        unit := #inch
    ].
    printer := self possiblePrinters at:(self printerTypeSelection value).

    printer ~= Printer ifTrue:[^ true].

    Printer printCommand ~= self printCommand value ifTrue:[^ true].
    (Printer printFilename ? '') ~= (self printFilename value ? '') ifTrue:[^ true].

    Printer supportsPageSizes ifTrue:[
        Printer pageFormat ~= self pageFormat value ifTrue:[^ true].
        Printer landscape ~= (self landscape value) ifTrue:[^ true].
    ].
    Printer supportsMargins ifTrue:[
        Printer topMargin ~= ((UnitConverter convert:(self topMargin value asFloat) from:unit to:#inch) asFloat) ifTrue:[^ true].
        Printer leftMargin ~= ((UnitConverter convert:(self leftMargin value asFloat) from:unit to:#inch) asFloat) ifTrue:[^ true].
        Printer rightMargin ~= ((UnitConverter convert:(self rightMargin value asFloat) from:unit to:#inch) asFloat) ifTrue:[^ true].
        Printer bottomMargin ~= ((UnitConverter convert:(self bottomMargin value asFloat) from:unit to:#inch) asFloat) ifTrue:[^ true].
    ].
    Printer supportsPostscript ifTrue:[
        Printer supportsColor ~= self supportsColor value ifTrue:[^ true].
    ].
    ^ false

    "Modified: / 07-08-2006 / 15:25:47 / fm"
!

possiblePrinters
    possiblePrinters isNil ifTrue:[
        possiblePrinters := PrinterStream withAllSubclasses asArray.
    ].
    ^ possiblePrinters
! !

!AbstractSettingsApplication::ProcessorSchedulerSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ProcessorSchedulerSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#dynamicPriorities
'If checked, the scheduler uses an adaptive dynamic priority scheme, where low priority background processes are guaranteed to make progress,\even if higher priority processes are constantly executing.\The algorithm is similar to the UNIX scheduler''s, where the dynamic priority of a long waiting process is increased slowly,\until it gets a chance to run. This is very useful for background tasks, such as print jobs'

#preemptiveScheduling
'If checked, processes are preempted (suspended) in regular short intervals, if another process with the same priority is ready to run.\Thus the processor is timeslicing among processes.\If off, processes use the CPU until they go into a wait or explicitly yield the CPU to another process.\\Non-preemptive is the default in most other Smalltalk implementations,\as it allows for sloppy coding of all accesses to global shared state (such as the dependency collections or the Transcript window).\However, it results in a very bad user experience, as long running actions will freeze the UI.\\Therefore, preemptive scheduling is the default in ST/X'

)
! !

!AbstractSettingsApplication::ProcessorSchedulerSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::ProcessorSchedulerSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@ADQ@@@@@@@@@@DQBL2QD@@@@@@@DH"D3D"I@@@@@@DHQDSLQDRP@@@@DHQDQDQDQD$@@@DHQDQDQDQDQI@@@P!!DQDQDQDQD$@@AB
DQDQDQLQDRP@ABDQDQDQLQDQD$@DHQDQDSLQDQDRP@P!!DQDQL1DQDQI@ABDQDQDQLQDQD$@@P!!DQDQDSDQD$@@ABDQDQDQD1DRP@@DHQDQDQDQLQI@@@ABDQ
DQDQDQI@@@@@P!!DQDQDQI@@@@@@DH"DQD"I@@@@@@@ADP"H$Q@@@@@@@@@@DQD@@@@@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 255 255 255 128 128 128 0 128 128 192 192 192]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@@G @@?<@A?>@C??@G?? O??0O??0O??0_??8_??8_??8_??8O??0O??0O??0G?? C??@A?>@@?<@@G @@@@@'); yourself); yourself]
! !

!AbstractSettingsApplication::ProcessorSchedulerSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ProcessorSchedulerSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::ProcessorSchedulerSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::ProcessorSchedulerSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Processor and Scheduler Settings'
         name: 'Processor and Scheduler Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 600 320)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: topSpace
             horizontalSpace: 3
             verticalSpace: 5
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Preemptive Scheduling'
                   name: 'CheckBox11'
                   activeHelpKey: preemptiveScheduling
                   model: preemptive
                   translateLabel: true
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'Box2'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Dynamic Priorities'
                         name: 'CheckBox12'
                         layout: (LayoutFrame 30 0.0 0 0 0 1.0 30 0)
                         activeHelpKey: dynamicPriorities
                         enableChannel: preemptive
                         model: dynamicPrios
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::ProcessorSchedulerSettingsAppl methodsFor:'actions'!

basicReadSettings
    self preemptive value:Processor isTimeSlicing.
    self dynamicPrios value:Processor supportDynamicPriorities.
!

basicSaveSettings

    Processor isTimeSlicing ~~ self preemptive value ifTrue:[
        self preemptive value ifTrue:[
            Processor startTimeSlicing
        ] ifFalse:[
            Processor stopTimeSlicing
        ]
    ].
    Processor supportDynamicPriorities ~~ self dynamicPrios value ifTrue:[
        Processor supportDynamicPriorities:self dynamicPrios value
    ].
! !

!AbstractSettingsApplication::ProcessorSchedulerSettingsAppl methodsFor:'aspects'!

dynamicPrios
    dynamicPrios isNil ifTrue:[
        dynamicPrios := true asValue.
        dynamicPrios onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ dynamicPrios.
!

preemptive
    preemptive isNil ifTrue:[
        preemptive := true asValue.
        preemptive onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ preemptive.
! !

!AbstractSettingsApplication::ProcessorSchedulerSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/miscSettings.html'
! !

!AbstractSettingsApplication::ProcessorSchedulerSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self preemptive value ~= Processor isTimeSlicing ifTrue:[^ true].
    self dynamicPrios value ~= Processor supportDynamicPriorities ifTrue:[^ true].
    ^ false
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#rdoitDisabled
'RDoit setup disabled, because the "stx:goodies/rdoit" package is not loaded.\To load, open the package load dialog via the Launcher''s "File"-"Load Package" menu item.\\Press the ''Help'' button for a description of what this does'

#rdoitSettings
'RDoit setup. Press the ''Help'' button for a description of what this does'

#scriptingDisabled
'Scripting service setup disabled, because the "stx:goodies/simpleServices" package is not loaded.\To load, open the package load dialog via the Launcher''s "File"-"Load Package" menu item.\\Press the ''Help'' button for a description of what this does'

#scriptingSettings
'Scripting service setup. Press the ''Help'' button for a description of what this does'
)
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::RDoItServerSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&Y&Y&Y&Y&Y3@@@BY&Y&Y&Y&Y''L@@@I$[]7_]7]6,1P@@&QL3L>:1GZ3E@@BY83L3L>D]+LT@@I
''#L3L38Q6,1P@@&[L3L8 @]7''E@@BYE3NH (@@_LT@@I$WNBBDAH L1P@@&Q]8P$IB"@3E@@BY4W $ B$@CLT@@L3L $!!H@$"@1P@@3L2DJB DJHCE@@@@UV
!!B D @A%T@@@@@BBP$IH @@@@@@@@HPHHB"@@@@@@@@@@@!!H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b')
            colorMapFromArray:#[0 0 0 64 80 96 240 240 0 80 112 112 240 240 240 64 64 64 48 64 80 64 96 96 128 128 0 128 128 128 48 80 80 80 96 96 112 112 112 64 80 80 80 96 112]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@G??0G??0G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8A??8@O?@@O?@@G>@@A0@@@@@'); yourself); yourself]
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::RDoItServerSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::RDoItServerSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::RDoItServerSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'RDoIt Server Settings'
         name: 'RDoIt Server Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 601 535)
       )
       component:
      (SpecCollection
         collection: (
          (FramedBoxSpec
             label: 'RDoIt'
             name: 'RDoItFramedBox'
             layout: (LayoutFrame 0 0 0 0 0 1 232 0)
             activeHelpKey: rdoitSettings
             labelPosition: topLeft
             translateLabel: true
             component:
            (SpecCollection
               collection: (
                (VerticalPanelViewSpec
                   name: 'VerticalPanel2'
                   layout: (LayoutFrame 0 0.0 5 0.0 0 1.0 0 1.0)
                   horizontalLayout: fit
                   verticalLayout: top
                   horizontalSpace: 0
                   verticalSpace: 0
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box1'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Remote doits enabled'
                               name: 'CheckBox1'
                               layout: (LayoutFrame 0 0 0 0 -5 1 22 0)
                               enableChannel: hasRDoitServerClass
                               model: rDoitsEnabled
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 25)
                       )
                      (ViewSpec
                         name: 'Box2'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Port/Path:'
                               name: 'Label2'
                               layout: (LayoutFrame 0 0 0 0 150 0 22 0)
                               translateLabel: true
                               adjust: right
                               enableDisableColorChannel: rDoitsEnabled
                             )
                            (InputFieldSpec
                               name: 'EntryField1'
                               layout: (LayoutFrame 150 0 0 0 -5 1 22 0)
                               enableChannel: rDoitsEnabled
                               model: rDoitServerPortOrPath
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: true
                             )
                            (LabelSpec
                               label: 'Port# for Tcp Socket; Path for Unix Domain Socket (Unix only).'
                               name: 'Label3'
                               layout: (LayoutFrame 150 0 28 0 596 0 50 0)
                               translateLabel: true
                               adjust: left
                               enableDisableColorChannel: rDoitsEnabled
                             )
                            )

                         )
                         extent: (Point 567 60)
                       )
                      (ViewSpec
                         name: 'Box13'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Local Connections Only'
                               name: 'CheckBox10'
                               layout: (LayoutFrame 150 0 0 0 -5 1 22 0)
                               enableChannel: rDoitsEnabled
                               model: rDoitEnabledOnlyViaLocalConnection
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 25)
                       )
                      (ViewSpec
                         name: 'Box3'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Log errors'
                               name: 'CheckBox2'
                               layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                               enableChannel: rDoitsEnabled
                               model: rDoitErrorLogging
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 25)
                       )
                      (ViewSpec
                         name: 'Box4'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Log requests'
                               name: 'CheckBox3'
                               layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                               enableChannel: rDoitsEnabled
                               model: rDoitLogging
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 24)
                       )
                      (ViewSpec
                         name: 'Box5'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Debug errors'
                               name: 'CheckBox4'
                               layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                               enableChannel: rDoitsEnabled
                               model: rDoitErrorDebugging
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 23)
                       )
                      )

                   )
                 )
                )

             )
           )
          (FramedBoxSpec
             label: 'JavaScript/Smalltalk-Scripting via Telnet'
             name: 'ScriptingFramedBox'
             layout: (LayoutFrame 0 0 224 0 0 1 460 0)
             activeHelpKey: scriptingSettings
             labelPosition: topLeft
             translateLabel: true
             component:
            (SpecCollection
               collection: (
                (VerticalPanelViewSpec
                   name: 'VerticalPanel3'
                   layout: (LayoutFrame 0 0.0 5 0.0 0 1.0 0 1.0)
                   horizontalLayout: fit
                   verticalLayout: top
                   horizontalSpace: 0
                   verticalSpace: 0
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box6'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Telnet Scripting enabled'
                               name: 'CheckBox5'
                               layout: (LayoutFrame 0 0 0 0 -5 1 22 0)
                               enableChannel: hasScriptingServerClass
                               model: scriptingEnabled
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 25)
                       )
                      (ViewSpec
                         name: 'Box12'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Port:'
                               name: 'Label4'
                               layout: (LayoutFrame 0 0 0 0 150 0 22 0)
                               translateLabel: true
                               adjust: right
                               enableDisableColorChannel: scriptingEnabled
                             )
                            (InputFieldSpec
                               name: 'EntryField2'
                               layout: (LayoutFrame 150 0 0 0 -5 1 22 0)
                               enableChannel: rDoitsEnabled
                               model: scriptingServerPortOrPath
                               isReadOnly: true
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: true
                             )
                            (LabelSpec
                               label: 'Port# for Tcp Socket; Path for Unix Domain Socket (Unix only).'
                               name: 'Label5'
                               layout: (LayoutFrame 150 0 28 0 596 0 50 0)
                               initiallyInvisible: true
                               translateLabel: true
                               adjust: left
                             )
                            )

                         )
                         extent: (Point 567 60)
                       )
                      (ViewSpec
                         name: 'Box11'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Local Connections Only'
                               name: 'CheckBox9'
                               layout: (LayoutFrame 150 0 0 0 -5 1 22 0)
                               enableChannel: scriptingEnabled
                               model: scriptingEnabledOnlyViaLocalConnection
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 25)
                       )
                      (ViewSpec
                         name: 'Box8'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Log errors'
                               name: 'CheckBox6'
                               layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                               enableChannel: scriptingEnabled
                               model: scriptingErrorLogging
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 25)
                       )
                      (ViewSpec
                         name: 'Box9'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Log requests'
                               name: 'CheckBox7'
                               layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                               enableChannel: scriptingEnabled
                               model: scriptingLogging
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 24)
                       )
                      (ViewSpec
                         name: 'Box10'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Debug errors'
                               name: 'CheckBox8'
                               layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                               enableChannel: scriptingEnabled
                               model: scriptingErrorDebugging
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 567 23)
                       )
                      )

                   )
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl methodsFor:'actions'!

basicReadSettings
    |rDoitsEnabled rDoitLogging rDoitErrorLogging rDoitErrorDebugging rDoitServerPortOrPath
     rDoitEnabledOnlyViaLocalConnection
     scriptingEnabled scriptingEnabledOnlyViaLocalConnection scriptingLogging
     scriptingErrorLogging scriptingErrorDebugging|

    rDoitsEnabled := false.
    rDoitLogging := false.
    rDoitErrorLogging := false.
    rDoitErrorDebugging := false.
    rDoitServerPortOrPath := ''.
    rDoitEnabledOnlyViaLocalConnection := true.

    scriptingEnabled := false.
    scriptingEnabledOnlyViaLocalConnection := true.

    (self hasRDoitServer and:[RDoItServer isLoaded]) ifTrue:[
        rDoitsEnabled := RDoItServer serverRunning.
        rDoitEnabledOnlyViaLocalConnection := RDoItServer localConnectionsOnly.
        rDoitLogging := RDoItServer isLogging.
        rDoitErrorLogging := RDoItServer isErrorLogging.
        rDoitErrorDebugging := RDoItServer isErrorCatching not.
        rDoitServerPortOrPath := RDoItServer defaultPortNumberOrPath asString.
    ].

    (STXScriptingServer notNil
    and:[ STXScriptingServer isLoaded ]) ifTrue:[
        scriptingEnabled := STXScriptingServer serverRunning.
        scriptingEnabledOnlyViaLocalConnection := STXScriptingServer localConnectionsOnly.
        scriptingLogging := STXScriptingServer isLogging.
        scriptingErrorLogging := STXScriptingServer isErrorLogging.
        scriptingErrorDebugging := STXScriptingServer isErrorDebugging.
    ].

    self rDoitsEnabled value:rDoitsEnabled.
    self rDoitLogging value:rDoitLogging.
    self rDoitErrorLogging value:rDoitErrorLogging.
    self rDoitErrorDebugging value:rDoitErrorDebugging.
    self rDoitServerPortOrPath value:rDoitServerPortOrPath.

    self scriptingEnabled value:scriptingEnabled.
    self scriptingEnabledOnlyViaLocalConnection value:scriptingEnabledOnlyViaLocalConnection.
    self scriptingLogging value:scriptingLogging.
    self scriptingErrorLogging value:scriptingErrorLogging.
    self scriptingErrorDebugging value:scriptingErrorDebugging.

    "Modified: / 20-05-2010 / 14:49:50 / cg"
!

basicSaveSettings
    |shouldRun portOrPath|

    portOrPath := self getPortNumberOrPath.

    self hasRDoitServerClass ifTrue:[
        RDoItServer defaultPortNumberOrPath:portOrPath.
        RDoItServer logging:self rDoitLogging value.
        RDoItServer errorLogging:self rDoitErrorLogging value.
        RDoItServer errorCatching:(self rDoitErrorDebugging value not).
        RDoItServer localConnectionsOnly:(self rDoitEnabledOnlyViaLocalConnection value).
        shouldRun := self rDoitsEnabled value.
        shouldRun ~~ RDoItServer serverRunning ifTrue:[
            shouldRun ifFalse:[
                RDoItServer stop
            ] ifTrue:[
                RDoItServer start.
                "/ must wait a bit; give it a chance to
                "/ really start (before checking)
                Delay waitForSeconds:1.
                RDoItServer serverRunning ifFalse:[
                    self warn:'RDoit startup failed (see stderr).'
                ]
            ]
        ].
    ].

    self hasScriptingServerClass ifTrue:[
        STXScriptingServer logging:self scriptingLogging value.
        STXScriptingServer errorLogging:self scriptingErrorLogging value.
        STXScriptingServer errorDebugging:(self scriptingErrorDebugging value).
        STXScriptingServer localConnectionsOnly:(self scriptingEnabledOnlyViaLocalConnection value).
        shouldRun := self scriptingEnabled value.
        shouldRun ~~ STXScriptingServer serverRunning ifTrue:[
            shouldRun ifFalse:[
                STXScriptingServer stop
            ] ifTrue:[
                STXScriptingServer start.
                "/ must wait a bit; give it a chance to
                "/ really start (before checking)
                Delay waitForSeconds:1.
                STXScriptingServer serverRunning ifFalse:[
                    self warn:'STXScripting startup failed (see stderr).'
                ]
            ]
        ].
    ].

    "Modified: / 20-05-2010 / 14:50:44 / cg"
!

getPortNumberOrPath
    |portOrPath nrOrNil|

    portOrPath := self rDoitServerPortOrPath value.
    portOrPath isNumber ifFalse:[
        "a numeric string means it is a TCP port number"
        nrOrNil := Integer readFrom:portOrPath onError:nil.
        nrOrNil notNil ifTrue:[
            portOrPath := nrOrNil.
        ]
    ].
    ^ portOrPath
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl methodsFor:'aspects'!

rDoitEnabledOnlyViaLocalConnection
    rDoitEnabledOnlyViaLocalConnection isNil ifTrue:[
        rDoitEnabledOnlyViaLocalConnection := true asValue.
        rDoitEnabledOnlyViaLocalConnection onChangeSend:#updateModifiedChannel to:self
    ].
    ^ rDoitEnabledOnlyViaLocalConnection.

    "Created: / 20-05-2010 / 12:15:12 / cg"
!

rDoitErrorDebugging
    rDoitErrorDebugging isNil ifTrue:[
        rDoitErrorDebugging := true asValue.
        rDoitErrorDebugging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ rDoitErrorDebugging.
!

rDoitErrorLogging
    rDoitErrorLogging isNil ifTrue:[
        rDoitErrorLogging := true asValue.
        rDoitErrorLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ rDoitErrorLogging.
!

rDoitLogging
    rDoitLogging isNil ifTrue:[
        rDoitLogging := true asValue.
        rDoitLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ rDoitLogging.
!

rDoitOnlyViaLocalConnection
    rDoitOnlyViaLocalConnection isNil ifTrue:[
        rDoitOnlyViaLocalConnection := true asValue.
        rDoitOnlyViaLocalConnection onChangeSend:#updateModifiedChannel to:self
    ].
    ^ rDoitOnlyViaLocalConnection.

    "Created: / 20-05-2010 / 12:14:50 / cg"
!

rDoitServerPortOrPath
    rDoitServerPortOrPath isNil ifTrue:[
        rDoitServerPortOrPath := nil asValue.
        rDoitServerPortOrPath onChangeSend:#updateModifiedChannel to:self
    ].
    ^ rDoitServerPortOrPath.
!

rDoitsEnabled
    rDoitsEnabled isNil ifTrue:[
        rDoitsEnabled := true asValue.
        rDoitsEnabled onChangeSend:#rDoitsEnabledChanged to:self
    ].
    ^ rDoitsEnabled.
!

scriptingEnabled
    scriptingEnabled isNil ifTrue:[
        scriptingEnabled := false asValue.
        scriptingEnabled onChangeSend:#updateModifiedChannel to:self
    ].
    ^ scriptingEnabled.
!

scriptingEnabledOnlyViaLocalConnection
    scriptingEnabledOnlyViaLocalConnection isNil ifTrue:[
        scriptingEnabledOnlyViaLocalConnection := true asValue.
        scriptingEnabledOnlyViaLocalConnection onChangeSend:#updateModifiedChannel to:self
    ].
    ^ scriptingEnabledOnlyViaLocalConnection.
!

scriptingErrorDebugging
    scriptingErrorDebugging isNil ifTrue:[
        scriptingErrorDebugging := true asValue.
        scriptingErrorDebugging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ scriptingErrorDebugging.
!

scriptingErrorLogging
    scriptingErrorLogging isNil ifTrue:[
        scriptingErrorLogging := true asValue.
        scriptingErrorLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ scriptingErrorLogging.
!

scriptingLogging
    scriptingLogging isNil ifTrue:[
        scriptingLogging := true asValue.
        scriptingLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ scriptingLogging.
!

scriptingServerPortOrPath
    <resource: #uiAspect>

    scriptingServerPortOrPath isNil ifTrue:[
        STXScriptingServer notNil ifTrue:[
            scriptingServerPortOrPath := STXScriptingServer defaultPortNumber asValue.
        ].
    ].
    ^ scriptingServerPortOrPath.
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl methodsFor:'change & update'!

rDoitsEnabledChanged
    self updateModifiedChannel.
    self rDoitsEnabled value ifTrue:[
        RDoItServer autoload.
        rDoitServerPortOrPath value isEmptyOrNil ifTrue:[
            rDoitServerPortOrPath value:(RDoItServer defaultPortNumberOrPath asString)
        ]
    ]
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl methodsFor:'help'!

flyByHelpTextForKey:aKey
    |usedKey|

    usedKey := aKey.
    usedKey == #rdoitSettings ifTrue:[
        self hasRDoitServerClass ifFalse:[
            usedKey := #rdoitDisabled
        ].
    ].
    usedKey == #scriptingSettings ifTrue:[
        self hasScriptingServerClass ifFalse:[
            usedKey := #scriptingDisabled
        ].
    ].
    ^ super flyByHelpTextForKey:usedKey.
!

helpFilename
    ^ 'Launcher/communicationsSettings.html'
! !

!AbstractSettingsApplication::RDoItServerSettingsAppl methodsFor:'queries'!

hasRDoitServer
    ^ RDoItServer notNil and:[RDoItServer isLoaded]
!

hasRDoitServerClass
    ^ RDoItServer notNil
!

hasScriptingServer
    ^ STXScriptingServer notNil and:[STXScriptingServer isLoaded]
!

hasScriptingServerClass
    ^ STXScriptingServer notNil
!

hasUnsavedChanges
    (self hasRDoitServer and:[RDoItServer isLoaded]) ifTrue:[
        self rDoitsEnabled value ~= RDoItServer serverRunning ifTrue:[^ true].
        RDoItServer serverRunning ifTrue:[
            self rDoitLogging value ~= RDoItServer isLogging ifTrue:[^ true].
            self rDoitErrorLogging value ~= RDoItServer isErrorLogging ifTrue:[^ true].
            self rDoitErrorDebugging value ~= RDoItServer isErrorCatching not ifTrue:[^ true].
            self getPortNumberOrPath ~= RDoItServer defaultPortNumberOrPath ifTrue:[^ true].
            self rDoitEnabledOnlyViaLocalConnection value ~= RDoItServer localConnectionsOnly ifTrue:[^ true].
        ]
    ].
    (self hasScriptingServer and:[STXScriptingServer isLoaded]) ifTrue:[
        self scriptingEnabled value ~= STXScriptingServer serverRunning ifTrue:[^ true].
        STXScriptingServer serverRunning ifTrue:[
            self scriptingLogging value ~= STXScriptingServer isLogging ifTrue:[^ true].
            self scriptingErrorLogging value ~= STXScriptingServer isErrorLogging ifTrue:[^ true].
            self scriptingErrorDebugging value ~= STXScriptingServer isErrorDebugging ifTrue:[^ true].
            self scriptingEnabledOnlyViaLocalConnection value ~= STXScriptingServer localConnectionsOnly ifTrue:[^ true].
        ]
    ].
    ^ false

    "Modified: / 20-05-2010 / 14:48:52 / cg"
! !

!AbstractSettingsApplication::SQLServerSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::MiscDisplaySettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#sqlServer
'The sql server is a pure Smalltalk application which implements the mySQL wire protocol,\and allows for a smalltalk application to simulate database tables.\One particular application presents classes and methods as tables.\\The SQL server is a non-free ST/X addon.'

)
! !

!AbstractSettingsApplication::SQLServerSettingsAppl class methodsFor:'image specs'!

dbIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self dbIcon1 inspect
     ImageEditor openOnClass:self andSelector:#dbIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'AbstractSettingsApplication::SQLServerSettingsAppl class dbIcon1'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
H"H"H @@@@@@@@@@@@@@@@@@@@@"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@"H"H"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH"@@@@@@@@@@@@J"(*J"(*@@@@
@@@@@BH"@@@@@@@@J"(*@@@@@@@@J"(*@@@@H"H"@@@@@B(*@@@@@@@@@@@@@@@@J"("H"H"@@@@J @@@@@@@@@@@@@@@@@@@@@*H"H"@BH@H"(*@@@@@@@@
@@@@@@@@J"("H"H"@BH(H" $J"(*J @@@@@*J"(*H"H"H"H"@BH(H" $ABTJIB(*J"("H"H"H"H"H"H"@BH(H" $ABT%IBP(JBH"H"H"H"H"H"H"@@@(J" $
A@PDIBP(JBH"H"H"H"H*H"H"@BH@H"(*IBP$IBP(JBH"H"H"J"("H"H"@BH(H" $J"(*J"P(JBH*J"(*H"H"H"H"@BH(H" $ABTJIB(*J"("H"H"H"H"H"H"
@BH(H" $ABT%IBP(JBH"H"H"H"H"H"H"@@@(J" $A@PDIBP(JBH"H"H"H"H*H"H"@@@@@B(*IBP$IBP(JBH"H"H"J"(@H"H"H"H"H"H"J"(*IBP(JBH"J"(*
H"H"H"H"H"H"H"H"@@@@J"(*J"(*@@@@@@@@@BH"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@BH"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@BH"H"H"H"H"@@@@@@@@
@@@@@@@@@@@@@BH"H"H"H"H"@@@@@@@@@@@@@@@@@@@@@BH"') ; colorMapFromArray:#[224 189 75 255 253 212 114 169 125 244 219 172 224 180 55 105 195 48 255 253 194 253 210 112 27 163 14 139 188 141 254 253 153 67 140 42 245 230 190 245 250 242 238 222 158 240 212 96 254 253 228 249 239 209 254 233 132 135 224 88 62 138 68 241 209 144 254 198 97 148 180 81 255 227 154 39 125 38 61 166 37 216 172 46 46 153 24 113 206 71 25 131 15 240 198 86 79 187 37 254 243 141 102 77 2 69 123 9 205 154 5 249 235 113 225 193 100 218 179 65 130 98 3 10 113 5 0 0 0]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@G8@@??@C??0G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8G??8C??0@??@@G8@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

dbIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self dbIcon2 inspect
     ImageEditor openOnClass:self andSelector:#dbIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Object class dbIcon2'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@!!!!"O_@T>@@@@@@@@@@@@@@@@@@@@@E8=X(!!#T!!0-X@D@@@@@@@@@@@@@@@@@NVTLL@.HK%MTZQEH@@@@@@@@@@@@@@@@V2<LCC@K
"GTIT15UV @@@@@@@@@@@@@@R"$<F&P0B8]ONGECQ @@@@@@@@@@@@@@I!!,_]"2ARPH%J&!!8V@@@@@@@@@@@@@@@_1-EI61''PFFC!!F!!&V@@@@@@@@@@@@@@@
Z7QEI61''PFFC!!H.IV@@@@@@@@@@@@@@@\#Q3CRI''PB-.ICD:Q @@@@@@@@@@@@@@@EDH!!T4P^'',3EBA9# @@@@@@@@@@@@@@[Q-EI61''PFFC!!F!!VZ @@@@@@
@@@@@@@@M1-EI61''PFFC!!F ^V@@@@@@@@@@@@@@@_S=EI61''PFFC!!DQBV@@@@@@@@@@@@@@@B <GL%%''PA%]D 9P# @@@@@@@@@@@@@@@D\FM#VJ]84#S$EW
W@@@@@@@@@@@@@@@@@B@_$X!!#H0!!Q'':@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[219 185 65 198 168 74 219 190 79 243 243 243 247 247 247 212 188 103 224 198 109 222 200 122 234 215 144 254 223 141 240 223 165 253 234 173 253 237 183 241 231 193 188 151 42 211 174 48 191 161 59 254 242 210 208 176 66 242 239 229 220 189 76 242 242 242 245 245 245 255 255 255 222 198 111 244 220 117 237 216 141 255 233 149 254 227 155 250 228 170 196 152 26 252 239 190 253 238 192 212 212 212 249 242 210 207 171 55 211 178 65 225 194 72 230 197 74 255 251 236 250 248 244 231 203 98 246 219 105 245 221 117 227 210 143 241 216 146 253 228 154 249 232 171 253 237 182 174 139 37 239 228 192 202 168 50 209 174 52 210 173 51 214 179 60 222 188 68 210 174 70 224 193 81 208 180 89 254 254 254 225 200 105 232 208 118 220 202 138 252 229 143 252 235 160 205 200 181 186 147 30 202 156 27 251 235 189 255 244 201 216 216 216 233 228 211 193 161 65 207 177 72 230 197 73 252 249 237 252 251 244 208 183 100 213 188 101 231 202 112 206 189 131 252 230 145 254 225 148 254 228 160 254 233 176 187 149 35 198 153 27 211 211 211 215 215 215 248 241 209 225 225 225 223 192 70 231 231 231 231 201 81 225 195 86 253 253 253 219 192 114 251 228 125 243 221 145 253 226 149 247 229 168 252 236 180 201 155 26 253 243 195 255 240 196 255 239 199 217 217 217 220 185 61 254 249 224 223 188 69 232 203 81 244 244 244 252 252 252 211 183 100 236 208 111 227 205 125 252 230 144 253 226 148 236 222 171 197 156 25 202 156 26 190 149 32 187 154 48 197 165 54 203 172 59 215 179 59 224 224 224 228 196 72 236 236 236 210 184 89 249 249 249 250 223 100 251 225 111 217 194 122 233 215 148 246 222 149 253 230 161 186 145 25 200 158 27 251 236 189 209 209 209 205 168 48 218 218 218 208 177 64]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@G8@@_>@@??@@?? @?? @?? @?? @?? @?? @?? @?? @?? @?? @?? @_? @O?@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

defaultIcon
    <resource: #programImage>

    "/ ^ self dbIcon1.
    ^ self dbIcon2.
! !

!AbstractSettingsApplication::SQLServerSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::SQLServerSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::SQLServerSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::SQLServerSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'SQL Server Settings'
         name: 'SQL Server Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 600 550)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             activeHelpKey: #sqlServer
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'EnableBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'SQL Server Enabled'
                         name: 'EnableCheckBox'
                         layout: (LayoutFrame 5 0 0 0 -5 1 22 0)
                         enableChannel: hasSQLServerClass
                         model: sqlServerEnabled
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 25)
                 )
                (ViewSpec
                   name: 'PortBox'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'MySQL Port:'
                         name: 'Label2'
                         layout: (LayoutFrame 5 0 0 0 150 0 22 0)
                         translateLabel: true
                         adjust: right
                         enableDisableColorChannel: sqlServerEnabled
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         layout: (LayoutFrame 150 0 0 0 -5 1 22 0)
                         enableChannel: sqlServerEnabled
                         model: sqlServerPort
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: 'MySQL Port-Number (ODBC)'
                         name: 'Label3'
                         layout: (LayoutFrame 150 0 28 0 596 0 50 0)
                         translateLabel: true
                         adjust: left
                         enableDisableColorChannel: sqlServerEnabled
                       )
                      )

                   )
                   extent: (Point 600 72)
                 )
                (ViewSpec
                   name: 'LogErrorsBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Log Errors'
                         name: 'ErrorLoggingCheckBox'
                         layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                         enableChannel: sqlServerEnabled
                         model: sqlErrorLogging
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 25)
                 )
                (ViewSpec
                   name: 'LogDataBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Log Data'
                         name: 'LogDataCheckBox'
                         layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                         enableChannel: sqlServerEnabled
                         model: sqlDataLogging
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 23)
                 )
                (ViewSpec
                   name: 'LogRequestsBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Log Requests'
                         name: 'LogRequestsCheckBox'
                         layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                         enableChannel: sqlServerEnabled
                         model: sqlLogging
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 24)
                 )
                (ViewSpec
                   name: 'LogSQLBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Log SQL'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                         enableChannel: sqlServerEnabled
                         model: sqlStatementLogging
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 24)
                 )
                (ViewSpec
                   name: 'DebugErrorsBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Debug Errors'
                         name: 'DebugErrorsCheckBox'
                         layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                         enableChannel: sqlServerEnabled
                         model: sqlErrorDebugging
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 23)
                 )
                (ViewSpec
                   name: 'Box1'
                   extent: (Point 600 10)
                 )
                (ViewSpec
                   name: 'EnableSmalltalkBox'
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Virtual Smalltalk Tables Enabled'
                         name: 'EnableSmalltalkCheckBox'
                         layout: (LayoutFrame 25 0 0 0 -5 1 22 0)
                         enableChannel: sqlServerEnabled
                         model: sqlSmalltalkServerEnabled
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 600 24)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::SQLServerSettingsAppl methodsFor:'actions'!

basicReadSettings
    |sqlServerClass|

    sqlServerClass := self sqlServerClass.
    (sqlServerClass notNil and:[sqlServerClass isLoaded]) ifTrue:[
        self sqlServerEnabled value:sqlServerClass serverRunning.
        self sqlSmalltalkServerEnabled value:sqlServerClass isSmalltalkServerEnabled.
        self sqlLogging value:sqlServerClass isLogging.
        self sqlStatementLogging value:sqlServerClass isSQLLogging.
        self sqlErrorLogging value:sqlServerClass isErrorLogging.
        self sqlDataLogging value:sqlServerClass isDataLogging.
        self sqlErrorDebugging value:sqlServerClass isErrorCatching not.
        self sqlServerPort value:sqlServerClass defaultPort
    ] ifFalse:[
        self sqlServerEnabled value:false.
        self sqlSmalltalkServerEnabled value:false.
        self sqlLogging value:false.
        self sqlStatementLogging value:false.
        self sqlErrorLogging value:false.
        self sqlDataLogging value:false.
        self sqlErrorDebugging value:false.
        self sqlServerPort value:nil
    ].

    "Modified: / 25-01-2007 / 17:40:53 / cg"
!

basicSaveSettings
    |sqlServerClass shouldRun port|

    sqlServerClass := self sqlServerClass.

    port := self sqlServerPort value.
    port isNumber ifFalse:[
        port := port asInteger.
    ].

    sqlServerClass defaultPort:port.
    sqlServerClass logging:self sqlLogging value.
    sqlServerClass sqlLogging:self sqlStatementLogging value.
    sqlServerClass errorLogging:self sqlErrorLogging value.
    sqlServerClass dataLogging:self sqlDataLogging value.
    sqlServerClass errorCatching:(self sqlErrorDebugging value not).
    sqlServerClass smalltalkServerEnabled:(self sqlSmalltalkServerEnabled value).

    shouldRun := self sqlServerEnabled value.
    shouldRun ~~ sqlServerClass serverRunning ifTrue:[
        shouldRun ifFalse:[
            sqlServerClass stop
        ] ifTrue:[
            sqlServerClass start.
            "/ must wait a bit; give it a chance to
            "/ really start (before checking)
            Delay waitForSeconds:1.
            sqlServerClass serverRunning ifFalse:[
                self warn:'SQLServer startup failed (see stderr).'
            ]
        ]
    ].

    "Modified: / 25-01-2007 / 17:41:20 / cg"
! !

!AbstractSettingsApplication::SQLServerSettingsAppl methodsFor:'aspects'!

sqlDataLogging
    sqlDataLogging isNil ifTrue:[
        sqlDataLogging := true asValue.
        sqlDataLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sqlDataLogging.
!

sqlErrorDebugging
    sqlErrorDebugging isNil ifTrue:[
        sqlErrorDebugging := true asValue.
        sqlErrorDebugging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sqlErrorDebugging.
!

sqlErrorLogging
    sqlErrorLogging isNil ifTrue:[
        sqlErrorLogging := true asValue.
        sqlErrorLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sqlErrorLogging.
!

sqlLogging
    sqlLogging isNil ifTrue:[
        sqlLogging := true asValue.
        sqlLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sqlLogging.
!

sqlServerEnabled
    sqlServerEnabled isNil ifTrue:[
        sqlServerEnabled := true asValue.
        sqlServerEnabled onChangeSend:#sqlServerEnabledChanged to:self
    ].
    ^ sqlServerEnabled.
!

sqlServerPort
    sqlServerPort isNil ifTrue:[
        sqlServerPort := ValueHolder new.
        sqlServerPort onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sqlServerPort.
!

sqlSmalltalkServerEnabled
    sqlSmalltalkServerEnabled isNil ifTrue:[
        sqlSmalltalkServerEnabled := true asValue.
        sqlSmalltalkServerEnabled onChangeSend:#sqlSmalltalkServerEnabledChanged to:self
    ].
    ^ sqlSmalltalkServerEnabled.
!

sqlStatementLogging
    sqlStatementLogging isNil ifTrue:[
        sqlStatementLogging := true asValue.
        sqlStatementLogging onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sqlStatementLogging.
! !

!AbstractSettingsApplication::SQLServerSettingsAppl methodsFor:'change & update'!

sqlServerEnabledChanged
    self updateModifiedChannel.
    self sqlServerEnabled value ifTrue:[
        sqlServerPort value isEmptyOrNil ifTrue:[
            sqlServerPort value:(self sqlServerClass defaultPort)
        ]
    ]

    "Modified: / 25-01-2007 / 17:46:07 / cg"
!

sqlSmalltalkServerEnabledChanged
    self updateModifiedChannel.
    self sqlSmalltalkServerEnabled value ifTrue:[
        sqlServerPort value isEmptyOrNil ifTrue:[
            sqlServerPort value:(self sqlServerClass defaultPort)
        ]
    ]

    "Modified: / 25-01-2007 / 17:40:03 / cg"
! !

!AbstractSettingsApplication::SQLServerSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/communicationsSettings.html'
! !

!AbstractSettingsApplication::SQLServerSettingsAppl methodsFor:'queries'!

hasSQLServerClass
    ^ self sqlServerClass notNil

    "Created: / 25-01-2007 / 17:45:54 / cg"
!

hasUnsavedChanges
    |sqlServerClass|

    sqlServerClass := self sqlServerClass.
    (sqlServerClass notNil and:[sqlServerClass isLoaded]) ifFalse:[^ false ].

    self sqlServerEnabled value ~= sqlServerClass serverRunning ifTrue:[^ true].
    sqlServerClass serverRunning ifTrue:[
        self sqlSmalltalkServerEnabled value ~= sqlServerClass isSmalltalkServerEnabled ifTrue:[^ true].
        self sqlLogging value ~= sqlServerClass isLogging ifTrue:[^ true].
        self sqlStatementLogging value ~= sqlServerClass isSQLLogging ifTrue:[^ true].
        self sqlErrorLogging value ~= sqlServerClass isErrorLogging ifTrue:[^ true].
        self sqlDataLogging value ~= sqlServerClass isDataLogging ifTrue:[^ true].
        self sqlErrorDebugging value ~= sqlServerClass isErrorCatching not ifTrue:[^ true].
        self sqlServerPort value ~= sqlServerClass defaultPort ifTrue:[^ true].
    ].
    ^ false

    "Modified: / 25-01-2007 / 17:47:32 / cg"
!

sqlServerClass
    ^ SQLServer::SQLServer

    "Created: / 25-01-2007 / 17:29:59 / cg"
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl class methodsFor:'defaults'!

stcCompilationOptions
    ^ #(default never)
!

stcCompilationStrings

    ^ #('primitive code only' 'never')
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::STCCompilerSettingsAppl
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#ccOptions
'Additional flags to pass to the C compiler when compiling a module. In most cases this can be left empty.'

#ccOptionsBuiltin
'These options are always passed to the C compiler.'

#stcIncludes
'Extra C compiler include directories where to search for header files.\This may be left empty, but if you use some third-party C library in your inline C code, you may want to add some extra directories here.'

#stcIncludesBuiltin
'Builtin C compiler include directories that are always used.'

)
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon4

    "Modified: / 17-09-2007 / 11:35:12 / cg"
!

defaultIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::STCCompilerSettingsAppl defaultIcon1'
        ifAbsentPut:[(Depth2Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@C??????@CUUUUUW@CZ(J@B''@CZ""(*''CCZ"*(*''@CV(J(*WKCV*"(*W@CU""()WJCU(J()W@CUZ**%W@CUZ**%WACUV(JUW@CUV""UWDCUU")UWI
CUU")UWICUUR%UWJCUUR!!UWACUUTEUW@CUUUUUW@C??????@@@@@@@@B')
            colorMapFromArray:#[0 0 0 255 255 255 255 189 23 127 127 127]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@@@@O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8O??8@@@@'); yourself); yourself]
!

defaultIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'AbstractSettingsApplication::STCCompilerSettingsAppl class defaultIcon2'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD@0LDA@PDA@PDA@PDA@PDA@PD
A@PDA@LCA PCA@P@@@@@@@@@@@@@@@@@@@@D@0PFA PCA@PC@0@@@@@@@@@@@@@C@0@D@0PFAPTD@0LDA L@@@@@@@@@@@LFA@LCA@TEAPTEA@PE@PL@@@@@
@@@@@@LAAPPDAPTEAPTEAPTF@0@@@@@@@@@@@@@CA TEAPTEA DFAPTD@0@@@@@@@@@@@@@CA@TEA DF@0LAA TEA@LC@@@@@@@@@0LDAPTF@PLC@ HC@PTE
APPD@0@@@@@CA@PEAPTA@0HB@ HCA TEAPDA@0@@@@@C@PDEAPTF@0HB@0LDAPTFA LC@@@@@@@@@0LFA TEA@LCA@PEAPTF@0PD@@@@@@@@@@PCA TEAPPD
APTEAPTD@0PDA@@@@@@@A@PCA@TEAPTEAPTEA DEA@LDA@@@@@@@A@LDAPDFAPTEAPTD@0LAA LDA@P@@@@DA@LF@PLCA@TE@PPCA@PC@0PDA@P@@@@DA@PC
@0PD@0PA@PPCA@PDA@PDA@PD@@PDA@PDA@PD@0PA@0LDA@PDA@PDA@PDA@PDA@PDA@PDA@LCA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD') ; colorMapFromArray:#[255 189 23 127 127 127 236 233 216 0 0 0 255 255 255 194 194 194 161 161 165]; yourself]
!

defaultIcon3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon3 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'AbstractSettingsApplication::STCCompilerSettingsAppl class defaultIcon3'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@0PDA@PD
A@PDA@PDA@PDA@PDA@PDA@LDA LDA@PDA@PDA@PDA@PDA@PD@0LDA@LDA LDA@LCA@PDA@PDA@PDA@PCA PC@0PEAPPC@0PF@0PDA@PDA@PDA@PC@PTDA@TE
APTDA@TA@0PDA@PDA@PDA@PD@0XEAPTEAPTEAPXCA@PDA@PDA@PDA@PD@0PEAPXAA XEAPPCA@PDA@PDA@PDA@LCA@TEA DC@0DFAPTD@0LDA@PDA@PD@0PD
APTE@PLB@ LAAPTEA@PCA@P@A@PD@0DAAPTEA LB@ LFAPTE@PDCA@P@A@PDA@LCA XEAPPC@0PEAPXF@0LDA@PDA@PDA@PD@0XEAPTDA@TEAPXCA@PDA@PD
A@PDA@PD@0PEAPTEAPTEAPPCA@PDA@PDA@PDA@PCA@TAA TEAPTF@PTD@0PDA@PDA@PDA@PCA DC@0PEAPPC@0DF@0PDA@PDA@PDA@PD@0LDA@LD@PLDA@LC
A@PDA@PDA@PDA@PDA@PDA@LD@PLDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@0PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PD') ; colorMapFromArray:#[255 189 23 127 127 127 236 233 216 0 0 0 255 255 255 194 194 194 161 161 165]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@A @@C0@@33@A?? A?? @??@@??@C??0G??8G??8C??0@??@@??@A?? A?? @33@@C0@@A @@@@@@@@@@@@@') ; yourself); yourself]
!

defaultIcon4
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon4 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::STCCompilerSettingsAppl class defaultIcon4'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PC@0PDA@PD
A@PDA@PDA@PDA@PDA@PDA@LDA LDA@PDA@PDA@PDA@PDA@PD@0LDA@LDA LDA@LCA@PDA@PDA@PDA@PCA PC@0PEAPPC@0PF@0PDA@PDA@PDA@PC@PTDA@TE
APTDA@TA@0PDA@PDA@PDA@PD@0XEAPTEAPTEAPXCA@PDA@PDA@PDA@PD@0PEAPXAA XEAPPCA@PDA@PDA@PDA@LCA@TEA DC@0DFAPTD@0LDA@PDA@PD@0PD
APTE@PLB@ LAAPTEA@PCA@P@A@PD@0DAAPTEA LB@ LFAPTE@PDCA@P@A@PDA@LCA XEAPPC@0PEAPXF@0LDA@PDA@PDA@PD@0XEAPTDA@TEAPXCA@PDA@PD
A@PDA@PD@0PEAPTEAPTEAPPCA@PDA@PDA@PDA@PCA@TAA TEAPTF@PTD@0PDA@PDA@PDA@PCA DC@0PEAPPC@0DF@0PDA@PDA@PD@@PD@0LDA@LD@PLDA@LC
A@PDA@PDA@PC@0PDA@PDA@LD@PLDA@PDA@PC@0PDA@PCA@PDA@PDA@PC@0PDA@PDA@PD@0PDA@LDA@PDA@PDA@PDA@PDA@PDA@PDA@LDA@PCA@PD@0LD@0LD
@@LC@@LCA@PD@0PDA@PC@0PDA@PDA@PDA@PDA@PDA@PC@0PD') ; colorMapFromArray:#[255 189 23 127 127 127 236 233 216 0 0 0 255 255 255 194 194 194 161 161 165]; mask:((ImageMask new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@A @@C0@@33@A?? A?? @??@@??@C??0G??8G??8C??0@??@@??@A?? A?? @33@LC0LHA DP@@BH6[DL@@L') ; yourself); yourself]
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::STCCompilerSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::STCCompilerSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::STCCompilerSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'STC Compiler Settings'
         name: 'STC Compiler Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 600 602)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 0
             component:
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'SeparatingBox1'
                   extent: (Point 600 4)
                 )
                (ViewSpec
                   name: 'InfoTextBox'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         name: 'Label14'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         translateLabel: true
                         labelChannel: helpText
                         adjust: left
                       )
                      )

                   )
                   extent: (Point 600 90)
                 )
                (ViewSpec
                   name: 'STCCompilationBox11'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'STC Compilation to Machine Code:'
                         name: 'Label11'
                         layout: (LayoutFrame 0 0 0 0 240 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (PopUpListSpec
                         label: 'PopUp List'
                         name: 'StcCompilation'
                         layout: (LayoutFrame 241 0 0 0 -5 1 22 0)
                         translateLabel: true
                         tabable: true
                         model: stcCompilationSelection
                         enableChannel: canLoadBinaries
                         menu: stcCompilationList
                         useIndex: true
                       )
                      )

                   )
                   extent: (Point 600 29)
                 )
                (ViewSpec
                   name: 'STCCommandBox1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'STC Command:'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: stc
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'STCOptionsBox2'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'STC Options:'
                         name: 'Label2'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField2'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: stcOptions
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'KeepCIntermediateBox'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Keep Intermediate C File:'
                         name: 'Label15'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (CheckToggleSpec
                         name: 'CheckToggle1'
                         layout: (LayoutOrigin 203 0 4 0)
                         translateLabel: true
                         model: stcKeepCIntermediate
                         isTriggerOnDown: true
                         showLamp: false
                         lampColor: (Color 100.0 100.0 0.0)
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'CCCommandBox3'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'CC Command:'
                         name: 'Label3'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField3'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: cc
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'CCOptionsBox1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Built-in C flags:'
                         name: 'Label18'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         activeHelpKey: ccOptionsBuiltin
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField13'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         activeHelpKey: ccOptionsBuiltin
                         initiallyDisabled: true
                         enableChannel: canLoadBinaries
                         model: ccOptionsBuiltin
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 29)
                 )
                (ViewSpec
                   name: 'CCOptionsBox2'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'C flags:'
                         name: 'Label4'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         activeHelpKey: ccOptions
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField4'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         activeHelpKey: ccOptions
                         enableChannel: canLoadBinaries
                         model: ccOptions
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'CCIncludeDirectoriesBox2'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Builtin Include Directories:'
                         name: 'Label19'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         activeHelpKey: stcIncludesBuiltin
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField14'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         activeHelpKey: stcIncludesBuiltin
                         initiallyDisabled: true
                         enableChannel: canLoadBinaries
                         model: stcIncludesBuiltin
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 29)
                 )
                (ViewSpec
                   name: 'CCIncludeDirectoriesBox2'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Include Directories:'
                         name: 'Label5'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         activeHelpKey: stcIncludes
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField5'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         activeHelpKey: stcIncludes
                         enableChannel: canLoadBinaries
                         model: stcIncludes
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'STCDefinesBox6'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Defines:'
                         name: 'Label6'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField6'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: stcDefines
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'LinkCommandBox7'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Link Command:'
                         name: 'Label7'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField7'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: linkCommand
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'LinkArgumentsBox8'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Link Arguments:'
                         name: 'Label8'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField8'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: linkArgs
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'LinkSharedArgumentsBox1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Link Shared Arguments:'
                         name: 'Label12'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField11'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: linkSharedArgs
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'CLibrariesBox9'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'C-Libraries:'
                         name: 'Label9'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField9'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: canLoadBinaries
                         model: stcLibraries
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'STCLibraryPathBox10'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'STC Library Path:'
                         name: 'Label10'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField10'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         enableChannel: enableStcLibraryPath
                         model: stcLibraryPath
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'MakeCommandBox'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Make Command:'
                         name: 'Label13'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (InputFieldSpec
                         name: 'EntryField12'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         model: makeCommand
                         acceptOnLeave: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                (ViewSpec
                   name: 'SeparatingBox2'
                   extent: (Point 600 12)
                 )
                (ViewSpec
                   name: 'SetupForBox'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Set above Options for:'
                         name: 'Label16'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (PopUpListSpec
                         name: 'PopUpList1'
                         layout: (LayoutFrame 201 0 0 0 -5 1 22 0)
                         translateLabel: true
                         tabable: true
                         model: supportedCCompilerSelection
                         menu: supportedCCompilerList
                         useIndex: true
                         stateChangeCallBackSelector: supportedCCompilerSelectionChanged
                       )
                      )

                   )
                   extent: (Point 600 29)
                 )
                (ViewSpec
                   name: 'Box1'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Verbose (Trace Commands):'
                         name: 'Label17'
                         layout: (LayoutFrame 0 0 0 0 200 0 22 0)
                         translateLabel: true
                         adjust: right
                       )
                      (CheckToggleSpec
                         name: 'CheckToggle2'
                         layout: (LayoutOrigin 203 0 4 0)
                         translateLabel: true
                         model: verbose
                         isTriggerOnDown: true
                         showLamp: false
                         lampColor: (Color 100.0 100.0 0.0)
                       )
                      )

                   )
                   extent: (Point 600 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl methodsFor:'actions'!

basicReadSettings
    |t|

    self canLoadBinaries
        value:(ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles]).

    self verbose value:(STCCompilerInterface verbose ? false).

    self stcIncludes value:ParserFlags stcCompilationIncludes.
    self stcDefines value:ParserFlags stcCompilationDefines.
    self stcOptions value:ParserFlags stcCompilationOptions.
    self stcKeepCIntermediate value:ParserFlags stcKeepCIntermediate.
    self ccOptions value:ParserFlags ccCompilationOptions.
    self cc value:ParserFlags ccPath.
    self stc value:ParserFlags stcPath.
    self makeCommand value:ParserFlags makeCommand.

    self linkCommand value:ParserFlags linkCommand.
    self linkArgs value:ParserFlags linkArgs.
    self linkSharedArgs value:ParserFlags linkSharedArgs.

    (t := ParserFlags searchedLibraries) notNil ifTrue:[
        self stcLibraries value:(String fromStringCollection:t separatedBy:' ')
    ].
    (t := ParserFlags libPath) notNil ifTrue:[
        self stcLibraryPath value:t
    ].

    self stcCompilationSelection value:(self class stcCompilationOptions
             indexOf:(ParserFlags stcCompilation)
             ifAbsent:1).

    "Modified: / 09-08-2006 / 18:49:38 / fm"
    "Modified: / 16-09-2011 / 18:45:15 / cg"
!

basicSaveSettings

    STCCompilerInterface verbose:self verbose value.

    ParserFlags stcCompilation:(self class stcCompilationOptions at:self stcCompilationSelection value).
    ParserFlags stcCompilationIncludes:self stcIncludes value.
    ParserFlags stcCompilationDefines:self stcDefines value.
    ParserFlags stcCompilationOptions:self stcOptions value.
    ParserFlags stcKeepCIntermediate:self stcKeepCIntermediate value.
    ParserFlags ccCompilationOptions:self ccOptions value.
    ParserFlags ccPath:self cc value.
    ParserFlags makeCommand:self makeCommand value.

    self stc value ~= ParserFlags stcPath ifTrue:[
        ParserFlags stcPath:self stc value
    ].
    ParserFlags linkCommand:self linkCommand value.
    ParserFlags linkArgs:self linkArgs value.
    ParserFlags linkSharedArgs:self linkSharedArgs value.
    self stcLibraries value notNil ifTrue:[
        ParserFlags searchedLibraries:(self stcLibraries value asCollectionOfWords).
    ].
    stcLibraryPath notNil ifTrue:[
        ParserFlags libPath:(self stcLibraryPath value).
    ].

    "Modified: / 09-08-2006 / 19:33:10 / fm"
    "Modified: / 16-09-2011 / 18:45:28 / cg"
!

setupForBCC
    self cc value:'c:\borland\bcc55\bin\bcc32'.
    self ccOptions value:'-w-'.
    self stcIncludes value:'-I..\..\include -Ic:\Borland\bcc55\Include'.
    self linkCommand value:'c:\borland\bcc55\bin\ilink32'.
    self linkArgs value:'-L..\..\lib\bc -Lc:\Borland\bcc55\Lib -r -c -ap -Tpd -Gi -w-dup'.
    self stcLibraries value:'import32.lib odbc32.lib glu32.lib opengl32.lib'.
    self makeCommand value:'bmake'.

    self updateModifiedChannel.
    self supportedCCompilerSelection value:0
!

setupForCLANG
    |ccOptions linkArgs linkSharedArgs|

    self cc value:'clang'.
    ExternalAddress pointerSize == 4 ifTrue:[
        ccOptions := '-O3 -arch x86'.
        linkArgs := '-arch x86'.
        linkSharedArgs := '-shared -arch x86'.
    ] ifFalse:[
        ccOptions := '-O3 -arch x86_64'.
        linkArgs := '-arch x86_64'.
        linkSharedArgs := '-shared -arch x86_64'.
    ].
    OperatingSystem isOSXlike ifTrue:[
        ccOptions := ccOptions , ' -mmacosx-version-min=10.3'.
        linkSharedArgs := linkSharedArgs , ' -mmacosx-version-min=10.3 librun.so'
    ].

    self ccOptions value:ccOptions.
    self linkArgs value:linkArgs.
    self linkSharedArgs value:linkSharedArgs.
    self stcIncludes value:'-I../../include -I/usr/include/freetype2'.
    self linkCommand value:'clang'.
    self stcLibraries value:''.
    self makeCommand value:'make'.

    self updateModifiedChannel.
    self supportedCCompilerSelection value:0
!

setupForGCC
    | stcPath |
    self cc value:'gcc'.
    self linkSharedArgs value:'-shared'.

    stcPath := self stc value asFilename.
    (stcPath exists not and:[ stcPath isAbsolute ]) ifTrue:[
        stcPath := OperatingSystem pathOfCommand:'stc'.
    ].
    (stcPath exists and:[stcPath isExecutable]) ifTrue:[
        | stcInclude |

        stcInclude := stcPath directory / 'include'.
        stcInclude isDictionary ifTrue:[
            self stcIncludes value:'-I', stcInclude pathName.
        ].
    ].


    self linkCommand value:'gcc'.
    self stcLibraries value:''.
    self makeCommand value:'make'.

    self updateModifiedChannel.
    self supportedCCompilerSelection value:0

    "Modified: / 05-12-2015 / 07:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForMINGW
    ExternalAddress pointerSize == 4 ifTrue:[
        self cc value:'C:\mingw32\bin\gcc'.
        self linkArgs value:'-L..\..\lib\mingw -LC:\mingw32\lib'.
    ] ifFalse:[
        self cc value:'C:\mingw64\bin\gcc'.
        self linkArgs value:'-L..\..\lib\mingw -LC:\mingw64\lib'.
    ].
    self ccOptions value:''.
    self stcIncludes value:'-I..\..\include'.
    self linkCommand value:(self cc value).
    self stcLibraries value:'-lkernel32 -luser32 -lgdi32 -lodbc32 -lglu32 -lopengl32 -luuid -liphlpapi -lws2_32 -lwsock32 -lversion -lwinmm'.
    self makeCommand value:'mingwmake'.

    self updateModifiedChannel.
    self supportedCCompilerSelection value:0
!

setupForMSVC
    |programFiles programFilesX86|

    programFiles := OperatingSystem getEnvironment:'ProgramFiles'.
    programFiles isEmptyOrNil ifTrue:[ programFiles := 'C:\Program Files' ].
    programFilesX86 := OperatingSystem getEnvironment:'ProgramFiles(x86)'.
    programFilesX86 isEmptyOrNil ifTrue:[ programFilesX86 := 'C:\Program Files (x86)' ].

    {
        (programFilesX86,'\Microsoft Visual Studio 10.0\VC\bin'     ) .
        (programFilesX86,'\Microsoft Visual Studio 11.0\VC\bin'     ) .
        (programFilesX86,'\Microsoft Visual Studio 12.0\VC\bin'     ) .
        (programFiles,'\Microsoft Visual Studio 10.0\VC\bin'        ) .
        (programFiles,'\Microsoft Visual Studio 11.0\VC\bin'        ) .
        (programFiles,'\Microsoft Visual Studio 12.0\VC\bin'        ) .
    } do:[:each |
        each asFilename exists ifTrue:[
            self cc value:(each,'\cl.exe').
            self linkCommand value:(each,'\ilink32.exe').
        ].
    ].
    self ccOptions value:'/O1'.
    self stcIncludes value:'-I..\..\include'.
    self linkArgs value:'-L..\..\lib\vc'.
    self stcLibraries value:'import32.lib odbc32.lib glu32.lib opengl32.lib'.
    self makeCommand value:'vcmake'.

    self updateModifiedChannel.
    self supportedCCompilerSelection value:0
!

supportedCCompilerSelectionChanged
    |idx spec compiler|

    idx := self supportedCCompilerSelection value.
    idx == 0 ifTrue:[^ self].

    spec := self supportedCCompilerListSpec at:idx ifAbsent:[^ self].
    compiler := spec second.
    compiler == #clang ifTrue:[
        self setupForCLANG.
        ^ self.
    ].
    compiler == #gcc ifTrue:[
        self setupForGCC.
        ^ self.
    ].
    compiler == #bcc ifTrue:[
        self setupForBCC.
        ^ self.
    ].
    compiler == #msvc ifTrue:[
        self setupForMSVC.
        ^ self.
    ].
    compiler == #mingw ifTrue:[
        self setupForMINGW.
        ^ self.
    ].
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl methodsFor:'aspects'!

canLoadBinaries

    canLoadBinaries isNil ifTrue:[
        canLoadBinaries := (ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles]) asValue.
    ].
    ^ canLoadBinaries.
!

cc

    cc isNil ifTrue:[
        cc := ValueHolder new.
        cc onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ cc.
!

ccOptions

    ccOptions isNil ifTrue:[
        ccOptions := ValueHolder new.
        ccOptions onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ ccOptions.
!

ccOptionsBuiltin
    ^ STCCompilerInterface builtinCFlags

    "Created: / 09-12-2015 / 09:54:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enableStcLibraryPath

    ^ (ObjectFileLoader libPath notNil and:[self canLoadBinaries])
!

linkArgs

    linkArgs isNil ifTrue:[
        linkArgs := ValueHolder new.
        linkArgs onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ linkArgs.
!

linkCommand

    linkCommand isNil ifTrue:[
        linkCommand := ValueHolder new.
        linkCommand onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ linkCommand.
!

linkSharedArgs

    linkSharedArgs isNil ifTrue:[
        linkSharedArgs := ValueHolder new.
        linkSharedArgs onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ linkSharedArgs.
!

makeCommand

    makeCommand isNil ifTrue:[
        makeCommand := ValueHolder new.
        makeCommand onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ makeCommand.

    "Created: / 09-08-2006 / 18:49:52 / fm"
!

stc

    stc isNil ifTrue:[
        stc := ValueHolder new.
        stc onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stc.
!

stcCompilationList

    stcCompilationList isNil ifTrue:[
        stcCompilationList := (resources array:(self class stcCompilationStrings)) asList.
    ].
    ^ stcCompilationList.
!

stcCompilationSelection

    stcCompilationSelection isNil ifTrue:[
        stcCompilationSelection := (self class stcCompilationOptions indexOf:(ParserFlags stcCompilation) ifAbsent:1) asValue.
        stcCompilationSelection onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stcCompilationSelection.
!

stcDefines

    stcDefines isNil ifTrue:[
        stcDefines := ValueHolder new.
        stcDefines onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stcDefines.
!

stcIncludes

    stcIncludes isNil ifTrue:[
        stcIncludes := ValueHolder new.
        stcIncludes onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stcIncludes.
!

stcIncludesBuiltin
    ^ STCCompilerInterface builtinCIncludeDirectories

    "Modified: / 09-12-2015 / 17:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stcKeepCIntermediate
    stcKeepCIntermediate isNil ifTrue:[
        stcKeepCIntermediate := false asValue.
        stcKeepCIntermediate onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stcKeepCIntermediate.

    "Created: / 16-09-2011 / 18:42:10 / cg"
!

stcLibraries

    stcLibraries isNil ifTrue:[
        stcLibraries := ValueHolder new.
        stcLibraries onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stcLibraries.
!

stcLibraryPath

    stcLibraryPath isNil ifTrue:[
        stcLibraryPath := ValueHolder new.
        stcLibraryPath onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stcLibraryPath.
!

stcOptions

    stcOptions isNil ifTrue:[
        stcOptions := ValueHolder new.
        stcOptions onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ stcOptions.
!

supportedCCompilerList
    ^ self supportedCCompilerListSpec collect:[:s | s first].
!

supportedCCompilerListSpec
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ #(
            ('Borland CC v5.5 (bcc)'        #bcc)
            ('Microsoft Visual C (cl)'      #msvc)
            ('Mingw (gcc)'                  #mingw)
         ).
    ].

    ^ #(
        ('GNU gcc'                      #gcc)
        ('clang'                        #clang)
     ).
!

supportedCCompilerSelection
    supportedCCompilerSelection isNil ifTrue:[
        supportedCCompilerSelection := ValueHolder new.
    ].
    ^ supportedCCompilerSelection.
!

verbose

    verbose isNil ifTrue:[
        verbose := false asValue.
        verbose onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ verbose.
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/compilerSettings.html'
!

helpText
    ^ 'These settings are only relevant if methods are to be compiled directly to
machine code (i.e. using the external stc, not the builtin bytecode compiler).
Stc-compilation is mandatory for methods which contain inline-C code,
otherwise, for plain smalltalk code, is not needed.'

    "Created: / 16-09-2011 / 18:18:32 / cg"
! !

!AbstractSettingsApplication::STCCompilerSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    | searchedLibs |

    ((ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles]) ~= self canLoadBinaries value ) ifTrue:[^ true].

    ((STCCompilerInterface verbose) ~= (self verbose value)) ifTrue:[^ true].

    ((ParserFlags stcCompilation ? #default) ~= (self class stcCompilationOptions at:self stcCompilationSelection value)) ifTrue:[^ true].
    ((ParserFlags stcCompilationIncludes) ~= self stcIncludes value) ifTrue:[^ true].
    ((ParserFlags stcCompilationDefines) ~= self stcDefines value) ifTrue:[^ true].
    ((ParserFlags stcCompilationOptions) ~= self stcOptions value) ifTrue:[^ true].
    ((ParserFlags stcKeepCIntermediate) ~= self stcKeepCIntermediate value) ifTrue:[^ true].
    ((ParserFlags ccCompilationOptions) ~= self ccOptions value) ifTrue:[^ true].
    ((ParserFlags ccPath) ~= self cc value) ifTrue:[^ true].
    ((ParserFlags stcPath) ~= self stc value) ifTrue:[^ true].
    ((ParserFlags makeCommand) ~= self makeCommand value) ifTrue:[^ true].
    ((ParserFlags linkCommand) ~= self linkCommand value) ifTrue:[^ true].
    ((ParserFlags linkArgs) ~= self linkArgs value) ifTrue:[^ true].
    ((ParserFlags linkSharedArgs) ~= self linkSharedArgs value) ifTrue:[^ true].
     (ParserFlags libPath ~= self stcLibraryPath value) ifTrue:[^ true].

    searchedLibs := ParserFlags searchedLibraries.
    searchedLibs notNil ifTrue:[
        (String fromStringCollection:searchedLibs separatedBy:' ') ~= self stcLibraries value ifTrue:[^ true].
    ].
    ^ false.

    "Modified: / 09-08-2006 / 18:50:36 / fm"
    "Modified: / 16-09-2011 / 18:42:00 / cg"
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl class methodsFor:'defaults'!

exampleText

    ^  'methodSelector:methodArg
    "method comment:
     some stupid code to show the current settings"

    |index|

    "/ another comment ...
    self at:index+1.                    "/ a message
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
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::SourceCodeFormatSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@CL3L3L3L3L3LP@@L4QDQDQDQDQAL@@3P"IDQDQDQDD0@CMBQDQDQDQDPS@@L4IDQDQDQDQAL@@3P"IDQDQDQDD0@CMDQDP"H"H$PS@@L4
QDQDQDQDQAL@@3QDQDH"H"IDD0@CMDQDQDQDQDPS@@L4QDQBH"H"QAL@@3QDQDQDQDQD@0@CMDQDP"H"H$PC@@L4QDQDQDQDQ@L@@3P"IDQDQDQD@0@CMDP$
QDQDQDPC@@L4QBQDQDQDQ@L@@3P"IDQDQDQD@0@CMDQDQDQDQDPC@@LP@@@@@@@@@@L@@CL3L3L3L3L3L0@b') ; colorMapFromArray:#[0 0 0 48 48 48 160 160 160 208 208 208 240 240 240]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@@@@_?? _??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0_??0O??0') ; yourself); yourself]
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::SourceCodeFormatSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::SourceCodeFormatSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::SourceCodeFormatSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Code Format Settings'
         name: 'Code Format Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 613 685)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel3'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
             horizontalLayout: fit
             verticalLayout: topSpaceFit
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (VerticalPanelViewSpec
                   name: 'VerticalPanel1'
                   horizontalLayout: fit
                   verticalLayout: bottom
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box1'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Space around Temporaries'
                               name: 'CheckBox3'
                               layout: (LayoutFrame 0 0 0 0 270 0 30 0)
                               model: spaceAroundTemporaries
                               translateLabel: true
                             )
                            (CheckBoxSpec
                               label: 'Blank line after local Var Declaration'
                               name: 'CheckBox4'
                               layout: (LayoutFrame 270 0 0 0 0 1 30 0)
                               model: emptyLineAfterTemporaries
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 613 30)
                       )
                      (ViewSpec
                         name: 'Box11'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Space after ''^'''
                               name: 'CheckBox5'
                               layout: (LayoutFrame 0 0 0 0 270 0 30 0)
                               model: spaceAfterReturnToken
                               translateLabel: true
                             )
                            (CheckBoxSpec
                               label: 'Space after '':'' in Keywords'
                               name: 'CheckBox6'
                               layout: (LayoutFrame 270 0 0 0 -5 1 30 0)
                               model: spaceAfterKeywordSelector
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 613 30)
                       )
                      (ViewSpec
                         name: 'Box15'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Space after ''['''
                               name: 'CheckBox9'
                               layout: (LayoutFrame 0 0 0 0 270 0 30 0)
                               model: spaceAfterBlockStart
                               translateLabel: true
                             )
                            (CheckBoxSpec
                               label: 'Space before '']'''
                               name: 'CheckBox10'
                               layout: (LayoutFrame 270 0 0 0 -5 1 30 0)
                               model: spaceBeforeBlockEnd
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 613 30)
                       )
                      (ViewSpec
                         name: 'Box12'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'C-Style Blocks'
                               name: 'CheckBox8'
                               layout: (LayoutFrame 0 0 0 0 270 0 30 0)
                               model: cStyleBlocks
                               translateLabel: true
                             )
                            (CheckBoxSpec
                               label: 'Block Args on new Line'
                               name: 'CheckBox7'
                               layout: (LayoutFrame 270 0 0 0 -5 1 30 0)
                               model: blockArgumentsOnNewLine
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 613 30)
                       )
                      (ViewSpec
                         name: 'Box13'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Indent:'
                               name: 'Label1'
                               layout: (LayoutFrame 0 0 0 0 327 0 30 0)
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'EntryField1'
                               layout: (LayoutFrame 334 0 0 0 381 0 30 0)
                               model: tabIndent
                               type: number
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: true
                             )
                            )

                         )
                         extent: (Point 613 30)
                       )
                      (ViewSpec
                         name: 'Box16'
                         component:
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Max Length for Single Line Blocks:'
                               name: 'Label5'
                               layout: (LayoutFrame 0 0 0 0 327 0 30 0)
                               translateLabel: true
                               adjust: right
                             )
                            (InputFieldSpec
                               name: 'EntryField4'
                               layout: (LayoutFrame 334 0 0 0 381 0 30 0)
                               model: maxLengthForSingleLineBlocks
                               type: number
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnLostFocus: true
                               acceptOnPointerLeave: true
                             )
                            )

                         )
                         extent: (Point 613 30)
                       )
                      (HorizontalPanelViewSpec
                         name: 'HorizontalPanel1'
                         horizontalLayout: fitSpace
                         verticalLayout: bottom
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Reset to ST/X Default'
                               name: 'Button1'
                               translateLabel: true
                               tabable: true
                               model: resetToStxDefault
                               extent: (Point 300 22)
                             )
                            (ActionButtonSpec
                               label: 'Reset to RefactoryBrowser Default'
                               name: 'Button2'
                               translateLabel: true
                               tabable: true
                               model: resetToRBDefault
                               extent: (Point 301 22)
                             )
                            )

                         )
                         extent: (Point 613 30)
                       )
                      )

                   )
                   extent: (Point 613 180)
                 )
                (ViewSpec
                   name: 'SpacingBox1'
                   extent: (Point 613 10)
                 )
                (ViewSpec
                   name: 'Box14'
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Sample Output:'
                         name: 'Label3'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         translateLabel: true
                         adjust: left
                       )
                      (TextEditorSpec
                         name: 'TextEditor3'
                         layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                         model: editorText
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                         postBuildCallback: postBuildTextEditor:
                       )
                      )

                   )
                   extent: (Point 613 453)
                 )
                )

             )
           )
          (CheckBoxSpec
             label: 'Auto Format'
             name: 'CheckBox2'
             layout: (LayoutFrame 3 0 -30 1 0 1 0 1)
             model: autoFormat
             translateLabel: true
           )
          )

       )
     )
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl methodsFor:'actions'!

basicReadSettings
    reformatLocked := true.

    self
        readAspects:
            #(
                tabIndent
                spaceAroundTemporaries
                emptyLineAfterTemporaries
                spaceAfterReturnToken
                spaceAfterKeywordSelector
                spaceAfterBlockStart
                spaceBeforeBlockEnd
                cStyleBlocks
                blockArgumentsOnNewLine
                maxLengthForSingleLineBlocks
            )
        from:RBFormatter.

    self autoFormat value:currentUserPrefs autoFormatting.
    self updateModifiedChannel.
    reformatLocked := false.
    self reformat.
!

basicSaveSettings

    currentUserPrefs autoFormatting:self autoFormat value.
    currentUserPrefs at:#'formatter.tabIndent' put:self tabIndent value.
    currentUserPrefs at:#'formatter.spaceAroundTemporaries' put:self spaceAroundTemporaries value.
    currentUserPrefs at:#'formatter.emptyLineAfterTemporaries' put:self emptyLineAfterTemporaries value.
    currentUserPrefs at:#'formatter.spaceAfterReturnToken' put:self spaceAfterReturnToken value.
    currentUserPrefs at:#'formatter.spaceAfterKeywordSelector' put:self spaceAfterKeywordSelector value.
    currentUserPrefs at:#'formatter.spaceAfterBlockStart' put:self spaceAfterBlockStart value.
    currentUserPrefs at:#'formatter.spaceBeforeBlockEnd' put:self spaceBeforeBlockEnd value.
    currentUserPrefs at:#'formatter.cStyleBlocks' put:self cStyleBlocks value.
    currentUserPrefs at:#'formatter.blockArgumentsOnNewLine' put:self blockArgumentsOnNewLine value.
    currentUserPrefs at:#'formatter.maxLengthForSingleLineBlocks' put:self maxLengthForSingleLineBlocks value.
    RBFormatter
        tabIndent:self tabIndent value;
        spaceAroundTemporaries:self spaceAroundTemporaries value;
        emptyLineAfterTemporaries:self emptyLineAfterTemporaries value;
        spaceAfterReturnToken:self spaceAfterReturnToken value;
        spaceAfterKeywordSelector:self spaceAfterKeywordSelector value;
        spaceAfterBlockStart:self spaceAfterBlockStart value;
        spaceBeforeBlockEnd:self spaceBeforeBlockEnd value;
        cStyleBlocks:self cStyleBlocks value;
        blockArgumentsOnNewLine:self blockArgumentsOnNewLine value;
        maxLengthForSingleLineBlocks:self maxLengthForSingleLineBlocks value asInteger.
!

reformat

    |tree s_tabIndent s_spaceAroundTemporaries s_emptyLineAfterTemporaries
     s_spaceAfterReturnToken s_spaceAfterKeywordSelector s_cStyleBlocks
     s_maxLengthForSingleLineBlocks s_blockArgumentsOnNewLine
     s_spaceAfterBlockStart s_spaceBeforeBlockEnd|

    reformatLocked ifFalse:[
        "/
        "/ temporary change the RBFormatters settings ...
        "/
        s_tabIndent := RBFormatter tabIndent.
        s_spaceAroundTemporaries := RBFormatter spaceAroundTemporaries.
        s_emptyLineAfterTemporaries := RBFormatter emptyLineAfterTemporaries.
        s_spaceAfterReturnToken := RBFormatter spaceAfterReturnToken.
        s_spaceAfterKeywordSelector := RBFormatter spaceAfterKeywordSelector.
        s_spaceAfterBlockStart := RBFormatter spaceAfterBlockStart.
        s_spaceBeforeBlockEnd := RBFormatter spaceBeforeBlockEnd.
        s_cStyleBlocks := RBFormatter cStyleBlocks.
        s_blockArgumentsOnNewLine := RBFormatter blockArgumentsOnNewLine.
        s_maxLengthForSingleLineBlocks := RBFormatter maxLengthForSingleLineBlocks.

        RBFormatter
            tabIndent:self tabIndent value;
            spaceAroundTemporaries:self spaceAroundTemporaries value;
            emptyLineAfterTemporaries:self emptyLineAfterTemporaries value;
            spaceAfterReturnToken:self spaceAfterReturnToken value;
            spaceAfterKeywordSelector:self spaceAfterKeywordSelector value;
            spaceAfterBlockStart:self spaceAfterBlockStart value;
            spaceBeforeBlockEnd:self spaceBeforeBlockEnd value;
            cStyleBlocks:self cStyleBlocks value;
            blockArgumentsOnNewLine:self blockArgumentsOnNewLine value;
            maxLengthForSingleLineBlocks:self maxLengthForSingleLineBlocks value.

"/        tree := RBParser
"/                    parseMethod:self class exampleText
"/                    onError: [:aString :position | nil].
"/        tree do:[:node |
"/            (node ~~ tree and:[node parent isNil]) ifTrue:[
"/                self error:'No parent for node'.
"/            ]
"/        ].
"/        self editorText value:tree printString.
        self editorText value:(RBFormatter format:(self class exampleText)).

        RBFormatter
            tabIndent:s_tabIndent;
            spaceAroundTemporaries:s_spaceAroundTemporaries;
            emptyLineAfterTemporaries:s_emptyLineAfterTemporaries;
            spaceAfterReturnToken:s_spaceAfterReturnToken;
            spaceAfterKeywordSelector:s_spaceAfterKeywordSelector;
            spaceAfterBlockStart:s_spaceAfterBlockStart;
            spaceBeforeBlockEnd:s_spaceBeforeBlockEnd;
            cStyleBlocks:s_cStyleBlocks;
            blockArgumentsOnNewLine:s_blockArgumentsOnNewLine;
            maxLengthForSingleLineBlocks:s_maxLengthForSingleLineBlocks.
      ].
!

resetToRBDefault

    reformatLocked := true.
    self tabIndent value: 8.
    self spaceAfterReturnToken value:false.
    self spaceAfterKeywordSelector value:true.
    self spaceAroundTemporaries value:true.
    self spaceAfterBlockStart value:true.
    self spaceBeforeBlockEnd value:true.
    self emptyLineAfterTemporaries value:false.
    self cStyleBlocks value:false.
    self blockArgumentsOnNewLine value:false.
    self maxLengthForSingleLineBlocks value: 20.
    reformatLocked := false.
    self reformat.
!

resetToStxDefault

    reformatLocked := true.
    self tabIndent value: 4.
    self spaceAfterReturnToken value: true.
    self spaceAfterKeywordSelector value: false.
    self spaceAroundTemporaries value: false.
    self spaceAfterBlockStart value:false.
    self spaceBeforeBlockEnd value:false.
    self emptyLineAfterTemporaries value: true.
    self cStyleBlocks value: true.
    self blockArgumentsOnNewLine value:false.
    self maxLengthForSingleLineBlocks value: 20.
    reformatLocked := false.
    self reformat.
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl methodsFor:'aspects'!

autoFormat

    autoFormat isNil ifTrue:[
        autoFormat := currentUserPrefs autoFormatting asValue.
        autoFormat onChangeSend:#updateModifiedChannel to:self
    ].
    ^ autoFormat.
!

blockArgumentsOnNewLine

    blockArgumentsOnNewLine isNil ifTrue:[
        blockArgumentsOnNewLine := true asValue.
        blockArgumentsOnNewLine addDependent:self.
    ].
    ^ blockArgumentsOnNewLine.
!

cStyleBlocks

    cStyleBlocks isNil ifTrue:[
        cStyleBlocks := true asValue.
        cStyleBlocks addDependent:self.
    ].
    ^ cStyleBlocks.
!

editorText

    editorText isNil ifTrue:[
        editorText := ValueHolder new.
    ].
    ^ editorText.
!

emptyLineAfterTemporaries

    emptyLineAfterTemporaries isNil ifTrue:[
        emptyLineAfterTemporaries := true asValue.
        emptyLineAfterTemporaries addDependent:self.
    ].
    ^ emptyLineAfterTemporaries.
!

maxLengthForSingleLineBlocks

    maxLengthForSingleLineBlocks isNil ifTrue:[
        maxLengthForSingleLineBlocks := ValueHolder new.
        maxLengthForSingleLineBlocks addDependent:self.
    ].
    ^ maxLengthForSingleLineBlocks.
!

spaceAfterBlockStart

    spaceAfterBlockStart isNil ifTrue:[
        spaceAfterBlockStart := true asValue.
        spaceAfterBlockStart addDependent:self.
    ].
    ^ spaceAfterBlockStart.
!

spaceAfterKeywordSelector

    spaceAfterKeywordSelector isNil ifTrue:[
        spaceAfterKeywordSelector := true asValue.
        spaceAfterKeywordSelector addDependent:self.
    ].
    ^ spaceAfterKeywordSelector.
!

spaceAfterReturnToken

    spaceAfterReturnToken isNil ifTrue:[
        spaceAfterReturnToken := true asValue.
        spaceAfterReturnToken addDependent:self.
    ].
    ^ spaceAfterReturnToken.
!

spaceAroundTemporaries

    spaceAroundTemporaries isNil ifTrue:[
        spaceAroundTemporaries := true asValue.
        spaceAroundTemporaries addDependent:self.
    ].
    ^ spaceAroundTemporaries.
!

spaceBeforeBlockEnd

    spaceBeforeBlockEnd isNil ifTrue:[
        spaceBeforeBlockEnd := true asValue.
        spaceBeforeBlockEnd addDependent:self.
    ].
    ^ spaceBeforeBlockEnd.
!

tabIndent

    tabIndent isNil ifTrue:[
        tabIndent := ValueHolder new.
        tabIndent addDependent:self.
    ].
    ^ tabIndent.
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    (changedObject == self blockArgumentsOnNewLine
    or:[ changedObject == self cStyleBlocks
    or:[ changedObject == self emptyLineAfterTemporaries
    or:[ changedObject == self maxLengthForSingleLineBlocks
    or:[ changedObject == self spaceAfterKeywordSelector
    or:[ changedObject == self spaceAfterReturnToken
    or:[ changedObject == self spaceAfterBlockStart
    or:[ changedObject == self spaceBeforeBlockEnd
    or:[ changedObject == self spaceAroundTemporaries
    or:[ changedObject == self tabIndent]]]]]]]]])
    ifTrue:[
        self updateModifiedChannel.
        self reformat.
        ^ self
    ].
    super
        update:something
        with:aParameter
        from:changedObject
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/sourceFormatSettings.html'
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl methodsFor:'initialization & release'!

initialize
    super initialize.
    RBFormatter isNil ifTrue:[
        ^ self warn:'Sorry, no RBFormatter class'
    ].
    RBFormatter isLoaded ifFalse:[
        WindowGroup activeGroup withWaitCursorDo:[RBFormatter autoload]
    ].
    reformatLocked := false.
!

postBuildTextEditor:aWidget

    aWidget cursorMovementWhenUpdating:nil;
    scrollWhenUpdating:nil.
! !

!AbstractSettingsApplication::SourceCodeFormatSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    self autoFormat value ~= currentUserPrefs autoFormatting ? false ifTrue:[^ true].

    (self
        hasChangedAspectIn:
            #(
                tabIndent
                spaceAroundTemporaries
                emptyLineAfterTemporaries
                spaceAfterReturnToken
                spaceAfterKeywordSelector
                spaceAfterBlockStart
                spaceBeforeBlockEnd
                cStyleBlocks
                blockArgumentsOnNewLine
                maxLengthForSingleLineBlocks
            )
        asComparedTo:RBFormatter) ifTrue:[^ true].

    ^ false
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl class methodsFor:'documentation'!

documentation
"
    this is the old (now obsolete) settings app, which was used until multiple
    managers were supported (i.e. when only the CVSSourceCodeManager was available).
    It has been split into a generic part (manager-to-module assignment),
    and per-manager subapplications.
"
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::SourceCodeManagementSettingsAppl
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#addPerPackageManager
'Add a new per-package manager definition'

#browseSourceCache
'Open a file browser on the source cache directory'

#checkClassesWhenCheckingIn
'Before checking into the repository, check classes for leftover halt and breakpoint code'

#checkPerPackageManager
'Open a window to show which scm-manager is responsible for which package'

#condenseSourceCache
'Cleanup old cached versions from the source cache.\Will keep only the current (newest) version in the cache.\Access to older code versions will be slowed down (compare with old version browser function)'

#defaultManagerType
'The default repository type.\This is used for packages for which no entry matches in the list below'

#editPerPackageManager
'Modify the selected per-package manager definition'

#fillSourceCache
'Fill the cache (by fetching all source files) in a low-prio background process'

#flushSourceCache
'Remove all files from the source cache.\Access to source code will temporarily be slowed down,\until sources have been refetched from the repository'

#keepMethodSourceInImage
'After first file access, keep the method sources in the image itself.\All following text search operations will be much faster.\Grows the image over time (but who cares, these days)'

#moveManagerDown
'Move the selected entry down in the list.\(The first matching definition is used to determine which repository type is used)'

#moveManagerUp
'Move the selected entry up in the list.\(The first matching definition is used to determine which repository type is used)'

#perPackageConfiguration
'Define per-package repository types here.\For any non-matching package-id, the default repository type is used'

#removePerPackageManager
'Remove the selected per-package manager definition'

#sourceCache
'After checkout, keep the sourcefile in a local file (to avoid repeated checkout of the same file)'

#useLocalSources
'If present, use the local source files (from the development system''s tree),\making source access much faster if you have a slow repository access.\If checked, you should NOT check out new sources on the shell level into those sourcefiles,\otherwise, the browser may show corrupt source text.\\If checkout fails, these will always be tried as second chance.'

#useManager
'Enable source code management.\If off, all queries for sourcecode are resolved by local files (offline operation)'

#verboseSourceCodeAccess
'Output debugging messages on the Transcript\(mostly traces of the underlying scm mechanism, such as cvs commands)'

)
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::SourceCodeManagementSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth8Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@A@PHB@0P@@@@@@@@@@@@@@@@@@@HEA \HA $JB0HD@@@@@@@@@@@@@@HLA04NC0HD@@L@@ P@@@@@@@@@@@@ED@ NDP@@@@@@@@@D@@@@@@@@
@@@BA \FAPP@@@@@@@@@@@P@@@@@@@@@AQ@RC0@@@@@@@@@@@@@@@@@@@@@@@@TGA!!DD@@@@@@@@@@@@@@@@@@@D@PDIA08OA@@@@@@@@@@@@@@@@@@@AP S
A0XIBPXGC0P@@@@@@@@@@@@@@@@ECAPLBPXOAP@@@@@@EQX@@@@@@@@@@@TIE@XOAP@@@@@@EQ\XE @@@@@@@@@@AP$OAP@@@@@@FQ\ZE!! V@@@@@@@@@@@E
F0@@@@@@EQ\ZF!!(VFAX@@@@@@@@@@@@@@@@ZEQ\VE!!(ZF!!XWF @@@@@@@@@@@@@@@@@@@A\ZE!!(@@@@@@@@@@@@@@@@@@@@@@@@XE!!XZ@@@@@@@@@@@@@@@@
@@@@@@@@EQ(V@@@@@@@@@@@@@@@@@@@@@@@@EQ\VE @@@@@@@@@@@@@@@@@@@@@@EQ VE @@@@@@@@@@@@@@F @@@@@WEQ VE!!(@@@@@@@@@@@@@@@@@E!!\W
EQXVE @@@@@@@@@@@@@@@@@@@@@@@A(Z@@@@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 32 64 0 0 64 0 32 32 0 0 32 0 32 96 32 96 192 128 192 224 192 160 224 160 32 128 64 64 96 64 64 96 32 32 160 64 160 224 192 64 160 96 32 128 32 224 224 224 64 128 64 160 192 160 224 224 192 32 160 96 160 160 160 64 64 64 96 96 96 128 128 128 192 192 192 32 32 32 32 64 32]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@O8@@?>@A??@A?C C<@0C8@PC8@@??@@??F@_>O@O<_ G8?0C1?8A#?<@C?<@@_@H@_@L@?@GC>@C?>@A?<@@_0@'); yourself); yourself]
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::SourceCodeManagementSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::SourceCodeManagementSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::SourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Source Code Manager Settings'
         name: 'Source Code Manager Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 660 639)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: topSpace
             horizontalSpace: 3
             verticalSpace: 20
             component:
            (SpecCollection
               collection: (
                (VerticalPanelViewSpec
                   name: 'VerticalPanel3'
                   horizontalLayout: fit
                   verticalLayout: top
                   horizontalSpace: 3
                   verticalSpace: 4
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box3'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Sourcecode Management'
                               name: 'SourcecodeManagementCheckBox'
                               layout: (LayoutFrame 5 0 0 0.0 332 0 30 0)
                               activeHelpKey: useManager
                               model: useManager
                               translateLabel: true
                             )
                            (ComboListSpec
                               name: 'ComboList1'
                               layout: (LayoutFrame -151 1 0 0 -5 1 30 0)
                               activeHelpKey: defaultManagerType
                               visibilityChannel: moreThanOneManagerTypesAvailable
                               enableChannel: useManager
                               model: selectedManagerTypeIndexHolder
                               comboList: availableManagerTypeNames
                               useIndex: true
                             )
                            (LabelSpec
                               label: 'Default Repository Type:'
                               name: 'Label14'
                               layout: (AlignmentOrigin -154 1 16 0 1 0.5)
                               activeHelpKey: defaultManagerType
                               translateLabel: true
                               resizeForLabel: true
                               adjust: right
                             )
                            )

                         )
                         extent: (Point 660 30)
                       )
                      (FramedBoxSpec
                         label: 'Per Package Settings'
                         name: 'PerPackageConfiguration'
                         activeHelpKey: perPackageConfiguration
                         labelPosition: topLeft
                         translateLabel: true
                         component:
                        (SpecCollection
                           collection: (
                            (VerticalPanelViewSpec
                               name: 'RepositoryConfigurations'
                               layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                               activeHelpKey: perPackageConfiguration
                               horizontalLayout: fit
                               verticalLayout: bottomFit
                               horizontalSpace: 3
                               verticalSpace: 3
                               component:
                              (SpecCollection
                                 collection: (
                                  (ViewSpec
                                     name: 'RepositoryConfigurationListBox'
                                     activeHelpKey: perPackageConfiguration
                                     component:
                                    (SpecCollection
                                       collection: (
                                        (DataSetSpec
                                           name: 'RepositoryConfigurationList'
                                           layout: (LayoutFrame 0 0 0 0 -122 1 0 1)
                                           enableChannel: useManager
                                           model: selectedManagerPerMatchingModuleHolder
                                           hasHorizontalScrollBar: true
                                           hasVerticalScrollBar: true
                                           dataList: managerPerMatchingModule
                                           columnHolder: managerPerMatchingModuleColumns
                                           beDependentOfRows: true
                                         )
                                        (VerticalPanelViewSpec
                                           name: 'Buttons1'
                                           layout: (LayoutFrame -121 1 0 0 0 1 -22 1)
                                           horizontalLayout: fit
                                           verticalLayout: top
                                           horizontalSpace: 5
                                           verticalSpace: 3
                                           component:
                                          (SpecCollection
                                             collection: (
                                              (ActionButtonSpec
                                                 label: 'Add...'
                                                 name: 'ButtonAdd'
                                                 activeHelpKey: addPerPackageManager
                                                 translateLabel: true
                                                 model: actionAdd
                                                 extent: (Point 119 30)
                                               )
                                              (ActionButtonSpec
                                                 label: 'Edit...'
                                                 name: 'ButtonEdit'
                                                 activeHelpKey: editPerPackageManager
                                                 translateLabel: true
                                                 model: actionEdit
                                                 enableChannel: canRemoveManagerPerPackageEntry
                                                 extent: (Point 119 30)
                                               )
                                              (ActionButtonSpec
                                                 label: 'Move Up'
                                                 name: 'ButtonModeUp'
                                                 activeHelpKey: moveManagerUp
                                                 translateLabel: true
                                                 model: actionMoveUp
                                                 enableChannel: canMoveUp
                                                 extent: (Point 119 30)
                                               )
                                              (ActionButtonSpec
                                                 label: 'Move Down'
                                                 name: 'ButtonModeDown'
                                                 activeHelpKey: moveManagerDown
                                                 translateLabel: true
                                                 model: actionMoveDown
                                                 enableChannel: canMoveDown
                                                 extent: (Point 119 30)
                                               )
                                              (LabelSpec
                                                 name: 'SpacingLabel'
                                                 translateLabel: true
                                                 extent: (Point 121 22)
                                               )
                                              (ActionButtonSpec
                                                 label: 'Remove'
                                                 name: 'ButtonRemove'
                                                 activeHelpKey: removePerPackageManager
                                                 translateLabel: true
                                                 model: actionRemove
                                                 enableChannel: canRemoveManagerPerPackageEntry
                                                 extent: (Point 119 30)
                                               )
                                              )

                                           )
                                         )
                                        (ActionButtonSpec
                                           label: 'Test'
                                           name: 'Button2'
                                           layout: (LayoutFrame -90 1 -30 1 0 1 0 1)
                                           activeHelpKey: checkPerPackageManager
                                           translateLabel: true
                                           model: actionTest
                                         )
                                        )

                                     )
                                     extent: (Point 622 262)
                                   )
                                  )

                               )
                             )
                            )

                         )
                         extent: (Point 660 300)
                       )
                      (FramedBoxSpec
                         label: 'Source Cache'
                         name: 'SourceCacheBox'
                         activeHelpKey: sourceCache
                         labelPosition: topLeft
                         translateLabel: true
                         component:
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'SourceCacheDirBox'
                               layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                               component:
                              (SpecCollection
                                 collection: (
                                  (FilenameInputFieldSpec
                                     name: 'FilenameEntryField1'
                                     layout: (LayoutFrame 64 0.25 0 0 -2 1 30 0)
                                     enableChannel: useManager
                                     model: sourceCacheDir
                                     immediateAccept: false
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     acceptOnLostFocus: true
                                     acceptOnPointerLeave: true
                                   )
                                  (LabelSpec
                                     label: 'Source Cache Dir:'
                                     name: 'SourceCacheDirLabel'
                                     layout: (LayoutFrame 0 0.0 0 0 60 0.25 30 0)
                                     translateLabel: true
                                     adjust: right
                                   )
                                  )

                               )
                             )
                            (HorizontalPanelViewSpec
                               name: 'CacheActionsHorizontalPanel1'
                               layout: (LayoutFrame 0 0 37 0 -1 1 67 0)
                               horizontalLayout: right
                               verticalLayout: center
                               horizontalSpace: 3
                               verticalSpace: 3
                               component:
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Fill Cache'
                                     name: 'FillCacheInBackgroundButton'
                                     activeHelpKey: fillSourceCache
                                     translateLabel: true
                                     tabable: true
                                     model: fillSourceCache
                                     enableChannel: useManager
                                     extent: (Point 150 30)
                                   )
                                  )

                               )
                             )
                            (HorizontalPanelViewSpec
                               name: 'CacheActionsHorizontalPanel2'
                               layout: (LayoutFrame 0 0 70 0 -1 1 100 0)
                               horizontalLayout: right
                               verticalLayout: center
                               horizontalSpace: 3
                               verticalSpace: 3
                               component:
                              (SpecCollection
                                 collection: (
                                  (ActionButtonSpec
                                     label: 'Browse'
                                     name: 'Button3'
                                     activeHelpKey: browseSourceCache
                                     translateLabel: true
                                     tabable: true
                                     model: browseSourceCache
                                     enableChannel: useManager
                                     extent: (Point 171 30)
                                   )
                                  (ViewSpec
                                     name: 'Box5'
                                     extent: (Point 20 10)
                                   )
                                  (ActionButtonSpec
                                     label: 'Flush'
                                     name: 'Button4'
                                     activeHelpKey: flushSourceCache
                                     translateLabel: true
                                     tabable: true
                                     model: flushSourceCache
                                     enableChannel: useManager
                                     extent: (Point 150 30)
                                   )
                                  (ActionButtonSpec
                                     label: 'Condense'
                                     name: 'Button5'
                                     activeHelpKey: condenseSourceCache
                                     translateLabel: true
                                     tabable: true
                                     model: condenseSourceCache
                                     enableChannel: useManager
                                     extent: (Point 150 30)
                                   )
                                  )

                               )
                             )
                            )

                         )
                         extent: (Point 660 136)
                       )
                      (ViewSpec
                         name: 'UseLocalSourceBox'
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'If Present, Use Local Source (Suppress Checkout)'
                               name: 'CheckBox4'
                               layout: (LayoutFrame 30 0 1 0 -5 1 29 0)
                               activeHelpKey: useLocalSources
                               enableChannel: useManager
                               model: localSourceFirst
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 660 32)
                       )
                      (ViewSpec
                         name: 'KeepMethodSourceBox'
                         activeHelpKey: keepMethodSourceInImage
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Keep Method Source (In Image)'
                               name: 'CheckBox7'
                               layout: (LayoutFrame 30 0 1 0 -5 1 29 0)
                               activeHelpKey: keepMethodSourceInImage
                               enableChannel: useManager
                               model: keepMethodSource
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 660 32)
                       )
                      (ViewSpec
                         name: 'CheckForHaltSendsBox'
                         activeHelpKey: checkClassesWhenCheckingIn
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Check for halt/error-Sends when Checking in'
                               name: 'CheckBox5'
                               layout: (LayoutFrame 30 0 1 0 -5 1 30 0)
                               activeHelpKey: checkClassesWhenCheckingIn
                               enableChannel: useManager
                               model: checkClassesWhenCheckingIn
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 660 32)
                       )
                      (ViewSpec
                         name: 'VerboseBox'
                         activeHelpKey: verboseSourceCodeAccess
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Verbose (Trace Operations on Transcript)'
                               name: 'CheckBox6'
                               layout: (LayoutFrame 30 0 1 0 -5 1 30 0)
                               activeHelpKey: verboseSourceCodeAccess
                               enableChannel: useManager
                               model: verboseSourceCodeAccess
                               translateLabel: true
                             )
                            )

                         )
                         extent: (Point 660 32)
                       )
                      )

                   )
                   extent: (Point 660 768)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl class methodsFor:'tableColumns specs'!

managerPerMatchingModuleColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:AbstractSettingsApplication::SourceCodeManagementSettingsAppl andSelector:#managerPerMatchingModuleColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Module (PackageID Match)'
         labelButtonType: Button
         width: 0.5
         model: displayStringForPackage
         menuFromApplication: false
         writeSelector: package:
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Repository Type'
         labelButtonType: Button
         width: 0.5
         model: displayStringForManagerTypeName
         menuFromApplication: false
         writeSelector: manager:
         canSelect: false
       )
      )

! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl methodsFor:'accessing'!

manager

    ^ Smalltalk at:#SourceCodeManager
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl methodsFor:'actions'!

actionAdd
    |dlg package mgr oldEntry idx|

    dlg := PerModuleManagerSettingDialog new.
    dlg open ifFalse:[ ^ self ].
    package := dlg package.
    mgr := dlg manager.
    oldEntry := managerPerMatchingModule
                detect:[:entry | entry package = package and:[ entry manager = mgr ] ]
                ifNone:nil.
    oldEntry notNil
        ifTrue:
            [ oldEntry manager:mgr.
            managerPerMatchingModule changed.
            idx := managerPerMatchingModule indexOf:oldEntry. ]
        ifFalse:
            [ managerPerMatchingModule
                add:(AbstractSourceCodeManager::PackageAndManager package:package manager:mgr).
            idx := managerPerMatchingModule size. ].
    selectedManagerPerMatchingModuleHolder value:idx.

    "Created: / 18-04-2011 / 19:30:46 / cg"
    "Modified: / 18-04-2011 / 21:24:52 / cg"
    "Modified: / 09-07-2011 / 14:07:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionEdit
    <resource: #uiCallback>

    | entry dlg |
    entry := managerPerMatchingModule at: selectedManagerPerMatchingModuleHolder value.
    dlg := PerModuleManagerSettingDialog new.
    dlg package: entry package.
    dlg manager: entry manager.
    dlg open ifTrue:[
        entry package: dlg package.
        entry manager: dlg manager.
        entry changed.
        self updateModifiedChannel.
    ]

    "Modified: / 29-03-2012 / 11:53:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionMoveDown
    <resource: #uiCallback>

    | idx |
    idx := selectedManagerPerMatchingModuleHolder value.
    idx == managerPerMatchingModule size ifTrue:[^self].
    managerPerMatchingModule swap: idx  with: idx + 1.
    selectedManagerPerMatchingModuleHolder value: idx + 1

    "Modified: / 09-07-2011 / 13:23:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionMoveUp
    <resource: #uiCallback>

    | idx |
    idx := selectedManagerPerMatchingModuleHolder value.
    idx == 1 ifTrue:[^self].
    managerPerMatchingModule swap: idx - 1 with: idx.
    selectedManagerPerMatchingModuleHolder value: idx - 1

    "Modified: / 09-07-2011 / 13:23:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

actionRemove
    |idx|

    idx := self selectedManagerPerMatchingModuleHolder value.
    managerPerMatchingModule removeIndex:idx.
    managerPerMatchingModule size >= idx
        ifTrue:[ selectedManagerPerMatchingModuleHolder value:idx. ]
        ifFalse:
            [ managerPerMatchingModule size >= (idx - 1)
                ifTrue:[ selectedManagerPerMatchingModuleHolder value:idx - 1. ]. ].

    "Created: / 18-04-2011 / 20:56:46 / cg"
!

actionTest
    <resource: #uiCallback>

    Tools::SourceCodeManagerConfigurationTestTool open

    "Modified: / 11-10-2011 / 08:52:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addModule:module withData:data
    (self listOfModules includes:module) ifFalse:[
        self listOfModules add:module; sort.
    ].
    rootsPerModule at:module put:data.

    self updateModifiedChannel.

    "Created: / 08-11-2006 / 19:25:21 / cg"
!

basicReadSettings
    self initialize.

    self verboseSourceCodeAccess value:(AbstractSourceCodeManager verboseSourceCodeAccess).
    self keepMethodSource value:(currentUserPrefs keepMethodSourceCode).

    self hasManager ifTrue:[
        self useManager value:(manager := Smalltalk at:#SourceCodeManager) notNil.
        self localSourceFirst value:Class tryLocalSourceFirst.
        self sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).

        manager notNil ifTrue:[
            manager forgetDisabledModules.
        ].
    ] ifFalse:[
        self useManager value:false.
        self localSourceFirst value:false.
    ].

    self managerPerMatchingModule removeAll.
    AbstractSourceCodeManager managerPerMatchingModuleDefinitions do:[:each |
        self managerPerMatchingModule add: each copy
    ].

    self availableManagers do:[:eachManager |
        |infoPerModule|

        infoPerModule := eachManager repositoryInfoPerModule.
        infoPerModule keysAndValuesDo:[:module :info |
            rootsPerModule at:module put:(Array with:eachManager with:info).
        ].
    ].

    self updateSelectedManager.

    self checkClassesWhenCheckingIn value:(currentUserPrefs at:#checkClassesWhenCheckingIn ifAbsent:true).

    rootsPerModule notNil ifTrue:[
        self listOfModules removeAll.
        listOfModules addAll:rootsPerModule keys asList.
    ].
"/    self selectedPerModuleRootChanged.

    "Modified: / 09-07-2011 / 14:00:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 12:36:19 / cg"
!

basicSaveSettings
    |modules|

    AbstractSourceCodeManager verboseSourceCodeAccess:(self verboseSourceCodeAccess value).
    currentUserPrefs at:#checkClassesWhenCheckingIn put:self checkClassesWhenCheckingIn value.
    Class tryLocalSourceFirst:self localSourceFirst value.
    currentUserPrefs keepMethodSourceCode:(self keepMethodSource value).

    (self hasManager and:[self useManager value]) ifTrue:[
        manager ~~ self selectedManager ifTrue:[
            manager := nil.
        ].

        manager isNil ifTrue:[
            manager := self selectedManager.
            manager isNil ifTrue:[
                manager := self availableManagers first.
            ].
        ].
        Smalltalk at:#SourceCodeManager put:manager.

        manager notNil ifTrue:[
            | nm fn|

            nm := self sourceCacheDir value.
            nm notEmptyOrNil ifTrue:[
                (fn := nm asFilename) exists ifFalse:[
                    (self confirm:('CVS cache directory ''' , nm , ''' does not exist\create ?' withCRs)) ifTrue:[
                        fn recursiveMakeDirectory;
                           makeReadableForAll;
                           makeWritableForAll;
                           makeExecutableForAll.
                    ]
                ].
                (fn isWritableDirectory and:[fn isReadable]) ifTrue:[
                    AbstractSourceCodeManager cacheDirectoryName:nm.
                ] ifFalse:[
                    self warn:'Invalid sourceCache directory.'
                ]
            ].
        ].

        AbstractSourceCodeManager
            managerPerMatchingModuleDefinitions:
                managerPerMatchingModule asOrderedCollection.

        self availableManagers do:[:eachManager |
            |infoPerModule|

            modules := rootsPerModule select:[:entry | entry first == eachManager].
            infoPerModule := Dictionary new.
            modules keysAndValuesDo:[:module :entry |
                entry first == eachManager ifTrue:[
                    infoPerModule at:module put:(entry second).
                ].
            ].
            eachManager repositoryInfoPerModule:infoPerModule.
        ].

        self sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).

        DebugView newDebugger. "/ ???
    ] ifFalse:[
        Smalltalk at:#SourceCodeManager put:nil
    ].

    self acceptChannel value.

    "Modified: / 09-07-2011 / 14:02:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 12:36:44 / cg"
!

browseSourceCache
    <resource: #uiCallback>

    |cacheDir|

    cacheDir := self sourceCacheDir value.
    cacheDir isNil ifTrue:[
        AbstractSourceCodeManager cachingSources ifTrue:[
            AbstractSourceCodeManager initCacheDirPath.
            cacheDir := self sourceCacheDir value.
            cacheDir isNil ifTrue:[
                Dialog information:'Failed to setup a default cache directory. Please enter manually'.
                ^ self.
            ].
        ] ifFalse:[
            (Dialog confirm:'No cache directory defined. Setup now?') ifTrue:[
                AbstractSourceCodeManager cachingSources:true.
                self browseSourceCache
            ].
        ].
    ].
    UserPreferences fileBrowserClass openOn:cacheDir

    "Modified: / 12-10-2011 / 11:11:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

condenseSourceCache
    self withWaitCursorDo:[ AbstractSourceCodeManager condenseSourceCache ].
    Method flushSourceStreamCache.

    "Modified: / 28-11-2006 / 12:21:33 / cg"
!

fillSourceCache
    |p|

    FillCacheProcess notNil ifTrue:[
        FillCacheProcess terminate
    ].
    FillCacheProcess := p :=
        [
            [
                Smalltalk allClasses do:[:eachClass |
                    eachClass source
                ]
            ] ensure:[
                (FillCacheProcess == p) ifTrue:[
                    FillCacheProcess := nil
                ]
            ].
        ] forkAt:(Processor systemBackgroundPriority)
!

flushSourceCache
    self withWaitCursorDo:[ AbstractSourceCodeManager flushSourceCache ].

    "Modified: / 30-09-2011 / 13:34:01 / cg"
!

removePerModuleRoot

    |module|

    acceptChannel value:true.
    module := self perModuleRootModule value.
    self listOfModules remove:module ifAbsent:nil.
    rootsPerModule removeKey:module ifAbsent:nil.
    self perModuleRootModule value:nil.
    self perModuleRoot value:nil.
    self updateModifiedChannel.
!

setupSourceCodeManager

   AbstractLauncherApplication::LauncherDialogs cvsConfigurationDialog.
   manager := (Smalltalk at:#SourceCodeManager).
   manager notNil ifTrue:[
        repositoryHolder value: manager repositoryName.
        sourceCacheDir value:(AbstractSourceCodeManager cacheDirectoryName).
   ].

    "Modified: / 16-08-2006 / 11:07:51 / cg"
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl methodsFor:'aspects'!

acceptChannel

    acceptChannel isNil ifTrue:[
        acceptChannel := TriggerValue new.
    ].
    ^ acceptChannel.
!

availableManagerTypeNames
    ^ self availableManagers collect:[:cls | cls managerTypeName].

    "Created: / 16-08-2006 / 11:16:25 / cg"
!

availableManagers
    availableManagers isNil ifTrue:[
        availableManagers := AbstractSourceCodeManager availableManagers copy.
        availableManagers := availableManagers sort:[:a :b | a managerTypeName asLowercase < b managerTypeName asLowercase].
    ].
    ^ availableManagers.

    "
     self basicNew availableManagers
    "

    "Created: / 16-08-2006 / 11:01:10 / cg"
    "Modified: / 18-04-2011 / 19:05:47 / cg"
!

canMoveDown
    ^ BlockValue
        with:
            [:sel |
            sel notNil
                and:[sel ~~ 0
                    and:[sel ~~ managerPerMatchingModule size]]]
        argument:(self selectedManagerPerMatchingModuleHolder)

    "Created: / 18-04-2011 / 20:52:48 / cg"
    "Created: / 09-07-2011 / 14:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canMoveUp
    ^ BlockValue
        with:
            [:sel |
            sel notNil
                and:[sel > 1]]
        argument:(self selectedManagerPerMatchingModuleHolder)

    "Created: / 18-04-2011 / 20:52:48 / cg"
    "Created: / 09-07-2011 / 14:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canRemoveManagerPerPackageEntry
    ^ BlockValue
        with:[:sel :use | sel notNil and:[sel ~~ 0 and:[use]] ]
        argument:(self selectedManagerPerMatchingModuleHolder)
        argument:(self useManager)

    "Created: / 18-04-2011 / 20:52:48 / cg"
!

checkClassesWhenCheckingIn

    checkClassesWhenCheckingIn isNil ifTrue:[
        checkClassesWhenCheckingIn := (currentUserPrefs at:#checkClassesWhenCheckingIn ifAbsent:true) asValue.
        checkClassesWhenCheckingIn onChangeSend:#updateModifiedChannel to:self
    ].
    ^ checkClassesWhenCheckingIn.
!

keepMethodSource

    keepMethodSource isNil ifTrue:[
        keepMethodSource := ValueHolder new.
        keepMethodSource onChangeSend:#updateModifiedChannel to:self
    ].
    ^ keepMethodSource.
!

listOfModules

    listOfModules isNil ifTrue:[
        rootsPerModule notNil ifTrue:[
            listOfModules := rootsPerModule keys asList.
        ].
        listOfModules sort.
        listOfModules onChangeSend:#updateModifiedChannel to:self
    ].
    ^ listOfModules.
!

localSourceFirst

    localSourceFirst isNil ifTrue:[
        localSourceFirst := ValueHolder new.
        localSourceFirst onChangeSend:#updateModifiedChannel to:self
    ].
    ^ localSourceFirst.
!

managerIsCVSSourceCodeManager
    managerIsCVSSourceCodeManager isNil ifTrue:[
        managerIsCVSSourceCodeManager := (SourceCodeManager notNil and:
                                         [SourceCodeManager isCVS]) asValue.
    ].
    ^ managerIsCVSSourceCodeManager.

    "Created: / 16-08-2006 / 10:56:38 / cg"
!

managerIsSmallTeamSourceCodeManager
    managerIsSmallTeamSourceCodeManager isNil ifTrue:[
        managerIsSmallTeamSourceCodeManager := (SourceCodeManager notNil and:
                                         [SourceCodeManager isSmallTeam]) asValue.
    ].
    ^ managerIsSmallTeamSourceCodeManager.

    "Created: / 09-11-2006 / 14:33:53 / cg"
!

managerIsStoreSourceCodeManager
    managerIsStoreSourceCodeManager isNil ifTrue:[
        managerIsStoreSourceCodeManager := (SourceCodeManager notNil and:
                                         [SourceCodeManager isStore]) asValue.
    ].
    ^ managerIsStoreSourceCodeManager.

    "Created: / 16-08-2006 / 10:57:13 / cg"
!

managerPerMatchingModule
    managerPerMatchingModule isNil ifTrue:[
        managerPerMatchingModule := List new.
        managerPerMatchingModule onChangeSend:#updateModifiedChannel to:self
    ].
    ^ managerPerMatchingModule.

    "Created: / 18-04-2011 / 20:44:54 / cg"
!

managerTypeIndexToAddHolder
    managerTypeIndexToAddHolder isNil ifTrue:[
        managerTypeIndexToAddHolder := ValueHolder new.
    ].
    ^ managerTypeIndexToAddHolder.

    "Created: / 18-04-2011 / 19:32:30 / cg"
!

managerTypeToAddHolder
    managerTypeToAddHolder isNil ifTrue:[
        managerTypeToAddHolder := ValueHolder new.
    ].
    ^ managerTypeToAddHolder.

    "Created: / 18-04-2011 / 19:34:11 / cg"
!

moreThanOneManagerTypesAvailable
    ^ self availableManagers size > 1

    "Created: / 16-08-2006 / 11:22:03 / cg"
!

packageToAddHolder
    packageToAddHolder isNil ifTrue:[
        packageToAddHolder := ValueHolder new.
    ].
    ^ packageToAddHolder.

    "Created: / 18-04-2011 / 19:32:39 / cg"
!

perModuleFieldsEnableHolder

    perModuleFieldsEnableHolder isNil ifTrue:[
        perModuleFieldsEnableHolder := true asValue.
        perModuleFieldsEnableHolder addDependent:self.
    ].
    ^ perModuleFieldsEnableHolder.
!

perModuleRoot
    perModuleRoot isNil ifTrue:[
        perModuleRoot := ValueHolder new.
        perModuleRoot addDependent:self.
    ].
    ^ perModuleRoot.
!

perModuleRootModule
    perModuleRootModule isNil ifTrue:[
        perModuleRootModule := ValueHolder new.
    ].
    ^ perModuleRootModule.
!

removeEnabled

    removeEnabled isNil ifTrue:[
        removeEnabled := false asValue.
    ].
    ^ removeEnabled.
!

selectedManager
    |idx availableManagers|

    availableManagers := self availableManagers.
    availableManagers size == 1 ifTrue:[
        ^ availableManagers anElement
    ].

    idx := self selectedManagerTypeIndexHolder value.
    (idx == 0 or:[idx isNil]) ifTrue:[ ^ nil].
    ^ availableManagers at:idx

    "Modified: / 16-08-2006 / 11:18:50 / cg"
!

selectedManagerPerMatchingModuleHolder
    selectedManagerPerMatchingModuleHolder isNil ifTrue:[
        selectedManagerPerMatchingModuleHolder := nil asValue.
        selectedManagerPerMatchingModuleHolder addDependent:self.
    ].
    ^ selectedManagerPerMatchingModuleHolder.

    "Created: / 18-04-2011 / 20:49:17 / cg"
!

selectedManagerTypeIndexHolder
    |selectedManager|

    selectedManagerTypeIndexHolder isNil ifTrue:[
        selectedManagerTypeIndexHolder := nil asValue.
        selectedManagerTypeIndexHolder onChangeEvaluate:[
            selectedManager := self selectedManager.
            self managerIsCVSSourceCodeManager value:( selectedManager notNil and:[ selectedManager isCVS] ).
            self managerIsStoreSourceCodeManager value:( selectedManager notNil and:[ selectedManager isStore] ).
            self managerIsSmallTeamSourceCodeManager value:( selectedManager notNil and:[ selectedManager isSmallTeam] ).
            self updateModifiedChannel
        ].

        self updateSelectedManager.
    ].
    ^ selectedManagerTypeIndexHolder.

    "Created: / 16-08-2006 / 11:17:20 / cg"
    "Modified: / 09-11-2006 / 14:34:54 / cg"
!

selectedPerModuleRoot
    selectedPerModuleRoot isNil ifTrue:[
        selectedPerModuleRoot := ValueHolder new.
        selectedPerModuleRoot addDependent:self.
    ].
    ^ selectedPerModuleRoot.
!

sourceCacheDir
    sourceCacheDir isNil ifTrue:[
        sourceCacheDir := ValueHolder new.
        sourceCacheDir onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sourceCacheDir.
!

useManager
    useManager isNil ifTrue:[
        useManager := ValueHolder new.
        useManager onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useManager.
!

verboseSourceCodeAccess
    verboseSourceCodeAccess isNil ifTrue:[
        verboseSourceCodeAccess := false asValue.
        verboseSourceCodeAccess onChangeSend:#updateModifiedChannel to:self
    ].
    ^ verboseSourceCodeAccess.
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl methodsFor:'change & update'!

selectedPerModuleRootChanged
    |module entry firstEntry
     removeEnabled perModuleRootModule perModuleRoot|

    self acceptChannel value:true.
    module := self selectedPerModuleRoot value.
    module isNil ifTrue:[
        removeEnabled := false.
        perModuleRootModule := ' '.
        perModuleRoot := ''.
    ] ifFalse:[
        entry := rootsPerModule at:module ifAbsent:#().
        firstEntry := entry first.
        (firstEntry = CVSSourceCodeManager) ifTrue:[
            removeEnabled := true.
            perModuleRootModule := module.
            perModuleRoot := (entry at:2).
        ] ifFalse:[
            removeEnabled := false.
            perModuleRootModule := module , ' ',('<<use ',firstEntry managerTypeName,'>>') allBold.
            perModuleRoot := ''.
        ].
    ].

    self removeEnabled value:removeEnabled.
    self perModuleRootModule value:perModuleRootModule.
    self perModuleRoot value:perModuleRoot.
!

sourceDirChanged
    |nm fn previousDir|

    manager isNil ifTrue:[^ self].

    previousDir := AbstractSourceCodeManager cacheDirectoryName.

    nm := self sourceCacheDir value.
    nm isEmptyOrNil ifTrue:[^ self].

    (fn := nm asFilename) exists ifFalse:[
        (self confirm:(resources
                            stringWithCRs:'SourceCache directory "%1" does not exist.\Create ?'
                            with:nm)
        ) ifFalse:[
            self sourceCacheDir value:previousDir.
            ^ self.
        ].
        fn
            recursiveMakeDirectory;
            makeReadableForAll;
            makeWritableForAll;
            makeExecutableForAll.
        ^ self.
    ].

    (fn isDirectory) ifFalse:[
        self warn:(resources
                            stringWithCRs:'Not a directory: "%1"'
                            with:nm).
        self sourceCacheDir value:previousDir.
        ^ self.
    ].

    (fn isWritableDirectory and:[fn isReadable]) ifFalse:[
        (self confirm:(resources
                            stringWithCRs:'SourceCache directory "%1" is not both readable and writable.\Change ?'
                            with:nm)
        ) ifFalse:[
            self sourceCacheDir value:previousDir.
            ^ self.
        ].
        fn
            makeReadableForAll;
            makeWritableForAll;
            makeExecutableForAll.
    ].
"/    (fn isReadableForAll and:[fn isWritableForAll]) ifFalse:[
"/        (self confirm:(resources
"/                            stringWithCRs:'SourceCache directory "%1" is not both readable and writable for other users.\Change ?'
"/                            with:nm)
"/        ) ifTrue:[
"/            fn
"/                makeReadableForAll;
"/                makeWritableForAll;
"/                makeExecutableForAll.
"/        ]
"/    ].
!

update:something with:aParameter from:changedObject
    |idx entry|

    changedObject == sourceCacheDir ifTrue:[
        self sourceDirChanged.
        self updateModifiedChannel.
        ^ self
    ].

    changedObject == selectedManagerPerMatchingModuleHolder ifTrue:[
        idx := changedObject value.
        (idx notNil and:[idx ~~ 0]) ifTrue:[
            entry := self managerPerMatchingModule at:idx.
            self packageToAddHolder value:(entry package).
            self managerTypeToAddHolder value:(entry managerTypeName).
        ].
        ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 18-04-2011 / 21:23:08 / cg"
    "Modified: / 09-07-2011 / 14:07:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelectedManager
    |selectedManagerTypeIndex availableManagers|

    availableManagers := self availableManagers.

    selectedManagerTypeIndex := availableManagers indexOf:SourceCodeManager.
    selectedManagerTypeIndex == 0 ifTrue:[
        availableManagers size == 1 ifTrue:[
            selectedManagerTypeIndex := 1.
        ].
    ].
    self selectedManagerTypeIndexHolder value:selectedManagerTypeIndex.
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_SourceCodeManagerSettings'
!

helpFilename
    ^ 'Launcher/sourceRepositorySetup.html'

    "Modified: / 04-07-2011 / 17:22:39 / cg"
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl methodsFor:'initialization & release'!

initialize
    (AbstractSourceCodeManager notNil) ifTrue:[ AbstractSourceCodeManager autoload ].

    managerTypePerModule := Dictionary new.

    useManager := false asValue.
    useManager onChangeSend:#updateModifiedChannel to:self.

    sourceCacheDir := nil asValue.
    sourceCacheDir addDependent:self.

    repositoryHolder := '' asValue.
    rootsPerModule := Dictionary new.

    self availableManagers do:[:eachManager |
        eachManager repositoryInfoPerModule
            keysAndValuesDo:[:module :info |
                module withoutSeparators ~= module ifTrue:[
                    self halt:'should not happen any longer'
                ].
                rootsPerModule at:module put:(Array with:eachManager with:info)
            ].
    ].

    super initialize.

    "Modified: / 18-04-2011 / 19:37:38 / cg"
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl methodsFor:'queries'!

cvsRootFromCVSRootFileOrNil
    |cvsDir cvsRootFile cvsRoot|

    cvsDir := 'CVS' asFilename.
    cvsDir isDirectory ifTrue:[
        cvsRootFile := cvsDir construct:'Root'.
        cvsRootFile isReadable ifTrue:[
            cvsRoot := cvsRootFile contents firstIfEmpty:nil.
        ].
    ].
    ^ cvsRoot
!

hasManager
    "true if ANY source code management class is available"

    ^ AbstractSourceCodeManager notNil and:[AbstractSourceCodeManager isLoaded]
!

hasUnsavedChanges
    (self useManager value ~= ((Smalltalk at:#SourceCodeManager) notNil)) ifTrue:[^ true].
    (Smalltalk at:#SourceCodeManager) ~~ self selectedManager ifTrue:[^ true].
    (self hasManager and:[self useManager value]) ifFalse:[^ false].

    (Class tryLocalSourceFirst ~= self localSourceFirst value) ifTrue:[^ true].
    ((self selectedManager cacheDirectoryName ? '') ~= (self sourceCacheDir value ? '')) ifTrue:[^ true].

    ((currentUserPrefs at:#checkClassesWhenCheckingIn ifAbsent:true) ~= self checkClassesWhenCheckingIn value)
        ifTrue:[^ true].

    ((currentUserPrefs keepMethodSourceCode) ~= self keepMethodSource value)
        ifTrue:[^ true].

    ((AbstractSourceCodeManager managerPerMatchingModuleDefinitions)
        ~= (self managerPerMatchingModule asOrderedCollection)) ifTrue:[^ true].

    (AbstractSourceCodeManager verboseSourceCodeAccess
        ~= self verboseSourceCodeAccess value) ifTrue:[^ true].

    self availableManagers do:[:mgr |
        |modules|

        modules := rootsPerModule select:[:entry | entry first == mgr].

        mgr repositoryInfoPerModule keysAndValuesDo:[:module :info |
            ((modules includesKey:module) and:[info = (modules at:module) second])
            ifFalse:[^ true].
        ].
        modules keysAndValuesDo:[:module :info|
            ((mgr repositoryInfoPerModule includesKey:module) and:[(mgr repositoryInfoPerModule at:module) = info second])
            ifFalse:[^ true].
        ].
    ].

    ^ false

    "Modified: / 09-07-2011 / 14:09:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 12:35:40 / cg"
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#manager
'Specify the source code manager which will be used for packages matching the above pattern'

#packageMatchPattern
'Specify a matchpattern. Packages matching this pattern will be managed by the source code manager below'

)

    "Created: / 01-12-2011 / 19:52:19 / cg"
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog andSelector:#windowSpec
     AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog new openInterface:#windowSpec
     AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Per Module Source Code Manager'
         name: 'Per Module Source Code Manager'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 581 98)
       )
       component:
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Content'
             layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
             component:
            (SpecCollection
               collection: (
                (ComboBoxSpec
                   name: 'ComboBox1'
                   layout: (LayoutFrame 216 0 9 0 -2 1 31 0)
                   activeHelpKey: packageMatchPattern
                   enableChannel: useManager
                   model: packageHolder
                   comboList: samplePackageList
                 )
                (LabelSpec
                   label: 'Package ID (Matchpattern):'
                   name: 'Label15'
                   layout: (LayoutFrame 9 0 9 0 214 0 31 0)
                   activeHelpKey: packageMatchPattern
                   translateLabel: true
                   adjust: right
                 )
                (LabelSpec
                   label: 'Manager:'
                   name: 'Label16'
                   layout: (LayoutFrame 9 0 37 0 214 0 59 0)
                   activeHelpKey: manager
                   translateLabel: true
                   adjust: right
                 )
                (ComboListSpec
                   name: 'ComboList2'
                   layout: (LayoutFrame 216 0 39 0 -2 1 61 0)
                   activeHelpKey: manager
                   model: managerNameHolder
                   comboList: availableManagerTypeNames
                   useIndex: false
                   hidePullDownMenuButton: true
                 )
                )

             )
           )
          (HorizontalPanelViewSpec
             name: 'Buttons'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component:
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'Button2'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 289 22)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'Button1'
                   translateLabel: true
                   model: doAccept
                   enableChannel: doAcceptEnabled
                   extent: (Point 289 22)
                 )
                )

             )
             keepSpaceForOSXResizeHandleH: true
           )
          )

       )
     )
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog methodsFor:'accessing'!

manager

    | m mn|
    mn := self managerNameHolder value.
    m := self availableManagers detect:[:mgr | mgr managerTypeName = mn] ifNone:nil.
    ^m

    "Created: / 09-07-2011 / 13:07:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

manager: aSourceCodeManager

    self managerNameHolder value: aSourceCodeManager managerTypeName

    "Created: / 09-07-2011 / 13:02:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package

    ^self packageHolder value

    "Created: / 09-07-2011 / 13:06:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package: aString

    self packageHolder value: aString

    "Created: / 09-07-2011 / 13:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::SourceCodeManagementSettingsAppl::PerModuleManagerSettingDialog methodsFor:'aspects'!

availableManagerTypeNames
    ^ self availableManagers collect:[:cls | cls managerTypeName].

    "Created: / 16-08-2006 / 11:16:25 / cg"
!

availableManagers
    availableManagers isNil ifTrue:[
        availableManagers := AbstractSourceCodeManager availableManagers copy.
        availableManagers := availableManagers sort:[:a :b | a managerTypeName asLowercase < b managerTypeName asLowercase].
    ].
    ^ availableManagers.

    "
     self basicNew availableManagers
    "

    "Created: / 16-08-2006 / 11:01:10 / cg"
    "Modified: / 18-04-2011 / 19:05:47 / cg"
!

doAcceptEnabled
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#doAcceptEnabled) isNil ifTrue:[
        holder := BlockValue
            with:
                [:package :manager|
                package value notEmptyOrNil  and:[manager value notNil]]
            argument: self packageHolder
            argument: self managerHolder.

        builder aspectAt:#doAcceptEnabled put:holder.
    ].
    ^ holder.

    "Modified: / 09-07-2011 / 13:00:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerHolder
    <resource: #uiAspect>

    managerNameHolder isNil ifTrue:[
        managerNameHolder := ValueHolder new.
    ].
    ^ managerNameHolder.

    "Modified (comment): / 03-12-2011 / 11:30:58 / cg"
!

managerNameHolder
    <resource: #uiAspect>

    managerNameHolder isNil ifTrue:[
        managerNameHolder := ValueHolder new.
    ].
    ^ managerNameHolder.

    "Created: / 09-07-2011 / 13:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-12-2011 / 11:30:45 / cg"
!

packageHolder
    <resource: #uiAspect>

    packageHolder isNil ifTrue:[
        packageHolder := ValueHolder new.
    ].
    ^ packageHolder.

    "Modified (comment): / 03-12-2011 / 11:30:51 / cg"
!

samplePackageList
    <resource: #uiAspect>

    |modules|

    modules := Smalltalk allPackageIDs
                collect:[:packageId | packageId asPackageId module ]
                as:Set.

    modules remove:(PackageId noProjectID) ifAbsent:[].
    modules := modules collect:[:packageId | packageId , ':*' ].
    ^ modules asSortedCollection

    "Created: / 12-03-2012 / 11:35:40 / cg"
    "Modified: / 13-03-2012 / 13:12:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::StyleSettingsAppl class methodsFor:'defaults'!

standardStyles
    "only those are presented initially"

    ^  #(
        'adwaita'
        "/ 'decWindows'
        'iris'
        'macosx'
        'macosx_yosemite'
        'motif'
        'mswindows8'
        'mswindows95'
        'mswindowsXP'
        'mswindowsxp'
        'mswindowsVista'
        'mswindowsvista'
        'napkin'
        "/ 'next'
        "/ 'normal'
        "/ 'os2'
        'sgmotif'
        "/ 'st80'
       )
! !

!AbstractSettingsApplication::StyleSettingsAppl class methodsFor:'image specs'!

closePreviewButtonImage
      ^ ToolbarIconLibrary removeTabIcon
!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::StyleSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@DA@@@@@@@@@@@@@@@@@@@@@@@@@@DB@ D@@@@@@@@@@@@@@@@@@@@@@@DB@ HB@P@@@@@@@@@@@@@@@@@@@@DCA@HB@ DA@@@@@@@@@@@@
@@@@@@TC@0LD@ XF@PD@@@@@@@@@@@@@@@TC@0LC@0PFA PD@P@@@@@@@@@@@@TC@0LC@0LCA@XGA@PA@@@@@@@@@@TC@0LC@0LC@0LHA@PHB@D@@@@@@@TC
@0LC@0LC@0LC@0 HB@HC@P@@@@@@APLC@0LC@0LC@0LCB@HC@0LI@@@JB (JB (JB (JB (JB (HB0LE@@@@B 0CCP4NC1@PDQHL@0LJ@0 E@@@@@@(L@04M
C <PDADRC@LCB LE@@@@@@@JD1LSD1LTEAPUEQTUEP(E@@@@@@@@AP0LC@0LC@0LC@0VE!!XE@@@@@@@@@@TLC@0LC@0LC@0LE!!XVAP@@@@@@@@@EC@0LC@0L
C@0LE!!XVE T@@@@@@@@@AP0LC@0LC@0LCAXVE!!XE@@@@@@@@@@TLC@0LC@0LC@0VE!!XVAP@@@@@@@@@EC@0LC@0LC@0LE!!XVE T@@@@@@@@@AP0LC@0LC@0L
E!!XVE!!XE@@@@@@@@@@TEAPTEAPTEAPTEAPTEAP@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 76 76 80 120 118 120 192 192 190 76 78 80 80 80 80 92 94 90 104 102 100 68 66 70 88 86 90 0 80 130 128 128 130 240 240 240 16 144 190 16 128 180 16 128 160 0 112 160 0 112 140 0 96 140 16 112 140 0 96 130 0 80 110 224 224 220]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@C@@@G @@O0@@_8@@?<@A?>@C??@G?? O??0G??8_??0_?? _??@_?>@_?<@_?<@_?<@_?<@_?<@_?<@_?<@_?<@') ; yourself); yourself]
! !

!AbstractSettingsApplication::StyleSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::StyleSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::StyleSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::StyleSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'ViewStyle Selection'
         name: 'ViewStyle Selection'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 562 661)
       )
       component:
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 -65 1)
             component:
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Box1'
                   component:
                  (SpecCollection
                     collection: (
                      (TextEditorSpec
                         name: 'TextEditor1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         style: (FontDescription arial medium roman 9)
                         model: noticeLabelHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                         postBuildCallback: postBuildHelpLabel:
                         viewClassName: 'TextView'
                       )
                      )

                   )
                 )
                (ViewSpec
                   name: 'Box2'
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         horizontalLayout: fit
                         verticalLayout: topFit
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'Box4'
                               component:
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'standard styles only'
                                     name: 'CheckBox1'
                                     layout: (LayoutFrame 0 0 0 0 -150 1 0 1)
                                     model: showStandardStylesOnly
                                     translateLabel: true
                                   )
                                  (CheckBoxSpec
                                     label: 'Preview'
                                     name: 'CheckBox2'
                                     layout: (AlignmentOrigin 0 1 17 0 1 0.5)
                                     model: previewVisibleHolder
                                     translateLabel: true
                                   )
                                  )

                               )
                               extent: (Point 562 35)
                             )
                            (SequenceViewSpec
                               name: 'StyleList'
                               model: selectedStyle
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               doubleClickSelector: doubleClickAt:
                               useIndex: false
                               sequenceList: styleList
                               extent: (Point 562 334)
                             )
                            )

                         )
                       )
                      )

                   )
                 )
                )

             )
             handles: (Any 0.37 1.0)
           )
          (ViewSpec
             name: 'Box3'
             layout: (LayoutFrame 0 0 -65 1 0 1 0 1)
             component:
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Label'
                   name: 'Label1'
                   layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                   translateLabel: true
                   labelChannel: infoLabelHolder
                   resizeForLabel: true
                   adjust: left
                 )
                )

             )
           )
          (LabelSpec
             label: 'Preview'
             name: 'PreviewLabel'
             layout: (LayoutFrame 29 0 39 0 129 0 61 0)
             level: 0
             borderWidth: 1
             visibilityChannel: previewVisibleHolder
             backgroundColor: (Color 87.0 87.0 87.0)
             translateLabel: true
           )
          (NonScrollableArbitraryComponentSpec
             name: 'Preview'
             layout: (LayoutFrame 27 0 63 0 444 0 240 0)
             level: 1
             visibilityChannel: previewVisibleHolder
             hasBorder: false
             component: ImageView
           )
          (ActionButtonSpec
             label: 'closePreviewButtonImage'
             name: 'ClosePreviewButton'
             layout: (LayoutFrame 423 0 41 0 443 0 63 0)
             visibilityChannel: previewVisibleHolder
             hasCharacterOrientedLabel: false
             translateLabel: true
             model: closePreview
           )
          )

       )
     )
! !

!AbstractSettingsApplication::StyleSettingsAppl methodsFor:'actions'!

basicReadSettings
    "nothing done here"
!

basicSaveSettings
    |newStyle|

    newStyle := self selectedStyle value asSymbol.

    self withWaitCursorDo:[
        Transcript showCR:'Change style to ' , newStyle , ' ...'.
        View defaultStyle:newStyle.
        currentUserPrefs viewStyle:newStyle.
        currentUserPrefs fontPreferencesChanged. "/ force into class defaults
    ].
    self reopenToolsAfterChangedViewStyleSetting.

    "Modified: / 24-11-2016 / 18:02:04 / cg"
!

closePreview
    self previewVisibleHolder value:false.
!

doubleClickAt:aLine

    self saveSettings.
! !

!AbstractSettingsApplication::StyleSettingsAppl methodsFor:'aspects'!

infoLabelHolder

    infoLabelHolder isNil ifTrue:[
        infoLabelHolder := '' asValue.
    ].
    ^ infoLabelHolder.
!

noticeLabelHolder

    noticeLabelHolder isNil ifTrue:[
        noticeLabelHolder := '' asValue.
    ].
    ^ noticeLabelHolder.
!

previewVisibleHolder

    previewVisibleHolder isNil ifTrue:[
        previewVisibleHolder := false asValue.
        previewVisibleHolder onChangeSend:#changeInfoLabel to:self.
    ].
    ^ previewVisibleHolder.
!

selectedStyle

    selectedStyle isNil ifTrue:[
        selectedStyle := ValueHolder new.
        selectedStyle addDependent:self.
    ].
    ^ selectedStyle.
!

showStandardStylesOnly

    showStandardStylesOnly isNil ifTrue:[
        showStandardStylesOnly := true asValue.
        showStandardStylesOnly addDependent:self.
    ].
    ^ showStandardStylesOnly.
!

styleList

    styleList isNil ifTrue:[
        styleList := List new.
        styleList addDependent:self.
    ].
    ^ styleList.
! !

!AbstractSettingsApplication::StyleSettingsAppl methodsFor:'change & update'!

changeInfoLabel
    |nm sheet comment previewFile previewImage imgView labelView|

    comment := ''.
    nm := self selectedStyle value.
    nm notNil ifTrue:[
        sheet := ViewStyle fromFile:(nm , '.style').
        comment := (sheet at:#comment ifAbsent:'') withoutSeparators.
        previewFile := sheet at:#previewFileName ifAbsent:nil.
    ].
    comment := comment withCRs asStringCollection.
    comment size == 1 ifTrue:[
        comment := comment first
    ].
    self infoLabelHolder value:comment.

    self previewVisibleHolder value ifTrue:[
        self builder notNil ifTrue:[
            labelView := self componentAt:#PreviewLabel.
            imgView := (self componentAt:#Preview).

            previewFile notEmptyOrNil ifTrue:[
                previewImage := Image fromFile:'../../doc/online/pictures' asFilename / previewFile.
            ].
            previewImage notNil ifTrue:[
                labelView label:'Preview'.
                imgView adjust:#fitBig; image:previewImage.
            ] ifFalse:[
                labelView label:'Sorry - no preview available'.
                imgView image:nil.
            ].
            labelView forceResizeHorizontally.
        ]
    ]
!

update:something with:aParameter from:changedObject
    changedObject == self showStandardStylesOnly ifTrue:[
        self updateList.
        ^ self
    ].
    changedObject == self selectedStyle ifTrue:[
        self changeInfoLabel.
        self updateModifiedChannel.
        ^ self
    ].
    super
        update:something
        with:aParameter
        from:changedObject
!

updateList

    |listOfStyles lastSelection|

    lastSelection := self selectedStyle value.
    listOfStyles := styleDirectoryContents select:[:aFileName | aFileName asFilename hasSuffix:'style'].
    listOfStyles := listOfStyles collect:[:aFileName | aFileName asFilename nameWithoutSuffix].
"/    Filename isCaseSensitive ifFalse:[
"/        listOfStyles := listOfStyles collect:[:aStyleName | aStyleName asLowercase].
"/    ].
    listOfStyles remove:'generic' ifAbsent:nil; remove:'mswindows3' ifAbsent:nil.
    self showStandardStylesOnly value ifTrue:[
        listOfStyles := listOfStyles select:[:aStyleName | self class standardStyles includes:aStyleName asLowercase].
    ].

    listOfStyles sort.
    self styleList contents:listOfStyles.
    self selectedStyle value:lastSelection.

    "Modified: / 06-02-2014 / 14:58:34 / cg"
! !

!AbstractSettingsApplication::StyleSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/styleSettings.html'
! !

!AbstractSettingsApplication::StyleSettingsAppl methodsFor:'initialization & release'!

commonPostBuild
    super commonPostBuild.
    self changeInfoLabel
!

initialize

    |someRsrcFile resourceDir|

    super initialize.

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
        resourceDir isNil ifTrue:[
            self warn:'no styles found (missing ''resources'' directory)'.
            ^ self
        ].
    ].

    [
        styleDirectoryContents := resourceDir asFilename directoryContents.
    ] on:FileStream openErrorSignal do:[:ex|
        self warn:'no styles found (unaccessible ''resources'' directory)'.
        ^ self
    ].

    self updateList.
    (self class standardStyles includes:View defaultStyle asLowercase) ifFalse:[
        self showStandardStylesOnly value:false
    ].
    self selectedStyle value:(View defaultStyle).
    self noticeLabelHolder value:(resources at:'STYLE_MSG' default:'Select a Style') withCRs.
!

postBuildHelpLabel:aWidget
    aWidget level:0.
    aWidget scrolledView backgroundColor:self window viewBackground.
! !

!AbstractSettingsApplication::StyleSettingsAppl methodsFor:'queries'!

hasUnsavedChanges

    ^  (self selectedStyle value ~= View defaultStyle)
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl class methodsFor:'defaults'!

emphasisList
    ^ self emphasisMappingList collect:#first
!

emphasisMappingList
    "self emphasisMappingList"

    ^ {
        #( #'normal'                 #normal ) .
        #( #'underline'              #underline) .
         { 'red underline' .        { #underline . (#underlineColor->Color red) } } .
        #( #'underwave'              #underwave) .
         { 'red underwave' .        { #underwave . (#underlineColor->Color red) } } .
        #( #'bold'                   #bold ) .
        #( 'bold + underline'       #(bold underline) ) .
         { 'bold + red underline' . { #bold . #underline . (#underlineColor->Color red) } } .
        #( 'bold + underwave'       #(bold underwave) ) .
         { 'bold + red underwave' . { #bold . #underwave . (#underlineColor->Color red) } } .
        #( #'italic'                 #italic ) .
        #( 'italic + underline'     #(italic underline) ) .
         { 'italic + red underline'. { #italic . #underline . (#underlineColor->Color red) } } .
        #( 'italic + underwave'     #(italic underwave) ) .
         { 'italic + red underwave'. { #italic . #underwave . (#underlineColor->Color red) } } .
        #( #'reverse'                #reverse )
    }
!

exampleText

    ^  'methodSelector:methodArg
    "method comment: some stupid code to show the current settings"

    |methodVar|  "/ an end-of-line comment...

    self at:methodArg.        "/ a message
    self fooBarBaz:methodVar. "/ a bad message
    self halt.                "/ a debug message
    Error raise.              "/ an error
    methodVar := Array new:1.
    instVar := 1234.          "/ side effect
    ClassVar := instVar.      "/ side effect
    methodVar := ClassVar + instVar.    "/ not a side effect
    unknonVar := 1.           "/ a bad variable
    UnknonVar := 1.           "/ another bad variable
    "self bar:methodVar.  detect commented code easily"
    1 to:5 do:[:i | self at:i + 1].
    [:blockArg | blockArg + 1].
    Transcript showCR:''some string'' , #someSymbol.
    ^ self.
'.

    "Modified: / 14-02-2012 / 10:18:48 / cg"
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::SyntaxColorSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#colorSelection
'Choose a color for the selected element type'

#commonStyleSelection
'Choose a common style, then change by clicking on the "Reset To" button'

#elementSelection
'Select the element which you want to define/modify'

#emphasisSelection
'Choose a presentation style for the selected element type'

#immediateSelectorCheck
'If checked, the code is immediately checked for valid message selectors (on each key).\This may slow down editing a bit'

#resetToCommonStyle
'Press to reset to the selected common style'

#syntaxColoringEnabled
'If checked, syntax coloring is enabled'

#individualStyleSetting
'Personal style configuration'

#commonStyleSetting
'Choose a common style'

#sampleOutput
'Shows a piece of code emphasized as specified in color/emphasis settings'

)

    "Created: / 14-02-2012 / 10:44:21 / cg"
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons"

    ^ Icon
        constantNamed:#'AbstractSettingsApplication::SyntaxColorSettingsAppl class defaultIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray
                            fromPackedString:'
DQDQDQDQDQDQDQDTQDQDQDQDQDQDPQQ@QDADQBP$QDP!!E@QDQ@QDIBQDP$DTADQDADQDQDQBPQPDQDPDQDQDQBQAE@QDQ@QDQDQDIDDTADQDADQDQDIDPQPD
QDPDQDQDP$QAEDADPDQDQDP$QDDTQDQDQDQDQDQDPQQDADQDQDQDQDQAEDADQDQDQDQDQDDTPDQ@QDADQDQDPQP@A@PDA@Q@QDQAEDADA@PDADQDQDDTPDPD
A@PDQDQDPQQ@QDADPDQ@QDQAEDQDQDQDQDQDQDDTMCP4MCP4QDQDPQQCP4MCP4MDQDQADQDQDQDQDQDQDQDb');
                colorMapFromArray:#[ 0 0 0 88 88 88 0 0 255 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray
                                        fromPackedString:'???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<???<');
                            yourself);
                yourself
        ]
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::SyntaxColorSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::SyntaxColorSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::SyntaxColorSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Syntax Color Settings'
         name: 'Syntax Color Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 695 609)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: topSpaceFit
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Syntax Coloring'
                   name: 'CheckBox1'
                   activeHelpKey: syntaxColoringEnabled
                   model: syntaxColoring
                   translateLabel: true
                   extent: (Point 695 30)
                 )
                (CheckBoxSpec
                   label: 'Immediate Selector Check'
                   name: 'ImmediateSelectorCheckBox'
                   activeHelpKey: immediateSelectorCheck
                   enableChannel: syntaxColoring
                   model: fullSelectorCheck
                   translateLabel: true
                   extent: (Point 695 30)
                 )
                (ViewSpec
                   name: 'SpacingBox2'
                   extent: (Point 695 10)
                 )
                (LabelSpec
                   label: 'Style:'
                   name: 'Label5'
                   activeHelpKey: individualStyleSetting
                   translateLabel: true
                   adjust: left
                   extent: (Point 695 30)
                 )
                (ViewSpec
                   name: 'ElementSelectionBox'
                   activeHelpKey: elementSelection
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Element:'
                         name: 'Label4'
                         layout: (LayoutFrame 4 0 0 0 140 0 30 0)
                         activeHelpKey: elementSelection
                         translateLabel: true
                         adjust: right
                       )
                      (ComboListSpec
                         name: 'ComboList3'
                         layout: (LayoutFrame 140 0 0 0 0 1 30 0)
                         activeHelpKey: elementSelection
                         enableChannel: syntaxColoring
                         model: syntaxElementSelection
                         comboList: syntaxElementList
                         useIndex: false
                         hidePullDownMenuButton: false
                       )
                      )

                   )
                   extent: (Point 695 34)
                 )
                (ViewSpec
                   name: 'ColorBox'
                   activeHelpKey: colorSelection
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Color:'
                         name: 'Label2'
                         layout: (LayoutFrame 4 0 0 0 140 0 30 0)
                         activeHelpKey: colorSelection
                         translateLabel: true
                         adjust: right
                       )
                      (ColorMenuSpec
                         name: 'ColorMenu2'
                         layout: (LayoutFrame 140 0 0 0 0 1 30 0)
                         activeHelpKey: colorSelection
                         enableChannel: syntaxColoring
                         model: syntaxColor
                         labelsAreColored: true
                       )
                      )

                   )
                   extent: (Point 695 34)
                 )
                (ViewSpec
                   name: 'EmphasisBox'
                   activeHelpKey: emphasisSelection
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Emphasis:'
                         name: 'Label1'
                         layout: (LayoutFrame 4 0 0 0 140 0 30 0)
                         activeHelpKey: emphasisSelection
                         translateLabel: true
                         adjust: right
                       )
                      (ComboListSpec
                         name: 'ComboList5'
                         layout: (LayoutFrame 140 0 0 0 0 1 30 0)
                         activeHelpKey: emphasisSelection
                         enableChannel: syntaxColoring
                         model: syntaxEmphasisSelection
                         comboList: syntaxEmphasisList
                         useIndex: false
                         hidePullDownMenuButton: false
                       )
                      )

                   )
                   extent: (Point 695 34)
                 )
                (ViewSpec
                   name: 'ResetBox'
                   activeHelpKey: resetToCommonStyle
                   component:
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Reset To:'
                         name: 'Button2'
                         layout: (LayoutFrame 0 0 -36 1 150 0 -6 1)
                         activeHelpKey: resetToCommonStyle
                         translateLabel: true
                         model: resetToColorScheme
                         enableChannel: syntaxColoring
                       )
                      (ComboListSpec
                         name: 'ComboList4'
                         layout: (LayoutFrame 152 0 -36 1 0 1 -6 1)
                         activeHelpKey: commonStyleSelection
                         enableChannel: syntaxColoring
                         model: resetListSelection
                         comboList: resetList
                         useIndex: false
                         hidePullDownMenuButton: false
                       )
                      )

                   )
                   extent: (Point 695 40)
                 )
                (ViewSpec
                   name: 'SpacingBox1'
                   extent: (Point 695 10)
                 )
                (LabelSpec
                   label: 'Sample Output:'
                   name: 'SampleLabel3'
                   activeHelpKey: sampleOutput
                   translateLabel: true
                   adjust: left
                   extent: (Point 695 30)
                 )
                (TextEditorSpec
                   name: 'TextEditor2'
                   activeHelpKey: sampleOutput
                   enableChannel: syntaxColoring
                   model: coloredText
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   isReadOnly: true
                   hasKeyboardFocusInitially: false
                   extent: (Point 695 291)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl methodsFor:'actions'!

aspects
    ^ #(
        syntaxColoring
        fullSelectorCheck
    )
!

basicReadSettings
    |elementColorList elementList resetListLoc|

    oldUserPreferences notNil ifTrue:[
        (UserPreferences reset; current) addAll:oldUserPreferences
    ].

    super basicReadSettings.

    oldUserPreferences := currentUserPrefs copy.
    elementColorList := UserPreferences syntaxColorNames.
    elementList := elementColorList
                        collect:[:each |
                            (each endsWith:' Color')
                                ifTrue:[ each copyButLast:' Color' size ]
                                ifFalse:[each]].

    resetListLoc := currentUserPrefs listOfPredefinedSyntaxColoringSchemes
                        collect:[:entry | entry second].
    self resetList value:resetListLoc.
    self resetListSelection value:resetListLoc first.
    self syntaxElementList value:elementList.
    self syntaxElementSelection value:(elementList at:1).
!

basicSaveSettings

    oldUserPreferences := currentUserPrefs copy.
    super basicSaveSettings.
!

discardChangesAndReadSettings
    |prefs|

    "/ UserPreferences reset.
    prefs := currentUserPrefs. "/ UserPreferences current.
    changedSettings keysAndValuesDo:[:k :v |
        prefs at:k put:v
    ].
    changedSettings := Dictionary new.
    "/ self flyByHelpSettingChanged.    "/ reinstall
    self recolor.
    super discardChangesAndReadSettings.
!

recolor
    |text dummyClass|

    self syntaxColoring value ifTrue:[
        Class withoutUpdatingChangesDo:[
            dummyClass := Object
                            subclass:#DummyClass
                            instanceVariableNames:'instVar'
                            classVariableNames:'ClassVar'
                            poolDictionaries:''
                            category:''
                            inEnvironment:nil
        ].
        text := SyntaxHighlighter
                    formatMethod:self class exampleText
                    in:dummyClass
                    using:currentUserPrefs.
    ] ifFalse:[
        text := self class exampleText.
    ].
    self coloredText value:text

    "Modified: / 14-02-2012 / 10:13:56 / cg"
!

resetToColorScheme
    |resetSelector|

    resetSelector := resetListDictionary keyAtValue:(self resetListSelection value).
    currentUserPrefs perform:resetSelector.
    self recolor.
    self updateModifiedChannel

    "Modified (format): / 16-03-2012 / 10:32:02 / cg"
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl methodsFor:'aspects'!

coloredText

    coloredText isNil ifTrue:[
        coloredText := ValueHolder new.
    ].
    ^ coloredText.
!

fullSelectorCheck

    fullSelectorCheck isNil ifTrue:[
        fullSelectorCheck := currentUserPrefs fullSelectorCheck asValue.
        fullSelectorCheck onChangeSend:#updateModifiedChannel to:self
    ].
    ^ fullSelectorCheck.
!

resetList

    resetList isNil ifTrue:[
        resetList := ValueHolder new.
    ].
    ^ resetList.

    "Modified: / 08-09-2006 / 16:00:58 / cg"
!

resetListSelection

    resetListSelection isNil ifTrue:[
        resetListSelection := ValueHolder new.
    ].
    ^ resetListSelection.
!

syntaxColor

    syntaxColor isNil ifTrue:[
        syntaxColor := ValueHolder new.
        syntaxColor addDependent:self.
    ].
    ^ syntaxColor.
!

syntaxColoring

    syntaxColoring isNil ifTrue:[
        syntaxColoring := true asValue.
        syntaxColoring addDependent:self.
        syntaxColoring onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ syntaxColoring.
!

syntaxElementList
    syntaxElementList isNil ifTrue:[
        syntaxElementList := ValueHolder new.
    ].
    ^ syntaxElementList.

    "Modified: / 08-09-2006 / 16:01:05 / cg"
!

syntaxElementSelection

    syntaxElementSelection isNil ifTrue:[
        syntaxElementSelection := ValueHolder new.
        syntaxElementSelection addDependent:self.
    ].
    ^ syntaxElementSelection.

    "Modified: / 08-09-2006 / 16:01:08 / cg"
!

syntaxEmphasisList
    syntaxEmphasisList isNil ifTrue:[
        syntaxEmphasisList := ValueHolder new.
    ].
    ^ syntaxEmphasisList.

    "Modified: / 08-09-2006 / 16:01:13 / cg"
!

syntaxEmphasisSelection

    syntaxEmphasisSelection isNil ifTrue:[
        syntaxEmphasisSelection := ValueHolder new.
        syntaxEmphasisSelection addDependent:self.
    ].
    ^ syntaxEmphasisSelection.
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl methodsFor:'change & update'!

getEmphasis:anEmphasisOrSymbol
    " return emphasis Symbol for emphasis or emphasis for emphasis symbol "

    ^ emphasisDictionary at:anEmphasisOrSymbol ifAbsent:[nil]
!

syntaxColorChanged
    |prefKey|

    prefKey := self syntaxColorSelector.
    (changedSettings includesKey:prefKey) ifFalse:[
        "/ remember previous value
        changedSettings at:prefKey put:(currentUserPrefs at:prefKey ifAbsent:nil).
    ].
    currentUserPrefs at:prefKey put:(self syntaxColor value).
    self recolor.
    self updateModifiedChannel
!

syntaxElementSelectionChanged
    | syntaxEmphasisValue |

    self syntaxColor value:(currentUserPrefs perform:(self syntaxColorSelector)).
    syntaxEmphasisValue := (currentUserPrefs perform:(self syntaxEmphasisSelector)).
    self syntaxEmphasisSelection value:(self getEmphasis:syntaxEmphasisValue).
    "/ self recolor.
!

syntaxEmphasisSelectionChanged
    |em prefKey|

    prefKey := self syntaxEmphasisSelector.
    (changedSettings includesKey:prefKey) ifFalse:[
        "/ remember previous value
        changedSettings at:prefKey put:(currentUserPrefs at:prefKey ifAbsent:nil).
    ].
    em := self getEmphasis:(self syntaxEmphasisSelection value ? 'normal') string.
    currentUserPrefs at:prefKey put:em.

    self recolor.
    self updateModifiedChannel
!

update:something with:aParameter from:changedObject
    changedObject == self syntaxElementSelection ifTrue:[
        self syntaxElementSelectionChanged.
        ^ self.
    ].
    changedObject == self syntaxColor ifTrue:[
        self syntaxColorChanged.
        ^ self.
    ].
    changedObject == self syntaxEmphasisSelection ifTrue:[
        self syntaxEmphasisSelectionChanged.
        ^ self.
    ].
    changedObject == self syntaxColoring ifTrue:[
        self recolor.
        ^ self.
    ].

    super update:something with:aParameter from:changedObject
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/sourceSettings.html'
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl methodsFor:'initialization & release'!

initialize
    self initializeEmphasisDictionary.
    super initialize.

    self syntaxEmphasisList
        value:(self class emphasisList
                collect:[:lbl |
                    lbl emphasizeAllWith:( self getEmphasis:lbl )
                ]).

    changedSettings := Dictionary new.
    resetListDictionary := Dictionary new.
    currentUserPrefs listOfPredefinedSyntaxColoringSchemes do:[:entry |
        resetListDictionary at:(entry at:1) put:(entry at:2)
    ].
!

initializeEmphasisDictionary

    emphasisDictionary := Dictionary new.
    self class emphasisMappingList do:[ :mapping |
        |name emphasis|

        name := mapping first.
        emphasis := mapping second.
        emphasisDictionary at:name put:emphasis.
        emphasisDictionary at:emphasis put:name.
    ].
!

release

    oldUserPreferences notNil ifTrue:[
        (UserPreferences reset; current)
            addAll:oldUserPreferences;
            flyByHelpSettingChanged.    "/ reinstall
    ].
    super release

    "Modified: / 14-02-2012 / 11:01:49 / cg"
! !

!AbstractSettingsApplication::SyntaxColorSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    |colorList colorPerformer emphasisPerformer|

    oldUserPreferences isNil ifTrue:[^ false].

    colorList := UserPreferences syntaxColorNames.
    colorList do:[:syntaxElement |
        colorPerformer := (self syntaxColorSelectorForElement:syntaxElement).
        emphasisPerformer := (self syntaxEmphasisSelectorForElement:syntaxElement).
        ((oldUserPreferences perform:colorPerformer) ~= (currentUserPrefs perform:colorPerformer)) ifTrue:[
            ^ true
        ].
        ((oldUserPreferences perform:emphasisPerformer) ~= (currentUserPrefs perform:emphasisPerformer)) ifTrue:[
            ^ true
        ].
        syntaxElement
    ].

    (super hasUnsavedChanges) ifTrue:[^ true].

    ^ false
!

syntaxColorSelector
    |elementName key|

    elementName := key := self syntaxElementSelection value.
    (elementName endsWith:' Color') ifFalse:[
        key := elementName,' Color'.
    ].
    ^ (self syntaxColorSelectorForElement:key)
!

syntaxColorSelectorForElement:aSyntaxElementsName
    "/ old code - error prone
    ^ (UserPreferences syntaxColorNamesAndKeys detect:[:el | el first = aSyntaxElementsName]) second
"/    ^ (aSyntaxElementsName replChar:$  withString: '') asLowercaseFirst asSymbol
!

syntaxEmphasisSelector
    |elementName key|

    elementName := self syntaxElementSelection value.
    key := elementName,' Color'.
    ^ self syntaxEmphasisSelectorForElement:key
!

syntaxEmphasisSelectorForElement:aSyntaxElementsName
    ^ (UserPreferences syntaxColorNamesAndKeys detect:[:el | el first = aSyntaxElementsName]) third
"/    ^ (((self syntaxColorSelectorForElement:anEmElement) upToAll: 'Color'), 'Emphasis')
"/        asLowercaseFirst asSymbol
! !

!AbstractSettingsApplication::SystemBrowserSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::SystemBrowserSettingsAppl
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#compactSCMLayout
'Arrange source code manager menu items in a compact layout'

#inPlaceSearch
'In-place search to browser lists'

#inlineSCMLayout
'Arrange source code manager menu items in a falt inline layout'

#oldSCMMenuLayout
'Arrange source code manager menu items in the old, traditional layout'

#searchBarInBrowser
'Add a search bar to the browser (like in web browsers)'

#showBookmarksBar
'Show the bookmarks bar'

#showGlobalHistory
'Show a toolbar button to navigate the global visited classes history'

#showLocalHistory
'Show a toolbar button to navigate the local (per browser) visited classes history'

#showMarqueeInfo
'Scroll multipline info texts in the low info area.\If off, multiline infos are suppressed and no automatic scrolling is done (better for VM/remote desktops)'

#showMethodTemplate
'Show a method code template when no method is selected'

#sortAndIndentClassesByInheritance
'Sort and indent classes by inheritance within a category (as opposed to sorting by name)'

#useEmbeddedTestRunner
'Show a panel to start sUnit tests, whenever a testcase class is selected'

#webBrowserLikeLayout
'Use a layout similar to web browsers'

)
! !

!AbstractSettingsApplication::SystemBrowserSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary systemBrowser24x24Icon

    "Modified: / 17-09-2007 / 11:35:15 / cg"
! !

!AbstractSettingsApplication::SystemBrowserSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::SystemBrowserSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::SystemBrowserSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::SystemBrowserSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'System Browser Settings'
         name: 'System Browser Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 569 590)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'SettingsPanel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Settings'
                   name: 'ToolsSettingsPanel'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'ToolSettingsVPanel'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Use the Embedded Test Runner'
                               name: 'UseEmbeddedTestRunner'
                               activeHelpKey: useEmbeddedTestRunner
                               model: showEmbeddedTestRunnerInBrowser
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Web Browser Like Layout (Toolbars are Part of the Tab - experimental)'
                               name: 'CheckBox1'
                               activeHelpKey: webBrowserLikeLayout
                               initiallyInvisible: true
                               model: webBrowserLikeLayout
                               translateLabel: true
                               extent: (Point 607 30)
                             )
                            (CheckBoxSpec
                               label: 'Show Bookmarks Bar'
                               name: 'ShowBookmarksBar'
                               activeHelpKey: showBookmarksBar
                               model: showBookmarkBar
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Sort and Indent Classes by Inheritance'
                               name: 'SortAndIndentClassesByInheritance'
                               activeHelpKey: sortAndIndentClassesByInheritance
                               model: sortAndIndentClassesByInheritance
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Show Local Navigation History (Separate History per Browser Tab)'
                               name: 'CheckBox2'
                               activeHelpKey: showLocalHistory
                               model: showLocalHistory
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Show Global Navigation History (Global History for all Browsers)'
                               name: 'CheckBox3'
                               activeHelpKey: showGlobalHistory
                               model: showGlobalHistory
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Show Search Bar in Browser'
                               name: 'ShowSearchBarInBrowser'
                               activeHelpKey: searchBarInBrowser
                               model: useSearchBarInBrowser
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Use in-place Search in Browser Lists (experimental)'
                               name: 'CheckBox4'
                               activeHelpKey: inPlaceSearch
                               model: useInPlaceSearchInBrowserLists
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Show Method Template'
                               name: 'MethodTemplate'
                               activeHelpKey: showMethodTemplate
                               model: showMethodTemplate
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            (CheckBoxSpec
                               label: 'Marquee Info'
                               name: 'CheckBox5'
                               activeHelpKey: showMarqueeInfo
                               model: showMarqueeInfo
                               translateLabel: true
                               extent: (Point 533 30)
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 569 333)
                 )
                (FramedBoxSpec
                   label: 'Sourcecode Management Menu Layout'
                   name: 'MenuLayoutPanel'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'MenuLayoutVPanel'
                         layout: (LayoutFrame 0 0 5 0 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (RadioButtonSpec
                               label: 'Old'
                               name: 'SCMMenuLayoutOld'
                               activeHelpKey: oldSCMMenuLayout
                               translateLabel: true
                               model: sourceCodeManagementMenuLayout
                               isTriggerOnDown: true
                               select: 'old'
                               extent: (Point 533 30)
                             )
                            (RadioButtonSpec
                               label: 'Inline'
                               name: 'SCMMenuLayoutInline'
                               activeHelpKey: inlineSCMLayout
                               translateLabel: true
                               model: sourceCodeManagementMenuLayout
                               isTriggerOnDown: true
                               select: 'inline'
                               extent: (Point 533 30)
                             )
                            (RadioButtonSpec
                               label: 'Compact'
                               name: 'SCMMenuLayoutCompact'
                               activeHelpKey: compactSCMLayout
                               translateLabel: true
                               model: sourceCodeManagementMenuLayout
                               isTriggerOnDown: true
                               select: 'compact'
                               extent: (Point 533 30)
                             )
                            )

                         )
                       )
                      )

                   )
                   extent: (Point 569 135)
                 )
                (FramedBoxSpec
                   label: 'Static Analysis (Lint)'
                   name: 'LintPanel'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'LintPanelContent'
                         layout: (LayoutFrame 0 0 0 0 0 1 53 0)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component:
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'DefaultRulesetBox'
                               component:
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Default Rules:'
                                     name: 'DefaultRulesetLabel'
                                     layout: (LayoutFrame 0 0 0 0 138 0 0 1)
                                     translateLabel: true
                                     adjust: left
                                   )
                                  (InputFieldSpec
                                     name: 'DefaultRuleset'
                                     layout: (LayoutFrame 144 0 0 0 -100 1 0 1)
                                     model: smallLintRulesetDefault
                                     isReadOnly: true
                                     acceptOnReturn: true
                                     acceptOnTab: true
                                     converter: smallLintRulesetDefaultAdaptor
                                     acceptOnPointerLeave: true
                                     emptyFieldReplacementText: 'Default'
                                   )
                                  (ActionButtonSpec
                                     label: 'Select'
                                     name: 'DefaultRulesetSelectButton'
                                     layout: (LayoutFrame -100 1 0 0 0 1 0 1)
                                     translateLabel: true
                                     model: doSelectDefaultRuleset
                                   )
                                  )

                               )
                               extent: (Point 533 25)
                             )
                            (ViewSpec
                               name: 'Box1'
                               component:
                              (SpecCollection
                                 collection: (
                                  (LinkButtonSpec
                                     label: 'Configure Rule Sets...'
                                     name: 'Button1'
                                     layout: (LayoutFrame -200 1 -20 1 0 1 0 1)
                                     foregroundColor: (Color 0.0 0.0 100.0)
                                     translateLabel: true
                                     adjust: right
                                     model: doConfigureRulesets
                                   )
                                  )

                               )
                               extent: (Point 533 25)
                             )
                            )

                         )
                         useDynamicPreferredHeight: true
                         usePreferredHeight: true
                       )
                      )

                   )
                   extent: (Point 569 92)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::SystemBrowserSettingsAppl methodsFor:'actions'!

accept
    self saveSettings.
    self closeRequest.

    "Created: / 14-10-2014 / 09:18:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigureRulesets
    Tools::LintRuleSettingsApplication open

    "Modified: / 14-10-2014 / 09:28:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSelectDefaultRuleset
    <resource: #uiCallback>

    | dialog |

    dialog := Tools::LintRuleSelectionDialog new.
    dialog open.
    dialog accepted ifTrue:[
        smallLintRulesetDefault value: dialog selectionAsRule.
    ]

    "Modified: / 14-10-2014 / 22:12:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::SystemBrowserSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        "/ showAcceptCancelBarInBrowser
        useSearchBarInBrowser
        showMethodTemplate
        "/ useCodeView2InTools
        showEmbeddedTestRunnerInBrowser
        showBookmarkBar
        webBrowserLikeLayout
        sortAndIndentClassesByInheritance
        showGlobalHistory
        showLocalHistory
        useInPlaceSearchInBrowserLists
        sourceCodeManagementMenuLayout
        confirmRefactorings
        smallLintRulesetDefault
        showMarqueeInfo
    )

    "Created: / 25-11-2011 / 15:09:28 / cg"
    "Modified: / 14-10-2014 / 08:19:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

confirmRefactorings

    confirmRefactorings isNil ifTrue:[
        confirmRefactorings := false asValue.
        confirmRefactorings onChangeSend:#updateModifiedChannel to:self
    ].
    ^ confirmRefactorings.

    "Created: / 07-06-2011 / 14:34:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showAcceptCancelBarInBrowser
    showAcceptCancelBarInBrowser isNil ifTrue:[
        showAcceptCancelBarInBrowser := false asValue.
        showAcceptCancelBarInBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showAcceptCancelBarInBrowser.
!

showBookmarkBar
    "return/create the 'showMethodTemplate' value holder (automatically generated)"

    showBookmarkBar isNil ifTrue:[
        showBookmarkBar := ValueHolder new.
        showBookmarkBar onChangeSend:#updateModifiedChannel to:self

    ].
    ^ showBookmarkBar

    "Created: / 18-05-2011 / 16:51:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showEmbeddedTestRunnerInBrowser
    "return/create the 'showEmbeddedTestRunnerInBrowser' value holder (automatically generated)"

    showEmbeddedTestRunnerInBrowser isNil ifTrue:[
        showEmbeddedTestRunnerInBrowser := ValueHolder new.
        showEmbeddedTestRunnerInBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showEmbeddedTestRunnerInBrowser

    "Modified: / 11-03-2010 / 10:12:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showGlobalHistory

    showGlobalHistory isNil ifTrue:[
        showGlobalHistory := false asValue.
        showGlobalHistory onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showGlobalHistory.

    "Created: / 07-07-2011 / 00:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showLocalHistory

    showLocalHistory isNil ifTrue:[
        showLocalHistory := false asValue.
        showLocalHistory onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showLocalHistory.

    "Created: / 07-07-2011 / 00:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showMarqueeInfo
    showMarqueeInfo isNil ifTrue:[
        showMarqueeInfo := true asValue.
        showMarqueeInfo onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showMarqueeInfo.
!

showMethodTemplate
    "return/create the 'showMethodTemplate' value holder (automatically generated)"

    showMethodTemplate isNil ifTrue:[
        showMethodTemplate := ValueHolder new.
        showMethodTemplate onChangeSend:#updateModifiedChannel to:self

    ].
    ^ showMethodTemplate

    "Modified: / 11-03-2010 / 10:08:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smallLintRulesetDefault
    <resource: #uiAspect>

    smallLintRulesetDefault isNil ifTrue:[
        smallLintRulesetDefault := ValueHolder new.
        smallLintRulesetDefault onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallLintRulesetDefault.

    "Created: / 14-10-2014 / 08:19:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 18:23:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smallLintRulesetDefaultAdaptor
    ^ PluggableAdaptor new
        getter:[ :model | model value isNil ifTrue:[nil] ifFalse:[model value name]]
        setter:[ :model :value | ]

    "Created: / 14-10-2014 / 22:11:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sortAndIndentClassesByInheritance

    sortAndIndentClassesByInheritance isNil ifTrue:[
        sortAndIndentClassesByInheritance := false asValue.
        sortAndIndentClassesByInheritance onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sortAndIndentClassesByInheritance.

    "Created: / 06-07-2011 / 23:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceCodeManagementMenuLayout
    sourceCodeManagementMenuLayout isNil ifTrue:[
        sourceCodeManagementMenuLayout := #inline "#old" asValue.
        sourceCodeManagementMenuLayout onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sourceCodeManagementMenuLayout.

    "Created: / 06-10-2011 / 18:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useCodeView2InTools
    "return/create the 'useCodeView2InTools' value holder (automatically generated)"

    useCodeView2InTools isNil ifTrue:[
        useCodeView2InTools := ValueHolder new.
        useCodeView2InTools onChangeSend:#updateModifiedChannel to:self

    ].
    ^ useCodeView2InTools

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useInPlaceSearchInBrowserLists
    useInPlaceSearchInBrowserLists isNil ifTrue:[
        useInPlaceSearchInBrowserLists := false asValue.
        useInPlaceSearchInBrowserLists onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useInPlaceSearchInBrowserLists.

    "Created: / 28-07-2011 / 09:36:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useSearchBarInBrowser
    "true, if the search-entry fields are shown in the browser itself
     (like in firefox). False if a dialog is to be opened."

    useSearchBarInBrowser isNil ifTrue:[
        useSearchBarInBrowser := true asValue.
        useSearchBarInBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useSearchBarInBrowser.
!

webBrowserLikeLayout
    "true, if the search-entry fields are shown in the browser itself
     (like in firefox). False if a dialog is to be opened."

    webBrowserLikeLayout isNil ifTrue:[
        webBrowserLikeLayout := false asValue.
        webBrowserLikeLayout onChangeSend:#updateModifiedChannel to:self
    ].
    ^ webBrowserLikeLayout.

    "Created: / 07-06-2011 / 14:34:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::SystemBrowserSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/browserSettings.html'
! !

!AbstractSettingsApplication::SystemMessageSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::SystemMessageSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#vmInfo
'Enable/disable information messages from the Virtual Machine (VM)'

#vmErrors
'Enable/disable error messages from the Virtual Machine (VM)'

#displayErrors
'Enable/disable error messages from the display (X or Windows screen connection)'

#classInfos
'Enable/disable messages from the class library'

#showToolTips
'Show tooltips (fly-by help)'

#toolTipAutoHideDelay
'Autohide tooltips after that time (seconds by default). 0 to not autohide.'

#onlyShowTooltipsForActiveWindow
'Show tooltips only for the active window. Not for any passive windows underneath'

#beepEnabled
'Enable/disable audible beeps altogether'

#beepInEditor
'Enable/disable audible beeps from the editor (search found nothing, etc.)'

#beepForInfoDialog
'Enable/disable audible beeps when an info dialog is opened'

#beepForWarningDialog
'Enable/disable audible beeps when a warning dialog is opened'

#beepForErrorDialog
'Enable/disable audible beeps when an error dialog is opened'

#flyByHelpActive
'Enable/disable tooltips'

#sendMessagesAlsoToTranscript
'If on, messages are sent to both Stderr and the Transcript.\If off, they are sent to Stderr only.\The default is on.'
)
! !

!AbstractSettingsApplication::SystemMessageSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::SystemMessageSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth8Image width:22 height:22) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@PDA@P@@@@@@@@@@@@@@@@@@@@@@@PHB@0D@@@@@@@@@@@@@@@@@@@@@@PHDAPLC@P@@@@@@@@@@@@@@@@@@@@DBA PGA0 @@@@@@@@@@@@@
@@@@@@@A@ XDA0\H@@@@@@@@@@@@@@@@@@@@@PHIA@(J@@@@@@@@@@@@@@@@@@@@@@DAB00MCP@@@@@@@@@@@@@@@@@@@@@@@@DN@@@@@@@@@@@@@@@@@@@@
@@@@@@@AC @@@@@@@@@@@@@@@@@@@@@@@@@@@P8@@@@@@@@@@@@@@@@@@@@@@@<OC0PNDA@@DQD@@@@@@@@@@@@@@@<RD1LTEQXVE1 XDP@@@@@@@@@@@@@O
D!!LSEATVE!!\XFAD@@@@@@@@@@@@@C1HSD1$UEAPZF1,\@@@@@@@@@@@@@@<RGQ4YF!!PTEAXVG@@@@@@@@@@@@@@OD!!4]FQ(TEAPVE!!0@@@@@@@@@@@@@C1H]
GQ$TEAPTE1\@@@@@@@@@@@@@@@<RGQ4YF!!(ZF!!TU@@@@@@@@@@@@C0<^D1LSG2@UER@ HBD"@@@@@@@@@@<OG!!LSD1< EQT HB@!!H @@@@@@@@@OC2DSD1L_
F!!(ZF!!(ZF@@@@@@@@@@@@@@ODQ0\H"H"H @@@@@@@@@@@@@a')
            colorMapFromArray:#[0 0 0 64 32 16 128 96 48 112 48 0 176 112 48 176 96 32 208 160 128 160 96 16 48 32 0 192 128 80 160 80 16 112 80 32 176 112 32 96 48 16 160 112 32 80 80 16 128 64 16 64 64 16 208 208 176 224 224 208 160 160 128 144 144 80 112 112 64 128 128 64 80 80 32 192 192 160 160 160 112 96 96 48 48 48 16 240 240 224 176 176 128 176 176 144 144 144 96 112 112 48 32 32 0]
            mask:((ImageMask width:22 height:22) bits:(ByteArray fromPackedString:'@G @@O @@_0@@_0@@_0@@_0@@_0@@G @@G @@G @@?<@A?>@A?>@A?>@A?>@A?>@A?>@A?>@G??@G??@G??@A?>@'); yourself); yourself]
! !

!AbstractSettingsApplication::SystemMessageSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::SystemMessageSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::SystemMessageSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::SystemMessageSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Messages Settings'
         name: 'Messages Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 574 602)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fitSpace
             verticalLayout: topSpace
             horizontalSpace: 5
             verticalSpace: 5
             component:
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Info & Error Messages'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'VM Info Messages'
                         name: 'VMInfoMessages'
                         layout: (LayoutFrame 5 0 5 0 -5 1 35 0)
                         activeHelpKey: vmInfo
                         model: vmInfo
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'VM Error Messages'
                         name: 'VMErrorMessages'
                         layout: (LayoutFrame 5 0 35 0 -5 1 65 0)
                         activeHelpKey: vmErrors
                         model: vmErrors
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Display Error Messages (Xlib, Xtlib, WinAPI ...)'
                         name: 'DisplayErrorMessages'
                         layout: (LayoutFrame 5 0 65 0 -5 1 95 0)
                         activeHelpKey: displayErrors
                         model: displayErrors
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Other Info Messages'
                         name: 'OtherInfoMessages'
                         layout: (LayoutFrame 5 0 95 0 -5 1 125 0)
                         activeHelpKey: classInfos
                         model: classInfos
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Send also to Transcript (in addition to Stderr)'
                         name: 'CheckBox8'
                         layout: (LayoutFrame 5 0 149 0 -5 1 179 0)
                         activeHelpKey: sendMessagesAlsoToTranscript
                         model: sendMessagesAlsoToTranscript
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 564 213)
                 )
                (FramedBoxSpec
                   label: 'Audible Bell'
                   name: 'FramedBox3'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Beep Generally Enabled'
                         name: 'beepEnabled'
                         layout: (LayoutFrame 5 0 10 0 0 1 40 0)
                         activeHelpKey: beepEnabled
                         model: beepEnabled
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Beep in Editor'
                         name: 'CheckBox7'
                         layout: (LayoutFrame 40 0 35 0 0 1 65 0)
                         activeHelpKey: beepInEditor
                         enableChannel: beepEnabled
                         model: beepInEditor
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Beep for Info Dialogs'
                         name: 'CheckBox3'
                         layout: (LayoutFrame 40 0 60 0 0 1 90 0)
                         activeHelpKey: beepForInfoDialog
                         enableChannel: beepEnabled
                         model: beepForInfoDialog
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Beep for Warning Dialogs'
                         name: 'CheckBox4'
                         layout: (LayoutFrame 40 0 85 0 0 1 115 0)
                         activeHelpKey: beepForWarningDialog
                         enableChannel: beepEnabled
                         model: beepForWarningDialog
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Beep for Error Dialogs'
                         name: 'CheckBox5'
                         layout: (LayoutFrame 40 0 111 0 0 1 141 0)
                         activeHelpKey: beepForErrorDialog
                         enableChannel: beepEnabled
                         model: beepForErrorDialog
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 564 178)
                 )
                (FramedBoxSpec
                   label: 'Help'
                   name: 'FramedBox4'
                   labelPosition: topLeft
                   translateLabel: true
                   component:
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Tooltips (FlyBy Help)'
                         name: 'CheckBox6'
                         layout: (LayoutFrame 5 0 7 0 -5 1 37 0)
                         activeHelpKey: flyByHelpActive
                         model: flyByHelpActive
                         translateLabel: true
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         layout: (LayoutFrame -90 1 5 0 -34 1 35 0)
                         activeHelpKey: toolTipAutoHideDelay
                         enableChannel: flyByHelpActive
                         model: toolTipAutoHideDelay
                         type: timeDurationOrNil
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                       )
                      (LabelSpec
                         label: 'Autohide after:'
                         name: 'Label1'
                         layout: (AlignmentOrigin -94 1 21 0 1 0.5)
                         activeHelpKey: toolTipAutoHideDelay
                         translateLabel: true
                         adjust: right
                       )
                      (LabelSpec
                         label: '(s)'
                         name: 'Label2'
                         layout: (LayoutFrame -31 1 6 0 0 1 36 0)
                         activeHelpKey: toolTipAutoHideDelay
                         translateLabel: true
                         adjust: left
                       )
                      (CheckBoxSpec
                         label: 'Only Show Tooltips for Active Window'
                         name: 'CheckBox9'
                         layout: (LayoutFrame 40 0 42 0 0 1 72 0)
                         activeHelpKey: onlyShowTooltipsForActiveWindow
                         enableChannel: flyByHelpActive
                         model: onlyShowTooltipsForActiveWindow
                         translateLabel: true
                       )
                      )

                   )
                   extent: (Point 564 108)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::SystemMessageSettingsAppl methodsFor:'actions'!

basicReadSettings
    super basicReadSettings.

    self vmInfo value:ObjectMemory infoPrinting.
    self vmErrors value:ObjectMemory debugPrinting.
    self classInfos value:Object infoPrinting.
    self displayErrors value:DeviceWorkstation errorPrinting.

    "Modified: / 10-11-2010 / 12:08:03 / cg"
!

basicSaveSettings

    ObjectMemory infoPrinting:self vmInfo value.
    ObjectMemory debugPrinting:self vmErrors value.
    Object infoPrinting:self classInfos value.
    DeviceWorkstation errorPrinting:self displayErrors value.

    super basicSaveSettings.

    "Modified: / 10-11-2010 / 12:08:14 / cg"
! !

!AbstractSettingsApplication::SystemMessageSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
                beepEnabled
                beepInEditor
                beepForInfoDialog
                beepForWarningDialog
                beepForErrorDialog
                flyByHelpActive
                toolTipAutoHideDelay
                sendMessagesAlsoToTranscript
                onlyShowTooltipsForActiveWindow
            )

    "Created: / 10-11-2010 / 12:07:42 / cg"
!

beepEnabled
    beepEnabled isNil ifTrue:[
        beepEnabled := true asValue.
        beepEnabled onChangeSend:#updateModifiedChannel to:self
    ].
    ^ beepEnabled.
!

beepForErrorDialog
    beepForErrorDialog isNil ifTrue:[
        beepForErrorDialog := currentUserPrefs beepForErrorDialog asValue.
        beepForErrorDialog onChangeSend:#updateModifiedChannel to:self
    ].
    ^ beepForErrorDialog.
!

beepForInfoDialog
    beepForInfoDialog isNil ifTrue:[
        beepForInfoDialog := currentUserPrefs beepForInfoDialog asValue.
        beepForInfoDialog onChangeSend:#updateModifiedChannel to:self
    ].
    ^ beepForInfoDialog.
!

beepForWarningDialog
    beepForWarningDialog isNil ifTrue:[
        beepForWarningDialog := currentUserPrefs beepForWarningDialog asValue.
        beepForWarningDialog onChangeSend:#updateModifiedChannel to:self
    ].
    ^ beepForWarningDialog.
!

beepInEditor
    beepInEditor isNil ifTrue:[
        beepInEditor := true asValue.
        beepInEditor onChangeSend:#updateModifiedChannel to:self
    ].
    ^ beepInEditor.
!

changeFileName

    changeFileName isNil ifTrue:[
        changeFileName := ObjectMemory nameForChanges asValue.
        changeFileName onChangeSend:#updateModifiedChannel to:self
    ].
    ^ changeFileName.
!

classInfos

    classInfos isNil ifTrue:[
        classInfos := Object infoPrinting asValue.
        classInfos onChangeSend:#updateModifiedChannel to:self
    ].
    ^ classInfos.
!

displayErrors

    displayErrors isNil ifTrue:[
        displayErrors := DeviceWorkstation errorPrinting asValue.
        displayErrors onChangeSend:#updateModifiedChannel to:self
    ].
    ^ displayErrors.
!

flyByHelpActive
    flyByHelp isNil ifTrue:[
        flyByHelp := currentUserPrefs flyByHelpActive asValue.
        flyByHelp onChangeSend:#updateModifiedChannel to:self
    ].
    ^ flyByHelp.
!

logDoits

    logDoits isNil ifTrue:[
        logDoits := Smalltalk logDoits asValue.
        logDoits onChangeSend:#updateModifiedChannel to:self
    ].
    ^ logDoits.
!

onlyShowTooltipsForActiveWindow
    onlyShowTooltipsForActiveWindow isNil ifTrue:[
        onlyShowTooltipsForActiveWindow := true asValue.
        onlyShowTooltipsForActiveWindow onChangeSend:#updateModifiedChannel to:self
    ].
    ^ onlyShowTooltipsForActiveWindow.
!

sendMessagesAlsoToTranscript
    sendMessagesAlsoToTranscript isNil ifTrue:[
        sendMessagesAlsoToTranscript := true asValue.
        sendMessagesAlsoToTranscript onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sendMessagesAlsoToTranscript.
!

toolTipAutoHideDelay
    toolTipAutoHideDelay isNil ifTrue:[
        toolTipAutoHideDelay := 10 seconds asValue.
        toolTipAutoHideDelay onChangeSend:#updateModifiedChannel to:self
    ].
    ^ toolTipAutoHideDelay.

    "Created: / 10-11-2010 / 12:07:10 / cg"
!

updChanges

    updChanges isNil ifTrue:[
        updChanges := Class updatingChanges asValue.
        updChanges onChangeSend:#updateModifiedChannel to:self
    ].
    ^ updChanges.
!

vmErrors

    vmErrors isNil ifTrue:[
        vmErrors := ObjectMemory debugPrinting asValue.
        vmErrors onChangeSend:#updateModifiedChannel to:self
    ].
    ^ vmErrors.
!

vmInfo

    vmInfo isNil ifTrue:[
        vmInfo := ObjectMemory infoPrinting asValue.
        vmInfo onChangeSend:#updateModifiedChannel to:self
    ].
    ^ vmInfo.
! !

!AbstractSettingsApplication::SystemMessageSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/messageSettings.html'
! !

!AbstractSettingsApplication::SystemMessageSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    (super hasUnsavedChanges) ifTrue:[^ true].

    self vmInfo value ~= ObjectMemory infoPrinting ifTrue:[^ true].
    self vmErrors value ~= ObjectMemory debugPrinting ifTrue:[^ true].
    self classInfos value ~= Object infoPrinting ifTrue:[^ true].
    self displayErrors value ~= DeviceWorkstation errorPrinting ifTrue:[^ true].
    ^ false

    "Modified: / 10-11-2010 / 12:08:25 / cg"
! !

!AbstractSettingsApplication::TerminalViewSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::FontSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#terminalOutputIsUTF8
'The shell''s (or command) output is UTF8 encoded (as opposed to Ascii/Latin-1).\Enable this on OSX and some modern Linux systems'

#terminalInputIsUTF8
'The shell (or command) accepts UTF8 encoded input (as opposed to Ascii/Latin-1).\Enable this on OSX and some modern Linux systems'

)
! !

!AbstractSettingsApplication::TerminalViewSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    OperatingSystem isUNIXlike ifTrue:[
        ^ ToolbarIconLibrary unixShellTerminal22x22Icon
    ].
    ^ ToolbarIconLibrary terminal16x16Icon
! !

!AbstractSettingsApplication::TerminalViewSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::TerminalViewSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::TerminalViewSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::TerminalViewSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Terminalview Settings'
         name: 'Terminalview Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 658 543)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Shell / Command Output is UTF8 encoded'
                   name: 'UserCodeView2'
                   activeHelpKey: terminalOutputIsUTF8
                   model: terminalOutputIsUTF8
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                (CheckBoxSpec
                   label: 'Shell / Command Input is UTF8 encoded'
                   name: 'CheckBox1'
                   activeHelpKey: terminalInputIsUTF8
                   model: terminalInputIsUTF8
                   translateLabel: true
                   extent: (Point 658 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::TerminalViewSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        #terminalOutputIsUTF8
        #terminalInputIsUTF8
    )
!

terminalInputIsUTF8
    terminalInputIsUTF8 isNil ifTrue:[
        terminalInputIsUTF8 := false asValue.
        terminalInputIsUTF8 onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ terminalInputIsUTF8.
!

terminalOutputIsUTF8
    terminalOutputIsUTF8 isNil ifTrue:[
        terminalOutputIsUTF8 := false asValue.
        terminalOutputIsUTF8 onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ terminalOutputIsUTF8.
! !

!AbstractSettingsApplication::TerminalViewSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/terminalSettings.html'
! !

!AbstractSettingsApplication::ToolboxSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::ToolboxSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth4Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"JH!!"H"H"H"H"H"H"Y'']6 "H"H"H"H"H"Y6Y''^BH"H"H"H"H"I6DV^BH"H"H""H"H&QFH H"HH"H(UUUUT3
L3L3L3 "H(UUUUT3L3"CL3 "H(UUUUT3L6]9L3 "H(UUUUT3L6]1L3 "H(UUUUT3L6]9L3 "H(UUUUT3L3!!CL3 "H(UUUUT3L3L3L3 "H(UUUUT3L3L3L3 "
H(UUUUT3L3L3L3 "H(UUUUT3L3L3L3 "H(UUUUT3L3L3NYH"H")UUUT3L3NZ&RH"H"J*UUL3&)$2H"H"H"H%***YL"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"
H"H"H"H"H"H"H"H"H"H"H"H"') ; colorMapFromArray:#[73 74 74 98 53 53 107 107 107 254 102 102 180 180 180 255 0 0 128 128 128 253 252 252 46 49 49 171 80 80 155 25 25]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@C0@@G<@@G>@@GN@G??8O??<O??<O??<O??<O??<O??<O??<O??<O??<O??<O??8G??0C?>@A? @@@@@@@@@@@@@') ; yourself); yourself]
! !

!AbstractSettingsApplication::ToolboxSettingsAppl class methodsFor:'interface specs'!

developmentToolsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ToolboxSettingsAppl andSelector:#developmentToolsSpec
     AbstractSettingsApplication::ToolboxSettingsAppl new openInterface:#developmentToolsSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: developmentToolsSpec
        window:
       (WindowSpec
          label: 'Development'
          name: 'Development'
          bounds: (Rectangle 0 0 674 614)
        )
        component:
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'DevToolsPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              postBuildCallback: developmentToolSettingsInto:
            )
           )

        )
      )

    "Modified: / 03-04-2012 / 10:51:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

miscToolsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ToolboxSettingsAppl andSelector:#developmentToolsSpec
     AbstractSettingsApplication::ToolboxSettingsAppl new openInterface:#developmentToolsSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: miscToolsSpec
        window:
       (WindowSpec
          label: 'Other'
          name: 'Other'
          bounds: (Rectangle 0 0 674 614)
        )
        component:
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'DevToolsPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              postBuildCallback: miscToolSettingsInto:
            )
           )

        )
      )

    "Created: / 03-04-2012 / 10:51:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ToolboxSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::ToolboxSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::ToolboxSettingsAppl open
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: windowSpec
        window:
       (WindowSpec
          label: 'Toolbox Settings'
          name: 'Toolbox Settings'
          bounds: (Rectangle 0 0 551 561)
        )
        component:
       (SpecCollection
          collection: (
           (NoteBookViewSpec
              name: 'NoteBook'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              menu: notebookTabList
            )
           )

        )
      )
! !

!AbstractSettingsApplication::ToolboxSettingsAppl class methodsFor:'list specs'!

notebookTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#notebookTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Development'
          minorKey: developmentToolsSpec
          createNewBuilder: false
        )
       (TabItem
          label: 'Miscellaneous'
          minorKey: miscToolsSpec
          createNewBuilder: false
        )

       )

      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 03-04-2012 / 10:52:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::ToolboxSettingsAppl methodsFor:'aspects'!

aspects

    ^#(
        "Development"
        changesBrowserClassName

        "Misc"
        fileBrowserClassName
    )

    "Created: / 14-02-2012 / 18:36:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesBrowserClassName
    <resource: #uiAspect>

    changesBrowserClassName isNil ifTrue:[
        changesBrowserClassName := ValueHolder new.
      changesBrowserClassName onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ changesBrowserClassName.

    "Modified: / 14-02-2012 / 18:58:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileBrowserClassName
    <resource: #uiAspect>

    fileBrowserClassName isNil ifTrue:[
        fileBrowserClassName := ValueHolder new.
        fileBrowserClassName onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ fileBrowserClassName.

    "Modified: / 14-02-2012 / 18:58:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 03-04-2012 / 10:54:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notebookTabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#notebookTabList) isNil ifTrue:[
        builder aspectAt:#notebookTabList put:(list := self class notebookTabList).
    ].
    ^ list
! !

!AbstractSettingsApplication::ToolboxSettingsAppl methodsFor:'hooks'!

developmentToolSettingsInto:panel

    (self addClassToolSettingTo: panel)
        label: 'Changes Browser';
        classes:#(  #ChangesBrowser
                    #NewChangesBrowser
                    #Tools::ChangeSetBrowser2 );
        labels: #(  'ChangesBrowser - default'
                    'NewChangesBrowser - experimental, not maintained'
                    'Tools::ChangeSetBrowser2 - experimental' );
        model: self changesBrowserClassName

    "Created: / 14-02-2012 / 16:20:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

miscToolSettingsInto:panel

    (self addClassToolSettingTo: panel)
        label: 'File Browser';
        classes:#(  #FileBrowser
                    #FileBrowserV2
                    #FileBrowserV3 );
        labels: #(  'FileBrowser'
                    'FileBrowserV2 - default'
                    'FileBrowserV3 - experimental' );
        model: self fileBrowserClassName

    "Created: / 03-04-2012 / 10:54:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::ToolboxSettingsAppl methodsFor:'private'!

addClassToolSettingTo: panel

    | model setting canvas |
    canvas := ApplicationSubView new.
    setting := ClassToolSetting new.
    setting createBuilder.
    setting model: model.
    setting window: canvas.
    canvas client: setting.
    canvas height: 30.
    panel addSubView: canvas.
    ^setting

    "Created: / 14-02-2012 / 18:56:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::ToolboxSettingsAppl methodsFor:'protocol'!

helpFilename
    "subclasses must return the relative name of a helpFile
     in the doc/online/<language>/help directory.
     Or nil, if no help is available."

    ^ self shouldImplement
! !

!AbstractSettingsApplication::ToolboxSettingsAppl::ClassToolSetting class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ToolboxSettingsAppl::ClassToolSetting andSelector:#windowSpec
     AbstractSettingsApplication::ToolboxSettingsAppl::ClassToolSetting new openInterface:#windowSpec
     AbstractSettingsApplication::ToolboxSettingsAppl::ClassToolSetting open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'ToolSetting'
         name: 'ToolSetting'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 431 60)
       )
       component:
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Tool...'
             name: 'Label'
             layout: (LayoutFrame 0 0 0 0 250 0 30 0)
             translateLabel: true
             labelChannel: optionLabelHolder
             adjust: left
           )
          (PopUpListSpec
             label: 'Please select...'
             name: 'OptionList'
             layout: (LayoutFrame 250 0 3 0 0 1 27 0)
             translateLabel: true
             model: optionSelectionHolder
             menu: optionLabelList
             useIndex: true
           )
          (InputFieldSpec
             name: 'EntryField1'
             layout: (LayoutFrame 250 0 33 0 0 1 56 0)
             visibilityChannel: optionCustomValueVisibleHolder
             backgroundChannel: optionCustomValueBackgroundHolder
             model: optionCustomValueHolder
             type: string
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnPointerLeave: true
           )
          )

       )
     )
! !

!AbstractSettingsApplication::ToolboxSettingsAppl::ClassToolSetting methodsFor:'accessing'!

classes: aCollection

    optionValueList := aCollection.

    "Created: / 14-02-2012 / 18:20:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label: aString

    self optionLabelHolder value: aString

    "Created: / 14-02-2012 / 18:22:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labels: aCollection

    | labels |
    labels := aCollection asOrderedCollection.
    labels add: (self class resources at: 'Custom class') asText allItalic.
    self optionLabelList value: labels.

    "Created: / 14-02-2012 / 18:21:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

model: aValueHolder

    self optionValueHolder: aValueHolder

    "Created: / 14-02-2012 / 18:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::ToolboxSettingsAppl::ClassToolSetting methodsFor:'aspects'!

optionCustomValueBackgroundHolder
    <resource: #uiAspect>

    optionCustomValueBackgroundHolder isNil ifTrue:[
        optionCustomValueBackgroundHolder := ValueHolder new.
    ].
    ^ optionCustomValueBackgroundHolder.
!

optionCustomValueBackgroundHolder:something
    "set the 'optionCustomValueBackgroundHolder' value holder (automatically generated)"

    optionCustomValueBackgroundHolder := something.
!

optionCustomValueHolder
    <resource: #uiAspect>

    optionCustomValueHolder isNil ifTrue:[
        optionCustomValueHolder := ValueHolder new.
        optionCustomValueHolder addDependent:self.
    ].
    ^ optionCustomValueHolder.

    "Modified: / 14-02-2012 / 18:18:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

optionCustomValueVisibleHolder
    <resource: #uiAspect>

    optionCustomValueVisibleHolder isNil ifTrue:[
        optionCustomValueVisibleHolder := false asValue.
        optionCustomValueVisibleHolder addDependent:self.
    ].
    ^ optionCustomValueVisibleHolder.

    "Modified: / 14-02-2012 / 18:27:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

optionLabelHolder
    <resource: #uiAspect>

    optionLabelHolder isNil ifTrue:[
        optionLabelHolder := ValueHolder new.
    ].
    ^ optionLabelHolder.
!

optionLabelList
    <resource: #uiAspect>

    optionLabelList isNil ifTrue:[
        optionLabelList := ValueHolder new.
    ].
    ^ optionLabelList.
!

optionLabelList:something
    "set the 'optionLabelList' value holder (automatically generated)"

    optionLabelList := something.
!

optionSelectionHolder
    <resource: #uiAspect>

    optionSelectionHolder isNil ifTrue:[
        optionSelectionHolder := ValueHolder new.
        optionSelectionHolder addDependent:self.
    ].
    ^ optionSelectionHolder.

    "Modified: / 14-02-2012 / 18:26:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

optionSelectionHolder:something
    "set the 'optionSelectionHolder' value holder (automatically generated)"

    |oldValue newValue|

    optionSelectionHolder notNil ifTrue:[
        oldValue := optionSelectionHolder value.
        optionSelectionHolder removeDependent:self.
    ].
    optionSelectionHolder := something.
    optionSelectionHolder notNil ifTrue:[
        optionSelectionHolder addDependent:self.
    ].
    newValue := optionSelectionHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:optionSelectionHolder.
    ].
!

optionValueHolder
    "return/create the 'optionValueHolder' value holder (automatically generated)"

    optionValueHolder isNil ifTrue:[
        optionValueHolder := ValueHolder new.
        optionValueHolder addDependent:self.
    ].
    ^ optionValueHolder
!

optionValueHolder:something
    "set the 'optionValueHolder' value holder (automatically generated)"

    |oldValue newValue|

    optionValueHolder notNil ifTrue:[
        oldValue := optionValueHolder value.
        optionValueHolder removeDependent:self.
    ].
    optionValueHolder := something.
    optionValueHolder notNil ifTrue:[
        optionValueHolder addDependent:self.
    ].
    newValue := optionValueHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:optionValueHolder.
    ].
! !

!AbstractSettingsApplication::ToolboxSettingsAppl::ClassToolSetting methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == optionSelectionHolder ifTrue:[
        | idx |

        idx := self optionSelectionHolder value.
        self optionCustomValueVisibleHolder value: (idx == optionLabelList value size).
        idx <= optionValueList size ifTrue:[
            self optionValueHolder value: (optionValueList at: idx)
        ].
         ^ self.
    ].
    changedObject == optionCustomValueVisibleHolder ifTrue:[
        self window notNil ifTrue:[
            optionCustomValueVisibleHolder value ifTrue:[
                self window height: 60
            ] ifFalse:[
                self window height: 30
            ]
        ]
    ].

    changedObject == optionValueHolder ifTrue:[
        | idx |

        self optionSelectionHolder value: ((optionValueList ? #()) indexOf: optionValueHolder value ifAbsent:[optionLabelList value size]).
        self optionCustomValueHolder value: optionValueHolder value.

    ].


    super update:something with:aParameter from:changedObject

    "Modified: / 14-02-2012 / 19:01:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSettingsApplication::ToolsSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ToolsSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#autoRaiseTranscript
'Autoraise the Transcript window when messages are added'

#useNewFileBrowser
'Use the new, improved FileBrowser (as opposed to the simpler, older version)'

#useNewSystemBrowser
'Use the new, improved SystemBrowser (as opposed to the simpler, older version)'

#useHierarchicalInspector
'Use the new, hierarchical inspector (unfinished, experimental)'

#showDidYouKnowTips
'Show the "Did you Know?" tip browser at startup'

#showClockInLauncher
'Show the current time in the Launcher'

#transcriptBufferSize
'Number of lines that are remembered in the Transcript'

#useSmalltalkDocumentView
'Use the builtIn HTML-Viewer, as opposed to the systems webBrowser (firefox, internet-explorer, etc.)'

#eclipseStyleMenus
'Use different menu layout in some tools, useful if you are used to the eclipse IDE'
)

    "Modified: / 09-08-2012 / 09:34:41 / cg"
! !

!AbstractSettingsApplication::ToolsSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons"

    ^ Icon
        constantNamed:#'AbstractSettingsApplication::ToolsSettingsAppl class defaultIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray
                            fromPackedString:'
******************************@@@@@@@@@@@@@J(@@@@@@@@@@@@@* @@@F(QD@@@@@B*@@@@B((QD@@@@J(@@@@@@JLQ@@@@* @B$@@@)CD@@@B*@@
IC$J*SPP@@@J(@BH@4MCQADP@@* AR"HACQAFQD@B*@@H""H"HEG$Q@J(@@@H"H("HP9$@* @@@@@"H""HI@B*@@@@@@@@H""H@J(@@@@@@@@@H" @* @@@@
@@@@@@H0B*@@@@@@@@@@@@@J(@@@@@@@@@@@@@* @@@@@@@@@@@@B*****************************(b');
                colorMapFromArray:#[ 0 0 0 160 160 160 240 240 240 224 224 224 48 48 48 128 128 128 208 208 208 112 112 112 192 192 192 96 96 96 176 176 176 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray
                                        fromPackedString:'@@@@@@@@@@@@@?@@@?0@@_8@GO<@G3<@G?>@G??@G?? G?? C?? @?? @G? @@_ @@G @@A @@@@@@@@@@@@@@@@');
                            yourself);
                yourself
        ]
! !

!AbstractSettingsApplication::ToolsSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::ToolsSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::ToolsSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::ToolsSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Tool Settings'
         name: 'Tool Settings'
         flags: 1
         min: (Point 10 10)
         bounds: (Rectangle 0 0 594 584)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 562 0)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Use the New System Browser'
                   name: 'NewSystemBrowser'
                   activeHelpKey: useNewSystemBrowser
                   visibilityChannel: false
                   model: useNewSystemBrowser
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New File Browser'
                   name: 'NewFileBrowser'
                   activeHelpKey: useNewFileBrowser
                   visibilityChannel: false
                   model: useNewFileBrowser
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New VersionDiff Browser'
                   name: 'VersionDiffBrowser'
                   model: useNewVersionDiffBrowser
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New FileTree File Dialog'
                   name: 'UseNewFileDialogCheckBox'
                   model: useNewFileDialog
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New Settings Dialog'
                   name: 'UseNewSettinsApplicationCheckBox'
                   visibilityChannel: false
                   model: useNewSettingsApplication
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New Process Monitor'
                   name: 'UseNewProcessMonitor'
                   model: useProcessMonitorV2
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New TestRunner2'
                   name: 'CheckBox3'
                   model: useTestRunner2
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New Changes Browser for Changefiles (not yet recommended)'
                   name: 'ChangesBrowser'
                   model: useNewChangesBrowser
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the New ChangeSet Browser for Internal ChangeSets'
                   name: 'CheckBox5'
                   model: useNewChangeSetBrowser
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use Hierarchical Inspector (not yet recommended)'
                   name: 'HierarchicalInspector'
                   activeHelpKey: useHierarchicalInspector
                   model: useNewInspector
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Use the Smalltalk Document Viewer'
                   name: 'UseSmalltalkDocumentViewer'
                   activeHelpKey: useSmalltalkDocumentView
                   model: useSmalltalkDocumentViewer
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel2'
                   horizontalLayout: leftFit
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'External Diff Tool:'
                         name: 'Label3'
                         activeHelpKey: transcriptBufferSize
                         translateLabel: true
                         resizeForLabel: true
                         adjust: left
                         useDefaultExtent: true
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         activeHelpKey: transcriptBufferSize
                         model: externalDiffCommandTemplate
                         type: string
                         immediateAccept: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         acceptOnPointerLeave: true
                         extent: (Point 480 30)
                       )
                      )

                   )
                   extent: (Point 594 35)
                 )
                (DividerSpec
                   name: 'Separator3'
                   extent: (Point 594 4)
                 )
                (CheckBoxSpec
                   label: 'Show "Tip Of The Day" at Startup'
                   name: 'CheckBox1'
                   activeHelpKey: showDidYouKnowTips
                   model: showTipOfTheDayAtStartup
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (CheckBoxSpec
                   label: 'Show Clock in Launcher'
                   name: 'Clock'
                   activeHelpKey: showClockInLauncher
                   model: showClockInLauncher
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (DividerSpec
                   name: 'Separator2'
                   extent: (Point 594 4)
                 )
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel1'
                   horizontalLayout: left
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box4'
                         extent: (Point 20 10)
                       )
                      (LabelSpec
                         label: 'Transcript''s Buffer Size:'
                         name: 'Label1'
                         activeHelpKey: transcriptBufferSize
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                         useDefaultExtent: true
                       )
                      (InputFieldSpec
                         name: 'Transcripts Buffer Size'
                         activeHelpKey: transcriptBufferSize
                         model: transcriptBufferSize
                         type: number
                         immediateAccept: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnLostFocus: true
                         numChars: 8
                         acceptOnPointerLeave: true
                         extent: (Point 78 30)
                       )
                      (LabelSpec
                         label: '(Lines)'
                         name: 'Label2'
                         activeHelpKey: transcriptBufferSize
                         translateLabel: true
                         resizeForLabel: true
                         adjust: right
                         useDefaultExtent: true
                       )
                      )

                   )
                   extent: (Point 594 35)
                 )
                (CheckBoxSpec
                   label: 'Autoraise Transcript'
                   name: 'CheckBox2'
                   activeHelpKey: autoRaiseTranscript
                   model: autoRaiseTranscript
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                (DividerSpec
                   name: 'Separator1'
                   extent: (Point 594 4)
                 )
                (CheckBoxSpec
                   label: 'Eclipse Style Menus (where implemented)'
                   name: 'CheckBox4'
                   activeHelpKey: eclipseStyleMenus
                   model: eclipseStyleMenus
                   translateLabel: true
                   extent: (Point 594 30)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::ToolsSettingsAppl methodsFor:'actions'!

basicReadSettings
    |transcript|

    super basicReadSettings.

    transcript := Transcript current.
    transcript isTextCollector ifTrue:[
        self transcriptBufferSize value:transcript lineLimit.
        "/ now already in userprefs
        "/ self autoRaiseTranscript value:transcript autoRaise.
    ].

    "Modified: / 29-08-2013 / 11:40:23 / cg"
!

basicSaveSettings
    |showClock launcher reopenLauncher newSystemBrowserClass transcript|

    reopenLauncher := false.

    newSystemBrowserClass := Tools::NewSystemBrowser ? NewSystemBrowser.

    super basicSaveSettings.

    currentUserPrefs useNewSettingsApplication ~= self useNewSettingsApplication value ifTrue:[
        currentUserPrefs useNewSettingsApplication:self useNewSettingsApplication value.
    ].

    currentUserPrefs useNewSystemBrowser ~= self useNewSystemBrowser value ifTrue:[
        currentUserPrefs useNewSystemBrowser:self useNewSystemBrowser value.
            (self useNewSystemBrowser value and:[newSystemBrowserClass isLoaded]) ifTrue:[
                newSystemBrowserClass installInLauncher.
            ] ifFalse:[
                newSystemBrowserClass removeFromLauncher.
            ].
            reopenLauncher := true.
    ].

    (Smalltalk at:#FileBrowserV2) isBehavior ifTrue:[
        currentUserPrefs useNewFileBrowser ~= self useNewFileBrowser value ifTrue:[
            currentUserPrefs useNewFileBrowser:self useNewFileBrowser value.
            (self useNewFileBrowser value and:[FileBrowserV2 isLoaded]) ifTrue:[
                FileBrowserV2 installInLauncher.
            ] ifFalse:[
                FileBrowserV2 removeFromLauncher.
            ].
            reopenLauncher := true.
        ]
    ].

    transcript := Transcript current.
    (transcript notNil and:[transcript isExternalStream not]) ifTrue:[
        transcript lineLimit:self transcriptBufferSize value.
        "/ now already done by UserPreferences
        "/ transcript autoRaise:self autoRaiseTranscript value.
        launcher := transcript application.
    ].

    showClock := self showClockInLauncher value.
    currentUserPrefs showClockInLauncher ~= showClock ifTrue:[
        currentUserPrefs showClockInLauncher:showClock.
        launcher notNil ifTrue:[
            showClock ifTrue:[
                launcher startClock
            ] ifFalse:[
                launcher stopClock
            ]
        ]
    ].
    Inspector := currentUserPrefs inspectorClassSetting.

    reopenLauncher ifTrue:[
        launcher notNil ifTrue:[
            launcher reopenLauncher.
        ]
    ].

    "Modified: / 27-07-2012 / 20:51:46 / cg"
! !

!AbstractSettingsApplication::ToolsSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        #eclipseStyleMenus
        #useTestRunner2
        "/ #useCodeView2InTools
        #useNewInspector
        #useNewChangesBrowser
        #useNewChangeSetBrowser
        "/ #useNewSystemBrowser     -- no longer an option
        #useNewVersionDiffBrowser
        "/ #useNewFileBrowser       -- no longer an option
        #useNewFileDialog
        "/ #useNewSettingsApplication   -- no longer an option
        #useProcessMonitorV2
        #useSmalltalkDocumentViewer
        #showClockInLauncher
        #showTipOfTheDayAtStartup
        #externalDiffCommandTemplate
        #autoRaiseTranscript
    )

    "Created: / 27-07-2012 / 20:48:18 / cg"
!

autoRaiseTranscript
    autoRaiseTranscript isNil ifTrue:[
        autoRaiseTranscript := false asValue.
        autoRaiseTranscript onChangeSend:#updateModifiedChannel to:self
    ].
    ^ autoRaiseTranscript.

    "Modified: / 21-09-2006 / 00:39:54 / cg"
!

eclipseStyleMenus
    eclipseStyleMenus isNil ifTrue:[
        eclipseStyleMenus := false asValue.
        eclipseStyleMenus onChangeSend:#updateModifiedChannel to:self
    ].
    ^ eclipseStyleMenus.

    "Modified: / 21-09-2006 / 00:39:54 / cg"
    "Created: / 08-07-2011 / 13:42:13 / cg"
!

externalDiffCommandTemplate
    externalDiffCommandTemplate isNil ifTrue:[
        externalDiffCommandTemplate := UserPreferences current externalDiffCommandTemplate asValue.
        externalDiffCommandTemplate onChangeSend:#updateModifiedChannel to:self
    ].
    ^ externalDiffCommandTemplate.
!

showClockInLauncher
    showClockInLauncher isNil ifTrue:[
        showClockInLauncher := false asValue.
        showClockInLauncher onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showClockInLauncher.

    "Modified: / 21-09-2006 / 00:39:54 / cg"
!

showTipOfTheDayAtStartup
    showTipOfTheDayAtStartup isNil ifTrue:[
        showTipOfTheDayAtStartup := false asValue.
        showTipOfTheDayAtStartup onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showTipOfTheDayAtStartup.

    "Modified: / 21-09-2006 / 00:39:54 / cg"
!

transcriptBufferSize
    transcriptBufferSize isNil ifTrue:[
        transcriptBufferSize := 600 asValue. "/ Transcript current lineLimit asValue.
        transcriptBufferSize onChangeSend:#updateModifiedChannel to:self
    ].
    ^ transcriptBufferSize.
!

useCodeView2InTools
    useCodeView2InTools isNil ifTrue:[
        useCodeView2InTools := ValueHolder new.
        useCodeView2InTools onChangeSend:#updateModifiedChannel to:self

    ].
    ^ useCodeView2InTools

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useNewChangeSetBrowser
    useNewChangeSetBrowser isNil ifTrue:[
        useNewChangeSetBrowser := false asValue.
        useNewChangeSetBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewChangeSetBrowser.

    "Modified: / 21-09-2006 / 00:39:37 / cg"
    "Created: / 27-07-2012 / 20:45:41 / cg"
!

useNewChangesBrowser
    useNewChangesBrowser isNil ifTrue:[
        useNewChangesBrowser := false asValue.
        useNewChangesBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewChangesBrowser.

    "Modified: / 21-09-2006 / 00:39:37 / cg"
!

useNewFileBrowser
    useNewFileBrowser isNil ifTrue:[
        useNewFileBrowser := true asValue.
        useNewFileBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewFileBrowser.

    "Modified: / 21-09-2006 / 00:39:19 / cg"
!

useNewFileDialog
    useNewFileDialog isNil ifTrue:[
        useNewFileDialog := true asValue.
        useNewFileDialog onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewFileDialog.
!

useNewInspector
    useNewInspector isNil ifTrue:[
        useNewInspector := false asValue.
        useNewInspector onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewInspector.

    "Modified: / 21-09-2006 / 00:38:41 / cg"
!

useNewSettingsApplication
    useNewSettingsApplication isNil ifTrue:[
        useNewSettingsApplication := true asValue.
        useNewSettingsApplication onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewSettingsApplication.
!

useNewSystemBrowser
    useNewSystemBrowser isNil ifTrue:[
        useNewSystemBrowser := true asValue.
        useNewSystemBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewSystemBrowser.

    "Modified: / 21-09-2006 / 00:39:02 / cg"
!

useNewVersionDiffBrowser
    useNewVersionDiffBrowser isNil ifTrue:[
        useNewVersionDiffBrowser := true asValue.
        useNewVersionDiffBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useNewVersionDiffBrowser.

    "Modified: / 21-09-2006 / 00:38:56 / cg"
!

useProcessMonitorV2
    useProcessMonitorV2 isNil ifTrue:[
        useProcessMonitorV2 := true asValue.
        useProcessMonitorV2 onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useProcessMonitorV2.

    "Modified: / 21-09-2006 / 00:38:50 / cg"
!

useSmalltalkDocumentViewer
    useSmalltalkDocumentViewer isNil ifTrue:[
        useSmalltalkDocumentViewer := nil asValue.
        useSmalltalkDocumentViewer onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useSmalltalkDocumentViewer.

    "Modified: / 21-09-2006 / 00:03:13 / cg"
!

useTestRunner2
    useTestRunner2 isNil ifTrue:[
        useTestRunner2 := true asValue.
        useTestRunner2 onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useTestRunner2.

    "Modified: / 21-09-2006 / 00:39:19 / cg"
    "Created: / 06-07-2011 / 13:52:33 / cg"
! !

!AbstractSettingsApplication::ToolsSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/toolSettings.html'
! !

!AbstractSettingsApplication::ToolsSettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    |transcript|

    super hasUnsavedChanges ifTrue:[^ true].

    transcript := Transcript current.
    transcript isTextCollector ifTrue:[
        (self transcriptBufferSize value  ~= transcript lineLimit) ifTrue:[^ true].
        "/ now already in UserPreferences
        "/ (self autoRaiseTranscript value  ~= transcript autoRaise) ifTrue:[^ true].
    ].
    ^ false.

    "Modified: / 29-08-2013 / 11:40:55 / cg"
! !

!AbstractSettingsApplication::WorkspaceSettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:AbstractSettingsApplication::ProcessorSchedulerSettingsAppl
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#usersModuleName
'The name used as top-level module name (in the package-identifier) of your own classes and methods).\Will also be the top-level directory name inside the source code repository\and inside your workspace.'

#workspaceDirectory
'The workspace directory where files are created for building and deployment'

)
! !

!AbstractSettingsApplication::WorkspaceSettingsAppl class methodsFor:'image specs'!

defaultIcon
    ^ self defaultIcon2
!

defaultIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::WorkspaceSettingsAppl defaultIcon1'
        ifAbsentPut:[(Depth4Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AH@@@@@@@@@@@@@@AH@@@@@@@@@@@HP@UTP@R@@@@@@@@MQEU
UQES@@@@@@@@@%UUUUT @@@@@@@@@UT#H%TP@@@@@@@@EUH0@2UQ@@@@@@@QUULDPCUUDP@@@@@3UUHDPBUUL0@@@@@@H%TP@UT"@@@@@@@@@%UQEUT @@@@
@@@@@UUUUUTP@@@@@@@@ESIUURMQ@@@@@@@@H0@UTP@2@@@@@@@@@@@AL@@@@@@@@@@@@@@AL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 0 0 255 255 255 161 161 165 127 127 127 236 233 216 194 194 194] mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@A @@C0@@33@A?? A?? @??@@??@C??0G??8G??8C??0@??@@??@A?? A?? @33@@C0@@A @@@@@@@@@@@@@'); yourself); yourself]
!

defaultIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSettingsApplication::WorkspaceSettingsAppl defaultIcon2'
        ifAbsentPut:[(Depth8Image width:24 height:24) bits:(ByteArray fromPackedString:'
@@]YVU%YA0@@@@@@@@@@@@@@@@@@@@@@@E%]WV!!]VP@@@@@@@@@@@@@@@@@@@@@@Q8X,BP$IU5]MSUUU[6=MH0@@@@@@@@@@\TZ (CT"%2^$!!C\]^JT6X @@
@@@@@@@@\U(TEB TUJEP&DM''S5!!\#0@@@@@@@@@@JWR@RR<LP1=E$GVYD @@^0@@@@@@@@@@%Q\;I!!=_\1%)F0-?@@DB@@@@@@@@@@@@BH,?X6L[B4,@@C1
@@DB@@@@@@@@@@@@IH0UX@9 L0@B@P@@@PTE@P@@@PH@@@@@RG80LE9^  @CAPDAAPTEAPDAAPL@@@@@^*M&&))=GA0@@ TEAPTEAPTE@ @@@@@@''%L-TVU,
DRD@@PTE@ LB@ TE@P@@@@@@HEHVQA!!D@@@AAPTB@0@@@0HEAPD@@@@@LSH=OS4@@PDEAPTC@C4=@@LEAPTA@P@@\IQNPG\@@0LEAPTB@G]7@@HEAPTC@0@@
@@@@@@@@@@@B@ TE@P@@@PTE@ H@@@@@@@@@@@@@@@@@@ TEAPDAAPTE@ @@@@@@@@@@@@@@@@@@@PTEAPTEAPTE@P@@@@@@@@@@@@@@@@@AAPHBAPTEAPHC
APD@@@@@@@@@@@@@@@@B@ @@@PTE@P@@@0H@@@@@@@@@@@@@@@@@@@@@@@TB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') colorMapFromArray:#[0 0 0 255 255 255 161 161 165 127 127 127 236 233 216 194 194 194 162 194 216 161 179 191 110 142 163 154 183 200 109 140 160 170 200 219 182 208 224 191 196 201 163 195 217 136 178 205 197 202 208 132 176 205 171 200 219 157 192 214 193 214 229 164 195 217 131 171 195 176 208 227 128 171 196 174 203 222 196 203 209 171 200 220 143 183 209 194 219 234 131 171 196 178 205 223 102 137 158 134 176 205 210 229 242 132 159 177 108 141 161 142 182 208 179 205 223 204 225 238 193 214 227 114 144 163 150 188 211 135 179 206 153 182 200 134 178 204 165 200 224 183 209 224 154 190 212 102 135 156 87 124 149 162 195 216 134 179 206 209 228 240 190 216 236 194 221 235 142 182 206 128 169 196 190 195 200 178 205 222 164 197 217 87 125 149 160 194 216 172 200 219 195 201 206 106 140 161 167 198 218 180 207 223 129 171 196 176 205 223 209 229 243 133 160 177 107 140 161 183 208 224 130 171 196 168 200 218 148 189 216 111 144 166 198 203 209 176 204 221 188 210 224 133 178 205 126 173 205 132 179 214 191 212 228 112 144 166 150 188 212 111 144 165 174 201 219 119 151 171 194 216 232 170 200 218 175 203 225 165 197 218 153 190 212 177 205 223 163 195 216 188 193 198 112 144 163 172 201 220 195 200 205 131 178 205 143 184 208 179 205 222 164 197 218 175 202 221 187 192 197 159 193 215 133 179 205 140 185 213 192 197 202 113 144 166 199 207 214 114 146 165 100 137 159 176 205 222 181 207 228 173 203 221 128 175 205 193 198 203 191 217 233 139 182 208 102 138 159 112 143 163 168 200 224 144 183 209 153 191 217 169 200 219 181 208 224 166 198 218 152 189 212 189 194 200 200 222 237 188 194 199 109 143 165 186 191 196 153 194 221 132 179 205 142 183 208 173 204 227 158 197 224 136 179 206 149 188 211 111 144 163 174 204 220 158 193 214 156 192 213 162 197 221 201 206 211 112 143 164 101 137 158 208 226 242 185 208 225 173 202 220 144 184 209 156 192 214 129 169 196 133 182 214 101 137 159 111 142 163 209 228 242 187 210 224 108 142 162 140 186 214 204 224 237 189 215 232] mask:((ImageMask width:24 height:24) bits:(ByteArray fromPackedString:'_ @@_ @@??<@??<@??<@??<@??<@??<0???8???8???0???0???<???>???>@??<@O?0@O?0@_?8@_?8@L<0@@<@@@X@@@@@'); yourself); yourself]
! !

!AbstractSettingsApplication::WorkspaceSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractSettingsApplication::WorkspaceSettingsAppl andSelector:#windowSpec
     AbstractSettingsApplication::WorkspaceSettingsAppl new openInterface:#windowSpec
     AbstractSettingsApplication::WorkspaceSettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'Workspace Settings'
         name: 'Workspace Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 600 320)
       )
       component:
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel2'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             horizontalLayout: fit
             verticalLayout: topSpace
             horizontalSpace: 3
             verticalSpace: 5
             component:
            (SpecCollection
               collection: (
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel1'
                   activeHelpKey: usersModuleName
                   horizontalLayout: leftSpaceFit
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Top Level Module ID:'
                         name: 'Label1'
                         translateLabel: true
                         adjust: left
                         extent: (Point 200 22)
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         model: usersModuleName
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                         useDefaultExtent: true
                       )
                      )

                   )
                   extent: (Point 600 35)
                 )
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel2'
                   activeHelpKey: workspaceDirectory
                   horizontalLayout: leftSpaceFit
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Workspace Directory:'
                         name: 'Label2'
                         translateLabel: true
                         adjust: left
                         extent: (Point 200 22)
                       )
                      (InputFieldSpec
                         name: 'EntryField2'
                         model: workspaceDirectory
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                         useDefaultExtent: true
                       )
                      )

                   )
                   extent: (Point 600 35)
                 )
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel3'
                   activeHelpKey: workspaceDirectory
                   horizontalLayout: rightSpace
                   verticalLayout: center
                   horizontalSpace: 3
                   verticalSpace: 3
                   component:
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Create Workspace Directory'
                         name: 'Button1'
                         translateLabel: true
                         model: createWorkspaceDirectory
                         useDefaultExtent: true
                       )
                      (ActionButtonSpec
                         label: 'Browse'
                         name: 'Button2'
                         translateLabel: true
                         model: browseWorkspaceDirectory
                         useDefaultExtent: true
                       )
                      )

                   )
                   extent: (Point 600 35)
                 )
                )

             )
           )
          )

       )
     )
! !

!AbstractSettingsApplication::WorkspaceSettingsAppl methodsFor:'actions'!

browseWorkspaceDirectory
    |fn|

    (fn := workspaceDirectory value) notEmptyOrNil ifTrue:[
        (fn := fn asFilename) exists ifFalse:[
            Dialog warn:'Directory does not exist'.
        ] ifTrue:[
            UserPreferences current fileBrowserClass openOn:fn
        ]
    ]
!

createWorkspaceDirectory
    |fn|

    (fn := workspaceDirectory value) notEmptyOrNil ifTrue:[
        (fn := fn asFilename) exists ifFalse:[
            fn recursiveMakeDirectory
        ]
    ]
! !

!AbstractSettingsApplication::WorkspaceSettingsAppl methodsFor:'aspects'!

aspects
    ^ #(
        #usersModuleName
        #workspaceDirectory
    )
!

usersModuleName
    usersModuleName isNil ifTrue:[
        usersModuleName := '' asValue.
        usersModuleName onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ usersModuleName.
!

workspaceDirectory
    workspaceDirectory isNil ifTrue:[
        workspaceDirectory := '~/.smalltalk/workspace' asValue.
        workspaceDirectory onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ workspaceDirectory.
! !

!AbstractSettingsApplication::WorkspaceSettingsAppl methodsFor:'help'!

helpFilename
    ^ 'Launcher/workspaceSettings.html'
! !

!AbstractSettingsApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

