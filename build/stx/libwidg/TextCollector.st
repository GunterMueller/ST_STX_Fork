"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

EditTextView subclass:#TextCollector
	instanceVariableNames:'entryStream lineLimit destroyAction outstandingLines
		outstandingLine flushBlock flushPending inFlush collecting
		timeDelay access currentEmphasis alwaysAppendAtEnd collectSize
		autoRaise'
	classVariableNames:'TranscriptQuerySignal DebugSendersOfMessagePattern
		TraceSendersOfMessagePattern TimestampMessages DefaultLineLimit
		DefaultTimeDelay DefaultCollectSize'
	poolDictionaries:''
	category:'Views-Text'
!

!TextCollector class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a view for editable text, which also understands some stream messages.
    Instances of this view can take the place of a stream and display the 
    received text.
    Its main use in the system is the Transcript, but it can also be used for
    things like trace-windows, errorLogs etc.
    It is also inherited by TerminalView, which especially uses the buffering and
    delayed output features for high performance output (compare to a windows console).

    If collecting is turned on, a textcollector will not immediately display 
    entered text, but wait for some short time (timeDelay) and collect incoming 
    data - finally updating the whole chunk in one piece. 
    This helps slow display devices, which would otherwise scroll a lot. 
    (on fast displays this is less of a problem).

    The total number of lines kept is controlled by lineLimit, if more lines 
    than this limit are added at the bottom, the textcollector will forget lines 
    at the top. You can set linelimit to nil (i.e. no limit), but you may need a lot 
    of memory then ...

    [StyleSheet paramters (transcript only):]

        transcriptForegroundColor       defaults to textForegroundColor
        transcriptBackgroundColor'      defaults to textBackgroundColor.

        transcriptCursorForegroundColor
        transcriptCursorBackgroundColor

    [author:]
        Claus Gittinger

    [see also:]
        CodeView EditTextView
        ActorStream
"
! !

!TextCollector class methodsFor:'instance creation'!

initialize
    TranscriptQuerySignal isNil ifTrue:[
        TranscriptQuerySignal := QuerySignal new.
    ]
!

newTranscript
    "create and open a new transcript.
     This is a leftOver method from times were the Launcher & Transcript
     were two different views. It is no longer recommended."

    ^ self newTranscript:#Transcript

    "
     TextCollector newTranscript.
     Transcript lineLimit:3000.
    "

    "Modified: 17.2.1997 / 18:20:27 / cg"
!

newTranscript:nameSymbol
    "create and open a new transcript, unless one already exists by that name.
     The transcript is remembered in a global by that name.
     This is a leftOver method from times were the Launcher & Transcript
     were two different views. It is no longer recommended."

    |topView transcript defSz f v lines cols|

    transcript := Smalltalk at:nameSymbol.
    (transcript isTextView and:[transcript isOpen and:[transcript device == Screen current]]) ifTrue:[
        "if there is already an open Transcript on the same device, 
         do not open an additional one.
         expecco StandardLibrary <= 2.0.0.3 checked for Transcript>>#isStream and
         tries to opens a new Transcript window for each new Transcribe with expecco >=2.4"
        ^ transcript.
    ].

    topView := StandardSystemView label:nameSymbol "minExtent:(100 @ 100)".

    v := HVScrollableView for:self miniScrollerH:true miniScrollerV:false in:topView.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    transcript := v scrolledView.
    "transcript partialLines:false."

    f := transcript font.

    "
     should add the height of the frame & scrollbars to be exact ...
    "
    defSz := self defaultTranscriptSize.
    cols := defSz x.
    lines := defSz y.
    topView extent:(((f widthOf:'x') * cols) @ (f height * lines)).

    transcript beTranscript:nameSymbol.

    "
     run it at a slightly higher prio, to allow for
     delayed buffered updates to be performed
    "
    topView openWithPriority:(Processor userSchedulingPriority + 1).

    ^ transcript

    "
     TextCollector newTranscript:#T2.
     T2 showCR:'Hello world'.
     Smalltalk removeKey:#T2
    "

    "Modified: 17.2.1997 / 18:20:27 / cg"
! !

!TextCollector class methodsFor:'Signal constants'!

transcriptQuerySignal
    ^ TranscriptQuerySignal
! !

!TextCollector class methodsFor:'debugging'!

debugSendersOfMessagePattern
    ^ DebugSendersOfMessagePattern

    "Created: / 02-02-2012 / 12:05:27 / cg"
!

debugSendersOfMessagePattern:aGLOBMatchPattern
    "ever want to know, who sends a particular text-message to the transcript ?
     Call this with a match string and get a halt, when a matching text is sent to the transcript"

    DebugSendersOfMessagePattern := aGLOBMatchPattern asNilIfEmpty

    "
     self debugSendersOfMessagePattern:'no such*'
     self debugSendersOfMessagePattern:'remove*'
     self debugSendersOfMessagePattern:nil.
     self debugSendersOfMessagePattern:'*'.
    "

    "Modified: / 02-02-2012 / 12:07:11 / cg"
