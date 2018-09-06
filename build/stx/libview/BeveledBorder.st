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

"{ NameSpace: Smalltalk }"

AbstractBorder subclass:#BeveledBorder
	instanceVariableNames:'color shadowColor lightColor level'
	classVariableNames:'RaisedBorder2 InsetBorder2 RaisedBorder1 InsetBorder1'
	poolDictionaries:''
	category:'Graphics-Support'
!

!BeveledBorder class methodsFor:'documentation'!

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
    This will replace the mixture of window-system supported borders and manually
    drawn 3D levels (which is ugly, but served me well for almost 20years now).

    [author:]
        Claus Gittinger
"
!

examples
"
                                                [exBegin]
     |top v b|

    
     top := StandardSystemView extent:100@100.
     v := View origin:10@10 corner:90@30 in:top.
     top openAndWait.

     b := BeveledBorder raised1.
     v border:b.
     Delay waitForSeconds:1.
     v border:(BeveledBorder level:2).
     Delay waitForSeconds:1.
     v border:(BeveledBorder level:3).
     Delay waitForSeconds:1.
     v border:(BeveledBorder level:-3).
     Delay waitForSeconds:1.
     v border:(BeveledBorder level:-2).
     Delay waitForSeconds:1.
     v border:(BeveledBorder level:-1).
     Delay waitForSeconds:1.
     v border:(BeveledBorder level:0).
                                                [exEnd]

                                                [exBegin]
     |top v b|

     top := StandardSystemView extent:100@100.
     v := View origin:10@10 corner:90@30 in:top.
     top openAndWait.

     b := BeveledBorder inset1.
     v border:b.
                                                [exEnd]
"
! !

!BeveledBorder class methodsFor:'instance creation'!

level:aNumber
    aNumber == 1 ifTrue:[^ self raised1].
    aNumber == -11 ifTrue:[^ self inset1].
    ^ self new level:aNumber
!

level:aNumber color:aColor
    aNumber == 1 ifTrue:[^ self raised1].
    aNumber == -11 ifTrue:[^ self inset1].
    ^ self new level:aNumber color:aColor
! !

!BeveledBorder class methodsFor:'constants'!

inset
    "Answer the default beveled border with inset edges."

    InsetBorder2 isNil ifTrue:[
        InsetBorder2 := self new level:-2
    ].
    ^ InsetBorder2

    "
     self inset
    "
!

inset1
    "Answer the default beveled border with inset edges of thickness 1."

    InsetBorder1 isNil ifTrue:[
        InsetBorder1 := self new level:-1
    ].
    ^ InsetBorder1
!

raised
    "Answer the default beveled border with raised edges."

    RaisedBorder2 isNil ifTrue:[
        "/ RaisedBorder := self new setBorderWidth: 2.
        RaisedBorder2 := self new level:2
    ].
    ^ RaisedBorder2
!

raised1
    "Answer the default beveled border with raised edges of thickness 1."

    RaisedBorder1 isNil ifTrue:[
        "/ RaisedBorder := self new setBorderWidth: 1.
        RaisedBorder1 := self new level:1
    ].
    ^ RaisedBorder1
! !

!BeveledBorder methodsFor:'accessing'!

color
    ^ color.
!

color:aColor
    color := aColor.
    shadowColor := aColor slightlyDarkened.
    lightColor := aColor slightlyLightened.
!

level
    ^ level

    "Created: / 6.7.1998 / 17:36:59 / cg"
!

level:anInteger
    level := anInteger.
    width := level abs.

    "Created: / 6.7.1998 / 13:42:09 / cg"
    "Modified: / 6.7.1998 / 17:37:17 / cg"
!

level:aNumber color:aColor
    self level:aNumber.
    self color:aColor.
! !

!BeveledBorder methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    |oldPaint boxLeft boxTop boxWidth boxHeight light shadow|

    oldPaint := aGC paint.

    boxLeft := aRectangle left.
    boxTop := aRectangle top.
    boxWidth := aRectangle width.
    boxHeight := aRectangle height.

    (lightColor notNil and:[shadowColor notNil]) ifTrue:[
        light := lightColor. 
        shadow := shadowColor.
    ] ifFalse:[
        light := aGC lightColor. 
        shadow := aGC shadowColor.
    ].

    aGC 
        drawEdgesForX:boxLeft y:boxTop width:boxWidth height:boxHeight level:(level ? width)
        shadow:shadow light:light
        halfShadow:nil halfLight:nil
        style:nil.

    aGC paint:oldPaint.

    "
     View new
        border:(BeveledBorder level:2 color:Color red);
        open.
    "
    "
     View new
        border:(BeveledBorder level:4 color:Color red);
        open.
    "

    "
     StandardSystemView new
        extent:200@200;
        add:(View new
                origin:(10@10) corner:0.9@0.9;
                border:(BeveledBorder width:4 color:Color red));
        open.
    "
! !

!BeveledBorder class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

