"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

Object subclass:#EnterFieldGroup
	instanceVariableNames:'fields currentField leaveAction wrap leaveOnTabLast'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support'
!

!EnterFieldGroup class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    EnterFieldGroup controls the interaction between EnterFields
    enabling the next/prev field when a field is left. 
    Instances of this class keep track of which field of the group is the 
    currentField (i.e. the one getting keyboard input) and forwards input
    to that one.
    This is done by arranging for all of my fields to delegate their
    input to me, which is then forwarded to the active field).

    The block accessible as leaveAction is evaluated when the last
    field of the group is left (by cursor-down or cr). 
    Usually this block triggers accept on the fields (if they did not already)
    and/or performs some followup processing and possibly closes the topview 
    (for example: in a dialog).

    EnterFieldGroups can be used as a delegate (of the topView) to forward
    input (entered into the topView) to the currently active field.

    Stepping to previous field is via CursorUp/PreviousField,
    to next field via CursorDown/NextField/Tab.
    By default, tabbing via #Tab is disabled - to enable it, send the field
    a #makeTabable or #makeAllTabable to the group.

    All of this here is low level stuff, providing a lot of freedom in
    which keys are handled and how they perform.
    Normally, these are not required for most users - the DialogBox sets up
    things correctly for most cases.


    [Instance variables:]

        fields          <Collection of EditField>       the fields of the group

        currentField    <EditField>                     the active field

        leaveAction     <nil|Block>                     action to perform, when the
                                                        last field is left by a non-wrap

        wrap            <Boolean>                       if true, non-return next-keys wrap
                                                        back to the first field.
                                                        If false (the default), next in
                                                        the last field is taken as return.
                                                        This is ignored, if no leaveAction was 
                                                        defined.

        leaveOnTabLast  <Boolean>                       if true, tabbing out of the last
                                                        field leaves the group.
                                                        The default is false.

    [author:]
        Claus Gittinger


    [see also:]
        DialogBox
        EditField
"
!

