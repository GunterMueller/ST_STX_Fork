"{ NameSpace: Demos }"

GlobeDemo subclass:#RoundGlobe
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Animations'
!

!RoundGlobe class methodsFor:'documentation'!

documentation
"
    suns globes - round.
    Notice: not all systems support round shaped windows.

    [author:]
        Claus Gittinger - written spring 90

    [start with:]
        RoundGlobe open

    [see also:]
        GlobeDemo
        Image
"
! !

!RoundGlobe methodsFor:'handling size changes'!

sizeChanged:how of:aView
    self computeShape.
    aView sizeChanged:how
! !

!RoundGlobe methodsFor:'initialization'!

realize
    self label:'RoundGlobe'.
    super realize.
    self computeShape

    "RoundGlobe open"
! !

!RoundGlobe methodsFor:'shape computation'!

computeShape
    |extent shapeForm borderForm bw|

    extent := self extent.
    borderForm := Form width:width height:height depth:1 on:device.
    borderForm fill:(Color colorId:0).
    shapeForm := Form width:width height:height depth:1 on:device.
    shapeForm fill:(Color colorId:0).

    borderForm foreground:(Color colorId:1).
    shapeForm foreground:(Color colorId:1).

    borderForm fillArcX:0 y:0 
		      w:(borderForm width)
		      h:(borderForm height)
		   from:0
		  angle:360.
    bw := 3.
    shapeForm fillArcX:bw y:bw 
		     w:(shapeForm width - (bw * 2))
		     h:(shapeForm height - (bw * 2))
		   from:0
		  angle:360.
    self borderShape:borderForm.
    self viewShape:shapeForm
! !

!RoundGlobe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Animation/RoundGlobe.st,v 1.8 1997-01-08 11:38:23 cg Exp $'
! !
