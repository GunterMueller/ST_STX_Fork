"
 COPYRIGHT (c) 2009 by Claus Gittinger
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

GeometricWrapper subclass:#StrokingOrFillingWrapper
	instanceVariableNames:'lineWidth lineStyle capStyle joinStyle fill'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!StrokingOrFillingWrapper class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by Claus Gittinger
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
    combines stroking and fillingwrapper into one.

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

!StrokingOrFillingWrapper methodsFor:'accessing'!

bounds
    "return the boundary rectangle - here, must take care of the lineWidth"

    ^ (component bounds insetBy:(lineWidth // 2 + 1) negated) rounded

    "Created: 8.5.1996 / 23:22:43 / cg"
    "Modified: 5.6.1996 / 20:30:39 / cg"
!

capStyle
    "return the capStyle"

    ^ capStyle

    "Created: 8.5.1996 / 23:22:04 / cg"
    "Modified: 9.5.1996 / 00:09:12 / cg"
!

capStyle:aSymbol
    "set the capStyle"

    capStyle := aSymbol

    "Created: 8.5.1996 / 23:22:13 / cg"
    "Modified: 9.5.1996 / 00:09:17 / cg"
!

joinStyle
    "return the joinStyle"

    ^ joinStyle

    "Created: 8.5.1996 / 23:22:04 / cg"
    "Modified: 9.5.1996 / 00:09:12 / cg"
!

joinStyle:aSymbol
    "set the joinStyle"

    joinStyle := aSymbol

    "Created: 8.5.1996 / 23:22:13 / cg"
    "Modified: 9.5.1996 / 00:09:17 / cg"
!

lineStyle
    "return the lineStyle"

    ^ lineStyle

    "Created: 8.5.1996 / 23:22:04 / cg"
    "Modified: 9.5.1996 / 00:09:12 / cg"
!

lineStyle:aSymbol
    "set the lineStyle"

    lineStyle := aSymbol

    "Created: 8.5.1996 / 23:22:13 / cg"
    "Modified: 9.5.1996 / 00:09:17 / cg"
!

lineWidth
    "return the lineWidth"

    ^ lineWidth

    "Created: 8.5.1996 / 23:22:04 / cg"
    "Modified: 9.5.1996 / 00:09:12 / cg"
!

lineWidth:aNumber
    "set the lineWidth"

    lineWidth := aNumber

    "Created: 8.5.1996 / 23:22:13 / cg"
    "Modified: 9.5.1996 / 00:09:17 / cg"
!

preferredBounds
    "return the components bounds as preferredBounds"

    ^ (component bounds insetBy:(lineWidth / 2 + 1) negated) rounded

    "Created: 8.5.1996 / 23:23:00 / cg"
    "Modified: 5.6.1996 / 20:32:36 / cg"
! !

!StrokingOrFillingWrapper methodsFor:'displaying'!

displayFilledOn:aGC
    "display myself - here, display the geometric object asFilled"

    |prevFg prevBg|

    prevFg := aGC paint.
    prevBg := aGC backgroundPaint.

    aGC paint:foregroundColor on:backgroundColor.

    component displayFilledOn:aGC.

    aGC paint:prevFg on:prevBg.

    "Created: 8.5.1996 / 23:54:06 / cg"
    "Modified: 10.2.1997 / 14:21:41 / cg"
!

displayOn:aGC
    "display myself - here, display the geometric object asStroked"

    fill ifTrue:[
        self displayFilledOn:aGC
    ] ifFalse:[
        self displayStrokedOn:aGC
    ]
!

displayStrokedOn:aGC
    "display myself - here, display the geometric object asStroked or asFilled"

    |prevLineWidth prevLineStyle prevCapStyle prevJoinStyle 
     prevFg prevBg|

    prevLineWidth := aGC lineWidth.
    prevLineStyle := aGC lineStyle.
    prevJoinStyle := aGC joinStyle.
    prevCapStyle  := aGC capStyle.
    prevFg := aGC paint.
    prevBg := aGC backgroundPaint.

    aGC lineWidth:lineWidth.
    aGC lineStyle:lineStyle.
    aGC joinStyle:joinStyle.
    aGC capStyle:capStyle.
    aGC paint:foregroundColor on:backgroundColor.

    component displayStrokedOn:aGC.

    aGC lineWidth:prevLineWidth.
    aGC lineStyle:prevLineStyle.
    aGC joinStyle:prevJoinStyle.
    aGC capStyle:prevCapStyle.
    aGC paint:prevFg on:prevBg.

    "Created: 8.5.1996 / 23:24:04 / cg"
    "Modified: 10.2.1997 / 14:21:33 / cg"
! !

!StrokingOrFillingWrapper methodsFor:'initialization'!

initialize
    "default my lineWidth to one pixel"

    super initialize.
    lineWidth := 1.

    "Created: 8.5.1996 / 23:49:27 / cg"
    "Modified: 9.5.1996 / 00:11:51 / cg"
! !

!StrokingOrFillingWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/StrokingOrFillingWrapper.st,v 1.1 2009-05-06 07:29:31 cg Exp $'
! !

