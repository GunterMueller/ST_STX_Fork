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
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#KeyboardForwarder
	instanceVariableNames:'sourceView destinationView destination condition filter'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!KeyboardForwarder class methodsFor:'documentation'!

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
    Instances of this class can be used to forward keyboard
    events to some object or other view (install them via aView delegate:).
    Event delegation allows to add additional keyboard functions to views
    WITHOUT modifying their code or changing controllers.
    Also, it allows to catch certain individual keys to ignore them or
    perform different functions.

    Notice, that delegates don't have to be instances of
    myself; any object with a protocol similar to mine can be used as
    a delegate. 
    (i.e. any object that responds to 
     handlesKeyPress:view: / keyPress:x:y:view: / delegatesTo: etc.)

    However, I provide the most common functions required for conditional
    event delegation and instances of myself are for example used to forward 
    events from elements of some dialogBoxes to the enterfield/fieldGroup - 
    (which allows keyboard input to be forwarded to the active text-field even 
     while the mouse pointer is somewhere else)

    Another application of delegation is to catch keyboard input to some standard
    widget, optionally processing and resending the key-event.

    I can either forward the key event to another view, or to some general
    object - the difference is that views are sent a #keyXXX:x:y: message,
    while general destinations get a #keyXXX:x:y:view: message, with the original
    view (the one in which the event occurred) as additional argument.

    [Instance Variables:]

        destinationView         <View>          the view which shall receive
                                                the forwarded keyboard events.

        destination             <Object>        the object which shall receive
                                                the forwarded keyboard events.

        sourceView              <ViewOrNil>     if non-nil, only events from this
                                                view are forwarded.
                                                (currently nowhere used)

        condition               <Symbol>        an additional condition for forwarding
                                                currently only #noFocus is implemented.
                                                The #noFocus condition will only forward
                                                events if no explicit focus has been
                                                set in the windowGroup.

                                <Block>         condition block - event is forwarded,
                                                if it evaluates to true.
                                                The block gets 3 arguments:
                                                    eventType   #keyPress or #keyRelease
                                                    key         the key
                                                    view        the originating view

    For more info on event handling/forwarding, see the documentation in
    WindowSensor, WindowGroup and especially in WindowEvent.

    [see also:]
        WindowEvent WindowSensor WindowGroup

    [author:]
        Claus Gittinger
"
!

