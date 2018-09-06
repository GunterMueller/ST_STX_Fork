"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016-2017 Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

AbstractTestRunner subclass:#TestRunnerMini
	instanceVariableNames:'runnerPanel selectedClassesHolder selectedProtocolsHolder
		selectedMethodsHolder methodGeneratorHolder resultHolder
		resultInfoHolder resultBackgroundColorHolder runningHolder
		progressHolder progressIndicatorShownHolder infoHolder
		testProcess allTestCases progressIndicator'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-UI'
!

Object subclass:#SuiteAndResult
	instanceVariableNames:'suite result'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestRunnerMini
!

!TestRunnerMini class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016-2017 Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    a tiny runner to be embedded in a system browser
"
! !

!TestRunnerMini class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::TestRunnerEmbedded    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#debugSelected
'Run the selected test(s) with debugging enabled.\\A debugger is opened on error or assertion failure'

#runAll
'Run all tests.\\No debugger is opened on error or assertion failure,\but the test outcomes are remembered'

#runFailed
'Only rerun failed tests.\\No debugger is opened on error or assertion failure,\but the test outcomes are remembered'     

#runSelected
'Run the selected test(s).\\No debugger is opened on error or assertion failure,\but the test outcomes are remembered'     

#stopRun
'Stop the test-run'

#pin
'Pin the runner for the selected testcase as floating window.'

#runAllWithCoverage
'Run all tests with coverage measurement.\\This first recompiles all classes which are covered by the test(s) with instrumentation enabled,\so that reached code is recorded (runs a bit slower).\After the run, the browser will colorize reached code in green, unreached code in red, and partially reached code in orange.'

)

    "Created: / 04-06-2012 / 19:27:47 / cg"
! !

!TestRunnerMini class methodsFor:'image specs'!

pinIcon
    ^  self pinIcon2
!

pinIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self pinIcon1 inspect
     ImageEditor openOnClass:self andSelector:#pinIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::TestRunnerMini pinIcon1'
        ifAbsentPut:[(Depth8Image new) width:14; height:13; bits:(ByteArray fromPackedString:'
NC 8NC 8NC 8NB8/L# 8NC 8NC 8NC 8J3@1L# 8NC 8NC 8NB80J3@/APXDB@8OB3L+L3L0KB8RD1TVE1$ZJ2<0L2,8N@TGA@$JD@00KR<-M3 8M04MCP4M
CPD0KSL7NC 7CRD\HRDAHRD!!HS\8NCXMH!!4"H!!4TGQ4#M# 8M@4[IRP^IQ8XIRT5NC *CRX_I!!<_I!!<QG2$8N@LMI2 ''HB\ HB\ @# 8@@@@@@@@@@@@@@@@
NC b') ; colorMapFromArray:#[136 149 174 23 50 93 145 154 169 144 154 168 48 116 186 68 118 170 70 119 171 70 120 171 62 133 196 62 132 195 93 155 206 170 202 228 171 202 228 197 223 244 93 156 206 132 180 218 132 181 218 205 228 246 90 156 204 111 182 226 179 216 240 88 182 232 115 196 236 153 212 241 186 225 246 189 226 245 217 238 249 242 251 255 235 249 255 238 250 255 241 251 255 245 252 255 248 253 255 235 250 255 238 251 255 239 251 255 241 252 255 242 252 255 245 253 255 248 254 255 247 254 255 157 161 160 157 162 160 0 114 54 0 97 46 0 82 39 0 149 62 53 155 88 114 182 73 125 181 81 163 202 129 159 167 110 170 170 151 171 169 151 183 177 142 191 182 136 255 255 255]; mask:((Depth1Image new) width:14; height:13; bits:(ByteArray fromPackedString:'@C @O@A<??3?<O?0??C?<O?0??C?<O?0??@b') ; yourself); yourself]
!

pinIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self pinIcon2 inspect
     ImageEditor openOnClass:self andSelector:#pinIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::TestRunnerMini pinIcon2'
        ifAbsentPut:[(Depth8Image new) width:14; height:13; bits:(ByteArray fromPackedString:'
NC 8NC 8NC 8HR8/L"D8NC 8NC 8NC !!J3@1L# 8NC 8NC 8HR80J3@/APXDB@8OB3L+L3L0KB8RD1TVE1$ZJ2<0L2,!!HPTGA@$JD@00KR<-M3 8M04MCP4M
CPD0KSL7NC 7CRD\HRDAHRD!!HS\8NCXMH!!4"H!!4TGQ4#M# 8M@4[IRP^IQ8XIRT5NC *CRX_I!!<_I!!<QG2$8N@LMI2 ''HB\ HB\ @# 8@@@@@@@@@@@@@@@@
NC b') ; colorMapFromArray:#[136 149 174 23 50 93 145 154 169 144 154 168 48 116 186 68 118 170 70 119 171 70 120 171 62 133 196 62 132 195 93 155 206 170 202 228 171 202 228 197 223 244 93 156 206 132 180 218 132 181 218 205 228 246 90 156 204 111 182 226 179 216 240 88 182 232 115 196 236 153 212 241 186 225 246 189 226 245 217 238 249 242 251 255 235 249 255 238 250 255 241 251 255 245 252 255 248 253 255 235 250 255 238 251 255 239 251 255 241 252 255 242 252 255 245 253 255 248 254 255 247 254 255 157 161 160 157 162 160 114 0 18 97 25 0 82 21 0 149 30 0 155 66 53 182 73 138 181 81 147 202 129 179 163 110 167 170 170 151 171 169 151 183 177 142 191 182 136 255 255 255]; mask:((Depth1Image new) width:14; height:13; bits:(ByteArray fromPackedString:'@G0@_@C<??3??O?0??C?<O?0??C?<O?0??@b') ; yourself); yourself]
! !

!TestRunnerMini class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunnerMini andSelector:#windowSpec
     Tools::TestRunnerMini new openInterface:#windowSpec
     Tools::TestRunnerMini open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: '19654d83-a88a-4ba5-a03b-0550ba80c0db'
       window: 
      (WindowSpec
         label: 'Mini Test Runner'
         name: 'Mini Test Runner'
         uuid: '4bd5c159-6c40-4503-aaf5-fe44c935bfb2'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 600 50)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             uuid: '66940902-27aa-44b9-9781-ca7fecce683d'
             backgroundChannel: resultBackgroundColorAspect
             component: 
            (SpecCollection
               collection: (
                (HorizontalPanelViewSpec
                   name: 'RunnerInnerBox'
                   layout: (LayoutFrame 0 0 0 0 -2 1 0 1)
                   uuid: '5270ed4f-9fb1-4ee4-a6d7-29a0cf210484'
                   backgroundChannel: resultBackgroundColorAspect
                   horizontalLayout: rightSpaceFit
                   verticalLayout: topSpace
                   horizontalSpace: 0
                   elementsChangeSize: true
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'RunnerInfoBox'
                         uuid: '28697b42-41ed-4d3e-af60-105a19b47367'
                         backgroundChannel: resultBackgroundColorAspect
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Run tests first!!'
                               name: 'ResultName'
                               layout: (LayoutFrame 22 0 0 0 0 1 -10 1)
                               uuid: '96629bc4-d4d3-4809-bf4c-ac182ea08683'
                               backgroundChannel: resultBackgroundColorAspect
                               foregroundChannel: resultTextForegroundColorAspect
                               foregroundColor: (Color 100.0 100.0 100.0)
                               translateLabel: true
                               labelChannel: resultNameAspect
                               adjust: left
                             )
                            (ActionButtonSpec
                               name: 'Button3'
                               layout: (LayoutFrame 5 0 3 0 21 0 17 0)
                               activeHelpKey: pin
                               uuid: '1d2689a8-76d6-423d-b4a7-f5f5c5adbd1a'
                               level: 0
                               visibilityChannel: pinButtonVisibleHolder
                               backgroundChannel: resultBackgroundColorAspect
                               hasCharacterOrientedLabel: false
                               translateLabel: true
                               labelChannel: pinIcon
                               model: pin
                             )
                            )
                          
                         )
                         extent: (Point 219 31)
                       )
                      (ActionButtonSpec
                         label: 'Debug'
                         name: 'DebugButton'
                         activeHelpKey: debugSelected
                         uuid: '61c9ca6b-6f31-42bc-818b-5b2e562fd6f2'
                         translateLabel: true
                         model: debug
                         enableChannel: runEnabledHolder
                         extent: (Point 60 25)
                       )
                      (ActionButtonSpec
                         label: 'Stop'
                         name: 'Button2'
                         activeHelpKey: stopRun
                         uuid: '1ae27061-7e2c-4769-83fd-1e461371fe86'
                         visibilityChannel: runningHolder
                         translateLabel: true
                         model: stop
                         extent: (Point 60 25)
                       )
                      (ActionButtonSpec
                         label: 'Run'
                         name: 'Run'
                         activeHelpKey: runSelected
                         uuid: '79afa5fe-a549-4419-b035-21af25ac5ec3'
                         visibilityChannel: notRunningHolder
                         translateLabel: true
                         model: run
                         enableChannel: runEnabledHolder
                         extent: (Point 60 25)
                       )
                      (ActionButtonSpec
                         label: 'Failed'
                         name: 'Button1'
                         activeHelpKey: runFailed
                         uuid: '0cc5d9bb-8cab-44d4-aba2-62578ac4ebf8'
                         visibilityChannel: runFailedButtonVisibleHolder
                         translateLabel: true
                         model: runFailed
                         enableChannel: runFailedEnabledHolder
                         extent: (Point 60 25)
                       )
                      (ActionButtonSpec
                         label: 'Run All'
                         name: 'RunAll'
                         activeHelpKey: runAll
                         uuid: 'fc3f6081-35f8-43b6-a826-a4e902a11224'
                         visibilityChannel: runAllButtonVisibleHolder
                         translateLabel: true
                         model: runAll
                         enableChannel: runAllEnabledHolder
                         extent: (Point 60 25)
                       )
                      (ActionButtonSpec
                         label: 'Coverage'
                         name: 'Button4'
                         activeHelpKey: runAllWithCoverage
                         uuid: '4a032381-faf2-45f1-9860-71a32621b927'
                         visibilityChannel: runCoverageEnabledHolder
                         translateLabel: true
                         model: runAllWithCoverage
                         extent: (Point 80 25)
                       )
                      )
                    
                   )
                   postBuildCallback: postBuildRunnerPanel:
                 )
                (LabelSpec
                   name: 'ResultInfo'
                   layout: (LayoutFrame 0 0 -20 1 0 1 0 1)
                   style: (FontDescription helvetica medium roman 10 #'iso10646-1' nil nil)
                   uuid: 'f1b6a42b-e53e-4ace-ab09-040c0d2a0f39'
                   backgroundChannel: resultBackgroundColorAspect
                   foregroundChannel: resultTextForegroundColorAspect
                   translateLabel: true
                   labelChannel: resultInfoAspect
                   adjust: left
                 )
                (ViewSpec
                   name: 'ProgressPanel'
                   layout: (LayoutFrame -32 0.5 -17 1 -3 1.0 -5 1)
                   uuid: 'e955621c-7cc4-4a8a-9d41-22e68fbe024d'
                   initiallyInvisible: true
                   visibilityChannel: progressIndicatorShownHolder
                   backgroundChannel: resultBackgroundColorAspect
                   component: 
                  (SpecCollection
                     collection: (
                      (ProgressIndicatorSpec
                         name: 'RunningProgress'
                         layout: (LayoutFrame 5 0 0 0 -5 1 0 1)
                         uuid: '2be63ed2-a5ba-449a-91bb-5cdb196105b6'
                         model: progressHolder
                         postBuildCallback: postBuildProgressIndicator:
                       )
                      )
                    
                   )
                 )
                )
              
             )
           )
          )
        
       )
     )

