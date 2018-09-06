"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

IdentityDictionary subclass:#UserPreferences
	instanceVariableNames:'modified'
	classVariableNames:'CurrentPreferences DefaultPreferences'
	poolDictionaries:''
	category:'System-Support'
!

!UserPreferences class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2009-2011 Jan Vrany
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
    A Dictionary for user preference values.
    For non-existing keys, either a defaultValue (false),
    or the value from a defaultDictionary is returned.

    This will eventually keep track of ALL user preferences.
    For now, not all preferences are found here -
    (some of them are currently spread over the system - especially, in Class-Variables)
    - but this will change over time.

    If more prefs are added, think about adding a corresponding UI to the SystemSettingsDialog too.

    Notice, that ST/X is intended to be multi-user capable, supporting multiple users on multiple screens.
    This is effectively used by (at least) 2 ST/X customers we are aware of (for multi-screen applications).
    So do not break it, by putting user-specific stuff into class variables.

    Usage:
        UserPreferences current at:#foo
    or
        UserPreferences current at:#foo put:something
"
! !

!UserPreferences class methodsFor:'initialization'!

initializeDefaultsIn:preferences
    Color isNil "Smalltalk isStandAloneApp" ifTrue:[
        ^ self.
    ].
    Color initialize.

    #(
        #useNewChangesBrowser           false
        #useNewInspector                false
        #showClockInLauncher            true

        #autoFormatting                 false
        #syntaxColoring                 true
        #fullSelectorCheck              false

        #defaultSyntaxColor             (Color black)
        #defaultSyntaxEmphasis          normal

        #errorColor                     (Color red)

        "/ #commentColor                   (Color 12.5 12.5 100)
        #commentColor                   (Color 0 50 0)
        #commentEmphasis                normal

        #methodSelectorEmphasis         bold
        #selectorEmphasis               bold
        #unimplementedSelectorColor     (Color red)
        #unimplementedSelectorEmphasis  normal

        "/ I prefer red-underwave over red identifier ...
        "/      #badIdentifierColor                 (Color red)
        #instVarIdentifierColor         (Color 33 0 33)

        "/ I prefer redish background
        "/      #sideEffectAssignmentColor          (Color 75 0 0)
        "/ #sideEffectAssignmentBackgroundColor    (Color 100 86 86)

        #jsKeywordEmphasis              bold
        "/ #jsKeywordColor                 (Color black)
        #jsKeywordColor                 (Color 33 33 0)

        #controlFlowSelectorColor       (Color 0 0 100)
        #debugSelectorColor             (Color 80 0 0)
        #errorRaisingSelectorColor      (Color 80 0 0)
        "/ #constantColor                  (Color 25 0 0)
        #constantColor                  (Color 64 8 8)

        #globalIdentifierColor          (Color 67 0 67)
        #unknownIdentifierColor         (Color 67 0 67)

        #returnColor                    (Color 0 0 100)
        #returnEmphasis                 bold
     ) pairWiseDo:[:k :v |
        preferences at:k put:(v decodeAsLiteralArray).
    ].

    "/ I prefer red-underwave over red identifier ...
    preferences at:#badIdentifierEmphasis put:(Array with:#underwave with:(#underlineColor->Color red)).

    "
     self initializeDefaultPreferences
    "

    "Created: / 06-06-2016 / 10:42:14 / cg"
! !

!UserPreferences class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ super new initialize.

    "Modified: / 07-06-2017 / 11:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences class methodsFor:'accessing'!

current
    CurrentPreferences isNil ifTrue:[
        CurrentPreferences := self new.
        CurrentPreferences flyByHelpSettingChanged.
    ].
    "/ The #value message allows CurrentPrefences to be a block (or anything
    "/ that responds to #value) that returns different preferences in different
    "/ contexts. For example, each screen might have different user with
    "/ different settings.
    ^ CurrentPreferences value.

    "
     CurrentPreferences := nil
    "

    "Modified: / 06-06-2016 / 10:42:59 / cg"
    "Modified: / 07-06-2017 / 12:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

default
    DefaultPreferences isNil ifTrue:[
        DefaultPreferences := self new.
    ].
    ^ DefaultPreferences.

    "
     DefaultPreferences := nil.
    "

    "Modified: / 06-06-2016 / 10:41:45 / cg"
    "Modified: / 07-06-2017 / 11:33:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset
    "resets the CurrentPreferences to its default values"

    CurrentPreferences := nil
!

setCurrent:preferencesInstance
    "sets the CurrentPreferences to preferencesInstance"

    CurrentPreferences := preferencesInstance
!

syntaxColorKeys
    "returns the keys of syntax color items"

    ^ self syntaxColorNamesAndKeys collectAll:[:each | each from:2]

    "
     self syntaxColorKeys
    "

"/    ^#(
"/        argumentIdentifierColor
"/          argumentIdentifierEmphasis
"/        booleanConstantColor
"/          booleanConstantEmphasis
"/        bracketColor
"/          bracketEmphasis
"/        classVariableIdentifierColor
"/          classVariableIdentifierEmphasis
"/        constantColor
"/          constantEmphasis
"/        controlFlowSelectorColor
"/          controlFlowSelectorEmphasis
"/        commentColor
"/          commentEmphasis
"/        defaultSyntaxColor
"/          defaultSyntaxEmphasis
"/        errorColor
"/        globalIdentifierColor
"/          globalIdentifierEmphasis
"/        globalClassIdentifierColor
"/          globalClassIdentifierEmphasis
"/        hereColor
"/          hereEmphasis
"/        identifierColor
"/          identifierEmphasis
"/        instVarIdentifierColor
"/          instVarIdentifierEmphasis
"/        localIdentifierColor
"/          localIdentifierEmphasis
"/        methodSelectorColor
"/          methodSelectorEmphasis
"/        poolVariableIdentifierColor
"/          poolVariableIdentifierEmphasis
"/        returnColor
"/          returnEmphasis
"/        selectorColor
"/          selectorEmphasis
"/        selfColor
"/          selfEmphasis
"/        stringColor
"/          stringEmphasis
"/        superColor
"/          superEmphasis
"/        symbolColor
"/          symbolEmphasis
"/        thisContextColor
"/          thisContextEmphasis
"/        unknownIdentifierColor
"/          unknownIdentifierEmphasis
"/        unimplementedSelectorColor
"/          unimplementedSelectorEmphasis
"/        sideEffectAssignmentBackgroundColor
"/          sideEffectAssignmentColor
"/        colorForInstrumentedFullyCoveredCode
"/            emphasisForInstrumentedFullyCoveredCode
"/        colorForInstrumentedPartiallyCoveredCode
"/            emphasisForInstrumentedPartiallyCoveredCode
"/        colorForInstrumentedNeverCalledCode
"/            emphasisForInstrumentedNeverCalledCode
"/    )

    "Modified: / 14-02-2012 / 10:17:46 / cg"
!

syntaxColorNames
    "returns the syntax colors for the settings in the launcher"

    ^ self syntaxColorNamesAndKeys collect:#first.

"/"/ warning, the strings below are presented to the user
"/"/ as the syntax-color boxes comboList - however, they are
"/"/ also used (without separators) as key into myself.
"/"/ Therefore, do not change the strings below.
"/"/ I know - this is bad coding ....
"/
"/^#(
"/'Argument Identifier Color'
"/'Boolean Constant Color'
"/'Bracket Color'
"/'Class Variable Identifier Color'
"/'Collection Enumeration Selector Color'
"/'Constant Color'
"/'Control Flow Selector Color'
"/'Comment Color'
"/'Debug Selector Color'
"/'Error Raising Selector Color'
"/'Global Identifier Color'
"/'Global Class Identifier Color'
"/'Here Color'
"/'Identifier Color'
"/'InstVar Identifier Color'
"/'Local Identifier Color'
"/'Method Selector Color'
"/'Pool Variable Identifier Color'
"/'Return Color'
"/'Selector Color'
"/'Self Color'
"/'Side Effect Assignment Color'
"/'Side Effect Assignment Background Color'
"/'String Color'
"/'Super Color'
"/'Symbol Color'
"/'This Context Color'
"/'Unknown Identifier Color'
"/'Unimplemented Selector Color'
"/'Side Effect Assignment Color'
"/'Coverage: Reached Color'
"/'Coverage: Partially Reached Color'
"/'Coverage: Unreached Color'
"/)

    "Modified: / 14-02-2012 / 15:51:38 / cg"
!

syntaxColorNamesAndKeys
    "returns the names and keys of syntax color items"

    ^#(
	(
	  'Argument Identifier Color'
	  argumentIdentifierColor
	  argumentIdentifierEmphasis
	)
	(
	  'Boolean Constant Color'
	  booleanConstantColor
	  booleanConstantEmphasis
	)
	(
	  'Bracket Color'
	  bracketColor
	  bracketEmphasis
	)
	(
	  'Class Variable Identifier Color'
	  classVariableIdentifierColor
	  classVariableIdentifierEmphasis
	)
	(
	  'Constant Color'
	  constantColor
	  constantEmphasis
	)
	(
	  'Control Flow Selector Color'
	  controlFlowSelectorColor
	  controlFlowSelectorEmphasis
	)
	(
	  'Comment Color'
	  commentColor
	  commentEmphasis
	)
	(
	  'Collection Enumeration Selector Color'
	  collectionEnumerationSelectorColor
	  collectionEnumerationSelectorEmphasis
	)
	(
	  'Debug Selector Color'
	  debugSelectorColor
	  debugSelectorEmphasis
	)
	(
	  'Default Syntax Color'
	  defaultSyntaxColor
	  defaultSyntaxEmphasis
	)
	(
	  'Error Raising Selector Color'
	  errorColor
	  errorEmphasis
	)
	(
	  'Global Identifier Color'
	  globalIdentifierColor
	  globalIdentifierEmphasis
	)
	(
	  'Global Class Identifier Color'
	  globalClassIdentifierColor
	  globalClassIdentifierEmphasis
	)
	(
	  'Here Color'
	  hereColor
	  hereEmphasis
	)
	(
	  'Identifier Color'
	  identifierColor
	  identifierEmphasis
	)
	(
	  'InstVar Identifier Color'
	  instVarIdentifierColor
	  instVarIdentifierEmphasis
	)
	(
	  'Local Identifier Color'
	  localIdentifierColor
	  localIdentifierEmphasis
	)
	(
	  'Method Selector Color'
	  methodSelectorColor
	  methodSelectorEmphasis
	)
	(
	  'Pool Variable Identifier Color'
	  poolVariableIdentifierColor
	  poolVariableIdentifierEmphasis
	)
	(
	  'Return Color'
	  returnColor
	  returnEmphasis
	)
	(
	  'Selector Color'
	  selectorColor
	  selectorEmphasis
	)
	(
	  'Self Color'
	  selfColor
	  selfEmphasis
	)
	(
	  'String Color'
	  stringColor
	  stringEmphasis
	)
	(
	  'Super Color'
	  superColor
	  superEmphasis
	)
	(
	  'Symbol Color'
	  symbolColor
	  symbolEmphasis
	)
	(
	  'This Context Color'
	  thisContextColor
	  thisContextEmphasis
	)
	(
	  'Unknown Identifier Color'
	  unknownIdentifierColor
	  unknownIdentifierEmphasis
	)
	(
	  'Unimplemented Selector Color'
	  unimplementedSelectorColor
	  unimplementedSelectorEmphasis
	)
	(
	  'Side Effect Assignment Color'
	  sideEffectAssignmentColor
	  sideEffectAssignmentColorEmphasis
	)
	(
	  'Side Effect Assignment Background Color'
	  sideEffectAssignmentBackgroundColor
	  sideEffectAssignmentBackgroundColorEmphasis
	)
	(
	  'Coverage: Reached Color'
	  colorForInstrumentedFullyCoveredCode
	  emphasisForInstrumentedFullyCoveredCode
	)
	(
	  'Coverage: Partially Reached Color'
	  colorForInstrumentedPartiallyCoveredCode
	  emphasisForInstrumentedPartiallyCoveredCode
	)
	(
	  'Coverage: Unreached Color'
	  colorForInstrumentedNeverCalledCode
	  emphasisForInstrumentedNeverCalledCode
	)
    )

    "Modified: / 14-02-2012 / 10:17:46 / cg"
! !

!UserPreferences class methodsFor:'accessing - defaults'!

defaultUserSettingsFile
    "Return default user settings file."

    ^self defaultUserSettingsFileLocations first.
    "
    UserPreferences defaultUserSettingsFile
    "

    "Created: / 06-10-2008 / 08:27:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-06-2017 / 11:29:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-06-2017 / 21:47:46 / jv"
!

defaultUserSettingsFileLocations
    "Return list of files which are probed when looking for
     saved user settings.

     The location changed over the time. To be backward
     compatible, return all of them.
    "
    ^ {
        (Filename usersPrivateSmalltalkDirectory / 'settings.stx') .         "/ per-user settings file (new default?)
        (Filename usersPrivateSmalltalkDirectory / 'settings.rc') .          "/ for backward compatibility with jv-branch
    } , (
        Smalltalk realSystemPath collect: [ :e|e asFilename / 'settings.stx']"/ per-user settings file (new default?)
    ) , (
        Smalltalk realSystemPath collect: [ :e|e asFilename / 'settings.rc'] "/ for backward compatibility with jv-branch
    )

    "
    UserPreferences defaultUserSettingsFileLocations
    "

    "Created: / 07-06-2017 / 21:46:43 / jv"
    "Modified: / 31-07-2017 / 20:48:28 / jv"
!

defaultWorkspaceDirectory
    ^ (Filename usersPrivateSmalltalkDirectory) / 'workspace'
! !

!UserPreferences class methodsFor:'accessing defaultPrefs'!

defaultSettingsFilename
    ^ 'settings.stx'
!

fileBrowserClass
    "the class to be used for file browsing (used to be the simple FileBrowser, but is now the FileBrowserV2)"

    ^ self current fileBrowserClass

    "
     UserPreferences fileBrowserClass
    "

    "Modified: / 17-07-2010 / 14:50:34 / cg"
!

systemBrowserClass
    ^ self current systemBrowserClass

    "
     UserPreferences systemBrowserClass
    "
!

versionDiffViewerClass
    ^ self current versionDiffViewerClass

    "
     UserPreferences versionDiffViewerClass
    "
! !

!UserPreferences class methodsFor:'load / save'!

loadSettings
    "Load and return default user settings. Probe all files specified specified
     in #defaultUserSettingsFileLocations. First found is used, the rest is ignored.
    "

    self defaultUserSettingsFileLocations do:[:file |
        file exists ifTrue:[
            file isDirectory ifTrue:[
                Logger warning: 'user settings file is actually a directory: %1' with: file pathName.
            ] ifFalse:[
                file isReadable ifFalse:[
                    Logger warning: 'user settings file is not readable, skipping: %1' with: file pathName.
                ] ifTrue:[
                    ^ self loadSettingsFrom: file
                ].
            ]
        ]
    ].
    ^ self new.

    "
    UserPreferences loadSettings.
    "

    "Created: / 07-06-2017 / 11:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-06-2017 / 21:50:56 / jv"
!