examples
"
    catch an enterfields input:
                                                                        [exBegin]
        |top field forwarder catcher|

        catcher := Plug new.
        catcher respondTo:#keyPress:x:y:view:
                    with:[:key :x :y :view | Transcript showCR:'caught keyPress: ' , key printString.].
        catcher respondTo:#keyRelease:x:y:view:
                    with:[:key :x :y :view | Transcript showCR:'caught keyRelease: ' , key printString.].

        top := StandardSystemView new.
        top extent:200@200.

        field := EditField in:top.
        field origin:0.0@0.0; width:1.0.

        forwarder := KeyboardForwarder to:catcher. 
        field delegate:forwarder.

        top open
                                                                        [exEnd]


    catch an enterfields return-key only:
                                                                        [exBegin]
        |top field forwarder catcher|

        catcher := Plug new.
        catcher respondTo:#keyPress:x:y:view:
                    with:[:key :x :y :view | Transcript showCR:'caught return'].

        top := StandardSystemView new.
        top extent:200@200.

        field := EditField in:top.
        field origin:0.0@0.0; width:1.0.

        forwarder := KeyboardForwarder 
                        to:catcher 
                        condition:[:type :key :view | (type == #keyPress) & (key == #Return)].
        field delegate:forwarder.

        top open
                                                                        [exEnd]


    catch all of an enterfields input and ignore it:
                                                                        [exBegin]
        |top field forwarder|

        top := StandardSystemView new.
        top extent:200@200.

        field := EditField in:top.
        field origin:0.0@0.0; width:1.0.

        forwarder := KeyboardForwarder to:nil. 
        field delegate:forwarder.

        top open
                                                                        [exEnd]
"
! !

!KeyboardForwarder class methodsFor:'instance creation'!

from:sourceView to:destination
    "create and return a new KeyboardForwarder to redirect key events
     for sourceView to destination. Events from other than the sourceView
     will not be forwarded. The forwarded event will be reported including
     the original view as argument (i.e. as #keyPress:x:y:view:). 
     Use this, if the destination is not a view."

    ^ self new sourceView:sourceView; destination:destination
!

from:sourceView toView:destinationView
    "create and return a new KeyboardForwarder to redirect key events
     for sourceView to destinationView. Events from other than the sourceView
     will not be forwarded. The forwarded event will be reported excluding
     the original view as argument (i.e. as #keyPress:x:y:). 
     Use this, if the destination is a view."

    ^ self new sourceView:sourceView; destinationView:destinationView
!

to:destination
    "create and return a new KeyboardForwarder to redirect any key event
     to destination (Independent of the view in which the event originally
     occurred). The forwarded event will be reported including
     the original view as argument (i.e. as #keyPress:x:y:view:). 
     Use this, if the destination is not a view."

    ^ self to:destination condition:nil filter:nil 
!

to:destination condition:aCondition
    "create and return a new KeyboardForwarder to redirect any key event
     to destinationView (Independent of the view in which the event originally
     occurred) but only, if some condition as specified by aCondition
     is met. The forwarded event will be reported including
     the original view as argument (i.e. as #keyPress:x:y:view:). 
     Use this, if the destination is not a view."

    ^ self to:destination condition:aCondition filter:nil 
!

to:destination condition:aCondition filter:aFilterBlock
    "create and return a new KeyboardForwarder to redirect any key event
     to destinationView (Independent of the view in which the event originally
     occurred) but only, if some condition as specified by aCondition
     is met and aFilterBlock returns true for that key.
     The forwarded event will be reported including
     the original view as argument (i.e. as #keyPress:x:y:view:). 
     Use this, if the destination is not a view."

    ^ self new destination:destination; condition:aCondition; filter:aFilterBlock
!

toView:destinationView
    "create and return a new KeyboardForwarder to redirect any key event
     to destinationView (Independent of the view in which the event originally
     occurred). The forwarded event will be reported excluding
     the original view as argument (i.e. as #keyPress:x:y:). 
     Use this, if the destination is a view."

    ^ self toView:destinationView condition:nil filter:nil 
!

toView:destinationView condition:aCondition
    "create and return a new KeyboardForwarder to redirect any key event
     to destinationView (Independent of the view in which the event originally
     occurred) but only, if some condition as specified by aCondition
     is met. The forwarded event will be reported excluding
     the original view as argument (i.e. as #keyPress:x:y:). 
     Use this, if the destination is a view."

    ^ self toView:destinationView condition:aCondition filter:nil 
!

toView:destinationView condition:aCondition filter:aFilterBlock
    "create and return a new KeyboardForwarder to redirect any key event
     to destinationView (Independent of the view in which the event originally
     occurred) but only, if some condition as specified by aCondition
     is met and aFilterBlock returns true for that key.
     The forwarded event will be reported excluding
     the original view as argument (i.e. as #keyPress:x:y:). 
     Use this, if the destination is a view."

    ^ self new destinationView:destinationView; condition:aCondition; filter:aFilterBlock
! !

!KeyboardForwarder methodsFor:'accessing'!

condition:aCondition
    "set the condition - typically a block"

    condition := aCondition
!

destination
    "return the destination"

    ^ destination
!

destination:anObject 
    "set the destination 
     - that one will get the event with an additional view arg."

    destination := anObject
!

destinationView
    "return the destination view"

    ^ destinationView
!

destinationView:aView
    "set the destination view"

    destinationView := aView
!

filter:aOneArgBlock
    "set the filter - if non-nil, only keys for which it returns true are forwarded"

     filter := aOneArgBlock

    "Created: 4.2.1996 / 20:35:15 / cg"
!

sourceView
    "get the sourceView - if nonNil, only events from this view will be forwarded"

    ^ sourceView
!

sourceView:aView
    "set the sourceView - if nonNil, only events from this view will be forwarded"

    sourceView := aView
! !

!KeyboardForwarder methodsFor:'event forwarding'!

keyPress:key x:x y:y view:aView
    "handle a delegated event - this is sent by the sensor to actually
     forward the event (i.e. after I returned true on handlesKeyPress:.
     Take care of cyclic delegation (via a kludge-test for negative coordinate)."

    |xDel yDel forwardedEvent|

    x isNil ifTrue:[
        "
         already delegated ... ignore
        "
        ^ self
    ].

    filter notNil ifTrue:[
        (filter value:key) ifFalse:[^ self].
    ].

    xDel := x.
    yDel := y.

    x == 0 ifTrue:[
        "
         already delegated ... care to not delegate twice
        "
        xDel := nil.
        yDel := nil.
    ].

    destination notNil ifTrue:[
        destination keyPress:key x:nil y:nil view:aView.
    ] ifFalse:[
        destinationView notNil ifTrue:[
            forwardedEvent := WindowEvent keyPress:key x:xDel y:yDel view:destinationView.
            destinationView
                dispatchEvent:forwardedEvent
                withFocusOn:nil 
                delegate:false
        ]
    ]

    "Modified: / 20.5.1998 / 22:54:05 / cg"
!

keyRelease:key x:x y:y view:aView
    "handle a delegated event - this is sent by the sensor to actually
     forward the event (i.e. after I returned true on handlesKeyRelease:.
     Take care of cyclic delegation (via a kludge-test for negative coordinate)."

    |forwardedEvent|

    x < 0 ifTrue:[
        "
         already delegated ... ignore
        "
        ^ self
    ].

    filter notNil ifTrue:[
        (filter value:key) ifFalse:[^ self].
    ].

    destination notNil ifTrue:[
        destination keyRelease:key x:-1 y:-1 view:aView
    ] ifFalse:[
        destinationView notNil ifTrue:[
            forwardedEvent := WindowEvent keyRelease:key x:-1 y:-1 view:destinationView.
            destinationView dispatchEvent:forwardedEvent withFocusOn:nil delegate:false
        ]
    ]

    "Modified: / 20.5.1998 / 22:54:32 / cg"
! !

!KeyboardForwarder methodsFor:'focus forwarding'!

hasKeyboardFocus:aBoolean
    "forward focus information to my destination"

    destinationView notNil ifTrue:[
        destinationView hasKeyboardFocus:aBoolean
    ].

    "Modified: 25.2.1997 / 23:16:35 / cg"
!

showFocus:explicit
    "forward focus information to my destination"

    |d|

    destinationView notNil ifTrue:[
        d := destinationView
    ] ifFalse:[
        d := destination
    ].
    d notNil ifTrue:[
        d showFocus:explicit
    ]

    "Modified: 25.2.1997 / 23:16:35 / cg"
!

showNoFocus:explicit
    "forward focus information to my destination"

    |d|

    destinationView notNil ifTrue:[
        d := destinationView
    ] ifFalse:[
        d := destination
    ].
    d notNil ifTrue:[
        d showNoFocus:explicit
    ]

    "Modified: 25.2.1997 / 23:16:40 / cg"
! !

!KeyboardForwarder methodsFor:'queries'!

checkCondition:type key:key view:aView
    "return true, if I am interested in an event with type (#keyPress or
     #keyRelease) and key for aView."

    |wg|

    filter notNil ifTrue:[
        (filter value:key) ifFalse:[^ false].
    ].

    condition notNil ifTrue:[
        condition == #noFocus ifTrue:[
            wg := aView windowGroup.
            (wg isNil or:[wg focusView notNil]) ifTrue:[^ false]
        ].
        condition isBlock ifTrue:[
            (condition value:type value:key value:aView) ifFalse:[^ false]
        ]
    ].
    sourceView notNil ifTrue:[
        ^ aView == sourceView
    ].
    ^ true

    "Modified: / 31.10.1997 / 20:24:42 / cg"
!

delegatesTo:someone
    "return true, if I delegate events to someone"

    ^ destination == someone or:[destinationView == someone]
!

handlesButtonMotion:something inView:aView
    "I am not interested in button events"

    ^ false
!

handlesButtonPress:something inView:aView
    "I am not interested in button events"

    ^ false
!

handlesKeyPress:key inView:aView
    "this is the query from the sensor to ask me if I would like to
     get a keyPress event for key from aView. Return true, if I want so,
     false otherwise."

    ^ self checkCondition:#keyPress key:key view:aView
!

handlesKeyRelease:key inView:aView
    "this is the query from the sensor to ask me if I would like to
     get a keyRelease event for key from aView. Return true, if I want so,
     false otherwise."

    ^ self checkCondition:#keyRelease key:key view:aView
!

handlesPointerEnter:something inView:aView
    "I am not interested in pointer events"

    ^ false
!

handlesPointerLeave:something inView:aView
    "I am not interested in pointer events"

    ^ false
! !

!KeyboardForwarder class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

