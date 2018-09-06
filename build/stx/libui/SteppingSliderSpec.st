"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"




SliderSpec subclass:#SteppingSliderSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SteppingSliderSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



! !

!SteppingSliderSpec methodsFor:'queries - UIPainter'!

needsRebuildForAttributes
    "return true, if my view must be rebuild
     when an attribute changes.
     True may be returned by a concrete subclass, 
     if attribute changes imply a view-class change 
     (such as Horizontal/vertical)"

    ^ true



!

viewClass
    "return true, if my view must be rebuild
     when an attribute changes.
     True may be returned by a concrete subclass, 
     if attribute changes imply a view-class change 
     (such as Horizontal/vertical)"

    ^ orientation == #horizontal ifTrue:[HorizontalSteppingSlider]
                                 ifFalse:[SteppingSlider]


! !

!SteppingSliderSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SteppingSliderSpec.st,v 1.3 2000-02-18 14:17:51 cg Exp $'
! !
