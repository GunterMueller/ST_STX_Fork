"
 COPYRIGHT (c) 1998 by Andreas Vogel / eXept Software AG
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

PanelView subclass:#GridBagLayoutView
	instanceVariableNames:'columnWidths rowHeights columnWeights rowWeights layoutInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!GridBagLayoutView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by Andreas Vogel / eXept Software AG
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
GridBagLayout is a flexible layout manager that aligns components vertically and horizontally,
without requiring that the components be the same size. Each GridBagLayout uses a dynamic rectangular 
grid of cells, with each component occupying one or more cells (called its display area).
Each component managed by a GridBagLayout is associated with a GridBagConstraints instance that 
specifies how the component is laid out within its display area. How a GridBagLayout places a set of 
components depends on each component's GridBagConstraints and minimum size, as well as the preferred 
size of the components' container.

To use a GridBagLayout effectively, you must customize one or more of its components' GridBagConstraints.
You customize a GridBagConstraints object by setting one or more of its instance variables:

    gridX
    gridY
		Specifies the cell at the upper left of the component's display area, where the 
		upper-left-most cell has address gridX=0, gridY=0. Use #RELATIVE (the default value)
		to specify that the component be just placed just to the right of (for gridX)
		or just below (for gridY) the component that was added to the container just before 
		this component was added.

    gridWidth
    gridHeight
		Specifies the number of cells in a row (for gridWidth) or column (for gridHeight)
		in the component's display area. The default value is 1. Use #REMAINDER to specify
		that the component be the last one in its row (for gridWidth) or column (for gridHeight).
		Use #RELATIVE to specify that the component be the next to last one in its row 
		(for gridWidth) or column (for gridHeight).

    fill
		Used when the component's display area is larger than the component's requested size
		to determine whether (and how) to resize the component.
		Valid values are
		    #NONE
			(the default),
		    #HORIZONTAL
			(make the component wide enough to fill its display area
			horizontally, but don't change its height),
		    #VERTICAL
			(make the component tall enough to fill its display area
			vertically, but don't change its width), and
		    #BOTH       
			(make the component fill its display area entirely).

    ipadX
    ipadY
		Specifies the internal padding: how much to add to the minimum size of the component.
		The width of the component will be at least its minimum width plus ipadX*2 pixels
		(since the padding applies to both sides of the component). Similarly, the height of 
		the component will be at least the minimum height plus ipadY*2 pixels.

    insets
		Specifies the external padding of the component -- the minimum amount of space between 
		the component and the edges of its display area.

    anchor
		Used when the component is smaller than its display area to determine where (within the area) 
		to place the component.
		Valid values are
			#CENTER (the default),
			#NORTH,
			#NORTHEAST,
			#EAST,
			#SOUTHEAST,
			#SOUTH,
			#SOUTHWEST,
			#WEST, 
			#NORTHWEST.

    weightX
    weightY
		Used to determine how to distribute space; this is important for specifying resizing 
		behavior. Unless you specify a weight for at least one component in a row (weightX)
		and column (weightY), all the components clump together in the center of their container.
		This is because when the weight is zero (the default), the GridBagLayout puts any extra 
		space between its grid of cells and the edges of the container.


    [see also:]
	GridBagConstraints
	GridBagLayoutInfo
	Insets

    [author:]
	Andreas Vogel
"
!

examples
"
    This example is taken from the java source and should produce the same layout. Check the file
    Grid*.gif in the java distribution.

									[exBegin]
	| v p c |
	c := #(
	    #( fill: #BOTH weightX: 1.0 )                         
	    #( fill: #BOTH weightX: 1.0 )                         
	    #( fill: #BOTH weightX: 1.0 )                         
	    #( fill: #BOTH weightX: 1.0 gridWidth: #REMAINDER ) 
	    #( fill: #BOTH gridWidth: #REMAINDER )                
	    #( fill: #BOTH gridWidth: #RELATIVE )                 
	    #( fill: #BOTH gridWidth: #REMAINDER )                
	    #( fill: #BOTH weightY: 1.0 gridHeight: 2 )
	    #( fill: #BOTH gridWidth: #REMAINDER )                
	    #( fill: #BOTH gridWidth: #REMAINDER )                
	).           
	v := StandardSystemView new. v label:'GridBagLayoutView: Example 1'.
	p := GridBagLayoutView in:v. p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
	1 to: c size do:[ :i | | b |
	    b := Button label:('Button ',(i displayString)) in:p. 
	    b objectAttributeAt:#GridBagConstraints put:((#(GridBagConstraints) , (c at:i)) decodeAsLiteralArray). 
	].
	v extent:(p preferredExtent). v open.
									[exEnd]


									[exBegin]
	| v p c |
	c := #(
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH weightX: 1.0 )                         
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH weightX: 1.0 )                         
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH weightX: 1.0 )                         
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH weightX: 1.0 gridWidth: #REMAINDER ) 
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH gridWidth: #REMAINDER )                
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH gridWidth: #RELATIVE )                 
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH gridWidth: #REMAINDER )                
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH weightY: 1.0 gridHeight: 2 )
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH gridWidth: #REMAINDER )                
	    #( insets: #(Insets 2 2 2 2) fill: #BOTH gridWidth: #REMAINDER )                
	).           
	v := StandardSystemView new. v label:'GridBagLayoutView: Example 2'.
	p := GridBagLayoutView in:v. p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
	1 to: c size do:[ :i | | b |
	    b := Button label:('Button ',(i displayString)) in:p. 
	    b objectAttributeAt:#GridBagConstraints put:((#(GridBagConstraints) , (c at:i)) decodeAsLiteralArray). 
	].
	v extent:(p preferredExtent). v open.
									[exEnd]



