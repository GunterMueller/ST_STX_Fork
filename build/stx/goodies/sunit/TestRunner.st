"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#TestRunner
	instanceVariableNames:'result lastTestCase lastPass defect allDefects defectMenu details
		mode scriptModel script numberOfTestsToRun testsWhichFailed
		testsWhichPassed categoryModel category'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-UI'
!

!TestRunner class methodsFor:'documentation'!

documentation
"
    This GUI is based on SUnit2.7 and
    was ported to ST/X by Samuel S. Schuster (as 2.7)  (thanks, indeed)

    It was slightly enhanced by adding a rerun-defects, browse and
    a category selector (to minor revision 2.7d, in the meantime)
"
! !

!TestRunner class methodsFor:'defaults'!

colorForFailedTests
    ^ Color red
!

colorForPassedTests
    ^ Color green darkened
!

defaultIcon
    <resource: #programImage>

    "/ kept there to prevent me from being autoloaded for the icon
    ^ ToolbarIconLibrary sUnit24x24Icon
! !

!TestRunner class methodsFor:'interface specs'!

flyByHelpSpec
    <resource: #help>

    ^super flyByHelpSpec addPairsFrom:#(

#refreshSuitesButton
'Refresh List of Tests'

#suitesCategoryList
'Test Categories'

#suiteSelection
'Selected Test'

#runButton
'Run selected Test'

#rerunDefectsButton
'ReRun Defects Only'

#runAllButton
'Run all Tests from Category'

#defectsList
'Failures'

#browseButton
'Browse Test'

#debugButton
'Debug Failed Test'

)
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TestRunner andSelector:#windowSpec
     TestRunner new openInterface:#windowSpec
     TestRunner open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'SUnit Camp Smalltalk 3.1/STX TestRunner'
	  name: 'SUnit Camp Smalltalk 3.1/STX TestRunner'
	  min: (Point 362 122)
	  bounds: (Rectangle 0 0 493 175)
	  icon: defaultIcon
	)
	component:
       (SpecCollection
	  collection: (
	   (ActionButtonSpec
	      label: 'Refresh'
	      name: 'RefreshButton'
	      layout: (LayoutFrame 0 0 0 0 75 0 48 0)
	      activeHelpKey: refreshSuitesButton
	      tabable: true
	      model: refreshSuites
	    )
	   (MenuButtonSpec
	      name: 'category'
	      layout: (LayoutFrame 76 0 0 0 -216 1 24 0)
	      activeHelpKey: suitesCategoryList
	      tabable: true
	      model: category
	      menu: categoryList
	    )
	   (MenuButtonSpec
	      name: tests
	      layout: (LayoutFrame 76 0 24 0 -216 1 48 0)
	      activeHelpKey: suiteSelection
	      tabable: true
	      model: script
	      menu: scriptModel
	      useIndex: true
	    )
	   (ActionButtonSpec
	      label: 'Run'
	      name: 'RunButton'
	      layout: (LayoutFrame -215 1 0 0 -160 1 48 0)
	      activeHelpKey: runButton
	      tabable: true
	      model: runTests
	      enableChannel: enableRunButton
	    )
	   (ActionButtonSpec
	      label: 'ReRun Defects'
	      name: 'ReRunButton'
	      layout: (LayoutFrame -159 1 0 0 -57 1 48 0)
	      activeHelpKey: rerunDefectsButton
	      tabable: true
	      model: runDefects
	      enableChannel: enableDefects
	    )
	   (ActionButtonSpec
	      label: 'Run All'
	      name: 'RunAllButton'
	      layout: (LayoutFrame -56 1 0 0 0 1 48 0)
	      activeHelpKey: runAllButton
	      tabable: true
	      model: runAllTests
	    )
	   (ProgressIndicatorSpec
	      name: 'ProgressIndicator1'
	      layout: (LayoutFrame 0 0.0 49 0 0 1.0 60 0)
	      visibilityChannel: percentageIndicatorVisible
	      model: percentageDone
	      foregroundColor: (Color 32.999160753796 32.999160753796 0.0)
	      backgroundColor: (Color 66.999313344015 66.999313344015 0.0)
	      showPercentage: false
	    )
	   (LabelSpec
	      label: '...'
	      name: 'details'
	      layout: (LayoutFrame 0 0 21 0.5 0 1 -25 1)
	      labelChannel: details
	    )
	   (LabelSpec
	      label: 'N/A'
	      name: 'mode'
	      layout: (LayoutFrame 0 0 49 0 0 1 35 0.5)
	      style: (FontDescription Arial bold roman 14)
	      labelChannel: mode
	    )
	   (MenuButtonSpec
	      name: defects
	      layout: (LayoutFrame 0 0 -24 1 -152 1 0 1)
	      isOpaque: true
	      flags: 40
	      activeHelpKey: defectsList
	      tabable: true
	      model: selectionHolder
	      initiallyDisabled: true
	      enableChannel: enableDefects
	      menu: defectMenu
	      ignoreReselect: false
	    )
	   (ActionButtonSpec
	      label: 'Browse'
	      name: 'BrowseButton'
	      layout: (LayoutFrame -151 1 -24 1 -76 1 0 1)
	      activeHelpKey: browseButton
	      tabable: true
	      model: browseSelectedTestCase
	      initiallyDisabled: true
	      enableChannel: enableRunButton
	    )
	   (ActionButtonSpec
	      label: 'Debug'
	      name: 'DebugButton'
	      layout: (LayoutFrame -75 1 -24 1 0 1 0 1)
	      activeHelpKey: debugButton
	      tabable: true
	      model: debugSelectedFailure
	      initiallyDisabled: true
	      enableChannel: enableDebugButton
	    )
	   )

	)
      )
