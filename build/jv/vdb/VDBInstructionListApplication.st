"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractTreeApplication subclass:#VDBInstructionListApplication
	instanceVariableNames:'instructionListHolder instructionBasicBlocks
		selectedInstructionHolder selectedInstructionBranchTargetAddress
		selectedInstructionBasicBlock frameHolder
		canExecStepOverInstructionHolder canExecStepIntoInstructionHolder
		canExecBackOverInstructionHolder canExecBackIntoInstructionHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Others'
!

!VDBInstructionListApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBInstructionListApplication class methodsFor:'accessing'!

windowTitle
    ^ self resources string: 'Assembly'

    "Created: / 22-06-2018 / 12:25:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication class methodsFor:'menu specs'!

contextMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBInstructionListApplication andSelector:#contextMenu
     (Menu new fromLiteralArrayEncoding:(VDBInstructionListApplication contextMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Context Menu Slice'
            isVisible: true
            submenuChannel: contextMenuApplSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Item Menu Slice'
            isVisible: true
            submenuChannel: contextMenuItemSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Copy Menu Slice'
            isVisible: true
            submenuChannel: contextMenuCopySlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            label: 'Inspect Menu Slice'
            isVisible: true
            submenuChannel: contextMenuInspectSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Pin Menu'
            itemValue: doPinMenuAs:item:
            isVisible: true
            labelImage: (ResourceRetriever VDBIconLibrary pin 'Pin Menu')
            argument: 'Disassembly Actions'
          )
         )
        nil
        nil
      )

    "Modified: / 01-09-2018 / 14:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contextMenuApplSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBInstructionListApplication andSelector:#contextMenuApplSlice
     (Menu new fromLiteralArrayEncoding:(VDBInstructionListApplication contextMenuApplSlice)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canShowCurrentHolder
            label: 'Show Current Instruction'
            itemValue: doShowCurrent
            isVisible: true
          )
         (MenuItem
            enabled: canShowBranchTargetHolder
            label: 'Show Branch Traget'
            itemValue: doShowBranchTarget
            isVisible: true
          )
         (MenuItem
            enabled: canShowSelectionHolder
            label: 'Show Selection'
            itemValue: doShowSelection
            isVisible: true
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            enabled: canExecStepOverInstructionHolder         
            label: 'Step Over'
            itemValue: doExecStepOverInstruction
            isVisible: true
            labelImage: (ResourceRetriever VDBIconLibrary actionStepOver6x16 'Step Over One Instruction')
          )
         (MenuItem
            enabled: canExecStepIntoInstructionHolder
            label: 'Step Into'
            itemValue: doExecStepIntoInstruction
            isVisible: true
            labelImage: (ResourceRetriever VDBIconLibrary actionStepInto6x16 'Step Into One Instruction')
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
             enabled: canExecBackOverInstructionHolder
            label: 'Back Over'
            itemValue: doExecBackOverInstruction
            isVisible: true
          )
         (MenuItem
            enabled: canExecBackIntoInstructionHolder
            label: 'Back Into'
            itemValue: doExecBackIntoInstruction
            isVisible: true
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         )
        nil
        nil
      )

    "Modified: / 01-09-2018 / 22:02:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication class methodsFor:'utilities'!

instructions: aCollection title: aString
    ^ self new  
        instructionList: aCollection;
        title: aString;
        yourself

    "Created: / 26-06-2018 / 11:03:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'accessing'!

frame
    ^ self frameHolder value

    "Created: / 06-08-2018 / 13:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

frame: aGDBFrame
    self frameHolder value: aGDBFrame

    "Created: / 06-08-2018 / 13:22:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instructionList
    ^ self instructionListHolder value

    "Created: / 07-08-2018 / 13:27:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instructionList: aCollection
    self instructionListHolder value: aCollection

    "Created: / 22-06-2018 / 12:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'aspects'!

