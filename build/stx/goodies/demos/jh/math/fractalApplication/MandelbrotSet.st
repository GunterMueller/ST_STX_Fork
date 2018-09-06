"{ Package: 'stx:goodies/demos/jh/math/fractalApplication' }"

"{ NameSpace: Demos }"

Object subclass:#MandelbrotSet
	instanceVariableNames:'realMin realMax imaginaryMin imaginaryMax deltaR deltaI colors'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-Mandelbrot'
!

!MandelbrotSet class methodsFor:'documentation'!

documentation
"
    Image of a Mandelbrot set with the middle at centre and of a certain size (extent),
    calculated using a maximum number to determine the colorrange.
    As a basis Bob Arnings Squeak implementation was used.

    I use the Mariani Silver algorithm to calculate my colors.
    If I cannot calculate the mandelbrot number within the maximum number of iterations,
    I consider it endless and the color is black.

    [author:]
	Bob Arning
	Jan Hussaarts (Jan@DESKTOPJAN)
"
! !

!MandelbrotSet class methodsFor:'instance creation'!

default
    ^ self new setDefault
!

realMin:aRealMin realMax:aRealMax imaginaryMin:anImaginaryMin imaginaryMax:anImaginaryMax
    ^ self new
	realMin:aRealMin
	realMax:aRealMax
	imaginaryMin:anImaginaryMin
	imaginaryMax:anImaginaryMax
! !

!MandelbrotSet methodsFor:'accessing'!

calculatePixel:aPixel
    |po qo maxColors x y steps c z0 z1|

    x := aPixel x.
    y := aPixel y.
    maxColors := colors size.
    po := realMin + (x * deltaR).
    qo := imaginaryMin + (y * deltaI).
    c := Complex real:po imaginary:qo.
    z0 := Complex real:0 imaginary:0.
    steps := 0.
    [
	z1 := (z0 * z0) + c.
	steps := steps + 1.
	z0 := z1.
	(steps > maxColors) or:[z0 abs > 16]
    ] whileFalse.
    ^ steps min:maxColors
!

calculatePixelY:aPixel
    |po qo x0 y0 x1 maxColors m xSquared ySquared x y steps|

    x := aPixel x.
    y := aPixel y.
    maxColors := colors size.
    m := 16.
    po := realMin + (x * deltaR).
    qo := imaginaryMin + (y * deltaI).
    xSquared := 0.0.
    x0 := 0.0.
    ySquared := 0.0.
    y0 := 0.0.
    steps := 0.
    [
	x1 := xSquared - ySquared + po.
	y0 := 2 * x0 * y0 + qo.
	x0 := x1.
	steps := steps + 1.
	(steps > maxColors)
	    or:[(xSquared := x0 squared) + (ySquared := y0 squared) > m]
    ] whileFalse.
^steps min:maxColors.
!

calculatePoint:aPixel
    |x y|

    x := aPixel x.
    y := aPixel y.
    ^ (realMin + (x * deltaR)) @ (imaginaryMin + (y * deltaI))
!

changeColors
    self initColors.
!

colorAtCentre: aRectangle
    |halfWidth halfHeigth|

    halfWidth := aRectangle origin x + ((aRectangle width / 2) floor).
    halfHeigth := aRectangle origin y + ((aRectangle height / 2) floor).
    ^ self calculatePixel:halfWidth @ halfHeigth
!

