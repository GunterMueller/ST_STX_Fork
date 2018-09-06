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

LayoutOrigin subclass:#AlignmentOrigin
	instanceVariableNames:'leftAlignmentFraction topAlignmentFraction'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry'
!

!AlignmentOrigin class methodsFor:'documentation'!

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
    its superview. Like a LayoutOrigin, it controls the components origin
    via a relative part plus offset. However, in contrast to LayoutOrigin
    (in which the top-left corner is specified by fraction+offset, here any
    reference point within the component is positioned.
    The reference point itself is specified as fraction of the components size.

    Notice: 
	this class was implemented using protocol information
	from alpha testers - it may not be complete or compatible to
	the corresponding ST-80 class. 
	If you encounter any incompatibilities, please forward a note 
	describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
	Claus Gittinger

    [See also:]
	LayoutOrigin LayoutFrame Layout
	View
"
!

examples
"
    Although the examples below use a button as component,
    they work of course with any type of subview ....

    using a LayoutOrigin, to control the top-left origins position of
    a component (i.e. origin at:0.5@0.5):
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


    using an AlignmentOrigin, to control the centers position of
    a component (i.e. center of component at:0.5@0.5):
									[exBegin]
	|top button|

	top := StandardSystemView new.
	top extent:300@300.

	button := Button label:'component'.
	top add:button in:(AlignmentOrigin new
				leftFraction:0.5;
				topFraction:0.5;
				leftAlignmentFraction:0.5;
				topAlignmentFraction:0.5).

	top open
									[exEnd]


    using an AlignmentOrigin, to control the bottom-right position of
    a component (i.e. bottom-right of component at:0.5@0.5):
									[exBegin]
	|top button|

	top := StandardSystemView new.
	top extent:300@300.

	button := Button label:'component'.
	top add:button in:(AlignmentOrigin new
				leftFraction:0.5;
				topFraction:0.5;
				leftAlignmentFraction:1.0;
				topAlignmentFraction:1.0).

	top open
									[exEnd]


    four buttons around relative 0.75@0.75:
									[exBegin]
	|top button|

	top := StandardSystemView new.
	top extent:300@300.

	button := Button label:'button1'.
	top add:button in:(AlignmentOrigin new
				leftFraction:0.75;
				topFraction:0.75;
				leftAlignmentFraction:1.0;
				topAlignmentFraction:1.0).

	button := Button label:'button2'.
	top add:button in:(AlignmentOrigin new
				leftFraction:0.75;
				topFraction:0.75;
				leftAlignmentFraction:0.0;
				topAlignmentFraction:1.0).

	button := Button label:'button3'.
	top add:button in:(AlignmentOrigin new
				leftFraction:0.75;
				topFraction:0.75;
				leftAlignmentFraction:1.0;
				topAlignmentFraction:0.0).

	button := Button label:'button4'.
	top add:button in:(AlignmentOrigin new
				leftFraction:0.75;
				topFraction:0.75;
				leftAlignmentFraction:0.0;
				topAlignmentFraction:0.0).
	top open
									[exEnd]
"
! !

!AlignmentOrigin methodsFor:'accessing'!

leftAlignmentFraction
    "return leftAlignmentFraction"

    ^ leftAlignmentFraction
!

leftAlignmentFraction:something
    "set leftAlignmentFraction"

    leftAlignmentFraction := something.
!

leftAlignmentFraction:lF topAlignmentFraction:tF
    "set both leftAlignmentFraction and topAlignmentFraction"

    leftAlignmentFraction := lF.
    topAlignmentFraction := tF

    "Created: 18.4.1997 / 20:06:02 / cg"
!

topAlignmentFraction
    "return topAlignmentFraction"

    ^ topAlignmentFraction
!

topAlignmentFraction:something
    "set topAlignmentFraction"

    topAlignmentFraction := something.
! !

!AlignmentOrigin methodsFor:'comparing'!

= anObject
    ^ super = anObject
        and:[ anObject leftAlignmentFraction = leftAlignmentFraction
        and:[ anObject topAlignmentFraction = topAlignmentFraction ]]
!

hash
    ^ super hash
      + leftAlignmentFraction hash + topAlignmentFraction hash 
! !

!AlignmentOrigin methodsFor:'converting'!

fromLiteralArrayEncoding:encodingArray
    "read my values from an encoding.
     The encoding is supposed to be of the form: 
	(AlignmentOrigin orgOffsX relOrgX orgOffsY relOrgY leftAlignFract topAlignFract)"

    leftOffset := encodingArray at:2.
    leftFraction := encodingArray at:3.
    topOffset := encodingArray at:4.
    topFraction := encodingArray at:5.
    leftAlignmentFraction := encodingArray at:6.
    topAlignmentFraction := encodingArray at:7.

    "
      AlignmentOrigin new fromLiteralArrayEncoding:#(#AlignmentOrigin 70 0 2 0 0.5 0.25)
    "

    "Modified: / 1.9.1995 / 02:23:53 / claus"
    "Modified: / 16.11.1997 / 23:04:16 / cg"
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is: 
	(#AlignmentOrigin orgOffsX relOrgX orgOffsY relOrgY leftAlignFract topAlignFract)"

    ^ super literalArrayEncoding
      , (Array
	    with:leftAlignmentFraction
	    with:topAlignmentFraction)

    "Modified: 1.9.1995 / 02:43:35 / claus"
    "Modified: 22.4.1996 / 12:59:56 / cg"
! !

!AlignmentOrigin methodsFor:'initialization'!

initialize
    super initialize.
    leftAlignmentFraction := topAlignmentFraction := 0.
! !

!AlignmentOrigin methodsFor:'printing & storing'!

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
    aGCOrStream nextPutAll:' a: '.
    leftAlignmentFraction displayOn:aGCOrStream.
    aGCOrStream nextPut:$@. 
    topAlignmentFraction displayOn:aGCOrStream.
    aGCOrStream nextPut:$). 

    "Modified: 22.1.1997 / 11:58:38 / cg"
! !

!AlignmentOrigin methodsFor:'queries'!

isAlignmentOrigin
    "return true, if this is an alignmentOrigin"

    ^ true


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
    leftAlignmentFraction ~~ 0 ifTrue:[
        x := x - (prefRect width * leftAlignmentFraction value)
    ].
    topAlignmentFraction ~~ 0 ifTrue:[
        y := y - (prefRect height * topAlignmentFraction value)
    ].
    ^ Rectangle left:x top:y extent:prefRect extent

    "
     |superRect aO|

     superRect := 0@0 corner:100@100.
     aO := (AlignmentOrigin new).
     aO leftFraction:0.5;
        topFraction:0.5;
        leftAlignmentFraction:0.5;
        topAlignmentFraction:0.5.
     aO rectangleRelativeTo:superRect preferred:(0@0 corner:30@30) 
    "

    "Modified: / 13.8.1998 / 18:39:26 / cg"
! !

!AlignmentOrigin class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

