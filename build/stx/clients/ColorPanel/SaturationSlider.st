ColorSlider subclass:#SaturationSlider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!


!SaturationSlider methodsFor:'drawing'!

drawThumb
    baseColor hue isNil ifTrue:[
        ^ self
    ].
    super drawThumb

    "Created: 15.6.1996 / 11:35:40 / cg"
! !

!SaturationSlider methodsFor:'private'!

color:aColor
    |oldHue newHue oldLight newLight|

    (baseColor isNil
    or:[
        oldHue := baseColor hue.
        newHue := aColor hue.
        oldLight := baseColor light.
        newLight := aColor light.

        oldHue isNil 
        or:[newHue isNil
        or:[(oldHue roundTo:3) ~= (newHue roundTo:3)
        or:[(oldLight roundTo:10) ~= (newLight roundTo:10)]]]
    ]) ifTrue:[
"/'change oldHue:' print. (oldHue roundTo:3) print.
"/' newHue: ' print. (newHue roundTo:3) printCR.        
"/'oldLight:' print. (oldLight roundTo:10) print.
"/' newLight: ' print. (newLight roundTo:10) printCR.        

        super color:aColor

"/        baseColor := aColor.
"/        self getColors.
"/        shown ifTrue:[
"/            self setBgPattern.
"/            self invalidate
"/        ]
    ]

    "Created: 12.6.1996 / 11:01:01 / cg"
    "Modified: 15.6.1996 / 11:38:48 / cg"
!

getColors
    |h visual|

    ((visual := device visualType) ~~ #TrueColor
    and:[visual ~~ #StaticGray]) ifTrue:[
        colors := nil.
        ^ self
    ].

    h := baseColor hue.
    h notNil ifTrue:[
        colors := Array new:nColors.

        1 to:nColors do:[:i |
            colors at:i put:(Color hue:h
                                 light:50
                            saturation:(100.0 / nColors * i))
        ]
    ] ifFalse:[
        super color:Black
    ]

    "Modified: 15.6.1996 / 10:46:33 / cg"
!

getDitherColors
    |h l s clr0 clr ditherColors|

    h := baseColor hue.
    h isNil ifTrue:[
        "/ no hue
        ^ Array with:(Color grey:(baseColor light)) 
                with:(Color grey:(baseColor light))
    ].

    clr0 := Color hue:h light:50 saturation:100.
    l := 50.
    s := 100.

    ditherColors := Array new:4.
    (clr := clr0 exactOn:device) notNil ifTrue:[
        ditherColors at:4 put:clr.
        (clr := (Color hue:h
                       light:l
                       saturation:(s * 0.67)) exactOn:device) notNil ifTrue:[
            ditherColors at:3 put:clr.
            (clr := (Color hue:h
                         light:l
                    saturation:(s * 0.33)) exactOn:device) notNil ifTrue:[
                ditherColors at:2 put:clr.
                ditherColors at:1 put:(Color grey:(clr0 grayIntensity)).
                ^ ditherColors
            ]
        ].
        ditherColors := nil.
    ].

    ^ Array with:(Color grey:(clr0 grayIntensity))
            with:(clr0)

    "Created: 15.6.1996 / 09:50:59 / cg"
    "Modified: 15.6.1996 / 13:03:54 / cg"
! !

!SaturationSlider class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/SaturationSlider.st,v 1.2 1996-06-15 11:48:59 cg Exp $'
! !
