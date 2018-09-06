"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SemaphoreTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!SemaphoreTest methodsFor:'tests'!

testSpeed01
    |s t|

    s := Semaphore forMutualExclusion.
    t := Time millisecondsToRun:[
       1000000 timesRepeat:[ s critical:[1+1] ]
    ].
    Transcript showCR:t

    "
     self run:#testSpeed01
    "
! !

!SemaphoreTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

