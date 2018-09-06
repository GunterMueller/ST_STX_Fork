"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Controller subclass:#ButtonController
	instanceVariableNames:'enableChannel pressChannel releaseChannel pressed active entered
		isTriggerOnDown autoRepeat repeatBlock initialDelay repeatDelay
		pressActionBlock releaseActionBlock isToggle isRadio buttonDown
		doubleClickActionBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!ButtonController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    ButtonControllers are used with buttons and handle all user interaction.
    These are automatically created when a Button is created, therefore no manual
    action is required for creation.
    In normal applications, you don't have to care for the controller; 
    access to the controllers behavior is possible via messages to the button.
    (setting actions, controlling autorepeat etc.)

    A ButtonController supports 3 types of notifications:
        MVC change notification - as usual
        channel notifications   - through the pressChannel/releaseChannels
        action callBack         - through pressAction / releaseAction blocks.

    Notifications are made in the above order (i.e. an actionBlock sees the model
    already changed, if there is a model).

    Having multiple mechanisms here is both historic and to make the life
    of simple applications easier - most buttons don't need a model or notification
    channels and simply perform some action.
    In general: actionBlocks are useful, if there is a single subject which
    needs to be told about the press (i.e. actionButtons); 
    models should be used when the button represents some value in some other
    object.
    Channels are much like the MVC approach, however, these are useful if
    press/release/label etc. may come from different objects, and a single 
    (synthetic) model does not make sense or is not appropriate.

    Actually, the channels are the most general - and the other mechanism could
    (and will, maybe) based upon them; after all, an actionBlock is a channel,
    whcih sends #value to its block ....



    See examples in the Button class.

    [Instance variables:]

      enableChannel           <ValueHolder    pressing is allowed (default: true)
                               on Boolean>    

      pressed                 <Boolean>       true if currently pressed (read-only)

      entered                 <Boolean>       true if the cursor is currently in this view

      isTriggerOnDown         <Boolean>       controls if the action should be executed on
                                              press or on release (default: on release).

      isToggle                <Boolean>       controls if the button should show toggle
                                              behavior (as opposed to one-shot behavior)

      pressActionBlock        <Block>         block to evaluate when pressed (default: noop)

      releaseActionBlock      <Block>         block to evaluate when released (default: noop)

      autoRepeat              <Boolean>       auto-repeats when pressed long enough (default: false)

      initialDelay            <Number>        seconds till first auto-repeat (default: 0.2)

      repeatDelay             <Number>        seconds of repeat intervall (default: 0.025)

      repeatBlock             <Block>         block evaluated for auto-repeat (internal)

      active                  <Boolean>       true during action evaluation (internal)

    [author:]
        Claus Gittinger
"
! !

!ButtonController class methodsFor:'defaults'!

defaultInitialDelay
    "when autorepeat is enabled, and button is not released,
     start repeating after initialDelay seconds"

    ^ 0.2
!

defaultRepeatDelay
    "when autorepeat is enabled, and button is not released,
     repeat every repeatDelay seconds"

    ^ 0.025
! !

!ButtonController methodsFor:'accessing-behavior'!

action:aBlock
    "convenient method: depending on the setting the triggerOnDown flag,
     either set the press-action & clear any release-action or
     vice versa, set the release-action and clear the press-action."

    isTriggerOnDown ifTrue:[
        releaseActionBlock := nil.
        pressActionBlock := aBlock
    ] ifFalse:[
        releaseActionBlock := aBlock.
        pressActionBlock := nil
    ].

    "Modified: 9.2.1996 / 22:41:22 / cg"
!

autoRepeat
    "turn on autorepeat. OBSOLETE; use #autoRepeat:"

    self autoRepeat:true.

    "Modified: 9.2.1996 / 22:42:46 / cg"
!

autoRepeat:aBoolean
    "turn on/off autorepeat"

    autoRepeat := aBoolean.
    repeatBlock := MessageSend receiver:self selector:#repeat. "/ [self repeat]

    "Modified: 5.9.1995 / 22:06:00 / claus"
    "Modified: 20.3.1997 / 21:56:13 / cg"
!

beButton
    "make the receiver act like a button; that's the default, anyway"

    "/ because I will be a trigger-on-up button
    (isTriggerOnDown 
    and:[pressActionBlock notNil 
    and:[releaseActionBlock isNil]]) ifTrue:[
        pressActionBlock := releaseActionBlock.
        releaseActionBlock := nil.
    ].

    isTriggerOnDown := false.
    isToggle := false.
    isRadio := false.

    "Modified: 15.7.1996 / 13:42:15 / cg"
    "Created: 27.1.1997 / 13:30:11 / cg"
!

