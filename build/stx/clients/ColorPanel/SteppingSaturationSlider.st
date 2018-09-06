SteppingColorSlider subclass:#SteppingSaturationSlider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!


!SteppingSaturationSlider methodsFor:'initialization'!

createElements
    button1 := ArrowButton leftIn:self.
    button1 name:'LeftButton'.
    button2 := ArrowButton rightIn:self.
    button2 name:'RightButton'.
    thumb := SaturationSlider in:self.

    "Created: 12.6.1996 / 11:07:52 / cg"
! !

!SteppingSaturationSlider class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/SteppingSaturationSlider.st,v 1.1 1996-06-12 09:21:28 cg Exp $'
! !
