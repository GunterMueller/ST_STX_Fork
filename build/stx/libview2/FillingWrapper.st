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

StrokingOrFillingWrapper subclass:#FillingWrapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!FillingWrapper class methodsFor:'documentation'!

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
    a wrapper for a geometric object, which is to be drawn filled.
    This allows any geometric thingy to be used as a filled component in a view.

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
        StrokingWrapper Geometric GraphicsContext

    [author:]
        Claus Gittinger
"


!

examples
"
  wrap an ellipticArc and display it
  (notice, that no automatic redraw is performed):
                                                                        [exBegin]
    |v e component|

    v := (View extent:250@250) openAndWait.

    e := EllipticalArc boundingBox:(10@10 corner:90@90)
                        startAngle:0 
                        sweepAngle:270.
    component := FillingWrapper on:e.

    component displayOn:v.
                                                                        [exEnd]
  wrap an spline and display it
  (notice, that no automatic redraw is performed):
                                                                        [exBegin]
    |v s component|

    v := (View extent:250@250) openAndWait.

    s := Spline controlPoints:
               (Array with:(20@20)
                      with:(80@80)
                      with:(20@80)
                      with:(20@20)).
    component := FillingWrapper on:s.
    component foregroundColor:(Color green darkened).
    component displayOn:v.
                                                                        [exEnd]
  wrap ellipticArcs
  and add them as components to a View
  (notice, that doing so makes the redraw automatic):
                                                                        [exBegin]
    |v e component|

    v := View extent:250@250.

    e := EllipticalArc boundingBox:(10@10 corner:90@90)
                        startAngle:0 
                        sweepAngle:270.
    v addComponent:(StrokingWrapper on:e).

    e := EllipticalArc boundingBox:(110@110 corner:190@190)
                        startAngle:0 
                        sweepAngle:270.
    v addComponent:(FillingWrapper on:e).
    v open
                                                                        [exEnd]


  wrap a rectangle and an ellipticArc,
  and add them as components to a View
  (notice, that doing so makes the redraw automatic):
                                                                        [exBegin]
    |v e component|

    v := View new.
    v extent:250@250.

    e := Rectangle origin:10@10 corner:90@90.
    component := FillingWrapper on:e.
    component foregroundColor:Color red.

    v addComponent:component.

    e := EllipticalArc boundingBox:(10@10 corner:90@90)
                     startAngle:0 sweepAngle:270.
    component := StrokingWrapper on:e.
    component lineWidth:5.

    v addComponent:component.

    v addComponent:(Button label:'hello').

    v open
                                                                        [exEnd]

 spline as a Buttons-label (hugh ?):
                                                                        [exBegin]
    |a b|

    a := ArrowedSpline controlPoints:
               (Array with:(00@00)
                      with:(60@60)
                      with:(00@60)).

    b := Button label:(((StrokingWrapper on:a) 
                        foregroundColor:Color red;
                        lineWidth:3;
                        lineStyle:#dashed)).
    b open.
                                                                        [exEnd]
"
! !

!FillingWrapper methodsFor:'displaying'!

displayOn:aGC
    "display myself - here, display the geometric object asFilled"

    self displayFilledOn:aGC
! !

!FillingWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/FillingWrapper.st,v 1.12 2009-05-06 07:29:44 cg Exp $'
! !

