"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

Report subclass:#TestReport
	instanceVariableNames:'suite coverage instrument keepStdout keepBytecode'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports'
!

TestResult subclass:#Result
	instanceVariableNames:'format time timeoutScale timeoutScaleReassesmentTime npassed
		nfailed nerror nskipped collector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestReport
!


!TestReport methodsFor:'accessing'!

keepBytecode
    ^ keepBytecode
!

keepBytecode:aBoolean
    keepBytecode := aBoolean.
!

keepStdout
    ^ keepStdout
!

keepStdout:aBoolean
    keepStdout := aBoolean.
!

suite
    ^ suite

    "Created: / 07-11-2011 / 09:41:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport methodsFor:'accessing - defaults'!

defaultFileSuffix

    ^'Test'

    "Created: / 04-08-2011 / 12:56:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFormat
    "superclass HDReport says that I am responsible to implement this method"

    ^ Builder::TestReportFormat::JUnit new

    "Created: / 04-08-2011 / 11:54:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultName

    ^String streamContents:[:s|
        suite tests do:[:suite|
            s nextPutAll: suite name
        ] separatedBy:[
            s nextPut:$,;space
        ]
    ]

    "Created: / 07-11-2011 / 09:47:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport methodsFor:'command line options'!

cmdlineOptionCoverage

    ^CmdLineOption new
        short: $c;
        long: 'coverage';
        description: 'collect code coverage when running tests';
        action:[
            coverage := CoverageReport new.
        ]

    "Created: / 25-06-2013 / 15:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2014 / 16:54:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionDropStdout

    ^CmdLineOption new
        long: 'drop-stdout';
        description: 'Do not include stdout in report';
        action:[
            keepStdout := false
        ]

    "Created: / 08-08-2014 / 11:48:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionInstrument

    ^CmdLineOption new
        short: $I;
        long: 'instrument';
        description: 'extra package to instrument for coverage (implies --coverage)';
        action:[:package |
            instrument isNil ifTrue:[ 
                instrument := Set new.
            ].
            instrument add: package.
            coverage isNil ifTrue:[ 
                coverage := CoverageReport new.
            ].

        ]

    "Created: / 27-05-2014 / 16:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionKeepBytecode

    ^CmdLineOption new
        long: 'keep-bytecode';
        description: 'Keep and include method''s bytecode in reported stacktraces. May generate huge report!!';
        action:[
            keepBytecode := true
        ]

    "Created: / 15-03-2016 / 14:32:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cmdlineOptionKeepStdout

    ^CmdLineOption new
        long: 'keep-stdout';
        description: 'Keep stdout and include it in report (may generate huge report!!)';
        action:[
            keepStdout := true
        ]

    "Created: / 16-06-2014 / 10:42:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport methodsFor:'initialization'!

initialize

    suite := TestSuite new.
    coverage := nil.
    keepStdout := true.

    "Modified: / 08-08-2014 / 11:45:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForClasses:classes
    "Setup the report to run given classes"

    | suiteFromClasses |

    suiteFromClasses := TestSuite named:name.
    classes do:
            [:cls | 
            |tc|

            cls isTestCaseLike 
                ifTrue:
                    [ tc := cls asTestCase.
                    tc isAbstract ifFalse:[ suiteFromClasses addTest:tc suite ] ] ].

    self setupForSuite: suiteFromClasses.

    "Created: / 04-08-2011 / 14:34:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForPackages:pkgs 

    pkgs do: [:pkg | 
        |def |

        self loadPackageIfNotAlready: pkg.
        def := ProjectDefinition definitionClassForPackage:pkg.

        (def respondsTo:#testSuite) ifTrue:[ 
            suite addTest:def testSuite 
        ] ifFalse:[ 
            | classes psuite |
            psuite := TestSuite named:pkg.

            classes := def notNil 
                        ifTrue:[ def classes ]
                        ifFalse:[ ProjectDefinition searchForClassesWithProject:pkg asSymbol ].
            classes do: [:cls | 
                |tc|

                cls isTestCaseLike ifTrue: [ 
                    tc := cls asTestCase.
                    tc isAbstract ifFalse:[ 
                        psuite addTest:tc suite
                    ]
                ]
            ].
            suite addTest: psuite.
        ]
    ].
    coverage notNil ifTrue:[
        coverage setupForPackages: packages.
        instrument notNil ifTrue:[ 
            coverage setupForPackages: instrument.
        ].
    ]

    "Modified: / 27-05-2014 / 16:35:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForSuite: suiteToAdd

    suite addTest: suiteToAdd.

    "Created: / 06-11-2011 / 18:27:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport methodsFor:'private'!

