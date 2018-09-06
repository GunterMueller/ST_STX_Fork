"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


"{ Package: 'stx:libview2' }"

PopUpView subclass:#PopUpBanner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!PopUpBanner class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    Shows a banner popUp (splash window);
    can be used at startup to make wait-time a bit more interesting.
    See use in smalltalk.rc / showBanner.rc / hideBanner.rc.

    [author:]
        Claus Gittinger
"

!

examples
"
                                                [exBegin]
    |img bannerView|

    img := Image fromFile:'banner1.xpm'.
    bannerView := PopUpBanner forImage:img.
    bannerView showCentered.

    Delay waitForSeconds:2.
    bannerView destroy
                                                [exEnd]
"

! !

!PopUpBanner class methodsFor:'instance creation'!

forImage:anImage
    |v|

    v := self new.
    v viewBackground:anImage.
    v cursor:Cursor wait.
    ^ v
! !

!PopUpBanner methodsFor:'activation & deactivation'!

open
    "default for popUpBanners is to come up modeless"

    |center r1 r2|

    "/ sorry - zooming does not work during early initialization;
    "/ REASON: at smalltalk.rc reading time, scheduling does not yet take place;
    "/ therefore, Delaydoes not work. 
    "/ sigh.
"/    center := self center.
"/    r1 := (center corner:center) insetBy:-5.
"/    r2 := self origin corner:self corner.
"/    self device zoom:r1 to:r2 duration:300.

    self realize

!

showCentered
    self extent:viewBackground extent.
    self showAt:((self device extent // 2) - (viewBackground extent // 2))


! !

!PopUpBanner methodsFor:'deactivation'!

destroy
    "/ sorry - zooming does not work during early initialization;
    "/ REASON: at smalltalk.rc reading time, scheduling does not yet take place;
    "/ therefore, Delay does not work, therefore zoom:to:duratio: does not work. 
    "/ - sigh.
   
"/    |screen center r1 r2|
"/
"/    screen := self device.
"/    center := self center.
"/    r1 := (center corner:center) insetBy:-5.
"/    r2 := self origin corner:self corner.

    super destroy.

"/    screen zoom:r2 to:r1 duration:300.
! !

!PopUpBanner methodsFor:'event handling'!

buttonPress:button x:x y:y
   "destroy view when user clicks into"

    self destroy
! !

!PopUpBanner methodsFor:'queries'!

grabWhenMapped
    ^ false
! !

!PopUpBanner class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/PopUpBanner.st,v 1.10 2003-05-07 15:18:41 cg Exp $'
! !