fillRectangle:aRectangle withColors:anArrayWithColors on:aView
    |halfWidth halfHeigth newColor1 origin corner newColor2 newColor4 newColor5 newColor3 halfWidthPlusOne halfHeigthPlusOne newColor6 newColor7 newColor8 newColor9 newColor10 newColor11 newColor12|

    aRectangle area <= 64 ifTrue:[
	(anArrayWithColors asSet size = 1) ifTrue:[
	    ((self colorAtCentre:aRectangle) = (anArrayWithColors at:1)) ifTrue:[
		aView paint:(colors at:(anArrayWithColors at:1)).
		aRectangle origin:(aRectangle origin - (1 @ 1)).
		aRectangle corner:(aRectangle corner + (1 @ 1)).
		^ aRectangle displayFilledOn:aView
	    ]
	]
    ].
    origin := aRectangle origin.
    corner := aRectangle corner.
    (aRectangle width <= 4 or:([aRectangle height <= 4])) ifTrue:[
	^ self
	    fillSmallRectangle:aRectangle
	    withColors:anArrayWithColors
	    on:aView
    ].
    halfWidth := origin x + ((aRectangle width / 2) floor).
    halfHeigth := origin y + ((aRectangle height / 2) floor).
    halfWidthPlusOne := halfWidth + 1.
    halfHeigthPlusOne := halfHeigth + 1.
    newColor1 := self calculatePixel:halfWidth @ origin y.
    newColor2 := self calculatePixel:halfWidth @ halfHeigth.
    newColor3 := self calculatePixel:origin x @ halfHeigth.
    newColor4 := self calculatePixel:halfWidthPlusOne @ origin y.
    newColor5 := self calculatePixel:corner x @ halfHeigth.
    newColor6 := self calculatePixel:halfWidthPlusOne @ halfHeigth.
    newColor7 := self calculatePixel:origin x @ halfHeigthPlusOne.
    newColor8 := self calculatePixel:halfWidth @ halfHeigthPlusOne.
    newColor9 := self calculatePixel:halfWidth @ corner y.
    newColor10 := self calculatePixel:halfWidthPlusOne @ halfHeigthPlusOne.
    newColor11 := self calculatePixel:corner x @ halfHeigthPlusOne.
    newColor12 := self calculatePixel:halfWidthPlusOne @ corner y.
    self
	fillRectangle:(Rectangle origin:(origin) corner:(halfWidth @ halfHeigth))
	withColors:(Array
		with:(anArrayWithColors at:1)
		with:(newColor1)
		with:(newColor2)
		with:(newColor3))
	on:aView.
    self
	fillRectangle:(Rectangle origin:(halfWidthPlusOne @ origin y)
		corner:(aRectangle corner x @ halfHeigth))
	withColors:(Array
		with:(newColor4)
		with:(anArrayWithColors at:2)
		with:(newColor5)
		with:(newColor6))
	on:aView.
    self
	fillRectangle:(Rectangle
		origin:(aRectangle origin x @ halfHeigthPlusOne)
		corner:(halfWidth @ aRectangle corner y))
	withColors:(Array
		with:newColor7
		with:(newColor8)
		with:(newColor9)
		with:(anArrayWithColors at:4))
	on:aView.
    self
	fillRectangle:(Rectangle origin:(halfWidthPlusOne @ halfHeigthPlusOne)
		corner:(aRectangle corner))
	withColors:(Array
		with:(newColor10)
		with:(newColor11)
		with:(anArrayWithColors at:3)
		with:(newColor12))
	on:aView
!

fillSmallRectangle:aRectangle withColors:anArrayWithColors on:aView
    |origin corner startX startY endX endY|

    origin := aRectangle origin.
    corner := aRectangle corner.
    startX := origin x.
    startY := origin y.
    endX := corner x.
    endY := corner y.
    startX to:endX do:[:anX |
	startY to:endY do:[:anY |
	    aView paint:(colors at:(self calculatePixel:anX @ anY)).
	    aView displayPoint:anX @ anY
	]
    ]
!

fitTo:aRectangle
    |origin corner|

    origin := self calculatePoint:aRectangle origin.
    corner := self calculatePoint:aRectangle corner.
    realMin := origin x.
    realMax := corner x.
    imaginaryMin := origin y.
    imaginaryMax := corner y.
!

imaginaryHeight
    ^ imaginaryMax - imaginaryMin
!

label
^'Mandelbrot set'
!

realWidth
    ^ realMax - realMin
!

update:aView
    |ext colors|
    deltaR := self realWidth / aView width.
    deltaI := self imaginaryHeight / aView height.
    ext := aView extent.
    colors := Array new:4.
    colors at:1 put:(self calculatePixel:0 @ 0).
    colors at:2 put:(self calculatePixel:0 @ ext y).
    colors at:3 put:(self calculatePixel:ext).
    colors at:4 put:(self calculatePixel:(ext x @ 0)).
    self
	fillRectangle:(Rectangle origin:0 @ 0 extent:ext)
	withColors:colors
	on:aView
!

zoomOutWith: aFraction
realMin := realMin - (aFraction * self realWidth).
realMax := realMax + (aFraction * self realWidth).
imaginaryMin := imaginaryMin - (aFraction * self imaginaryHeight).
imaginaryMax := imaginaryMax + (aFraction * self imaginaryHeight).
! !

!MandelbrotSet methodsFor:'initialization'!

initColors
    |steps max random|
	max := 64.
   colors := OrderedCollection new.
random := Random new.
    steps := (0 to: max) collect:[:i | (i / max) asFloat].
    steps do:[:i |
       colors add:(Color
		    r: random next
		    g:i
		    b:random next)
    ].
    steps do:[:i |
	colors add:(Color
		    r:random next
		    g:random next
		    b:i)
    ].
    steps do:[:i |
	colors add:(Color
		    r:i
		    g:random next
		    b:random next)
    ].
    colors add:Color black
!

realMin:aRealMin realMax:aRealMax imaginaryMin:anImaginaryMin imaginaryMax:anImaginaryMax
    realMin := aRealMin asLongFloat.
    realMax := aRealMax asLongFloat.
    imaginaryMin := anImaginaryMin asLongFloat.
    imaginaryMax := anImaginaryMax asLongFloat.
    colors isNil ifTrue:[
	self initColors
    ]
!

setDefault
    self
	realMin:-2.5
	realMax:1.5
	imaginaryMin:-1.5232
	imaginaryMax: 1.5232.
! !

!MandelbrotSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/MandelbrotSet.st,v 1.3 2008-10-26 13:45:19 cg Exp $'
! !