!

timestampMessages
    ^ TimestampMessages
!

timestampMessages:aBoolean
    "if true, all messages are shown with a timestamp in front"

    TimestampMessages := aBoolean 

    "
     self timestampMessages:true
     self timestampMessages:false.
    "
!

traceSendersOfMessagePattern
    ^ TraceSendersOfMessagePattern

    "Created: / 02-02-2012 / 12:05:32 / cg"
!

traceSendersOfMessagePattern:aGLOBMatchPattern
    "ever want to know, who sends a particular text-message to the transcript ?
     Call this with a match string and get a trace, when a matching text is sent to the transcript"

    TraceSendersOfMessagePattern := aGLOBMatchPattern asNilIfEmpty

    "
     self traceSendersOfMessagePattern:'removed unreached*'
     self traceSendersOfMessagePattern:nil.
     self traceSendersOfMessagePattern:'*'.
    "

    "Created: / 02-02-2012 / 11:59:22 / cg"
! !

!TextCollector class methodsFor:'defaults'!

defaultCollectSize
    "the number of lines buffered for delayed update.
     At most this number of lines to be shown are buffered (without redrawing),
     before a redraw is done. Thus, if a lot of output is generated fast,
     the redrawing is performed in chunks. 
     This has a significant effect on the performane, 
     as the view does not have to scroll and redraw for each
     individual line, but does junp-scrolling instead.
     See also defaultTimeDelay"

    ^ DefaultCollectSize ? 1000

    "Modified: / 27.7.1998 / 16:14:51 / cg"
!

defaultCollectSize:numberOfLines
    "the number of lines buffered for delayed update.
     At most this number of lines to be shown are buffered (without redrawing),
     before a redraw is done. Thus, if a lot of output is generated fast,
     the redrawing is performed in chunks. 
     This has a significant effect on the performane, 
     as the view does not have to scroll and redraw for each
     individual line, but does junp-scrolling instead.
     See also defaultTimeDelay"

    DefaultCollectSize := numberOfLines

    "Modified: / 27.7.1998 / 16:14:51 / cg"
!

defaultLineLimit
    "the number of lines remembered by default.
     Only the last n lines are remembered and can be seen by scrolling.
     Older lines are forgotten.
     This limit can be changed by the userPreferences dialog"

    ^ DefaultLineLimit ? 1000
!

defaultLineLimit:numberOfLines
    "the number of lines remembered by default.
     Only the last n lines are remembered and can be seen by scrolling.
     Older lines are forgotten.
     This limit can be changed by the userPreferences dialog"

    DefaultLineLimit := numberOfLines
!

defaultTimeDelay
    "the time in seconds to wait & collect by default.
     At most this number of seconds incoming text is buffered (without redrawing),
     before a redraw is done. Thus, if a lot of output is generated fast,
     the redrawing is performed in chunks. 
     This has a significant effect on the performane, 
     as the view does not have to scroll and redraw for each
     individual line, but does junp-scrolling instead.
     The value may be a float (eg. 0.5)
     See also defaultCollectSize"

    ^ DefaultTimeDelay ? 0.5 
!

defaultTimeDelay:seconds
    "the time in seconds to wait & collect by default.
     At most this number of seconds incoming text is buffered (without redrawing),
     before a redraw is done. Thus, if a lot of output is generated fast,
     the redrawing is performed in chunks. 
     This has a significant effect on the performane, 
     as the view does not have to scroll and redraw for each
     individual line, but does junp-scrolling instead.
     The argument may be a float (eg. 0.5)
     See also defaultCollectSize"

    DefaultTimeDelay := seconds 
!

defaultTranscriptSize
    "the number of cols/lines by which the Transcript should come up"

    ^ 70@11
! !

!TextCollector methodsFor:'Compatibility-ST80'!

deselect
    self unselect
!

flush
    self endEntry.
    super flush
! !

!TextCollector methodsFor:'accessing'!

autoRaise
    ^ autoRaise ? false
!

autoRaise:something
    autoRaise := something.
!

collect:aBoolean
    "turn on/off collecting - if on, do not output immediately
     but collect text and output en-bloque after some time delta"

    collecting := aBoolean
!

collectSize:numberOfLines
    "set the collect buffer size. If collect is enabled,
     the receiver will force update of the view, 
     whenever that many lines have been collected
     (or the updateTimeDelay interval has passed).
     With collect turned off, an immediate update is performed."

    collectSize := numberOfLines

    "Modified: / 27.7.1998 / 16:16:00 / cg"
!

destroyAction:aBlock
    "define the action to be performed when I get destroyed.
     This is a special feature, to allow resetting Transcript to Stderr
     when closed. (see TextCollectorclass>>newTranscript)"

    destroyAction := aBlock
