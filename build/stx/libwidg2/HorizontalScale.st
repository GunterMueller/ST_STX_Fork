"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

SimpleView subclass:#HorizontalScale
	instanceVariableNames:'slider range action'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!HorizontalScale class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    like a slider, but with a range (i.e. may be different from 0..100)
    and displaying the current value.
"
!

examples
"
    |top s1 s2|

    top := StandardSystemView new.
    top extent:200@200.
    s1 := HorizontalScale origin:0.0 @ 0.0 in:top.
    s1 extent:1.0 @ 50.

    s2 := HorizontalScale origin:0.0 @ 0.5 in:top.
    s2 extent:1.0 @ 50.
    s2 range:(-50 to:50).
    top open
"

! !

!HorizontalScale methodsFor:'accessing'!

range:anInterval
    range := anInterval
!

scrollAction:aBlock
    action := aBlock
! !

!HorizontalScale methodsFor:'drawing'!

redraw
    |percent value x label|

    percent := slider thumbOrigin.

    value := (range last - range first) * (percent / 100).
    value := value + range first.

    x := slider thumbFrame left + (slider thumbFrame width // 2).
    self clear.
    self paint:Black.
    value := value roundTo:(range last - range first) / 100.
    label := value asFloat printString.
    (label endsWith:'.0') ifTrue:[
	label := value asInteger printString
    ].
    self displayString:label
		     x:x - ((font widthOf:label) // 2)
		     y:font ascent + device verticalPixelPerMillimeter

    "Created: / 7.3.1999 / 00:16:54 / cg"
    "Modified: / 7.3.1999 / 00:26:19 / cg"
! !

!HorizontalScale methodsFor:'initialization'!

initialize
    super initialize.

    range := (0 to:100).
    slider := HorizontalSlider in:self.
    slider origin:0.0 @ (font height + device verticalPixelPerMillimeter rounded).
    slider width:1.0.

"/    self height:(slider height
"/                + (font height)
"/                + (device verticalPixelPerMillimeter * 2) rounded).

    slider scrollAction:[:percent | self scroll:percent].

    "Modified: / 7.3.1999 / 00:21:52 / cg"
! !

!HorizontalScale methodsFor:'queries'!

preferredExtent
    ^ slider preferredExtent + (0 @ (font height + device verticalPixelPerMillimeter rounded))

    "Created: / 7.3.1999 / 00:18:28 / cg"
    "Modified: / 7.3.1999 / 00:24:40 / cg"
! !

!HorizontalScale methodsFor:'slider actions'!

scroll:percent
    |value|

    value := (range last - range first) * (percent / 100).
    value := value + range first.
    action notNil ifTrue:[
	action value:value.
    ].
    self redraw

    "Modified: / 7.3.1999 / 00:17:33 / cg"
! !

!HorizontalScale class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/HorizontalScale.st,v 1.6 2006-11-13 16:11:30 cg Exp $'
! !

