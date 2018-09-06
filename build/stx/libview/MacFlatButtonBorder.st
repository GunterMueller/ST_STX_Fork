"{ Encoding: utf8 }"

"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

SimpleBorder subclass:#MacFlatButtonBorder
	instanceVariableNames:'backgroundColor1 backgroundColor2 imgTopLeft imgTopRight
		imgBottomLeft imgBottomRight'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!MacFlatButtonBorder class methodsFor:'documentation'!

documentation
"
    an as yet unused and unfinished attempt to provide a mac-osx like
    button border. These will look like mac buttons in yosemite (i.e. ugly old 70s retro flat style).
    To be continued.
"
! !

!MacFlatButtonBorder class methodsFor:'instance creation'!

color:color1 backgroundColor:color2
    "create a new instance of the receiver with a border of the given color."

    ^ self new color:color1; backgroundColor:color2
!

color:color1 insideColor:color2
    "create a new instance of the receiver with a border of the given color."

    ^ self new color:color1; insideColor:color2
! !

!MacFlatButtonBorder class methodsFor:'image specs'!

topLeftImageFilled
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageFilled inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageFilled
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXRoundButtonBorder topLeftImageFilled'
        ifAbsentPut:[(Depth8Image width:4 height:4) bits:(ByteArray fromPackedString:'@@LB@PLA@P@B@P@@@P@@@@@a') colorMapFromArray:#[44 132 251 49 107 245 95 142 236 175 196 234] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'\OC0<@@a'); yourself); yourself]
!

topLeftImageUnfilled
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilled inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilled
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXRoundButtonBorder topLeftImageUnfilled'
        ifAbsentPut:[(Depth2Image width:4 height:4) bits:(ByteArray fromPackedString:'9HMOO0@a') colorMapFromArray:#[183 183 183 201 201 201 224 224 224 255 255 255] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'\OC0<@@a'); yourself); yourself]
!

topLeftImageUnfilledMasked
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXRoundButtonBorder topLeftImageUnfilledMasked'
        ifAbsentPut:[(Depth2Image width:4 height:4) bits:(ByteArray fromPackedString:'IHA@@@@a') colorMapFromArray:#[183 183 183 201 201 201 224 224 224 255 255 255] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'\NC@ @@a'); yourself); yourself]
!

topLeftImageUnfilledMasked2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked2 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXRoundButtonBorder topLeftImageUnfilledMasked2'
        ifAbsentPut:[(Depth2Image width:4 height:4) bits:(ByteArray fromPackedString:'IH!! @@@a') colorMapFromArray:#[183 183 183 201 201 201 224 224 224 255 255 255] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'\NC@ @@a'); yourself); yourself]
!

topLeftImageUnfilledMasked3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked3 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacOSXRoundButtonBorder topLeftImageUnfilledMasked3'
        ifAbsentPut:[(Depth2Image width:4 height:4) bits:(ByteArray fromPackedString:'HH  @@@a') colorMapFromArray:#[183 183 183 201 201 201 224 224 224 255 255 255] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'\NC@ @@a'); yourself); yourself]
!

topLeftImageUnfilledMasked4
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked4 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacFlatButtonBorder topLeftImageUnfilledMasked4'
        ifAbsentPut:[(Depth2Image width:4 height:4) bits:(ByteArray fromPackedString:'HH,/O0@a') colorMapFromArray:#[183 183 183 201 201 201 224 224 224 255 255 255] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'\OC0<@@a'); yourself); yourself]
!

topLeftImageUnfilledMasked5
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked5 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked5
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacFlatButtonBorder topLeftImageUnfilledMasked5'
        ifAbsentPut:[(Depth2Image width:4 height:4) bits:(ByteArray fromPackedString:'HH<?O0@a') colorMapFromArray:#[183 183 183 201 201 201 224 224 224 255 255 255] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'\OC0<@@a'); yourself); yourself]
!

topLeftImageUnfilledMasked6
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self topLeftImageUnfilledMasked6 inspect
     ImageEditor openOnClass:self andSelector:#topLeftImageUnfilledMasked6
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'MacFlatButtonBorder topLeftImageUnfilledMasked6'
        ifAbsentPut:[(Depth2Image width:4 height:4) bits:(ByteArray fromPackedString:'@@<?O0@a') colorMapFromArray:#[183 183 183 201 201 201 224 224 224 255 255 255] mask:((ImageMask width:4 height:4) bits:(ByteArray fromPackedString:'LGC0<@@a'); yourself); yourself]
! !

!MacFlatButtonBorder methodsFor:'accessing'!

backgroundColor1
    "the first gradient color"

    ^ backgroundColor1
!

backgroundColor1:newColor
    "the first gradient color"

    backgroundColor1 ~= newColor ifTrue:[        
        backgroundColor1 := newColor.
        imgTopLeft := imgTopRight := imgBottomLeft := imgBottomRight := nil.
    ]
!

backgroundColor2
    "the second gradient color"

    ^ backgroundColor2
!

backgroundColor2:newColor
    "the second gradient color"

    backgroundColor2 ~= newColor ifTrue:[        
        backgroundColor2 := newColor.
        imgTopLeft := imgTopRight := imgBottomLeft := imgBottomRight := nil.
    ]
!

color:newColor
    "the color of the border"
    
    color ~= newColor ifTrue:[        
        color := newColor.
        imgTopLeft := imgTopRight := imgBottomLeft := imgBottomRight := nil.
    ].
! !

!MacFlatButtonBorder methodsFor:'displaying'!

displayOn:aGC forDisplayBox:aRectangle
    |oldPaint boxLeft boxRight boxTop boxBottom boxWidth boxHeight|

    color isNil ifTrue:[ ^ self].

    oldPaint := aGC paint.

    boxLeft := aRectangle left.
    boxTop := aRectangle top.
    boxWidth := aRectangle width.
    boxHeight := aRectangle height.

    boxRight := boxLeft + boxWidth.
    boxBottom := boxTop + boxHeight.
    
    imgTopLeft isNil ifTrue:[
        self makeImages.
        imgTopLeft isNil ifTrue:[
            ^ self
        ].    
    ].    
    aGC container isNil ifTrue:[
        aGC paint:(aGC viewBackground).
    ] ifFalse:[
        aGC paint:(aGC container viewBackground).
    ].
    aGC fillRectangleX:boxLeft y:boxTop width:2 height:2.
    aGC fillRectangleX:boxRight-2 y:boxTop width:2 height:2.
    aGC fillRectangleX:boxRight-2 y:boxBottom-2 width:2 height:2.
    aGC fillRectangleX:boxLeft y:boxBottom-2 width:2 height:2.

    aGC displayImage:imgTopLeft x:boxLeft y:boxTop.
    aGC displayImage:imgTopRight x:boxRight-4 y:boxTop.
    aGC displayImage:imgBottomRight x:boxRight-4 y:boxBottom-4.
    aGC displayImage:imgBottomLeft x:boxLeft y:boxBottom-4.

    aGC paint:color.
    aGC displayLineFromX:boxLeft+4 y:boxTop toX:boxRight-4 y:boxTop.
    aGC displayLineFromX:boxLeft+4 y:boxBottom-1 toX:boxRight-4 y:boxBottom-1.
    aGC displayLineFromX:boxLeft y:boxTop+4 toX:boxLeft y:boxBottom-4.
    aGC displayLineFromX:boxRight-1 y:boxTop+4 toX:boxRight-1 y:boxBottom-4.

    aGC paint:oldPaint.

    "
     |v1 v2|

     v1 := TopView new.
     v2 := View origin:10@10 corner:100@30 in:v1.
     v2 border:(MacFlatButtonBorder color:Color red).
     v1 open.
    "
    "
     |v1 v2|

     v1 := TopView new.
     v2 := View origin:10@10 corner:100@30 in:v1.
     v2 border:((MacFlatButtonBorder color:Color red) backgroundColor1:Color blue; backgroundColor2:Color green).
     v1 open.
    "
! !

!MacFlatButtonBorder methodsFor:'private'!

makeImages
    |protoImage img hue light sat|
    
    hue := color hue.
    light := color light.
    sat := color saturation.

    protoImage := self class topLeftImageUnfilledMasked6.
    img := protoImage copy.

    img colorMap at:1 put:color.
    hue notNil ifTrue:[
        img colorMap at:2 put:(Color hue:hue light:light+15 saturation:sat-12).
        img colorMap at:3 put:(Color hue:hue light:light+30 saturation:sat-40).
    ].    
    imgTopLeft := img.
    imgTopRight := img rotated:90.
    imgBottomLeft := img rotated:-90.
    imgBottomRight := img rotated:180.

    backgroundColor1 notNil ifTrue:[ 
        imgTopLeft colorMap at:4 put:backgroundColor1. 
        imgTopRight colorMap at:4 put:backgroundColor1. 
    ].
    backgroundColor2 notNil ifTrue:[ 
        imgBottomLeft colorMap at:4 put:backgroundColor2. 
        imgBottomRight colorMap at:4 put:backgroundColor2. 
    ].
    
"/    imgBottomRight colorMap at:1 put:color darkened. 
"/    imgBottomRight colorMap at:2 put:color slightlyDarkened. 
"/    imgBottomRight colorMap at:3 put:color slightlyDarkened. 
! !

!MacFlatButtonBorder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

