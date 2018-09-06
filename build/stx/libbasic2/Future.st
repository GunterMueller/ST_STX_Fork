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

ProtoObject subclass:#Future
	instanceVariableNames:'result semaphore'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!Future class methodsFor:'documentation'!

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
    I represent an execution in progress, which will be required some time
    in the future.
    I will immediately start execution in a separate process,
    but delay any messages sent to me, until the execution has completed.
    This is useful for time consuming operations (print jobs, compile jobs etc.),
    which can be done in the background and the user can do something else
    in the meantime. If the computation is finished before the user needs its
    value, he is not forced to wait.
    If the computation is unfinished, he has to wait for the remaining time only.

    [author:]
        tph@cs.man.ac.uk

    [see also:]
        Block Lazy LazyValue
"
!

examples
"
  Starts evaluating the factorial immediately, but waits until
  the result is available before printing the answer
                                                                    [exBegin]
    | fac |

    fac := [50000 factorial] futureValue.
    Transcript showCR: 'evaluating factorial...'.
    Dialog information:'You can do something useful now...'.
    Transcript showCR: fac
                                                                    [exEnd]


  An example illustrating the use of multiple futures and
  explicit resynchronisation.

  Starts evaluating both factorials immediately, but waits until
  both blocks have finished before continuing.
                                                                    [exBegin]
    | fac1 fac2 |

    fac1 := [Transcript showCR: 'Starting fac1.. '. 9000 factorial. Transcript showCR: 'Finished fac1'] futureValue.
    fac2 := [Transcript showCR: 'Starting fac2.. '. 5000 factorial. Transcript showCR: 'Finished fac2'] futureValue.
    fac2 value.
    fac1 value.
    Transcript showCR: 'both completed.'.
                                                                    [exEnd]

  Example showing how arguments may be passed to futures.
                                                                    [exBegin]
    | temp |

    temp := [:x :y | 10 * x * y] futureValue: 3 value: 4.
    Transcript  showCR: temp.

                                                                    [exEnd]

  Claus:
    The above examples do not really show the power of Futures;
    they can be useful, whenever some long-time computation is
    to be done, and some other useful work can be done in the meanwhile.
    for example:

    Without futures, the inputfile is read before opening the view;
    the readTime and view creation times sum up:
                                                                    [exBegin]
        |p text v|

        p := PipeStream readingFrom:'ls -l /bin /usr/bin /usr/lib'.
        text := p contents.
        p close.
        v := TextView new openAndWait.
        v contents:text
                                                                    [exEnd]

    The same here:
                                                                    [exBegin]
        |p text v|

        v := TextView new openAndWait.
        p := PipeStream readingFrom:'ls -l /bin /usr/bin /usr/lib'.
        text := p contents.
        p close.
        v contents:text
                                                                    [exEnd]


    With futures, the view creation and reading are done in parallel:
    (if the windowing system is slow when opening the view, the contents may
     be already available - especially on X window systems, where the user
     has to provide the window position with the mouse)
                                                                    [exBegin]
        |p text v|

        text := [   |p t|

                    p := PipeStream readingFrom:'ls -l /bin /usr/bin /usr/lib'.
                    t := p contents.
                    p close.
                    t
                ] futureValue.
        v := TextView new openAndWait.
        v contents:text
                                                                    [exEnd]
"
! !

!Future methodsFor:'evaluating'!

block:aBlock
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [result := aBlock value] ensure:[semaphore signal. semaphore := nil.]
    ] fork

    "Modified (format): / 04-10-2011 / 14:54:11 / cg"
!

block:aBlock value:aValue
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock value:aValue
        ] ensure:[semaphore signal. semaphore := nil.]
    ] fork

    "Modified (format): / 04-10-2011 / 14:54:18 / cg"
!

block:aBlock value:value1 value:value2
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock value:value1 value:value2
        ] ensure:[semaphore signal. semaphore := nil.]
    ] fork

    "Modified (format): / 04-10-2011 / 14:54:28 / cg"
!

block:aBlock value:value1 value:value2 value:value3
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock value:value1 value:value2 value:value3
        ] ensure:[semaphore signal. semaphore := nil.]
    ] fork

    "Modified (format): / 04-10-2011 / 14:54:45 / cg"
!

block:aBlock valueWithArguments:anArray
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock valueWithArguments:anArray
        ] ensure:[semaphore signal. semaphore := nil.]
    ] fork

    "Modified (format): / 04-10-2011 / 14:55:09 / cg"
!

priority:prio block: aBlock
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [result := aBlock value] ensure:[semaphore signal. semaphore := nil.]
    ] forkAt:prio

    "Created: / 04-10-2011 / 14:53:21 / cg"
!

priority:prio block: aBlock value: aValue
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock value:aValue
        ] ensure:[semaphore signal. semaphore := nil.]
    ] forkAt:prio

    "Created: / 04-10-2011 / 14:53:35 / cg"
!

priority:prio block:aBlock value:value1 value:value2
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock value:value1 value:value2
        ] ensure:[semaphore signal. semaphore := nil.]
    ] forkAt:prio

    "Created: / 04-10-2011 / 14:54:03 / cg"
!

priority:prio block:aBlock value:value1 value:value2 value:value3
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock value:value1 value:value2 value:value3
        ] ensure:[semaphore signal. semaphore := nil.]
    ] forkAt:prio

    "Created: / 04-10-2011 / 14:54:51 / cg"
!

priority:prio block:aBlock valueWithArguments:anArray
    "Execute aBlock in parallel with whatever called me, but
     ensure that any messages sent to me before execution
     of the block has terminated are suspended until it has terminated."

    semaphore := Semaphore new name:'Future'.
    [
        [
            result := aBlock valueWithArguments:anArray
        ] ensure:[semaphore signal. semaphore := nil.]
    ] forkAt:prio

    "Created: / 04-10-2011 / 14:55:14 / cg"
! !

!Future methodsFor:'printing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ self value displayOn:aGCOrStream
    ].

    semaphore isNil ifTrue:[
        result displayOn:aGCOrStream.
        aGCOrStream nextPutAll:' (Future evaluated)'.
        ^ self.
    ].    
    aGCOrStream nextPutAll:'Future (unevaluated)'
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

!Future methodsFor:'synchronising'!

doesNotUnderstand:aMessage
    "Any message to a Future will end up here."

    semaphore notNil ifTrue:[
        IsDebuggingQuery query ifTrue:[
            "enable debugging / inspecting"
            ^ aMessage sendTo:self usingClass:Object.
        ].
        self value.
    ].
    ^ aMessage sendTo:result

    "Modified: / 04-10-2011 / 17:37:18 / cg"
!

perform:aSelector withArguments:argArray
    "send the message aSelector with all args taken from argArray
     to the receiver."

    semaphore notNil ifTrue:[
        IsDebuggingQuery query ifTrue:[
            "enable debugging / inspecting"
            ^ super perform:aSelector withArguments:argArray.
        ].
        self value.
    ].
    ^ result perform:aSelector withArguments:argArray.
!

value
    |sema|

    sema := semaphore.
    sema notNil ifTrue:[
        semaphore waitUncounted. "Wait for evaluation to complete"
                                 "(if not already completed)"
    ].
    ^ result

    "Created: / 04-10-2011 / 17:36:06 / cg"
! !

!Future methodsFor:'testing'!

hasValue
    ^ semaphore isNil or:[semaphore wouldBlock not].

    "Modified: / 04-10-2011 / 17:29:36 / cg"
!

isLazyValue
    ^ semaphore notNil and:[semaphore wouldBlock]
! !

!Future class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

