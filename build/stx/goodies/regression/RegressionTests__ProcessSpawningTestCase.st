"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ProcessSpawningTestCase
	instanceVariableNames:'process threads threadsBlocker failureSignaller failure'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Abstract'
!

!ProcessSpawningTestCase class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ProcessSpawningTestCase methodsFor:'private'!

performTest
    | blocker |

    self assert: threadsBlocker notNil.
    self assert: failureSignaller notNil.

    blocker := SemaphoreSet with: threadsBlocker with: failureSignaller.
    super performTest.
    blocker wait.


    failure notNil ifTrue:[
        (failure value isKindOf: TestResult failure) ifTrue:[ 
            self assert: false description: (failure value description , ' in ', failure key printString)
        ] ifFalse:[ 
            self error: (failure value description , ' in ', failure key printString)
        ].
    ]

    "Created: / 28-08-2017 / 12:18:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2017 / 20:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProcessSpawningTestCase methodsFor:'running'!

setUp
    Smalltalk addDependent: self.      
    process := Processor activeProcess.
    threads := Set new.
    threadsBlocker := (Semaphore new:1) name: 'threadsBlocker for ', self printString.
    failureSignaller := (Semaphore new) name: 'failureSignaller for ', self printString. 

    MessageTracer mock: #newProcess in: Block do: [ :receiver :method |
        | process |

        process := method valueWithReceiver: receiver arguments: #().
        process addExitAction:[ threadsBlocker notNil ifTrue:[ threadsBlocker signal ] ].
        process emergencySignalHandler:[ :ex | failure := process -> ex parameter. failureSignaller notNil ifTrue:[ failureSignaller signal ] ].
        threadsBlocker setCount: threadsBlocker count - 1.
        process.    
    ].

    "
    ThreadSpawningTestCase debug: #TEST_02.
    "

    "Created: / 28-08-2017 / 10:08:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2017 / 20:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    MessageTracer unmock: #newProcess in: Block.
    process := nil.
    threadsBlocker := nil.
    failureSignaller := nil.
    threads do:[:thread | 
        thread isDead ifFalse:[ thread terminate ]
    ].

    "Created: / 28-08-2017 / 11:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2017 / 20:32:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProcessSpawningTestCase methodsFor:'tests - infrastructure'!

TEST_error
    [ 
        self perform: #quz
    ] fork

    "
    ProcessSpawningTestCase debug: #TEST_error
    "

    "Created: / 28-08-2017 / 20:41:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

TEST_failure
    [ 
        self assert: false.
    ] fork

    "
    ProcessSpawningTestCase debug: #TEST_failure
    "

    "Created: / 28-08-2017 / 20:40:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

TEST_pass
    [ 
        self assert: true.
    ] fork

    "
    ProcessSpawningTestCase debug: #TEST_pass
    "

    "Created: / 28-08-2017 / 20:40:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_infrastructre
    | result |

    result := (ProcessSpawningTestCase selector:#'TEST_pass') run.
    self assert:result passedCount == 1.     
    self assert:result failureCount == 0.     
    self assert:result errorCount == 0.     

    result := (ProcessSpawningTestCase selector:#'TEST_failure') run.
    self assert:result passedCount == 0.     
    self assert:result failureCount == 1.     
    self assert:result errorCount == 0.     

    result := (ProcessSpawningTestCase selector:#'TEST_error') run.
    self assert:result passedCount == 0.     
    self assert:result failureCount == 0.     
    self assert:result errorCount == 1.     
    
    "
    ProcessSpawningTestCase run: #test_infrastructre
    ProcessSpawningTestCase debug: #test_infrastructre
    "

    "Created: / 28-08-2017 / 20:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

