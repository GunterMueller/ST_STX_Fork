View subclass:#ThreeSliderPanel
	instanceVariableNames:'slider1 slider2 slider3 label1 label2 label3 nameLabel1
		nameLabel2 nameLabel3 action val1 val2 val3'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

ThreeSliderPanel comment:'
 abstract for RGB and HLS panels

ThreeSliderPanel new realize
 $Header: /cvs/stx/stx/clients/ColorPanel/ThreeSliderPanel.st,v 1.4 1996-06-12 11:02:35 cg Exp $
 written june 93 by claus
'!


!ThreeSliderPanel class methodsFor:'specification'!

slider1Class
    ^ self sliderClass
!

slider2Class
    ^ self sliderClass
!

slider3Class
    ^ self sliderClass
!

sliderClass
    ^ HorizontalSlider 
! !

!ThreeSliderPanel methodsFor:'accessing'!

action:aBlock
    action := aBlock
!

setSlider1:v1 slider2:v2 slider3:v3
    |v|

    v1 notNil ifTrue:[
	v := v1 rounded.
	v ~= val1 ifTrue:[
	    slider1 thumbOrigin:v.
	    label1 label:v printString.
	    val1 := v.
	].
    ].
    v2 notNil ifTrue:[
	v := v2 rounded.
	v ~= val2 ifTrue:[
	    slider2 thumbOrigin:v.
	    label2 label:v printString.
	    val2 := v.
	]
    ].
    v3 notNil ifTrue:[
	v := v3 rounded.
	v ~= val3 ifTrue:[
	    slider3 thumbOrigin:v.
	    label3 label:v printString.
	    val3 := v
	]
    ]
! !

!ThreeSliderPanel methodsFor:'initialization'!

initialize
    |l h sep r helper wl|

    super initialize.

    font := font on:device.
    wl := font widthOf:'000'.

    sep := (device horizontalPixelPerMillimeter) rounded.
    h := (device verticalPixelPerMillimeter *5) rounded.

    helper := VerticalPanelView 
                    origin:(0.0 @ 0.0)
                    corner:(0.0 @ 1.0)
                        in:self.

    nameLabel1 := Label label:'W' in:helper.
    nameLabel1 adjust:#right; borderWidth:0; sizeFixed:true.

    nameLabel2 := Label label:'W' in:helper.
    nameLabel2 adjust:#right; borderWidth:0; sizeFixed:true.

    nameLabel3 := Label label:'W' in:helper.
    nameLabel3 adjust:#right; borderWidth:0; sizeFixed:true.

    helper rightInset:(nameLabel1 preferredExtent x + sep) negated.
    helper verticalInset:sep.
    helper borderWidth:0.

    helper := VerticalPanelView 
                    origin:(1.0 @ 0.0)
                    corner:(1.0 @ 1.0)
                        in:self.
    helper leftInset:(wl + sep + sep) negated.
    helper verticalInset:sep.
    helper borderWidth:0.

    label1 := Label label:'999' in:helper.
    label1 adjust:#right; borderWidth:0; sizeFixed:true.
    label1 label:'  0'.

    label2 := Label label:'999' in:helper.
    label2 adjust:#right; borderWidth:0; sizeFixed:true.
    label2 label:'  0'.

    label3 := Label label:'999' in:helper.
    label3 adjust:#right; borderWidth:0; sizeFixed:true.
    label3 label:'  0'.

    helper := VerticalPanelView 
                    origin:(0.0 @ 0.0)
                    corner:(1.0 @ 1.0)
                        in:self.
    helper rightInset:(label1 width + sep + sep).
    helper leftInset:(nameLabel1 preferredExtent x + sep + sep).
    helper borderWidth:0.
    helper horizontalLayout:#fit.

    slider1 := (self class slider1Class) origin:(0.0 @ 0.0) extent:(1.0 @ h) in:helper.
    slider1 scrollAction:[:value | self slider1:value].

    slider2 := (self class slider2Class) origin:(0.0 @ 0.34) extent:(1.0 @ h) in:helper.
    slider2 scrollAction:[:value | self slider2:value].

    slider3 := (self class slider3Class) origin:(0.0 @ 0.66) extent:(1.0 @ h) in:helper.
    slider3 scrollAction:[:value | self slider3:value].

    action := [:r :g :b | ].
    val1 := 0.
    val2 := 0.
    val3 := 0.
! !

!ThreeSliderPanel methodsFor:'user interaction'!

slider1:val
    |v|

    v := val rounded.
    label1 label:v printString.
    val1 := v.
    action value:val1 value:val2 value:val3
!

slider2:val
    |v|

    v := val rounded.
    label2 label:v printString.
    val2 := v.
    action value:val1 value:val2 value:val3
!

slider3:val
    |v|

    v := val rounded.
    label3 label:v printString.
    val3 := v.
    action value:val1 value:val2 value:val3
! !

!ThreeSliderPanel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/ThreeSliderPanel.st,v 1.4 1996-06-12 11:02:35 cg Exp $'
! !
