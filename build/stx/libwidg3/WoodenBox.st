"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libwidg3' }"

ObjectView subclass:#WoodenBox
	instanceVariableNames:'front pullButton contentsView shadow veryLightColor lghtColor
		mediumColor darkColor coverView'
	classVariableNames:'TextureV TextureH'
	poolDictionaries:''
	category:'Views-Fun'
!

!WoodenBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    this is a fun widget (mostly for demonstration purposes).
    TODO: add drag and drop

    [see also:]
        GraniteBox WoodenMenu PullDownMenu

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                [exBegin]
     WoodenBox new open
                                                                [exEnd]

                                                                [exBegin]
     WoodenBox new closeCover open
                                                                [exEnd]

                                                                [exBegin]
     GraniteBox new open
                                                                [exEnd]


   how about this one (has a nice cover to open):
                                                                [exBegin]
     |w openIt closeIt|

     w := WoodenBox new.
     openIt := [w openCover. w pullButton action:closeIt].
     closeIt := [w closeCover. w pullButton action:openIt].
     w pullButton action:openIt.
     w closeCover.
     w open
                                                                [exEnd]


   rock solid ...
                                                                [exBegin]
     |w openIt closeIt|
     w := GraniteBox new.
     openIt := [w openCover. w pullButton action:closeIt].
     closeIt := [w closeCover. w pullButton action:openIt].
     w pullButton action:closeIt.
     w open
                                                                [exEnd]


   plastic but a nice cover ...
                                                                [exBegin]
     |w openIt closeIt|
     w := GraniteBox new.
     openIt := [w openCover. w pullButton action:closeIt].
     closeIt := [w closeCover. w pullButton action:openIt].
     w pullButton action:closeIt.
     w viewBackground:(Color green darkened darkened).
     w frontView viewBackground:(Color green darkened darkened).
     w open
                                                                [exEnd]


   all plastic  ...
                                                                [exBegin]
     |w openIt closeIt|
     w := GraniteBox new.
     openIt := [w openCover. w pullButton action:closeIt].
     closeIt := [w closeCover. w pullButton action:openIt].
     w pullButton action:closeIt.
     w viewBackground:(Color green darkened darkened).
     w frontView viewBackground:(Color green darkened).
     w coverView viewBackground:(Color green darkened).
     w open
                                                                [exEnd]


   mixing wood & granite:
                                                                [exBegin]
     |w openIt closeIt|
     w := GraniteBox new.
     openIt := [w openCover. w pullButton action:closeIt].
     closeIt := [w closeCover. w pullButton action:openIt].
     w pullButton action:closeIt.
     w coverView viewBackground:(WoodenBox new textureV).
     w open
                                                                [exEnd]


                                                                [exBegin]
     |w openIt closeIt|
     w := WoodenBox new.
     openIt := [w openCover. w pullButton action:closeIt].
     closeIt := [w closeCover. w pullButton action:openIt].
     w pullButton action:closeIt.
     w coverView viewBackground:(GraniteBox new textureV).
     w open
                                                                [exEnd]


   put something into the box:
                                                                [exBegin]
     |w openIt closeIt obj|

     w := WoodenBox new.
     openIt := [w openCover. w pullButton action:closeIt].
     closeIt := [w closeCover. w pullButton action:openIt].
     w pullButton action:openIt.
     w closeCover.

     obj := Demos::ToolObject new.
     obj icon:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_tools/crayons_masked.xpm').
     obj origin:5@10.
     w add:obj.

     obj := Demos::ToolObject new.
     obj icon:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_tools/pencil_red_masked.xpm').
     obj origin:30@45.
     w add:obj.

     obj := Demos::ToolObject new.
     obj icon:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_tools/pencil_green_masked.xpm').
     obj origin:40@25.
     w add:obj.

     obj := Demos::ToolObject new.
     obj icon:(Image fromFile:'../../goodies/bitmaps/xpmBitmaps/misc_tools/pencil_blue_masked.xpm').
     obj origin:50@35.
     w add:obj.

     w open.

                                                                [exEnd]


"
! !

!WoodenBox class methodsFor:'cleanup'!

