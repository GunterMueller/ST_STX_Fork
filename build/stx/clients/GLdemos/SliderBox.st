"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Smalltalk }"

View subclass:#SliderBox
	instanceVariableNames:'framedBox1 slider1 slider2 slider3 label1 label2 label3'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!


!SliderBox methodsFor:'accessing'!

label:aLabel
    framedBox1 label:aLabel
!

xSlider
    ^ slider1
!

ySlider
    ^ slider2
!

zSlider
    ^ slider3
! !

!SliderBox methodsFor:'initialization'!

initialize
    "This method was created by the interface builder"

    super initialize.
    self setupSubViews.
    self setupLocalStuff
!

setupLocalStuff
    "This method was created by the interface builder"

    ^ self
!

setupSubViews
    "This method was created by the interface builder"

    self extent:177@346.
    framedBox1 := FramedBox new.
    self addSubView:framedBox1.
    framedBox1 origin:(0@0) extent:(177@346).
    framedBox1 label:'scale'.
    slider1 := Slider new.
    framedBox1 addSubView:slider1.
    slider1 origin:(19@64) extent:(22@263).
    slider2 := Slider new.
    framedBox1 addSubView:slider2.
    slider2 origin:(73@64) extent:(22@263).
    slider3 := Slider new.
    framedBox1 addSubView:slider3.
    slider3 origin:(127@64) extent:(22@263).
    label1 := Label new.
    framedBox1 addSubView:label1.
    label1 origin:(23@37) extent:(14@22).
    label1 label:'X'.
    label2 := Label new.
    framedBox1 addSubView:label2.
    label2 origin:(77@37) extent:(14@22).
    label2 label:'Y'.
    label3 := Label new.
    framedBox1 addSubView:label3.
    label3 origin:(130@37) extent:(14@22).
    label3 label:'Z'.
    ^ self
! !

!SliderBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/SliderBox.st,v 1.4 2016-01-21 18:06:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/SliderBox.st,v 1.4 2016-01-21 18:06:10 cg Exp $'
! !