! !

!TestRunner class methodsFor:'opening'!

open

	^super open
!

openOnTestCase:aTestCaseSubclass
    "open the testrunner,let it switch to and execute a testcase"

    |runner|

    runner := self new.
    runner openAndWaitUntilVisible.

    "/ idx := runner scriptModel value indexOf:aTestCaseSubclass name.
    runner selectScriptNamed:aTestCaseSubclass name.

    "/ the test should be executed by the TestRunner process (not the caller)
    "/ in oder for CTRL-C and busyCursor to work correctly.
    "/ Therefore, push event instead of executing the test here.

    "/runner runTests
    runner enqueueMessage:#runTests for:runner arguments:#().

    "
     self openOnTestCase:CompilerTest
     self openOnTestCase:ConstraintTests
    "
! !

!TestRunner class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
	#script
      ).

! !

!TestRunner methodsFor:'accessing'!

category
    |holder|

    (holder := builder bindingAt:#category) isNil ifTrue:[
	holder := '* all *' asValue.
	builder aspectAt:#category put:holder.
	holder onChangeSend:#categorySelectionChanged to:self.
    ].
    ^ holder.
!

categoryList
    ^categoryModel isNil
	ifTrue: [categoryModel := ValueHolder new. self updateCategoryList. categoryModel]
	ifFalse: [categoryModel]
!

defectMenu
    ^ defectMenu isNil
        ifTrue: [defectMenu := OrderedCollection new asValue]
        ifFalse: [defectMenu]

    "Modified: / 4.4.2000 / 20:00:31 / Sames"
!

defects

	^self builder componentAt: #defects

    "Created: / 21.6.2000 / 12:19:29 / Sames"
!

details
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^details isNil
		ifTrue:
			[details := '...' asValue]
		ifFalse:
			[details]
!

mode
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^mode isNil
		ifTrue:
			[mode := 'N/A' asValue]
		ifFalse:
			[mode]
!

percentageDone
    ^ builder valueAspectFor:#percentageDone initialValue:0
!

percentageIndicatorVisible
    ^ builder valueAspectFor:#percentageIndicatorVisible initialValue:false
!

script
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    script isNil ifTrue:[
        script := ValueHolder new.
        script onChangeSend:#suiteSelectionChanged to:self.
    ].
    ^ script.

    "Created: / 21.6.2000 / 12:04:36 / Sames"
!

script:something
    builder aspectAt:#script put:something.

    "Created: / 21.6.2000 / 12:04:36 / Sames"
!

scriptModel
    "This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

    ^scriptModel isNil
	ifTrue: [scriptModel := ValueHolder new. self updateSuitesList. scriptModel]
	ifFalse: [scriptModel]

    "Modified: / 2.4.2000 / 14:37:51 / Sames"
!

selection

	^defect

    "Created: / 4.4.2000 / 18:50:55 / Sames"
!

selectionHolder

    |holder|

    (holder := builder bindingAt:#selectionHolder) isNil ifTrue:[
	holder := AspectAdaptor new subject:self; forAspect:#selection.
	builder aspectAt:#selectionHolder put:holder.
    ].
    ^ holder.

    "Created: / 4.4.2000 / 18:46:08 / Sames"
    "Modified: / 4.4.2000 / 18:47:31 / Sames"