examples 
"
    without a group - user has to enter mouse into the next field to activate it;
    Cursor-keys don't work:
                                                                        [exBegin]
        |top panel field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        top open
                                                                        [exEnd]


    with a group - Return-key or CursorKey enables next field:
    (but still, mouse pointer has to be moved into any of the fields,
     because the topView does not forward its input into the fields.
     Also, tabbing is not possible here)
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.

        top open
                                                                        [exEnd]



    same, enables tabbing within the group via the Tab key
    (but still, the mouse pointer must be in one of the fields):
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.

        field1 makeTabable.
        field2 makeTabable.
        field3 makeTabable.
        top open
                                                                        [exEnd]
    individual makeTabable messages to the fields allows single
    fields to be sticky (i.e. explicit click is needed to get out
    of it) - this is very seldom required.
    To make all fields tabable (the usual case), there is a shortCut:
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.
        group makeAllTabable.

        top open
                                                                        [exEnd]



    use a delagation from the outerView to the group - 
    Return-key or CursorKey enables next field:
    input for topView is delegated to the group, which also behaves
    as a unit w.r.t. keyboard focus (move pointer in and out).
    Again, without tabbing:
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.

        top delegate:group.
        top open
                                                                        [exEnd]


    and, with tabbing:
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.
        group makeAllTabable.

        top delegate:group.
        top open
                                                                        [exEnd]



    as above, but close the box when the last field is left
    via return - notice, that tabbing still wraps around:
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.
        group leaveAction:[top destroy].
        group makeAllTabable.

        top delegate:group.
        top open
                                                                        [exEnd]

    in the next example, tabbing out of the last field
    closes the box as well:
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.
        group leaveAction:[top destroy].
        group makeAllTabable.
        group leaveOnTabLast:true.

        top delegate:group.
        top open
                                                                        [exEnd]


    the next example shows that the input order is defined by the
    order in the group; NOT by the physical layout of the fields in the superview:
    (i.e. you can arrange your fields in multiple framedBoxes, panels or
     subviews - independent of the tab-stepping order)
                                                                        [exBegin]
        |top panel group field1 field2 field3|

        top := StandardSystemView label:'reverse'.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field3; add:field2; add:field1.
        group leaveAction:[top destroy].
        group makeAllTabable.

        top delegate:group.
        top open
                                                                        [exEnd]



    using a single model for all fields:
    (here, we use a Plug to simulate a more complex model):
                                                                        [exBegin]
        |top panel group field1 field2 field3 model
         value1 value2 value3|

        top := StandardSystemView new.
        top extent:200@200.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        panel add:(field1 := EditField extent:(1.0 @ nil)).
        panel add:(field2 := EditField extent:(1.0 @ nil)).
        panel add:(field3 := EditField extent:(1.0 @ nil)).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.
        group leaveAction:[top destroy].
        group makeAllTabable.

        value1 := 'one'. value2 := 'two'. value3 := 'three'.

        model := Plug new.
        model respondTo:#value1 with:[value1].
        model respondTo:#value1: with:[:arg | value1 := arg].
        model respondTo:#value2 with:[value2].
        model respondTo:#value2: with:[:arg | value2 := arg].
        model respondTo:#value3 with:[value3].
        model respondTo:#value3: with:[:arg | value3 := arg].

        field1 model:model; aspect:#value1; change:#value1:.
        field2 model:model; aspect:#value2; change:#value2:.
        field3 model:model; aspect:#value3; change:#value3:.

        top delegate:group.
        top openModal.

        Transcript showCR:'value1: ' , value1.
        Transcript showCR:'value2: ' , value2.
        Transcript showCR:'value3: ' , value3.
                                                                        [exEnd]


    all of the above is done automatically for you, 
    if you add inputFields to a dialogBox.
    Here, all fields use the same model, but different aspects:
                                                                        [exBegin]
        |box model
         value1 value2 value3|

        box := DialogBox new.
        box extent:200@200.

        value1 := 'one'. value2 := 'two'. value3 := 'three'.

        model := Plug new.
        model respondTo:#value1 with:[value1].
        model respondTo:#value1: with:[:arg | value1 := arg].
        model respondTo:#value2 with:[value2].
        model respondTo:#value2: with:[:arg | value2 := arg].
        model respondTo:#value3 with:[value3].
        model respondTo:#value3: with:[:arg | value3 := arg].

        (box addInputFieldOn:model) aspect:#value1; change:#value1:.
        box addVerticalSpace.
        (box addInputFieldOn:model) aspect:#value2; change:#value2:.
        box addVerticalSpace.
        (box addInputFieldOn:model) aspect:#value3; change:#value3:.

        box addOkButton.

        box open.

        Transcript showCR:'value1: ' , value1.
        Transcript showCR:'value2: ' , value2.
        Transcript showCR:'value3: ' , value3.
                                                                        [exEnd]

    Here, the fields use different models, but the same aspect:
                                                                        [exBegin]
        |box model
         valueHolder1 valueHolder2 valueHolder3|

        box := DialogBox new.
        box extent:200@200.

        valueHolder1 := 'one' asValue. 
        valueHolder2 := 'two' asValue. 
        valueHolder3 := 'three' asValue.

        box addInputFieldOn:valueHolder1.
        box addVerticalSpace.
        box addInputFieldOn:valueHolder2.
        box addVerticalSpace.
        box addInputFieldOn:valueHolder3.

        box addOkButton.

        box open.

        Transcript showCR:'value1: ' , valueHolder1 value.
        Transcript showCR:'value2: ' , valueHolder2 value.
        Transcript showCR:'value3: ' , valueHolder3 value.
                                                                        [exEnd]
"

    "Created: 27.4.1996 / 16:43:28 / cg"
! !

!EnterFieldGroup methodsFor:'accessing'!

currentField
    "return the field which currently has the focus"

     ^ currentField
!

fields
    "return a collection of the inputFields contained in the group."

     ^ fields
!

leaveAction:aBlock
    "set the action to perform when the last field is left.
     Usually, this is to accept the values of all fields and perform
     some additional processing (such as closing a dialog)."

    leaveAction := aBlock
!

leaveOnTabLast:aBoolean
    "specifies if leaving the last field via Tab
     should leave the group or stay in the group.
     (if staying, either wrap or not, depending on the setting of wrap)
     The default is to stay in the group"

    leaveOnTabLast := aBoolean

    "Created: 27.4.1996 / 17:22:30 / cg"
    "Modified: 27.4.1996 / 17:22:44 / cg"
!

makeAllTabable
    "make all fields tabable"

    fields do:[:field |
        field makeTabable
    ]

    "Created: 27.4.1996 / 17:11:41 / cg"
!

