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

LayoutOrigin subclass:#LayoutFrame
	instanceVariableNames:'rightFraction bottomFraction rightOffset bottomOffset'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry'
!

!LayoutFrame class methodsFor:'documentation'!

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
    This class is provided to make porting of existing ST-80/Squeak applications
    easier. Instances can be used to control the geometry of a subview, within
    its superview. Like a layoutOrigin, it controls the origin of a component
    by given fraction and offset dimensions; in addition, the bottom-right
    corner is also controlled by corresponding values. Therefore, the components
    preferredExtent is ignored.

    See also:
        LayoutOrigin AlignmentOrigin Layout

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
        LayoutOrigin AlignmentOrigin Layout 
        Rectangle Point
"
!

examples
"
    Although the examples below use a button as component,
    they work of course with any type of subview ....


    arrange for the button to be in 0.25 @ 0.25 -> 0.75 @ 0.75.
    This is the same as with relative origin/corner.
                                                                        [exBegin]
        |top button|

        top := StandardSystemView new.
        top extent:300@300.

        button := Button label:'component'.
        top add:button in:(LayoutFrame new
                                leftFraction:0.25;
                                topFraction:0.25;
                                rightFraction:0.75;
                                bottomFraction:0.75).

        top open
                                                                        [exEnd]


    like above, but adds additional offset to the origin:
    This is the same as with relative origin/corner
    and setting left & right insets.
                                                                        [exBegin]
        |top button|

        top := StandardSystemView new.
        top extent:300@300.

        button := Button label:'component'.
        top add:button in:(LayoutFrame new
                                leftFraction:0.25; leftOffset:10;
                                topFraction:0.25;  topOffset:-20;
                                rightFraction:0.75;
                                bottomFraction:0.75).

        top open
                                                                        [exEnd]


    like above, with offsets on all edges, 
    actually simulating a constant inset on all four edges:
                                                                        [exBegin]
        |top button|

        top := StandardSystemView new.
        top extent:300@300.

        button := Button label:'component'.
        top add:button in:(LayoutFrame new
                                leftFraction:0.0; leftOffset:10;
                                topFraction:0.0;  topOffset:10;
                                rightFraction:1.0; rightOffset:-10;
                                bottomFraction:1.0; bottomOffset:-10).

        top open
                                                                        [exEnd]
"
! !

!LayoutFrame class methodsFor:'instance creation'!

bottomFrame:pixels
    "create a new layoutFrame which makes the child take a fixed frame at the bottom"

    ^ self
        leftFraction:0 offset:0
        rightFraction:1 offset:0
        topFraction:1 offset:pixels negated 
        bottomFraction:1 offset:0
!

bottomInset:pixels
    "create a new layoutFrame which insets the child at the bottom by some pixels"

    ^ self
        leftFraction:0 offset:0
        rightFraction:1 offset:0
        topFraction:0 offset:0 
        bottomFraction:1 offset:pixels negated

    "Created: / 26-04-2010 / 15:07:50 / cg"
!

fractions:fractionRectangle offsets:offsetRectangle
    "create a new layoutFrame given a rectangle of fractions and a rectangle of offsets"

    ^ self new
        fractions:fractionRectangle offsets:offsetRectangle

    "
     LayoutFrame 
        fractions:(0 @ 0 corner:1.0 @ 1.0) 
        offsets:(0 @ 0 corner:0 @ 0)
    "
!

inset:pixels
    "create a new layoutFrame which insets the child by some pixels"

    ^ self
        leftFraction:0 offset:pixels
        rightFraction:1 offset:pixels negated
        topFraction:0 offset:pixels 
        bottomFraction:1 offset:pixels negated 
!

leftFraction:lF offset:lO rightFraction:rF offset:rO topFraction:tF offset:tO bottomFraction:bF offset:bO
    "create a new layoutFrame"

    ^ self new
        leftFraction:lF offset:lO 
        rightFraction:rF offset:rO 
        topFraction:tF offset:tO 
        bottomFraction:bF offset:bO



