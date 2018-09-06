"
 COPYRIGHT (c) 2004 by eXept Software AG
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

View subclass:#TransparentBox
	instanceVariableNames:'shapeForm'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!TransparentBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
    | tv b1 b2 |

    b1 := Button label:'close'.
    b1 action:[ tv close ].
    b1 origin:10@10.

    b2 := Button label:'hello'.
    b2 origin:100@100.

    tv := self new.
    tv extent:200@200.

    tv addSubView:b1.
    tv addSubView:b2.
    tv open
"
! !

!TransparentBox methodsFor:'events'!

sizeChanged:how
    shapeForm notNil ifTrue:[
        self computeShape.
    ].
    ^ super sizeChanged: how.
! !

!TransparentBox methodsFor:'initialization'!

realize
    self computeShape.
    super realize.
! !

!TransparentBox methodsFor:'queries'!

isTransparentBox

    ^true
!

specClass
    ^ TransparentBoxSpec
!

windowStyle
    ^ #undecorated
! !

!TransparentBox methodsFor:'shape computation'!

addSubView:aView
    super addSubView:aView.
    shapeForm notNil ifTrue:[
        self computeShape
    ].
!

computeShape
    | subViews w h |

    device supportsArbitraryShapedViews ifFalse:[^self].

    w := self extent x.
    h := self extent y.
    shapeForm := Form width:w height:h.
    shapeForm fill:(Color colorId:0).

    shapeForm foreground:(Color colorId:1).

    subViews := self subViews.
    subViews isEmptyOrNil ifTrue:[
       self fillFormWithBorderShape:shapeForm.
    ] ifFalse:[
        subViews do:[:aSubView|
            aSubView fillFormWithBorderShape:shapeForm.
        ]
    ].
    "/ self viewShape:shapeForm.
    self borderShape:shapeForm.
! !

!TransparentBox class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