loadSettingsFrom: aStringOrFilename
    "Load previously stored settings from given file. Returns loaded settings."

    | prefsFile prefs currentProcess currentPrefs |

    prefsFile := aStringOrFilename.
    (prefsFile isReadable not or:[prefsFile isRegularFile not]) ifTrue:[
        self error: 'File not readable or not a regular file'
    ].
    "/ Currently format of user preferences is actually an executable
    "/ smalltalk code that is evaluated. That code fills in values in
    "/ `UserPreferences current`. This way, it's not possible to load
    "/ previously saved preferences to some other objects.
    "/
    "/ So, in order to load preferences we need to temporarily
    "/ swap `UserPreferences current` to pristine instance, load
    "/ preferences and then restore old preferences.
    "/
    "/ Things are more complicated since someone may access preferences
    "/ while loading. Therefore, answer old preferences except for
    "/ current process which is loading new ones.
    "/
    "/ What a hack!!
    currentPrefs := CurrentPreferences.
    currentProcess := Processor activeProcess.
    [
        prefs := self new.
        CurrentPreferences := [
            Processor activeProcess == currentProcess
                ifTrue:[ prefs ]
                ifFalse:[ currentPrefs value ]
        ].
        prefsFile fileIn.
        prefs at:#settingsFilename put: prefsFile pathName.
    ] ensure:[
        CurrentPreferences := currentPrefs.
    ].
    ^ prefs

    "
    UserPreferences loadSettingsFrom: self defaultUserSettingsFile.

    | file |

    file := Filename newTemporary.
    [
        file writingFileDo:[:s| s nextPutLine: 'UserPreferences current at: #xxx put: #yyy' ].
        UserPreferences loadSettingsFrom: file
    ] ensure:[
        file remove.
    ].
    "

    "Created: / 07-06-2017 / 11:46:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-06-2017 / 13:25:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveSettings:userPrefs in:fileNameOrString
    "save settings to a settings-file."

    "a temporary kludge for old classVariable-based settings
     - all of those MUST go into the user-preferences dictionary eventually"

    |screen fileName dir|

    fileName := fileNameOrString asFilename.

    screen := Screen current.

    (dir := fileName directory) exists ifFalse:[
        dir recursiveMakeDirectory.
    ].
    fileName writingFileDo:[:s|
        s nextPutLine:'"/ ST/X saved settings';
          nextPutLine:'"/ DO NOT MODIFY MANUALLY';
          nextPutLine:'"/ (modifications would be lost with next save-settings)';
          nextPutLine:'"/';
          nextPutLine:'"/ this file was automatically generated by the';
          nextPutLine:'"/ ''save settings'' function of the SettingsDialog';
          nextPutLine:'"/'.
        s cr.

        s nextPutLine:'"/'.
        s nextPutLine:'"/ saved by ' , OperatingSystem getLoginName , '@' , OperatingSystem getHostName , ' at ' , Timestamp now printString.
        s nextPutLine:'"/'.
        s cr.

        s nextPutLine:'"/'.
        s nextPutLine:'"/ Display settings:'.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ only restore the display settings, if on the same Display ...'.
        s nextPutLine:'Display notNil ifTrue:['.
        s nextPutLine:' Display displayName = ' , (screen displayName storeString) , ' ifTrue:['.
          screen fixColors notNil ifTrue:[
            s nextPutLine:'  Image flushDeviceImages.'.
            s nextPutLine:'  Color colorAllocationFailSignal catch:['.
            s nextPutLine:'    Color getColorsRed:6 green:6 blue:4 on:Display'.
            s nextPutLine:'  ].'.
          ] ifFalse:[
            s nextPutLine:'  Display releaseFixColors.'.
          ].
          s nextPutLine:'  Display hasColors: ' , (screen hasColors storeString) , '.'.
          s nextPutLine:'  Display widthInMillimeter: ' , (screen widthInMillimeter storeString) , '.'.
          s nextPutLine:'  Display heightInMillimeter: ' , (screen heightInMillimeter storeString) , '.'.
          s nextPutLine:'  Display supportsDeepIcons: ' , (screen supportsDeepIcons storeString) , '.'.
          s nextPutLine:'  Image ditherAlgorithm: ' , (Image ditherAlgorithm storeString) , '.'.
          s nextPutLine:'  View defaultStyle:' , View defaultStyle storeString , '.'.
        s nextPutLine:' ].'.
        s nextPutLine:'].'.
        s cr.

        s nextPutLine:'"/'.
        s nextPutLine:'"/ Parser/Compiler settings:'.
        s nextPutLine:'"/'.
        s nextPutLine:'ParserFlags warnSTXSpecials: ' , (ParserFlags warnSTXSpecials storeString) , '.';
          nextPutLine:'ParserFlags warnings: ' , (ParserFlags warnings storeString) , '.';
          nextPutLine:'ParserFlags warnUnderscoreInIdentifier: ' , (ParserFlags warnUnderscoreInIdentifier storeString) , '.';
          nextPutLine:'ParserFlags warnOldStyleAssignment: ' , (ParserFlags warnOldStyleAssignment storeString) , '.';
          nextPutLine:'ParserFlags warnCommonMistakes: ' , (ParserFlags warnCommonMistakes storeString) , '.';
          nextPutLine:'ParserFlags warnPossibleIncompatibilities: ' , (ParserFlags warnPossibleIncompatibilities storeString) , '.';
          nextPutLine:'ParserFlags allowUnderscoreInIdentifier: ' , (ParserFlags allowUnderscoreInIdentifier storeString) , '.';
          nextPutLine:'ParserFlags allowSqueakExtensions: ' , (ParserFlags allowSqueakExtensions storeString) , '.';
          nextPutLine:'ParserFlags allowDolphinExtensions: ' , (ParserFlags allowDolphinExtensions storeString) , '.';
          nextPutLine:'ParserFlags allowQualifiedNames: ' , (ParserFlags allowQualifiedNames storeString) , '.';
          nextPutLine:'ParserFlags arraysAreImmutable: ' , (ParserFlags arraysAreImmutable storeString) , '.';
          nextPutLine:'ParserFlags lineNumberInfo: ' , (ParserFlags lineNumberInfo storeString) , '.';

          nextPutLine:'Compiler foldConstants: ' , (Compiler foldConstants storeString) , '.';
          nextPutLine:'ParserFlags stcCompilation: ' , (ParserFlags stcCompilation storeString) , '.';
          nextPutLine:'OperatingSystem getOSType = ' , (OperatingSystem getOSType storeString) , ' ifTrue:[';
          nextPutLine:'  ParserFlags stcCompilationDefines: ' , (ParserFlags stcCompilationDefines storeString) , '.';
          nextPutLine:'  ParserFlags stcCompilationOptions: ' , (ParserFlags stcCompilationOptions storeString) , '.';
          nextPutLine:'  ParserFlags ccCompilationOptions: ' , (ParserFlags ccCompilationOptions storeString) , '.';
          nextPutLine:'  ParserFlags makeCommand: ' , (ParserFlags makeCommand storeString) , '.';
          nextPutLine:'  ExternalAddress pointerSize = ' , (ExternalAddress pointerSize storeString) , ' ifTrue:[';
          nextPutLine:'    ParserFlags stcCompilationIncludes: ' , (ParserFlags stcCompilationIncludes storeString) , '.';
          nextPutLine:'    ',(ParserFlags stcModulePath ? 'modules') storeString , ' asFilename exists ifTrue:[';
          nextPutLine:'      ParserFlags stcModulePath: ' , (ParserFlags stcModulePath ? 'modules') storeString , '.';
          nextPutLine:'    ].';
          nextPutLine:'    ParserFlags stcPath: ' , (ParserFlags stcPath storeString) , '.';
          nextPutLine:'    ParserFlags ccPath: ' , (ParserFlags ccPath storeString) , '.';
          nextPutLine:'    ParserFlags linkArgs: ' , (ParserFlags linkArgs storeString) , '.';
          nextPutLine:'    ParserFlags linkSharedArgs: ' , (ParserFlags linkSharedArgs storeString) , '.';
          nextPutLine:'    ParserFlags linkCommand: ' , (ParserFlags linkCommand storeString) , '.';
          nextPutLine:'    ParserFlags libPath: ' , (ParserFlags libPath storeString) , '.';
          nextPutLine:'    ParserFlags searchedLibraries: ' , (ParserFlags searchedLibraries storeString) , '.';
          nextPutLine:'  ].';
          nextPutLine:'].';

          nextPutLine:'ObjectMemory justInTimeCompilation: ' , (ObjectMemory justInTimeCompilation storeString) , '.';
          nextPutLine:'ObjectMemory fullSingleStepSupport: ' , (ObjectMemory fullSingleStepSupport storeString) , '.'.

        HistoryManager notNil ifTrue:[
            HistoryManager isActive ifTrue:[
                s nextPutLine:'HistoryManager notNil ifTrue:[HistoryManager activate].'.
                s nextPutLine:'HistoryManager notNil ifTrue:[HistoryManager fullHistoryUpdate:' , HistoryManager fullHistoryUpdate storeString , '].'.
            ] ifFalse:[
                s nextPutLine:'HistoryManager notNil ifTrue:[HistoryManager deactivate].'.
            ].
        ].

        s nextPutLine:'Class catchMethodRedefinitions: ' , (Class catchMethodRedefinitions storeString) , '.'.
        s nextPutLine:'ClassCategoryReader sourceMode: ' , (ClassCategoryReader sourceMode storeString) , '.'.

        s cr.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ Info & Debug Messages:'.
        s nextPutLine:'"/'.
        s nextPutLine:'Smalltalk hasNoConsole ifFalse:[ ObjectMemory infoPrinting: ' , (ObjectMemory infoPrinting storeString) , '].';
          nextPutLine:'ObjectMemory debugPrinting: ' , (ObjectMemory debugPrinting storeString) , '.';
          nextPutLine:'Smalltalk hasNoConsole ifFalse:[ Object infoPrinting: ' , (Object infoPrinting storeString) , '].';
          nextPutLine:'DeviceWorkstation errorPrinting: ' , (DeviceWorkstation errorPrinting storeString) , '.'.

    "/    FlyByHelp isActive ifTrue:[
    "/        s nextPutLine:'FlyByHelp start.'
    "/    ].

        s cr.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ Edit settings:'.
        s nextPutLine:'"/'.
        "/ s nextPutLine:'EditTextView st80Mode: ' , (EditTextView st80Mode storeString) , '.'.
        "/ s nextPutLine:'TextView st80SelectMode: ' , (TextView st80SelectMode storeString) , '.'.
        s nextPutLine:'UserPreferences current syntaxColoring: ' , (userPrefs syntaxColoring storeString) , '.'.
        (ListView userDefaultTabPositions = ListView tab4Positions) ifTrue:[
            s nextPutLine:'ListView userDefaultTabPositions:(ListView tab4Positions).'.
        ] ifFalse:[
            s nextPutLine:'ListView userDefaultTabPositions:(ListView tab8Positions).'.
        ].

        s nextPutLine:'"/'.
        s nextPutLine:'"/ User preference values:'.
        s nextPutLine:'"/'.
        userPrefs keysAndValuesDo:[:k :v |
            |putSelector|

            putSelector := (k , ':') asSymbolIfInterned.
            (UserPreferences includesSelector:putSelector) ifTrue:[
                s nextPutAll:'UserPreferences current ';
                  nextPutAll:putSelector.
            ] ifFalse:[
                s nextPutAll:'UserPreferences current at:'.
                k storeOn:s.
                s nextPutAll:' put:'.
            ].
            v storeOn:s.
            s nextPut:$.; cr.
        ].

        s cr.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ GC settings:'.
        s nextPutLine:'"/'.
        s nextPutLine:'ObjectMemory newSpaceSize: ' , (ObjectMemory newSpaceSize storeString) , '.';
          nextPutLine:'ObjectMemory dynamicCodeGCTrigger: ' , (ObjectMemory dynamicCodeGCTrigger storeString) , '.';
          nextPutLine:'ObjectMemory freeSpaceGCAmount: ' , (ObjectMemory freeSpaceGCAmount storeString) , '.';
          nextPutLine:'ObjectMemory freeSpaceGCLimit: ' , (ObjectMemory freeSpaceGCLimit storeString) , '.';
          nextPutLine:'ObjectMemory incrementalGCLimit: ' , (ObjectMemory incrementalGCLimit storeString) , '.';
          nextPutLine:'ObjectMemory oldSpaceCompressLimit: ' , (ObjectMemory oldSpaceCompressLimit storeString) , '.';
          nextPutLine:'ObjectMemory oldSpaceIncrement: ' , (ObjectMemory oldSpaceIncrement storeString) , '.'.

        s cr.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ Misc settings:'.
        s nextPutLine:'"/'.
        s nextPutLine:'Class keepMethodHistory: ' , (Class methodHistory notNil storeString) , '.';
          nextPutLine:'Smalltalk logDoits: ' , (Smalltalk logDoits storeString) , '.';
          nextPutLine:'Autoload compileLazy: ' , (Autoload compileLazy storeString) , '.';
          nextPutLine:'Smalltalk loadBinaries: ' , (Smalltalk loadBinaries storeString) , '.';
          nextPutLine:'StandardSystemView includeHostNameInLabel: ' , (StandardSystemView includeHostNameInLabel storeString) , '.';

          "/ claus - I don't think its a good idea to save those ...
    "/      nextPutLine:'"/ Class updateChanges: ' , (Class updatingChanges storeString) , '.';
    "/      nextPutLine:'"/ ObjectMemory nameForChanges: ' , (ObjectMemory nameForChanges storeString) , '.';

          nextPutLine:'StandardSystemView returnFocusWhenClosingModalBoxes: ' , (StandardSystemView returnFocusWhenClosingModalBoxes storeString) , '.';
          nextPutLine:'StandardSystemView takeFocusWhenMapped: ' , (StandardSystemView takeFocusWhenMapped storeString) , '.';
          nextPutLine:'Display notNil ifTrue:[';
          nextPutLine:' Display activateOnClick: ' , ((screen activateOnClick:nil) storeString) , '.';
          nextPutLine:'].';
          nextPutLine:'MenuView showAcceleratorKeys: ' , (MenuView showAcceleratorKeys storeString) , '.';
          nextPutLine:'Class tryLocalSourceFirst: ' , (Class tryLocalSourceFirst storeString) , '.'.
        (NoHandlerError emergencyHandler == AbstractLauncherApplication notifyingEmergencyHandler) ifTrue:[
            s nextPutLine:'NoHandlerError emergencyHandler:(AbstractLauncherApplication notifyingEmergencyHandler).'.
        ].
        Processor isTimeSlicing ifTrue:[
            s nextPutLine:'Processor startTimeSlicing.'.
            s nextPutLine:('Processor supportDynamicPriorities:' , (Processor supportDynamicPriorities ? false) storeString , '.').
        ] ifFalse:[
            s nextPutLine:'Processor stopTimeSlicing.'.
        ].

        s cr.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ Printer settings:'.
        s nextPutLine:'"/'.
        Printer notNil ifTrue:[
            s nextPutLine:'Printer := ' , (Printer name) , '.'.
            Printer supportsPrintingToCommand ifTrue:[
                s nextPutLine:'Printer printCommand: ' , (Printer printCommand storeString) , '.'.
            ].
            Printer supportsPageSizes ifTrue:[
                s nextPutLine:'Printer pageFormat: ' , (Printer pageFormat storeString) , '.'.
                s nextPutLine:'Printer landscape: ' , (Printer landscape storeString) , '.'.
            ].
            Printer supportsMargins ifTrue:[
                s nextPutLine:'Printer topMargin: ' , (Printer topMargin storeString) , '.'.
                s nextPutLine:'Printer leftMargin: ' , (Printer leftMargin storeString) , '.'.
                s nextPutLine:'Printer rightMargin: ' , (Printer rightMargin storeString) , '.'.
                s nextPutLine:'Printer bottomMargin: ' , (Printer bottomMargin storeString) , '.'.
            ].
            Printer supportsPostscript ifTrue:[
                s nextPutLine:'Printer supportsColor: ' , (Printer supportsColor storeString) , '.'.
            ].
        ].
        s cr.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ Font settings:'.
        s nextPutLine:'"/ (only restored, if image is restarted on the same display)'.
        s nextPutLine:'"/'.
        s nextPutLine:'Display notNil ifTrue:['.
        s nextPutLine:' Display displayName = ' , (screen displayName storeString) , ' ifTrue:['.
        {
            SimpleView . Label . CheckBox . CheckLabel . Button . Toggle .
            SelectionInListView . MenuView . MenuPanel . NoteBookView . PullDownMenu .
            TextView . EditTextView . CodeView
        } do:[:cls |
            s nextPutLine:'  ',cls name,' defaultFont: ' , (cls defaultFont storeString) , '.'.
        ].
        s nextPutLine:' ].'.
        s nextPutLine:'].'.

        s cr.
        s nextPutLine:'"/'.
        s nextPutLine:'"/ SourceCodeManager settings:'.
        s nextPutLine:'"/ (repositories are networked nowadays, so the settings are host independent)'.
        s nextPutLine:'"/'.
        s nextPutLine:'Class tryLocalSourceFirst:' , Class tryLocalSourceFirst storeString , '.'.
        s nextPutLine:'AbstractSourceCodeManager notNil ifTrue:[AbstractSourceCodeManager cacheDirectoryName:' , AbstractSourceCodeManager cacheDirectoryName storeString , '].'.

        AbstractSourceCodeManager availableManagers do:[:eachManager |
            eachManager savePreferencesOn:s
        ].

        s syncData.
        userPrefs beUnmodified.
    ].

    "
     Transcript topView application saveSettings
    "

    "Modified: / 09-08-2006 / 18:52:14 / fm"
    "Modified: / 26-09-2012 / 13:33:47 / cg"
! !

!UserPreferences methodsFor:'accessing'!

at:key
    ^ super at:key asSymbol

    "Created: / 15-01-2012 / 14:27:29 / cg"
!

at:key ifAbsent:exceptionValue
    ^ super
	at:key asSymbol
	ifAbsent:[
	    "/ Look to DefaultPreferences first...
	    (DefaultPreferences notNil and:[self ~~ DefaultPreferences]) ifTrue:[
		DefaultPreferences at:key ifAbsent:exceptionValue
	    ] ifFalse:[
		exceptionValue value
	    ]
	].

    "Created: / 15-01-2012 / 14:27:21 / cg"
    "Modified (format): / 05-02-2015 / 07:10:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at:key put:value
    |classNameToCheck classToCheck|

"/    key isSymbol ifFalse:[
"/        self halt.
"/        self at:key asSymbol put:value.
"/        ^ self
"/    ].

    value == true ifTrue:[
	key == #useNewVersionDiffBrowser ifTrue:[
	    classNameToCheck := #'VersionDiffBrowser'.
	].
	key == #useNewChangesBrowser ifTrue:[
	    classNameToCheck := #'NewChangesBrowser'.
	].
	key == #useNewFileBrowser ifTrue:[
	    classNameToCheck := #'FileBrowserV2'.
	].
	key == #useNewSystemBrowser ifTrue:[
	    classNameToCheck := #'Tools::NewSystemBrowser'.
	].
	key == #useNewInspector ifTrue:[
	    classNameToCheck := #'NewInspector::NewInspectorView'.
	].
    ].

    classNameToCheck notNil ifTrue:[
	classToCheck := Smalltalk at:classNameToCheck.
	classToCheck isNil ifTrue:[
	    ('UserPreferences [warning]: no class ' , classNameToCheck , ' class in system.') errorPrintCR.
	] ifFalse:[
	    Autoload autoloadFailedSignal handle:[:ex |
		'UserPreferences [warning]: autoload of ' , classNameToCheck , ' failed.' errorPrintCR.
	    ] do:[
		classToCheck autoload.
	    ]
	]
    ].

    ^ super at:key asSymbol put:value

    "Modified: / 15-01-2012 / 14:26:53 / cg"
!

beModified
    "this is not needed for settings applications, which notice any modifications
     themself. Howvever, if someone else modifies the settings (programmatically),
     the change should be remembered, so that the user can be warned at session end"

    modified := true
!

beUnmodified
    "done when saved"

    modified := false
!

isModified
    "this is set, if someone modifies the settings programmatically,
     so that the user can be warned at session end"

    ^ modified ? false
! !




!UserPreferences methodsFor:'accessing-locale'!