!

tests

	^self builder componentAt: #tests

    "Created: / 4.4.2000 / 19:57:37 / Sames"
! !

!TestRunner methodsFor:'actions'!

browseSelectedTestCase
    |testCaseName testCase browser defect singleCase|

    testCaseName := self selectedScript.
    testCaseName isNil ifTrue:[
        testCaseName := self tests contents.
        testCaseName notNil ifTrue:[
            testCaseName := testCaseName string
        ]
    ].
    testCaseName notNil ifTrue:[
        testCase := Smalltalk at:testCaseName asSymbol.
        testCase notNil ifTrue:[
            browser := testCase browserClass openInClass:testCase.
            MessageNotUnderstood
                handle:[:ex | ]
                do:[
                    (defect := self selection) notNil ifTrue:[
                        singleCase := allDefects at:defect ifAbsent: [nil].
                    ].
                    singleCase notNil ifTrue:[
                        browser switchToSelector:singleCase selector
                    ] ifFalse:[
                        browser selectProtocolsMatching:'test*'
                    ]
                ]
        ]
    ]
!

categorySelectionChanged
    |selectedScriptIndex selectedScript oldSuitesList newSuitesList
     newScriptSelectionIndex|

    selectedScriptIndex := self script value.
    oldSuitesList := self scriptModel value.

    (selectedScriptIndex notNil and:[selectedScriptIndex ~~0]) ifTrue:[
	selectedScript := (oldSuitesList at:selectedScriptIndex) string
    ].

    self updateSuitesList.

    newSuitesList := self scriptModel value.
    newScriptSelectionIndex := newSuitesList indexOf:selectedScript.

    self script value:(newScriptSelectionIndex == 0
			    ifTrue:[nil]
			    ifFalse:[newScriptSelectionIndex]).
!

debugSelectedFailure
	self debugTest: self selection

    "Created: / 21.6.2000 / 10:58:58 / Sames"
    "Modified: / 21.6.2000 / 12:21:05 / Sames"
!

debugTest: aTestCaseName
    | testCase |

    defect := aTestCaseName.
    testCase := allDefects at: aTestCaseName ifAbsent: [nil].
    testCase isNil ifTrue: [^self enableDebugButton value: false].

    self enableDebugButton value: true.
    self displayMode: 'Debugging'.

    "/ defect := nil.

    self withWaitCursorDo:[
	((result isFailure: testCase) "or:[(result isError: testCase)]")
	    ifTrue: [testCase debugAsFailure]
	    ifFalse: [testCase debug].
    ].

    "Modified: / 21.6.2000 / 12:12:09 / Sames"
!

enableDebugButton
    ^ builder valueAspectFor:#enableDebugButton initialValue:false

    "Created: / 21.6.2000 / 10:47:34 / Sames"
    "Modified: / 21.6.2000 / 10:51:07 / Sames"
!

enableDefects
    ^ builder valueAspectFor:#enableDefects initialValue:true
!

enableRunButton
    ^ builder valueAspectFor:#enableRunButton initialValue:true

    "Created: / 21.6.2000 / 10:47:34 / Sames"
!

refreshSuites
        self updateCategoryList.
        self updateSuitesList.

        self script value:nil.
        self tests selection: 0.
        self defects selection: 0.
        result := TestResult defaultResultClass new.
        lastTestCase := nil.
        self displayRefresh

    "Created: / 21.6.2000 / 10:58:34 / Sames"
    "Modified: / 21.6.2000 / 12:19:54 / Sames"
!

rerunSingleSelectedTestCase
    self debugTest:self defects contents
!

runAllTests
	self runSuite: self allTestSuite
!

runDefectTests
	| testSuite |
	(testSuite := self defectTestSuite) notNil ifTrue:
		[self runSuite: testSuite]
!

runDefects
    allDefects size > 0 ifTrue:[
	^ self runDefectTests
    ].
    self runTests
!

