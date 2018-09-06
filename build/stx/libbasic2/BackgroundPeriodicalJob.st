"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

AbstractBackgroundJob subclass:#BackgroundPeriodicalJob
	instanceVariableNames:'interval'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!BackgroundPeriodicalJob class methodsFor:'documentation'!

documentation
"
    A BackgroundPeriodicalJob is a specialized form
    of a BackgroundJob that performs given job periodically
    i.e., every X milliseconds.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        interval       <TimeDuration>     how often to perform a job.

    [class variables:]

    [see also:]
        BackgroundJob
"
!

examples
"
    | job text |
    text := 'Hello world'.
    job :=  BackgroundPeriodicalJob named: 'example job' on:[
                Transcript showCR:'One guy said: ', text
            ].
    job interval: 1000.
    job start.
    Delay waitForSeconds: 3.
    text := 'Haya, you should see this text repeating every second....'.
    job restart.        
    Delay waitForSeconds: 3.
    job stop.

"
! !

!BackgroundPeriodicalJob methodsFor:'accessing'!

interval
    ^ interval
!

interval:anIntegerOrTimeDuration

    anIntegerOrTimeDuration isInteger ifTrue:[
        interval := TimeDuration fromMilliseconds: anIntegerOrTimeDuration.
    ] ifFalse:[
        interval := anIntegerOrTimeDuration.
    ].

    "Modified: / 06-09-2011 / 12:00:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundPeriodicalJob methodsFor:'processing'!

process
    | delay |

    delay := Delay forMilliseconds: interval getMilliseconds.
    [
        job value.
        delay wait.
    ] loop.

    "Created: / 06-09-2011 / 12:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 10:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundPeriodicalJob class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

