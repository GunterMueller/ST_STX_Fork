"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ExceptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

Query subclass:#MyQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ExceptionTest
!

Exception subclass:#MyResumableTestError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ExceptionTest
!

Exception subclass:#MyTestError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ExceptionTest
!

!ExceptionTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ExceptionTest methodsFor:'tests'!

test01

    |result zero|

    result := OrderedCollection new.
    zero := 0.

    [ 0 // zero ]
	on:ZeroDivide
	do:[:ex|
	    self assert:(ex creator == ZeroDivide).
	    self assert:(ex originator == 0).
	    result add:#Error
	].
    self assert:(result size == 1).
    self assert:(result first == #Error).
!

test02

    |result zero|

    result := OrderedCollection new.
    zero := 0.

    self should:[
	[ 0 // zero ] on:ZeroDivide do:[:ex|
	    result add:#Error.
	    0 // zero
	].
    ] raise:ZeroDivide.
    self assert:(result size == 1).
    self assert:(result first == #Error).
!

test03

    |result zero|

    result := OrderedCollection new.
    zero := 0.

    self should:[
	[ 0 // zero ] on:ZeroDivide do:[:ex|
	    result add:#Error.
	    [ 0 // zero ] on:ZeroDivide do:[:ex|
		result add:#Error1.
		ex reject.
	    ].
	].
    ] raise:ZeroDivide.
    self assert:(result size == 2).
    self assert:(result first == #Error).
    self assert:(result second == #Error1).
!

test04_on_do

    |exceptionHappened zero|

    zero := 0.
    exceptionHappened := false.

    [0 // zero]
	on:ZeroDivide
	do:[:ex|
	    exceptionHappened := true
	].

    self assert:(exceptionHappened).
!

test05_on_do_ensure

    |exceptionHappened ensureCalled zero|

    zero := 0.
    exceptionHappened := ensureCalled := false.

    [0 // zero]
	on:ZeroDivide
	do:[:ex| exceptionHappened := true]
	ensure:[ ensureCalled := true ].

    self assert:(exceptionHappened).
    self assert:(ensureCalled).
!

test06_on_do_ensure

    |exceptionHappened ensureCalled zero|

    zero := 0.
    exceptionHappened := ensureCalled := false.

    [zero // 1]
	on:ZeroDivide
	do:[:ex| exceptionHappened := true]
	ensure:[ ensureCalled := true ].

    self assert:(exceptionHappened not).
    self assert:(ensureCalled).
!

test07_error_in_unwind
    "think about this - not sure, how to react on an error happening in the unwind..."

    |zero trace|

    zero := 0.

    trace := OrderedCollection new.
    self shouldnt:[
	Error handle:[:ex |
	    trace add:5.
	] do:[
	    [
		trace add:1.
		1 // zero.
		trace add:2.
	    ] ensure:[
		trace add:3.
		1 // zero.
		trace add:4.
	    ].
	].
    ] raise:Error.

    self assert:(trace asArray = #(1 5 3 5)).
!

test08_error_in_unwind2
    "no matter what happens in test7 - this one should work !!"

    |zero trace|

    zero := 0.

    trace := OrderedCollection new.
    self shouldnt:[
	Error handle:[:ex |
	    trace add:6.
	] do:[
	    Error handle:[:ex |
		trace add:5.
	    ] do:[
		[
		    trace add:1.
		    1 // zero.
		    trace add:2.
		] ensure:[
		    trace add:3.
		    1 // zero.
		    trace add:4.
		].
	    ].
	].
    ] raise:Error.

    self assert:(trace asArray = #(1 5 3 5)).


    "Created: / 24-08-2011 / 14:02:01 / cg"
!

test09_reraiseOuterHandlerWithEnsure
    |trace|

    trace := OrderedCollection new.

    AbortSignal handle:[:ex |
	trace add:1.
    ] do:[
	[
	    AbortSignal handle:[:ex |
		trace add:2.
		AbortSignal raise.
		trace add:3.
	    ] do:[
		trace add:4.
		AbortSignal raise.
		trace add:5.
	    ].
	    trace add:6.
	] ensure:[
	    trace add:9
	].
    ].
    trace add:7.

    self assert:(trace asArray = #(4 2 1 9 7)).
!

test10_reraiseOuterHandlerWithEnsure
    |trace|

    trace := OrderedCollection new.

    AbortSignal handle:[:ex |
	trace add:1.
    ] do:[
	[
	    AbortSignal handle:[:ex |
		trace add:2.
		AbortSignal raise.
		trace add:3.
	    ] do:[
		trace add:4.
		AbortSignal raise.
		trace add:5.
	    ].
	    trace add:6.
	] ensure:[
	    trace add:9
	].
    ].
    trace add:7.

    self assert:(trace asArray = #(4 2 1 9 7)).
!

test11

    |result zero|

    result := OrderedCollection new.
    zero := 0.

    [
	[
	    Warning handle:[:ex | result add:#Warning ] do:[ 2 // zero ].
	] on:ZeroDivide do:[:ex |
	    result add:#Error.
	    ex reject.
	    [
		self warn:ex description.
	    ] on:Warning do:[:ex| result add:#Warning2]
	]
    ] on:ZeroDivide do:[:ex |
	result add:#Error2
    ].

    self assert:(result size == 2).
    self assert:(result first == #Error).
    self assert:(result second == #Error2)

    "
     self run:#test10
     self new test10
    "
!

test12_abortInEnsure
    |trace setUp tearDown action|

    trace := OrderedCollection new.

    setUp :=
	[
	    trace add:1.
	    "/ Transcript showCR:'1'.
	    AbortSignal raise.
	].

    tearDown :=
	[
	    trace add:2.
	    "/ Transcript showCR:'2'.
	    AbortSignal raise.
	].

    action :=
	[
	    trace add:3.
	    "/ Transcript showCR:'3'.
	].

    AbortSignal handle:[:ex |
	trace add:44.
	"/ Transcript showCR:'44'.
    ] do:[
	AbortSignal handle:[:ex |
	    trace add:4.
	    "/ Transcript showCR:'4'.
	] do:[
	    [
		trace add:5.
		"/ Transcript showCR:'5'.
		setUp value.
		trace add:6.
		"/ Transcript showCR:'6'.
		action value.
		trace add:7.
		"/ Transcript showCR:'7'.
	    ] ensure: [
		trace add:8.
		"/ Transcript showCR:'8'.
		tearDown value
		trace add:9.
		"/ Transcript showCR:'9'.
	    ].
	].
    ].
    trace add:10.
    "/ Transcript showCR:'10'.
    self assert:(trace asArray = #(5 1 4 8 2 4 10)).

    "
     self new test12_reraiseOuterHandlerWithEnsure
    "
!

test13_abortInEnsureInProcess
    |trace setUp tearDown action p|

    trace := OrderedCollection new.

    setUp :=
	[
	    trace add:1.
	    "/ Transcript showCR:'1'.
	    AbortSignal raise.
	].

    tearDown :=
	[
	    trace add:2.
	    "/ Transcript showCR:'2'.
	    AbortSignal raise.
	].

    action :=
	[
	    trace add:3.
	    "/ Transcript showCR:'3'.
	].

    p :=
	[
	    AbortSignal handle:[:ex |
		trace add:44.
		"/ Transcript showCR:'44'.
	    ] do:[
		AbortSignal handle:[:ex |
		    trace add:4.
		    "/ Transcript showCR:'4'.
		] do:[
		    [
			trace add:5.
			"/ Transcript showCR:'5'.
			setUp value.
			trace add:6.
			"/ Transcript showCR:'6'.
			action value.
			trace add:7.
			"/ Transcript showCR:'7'.
		    ] sunitEnsure: [
			trace add:8.
			"/ Transcript showCR:'8'.
			tearDown value
			trace add:9.
			"/ Transcript showCR:'9'.
		    ].
		].
	    ].
	    trace add:10.
	    "/ Transcript showCR:'10'.
	] newProcess.
    "/ p addExitAction:[ self halt].
    p resume.

    p waitUntilTerminated.
    self assert:(trace asArray = #(5 1 4 8 2 4 10)).

    "
     self new test12_reraiseOuterHandlerWithEnsure
    "
!

test14_queryDefaultAnswer
    |answer|

    answer := MyQuery query.
    self assert:(answer == #defaultAnswer).
!

test15_queryWithHandler
    |answer|

    MyQuery answer:#ok do:[
	answer := MyQuery query.
	self assert:(answer == #ok).
    ].
!

test16_queryWithHandler2DefaultAnswer
    |answer|

    MyQuery answer:#ok
	do:[
	    [
		answer := MyQuery query.
		self assert:(answer == #ok2).
	    ] on:MyQuery do:[:ex | ex return:#ok2 ].
	].
!

test17_queryWithHandler3
    |answer|

    MyQuery answer:#ok
	do:[
	    [
		answer := MyQuery query.
		self assert:(answer == #ok).
	    ] on:AbortAllOperationWantedQuery do:[:ex | ex return:#ok2 ].
	].
!

testHandlerContext
    "A test ensuring that when evaluating the action block the exception environment is set to the handler context."

    | result |
    result := [
    [
    [ MyResumableTestError signal ]
	on: MyTestError
	do: [ 'handler 2' ] ]
	on: MyResumableTestError
	do: [ MyTestError signal ] ]
	on: MyTestError
	do: [ 'handler 1' ].
    self assert: 'handler 1' = result description: 'Incorrect handler'

    "Created: / 20-08-2014 / 17:05:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testHandlerFromAction
    "A test ensuring that nested exceptions work as expected."

    | result |
    result := [
    [
    [ self error: 'trigger error' ]
	on: ZeroDivide
	do: [ :ex | 'inner' ] ]
	on: Error
	do: [ :ex | 3 perform: ('', '/') asSymbol with: 0 ] ]
	on: ZeroDivide
	do: [ :ex | 'outer' ].
    self assert: 'outer' = result description: 'Incorrect handler'

    "Created: / 20-08-2014 / 17:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ExceptionTest::MyQuery class methodsFor:'default actions'!

defaultAnswer
    ^ #defaultAnswer
! !

!ExceptionTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