lowSpaceCleanup
    "cleanup in low-memory situations"

    TextureH := TextureV := nil

    "
     Smalltalk allClassesDo:[:aClass |
	aClass lowSpaceCleanup
     ]
    "
    "
     WoodenBox lowSpaceCleanup
    "
! !

!WoodenBox methodsFor:'accessing'!

coverView
    "return the view used as a cover"

    ^ coverView
!

frontView
    "return the view used as a front panel"

    ^ front

!

label:aString
    "set the pull-buttons label string"

    pullButton label:aString
!

pullButton
    "return the pull button"

    ^ pullButton
!

wrap:aView
    "arrange for another view to be wrapped in myself"

    aView superView:self.
    aView origin:(1@1) corner:1@1
! !

!WoodenBox methodsFor:'animation'!

closeCover
    "slowly close the cover"

    |step|

    shown ifTrue:[
        coverView beVisible.
        device flush.

        step := (coverView height / 4) rounded.

        coverView height negated to:0 by:step do:[:y |
            coverView origin:(6 @ y).
            device flush.
            10 timesRepeat:[Processor yield.
                windowGroup processExposeEvents.
                Processor yield.
            ].
            device flush.
            (Delay forSeconds:0.03) wait
        ].
    ] ifFalse:[
        coverView hiddenOnRealize:false
    ].

    coverView origin:(6 @ 0).
!

openCover
    "slowly open the cover"

    |step|

    shown ifTrue:[
        step := (coverView height negated / 4) rounded.

        0 to:(coverView height negated) by:step do:[:y |
            coverView origin:(6  @ y).
            device flush.
            10 timesRepeat:[Processor yield.
                windowGroup processExposeEvents.
                Processor yield.
            ].
            device flush.
            (Delay forSeconds:0.03) wait
        ].
        device flush.
    ].
    coverView beInvisible.
! !

!WoodenBox methodsFor:'drawing'!

