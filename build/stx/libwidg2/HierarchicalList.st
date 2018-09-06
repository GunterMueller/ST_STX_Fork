"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

List subclass:#HierarchicalList
	instanceVariableNames:'recursionLock root showRoot application monitoringTask
		monitoringTaskDelay additionalItemsToMonitorSemaphore'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!HierarchicalList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Hierarchical Lists are mostly like List, but adding and removing
    elements are handled by the items itself.
    Special change notifications are emitted, 
    whenever the list is changed.
    I am used mostly by the HierarchicalListView widget;
    see comments there.    

    [Instance variables:]
        root        <HierarchicalItem>  first item into list
        showRoot    <Boolean>           show or hide root item
        application <Application>       the user is able to set an application
                                        which can be accessed by an item.
    [author:]
        Claus Atzkern

    [see also:]
        HierarchicalItem
        HierarchicalListView
"
! !

!HierarchicalList methodsFor:'accessing-look'!

showRoot
    "show or hide root item
    "
    showRoot isNil ifTrue:[
        showRoot := true
    ].
    ^ showRoot
!

showRoot:aBoolean
    "show or hide root item
    "
    aBoolean ~~ self showRoot ifTrue:[
        showRoot := aBoolean.

        root notNil ifTrue:[
            showRoot ifTrue:[
                super addFirst:root
            ] ifFalse:[
                super removeFirst.
                root expand
            ]
        ]
    ]

! !

!HierarchicalList methodsFor:'accessing-monitoring task'!

monitoringTaskDelay
    "get the delay time of the monitoring task measured  in seconds
     or nil( monitoring disabled ). The task runs through all items 
     of the list performing #monitoringCycle and than at end of the
     list the task is suspended for monitoringTaskDelay seconds.
    "
    ^ monitoringTaskDelay
!

monitoringTaskDelay:inSecondsOrNil
    "set the delay time of the monitoring task measured  in seconds
     or nil( monitoring disabled ). The task runs through all items 
     of the list performing #monitoringCycle and than at end of the
     list the task is suspended for monitoringTaskDelay seconds.
    "
    inSecondsOrNil isNil ifTrue:[
        self stopMonitoringTask.
        monitoringTaskDelay := nil.
    ] ifFalse:[
        monitoringTaskDelay := inSecondsOrNil.
        self startMonitoringTask
    ].
! !

!HierarchicalList methodsFor:'accessing-mvc'!

addDependent:anObject
    "restart the monitoringTask if necessary
    "
    super addDependent:anObject.
    self  startMonitoringTask.
!

application
    "returns the responsible application; if no application is defined,
     nil is returned
    "
    ^ application
!

application:anApplication
    "set the responsible application
    "
    application := anApplication.
!

applicationsDo:aOneArgBlock
    "evaluate the block on each dependent application
    "
    |appl|

    dependents notNil ifTrue:[
        dependents do:[:aDep|
            appl := aDep perform:#application ifNotUnderstood:nil.

            appl notNil ifTrue:[
                aOneArgBlock value:appl
            ]
        ]
    ]
!

removeDependent:anObject
    "stop the monitoringTask if no more dependencies exists
    "
    super removeDependent:anObject.

    dependents size == 0 ifTrue:[
        self stopMonitoringTask
    ].

! !

!HierarchicalList methodsFor:'accessing-root'!

root
    "get the root item
    "
    ^ root

!

root:aRootItem
    "set the root item
    "
    |children|

    self stopMonitoringTask.

    "/ inlink the previous root
    root notNil ifTrue:[
        root parent:nil.
        root := nil.
    ].

    (root := aRootItem) isEmptyOrNil ifTrue:[
        self removeAll.
    ] ifFalse:[
        self showRoot ifFalse:[root expand].

        root parent:self.
        children := OrderedCollection new.
        self showRoot ifTrue:[children add:root].
        root addVisibleChildrenTo:children.
        "/ self removeAll.
        "/ self addAll:children beforeIndex:1.
        self contents:children.    
    ].
    self startMonitoringTask.

    "Modified: / 12-09-2006 / 18:22:42 / cg"
! !

!HierarchicalList methodsFor:'private'!

criticalDo:aBlock
    "evaluate the block in a critical region
    "
    ^ recursionLock critical:aBlock
!

