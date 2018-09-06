"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2011 Jan Vrany
 COPYRIGHT (c) 2015-2018 Jan Vrany
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

Object subclass:#Smalltalk
	instanceVariableNames:''
	classVariableNames:'StartBlocks ImageStartBlocks ExitBlocks CachedClasses
		NumberOfClassesHint SystemPath StartupClass StartupSelector
		StartupArguments CommandLine CommandName CommandLineArguments
		CachedAbbreviations VerboseStartup VerboseLoading Verbose
		SilentLoading Initializing StandAlone HeadlessOperation IsPlugin
		IsSharedLibraryComponent IsSTScript IsRepl DebuggingStandAlone
		Silent Debugging LogDoits LoadBinaries RealSystemPath
		ResourcePath SourcePath BinaryPath FileInPath PackagePath
		BinaryDirName ResourceDirName SourceDirName BitmapDirName
		PackageDirName FileInDirName ChangeFileName ImageStartTime
		ImageRestartTime DemoMode SaveEmergencyImage SpecialObjectArray
		CallbackSignal ClassesFailedToInitialize HasNoConsole IgnoreHalt
		PackageToPathMapping IgnoreAssertions LanguageModifier
		LanguageCodeset'
	poolDictionaries:''
	category:'System-Support'
!

Smalltalk comment:''
!

!Smalltalk class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2011 Jan Vrany
 COPYRIGHT (c) 2015-2018 Jan Vrany
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
    This is one of the central classes in the system;
    it provides all system-startup, shutdown and maintenance support.
    Also global variables are (conceptionally) kept here.

    As you will notice, this is NOT a Dictionary
    - my implementation of globals is totally different
      due to the need to be able to access globals from c-code as well,
      I do not use associations for globals, but instead keep the
      name<->value relations in the VM and access globals via utility
      functions found there.

    However, it provides the known enumeration protocol.
    It may change to become a subclass of collection at some time,
    to inherit more collection stuff ...


    [Instance variables:]
					none - all handling is done in the VM

    [Class variables:]

	StartBlocks     <Collection>    blocks to be executed in a separate process after
					everything has been initialized. These blocks will
					be deleted after execution and therefore not be
					executed after an image restart. Initial processes
					(such as the Launcher) are usually started here.
					These blocks are added by smalltalk.rc/private.rc etc.
					via #addStartBlock during early initialization.

	ImageStartBlocks
			<Collection>    blocks to be executed in a separate process after
					everything has been initialized. These blocks will be
					executed after an image restart.
					These blocks are usually added by smalltalk_r.rc etc.

	ExitBlocks      <Collection>    blocks to evaluate before system is
					left. Not currently used (GNU-ST compatibility).

	SystemPath      <Collection>    path to search for system files (sources, bitmaps etc)
					Set to a default here, but typically changed from some
					startup.rc file

	PackagePath     <Collection>    path to search for package.
					This is going to replace the above systemPath, and a classes
					resources will eventually searched in its package directory.
					This list defines the path, where packages are searched for,
					initially this is something like /opt/smalltalk/packages.
					Set to a default here, but typically changed from some
					startup.rc file

	StartupClass    <Class>         class and selector, where the system starts up
	StartupSelector <Symbol>        (right after VM initialization)
	StartupArguments <Array>        If an image is saved while those being nonNil,
					the image will come up there.
					Allows for customized images to be generated from a standard ST/X.
					StandAlone programs also set those during initialization.

	CommandLine          <String>   Unix (OS-) command line

	CommandName          <String>   the command (i.e. argv[0])

	CommandLineArguments <Array>    Unix (OS-) command line arguments broken into words
					CommandName has been stripped off.
					(initially set by the VM)

	SilentLoading   <Boolean>       OBSOLETE:
					suppresses messages during fileIn and in compiler
					(can be set to true from a customized main.c)

	VerboseLoading   <Boolean>      generate messages during fileIn and in compiler
					(can be set to true from a customized main.c)

	Initializing    <Boolean>       true while (re-)initializing
					Controls the behavior of certain error
					reporters (for example: suppress dialogBoxes)
					while the system is not yet fit for full operation.

	StandAlone      <Boolean>       true, if this is a standalone app;
					if true the process scheduler watches for
					which processes are still running, and
					exits ST/X, when the last non-background
					and non-system process exits.
					Can be set in an application-specific startup script,
					or, for standAlone programs, by C-code during initialization.

	HeadlessOperation               if true, a non-existing Display connection
			<Boolean>       will NOT lead to an error-exit during startup.
					Default is false.
					Can be set in an application-specific startup script,
					or, for standAlone programs, by C-code during initialization.

	LogDoits        <Boolean>       if true, doits are also logged in the changes
					file. Default is false, since the changes file
					may become huge if every tiny doIt is saved there ...

	LoadBinaries    <Boolean>       if true, we attempt to load classes rom a binary
					file, if present. If false, this is always suppressed.

	SaveEmergencyImage <Boolean>    if true (the default), an emergency image
					is saved, if the main Display looses its
					connection. This is useful if you have a
					flaky display connection (serial line)
					and want to have your stuff saved automatically
					in case of a broken connection.

	IgnoreAssertions  <Boolean>     if true, assertions are ignored (i.e. no errors reported).
					Usually false in the development system, true in a standalone deployed app.

    strictly private classVariables (helpers):

	CachedClasses   <Collection>    known classes (cached for faster class enumeration)

	CachedAbbreviations
			<Dictionary>    className to filename mappings

	RealSystemPath  <Collection>    cached collection of directories along the path
					which really exist. Caching avoids long checks
					for existing directories on broken NFS volumes.

	SourcePath      <Collection>    cached names of really existing directories
					These are remembered, as in NFS systems,
	ResourcePath                    the time to lookup files may become long
	BinaryPath                      (especially, if some directories are on machines
	FileInPath                      which are not up ...).
					Therefore, the set of really
					existing directories is cached when the SystemPath
					is walked the first time.
					A consequence is that you have to invoke
					flushSystemPath, when you create any of those
					directories while running
					(and want the running ST/X to look there)


    [author:]
	Claus Gittinger

    [see also:]
	ObjectMemory
	StandaloneStartup
	GetOpt
	ReadEvalPrintLoop
"
!

readme_resources
"
    What is a resource file:
	resource files contain language transformation and sometimes
	UI-look specifics such as icons etc.

    Where are resources stored in the image:
	Resource files are only read on demand (i.e. when needed) and only read once
	i.e. they are cached in the image).
	The cached data is held in a per-class class-instVar named 'ClassResources'.
	With only a few exceptions, the only classes which need resources are the GUI
	classes under the SimpleView hierarchy.

    How does the system find resources:
	The idea is that the system-provided resource files can be overwritten
	by the user or an application configuration.
	This works via a hierarchy of directories where resources are searched for,
	with the systems standard resource-files being at the end of that chain.

	When searching for a resource file for class X, the following files are searched
	in order:
		{ResourcePath} / resources / X.rs
		{SystemPath} / (CLASSES-PACKAGE-PATH) / X.rs
		{ResourcePath} / (CLASSES-PACKAGE-PATH) / X.rs
"
! !

!Smalltalk class methodsFor:'initialization'!

basicInitializeSystem
    "initialize all other classes.
     This one is the very first entry into the smalltalk world
     [with error handling, via the initializeSystem],
     right after startup, usually immediately followed by Smalltalk>>start.

     Notice:
        this is NOT called when an image is restarted; in this
        case the show starts in Smalltalk>>restart."

    OrderedCollection initialize.

    Smalltalk at:#Compiler put:ByteCodeCompiler.
    Compiler isNil ifTrue:[
        "
         ByteCodeCompiler is not in the system (i.e. has not been linked in)
         this allows at least immediate evaluations for runtime systems without compiler
         NOTICE: a parser is always needed, otherwise we cannot read resource files etc.
        "
        Smalltalk at:#Compiler put:Parser
    ].

    "/
    "/ start catching SIGSEGV and SIGBUS
    "/
    OperatingSystem enableHardSignalInterrupts.

    self initGlobalsFromEnvironment.

    "/
    "/ sorry - there are some, which MUST be initialized before ..
    "/ reason: if any error happens during init, we need Signals, Stdout etc. to be there
    "/
    SmallInteger initialize.
    Object initialize.
    UninterpretedBytes initialize.
    OperatingSystem initialize.
    Stream initialize.
    PositionableStream initialize.
    Filename initialize.
    ObjectMemory initialize.
    ExternalStream initialize.
    ProcessorScheduler initialize.

    self initStandardStreams.    "/ setup Stdin, Stdout etc.

    "/
    "/ sorry, path must be set before ...
    "/ reason: some classes need it during initialize (they might need resources, bitmaps etc)
    "/
    "/ but, on OSX we need the CharacterEncoder to be initialized
    CharacterEncoder initialize.
    self initSystemPath.
    self initPackagePath.

    "/
    "/ in case, someone needs the objectFileLoader early
    "/
    ObjectFileLoader notNil ifTrue:[
        ObjectFileLoader initialize.
    ].

    "/
    "/ now, finally, initialize all other classes
    "/
    self initializeModules.

    ImageStartTime := Timestamp now.

    self initInterrupts.
    self initUserPreferences.

    "/ just to make sure: if any prefs affect any resources,
    "/ flush them here, so they are reread in any case.
    "/ required for some apps, for example to show the menu correctly (see launcher's help menu)
    ApplicationModel notNil ifTrue:[
        ApplicationModel flushAllClassResources.
    ].

    "/
    "/ give classes a chance to perform 2nd-level initialization
    "/ now, we are certain, that all other classes have been initialized
    "/ (especially: streams and signals can now be used)
    "/
    ObjectMemory changed:#initialized.

    "Modified: / 08-01-1997 / 19:58:12 / stefan"
    "Modified: / 05-12-2006 / 21:48:58 / cg"
    "Modified: / 24-10-2012 / 18:45:15 / sr"
    "Modified: / 25-06-2016 / 16:35:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initGlobalsFromEnvironment
    "setup globals from the shell-environment"

    StandAlone isNil ifTrue:[
        StandAlone := false.
    ].
    HeadlessOperation isNil ifTrue:[
        HeadlessOperation := false.
    ].

    "
     Smalltalk initGlobalsFromEnvironment
    "

    "Modified: / 14-02-2012 / 15:25:08 / cg"
    "Modified: / 21-11-2017 / 21:29:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initInterrupts
    "initialize interrupts"

    OperatingSystem enableUserInterrupts.
    OperatingSystem enableHardSignalInterrupts.
    OperatingSystem enableCrashSignalInterrupts.

    ObjectMemory userInterruptHandler:self.
    ObjectMemory signalInterruptHandler:self.
    ObjectMemory recursionInterruptHandler:self.

    OperatingSystem isOSXlike ifTrue:[
	"/ OSX sends SIGABRT for NSExceptions
	OperatingSystem operatingSystemSignal:(OperatingSystem sigABRT) install:NSException.
	OperatingSystem enableAbortInterrupts.
    ].

    "
     Smalltalk initInterrupts
    "

    "Modified: 20.8.1997 / 09:35:49 / stefan"
!

initPackagePath
    "Initialize package path"

    PackagePath := OperatingSystem defaultPackagePath.
    self addWorkspaceDirectoryToPackagePath.

    "Created: / 25-06-2016 / 16:35:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initStandardStreams
    "initialize some well-known streams"

    Stdout := NonPositionableExternalStream forStdout.
    Stderr := NonPositionableExternalStream forStderr.
    Stdin := NonPositionableExternalStream forStdin.
    PrinterStream notNil ifTrue:[
	Printer := PrinterStream defaultPrinter.
    ].
    Transcript := Stderr

    "
     Smalltalk initStandardStreams
    "

    "Modified: / 25-10-2006 / 17:36:46 / cg"
!

initStandardTools
    "predefine some tools which we might need later
     - if the view-classes exist,
       they will redefine Inspector and Debugger for graphical interfaces"

    Display notNil ifTrue:[
	InspectorView notNil ifTrue:[
	    Inspector := InspectorView
	].
	DebugView notNil ifTrue:[
	    Debugger := DebugView
	].
	"/ Display initialize
    ].

    "/ make the changeFilePath an absolute one,
    "/ in case some stupid windows fileDialog changes the current directory...
    ObjectMemory
	nameForChanges:(Filename currentDirectory / ObjectMemory nameForChangesLocal)
			    asAbsoluteFilename pathName

    "
     Smalltalk initStandardTools
    "

    "Modified: / 09-02-2011 / 20:44:47 / cg"
!

initSystemPath
    "setup path where system files are searched for.
     the default path is set to:
            .
            <directory of exe>       (WIN32 only)
            $HOME                    (if defined)
            $HOME/.smalltalk         (if defined & existing)
            $SMALLTALK_LIBDIR        (if defined & existing)
            $STX_LIBDIR              (if defined & existing)
            $STX_TOPDIR              (if defined & existing)
            REGISTRY('HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\<CurrentVersion>\LibDir') (WIN32 only)
            REGISTRY('HKEY_LOCAL_MACHINE\Software\eXept\Smalltalk/X\LibDir')                  (WIN32 only)
            <standard places>

     standard places (unix):
            /opt/smalltalk/<release> (if existing)
            /opt/smalltalk           (if existing)
            /usr/local/lib/smalltalk (if existing)
            /usr/lib/smalltalk       (if existing)
            /lib/smalltalk           (if existing)

     win32:
            \programs\exept\smalltalk (if existing)
            \programs\smalltalk       (if existing)
            \smalltalk                (if existing)

     vms:
            $stx:lib                 (if existing)
            $stx:root                (if existing)

     of course, it is possible to add entries from the 'smalltalk.rc'
     startup file; add expressions such as:
            Smalltalk systemPath addFirst:'/foo/bar/baz'.
        or:
            Smalltalk systemPath addLast:'/fee/foe/foo'.

     However, smalltalk.rc itself must be found along the above path.
    "

    ChangeFileName := 'changes'.
    OperatingSystem isVMSlike ifTrue:[
        BitmapDirName := 'bitmaps.dir'.
        BinaryDirName := 'binary.dir'.
        SourceDirName := 'source.dir'.
        ResourceDirName := 'resources.dir'.
        FileInDirName := 'filein.dir'.
        PackageDirName := 'packages.dir'.
    ] ifFalse:[
        BitmapDirName := 'bitmaps'.
        BinaryDirName := 'binary'.
        SourceDirName := 'source'.
        ResourceDirName := 'resources'.
        FileInDirName := 'fileIn'.
        PackageDirName := 'packages'.
    ].

    SystemPath isEmptyOrNil ifTrue:[
        SystemPath := OperatingSystem defaultSystemPath.
        self flushPathCaches
    ].

    PackagePath isEmptyOrNil ifTrue:[
        PackagePath := OperatingSystem defaultPackagePath.
    ].
    self addWorkspaceDirectoryToPackagePath.
    self addIdeTopDirectoryToPackagePath.

    "
     Smalltalk initSystemPath
     Smalltalk systemPath

     SystemPath := nil.
     PackagePath := nil.
     OperatingSystem defaultSystemPath
     OperatingSystem defaultPackagePath
    "

    "Modified: / 24.12.1999 / 00:23:35 / cg"
!

initUserPreferences
    "setup other stuff"

    LogDoits := false.
    LoadBinaries := false.
    SaveEmergencyImage := (StandAlone ~~ true).

    "Modified: / 24.10.1997 / 18:22:47 / cg"
!

initializeClass:aClass
    "sent from VM via #initializeModules"

    Error handle:[:ex |
        ObjectMemory printStackBacktrace.
        ClassesFailedToInitialize isNil ifTrue:[
            ClassesFailedToInitialize := IdentitySet new.
        ].
        ClassesFailedToInitialize add:aClass.
        ('Smalltalk [warning]: error during initialize of ' , aClass name,': ', ex description printString) errorPrintCR.
        ex suspendedContext fullPrintAll.
        '------------------------------------------------' errorPrintCR.
        (Debugging == true) ifTrue:[
            ex reject
        ].
    ] do:[
        aClass initialize
    ].

    "Modified: / 11-09-2011 / 17:01:32 / cg"
!

initializeModules
    "perform module specific initialization and
     send #initialize to all classes.
     Notice: this is NOT called when an image is restarted"

    self initializeModulesOnce.
    ClassesFailedToInitialize size > 0 ifTrue:[
	('Smalltalk [info]: retry initialization of failed class(es)...') infoPrintCR.
	ClassesFailedToInitialize := nil.
	self initializeModulesOnce.
	ClassesFailedToInitialize size > 0 ifTrue:[
	    ('Smalltalk [error]: class(es) persist to fail during initialize') errorPrintCR.
	]
    ].

    ProjectDefinition initializeAllProjectDefinitions.

    "Modified: / 23-10-2006 / 16:40:39 / cg"
!

initializeModulesOnce
    "perform module specific initialization and
     send #initialize to all classes.
     Notice: this is not called when an image is restarted"

%{
#ifdef __SCHTEAM__
    STClass.initializeAllClasses(__c__);
    return __c__._RETURN_self();
#else
    __init_registered_modules__(3);

    @global(DemoMode) = __getDemoMode() ? true : false;
    RETURN (self);
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed
!

initializeSystem
    "initialize all classes; setup dispatcher processes etc.
     This one is the very first entry into the smalltalk world,
     right after startup, usually immediately followed by Smalltalk>>start.
     Here, a few specific initializations are done, then the actual initialization is
     done inside an error handler in basicInitializeSystem.
     Notice:
        this is called by the VM's main entry. You will not find senders from Smalltalk.
     Also Notice:
        this is NOT called when an image is restarted;
        in this case the show starts in Smalltalk>>restart."

    |idx shellArgs|

    NumberOfClassesHint := 10000.

    Initializing := true.
    AbstractOperatingSystem initializeConcreteClass.

    CommandLineArguments isEmptyOrNil ifTrue:[
        CommandLineArguments := #('stx') asOrderedCollection.
    ].
    CommandLine := CommandLineArguments copy.
    CommandLineArguments := CommandLineArguments asOrderedCollection.
    CommandName := CommandLineArguments removeFirst. "/ the command

    SilentLoading := Silent := false.
    VerboseLoading := VerboseStartup := Verbose := false.
    DebuggingStandAlone := Debugging := false.

    "/ if no argument was given, look for an environment variable named
    "/ STX_DEFAULT_ARGS. If set, take that.
    "/ if any argument was given, unless a --noShellArgs argument is given,
    "/ slice in the value from "STX_MORE_ARGS" at the beginning.
    "/
    "/ These allow for args like "--quick --infoPrint" to be automatically prepended
    idx := CommandLineArguments indexOfAny:#('--noShellArgs' '--noshellargs').
    (idx ~~ 0) ifTrue:[
        CommandLineArguments removeIndex:idx.
    ] ifFalse:[
        CommandLineArguments isEmpty ifTrue:[
            shellArgs := OperatingSystem getEnvironment:'STX_DEFAULT_ARGS'.
            shellArgs notEmptyOrNil ifTrue:[
                shellArgs := shellArgs asCollectionOfWords.
                CommandLineArguments addAll:shellArgs.
            ].
        ] ifFalse:[
            "/ prepend shell environment args from "STX_ARGS"
            shellArgs := OperatingSystem getEnvironment:'STX_MORE_ARGS'.
            shellArgs notEmptyOrNil ifTrue:[
                shellArgs := shellArgs asCollectionOfWords.
                CommandLineArguments addAllFirst:shellArgs.
            ].
        ].
    ].

    self initializeVerboseFlags.

    Error handle:[:ex |
        StandAlone ifTrue:[
            DebuggingStandAlone ifFalse:[
                'Startup Error - use "--debug" command line argument for more info' errorPrintCR.
                Smalltalk exit:1.
            ].
            'Smalltalk [error]: Error during early initialization:' errorPrintCR.
            thisContext fullPrintAll.
        ].
        ex reject.
    ] do:[
        self basicInitializeSystem
    ].

    "Modified: / 12-10-2010 / 11:27:47 / cg"
!

initializeVerboseFlags
    |idx|

    StandAlone ifTrue:[
        InfoPrinting := false.
        ObjectMemory infoPrinting:false.
        IgnoreAssertions := true.
    ] ifFalse:[
        IgnoreAssertions := false.
    ].

    (idx := CommandLineArguments indexOf:'--ignoreHalt') ~~ 0 ifTrue:[
        IgnoreHalt := true.
        CommandLineArguments removeIndex:idx
    ].
    (idx := CommandLineArguments indexOf:'--noIgnoreHalt') ~~ 0 ifTrue:[
        IgnoreHalt := false.
        CommandLineArguments removeIndex:idx
    ].
    (idx := CommandLineArguments indexOf:'--ignoreAssert') ~~ 0 ifTrue:[
        IgnoreAssertions := true.
        CommandLineArguments removeIndex:idx
    ].
    (idx := CommandLineArguments indexOf:'--noIgnoreAssert') ~~ 0 ifTrue:[
        IgnoreAssertions := false.
        CommandLineArguments removeIndex:idx
    ].
    (idx := CommandLineArguments indexOf:'--silentStartup') ~~ 0 ifTrue:[
        SilentLoading := true.
        CommandLineArguments removeIndex:idx
    ].
    (idx := CommandLineArguments indexOf:'--verboseLoading') ~~ 0 ifTrue:[
        VerboseLoading := true.
        CommandLineArguments removeIndex:idx
    ].
    (idx := CommandLineArguments indexOf:'--verboseStartup') ~~ 0 ifTrue:[
        VerboseLoading := true.
        VerboseStartup := true.
        CommandLineArguments removeIndex:idx
    ].

    "/ reinterpret those, in case given after the VM options.
    (idx := CommandLineArguments indexOf:'--debugPrint') ~~ 0 ifTrue:[
        ObjectMemory debugPrinting:true.
        CommandLineArguments removeIndex:idx
    ].
    (idx := CommandLineArguments indexOf:'--infoPrint') ~~ 0 ifTrue:[
        ObjectMemory infoPrinting:true.
        CommandLineArguments removeIndex:idx
    ].

    (idx := CommandLineArguments indexOf:'--verbose') ~~ 0 ifTrue:[
        Object infoPrinting:true.
        Verbose := true.
        VerboseLoading := true.
        VerboseStartup := true.
        Logger notNil ifTrue:[
            Logger loggingThreshold: Logger severityALL.
        ].
        CommandLineArguments removeIndex:idx.
    ].

    Silent := false.
    (idx := CommandLineArguments indexOf:'--silent') ~~ 0 ifTrue:[
        CommandLineArguments removeIndex:idx.
        Silent := SilentLoading := true.
        Object infoPrinting:false.
        ObjectMemory infoPrinting:false.
        ObjectMemory debugPrinting:false.
        Verbose := VerboseLoading := VerboseStartup := false.
        Logger notNil ifTrue:[
            Logger loggingThreshold: Logger severityNONE
        ].
    ].

    idx := CommandLineArguments indexOf:'--debug'.
    Debugging := (idx ~~ 0).

    StandAlone ifTrue:[
        DebuggingStandAlone := Debugging.
        DebuggingStandAlone ifTrue:[
            Inspector := MiniInspector.
            Debugger := MiniDebugger.
            IgnoreAssertions := false.
        ].
    ] ifFalse:[
        "/
        "/ define low-level debugging tools - graphical classes are not prepared yet
        "/ to handle things.
        "/ This will bring us into the MiniDebugger when an error occurs during startup.
        "/
        Inspector := MiniInspector.
        Debugger := MiniDebugger.
    ].
!

isInitialized
    "this returns true, if the system is properly initialized;
     i.e. false during startup.
     Especially, the whole display/viewing stuff and process escheduling
     is not working correctly until initialized."

    Initializing isNil ifTrue:[^ false]. "/ if called very early
    ^ Initializing not
!

isInitializing
    "Return true if the system is currently initializing,;
     i.e. true during startup and image restart, false during
     normal work.

     Especially, the whole display/viewing stuff and process scheduling
     is not working correctly while initializing."

    Initializing isNil ifTrue:[^ true]. "/ if called very early
    ^ Initializing

    "Created: / 20-04-2016 / 08:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRestarting
    "Return true if the system is currently restarting from
     a snapshot, i.e., when performing Smalltalk-level actions
     after snapin (such as recreate windows, bitmaps and so on).
     Return false during normal work.

     Especially, the whole display/viewing stuff and process scheduling
     is not working correctly while restarting."

    ^ self isInitializing and:[ ImageRestartTime notNil ].

    "Created: / 20-04-2016 / 08:23:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitStandardStreams
    "reinitialize some well-known streams.
     Tis must be done very early during startup, to allow for
     debug and trace messages to be output
     (otherwise, the file-descriptors are invalid)"

    Stdout reOpen. Stderr reOpen. Stdin reOpen.
! !

!Smalltalk class methodsFor:'Compatibility-GNU'!

system:command
    "GNU-Smalltalk compatibility: execute an OS command"

    OperatingSystem executeCommand:command

    "
     Smalltalk system:'ls'
    "
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

beep
    "output an audible beep or bell"

    Screen current beep
!

garbageCollect
    "for Squeak compatibility"

    ObjectMemory garbageCollect
!

garbageCollectMost
    "collect recently created garbage; return the amount of freeSpace.
     In ST/X, only the newSpace is collected here, and the sum of
     newSpace + freeListSpace is returned."

    ObjectMemory scavenge.
    ^ ObjectMemory freeSpace + (ObjectMemory newSpaceSize - ObjectMemory newSpaceUsed)
!

isMorphic
    ^ false
!

platformName
    "not yet fully implemented (I have to figure out, what squeak returns in each case...)"

    ^ OperatingSystem platformName asUppercaseFirst

    "
     Smalltalk platformName -> 'Win32'
    "
!

registerExternalObject: anObject
    "Register the given object in the external objects array and return its index.
     If it is already there, just return its index.
     ExternalObjects are protected from GC and can be accessed easily from
     primitive code (via the global Smalltalk:SpecialObjectArray)"

    | objects firstEmptyIndex obj sz newObjects |

    objects := SpecialObjectArray.
    objects isNil ifTrue:[
	objects := Array new:5.
    ].

    "find the first empty slot and look if already registered"
    firstEmptyIndex := 0.
    1 to: objects size do: [:i |
	obj := objects at: i.
	obj == anObject ifTrue: [^ i].  "object already there, just return its index"
	(obj == nil and: [firstEmptyIndex = 0]) ifTrue: [
	    firstEmptyIndex := i
	]
    ].

    "if no empty slots, expand the array"
    firstEmptyIndex = 0 ifTrue: [
	sz := objects size.
	newObjects := objects species new: sz + 20.  "grow linearly"
	newObjects replaceFrom: 1 to: sz with: objects startingAt: 1.
	firstEmptyIndex := sz + 1.
	SpecialObjectArray := newObjects.
	objects := newObjects
    ].

    objects at: firstEmptyIndex put: anObject.
    ^ firstEmptyIndex

!

removeClassNamed: aName
    "Invoked from fileouts: if there is currently a class in the system named aName, then remove it.
     Also needed by the refactory browser.
     If anything untoward happens, report it in the Transcript."

    | oldClass |

    (oldClass := self at: aName asSymbol ifAbsent: [nil]) isNil ifTrue:[
	Transcript showCR: 'Removal of class named ', aName, ' ignored because it does not exist.'.
	^ self
    ].
    oldClass removeFromSystem
! !

!Smalltalk class methodsFor:'Compatibility-V''Age'!

allClassesImplementing:aSelector
    ^ self allClassesForWhich:[:cls | cls includesSelector:aSelector].

    "Modified: / 10-08-2006 / 12:12:17 / cg"
!

declareConstant:constantName poolName:poolNameArg value:value
    "visualAge compatible pool variable declaration.
     called when a V'age application is filed in
     (or one of its changes is accepted via the change browser)"

    |ns poolName pool|

    "/ when coming from the change-browser,
    "/ a namespace override may be given...
    ns := Class nameSpaceQuerySignal query.
    (ns isNil or:[ns == Smalltalk]) ifTrue:[
	poolName := poolNameArg asSymbol
    ] ifFalse:[
	poolName := (ns name,'::',poolNameArg) asSymbol
    ].
    pool := self classNamed:poolName.
    pool declareConstant:constantName value:value
!

declarePoolDictionary:poolDictionaryNameArg
    "visualAge compatible pool declaration.
     called when a V'age application is filed in
     (or one of its changes is accepted via the change browser)"

    |ns poolName|

    poolName := poolDictionaryNameArg asSymbol.

"/    "/ when coming from the change-browser,
"/    "/ a namespace override may be given...
"/    ns := Class nameSpaceQuerySignal query.
"/    (ns isNil or:[ns == Smalltalk]) ifTrue:[
"/        poolName := poolDictionaryNameArg asSymbol
"/    ] ifFalse:[
"/        poolName := (ns name,'::',poolDictionaryNameArg) asSymbol
"/    ].
    ^ SharedPool subclass:(poolName asSymbol)
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* VAST Pools'

    "Modified: / 07-02-2012 / 15:56:16 / cg"
!

declareVariable:varName poolName:poolNameArg
    "visualAge compatible pool declaration.
     called when a V'age application is filed in
     (or one of its changes is accepted via the change browser)"

    |ns poolName pool|

    "/ when coming from the change-browser,
    "/ a namespace override may be given...
    ns := Class nameSpaceQuerySignal query.
    (ns isNil or:[ns == Smalltalk]) ifTrue:[
	poolName := poolNameArg asSymbol
    ] ifFalse:[
	poolName := (ns name,'::',poolNameArg) asSymbol
    ].
    pool := self classNamed:poolName.
    pool declareVariable:varName

    "Created: / 07-02-2012 / 15:57:05 / cg"
! !

!Smalltalk class methodsFor:'Compatibility-VW'!

defineClass:nameSymbol superclass:superclass indexedType:indexed private:private instanceVariableNames:instVars classInstanceVariableNames:classInstVars imports:imports category:category
    ^ self
	defineClass:nameSymbol
	superclass:superclass
	indexedType:indexed
	private:private
	instanceVariableNames:instVars
	classInstanceVariableNames:classInstVars
	imports:imports
	category:category
	attributes:nil
!

defineClass:nameSymbol superclass:superclass indexedType:indexed private:private instanceVariableNames:instVars classInstanceVariableNames:classInstVars imports:imports category:category attributes:annotations
    |newClass|

    indexed == #none ifTrue:[
	newClass := superclass
	    subclass:nameSymbol
	    instanceVariableNames:instVars
	    classVariableNames:''
	    poolDictionaries:''
	    category:category
	    inEnvironment:self.
	classInstVars size > 0 ifTrue:[
	    newClass class instanceVariableNames:classInstVars.
	].
	^ newClass
    ].
    self shouldImplement.
!

defineNameSpace:nameSymbol private:private imports:imports category:category
    |newNameSpace|

    private ifTrue:[self halt].     "/ what to do ?
    imports withoutSeparators notEmpty ifTrue:[self halt].     "/ what to do ?
    newNameSpace := NameSpace name:nameSymbol.
    newNameSpace setCategory:category.
    ^ newNameSpace
!

dialectName
    ^ #SmalltalkX

    "
     Smalltalk dialectName
    "
!

dialectReleaseVersion
    ^ self versionString

    "
     Smalltalk dialectReleaseVersion
    "
! !

!Smalltalk class methodsFor:'accessing'!

associationAt:aKey
    "return a key-value association for aKey.
     Since ST/X's Smalltalk as no real dictionary, this is
     simulated here."

    |val|

    val := self at:aKey ifAbsent:[^ nil].
    ^ Association key:aKey value:val

    "Created: / 1.11.1997 / 13:27:20 / cg"
!

associationAt:aKey ifAbsent:exceptionBlock
    "return a key-value association for aKey, or the value
     from exceptionBlock, if no such key is present.
     Since ST/X's Smalltalk as no real dictionary, this is simulated here.
     Warning: this is a compatibility interface only, with a different semantic as
              the original ST80 implementation. The returned assoc is created on the fly,
              and not the one stored in the receiver (there are not assocs there)"

    |val|

    val := self at:aKey ifAbsent:[^ exceptionBlock value].
    ^ Association key:aKey value:val

    "Created: / 18.6.1998 / 17:05:24 / cg"
!

at:aKey
    "retrieve the value stored under aKey, a symbol.
     Return nil if not present
     (this will be changed to trigger an error - better use #at:ifAbsent:)"

    aKey class == Symbol ifFalse:[self error:'expected symbol'].

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	STSymbol keySymbol = aKey.asSTSymbol();
	STObject val = STSmalltalkEnvironment.GetResolvedBindingOrNull(keySymbol);

	return context._RETURN( val == null ? Nil : val );
    }
    /* NOT REACHED */
#else
    RETURN ( __GLOBAL_GET(aKey) );
#endif
%}.
    ^ self primitiveFailed
!

at:aKey ifAbsent:aBlock
    "retrieve the value stored at aKey.
     If there is nothing stored under this key, return the value of
     the evaluation of aBlock."

    |val|

    val := self at:aKey.
    (val notNil or:[self includesKey:aKey]) ifTrue:[
        ^ val
    ].
    ^ aBlock value

    "
     Smalltalk removeKey:#fooBar.
     Smalltalk at:#fooBar                       <- returns nil
     Smalltalk at:#fooBar ifAbsent:['sorry']    <- no error
    "
!

at:aKey ifAbsentPut:aBlock
    "return the element indexed by aKey if present,
     if not present, store the result of evaluating valueBlock
     under aKey and return it."

    ^ self at:aKey ifAbsent:[ self at:aKey put:aBlock value ].

    "Created: / 29-05-2007 / 12:41:12 / cg"
!

at:aKey ifPresent:aBlock
    "try to retrieve the value stored at aKey.
     If there is nothing stored under this key, do nothing.
     Otherwise, evaluate aBlock, passing the retrieved value as argument."

    |val|

    val := self at:aKey.
    (val notNil or:[self includesKey:aKey]) ifTrue:[
        ^ aBlock value:val.
    ].
    ^ nil

    "
     Smalltalk at:#fooBar ifPresent:[:what | Transcript showCR:what].
     Smalltalk at:#Object ifPresent:[:what | Transcript showCR:what].

     Smalltalk at:#fooBar put:nil.
     Smalltalk at:#fooBar ifPresent:[:what | Transcript showCR:what].
    "

    "Modified: / 27-12-2011 / 10:14:30 / cg"
