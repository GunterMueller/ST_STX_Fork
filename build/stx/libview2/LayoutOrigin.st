"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Layout subclass:#LayoutOrigin
	instanceVariableNames:'leftFraction topFraction leftOffset topOffset'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry'
!

!LayoutOrigin class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    This class is provided to make porting of existing ST-80 applications
    easier. Instances can be used to control the geometry of a subview, within
    its superview. It provides the same functionality as a relative origin
    combined with insets.
    A layoutOrigin controls the origin of a subcomponent, given a fractional
    component and an offset component.

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger

    [see also:]
        View
        LayoutFrame AlignmentOrigin Layout 
        Rectangle Point
"
!

examples
"
    Although the examples below use a button as component,
    they work of course with any type of subview ....

    using a LayoutOrigin, to arrange for
    the TOPLEFT of a component be positions
    at the center (i.e. buttons origin at:0.5 @ 0.5):
                                                                        [exBegin]
        |top button|

        top := StandardSystemView new.
        top extent:300@300.

        button := Button label:'component'.
        top add:button in:(LayoutOrigin new
                                leftFraction:0.5;
                                topFraction:0.5).

        top open
                                                                        [exEnd]


    like above, but adds an additional offset:
    (i.e. center of button at:0.5 @ 0.5 OFFSET by 10 @ 20):
                                                                        [exBegin]
        |top button|

        top := StandardSystemView new.
        top extent:300@300.

        button := Button label:'component'.
        top add:button in:(LayoutOrigin new
                                leftFraction:0.5;
                                topFraction:0.5;
                                leftOffset:10;
                                topOffset:20).

        top open
                                                                        [exEnd]
"
! !

!LayoutOrigin class methodsFor:'instance creation'!

fractionalFromPoint:aPoint
    "given a point, create a layoutOrigin representing the same 
     relative origin."

    ^ (self new) leftFraction:aPoint x topFraction:aPoint y

    "
     LayoutOrigin fractionalFromPoint:0.5@0.5
    "
!

fromPoint:aPoint
    "return a new LayoutOrigin from aPoint.
     If the coordinates are between 0 and 1, 
     take them as fractional parts (relative to superview).
     Otherwise, treat them as absolute offsets."

    |x y layout|

    x := aPoint x.
    y := aPoint y.
    layout := self new.
    ((x between:0 and:1)
    and:[y between:0 and:1]) ifTrue:[
        layout leftFraction:x topFraction:y
    ] ifFalse:[
        layout leftOffset:x topOffset:y
    ].
    ^ layout

    "
     LayoutOrigin fromPoint:100@100
     LayoutOrigin fromPoint:0.5@0.5
     LayoutOrigin fromPoint:0.5@100
    "
!

offsetFromPoint:aPoint
    "given a point, create a layoutOrigin representing the same 
     absolute (pixel) origin."

    ^ self new leftOffset:aPoint x topOffset:aPoint y

    "
     LayoutOrigin offsetFromPoint:100@100
    "
! !

!LayoutOrigin methodsFor:'accessing'!

leftFraction
    "return leftFraction"

    ^ leftFraction
!

leftFraction:something
    "set leftFraction"

    leftFraction := something.
!

leftFraction:something offset:o
    "set leftFraction and offset"

    leftFraction := something.
    leftOffset := o
!

leftFraction:lF offset:lO topFraction:tF offset:tO 
    "set leftFraction, leftOffset, topFraction and topOffset"

    leftFraction := lF. leftOffset := lO.
    topFraction := tF. topOffset := tO.

    "Created: 18.4.1997 / 20:07:15 / cg"
!

leftFraction:newLeft topFraction:newTop 
    "set leftFraction and topFraction"

    leftFraction := newLeft.
    topFraction := newTop.
!

leftInset:pixels
    "set leftOffset for an inset at the left"

    leftOffset := pixels.

    "Created: 26.5.1996 / 17:38:55 / cg"
    "Modified: 26.5.1996 / 17:42:16 / cg"
!

leftOffset
    "return leftOffset"

    ^ leftOffset
!

leftOffset:something
    "set leftOffset"

    leftOffset := something.
!

leftOffset:newLeft topOffset:newTop 
    "set leftOffset and topOffset"

    leftOffset := newLeft.
    topOffset := newTop.
!

topFraction
    "return topFraction"

    ^ topFraction
!