runSuite:aTestSuite
    |numTests|
    "/ count the number of individual tests
    numTests := 0.
    aTestSuite tests do:
            [:eachTestOrSubSuite |
            (eachTestOrSubSuite isKindOf:TestSuite)
                ifTrue:[numTests := numTests + eachTestOrSubSuite tests size.]
                ifFalse:[numTests := numTests + 1.]].
    numberOfTestsToRun := numTests.
    self percentageDone value:0.
    Cursor wait showWhile:
            [|errorCountBefore failureCountBefore|
            self displayRunning.

            "/ self displayDetails: '...'.

            aTestSuite addDependentToHierachy:self.
            result := TestResult defaultResultClass new.
            lastTestCase := aTestSuite.
            self showPercentageIndicator.
            errorCountBefore := result errorCount.
            failureCountBefore := result failureCount.

            [|caseName|
            aTestSuite
                run:result
                beforeEachDo:
                    [:eachCase :eachResult |
                    caseName := eachCase getTestName.
                    caseName size == 0 ifTrue:[self halt:'oops - className?'].
                    self displayDetails:(caseName , '...').
                    self testPassed:caseName]
                afterEachDo:
                    [:eachCase :eachResult |
                    |passed errorCountAfter failureCountAfter|
                    errorCountAfter := result errorCount.
                    failureCountAfter := result failureCount.
                    passed := (errorCountAfter == errorCountBefore)
                                & (failureCountAfter == failureCountBefore).
                    passed == true
                        ifTrue:
                            ["/                                    testsWhichPassed add:caseName.
                            "/                                    testsWhichFailed remove:caseName ifAbsent:nil.
                            ]
                        ifFalse:[self testFailed:caseName withResult:result].
                    errorCountBefore := errorCountAfter.
                    failureCountBefore := failureCountAfter]] ensure:
                        [aTestSuite removeDependentFromHierachy:self.
                        self hidePercentageIndicator.
                        self displayNormalColorInProgress.].
            self updateWindow]
!

runTests
	| testSuite |
	(testSuite := self freshTestSuite) notNil ifTrue:
		[self runSuite: testSuite]

    "Modified: / 2.4.2000 / 14:16:10 / Sames"
!

scriptSelectionChanged
    self enableRunButton value:(self script value notNil).
!

selection: aValue

    aValue = '' ifTrue:[
	defect := aValue.
    ] ifFalse:[
	self debugTest: aValue
    ].

    "Created: / 4.4.2000 / 18:54:09 / Sames"
    "Modified: / 4.4.2000 / 19:01:33 / Sames"
!

suiteSelectionChanged
    |ok className description  cls|

    ok := self freshTestSuite notNil and:[self script value notNil].
    "/ self enableRunButton value:ok.
    self enableRunButton value:self script value notNil.
    self enableDefects value:(ok and:[allDefects size > 0]).

    self script value notNil ifTrue:[
	self selectedScript notNil ifTrue:[
	    className := self selectedScript string.
	].
	(ok and:[className notNil]) ifTrue:[
	    cls := Smalltalk at:className.
	    (cls class includesSelector:#description) ifTrue:[
		description := cls description.
	    ]
	].
    ].
    self displayDetails:nil.
    self displayMode: (description ? '').
    self displayGray.

    "Created: / 21.6.2000 / 11:31:25 / Sames"
    "Modified: / 21.6.2000 / 11:32:54 / Sames"
!

suitesInCategory
	|suites cat allCategories|

	cat := self category value.
	allCategories := (cat = '* all *').

	suites := TestCase allSubclasses
			select:[:each |
				true "/ "cg:TestCaseHelper is gone -->" ((each isSubclassOf:TestCaseHelper) not)
				and:[each isAbstract not
				and:[allCategories or:[cat = each category]]]]
			thenCollect: [:each | each name].
	suites sort.
	^ suites
!

updateCategoryList
        |categories|

        categories := (TestCase allSubclasses collect:[:each | each category] as:Set) asOrderedCollection.
        categories sort.
        categories addFirst:'* all *'.
        self categoryList value:categories.
!

updateSuitesList
        |suites|

        suites := self suitesInCategory.
        suites := suites
                    collect:[:eachSuiteName |
                                (testsWhichFailed includes:eachSuiteName) ifTrue:[
                                    eachSuiteName withColor:(self class colorForFailedTests).
                                ] ifFalse:[
                                    (testsWhichPassed includes:eachSuiteName) ifTrue:[
                                        eachSuiteName withColor:(self class colorForPassedTests).
                                    ] ifFalse:[
                                        eachSuiteName
                                    ]
                                ].
                            ].
        self scriptModel value: suites.
! !

!TestRunner methodsFor:'initialize-release'!

release
    Smalltalk removeDependent:self.
    super release.
! !

!TestRunner methodsFor:'private'!

addToFailedTests:caseName
    testsWhichFailed add:caseName.
