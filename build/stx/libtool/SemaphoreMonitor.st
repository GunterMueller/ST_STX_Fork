"
 COPYRIGHT (c) 1997 by Claus Gittinger
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

SystemStatusMonitor subclass:#SemaphoreMonitor
	instanceVariableNames:'semaphores'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

!SemaphoreMonitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger
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
    This view shows smalltalk's semaphores - a debugging tool.

    [disclaimer:]
        this is one of the oldest tools in the system, written in the early 90's.
        It does in no way reflect the way GUIs are designed/written these days.
        
    [see also:]
        Semaphore SemaphoreSet
        Process ProcessorScheduler
        WindowGroup
        ProcessMonitor

    [author:]
        Claus Gittinger

    [start with:]
        SemaphoreMonitor open
"
! !

!SemaphoreMonitor class methodsFor:'defaults'!

defaultLabel
    ^ 'Semaphore Monitor'

    "Created: 23.1.1997 / 02:52:53 / cg"
! !

!SemaphoreMonitor methodsFor:'drawing'!

titleLine
    ^ 'Id     Name                    Count  Owner   Waiting Process(es)'.

    "
     SemaphoreMonitor open
    "

    "Modified: / 17.6.1998 / 14:52:48 / cg"
!

updateList
    "update list of semaphores"

    |newList|

    shown ifTrue:[
        newList := Semaphore allSubInstances.

        "sort by hashKey - will not always generate unique numbers,
         but most of the time, this works ... for now"

        newList sort:[:s1 :s2 | s1 identityHash < s2 identityHash].

        newList ~= semaphores ifTrue:[
            self updateStatus:newList
        ].
    ].
    self installDelayedUpdate.

    "Modified: / 3.7.1996 / 13:37:29 / stefan"
    "Created: / 23.1.1997 / 02:44:48 / cg"
    "Modified: / 14.12.1999 / 20:52:44 / cg"
!

