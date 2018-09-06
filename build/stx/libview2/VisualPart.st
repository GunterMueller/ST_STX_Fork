"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

VisualComponent subclass:#VisualPart
	instanceVariableNames:'container layout name visibilityHolder originHolder extentHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!VisualPart class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    abstract superclass for all kinds of visual components, which
    are containers for some other component.
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

    [see also:]
        GeometricWrapper
"


! !

!VisualPart methodsFor:'accessing'!

backgroundColor
    ^ container backgroundColor

    "Created: / 18.6.1998 / 15:58:34 / cg"
!

container
    "return my container"

    ^ container

    "Created: 9.5.1996 / 00:31:41 / cg"
    "Modified: 5.6.1996 / 01:08:26 / cg"
!

container:something
    "set container"

    container := something.

    "Created: 9.5.1996 / 00:31:41 / cg"
!

extentHolder
    ^ extentHolder
!

extentHolder:something
    extentHolder removeDependent:self.
    extentHolder := something.
    extentHolder notNil ifTrue:[ extentHolder addDependent:self].
!

graphicsContext
    "return the graphicsContext"

    ^ container graphicsContext

    "Created: 9.5.1996 / 00:32:12 / cg"
    "Modified: 9.5.1996 / 01:37:10 / cg"
!

graphicsDevice
    "return the graphicsContext"

    ^ container graphicsDevice

    "Created: 9.5.1996 / 00:32:12 / cg"
    "Modified: 9.5.1996 / 01:37:03 / cg"
!

name
    ^ name
!

name:something
    name := something.
!

originHolder
    ^ originHolder
!

originHolder:something
    originHolder removeDependent:self.
    originHolder := something.
    originHolder notNil ifTrue:[ originHolder addDependent:self].
!

topComponent
    "return the top component - typically the topView"

    ^ container topComponent

    "Modified: 9.5.1996 / 01:37:10 / cg"
    "Created: 9.5.1996 / 01:39:15 / cg"
!

view
    "return my view"

    container isNil ifTrue:[^ nil].
    ^ container view

    "Created: 4.6.1996 / 21:32:34 / cg"
    "Modified: 5.6.1996 / 01:20:13 / cg"
!

visibilityChannel
    "/ self obsoleteMethodWarning.
    ^ self visibilityHolder
!

visibilityChannel:something
    "/ self obsoleteMethodWarning.
    self visibilityHolder:something
!

visibilityHolder
    ^ visibilityHolder
!

visibilityHolder:something
    visibilityHolder removeDependent:self.
    visibilityHolder := something.
    visibilityHolder notNil ifTrue:[ visibilityHolder addDependent:self].
! !

!VisualPart methodsFor:'accessing-dimensions'!

bounds:newBounds
"/    self assert:(newBounds left isInteger).
"/    self assert:(newBounds width isInteger).
"/    self assert:(newBounds top isInteger).
"/    self assert:(newBounds height isInteger).

    frame := newBounds rounded.
!

possiblyInvalidate
    container notNil ifTrue:[
        self computeBoundingBox.
        frame notNil ifTrue:[
            container invalidate:(frame insetBy:-2).
        ]
    ].
! !

!VisualPart methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "/ invalidate is always ok - however, it will redraw bg, fg and line
    "/ and therefore may produce flicker (unless double buffering)

    (changedObject == originHolder 
    or:[ changedObject == extentHolder ]) ifTrue:[
        "/ invalidate old region
        self container 
            clearRectangle:self frame;
            invalidateRectangle:self frame repairNow:false.

        "/ flush cached frame info.   
        frame := nil.
    ].
    self invalidate.
! !

!VisualPart methodsFor:'view protocol mimicri'!

bottomInset
    ^ 0
!

computeBoundingBox
    |newBounds newOrigin newExtent delta|

    container notNil ifTrue:[
        layout notNil ifTrue:[
            newBounds := layout 
                            rectangleRelativeTo:(0@0 extent:container extent "container bounds")
                            preferred:self preferredBounds.
        ].
        (newExtent := extentHolder value) notNil ifTrue:[
            newBounds isNil ifTrue:[
                newBounds := 0@0 extent:newExtent.
            ] ifFalse:[
                newBounds extent:newExtent
            ]
        ].
        (newOrigin := originHolder value) notNil ifTrue:[
            newBounds isNil ifTrue:[
                newBounds := newOrigin extent:(self preferredExtent).
            ].
            delta := newOrigin - newBounds origin.
            newBounds origin:newOrigin corner:(newBounds corner + delta).
        ].
        newBounds notNil ifTrue:[
            self bounds:newBounds.
        ].
    ].

    ^ frame
