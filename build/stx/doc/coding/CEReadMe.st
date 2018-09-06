"{ NameSpace: CodingExamples }"

Object subclass:#ReadMe
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'_README'
!

!ReadMe class methodsFor:'documentation'!

documentation
"
    In the CodingExamples nameSpace, you will find various
    non-GUI related coding examples.

    These demonstrate particular features of the programming
    language / implementation.

    The corresponding files are found in 'doc/coding' and
    contain examples of how to use some of the more non-obvious 
    mechanisms of smalltalk (and/or Smalltalk/X), and some view class examples.

    Some files found there contain full classes or methods, others contain just code 
    fragments to be evaluated by doIt. 
    Look at the files (using the FileBrowser) before you start filing them in.

    The examples will be split into two directories (one for mechanisms, 
    another for view tutorials) soon.

    List of files (most contain classes which are also autoloaded):
    (may be outdated by the time you read this ..)

        Array-literalStore      demonstrates why
                                storing into array literals is BAD BAD BAD 

        BOSS-examples           some code fragments to demonstrate binary store 
                                and load of objects (code fragments)

        BOSS-errors             some code fragments to demonstrate possible errors
                                when using binary store (i.e. loading obsolete instances)

        Block-examples          demonstrates, that blocks have true local state
                                (i.e. are closures, and can be recursive)

        Block-unwind            shows how valueOnUnwind: and valueNowOrOnUnwind:
                                are used

        Class-anonymous         demonstrates how classes (a Behavior or light weight class)
                                can be created on-the-fly. Even have instances which
                                understand messages.

        Class-dynamic           simple demonstration of dynamically changing the
                                class of an object.

        Class-multipleInheritance
                                a very simple implementation of multiple inheritance

        Class-subclassing       each possibility to define a subclass

        Context-advanced        some special tricks possible with contexts
                                (some of these tricks already found their way into 
                                 the standard classes; see Blocks whileXX implementation)
                                Also includes demonstrations of unwinding and unwind-
                                protect-actions (valueOnUnwindDo)

        File-IO.st              code fragments to show simple I/O with text & binary files

        FileIn-errors           demonstrates how errors during fileIn are handled
                                (i.e. use of abort, debug & continue)

        Process-examples        simple process examples showing fork, newProcess etc)

        Process-delay           shows use of Delay and process forking

        Process-diningTable     the standard philosopher example using Semaphores

        Process-philosopher     (load both, start with: '(DiningTable new:5) dinner')

        Process-philosopher2    example on how to prevent the (possible) deadlock in Philosopher

        Process-sharedQueue     shows use of processes and shared queues

        Registry-example        shows use of Registry to track object reclamation by
                                the garbage collector (i.e. finalization).

        Signal-handling         examples on how Signal, Exception and SignalSet 
                                are used (study this one carefully - its nice)

        Signal-floatSignals     floating point errors and handling

        Signal-stackoverflow    examples on how stack overflow can be handled

        Socket-connection       use of Sockets (code fragments)

        Socket-objectcopy       how objects can be sent via a socket connection using 
                                binaryStore (code fragments)

        Special-hereSend        local sends - an ST/X special feature

        libfoo_example          source for the example in the
                                online documentation 'How to compile ...'

        libfoo2_example         like above, but C-functions are defined
                                privately in the CInterface class
"
! !

!ReadMe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/CEReadMe.st,v 1.6 1998-01-28 14:41:54 cg Exp $'
! !
