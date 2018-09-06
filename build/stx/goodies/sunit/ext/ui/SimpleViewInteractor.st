"{ Package: 'stx:goodies/sunit/ext/ui' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SimpleViewInteractor
	instanceVariableNames:'view'
	classVariableNames:'DefaultTypeWaitTime DefaultInteractionTimeout'
	poolDictionaries:''
	category:'SUnit-Smalltalk/X-UI Testing-Interactors'
!


!SimpleViewInteractor class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    DefaultTypeWaitTime := 100. "/MSecs
    DefaultInteractionTimeout := 2000. "/MSecs

    "Modified: / 31-01-2015 / 08:23:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleViewInteractor class methodsFor:'instance creation'!

for: aView
    ^ aView interactorClass new 
        initializeForView: aView;
        yourself

    "Created: / 20-05-2014 / 09:14:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleViewInteractor methodsFor:'error handling'!

doesNotUnderstand: aMessage
    ^ [ aMessage sendTo: view ] 
        on: Object messageNotUnderstoodSignal 
        do:[:ex | super doesNotUnderstand: aMessage ].

    "Created: / 20-05-2014 / 09:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleViewInteractor methodsFor:'initialization'!

initializeForView: aSimpleView
    view := aSimpleView

    "Created: / 20-05-2014 / 09:13:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleViewInteractor methodsFor:'interaction'!

do: aBlock
    "Evaluate given block in view's event queue and wait until block is processed.
     The block is optionally passed the view as first parameter."

    self do: aBlock timeout: DefaultInteractionTimeout.

    "Created: / 31-01-2015 / 08:24:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