"
! !

!GridBagLayoutView class methodsFor:'instance creation'!

new
    "Create a new instance of my class and do explizit initialization of it."

    ^ self basicNew initialize

    "Created: / 19.1.1998 / 13:53:11 / av"
    "Modified: / 1.2.1998 / 13:02:59 / av"
! !

!GridBagLayoutView methodsFor:'initialization'!

initialize
    "Initialize the instance. Mainly set our instance variables to required values."

    super initialize.

    columnWidths  := IdentityDictionaryWithDefault newWithDefaultValue:0.
    rowHeights    := IdentityDictionaryWithDefault newWithDefaultValue:0.

    columnWeights := IdentityDictionaryWithDefault newWithDefaultValue:0.0.
    rowWeights    := IdentityDictionaryWithDefault newWithDefaultValue:0.0.

    layoutInfo    := nil.

    "Created: / 19.1.1998 / 13:53:59 / av"
    "Modified: / 1.2.1998 / 12:57:05 / av"
! !

!GridBagLayoutView methodsFor:'layout'!

setChildPositions
    "(re)compute position of every child whenever childs are added or my size has changed"

    self arrangeGrid.

    "Modified: / 1.2.1998 / 12:52:22 / av"
! !

!GridBagLayoutView methodsFor:'private'!

adjustForGravity:c in:r

    |insets fill anchor diffx diffy add |

    insets := c insets.
    fill := c fill.
    anchor := c anchor.
    
    r setLeft: ((r left)   + (insets left)).
    r width:   ((r width)  - ((insets left) + (insets right))).
    r setTop:  ((r top)    + (insets top)).
    r height:  ((r height) - ((insets top) + (insets bottom))).

    diffx := 0.
    (fill ~~ #HORIZONTAL and:[(fill ~~ #BOTH) and:[(r width) > (add := (c minWidth) + (c ipadX))]]) ifTrue:[
        diffx := (r width) - add.
        r width:add.
    ].

    diffy := 0.
    (fill ~~ #VERTICAL and:[(fill ~~ #BOTH) and:[(r height) > (add := (c minHeight) + (c ipadY))]]) ifTrue:[
        diffy := (r height) - add.
        r height:add.
    ].

    (anchor == #CENTER) ifTrue:[
        r setLeft:((r left) + (diffx / 2)).
        r setTop:((r top) + (diffy / 2)).
    ].
    (anchor == #NORTH) ifTrue:[
        r setLeft:((r left) + (diffx / 2)).
    ].
    (anchor == #NORTHEAST) ifTrue:[
        r setLeft:((r left) + diffx).
    ].
    (anchor == #EAST) ifTrue:[
        r setLeft:((r left) + diffx).
        r setTop:((r top) + (diffy / 2)).
    ].
    (anchor == #SOUTHEAST) ifTrue:[
        r setLeft:((r left) + diffx).
        r setTop:((r top) + diffy).
    ].
    (anchor == #SOUTH) ifTrue:[
        r setLeft:((r left) + (diffx / 2)).
        r setTop:((r top) + diffy).
    ].
    (anchor == #SOUTHWEST) ifTrue:[
        r setTop:((r top) + diffy).
    ].
    (anchor == #WEST) ifTrue:[
        r setTop:((r top) + (diffy / 2)).
    ].
    (anchor == #NORTHWEST) ifTrue:[
    ].

    r setLeft: ((r left)   asInteger).
    r setTop:  ((r top)    asInteger).
    r width:   ((r width)  asInteger).
    r height:  ((r height) asInteger).

    ^ r

    "Modified: / 22.1.1998 / 09:50:01 / av"
