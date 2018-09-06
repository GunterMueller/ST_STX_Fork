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

Wrapper subclass:#TranslatingWrapper
	instanceVariableNames:'origin'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!TranslatingWrapper class methodsFor:'documentation'!

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
    a wrapper which shifts the origin of its wrapped component.
    This allows the wrapped thingy to think & draw in its own 0@0 based
    coordinates.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [see also:]
        Wrapper 

    [author:]
        Claus Gittinger
"
!

examples
"
  some components without translatingWrapper
                                                                        [exBegin]
    |t s v e component|

    t := StandardSystemView extent:250@200.
    s := HVScrollableView for:View miniScroller:true in:t.
    s origin:0.0@0.0 corner:1.0@1.0.
    v := s scrolledView.

    e := Rectangle origin:10@10 corner:90@90.
    component := FillingWrapper on:e.
    component foregroundColor:Color red.
    v addComponent:component.

    e := EllipticalArc boundingBox:(10@10 corner:90@90)
                     startAngle:0 sweepAngle:360.
    component := StrokingWrapper on:e.
    component lineWidth:5.
    component foregroundColor:Color black.
    v addComponent:component.

    e := Arrow from:100@100 to:150@250.
    component := StrokingWrapper on:e.
    component lineWidth:2.
    v addComponent:component.

    t open
                                                                        [exEnd]
  the same components WITH translatingWrappers
                                                                        [exBegin]
    |t s v e component|

    t := StandardSystemView extent:250@200.
    s := HVScrollableView for:View miniScroller:true in:t.
    s origin:0.0@0.0 corner:1.0@1.0.
    v := s scrolledView.

    e := Rectangle origin:0@0 corner:80@80.
    component := FillingWrapper on:e.
    component foregroundColor:Color red.
    v addComponent:(TranslatingWrapper on:component at:10@10).

    e := EllipticalArc boundingBox:(0@0 corner:80@80)
                     startAngle:0 sweepAngle:360.
    component := StrokingWrapper on:e.
    component lineWidth:5.
    v addComponent:(TranslatingWrapper on:component at:10@10).

    e := Arrow from:0@0 to:50@150.
    component := StrokingWrapper on:e.
    component lineWidth:2.
    v addComponent:(TranslatingWrapper on:component at:100@100).

    v addComponent:(TranslatingWrapper on:(Image fromFile:'SBrowser.xbm') at:0@100).

    t open
                                                                        [exEnd]
  overlapping
                                                                        [exBegin]
    |t s v e component|

    t := StandardSystemView extent:250@200.
    s := HVScrollableView for:View miniScroller:true in:t.
    s origin:0.0@0.0 corner:1.0@1.0.
    v := s scrolledView.

    e := Rectangle origin:0@0 corner:80@80.
    component := FillingWrapper on:e.
    component foregroundColor:Color red.
    v addComponent:(TranslatingWrapper on:component at:10@10).

    e := EllipticalArc boundingBox:(0@0 corner:80@80)
                     startAngle:0 sweepAngle:360.
    component := StrokingWrapper on:e.
    component lineWidth:5.
    v addComponent:(TranslatingWrapper on:component at:50@50).

    e := Arrow from:0@0 to:50@150.
    component := StrokingWrapper on:e.
    component lineWidth:2.
    v addComponent:(TranslatingWrapper on:component at:100@100).

    e := Image fromFile:'SBrowser.xbm'.
    component := FillingWrapper on:e.
    component foregroundColor:Color red; backgroundColor:Color yellow.

    v addComponent:(TranslatingWrapper on:component at:50@150).

    component := StrokingWrapper on:e.
    component foregroundColor:Color blue.

    v addComponent:(TranslatingWrapper on:component at:50@100).

    t open
                                                                        [exEnd]
"
! !

!TranslatingWrapper class methodsFor:'instance creation'!

on:aComponent at:originPoint
    "create and return a translatingWrapper, which positions
     aComponent at some originPoint"

    ^ (self on:aComponent) translation:originPoint

    "Created: 26.5.1996 / 16:07:29 / cg"
    "Modified: 26.5.1996 / 16:12:28 / cg"
! !

!TranslatingWrapper methodsFor:'accessing'!

translation
    "return the origin offset"

    ^ origin

    "Modified: 26.5.1996 / 16:06:32 / cg"
!

translation:originPoint
    "set the origin offset"

    |delta|

    delta := originPoint - origin.
    origin := originPoint.
    frame := frame origin + origin extent:frame extent.
    component bounds:(component bounds + delta).

    "Created: 26.5.1996 / 16:07:47 / cg"
    "Modified: 5.6.1996 / 02:37:27 / cg"
! !

!TranslatingWrapper methodsFor:'accessing - bounds'!

bounds:newBounds
    frame := newBounds.
    origin = 0 ifTrue:[
        component bounds:newBounds
    ] ifFalse:[
        component bounds:(newBounds origin - origin extent:(newBounds extent)).
    ]

    "Created: 26.5.1996 / 16:44:16 / cg"
    "Modified: 5.6.1996 / 00:51:10 / cg"
!

preferredBounds
    ^ component preferredBounds + origin

    "Modified: 26.5.1996 / 16:44:26 / cg"
    "Created: 26.5.1996 / 16:44:53 / cg"
! !

!TranslatingWrapper methodsFor:'displaying'!

displayOn:aGC
    |oldTranslation|

    oldTranslation := aGC translation.
    aGC translateBy:origin.
    component displayOn:aGC.
    aGC translation:oldTranslation.

    "Created: 26.5.1996 / 15:27:54 / cg"
    "Modified: 10.2.1997 / 19:29:21 / cg"
! !

!TranslatingWrapper methodsFor:'initialization'!

initialize
   super initialize.
   origin := 0@0

    "Modified: 4.6.1996 / 21:43:44 / cg"
! !

!TranslatingWrapper methodsFor:'testing'!

containsPoint:aPoint
    ^ component containsPoint:(aPoint - origin)

    "Created: 26.5.1996 / 16:48:14 / cg"
!

intersects:aRectangle
    ^ component intersects:(aRectangle - origin)

    "Created: 26.5.1996 / 16:48:33 / cg"
! !

!TranslatingWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/TranslatingWrapper.st,v 1.8 2009-05-08 11:55:06 cg Exp $'
! !

