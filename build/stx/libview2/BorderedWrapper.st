"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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

BoundedWrapper subclass:#BorderedWrapper
	instanceVariableNames:'border inset insideColor borderWidth borderColor level'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!BorderedWrapper class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    a wrapper which controls the layout (origin & extent)
    of its wrapped component and also draws a border around.

    If insideColor is nonNil, the area is cleared to that color,
    making the overall look be opaque.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [see also:]
        Wrapper TranslatingWrapper GeometricWrapper

    [author:]
        Claus Gittinger
"

!

examples
"
  a 'no-border' border
                                                                        [exBegin]
    |t component|

    t := StandardSystemView extent:250@250.

    component := ClockView new.

    t addComponent:((BorderedWrapper 
                        on:component in:(0.1@0.1 corner:0.9@0.9)
                    )
                   ).

    t open
                                                                        [exEnd]

  a '2D' border
                                                                        [exBegin]
    |t component|

    t := StandardSystemView extent:250@250.

    component := ClockView new.

    t addComponent:((BorderedWrapper 
                        on:component in:(0.1@0.1 corner:0.9@0.9))
                            borderColor:Color red;
                            borderWidth:2).

    t open
                                                                        [exEnd]

  a '3D' border
                                                                        [exBegin]
    |t component|

    t := StandardSystemView extent:250@250.

    component := ClockView new.

    t addComponent:((BorderedWrapper 
                        on:component in:(0.1@0.1 corner:0.9@0.9))
                            level:2).

    t open
                                                                        [exEnd]

  multiple components (absolute & relative sizes):
                                                                        [exBegin]
    |t component|

    t := StandardSystemView extent:250@250.

    component := ClockView new.
    t addComponent:((BorderedWrapper 
                        on:component in:(10@10 corner:100@100))
                            borderWidth:1; borderColor:Color blue).

    component := ClockView new.
    t addComponent:((BorderedWrapper 
                        on:component in:(0.5@0.5 corner:1.0@1.0))
                            borderWidth:1; borderColor:Color red).


    t openAndWait.
                                                                        [exEnd]

  multiple components (absolute & relative layouts):
                                                                        [exBegin]
    |t component|

    t := StandardSystemView extent:250@250.

    component := ClockView new.
    component borderWidth:1; borderColor:Color blue.
    component layout:((10@10 corner:100@100) asLayout).
    t addComponent:component.

    component := ClockView new.
    component borderWidth:1; borderColor:Color red.
    component layout:((0.5@0.5 corner:1.0@1.0) asLayout).
    t addComponent:component.

    t openAndWait.
                                                                        [exEnd]

  non-view components (scrollable, both with & without insideColor):
                                                                        [exBegin]
    |t s v e component|

    t := StandardSystemView extent:250@200.
    s := HVScrollableView for:View miniScroller:true in:t.
    s origin:0.0@0.0 corner:1.0@1.0.
    v := s scrolledView.

    e := Rectangle origin:0@0 corner:80@80.
    component := FillingWrapper on:e.
    component foregroundColor:Color red.
    v addComponent:((BorderedWrapper on:component at:10@10)
                        borderWidth:3; borderColor:Color green darkened).

    e := EllipticalArc boundingBox:(0@0 corner:80@80)
                     startAngle:0 sweepAngle:360.
    component := StrokingWrapper on:e.
    component lineWidth:5; foregroundColor:Color yellow.
    v addComponent:((BorderedWrapper on:component at:50@50)
                        insideColor:Color blue;
                        level:1).

    e := Arrow from:0@0 to:50@150.
    component := StrokingWrapper on:e.
    component lineWidth:2.
    v addComponent:((BorderedWrapper on:component at:100@100) level:2).

    t open
                                                                        [exEnd]
"
! !

!BorderedWrapper class methodsFor:'instance creation'!

on:aComponent in:aLayout border:aBorder
    ^ (super on:aComponent in:aLayout) border:aBorder

    "Created: 28.5.1996 / 23:15:00 / cg"
!

on:aComponent in:aLayout level:threeDLevel
    ^ (super on:aComponent in:aLayout) level:threeDLevel

    "Created: 25.1.1997 / 16:56:51 / cg"
! !

!BorderedWrapper methodsFor:'accessing'!

border
    "return border"

    ^ border

    "Created: 28.5.1996 / 23:15:15 / cg"
!

border:something
    "set border"

    border := something.

    "Created: 28.5.1996 / 23:15:15 / cg"
!

borderColor:aColor
    "set the 2D borderColor"

    |v|

    borderColor := aColor.
    (v := self view) notNil ifTrue:[v invalidate]

    "Modified: 5.6.1996 / 01:20:37 / cg"
    "Created: 5.6.1996 / 01:34:17 / cg"