!

computeCorner
    ^ self corner
!

computeExtent
    ^ self extent
!

computeOrigin
    ^ self origin
!

containerChangedSize
    "my container changed its size.
     The default here is to ignore this, but some wrappers like
     to resize when this happens."

"/Transcript show:'container '; show:container; show:' of '; show:self; 
"/           show:' changed size to '; showCR:container viewRectangle.

    layout notNil ifTrue:[
        self bounds:(layout 
                        rectangleRelativeTo:(0@0 extent:container extent "container bounds")
                        preferred:self preferredBounds).
    ].
    "/ self invalidate.

    "Created: 4.6.1996 / 21:27:58 / cg"
    "Modified: 19.7.1996 / 21:20:58 / cg"
!

cornerRule
    ^ nil
!

create
    "want myself to be created."

    container create

    "Created: 4.6.1996 / 21:30:25 / cg"
!

destroy
    |c|

    (c := container) notNil ifTrue:[
        container := nil.
        frame notNil ifTrue:[ c invalidate:frame ].
        c removeComponent:self.
    ].
!

device
    ^ container device
!

extentRule
    ^ nil
!

geometryLayout
    ^ layout 
!

geometryLayout:newLayoutOrNil
    self possiblyInvalidate.

    frame := nil.
    layout := newLayoutOrNil.

    self possiblyInvalidate.
!

invalidate
    container notNil ifTrue:[
        (layout notNil or:[frame notNil]) ifTrue:[
            container invalidate:self bounds
        ]
    ]

    "Modified: / 18.6.1998 / 16:12:15 / cg"
!

isComponentOf:aViewOrComponent
    "return true, if I am a (direct or indirect) component of aViewOrComponent"

    |sview|

    sview := self.

    [ (sview := sview container) notNil ] whileTrue:[
        sview == aViewOrComponent ifTrue:[^ true].
    ].
    ^ false
!

leftInset
    ^ 0
!

originRelativeTo:aContainer
    "return the origin (in pixels) relative to a superView,
     or relative to the rootView (if the aView argument is nil).
     If the receiver is nonNil and not a subview of aView, return nil."

    |currentPart
     bw   "{ Class: SmallInteger }"
     sumX "{ Class: SmallInteger }"
     sumY "{ Class: SmallInteger }"|

    currentPart := self.
    sumX := 0.
    sumY := 0.
    [currentPart notNil] whileTrue:[
        (currentPart == aContainer) ifTrue:[
            ^ (sumX @ sumY)
        ].
        bw := currentPart borderWidth.
        sumX := sumX + (currentPart left) + bw.
        sumY := sumY + (currentPart top) + bw.
        currentPart := currentPart superView
    ].

    (aContainer isNil or:[aContainer == self graphicsDevice rootView]) ifTrue:[
        "return relative to screen ..."
        ^ (sumX @ sumY)
    ].
    ^ nil
!

originRule
    ^ nil
!

realize
    "my container realized itself.
     The default here is to ignore this, but some wrappers like
     to do something when this happens."

    self realizeAllSubViews

    "Created: / 4.6.1996 / 21:28:31 / cg"
    "Modified: / 6.7.1998 / 18:38:28 / cg"
!

realizeAllSubViews
    "realize all my subviews - but not myself."

    ^ self

    "Created: / 6.7.1998 / 18:37:08 / cg"
!

relativeCorner
    ^ nil
!

relativeExtent
    ^ nil
!

relativeOrigin
    ^ nil
!

rightInset
    ^ 0
!

shown
    container isNil ifTrue:[^ false].
    ^ container shown


!

subViewChangedSize
    ^ self

    "Created: 4.6.1996 / 21:35:57 / cg"
!

subViews
    ^ #()
!

topInset
    ^ 0
!

topView
    "return the topView - that's the one with no superview"

    ^ container topView
!

windowGroup
    ^ container windowGroup

    "Created: 5.6.1996 / 00:49:19 / cg"
!

withAllSubViewsDo:aBlock
    aBlock value:self
! !

!VisualPart class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/VisualPart.st,v 1.26 2014-12-02 17:22:25 cg Exp $'
! !

