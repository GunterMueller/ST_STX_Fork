"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ProcessTest
	instanceVariableNames:'subProcesses'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!ProcessTest methodsFor:'test'!

tearDown

    subProcesses notEmptyOrNil ifTrue:[
	subProcesses do:[:aProcess|
	    aProcess terminate.
	].
    ].

    "Modified: / 19-09-2014 / 13:27:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testMaxProcessId
    "This test makes sure a process id never exeeds MaxProcessId."

    | blocker lastId maxId iters |


    self
	skipIf: Processor maxProcessId > 500000
	description: 'Processor maxProcessId is huge, would take really a long time'.

    blocker := Semaphore new.
    lastId := Processor activeProcess id.
    maxId := Processor maxProcessId.

    iters := 0.
    [ lastId ~~ maxId ] whileTrue:[
	[ lastId := Processor activeProcess id. blocker signal ] fork.
	blocker wait.
	iters := iters + 1.
	iters > maxId ifTrue:[
	    "/ OK, we tried long enough. The system is probably already
	    "/ reusing Process id's so it may never reach maxId.
	    ^ self.
	].
    ].
    "/ OK, we reached the limit. Try once again to spawn a new
    "/ thread and assert its id is smaller then the limit.
    [ lastId := Processor activeProcess id. blocker signal ] fork.
    blocker wait.

    self assert: lastId < maxId.

    "Created: / 19-09-2014 / 12:50:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 19-09-2014 / 14:06:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTerminateWithAllSubProcesses

    | block masterTask allProcesses|

    subProcesses := OrderedCollection new.
    block := [
	1 to:10 do:[:index|
	    |subTask|
	    subTask := [[true] whileTrue:[]] newProcess.
	    subTask name:'TestTask no:', index asString.
	    subTask priority:4.
	    subProcesses add:subTask.
	    subTask resume.
	].
	[true] whileTrue:[Delay waitForSeconds:10].
    ].

    masterTask := block newProcess.
    masterTask beGroupLeader.
    masterTask priority:8.
    masterTask name:'masterTask'.
    masterTask resume.

    Delay waitForSeconds:0.5.

    masterTask terminateWithAllSubprocessesInGroup.
    masterTask waitUntilTerminated.

    Delay waitForSeconds:1.
    allProcesses := ProcessorScheduler knownProcesses asOrderedCollection select:[:p | p isDead not].
    subProcesses do:[:aProcess|
	self should:((allProcesses includes:aProcess) not).
    ].

    "
     self new testTerminateWithAllSubProcesses
    "
! !

!ProcessTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