redrawX:x y:y width:w height:h
    "redraw the box"

    |c lh t
     right bott yMin hSide r b tY tX
     form1 form2 form3 form4 h1 h2 h3 sh fg bg fun|

    super redrawX:x y:y width:w height:h.

    right := x + w.
    bott := y + h.

    lh := front height + 4.

    self clippingRectangle:(x@y extent:(w@h)).

    shadow ifTrue:[
        "
         the shadow ...
         which one looks best ?
        "
"/        h1 := 4. h2 := 3. h3 := 3.
"/        h1 := 6. h2 := 4. h3 := 3.
"/        h1 := 10. h2 := 6. h3 := 4.
"/        h1 := 4. h2 := 10. h3 := 5.
        h1 := 0. h2 := 5. h3 := 10.

        sh := h1 + h2 + h3.

        form1 := Form veryLightGreyFormOn:device.
        form2 := Form lightGreyFormOn:device.
        form3 := Form mediumGreyFormOn:device.
        form4 := Form darkGreyFormOn:device.

        "
         can we draw the shadow with one fill ?
        "
        device blackpixel == 0 ifTrue:[
            fg := Color noColor.
            bg := Color allColor.
            fun := #and
        ] ifFalse:[
            ((device blackpixel == -1) 
             or:[device blackpixel == ((1 bitShift:device depth)-1)]) ifTrue:[
                fg := Color allColor.
                bg := Color noColor.
                fun := #or
            ]
        ].
        fun notNil ifTrue:[
            self function:fun.
            self mask:form1.
            self foreground:fg background:bg.
            self fillRectangleX:7+sh-h1 y:sh width:h1 height:height-lh-sh-4.
            self fillRectangleX:7+sh-h1 y:sh-h1 width:width-14 height:h1.
            self mask:form2.
"/            self fillRectangleX:7+sh-h1 y:sh-h1 width:h1 height:h1.

            self fillRectangleX:7+h3 y:sh-h1 width:h2 height:height-lh-sh+h1-4.
            self fillRectangleX:7+h3 y:h3 width:width-14 height:h2.
            self mask:form3.
"/            self fillRectangleX:7+h3 y:h3 width:h2 height:h2.

            self fillRectangleX:7 y:h3 width:h3 height:height-lh-h3-4.
            self fillRectangleX:7 y:0 width:width-14 height:h3.
            self mask:form4.
"/            self fillRectangleX:7 y:0 width:h3 height:h3.

            self function:#copy.
            self mask:nil.
            self paint:Black on:White.
        ] ifFalse:[
            "
             must do it in two operations; 1st clear to zero,
             then or-in black
            "
            self function:#and.
            self mask:form1.
            self foreground:Color noColor background:Color allColor.

            self fillRectangleX:7+sh-h1 y:sh width:h1 height:height-lh-sh-4.
            self fillRectangleX:7+sh-h1 y:sh-h1 width:width-14 height:h1.
            self mask:form2.
"/            self fillRectangleX:7+sh-h1 y:sh-h1 width:h1 height:h1.

            self fillRectangleX:7+h3 y:sh-h1 width:h2 height:height-lh-sh+h1-4.
            self fillRectangleX:7+h3 y:h3 width:width-14 height:h2.
            self mask:form3.
"/            self fillRectangleX:7+h3 y:h3 width:h2 height:h2.

            self fillRectangleX:7 y:h3 width:h3 height:height-lh-h3-4.
            self fillRectangleX:7 y:0 width:width-14 height:h3.
            self mask:form4.
"/            self fillRectangleX:7 y:0 width:h3 height:h3.

            self function:#or.
            self mask:form1.
            self foreground:(Black on:device) background:Color noColor.

            self fillRectangleX:7+sh-h1 y:sh width:h1 height:height-lh-sh-4.
            self fillRectangleX:7+sh-h1 y:sh-h1 width:width-14 height:h1.
            self mask:form2.
"/            self fillRectangleX:7+sh-h1 y:sh-h1 width:h1 height:h1.

            self fillRectangleX:7+h3 y:sh-h1 width:h2 height:height-lh-sh+h1-4.
            self fillRectangleX:7+h3 y:h3 width:width-14 height:h2.
            self mask:form3.
"/            self fillRectangleX:7+h3 y:h3 width:h2 height:h2.

            self fillRectangleX:7 y:h3 width:h3 height:height-lh-h3-4.
            self fillRectangleX:7 y:0 width:width-14 height:h3.
            self mask:form4.
"/            self fillRectangleX:7 y:0 width:h3 height:h3.

            self function:#copy.
            self mask:nil.
            self paint:Black on:White.
        ].
    ].

    tY := height -1 - lh - 7.
    bott >= tY ifTrue:[
        y <= tY ifTrue:[
            t := self textureH.
            t isNil ifTrue:[
                self paint:mediumColor.
                self fillRectangleX:0 y:tY
                              width:width height:7.
            ] ifFalse:[
                self paint:front viewBackground.
                self fillRectangleX:0 y:tY width:width height:7.
            ]
        ]
    ].

    "
     outer shadow
    "
    self paint:veryLightColor "lghtColor" "mediumColor".
    self displayLineFromX:0 y:0 toX:0 y:height.

    self paint:Black "darkBrown".
    self displayLineFromX:width-1 y:0 toX:width-1 y:height.
    self displayLineFromX:0 y:height-1 toX:width-1 y:height-1.

    tY := height - (8+lh).
    y <= tY ifTrue:[
        bott >= tY ifTrue:[
            self paint:lghtColor.
            self displayLineFromX:0 y:tY toX:width y:tY.
        ]
    ].

    "
     sides
    "
    yMin := y-1.
    hSide := ((height-4-lh) min:bott) - yMin + 1.

    self paint:mediumColor.
    x <= 7 ifTrue:[
        self fillRectangleX:0 y:yMin width:7 height:hSide.
    ].
    r := width-7.
    right >= r ifTrue:[
        self fillRectangleX:r y:yMin width:7 height:hSide.
    ].

    self paint:lghtColor.
    x <= 5 ifTrue:[
        self fillRectangleX:0 y:yMin width:5 height:hSide.
    ].
    right >= r ifTrue:[
        self fillRectangleX:r y:yMin width:5 height:hSide.
    ].

    self paint:veryLightColor.
    x <= 2 ifTrue:[
        self fillRectangleX:0 y:yMin width:2 height:hSide.
    ].
    right >= r ifTrue:[
        self fillRectangleX:r y:yMin width:2 height:hSide.
    ].

    self paint:veryLightColor "White".
    x <= 1 ifTrue:[
        self fillRectangleX:0 y:yMin width:1 height:hSide.
    ].
    right >= r ifTrue:[
        self fillRectangleX:r y:yMin width:1 height:hSide.
    ].

    self paint:Black.
    x <= 6 ifTrue:[
        self fillRectangleX:6 y:yMin width:1 height:hSide.
    ].
    r := width - 1.
    right >= r ifTrue:[
        self fillRectangleX:r y:yMin width:1 height:hSide.
    ].

    "
     small low end-notch of sides
    "
    b := height-5-lh.
    bott >= b ifTrue:[
        self paint:Black.
        self displayLineFromX:1"0" y:b toX:7 y:b.
        self displayLineFromX:width-7 y:b toX:width-1 y:b.
    ].

    b := b + 1.
    bott >= b ifTrue:[
        self paint:lghtColor.
        self displayLineFromX:1"0" y:b toX:7 y:b.
        self displayLineFromX:width-7 y:b toX:width-1 y:b.
    ].

    b := b + 1.
    self displayLineFromX:7 y:b toX:7 y:b-4.
    self displayLineFromX:width-8 y:b toX:width-8 y:b-4.

    "
     shadow-notch above front plate
    "
    tY := height - lh.
    bott >= tY ifTrue:[
        self paint:Black.
        self displayLineFromX:0"1" "0" y:tY toX:width-1 y:tY.
    ].

    tY := tY + 1.
    bott >= tY ifTrue:[
        self paint:lghtColor "mediumColor".
        self displayLineFromX:1"0" y:tY toX:width-1 y:tY.
    ].

    self clippingRectangle:nil.

   "
    WoodenBox new open
   "

    "Created: 28.3.1997 / 22:56:16 / cg"
    "Modified: 28.3.1997 / 22:57:29 / cg"
