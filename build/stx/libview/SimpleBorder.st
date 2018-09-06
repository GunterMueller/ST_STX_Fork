"
 COPYRIGHT (c) 1997 by eXept Software AG
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

"{ NameSpace: Smalltalk }"

AbstractBorder subclass:#SimpleBorder
	instanceVariableNames:'color'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!SimpleBorder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    a simple border, where all four sides are drawn in the same solid color

    [author:]
        Claus Gittinger
"
!

examples
"
                                                    [exBegin]
    |v1 v2 b|

    v1 := View new extent:100@100.
    v2 := View origin:10@10 corner:90@20 in:v2.
    v2 border:(SimpleBorder new color:Color red).
    v1 openAndWait.
                                                    [exEnd]
"
! !

!SimpleBorder methodsFor:'accessing'!

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
! !

!SimpleBorder methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    |oldPaint boxLeft boxTop boxWidth boxHeight|

    color isNil ifTrue:[ ^ self].

    oldPaint := aGC paint.
    aGC paint:color.
    width == 1 ifTrue:[
        aGC displayRectangle:aRectangle.
    ] ifFalse:[
        boxLeft := aRectangle left.
        boxTop := aRectangle top.
        boxWidth := aRectangle width.
        boxHeight := aRectangle height.
        aGC fillRectangleX:boxLeft y:boxTop width:boxWidth height:width.
        aGC fillRectangleX:boxLeft y:boxTop+boxHeight-width width:boxWidth height:width.
        aGC fillRectangleX:boxLeft y:boxTop+width width:width height:boxHeight-width-width.
        aGC fillRectangleX:boxLeft+boxWidth-width y:boxTop+width width:width height:boxHeight-width-width.
    ].
    aGC paint:oldPaint.

    "
     View new
        border:(SimpleBorder width:2 color:Color red);
        open.
    "
    "
     View new
        border:(SimpleBorder width:4 color:Color red);
        open.
    "

    "
     StandardSystemView new
        extent:200@200;
        add:(View new
                origin:(10@10) corner:0.9@0.9;
                border:(SimpleBorder width:4 color:Color red));
        open.
    "
! !

!SimpleBorder class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview/SimpleBorder.st,v 1.7 2015-01-05 20:35:12 cg Exp $'
! !