topFraction:something
    "set topFraction"

    topFraction := something.
!

topFraction:something offset:o
    "set topFraction and offset"

    topFraction := something.
    topOffset := o
!

topInset:pixels
    "set topOffset for an inset at the top"

    topOffset := pixels.

    "Created: 26.5.1996 / 17:39:00 / cg"
    "Modified: 26.5.1996 / 17:42:12 / cg"
!

topOffset
    "return topOffset"

    ^ topOffset
!

topOffset:something
    "set topOffset"

    topOffset := something.
! !

!LayoutOrigin methodsFor:'comparing'!

= anObject
    ^ anObject class == self class
        and:[ anObject leftFraction = leftFraction
        and:[ anObject topFraction = topFraction
        and:[ anObject leftOffset = leftOffset
        and:[ anObject topOffset = topOffset ]]]]
!

hash
    ^ leftFraction hash + topFraction hash + leftOffset hash + topOffset hash
! !

!LayoutOrigin methodsFor:'converting'!

asAlignmentOrigin
    "return an equivalent alignmentOrigin"

    ^ AlignmentOrigin new
        leftFraction:leftFraction offset:leftOffset;
        topFraction:topFraction offset:topOffset;
        leftAlignmentFraction:0 topAlignmentFraction: 0;
        yourself

    "Created: 18.4.1997 / 20:08:14 / cg"
!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be of the form: 
	(#LayoutOrigin orgOffsX relOrgX orgOffsY relOrgY)
     This is the reverse operation to #literalArrayEncoding."

    leftOffset := encoding at:2.
    leftFraction := encoding at:3.
    topOffset := encoding at:4.
    topFraction := encoding at:5.


    "
      LayoutOrigin new fromLiteralArrayEncoding:#(#LayoutOrigin 70 0 2 0)
    "
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is: 
        (#LayoutOrigin orgOffsX relOrgX orgOffsY relOrgY)
    "

    ^ Array
        with:self class name
        with:leftOffset
        with:leftFraction
        with:topOffset
        with:topFraction

    "
      LayoutOrigin new fromLiteralArrayEncoding:#(#LayoutOrigin 70 0 2 0)
      (LayoutOrigin new leftOffset:10; leftFraction:0.2;
                       topOffset:20; topFraction:0.4) literalArrayEncoding 
    "

    "Modified: 1.9.1995 / 02:43:48 / claus"
    "Modified: 22.4.1996 / 13:00:21 / cg"
! !

!LayoutOrigin methodsFor:'initialization'!

initialize
    leftOffset := topOffset := 0.
    leftFraction := topFraction := 0.
! !

!LayoutOrigin methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a printed representation of the receiver for displaying"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPutAll:'(l: '.

    leftFraction displayOn:aGCOrStream.
    aGCOrStream nextPut:$+. 
    leftOffset displayOn:aGCOrStream.
    aGCOrStream nextPutAll:' t: '.
    topFraction displayOn:aGCOrStream.
    aGCOrStream nextPut:$+. 
    topOffset displayOn:aGCOrStream.
    aGCOrStream nextPut:$). 
! !

!LayoutOrigin methodsFor:'queries'!

isLayoutOrigin
    "return true, if this is a layoutOrigin"

    ^ true

!

origin
    ^ leftFraction asFloat @ topFraction asFloat
!

rectangleRelativeTo:superRectangle preferred:prefRectHolder
    "compute the rectangle represented by the receiver,
     given the superViews rectangle and the view's preferredExtent."

    |x y prefRect|

    prefRect := prefRectHolder value.

    x := superRectangle left.
    y := superRectangle top.

    leftOffset notNil ifTrue:[
        x := x + leftOffset value
    ].
    topOffset notNil ifTrue:[
        y := y + topOffset value
    ].
    leftFraction notNil ifTrue:[
        x := x + (superRectangle width * leftFraction value)
    ].
    topFraction notNil ifTrue:[
        y := y + (superRectangle height * topFraction value)
    ].
    ^ Rectangle left:x top:y extent:prefRect extent

    "
     |superRect lO|

     superRect := 0@0 corner:100@100.
     lO := (LayoutOrigin new).
     lO leftFraction:0.5;
        topFraction:0.5.
     lO rectangleRelativeTo:superRect preferred:(0@0 corner:30@30)
    "

    "Modified: / 13.8.1998 / 18:39:49 / cg"
! !

!LayoutOrigin class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

