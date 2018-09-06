"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

MenuView subclass:#PatternMenu
	instanceVariableNames:'patterns nrows ncols patternSize space orientation windowRatio
		inSet'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool'
!

!PatternMenu class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a menu for fill- and line-patterns. Instead of textual entries,
    it shows bitmaps, images or colors.
    Normally, layout is done automatically, but can be controlled
    by specifying a ratio (width vs. height). The default ratio is
    1 @ 3 (i.e. 3 times higher than wide). It can be changed with the
    #windowRatio:-message.
    Also, patterns are arranged verticalFirst by default, which can be
    changed with the #orientation:-message.

    You can use PatternMenus as persistent menu, or in a popUp or pullDown
    menu; see examples.

    [author:]
        Claus Gittinger

    [see also:]
        LineMenu
        DrawTool
        PopUpMenu PullDownMenu
        Image Form Color
"
!

examples
"
    as persistent menu:
                                                                        [exBegin]

        |p colors savedBackground|

        p := PatternMenu new.
        colors := OrderedCollection new.
        colors add:(Color red:100 green:0 blue:0);
               add:(Color red:75 green:0 blue:0);
               add:(Color red:50 green:0 blue:0);
               add:(Color red:25 green:0 blue:0);
               add:(Color red:0 green:100 blue:0);
               add:(Color red:0 green:75 blue:0);
               add:(Color red:0 green:50 blue:0);
               add:(Color red:0 green:25 blue:0);                 
               add:(Color red:0 green:0 blue:100);
               add:(Color red:0 green:0 blue:75);
               add:(Color red:0 green:0 blue:50);
               add:(Color red:0 green:0 blue:25).

        p patterns:colors.
        p selectors:#value:.
        p args:colors.
        p receiver:[:val | 
                        Transcript backgroundColor:val. 
                        Transcript redraw
                   ].
        p windowRatio:(2 @ 2).
        p open.
                                                                        [exEnd]


    in a popup-menu:
                                                                        [exBegin]

        |v p|

        v := View new.
        p := PatternMenu new.
        p patterns:(Array with:Color red
                          with:Color green
                          with:Color blue).
        v middleButtonMenu:(PopUpMenu forMenu:p).
        v open
                                                                        [exEnd]


   as a submenu:
                                                                        [exBegin]

        |v m m1 m2 m3 colors icons|

        colors := (Array with:Color red
                         with:Color green
                         with:Color blue).

        icons := (Array with:(Image fromFile:'SmalltalkX.xbm')
                        with:(Image fromFile:'SBrowser.xbm')
                        with:(Image fromFile:'FBrowser.xbm')).

        v := StandardSystemView new.
        v extent:200@200.

        m1 := PatternMenu new.
        m1 patterns:colors.
        m1 selectors:#viewBackgroundAndClear:.
        m1 args:colors.
        m1 receiver:v.

        m2 := PatternMenu new.
        m2 patterns:icons.
        m2 adjustPatternSize.
        m2 selectors:#icon:.
        m2 args:icons.
        m2 receiver:v.

        m3 := LineMenu new.
        m3 lineWidths:#(1 2 3 4 5 10).
        m3 selectors:#lineWidth:.
        m3 args:#(1 2 3 4 5 10).
        m3 receiver:v.

        m := PopUpMenu
                labels:#(
                         'colors ...'
                         'icons ...'
                         'line ...'
                        )
                selectors:#(#colors #icons #lines)
                receiver:[:v | Transcript show:'arg: '; showCR:v].
        m subMenuAt:#colors put:(PopUpMenu forMenu:m1).
        m subMenuAt:#icons put:(PopUpMenu forMenu:m2).
        m subMenuAt:#lines put:(PopUpMenu forMenu:m3).
        v middleButtonMenu:m.
        v open
                                                                        [exEnd]
"
! !

!PatternMenu class methodsFor:'instance creation'!

patterns:patterns selectors:selectors args:args receiver:anObject for:aTopMenu
    |newMenu|

    newMenu := self forMenu:aTopMenu.
    newMenu patterns:patterns.
    newMenu selectors:selectors.
    newMenu args:args.
    newMenu receiver:anObject.
    ^newMenu

    "Modified: 5.6.1996 / 11:30:27 / cg"
!

patterns:patterns selectors:selectors receiver:anObject for:aTopMenu
    |newMenu|

    newMenu := self forMenu:aTopMenu.
    newMenu patterns:patterns.
    newMenu selectors:selectors.
    newMenu receiver:anObject.
    ^newMenu

    "Modified: 5.6.1996 / 11:30:31 / cg"
