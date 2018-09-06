"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TestResultReporter
	instanceVariableNames:'result stream'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Smalltalk/X-Report'
!

!TestResultReporter class methodsFor:'documentation'!

documentation
"
    this is used as a last step in jenkins automated builds.

    WARNING:
        this is about to be obsoleted by the reporter classes found in the
        goodies/builder/ packages.

    Currently supported formats are:
        #xml_jUnit      - a junit-like xml format
        #xml_pythonUnit - a python unit-like xml format
        #xml            - same, for backward compatibility
        #tap            - perl TAP unit test format; 
                          very naive and simple, but there are tools for it...
        #xml_perfPublisher
                        - can be processed by the perfPublisher jenkins/hudson plugin

    public API entry:
        |aTestResult|

        aTestResult := aUnitTest suite run.
        TestResultReporter report:aTestResult format:#xml on: aStream

    modifications:
        cg: I think the name 'xml' is too unspecific; 
            I may want to add a whole bunch of additional xml-based formats. 
            So I changed #xml to xml_pythonUnit (but still support the original #xml for bw-compatibility).
            You may be especially interested in xml_perfPublisher, which is great to present
            nice reports in jenkins/hudson...

    [author:]
        Jan Vranji
        documentation, tap & perfPublisher format added by Claus Gittinger

    [see also:]
        TAP 
            http://testanything.org/wiki/index.php/Main_Page
            http://search.cpan.org/~petdance/Test-Harness-2.64/lib/Test/Harness/TAP.pod

        perfPublisher
            http://wiki.hudson-ci.org/display/HUDSON/PerfPublisher+Plugin
"
!

examples
"
    Smalltalk loadPackage:'exept:regression'

                                                                               [exBegin]
    |suite result testResult|

    suite := TestSuite named:'SelfTest'.
    #(
        'JavaScriptTests'
        'FloatTest'
        'IntegerTest'
    ) do:[:className |
        |fullName|

        fullName := ('RegressionTests::',className).
        suite addTest:(Smalltalk classNamed:fullName) suite.
    ].
    testResult := suite run.                                                                           
    TestResultReporter report:testResult format:#xml_jUnit on:Transcript. 
                                                                               [exEnd]

                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::IntegerTest suite run.
    TestResultReporter report:testResult format:#xml_jUnit on:Transcript. 
                                                                               [exEnd]

                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::IntegerTest suite run.
    TestResultReporter report:testResult format:#xml_pythonUnit on:Transcript. 
                                                                               [exEnd]

                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::IntegerTest suite run.
    TestResultReporter report:testResult format:#tap on:Transcript.      
                                                                               [exEnd]

                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::CollectionTests suite run.
    TestResultReporter report:testResult format:#xml_perfPublisher on:Transcript.
                                                                               [exEnd]

                                                                               [exBegin]
    |suite testResult|

    suite := RegressionTests::WritingToTranscriptOrStdoutTest suite.
    testResult := suite run.
    TestResultReporter report:testResult format:#xml_jUnit on:Transcript.
                                                                               [exEnd]

                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::NumberTest suite run.
    TestResultReporter report:testResult format:#xml_jUnit on:Transcript.
                                                                               [exEnd]
                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::NumberTest suite run.
    TestResultReporter report:testResult format:#xml_pythonUnit on:Transcript.
                                                                               [exEnd]
                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::NumberTest suite run.
    TestResultReporter report:testResult format:#xml_perfPublisher on:Transcript.
                                                                               [exEnd]
                                                                               [exBegin]
    |testResult|

    testResult := RegressionTests::NumberTest suite run.
    TestResultReporter report:testResult format:#tap on:Transcript.
                                                                               [exEnd]

  test an error:
                                                                               [exBegin]
    |testResult|

    (RegressionTests::AssociationTests includesSelector:#'test_xx_willFail') ifFalse:[
        Class withoutUpdatingChangesDo:[
            RegressionTests::AssociationTests compile:'test_xx_willFail self assert:5 > 7.'.
            RegressionTests::AssociationTests compile:'test_xx_willErr self error:''err by purpose''.'
        ].
    ].
    testResult := RegressionTests::AssociationTests suite run.
    TestResultReporter report:testResult format:#xml_jUnit on:Transcript.
                                                                               [exEnd]
