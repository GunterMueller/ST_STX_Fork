"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractTreeApplication subclass:#VDBStackApplication
	instanceVariableNames:'selectedThreadGroupHolder selectedThreadHolder
		selectedFrameHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Others'
!

!VDBStackApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBStackApplication class methodsFor:'accessing'!

windowTitle
    ^ 'Backtrace'

    "Created: / 11-07-2017 / 16:37:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStackApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #debuggerHolder
        #selectedFrameHolder
        #selectedThreadGroupHolder
        #selectedThreadHolder
      ).

! !

!VDBStackApplication methodsFor:'aspects'!

foregroundColorFor: aVDBAbstractPresenter
    ^ (aVDBAbstractPresenter isFramePresenter and:[ aVDBAbstractPresenter frame thread isStopped not])
        ifTrue:[  Color gray ]
        ifFalse:[ nil ]

    "Created: / 26-06-2018 / 13:06:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-07-2018 / 13:13:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedFrameHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    selectedFrameHolder isNil ifTrue:[
        selectedFrameHolder := ValueHolder new.
        selectedFrameHolder addDependent:self.
    ].
    ^ selectedFrameHolder

    "Created: / 21-09-2014 / 23:51:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedFrameHolder:aValueModel
    "set the 'selectionHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedFrameHolder notNil ifTrue:[
        oldValue := selectedFrameHolder value.
        selectedFrameHolder removeDependent:self.
    ].
    selectedFrameHolder := aValueModel.
    selectedFrameHolder notNil ifTrue:[
        selectedFrameHolder addDependent:self.
    ].
    newValue := selectedFrameHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedFrameHolder.
    ].

    "Created: / 21-09-2014 / 23:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedThreadGroupHolder
    "return/create the 'selectedThreadGroupHolder' value holder (automatically generated)"

    selectedThreadGroupHolder isNil ifTrue:[
        selectedThreadGroupHolder := ValueHolder new.
        selectedThreadGroupHolder addDependent:self.
    ].
    ^ selectedThreadGroupHolder
!

selectedThreadGroupHolder:something
    "set the 'selectedThreadGroupHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedThreadGroupHolder notNil ifTrue:[
        oldValue := selectedThreadGroupHolder value.
        selectedThreadGroupHolder removeDependent:self.
    ].
    selectedThreadGroupHolder := something.
    selectedThreadGroupHolder notNil ifTrue:[
        selectedThreadGroupHolder addDependent:self.
    ].
    newValue := selectedThreadGroupHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedThreadGroupHolder.
    ].
!

selectedThreadHolder
    "return/create the 'selectedThreadHolder' value holder (automatically generated)"

    selectedThreadHolder isNil ifTrue:[
        selectedThreadHolder := ValueHolder new.
        selectedThreadHolder addDependent:self.
    ].
    ^ selectedThreadHolder
!

selectedThreadHolder:something
    "set the 'selectedThreadHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedThreadHolder notNil ifTrue:[
        oldValue := selectedThreadHolder value.
        selectedThreadHolder removeDependent:self.
    ].
    selectedThreadHolder := something.
    selectedThreadHolder notNil ifTrue:[
        selectedThreadHolder addDependent:self.
    ].
    newValue := selectedThreadHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedThreadHolder.
    ].
! !

!VDBStackApplication methodsFor:'change & update'!

enqueueUpdateAfterThreadStopped:aGDBThread 
    self enqueueDelayedUpdate:#delayedUpdateAfterThreadStopped:
        with:aGDBThread

    "Created: / 22-09-2014 / 23:15:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2018 / 06:52:50 / jv"
!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    sender == selectedFrameHolder ifTrue:[
         self updateInternalSelection.
         ^ self.
    ].
    super update:aspect with:param from:sender

    "Modified: / 27-02-2015 / 15:44:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateInternalSelection
    | frame presenter |

    frame := self selectedFrameHolder value.
    presenter := self internalListHolder value detect:[:e | e subject == frame ] ifNone:[ nil ].
    self internalSelectionHolder
        value: presenter
        withoutNotifying: self.

    "Created: / 20-09-2014 / 23:05:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 30-07-2018 / 07:40:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelection
    | internalSelection frame thread group |

    internalSelection := self internalSelectionHolder value.
    internalSelection notNil ifTrue:[ 
        internalSelection isFramePresenter ifTrue:[
            frame := internalSelection frame.
            thread := frame thread.
            group := thread group.
        ] ifFalse:[ 
            internalSelection isThreadPresenter ifTrue:[ 
                thread := internalSelection thread.
                group := thread group.
            ] ifFalse:[  
                group := internalSelection threadGroup.
            ]
        ].
    ].

    self selectedThreadGroupHolder value: group withoutNotifying: self.
    self selectedThreadHolder value: thread withoutNotifying: self.
    self selectedFrameHolder value: frame withoutNotifying: self.

    "Created: / 20-09-2014 / 23:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-09-2014 / 00:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStackApplication methodsFor:'change & update-delayed'!

