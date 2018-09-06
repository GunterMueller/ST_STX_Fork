"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

Event subclass:#WindowEvent
	instanceVariableNames:'delegatedFrom consumed'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

WindowEvent subclass:#ApplicationEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#InputEvent
	instanceVariableNames:'modifierFlags'
	classVariableNames:'F_CTRL F_ALT F_META F_SHIFT F_BUTTON1 F_BUTTON2 F_BUTTON3'
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#ButtonEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::ButtonEvent subclass:#ButtonPressEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::ButtonPressEvent subclass:#ButtonMultiPressEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::ButtonEvent subclass:#ButtonReleaseEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#ClientEvent
	instanceVariableNames:'eventData'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#ConfigureEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#DamageEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#DropEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#EnterLeaveEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#FocusEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#KeyboardEvent
	instanceVariableNames:'rawKey'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::ButtonEvent subclass:#ButtonMotionEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::KeyboardEvent subclass:#KeyPressEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::KeyboardEvent subclass:#KeyReleaseEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::KeyboardEvent subclass:#HotKeyEvent
	instanceVariableNames:'hotkeyIdentifier'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#KeyboardFocusEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#MessageSendEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::ButtonEvent subclass:#MouseWheelMotionEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#NativeWidgetCommandEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#NewDamageEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#SelectionEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::SelectionEvent subclass:#SelectionClearEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#TerminateEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent::InputEvent subclass:#TrayActionEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#VisibilityChangeEvent
	instanceVariableNames:'visibility'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

WindowEvent subclass:#WindowMapUnmapEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowEvent
!