print: anObject on: aStream

    [ anObject printOn: aStream ]
        on: Error do:
            [aStream 
                nextPutAll: '** error when prining instance of ';
                nextPutAll: anObject class name;
                nextPutAll: '**']

    "Created: / 15-03-2011 / 22:09:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport methodsFor:'running'!

runReport

    | result t0 t1 |
    result := Result new format:format.
    t0 := Timestamp now.
    coverage notNil ifTrue:[
        InstrumentationContext  run:[
            suite run:result.
        ].
        Transcript cr; cr.
        Transcript show: 'COLLECTING COVERAGE...'.
        coverage name: self name.
        coverage ident: self ident.
        coverage run.
    ] ifFalse:[
        suite run:result.
    ].
    t1 := Timestamp now.

    Transcript cr; cr.

    result failureOutcomes do:[:failureOutcome |
        Transcript show: 'FAILED '.
        failureOutcome testCase printOn: Transcript.
        Transcript cr.
    ].
    result errorOutcomes do:[:errorOutcome |
        Transcript show: 'ERROR  '.
        errorOutcome testCase printOn: Transcript.
        Transcript cr.
    ].
    Transcript cr; cr.
    Transcript show: 'SUMMARY: '.
    result printOn: Transcript.
    Transcript show: ', test execution time '.
    (t1 - t0) printOn: Transcript.
    Transcript cr.

    "Created: / 04-08-2011 / 12:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2017 / 12:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport::Result methodsFor:'accessing'!

errorCount

    ^nerror

    "Created: / 31-01-2013 / 13:54:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptions

    ^super exceptions , HaltInterrupt

    "Created: / 03-08-2011 / 14:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failureCount

    ^nfailed

    "Created: / 31-01-2013 / 13:53:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

format
    ^ format
!

format:aFormat
    format := aFormat.
!

passedCount

    ^npassed

    "Created: / 31-01-2013 / 13:54:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skippedCount

    ^nskipped

    "Created: / 31-01-2013 / 13:54:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timeoutScale
    "Return a timeout scaling factor used to adjust test-case defined timeout.
     This is required in order to stabilize tests on different computers and setups.
     Slower machines may need higher timeout otherwise tests may fail."

    "/ This scaling factor is computed automatically by running a (not so) simple 
    "/ benchmark. To make things more complicated, we have to re-asses the scaling
    "/ factor time to time as machine performance may vary depending on a load - this
    "/ happens specially on CI setups where CI slaves are virtualized and running on
    "/ heavily-loaded systems.
    "/ 
    "/ The benchmark itself consists of:
    "/ 
    "/    * CPU benchmark - to handle systems with slow CPUs such as some
    "/      low-end Celerons on RPi-kind of thing)
    "/    * IO benchmark - to handle the case of slow IO on overloaded host
    "/      running many tests in parallel.
    "/ 


    (timeoutScale isNil or: [timeoutScaleReassesmentTime < OperatingSystem getMillisecondTime ]) ifTrue:[ 
        | time1 files time2 scale1 scale2 |

        "/ simple CPU benchmark
        time1 := Time millisecondsToRun:[3000 timesRepeat: [ 2000 factorial ]].
        scale1 := time1 / 2500"mean value of an i5 64bit".

        files := (Smalltalk getPackageDirectoryForPackage: self class package) recursiveDirectoryContentsAsFilenames 
                    select: [:e | e isRegularFile and:[e suffix = 'st']].
        time2 := Time millisecondsToRun:[ 10 timesRepeat: [ files shuffled do:[:e|e contents ] ] ].
        scale2 := time2 / 2500"mean value of an 64bit linux ext4 on SATA SSD".

        timeoutScale := (scale1 max: scale2) max: 1.
        timeoutScaleReassesmentTime := OperatingSystem getMillisecondTime + (1000*60*3) "/ reasses every three minutes
    ].
    ^ timeoutScale

    "
    Builder::TestReport::Result new timeoutScale; timeoutScale
    "

    "Created: / 24-08-2018 / 09:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 24-08-2018 / 11:20:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport::Result methodsFor:'adding'!