beRadioButton
    "make the receiver act like a radioButton;
     That is like a toggle, but do not allow turning myself off
     by buttonPress (instead, must be turned off by another button or programmatically)"

    "/ because I will be a trigger-on-down button
    (isTriggerOnDown not 
    and:[releaseActionBlock notNil 
    and:[pressActionBlock isNil]]) ifTrue:[
        pressActionBlock := releaseActionBlock.
        releaseActionBlock := nil.
    ].

    isTriggerOnDown := true.
    isToggle := false.
    isRadio := true.
!

beToggle
    "make the receiver act like a toggle"

    "/ because I will be a trigger-on-down button
    (isTriggerOnDown not 
    and:[releaseActionBlock notNil 
    and:[pressActionBlock isNil]]) ifTrue:[
        pressActionBlock := releaseActionBlock.
        releaseActionBlock := nil.
    ].

    isTriggerOnDown := true.
    isToggle := true.
    isRadio := false.

    "Modified: 15.7.1996 / 13:42:15 / cg"
!

beTriggerOnDown
    "make the receiver act on button press"

    isTriggerOnDown := true
!

beTriggerOnUp
    "make the receiver act on button release"

    isTriggerOnDown := false
!

disable
    "alternative invokation; redirected to basic mechanism"

    self enabled:false

    "Modified: / 30.3.1999 / 14:50:12 / stefan"
!

doubleClickAction
    "return the doubleClickAction; that's the block which gets evaluated
     when the button is double-clicked (if non-nil).
     Seldom used with buttons"

    ^ doubleClickActionBlock
!

doubleClickAction:aBlock
    "define the action to be performed on double click"

    doubleClickActionBlock := aBlock.
!

enable
    "alternative invokation; redirected to basic mechanism"

    self enabled:true

    "Modified: / 30.3.1999 / 14:50:01 / stefan"
!

enabled:aBoolean
    "disable the button"

    enableChannel value ~~ aBoolean ifTrue:[
        enableChannel value:aBoolean.
        "/ view redraw    - not needed; I listen to enableChannel
    ]

    "Created: / 30.3.1999 / 14:49:05 / stefan"
!

isTriggerOnDown
    "return true, if I trigger on press
     (in contrast to triggering on up, which is the default)"

    ^ isTriggerOnDown
!

pressAction
    "return the pressAction; that's the block which gets evaluated
     when the button is pressed (if non-nil)"

    ^ pressActionBlock
!

pressAction:aBlock
    "define the action to be performed on press"

    pressActionBlock := aBlock.
!

releaseAction
    "return the releaseAction; that's the block which gets evaluated
     when the button is released (if non-nil)"

    ^ releaseActionBlock
!

releaseAction:aBlock
    "define the action to be performed on release"

    releaseActionBlock := aBlock.
!

triggerOnDown:aBoolean
    "set/clear the flag which controls if the action block is to be evaluated
     on press or on release. 
     (see also ST-80 compatibility methods beTriggerOn*)"

    isTriggerOnDown := aBoolean
! !

!ButtonController methodsFor:'accessing-channels'!

enableChannel
    "return the valueHolder holding the enable boolean value"

    ^ enableChannel

    "Modified: 30.4.1996 / 15:09:30 / cg"
!

enableChannel:aValueHolder
    "set the valueHolder, which holds the enable boolean value"

    |wasEnabled|

    enableChannel notNil ifTrue:[
        wasEnabled := enableChannel value.
        enableChannel retractInterestsFor:self. 
    ] ifFalse:[
        wasEnabled := true
    ].
    enableChannel := aValueHolder.
    aValueHolder onChangeSend:#enableStateChanged to:self.

    enableChannel value ~~ wasEnabled ifTrue:[
        self enableStateChanged

    ]

    "Modified: 17.9.1995 / 19:41:18 / claus"
!

pressChannel

    ^ pressChannel
!

pressChannel:aChannel
    pressChannel := aChannel
!

releaseChannel

    ^ releaseChannel
!

releaseChannel:aChannel
    releaseChannel := aChannel
! !

!ButtonController methodsFor:'accessing-state'!

active
    "return true, if I am active; 
     that is: currently performing my action.
     This query can be used to avoid multiple redraws."

    ^ active
!

active:aBoolean
    active := aBoolean
!

enabled
    "return true, if I am enabled"

    ^ enableChannel value
!

entered
    "return true, if the mouse pointer is currently in my view"

    ^ entered
!

entered:aBoolean
    entered := aBoolean
!

pressed
    "return true, if I am pressed"

    ^ pressed
!

pressed:aBoolean
    pressed ~~ aBoolean ifTrue:[
	pressed := aBoolean.
	self performAction.
    ].
!

setPressed:aBoolean
    pressed := aBoolean.

    "Created: 14.11.1995 / 21:37:08 / cg"
!

toggle
    "toggle and perform the action"

    enableChannel value ifTrue:[
        self toggleNoAction.
        self performAction.
        view changed:#toggle with:pressed
    ]
