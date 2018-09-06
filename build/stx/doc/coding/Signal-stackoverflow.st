"{ NameSpace: CodingExamples }"

Object subclass:#SignalHandlingExample2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Exceptions'
!

!SignalHandlingExample2 class methodsFor:'documentation'!

documentation
"
    demonstrates handling of recursion interrupt
"
! !

!SignalHandlingExample2 class methodsFor:'examples2'!

exampleA1
    "the handler will just abort"

    Object recursionInterruptSignal handle:[:ex |
        Transcript showCR:'oops - too much recursion'; endEntry.

        ex return.
    ] do:[
        Transcript showCR:'starting 10000 factorial ...'; endEntry.
        10000 factorialR.
        Transcript showCR:'done factorial.'; endEntry.
    ].

    Transcript showCR:'thats it'

    "
     SignalHandlingExample2 exampleA1
    "

    "Modified: 27.1.1997 / 15:29:02 / cg"
!

exampleA2
    "the handler will add more stack and restart
     (which works, but is not the best solution - see exampleA3)"

    "make certain, that stack limit is restored, 
     (in case you dont want to wait for the 10000 factorial 
      to be computed, and therefore abort from the debugger ...:-)"

    |originalLimit|

    originalLimit := Processor activeProcess maximumStackSize.

    [
        Object recursionInterruptSignal handle:[:ex |
            |limit|

            Transcript showCR:'oops - too much recursion'; endEntry.
            limit := Processor activeProcess maximumStackSize.
            Transcript show:'increase stack to '; show:(limit * 2); showCR:' and restart.'; endEntry.
            Processor activeProcess setMaximumStackSize:(limit * 2).

            ex restart
        ] do:[
            Transcript showCR:'starting 10000 factorial ...'; endEntry.
            10000 factorialR.
            Transcript showCR:'done factorial.'; endEntry.
        ].
    ] valueNowOrOnUnwindDo:[
        Processor activeProcess setMaximumStackSize:originalLimit
    ].

    Transcript showCR:'thats it'

    "
     SignalHandlingExample2 exampleA2
    "

    "Modified: 27.1.1997 / 15:31:43 / cg"
!

exampleA3
    "the handler will add more stack and continue"

    "make certain, that stack limit is restored, in case
     you dont want to wait for the 10000 factorial to be
     computed, and therefore abort from the debugger ...:-)"

    |originalLimit|

    originalLimit := Processor activeProcess maximumStackSize.
    [
        Object recursionInterruptSignal handle:[:ex |
            |limit|

            Transcript showCR:'oops - too much recursion'; endEntry.
            limit := Processor activeProcess maximumStackSize.
            Transcript show:'increase stack to '; show:(limit * 2); showCR:' and continue.'; endEntry.
            Processor activeProcess setMaximumStackSize:(limit * 2).

            ex proceed
        ] do:[
            Transcript showCR:'starting 10000 factorial ...'; endEntry.
            10000 factorialR.
            Transcript showCR:'done factorial.'; endEntry.
        ].
    ] valueNowOrOnUnwindDo:[
        Processor activeProcess setMaximumStackSize:originalLimit
    ].

    Transcript showCR:'thats it'

    "
     SignalHandlingExample2 exampleA3
    "

    "Modified: 27.1.1997 / 15:31:51 / cg"
! !

!SignalHandlingExample2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Signal-stackoverflow.st,v 1.8 1997-01-27 14:34:07 cg Exp $'
! !
