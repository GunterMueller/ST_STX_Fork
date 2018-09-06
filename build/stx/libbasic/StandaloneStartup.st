"
 COPYRIGHT (c) 2006 by eXept Software AG
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

Object subclass:#StandaloneStartup
	instanceVariableNames:''
	classVariableNames:'Verbose CommandLineArguments'
	poolDictionaries:''
	category:'System-Support'
!

StandaloneStartup class instanceVariableNames:'MutexHandle'

"
 No other class instance variables are inherited by this class.
"
!

!StandaloneStartup class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    When smalltalk is started as IDE (stx), the show starts in Smalltalk>>start.
    In contrast, when a standAlone app is linked, 
    the show starts in the startup class's start method.

    This class is an abstrat, subclassable template for a standalone GUI-application's startup.

    For your own stand alone programs, define a subclass of this, 
    and redefine the #main: method there.
    (of course, the other methods can also be redefined.)

    [author:]
        Claus Gittinger

    [start with:]
        <yourNamehere>Startup start

    [see also:]
        Smalltalk
        GetOpt
        ReadEvalPrintLoop
        StandaloneStartupHeadless
"
!

howToDealWithMultipleApplicationInstances
"
    please read the comment in the corresponding ApplicationModel class-documentation method.
"
!

whichMethodsToRedefine
"
    main:argv
        that's the actual program.

    suppressRCFileReading
        false here; redefine to return true, to disable the rc-file reading.
        you loose the chance of configuration, but lock the user out from any access to any smalltalk
        (if you have a user-phobia)

    allowDebugOption
        false here; redefine to return true, to enable the --debug startup option.
        if disabled, you loose the chance of debugging, but lock the user out from any access to any smalltalk

    allowScriptingOption
        false here; redefine to return true, to enable the --scripting startup option.
        if disabled, you loose the chance of remote control, but lock the user out from any access to any smalltalk

"
! !

!StandaloneStartup class methodsFor:'initialization'!

initialize
    "/ Verbose := true.
    Verbose := false.
! !

!StandaloneStartup class methodsFor:'debugging support'!

