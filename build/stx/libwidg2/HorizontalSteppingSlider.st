"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libwidg2' }"

SteppingSlider subclass:#HorizontalSteppingSlider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!HorizontalSteppingSlider class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    HorizontalSteppingSliders are like HorizontalSliders, but add step-up and step-down
    buttons (which increment/decrement the value).

    [author:]
	Claus Gittinger

    [see also:]
	HorizontalScrollBar HorizontalScroller HorizontalSlider
	ThumbWheel
"
!

examples
"
  see more examples in my superclass, SteppingSlider
								[exBegin]
    |top sl|

    top := StandardSystemView extent:200@200.
    sl := HorizontalSteppingSlider in:top.
    sl origin:(0.0@0.0) corner:(1.0@(sl preferredExtent y)).
    sl scrollAction:[:pos | Transcript showCR:pos].
    top open
								[exEnd]
"
! !

!HorizontalSteppingSlider methodsFor:'initialization'!

initialize
    orientation := #horizontal.
    super initialize.


! !

!HorizontalSteppingSlider class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/HorizontalSteppingSlider.st,v 1.13 2006-11-13 16:11:30 cg Exp $'
! !
