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

SystemStatusMonitor subclass:#ExternalStreamMonitor
	instanceVariableNames:'semaphores streams filterOpenStreamsOnlyHolder
		filterSocketsOnlyHolder filterConnectedSocketsOnlyHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

!ExternalStreamMonitor class methodsFor:'documentation'!

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
    This view shows smalltalk's external stream instances - a debugging tool.

    [disclaimer:]
        this is based on one of the oldest tools in the system, written in the early 90's.
        It does in no way reflect the way GUIs are designed/written these days.
        
    [see also:]
        Stream ExternalStream
        WindowGroup
        ProcessMonitor
        SemaphoreMonitor

    [author:]
        Claus Gittinger

    [start with:]
        ExternalStreamMonitor open
"
! !

!ExternalStreamMonitor class methodsFor:'defaults'!

defaultLabel
    ^ 'External Streams Monitor'

    "Created: 23.1.1997 / 02:52:53 / cg"
! !

!ExternalStreamMonitor class methodsFor:'menu specs'!

filterMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ExternalStreamMonitor andSelector:#filterMenu
     (Menu new fromLiteralArrayEncoding:(ExternalStreamMonitor filterMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Open Streams Only'
            hideMenuOnActivated: false
            indication: filterOpenStreamsOnlyHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Sockets Only'
            hideMenuOnActivated: false
            indication: filterSocketsOnlyHolder
          )
         (MenuItem
            label: 'Connected Sockets Only'
            hideMenuOnActivated: false
            indication: filterConnectedSocketsOnlyHolder
          )
         )
        nil
        nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ExternalStreamMonitor andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(ExternalStreamMonitor mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequestToTopView
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Filter'
            submenuChannel: filterMenu
          )
         )
        nil
        nil
      )
! !

!ExternalStreamMonitor methodsFor:'aspects'!

filterConnectedSocketsOnlyHolder
    filterConnectedSocketsOnlyHolder isNil ifTrue:[
        filterConnectedSocketsOnlyHolder := false asValue.
        filterConnectedSocketsOnlyHolder onChangeSend:#filterConnectedSocketsOnlyHolderChanged to:self.
    ].    
    ^ filterConnectedSocketsOnlyHolder
!

filterOpenStreamsOnlyHolder 
    filterOpenStreamsOnlyHolder isNil ifTrue:[
        filterOpenStreamsOnlyHolder := false asValue.
        filterSocketsOnlyHolder onChangeSend:#filterOpenStreamsOnlyHolder to:self.
    ].    
    ^ filterOpenStreamsOnlyHolder
!

filterSocketsOnlyHolder
    filterSocketsOnlyHolder isNil ifTrue:[
        filterSocketsOnlyHolder := false asValue.
        filterSocketsOnlyHolder onChangeSend:#filterSocketsOnlyHolderChanged to:self.
    ].    
    ^ filterSocketsOnlyHolder
! !

!ExternalStreamMonitor methodsFor:'drawing'!

titleLine
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ 'Type                 Global                     Handle Detail'.
    ] ifFalse:[    
        ^ 'Type                 Global                     FD Detail'.
    ].
    
    "
     ExternalStreamMonitor open
    "

    "Modified: / 17.6.1998 / 14:52:48 / cg"
!

updateList
    "update list of semaphores"

    |newList|

    shown ifTrue:[
        newList := ExternalStream allSubInstances.

        self filterSocketsOnlyHolder value ifTrue:[
            newList := newList select:[:eachStream | eachStream isSocket].
        ].
        self filterOpenStreamsOnlyHolder value ifTrue:[
            newList := newList select:[:eachStream | eachStream isOpen].
        ].
        self filterConnectedSocketsOnlyHolder value ifTrue:[
            newList := newList select:[:eachStream | eachStream isSocket and:[eachStream isConnected]].
        ].
        
        "sort by hashKey - will not always generate unique numbers,
         but most of the time, this works ... for now"

        newList sort:[:s1 :s2 | 
                    s1 className < s2 className
                    or:[ s1 className = s2 className
                         and:[false]]
                ].

        newList ~= streams ifTrue:[
            self updateStatus:newList
        ].
    ].
    self installDelayedUpdate.
!