!

entryStream
    ^ entryStream
!

lineLimit
    "return the number of text-lines I am supposed to hold when collecting.
     Nil means: unlimited"

    ^ lineLimit

    "
     Transcript lineLimit:5000
     Transcript lineLimit
    "

    "Modified: / 16.5.1998 / 01:33:52 / cg"
!

lineLimit:aNumber
    "define the number of text-lines I am supposed to hold"

    lineLimit := aNumber

    "
     Transcript lineLimit:5000
    "

    "Modified: / 16.5.1998 / 01:33:52 / cg"
!

updateTimeDelay:seconds
    "if collect is enabled, the receiver will update its view, 
     after that time delay (i.e. it collects output during that period),
     or when collectSize lines have been collected without update.
     With collect turned off, an immediate update is performed."

    timeDelay := seconds

    "Modified: / 27.7.1998 / 16:16:41 / cg"
! !

!TextCollector methodsFor:'event handling'!

exposeX:x y:y width:w height:h
    "flush buffered text when exposed"

    super exposeX:x y:y width:w height:h.
    "/ self endEntry
! !

!TextCollector methodsFor:'initialization & release'!

destroy
    "destroy this view"

    destroyAction value.
    super destroy

    "Modified: / 9.11.1998 / 21:18:17 / cg"
!

initialize
    super initialize.

    scrollWhenUpdating := #endOfText.

    outstandingLines := nil.
    alwaysAppendAtEnd := true.
    collectSize := self class defaultCollectSize.

    flushPending := inFlush := false.
    collecting := true.
    timeDelay := self class defaultTimeDelay.
    access := RecursionLock new name:'TextCollector access lock'.

    lineLimit := self class defaultLineLimit.
    entryStream := ActorStream new.
    entryStream nextPutBlock:[:something | self nextPut:something].
    entryStream nextPutAllBlock:[:something | self nextPutAll:something]

    "Modified: / 14.12.1999 / 21:13:54 / cg"
!

mapped
    "view became visible - show collected lines (if any)"

    super mapped.
    self endEntry
!

reinitialize
    "reinit after a snapIn.
     recreate access-semaphore; image could have been save (theoretically)
     with the semaphore locked - in this case, we had a deadlock"

    flushPending := inFlush := false.
    access := RecursionLock new. "/ Semaphore forMutualExclusion.
    super reinitialize.

    "Modified: / 5.3.1998 / 10:09:14 / stefan"
!

release
    flushBlock notNil ifTrue:[
        Processor removeTimedBlock:flushBlock.
        flushBlock := nil.
    ].
    outstandingLines := nil.
    outstandingLine := ''.

    super release

    "Modified: / 9.11.1998 / 21:18:17 / cg"
! !

!TextCollector methodsFor:'menu'!

editMenu
    "return my popUpMenu; that's the superClasses menu,
     plus a 'Line Limit' item."

    <resource: #programMenu>

    |m sub sensor|

    m := super editMenu.
    self showLineLimitInMenu ifTrue:[
        ((sensor := self sensor) notNil and:[sensor ctrlDown and:[sensor shiftDown not]]) ifTrue:[
            sub := m.
        ] ifFalse:[
            sub := m subMenuAt:#others.
        ].

        sub notNil ifTrue:[
            sub
                addItemList:#(
                    ('-'                                                                    )
                    ('Set Line Limit'               doSetLineLimit                         ))
                resources:resources
                after:#doPrint.
        ].
    ].
    
    ^ m.
! !

!TextCollector methodsFor:'menu - actions'!

doSetLineLimit
    |nLines|

    nLines := Dialog requestNumber:'Enter Line Limit:' initialAnswer:lineLimit.
    nLines notNil ifTrue:[
        self lineLimit:(nLines asInteger max:100).
    ].
! !

!TextCollector methodsFor:'private'!

checkLineLimit
    "this method checks if the text has become too large (> lineLimit)
     and cuts off some lines at the top if so; it must be called whenever lines
     have been added to the bottom"

    |nDel newCursorLine|

    lineLimit notNil ifTrue:[
        (cursorLine > lineLimit) ifTrue:[
            nDel := list size - lineLimit.
            self basicListRemoveFromIndex:1 toIndex:nDel.
            newCursorLine := cursorLine - nDel.
            firstLineShown := firstLineShown - nDel.
            (firstLineShown < 1) ifTrue:[
                newCursorLine := newCursorLine - firstLineShown + 1.
                firstLineShown := 1
            ].
            self setCursorLine:newCursorLine.
            self contentsChanged.
            self invalidate.
        ]
    ].
    self autoRaise ifTrue:[
        self topView 
            raise;
            "/ setForegroundWindow;
            yourself.
    ].

    "Modified: / 26-07-2006 / 16:02:15 / fm"
!

