"
 This is a Manchester Goodie protected by copyright.
 These conditions are imposed on the whole Goodie, and on any significant
 part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).
 Further information on the copyright conditions may be obtained by
 sending electronic mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: copyright
 or by writing to The Smalltalk Goodies Library Manager, Dept of
 Computer Science, The University, Manchester M13 9PL, UK

 (C) Copyright 1992 University of Manchester
 For more information about the Manchester Goodies Library (from which
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

ProtoObject subclass:#Lazy
	instanceVariableNames:'result startSemaphore endSemaphore'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!Lazy class methodsFor:'documentation'!

copyright
"
 This is a Manchester Goodie protected by copyright.
 These conditions are imposed on the whole Goodie, and on any significant
 part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).
 Further information on the copyright conditions may be obtained by
 sending electronic mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: copyright
 or by writing to The Smalltalk Goodies Library Manager, Dept of
 Computer Science, The University, Manchester M13 9PL, UK

 (C) Copyright 1992 University of Manchester
 For more information about the Manchester Goodies Library (from which
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help
"
!

documentation
"
    I represent an execution which may or may not be required.
    I will not start execution until at least one message has been received.
    The messages sent to me are delayed until execution has completed.

    [author:]
        tph@cs.man.ac.uk

    [see also:]
        Block LazyValue Future
"
!

examples
"
  Evaluates the factorial, starting only when the
  result is actually required (when printString is sent).
                                                [exBegin]
    | fac |
    fac := [100 factorial] lazyValue.
    Transcript showCR: 'Doing nothing. '.
    (Delay forSeconds: 2) wait.
    Transcript showCR: fac printString.
                                                [exEnd]


  Starts evaluating both factorials only when required (by the value),
  and waits until both blocks have finished before continuing.
                                                [exBegin]
    | fac1 fac2 |
    fac1 := [Transcript showCR: 'Starting fac1.. '. 100 factorial] lazyValue.
    fac2 := [Transcript showCR: 'Starting fac2.. '. 120 factorial] lazyValue.
    fac2 value.
    fac1 value.
    Transcript showCR: 'both completed.'.
                                                [exEnd]


  Demonstrates how to pass arguments to a lazy evaluation block.
                                                [exBegin]
    | temp |
    temp := [:x :y :z | x * y * z] lazyValueWithArguments: #(2 3 4).
    Transcript  showCR: temp printString.
                                                [exEnd]
"
! !

!Lazy methodsFor:'evaluating'!

block: aBlock
    "Execute aBlock in parallel, but ensure that any messages sent
     to me before execution of the block has terminated are
     suspended until it has terminated. Do not start the evaluation
     until at least one message has been sent to the receiver."

    startSemaphore := Semaphore new.
    endSemaphore := Semaphore new.
    [
        startSemaphore wait.
        result := aBlock value.
        endSemaphore signal
    ] fork.
!

block: aBlock value: aValue
	"Execute aBlock in parallel, but ensure that any messages sent
	 to me before execution of the block has terminated are
	 suspended until it has terminated. Do not start the evaluation
	 until at least one message has been sent to the receiver."

	startSemaphore := Semaphore new.
	endSemaphore := Semaphore new.
	[startSemaphore wait.
	 result := aBlock value: aValue.
	 endSemaphore signal] fork
!

block: aBlock value: value1 value: value2
	"Execute aBlock in parallel, but ensure that any messages sent
	 to me before execution of the block has terminated are
	 suspended until it has terminated. Do not start the evaluation
	 until at least one message has been sent to the receiver."

	startSemaphore := Semaphore new.
	endSemaphore := Semaphore new.
	[startSemaphore wait.
	 result := aBlock value: value1 value: value2.
	 endSemaphore signal] fork
!

block: aBlock value: value1 value: value2 value: value3
	"Execute aBlock in parallel, but ensure that any messages sent
	 to me before execution of the block has terminated are
	 suspended until it has terminated. Do not start the evaluation
	 until at least one message has been sent to the receiver."

	startSemaphore := Semaphore new.
	endSemaphore := Semaphore new.
	[startSemaphore wait.
	 result := aBlock value: value1 value: value2 value: value3.
	 endSemaphore signal] fork
!

block: aBlock valueWithArguments: anArray
	"Execute aBlock in parallel, but ensure that any messages sent
	 to me before execution of the block has terminated are
	 suspended until it has terminated. Do not start the evaluation
	 until at least one message has been sent to the receiver."

	startSemaphore := Semaphore new.
	endSemaphore := Semaphore new.
	[startSemaphore wait.
	 result := aBlock valueWithArguments: anArray.
	 endSemaphore signal] fork
! !

!Lazy methodsFor:'printing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ self _evaluate_ displayOn:aGCOrStream
    ].

    startSemaphore isNil ifTrue:[
        result displayOn:aGCOrStream.
        aGCOrStream nextPutAll:' (Lazy evaluated)'.
        ^ self.
    ].    
    aGCOrStream nextPutAll:'Lazy (unevaluated)'
!

displayString
    |s|

    "/ attention: TextStream is not present in ultra-mini standalone apps
    s := TextStream isNil
            ifTrue:['' writeStream]
            ifFalse:[TextStream on:(String new:32)].
    self displayOn:s.
    ^ s contents
! !

!Lazy methodsFor:'synchronising'!

_evaluate_
    "answer the computed value"

    |startSema endSema|

    startSema := startSemaphore.
    startSema notNil ifTrue:[
        startSema signal.          "Start the evaluation."
        endSema := endSemaphore.
        endSema notNil ifTrue:[
            endSema waitUncounted.     "Wait until evaluation completed."
        ].
        startSemaphore := endSemaphore := nil.
    ].

    ^ result
!

doesNotUnderstand: aMessage
    "Any message to a Lazy will end up here."

    startSemaphore notNil ifTrue:[
        IsDebuggingQuery query ifTrue:[
            "enable debugging / inspecting without evaluating"
            ^ aMessage sendTo:self usingClass:Object.
        ].
        self _evaluate_.
    ].

    ^ aMessage sendTo:result.
!

perform:aSelector withArguments:argArray
    "send the message aSelector with all args taken from argArray
     to the receiver."

    startSemaphore notNil ifTrue:[
        IsDebuggingQuery query ifTrue:[
            "enable debugging / inspecting"
            ^ super perform:aSelector withArguments:argArray.
        ].
        self _evaluate_.
    ].
    ^ result perform:aSelector withArguments:argArray.
! !

!Lazy methodsFor:'testing'!

isLazyValue
    ^ endSemaphore wouldBlock
! !

!Lazy class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