!

leftFraction:lF rightFraction:rF topFraction:tF bottomFraction:bF
    "create a new layoutFrame"

    ^ self new
        leftFraction:lF offset:0 
        rightFraction:rF offset:0 
        topFraction:tF offset:0 
        bottomFraction:bF offset:0
!

leftFrame:pixels
    "create a new layoutFrame which makes the child take a fixed frame at the left"

    ^ self
        leftFraction:0 offset:0
        rightFraction:0 offset:pixels
        topFraction:0 offset:0 
        bottomFraction:1 offset:0
!

leftOffset:lO rightOffset:rO topOffset:tO bottomOffset:bO
    "create a new layoutFrame"

    ^ self new
        leftOffset:lO 
        rightOffset:rO 
        topOffset:tO 
        bottomOffset:bO

    "Created: 18.4.1997 / 20:14:44 / cg"
!

leftOffset:lO topOffset:tO rightOffset:rO bottomOffset:bO
    "create a new layoutFrame"

    ^ self leftOffset:lO rightOffset:rO topOffset:tO bottomOffset:bO

    "Modified: 18.4.1997 / 20:15:23 / cg"
!

origin:origin corner:corner
    "create a new layoutFrame from an oldStyle origin-corner rectangle.
     Added to make migration from Rectangles to LayoutFrames easier."

    |leftFraction leftOffset rightFraction rightOffset
     topFraction topOffset bottomFraction bottomOffset
     orgX orgY cornerX cornerY|

    orgX := origin x.
    orgY := origin y.
    cornerX := corner x.
    cornerY := corner y.
    leftFraction := leftOffset := 0.
    orgX isInteger ifTrue:[
        leftOffset := orgX
    ] ifFalse:[
        leftFraction := orgX.
    ].
    orgY isInteger ifTrue:[
        topOffset := orgY
    ] ifFalse:[
        topFraction := orgY.
    ].
    cornerX isInteger ifTrue:[
        rightOffset := cornerX
    ] ifFalse:[
        rightFraction := cornerX.
    ].
    cornerY isInteger ifTrue:[
        bottomOffset := cornerY
    ] ifFalse:[
        bottomFraction := cornerY.
    ].
    ^ self
        leftFraction:leftFraction offset:leftOffset
        rightFraction:rightFraction offset:rightOffset
        topFraction:topFraction offset:rightOffset 
        bottomFraction:bottomFraction offset:bottomOffset 
!

rightFrame:pixels
    "create a new layoutFrame which makes the child take a fixed frame at the right"

    ^ self
        leftFraction:1 offset:pixels negated
        rightFraction:1 offset:0
        topFraction:0 offset:0 
        bottomFraction:1 offset:0
!

topFrame:pixels
    "create a new layoutFrame which makes the child take a fixed frame at the top"

    ^ self
        leftFraction:0 offset:0
        rightFraction:1 offset:0
        topFraction:0 offset:0 
        bottomFraction:0 offset:pixels
!

topInset:pixels
    "create a new layoutFrame which insets the child at the top by some pixels"

    ^ self
        leftFraction:0 offset:0
        rightFraction:1 offset:0
        topFraction:0 offset:pixels 
        bottomFraction:1 offset:0
! !

!LayoutFrame methodsFor:'accessing'!

bottomFraction
    "Return the y-coordinate of the bottom of the relative rectangle as a percentage of the height of the reference rectangle."

    ^ bottomFraction
!

bottomFraction:something
    "Set the y-coordinate of the bottom of the relative rectangle to be a fraction of the height of the reference rectangle."

    bottomFraction := something.
!

bottomFraction:something offset:o
    "set both bottomFraction and offset"

    bottomFraction := something.
    bottomOffset := o
!

bottomInset:pixels
    "set bottomOffset for an inset at the bottom"

    bottomOffset := pixels negated.

    "Created: 26.5.1996 / 17:38:30 / cg"
!

