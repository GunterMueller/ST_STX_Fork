"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

View subclass:#JavaView
	instanceVariableNames:'eventReceiver updateRegions javaPeer'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Views-Support'
!

!JavaView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaView methodsFor:'accessing'!

delegate:anObject
    super delegate:anObject.
    eventReceiver := anObject.

    "Created: 18.8.1997 / 15:22:20 / cg"
!

getNextUpdateRectangle
    |r|

    updateRegions size == 0 ifTrue:[^ nil].
    r := updateRegions removeFirst.
    updateRegions size == 0 ifTrue:[updateRegions := nil].
    ^ r

    "Created: 18.8.1997 / 15:37:31 / cg"
!

javaPeer
    "for debugging support - here is a handle to the corresponding
     javaPeer"

    ^ javaPeer

    "Created: 18.8.1997 / 22:34:35 / cg"
!

javaPeer:aJavaView
    "for debugging support - here is a handle to the corresponding
     javaPeer"

    javaPeer := aJavaView

    "Created: 18.8.1997 / 22:34:30 / cg"
! !

!JavaView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    "/ req'd if running as embeddedApplet ...

    |ev sensor|

"/ 'JavaView buttonMotion' printCR.

    sensor := self sensor.    
    eventReceiver notNil ifTrue:[
        ev := WindowEvent buttonEvent
                 for:self
                 type:#buttonMotion:x:y:
                 arguments:(Array with:state with:x with:y).
        ev hasShift:sensor shiftDown
           ctrl:sensor ctrlDown
           alt:sensor altDown      
           meta:sensor metaDown
           button1:sensor leftButtonPressed
           button2:sensor middleButtonPressed 
           button3:sensor rightButtonPressed.
        eventReceiver processEvent:ev.
    ].

    "Modified: / 12.11.1998 / 16:30:50 / cg"
    "Created: / 10.12.1998 / 19:35:40 / cg"
!

buttonPress:button x:x y:y
    "/ req'd if running as embeddedApplet ...

    |ev|

"/ 'JavaView buttonPress' printCR.

    eventReceiver notNil ifTrue:[
        ev := WindowEvent buttonEvent
                 for:self
                 type:#buttonPress:x:y:
                 arguments:(Array with:button with:x with:y).
        ev hasShift:self sensor shiftDown
           ctrl:self sensor ctrlDown
           alt:self sensor altDown      
           meta:self sensor metaDown
           button1:self sensor leftButtonPressed
           button2:self sensor middleButtonPressed 
           button3:self sensor rightButtonPressed.
        eventReceiver processEvent:ev.
    ].

    "Modified: / 6.2.1998 / 00:56:56 / cg"
    "Created: / 10.12.1998 / 19:35:58 / cg"
!

buttonRelease:button x:x y:y
    "/ req'd if running as embeddedApplet ...

    |ev|

"/ 'JavaView buttonRelease' printCR.

    eventReceiver notNil ifTrue:[
        ev := WindowEvent buttonEvent
                 for:self
                 type:#buttonRelease:x:y:
                 arguments:(Array with:button with:x with:y).

        ev hasShift:self sensor shiftDown
           ctrl:self sensor ctrlDown
           alt:self sensor altDown      
           meta:self sensor metaDown
           button1:self sensor leftButtonPressed
           button2:self sensor middleButtonPressed 
           button3:self sensor rightButtonPressed.
        eventReceiver processEvent:ev.
    ].

    "Modified: / 6.2.1998 / 00:57:00 / cg"
    "Created: / 10.12.1998 / 19:36:11 / cg"
!

exposeX:x y:y width:w height:h
    |ev rect|

    rect := Rectangle left:x top:y width:w height:h.

"/ ('JavaView exposeX:' , x printString , ' y:' , y printString , ' width:' , w printString , ' height:' , h printString) printCR.

    updateRegions isNil ifTrue:[
        updateRegions := OrderedCollection new.
    ].
    updateRegions add:rect.
    eventReceiver notNil ifTrue:[
        ev := WindowEvent 
                damageFor:self 
                rectangle:rect. 
        eventReceiver processEvent:ev.
    ].
"/    super exposeX:x y:y width:w height:h

    "Created: / 18.8.1997 / 15:00:24 / cg"
    "Modified: / 19.10.1998 / 23:10:15 / cg"
!

keyPress:key x:x y:y
    "/ req'd if running as embeddedApplet ...

    |ev|

"/ 'JavaView keyPress' printCR.

    eventReceiver notNil ifTrue:[
        ev := WindowEvent keyboardEvent
                 for:self
                 type:#keyPress:x:y:
                 arguments:(Array with:key with:x with:y).
        eventReceiver processEvent:ev.
    ].

    "Modified: / 6.2.1998 / 00:57:08 / cg"
    "Created: / 10.12.1998 / 19:36:24 / cg"
!

keyRelease:key x:x y:y
    "/ req'd if running as embeddedApplet ...

    |ev|

"/ 'JavaView keyRelease' printCR.

    eventReceiver notNil ifTrue:[
        ev := WindowEvent keyboardEvent
                 for:self
                 type:#keyRelease:x:y:
                 arguments:(Array with:key with:x with:y).
        eventReceiver processEvent:ev.
    ].

    "Modified: / 6.2.1998 / 00:57:16 / cg"
    "Created: / 10.12.1998 / 19:36:38 / cg"
! !

!JavaView methodsFor:'initialization'!

initialize
    super initialize.

    self enableMotionEvents.
    (superView notNil and:[superView isMemberOf:JavaEmbeddedFrameView])
    ifTrue:[
        self viewBackground:superView viewBackground
    ]

    "Created: / 21.8.1997 / 16:37:45 / cg"
    "Modified: / 13.1.1998 / 14:29:30 / cg"
! !

!JavaView methodsFor:'queries'!

isJavaView
    ^ true

    "Created: / 4.12.1998 / 14:09:30 / cg"
! !

!JavaView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaView.st,v 1.30 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaView.st,v 1.30 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