backgroundColorFor: aVDBPresenter
    (frameHolder value notNil and:[aVDBPresenter isInstructionPresenter]) ifTrue:[ 
        frameHolder value address == aVDBPresenter address ifTrue:[ 
            ^ Color green.
        ].
    ].

    selectedInstructionBranchTargetAddress notNil ifTrue:[ 
        aVDBPresenter isInstructionPresenter ifTrue:[ 
            aVDBPresenter instruction address = selectedInstructionBranchTargetAddress ifTrue:[ 
                ^ Color blue lighter lighter
            ].
        ].
        selectedInstructionBasicBlock notNil ifTrue:[ 
            | successor2 |

            successor2 := selectedInstructionBasicBlock successor2.
            (successor2 notNil and:[ successor2 includesAddress: aVDBPresenter address] ) ifTrue:[
                ^ Color blue lighter lighter lighter
            ].
        ].
    ].
    selectedInstructionBasicBlock notNil ifTrue:[ 
        (selectedInstructionBasicBlock includesAddress: aVDBPresenter address) ifTrue:[ 
            ^ Color yellow lighter lighter
        ].
    ].
    ^ nil

    "Created: / 26-06-2018 / 11:26:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 11:50:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foregroundColorFor: aVDBAbstractPresenter
    ^ aVDBAbstractPresenter isInstructionsAndSourcePresenter 
        ifTrue:[ Color gray ]
        ifFalse:[ nil ]

    "Created: / 26-06-2018 / 13:07:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

frameHolder
    "return/create the 'frameHolder' value holder (automatically generated)"

    frameHolder isNil ifTrue:[
        frameHolder := ValueHolder new.
        frameHolder addDependent:self.
    ].
    ^ frameHolder
!

frameHolder:something
    "set the 'frameHolder' value holder (automatically generated)"

    |oldValue newValue|

    frameHolder notNil ifTrue:[
        oldValue := frameHolder value.
        frameHolder removeDependent:self.
    ].
    frameHolder := something.
    frameHolder notNil ifTrue:[
        frameHolder addDependent:self.
    ].
    newValue := frameHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:frameHolder.
    ].
!

instructionListHolder
    "return/create the 'instructionListHolder' value holder (automatically generated)"

    instructionListHolder isNil ifTrue:[
        instructionListHolder := ValueHolder new.
        instructionListHolder addDependent:self.
    ].
    ^ instructionListHolder
!

instructionListHolder:valueModel
    "set the 'instructionListHolder' value holder (automatically generated)"

    |oldValue newValue|

    instructionListHolder notNil ifTrue:[
        oldValue := instructionListHolder value.
        instructionListHolder removeDependent:self.
    ].
    instructionListHolder := valueModel.
    instructionListHolder notNil ifTrue:[
        instructionListHolder addDependent:self.
    ].
    newValue := instructionListHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:instructionListHolder.
    ].
!

selectedInstructionHolder
    "return/create the 'selectedInstructionHolder' value holder (automatically generated)"

    selectedInstructionHolder isNil ifTrue:[
        selectedInstructionHolder := ValueHolder new.
        selectedInstructionHolder addDependent:self.
    ].
    ^ selectedInstructionHolder
!

selectedInstructionHolder:valueModel
    "set the 'selectedInstructionHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedInstructionHolder notNil ifTrue:[
        oldValue := selectedInstructionHolder value.
        selectedInstructionHolder removeDependent:self.
    ].
    selectedInstructionHolder := valueModel.
    selectedInstructionHolder notNil ifTrue:[
        selectedInstructionHolder addDependent:self.
    ].
    newValue := selectedInstructionHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedInstructionHolder.
    ].
! !

!VDBInstructionListApplication methodsFor:'change & update'!

