"{ Namespace: 'CodingExamples' }"

Object subclass:#ProcessExamples
	 instanceVariableNames:''
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Processes'!

!ProcessExamples class methodsFor:'examples'!

example1
    "create and run 2 processes with same prio, using newProcess + resume"

    |p1 p2|

    p1 := [
	1 to:3 do:[:i | 
	    ('process 1 round: ' , i printString)  printNewline.
	    (Delay forSeconds:2) wait
	]
    ] newProcess resume.

    p2 := [
	1 to:3 do:[:i | 
	    ('process 2 round: ' , i printString)  printNewline.
	    (Delay forSeconds:2) wait
	]
    ] newProcess resume.


    "ProcessExamples example1"
!

example2
    "create and run 2 processes with same prio using fork"

    [
	1 to:3 do:[:i | 
	    ('process 1 round: ' , i printString)  printNewline.
	    (Delay forSeconds:2) wait
	]
    ] fork.

    [
	1 to:3 do:[:i | 
	    ('process 2 round: ' , i printString)  printNewline.
	    (Delay forSeconds:2) wait
	]
    ] fork.

    "ProcessExamples example2"
!

example3
    "create and run 2 processes with different prios; process 1 will finish first"

    [
	1 to:3 do:[:i | 
	    ('process 1 round: ' , i printString)  printNewline.
	    Processor yield
	]
    ] forkAt:(Processor highestPriority).

    [
	1 to:3 do:[:i | 
	    ('process 2 round: ' , i printString)  printNewline.
	    Processor yield
	]
    ] fork.


    "ProcessExamples example3"
!

example4
    "producer/consumer example with polling"

    |sharedData rand|

    sharedData := nil.

    [
	rand := Random new.
	1 to:3 do:[:i |
	    |val|

	    [sharedData notNil] whileTrue:[
		Processor yield
	    ].
	    val := rand next.
	    'process 1 sending ' print. val printNewline.
	    sharedData := val.
	]
    ] fork.

    [
	1 to:3 do:[:i | 
	    [sharedData isNil] whileTrue:[
		Processor yield
	    ].
	    'process 2 received ' print. sharedData printNewline.
	    sharedData := nil.
	    Processor yield
	]
    ] fork.


    "ProcessExamples example4"
!

example5
    "producer/consumer example using semaphores"

    |sharedData rand writeSema readSema|

    sharedData := nil.
    writeSema := Semaphore new:1.
    readSema := Semaphore new.

    [
	rand := Random new.
	1 to:3 do:[:i |
	    |val|

	    writeSema wait.
	    val := rand next.
	    'process 1 sending ' print. val printNewline.
	    sharedData := val.
	    readSema signal.
	]
    ] fork.

    [
	1 to:3 do:[:i |
	    readSema wait.
	    'process 2 received ' print. sharedData printNewline.
	    sharedData := nil.
	    writeSema signal
	]
    ] fork.


    "ProcessExamples example5"
! !