installDelayedUpdate
    "arrange for collecting input for some time,
     and output all buffered strings at once after a while.
     This makes output to the transcript much faster on systems
     with poor scrolling performance (i.e. dumb vga cards ...)."

    |p|

    flushPending ifFalse:[
        inFlush ifFalse:[
            flushPending := true.
            "
             we could run under a process, which dies in the meantime;
             therefore, we have to arrange for the transcript process to
             be interrupted and do the update.
            "
            windowGroup isNil ifTrue:[
                p := Processor timeoutHandlerProcess
            ] ifFalse:[
                p := windowGroup process
            ].
            (p isNil or:[p isSystemProcess]) ifTrue:[
                self endEntry
            ] ifFalse:[
                flushBlock isNil ifTrue:[
                    flushBlock := [self delayedEndEntry].
                ].
                Processor addTimedBlock:flushBlock for:p afterSeconds:timeDelay.
            ].
            p := nil.   "hack: avoid dangling references to p through the home context of flushBlock"
        ]
    ]

    "Modified: / 17.4.1997 / 13:03:15 / stefan"
    "Modified: / 9.11.1998 / 14:34:07 / cg"
!

senderTraceString
    "generate a sender trace string."

    |con|

    "/ skip over intermediate contexts
"/    con := con sender.
"/    con := thisContext sender sender.
"/    [ con receiver == self ] whileTrue:[
"/        con := con sender
"/    ].     
    con := DebugView interestingContextFrom:thisContext sender sender.
    ^ con printString

    "Created: / 02-02-2012 / 11:58:17 / cg"
! !

!TextCollector methodsFor:'queries'!

current
    "return the current (your screen's) transcript.
     In multiDisplay applications, this need NOT be the main transcript,
     as each display may have its own transcript.
     But typically, this is the same as Transcript."

    |theTranscript app|

    theTranscript := TranscriptQuerySignal query.
    theTranscript isNil ifTrue:[
        app := self topView application class current.
        (app notNil and:[thisContext isRecursive not]) ifTrue:[
            theTranscript := (app transcript ? Stderr).
        ] ifFalse:[
            theTranscript := Stderr.
        ]
    ].
    ^ theTranscript

    "
     Transcript current flash
    "

    "Created: / 05-07-1996 / 14:14:34 / cg"
    "Modified (comment): / 29-08-2013 / 11:04:55 / cg"
!

isStream
    "if I am the Transcript, I am used as a stream.
     See #displayOn:"

    ^ self == Transcript

    "
        Transcript isStream
    "
!

isTextCollector
    ^ true

    "
     Transcript isTextCollector
    "

    "Created: / 29-08-2013 / 11:32:46 / cg"
!

position
    "for compatibiliy with normal streams; return the column"

    ^ cursorCol
!

showLineLimitInMenu
    ^ true.
! !

!TextCollector methodsFor:'scrolling'!

makeCursorVisible
    (scrollLocked ? false) ifFalse:[
        access critical:[
            super makeCursorVisible
        ]
    ]
!

scrollLock:aBoolean
    aBoolean ifTrue:[
        scrollWhenUpdating := #endOfText.
    ] ifFalse:[
        scrollWhenUpdating := nil.
    ].
    scrollLocked := aBoolean.
!

scrollTo:anOrigin redraw:doRedraw
    access critical:[
        super scrollTo:anOrigin redraw:doRedraw
    ]
! !

!TextCollector methodsFor:'stream messages'!

addLine:line
    "append a line to the outstanding lines buffer"

    access critical:[
        outstandingLine size ~~ 0 ifTrue:[
            outstandingLine := outstandingLine , line
        ] ifFalse:[
            (TimestampMessages == true and:[self == Transcript]) ifTrue:[
                outstandingLine := Timestamp now printString,' ',line
            ] ifFalse:[
                outstandingLine := line
            ]
        ].
        "/ self ~~ Transcript ifTrue:['xa' printCR].
        outstandingLines isNil ifTrue:[
            outstandingLines := OrderedCollection with:outstandingLine
        ] ifFalse:[
            outstandingLines add:outstandingLine.
        ].
        outstandingLine := ''.

        collecting ifTrue:[
            flushPending ifFalse:[
                self installDelayedUpdate
            ] ifTrue:[
                outstandingLines size > collectSize ifTrue:[
                    self endEntry
                ]
            ]
        ] ifFalse:[
            self endEntry.
            self cursorReturn.
            self checkLineLimit.
            self cursorToEnd.
        ]
    ].

    "Created: / 28.7.1998 / 00:31:46 / cg"
    "Modified: / 28.7.1998 / 00:34:58 / cg"
!

