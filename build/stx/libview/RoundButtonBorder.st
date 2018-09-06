"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

AbstractBorder subclass:#RoundButtonBorder
	instanceVariableNames:'color'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!RoundButtonBorder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    experimental

    |v b|

    v := View new extent:100@100; openAndWait.
    b := RoundButtonBorder new.
    b width:1 color:(Color rgbValue:16r707070).
    b displayOn:v forDisplayBox:((0@0 corner:v extent) insetBy:10).
    Delay waitForSeconds:3.

    b width:1 color:(Color rgbValue:16r2C628B).
    b displayOn:v forDisplayBox:((0@0 corner:v extent) insetBy:10).
    Delay waitForSeconds:3.

    b width:1 color:(Color rgbValue:16r3C7FB1).
    b displayOn:v forDisplayBox:((0@0 corner:v extent) insetBy:10).

    [author:]
        Claus Gittinger
"
! !

!RoundButtonBorder methodsFor:'accessing'!

color
    "the color of the border"

    ^ color
!

color:aColor
    "set the color of the border"

    width ~~ 0 ifTrue:[
        self assert:aColor notNil.
    ].
    color := aColor
!

width
    ^ 2
! !

!RoundButtonBorder methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    |oldPaint left top w h|

    color isNil ifTrue:[ ^ self].

    oldPaint := aGC paint.
    aGC paint:color.
    left := aRectangle left.
    top := aRectangle top.
    w := aRectangle width.
    h := aRectangle height.

    aGC displayRectangleX:left y:top width:w height:h.

    aGC paint:color slightlyLightened.
    aGC displayPointX:left+2 y:top.
    aGC displayPointX:left+1 y:top+1.
    aGC displayPointX:left y:top+2.

    aGC displayPointX:left+2 y:top+h-1.
    aGC displayPointX:left+1 y:top+h-2.
    aGC displayPointX:left y:top+h-3.

    aGC displayPointX:left+w-3 y:top.
    aGC displayPointX:left+w-2 y:top+1.
    aGC displayPointX:left+w-1 y:top+2.

    aGC displayPointX:left+w-3 y:top+h-1.
    aGC displayPointX:left+w-2 y:top+h-2.
    aGC displayPointX:left+w-1 y:top+h-3.

    aGC paint:color lightened.
    aGC displayPointX:left+1 y:top.
    aGC displayPointX:left y:top+1.

    aGC displayPointX:left+1 y:top+h-1.
    aGC displayPointX:left y:top+h-2.

    aGC displayPointX:left+w-2 y:top.
    aGC displayPointX:left+w-1 y:top+1.

    aGC displayPointX:left+w-2 y:top+h-1.
    aGC displayPointX:left+w-1 y:top+h-2.

    aGC paint:(aGC container ? aGC) viewBackground.
    aGC displayPointX:left y:top.
    aGC displayPointX:left+w-1 y:top.

    aGC displayPointX:left y:top+h-1.
    aGC displayPointX:left+w-1 y:top+h-1.

    aGC paint:oldPaint.

    "
     |v b|

     v := View new openAndWait.
     b := RoundButtonBorder width:2 color:Color grey.
     b displayOn:v forDisplayBox:(0@0 corner:v extent).
    "
! !

!RoundButtonBorder class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview/RoundButtonBorder.st,v 1.4 2009-11-05 13:55:59 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