delayedUpdateAfterThreadStopped:thread 
    "/ It may happen that by te time we get here the thread is running
    "/ again, so care for this.
    
    thread isStopped ifTrue:[
        |threadP framePs frameP|

        threadP := self internalListHolder value root 
                recursiveDetect:[:e | e isThreadPresenter and:[ e thread == thread ] ].
        framePs := threadP children.
        framePs notEmpty ifTrue:[
            frameP := threadP children first.
            frameP parent expand.
            self internalSelectionHolder value:frameP
        ].
    ].

    "Created: / 22-09-2014 / 23:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2017 / 08:56:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-01-2018 / 20:22:04 / jv"
!

delayedUpdateInternalList
    | root  list |

    debugger isNil ifTrue:[
        self internalListHolder root children:#().
        ^ self.
    ].
    root := self internalListHolder root.
    list := debugger inferiors 
            select:[:inferior | true "inferior isRunning or:[ inferior isStopped ]" ]
            thenCollect:[:inferior | 
                (VDBThreadGroupPresenter new)
                    setThreadGroup:inferior;
                    parent:root
            ].
    root children:list.
    root expand.
    root children size == 1 ifTrue:[
        root children anElement expand.
        root children anElement children size == 1 ifTrue:[
            root children anElement children anElement expand.
        ]
    ].
    self delayedInvalidateInternalList

    "Created: / 20-09-2014 / 23:05:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2018 / 19:52:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateSelection
    | internalSelection frame thread group |

    internalSelection := self internalSelectionHolder value.
    internalSelection notNil ifTrue:[ 
        internalSelection isFramePresenter ifTrue:[
            frame := internalSelection frame.
            thread := frame thread.
            group := thread group.
        ] ifFalse:[ 
            internalSelection isThreadPresenter ifTrue:[ 
                thread := internalSelection thread.
                group := thread group.
            ] ifFalse:[  
                group := internalSelection threadGroup.
            ]
        ].
    ].

    self selectedThreadGroupHolder value: group withoutNotifying: self.
    self selectedThreadHolder value: thread withoutNotifying: self.
    self selectedFrameHolder value: frame withoutNotifying: self.

    "Created: / 27-02-2015 / 15:33:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStackApplication methodsFor:'event handling'!

onRunningEvent: event
    self selectedFrameHolder value notNil ifTrue:[ 
        self internalSelectionHolder value: nil.
    ].
    self delayedInvalidateInternalList

    "Created: / 30-09-2014 / 00:02:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2018 / 06:59:11 / jv"
    "Modified: / 09-04-2018 / 20:43:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onStoppedEvent: event
    | stoppedThread |

    self enqueueDelayedUpdateInternalList.
    stoppedThread := event stoppedThread.
    stoppedThread notNil ifTrue:[
        self enqueueUpdateAfterThreadStopped:event stoppedThread.
    ].

    "Created: / 17-09-2014 / 23:04:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-09-2014 / 23:26:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 11:51:51 / jv"
!

onThreadGroupExitedEvent: event
    self enqueueDelayedUpdateInternalList.

    "Created: / 18-09-2014 / 23:30:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2014 / 23:08:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadGroupStartedEvent: event
    self enqueueDelayedUpdateInternalList.

    "Created: / 02-03-2015 / 06:42:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStackApplication methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    debugger announcer
        when: GDBRunningEvent               send: #onRunningEvent: to: self;
        when: GDBStoppedEvent               send: #onStoppedEvent: to: self;
        when: GDBThreadGroupStartedEvent    send: #onThreadGroupStartedEvent: to: self;
        when: GDBThreadGroupExitedEvent     send: #onThreadGroupExitedEvent: to: self

    "Created: / 07-06-2014 / 14:33:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 06:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2018 / 06:56:46 / jv"
! !

!VDBStackApplication methodsFor:'queries'!

canSelect: anItem
    ^ anItem isFramePresenter not or:[ anItem frame thread isStopped ]

    "Created: / 09-04-2018 / 20:52:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBStackApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

