"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

MessageSend subclass:#Event
	instanceVariableNames:'timeStamp'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!Event class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    An abstract class that has been inserted recently into the long-time-existing
    WindowEvent hierarchy for more VW compatibility. Especially to provide a home
    for sublcasses of UI.Event.

    The real code has been and still is in WindowEvent.

    [author:]
        Claus Gittinger

    [see also:]
        WindowEvent MessageSend WindowGroup WindowSensor
        DeviceWorkstation View
        KeyboardMap KeyboardForwarder EventListener

"
! !

!Event methodsFor:'accessing'!

target
    "return the target, for which the event is for"

    ^ receiver
!

target:anObject
    "set the target, for which the event is for"

    receiver := anObject
!

timeStamp
    ^ timeStamp
!

timeStamp:aTimestamp
    timeStamp := aTimestamp.
! !

!Event class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/Event.st,v 1.1 2009-06-01 08:42:33 cg Exp $'
! !
