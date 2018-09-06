"{ Encoding: utf8 }"

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
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

AbstractBorder subclass:#Border
	instanceVariableNames:'leftColor leftWidth rightColor rightWidth topColor topWidth
		bottomColor bottomWidth'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!Border class methodsFor:'documentation'!

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
    a border holds the values of a view's (or component's) border.
    We have only recently started to change the system to use borders instead of separate
    borderWidth, borderColor, level, shadow- and lightColors.
    Expect more changes here in the near future..

    [see also:]
        SimpleView

    [author:]
        Claus Gittinger
"
!

examples
"
                                                        [exBegin]
     |v b|

     v := StandardSystemView extent:100@100.
     v openAndWait.

     b := Border width:1 color:Color red.
     v border:b
                                                        [exEnd]

                                                        [exBegin]
     |v b|

     v := StandardSystemView extent:100@100.
     v openAndWait.

     b := Border width:10 color:Color red.
     b displayOn:v forDisplayBox:(0@0 corner:90@90).

     Delay waitForSeconds:1.
     b leftColor:Color blue.
     b displayOn:v forDisplayBox:(0@0 corner:90@90).
     Delay waitForSeconds:1.
     b topColor:Color green.
     b displayOn:v forDisplayBox:(0@0 corner:90@90).
     Delay waitForSeconds:1.
     b rightColor:Color yellow.
     b displayOn:v forDisplayBox:(0@0 corner:90@90).
                                                        [exEnd]

                                                        [exBegin]
     |v b|

     v := StandardSystemView extent:100@100.
     v openAndWait.

     b := Border width:10 color:Color red.
     b topColor:Color red.
     b leftColor:Color blue.
     b topColor:Color green.
     b rightColor:Color yellow.
     b leftWidth:10 rightWidth:20 topWidth:5 bottomWidth:15.

     b displayOn:v forDisplayBox:(0@0 corner:90@90).
                                                        [exEnd]

                                                        [exBegin]
     |v sub1 sub2 sub3|

     v := StandardSystemView extent:200@200.
     v openAndWait.

     sub1 := (View in:v) origin:10@10; corner:90@90.
     sub1 border:(SimpleBorder width:10 color:Color red ).
     sub1 realize.
     sub2 := (View in:v) origin:110@10; corner:190@90.
     sub2 border:(Border new width:10; color:Color blue; leftColor:Color red; rightColor:Color red ).
     sub2 realize.
     sub3 := (View in:v) origin:110@110; corner:190@190.
     sub3 border:(SimpleBorder width:10 color:Color green ).
     sub3 realize.

     Delay waitForSeconds:1.
     sub3 border:(Border new width:10; color:Color yellow; leftColor:Color red; rightColor:Color red ).

                                                        [exEnd]
"
! !

!Border methodsFor:'accessing'!

bottomColor
    "return the value of the instance variable 'bottomColor' (automatically generated)"

    ^ bottomColor

    "Created: 10.2.1997 / 14:51:34 / cg"
!

bottomColor:aColor
    "set the bottomColor"

    bottomColor := aColor

    "Created: 10.2.1997 / 15:37:51 / cg"
!

bottomWidth
    ^ bottomWidth
!

bottomWidth:something
    bottomWidth := something.
!

color:newColor
    "set all four colors"

     leftColor := rightColor := topColor := bottomColor := newColor

    "Created: 10.2.1997 / 15:27:01 / cg"
!

leftColor
    "return the value of the instance variable 'leftColor' (automatically generated)"

    ^ leftColor

    "Created: 10.2.1997 / 14:51:34 / cg"
!

leftColor:aColor
    "set the leftColor"

    leftColor := aColor

    "Created: 10.2.1997 / 15:38:02 / cg"
!

leftWidth
    ^ leftWidth
!

leftWidth:something
    leftWidth := something.
!

leftWidth:leftWidthArg rightWidth:rightWidthArg topWidth:topWidthArg bottomWidth:bottomWidthArg 
    leftWidth := leftWidthArg.
    rightWidth := rightWidthArg.
    topWidth := topWidthArg.
    bottomWidth := bottomWidthArg.
!

rightColor
    "return the value of the instance variable 'rightColor' (automatically generated)"

    ^ rightColor

    "Created: 10.2.1997 / 14:51:34 / cg"
!

rightColor:aColor
    "set the rightColor"

    rightColor := aColor

    "Created: 10.2.1997 / 15:38:08 / cg"
!

rightWidth
    ^ rightWidth
!

rightWidth:something
    rightWidth := something.
!

topColor
    "return the value of the instance variable 'topColor' (automatically generated)"

    ^ topColor

    "Created: 10.2.1997 / 14:51:34 / cg"
!

topColor:aColor
    "set the topColor"

    topColor := aColor

    "Created: 10.2.1997 / 15:38:17 / cg"
!

topWidth
    ^ topWidth
!

topWidth:something
    topWidth := something.
!

width:w
    leftWidth := rightWidth := topWidth := bottomWidth := width := w.
! !

!Border methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    "display the border represented by the receiver in the given rectangle.
     The gc's state is restored after the drawing."

    |oldPaint rL rR rT rB rW rH|

    width == 0 ifTrue:[ ^ self ].

    oldPaint := aGC paint.

    rL := aRectangle left.
    rT := aRectangle top.
    rR := aRectangle right.
    rB := aRectangle bottom.
    rH := aRectangle height.
    rW := aRectangle width.

    leftColor notNil ifTrue:[
        aGC paint:leftColor.
        leftWidth == 1 ifTrue:[
            aGC displayLineFromX:rL y:rT toX:rL y:rB-1.
        ] ifFalse:[
            aGC fillRectangleX:rL y:rT width:leftWidth height:rH
        ].
    ].

    topColor notNil ifTrue:[
        aGC paint:topColor.
        topWidth == 1 ifTrue:[
            aGC displayLineFromX:rL+1 y:rT toX:rR-1 y:rT.
        ] ifFalse:[
            aGC fillRectangleX:(rL + leftWidth) y:rT width:rW - leftWidth - rightWidth  height:topWidth
        ].
    ].

    rightColor notNil ifTrue:[
        aGC paint:rightColor.
        rightWidth == 1 ifTrue:[
            aGC displayLineFromX:rR-1 y:rT toX:rR-1 y:rB-1.
        ] ifFalse:[
            aGC fillRectangleX:(rR - rightWidth) y:rT width:rightWidth height:rH
        ].
    ].

    bottomColor notNil ifTrue:[
        aGC paint:bottomColor.
        bottomWidth == 1 ifTrue:[
            aGC displayLineFromX:rL+1 y:rB-1 toX:rR-2 y:rB-1.
        ] ifFalse:[
            aGC fillRectangleX:rL+leftWidth y:(rB-bottomWidth) width:rW - leftWidth - rightWidth height:bottomWidth
        ].
    ].

    aGC paint: oldPaint

    "Modified: 10.2.1997 / 15:55:04 / cg"
! !

!Border methodsFor:'initialization'!

initialize
    width := 1.
    leftWidth := rightWidth := topWidth := bottomWidth := 1.
! !

!Border methodsFor:'queries'!

bottomMargin
    ^ bottomWidth
!

leftMargin
    ^ leftWidth
!

rightMargin
    ^ rightWidth
!

topMargin
    ^ topWidth
! !

!Border class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

