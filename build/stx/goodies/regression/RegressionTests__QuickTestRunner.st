"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

Object subclass:#QuickTestRunner
	instanceVariableNames:'suite anyError result'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!QuickTestRunner class methodsFor:'documentation'!

documentation
"
    ATTENTION: if you change anything here, please verify compatibility with the
	       SeltTestRunner script found in stx/goodies/regression.

    This is meant to be called via a script or command-line argument, when executing
    selftests via jenkins.

    Runs a number of tests from the stx:goodies/regression package (see list below)
    executed through SelfTestRunner script using the following command line:

    stx --noBanner -I --execute SelfTestRunner.st
      use --debug to debug failed test cases.

    to use with jenkins (+ jUnit plugin):
    use the following buildscript (in jenkins):
    (after checkout of stx)
	 cd stx
	 call bmake
	 cd goodies\selftest
	 ..\..\projects\smalltalk\stx.com --noBanner -I --execute SelfTestRunner.st

    and configure the jenkins junit plugin, to scan for 'testresult.xml'

    [author:]
	Claus Gittinger

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!QuickTestRunner class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!QuickTestRunner class methodsFor:'execution'!

start
    |runner|

    runner := self new.
    runner
	prepare;
	buildSuite;
	runSuite.

    Smalltalk isStandAloneApp ifTrue:[
	Smalltalk exit:(runner anyError ifTrue:[1] ifFalse:[0])
    ].
! !

!QuickTestRunner methodsFor:'execution'!

buildSuite
    |anyMissing|

    anyMissing := false.

    Stdout showCR:'Creating suite...'.
    suite := TestSuite named:'SelfTest'.

    Stdout showCR:'Loading regression tests...'.
    self listOfTestClasses do:[:className |
	|fullName|

	fullName := ('RegressionTests::',className).
	Stdout showCR:('Loading ',className,'...').
	Smalltalk fileInClass:fullName package:'stx:goodies/regression'.
	(Smalltalk classNamed:fullName) isNil ifTrue:[
	    Stdout showCR:('**** Ouch - missing class: "',fullName,'"').
	    anyMissing := true.
	] ifFalse:[
	    suite addTest:(Smalltalk classNamed:fullName) suite.
	]
    ].

    anyError := anyError | anyMissing.
!

generateReport
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
!

listOfTestClasses
    "*** IMPORTANT *** "
    "* To add a new test please edit stx_goodies_regression>>testCaseNamesWithoutNamespace"
    "*** ********* *** "
    Smalltalk fileInClass:#'stx_goodies_regression' package:'stx:goodies/regression'.
    (Smalltalk at: #'stx_goodies_regression') isNil ifTrue:[
	Stdout showCR:('ERROR: Ouch - missing class: "stx_goodies_regression"').
	Stdout showCR:('EXIT').
	Smalltalk exit: 1.
    ].
    ^(Smalltalk at: #'stx_goodies_regression') testCaseNamesWithoutNamespace

    "Modified: / 21-02-2013 / 18:05:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prepare
    "/ tell the system, where stx is...

    |top|

    top := Smalltalk packageDirectoryForPackageId:'stx'.
    "/ top := '../../..'.

    ParserFlags initializeSTCFlagsForTopDirectory:top.

    Object infoPrinting:false.
    ObjectMemory infoPrinting:false.

    Processor activeProcess exceptionHandlerSet
	on:(Class updateChangeFileQuerySignal)
	do:[:ex | ex proceedWith:false ].

    Stdout showCR:'Selftest Started'.

    Stdout showCR:'Loading sunit...'.
    Smalltalk loadPackage:'stx:goodies/sunit'.
    self assert:(TestCase notNil and:[TestCase isLoaded]).

    Smalltalk loadPackage:'stx:libcompat'.
    Smalltalk loadPackage:'stx:libjavascript'.
    Smalltalk loadPackage:'exept:libcrypt'.
!

runSuite
    Stdout showCR:'Running suite...'.
    result := suite
		run:TestResultStX new beforeEachDo:[:test |
		    Stdout showCR:('- running ',test printString).
		]
		afterEachDo:[:test| ]
		debug:(Smalltalk commandLineArgumentNamed:'--debug') notNil.
! !

!QuickTestRunner methodsFor:'initialization'!

initialize
    anyError := false.
! !

!QuickTestRunner class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

