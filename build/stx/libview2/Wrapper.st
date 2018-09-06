"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

VisualPart subclass:#Wrapper
	instanceVariableNames:'component'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!Wrapper class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    abstract superclass for all kinds of wrapping components

    This class and its subclasses (currently) exist mostly for
    ST-80 compatibility - to provide a home for ported PD classes,
    which depend on the VisualPart hierarchy.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.
        This is still being constructed - not yet finished.

    [author:]
        Claus Gittinger
"

! !

!Wrapper class methodsFor:'instance creation'!

on:aComponent
    ^ self new component:aComponent

    "Created: 8.5.1996 / 23:20:46 / cg"
! !

!Wrapper methodsFor:'accessing'!

component
    "return the wrappers component"

    ^ component

    "Created: 8.5.1996 / 23:17:30 / cg"
    "Modified: 9.5.1996 / 00:19:58 / cg"
!

component:someComponent
    "set the wrappers component"

    component := someComponent.
    component notNil ifTrue:[
        "/ temporary kludge - images are (currently) not
        "/ inheriting from visualComponent ...
"/        (someComponent respondsTo:#container:) ifTrue:[
            someComponent container:self.
"/        ].
        frame isNil ifTrue:[
            component bounds notNil ifTrue:[
                frame := component bounds
            ]
        ]
    ]

    "Created: 8.5.1996 / 23:17:46 / cg"
    "Modified: 5.6.1996 / 02:31:40 / cg"
! !

!Wrapper methodsFor:'accessing - bounds'!

bounds:newBounds
    "set my bounds - forwarded to the wrapped object"

    newBounds ~= frame ifTrue:[
        frame := newBounds.
        component bounds:newBounds
    ].

    "Created: 8.5.1996 / 23:18:12 / cg"
    "Modified: 19.7.1996 / 17:47:34 / cg"
!

newBounds:newBounds containingBounds:containingBounds
    self bounds:newBounds

    "Created: 26.5.1996 / 16:50:49 / cg"
!

preferredBounds
    "return my preferredBounds as the components preferredBounds"

    ^ component preferredBounds

    "Created: 8.5.1996 / 23:18:53 / cg"
    "Modified: 9.5.1996 / 00:10:32 / cg"
! !

!Wrapper methodsFor:'displaying'!

displayOn:aGCOrStream
    "display myself - forwarded to the wrapped object"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream or:[aGCOrStream == Transcript]) ifTrue:[
        self printOn:aGCOrStream.
        ^ self
    ].
    component displayOn:aGCOrStream

    "Created: / 08-05-1996 / 23:19:24 / cg"
    "Modified: / 11-09-2006 / 15:01:24 / User"
! !

!Wrapper methodsFor:'queries'!

hasBorder
    ^ false

    "Created: 26.5.1996 / 16:47:37 / cg"
!

isWrapper
    ^ true

    "Created: 5.6.1996 / 01:04:30 / cg"
! !

!Wrapper methodsFor:'testing'!

containsPoint:aPoint
    ^ component containsPoint:aPoint

    "Created: 26.5.1996 / 16:48:00 / cg"
!

intersects:aRectangle
    ^ component intersects:aRectangle

    "Created: 26.5.1996 / 16:48:52 / cg"
! !

!Wrapper methodsFor:'view protocol mimicri'!

containerMapped
    component containerMapped

    "Created: 19.7.1996 / 17:41:31 / cg"
!

containerUnmapped
    component containerUnmapped

    "Created: 19.7.1996 / 17:45:10 / cg"
!

destroy
    self destroyComponent.
    super destroy.

    "Created: 19.7.1996 / 17:26:02 / cg"
!

destroyComponent
    component destroy
!

realize
    "my container realized itself. Forward this to my component"

    component realize.

    "Created: 4.6.1996 / 21:29:27 / cg"
!

removeSubView:aView
    component := nil

    "Created: 4.6.1996 / 21:39:50 / cg"
!

withAllSubViewsDo:aBlock
    aBlock value:self.
    component notNil ifTrue:[
        component withAllSubViewsDo:aBlock
    ].

! !

!Wrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/Wrapper.st,v 1.13 2009-05-08 11:54:52 cg Exp $'
! !

