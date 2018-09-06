"{ Package: 'stx:goodies/demos/jh/math/fractalApplication' }"

"{ NameSpace: Demos }"

MandelbrotSet subclass:#JuliaSet
	instanceVariableNames:'c lowerLimit'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-Mandelbrot'
!

!JuliaSet class methodsFor:'documentation'!

documentation
"
    JuliaSet. Fractal. Can draw itself on a view.

    [author:]
	Jan Hussaarts (Jan@DESKTOPJAN)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"


								[exBegin]
 FractalApplication new openJulia
								[exEnd]
"
!

history
    "Created: / 24.5.2003 / 00:17:17 / Jan"
! !

!JuliaSet class methodsFor:'instance creation'!

realMin:aRealMin realMax:aRealMax imaginaryMin:anImaginaryMin imaginaryMax:anImaginaryMax c:aC
    ^ (self
	realMin:aRealMin
	realMax:aRealMax
	imaginaryMin:anImaginaryMin
	imaginaryMax:anImaginaryMax) c:aC
! !

!JuliaSet methodsFor:'accessing'!

calculatePixel:aPixel
    |po qo maxColors x y steps  z1 z0|

    x := aPixel x.
    y := aPixel y.
    maxColors := colors size.
    po := realMin + (x * deltaR).
    qo := imaginaryMin + (y * deltaI).
    z0 := Complex real:po imaginary:qo.
    steps := 0.
    [
	z1 := (z0 * z0) + c.
	steps := steps + 1.
	z0 := z1.
	(steps > maxColors) or:[z0 abs > lowerLimit]
    ] whileFalse.
    ^ steps min:maxColors
!

label
^'Julia set'
! !

!JuliaSet methodsFor:'initialization'!

c:aC
    c := aC.
    lowerLimit := ((c abs sqrt) + 1).
!

colors:aSetOfColors
    colors := aSetOfColors
!

setDefault
   self
	realMin:-2.5
	realMax: 2.5
	imaginaryMin:-1.5232
	imaginaryMax: 1.5232.
    self c:(Complex real: -1.4 imaginary: 0).
    self initColors
! !

!JuliaSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/JuliaSet.st,v 1.3 2008-10-26 13:45:19 cg Exp $'
! !
