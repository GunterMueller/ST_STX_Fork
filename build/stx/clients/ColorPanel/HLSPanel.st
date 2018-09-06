ThreeSliderPanel subclass:#HLSPanel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

HLSPanel comment:'
 allows mixing of a color by hls values

HLSPanel new realize
 $Header: /cvs/stx/stx/clients/ColorPanel/HLSPanel.st,v 1.7 1996-06-12 18:31:13 cg Exp $
 written june 93 by claus
'!


!HLSPanel class methodsFor:'specification'!

slider1Class
    ^ SteppingHueSlider

!

slider3Class
    ^ SteppingSaturationSlider

!

sliderClass
    ^ SteppingColorSlider

! !

!HLSPanel methodsFor:'accessing'!

lightSlider
    ^ slider2
!

saturationSlider
    ^ slider3
!

setFrom:aColor
    self setSlider1:aColor hue 
	    slider2:aColor light
	    slider3:aColor saturation
! !

!HLSPanel methodsFor:'initialization'!

initialize
    super initialize.

    nameLabel1 label:'H'.
    nameLabel2 label:'L'.
    nameLabel3 label:'S'.

    slider1 start:0 stop:360.

    slider1 color:Color white; label:'hue'.
    slider2 color:Color white; label:'light'.
    slider3 color:Color white; label:'saturation'.

! !

!HLSPanel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/HLSPanel.st,v 1.7 1996-06-12 18:31:13 cg Exp $'
! !