!WindowEvent class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    Instances of WindowEvent are created for every event coming from the graphics device. 
    Usually, they are enqueued by the event dispatcher process into
    a sensors input queue, and dequeued & processed by a windowGroup process
    in its event loop.

    WindowEvents hold the event type and additional information (such as key,
    x/y coordinates etc). Also, windowEvents know how to send themself to some
    destination. To provide a common (single) place where event dispatching is
    implemented, this forwarding is done by a class method here (i.e. not by the
    window group itself).

    The algorithm for event dispatching is:

        - if the destination view has a keyboard focus set,
          AND the event is a keyboard event,
          THEN recursively invoke the event dispatching method,
               sending the event to the focus view (or its delegate, as below)

        - if the destination view has a delegate,
          AND its a keyboard, button or pointer event,
          AND the delegate is interested in that event 
              (i.e. implements & responds to #handlesXXX with true)
          THEN send the event to the delegate, passing the original view
               as additional argument

        - if the view has a nonNil controller,
          AND its a key, button or pointer event,
          THEN send the event to the controller

        - otherwise send the event to the view


    If the view has a non-nil transformation, the event is sent as a
    #deviceXXX message, passing device coordinates. Typically, subclasses
    of view do not redefine this method and the inherited default method
    translates these device coordinates into logical coordinates and resends
    an XXX message.
    If the view has no transformation, the XXX message is directly sent here.

    For example, a 'buttonPress:button x:x y:y' event leads to sending of
    'aView deviceButtonPress:button x:x y:y' which resends
    'aView buttonPress:button x:(x-logical) y:(y-logical)'

    This allows views which are interested in deviceCoordinates to get them
    (by redefining #deviceXXX) and other views to transparently get & use
    logical coordinates.

    Therefore, for a delegated keyPress messages, the flow is:

        sendEvent
            view has delegate
                ------> ask delegate via 'handlesKeyPress:key inView:view'
                <------ returns true
                ------> 'delegate keyPress:key x:x y:y view:view'
                        -----> delegate does whatever it wants to do
                               (typically sends the event to some other view)

    for an undelegated message:

        sendEvent
            view has delegate
                ------> ask delegate via 'handlesKeyPress:key inView:view'
                <------ returns false
            view has controller
                ------> 'controller keyPress:key x:x y:y'
            view has no controller
                view has transformation
                    ----> 'view deviceKeyPress:key x:x y:y'
                          inverse transform x/y
                          ----> 'self keyPress:key x:xLogical y:yLogical'
                view has no transformation
                    ----> 'view keyPress:key x:x y:y'

    [author:]
        Claus Gittinger

    [see also:]
        WindowGroup WindowSensor
        DeviceWorkstation View
        KeyboardMap KeyboardForwarder EventListener

"
! !

!WindowEvent class methodsFor:'instance creation'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    ^ (ButtonMotionEvent new)
          for:aView
          type:#buttonMotion:x:y:
          arguments:(Array with:buttonAndModifierState with:x with:y)
!

buttonMultiPress:button x:x y:y view:aView
    ^ (ButtonMultiPressEvent new)
          for:aView
          type:#buttonMultiPress:x:y:
          arguments:(Array with:button with:x with:y)
!

buttonPress:button x:x y:y view:aView
    ^ (ButtonPressEvent new)
          for:aView
          type:#buttonPress:x:y:
          arguments:(Array with:button with:x with:y)
!

buttonRelease:button x:x y:y view:aView
    ^ (ButtonReleaseEvent new)
          for:aView
          type:#buttonRelease:x:y:
          arguments:(Array with:button with:x with:y)
!

clientMessageEvent:type format:format eventData:data view:aView
    "this one is only used with X-Windows"

    ^ ClientEvent
         for:aView
         type:#clientMessage:format:eventData:
         arguments:(Array with:type with:format with:data)
!

configureX:x y:y width:w height:h view:aView
    ^ ConfigureEvent
         for:aView
         type:#configureX:y:width:height:
         arguments:(Array with:x with:y with:w with:h)
!

copyDataEvent:parameter eventData:data view:aView
    "this one is only used with Win32"

    ^ ClientEvent
         for:aView
         type:#copyDataEvent:eventData:
         arguments:(Array with:parameter with:data)
!

coveredBy:coveringSiblingView view:coveredView
    ^ (WindowEvent basicNew)
        for:coveredView 
        type:#coveredBy:
        arguments:(Array with:coveringSiblingView)
!

createWindow:view x:x y:y width:w height:h

    ^ (self basicNew)
        for: view 
        type:#createWindowX:y:width:height:
        arguments: (Array with: x with: y with: w with: h)

    "Created: / 30-05-2011 / 19:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2011 / 13:05:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

damageFor:aView rectangle:aRectangle
    "create and return a new damage Event for aRectangle
     in aView"

    ^ DamageEvent for:aView type:#damage arguments:aRectangle
!

destroyedView:aView
    ^ (self basicNew)
        for:aView 
        type:#destroyed
!

dropFiles:files view:view position:dropPositionOrNil handle:dropHandleOrNil
    ^ self 
        dropMessage:(self dropType_files) 
        data:files 
        view:view 
        position:dropPositionOrNil 
        handle:dropHandleOrNil

    "Modified: / 13-10-2006 / 10:11:47 / cg"
!

dropMessage:dropTypeSymbol data:dropValue view:aView position:positionOrNil handle:dropHandleOrNil
    ^ DropEvent 
          for:aView
          type:#dropMessage:data:position:handle:
          arguments:(Array with:dropTypeSymbol with:dropValue with:positionOrNil with:dropHandleOrNil)
!

focusInView:aView
    ^ FocusEvent 
        for:aView 
        type:#focusIn
!

focusOutView:aView
    ^ FocusEvent 
        for:aView 
        type:#focusOut
!

hotkeyWithId:aHotkeyId rawKey:keyWithModifier view:aView

    |ev|

     ev := (HotKeyEvent new)
          for:aView
          type:#hotkeyWithId:rawKey:
          arguments:(Array with:keyWithModifier with:0 with:0).
     ev rawKey:keyWithModifier.
     ev hotkeyIdentifier:aHotkeyId.
    ^ ev
!

keyPress:key rawKey:untranslatedKey 
    hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
    button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown
    x:x y:y view:aView

    |ev|

    ev := self keyPress:key x:x y:y view:aView.
    ev rawKey:untranslatedKey.
    ev  hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
        button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.
    ^ ev
!

keyPress:key x:x y:y view:aView
    ^ (KeyPressEvent new)
          for:aView
          type:#keyPress:x:y:
          arguments:(Array with:key with:x with:y)
!

keyRelease:key rawKey:untranslatedKey 
    hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
    button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown
    x:x y:y view:aView

    |ev|

    ev := self keyRelease:key x:x y:y view:aView.
    ev rawKey:untranslatedKey.
    ev  hasShift:shiftDown ctrl:ctrlDown alt:altDown meta:metaDown
        button1:leftButtonDown button2:middleButtonDown button3:rightButtonDown.
    ^ ev
!

keyRelease:key x:x y:y view:aView
    ^ (KeyReleaseEvent new)
          for:aView
          type:#keyRelease:x:y:
          arguments:(Array with:key with:x with:y)
!

keyboardFocus:arg view:aView

    ^ KeyboardFocusEvent    
            for:aView type:#hasKeyboardFocus: arguments:(Array with:arg).
!

mappedView:aView
    ^ WindowMapUnmapEvent 
        for:aView 
        type:#mapped
!

messageSend:receiver selector:aSelector arguments:arguments
    ^ MessageSendEvent
         for:receiver
         type:aSelector
         arguments:arguments
!

mouseWheelMotion:state x:x y:y amount:amount deltaTime:deltaTime view:aView
    ^ MouseWheelMotionEvent
             for:aView
             type:#mouseWheelMotion:x:y:amount:deltaTime:
             arguments:(Array with:state with:x with:y with:amount with:deltaTime).
!

nativeWidgetCommand:command arguments:argVector view:aView
    ^ (NativeWidgetCommandEvent new)
        for:aView 
        type:command
        arguments:argVector
!

newDamageFor:aView
    "create and return a new damage Event for aView"

    ^ NewDamageEvent for:aView type:#newDamage
!

pasteFromClipBoard:something view:aView
    ^ (self basicNew)
        for:aView
        type:#pasteFromClipBoard:
        arguments:(Array with:something).
!

pointerEnter:state x:x y:y view:aView
    ^ EnterLeaveEvent
             for:aView
             type:#pointerEnter:x:y:
             arguments:(Array with:state with:x with:y).
!

pointerLeave:state view:aView
    ^ EnterLeaveEvent
             for:aView
             type:#pointerLeave:
             arguments:(Array with:state).
!

postViewCreateNotification:aView
    ^ (self basicNew) 
        for:aView 
        type:#postCreateView
!

preViewCreateNotification:aView
    ^ (self basicNew) 
        for:aView 
        type:#preCreateView
!

propertyChange:view property:propertyId state:aSymbol time:time
    ^ (self basicNew)
        for: view 
        type:#propertyChange:state:
        arguments: (Array with: propertyId with: aSymbol)

    "Created: / 01-06-2011 / 13:36:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveAndTerminateView:aView
    ^ (TerminateEvent basicNew)
        for:aView 
        type:#saveAndTerminate
!

terminateView:aView
    ^ (TerminateEvent basicNew)
        for:aView 
        type:#terminate
!

trayAction:event arguments:argVector view:aView
    ^ (TrayActionEvent new)
        for:aView 
        type:event
        arguments:argVector

    "Created: / 31-10-2007 / 01:23:53 / cg"
!

unmappedView:aView
    ^ WindowMapUnmapEvent 
        for:aView 
        type:#unmapped
!

visibilityOf:aView changedTo:how
    ^ EnterLeaveEvent
             for:aView
             type:#visibilityChange:
             arguments:(Array with:how).

    "Created: / 23-01-2012 / 09:51:03 / cg"
! !

!WindowEvent class methodsFor:'constants'!

dropType_directory
    ^ #directory

    "Created: / 13-10-2006 / 10:08:59 / cg"
!

dropType_file
    ^ #file

    "Created: / 13-10-2006 / 10:08:52 / cg"
!

dropType_files
    ^ #files

    "Created: / 13-10-2006 / 10:09:04 / cg"
!

dropType_text
    ^ #text

    "Created: / 13-10-2006 / 10:09:36 / cg"
! !

!WindowEvent class methodsFor:'instance creation-basic'!

for:aView type:aSymbol
    "create and return a new windowEvent for sending
     aSymbol-message with no arguments to aView"

    ^ self new for:aView type:aSymbol
!

for:aView type:aSymbol arguments:argArray
    "create and return a new windowEvent for sending
     aSymbol-message with arguments to aView"

    ^ self new for:aView type:aSymbol arguments:argArray
!

new
    self == WindowEvent ifTrue:[
        '----------------' errorPrint.
        'WindowEvent is abstract - use/add explicit creation message' errorPrintCR.
        thisContext fullPrintAll.
        self abstractClassInstantiationError.
    ].
    ^ super new

    "Modified (format): / 31-08-2012 / 19:44:41 / cg"
! !

!WindowEvent methodsFor:'accessing'!

consumed
    "return the value of the instance variable 'consumed' (automatically generated)"

    ^ consumed
!

consumed:aBoolean
    "set the value of the instance variable 'consumed' (automatically generated)"

    consumed := aBoolean.
!

delegatedFrom
    "return the value of the instance variable 'delegatedFrom' (automatically generated)"

    ^ delegatedFrom
!

delegatedFrom:something
    "set the value of the instance variable 'delegatedFrom' (automatically generated)"

    delegatedFrom := something.
!

key
    "return the key - nil is returned here.
     This is redefined in KeyboardEvent."

    ^ nil

    "Created: 1.8.1997 / 13:56:21 / cg"
!

rectangle
    "return the damage rectangle"

    ^ args "consider this a kludge"
!

type
    "return the type of the event"

    ^ selector
!

view
    "return the view, for which the event is for"

    ^ receiver
!

view:aView
    "set the view, for which the event is for"

    receiver := aView
!

x
    "the x coordinate - if any.
     nil returned for all but button- and keyEvents"

    ^ nil
!

x:ignoredInteger
    "set the x coordinate - ignored here.
     only for button- and keyEvents"
!

y
    "the y coordinate - if any.
     nil returned for all but button- and keyEvents"

    ^ nil
!

y:ignoredInteger
    "set the y coordinate - ignored here.
     only for button- and keyEvents"
! !

!WindowEvent methodsFor:'dispatching'!

dispatchTo:anObject
    "send this event to anObject"

    ^ anObject perform:selector withArguments:args
!

dispatchWithViewArgumentTo:anObject
    "send this event to anObject, and pass an additional view argument"

    args size = 0 ifTrue:[
        ^ anObject 
            perform:selector asMutator
            with:receiver
    ].

    ^ anObject 
        perform:(selector , 'view:') asSymbol
        withArguments:(args copyWith:receiver)
! !

!WindowEvent methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPut:$(.

    selector storeOn:aGCOrStream. 
    aGCOrStream
        nextPutAll:' view: '; 
        nextPutAll:receiver class name; 
        nextPutAll:' args: '.

    args displayOn:aGCOrStream.
    aGCOrStream nextPut:$)

    "Created: 7.3.1996 / 14:55:50 / cg"
    "Modified: 20.9.1997 / 11:42:11 / cg"
! !

!WindowEvent methodsFor:'private-accessing'!

for:aView type:aSymbol
    "set the instance variables of the event"

    receiver :=  aView.
    selector := aSymbol.
    args := #().
    timeStamp := Timestamp now.
!

for:aView type:aSymbol arguments:argArray
    "set the instance variables of the event"

    receiver :=  aView.
    selector := aSymbol.
    args := argArray.
    timeStamp := Timestamp now.
! !

!WindowEvent methodsFor:'queries'!

hasAlt
    "return true, if this is a keyboard event, with ALT pressed"

    ^ false

    "Created: 12.4.1997 / 11:04:10 / cg"
!

hasCtrl
    "return true, if this is a keyboard event, with CTRL pressed"

    ^ false

    "Created: 12.4.1997 / 11:04:03 / cg"
!

hasMeta
    "return true, if this is a keyboard event, with META pressed"

    ^ false

    "Created: 12.4.1997 / 11:04:16 / cg"
!

hasShift
    "return true, if this is a keyboard event, with SHIFT pressed"

    ^ false

    "Created: 12.4.1997 / 11:30:59 / cg"
!

targetView
    "return the view which will eventually handle the event;
     for most events, this is the same as the view, for which the event was
     originally generated.
     Except, if an explicit focus has been assigned (i.e. tabbed into a component),
     AND the event is a keyboard event. In this case, the targetView might be different.
     Notice: this method might return nil, for synthetic (app-related) or display screen related
     events"

    ^ self view.
! !

!WindowEvent methodsFor:'testing'!

isApplicationEvent
    "return true, if this event is application related (i.e. not for a particular view)"

    ^ false
!

isButtonEvent
    "return true, if this event is a button event"

    ^ false
!

isButtonMotionEvent
    "return true, if this event is a buttonMotion event"

    ^ false

    "Created: 5.3.1997 / 12:25:43 / cg"
!

isButtonMultiPressEvent
    "return true, if this event is a buttonMulti-Press event"

    ^ false

    "Created: 5.3.1997 / 12:25:43 / cg"
!

isButtonPressEvent
    "return true, if this event is a buttonPress event"

    ^ false

    "Created: 5.3.1997 / 12:25:43 / cg"
!

isButtonReleaseEvent
    "return true, if this event is a buttonPress event"

    ^ false

    "Created: 5.3.1997 / 12:25:43 / cg"
!

isConfigureEvent
    "return true, if this is a window geometry change event"

    ^ false.
!

isCreateWindowEvent
    "return true, if this event is a CreateWindow event"

    ^selector == #createWindowX:y:width:height:

    "Created: / 01-06-2011 / 13:01:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDamage
    "return true, if this is a damage event"

    ^ false.
!

isDamageForView:aView
    "return true, if this is a damage event for a View"

    ^ false.
!

isDelegatedToFocusView
    "return true, if this event will be forwarded to a focusView."

    ^ false.
!

isFocusEvent
    "return true, if this event is a focusIn/focusOut event"

    ^ false

    "Created: 5.3.1997 / 12:12:37 / cg"
!

isFocusInEvent
    "return true, if this event is a focusIn event"

    ^ false

    "Created: 5.3.1997 / 12:18:10 / cg"
!

isFocusOutEvent
    "return true, if this event is a focusOut event"

    ^ false

    "Created: 5.3.1997 / 12:18:10 / cg"
!

isHotKeyEvent
    "return true, if this event is a hotkey event"

    ^ false
!

isInputEvent
    "return true, if this event is an input (pointer, key or button) event"

    ^ false

    "Created: / 21.5.1999 / 19:49:42 / cg"
    "Modified: / 21.5.1999 / 19:50:11 / cg"
!

isKeyEvent
    "return true, if this event is a keyboard event"

    ^ false

    "Modified: / 28.1.1998 / 00:03:17 / cg"
!

isKeyPressEvent
    "return true, if this event is a keyboard press event"

    ^ false

    "Modified: / 28.1.1998 / 00:03:24 / cg"
!

isKeyReleaseEvent
    "return true, if this event is a keyboard release event"

    ^ false

    "Modified: / 28.1.1998 / 00:03:31 / cg"
!

isKeyboardFocusEvent
    "return true, if this event is a keyboard focus event"

    ^ false
!

isMapEvent
    "return true, if this is a map event"

    ^ false

    "Created: / 29-01-1998 / 21:52:54 / cg"
    "Modified: / 09-11-2007 / 13:10:25 / cg"
!

isMessageSendEvent
    "return true, if this event is a general messageSend event"

    ^ false
!

isMouseWheelEvent
    ^ false
!

isPointerEnterEvent
    "return true, if this event is a pointer-enter event"

    ^ false

    "Created: 9.1.1996 / 15:51:24 / cg"
    "Modified: 9.1.1996 / 15:51:40 / cg"
!

isPointerEnterLeaveEvent
    "return true, if this event is a pointer-enter/leave event"

    ^ false

    "Created: 9.1.1996 / 15:51:18 / cg"
!

isPointerLeaveEvent
    "return true, if this event is a pointer-leave event"

    ^ false

    "Created: 9.1.1996 / 15:51:36 / cg"
!

isPropertyChangeEvent
    "return true, if this event is a CreateWindow event"

    ^selector == #propertyChange:state:

    "Created: / 01-06-2011 / 13:36:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTerminateEvent
    ^ false
!

isTrayEvent
    "return true, if this is an event from the tray (WIN32 only, for now)"

    ^ false

    "Created: / 09-11-2007 / 13:09:29 / cg"
!

isUnmapEvent
    "return true, if this is an unmap event"

    ^ false

    "Modified: / 09-11-2007 / 13:10:07 / cg"
!

isUserEvent
    "return true, if this event is a user event (i.e. mouse, keyboard or button)"

    self isButtonEvent       ifTrue:[^ true].
    self isKeyEvent          ifTrue:[^ true].
    self isTerminateEvent    ifTrue:[^ true].

    self isPointerEnterEvent ifTrue:[^ true].
    "/ self isPointerLeaveEvent ifTrue:[^ true].     -- why disabled ?

    ^ false

    "Modified: 5.3.1997 / 11:27:40 / cg"
! !

!WindowEvent::ApplicationEvent methodsFor:'blocked'!

view
    ^ nil
! !

!WindowEvent::ApplicationEvent methodsFor:'testing'!

isApplicationEvent
    ^ true
! !

!WindowEvent::InputEvent class methodsFor:'class initialization'!

initialize
    F_SHIFT := 16r001.
    F_CTRL  := 16r002.
    F_ALT   := 16r004.
    F_META  := 16r008.

    F_BUTTON1 := 16r100.
    F_BUTTON2 := 16r200.
    F_BUTTON3 := 16r400.

    "
     self initialize
    "

    "Modified: 13.8.1997 / 22:16:17 / cg"
! !

!WindowEvent::InputEvent methodsFor:'accessing'!

hasShift:shift ctrl:ctrl alt:alt meta:meta button1:b1 button2:b2 button3:b3
    |f "{ Class: SmallInteger }"|

    f := 0.
    shift ifTrue:[f := f bitOr:F_SHIFT].
    ctrl ifTrue:[f := f bitOr:F_CTRL].
    alt ifTrue:[f := f bitOr:F_ALT].
    meta ifTrue:[f := f bitOr:F_META].
    b1 ifTrue:[f := f bitOr:F_BUTTON1].
    b2 ifTrue:[f := f bitOr:F_BUTTON2].
    b3 ifTrue:[f := f bitOr:F_BUTTON3].
    modifierFlags := f.

    "Created: 13.8.1997 / 22:17:56 / cg"
!

hasShift:shift hasCtrl:ctrl hasAlt:alt hasMeta:meta
    |f "{ Class: SmallInteger }"|

    f := 0.
    shift ifTrue:[f := f bitOr:F_SHIFT].
    ctrl ifTrue:[f := f bitOr:F_CTRL].
    alt ifTrue:[f := f bitOr:F_ALT].
    meta ifTrue:[f := f bitOr:F_META].
    modifierFlags := f.

    "Created: 13.8.1997 / 22:02:09 / cg"
!

hasShift:shift hasCtrl:ctrl hasAlt:alt hasMeta:meta hasButton1:b1 hasButton2:b2 hasButton3:b3
    |f "{ Class: SmallInteger }"|

    f := 0.
    shift ifTrue:[f := f bitOr:F_SHIFT].
    ctrl ifTrue:[f := f bitOr:F_CTRL].
    alt ifTrue:[f := f bitOr:F_ALT].
    meta ifTrue:[f := f bitOr:F_META].
    b1 ifTrue:[f := f bitOr:F_BUTTON1].
    b2 ifTrue:[f := f bitOr:F_BUTTON2].
    b3 ifTrue:[f := f bitOr:F_BUTTON3].
    modifierFlags := f.

    "Created: 13.8.1997 / 22:17:25 / cg"
!

modifierFlags
    ^ modifierFlags
!

modifierFlags:flagBits
    modifierFlags := flagBits
! !

!WindowEvent::InputEvent methodsFor:'queries'!

hasAlt
    "return true, if this is an event, with ALT pressed"

    modifierFlags isNil ifTrue:[^ false].
    ^ (modifierFlags bitAnd:F_ALT) ~~ 0

    "Created: 13.8.1997 / 22:02:23 / cg"
    "Modified: 21.8.1997 / 19:41:11 / cg"
!

hasButton1
    "return true, if this is an event, with the left mouse button pressed"

    modifierFlags isNil ifTrue:[^ false].
    ^ (modifierFlags bitAnd:F_BUTTON1) ~~ 0

    "Created: 13.8.1997 / 22:16:35 / cg"
    "Modified: 21.8.1997 / 19:41:40 / cg"
!

hasButton2
    "return true, if this is an event, with the middle mouse button pressed"

    modifierFlags isNil ifTrue:[^ false].
    ^ (modifierFlags bitAnd:F_BUTTON2) ~~ 0

    "Created: 13.8.1997 / 22:16:43 / cg"
    "Modified: 21.8.1997 / 19:41:47 / cg"
!

hasButton3
    "return true, if this is an event, with the right mouse button pressed"

    modifierFlags isNil ifTrue:[^ false].
    ^ (modifierFlags bitAnd:F_BUTTON3) ~~ 0

    "Created: 13.8.1997 / 22:16:49 / cg"
    "Modified: 21.8.1997 / 19:41:52 / cg"
!

hasCtrl
    "return true, if this is an event, with CTRL pressed"

    modifierFlags isNil ifTrue:[^ false].
    ^ (modifierFlags bitAnd:F_CTRL) ~~ 0

    "Created: 13.8.1997 / 22:02:29 / cg"
    "Modified: 21.8.1997 / 19:41:21 / cg"
!

hasMeta
    "return true, if this is an event, with META pressed"

    modifierFlags isNil ifTrue:[^ false].
    ^ (modifierFlags bitAnd:F_META) ~~ 0

    "Created: 13.8.1997 / 22:02:59 / cg"
    "Modified: 21.8.1997 / 19:41:27 / cg"
!

hasShift
    "return true, if this is an event, with SHIFT pressed"

    modifierFlags isNil ifTrue:[^ false].
    ^ (modifierFlags bitAnd:F_SHIFT) ~~ 0

    "Created: 13.8.1997 / 22:03:09 / cg"
    "Modified: 21.8.1997 / 19:41:34 / cg"
!

targetView
    "return the view which will eventually handle the event;
     for most events, this is the same as the view, for which the event was
     originally generated.
     Except, if an explicit focus has been assigned (i.e. tabbed into a component),
     AND the event is a keyboard event. In this case, the targetView might be different.
     Notice: this method might return nil, for synthetic (app-related) or display screen related
     events"

    |evView group focusView|

    evView := self view.
    self isDelegatedToFocusView ifTrue:[
        evView notNil ifTrue:[
            group := evView windowGroup.
            group notNil ifTrue:[
                focusView := group focusView.
                focusView notNil ifTrue:[^ focusView].
            ].
        ].
    ].
    ^ evView
! !

!WindowEvent::InputEvent methodsFor:'testing'!

isInputEvent
    ^ true

    "Created: / 21.5.1999 / 19:49:30 / cg"
! !

!WindowEvent::ButtonEvent methodsFor:'accessing'!

button
    "return the button nr of the button-event"

    ^ args at:1
!

state
    "return the button state of the button-event
     (mouse button bits at the time of the event)."

    ^ args at:1

    "Created: / 12.11.1998 / 16:21:18 / cg"
!

x
    "return the x coordinate of the button-event
     (mouse position at the time of the event)."

    ^ args at:2

    "Created: 1.8.1997 / 13:58:15 / cg"
!

x:anInteger
    "change the x coordinate of the button-event"

    args at:2 put:anInteger

    "Created: 1.8.1997 / 13:58:15 / cg"
!

y
    "return the y coordinate of the button-event
     (mouse position at the time of the event)."

    ^ args at:3

    "Created: 1.8.1997 / 13:58:07 / cg"
!

y:anInteger
    "change the y coordinate of the button-event"

    ^ args at:3 put:anInteger

    "Created: 1.8.1997 / 13:58:15 / cg"
! !

!WindowEvent::ButtonEvent methodsFor:'testing'!

isButtonEvent
    "return true, if this event is a button event"

    ^ true

    "Created: 4.4.1997 / 13:44:11 / cg"
! !

!WindowEvent::ButtonPressEvent methodsFor:'testing'!

isButtonPressEvent
    "return true, if this event is a buttonPress event"

    ^ true
! !

!WindowEvent::ButtonMultiPressEvent methodsFor:'testing'!

isButtonMultiPressEvent
    ^ true
!

isButtonPressEvent
    "/ ATTENTION: temporary for bw. compatibility, since due to a bug,
    "/ multi-presses returned false to this query

"/'----------------' errorPrint.
"/'oops multipressEvent asked for isButtonPress' errorPrintCR.
"/thisContext fullPrintAll.
    ^ false
! !

!WindowEvent::ButtonReleaseEvent methodsFor:'testing'!

isButtonReleaseEvent
    "return true, if this event is a buttonRelease event"

    ^ true
! !

!WindowEvent::ClientEvent methodsFor:'accessing'!

eventData
    "return the value of the instance variable 'eventData' (automatically generated)"

    ^ eventData

    "Created: 4.4.1997 / 17:41:50 / cg"
!

eventData:something
    "set the value of the instance variable 'eventData' (automatically generated)"

    eventData := something.

    "Created: 4.4.1997 / 17:41:57 / cg"
! !

!WindowEvent::ConfigureEvent methodsFor:'testing'!

isConfigureEvent
    ^ true
! !

!WindowEvent::DamageEvent methodsFor:'testing'!

isDamage
    "return true, if this is a damage event"

    ^ true
!

isDamageForView:aView
    "return true, if this is a damage event for aView"

    ^ (receiver == aView)
! !

!WindowEvent::EnterLeaveEvent methodsFor:'accessing'!

state

    ^ args at:1
!

x

    ^ args at:2 ifAbsent:nil
!

y

    ^ args at:3 ifAbsent:nil
! !

!WindowEvent::EnterLeaveEvent methodsFor:'testing'!

isPointerEnterEvent
    "return true, if this event is a pointer-enter event"

    ^ (selector == #'pointerEnter:x:y:')

    "Created: 9.1.1996 / 15:51:24 / cg"
    "Modified: 9.1.1996 / 15:51:40 / cg"
!

isPointerEnterLeaveEvent
    "return true, if this event is a pointer-enter/leave event"

    ^ true

    "Created: 9.1.1996 / 15:51:18 / cg"
!

isPointerLeaveEvent
    "return true, if this event is a pointer-leave event"

    ^ selector == #'pointerLeave:'

    "Created: 9.1.1996 / 15:51:36 / cg"
! !

!WindowEvent::FocusEvent methodsFor:'testing'!

isFocusEvent
    "return true, if this event is a focus event"

    ^ true

    "Created: / 21.5.1999 / 19:44:47 / cg"
!

isFocusInEvent
    "return true, if this event is a focusIn event"

    ^ (selector == #focusIn)

    "Created: / 21.5.1999 / 19:45:04 / cg"
!

isFocusOutEvent
    "return true, if this event is a focusOut event"

    ^ (selector == #focusOut)

    "Created: / 21.5.1999 / 19:45:04 / cg"
! !

!WindowEvent::KeyboardEvent methodsFor:'accessing'!

key
    "return the key of the key-event."

    ^ args at:1

    "Created: 1.8.1997 / 13:55:19 / cg"
!

key:aCharacterOrSymbol
    "change the key of the key-event."

    args at:1 put:aCharacterOrSymbol

    "Created: 1.8.1997 / 13:55:19 / cg"
!

rawKey
    ^ rawKey

    "Created: 4.4.1997 / 13:47:15 / cg"
!

rawKey:aKey
    rawKey := aKey

    "Created: 4.4.1997 / 13:47:10 / cg"
!

x
    "return the x coordinate of the key-event
     (mouse position at the time of the key-event)."

    ^ args at:2

    "Created: 1.8.1997 / 13:57:27 / cg"
!

x:anInteger
    "change the x coordinate of the key-event"

    ^ args at:2 put:anInteger
!

y
    "return the y coordinate of the key-event
     (mouse position at the time of the key-event)."

    ^ args at:3

    "Created: 1.8.1997 / 13:55:19 / cg"
    "Modified: 1.8.1997 / 13:57:42 / cg"
!

y:anInteger
    "change the y coordinate of the key-event"

    ^ args at:3 put:anInteger
! !

!WindowEvent::KeyboardEvent methodsFor:'testing'!

isDelegatedToFocusView
    "return true, if this event will be forwarded to a focusView."

    ^ true
!

isKeyEvent
    "return true, if this event is a keyboard event"

    ^ true

    "Created: 4.4.1997 / 13:39:59 / cg"
! !

!WindowEvent::ButtonMotionEvent methodsFor:'testing'!

isButtonMotionEvent
    "return true, if this event is a buttonMotion event"

    ^ true
! !

!WindowEvent::KeyPressEvent methodsFor:'testing'!

isKeyPressEvent
    "return true, if this event is a keyboard press event"

    ^ true
! !

!WindowEvent::KeyReleaseEvent methodsFor:'testing'!

isKeyReleaseEvent
    "return true, if this event is a keyboard press event"

    ^ true
! !

!WindowEvent::HotKeyEvent methodsFor:'accessing'!

hotkeyIdentifier
    ^ hotkeyIdentifier
!

hotkeyIdentifier:something
    hotkeyIdentifier := something.
! !

!WindowEvent::HotKeyEvent methodsFor:'testing'!

isHotKeyEvent
    "return true, if this event is a hotkey event"

    ^ true
! !

!WindowEvent::KeyboardFocusEvent methodsFor:'accessing'!

hasFocus

    ^ args at: 1
! !

!WindowEvent::KeyboardFocusEvent methodsFor:'testing'!

isKeyboardFocusEvent
    "return true, if this event is a keyboard focus event"

    ^ true
! !

!WindowEvent::MessageSendEvent methodsFor:'blocked'!

view
    ^ nil
! !

!WindowEvent::MessageSendEvent methodsFor:'testing'!

isMessageSendEvent
    "return true, if this event is a general messageSend event"

    ^ true



! !

!WindowEvent::MouseWheelMotionEvent methodsFor:'accessing'!

amount
    "return the amount of the mouse wheel motion event   "

    ^ args at:4
!

deltaTime
    "return the deltaTime of the mouse wheel motion event   "

    ^ args at:5
! !

!WindowEvent::MouseWheelMotionEvent methodsFor:'testing'!

isDelegatedToFocusView
    "return true, if this event will be forwarded to a focusView."

    ^ true.
!

isMouseWheelEvent
    ^ true.
! !

!WindowEvent::NativeWidgetCommandEvent methodsFor:'accessing'!

command
    ^ selector
!

command:something
    selector := something.
! !

!WindowEvent::NewDamageEvent methodsFor:'testing'!

isDamage
    "return true, if this is a damage event"

    ^ true
!

isDamageForView:aView
    "return true, if this is a damage event for aView"

    ^ (receiver == aView)
! !

!WindowEvent::TerminateEvent methodsFor:'testing'!

isTerminateEvent
    ^ true
! !

!WindowEvent::TrayActionEvent methodsFor:'accessing'!

event
    ^ selector

    "Created: / 31-10-2007 / 01:23:05 / cg"
!

event:something
    selector := something.

    "Created: / 31-10-2007 / 01:23:07 / cg"
! !

!WindowEvent::TrayActionEvent methodsFor:'testing'!

isTrayEvent
    ^ true

    "Created: / 09-11-2007 / 13:09:17 / cg"
! !

!WindowEvent::VisibilityChangeEvent class methodsFor:'instance creation'!

for:aView visibility:how
    ^ self new

    "Created: / 23-01-2012 / 10:02:42 / cg"
! !

!WindowEvent::WindowMapUnmapEvent methodsFor:'testing'!

isMapEvent
    "return true, if this is a map event"

    ^ selector == #mapped

    "Created: / 29-01-1998 / 21:52:54 / cg"
    "Modified: / 09-11-2007 / 13:11:02 / cg"
!

isUnmapEvent
    "return true, if this is an unmap event"

    ^ selector == #unmapped

    "Modified: / 09-11-2007 / 13:11:04 / cg"
! !

!WindowEvent class methodsFor:'documentation'!

version_CVS

    ^  '$Header: /cvs/stx/stx/libview/WindowEvent.st,v 1.111 2014-03-05 22:13:18 cg Exp $'
!

version_SVN
    ^ '$ Id $'
! !


WindowEvent::InputEvent initialize!
