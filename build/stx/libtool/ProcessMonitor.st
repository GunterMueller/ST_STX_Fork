"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

SystemStatusMonitor subclass:#ProcessMonitor
	instanceVariableNames:'processes hideDead runColor suspendedColor waitColor cpuUsages
		showDetail'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

!ProcessMonitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    >>> This class has been obsoleted by ProcessMonitorV2 <<<

    This view shows smalltalks (light-weight) processes, and also offers
    a popup menu for various useful operations on them.
    Especially 'debug' is useful, to see what a process is currently
    doing.

    The information shown is:
        id         - the numeric id of the process
        name       - the name (if any) of the process
                     (the name has no semantic meaning; it exists for the processMonitor only)
        state      - what is it doing;
                        wait      - waiting on a semaphore
                        eventWait - waiting on a view-event semaphore
                        ioWait    - waiting on an io-semaphore
                        timeWait  - waiting for a time-semaphore
                        run       - run, but currently not scheduled
                        active    - really running (this info is useless, since at
                                    update time, its always the update process which is
                                    running)
                        suspended - suspended; not waiting on a semaphore
                        light     - not yet started (i.e. has no stack yet)
        
        prio       - the processes priority (1..30)
        usedStack  - the current stack use
        totalStack - the stack currently allocated (i.e. the maximum ever needed)

    [see also:]
        Process ProcessorScheduler
        WindowGroup
        SemaphoreMonitor

    [author:]
        Claus Gittinger

    [start with:]
        ProcessMonitor open
"
! !

!ProcessMonitor class methodsFor:'defaults'!

defaultIcon
    |i|

    i := Image fromFile:'ProcMon.xbm'.
    i notNil ifTrue:[^ i].
    ^ super defaultIcon

    "Modified: 23.1.1997 / 02:52:31 / cg"
!

defaultLabel
    ^ 'Process Monitor'
!

nameLengthInList
    ^ 30

    "Created: 21.8.1997 / 15:42:05 / cg"
! !

!ProcessMonitor methodsFor:'drawing'!

titleLine
    showDetail ifTrue:[
        Processor supportDynamicPriorities ifTrue:[
            ^ 
'Id     Group  Name                            State     Prio       UsedStack    TotalStack  Current-Segment      Switch  Where'.
        ].
        ^ 
'Id     Group  Name                            State    Prio UsedStack    TotalStack  Current-Segment      Switch  Where'.
    ].
    ^ 
'Id     Group  Name                            State    Prio Where                                           '.

    "Modified: / 3.7.1996 / 13:57:38 / stefan"
    "Modified: / 3.8.1998 / 23:20:24 / cg"
!

updateList
    "update list of processes"

    |newList|

    shown ifTrue:[
        newList := self getProcessList.

        "sort by id - take care of nil ids of dead processes"
        newList sort:[:p1 :p2 |
                         |id1 id2|

                         (p1 isNil or:[(id1 := p1 id) isNil])
                             ifTrue:[true]
                             ifFalse:[
                                 (p2 isNil or:[(id2 := p2 id) isNil])
                                     ifTrue:[false]
                                     ifFalse:[id1 < id2]
                         ]
                     ].
        newList ~= processes ifTrue:[
            self updateStatus:newList
        ].
    ].
    updateBlock notNil ifTrue:[
        Processor removeTimedBlock:listUpdateBlock.
        Processor addTimedBlock:listUpdateBlock afterSeconds:listUpdateDelay
    ].

    "Modified: / 3.7.1996 / 13:37:29 / stefan"
    "Modified: / 14.12.1999 / 20:50:14 / cg"
!

