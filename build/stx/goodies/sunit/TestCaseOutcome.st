"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TestCaseOutcome
	instanceVariableNames:'testCase result properties'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Base'
!

!TestCaseOutcome class methodsFor:'documentation'!

documentation
"
    will keep additional info for a testCase run:
        startTime, endTime,
        backtrace (if fail or error)
        and collectedStdout
"
! !

!TestCaseOutcome class methodsFor:'instance creation'!

forCase: aTestCase

    ^self new testCase: aTestCase; yourself

    "Created: / 16-08-2011 / 15:24:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCaseOutcome methodsFor:'accessing'!

collectedOutput

    ^self propertyAt: #collectedOutput

    "Modified: / 16-08-2011 / 15:27:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 16-08-2011 / 18:19:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

collectedOutput: aString

    ^self propertyAt: #collectedOutput put: aString

    "Modified: / 16-08-2011 / 15:28:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 16-08-2011 / 18:19:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endTime

    ^self propertyAt: #endTime

    "Modified: / 16-08-2011 / 15:28:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endTime: anObject

    ^self propertyAt: #endTime put: anObject

    "Modified: / 16-08-2011 / 15:28:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptionDetail

    ^self propertyAt: #exceptionDetail

    "Modified: / 16-08-2011 / 15:29:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptionDetail: anObject

    ^self propertyAt: #exceptionDetail put: anObject

    "Modified: / 16-08-2011 / 15:29:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executionTime
    "the execution time in millis; nil if not yet executed"

    |startTime endTime|

    (startTime := self startTime) isNil ifTrue:[
        "/ not yet executed
        ^ nil
    ].
    (endTime := self endTime) isNil ifTrue:[
        "/ assume it is still running...
        endTime := Timestamp now
    ].
    ^ (endTime millisecondDeltaFrom:startTime)

    "Modified (format): / 18-08-2011 / 21:02:28 / cg"
!

propertyAt: aSymbol

    ^ self propertyAt: aSymbol ifAbsent: [nil]

    "Created: / 16-08-2011 / 15:26:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-08-2011 / 21:03:01 / cg"
!

propertyAt: aSymbol ifAbsent: aBlock

    properties isNil ifTrue: [^aBlock value].
    ^properties at: aSymbol ifAbsent:aBlock.

    "Created: / 16-08-2011 / 15:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: aSymbol put: anObject

    properties isNil ifTrue: [properties := Dictionary new].
    properties at: aSymbol put: anObject.

    "Created: / 16-08-2011 / 15:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

result
    ^ result
!

result:aSymbol
    ((aSymbol ~= TestResult statePass) 
    and:[ aSymbol ~= TestResult stateFail 
    and:[ aSymbol ~= TestResult stateError
    and:[ aSymbol ~= TestResult stateSkip ]]]) ifTrue:[
        self error:'invalid result'.
    ].
    result := aSymbol.

    "Modified: / 20-08-2011 / 12:52:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector

    ^testCase selector

    "Created: / 16-08-2011 / 15:38:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startTime

    ^self propertyAt: #startTime

    "Modified: / 16-08-2011 / 15:29:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startTime: anObject

    ^self propertyAt: #startTime put: anObject

    "Modified: / 16-08-2011 / 15:29:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCase
    ^ testCase
!

testCase:something
    testCase := something.
! !

!TestCaseOutcome methodsFor:'comparing'!

= anotherOutcome
    |myTestCase otherTestCase|

    ^(anotherOutcome isKindOf: self class) 
        and:[(myTestCase := self testCase) class == (otherTestCase := anotherOutcome testCase) class
            and:[myTestCase selector == otherTestCase selector]].

    "Created: / 20-08-2011 / 14:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^testCase hash bitXor: result hash

    "Created: / 20-08-2011 / 14:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCaseOutcome methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    testCase printOn: aStream.
    aStream nextPut:$).

    "Modified: / 17-07-2013 / 17:59:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCaseOutcome methodsFor:'remembering'!

remember

    ^testCase class rememberOutcome: self.

    "Created: / 20-08-2011 / 12:45:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCaseOutcome class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

