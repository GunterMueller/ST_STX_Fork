"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#NoteBookFrameView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!NoteBookFrameView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    this view is used as the bottom part of a notebook,
    in which the selected subCanvas is drawn.
    Its only reason for existance is to redefine the
    border drawing to NOT draw the top border.

    [author:]
	Claus Gittinger

    [see also:]
	NoteBookView TabView
"
! !

!NoteBookFrameView methodsFor:'drawing'!

drawEdgesForX:x y:y width:w height:h level:l
		shadow:shadowColor light:lightColor
		halfShadow:halfShadowColor halfLight:halfLightColor
		style:edgeStyle

    "draw 3D edges into a rectangle, but NOT the top edge"

    |topLeftFg botRightFg topLeftHalfFg botRightHalfFg
     count "{ Class: SmallInteger }"
     r     "{ Class: SmallInteger }"
     b     "{ Class: SmallInteger }"
     xi    "{ Class: SmallInteger }"
     yi    "{ Class: SmallInteger }"
     run paint|

    count := l.
    (count < 0) ifTrue:[
	topLeftFg := shadowColor.
	botRightFg := lightColor.
	topLeftHalfFg := halfShadowColor.
	botRightHalfFg := halfLightColor.
	count := count negated
    ] ifFalse:[
	topLeftFg := lightColor.
	botRightFg := shadowColor.
	topLeftHalfFg := halfLightColor.
	botRightHalfFg := halfShadowColor.
    ].
    topLeftHalfFg isNil ifTrue:[
	topLeftHalfFg := topLeftFg
    ].
    botRightHalfFg isNil ifTrue:[
	botRightHalfFg := botRightFg
    ].

    r := x + w - 1. "right"
    b := y + h - 1. "bottom"

    self lineWidth:0.

    "top and left edges"
    ((edgeStyle == #soft) and:["l" count > 0]) ifTrue:[
	paint := topLeftHalfFg
    ] ifFalse:[
	paint := topLeftFg
    ].
    self paint:paint.

    0 to:(count - 1) do:[:i |
	run := y + i.
	run := x + i.
	self displayDeviceLineFromX:run y:y toX:run y:b  "left"
    ].
    (edgeStyle == #soft) ifTrue:[
"
	self paint:topLeftFg.
	self displayDeviceLineFromX:x y:y toX:r y:y.
	self displayDeviceLineFromX:x y:y toX:x y:b
"
	(l > 2) ifTrue:[
	    self paint:(device blackColor).
	    self displayDeviceLineFromX:x y:y toX:x y:b.
	]
    ].

    xi := x + 1.
    yi := y + 1.

"/ does not look good
"/ style == #st80 iftrue:[
"/  yi := yi + 1
"/ ].

    "bottom and right edges"
    (edgeStyle == #soft "new:" and:[count > 1]) ifTrue:[
	paint := botRightHalfFg
    ] ifFalse:[
	paint := botRightFg
    ].

    self paint:paint.
    0 to:(count - 1) do:[:i |
	run := b - i.
	self displayDeviceLineFromX:xi-1 y:run toX:r y:run. "bottom"
	run := r - i.
	self displayDeviceLineFromX:run y:yi-1 toX:run y:b.  "right"
	xi := xi + 1.
	yi := yi + 1
    ].
    ((edgeStyle == #soft) and:[l > 1]) ifTrue:[
	self paint:(device blackColor) "shadowColor".
	self displayDeviceLineFromX:(x + (1 - 1)) y:b toX:r y:b.
	self displayDeviceLineFromX:r y:(y + (1 - 1)) toX:r y:b
    ].

    self edgeDrawn:#all

    "Modified: 7.3.1997 / 17:59:19 / cg"


!

drawTopEdgeLevel:level shadow:shadowColor light:lightColor halfShadow:halfShadowColor halfLight:halfLightColor style:edgeStyle
    "does NOT draw the top edge"

    ^ self

! !

!NoteBookFrameView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/NoteBookFrameView.st,v 1.3 2006-11-13 16:11:31 cg Exp $'
! !