!

arrangeGrid
    " Lay out the grid."

    | insets subViews info ext d r c diffw diffh weight |

    insets := Insets new.

    "/ If the parent has no slaves anymore, then don't do anything
    "/ at all:  just leave the parent's size as-is.
    (((subViews := self subViews) size) == 0) ifTrue:[^ self].

"/    self extentChangedFlag ifTrue:[
"/        ext    := self computeExtent.
"/        width  := ext x.
"/        height := ext y.
"/    ].

    "/ Pass #1: scan all the slaves to figure out the total amount
    "/ of space needed.
    
    info := self getLayoutInfo:#PREFERRED_SIZE.    
    d := self getMinSize:info.

    ((width < (d width)) or:[(height < (d height))]) ifTrue:[
        info := self getLayoutInfo:#MINIMUM_SIZE.    
        d := self getMinSize:info.
    ].

    layoutInfo := info.
    r := Rectangle origin:0@0 extent:((d width) @ (d height)).

    "/ If the current dimensions of the window don't match the desired
    "/ dimensions, then adjust the minWidth and minHeight arrays
    "/ according to the weights.

    diffw := width - (r width).
    (diffw ~~ 0) ifTrue:[
        weight := 0.0.
        0 to:((info width) - 1) do:[ :i |
            weight := weight + ((info weightX) at:(i + 1)).
        ].
        (weight > 0.0) ifTrue:[
            0 to:((info width) - 1) do:[ :i |    
                | dx |
                dx := ((diffw * ((info weightX) at:(i + 1))) / weight) asInteger.
                (info minWidth) at:(i + 1) put:(((info minWidth) at:(i + 1)) + dx).
                r width:((r width) + dx).
                (((info minWidth) at:(i + 1)) < 0) ifTrue:[
                    r width:((r width) - ((info minWidth) at:(i + 1))).
                    (info minWidth) at:(i + 1) put:0.
                ].
            ].
        ].
        diffw := width - (r width).
    ] ifFalse:[
        diffw := 0.
    ].

    diffh := height - (r height).
    (diffh ~~ 0) ifTrue:[
        weight := 0.0.
        0 to:((info height) - 1) do:[ :i |
            weight := weight + ((info weightY) at:(i + 1)).
        ].
        (weight > 0.0) ifTrue:[
            0 to:((info height) - 1) do:[ :i |    
                | dy |
                dy := ((diffh * ((info weightY) at:(i + 1))) / weight) asInteger.
                (info minHeight) at:(i + 1) put:(((info minHeight) at:(i + 1)) + dy).
                r height:((r height) + dy).
                (((info minHeight) at:(i + 1)) < 0) ifTrue:[
                    r height:((r height) - ((info minHeight) at:(i + 1))).
                    (info minHeight) at:(i + 1) put:0.
                ].
            ].
        ].
        diffh := height - (r height).
    ] ifFalse:[
        diffh := 0.
    ].

    "/ Now do the actual layout of the slaves using the layout information
    "/ that has been collected.

    info startX:(((diffw / 2) + (insets left)) asInteger).
    info startY:(((diffh / 2) + (insets top)) asInteger).

    subViews do:[ :child |
        |rW rH minWidth minHeight|

        c := self constraints:child.
        minWidth := info minWidth.
        minHeight := info minHeight.

        r setLeft:(info startX).
        0 to:((c tempX) - 1) do:[ :i | r setLeft:((r left) + (minWidth at:(i + 1))). ].
        
        r setTop:(info startY).
        0 to:((c tempY) - 1) do:[ :i | r setTop:((r top) + (minHeight at:(i + 1))). ].

        r width:0.
        (c tempX) to:((c tempX) + (c tempWidth) - 1) do:[ :i |
            r width:((r width) + (minWidth at:(i + 1))).
        ].

        r height:0.
        (c tempY) to:((c tempY) + (c tempHeight) - 1) do:[ :i |
            r height:((r height) + (minHeight at:(i + 1))).
        ].

        self adjustForGravity:c in:r.

        "/ If the window is too small to be interesting then
        "/ unmap it.  Otherwise configure it and then make sure
        "/ its mapped.
        rW := r width.
        rH := r height.

        ((rW <= 0) or:[rH <= 0]) ifTrue:[
            child origin:(0@0) ; width:0 height:0.
        ] ifFalse:[
            child origin:((r left) @ (r top)).
            child width:rW.
            child height:rH.
        ].
    ].

    "Modified: / 1.2.1998 / 12:53:37 / av"