!

at:aKey put:aValue
    "store the argument aValue under aKey, a symbol.
     Return aValue (sigh)."

    |oldValue|

%{
#ifdef __SCHTEAM__
    {
	STSymbol keySymbol = aKey.asSTSymbol();
	oldValue = STSmalltalkEnvironment.SetBinding(keySymbol, aValue);
    }
#else
    oldValue = __GLOBAL_SET(aKey, aValue, (OBJ *)0);
#endif
%}.
    CachedClasses notNil ifTrue:[
	oldValue isBehavior ifTrue:[
	    oldValue name == aKey ifTrue:[
		CachedClasses remove:oldValue ifAbsent:[]
	    ]
	].
	aValue isBehavior ifTrue:[
	    aValue name == aKey ifTrue:[
		CachedClasses add:aValue
	    ] ifFalse:[
		CachedClasses := nil
	    ]
	].
    ].
    ^ aValue.

    "Modified: 19.4.1996 / 11:31:49 / cg"
!

includesKey:aKey
    "return true, if the key is known"

    "/ for debugging - this is a common mistake,
    "/ to try to access a class by nameString, instead
    "/ of by symbol.

    "/ aKey class == String ifTrue:[self halt].

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    STSymbol keySymbol = aKey.asSTSymbol();
    return __c__._RETURN( STSmalltalkEnvironment.HasBinding(keySymbol) ? STObject.True : STObject.False);
    /* NOT REACHED */
#else
    RETURN ( __GLOBAL_KEYKNOWN(aKey) );
#endif
%}.
    ^ self primitiveFailed
!

keyAtValue:anObject
    "return the symbol under which anObject is stored - or nil"

    self keysDo:[:aKey |
	(self at:aKey) == anObject ifTrue:[^ aKey]
    ].
    ^ nil

    "Smalltalk keyAtValue:Object"
!

keys
    "return a collection with all keys in the Smalltalk dictionary"

    |keys|

    keys := IdentitySet new: self size.
    self keysDo:[:k | keys add:k].
    ^ keys
!

removeKey:aKey
    "remove the association stored under the key-argument from the globals dictionary.
     WARNING:
	this is somewhat dangerous: conceptionally, the association is removed,
	to which machine & byte compiled code refers if it accesses a global.
	If there are still global accesses in some literalArray or from machine-compiled code,
	it continues to reference the globals value via that obsolete association and gets a nil
	value.  (which is correct)
	However, if that global is later reintroduced, a new association will be created and
	the new global now referenced via the new association.
	The old accesses will still see nil, although the globals value is actually non-nil
	(this is questionable).
	To avoid this problem, the #removeClass: method never removed the key."

    CachedClasses := nil.

%{  /* NOCONTEXT */
    RETURN ( __GLOBAL_REMOVE(aKey) );
%}.
    ^ self primitiveFailed

!

startBlocks
    ^ StartBlocks
!

values
    "return a collection with all values in the Smalltalk dictionary"

    |values|

    values := OrderedCollection new: self size.
    self do:[:v | values add:v].
    ^ values

    "Created: 20.6.1997 / 16:58:28 / cg"
! !


!Smalltalk class methodsFor:'browsing'!

browseAllCallsOn:aSelectorSymbol
    "{ Pragma: +optSpace }"

    "startup a browser for all methods sending a particular message"

    UserPreferences systemBrowserClass browseAllCallsOn:aSelectorSymbol

    "
     Smalltalk browseAllCallsOn:#at:put:
    "
!

browseAllSelect:aBlock
    "{ Pragma: +optSpace }"

    "startup a browser for all methods for which aBlock returns true"

    UserPreferences systemBrowserClass browseAllSelect:aBlock

    "
     Smalltalk browseAllSelect:[:m | m literals isNil]
    "
!

browseChanges
    "{ Pragma: +optSpace }"

    "startup a changes browser"

    ChangesBrowser notNil ifTrue:[
	ChangesBrowser open
    ] ifFalse:[
	self warn:'no ChangesBrowser built in'
    ]

    "
     Smalltalk browseChanges
    "
!

browseClass:aClass
    "{ Pragma: +optSpace }"

    "startup a browser on aClass.
     The broser will only show that class (i.e. be a singleClass-browser).
     See browseInClass: for a full browser, which has aClass selected initially."

    UserPreferences systemBrowserClass browseClass:aClass

    "
     Smalltalk browseClass:Array
    "
!

browseImplementorsMatching:aSelectorSymbolOrMatchPattern
    "{ Pragma: +optSpace }"

    "startup a browser for all methods implementing a message matching"

    UserPreferences systemBrowserClass browseImplementorsMatching:aSelectorSymbolOrMatchPattern

    "
     Smalltalk browseImplementorsOf:#'at:put:'
     Smalltalk browseImplementorsMatching:#'at:*'
    "
!

browseImplementorsOf:aSelectorSymbol
    "{ Pragma: +optSpace }"

    "startup a browser for all methods implementing a particular message"

    UserPreferences systemBrowserClass browseImplementorsOf:aSelectorSymbol

    "
     Smalltalk browseImplementorsOf:#at:put:
    "
!

browseInClass:aClass
    "{ Pragma: +optSpace }"

    "startup a full browser showing aClass.
     The browser will be a full browser with aClass initially selected.
     See browseClass: for a singleClass browser, which shows only a single class."

    UserPreferences systemBrowserClass openInClass:aClass

    "
     Smalltalk browseInClass:Array
    "
!

browseInClass:aClass selector:selector
    "{ Pragma: +optSpace }"

    "startup a full browser showing aClass>>selector.
     The browser will be a full browser with aClass initially selected.
     See browseClass: for a singleClass browser, which shows only a single class."

    UserPreferences systemBrowserClass openInClass:aClass selector:selector

    "
     Smalltalk browseInClass:Array selector:#at:
    "
! !

!Smalltalk class methodsFor:'class management'!

basicRemoveClass:aClass
    "remove the argument, aClass from the smalltalk dictionary;
     we have to flush the caches since these methods are now void.
     Also, class variables of aClass are removed."

    |sym cSym names oldName oldNameSym actualName wrongName|

    aClass isNil ifTrue:[^ self].

    oldName := aClass name.
    sym := oldNameSym := oldName asSymbol.
    ((self at:oldNameSym) == aClass) ifFalse:[
        "check other name ..."
        (self includes:aClass) ifFalse:[
            'Smalltalk [warning]: no such class: ' errorPrint. oldName errorPrintCR.
            ^ self
        ].
        "
         the class has changed its name - without telling me ...
         what should be done in this case ?
        "
        'Smalltalk [warning]: class ' errorPrint. oldName errorPrint.
        ' has changed its name' errorPrintCR.

        "/
        "/ might be an alias (i.e. removing a compatibility name)
        "/
        actualName := self keyAtValue:aClass.
        ('Smalltalk [info]: ' , oldName , ' is actually stored as ' , actualName , '.') infoPrintCR.
        sym := actualName asSymbol.
        oldName := actualName asString.
        wrongName := true.
    ].

    aClass isBuiltInClass ifTrue:[
        self error: 'Cannot remove builtin class!!'.
    ].
    self at:sym put:nil.    "nil it out for compiled accesses"

    "/
    "/ see comment in removeKey: on why we don't remove it here
    "/
    "/ self removeKey:sym.     "/ remove key - this actually fails, if there are
                               "/ still compiled code references."

    "remove private classes"

    aClass privateClassesSorted do:[:somePrivateClass |
        aClass privateClassesAt:(somePrivateClass nameWithoutPrefix) asSymbol put:nil.
    ].

    "remove class variables"

    names := aClass classVariableString asCollectionOfWords.
    names do:[:name |
        cSym := aClass globalKeyForClassVar:name.
        self at:cSym asSymbol put:nil.

        "/
        "/ see comment in removeKey: on why we dont remove it here
        "/
        "/ self removeKey:cSym
    ].


"/    actually could get along with less flushing
"/    (entries for aClass and subclasses only)
"/    but we have to delay this, until we have the set of subclasses
"/    at hand - for now, searching for all subclasses is way more
"/    expensive then cache flushing.
"/
"/    aClass allSubclassesDo:[:aSubclass |
"/        ObjectMemory flushInlineCachesForClass:aSubclass.
"/        ObjectMemory flushMethodCacheFor:aSubclass
"/    ].
"/    ObjectMemory flushInlineCachesForClass:aClass.
"/    ObjectMemory flushMethodCacheFor:aClass

    ObjectMemory flushInlineCaches.
    ObjectMemory flushMethodCache.

    aClass addChangeRecordForClassRemove.
    self changed:#classRemove with:aClass.

    aClass setCategory:#'* removed *'.

"/    self flushCachedClasses.
"/    Class flushSubclassInfo.
    self flushCachedClass:aClass.
    Class flushSubclassInfoFor:aClass superclass.
    Class flushSubclassInfoFor:aClass.

    wrongName == true ifTrue:[
        "/
        "/ an alias (i.e. removing a compatibility name)
        "/
        "/ check if there are more refs to it ...
        [self includes:aClass] whileTrue:[
            actualName := self keyAtValue:aClass.
            ('Smalltalk [info]: ' , aClass name , ' is also registered under the name ' , actualName
                          , ' - remove that binding too.') infoPrintCR.
            self at:actualName put:nil.
        ].
    ].

    "Modified: / 18-11-2006 / 17:16:31 / cg"
!

changeCategoryOf:aClass to:newCategory
    "change a classes category, add a change record,
     send change notifications"

    |ns oldCategory|

    oldCategory := aClass category.
    oldCategory ~= newCategory ifTrue:[
	aClass category:(newCategory withoutSeparators asSymbol).

	"notify change of category"
	ns := aClass environment ? self.
	ns changed:#organization with:(aClass -> oldCategory).
	ns ~~ self ifTrue:[
	    self changed:#organization with:(aClass -> oldCategory).
	]
    ].

    "
     Smalltalk changeCategoryOf:NewApplication to:#myApplications
    "

    "Modified: / 11.2.2000 / 11:36:27 / cg"
!

defineNameSpace: name private: private imports: imports category: category attributes: annotations
    NameSpace name:name

!

flushCachedClass:aClass
    CachedClasses notNil ifTrue:[
	CachedClasses remove:aClass ifAbsent:[].
    ].
!

flushCachedClasses
    CachedClasses := nil.

    "
     Smalltalk flushCachedClasses
    "
!

removeClass:aClass
    "remove the argument, aClass from the smalltalk dictionary;
     we have to flush the caches since these methods are now void.
     Also, class variables of aClass are removed.
     Recompile accessors to aClass."

    |oldNameSym ns ons|

    oldNameSym := aClass name asSymbol.
    ns := aClass nameSpace.
    aClass topOwningClass notNil ifTrue:[
        ons := aClass topOwningClass nameSpace
    ].

    self basicRemoveClass:aClass.

    ns ~~ Smalltalk ifTrue:[
        ons notNil ifTrue:[
            ClassBuilder
                recompileGlobalAccessorsTo:oldNameSym
                in:ons
                except:nil
        ].
        (ns notNil and:[ns ~~ ons]) ifTrue:[
            ClassBuilder
                recompileGlobalAccessorsTo:oldNameSym
                in:ns
                except:nil
        ].
    ].
!

removeClasses:aCollectionOfClasses
    "remove aCollectionOfClasses from the smalltalk dictionary;
     we have to flush the caches since these methods are now void.
     Also, class variables of aClass are removed.
     Recompile accessors to the classes - after all classes in the collection have been removed."

    |tuples|

    tuples := aCollectionOfClasses collect:[:eachClass|
                Array
                    with:eachClass name asSymbol
                    with:eachClass nameSpace
                    with:(
                            eachClass topOwningClass notNil ifTrue:[
                                eachClass topOwningClass nameSpace
                            ] ifFalse:[nil])
            ].

    aCollectionOfClasses do:[:eachClass|
        self basicRemoveClass:eachClass.
    ].

    tuples do:[:eachClssymNsOnsTuple|
        |oldNameSym ns ons|

        oldNameSym := eachClssymNsOnsTuple at:1.
        ns := eachClssymNsOnsTuple at:2.
        ons := eachClssymNsOnsTuple at:3.

        ns ~~ Smalltalk ifTrue:[
            ons notNil ifTrue:[
                ClassBuilder
                    recompileGlobalAccessorsTo:oldNameSym
                    in:ons
                    except:nil
            ].
            (ns notNil and:[ns ~~ ons]) ifTrue:[
                ClassBuilder
                    recompileGlobalAccessorsTo:oldNameSym
                    in:ns
                    except:nil
            ].
        ]
    ].
!

