"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
	      All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#AbstractBackgroundJob
	instanceVariableNames:'name job priority thread running isDebuggerJob initiatingThread'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!AbstractBackgroundJob class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
	      All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    Ab AbstractBackgroundJob is a base superclass for any kind of background
    processing job. Possible uses include (but not limited to): 
    copying files, syntax higlighting, live searching, autosave, etc.

    See subclasses for various form of background processing.

    A task to be processed in a background is given to instances
    in a form of a block or a message send. The background task must 
    be then started by sending a #start message to the instance of 
    the job. A job may be restarted any time by sending #restart or
    terminated by sending #stop. Sending #start to already started
    job does nothing.

    Implementation note: 
    The the task is actually processed in a separate, exclusive    
    worker thread, so an explicit synchronization have to
    be done iff the task accesses possibly shared data. 
    The worker exists only iff the job is actually running. When 
    the task is finished, worker thread terminates.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        name    <String|nil>            A user friendly name of a job,
                                        useful for identifing job's thread in
                                        process list.
        job     <Block|MessageSend>     A task to perform in background.
        priority<Integer>               A priority of worker thread. Defaults to
                                        Processor userBackgroundPriority.
        thread  <Process|nil>           The worker thread
        running <Boolean>               Boolean value indicating whether
                                        tasks already started or not.

    [see also:]
        BackgroundJob
        BackgroundQueueProcessingJob
        BackgroundPeriodicalJob
        Tools::CodeHighlightingService (uses this class)
    
    

"
! !

!AbstractBackgroundJob class methodsFor:'instance creation'!

named: name

    ^self new name: name

    "Created: / 28-04-2011 / 20:26:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

named: name on: block

    ^self new name: name; job: block

    "Created: / 28-04-2011 / 20:27:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

on: block

    ^self new job: block

    "Created: / 28-04-2011 / 20:30:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractBackgroundJob methodsFor:'accessing'!

initiatingThread
    ^ initiatingThread
!

initiatingThread:something
    initiatingThread := something.
!

isDebuggerJob
    ^ isDebuggerJob ? false
!

isDebuggerJob:aBoolean
    "added to allow suppression of breakpoints/halts of a
     job started by the debugger 
     (if you ask what this is for,
      try to put a breakpoint into the syntaxhighlighter in the old schema)"
     
    isDebuggerJob := aBoolean
!

job
    ^ job
!

job:aBlockOrMessageSend

    "Sets the job to be done. The job is sent
    #value from the worker thread once started"

    job := aBlockOrMessageSend.

    "Modified (comment): / 03-08-2011 / 21:02:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name ? '<unnamed background job>'

    "Modified: / 28-04-2011 / 20:29:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:aString
    name := aString.
!

priority
    ^ priority
!

priority:anInteger
    "Set the priority of a worker thread"

    priority := anInteger.

    "Modified (format): / 03-08-2011 / 16:42:45 / cg"
    "Modified (comment): / 03-08-2011 / 21:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

thread
    "Return the thread (an instance of Process) that currently
     processes the job or nil. if no processing is currently performed."

    ^thread

    "Created: / 18-04-2012 / 10:16:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractBackgroundJob methodsFor:'initialization'!

initialize
    priority := Processor userBackgroundPriority.
    running := false.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 29-07-2011 / 10:52:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:42:51 / cg"
! !

!AbstractBackgroundJob methodsFor:'private'!

setupThread: t priority: p
    "Sets up worker thread"

    t priority: p.
    t name: name.

    "Created: / 20-01-2012 / 16:38:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractBackgroundJob methodsFor:'processing'!

process
    "Actually perform the job. This method is called from the background worker thread"

    self subclassResponsibility

    "Created: / 28-04-2011 / 20:23:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:42:42 / cg"
    "Modified: / 21-02-2015 / 10:12:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractBackgroundJob methodsFor:'queries'!

running
    "Return true if the job is actually running, i.e., if it
     is actually computing a value, contrary to #scheduled, that
     returns true even if computation actually did not start
     (i.e., thread is created but was not scheduled so far)"

    ^running

    "Created: / 29-07-2011 / 10:23:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:42:35 / cg"
!

scheduled
    "Return true, if the job has been already started"

    ^thread notNil

    "Created: / 29-07-2011 / 10:47:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:42:32 / cg"
! !

!AbstractBackgroundJob methodsFor:'start & stop'!

abort
    "Abort the job, if it is running. Similar to #stop, but raises 
     abort operation request so the job has a chance to terminate
     gracefully"

    | t |

    (t := thread) isNil ifTrue:[^self].
    t interruptWith:[
        NoHandlerError handle:[:ex |
            ex exception creator == AbortOperationRequest ifTrue:[
                ex return.
            ].
            ex reject.
        ] do:[
            AbortOperationRequest raise.
        ].
    ].
    self stop

    "Created: / 09-02-2012 / 19:34:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

restart

    running ifTrue:[
        self stop.
    ].
    self start

    "Created: / 28-04-2011 / 20:31:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:42:39 / cg"
    "Modified (comment): / 03-08-2011 / 21:03:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start
    self startWithPriority: priority

    "Created: / 28-04-2011 / 20:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:44:36 / cg"
!

startWithPriority: prio
    | t |

    ((t := thread) isNil or:[t isDead]) ifTrue:[
        thread := 
            [
                [
                    ControlInterrupt handle:[:ex |
                        self isDebuggerJob ifTrue:[
                            Transcript showCR:'halt/breakpoint ignored in debugger job'.
                            ex proceed.
                        ].
                        ex reject
                    ] do:[    
                        running := true.
                        self process
                    ].    
                ] ensure: [
                    running := false.
                    thread := nil
                ].    
            ] newProcess.
        self setupThread: thread priority: prio.
        thread resume.
    ]

    "Created: / 29-07-2011 / 11:04:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:42:19 / cg"
    "Modified: / 21-02-2015 / 10:10:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop
    | t |

    (t := thread) isNil ifTrue:[^self].
    thread := nil.
    t terminate.
    "/ raise its prio to make it terminate quickly
    t priority:(Processor userSchedulingPriority + 1)

    "Created: / 28-04-2011 / 20:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:07:28 / cg"
! !

!AbstractBackgroundJob class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

