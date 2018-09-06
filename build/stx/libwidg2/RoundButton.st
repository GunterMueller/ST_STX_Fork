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

Button subclass:#RoundButton
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!RoundButton class methodsFor:'documentation'!

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
    this is not finished - please do not look at it
    and do not use it (i.e. simply ignore it ;-).

    Notice - this only works under graphic displays which
    support arbitrary shaped views (i.e. XWindow).

    Under Win32, you will see a rectanglular view instead.
"
!

examples
"
    |top b|

    top := StandardSystemView extent:300@300.
    b := RoundButton label:'hello' in:top.
    top open
"
! !

!RoundButton methodsFor:'drawing'!

drawWith:fg and:bg
    self paint:bg.
    self fillRectangleX:0 y:0 width:width height:height.
    super drawWith:fg and:bg
! !

!RoundButton methodsFor:'private'!

roundCornerFormWidth:width height:height offset:off
    |form wCorn hCorn wCornHalf wCornHalfRest hCornHalf hCornHalfRest
     left top right bot w h|

     "compute a shape form"
     form := Form width:width height:height.
     form fill:(Color colorId:0).

     left := off. right := width-(off*2)-1.
     top := off. bot := height-(2*off)-1.

     w := width - off - off.
     h := height - off - off.

     wCorn := (w * 0.33) rounded asInteger.
     hCorn := (h * 0.75) rounded asInteger.
     wCornHalf := wCorn // 2.
     hCornHalf := hCorn // 2.
     wCorn odd ifTrue:[
	 wCornHalfRest := 1
     ] ifFalse:[
	 wCornHalfRest := 0
     ].
     hCorn odd ifTrue:[
	 hCornHalfRest := 1
     ] ifFalse:[
	 hCornHalfRest := 0
     ].

     form paint:(Color colorId:1).

     form fillArcX:left y:top w:wCorn h:hCorn from:0 angle:360.

     form fillRectangleX:(left + wCornHalf) y:top
			 width:(w - wCorn + wCornHalfRest) height:hCornHalf.

     "top right arc"
     form fillArcX:(right - wCorn) y:top w:wCorn h:hCorn from:0 angle:90.

     "big middle rect"
     form fillRectangleX:left y:(top + hCornHalf)
		    width:w height:(h - hCorn + hCornHalfRest).

     "bottom left arc"
     form fillArcX:left y:(bot - hCorn) w:wCorn h:hCorn from:180 angle:90.

     "bottom rect"
     form fillRectangleX:(left + wCornHalf) y:(bot - hCornHalf)
		    width:(w - wCorn + wCornHalfRest) height:hCornHalf.

     "bottom right arc"
     form fillArcX:(right - wCorn) y:(bot - hCorn) w:wCorn h:hCorn from:270 angle:90.

     ^ form
! !

!RoundButton methodsFor:'window events'!

sizeChanged:how
    |shapeForm borderForm|

    super sizeChanged:how.

    "compute a new shape form"

    borderForm := self roundCornerFormWidth:width+(borderWidth * 2)
				     height:height+(borderWidth * 2)
				     offset:0.
    shapeForm := self roundCornerFormWidth:width+(borderWidth * 2)
				    height:height+(borderWidth * 2)
				    offset:borderWidth.

    self borderShape:borderForm.
    self viewShape:shapeForm
! !

!RoundButton class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/RoundButton.st,v 1.5 2006-11-13 16:11:31 cg Exp $'
! !