addError: testcase detail: exception

    outcome result: (TestResult stateError).
    outcome collectedOutput: collector contents. 
    format writeTestCase: testcase outcome: outcome time: time exception: exception.
    Transcript show:'...ERROR'.
    Logger trace: 'Finised %1>>%2, result ERROR' with: testcase nameForHDTestReport with: testcase selectorForHDTestReport.
    self errorOutcomes add:outcome.      
    nerror := nerror + 1.

    "Created: / 03-08-2011 / 15:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-10-2014 / 14:02:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addFailure: testcase detail: exception

    outcome result: (TestResult stateFail).
    outcome collectedOutput: collector contents. 
    format writeTestCase: testcase outcome: outcome time: time exception: exception.
    Transcript show:'...FAILED'.
    Logger trace: 'Finised %1>>%2, result FAILED' with: testcase nameForHDTestReport with: testcase selectorForHDTestReport.
    self failureOutcomes add: outcome.
    nfailed := nfailed + 1.

    "Created: / 03-08-2011 / 15:00:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-10-2014 / 14:01:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addPass: testcase

    outcome result: TestResult statePass.
    format writeTestCase: testcase outcome: outcome time: time exception: nil.
    Transcript show:'...OK'.
    Logger trace: 'Finised %1>>%2, result PASSED' with: testcase nameForHDTestReport with: testcase selectorForHDTestReport.
    npassed := npassed + 1.

    "Created: / 03-08-2011 / 15:19:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-10-2014 / 14:01:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSkipped: testcase

    outcome := self createOutcome.
    outcome testCase: testcase.        
    outcome result: TestResult stateSkip.
    format writeTestCase: testcase outcome: outcome time: time exception: nil.
    Transcript show:'...SKIPPED'.
    Logger trace: 'Finised %1>>%2, result SKIPPED' with: testcase nameForHDTestReport with: testcase selectorForHDTestReport.
    nskipped := nskipped + 1.

    "Created: / 21-11-2012 / 15:35:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-10-2014 / 14:01:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport::Result methodsFor:'initialization'!

initialize
    super initialize.

    npassed := nfailed := nerror := nskipped := 0.
    timeoutScaleReassesmentTime := 0

    "Created: / 31-01-2013 / 13:52:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2018 / 10:58:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport::Result methodsFor:'running'!

