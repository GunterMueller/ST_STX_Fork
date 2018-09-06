"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

Slider subclass:#HorizontalSlider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!HorizontalSlider class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    this class implements horizontal sliders.

    [author:]
        Claus Gittinger
"
! !

!HorizontalSlider methodsFor:'initialization'!

initialize
    orientation := #horizontal. 
    super initialize.
    sliderHeight := (self horizontalPixelPerMillimeter:10) rounded.

    "Modified: / 7.3.1999 / 00:00:47 / cg"
! !

!HorizontalSlider methodsFor:'queries'!

preferredExtent
    "return the view's preferredExtent."

    |w h|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    w := self class defaultExtent x.
    h := (self verticalPixelPerMillimeter:6) rounded.

    preferredExtent := w @ h.
    ^ preferredExtent.

    "Modified: 19.7.1996 / 20:44:30 / cg"
! !

!HorizontalSlider class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