dateInputFormat
    "return a format used when tools read a date from the user"

    ^ self
	at:#dateInputFormat
	ifAbsentPut:[
	    (self language == #en and:[ self languageTerritory ~= #en])
		ifTrue:[ '%m %d %y' ]
		ifFalse:[ '%d %m %y' ]
	]
!

dateInputFormat:aFormatString
    "return a format used when tools read a date from the user"

    ^ self
	at:#dateInputFormat
	ifAbsentPut:[
	    (self language == #en and:[ self languageTerritory ~= #en])
		ifTrue:[ '%m %d %y' ]
		ifFalse:[ '%d %m %y' ]
	]

    "
     UserPreferences current dateInputFormat:'%d %m %y'  -- european
     UserPreferences current dateInputFormat:'%m %d %y'  -- us
    "
!

decimalPointCharacter
    "toDo: migrate from ClassVar in Number;
     use this for new applications"

    ^ self at:#decimalPointCharacter ifAbsent:[ $. ]
!

decimalPointCharacter:aCharacter
    ^ self at:#decimalPointCharacter put:aCharacter
!

thousandsSeparatorCharacter
    "toDo: migrate from ClassVar elsewhere;
     use this for new applications"

    ^ self at:#thousandsSeparatorCharacter ifAbsent:[ $, ]
!

thousandsSeparatorCharacter:aCharacter
    ^ self at:#thousandsSeparatorCharacter put:aCharacter
! !

!UserPreferences methodsFor:'accessing-misc'!

selectorNamespacesEnabled
    "Return true, if selector namespaces support is enabled
     for this system. Note, that this method may return true
     even if selector namespaces are not supported by this system.

     This is rather user setting. To ask whether the selector namespaces
     support should be used, use:

        UserPreferences current selectorNamespacesSupportedAndEnabled
    "

    ^self at:#selectorNamespacesEnabled ifAbsent:false.

    "
        UserPreferences current selectorNamespacesEnabled
        UserPreferences current selectorNamespacesSupportedAndEnabled

        UserPreferences current selectorNamespacesEnabled: true.
        UserPreferences current selectorNamespacesEnabled: false.
    "

    "Created: / 19-07-2012 / 15:26:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorNamespacesEnabled: aBoolean
    "Enables/disables selector namespaces support for this system.
     Please note that even if selector namespaces are enabled here,
     they may not be supported by the system/VM.

     This is rather user setting. To ask whether the selector namespaces
     are supported use

	ConfigurableFeatures includesFeature:#SelectorNamespaces
    "

    self at:#selectorNamespacesEnabled put: aBoolean

    "
	UserPreferences current selectorNamespacesEnabled
	UserPreferences current selectorNamespacesSupportedAndEnabled

	UserPreferences current selectorNamespacesEnabled: true.
	UserPreferences current selectorNamespacesEnabled: false.
    "

    "Created: / 19-07-2012 / 15:27:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorNamespacesSupportedAndEnabled
    "Return true, if selector namespaces are both enabled
     and supported by this system/VM, false otherwise
    "

    ^ (ConfigurableFeatures includesFeature:#SelectorNamespaces)
	and:[self selectorNamespacesEnabled]

    "
	UserPreferences current selectorNamespacesEnabled
	UserPreferences current selectorNamespacesSupportedAndEnabled

	UserPreferences current selectorNamespacesEnabled: true.
	UserPreferences current selectorNamespacesEnabled: false.
    "

    "Created: / 19-07-2012 / 15:32:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-misc-communication'!

dotNetBridgeRunsInIDE
    "a debugging flag: if true, the dotNetBridge is assumed to be
     already running and the bridge-exe will not be started by st/x"

    ^ self at:#dotNetBridgeRunsInIDE ifAbsent:false
!

dotNetBridgeRunsInIDE:aBoolean
    "a debugging flag: if true, the dotNetBridge is assumed to be
     already running and the bridge-exe will not be started by st/x"

    ^ self at:#dotNetBridgeRunsInIDE put:aBoolean
!

dotNetBridgeVerbose
    ^ self at:#dotNetBridgeVerbose ifAbsent:false

    "
     UserPreferences current dotNetBridgeVerbose
    "
!

dotNetBridgeVerbose:aBoolean
    ^ self at:#dotNetBridgeVerbose put:aBoolean
!

javaBridgeRunsInIDE
    "a debugging flag: if true, the javaBridge is assumed to be
     already running and the bridge-exe will not be started by st/x"

    ^ self at:#javaBridgeRunsInIDE ifAbsent:false
!

javaBridgeRunsInIDE:aBoolean
    "a debugging flag: if true, the javaBridge is assumed to be
     already running and the bridge-exe will not be started by st/x"

    ^ self at:#javaBridgeRunsInIDE put:aBoolean
!

logHTTPRequests
    ^ self at:#logHTTPRequests ifAbsent:false
!

logHTTPRequests:aBoolean
    ^ self at:#logHTTPRequests put:aBoolean

    "
     UserPreferences current logHTTPRequests
     UserPreferences current logHTTPRequests:true
     UserPreferences current logHTTPRequests:false
    "
!

logSOAPRequests
    ^ (self soapLoggingLevel ? 0) > 0
!

logSOAPRequests:aBoolean
    self soapLoggingLevel:(aBoolean ifTrue:3 ifFalse:0)

    "
     UserPreferences current logSOAPRequests
     UserPreferences current logSOAPRequests:true
     UserPreferences current logSOAPRequests:false
    "
!

smallteamViaXMPPEnabled
    ^ self at:#smallteamViaXMPPEnabled ifAbsent:false
!

smallteamViaXMPPEnabled:aBoolean
    self at:#smallteamViaXMPPEnabled put:aBoolean
!

smallteamXMPPPassword
    ^ self at:#smallteamXMPPPassword ifAbsent:[ '' ]
!

smallteamXMPPPassword:aPasswordString
    self at:#smallteamXMPPPassword put:aPasswordString
!

smallteamXMPPServer
    ^ self at:#smallteamXMPPServer ifAbsent:[ 'exept.de' ]
!

smallteamXMPPServer:aHostname
    self at:#smallteamXMPPServer put:aHostname

    "
     UserPreferences current smallteamXMPPUser:'exept.de'.
    "
!

smallteamXMPPUser
    ^ self at:#smallteamXMPPUser ifAbsent:[ OperatingSystem getLoginName ]
!

smallteamXMPPUser:aUsernameString
    self at:#smallteamXMPPUser put:aUsernameString

    "
     UserPreferences current smallteamXMPPUser:'cg'.
    "
!

smtpServerName
    ^ self at:#smtpServerName ifAbsent:nil

    "Created: / 20-09-2007 / 15:59:20 / cg"
!

smtpServerName:aHostnameString
    ^ self at:#smtpServerName put:aHostnameString

    "
     UserPreferences current smtpServerName
     UserPreferences current smtpServerName:'mailhost'
    "

    "Created: / 20-09-2007 / 15:59:58 / cg"
!

soapErrorDebugging
    "open a debugger on error, or report it as a soap-error"

    ^ self at:#soapErrorDebugging ifAbsent:false
!

soapErrorDebugging:aBoolean
    "open a debugger on error, or report it as a soap-error"
    ^ self at:#soapErrorDebugging put:aBoolean

    "
     UserPreferences current soapErrorDebugging:true
    "
!

soapLoggingLevel
    ^ self at:#soapLoggingLevel ifAbsent:[0]

    "Modified: / 16-10-2016 / 23:55:34 / cg"
!

soapLoggingLevel:anIntegerBetween0_and_3
    ^ self at:#soapLoggingLevel put:anIntegerBetween0_and_3
!

socksProxyHost
    ^ self at:#socksProxyHost ifAbsent:nil

    "Created: / 27-12-2011 / 14:40:27 / cg"
!

socksProxyHost:aString
    ^ self at:#socksProxyHost put:aString

    "Created: / 27-12-2011 / 14:42:15 / cg"
!

socksProxyPort
    ^ self at:#socksProxyPort ifAbsent:nil

    "Created: / 27-12-2011 / 14:40:32 / cg"
!

socksProxyPort:aNumber
    ^ self at:#socksProxyPort put:aNumber

    "Created: / 27-12-2011 / 14:42:29 / cg"
! !

!UserPreferences methodsFor:'accessing-pref''d tools'!

changeSetBrowserClass

    | class className |

    className := self at: #changeSetBrowserClassName ifAbsent:[nil].
    className notNil ifTrue:[
        class := Smalltalk at: className asSymbol.
        class notNil ifTrue:[ ^ class ].
    ].

    "Original code"
    ^ ChangeSetBrowser.

"/    self useNewChangeSetBrowser ifTrue:[
"/        ^ Tools::ChangeSetBrowser2 ? ChangeSetBrowser
"/    ].
"/    ^ ChangeSetBrowser ? Tools::ChangeSetBrowser2

    "
     self current changeSetBrowserClass
    "

    "Created: / 01-07-2011 / 16:33:13 / cg"
    "Modified: / 25-07-2011 / 12:21:42 / sr"
    "Modified: / 25-01-2012 / 17:11:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetBrowserClass: aClass

    self at: #changeSetBrowserClassName put: aClass name.

    "
	UserPreferences current changeSetBrowserClass
	UserPreferences current changeSetBrowserClass: Tools::ChangeSetBrowser2.
	UserPreferences current changeSetBrowserClass: ChangeSetBrowser.
    "

    "Created: / 25-01-2012 / 17:08:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesBrowserClass
    "the browser to be used for the changeFile"

    | class className |

    className := self at: #changesBrowserClassName ifAbsent:[nil].
    className notNil ifTrue:[
	class := Smalltalk at: className asSymbol.
	class notNil ifTrue:[ ^ class ].
    ].

    "/ Old code
    self useNewChangesBrowser ifTrue:[
	^ (NewChangesBrowser ? ChangesBrowser)
    ].
    ^ ChangesBrowser

    "Created: / 17-10-1998 / 14:37:46 / cg"
    "Modified: / 25-01-2012 / 17:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesBrowserClass: aClass

    self at: #changesBrowserClassName put: aClass name.

    "
	UserPreferences current changesBrowserClass
	UserPreferences current changesBrowserClass: Tools::ChangeSetBrowser2.
	UserPreferences current changesBrowserClass: ChangeSetBrowser.
    "

    "Created: / 25-01-2012 / 17:12:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

externalDiffCommandTemplate
    "the external command to use for diff"

    ^ self
	at:#externalDiffCommandTemplate
	ifAbsent:[
	    OperatingSystem isMSDOSlike ifTrue:[
		'diff %1 %2'
	    ] ifFalse:[
		'diff -b %1 %2'
	    ]
	]

    "
     UserPreferences current externalDiffCommandTemplate
    "

    "Modified: / 13-10-1998 / 15:53:05 / cg"
    "Created: / 26-07-2012 / 15:06:31 / cg"
!

externalDiffCommandTemplate:aString
    "the external command to use for diff.
     The default is 'diff %1 %2' on msdos and 'diff -b %1 %2' on unix"

    self at:#externalDiffCommandTemplate put:aString

    "
     UserPreferences current externalDiffCommandTemplate
    "
!

inspectorClassSetting
    self useNewInspector ifTrue:[
	^ (NewInspector::NewInspectorView ? InspectorView)
    ].
    ^ InspectorView

    "Modified: / 12.11.2001 / 15:47:35 / cg"
    "Created: / 12.11.2001 / 15:49:00 / cg"
!

showTipOfTheDayAtStartup
    ^ self at:#showTipOfTheDayAtStartup ifAbsent:false
!

showTipOfTheDayAtStartup:aBoolean
    self at:#showTipOfTheDayAtStartup put:aBoolean.
!

systemBrowserClass
    self useNewSystemBrowser ifTrue:[
	^ ((Tools::NewSystemBrowser ? NewSystemBrowser) ? SystemBrowser)
    ].
    ^ SystemBrowser
!

testRunnerClass
    self useTestRunner2 ifTrue:[
	^ Tools::TestRunner2 ? TestRunner
    ].
    ^ TestRunner

    "Created: / 06-07-2011 / 13:55:03 / cg"
!

useInspector2
    "using brand new or old inspector"

    ^ self at:#useInspector2 ifAbsent:false

    "
     UserPreferences current useInspector2
    "

    "Modified: / 17-10-1998 / 14:45:12 / cg"
    "Created: / 03-07-2011 / 22:35:50 / cg"
!

useInspector2:aBoolean
    "using very new or old inspector"

    self at:#useInspector2 put:aBoolean

    "
     UserPreferences current useInspector2
    "

    "Created: / 03-07-2011 / 22:36:13 / cg"
!

useNativeFileDialog
    ^ self nativeFileDialogs

    "Modified: / 24-08-2010 / 17:02:10 / sr"
!

useNativeFileDialog:aBoolean
    self nativeFileDialogs:aBoolean

    "Modified: / 24-08-2010 / 17:02:13 / sr"
!

useNewChangeSetBrowser
    "using old or jan's changeSetBrowser for package diffs"

    ^ self at:#useNewChangeSetBrowser ifAbsent:false

    "Modified: / 13-10-1998 / 15:53:05 / cg"
    "Created: / 26-07-2012 / 15:06:31 / cg"
!

useNewChangeSetBrowser:aBoolean
    "using old or jan's changeSetBrowser for package diffs"

    ^ self at:#useNewChangeSetBrowser put:aBoolean

    "Created: / 26-07-2012 / 15:06:50 / cg"
!

useNewChangesBrowser
    "using new or old change browser for the changes file"

    ^ self at:#useNewChangesBrowser ifAbsent:false

    "Modified: / 13-10-1998 / 15:53:05 / cg"
    "Modified (comment): / 26-07-2012 / 15:04:37 / cg"
!

useNewChangesBrowser:aBoolean
    "using new or old changeBrowser for the changes file"

    self at:#useNewChangesBrowser put:aBoolean

    "
     UserPreferences current useNewChangesBrowser
    "

    "Modified: / 13-10-1998 / 15:53:21 / cg"
    "Modified (comment): / 26-07-2012 / 15:04:39 / cg"
!

useNewFileBrowser
    "using new or old version diff viewer"

    ^ self at:#useNewFileBrowser ifAbsent:(FileBrowserV2 notNil and:[FileBrowserV2 isLoaded])

    "Modified: / 13.10.1998 / 15:53:05 / cg"
!

useNewFileBrowser:aBoolean
    "using new or old file browser"

    self at:#useNewFileBrowser put:aBoolean

    "
     UserPreferences current useNewFileBrowser
    "

    "Modified: / 13.10.1998 / 15:53:21 / cg"
!

useNewFileDialog
    "using new or old file dialog"

    ^ self at:#useNewFileDialog ifAbsent:true

    "
     UserPreferences current useNewFileDialog:false
     UserPreferences current useNewFileDialog:true
    "

    "Modified (comment): / 23-01-2012 / 17:25:01 / cg"
!

useNewFileDialog:aBoolean
    "using new or old file dialog"

    self at:#useNewFileDialog put:aBoolean

    "
     UserPreferences current useNewFileDialog:true
    "
!

useNewInspector
    "using new or old inspector"

    ^ self at:#useNewInspector ifAbsent:false

    "
     UserPreferences current useNewInspector
    "

    "Modified: / 17.10.1998 / 14:45:12 / cg"
!

useNewInspector:aBoolean
    "using new or old inspector"

    self at:#useNewInspector put:aBoolean

    "
     UserPreferences current useNewInspector
    "
!

useNewSettingsApplication
    "using one application for the settings"

    ^ self at:#useNewSettingsApplication ifAbsent:true
!

useNewSettingsApplication:aBoolean
    "using one application for the settings"

    self at:#useNewSettingsApplication put:aBoolean

    "
     UserPreferences current useNewSettingsApplication:true
    "

    "Modified: / 13.10.1998 / 15:53:21 / cg"
!

useNewSystemBrowser
    "using new or old system browser"

    |newSystemBrowserClass useIt|

    newSystemBrowserClass := (Tools::NewSystemBrowser ? NewSystemBrowser).
    useIt := self at:#useNewSystemBrowser ifAbsent:nil.
    useIt isNil ifTrue:[
	useIt := (newSystemBrowserClass notNil and:[ newSystemBrowserClass isLoaded]).
	useIt ifTrue:[
	    self at:#useNewSystemBrowser put:true.
	].
    ].
    ^ useIt
!

useNewSystemBrowser:aBoolean
    "using new or old systemBrowser"

    self at:#useNewSystemBrowser put:aBoolean

    "
     UserPreferences current useNewSystemBrowser:true
    "

    "Modified: / 13.10.1998 / 15:53:21 / cg"
!

useNewVersionDiffBrowser
    "using new or old version diff viewer"

    ^ self at:#useNewVersionDiffBrowser ifAbsent:true

    "Modified: / 13.10.1998 / 15:53:05 / cg"
!

useNewVersionDiffBrowser:aBoolean
    "using new or old versionDiffBrowser"

    self at:#useNewVersionDiffBrowser put:aBoolean

    "
     UserPreferences current useNewVersionDiffBrowser
    "

    "Modified: / 13.10.1998 / 15:53:21 / cg"
!

useProcessMonitorV2
    "using ProcessMonitorV2 application for display Processes"

    ^ self at:#useProcessMonitorV2 ifAbsent:(ProcessMonitorV2 notNil)
!

useProcessMonitorV2:aBoolean
    "using ProcessMonitorV2 application for display Processes"

    self at:#useProcessMonitorV2 put:aBoolean

    "
     UserPreferences current useProcessMonitorV2:true
    "

    "Modified: / 13.10.1998 / 15:53:21 / cg"
!

useSmalltalkDocumentViewer
    "using the smalltalk-DocumentViewer (as opposed to the native systems Browser)
     to display documentation"

    ^ self at:#useSmalltalkDocumentViewer ifAbsent:true

    "
     UserPreferences current useSmalltalkDocumentViewer
     UserPreferences current useSmalltalkDocumentViewer:false
    "
!

useSmalltalkDocumentViewer:aBoolean
    "using the smalltalk-DocumentViewer (as opposed to the native systems Browser)
     to display documentation"

    ^ self at:#useSmalltalkDocumentViewer put:aBoolean
!

useTestRunner2
    "using new or old test runner"

    ^ self at:#useTestRunner2 ifAbsent:true

    "Created: / 06-07-2011 / 13:41:33 / cg"
!

useTestRunner2:aBoolean
    "using new or old test runner"

    self at:#useTestRunner2 put:aBoolean

    "
     UserPreferences current useTestRunner2:true
    "

    "Created: / 06-07-2011 / 13:41:40 / cg"
!

useXTermViewIfAvailable
    "switch between xtermView (xembed) and vt100 (st/x emulation)
     if possible on that architecture."

    ^ self at:#useXTermViewIfAvailable ifAbsent:false

    "
     UserPreferences current useXTermViewIfAvailable
    "
!

useXTermViewIfAvailable:aBoolean
    "switch between xtermView (xembed) and vt100 (st/x emulation)
     if possible on that architecture."

    self at:#useXTermViewIfAvailable put:aBoolean

    "
     UserPreferences current useXTermViewIfAvailable
    "
!

versionDiffViewerClass
    self useNewVersionDiffBrowser ifTrue:[
	^ (VersionDiffBrowser ? DiffTextView)
    ].
    ^ DiffCodeView
! !


!UserPreferences methodsFor:'accessing-prefs-UI'!

allowMouseWheelZoom
    "return the flag which controls if text can be magnified via the ALT-wheel-action"

    ^ self at:#allowMouseWheelZoom ifAbsent:[ true ]

    "
     UserPreferences current allowMouseWheelZoom
    "
!

allowMouseWheelZoom:aBooleanOrNil
    "set/clear the flag which controls if text can be magnified via the ALT-wheel-action"

    ^ self at:#allowMouseWheelZoom put:aBooleanOrNil

    "
     UserPreferences current allowMouseWheelZoom:true
     UserPreferences current allowMouseWheelZoom:false
     UserPreferences current allowMouseWheelZoom
    "
!

avoidConfirmationsForExperiencedUsers
    "some confirmers ara annoying, if you are an experienced st/x user"

    ^ self at:#avoidConfirmationsForExperiencedUsers ifAbsent:[ false ]

    "
     UserPreferences current avoidConfirmationsForExperiencedUsers
     UserPreferences current avoidConfirmationsForExperiencedUsers:true
    "

    "Created: / 05-09-2012 / 11:26:55 / cg"
!

avoidConfirmationsForExperiencedUsers:aBooleanOrNil
    "some confirmers ara annoying, if you are an experienced st/x user.
     Set/clear the flag which controls this"

    ^ self at:#avoidConfirmationsForExperiencedUsers put:aBooleanOrNil

    "
     UserPreferences current avoidConfirmationsForExperiencedUsers:true
    "

    "Created: / 05-09-2012 / 11:27:09 / cg"
!

avoidSlowDrawingOperationsUnderWindows
    ^ OperatingSystem isMSWINDOWSlike
!

beepEnabled
    "return the flag which controls the beeper"

    ^ self at:#beepEnabled ifAbsentPut:true

    "
     UserPreferences current beepEnabled
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
    "Created: / 3.12.1999 / 17:09:49 / ps"
!

beepEnabled:aBoolean
    "set/clear the flag which controls the beeper"

    ^ self at:#beepEnabled put:aBoolean

    "
     UserPreferences current beepEnabled:false
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
    "Created: / 3.12.1999 / 17:10:27 / ps"
!

beepForErrorDialog
    "return the flag which controls beeping for error dialogs"

    ^ self at:#beepForErrorDialog ifAbsent:true

    "
     UserPreferences current beepForErrorDialog
    "
!

beepForErrorDialog:aBoolean
    "set/clear the flag which controls beeping for error dialogs"

    ^ self at:#beepForErrorDialog put:aBoolean

    "
     UserPreferences current beepForErrorDialog:true
    "
!

beepForInfoDialog
    "return the flag which controls beeping for info dialogs"

    ^ self at:#beepForInfoDialog ifAbsent:false

    "
     UserPreferences current beepForInfoDialog
    "
!

beepForInfoDialog:aBoolean
    "set/clear the flag which controls beeping for info dialogs"

    ^ self at:#beepForInfoDialog put:aBoolean

    "
     UserPreferences current beepForInfoDialog:true
    "
!

beepForWarningDialog
    "return the flag which controls beeping for warning dialogs"

    ^ self at:#beepForWarningDialog ifAbsent:true

    "
     UserPreferences current beepForWarningDialog
    "
!

beepForWarningDialog:aBoolean
    "set/clear the flag which controls beeping for warning dialogs"

    ^ self at:#beepForWarningDialog put:aBoolean

    "
     UserPreferences current beepForWarningDialog:true
    "
!

beepInEditor
    "return the flag which controls the beeper"

    ^ self at:#beepInEditor ifAbsentPut:true

    "
     UserPreferences current beepInEditor
    "
!

button2WithAltKey
    "if true, an ALT-left click is translated to a right click
     Useful with 1-button mice"

    ^ self at:#button2WithAltKey ifAbsent:[ false ]

    "
     UserPreferences current button2WithAltKey
    "
!

button2WithAltKey: aBoolean
    "if true, an ALT-left click is translated to a right click
     Useful with 1-button mice"

    ^ self at:#button2WithAltKey put: aBoolean

    "
     UserPreferences current button2WithAltKey
     UserPreferences current button2WithAltKey:true
     UserPreferences current button2WithAltKey:false
    "
!

closePopUpMenuChainOnEscape
    "if true, the whole chain of popUpMenus is closed when escape is pressed.
     if false (the default), only the last popup-view is closed.
     The first corresponds to X-behavior, the later is how windows does it - sigh."

    ^ self at:#closePopUpMenuChainOnEscape ifAbsent:false

    "
     UserPreferences current closePopUpMenuChainOnEscape:false
     UserPreferences current closePopUpMenuChainOnEscape:true
    "
!

closePopUpMenuChainOnEscape:aBoolean
    "if true, the whole chain of popUpMenus is closed when escape is pressed.
     if false (the default), only the last popup-view is closed.
     The first corresponds to X-behavior, the later is how windows does it - sigh."

    ^ self at:#closePopUpMenuChainOnEscape put:aBoolean

    "
     UserPreferences current closePopUpMenuChainOnEscape:true
     UserPreferences current closePopUpMenuChainOnEscape:false
    "
!

delayedMenuShowAndHide
    "the Windows behavior of showing submenus of a menu slightly delayed,
     to allow for short-time leaving of the mouse pointer.
     (bug #D1480943)"

    ^ self at:#delayedMenuShowAndHide ifAbsent:true

    "Created: / 29-11-2010 / 19:47:21 / cg"
!

delayedMenuShowAndHide:aBoolean
    "the Windows behavior of showing submenus of a menu slightly delayed,
     to allow for short-time leaving of the mouse pointer.
     (bug #D1480943)"

    ^ self at:#delayedMenuShowAndHide put:aBoolean

    "
     UserPreferences current delayedMenuShowAndHide
    "

    "Created: / 29-11-2010 / 19:47:36 / cg"
!

eclipseStyleMenus
    "if true, return menus organized like in eclipse;
     if false (the default) return them as usual"

    ^ self at:#eclipseStyleMenus ifAbsent:false

    "Created: / 08-07-2011 / 13:22:45 / cg"
!

eclipseStyleMenus:aBoolean
    "if true, return menus organized like in eclipse;
     if false (the default) return them as usual"

    ^ self at:#eclipseStyleMenus put:aBoolean

    "
     UserPreferences current eclipseStyleMenus:true
    "

    "Created: / 08-07-2011 / 13:22:50 / cg"
!

enableVMWareDrawingBugWorkaround
    "return the flag which enables a workaround for a redraw bug when running X/Linux in the VMWare virtual machine"

    ^ self at:#enableVMWareDrawingBugWorkaround ifAbsent:[ false ]

    "
     UserPreferences current enableVMWareDrawingBugWorkaround
    "

    "Created: / 19-11-2013 / 09:53:20 / cg"
!

enableVMWareDrawingBugWorkaround:aBoolean
    "change the flag which enables a workaround for a redraw bug when running X/Linux in the VMWare virtual machine"

    "/ self assert:(aBoolean isBoolean).
    self at:#enableVMWareDrawingBugWorkaround put:aBoolean.
    (Screen notNil and:[Screen current notNil and:[Screen current isX11Platform]]) ifTrue:[
        Screen current maxOperationsUntilFlush:(aBoolean ifTrue:[1] ifFalse:[nil])
    ].

    "
     UserPreferences current enableVMWareDrawingBugWorkaround
     UserPreferences current enableVMWareDrawingBugWorkaround:true
     UserPreferences current enableVMWareDrawingBugWorkaround:false
    "

    "Created: / 19-11-2013 / 09:53:45 / cg"
!

expandSelectionOnMouseMoveWithButtonPressed
    "expand the selection in a selectionInListView if the mouse is pressed while moving over
     more lines. Default is not FALSE !!"

    ^ self at:#expandSelectionOnMouseMoveWithButtonPressed ifAbsent:false

    "
     UserPreferences current expandSelectionOnMouseMoveWithButtonPressed
    "
!

expandSelectionOnMouseMoveWithButtonPressed:aBoolean
    "expand the selection in a selectionInListView if the mouse is pressed while moving over
     more lines. Default is not FALSE !!"

    ^ self at:#expandSelectionOnMouseMoveWithButtonPressed put:aBoolean

    "
     UserPreferences current expandSelectionOnMouseMoveWithButtonPressed
    "
!

flyByHelpActive

    ^ self at:#flyByHelpActive ifAbsent:true "(FlyByHelp notNil and:[FlyByHelp isActive])"
!

flyByHelpActive:aBoolean
    aBoolean ~~ self flyByHelpActive ifTrue:[
	self at:#flyByHelpActive put:aBoolean.
    ].
    self flyByHelpSettingChanged.
!

focusFollowsMouse
    "return the flag which controls if the keyboard focus should
     follow the mouse (as in X) - as opposed to click mode (as in MS-win).
     This only affects certain widgets (EditFields, EditTextViews and SelectionInListViews).
     The returned value has 3 states: true/false and nil, which means: as defined in styleSheet."

    ^ self at:#focusFollowsMouse ifAbsent:[ false ]

    "
     UserPreferences current focusFollowsMouse
    "
    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

focusFollowsMouse:aBooleanOrNil
    "set/clear the flag which controls if the keyboard focus should
     follow the mouse (as in X) - as opposed to click mode (as in MS-win).
     This only affects certain widgets (EditFields, EditTextViews and SelectionInListViews).
     Allowed are: true/false and nil, which means: as defined in styleSheet."

    ^ self at:#focusFollowsMouse put:aBooleanOrNil

    "
     UserPreferences current focusFollowsMouse:true
     UserPreferences current focusFollowsMouse:false
     UserPreferences current focusFollowsMouse
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

fontPreferences
    "experimental"

    ^ self at:#fontPreferences

    "
     UserPreferences current fontPreferences
     UserPreferences current fontPreferences:nil
    "
!

fontPreferences:aDictionary
    "experimental"

    self at:#fontPreferences put:aDictionary.
    aDictionary isNil ifTrue:[^ self].

    self fontPreferencesChanged.

    "
     UserPreferences current fontPreferences
     UserPreferences current fontPreferences:nil
    "
!

fontPreferencesChanged
    "tells view classes about changed font preferences"

    |dict fn getFont|

    dict := self at:#fontPreferences.
    dict isNil ifTrue:[^ self].

    getFont :=
        [:key|
            |s fn|

            s := dict at:key ifAbsent:nil.
            s notNil ifTrue:[
                fn := Object readFrom:s.
                self useXftFontsOnly ifTrue:[
                    fn := XftFontDescription for:fn
                    "/ cg: don't allocate on the display, because it takes
                    "/ dam long sometimes when Xft fonts are used.
                    "/ startup feels better, if we do it lazy.
                ] ifFalse:[
                    Display notNil ifTrue:[fn := fn onDevice:Display].
                ]
            ].
            fn
        ].

    fn := getFont value:#Other.
    fn notNil ifTrue:[
        SimpleView withAllSubclasses do:[:cls | cls defaultFont:fn].
    ].

    fn := getFont value:#Label.
    fn notNil ifTrue:[
        Label defaultFont:fn.
        CheckBox defaultFont:fn.
    ].

    fn := getFont value:#Button.
    fn notNil ifTrue:[
        Button defaultFont:fn.
        Toggle defaultFont:fn.
    ].

    fn := getFont value:#Text.
    fn notNil ifTrue:[
        TextView withAllSubclasses do:[:cls | cls defaultFont:fn].
    ].

    fn := getFont value:#InputField.
    fn notNil ifTrue:[
        EditField withAllSubclasses do:[:cls | cls defaultFont:fn].
    ].

    fn := getFont value:#List.
    fn notNil ifTrue:[
        SelectionInListView withAllSubclasses do:[:cls | cls defaultFont:fn].
    ].

    fn := getFont value:#Tooltip.
    fn notNil ifTrue:[
        ActiveHelpView withAllSubclasses do:[:cls | cls defaultFont:fn].
    ].

    fn := getFont value:#Menu.
    fn notNil ifTrue:[
        ListView defaultFont:fn.
        MenuView defaultFont:fn.
        MenuPanel defaultFont:fn.
        NoteBookView defaultFont:fn.
        PullDownMenu defaultFont:fn.
    ].
!

forceWindowsIntoMonitorBounds
    "if true, windows are forced to be placed into a monitor's bounds completely;
     if false, they may be placed as to cross a boundary. This only affects initial placement,
     not window movement."

    ^ self at:#forceWindowsIntoMonitorBounds ifAbsent:true

    "Created: / 22-10-2010 / 10:59:10 / cg"
!

forceWindowsIntoMonitorBounds:aBoolean
    "if true, windows are forced to be placed into a monitor's bounds completely;
     if false, they may be placed as to cross a boundary. This only affects initial placement,
     not window movement."

    ^ self at:#forceWindowsIntoMonitorBounds put:aBoolean

    "
     UserPreferences current forceWindowsIntoMonitorBounds:false
     UserPreferences current forceWindowsIntoMonitorBounds:true
    "

    "Modified: / 22-10-2010 / 11:13:54 / cg"
!

menuPanelTakesFocusOnClick
    "if true, the menu panel takes the focus and allows further control via
     cursor and tab keys."

    "/ read comment in menuPanel - for now, it should be on,
    "/ otherwise you cannot control a menu with cursor keys or escape. sigh.
    ^ self at:#menuPanelTakesFocusOnClick ifAbsent:[ true "false" ]

    "
     UserPreferences current menuPanelTakesFocusOnClick
     UserPreferences current menuPanelTakesFocusOnClick:false
     UserPreferences current menuPanelTakesFocusOnClick:true
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

menuPanelTakesFocusOnClick:aBooleanOrNil
    "if true, the menu panel takes the focus and allows further control via
     cursor and tab keys.
     Used to be on, but now we changed the default as it turned out to be counter productive"

    ^ self at:#menuPanelTakesFocusOnClick put:aBooleanOrNil

    "
     UserPreferences current menuPanelTakesFocusOnClick:true
     UserPreferences current menuPanelTakesFocusOnClick:false
     UserPreferences current menuPanelTakesFocusOnClick
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

motionDistanceToStartDrag
    "the motion distance (in pixel) to start drag (as opposed to adding to the selection)"

    ^ "DragMotionDistance ?" 10
!

mouseWheelDirectionReversed
    "if set, mouse wheel motions are upside-down.
     I got very confused with macOSX10.9, behavind different from 10.6,
     so I added this option"

    ^ self at:#mouseWheelDirectionReversed ifAbsent:[ false ]

    "
     UserPreferences current mouseWheelDirectionReversed
     UserPreferences current mouseWheelDirectionReversed:true
     UserPreferences current mouseWheelDirectionReversed:false
    "
!

mouseWheelDirectionReversed:aBoolean
    "if set, mouse wheel motions are upside-down.
     I got very confused with macOSX10.9, behavind different from 10.6,
     so I added this option"

    self at:#mouseWheelDirectionReversed put:aBoolean

    "
     UserPreferences current mouseWheelDirectionReversed
     UserPreferences current mouseWheelDirectionReversed:true
     UserPreferences current mouseWheelDirectionReversed:false
    "
!

mouseWheelFocusFollowsMouse
    "return the flag which controls if the mouseWheel focus should
     follow the mouse (as in X) - as opposed to click mode (as in MS-win)"

    self focusFollowsMouse ifTrue:[^ true].
    ^ self at:#mouseWheelFocusFollowsMouse ifAbsent:[ Screen current isWindowsPlatform ]

    "
     UserPreferences current mouseWheelFocusFollowsMouse
    "
!

mouseWheelScale
    "if set, mouse wheel motions are scaled by this number"

    ^ self at:#mouseWheelScale ifAbsent:[ 1 ]

    "
     UserPreferences current mouseWheelScale
     UserPreferences current mouseWheelScale:0.5
     UserPreferences current mouseWheelScale:1
    "
!

mouseWheelScale:aNumber
    "if set, mouse wheel motions are scaled by this number"

    self at:#mouseWheelScale put:aNumber.
    WindowSensor mouseWheelScale:aNumber.

    "
     UserPreferences current mouseWheelScale
     UserPreferences current mouseWheelScale:0.25
     UserPreferences current mouseWheelScale:0.5
     UserPreferences current mouseWheelScale:1

     WindowSensor mouseWheelScale
    "
!

nativeDialogs
    ^ self at:#nativeDialogs ifAbsent:false

    "Created: / 24-08-2010 / 17:01:47 / sr"
!

nativeDialogs:aBoolean
    |currentScreen|

    self at:#nativeDialogs put:aBoolean.
    currentScreen := Screen current.
    currentScreen notNil ifTrue:[
	currentScreen supportsNativeDialogs ifTrue:[
	    currentScreen nativeDialogs:aBoolean
	].
    ].

    "Modified: / 24-08-2010 / 18:06:43 / sr"
!

nativeFileDialogs
    ^ self at:#nativeFileDialogs ifAbsent:false

    "Created: / 24-08-2010 / 17:01:59 / sr"
!

nativeFileDialogs:aBoolean
    |currentScreen|

    self at:#nativeFileDialogs put:aBoolean.
    currentScreen := Screen current.
    currentScreen notNil ifTrue:[
	currentScreen supportsNativeFileDialogs ifTrue:[
	    currentScreen nativeFileDialogs:aBoolean
	].
    ].

    "Modified: / 24-08-2010 / 18:06:27 / sr"
!

nativeWidgets
    ^ self at:#nativeWidgets ifAbsent:false

    "Created: / 24-08-2010 / 16:58:44 / sr"
!

nativeWidgets:aBoolean
    "enable/disable native widgets on the current display"

    |currentScreen|

    self at:#nativeWidgets put:aBoolean.
    currentScreen := Screen current.
    currentScreen notNil ifTrue:[
	currentScreen supportsNativeWidgets ifTrue:[
	    currentScreen nativeWidgets:aBoolean
	].
    ].

    "Created: / 24-08-2010 / 16:58:14 / sr"
    "Modified: / 24-08-2010 / 18:05:56 / sr"
!

onlyShowTooltipsForActiveWindow
    "on a mac (and maybe on others), it is preferable to turn this on"

    ^ self at:#onlyShowTooltipsForActiveWindow ifAbsent:true

    "
     UserPreferences current onlyShowTooltipsForActiveWindow
     UserPreferences current onlyShowTooltipsForActiveWindow:false
    "
!

onlyShowTooltipsForActiveWindow:aBooleanOrNil
    "on a mac (and maybe on others), it is preferable to turn this on"

    ^ self at:#onlyShowTooltipsForActiveWindow put:aBooleanOrNil
!

opaqueTableColumnResizing
    "return the flag which controls if table column resizing should be done
     animated (opaque)"

    ^ self at:#opaqueTableColumnResizing ifAbsent:false

    "
     UserPreferences current opaqueTableColumnResizing
    "
!

opaqueTableColumnResizing:aBoolean
    "change the flag which controls if table column resizing should be done
     animated (opaque)"

    ^ self at:#opaqueTableColumnResizing put:aBoolean

    "
     UserPreferences current opaqueTableColumnResizing:true
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

opaqueVariablePanelResizing
    "return the flag which controls if variable panel resizing should be done
     animated (opaque)"

    ^ self at:#opaqueVariablePanelResizing ifAbsent:true

    "
     UserPreferences current opaqueVariablePanelResizing
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

opaqueVariablePanelResizing:aBoolean
    "change the flag which controls if variable panel resizing should be done
     animated (opaque)"

    ^ self at:#opaqueVariablePanelResizing put:aBoolean

    "
     UserPreferences current opaqueVariablePanelResizing:true
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

searchDialogIsModal
    "true if the search dialog (in textViews) shall be modal (the default)"

    ^ self at:#searchDialogIsModal ifAbsent:true

    "
     UserPreferences current searchDialogIsModal
    "
!

searchDialogIsModal:aBooleanOrNil
    "true if the search dialog (in textViews) shall be modal (the default)"

    ^ self at:#searchDialogIsModal put:aBooleanOrNil

    "
     UserPreferences current searchDialogIsModal:true
     UserPreferences current searchDialogIsModal:false
     UserPreferences current searchDialogIsModal
    "
!

selectOnRightClick
    "the Windows behavior of selecting on a right-click"

    ^ self at:#selectOnRightClick ifAbsent:false
!

selectOnRightClick:aBoolean
    "the Windows behavior of selecting on a right-click"

    ^ self at:#selectOnRightClick put:aBoolean

    "
     UserPreferences current selectOnRightClick:true.
     UserPreferences current selectOnRightClick:false.
    "
!

shiftMouseWheelScrollsHorizontally
    "if true (the default), a shift-mouse-wheel does horizontal scrolling"

    ^ self at:#shiftMouseWheelScrollsHorizontally ifAbsent:[ true ]

    "
     UserPreferences current shiftMouseWheelScrollsHorizontally
    "
!

shiftMouseWheelScrollsHorizontally:aBoolean
    "if true (the default), a shift-mouse-wheel does horizontal scrolling"

    self at:#shiftMouseWheelScrollsHorizontally put:aBoolean

    "
     UserPreferences current shiftMouseWheelScrollsHorizontally
    "
!

shouldRememberLastExtent
    ^ self at:#shouldRememberLastExtent ifAbsent:true

    "Created: / 31-07-2013 / 18:11:17 / cg"
!

shouldRememberLastExtent:aBoolean
    ^ self at:#shouldRememberLastExtent put:aBoolean

    "
     UserPreferences current shouldRememberLastExtent.
     UserPreferences current shouldRememberLastExtent:true.
     UserPreferences current shouldRememberLastExtent:false.
    "

    "Created: / 31-07-2013 / 18:11:25 / cg"
!

showDottedLinesInTree
    ^ self
	at:#showDottedLinesInTree
	ifAbsent:[ OperatingSystem isMSWINDOWSlike not
		   or:[  OperatingSystem isVistaLike not ] ]

    "Created: / 03-12-2010 / 11:31:46 / cg"
    "Modified: / 09-02-2011 / 23:27:03 / cg"
!

showDottedLinesInTree:aBoolean
    ^ self at:#showDottedLinesInTree put:aBoolean

    "
     UserPreferences current showDottedLinesInTree:true.
     UserPreferences current showDottedLinesInTree:false.
    "

    "Created: / 03-12-2010 / 11:31:53 / cg"
!

showRightButtonMenuOnRelease
    "the Windows behavior of showing the right-button menu on a release."

    ^ self at:#showRightButtonMenuOnRelease ifAbsent:true
!

showRightButtonMenuOnRelease:aBoolean
    "the Windows behavior of showing the right-button menu on a release."

    ^ self at:#showRightButtonMenuOnRelease put:aBoolean

    "
     UserPreferences current showRightButtonMenuOnRelease:true.
     UserPreferences current showRightButtonMenuOnRelease:false.
    "
!

startTextDragWithControl
    "if true, textDrag is only started when the CTRL-key is down"

    ^ self at:#startTextDragWithControl ifAbsent:true

    "
     UserPreferences current startTextDragWithControl
    "
!

startTextDragWithControl:aBooleanOrNil
    "if true, textDrag is only started when the CTRL-key is down"

    ^ self at:#startTextDragWithControl put:aBooleanOrNil

    "
     UserPreferences current startTextDragWithControl:true
     UserPreferences current startTextDragWithControl:false
     UserPreferences current startTextDragWithControl
    "
!

toolTipAutoHideDelay
    "return the time in seconds, tooltips are shown. 0 means: show forever"

    ^ self at:#toolTipAutoHideDelay ifAbsentPut:[FlyByHelp showTime]

    "
     UserPreferences current toolTipAutoHideDelay
    "

    "Created: / 10-11-2010 / 12:08:58 / cg"
!

toolTipAutoHideDelay:aTimeDuration
    "set the time, tooltips are shown. 0 means: don't hide"

    self at:#toolTipAutoHideDelay put:aTimeDuration.
    FlyByHelp showTime: (aTimeDuration isInteger
                            ifTrue:[aTimeDuration]
                            ifFalse:[aTimeDuration asSeconds]).

    "
     UserPreferences current toolTipAutoHideDelay:10 seconds
     UserPreferences current toolTipAutoHideDelay:0
    "

    "Created: / 10-11-2010 / 12:09:33 / cg"
    "Modified: / 07-03-2011 / 23:56:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

toolTipShapeStyle
    "return a symbol, or nil. If nil, the value from the stylesheet is used."

    ^ self at:#toolTipShapeStyle ifAbsent:[ nil ]

    "
     UserPreferences current toolTipShapeStyle
     UserPreferences current toolTipShapeStyle:#cartoon
     UserPreferences current toolTipShapeStyle:nil
    "
!

toolTipShapeStyle:aSymbolOrNil
    "A symbol, or nil. If nil, the value from the stylesheet is used."

    self at:#toolTipShapeStyle put:aSymbolOrNil

    "
     UserPreferences current toolTipShapeStyle
     UserPreferences current toolTipShapeStyle:#cartoon
     UserPreferences current toolTipShapeStyle:nil
    "
!

useColorsForColorBlindness
    "return the flag which controls some color combinations
     to compensate for color deficiencies, such as red-green blindness.
     For example, red-green is replaced by red-blue"

    ^ self at:#useColorsForColorBlindness ifAbsent:[ false ]

    "
     UserPreferences current useColorsForColorBlindness
     UserPreferences current useColorsForColorBlindness:true
     UserPreferences current useColorsForColorBlindness:false
    "
!

useColorsForColorBlindness:aBoolean
    "change the flag which controls some color combinations
     to compensate for color deficiencies, such as red-green blindness.
     For example, red-green is replaced by red-blue"

    self at:#useColorsForColorBlindness put:aBoolean

    "
     UserPreferences current useColorsForColorBlindness
     UserPreferences current useColorsForColorBlindness:true
     UserPreferences current useColorsForColorBlindness:false
    "
!

useXFontsOnly
    "experimental:
     a flag to suppress any use of Xft Fonts on X window displays"

    ^ self at:#useXFontsOnly ifAbsent:[ false ]

    "
     UserPreferences current useXFontsOnly
    "
!

useXFontsOnly:aBoolean
    "experimental:
     a flag to suppress any use of Xft Fonts on X window displays"

    self at:#useXFontsOnly put:aBoolean

    "
     UserPreferences current useXFontsOnly
     UserPreferences current useXFontsOnly:true
     UserPreferences current useXFontsOnly:false
     UserPreferences current useXftFontsOnly:true
     UserPreferences current useXftFontsOnly:false
    "
!

useXftFontsOnly
    "experimental:
     return the flag which controls if ONLY Xft fonts should be used.
     If changed, this should be done very early during startup, before any other fonts
     are already acquired (i.e. before any views are opened)"

    ^ self at:#useXftFontsOnly ifAbsent:[ false ]

    "
     UserPreferences current useXftFontsOnly
    "
!

useXftFontsOnly:aBooleanOrNil
    "experimental:
     set/clear the flag which controls if ONLY Xft fonts should be used.
     If changed, this should be done very early during startup, before any other fonts
     are already acquired (i.e. before any views are opened)"

    ^ self at:#useXftFontsOnly put:aBooleanOrNil

    "
     UserPreferences current useXftFontsOnly:true
     UserPreferences current useXftFontsOnly:false
     UserPreferences current useXftFontsOnly
    "
!

viewStyle
    ^ self at:#viewStyle ifAbsent:[ nil ]

    "
     UserPreferences current viewStyle
     UserPreferences current viewStyle:(ViewStyle adwaita)
    "

    "Created: / 24-11-2016 / 17:58:30 / cg"
!

viewStyle:aStyleSymbol
    self at:#viewStyle put:aStyleSymbol

    "
     UserPreferences current viewStyle
     UserPreferences current viewStyle:(ViewStyle adwaita)
    "

    "Created: / 24-11-2016 / 17:58:51 / cg"
!

waitCursorVisibleTime
    "anser the time (in ms), how long a wait cursor should be visible at least"

    ^ 100

    "Modified: / 12-09-2011 / 11:08:53 / cg"
!

workAroundRenderingBugOnVista
    "a temporary kludge for the vista-cleartype character redraw bug"

    ^ OperatingSystem isMSWINDOWSlike

    "Created: / 08-11-2010 / 14:47:52 / cg"
    "Modified: / 09-11-2010 / 13:02:43 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

acceptCancelBarOrder
    "the original order was accept-cancel-compare.
     However, we found that the danger of pressing cancel by accident
     was too high, so we changed the default.
     If you want to go back, return #acceptCancelCompare here"

    ^ self at:#acceptCancelBarOrder ifAbsent:#acceptCompareCancel

    "
     UserPreferences current acceptCancelBarOrder
     UserPreferences current acceptCancelBarOrder: #acceptCompareCancel
     UserPreferences current acceptCancelBarOrder: #acceptCancelCompare
    "
!

acceptCancelBarOrder:aSymbol
    "the original order was accept-cancel-compare.
     However, we found that the danger of pressing cancel by accident
     was too high, so we changed the default.
     If you want to go back, return #acceptCancelCompare here"

    self at:#acceptCancelBarOrder put:aSymbol

    "
     UserPreferences current acceptCancelBarOrder
     UserPreferences current acceptCancelBarOrder: #acceptCompareCancel
     UserPreferences current acceptCancelBarOrder: #acceptCancelCompare
    "
!

autoFormatting
    "return the flag which controls automatic formatting of code (in some browsers)
     Notice, the regular browser does not (yet) do automatic formating."

    ^ self at:#autoFormatting ifAbsent:false

    "
     UserPreferences current autoFormatting
    "

    "Created: / 4.2.2000 / 20:08:08 / cg"
    "Modified: / 5.2.2000 / 15:38:33 / cg"
!

autoFormatting:aBoolean
    "turn on/off automatic formatting of code (in some browsers);
     Notice, the regular browser does not (yet) do automatic formating."

    ^ self at:#autoFormatting put:aBoolean

    "
     UserPreferences current autoFormatting:true
     UserPreferences current autoFormatting:false
    "

    "Created: / 4.2.2000 / 20:08:26 / cg"
    "Modified: / 5.2.2000 / 15:38:20 / cg"
!

autoIndentInCodeView
    "return the flag which controls automatic cursor control in editors which
     show code(autoIndent)"

    ^ self at:#autoIndentInCodeView ifAbsent:true

    "
     UserPreferences current autoIndentInCodeView
    "
!

autoIndentInCodeView:aBoolean
    "flag which controls automatic cursor control in editors which
     show code(autoIndent)"

    ^ self at:#autoIndentInCodeView put:aBoolean

    "
     UserPreferences current autoIndentInCodeView:true
     UserPreferences current autoIndentInCodeView:false
    "
!

confirmCheckinOfPrivateClasses
    "If set, a confirmation dialog is shown when attempting to checkin a private class."

    ^ self at:#confirmCheckinOfPrivateClasses ifAbsent:[true].

    "
     UserPreferences current confirmCheckinOfPrivateClasses
     UserPreferences current confirmCheckinOfPrivateClasses:true
     UserPreferences current confirmCheckinOfPrivateClasses:false
    "
!

confirmCheckinOfPrivateClasses:aBoolean
    "If set, a confirmation dialog is shown when attempting to checkin a private class."

    self at:#confirmCheckinOfPrivateClasses put:aBoolean.

    "
     UserPreferences current confirmCheckinOfPrivateClasses
     UserPreferences current confirmCheckinOfPrivateClasses:true
     UserPreferences current confirmCheckinOfPrivateClasses:false
    "
!

enforceCodeStyle
    "return the flag which controls enforcing a certain code style (in some browsers)"

    ^ self at:#enforceCodeStyle ifAbsent:false

    "
     UserPreferences current enforceCodeStyle
     UserPreferences current enforceCodeStyle:true
     UserPreferences current enforceCodeStyle:false
    "

    "Modified: / 27-03-2007 / 21:51:42 / cg"
!

enforceComment
    "return the flag which controls enforcing a comment in accepted methods"

    ^ self at:#enforceComment ifAbsent:false

    "
     UserPreferences current enforceComment
     UserPreferences current enforceComment:true
     UserPreferences current enforceComment:false
    "

    "Created: / 17-07-2010 / 14:16:27 / cg"
!

enforceComment:aBoolean
    "set/clear the flag which controls enforcing a comment in accepted methods"

    ^ self at:#enforceComment put:aBoolean

    "
     UserPreferences current enforceComment:true
     UserPreferences current enforceComment:false
    "

    "Created: / 17-07-2010 / 14:17:02 / cg"
!

runLintChecksInBackground
    "controls the browser's lint-check behavior;
     background operation (Jan's pref) makes it difficult to stop and debug...)"

    ^ self at:#runLintChecksInBackground ifAbsent:true

    "
     UserPreferences current runLintChecksInBackground
     UserPreferences current runLintChecksInBackground:true
     UserPreferences current runLintChecksInBackground:false
    "

    "Created: / 17-07-2010 / 14:16:27 / cg"
!

runLintChecksInBackground:aBoolean
    "controls the browser's lint-check behavior;
     background operation (Jan's pref) makes it difficult to stop and debug...)"

    ^ self at:#runLintChecksInBackground put:aBoolean

    "
     UserPreferences current runLintChecksInBackground:true
     UserPreferences current runLintChecksInBackground:false
    "

    "Created: / 17-07-2010 / 14:17:02 / cg"
!

showAcceptCancelBarInBrowser
    "this is a little confusing: the codeview2 has its own accept/cancel bar
     which can be turned on separately.
     The codeview2 will suppress the regular accept/cancel bar, if it uses its own."

    ^ self at:#showAcceptCancelBarInBrowser ifAbsent:true

    "
     UserPreferences current showAcceptCancelBarInBrowser
     UserPreferences current showAcceptCancelBarInBrowser:true
     UserPreferences current showAcceptCancelBarInBrowser:false
    "
!

showAcceptCancelBarInBrowser:aBoolean
    "this is a little confusing: the codeview2 has its own accept/cancel bar
     which can be turned on separately.
     The codeview2 will suppress the regular accept/cancel bar, if it uses its own."

    ^ self at:#showAcceptCancelBarInBrowser put:aBoolean

    "
     UserPreferences current showAcceptCancelBarInBrowser:true
     UserPreferences current showAcceptCancelBarInBrowser:false
    "
!

showMarqueeInfo
    "If set, show multiline infos in the info area as a scrolling marquee text"

    ^ self at:#showMarqueeInfo ifAbsent:[true].

    "
     UserPreferences current showMarqueeInfo
     UserPreferences current showMarqueeInfo:true
     UserPreferences current showMarqueeInfo:false
    "

    "Created: / 04-04-2012 / 14:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showMarqueeInfo:aBoolean
    "If set, show multiline infos in the info area as a scrolling marquee text"

    self at:#showMarqueeInfo put:aBoolean.

    "
     UserPreferences current showMarqueeInfo
     UserPreferences current showMarqueeInfo:true
     UserPreferences current showMarqueeInfo:false
    "

    "Created: / 04-04-2012 / 14:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxColoring
    "return the flag which controls syntax coloring (in the browsers)"

    ^ self at:#syntaxColoring ifAbsent:true

    "
     UserPreferences current syntaxColoring
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

syntaxColoring:aBoolean
    "turn on/off syntaxColoring (in the browsers)."

    ^ self at:#syntaxColoring put:aBoolean

    "
     UserPreferences current syntaxColoring:true
     UserPreferences current syntaxColoring:false
    "

    "Created: / 31.3.1998 / 13:44:00 / cg"
    "Modified: / 1.4.1998 / 13:23:03 / cg"
!

useSearchBarInBrowser
    "true, if the search-entry fields are initially shown in the browser itself
     (like in firefox). False if a dialog is to be opened."

    "/ cg: disabled for now, until fixed.
    "/ does not initially select the searchString.
    "/ thereby interrupting the workflow...

    ^ self at:#useSearchBarInBrowser ifAbsent:false

    "
     UserPreferences current useSearchBarInBrowser
     UserPreferences current useSearchBarInBrowser:true
     UserPreferences current useSearchBarInBrowser:false
    "
!

useSearchBarInBrowser:aBoolean
    "true, if the search-entry fields are initially shown in the browser itself
     (like in firefox). False if a dialog is to be opened."

    ^ self at:#useSearchBarInBrowser put:aBoolean

    "
     UserPreferences current useSearchBarInBrowser:true
     UserPreferences current useSearchBarInBrowser:false
    "
! !

!UserPreferences methodsFor:'accessing-prefs-browser-colors'!

colorForInstrumentedFullyCoveredCode
    "the color for code in the browser which is instrumented
     and where all branches have been executed (also code, which has been executed)"

    |clr|

    clr := self at:#colorForInstrumentedFullyCoveredCode ifAbsent:nil.
    clr isNil ifTrue:[
	clr := Color green slightlyDarkened "darkened".
	"/ self at:#colorForInstrumentedFullyCoveredCode put:clr.
    ].
    ^ clr

    "
     UserPreferences current
	at:#emphasisForInstrumentedFullyCoveredCode
	put:(Color green slightlyDarkened).
    "

    "Created: / 28-04-2010 / 13:58:52 / cg"
!

colorForInstrumentedFullyCoveredCode:aColor
    "the color for code in the browser which is instrumented
     and where all branches have been executed (also code, which has been executed)"

    self at:#colorForInstrumentedFullyCoveredCode put:aColor.

    "
     UserPreferences current colorForInstrumentedFullyCoveredCode:(Color green slightlyDarkened).
     UserPreferences current colorForInstrumentedFullyCoveredCode:nil.
    "

    "Created: / 28-04-2010 / 13:58:52 / cg"
!

colorForInstrumentedNeverCalledCode
    "the color for code in the browser which is instrumented but has never been called"

    |clr|

    clr := self at:#colorForInstrumentedNeverCalledCode ifAbsent:nil.
    clr isNil ifTrue:[
	clr := Color red "slightlyDarkened" "darkened".
	"/ self at:#colorForInstrumentedNeverCalledCode put:clr.
    ].
    ^ clr

    "
     UserPreferences current
	at:#colorForInstrumentedNeverCalledCode
	put:(Color red slightlyDarkened).
    "

    "Created: / 28-04-2010 / 13:59:43 / cg"
!

colorForInstrumentedNeverCalledCode:aColor
    "the color for code in the browser which is instrumented but has never been called"

    self at:#colorForInstrumentedNeverCalledCode put:aColor.

    "
     UserPreferences current colorForInstrumentedNeverCalledCode:(Color red slightlyDarkened).
     UserPreferences current colorForInstrumentedNeverCalledCode:nil.
    "

    "Created: / 28-04-2010 / 13:59:43 / cg"
!

colorForInstrumentedPartiallyCoveredCode
    "color for code in the browser which is instrumented and where some branches have been
     executed"

    |clr|

    clr := self at:#colorForInstrumentedPartiallyCoveredCode ifAbsent:nil.
    clr isNil ifTrue:[
	clr := Color orange "slightlyDarkened".
	"/ self at:#colorForInstrumentedPartiallyCoveredCode put:clr.
    ].
    ^ clr

    "
     UserPreferences current
	at:#colorForInstrumentedPartiallyCoveredCode
	put:(Color orange slightlyLightened).
    "

    "Created: / 28-04-2010 / 14:00:56 / cg"
!

colorForInstrumentedPartiallyCoveredCode:aColor
    "color for code in the browser which is instrumented and where some branches have been
     executed"

    self at:#colorForInstrumentedPartiallyCoveredCode put:aColor.

    "
     UserPreferences current colorForInstrumentedPartiallyCoveredCode:(Color orange slightlyLightened).
     UserPreferences current colorForInstrumentedPartiallyCoveredCode:nil.
    "

    "Created: / 28-04-2010 / 14:00:56 / cg"
!

colorForPseudoProtocolsInMethodListInBrowser
    "eventually, make this also a settings value (for people with weak gray-visibility)"

    |bg|

    SelectionInListView notNil ifTrue:[
	bg := SelectionInListView defaultBackgroundColor.
    ].
    bg isNil ifTrue:[
	View notNil ifTrue:[
	    bg := View defaultBackgroundColor.
	].
	bg isNil ifTrue:[
	    ^ Color gray
	].
    ].

    (Color gray brightness - (bg brightness)) abs < 0.3 ifTrue:[
	(bg brightness) > 0.7 ifTrue:[
	    ^ Color gray:20.
	].
	^ Color gray:80.
    ].
    ^ Color gray

    "Created: / 07-09-2011 / 09:51:12 / cg"
!

emphasisForChangedCode
    "the emphasis for changed code (in changeSet) in the browser"

    |emp|

    emp := self at:#emphasisForChangedCode ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color red darkened.
	emp := Array with:#bold with:emp.
	"/ emp := #color->Color blue darkened.
	self at:#emphasisForChangedCode put:emp.
    ].
    ^ emp

    "
     self allInstancesDo:[:pref |pref at:#emphasisForChangedCode put:nil].
     UserPreferences current emphasisForChangedCode.
     UserPreferences current at:#emphasisForChangedCode put:nil.
    "

    "Modified: / 10-11-2006 / 17:27:23 / cg"
!

emphasisForChangedCodeInSmallTeam
    "the emphasis for changed code (in a remote changeSet) in the browser.
     You need the SmallTeam extension to be present for this to work."

    |emp|

    emp := self at:#emphasisForChangedCodeInSmallTeam ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color yellow darkened.
	emp := Array with:#bold with:emp.
	self at:#emphasisForChangedCodeInSmallTeam put:emp.
    ].
    ^ emp

    "
     self allInstancesDo:[:pref |pref at:#emphasisForChangedCodeInSmallTeam put:nil].
     UserPreferences current emphasisForChangedCodeInSmallTeam.
     UserPreferences current at:#emphasisForChangedCodeInSmallTeam put:nil.
    "

    "Created: / 10-11-2006 / 16:31:00 / cg"
!

emphasisForDifferentPackage
    |emp|

    emp := self at:#emphasisForDifferentPackage ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color green darkened.
	"/ emp := Array with:#bold with:emp.
	self at:#emphasisForDifferentPackage put:emp.
    ].
    ^ emp

    "
     self allInstancesDo:[:pref |pref at:#emphasisForDifferentPackage put:nil].
    "
!

emphasisForInstrumentedFullyCoveredCode
    "the emphasis for code in the browser which is instrumented and where all branches have been
     executed"

    |emp|

    emp := self at:#emphasisForInstrumentedFullyCoveredCode ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color green slightlyDarkened.
	emp := Array with:#bold with:emp.
	"/ emp := #color->Color blue darkened.
	self at:#emphasisForInstrumentedFullyCoveredCode put:emp.
    ].
    ^ emp

    "
     UserPreferences current
	at:#emphasisForInstrumentedFullyCoveredCode
	put:(Array with:#bold with:(#color->Color green slightlyDarkened)).
    "

    "Created: / 27-04-2010 / 13:01:01 / cg"
    "Modified: / 27-04-2010 / 14:48:11 / cg"
!

emphasisForInstrumentedNeverCalledCode
    "the emphasis for code in the browser which is instrumented but has never been called"

    |emp|

    emp := self at:#emphasisForInstrumentedNeverCalledCode ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color red slightlyDarkened.
	emp := Array with:#bold with:emp.
	"/ emp := #color->Color blue darkened.
	self at:#emphasisForInstrumentedNeverCalledCode put:emp.
    ].
    ^ emp

    "
     UserPreferences current
	at:#emphasisForInstrumentedNeverCalledCode
	put:(Array with:#bold with:(#color->Color red slightlyDarkened)).
    "

    "Created: / 27-04-2010 / 12:59:47 / cg"
    "Modified: / 27-04-2010 / 14:48:39 / cg"
!

emphasisForInstrumentedPartiallyCoveredCode
    "the emphasis for code in the browser which is instrumented and where some branches have been
     executed"

    |emp|

    emp := self at:#emphasisForInstrumentedPartiallyCoveredCode ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color orange.
	emp := Array with:#bold with:emp.
	"/ emp := #color->Color blue darkened.
	self at:#emphasisForInstrumentedPartiallyCoveredCode put:emp.
    ].
    ^ emp

    "
     UserPreferences current
	at:#emphasisForInstrumentedPartiallyCoveredCode
	put:(Array with:#bold with:(#color->Color orange slightlyLightened)).
    "

    "Created: / 27-04-2010 / 13:01:20 / cg"
    "Modified: / 27-04-2010 / 18:50:43 / cg"
!

emphasisForModifiedBuffer
    |emp|

    emp := self at:#emphasisForModifiedBuffer ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color red darkened.
	emp := Array with:#bold with:emp.
	self at:#emphasisForModifiedBuffer put:emp.
    ].
    ^ emp

    "
     self allInstancesDo:[:pref |pref at:#emphasisForModifiedBuffer put:nil].
    "
!

emphasisForNamespacedCode
    "the emphasis for changed code (in changeSet) in the browser"

    |emp|

    emp := self at:#emphasisForNamespacedCode ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color green darkened.
	"/ emp := Array with:#bold with:emp.
	"/ emp := #color->Color blue darkened.
	self at:#emphasisForNamespacedCode put:emp.
    ].
    ^ emp

    "
     self allInstancesDo:[:pref |pref at:#emphasisForNamespacedCode put:nil].
     UserPreferences current emphasisForNamespacedCode.
     UserPreferences current at:#emphasisForNamespacedCode put:nil.
    "

    "Created: / 01-07-2010 / 18:39:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

emphasisForObsoleteCode
    |emp|

    emp := self at:#emphasisForObsoleteCode ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #color->Color red.
	emp := Array with:#bold with:emp.
	self at:#emphasisForObsoleteCode put:emp.
    ].
    ^ emp

    "
     self allInstancesDo:[:pref |pref at:#emphasisForObsoleteCode put:nil].
    "
!

emphasisForReadVariable
    |emp|

    emp := self at:#emphasisForReadVariable ifAbsent:nil.
    emp isNil ifTrue:[
	emp := #underline.
	self at:#emphasisForReadVariable put:emp.
    ].
    ^ emp
!

emphasisForWrittenVariable
    |emp|

    emp := self at:#emphasisForWrittenVariable ifAbsent:nil.
    emp isNil ifTrue:[
	emp := Array with:#underline with:#underlineColor->Color red.
	self at:#emphasisForWrittenVariable put:emp.
    ].
    ^ emp
! !

!UserPreferences methodsFor:'accessing-prefs-browser-syntaxColoring'!

argumentIdentifierColor
    "the color used for argument identifiers;
     If syntaxColoring is turned on."

    ^ self at:#argumentIdentifierColor ifAbsent:[self identifierColor]

    "Created: / 31.3.1998 / 15:08:20 / cg"
    "Modified: / 1.4.1998 / 13:19:58 / cg"
!

argumentIdentifierEmphasis
    "the emphasis used for argument identifiers;
     If syntaxColoring is turned on."

    ^ self at:#argumentIdentifierEmphasis ifAbsent:[self identifierEmphasis]

    "Created: / 31.3.1998 / 15:16:40 / cg"
    "Modified: / 1.4.1998 / 13:19:55 / cg"
!

badIdentifierColor
    "the color used for illegal identifiers;
     If syntaxColoring is turned on."

    ^ self at:#badIdentifierColor ifAbsent:[self identifierColor]
!

badIdentifierEmphasis
    "the emphasis used for illegal identifiers;
     If syntaxColoring is turned on."

    ^ self at:#badIdentifierEmphasis ifAbsent:[UserPreferences default at:#badIdentifierEmphasis ifAbsent:#normal]

    "Modified: / 21-04-2011 / 12:34:50 / cg"
!

booleanConstantColor
    "the color used for boolean constants;
     If syntaxColoring is turned on."

    ^ self at:#booleanConstantColor ifAbsent:[self constantColor]

    "Created: / 31.3.1998 / 18:12:06 / cg"
    "Modified: / 1.4.1998 / 13:20:07 / cg"
!

booleanConstantEmphasis
    "the emphasis used for boolean constants;
     If syntaxColoring is turned on."

    ^ self at:#booleanConstantEmphasis ifAbsent:[self constantEmphasis]

    "Created: / 31.3.1998 / 18:12:46 / cg"
    "Modified: / 1.4.1998 / 13:26:01 / cg"
!

bracketColor
    "the color used for brackets;
     If syntaxColoring is turned on."

    ^ self at:#bracketColor ifAbsent:[self defaultSyntaxColor]

    "
     self current at:#bracketColor  put:Color red.
     self current at:#bracketEmphasis  put:#bold

     self current bracketColor
     self current bracketEmphasis
    "

    "Created: / 31.3.1998 / 19:11:38 / cg"
    "Modified: / 1.4.1998 / 13:22:33 / cg"
!

bracketEmphasis
    "the emphasis used for brackets;
     If syntaxColoring is turned on."

    ^ self at:#bracketEmphasis ifAbsent:[self defaultSyntaxEmphasis]

    "
     self current at:#bracketEmphasis  put:#bold
     self current bracketEmphasis
    "

    "Created: / 31.3.1998 / 19:11:38 / cg"
    "Modified: / 1.4.1998 / 13:22:33 / cg"
!

classVariableIdentifierColor
    "the color used for classVar/classInstVar identifiers
     If syntaxColoring is turned on."

    ^ self at:#classVariableIdentifierColor ifAbsent:[self globalIdentifierColor]

    "Modified: / 1.4.1998 / 13:20:47 / cg"
    "Created: / 4.3.1999 / 12:50:31 / cg"
!

classVariableIdentifierEmphasis
    "the color used for classVar/classInstVar identifiers
     If syntaxColoring is turned on."

    ^ self at:#classVariableIdentifierEmphasis ifAbsent:[self globalIdentifierEmphasis]

    "Modified: / 1.4.1998 / 13:20:47 / cg"
    "Created: / 4.3.1999 / 12:50:31 / cg"
!

collectionEnumerationSelectorColor
    "the color used for some selected collection enumeration
     selectors (such as collect:, select: etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector color is used."

    ^ self at:#collectionEnumerationSelectorColor ifAbsent:nil

    "Created: / 14-02-2012 / 15:52:39 / cg"
!

collectionEnumerationSelectorEmphasis
    "the color used for some selected collection enumeration
     selectors (such as collect:, select: etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector emphasis is used."

    ^ self at:#collectionEnumerationSelectorEmphasis ifAbsent:nil

    "Created: / 14-02-2012 / 15:58:58 / cg"
!

commentColor
    "the color used for comments;
     If syntaxColoring is turned on."

    ^ self at:#commentColor ifAbsent:[UserPreferences default at:#commentColor ifAbsent:[Color black]]

    "Created: / 31-03-1998 / 15:10:23 / cg"
    "Modified: / 21-04-2011 / 12:33:39 / cg"
!

commentEmphasis
    "the emphasis used for comments;
     If syntaxColoring is turned on."

    ^ self at:#commentEmphasis ifAbsent:[UserPreferences default at:#commentEmphasis ifAbsent:#normal]

    "Created: / 31-03-1998 / 15:09:59 / cg"
    "Modified: / 21-04-2011 / 12:34:48 / cg"
!

commentEmphasisAndColor
    ^ self emphasis:(self commentEmphasis) andColor:(self commentColor).

    "Modified: / 17-02-2011 / 14:20:41 / cg"
!

commentFont
    "the font used for comments; nil if no special font has been defined.
     If syntaxColoring is turned on."

    ^ self at:#commentFont ifAbsent:nil
!

commentFont:aFont
    "the font used for comments; nil if no special font has been defined.
     If syntaxColoring is turned on."

    self at:#commentFont put:aFont

    "
     UserPreferences current commentFont:(XftFontDescription family: 'Comic Sans' size: 12)
     UserPreferences current commentFont
    "
!

constantColor
    "the color used for constants;
     If syntaxColoring is turned on."

    ^ self at:#constantColor ifAbsent:[UserPreferences default at:#constantColor ifAbsent:[Color black]]

    "Created: / 31-03-1998 / 18:13:15 / cg"
    "Modified: / 21-04-2011 / 12:33:36 / cg"
!

constantEmphasis
    "the emphasis used for constants;
     If syntaxColoring is turned on."

    ^ self at:#constantEmphasis ifAbsent:[self identifierEmphasis]

    "Created: / 31.3.1998 / 18:13:23 / cg"
    "Modified: / 1.4.1998 / 13:25:43 / cg"
!

controlFlowSelectorColor
    "the color used for some selected controlFlow selectors (such as if, while etc.);
     If syntaxColoring is turned on."

    ^ self at:#controlFlowSelectorColor ifAbsent:nil

    "Created: / 08-09-2006 / 15:51:20 / cg"
!

controlFlowSelectorEmphasis
    "the emphasis used for some selected controlFlow selectors (such as if, while etc.);
     If syntaxColoring is turned on."

    ^ self at:#controlFlowSelectorEmphasis ifAbsent:nil

    "Created: / 08-09-2006 / 15:51:04 / cg"
!

debugSelectorColor
    "the color used for some selected debug
     selectors (such as halt etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector color is used."

    ^ self at:#debugSelectorColor ifAbsent:nil
!

debugSelectorEmphasis
    "the color used for some selected debug
     selectors (such as halt etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector emphasis is used."

    ^ self at:#debugSelectorEmphasis ifAbsent:nil
!

defaultSyntaxColor
    "the color used for anything else;
     If syntaxColoring is turned on."

    ^ self at:#defaultSyntaxColor ifAbsent:[UserPreferences default at:#defaultSyntaxColor ifAbsent:[Color black]]

    "Modified: / 21-04-2011 / 12:31:48 / cg"
!

defaultSyntaxEmphasis
    "the emphasis used for anything else;
     If syntaxColoring is turned on."

    ^ self
        at:#defaultSyntaxEmphasis
        ifAbsent:[UserPreferences default at:#defaultSyntaxEmphasis ifAbsent:#normal]

    "Modified: / 21-04-2011 / 12:34:46 / cg"
!

emphasis:e andColor:c
    ^ Text addEmphasis:e to:(#color->c).

    "Created: / 17-02-2011 / 14:20:25 / cg"
!

emphasizeParenthesisLevel
    ^ self at:#emphasizeParenthesisLevel ifAbsent:true

    "
     UserPreferences current emphasizeParenthesisLevel
     UserPreferences current emphasizeParenthesisLevel:true
     UserPreferences current emphasizeParenthesisLevel:false
    "
!

emphasizeParenthesisLevel:aBoolean
    self at:#emphasizeParenthesisLevel put:aBoolean

    "
     UserPreferences current emphasizeParenthesisLevel
     UserPreferences current emphasizeParenthesisLevel:true
     UserPreferences current emphasizeParenthesisLevel:false
    "
!

errorColor
    "the color used for illegal identifiers;
     If syntaxColoring is turned on."

    ^ self at:#errorColor ifAbsent:[UserPreferences default at:#errorColor ifAbsent:[Color black]]

    "Modified: / 21-04-2011 / 12:33:33 / cg"
!

errorRaisingSelectorColor
    "the color used for some selected error raising
     selectors (such as raise etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector color is used."

    ^ self at:#errorRaisingSelectorColor ifAbsent:nil
!

errorRaisingSelectorEmphasis
    "the color used for some selected error raising
     selectors (such as raise etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector emphasis is used."

    ^ self at:#errorRaisingSelectorEmphasis ifAbsent:nil
!

fullSelectorCheck
    "with fullSelector check, selectors are searched immediately for
     being implemented in the system. This may not be useful on slow machines"

    ^ self at:#fullSelectorCheck ifAbsent:[UserPreferences default at:#fullSelectorCheck]

    "Created: / 31.3.1998 / 15:09:41 / cg"
    "Modified: / 1.4.1998 / 13:25:06 / cg"
!

globalClassIdentifierColor
    "the color used for global identifiers which are known to be classes;
     If syntaxColoring is turned on."

    ^ self at:#globalClassIdentifierColor ifAbsent:[self globalIdentifierColor]

    "Modified: / 1.4.1998 / 13:20:47 / cg"
    "Created: / 4.3.1999 / 12:50:31 / cg"
!

globalClassIdentifierEmphasis
    "the emphasis used for global variable identifiers which are known to be classes;
     If syntaxColoring is turned on."

    ^ self at:#globalClassIdentifierEmphasis ifAbsent:[self globalIdentifierEmphasis]

    "Modified: / 1.4.1998 / 13:25:31 / cg"
    "Created: / 4.3.1999 / 12:51:00 / cg"
!

globalIdentifierColor
    "the color used for global identifiers;
     If syntaxColoring is turned on."

    ^ self at:#globalIdentifierColor ifAbsent:[self identifierColor]

    "Created: / 31.3.1998 / 15:18:49 / cg"
    "Modified: / 1.4.1998 / 13:20:47 / cg"
!

globalIdentifierEmphasis
    "the emphasis used for global variable identifiers;
     If syntaxColoring is turned on."

    ^ self at:#globalIdentifierEmphasis ifAbsent:[self identifierEmphasis]

    "Created: / 31.3.1998 / 15:18:29 / cg"
    "Modified: / 1.4.1998 / 13:25:31 / cg"
!

hereColor
    "the color used for the here pseudoVariable;
     If syntaxColoring is turned on."

    ^ self at:#hereColor ifAbsent:[self selfColor]

    "Created: / 31.3.1998 / 17:38:09 / cg"
    "Modified: / 1.4.1998 / 13:20:57 / cg"
!

hereEmphasis
    "the emphasis used for the hre special variable;
     If syntaxColoring is turned on."

    ^ self at:#hereEmphasis ifAbsent:[self selfEmphasis]

    "Created: / 31.3.1998 / 17:35:13 / cg"
    "Modified: / 1.4.1998 / 13:25:17 / cg"
!

identifierColor
    "the color used for other identifiers;
     If syntaxColoring is turned on."

    ^ self at:#identifierColor ifAbsent:[self defaultSyntaxColor]

    "
     UserPreferences current at:#identifierColor put:Color green darkened darkened.
     UserPreferences current at:#identifierColor put:Color black.
    "

    "Created: / 31.3.1998 / 17:35:55 / cg"
    "Modified: / 2.4.1998 / 10:39:42 / cg"
!

identifierEmphasis
    "the emphasis used for other identifiers;
     If syntaxColoring is turned on."

    ^ self at:#identifierEmphasis ifAbsent:[self defaultSyntaxEmphasis]

    "Created: / 31.3.1998 / 15:09:41 / cg"
    "Modified: / 1.4.1998 / 13:25:06 / cg"
!

instVarIdentifierColor
    "the color used for instance variable identifiers;
     If syntaxColoring is turned on."

    ^ self at:#instVarIdentifierColor ifAbsent:[self identifierColor]

    "
     UserPreferences current at:#instVarIdentifierColor put:Color green darkened.
     UserPreferences current at:#instVarIdentifierColor put:Color black.
     UserPreferences current instVarIdentifierColor
    "

    "Created: / 16.4.1998 / 18:31:29 / cg"
    "Modified: / 16.4.1998 / 18:57:06 / cg"
!

instVarIdentifierEmphasis
    "the emphais used for instance variable identifiers;
     If syntaxColoring is turned on."

    ^ self at:#instVarIdentifierEmphasis ifAbsent:[self identifierEmphasis]

    "Modified: / 1.4.1998 / 13:24:42 / cg"
    "Created: / 16.4.1998 / 18:40:05 / cg"
!

jsKeywordColor
    ^ self at:#jsKeywordColor ifAbsent:[self defaultSyntaxColor]
!

jsKeywordEmphasis
    ^ self at:#jsKeywordEmphasis ifAbsent:[self defaultSyntaxEmphasis]
!

localIdentifierColor
    "the color used for local variable identifiers;
     If syntaxColoring is turned on."

    ^ self at:#localIdentifierColor ifAbsent:[self identifierColor]

    "
     UserPreferences current at:#localIdentifierColor put:Color green darkened.
     UserPreferences current at:#localIdentifierColor put:Color black.
    "

    "Created: / 31.3.1998 / 15:18:07 / cg"
    "Modified: / 2.4.1998 / 10:40:05 / cg"
!

localIdentifierEmphasis
    "the emphais used for local variable identifiers;
     If syntaxColoring is turned on."

    ^ self at:#localIdentifierEmphasis ifAbsent:[self identifierEmphasis]

    "Created: / 31.3.1998 / 15:16:56 / cg"
    "Modified: / 1.4.1998 / 13:24:42 / cg"
!

methodSelectorColor
    "the color used for a methods selector pattern;
     If syntaxColoring is turned on."

    ^ self at:#methodSelectorColor ifAbsent:[self defaultSyntaxColor]

    "Created: / 31.3.1998 / 15:11:24 / cg"
    "Modified: / 1.4.1998 / 13:24:26 / cg"
!

methodSelectorEmphasis
    "the emphasis used for a methods selector pattern;
     If syntaxColoring is turned on."

    ^ self at:#methodSelectorEmphasis ifAbsent:[UserPreferences default at:#methodSelectorEmphasis ifAbsent:#normal]

    "Created: / 31-03-1998 / 15:11:16 / cg"
    "Modified: / 21-04-2011 / 12:34:42 / cg"
!

numberConstantColor
    "the color used for number constants;
     If syntaxColoring is turned on."

    ^ self at:#numberConstantColor ifAbsent:[ self constantColor ]
!

numberConstantEmphasis
    "the emphasis used for number constants;
     If syntaxColoring is turned on."

    ^ self at:#numberConstantEmphasis ifAbsent:[ self constantEmphasis ]
!

poolVariableIdentifierColor
    "the color used for pool variable identifiers
     If syntaxColoring is turned on."

    ^ self at:#poolVariableIdentifierColor ifAbsent:[self globalIdentifierColor]
!

poolVariableIdentifierEmphasis
    "the color used for pool variable identifiers
     If syntaxColoring is turned on."

    ^ self at:#poolVariableIdentifierEmphasis ifAbsent:[self globalIdentifierEmphasis]
!

returnColor
    "the color used for the return expression;
     If syntaxColoring is turned on."

    ^ self at:#returnColor ifAbsent:[self defaultSyntaxColor]

    "Modified: / 5.1.1980 / 00:43:52 / cg"
!

returnEmphasis
    "the emphasis used for returns;
     If syntaxColoring is turned on."

    ^ self at:#returnEmphasis ifAbsent:[#bold "self defaultSyntaxEmphasis"]

    "Created: / 5.1.1980 / 00:43:39 / cg"
!

selectorColor
    "the color used for message selectors;
     If syntaxColoring is turned on."

    ^ self at:#selectorColor ifAbsent:[self defaultSyntaxColor]

    "Created: / 31.3.1998 / 15:19:19 / cg"
    "Modified: / 1.4.1998 / 13:24:04 / cg"
!

selectorEmphasis
    "the emphasis used for message selectors;
     If syntaxColoring is turned on."

    ^ self at:#selectorEmphasis ifAbsent:[UserPreferences default at:#selectorEmphasis ifAbsent:#normal]

    "Created: / 31-03-1998 / 15:19:09 / cg"
    "Modified: / 21-04-2011 / 12:34:39 / cg"
!

selfColor
    "the color used for the self pseudoVariable;
     If syntaxColoring is turned on."

    ^ self at:#selfColor ifAbsent:[self identifierColor]

    "Created: / 31.3.1998 / 17:35:45 / cg"
    "Modified: / 1.4.1998 / 13:21:07 / cg"
!

selfEmphasis
    "the emphasis used for the self pseudoVariable;
     If syntaxColoring is turned on."

    ^ self at:#selfEmphasis ifAbsent:[self identifierEmphasis]

    "Created: / 31.3.1998 / 17:34:57 / cg"
    "Modified: / 1.4.1998 / 13:21:51 / cg"
!

sideEffectAssignmentBackgroundColor
    "the bg-color used for assignments with side effect (i.e. to instvars, globals, classvars or pool vars).
     If nil is returned, the variable's color is used"

    ^ self at:#sideEffectAssignmentBackgroundColor ifAbsent:[ nil ]

    "Created: / 13-02-2012 / 11:35:20 / cg"
!

sideEffectAssignmentColor
    "the color used for assignments with side effect (i.e. to instvars, globals, classvars or pool vars).
     If nil is returned, the variable's color is used"

    ^ self at:#sideEffectAssignmentColor ifAbsent:[ nil ]

    "Created: / 13-02-2012 / 11:35:09 / cg"
!

stringColor
    "the color used for string constants;
     If syntaxColoring is turned on."

    ^ self at:#stringColor ifAbsent:[self constantColor]

    "Created: / 31.3.1998 / 15:19:50 / cg"
    "Modified: / 1.4.1998 / 13:22:06 / cg"
!

stringEmphasis
    "the emphasis used for string constants;
     If syntaxColoring is turned on."

    ^ self at:#stringEmphasis ifAbsent:[self constantEmphasis]

    "Created: / 31.3.1998 / 15:19:09 / cg"
    "Modified: / 1.4.1998 / 13:22:00 / cg"
!

stringEmphasisAndColor
    ^ self emphasis:(self stringEmphasis) andColor:(self stringColor).

    "Created: / 17-02-2011 / 14:29:10 / cg"
!

superColor
    "the color used for the super pseudoVariable;
     If syntaxColoring is turned on."

    ^ self at:#superColor ifAbsent:[self selfColor]

    "Created: / 31.3.1998 / 17:37:56 / cg"
    "Modified: / 1.4.1998 / 13:21:15 / cg"
!

superEmphasis
    "the emphasis used for the super pseudoVariable;
     If syntaxColoring is turned on."

    ^ self at:#superEmphasis ifAbsent:[self selfEmphasis]

    "Created: / 31.3.1998 / 17:35:08 / cg"
    "Modified: / 1.4.1998 / 13:21:41 / cg"
!

symbolColor
    "the color used for symbol constants;
     If syntaxColoring is turned on."

    ^ self at:#symbolColor ifAbsent:[self constantColor]

    "Created: / 1.4.1998 / 12:57:35 / cg"
    "Modified: / 1.4.1998 / 13:22:16 / cg"
!

symbolEmphasis
    "the emphasis used for symbol constants;
     If syntaxColoring is turned on."

    ^ self at:#symbolEmphasis ifAbsent:[self constantEmphasis]

    "Created: / 1.4.1998 / 12:57:43 / cg"
    "Modified: / 1.4.1998 / 13:23:43 / cg"
!

thisContextColor
    "the color used for the thisContext pseudoVariable;
     If syntaxColoring is turned on."

    ^ self at:#thisContextColor ifAbsent:[self identifierColor]

    "Created: / 31.3.1998 / 17:37:49 / cg"
    "Modified: / 1.4.1998 / 13:21:24 / cg"
!

thisContextEmphasis
    "the emphasis used for the thisContext pseudoVariable;
     If syntaxColoring is turned on."

    ^ self at:#thisContextEmphasis ifAbsent:[self identifierEmphasis]

    "Created: / 31.3.1998 / 17:35:27 / cg"
    "Modified: / 1.4.1998 / 13:21:30 / cg"
!

unimplementedSelectorColor
    "the color used for bad message selectors;
     If syntaxColoring is turned on."

    ^ self at:#unimplementedSelectorColor ifAbsent:[UserPreferences default at:#unimplementedSelectorColor ifAbsent:[Color black]]

    "Modified: / 21-04-2011 / 12:33:29 / cg"
!

unimplementedSelectorEmphasis
    "the emphasis used for bad message selectors;
     If syntaxColoring is turned on."

    ^ self at:#unimplementedSelectorEmphasis ifAbsent:[UserPreferences default at:#unimplementedSelectorEmphasis ifAbsent:#normal]

    "Created: / 31-03-1998 / 15:19:09 / cg"
    "Modified: / 21-04-2011 / 12:34:36 / cg"
!

unknownIdentifierColor
    "the color used for unknown identifiers;
     If syntaxColoring is turned on."

    ^ self at:#unknownIdentifierColor ifAbsent:[self badIdentifierColor]

    "
     self current at:#unknownIdentifierColor  put:Color red.
     self current at:#unknownIdentifierEmphasis  put:#bold

     self current unknownIdentifierColor
     self current unknownIdentifierEmphasis
    "

    "Created: / 31.3.1998 / 19:11:38 / cg"
    "Modified: / 1.4.1998 / 13:22:33 / cg"
!

unknownIdentifierEmphasis
    "the emphasis used for unknown identifiers;
     If syntaxColoring is turned on."

    ^ self at:#unknownIdentifierEmphasis ifAbsent:[self badIdentifierEmphasis]

    "Created: / 31.3.1998 / 19:11:55 / cg"
    "Modified: / 1.4.1998 / 13:22:45 / cg"
!

xmlAttributeColor
    "the emphasis used for xml-attributes;
     If syntaxColoring is turned on."

    ^ self at:#xmlAttributeColor ifAbsent:[ Color green darkened ]

    "
     self current at:#xmlAttributeColor put:Color black
     self current xmlAttributeColor
    "

    "Created: / 24-07-2011 / 21:30:59 / cg"
!

xmlAttributeEmphasis
    "the emphasis used for xml-attributes;
     If syntaxColoring is turned on."

    ^ self at:#xmlAttributeEmphasis ifAbsent:[ #bold "#normal" ]

    "
     self current at:#xmlAttributeEmphasis put:#normal
     self current at:#xmlAttributeEmphasis put:#bold
     self current xmlAttributeEmphasis
    "

    "Created: / 24-07-2011 / 21:30:29 / cg"
!

xmlCDataColor
    "the emphasis used for xml-CData;
     If syntaxColoring is turned on."

    ^ self at:#xmlCDataColor ifAbsent:[ Color blue ]

    "
     self current at:#xmlCDataColor put:Color black
     self current xmlCDataColor
    "

    "Created: / 24-07-2011 / 21:31:30 / cg"
!

xmlCDataEmphasis
    "the emphasis used for xml-CData;
     If syntaxColoring is turned on."

    ^ self at:#xmlCDataEmphasis ifAbsent:[ #normal ]

    "
     self current at:#xmlCDataEmphasis put:#normal
     self current xmlCDataEmphasis
    "

    "Created: / 24-07-2011 / 21:31:52 / cg"
!

xmlTagColor
    "the emphasis used for xml-tags;
     If syntaxColoring is turned on."

    ^ self at:#xmlTagColor ifAbsent:[ Color blue ]

    "
     self current at:#xmlTagColor put:Color black
     self current xmlTagColor
    "

    "Created: / 17-02-2011 / 14:18:28 / cg"
!

xmlTagEmphasis
    "the emphasis used for xml-tags;
     If syntaxColoring is turned on."

    ^ self at:#xmlTagEmphasis ifAbsent:[ #bold ]

    "
     self current at:#xmlTagEmphasis put:#normal
     self current xmlTagEmphasis
    "

    "Created: / 17-02-2011 / 14:18:01 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerAllowEditOfHistory:aBoolean
    "useful if you have 'beginner students', to prevent them from changing the history"

    self
        at: #'history-manager.allow-edit-of-history'
        put:aBoolean
!

historyManagerEnabled
    "automatically add history line comments to accepted methods"

    ^self
        at: #'history-manager.enabled'
        ifAbsent: true
!

historyManagerEnabled:aBoolean
    "automatically add history line comments to accepted methods"

    ^self
        at: #'history-manager.enabled'
        put: aBoolean


    "
     UserPreferences current historyManagerEnabled
     UserPreferences current historyManagerEnabled:true
     UserPreferences current historyManagerEnabled:false
    "
! !

!UserPreferences methodsFor:'accessing-prefs-code'!

categoryForMenuActionsMethods
    ^ 'menu actions'.
!

haltInObsoleteMethod
    "sometimes, these are annoying..."

    ^ self at:#haltInObsoleteMethod ifAbsent:true

    "
     UserPreferences current haltInObsoleteMethod

     UserPreferences current haltInObsoleteMethod:true
     UserPreferences current haltInObsoleteMethod:false
    "
!

ignorePublicPrivateCategories
    "used when loading dolphin code (which defines multiple categories per method);
     if on, categories like public and private are ignored (if the method already has a category).
     Turn this on, to get reasonable categories when loading dolphin code"

    ^ self at:#ignorePublicPrivateCategories ifAbsent:true

    "
     UserPreferences current ignorePublicPrivateCategories
    "

    "Created: / 23-09-2011 / 19:49:37 / cg"
!

ignorePublicPrivateCategories:aBoolean
    "used when loading dolphin code (which defines multiple categories per method);
     if on, categories like public and private are ignored (if the method already has a category).
     Turn this on, to get reasonable categories when loading dolphin code"

    self at:#ignorePublicPrivateCategories put:aBoolean

    "
     UserPreferences current ignorePublicPrivateCategories
    "

    "Created: / 23-09-2011 / 19:49:54 / cg"
!

keepMethodSourceCode
    "when fetching the source from a file/cvs, should the source be kept in the image ?
     If on, the image will grow over time by about 10-20 Mb.
     (will stay that high, even if switched off afterwards)"

    "/ changed to always cache the sources.
    "/ these days, memory is so cheap (times of 4Mb machines are gone)
    ^ self at:#keepMethodSourceCode ifAbsent:true

    "
     UserPreferences current keepMethodSourceCode
    "
!

keepMethodSourceCode:aBoolean
    "when fetching the source from a file/cvs, should the source be kept in the image ?
     If on, the image will grow over time by about 10-20 Mb.
     (will stay that high, even if switched off afterwards)"

    ^ self at:#keepMethodSourceCode put:aBoolean

    "
     UserPreferences current keepMethodSourceCode
     UserPreferences current keepMethodSourceCode:true
    "
!

numberOfLinesForLongMethod
    "how many lines for a method's source to be considered as 'long'"

    ^ self at:#numberOfLinesForLongMethod ifAbsent:30

    "
     UserPreferences current numberOfLinesForLongMethod
    "
! !

!UserPreferences methodsFor:'accessing-prefs-code generator'!

generateComments
    "return true; comments shall be generated (by the codeGenerator tool)"

    ^ self at:#generateComments ifAbsent:true.

    "
     UserPreferences current generateComments
     UserPreferences current generateComments:false
     UserPreferences current generateComments:true
    "
!

generateComments:aBoolean
    "true if comments shall be generated (by the codeGenerator tool)"

    self at:#generateComments put:aBoolean.

    "
     UserPreferences current generateComments
     UserPreferences current generateComments:false
    "
!

generateCommentsForAspectMethods
    "return true; comments shall be generated (by the codeGenerator tool)"

    ^ self at:#generateCommentsForAspectMethods ifAbsent:true.

    "
     UserPreferences current generateCommentsForAspectMethods
    "
!

generateCommentsForAspectMethods:aBoolean
    "true if comments shall be generated (by the codeGenerator tool)"

    self at:#generateCommentsForAspectMethods put:aBoolean.

    "
     UserPreferences current generateCommentsForAspectMethods:false
    "
!

generateCommentsForGetters
    "return true if comments for simple getters are to be generated (by the codeGenerator tool).
     The default is now false, as these look stupid in the browser and were only generated
     for the HTMLDocumentGenerator, which is not able to generate these comments on the fly."

    ^ self generateComments and:[self at:#generateCommentsForGetters ifAbsent:false].

    "
     UserPreferences current generateCommentsForGetters
    "
!

generateCommentsForGetters:aBoolean
    "true if comments for simple getters are to be generated (by the codeGenerator tool).
     The default is now false, as these look stupid in the browser and were only generated
     for the HTMLDocumentGenerator, which is not able to generate these comments on the fly."

    self at:#generateCommentsForGetters put:aBoolean.

    "
     UserPreferences current generateCommentsForGetters
    "
!

generateCommentsForSetters
    "return true if comments for simple setters are to be generated (by the codeGenerator tool).
     The default is now false, as these look stupid in the browser and were only generated
     for the HTMLDocumentGenerator, which is not able to generate these comments on the fly."

    ^ self generateComments and:[self at:#generateCommentsForSetters ifAbsent:false].

    "
     UserPreferences current generateCommentsForSetters
    "
!

generateCommentsForSetters:aBoolean
    "true if comments for simple setters are to be generated (by the codeGenerator tool).
     The default is now false, as these look stupid in the browser and were only generated
     for the HTMLDocumentGenerator, which is not able to generate these comments on the fly."

    self at:#generateCommentsForSetters put:aBoolean.

    "
     UserPreferences current generateSommentsForGetters
    "
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

assignmentBackgroundColorForNavigationService
    ^ (Color rgbValue:16rFFDBDB)
!

codeView2AutoPrettyPrint

    ^self at:#codeView2AutoPrettyPrint ifAbsent: false

    "
     UserPreferences current codeView2AutoPrettyPrint
     UserPreferences current codeView2AutoPrettyPrint:true
     UserPreferences current codeView2AutoPrettyPrint:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 07-08-2011 / 12:46:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeView2AutoPrettyPrint: aBoolean

    ^self at:#codeView2AutoPrettyPrint put: aBoolean

    "
     UserPreferences current codeView2AutoPrettyPrint
     UserPreferences current codeView2AutoPrettyPrint:true
     UserPreferences current codeView2AutoPrettyPrint:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 07-08-2011 / 12:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeView2QuickSendersAndImplementorsOnControl
    "if true, CTRL-click opens the quick senders/implementors menu;
     if false, you have to press ALT"

    ^self at:#codeView2QuickSendersAndImplementorsOnControl ifAbsent: false

    "
     UserPreferences current codeView2QuickSendersAndImplementorsOnControl
     UserPreferences current codeView2QuickSendersAndImplementorsOnControl:true
     UserPreferences current codeView2QuickSendersAndImplementorsOnControl:false"
!

codeView2QuickSendersAndImplementorsOnControl: aBoolean
    "if true, CTRL-click opens the quick senders/implementors menu;
     if false, you have to press ALT"

    ^self at:#codeView2QuickSendersAndImplementorsOnControl put: aBoolean

    "
     UserPreferences current codeView2QuickSendersAndImplementorsOnControl
     UserPreferences current codeView2QuickSendersAndImplementorsOnControl:true
     UserPreferences current codeView2QuickSendersAndImplementorsOnControl:false"
!

selectorBackgroundColorForNavigationService
    ^ (Color rgbValue:"16rADD9FF" 16rDBEEFF)
!

variableBackgroundColorForNavigationService
    ^ self
	at: #variableBackgroundColorForNavigationService
	ifAbsent: [
	    (Color rgbValue:16rFFFFA7)
	    "/ (Color rgbValue:16rEFD7A7)
	]

    "Modified: / 01-10-2013 / 11:35:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-defaultPackages'!

addPreloadedPackage:packageName
    "add this to the set of preloaded packages.
     This will be automatically loaded whenever the system starts"

    (self at:#preloadedPackages ifAbsentPut:[Set new]) add:packageName.
    Smalltalk loadPackage:packageName.

    "
     UserPreferences current preloadedPackages

     UserPreferences current addPreloadedPackage:'stx:goodies/smallsense'
     UserPreferences current removePreloadedPackage:'stx:goodies/smallsense'
    "
!

preloadedPackages
    "the set of preloaded packages.
     These will be automatically loaded whenever the system starts"

    ^ self at:#preloadedPackages ifAbsent:[ #() ].

    "
     UserPreferences current addPreloadedPackage:'stx:goodies/smallsense'
     UserPreferences current removePreloadedPackage:'stx:goodies/smallsense'
     UserPreferences current preloadedPackages
    "
!

preloadedPackages:setOfPreloadedPackages
    "define the set of preloaded packages.
     This will be automatically loaded whenever the system starts"

    |set|

    set := setOfPreloadedPackages asSet.
    self at:#preloadedPackages put:set.
    set do:[:each |
	Smalltalk loadPackage:each
    ].

    "
     UserPreferences current addPreloadedPackage:'stx:goodies/smallsense'
     UserPreferences current removePreloadedPackage:'stx:goodies/smallsense'
     UserPreferences current preloadedPackages
    "
!

removePreloadedPackage:packageName
    "remove this from the set of preloaded packages.
     This will be no longer be automatically loaded whenever the system starts"

    |preloaded|

    preloaded := self at:#preloadedPackages ifAbsent:[nil].
    preloaded notNil ifTrue:[
        preloaded remove:packageName ifAbsent:[]
    ].

    "
     UserPreferences current preloadedPackages

     UserPreferences current addPreloadedPackage:'stx:goodies/smallsense'
     UserPreferences current removePreloadedPackage:'stx:goodies/smallsense'
    "
! !

!UserPreferences methodsFor:'accessing-prefs-editor'!

appendAbbreviationsToCompletionSuggestions
    "show abbreviations in completion"

    ^ self at:#appendAbbreviationsToCompletionSuggestions ifAbsent:false

    "
     UserPreferences current appendAbbreviationsToCompletionSuggestions
     UserPreferences current appendAbbreviationsToCompletionSuggestions:true
     UserPreferences current appendAbbreviationsToCompletionSuggestions:false
    "
!

appendAbbreviationsToCompletionSuggestions:aBoolean
    "show abbreviations in completion"

    ^ self at:#appendAbbreviationsToCompletionSuggestions put:aBoolean

    "
     UserPreferences current appendAbbreviationsToCompletionSuggestions
     UserPreferences current appendAbbreviationsToCompletionSuggestions:true
     UserPreferences current appendAbbreviationsToCompletionSuggestions:false
    "
!

codeCompletionOnControlKey
    "show completion with CTRL-key - experimental"

    ^ self at:#codeCompletionOnControlKey ifAbsent:false

    "
     UserPreferences current codeCompletionOnControlKey
     UserPreferences current codeCompletionOnControlKey:true
     UserPreferences current codeCompletionOnControlKey:false
    "
!

codeCompletionOnControlKey:aBoolean
    "show completion with CTRL key - experimental"

    ^ self at:#codeCompletionOnControlKey put:aBoolean

    "
     UserPreferences current codeCompletionOnControlKey
     UserPreferences current codeCompletionOnControlKey:true
     UserPreferences current codeCompletionOnControlKey:false
    "
!

codeCompletionOnTabKey
    "show completion with TAB-key - experimental"

    ^ self at:#codeCompletionOnTabKey ifAbsent:true

    "
     UserPreferences current codeCompletionOnTabKey
     UserPreferences current codeCompletionOnTabKey:true
     UserPreferences current codeCompletionOnTabKey:false
    "
!

codeCompletionOnTabKey:aBoolean
    "show completion with TAB-key - experimental"

    self at:#codeCompletionOnTabKey put:aBoolean

    "
     UserPreferences current codeCompletionOnTabKey
     UserPreferences current codeCompletionOnTabKey:true
     UserPreferences current codeCompletionOnTabKey:false
    "
!

codeCompletionViewKeyboardNavigationNeedsModifier
    "if you find it annoying, that cursor up/down is intercepted by a floating
     completion view, set this to true. Then cursor up/down are only passed to the completion
     view if a shift- or control modifier is pressed.
     The default is false for backward compatibility"

    ^ self at:#codeCompletionViewKeyboardNavigationNeedsModifier ifAbsent:[false]

    "
     UserPreferences current codeCompletionViewKeyboardNavigationNeedsModifier
     UserPreferences current codeCompletionViewKeyboardNavigationNeedsModifier:true
     UserPreferences current codeCompletionViewKeyboardNavigationNeedsModifier:false
    "
!

codeCompletionViewKeyboardNavigationNeedsModifier:aBoolean
    "if you find it annoying, that cursor up/down is intercepted by a floating
     completion view, set this to true. Then cursor up/down are only passed to the completion
     view if a shift- or control modifier is pressed.
     The default is false for backward compatibility"

    self at:#codeCompletionViewKeyboardNavigationNeedsModifier put:aBoolean

    "
     UserPreferences current codeCompletionViewKeyboardNavigationNeedsModifier
     UserPreferences current codeCompletionViewKeyboardNavigationNeedsModifier:true
     UserPreferences current codeCompletionViewKeyboardNavigationNeedsModifier:false
    "
!

deleteSetsClipboardText
    "if true, a delete also updates the clipboard with the deleted text"

    ^ self at:#deleteSetsClipboardText ifAbsent:false

    "
     UserPreferences current deleteSetsClipboardText
    "
!

deleteSetsClipboardText:aBooleanOrNil
    "if true, a delete also updates the clipboard with the deleted text"

    ^ self at:#deleteSetsClipboardText put:aBooleanOrNil

    "
     UserPreferences current deleteSetsClipboardTextdeleteSetsClipboardText:true
     UserPreferences current deleteSetsClipboardText:false
     UserPreferences current deleteSetsClipboardText
    "
!

enforcedDropModeForFiles
    "when dropping a file, paste the #name, the #contents or ask ?
     (default is nil, for ask)"

    ^ self at:#enforcedDropModeForFiles ifAbsent:nil

    "
     UserPreferences current enforcedDropModeForFiles
    "
!

enforcedDropModeForFiles:aSymbolOrNil
    "when dropping a file, paste the #name, the #contents or ask ?
     (default is nil, for ask)"

    ^ self at:#enforcedDropModeForFiles put:aSymbolOrNil

    "
     UserPreferences current enforcedDropModeForFiles:#contents
     UserPreferences current enforcedDropModeForFiles:#name
    "
!

extendedWordSelectMode
    "when double clicking, include underscore, dollar and at-character as word-characters ?
     (default is on)"

    ^ self at:#extendedWordSelectMode ifAbsent:true

    "
     UserPreferences current extendedWordSelectMode
    "

    "Created: / 03-07-2006 / 16:49:58 / cg"
!

extendedWordSelectMode:aBoolean
    "when double clicking, include underscore, dollar and at-character as word-characters ?
     (default is on)"

    ^ self at:#extendedWordSelectMode put:aBoolean

    "
     UserPreferences current extendedWordSelectMode:true
     UserPreferences current extendedWordSelectMode:false
    "

    "Created: / 03-07-2006 / 16:50:20 / cg"
!

generateBackupFileWhenSaving
    "if true, the editor will write a backup file
     before saving. The default is true"

    ^ self at:#generateBackupFileWhenSaving ifAbsent:true "false"
!

generateBackupFileWhenSaving:aBoolean
    "if true, the editor will write a backup file
     before saving. The default is true"

    self at:#generateBackupFileWhenSaving put:aBoolean
!

immediateCodeCompletion
    "show completion, as you type - experimental"

    ^ self at:#immediateCodeCompletion ifAbsent:true "false"

    "
     UserPreferences current immediateCodeCompletion
     UserPreferences current immediateCodeCompletion:true
     UserPreferences current immediateCodeCompletion:false
    "
!

immediateCodeCompletion:aBoolean
    "show completion, as you type - experimental"

    ^ self at:#immediateCodeCompletion put:aBoolean

    "
     UserPreferences current immediateCodeCompletion
     UserPreferences current immediateCodeCompletion:true
     UserPreferences current immediateCodeCompletion:false
    "
!

numberOfRememberedUndoOperationsInEditor
    "the number of possible undo-operations.
     Nil means: unlimited.
     Notice: you may run out of memory, if editing a lot and the number of undos is not limited."

    ^ self at:#numberOfRememberedUndoOperationsInEditor ifAbsent:nil

    "
     UserPreferences current numberOfRememberedUndoOperationsInEditor
    "

    "Modified: / 09-10-2006 / 11:01:35 / cg"
!

numberOfRememberedUndoOperationsInEditor:aNumberOrNil
    "the number of possible undo-operations.
     Nil means: unlimited.
     Notice: you may run out of memory, if editing a lot and the number of undos is not limited."

    ^ self at:#numberOfRememberedUndoOperationsInEditor put:aNumberOrNil

    "
     UserPreferences current numberOfRememberedUndoOperationsInEditor:20
    "

    "Created: / 09-10-2006 / 11:00:56 / cg"
!

selectAllWhenClickingBeyondEnd
    "select mode, when clicking after the end of text,
     as in st80 (or squeak), select all"

    ^ self at:#selectAllWhenClickingBeyondEnd ifAbsent:false

    "
     UserPreferences current selectAllWhenClickingBeyondEnd
    "

    "Created: / 07-03-2012 / 14:00:17 / cg"
!

selectAllWhenClickingBeyondEnd:aBoolean
    "select mode, when clicking after the end of text,
     as in st80 (or squeak), select all"

    ^ self at:#selectAllWhenClickingBeyondEnd put:aBoolean

    "
     UserPreferences current selectAllWhenClickingBeyondEnd:true
     UserPreferences current selectAllWhenClickingBeyondEnd:false
    "

    "Created: / 07-03-2012 / 14:00:23 / cg"
!

selectionExtensionMode
    "Returns selection extension mode. Mode is either

    #traditional ... Shift-End always moves end of selection (iff it is on the same line)
		     Shift->Home always moves beggining of selection (iff it is on the same line)
		     That's how CG likes it.

    #standard ...    That's how vast majority text editors and text widgets behaves, therefore
		     this is how most users expects it to behave.


    For historical reasons, #traditional is the default..."

    ^ self at: #selectionExtensionMode ifAbsent:[ #traditional ]



    "
    UserPreferences current selectionExtensionMode

    UserPreferences current selectionExtensionMode:#traditional
    UserPreferences current selectionExtensionMode:#standard
    UserPreferences current selectionExtensionMode:nil

    UserPreferences current selectionExtensionMode

    "

    "Created: / 27-03-2014 / 09:19:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionExtensionMode: aSymbol
    "Sets selection extension mode. Must be either:

    #traditional ... Shift-End always moves end of selection (iff it is on the same line)
		     Shift->Home always moves beggining of selection (iff it is on the same line)
		     That's how CG likes it.

    #standard ...    That's how vast majority text editors and text widgets behaves, therefore
		     this is how most users expects it to behave.


    For historical reasons, #traditional is the default..."

    aSymbol isNil ifTrue:[
	self removeKey:#selectionExtensionMode.
	^ self.
    ].

    (#(traditional standard) includes: aSymbol) ifFalse:[
	self error:'Invalid value. Possible values are #traditional and #standard'.
    ].
    self at: #selectionExtensionMode put: aSymbol



    "
    UserPreferences current selectionExtensionMode

    UserPreferences current selectionExtensionMode:#traditional
    UserPreferences current selectionExtensionMode:#standard
    UserPreferences current selectionExtensionMode:nil

    UserPreferences current selectionExtensionMode

    "

    "Created: / 27-03-2014 / 09:18:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

st80EditMode
    "editing as in st80 (do not allow cursor beyond endOfLine/endOftext)."

    ^ self at:#st80EditMode ifAbsent:[false]

    "
     UserPreferences current st80EditMode
     UserPreferences current st80EditMode:true
     UserPreferences current st80EditMode
     UserPreferences current st80EditMode:false
     UserPreferences current st80EditMode
    "
!

st80EditMode:aBoolean
    "editing as in st80 (do not allow cursor beyond endOfLine/endOftext)."

    ^ self at:#st80EditMode put:aBoolean

    "
     UserPreferences current st80EditMode:true
     UserPreferences current st80EditMode:false
    "
!

st80SelectMode
    "select mode, when double clicking as in st80
     (select to corresponding lparen/double-quote) ?"

    ^ self at:#st80SelectMode ifAbsent:[false]

    "
     UserPreferences current st80SelectMode
    "

    "Created: / 03-07-2006 / 16:25:19 / cg"
!

st80SelectMode:aBoolean
    "select mode, when double clicking as in st80
     (select to corresponding lparen/double-quote)."

    ^ self at:#st80SelectMode put:aBoolean

    "
     UserPreferences current st80SelectMode:true
     UserPreferences current st80SelectMode:false
    "

    "Created: / 03-07-2006 / 16:25:27 / cg"
!

trimBlankLines
    "if true, blank lines are trimmed to zero size in the editor"

    ^ self at:#trimBlankLines ifAbsent:[true]

    "
     UserPreferences current trimBlankLines
     UserPreferences current trimBlankLines:true
     UserPreferences current trimBlankLines
     UserPreferences current trimBlankLines:false
     UserPreferences current trimBlankLines
    "
!

trimBlankLines:aBoolean
    "if true, blank lines are trimmed to zero size in the editor"

    self at:#trimBlankLines put:aBoolean

    "
     UserPreferences current trimBlankLines
     UserPreferences current trimBlankLines:true
     UserPreferences current trimBlankLines
     UserPreferences current trimBlankLines:false
     UserPreferences current trimBlankLines
    "
!

whitespaceWordSelectMode
    "when double clicking, treat ANY non-whitespace as word-characters ?
     (default is off)"

    ^ self at:#whitespaceWordSelectMode ifAbsent:false

    "
     UserPreferences current whitespaceWordSelectMode
    "

    "Created: / 03-07-2006 / 16:49:58 / cg"
!

whitespaceWordSelectMode:aBoolean
    "when double clicking, treat ANY non-whitespace as word-characters ?
     (default is off)"

    ^ self at:#whitespaceWordSelectMode put:aBoolean

    "
     UserPreferences current whitespaceWordSelectMode:true
     UserPreferences current whitespaceWordSelectMode:false
    "

    "Created: / 03-07-2006 / 16:50:20 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-external tools'!

defaultFileOpenCommandFor:suffix
    "for the fileBrowser - remember which command to use as-per suffix"

    ^ (self at:#defaultFileOpenCommands ifAbsentPut:[Dictionary new])
        at:suffix ifAbsent:nil
!

defaultFileOpenCommandFor:suffix put:openCmd
    "for the fileBrowser - remember which command to use as-per suffix"

    (self at:#defaultFileOpenCommands ifAbsentPut:[Dictionary new])
        at:suffix put:openCmd
!

osFileExplorerCommand
    "return an OS command template to open a finder/explorer or similar"

    ^ self at:#osFileExplorerCommand ifAbsent:nil
!

osFileExplorerCommand:aString
    "define an OS command template to open a finder/explorer or similar"

    self at:#osFileExplorerCommand put:aString

    "
     UserPreferences current osFileExplorerCommand

     osx:
     UserPreferences current osFileExplorerCommand:'open %1'

     linux:
     UserPreferences current osFileExplorerCommand:'nautilus %1'
     UserPreferences current osFileExplorerCommand:'dolphin %1'
    "
! !

!UserPreferences methodsFor:'accessing-prefs-files and directories'!

changeFileName
    "were to keep changes"

    ^ self
        at: #'changeFileName'
        ifAbsent: [nil]
!

changeFileName:aFilename
    "were to keep changes"

    self
	at: #'changeFileName'
	put: aFilename.
!

usersModuleName
    "this will be taken as the user's module in the workspace and as a default for new projects"

    ^ self at:#usersModuleName ifAbsent:[OperatingSystem getLoginName ]
!

usersModuleName:aString
    self at:#usersModuleName put:aString
!

workspaceDirectory
    "this is the folder where snapshot images, the change file and any stc-compiled
     object files are stored.
     The idea is to keep that stuff together, so we can move it as a bunch.
     These used to be in the bin-folder of st/x, but that would not work with readonly/shared
     st/x installations."

    ^ self at:#workspaceDirectory ifAbsent:[self class defaultWorkspaceDirectory]
!

workspaceDirectory:aDirectoryOrNilForDefault
    |d|

    (d := aDirectoryOrNilForDefault) notNil ifTrue:[
        d := d asFilename
    ].
    self at:#workspaceDirectory put:d
! !

!UserPreferences methodsFor:'accessing-prefs-localization'!

language
    "/ intermediate migration code;
    "/ for now, Smalltalk uses a global language and territory setting;
    "/ however, for multi-user operation, this must be in a preference-setting.
    "/ For now, forward to smalltalk, until all references to "Smalltalk-language"
    "/ are replaced with "UserPreferences current language"

    self useSystemLanguage ifTrue:[
        ^ OperatingSystem getLanguage
    ] ifFalse:[
        ^ self at:#language ifAbsent:[OperatingSystem getLanguage].
    ].

    "
     UserPreferences current language
    "

    "Created: / 20-09-2006 / 23:55:01 / cg"
    "Modified: / 20-11-2017 / 14:02:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

language:aLanguageSymbol
    "/ intermediate migration code;
    "/ for now, Smalltalk uses a global language and territory setting;
    "/ however, for multi-user operation, this must be in a preference-setting.
    "/ For now, forward to smalltalk, until all references to "Smalltalk-language"
    "/ are replaced with "UserPreferences current language"

    | changed |

    changed := self language ~= aLanguageSymbol.
    self at:#language put:aLanguageSymbol.
    changed ifTrue:[
        Smalltalk changed: #Language; changed: #LanguageTerritory.
    ].


    "
     UserPreferences current language
     UserPreferences current language:#en
    "

    "Created: / 20-09-2006 / 23:55:01 / cg"
    "Modified: / 21-11-2017 / 21:29:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageTerritory
    "/ intermediate migration code;
    "/ for now, Smalltalk uses a global language and territory setting;
    "/ however, for multi-user operation, this must be in a preference-setting.
    "/ for now, forward to smalltalk, while all references to "Smalltalk-language"
    "/ are replaced with "UserPreferences current language"

    self useSystemLanguage ifTrue:[
        ^ OperatingSystem getLanguageTerritory
    ] ifFalse:[
        ^ self at:#languageTerritory ifAbsent:[self language].
    ].


    "
     UserPreferences current languageTerritory
    "

    "Created: / 20-09-2006 / 23:55:01 / cg"
    "Modified: / 20-11-2017 / 14:13:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageTerritory:aLanguageSymbol
    "/ intermediate migration code;
    "/ for now, Smalltalk uses a global language and territory setting;
    "/ however, for multi-user operation, this must be in a preference-setting.
    "/ For now, forward to smalltalk, until all references to "Smalltalk-language"
    "/ are replaced with "UserPreferences current language"

   | changed |

    changed := self language ~= aLanguageSymbol.
    self at:#languageTerritory put:aLanguageSymbol.
    changed ifTrue:[
        Smalltalk changed: #LanguageTerritory
    ].

    "
     UserPreferences current languageTerritory
     UserPreferences current languageTerritory:#en
    "

    "Created: / 20-09-2006 / 23:55:01 / cg"
    "Modified: / 21-11-2017 / 21:29:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unitForFileSize
    "may return either 1000 or 1024"

    ^ self at:#unitForFileSize ifAbsent:[1000]
!

unitStringsForFileSize
    self unitForFileSize == 1024 ifTrue:[
        ^ #('Byte' 'KiB' 'MiB' 'GiB' 'TiB' 'PiB' 'EiB' 'ZiB' 'YiB')
    ] ifFalse:[
        ^ #('Byte' 'KB' 'MB' 'GB' 'TB' 'PB' 'EB' 'ZB' 'YB')
    ].
!

useSystemLanguage
    "if true, the operating system's language is used (i.e. LANG environment variable),
     when the system comes up. If false, the setting here is used.
     The default is true."

    ^ self at:#useSystemLanguage ifAbsent:[true].

    "
     UserPreferences current useSystemLanguage
     UserPreferences current useSystemLanguage:false
     UserPreferences current useSystemLanguage:true
    "
!

useSystemLanguage:aBoolean
    "if true, the operating system's language is used (i.e. LANG environment variable),
     when the system comes up. If false, the setting here is used.
     The default is true."

    | changed |

    changed := self useSystemLanguage ~= aBoolean.
    self at:#useSystemLanguage put:aBoolean.
    changed ifTrue:[
        Smalltalk changed: #Language; changed: #LanguageTerritory.
    ].




    "
     UserPreferences current useSystemLanguage
     UserPreferences current useSystemLanguage:false
    "

    "Modified: / 21-11-2017 / 21:29:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-startup'!

autoloadedPackages
    "list of package names, which are automatically loaded upon startup"

    ^ self at:#autoloadedPackages ifAbsent:[#()]
!

autoloadedPackages:aCollectionOfPackageNames
    "list of package names, which are automatically loaded upon startup"

    self at:#autoloadedPackages put:aCollectionOfPackageNames
! !

!UserPreferences methodsFor:'accessing-prefs-times'!

timeToAutoExpandItemsWhenDraggingOver
    "in a hierarchical tree view"

    ^ 700  "/ millis
!

twoDigitDateHandler
    "return a block which converts a two-digit date.
     Possible algorithms:
	- identity: treat as year 00..99
	- add 1900: treat as 1900..1999
	- around: treat as 1950..1999 if value is 50..99; 2000..2049 otherwise.

     TODO: make this configurable, keep in dictionary and add to settings.
    "

    ^ [:x | (x >= 50) ifTrue:[1900+x] ifFalse:[2000+x]].
    "/ ^ [:x | 1900+x].
    "/ ^ [:x | x].
! !

!UserPreferences methodsFor:'accessing-prefs-tools'!

allowSendMailFromDebugger
    "if true inserts a button in Debugger for open a GUI to send useful debugger infos per mail to a default
     mail account "

    ^ self at:#allowSendMailFromDebugger ifAbsent:true

    "
     UserPreferences current allowSendMailFromDebugger
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

allowSendMailFromDebugger:aBoolean
    "if true inserts a button in Debugger for open a GUI to send useful debugger infos per mail to a default
     mail account "

    ^ self at:#allowSendMailFromDebugger put:aBoolean

    "
     UserPreferences current allowSendMailFromDebugger:true
     UserPreferences current allowSendMailFromDebugger:false
    "
!

autoDefineWorkspaceVariables
    "return the flag which controls automatic definition of unknown variables
     as workspace variables (in doIts)"

    ^ self at:#autoDefineWorkspaceVariables ifAbsent:false

    "
     UserPreferences current autoDefineWorkspaceVariables
    "
!

autoDefineWorkspaceVariables:aBoolean
    "turn on/off automatic definition of unknown variables
     as workspace variables (in doIts)"

    ^ self at:#autoDefineWorkspaceVariables put:aBoolean

    "
     UserPreferences current autoDefineWorkspaceVariables:true
     UserPreferences current autoDefineWorkspaceVariables:false
    "
!

autoRaiseDebugger
    "if true, the debugger raises itself automatically when entered.
     The default is true"

    ^ self at:#autoRaiseDebugger ifAbsent:true

    "
     UserPreferences current autoRaiseDebugger
    "

    "Created: / 15-05-2007 / 13:29:10 / cg"
!

autoRaiseDebugger:aBoolean
    "if true, the debugger raises itself automatically when entered.
     The default is true"

    ^ self at:#autoRaiseDebugger put:aBoolean

    "
     UserPreferences current autoRaiseDebugger
     UserPreferences current autoRaiseDebugger:false
     UserPreferences current autoRaiseDebugger:true
    "

    "Created: / 15-05-2007 / 13:29:31 / cg"
!

autoRaiseOnFocusInDelay
    "if non-nil, an application window will raise automatically,
     when it gets the focus (via the window manager) after that
     number of milliseconds. If nil, autoRaise is disabled.
     Especially useful with focusFollowsMouse under X11"

    ^ self at:#autoRaiseOnFocusInDelay ifAbsent:nil

    "
     UserPreferences current autoRaiseOnFocusInDelay
    "
!

autoRaiseOnFocusInDelay:anIntegerOrNil
    "if non-nil, an application window will raise automatically,
     when it gets the focus (via the window manager) after that
     number of milliseconds. If nil, autoRaise is disabled.
     Especially useful with focusFollowsMouse under X11"

    ^ self at:#autoRaiseOnFocusInDelay put:anIntegerOrNil

    "
     UserPreferences current autoRaiseOnFocusInDelay
     UserPreferences current autoRaiseOnFocusInDelay:nil
     UserPreferences current autoRaiseOnFocusInDelay:750
    "
!

autoRaiseTranscript
    "if true, the transcript raises itself automatically when new messages appear.
     The default is false"

    ^ self at:#autoRaiseTranscript ifAbsent:false

    "
     UserPreferences current autoRaiseTranscript
    "
!

autoRaiseTranscript:aBoolean
    "if true, the transcript raises itself automatically when new messages appear.
     The default is false"

    |transcript|

    self at:#autoRaiseTranscript put:aBoolean.
    (self == UserPreferences current) ifTrue:[
        transcript := Transcript current.
        (transcript notNil and:[transcript isTextCollector]) ifTrue:[
            transcript autoRaise:aBoolean.
        ].
    ].

    "
     UserPreferences current autoRaiseTranscript:true
     UserPreferences current autoRaiseTranscript:false
     UserPreferences current autoRaiseTranscript
    "
!

debuggerLogFile
    "if non nil, any entered debugger writes a backrace to that logfile.
     This is useful to record all session-problems"

    ^ self at:#debuggerLogFile ifAbsent:nil

    "
     UserPreferences current debuggerLogFile
     UserPreferences current debuggerLogFile:'debug.log'
     UserPreferences current debuggerLogFile:nil
    "
!

debuggerLogFile:aFilename
    "if non nil, any entered debugger writes a backrace to that logfile.
     This is useful to record all session-problems"

    ^ self at:#debuggerLogFile put:aFilename

    "
     UserPreferences current debuggerLogFile
     UserPreferences current debuggerLogFile:'debug.log'
     UserPreferences current debuggerLogFile:nil
    "
!

editToolbarVisibleInWorkspace
    "return the flag which defaults the edit-toolbar-visibility in a workspace application"

    ^ self at:#editToolbarVisibleInWorkspace ifAbsent:false
!

editToolbarVisibleInWorkspace:aBooleanOrNil
    "set the flag which defaults the edit-toolbar-visibility in a workspace application"

    ^ self at:#editToolbarVisibleInWorkspace put:aBooleanOrNil
!

functionKeySequences
    "return the collection of function-key macros.
     That's a dictionary, which assigns code to F-keys"

    ^ self at:#functionKeySequences ifAbsentPut:[Dictionary new]

    "
     UserPreferences current functionKeySequences
    "

    "Modified: / 11-09-1998 / 00:09:59 / cg"
    "Modified (comment): / 06-06-2016 / 10:43:30 / cg"
!

hideSupportCodeInDebugger
    ^ self at:#hideSupportCodeInDebugger ifAbsent:true

    "
     UserPreferences current hideSupportCodeInDebugger
    "

    "Created: / 10-06-2012 / 21:24:09 / cg"
!

hideSupportCodeInDebugger:aBooleanOrNil
    ^ self at:#hideSupportCodeInDebugger put:aBooleanOrNil

    "Created: / 10-06-2012 / 21:24:18 / cg"
!

infoVisibleInWorkspace
    "return the flag which defaults the info-visibility in a workspace application"

    ^ self at:#infoVisibleInWorkspace ifAbsent:false

    "Created: / 14-07-2007 / 16:43:37 / cg"
!

infoVisibleInWorkspace:aBooleanOrNil
    "set the flag which defaults the info-visibility in a workspace application"

    ^ self at:#infoVisibleInWorkspace put:aBooleanOrNil

    "Created: / 14-07-2007 / 16:43:44 / cg"
!

sendMessagesAlsoToTranscript
    "return the flag which controls if info/error messages are to be shown
     on both Stderr AND the Transcript, or only on Stderr"

    ^ self at:#sendMessagesAlsoToTranscript ifAbsent:true

    "
     UserPreferences current sendMessagesAlsoToTranscript
    "
!

sendMessagesAlsoToTranscript:aBooleanOrNil
    "set/clear the flag which controls if info/error messages are to be shown
     on both Stderr AND the Transcript, or only on Stderr"

    ^ self at:#sendMessagesAlsoToTranscript put:aBooleanOrNil

    "
     UserPreferences current sendMessagesAlsoToTranscript:false.
     'hello' infoPrintCR.

     UserPreferences current sendMessagesAlsoToTranscript:true.
     'hello' infoPrintCR.
    "
!

sendMessagesOnlyToTranscript
    "return the flag which controls if info/error messages are to be shown
     on Stderr (if true is returned, they are only shown on the Transcript)"

    ^ self at:#sendMessagesOnlyToTranscript ifAbsent:false

    "
     UserPreferences current sendMessagesOnlyToTranscript
    "
!

sendMessagesOnlyToTranscript:aBoolean
    "set the flag which controls if info/error messages are to be shown
     on Stderr (if true is returned, they are only shown on the Transcript)"

    self at:#sendMessagesOnlyToTranscript put:aBoolean

    "
     UserPreferences current sendMessagesOnlyToTranscript:true.
     'hello' errorPrintCR.

     UserPreferences current sendMessagesOnlyToTranscript:false.
     'hello' errorPrintCR.

     UserPreferences current sendMessagesOnlyToTranscript
    "
!

showClockInLauncher
    "return the flag which controls if a clock is shown in the launcher"

    ^ self at:#showClockInLauncher ifAbsent:false

    "
     UserPreferences current showClockInLauncher
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

showClockInLauncher:aBooleanOrNil
    "set/clear the flag which controls if a clock is shown in the launcher"

    ^ self at:#showClockInLauncher put:aBooleanOrNil

    "
     UserPreferences current showClockInLauncher:false.
     NewLauncher open.

     UserPreferences current showClockInLauncher:true.
     NewLauncher open.
    "

    "Modified: / 11.9.1998 / 00:09:59 / cg"
!

showTypeIndicatorInInspector
    ^ self at:#showTypeIndicatorInInspector ifAbsent:true

    "
     UserPreferences current showTypeIndicatorInInspector
    "

    "Created: / 16-05-2012 / 19:09:50 / cg"
!

showTypeIndicatorInInspector:aBooleanOrNil
    ^ self at:#showTypeIndicatorInInspector put:aBooleanOrNil

    "
     UserPreferences current showTypeIndicatorInInspector:false.
     NewLauncher inspect.

     UserPreferences current showTypeIndicatorInInspector:true.
     NewLauncher inspect.
    "

    "Created: / 16-05-2012 / 19:10:13 / cg"
!

terminalInputIsUTF8
    "if true, a shell or unix command accepts utf8 encoded input and character input
     should be encoded as such by the terminal emulator."

    ^ self
        at:#terminalInputIsUTF8
        ifAbsent:[ OperatingSystem isOSXlike
                   "/ or ???
                 ]

    "
     UserPreferences current terminalInputIsUTF8
    "
!

terminalInputIsUTF8:aBoolean
    "if true, a shell or unix command accepts utf8 encoded input and character input
     should be encoded as such by the terminal emulator.
     This specifies a default setting for terminal views; individual instances can be
     changed be calling a corresponding setup method on it."

    ^ self
        at:#terminalInputIsUTF8
        put:aBoolean

    "
     UserPreferences current terminalInputIsUTF8
     UserPreferences current terminalInputIsUTF8:true
     UserPreferences current terminalInputIsUTF8:false
    "
!

terminalOutputIsUTF8
    "if true, the shell's output is utf8 encoded and should be decoded by
     the terminal emulator."

    ^ self
	at:#terminalOutputIsUTF8
	ifAbsent:[ OperatingSystem isOSXlike
		   "/ or ???
		 ]

    "
     UserPreferences current terminalOutputIsUTF8
    "
!

terminalOutputIsUTF8:aBoolean
    "if true, the shell's output is utf8 encoded and should be decoded by
     the terminal emulator.
     This specifies a default setting for terminal views; individual instances can be
     changed be calling a corresponding setup method on it."

    ^ self
        at:#terminalOutputIsUTF8
        put:aBoolean

    "
     UserPreferences current terminalOutputIsUTF8
     UserPreferences current terminalOutputIsUTF8:true
     UserPreferences current terminalOutputIsUTF8:false
    "
!

toolbarVisibleInWorkspace
    "return the flag which defaults the toolbar-visibility in a workspace application"

    ^ self at:#toolbarVisibleInWorkspace ifAbsent:true

    "Modified: / 18-07-2007 / 08:55:44 / cg"
!

toolbarVisibleInWorkspace:aBooleanOrNil
    "set the flag which defaults the toolbar-visibility in a workspace application"

    ^ self at:#toolbarVisibleInWorkspace put:aBooleanOrNil

    "Created: / 14-07-2007 / 16:42:09 / cg"
!

useJavaCompletionEngineSimple
    "/ switch to false, when the JavaCompletionEngine is
    "/ finished.

    ^ true
!

useNewLayoutInDebugger
    ^ self at:#useNewLayoutInDebugger ifAbsent:true

    "
     UserPreferences current useNewLayoutInDebugger
    "
!

useNewLayoutInDebugger:aBoolean
    ^ self at:#useNewLayoutInDebugger put:aBoolean
!

useRefactoringSupport
    "return the flag which enables/disables use of refactoring package in browser.
     If enabled, this enables all kinds of refactorings, better search and undo features.
     There is usually no reason to disable these."

    ^ self at:#useRefactoringSupport ifAbsent:true
!

useRefactoringSupport:aBooleanOrNil
    "enable/disable use of refactoring package in browser.
     If enabled, this enables all kinds of refactorings, better search and undo features.
     There is usually no reason to disable these."

    ^ self at:#useRefactoringSupport put:aBooleanOrNil

    "
     UserPreferences current useRefactoringSupport:false
     UserPreferences current useRefactoringSupport:true
    "
!

verboseBacktraceInDebugger
    ^ self at:#verboseBacktraceInDebugger ifAbsent:true

    "
     UserPreferences current verboseBacktraceInDebugger
    "
!

verboseBacktraceInDebugger:aBoolean
    ^ self at:#verboseBacktraceInDebugger put:aBoolean
! !

!UserPreferences methodsFor:'accessing-prefs-tools-building'!

autoUnloadAutoloadedClassesInProjectDefinition
    ^ self at:#autoUnloadAutoloadedClassesInProjectDefinition ifAbsent:false

    "
     UserPreferences current autoUnloadAutoloadedClassesInProjectDefinition
    "

    "Created: / 28-01-2014 / 21:42:59 / cg"
!

autoUnloadAutoloadedClassesInProjectDefinition:aBoolean
    ^ self at:#autoUnloadAutoloadedClassesInProjectDefinition put:aBoolean

    "
     UserPreferences current autoUnloadAutoloadedClassesInProjectDefinition
     UserPreferences current autoUnloadAutoloadedClassesInProjectDefinition:false
    "

    "Created: / 28-01-2014 / 21:43:18 / cg"
!

buildDirectory
    ^ self at:#buildDirectory ifAbsent:nil

    "
     UserPreferences current buildDirectory
    "
!

buildDirectory:aFilenameStringOrNil
    ^ self at:#buildDirectory put:aFilenameStringOrNil

    "
     UserPreferences current buildDirectory
    "
!

localBuild
    "deployment-build in  a local directory (as opposed to making via the repository)"

    ^ self at:#localBuild ifAbsent:true

    "Created: / 20-09-2006 / 23:55:01 / cg"
!

localBuild:aBoolean
    "deployment-build in  a local directory (as opposed to making via the repository)"

    ^ self at:#localBuild put:aBoolean

    "
     UserPreferences current localBuild
    "

    "Created: / 20-09-2006 / 23:55:26 / cg"
!

suppressProjectDefinitionWarnings
    ^ self at:#suppressProjectDefinitionWarnings ifAbsent:true

    "
     UserPreferences current suppressProjectDefinitionWarnings
    "

    "Created: / 28-01-2014 / 21:41:01 / cg"
!

suppressProjectDefinitionWarnings:aBoolean
    ^ self at:#suppressProjectDefinitionWarnings put:aBoolean

    "
     UserPreferences current suppressProjectDefinitionWarnings
     UserPreferences current suppressProjectDefinitionWarnings:true
    "

    "Created: / 28-01-2014 / 21:41:12 / cg"
!

usedCompilerForBuild
    ^ self at:#usedCompilerForBuild ifAbsent:nil

    "
     UserPreferences current usedCompilerForBuild
    "

    "Created: / 22-01-2012 / 10:52:47 / cg"
!

usedCompilerForBuild:aString
    ^ self at:#usedCompilerForBuild put:aString

    "
     UserPreferences current usedCompilerForBuild
     UserPreferences current usedCompilerForBuild:'bcc'
    "

    "Created: / 22-01-2012 / 10:52:59 / cg"
! !

!UserPreferences methodsFor:'accessing-scm'!

showBadRevisionStringDialogs
    "show a dialog when a bad revision string is encountered, or silently fix it"

    ^ self at: #'showBadRevisionStringDialogs' ifAbsent:true

    "Created: / 19-08-2011 / 12:51:25 / cg"
!

showBadRevisionStringDialogs:aBoolean
    "show a dialog when a bad revision string is encountered, or silently fix it"

    ^ self at: #'showBadRevisionStringDialogs' put:aBoolean

    "Created: / 19-08-2011 / 12:51:58 / cg"
! !




!UserPreferences methodsFor:'default settings-syntax colors'!

listOfPredefinedSyntaxColoringSchemes
    "return a list of pre-defined syntax highlightning styles
     (as shown in the Launchers 'source and debugger settings' dialog."

    ^ #(
	    (#resetSyntaxColors                                         'default [ST/X style]')
	    (#resetSyntaxColorsWithSideEffectHighlighting               'default with side effect highlighting [new ST/X style]')
	    (#resetSyntaxColorsToVCStyle                                'green comments; blue controlFlow, red constants [VISUAL-C style]')
	    (#resetSyntaxColorsBlueControlFlowSelectors                 'blue controlFlow')
	    (#resetSyntaxColorsGreenComments                            'green comments')
	    (#resetSyntaxColorsGreenCommentsBlueControlFlowSelectors    'green comments; blue controlFlow')
	    (#resetSyntaxColorsBlueSelectorsGreenComments               'blue selectors; green comments [DOLPHIN style]')
	    (#resetSyntaxColorsBlueSelectorsGreyComments                'blue selectors; grey comments')
	    (#resetSyntaxColorsToSqueakStyle1                           'blue selectors; green comments [SQUEAK style]')
	    (#resetSyntaxColorsToSqueakStyle2                           'blue selectors; green comments; brown self [new SQUEAK style]')
	    (#resetSyntaxColorsAllBlackExceptBadIDs                     'no colors, but highlight errors')
	    (#resetSyntaxColorsToVAgeStyle                              'blue globals; green comments [V''Age style]')
	    (#resetSyntaxColorsToVW7Style                               'light blue comments [VW7 style]')
      )

    "Modified: / 17-03-2012 / 10:40:18 / cg"
!

resetSyntaxColors
    "resets the colors in the CurrentPreferences to their default values"

    self class syntaxColorKeys do:[:k | self removeKey:k ifAbsent:nil].


!

resetSyntaxColorsAllBlackExceptBadIDs
    "resets the colors in the CurrentPreferences to no-color mode,
     except for bad identifiers, which are underwaved."

    self resetSyntaxColors.
    self at:#badIdentifierEmphasis  put:(Array with:#underwave with:(#underlineColor->Color red)).
    self at:#errorColor             put:Color black.
    self at:#commentColor           put:Color black.
    self at:#constantColor          put:Color black.
    self at:#methodSelectorEmphasis put:#normal.
    self at:#selectorEmphasis       put:#normal.

    "Modified: / 16-03-2012 / 10:35:02 / cg"
!

resetSyntaxColorsBlueControlFlowSelectors
    "resets the colors in the CurrentPreferences to alternative default values
     (with blue control flow selectors)"

    self resetSyntaxColors.
    self at:#controlFlowSelectorColor put:(Color blue).

    "Created: / 08-09-2006 / 16:11:52 / cg"
!

resetSyntaxColorsBlueSelectorsGreenComments
    "resets the colors in the CurrentPreferences to alternative default values
     (with blue selectors and green comments)"

    self resetSyntaxColors.
    self at:#commentColor           put:(Color green darkened).
    self at:#commentEmphasis        put:#italic.
    self at:#selectorColor          put:(Color blue).
    self at:#selectorEmphasis       put:#normal.
    self at:#methodSelectorColor    put:(Color blue).
    self at:#methodSelectorEmphasis put:#bold.

    "Modified: / 16-03-2012 / 10:34:55 / cg"
!

resetSyntaxColorsBlueSelectorsGreyComments
    "resets the colors in the CurrentPreferences to alternative default values
     (with blue selectors and grey comments)"

    self resetSyntaxColorsBlueSelectorsGreenComments.
    self at:#commentColor    put:(Color gray).
!

resetSyntaxColorsGreenComments
    "resets the colors in the CurrentPreferences to alternative default values
     (with green comments)"

    self resetSyntaxColors.
    self at:#commentColor put:(Color green darkened).

    "Modified: / 16-03-2012 / 10:34:50 / cg"
!

resetSyntaxColorsGreenCommentsBlueControlFlowSelectors
    "resets the colors in the CurrentPreferences to alternative default values
     (with green comments, blue control flow)"

    self resetSyntaxColors.
    self at:#commentColor put:(Color green darkened).
    self at:#controlFlowSelectorColor put:(Color blue).

    "Created: / 08-09-2006 / 16:10:38 / cg"
!

resetSyntaxColorsToSqueakStyle
    "resets the colors in the CurrentPreferences to alternative default values"

    self resetSyntaxColorsToSqueakStyle2

    "Modified (comment): / 17-03-2012 / 10:38:07 / cg"
!

resetSyntaxColorsToSqueakStyle1
    "resets the colors in the CurrentPreferences to alternative default values
     (with blue selectors and green comments)"

    self resetSyntaxColors.
    self at:#commentColor             put:(Color green darkened).
    self at:#commentEmphasis          put:#italic.
    self at:#selectorColor            put:(Color blue:80).
    self at:#selectorEmphasis         put:#normal.
    self at:#methodSelectorColor      put:(Color black).
    self at:#methodSelectorEmphasis   put:#bold.
    self at:#globalIdentifierEmphasis put:#bold.
    self at:#localIdentifierColor     put:(Color grey:40).
    self at:#instVarIdentifierEmphasis put:#bold.
    self at:#constantColor            put:(Color red:67).

    "Modified: / 16-03-2012 / 10:34:40 / cg"
    "Modified (comment): / 17-03-2012 / 10:38:47 / cg"
!

resetSyntaxColorsToSqueakStyle2
    "resets the colors in the CurrentPreferences to alternative default values
     (with blue selectors and green comments)"

    self resetSyntaxColors.
    self at:#commentColor             put:(Color green darkened).
    self at:#commentEmphasis          put:#italic.
    self at:#selectorColor            put:(Color blue:80).
    self at:#selectorEmphasis         put:#normal.
    self at:#controlFlowSelectorEmphasis put:#bold.
    self at:#methodSelectorColor      put:(Color black).
    self at:#methodSelectorEmphasis   put:#bold.
    self at:#globalIdentifierEmphasis put:#bold.
    self at:#localIdentifierColor     put:(Color grey:40).
    self at:#instVarIdentifierEmphasis put:#bold.
    self at:#constantColor            put:(Color red:67).
    self at:#selfColor                put:(Color red:50 ).
    self at:#selfEmphasis             put:#bold.
    self at:#localIdentifierColor     put:(Color grey:50 ).
    self at:#localIdentifierEmphasis  put:#normal.

    "Modified: / 16-03-2012 / 10:34:35 / cg"
    "Modified (comment): / 17-03-2012 / 10:38:57 / cg"
!

resetSyntaxColorsToVAgeStyle
    "resets the colors in the CurrentPreferences to alternative default values
     (green comments, blue globals)"

    self resetSyntaxColors.
    self at:#identifierColor          put:(Color rgbValue:16r00007F).
    self at:#argumentColor            put:(Color rgbValue:16r00007F).
    self at:#identifierEmphasis       put:#normal.
    self at:#commentColor             put:(Color rgbValue:16r007F00).
    self at:#selfColor                put:(Color rgbValue:16r7F007F).
    self at:#constantColor            put:(Color rgbValue:16r7F0000).
    self at:#selectorColor            put:(Color black).
    self at:#selectorEmphasis         put:#bold.
    self at:#globalIdentifierColor    put:(Color blue).
    self at:#methodSelectorColor      put:(Color black).
    self at:#methodSelectorEmphasis   put:#bold.

    "Created: / 17-03-2012 / 10:37:42 / cg"
!

resetSyntaxColorsToVCStyle
    "resets the colors in the CurrentPreferences to visual C default style
     (green comments, blue keywords, redish string constants)"

    self resetSyntaxColors.
    self at:#controlFlowSelectorColor put:(Color blue).
    self at:#commentColor             put:(Color green darkened).
    self at:#constantColor            put:(Color red:64 green:8 blue:8).

    "Modified: / 16-03-2012 / 10:34:30 / cg"
    "Modified (comment): / 17-03-2012 / 10:39:11 / cg"
!

resetSyntaxColorsToVW7Style
    "resets the colors in the CurrentPreferences to alternative default values
     (with light blue comments, green variables)"

    self resetSyntaxColors.
    self at:#commentColor             put:(Color blue lightened).
    self at:#selectorColor            put:(Color black).
    self at:#selectorEmphasis         put:#normal.
    self at:#methodSelectorColor      put:(Color black).
    self at:#methodSelectorEmphasis   put:#bold.
    self at:#identifierEmphasis       put:#normal.
    self at:#identifierColor          put:(Color green darkened).

    "Modified: / 16-03-2012 / 10:34:26 / cg"
    "Modified (comment): / 17-03-2012 / 10:39:18 / cg"
!

resetSyntaxColorsWithSideEffectHighlighting
    "resets the colors in the CurrentPreferences to their default values
     plus side effect highlighting (assignments to instvars and globals are marked)"

    self resetSyntaxColors.
    self at:#sideEffectAssignmentBackgroundColor put:(Color rgbValue:16rFFDBDB).

    "Created: / 13-02-2012 / 12:12:56 / cg"
! !

!UserPreferences methodsFor:'default values'!

defaultValue
    "the defaultValue for non-existing keys"

    ^ nil
!

errorKeyNotFound:aKey
    "for any non-existing key, false is returned"

    ^ self defaultValue
! !

!UserPreferences methodsFor:'initialization'!

initialize
    super initialize.
    self class initializeDefaultsIn: self.
    self beUnmodified.

    "Modified: / 07-06-2017 / 11:32:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'misc'!

doesNotUnderstand:aMessage
    |k def numArgs|

    k := aMessage selector.
    (numArgs := aMessage numArgs) == 0 ifTrue:[
        (self includesKey:k) ifTrue:[
            ^ self at:k
        ].
        ((def := self class default) includesKey:k) ifTrue:[
            ^ def at:k
        ].
        ^ self defaultValue
    ].

    "/ this is needed, if a setting is loaded (via the settings.stx) at a time
    "/ when the corresponding package which uses that setting is not yet loaded;
    "/ for example: libsvn settings, with no libsvn being present.
    "/ if obsolete keys accumulate over time, we might need a settings cleanup GUI to
    "/ care for that.

    (numArgs == 1 and:[k endsWith:$:]) ifTrue:[
        k := k copyButLast asSymbol.
        ^ self at:k put:(aMessage arg1)
    ].

    numArgs == 1 ifTrue:[
        Logger info:'obsolete settings key ignored: %1' with:aMessage selector.
        ^ nil
    ].

    ^ super doesNotUnderstand:aMessage

    "Modified (comment): / 19-08-2011 / 14:01:56 / cg"
!

flyByHelpSettingChanged
    FlyByHelp notNil ifTrue:[
	(self at:#flyByHelpActive ifAbsent:true) ifTrue:[
	    FlyByHelp start.
	] ifFalse:[
	    FlyByHelp stop.
	].
    ].
! !

!UserPreferences methodsFor:'obsolete'!

useNewSettinsApplication
    <resource: #obsolete>
    "obsolete - will be removed in next release.
     (this is kept for a while, as it may have found its way into some
      saved user preference files)"

    self obsoleteMethodWarning.
    ^ self useNewSettingsApplication
!

useNewSettinsApplication:aBoolean
    <resource: #obsolete>
    "obsolete - will be removed in next release"

    self obsoleteMethodWarning.
    self useNewSettingsApplication:aBoolean.
! !

!UserPreferences methodsFor:'saving'!

saveIn:fileName
    self class saveSettings:self in:fileName

    "
     UserPreferences current saveIn:'test.settings'
    "
! !

!UserPreferences class methodsFor:'documentation'!

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
    ^ '$ Id: UserPreferences.st 10648 2011-06-23 15:55:10Z vranyj1  $'
! !

