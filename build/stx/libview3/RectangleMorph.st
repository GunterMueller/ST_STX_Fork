"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview3' }"

Morph subclass:#RectangleMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Display Objects'
!

!RectangleMorph class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by Claus Gittinger
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
    I represent a filled or unfilled rectangle.
"
! !

!RectangleMorph methodsFor:'drawing'!

displayBackgroundOn:aGC
    "/ intentionally left blank (filled with fg)
!

displayInsideOn:aGC 
    |fg|

    (fillHolder value ? fill ? false) ifTrue:[
        fg := foregroundColorHolder value ? foregroundColor.
        fg notNil ifTrue:[
            aGC paint:fg.
            aGC fillRectangle:frame.
        ].
    ].
!

displayOutsideOn:aGC
    |lc lw|

    (lineHolder value ? line ? false) ifTrue:[
        lc := lineColorHolder value ? lineColor.
        lc notNil ifTrue:[
            lw := lineWidthHolder value ? lineWidth ? 0.

            aGC paint:lc.
            aGC lineWidth:lw.
            aGC displayRectangle:frame.
        ].
    ]
! !

!RectangleMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/RectangleMorph.st,v 1.4 2009-05-11 23:57:41 cg Exp $'
! !