dumpCoverageInformation
    "if the --coverage argument was given, dump that information now.
     This is invoked via an exit block, when smalltalk terminates"

    "/ count instrumented vs. non-instrumented classes
    |nClasses nMethods 
     locOverall locExecuted locUnexecuted locInstrumented locUninstrumented
     locCovered locUncovered
     nInstrumentedClasses nUninstrumentedClasses nPartiallyInstrumentedClasses
     nInstrumentedMethods nUninstrumentedMethods 
     nClassesCompletelyCovered nClassesPartiallyCovered nClassesUncovered
     nMethodsCompletelyCovered nMethodsPartiallyCovered nMethodsUncovered|

    nInstrumentedClasses := nUninstrumentedClasses := nPartiallyInstrumentedClasses := 0.
    nInstrumentedMethods := nUninstrumentedMethods := 0.
    nClasses := nMethods := 0.
    locOverall := locCovered := locUncovered := 0.
    locInstrumented := locUninstrumented := 0.
    locExecuted := locUnexecuted := 0.
    nClassesCompletelyCovered := nClassesPartiallyCovered := nClassesUncovered := 0.
    nMethodsCompletelyCovered := nMethodsPartiallyCovered := nMethodsUncovered := 0.

    Smalltalk allClassesDo:[:eachClass |
        |nInstrumentedMethodsInClass nUninstrumentedMethodsInClass
         nMethodsCompletelyCoveredInClass nMethodsPartiallyCoveredInClass nMethodsUncoveredInClass
         locInstrumentedMethodsInClass locUninstrumentedMethodsInClass
         locExecutedInClass locUnexecutedInClass locPartiallyExecutedInClass|

        nMethodsCompletelyCoveredInClass := nMethodsPartiallyCoveredInClass := nMethodsUncoveredInClass := 0.
        nInstrumentedMethodsInClass := nUninstrumentedMethodsInClass := 0.
        locInstrumentedMethodsInClass := locUninstrumentedMethodsInClass := 0.
        eachClass instAndClassMethodsDo:[:mthd |
            |locMethod|

            nMethods := nMethods + 1.
            locMethod := 0. "/ mthd source asCollectionOfLines size.

            mthd isInstrumented ifTrue:[
                nInstrumentedMethodsInClass := nInstrumentedMethodsInClass + 1.
                locInstrumentedMethodsInClass := locInstrumentedMethodsInClass + locMethod.
                mthd hasBeenCalled ifTrue:[
                    mthd haveAllBlocksBeenExecuted ifTrue:[
                        "/ fully covered
                        nMethodsCompletelyCoveredInClass := nMethodsCompletelyCoveredInClass + 1
                    ] ifFalse:[
                        "/ partially covered
                        nMethodsPartiallyCoveredInClass := nMethodsPartiallyCoveredInClass + 1
                    ]
                ] ifFalse:[
                    "/ completely uncovered
                    nMethodsUncoveredInClass := nMethodsUncoveredInClass + 1
                ].
            ] ifFalse:[
                nUninstrumentedMethodsInClass := nUninstrumentedMethodsInClass + 1.
                locUninstrumentedMethodsInClass := locUninstrumentedMethodsInClass + locMethod.
            ].
        ].

        nInstrumentedMethods := nInstrumentedMethods + nInstrumentedMethodsInClass.
        nUninstrumentedMethods := nUninstrumentedMethods + nUninstrumentedMethodsInClass.

        nMethodsCompletelyCovered := nMethodsCompletelyCovered + nMethodsCompletelyCoveredInClass.
        nMethodsUncovered := nMethodsUncovered + nMethodsUncoveredInClass.
        nMethodsPartiallyCovered := nMethodsPartiallyCovered + nMethodsPartiallyCoveredInClass.

        nClasses := nClasses + 1.
        nInstrumentedMethodsInClass == 0 ifTrue:[
            nUninstrumentedMethodsInClass == 0 ifTrue:[
                "/ empty class - do not count
            ] ifFalse:[
                "/ completely uninstrumented
                nUninstrumentedClasses := nUninstrumentedClasses + 1.
            ].
        ] ifFalse:[
            nUninstrumentedMethodsInClass == 0 ifTrue:[
                "/ completely instrumented
                nInstrumentedClasses := nInstrumentedClasses + 1.
            ] ifFalse:[
                "/ part/part
                nPartiallyInstrumentedClasses := nPartiallyInstrumentedClasses + 1.
            ].
        ].

        nMethodsCompletelyCoveredInClass > 0 ifTrue:[
            nClassesCompletelyCovered := nClassesCompletelyCovered + 1.
        ] ifFalse:[
            nMethodsPartiallyCoveredInClass > 0 ifTrue:[
                nClassesPartiallyCovered := nClassesPartiallyCovered + 1.
            ] ifFalse:[
                nClassesUncovered := nClassesUncovered + 1.
            ].
        ].
    ].
    
    Stderr nextPutLine:'Coverage info:'.
    Stderr nextPutLine:('  Classes, overall: %1' bindWith:nClasses).
    Stderr nextPutLine:('  Classes, instrumented: %1 (%2%%)' bindWith:nInstrumentedClasses with:((nInstrumentedClasses / nClasses * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Classes, uninstrumented: %1 (%2%%)' bindWith:nUninstrumentedClasses with:((nUninstrumentedClasses / nClasses * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Classes, partially instrumented: %1 (%2%%)' bindWith:nPartiallyInstrumentedClasses with:((nPartiallyInstrumentedClasses / nClasses * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Classes, covered: %1 (%2%%)' bindWith:nClassesCompletelyCovered with:((nClassesCompletelyCovered / nClasses * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Classes, partially covered: %1 (%2%%)' bindWith:nClassesPartiallyCovered with:((nClassesPartiallyCovered / nClasses * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Classes, uncovered: %1 (%2%%)' bindWith:nClassesUncovered with:((nClassesUncovered / nClasses * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Methods, overall: %1' bindWith:nMethods).
    Stderr nextPutLine:('  Methods, instrumented: %1 (%2%%)' bindWith:nInstrumentedMethods with:((nInstrumentedMethods / nMethods * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Methods, uninstrumented: %1 (%2%%)' bindWith:nUninstrumentedMethods with:((nUninstrumentedMethods / nMethods * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Methods, covered: %1 (%2%%)' bindWith:nMethodsCompletelyCovered with:((nMethodsCompletelyCovered / nMethods * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Methods, partially covered: %1 (%2%%)' bindWith:nMethodsPartiallyCovered with:((nMethodsPartiallyCovered / nMethods * 100) asFixedPoint:1)).
    Stderr nextPutLine:('  Methods, uncovered: %1 (%2%%)' bindWith:nMethodsUncovered with:((nMethodsUncovered / nMethods * 100) asFixedPoint:1)).

    "
     self dumpCoverageInformation
    "

    "Created: / 24-05-2011 / 17:08:46 / cg"
    "Modified: / 25-05-2011 / 00:10:51 / cg"
!

handleCoverageMeasurementOptionsFromArguments:argv
    "handle the coverage measurement command line argument:
        --coverage 
            [+/-]package: <package-pattern>       ... do / do not measure in package (regex match)
            [+/-]class: <class-pattern>           ... do / do not measure in class (regex match, including nameSpace)
            [+/-]method: <className>#<methodName> ... do / do not measure in method

     adds instrumentation code to all selected methods.
    "

    |idx nextArg done doAdd addNames addMethodNames
     anyItem nMethodsInstrumented checkClass checkMethod coverageAction
     includedPackageNames excludedPackageNames 
     includedClassNames excludedClassNames 
     includedMethodNames excludedMethodNames|

"
 self handleCoverageMeasurementOptionsFromArguments:#('foo' '--coverage' '+package:' 'expeccoNET:*' '-class:' 'ExpeccoNET::ML' 'ExpeccoNET::LicenseString'  )
 self handleCoverageMeasurementOptionsFromArguments:#('foo' '--coverage' '+package:' 'stx:*')
 self handleCoverageMeasurementOptionsFromArguments:#('foo' '--coverage' '+package:' 'stx:libtool*')
 self handleCoverageMeasurementOptionsFromArguments:#('foo' '--coverage' '+class:' 'Tools::*' '-class:' 'Tools::StringSearchTool' )
 self handleCoverageMeasurementOptionsFromArguments:#('foo' '--coverage' '+class:' 'Tools::*Browser*'  )
 self handleCoverageMeasurementOptionsFromArguments:#('foo' '--coverage' '+method:' 'String#at:put:' 'String#at:')
"
    includedPackageNames := Set new.
    excludedPackageNames := Set new.
    includedClassNames := Set new.
    excludedClassNames := Set new.
    includedMethodNames := Dictionary new.
    excludedMethodNames := Dictionary new.

    idx := argv indexOfAny:#('--coverage').
    idx == 0 ifTrue:[^ self ].

    addNames := [:collection |
            [ 
                nextArg := argv at:idx ifAbsent:nil.
                nextArg notNil 
                    and:[ ((nextArg startsWith:'+') or:[(nextArg startsWith:'-')]) not
                    and:[ (nextArg endsWith:':') not ]]
            ] whileTrue:[
                collection add:nextArg.
                anyItem := true.
                idx := idx + 1.
            ].
        ].

    addMethodNames := [:collection |
            |idx2 className selector|

            [ 
                nextArg := argv at:idx ifAbsent:nil.
                nextArg notNil 
                    and:[ ((nextArg startsWith:'+') or:[(nextArg startsWith:'-')]) not]
            ] whileTrue:[
                idx2 := nextArg indexOf:$#.
                className := nextArg copyTo:idx2-1.
                selector := nextArg copyFrom:idx2+1.
                (collection at:className ifAbsentPut:[Set new]) add:selector.
                anyItem := true.
                idx := idx + 1.
            ].
        ].

    idx := idx + 1.
    done := false.

    [ 
        nextArg := argv at:idx ifAbsent:nil.
        done not 
            and:[ nextArg notNil 
            and:[ ((nextArg startsWith:'+') or:[(nextArg startsWith:'-')]) ]]
    ] whileTrue:[
        idx := idx + 1.
        doAdd := nextArg first == $+.
        nextArg := nextArg copyFrom:2.
        nextArg = 'package:' ifTrue:[
            addNames value:(doAdd ifTrue:includedPackageNames ifFalse:excludedPackageNames). 
        ] ifFalse:[
            nextArg = 'class:' ifTrue:[
                addNames value:(doAdd ifTrue:includedClassNames ifFalse:excludedClassNames). 
            ] ifFalse:[
                nextArg = 'method:' ifTrue:[
                    addMethodNames value:(doAdd ifTrue:includedMethodNames ifFalse:excludedMethodNames).
                ] ifFalse:[
                    done := true
                ]
            ].
        ].
    ].

    anyItem ifFalse:[ ^ self ].
    nMethodsInstrumented := 0.

    coverageAction := [:aMethod |
            ((aMethod sends:#subclassResponsibility) not
            and:[ aMethod hasPrimitiveCode not ]) ifTrue:[
                Transcript show:'instrumenting '; showCR:aMethod.
                aMethod mclass recompile:aMethod selector usingCompilerClass:InstrumentingCompiler.
                nMethodsInstrumented := nMethodsInstrumented + 1.
            ] ifFalse:[
                Transcript show:'skipped '; showCR:aMethod.
            ].
        ].

    checkMethod := [:someMethod |
            ((excludedMethodNames at:someMethod mclass name ifAbsent:#()) includes:someMethod selector) ifFalse:[
                coverageAction value:someMethod
            ].
        ].

    checkClass := [:someClass |
            someClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                checkMethod value:mthd
            ]
        ].

    Smalltalk allClassesDo:[:eachClass |
        (includedPackageNames contains:[:somePackagePattern| somePackagePattern match:(eachClass package)]) ifTrue:[
            (excludedPackageNames contains:[:somePackagePattern| somePackagePattern match:(eachClass package)]) ifFalse:[
                (excludedClassNames contains:[:someClassPattern| someClassPattern match:(eachClass name)]) ifFalse:[
                    checkClass value:eachClass
                ]
            ]
        ] ifFalse:[
            (includedClassNames contains:[:someClassPattern| someClassPattern match:(eachClass name)]) ifTrue:[
                (excludedClassNames contains:[:someClassPattern| someClassPattern match:(eachClass name)]) ifFalse:[
                    checkClass value:eachClass
                ]
            ] ifFalse:[ 
                (Array with:eachClass theMetaclass with:eachClass) do:[:clsOrMeta |
                    |selectors|

                    selectors := includedMethodNames at:clsOrMeta name ifAbsent:nil.
                    selectors notEmptyOrNil ifTrue:[
                        selectors do:[:eachSelector |
                            coverageAction value:(clsOrMeta compiledMethodAt:eachSelector asSymbol).
                        ].
                    ].
                ].
            ].
        ].
    ].

    nMethodsInstrumented ifTrue:[
        Transcript show:('%1 methods instrumented' bindWith:nMethodsInstrumented).
        Smalltalk addExitBlock:[ self dumpCoverageInformation ].
    ].

    "Created: / 24-05-2011 / 16:30:54 / cg"
    "Modified: / 24-05-2011 / 18:16:29 / cg"
! !

!StandaloneStartup class methodsFor:'defaults'!

allowCoverageMeasurementOption
    "enable/disable the --measureCoverage startup options.
     The default is false, so standAlone apps do not support coverage measurements by default.
     Can be redefined in subclasses to enable it 
     (but will need the libcomp and possibly the programming/oom packages to be present)"

    ^ Smalltalk isStandAloneApp not

    "Created: / 24-05-2011 / 16:16:15 / cg"
    "Modified: / 25-05-2011 / 00:21:18 / cg"
!

allowDebugOption
    "enable/disable the --debug startup option.
     Can be redefined in subclasses to enable it"

    ^ false
!

allowScriptingOption
    "enable/disable the --scripting startup option.
     Can be redefined in subclasses to enable it"

    ^ false
!

suppressRCFileReading
    "enable/disable the rc-file reading (and also the --rcFileName option).
     If suppressed, there is no chance to interfere with the startup.
     Can be redefined in subclasses to disable it"

    ^ false
! !

!StandaloneStartup class methodsFor:'helpers'!

printInfo:msg
    "print an informal message using the logger"
    
    ('%1 [info]: ' bindWith:(self applicationName)) infoPrint.
    msg asString infoPrintCR.
!

redirectStandardStreams
    "redirect all output for Transcript to stderr"
    
    Transcript := Stderr.
!

verbose
    "true iff the program was started with --verbose flag"
    
    ^ Verbose == true

    "Created: / 01-02-2011 / 15:52:47 / cg"
!

verboseInfo:msg
    "output some message, but only if the program was started with --verbose"
    
    Verbose == true ifTrue:[
        self printInfo:msg
    ]

    "Modified: / 19-09-2006 / 16:30:27 / cg"
! !


!StandaloneStartup class methodsFor:'multiple applications support'!

applicationRegistryPath
    "the key under which this application stores its process ID in the registry
     as a collection of path-components.
     i.e. if #('foo' 'bar' 'baz') is returned here, the current applications ID will be stored
     in HKEY_CURRENT_USER\Software\foo\bar\baz\CurrentID.
     (would also be used as a relative path for a temporary lock file under unix).
     Used to detect if another instance of this application is already running."

    self subclassResponsibility
!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used.
     If redefined, please return a real UUID (i.e. UUID fromString:'.....') and not a string or 
     similar possibly conflicting identifier.
     You can paste a fresh worldwide unique id via the editor's more-misc-paste UUID menuFunction."
    
    self subclassResponsibility

    "Modified (comment): / 19-08-2011 / 01:54:39 / cg"
!

shouldReuseRunningApplication
    "answer true, if an already running application instance should be re-used"

    ^ false
! !

!StandaloneStartup class methodsFor:'multiple applications support-helpers'!

applicationRegistryEntry
    "retrieve the registry entry in which (if present), any currently running application
     has left its process ID"

    |path relPathName applicationEntry softwareEntry|

    OperatingSystem isMSWINDOWSlike ifFalse:[^ nil].

    path := self applicationRegistryPath.
    relPathName := path asStringWith:$\.
    applicationEntry := Win32OperatingSystem registryEntry key:'HKEY_CURRENT_USER\Software\',relPathName.
    applicationEntry isNil ifTrue:[
        softwareEntry := Win32OperatingSystem registryEntry key:'HKEY_CURRENT_USER\Software'.
        softwareEntry isNil ifTrue:[
            Transcript showCR: 'Failed to get Software entry in registry'.
            ^ nil.
        ].

        path do:[:subKey |
            |subEntry|

            subEntry := softwareEntry createSubKeyNamed:subKey.
            subEntry isNil ifTrue:[
                Transcript showCR: 'Failed to create ',subKey,' entry in registry'.
                ^ nil.
            ].
            softwareEntry := subEntry.
        ].
        applicationEntry := softwareEntry.
    ].
    ^ applicationEntry
!

checkForAndExitIfAnotherApplicationInstanceIsRunning
    "if another instance of this application is running,
     send it an openFile command for my file-argument, and exit.
     (i.e. the already running app gets a (processOpenPathCommand:argument) message
      to ask it to open up another window)."

    |shouldExit|

    self verboseInfo:('check for another app').
    self isAnotherApplicationInstanceRunning ifTrue:[
       self verboseInfo:('other app is running').
        shouldExit := self processStartupOfASecondInstance.
        shouldExit ifTrue:[
            self verboseInfo:('yes; go away').
            self releaseApplicationMutex.
            Smalltalk isStandAloneApp ifTrue:[
                Smalltalk exit.
            ]
        ].
    ].

    "Modified: / 04-02-2011 / 00:04:31 / cg"
!

confirmOpenNewApplicationInstance

    ^ Dialog confirm: ('Continue opening a new instance of %1 or exit?' bindWith:self applicationName)
                title: ('%1 is already open!!' bindWith:self applicationName)
             yesLabel: 'Continue' 
              noLabel: 'Exit'
!

currentIDKeyInRegistry
    ^ 'CurrentID'
!

getCurrentIDFromRegistry

    |applicationEntry|

    applicationEntry := self applicationRegistryEntry.
    applicationEntry isNil ifTrue:[^ nil.].
    ^ applicationEntry valueNamed: self currentIDKeyInRegistry

    "
     |hWnd externalAddress|
     hWnd := DapasXStartup getCurrentIDFromRegistry.   
     hWnd isEmptyOrNil ifTrue:[^ self halt.].
     hWnd := hWnd asInteger.
     externalAddress := ExternalAddress newAddress: hWnd.
     Display raiseWindow:externalAddress.
     Display setForegroundWindow:externalAddress
    "
!

getIDOfRunningApplicationFromRegistryEntry
    |applicationEntry|

    applicationEntry := self applicationRegistryEntry.
    applicationEntry isNil ifTrue:[^ nil.].
    ^ applicationEntry valueNamed: self currentIDKeyInRegistry
!

isAnotherApplicationInstanceRunning
    "answer true, if another instance of myself is currently running.
     For now, it only works under win32, because it uses the underlying mutex mechanism."
    
    | lastErrorCode alreadyExists handleAndLastErrorCode |

    OperatingSystem isMSDOSlike ifTrue:[
        self verboseInfo:('create mutex...').
        handleAndLastErrorCode := OperatingSystem createMutexNamed:(self applicationUUID printString).
        MutexHandle := handleAndLastErrorCode first.
        lastErrorCode := handleAndLastErrorCode second.
        "/ self assert: lastErrorCode == 0.
        alreadyExists := 
            MutexHandle isNil 
            or:[lastErrorCode == 183 "ERROR_ALREADY_EXISTS"
            or:[lastErrorCode == 5 "ERROR_ACCESS_DENIED"]].

        self verboseInfo:('alreadyExists = ',alreadyExists printString).
        alreadyExists ifTrue:[
            "we do not own the Mutex, so we cannot release it"
            MutexHandle notNil ifTrue:[
                OperatingSystem primCloseHandle: MutexHandle.
                MutexHandle := nil.
            ].
        ] ifFalse:[
            "no need to wait, createMutex sets initialOwner = true"    
"/            OperatingSystem waitForSingleObject: MutexHandle.
        ].
        ^ alreadyExists.
    ].

    ^ false.

    "Modified: / 04-02-2011 / 00:05:51 / cg"
!

processStartupOfASecondInstance
    "This is executed when I have been started as a second instance of an already running application.
     If I can get the currentID (i.e. windowID) of the first one and there is a command line argument with a file, 
     send a message (processOpenPathCommand:argument) to the main window of the already running application, to ask it for another window.
     If the currentID is unknown, ask if the user wants to open a new instance of the application anyway.
     Return true if the first instance has been notified, and this second instance should exit."

    |currentIDStringFromRegistry currentIDFromRegistry fileArg commands aWindowId setForegroundWindowSucceeded|

    commands := CommandLineArguments.

    currentIDStringFromRegistry := self getCurrentIDFromRegistry.

    "If the currentID is not found and there are arguments from the command line, 
     we should wait in case of starting the first instance of the application 
     with a multiple selection of files."
    (currentIDStringFromRegistry isEmptyOrNil and:[commands notEmptyOrNil]) ifTrue:[
        Delay waitForSeconds: 2.
    ].

    currentIDStringFromRegistry := self getCurrentIDFromRegistry.
    currentIDStringFromRegistry isEmptyOrNil ifTrue:[
        ^ self confirmOpenNewApplicationInstance not.
    ].

    currentIDFromRegistry := Integer readFrom:currentIDStringFromRegistry onError: 0.

    "/ bring the other application to the foreground
    aWindowId := ExternalAddress newAddress: currentIDFromRegistry.
    setForegroundWindowSucceeded := Display primSetForegroundWindow: aWindowId.
"/    setForegroundWindowSucceeded ifFalse:[^ self confirmOpenNewApplicationInstance not].

    "Autostart for associated extension"
    commands notEmpty ifTrue:[
        fileArg := commands last asFilename.
        fileArg exists ifTrue:[
            self sendOpenPathCommand:(fileArg pathName) toWindowId: aWindowId.
        ].
    ].
    ^ true

    "Modified: / 08-07-2010 / 00:47:44 / cg"
!

releaseApplicationMutex
    (MutexHandle notNil and:[OperatingSystem isMSDOSlike]) ifTrue:[
        OperatingSystem releaseMutex: MutexHandle.
        OperatingSystem primCloseHandle: MutexHandle.

        MutexHandle := nil.
    ].
!

sendCommand:message toWindowId:aWindowId
    "use the event send mechanism to forward a command to the already running application"

    Display 
        sendCopyData: message 
        toWindowId: aWindowId.
!

sendOpenPathCommand:pathName toWindowId:aWindowId
    "use the event send mechanism to forward an open-Path command to the already running application"

    self sendCommand:('openPath:', pathName) toWindowId:aWindowId.
!

writeCurrentIDIntoRegistry: currentID

    |applicationEntry currentIDEntry|

    applicationEntry := self applicationRegistryEntry.
    applicationEntry isNil ifTrue:[^ false.].

    currentIDEntry := applicationEntry createSubKeyNamed:(self currentIDKeyInRegistry).
    currentIDEntry isNil ifTrue:[
        Transcript showCR: 'Failed to create CurrentID entry in registry'.
        ^ false.
    ].

    ^ applicationEntry valueNamed:(self currentIDKeyInRegistry) put:(currentID printString).

    "
     | currentID returnedCurrentID |
     currentID := 999.
     DapasXStartup writeCurrentIDIntoRegistry: currentID.
     returnedCurrentID := DapasXStartup getCurrentIDFromRegistry.
     self assert: currentID = returnedCurrentID asNumber.
    "
! !

!StandaloneStartup class methodsFor:'queries'!

applicationName
    "used in verbose messages - can/should be redefined in subclasses"

    |nm|

    nm := self nameWithoutPrefix.
    (nm endsWith:'Startup') ifTrue:[
        ^ nm copyButLast:('Startup' size).
    ].
    (nm endsWith:'Start') ifTrue:[
        ^ nm copyButLast:('Start' size).
    ].
    ^ nm

    "Created: / 19-09-2006 / 16:26:44 / cg"
!

commandLineArguments
    ^ CommandLineArguments
!

isAbstract
    ^ self == StandaloneStartup
!

isBrowserStartable
    "do not allow clicking on me in the browser"

    ^ false

    "Created: / 06-10-2006 / 11:33:13 / cg"
!

keepSplashWindowOpen
    "if true is returned here, the splashWindow is not closed and will be still open
     when the main: method is invoked. This allows for plugin-loads etc. to be shown in the
     splash screen. However, my subclass's main: has to make sure that the splashScreen is closed.
     (calling hideSplashWindow)
     The default is false here which means that the splashWindow will be already closed when the
     subclasses main: is invoked."

    ^ false
!

patchesDirectory
    "answer a directory containing patches.
     The directory needs not to be present."

    ^ OperatingSystem pathOfSTXExecutable asFilename directory construct:'patches'.
!

startupFilename
    "used in verbose messages - can/should be redefined in subclasses"

    ^ self applicationName asLowercase,'Start.rc'

    "
     ExpeccoStartup startupFilename -> 'expecco.rc'
    "

    "Created: / 19-09-2006 / 16:38:28 / cg"
! !

!StandaloneStartup class methodsFor:'startup'!

handleRCFileOptionsFromArguments:argv
    "handle rc-file command line arguments:
        --rcFileName ......... define a startup rc-file
    "

    |idx nextArg rcFilename|

    idx := argv indexOf:'--rcFileName'.
    idx ~~ 0 ifTrue:[
        nextArg := argv at:(idx + 1) ifAbsent:nil.
        (nextArg notNil and:[ (nextArg startsWith:'-') not ]) ifTrue:[
            rcFilename := nextArg.
            argv removeAtIndex:idx+1; removeAtIndex:idx.
        ]
    ].

    rcFilename isNil ifTrue:[
        rcFilename := self startupFilename.
    ].
    rcFilename asFilename exists ifTrue:[
        self verboseInfo:('reading ',rcFilename,'...').
        rcFilename isAbsolute ifFalse:[
            rcFilename := OperatingSystem pathOfSTXExecutable asFilename directory constructString:rcFilename.
        ].
        Smalltalk secureFileIn:rcFilename
    ].

    "Created: / 24-05-2011 / 16:13:34 / cg"
!

handleScriptingOptionsFromArguments:argv
    "handle scripting command line argument:
        --scripting portNr ... start a scripting server on port (or default, if missing)
        --allowHost host ..... add host to the allowed scripting hosts
    "

    |scripting idx nextArg portNr allowedScriptingHosts|

    self verboseInfo:('handle scripting: ',argv asArray printString).

    scripting := false.

    idx := argv indexOfAny:#('--scripting').
    idx ~~ 0 ifTrue:[
        nextArg := argv at:(idx + 1) ifAbsent:nil.
        (nextArg notNil and:[ (nextArg startsWith:'-') not ]) ifTrue:[
            portNr := nextArg asInteger.
            argv removeAtIndex:idx+1.
        ].
        argv removeAtIndex:idx.

        scripting := true
    ].

    allowedScriptingHosts := OrderedCollection new.

    idx := argv indexOfAny:#('--allowHost').
    [idx ~~ 0] whileTrue:[
        nextArg := argv at:(idx + 1) ifAbsent:nil.
        nextArg isNil ifTrue:[
            self usage.
            AbortOperationRequest raise.
        ].
        allowedScriptingHosts add:nextArg.
        idx := argv indexOfAny:#('--allowHost').
    ].

    scripting ifTrue:[
        self verboseInfo:('scripting on').
        STXScriptingServer isNil ifTrue:[
            [
                Smalltalk loadPackage:'stx:goodies/simpleServices'.
            ] on:PackageLoadError do:[:ex|
                self verboseInfo:('missing STXScriptingServer package (stx:goodies/simpleServices)').
                ^ self.
            ]
        ].
        STXScriptingServer notNil ifTrue:[
            allowedScriptingHosts do:[:eachHost | STXScriptingServer allowHost:eachHost ].

            "/ scripting on port/stdin_out/8008
            self verboseInfo:('start scripting').
            STXScriptingServer server:(STXScriptingServer startAt:portNr)
        ] ifFalse:[
            self verboseInfo:('missing STXScriptingServer class').
        ].
    ].

    "Created: / 24-05-2011 / 16:12:02 / cg"
    "Modified: / 24-05-2011 / 17:40:26 / cg"
!

loadPatch:fileName
    self verboseInfo:('loading patch: ',fileName baseName).
    [
        Smalltalk silentFileIn:fileName.
    ] on:InvalidPatchError do:[:ex|
        self verboseInfo:('invalid patch: %1 error: %2'
                                 bindWith:fileName baseName with:ex messageText).
        ^ false.
    ].
    ^ true
!

loadPatches
    "load all patches in the application's patches dir"

    self possiblyCheckForNewPatchesOnServer.
    self loadPatchesMatching:nil.
!

loadPatchesMatching:aGlobString
    "load the patches in the application's patches dir.
     If aGlobString ist not empty or nil, only patches matching the glob
     pattern are loaded. E.g. '[0-9]*.chg'"

    |patchesDir prevMode patchesToLoad|

    patchesDir := self patchesDirectory asFilename.
    patchesDir isDirectory ifTrue:[
        prevMode := ClassCategoryReader sourceMode.
        ClassCategoryReader sourceMode:#discard.
        [
            patchesToLoad := patchesDir directoryContentsAsFilenames.
            patchesToLoad := patchesToLoad select:[:eachFilenameString|
                    eachFilenameString asFilename isRegularFile 
                ].
            aGlobString notEmptyOrNil ifTrue:[
                patchesToLoad := patchesToLoad select:[:eachFilename|
                        aGlobString match:eachFilename baseName caseSensitive:false
                    ].
            ].
            (patchesToLoad sort:[:a :b | a baseName < b baseName]) do:[:patchFile |
                self loadPatch:patchFile.
            ].
        ] ensure:[
            ClassCategoryReader sourceMode:prevMode.
        ].
    ].

    "Modified: / 19-09-2006 / 16:30:58 / cg"
    "Modified: / 25-11-2013 / 12:27:33 / sr"
!

loadRemainingClassLibraries
    "To speedup startup, we did not load all dll's (only a subset of non-GUI dll's is present).
     Now, load all skipped libs (the ones marked with '*') from modules.stx."

    |modulesFile dllDirectory dlls|

    OperatingSystem isMSWINDOWSlike ifFalse:[^ self ].

    self verboseInfo:'loadRemainingClassLibraries'.
    modulesFile  := self stxModulesFilename.
    dllDirectory := modulesFile directory.

    dlls := OrderedCollection new.

    modulesFile readingLinesDo:[:eachModulesLine|
        |basename dllFile|

        basename := eachModulesLine withoutSeparators.

        (basename notEmpty and:[basename first == $*]) ifTrue:[
            basename := (basename copyFrom:2) withoutSeparators, '.dll'.
            dllFile := dllDirectory construct:basename.

            dllFile exists ifTrue:[
"/                self verboseInfo:('loading: ', basename).
"/                Smalltalk showSplashMessage:('loading ', basename).
                dlls add:dllFile.
            ] ifFalse:[
                self verboseInfo:( '**** cannot resolve: ', basename).
            ].
        ].
    ].

    dlls notEmpty ifTrue:[
        ObjectFileLoader loadObjectFiles:dlls.
        ProjectDefinition initializeAllProjectDefinitions.

        Display notNil ifTrue:[
            "New view classes may have been loaded - have to update their styles"
            self verboseInfo:'update style caches of loaded dlls'.
            SimpleView readStyleSheetAndUpdateAllStyleCaches.
        ].
    ].

    "Modified: / 11-08-2011 / 17:23:55 / cg"
!

possiblyCheckForNewPatchesOnServer
    "to be redefined in concrete applications: check fo patches on a server"

    "/ intentionally left blank
!

removeDebugger
    Smalltalk at:#Debugger put:nil.
!

removeInspector
    Smalltalk at:#Inspector put:nil.
!

removeLauncher
    NewLauncher notNil ifTrue:[
        NewLauncher allPrivateClasses do:[:cls |
            Smalltalk at:(cls name) put:nil.
        ].
        Smalltalk at:#NewLauncher put:nil.
    ].
!

setupSmalltalkFromArguments:argv
    "handle common command line arguments:
        --help ............... print usage and exit
        --verbose (-V) ....... be verbose during startup
        --debug .............. enable debugger & inspector
        --rcFileName ......... define a startup rc-file
        --scripting portNr ... start a scripting server
        --allowHost host ..... add host to the allowed scripting hosts
    "

    |idx debugging baseDir|

"/    Smalltalk beHeadless:true.
"/    OperatingSystem disableSignal:(OperatingSystem sigHUP).
"/    Smalltalk infoPrinting:true.

    (argv includes:'--help') ifTrue:[
        self usage.
        AbortOperationRequest raise.
    ].

    idx := argv indexOfAny:#('--verbose' '-V').
    idx ~~ 0 ifTrue:[
        argv removeAtIndex:idx.
        Verbose := true.
        Logger notNil ifTrue:[
            Logger loggingThreshold: Logger severityALL.
        ].    
    ].
    self verboseInfo:('args: ',argv asArray printString).

    debugging := false.
    (self allowDebugOption) ifTrue:[
        idx := argv indexOf:'--debug'.
        idx ~~ 0 ifTrue:[
            self verboseInfo:('debug on').
            argv removeAtIndex:idx.
            debugging := true
        ].
    ].
    debugging ifTrue:[
        self setupToolsForDebug.
    ] ifFalse:[
        self setupToolsForNoDebug.
    ].
    baseDir := OperatingSystem pathOfSTXExecutable asFilename directory.
    baseDir baseName = 'application' ifTrue:[
        ".../work/exept/expecco/application/expecco -> .../work/"
        baseDir := baseDir directory directory directory.
        Smalltalk packagePath 
                    add:(baseDir pathName).
    ] ifFalse:[
        "/opt/expecco/bin/expecco -> /opt/expecco/"
        baseDir := baseDir directory.
        Smalltalk packagePath 
                    add:(baseDir constructString:'packages').
    ].

    (self suppressRCFileReading) ifFalse:[
        self handleRCFileOptionsFromArguments:argv.
    ].
    (self allowScriptingOption) ifTrue:[
        self handleScriptingOptionsFromArguments:argv.
    ].
    (self allowCoverageMeasurementOption) ifTrue:[
        self handleCoverageMeasurementOptionsFromArguments:argv.
    ].

    ^ true

    "Modified: / 24-05-2011 / 16:14:45 / cg"
!

setupToolsForDebug
    Debugger := DebugView ? MiniDebugger.
    Inspector := InspectorView ? MiniInspector.
    Verbose ifTrue:[ 'debug enabled - CTRL-C brings you into a debugger.' errorPrintCR ].
"/    self verboseInfo:('debug enabled - CTRL-C brings you into a debugger.').

    "Created: / 19-09-2006 / 16:40:32 / cg"
!

setupToolsForNoDebug
    Smalltalk isStandAloneApp ifTrue:[
        self removeDebugger.
        self removeInspector.

        Verbose ifTrue:[ 'debug disabled.' errorPrintCR ].
        self redirectStandardStreams.
    ].

    "Created: / 19-09-2006 / 16:40:47 / cg"
    "Modified: / 31-10-2007 / 16:18:40 / cg"
!

start
    "this is the default initial entry into a standalone program.
     It checks for any remaining shared libraries/packages which need to be
     loaded, looks for any patch-files to be applied
     and then enters into main.
     On systems, which allow for the same app to be started for multiple documents
     (i.e. windows), when clicking on a document), 
     first check if there is an already running application and tell it to open
     a window for the new document."
     
    GenericException handle:[:ex |
        self verboseInfo:'Error during startup:'.
        self verboseInfo:ex description.
        Verbose == true ifTrue:[ex suspendedContext fullPrintAllLevels:10].
        ex reject.        
    ] do:[
        |idx|

        Smalltalk showSplashMessage:'start'.
        self verboseInfo:'starting...'.
        CommandLineArguments := (self additionalArgumentsFromRegistry) 
                                , Smalltalk commandLineArguments.

        self verboseInfo:('args: ', CommandLineArguments asStringCollection asString).

        "--newAppInstance - do not reuse an existing application instance,
         but run in a separate process"
        idx := CommandLineArguments indexOfAny:#('--newAppInstance').
        idx == 0 ifTrue:[
            self shouldReuseRunningApplication ifTrue:[
                self verboseInfo:'should reuse app'.
                "Multiple Application support:
                 if another expecco is running, ask it to open another window for me.
                 If that is the case, the following function will not return, but instead exit."
                self checkForAndExitIfAnotherApplicationInstanceIsRunning.
            ].
        ] ifFalse:[
            CommandLineArguments removeAtIndex:idx.
        ].

        "/ Arrive here, if no other application is running.
        "/ to speedup startup, we did not load all dll's (only a subset of non-GUI dll's is present).
        "/ now, load all skipped libs from modules.stx.
        self loadRemainingClassLibraries.

        Smalltalk isStandAloneApp ifTrue:[
            self verboseInfo:'looking for patches'.
            self loadPatches.
        ].
        self verboseInfo:'setup Smalltalk'.
        self setupSmalltalkFromArguments:CommandLineArguments.
        self main:CommandLineArguments
    ].

    "Modified: / 04-02-2011 / 00:03:47 / cg"
!

startStartBlockProcess
    Smalltalk startStartBlockProcess
!

stxModulesFilename
    "answer the Filename of modules.stx"

    |file|

    file := 'modules.stx' asFilename.
    file exists ifTrue:[^ file].

    file := OperatingSystem pathOfSTXExecutable asFilename directory construct:'modules.stx'.
    file exists ifTrue:[^ file].

    self error:'cannot find: modules.stx'.
!

usage
    Stderr nextPutLine:'usage: ',self applicationName,' [options...]'.
    Stderr nextPutLine:'  --help .................. output this message'.
    Stderr nextPutLine:'  --verbose ............... verbose startup'.
    self isHeadless ifFalse:[
        Stderr nextPutLine:'  --noBanner .............. no splash screen'.
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[
        Stderr nextPutLine:'  --newAppInstance ........ start as its own application process (do not reuse a running instance)'.
    ].
    self allowScriptingOption ifTrue:[
        Stderr nextPutLine:'  --scripting <portNr> .... enable scripting via port (or stdin/stdOut, if 0. Default is 8008)'.
    ].
    self allowDebugOption ifTrue:[
        Stderr nextPutLine:'  --debug ................. enable Debugger'.
    ].
    self allowCoverageMeasurementOption ifTrue:[
        Stderr nextPutLine:'  --coverage .............. turn on coverage measurement'.
        Stderr nextPutLine:'     [+/-]package: pattern ...  - include/exclude packages'.
        Stderr nextPutLine:'     [+/-]class: pattern ...    - include/exclude classes'.
        Stderr nextPutLine:'     [+/-]method: cls#sel ...   - include/exclude methods'.
    ].
    self suppressRCFileReading ifFalse:[
        Stderr nextPutLine:'  --rcFileName file ....... execute code from file on startup (default: ',self startupFilename,')'.
    ].

    "Created: / 19-09-2006 / 16:37:55 / cg"
    "Modified: / 24-05-2011 / 17:23:18 / cg"
!

usageAndExitWith:exitCode
    "show the usage message, then exit with given exitCode"
    
    self usage.
    Smalltalk exitIfStandalone:exitCode
! !

!StandaloneStartup class methodsFor:'startup-to be redefined'!

additionalArgumentsFromRegistry
    "can be redefined to fetch and return additional arguments from the registry 
     (or other .ini file). These are added to the beginning of the command line arguments."

    ^ #()

    "Created: / 04-08-2010 / 12:20:27 / cg"
!

isHeadless
    "this is invoked early by Smalltalk>>mainStartup, to ask if I like to
     have a Display or if I am a non-GUI headless application.

     Redefine in subclass, if your application is a non-GUI application"

    ^ false
!

main
    self verboseInfo:('entering main').

    self main:CommandLineArguments.

    "
     self main
     self main:#('--info') 
    "

    "Modified: / 31-10-2007 / 16:03:22 / cg"
!

main:argv
    self subclassResponsibility.

"/ a typical main: looks like (in a subclass):

"/    |app fileArg|
"/
"/    self verboseInfo:('starting application').
"/
"/    self startStartBlockProcess.
"/    Smalltalk openDisplay.
"/    app := <someGUIApplicationModelClass> open.
"/
"/    self verboseInfo:('looking for args in ',argv).
"/    argv notEmptyOrNil ifTrue:[
"/        fileArg := argv last asFilename.
"/        self verboseInfo:('fileArg is ',fileArg name).
"/        fileArg exists ifTrue:[
"/            self verboseInfo:('file exists').
"/
"/            ( #('foo' 'bar' 'baz' ) includes:fileArg suffix) ifTrue:[
"/                self verboseInfo:('loading').
"/
"/                Error handle:[:ex |
"/                    self verboseInfo:'error while loading'.
"/                    ex suspendedContext fullPrintAll.
"/                ] do:[
"/                    app menuLoadFromFile:fileArg
"/                ].
"/            ].
"/        ].
"/    ].

    "Created: / 19-09-2006 / 16:48:29 / cg"
! !

!StandaloneStartup class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


StandaloneStartup initialize!