! !

!TestRunnerMini class methodsFor:'queries'!

shouldRememberLastExtent
    "to be redefined by concrete applications:
     if true is answered, the application's extent is remembered on close
     and used as a default when opened the next time"

    ^ false

    "Created: / 22-09-2014 / 14:02:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini methodsFor:'accessing'!

allTestCases
    allTestCases isNil ifTrue:[
        self updateTestCases
    ].
    ^ allTestCases
!

allTestCases:something
    allTestCases := something.
!

infoHolder:something
    "to show something in the browsers info area (near the bottom"

    infoHolder := something.

    "Created: / 05-07-2011 / 16:22:24 / cg"
!

selectedTestMethods

    | selectedClass |
    selectedClass := self theSingleTestCase.

    ^ (self selectedMethodsHolder value ? #()) select:
            [:mthd | | cls |
            (cls := selectedClass) isNil ifTrue:[cls := mthd mclass].
            (self isTestCaseLike:selectedClass) 
                and:[ selectedClass isTestSelector:mthd selector ] ]

    "Created: / 15-03-2010 / 13:21:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2011 / 15:46:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-08-2011 / 17:46:38 / cg"
!

selectedTestMethodsFromProtocols:protocols 

    |methods generator selectedClass|

    methods := Set new.
    generator := self methodGeneratorHolder value.
    selectedClass := self theSingleTestCase.

    generator notNil ifTrue:[ 
        generator do: [:cls :cat :sel :mthd | 
            (mthd notNil 
                and:[ (self isTestCaseLike:(selectedClass ? cls)) 
                and:[ (selectedClass ? cls) isTestSelector:sel ] ]) 
            ifTrue:[ methods add:mthd ] 
        ] 
    ] ifFalse:[
        allTestCases do: [:cls | 
            cls methodsDo: [:mthd | 
                ((protocols includes:mthd category) and:[ cls isTestSelector:mthd selector ]) 
                ifTrue:[ 
                    methods add:mthd 
                ] 
            ] 
        ] 
    ].
    ^ methods

    "Created: / 15-03-2010 / 19:50:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2011 / 15:53:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-06-2012 / 19:05:32 / cg"
!

selectedTestMethodsFromProtocols:protocols inClass:aTestClass

    |methods generator|

    methods := Set new.
    generator := self methodGeneratorHolder value.

    generator notNil ifTrue:[ 
        generator do: [:cls :cat :sel :mthd | 
            (mthd notNil 
                and:[ (self isTestCaseLike:(aTestClass ? cls)) 
                and:[ (aTestClass ? cls) isTestSelector:sel ] ]) 
            ifTrue:[ methods add:mthd ] 
        ] 
    ] ifFalse:[
        self allTestCases do: [:cls | 
            cls methodsDo: [:mthd | 
                ((protocols includes:mthd category) and:[ cls isTestSelector:mthd selector ]) 
                ifTrue:[ 
                    methods add:mthd 
                ] 
            ] 
        ] 
    ].
    methods := methods asOrderedCollection.
    methods sortBySelector:#selector.
    ^ methods 

    "Created: / 15-03-2010 / 19:50:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2011 / 15:53:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-06-2012 / 19:05:32 / cg"
!

selectedTestMethodsInClass:testClass
    ^ (self selectedMethodsHolder value ? #()) select:
            [:mthd | | cls |
            (cls := testClass) isNil ifTrue:[cls := mthd mclass].
            (self isTestCaseLike:testClass) 
                and:[ testClass isTestSelector:mthd selector ] ]

    "Created: / 15-03-2010 / 13:21:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2011 / 15:46:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-08-2011 / 17:46:38 / cg"
!

theSingleTestCase

    self allTestCases isEmptyOrNil ifTrue:[^nil].
    allTestCases size > 1 ifTrue:[^nil].

    ^allTestCases anyOne.

    "Created: / 22-07-2011 / 15:44:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini methodsFor:'actions'!

allCoveredClasses
    "return a collection of classes which are covered by the selected
     tests. Requires that the testcase returns a non-empty collection
     from the coveredClasses query"

    |testedClasses suite|

    testedClasses := Set new.

    suite := self suiteForRunAll.
    suite tests do:[:eachTest |
        testedClasses addAll:(eachTest class coveredClasses).
    ].
    ^ testedClasses
!

debug
    | suiteAndResult suite result testRunAction| 

    suiteAndResult := resultHolder value.
    suite := suiteAndResult suiteForRun.
"/ ^self run:suite debug: true coverageContext: nil.


    "/ suite tests size ~= 1 ifTrue:[^self breakPoint: #jv].
    "/ test := suiteAndResult suite tests anyOne.
    result := TestResult defaultResultClass new.
    suiteAndResult := SuiteAndResult suite: suite result: result.

    self stop.

testRunAction := [
    "/ debug run is synchronous
    [
        self runningHolder value:true.
        self windowGroup repairDamage.

        suite tests do:[:test |
            [
                test debug. 
            ] ifCurtailed:[
                result failureOutcomes add: test.
                resultHolder value:suiteAndResult; changed.    
            ].

            (test class testSelectorPassed:test selector) ifTrue:[
                "/ result := TestResult defaultResultClass new.
                "/ result passed add: test.
                "/ suiteAndResult := SuiteAndResult suite: suite result: result.
                result passedOutcomes add: test.
                resultHolder value:suiteAndResult; changed.    
            ] ifFalse:[
                (test class testSelectorFailed:test selector) ifTrue:[
                    "/ result := TestResult defaultResultClass new.
                    "/ result failures add: test.
                    "/ suiteAndResult := SuiteAndResult suite: suite result: result.       
                    result failureOutcomes add: test.
                    resultHolder value:suiteAndResult; changed.    
                ]
            ].
            self windowGroup repairDamage
        ].
    ] ensure:[
        self runningHolder value:false.
    ].
].
    testRunAction value.
    
"/    testProcess := testRunAction newProcess.
"/    testProcess priority:(Processor userBackgroundPriority).
"/    testProcess resume.

    "Created: / 15-03-2010 / 15:43:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 11:33:48 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Modified: / 03-12-2012 / 14:02:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 16:49:14 / cg"
!

pin
    | runner |

    runner := TestRunnerMini new.
    runner resultHolder value: resultHolder value copy.

    runner allButOpen.
    runner window beToolWindow.
    runner open.

    "Modified: / 19-07-2017 / 08:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run
    |suite|

    resultHolder value isNil ifTrue:[
        suite := self suiteForRun
    ] ifFalse:[
        suite := resultHolder value suiteForRun
    ].
    self run:suite

    "Created: / 10-03-2010 / 19:42:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-08-2011 / 09:58:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2011 / 10:56:39 / cg"
!

run:suite 
    ^self run: suite debug: false

    "Created: / 11-03-2010 / 10:22:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2012 / 20:23:58 / cg"
    "Modified: / 03-12-2012 / 13:59:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run:suite debug: debug 
    self run:suite debug: debug coverageContext: nil
!

run:suite debug: debug coverageContext: coverageContextOrNil
    |suiteAndResult numTests testRunAction|

    numTests := suite tests size.
    numTests == 0 ifTrue:[
        ^ self
    ].

    self stop.

    testRunAction := 
        [
            |result incr run|

            result := (debug ifFalse:[TestResult] ifTrue:[TestResultForRunWithDebug]) new.
            suiteAndResult := SuiteAndResult suite:suite result:result.
            resultHolder setValue:nil; value:suiteAndResult; changed.
            [
                self runningHolder value:true.
                self progressIndicatorShownHolder value:(numTests > 1).
                self progressHolder value:0.
                incr := 100 / numTests.
                run := 0.
                result := suite 
                            run: result
                            beforeEachDo:[:test :result |
                                infoHolder notNil ifTrue:[
                                    infoHolder value:('Running "%1-%2"...' 
                                                    bindWith:test name
                                                    with:test getTestName allBold)
                                ]
                            ]
                            afterEachDo:[:test :result | 
                                run := run + 1.
                                self progressHolder value:(incr * run) truncated "rounded".
                                infoHolder notNil ifTrue:[
                                    infoHolder value:('Done.')
                                ].
                                resultHolder setValue:nil; value:suiteAndResult; changed.
                            ]
                            debug: debug.
                suiteAndResult := SuiteAndResult suite:suite result:result.
            ] ensure:[
                self progressIndicatorShownHolder value:false.
                resultHolder setValue:nil; value:suiteAndResult; changed.
                self runningHolder value:false.
            ]
        ].

    coverageContextOrNil notNil ifTrue:[
        |realAction|

        realAction := testRunAction.
        testRunAction := [ coverageContextOrNil run:realAction ]
    ].

    testProcess := testRunAction newProcess.
    testProcess priority:(Processor userBackgroundPriority).
    testProcess resume.

    "Created: / 03-12-2012 / 13:59:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 16:57:27 / cg"
!

runAll

    self run: (self suiteForRunAll).

    "Created: / 10-03-2010 / 19:42:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2010 / 13:12:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 19:00:14 / cg"
!

runAllWithCoverage
    "return a collection of classes which are covered by the selected
     tests. Requires that the testcase returns a non-empty collection
     from the coveredClasses query"

    |testedClasses suite packages package instrumentPackage answer|

    suite := self suiteForRunAll.

    instrumentPackage := false.
    testedClasses := self allCoveredClasses.
    testedClasses isEmpty ifTrue:[
"/        "/ may be in a package?
"/        packages := suite tests collect:[:eachTest | eachTest class package] as:Set.
"/        packages remove:'stx:libbasic' ifAbsent:[].
"/        packages size == 1 ifTrue:[
"/            package := packages first.
"/            answer := Dialog 
"/                confirmWithCancel:(resources 
"/                                    stringWithCRs:'The test cases do not define any covered class.\(missing #coveredClassNames or #coveredPackageNames method)\\Instrument package("%1") or run without coverage ?'
"/                                    with:package)
"/                labels:(resources array:#('No' 'Unstrument Packages' 'Yes')).
"/            
"/self halt.
"/        ] ifFalse:[
"/            (Dialog confirm:(resources stringWithCRs:'The test cases do not define any covered class.\(missing #coveredClassNames or #coveredPackageNames method)\\Run without coverage ?'))
"/            ifFalse:[^ self].
"/        ].
        (Dialog confirm:(resources stringWithCRs:'The test cases do not define any covered class.\(missing #coveredClassNames or #coveredPackageNames method)\\Run without coverage ?'))
        ifFalse:[^ self].
    ] ifFalse:[
        self withWaitCursorDo:[
            infoHolder notNil ifTrue:[
                infoHolder value:('Instrumenting...')
            ].

            testedClasses do:[:eachClass |
                masterApplication recompileClassWithInstrumentation:eachClass.
                InstrumentationInfo cleanAllInfoFor:eachClass withChange:true.
            ].
        ].
        infoHolder notNil ifTrue:[
            infoHolder value:('Running test...')
        ].
    ].

    self 
        run:suite 
        debug:false 
        coverageContext:(InstrumentationContext new coverageOnly:true)
!

runFailed
    self run: self suiteForRunFailed.

    "Created: / 04-06-2012 / 18:32:19 / cg"
!

runWithDebug
    "/ cg: I really do not want to run them twice to get a debugger 
    "/ - I want to run them either with a debugger coming right away, or not.

    | suiteAndResult suite|

    suiteAndResult := resultHolder value.
    suiteAndResult isNil ifTrue:[
        suite := self suiteForRun.
    ] ifFalse:[
        suite := suiteAndResult suiteForRun.
    ].

    self run: suite debug: true



    "/ suiteAndResult suite tests size ~= 1 ifTrue:[^self breakPoint: #jv].
    "/ [suiteAndResult suite tests anyOne debug] fork

    "Created: / 05-07-2011 / 18:45:43 / cg"
    "Modified: / 09-10-2011 / 10:55:46 / cg"
    "Modified: / 03-12-2012 / 13:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop
    |p|

    (p := testProcess) notNil ifTrue:[
        testProcess := nil.
        p terminate
    ].

    "Created: / 04-06-2012 / 18:34:07 / cg"
! !

!TestRunnerMini methodsFor:'aspects'!

debugVisibleAspect
    ^ BlockValue 
        with:[:model | 
            model notNil
            and:[ model testCount == 1 
            and:[ model hasFailuresOrErrors ]]
        ]
        argument:resultHolder

    "Created: / 15-03-2010 / 15:40:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-08-2011 / 18:19:14 / cg"
!

notRunningHolder
    ^ BlockValue forLogicalNot:(self runningHolder)

    "Created: / 04-06-2012 / 18:38:48 / cg"
!

progressHolder
    "return/create the 'progressHolder' value holder (automatically generated)"

    progressHolder isNil ifTrue:[
        progressHolder := ValueHolder new.
    ].
    ^ progressHolder
!

progressIndicatorShownHolder
    progressIndicatorShownHolder isNil ifTrue:[
        progressIndicatorShownHolder := ValueHolder with: false.
    ].
    ^ progressIndicatorShownHolder

    "Modified: / 15-03-2010 / 20:29:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-06-2012 / 18:38:52 / cg"
    "Created: / 04-06-2012 / 19:42:59 / cg"
!

resultBackgroundColorAspect
    <resource: #uiAspect>
    resultBackgroundColorHolder isNil ifTrue:[
        resultBackgroundColorHolder := BlockValue 
                with:[:result :running | 
                    running ifTrue:[
                        self class currentlyRunningColor
                        "/ View defaultBackgroundColor
                    ] ifFalse:[
                        result isNil ifTrue:[
                            self class notRunColor
                        ] ifFalse:[
                            result color
                        ]
                    ].
                ]
                argument:resultHolder
                argument:self runningHolder.
        resultBackgroundColorHolder 
            onChangeEvaluate:[
                runnerPanel notNil ifTrue:[
                    runnerPanel backgroundColor:resultBackgroundColorHolder value
                ]
            ].
    ].
    ^ resultBackgroundColorHolder.

    "Created: / 15-03-2010 / 15:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 19:40:11 / cg"
    "Modified: / 23-09-2014 / 09:46:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resultHolder
    "return/create the 'resultHolder' value holder (automatically generated)"

    resultHolder isNil ifTrue:[
        resultHolder := ValueHolder new.
    ].
    ^ resultHolder
!

resultInfoAspect
    ^ BlockValue 
        with:[:model | model isNil ifTrue:[ '' ] ifFalse:[ model info ] ]
        argument:resultHolder

    "Created: / 15-03-2010 / 20:22:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-08-2011 / 18:20:26 / cg"
!

resultNameAspect
    ^ BlockValue 
        with:[:model | model isNil ifTrue:[ 'Run the tests!!' ] ifFalse:[ model name ] ]
        argument:resultHolder

    "Created: / 15-03-2010 / 14:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2010 / 20:17:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-08-2011 / 18:20:38 / cg"
!

resultTextForegroundColorAspect
    <resource: #uiAspect>

    ^ BlockValue 
        with:[:bgColor | 
            bgColor brightness > 0.6 ifTrue:[
                Color black
            ] ifFalse:[
                Color white
            ].
        ]
        argument:self resultBackgroundColorAspect
!

runAllEnabledHolder

    ^ self notRunningHolder

    "Created: / 07-09-2010 / 09:15:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 18:40:46 / cg"
!

runEnabledHolder
    ^BlockValue
        with:
            [:result :running | 

            running not
            and:[ result notNil 
            and:[ result testCount > 0 ]]
        ]
        argument: self resultHolder
        argument: self runningHolder

    "Created: / 07-09-2010 / 09:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 16:54:29 / cg"
!

runFailedEnabledHolder
    ^BlockValue
        with:
            [:running | 

            |result|

            running not
            and:[ TestResult notNil 
            and:[ TestResult isLoaded
            and:[ result := self resultForSuite:self suiteForRunAll. result notNil 
            and:[ result hasFailuresOrErrors ]]]]
        ]
        "/ argument: self resultHolder
        argument: self runningHolder

    "Created: / 07-09-2010 / 09:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 04-06-2012 / 18:28:12 / cg"
    "Modified: / 18-07-2012 / 09:55:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runningHolder
    runningHolder isNil ifTrue:[
        runningHolder := ValueHolder with: false.
    ].
    ^ runningHolder

    "Modified: / 15-03-2010 / 20:29:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-06-2012 / 18:38:52 / cg"
!

stopEnabledHolder
    ^ self runningHolder

    "Created: / 04-06-2012 / 18:29:01 / cg"
! !

!TestRunnerMini methodsFor:'aspects-visibility'!

pinButtonVisibleHolder
    ^ false

    "Created: / 23-09-2014 / 10:11:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runAllButtonVisibleHolder
    ^ false

    "Created: / 23-09-2014 / 10:12:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCoverageEnabledHolder
    ^ false

    "Created: / 17-11-2017 / 11:47:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runFailedButtonVisibleHolder
    ^ false

    "Created: / 23-09-2014 / 10:12:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini methodsFor:'change & update'!

invalidateSuiteAndResult
    resultHolder value:nil.
!

update:aspect with:param from:sender

    sender == Smalltalk ifTrue:[
            aspect == #lastTestRunResult ifTrue:[
                allTestCases notNil ifTrue:[
                    (allTestCases includesIdentical: param first) ifTrue:[
                        self invalidateSuiteAndResult. "/ updateTestSuiteAndResult.
                        self enqueueDelayedAction:[ self updateSuiteAndResult ].
                        ^self        
                    ]
                ].
            ]        
        ].
    super update:aspect with:param from:sender

    "Modified: / 23-09-2014 / 10:23:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSuiteAndResult
    | suite suiteAndResult |

    self runningHolder value ifTrue:[^self].
    self allTestCases isEmptyOrNil ifTrue:[^self].

    suite := self suiteForRun.
    suiteAndResult := SuiteAndResult
                        suite:  suite
                        result: (self resultForSuite: suite).
    resultHolder value: suiteAndResult.

    "Created: / 15-03-2010 / 19:41:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2010 / 20:55:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 19:03:15 / cg"
!

updateTestCases
    "/ Nothing to do here

    "Created: / 23-09-2014 / 12:02:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateTestSuiteAndResult
    | suite suiteAndResult |

    self runningHolder value ifTrue:[^self].
    allTestCases isEmptyOrNil ifTrue:[^self].
    suiteAndResult := SuiteAndResult
                        suite:  (suite := self suiteForRun)
                        result: (self resultForSuite: suite).
    resultHolder value: suiteAndResult.

    "Created: / 15-03-2010 / 19:41:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2010 / 20:55:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 19:03:15 / cg"
!

updateVisibility
    "/ cg: now done by embedder via a valueHolder on the visibility
    ^ self.
"/    self hasTestCaseSelected 
"/        ifTrue:[self show]
"/        ifFalse:[self hide]

    "Created: / 11-03-2010 / 09:02:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini methodsFor:'hooks'!

commonPostOpen

    Smalltalk addDependent: self.

    "Created: / 17-11-2011 / 20:59:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildRunnerPanel: aView

    runnerPanel := aView.
    runnerPanel backgroundColor: self resultBackgroundColorAspect value

    "Created: / 15-03-2010 / 14:26:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release

    Smalltalk removeDependent: self.

    "Created: / 23-09-2014 / 10:22:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releaseAsSubCanvas

    Smalltalk removeDependent: self.

    "Created: / 17-11-2011 / 21:03:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini methodsFor:'initialization'!

initialize
    super initialize.
    resultHolder := ValueHolder new.
! !

!TestRunnerMini methodsFor:'private'!

isTestCaseLike:cls 

    ^(super isTestCaseLike: cls) and:
        [(cls askFor: #isAbstract) not]

    "Modified: / 04-03-2011 / 06:54:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildProgressIndicator:aWidget
    progressIndicator := aWidget
! !

!TestRunnerMini methodsFor:'queries'!

hasTestCaseSelected

    ^self allTestCases notEmptyOrNil

    "Created: / 11-03-2010 / 09:06:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2010 / 20:54:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 20:42:10 / cg"
! !

!TestRunnerMini methodsFor:'utilities'!

resultForSuite:suite 
    |result|

    result := TestResult defaultResultClass new.
    suite isNil ifTrue:[ ^ result ].
    suite tests do:[:test |
        | sel cls |

        sel := test selector.
        cls := test class.
        (cls testSelectorPassed:sel) ifTrue:[
            result passedOutcomes add: (cls asTestCase rememberedOutcomeFor: sel)
        ] ifFalse:[
            (cls testSelectorError:sel) ifTrue:[
                result errorOutcomes add:(cls rememberedOutcomeFor: sel)
            ] ifFalse:[
                (cls testSelectorFailed:sel) ifTrue:[
                    result failureOutcomes add:(cls rememberedOutcomeFor: sel)
                ]
            ]
        ]
    ].
    ^ result

    "Created: / 15-03-2010 / 19:46:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 16:43:39 / cg"
    "Modified: / 26-07-2016 / 23:32:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suiteForRun
    |result|

    (result := resultHolder value) isNil ifTrue:[^ nil].

    ^ result suiteForRun

    "Modified: / 23-09-2014 / 12:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suiteForRunAll
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self suiteForRun

    "Modified: / 23-09-2014 / 12:07:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suiteForRunFailed
    |suite numTests|

    suite := TestSuite named:(self suiteNameFromClasses: self allTestCases).
    numTests := 0.

    self suiteForRunAll tests do:[:eachTest |
        | sel cls |

        sel := eachTest selector.
        cls := eachTest class.
        (cls testSelectorPassed:sel) ifFalse:[
            suite addTest:eachTest.
            numTests := numTests + 1.
        ]
    ].

    numTests == 1 ifTrue:[
        suite name:(suite tests first selector)
    ] ifFalse:[
        suite name:(suite tests size printString,' tests')
    ].
    ^suite

    "Modified: / 23-09-2014 / 12:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini::SuiteAndResult class methodsFor:'instance creation'!

suite: suite result: result

    ^self new
        suite: suite;
        result: result.

    "Modified: / 15-03-2010 / 15:27:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini::SuiteAndResult methodsFor:'accessing'!

color
    |numTests numRun|

    self testCount > 0 ifTrue:[
        result notNil ifTrue:[
            self hasErrors ifTrue:[^AbstractTestRunner errorColor].
            self hasFailures ifTrue:[^AbstractTestRunner failedColor].
            self hasPassed ifTrue:[
                numTests := suite tests size.
                numRun := result passedCount + result skippedCount.
                numRun = numTests ifTrue:[
                    ^AbstractTestRunner passedColor 
                ]
            ].
            self hasSkipped ifTrue:[^AbstractTestRunner notRunColor]. 
        ]
    ].
    ^ AbstractTestRunner notRunColor

    "Created: / 15-03-2010 / 15:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-06-2018 / 22:15:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

info
    |numTests numPassed numFailed numRun resources numError numSkipped |

    result isNil ifTrue:[^''].

    numTests := suite tests size.
    numPassed := result passedCount.
    numFailed := result failureCount.
    numError := result errorCount.
    numSkipped := result skippedCount.
    numRun := numPassed + numFailed + numError + numSkipped.
    "/ (result passedCount + result failureCount + result errorCount) = 1 ifTrue:[^''].
    resources := TestRunnerMini resources.
    numRun == 0 ifTrue:[
        numTests == 1 ifTrue:[
            ^(resources string: 'not run')
        ].
        ^(resources string: '%1 tests, 0 run') bindWith: numTests
    ].
    ^ String streamContents:[ :s |
        "/ 'X tests'...
        numTests printOn: s. s space; nextPutAll: (resources string: 'tests').
        numRun < numTests ifTrue:[
            "/ ', %2 run'...
            s nextPut: $,. numRun printOn: s. s space; nextPutAll: (resources string: 'run').
        ].
        numPassed > 0 ifTrue:[ 
            "/ ', %3 passed'...
            s nextPut: $,. numPassed printOn: s. s space; nextPutAll: (resources string: 'passed').
        ].
        numFailed > 0 ifTrue:[ 
            "/ ', %4 failed'...
            s nextPut: $,. numFailed printOn: s. s space; nextPutAll: (resources string: 'failed').
        ].
        numError > 0 ifTrue:[ 
            "/ ', %5 errors'...
            s nextPut: $,. numError printOn: s. s space; nextPutAll: (resources string: (numError > 1 ifTrue:[ 'errors' ] ifFalse:[ 'error' ])).
        ].
        numSkipped > 0 ifTrue:[ 
            "/ ', %4 failed'...
            s nextPut: $,. numSkipped printOn: s. s space; nextPutAll: (resources string: 'skipped').
        ].
    ].

    "Created: / 15-03-2010 / 20:23:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 12:25:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    ^suite name

    "Created: / 15-03-2010 / 15:12:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

result
    ^ result
!

result:aTestResult
    result := aTestResult.
!

suite
    ^ suite
!

suite:aTestSuite
    suite := aTestSuite.
!

suiteForRun

    | suiteForRun |
    suiteForRun := suite class named: suite name.
    suiteForRun addTests:
        (suite tests collect:[:testCase|testCase class selector: testCase selector]).
    ^suiteForRun

    "Created: / 22-08-2011 / 09:56:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCount

    ^suite tests size

    "Created: / 15-03-2010 / 15:44:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerMini::SuiteAndResult methodsFor:'queries'!

hasErrors

    ^result errorCount > 0

    "Created: / 15-03-2010 / 15:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFailures

    ^result failureCount > 0

    "Created: / 15-03-2010 / 15:21:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFailuresOrErrors

    ^self hasErrors or:[self hasFailures]

    "Created: / 15-03-2010 / 15:45:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasPassed

    ^result passedCount > 0

    "Created: / 15-03-2010 / 22:06:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSkipped

    ^result skippedCount > 0
! !

!TestRunnerMini class methodsFor:'documentation'!

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