!

addToPassedTests:caseName
    testsWhichPassed add:caseName.
!

allTestSuite
        "generate and return a suite for all tests, except SUnitTests"

        | tokens stream suite|

        tokens := (self suitesInCategory
                          collect: [:eachName | eachName ", '*' " ])
                      copyWithout: 'SUnitTest* '.
        stream := WriteStream on:''.
        tokens do: [:each | stream nextPutAll:each; space].
        suite := TestSuitesScripter run: stream contents.
        suite name:'all'.
        ^ suite
!

defectTestSuite
	|suite|

	suite := TestSuite new.
	suite name:'defects'.
	allDefects keysAndValuesDo:[:nm :test |
	    suite addTest:test.
	].
	^suite
!

formatTime: aTime
	aTime hours > 0 ifTrue: [^aTime hours printString , 'h'].
	aTime minutes > 0 ifTrue: [^aTime minutes printString , 'min'].
	^aTime seconds printString , ' sec'
!

freshTestSuite
	|tests suite|

	tests := self tests contents.
	tests isNil ifTrue:[ ^ nil].
	tests := tests string.
	suite := TestSuitesScripter run: tests.
	^ suite

    "Modified: / 4.4.2000 / 20:13:41 / Sames"
!

initialize
    super initialize.

    testsWhichPassed := Set new.
    testsWhichFailed := Set new.

    TestCase allSubclassesDo:[:cls |
        |lastResult className|

        cls isAbstract ifFalse:[
            lastResult := cls lastTestRunResultOrNil.
            lastResult notNil ifTrue:[
                className := cls name.
                lastResult == TestResult statePass ifTrue:[
                    testsWhichPassed add:className
                ] ifFalse:[
                    testsWhichFailed add:className
                ]
            ]
        ]
    ].
!

postOpenWith: aBuilder
    "automatically generated by UIPainter ..."

    super postOpenWith: aBuilder.
    self tests defaultLabel: ''.
    "/ self tests selection: 'ExampleSetTest'. self script value:1.

    self enableRunButton value: (self script value notNil).
    self enableDebugButton value: false.
    self enableDefects value: false.
    self script onChangeSend: #suiteSelectionChanged to:self.

    Smalltalk addDependent:self.

    "Created: / 2.4.2000 / 14:44:32 / Sames"
    "Modified: / 21.6.2000 / 12:06:30 / Sames"
!

removeFromFailedTests:caseName
    testsWhichFailed remove:caseName ifAbsent:nil.
!

removeFromPassedTests:caseName
    testsWhichPassed remove:caseName ifAbsent:nil.
!

selectScriptNamed:aScriptName
    |idx scriptClass|

    idx := self scriptModel value indexOf:aScriptName.
    self script value:idx.

    self updateCategoryList.

    scriptClass := Smalltalk at:aScriptName asSymbol.
    scriptClass notNil ifTrue:[
	self category value:scriptClass category.
    ]
!

selectedScript
    |scriptIndex|

    scriptIndex := self script value.
    scriptIndex isNil ifTrue:[
	^ ''
    ].
    ^ self scriptModel value at:scriptIndex ifAbsent:nil.
!

testFailed:caseName withResult:result
    |cls|

    self removeFromPassedTests:caseName.
    self addToFailedTests:caseName.

    (cls := Smalltalk classNamed:caseName) notNil ifTrue:[
	cls rememberFailedTestRunWithResult:result.
    ].
!

testPassed:caseName
    |cls|

    self removeFromFailedTests:caseName.
    self addToPassedTests:caseName.

"/    Transcript show:'passed: '; showCR:caseName.
"/    Transcript show:'passed: '; showCR:caseName className.

    (cls := Smalltalk classNamed:caseName) notNil ifTrue:[
	cls rememberPassedTestRun
    ].
!

timeSinceLastPassAsString
	lastPass isNil ifTrue: [^''].
	^', ' , (self formatTime: (Time now subtractTime: lastPass getSeconds)) , ' since last Pass'

    "Modified: / 3.4.2000 / 19:17:11 / Sames"
! !

!TestRunner methodsFor:'updating'!

