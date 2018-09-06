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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Geometric subclass:#Rectangle
	instanceVariableNames:'left top width height'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Rectangle class methodsFor:'documentation'!

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
    Rectangles represent a rectangular area in 2D space.

    notice, my implementation does not use origin/corner as instance objects
    but left/top/width/height to save space and allocations. This means, that my
    Rectangles cannot be used to represent Rectangles in a higher than 2D
    space. (i.e. only valid if origin/corner are 2D Points)

    (aside from that, you will not see any difference from the outside)

    Instance variables:

	left           <Number>        the left coordinate (i.e origin x)
	top            <Number>        the top coordinate (i.e origin y)
	width          <Number>        the width of the rectangle
	height         <Number>        the height of the rectangle

    I am not certain, if implementing Rectangle different was a good idea -
    subclasses may expect things to be different ...
    Therefore, this may change.

    [author:]
	Claus Gittinger

    [see also:]
	Point Polygon Circle EllipticalArc Spline
	LayoutOrigin LayoutFrame AlignmentOrigin Layout
	View GraphicsContext StrokingWrapper FillingWrapper
"
! !

!Rectangle class methodsFor:'instance creation'!

center:centerPoint extent:extentPoint
    "return an instance of me whose center is centerPoint and width
     by height is extentPoint."

    ^ self
	origin:centerPoint - (extentPoint//2)
	extent:extentPoint
!

decodeFromLiteralArray:anArray
    "create & return a new instance from information encoded in anArray.
     Redefined for faster creation."

    |l t w h|

    l := anArray at:2.
    t := anArray at:3.
    w := (anArray at:4) - l.
    h := (anArray at:5) - t.
    ^ self left:l top:t width:w height:h

    "
     Rectangle decodeFromLiteralArray:#(Rectangle 100 200 300 500)
    "

    "Created: / 28.1.1998 / 17:46:52 / cg"
!

encompassing:listOfPoints
    "Return a rectangle, which encompasses all of the given points."

    |topLeft bottomRight|

    topLeft := bottomRight := nil.
    listOfPoints do:[:p |
        topLeft isNil
            ifTrue: [topLeft := bottomRight := p]
            ifFalse: [topLeft := topLeft min: p.
                      bottomRight := bottomRight max: p]
    ].
    ^ topLeft corner: bottomRight

    "
     Rectangle encompassing:(Array with:10@10 with:50@0 with:0@50)
    "
!

left:left right:right top:top bottom:bottom
    "create and return a new Rectangle giving left, top, right and bottom coordinates"

    ^ (self basicNew) left:left right:right top:top bottom:bottom
!

left:left top:top extent:extent
    "create and return a new Rectangle giving left, top, and
     an extent point."

    ^ (self basicNew) left:left top:top extent:extent

    "Created: 8.5.1996 / 20:56:29 / cg"
!

left:left top:top right:right bottom:bottom
    "create and return a new Rectangle giving left, top, right and bottom coordinates"

    ^ (self basicNew) left:left top:top right:right bottom:bottom
!

left:left top:top width:w height:h
    "create and return a new Rectangle giving left and top coordinates
     and width, height"

%{  /* NOCONTEXT */
    REGISTER OBJ newRect;
    OBJ t;
    int spc;

    if (__CanDoQuickNew(OHDR_SIZE + 4*sizeof(OBJ))) {   /* OBJECT ALLOCATION */
	if (self == Rectangle) {
	    /*
	     * short cut - rectangles are created so often ...
	     */
	    __qCheckedNew(newRect, OHDR_SIZE + 4*sizeof(OBJ));

	    __InstPtr(newRect)->o_class = Rectangle;
	    __qSTORE(newRect, Rectangle);

	    __InstPtr(newRect)->i_instvars[0] = left;
	    __InstPtr(newRect)->i_instvars[1] = top;
	    __InstPtr(newRect)->i_instvars[2] = w;
	    __InstPtr(newRect)->i_instvars[3] = h;

	    if (! (__bothSmallInteger(left, top) &&
		   __bothSmallInteger(w, h))) {
		spc = __qSpace(newRect);
		__STORE_SPC(newRect, left, spc);
		__STORE_SPC(newRect, top, spc);
		__STORE_SPC(newRect, w, spc);
		__STORE_SPC(newRect, h, spc);
	    }

	    RETURN ( newRect );
	}
    }
%}.
    ^ (self basicNew) left:left top:top width:w height:h
!

merging: listOfRects
    "return the merge of a number of rectangles.
     Avoids creation of temp garbage."

    | topLeft bottomRight |

    topLeft := bottomRight := nil.
    listOfRects do:[:r |
        topLeft isNil ifTrue: [
            topLeft := r topLeft.
            bottomRight := r bottomRight
        ] ifFalse: [
            topLeft := topLeft min: r topLeft.
            bottomRight := bottomRight max: r bottomRight
        ]
    ].
    ^ topLeft corner: bottomRight
!

origin:origin corner:corner
    "create and return a new Rectangle giving top-left and bottom-right points"

    ^ (self basicNew) origin:origin corner:corner
!

origin:origin extent:extent
    "create and return a new Rectangle giving top-left point and extent point"

%{  /* NOCONTEXT */
    REGISTER OBJ newRect;
    OBJ t;
    int spc;

    if (__CanDoQuickNew(OHDR_SIZE + 4*sizeof(OBJ))) {   /* OBJECT ALLOCATION */
	/*
	 * short cut - rectangles are created so often ...
	 */
	if (self == Rectangle) {
	    if (__isPoint(origin) && __isPoint(extent)) {
		__qCheckedNew(newRect, OHDR_SIZE + 4*sizeof(OBJ));
		__InstPtr(newRect)->o_class = Rectangle;
		__qSTORE(newRect, Rectangle);
		spc = __qSpace(newRect);

		t = __PointInstPtr(origin)->p_x;
		__InstPtr(newRect)->i_instvars[0] = t;
		__STORE_SPC(newRect, t, spc);

		t = __PointInstPtr(origin)->p_y;
		__InstPtr(newRect)->i_instvars[1] = t;
		__STORE_SPC(newRect, t, spc);

		t = __PointInstPtr(extent)->p_x;
		__InstPtr(newRect)->i_instvars[2] = t;
		__STORE_SPC(newRect, t, spc);

		t = __PointInstPtr(extent)->p_y;
		__InstPtr(newRect)->i_instvars[3] = t;
		__STORE_SPC(newRect, t, spc);
		RETURN ( newRect );
	    }
	}
    }
%}.
    ^ (self basicNew) origin:origin extent:extent
!

origin:origin width:w height:h
    "create and return a new Rectangle giving top-left and extent
     as individual width/height"

    ^ (self basicNew) origin:origin width:w height:h

    "Created: 8.5.1996 / 20:55:53 / cg"
!

vertex:vertex1Point vertex:vertex2Point
    "create and return a new instance of the receiver,
     given two diagonally opposite vertices."

    ^ self
	origin: (vertex1Point min: vertex2Point)
	corner: (vertex1Point max: vertex2Point)

    "Created: 10.2.1997 / 12:14:32 / cg"
! !

!Rectangle class methodsFor:'instance creation-interactive'!

fromUser
    "let user specify a rectangle on the screen, return it.
     If the user presses ESC, an AbortOperationRequest is raised."

    ^ Screen current rectangleFromUser

    "
     Rectangle fromUser
    "
!

originFromUser:extent
    "let user specify an origin on the screen, return it"

    ^ Screen current originFromUser:extent

    "
     Rectangle originFromUser:50@50
    "
! !

!Rectangle methodsFor:'Compatibility-Squeak'!

amountToTranslateWithin: aRectangle
    "Answer a Point, delta, such that self + delta is forced within aRectangle."
    "Altered so as to prefer to keep self topLeft inside when all of self
     cannot be made to fit 7/27/96 di"

    | dx dy |

    dx := 0.  dy := 0.
    self right > aRectangle right ifTrue: [dx := aRectangle right - self right].
    self bottom > aRectangle bottom ifTrue: [dy := aRectangle bottom - self bottom].
    (self left + dx) < aRectangle left ifTrue: [dx := aRectangle left - self left].
    (self top + dy) < aRectangle top ifTrue: [dy := aRectangle top - self top].
    ^ dx@dy
!

containsRect:aRect
    "Answer whether aRect is within the receiver (OK to coincide)."

    ^ self contains:aRect
!

isTall
    "return true, if the receiver is higher then its width"

    ^ self height > self width
!

isWide
    "return true, if the receiver is wider then its height"

    ^ self width > self height
!

translatedToBeWithin: aRectangle
    "Answer a copy of the receiver that does not extend beyond aRectangle.  7/8/96 sw"

    ^ self translateBy: (self amountToTranslateWithin: aRectangle)
!

withHeight:height
    "Return a copy of me with a different height"

    |origin corner|

    origin := self origin.
    corner := self corner.
    ^ origin corner:(corner x @ (origin y + height))
! !

!Rectangle methodsFor:'accessing'!

area
    "return the area
     - for screen Rectangles this is the number of pixels"

    ^ width * height
!

bottom
    "return the y coordinate of the bottom"

    ^ (top + height)
!

bottom:aNumber
    "set the bottom edge - warning: destructive"

    height := aNumber - top
!

bottomCenter
    "return the bottom center point"

    ^ (left + (width / 2)) @ (top + height)

    "Modified: 4.6.1996 / 16:04:08 / cg"
!

bottomLeft
    "return the bottom-left point"

    ^ left @ (top + height)
!

bottomRight
    "return the bottom-right point"

    ^ (left + width) @ (top + height)
!

center
    "return the point in the center of the receiver"

    ^ (left + (width / 2)) @ (top + (height / 2))

    "Modified: 4.6.1996 / 16:03:53 / cg"
!

corner
    "return the corner"

%{  /* NOCONTEXT */
    if (self == @global(Rectangle)) {
	OBJ _tleft = __INST(left);
	OBJ _ttop = __INST(top);
	OBJ _twidth = __INST(width);
	OBJ _theight = __INST(height);

	if (__bothSmallInteger(_tleft, _ttop)
	 && __bothSmallInteger(_twidth, _theight)) {
	    if (__CanDoQuickNew(sizeof(struct __Point))) {      /* OBJECT ALLOCATION */
		OBJ newPoint;
		int spc;
		int cX = __intVal(_tleft) + __intVal(_twidth);
		int cY = __intVal(_ttop) + __intVal(_theight);

		if (__ISVALIDINTEGER(cX) && __ISVALIDINTEGER(cY)) {
		    __qCheckedNew(newPoint, sizeof(struct __Point));
		    __InstPtr(newPoint)->o_class = self; __qSTORE(newPoint, self);
		    __PointInstPtr(newPoint)->p_x = __MKSMALLINT(cX);
		    __PointInstPtr(newPoint)->p_y = __MKSMALLINT(cY);
		    RETURN ( newPoint );
		}
	    }
	}
    }
%}.
    ^ (left + width) @ (top + height)
!

corner:aPoint
    "set the bottom-right corner - warning: destructive"

    width := aPoint x - left.
    height := aPoint y - top
!

extent
    "return the extent"

%{  /* NOCONTEXT */

    if (__CanDoQuickNew(sizeof(struct __Point))) {      /* OBJECT ALLOCATION */
	if (self == @global(Rectangle)) {
	    OBJ newPoint;
	    int spc;
	    OBJ newX = __INST(width);
	    OBJ newY = __INST(height);

	    __qCheckedNew(newPoint, sizeof(struct __Point));
	    __InstPtr(newPoint)->o_class = self; __qSTORE(newPoint, self);
	    __PointInstPtr(newPoint)->p_x = newX;
	    __PointInstPtr(newPoint)->p_y = newY;
	    if (! __bothSmallInteger(newX, newY)) {
		spc = __qSpace(newPoint);
		__STORE_SPC(newPoint, newX, spc);
		__STORE_SPC(newPoint, newY, spc);
	    }
	    RETURN ( newPoint );
	}
    }
%}.
    ^ Point x:width y:height
!

extent:aPoint
    "set the extent from the argument, aPoint with width taken from aPoint x
     and height taken from aPoint y.
     warning: destructive"

    width := aPoint x.
    height := aPoint y
!

height
    "return the height of the rectangle"

    ^ height
!

height:aNumber
    "change the height of the rectangle.
     logically, this changes the corner to get the given height.
     warning: destructive"

    height := aNumber

    "Created: 3.3.1997 / 16:33:22 / cg"
!

left
    "return the x-coordinate of the top-left origin"

    ^ left
!

left:aNumber
    "set the left edge, adjust width - warning: destructive"

    left notNil ifTrue:[
	"adjust width"
	width := width + (left - aNumber).
    ].
    left := aNumber
!

left:newLeft right:right top:newTop bottom:bottom
    "set the rectangle given left, top, right and bottom coordinates.
     warning: destructive"

    left := newLeft.
    top := newTop.
    width := right - left.
    height := bottom - top
!

left:newLeft top:newTop extent:extent
    "set the rectangle given left, top, coordinates and an extent.
     warning: destructive"

    left := newLeft.
    top := newTop.
    width := extent x.
    height := extent y

    "Created: 8.5.1996 / 20:55:10 / cg"
!

left:newLeft top:newTop right:right bottom:bottom
    "set the rectangle given left, top, right and bottom coordinates.
     warning: destructive"

    left := newLeft.
    top := newTop.
    width := right - left.
    height := bottom - top
!

left:newLeft top:newTop width:newWidth height:newHeight
    "set the rectangle given left, top coordinates and width, height.
     warning: destructive"

    left := newLeft.
    top := newTop.
    width := newWidth.
    height := newHeight
!

leftCenter
    "return the left center point"

    ^ left @ (top + (height / 2))

    "Modified: 4.6.1996 / 16:04:01 / cg"
!

origin
    "return the origin"

%{  /* NOCONTEXT */

    /*
     * claus: I am no longer certain, if this primitive is worth the effort
     */
    if (__CanDoQuickNew(sizeof(struct __Point))) {      /* OBJECT ALLOCATION */
	if (self == @global(Rectangle)) {
	    OBJ newPoint;
	    int spc;
	    OBJ newX = __INST(left);
	    OBJ newY = __INST(top);

	    __qCheckedNew(newPoint, sizeof(struct __Point));
	    __InstPtr(newPoint)->o_class = self; __qSTORE(newPoint, self);
	    __PointInstPtr(newPoint)->p_x = newX;
	    __PointInstPtr(newPoint)->p_y = newY;
	    if (! __bothSmallInteger(newX, newY)) {
		spc = __qSpace(newPoint);
		__STORE_SPC(newPoint, newX, spc);
		__STORE_SPC(newPoint, newY, spc);
	    }
	    RETURN ( newPoint );
	}
    }
%}.
    ^ Point x:left y:top
!

origin:aPoint
    "set the top-left origin. The corner remains unchanged.
     warning: destructive"

    |newTop newLeft|

    newLeft := aPoint x.
    newTop := aPoint y.
    left notNil ifTrue:[
	width := width + (left - newLeft).
    ].
    top notNil ifTrue:[
	height := height + (top - newTop).
    ].
    left := newLeft.
    top := newTop
!

origin:origin corner:corner
    "set both origin and corner - warning: destructive"

    left := origin x.
    top := origin y.
    width := corner x - left.
    height := corner y - top
!

origin:origin extent:extent
    "set both origin and extent - warning: destructive"

    left := origin x.
    top := origin y.
    width := extent x.
    height := extent y
!

origin:origin width:w height:h
    "set both origin and extent;
     the extent is given as individual width and height.
     warning: destructive"

    left := origin x.
    top := origin y.
    width := w.
    height := h

    "Created: 8.5.1996 / 20:53:53 / cg"
!

right
    "return the x coordinate of the right"

    ^ (left + width)
!

right:aNumber
    "set the right edge - warning: destructive"

    width := aNumber - left
!

rightCenter
    "return the right center point"

    ^ (left + width) @ (top + (height / 2))

    "Modified: 4.6.1996 / 16:09:05 / cg"
!

setLeft:newLeft
    "set left without adjusting width - warning: destructive"

    left := newLeft.

    "Modified: / 22.1.1998 / 09:40:35 / av"
    "Created: / 3.2.1998 / 19:01:06 / cg"
!

setOrigin:newOrigin corner:newCorner
    "set the rectangles dimensions - warning: destructive"

    self origin:newOrigin corner:newCorner
!

setTop:newTop
    "set top without adjusting height - warning: destructive"

    top := newTop.

    "Modified: / 20.1.1998 / 18:25:35 / av"
    "Created: / 3.2.1998 / 19:01:01 / cg"
!

top
    "return the y-coordinate of the top-left"

    ^ top
!

top:aNumber
    "set the top edge, adjust height - warning: destructive"

    top notNil ifTrue:[
	"adjust height"
	height := height + (top - aNumber).
    ].
    top := aNumber
!

topCenter
    "return the top center point"

    ^ (left + (width / 2)) @ top

    "Modified: 4.6.1996 / 16:09:09 / cg"
!

topLeft
    "return the top-left point - the same as origin"

    ^ left @ top
!

topLeft:aPoint
    "Set the top and left edges.
     The bottom right remains unchanged.
     warning: destructive"

    |newTop|

    newTop := aPoint y.
    height := height + (top - newTop).
    top := newTop.
    width := aPoint x - left
!

topRight
    "return the top-right point"

    ^ (left + width) @ top
!

topRight:aPoint
    "Set the top and right edges.
     The bottom left remains unchanged.
     warning: destructive"

    |newTop|

    newTop := aPoint y.
    height := height + (top - newTop).
    top := newTop.
    width := aPoint x - left
!

vertices
    "return the array containing my points as a closed polygon (for Polygon compatibility)"

    ^ Array
	with:(self topLeft)
	with:(self topRight)
	with:(self bottomRight)
	with:(self bottomLeft)
	with:(self topLeft)

    "
     (Rectangle origin:100@100 extent:20@30) vertices
     (Rectangle origin:100@100 extent:20@30) asPolygon vertices
    "

    "Modified: / 16-07-2010 / 16:59:16 / cg"
!

width
    "return the width of the rectangle"

    ^ width
!

width:aNumber
    "change the width of the rectangle.
     logically, this changes the corner to get the given width.
     warning: destructive"

    width := aNumber

    "Created: 3.3.1997 / 16:33:48 / cg"
! !

!Rectangle methodsFor:'comparing'!

= aRectangle
    "return true, if the argument aRectangle represents the same
     rectangle as the receiver"

%{  /* NOCONTEXT */
    /*
     * because rectangles are often compared in the graphics code,
     * handle the common case quickly
     */
    if (__isNonNilObject(aRectangle)
     && __qClass(aRectangle) == Rectangle) {
	if ((__InstPtr(self)->i_instvars[0] == __InstPtr(aRectangle)->i_instvars[0])
	 && (__InstPtr(self)->i_instvars[1] == __InstPtr(aRectangle)->i_instvars[1])
	 && (__InstPtr(self)->i_instvars[2] == __InstPtr(aRectangle)->i_instvars[2])
	 && (__InstPtr(self)->i_instvars[3] == __InstPtr(aRectangle)->i_instvars[3])) {
	    RETURN ( true );
	}
	if (__bothSmallInteger(__InstPtr(self)->i_instvars[0], __InstPtr(aRectangle)->i_instvars[0])
	 && __bothSmallInteger(__InstPtr(self)->i_instvars[1], __InstPtr(aRectangle)->i_instvars[1])
	 && __bothSmallInteger(__InstPtr(self)->i_instvars[2], __InstPtr(aRectangle)->i_instvars[2])
	 && __bothSmallInteger(__InstPtr(self)->i_instvars[3], __InstPtr(aRectangle)->i_instvars[3])) {
	    RETURN ( false );
	}
    }
%}.
    (aRectangle species ~~ self species) ifTrue:[^ false].

    left = aRectangle left ifFalse:[^ false].
    top = aRectangle top ifFalse:[^ false].
    width = aRectangle width ifFalse:[^ false].
    height = aRectangle height ifFalse:[^ false].
    ^ true
!

hash
    "return an integer useful for hashing -
     redefined since = is redefined here"

    ^ ((left hash bitShift:16) bitXor:(top hash bitShift:16))
      + ((width hash) bitXor:(height hash))
! !

!Rectangle methodsFor:'converting'!

asFractionalLayout
    "return a layoutFrame in which fractions (top, left, bottom, right)
     are taken from corresponding edges of the receiver.
     You have to make certain that those are in 0..1."

    |l|

    l := LayoutFrame new.
    l
        leftFraction:(self left);
        rightFraction:(self right);
        topFraction:(self top);
        bottomFraction:(self bottom).
    ^ l

    "
     (0.5@0.5 corner:0.75@0.75) asFractionalLayout
     (0.5@0.5 corner:0.75@0.75) asOffsetLayout
     (0.5@0.5 corner:0.75@0.75) asLayout
     (0@0 corner:1@1) asLayout
     (0@0 corner:1@1) asFractionalLayout
     (0@0 corner:1@1) asOffsetLayout
    "
!

asLayout
    "return a layoutFrame in which offsets (top, left, bottom, right)
     are taken from corresponding edges of the receiver.
     If all values are between 0.0 .. 1.0, a fractionalLayout is created,
     otherwise, an offsetLayout"

    |newLayout l r t b|

    newLayout := LayoutFrame new.
    l := left.
    r := (self right).
    t := top.
    b := (self bottom).
    ((l between:0.0 and:1.0)
    and:[(r between:0.0 and:1.0)
    and:[(t between:0.0 and:1.0)
    and:[(b between:0.0 and:1.0)]]]) ifTrue:[
	newLayout
	    leftFraction:l;
	    rightFraction:r;
	    topFraction:t;
	    bottomFraction:b.
    ] ifFalse:[
	newLayout
	    leftOffset:l;
	    rightFraction:0 offset:r;
	    topOffset:t;
	    bottomFraction:0 offset:b.
    ].
    ^ newLayout

    "
     (0.5@0.5 corner:0.75@0.75) asFractionalLayout
     (0.5@0.5 corner:0.75@0.75) asOffsetLayout
     (0.5@0.5 corner:0.75@0.75) asLayout
     (0@0 corner:1@1) asLayout
     (0@0 corner:1@1) asFractionalLayout
     (0@0 corner:1@1) asOffsetLayout
    "

    "Modified: 5.6.1996 / 00:45:46 / cg"
!

asOffsetLayout
    "return a layoutFrame in which offsets (top, left, bottom, right)
     are taken from corresponding edges of the receiver.
     You have to make certain that those are in 0..1."

    |newLayout|

    newLayout := LayoutFrame new.
    newLayout
	leftOffset:(self left);
	rightFraction:0 offset:(self right);
	topOffset:(self top);
	bottomFraction:0 offset:(self bottom).
    ^ newLayout

    "
     (0.5@0.5 corner:0.75@0.75) asFractionalLayout
     (0.5@0.5 corner:0.75@0.75) asOffsetLayout
     (0.5@0.5 corner:0.75@0.75) asLayout

     (10@10 corner:20@20) asFractionalLayout
     (10@10 corner:20@20) asOffsetLayout
     (10@10 corner:20@20) asLayout
    "

!

asPointArray
    "return an array containing my corners (clockwise) and
     the origin again as 5th element. Can be used to convert
     a rectangle into a polygon."

    |org|

    ^ Array with:(org := self origin)
	    with:self topRight
	    with:self corner
	    with:self bottomLeft
	    with:org

    "
     (10@10 corner:100@100) asPointArray
    "
!

asPolygon
    "return a polygon from the receiver"

    ^ Polygon vertices:self asPointArray

    "
     (10@10 corner:100@100) asPolygon
    "

    "Modified: 8.5.1996 / 20:14:44 / cg"
!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be of the form: (Rectangle orgX orgY cornX cornY)"

    left := encoding at:2.
    top := encoding at:3.
    width := (encoding at:4) - left.
    height := (encoding at:5) - top


    "
     Rectangle new fromLiteralArrayEncoding:#(Rectangle 100 200 300 500)
    "
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is: (Rectangle orgX orgY cornX cornY)"

    ^ Array
	with:#Rectangle
	with:left
	with:top
	with:(left + width)
	with:(top + height)


    "
     Rectangle new fromLiteralArrayEncoding:#(Rectangle 100 200 300 500)
     (100@200 corner:300@500) literalArrayEncoding
    "

    "Modified: 1.9.1995 / 02:16:54 / claus"
    "Modified: 22.4.1996 / 13:00:36 / cg"
!

rectangleRelativeTo:aRectangle preferred:prefRectHolder
    "compute a displayRectangle, treating the receiver like a
     layoutFrame.
     This allows rectangles to be used interchangable with Layouts."

    ^ (self asLayout) rectangleRelativeTo:aRectangle preferred:prefRectHolder

    "
     (10@20 corner:20@30) rectangleRelativeTo:(0@0 corner:100@100) preferred:(0@0 corner:50@50)

     (0.5@0.5) rectangleRelativeTo:(0@0 corner:100@100) preferred:(0@0 corner:50@50)
    "

    "Modified: / 27.5.1998 / 10:20:20 / cg"
! !

!Rectangle methodsFor:'destructive rectangle operations'!

expandBy:delta
    "destructively expanded the receiver in all directions
     by amount, a Point, Rectangle or Number.
     Warning: this is a destructive operation, modifying the receiver
     NOT returning a copy. You have to be certain to be the exclusive
     owner of the receiver to avoid side effects. See also: #expandedBy:"

    |amountPoint deltaLeft deltaTop deltaWidth deltaHeight|

    delta isNumber ifTrue:[
	deltaLeft := deltaTop := delta.
	deltaWidth := deltaHeight := delta * 2.
    ] ifFalse:[
	delta isRectangle ifTrue:[
	    deltaLeft := delta left.
	    deltaTop := delta top.
	    deltaWidth := deltaLeft + delta right.
	    deltaHeight := deltaTop + delta bottom
	] ifFalse:[
	    amountPoint := delta asPoint.
	    deltaLeft := amountPoint x.
	    deltaTop := amountPoint y.
	    deltaWidth := deltaLeft * 2.
	    deltaHeight := deltaTop * 2.
	]
    ].

    left := (left - deltaLeft).
    top := (top - deltaTop).
    width := (width + deltaWidth).
    height := (height + deltaHeight).

    "
     |r|
     r := Rectangle origin:10@10 corner:100@100.
     r expandBy:5.

     r := Rectangle origin:10@10 corner:100@100.
     r expandBy:(5 @ 0).

     r := Rectangle origin:10@10 corner:100@100.
     r expandBy:(10 @ 10).

     r := Rectangle origin:10@10 corner:100@100.
     r expandBy:( 10@10 corner:20@20 )
    "
!

moveBy:aPoint
    "destructively translate the rectangle by some distance.
     sorry for the name inconsistency - but GNU-ST named it that way"

    left := left + aPoint x.
    top := top + aPoint y
!

moveTo:aPoint
    "destructively translate the rectangle to have its origin at aPoint."

    |diff|

    diff := aPoint - self origin.
    self origin:aPoint corner:self corner + diff
!

scaleBy:scale
    "scale the receiver rectangle by scale (a Number or Point).
     This is destructive (modifies the receiver, not a copy) and
     should only be used if you know, that you are the exclusive owner
     of the receiver. (use scaledBy if in doubt)"

    |scalePoint sx sy|

    (scale isMemberOf:Point) ifTrue:[  "type hint to stc"
	sx := scale x.
	sy := scale y
    ] ifFalse:[
	scalePoint := scale asPoint.
	sx := scalePoint x.
	sy := scalePoint y
    ].
    width := width * sx.
    height := height * sy.
    left := left * sx.
    top := top * sy

    "
     (Rectangle origin:10@10 corner:50@50) scaleBy:2
    "

    "its destructive:"
    "
     |r1 r2|

     r1 := Rectangle origin:10@10 corner:50@50.
     r2 := r1 scaleBy:2.
     r1
    "
!

translateBy:amount
    "translate (i.e. move) the receiver rectangle
     by amount, a Point or Number.
     This is destructive (modifies the receiver, not a copy) and
     should only be used if you know, that you are the exclusive owner
     of the receiver. (use translatedBy if in doubt)"

    |amountPoint|

    (amount isMemberOf:Point) ifTrue:[  "type hint to stc"
	left := left + amount x.
	top := top + amount y
    ] ifFalse:[
	amountPoint := amount asPoint.
	left := left + amountPoint x.
	top := top + amountPoint y
    ]

    "
     (Rectangle origin:10@10 corner:50@50) translateBy:10
    "

    "its destructive:"
    "
     |r1 r2|

     r1 := Rectangle origin:10@10 corner:50@50.
     r2 := r1 translateBy:10.
     r1
    "
! !

!Rectangle methodsFor:'displaying'!

displayFilledOn:aGC
    "display a filled rectangle as represented by the receiver in
     the graphicsContext, aGC"

    aGC fillRectangleX:left y:top width:width height:height

    "
     |v|

     v := View new openAndWait.

     (Rectangle origin:10@10 corner:50@50) displayFilledOn:v
    "

    "Modified: 8.5.1996 / 14:40:42 / cg"
!

displayStrokedOn:aGC
    "display an unfilled rectangle as represented by the receiver in
     the graphicsContext, aGC"

    aGC displayRectangleX:left y:top width:width height:height

    "
     |v|

     v := View new openAndWait.

     (Rectangle origin:10@10 corner:50@50) displayStrokedOn:v
    "

    "Modified: 8.5.1996 / 14:40:53 / cg"
! !


!Rectangle methodsFor:'printing & storing'!

printOn:aStream
    "print the receiver on aStream"

    aStream nextPutAll:(self class name).
    aStream nextPutAll:' origin:'.
    (self origin) printOn:aStream.
    aStream nextPutAll:' extent:'.
    (self extent) printOn:aStream

    "Modified: 29.5.1996 / 00:17:39 / cg"
!

storeOn:aStream
    "store the receiver on aStream; i.e. print an expression which will
     reconstruct the receiver"

    aStream nextPut:$(.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' origin:'.
    (self origin) storeOn:aStream.
    aStream nextPutAll:' extent:'.
    (self extent) storeOn:aStream.
    aStream nextPut:$)

    "Modified: 29.5.1996 / 00:17:42 / cg"
! !

!Rectangle methodsFor:'queries'!

bounds
    "return the smallest enclosing rectangle"

    ^ self

    "Created: 8.5.1996 / 13:56:24 / cg"
    "Modified: 8.5.1996 / 14:06:38 / cg"
!

computeBounds
    "return the smallest enclosing rectangle"

    ^ self

    "Modified: 8.5.1996 / 14:06:38 / cg"
    "Created: 12.2.1997 / 11:44:45 / cg"
!

contains:aRectangle
    "return true, if the argument, aRectangle is equal to or
     is contained fully within the receiver"

%{  /* NOCONTEXT */
    /*
     * claus: this may be often called by objectView
     * the primitive code below (although looking ugly)
     * speeds that up by almost a factor of 2 ...
     */
    OBJ slf = self;
    OBJ rct = aRectangle;

    if (__isNonNilObject(rct)
     && __qClass(rct) == Rectangle) {
	OBJ r_l, r_w, r_t, r_h, l, w, t, h;
	INT r_ir, r_il, r_ib, r_it;
	INT il, it, ir, ib, iw, ih;

	r_l = __OINST(rct, left);
	l = __OINST(slf, left);
	if (__bothSmallInteger(r_l, l)) {
#ifndef POSITIVE_ADDRESSES      /* tag in low-bit */
	    il = (INT)(l);
	    r_il = (INT)(r_l);
#else
	    il = __intVal(l);
	    r_il = __intVal(r_l);
#endif
	    if (il > r_il) { RETURN (false); }   /* left > aRectangle left */

	    r_t = __OINST(rct, top);
	    t = __OINST(slf, top);
	    if (__bothSmallInteger(r_t, t)) {
#ifndef POSITIVE_ADDRESSES      /* tag in low-bit */
		it = (INT)(t);
		r_it = (INT)(r_t);
#else
		it = __intVal(t);
		r_it = __intVal(r_t);
#endif
		if (it > r_it) { RETURN (false); }   /* top > aRectangle top */

		r_w = __OINST(rct, width);
		w = __OINST(slf, width);
		if (__bothSmallInteger(r_w, w)) {
#ifndef POSITIVE_ADDRESSES      /* tag in low-bit */
		    ir = il + (INT)(w);
		    r_ir = r_il + (INT)(r_w);
#else
		    ir = il + __intVal(w);
		    r_ir = r_il + __intVal(r_w);
#endif
		    if (ir < r_ir) { RETURN (false); }   /* (left + width) < aRectangle right */

		    r_h = __OINST(rct, height);
		    h = __OINST(slf, height);
		    if (__bothSmallInteger(r_h, h)) {
#ifndef POSITIVE_ADDRESSES      /* tag in low-bit */
			ib = it + (INT)(h);
			r_ib = r_it + (INT)(r_h);
#else
			ib = it + __intVal(h);
			r_ib = r_it + __intVal(r_h);
#endif
			if (ib < r_ib) { RETURN (false); }   /* (top + height) < aRectangle bottom */
			RETURN (true);
		    }
		}
	    }
	}
    }
%}.
    (left <= aRectangle left) ifTrue:[
      ((left + width) >= aRectangle right) ifTrue:[
	(top <= aRectangle top) ifTrue:[
	  ((top + height) >= aRectangle bottom) ifTrue:[
	    ^ true
	  ]
	]
      ]
    ].
    ^ false

    "
     (0@0 corner:100@100) contains:(10@10 corner:90@90)
     (0@0 corner:100@100) contains:(10@10 corner:100@100)
     (0@0 corner:100@100) contains:(10@10 corner:110@100)
     (0@0 corner:100@100) contains:(10@10 corner:100@110)
     (10@10 corner:100@100) contains:(0@10 corner:100@100)
    "
!

containsPoint:aPoint
    "return true, if the argument, aPoint is contained in the receiver"

    |px py|

    px := aPoint x.
    (px < left)           ifTrue:[^ false].
    (px > (left + width)) ifTrue:[^ false].
    py := aPoint y.
    (py < top)            ifTrue:[^ false].
    (py > (top + height)) ifTrue:[^ false].
    ^ true
!

containsPointX:x y:y
    "return true, if the point defined by x@y is contained in the receiver.
     This is the same as containsPoint:, but can be used if the coordinates
     are already available as separate numbers to avoid useless creation of a
     temporary point."

    (x < left)           ifTrue:[^ false].
    (x > (left + width)) ifTrue:[^ false].
    (y < top)            ifTrue:[^ false].
    (y > (top + height)) ifTrue:[^ false].
    ^ true
!

corners
    "Return an array of corner points"

    ^ Array
	with: self topLeft
	with: self bottomLeft
	with: self bottomRight
	with: self topRight


!

innerCorners
    "Return an array of inner corner points,
     ie, the most extreme pixels included.
     Added for Aqueak compatibility."

    ^ (self topLeft corner:(self bottomRight - (1@1))) corners

    "
     (10@10 corner:100@100) corners
     (10@10 corner:100@100) innerCorners
    "
!

intersects:aRectangle
    "return true, if the intersection between the argument, aRectangle
     and the receiver is not empty"

    |b r|

%{  /* NOCONTEXT */
    /*
     * claus: this is one of the mostly called methods in
     * the objectView - the primitive code below (although looking ugly)
     * speeds up drawing by almost a factor of 2 ...
     */
    OBJ slf = self;
    OBJ rct = aRectangle;

    if (__isNonNilObject(rct)
     && __qClass(rct) == Rectangle) {
	OBJ r_l, r_w, r_t, r_h, l, w, t, h;
	INT r_ir, r_il, r_ib, r_it;
	INT il, it, ir, ib, iw, ih;

	r_l = __OINST(rct, left);
	r_w = __OINST(rct, width);

	if (__bothSmallInteger(r_l, r_w)) {
	    r_t = __OINST(rct, top);
	    r_h = __OINST(rct, height);

	    l = __OINST(slf, left);
	    w = __OINST(slf, width);

	    if (__bothSmallInteger(l, w)) {
		t = __OINST(slf, top);
		h = __OINST(slf, height);

#ifndef POSITIVE_ADDRESSES      /* tag in low-bit */
		r_il = (INT)(r_l);
		r_ir = r_il + (INT)(r_w) - 1;
		il = (INT)(l);
		if (r_ir < il) { RETURN (false); }
		ir = il + (INT)(w) - 1;
		if (r_il > ir) { RETURN (false); }
#else                           /* tag in hi-bit */
		r_il = __intVal(r_l);
		r_ir = r_il + __intVal(r_w);        /* aRectangle right */
		il = __intVal(l);
		if (r_ir < il) { RETURN (false); }  /* (aRectangle right) < left */

		ir = il + __intVal(w);
		if (r_il > ir) { RETURN (false); }   /* (aRectangle left) > r */
#endif

		if (__bothSmallInteger(r_t, r_h)) {
		    if (__bothSmallInteger(t, h)) {
#ifndef POSITIVE_ADDRESSES
			r_it = (INT)(r_t);
			r_ib = r_it + (INT)(r_h) - 1; /* aRectangle bottom */
			it = (INT)(t);
			if (r_ib < it) { RETURN (false); } /* (aRectangle bottom) < top */

			ib = it + (INT)(h) - 1;
			if (r_it > ib) { RETURN (false); } /* (aRectangle top) > b */
#else
			r_it = __intVal(r_t);
			r_ib = r_it + __intVal(r_h); /* aRectangle bottom */
			it = __intVal(t);
			if (r_ib < it) { RETURN (false); } /* (aRectangle bottom) < top */

			ib = it + __intVal(h);
			if (r_it > ib) { RETURN (false); } /* (aRectangle top) > b */
#endif
			RETURN (true);
		    }
		}
	    }
	}
    }
%}.
    (aRectangle right)  < left ifTrue:[^ false].
    (aRectangle bottom) < top  ifTrue:[^ false].
    r := left + width.
    (aRectangle left)   > r    ifTrue:[^ false].
    b := top + height.
    (aRectangle top)    > b    ifTrue:[^ false].
    ^ true
!

isContainedIn:aRectangle
    "return true, if the receiver is fully contained within
     the argument, aRectangle"

    (aRectangle left <= left) ifTrue:[
      (aRectangle right >= (left + width)) ifTrue:[
	(aRectangle top <= top) ifTrue:[
	  (aRectangle bottom >= (top + height)) ifTrue:[
	    ^ true
	  ]
	]
      ]
    ].
    ^ false

    "
     |r|

     r := Rectangle origin:10@10 corner:100@100.
     r isContainedIn: (Rectangle origin:10@10 corner:100@100).
     r isContainedIn: (Rectangle origin:11@10 corner:100@100).
     r isContainedIn: (Rectangle origin:9@10 corner:100@100).
    "
! !

!Rectangle methodsFor:'rectangle operations'!

+ aPoint
    "return a new rectangle with same extent as receiver but
     origin translated by the argument, aPoint"

    |amountPoint|

    (aPoint isMemberOf:SmallInteger) ifTrue:[
	"/ this is an stc optimization
	^ Rectangle
	    left:(left + aPoint)
	    top:(top + aPoint)
	    width:width
	    height:height
    ].

    amountPoint := aPoint asPoint.
    ^ Rectangle left:(left + amountPoint x)
		 top:(top + amountPoint y)
	       width:width
	      height:height

    "Modified: 25.1.1997 / 17:29:53 / cg"
!

- aPoint
    "return a new rectangle with same extent as receiver but
     origin translated by the argument, aPoint"

    |amountPoint|

    (aPoint isMemberOf:SmallInteger) ifTrue:[
	"/ this is an stc optimization
	^ Rectangle
	    left:(left - aPoint)
	    top:(top - aPoint)
	    width:width
	    height:height
    ].

    amountPoint := aPoint asPoint.
    ^ Rectangle left:(left - amountPoint x)
		 top:(top - amountPoint y)
	       width:width
	      height:height

    "Modified: 25.1.1997 / 17:29:53 / cg"
    "Created: 25.1.1997 / 17:30:21 / cg"
!

areasOutside:aRectangle
    "Answer an Array of Rectangles comprising the parts of the receiver 
     not intersecting aRectangle.
     That is all areas with no common pixels."

    |areas|

    "Make sure the intersection is non-empty"
    (self origin <= aRectangle corner and: [aRectangle origin <= self corner]) ifFalse: [
        ^ Array with: self
    ].
    areas := OrderedCollection new.
    self areasOutside:aRectangle do:[:r | areas add:r].
    ^ areas asArray

    "/ cg: the old code below was wrong ...

"/    "----------------------------------------------------------------
"/    | added for GNU-ST compatibility
"/    |
"/    | author: Doug McCallum <uunet!!ico.isc.com!!dougm>
"/    |
"/    |areasOutside: aRectangle
"/    | most complicated of the Rectangle primitives
"/    | The basic methodology is to first determine that there is an
"/    | intersection by finding the overlapping rectangle.  From the
"/    | overlapping rectangle, first determine if it runs along an edge.
"/    | If it doesn't, extend the rectangle up to the top edge and add
"/    | the new rectangle to the collection and start the rest of the
"/    | process.  If the left edge does not touch the left edge of self,
"/    | extend it to the edge saving the new rectangle.  Then do the
"/    | same to the right edge.  Then check top and bottom edges.  Most
"/    | of the time only 2 or 3 rectangles get formed, occasionally 4.
"/    | It should be possible to never get more than 3 but requires more
"/    | work.
"/     ----------------------------------------------------------------"
"/
"/    | collect iRect tmp |
"/
"/    iRect := self intersect: aRectangle.
"/    iRect isNil ifTrue: [^nil]. "case of no intersection"
"/                                "the collect collection gathers Rectangles"
"/    collect := OrderedCollection new: 4.
"/                                "is it floating or on the edge?"
"/    (((((iRect top) ~= self top)
"/         and: [ (iRect bottom) ~= self bottom ])
"/         and: [ (iRect left) ~= self left ])
"/         and: [ (iRect right) ~= self right ] )
"/        ifTrue: "entirely in the center."
"/            [tmp := Rectangle origin: (Point x: iRect left y: self top)
"/                              corner: iRect bottomRight.
"/             collect add: tmp.
"/             iRect := iRect merge: tmp].
"/    ((iRect left) ~= self left)
"/        ifTrue:                 "doesn't touch left edge so make it touch"
"/            [tmp := Rectangle origin: (Point x: self left y: iRect top)
"/                              corner: iRect bottomLeft.
"/                 collect add: tmp.
"/                                "merge new (tmp) with overlap to keep track"
"/                 iRect := iRect merge: tmp].
"/    ((iRect right) ~= self right)
"/        ifTrue:                 "doesn't touch right edge so extend it"
"/            [tmp := Rectangle origin: iRect topRight
"/                              corner: (Point x: self right y: iRect bottom).
"/                 collect add: tmp.
"/                 iRect := iRect merge: tmp].
"/    (((iRect left) ~= self left) or: [(iRect top) ~= self top])
"/        ifTrue:                 "whole top part can be taken now"
"/            [tmp := Rectangle origin: self origin corner: iRect topRight.
"/                 collect add: tmp].
"/    (((iRect right) ~= self right) or: [(iRect bottom) ~= self bottom])
"/        ifTrue:                 "whole bottom open and can be taken"
"/            [tmp := Rectangle origin: iRect bottomLeft corner: self corner.
"/                 collect add: tmp].
"/    ^collect
!

areasOutside:aRectangle do:aBlock
    "evaluate aBlock for Rectangles comprising the parts of the receiver 
     not intersecting aRectangle.
     That is all areas with no common pixels."

    |yOrigin yCorner origin corner|

    origin := self origin.
    corner := self corner.

    "Make sure the intersection is non-empty"
    (origin <= aRectangle corner and: [aRectangle origin <= corner])
            ifFalse: [ aBlock value:self. ^ self].

    aRectangle origin y > origin y ifTrue: [ 
        aBlock value: (origin corner: corner x @ (yOrigin := aRectangle origin y)) 
    ] ifFalse: [ 
        yOrigin := origin y 
    ].
    aRectangle corner y < corner y ifTrue: [ 
        aBlock value: (origin x @ (yCorner := aRectangle corner y) corner: corner) 
    ] ifFalse: [
        yCorner := corner y
    ].
    aRectangle origin x > origin x ifTrue: [ 
        aBlock value: (origin x @ yOrigin corner: aRectangle origin x @ yCorner) 
    ].
    aRectangle corner x < corner x ifTrue: [ 
        aBlock value: (aRectangle corner x @ yOrigin corner: corner x @ yCorner) 
    ].

    "
     self assert:
            ((0@0 corner:100@100) areasOutside:(0@0 corner:50@50)) asArray
            = { (Rectangle origin:0@50 extent:100@50) . (Rectangle origin:50@0 extent:50@50) }

     self assert:
            ((0@0 corner:150@100) areasOutside:(0@0 corner:100@100)) asArray
            = { (Rectangle origin:100@0 extent:50@100) }

     self assert:
            ((0@0 corner:100@150) areasOutside:(0@0 corner:100@100)) asArray
            = { (Rectangle origin:0@100 extent:100@50) }
    "
    
    "/ cg: the old code below was wrong ...

"/    "----------------------------------------------------------------
"/    | added for GNU-ST compatibility
"/    |
"/    | author: Doug McCallum <uunet!!ico.isc.com!!dougm>
"/    |
"/    |areasOutside: aRectangle
"/    | most complicated of the Rectangle primitives
"/    | The basic methodology is to first determine that there is an
"/    | intersection by finding the overlapping rectangle.  From the
"/    | overlapping rectangle, first determine if it runs along an edge.
"/    | If it doesn't, extend the rectangle up to the top edge and add
"/    | the new rectangle to the collection and start the rest of the
"/    | process.  If the left edge does not touch the left edge of self,
"/    | extend it to the edge saving the new rectangle.  Then do the
"/    | same to the right edge.  Then check top and bottom edges.  Most
"/    | of the time only 2 or 3 rectangles get formed, occasionally 4.
"/    | It should be possible to never get more than 3 but requires more
"/    | work.
"/     ----------------------------------------------------------------"
"/
"/    | collect iRect tmp |
"/
"/    iRect := self intersect: aRectangle.
"/    iRect isNil ifTrue: [^nil]. "case of no intersection"
"/                                "the collect collection gathers Rectangles"
"/    collect := OrderedCollection new: 4.
"/                                "is it floating or on the edge?"
"/    (((((iRect top) ~= self top)
"/         and: [ (iRect bottom) ~= self bottom ])
"/         and: [ (iRect left) ~= self left ])
"/         and: [ (iRect right) ~= self right ] )
"/        ifTrue: "entirely in the center."
"/            [tmp := Rectangle origin: (Point x: iRect left y: self top)
"/                              corner: iRect bottomRight.
"/             collect add: tmp.
"/             iRect := iRect merge: tmp].
"/    ((iRect left) ~= self left)
"/        ifTrue:                 "doesn't touch left edge so make it touch"
"/            [tmp := Rectangle origin: (Point x: self left y: iRect top)
"/                              corner: iRect bottomLeft.
"/                 collect add: tmp.
"/                                "merge new (tmp) with overlap to keep track"
"/                 iRect := iRect merge: tmp].
"/    ((iRect right) ~= self right)
"/        ifTrue:                 "doesn't touch right edge so extend it"
"/            [tmp := Rectangle origin: iRect topRight
"/                              corner: (Point x: self right y: iRect bottom).
"/                 collect add: tmp.
"/                 iRect := iRect merge: tmp].
"/    (((iRect left) ~= self left) or: [(iRect top) ~= self top])
"/        ifTrue:                 "whole top part can be taken now"
"/            [tmp := Rectangle origin: self origin corner: iRect topRight.
"/                 collect add: tmp].
"/    (((iRect right) ~= self right) or: [(iRect bottom) ~= self bottom])
"/        ifTrue:                 "whole bottom open and can be taken"
"/            [tmp := Rectangle origin: iRect bottomLeft corner: self corner.
"/                 collect add: tmp].
"/    ^collect
!

encompass:aPoint
    "return a Rectangle that contains both the receiver and aPoint."

    ^ Rectangle
	origin: (self origin min: aPoint)
	corner: (self corner max: aPoint)

!

expandedBy:delta
    "return a new rectangle which is expanded in all directions
     by amount, a Point, Rectangle or Number"

    ^ self copy expandBy:delta

    "
     |r|
     r := Rectangle origin:10@10 corner:100@100.
     r expandedBy:5.
     r expandedBy:(5 @ 0).
     r expandedBy:(10 @ 10).
     r expandedBy:( 10@10 corner:20@20 )
    "
!

insetBy: delta
    "return a new rectangle which is inset in all directions
     by delta, a Point, Rectangle or Number"

    |amountPoint deltaLeft deltaTop deltaWidth deltaHeight|

    delta isNumber ifTrue:[
	deltaLeft := deltaTop := delta.
	deltaWidth := deltaHeight := delta * 2.
    ] ifFalse:[
	delta isRectangle ifTrue:[
	    deltaLeft := delta left.
	    deltaTop := delta top.
	    deltaWidth := deltaLeft + delta right.
	    deltaHeight := deltaTop + delta bottom
	] ifFalse:[
	    amountPoint := delta asPoint.
	    deltaLeft := amountPoint x.
	    deltaTop := amountPoint y.
	    deltaWidth := deltaLeft * 2.
	    deltaHeight := deltaTop * 2.
	]
    ].

    ^ Rectangle left:(left + deltaLeft)
		 top:(top + deltaTop)
	       width:(width - deltaWidth)
	      height:(height - deltaHeight)
    "
     |r|
     r := Rectangle origin:10@10 corner:100@100.
     r insetBy:5.
     r insetBy:(5 @ 0).
     r insetBy:(10 @ 10).
     r insetBy:( 10@10 corner:20@20 )
    "
!

insetOriginBy:originDelta cornerBy:cornerDelta
    "return a new rectangle which is inset by originDelta
     and cornerDelta; both may be instances of Point or Number"

    ^ Rectangle
	origin:(left @ top) + originDelta asPoint
	corner:(self corner - cornerDelta asPoint)
    "
     |r|
     r := Rectangle origin:10@10 corner:100@100.
     r insetOriginBy:5 cornerBy:10.
     r insetOriginBy:10@5 cornerBy:10.
     r insetOriginBy:10 cornerBy:10@5.
     r insetOriginBy:10@10 cornerBy:20@20.
    "
!

intersect:aRectangle
    "return a new rectangle covering the intersection of the receiver
     and the argument, aRectangle (i.e. the area covered by both).
     the rectangles must intersect for a valid return"

    ^ Rectangle left:(left max:(aRectangle left))
	       right:((left + width) min:(aRectangle right))
		 top:(top max:(aRectangle top))
	      bottom:((top + height) min:(aRectangle bottom))

    "
     |r1 r2|

     r1 := Rectangle origin:10@10 corner:100@100.
     r2 := Rectangle origin:50@50 corner:150@75.
     r1 intersect:r2
    "
!

merge:aRectangle
    "return a new rectangle covering both the receiver
     and the argument, aRectangle"

    ^ Rectangle left:(left min:(aRectangle left))
	       right:((left + width) max:(aRectangle right))
		 top:(top min:(aRectangle top))
	      bottom:((top + height) max:(aRectangle bottom))

    "
     (Rectangle origin:10@10 corner:100@100)
	 merge:(Rectangle origin:20@20 corner:110@110)

     (Rectangle origin:10@10 corner:100@100)
	 merge:(Rectangle origin:20@20 corner:100@100)
    "
!

nonIntersections:aRectangle
    "this is the same as areasOutside: - for ST/V compatibility only"

    ^ self areasOutside:aRectangle
!

quickMerge: aRectangle
    "return the receiver if it encloses the given rectangle,
     or the merge of the two rectangles if it doesn't.
     This method is an optimized version of merge: to reduce extra rectangle creations."

    | useRcvr rLeft rTop rRight rBottom minX maxX minY maxY |

    useRcvr := true.

    rLeft := aRectangle left.
    rTop := aRectangle top.
    rRight := aRectangle right.
    rBottom := aRectangle bottom.

    minX := left.
    rLeft < minX ifTrue: [useRcvr := false. minX := rLeft].
    maxX := self right.
    rRight > maxX ifTrue: [useRcvr := false. maxX := rRight].
    minY := top.
    rTop < minY ifTrue: [useRcvr := false. minY := rTop].
    maxY := self bottom.
    rBottom > maxY ifTrue: [useRcvr := false. maxY := rBottom].

    useRcvr ifTrue: [
	^ self
    ].

    minX = rLeft ifTrue:[
	maxX = rRight ifTrue:[
	    minY = rTop ifTrue:[
		maxY = rBottom ifTrue:[
		    ^ aRectangle
		].
	    ].
	].
    ].

    ^ Rectangle left:minX top:minY right:maxX bottom:maxY.

    "
     (Rectangle origin:10@10 corner:100@100)
	 quickMerge:(Rectangle origin:20@20 corner:110@110)

     (Rectangle origin:10@10 corner:100@100)
	 quickMerge:(Rectangle origin:20@20 corner:100@100)
    "
!

scaledBy:scale
    "return a new rectangle which is the receiver
     scaled by scale"

    |scalePoint sx sy|

    (scale isMemberOf:SmallInteger) ifTrue:[
	"/ this is an stc optimization
	^ Rectangle left:left * scale
		     top:top * scale
		   width:width * scale
		  height:height * scale
    ].

    scalePoint := scale asPoint.
    sx := scalePoint x.
    sy := scalePoint y.
    ^ Rectangle left:left * sx
		 top:top * sy
	       width:width * sx
	      height:height * sy
    "
     (Rectangle origin:10@10 corner:50@50) scaledBy:2
    "

    "it is NOT destructive:"
    "
     |r1 r2|

     r1 := Rectangle origin:10@10 corner:50@50.
     r2 := r1 scaledBy:2.
     r1
    "
!

scaledBy:scale translatedBy:translation
    "return a new rectangle which is translated (i.e. moved)
     by translation, aPoint or Number and scaled by scale, aPoint or number."

    |x y w h translationPoint scalePoint sx sy|

    (translation isNil and:[scale isNil]) ifTrue:[
	^ self.
    ].

    x := left.
    y := top.
    w := width.
    h := height.

    scale notNil ifTrue:[
	(scale isMemberOf:SmallInteger) ifTrue:[
	    "/ this is an stc optimization
	    x := x * scale.
	    y := y * scale.
	    w := w * scale.
	    h := h * scale.
	] ifFalse:[
	    scalePoint := scale asPoint.
	    sx := scalePoint x.
	    sy := scalePoint y.
	    x := x * sx.
	    y := y * sy.
	    w := w * sx.
	    h := h * sy.
	].
    ].
    translation notNil ifTrue:[
	(translation isMemberOf:SmallInteger) ifTrue:[
	    "/ this is an stc optimization
	    x := x + translation.
	    y := y + translation.
	] ifFalse:[
	    translationPoint := translation asPoint.
	    x := x + translationPoint x.
	    y := y + translationPoint y.
	].
    ].

    ^ Rectangle left:x top:y width:w height:h.

    "
     (Rectangle origin:10@10 corner:50@50) scaledBy:2 translatedBy:10
    "
!

translatedBy:amount
    "return a new rectangle which is translated (i.e. moved)
     by amount, aPoint or Number"

    |amountPoint|

    (amount isMemberOf:SmallInteger) ifTrue:[
	"/ this is an stc optimization
	^ Rectangle
	    left:(left + amount)
	    top:(top + amount)
	    width:width
	    height:height
    ].

    amountPoint := amount asPoint.
    ^ Rectangle left:(left + amountPoint x)
		 top:(top + amountPoint y)
	       width:width
	      height:height
    "
     (Rectangle origin:10@10 corner:50@50) translatedBy:10
    "

    "its NOT destructive:"
    "
     |r1 r2|

     r1 := Rectangle origin:10@10 corner:50@50.
     r2 := r1 translatedBy:10.
     r1
    "
! !

!Rectangle methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Always true here."

    ^ true

    "Created: 8.5.1996 / 08:16:47 / cg"
!

isRectangle
    "return true, if the receiver is some kind of rectangle"

    ^ true
! !

!Rectangle methodsFor:'transformations'!

align:offset with:someCoordinate
    "return a new rectangle which is translated (i.e. moved)
     such that the point offset in mySelf is placed on someCoordinate."

    ^ Rectangle origin:(someCoordinate - offset + self origin)
		extent:(self extent)
    "
     |r|

     r := Rectangle origin:10@10 corner:50@50.
     r align:(r center) with:100@100.
    "
! !

!Rectangle methodsFor:'truncation & rounding'!

rounded
    "return a copy of the receiver with rounded coordinates.
     Return the receiver if its coordinates are already integral."

    (left isInteger
    and:[top isInteger
    and:[width isInteger
    and:[height isInteger]]])
	ifTrue: [^ self].

    ^ Rectangle left:(left rounded)
		 top:(top rounded)
	       width:(width rounded)
	      height:(height rounded)
!

truncated
    "return a Rectangle whose origin and corner have any fractional parts removed.
     Return the receiver if its coordinates are already integral."

    (left isInteger
    and:[top isInteger
    and:[width isInteger
    and:[height isInteger]]])
	ifTrue: [^ self].

    ^ Rectangle
	left:left truncated
	top:top truncated
	width:width truncated
	height:height truncated.
! !

!Rectangle class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

