"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#OperationInQueueTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!OperationInQueueTests methodsFor:'tests'!

test1
    |op opQ rslt|

    opQ := OperationQueue new.

    op := [ 1 + 2 ].

    rslt := opQ scheduleOperation:op.

    self assert:(rslt == 3)
!

test2
    |op opQ rslt|

    opQ := OperationQueue new.

    op := 1.

    rslt := opQ scheduleOperation:op.

    self assert:(rslt == 1)
!

test3
    |op opQ val1 val2 val3 val1b val2b val3b
     rslt rslt1 rslt2 rslt3 p0 p1 p2 p3 rslt1b rslt2b rslt3b p1b p2b p3b sz|

    opQ := OperationQueue new.
    opQ consumerProcessPriority:8.

    op := '1'.
    rslt := opQ scheduleOperation:op.

    self assert:(rslt = '1').

    self assert:(opQ size == 0).

    p0 := [
	opQ scheduleOperation:[ Delay waitForSeconds:1.].
    ] fork.

    p1 := [
	rslt1 := opQ scheduleOperation:(val1 := '1').
    ] fork.

    p2 := [
	rslt2 := opQ scheduleOperation:(val2 := '2').
    ] fork.

    p3 := [
	rslt3 := opQ scheduleOperation:(val3 := '3').
    ] fork.

    Delay waitForSeconds:0.2.
    self assert:((sz := opQ size) == 3).

    p1b := [
	rslt1b := opQ scheduleOperation:(val1b := '1').
    ] fork.

    p2b := [
	rslt2b := opQ scheduleOperation:(val2b := '2').
    ] fork.

    p3b := [
	rslt3b := opQ scheduleOperation:(val3b := '3').
    ] fork.

    Delay waitForSeconds:0.1.
    self assert:(opQ size == 3).

    Delay waitForSeconds:2.
    self assert:((sz := opQ size) == 0).

    self assert:(val1 == rslt1).
    self assert:(val2 == rslt2).
    self assert:(val3 == rslt3).
    self assert:(rslt1 = rslt1b).
    self assert:(rslt2 = rslt2b).
    self assert:(rslt3 = rslt3b).
    self assert:(val1b = rslt1b).
    self assert:(val2b = rslt2b).
    self assert:(val3b = rslt3b).
! !

!OperationInQueueTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

