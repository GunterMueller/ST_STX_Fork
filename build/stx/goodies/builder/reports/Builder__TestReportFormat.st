"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

ReportFormat subclass:#TestReportFormat
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Formats'
!

TestReportFormat subclass:#JUnit
	instanceVariableNames:'position failures errors skipped startTime stopTime'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestReportFormat
!

TestReportFormat subclass:#PerfPublisher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestReportFormat
!

TestReportFormat subclass:#PythonUnittest
	instanceVariableNames:'index'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestReportFormat
!

TestReportFormat subclass:#TAP
	instanceVariableNames:'index'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestReportFormat
!


!TestReportFormat class methodsFor:'testing'!

isAbstract

    ^self == TestReportFormat

    "Created: / 04-08-2011 / 11:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat methodsFor:'accessing - defaults'!

defaultFileSuffix
    "superclass HDReportFormat says that I am responsible to implement this method"

    ^ 'xml'

    "Modified: / 04-08-2011 / 12:48:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat methodsFor:'writing'!

writeTestCase: testcase outcome: outcome time: time exception: exception

    | stacktrace |
    exception isNil ifTrue:[
        stacktrace := nil.        
    ] ifFalse:[
        stacktrace :=
            (String streamContents:[:s|
                self writeStackTrace: exception of: testcase on: s
            ])
    ].

    ^self writeTestCase: testcase outcome: outcome time: time exception: exception 
             stacktrace: stacktrace

    "Created: / 03-08-2011 / 19:44:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeTestCase: testcase outcome: outcome time: time exception: exception stacktrace: stacktrace

    "Write an outcome of a given test.
     Argumments:
        testcase....the testcase <TestCase>
        outcome.....the testcase outcome <TestCaseOutcome>
        time........time taken to run the test in milliseconds
        exception...exception that caused error/failure or nil if N/A < Exception | nil >
        backtrace...stacktrace info or nil if N/A <String | nil >"

    self subclassResponsibility

    "Created: / 03-08-2011 / 19:43:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 06-06-2014 / 00:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat methodsFor:'writing - utilities'!

