"/
"/ runs a number of tests from the exept:regression package (see list below)
"/ execute this script using the following command line:
"/
"/ stx --noBanner -I --execute SelfTest.st
"/
"/   use
"/      --debug to debug failed test cases.
"/      --skipTests to skip tests
"/      --skipMetrics to metric reports tests
"/
"/ To use with jenkins (+ jUnit plugin):
"/ use the following buildscript (in jenkins):
"/ (after checkout of stx)
"/      cd stx
"/      call bmake
"/      cd goodies\selftest
"/      ..\..\projects\smalltalk\stx.com --noBanner -I --execute SelfTest.st
"/
"/ and configure the jenkins junit plugin, to scan for "testresult.xml"
"/ ------------------------------------------------------------------------------------

"/ tell the system, where stx is...
ParserFlags initializeSTCFlagsForTopDirectory:'../../..'.

Object infoPrinting:false.
ObjectMemory infoPrinting:false.

"/ install a global handler, which suppresses the updating of the change file
Processor activeProcess exceptionHandlerSet
    on:(Class updateChangeFileQuerySignal)
    do:[:ex | ex proceedWith:false ].
!

Stdout showCR:'Selftest Started'.
!

Smalltalk packagePath addFirst:'../../../..'.

"/ ensure that some packages are present
Stdout showCR:'Loading sunit...'.
Smalltalk loadPackage:'stx:goodies/sunit'.
self assert:(TestCase notNil and:[TestCase isLoaded]) message:'[Error]: Missing TestCase class after sunit package load'.

"/ Smalltalk loadPackage:'stx:goodies/xml/vw'.
"/ Smalltalk loadPackage:'stx:goodies/xml/stx'.
Smalltalk loadPackage:'stx:libcompat'.
Smalltalk loadPackage:'stx:libjavascript'.
!

|suite result debugging|

Stdout showCR:'Creating suite...'.
suite := TestSuite named:'SelfTest'.

Stdout showCR:'Loading regression tests...'.

"To add a new test please edit exept_regression>>testCaseNamesWithoutNamespace"
Smalltalk fileInClass:#'exept_regression' package:'exept:regression'.
(Smalltalk at: #'exept_regression') isNil ifTrue:[
    Stdout showCR:('ERROR: Ouch - missing class: "exept_regression"').
    Smalltalk exit: 1.
].

(Smalltalk at: #'exept_regression') testCaseNamesWithoutNamespace do:[:className |
    |fullName|

    fullName := ('RegressionTests::',className).
    Stdout showCR:('  loading ',className,'...').
    Error handle:[:ex |
	Stdout showCR:('**** Ouch - error while loading class: "',className,'"').
    ] do:[
	Smalltalk fileInClass:fullName package:'exept:regression'.
    ].
    (Smalltalk classNamed:fullName) isNil ifTrue:[
	Stdout showCR:('**** Ouch - missing class: "',fullName,'"').
    ] ifFalse:[
	suite addTest:(Smalltalk classNamed:fullName) suite.
    ]
].

"/
"/ run the suite
"/
(Smalltalk commandLineArguments includes:'--skipTests') ifTrue:[
    Stdout showCR:'Skipping suite.'.
] ifFalse:[
    Stdout showCR:'Running suite...'.
    debugging := (Smalltalk commandLineArguments includes:'--debug').
    result := suite
		run:TestResultStX new
		beforeEachDo:[:test |
		    Stdout showCR:('- running ',test printString).
		]
		afterEachDo:[:test|
		    Stdout showCR:('- done ',test printString).
		]
		debug:debugging.

    Stdout showCR:'Generating report...'.
    TestResultReporter
	report:result
	format:#xml_jUnit
	as:'testresult.xml'.

    Stdout showCR:'Summary:'.
    Stdout showCR:('  %1 tests;' bindWith:result runCount).
    Stdout show:('  %1 passed,' bindWith:result passedCount).
    Stdout show:(' %1 failed,' bindWith:result failureCount).
    Stdout showCR:(' %1 errors.' bindWith:result errorCount).
].

"/
"/ generate a metrics report
"/
#(
	    'stx:libbasic'
	    'stx:libbasic2'
	    'stx:libbasic3'
	    'stx:libcomp'
	    'stx:libview'
	    'stx:libview2'
	    'stx:libwidg'
	    'stx:libwidg2'
	    'stx:libtool'
	    'stx:libtool2'
	    'stx:libui'
	    'stx:libhtml'
	    'stx:libboss'
	    'stx:libdb'
	    'stx:libjavascript'
	    'stx:goodies/xml/stx'
	    'stx:goodies/xml/yaxo'
	    'stx:goodies/xml/xsl'
	    'stx:goodies/xml/xpath'
	    'stx:goodies/net'
	    'stx:goodies/communication'
	    'stx:goodies/webServer'
	    'stx:goodies/soap'
) do:[:p | Smalltalk loadPackage:p].

(Smalltalk commandLineArguments includes:'--skipMetrics') ifTrue:[
    Stdout showCR:'Skipping metrics.'.
] ifFalse:[
    'metrics.xml' asFilename writingFileDo:[:stream |
	MetricsReporter new
	    stream: stream;
	    packages:{
		'stx:*'       .
	    };
	    classMetricNames: #();
	    methodMetricNames: #();
	    packageMetricNames: #( 'LOC' 'NOM' 'NOC');
	    reportXml_metrics.
    ].
].

!