cr
    "output a carriage return, finishing the current line"

    access critical:[
        |line|

        collecting ifTrue:[
            line := outstandingLine.
            (TimestampMessages == true and:[self == Transcript]) ifTrue:[
                outstandingLine size == 0 ifTrue:[
                    line := Timestamp now printString
                ].
            ].
            "/ self ~~ Transcript ifTrue:['xc' printCR].
            outstandingLines isNil ifTrue:[
                outstandingLines := OrderedCollection with:line
            ] ifFalse:[
                outstandingLines add:line.
            ].
            outstandingLine := ''.
            flushPending ifFalse:[
                self installDelayedUpdate
            ]
        ] ifFalse:[
            self cursorReturn.
            self checkLineLimit.
            self cursorToEnd.
        ].
    ].
!

display:someObject
    "dolphin compatibility"

    "/ someObject printOn:self.
    self nextPutAll: someObject asString.
!

doesNotUnderstand:aMessage
    "this is funny: all message we do not understand, are passed
     on to the stream which will send the characters via nextPut:
     This way, we understand all Stream messages - great isn't it!!"

    ^ aMessage sendTo:entryStream
!

ensureCr
    "if the output position is not already at the beginning of a line,
     output a carriage return"

    |needCR|

    collecting ifTrue:[
        needCR := outstandingLine notEmptyOrNil
    ] ifFalse:[
        needCR := cursorCol > 0
    ].

    needCR ifTrue:[
        self cr.
    ].

    "Created: / 14-09-2011 / 09:01:03 / cg"
!

format:formatSpec with:args
    "convenient formatted printing:
        %1..%9  - positional parameters from args-collection
        %(name) - named parameter from args-dictionary
        %%      - escape for %
        %<cr>   - cr (also tab, nl)"

    ^ entryStream format:formatSpec with:args

    "
     1 to: 10 do:[:i |
        Transcript 
            format:'[%1] Hello %2 World - this is %3%<cr>' 
            with:{i . 'my' . 'nice'}
     ].
    "
!

lineLength
    "to make a textCollector (somewhat) compatible with printer
     streams, support the lineLength query"

    ^ width // (gc font width)

    "Modified: 11.1.1997 / 14:42:41 / cg"
!

nextPut:something
    "append somethings printString to my displayed text.
     This allows TextCollectors to be used Stream-wise"

    |txt|

    (something isCharacter) ifTrue:[
        ((something == Character cr) or:[something == Character nl]) ifTrue:[
            ^ self cr
        ].
    ].

    txt := something asString.
    currentEmphasis notNil ifTrue:[
        txt := txt emphasizeAllWith:currentEmphasis
    ].
    self show:txt.

"/    flushPending ifTrue:[
"/        self endEntry
"/    ].
"/    (something isMemberOf:Character) ifTrue:[
"/        ((something == Character cr) or:[something == Character nl]) ifTrue:[
"/            ^ self cr
"/        ].
"/        self insertCharAtCursor:something
"/    ] ifFalse:[
"/        self insertStringAtCursor:(something printString).
"/        self checkLineLimit
"/    ].
"/    device flush

    "Modified: 11.1.1997 / 14:43:05 / cg"
!

nextPutAll:something
    "append all of something to my displayed text.
     This allows TextCollectors to be used Stream-wise"

    self show:(currentEmphasis notNil 
                ifTrue:[something emphasizeAllWith:currentEmphasis]
                ifFalse:[something])

    "Modified: 11.1.1997 / 14:43:26 / cg"
!

nextPutAll:count from:buffer startingAt:initialPosition
    "append count characters from buffer starting at initialPosition to my displayed text.
     This allows TextCollectors to be used Stream-wise"

    |stringToShow|

    stringToShow := buffer copyFrom:initialPosition to:initialPosition+count-1.

    self show:(currentEmphasis notNil 
                ifTrue:[stringToShow emphasizeAllWith:currentEmphasis]
                ifFalse:[stringToShow]).
    ^ count.

    "Modified: 11.1.1997 / 14:43:26 / cg"
!

printf:formatSpec
    "convenient C-style formatted printing"

    ^ entryStream printf:formatSpec

    "
     1 to: 10 do:[:i |
        Transcript printf:'Hello World\n'
     ].
    "
!

printf:formatSpec with:arg1
    "convenient C-style formatted printing with 1 argument"

    ^ entryStream printf:formatSpec with:arg1

    "
     1 to: 10 do:[:i |
        Transcript printf:'[%d] Hello World\n' with:i
     ].
    "
!

printf:formatSpec with:arg1 with:arg2
    "convenient C-style formatted printing with 2 arguments"

    ^ entryStream printf:formatSpec with:arg1 with:arg2

    "
     1 to: 10 do:[:i |
        Transcript 
            printf:'[%d] Hello World\n' with:i
     ].
    "
!

printf:formatSpec with:arg1 with:arg2 with:arg3
    "convenient C-style formatted printing with 3 arguments"

    ^ entryStream printf:formatSpec with:arg1 with:arg2 with:arg3

    "
     1 to: 10 do:[:i |
        Transcript 
            printf:'[%d] Hello World\n' with:i
     ].
    "