enqueueDelayedUpdateBasicBlocks
    self enqueueDelayedUpdate: #delayedUpdateBasicBlocks

    "Created: / 26-06-2018 / 12:20:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    sender == instructionListHolder ifTrue:[ 
         self enqueueDelayedUpdateInternalList.
         ^ self.
    ].
    sender == frameHolder ifTrue:[ 
         self updateAfterFrameChanged.
         ^ self.
    ].
    sender == selectedInstructionHolder ifTrue:[ 
        self updateAfterSelectedInstructionChanged.
    ].
    super update:aspect with:param from:sender

    "Modified: / 06-08-2018 / 13:23:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterFrameChanged
    self debugger: self frame debugger.
    self updateButtonEnablements.

    "Created: / 06-08-2018 / 13:24:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 22:13:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterSelectedInstructionChanged
    | selected |

    selected := self selectedInstructionHolder value.
    selected notNil ifTrue:[
        selected isBranch ifTrue:[ 
            selectedInstructionBranchTargetAddress := selected branchTarget.
        ] ifFalse:[ 
            selectedInstructionBranchTargetAddress := nil.
        ].
        instructionBasicBlocks size > 1 ifTrue:[
            selectedInstructionBasicBlock := instructionBasicBlocks detect:[:e | e includesAddress: selected address ] ifNone: [ nil ]
        ] ifFalse:[ 
            selectedInstructionBasicBlock := nil.
        ].
    ] ifFalse:[ 
        selectedInstructionBranchTargetAddress := nil.
        selectedInstructionBasicBlock := nil.

    ].

    self enqueueDelayedInvalidateInternalList.

    "Created: / 26-06-2018 / 11:33:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 14:56:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateButtonEnablements
    | frame thread threadIsStopped canReverse |

    frame := self frameHolder value.
    frame notNil ifTrue:[ 
        thread := frame thread.
    ].
    threadIsStopped := thread notNil and:[ thread isStopped ].
    canReverse := debugger hasFeature: 'reverse'.

    self canExecStepIntoInstructionHolder value: threadIsStopped.
    self canExecStepOverInstructionHolder value: threadIsStopped.

    self canExecBackIntoInstructionHolder value: threadIsStopped & canReverse.
    self canExecBackOverInstructionHolder value: threadIsStopped & canReverse.

    "Created: / 01-09-2018 / 14:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 22:15:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'change & update-delayed'!

delayedUpdateBasicBlocks
    | instructions |

    instructions := OrderedCollection new.
    self instructionsDo: [ :e | instructions add: e ].
    instructionBasicBlocks := VDBInstructionBasicBlock analyze: instructions.
    self enqueueDelayedInvalidateInternalList.

    "Created: / 26-06-2018 / 12:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 11:33:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateInternalList
    | root |

    root := self internalListHolder root.
    root children:
        ((self instructionListHolder value ? #()) collect:[:model | 
            (model isKindOf: GDBInstructionsAndSourceLine) ifTrue:[
                (VDBInstructionsAndSourcePresenter new) setInstructionsAndSource: model;
                    parent:root;
                    yourself
            ] ifFalse:[ 
                (VDBInstructionPresenter new) setInstruction: model;
                    parent:root;
                    yourself
            ].
        ]).
    root expand.
    root children do:[:each | each expand ].
    self frame notNil ifTrue:[ 
        self scrollToAddress: self frame address.
    ].
    internalListView notNil ifTrue:[
        internalListView invalidate.
    ].
    self enqueueDelayedUpdateBasicBlocks.

    "Created: / 27-02-2015 / 15:47:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 16:13:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateSelection
    | internalSelection |

    internalSelection := self internalSelectionHolder value.
    internalSelection notNil ifTrue:[
        self selectedInstructionHolder value: internalSelection instruction
    ] ifFalse:[ 
        self selectedInstructionHolder value: nil
    ].

    "Modified: / 22-06-2018 / 15:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'event handling'!

onCommandResultEvent: aGDBStoppedEvent
    self updateButtonEnablements

    "Created: / 01-06-2017 / 23:43:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onRunningEvent: aGDBStoppedEvent
    self updateButtonEnablements

    "Created: / 21-09-2014 / 22:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 23:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onStoppedEvent: aGDBStoppedEvent
    self frame notNil ifTrue:[
        self frame thread stack. "/ to force update of (cached) frames.
        self enqueueDelayedInvalidateInternalList
    ].
    self updateButtonEnablements

    "Created: / 06-08-2018 / 14:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 22:39:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    debugger announcer 
        when: GDBStoppedEvent       send: #onStoppedEvent:  to: self;
        when: GDBRunningEvent       send: #onRunningEvent:  to: self;
        "/when: GDBExitEvent          send: #onExitEvent:     to: self;
        when: GDBCommandResultEvent send: #onCommandResultEvent: to: self.

    "Created: / 06-08-2018 / 14:44:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 14:48:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'menu actions'!

