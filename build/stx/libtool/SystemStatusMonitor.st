"
 COPYRIGHT (c) 1997 by eXept Software AG
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

SimpleView subclass:#SystemStatusMonitor
	instanceVariableNames:'listView listUpdateDelay updateDelay updateBlock listUpdateBlock
		updateProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

!SystemStatusMonitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    Abstract class providing common code for list-based status monitors.

    [disclaimer:]
        these are some of the oldest tools in the system, written in the early 90's.
        They do in no way reflect the way GUIs are designed/written these days.
"
! !

!SystemStatusMonitor class methodsFor:'defaults'!

defaultIcon
    ^ StandardSystemView defaultIcon

    "Created: 23.1.1997 / 02:52:25 / cg"
!

defaultLabel
    ^ 'Status Monitor'

    "Created: 23.1.1997 / 02:52:43 / cg"
! !

!SystemStatusMonitor class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:SystemStatusMonitor andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(SystemStatusMonitor mainMenu)) startUp
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
         )
        nil
        nil
      )
! !

!SystemStatusMonitor class methodsFor:'startup'!

isAbstract
    "return true, if this is an abstract class."

    ^ self == SystemStatusMonitor
!

isVisualStartable
    "return true, if this application can be started via #open.
     (to allow start of a subclass instance via double-click in the browser)"

    ^ self ~~ SystemStatusMonitor

    "Created: / 10.8.1998 / 16:02:23 / cg"
    "Modified: / 10.8.1998 / 16:02:41 / cg"
!

open
    |top menuPanel menu monitor|

    top := StandardSystemView new.

    monitor := self in:top.
    monitor layout:(LayoutFrame
        leftFraction:0 offset:0
        rightFraction:1 offset:0
        topFraction:0 offset:30
        bottomFraction:1 offset:0).

    menuPanel := MenuPanel in:top.
    menuPanel layout:(LayoutFrame
        leftFraction:0 offset:0
        rightFraction:1 offset:0
        topFraction:0 offset:0
        bottomFraction:0 offset:30).
    menuPanel verticalLayout:false.
    menu := self mainMenu decodeAsLiteralArray.
    menu findGuiResourcesIn:monitor.
    menu receiver:monitor.
    menuPanel menu:menu.

    top extent:monitor preferredExtent.
    top label:self defaultLabel.
    top icon:self defaultIcon.
    top open.

    ^ monitor

    "
     ProcessMonitor open
    "

    "Created: 23.1.1997 / 02:53:42 / cg"
! !

!SystemStatusMonitor methodsFor:'destroying'!

release
    updateBlock notNil ifTrue:[
        Processor removeTimedBlock:updateBlock.
        updateBlock := nil.
    ].
    listUpdateBlock notNil ifTrue:[
        Processor removeTimedBlock:listUpdateBlock.
        listUpdateBlock := nil.
    ].
    updateProcess notNil ifTrue:[
        updateProcess terminate.
        updateProcess := nil.
    ].
    super release

    "Created: 23.1.1997 / 02:26:50 / cg"
! !

!SystemStatusMonitor methodsFor:'drawing'!

titleLine
    self subclassResponsibility
!

updateList
    self subclassResponsibility
!

updateStatus:arg
    self subclassResponsibility
!

updateView
    self updateList.
    self updateStatus:nil

    "Created: / 23.1.1997 / 02:27:05 / cg"
    "Modified: / 14.12.1999 / 20:47:37 / cg"
! !

!SystemStatusMonitor methodsFor:'events'!

canHandle:key
    ^ key == #InspectIt

    "Created: 23.1.1997 / 02:27:15 / cg"
!

keyPress:key x:x y:y
    <resource: #keyboard ( #InspectIt ) >

    key == #InspectIt ifTrue:[
	^ self inspectSelection.
    ].
    ^ super keyPress:key x:x y:y

    "Modified: 23.1.1997 / 02:27:27 / cg"
    "Created: 23.1.1997 / 02:27:45 / cg"
! !

!SystemStatusMonitor methodsFor:'initialization'!