displayColor: aColorValue

	(builder componentAt: #mode) widget insideColor: aColorValue.
	(builder componentAt: #details) widget insideColor: aColorValue.

    "Modified: / 2.4.2000 / 14:21:42 / Sames"
!

displayDefault
	self displayColor: self tests backgroundColor

    "Created: / 21.6.2000 / 12:28:06 / Sames"
    "Modified: / 21.6.2000 / 12:35:09 / Sames"
!

displayDefects: aCollection
    | failedTests|
    aCollection isEmpty ifTrue: [
        self selectionHolder value:''.
        self enableDefects value:false.
        self enableDebugButton value:false.
        ^ self
    ].
    allDefects := Dictionary new.
    aCollection do: [:each | allDefects at: each printString put: each].
    failedTests := allDefects keysSorted.
    self defectMenu value: failedTests.
"/    self selectionHolder value: failedTests first withoutNotifying:self.
    self enableDefects value:true.

    "Modified: / 4.4.2000 / 20:11:06 / Sames"
!

displayDetails: aString
    self details value: aString.
    self repairDamage.

    "Modified: / 21.6.2000 / 11:10:14 / Sames"
!

displayErrorColorInProgress
    (self builder componentAt:#ProgressIndicator1)
      foregroundColor: (self class colorForFailedTests).

"/    (self builder componentAt:#ProgressIndicator1)
"/      backgroundColor: (Color red:67 green:0 blue:0)
!

displayFail
	self displayRed.
	self displayMode: 'Fail'.
	self displayDetails: result printString.
!

displayGray
	self displayColor: (View defaultViewBackgroundColor)
!

displayGreen
	self displayColor: ColorValue green
!

displayMode: aString
	self mode value: aString.
	self repairDamage.

    "Modified: / 21.6.2000 / 11:14:19 / Sames"
!

displayNormalColorInProgress
    (self builder componentAt:#ProgressIndicator1)
      foregroundColor: (Color red:33 green:33 blue:0);
      backgroundColor: (Color red:67 green:67 blue:0)
!

displayPass
    self displayGreen.
    (lastTestCase notNil
    and:[lastTestCase name notNil]) ifTrue:[
	self displayMode: 'Pass ' , lastTestCase name.
    ] ifFalse:[
	self displayMode: 'Pass'.
    ].
    self displayDetails: result runCount printString , ' run' , self timeSinceLastPassAsString.
    lastPass := Time now

    "Modified: / 21.6.2000 / 12:14:52 / Sames"
!

displayRed
	self displayColor: ColorValue red.
!

displayRefresh
    self displayMode: 'N/A'.
    self displayDetails:'...'.
    self updateDefects.
    self enableRunButton value: (self script value notNil).
    self enableDefects value: false.
    self enableDebugButton value: false.
    self displayDefault

    "Created: / 21.6.2000 / 12:14:11 / Sames"
    "Modified: / 21.6.2000 / 12:28:24 / Sames"
!

displayRunning
	self displayRunning:(self selectedScript ? 'all') string.
!

displayRunning:scriptName
	self displayYellow.
	self displayMode:('running ' , scriptName allBold).
"/        self displayDetails: '...'.
	self repairDamage.
!

displayYellow
	self displayColor: ColorValue yellow
!

hidePercentageIndicator
    self percentageIndicatorVisible value:false.
!

repairDamage
    |wg|

    (wg := self windowGroup) notNil ifTrue:[wg  repairDamage].
!

showPercentageIndicator
    self percentageIndicatorVisible value:true.
!

update:something with:aParameter from:changedObject
    changedObject == Smalltalk ifTrue:[
	(changedObject isBehavior and:[changedObject isSubclassOf:TestCase]) ifTrue:[
	    self updateSuitesList
	].
	^ self
    ].

    (changedObject isKindOf: TestSuite) ifTrue: [
	self displayRunning:changedObject name.
	^ self
    ].

    (changedObject isKindOf: TestCase) ifTrue: [
	(result errorCount + result failureCount) > 0 ifTrue:[
	    self displayErrorColorInProgress.
	].
	self percentageDone value:(result runCount / numberOfTestsToRun * 100) rounded.
	self displayDetails: changedObject printString.
	^ self
    ].

    super update:something with:aParameter from:changedObject
!

updateDefects
	|script|

	script := self selectedScript.
	script notNil ifTrue:[script := script string].

	self displayDefects: result defects.

	script notNil ifTrue:[
	    result hasPassed ifTrue:[
		self testPassed:script
	    ] ifFalse:[
		self testFailed:script withResult:result
	    ].
	].
!

updateWindow
	result hasPassed
		ifTrue: [self displayPass]
		ifFalse: [self displayFail].
	self updateDefects.
	self updateSuitesList. "/ for colors
! !

!TestRunner class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

