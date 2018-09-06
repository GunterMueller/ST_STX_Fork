"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

StandaloneStartup subclass:#ReportRunner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports'
!

ReportRunner class instanceVariableNames:'parser report debugging setup teardown ident'

"
 The following class instance variables are inherited by this class:

	StandaloneStartup - MutexHandle
	Object - 
"
!


!ReportRunner class methodsFor:'initialization'!

initialize

    super initialize.
    debugging := Transcript notNil and:[Transcript isView].
    self setupSignalHandlers.

    "Created: / 06-11-2011 / 22:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2013 / 01:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportRunner class methodsFor:'command line options'!

cmdlineOptionIdent

    ^CmdLineOption new
        short: $i;
        long: 'ident';
        description: 'run/configuration identification';
        action:[:option |
            ident := option.
        ];
        yourself

    "Created: / 22-01-2014 / 10:00:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionOutputDirectory

    ^CmdLineOption new
        short: $D;
        long: 'output-directory';
        description: 'Default report output directory';
        action:[:outputdir |
            Report outputDir: outputdir.
            self  verboseInfo:'Report dir: ' , Report outputDir asString.
        ];
        yourself

    "Created: / 06-11-2011 / 09:33:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2014 / 10:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionReport

    ^CmdLineOption new
        short: $r;
        long: 'report';
        description: 'Report to run';
        action:[:option |
            report := Smalltalk at: option asSymbol.
            report isNil ifTrue:[
                Stderr nextPutLine:('ERROR: Report class %1 does not exist (forgot to load package?)' bindWith: option).
                "/Smalltalk exit: 1.
            ].
            report := report new.
            parser options addAll: (CmdLineOption optionsFor: report)
        ];
        yourself

    "Created: / 06-11-2011 / 09:45:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2014 / 10:00:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionSetup

    ^CmdLineOption new
        short: $S;
        long: 'setup';
        description: 'Code executed before tests are loaded and executed';
        action:[:option |
            setup := option
        ];
        yourself

    "Created: / 15-05-2013 / 16:50:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-01-2014 / 15:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionTeardown

    ^CmdLineOption new
        short: $T;
        long: 'teardown';
        description: 'Code executed after all tests are executed';
        action:[:option |
            teardown := option
        ];
        yourself

    "Created: / 15-05-2013 / 16:50:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2014 / 10:01:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportRunner class methodsFor:'debugging'!

dumpProcess: aProcess
    Stderr cr; cr

    "Created: / 27-06-2013 / 23:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpProcess: aProcess on: aStream
    | ctx |
    aStream cr; cr.
    aStream nextPutAll: '== ['; nextPutAll: aProcess id printString; nextPutAll:'] '; nextPutAll: aProcess name; nextPutAll: ' =='; cr.
    aStream cr.
    aStream nextPutAll: '  State:   '; nextPutAll: aProcess state printString; cr.
    aStream nextPutAll: '  Group:   '; nextPutAll: aProcess processGroupId printString; cr.
    aStream nextPutAll: '  Creator: '; nextPutAll: aProcess processGroupId printString; cr.
    aStream nextPutAll: '  Stack:   '; cr; cr.

    aProcess == Processor activeProcess ifTrue:[ctx := thisContext] ifFalse:[ctx := aProcess suspendedContext].
    [ ctx notNil ] whileTrue:[
        aStream nextPutAll: '  '.
        ctx fullPrintOn: aStream.
        aStream cr.
        ctx := ctx sender.
    ].
    aStream cr.

    "
        self dumpProcess: Processor activeProcess on: Transcript.
    "

    "Created: / 28-06-2013 / 01:00:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2014 / 09:14:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpProcesses
    self dumpProcessesOn: Stderr

    "
    self dumpProcessesOn: Transcript.
    "

    "Created: / 27-06-2013 / 23:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-06-2013 / 01:06:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpProcessesOn: aStream
    Process allInstancesDo:[:process|
        process isDead ifFalse:[
            self dumpProcess: process on: aStream
        ]
    ]

    "Created: / 27-06-2013 / 23:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportRunner class methodsFor:'defaults'!