do: aBlock timeout: timeout
    "Evaluate given block in view's event queue and wait until block is processed.
     The block is optionally passed the view as first parameter.
     An error is thrown when the block does not finish in given time."

    | blocker1 blocker2 |

    blocker1 := Semaphore new.
    blocker2 := Semaphore new.

    view sensor pushAction:[ 
        blocker1 signal.
        aBlock valueWithOptionalArgument: view.
        blocker2 signal.
    ].
    blocker1 wait.
    (blocker2 waitWithTimeoutMs: timeout) isNil ifTrue:[ 
        self error: 'User action did not finish in ', timeout printString , 'ms'.
    ].

    "/ A thus point, `aBlock` has processed by the event queue. Now we have to 
    "/ wait for event queue to empty - some widget/tools just delay the actual action
    "/ by pushing the real work back into queue. Following makes sure those delayed
    "/ actions are processed too. 
    blocker1 := Semaphore new.
    view sensor pushAction:[
        blocker1 signal.
    ].
    blocker1 wait.


    "Created: / 31-01-2015 / 08:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-07-2016 / 18:56:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type: value
    "Send sequence of key press / key release events to the view.

    If argument is a character, send events for that character.    
    If argument is a string, send events for each character.
    If argument is a symbol, assume it's a single (symbolic) key and
        send press + release with that symbol as key
    If argument is a unspecified collection, send each element recursively.
    "

    self type: value wait: true

    "Created: / 20-05-2014 / 15:14:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-07-2014 / 07:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type: value wait: wait
    "Send sequence of key press / key release events to the view.
     If `wait` is true, wait for DefaulWaitTime milliseconds to give
     Workstation a chance to process ecents

    If argument is a character, send events for that character.    
    If argument is a string, send events for each character.
    If argument is a symbol, assume it's a single (symbolic) key and
        send press + release with that symbol as key
    If argument is a unspecified collection, send each element recursively.
    "

    value isCharacter ifTrue:[
        view device simulateKeyboardInput: value inViewId:view id.
    ] ifFalse:[ value isSymbol ifTrue:[
        | raw modifiers ctrl cmd shift |

        raw := view device keyboardMap bindingForLogical: value.
        raw isNil ifTrue:[ 
            | aliases |

            aliases := view device keyboardMap aliasesForLogical: value.
            aliases notEmptyOrNil ifTrue:[ 
                raw := aliases anElement.
            ].
        ].
        raw isNil ifTrue:[ 
            raw := value.
        ].
        ctrl := cmd := shift := false.
        (raw startsWith: 'Ctrl') ifTrue:[
            ctrl := true.
            modifiers := (modifiers ? 0) | view device ctrlModifierMask.
            raw := raw copyFrom: 5.
        ].
        (raw startsWith: 'Cmd') ifTrue:[
            cmd := true.                 
            modifiers := (modifiers ? 0) | view device metaModifierMask.
            raw := raw copyFrom: 4.
        ].
        (raw startsWith: 'Shift') ifTrue:[
            shift := true.
            modifiers := (modifiers ? 0) | view device shiftModifierMask.
            raw := raw copyFrom: 6.
        ].        
        (raw size == 1 and:[raw first isUppercase]) ifTrue:[ 
             shift := true.
             modifiers := (modifiers ? 0) | view device shiftModifierMask.
             raw := raw first asLowercase codePoint.
        ] ifFalse:[ 
            (raw startsWith: 'Cursor') ifTrue:[ 
                raw := raw copyFrom: 7.
            ].
        ].
        ctrl ifTrue:[ 
            view device sendKeyOrButtonEvent: #keyPress x: 10 y: 10 keyOrButton: #Control_L state: modifiers toViewId: view id.            
        ].
        cmd ifTrue:[ 
            view device sendKeyOrButtonEvent: #keyPress x: 10 y: 10 keyOrButton: #Alt_L state: modifiers toViewId: view id.            
        ].
        shift ifTrue:[ 
            view device sendKeyOrButtonEvent: #keyPress x: 10 y: 10 keyOrButton: #Shift_L state: modifiers toViewId: view id.            
        ].
        view device sendKeyOrButtonEvent: #keyPress x: 10 y: 10 keyOrButton: raw state: modifiers toViewId: view id.
        view device sendKeyOrButtonEvent: #keyRelease x: 10 y: 10 keyOrButton: raw state: modifiers toViewId: view id.
        shift ifTrue:[ 
            view device sendKeyOrButtonEvent: #keyRelease x: 10 y: 10 keyOrButton: #Shift_L state: modifiers toViewId: view id.            
        ].
        cmd ifTrue:[ 
            view device sendKeyOrButtonEvent: #keyRelease x: 10 y: 10 keyOrButton: #Alt_L state: modifiers toViewId: view id.            
        ].
        ctrl ifTrue:[ 
            view device sendKeyOrButtonEvent: #keyRelease x: 10 y: 10 keyOrButton: #Control_L state: modifiers toViewId: view id.            
        ]        
    ] ifFalse:[
        value do:[:each | self type: each wait: false ]
    ]].

    wait ifTrue:[ 
        "/ Give some time to (external) window system to process
        "/ events (for example, X server may need some time to catch
        "/ up with new events and deliver them back to the application.
        Delay waitForMilliseconds: DefaultTypeWaitTime.

        "/ Now let's hope window system has delivered events back to
        "/ Smalltalk/X. Synchronize on view's internal event queue
        "/ (make sure all events are processed).
        self wait.
    ].

    "Created: / 23-07-2014 / 07:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-09-2018 / 11:07:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wait
    "Wait (block the caller) until all event is the event queue are processed."

    self do:[] timeout: nil

    "Created: / 18-07-2016 / 18:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleViewInteractor methodsFor:'navigation'!

/ aString
    "Return an interactor for subview named `aString`"

    | subviews |

    subviews := view subViews select:[:each | each name = aString ].
    subviews size == 1 ifTrue:[ ^ subviews anElement interactor ].
    subviews isEmpty 
        ifTrue:[ self error: ('No sub-componenents with name ''%1''' bindWith: aString)  ]
        ifFalse: [ self error: ('Multiple sub-componenents with name ''%1''' bindWith: aString) ]

    "Created: / 20-05-2014 / 09:26:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2015 / 08:17:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleViewInteractor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


SimpleViewInteractor initialize!