initContents:aSize
    "setup defaults
    "
    showRoot      isNil ifTrue:[ showRoot      := true ].
    recursionLock isNil ifTrue:[ recursionLock := RecursionLock new ].

    ^ super initContents:aSize.
!

itemAddAll:aListOfItems beforeIndex:anIndex
    "insert all items before an index
    "
    super addAll:aListOfItems beforeIndex:anIndex
!

itemChanged:what with:aPara from:anItem
    "catch notification from item; throw changeNotifications
     to dependencies;
     **** don't know what to do with a parameter and argument what
     **** list protocol ****
    "
    |index arrIdx "{ Class: SmallInteger }"|

    (index := super identityIndexOf:anItem) ~~ 0 ifTrue:[
        arrIdx := index + firstIndex - 1.
        contentsArray basicAt:arrIdx put:anItem.

        dependents size ~~ 0 ifTrue:[
            what isNil ifTrue:[self changed:#at: with:index]
                      ifFalse:[self changed:#at: with:(Array with:index with:what)]
        ]
    ]
!

itemRemoveFromIndex:start toIndex:stop
    "remove the items stored under startIndex up to and including
     the items under stopIndex.
    "
    ^ super removeFromIndex:start toIndex:stop
!

parentOrModel
    "always returns nil
    "
    ^ nil
!

recursionLock
    ^ recursionLock

! !

!HierarchicalList methodsFor:'private-monitoring task'!

monitoringCycle
    "the block evaluated
    "
    |index item|

    item  := root.
    index := 1.                 "/ on default discard first entry the root

    root isNil ifTrue:[
        item := self at:index ifAbsent:nil.
    ] ifFalse:[
        self showRoot ifFalse:[
            index := 0          "/ read list from begin
        ]
    ].

    [item notNil] whileTrue:[
        item monitoringCycle.
        Processor yield.
        index := index + 1.
        item  := self at:index ifAbsent:nil.
    ]
!

startMonitoringTask
    "start the monitoring task; backgrund process finishes, when no (more) dependencies exist,
     and the additionalItemsToMonitorSemaphore is not signalled 
     (aka: no more background children to read)"

    |name|

    (monitoringTask isNil
        and:[self monitoringTaskDelay notNil
        and:[(dependents size ~~ 0) or:[additionalItemsToMonitorSemaphore notNil]]]
    ) ifTrue:[
        monitoringTask := 
            [
                [(dependents size ~~ 0) or:[additionalItemsToMonitorSemaphore notNil]] whileTrue:[
                    self monitoringCycle.
                    additionalItemsToMonitorSemaphore isNil ifTrue:[
                        Delay waitForSeconds:self monitoringTaskDelay
                    ] ifFalse:[
                        additionalItemsToMonitorSemaphore waitWithTimeout:self monitoringTaskDelay.
                    ]
                ].
            ] newProcess.

        monitoringTask priorityRange:(Processor userBackgroundPriority to:Processor activePriority).
        monitoringTask restartable:true.
        monitoringTask resume.

        name := application notNil ifTrue:[application class name] ifFalse:['???'].
        monitoringTask name:'HierarchicalList: ', name.
    ].
    ^ true.
!

stopMonitoringTask
    "stop the monitoring task"

    |task|

    (task := monitoringTask) notNil ifTrue:[
        monitoringTask := nil.

        Error 
            handle:[:ex| ] 
            do:[
                task terminateWithAllSubprocessesInGroup.
                task waitUntilTerminated.
            ]
    ]
!

triggerUpdateCycle
    additionalItemsToMonitorSemaphore isNil ifTrue:[
        [
            additionalItemsToMonitorSemaphore isNil ifTrue:[
                additionalItemsToMonitorSemaphore := Semaphore new.
            ].
        ] valueUninterruptably
    ].

    monitoringTaskDelay isNil ifTrue:[
        monitoringTaskDelay := 10
    ].

    additionalItemsToMonitorSemaphore signalOnce.
    self startMonitoringTask.
! !

!HierarchicalList methodsFor:'protocol'!

childrenFor:anItem
    "returns the children for an item or an empty list
    "
    ^ #()
!

iconFor:anItem
    "returns the icon for an item or nil
    "
    ^ nil
!

labelFor:anItem
    "returns the label for an item or nil"

    ^ nil
!

middleButtonMenuFor:anItem
    "returns the middleButton menu for an item or nil
    "
    ^ nil


! !

!HierarchicalList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