doShowBranchTarget
    | selection |

   selection := self selectedInstructionHolder value.
   (selection notNil and:[selection isBranch]) ifTrue:[ 
        | branchTarget |

        branchTarget := selection branchTarget.
        "/ For indirect jumps, `branchTarget` is `nil`.
        branchTarget notNil ifTrue:[ 
            self doShowInstructionAtAddress: branchTarget  
        ].
   ].

    "Modified: / 01-09-2018 / 14:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowCurrent
    | frame |

    frame := self frameHolder value.
    frame notNil ifTrue:[ 
        self doShowInstructionAtAddress: frame address  
    ].

    "Modified: / 01-09-2018 / 14:27:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowInstructionAtAddress: address
    self scrollToAddress: address

    "Created: / 01-09-2018 / 14:26:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doShowSelection
   | selection |

   selection := self selectedInstructionHolder value.
   selection notNil ifTrue:[ 
       self doShowInstructionAtAddress: selection address
   ].

    "Modified: / 01-09-2018 / 14:32:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'menu actions-exec'!

doExec: command
    debugger send: command andWait: false.
    self enqueueDelayedInvalidateInternalList

    "Created: / 21-09-2014 / 21:50:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 17:57:15 / jv"
    "Modified: / 01-09-2018 / 22:33:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecBackIntoInstruction
    self doExec:(GDBMI_exec_step_instruction arguments:#('--reverse'))

    "Modified: / 01-09-2018 / 22:16:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecBackOverInstruction
    self doExec:(GDBMI_exec_next_instruction arguments:#('--reverse'))

    "Modified: / 01-09-2018 / 22:16:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecSteIntoInstruction
    self doExec:GDBMI_exec_step_instruction new

    "Created: / 01-09-2018 / 22:00:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecStepOverInstruction
    self doExec:GDBMI_exec_next_instruction new

    "Modified: / 01-09-2018 / 21:59:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'menu aspects'!

canShowBranchTargetHolder
    ^ BlockValue 
        with:[ :selection | selection value notNil and:[selection value isBranch and:[selection value branchTarget notNil]]] 
        argument: self selectedInstructionHolder

    "Modified: / 01-09-2018 / 15:32:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canShowCurrentHolder
    ^ BlockValue 
        with:[ :frame | frame value notNil and:[frame value address notNil ]]
        argument: self frameHolder

    "Modified: / 01-09-2018 / 15:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canShowSelectionHolder
    ^ BlockValue 
        with:[ :selection | selection value notNil ] 
        argument: self selectedInstructionHolder

    "Modified: / 01-09-2018 / 15:33:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'menu aspects-exec'!

canExecBackIntoInstructionHolder
    canExecBackIntoInstructionHolder isNil ifTrue:[
        canExecBackIntoInstructionHolder := ValueHolder with: false.
    ].
    ^ canExecBackIntoInstructionHolder

    "Modified: / 01-09-2018 / 22:07:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecBackOverInstructionHolder
    canExecBackOverInstructionHolder isNil ifTrue:[
        canExecBackOverInstructionHolder := ValueHolder with: false.
    ].
    ^ canExecBackOverInstructionHolder

    "Modified: / 01-09-2018 / 22:07:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecStepIntoInstructionHolder
    canExecStepOverInstructionHolder isNil ifTrue:[
        canExecStepOverInstructionHolder := ValueHolder with: false.
    ].
    ^ canExecStepOverInstructionHolder

    "Modified: / 01-09-2018 / 22:08:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecStepOverInstructionHolder
    canExecStepOverInstructionHolder isNil ifTrue:[
        canExecStepOverInstructionHolder := ValueHolder with: false.
    ].
    ^ canExecStepOverInstructionHolder

    "Modified: / 01-09-2018 / 22:08:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'private'!

instructionPresentersDo: aBlock
    self internalListHolder root children do:[:each |
        each isInstructionPresenter ifTrue:[ 
            aBlock value: each
        ] ifFalse:[ 
            each children do: aBlock
        ].
    ]

    "Created: / 26-06-2018 / 12:30:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instructionsDo: aBlock
    self instructionListHolder value ? #() do:[:each |
        each instructionsDo: aBlock
    ]

    "Created: / 16-08-2018 / 11:32:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'queries'!

canSelect: anItem
    ^ anItem isInstructionPresenter

    "Created: / 22-06-2018 / 15:07:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication methodsFor:'scrolling'!

scrollToAddress: address
    internalListView isNil ifTrue:[ ^ self ].
    (self frame notNil and:[ self instructionList notEmptyOrNil ]) ifTrue:[ 
        self instructionPresentersDo:[ :each |
            each address = address ifTrue:[ 
                self scrollToListItem: each.
            ].
        ]
    ].

    "Created: / 07-08-2018 / 13:36:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionListApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

