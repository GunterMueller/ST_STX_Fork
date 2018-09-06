"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TestCoverageReporter
	instanceVariableNames:'packages stream'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Smalltalk/X-Report'
!

!TestCoverageReporter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
    this is used as a last step in jenkins automated builds.

    Currently supported formats are:
        #xml_cobertura      - a cobertura compatible format

    public API entry:
        |aTestResult|

        InstrumentingCompiler compilePackage:'mypackageID'.
        InstrumentationContext new run:[
            aTestResult := aUnitTest suite run.
        ].
        'testResult.xml' asFilename writingFileDo:[:stream |
            TestResultReporter report:aTestResult format:#xml_jUnit on:stream.
        ].
        'testCoverage.xml' asFilename writingFileDo:[:stream |
                TestCoverageReporter reportPackages:{ 'mypackageID' } format:#xml_cobertura on:stream.
        ].

    [author:]
        Claus Gittinger

    [see also:]
        cobertura
            http://wiki.hudson-ci.org/display/HUDSON/PerfPublisher+Plugin
            https://raw.github.com/jenkinsci/cobertura-plugin/master/src/test/resources/hudson/plugins/cobertura/coverage-with-data.xml    
"
!

examples
"
    Smalltalk loadPackage:'exept:regression'

                                                                               [exBegin]
    |suite result testResult|

    InstrumentingCompiler compilePackage:'stx:libjavascript'.
    InstrumentationContext new run:[
        testResult := RegressionTests::JavaScriptTests suite run.
    ].
    'testResult.xml' asFilename writingFileDo:[:stream |
        TestResultReporter report:testResult format:#xml_jUnit on:stream.
    ].
    'testCoverage.xml' asFilename writingFileDo:[:stream |
        TestCoverageReporter reportPackages:{ 'stx:libjavascript' } format:#xml_cobertura on:stream.
    ].

                                                                               [exEnd]

                                                                               [exBegin]
    |suite result testResult|

    InstrumentingCompiler compilePackage:'stx:libjavascript'.
    InstrumentationContext new run:[
        testResult := RegressionTests::JavaScriptTests suite run.
    ].
'
    TestResultReporter report:testResult format:#xml_jUnit on:Transcript.
'.
    TestCoverageReporter reportPackages:{ 'stx:libjavascript' } format:#xml_cobertura on:Transcript.

                                                                               [exEnd]
"
!

format_cobertura_dtd04
"
<!!ELEMENT coverage (sources?,packages)>
<!!ATTLIST coverage line-rate        CDATA #REQUIRED>
<!!ATTLIST coverage branch-rate      CDATA #REQUIRED>
<!!ATTLIST coverage lines-covered    CDATA #REQUIRED>
<!!ATTLIST coverage lines-valid      CDATA #REQUIRED>
<!!ATTLIST coverage branches-covered CDATA #REQUIRED>
<!!ATTLIST coverage branches-valid   CDATA #REQUIRED>
<!!ATTLIST coverage complexity       CDATA #REQUIRED>
<!!ATTLIST coverage version          CDATA #REQUIRED>
<!!ATTLIST coverage timestamp        CDATA #REQUIRED>

<!!ELEMENT sources (source*)>