!

borderWidth
    "return the 2D borderWidth"

    ^ borderWidth

    "Modified: 5.6.1996 / 01:52:41 / cg"
    "Created: 5.6.1996 / 14:27:28 / cg"
!

borderWidth:aNumber
    "set the 2D borderWidth"

    |v|

    borderWidth ~~ aNumber ifTrue:[
        borderWidth := aNumber.
        bounds notNil ifTrue:[self bounds:bounds].
        (v := self view) notNil ifTrue:[v invalidate]
    ]

    "Created: 5.6.1996 / 01:33:56 / cg"
    "Modified: 5.6.1996 / 01:52:41 / cg"
!

inset
    |i|

    borderWidth notNil ifTrue:[
        i := borderWidth
    ] ifFalse:[
        i := 0
    ].
    level notNil ifTrue:[
        i := i + level abs.
    ].
    ^ i

    "Created: 5.6.1996 / 01:03:25 / cg"
    "Modified: 5.6.1996 / 01:03:47 / cg"
!

insideColor
    "return the insideColor"

    ^ insideColor

    "Created: 29.5.1996 / 11:09:58 / cg"
!

insideColor:aColorOrPixmap
    "set the insideColor"

    insideColor := aColorOrPixmap

    "Created: 29.5.1996 / 11:10:16 / cg"
!

level
    "return the 3D level"

    ^ level

    "Created: 5.6.1996 / 14:27:47 / cg"
!

level:aNumber
    "set the 3D level"

    |v|

    level ~~ aNumber ifTrue:[
        level := aNumber.
        bounds notNil ifTrue:[self bounds:bounds].
        (v := self view) notNil ifTrue:[v invalidate]
    ]

    "Created: 5.6.1996 / 01:19:41 / cg"
    "Modified: 5.6.1996 / 01:53:00 / cg"
! !

!BorderedWrapper methodsFor:'displaying'!

displayOn:aGC
    |bounds x y w h r b tX tY bw|

    bounds := self bounds.

    x := bounds left rounded.
    y := bounds top rounded.
    r := bounds right rounded.
    b := bounds bottom rounded.

    insideColor notNil ifTrue:[
        aGC paint:insideColor.
        aGC fillRectangleX:x y:y width:(r-x) height:(b-y)
    ].

    super displayOn:aGC.

    bw := 0.
    borderColor notNil ifTrue:[
        (borderWidth notNil
        and:[borderWidth ~~ 0]) ifTrue:[
            bw := borderWidth.
            aGC paint:borderColor.
            0 to:(borderWidth-1) do:[:i |
                aGC displayRectangleX:x+i y:y+i width:(r-x-i-i) height:(b-y-i-i).
            ].
        ]
    ].

    level notNil ifTrue:[
        "/ drawEdgesForX: draws in deviceCoordinates - have to translate here.

        tX := aGC translation x.
        tY := aGC translation y.

        aGC drawEdgesForX:x+tX+bw
                        y:y+tY+bw
                    width:(r-x+1-bw-bw)
                   height:(b-y+1-bw-bw)
                    level:level 
                   shadow:Color black 
                    light:Color white
               halfShadow:Color grey 
                halfLight:Color grey
                    style:#iris
    ].

    "Modified: 27.1.1997 / 11:45:28 / cg"
! !

!BorderedWrapper methodsFor:'initialization'!

initialize
    super initialize.

    inset := 0.
    insideColor := Color white.
    borderWidth := 0.
    insideColor := Color black.
    level := 0.

    "Created: 19.7.1996 / 17:22:33 / cg"
! !

!BorderedWrapper methodsFor:'private'!

layoutChanged
    |subBounds b|

    component notNil ifTrue:[
        b := bounds insetBy:self inset.
        
        layout notNil ifTrue:[
            subBounds := (layout 
                            rectangleRelativeTo:b
                            preferred:b) rounded.
        ] ifFalse:[
            subBounds := b
        ].

        origin := b origin.
"/ Transcript show:layout displayString; show:'subbounds: '; showCR:subBounds.
        component bounds:subBounds.
    ]

    "Created: 19.7.1996 / 21:25:02 / cg"
! !

!BorderedWrapper methodsFor:'queries'!

hasBorder
     ^ true

    "Created: 5.6.1996 / 14:28:38 / cg"
!

isBorderedWrapper
     ^ true

    "Created: 5.6.1996 / 14:11:03 / cg"
! !

!BorderedWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/BorderedWrapper.st,v 1.10 2003-08-18 12:13:55 cg Exp $'
! !

