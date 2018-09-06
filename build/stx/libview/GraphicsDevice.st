"
COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
COPYRIGHT (c) 2016 Jan Vrany
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

Object subclass:#GraphicsDevice
	instanceVariableNames:'displayId screen eventListeners deviceType graphicsContextClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Graphics'
!

GraphicsDevice class instanceVariableNames:'graphicsContextClass'

"
 No other class instance variables are inherited by this class.
"

!
AllocationFailure subclass:#GraphicResourceAllocationFailure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:GraphicsDevice
!

!GraphicsDevice class methodsFor:'documentation'!

copyright
"
COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
COPYRIGHT (c) 2016 Jan Vrany
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
    this abstract class was inserted to provide a home for ST-80 classes
    (previously, DeviceWorkstation was directly under Object).

    In ST/X, this is mostly dummy.

    [instance variables:]
      displayId       <Handle>            the device handle
      screen          any                 another some device specific id
      eventListeners  <Collection> | nil  bunch of objects interested in events.
      deviceType      <Symbol>             some arbitrary symbol, used to choose windowSpecs.

    [see also:]
	DeviceWorkstation XWorkstation

    [author:]
	Claus Gittinger
"

! !

!GraphicsDevice class methodsFor:'accessing'!

graphicsContextClass
    "Return a graphics context class to use for this graphics device type.
     Default is to use DeviceGraphicsContext"
    ^ graphicsContextClass ? DeviceGraphicsContext

    "Modified (comment): / 25-02-2016 / 07:30:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

graphicsContextClass:aClass
    "Set a graphics context class to use for this graphics device type.
     Usually there's no need set this, just stich with defaults." 

    graphicsContextClass := aClass.

    "Modified (comment): / 25-02-2016 / 07:30:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsDevice methodsFor:'accessing'!

graphicsContextClass
    "Return a graphics context class to use for this device.
     Default is to use DeviceGraphicsContext"
    graphicsContextClass isNil ifTrue:[ 
        graphicsContextClass := self class graphicsContextClass.         
    ].
    ^ graphicsContextClass

    "Modified: / 25-02-2016 / 07:31:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

graphicsContextClass:aClass
    "Set a graphics context class to use for this device.
     Usually there's no need set this, just stich with defaults." 

    graphicsContextClass := aClass.

    "Modified (comment): / 25-02-2016 / 07:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsDevice methodsFor:'accessing & queries'!

addEventListener:aListener
    "add a local eventListener (with new protocol - #processEvent:)
     This one gets a chance to intercept all events for this device"

    eventListeners isNil ifTrue:[
        eventListeners := OrderedCollection new:2
    ].
    (eventListeners includesIdentical:aListener) ifFalse:[
        eventListeners add:aListener
    ].
!

bePDA
    self deviceType:#pda
!

deviceType
    ^ deviceType
!

deviceType:aSymbol
    deviceType := aSymbol
!

isPDA
    ^ self deviceType == #pda
!

isWebServiceDevice
    "I am not a WebService pseude-device"

    ^ false
!

removeEventListener:aListener
    "remove a local eventListener (with new protocol - #processEvent:)"

    eventListeners notNil ifTrue:[
	eventListeners removeIdentical:aListener ifAbsent:nil
    ].
! !

!GraphicsDevice methodsFor:'creating graphics contexts'!

newGraphicsContextFor:aGraphicsMedium
    "create a new graphics context.
     The defaults is to use the inherited graphics context.
     Subclasses may redefine this to use their own graphics context"

    |gc|

    GraphicsMedium superclass == DeviceGraphicsContext ifTrue:[
        "this is for transition to delegatest GC"
        ^ aGraphicsMedium.
    ].
    graphicsContextClass isNil ifTrue:[ 
        graphicsContextClass := self class graphicsContextClass.
    ].
    gc := graphicsContextClass onDevice:self.
    gc font:aGraphicsMedium class defaultFont.
    ^ gc.

    "Modified: / 25-02-2016 / 07:32:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsDevice methodsFor:'event processing'!

notifyEventListenersAbout:anEvent
    "notify all eventHandlers about an incoming event.
     If any returns true, it is assumed to be eaten by the handler and not
     enqueued (i.e. not passed to the windowGroup process)"

    |anyListenerReturnedTrue|

    anyListenerReturnedTrue := false.

    "/ local listeners ...
    eventListeners notNil ifTrue:[
        eventListeners do:[:aListener |
            "/ notice: evaluating or here; all listeners get a chance
            anyListenerReturnedTrue := anyListenerReturnedTrue |
                                       (aListener processEvent:anEvent)
        ]
    ].

    ^ anyListenerReturnedTrue.
! !

!GraphicsDevice methodsFor:'misc'!

roundTripTime
    "answer the round trip time in milliseconds.
     May be used to detect slow device connections.
     Subclasses redefine this. Assume a fast Diplay connection
     and answer 0 here"

    ^ 0

    "
     Screen current roundTripTime
    "
! !

!GraphicsDevice::GraphicResourceAllocationFailure class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
COPYRIGHT (c) 2016 Jan Vrany
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
    raised when allocation of a graphics resource (pixmap, bitmap, cursor, font, etc.)
    fails.
"
! !

!GraphicsDevice::GraphicResourceAllocationFailure class methodsFor:'queries'!

defaultAnswer
    ^ nil
!

isQuerySignal
    ^ true
! !

!GraphicsDevice::GraphicResourceAllocationFailure class methodsFor:'raising'!

query
    ^ self raiseAsQuery
! !

!GraphicsDevice class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

