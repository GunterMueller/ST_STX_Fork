SteppingColorSlider subclass:#SteppingHueSlider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!


!SteppingHueSlider methodsFor:'initialization'!

createElements
    button1 := ArrowButton leftIn:self.
    button1 name:'LeftButton'.
    button2 := ArrowButton rightIn:self.
    button2 name:'RightButton'.
    thumb := HueSlider in:self.





! !

!SteppingHueSlider class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/SteppingHueSlider.st,v 1.3 1996-06-12 09:21:18 cg Exp $'
! !
