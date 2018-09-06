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

StrokingOrFillingWrapper subclass:#StrokingWrapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!StrokingWrapper class methodsFor:'documentation'!

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
    a wrapper for a geometric object, which is to be drawn stroked.
    This allows any geometric thingy to be used as a component in a view.

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
        FillingWrapper Geometric GraphicsContext

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

    v := (StandardSystemView extent:250@250) openAndWait.

    e := EllipticalArc boundingBox:(10@10 corner:90@90)
                        startAngle:0 
                        sweepAngle:270.
    component := StrokingWrapper on:e.

    component displayOn:v.
                                                                        [exEnd]

  wrap a rectangle and an ellipticArc,
  and add them as components to a View
  (notice, that doing so makes the redraw automatic):
                                                                        [exBegin]
    |v e component|

    v := StandardSystemView extent:250@250.

    e := Rectangle origin:10@10 corner:90@90.
    component := FillingWrapper on:e.
    component foregroundColor:Color red.

    v addComponent:component.

    e := EllipticalArc boundingBox:(10@10 corner:90@90)
                     startAngle:0 sweepAngle:360.
    component := StrokingWrapper on:e.
    component lineWidth:5.

    v addComponent:component.

    v addComponent:(Button label:'hello').

    v open
                                                                        [exEnd]
  with lineWidth & style:
  (notice, that the redraw is automatic):
                                                                        [exBegin]
    |v e|

    v := StandardSystemView extent:250@250.

    e := EllipticalArc boundingBox:(10@10 corner:90@90)
                        startAngle:0 
                        sweepAngle:270.
    v addComponent:((StrokingWrapper on:e)
                        lineWidth:5;
                        lineStyle:#dashed;
                        foregroundColor:(Color red)).

    e := EllipticalArc boundingBox:(30@30 corner:70@70)
                        startAngle:90 
                        sweepAngle:270.
    v addComponent:((StrokingWrapper on:e)
                        lineWidth:5;
                        lineStyle:#doubleDashed;
                        foregroundColor:(Color red);
                        backgroundColor:(Color green)).
    v open.
                                                                        [exEnd]

  scrolling:
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
    v addComponent:component.

    e := Arrow from:100@100 to:150@250.
    component := StrokingWrapper on:e.
    component lineWidth:2.
    v addComponent:component.

    v addComponent:(Button label:'hello').

    t open
                                                                        [exEnd]

"
! !

!StrokingWrapper methodsFor:'displaying'!

displayOn:aGC
    "display myself - here, display the geometric object asStroked"

    self displayStrokedOn:aGC
! !

!StrokingWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/StrokingWrapper.st,v 1.16 2009-05-06 07:29:41 cg Exp $'
! !