performCase:aTestCase 
    | savedStdout savedStderr savedTranscript encoder |

    savedStdout := Stdout.
    savedStderr := Stdout.
    savedTranscript := Transcript.
    encoder := OperatingSystem isMSWINDOWSlike 
                ifTrue:[ CharacterEncoder encoderForUTF8 ]
                ifFalse:[ CharacterEncoder encoderFor: OperatingSystem getCodeset ].
    collector := WriteStream on:(String new:100).
    [
        Stdout := SplittingWriteStream on:collector and: (EncodedStream stream: Stdout encoder: encoder).
        Stderr := SplittingWriteStream on:collector and: (EncodedStream stream: Stderr encoder: encoder).
        Transcript := SplittingWriteStream on:collector and: Transcript.
        time := Time millisecondsToRun: [ super performCase: aTestCase ]
    ] ensure:[
        Stdout := savedStdout.
        Stderr := savedStderr.
        Transcript := savedTranscript.
        outcome collectedOutput: nil. "/ flush it, it has been written to output already
        collector := nil.
    ].

    "Created: / 03-08-2011 / 18:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:12:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCase:aTestCase debugged: debugged 

    | timeout |
    timeout := aTestCase timeout.

    self runCase: aTestCase debugged: debugged 
         fork:  (aTestCase shouldFork or:[timeout notNil])
         timeout: timeout ? 60"sec"

    "Created: / 22-08-2011 / 14:37:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCase:aTestCase debugged: debugged fork:doFork

    ^self runCase:aTestCase debugged: debugged 
          fork:doFork timeout: aTestCase timeout ? 60"sec"

    "Created: / 22-08-2011 / 14:38:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCase:aTestCase debugged: debugged fork:doFork timeout: tout
    | nm sel |

    (aTestCase perform: #shouldSkip ifNotUnderstood:[false]) ifTrue:[
        self addSkipped: aTestCase.
        ^self.
    ].

    nm := aTestCase nameForHDTestReport.
    nm size > 20 ifTrue:[
        nm := (nm copyTo: 17) , '...'
    ].
    sel := aTestCase selectorForHDTestReport.
    sel size > 20 ifTrue:[
        sel := '...' , (sel copyFrom: sel size - 16 to: sel size)
    ].
    Transcript showCR:('%1 >> #%2' bindWith: aTestCase nameForHDTestReport with: aTestCase selectorForHDTestReport).
    Transcript show:('%-20s >> %-20s : ' printfWith: nm with: sel).

    outcome := self createOutcome.
    outcome testCase: aTestCase.

    doFork ifFalse:[ 
        super runCase:aTestCase debugged: debugged.
        Transcript cr.
        ^self.
    ].

    OperatingSystem isUNIXlike ifTrue:[
"/        self unixForkCase: aTestCase debugged: debugged.
"/      Use lightweight forking
        self lightForkCase: aTestCase debugged: debugged timeout: tout.
        ^ self.
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[
        self lightForkCase: aTestCase debugged: debugged timeout: tout.
        ^ self.
    ].

    self error:'Unssuported platform'

    "Created: / 12-01-2012 / 17:52:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-10-2014 / 13:57:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport::Result methodsFor:'running-private'!

lightForkCase:aTestCase debugged: debugged timeout: timeoutBase
    | timeout thread sema stime etime timeouted error stack log logPos |

    Logger trace: 'Running %1>>%2' with: aTestCase nameForHDTestReport with: aTestCase selectorForHDTestReport.
    Transcript show:'F'.
    timeout := (timeoutBase * self timeoutScale) rounded. 
    sema := Semaphore new.
    stime := OperatingSystem getMillisecondTime.
    log := false.
    logPos := format stream stream position.
    timeouted := false.
    thread := [ super runCase:aTestCase debugged: debugged ] newProcess.
    thread addExitAction:[sema signal].
    thread name: ('Testcase execution thread (%1)' bindWith: aTestCase).
    thread resume.

    Transcript show: 'W'.
    (sema waitWithTimeout:timeout) isNil ifTrue: [
        Transcript show: 'T'.
        stack := String streamContents:[:s |  ReportRunner dumpProcessesOn:s ].
        thread terminate.
        timeouted := true.
        Transcript show: 'K'.
    ].

    etime := OperatingSystem getMillisecondTime.
    timeouted ifTrue:[
        error := TimeoutError new messageText: ('Timed out (effective %1ms, base %2ms, scale %3)' bindWith: timeout with: timeoutBase with: timeoutScale asFloat) .
        outcome isNil ifTrue:[ outcome := self createOutcome ].
        outcome result: TestResult stateError.
        format 
            writeTestCase: aTestCase outcome: outcome 
                     time: etime - stime
                exception: error
               stacktrace: stack.
         Transcript show:'...ERROR'.
         Logger trace: 'Finised %1>>%2, result ERROR (timeout)' with: aTestCase nameForHDTestReport with: aTestCase selectorForHDTestReport.
    ].

    outcome := nil.
    Transcript cr.

    "Created: / 12-01-2012 / 17:42:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2018 / 11:19:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unixForkCase:aTestCase debugged: debugged timeout: timeoutBase
    | timeout pid status sema stime etime error stack suiteFailuresBefore suiteErrorsBefore log logPos |

    Transcript show:'forking...'.
    timeout := (timeoutBase * self timeoutScale) rounded.   
    sema := Semaphore new.
    stime := OperatingSystem getMillisecondTime.
    log := false.
    logPos := format stream stream position.
    Processor monitor:
            [ pid := OperatingSystem fork.
            pid == 0 ifTrue:[ nil ] ifFalse:[ pid ] ]
        action:
            [:s | 
            Transcript show:'child finished...'.
            status := s.
            sema signal ].
    pid == 0 
        ifTrue:
            [ "Child, exit codes:
             0...PASSED
             1...FAILED
             2...ERROR
           >64...got signal <code>-64"
            
            [ suiteFailuresBefore := failures.
            suiteErrorsBefore := errors.
            super runCase:aTestCase debugged: debugged.
            suiteErrorsBefore ~~ errors ifTrue:[ Smalltalk exit:2 ].
            suiteFailuresBefore ~~ failures ifTrue:[ Smalltalk exit:1 ].
            format streamClose.
            Smalltalk exit:0. ] on:OSSignalInterrupt
                    do:[:ex | format streamClose. Smalltalk exit:64 + ex parameter ] ]
        ifFalse:
            [ "Parent"
            format streamClose.
            Transcript show: 'waiting for child...'.
            (sema waitWithTimeout:timeout) isNil 
                ifTrue:
                    [Transcript show: 'timeout...'.
                    OperatingSystem terminateProcess:pid.
                    OperatingSystem childProcessWait:true pid:pid.
                    Transcript show: 'killed...'.
                    ].
            etime := OperatingSystem getMillisecondTime.
            (status isNil or:[ status success not ]) 
                ifFalse:[
                    "/child finished, result is pass. However, it is not in my passed collection
                    "/since addPass: has been called in child process
                   super addPass: aTestCase.
                ] ifTrue:
                    [ log := true.
                    status isNil 
                        ifTrue:
                            [ error := TimeoutError new messageText: ('Timed out (effective %1ms, base %2ms, scale %3)' bindWith: timeout with: timeoutBase with:timeoutScale asFloat) .
                            stack := 'Oops, timed out!! (timeout was ' , timeout printString , ' sec)'. ]
                        ifFalse:
                            [ status status == #signal 
                                ifTrue:
                                    [ error := OSSignalInterrupt new parameter:status code.
                                    stack := 'Oops, VM terminated on signal ' , status code printString, ' (stactrace not awailable)' ].
                            status status == #exit 
                                ifTrue:
                                    [ status code == 1 
                                        ifTrue:
                                            [super addFailure: aTestCase detail: nil.
                                            log := false ].
                                    status code == 2 
                                        ifTrue:
                                            [super addError: aTestCase detail: nil.
                                            log := false ].
                                    status code > 64 
                                        ifTrue:
                                            [ error := OSSignalInterrupt new parameter:status code - 64.
                                            stack := 'Oops, VM terminated on signal ' , status code p ] ] ]. ].
            format streamOpenForAppend.
            log ifTrue:[
                     outcome result: TestResult stateError.
                     format stream stream position: logPos.
                     format 
                        writeTestCase: aTestCase outcome: outcome 
                                 time: etime - stime
                            exception: error
                           stacktrace: stack.
                     Transcript show:'ERROR'
            ]
    ].
    outcome := nil.
    Transcript cr.

    "Created: / 12-01-2012 / 17:43:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2018 / 11:19:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReport class methodsFor:'documentation'!

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