"
!

format_tap
"
    sample output for one of the st/x regression-tests looks like:

1..49
ok 1 - RegressionTests::IntegerTest-testComparing (0ms)
ok 2 - RegressionTests::IntegerTest-testConstants (0ms)
ok 3 - RegressionTests::IntegerTest-testCreationFromBytes1 (0ms)
ok 4 - RegressionTests::IntegerTest-testDivision (0ms)
ok 5 - RegressionTests::IntegerTest-testEncodeDecode (0ms)
ok 6 - RegressionTests::IntegerTest-testFactorial (0ms)
ok 7 - RegressionTests::IntegerTest-testGCD (0ms)
ok 8 - RegressionTests::IntegerTest-testILC (0ms)
ok 9 - RegressionTests::IntegerTest-testInline1 (0ms)
ok 10 - RegressionTests::IntegerTest-testInteger1 (0ms)
ok 11 - RegressionTests::IntegerTest-testIntegerMisc (0ms)
...
ok 47 - RegressionTests::IntegerTest-test_gcdBug1 (0ms)
ok 48 - RegressionTests::IntegerTest-test_gcdBug2 (0ms)
ok 49 - RegressionTests::IntegerTest-test_gcdBug3 (0ms)
"
!

format_xml_jUnit
"
    sample output for one of the st/x regression-tests looks like:

   <?xml version='1.0' encoding='UTF-8' ?>
   <testsuite errors='1' failures='0' hostname='hazelnut.osuosl.org' name='net.cars.engine.BougieTest' tests='2' time='0.017' timestamp='2007-11-02T23:13:50'>
     <properties>
       <property name='java.vendor' value='IBM Corporation' />
       <property name='os.name' value='Linux' />
       <property name='sun.boot.class.path' value='/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/vm.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/core.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/charsets.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/graphics.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/security.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmpkcs.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmorb.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmcfw.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmorbapi.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmjcefw.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmjgssprovider.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmjsseprovider2.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmjaaslm.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/ibmcertpathprovider.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/server.jar:/opt/ibm-jdk-bin-1.5.0.5a/jre/lib/xml.jar' />
       <property name='sun.java2d.fontpath' value='' />
       <property name='java.vm.specification.vendor' value='Sun Microsystems Inc.' />
       <property name='ant.home' value='/home/jancumps/project/continuus/ant/distro' />
      ...
     </properties>
     <testcase classname='net.cars.engine.BougieTest' name='sparkDry' time='0.0010' />
     <testcase classname='net.cars.engine.BougieTest' name='sparkHumid' time='0.0050'>
       <error message='humidity level too high' type='java.lang.RuntimeException'>java.lang.RuntimeException: humidity level too high
          at net.cars.engine.Bougie.spark(Unknown Source)
          at net.cars.engine.BougieTest.sparkHumid(BougieTest.java:36)
       </error>
     </testcase>
     <system-out><!![CDATA[]]></system-out>
     <system-err><!![CDATA[]]></system-err>
  </testsuite>
"
!

format_xml_perfPublisher
"
    sample output looks like:

