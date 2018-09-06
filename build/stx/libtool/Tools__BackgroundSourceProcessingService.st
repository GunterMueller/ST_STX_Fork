"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

CodeViewService subclass:#BackgroundSourceProcessingService
	instanceVariableNames:'job done modified'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!BackgroundSourceProcessingService class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    An abstract base class for all services that process current
    (displayed) source code. All processing is done in background
    job, that is restarted whenever a text in the editor is changed.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        job         <BackgroundJob> A background job.

    [class variables:]

    [see also:]

"
! !

!BackgroundSourceProcessingService class methodsFor:'queries'!

isAbstract

    ^self == Tools::BackgroundSourceProcessingService

    "Created: / 24-01-2012 / 12:27:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundSourceProcessingService methodsFor:'accessing-defaults'!

defaultJobName
    "Returns a human-readable job name, to ease identification in process browser"

    ^ 'CodeView2''s source processing job'

    "Created: / 24-01-2012 / 12:05:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundSourceProcessingService methodsFor:'change & update'!

modelChanged
    "Model has changed (i.e. value holder keeping displayed text"

    self sourceChanged: true

    "Created: / 17-03-2012 / 15:45:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceChanged:force
    "Called when codeview's text changes"

    (force or:[codeView reallyModified]) ifTrue:[
        self process.
        "/ cg: tried to avoid multiple processing,
        "/ but it seems to not help - still doing multiple
        "/ when clicking on a new method in a mixed-class-method list
        "/ (one for the method-class, one for the source)
        "/ codeView sensor enqueueMessage:#process for:self arguments:nil "/  self process
    ].

    "Modified: / 22-08-2011 / 13:51:53 / cg"
    "Modified (format): / 05-09-2011 / 05:06:40 / cg"
    "Modified: / 17-03-2012 / 16:04:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:aspect with:param from:sender 
    textView notNil ifTrue:[
        "/sender == textView modifiedChannel ifTrue:[^self codeChanged: false].
        sender == textView model ifTrue:[
            sender value ~= textView contents ifTrue:[
                self modelChanged.
                ^self.
            ].
        ].
        (sender == textView and:[aspect == #sizeOfContents]) ifTrue:[
            self sourceChanged:true.
            ^self.
        ].
    ].
    codeView notNil ifTrue:[
        sender == codeView languageHolder ifTrue:[
            self sourceChanged:true.
            ^self
        ].
        sender == codeView classHolder ifTrue:[
            self sourceChanged:true.
            ^self
        ].
    ].

    aspect == #codeAspect ifTrue:[
        self sourceChanged:true.
        ^self
    ].

    super 
        update:aspect
        with:param
        from:sender

    "Created: / 06-03-2010 / 19:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-09-2011 / 12:00:29 / cg"
    "Modified: / 22-02-2012 / 15:02:16 / jv"
    "Modified: / 15-04-2013 / 23:00:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundSourceProcessingService methodsFor:'event handling'!

linesDeletedFrom:start to:end 
    self sourceChanged:true

    "Created: / 06-07-2011 / 17:14:36 / jv"
    "Created: / 16-09-2011 / 15:18:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesInsertedFrom:start to:end 
    self sourceChanged:true

    "Created: / 06-07-2011 / 17:14:36 / jv"
    "Created: / 16-09-2011 / 15:18:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesModifiedFrom:start to:end 
    self sourceChanged:true

    "Created: / 06-07-2011 / 17:14:36 / jv"
    "Created: / 16-09-2011 / 15:15:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundSourceProcessingService methodsFor:'initialization'!

initialize
    job := (Smalltalk at:#BackgroundJob) 
                named:self defaultJobName
                on:[self processSafely: true]

    "Created: / 29-07-2011 / 10:31:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2012 / 16:17:21 / cg"
    "Modified: / 25-02-2014 / 19:58:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundSourceProcessingService methodsFor:'processing'!

process
    "(Re)starts the processing job. Should be called whenever a source 
     must be (re)processed."

    | prio browser |

    "/ this clobbers the codeViews modified state; therefore, we have to remember
    "/ this info somewhere ...
    (browser := codeView browser) notNil ifTrue:[
        textView modified ifTrue:[
            browser navigationState realModifiedState: true
        ].
        textView modifiedChannel setValue:false.
    ].

    job scheduled ifTrue:[
        job running ifFalse:[
            "/ process already created, but did not get a change to start yet;
            ^ self
        ].
        job stop.
    ].
    prio := (Processor activePriority - 1) min:Processor userBackgroundPriority.
    job startWithPriority: prio.

    "Modified: / 07-07-2011 / 12:26:12 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Created: / 24-01-2012 / 12:15:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-06-2012 / 23:58:20 / cg"
!

process: delayed
    "Actually process source code. If `delayed` is true, view should be updated
     asynchronously using #pushUserEvent:. Individual services should override
     this method.

     NOTE: Do not call this method from custom code directly, always call
     #processSafely: which handle possible errors and protect against
     'debugger bomb'
     "

    self subclassResponsibility

    "Created: / 24-01-2012 / 12:25:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-02-2014 / 19:52:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processSafely: delayed
    "Process source code. If `delayed` is true, view should be updated
     asynchronously using #pushUserEvent:"

    DebugView 
        withOptionToIgnoreException:(BreakPointInterrupt,HaltInterrupt,Error) 
        do:[
            (Error , HaltInterrupt , BreakPointInterrupt) handle:[:ex|
                "/ Kludge...    
                (codeView topView class == DebugView) ifTrue:[
                    Transcript showCR: 'Error when processing source code'.
                    ex suspendedContext fullPrintAllOn: Transcript.
                    ex return.
                ].
                ex reject "/ go ask for debugging
            ] do:[
                self process: delayed
            ]
        ]

    "Created: / 25-02-2014 / 19:57:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-03-2015 / 15:56:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundSourceProcessingService methodsFor:'registering'!

registerIn: aCodeView

    super registerIn: aCodeView.
    textView addDependent: self.

    "Created: / 27-07-2011 / 13:25:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregister
    job stop.
    textView removeDependent: self.     
    super unregister.

    "Created: / 13-06-2014 / 15:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-08-2014 / 06:57:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BackgroundSourceProcessingService class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

