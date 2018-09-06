"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

StandaloneStartup subclass:#JavaBenchmarkRunner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Framework'
!

JavaBenchmarkRunner class instanceVariableNames:'benchmark passes variant debugging profiler jit'

"
 The following class instance variables are inherited by this class:

	StandaloneStartup - MutexHandle
	Object - 
"
!


!JavaBenchmarkRunner class methodsFor:'initialization'!

initialize

    super initialize.
    debugging := Transcript notNil and:[Transcript isView].
    variant := #runJ:

    "Created: / 06-11-2011 / 22:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-10-2012 / 23:42:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkRunner class methodsFor:'accessing'!

profiler
    ^ profiler
! !

!JavaBenchmarkRunner class methodsFor:'command line options'!

cmdlineOptionBenchmark

    ^CmdLineOption new
        short: $b;
        long: 'benchmark';
        description: 'benchmark to run (class name)';
        action:[:option |
            benchmark := Smalltalk at: option asSymbol.
            benchmark isNil ifTrue:[
                Class withoutUpdatingChangesDo:[
                    benchmark := JavaBenchmark subclass:option asSymbol
                                    instanceVariableNames:''
                                    classVariableNames:''
                                    poolDictionaries:''
                                    category:'Benchmarks-Java-Created on demand'.
                    benchmark setPackage: #'__temporary__'.
                ].
            ].
            benchmark isNil ifTrue:[
                Stderr nextPutLine: 'ERROR: No such benchmark: ', option.
                self exit: 0.
            ]
        ]

    "Created: / 31-10-2012 / 10:49:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2013 / 11:57:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionJava

    ^CmdLineOption new
        short: $j;
        long: 'java';
        description: 'run Java version of the benchmark (default)';
        action:[
            variant := #runJ:
        ]

    "Created: / 31-10-2012 / 11:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-10-2012 / 23:41:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionJit

    ^CmdLineOption new
        short: $J;
        long: 'jit';
        description: 'turn on mcompiler';
        action:[
            jit := true
        ]

    "Created: / 01-05-2013 / 14:59:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionNoJit

    ^CmdLineOption new
        short: $N;
        long: 'nojit';
        description: 'turn off mcompiler';
        action:[
            jit := false
        ]

    "Created: / 01-05-2013 / 14:59:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionPasses

    ^CmdLineOption new
        short: $n;
        long: 'passed';
        description: 'how many passes to run (integer)';
        action:[:option |
            passes := Integer readFrom: option onError:[
                Stderr nextPutLine: 'ERROR: Not an integer value: ', option.
                self exit: 0.
            ]
        ]

    "Created: / 31-10-2012 / 10:52:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 02:32:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionSmalltak

    ^CmdLineOption new
        short: $s;
        long: 'smalltalk';
        description: 'run Smalltalk version of the benchmark';
        action:[
            variant := #runS:
        ]

    "Created: / 31-10-2012 / 11:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-10-2012 / 23:41:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionSmalltak2Java

    ^CmdLineOption new
        short: $k;
        long: 'smalltalk2java';
        description: 'run cross-language version of the benchmark';
        action:[
            variant := #runS2J:
        ]

    "Created: / 31-10-2012 / 23:42:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkRunner class methodsFor:'defaults'!

allowCoverageMeasurementOption

    ^true

    "Created: / 13-01-2012 / 11:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-10-2012 / 10:38:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowDebugOption

    ^true

    "Created: / 21-07-2011 / 09:48:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkRunner class methodsFor:'startup'!

setupToolsForDebug

    super setupToolsForDebug.
    debugging := true.

    "Created: / 06-11-2011 / 22:06:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usage

    Stderr nextPutLine:'usage:'; cr;
           nextPutAll:'   benchmark-runner.';
           nextPutAll: (OperatingSystem isMSWINDOWSlike ifTrue:['bat'] ifFalse:['sh']);
           nextPutAll: ' -b <benchmark> -n <n>'; cr; cr.

    Stderr nextPutLine:'  --help .................. output this message'.
"/    Stderr nextPutLine:'  --verbose ............... verbose startup'.
"/    Stderr nextPutLine:'  --noBanner .............. no splash screen'.
"/    Stderr nextPutLine:'  --newAppInstance ........ start as its own application process (do not reuse a running instance)'.
"/    self allowScriptingOption ifTrue:[
"/        Stderr nextPutLine:'  --scripting portNr ...... enable scripting via port (or stdin/stdOut, if 0)'.
"/    ].
    self allowDebugOption ifTrue:[
        Stderr nextPutLine:'  --debug ................. enable Debugger'.
    ].

    "/                 '  ......................... '
    Stderr nextPutLine:'  -b <benchmark>'.
    Stderr nextPutLine:'  --benchmark=<benchmark> . benchmark to run (class name)'.
    Stderr nextPutLine:'  -n <n>'.
    Stderr nextPutLine:'  --passes ................ how many passes of given benchmark (integer)'.
    Stderr nextPutLine:'  -j'.
    Stderr nextPutLine:'  --java ..,............... run Java version of the benchmark (default)'.
    Stderr nextPutLine:'  -s'.
    Stderr nextPutLine:'  --smalltalk ............. run Smalltalk version of the benchmark'.



    "
    self usage
    "

    "Created: / 13-01-2012 / 11:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-10-2012 / 11:05:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkRunner class methodsFor:'startup-to be redefined'!

exit: code
    debugging ifFalse:[
        Smalltalk exit: code
    ].

    "Created: / 02-11-2012 / 02:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

main:argv

    "Process command line arguments"
    | parser |

    jit := true.
    parser := CmdLineParser new.
    [               
        parser parse: argv for: self.        
    ] on: Error do:[:ex|
        Stderr nextPutLine:'Error when processing options: ', ex description.
        debugging ifFalse:[     
            ex suspendedContext fullPrintAllOn: Stderr.
            Stderr nextPutLine:'Exiting'.
            Smalltalk exit:1.
        ] ifTrue:[
            ex pass
        ]        
    ].

    "Set stack size to 16MB"
    Processor activeProcess setMaximumStackSize: ((1024 * 1024 * 16) max: Process defaultMaximumStackSize).

    "Setup for performance"
    JavaNativeMethod cacheNativeImplementation: true.

    ObjectMemory justInTimeCompilation: jit.
    ObjectMemory javaNativeCodeOptimization:jit.
    ObjectMemory javaJustInTimeCompilation: jit.    

    ObjectMemory newSpaceSize: ObjectMemory newSpaceSize * 5.

    [
        | time |

        Profiler valgrind runningUnderValgrind ifTrue:[
            profiler := #callgrind
        ].

        time := benchmark new 
                    profiler: profiler;
                    perform: variant with: passes.
        Stdout nextPutLine: 'EXECUTION TIME: ' , time printString.

        debugging ifFalse:[
            Smalltalk exit:0.
        ].
    ] on: Error do:[:ex|
        Stderr nextPutAll:'Error when running benchmark: '.
        Stderr nextPutAll:ex description; cr.
        ex suspendedContext printAllOn:Stderr.
        debugging ifFalse:[
            Smalltalk exit:1.
        ] ifTrue:[
            ex pass
        ]
    ]

    "Modified: / 01-05-2013 / 15:00:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBenchmarkRunner class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/JavaBenchmarkRunner.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !


JavaBenchmarkRunner initialize!