renameClass:aClass to:newName
    "rename aClass to newName. Most of the work is in
     renaming the classVariables (create & copy over values)
     and patching the classes methods to access the new variables."

    |oldName oldSym newSym names oldCVSym newCVSym value oldNameToNewName
     oldNameSpace newNameSpace oldBaseName newBaseName privateClasses
     oldBaseNameWithoutPrefix newBaseNameWithoutPrefix i1 i2 nm ns subns
     oldMetaclass newMetaclass newCategory|

    "/ check for all intermediate namespaces / owning classes
    i1 := 1.
    i2 := 1.
    ns := self.
    [i2 ~~ 0] whileTrue:[
        i2 := newName indexOfSubCollection:'::' startingAt:i1.
        i2 ~~ 0 ifTrue:[
            nm := newName copyFrom:i1 to:i2-1.
            ns isNameSpace ifTrue:[
                subns := ns at:nm asSymbol ifAbsent:nil.
                subns isNil ifTrue:[
                    self error:'Nonexisting namespace: ',nm.
                    ^ nil.
                ].
            ] ifFalse:[
                subns := ns privateClassesAt:nm asSymbol.
                subns isNil ifTrue:[
                    self error:'Cannot create a namespace below a class'
                ]
            ].
            ns := subns.
            i1 := i2 + 2.
        ].
    ].

    oldName := aClass name.
    oldNameSpace := aClass topNameSpace.
    oldBaseName := aClass nameWithoutNameSpacePrefix.
    oldBaseNameWithoutPrefix := aClass nameWithoutPrefix.
    oldSym := oldName asSymbol.
    privateClasses := aClass privateClassesSorted.

    ((self at:oldSym) ~~ aClass) ifTrue:[
        'Smalltalk [warning]: rename failed - name is different from key' errorPrintCR.
        ^ self
    ].

    "/ rename the class

    newSym := newName asSymbol.

    "/ change the owning class
    ns isNameSpace ifFalse:[
        aClass isPrivate ifTrue:[
            aClass class setOwningClass:ns.
        ] ifFalse:[
            "/ sigh - must make a PrivateMetaclass from Metaclass
            oldMetaclass := aClass class.
            newMetaclass := PrivateMetaclass new.
            newMetaclass flags:(oldMetaclass flags).
            newMetaclass setSuperclass:(oldMetaclass superclass).
            newMetaclass instSize:(oldMetaclass instSize).
            newMetaclass setInstanceVariableString:(oldMetaclass instanceVariableString).
            newMetaclass setMethodDictionary:(oldMetaclass methodDictionary).
            newMetaclass setSoleInstance:aClass.
            newMetaclass setOwningClass:ns.

            aClass changeClassTo:newMetaclass.
            ObjectMemory flushCaches.
        ]
    ] ifTrue:[
        aClass isPrivate ifTrue:[
            newCategory := aClass topOwningClass category.

            "/ sigh - must make a Metaclass from PrivateMetaclass
            oldMetaclass := aClass class.

            newMetaclass := Metaclass new.
            newMetaclass flags:(oldMetaclass flags).
            newMetaclass setSuperclass:(oldMetaclass superclass).
            newMetaclass instSize:(oldMetaclass instSize).
            newMetaclass setInstanceVariableString:(oldMetaclass instanceVariableString).
            newMetaclass setMethodDictionary:(oldMetaclass methodDictionary).
            newMetaclass setSoleInstance:aClass.

            aClass category:newCategory.
            aClass changeClassTo:newMetaclass.
            ObjectMemory flushCaches.
        ]
    ].

    aClass setName:newSym.

    "/ store it in Smalltalk
    self at:oldSym put:nil.

    "/
    "/ see comment in #removeKey: on why we don't remove it it here
    "/
    "/ self removeKey:oldSym.
    self at:newSym put:aClass.

    "/ create new class variables and copy over values

    oldNameToNewName := IdentityDictionary new.

    names := aClass classVariableString asCollectionOfWords.
    names do:[:name |
        oldCVSym := (oldSym , ':' , name) asSymbol.
        value := self at:oldCVSym.
        self at:oldCVSym put:nil.

        "/
        "/ see comment in #removeKey: on why we dont remove it it here
        "/
        "/ self removeKey:cSym.

        newCVSym := (newSym , ':' , name) asSymbol.
        self at:newCVSym put:value.

        oldNameToNewName at:oldCVSym put:newCVSym.
    ].

    "/ patch methods literal arrays from oldCVname to newCVname

    oldNameToNewName keysAndValuesDo:[:oldNameSym :newNameSym |
        aClass withAllSubclasses do:[:aSubClass |
            Transcript showCR:'changing global accesses from ''' , oldNameSym , ''' into ''' , newNameSym , ''' in class: ''' , aSubClass name , ''' ...'.
            aSubClass instAndClassSelectorsAndMethodsDo:[:sel :aMethod |
                aMethod changeLiteral:oldNameSym to:newNameSym
            ].
        ].

        "/ and also in privateClasses ? ...

"/        privateClasses size > 0 ifTrue:[
"/            privateClasses do:[:aPrivateClass |
"/                aPrivateClass withAllSubclasses do:[:aSubClass |
"/                    aSubClass class methodDictionary do:[:aMethod |
"/                        aMethod changeLiteral:oldNameSym to:newNameSym
"/                    ].
"/                    aSubClass methodDictionary do:[:aMethod |
"/                        aMethod changeLiteral:oldNameSym to:newNameSym
"/                    ]
"/                ].
"/            ]
"/        ]
    ].

    aClass addChangeRecordForClassRename:oldSym to:newSym.

    "/ clear the namespace (for namespace query to work)
    aClass setEnvironment:nil.
    newNameSpace := aClass topNameSpace.

    privateClasses size > 0 ifTrue:[
        "/ must rename privateClasses as well
        Class withoutUpdatingChangesDo:[
            privateClasses do:[:aPrivateClass |
                self renameClass:aPrivateClass
                     to:(newSym , '::' , aPrivateClass nameWithoutPrefix).

                Transcript showCR:'recompiling methods in ''' , newNameSpace name , ''' accessing ''' , oldName , '::' , aPrivateClass nameWithoutPrefix , ''' ...'.
                aClass theNonMetaclass recompileMethodsAccessingGlobal:(oldName , '::' , aPrivateClass nameWithoutPrefix) asSymbol.
                aClass theMetaclass recompileMethodsAccessingGlobal:(oldName , '::' , aPrivateClass nameWithoutPrefix) asSymbol.
                aClass theNonMetaclass recompileMethodsAccessingGlobal:(aPrivateClass nameWithoutPrefix) asSymbol.
                aClass theMetaclass recompileMethodsAccessingGlobal:(aPrivateClass nameWithoutPrefix) asSymbol.
"/                ClassBuilder
"/                    recompileGlobalAccessorsTo:(oldName , '::' , aPrivateClass nameWithoutPrefix) asSymbol
"/                    in:newNameSpace
"/                    except:nil.
            ]
        ]
    ].

    oldNameSpace ~~ newNameSpace ifTrue:[

        "/ all those referencing the class from the old nameSpace
        "/ must be recompiled ...
        "/ (to now access the global from smalltalk)

        oldNameSpace ~~ Smalltalk ifTrue:[
            Transcript showCR:'recompiling methods in ''' , oldNameSpace name , ''' accessing ''' , oldName , ''' ...'.

            ClassBuilder
                recompileGlobalAccessorsTo:oldName asSymbol
                in:oldNameSpace
                except:nil.
        ].

        "/ all referencing the class in the new namespace
        "/ as well; to now access the new class.

        (newNameSpace notNil and:[newNameSpace ~~ Smalltalk]) ifTrue:[
            Transcript showCR:'recompiling methods in ''' , newNameSpace name , ''' accessing ''' , oldBaseName , ''' ...'.

            ClassBuilder
                recompileGlobalAccessorsTo:oldBaseName asSymbol
                in:newNameSpace
                except:nil.
        ].
    ] ifFalse:[
        "/ all references to a global with my new name in my owning class
        "/ must now be redirected to myself.

        aClass isPrivate ifTrue:[
            newBaseName := aClass nameWithoutNameSpacePrefix.
            newBaseNameWithoutPrefix := aClass nameWithoutPrefix.

            Transcript showCR:'recompiling methods accessing ''' , oldBaseNameWithoutPrefix , ''' in: ''' , aClass owningClass name , ''' ...'.
            aClass owningClass recompileMethodsAccessingGlobal:oldBaseNameWithoutPrefix.
            aClass owningClass class recompileMethodsAccessingGlobal:oldBaseNameWithoutPrefix.

            Transcript showCR:'recompiling methods accessing ''' , oldBaseName , ''' in: ''' , aClass owningClass name , ''' ...'.
            aClass owningClass recompileMethodsAccessingGlobal:oldBaseName.
            aClass owningClass class recompileMethodsAccessingGlobal:oldBaseName.

            Transcript showCR:'recompiling methods accessing ''' , newBaseNameWithoutPrefix , ''' in: ''' , aClass owningClass name , ''' ...'.
            aClass owningClass recompileMethodsAccessingGlobal:newBaseNameWithoutPrefix.
            aClass owningClass class recompileMethodsAccessingGlobal:newBaseNameWithoutPrefix.

            Transcript showCR:'recompiling methods accessing ''' , newBaseName , ''' in: ''' , aClass owningClass name , ''' ...'.
            aClass owningClass recompileMethodsAccessingGlobal:newBaseName.
            aClass owningClass class recompileMethodsAccessingGlobal:newBaseName.
        ]
    ].

    aClass changed:#definition.
    "/ because of the change of my superclasses name ...
    aClass allSubclassesDo:[:subClass |
        subClass changed:#definition.
    ].
    "/ because of the change of my superclasses name ...
    aClass subclassesDo:[:subClass |
        subClass addChangeRecordForClass:subClass.
    ].
    self changed:#definition.
    self changed:#classRename with:(Array with:aClass with:oldName).

    "Created: / 29-10-1995 / 19:58:32 / cg"
    "Modified: / 18-06-1996 / 14:20:50 / stefan"
    "Modified: / 05-09-2006 / 12:52:25 / cg"
! !

!Smalltalk class methodsFor:'copying'!

deepCopy
    "redefined to return self - there is only one Smalltalk dictionary"

    ^ self

    "Modified: 18.5.1996 / 12:13:33 / cg"
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of the receiver.
     Redefined to return the receiver - there is only one Smalltalk dictionary"

    ^ self

    "Modified: 18.5.1996 / 12:13:36 / cg"
!

shallowCopy
    "redefined to return self - there is only one Smalltalk dictionary"

    ^ self

    "Modified: 18.5.1996 / 12:13:39 / cg"
!

simpleDeepCopy
    "redefined to return self - there is only one Smalltalk dictionary"

    ^ self

    "Modified: 18.5.1996 / 12:13:42 / cg"
! !

!Smalltalk class methodsFor:'debugging ST/X'!

compileTrace:aBoolean
    "dump generated inline code (NOOP if VM was compiled without the trace-debug option)"
%{
    extern char __compileTrace__;

    __compileTrace__ = (aBoolean == true) ? 1 : 0;
%}
    "
     Smalltalk compileTrace:true
     Smalltalk compileTrace:false
    "
!

debugBreakPoint
    "{ Pragma: +optSpace }"

    "call the dummy debug function, on which a breakpoint
     can be put in adb, sdb, dbx or gdb.
     WARNING: this method is for debugging only
	      it will be removed without notice."
%{
    __PATCHUPCONTEXTS(__context);
    __debugBreakPoint__();
%}.
    ^ self
!

exitWithCoreDump
    "{ Pragma: +optSpace }"

    "abort the program and dump core"

    OperatingSystem exitWithCoreDump
    "/ never returns

    "Be careful evaluating this:
     Smalltalk exitWithCoreDump
    "
!

fatalAbort
    "{ Pragma: +optSpace }"

    "report a fatal-error, print a stack backtrace and exit with core dump.
     (You may turn off the stack print with debugPrinting:false)"

    self fatalAbort:'fatalAbort'
!

fatalAbort:aMessage
    "{ Pragma: +optSpace }"

    "report a fatal-error; print a stack backtrace and exit with core dump
     (You may turn off the stack print with debugPrinting:false)"

%{
#ifdef __SCHTEAM__
    STMain.fatalAbort( aMessage );
    /* NOT REACHED */
#else
    char *msg;

    if (__isStringLike(aMessage))
	msg = (char *) __stringVal(aMessage);
    else
	msg = "fatalAbort";

    __fatal0(__context, msg);
    /* NEVER RETURNS */
#endif
%}.
    ^ self primitiveFailed
!

ignoreHalt
    "return true, if halts are ignored.
     Usually, this is done in standAlone applications"

    IgnoreHalt isNil ifTrue:[
	^  self isStandAloneApp
    ].
    ^ IgnoreHalt

    "Created: / 18-11-2010 / 11:20:16 / cg"
!

ignoreHalt:aBoolean
    "control if halts are to be ignored;
     usually, this is done in standAlone applications"

    IgnoreHalt := aBoolean

    "
     Smalltalk ignoreHalt:true.
     self halt.
     Smalltalk ignoreHalt:false.
     self halt.
    "

    "Created: / 18-11-2010 / 11:20:27 / cg"
!

verbose
    ^ Verbose
!

verbose:aBoolean
    Verbose := aBoolean
!

vmInstructionTrace:aBoolean
    self halt:'not yet implemented'

    "Modified: / 19-01-2012 / 10:15:35 / cg"
! !

!Smalltalk class methodsFor:'enumerating'!

allBehaviorsDo:aBlock
    "evaluate the argument, aBlock for all classes and metaclasses in the system"

    self allClassesAndMetaclassesDo:aBlock

    "
     Smalltalk allBehaviorsDo:[:aClass | aClass name printCR]
    "
!

allClassCategories
    "return a set of all class categories in the system"

    |allCategories|

    allCategories := Set new.
    Smalltalk allClassesDo:[:cls |
	|category|

	category := cls category.
	category notNil ifTrue:[
	    allCategories add:category.
	].
    ].

    ^ allCategories.

    "
     Smalltalk allClassCategories
    "

    "Created: / 17.11.2001 / 12:13:09 / cg"
!

allClassesAndMetaclassesDo:aBlock
    "evaluate the argument, aBlock for all classes and metaclasses in the system."

    |already numClassesHintTimes2|

    numClassesHintTimes2 := NumberOfClassesHint*2.
    already := IdentitySet new:numClassesHintTimes2.
    self allClassesDo:[:eachClass |
        |theNonMeta theMeta|

        theNonMeta := eachClass theNonMetaclass.
        (already includes:theNonMeta) ifFalse:[
            aBlock value:theNonMeta.
            already add:theNonMeta.
        ].
        theMeta := theNonMeta class.
        (already includes:theMeta) ifFalse:[
            aBlock value:theMeta.
            already add:theMeta.
        ].
        already size > numClassesHintTimes2 ifTrue:[
            NumberOfClassesHint := (already size // 2) + 10
        ].
    ].
!

allClassesDo:aBlock
    "evaluate the argument, aBlock for all classes in the system."

    self allClasses do:aBlock

    "
     Smalltalk allClassesDo:[:aClass | aClass name printCR]
    "
!

allClassesForWhich:filter
    "return a collection with all classes in the system,
     for which filter evaluates to true."

    |collectedClasses|

    collectedClasses := OrderedCollection new.
    self allClassesForWhich:filter do:[:cls |
	collectedClasses add:cls
    ].
    ^ collectedClasses

    "
     Smalltalk
	allClassesForWhich:[:cls | cls name startsWith:'Po']
    "

    "Created: / 10-08-2006 / 12:11:31 / cg"
!

allClassesForWhich:filter do:aBlock
    "evaluate the argument, aBlock for all classes in the system, for which filter evaluates to true."

    self allClassesDo:[:cls |
	(filter value:cls) ifTrue:[ aBlock value:cls ].
    ].

    "
     Smalltalk
	allClassesForWhich:[:cls | cls name startsWith:'Po']
	do:[:aClass | Transcript showCR:aClass name]
    "
!

allClassesInCategory:aCategory
    "return a collection of for all classes in aCategory;
     The order of the classes is not defined."

    ^ self allClassesForWhich:[:cls | cls category = aCategory]

    "
     Smalltalk allClassesInCategory:'Views-Basic'
    "

    "Modified: / 10-08-2006 / 12:13:32 / cg"
!

allClassesInCategory:aCategory do:aBlock
    "evaluate the argument, aBlock for all classes in the aCategory;
     The order of the classes is not defined."

    aCategory notNil ifTrue:[
	self allClassesForWhich:[:cls | cls category = aCategory] do:aBlock
    ]

    "
     Smalltalk allClassesInCategory:'Views-Basic' do:[:aClass | Transcript showCR:aClass]
    "

    "Modified: / 09-08-2006 / 17:18:50 / fm"
!

allClassesInCategory:aCategory inOrderDo:aBlock
    "evaluate the argument, aBlock for all classes in aCategory;
     superclasses come first - then subclasses"

    |classes|

    aCategory notNil ifTrue:[
	classes := OrderedCollection new.
	self allClassesInCategory:aCategory do:[:aClass |
	    classes add:aClass
	].
	classes topologicalSort:[:a :b | b isSubclassOf:a].
	classes do:aBlock
    ]

    "
     Smalltalk allClassesInCategory:'Views-Basic' inOrderDo:[:aClass | aClass name printCR]
    "

    "Modified: / 17.11.2001 / 12:18:15 / cg"
!

allClassesInOrderDo:aBlock
    "evaluate the argument, aBlock for all classes in the system;
     Evaluation order is by inheritance: superclasses come first."

    |already|

    already := IdentitySet new:NumberOfClassesHint.
    self allClassesDo:[:eachClass |
	(already includes:eachClass) ifFalse:[
	    eachClass allSuperclasses reverseDo:[:eachSuperClass |
		(already includes:eachSuperClass) ifFalse:[
		    already add:eachSuperClass.
		    aBlock value:eachSuperClass.
		].
	    ].
	    already add:eachClass.
	    aBlock value:eachClass.
	]
    ].

    "
     Smalltalk allClassesInOrderDo:[:aClass | Transcript showCR:aClass name]
    "
!

allClassesInPackage:aPackageID
    "evaluate the argument, aBlock for all classes a package;
     The order of the classes is not defined.
     The returned collection may include private classes"

    ^ self allClassesForWhich:[:cls | cls package = aPackageID]

    "
     Smalltalk allClassesInPackage:'bosch:dapasx'
    "

    "Created: / 10-08-2006 / 12:14:10 / cg"
    "Modified: / 12-10-2006 / 23:48:43 / cg"
!

allClassesInPackage:aPackageID do:aBlock
    "evaluate the argument, aBlock for all classes a package;
     The order of the classes is not defined."

    ^ self allClassesForWhich:[:cls | cls package = aPackageID] do:aBlock

    "
     Smalltalk allClassesInPackage:'bosch:dapasx' do:[:aClass | Transcript showCR:aClass]
    "

    "Created: / 09-08-2006 / 17:14:17 / fm"
!

allKeysDo:aBlock
    <resource: #obsolete>
    "evaluate the argument, aBlock for all keys in the Smalltalk dictionary"

    self obsoleteMethodWarning:'please use #keysDo:'.
    self keysDo:aBlock

    "Modified: / 20-01-2017 / 17:52:40 / stefan"
!

allMethodCategories
    "return a set of all method-categories (protocols) in the system"

    |allCategories|

    allCategories := Set new.
    Smalltalk allClassesDo:[:cls |
	allCategories addAll:cls categories.
    ].

    ^ allCategories.

    "
     Smalltalk allMethodCategories
    "
!

allMethodsDo:aBlock
    "enumerate all methods in all classes"

    Smalltalk allClassesDo:[:eachClass |
	eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
	    aBlock value:mthd
	]
    ].
!

allMethodsForWhich:aBlock
    "return a collection of methods for which aBlock returns true"

    |coll|

    coll := OrderedCollection new.
    Smalltalk allClassesDo:[:eachClass |
	eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
	    (aBlock value:mthd) ifTrue:[
		coll add:mthd
	    ].
	]
    ].
    ^ coll
!

allMethodsWithSelectorDo:aTwoArgBlock
    "enumerate all methods in all classes and evaluate aBlock
     with method and selector as arguments."

    Smalltalk allClassesDo:[:eachClass |
	eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
	    aTwoArgBlock value:mthd value:sel
	]
    ].
!

associationsDo:aBlock
    "evaluate the argument, aBlock for all key/value pairs
     in the Smalltalk dictionary"

    self keysDo:[:aKey |
	aBlock value:(aKey -> (self at:aKey))
    ]

    "Smalltalk associationsDo:[:assoc | assoc printCR]"
!

basicKeys
    "for rel > 5 only"

%{
#ifdef __SCHTEAM__
    STObject[] keys = STSmalltalkEnvironment.GetKeyVector();
    return __c__._RETURN( new STVector(keys) );
#endif
%}.
    self primitiveFailed
!

do:aBlock
    "evaluate the argument, aBlock for all values in the Smalltalk dictionary"

    |work|

%{  /* NOREGISTER - work may not be placed into a register here */
    __GLOBALS_DO(&aBlock, &work);
    RETURN (self);
%}.
    self keysDo:[:aKey |
	aBlock value:(self at:aKey)
    ]
!

keysAndValuesDo:aBlock
    "evaluate the two-arg block, aBlock for all keys and values"

    self keysDo:[:aKey |
	aBlock value:aKey value:(self at:aKey)
    ]
!

keysAndValuesSelect:selectBlockWith2Args thenCollect:collectBlockWith2Args
    |collected|

    collected := OrderedCollection new.
    self keysAndValuesDo:[:eachKey :eachValue |
	(selectBlockWith2Args value:eachKey value:eachValue) ifTrue:[
	    collected add:(collectBlockWith2Args value:eachKey value:eachValue)
	].
    ].
    ^ collected

    "
     Smalltalk
	keysAndValuesSelect:[:nm :val | (nm startsWith:'Ab') and:[val notNil]]
	thenCollect:[:nm :val | nm]
    "
!

keysDo:aBlock
    "evaluate the argument, aBlock for all keys in the Smalltalk dictionary"
    |work|

%{  /* NOREGISTER - work may not be placed into a register here */
    __GLOBALKEYS_DO(&aBlock, &work);
    RETURN (self);
%}.
    self basicKeys do:[:aKey |
	aBlock value:aKey
    ]
! !

!Smalltalk class methodsFor:'message control'!

silentLoading
    "returns the Silentloading class variable, which globally controls if compilation
     messages are shown on the transcript during a fileIn."

     ^ SilentLoading ? false
!

silentLoading:aBoolean
    "{ Pragma: +optSpace }"

    "allows access to the Silentloading class variable, which controls
     messages (especially during fileIn) onto the transcript.
     You can save a snapshot with this flag set to true, which makes
     the image come up silent. Can also be set, to read in files unlogged."

    |prev|

    prev := SilentLoading.
    SilentLoading := aBoolean.
    ^ prev
!

silentlyLoadingDo:aBlock
    "evaluates aBlock with silent loading on - no compilation messages (except errors)
     are shown on the transcript"

    |sav|

    Smalltalk verbose ifTrue:[
        aBlock value.
        ^ self.
    ].

    sav := SilentLoading.
    SilentLoading := true.
    aBlock ensure:[ SilentLoading := sav ].
! !

!Smalltalk class methodsFor:'misc accessing'!

beHeadless:aBoolean
    "set/clear the headlessOperation flag."

    HeadlessOperation := aBoolean
!

beSTScript:aBoolean
    "set/clear the isSTScript flag."

    IsSTScript := aBoolean

    "Created: / 06-12-2006 / 16:43:36 / cg"
!

standAloneApp:aBoolean
    "set/clear the StandAlone flag."

    StandAlone := aBoolean
! !


!Smalltalk class methodsFor:'private-system management-packages'!

basicLoadPackage:aPackageString fromDirectory:packageDirOrStringOrNil asAutoloaded:doLoadAsAutoloaded
    "load a package referenced by aPackageString - a string like 'stx:libbasic'.
     The package is either located in packageDirOrStringOrNil, or in the current directory (if nil).
     Answer true, if the load succeeded, false if it failed"

    |packageDirOrNil binaryClassLibraryFilename projectDefinitionFilename
     projectDefinitionClass projectDefinitionClassName silent somethingHasBeenLoaded
     loadOK errorInInitialize|

    packageDirOrStringOrNil notNil ifTrue:[
        packageDirOrNil := packageDirOrStringOrNil asFilename.
    ].
    silent := VerboseLoading not
                and:[SilentLoading or:[StandAlone or:[InfoPrinting not]]].

    "For now: have to read the project definition first!!
     The class library may contain subclasses of classes in prerequisite packages -
     so the prerequisite packages have to be loaded first.
     Normally there is a project definiton, use that one to pull in the rest"

    "maybe, it is already in the image"
    projectDefinitionClass := ProjectDefinition definitionClassForPackage:aPackageString.
    projectDefinitionClass notNil ifTrue:[
        projectDefinitionClass checkForLoad.
    ].

    "Is there a shared library (.dll or .so) ?"
    binaryClassLibraryFilename := ObjectFileLoader
                                    binaryClassFilenameForPackage:aPackageString
                                    inDirectory:packageDirOrNil.

    (binaryClassLibraryFilename notNil and:[binaryClassLibraryFilename exists]) ifTrue:[
        |loadErrorOccurred|

        loadErrorOccurred := false.
        ObjectFileLoader objectFileLoadErrorNotification handle:[:ex |
            loadErrorOccurred := true.
            ex proceedWith:true.
        ] do:[
            loadOK := (ObjectFileLoader loadObjectFile:binaryClassLibraryFilename) notNil.
            "/ loadOK := self loadPackage:aPackageString fromClassLibrary:binaryClassLibraryFilename.
        ].
        (loadOK and:[loadErrorOccurred not]) ifTrue:[
            "now, all compiled classes have been loaded.
             keep classes in the package which are autoloaded as autoloaded."
            ^ true
        ].

        loadErrorOccurred ifTrue:[
            self breakPoint:#cg.
            projectDefinitionClass := ProjectDefinition definitionClassForPackage:aPackageString.
            projectDefinitionClass notNil ifTrue:[
                projectDefinitionClass
                    checkForLoad;
                    loadPreRequisitesAsAutoloaded:doLoadAsAutoloaded.
            ].
        ].
    ].
    packageDirOrNil isNil ifTrue:[
        ^ PackageNotFoundError raiseRequestWith:aPackageString.
    ].

    "fallback - go through the project definition"
    projectDefinitionClass isNil ifTrue:[
        projectDefinitionClassName := ProjectDefinition projectDefinitionClassNameForDefinitionOf:aPackageString.
        "/ try to load the project definition class
        projectDefinitionFilename := (packageDirOrNil / projectDefinitionClassName) withSuffix:'st'.
        projectDefinitionFilename exists ifFalse:[
            projectDefinitionFilename := (packageDirOrNil / 'source' / projectDefinitionClassName) withSuffix:'st'.
        ].
        projectDefinitionFilename exists ifTrue:[
            Class withoutUpdatingChangesDo:[
                Smalltalk silentlyLoadingDo:[
                    Error handle:[:ex |
                        "/ catch error during initialization;
                        ex suspendedContext withAllSendersDo:[:sender |
                            (sender selector == #initialize
                                and:[sender receiver isBehavior
                                and:[sender receiver name = projectDefinitionClassName]]
                            ) ifTrue:[
                                errorInInitialize := true
                            ].
                        ].
                        errorInInitialize ifFalse:[ ex reject ].
                    ] do:[
                        projectDefinitionFilename fileIn.
                    ].
                ].
            ].
            errorInInitialize ifTrue:[
                Transcript showCR:'Smalltalk [warning]: an error happened in #initialize - retry after loading package.'.
            ].
            projectDefinitionClass := ProjectDefinition definitionClassForPackage:aPackageString.
        ].
    ].
    projectDefinitionClass notNil ifTrue:[
        projectDefinitionClass
            autoload;
            checkForLoad;
            loadPreRequisitesAsAutoloaded:doLoadAsAutoloaded.

        somethingHasBeenLoaded := projectDefinitionClass loadAsAutoloaded:doLoadAsAutoloaded.
        errorInInitialize ifTrue:[
            Transcript showCR:('Smalltalk [info]: retrying #initialize').
            projectDefinitionClass initialize.
        ].
        (silent not and:[somethingHasBeenLoaded]) ifTrue:[
            Transcript showCR:('Smalltalk [info]: loaded package: ' , aPackageString , ' from project definition').
        ].
        ^ true.
    ].

    "/ source files-file loading no longer supported
    "/ however, allow for autoload-stub loaded
    doLoadAsAutoloaded ifTrue:[
        self
            recursiveInstallAutoloadedClassesFrom:packageDirOrNil
            rememberIn:Set new
            maxLevels:2
            noAutoload:false
            packageTop:packageDirOrNil
            showSplashInLevels:0.
        ^ true
    ].

    ^ PackageNotFoundError raiseRequestWith:aPackageString errorString:' - no projectDef, dll or loadAll found'.

    "
     Smalltalk loadPackageWithId:'stx:libbasic'
     Smalltalk loadPackageWithId:'stx:goodies/persistency'
     Smalltalk loadPackageWithId:'exept:ctypes'
    "

    "Modified: / 29-07-2011 / 19:55:35 / cg"
!

loadExtensionsForPackage:aPackageId
    | extensionsLoaded |

    extensionsLoaded := false.
    ProgrammingLanguage allDo:[:programmingLanguage|
        "/ evaluating or here - want all extensions to be loaded
        extensionsLoaded := extensionsLoaded | (self loadExtensionsForPackage:aPackageId language: programmingLanguage)
    ].
    ^ extensionsLoaded

    "Modified: / 18-02-2007 / 11:03:26 / cg"
    "Modified: / 02-01-2010 / 10:43:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-09-2011 / 09:19:24 / cg"
!

loadExtensionsForPackage:aPackageId language: programmingLanguage
    |mgr packageDirName inStream projectDefinition extensionsFilename mod dir
     extensionsRevisionString extensionsRevisionInfo|

    programmingLanguage supportsExtensionMethods ifFalse:[^false].

    packageDirName := aPackageId copyReplaceAll:$: with:$/.
    packageDirName := self getPackageFileName:packageDirName.

    (packageDirName notNil and:[Class tryLocalSourceFirst]) ifTrue:[
        (self loadExtensionsFromDirectory:packageDirName language: programmingLanguage) ifTrue:[
            ^ true.
        ].
        packageDirName := nil.  "do not try again"
    ].

    "
     if there is a sourceCodeManager, ask it first for the extensions
    "
    (Smalltalk at:#AbstractSourceCodeManager) notNil ifTrue:[
        mgr := AbstractSourceCodeManager managerForPackage: aPackageId
    ].
    mgr notNil ifTrue:[
        extensionsFilename := 'extensions.' , programmingLanguage sourceFileSuffix.

        projectDefinition := ProjectDefinition definitionClassForPackage:aPackageId.
        projectDefinition notNil ifTrue:[
            mod := aPackageId asPackageId module.
            dir := aPackageId asPackageId directory.
            extensionsRevisionString := projectDefinition perform:(mgr nameOfVersionMethodForExtensions) ifNotUnderstood:nil.
            extensionsRevisionString notNil ifTrue:[
                extensionsRevisionInfo := mgr revisionInfoFromString:extensionsRevisionString inClass:nil.
                extensionsRevisionInfo notNil ifTrue:[
                    extensionsRevisionInfo fileName = extensionsFilename ifFalse:[
                        "JV@2011-10-23: following condition is never satisfied for
                         filed-in packages. The whole scheme of extensionVersion_XXX
                         works ONLY for compiled packages as it depends on fact, that
                         extension Init() routine is called AFTER all classes are inited,
                         therefore the extensionVersion_XXX methods from extensions.st
                         overwrites methods coming from package definition class. All this
                         is so tricky and error prone, that we have to come up with better
                         solution!!"
                        packageDirName notNil ifTrue:[
                            ^ self loadExtensionsFromDirectory:packageDirName language: programmingLanguage
                        ] ifFalse:[
                            ^ false
                        ]
                    ]
                ]
            ].
            SourceCodeManagerError handle:[:ex |
            ] do:[
                inStream := mgr streamForExtensionFile:extensionsFilename package:aPackageId directory:dir module:mod cache:true.
            ].
        ].
        inStream isNil ifTrue:[
            SourceCodeManagerError handle:[:ex |
            ] do:[
                inStream := mgr getMostRecentSourceStreamForFile:extensionsFilename inPackage:aPackageId.
            ].
        ].
        inStream notNil ifTrue:[
            Class withoutUpdatingChangeSetDo:[
                inStream fileIn.
            ].
            inStream close.
            VerboseLoading ifTrue:[
                Transcript showCR:('loaded extensions for ',aPackageId,' from repository').
            ].
            ^ true
        ]
    ].

    packageDirName notNil ifTrue:[
        ^ self loadExtensionsFromDirectory:packageDirName language: programmingLanguage
    ].
    ^ false

    "Created: / 02-01-2010 / 10:41:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2011 / 10:03:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-11-2011 / 13:41:29 / cg"
    "Modified: / 23-10-2011 / 19:35:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadExtensionsFromDirectory:packageDirOrString
    | extensionsLoaded |

    extensionsLoaded := false.
    ProgrammingLanguage allDo:[:programmingLanguage|
        "/ evaluating or here - want all extensions to be loaded
        extensionsLoaded := extensionsLoaded | (self loadExtensionsFromDirectory: packageDirOrString language: programmingLanguage)
    ].
    ^ extensionsLoaded

    "Modified: / 02-01-2010 / 10:40:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadExtensionsFromDirectory:packageDirOrString language: language
    |packageDir f|

    packageDir := packageDirOrString asFilename.

    f := packageDir / ('extensions.' , language sourceFileSuffix).
    f exists ifTrue:[
	Class withoutUpdatingChangeSetDo:[
	    f fileIn.
	].
	VerboseLoading ifTrue:[
	    Transcript showCR:('loaded extensions: ' , f pathName).
	].
	^ true
    ].
    ^ true"/false

    "Created: / 02-01-2010 / 10:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-11-2011 / 13:41:19 / cg"
    "Modified: / 31-01-2013 / 11:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadPackage:aPackageStringArg asAutoloaded:doLoadAsAutoloaded
    "make certain, that some particular package is loaded into the system.
     Return true on success, false otherwise."

    |packageId packageString packageDir def sourceCodeManager|

    packageString := aPackageStringArg.

    "/ a little convenience: so you can stx packages with loadPackage:'goodies/soap'
    (packageString includes:$:) ifFalse:[
        packageString := 'stx:',packageString.
    ].

    "if I am here, so must my package"
    packageString = self package ifTrue:[^ true].

    packageId := aPackageStringArg asPackageId.

    "/ if there is a projectDefinition, let it load itself...
    def := packageId projectDefinitionClass.
    (def notNil and:[def isLoaded]) ifTrue:[
        def loadAsAutoloaded:doLoadAsAutoloaded.
        ^ true.
    ].

    packageDir := self getPackageDirectoryForPackage:packageId.

    [
        self
            loadPackage:packageString
            fromDirectory:packageDir
            asAutoloaded:doLoadAsAutoloaded.
    ] on:PackageLoadError do:[:ex|
        ex creator ~~ PackageNotCompatibleError ifTrue:[
            AbstractSourceCodeManager notNil ifTrue:[
                sourceCodeManager := AbstractSourceCodeManager sourceCodeManagerForPackage:packageString.
                sourceCodeManager notNil ifTrue:[
                    PackageLoadError handle:[:ex2 |
                        ex reject
                    ] do:[
                        ^ sourceCodeManager loadPackageWithId:packageString fromRepositoryAsAutoloaded:doLoadAsAutoloaded
                    ].
                ].
            ].
        ].
        ex reject.
    ].

    ^ true

    "
     Smalltalk loadPackageWithId:'stx:libbasic'
     Smalltalk loadPackageWithId:'stx:goodies/persistency'
     Smalltalk loadPackageWithId:'exept:ctypes'
    "

    "Modified: / 16-11-2010 / 17:42:49 / cg"
    "Modified: / 28-06-2016 / 07:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadPackage:packageId fromAllSourceFilesInDirectory:aDirectory
    "load all source files found in aDirectory and treat them like
     a package. Allows for initial import of alien ST-code as a new package.
     Experimental."

    |p t new anyFail repeatCount|

    "/ problem: dependencies.
    "/ solution: repeat twice, so that superclasses are present the second time

    Class packageQuerySignal answer:packageId asSymbol do:[
	|any|

	repeatCount := 0.
	[
	    repeatCount := repeatCount + 1.
	    anyFail := false.
	    aDirectory directoryContents do:[:file |
		|fn|

		fn := aDirectory / file.
		(fn hasSuffix:'st') ifTrue:[
		    Metaclass confirmationQuerySignal answer:false
		    do:[
			Error
			    handle:[:ex |
				anyFail := true
			    ]
			    do:[
				(self fileIn:fn) ifFalse:[
				    anyFail := true
				] ifTrue:[
				    any := true.
				]
			    ]
		    ]
		]
	    ].
	    any ifFalse:[
		^ false "/ no file found
	    ]
	] doWhile:[anyFail and:[repeatCount<2]].
    ].

    new := (p := Project projectWithId:packageId) isNil.
    new ifTrue:[ p := Project new].

    p name:packageId.
    p directory:aDirectory.
    p package:packageId.
    t := packageId asCollectionOfSubstringsSeparatedByAny:'/\:'.
    p repositoryModule:(t first).
    p repositoryDirectory:(packageId copyFrom:t first size + 2).
    p isLoaded:true.

    new ifTrue:[Project addLoadedProject:p].
    anyFail ifTrue:[
	^ PackageLoadError raiseRequestWith:packageId.
    ].
    ^ true
!

loadPackage:packageId fromClassLibrary:aFilename
    "load a package from a compiled classLib.
     Experimental."

    |p t new|

    (self fileIn:aFilename) ifFalse:[
	(self fileInClassLibrary:aFilename) ifFalse:[
	    ^ false.
	]
    ].

    new := (p := Project projectWithId:packageId) isNil.
    new ifTrue:[ p := Project new].

    p name:packageId.
    p directory:aFilename directory.
    p package:packageId.
    t := packageId asCollectionOfSubstringsSeparatedByAny:'/\:'.
    p repositoryModule:(t first).
    p repositoryDirectory:(packageId copyFrom:t first size + 2).
    p isLoaded:true.

    new ifTrue:[Project addLoadedProject:p].

    ^ true
!

loadPackage:aPackageString fromDirectory:packageDirOrStringOrNil asAutoloaded:doLoadAsAutoloaded
    "load a package referenced by aPackageString - a string like 'stx:libbasic'.
     The package is either located in packageDirOrStringOrNil, or in the current directory (if nil).
     Answer true, if the load succeeded, false if it failed"

    |ret|

    PackageLoadInProgressQuery
	answerNotifyLoading:aPackageString asSymbol
	do:[
	    ret := self basicLoadPackage:aPackageString fromDirectory:packageDirOrStringOrNil asAutoloaded:doLoadAsAutoloaded
	].
    ^ ret

    "
     Smalltalk loadPackage:'stx:goodies/communication'
    "
!

loadPackage:packageId fromLoadAllFile:aFilename
    <resource: #obsolete>
    "load a package from a loadAll - loader script.
     Experimental."

    |p t new|

    Metaclass confirmationQuerySignal answer:false
    do:[
	(self fileIn:aFilename) ifFalse:[
	    self warn:'Failed to load the package ', packageId printString.
	    ^ false.
	]
    ].

    new := (p := Project projectWithId:packageId) isNil.
    new ifTrue:[ p := Project new].

    p name:packageId.
    p directory:aFilename directory.
    p package:packageId.
    t := packageId asCollectionOfSubstringsSeparatedByAny:'/\:'.
    p repositoryModule:(t first).
    p repositoryDirectory:(packageId copyFrom:t first size + 2).
    p isLoaded:true.

    new ifTrue:[Project addLoadedProject:p].
    ^ true
!

loadPackage:aPackageId fromZIPArchive:f asAutoloaded:doLoadAsAutoloaded
    "load a package from a .zip delivery file.
     Experimental."

    PackageLoadError
        raiseWith:aPackageId
        errorString:' - package loading from zip is not yet implemented'.
!

loadPackageFromAbbrevFile:aPackageId asAutoloaded:doLoadAsAutoloaded
    <resource: #obsolete>
    |abbrevFile packageDir|

    packageDir := self getPackageDirectoryForPackage:aPackageId.
    packageDir isNil ifTrue:[^ false].

    "/ abbrev.stc ?
    abbrevFile := packageDir / 'abbrev.stc'.
    abbrevFile exists ifFalse:[^ false].

    Smalltalk installAutoloadedClassesFrom:abbrevFile pathName.

    doLoadAsAutoloaded ifFalse:[
        "/ force autoloading...
        Smalltalk allClassesInPackage:aPackageId do:[:eachClass | eachClass autoload].
    ].

    self loadExtensionsFromDirectory:packageDir.
    VerboseLoading ifTrue:[
        Transcript showCR:('Smalltalk [info]: loaded package: ' , aPackageId , ' from abbrev file: ' , abbrevFile pathName).
    ].
    ^ true

    "Modified: / 04-11-2011 / 13:43:29 / cg"
    "Modified: / 28-06-2016 / 07:52:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Smalltalk class methodsFor:'queries'!

allClasses
    "return an unordered collection of all classes in the system.
     Only globally anchored classes are returned
     (i.e. anonymous ones have to be acquired by Behavior allSubInstances)"

    |classes|

    "/ you may wonder, what this while is for, here ...
    "/ the reason is that if we modify the class hierarchy in
    "/ another view (background fileIn), while building up the
    "/ cachedClasses set, this may be flushed (invalidated) by the
    "/ other process in the meanwhile.
    "/ If that happens, we restart the set-building here
    "/
    [(classes := CachedClasses) isNil] whileTrue:[
        CachedClasses := classes := IdentitySet new:NumberOfClassesHint.
        self keysAndValuesDo:[:eachName :eachGlobal |
            (eachGlobal notNil and:[eachGlobal isBehavior]) ifTrue:[
                "/ sigh - would like to skip over aliases
                "/ but this cannot be done simply by comparing
                "/ the classes name against the store-key
                "/ i.e. cannot do:
                "/      anObject name == sym ifTrue:[
                "/          classes add:anObject
                "/      ]
                "/ because that would lead to ignore all java
                "/ classes, which are stored under a different
                "/ key.

                (eachGlobal name == eachName
                 or:[eachGlobal isJavaClass]) ifTrue:[
                    classes add:eachGlobal
                ].
            ]
        ].
        NumberOfClassesHint := classes size.
    ].
    ^ classes

    "
     CachedClasses := nil.
     Smalltalk allClasses

    to get the list sorted by name:

     Smalltalk allClasses asSortedCollection:[:a :b | a name < b name]
    "

    "Modified: / 06-12-2011 / 12:41:42 / cg"
!

allClassesAndMetaclasses
    "return an unordered collection of all classes with their metaclasses in the system."

    |classes|

    classes := IdentitySet new:NumberOfClassesHint*2.
    self allClassesDo:[:eachClass |
	classes add:(eachClass theNonMetaclass).
	classes add:(eachClass theMetaclass).
    ].
    ^ classes
!

allClassesWithAllPrivateClasses
    "return an unordered collection of all classes in the Smalltalk namespace.
     Only globally anchored classes are returned; Namespaces are not included.
     (i.e. anonymous ones have to be acquired by Behavior allSubInstances)"

    ^ self allClasses select:[:aClass |
            |owner|

            (aClass isRealNameSpace not)
            and:[
                owner := aClass topOwningClass.
                (owner ? aClass) nameSpace == Smalltalk
            ]
      ]

    "
     Smalltalk allClassesWithAllPrivateClasses
    "

    "Modified: / 10-11-2006 / 17:24:00 / cg"
!

allExtensions
    "return a collection of all extension methods (methods added from another package)"

    |methods|

    methods := OrderedCollection new.
    self allClassesDo:[:eachClass |
	|classPackage|

	classPackage := eachClass package.
	eachClass instAndClassMethodsDo:[:mthd |
	    mthd package ~= classPackage ifTrue:[ methods add:mthd ].
	].
    ].
    ^ methods

    "
     Smalltalk allExtensions
    "
!

allExtensionsForPackage:aProjectID
    "return a collection of all extension methods for a given projectID"

    |methods|

    methods := OrderedCollection new.
    self allClassesDo:[:eachClass |
	methods addAll:(eachClass extensionsFrom:aProjectID).
    ].
    ^ methods
!

allImplementorsOf:aSelector
    "return a collection of classes which implement the given selector"

    |implementors|

    implementors := OrderedCollection new.
    self allImplementorsOf:aSelector do:[:cls | implementors add:cls].
    ^ implementors

    "
     Smalltalk allImplementorsOf:#isNil
     (Smalltalk allImplementorsOf:#add:) size
    "

    "Modified: / 30-04-2016 / 17:37:39 / cg"
!

allImplementorsOf:aSelector do:aBlock
    "enumerate all classes which implement the given selector"

    self allClassesDo:[:cls |
        (cls includesSelector:aSelector) ifTrue:[
            aBlock value:cls.
        ].
        (cls class includesSelector:aSelector) ifTrue:[
            aBlock value:cls class.
        ].
    ].

    "
     Smalltalk allImplementorsOf:#isNil do:[:cls | Transcript showCR:cls]
     Smalltalk allImplementorsOf:#add: do:[:cls | Transcript showCR:cls]
    "

    "Created: / 30-04-2016 / 17:36:45 / cg"
!

allLoadedPackageIDs

    ^ self allPackageIdsIncludingUnloadedClasses: false


    "
     Smalltalk allLoadedPackageIDs
    "
!

allLoadedProjectIDs
    <resource: #obsolete>
    self obsoleteMethodWarning:'use allLoadedPackageIDs'.
    ^ self allPackageIdsIncludingUnloadedClasses: false


    "
     Smalltalk allLoadedProjectIDs
    "
!

allPackageIDs

    ^ self allPackageIdsIncludingUnloadedClasses: true

    "
     Smalltalk allPackageIDs
    "
!

allPackageIdsIncludingUnloadedClasses: includeUnloadedClasses
    "Returns all package ids.
     Excludes packages coming from unloaded classes if includeUnloadedClasses is false.
    "

    |allProjects|

    allProjects := Set new.
    self allClassesDo:[:eachClass |
        |cls pkg|

        eachClass isRealNameSpace ifFalse:[
            (includeUnloadedClasses or:[eachClass isLoaded]) ifTrue:[
                cls := eachClass theNonMetaclass.
                cls isPrivate ifTrue:[
                    cls := cls topOwningClass
                ].
                pkg := cls package.
                pkg size > 0 ifTrue:[
                    allProjects add:pkg.
                ] ifFalse:[
                    "/ for now, nameSpaces are not in any package;
                    "/ this might change. Then, 0-sized packages are
                    "/ illegal, and the following should be enabled.
                    "/ self halt
                ].
                cls isJavaClass ifFalse:[
                    cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
			| package packageAsSymbol |

			package := mthd package.
			packageAsSymbol := package asSymbol.
			allProjects add: packageAsSymbol
                    ].
                ].
            ].
        ].
    ].
    allProjects := allProjects asOrderedCollection sort.
    ^ allProjects

    "
     Smalltalk allProjectsIdsIncludingUnloadedClasses: true
     Smalltalk allProjectsIdsIncludingUnloadedClasses: false
    "
!

allProjectIDs
    <resource: #obsolete>
    self obsoleteMethodWarning:'use allPackageIDs'.
    ^ self allPackageIDs

    "
     Smalltalk allProjectIDs
    "
!

allProjectsIdsIncludingUnloadedClasses: includeUnloadedClasses
    <resource: #obsolete>
    "Returns all projects ids.
     Excludes projects coming from unloaded classes if includeUnloadedClasses is false.
    "

    self obsoleteMethodWarning:'use allPackageIdsIncludingUnloadedClasses:'.
    ^ self allPackageIdsIncludingUnloadedClasses: includeUnloadedClasses

    "
     Smalltalk allProjectsIdsIncludingUnloadedClasses: true
     Smalltalk allProjectsIdsIncludingUnloadedClasses: false
    "
!

cellAt:aName
    "{ Pragma: +optSpace }"

    "return the address of a global cell
     - used internally for compiler only"

%{  /* NOCONTEXT */
    RETURN ( __GLOBAL_GETCELL(aName) );
%}.
    ^ self primitiveFailed

!

classCategoryCompletion:aPartialCategory
    "given a partial class category name, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching categories"

    ^ DoWhatIMeanSupport classCategoryCompletion:aPartialCategory inEnvironment:self

    "
     Smalltalk classCategoryCompletion:'Sys'
     Smalltalk classCategoryCompletion:'System'
     Smalltalk classCategoryCompletion:'System-BinaryStorage'
    "

    "Modified: / 10-08-2006 / 13:06:34 / cg"
!

classNamed:aString
    "return the class with name aString, or nil if absent.
     To get to the metaClass, append ' class' to the string.
     To get a nameSpace or private class, prefix the name as required.
     If a private class of an autoloaded class is referenced, the owning class
     will be loaded."

    |cls sym nonMeta idx prefix rest namespace nsNameSymbol|

    "Quick try - if everything is loaded, this will succeed.
     But be careful, to not invent new symbols ..."
    sym := aString asSymbolIfInterned.
    sym notNil ifTrue:[
        cls := self at:sym ifAbsent:nil.
        cls isBehavior ifTrue:[^ cls].
    ].

    (aString endsWith:' class') ifTrue:[
        nonMeta := self classNamed:(aString copyButLast:6).
        nonMeta notNil ifTrue:[
            ^ nonMeta theMetaclass
        ].
        ^ nil.
    ].

    "no success yet. Try if this is a private class of an autoloaded class"
    cls isNil ifTrue:[
        idx := aString indexOfSubCollection:'::'.
        idx ~~ 0 ifTrue:[
            prefix := aString copyTo:idx-1.
            nsNameSymbol := prefix asSymbolIfInterned.
            nsNameSymbol notNil ifTrue:[
                rest := aString copyFrom:idx+2.
                namespace := self at:prefix asSymbolIfInterned ifAbsent:nil.
                "namespace may be the owner of a private class.
                 NameSpaces and Behaviors have the same protocol"
                [namespace isBehavior] whileTrue:[
                    idx := rest indexOfSubCollection:'::'.
                    idx ~~ 0 ifTrue:[
                        prefix := rest copyTo:idx-1.
                        rest := rest copyFrom:idx+2.
                        "this does an implicit autoload if required"
                        namespace := namespace privateClassesAt:prefix.
                    ] ifFalse:[
                        namespace isLoaded ifTrue:[
                            cls := namespace privateClassesAt:rest.
                            cls isBehavior ifTrue:[^ cls].
                        ].
                        namespace := nil.   "force exit of loop"
                    ].
                ].
            ].
        ].
    ].

    ^ nil

    "
     Smalltalk classNamed:'Object'
     Smalltalk classNamed:'Authentication::BasicAuthenticator::BasicAuthenticationData'
     Smalltalk classNamed:'Authentication::BasicAuthenticator::BasicAuthenticationData class'
     Smalltalk classNamed:'Authentication::BasicAuthenticator'
     Smalltalk classNamed:'fooBar'
     Smalltalk classNamed:'true'
     Smalltalk classNamed:'Object class'
     Smalltalk classNamed:'Metaclass'
     Smalltalk classNamed:'Array'
     Smalltalk classNamed:'Array class'
    "

    "Created: / 24-11-1995 / 17:30:22 / cg"
    "Modified: / 19-06-1996 / 14:22:21 / stefan"
    "Modified: / 23-10-2006 / 18:06:53 / cg"
    "Modified (comment): / 20-08-2011 / 16:43:07 / cg"
!

classNames
    "return a collection of all classNames in the system"

    ^ self allClasses collect:[:aClass | aClass name]

    "
     Smalltalk classNames
    "
!

classnameCompletion:aPartialClassName
    "given a partial classname, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    ^ DoWhatIMeanSupport classnameCompletion:aPartialClassName inEnvironment:self
!

classnameCompletion:aPartialClassName inEnvironment:anEnvironment
    "given a partial classname, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    ^ DoWhatIMeanSupport classnameCompletion:aPartialClassName inEnvironment:anEnvironment

    "
     Smalltalk classnameCompletion:'Arr'
     Smalltalk classnameCompletion:'Arra'
     Smalltalk classnameCompletion:'arra'
     Smalltalk classnameCompletion:'*rray'

     Smalltalk classnameCompletion:'Arr cl'
     Smalltalk classnameCompletion:'*rray cl'
    "

    "Created: 24.11.1995 / 17:24:45 / cg"
    "Modified: 3.4.1997 / 18:25:01 / cg"
!

defaultNameSpace
    "return the default namespace, where new classes are installed,
     if NO special nameSpace handler is present"

    ^ Project defaultNameSpace.

    "Created: / 19-12-1996 / 23:49:25 / cg"
    "Modified: / 17-08-2006 / 14:01:22 / cg"
!

globalNameCompletion:aPartialGlobalName
    "given a partial globalName, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    ^ DoWhatIMeanSupport globalNameCompletion:aPartialGlobalName inEnvironment:self match:true

    "
     Smalltalk globalnameCompletion:'Arr'
     Smalltalk globalnameCompletion:'Arra'
     Smalltalk globalnameCompletion:'arra'
     Smalltalk globalnameCompletion:'*rray'
    "

    "Created: / 24-11-1995 / 17:24:45 / cg"
    "Modified: / 10-08-2006 / 13:05:39 / cg"
!

globalnameCompletion:aPartialGlobalName
    "given a partial globalName, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching names"

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #globalNameCompletion:'.
    ^ DoWhatIMeanSupport globalNameCompletion:aPartialGlobalName inEnvironment:self

    "
     Smalltalk globalnameCompletion:'Arr'
     Smalltalk globalnameCompletion:'Arra'
     Smalltalk globalnameCompletion:'arra'
     Smalltalk globalnameCompletion:'*rray'
    "

    "Created: / 24-11-1995 / 17:24:45 / cg"
    "Modified: / 10-08-2006 / 13:05:48 / cg"
!

hasClassNamed:aString
    Symbol
	hasInterned:aString
	ifTrue:[:aSymbol | ^ (self at:aSymbol ifAbsent:[ nil ]) isClass ].
    ^ false

    "Created: / 26-08-2009 / 11:43:03 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
    "Modified: / 20-08-2011 / 16:41:31 / cg"
!

hasNameSpaces
    "can be redefined by dummy namespaces/environments, to suppress
     the namespace display in a browser (PocketSmalltalk)"

    ^ true
!

hasNamespaces
    "can be redefined by dummy namespaces/environments, to suppress
     the namespace display in a browser (PocketSmalltalk)"

    <resource:#obsolete>
    ^ true
!

hasSelectorNameSpaces
    "for now return false
     Selector namespaces are being implemented and supported by the VM,
     but not yet fully supported by all tools...
     Therefore, for now, do not generate code which uses this feature."

    ^ false

    "Created: / 05-03-2007 / 13:26:28 / cg"
!

includes:something
    "this should come from Collection.
     will change the inheritance - Smalltalk is actually a collection"

    self do:[:element | element = something ifTrue:[^ true]].
    ^ false
!

includesIdentical:something
    "this should come from Collection.
     will change the inheritance - Smalltalk is actually a collection"

    self do:[:element | element == something ifTrue:[^ true]].
    ^ false
!

isBrowserStartable
    ^ false.

    "Created: / 06-10-2006 / 11:46:52 / cg"
!

isNameSpace
    "return true, if the receiver is a nameSpace."

    ^ true

    "Created: 11.10.1996 / 18:10:43 / cg"
!

isRealNameSpace
    "return true, if the receiver is a nameSpace, but not Smalltalk (which is also a class)."

    ^ false

    "Created: / 10-11-2006 / 17:02:19 / cg"
!

isTopLevelNameSpace
    ^ true
!

isTopLevelNamespace
    "obsolete - use isTopLevelNameSpace"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #isTopLevelNameSpace'.
    ^ true

    "Created: 11.10.1996 / 18:10:43 / cg"
!

keyIsClassVariableNameKey:aKey
    |i|

    i := aKey lastIndexOf:$:.
    i ~~ 0 ifTrue:[
	i > 1 ifTrue:[
	    (aKey at:(i-1)) == $: ifFalse:[
		^ true.
	    ].
	].
    ].
    ^ false.

    "
     self keyIsClassVariableNameKey:'foo::bar'
     self keyIsClassVariableNameKey:'foo:bar'
     self keyIsClassVariableNameKey:':bar'
     self keyIsClassVariableNameKey:'::bar'
    "
!

loadedClassNamed:aString
    "Same as #classNamed,
     but a private class of an autoloaded class will not be found."

    |cls sym nonMeta|

    "Quick try - if everything is loaded, this will succeed.
     But be careful, to not invent new symbols ..."
    sym := aString asSymbolIfInterned.
    sym notNil ifTrue:[
	cls := self at:sym ifAbsent:nil.
	cls isBehavior ifTrue:[^ cls].
    ].

    (aString endsWith:' class') ifTrue:[
	nonMeta := self loadedClassNamed:(aString copyButLast:6).
	nonMeta notNil ifTrue:[
	    ^ nonMeta theMetaclass
	].
    ].
    ^ nil

    "
     Smalltalk loadedClassNamed:'Object'
     Smalltalk loadedClassNamed:'Authentication::BasicAuthenticator::BasicAuthenticationData'
     Smalltalk loadedClassNamed:'Authentication::BasicAuthenticator::BasicAuthenticationData class'
     Smalltalk loadedClassNamed:'Authentication::BasicAuthenticator'
     Smalltalk loadedClassNamed:'fooBar'
     Smalltalk loadedClassNamed:'true'
     Smalltalk loadedClassNamed:'Object class'
     Smalltalk loadedClassNamed:'Metaclass'
     Smalltalk loadedClassNamed:'Array'
     Smalltalk loadedClassNamed:'Array class'
    "
!

methodProtocolCompletion:aPartialProtocolName
    "given a partial method protocol name, return an array consisting of
     2 entries: 1st: the best (longest) match
		2nd: collection consisting of matching protocols"

    ^ DoWhatIMeanSupport methodProtocolCompletion:aPartialProtocolName inEnvironment:self

    "
     Smalltalk methodProtocolCompletion:'doc'
     Smalltalk methodProtocolCompletion:'docu'
     Smalltalk methodProtocolCompletion:'documenta'
    "

    "Modified: / 10-08-2006 / 13:05:20 / cg"
!

numberOfGlobals
    "return the number of global variables in the system"

    |tally "{ Class: SmallInteger }" |

    tally := 0.
    self do:[:obj | tally := tally + 1].
    ^ tally

    "Smalltalk numberOfGlobals"
!

referencesAny:aCollection
    "redefined, since the references are only kept in the VM's symbol table"

    self keysAndValuesDo:[:key :val |
	aCollection do:[:anObject |
	    (key == anObject) ifTrue:[^ true].
	    (val == anObject ) ifTrue:[^ true].
	]
    ].
    ^ super referencesAny:aCollection

    "Created: / 2.2.1998 / 16:01:20 / cg"
!

referencesDerivedInstanceOf:aClass
    "redefined, since the references are only kept in the VM's symbol table"

    self keysAndValuesDo:[:key :val |
	(key isKindOf:aClass) ifTrue:[^ true].
	(val isKindOf:aClass) ifTrue:[^ true].
    ].
    ^ super referencesDerivedInstanceOf:aClass
!

referencesInstanceOf:aClass
    "redefined, since the references are only kept in the VM's symbol table"

    self keysAndValuesDo:[:key :val |
	(key isMemberOf:aClass) ifTrue:[^ true].
	(val isMemberOf:aClass) ifTrue:[^ true].
    ].
    ^ super referencesInstanceOf:aClass
!

referencesObject:anObject
    "redefined, since the references are only kept in the VM's symbol table"

    self keysAndValuesDo:[:key :val |
	(key == anObject) ifTrue:[^ true].
	(val == anObject ) ifTrue:[^ true].
    ].
    ^ super referencesObject:anObject

    "Modified: / 3.2.1998 / 14:22:46 / cg"
!

resolveName:aName inClass:aClass
    "resolve aName as if compiled within aClass;
     i.e. if it has a private class with this name, return it;
     if aName is known within the classes namespace, return that.
     Otherwise, return a global with that name.
     This should be used whereever Smalltalk>>at: used to be used,
     to resolve a global by name."

    |nameUsed sym cls ns|

    aName isNil ifTrue:[^ nil].
    aName isBehavior ifTrue:[^ aName].       "/ already resolved
    nameUsed := aName.

    (nameUsed startsWith:'Smalltalk::') ifTrue:[
	nameUsed := nameUsed copyFrom:12.
	^ self at:(nameUsed asSymbol) ifAbsent:nil.
    ].

    sym := nameUsed asSymbol.

    cls := aClass privateClassesAt:sym.
    cls notNil ifTrue:[^ cls].

    ns := aClass nameSpace.
    (ns notNil and:[ns ~~ Smalltalk]) ifTrue:[
	ns isNameSpace ifTrue:[
	    cls := ns at:sym ifAbsent:nil.
	] ifFalse:[
	    cls := ns privateClassesAt:sym
	].
	cls notNil ifTrue:[^ cls].
    ].
    ^ self at:sym ifAbsent:nil.

    "Modified: / 9.7.1999 / 01:18:07 / cg"
!

selectorCompletion:aPartialSymbolName
    "given a partial selector, return an array consisting of
     2 entries: 1st: the longest match
		2nd: collection consisting of matching implemented selectors"

    ^ DoWhatIMeanSupport selectorCompletion:aPartialSymbolName inEnvironment:self
!

selectorCompletion:aPartialSymbolName inEnvironment:anEnvironment
    "given a partial selector, return an array consisting of
     2 entries: 1st: the longest match
		2nd: collection consisting of matching implemented selectors"

    ^ DoWhatIMeanSupport selectorCompletion:aPartialSymbolName inEnvironment:anEnvironment

    "
     Smalltalk selectorCompletion:'at:p'
     Smalltalk selectorCompletion:'nextP'
     Smalltalk selectorCompletion:'nextp'
    "

    "Modified: / 7.6.1996 / 08:44:33 / stefan"
    "Modified: / 14.6.1998 / 15:54:03 / cg"
!

size
    "Return the number of globals"

%{  /* NOCONTEXT */
    return ( __MKINT( __GLOBALS_SIZE() ) );
%}.
    self primitiveFailed.

    "Created: / 03-07-2017 / 21:47:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

someImplementorOf:aSelector
    "return any class, which implement the given selector. Nil if there is none.
     (useful to search, if there is one at all)"

    self allImplementorsOf:aSelector do:[:cls | ^ cls].
    ^ nil.

    "
     Smalltalk someImplementorOf:#isNil
     Smalltalk someImplementorOf:#add:
    "

    "Created: / 30-04-2016 / 17:39:19 / cg"
! !

!Smalltalk class methodsFor:'queries-system'!

isAmber
    "is this an Amber Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isAmber to your Amber Smalltalk,
     returning true there."

    ^ false

    "Created: / 18-12-2013 / 15:43:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDolphinSmalltalk
    "is this a Dolphin Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isDolphinSmalltalk to your dolphin,
     returning true there."

    ^ false
!

isGemStone
    "is this a GemStone Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isGemStone to your GemStone/S,
     returning true there."

    ^ false

    "Created: / 18-12-2013 / 15:43:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPharo
    "is this a Pharo Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isPharo to your Pharo,
     returning true there."

    ^ false

    "Created: / 18-12-2013 / 15:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSmalltalkMT
    "is this a Smalltalk-MT system ?
     Return false here - this may be useful to write portable
     applications - add #isSmalltalkMT to your smalltalk-MT,
     returning true there."

    ^ false
!

isSmalltalkV
    "is this a Smalltalk/V system ?
     Return false here - this may be useful to write portable
     applications - add #isSmalltalkV to your smalltalkV,
     returning true there."

    ^ false
!

isSmalltalkX
    "is this a Smalltalk/X system ?
     Return true here - this may be useful to write portable
     applications - add #isSmalltalkX to your other smalltalks,
     returning false there."

    ^ true
!

isSqueak
    "is this a SqueakSmalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isSqueak to your squeak,
     returning true there."

    ^ false
!

isSqueakLike
    "is this a Squeak, Pharo, Cuis or similar Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isSqueakLike to your squeak, pharo,...
     returning true there."

    ^ false
!

isVisualAge
    "is this a VisualAge Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isVisualAge to your visualAge,
     returning true there."

    ^ false
!

isVisualSmalltalkEnterprise
    "is this a VSE Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isVisualSmallalkEnterprise to your VSE,
     returning true there."

    ^ false
!

isVisualWorks
    "is this a VisualWorks Smalltalk system ?
     Return false here - this may be useful to write portable
     applications - add #isVisualWorks to your visualWorks,
     returning true there."

    ^ false
! !

!Smalltalk class methodsFor:'startup'!

browserWindowStartup
    "invoked, when st/x is started as a plugin in a (currently firefox) browser.
     In contrast to squeak (where a single window is used to show the display bitmap),
     the browser window is used as a pseudo root-window for a single aplication window.
     If required, that app must ensure that multiple apps (if any) are setup as a
     multiwindow application.
     Actually, control is transferred to PluginSupport, which is suppoesed to know what to do"

    |windowIDString numericWindowID windowID params idx process|

    idx := CommandLineArguments indexOf:'--browserWindow:'.
    windowIDString := CommandLineArguments at:idx+1.
    numericWindowID := Integer fromString:windowIDString.
    windowID := ExternalAddress newAddress:numericWindowID.

    idx := CommandLineArguments indexOf:'--browserParameters:'.
    idx ~~ 0 ifTrue:[
	params := Dictionary new.
	(CommandLineArguments copyFrom:idx+1) pairWiseDo:[:key :value |
	    params at:key put:value.
	].
    ].

    'browserWindow is: ' errorPrint. windowID errorPrintCR.
    'browserParameters are: ' errorPrint. params errorPrintCR.
    'Display is: ' errorPrint. Display errorPrintCR.

    process := [
	PluginSupport
	    startInBrowserWithWindowID:windowID
	    parameters:params.
    ] newProcess.
    process priority:(Processor userSchedulingPriority).
    process name:'browser start handler'.
    process beGroupLeader.
    process resume.
    process := nil.

    Processor dispatchLoop.
    Smalltalk exit.

    "Modified: / 11-09-2010 / 14:06:59 / cg"
!

defineCommandLineAsWorkspaceVariablesForScripts
    "/ enable this, so we can provide _$1.._$n in the script
    ParserFlags allowUnderscoreInIdentifier:true.
    ParserFlags allowDollarInIdentifier:true.
    ParserFlags warnDollarInIdentifier:false.
    ParserFlags warnUnderscoreInIdentifier:false.
    ParserFlags allowOldStyleAssignment:false.

    "/ add bindings for arguments
    Workspace workspaceVariableAt:('_$0') put:CommandName.
    Workspace workspaceVariableAt:('_$n') put:CommandLineArguments size.
    Workspace workspaceVariableAt:('_$$') put:CommandLineArguments.
    CommandLineArguments doWithIndex:[:arg :i |
        Workspace workspaceVariableAt:('_$',i printString) put:arg.
    ].
!

displayInitializationDone
    "inform the restart, that the display has been initialized"

    CallbackSignal raiseRequest.
!

executeStartBlocks
    |startBlocks|

    startBlocks := self startBlocks.
    startBlocks notNil ifTrue:[
        Logger info: 'Executing start blocks'.
        startBlocks copy do:[:aBlock|
            startBlocks remove: aBlock.
            aBlock on: Error do:[:ex |
                Logger error: 'Error when executing start block: %1' with: ex description.
                InfoPrinting == true ifTrue:[
                    ex description infoPrintCR.
                    ex infoPrintCR.
                    thisContext fullPrintAll.
                ].
            ]
        ].
    ].

    "Created: / 07-01-2012 / 12:58:39 / cg"
    "Modified: / 18-01-2017 / 22:45:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hideSplashWindow
%{
#ifdef WIN32
    extern void __win32_hideSplashScreen();

    __win32_hideSplashScreen();
#endif
%}
!

lateOpenDisplay
    "this is called when a view is opened without a display being already opened."

    Smalltalk openDisplay.
    Display notNil ifTrue:[
        IsRepl ifFalse:[
            Display exitOnLastClose:true.
        ].
        "/ Processor exitWhenNoMoreUserProcesses:true.
    ].
!

mainStartup:graphicalMode
    "common start/restart action, if there is a Display, initialize it
     and start dispatching; otherwise go into a read-eval-print loop."

    |process imageName thisIsARestart idx|

    imageName := ObjectMemory imageName.
    thisIsARestart := imageName notNil.

    true "graphicalMode" ifTrue:[
        Display isNil ifTrue:[
            (StartupClass notNil
            and:[ (StartupClass perform:#isHeadless ifNotUnderstood:false) ]) ifFalse:[
                self openDisplay.
            ].
        ].
    ].

    StandAlone ifFalse:[
        "
         enable the graphical debugger/inspector
         (they could have been (re)defined as autoloaded in the patches file)
        "
        self initStandardTools.
    ].

    "
     if there is a display, start its event dispatcher
    "
    Display notNil ifTrue:[
        Display deviceIOTimeoutErrorSignal handlerBlock:[:ex |
            SaveEmergencyImage == true ifTrue:[
                'Display [warning]: broken display connection - emergency save in ''crash.img''.' infoPrintCR.
                ObjectMemory primSnapShotOn:'crash.img'.
            ].
            'Display [warning]: broken display connection - exit.' infoPrintCR.
            self exit:11.
        ].
        Display startDispatch.
    ].

    idx := CommandLineArguments indexOf:'--browserWindow:'.
    IsPlugin := (idx ~~ 0).
    IsPlugin ifTrue:[
        'Smalltalk [info]: startup browser window...' infoPrintCR.
        self browserWindowStartup.
        "/ not reached
    ].

    Initializing := false.

    "/ start a process, which evaluates all StartBlocks
    "/ this used to be done right here (in this system-process),
    "/ but lead to trouble, when it suspended.
    "/ Therefore, it is now done by an extra user-process.

    process := [
        'Smalltalk [info]: startup process 1 active.' infoPrintCR.
        StartBlocks notNil ifTrue:[
            self executeStartBlocks.
            StartBlocks := nil.
        ].
        ImageStartBlocks notNil ifTrue:[
            'Smalltalk [info]: execute imageStartBlocks...' infoPrintCR.
            ImageStartBlocks do:[:aBlock|
                aBlock value
            ].
        ].
        StandAlone ifFalse:[
            (SilentLoading == true) ifFalse:[   "i.e. undefined counts as false"
                thisIsARestart ifTrue:[
                    Transcript cr.
                    Transcript showCR:('Smalltalk restarted from:'
                                        , imageName
                                        , ' (saved '
                                        , ObjectMemory imageSaveTime printString
                                        , ')' ).
                ] ifFalse:[
                    Transcript showCR:(self hello).
                    Transcript showCR:(self copyrightString).
                ].
                Transcript cr.
            ].

            DemoMode==true ifTrue:[
                Transcript showCR:'*** Restricted use:                              ***'.
                Transcript showCR:'*** This program may be used for education only. ***'.
                Transcript showCR:'*** Please read the files COPYRIGHT and LICENSE  ***'.
                Transcript showCR:'*** for more details.                            ***'.
                Transcript cr.
            ].
        ].

        thisIsARestart ifTrue:[
            "/
            "/ the final late notification - users can now assume that
            "/ views, forms etc. have been recreated.

            ObjectMemory changed:#returnFromSnapshot.
        ]

    ] newProcess.

    process priority:(Processor userSchedulingPriority).
    process name:'start block handler'.
    process beGroupLeader.
    process resume.
    process := nil.

    ObjectMemory startBackgroundCollectorAt:5.
    ObjectMemory startBackgroundFinalizationAt:5.

    "/ start a process, which evaluates the startupClass>>startupSelector
    "/ message.

    (StartupClass notNil and:[StartupSelector notNil]) ifTrue:[
        "
         allow more customization by reading an image specific rc-file
        "
        thisIsARestart ifTrue:[
            (imageName asFilename hasSuffix:'img') ifTrue:[
                imageName := imageName copyButLast:4
            ].
            self fileIn:(imageName , '.rc')
        ].

        Display notNil ifTrue:[
            Display exitOnLastClose:true.
        ].
        Processor exitWhenNoMoreUserProcesses:true.

        process := [
            'Smalltalk [info]: startup process 2 active.' infoPrintCR.
            StandAlone ifTrue:[
                AbortOperationRequest handle:[:ex |
                    'Smalltalk [info]: aborted - exit.' infoPrintCR.
                    OperatingSystem exit:1
                ] do:[
                    ('Smalltalk [info]: call ',StartupSelector,' of ',StartupClass name,' (1)') infoPrintCR.
                    StartupClass perform:StartupSelector withArguments:StartupArguments.
                ]
            ] ifFalse:[
                ('Smalltalk [info]: call ',StartupSelector,' of ',StartupClass name,' (2)') infoPrintCR.
                StartupClass perform:StartupSelector withArguments:StartupArguments.
            ].

            "/
            "/ non-GUI apps exit after the startup;
            "/ assume that GUI apps have created & opened some view ...
            "/
            Display isNil ifTrue:[
                'Smalltalk [info]: no Display - exit.' infoPrintCR.
                Smalltalk exit:11.
            ].
"/            "/
"/            "/ GUI apps exit after the last user process has finished
"/            "/
"/            Display exitOnLastClose:true.
            Processor exitWhenNoMoreUserProcesses:true.
        ] newProcess.
        process priority:(Processor userSchedulingPriority).
        process name:'main'.
        process beGroupLeader.
        process resume.
        process := nil.    "do not refer to process"
    ].

    StandAlone ifTrue:[
        Display notNil ifTrue:[
            FlyByHelp notNil ifTrue:[
                FlyByHelp start
            ].
        ].
    ].

"/    Display notNil ifTrue:[
"/        Display exitOnLastClose:true.
"/    ].
    "
     if view-classes exist, start dispatching;
     otherwise go into a read-eval-print loop
    "
    ((Display notNil and:[graphicalMode])
     or:[process notNil
     or:[HeadlessOperation
     or:[StandAlone]]]
    ) ifTrue:[
        Processor exitWhenNoMoreUserProcesses:true.
        Processor dispatchLoop.
        "done - the last process finished"
        'Smalltalk [info]: last process finished - exit.' infoPrintCR.
    ] ifFalse:[
        StandAlone ifFalse:[
            self readEvalPrintLoop
        ]
    ].

    self exit

    "Created: / 18-07-1996 / 21:07:39 / cg"
    "Modified: / 09-09-1996 / 17:42:50 / stefan"
    "Modified: / 07-01-2012 / 12:59:23 / cg"
!

openDisplay
    "try to open a display connection.
     If so, also read display- and keyboard.rc"

    |commandName|

    commandName := Smalltalk commandName.
    (commandName, ' [info]: opening display...') infoPrintCR.

    Display isNil ifTrue:[
	Screen notNil ifTrue:[
	    [
		Screen openDefaultDisplay:nil.
	    ] on:Screen deviceOpenErrorSignal do:[:ex|
                "do not use #errorPrintCR, it is no error, when an app supports display and no display.
                 in case shell exec 'app --version' we do not want this error string as part of the output"
                ('%1 [error]: No display connection to: %2' bindWith:commandName with:ex parameter) infoPrintCR.
"/                ('%1 [error]: No display connection to: %2' bindWith:commandName with:ex parameter) errorPrintCR.
		(commandName, ' [info]: Either set the DISPLAY environment variable,') infoPrintCR.
		(commandName, ' [info]: or start smalltalk with a -display argument.') infoPrintCR.
		HeadlessOperation == true ifFalse:[
		    OperatingSystem exit:1.
		].
	    ].

	    Display notNil ifTrue:[
		(self secureFileIn:'display.rc') ifFalse:[
		    "/ 'Smalltalk [warning]: no display.rc found; screen setting might be wrong.' errorPrintCR.
		    (self secureFileIn:'keyboard.rc') ifFalse:[
			"/ 'Smalltalk [warning]: no keyboard.rc found; shortkey setting might be wrong.' errorPrintCR.
		    ]
		]
	    ].
	]
    ]

    "Created: / 06-12-2006 / 15:38:17 / cg"
!

providingDisplayDo:aBlock
    "/ provide a Display, if needed
    (Smalltalk at:#Screen) currentScreenQuerySignal handle:[:ex |
        Display isNil ifTrue:[ self lateOpenDisplay ].
        ex proceedWith:Display.
    ] do:aBlock
!

readEvalPrintLoop
    "say hello, then go into a read-eval-print loop"

    "{ Pragma: +optSpace }"

    Transcript showCR:(self hello).
    Transcript showCR:(self copyrightString).
    Transcript cr.
    Transcript showCR:'Read-eval-print loop; exit with "#exit"; help with "?"'.

    ReadEvalPrintLoop new
        prompt:'ST> ';
        doChunkFormat:false;
        error:Stderr;
        readEvalPrintLoop

    "Modified: / 07-12-2006 / 17:35:19 / cg"
!

restart
    "startup after an image has been loaded;
     This is called by the VM's main entry - you should not find senders from Smalltalk.

     there are three change-notifications made to dependents of ObjectMemory,
     which allow a stepwise re-init: #earlyRestart, #restarted and #returnFromSnapshot.

     #earlySystemInstallation is sent for ST80 compatibility

     #earlyRestart is send first, nothing has been setup yet.
		   (should be used to flush all device dependent entries)

     #restarted is send right after.
		   (should be used to recreate external resources (fds, bitmaps etc)

     #returnFromSnapshot is sent last
		   (should be used to restart processes, reOpen Streams which cannot
		    be automatically be reopened (i.e. Sockets, Pipes) and so on.
		   (Notice that positionable fileStreams are already reopened and repositioned)
     "

    |deb insp transcript idx|

    "/
    "/ when we arrive here, all objects from our previous life
    "/ have been reloaded - however, some may still contain invalid device
    "/ handles, display information etc.
    "/ also, dynamically loaded modules have not yet been reloaded yet.
    "/ and the concrete OS, concrete FileName etc. are still refering to
    "/ the previous classes.

    Initializing := true.
    AbstractOperatingSystem initializeConcreteClass.

    ImageRestartTime := Timestamp now.

    CommandLine := CommandLineArguments copy.
    CommandLineArguments := CommandLineArguments asOrderedCollection.
    CommandName := CommandLineArguments removeFirst. "/ the command

    idx := CommandLineArguments indexOf:'-q'.
    idx == 0 ifTrue:[
	idx := CommandLineArguments indexOf:'--silent'.
    ].
    idx ~~ 0 ifTrue:[
	Object infoPrinting:false.
	ObjectMemory infoPrinting:false.
	CommandLineArguments removeAtIndex:idx.
    ].

    "/ start catching SIGSEGV and SIGBUS
    OperatingSystem enableHardSignalInterrupts.

    "/ reinit Filename
    Filename reinitialize.

    "/ flush cached path directories (may have changed in the meanwhile)
    self flushPathCaches.
    self reinitializePackagePath.

    "/ reinit the default streams: Stdin, Stdout and Stderr
    "/ after that, we can write to stderr.
    self reinitStandardStreams.

    "/ redirect Transcript to Stderr during startup
    transcript := Transcript.
    Transcript := Stderr.

    "/ temporary switch back to dumb interface -
    "/ to handle errors while view-stuff is not yet reinitialized
    insp := Inspector.
    deb := Debugger.
    deb notNil ifTrue:[
	deb reinitialize
    ].
    Inspector := MiniInspector.
    Debugger := MiniDebugger.

    "/ reload any dynamically loaded objects.
    "/ this must be done before doing anything else below,
    "/ because the Processor may restart processes which use
    "/ this code.
    "/ Also, a dynamic object might be registered as dependent of
    "/ ObjectFileLoader; therefore, must reload before doing any notifications.

    ObjectFileLoader notNil ifTrue:[
	ObjectFileLoader reloadAllRememberedObjectFiles.
    ].

    "/ invalidate all display connections.
    "/ This is required to avoid trouble if someone accesses
    "/ a display during early startup.
    Screen notNil ifTrue:[
	Screen allScreens do:[:eachDisplay |
	    eachDisplay invalidateConnection.
	].
    ].

    ObjectMemory changed:#earlySystemInstallation.

    "/ reinitialize the Processor - restartable processes
    "/ are now restarted here (but not yet scheduled).
    Processor reinitialize.

    "/ flush device handles & recreate OS resources (if possible)
    "/ (mostly view/GC/color & font stuff)
    ObjectMemory
	changed:#earlyRestart; changed:#restarted.

    "/ start catching SIGINT and SIGQUIT
    OperatingSystem enableUserInterrupts.
    OperatingSystem enableCrashSignalInterrupts.
    ObjectMemory restoreGarbageCollectorSettings.

    "/ give user a chance to re-customize things in smalltalk_r.rc.
    "/ reading if smalltalk_r.rc may be suppressed by the --faststart argument.
    idx := CommandLineArguments indexOf:'--faststart'.
    idx == 0 ifTrue:[
	idx := CommandLineArguments indexOf:'--fastStart'.
    ].
    idx ~~ 0 ifTrue:[
	CommandLineArguments removeAtIndex:idx.
    ] ifFalse:[
	CallbackSignal := QuerySignal new.
	[
	    Class withoutUpdatingChangesDo:[
		(self fileIn:(self commandName , '_r.rc')) ifFalse:[
		    "no _r.rc file where executable is; try default smalltalk_r.rc"
		    self fileIn:'smalltalk_r.rc'
		].
	    ]
	] on:CallbackSignal do:[:ex|
	    "/ now, display and view-stuff works;
	    "/ back to the previous debugging interface
	    Inspector := insp.
	    Debugger := deb.

	    "/ reinstall Transcript, if not changed during restart.
	    "/ if there was no Transcript, go to stderr
	    (transcript notNil and:[Transcript == Stderr]) ifTrue:[
		Transcript := transcript.
	    ].
	    Initializing := false.
	    ex proceed.
	].
	CallbackSignal := nil.
    ].

    "/ reinitialization (restart) of Display is normally performed
    "/ in the restart script. If this has not been run for some reason,
    "/ do in now.
    Initializing ifTrue:[
	Display notNil ifTrue:[
	    [
		Display reinitializeFor:Screen defaultDisplayName.
	    ] on:Screen deviceOpenErrorSignal do:[
		'Smalltalk [error]: Cannot restart connection to: ' errorPrint.
		Screen defaultDisplayName errorPrintCR.
		OperatingSystem exit:1.
	    ].
	].
	"/ now, display and view-stuff works;
	"/ back to the previous debugging interface

	Inspector := insp.
	Debugger := deb.

	"/ reinstall Transcript, if not changed during restart.
	"/ if there was no Transcript, go to stderr

	(transcript notNil and:[Transcript == Stderr]) ifTrue:[
	    Transcript := transcript.
	].
	Initializing := false.
    ].
    Screen notNil ifTrue:[
	"clean up leftover screens (and views) that haven't been reopened.
	 Operate on a copy, since brokenConnection removes us from AllScreens"
	Screen allScreens copy do:[:eachDisplay |
	    eachDisplay isOpen ifFalse:[
		'Smalltalk [info]: cannot reopen secondary display: ' errorPrint.
		eachDisplay errorPrintCR.
		eachDisplay cleanupAfterDispatch; brokenConnection.
	    ]
	].
    ].

    deb := insp := transcript := nil.   "avoid dangling refs"
    (StartupClass perform:#keepSplashWindowOpen ifNotUnderstood:[false]) ifFalse:[
	self hideSplashWindow.   "/ if there is one, it's now time to hide it
    ].
    self mainStartup:true

    "Modified: / 03-08-1999 / 09:42:21 / stefan"
    "Modified: / 29-07-2011 / 17:58:23 / cg"
!

showSplashMessage:aString
    "put the message into the splash screen (if there is one).
     Use this for messages during startup"

    self showSplashMessage:aString color:nil.
!

showSplashMessage:aMessageStringOrNil color:rgbValueOrNil
    "put the message into the splash screen (if there is one)."

%{
#ifdef WIN32
    extern void __win32_splashMessage();
    char *msg = (char *)0;
    int clr = 0;

    if (__isStringLike(aMessageStringOrNil)) {
	msg = __stringVal(aMessageStringOrNil);
    }
    if (__isSmallInteger(rgbValueOrNil)) {
	clr = __intVal(rgbValueOrNil);
	__win32_splashMessageColor(clr);
    }
    __win32_splashMessage(msg);
#endif
%}
!

splashInfo:aString
    "like infoPrintCR,
     but in addition put the message into the splash screen (if there is one).
     Use this for info messages during startup"

    aString notNil ifTrue:[ aString infoPrintCR ].
    self showSplashMessage:aString color:nil.
!

start
    "low level entry from the VM's main.
     After initializeSystem, this is the very first real entry into the Smalltalk world.
     Analyzes the command line and checks what to do
     (i.e. script/repl/eval or full blown IDE).
     Also handles --load and various debug options.
     Caveat:
        this has become too complicated and desperately needs a rewrite.

     Also:
        Be very careful when changing things here;
        especially be careful to ensure that the scripting options are robust against any
        missing packages; so the error handlers should not depend on any stream, logger etc. features.
     "

    |idx graphicalMode arg didReadRCFile keepSplashWindow|

    graphicalMode := Smalltalk isSmalltalkDevelopmentSystem.
    Initializing := true.

    keepSplashWindow := StartupClass perform:#keepSplashWindowOpen ifNotUnderstood:[false].

    idx := CommandLineArguments indexOf:'--debug'.
    (idx ~~ 0) ifTrue:[
        CommandLineArguments removeAtIndex:idx.
    ].

    "
     while reading patches- and rc-file, do not add things into change-file
    "
    Class withoutUpdatingChangesDo:[
        |commandFiles rcFile defaultRC prevCatchSetting
         isEval isPrint isFilter isRepl isRunMain idxFileArg process|

        isEval := isPrint := isFilter := isRepl := isRunMain := false.
        didReadRCFile := false.

        StandAlone ifFalse:[
            "/ self initializeVerboseFlags.

            "/
            "/ look for any '-q', '-e', '-l' or '-f' command line arguments
            "/ and handle them;
            "/ read startup and patches file
            "/
            idx := CommandLineArguments indexOfAny:#('-R' '--repl').
            isRepl := IsRepl := (idx ~~ 0).

            idx := CommandLineArguments indexOfAny:#('-q' '--silent').
            idx ~~ 0 ifTrue:[
                Object infoPrinting:false.
                ObjectMemory infoPrinting:false.
                CommandLineArguments removeAtIndex:idx.
                SilentLoading := true.
            ].

            [
                idx := CommandLineArguments indexOfAny:#('-pp' '--packagePath').
                idx ~~ 0
            ] whileTrue:[
                arg := CommandLineArguments at:idx + 1.
                CommandLineArguments removeAtIndex:idx+1; removeAtIndex:idx.
                (arg asCollectionOfSubstringsSeparatedByAny:',;') do:[:each |
                    self packagePath addLast:each.
                    VerboseStartup ifTrue:[
                        ('Smalltalk [info]: add to packagePath: "', arg, '".') infoPrintCR.
                    ].
                ].
            ].

            [
                idx := CommandLineArguments indexOfAny:#('-l' '--load').
                idx ~~ 0
            ] whileTrue:[
                arg := CommandLineArguments at:idx + 1.
                CommandLineArguments removeAtIndex:idx+1; removeAtIndex:idx.
                Smalltalk silentlyLoadingDo:[
                    (arg asCollectionOfSubstringsSeparatedByAny:',;') do:[:each |
                        each asFilename exists ifTrue:[
                            (VerboseStartup | VerboseLoading) ifTrue:[
                                ('Smalltalk [info]: loading file: "', each, '".') infoPrintCR.
                            ].
                            Smalltalk fileIn:each
                        ] ifFalse:[
                            (VerboseStartup | VerboseLoading) ifTrue:[
                                ('Smalltalk [info]: loading package: "', each, '".') infoPrintCR.
                            ].
                            Smalltalk loadPackage:each
                        ].
                    ].
                ].
            ].

            "/ look for a '-e filename' or '--execute filename' or '--script filename' argument
            "/ this will force fileIn of filename only, no standard startup.

            idx := CommandLineArguments indexOfAny:#('-e' '--execute' '--script').
            idx ~~ 0 ifTrue:[
                SilentLoading := true.
                CommandName := arg := CommandLineArguments at:idx + 1.

                CommandLineArguments
                    removeAtIndex:idx+1; removeAtIndex:idx.

                self startSchedulerAndBackgroundCollector.
                keepSplashWindow ifFalse:[ self hideSplashWindow ].
                Initializing := false.

                process := [
                    Processor exitWhenNoMoreUserProcesses:true.

                    "/ set workspace variables
                    self defineCommandLineAsWorkspaceVariablesForScripts.

                    "/ provide a Display, if needed
                    self providingDisplayDo:[
                        VerboseStartup ifTrue:[
                            ('Smalltalk [info]: reading script from: "', arg, '".') infoPrintCR.
                        ].
                        NoHandlerError handle:[:ex |
                            Debugging == true ifTrue:[
                                MiniDebugger enterException:ex.
                            ] ifFalse:[
                                Silent ifFalse:[
                                    'Smalltalk [error]: ' _errorPrint. ex description _errorPrintCR.
                                ].
                                (VerboseStartup or:[ObjectMemory debugPrinting]) ifTrue:[
                                    ex suspendedContext fullPrintAll.
                                ].
                                self exit:1.
                            ].
                            self exit:1.
                            "/ ex reject.
                        ] do:[
                            UserInterrupt handle:[:ex |
                                Debugging == true ifTrue:[
                                    'user interrupt (type "c" to continue; "x" to exit; "?" for help).' errorPrintCR.
                                    "/ thisContext fullPrintAll.
                                    MiniDebugger enterException:ex.
                                    ex proceed.
                                ].
                                Silent ifFalse:[ 'user interrupt.' errorPrintCR ].
                                self exit:128+(OperatingSystem sigINT).
                            ] do:[
                                arg = '-' ifTrue:[
                                    self fileInStream:Stdin
                                           lazy:nil
                                           silent:nil
                                           logged:false
                                           addPath:nil
                                ] ifFalse:[
                                    IsSTScript := true.
                                    Smalltalk silentlyLoadingDo:[
                                        self fileIn:arg.
                                    ].
                                ].
                            ].
                        ].
                    ].

                    "/ after the script, if Screen has been opened and there are any open windows,
                    "/ then do not exit
false ifTrue:[
                    Display notNil ifTrue:[
                        Processor exitWhenNoMoreUserProcesses:true.
                        "/ Display exitOnLastClose:true.
                        "/ Display checkForEndOfDispatch.
                    ] ifFalse:[
                        self exit.
                    ].
].
                ] newProcess.
                process priority:(Processor userSchedulingPriority).
                process name:'main'.
                process beGroupLeader.
                process resume.

                Processor dispatchLoop.
                self exit
            ].

            "look for a '-f filename' or '--file filename' argument
             if scripting, these are loaded before -P, -E or -R action.
             if not scripting, this will force evaluation of filename instead of smalltalk.rc"
            [
                idxFileArg := CommandLineArguments indexOfAny:#('-f' '--file').
                (idxFileArg ~~ 0)
            ] whileTrue:[
                commandFiles isNil ifTrue:[ commandFiles := OrderedCollection new ].
                commandFiles add:(CommandLineArguments at:idxFileArg+1).
                CommandLineArguments removeAtIndex:idxFileArg+1; removeAtIndex:idxFileArg.
            ].

            "/ look for a '-E expr' or '--eval expr' argument (-P or --print to print the result of evaluation)
            "/ or -F/--filter or a '--repl' argument
            "/ E, P and F this will force evaluation of expr only, no standard startup
            "/ repl go into an interactive loop.
            idx := CommandLineArguments indexOfAny:#('-E' '--eval').
            (isEval := (idx ~~ 0)) ifFalse:[
                idx := CommandLineArguments indexOfAny:#('-P' '--print').
                (isPrint := (idx ~~ 0)) ifFalse:[
                    idx := CommandLineArguments indexOfAny:#('-F' '--filter').
                    (isFilter := (idx ~~ 0)) ifFalse:[
                        idx := CommandLineArguments indexOfAny:#('-R' '--repl').
                        (isRepl := (idx ~~ 0)) ifFalse:[
                            idx := CommandLineArguments indexOfAny:#('--run').
                            isRunMain := (idx ~~ 0)
                        ].
                    ].
                ].
            ].

            (isEval | isPrint | isFilter | isRepl | isRunMain) ifTrue:[
                |args|

                VerboseStartup ifTrue:[
                    ('Smalltalk [info]: eval/filter/print or repl') infoPrintCR.
                ].
                isRepl ifFalse:[
                    CommandLineArguments size <= idx ifTrue:[
                        StandAlone := true.
                        self exitWithErrorMessage:'missing argument after -E/-P/-F/--run.'.
                    ].
                    isFilter ifTrue:[
                        args := CommandLineArguments copyFrom:idx + 1.
                        CommandLineArguments removeFromIndex:idx+1.
                        VerboseStartup ifTrue:[
                            ('Smalltalk [info]: filter expression(s): ') infoPrint.
                            args infoPrintCR.
                        ].
                    ] ifFalse:[
                        arg := CommandLineArguments at:idx + 1.
                        CommandLineArguments removeAtIndex:idx+1.
                        VerboseStartup ifTrue:[
                            ('Smalltalk [info]: eval expression: ') infoPrint.
                            arg infoPrintCR.
                        ].
                    ].
                ].
                CommandLineArguments removeAtIndex:idx.

                self startSchedulerAndBackgroundCollector.

                keepSplashWindow ifFalse:[ self hideSplashWindow ].
                Initializing := false.

                "/ set workspace variables
                self defineCommandLineAsWorkspaceVariablesForScripts.

                "/ all of the above allow for a -f file to be loaded before any other action
                (commandFiles notEmptyOrNil) ifTrue:[
                    commandFiles do:[:commandFile |
                        (VerboseStartup | VerboseLoading) ifTrue:[
                            ('Smalltalk [info]: reading command file from: "', commandFile, '".') infoPrintCR.
                        ].
                        Smalltalk silentlyLoadingDo:[
                            (self secureFileIn:commandFile) ifFalse:[
                                StandAlone := true.
                                self exitWithErrorMessage:('"', commandFile, '" not found.').
                            ]
                        ]
                    ]
                ].

                isRepl ifFalse:[
                    Debugging == true ifFalse:[
                        "/ remove the Debugger
                        Debugger := nil.
                    ].
                ].

                process := [
                    self providingDisplayDo:[
                        isRepl ifTrue:[
                            Processor exitWhenNoMoreUserProcesses:false.
                            Processor activeProcess name:'repl'.
                            self readEvalPrintLoop.
                            self exit.
                        ].

                        Processor exitWhenNoMoreUserProcesses:true.

                        NoHandlerError handle:[:ex |
                            Debugging == true ifTrue:[
                                MiniDebugger enterException:ex.
                            ] ifFalse:[
                                Silent ifFalse:[
                                    'Smalltalk [error]: ' _errorPrint. ex description _errorPrintCR.
                                ].
                                (VerboseStartup or:[ObjectMemory debugPrinting]) ifTrue:[
                                    ex suspendedContext fullPrintAll.
                                ].
                                self exit:1.
                            ].
                            self exit:1.
                            "/ ex reject.
                        ] do:[
                            UserInterrupt handle:[:ex |
                                Debugging == true ifTrue:[
                                    'user interrupt (type "c" to continue; "x" to exit; "?" for help).' errorPrintCR.
                                    "/ thisContext fullPrintAll.
                                    MiniDebugger enterException:ex.
                                    ex proceed.
                                ].
                                Silent ifFalse:[ 'user interrupt.' errorPrintCR ].
                                self exit:128+(OperatingSystem sigINT).
                            ] do:[
                                |filterCode filterStart filterEnd|

                                isFilter ifTrue:[
                                    "/ --filter - apply code to each input line.
                                    "/ compile code only once
                                    (args size == 1) ifTrue:[
                                        VerboseStartup ifTrue:[
                                            'Smalltalk [info]: filter 1-arg' infoPrintCR.
                                        ].
                                        filterCode := args at:1.
                                    ] ifFalse:[
                                        (args size == 3) ifTrue:[
                                            VerboseStartup ifTrue:[
                                                'Smalltalk [info]: filter 3-arg' infoPrintCR.
                                            ].
                                            filterStart := args at:1.
                                            filterCode := args at:2.
                                            filterEnd := args at:3.
                                        ] ifFalse:[
                                            StandAlone := true.
                                            self exitWithErrorMessage:'--filter must be followed by 1 or 3 expression arg(s)'
                                        ].
                                    ].
                                    filterStart notEmptyOrNil ifTrue:[
                                        VerboseStartup ifTrue:[
                                            ('Smalltalk [info]: eval: "', filterStart, '"...') infoPrintCR.
                                        ].
                                        Compiler evaluate:filterStart notifying:(EvalScriptingErrorHandler new source:filterStart)
                                    ].
                                    VerboseStartup ifTrue:[
                                        ('Smalltalk [info]: compile: "', filterCode, '"...') infoPrintCR.
                                    ].
                                    Compiler
                                        compile:'doIt:line ',filterCode
                                        forClass:String
                                        notifying:(EvalScriptingErrorHandler new source:filterCode).

                                    [Stdin atEnd] whileFalse:[
                                        |line|

                                        line := Stdin nextLine.
                                        line doIt:line.
                                    ].
                                    filterEnd notEmptyOrNil ifTrue:[
                                        VerboseStartup ifTrue:[
                                            ('Smalltalk [info]: eval: "', filterEnd, '"...') infoPrintCR.
                                        ].
                                        Compiler evaluate:filterEnd notifying:(EvalScriptingErrorHandler new source:filterEnd)
                                    ].
                                ] ifFalse:[
                                    (isPrint | isEval) ifTrue:[
                                        "/ --print or --eval
                                        |rslt|

                                        rslt := Parser new
                                                    evaluate:arg
                                                    notifying:(EvalScriptingErrorHandler new source:arg)
                                                    compile:true.
                                        isPrint ifTrue:[
                                            rslt printCR.
                                        ].
                                    ] ifFalse:[
                                        "/ --run <className>
                                        |className class|

                                        className := arg.
                                        class := Smalltalk classNamed:className.
                                        class isNil ifTrue:[
                                            StandAlone := true.
                                            self exitWithErrorMessage:'no such class: "', className, '".'
                                        ].
                                        (class respondsTo:#main:) ifTrue:[
                                            class main:CommandLineArguments.
                                        ] ifFalse:[
                                            (class respondsTo:#main) ifTrue:[
                                                class main.
                                            ] ifFalse:[
                                                (class respondsTo:#start) ifTrue:[
                                                    class start.
                                                ] ifFalse:[
                                                    StandAlone := true.
                                                    self exitWithErrorMessage:'class has no "main:", "main" or "start" method.'
                                                ].
                                            ].
                                        ].
                                    ].
                                ].
                            ].
                        ].
                    ].

                    "/ after the script, if Screen has been opened and there are any open windows,
                    "/ then do not exit
false ifTrue:[
                    Display notNil ifTrue:[
                        Processor exitWhenNoMoreUserProcesses:true.
                        "/ Display exitOnLastClose:true.
                        "/ Display checkForEndOfDispatch.
                        VerboseStartup ifTrue:[
                            ('Smalltalk [info]: display opened.') infoPrintCR.
                        ].
                    ] ifFalse:[
                        VerboseStartup ifTrue:[
                            ('Smalltalk [info]: no display - exit after script.') infoPrintCR.
                        ].
                        self exit.
                    ].
].
                    VerboseStartup ifTrue:[
                        ('Smalltalk [info]: script/repl/eval finished.') infoPrintCR.
                    ].

                ] newProcess.
                process priority:(Processor userSchedulingPriority).
                process name:'main'.
                process beGroupLeader.
                process resume.

                Processor dispatchLoop.
                VerboseStartup ifTrue:[
                    ('Smalltalk [info]: exit normally.') infoPrintCR.
                ].
                self exit
            ].
        ].

        commandFiles notNil ifTrue:[
            SilentLoading := true.  "/ suppress the hello & copyright messages
            self addStartBlock:
                [
                    commandFiles do:[:commandFile |
                        (self secureFileIn:commandFile) ifFalse:[
                            self exitWithErrorMessage:('startup file "', commandFile, '" not found.').
                        ].
                    ].
                ].

"/            self startSchedulerAndBackgroundCollector.
"/            keepSplashWindow ifFalse:[ self hideSplashWindow ].
"/            Initializing := false.
"/
"/            (self secureFileIn:commandFile) ifFalse:[
"/                ('Smalltalk [error]: startup file "', commandFile, '" not found.') errorPrintCR.
"/                OperatingSystem exit:1.
"/            ].
        ] ifFalse:[
            "/ look for <command>.rc
            "/ if not found, read smalltalk.rc (or stxapp.rc for standAlone operation)

            rcFile := self commandName asFilename withSuffix:'rc'.
            (didReadRCFile := rcFile exists and:[self secureFileIn:rcFile]) ifFalse:[
                StandAlone ifFalse:[
                    defaultRC := 'smalltalk.rc' "/asFilename
                ] ifTrue:[
                    defaultRC := 'stxapp.rc' "/asFilename
                ].
                "JV@2011-11-01: DO NOT check defaultRC exist - this prevents smalltalk to
                    to be started with different working directory than stx/projects/smalltalk !!!!!!"

                "/didReadRCFile := defaultRC exists and:[self secureFileIn:defaultRC].
                didReadRCFile := (self getSystemFileName:defaultRC) notNil
                                 and:[self secureFileIn:defaultRC].
                didReadRCFile ifFalse:[
                    StandAlone ifFalse:[
                        'Smalltalk [warning]: no startup rc-file found. Going into line-by-line interpreter.' infoPrintCR.
                        graphicalMode := false.
                    ]
                ]
            ].

            "/ ('StandAlone is %1' bindWith:StandAlone) printCR.
            "/ ('Headless is %1' bindWith:HeadlessOperation) printCR.
            "/ ('Display is %1' bindWith:Display) printCR.
            "/ ('Screen is %1' bindWith:Screen) printCR.

            keepSplashWindow ifFalse:[ self hideSplashWindow ].
            didReadRCFile ifFalse:[
                'private.rc' asFilename exists ifTrue:[ self secureFileIn:'private.rc' ].

                "/
                "/ No RC file found;
                "/ Setup more default stuff
                "/
                StandAlone ifFalse:[
                    "/ its a smalltalk - proceed in interpreter.
                    'Smalltalk [warning]: no startup rc-file found. Going into line-by-line interpreter.' infoPrintCR.
                    graphicalMode := false.
                ].

                "/ setup more defaults...
"/                ObjectMemory startBackgroundCollectorAt:5.
"/                ObjectMemory startBackgroundFinalizationAt:5.
                self addStartBlock:[
                    self startSchedulerAndBackgroundCollector
                ].
            ].
        ].
        (CommandLineArguments includes:'--scripting') ifTrue:[
            self addStartBlock:[
                StandaloneStartup handleScriptingOptionsFromArguments:CommandLineArguments.
            ].
        ].
    ].

    HeadlessOperation ifTrue:[
        graphicalMode := false.
    ].

    keepSplashWindow ifFalse:[ self hideSplashWindow ].
    self mainStartup:graphicalMode

    "Modified: / 17-12-2013 / 16:44:40 / cg"
!

startSchedulerAndBackgroundCollector
    Processor startTimeSlicing.
    Processor supportDynamicPriorities:true.

    ObjectMemory startBackgroundCollectorAt:5.
    ObjectMemory startBackgroundFinalizationAt:5.
    ObjectMemory backgroundCollectProcess priorityRange:(4 to:9).
    ObjectMemory backgroundFinalizationProcess priorityRange:(4 to:9).

    "Created: / 31-07-2011 / 20:01:33 / cg"
!

startStartBlockProcess
    "at the end of the smalltalk initialization, start all actions that
     were delayed until the ProcessorScheduler is running in a separate process"

    |p|

    p :=
	[
	    self executeStartBlocks.
	] newProcess.

    p
	priority:(Processor userSchedulingPriority);
	name:'start block handler';
	beGroupLeader;
	resume.

    "Modified: / 07-01-2012 / 12:59:01 / cg"
! !

!Smalltalk class methodsFor:'startup and exit'!

addExitBlock:aBlock
    "{ Pragma: +optSpace }"

    "add a block to be executed when Smalltalk finishes.
     This feature is currently not used anywhere - but could be useful for
     cleanup in stand alone applications.

     Better use: ObjectMemory>>#addDependent: and handle the change message
     #aboutToQuit."

    ExitBlocks isNil ifTrue:[
	ExitBlocks := OrderedCollection with:aBlock
    ] ifFalse:[
	ExitBlocks add:aBlock
    ]
!

addImageStartBlock:aBlock
    "{ Pragma: +optSpace }"

    "add a blocks to be executed in a separate process after
     everything has been initialized.
     These blocks will be executed after an image restart."

    ImageStartBlocks isNil ifTrue:[
	ImageStartBlocks := OrderedCollection with:aBlock
    ] ifFalse:[
	ImageStartBlocks add:aBlock
    ]

    "Created: 9.9.1996 / 16:48:20 / stefan"
!

addStartBlock:aBlock
    "to be called ONLY during very early startup (before the process scheduler
     is started) to add a block to be executed in a separate process after
     everything has been initialized.
     Used to allow a startup script (which is executed BEFORE the scheduler and
     UI display is startup up) to add actions which require those subsystems to
     be operating.
     These blocks will be executed only once and not be executed after an image restart.
     Initial processes such as the launcher are usually started here
     (see smalltalk.rc / private.rc).
     ONLY to be called from such an rc file."

    "{ Pragma: +optSpace }"

    "/ to protect against "mis-users" of this mehtod...
    Initializing ifFalse:[
	aBlock value
    ] ifTrue:[
	StartBlocks isNil ifTrue:[
	    StartBlocks := OrderedCollection with:aBlock
	] ifFalse:[
	    StartBlocks add:aBlock
	]
    ].

    "Created: / 09-09-1996 / 16:46:53 / stefan"
    "Modified (comment): / 18-08-2011 / 09:18:42 / cg"
!

exit
    "{ Pragma: +optSpace }"

    "finish the Smalltalk system"

    self exit:0
    "not reached"

    "Be careful evaluating this
     Smalltalk exit
    "
!

exit:statusInteger
    "{ Pragma: +optSpace }"

    "finish the Smalltalk system"

    ObjectMemory changed:#aboutToExit.  "/ for ST/X backward compatibility
    ObjectMemory changed:#aboutToQuit.  "/ for ST-80 compatibility
    ExitBlocks notNil ifTrue:[
	ExitBlocks do:[:aBlock |
	    aBlock value
	]
    ].
    OperatingSystem exit:statusInteger
    "not reached"

    "Be careful evaluating this
     Smalltalk exit:1
    "
!

exitIfStandalone
    "if this is a standalone application, exit.
     Otherwise give a warning and abort.
     Call this in your code instead of Smalltalk exit,
     so the code can be tested in the IDE without danger of shuttong down ST/X"

    "{ Pragma: +optSpace }"

    self exitIfStandalone:0

    "Created: / 06-06-2016 / 14:56:49 / cg"
!

exitIfStandalone:statusInteger
    "if this is a standalone application, exit.
     Otherwise give a warning and abort.
     Call this in your code instead of Smalltalk exit,
     so the code can be tested in the IDE without danger of shuttong down ST/X"

    "{ Pragma: +optSpace }"

    Smalltalk isStandAloneApp ifTrue:[
        self exit:statusInteger
    ] ifFalse:[
        self warn:'Application asks Smalltalk to exit (this is suppressed in IDE).'.
        AbortOperationRequest raise.
    ]

    "
     Smalltalk exitIfStandalone:1
    "

    "Created: / 06-06-2016 / 14:56:00 / cg"
!

exitOrError:exitCode
    "exit only if running as standalone application.
     Raise an error in the development system.
     Useful for testing standalone apps which should not kill
     your development system."

    self isStandAloneApp ifTrue:[
        self exit:exitCode.
    ].
    self error:'standalone smalltalk would exit here with exit code: ', exitCode printString.

    "
     self exitOrError:0
    "
!

exitWithErrorMessage:msg
    ('Smalltalk [error]: ',msg) errorPrintCR.
    self exitOrError:1
! !

!Smalltalk class methodsFor:'startup queries'!

commandLine
    "return the full command line arguments (with which ST/X was started)"

    ^ CommandLine

    "
     Smalltalk commandLine
    "

    "Created: 19.7.1996 / 11:09:06 / cg"
!

commandLineArgumentNamed:aString
    "extract a named argument from the command line arguments.
     This searches for the given string in the command line and returns the next argument after it."

    |args index|

    args := self commandLineArguments.
    index := args indexOf:aString.
    (index between:1 and:(args size - 1)) ifTrue:[
	^ args at:index+1
    ].
    ^ nil.

    "
     self commandLineArgumentNamed:'-display'
    "
!

commandLineArguments
    "return the user command line arguments;
     This is a collection of strings (separated command line words),
     from which the internal startup arguments have already been removed.
     I.e. if started with: 'smalltalk -I -f xxx foo bar baz',
     the commandLineArguments will be #('foo' 'bar' 'baz').
     In contrast, the value returned by #commandLine will be the full set of words."

    ^ CommandLineArguments

    "Modified: 19.7.1996 / 11:11:03 / cg"
!

commandName
    "return the excutables name - this is normally 'stx',
     but can be something else for standAlone apps."

    ^ CommandName.

    "
     Smalltalk commandName
    "

    "Modified: 19.7.1996 / 11:11:16 / cg"
!

hasNoConsole
    "return true, if this is a console-less application (i.e. I am winstx)
     i.e. there should be no writing to stdout/stderr"

    ^ HasNoConsole ? false

    "
     Smalltalk hasNoConsole
    "
!

ignoreAssertions
    "return true, if assertions are to be ignored (i.e. not executed).
     This is false by default in an IDE (i.e. full smalltalk),
     but can be set to true for standAlone applications
     (whether that is a good idea and helps, is another question)
     However, it may make the app a little faster, if assertions are compatational
     expensive, as they are skipped (the stc compiler is generatig code which skips those)."

    ^ IgnoreAssertions ? false
!

ignoreAssertions:aBoolean
    "set to true, if assertions are to be ignored (i.e. not executed).
     This is false by default in an IDE (i.e. full smalltalk),
     but can be set to true for standAlone applications
     (whether that is a good idea and helps, is another question)
     However, it may make the app a little faster, if assertions are compatational
     expensive, as they are skipped (the stc compiler is generatig code which skips those)."

    IgnoreAssertions := aBoolean
!

isHeadless
    "return true, if this is a headless application
     i.e. no default Display connection is required/used"

    ^ HeadlessOperation ? false

    "
     Smalltalk isHeadless
    "
!

isPlugin
    "return true, if this is a plugin application
     i.e. running in a browserWindow"

    ^ IsPlugin ? false

    "
     Smalltalk isPlugin
    "
!

isSTScript
    "return true, if this is stscript. i.e. the stx scripting engine."

    ^ IsSTScript ? false

    "
     Smalltalk isSTScript
    "

    "Created: / 06-12-2006 / 16:41:21 / cg"
!

isSharedLibraryComponent
    "return true, if this is a shared library component of another application
     i.e. a dll within another app."

    ^ IsSharedLibraryComponent ? false

    "
     Smalltalk isSharedLibraryComponent
    "

    "Created: / 10-08-2006 / 13:09:34 / cg"
!

isSmalltalkDevelopmentSystem
    "return true, if this is a real smalltalk system
     i.e. NOT a stripped or a linked standAlone application (such as the webServer)
     and NOT a plugIn (i.e. running in a browser)
     and NOT a sharedLibrary component (i.e. a dll in another app).
     This is used to determine, whether debugging is possible/desired or not."

    self isPlugin ifTrue:[^ false].                     "/ I am a browser-plugin
    self isSharedLibraryComponent ifTrue:[^ false].     "/ I am a COM-ponent
    self isSTScript ifTrue:[^ true ].                   "/ I am stScript
    ^ self isStandAloneApp not.

    "
     Smalltalk isSmalltalkDevelopmentSystem
    "

    "Created: / 10-08-2006 / 13:12:49 / cg"
    "Modified: / 06-12-2006 / 16:42:56 / cg"
    "Modified (comment): / 27-07-2013 / 15:36:20 / cg"
!

isStandAloneApp
    "return true, if this is a standAlone application
     i.e. a stripped & linked application (such as the webServer)
     in contrast to a full smalltalk (development) system."

    ^ StandAlone ? false

    "
     Smalltalk isStandAloneApp
    "
!

isStandAloneDebug
    "return true, if this is a standAlone application which
     was started with the -debug option."

    ^ DebuggingStandAlone ? false

    "
     Smalltalk isStandAloneDebug
    "

    "Created: / 19-01-2012 / 10:17:41 / cg"
!

startupArguments
    "return the arguments passed to StartupClass when stx gets started.
     Usually these are nil,
     but saving an image with a non-nil StartupClass/StartupSelector/StartupArgs allows for
     a simple way to configure and create stand-alone applications"

    ^ StartupArguments

    "
     Smalltalk startupArguments
    "
!

startupClass
    "return the class, that will get the start message when smalltalk
     starts and its non-nil. Usually this is nil,
     but saving an image with a non-nil StartupClass/StartupSelector/StartupArgs allows for
     a simple way to configure and create stand-alone applications"

    ^ StartupClass

    "
     Smalltalk startupClass
    "
!

startupClass:aClass selector:aSymbol arguments:anArrayOrNil
    "{ Pragma: +optSpace }"

    "set the class, selector and arguments to be performed when smalltalk
     starts. Setting those before saving a snapshot, will make the saved
     image come up executing your application (instead of the normal mainloop)"

    StartupClass := aClass.
    StartupSelector := aSymbol.
    StartupArguments := anArrayOrNil
!

startupSelector
    "return the selector, that will be sent to StartupClass.
     Usually this is nil,
     but saving an image with a non-nil StartupClass/StartupSelector allows for
     a simple way to configure and create stand-alone applications"

    ^ StartupSelector

    "
     Smalltalk startupSelector
    "
!

wasStartedFromImage
    "return true, if this smalltalk was started from an image,
     as opposed to a fresh and clean startup"

    ^ ImageRestartTime notNil

    "
     Smalltalk wasStartedFromImage
    "
! !

!Smalltalk class methodsFor:'system environment'!

language
    ^ UserPreferences current language

    "
     Smalltalk language
    "

    "Modified: / 26-04-1996 / 17:10:05 / cg"
    "Modified: / 20-11-2017 / 14:12:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

language:aLanguageSymbol
    <resource: #obsolete>

    self obsoleteFeatureWarning:'Use `UserPreferences current language: ...`'

    "Modified: / 19-10-2006 / 23:17:29 / cg"
    "Modified: / 20-11-2017 / 14:10:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

language:aLanguageSymbol territory:aTerritorySymbol
    <resource: #obsolete>

    self obsoleteFeatureWarning:'Use `UserPreferences current language: ...; languageTerritory:`'      .

    "
     Smalltalk language:#de territory:#de
    "

    "Created: / 19-10-2006 / 22:16:22 / cg"
    "Modified: / 19-10-2006 / 23:17:36 / cg"
    "Modified: / 20-11-2017 / 14:11:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageAndTerritory
    "return the language and territory in the format lang-terr (i.e. de-de, en-us)"

    ^ self language , '-' , self languageTerritory

    "
     Smalltalk languageAndTerritory
    "

    "Created: / 16-01-2011 / 10:19:42 / cg"
    "Modified (comment): / 20-11-2017 / 14:13:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageCodeset
    ^ LanguageCodeset
!

languageModifier
    ^ LanguageModifier
!

languageTerritory
    "return the language territory setting"

    ^ UserPreferences current languageTerritory

    "Modified: / 20-11-2017 / 14:13:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageTerritory:aTerritorySymbol
    <resource: #obsolete>

    self obsoleteFeatureWarning:'Use `UserPreferences current languageTerritory: ...`'      .

    "
     Time now

     Smalltalk languageTerritory:#us.
     Time now

     Smalltalk languageTerritory:#de.
     Time now
    "

    "Modified: / 19-10-2006 / 23:17:40 / cg"
    "Modified: / 20-11-2017 / 14:12:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setLanguage:aLanguageSymbol
    <resource: #obsolete>
    self obsoleteFeatureWarning

    "Modified: / 20-11-2017 / 14:16:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setLanguage:aLanguageSymbol territory:aTerritorySymbol
    <resource: #obsolete>
    self obsoleteFeatureWarning.

    "Modified (format): / 28-11-2017 / 00:03:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Smalltalk class methodsFor:'system management'!

compressSources
    "{ Pragma: +optSpace }"

    "compress the sources file, and remove all method source strings
     from the system and replace them by refs to a string in the source file.
     This is a bit different in ST/X than in other smalltalks,
     since we use per-class sourcefiles for the compiled classes,
     and a mix of in-memory strings and one-for-all sourceFile for
     incremental compiled methods.
     Therefore, only those sources which are not coming from compiled
     methods are put into the 'st.src' file - all others are untouched.
     This is being automated - so don't care for now."

    |newStream table source pos fileName|

    "
     first, find all methods which contain either a string-ref
     or an external string in the 'st.src' file
    "
    newStream := 'src.tmp' asFilename writeStream.

    table := IdentityDictionary new:100.

    Method allSubInstancesDo:[:aMethod |
        source := nil.
        aMethod sourcePosition notNil ifTrue:[
            aMethod sourceFilename = 'st.src' ifTrue:[
                source := aMethod source.
            ]
        ] ifFalse:[
            source := aMethod source
        ].

        source notNil ifTrue:[
            pos := newStream position + 1.
            newStream nextChunkPut:source.

            "
             dont change the methods info - maybe some write error
             occurs later, in that case we abort and leave everything
             untouched.
            "
            table at:aMethod put:pos
        ]
    ].

    newStream syncData; close.

    "
     now, rename the new source file,
    "
    fileName := (ObjectMemory nameForSources).
    'src.tmp' asFilename renameTo:fileName.

    "good - now go over all changed methods, and change their
     source reference"

    table keysAndValuesDo:[:aMethod :pos |
        aMethod localSourceFilename:fileName position:pos.
"/        aMethod printCR.
    ].

    "
     Smalltalk compressSources
    "

    "Modified: 16.1.1997 / 01:25:58 / cg"
!

generateSingleSourceFile
    "{ Pragma: +optSpace }"

    "generate the sources file, and remove all method source strings
     from the system and replace them by refs to a string in the source file.
     This makes the image independent from the per-class source files
     and makes transportation of endUser applications easier, since
     only 3 files (executable, image and sourceFile) need to be
     transported."

    |newStream table source pos fileName|

    newStream := 'src.tmp' asFilename writeStream.

    table := IdentityDictionary new:100.

    Method allSubInstancesDo:[:aMethod |
        source := aMethod source.
        source notNil ifTrue:[
            pos := newStream position + 1.
            newStream nextChunkPut:source.

            "
             don't change the methods info - maybe some write error
             occurs later, in that case we abort and leave everything
             untouched.
            "
            table at:aMethod put:pos
        ]
    ].

    newStream syncData; close.

    "
     now, rename the new source file,
    "
    fileName := (ObjectMemory nameForSources).
    'src.tmp' asFilename renameTo:fileName.

    "good - now go over all changed methods, and change their
     source reference"

    table keysAndValuesDo:[:aMethod :pos |
        aMethod localSourceFilename:fileName position:pos.
"/        aMethod printCR.
    ].

    "
     Smalltalk generateSingleSourceFile
    "

    "Modified: 16.1.1997 / 01:25:58 / cg"
    "Created: 17.10.1997 / 13:00:56 / cg"
!

installAutoloadedClassFromSourceFile:aFilename
    "install aFilename (which must be a smalltalk source file) as autoloaded class
     (extract the class definition chunk from the file and create an autoloaded
      class stub for it)"

    |chunks filename|

    filename := aFilename asFilename.

    ChangeSet::InvalidChangeChunkError handle:[:ex |
	^ self
    ] do:[
	filename readingFileDo:[:s|
	    chunks := ChangeSet fromStream:s while:[:chunk | chunk isMethodChange not].
	].
    ].

    chunks
	select:[:eachChunk | eachChunk isClassDefinitionChange]
	thenDo:[:eachClassChunk |
		eachClassChunk installAsAutoloadedClassIfPublicWithFilename:filename asAbsoluteFilename "withoutSuffix" name "baseName"
	].

    "Created: / 01-08-2013 / 16:57:26 / cg"
!

installAutoloadedClassNamed:clsName category:cat package:package revision:revisionOrNil
    "create & install an autoload stub for a class named: clsName,
     to be loaded from package.
     If revisionOrNil is non-nil, set it up to load exactly that revision
     (otherwise, the newest revision will be loaded"

    ^ self
	installAutoloadedClassNamed:clsName
	category:cat
	package:package
	revision:revisionOrNil
	numClassInstVars:nil.
!

installAutoloadedClassNamed:clsName category:cat package:package revision:revisionOrNil numClassInstVars:numClassInstVarsOrNil
    "create & install an autoload stub for a class named: clsName,
     to be loaded from package.
     If revisionOrNil is non-nil, set it up to load exactly that revision
     (otherwise, the newest revision will be loaded"

    |clsSym cls|

    clsSym := clsName asSymbol.

    "/ install if not already compiled-in
    (cls := self at:clsSym) isNil ifTrue:[
	Autoload subclass:clsSym
	    instanceVariableNames:''
	    classVariableNames:''
	    poolDictionaries:''
	    category:cat
	    inEnvironment:Smalltalk.

	cls := self at:clsSym.
	cls isNil ifTrue:[
	    ('Smalltalk [warning]: failed to install ' , clsName , ' as autoloaded.') infoPrintCR.
	] ifFalse:[
	    cls package:package asSymbol.
	    revisionOrNil notNil ifTrue:[
		cls setBinaryRevision:revisionOrNil
	    ]
	]
    ] ifFalse:[
	"/ class already present - however, if unloaded, check for category/package change
	cls isLoaded ifFalse:[
	    package ~= cls package ifTrue:[
		cls withoutUpdatingChangesDo:[
		    cls package:package asSymbol.
		].
	    ].
	    cat ~= cls category ifTrue:[
		cls withoutUpdatingChangesDo:[
		    cls category:cat.
		].
	    ].
	].
    ].
    ^ cls.

    "Created: / 05-11-1998 / 15:10:25 / cg"
    "Modified: / 16-01-2007 / 12:56:18 / cg"

!

installAutoloadedClasses
    "scan all packages and install all classes found there as
     autoloaded. This takes some time ..."

    |dirsConsulted|

    LoadInProgressQuery answerNotifyLoadingDo:[
	dirsConsulted := Set new.

	"/ along the package-path
	self packagePath do:[:eachPathComponent |
	    (dirsConsulted includes:eachPathComponent) ifFalse:[
		self
		    recursiveInstallAutoloadedClassesFrom:eachPathComponent
		    rememberIn:dirsConsulted
		    maxLevels:15
		    noAutoload:false
		    packageTop:eachPathComponent
		    showSplashInLevels:2.
	    ]
	].
	self splashInfo:nil.
    ].

    "
     Smalltalk installAutoloadedClasses
    "

    "Created: / 14.2.1997 / 17:32:57 / cg"
    "Modified: / 13.12.1999 / 11:56:50 / cg"
!

installAutoloadedClassesFrom:anAbbrevFilePath
    "read the given abbreviation file; install all classes found there as
     autoloaded. This takes some time ..."

    |f s|

    f := self getSystemFileName:anAbbrevFilePath.
    f isNil ifTrue:[f := self getPackageFileName:anAbbrevFilePath].

    f notNil ifTrue:[
        f := f asFilename.
        f isDirectory ifTrue:[
            f := f construct:'abbrev.stc'
        ].
        [
            s := f readStream.
            self installAutoloadedClassesFromStream:s.
            s close.
        ] on:FileStream openErrorSignal
        do:[:ex| "do nothing"].
    ]

    "
     Smalltalk installAutoloadedClassesFrom:'include/abbrev.stc'
     Smalltalk installAutoloadedClassesFrom:'../../goodies/communication/abbrev.stc'
    "

    "Modified: / 5.11.1998 / 15:10:51 / cg"
!

installAutoloadedClassesFromAbbrevFile:aFilename
    aFilename readingFileDo:[:abbrevStream |
        self installAutoloadedClassesFromStream:abbrevStream.
    ]

    "
     self installAutoloadedClassesFromAbbrevFile:('../../goodies/communication/abbrev.stc' asFilename)
    "

    "Created: / 29-07-2011 / 20:39:21 / cg"
!

installAutoloadedClassesFromStream:anAbbrevFileStream
    "read the given abbreviation file;
     install all classes found there as autoloaded, and also update the
     abbreviation (className-to-fileName mapping) table.
     This takes some time ..."

    |s2 l abbrevFileName info clsName cls abbrev package cat numClassInstVars words w|

    anAbbrevFileStream isFileStream ifTrue:[
        abbrevFileName := anAbbrevFileStream pathName.
        info := 'declared from: ', abbrevFileName.
    ].

    "/ yes, create any required nameSpace, without asking user.
    Class createNameSpaceQuerySignal answer:true do:[

        [anAbbrevFileStream atEnd] whileFalse:[
            l := anAbbrevFileStream nextLine withoutSeparators.
            "Skip empty lines and comments"
            (l notEmpty and:[l first ~= $#]) ifTrue:[
                "/ must do it manually, caring for quoted strings.
"/                words := line asCollectionOfWords.

                words := OrderedCollection new.
                s2 := l readStream.
                [s2 atEnd] whileFalse:[
                    s2 skipSeparators.
                    s2 peek == $' ifTrue:[
                        s2 next.
                        w := s2 upTo:$'.
                        s2 skipSeparators.
                    ] ifFalse:[
                        w := s2 upToSeparator
                    ].
                    words add:w
                ].
                words size < 3 ifTrue:[
                    'Smalltalk [warning]: bad abbrev entry' errorPrint.
                    anAbbrevFileStream isFileStream ifTrue:[
                        ' (in ''' errorPrint.
                        anAbbrevFileStream pathName errorPrint.
                        ''')' errorPrint
                    ].
                    ': ' errorPrint. l errorPrintCR
                ] ifFalse:[
                    clsName := (words at:1) asSymbol.
                    abbrev := (words at:2).
                    package := (words at:3) asSymbol.
                    cat := words at:4 ifAbsent:nil.
                    numClassInstVars := words at:5 ifAbsent:'0'.
                    numClassInstVars := Integer readFrom:numClassInstVars onError:[0].

                    (cat size == 0) ifTrue:[
                        cat := 'autoloaded'
                    ].

                    "/ on the fly, update the abbreviations
                    self setFilename:abbrev forClass:clsName package:package.

                    "/ '  autoloaded: ' print. clsName print. ' in ' print. cat printCR.

                    cls := self
                        installAutoloadedClassNamed:clsName
                        category:cat
                        package:package
                        revision:nil
                        numClassInstVars:numClassInstVars.

"/                    info notNil ifTrue:[
"/                        cls setComment:info.
"/                    ].
                ]
            ]
        ]
    ]
!

loadBinaries
    "return true, if binaries should be loaded into the system,
     false if this should be suppressed. The default is false (for now)."

    ^ LoadBinaries
!

loadBinaries:aBoolean
    "{ Pragma: +optSpace }"

    "turn on/off loading of binary objects"

    aBoolean ifTrue:[
	(ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles]) ifTrue:[
	    LoadBinaries := true.
	    ^ self
	].
	'Smalltalk [info]: this system does not support binary loading' infoPrintCR.
    ].
    LoadBinaries := false

    "Modified: 10.1.1997 / 15:11:00 / cg"
!

logDoits
    "return true if doits should go into the changes file
     as well as changes - by default, this is off, since
     it can blow up the changes file enormously ...
    "

    ^ LogDoits

    "
     LogDoits := false
     LogDoits := true
    "
!

logDoits:aBoolean
    "{ Pragma: +optSpace }"

    "turn on/off logging of doits in the changes file.
     By default, this is off, since it can blow up the
     changes file enormously ...
    "

    LogDoits := aBoolean

!

makeBytecodeMethods
    "{ Pragma: +optSpace }"

    "walk over all methods and make each a bytecode method
     iff it does not contain primitive C code.
     Experimental and not yet used."

    Method allSubInstancesDo:[:aMethod |
        |newMethod|

        aMethod hasPrimitiveCode ifFalse:[
"/            aMethod errorPrintCR.
            newMethod := aMethod asByteCodeMethod.
            newMethod ~~ aMethod ifTrue:[
                newMethod isNil ifTrue:[
                    'Smalltalk>>makeBytecodeMethods could nor recompile: ' errorPrint. aMethod errorPrintCR.
                ] ifFalse:[
                    aMethod becomeSameAs:newMethod
                ].
            ]
        ].
    ].

    "
     Smalltalk makeBytecodeMethods
    "

    "Modified: 16.1.1997 / 01:25:58 / cg"
    "Created: 17.10.1997 / 13:52:19 / cg"
!

recursiveInstallAutoloadedClassesFrom:aTopDirectory
    "scan all packages and install all classes found there as
     autoloaded. This takes some time ..."

    |dirsConsulted|

    dirsConsulted := Set new.

    self
        recursiveInstallAutoloadedClassesFrom:aTopDirectory
        rememberIn:dirsConsulted
        maxLevels:15
        noAutoload:false
        packageTop:nil
        showSplashInLevels:-1.


    "
     Smalltalk recursiveInstallAutoloadedClassesFrom:'..\..\..\cg\private\euler'
    "

    "Created: / 31-07-2012 / 15:27:40 / cg"
!

recursiveInstallAutoloadedClassesFrom:aDirectory rememberIn:dirsConsulted maxLevels:maxLevels noAutoload:noAutoloadIn packageTop:packageTopPath
    "read all abbrev.stc files from and under aDirectory
     and install autoloaded classes.
     If a file called NOAUTOLOAD is found, no classes there are installed as autoloaded,
     but classes in subdirectories are installed, if the subdirectory contains a file
     named AUTOLOAD.
     If a file called NOSUBAUTOLOAD is found, no classes there and below are installed as autoloaded.
     If a file called NOPACKAGES is found, no further searching is done in that directory or below."

    self
	recursiveInstallAutoloadedClassesFrom:aDirectory rememberIn:dirsConsulted
	maxLevels:maxLevels noAutoload:noAutoloadIn packageTop:packageTopPath
	showSplashInLevels:0.

    "
     Smalltalk installAutoloadedClasses
    "

    "Modified: / 17-08-2006 / 16:48:43 / cg"
!

recursiveInstallAutoloadedClassesFrom:aDirectory rememberIn:dirsConsulted
maxLevels:maxLevels noAutoload:noAutoloadIn packageTop:packageTopPath
showSplashInLevels:showSplashInLevels
    "read all abbrev.stc files from and under aDirectory
     and install autoloaded classes.
     If a file called NOAUTOLOAD is found, no classes there are installed as autoloaded,
     but classes in subdirectories are installed, if the subdirectory contains a file
     named AUTOLOAD.
     If a file called NOSUBAUTOLOAD is found, no classes there and below are installed as autoloaded.
     If a file called NOPACKAGES is found, no further searching is done in that directory or below."

    |dir noAutoloadHere dirName directoryContents haveAbbrevDotSTC|

    dir := aDirectory asFilename.

    "/ Care for non-existent directories"
    dir exists ifFalse:[ ^ self ].

    dirName := dir physicalPathName.            "take care of symbolic links"

    (dirsConsulted includes:dirName) ifTrue:[
        ^ self
    ].

    (dir / 'NOPACKAGES') exists ifTrue:[
        ^ self.
    ].
    (dir / 'NOSUBAUTOLOAD') exists ifTrue:[
        ^ self.
    ].

    maxLevels == 0 ifTrue:[
        Transcript showCR:('Autoload: max directory nesting reached in %1' bindWith:dir pathName).
        ^ self
    ].

    dirsConsulted add:dirName.
    noAutoloadHere := noAutoloadIn.
    noAutoloadHere ifFalse:[
        (dir / 'NOAUTOLOAD') exists ifTrue:[
            noAutoloadHere := true.
        ].
    ] ifTrue:[
        (dir / 'AUTOLOAD') exists ifTrue:[
            noAutoloadHere := false.
        ].
    ].

    showSplashInLevels >= 0 ifTrue:[
        self showSplashMessage:('Smalltalk [info]: installing autoloaded classes found under "%1"...'
                                bindWith:(dirName contractAtBeginningTo:35)).
    ].

    "/
    "/ suppress installation as autoloaded in this and everything
    "/ below; however, still traverse the directories to find packages ...
    "/
    haveAbbrevDotSTC := false.
    noAutoloadHere ifFalse:[
        [
            self installAutoloadedClassesFromAbbrevFile:(dir / 'abbrev.stc').
            haveAbbrevDotSTC := true.
        ] on:FileStream openErrorSignal
        do:[:ex|
            "ignore this file"
        ].
    ].

    [
        directoryContents := dir directoryContents.
    ] on:FileStream openErrorSignal do:[:ex|
        "non-accessible directory: we are done"
        ^ self
    ].

    directoryContents := directoryContents select:[:fn | (fn startsWith:'.') not] as:Set.

    directoryContents removeAllFoundIn:#(
                            'objbc' 'objvc' 'objmingw'
                            'doc'
                            'CVS'
                            'bitmaps'
                            'resources'
                            'source'
                            'not_delivered'
                            'not_ported'
                        ).
    dir baseName = 'stx' ifTrue:[
        directoryContents removeAllFoundIn:#(
                            'configurations'
                            'include'
                            'rules'
                            'stc'
                            'support'
                        ).
    ].

    directoryContents do:[:eachFilenameString |
        |f|

        f := dir / eachFilenameString.
        f isDirectory ifTrue:[
             self
                recursiveInstallAutoloadedClassesFrom:f
                rememberIn:dirsConsulted
                maxLevels:maxLevels-1
                noAutoload:noAutoloadHere
                packageTop:packageTopPath
                showSplashInLevels:showSplashInLevels - 1.
        ] ifFalse:[
            (noAutoloadHere not and:[haveAbbrevDotSTC not]) ifTrue:[
                f suffix = 'st' ifTrue:[
                    [
                        self installAutoloadedClassFromSourceFile:f.
                        f directory baseName = 'libbasic' ifTrue:[self halt].
                    ] on:FileStream openErrorSignal do:[:ex|
                        "ignore this file, but write a warning"
                        Transcript showCR:('Autoload: cannot install %1. (%2)' bindWith:f pathName with:ex description).
                    ].
                ]
            ].
        ]
    ].

    showSplashInLevels >= 0 ifTrue:[
        self showSplashMessage:('Smalltalk [info]: installing autoloaded classes from "%1"...'
                                bindWith:(dirName contractAtBeginningTo:35)).
    ].

    "
     Smalltalk installAutoloadedClasses
    "

    "Modified: / 01-08-2013 / 16:57:49 / cg"
!

replaceReferencesTo:anObject with:newRef
    "if the receiver refers to the argument, anObject, replace this reference with newRef.
     Return true, if any reference was changed.
     Notice: this does not change the class-reference."

    |toAdd|

    toAdd := OrderedCollection new.
    self keysAndValuesDo:[:key :val |
	(key == anObject) ifTrue:[
	    self shouldImplement.
	].
	(val == anObject ) ifTrue:[
	    toAdd add:(key -> newRef)
	].
    ].
    toAdd do:[:each |
	self at:(each key) put:(each value)
    ].
!

saveEmergencyImage:aBoolean
    "set/clear the flag which controls if ST/X should save an
     emergency image in case of a broken display connection.
     The default is true.
     This may be useful, if you work with an unsecure display
     (serial line), and want to have a chance of proceeding after
     a crash. In multiheaded applications, this only affects
     crashes of the master Display connection (the initial connection);
     errors on other displays are reported to the views and treated
     like window destroy from the windowManager."

    SaveEmergencyImage := aBoolean

    "Modified: / 24.10.1997 / 18:22:26 / cg"
!

systemOrganization
    "for partial ST80 compatibility;
     In ST80, Smalltalk organization returns a systemOrganizer, which
     keeps track of class-categories, while all classes return a classOrganizer
     from #organization, which keeps track of method categories of that class.
     Since in ST/X, Smalltalk is a class, there is now a conflict.
     To make a workaround possible, use #systemOrganization when porting
     VW apps to ST/X to get the class-categories.
     Read the documentation in SystemOrganizer for more info."

    ^ SystemOrganizer for:nil

    "Created: / 20.6.1998 / 12:24:02 / cg"
    "Modified: / 20.6.1998 / 12:41:34 / cg"
! !

!Smalltalk class methodsFor:'system management-fileIn'!

fileIn:aFileName
    "read in the named file - look for it in some standard places;
     return true if ok, false if failed.
     This method can load almost anything which makes sense:
	.st    - source files
	.cls   - binary smalltalk bytecode files
	.so    - binary compiled machine code class libraries
	[.class - java bytecode -- soon to come]"

    ^ self fileIn:aFileName lazy:nil silent:nil logged:false

    "
     Smalltalk fileIn:'source/TicTacToe.st'
     Smalltalk fileIn:'binary/TicTacToe.cls'
     Smalltalk fileIn:'binary/TicTacToe.so'
    "

    "Created: 28.10.1995 / 17:06:28 / cg"
!

fileIn:aFileName inPackage:aPackageID
    "read in the named file in a packages directory."

    |dir|

    dir := self getPackageDirectoryForPackage:aPackageID.
    dir isNil ifTrue:[^ false].

    dir := dir asFilename.
    ^ (self fileIn:(dir construct:aFileName))
      or:[ self fileIn:((dir construct:'source') construct:aFileName) ]
!

fileIn:aFileName lazy:lazy
    "read in the named file - look for it in some standard places;
     return true if ok, false if failed.
     If lazy is true, no code is generated for methods, instead stubs
     are created which compile themself when first executed. This allows
     for much faster fileIn (but slows down the first execution later).
     Since no syntax checks are done when doing lazy fileIn, use this only for
     code which is known to be syntactically correct."

    ^ self fileIn:aFileName lazy:lazy silent:nil logged:false

    "
     Smalltalk fileIn:'source/TicTacToe.st' lazy:true
    "

    "Created: 28.10.1995 / 17:06:36 / cg"
!

fileIn:aFileName lazy:lazy silent:silent
    "read in the named file - look for it in some standard places;
     return true if ok, false if failed.
     If lazy is true, no code is generated for methods, instead stubs
     are created which compile themself when first executed. This allows
     for much faster fileIn (but slows down the first execution later).
     Since no syntax checks are done when doing lazy fileIn, use this only for
     code which is known to be syntactically correct.
     If silent is true, no compiler messages are output to the transcript.
     Giving nil for silent/lazy will use the current settings."

    ^ self fileIn:aFileName lazy:lazy silent:silent logged:false

    "Created: 28.10.1995 / 17:06:41 / cg"
!

fileIn:aFileNameOrString lazy:lazy silent:silent logged:logged
    "read in the named file - look for it in some standard places;
     return true if ok, false if failed.
     If lazy is true, no code is generated for methods, instead stubs
     are created which compile themself when first executed. This allows
     for much faster fileIn (but slows down the first execution later).
     Since no syntax checks are done when doing lazy fileIn, use this only for
     code which is known to be syntactically correct.
     If silent is true, no compiler messages are output to the transcript.
     Giving nil for silent/lazy will use the current settings.
     This method can load almost anything which makes sense:
	.st    - source files
	.cls   - binary smalltalk bytecode files
	.so    - binary compiled machine code class libraries
	[.class - java bytecode -- soon to come]"

    |fileNameString inStream path morePath bos|

    fileNameString := aFileNameOrString asString.

    "
     an object or shared object ?
    "
    (ObjectFileLoader notNil
    and:[ObjectFileLoader hasValidBinaryExtension:fileNameString]) ifTrue:[
	"/ LoadBinaries ifFalse:[^ false].
	path := self getBinaryFileName:fileNameString.
	path isNil ifTrue:[
	    path := self getSystemFileName:fileNameString.
	].
	path isNil ifTrue:[^ false].
	^ (ObjectFileLoader loadObjectFile:path) notNil
    ].

    inStream := self systemFileStreamFor:fileNameString.
    inStream isNil ifTrue:[^ false].

    (fileNameString asFilename hasSuffix:'cls') ifTrue:[
	BinaryObjectStorage notNil ifTrue:[
	    [
		inStream binary.
		bos := BinaryObjectStorage onOld:inStream.
		bos next.
	    ] ensure:[
		bos close.
	    ].
	    ^ true
	].
	^ false
    ].

    (fileNameString includes:$/) ifTrue:[
	"/ temporarily prepend the file's directory
	"/ to the searchPath.
	"/ This allows fileIn-driver files to refer to local
	"/ files via a relative path, and drivers to fileIn other
	"/ drivers ...
	morePath := inStream pathName asFilename directoryName.
    ].
    ^ self fileInStream:inStream lazy:lazy silent:silent logged:logged addPath:morePath

    "
     Smalltalk fileIn:'clients/TicTacToe/TicTacToe.st' lazy:true silent:true
     Smalltalk fileIn:'keyboard.rc'
    "

    "Modified: / 08-09-2006 / 19:21:16 / cg"
!

fileIn:aFileName logged:logged
    "read in the named file - look for it in some standard places;
     return true if ok, false if failed.
     The argument logged controls, if the changefile is to be updated."

    ^ self fileIn:aFileName lazy:nil silent:nil logged:logged

    "
     Smalltalk fileIn:'source/TicTacToe.st' logged:false
    "
!

fileIn:aFileName silent:silent
    "read in the named file - look for it in some standard places;
     return true if ok, false if failed.
     If silent is true, no compiler messages are output to the transcript."

    ^ self fileIn:aFileName lazy:nil silent:silent logged:false

    "
     Smalltalk fileIn:'source/TicTacToe.st' silent:true
    "

    "Created: 28.10.1995 / 17:06:36 / cg"
!

fileInChanges
    "read in the last changes file - bringing the system to the state it
     had when left the last time.
     WARNING: this method is rubbish: it should only read things after the
	      last '**snapshot**' - entry
	      (instead of the complete changes file)."

    "
     do NOT update the changes file now ...
    "
    self fileIn:ChangeFileName logged:false

    "
     Smalltalk fileInChanges
    "
!

fileInClass:aClassName
    "find a source/object file for aClassName and -if found - load it.
     search is in some standard places trying driver-file (.ld), object-file (.o) and
     finally source file (.st) in that order.
     The file is first searched for using the class name, then the abbreviated name."

    ^ self
	fileInClass:aClassName
	package:nil
	initialize:true
	lazy:false
	silent:nil

    "Modified: / 9.1.1998 / 14:41:46 / cg"
!

fileInClass:aClassName fromObject:aFileName
    "read in the named object file and dynamic-link it into the system
     - look for it in some standard places.
     Only install the named class from this object file.
     Return true if ok, false if failed."

    |path ok|

    "
     check if the dynamic loader class is in
    "
    (LoadBinaries not or:[ObjectFileLoader isNil]) ifTrue:[^ false].

    (path := self getBinaryFileName:aFileName) isNil ifTrue:[^ false].
    ok := (ObjectFileLoader loadClass:aClassName fromObjectFile:path) notNil.
    ok ifTrue:[
	VerboseLoading ifTrue:[
	    Transcript show:'  loaded ' , aClassName , ' from ' ; showCR:aFileName.
	]
    ].
    ^ ok

    "
     Smalltalk fileInClass:'AbstractPath' fromObject:'../../goodies/Paths/AbstrPath.so'
     Smalltalk fileInClass:'ClockView' fromObject:'../../libwidg3/libwidg3.so'
    "

    "Modified: / 04-11-2011 / 13:42:24 / cg"
!

fileInClass:aClassName initialize:doInit
    "find a source/object file for aClassName and -if found - load it.
     search is in some standard places trying driver-file (.ld), object-file (.o) and
     finally source file (.st) in that order.
     The file is first searched for using the class name, then the abbreviated name."

    ^ self
	fileInClass:aClassName
	package:nil
	initialize:doInit
	lazy:false
	silent:nil

    "Modified: / 9.1.1998 / 14:42:02 / cg"
!

fileInClass:aClassName initialize:doInit lazy:loadLazy
    "find a source/object file for aClassName and -if found - load it.
     search is in some standard places trying driver-file (.ld), object-file (.o) and
     finally source file (.st) in that order.
     The file is first searched for using the class name, then the abbreviated name."

     ^ self
	fileInClass:aClassName
	package:nil
	initialize:doInit
	lazy:loadLazy
	silent:nil

    "Modified: / 9.1.1998 / 14:42:19 / cg"
!

fileInClass:aClassName initialize:doInit lazy:loadLazy silent:beSilent
    "find a source/object file for aClassName and -if found - load it.
     Search is in some standard places, trying driver-file (.ld), object-file (.so / .o) and
     finally source file (.st), in that order.
     The file is first searched for using the class name, then the abbreviated name.
     The argument doInit controlls if the class should be sent a #initialize after the
     load; loadLazy tells if it should be loaded lazily. beSilent tells if the compiler
     should not send notes to the transcript; it can be true, false or nil, where
     nil uses the value from SilentLoading."

    ^ self
        fileInClass:aClassName
        package:nil
        initialize:doInit
        lazy:loadLazy
        silent:beSilent

    "Modified: / 9.1.1998 / 14:42:28 / cg"
!

fileInClass:aClassName package:package
    "find a source/object file for aClassName and -if found - load it.
     search is in some standard places trying driver-file (.ld), object-file (.o) and
     finally source file (.st) in that order.
     The file is first searched for using the class name, then the abbreviated name."

    ^ self
	fileInClass:aClassName
	package:package
	initialize:true
	lazy:false
	silent:nil

    "Created: / 08-01-2007 / 10:06:09 / cg"
!

fileInClass:aClassName package:package initialize:doInit lazy:loadLazy silent:beSilent
    "find a source/object file for aClassName and -if found - load it.
     This is the workhorse for autoloading.
     Search is in some standard places, trying driver-file (.ld), object-file (.so / .o) and
     finally source file (.st), in that order.
     The file is first searched for using the class name, then the abbreviated name.
     The argument doInit controlls if the class should be sent a #initialize after the
     load; loadLazy tells if it should be loaded lazily. beSilent tells if the compiler
     should not send notes to the transcript; it can be true, false or nil, where
     nil uses the value from SilentLoading."

    |classFileName alternativeClassFileName libName newClass ok wasLazy wasSilent sharedLibExtension inStream mgr
     filenameToSet packageDir packageFile bos|

    ClassLoadInProgressQuery answerNotifyLoading:aClassName do:[

        wasLazy := Compiler compileLazy:loadLazy.
        beSilent notNil ifTrue:[
            wasSilent := self silentLoading:beSilent.
        ].

        classFileName := Smalltalk fileNameForClass:aClassName.
        (classFileName = aClassName) ifTrue:[
            "/ no abbrev.stc translation for className
            (aClassName includes:$:) ifTrue:[
                "/ a nameSpace name
                alternativeClassFileName := classFileName copyFrom:(classFileName lastIndexOf:$:)+1
            ].
        ].

        classFileName asFilename isAbsolute ifTrue:[
            classFileName asFilename suffix notEmptyOrNil ifTrue:[
                ok := self fileIn:classFileName lazy:loadLazy silent:beSilent.
            ] ifFalse:[
                ok := self fileInSourceFile:classFileName lazy:loadLazy silent:beSilent.
            ]
        ] ifFalse:[
            classFileName := classFileName copyReplaceAll:$: with:$_ ifNone:classFileName.
            [
                Class withoutUpdatingChangesDo:[
                    |zarFn zar entry|

                    ok := false.

                    package notNil ifTrue:[
                        packageDir := package asPackageId packageDirectory.
                        "/ packageDir := package asString.
                        "/ packageDir := packageDir copyReplaceAll:$: with:$/.
                        packageDir isNil ifTrue:[
                            packageDir := self getPackageDirectoryForPackage:package
                        ].
                        packageDir notNil ifTrue:[
                            packageDir := packageDir asFilename.
                        ].
                    ].

                    Class packageQuerySignal answer:package do:[
                        "
                         then, if dynamic linking is available,
                        "
                        (LoadBinaries and:[ObjectFileLoader notNil]) ifTrue:[
                            sharedLibExtension := ObjectFileLoader sharedLibraryExtension.
                            "
                             first look for a class packages shared binary in binary/xxx.o
                            "
                            libName := self libraryFileNameOfClass:aClassName.
                            libName notNil ifTrue:[
                                (ok := self fileInClass:aClassName fromObject:(libName, sharedLibExtension))
                                ifFalse:[
                                    sharedLibExtension ~= '.o' ifTrue:[
                                        ok := self fileInClass:aClassName fromObject:(libName, '.o')
                                    ]
                                ].
                            ].
                            "
                             then, look for a shared binary in binary/xxx.o
                            "
                            ok ifFalse:[
                                (ok := self fileInClass:aClassName fromObject:(classFileName, sharedLibExtension))
                                ifFalse:[
                                    sharedLibExtension ~= '.o' ifTrue:[
                                        ok := self fileInClass:aClassName fromObject:(classFileName, '.o')
                                    ].
                                    ok ifFalse:[
                                        alternativeClassFileName notNil ifTrue:[
                                            (ok := self fileInClass:aClassName fromObject:(alternativeClassFileName, sharedLibExtension))
                                            ifFalse:[
                                                sharedLibExtension ~= '.o' ifTrue:[
                                                    ok := self fileInClass:aClassName fromObject:(alternativeClassFileName, '.o')
                                                ]
                                            ]
                                        ].
                                    ].
                                ].
                            ].
                        ].

                        "
                         if that did not work, look for a compiled-bytecode file ...
                        "
                        ok ifFalse:[
                            (ok := self fileIn:(classFileName , '.cls') lazy:loadLazy silent:beSilent)
                            ifFalse:[
                                alternativeClassFileName notNil ifTrue:[
                                    ok := self fileIn:(alternativeClassFileName , '.cls') lazy:loadLazy silent:beSilent
                                ]
                            ]
                        ].
                        "
                         if that did not work, and the classes package is known,
                         look for an st-cls file
                         in a package subdir of the source-directory ...
                        "
                        ok ifFalse:[
                            (packageDir notNil and:[BinaryObjectStorage notNil]) ifTrue:[
                                packageFile := self getPackageFileName:((packageDir / 'classes' / classFileName) addSuffix:'cls').
                                packageFile isNil ifTrue:[
                                    packageFile := (packageDir / 'classes' / classFileName) addSuffix:'cls'.
                                ].
                                (ok := self fileIn:packageFile lazy:loadLazy silent:beSilent)
                                ifFalse:[
                                    alternativeClassFileName notNil ifTrue:[
                                        packageFile := self getPackageFileName:((packageDir / 'classes' / alternativeClassFileName) addSuffix:'cls').
                                        packageFile isNil ifTrue:[
                                            packageFile := ((packageDir / 'classes' / alternativeClassFileName) addSuffix:'cls').
                                        ].
                                        ok := self fileIn:packageFile lazy:loadLazy silent:beSilent
                                    ]
                                ].

                                zarFn := self getPackageFileName:(packageDir / 'classes.zip').
                                zarFn notNil ifTrue:[
                                    zar := ZipArchive oldFileNamed:zarFn.
                                    zar notNil ifTrue:[
                                        entry := zar extract:(classFileName , '.cls').
                                        (entry isNil and:[alternativeClassFileName notNil]) ifTrue:[
                                            entry := zar extract:(alternativeClassFileName , '.cls').
                                        ].
                                        entry notNil ifTrue:[
                                            bos := BinaryObjectStorage onOld:(entry asByteArray readStream).
                                            bos next.
                                            bos close.
                                            ok := true
                                        ].
                                    ]
                                ]
                            ]
                        ].

                        "
                         if that did not work, look for an st-source file ...
                        "
                        ok ifFalse:[
                            filenameToSet := classFileName.
                            (ok := self fileInSourceFile:filenameToSet lazy:loadLazy silent:beSilent)
                            ifFalse:[
                                alternativeClassFileName notNil ifTrue:[
                                    filenameToSet := alternativeClassFileName.
                                    ok := self fileInSourceFile:filenameToSet lazy:loadLazy silent:beSilent
                                ].
                                ok ifFalse:[
                                    "
                                     ... and in the standard source-directory
                                    "
                                    filenameToSet := 'source' asFilename / classFileName.
                                    (ok := self fileInSourceFile:filenameToSet lazy:loadLazy silent:beSilent)
                                    ifFalse:[
                                        alternativeClassFileName notNil ifTrue:[
                                            filenameToSet := 'source' asFilename / alternativeClassFileName.
                                            ok := self fileInSourceFile:filenameToSet lazy:loadLazy silent:beSilent
                                        ]
                                    ]
                                ]
                            ].
                            "
                             if that did not work, and the classes package is known,
                             look for an st-source file
                             in a package subdir of the source-directory ...
                            "
                            ok ifFalse:[
                                packageDir notNil ifTrue:[
                                    packageFile := self getPackageSourceFileName:(packageDir / 'source' / classFileName).
                                    packageFile isNil ifTrue:[
                                        packageFile := (packageDir / 'source' / classFileName).
                                    ].
                                    filenameToSet := packageFile.
                                    (ok := self fileInSourceFile:packageFile lazy:loadLazy silent:beSilent)
                                    ifFalse:[
                                        alternativeClassFileName notNil ifTrue:[
                                            packageFile := self getPackageSourceFileName:(packageDir / 'source' / alternativeClassFileName).
                                            packageFile isNil ifTrue:[
                                                packageFile := (packageDir / 'source' / alternativeClassFileName).
                                            ].
                                            filenameToSet := packageFile.
                                            ok := self fileInSourceFile:packageFile lazy:loadLazy silent:beSilent
                                        ].
                                        ok ifFalse:[
                                            packageFile := self getPackageSourceFileName:(packageDir / classFileName).
                                            packageFile isNil ifTrue:[
                                                packageFile := (packageDir / classFileName).
                                            ].
                                            filenameToSet := packageFile.
                                            (ok := self fileInSourceFile:packageFile lazy:loadLazy silent:beSilent)
                                            ifFalse:[
                                                alternativeClassFileName notNil ifTrue:[
                                                    packageFile := self getPackageFileName:(packageDir / alternativeClassFileName).
                                                    packageFile isNil ifTrue:[
                                                        packageFile := packageDir / alternativeClassFileName.
                                                    ].
                                                    filenameToSet := packageFile.
                                                    ok := self fileInSourceFile:packageFile lazy:loadLazy silent:beSilent
                                                ].
                                                ok ifFalse:[
                                                    "
                                                     ... and in the standard source-directory
                                                    "
                                                    filenameToSet := 'source' asFilename / packageDir / classFileName.
                                                    (ok := self fileInSourceFile:filenameToSet lazy:loadLazy silent:beSilent)
                                                    ifFalse:[
                                                        alternativeClassFileName notNil ifTrue:[
                                                            filenameToSet := 'source' asFilename / packageDir / alternativeClassFileName.
                                                            ok := self fileInSourceFile:filenameToSet lazy:loadLazy silent:beSilent
                                                        ]
                                                    ]
                                                ]
                                            ].
                                        ].
                                    ].
                                ]
                            ].
                            "
                             if that did not work, and the classes package is known,
                             look for a zipArchive containing a class entry.
                            "
                            ok ifFalse:[
                                packageDir notNil ifTrue:[
                                    zarFn := self getPackageFileName:(packageDir / 'source.zip').
                                    zarFn isNil ifTrue:[
                                        zarFn := packageDir withSuffix:'zip'.
                                        zarFn := self getSourceFileName:zarFn.
                                    ].
                                    (zarFn notNil and:[zarFn asFilename exists]) ifTrue:[
                                        zar := ZipArchive oldFileNamed:zarFn.
                                        zar notNil ifTrue:[
                                            entry := zar extract:(classFileName , '.st').
                                            (entry isNil and:[alternativeClassFileName notNil]) ifTrue:[
                                                entry := zar extract:(alternativeClassFileName , '.st').
                                            ].
                                            entry notNil ifTrue:[
                                                filenameToSet := zarFn.
                                                ok := self
                                                        fileInStream:(entry asString readStream)
                                                        lazy:loadLazy
                                                        silent:beSilent
                                                        logged:false
                                                        addPath:nil
                                            ].
                                        ]
                                    ]
                                ]
                            ].

                            "
                             if that did not work,
                             look for a zipArchive containing a class entry.
                            "
                            ok ifFalse:[
                                zarFn := self getSourceFileName:'source.zip'.
                                zarFn notNil ifTrue:[
                                    zar := ZipArchive oldFileNamed:zarFn.
                                    zar notNil ifTrue:[
                                        entry := zar extract:(zarFn := classFileName , '.st').
                                        (entry isNil and:[alternativeClassFileName notNil]) ifTrue:[
                                            entry := zar extract:(zarFn := alternativeClassFileName , '.st').
                                        ].
                                        entry notNil ifTrue:[
                                            filenameToSet := zarFn.
                                            ok := self
                                                    fileInStream:(entry asString readStream)
                                                    lazy:loadLazy
                                                    silent:beSilent
                                                    logged:false
                                                    addPath:nil
                                        ].
                                    ]
                                ]
                            ].
                            ok ifFalse:[
                                "
                                 if there is a sourceCodeManager, ask it for the classes sourceCode
                                "
                                (mgr := Smalltalk at:#SourceCodeManager) notNil ifTrue:[
                                    inStream := mgr getMostRecentSourceStreamForClassNamed:aClassName inPackage:package.
                                    inStream notNil ifTrue:[
                                        filenameToSet := nil.
                                        ok := self fileInStream:inStream lazy:loadLazy silent:beSilent logged:false addPath:nil.
                                    ]
                                ].
                            ].
                        ].
                    ]
                ].
            ] ensure:[
                Compiler compileLazy:wasLazy.
                wasSilent notNil ifTrue:[
                    self silentLoading:wasSilent
                ]
            ].
        ].

        ok ifTrue:[
            newClass := self at:(aClassName asSymbol).
            newClass notNil ifTrue:[
                "set the classes name - but do not change if already set"
                filenameToSet notNil ifTrue:[
                    newClass getClassFilename isNil ifTrue:[
                        newClass setClassFilename:(filenameToSet asFilename baseName)
                    ].
                ].

                doInit ifTrue:[
                    newClass initialize
                ]
            ]
        ].
    ].

    ^ newClass

    "Created: / 09-01-1998 / 14:40:32 / cg"
    "Modified: / 05-06-1999 / 14:53:01 / cg"
    "Modified: / 16-08-2009 / 14:52:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-06-2016 / 07:52:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileInClassLibrary:aClassLibraryName
    "find an object file containing a binary class library in some standard places
     and load it. This install all of its contained classes.
     Return true if ok, false if not.
     Notice: the argument may not have an extension (by purpose);
	     the sharedLib extension (.dll / .so / .sl) is added here, to
	     make the caller independent of the underlying operatingSystem."

    |path fn|

    ObjectFileLoader isNil ifTrue:[
	^ PackageLoadError raiseRequestWith:aClassLibraryName errorString:' - no ObjectFileLoader'.
    ].

    fn := aClassLibraryName asFilename withSuffix:(ObjectFileLoader sharedLibrarySuffix).
    fn := fn pathName.

    path := self getBinaryFileName:fn.
    path isNil ifTrue:[
	path := self getSystemFileName:fn.
    ].
    path isNil ifTrue:[
	^ PackageNotFoundError raiseRequestWith:aClassLibraryName.
    ].

    (ObjectFileLoader loadObjectFile:path) isNil ifTrue:[
	^ PackageLoadError raiseRequestWith:aClassLibraryName.
    ].
    ^ true.


    "
     Smalltalk fileInClassLibrary:'libtable'
     Smalltalk fileInClassLibrary:'binary/libwidg3'
    "

    "Modified: 8.1.1997 / 17:58:56 / cg"
!

fileInClassLibrary:aClassLibraryName inPackage:packageID
    "find an object file containing a binary class library in some standard places
     and load it. This installs all of its contained classes.
     Return true if ok, false if not.
     Notice: the argument may not have an extension (by purpose);
	     the sharedLib extension (.dll / .so / .sl) is added here, to
	     make the caller independent of the underlying operatingSystem."

    |baseName handle libraryFilename packagePath|

    ObjectFileLoader isNil ifTrue:[
	^ PackageLoadError raiseRequestWith:packageID errorString:' - no ObjectFileLoader'
    ].

    baseName := aClassLibraryName asFilename withSuffix:(ObjectFileLoader sharedLibrarySuffix).
    baseName exists ifTrue:[
	"/ load local file first...
	handle := ObjectFileLoader loadObjectFile:baseName.
    ].
    handle isNil ifTrue:[
	packagePath := self getPackageDirectoryForPackage:packageID.
	packagePath isNil ifTrue:[
	    ^ PackageNotFoundError raiseRequestWith:packageID.
	].
	packagePath := packagePath asFilename.
	libraryFilename := packagePath / baseName.
	libraryFilename exists ifFalse:[
	    libraryFilename := nil.
	    #('objbc' 'objvc') do:[:eachPossibleCompiledCodeDir |
		"in windows, with Borland compiler, DLLs in development environment are under objbc;
		 with MSVC, they are under objvc"
		libraryFilename isNil ifTrue:[
		    libraryFilename := packagePath / eachPossibleCompiledCodeDir / baseName.
		    libraryFilename exists ifFalse:[ libraryFilename := nil ]
		].
	    ].
	].
	(libraryFilename notNil and:[libraryFilename exists]) ifTrue:[
	    handle := ObjectFileLoader loadObjectFile:libraryFilename pathName.
	].
    ].

    handle isNil ifTrue:[
	^ PackageNotFoundError raiseRequestWith:packageID.
    ].
"/    handle notNil ifTrue:[
"/        Transcript showCR:('    Smalltalk: loaded %1.' bindWith:libraryFilename pathName).
"/    ].
    ^ true.

    "
     Smalltalk fileInClassLibrary:'libtable'
     Smalltalk fileInClassLibrary:'binary/libwidg3'
     Smalltalk fileInClassLibrary:'refactoryBrowser' inPackage:'stx:goodies/refactoryBrowser'
    "

    "Modified: / 08-10-2011 / 00:08:51 / cg"
!

fileInSourceFile:filenameArg lazy:loadLazy silent:beSilent
    "Try all available programming languages"

    |filename|

    filename := filenameArg asFilename.
"/    ProgrammingLanguage allDo:[:lang|
"/        | f |
"/
"/        "/ cg: changed: did try all languages to load (eg. wether suffix matched or not.
"/        "/ I don't think, that is a good idea, as all of them languages might start parsing...
"/        (filename hasSuffix:lang sourceFileSuffix) ifTrue:[
"/            (self fileIn:f lazy:loadLazy silent:beSilent) ifTrue:[
"/                ^ true
"/            ].
"/        ]
"/    ].
"/ revert to old code to get stuff running again- please review - (autoload problems)
    ProgrammingLanguage allDo:[:lang| | f |
	f := (filename hasSuffix:lang sourceFileSuffix)
		    ifTrue:[filename]
		    ifFalse:[filename addSuffix:lang sourceFileSuffix].
	(self fileIn:f lazy:loadLazy silent:beSilent)
		ifTrue:[^ true]
    ].

    ^ false

    "Created: / 16-08-2009 / 14:45:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileInStream:streamArg
    ^ self fileInStream:streamArg lazy:nil silent:nil logged:false addPath:nil
!

fileInStream:streamArg lazy:lazy silent:silent logged:logged addPath:morePath
    "read sourceCode from aStream;
     return true if ok, false if failed.
     If lazy is true, no code is generated for methods, instead stubs
     are created which compile themself when first executed. This allows
     for much faster fileIn (but slows down the first execution later).
     Since no syntax checks are done when doing lazy fileIn, use this only for
     code which is known to be syntactically correct.
     If silent is true, no compiler messages are output to the transcript.
     Giving nil for silent/lazy will use the current settings.
     If morePath is nonNil, it is prepended to the systemPath temporarily during the
     fileIn. This allows for st-expressions to refer to more files (i.e. fileIn more)
     using a relative path."

    |inStream wasLazy wasSilent oldSystemPath oldRealPath|

    inStream := streamArg.
    inStream isNil ifTrue:[^ false].
    inStream isLineNumberReadStream ifFalse:[
        LineNumberReadStream notNil ifTrue:[
            "/ sigh - is in libbasic2, which is not always present
            inStream := LineNumberReadStream on:inStream.
        ].
    ].
    inStream := EncodedStream isNil
                    ifTrue:[ inStream ]
                    ifFalse:[ EncodedStream decodedStreamFor:inStream ].

    lazy notNil ifTrue:[wasLazy := Compiler compileLazy:lazy].
    silent notNil ifTrue:[wasSilent := self silentLoading:silent].
    morePath notNil ifTrue:[
        oldSystemPath := SystemPath copy.
        SystemPath addFirst:morePath.
        oldRealPath := RealSystemPath.
        RealSystemPath := nil.
    ].

    [
        (Class updateChangeFileQuerySignal , Class updateChangeListQuerySignal) answer:logged do:[
            "JV: Changed to give ProgrammingLanguage to choose
             proper reader"
            (ProgrammingLanguage forStream: inStream) fileInStream: inStream
        ]
    ] ensure:[
        morePath notNil ifTrue:[
            "take care, someone could have changed SystemPath during fileIn!!"
            (SystemPath copyFrom:2) = oldSystemPath ifTrue:[
                SystemPath := oldSystemPath.
                RealSystemPath := oldRealPath.
            ] ifFalse:[
                (oldSystemPath includes:morePath) ifFalse:[
                    SystemPath remove:morePath ifAbsent:[].
                ].
                RealSystemPath := nil.
            ].
        ].
        lazy notNil ifTrue:[Compiler compileLazy:wasLazy].
        silent notNil ifTrue:[self silentLoading:wasSilent].
        inStream close
    ].
    ^ true

    "
     Smalltalk fileInStream:('source/TicTacToe.st' asFilename readStream) lazy:true silent:true
    "

    "Modified: / 05-11-1996 / 20:03:35 / cg"
    "Modified: / 16-08-2009 / 11:06:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isClassLibraryLoaded:name
    "return true, if a particular class library is already loaded"

    ObjectMemory
	binaryModuleInfo
	    do:[:entry |
		   entry type == #classLibrary ifTrue:[
		       entry libraryName = name ifTrue:[
			  ^ true        "/ already loaded
		       ]
		   ].
	       ].

    ^ false

    "
     Smalltalk isClassLibraryLoaded:'libstx_libbasic'
     Smalltalk isClassLibraryLoaded:'libstx_libwidg3'
     Smalltalk isClassLibraryLoaded:'libstx_libboss'
    "

    "Modified: / 23-08-2006 / 15:54:46 / cg"
!

loadClassLibraryIfAbsent:name
    "dynamically load a classLibrary, if not already loaded
     and the system supports dynamic loading.
     Return true, if the library is loaded, false if not.
     This entry is called without system specific filename
     extensions - it is portable among different architectures
     as long as corresponding files (x.so / x.dll / x.sl / x.o)
     are be present ..."

    (self isClassLibraryLoaded:name) ifTrue:[ ^ true ].  "/ already loaded
    ^ self fileInClassLibrary:name

    "
     Smalltalk loadClassLibraryIfAbsent:'libbasic'
     Smalltalk loadClassLibraryIfAbsent:'libwidg3'
    "

    "Modified: 31.10.1996 / 16:57:24 / cg"
!

secureFileIn:aFileName
    "read in the named file, looking for it at standard places.
     Catch various errors during fileIn.
     Return true if ok, false if failed"

    |retVal|

    Parser isNil ifTrue:[^ false].      "/ for small stand alone apps.
    retVal := false.

    (SignalSet
	with:AbortOperationRequest
	with:TerminateProcessRequest
	with:Parser parseErrorSignal)
	    handle:[:ex | ex return ]
	    do:[ retVal := self fileIn:aFileName ].
    ^ retVal
!

silentFileIn:aFilename
    "same as fileIn:, but do not output 'compiled...'-messages on Transcript.
     Main use is during startup."

    self silentlyLoadingDo:[
	self fileIn:aFilename
    ].
! !

!Smalltalk class methodsFor:'system management-files'!

addIdeTopDirectoryToPackagePath
    "{ Pragma: +optSpace }"

    |topDirectory|

    (topDirectory := OperatingSystem pathOfSTXExecutable) notNil ifTrue:[
        topDirectory := topDirectory asFilename.
        (topDirectory directory / 'stc') exists ifTrue:[
            topDirectory := topDirectory directory.
        ] ifFalse:[
            (topDirectory directory directory / 'stc') exists ifTrue:[
                topDirectory := topDirectory directory directory.
            ] ifFalse:[
                (topDirectory directory directory directory / 'stc') exists ifTrue:[
                    topDirectory := topDirectory directory directory directory.
                ] ifFalse:[
                    topDirectory := nil
                ].
            ].
        ].
        topDirectory notNil ifTrue:[
            "/ one above "stx"
            topDirectory := topDirectory directory pathName.
            (PackagePath includes:topDirectory) ifFalse:[
                PackagePath add:topDirectory
            ]
        ]
    ].
!

addWorkspaceDirectoryToPackagePath
    "{ Pragma: +optSpace }"

    |workspaceDirectory|

    (workspaceDirectory := UserPreferences current workspaceDirectory) notNil ifTrue:[
        (workspaceDirectory := workspaceDirectory asFilename) exists ifTrue:[
            workspaceDirectory := workspaceDirectory pathName.
            (PackagePath includes:workspaceDirectory) ifFalse:[
                PackagePath addFirst:workspaceDirectory
            ]
        ]
    ].
!

bitmapFileStreamFor:aFileName
    "search aFileName in some standard places;
     return a readonly fileStream or nil if not found.
     Searches in subdirectories named 'bitmaps' in the SystemPath.
     Notice: this does not look in the package-specific bitmaps directories."

    |aString|

    aString := self getBitmapFileName:aFileName.
    aString notNil ifTrue:[
	^ aString asFilename readStreamOrNil
    ].
    ^ nil
!

bitmapFromFileNamed:aFileName forClass:aClass
    "backward compatibility:
     search aFileName in some standard places:
     first in the redefinable bitmaps path,
     then in the classes own package directory if existing.
     Return an image or nil."

    ^ self imageFromFileNamed:aFileName forClass:aClass

    "
     Smalltalk bitmapFromFileNamed:'SmalltalkX.xbm' forClass:View
    "
!

bitmapFromFileNamed:aFileName inPackage:aPackage
    "backward compatibility:
     search aFileName in some standard places:
     first in the redefinable bitmaps path,
     then in the package directory if existing.
     Return an image or nil."

    ^ self imageFromFileNamed:aFileName inPackage:aPackage

    "
     Smalltalk bitmapFromFileNamed:'SmalltalkX.xbm' inPackage:'stx:libview'
     Smalltalk bitmapFromFileNamed:'SmalltalkX.xbm' inPackage:'stx:libtool'
    "
!

classNameForFile:aFileName
    "return the className which corresponds to an abbreviated fileName,
     or nil if no special translation applies. The given filename arg may
     include a '.st' suffix (but no other)."

    |fn|

    (aFileName asFilename hasSuffix:'st') ifTrue:[
	fn := aFileName copyButLast:3
    ] ifFalse:[
	fn := aFileName
    ].
    ^ self filenameAbbreviations keyAtEqualValue:fn ifAbsent:[fn].

    "
     Smalltalk classNameForFile:'DrawObj'
     Smalltalk classNameForFile:'DrawObj.st'
     Smalltalk classNameForFile:'ArrColl.st'
     Smalltalk classNameForFile:'ArrColl.chg'
    "

    "Modified: 11.12.1995 / 14:51:10 / cg"
!

constructPathFor:aDirectoryName
    "search for aDirectory in SystemPath;
     return a collection of paths which include that directory."

    ^ self realSystemPath select:[:dirName |
        |fullPath|

        fullPath := dirName asFilename construct:aDirectoryName.
        "/ fullPath exists and:[fullPath isDirectory and:[fullPath isReadable]]
        fullPath isDirectory and:[fullPath isReadable]
    ].
!

fileInFileStreamFor:aFileName
    "obsolete
     search aFileName in some standard places;
     return a readonly fileStream or nil if not found.
     Searches in subdirectories named 'fileIn' in SystemPath"

    |aString|

    aString := self getFileInFileName:aFileName.
    aString notNil ifTrue:[
	^ aString asFilename readStreamOrNil
    ].
    ^ nil
!

fileNameForClass:aClassOrClassName
    "return a actual or expected (or most wanted) filename for aClassOrClassName
     - only the base name (without directory part) and without suffix."

    |cls nonMetaclass nm nameWithPrefix nameWithoutPrefix compatQuery compatPkg |

"/  This was added as an extension of libsvn - should be no longer needed
"/  JV@2012-09-25: but it actually is. The problem is that class filename
"/  is stored in the class itself and used to generate abbrev.stc and
"/  prerequisites in makefiles. But if you renamed such a stc-compiled class,
"/  the filename remains the same, but SVN __ALWAYS__ keep container name
"/  and class name in sync. Therefore build files gets messed up. Indeed, this
"/  should be fixed in code that files-out the package and generates build files.
"/  Certainly a hack, but do not remove this until fixed elsewhere

    compatQuery := Smalltalk classNamed: 'SVN::CompatModeQuery'.
    (compatQuery notNil
      and:[compatQuery isLoaded
	and:[compatQuery query not]]) ifTrue:[
	    nm := aClassOrClassName isBehavior
		ifTrue:[aClassOrClassName name]
		ifFalse:[aClassOrClassName].
	    nm := nm copyReplaceAll:$: with:$_ ifNone:nm.
	    ^nm
    ].

    "/ Same for another query for new libscm. Here we have to do
    "/ this only for packages that are being filed out and NOT for others.
    "/ The problem is that this method is also used for getting filenames
    "/ of classes OUTSIDE filed-out package when generating makefile dependencies.
    compatQuery := Smalltalk classNamed: 'SCMCompatModeQuery'.
    (compatQuery notNil
      and:[compatQuery isLoaded
	and:[(compatPkg := compatQuery query) notNil]]) ifTrue:[
	    | compatPkgs |
	    "/ Originally libscm could only fileout one package at time so
	    "/ the query answered one package name. However, to support nested
	    "/ packages, libscm is being rewritten to commit multiple packages
	    "/ at once, so query answers a collection of packages. The code below
	    "/ makes sure it works for both.
	    compatPkgs := compatPkg isString ifTrue:[ Array with: compatPkg] ifFalse:[ compatPkg ].
	    nm := aClassOrClassName isBehavior
		ifTrue:[aClassOrClassName name]
		ifFalse:[aClassOrClassName].
	    cls := Smalltalk at: nm asSymbol.
	    (cls notNil and:[compatPkgs includes: cls package]) ifTrue:[
		nm := nm copyReplaceAll:$: with:$_.
		^nm
	    ].
    ].

    aClassOrClassName isBehavior ifTrue:[
	cls := aClassOrClassName.
    ] ifFalse:[
	cls := Smalltalk classNamed:aClassOrClassName.
	cls isNil ifTrue:[
	    nameWithPrefix := aClassOrClassName.
	    nameWithoutPrefix := (aClassOrClassName copyFrom:(aClassOrClassName lastIndexOf:$:)+1).
	].
    ].

    cls notNil ifTrue:[
	nonMetaclass := cls theNonMetaclass.
	nm := nonMetaclass getClassFilename.
	nm isNil ifTrue:[
	    |revisionInfo|

	    (revisionInfo := cls revisionInfo) notNil ifTrue:[
		nm := revisionInfo fileName.
	    ].
	].
	nm notNil ifTrue:[
	    ^ nm asFilename withoutSuffix baseName
	].
	nameWithPrefix := nonMetaclass name.
	nameWithoutPrefix := nonMetaclass nameWithoutPrefix.
    ].

    CachedAbbreviations notNil ifTrue:[
	nameWithPrefix := nameWithPrefix asSymbol.
	(CachedAbbreviations includesKey:nameWithPrefix) ifTrue:[
	    ^ (CachedAbbreviations at:nameWithPrefix) asFilename baseName
	].
	nameWithoutPrefix := nameWithoutPrefix asSymbol.
	(CachedAbbreviations includesKey:nameWithoutPrefix) ifTrue:[
	    ^ (CachedAbbreviations at:nameWithoutPrefix) asFilename baseName
	].
    ].

    ^ nameWithPrefix copyReplaceAll:$: with:$_

    "
     Smalltalk fileNameForClass:#Complex
     Smalltalk fileNameForClass:'SmallInteger'
     Smalltalk fileNameForClass:'UnixOperatingSystem'
     Smalltalk fileNameForClass:'Launcher'
     Smalltalk fileNameForClass:'SomeUnknownClass'

     Smalltalk fileNameForClass:HTML::Encoder
     Smalltalk fileNameForClass:OSI::FTAMOperation
     Smalltalk fileNameForClass:'OSI::Foobar'
     Smalltalk fileNameForClass:(Workflow::UnsuccessfulFinishReasons)
     Workflow::UnsuccessfulFinishReasons classFilename
    "

    "Modified: / 06-10-2006 / 16:16:01 / cg"
    "Modified: / 23-02-2014 / 10:39:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-02-2014 / 12:39:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filenameAbbreviations
    "return a dictionary containing the classname-to-filename
     mappings. (needed for sys5.3 users, where filenames are limited
     to 14 chars)"

    CachedAbbreviations isNil ifTrue:[
	self readAbbreviations
    ].
    ^ CachedAbbreviations

    "flush with:

     CachedAbbreviations := nil
    "
    "
     Smalltalk filenameAbbreviations
    "
!

findPackageDirectoryForPackage:aPackage
    "find a packages directory along a number of standard places"

    |relDir|

    relDir := Smalltalk relativePackagePathForPackage:aPackage.
    relDir asFilename isAbsolute ifTrue:[^ relDir].

    ^ Smalltalk getPackageFileName:relDir.

    "
     Smalltalk findPackageDirectoryForPackage:'stx:libview/resources'
     Smalltalk findPackageDirectoryForPackage:'stx:libview'
    "
!

flushPathCaches
    "{ Pragma: +optSpace }"

    "forget pathCaches - these are collections containing valid directory names,
     where system files (resource, bitmaps etc.) are found.
     A flush is only required, if a new system directory has been created while
     the system is active, and those files should override the others
     (for example, if you created a private resource directory)"

    RealSystemPath := ResourcePath := SourcePath :=
    BinaryPath := FileInPath := nil.

    "
     Smalltalk flushPathCaches
    "
!

getBinaryFileName:aFileName
    "obsolete
     search aFileName in some standard places
     (subdirectories named 'binary' in SystemPath);
     return the absolute filename or nil if none is found."

    BinaryPath isNil ifTrue:[
	BinaryPath := self constructPathFor:BinaryDirName
    ].

    ^ self searchPath:BinaryPath for:aFileName in:BinaryDirName

    "Modified: 18.7.1996 / 15:53:49 / cg"
!

getBitmapFileName:aFileName
    "for backward compatibility:
     search aFileName in some standard places
     (subdirectories named 'bitmaps' in SystemPath);
     Return the pathName or nil if none is found."

    ^ self getBitmapFileName:aFileName forPackage:nil

    "
     Smalltalk getBitmapFileName:'SBrowser.xbm'
    "

    "Modified: 18.7.1996 / 15:53:55 / cg"
!

getBitmapFileName:aFileName forPackage:aPackageIDOrNil
    "for backward compatibility.
     search aFileName in some standard places:
     first in the redefinable bitmaps path,
     then in the package directory if existing.
     Return a path or nil.
     Search order is:
	bitmaps/<pkg>/file
	resources/<pkg>/bitmaps/file
	<pkg>/bitmaps/file
    "

    |f dir packageDir pF|

    f := aFileName asString withoutPrefix:'bitmaps/'.

    aPackageIDOrNil isNil ifTrue:[
	"/ this will be an error in the future
"/        'Smalltalk [warning]: bitmap file access without package: ' infoPrint. aFileName infoPrintCR.
"/        self halt.

	pF := self searchPath:(self realSystemPath) for:aFileName in:('bitmaps').
	pF notNil ifTrue:[
	    ^ pF.
	].
	f ~= aFileName ifTrue:[
	    pF := self searchPath:(self realSystemPath) for:f in:('bitmaps').
	    pF notNil ifTrue:[
		^ pF.
	    ].
	].
	^ nil
    ].

    dir := self projectDirectoryForPackage:aPackageIDOrNil.
    dir notNil ifTrue:[
	pF := dir asFilename / f.
	pF exists ifTrue:[
	    ^ pF.
	].
	pF := dir asFilename / 'bitmaps' /f.
	pF exists ifTrue:[
	    ^ pF.
	].
    ].

    packageDir := aPackageIDOrNil copyReplaceAll:$: with:$/.

    pF := self searchPath:(self realSystemPath) for:aFileName in:('bitmaps/',packageDir).
    pF notNil ifTrue:[
	^ pF.
    ].
    pF := self searchPath:(self realSystemPath) for:aFileName in:('resources/',packageDir,'/bitmaps').
    pF notNil ifTrue:[
	^ pF.
    ].

    ^ nil

    "
     Smalltalk imageFromFileNamed:'SmalltalkX.xbm' inPackage:'stx:libview'
     Smalltalk imageFromFileNamed:'SmalltalkX.xbm' inPackage:'stx:libtool'
     Smalltalk imageFromFileNamed:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'
     Smalltalk imageFromFileNamed:'CheckOn10_xp.xpm' inPackage:'stx:libwidg'
    "

    "Modified: / 11-10-2006 / 13:53:18 / cg"
!

getFileInFileName:aFileName
    "obsolete
     search aFileName in some standard places
     (subdirectories named 'fileIn' in SystemPath);
     return the absolute filename or nil if none is found."

    FileInPath isNil ifTrue:[
	FileInPath := self constructPathFor:FileInDirName
    ].

    ^ self searchPath:FileInPath for:aFileName in:FileInDirName

    "Modified: 18.7.1996 / 15:53:59 / cg"
!

getPackageDirectoryForPackage:aPackageId
    "Return a directory containing a given package (its resoruces, bitmaps, sources and
     other files).

     The directory is looked up as following:

         * package path is searched. If found, matching directory is returned.
           (see #packagePath and #initPackagePath)
         * then directories named 'packages' under system path are searched.
           If found, matching directory is returned.
           (see #systemPath and #initSystemPath)
         * Otherwise, nil is returned (meaning no package directory for given package
           is found)
    "

    |packageDirName packageDir|

    packageDirName := aPackageId asPackageId string copyReplaceAll:$: with:$/.

    packageDir := self getPackageFileName:packageDirName.
    packageDir isNil ifTrue:[
        ^ nil.
    ].
    ^ packageDir asFilename

    "
     Smalltalk packageDirectoryForPackageId:'stx:libbasic'
     Smalltalk packageDirectoryForPackageId:'stx:goodies/persistency'
     Smalltalk packageDirectoryForPackageId:'exept:ctypes'
    "

    "Modified: / 06-10-2006 / 11:49:27 / cg"
    "Modified: / 28-06-2016 / 07:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getPackageFileName:aFileName
    "search aFileName in some standard places
     (packagePath and subdirectories named 'packages' in SystemPath);
     return the absolute filename or nil if none is found."

    |f|

    "/ search along packagePath ...
    f := self searchPath:self packagePath for:aFileName in:nil.
    f isNil ifTrue:[
	"/ search under packages-directory along systemPath ...
	f := self searchPath:self realSystemPath for:aFileName in:PackageDirName.
	"/ kludge - allow for stx-directory to be named differently
	f isNil ifTrue:[
	    (aFileName asString startsWith:('stx' , Filename separator)) ifTrue:[
		f := '..' asFilename / '..' / (aFileName copyFrom:5).
	    ]
	].
    ].
    (f notNil and:[(f := f asFilename) exists]) ifTrue:[
	^ f pathName
    ].
    ^ nil

    "
     Smalltalk getPackageFileName:'stx/libview/resources/normal.style'
     Smalltalk getPackageFileName:'stx/libview/styles/normal.style'
     Smalltalk getPackageFileName:'stx/libview/source.zip'
    "
!

getPackageSourceFileName:filenameWithoutSuffixArg
    "search aFileName in some standard places and try all available languages"

    |filenameWithoutSuffix|

    filenameWithoutSuffix:= filenameWithoutSuffixArg asFilename.

    ProgrammingLanguage
	allDo:[:lang |
	    |file|

	    file := self
		    getPackageFileName:(filenameWithoutSuffix addSuffix:lang sourceFileSuffix).
	    file notNil ifTrue:[ ^ file ]
	].
    ^ nil

    "Created: / 16-08-2009 / 14:44:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

getResourceFileName:aFileName
    <resource: #obsolete>

    "search aFileName in some standard places
     (subdirectories named 'resources' in SystemPath);
     return the absolute filename or nil if none is found.
     Obsolete: you must now provide a package argument."

    self obsoleteMethodWarning:'use getResourceFileName:forPackage:'.
    ^ self getResourceFileName:aFileName forPackage:nil

    "
     Smalltalk getResourceFileName:'SystemBrowser.rs'
    "

    "Modified: 18.7.1996 / 15:54:03 / cg"
!

getResourceFileName:aFileName forClass:aClassOrNil
    "search aFileName in some standard places
     (subdirectories named 'resource' in SystemPath);
     and in aClasses package directory.
     Return the absolute filename or nil if none is found."

    |pkgOrNil|

    aClassOrNil notNil ifTrue:[
	pkgOrNil := aClassOrNil package.
    ].
    ^ self getResourceFileName:aFileName forPackage:pkgOrNil.

    "
     Smalltalk getResourceFileName:'de.rs' forClass:SystemBrowser
    "
!

getResourceFileName:aFileName forPackage:aPackageIDOrNil
    "search aFileName in some standard places
     (subdirectories named 'resource' in SystemPath);
     and in a packages directory.
     Return the absolute filename or nil if none is found.
     Search order is:
	resources/<pkg>/file
	<pkg>/resources/file
    "

    |pF f dir packageDir|

    f := aFileName asString withoutPrefix:'resources/'.

    aPackageIDOrNil isNil ifTrue:[
	"/ this will be an error in the future
"/        'Smalltalk [warning]: resource file access without package: ' infoPrint. aFileName infoPrintCR.
"/        self halt.

	pF := self searchPath:(self realSystemPath) for:aFileName in:('resources').
	pF notNil ifTrue:[
	    ^ pF.
	].
"/        pF := self searchPath:(self realSystemPath) for:aFileName in:('resources/styles').
"/        pF notNil ifTrue:[
"/            ^ pF.
"/        ].
	f ~= aFileName ifTrue:[
	    pF := self searchPath:(self realSystemPath) for:f in:('resources').
	    pF notNil ifTrue:[
		^ pF.
	    ].
"/            pF := self searchPath:(self realSystemPath) for:f in:('resources/styles').
"/            pF notNil ifTrue:[
"/                ^ pF.
"/            ].
	].
	^ nil
    ].

    packageDir := aPackageIDOrNil copyReplaceAll:$: with:$/.

    pF := self searchPath:(self realSystemPath) for:aFileName in:('resources/',packageDir).
    pF notNil ifTrue:[
	^ pF.
    ].

    "/ the following code finds the file within the IDE's own hierarchy
    dir := self projectDirectoryForPackage:aPackageIDOrNil.
    dir notNil ifTrue:[
	dir := dir asFilename.

	(pF := dir / 'resources' / f) exists ifTrue:[ ^ pF name ].
"/        (pF := dir / 'styles' / f) exists ifTrue:[ ^ pF name ].

	"resolve something like: 'ASN/definition.asn1'"
	(pF := dir / f) exists ifTrue:[ ^ pF name ].
    ].

    ^ nil

    "
     Smalltalk getResourceFileName:'SystemBrowser.rs' forPackage:'stx:libtool'
     Smalltalk getResourceFileName:'normal.style' forPackage:'stx:libview'
     Smalltalk getResourceFileName:'styles/normal.style' forPackage:'stx:libview'
     Smalltalk getResourceFileName:'styles/mswindowsXP.style' forPackage:'stx:libview'
     Smalltalk getResourceFileName:'Foo.rs' forPackage:'stx:libview'
    "

    "Modified: / 11-10-2006 / 13:53:43 / cg"
!

getSourceFileName:aFileName
    "search aFileName in some standard places
     (subdirectories named 'source' in SystemPath);
     return the absolute filename or nil if none is found.
     This is used to find a sourceFile for a methods source,
     if no sourceCodeManager is available."

    |f|

    SourcePath isNil ifTrue:[
	SourcePath := self constructPathFor:SourceDirName
    ].

    "/ first, try a source subdir along the path.
    SourcePath notNil ifTrue:[
	f := self searchPath:SourcePath for:aFileName in:SourceDirName.
    ].
    f isNil ifTrue:[
	"/ then, try it itself along the path.
	f := self searchPath:self realSystemPath for:aFileName in:nil
    ].
    ^ f

    "
     Smalltalk getSourceFileName:'Smalltalk.st'
     Smalltalk getSourceFileName:'ArrColl.st'
    "

    "Modified: 18.7.1996 / 15:54:07 / cg"
!

getSystemFileName:aFileNameOrString
    "search aFileNameOrString in some standard places;
     return the absolute filename or nil if none is found.
     see comment in Smalltalk>>initSystemPath.
     This should be used to access resources such as bitmaps, doc-files,
     and other help files.
    "

    "credits for this method go to Markus ...."

    |fn nameString|

    fn := aFileNameOrString asFilename.
    nameString := fn name.
    fn isAbsolute ifTrue:[
        "don't use path for absolute file names"

        ^ nameString
    ].

    self realSystemPath do:[:dirName |
        |realName|

        realName := dirName asFilename / nameString.
        "/
        "/ here, we also return true if its a directory
        "/ (Even if unreadable).
        "/ It could be that the file itself is still readable.
        "/
        (realName isDirectory or:[realName isReadable]) ifTrue: [
            ^ realName name
        ]
    ].
    ^ nil

    "
     Smalltalk getSystemFileName:'doc/online/english/TOP.html'
     Smalltalk getSystemFileName:'bitmaps/SBrowser.xbm'
     Smalltalk getSystemFileName:'bitmaps/foo'
     Smalltalk getSystemFileName:'resources/View.rs'
     Smalltalk getSystemFileName:'resources/iris.style'
    "

    "Modified: / 6.5.1999 / 10:40:37 / cg"
!

imageFromFileNamed:aFileName forClass:aClass
    "search aFileName in some standard places:
     first in the redefinable bitmaps path, then in the classes
     own package directory if existing.
     Return an image or nil."

    |classPackage img|

    classPackage := aClass package.
    img := self imageFromFileNamed:aFileName inPackage:classPackage.
    img isNil ifTrue:[
	"/ try under the goodies package ...
	classPackage ~= 'stx:goodies' ifTrue:[
	    img := self imageFromFileNamed:aFileName inPackage:'stx:goodies'.
	]
    ].
    ^ img

    "
     Smalltalk imageFromFileNamed:'SmalltalkX.xbm' forClass:View
    "
!

imageFromFileNamed:aFileName inPackage:aPackage
    "search aFileName in some standard places:
     first in the redefinable bitmaps path,
     then in the package directory if existing.
     Return an image or nil.
     Search order is:
	bitmaps/<pkg>/file
	resources/<pkg>/bitmaps/file
	<pkg>/bitmaps/file
    "

    |path|

    path := self getBitmapFileName:aFileName forPackage:aPackage.
    path notNil ifTrue:[
	^ Image fromFile:path.
    ].
    ^ nil

    "
     Smalltalk imageFromFileNamed:'SmalltalkX.xbm' inPackage:'stx:libview'
     Smalltalk imageFromFileNamed:'SmalltalkX.xbm' inPackage:'stx:libtool'
     Smalltalk imageFromFileNamed:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'
     Smalltalk imageFromFileNamed:'CheckOn10_xp.xpm' inPackage:'stx:libwidg'
     Smalltalk imageFromFileNamed:'ComboDn_xp.xpm' inPackage:'stx:libwidg'
    "

    "Modified: / 08-09-2006 / 18:02:04 / cg"
!

libraryFileNameOfClass:aClassOrClassName
    "for a given class, return the name of a classLibrary which contains
     binary code for it.
     Read the libinfo file 'liblist.stc' (which is created during the compilation process)
     for an entry for aClassOrClassName.
     Search for the className in the first col, and return the value found in
     the 2nd col.
     Return nil if no entry is found.

     A nil returns means that this class is either built-in or not present
     in a package-class library (i.e. either as separate .o or separate .st file).
     Otherwise, the returned name is the classLibrary object of that class.
     The classes code can be loaded from that file if binary loading is supported."

    |aStream line words n aClassName|

    aClassOrClassName isBehavior ifTrue:[
	aClassName := aClassOrClassName name
    ] ifFalse:[
	aClassName := aClassOrClassName
    ].
    aClassName := aClassName asString.

    #('include/liblist.stc')    "/ filenames
    with:#(2)                   "/ column
    do:[:fileName :col |

	aStream := self systemFileStreamFor:fileName.
	aStream notNil ifTrue:[
	    [aStream atEnd] whileFalse:[
		line := aStream nextLine.
		line notNil ifTrue:[
		    (line startsWith:'#') ifFalse:[
			words := line asCollectionOfWords.
			(n := words size) > 1 ifTrue:[
			    (words at:1) = aClassName ifTrue:[
				n >= col ifTrue:[
				    aStream close.
				    ^ (words at:col) withoutSeparators
				]
			    ]
			]
		    ]
		]
	    ].
	    aStream close
	].
    ].

    ^ nil

    "
     Smalltalk libraryFileNameOfClass:'ClockView'
     Smalltalk libraryFileNameOfClass:'Bag'
    "

    "Modified: 6.11.1995 / 15:41:39 / cg"
!

packagePath
    "Return a list directory names, where smalltalk looks for packages,
     that is, the list of directories searched when a package load is
     requested via #loadPackage:.

     To add a new entry to a package path, do

         Smalltalk packagePath add: '/path/to/some/directory'.

     See comment of Smalltalk class>>initPackagePath for default package path.

     Notice, that directories named 'packages' under the systemPath are
     always consulted - even if not in the packagePath"

    ^ PackagePath ? #()

    "
     Smalltalk packagePath
     Smalltalk packagePath addLast:'/opt/smalltalk'
     Smalltalk packagePath addFirst:'/usr/local/otherPackages'
    "

    "Modified (comment): / 25-06-2016 / 16:44:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packagePath:aPath
    "set the 'packagePath', a list of directories where smalltalk
     looks for packages. See #packagePath and #initPackagePath

     Setting package path this way is rarely necessary, to add more
     directories you may do

         Smalltalk packagePath add: '/path/to/some/directory'.

     ALso note, that directories named 'packages' under the systemPath are
     always consulted - even if not in the packagePath"

    PackagePath := aPath asOrderedCollection

    "
     Smalltalk packagePath:#( '.' '/opt/stx' '/opt/smalltalk' '/usr/local/otherPackages')
    "

    "Modified (format): / 26-06-2016 / 05:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

projectDirectoryForClass:aClass
    "given a class, return the path to its package directory;
     nil if not found."

    |pkg|

    pkg := aClass package.
    pkg isNil ifTrue:[^ nil].

    ^ self projectDirectoryForPackage:pkg.

    "
     Smalltalk projectDirectoryForClass:Array
     Smalltalk projectDirectoryForClass:View
    "
!

projectDirectoryForPackage:aPackage
    "given a packageID, return the path to its package directory;
     nil if not found."

    |prj prjDir|

    ^ aPackage asPackageId packageDirectory.

    "/ there might be a package specific resource directory ...
    "/ in the directory, from which the project was loaded
    prj := Project projectWithId:aPackage.
    prj notNil ifTrue:[
	prjDir := prj directory.
    ].
    (prjDir notNil and:[prjDir asFilename exists]) ifFalse:[
	prjDir := Smalltalk getPackageFileName:(aPackage copyReplaceAll:$: with:$/).
    ].
    ^ prjDir

    "
     Smalltalk projectDirectoryForPackage:'stx:libbasic'
     Smalltalk projectDirectoryForPackage:'exept:smartcard'
     Smalltalk projectDirectoryForPackage:'stx'
     Smalltalk projectDirectoryForPackage:'bosch'
     Smalltalk projectDirectoryForPackage:'bosch:foo'
    "

    "Modified: / 07-10-2006 / 17:45:58 / cg"
!

readAbbreviations
    "read classname to filename mappings from include/abbrev.stc.
     sigh - all for those poor sys5.3 or MSDOS people with short filenames ..."

    "since installAutoloadedClasses also reads all abbreviations, use it"

    CachedAbbreviations := IdentityDictionary new.
    self installAutoloadedClasses.
    ^ CachedAbbreviations.

    "
     Smalltalk readAbbreviations
    "

    "Modified: / 10.12.1999 / 17:48:53 / cg"
!

readAbbreviationsFromStream:aStream
    "read classname to filename mappings from aStream.
     sigh - all for those poor sys5.3 or MSDOS people with short filenames ..."

    self
	withAbbreviationsFromStream:aStream
	do:[:className :abbrev :pkg |
	    self setFilename:abbrev forClass:className package:pkg.
	].

    "Modified: / 13.12.1999 / 11:54:17 / cg"
!

realSystemPath
    "return the realSystemPath - that's the directory names from
     SystemPath which exist and are readable"

    |nP|

    RealSystemPath isNil ifTrue:[
	OperatingSystem isVMSlike ifTrue:[
	    "/ temporary kludge: since we cannot currently
	    "/ check for existence of a name like 'volume:',
	    "/ leave those in the Path without a check.
	    RealSystemPath := SystemPath select:[:dirName |  |f|
		f := dirName asFilename.
		f isVolumeOnly or:[(f isDirectory) and:[f isReadable]]
	    ]
	] ifFalse:[
	    RealSystemPath := SystemPath
		select:[:eachDirectoryName |  |f|
		    f := eachDirectoryName asFilename.
		    (f isDirectory) and:[f isReadable]
		] thenCollect:[:eachDirectoryName|
		    eachDirectoryName asFilename pathName.
		].

	    "/ remove duplicates (but keep order)
	    nP := OrderedCollection new.
	    RealSystemPath do:[:p |
		(nP includes:p) ifFalse:[
		    nP add:p
		]
	    ].
	    (nP includes:'.') ifFalse:[
		nP add:'.'
	    ].
	    RealSystemPath := nP.
	].
    ].
    ^ RealSystemPath
!

recursiveReadAllAbbreviationsFrom:aDirectory
    self recursiveReadAllAbbreviationsFrom:aDirectory maxLevels:15
!

recursiveReadAllAbbreviationsFrom:aDirectory maxLevels:maxLevels
    "read all abbreviations from and under aDirectory."

    |abbrevStream dir directoryContents|

    maxLevels == 0 ifTrue:[
"/        'Smalltalk [warning]: max directory nesting reached.' infoPrintCR.
        ^ self
    ].

    dir := aDirectory asFilename.
    dir exists ifFalse:[^ self].

    [
        abbrevStream := (dir / 'abbrev.stc') asFilename readStream.
        self readAbbreviationsFromStream:abbrevStream.
        abbrevStream close.
    ] on:FileStream openErrorSignal do:[:ex| "ignore this file"].

    [
        directoryContents := dir directoryContents.
    ] on:FileStream openErrorSignal do:[:ex|
        "non-accessible directory: we are done"
        ^ self
    ].

    directoryContents do:[:aFilename |
        |f|

        (#(
            'doc'
            'CVS'
            'bitmaps'
            'resources'
            'source'
        ) includes:aFilename) ifFalse:[
            f := dir / aFilename.
            f isDirectory ifTrue:[
                self recursiveReadAllAbbreviationsFrom:f maxLevels:maxLevels-1
            ]
        ].
    ].
!

reinitializePackagePath
    "{ Pragma: +optSpace }"

    PackagePath notNil ifTrue:[
        PackagePath := PackagePath select:[:p | p asFilename exists].
    ].
    PackagePath isEmptyOrNil ifTrue:[
        self initSystemPath
    ].

    "Modified: / 25-06-2016 / 16:36:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

relativePackagePathForPackage:aPackage
    |path|

    PackageToPathMapping notNil ifTrue:[
	path := PackageToPathMapping at:aPackage ifAbsent:nil.
	PackageToPathMapping notNil ifTrue:[^ path].
    ].
    ^ aPackage copyReplaceAll:$: with:$/.

    "
     PackageToPathMapping := Dictionary new.
     PackageToPathMapping at:'expeccoNET:server' put:'expeccoNET_oldVersion/server'.
     PackageToPathMapping at:'expeccoNET:server/ui' put:'expeccoNET_oldVersion/server/ui'.

     Smalltalk relativePackagePathForPackage:'stx:libview/resources'
     Smalltalk relativePackagePathForPackage:'stx:libview'
    "
!

resourceDirectoryForPackage:aPackage
    "given a packageID, return the path to its resource directory;
     nil if not found."

    |prjDir rsrcDir|

    aPackage notNil ifTrue:[
	prjDir := self projectDirectoryForPackage:aPackage.

	(prjDir notNil
	and:[(prjDir := prjDir asFilename) exists
	and:[(rsrcDir := prjDir / 'resources') exists]]) ifTrue:[
	    ^ rsrcDir
	].
	rsrcDir := self getSystemFileName:('resources/' , (aPackage copyReplaceAll:$: with:$/)).
	rsrcDir notNil ifTrue:[
	    ^ rsrcDir asFilename
	].
    ].
    ^ nil

    "
     Smalltalk resourceDirectoryForPackage:'stx:libbasic'
     Smalltalk resourceDirectoryForPackage:'exept:expecco'
     Smalltalk resourceDirectoryForPackage:'exept:smartcard'
    "
!

resourceFileStreamFor:aFileName
    "search aFileName in some standard places;
     return a readonly fileStream or nil if not found.
     Searches in subdirectories named 'resource' in SystemPath"

    ^ self resourceFileStreamFor:aFileName forClass:nil
!

resourceFileStreamFor:aFileName forClass:aClassOrNil
    "search aFileName in some standard places and in the classes
     package-resource directory.
     Return a readonly fileStream or nil if not found.
     Searches in subdirectories named 'resource' in SystemPath"

    |aString|

    aString := self getResourceFileName:aFileName forClass:aClassOrNil.
    aString notNil ifTrue:[
	^ aString asFilename readStreamOrNil
    ].
    ^ nil
!

searchPath:aPath for:aFileName in:aDirName
    "search aPath for a subdirectory named aDirectory with a file
     named aFileName"

    |f|

    ((f := aFileName asFilename) isAbsolute
    or:[f isExplicitRelative]) ifTrue:[
        "/
        "/ don't use path for absolute or explicit .-relative file names
        "/
        ^ aFileName
    ].

    aPath notNil ifTrue:[
        aPath do:[:dirName |
            |realName dir|

            dir := dirName asFilename.
            aDirName notNil ifTrue:[
                realName := dir / aDirName / aFileName.
            ] ifFalse:[
                realName := dir / aFileName.
            ].
            (realName isReadable) ifTrue:[
                ^ realName name
            ]
        ].
    ].

"/ not needed - executing dir is always in SearchPath
"/    realName := Filename currentDirectory / aFileName.
"/    (realName isReadable) ifTrue:[
"/        ^ realName name
"/    ].
    ^ nil.

    "Modified: / 29.4.1999 / 15:06:43 / cg"
!

setFilename:aFileNameString forClass:aClassNameString package:aPackageNameString
    |classNameSymbol oldAbbrev oldPath newPath cls abbrevs|

    CachedAbbreviations isNil ifTrue:[
	CachedAbbreviations := IdentityDictionary new.
    ].

    abbrevs := CachedAbbreviations.
    aClassNameString ~= aFileNameString ifTrue:[
	classNameSymbol := aClassNameString asSymbol.
	oldAbbrev := abbrevs at:classNameSymbol ifAbsent:nil.
	oldAbbrev notNil ifTrue:[
	    oldAbbrev ~= aFileNameString ifTrue:[
		oldAbbrev asFilename isAbsolute
		    ifTrue:[ oldPath := oldAbbrev ]
		    ifFalse:[ oldPath := (self projectDirectoryForPackage:aPackageNameString) asFilename constructString: oldAbbrev ].
		aFileNameString asFilename isAbsolute
		    ifTrue:[ newPath := aFileNameString ]
		    ifFalse:[ newPath := (self projectDirectoryForPackage:aPackageNameString) asFilename constructString: aFileNameString ].

		oldPath ~= newPath ifTrue:[
		    StandAlone ifFalse:[
			('Smalltalk [warning]: autoload path change for: ',aClassNameString,' in package ',aPackageNameString) infoPrintCR.
			('Smalltalk [info]: old: ',oldPath) infoPrintCR.
			('Smalltalk [info]: new: ',newPath) infoPrintCR.
		    ]
		]
	    ].
	    "overwrite old abbreviation with new one,
	     to allow fixing of bad abbrev files"
	].

	cls := self classNamed:aFileNameString.
	cls notNil ifTrue:[
	    cls name ~= aClassNameString ifTrue:[
		"/ ok, there is a class named after this abbrev ...
		"/ this is only a conflict, if the other class has no
		"/ abbreviation (or the same).
		(abbrevs at:(cls name asSymbol) ifAbsent:cls name) = aFileNameString ifTrue:[
		    cls isNameSpace ifFalse:[
			aPackageNameString = cls package ifTrue:[
			    StandAlone ifFalse:[
				('Smalltalk [warning]: conflict for: ' , cls name ,
				    ' in package ' , aPackageNameString) infoPrintCR.
				('Smalltalk [warning]: (' , aClassNameString , ' -> ' , aFileNameString
				    , ')') infoPrintCR
			    ]
			]
		    ]
		]
	    ]
	].
	abbrevs at:classNameSymbol put:aFileNameString.
    ]
!

sourceDirectoryNameOfClass:aClassOrClassName
    "for a given class, return the pathname relative to TOP of the classes source code.
     Read the files 'abbrev.stc' and 'liblist.stc' (which are created during the compilation process)
     for an entry for aClassOrClassName.
     Search for the className in the first col, and return the value found in
     the 3rd col.
     Return nil if no entry is found."

    |aStream line words n aClassName|

    aClassOrClassName isBehavior ifTrue:[
	aClassName := aClassOrClassName name
    ] ifFalse:[
	aClassName := aClassOrClassName
    ].
    aClassName := aClassName asString.

    #('include/abbrev.stc' 'include/liblist.stc')    "/ filenames
    with:#(3 2)                   "/ column
    do:[:fileName :col |

	aStream := self systemFileStreamFor:fileName.
	aStream notNil ifTrue:[
	    [aStream atEnd] whileFalse:[
		line := aStream nextLine.
		line notNil ifTrue:[
		    (line startsWith:'#') ifFalse:[
			words := line asCollectionOfWords.
			(n := words size) > 1 ifTrue:[
			    (words at:1) = aClassName ifTrue:[
				n >= col ifTrue:[
				    aStream close.
				    ^ (words at:col) withoutSeparators
				]
			    ]
			]
		    ]
		]
	    ].
	    aStream close
	].
    ].

    ^ nil

    "
     Smalltalk sourceDirectoryNameOfClass:'ClockView'
     Smalltalk sourceDirectoryNameOfClass:'Bag'
     Smalltalk sourceDirectoryNameOfClass:'GLWireCubeDemoView'
     Smalltalk sourceDirectoryNameOfClass:'SomeNonExistingClass'
    "

    "Created: 6.11.1995 / 15:43:30 / cg"
    "Modified: 9.12.1995 / 23:54:14 / cg"
    "Modified: 3.1.1997 / 11:26:44 / stefan"
!

sourceFileStreamFor:aFileName
    "search aFileName in some standard places;
     return a readonly fileStream or nil if not found.
     Searches in subdirectories named 'source' in SystemPath"

    |aString|

    aString := self getSourceFileName:aFileName.
    aString notNil ifTrue:[
	^ aString asFilename readStreamOrNil
    ].
    ^ nil
!

systemFileStreamFor:aFileName
    "search aFileName in some standard places;
     return a readonly fileStream or nil if not found.
     see comment in Smalltalk>>initSystemPath"

    |aString|

    aString := self getSystemFileName:aFileName.
    aString notNil ifTrue:[
	^ aString asFilename readStreamOrNil
    ].
    ^ nil
!

systemPath
    "return a collection of directorynames, where smalltalk
     looks for system files
     (usually in subdirs such as resources, bitmaps, source etc.)
     see comment in Smalltalk>>initSystemPath."

    ^ SystemPath ? #()

    "
     Smalltalk systemPath
     Smalltalk systemPath addLast:'someOtherDirectoryPath'
    "
!

systemPath:aPath
    "set the collection of directorynames, where smalltalk
     looks for system files
     (usually in subdirs such as resources, bitmaps, source etc.)
     see comment in Smalltalk>>initSystemPath."

    SystemPath := aPath.
    self flushPathCaches

    "
     Smalltalk systemPath
     Smalltalk systemPath:(Smalltalk systemPath copy addLast:'someOtherDirectoryPath')
    "
!

withAbbreviationsFromStream:aStream do:aBlock
    "read classname to filename mappings from aStream.
     Evaluate aBlock for each tuple:
	class-name , abbrev-name, package
     Sigh - all for those poor sys5.3 or MSDOS people with short filenames..."

    |line lineNo words nm abbrev pkg category size s w|

    lineNo := 0.
    [aStream atEnd] whileFalse:[
	line := aStream nextLine.
	lineNo := lineNo + 1.
	line notEmptyOrNil ifTrue:[
	    (line startsWith:'#') ifFalse:[

		"/ must do it manually, caring for quoted strings.
"/                words := line asCollectionOfWords.

		words := OrderedCollection new.
		s := line readStream.
		[s atEnd] whileFalse:[
		    s skipSeparators.
		    s peek == $' ifTrue:[
			s next.
			w := s upTo:$'.
			s skipSeparators.
		    ] ifFalse:[
			w := s upToSeparator
		    ].
		    words add:w
		].
		words size >= 3 ifTrue:[
		    nm := (words at:1) withoutSeparators.
		    abbrev := (words at:2) withoutSeparators.
		    pkg := (words at:3) withoutSeparators.
		    aBlock argumentCount = 3 ifTrue:[
			aBlock value:nm value:abbrev value:pkg.
		    ] ifFalse:[
			words size >= 4 ifTrue:[
			    category := words at:4.
			].
			words size = 5 ifTrue:[
			    size := (words at:5) asNumber
			].
			aBlock value:nm value:abbrev value:pkg value: category value: size
		    ]
		] ifFalse:[
		    ('Smalltalk [warning]: malformed line ', lineNo printString , ' in ' , (aStream pathName)) infoPrintCR.
		]
	    ]
	]
    ].

    "Modified: / 06-03-2011 / 18:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 21:35:00 / cg"
! !

!Smalltalk class methodsFor:'system management-packages'!

isPackageLoaded:aPackageIdOrPackage
    |projectDefinition|

    projectDefinition := aPackageIdOrPackage asPackageId projectDefinitionClass.
    ^ projectDefinition notNil and:[projectDefinition isLoaded and:[projectDefinition isFullyLoaded]]

    "
     Smalltalk isPackageLoaded:'stx:goodies/persistency'
     Smalltalk isPackageLoaded:'stx:goodies/refactoryBrowser/lint'
     Smalltalk isPackageLoaded:'stx:goodies/refactoryBrowser/lint/spelling'
    "
!

knownLoadablePackagesDo:aBlock
    "enumerate loadable packages from the packages folder."

    Smalltalk realSystemPath do:[:dirName |
        |packageDir|

        packageDir := dirName asFilename / 'packages'.
        (packageDir exists and:[packageDir isDirectory]) ifTrue:[
            packageDir directoryContentsAsFilenames sort do:[:fn |
                |item base nm path parentPath parent isLibrary isApplication isAlreadyLoaded
                 defClass target type nameComponents packageName packageID|

                ((fn suffix = 'mcz')
                or:[ fn isDirectory
                or:[ (fn baseName startsWith:'.')
                or:[ (fn baseName = 'README') ]]]) ifFalse:[
                    base := fn withoutSuffix baseName.
                    (base startsWith:'lib') ifTrue:[
                        nm := (base copyFrom:4).
                        fn suffix notEmptyOrNil ifTrue:[
                            type := #library.
                        ] ifFalse:[
                            type := #application.
                        ]
                    ] ifFalse:[
                        nm := base.
                        type := #application.
                    ].

                    (base ~= 'librun') ifTrue:[
                        (fn suffix = 'mcz') ifTrue:[
                            packageName := fn withoutSuffix.
                            target := fn.
                        ] ifFalse:[
                            ( #('dll' 'so' 'sl' 'dylib') includes:(fn suffix)) ifTrue:[
                                (base startsWith:'lib') ifTrue:[
                                    nm := base copyFrom:4.
                                ] ifFalse:[
                                    nm := base.
                                ].
                            ].
                            nameComponents := nm asCollectionOfSubstringsSeparatedBy:$_.
                            packageName := nameComponents first.
                            nameComponents size > 1 ifTrue:[
                                packageName := packageName,':',((nameComponents from:2) asStringWith:'/')
                            ].
                        ].
                        packageName notNil ifTrue:[
                            aBlock value:packageName value:type value:fn .
                        ]
                    ]
                ]
            ]
        ]
    ]

    "
     Smalltalk knownLoadablePackagesDo:[:packageID :type :path |
         Transcript showCR:'%1 (%2) in %3' with:packageID with:type with:path.
     ]
    "
!

loadPackage:aPackageIdOrPackage
    "make certain, that some particular package is loaded into the system.
     Return true if loaded, false otherwise."

    ^ self loadPackage:aPackageIdOrPackage asAutoloaded:false

    "
     Smalltalk loadPackage:'stx:libbasic'
     Smalltalk loadPackage:'stx:goodies/persistency'
     Smalltalk loadPackage:'cg:cparser'
     Smalltalk loadPackage:'cg:rose'
    "
!

packageDirectoryForPackageId:aPackageId
    <resource: #obsolete>

    self obsoleteMethodWarning:'Use #getPackageDirectoryForPackage: instead'.
    ^ self getPackageDirectoryForPackage: aPackageId

    "
     Smalltalk packageDirectoryForPackageId:'stx:libbasic'
     Smalltalk packageDirectoryForPackageId:'stx:goodies/persistency'
     Smalltalk packageDirectoryForPackageId:'exept:ctypes'
    "

    "Modified (format): / 28-06-2016 / 07:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

requirePackage:aPackageIdOrPackage
    "make certain, that some particular package is loaded into the system.
     Return true if loaded, false otherwise.
     Just an alias which is easier to remember"

    ^ self loadPackage:aPackageIdOrPackage

    "
     Smalltalk loadPackage:'stx:libbasic'
     Smalltalk loadPackage:'stx:goodies/persistency'
     Smalltalk loadPackage:'cg:cparser'
     Smalltalk loadPackage:'cg:rose'
    "
!

unloadPackage:aPackageIdOrPackage
    |projectDefinition|

    projectDefinition := aPackageIdOrPackage.
    projectDefinition isProjectDefinition ifFalse:[
        projectDefinition := projectDefinition asPackageId projectDefinitionClass.
        projectDefinition isNil ifTrue:[
            Logger warning:'trying to unload non-existing package: %1' with:aPackageIdOrPackage.
            ^ self.
        ].
    ].
    projectDefinition unloadPackage.

    "
     Smalltalk loadPackage:'stx:goodies/persistency'
     Smalltalk unloadPackage:'stx:goodies/persistency'
    "
! !

!Smalltalk class methodsFor:'system management-undeclared variables'!

clearUndeclaredVariables
    "remove all undeclared variables"

    (Smalltalk at:#Undeclared) do:[:eachKey |
	Smalltalk removeKey:(self undeclaredPrefix , eachKey) asSymbol.
    ].
    (Smalltalk at:#Undeclared) removeAll.
    Smalltalk removeKey:#Undeclared.
!

undeclaredPrefix
    "the prefix used for undeclared variables"

    ^ 'Undeclared:::'

    "Created: / 31.10.1997 / 01:13:10 / cg"
! !

!Smalltalk class methodsFor:'time-versions'!

configuration
    "{ Pragma: +optSpace }"

    "for developers only: return the configuration, with which
     this smalltalk was compiled."

%{  /* NOCONTEXT */
    extern char *__getBuildTargetString(void);

    RETURN (__MKSTRING(__getBuildTargetString()));
%}.
    self primitiveFailed.

    "
     Smalltalk configuration
    "
!

copyrightString
    "{ Pragma: +optSpace }"

    "return a copyright string"

%{  /* NOCONTEXT */
#ifndef __getCopyrightString
    extern OBJ __getCopyrightString();
#endif

    RETURN (__getCopyrightString());
%}.
    ^ self primitiveFailed

    "
     Smalltalk copyrightString
    "
!

distributorString
    "{ Pragma: +optSpace }"

    "return a string describing the distributor of this software"

%{  /* NOCONTEXT */
#ifndef __getDistributorString
    extern OBJ __getDistributorString();
#endif

    RETURN (__getDistributorString());
%}.
    ^ 'eXept Software AG, Germany'

    "
     Smalltalk distributorString
    "
!

expirationTime
    "{ Pragma: +optSpace }"

    "for developers only: return the time when the system will expire.
     after this time it will not run any longer.
     It returns nil, if no expiration time has been set (system runs forever :-))"

    |exp|

%{
    extern unsigned int __getExpirationTime();

    exp = __MKUINT(__getExpirationTime());
%}.
    exp == 0 ifTrue:[
	^ nil
    ].
    ^ Timestamp new fromOSTime:(exp * 1000). "OSTime is ms since 1970"

    "
     Smalltalk expirationTime
    "
!

fullVersionString
    "{ Pragma: +optSpace }"

    "return a full version string"

    ^ 'Smalltalk/X jv-branch release %1%2 of %3'
        bindWith:(self versionString)
        with:((ExternalAddress pointerSize == 8)
                        ifTrue:[' (64bit)']
                        ifFalse:[''])
        with:(self versionDate)

    "
     Smalltalk fullVersionString
    "

    "Created: / 27.10.1997 / 17:03:09 / cg"
    "Modified: / 27.10.1997 / 17:04:02 / cg"
!

hello
    "{ Pragma: +optSpace }"

    "return a greeting string"

    "stupid: this should come from a resource file ...
     but I don't use it here, to allow mini-systems without
     Resource-stuff."

    |proto lang bit bitsPerWordString|

    lang := Language.
    bit := 'bit'.

    (lang == #de) ifTrue:[
        proto := 'Willkommen bei %1 (%4Version %2 von %3)'. bit := 'Bit'.
    ] ifFalse:[ (lang == #fr) ifTrue:[
        proto := 'Salut, Bienvenue à %1 (%4version %2 de %3)'
    ] ifFalse:[ (lang == #it) ifTrue:[
        proto := 'Ciao, benvenuto al %1 (%4versione %2 di %3)'
    ] ifFalse:[ (lang == #es) ifTrue:[
        proto := 'Hola, bienvenida a %1 (%4version %2 de %3)'
    ] ifFalse:[ (lang == #pt) ifTrue:[
        proto := 'Ol!!, mem-vindo a %1 (%4version %2 de %3)'
    ] ifFalse:[ (lang == #no) ifTrue:[
        proto := 'Hei, verdenmottakelse til %1 (%4versjon %2 av %3)'
    ]]]]]].

    "/ ... more needed here ...

    proto isNil ifTrue:[
        proto := 'Hello World - welcome to %1 (%4version %2 of %3)'.
    ].
    ExternalAddress pointerSize ~~ 4 ifTrue:[
        bitsPerWordString := (ExternalAddress pointerSize * 8) printString,bit,' '.
    ] ifFalse:[
        bitsPerWordString := ''
    ].

    ^ proto bindWith:('Smalltalk/X jv-branch' allBold)
                with:(self versionString)
                with:(self versionDate)
                with:bitsPerWordString

    "
     Smalltalk language:#us.
     Smalltalk hello

     Smalltalk language:#de.
     Smalltalk hello

     Smalltalk language:#no.
     Smalltalk hello

     Transcript showCR:(Smalltalk hello)
     Stdout showCR:(Smalltalk hello)
    "

    "Modified: 18.5.1996 / 14:25:13 / cg"
!

imageRestartTime
    "return a timestamp for the moment when this image was restarted.
     If we do not execute from an image (i.e. fresh start), return nil."

    ^ ImageRestartTime

    "
     Smalltalk imageStartTime
     Smalltalk imageRestartTime
    "

    "Created: 13.12.1995 / 17:44:20 / cg"
    "Modified: 6.3.1996 / 11:56:35 / cg"
!

imageSaveTime
    "{ Pragma: +optSpace }"

    "return a timestamp for the moment when this image was saved"

    ^ ObjectMemory imageSaveTime
!

imageStartTime
    "{ Pragma: +optSpace }"

    "return a timestamp for the moment when this system started the first time
     (i.e. the first initial start without an image)"

    ^ ImageStartTime

    "
     Smalltalk imageStartTime
     Smalltalk imageRestartTime
    "

    "Created: 13.12.1995 / 17:44:14 / cg"
    "Modified: 13.12.1995 / 17:45:47 / cg"
!

majorVersionNr
    "{ Pragma: +optSpace }"

    "return the major version number.
     This is only incremented for very fundamental changes,
     which make old object files totally incompatible
     (for example, if the layout/representation of fundamental
      classes changes).

     ST/X revision Naming is:
        <major>.<minor>.<revision>.<release>"

    ^ 8

    "
     Smalltalk majorVersionNr
    "

    "Modified: 8.11.1996 / 19:59:21 / cg"
!

minorVersionNr
    "{ Pragma: +optSpace }"

    "return the minor version number.
     This is incremented for changes which make some old object
     files incompatible, or the protocol changes such that some
     classes need rework.

     ST/X revision Naming is:
        <major>.<minor>.<revision>.<release>"

    ^ 0

    "
     Smalltalk minorVersionNr
    "

    "Modified: / 16-08-2006 / 09:37:25 / cg"
!

releaseIdentification
    "{ Pragma: +optSpace }"

    "for developers only: return the release
     (to further identify the version in case of errors)"

%{  /* NOCONTEXT */
    extern OBJ __getRel();

    RETURN (__getRel());
%}.
    ^ 'ST/X_experimental'

    "
     Smalltalk releaseIdentification
    "
!

releaseNr
    "{ Pragma: +optSpace }"

    "return the release number.
     Now releaseNr is the build number (BUILD_NUMBER from Jenkins)

     ST/X revision Naming is:
	<major>.<minor>.<revision>.<release>"

    |releaseNumber|

    releaseNumber := Smalltalk versionBuildNumber.
    releaseNumber isEmpty ifTrue:[
	^ 0.
    ].
    ^ releaseNumber

    "
     Smalltalk releaseNr
     Smalltalk versionString
    "

    "Created: / 10-12-1995 / 01:42:19 / cg"
    "Modified: / 10-02-2007 / 14:49:51 / cg"
!

revisionNr
    "{ Pragma: +optSpace }"

    "return the revision number.
     Incremented for releases which fix bugs/add features
     and represent a stable workable version which got published
     to the outside world.

     ST/X revision Naming is:
        <major>.<minor>.<revision>.<release>"

    ^ 99

    "
     Smalltalk revisionNr
     Smalltalk hello string
    "

    "Modified: / 18-07-2012 / 19:09:42 / cg"
    "Modified: / 19-03-2013 / 10:48:59 / az"
    "Modified: / 09-06-2016 / 16:28:57 / cg"
!

timeStamp
    "return a string useful for timestamping a file.
     The returned string is padded with spaces for a constant
     length (to avoid changing a files size in fileOut with unchanged
     class)."

    ^ ('''' , self timeStampString , '''') paddedTo:80 with:(Character space)
!

timeStamp:aStream
    "write a string useful for timestamping a file onto aStream.
     ST80 compatibility"

    aStream nextPutAll:(self timeStamp).

    "Created: / 18.6.1998 / 17:22:58 / cg"
!

timeStampString
    "return a string useful for timestamping a file."

    |dateString|

    dateString := String streamContents:[:s | Date today printOn:s language:#en].  "/ MUST be english !!!!

    ^ ('From Smalltalk/X jv-branch, Version:' , (Smalltalk versionString) , ' on '
       , dateString , ' at ' , Time now printString
       )
!

versionBuildNumber
    "{ Pragma: +optSpace }"

    "return the executables build number - that's the jenkins build #.
     Empty if not built by jenkins"

%{  /* NOCONTEXT */
    extern char *__getBuildNumberString();

    RETURN (__MKSTRING(__getBuildNumberString() COMMA_SND) );
%}.
    ^ ''

    "
     Smalltalk versionBuildNumber
    "
!

versionDate
    "{ Pragma: +optSpace }"

    "return the executables build date - that's the date when the smalltalk
     executable was built"

%{  /* NOCONTEXT */
    extern char *__getBuildDateString();
    RETURN (__MKSTRING(__getBuildDateString() COMMA_SND) );
%}.
    ^ 'today'

    "
     Smalltalk versionDate
    "
!

versionString
    "{ Pragma: +optSpace }"

    "return the version string"

    ^ (self majorVersionNr printString ,
       '.',
       self minorVersionNr printString ,
       '.',
       self revisionNr printString,
       '.',
       self releaseNr printString)


    "
     Smalltalk versionString
    "
!

vmMajorVersionNr
    "{ Pragma: +optSpace }"

    "return the VMs major version number."
%{
    RETURN (__mkSmallInteger(4));
%}.
    ^ 4

    "
     Smalltalk vmMajorVersionNr
    "
! !

!Smalltalk class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/Smalltalk.st,v 1.1133 2015-05-22 18:41:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/Smalltalk.st,v 1.1133 2015-05-22 18:41:08 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id: Smalltalk.st 10648 2011-06-23 15:55:10Z vranyj1  $'
! !

