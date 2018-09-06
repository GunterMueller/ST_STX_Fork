"{ Package: 'stx:goodies/demos/jh/math/fractalApplication' }"

"{ NameSpace: Demos }"

View subclass:#FractalView
	instanceVariableNames:'cache'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-Mandelbrot'
!


!FractalView methodsFor:'accessing'!

cache
    cache isNil ifTrue:[
        cache := Form
                    width:self width
                    height:self height
                    depth:self device depth
                    onDevice:self device.
       model update: self.
    ].
    ^ cache
!

changeColors
    self model changeColors.
    self invalidate
!

createCache
    cache := Form
                width: self width
                height:self height
                depth:(self device depth)
                onDevice:device.
    cache clear

    "Modified: / 01-08-2013 / 13:56:36 / cg"
!

invalidate
    super invalidate.
    self model update:self
!

pointFromUser
    | point|

    point := self device pointFromUser.
    ^ (1 @ 1) + point - (self originRelativeTo:nil)
!

reset
    self model setDefault.
    self invalidate
!

zoomIn
    |rectangle relRectangle|

    rectangle := Rectangle fromUser.
    relRectangle := Rectangle
		origin:(1 @ 1 + rectangle origin - (self originRelativeTo:nil))
		extent:rectangle extent.
    self model fitTo:relRectangle.
    self invalidate
!

zoomOut
    self model zoomOutWith: 0.25.
    self invalidate
! !

!FractalView methodsFor:'drawing'!

displayPoint:aPoint
    self cache displayPoint:aPoint.
    super displayPoint:aPoint
!

fillRectangleX:left y:top width:width height:height
    self cache
	fillRectangleX:left
	y:top
	width:width
	height:height.
    super
	fillRectangleX:left
	y:top
	width:width
	height:height
!

paint:aColor
    self cache paint:aColor.
    super paint:aColor
!

redrawX:x y:y width:w height:h
    self extent = self cache extent ifTrue:[
	^ self
	    copyFrom:self cache
	    x:x
	    y:y
	    toX:x
	    y:y
	    width:w
	    height:h
    ] ifFalse:[
	self clear.
	self createCache.
	^ super
	    redrawX:0
	    y:0
	    width:self width
	    height:self height
    ]
!

sizeChanged:how
    how = #smaller ifTrue:[
	self createCache.
	self model update:self
    ]
! !

!FractalView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/FractalView.st,v 1.6 2013-08-01 12:07:31 cg Exp $'
! !

