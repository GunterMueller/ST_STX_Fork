"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractTreeApplication subclass:#VDBVariableObjectListApplication
	instanceVariableNames:'frameHolder variableObjectListHolder selectedVariableObjectHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Others'
!

!VDBVariableObjectListApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBVariableObjectListApplication class methodsFor:'accessing'!

windowTitle
    ^ 'Variables'

    "Created: / 11-07-2017 / 16:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectListApplication class methodsFor:'interface specs'!

columnsSpec
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:VDBFrameApplication andSelector:#columnsSpec
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Value'
         labelAlignment: left
         labelButtonType: Button
         width: 1.0
         height: heightOfFirstRow
         menuFromApplication: false
         printSelector: value
         backgroundSelector: backgroundColor
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
! !

!VDBVariableObjectListApplication class methodsFor:'plugIn spec'!

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
        #variableObjectListHolder
        #selectedVariableHolder
      ).

    "Modified: / 03-02-2018 / 09:52:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectListApplication class methodsFor:'startup-web applications'!

initialPageSpec
    "this is only required for web-applications"

    ^ self shouldImplement
!

pageSpecs
    "this is only required for web-applications"

    ^ self shouldImplement
! !

!VDBVariableObjectListApplication methodsFor:'accessing'!

variableObjectList: aSequencableCollection
    self variableObjectListHolder value: aSequencableCollection

    "Created: / 03-02-2018 / 08:07:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectListApplication methodsFor:'aspects'!

backgroundColorFor: aVDBVariableOjectPresenter
    ^ aVDBVariableOjectPresenter varobj hasChanged
        ifTrue:[ Color yellow lighter lighter ]
        ifFalse:[ nil ]

    "Created: / 01-02-2018 / 09:08:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foregroundColorFor: aVDBVariableOjectPresenter
    | value |

    value := aVDBVariableOjectPresenter valueString.
    ((value includesSubString: 'invalid') or:[ value includesSubString: 'cannot']) ifTrue:[ 
        ^ Color red
    ].
    ^ nil

    "Created: / 30-07-2018 / 11:14:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedVariableObjectHolder
    "return/create the 'selectedVariableHolder' value holder (automatically generated)"
    
    selectedVariableObjectHolder isNil ifTrue:[
        selectedVariableObjectHolder := ValueHolder new.
        selectedVariableObjectHolder addDependent:self.
    ].
    ^ selectedVariableObjectHolder
!

selectedVariableObjectHolder:something 
    "set the 'selectedVariableHolder' value holder (automatically generated)"
    
    | oldValue  newValue |

    selectedVariableObjectHolder notNil ifTrue:[
        oldValue := selectedVariableObjectHolder value.
        selectedVariableObjectHolder removeDependent:self.
    ].
    selectedVariableObjectHolder := something.
    selectedVariableObjectHolder notNil ifTrue:[
        selectedVariableObjectHolder addDependent:self.
    ].
    newValue := selectedVariableObjectHolder value.
    oldValue ~~ newValue ifTrue:[
        self 
            update:#value
            with:newValue
            from:selectedVariableObjectHolder.
    ].
!

variableObjectListHolder
    "return/create the 'variableObjectListHolder' value holder (automatically generated)"

    variableObjectListHolder isNil ifTrue:[
        variableObjectListHolder := ValueHolder with: #().
        variableObjectListHolder addDependent:self.
    ].
    ^ variableObjectListHolder

    "Modified: / 03-02-2018 / 07:33:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableObjectListHolder:something
    "set the 'variableObjectListHolder' value holder (automatically generated)"

    |oldValue newValue|

    variableObjectListHolder notNil ifTrue:[
        oldValue := variableObjectListHolder value.
        variableObjectListHolder removeDependent:self.
    ].
    variableObjectListHolder := something.
    variableObjectListHolder notNil ifTrue:[
        variableObjectListHolder addDependent:self.
    ].
    newValue := variableObjectListHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:variableObjectListHolder.
    ].
! !

!VDBVariableObjectListApplication methodsFor:'change & update'!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    sender == variableObjectListHolder ifTrue:[ 
         self enqueueDelayedUpdateInternalList.
         ^ self.
    ].
    super update:aspect with:param from:sender

    "Modified: / 03-02-2018 / 09:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectListApplication methodsFor:'change & update-delayed'!

delayedInvalidateInternalList

    "/ Updating children may take a while as it needs to issue
    "/ several commands to the GDB and wait for results. To avoid
    "/ flickering, we first force an update of all values
    "/ in background and then force an invalidate.
    "/ 
    "/ Note, that update of each individual variable is pushed back 
    "/ to event queue, allowing the UI to react for user events that 
    "/ may have come meanwhile.

    | children changed |

    children := internalListHolder root children.
    changed := false.
    children do:[:each | 
        self enqueueDelayedAction: [ 
            "/ Update the child, but only if the list of currently displayed
            "/ children remains the same. Keep in mind that user may have
            "/ have switched to another frame before we're finished with the update.
            internalListHolder root children == children ifTrue: [ changed := each varobj hasChanged or:[changed] ] 
        ].
    ].
    self enqueueDelayedAction:[ 
        (internalListHolder root children == children and:[changed]) ifTrue:[ super delayedInvalidateInternalList ].
    ]

    "Created: / 06-02-2018 / 12:52:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2018 / 09:42:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateInternalList
    | root |

    debugger isNil ifTrue:[
        self internalListHolder root children:#().
        ^ self.
    ].
    root := self internalListHolder root.
    root children:(self variableObjectListHolder value
                collect:[:v | 
                    (VDBVariableObjectPresenter new) setVarobj:v;
                        parent:root;
                        yourself
                ]).
    root expand.
    root children size == 1 ifTrue:[ 
        root children first expand
    ].
    internalListView notNil ifTrue:[
        internalListView invalidate.
    ]

    "Created: / 27-02-2015 / 15:47:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-05-2018 / 10:40:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateSelection
    | internalSelection |

    internalSelection := self internalSelectionHolder value.
    internalSelection notNil ifTrue:[
        self selectedVariableObjectHolder value: internalSelection varobj
    ] ifFalse:[ 
        self selectedVariableObjectHolder value: nil
    ].

    "Modified: / 28-01-2018 / 22:50:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectListApplication methodsFor:'drag & drop'!

dropObjects:aCollectionOfDropObjects
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefined in order for drop to work."

    ^ self shouldImplement
! !

!VDBVariableObjectListApplication methodsFor:'event handling'!

onStoppedEvent: aGDBStoppedEvent
    self enqueueDelayedInvalidateInternalList

    "Created: / 01-02-2018 / 23:14:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectListApplication methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    debugger announcer
        when: GDBStoppedEvent               send: #onStoppedEvent: to: self

    "Created: / 01-02-2018 / 23:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectListApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

