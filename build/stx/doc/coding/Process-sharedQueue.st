"{ NameSpace: CodingExamples }"

Object subclass:#SharedQueueExamples
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Processes'
!


!SharedQueueExamples class methodsFor:'examples'!

documentation
"
    demonstration of SharedQueues

    [see also:]
        SharedQueue
        Queue
        Process

    [author:]
        Claus Gittinger

    [start with:]
        CodingExamples::SharedQueueExamples example1
        CosingExamples::SharedQueueExamples example2
"

!

example1
    "
     this example creates a sharedQueue and some processes writing
     into it. A single reader process gets the data from 3 writers.
     Each process delays for some time after an action.
    "

    |queue rand reader writer1 writer2 writer3 action|

    queue := SharedQueue new:5.
    rand := Random new.
    action := [:num |
	1 to:10 do:[:index |
	    |datum|

	    datum := rand next.
	    Transcript 
		showCR:(num printString , ' writing ' , datum printString ,
			' (' , index printString , ')' ).
	    queue nextPut:datum.
	    (Delay forMilliseconds:(rand nextBetween:100 and:1000) asInteger) wait
	]
    ].

    writer1 := action forkWith:#(1). writer1 name:'writer1'. "give it a name - see ProcessMonitor"
    writer2 := action forkWith:#(2). writer2 name:'writer2'.
    writer3 := action forkWith:#(3). writer3 name:'writer3'.

    reader := [
	1 to:30 do:[:index |
	    |datum|

	    datum := queue next.
	    Transcript 
		showCR:('got ' , datum printString , ' (' , index printString , ')').
	    (Delay forMilliseconds:(rand nextBetween:100 and:1000) asInteger) wait
	]
    ] fork.

    reader name:'reader'.

    "SharedQueueExamples example1"
!

example2
    "filter processes:

     writer -> queue1 -> filter -> queue2 -> reader

    the writer will create a sequence of numbers, the filter will
    filter all odd numbers, the reader will show whats coming out."

    |queue1 queue2 writer reader filter|

    queue1 := SharedQueue new:5.
    queue2 := SharedQueue new:5.

    writer := [
	1 to:100 do:[:i |
	    queue1 nextPut:i
	]
    ] newProcess.

    filter := [
	|datum|

	[true] whileTrue:[
	    datum := queue1 next.
	    datum even ifTrue:[
		queue2 nextPut:datum
	    ]
	]
    ] fork.

    reader := [
	[true] whileTrue:[
	    Transcript showCR:(queue2 next printString)
	]
    ] fork.


    "start the show ..."

    writer resume.

    "SharedQueueExamples example2"
! !

!SharedQueueExamples class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Process-sharedQueue.st,v 1.8 1997-01-05 20:22:39 cg Exp $'
! !