<report name='GeneratedReport-0' categ='GeneratedReport'>
  <start>
    <date format='YYYYMMDD' val='20000101' />
    <time format='HHMMSS' val='195043' />
  </start>
  <test name='/file_0/test_0' executed='yes'>
    <description><!![CDATA[This is the description of the test number 0 member of the 0 file.]]></description>
    <targets>
      <target threaded='false'>PHP</target>
    </targets>
    <platform name='Plateform_0' remote='unknown' capspool='unknown'>
      <os>
        <type><!![CDATA[Linux-2.6.26-2-amd64-x86_64-with-glibc2.3.2]]></type>
        <name><!![CDATA[Linux]]></name>
        <version><!![CDATA[2.6.26-2-amd64]]></version>
        <distribution><!![CDATA[Linux-2.6.26-2-amd64-x86_64-with-debian-5.0.3]]></distribution>
      </os>
      <processor arch='x86_64'>
        <frequency unit='MHz' cpufreq='2667.000' />
      </processor>
      <hardware><!![CDATA[nVidia Corporation GeForce 8500 GT (rev a1)]]></hardware>
      <hardware><!![CDATA[nVidia Corporation GT200 [Tesla C1060 / Tesla S1070] (rev a1)]]></hardware>
      <compiler name='ifort' version='11.0 20090131' path='.' />
      <environment>{PUT HERE ALL YOUR LIBS AND THE DESCRIPTION OF YOUR TEST ENVIRONMENT}</environment>
    </platform>
    <commandline rank='0' time='20100128-195406.590832' duration='0.599782943726'>the_first_command_executed</commandline>
    <commandline rank='1' time='20100128-195406.590832' duration='0.599782943726'>the_second_command_executed</commandline>
    <result>
      <success passed='no' state='70' hasTimedOut='false' />
      <compiletime unit='s' mesure='1.456467636167308' isRelevant='false' />
      <performance unit='GFLOPs' mesure='39.621634393187904' isRelevant='false' />
      <executiontime unit='s' mesure='1.5300645576307736' isRelevant='false' />
      <errorlog><!![CDATA[EXEMPLE OF ERROR LOG]]></errorlog>
      <log name='NameOfLogNumber0'><!![CDATA[Here it's another of other log]]></log>
      <log name='NameOfLogNumber1'><!![CDATA[Here it's another of other log]]></log>
    </result>
  </test>
  <test name='/file_0/test_1' executed='yes'>
    ...
    </result>
  </test>
</report>
"
!

format_xml_pythonUnit
"
    sample output for one of the st/x regression-tests looks like:

<?xml version='1.0'?>
<unittest-results>
<test duration='0'
    status='success'
    ficture='RegressionTests::IntegerTest'
    name='testComparing'
    file='RegressionTests::IntegerTest.st'>
</test>
<test duration='0'
    status='success'
    ficture='RegressionTests::IntegerTest'
    name='testConstants'
    file='RegressionTests::IntegerTest.st'>
</test>
<test duration='0'
    status='success'
    ficture='RegressionTests::IntegerTest'
    name='testCreationFromBytes1'
    file='RegressionTests::IntegerTest.st'>
</test>
<test duration='0'
    status='success'
    ficture='RegressionTests::IntegerTest'
    name='testDivision'
    file='RegressionTests::IntegerTest.st'>
</test>
<test duration='0'
    status='success'
    ficture='RegressionTests::IntegerTest'
    name='testEncodeDecode'
    file='RegressionTests::IntegerTest.st'>
</test>
...
</unittest-results>
"
! !

!TestResultReporter class methodsFor:'queries'!

supportedFormats
   "return a list of formats and short-info-string, as per supported format symbol"

    ^ #(
        (#'xml_jUnit'           'a junit-like xml format')
        (#'xml_pythonUnit'      'a python unit-like xml format')
        (#'xml_perfPublisher'   'xml-based format for jenkins/hudson')
        (#'tap'                 'perl TAP unit test format')
    )

    "Created: / 30-07-2011 / 10:18:18 / cg"
! !

!TestResultReporter class methodsFor:'reporting'!

report: aTestResult format: format as: stringOrFilename

    self new report: aTestResult format: format as: stringOrFilename
!

report: aTestResult format: format on: stream

    self new report: aTestResult format: format on: stream

    "
     self report:(RegressionTests::IntegerTest runTests) format:#xml on:Transcript
    "

    "Modified (comment): / 30-07-2011 / 09:37:53 / cg"
! !

!TestResultReporter methodsFor:'reporting'!

report:formatSymbol
    "currently supported formatSymbols:
            xml_pythonUnit, xml_perfPublisher, tap"

    |reportFormatSelector|

    reportFormatSelector := self reportFormatSelector:formatSymbol.
    (self respondsTo: reportFormatSelector)
        ifTrue:[self perform: reportFormatSelector]
        ifFalse:[self error:'Unsupported format: ', formatSymbol].

    "Modified (comment): / 03-08-2011 / 12:57:54 / cg"
!

report: aTestResult format: format as: stringOrFilename

    | s |
    s := stringOrFilename asFilename writeStream.
    [ self report: aTestResult format: format on: s]
        ensure:[s close].
!

report: aTestResult format: aSymbol on: aStream

    result := aTestResult.
    stream := aStream.
    self report: aSymbol
!

reportFormatSelector:format
    ^ ('report' , format asString asUppercaseFirst) asSymbol
! !

!TestResultReporter methodsFor:'reporting - tap'!

reportTap
    "TAP (perl unit test) report format"

    |idx reportWithStatus|

    "example:
        1..4
        ok 1 - Input file opened
        not ok 2 - First line of the input valid
        ok 3 - Read the rest of the file
        not ok 4 - Summarized correctly # TODO Not written yet
    "

    "/ what about not-executed tests - why only runCount ?
    stream nextPutLine: ('1..%1' bindWith:result runCount).

    reportWithStatus := 
        [:testOutComes :status |
            testOutComes do:[:each | self reportTapTest: each index: idx result: status. idx := idx + 1 ]
        ].

    idx := 1.
    reportWithStatus value:result passedOutcomes value:#success.
    reportWithStatus value:result failureOutcomes value:#failure.
    reportWithStatus value:result errorOutcomes value:#error.

    "Created: / 30-07-2011 / 10:12:31 / cg"
!

reportTapTest: test index:index result: testResult
    | testClassName executionTime  testDescription statusString|

    testClassName := self sunitNameOf: test class.

    "most tests do not know, and return nil here!!"
    executionTime := test executionTime ? 0.0.

    testDescription := '%1-%2 (%3ms)'
                            bindWith:testClassName
                            with:test selector
                            with:executionTime.

    statusString := (testResult == #success)
                        ifTrue:['ok']
                        ifFalse:['not ok'].

    stream nextPutLine:('%1 %2 - %3'
                            bindWith:statusString
                            with:index
                            with:testDescription).

    "Created: / 30-07-2011 / 10:28:06 / cg"
! !

!TestResultReporter methodsFor:'reporting - xml-jUnit'!

errorMessageFromExceptionDetailOf:testOutcome
    |detail|

    detail := testOutcome exceptionDetail.
    detail isNil ifTrue:[
        ^ 'no error message'.
    ].

    "Smalltalk/X dialect detection..."
    ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[ 
        "exception specific description string"
        ^ detail at:#description ifAbsent:[ (detail at:#exception) description]
    ].

    ^ 'no error message (no dialect specific extractor)'.

    "Created: / 07-08-2011 / 12:45:45 / cg"
!

errorTypeFromExceptionDetailOf:testOutcome
    |detail|

    detail := testOutcome exceptionDetail.
    detail isNil ifTrue:[
        ^ 'unknown error type'.
    ].

    "Smalltalk/X dialect detection..."
    ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
        |exception|
        "class name of the exception"
        exception := detail at:#exception.
        exception isBehavior ifTrue:[
            ^ exception name.
        ].
        ^ exception printString.
    ].

    ^ 'unknown error type (no dialect specific extractor)'.

    "Created: / 07-08-2011 / 13:06:44 / cg"
!

reportTracebackFromExceptionDetailOf:testOutcome
    |detail|

    detail := testOutcome exceptionDetail.
    detail notNil ifTrue:[
        "Smalltalk/X dialect detection..."
        ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[ 
            stream nextPutAll:(detail at:#backtrace).
        ].
    ].

    "Created: / 07-08-2011 / 12:46:19 / cg"
!

reportXml_jUnit
    "jUnit-like XML unittest report format"

    stream
        nextPutLine: '<?xml version="1.0"?>';
        nextPutAll: '<testsuite';
        nextPutAll:(' tests="%1"' bindWith:result runCount);
        nextPutAll:(' timestamp="%1"' bindWith:result timestamp printStringIso8601Format);
        nextPutAll:(' time="%1"' bindWith:result executionTime);
        nextPutAll:(' errors="%1"' bindWith:result errors size);
        nextPutAll:(' failures="%1"' bindWith:result failures size).
    result skipped size > 0 ifTrue:[
        stream
            nextPutAll:(' skipped="%1"' bindWith:result skipped size).
    ].
    stream
        nextPutAll:(' hostname="%1"' bindWith:OperatingSystem getHostName);
        nextPutAll:(' name="%1"' bindWith:result name);
        nextPutLine: '>'.
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

    result passedOutcomes  do:[:eachOutcome | self reportXml_jUnitTest: eachOutcome ].
    result skippedOutcomes  do:[:eachOutcome | self reportXml_jUnitTest: eachOutcome ].
    result failureOutcomes do:[:eachOutcome | self reportXml_jUnitTest: eachOutcome ].
    result errorOutcomes   do:[:eachOutcome | self reportXml_jUnitTest: eachOutcome ].

    stream
        nextPutLine: '</testsuite>'

    "Created: / 05-08-2011 / 15:21:45 / cg"
!

reportXml_jUnitResultAndTraceback:testOutcome state:state
    |stateTag errorMessage errorType|

    (state = 'error') ifTrue:[
        stateTag := 'error'.
        errorMessage := 'unclassified error'.
    ] ifFalse:[
        stateTag := 'failure'.
        errorMessage := 'unclassified failure'.
    ].

    "
     retrieves a single line error message; we use the exception's name or description
    "
    errorMessage := self errorMessageFromExceptionDetailOf:testOutcome.
    errorType := self errorTypeFromExceptionDetailOf:testOutcome.
    errorMessage := errorMessage copyReplaceAll:$" withAll:'&quot;'.

    stream
        nextPutAll:('    <%1 message="%2" type="%3">' 
                            bindWith:stateTag 
                            with:errorMessage 
                            with:errorType);
        cr.

    "
     Prints a traceback to the stream.
     This is dialect-specific, so we have to check...
    "
    self reportTracebackFromExceptionDetailOf:testOutcome.

    stream
        nextPutAll:('    </%1>' bindWith:stateTag);
        cr.

    "Created: / 05-08-2011 / 15:40:09 / cg"
!

reportXml_jUnitTest:testOutcome
    |testClassName testClass testClassSourceFile executionTime executionTimeString 
     test testResult javaPackagePrefix|

    test := testOutcome testCase.
    testResult := testOutcome result.

    testClassName := self sunitNameOf: test class.
    "/ prepend package, so it looks like a Java-class path
    javaPackagePrefix := (test class package copyTransliterating:':/' to:'..'),'.'.

    (executionTime := testOutcome executionTime) isNil ifTrue:[
        executionTimeString := '0.0'.
    ] ifFalse:[
        executionTimeString := ((executionTime / 1000) asFixedPoint:3) printString.
    ].

    stream
        nextPutAll:'  <testcase'; 
        nextPutAll:(' classname="%1"' bindWith:(javaPackagePrefix,testClassName)); 
        nextPutAll:(' name="%1"' bindWith:test selector);
        nextPutAll:(' status="%1"' bindWith:testResult);
        nextPutAll:(' time="%1"' bindWith:executionTimeString).

    ((testResult = TestResult statePass) 
    and:[ testOutcome collectedOutput isEmptyOrNil ]) ifTrue:[
        stream nextPutAll:'/>'; cr.
    ] ifFalse:[
        stream nextPutAll:'>'; cr.

        testResult = TestResult statePass ifFalse:[
            self reportXml_jUnitResultAndTraceback:testOutcome state:testResult.

            "/ generate a link to the source file
            testClass := Smalltalk classNamed:testClassName.
            testClass notNil ifTrue:[
                testClassSourceFile := TestResultStX sourceFilenameOfClass:testClass.
                testClassSourceFile notNil ifTrue:[
                    stream
                        nextPutAll:'    <system-err>'; cr;
                        nextPutAll:('[[ATTACHMENT|%1]]' bindWith:testClassSourceFile); cr;
                        nextPutAll:'    </system-err>'; cr.
                ]
            ].
        ].

        testOutcome collectedOutput notEmptyOrNil ifTrue:[
            stream
                nextPutAll:'    <system-out><!![CDATA['; cr;
                nextPutAll: testOutcome collectedOutput;
                nextPutAll:']]> </system-out>'; cr.
        ].

        stream nextPutAll:'  </testcase>'; cr.
    ].

    "Created: / 18-08-2011 / 20:30:50 / cg"
! !

!TestResultReporter methodsFor:'reporting - xml-perfPublisher'!

reportXml_perfPublisher
    "xml-based format for hudson/jenkins"

    |reportName reportCategory testClass startTime|

    reportName := result name.
    reportCategory := 'uncategorized'.  "/ it is a required attribute; so what should we use ?

    (testClass := Smalltalk at:reportName asSymbol) isBehavior ifTrue:[
        reportCategory := testClass category.  "/ at least, something to show
    ].

    "/ compute the startTime from the earliest time found in the set of tests
    startTime := result timestamp.
    startTime isNil ifTrue:[
        startTime := (result tests 
                        collect:[:each | each startTime]
                        thenSelect:[:timeOrNil | timeOrNil notNil]) min.
    ].
    startTime := (startTime ? Time now) asTime.
    
    stream
        nextPutLine: '<?xml version="1.0"?>';
        nextPutLine:('<report name="%1" categ="%2">' bindWith:reportName with:reportCategory);
        nextPutLine:('  <start>');
        nextPutLine:('    <date format="YYYYMMDD" val="%1" />' bindWith:(Date today printStringFormat:'%y%m%d'));
        nextPutLine:('    <time format="HHMMSS" val="%1" />' bindWith:(startTime printStringFormat:'%h%m%s'));
        nextPutLine:('  </start>').

    result passedOutcomes  do:[:each|self reportXml_perfPublisher: each result: #success].
    result failureOutcomes do:[:each|self reportXml_perfPublisher: each result: #failure].
    result skippedOutcomes  do:[:each|self reportXml_perfPublisher: each result: #error].
    result errorOutcomes   do:[:each|self reportXml_perfPublisher: each result: #error].

    stream
        nextPutLine: '</report>'

    "Created: / 30-07-2011 / 11:45:15 / cg"
!

reportXml_perfPublisher: testOutcome result: testResult

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

    |test testClassName executionTime testName testDescription 
     successPassed successState exceptionInfo
     compilerName compilerVersion compilerConfiguration compilerVersionDate 
     timeUnit timeMeasure 
     sysInfo osType osVersion cpuType|

    test := testOutcome testCase.

    testClassName := self sunitNameOf: test class.
    testName := test selector.

    "most tests do not know, and return nil here!!"
    executionTime := testOutcome executionTime ? 0.    "/ millis
    testDescription := '%1-%2' bindWith:testClassName with:testName.

    successPassed := (testResult == #success) ifTrue:['yes'] ifFalse:['no'].
    testResult ~~ #success ifTrue:[
        exceptionInfo := testOutcome exceptionDetail.
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
        nextPutLine:('    <processor arch="%1" wordLength="%2">' bindWith:cpuType with:(ExternalAddress pointerSize * 8));
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

    "Created: / 30-07-2011 / 12:19:03 / cg"
! !

!TestResultReporter methodsFor:'reporting - xml-python-unit'!

reportXml
    "backward compatible: python unit-like XML unittest report format"

    self reportXml_pythonUnit

    "Created: / 30-07-2011 / 11:41:24 / cg"
!

reportXml_pythonUnit
    "python unittest-like XML unittest report format"

    stream
        nextPutLine: '<?xml version="1.0"?>';
        nextPutLine: '<unittest-results>'.

    result passedOutcomes  do:[:each|self reportXml_pythonUnitTest: each result: #success].
    result skippedOutcomes  do:[:each|self reportXml_pythonUnitTest: each result: #error].
    result failureOutcomes do:[:each|self reportXml_pythonUnitTest: each result: #failure].
    result errorOutcomes   do:[:each|self reportXml_pythonUnitTest: each result: #error].

    stream
        nextPutLine: '</unittest-results>'

    "Created: / 03-08-2011 / 12:56:04 / cg"
!

reportXml_pythonUnitTest:testOutcome result: testResult

    "
    Example:
    <test
        duration='0.0188629627228'
        status='error'
        fixture='bitten.tests.web_ui.SourceFileLinkFormatterTestCase'
        name='test_format_link_not_in_repos_with_line'
        file='/usr/src/trac-bitten-0.6b2.dfsg/bitten/tests/web_ui.py'>
    "

    |test testClassName executionTime |

    test := testOutcome testCase.
    testClassName := self sunitNameOf: test class.

    "most tests do not know, and return nil here!!"
    executionTime := (testOutcome executionTime ? 0.0) printString.

    stream
        nextPutAll:'<test duration="'; nextPutAll:executionTime; nextPutLine:'"'; 
        tab; nextPutAll:'status="'; nextPutAll: testResult; nextPutLine:'"';
        tab; nextPutAll:'ficture="'; nextPutAll: testClassName; nextPutLine:'"';
        tab; nextPutAll:'name="'; nextPutAll: test selector; nextPutLine:'"';
        "It seems that some tools requires the file attributes. So we supply one :-)"
        tab; nextPutAll:'file="'; nextPutAll: testClassName , '.st'; nextPutLine:'">'.

    testResult ~= #success ifTrue:[self reportXml_pythonUnitTraceback: test].

    stream nextPutLine:'</test>'.

    "Created: / 03-08-2011 / 12:56:37 / cg"
!

reportXml_pythonUnitTraceback: test

    "
        Prints a traceback to the stream.
        This is dialect-specific, so we have to check...
    "

    "Smalltalk/X dialect detection..."
    ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX])
        ifTrue:[^self reportXml_pythonUnitTracebackStX: test]

    "Created: / 03-08-2011 / 12:56:54 / cg"
!

reportXml_pythonUnitTracebackStX: test
    stream nextPutLine:'<traceback><!![CDATA['.

    [ test debug ]
        on: GenericException
        do: [:ex|
            ex suspendedContext fullPrintAllOn: stream].

    stream nextPutLine:']]></traceback>'.

    "Modified: / 07-12-2009 / 14:06:48 / Jan Vrany <jan.vrant@fit.cvut.cz>"
    "Created: / 03-08-2011 / 12:57:01 / cg"
! !

!TestResultReporter methodsFor:'utilities'!

sunitNameOf: aClass

    "No all SUnit versions comes with sunitName
     (at least Smalltalk/X 3.1)"

    ^(aClass respondsTo:#sunitName)
        ifTrue:[aClass sunitName]
        ifFalse:[aClass printString]
! !

!TestResultReporter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestResultReporter.st,v 1.57 2015-02-18 15:05:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestResultReporter.st,v 1.57 2015-02-18 15:05:31 cg Exp $'
!

version_SVN
    ^ '$Id: TestResultReporter.st,v 1.57 2015-02-18 15:05:31 cg Exp $'
! !