bottomOffset
    "return bottomOffset"

    ^ bottomOffset
!

bottomOffset:something
    "set bottomOffset"

    bottomOffset := something.
!

fractions:fractionRectangle offsets:offsetRectangle
    "LayoutFrame fractions:(0 @ 0 corner:1.0 @ 1.0) offsets:(0 @ 0 corner:0 @ 0)"

    self
        leftFraction:(fractionRectangle left) offset:(offsetRectangle left)
        rightFraction:(fractionRectangle right) offset:(offsetRectangle right)
        topFraction:(fractionRectangle top) offset:(offsetRectangle top)
        bottomFraction:(fractionRectangle bottom) offset:(offsetRectangle bottom)
!

horizontalInset:aNumber
    "setup the offsets for insetting horizontally the frame aNumber pixels at all sides"

    leftOffset := aNumber.
    rightOffset := aNumber negated.

    "Created: 26.5.1996 / 17:39:35 / cg"
!

inset:aNumber
    "setup the offsets for insetting the frame aNumber pixels at all sides"

    topOffset := leftOffset := aNumber.
    rightOffset := bottomOffset := aNumber negated.

    "Created: 26.5.1996 / 17:36:49 / cg"
!

leftFraction:lF offset:lO rightFraction:rF offset:rO topFraction:tF offset:tO bottomFraction:bF offset:bO
    "set all fields"

    leftFraction := lF.
    rightFraction := rF.
    topFraction := tF.
    bottomFraction := bF.
    leftOffset := lO.
    rightOffset := rO.
    topOffset := tO.
    bottomOffset := bO.

!

leftOffset:lO rightOffset:rO
    "set the horizontal offset fields"

    leftOffset := lO.
    rightOffset := rO.
!

leftOffset:lO rightOffset:rO topOffset:tO bottomOffset:bO
    "set all offset fields"

    leftOffset := lO.
    rightOffset := rO.
    topOffset := tO.
    bottomOffset := bO.

    "Created: 18.4.1997 / 20:16:08 / cg"
!

rightFraction
    "return rightFraction"

    ^ rightFraction
!

rightFraction:something
    "set rightFraction"

    rightFraction := something.
!

rightFraction:something offset:o
    "set rightFraction and offset"

    rightFraction := something.
    rightOffset := o
!

rightInset:pixels
    "set rightOffset for an inset at the right"

    rightOffset := pixels negated.

    "Created: 26.5.1996 / 17:38:38 / cg"
!

rightOffset
    "return rightOffset"

    ^ rightOffset
!

rightOffset:something
    "set rightOffset"

    rightOffset := something.
!

topOffset:newTopOffset bottomOffset:newBottomOffset
    topOffset := newTopOffset.
    bottomOffset := newBottomOffset.
!

verticalInset:aNumber
    "setup the offsets for insetting vertically the frame aNumber pixels
     at all sides"

    topOffset := aNumber.
    bottomOffset := aNumber negated.

    "Created: 26.5.1996 / 17:39:50 / cg"
! !

!LayoutFrame methodsFor:'comparing'!

= anObject
    ^ super = anObject
        and:[ anObject rightFraction = rightFraction
        and:[ anObject bottomFraction = bottomFraction
        and:[ anObject rightOffset = rightOffset
        and:[ anObject bottomOffset = bottomOffset ]]]]
!

hash
    ^ super hash
      + rightFraction hash + bottomFraction hash + rightOffset hash + bottomOffset hash
! !

