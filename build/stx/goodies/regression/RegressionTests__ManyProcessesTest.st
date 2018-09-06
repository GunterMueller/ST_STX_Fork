"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

nil subclass:#ManyProcessesTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!ManyProcessesTest class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!ManyProcessesTest methodsFor:'test'!

start:count
"
ManyProcessesTest new test400
"
    |waitSema|

    waitSema := Semaphore new.
    waitSema setCount:(1 - count).

    count timesRepeat:[
	[ [Delay waitForSeconds:0.4.] ensure:[waitSema signal].
	] forkAt:(Processor userBackgroundPriority)
    ].
    waitSema wait.
!

test400
    "
     self new test400
    "
    |waitSema repeat|

    repeat := 4.

    'Makefile' asFilename readStream close.

    waitSema := Semaphore new.
    waitSema setCount:(1 - repeat).

    repeat timesRepeat:[
	[ [self start:100] ensure:[waitSema signal]
	] forkAt:8.
    ].
    waitSema wait.
    Transcript showCR:'done'.
! !

!ManyProcessesTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

