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

SimpleView subclass:#Scale
	instanceVariableNames:'slider range action'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!Scale class methodsFor:'documentation'!

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
    s1 := Scale origin:0.0 @ 0.0 in:top.
    s1 extent:50 @ 1.0.

    s2 := Scale origin:0.5 @ 0.0 in:top.
    s2 extent:50 @ 1.0.
    s2 range:(-50 to:50).
    top open
"
! !

!Scale methodsFor:'accessing'!

range:anInterval
    range := anInterval
!

scrollAction:aBlock
    action := aBlock
! !

!Scale methodsFor:'drawing'!

redraw
    |percent value y label|

    percent := slider thumbOrigin.
    value := (range last - range first) * (percent / 100).
    value := value + range first.

    y := slider thumbFrame top + (slider thumbFrame height // 2).
    self clear.
    self paint:Black.
    value := value roundTo:(range last - range first) / 100.
    label := value asFloat printString.
    (label endsWith:'.0') ifTrue:[
	label := value asInteger printString
    ].
    self displayString:label
		     x:slider width + device horizontalPixelPerMillimeter
		     y:y + (font ascent // 2)

    "Created: / 7.3.1999 / 00:12:42 / cg"
    "Modified: / 7.3.1999 / 00:17:52 / cg"
! !

!Scale methodsFor:'initialization'!

initialize
    super initialize.

    range := (0 to:100).
    slider := Slider in:self.
"/    slider fixSize.
    slider origin:0.0 @ 0.0.
    slider height:1.0.

"/    self width:(slider width
"/                + (font widthOf:'100')
"/                + (device horizontalPixelPerMillimeter * 2) rounded).

    slider scrollAction:[:percent | self scroll:percent].

    "Modified: / 7.3.1999 / 00:23:42 / cg"
! !

!Scale methodsFor:'queries'!

preferredExtent
    ^ slider preferredExtent + ((font widthOf:'999') @ 0)

    "Created: / 7.3.1999 / 00:02:25 / cg"
! !

!Scale methodsFor:'slider actions'!

scroll:percent
    |value|

    value := (range last - range first) * (percent / 100).
    value := value + range first.
    action notNil ifTrue:[
	action value:value.
    ].
    self redraw

    "Modified: / 7.3.1999 / 00:17:46 / cg"
! !

!Scale class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/Scale.st,v 1.6 2006-11-13 16:11:31 cg Exp $'
! !

