"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

AbstractBackgroundJob subclass:#BackgroundJob
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!BackgroundJob class methodsFor:'documentation'!

documentation
"
    A BackgroundJob for one-shot computation. When started, it performs it job
    and terminates. User have to explicitly ask job to start again to 
    perform new computation.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        BackgroundJob
"
!

examples
"
    | job text |
    job :=  BackgroundJob named: 'example job' on:[
                Delay waitForSeconds: 3.
                Transcript showCR:'One guy said: ', text
            ].
    text := 'Hello world'.
    job restart.
    Delay waitForSeconds: 5.
    text := 'Ahoj Svete!!'.
    job restart.
    Delay waitForSeconds: 1.
    text := 'Haya, I''m talking fast, you should not see the czech greeting'.
    job restart.

"
! !

!BackgroundJob methodsFor:'processing'!

process
    "Actually perform the job. This method is called from the background worker thread"               

    self process:job

    "Created: / 21-02-2015 / 10:14:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process: aBlock
    aBlock value

    "Created: / 21-02-2015 / 10:19:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundJob methodsFor:'start & stop'!

restart: aBlock
    "Restart the job, evaluationg aBlock instead of pre-configured job"

    running ifTrue:[
        self stop.
    ].
    self start: aBlock

    "Created: / 21-02-2015 / 10:16:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start: aBlock
    "Start the job, evaluating aBlock instead of pre-configured `job`."

    self start: aBlock withPriority: priority

    "Created: / 21-02-2015 / 10:17:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start: block withPriority: prio
    | t |

    ((t := thread) isNil or:[t isDead]) ifTrue:[
        thread := [
            [
                running := true.
                self process: block.
            ] ensure: [
                running := false.
                thread := nil
            ]
        ] newProcess.
        self setupThread: thread priority: prio.
        thread resume.
    ]

    "Created: / 21-02-2015 / 10:18:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundJob class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/BackgroundJob.st,v 1.15 2015-02-21 22:42:34 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/BackgroundJob.st,v 1.15 2015-02-21 22:42:34 vrany Exp $'
!

version_SVN
    ^ '$Id: BackgroundJob.st,v 1.15 2015-02-21 22:42:34 vrany Exp $'
! !