updateStatus:newProcessList
    "update status display of processes"

    |oldList list line dIndex interrupted contextCount 
     aProcess nm st n found running sel space oldSelection
     newSelection numHeaderLines nameLength index
     con c sender id gId r skipping startTime endTime deltaT|

    startTime := Timestamp now.

    numHeaderLines := 2.
    space := Character space.
    nameLength := self class nameLengthInList.

    shown ifTrue:[
        oldList := listView list.

        oldSelection := listView selection.
        oldSelection notNil ifTrue:[
            oldSelection := oldSelection collect:[:idx | |pI|
                                            pI := idx-numHeaderLines.
                                            (pI > processes size or:[pI < 1]) ifTrue:[
                                                nil
                                            ] ifFalse:[
                                                processes at:pI
                                            ]
                                         ].
            newSelection := OrderedCollection new.
        ].

        newProcessList notNil ifTrue:[
            processes := WeakArray withAll:newProcessList.
        ].
        processes notNil ifTrue:[

            list := OrderedCollection new:(processes size + numHeaderLines).
            list add:self titleLine.
            list add:(String new:self titleLine size withAll:$-).

            interrupted := Processor interruptedProcess.

            dIndex := 1.
            index := 1.

            "/ use while-loop;
            "/ processList may change size ....

            [index <= processes size] whileTrue:[
                aProcess := processes at:index.
                index := index + 1.

                (aProcess notNil 
                and:[aProcess ~~ 0]) ifTrue:[
                    ((id := aProcess id) notNil or:[hideDead not]) ifTrue:[
                        line := WriteStream on:(String uninitializedNew:200).

                        id printOn:line paddedTo:7.
                        gId := aProcess processGroupId.
                        ((gId == id) or:[gId isNil]) ifTrue:[
                            "/ a group leader
                            '-      ' printOn:line.
                        ] ifFalse:[
                            gId printOn:line paddedTo:7.
                        ].

                        (nm := aProcess name) isNil ifFalse:[
                            nm := nm printStringPaddedTo:(nameLength-1).
                            nm size >= nameLength ifTrue:[
                                nm := (nm contractTo:(nameLength-1)).
                            ].
                            line nextPutAll:nm; nextPut:space.
                        ] ifTrue:[
                            line next:(nameLength) put:space.
                        ].
"/                        n := cpuUsages at:(id) ifAbsent:[0].
"/                        n ~~ 0 ifTrue:[
"/                            line := line , ((n * 4) printStringLeftPaddedTo:3)
"/                        ] ifFalse:[
"/                            line := line , '   '
"/                        ].
                        st := aProcess state.
                        (st == #run
                         and:[aProcess == interrupted]) ifTrue:[
                            c := ' *'.
                            running := true.
                        ] ifFalse:[
                            [
                                (Processor scheduledProcesses includes:aProcess) ifTrue:[
                                    c := ' +'
                                ] ifFalse:[
                                    c := '  '.
                                ].
                            ] valueUninterruptably.
                            running := false.
                        ].
                        line nextPutAll:c; nextPutAll:(st printStringPaddedTo:9).
                        line nextPutAll:(aProcess priority printStringLeftPaddedTo:3).

                        (showDetail 
                        and:[Processor supportDynamicPriorities]) ifTrue:[
                            (r := aProcess priorityRange) isNil ifTrue:[
                                line nextPutAll:'       '.
                            ] ifFalse:[
                                line nextPutAll:((
                                    ' ['  
                                    , (r start printString)
                                    , '..'
                                    , (r stop printString)
                                    , ']') paddedTo:7).
                            ].
                        ].

                        con := aProcess suspendedContext.
                        con isNil ifTrue:[
                            aProcess == Processor activeProcess ifTrue:[
                                con := thisContext
                            ]
                        ].

                        showDetail ifTrue:[
                            line nextPutAll:(aProcess usedStackSize printStringLeftPaddedTo:11).

                            id == 0 ifTrue:[
                                line nextPutAll:('unlimited' leftPaddedTo:14).
                            ] ifFalse:[
                                n := aProcess numberOfStackSegments.
                                line nextPutAll:(aProcess totalStackSize printStringLeftPaddedTo:10).
                                line nextPutAll:(('(' , n printString , ')') paddedTo:4).
                            ].
                            con notNil ifTrue:[
                                line nextPutAll:'  '.
                                line nextPutAll:(((ObjectMemory addressOf:con) printStringRadix:16) leftPaddedTo:8 with:$0).
                                line nextPutAll:' .. '.

                                contextCount := 1.
                                c := con.
                                [(sender := c sender) notNil] whileTrue:[
                                    c := sender.
                                    contextCount := contextCount + 1.
                                ].
                                line nextPutAll:(((ObjectMemory addressOf:c) printStringRadix:16) leftPaddedTo:8 with:$0).
                            ] ifFalse:[
                                line next:20 put:space.
                            ].
                            line nextPut:space.
                            line nextPutAll:(aProcess numberOfStackBoundaryHits printStringLeftPaddedTo:6).
                        ].

                        con notNil ifTrue:[
                            c := con.
                            found := false.
                            running ifFalse:[
                                "/ search for a semaphore-wait in the top 10 contexts

                                1 to:10 do:[:n |
                                    found ifFalse:[
                                        c notNil ifTrue:[
                                            (c receiver class == Semaphore) ifTrue:[
                                                c selector == #wait ifTrue:[
                                                    found := true.
                                                ]
                                            ].
                                            c := c sender.
                                        ]
                                    ]
                                ].
                            ].    
                            found ifFalse:[
                                "/ search for a non-processor, non-process
                                "/ receiver in the top 10 contexts

                                c := con.
                                1 to:10 do:[:n |
                                    |r|

                                    found ifFalse:[
                                        c notNil ifTrue:[
                                            ((r := c receiver) ~~ Processor 
                                             and:[r class ~~ Process]) ifTrue:[
                                                found := true.
                                            ] ifFalse:[
                                                c := c sender.
                                            ]
                                        ]
                                    ]
                                ]
                            ].
                            found ifFalse:[
                                c := con
                            ].

                            "/ skip, until an interesting context is
                            "/ found.
                            "/ this skips intermediate contexts, which lead
                            "/ to the sema-wait (for example, unwind blocks,
                            "/ delay-stuff etc.)

                            skipping := true.
                            [skipping] whileTrue:[
                                skipping := false.
                                (c notNil
                                and:[c receiver == Delay
                                     or:[c receiver class == Delay]]) ifTrue:[
                                    c := c sender.
                                    skipping := true.
                                ].

                                [c notNil
                                and:[c receiver isBlock 
                                and:[c selector startsWith:'value']]] whileTrue:[
                                    c := c sender.
                                    skipping := true.
                                ].

                                [c notNil
                                and:[c receiver isBlock 
                                and:[c selector = 'ensure:']]] whileTrue:[
                                    c := c sender.
                                    skipping := true.
                                ].

                                [c notNil
                                and:[c receiver == OperatingSystem 
                                and:[c selector == #unblockInterrupts]]] whileTrue:[
                                    c := c sender.
                                    skipping := true.
                                ].

                                [c notNil and:[c isBlockContext]] whileTrue:[
                                    c := c home.
                                    skipping := true.
                                ].
                            ].

                            c notNil ifTrue:[
                                sel := c selector.
                                sel isNil ifTrue:[
                                    sel := '* unknown *'
                                ].
                                line nextPutAll:'  '.
                                line nextPutAll:c receiver class name.
                                line nextPutAll:'>>'; nextPutAll:sel.
                            ]
                        ].
                        list add:line contents.
                        processes at:dIndex put:aProcess.
                        (oldSelection notNil and:[oldSelection includesIdentical:aProcess]) ifTrue:[
                            newSelection add:dIndex+numHeaderLines.
                        ].

                        dIndex := dIndex + 1
                    ]
                ].
            ].
            dIndex to:processes size do:[:index |
                processes at:index put:nil
            ]
        ].

        "avoid flicker"
        (oldList notNil and:[oldList size == list size]) ifTrue:[
            list keysAndValuesDo:[:idx :entry |
                (oldList at:idx) ~= entry ifTrue:[
                    listView at:idx put:entry
                ]
            ]
        ] ifFalse:[
            listView setList:list.
            "the first two entries cannot be selected"
            listView attributeAt:1 put:#disabled.
            listView attributeAt:2 put:#disabled.

            oldSelection notNil ifTrue:[
                listView selection:newSelection.
            ]
        ].
        "/ cg: must flush here - drawing is done by a background process;
        "/ without the flush, the output may look ugly (delayed)
        listView flush
    ].

    endTime := Timestamp now.
    deltaT := (endTime millisecondDeltaFrom:startTime) / 1000.0.
    "/ Transcript show:deltaT; show:' ' ; showCR:(updateDelay / 10.0).
    deltaT > (updateDelay / 5) ifTrue:[
        "/ the update took longer than 20% - make delay longer, to reduce cpu load.
        updateDelay := updateDelay * 2.
        "/ Transcript show:'+++ '; showCR:updateDelay.
    ] ifFalse:[
        updateDelay > 0.5 ifTrue:[
            deltaT < (updateDelay / 20) ifTrue:[
                "/ the update took less than 5% - make delay smaller for better animation.
                updateDelay := (updateDelay / 2) max:0.5.
                "/ Transcript show:'--- ';showCR:updateDelay.
            ].
        ].
    ].

    updateBlock notNil ifTrue:[
        Processor removeTimedBlock:updateBlock.
        Processor addTimedBlock:updateBlock afterSeconds:updateDelay
    ]

    "Modified: / 3.7.1996 / 13:56:01 / stefan"
    "Created: / 14.12.1999 / 20:47:12 / cg"
    "Modified: / 14.12.1999 / 20:50:59 / cg"
! !

!ProcessMonitor methodsFor:'initialization'!

initialize
    super initialize.

    hideDead := true.
    showDetail := Smalltalk at:#SystemDebugging ifAbsent:false.

    device hasColors ifTrue:[
	runColor := Color green.
	suspendedColor := Color yellow.
	waitColor := Color red.
    ] ifFalse:[
	runColor := suspendedColor := waitColor := Color black
    ].

    "
     ProcessMonitor open
    "

    "Modified: 23.1.1997 / 02:51:38 / cg"
!

realize
    waitColor := waitColor onDevice:device.
    runColor := runColor onDevice:device.
    suspendedColor := suspendedColor onDevice:device.
    super realize.

    "Modified: 23.1.1997 / 02:30:37 / cg"
! !

!ProcessMonitor methodsFor:'menu actions'!

abortProcess
    "abort (raise AbortSignal in) the selected process"

    self selectedProcessesDo:[:p |
        p abort
    ]
!

debugProcess
    "open a debugger on the selected process"

    self selectedProcessesDo:[:p |
       Debugger openOn:p
    ]
!

debugProcessWhenResumed
    self selectedProcessesDo:[:p |
       p onResumeDo:[:con | Debugger enter:con]
    ]

    "Created: / 14.10.1998 / 15:50:07 / cg"
    "Modified: / 14.10.1998 / 16:06:08 / cg"
!

debugWhenResumed
    self selectedProcessesDo:[:p |
       p addInterruptAction:[Debugger enter]
    ]

    "Created: / 14.10.1998 / 15:48:04 / cg"
    "Modified: / 14.10.1998 / 15:48:40 / cg"
!

hardTerminateProcess
    "hard terminate the selected process"

    self selectedProcessesSend:#terminateNoSignal

    "Created: 22.8.1997 / 02:06:51 / cg"
!

hideDead:aBoolean
    "turn on/off hiding of dead (already terminated) processes"

    hideDead := aBoolean

    "Modified: 23.1.1997 / 02:34:01 / cg"
!

inspectSelection
    "open an inspector on the selected process"

    self selectedProcessesSend:#inspect

    "Created: 23.1.1997 / 02:27:33 / cg"
!

lowerPrio
    "lower the selected processes priority"

    self selectedProcessesDo:[:p |
       p priority:(p priority - 1)
    ]
!

raisePrio
    "raise the selected processes priority"

    self selectedProcessesDo:[:p |
       p priority:(p priority + 1)
    ]
!

restartProcess
    "abort (raise AbortSignal in) the selected process"

    self selectedProcessesDo:[:p |
	p restart.
    ]
!

resumeProcess
    "resume the selected process (i.e. let it run) "

    self selectedProcessesSend:#resume
!

statusMenu
    "return a popUpMenu"

    <resource: #programMenu>

    |items m allRestartable|

    device ctrlDown ifTrue:[
        items := #( 
                        ('\c Detail' toggleDetail)
                        ('-')  
                        ('Hard Terminate'        hardTerminateProcess)
                  ).
    ] ifFalse:[
        items := #(
                             ('Inspect'               inspectSelection)
                             ('Debug'                 debugProcess)
"/                             ('Debug when resumed'    debugProcessWhenResumed)
                             ('-')  
                             ('Resume'                resumeProcess)
                             ('Suspend'               suspendProcess)
                             ('Stop'                  stopProcess)
                             ('-')   
                             ('Abort'                 abortProcess)
                             ('Terminate'             terminateProcess)
                             ('Terminate Group'       terminateProcessGroup)
                             ('Restart'               restartProcess)
                             ('-')  
                             ('Raise Prio'            raisePrio)
                             ('Lower Prio'            lowerPrio)
                            ).

        updateProcess isNil ifTrue:[
            items := #( 
                        ('Update' updateView) 
                        ('-')
                      ) , items.
        ].
    ].

    m := PopUpMenu 
                itemList:items
                resources:resources
                performer:self.


    listView hasSelection ifFalse:[
        m disableAll:#(
                             inspectSelection
                             debugProcess
                             debugProcessWhenResumed
                             resumeProcess  
                             suspendProcess  
                             stopProcess  
                             restartProcess
                             abortProcess
                             terminateProcess
                             terminateProcessGroup
                             raisePrio
                             lowerPrio
                      )
    ] ifTrue:[
        allRestartable := true.
        self selectedProcessesDo:[:p |
            p isRestartable ifFalse:[
                allRestartable := false
            ].
        ].
        allRestartable ifFalse:[
            m disable:#restartProcess
        ].
    ].

    m checkToggleAt:#toggleDetail put:showDetail.
    ^ m

    "Created: / 23.1.1997 / 03:05:54 / cg"
    "Modified: / 14.10.1998 / 17:15:43 / cg"