writeContext: context on: s

    |home mthd src vars args argAndVarNames |
    [
    context printOn: s.
    s cr.
    s nextPutAll:'receiver: '. context receiver printOn: s. s cr.
    s nextPutAll:'selector: '. context selector storeOn: s. s cr.

    args := context args.
    vars := context vars.
    argAndVarNames := context argAndVarNames.
    s nextPutAll:'args: '; cr.

    args keysAndValuesDo:[:idx :eachArg |
        s nextPutAll:'  '. idx printOn: s leftPaddedTo:2 . s space. (argAndVarNames at: idx ifAbsent:['']) printOn: s paddedTo:12. s nextPutAll:': '. eachArg printOn: s.s cr.
    ].
    s nextPutAll:'vars: '; cr.
    vars keysAndValuesDo:[:idx :eachVar |
        s nextPutAll:'  '. idx printOn: s leftPaddedTo:2. s space. (argAndVarNames at: idx + args size ifAbsent:['']) printOn: s paddedTo:12. s nextPutAll:': '. 
        eachVar isString ifTrue:[
            eachVar storeOn: s.
        ] ifFalse:[
            eachVar printOn: s.
        ].
        s cr.
    ].
    home := context methodHome.
    mthd := home method.  

    report keepBytecode ifTrue:[
        s nextPutAll:'bytecode: '; cr.    
        mthd notNil ifTrue:[ 
            (mthd isJavaMethod and:[mthd class ~~ JavaNativeMethod]) ifFalse:[ 
                Decompiler decompile: mthd to: s.
            ] ifTrue:[ 
                (Smalltalk at: #JavaByteCodeDisassembler) notNil ifTrue:[ 
                    (Smalltalk at: #JavaByteCodeDisassembler) diassemble: mthd to: s.
                ] ifFalse:[ 
                    s nextPutAll: ' ** no JavaByteCodeDisassembler **'  
                ].
            ].
        ].
    ].

    s cr.
    s nextPutAll:'source: '; cr.    
    [
    mthd isNil ifTrue:[
         s nextPutAll: '** no source **'. s cr. s cr.
        ^ self.
    ].
    src := mthd source.
    src isNil ifTrue:[
        s nextPutAll: '** no source **'. s cr. s cr.
        ^ self.
    ].
    ] on: Error do:[:ex|
        s 
            nextPutAll: '** error when getting source: ';
            nextPutAll:  ex description;
            nextPutAll: '**';
            cr; cr.
        ^ self.
    ].
    src := src asCollectionOfLines.
    src keysAndValuesDo:[:lNr :line |
        lNr == context lineNumber ifTrue:[
            s nextPutAll:'>> '.
        ] ifFalse:[
            s nextPutAll:'   '.
        ].
        s nextPutAll: line; cr.
    ].
    s cr.
    ] on: Error do:[:ex|
        s   cr;
            nextPutAll:'!!!!!!ERROR WHEN GETTING STACK TRACE!!!!!!'; cr;
            nextPutAll: ex description; cr
    ]. 

    "
    String streamContents:[ :s | Builder::TestReportFormat basicNew writeContext: thisContext on: s ]
    "

    "Created: / 03-08-2011 / 14:53:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2016 / 14:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeStackTrace:err of:aTestCase on: str

    | context |

    context := err signalerContext.

    [ context notNil ] whileTrue:[
        self writeContext: context on: str.
        str cr; cr.

        context receiver == aTestCase ifTrue:[
            context selector == aTestCase selector ifTrue:[ ^ self ].
            context selector == #setUp ifTrue:[ ^ self ].
        ].
        context := context sender.

    ].

    "Created: / 03-08-2011 / 14:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2016 / 14:33:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::JUnit class methodsFor:'accessing'!

symbolicNames
    ^ #( #junit #junit40 )

    "Created: / 04-08-2011 / 11:45:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::JUnit class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

!TestReportFormat::JUnit methodsFor:'initialization'!

initialize

    super initialize.
    errors := 0.
    failures := 0.
    skipped := 0.

    "Created: / 03-08-2011 / 15:26:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2012 / 15:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::JUnit methodsFor:'writing'!

writeFooter
    stopTime := OperatingSystem getMillisecondTime.
    stream
        tab;
        nextPutAll:'<system-out><!![CDATA[]]></system-out>';
        nextPut:Character lf.
    stream
        tab;
        nextPutAll:'<system-err><!![CDATA[]]></system-err>';
        nextPut:Character lf.
    stream nextPutAll:'</testsuite>'.
    stream stream position:position.
    stream
        nextPutAll:' failures="';
        print:failures;
        nextPutAll:'" errors="';
        print:errors;
        nextPutAll:'" skipped="';
        print:skipped;
        nextPutAll:'" time="';
        print:(Time milliseconds:stopTime since:startTime) / 1000.0;
        nextPutAll:'">'.
    stream close.

    "Created: / 03-08-2011 / 14:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2012 / 15:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHeader
    stream
        nextPutAll:'<?xml version="1.0" encoding="UTF-8"?>';
        nextPut:Character lf.
    stream
        nextPutAll:'<testsuite name="';
        nextPutAll:(Report encode:report name);
        nextPutAll:'" tests="';
        print:report suite testCount;
        nextPutAll:('" hostname="%1"' bindWith:OperatingSystem getHostName);
        nextPutAll:'>'.
     "Now this is ugly. We want to update the time and the number of failures and errors, but still at the same time stream a valid XML. So remember this position and add some whitespace, that we can fill later."
    position := stream stream position - 1.
    stream
        nextPutAll:(String new:100 withAll:$ );
        nextPut:Character lf.
    stream
        nextPutLine: '  <properties>';
        nextPutLine: '    <property name="programmingLanguage" value="Smalltalk" />';
        nextPutLine: '    <property name="smalltalk.vendor" value="exept Software AG" />';
        nextPutLine: '    <property name="smalltalk.compiler" value="Smalltalk/X" />';
        nextPutLine:('    <property name="smalltalk.version" value="%1" />'bindWith:Smalltalk versionString);
        nextPutLine:('    <property name="os.name" value="%1" />' bindWith:OperatingSystem osName);
        nextPutLine:('    <property name="os.arch" value="%1" />' bindWith:OperatingSystem getCPUType);
        nextPutLine:('    <property name="user.name" value="%1" />' bindWith:OperatingSystem getLoginName);
        nextPutLine:('    <property name="user.language" value="%1" />' bindWith:Smalltalk language).
"/    stream
"/        nextPutLine:('    <property name="smalltalk.libbasic.version" value="%1" />'bindWith:stx_libbasic versionString).
    stream
        nextPutLine: '  </properties>'.       

    startTime := OperatingSystem getMillisecondTime.

    "Created: / 03-08-2011 / 19:14:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2014 / 01:14:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeTestCase:testcase outcome:outcome time:time exception: exception stacktrace:stacktrace
    | result |

    outcome result == TestResult statePass ifTrue:[
        result := #pass.
    ] ifFalse:[
        outcome result == TestResult stateFail ifTrue:[
            result := #failure.
            failures := failures + 1
        ] ifFalse:[
            outcome result == TestResult stateError ifTrue:[
                result := #error.
                errors := errors + 1.
            ] ifFalse:[
                outcome result == TestResult stateSkip ifTrue:[
                    result := #skip.
                    skipped := skipped + 1
                ] ifFalse:[
                    self error: 'Invalid test result'.
                ]
            ].
        ].
    ].

    stream tab;
            nextPutAll: '<testcase classname="';
            nextPutAll: (self encode: testcase nameForHDTestReport);
            nextPutAll: '" name="';
            nextPutAll: (self encode: testcase selectorForHDTestReport);
            nextPutAll: '" time="'; print: (time ? 0) / 1000.0; nextPutAll: '">'; cr.

    result == #skip ifTrue:[
        stream tab; tab; nextPutAll: '<skipped/>'.
    ] ifFalse:[
        result ~~ #pass ifTrue:[
            | type message |

            exception isNil ifTrue:[
                type := 'unknown exception'.
                message := 'unknown exception occurred (no exception details available)'
            ] ifFalse:[
                type := exception class name.
                message := exception messageText notNil ifTrue:[ exception description ] ifFalse:[ 'no exception'].
            ].


            stream tab; tab;
                nextPut:$<; nextPutAll: result;
                nextPutAll:' type="';
                nextPutAll:(self encode:type);
                nextPutAll:'" message="';
                nextPutAll:(self encode: message);
                nextPutAll:'"><!![CDATA['; cr.
            "/ Write system identification here so one can tell on which system                     
            "/ it failed. Jenkins JUnit plugin infortunately does not show this
            "/ info in it's own UI
            self writeCDATA: ('Hostname: ' , OperatingSystem getHostName , Character cr).
            self writeCDATA: ('OS:       ' , OperatingSystem osName , Character cr).
            self writeCDATA: ('Arch:     ' , OperatingSystem getCPUType , Character cr, Character cr).
                
            self writeCDATA: (stacktrace ? 'stacktrace not available').
            stream
                nextPutAll:']]></'; nextPutAll: result; nextPutAll:'>';
                nextPut:Character lf
        ].
    ].
    report keepStdout ifTrue:[
        outcome collectedOutput notEmptyOrNil ifTrue:[
            stream nextPutAll:'    <system-out><!![CDATA['; cr.
            self writeCDATA: outcome collectedOutput.
            stream nextPutAll:']]> </system-out>'; cr.
        ].
    ].

    stream tab;
            nextPutAll: '</testcase>'; cr.


    stream flush

    "Created: / 03-08-2011 / 19:42:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-08-2017 / 14:38:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::JUnit methodsFor:'writing - utilities'!

