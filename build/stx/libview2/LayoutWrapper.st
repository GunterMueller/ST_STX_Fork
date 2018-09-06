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

TranslatingWrapper subclass:#LayoutWrapper
	instanceVariableNames:'bounds'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!LayoutWrapper class methodsFor:'documentation'!

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
    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
"

!

examples
"
                                                                        [exBegin]
    |t view wrapper|

    t := StandardSystemView extent:200@200.

    view := View new.
    view viewBackground:Color red.

    wrapper := LayoutWrapper new.
    wrapper layout:(LayoutFrame new
                        leftFraction:0.2;
                        rightFraction:0.8;
                        topFraction:0.2;
                        bottomFraction:0.8).
    wrapper component:view.

    t addComponent:wrapper.

    t open
                                                                        [exEnd]
                                                                        [exBegin]
     |top frame1 view1 frame2 view2|

     top := StandardSystemView new.
     frame1 := LayoutWrapper new.
     frame1 layout:(0.1@0.1 corner:0.9@0.9) asLayout.
     top addSubView:frame1.

     view1 := View new.
     view1 viewBackground:Color red.
     frame1 component:view1.

     frame2 := LayoutWrapper new.
     frame2 layout:(0.1@0.1 corner:0.9@0.9) asLayout.
     view1 addSubView:frame2.

     view2 := View new.
     view2 viewBackground:Color green.
     frame2 component:view2.

     top openWithExtent:200@200
                                                                        [exEnd]
"
! !

!LayoutWrapper class methodsFor:'instance creation'!

on:aComponent in:aLayout
    "create and return a layoutWrapper, which controls
     aComponent bounds using aLayout.
     The layout argument may be:
        nil       - no constraint
        Point     - origin shift
        Rectangle - origin shift & extent
        Layout    - full control"

    ^ (self on:aComponent) layout:aLayout

    "Created: 26.5.1996 / 16:18:44 / cg"
    "Modified: 26.5.1996 / 16:34:04 / cg"
! !

!LayoutWrapper methodsFor:'accessing'!

bounds:newBounds
"/ Transcript showCR:newBounds.
    bounds := newBounds.
    self layoutChanged

    "Created: 19.7.1996 / 20:10:09 / cg"
    "Modified: 19.7.1996 / 21:20:42 / cg"
!

layout:something
    "set the layout"

    layout := something.
    self layoutChanged

    "Created: 26.5.1996 / 16:18:11 / cg"
    "Modified: 19.7.1996 / 20:15:20 / cg"
! !

!LayoutWrapper methodsFor:'private'!

layoutChanged
    |subBounds|

    component notNil ifTrue:[
        layout notNil ifTrue:[
            subBounds := (layout 
                            rectangleRelativeTo:bounds
                            preferred:bounds) rounded.
        ] ifFalse:[
            subBounds := bounds
        ].

        origin := subBounds origin.
"/ Transcript show:layout displayString; show:'subbounds: '; showCR:subBounds.
        component bounds:subBounds.
    ]

    "Created: 19.7.1996 / 20:15:05 / cg"
    "Modified: 19.7.1996 / 21:20:46 / cg"
! !

!LayoutWrapper methodsFor:'queries'!

isLayoutWrapper
     ^ true

    "Created: 19.7.1996 / 17:51:16 / cg"
!

preferredBounds
    |b w h lw lh|

    bounds := component preferredBounds.
    layout isNil ifTrue:[^ bounds].

    w := bounds width.
    h := bounds height.

    "/ now, inverse apply the layouts values

    lw := layout rightFraction - layout leftFraction.
    lw ~~ 0 ifTrue:[
        lw := w * (1 / lw)
    ].
    lh := layout bottomFraction - layout topFraction.
    lh ~~ 0 ifTrue:[
        lh := h * (1 / lh)
    ].
    lw := lw + layout rightOffset - layout leftOffset.
    lh := lh + layout bottomOffset - layout topOffset.

    ^ 0@0 corner:(lw rounded @ lh rounded)

    "Created: 19.7.1996 / 17:51:16 / cg"
    "Modified: 19.7.1996 / 20:08:51 / cg"
! !

!LayoutWrapper methodsFor:'view protocol mimicri'!

computeOrigin
    "return my origin"

    ^ 0@0

    "Created: 19.7.1996 / 20:05:37 / cg"
!

origin:org corner:corn
    |newLayout l r t b lF rF tF bF lO rO tO bO|

    newLayout := LayoutFrame new.
    l := org x.
    l isInteger ifTrue:[
        lO := l.
        lF := 0.0
    ] ifFalse:[
        lO := 0.
        lF := l
    ].
    r := corn x.
    r isInteger ifTrue:[
        rO := r.
        rF := 0.0
    ] ifFalse:[
        rO := 0.
        rF := r
    ].
    t := org y.
    t isInteger ifTrue:[
        tO := t.
        tF := 0.0
    ] ifFalse:[
        tO := 0.
        tF := t
    ].
    b := corn y.
    b isInteger ifTrue:[
        bO := b.
        bF := 0.0
    ] ifFalse:[
        bO := 0.
        bF := b
    ].

    newLayout
        leftFraction:lF offset:lO;
        rightFraction:rF offset:rO;
        topFraction:tF offset:tO;
        bottomFraction:bF offset:bO.

    self layout:newLayout

    "Modified: 19.7.1996 / 21:22:11 / cg"
! !

!LayoutWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/LayoutWrapper.st,v 1.7 2009-11-24 18:21:01 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/LayoutWrapper.st,v 1.7 2009-11-24 18:21:01 stefan Exp $'
! !