allowCoverageMeasurementOption

    ^false "CoverageReport will do that"

    "Created: / 13-01-2012 / 11:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowDebugOption

    ^true

    "Created: / 21-07-2011 / 09:48:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportRunner class methodsFor:'multiple applications support'!

applicationRegistryPath
    "the key under which this application stores its process ID in the registry
     as a collection of path-components.
     i.e. if #('foo' 'bar' 'baz') is returned here, the current applications ID will be stored
     in HKEY_CURRENT_USER\Software\foo\bar\baz\CurrentID.
     (would also be used as a relative path for a temporary lock file under unix).
     Used to detect if another instance of this application is already running."

    ^ #('exept' 'smalltallx' 'hdreportrunner')

    "Modified: / 21-07-2011 / 09:43:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used."

    ^ '99f65c80-b375-11e0-86ad-0013e89c0459' asUUID

    "Modified: / 21-07-2011 / 09:44:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportRunner class methodsFor:'startup'!

handleSIGTERM
    self dumpProcesses.
    debugging ifFalse:[
        Smalltalk exit:127.
    ].

    "Created: / 27-06-2013 / 23:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2013 / 01:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleSIGUSR2
    self dumpProcesses

    "Created: / 27-06-2013 / 23:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupSignalHandlers
    "On UNIX, this sets up a custom signal handler on SIGUSR2 and SIGTERM that
     dumps stacks on all threads"

    | sigusr2 sigterm |

    OperatingSystem isUNIXlike ifTrue:[


        sigterm := Signal new.
        sigterm handlerBlock: [:ex | self handleSIGTERM].
        OperatingSystem operatingSystemSignal:OperatingSystem sigTERM install: sigterm.
        OperatingSystem enableSignal: OperatingSystem sigTERM.

        sigusr2 := Signal new.
        sigusr2 handlerBlock: [:ex | self handleSIGUSR2].
        OperatingSystem operatingSystemSignal:OperatingSystem sigUSR2 install: sigusr2.
        OperatingSystem enableSignal: OperatingSystem sigUSR2.
    ].

    "
    OperatingSystem sendSignal: OperatingSystem sigUSR2 to: OperatingSystem getProcessId
    "

    "Created: / 27-06-2013 / 20:57:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2013 / 01:11:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupToolsForDebug

    super setupToolsForDebug.
    debugging := true.

    "Created: / 06-11-2011 / 22:06:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start
    Smalltalk silentLoading: true.
    ^ super start.

    "Created: / 22-01-2014 / 09:17:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usage

    Stderr nextPutAll:'usage: report-runner.';
           nextPutAll: (OperatingSystem isMSWINDOWSlike ifTrue:['bat'] ifFalse:['sh']);
           nextPutAll: ' [-D <dir>] -r <report> [-p <package1> [-p <package2> [...]]]'; cr.

    Stderr nextPutLine:'Common options:'; cr.

    Stderr nextPutLine:'  --help .................. output this message'.
