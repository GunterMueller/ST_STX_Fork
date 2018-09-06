"{ NameSpace: Demos }"

StandardSystemView subclass:#ButtonFlyExample
	instanceVariableNames:'subview subButton autoJump sizeSlider speedSlider contBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Tutorial'
!

ButtonFlyExample comment:'

Tutorial example - a view with a subview;
Goal: catch the moving button ...

    ButtonFlyExample open


$Header: /cvs/stx/stx/clients/Demos/ButtonFly.st,v 1.11 1999-09-01 22:13:04 cg Exp $
written fall 93 by andreas as a first try

claus: andreas was totally new to smalltalk - it took him
       four hours, to learn enough of the language, and
       of the st/x classes to create this little demo.
'!

!ButtonFlyExample class methodsFor:'documentation'!

documentation
"
    Tutorial example - a view with a subview;
    Goal: catch the moving button ...

    claus: andreas was totally new to smalltalk when he wrote this
           - it took him four hours, to learn enough of the language, 
           and of the st/x classes to create this little demo.

    [start with:]
        ButtonFlyExample open

    [author:]
        Andreas Haemmerle (fall '93)
"

! !

!ButtonFlyExample methodsFor:'actions'!

abortAutoJump
    contBlock isNil ifFalse: [
        Processor removeTimedBlock:contBlock.
        subButton label:'press me'.
        subButton pressAction:[subButton label:'catch me'. contBlock value].
   ]

    "Modified: / 14.3.1998 / 16:24:55 / cg"
!

centerButton
    subButton origin:[(subview width - subButton width // 2)
                        @ 
                        (subview height - subButton height // 2)].

    self moveTo:#moveToLeftUpperCorner

    "Modified: / 14.3.1998 / 16:22:39 / cg"
!

destroy

    super destroy.

    Processor removeTimedBlock:contBlock.
!

maximizeButton
    subButton origin:[((subview width // 2) - (subview width // 4))
                        @ 
                        ((subview height // 2) - (subview height // 4))]
                 extent:[(subview width // 2)
                          @ 
                          ( subview height // 2)]

    "Modified: / 14.3.1998 / 16:22:34 / cg"
!

minimizeButton
    subButton origin:[((subview width // 2) - (subview width // 8))
                        @ 
                        ((subview height // 2) - (subview height // 8))]
                 extent:[(subview width // 4)
                          @ 
                          ( subview height // 4)]

    "Modified: / 14.3.1998 / 16:22:32 / cg"
!

moveTo:where
    autoJump ifTrue:[
        contBlock := [self perform:where].
        subButton pressAction:[self abortAutoJump].
        Processor addTimedBlock:contBlock 
                   afterSeconds: (speedSlider thumbOrigin roundTo:0.05).
    ] ifFalse: [
        subButton pressAction:[self perform:where].
    ]

    "Modified: / 14.3.1998 / 16:22:28 / cg"
!

moveToLeftLowerCorner
    subButton origin:[ 0 @ (subview height - subButton height) ].
    self moveTo:#centerButton

    "Modified: / 14.3.1998 / 16:22:25 / cg"
!

moveToLeftUpperCorner
    subButton origin:[0 @ 0].
    self moveTo:#moveToRightUpperCorner

    "Modified: / 14.3.1998 / 16:22:22 / cg"
!

moveToRightLowerCorner
    subButton origin:[ (subview width - subButton width)
                         @ 
                       (subview height - subButton height) ].

    self moveTo:#moveToLeftLowerCorner

    "Modified: / 14.3.1998 / 16:22:19 / cg"
!

moveToRightUpperCorner
    subButton origin:[(subview width - subButton width) @ 0].
    self moveTo:#moveToRightLowerCorner

    "Modified: / 14.3.1998 / 16:22:06 / cg"
!

realize

    self sizeChanged:nil.

    super realize.
!

speedSliderChanged
    contBlock isNil ifFalse: [
"/ speedSlider thumbOrigin printCR.
        Processor removeTimedBlock:contBlock.
        Processor addTimedBlock:contBlock 
                   afterSeconds:(speedSlider thumbOrigin roundTo:0.05).
   ]

    "Modified: / 14.3.1998 / 16:22:15 / cg"
! !

!ButtonFlyExample methodsFor:'initialization'!

initialize
    |hPixelPerMM vPixelPerMM sliderView labelView speedLabel sizeLabel|

    super initialize.

    self label:'Turorial Example'.

    hPixelPerMM := self horizontalPixelPerMillimeter rounded asInteger.
    vPixelPerMM := self verticalPixelPerMillimeter rounded asInteger.

"................."

    labelView := View origin:[hPixelPerMM @ vPixelPerMM]
                       extent:[(hPixelPerMM * 40)
                                @ 
                               ((vPixelPerMM * 3) + (vPixelPerMM * 10))
                              ]
                            in:self.

    labelView level:0.
    labelView borderWidth:0.

"................."

    speedLabel := Label origin:[hPixelPerMM @ vPixelPerMM]
                            in:labelView.

    speedLabel label:'speed :  5 sec.'.
    speedLabel sizeFixed:true; adjust:#left.

    sizeLabel := Label origin:[hPixelPerMM @ ((vPixelPerMM * 2) + (vPixelPerMM * 5))]
                           in:labelView.

    sizeLabel label:'size  : 25 %   '. 
    sizeLabel sizeFixed:true; adjust:#left.

"................."

    sliderView := View origin:[(hPixelPerMM + labelView width + hPixelPerMM) @ vPixelPerMM]
                       extent:[(width - (hPixelPerMM * 3) - labelView width)
                                @ 
                               ((vPixelPerMM * 3) + (vPixelPerMM * 10))
                              ]
                            in:self.

    sliderView level:0.
    sliderView borderWidth:0.

"................."

    speedSlider := HorizontalSlider in:sliderView.

    speedSlider origin:(hPixelPerMM @ vPixelPerMM)
                extent:[(sliderView width - (hPixelPerMM * 2)) @ (vPixelPerMM * 5)].

    speedSlider thumbOrigin:50.
    speedSlider start:0.05 stop:1 step:0.05.
    speedSlider scrollAction:[:speed | 
                                speedLabel label:'speed : ',
                                      ((speed roundTo:0.05) printStringRightAdjustLen:2),
                                      ' sec.'.
                               self speedSliderChanged].

"................."

    sizeSlider  := HorizontalSlider in:sliderView.

    sizeSlider origin:[hPixelPerMM @ (speedSlider bottom + vPixelPerMM)]
               extent:[(sliderView width - (hPixelPerMM * 2)) @ (vPixelPerMM * 5)].

    sizeSlider thumbOrigin:50.

    sizeSlider scrollAction:[:percent | sizeLabel label:'size  : ',
                                                        ((percent // 2) rounded printStringRightAdjustLen:2),
                                                        ' %'.
                              subButton containerChangedSize].

"................."

    subview := View origin:[hPixelPerMM @ (sliderView bottom + vPixelPerMM)]
                    extent:[(width - (hPixelPerMM * 2))
                             @ 
                            (height - (2 * (vPixelPerMM * 2)) - (sliderView height))
                           ]
                        in:self.

    subview level:-1.

"................."

    subButton := Button origin:[((subview width // 2) - ((subview width / 400 * sizeSlider thumbOrigin) rounded))
                                 @ 
                                ((subview height // 2) - ((subview height / 400 * sizeSlider thumbOrigin) rounded))
                               ]
                        extent:[(subview width / 200 * sizeSlider thumbOrigin) rounded
                                 @ 
                                (subview height / 200 * sizeSlider thumbOrigin) rounded
                               ]
                            in:subview.

    autoJump := true.

    subButton pressAction:[subButton label:'catch me'. self moveToLeftUpperCorner].
    subButton label:'press me'.
"
    subButton pressAction:[self maximizeButton]
    subButton releaseAction:[self minimizeButton].
"

    "ButtonFlyExample open"

    "Modified: / 14.3.1998 / 16:23:07 / cg"
! !

!ButtonFlyExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ButtonFly.st,v 1.11 1999-09-01 22:13:04 cg Exp $'
! !