!

stopProcess
    "stop the selected process - not even interrupts will wake it up"

    self selectedProcessesSend:#stop
!

suspendProcess
    "suspend the selected process - interrupts will let it run again"

    self selectedProcessesSend:#suspend
!

terminateProcess
    "terminate the selected process"

    self selectedProcessesSend:#terminate.
    self updateList.

    "Modified: / 9.11.2001 / 01:09:24 / cg"
!

terminateProcessGroup
    "terminate the selected process with all of its subprocesses"

    self selectedProcessesSend:#terminateGroup.
    self updateList.

    "Modified: / 9.11.2001 / 01:09:30 / cg"
!

toggleDetail
    "toggle detail"

    showDetail := showDetail not.
    self updateView

    "Modified: 23.1.1997 / 02:33:03 / cg"
    "Created: 23.1.1997 / 02:33:30 / cg"
! !

!ProcessMonitor methodsFor:'private'!

selectedProcessesDo:aBlock
    "evaluate aBlock on all selected processes"

    |p nr sel|

    sel := listView selection.
    sel isNil ifTrue:[^ self].

    (sel isKindOf:Collection) ifTrue:[
	sel do:[:n |
	    nr := n - 2.   "for headlines"
	    nr notNil ifTrue:[
		nr > 0 ifTrue:[
		    p := processes at:nr.
		    (p notNil and:[p ~~ 0]) ifTrue:[
		       aBlock value:p
		    ]
		]
	    ]
	]
    ] ifFalse:[
	nr := sel - 2.     "for headlines"
	nr notNil ifTrue:[
	    nr > 0 ifTrue:[
		p := processes at:nr.
		(p notNil and:[p ~~ 0]) ifTrue:[
		   aBlock value:p
		]
	    ]
	]
    ].

    "Modified: 23.1.1997 / 03:10:53 / cg"
!

selectedProcessesSend:aSelector
    "send a message to all selected processes"

    self selectedProcessesDo:[:p |
	p perform:aSelector
    ].
    self updateView.

    "Modified: 23.1.1997 / 02:34:49 / cg"
! !

!ProcessMonitor methodsFor:'process selection'!

getProcessList
    "select processes to display.
     Subclasses may redefine this"

    |coll|

    showDetail ifTrue:[
        coll := Process allSubInstances asOrderedCollection.
    ] ifFalse:[
        coll := ProcessorScheduler knownProcesses asOrderedCollection.
    ].
    ^ coll
! !

!ProcessMonitor methodsFor:'user actions'!

doubleClicked
    "open a debugger on the selected process"

    self debugProcess

    "Created: 23.1.1997 / 03:21:30 / cg"
! !

!ProcessMonitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ProcessMonitor.st,v 1.84 2007/10/05 09:53:00 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