!

constraints:anObject 
    " Get the GridBag constraints for an object. As a fallback create new constraints for objects
      which don't have any constraints yet."

    | c |

    c := anObject objectAttributeAt:#GridBagConstraints.
    c isNil ifTrue:[
	anObject objectAttributeAt:#GridBagConstraints put:(c := GridBagConstraints new)
    ].
    ^ c.

    "Created: / 21.1.1998 / 00:24:34 / av"
    "Modified: / 1.2.1998 / 12:55:23 / av"
!

getLayoutInfo:which
    "return a good extent, one that makes subviews fit"

    | 
        MAX_INT_VAL subViews 
        r i k px py pixelsDiff weightDiff weight nextSize c 
        curX curY curWidth curHeight curRow curCol xMax yMax
    |

    MAX_INT_VAL := 9999999999.
    subViews := (self subViews).

    r := GridBagLayoutInfo new.
    r width:0.
    r height:0.

    xMax := IdentityDictionaryWithDefault newWithDefaultValue:0.
    yMax := IdentityDictionaryWithDefault newWithDefaultValue:0.
    curRow := curCol := -1.

    "/ Pass #1
    "/
    "/ Figure out the dimensions of the layout grid (use a value of 1 for
    "/ zero or negative widths and heights).

    subViews do:[ :child |
        c := self constraints:child.

        curX := c gridX.
        curY := c gridY.
        ((curWidth  := c gridWidth)  <= 0) ifTrue:[ curWidth  := 1. ].
        ((curHeight := c gridHeight) <= 0) ifTrue:[ curHeight := 1. ].

        "/ If x or y is negative, then use relative positioning:
        ((curX < 0) and:[ curY < 0 ]) 
            ifTrue:[
                (curRow >= 0) 
                    ifTrue: [ curY := curRow. ]
                    ifFalse:[ (curCol >= 0) ifTrue:[ curX := curCol. ] ifFalse: [ curY := 0. ]].
            ].

        (curX < 0) 
            ifTrue:[
                px := 0.
                curY to:(curY + curHeight - 1) do: [ :i |
                    px := px max:(xMax at:(i + 1)).
                ].
                ((curX := px - curX - 1) < 0) ifTrue:[ curX := 0. ].
            ]
            ifFalse:[
                (curY < 0) ifTrue:[
                    py := 0.
                    curX to: (curX + curWidth - 1) do: [ :i |
                        py := py max: (yMax at:(i + 1)).
                    ].
                    ((curY := py - curY - 1) < 0) ifTrue:[ curY := 0. ].
                ].
            ].
        
        "/ Adjust the grid width and height
        px := curX + curWidth.  [ (r width)  < px ] whileTrue:[ r width:((r width) + 1). ].
        py := curY + curHeight. [ (r height) < py ] whileTrue:[ r height:((r height) + 1). ].

        "/ Adjust the xMax and yMax arrays
        curX to:(curX + curWidth  - 1) do:[ :i | yMax at:(i + 1) put:py. ].
        curY to:(curY + curHeight - 1) do:[ :i | xMax at:(i + 1) put:px. ].

        c minWidth:(child preferredWidth).
        c minHeight:(child preferredHeight).

        "/ Zero width and height must mean that this is the last item (or
        "/ else something is wrong). 
        (((c gridHeight) == 0) and:[ (c gridWidth) == 0 ]) ifTrue:[
            curRow := curCol := -1.
        ].

        "/ Zero width starts a new row
        (((c gridHeight) == 0) and:[ curRow < 0 ]) 
            ifTrue:[
                curCol := curX + curWidth.
            ]
            ifFalse:[
                ((c gridWidth) == 0 and:[ curCol < 0 ]) ifTrue:[
                    curRow := curY + curHeight.
                ].
            ].
    ].    

    "/
    "/ Apply minimum row/column dimensions
    "/
    ((r width)  < (columnWidths size)) ifTrue:[ r width:(columnWidths size). ].
    ((r height) < (rowHeights size))   ifTrue:[ r height:(rowHeights size). ].

    "/
    "/ Pass #2
    "/
    "/ Negative values for gridX are filled in with the current x value.
    "/ Negative values for gridY are filled in with the current y value.
    "/ Negative or zero values for gridWidth and gridHeight end the current
    "/ row or column, respectively.
    "/

    curRow := curCol := -1.
    xMax := IdentityDictionaryWithDefault newWithDefaultValue:0.
    yMax := IdentityDictionaryWithDefault newWithDefaultValue:0.

    subViews do:[ :child |
        c := self constraints:child.

        curX      := c gridX.
        curY      := c gridY.
        curWidth  := c gridWidth.
        curHeight := c gridHeight.

        "/ If x or y is negative, then use relative positioning:
        ((curX < 0) and:[ curY < 0 ]) 
            ifTrue:[
                (curRow >= 0) 
                    ifTrue: [ curY := curRow. ]
                    ifFalse:[ (curCol >= 0) 
                        ifTrue:  [ curX := curCol. ]
                        ifFalse: [ curY := 0. ].
                    ].
            ].

        (curX < 0) 
            ifTrue:[
                (curHeight <= 0) ifTrue:[
                    curHeight := curHeight + (r height) - curY.
                    (curHeight < 1) ifTrue:[ curHeight := 1. ].
                ].
                px := 0.
                curY to:(curY + curHeight - 1) do: [ :i | px := px max:(xMax at:(i + 1)). ].
                ((curX := px - curX - 1) < 0) ifTrue:[ curX := 0. ].
            ]
            ifFalse:[
                (curY < 0) ifTrue:[
                    (curWidth <= 0) ifTrue:[
                        curWidth := curWidth + (r width) - curX.
                        (curWidth < 1) ifTrue:[ curWidth := 1. ].
                    ].
                    py := 0.
                    curX to:(curX + curWidth - 1) do: [ :i | py := py max:(yMax at:(i + 1)). ].
                    ((curY := py - curY - 1) < 0) ifTrue:[ curY := 0. ].
                ].
            ].

        (curWidth <= 0) ifTrue:[
            curWidth := curWidth + (r width) - curX.
            (curWidth < 1) ifTrue:[ curWidth := 1. ].
        ].

        (curHeight <= 0) ifTrue:[
            curHeight := curHeight + (r height) - curY.
            (curHeight < 1) ifTrue:[ curHeight := 1. ].
        ].

        px := curX + curWidth.
        py := curY + curHeight.

        "/ Adjust the xMax and yMax arrays
        curX to: (curX + curWidth  - 1) do:[ :i | yMax at:(i + 1) put:py. ].
        curY to: (curY + curHeight - 1) do:[ :i | xMax at:(i + 1) put:px. ].

        "/ Zero width and height must mean that this is the last item (or
        "/ else something is wrong). 
        ((c gridHeight) == 0 and:[ (c gridWidth) == 0 ]) ifTrue:[
            curRow := curCol := -1.
        ].

        "/ Zero width starts a new row
        ((c gridHeight) == 0 and:[ curRow < 0 ]) 
            ifTrue:[
                curCol := curX + curWidth.
            ]
            ifFalse:[
                ((c gridWidth) == 0 and:[ curCol < 0 ]) ifTrue:[
                    curRow := curY + curHeight.
                ].
            ].
        
        "/ Assign the new values to the gridbag slave */
        c tempX:curX.
        c tempY:curY.
        c tempWidth:curWidth.
        c tempHeight:curHeight.
    ].

    "/
    "/ Apply minimum row/column dimensions and weights
    "/
    r minWidth:  (columnWidths copy). 
    r minHeight: (rowHeights copy). 
    r weightX:   (columnWeights copy). 
    r weightY:   (rowWeights copy).  

    "/
    "/ Pass #3
    "/
    "/ Distribute the minimun widths and weights:
    "/
    nextSize := MAX_INT_VAL.

    i := 1. [ i ~~ MAX_INT_VAL ] whileTrue:[
        subViews do:[ :child |
            c := self constraints:child.

            ((c tempWidth) == i) ifTrue:[
                px := (c tempX) + (c tempWidth).

                "/
                "/ Figure out if we should use this slaves weight.  If the weight
                "/ is less than the total weight spanned by the width of the cell,
                "/ then discard the weight.  Otherwise split the difference
                "/ according to the existing weights.
                "/
                weightDiff := (c weightX) asFloat.
                (c tempX) to:(px - 1) do:[ :k | weightDiff := weightDiff - ((r weightX) at:(k + 1)) ].

                (weightDiff > 0.0) ifTrue:[
                    weight := 0.0.
                    (c tempX) to:(px - 1) do:[ :k | weight := weight + ((r weightX) at:(k + 1)). ].

                    k := c tempX.
                    [ (weight > 0.0) and:[k < px] ] whileTrue:[
                        | wt dx |

                        wt := ((r weightX) at:(k + 1)) asFloat.
                        dx := (wt * weightDiff) / weight.
                        wt at:(k + 1) put:(wt + dx).
                        weightDiff := weightDiff - dx.
                        weight := weight - wt.
                    ].
                    (r weightX) at:(px - 1 + 1) put:(((r weightX) at:(px - 1 + 1)) + weightDiff).
                ].

                "/ Calculate the minWidth array values.
                "/ First, figure out how wide the current slave needs to be.
                "/ Then, see if it will fit within the current minWidth values.
                "/ If it will not fit, add the difference according to the
                "/ weightX array.

                pixelsDiff := (c minWidth) + (c ipadX) + (c insets left) + (c insets right).
                (c tempX) to:(px - 1) do:[ :k | 
                    pixelsDiff := pixelsDiff - ((r minWidth) at:(k + 1)).
                ].

                (pixelsDiff > 0) ifTrue:[
                    weight := 0.0.
                    (c tempX) to:(px - 1) do:[ :k | weight := weight + ((r weightX) at:(k + 1)). ].
                    k := c tempX.
                    [ (weight > 0.0) and:[k < px] ] whileTrue:[
                        | wt dx |

                        wt := ((r weightX) at:(k + 1)) asFloat.
                        dx := ((wt * pixelsDiff) / weight) asInteger.
                        (r minWidth) at:(k + 1) put:(((r minWidth) at:(k + 1)) + dx).
                        pixelsDiff := pixelsDiff - dx.
                        weight := weight - wt.
                    ].
                    (r minWidth) at:(px - 1 + 1) put:(((r minWidth) at:(px - 1 + 1)) + pixelsDiff).
                ].
            ] ifFalse:[
                (((c tempWidth) > i) and:[ (c tempWidth) < nextSize ]) ifTrue:[
                    nextSize := c tempWidth.
                ].
            ].

            "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            ((c tempHeight) == i) ifTrue:[
                py := (c tempY) + (c tempHeight).

                "/
                "/ Figure out if we should use this slaves weight.  If the weight
                "/ is less than the total weight spanned by the width of the cell,
                "/ then discard the weight.  Otherwise split the difference
                "/ according to the existing weights.
                "/
                weightDiff := (c weightY) asFloat.
                (c tempY) to:(py - 1) do:[ :k | weightDiff := weightDiff - ((r weightY) at:(k + 1)) ].

                (weightDiff > 0.0) ifTrue:[
                    weight := 0.0.
                    (c tempY) to:(py - 1) do:[ :k | weight := weight + ((r weightY) at:(k + 1)). ].

                    k := c tempY.
                    [ (weight > 0.0) and:[k < py] ] whileTrue:[
                        | wt dy |

                        wt := ((r weightY) at:(k + 1)) asFloat.
                        dy := (wt * weightDiff) / weight.
                        wt at:(k + 1) put:(wt + dy).
                        weightDiff := weightDiff - dy.
                        weight := weight - wt.
                    ].
                    (r weightY) at:(py - 1 + 1) put:(((r weightY) at:(py - 1 + 1)) + weightDiff).
                ].

                "/ Calculate the minWidth array values.
                "/ First, figure out how wide the current slave needs to be.
                "/ Then, see if it will fit within the current minWidth values.
                "/ If it will not fit, add the difference according to the
                "/ weightX array.

                pixelsDiff := (c minHeight) + (c ipadY) + (c insets top) + (c insets bottom).
                (c tempY) to:(py - 1) do:[ :k | 
                    pixelsDiff := pixelsDiff - ((r minHeight) at:(k + 1)).
                ].

                (pixelsDiff > 0) ifTrue:[
                    weight := 0.0.
                    (c tempY) to:(py - 1) do:[ :k | 
                        weight := weight + ((r weightY) at:(k + 1)).
                    ].
                    k := c tempY.
                    [ (weight > 0.0) and:[k < py] ] whileTrue:[
                        | wt dy |

                        wt := ((r weightY) at:(k + 1)) asFloat.
                        dy := ((wt * pixelsDiff) / weight) asInteger.
                        (r minHeight) at:(k + 1) put:(((r minHeight) at:(k + 1)) + dy).
                        pixelsDiff := pixelsDiff - dy.
                        weight := weight - wt.
                    ].
                    (r minHeight) at:(py - 1 + 1) put:(((r minHeight) at:(py - 1 + 1)) + pixelsDiff).
                ].
            ] ifFalse:[
                (((c tempHeight) > i) and:[ (c tempHeight) < nextSize ]) ifTrue:[
                    nextSize := c tempHeight.
                ].
            ].
        ].
        i := nextSize.
        nextSize := MAX_INT_VAL.
    ].

    ^ r

    "Modified: / 29.3.1997 / 11:06:45 / cg"
    "Created: / 19.1.1998 / 17:24:26 / av"
    "Modified: / 21.1.1998 / 18:40:38 / av"