!

printf:formatSpec with:arg1 with:arg2 with:arg3 with:arg4
    "convenient C-style formatted printing"

    ^ entryStream printf:formatSpec with:arg1 with:arg2 with:arg3 with:arg4

    "
     1 to: 10 do:[:i |
        Transcript 
            printf:'[%d] Hello World\n' with:i
     ].
    "
!

printf:formatSpec with:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "convenient C-style formatted printing"

    ^ entryStream printf:formatSpec with:arg1 with:arg2 with:arg3 with:arg4 with:arg5

    "
     1 to: 10 do:[:i |
        Transcript 
            printf:'[%d] Hello World\n' with:i
     ].
    "
!

printf:formatSpec withAll:args
    "convenient C-style formatted printing with an arbitrary number of arguments"

    ^ entryStream printf:formatSpec withAll:args

    "
     1 to: 10 do:[:i |
        Transcript 
            printf:'[%d] Hello %s World - this is %s\n' 
            with:{i . 'my' . 'nice'}
     ].
    "
!

println
    "for those used to Java/Javascript, a compatibility message.
     Most useful inside expecco"

    self cr
!

println:anObject
    "for those used to Java/Javascript, a compatibility message.
     Most useful inside expecco"

    self showCR:anObject
!

show:anObject
    "insert the argument aString at current cursor position"

    |printString lines|

    printString := anObject printString.

    (self == Transcript) ifTrue:[
        DebugSendersOfMessagePattern notNil ifTrue:[
            (DebugSendersOfMessagePattern match:printString string) ifTrue:[
                "to disable this breakpoint in the future, evaluate:
                     DebugSendersOfMessagePattern := nil
                "
                self halt:('Transcript: text matches: "', printString,'"').
            ].
        ].
        TraceSendersOfMessagePattern notNil ifTrue:[
            (TraceSendersOfMessagePattern match:printString string) ifTrue:[
                printString := self senderTraceString,': ',printString
            ].
        ].
    ].

    (printString includes:(Character cr)) ifTrue:[
        lines := printString asStringCollection.
        lines keysAndValuesDo:[:nr :line |
            (nr == lines size 
            and:[(printString endsWith:(Character cr)) not]) ifTrue:[
                "/ the last one.
                self show:line
            ] ifFalse:[
                self showCR:line
            ].
        ].
        ^ self.
    ].

    access critical:[
        "/ self ~~ Transcript ifTrue:['xs' printCR].
        outstandingLine size ~~ 0 ifTrue:[
            outstandingLine := outstandingLine , printString
        ] ifFalse:[
            outstandingLine := printString
        ].
        collecting ifTrue:[
            flushPending ifFalse:[
                self installDelayedUpdate
            ] ifTrue:[
                outstandingLines size > collectSize ifTrue:[
                    self endEntry
                ]
            ]
        ] ifFalse:[
            self endEntry
        ]
    ].

    "Modified: / 24-03-2012 / 20:04:10 / cg"
    "Modified (format): / 02-06-2012 / 01:54:55 / cg"
!

showCR:anObject
    "insert the argument aString at current cursor position,
     and advance to the next line. This is the same as a #show:
     followed by a #cr."

    |printString lines crlf|

"/ self ~~ Transcript ifTrue:[ ^ self tshow:anObject].
    printString := anObject printString.
    printString size == 0 ifTrue:[
        self cr.
        ^ self.
    ].

    self == Transcript ifTrue:[
        DebugSendersOfMessagePattern notNil ifTrue:[
            (DebugSendersOfMessagePattern match:printString string) ifTrue:[
                "/ to disable this right from inside the debugger, evaluate:
                "
                 DebugSendersOfMessagePattern := nil
                "
                self halt:('Transcript: text matches: "', printString, '"').
            ].
        ].
        TraceSendersOfMessagePattern notNil ifTrue:[
            (TraceSendersOfMessagePattern match:printString string) ifTrue:[
                printString := self senderTraceString,': ',printString
            ].
        ].
    ].

    crlf := String crlf.
    (printString includesAny:crlf) ifTrue:[
        lines := printString asStringCollection.
        lines do:[:line|
            |lineWithoutEOL|

            (line endsWith:Character nl) ifTrue:[
                (line endsWith:crlf) ifTrue:[
                    lineWithoutEOL := line copyButLast:2.
                ] ifFalse:[
                    lineWithoutEOL := line copyButLast:1.
                ]
            ] ifFalse:[
                (line endsWith:Character return) ifTrue:[
                    lineWithoutEOL := line copyButLast:1.
                ] ifFalse:[
                    lineWithoutEOL := line
                ]
            ].
            self addLine:lineWithoutEOL.
        ].
        ^ self.
    ].
    self addLine:printString

    "Modified: / 24-03-2012 / 20:00:08 / cg"
