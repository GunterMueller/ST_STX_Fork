HorizontalSteppingSlider subclass:#SteppingColorSlider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!


!SteppingColorSlider methodsFor:'initialization'!

createElements
    button1 := ArrowButton leftIn:self.
    button1 name:'LeftButton'.
    button2 := ArrowButton rightIn:self.
    button2 name:'RightButton'.
    thumb := ColorSlider in:self.


! !

!SteppingColorSlider class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/SteppingColorSlider.st,v 1.3 1996-06-12 09:21:05 cg Exp $'
! !
