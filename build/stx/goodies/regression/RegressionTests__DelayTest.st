"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
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

TestCase subclass:#DelayTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!DelayTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
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

!DelayTest class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!DelayTest class methodsFor:'queries'!

coveredClasses
    ^ Array with:Delay

    "Created: / 05-07-2011 / 09:51:28 / cg"
! !

!DelayTest methodsFor:'tests'!

test1
    |n verbose|

    self skipIf: (OperatingSystem getEnvironment:'JOB_NAME') notNil description: 'This test depends on real time timing and thus unreliable under CI setups'.

    verbose := false.

    [
        n := 0.
        [n < 10] whileTrue:[
           Delay waitForSeconds:0.1.
           verbose ifTrue:[ Transcript showCR:n ].
           n := n + 1.
        ]
    ] forkAt:(Processor activePriority - 1).

    self assert:(n == nil).     "because the process has lower prio and should not run"

    Delay waitForSeconds:0.05.

    self assert:(n == 0).       "because I should have interrupted the process"

    Delay waitForSeconds:1.5.

    self assert:(n == 10).      "because process should be complete now"

    "
     self basicNew test1
    "

    "Modified: / 10-01-2012 / 19:25:22 / cg"
    "Modified: / 26-07-2017 / 11:49:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test2
    |n verbose|

    self skipIf: (OperatingSystem getEnvironment:'JOB_NAME') notNil description: 'This test depends on real time timing and thus unreliable under CI setups'.

    verbose := false.
    n := 0.
    [
        [n < 10] whileTrue:[
           Delay waitForSeconds:0.1.
           verbose ifTrue:[ Transcript showCR:n ].
           n := n + 1.
        ]
    ] forkAt:(Processor activePriority + 1).

    self assert:(n == 0) description:'thread with delays should not have started yet'.
    Delay waitForSeconds:1.1.
    self assert:(n == 10) description:('thread with delays should have finished by now (n=%d)' bindWith:n).

    "
     self basicNew test2
    "

    "Modified: / 10-01-2012 / 19:25:35 / cg"
    "Modified: / 26-07-2017 / 11:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test3_longDelay
    "in stx6.2.1, the following does not wait, due to an overflow in
     the millisecond computation..."

    |stillWaiting watchDogBite|

    self skipIf: (OperatingSystem getEnvironment:'JOB_NAME') notNil description: 'This test depends on real time timing and thus unreliable under CI setups'.

    [
        watchDogBite := false.
        stillWaiting := true.
        Delay waitForSeconds:1000000.
        stillWaiting := false.
    ] valueWithWatchDog:[ watchDogBite := true] afterMilliseconds:1000.

    self assert:stillWaiting.
    self assert:watchDogBite.

    "
     self basicNew test3_longDelay
    "

    "Created: / 31-07-2011 / 18:44:53 / cg"
    "Modified: / 26-07-2017 / 11:49:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test4
    "check that we can wake up early"

    |longDelay waitTime watchDogBite|

    self skipIf: (OperatingSystem getEnvironment:'JOB_NAME') notNil description: 'This test depends on real time timing and thus unreliable under CI setups'.

    longDelay := Delay forSeconds:1000000.
    [
        Delay waitForSeconds:2.
        longDelay resume.
    ] fork.

    waitTime := Time secondsToRun:[
        "never wait longer than 10 seconds"
        [
            longDelay wait.
        ] valueWithWatchDog:[ watchDogBite := true] afterMilliseconds:10000.
    ].
    self assert:watchDogBite ~~ true.
    self assert:waitTime < 10.

    "
     self basicNew test4
    "

    "Modified: / 26-07-2017 / 11:49:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DelayTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

