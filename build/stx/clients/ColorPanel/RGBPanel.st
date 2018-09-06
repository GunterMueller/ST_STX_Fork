ThreeSliderPanel subclass:#RGBPanel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

RGBPanel comment:'
 allows mixing of a color by rgb values

RGBPanel new realize
 $Header: /cvs/stx/stx/clients/ColorPanel/RGBPanel.st,v 1.5 1996-06-12 11:02:57 cg Exp $
 written june 93 by claus
'!


!RGBPanel class methodsFor:'specification'!

sliderClass
    ^ SteppingColorSlider

! !

!RGBPanel methodsFor:'accessing'!

setFrom:aColor
    self setSlider1:aColor red 
	    slider2:aColor green
	    slider3:aColor blue
! !

!RGBPanel methodsFor:'initialization'!

initialize
    super initialize.

    slider1 color:Color red; label:'red'.
    slider2 color:Color green; label:'green'.
    slider3 color:Color blue; label:'blue'.

    nameLabel1 label:'R'.
    nameLabel2 label:'G'.
    nameLabel3 label:'B'.

    action := [:r :g :b | ].

    "
     RGBPanel new open
     (RGBPanel extent:200@100) open
    "
! !

!RGBPanel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/RGBPanel.st,v 1.5 1996-06-12 11:02:57 cg Exp $'
! !
