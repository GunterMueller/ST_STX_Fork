"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2016 Jan Vrany
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

AbstractBackgroundJob subclass:#BackgroundQueueProcessingJob
	instanceVariableNames:'queue queueAccessLock queueProcessedSema'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!BackgroundQueueProcessingJob class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2016 Jan Vrany
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
    A BackgroundQueueProcessingJob is a specialized form
    of a BackgroundJob for background processing of a queue.
    Each item in the queue (added by sending #add: item) 
    is processed (using the instance variable job).

    Implementation notes:
    The thread is running only if there is at least one item
    to process. When the queue is empty, the thread teminates.
    It is started again when a new item is added to the queue.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        queue       <OrderedCollection>     the queue of items to be procesed
        queueAccessLock<RecursionLock>      a lock used to synchronize
                                            access to the queue
        queueProcessedSema<Semaphore>       a semaphore signaled when the queue is
                                            processed (and therefore empty).
    [class variables:]

    [see also:]
        BackgroundJob

"
!

examples
"
    | job text |
    job :=  BackgroundQueueProcessingJob named: 'example job' on:[:text|
                Delay waitForSeconds: 3.
                Transcript showCR:'One guy said: ', text
            ].
    job add:'Hello world'. 
    Delay waitForSeconds: 5.
    job add:'Ahoj Svete!!'.
    job restart.
    Delay waitForSeconds: 1.
    job add:'Haya, looks like proper queue, you should see all greetings'.

"
! !

!BackgroundQueueProcessingJob methodsFor:'accessing-private'!

queue
    "Returns the internal queue."

    ^ queue

    "Modified (format): / 16-04-2014 / 15:11:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

queueAccessLock
    "Returns the internal lock used to protect internal queue"

    ^ queueAccessLock

    "Modified (comment): / 16-04-2014 / 15:11:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob methodsFor:'adding & removing'!

add: object

    ^self add: object at: nil

    "Created: / 28-04-2011 / 20:40:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:43:01 / cg"
    "Modified: / 07-09-2011 / 12:35:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

add: object at: index
    queueAccessLock critical:[
        (queue includes: object) ifFalse:[
            index notNil ifTrue:[
                queue add: object at: index
            ] ifFalse:[
                queue add: object
            ]
        ].
        self start
    ].

    "Modified (format): / 03-08-2011 / 16:43:01 / cg"
    "Created: / 07-09-2011 / 12:34:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    super initialize.
    queue := OrderedCollection new.
    queueAccessLock := RecursionLock new.
    queueProcessedSema := Semaphore new.

    "Modified: / 06-12-2011 / 15:50:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob methodsFor:'private'!

setupThread: t priority: p
    "Sets up worker thread"

    super setupThread: t priority: p.
    t addExitAction: [ queueProcessedSema signalForAll ].

    "Created: / 20-01-2012 / 16:40:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob methodsFor:'processing'!

process

    | cookie item |

    cookie := 'cookie'.
    [
        item := cookie.
        queueAccessLock critical:[
            queue notEmpty ifTrue:[item := queue removeFirst]
        ].
        item ~~ cookie ifTrue:[
            self processItem: item
        ].
        item ~~ cookie.
    ] whileTrue.

    "Created: / 28-04-2011 / 20:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-08-2011 / 16:43:21 / cg"
    "Modified: / 20-01-2012 / 16:39:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processItem: item

    ^job value: item

    "Created: / 28-04-2011 / 20:36:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob methodsFor:'queries'!

numberOfItemsInQueue
    "Returns number of items waiting to be processed. 
     May not be accurate as there is no synchronization
     (intentionally, for performance reasons)"
    
    ^ queue size

    "Created: / 06-12-2011 / 16:01:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob methodsFor:'start & stop'!

stopAndRemoveAll
    "Terminates queue processing and remove all pending
     items in a queue"

    self stop.
    queueAccessLock critical:[
        queue := OrderedCollection new.
    ]

    "Created: / 09-04-2012 / 17:18:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob methodsFor:'utilities'!

waitUntilProcessed
    "Blocks the receiver until all items from the queue are processed.
    NOTE, that it may block forever if another thread is filling queue
    fast enough."

    | shouldWait |        
    queueAccessLock critical:[
        shouldWait := queue notEmpty.
    ].
    shouldWait ifTrue:[
        self start.
        queueProcessedSema wait.
    ]

    "
    queueProcessedSema signalForAll    
    "

    "Created: / 06-12-2011 / 15:58:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundQueueProcessingJob class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/BackgroundQueueProcessingJob.st,v 1.17 2015-02-21 10:03:53 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/BackgroundQueueProcessingJob.st,v 1.17 2015-02-21 10:03:53 vrany Exp $'
!

version_SVN
    ^ '$Id: BackgroundQueueProcessingJob.st,v 1.17 2015-02-21 10:03:53 vrany Exp $'
! !

