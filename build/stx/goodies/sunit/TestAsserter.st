"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TestAsserter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Base'
!

TestAsserter comment:''
!


!TestAsserter class methodsFor:'asserting'!

assert: aBoolean description: aString
	"Minimal clone of the instance-side assert protocol so that class-side methods can use it."

	aBoolean ifFalse:
		[self logFailure: aString.
		TestResult failure sunitSignalWith: aString].
! !

!TestAsserter class methodsFor:'logging'!

failureLog
	^SUnitNameResolver defaultLogDevice
!

isLogging
	"By default, we're not logging failures. Override in subclasses as desired."

	^false
!

logFailure: aString
	self isLogging ifTrue:
		[self failureLog cr; nextPutAll: aString; flush].
!

logSkipped: aString
        self isLogging ifTrue:
                [self failureLog cr; nextPutAll: aString; flush].
! !

!TestAsserter methodsFor:'asserting'!

assert: aBoolean
    "fail the testcase if aBoolean is false"

    <resource: #skipInDebuggersWalkBack>

    aBoolean ifFalse:
        [self logFailure: 'Assertion failed'.
        TestResult failure sunitSignalWith: 'Assertion failed'].

    "Modified: / 05-12-2009 / 18:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assert:aBoolean description:aString
    "fail the testCase if aBoolean is false, 
     and report aString as failure-description."

    <resource: #skipInDebuggersWalkBack>

    ^self assert:aBoolean description:aString resumable: false.

    "Modified: / 06-08-2006 / 22:56:27 / cg"
    "Modified: / 11-09-2010 / 15:34:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assert: aBoolean description: aString resumable: resumableBoolean

    <resource: #skipInDebuggersWalkBack>
    | exception |
    aBoolean ifFalse:
	[self logFailure: aString.
		exception := resumableBoolean
			ifTrue: [TestResult resumableFailure]
			ifFalse: [TestResult failure].
		exception sunitSignalWith: aString].

    "Modified: / 05-12-2009 / 18:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deny: aBoolean
    "fail the testcase if aBoolean is true"

    <resource: #skipInDebuggersWalkBack>

    self assert: aBoolean not.

    "Modified: / 05-12-2009 / 18:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deny: aBoolean description: aString
    "fail the testCase if aBoolean is true, 
     and report aString as failure-description."

    <resource: #skipInDebuggersWalkBack>

    self assert: aBoolean not description: aString.

    "Modified: / 05-12-2009 / 18:17:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deny: aBoolean description: aString resumable: resumableBoolean

    <resource: #skipInDebuggersWalkBack>

    self assert: aBoolean not description: aString resumable: resumableBoolean.

    "Modified: / 05-12-2009 / 18:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

should: aBlock raise: anExceptionalEvent
    "during the execution of aBlock, the anExceptionalEvent should be raised"

    <resource: #skipInDebuggersWalkBack>

    self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent).

    "Modified: / 05-12-2009 / 18:18:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

should: aBlock raise: anExceptionalEvent description: aString
    "during the execution of aBlock, the anExceptionalEvent should be raised.
     If not, report aString as failure-description."

    <resource: #skipInDebuggersWalkBack>

    self
        assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
        description: aString.

    "Modified: / 05-12-2009 / 18:18:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

should: aBlock raise: anExceptionalEvent suchThat: condBlock
    "during the execution of aBlock, the anExceptionalEvent should be raised,
     and condBlock should return true on the exception instance"

    <resource: #skipInDebuggersWalkBack>

    self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent suchThat: condBlock).

    "Created: / 05-05-2011 / 20:14:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

should: aBlock raise: anExceptionalEvent suchThat: condBlock description: description
    "during the execution of aBlock, the anExceptionalEvent should be raised,
     and condBlock should return true on the exception instance.
     If not, report aString as failure-description."

    <resource: #skipInDebuggersWalkBack>

    self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent suchThat: condBlock)
         description: description

    "Created: / 05-05-2011 / 20:14:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

should: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: aStringFragment
    "during the execution of aBlock, the anExceptionalEvent should be raised,
     and aStringFragment should be contained in the exception-instances description."

    <resource: #skipInDebuggersWalkBack>

    ^ self should: aBlock 
           raise: anExceptionalEvent
           suchThat:[:ex | ex description includesString: aStringFragment]
!

should:aBlock raise:anExceptionalEvent whoseDescriptionIncludes:aStringFragment description:aString
    "during the execution of aBlock, the anExceptionalEvent should be raised,
     and aStringFragment should be contained in the exception-instances description.
     If not, report aString as failure-description."

    <resource: #skipInDebuggersWalkBack>

    ^ self should: aBlock 
           raise: anExceptionalEvent
           suchThat:[:ex | ex description includesString: aStringFragment]
           description: aString.
!

shouldnt: aBlock raise: anExceptionalEvent
    "during the execution of aBlock, the anExceptionalEvent should NOT be raised"

    <resource: #skipInDebuggersWalkBack>

    self
        assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not.

    "Modified: / 05-12-2009 / 18:18:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldnt: aBlock raise: anExceptionalEvent description: aString
    "during the execution of aBlock, the anExceptionalEvent should NOT be raised.
     If not, report aString as failure-description."

    <resource: #skipInDebuggersWalkBack>

    self
        assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
        description: aString.

    "Modified: / 05-12-2009 / 18:18:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skip
    "skip this test"
    
    self skipIf:true description:'Test Skipped'.
!

skip:aString
    "skip this test"
    
    self skipIf:true description:aString
!

skipIf:aCondition description:aString
    "skip this test, if some condition is met"
    
    aCondition value ifTrue: [
        self logSkipped: 'Skipped - ',aString.
        TestResult skipped sunitSignalWith: aString
    ].
! !

!TestAsserter methodsFor:'convenience'!

assert: anObject equals: anotherObject
	self assert: anObject = anotherObject
		description: anObject printString, ' is not equal to ', anotherObject printString.
! !

!TestAsserter methodsFor:'logging'!

logFailure: aString
	self class logFailure: aString.
!

logSkipped: aString
        self class logSkipped: aString.
! !

!TestAsserter methodsFor:'private'!

executeShould: execBlock inScopeOf: exceptionalEvent

    <resource: #skipInDebuggersWalkBack>

    ^ self
	executeShould: execBlock
	inScopeOf: exceptionalEvent
	suchThat: [:ex | true ]

    "Modified: / 05-05-2011 / 20:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeShould: execBlock inScopeOf: exceptionalEvent suchThat: conditionBlock
	^[execBlock value.
	false]
		sunitOn: exceptionalEvent
		do:
		    [:ex |
		    ex sunitExitWith:(conditionBlock value: ex)]

    "Created: / 05-05-2011 / 20:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestAsserter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