updateStatus:newSemaphoreList
    "update status display of semaphores"

    |oldList list oldSelection newSelection|

    shown ifTrue:[
        oldList := listView list.
        oldSelection := listView selectionValue.
        oldSelection notNil ifTrue:[
            oldSelection := oldSelection collect:[:line | line asCollectionOfWords first asNumber].
            newSelection := OrderedCollection new.
        ].

        newSemaphoreList notNil ifTrue:[
            semaphores := WeakArray withAll:newSemaphoreList.
        ].
        semaphores notNil ifTrue:[
            list := OrderedCollection new:(semaphores size + self numberOfHeadlines).
            list add:self titleLine.
            list add:(String new:self titleLine size withAll:$-).

            semaphores validElementsDo:[:aSemaphore |
                |waiters waitersNames nm id str owner color line count|

                "/ need a copy - it may change while being enumerated
                [
                    count := aSemaphore count.
                    waiters := aSemaphore waitingProcesses copy.
                ] valueUninterruptably.

                str := '' writeStream.
                [
                    waiters notNil ifTrue:[
                        waiters do:[:aProcess |
                            str nextPut:$[.
                            aProcess id printOn:str.
                            str nextPutAll:' '''.
                            str nextPutAll:(aProcess name contractTo:40).
                            str nextPutAll:'''<'.
                            aProcess priority printOn:str.
                            str nextPutAll:'>]'.
                            str space.
                        ].
                    ]
                ] valueUninterruptably.
                waitersNames := str contents.

                (aSemaphore respondsTo:#name) ifTrue:[
                    nm := aSemaphore name.
                    nm isNil ifTrue:[
                        nm := ''
                    ]
                ] ifFalse:[
                    nm := ''
                ].
                id := aSemaphore identityHash bitShift:-12.
                owner := aSemaphore lastOwnerId.
                owner isNil ifTrue:[
                    owner := ''
                ] ifFalse:[
                    owner := owner printString
                ].
                owner := owner leftPaddedTo:6.
                
                line := (id printStringPaddedTo:6)
                          , ' '
                          , ((nm contractTo:25) paddedTo:25)
                          , ' '
                          , (count printStringLeftPaddedTo:3)
                          , ' '
                          , owner printString
                          , ' '
                          , (waiters size printStringLeftPaddedTo:3)
                          , ' '
                          , waitersNames.

                count > 0 ifTrue:[
                    waiters size > 0 ifTrue:[
                        "this happens if a low priority process is ready to run but didn't wake up yet"
                        color := Color red.
"/                        self beep.
                    ] ifFalse:[
                        "fine, this semaphore is available"
                        color := Color blue.
                    ].
                    line := line colorizeAllWith:color.
                ] ifFalse:[
                    waiters size > 0 ifTrue:[
                        line := line colorizeAllWith:Color brown.
                    ].
                ].

                list add:line.
                oldSelection notNil ifTrue:[
                    (oldSelection includes:id) ifTrue:[
                        newSelection add:list size.
                    ]
                ]
            ].
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
        ].
        newSelection notNil ifTrue:[
            listView selectWithoutScroll:newSelection
        ].
        listView flush
    ].
    self installDelayedUpdate.

    "Modified: / 3.7.1996 / 13:56:01 / stefan"
    "Created: / 14.12.1999 / 20:52:29 / cg"
    "Modified: / 14.12.1999 / 20:53:14 / cg"
! !

!SemaphoreMonitor methodsFor:'menu'!

debugLastOwningProcess
    "open a debugger on the selected semaphores' (last) owning processes"

    self selectedSemaphoresDo:[:aSema |
        |p|

        (p := aSema lastOwner) notNil ifTrue:[
            DebugView openOn:p
        ]
    ]
!

debugWaiters
    "open a debugger on the selected semaphores' waiting processes"

    self selectedSemaphoresDo:[:aSema |
        aSema waitingProcesses do:[:aProcess |
            DebugView openOn:aProcess
        ]
    ]

    "Modified: / 23.1.1997 / 03:12:06 / cg"
    "Created: / 17.6.1998 / 14:56:55 / cg"
!

inspectSemaphore
    "open an inspector on the selected semaphore(s)"

    self selectedSemaphoresDo:[:aSema | aSema inspect]

    "Modified: 23.1.1997 / 03:12:06 / cg"
    "Created: 24.1.1997 / 23:11:50 / cg"
!

inspectWaiters
    "open an inspector on the selected semaphores' waiting processes"

    self selectedSemaphoresDo:[:aSema |
        aSema waitingProcesses do:[:aProcess |
            aProcess inspect
        ]
    ]

    "Modified: / 23.1.1997 / 03:12:06 / cg"
    "Created: / 17.6.1998 / 14:17:41 / cg"
!

selectedSemaphoresDo:aBlock
    "evaluate aBlock on all selected semaphore(s)"

    self selectionIndicesDo:[:n |
        |nr p|
        
        nr := n - self numberOfHeadlines.
        nr notNil ifTrue:[
            nr > 0 ifTrue:[
                p := semaphores at:nr.
                (p notNil and:[p ~~ 0]) ifTrue:[
                   aBlock value:p
                ]
            ]
        ]
    ].
!

signalSemaphore
    "signal all selected semaphores"

    self selectedSemaphoresDo:[:aSema | aSema signal]

    "Created: 23.1.1997 / 03:12:30 / cg"
!

statusMenu
    "return a popUpMenu"

    <resource: #programMenu>

    |labels selectors m|

    labels := resources array:#(
                         'Inspect'
                         'Inspect Waiters'
                         'Debug Waiters'
                         'Debug Last Owning Process'
                         '-'
                         'Signal'
                        ).
    selectors := #(
                         inspectSemaphore
                         inspectWaiters
                         debugWaiters
                         debugLastOwningProcess
                         nil
                         signalSemaphore
                        ).

    updateProcess isNil ifTrue:[
        labels := (resources array:#('Update' '-')) , labels.
        selectors := #(updateView nil) , selectors
    ].

    m := PopUpMenu labels:labels
                   selectors:selectors.


    listView hasSelection ifFalse:[
        m disableAll:#(
                         inspectSemaphore
                         inspectWaiters
                         debugWaiters
                         debugLastOwningProcess
                         signalSemaphore
                      )
    ].
    ^ m

    "Modified: / 17.6.1998 / 14:17:05 / cg"
! !

!SemaphoreMonitor methodsFor:'queries'!

numberOfHeadlines
    ^ 2
! !

!SemaphoreMonitor methodsFor:'user actions'!

doubleClicked
    "open an inspector on the selected semaphore"

    self inspectSemaphore

    "Created: 23.1.1997 / 03:22:04 / cg"
    "Modified: 31.1.1997 / 22:33:27 / cg"
! !

!SemaphoreMonitor class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

