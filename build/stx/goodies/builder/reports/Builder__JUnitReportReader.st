"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

XML::SAXDriver subclass:#JUnitReportReader
	instanceVariableNames:'currentTestResult currentOutcome'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Readers'
!


!JUnitReportReader class methodsFor:'reading'!

readFromFile: aStringOrFilename
    ^ self readFromStream: aStringOrFilename asFilename readStream

    "Created: / 12-03-2015 / 17:27:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFromStream: aStream
    ^ (self on: aStream beforeScanDo:[:parse| parse validate:false]) testResult

    "Created: / 12-03-2015 / 17:27:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitReportReader methodsFor:'accessing'!

testResult
    ^ currentTestResult

    "Created: / 12-03-2015 / 17:41:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitReportReader methodsFor:'content handler'!

endElement: localName namespace: nameSpace prefix: nameSpacePrefix
    localName = 'testcase' ifTrue:[ 
        currentOutcome result == TestResult statePass ifTrue:[ 
            currentTestResult passedOutcomes add: currentOutcome
        ] ifFalse:[ 
        currentOutcome result == TestResult stateFail ifTrue:[ 
            currentTestResult failureOutcomes add: currentOutcome
        ] ifFalse:[  
        currentOutcome result == TestResult stateError ifTrue:[ 
            currentTestResult errorOutcomes add: currentOutcome
        ] ifFalse:[ 
            self error: 'No result for current outcome!!'
        ]]].
    ].

    "Created: / 12-03-2015 / 17:24:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-03-2015 / 18:25:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startDocument
    currentTestResult :=TestResult new.

    "Created: / 12-03-2015 / 17:24:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startElement: localName namespace: namespace prefix: nameSpacePrefix attributes: attributes
    localName = 'testcase' ifTrue:[ 
        | classname name |

        classname := (attributes detect:[:e | e tag type = 'classname' ]) value.
             name := (attributes detect:[:e | e tag type = 'name' ]) value.

        currentOutcome := TestCaseOutcome forCase: (self testCaseForClassName: classname selector: name).
        currentOutcome result: TestResult statePass.
    ].
    localName = 'error' ifTrue:[ 
        currentOutcome result: TestResult stateError
    ].
    localName = 'failure' ifTrue:[ 
        currentOutcome result: TestResult stateFail
    ]

    "Created: / 12-03-2015 / 17:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitReportReader methodsFor:'private'!

testCaseForClassName:className selector:selector
    "/ Fake for now...
    ^ MessageSend receiver: className selector: selector

    "Created: / 12-03-2015 / 17:43:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitReportReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