"/    Stderr nextPutLine:'  --verbose ............... verbose startup'.
"/    Stderr nextPutLine:'  --noBanner .............. no splash screen'.
"/    Stderr nextPutLine:'  --newAppInstance ........ start as its own application process (do not reuse'.
"/    Stderr nextPutLine:'                            a running instance)'.
"/    self allowScriptingOption ifTrue:[
"/        Stderr nextPutLine:'  --scripting portNr ...enable scripting via port (or stdin/stdOut if 0)'.
"/    ].
    self allowDebugOption ifTrue:[
        Stderr nextPutLine:'  --debug ................. enable Debugger'.
    ].
    "/                 '  ......................... '
    Stderr nextPutLine:'  -D <dir>'.
    Stderr nextPutLine:'  --output-directory=<dir>  directory where report files will go'.
    Stderr nextPutLine:'  -S <expr>'.
    Stderr nextPutLine:'  --setup=<expr> .......... smalltalk expression that is evaluated before'. 
    Stderr nextPutLine:'                            any report is run'.
    Stderr nextPutLine:'  -T <expr>'.
    Stderr nextPutLine:'  --teardown=<expr> ....... smalltalk expression that is evaluated before'. 
    Stderr nextPutLine:'                            after all reports finished'.
    Stderr nextPutLine:'  -i <ident>'.
    Stderr nextPutLine:'  --ident=<ident> ......... run/configuration identification string to'.
    Stderr nextPutLine:'                            use when creating output files'.
    Stderr nextPutLine:'  -r <report class>'.
    Stderr nextPutLine:'  --report=<report class> . report to run. available reports:'.
    Report available do:[:report|
        Stderr nextPutAll:'      '; nextPutLine: report name
    ].
    Stderr nextPutLine:'  -p <package>'.
    Stderr nextPutLine:'  --package=<package> ..... package to run report on'.
    Stderr nextPutLine:'                            May be specified multiple times.'.

    Report available do:[:cls|
        self usageForReportClass: cls.
    ].


    debugging ifFalse:[
        Smalltalk exit:1.
    ].
    "
    self usage
    "

    "Created: / 13-01-2012 / 11:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2014 / 17:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usageForReportClass: class
    | options |

    "/ '.........................' size  25
    options := CmdLineOption optionsFor: class new.
    options := options reject:[:option | 'pF' includes: option short  ].
    options notEmptyOrNil ifTrue:[
        Stderr cr.
        Stderr nextPutAll: class name; nextPutLine:' options:'; cr.
        options do:[:option |                
            | optlen |  

            option short notNil ifTrue:[ 
                Stderr nextPutAll: '  '.
                Stderr nextPut: $-; nextPut: option short; space.
                optlen := 2.
                option hasParam ifTrue:[ 
                    | paramName |

                    paramName := 'val'.
                    Stderr nextPut:$<; nextPutAll: paramName; nextPut:$>; space.
                    optlen := optlen + 3 + paramName size.
                ].
            ].
            option long notNil ifTrue:[ 
                 option short notNil ifTrue:[ 
                    Stderr cr.
                ].
                Stderr nextPutAll: '  --'.
                Stderr nextPutAll: option long.
                optlen := option long size + 2.
                option hasParam ifTrue:[ 
                    | paramName |

                    paramName := 'val'.
                    Stderr nextPut:$=; nextPut:$<; nextPutAll: paramName; nextPut:$>.
                    optlen := optlen + 3 + paramName size.
                ].
                Stderr space.
            ].
            Stderr next: (26 - 1"space" -2"--" - optlen) put: $..    
            Stderr space.
            option description notNil ifTrue:[
                Stderr nextPutAll: option description
            ].
            Stderr cr.
        ]
    ]

    "
    ReportRunner usageForReportClass: TestReport.
    "

    "Created: / 27-05-2014 / 16:42:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-06-2014 / 11:25:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportRunner class methodsFor:'startup-to be redefined'!

main:argv0
    "Process command line arguments"

    | argv |

    argv := argv0 asOrderedCollection.
    argv isEmpty ifTrue:[ 
        self usage.
    ].
    argv remove: '--abortOnSEGV' ifAbsent:[nil].
    parser := CmdLineParser new.
    CmdLineOptionError autoload.

    [
        parser parse: argv for: self.
    ] on:CmdLineOptionError do:[:ex|
        Stderr nextPutLine:'Error when processing options: ', ex description.
        debugging ifFalse:[
            ex suspendedContext fullPrintAllOn: Stderr.
            Stderr nextPutLine:'Exiting'.
            Smalltalk exit:1.
        ] ifTrue:[
            ex pass
        ]
    ].

    debugging ifFalse:[ 
        NoHandlerError emergencyHandler:(NoHandlerError abortingEmergencyHandler)
    ].

    [
        setup notNil ifTrue:[Compiler evaluate: setup].
        [
            report ident: ident.
            report run.
        ] ensure:[
            teardown notNil ifTrue:[Compiler evaluate: teardown].
        ].
        debugging ifFalse:[
            Smalltalk exit:0.
        ].
    ] on: Error do:[:ex|
        Stderr nextPutAll:'Error when running tests: '.
        Stderr nextPutAll:ex description; cr.
        ex suspendedContext printAllOn:Stderr.


        debugging ifFalse:[
            Smalltalk exit:1.
        ] ifTrue:[
            ex pass
        ]
    ]

    "Modified: / 27-05-2014 / 17:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportRunner class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


ReportRunner initialize!