! !

!PatternMenu class methodsFor:'defaults'!

defaultOrientation
    "specifies default orientation; 
     either #verticalFirst or #horizontalFirst"

    ^ #verticalFirst
!

defaultPatternSize
    "returns default pattern size"

    "take 32x32 on a 100 dpi display"

    ^ (32 * Display horizontalPixelPerInch / 100) rounded asInteger 
      @
      (32 * Display verticalPixelPerInch / 100) rounded asInteger 
!

defaultSpace
    "returns space between patterns"

    ^ 1
!

defaultWindowRatio
    "height shalt be 3 times the width"
    ^ 1 @ 3
! !

!PatternMenu methodsFor:'accessing'!

adjustPatternSize
    "set the pattern-size to make the largest pattern fit"

    |maxW maxH|

    maxW := patterns inject:0 into:[:maxSoFar :p | maxSoFar max:(p width)].
    maxH := patterns inject:0 into:[:maxSoFar :p | maxSoFar max:(p height)].
    self patternSize:maxW @ maxH
!

isValidSelection:aNumber
    aNumber isNil ifTrue:[^ false].
    (aNumber < 1) ifTrue:[^ false].
    (aNumber > patterns size) ifTrue:[^ false].
    ^ true
!

orientation:aLayoutSymbol
    "set the orientation; 
     the argument can be #verticalFirst or #horizontalFirst"

    orientation := aLayoutSymbol
!

patternSize:anExtent
    "set the size of the pattern buttons"

    patternSize := anExtent.
    self recomputeSize
!

patterns
    ^ patterns
!

patterns:collectionOfPatterns
    patterns := collectionOfPatterns.
    enableFlags := Array new:(patterns size).
    enableFlags atAllPut:true.
    self recomputeSize
!

windowRatio:aRatioPoint
    "change the width/height ratio. Using 0 as x-value will create
     a one-col menu; using 0 as y value will create a one-row menu."

    windowRatio := aRatioPoint.
    self recomputeSize
! !

!PatternMenu methodsFor:'drawing'!

redraw
    |row col xpos ypos dx dy|

    shown ifFalse:[^ self].
    self backingStore:true.    "next time will be fast"
    self is3D ifFalse:[
	"draw a grid"
	xpos := patternSize x.
	ypos := 0.
	1 to:(ncols - 1) do:[:index |
	    1 to:space do:[:index2 |
		self displayLineFromX:xpos y:0 toX:xpos y:height.
		xpos := xpos + 1
	    ].
	    xpos := xpos + patternSize x
	].
	xpos := 0.
	ypos := patternSize y.
	1 to:(nrows - 1) do:[:index |
	    1 to:space do:[:index2 |
		self displayLineFromX:0 y:ypos toX:width y:ypos.
		ypos := ypos + 1
	    ].
	    ypos := ypos + patternSize y
	]
    ].

    row := 0.
    col := 0.
    xpos := 0.
    ypos := 0.
    dx := patternSize x + inSet + inSet + space.
    dy := patternSize y + inSet + inSet + space.
    1 to:(patterns size) do:[:index |
	self   show:(patterns at:index)
		atX:xpos
		  y:ypos
	   selected:(index == selection).

	(orientation == #verticalFirst) ifTrue:[
	    row := row + 1.
	    (row == nrows) ifTrue:[
		row := 0.
		ypos := 0.
		col := col + 1.
		xpos := xpos + dx
	    ] ifFalse:[
		ypos := ypos + dy
	    ]
	] ifFalse:[
	    col := col + 1.
	    (col == ncols) ifTrue:[
		col := 0.
		xpos := 0.
		row := row + 1.
		ypos := ypos + dy
	    ] ifFalse:[
		xpos := xpos + dx
	    ]
	]
    ]
!

redrawElement:aNumber
    self redrawPattern:aNumber
!

redrawPattern:patternNr
    |row col p xpos ypos|

    patternNr isNil ifTrue:[^ self].

    p := patternNr - 1.
    (orientation == #verticalFirst) ifTrue:[
	col := p // nrows.
	row := p - (col * nrows)
    ] ifFalse:[
	row := p // ncols.
	col := p - (row * ncols)
    ].
    xpos := (patternSize x + inSet + inSet + space) * col.
    ypos := (patternSize y + inSet + inSet + space) * row.

    self     show:(patterns at:patternNr) 
	      atX:xpos 
		y:ypos
	 selected:(patternNr == selection)