<!!ELEMENT source (#PCDATA)>

<!!ELEMENT packages (package*)>

<!!ELEMENT package (classes)>
<!!ATTLIST package name        CDATA #REQUIRED>
<!!ATTLIST package line-rate   CDATA #REQUIRED>
<!!ATTLIST package branch-rate CDATA #REQUIRED>
<!!ATTLIST package complexity  CDATA #REQUIRED>

<!!ELEMENT classes (class*)>

<!!ELEMENT class (methods,lines)>
<!!ATTLIST class name        CDATA #REQUIRED>
<!!ATTLIST class filename    CDATA #REQUIRED>
<!!ATTLIST class line-rate   CDATA #REQUIRED>
<!!ATTLIST class branch-rate CDATA #REQUIRED>
<!!ATTLIST class complexity  CDATA #REQUIRED>

<!!ELEMENT methods (method*)>

<!!ELEMENT method (lines)>
<!!ATTLIST method name        CDATA #REQUIRED>
<!!ATTLIST method signature   CDATA #REQUIRED>
<!!ATTLIST method line-rate   CDATA #REQUIRED>
<!!ATTLIST method branch-rate CDATA #REQUIRED>

<!!ELEMENT lines (line*)>

<!!ELEMENT line (conditions*)>
<!!ATTLIST line number CDATA #REQUIRED>
<!!ATTLIST line hits   CDATA #REQUIRED>
<!!ATTLIST line branch CDATA ""false"">
<!!ATTLIST line condition-coverage CDATA ""100%"">

<!!ELEMENT conditions (condition*)>

<!!ELEMENT condition EMPTY>
<!!ATTLIST condition number CDATA #REQUIRED>
<!!ATTLIST condition type CDATA #REQUIRED>
<!!ATTLIST condition coverage CDATA #REQUIRED>
"
! !

!TestCoverageReporter class methodsFor:'queries'!

supportedFormats
   "return a list of formats and short-info-string, as per supported format symbol"

    ^ #(
        (#'xml_cobertura'       'a cobertura-like xml format')
    )

    "Created: / 30-07-2011 / 10:18:18 / cg"
! !

!TestCoverageReporter class methodsFor:'reporting'!

reportPackages: aCollectionOfPackages format: format on: stream
    self new 
        reportPackages: aCollectionOfPackages format: format on: stream
! !

!TestCoverageReporter methodsFor:'reporting'!

reportPackages: aCollectionOfPackages format: aSymbol on: aStream

    packages := aCollectionOfPackages.
    stream := aStream.
    self report: aSymbol
! !

!TestCoverageReporter methodsFor:'reporting - xml-cobertura'!

reportXml_cobertura
"
 self new 
        stream:Transcipt;
        reportXml_coberturaForPackage:'stx:libbasic'
"
    "generate cobertura compatible XML coverage report format"

    |instrumentedClasses uninstrumentedClasses 
     version lineRate branchRate
     linesCovered linesValid branchesCovered branchesValid complexity|

    lineRate := 50.
    branchRate := 61.
    version := '0.4'.
    linesCovered := 1000.
    linesValid := 1000.
    branchesCovered := 1000.
    branchesValid := 1000.
    complexity := 1.5.

    instrumentedClasses := OrderedCollection new.    
    uninstrumentedClasses := OrderedCollection new.    

    packages do:[:eachPackageID |
        Smalltalk allClassesInPackage:eachPackageID do:[:eachClass |
            ((eachClass methodDictionary values contains:[:someMethod | someMethod isInstrumented])
            or:[ (eachClass class methodDictionary values contains:[:someMethod | someMethod isInstrumented]) ])
            ifTrue:[
                instrumentedClasses add:eachClass
            ] ifFalse:[
                uninstrumentedClasses add:eachClass
            ].
        ].
    ].

    stream
        nextPutLine: '<?xml version="1.0"?>';
        nextPutLine: '<!!--DOCTYPE coverage SYSTEM "http://cobertura.sourceforge.net/xml/coverage-03.dtd"-->';
        nextPutAll: '<coverage';
        nextPutAll:(' line-rate="%1"' bindWith:lineRate);
        nextPutAll:(' branch-rate="%1"' bindWith:branchRate);
        nextPutAll:(' version="%1"' bindWith:version);
        nextPutAll:(' lines-covered="%1"' bindWith:linesCovered);
        nextPutAll:(' lines-valid="%1"' bindWith:linesValid);
        nextPutAll:(' branches-covered="%1"' bindWith:branchesCovered);
        nextPutAll:(' branches-valid="%1"' bindWith:branchesValid);
        nextPutAll:(' complexity="%1"' bindWith:complexity);
        nextPutAll:(' timestamp="%1>"' bindWith:Timestamp now utcSecondsSince1970 * 1000 "millis").

    packages do:[:eachPackageID |
    ].

    stream
        nextPutAll: '</coverage'.
! !

!TestCoverageReporter methodsFor:'reporting-private'!

report:formatSymbol
    "currently supported formatSymbols:
            xml_cobertura"

    |reportFormatSelector|

    reportFormatSelector := self reportFormatSelector:formatSymbol.
    (self respondsTo: reportFormatSelector)
        ifTrue:[self perform: reportFormatSelector]
        ifFalse:[self error:'Unsupported format: ', formatSymbol].

    "Modified (comment): / 03-08-2011 / 12:57:54 / cg"
!

reportFormatSelector:format
    ^ ('report' , format asString asUppercaseFirst) asSymbol
! !

!TestCoverageReporter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestCoverageReporter.st,v 1.4 2015-02-18 15:05:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestCoverageReporter.st,v 1.4 2015-02-18 15:05:27 cg Exp $'
! !