writeCDATA: string
    | start stop |

    start := 1. 
    stop := start.
    [ (stop := (string indexOf: $] startingAt: stop)) ~~ 0 ] whileTrue:[
        ((stop < (string size - 1)) 
            and:[(string at: stop + 1) == $]
                and:[(string at: stop + 2) == $>]]) ifTrue:[
                    " Okay, found CDATA end token "
                    stream nextPutAll: string startingAt: start to: stop + 1.
                    stream nextPutAll: ']]><!![CDATA[>'.
                    start := stop := stop + 3.
                ] ifFalse:[
                    stop := stop + 1.
                ].
    ].
    start < string size ifTrue:[
        stream nextPutAll: string startingAt: start to: string size.        
    ].

    "
    String streamContents:[:s | Builder::TestReportFormat::JUnit new report: nil stream: s; writeCDATA:'ABCD']
    String streamContents:[:s | Builder::TestReportFormat::JUnit new report: nil stream: s; writeCDATA:']]]]']         
    String streamContents:[:s | Builder::TestReportFormat::JUnit new report: nil stream: s; writeCDATA:'Some <[CDATA[ CDATA ]]> Some Text and stray terminator ]]> here']
    "

    "Created: / 05-07-2013 / 16:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::PerfPublisher class methodsFor:'accessing'!

symbolicNames
    "Returns a collection of symbolic names for this format"

    ^ #(perfPublisher)

    "Modified: / 04-08-2011 / 11:52:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::PerfPublisher class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

!TestReportFormat::PerfPublisher methodsFor:'writing'!