wrap:aBoolean
    "specifies if leaving the last field via non-Return
     (i.e. Tab or Cursor-Down) should wrap back to the first, 
     or leave the group.
     The default is to not leave the group and wrap back to the first field."

    wrap := aBoolean

    "Modified: 27.4.1996 / 17:19:50 / cg"
! !

!EnterFieldGroup methodsFor:'adding & removing'!

add:aField
    "add another field to the group.
     Cursor motion out of the previous field will lead to the next
     one and vice versa."

    self add:aField before:nil

    "Modified: 18.10.1997 / 03:19:51 / cg"
!

add:aField before:anotherField
    "add another field to the group into a particular position
     within the tabbing order.
     Cursor motion out of the previous field will lead to the next
     one and vice versa."

    fields isNil ifTrue:[
        fields := OrderedCollection new
    ].

    anotherField isNil ifTrue:[
        fields add:aField.
    ] ifFalse:[
        fields add:aField before:anotherField
    ].

    aField delegate:self.
    aField hideCursor.
"/    aField disable.

    "set the fields enableAction to disable active field"

    aField clickAction:[:field |
        self makeActive:field
    ].

    "set the fields leaveAction to enable next field"

    aField leaveAction:[:field :key |
        self fieldLeft:field withKey:key
    ].

    fields size == 1 ifTrue:[
        "the first one"
        self makeActive:aField
    ]

    "Created: 18.10.1997 / 03:06:00 / cg"
    "Modified: 18.10.1997 / 03:20:36 / cg"
!

remove:aField
    "remove a field from the group."

    fields isNil ifTrue:[^ self].
    (fields includesIdentical:aField) ifFalse:[^ self].

    fields removeIdentical:aField.

    "Created: 18.10.1997 / 02:53:29 / cg"
    "Modified: 18.10.1997 / 03:21:09 / cg"
! !

!EnterFieldGroup methodsFor:'event forwarding'!

buttonPress:button x:x y:y view:aView
    "clicking on a field activates it and forwards the click to it"

    self makeActive:aView.
    aView buttonPress:button x:x y:y
!

handlesButtonPress:button inView:aView
    "query from event processor: am I interested in button-events ?
     yes I am (to activate the clicked-on field)."

   ^ true
!

handlesKeyPress:key inView:aView
    "query from event processor: am I interested in key-events ?
     yes I am (to forward it to the active field)."

    ^ true
!

handlesKeyRelease:key inView:aView
    "query from event processor: am I interested in key-events ?
     yes I am (to forward it to the active field)."

    ^ true
!

keyPress:key x:x y:y view:aView
    "key-press in any field - forward the key to the active field
     (with nil coordinates to indicate that the key was pressed
      outside. However, this info is not used by any view currently)"

    currentField notNil ifTrue:[
        "/ in case the currentFIeld was destroyed without telling me... (hack fix).
        currentField device notNil ifTrue:[
            currentField keyPress:key x:nil y:nil
        ]
    ]

    "Modified: / 18.9.1998 / 20:00:36 / cg"
!

keyRelease:key x:x y:y view:aView
    "key-release in any field - forward the key to the active field.
     (with -1/-1 as coordinate to indicate that the key was pressed
      outside. However, this info is not used by any view currently)"

    currentField notNil ifTrue:[
	currentField keyRelease:key x:-1 y:-1
    ]
!

showFocus:onOrOff
    "forward focus display to the active field "

    currentField notNil ifTrue:[
        currentField showFocus:onOrOff
    ]

    "Modified: 4.3.1996 / 22:18:22 / cg"
    "Created: 27.4.1996 / 16:41:38 / cg"
!

showNoFocus:onOrOff
    "forward nofocus display to the active field "

    currentField notNil ifTrue:[
        currentField showNoFocus:onOrOff
    ]

    "Modified: 4.3.1996 / 22:18:22 / cg"
    "Created: 27.4.1996 / 16:42:07 / cg"
! !

!EnterFieldGroup methodsFor:'group control'!