!LayoutFrame methodsFor:'converting'!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be of the form: 
	(LayoutFrame orgOffsX relOrgX orgOffsY relOrgY cornOffsX relCornX cornOffsY relCornY)
     This is the reverse to literalArrayEncoding."

    leftOffset := encoding at:2.
    leftFraction := encoding at:3.
    topOffset := encoding at:4.
    topFraction := encoding at:5.
    rightOffset := encoding at:6.
    rightFraction := encoding at:7.
    bottomOffset := encoding at:8.
    bottomFraction := encoding at:9.

    "
      LayoutFrame new fromLiteralArrayEncoding:#(#LayoutFrame 70 0 2 0 0 1 25 0 )
      #(#LayoutFrame 70 0 2 0 0 1 25 0 ) decodeAsLiteralArray 
    "
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is: 
        (#LayoutOrigin orgOffsX relOrgX orgOffsY relOrgY cornOffsX relCornX cornOffsY relCornY)"

    ^ super literalArrayEncoding
      , (Array
            with:rightOffset value          "take care of blocks (dynamic preferred extent)"
            with:rightFraction
            with:bottomOffset value
            with:bottomFraction)            "take care of blocks (dynamic preferred extent)"

    "Modified: 1.9.1995 / 02:43:35 / claus"
    "Modified: 22.4.1996 / 13:00:17 / cg"
! !

!LayoutFrame methodsFor:'initialization'!

initialize
    leftOffset := rightOffset := bottomOffset := topOffset := 0.
    leftFraction := topFraction := 0.
    "/ bottomFraction := rightFraction := 1.
    bottomFraction := rightFraction := 0.

    "Modified: 1.3.1997 / 16:12:50 / cg"
! !

!LayoutFrame methodsFor:'printing & storing'!

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
    aGCOrStream nextPutAll:' r: '.
    rightFraction displayOn:aGCOrStream.
    aGCOrStream nextPut:$+. 
    rightOffset displayOn:aGCOrStream.
    aGCOrStream nextPutAll:' b: '.
    bottomFraction displayOn:aGCOrStream.
    aGCOrStream nextPut:$+. 
    bottomOffset displayOn:aGCOrStream.
    aGCOrStream nextPut:$). 

    "Modified: 20.9.1997 / 11:40:14 / cg"
! !

!LayoutFrame methodsFor:'queries'!

corner
    ^ rightFraction asFloat @ bottomFraction asFloat
!

isLayoutFrame
    "return true, if this is a layoutFrame"

    ^ true


!

rectangleRelativeTo:superRectangle preferred:prefRectHolder
    "compute the rectangle represented by the receiver,
     given the superViews rectangle and the view's preferredExtent."

    |x1 y1 x2 y2 superWidth superHeight|

    x1 := x2 := superRectangle left.
    y1 := y2 := superRectangle top.

    leftOffset notNil ifTrue:[
        x1 := x1 + leftOffset value
    ].
    topOffset notNil ifTrue:[
        y1 := y1 + topOffset value
    ].
    rightOffset notNil ifTrue:[
        x2 := x2 + rightOffset value
    ].
    bottomOffset notNil ifTrue:[
        y2 := y2 + bottomOffset value
    ].

    leftFraction notNil ifTrue:[
        superWidth := superRectangle width.
        x1 := x1 + (superWidth * leftFraction value) 
    ].
    topFraction notNil ifTrue:[
        superHeight := superRectangle height.
        y1 := y1 + (superHeight * topFraction value) 
    ].
    rightFraction notNil ifTrue:[
        superWidth isNil ifTrue:[superWidth := superRectangle width].
        x2 := x2 + (superWidth * rightFraction value) 
    ].
    bottomFraction notNil ifTrue:[
        superHeight isNil ifTrue:[superHeight := superRectangle height].
        y2 := y2 + (superHeight * bottomFraction value) 
    ].
    ^ Rectangle left:x1 top:y1 right:x2 bottom:y2

    "
     |superRect lF|

     superRect := 0@0 corner:99@99.
     lF := (LayoutFrame new).
     lF leftFraction:0.25;
        topFraction:0.25;
        rightFraction:0.75;
        bottomFraction:0.75.
     lF rectangleRelativeTo:superRect preferred:(0@0 corner:30@30) 
    "

    "Created: / 6.3.1997 / 21:07:51 / cg"
    "Modified: / 13.8.1998 / 18:33:59 / cg"
! !

!LayoutFrame class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