!

space
    self show:' '
!

tab
    "append a tab-character to the stream.
     This is only allowed, if the receiver supports writing."

    self nextPut:(Character tab)
! !

!TextCollector methodsFor:'stream messages-emphasis'!

bgColor:aColor
    aColor isNil ifTrue:[
        currentEmphasis := Text removeEmphasis:#backgroundColor from:currentEmphasis
    ] ifFalse:[
        currentEmphasis := Text addEmphasis:(#backgroundColor->aColor) to:currentEmphasis
    ]
!

bold
    "switch to bold - followup text sent via show/nextPutAll: will be inserted in
     a bold font."

    currentEmphasis := Text addEmphasis:#bold to:currentEmphasis
!

color:aColor
    aColor isNil ifTrue:[
        currentEmphasis := Text removeEmphasis:#color from:currentEmphasis
    ] ifFalse:[
        currentEmphasis := Text addEmphasis:(#color->aColor) to:currentEmphasis
    ].

    "Modified: / 26.3.1999 / 14:29:21 / cg"
!

italic
    currentEmphasis := Text addEmphasis:#italic to:currentEmphasis
!

normal
    currentEmphasis := nil
!

notBold
    "switch to non-bold - followup text sent via show/nextPutAll: will be inserted in
     a non-bold font."

    currentEmphasis := Text removeEmphasis:#bold from:currentEmphasis
!

notItalic
    "switch to non-italic - followup text sent via show/nextPutAll: will be inserted in
     a non-italic font."

    currentEmphasis := Text removeEmphasis:#italic from:currentEmphasis
!

notReverse
    currentEmphasis := Text removeEmphasis:#color from:currentEmphasis.
    currentEmphasis := Text removeEmphasis:#backgroundColor from:currentEmphasis.
!

notUnderline
    currentEmphasis := Text removeEmphasis:#underline from:currentEmphasis

    "Created: / 26.3.1999 / 14:27:07 / cg"
!

reverse
    currentEmphasis := Text addEmphasis:(#color->bgColor) to:currentEmphasis.
    currentEmphasis := Text addEmphasis:(#backgroundColor->fgColor) to:currentEmphasis.
!

underline
    currentEmphasis := Text addEmphasis:#underline to:currentEmphasis

    "Created: / 26.3.1999 / 14:27:07 / cg"
! !

!TextCollector methodsFor:'transcript specials'!

beTranscript
    "make the receiver be the systemTranscript; this one
     is accessible via the global Transcript and gets relevant
     system messages from various places."

    self beTranscript:#Transcript

    "Modified: / 2.11.1997 / 22:34:47 / cg"
!

beTranscript:name
    "make the receiver be the systemTranscript; this one
     is accessible via the global Transcript and gets relevant
     system messages from various places."

    |fg bg cFg cBg|

    self assert:((Smalltalk includesKey:name) not
                or:[ (Smalltalk at:name) isBehavior not ]). 
    Smalltalk at:name put:self.

    "
     fancy feature: whenever Transcript is closed, reset to StdError
    "
    self destroyAction:[
        self == (Smalltalk at:name) ifTrue:[
            Smalltalk at:name put:Stderr
        ]
    ].

    "/ user may prefer a special color for this one;
    "/ look into the style definitions ...

    fg := styleSheet colorAt:'transcript.foregroundColor' default:self foregroundColor.
    bg := styleSheet colorAt:'transcript.backgroundColor' default:self backgroundColor.
    self foregroundColor:fg backgroundColor:bg.
    self viewBackground:bg.

    cFg := styleSheet colorAt:'transcript.cursorForegroundColor' default:bg.
    cBg := styleSheet colorAt:'transcript.cursorBackgroundColor' default:fg.
    self cursorForegroundColor:cFg backgroundColor:cBg. 

    "self lineLimit:1000. " "or whatever you think makes sense"

    "Modified: / 2.11.1997 / 22:34:47 / cg"
!

beginEntry
    "noop for now, ST80 compatibility"

    ^ self

    "Created: / 4.3.1998 / 11:08:14 / stefan"
!

clear
    self endEntry.
    self contents:nil.

    "
     Transcript clear
    "
!

delayedEndEntry
    "flush collected output; displaying all that has been buffered so far"

    "/ self ~~ Transcript ifTrue:[ 'de0' printCR ].
    inFlush ifTrue:[
        "/ self ~~ Transcript ifTrue:[ 'deX' printCR ].
        ^ self
    ].

    "/ self ~~ Transcript ifTrue:[ 'de1' printCR ].
    access owner == Processor activeProcess ifTrue:[
        "/ self ~~ Transcript ifTrue:[ 'de2' printCR ].
        self installDelayedUpdate.
        ^ self
    ].

    self endEntry
!

endEntry
    "flush collected output; displaying all that has been buffered so far"

    |nLines lines|

    ((outstandingLines isEmptyOrNil) and:[outstandingLine isEmptyOrNil]) ifTrue:[
        "/ self ~~ Transcript ifTrue:[ 'e- ' print. thisContext sender selector printCR ].
        ^ self
    ].
    shown ifFalse:[
        "/ when iconified or not yet shown, keep
        "/ collecting. But not too much ...
        outstandingLines size < 300 ifTrue:[
            "/ self ~~ Transcript ifTrue:[ 'eC' printCR ].
            access critical:[
                flushPending ifFalse:[
                    self installDelayedUpdate.
                ].
            ].
            ^ self
        ]
    ].

    (device isNil or:[device isOpen not or:[self drawableId isNil]]) ifTrue:[
        "on snapshot load, Transcript may not yet be re-created.
         Write to Stderr then."
        Stderr notNil ifTrue:[
            outstandingLines do:[:eachLine|
                eachLine printOn:Stderr.
            ].
            outstandingLines := nil.
            outstandingLine notNil ifTrue:[
                outstandingLine printOn:Stderr.
                outstandingLine := nil.
            ].
            Stderr cr.
        ].
        ^ self.
    ].

    "/ self ~~ Transcript ifTrue:[ 'e ' print. 
    "/    thisContext fullPrintAll.
    "/ ].

"/    access owner == Processor activeProcess ifTrue:[
"/self ~~ Transcript ifTrue:[ 'eI' printCR ].
"/        self installDelayedUpdate.
"/        ^ self
"/    ].

    access critical:[
        collecting ifTrue:[
            flushBlock notNil ifTrue:[
                Processor removeTimedBlock:flushBlock.
            ].
"/            flushPending ifFalse:[
"/self ~~ Transcript ifTrue:[ 'eP' printCR ].
"/                ^ self
"/            ].
        ].

        "/ self ~~ Transcript ifTrue:[ 'e1' printCR ].
        inFlush ifFalse:[
            "/ self ~~ Transcript ifTrue:[ 'e2' printCR ].
            inFlush := true.
            [
                flushPending := false.
self withAutoIndent:false do:[
                "/ self ~~ Transcript ifTrue:[ 'e3 "' print. outstandingLine print. '" ' print. outstandingLine asByteArray hexPrintString print. ' ' printCR. 
                "/                             (outstandingLines ? #()) do:[:l | '"' print. l print. '" ' print. l asByteArray hexPrintString printCR ]].
                (nLines := outstandingLines size) ~~ 0 ifTrue:[
                    "/ self ~~ Transcript ifTrue:[ 'e4' printCR.].
                    "insert the bunch of lines - if any"
                    lines := outstandingLines.
                    outstandingLines := nil.

                    "/ self ~~ Transcript ifTrue:[ 'e5 ' print. nLines printCR.].
                    (nLines ~~ 0) ifTrue:[
                        self isInInsertMode ifTrue:[
                            "/ self ~~ Transcript ifTrue:[ (nLines > 1 and:[(lines second ? '') startsWith:'111']) ifTrue:['e6a' printCR.self halt.]].
                            self insertLines:lines withCR:true.
                            "/ self ~~ Transcript ifTrue:[ (nLines > 1 and:[(lines second ? '') startsWith:'111']) ifTrue:['e6a' printCR.self halt.]].
                        ] ifFalse:[
                            self replaceLines:lines withCR:true
                        ].
                        alwaysAppendAtEnd ifTrue:[
                            self cursorToEnd.
                        ].
                        (cursorLine >= (firstLineShown + nFullLinesShown)) ifTrue:[
                            scrollLocked ifFalse:[
                                self withCursorOffDo:[
                                    self scrollDown:nLines
                                ]
                            ].
                        ].
                    ].
                ].

                "/ self ~~ Transcript ifTrue:[ (nLines > 1 and:[(lines second ? '') startsWith:'111']) ifTrue:['e7a' printCR.self halt.]].
                "and the last partial line - if any"
                outstandingLine size ~~ 0 ifTrue:[
                    self isInInsertMode ifTrue:[
                        self insertStringAtCursor:outstandingLine.
                    ] ifFalse:[
                        self replaceStringAtCursor:outstandingLine.
                    ].
                    outstandingLine := ''.
                ].
                self checkLineLimit.
                "/ device flush.
].
            ] ensure:[
                inFlush := false.
            ]
        ].
"/        flushPending ifTrue:[
"/            flushPending := false.
"/            self installDelayedUpdate
"/        ]
    ].

    "Modified: / 9.11.1998 / 21:17:56 / cg"
!

flash
    "make sure everything is visible, before flashing"

    self endEntry.
    super flash.
!

flash:message withColor:flashColor
    "make sure everything is visible, before flashing"

    self endEntry.
    super flash:message withColor:flashColor.
! !

!TextCollector class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


TextCollector initialize!