!

toggleNoAction
    "toggle, but do NOT perform any action"

    pressed ifTrue:[
        view turnOff.
        pressed := false.
    ] ifFalse:[
        view turnOn.
        pressed := true.
    ].
    view repairDamage

    "Modified: / 4.3.1998 / 13:35:12 / cg"
! !

!ButtonController methodsFor:'event handling'!

buttonMotion:buttonState x:x y:y
    (x >= 0 and:[x < view width
    and:[y >= 0 and:[y < view height]]]) ifTrue:[
        entered ifFalse:[
            self pointerEnter:buttonState x:x y:y
        ]
    ] ifFalse:[
        entered ifTrue:[
            self pointerLeave:buttonState
        ]
    ]
!

buttonMultiPress:button x:x y:y
    doubleClickActionBlock notNil ifTrue:[
        doubleClickActionBlock valueWithOptionalArgument:view.
        ^ self.
    ].    
    ^ self buttonPress:button x:x y:y
!

buttonPress:button x:x y:y
    |wg|

    "/ simulate momentary loss of focus to force accept into models in other components
    wg := view windowGroup.
    wg notNil ifTrue:[
        wg focusMomentaryRelease.
    ].

    (button == 1) ifFalse:[
        ^ super buttonPress:button x:x y:y
    ].

    buttonDown := true.

    enableChannel value ifTrue:[
        isToggle ifTrue:[
            self toggle.
            ^ self
        ].
        isRadio ifTrue:[
            pressed ifFalse:[
                self toggle
            ].
            ^ self
        ].

        pressed ifFalse:[
            pressed := true.
            view showActive.
            "/ make sure that a momentary press is visible
            view repairDamage.
            Delay waitForSeconds:0.1.

            (pressActionBlock notNil or:[model notNil]) ifTrue:[
                "
                 force output - so that button is drawn correctly in case
                 of any long-computation (at high priority)
                "
                view flush.
            ].

            self performAction.
            view notNil ifTrue:[
                view flush.
            ].

            autoRepeat ifTrue:[
                Processor addTimedBlock:repeatBlock afterSeconds:initialDelay
            ]
        ]
    ]

    "Modified: / 28-03-2012 / 13:08:38 / cg"
!

buttonRelease:button x:x y:y
    "button was released - if enabled, perform releaseaction"

    (button == 1) ifFalse:[
        ^ super buttonRelease:button x:x y:y
    ].

    buttonDown := false.

    (isToggle or:[isRadio]) ifTrue:[
        ^ self
    ].

    pressed ifTrue:[
        autoRepeat ifTrue:[
            Processor removeTimedBlock:repeatBlock
        ].
        pressed := false.
        view showPassive.

        enableChannel value ifTrue:[
            "
             only perform action if released within myself
            "
            ((x >= 0) 
            and:[x <= view width
            and:[y >= 0
            and:[y <= view height]]]) ifTrue:[
                (releaseActionBlock notNil or:[model notNil]) ifTrue:[
                    "
                     force output - so that button is drawn correctly in case
                     of any long-computation (at high priority)
                    "
                    view flush.
                ].

                self performAction.
            ]
        ]
    ]

    "Modified: 8.3.1997 / 00:04:19 / cg"
!

enableStateChanged
    "this is sent, whenever the enable value has changed"

    view notNil ifTrue:[
        view invalidate "redraw".
        view 
            cursor:(
                enableChannel value 
                    ifTrue:[ Cursor hand ]
                    ifFalse:[ Cursor normal ])
    ]

    "Modified: 17.9.1995 / 19:55:52 / claus"
    "Modified: 17.4.1997 / 01:53:14 / cg"
!

keyPress:key x:x y:y
    "trigger on Return and space, if I am the focusView of my group
     (i.e. if I got an explicit focus)"