updateStatus:newStreamsList
    "update status display of semaphores"

    |oldList list oldSelection newSelection|

    shown ifTrue:[
        oldList := listView list.
        oldSelection := listView selection.
        oldSelection notNil ifTrue:[
            oldSelection := oldSelection collect:[:lineNr | streams at:(lineNr - self numberOfHeadlines) ].
            newSelection := OrderedCollection new.
        ].

        newStreamsList notNil ifTrue:[
            streams := WeakArray withAll:newStreamsList.
        ].
        streams notNil ifTrue:[
            list := OrderedCollection new:(streams size + self numberOfHeadlines).
            list add:self titleLine.
            list add:(String new:self titleLine size withAll:$-).

            streams validElementsDo:[:aStream |
                |waiters waitersNames type globalNameOrNil handleString
                 isOpen handle detail color line|

"/                "/ need a copy - it may change while being enumerated
"/                [
"/                    count := aSemaphore count.
"/                    waiters := aSemaphore waitingProcesses copy.
"/                ] valueUninterruptably.

"/                str := '' writeStream.
"/                [
"/                    waiters notNil ifTrue:[
"/                        waiters do:[:aProcess |
"/                            str nextPut:$[.
"/                            aProcess id printOn:str.
"/                            str nextPutAll:' '''.
"/                            str nextPutAll:(aProcess name contractTo:40).
"/                            str nextPutAll:'''<'.
"/                            aProcess priority printOn:str.
"/                            str nextPutAll:'>]'.
"/                            str space.
"/                        ].
"/                    ]
"/                ] valueUninterruptably.
"/                waitersNames := str contents.

"/                (aSemaphore respondsTo:#name) ifTrue:[
"/                    nm := aSemaphore name.
"/                    nm isNil ifTrue:[
"/                        nm := ''
"/                    ]
"/                ] ifFalse:[
"/                    nm := ''
"/                ].
                type := aStream className.

                globalNameOrNil := Smalltalk keyAtValue:aStream.
                
                aStream isFileStream ifTrue:[
                    detail := aStream pathName.
                ] ifFalse:[
                    aStream isSocket ifTrue:[
                        aStream getPeer notNil ifTrue:[
                            detail := aStream getPeerName printString,aStream getPeer printString.
                        ]
                    ] ifFalse:[
                    ].
                ].
                
                OperatingSystem isMSWINDOWSlike ifTrue:[
                    aStream isOpen ifTrue:[
                        handle := aStream fileHandle.
                        handleString := handle address hexPrintString
                    ].
                    handleString := (handleString ? '') leftPaddedTo:7
                ] ifFalse:[
                    aStream isOpen ifTrue:[
                        handleString := aStream fileDescriptor printString
                    ].
                    handleString := (handleString ? '') leftPaddedTo:3
                ].

                line := (type contractTo:20) paddedTo:20.
                line := line , ' ' , (((globalNameOrNil ? '') contractTo:25) paddedTo:25).
                line := line , ' ' , handleString.
                line := line , ' ' , (detail ? '').

                isOpen := aStream isOpen.
                
"/                line := line
"/                          , ' '
"/                          , ((nm contractTo:25) paddedTo:25)
"/                          , ' '
"/                          , (count printStringLeftPaddedTo:3)
"/                          , ' '
"/                          , owner printString
"/                          , ' '
"/                          , (waiters size printStringLeftPaddedTo:3)
"/                          , ' '
"/                          , waitersNames.

                isOpen ifFalse:[
                    color := Color red.
                ] ifTrue:[
                    color := Color blue.
                ].
                line := line colorizeAllWith:color.

                list add:line.
                oldSelection notNil ifTrue:[
                    (oldSelection includesIdentical:aStream) ifTrue:[
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
! !

!ExternalStreamMonitor methodsFor:'menu'!

debugWaiters
    "open a debugger on the selected semaphores waiting processes"

    self selectedSemaphoresDo:[:aSema |
	aSema waitingProcesses do:[:aProcess |
	    DebugView openOn:aProcess
	]
    ]

    "Modified: / 23.1.1997 / 03:12:06 / cg"
    "Created: / 17.6.1998 / 14:56:55 / cg"
!

inspectSemaphore
    "open an inspector on the selected semaphores"

    self selectedSemaphoresDo:[:aSema | aSema inspect]

    "Modified: 23.1.1997 / 03:12:06 / cg"
    "Created: 24.1.1997 / 23:11:50 / cg"
!

inspectStream
    "open an inspector on the selected stream(s)"

    self selectedStreamsDo:[:aSema | aSema inspect]
!

inspectWaiters
    "open an inspector on the selected semaphores waiting processes"

    self selectedSemaphoresDo:[:aSema |
	aSema waitingProcesses do:[:aProcess |
	    aProcess inspect
	]
    ]

    "Modified: / 23.1.1997 / 03:12:06 / cg"
    "Created: / 17.6.1998 / 14:17:41 / cg"
!

selectedStreamsDo:aBlock
    "evaluate aBlock on all selected streams"

    self selectionIndicesDo:[:n |
        |nr stream|
        
        nr := n - self numberOfHeadlines.
        nr notNil ifTrue:[
            nr > 0 ifTrue:[
                stream := streams at:nr.
                (stream notNil and:[stream ~~ 0]) ifTrue:[
                   aBlock value:stream
                ]
            ]
        ]
    ].
!

statusMenu
    "return a popUpMenu"

    <resource: #programMenu>

    |labels selectors m|

    labels := resources array:#(
                         'Inspect'
                         'Inspect Waiters'
                         'Debug Waiters'
                        ).
    selectors := #(
                         inspectStream
                         inspectWaiters
                         debugWaiters
                        ).

    updateProcess isNil ifTrue:[
        labels := (resources array:#('Update' '-')) , labels.
        selectors := #(updateView nil) , selectors
    ].

    m := PopUpMenu labels:labels
                   selectors:selectors.


    listView hasSelection ifFalse:[
        m disableAll:#(
                         inspectStream
                         inspectWaiters
                         debugWaiters
                      )
    ].
    ^ m

    "Modified: / 17.6.1998 / 14:17:05 / cg"
! !

!ExternalStreamMonitor methodsFor:'queries'!

numberOfHeadlines
    ^ 2
! !

!ExternalStreamMonitor methodsFor:'user actions'!

doubleClicked
    "open an inspector on the selected semaphore"

    self inspectStream

    "Created: 23.1.1997 / 03:22:04 / cg"
    "Modified: 31.1.1997 / 22:33:27 / cg"
!

filterConnectedSocketsOnlyHolderChanged
    self sensor pushUserEvent:#updateList for:self
!

filterOpenStreamsOnlyHolderChanged
    self sensor pushUserEvent:#updateList for:self
!

filterSocketsOnlyHolderChanged
    self sensor pushUserEvent:#updateList for:self
! !

!ExternalStreamMonitor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

