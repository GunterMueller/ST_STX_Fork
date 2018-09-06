"{ Package: 'stx:libbasic3/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#MessageTracerTests
	instanceVariableNames:'methods'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Debugging-Support-Tests'
!


!MessageTracerTests methodsFor:'change & update'!

update: aspect with: param from: sender
    aspect == #methodTrap ifTrue:[
        methods add: (param changeClass >> param changeSelector)
    ].

    "Created: / 28-08-2017 / 17:45:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageTracerTests methodsFor:'private'!

add: x to: y
    ^ x + y

    "Created: / 28-08-2017 / 15:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageTracerTests methodsFor:'running'!

setUp
    Smalltalk addDependent: self.
    methods := Set new.

    "Created: / 28-08-2017 / 17:41:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    Smalltalk removeDependent: self.
    methods do:[:method | MessageTracer unwrapMethod: method ]

    "Created: / 28-08-2017 / 16:01:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2017 / 17:42:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageTracerTests methodsFor:'tests - mocking'!

test_mock_01a
    
    self assert: (self add: 1 to: 1) == 2.
    MessageTracer mock: #add:to: in: self class do: [ 0 ].
    self assert: (self add: 1 to: 1) == 0.

    "Created: / 28-08-2017 / 16:02:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_mock_01b
    
    self assert: (self add: 1 to: 1) == 2.
    MessageTracer mock: #add:to: in: self class do: [ :r :x :y | r ].
    self assert: (self add: 1 to: 1) == self.

    "Created: / 28-08-2017 / 16:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_mock_01c
    
    self assert: (self add: 1 to: 1) == 2.
    MessageTracer mock: #add:to: in: self class do: [ :r :x :y | x - y ].
    self assert: (self add: 1 to: 2) == -1.

    "Created: / 28-08-2017 / 16:04:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_mock_01d
    
    self assert: (self add: 1 to: 1) == 2.
    MessageTracer mock: #add:to: in: self class do: [ :r :x :y :m | (m valueWithReceiver: r arguments: { x . y }) + 10 ].
    self assert: (self add: 1 to: 3) == 14.

    "Created: / 28-08-2017 / 16:05:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_mock_02a
    | blocker value |
    
    self assert: (self add: 1 to: 1) == 2.

    MessageTracer mock: #add:to: in: self class do:[ 0 ].
    blocker := Semaphore new: 0.
    [ 
        value := self add: 10 to: -5.
        blocker signal.
    ] fork.
    blocker wait.
    self assert: value == 0.

    "Created: / 28-08-2017 / 16:08:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_mock_02b
    | blocker1 blocker2 value |
    
    self assert: (self add: 1 to: 1) == 2.

    MessageTracer mock: #add:to: in: self class do:[ 0 ].
    blocker1 := Semaphore new: 0.
    [ 
        blocker2 := Semaphore new: 0.
        [
            value := self add: 10 to: -5.
            blocker2 signal.
        ] fork.
        blocker2 wait.
        blocker1 signal.
    ] fork.
    blocker1 wait.
    self assert: value == 0.

    "Created: / 28-08-2017 / 16:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_mock_03a
    | blocker1 blocker2 threads |
    

    threads := Set new.    

    MessageTracer mock: #newProcess in: Block do:[:r :m |
        | p |

        p := m valueWithReceiver: r arguments: #().
        threads add: p.
        p
    ].
    ObjectMemory flushCaches.
    blocker1 := Semaphore new: 0.
    [ 
        blocker2 := Semaphore new: 0.
        [
            blocker2 signal.
        ] fork.
        blocker2 wait.
        blocker1 signal.
    ] fork.
    blocker1 wait.
    self assert: threads size == 2.

    "Created: / 28-08-2017 / 16:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageTracerTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