"/    <resource: #keyboard (#Return)>

    |simulateClick|

    view hasExplicitFocus ifTrue:[
        simulateClick := false.
        simulateClick := (key == Character space).
        simulateClick ifFalse:[
            ((key == #Return) and:[ isToggle not and:[isRadio not]]) ifTrue:[
                simulateClick := true.
            ].
        ].

        simulateClick ifTrue:[
            "just simulate a buttonPress/release here."
            self buttonPress:1 x:0 y:0.
            self buttonRelease:1 x:0 y:0.
            ^ self.
        ]
    ].
    view keyPress:key x:x y:y

    "Modified: / 07-03-2012 / 11:47:40 / cg"
!

performAction
    |action value|

    (isToggle or:[isRadio]) ifTrue:[
        value := pressed
    ] ifFalse:[
        value := true
    ].

    "
     ST-80 style model notification ...
     this updates the model (typically, a ValueHolder)
    "
    (isToggle
    or:[(isTriggerOnDown and:[pressed])
    or:[isTriggerOnDown not and:[pressed not]]]) ifTrue:[
        "the ST-80 way of doing things"
        view notNil ifTrue:[
            active := true.
            view sendChangeMessageWith:value.
            active := false.
        ].
    ].

    "
     ST/X style actionBlock evaluation & channel notification ...
    "
    pressChannel notNil ifTrue:[
        pressed ifTrue:[
            pressChannel value:true 
        ]
    ].
    releaseChannel notNil ifTrue:[
        pressed ifFalse:[
            releaseChannel value:true
        ]
    ].

    pressed ifTrue:[
        action := pressActionBlock.
    ] ifFalse:[
        action := releaseActionBlock.
    ].

    action notNil ifTrue:[
        active := true.
        action valueWithOptionalArgument:value.
        active := false.
    ].

    "Modified: 24.1.1997 / 11:38:20 / cg"
!

performShortcutAction
    enableChannel value ifTrue:[
        isToggle ifTrue:[
            self toggle.
            ^ self
        ].
        isRadio ifTrue:[
            pressed ifFalse:[
                self toggle
            ].
            ^ self
        ].

        self performAction.
    ]
!

pointerEnter:state x:x y:y
    "mouse pointer entered my view.
     Redraw with enteredColors if they differ from the normal colors"

    entered := true.
    enableChannel value ifTrue:[
        pressed ifTrue:[
            isTriggerOnDown ifFalse:[
                view showActive.
            ].

            "
             reentered after a leave with mouse-button down;
             restart autorepeating and/or if I am a button with
             triggerOnDown, show active again.
            "
            autoRepeat ifTrue:[
                Processor addTimedBlock:repeatBlock afterSeconds:initialDelay
            ].
        ].
        view invalidate
    ]

    "Modified: 26.5.1996 / 18:09:06 / cg"
!

pointerLeave:state
    "mouse pointer left my view.
     Redraw with normal colors if they differ from enteredColors"

    entered := false.
    "/ sometimes could happen that the view becomes nil
    view isNil ifTrue:[^ self].

    pressed ifTrue:[
        isTriggerOnDown ifFalse:[
            view showPassive.
        ] ifTrue:[
            view invalidate
        ].

        "
         leave with mouse-button down;
         stop autorepeating and/or if I am a button with
         action on release, show passive
        "
        autoRepeat ifTrue:[
            Processor removeTimedBlock:repeatBlock
        ].
    ].
    enableChannel value ifTrue:[
        view invalidate
    ]

    "Modified: 1.4.1997 / 13:27:32 / cg"
!

repeat
    "this is sent from the autorepeat-block, when the button has been pressed long
     enough; it simulates a release-press, by evaluating both release
     and press actions."

    |dly|

    (pressed and:[entered]) ifTrue:[
        enableChannel value ifTrue:[
            active ifFalse:[
                "/ don't repeat, if a release is pending ...
                "/ (must check this, because the release event could
                "/  stick in the queue, since exposes are handled first,
                "/  which could lead to event processing to never happen)
                (view sensor hasButtonReleaseEventFor:view) ifFalse:[
                    self performAction.

                    autoRepeat ifTrue:[
                        view graphicsDevice shiftDown ifTrue:[
                            dly := repeatDelay / 4.
                        ] ifFalse:[
                            dly := repeatDelay
                        ].
                        Processor addTimedBlock:repeatBlock afterSeconds:dly
                    ]
                ]
            ].
        ]
    ]

    "Modified: 28.5.1996 / 20:21:24 / cg"
!

requestAutoAccept
    "request to autoAccept from a keyboardProcessor.
     AutoAccept is always allowed"

    ^ true.
    "/ used to be:
    "/    ^ self enabled and:[view isDefault]
! !

!ButtonController methodsFor:'initialization'!

controlInitialize
    active := false.
    entered := false.

    "Created: 24.7.1997 / 14:58:28 / cg"
    "Modified: 24.7.1997 / 14:59:06 / cg"
!

initialize
    super initialize.

    enableChannel := ValueHolder with:true.
    enableChannel onChangeSend:#enableStateChanged to:self.

    active := false.
    pressed := false.
    entered := false.
    autoRepeat := false.
    initialDelay := self class defaultInitialDelay.
    repeatDelay := self class defaultRepeatDelay.
    isTriggerOnDown := false.
    isToggle := isRadio := false.

    "Modified: / 21.5.1998 / 03:07:02 / cg"
!

reinitialize
    active := false.
    (isToggle or:[isRadio]) ifFalse:[
        pressed := false.
    ].
    entered := false.

    "Modified: / 1.3.2000 / 15:17:10 / cg"
!

release
    "release all dependencies"

    enableChannel notNil ifTrue:[
        enableChannel retractInterestsFor:self.
        enableChannel := nil.
    ].
    super release
! !

!ButtonController class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

