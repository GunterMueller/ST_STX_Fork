"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

View subclass:#ImageView
	instanceVariableNames:'image magnifiedImage adjust magnificationFactor tileMode
		tileOffset lastMousePoint adjustHolder'
	classVariableNames:'DoNotMagnifyQuery'
	poolDictionaries:''
	category:'Views-Misc'
!

!ImageView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This View knows how to display a (bitmap-)image (or form).

    You can display an image with:

        ImageView openOn:anImageFileName
    or:
        ImageView openOnImage:anImage
    or:
        ImageView new image:anImage

    i.e.

        ImageView openOn:'../../goodies/bitmaps/gifImages/garfield.gif'
        ImageView openOn:'../../goodies/bitmaps/SBrowser.xbm'

        ImageView openOnImage:(Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif')
        ImageView openOnImage:(Image fromFile:'../../goodies/bitmaps/SBrowser.xbm')

    adjust:
        controls how images are displayed;
        can be one of:
            #topLeft    - image is displayed as usual
            #center     - image is shown centered
            #fitBig     - big images are shrunk to make it fit the view
            #fitSmall   - small images are magnified to make it fit the view,
            #fit        - all images are magnified to fit the view

    [author:]
        Claus Gittinger

    [see also:]
        Image Form
"
!

examples
"
    |top imgView scrView|

    top := StandardSystemView new.
    top extent:300@300.

    imgView := ImageView new.
    imgView image:(Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif').

    scrView := HVScrollableView forView:imgView.
    scrView origin:0@0 corner:1.0@1.0.
    top add:scrView.

    top open.
"
! !

!ImageView class methodsFor:'initialization'!

initialize
    DoNotMagnifyQuery isNil ifTrue:[
        DoNotMagnifyQuery := QuerySignal new defaultAnswer:false.
    ].
! !

!ImageView class methodsFor:'menu specs'!

middleButtonMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ImageView andSelector:#middleButtonMenu
     (Menu new fromLiteralArrayEncoding:(ImageView middleButtonMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Size to Fit'
            choice: adjustHolder
            choiceValue: fitBig
          )
         (MenuItem
            label: 'Original Size'
            choice: adjustHolder
            choiceValue: #topLeft
          )
         )
        nil
        nil
      )
! !

!ImageView class methodsFor:'queries-plugin'!

aspectSelectors
    ^ #( imageChannel )

    "Created: / 11.2.2000 / 00:37:33 / cg"
! !

!ImageView class methodsFor:'startup'!

openOn:anImageOrFileName
    "startup an image viewer on an image read from a file"

    anImageOrFileName isImage ifTrue:[
        ^ self openOnImage:anImageOrFileName
    ].
    ^ self openOnFile:anImageOrFileName

    "
     ImageView openOn:'bitmaps/gifImages/garfield.gif'
     ImageView openOn:'bitmaps/xpmBitmaps/misc_icons/BOOK.xpm'
    "

    "Modified: / 31.10.1997 / 16:17:52 / cg"
!

openOnFile:aFileName
    "startup an image viewer on an image read from a file"

    |fn imageView img e|

    fn := aFileName asFilename.

    img := Image fromFile:fn.
    img isNil ifTrue:[
        fn exists ifTrue:[
            e := 'Unknown or unsupported image format.'
        ] ifFalse:[
            e := 'No such image file.'.
        ].
        self warn:(self resources string:e).
        ^ nil
    ].
    imageView := self openOnImage:img.
    imageView topView label:(fn pathName) iconLabel:(fn baseName).
    ^ imageView

    "
     ImageView openOnFile:'../../goodies/bitmaps/gifImages/garfield.gif'
     ImageView openOnFile:'../../goodies/bitmaps/xpmBitmaps/misc_icons/BOOK.xpm'
    "

    "Modified: / 31.10.1997 / 16:17:52 / cg"
!

openOnImage:anImage
    "startup an image viewer on an image"

    |lbl|

    anImage isImage ifTrue:[
        lbl := anImage fileName ? 'an Image'
    ] ifFalse:[
        anImage isNil ifTrue:[
            lbl := 'an Image'
        ] ifFalse:[
            lbl := 'a Form'
        ]
    ].
    ^ self openOnImage:anImage title:lbl

    "
     ImageView openOnImage:(Image fromFile:'bitmaps/gifImages/garfield.gif') title:'garfield'
     ImageView openOnImage:(Image fromFile:'../../libtool/bitmaps/SBrowser.xbm') title:'old browser icon'
    "
!

openOnImage:anImage title:aString
    "startup an image viewer on an image"

    |top v imageView icnW icnH iconView magX magY mag imgWidth imgHeight|

    top := StandardSystemView label:aString.

    v := HVScrollableView for:self in:top.
    v origin:0@0 extent:1.0@1.0.
    imageView := v scrolledView.

    anImage notNil ifTrue:[
        imageView image:anImage.

        "define an icon view showing a little version of image.
         Since some window managers cannot handle this correctly (twm),
         this is only done when running on an IRIS"

        (true "(OperatingSystem getSystemType = 'iris')"
        and:[StyleSheet name == #iris]) ifTrue:[
            iconView := ImageView new.

            "for now; should somehow get access to preferred iconview extent ..."
            icnW := 86.
            icnH := 68.

            imgWidth := anImage width.
            imgHeight := anImage height.

            ((imgWidth <= icnW) and:[imgHeight <= icnH]) ifTrue:[
                iconView extent:(imgWidth @ imgHeight).
                mag := 1 @ 1
            ] ifFalse:[
                magX := icnW / imgWidth.
                magY := icnH / imgHeight.

                "scale image"
"
                mag := magX @ magY.
"
                "preserve ratio"
"
                mag := (magX min:magY) asPoint.
"
" "
                mag := (magX max:magY) asPoint.
" "

                iconView extent:((anImage width @ anImage height) * mag) rounded.
            ].

            top iconView:iconView.
        ].
    ].

    top open.

    iconView notNil ifTrue:[
        top windowGroup addView:iconView.
        [
            iconView image:(anImage magnifiedBy:mag).
        ] forkAt:4
    ].
    ^ imageView

    "
     ImageView openOnImage:(Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') title:'garfield'
     ImageView openOnImage:(Image fromFile:'../../libtool/bitmaps/SBrowser.xbm')
    "

    "Modified: / 01-06-2010 / 18:31:14 / cg"
! !

!ImageView methodsFor:'accessing'!

adjust
    "get the adjust (how the image is displayed);
     currently, only support #topLeft, #center, #fitBig, #fitSmall and #fit:
            #topLeft    - image is displayed as usual
            #center     - image is shown centered
            #fitBig     - big images are shrunk to make it fit the view
            #fitSmall   - small images are magnified to make it fit the view,
            #fit        - all images are magnified to fit the view
    "

    ^ adjust ? #topLeft
!

adjust:layoutSymbol
    "set the adjust (how the image is displayed);
     currently, only support #topLeft, #center, #fitBig, #fitSmall and #fit:
            #topLeft    - image is displayed as usual
            #center     - image is shown centered
            #fitBig     - big images are shrunk to make it fit the view
            #fitSmall   - small images are magnified to make it fit the view,
            #fit        - all images are magnified to fit the view
            #topLeftNoZoom    - image is displayed as usual, and magnification is reset
    "

    |layoutUsed|

    layoutUsed := layoutSymbol.
    layoutUsed == #topLeftNoZoom ifTrue:[
        layoutUsed := #topLeft
    ].
    self magnificationFactor ~= 1 ifTrue:[
        self magnificationFactor:1
    ].
    
    adjust ~= layoutUsed ifTrue:[
        adjust := layoutUsed.
        adjustHolder notNil ifTrue:[
            adjustHolder value:layoutUsed withoutNotifying:self
        ].    

        magnifiedImage := nil.
        shown ifTrue:[
            image notNil ifTrue:[
                self magnificationFactor ~= 1 ifTrue:[
                    self generateMagnifiedImage.
                ].    
                self clear.
                self scrollToTopLeft.
                self invalidate.
                self contentsChanged.
            ]
        ].
    ].
!

adjustHolder
    "get a valeHolder for the adjust (how the image is displayed);
     currently, only support #topLeft, #center, #fitBig, #fitSmall and #fit:
            #topLeft    - image is displayed as usual
            #center     - image is shown centered
            #fitBig     - big images are shrunk to make it fit the view
            #fitSmall   - small images are magnified to make it fit the view,
            #fit        - all images are magnified to fit the view
    "

    adjustHolder isNil ifTrue:[
        adjustHolder := self adjust asValue.
        adjustHolder 
            onChangeEvaluate:[
                self adjust:(adjustHolder value).
            ]
    ].        
    ^ adjustHolder
!

image
    "return the image"

    ^ image
!

image:anImage
    "set the image scrolls as set by adjust
     - may show a wait cursor, if image dithering may take a while"

    self image:anImage scroll:true
!

image:anImage scroll:doScroll
    "set the image possibly scroll as set by adjust
     - may show a wait cursor, if image dithering may take a while"

    self setImage:anImage scroll:doScroll
!

image:anImage scroll:doScroll invalidate:doInvalidate
    "set the image possibly scroll as set by adjust
     - may show a wait cursor, if image dithering may take a while"

    self setImage:anImage scroll:doScroll invalidate:doInvalidate
!

magnification
    magnifiedImage isNil ifTrue:[^ 1@1].
    ^ magnifiedImage extent / image extent
!

magnificationFactor
    ^ magnificationFactor ? 1
!

magnificationFactor:aNumber
    magnificationFactor ~= aNumber ifTrue:[
        magnificationFactor := aNumber.
        "/    magnificationFactor fractionPart < 0.1 ifTrue:[
        "/        "magnifying by integer factor is faster"
        "/        magnificationFactor := magnificationFactor truncated.
        "/    ].
        magnifiedImage := nil.
        magnificationFactor = 1 ifTrue:[
            self contentsChanged.
        ].    
        self invalidate.
    ].
!

model:aValueHolder
    super model:aValueHolder.
    self updateFromModel.

    "Created: / 25-07-2011 / 15:32:10 / cg"
!

setImage:anImage
    "set the image - show a wait cursor, since image dithering may take a while"

    self setImage:anImage scroll:true invalidate:true

    "Modified: / 10.2.2000 / 23:25:51 / cg"
!

setImage:anImage scroll:doScroll
    "set the image - may show a wait cursor, if image dithering may take a while"

    self setImage:anImage scroll:doScroll invalidate:true
!

setImage:anImage scroll:doScroll invalidate:doInvalidate
    "set the image - may show a wait cursor, if image dithering may take a while"

    |oldSize newSize newImageIsSmaller|

    self assert:(anImage isImage or:[anImage isNil]).
    
    oldSize := image isNil ifTrue:[0@0] ifFalse:[image extent].

    image := anImage.
    magnifiedImage := nil.
    self generateMagnifiedImage.

    newSize := image isNil ifTrue:[0@0] ifFalse:[(magnifiedImage ? image) extent].
    newImageIsSmaller := ((oldSize x > newSize x) or:[oldSize y > newSize y]).

    (newImageIsSmaller and:[ doInvalidate ]) ifTrue:[ self invalidate ].
    doScroll ifTrue:[ self scrollToTopLeft ].

    oldSize ~= newSize ifTrue:[
        "/ avoid endless loop in case of a resize happening due
        "/ to scrollBar visibility changes.
        "/ that QuerySignal suppresses another magnification in sizeChanged:
        DoNotMagnifyQuery
            answer:true
            do:[
                self contentsChanged.
            ]
    ].

    (shown and:[doInvalidate]) ifTrue:[
        "/ (anImage isNil "or:[newImageIsSmaller]") ifTrue:[
        "/     self clear.
        "/ ].
        self invalidate
    ].
    self changed:#image.

    "Modified: / 10.2.2000 / 23:25:51 / cg"
!

sizeToFit:aBoolean
    aBoolean ifTrue:[
        self adjust:#fitBig
    ] ifFalse:[
        self adjust:nil.
    ]
!

tileMode:aBoolean tileOffset:aPoint

    tileMode := aBoolean.
    tileOffset := aPoint
! !

!ImageView methodsFor:'accessing-channels'!

imageChannel
    ^ self model

    "Modified: / 31-03-2011 / 10:45:58 / cg"
!

imageChannel:aValueHolder
    self model:aValueHolder.

    "Created: / 11-02-2000 / 00:34:33 / cg"
    "Modified: / 31-03-2011 / 10:46:07 / cg"
! !

!ImageView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == model ifTrue:[
        self updateFromModel.
        ^ self
    ].
    super update:something with:aParameter from:changedObject

    "Created: / 11-02-2000 / 00:37:02 / cg"
    "Modified: / 31-03-2011 / 10:46:16 / cg"
!

updateFromModel
    "the model changes, set my image"

    self image:model value.
! !

!ImageView methodsFor:'drawing'!

generateMagnifiedImage
    |doFit innerWidth innerHeight imgWidth imgHeight|

    magnifiedImage notNil ifTrue:[
        ^ self
    ].
    image isNil ifTrue:[
        ^ self
    ].
    doFit := false.

    innerWidth := self innerWidth.
    innerHeight := self innerHeight.

    imgWidth := image width.
    imgHeight := image height.
    
    tileMode ~~ true ifTrue:[
        ((imgWidth > innerWidth)
        or:[imgHeight > innerHeight]) ifTrue:[
            ((adjust == #fit) or:[adjust == #fitBig]) ifTrue:[
                doFit := true
            ].
        ] ifFalse:[
            ((imgWidth < innerWidth)
            or:[imgHeight < innerHeight]) ifTrue:[
                ((adjust == #fit) or:[adjust == #fitSmall]) ifTrue:[
                    doFit := true
                ].
            ]
        ].
    ].
    doFit ifTrue:[
        magnifiedImage := image magnifiedPreservingRatioTo:(innerWidth @ innerHeight).
"/        self contentsChanged.
    ] ifFalse:[
        (magnificationFactor notNil and:[magnificationFactor ~= 1]) ifTrue:[
            magnifiedImage := image magnifiedBy:magnificationFactor.
        ] ifFalse:[
            magnifiedImage := image
        ].
    ].
    self contentsChanged.

    "Modified: / 06-05-2012 / 12:17:23 / cg"
!

redrawX:x y:y width:w height:h
    |xI yI depth shownImage imgWidth imgHeight right bott "rectRight rectBelow"|

    image notNil ifTrue:[
        self generateMagnifiedImage.

        shownImage := magnifiedImage ? image.
        imgWidth := shownImage width.
        imgHeight := shownImage height.

        adjust == #center ifTrue:[
            xI := (width - (margin * 2) - imgWidth) // 2.
            yI := (height - (margin * 2) - imgHeight) // 2.
        ] ifFalse:[
            xI := yI := margin
        ].

        ((depth := shownImage depth) == 1) ifTrue:[
            self paint:(shownImage colorFromValue:1)
                    on:(shownImage colorFromValue:0).
        ].

        tileMode == true ifTrue:[
            (tileOffset y > 0 and:[tileOffset x > 0]) ifTrue:[
                (false "depth ~~ 1"
                or:[shownImage mask notNil]) ifTrue:[
                    self clearRectangleX:x y:y width:w height:h.
                    0 to:y+h by:tileOffset y do:[:oY |
                        0 to:x+w by:tileOffset x do:[:oX |
                            self displayForm:image x:oX y:oY
                        ]
                    ].
                ] ifFalse:[
                    0 to:y+h by:tileOffset y do:[:oY |
                        0 to:x+w by:tileOffset x do:[:oX |
                            self displayOpaqueForm:image x:oX y:oY
                        ]
                    ].
                ].
            ]
        ] ifFalse:[
            "/rectRight := (shownImage width @ 0) corner:(width @ shownImage height).
            "/rectBelow := 0 @ (shownImage height) corner:(shownImage height @ height).
            "/(rectRight width > 0 and:[rectRight height > 0]) ifTrue:[ self clearRectangle:rectRight ].
            "/(rectBelow width > 0 and:[rectBelow height > 0]) ifTrue:[ self clearRectangle:rectBelow ].

            xI > (x+w) ifTrue:[^ self]. "/ no need to draw
            yI > (y+h) ifTrue:[^ self]. "/ no need to draw
            (xI+imgWidth) < x ifTrue:[^ self]. "/ no need to draw
            (yI+imgHeight) < y ifTrue:[^ self]. "/ no need to draw

            (false "depth ~~ 1"
            or:[shownImage mask notNil]) ifTrue:[
                self clearRectangleX:x y:y width:w height:h.
                shownImage displayOn:self x:xI y:yI.
                "/ self displayForm:shownImage x:xI y:yI
            ] ifFalse:[
                self displayOpaqueForm:shownImage x:xI y:yI
            ].

            "/ right of image ?
            right := x + w - 1.
            right > (xI + imgWidth) ifTrue:[
                self clearRectangleX:(xI + imgWidth) y:y
                               width:(right - imgWidth - xI) height:h
            ].
            "/ below of image ?
            bott := y + h - 1.
            bott > (yI + imgHeight) ifTrue:[
                self clearRectangleX:margin y:(yI + imgHeight)
                               width:w height:(bott - imgHeight - yI)
            ].
        ].
    ] ifFalse:[
        self clearRectangleX:x y:y width:w height:h.
    ].    

    "Created: / 11.7.1996 / 21:02:12 / cg"
    "Modified: / 12.8.1998 / 14:02:28 / cg"
! !

!ImageView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    |delta mousePoint|

    lastMousePoint notNil ifTrue:[
        mousePoint := (x@y).
        delta := mousePoint - lastMousePoint.
        delta ~= (0@0) ifTrue:[
            self scrollTo:(self viewOrigin - delta).
            lastMousePoint := mousePoint.
        ]
    ] ifFalse:[
        super buttonMotion:state x:x y:y
    ]
!

buttonPress:button x:x y:y
    button == 1 ifTrue:[
        "self cursor:(Cursor handGrab). "
        lastMousePoint := x@y.
    ].
    super buttonPress:button x:x y:y

    "Modified: / 06-05-2012 / 12:19:39 / cg"
!

buttonRelease:button x:x y:y
    button == 1 ifTrue:[
        lastMousePoint := nil
    ].
    super buttonRelease:button x:x y:y
!

mouseWheelZoom:amount
    "CTRL-wheel action"

    |mul|

    amount > 0 ifTrue:[
        mul := 1.2.
    ] ifFalse:[
        mul := 0.8.
    ].
    self magnificationFactor:((magnificationFactor ? 1) * mul).

    "Created: / 06-05-2012 / 12:18:06 / cg"
!

sizeChanged:how
    (#(fit fitBig fitSmall) includes:adjust) ifTrue:[
        magnifiedImage notNil ifTrue:[
            DoNotMagnifyQuery query ifFalse:[
                self pushEvent:#updateImageAfterSizeChange.
            ]
        ].
    ] ifFalse:[
        adjust == #center ifTrue:[
            self clear.
            self invalidate.
        ].
    ].
    super sizeChanged:how
!

updateImageAfterSizeChange
    |oldMagnifiedImage|
    
    oldMagnifiedImage := magnifiedImage.
    magnifiedImage := nil.
    self generateMagnifiedImage.
    (oldMagnifiedImage isNil
      or:[ magnifiedImage isNil
      or:[ oldMagnifiedImage extent ~= magnifiedImage extent ]]
    ) ifTrue:[
        "/ self clear.
        self invalidate.
    ].
! !

!ImageView methodsFor:'initialization & release'!

destroy
    magnifiedImage := nil.
    "/ image := nil.
    super destroy.
! !

!ImageView methodsFor:'menu'!

middleButtonMenu
    menuHolder notNil ifTrue:[^ super middleButtonMenu].
    ^ self class middleButtonMenu
! !

!ImageView methodsFor:'queries'!

heightOfContents
    "return the image's height - scrollbar needs this info"

    image isNil ifTrue:[^ 0].
    ^ (magnifiedImage ? image) height
!

widthOfContents
    "return the image's width - scrollbar needs this info"

    image isNil ifTrue:[^ 0].
    ^ (magnifiedImage ? image) width
! !

!ImageView methodsFor:'scrolling'!

scrollToMakeVisible:aPoint
    "try to arrange for aPoint to be visible (at the center, if possible)"

    |mag pos|

    mag := self magnification.
    pos := aPoint * mag.
    self scrollTo:(pos - (self extent / 2)) rounded.
! !

!ImageView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ImageView initialize!
