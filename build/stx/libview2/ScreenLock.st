"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

EventListener subclass:#ScreenLock
	instanceVariableNames:'workstation lastInactiveTime lockAfterSeconds lockChannel
		lockChannelOut processor lockedViews hiddenViews'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support'
!

!ScreenLock class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    documentation to be added.

    [author:]
	Stefan Vogel (stefan@nilpferd)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"
                                                                [exBegin]
    |screenLock|

    screenLock := ScreenLock forDevice:Screen current.
    screenLock lock.
    Delay waitForSeconds:3.
    screenLock unlock.
    screenLock unlisten.
                                                                [exEnd]

                                                                [exBegin]
    |screenLock|

    screenLock := ScreenLock forDevice:Screen current.
    Delay waitForSeconds:1.
    screenLock checkTime.
    Delay waitForSeconds:12.
    screenLock checkTime.
    Delay waitForSeconds:3.
    screenLock unlock.
    screenLock unlisten.
                                                                [exEnd]
                                                                [exBegin]
    |screenLock channel running|

    screenLock := ScreenLock forDevice:Screen current.
    screenLock lockAfterSeconds:4.
    [
        channel := false asValue.
        channel onChangeEvaluate:[
            channel value ifTrue:[
                self information:'Application is locked\\Hit ok to unlock' withCRs.
                channel value:false.
            ].
        ].
        screenLock lockChannel:channel.

        [
            Delay waitForSeconds:2.
            screenLock checkTime.
        ] loop.
    ] valueNowOrOnUnwindDo:[
        screenLock unlisten.
    ].
                                                                [exEnd]
"
! !

!ScreenLock class methodsFor:'instance creation'!

forDevice:aWorkstation

    ^ self new initializeForDevice:aWorkstation

! !

!ScreenLock methodsFor:'accessing'!

lockAfterSeconds
    "return the value of the instance variable 'lockAfterSeconds' (automatically generated)"

    ^ lockAfterSeconds
!

lockAfterSeconds:something
    "set the value of the instance variable 'lockAfterSeconds' (automatically generated)"

    lockAfterSeconds := something.
!

lockChannel

    lockChannel isNil ifTrue:[
        self lockChannel:false asValue.
    ].
    ^ lockChannel
!

lockChannel:something

    lockChannel notNil ifTrue:[ 
        lockChannel removeDependent:self.
    ].

    lockChannel := something.
    lockChannel addDependent:self.
!

lockChannelOut

    lockChannelOut isNil ifTrue:[
        lockChannelOut := false asValue.
    ].
    ^ lockChannelOut
!

lockChannelOut:something
    "set the value of the instance variable 'lockChannelOut' (automatically generated)"

    lockChannelOut := something.
!

processor
    "return the value of the instance variable 'processor' (automatically generated)"

    ^ processor
!

processor:something
    "set the value of the instance variable 'processor' (automatically generated)"

    processor := something.
!

workstation
    "return the value of the instance variable 'workstation' (automatically generated)"

    ^ workstation
!

workstation:something
    "set the value of the instance variable 'workstation' (automatically generated)"

    workstation := something.
! !

!ScreenLock methodsFor:'change & update'!

update:aspect with:param from:anObject

    |lock|

    anObject == lockChannel ifTrue:[
        aspect == #value ifTrue:[
            "/ lockChannel is a value holder
            lock := lockChannel value.
        ] ifFalse:[
            "/ lockChannel is a block or something else
            lock := param.
        ].

        "lock or unlock the screen
         If a processor is defined, let the processor perform the unlock,
         so that posssible Display errors do not affect the sender"

        lock == true ifTrue:[
            processor isNil ifTrue:[
                self lockScreen.
            ] ifFalse:[
                processor enqueueMessage:#lockScreen for:self arguments:#().
            ].
        ] ifFalse:[
            processor isNil ifTrue:[
                self unlockScreen.
            ] ifFalse:[
                processor enqueueMessage:#unlockScreen for:self arguments:#().
            ].
        ]
    ].
! !

!ScreenLock methodsFor:'events'!

buttonMotion:state x:x y:y view:aView

    ^ self gotEventForView:aView.
!

buttonMultiPress:button x:x y:y view:aView
    ^ self gotEventForView:aView.

!

buttonPress:button x:x y:y view:aView
    ^ self gotEventForView:aView.

!

buttonRelease:button x:x y:y view:aView
    ^ self gotEventForView:aView.

!

keyPress:key x:x y:y view:aView
    ^ self gotEventForView:aView.

!

keyRelease:key x:x y:y view:aView
    ^ self gotEventForView:aView.

!

mouseWheelMotion:state x:x y:y amount:amount deltaTime:dTime view:aView
    ^ self gotEventForView:aView.

! !

!ScreenLock methodsFor:'lock interface'!

checkTime

    |now|

    lockedViews isNil ifTrue:[
        now := Timestamp now.
        lastInactiveTime notNil ifTrue:[
            (lastInactiveTime addSeconds:lockAfterSeconds value) < now ifTrue:[
                self lock
            ].
        ] ifFalse:[
            lastInactiveTime := now.
        ].
    ].
!

lock
   "trigger locking of screen"

    self lockChannel value:true.
!

unlisten
    "do not listen for events any longer.
     This must be called when a screen lock is detached from a
     screen."

    workstation removeEventListener:self
!

unlock
   "trigger unlocking of screen"

    self lockChannel value:false.
! !

!ScreenLock methodsFor:'private'!

gotEventForView:v
    "got an event.
     Reset the inactive timer.
     If locked, eat all user events (for security)"

    lockedViews isNil ifTrue:[
        lastInactiveTime := nil.        
        ^ false.
    ].
    ^ lockedViews includes:v.
!

initializeForDevice:aWorkstation

     lockAfterSeconds := 10.
     workstation := aWorkstation.
     workstation addEventListener:self.

!

lockScreen
    "lock the screen"

    lockedViews := workstation allViews.
    hiddenViews := lockedViews select:[:v|
        "close popupViews, they will leave the modal loop when 
         they are unmapped.
         This is a kludge, but invisible popUpViews are 
         currently not supported"

        v isPopUpView ifTrue:[
            v hide.
        ].
        v shown and:[v isTopView].
    ].

    hiddenViews do:[:v|
        v beInvisible.
    ].

    lockChannelOut notNil ifTrue:[      
        lockChannelOut value:true.
    ].
!

unlockScreen

    lastInactiveTime := nil.
    hiddenViews do:[:v|
        "don't try to restore views that have been closed while
         being invisible"
        v id notNil ifTrue:[
            v beVisible.
        ].
    ].
    hiddenViews := lockedViews := nil.

    lockChannelOut notNil ifTrue:[      
        lockChannelOut value:false.
    ].
! !

!ScreenLock methodsFor:'queries'!

isLocked

    ^ lockedViews notNil
! !

!ScreenLock class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

