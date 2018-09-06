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

Wrapper subclass:#GeometricWrapper
	instanceVariableNames:'foregroundColor backgroundColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!GeometricWrapper class methodsFor:'documentation'!

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
    abstract class for wrappers of geometric objects.
    These allows any geometric thingy to be used as a component in a view.

    (background info: geometrics are mathematical objects - they do not 
     keep any color or lineStyle attributes. Wrappers add this information
     and can also be used as components of a view)

    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [see also:]
        StrokingWrapper FillingWrapper
        Geometric GraphicsContext

    [author:]
        Claus Gittinger
"



! !

!GeometricWrapper methodsFor:'accessing'!

backgroundColor
    ^ backgroundColor
!

backgroundColor:something
    backgroundColor := something.
    self invalidate.
!

component:someComponent
    "set the wrappers component. 
     Redefined to not set the components container - we know, those
     Geometrics dont know about containers."

    component := someComponent.

    "Created: 28.5.1996 / 23:02:36 / cg"
    "Modified: 28.5.1996 / 23:02:52 / cg"
!

foregroundColor
    ^ foregroundColor
!

foregroundColor:something
    foregroundColor := something.
    self invalidate.
! !

!GeometricWrapper methodsFor:'accessing - bounds'!

bounds
    "return the components bounds as default bounds"

    frame notNil ifTrue:[^ frame].
    ^ component bounds rounded

    "Created: 5.6.1996 / 02:29:10 / cg"
    "Modified: 5.6.1996 / 20:30:50 / cg"
!

bounds:newBounds
    "set my bounds"

    frame := newBounds

    "Created: 5.6.1996 / 02:30:00 / cg"
!

preferredBounds
    "return the components bounds as preferredBounds"

    ^ component bounds ceiling
! !

!GeometricWrapper methodsFor:'initialize / release'!

flushCoordinateCaches
    "/ geometrics are not interested in that

    "Created: 12.2.1997 / 11:56:07 / cg"
!

initialize
   foregroundColor := Color black.

! !

!GeometricWrapper methodsFor:'view protocol mimicri'!

destroyComponent
    "component is not a visualPart. Ignored here"
!

realize
    "my container realized itself. Ignored here"

    "Created: 5.6.1996 / 02:32:39 / cg"
! !

!GeometricWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/GeometricWrapper.st,v 1.13 2009-05-08 11:54:36 cg Exp $'
! !

