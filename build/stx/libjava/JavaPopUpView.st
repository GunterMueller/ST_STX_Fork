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

PopUpView subclass:#JavaPopUpView
	instanceVariableNames:'eventReceiver updateRegions javaPeer'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Views-Support'
!

!JavaPopUpView class methodsFor:'documentation'!

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

!JavaPopUpView methodsFor:'accessing'!

delegate:anObject
"/    super delegate:anObject.
    eventReceiver := anObject.

    "Modified: / 2.12.1998 / 23:57:57 / cg"
    "Created: / 4.12.1998 / 14:09:12 / cg"
!

getNextUpdateRectangle
    |r|

    updateRegions size == 0 ifTrue:[^ nil].
    r := updateRegions removeFirst.
    updateRegions size == 0 ifTrue:[updateRegions := nil].
    ^ r

    "Created: / 4.12.1998 / 14:09:12 / cg"
!

javaPeer
    "for debugging support - here is a handle to the corresponding
     javaPeer"

    ^ javaPeer

    "Created: / 4.12.1998 / 14:09:13 / cg"
!

javaPeer:aJavaView
    "for debugging support - here is a handle to the corresponding
     javaPeer"

    javaPeer := aJavaView

    "Created: / 4.12.1998 / 14:09:13 / cg"
! !

!JavaPopUpView methodsFor:'defaults'!

defaultShadow
    ^ false

    "Created: / 4.12.1998 / 15:12:13 / cg"
! !

!JavaPopUpView methodsFor:'event handling'!

exposeX:x y:y width:w height:h
    |ev rect|

    rect := Rectangle left:x top:y width:w height:h.

"/ 'JavaView expose' printCR.

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

    "Modified: / 19.10.1998 / 23:10:15 / cg"
    "Created: / 4.12.1998 / 14:09:13 / cg"
! !

!JavaPopUpView methodsFor:'initialization'!

initialize
    super initialize.

    self enableMotionEvents.

    "Modified: / 2.12.1998 / 23:32:30 / cg"
    "Created: / 4.12.1998 / 14:09:13 / cg"
! !

!JavaPopUpView methodsFor:'queries'!

isJavaView
    ^ true

    "Created: / 4.12.1998 / 14:09:40 / cg"
! !

!JavaPopUpView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaPopUpView.st,v 1.10 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaPopUpView.st,v 1.10 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