!

getMinSize:info
    "Figure out the minimum size of the master based on the information from getLayoutInfo. The
     result will be returned as a rectangle with width and height set to the minimum size."

    | d insets t |

    insets := Insets new.

    d := Rectangle origin:0@0 extent:0@0.
    
    t := 0.
    1 to:(info width) do:[ :i | t := t + ((info minWidth) at:i). ].
    d width:(t + (insets left) + (insets right)).

    t := 0.
    1 to:(info height) do:[ :i | t := t + ((info minHeight) at:i). ].
    d height:(t + (insets top) + (insets bottom)).

    ^ d

    "Modified: / 1.2.1998 / 12:59:00 / av"
!

minimumLayoutSize
    "Return our minimum layout size. The width and height of the returned rectangle gives the minimum
     layout size."

    | info |

    info := self getLayoutInfo:#MINIMUM_SIZE.
    ^ self getMinSize:info

    "Created: / 19.1.1998 / 17:25:01 / av"
    "Modified: / 1.2.1998 / 12:59:38 / av"
!

preferredLayoutSize
    "Return our preffered layout size. The width and height of the returned rectangle gives the
    preferred layout size."

    | info |

    info := self getLayoutInfo:#PREFFERED_SIZE.
    ^ self getMinSize:info

    "Created: / 19.1.1998 / 17:23:37 / av"
    "Modified: / 1.2.1998 / 13:00:04 / av"
! !

!GridBagLayoutView methodsFor:'queries'!

preferredExtent
    "Return a good extent, one that makes subviews fit. Return the the preferred extent as a point
    where x and y represents the width and height of the extent."

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    self subViews isNil ifTrue:[ 
        ^ super preferredExtent. 
    ].

    ^ self preferredLayoutSize extent.

    "Created: / 17.1.1998 / 00:11:46 / av"
    "Modified: / 1.2.1998 / 13:01:46 / av"
! !

!GridBagLayoutView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