initialize
    |v|

    super initialize.

    v := HVScrollableView for:SelectionInListView miniScrollerH:true in:self.
    v origin:0.0@0.0 corner:1.0@1.0.

    listView := v scrolledView.
    listView font:(EditTextView defaultFont).
    listView menuHolder:self; menuPerformer:self; menuMessage:#statusMenu. 

    listView multipleSelectOk:true.
    "/ listView toggleSelect:true.
    listView delegate:(KeyboardForwarder toView:self).
    listView doubleClickAction:[:line | self doubleClicked].

    updateDelay := 0.5.
    listUpdateDelay := 5.

    "/ event mode is no longer used;
    "/ this event support may vanish
    Processor isPureEventDriven ifTrue:[
        updateBlock := [self updateStatus:nil].
        listUpdateBlock := [self updateList].
    ].

    "
     ProcessMonitor open
    "

    "Modified: / 14.12.1999 / 20:47:57 / cg"
!

mapped
    super mapped.
    self updateStatus:nil.
    self updateList.

    "Created: / 23.1.1997 / 02:30:05 / cg"
    "Modified: / 14.12.1999 / 20:47:54 / cg"
!

realize
    super realize.

    self startUpdateProcess.

    "Created: 23.1.1997 / 02:30:28 / cg"
!

reinitialize
    updateProcess := nil.
    super reinitialize.
    self startUpdateProcess.

    "Modified: 22.12.1995 / 22:51:14 / cg"
    "Created: 23.1.1997 / 02:30:43 / cg"
!

startUpdateProcess
    updateBlock notNil ifTrue:[
        Processor addTimedBlock:updateBlock afterSeconds:updateDelay.
        Processor addTimedBlock:listUpdateBlock afterSeconds:listUpdateDelay.
    ] ifFalse:[
        updateProcess := [
            [
                |id cnt myDelay|

                myDelay := Delay forSeconds:updateDelay.

                "
                 every updateDelay (0.5), we look which process runs;
                 every half second, the status is updated.
                 every listUpdateDelay (5s), the list of processes is
                 built up again
                "
                [true] whileTrue:[
                    ((listUpdateDelay // updateDelay) max:2) - 1 timesRepeat:[
                        myDelay wait.
                        self updateStatus:nil.
                    ].
                    myDelay wait.
                    self updateList.
                ]
            ] ifCurtailed:[
                updateProcess := nil
            ]
        ]  forkAt:(Processor userSchedulingPriority + 1).
        updateProcess name:'monitor [' , 
                           Processor activeProcess id printString ,
                           '] update'.
        "
         raise my own priority
        "
        Processor activeProcess priority:(Processor userSchedulingPriority + 2)
    ].

    "Created: / 23.1.1997 / 02:30:58 / cg"
    "Modified: / 14.12.1999 / 20:47:50 / cg"
! !

!SystemStatusMonitor methodsFor:'menu'!

closeRequestToTopView
    self topView closeRequest
!

selectionIndicesDo:aBlock
    "evaluate aBlock on all selected indices"

    |sel|

    sel := listView selection.
    sel isNil ifTrue:[^ self].

    (sel isKindOf:Collection) ifTrue:[
        sel do:aBlock
    ] ifFalse:[
        aBlock value:sel.
    ].

    "Created: 23.1.1997 / 03:11:24 / cg"
! !

!SystemStatusMonitor methodsFor:'private'!

installDelayedUpdate
    updateBlock notNil ifTrue:[
        Processor removeTimedBlock:listUpdateBlock.
        Processor addTimedBlock:listUpdateBlock afterSeconds:listUpdateDelay
    ].
! !

!SystemStatusMonitor methodsFor:'queries'!

preferredExtent
    "return my preferred extent"

    ^ ((self font widthOf:self titleLine) + 400) @ 250

    "Modified: 23.1.1997 / 02:35:01 / cg"
    "Created: 23.1.1997 / 02:51:24 / cg"
! !

!SystemStatusMonitor methodsFor:'user actions'!

doubleClicked
    "intentionally blank here - to be redefined in subclasses"
    
    ^ self 
!

inspectSelection
    "intentionally blank here - to be redefined in subclasses"
    
    ^ self 
! !

!SystemStatusMonitor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: SystemStatusMonitor.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