! !

!WoodenBox methodsFor:'initialization'!

initColors
    mediumColor := ((Color red:40 green:27 blue:15) nearestOn:device).
    lghtColor := ((Color red:80   green:55 blue:30) nearestOn:device).
    veryLightColor := ((Color red:100 green:68 blue:38) nearestOn:device).
!

initialize
    |h t|

    super initialize.

    "shades of brown"
    self initColors.

    t := self textureV.
    t isNil ifTrue:[
	t := mediumColor.
    ].
    self viewBackground:t.
    self backingStore:true.

    shadow := true.

    front := View in:self.
    pullButton := Button in:front.

    t := self textureH.
    t isNil ifTrue:[
	t := mediumColor.
    ].
    front viewBackground:t.
    front origin:[1 @ (height - pullButton height - ViewSpacing)] 
	  corner:[(width-2) @ (height-2)].

    pullButton label:'ToolBox'.
    pullButton origin:[(front width - pullButton width // 2)
		       @
		       (front height - pullButton height - (ViewSpacing//2) + 1)].
    pullButton foregroundColor:Black.

    coverView := View in:self.
    coverView viewBackground:t.
    coverView extent:[(width - 14) 
		      @ 
		      (height - front height - (ViewSpacing * 2) - 4)].
    coverView hiddenOnRealize:true.
!

textureH
    "get the texture for horizontal crafted wood"

    |t|

    TextureH isNil ifTrue:[
        t := Smalltalk imageFromFileNamed:'wood2H.tiff' inPackage:'stx:libwidg3'.
        t notNil ifTrue:[
            TextureH := t on:device.
        ]
    ].
    ^ TextureH

    "
     TextureH := nil
    "
!

textureV
    "get the texture for vertically crafted wood"

    |t|

    TextureV isNil ifTrue:[
        t := Smalltalk imageFromFileNamed:'bitmaps/wood2V.tiff' inPackage:'stx:libwidg3'.
        t notNil ifTrue:[
            TextureV := t on:device.
        ]
    ].
    ^ TextureV

    "
     TextureV := nil
    "
! !

!WoodenBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/WoodenBox.st,v 1.15 2006-01-24 15:57:18 cg Exp $'
! !