writeFooter

    stream nextPutLine: '</report>'

    "Modified: / 03-08-2011 / 20:12:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHeader

    |reportName reportCategory testClass|

    reportName := report suite name.
    reportCategory := 'uncategorized'.  "/ it is a required attribute; so what should we use ?

    (testClass := Smalltalk at:reportName asSymbol) isBehavior ifTrue:[
        reportCategory := testClass category.  "/ at least, something to show
    ].

    stream
        nextPutLine: '<?xml version="1.0"?>';
        nextPutLine:('<report name="%1" categ="%2">' bindWith:reportName with:reportCategory);
        nextPutLine:('  <start>');
        nextPutLine:('    <date format="YYYYMMDD" val="%1" />' bindWith:(Date today printStringFormat:'%y%m%d'));
        nextPutLine:('    <time format="HHMMSS" val="%1" />' bindWith:(Time now printStringFormat:'%h%m%s'));
        nextPutLine:('  </start>').

    "Modified: / 03-08-2011 / 20:12:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeTestCase:testcase outcome:outcome time:time exception:exception stacktrace:stacktrace

    "
    Example:
    <test
        name='test_format_link_not_in_repos_with_line'
        executed='exec-status'
      <result>  
        <success passed='result-status' state='result-state'/>
        <errorlog><!![CDATA[EXEMPLE OF ERROR LOG]]></errorlog>
      </result>  
    </test>  
    "

    |testClassName executionTime testName testDescription 
     successPassed successState exceptionInfo
     compilerName compilerVersion compilerConfiguration compilerVersionDate 
     timeUnit timeMeasure 
     sysInfo osType osVersion cpuType|

    testClassName := testcase printString.
    testName := testcase selector.

    "most tests do not know, and return nil here!!"
    executionTime := time.    "/ millis
    testDescription := '%1-%2' bindWith:testClassName with:testName.

    successPassed := (outcome result == TestResult statePass) ifTrue:['yes'] ifFalse:['no'].
    (outcome result ~~ TestResult statePass) ifTrue:[
        exceptionInfo := stacktrace ? 'No stacktrace available'.
    ].

    successState := 'foo'.

    "/ caveat: the following needs to be made dialect-specific
    compilerName := 'Smalltalk/X'.
    compilerVersion := Smalltalk versionString.
    compilerConfiguration := Smalltalk configuration.
    compilerVersionDate := Smalltalk versionDate.

    sysInfo := OperatingSystem getSystemInfo.
    osType := (sysInfo at:#osType ifAbsent:'?').
    osVersion := (sysInfo at:#release ifAbsent:'?').

    cpuType := (sysInfo at:#cpuType ifAbsent:'?').
    "/ cpuSpeed := (sysInfo at:#cpuSpeed ifAbsent:'?').

    timeUnit := 'ms'.
    timeMeasure := executionTime.

    stream
        nextPutLine:('<test name="%1" executed="yes">' bindWith: testName);
        nextPutLine:('  <description><!![CDATA[%1]]></description>' bindWith: testDescription);
        nextPutLine:'  <platform>';
        nextPutLine:'    <os>';
        nextPutLine:('      <type><!![CDATA[%1]]></type>' bindWith:osType);
        nextPutLine:('      <version><!![CDATA[%1]]></version>' bindWith:osVersion);
        nextPutLine:'    </os>';
        nextPutLine:('    <processor arch="%1">' bindWith:cpuType);
        "/ nextPutLine:('      <frequency> unit="Mhz" cpufreq="%1" />' bindWith:cpuSpeed);
        nextPutLine:'    </processor>';
        nextPutLine:('    <compiler name="%1" version="%2" versiondate="%3" configuration="%4" />' 
                            bindWith:compilerName with:compilerVersion 
                            with:compilerVersionDate with:compilerConfiguration);
        "/ nextPutLine:'    <environment />';
        nextPutLine:'  </platform>';
        nextPutLine:'  <result>';
        nextPutLine:('    <success passed="%1" state="100" />' 
                            bindWith:successPassed with:successState);
        "/ cg: in the perfPublisher documentation, I found "mesure".
        "/ I am not sure, if that was a typo, or is actually what is expected...
        "/ to be on the save side, I generate both a mesure and a measure attribute,
        "/ so it will work, even if they ever fix perfPublisher's xml parser.
        nextPutLine:('    <executiontime unit="%1" mesure="%2" measure="%2" isRelevant="yes" />' 
                            bindWith:timeUnit with:timeMeasure).

    exceptionInfo notNil ifTrue:[
        stream
            nextPutLine:'    <errorlog><!![CDATA[';
            nextPutAll:exceptionInfo;
            nextPutLine:']]></errorlog>'.
        ].
    stream
        nextPutLine:'  </result>'.

    stream nextPutLine:'</test>'.

    "Modified: / 06-06-2014 / 00:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::PythonUnittest class methodsFor:'accessing'!

symbolicNames
    "Returns a collection of symbolic names for this format"

    ^ #(python python-unittest)

    "Modified: / 04-08-2011 / 11:52:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::PythonUnittest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

!TestReportFormat::PythonUnittest methodsFor:'writing'!

writeFooter

    stream
        nextPutLine: '</unittest-results>'

    "Modified: / 03-08-2011 / 20:19:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHeader

    stream
        nextPutLine: '<?xml version="1.0"?>';
        nextPutLine: '<unittest-results>'.

    "Modified: / 03-08-2011 / 20:19:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeTestCase:testcase outcome:outcome time:time exception:exception stacktrace:stacktrace

    "
    Example:
    <test
        duration='0.0188629627228'
        status='error'
        fixture='bitten.tests.web_ui.SourceFileLinkFormatterTestCase'
        name='test_format_link_not_in_repos_with_line'
        file='/usr/src/trac-bitten-0.6b2.dfsg/bitten/tests/web_ui.py'>
    "

    | testClassName result |

    testClassName := testcase class printString.

    outcome result == TestResult statePass ifTrue:[ 
        result := #success.
    ] ifFalse:[ 
        outcome result == TestResult stateFail ifTrue:[ 
            result := #failure.
        ] ifFalse:[ 
            outcome result == TestResult stateError ifTrue:[ 
                result := #error.
            ] ifFalse:[ 
                outcome result == TestResult stateSkip ifTrue:[ 
                    result := #skip.
                ] ifFalse:[
                    self error: 'Invalid test result'.
                ]
            ].
        ].
    ].    

    stream
        nextPutAll:'<test duration="'; nextPutAll:time; nextPutLine:'"'; 
        tab; nextPutAll:'status="'; nextPutAll: result; nextPutLine:'"';
        tab; nextPutAll:'ficture="'; nextPutAll: testClassName; nextPutLine:'"';
        tab; nextPutAll:'name="'; nextPutAll: testcase selector; nextPutLine:'"';
        "It seems that some tools requires the file attributes. So we supply one :-)"
        tab; nextPutAll:'file="'; nextPutAll: testClassName , '.st'; nextPutLine:'">'.

    outcome == #pass ifFalse:[
        stream nextPutLine:'<traceback><!![CDATA['.
        stream nextPutAll: stacktrace ? 'No stacktrace available'.
        stream nextPutLine:']]></traceback>'.
    ].

    stream nextPutLine:'</test>'.

    "Modified: / 06-06-2014 / 00:50:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::TAP class methodsFor:'accessing'!

symbolicNames
    "Returns a collection of symbolic names for this format"

    ^ #(tap TAP)

    "Modified: / 04-08-2011 / 11:52:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::TAP class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

!TestReportFormat::TAP methodsFor:'accessing - defaults'!

defaultFileSuffix
    "superclass HDReportFormat says that I am responsible to implement this method"

    ^ 'tap'

    "Modified: / 04-08-2011 / 12:47:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat::TAP methodsFor:'writing'!

writeFooter

    "nothing to do"

    "Modified: / 03-08-2011 / 20:05:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHeader

    stream nextPutAll: '1..'; nextPutAll: report suite testCount printString; cr.
    index := 0

    "Modified: / 04-08-2011 / 13:49:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeTestCase:testcase outcome:outcome time:time exception:exception stacktrace:stacktrace

    | result testDescription statusString |

    index := index + 1.
    outcome result == TestResult statePass ifTrue:[ 
        result := #pass.
    ] ifFalse:[ 
        outcome result == TestResult stateFail ifTrue:[ 
            result := #failure.
        ] ifFalse:[ 
            outcome result == TestResult stateError ifTrue:[ 
                result := #error.
            ] ifFalse:[ 
                outcome result == TestResult stateSkip ifTrue:[ 
                    result := #skip.
                ] ifFalse:[
                    self error: 'Invalid test result'.
                ]
            ].
        ].
    ].    

    testDescription := '%1-%2 (%3ms)'
                            bindWith:testcase printString
                            with:testcase selector
                            with:time.

    statusString := (result == #pass)
                        ifTrue:['ok']
                        ifFalse:['not ok'].

    stream nextPutLine:('%1 %2 - %3'
                            bindWith:statusString
                            with:index
                            with:testDescription).

    "Modified: / 06-06-2014 / 00:46:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestReportFormat class methodsFor:'documentation'!

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

