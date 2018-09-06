ColorSlider subclass:#HueSlider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!


!HueSlider methodsFor:'accessing'!

color:dummyColor
    |n keep|

    device visualType == #PseudoColor ifTrue:[
        "get these first, to give code below a chance of dithering"
        keep := OrderedCollection new.
        0 to:330 by:30 do:[:hue |
            keep add:((Color hue:hue light:50 saturation:100) on:device).
        ]
    ].

    n := 40.

    colors := Array new:n.
    1 to:n do:[:i |
        colors at:i put:(Color hue:(360 / n * i - (n // 2))
                             light:50
                        saturation:100)
    ].
    shown ifTrue:[
        self setBgPattern.
        self redraw
    ]
!

getColors
    |n keep|

    device visualType ~~ #TrueColor ifTrue:[
        "get these first, to give code below a chance of dithering"
        keep := OrderedCollection new.
        0 to:330 by:30 do:[:hue |
            keep add:((Color hue:hue light:50 saturation:100) on:device).
        ].

        n := 40.
    ] ifFalse:[
        n := 100.
    ].

    colors := Array new:n.
    1 to:n do:[:i |
        colors at:i put:(Color hue:(360 / n * i - (n // 2))
                             light:50
                        saturation:100)
    ].
! !

!HueSlider methodsFor:'private'!

setBgPattern
    self setTrueBgPattern

    "Created: 15.6.1996 / 13:41:04 / cg"
! !

!HueSlider  class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/HueSlider.st,v 1.7 1996-08-16 12:46:41 cg Exp $'
! !