!

redrawX:x y:y width:w height:h
    self redraw
!

show:aPattern atX:xp y:yp selected:selected
    |w h patternWidth patternHeight form|

    patternWidth := patternSize x.
    patternHeight := patternSize y.
    w := patternWidth + inSet + inSet.
    h := patternHeight + inSet + inSet.

    aPattern notNil ifTrue:[

        "this is slow on stupid servers ...
        self fillRectangleX:xp + inSet
                          y:yp + inSet
                      width:patternWidth
                     height:patternHeight
                       with:aPattern
        "

        aPattern isForm ifTrue:[
            form := aPattern
        ] ifFalse:[
            aPattern isImage ifTrue:[
                form := aPattern asFormOn:device.
            ]
        ].

        form notNil ifTrue:[
            "/ assume form is black-on-white (i.e. fg=1's=black; bg=0's=white)

            self maskOrigin:(xp + inSet) @ (yp + inSet).
            self foreground:Black background:White.
            self copyFrom:aPattern x:0 y:0
                      toX:xp + inSet y:yp + inSet
                    width:patternWidth
                   height:patternHeight
        ] ifFalse:[
            self withPattern:aPattern do:[
                self fillRectangleX:xp + inSet
                                  y:yp + inSet
                              width:patternWidth
                             height:patternHeight
            ]
        ]
    ].
    self is3D ifTrue:[
        selected ifTrue:[
            self drawEdgesForX:xp y:yp width:w height:h level:-2
        ] ifFalse:[
            self drawEdgesForX:xp y:yp width:w height:h level:2
        ].
    ] ifFalse:[
        selected ifTrue:[
            self displayRectangleX:xp y:yp width:w height:h.
            self displayRectangleX:xp + 1 y:yp + 1 width:w - 2 height:h - 2.
            self displayRectangleX:xp + 2 y:yp + 2 width:w - 4 height:h - 4
        ]
    ]

    "Modified: 14.6.1996 / 16:21:01 / cg"
! !

!PatternMenu methodsFor:'initialization'!

initialize
    super initialize.
    StyleSheet is3D ifTrue:[
	inSet := 4
    ] ifFalse:[
	inSet := 0
    ].
    orientation := self class defaultOrientation.
    windowRatio := self class defaultWindowRatio.
    space := self class defaultSpace.
    patternSize := self class defaultPatternSize
! !

!PatternMenu methodsFor:'private'!

positionToSelectionX:xpos y:ypos
    |index row col|

    (ypos < 0 or:[ypos >= height]) ifTrue:[^ nil].
    (xpos < 0 or:[xpos >= width]) ifTrue:[^ nil].

    col := xpos // ((patternSize x + inSet + inSet) + space).
    row := ypos // ((patternSize y + inSet + inSet) + space).
    (orientation == #verticalFirst) ifTrue:[
	index := nrows * col + row
    ] ifFalse:[
	index := ncols * row + col
    ].
    index := index + 1.
    (index > patterns size) ifTrue:[
	^ nil
    ].
    ^ index
! !

!PatternMenu methodsFor:'queries'!

preferredExtent 
    "from the ratio, compute number of row/cols needed"
    |factor nr nc w h nPattern|

    nr := windowRatio y.
    nc := windowRatio x.
    nPattern := patterns size.
    (nr == 0) ifTrue:[
	nrows := 1.
	ncols := nPattern
    ] ifFalse:[
	(nc == 0) ifTrue:[
	    ncols := 1.
	    nrows := nPattern
	] ifFalse:[
	    factor := nPattern // (nr * nc).
	    factor := factor sqrt asInteger.
	    nrows := nr * factor.
	    ncols := nc * factor.
	].
	(nrows * ncols) < nPattern ifTrue:[
	    ncols := ncols + 1.
	    nrows := nPattern // ncols.
	    (nrows * ncols) < nPattern ifTrue:[
		nrows := nrows + 1
	    ]
	].
    ].
    w := ((patternSize x + inSet + inSet) * ncols) + ((ncols - 1) * space).
    h := ((patternSize y + inSet + inSet) * nrows) + ((nrows - 1) * space).
    ^ w @ h
! !

!PatternMenu class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/PatternMenu.st,v 1.16 2009-02-12 15:57:47 cg Exp $'
! !