fieldLeft:aField withKey:key
    "some of my fields was left using key.
     Figure out, which one to give the focus:
     If there are more fields, go to that one;
     otherwise, handle this like tabbing to the next component"

    |thisIndex action next wg explicit nFields nextField delta|

    action := key.
    nFields := fields size.
    thisIndex := fields indexOf:aField.

    ((key == #CursorUp) or:[key == #PreviousField]) ifTrue:[
        delta := -1.
        (thisIndex == 1) ifTrue:[
            next := nFields
        ] ifFalse:[
            next := thisIndex - 1
        ]
    ].

    ((key == #CursorDown) 
    or:[key == #NextField
    or:[key == #Tab]]) ifTrue:[
        delta := 1.
        (thisIndex == nFields) ifTrue:[
            next := 1.
            wrap == false ifTrue:[
                action := #Return.
            ].
        ] ifFalse:[
            next := thisIndex + 1
        ]
    ].
    ((action == #Return)
    or:[key == #Tab and:[leaveOnTabLast == true]]) ifTrue:[
        delta := 1.
        (thisIndex == nFields) ifTrue:[
            leaveAction notNil ifTrue:[
                self makeInactive:aField.
                currentField := nil.
                leaveAction value.
                next := nil
            ] ifFalse:[
                next := 1
            ]
        ] ifFalse:[
            next := thisIndex + 1
        ]
    ].

    next notNil ifTrue:[
        "/ search for the next enabled field

        nextField := fields at:next.
        [nextField notNil 
         and:[nextField enabled not
               or:[nextField reallyRealized not]]] whileTrue:[
            next := next + delta.
            next < 1 ifTrue:[
                next := fields size.
            ] ifFalse:[
                next > fields size ifTrue:[
                    next := 1
                ]
            ].
            next == thisIndex ifTrue:[
                nextField := next := nil
            ] ifFalse:[
                nextField := fields at:next.
            ]
        ].

        next isNil ifTrue:[
            (wg := currentField windowGroup) notNil ifTrue:[
                delta < 0 ifTrue:[
                    wg focusPreviousFrom:aField
                ] ifFalse:[
                    wg focusNextFrom:aField.
                ].
            ].
            ^ self.
        ].

        nextField := fields at:next.
        explicit := false.
        wg notNil ifTrue:[
            wg focusView == currentField ifTrue:[
                explicit := true.
            ]
        ].
        explicit ifTrue:[
            wg focusView:nextField byTab:(wg focusCameByTab).
        ] ifFalse:[
            self makeActive:nextField 
        ]
    ]

    "Created: / 18-10-1997 / 03:03:34 / cg"
    "Modified: / 18-09-1998 / 20:16:48 / cg"
    "Modified: / 24-08-2010 / 16:14:17 / az"
! !

!EnterFieldGroup methodsFor:'misc'!

activateFirst
    "pass control to my first field"

    fields notNil ifTrue:[
        self makeActive:fields first
    ]

    "Modified: 7.2.1996 / 15:23:09 / cg"
!

activateFirstIfNoCurrent
    "pass control to my first field, if there is no current field"

    currentField isNil ifTrue:[
        self activateFirst
    ] ifFalse:[
        currentField requestFocus
    ]

    "Created: / 13.8.1998 / 21:22:35 / cg"
    "Modified: / 15.3.1999 / 08:22:18 / cg"
!

activateLast
    "pass control to my last field"

    fields notNil ifTrue:[
        self makeActive:fields last
    ]

    "Modified: 7.2.1996 / 15:23:09 / cg"
    "Created: 22.5.1996 / 19:04:05 / cg"
!

delegatesTo:aView
    ^ aView == currentField

    "Created: / 18.9.1998 / 19:57:49 / cg"
    "Modified: / 18.9.1998 / 19:58:23 / cg"
!

makeActive:aField
    "make a specific field the active one"

    currentField == aField ifTrue:[^ self].

    currentField notNil ifTrue:[
        currentField hideCursor.
        currentField hasKeyboardFocus:false.
    ].
    currentField := aField.
    currentField showCursor.
    currentField hasKeyboardFocus:true.

    "Modified: 21.5.1996 / 21:21:07 / cg"
!

makeInactive
    "make the current field inActive (take its focus)"

    self makeInactive:currentField

    "Created: 22.5.1996 / 18:58:56 / cg"
    "Modified: 22.5.1996 / 19:03:44 / cg"
!

makeInactive:aField
    "make a specific field inActive"

    currentField == aField ifTrue:[currentField := nil].

    aField notNil ifTrue:[
        aField hideCursor.
        aField hasKeyboardFocus:false.
    ].

    "Created: 21.5.1996 / 21:20:57 / cg"
! !

!EnterFieldGroup class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

