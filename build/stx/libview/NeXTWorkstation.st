"{ Package: 'stx:libview' }"

DeviceWorkstation subclass:#NeXTWorkstation
	instanceVariableNames:'buffered knownDrawableIds'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Graphics'
!

NeXTWorkstation comment:'

COPYRIGHT (c) 1992 by Claus Gittinger
	      All Rights Reserved

this class provides the interface to NeXTStep; since we cannot include
objc-code here (due to define conflicts with Class, nil ...) we call
helper functions to do the job; the helpers are in ../librun/NXsupport.c

All non-monochrome stuff is untested (I only have a monochroome station)

$Header: /cvs/stx/stx/libview/NeXTWorkstation.st,v 1.22 2013-05-21 20:49:14 cg Exp $
written spring 92 by claus
'
!

!NeXTWorkstation primitiveDefinitions!
%{

#include <stdio.h>
#include <dpsclient/wraps.h>
#include <dpsclient/psops.h>

%}
! !

!NeXTWorkstation primitiveFunctions!
%{
/*
 * cannot include objc stuff - too many name conflicts
 */
#define id INT
static INT lastDrawable = 0;

setDrawable(drawableId)
    OBJ drawableId;
{
    id drawable;

    drawable = (id)(_intVal(drawableId));
    if (drawable != lastDrawable) {
	if (lastDrawable) {
	    _objc_unlockFocus(lastDrawable);
	}
	_objc_lockFocus(drawable);
	lastDrawable = drawable;
    }
}

%}
! !

!NeXTWorkstation class methodsFor:'initialization'!

initialize
    self initializeDisplayConstants.
    self initializeConstants.
!

initializeDisplayConstants
    "initialize some common constants"
! !

!NeXTWorkstation class methodsFor:'queries'!

platformName
    ^ 'NeXTStep'
! !

!NeXTWorkstation methodsFor:'accessing & queries'!

blackpixel
    "return the colorId of black;
     for next, we use the color directly"

    ^ 16r000000
!

displayFileDescriptor
    "return the displays fileNumber - for select"

    ^ nil
!

hasDPS
    "return true, if display supports postscript output into a view"

    ^ true
!

hasShape
    "return true, if display supports arbitrary shaped windows.
     (actually, DPS does support this - but I currently dont know how)"

    ^ false
!

protocolVersion
    ^ self vendorRelease
!

serverVendor
    ^ 'NeXT'
!

translatePoint:aPoint from:windowId1 to:windowId2
    "given a point in window1, return the coordinate in window2
     - use to xlate points from a window to rootwindow"

     ^ self shouldNotImplement
!

vendorRelease
    ^ 2.1  "this is wrong - should get it from somewhere ..."
!

viewIdFromPoint:aPoint in:windowId
    "given a point in rootWindow, return the viewId of the subview of windowId
     hit by this coordinate.
     return nil if no view was hit.
     - use to find window to drop objects after a cross-view drag"

     ^ self shouldNotImplement
!

visualType:aSymbol
    ^ self shouldNotImplement
!

whitepixel
    "return the colorId of white;
     for next, we use the color directly"

    ^ 16rFFFFFF
! !

!NeXTWorkstation methodsFor:'bitmap/window creation'!

createBitmapFromArray:anArray width:w height:h
     ^ self shouldNotImplement
!

createBitmapFromFile:aString for:aForm
     ^ self shouldNotImplement
!

createBitmapWidth:w height:h
     ^ self shouldNotImplement
!

createFaxImageFromArray:data width:w height:h type:type k:k msbFirst:msbFirst
    "create a new faxImage in the workstation"

    ^ nil
!

createPixmapWidth:w height:h depth:d
     ^ self shouldNotImplement
!

createWindowFor:aView left:xpos top:ypos width:wwidth height:wheight

    |ext minWidth minHeight maxWidth maxHeight
     bWidth bColor viewBg viewBgId wsuperView wsuperViewId
     wlabel wcursor wcursorId wicon wiconId windowId
     wiconView wiconViewId
     drawableId|

    wsuperView := aView superView.
    wsuperView notNil ifTrue:[
	wsuperViewId := wsuperView id
    ].
    wlabel := aView label.
    wcursor := aView cursor.

    wsuperView isNil ifTrue:[
	ext := aView minExtent.
	ext notNil ifTrue:[
	    minWidth := ext x.
	    minHeight := ext y
	].
	ext := aView maxExtent.
	ext notNil ifTrue:[
	    maxWidth := ext x.
	    maxHeight := ext y
	].
    ].

%{
    id win;
    id view;
    int w, h, resizable;

    if ((minWidth != nil) && (maxWidth != nil)
     && (minWidth == maxWidth) && (minHeight == maxHeight)) {
	w = _intVal(minWidth);
	h = _intVal(maxHeight);
	resizable = 0;
    } else {
	w = _intVal(wwidth);
	h = _intVal(wheight);
	resizable = 1;
    }
    win = _NX_create_window(_intVal(xpos), _intVal(ypos), w, h, resizable);
    if (! win)
	return nil;

    /*
     * define its name
     */
    if (_isString(wlabel))
	_objc_setTitle(win, _stringVal(wlabel));
    else
	_objc_setTitle(win, "untitled");

    view = _objc_contentView(win);
    _objc_setFlipped_(view, 1);

    _objc_makeKeyAndOrderFront(win, 0);
    _objc_display(win);

    windowId = _MKSMALLINT(win);
    drawableId = _MKSMALLINT(view);
%}.
    self addKnownView:aView winId:windowId withId:drawableId.
    ^ drawableId
!

destroyFaxImage:aFaxImageId
     ^ self shouldNotImplement
!

destroyGC:aGCId
     ^ self shouldNotImplement
!

destroyPixmap:aDrawableId
     ^ self shouldNotImplement
!

destroyView:aView withId:aWindowId
     ^ self shouldNotImplement
!

gcFor:aDrawableId
     ^ self shouldNotImplement
!

rootWindowFor:aView
     ^ self shouldNotImplement
! !

!NeXTWorkstation methodsFor:'color stuff'!

colorCell
    "allocate a color - return index.
     Since NeXTs are either StaticGrey or StaticColor, return nil here."

    ^ nil
!

colorNamed:aString
    "allocate a color with color name - return index"

    ^ super colorNamed:aString
!

colorRed:redVal green:greenVal blue:blueVal
    "allocate a color with rgb values - return index"

    | r g b |

    "on the next, we use rgb value as index"
    r := (redVal * 16rFF / 100) asInteger.
    g := (greenVal * 16rFF / 100) asInteger.
    b := (blueVal * 16rFF / 100) asInteger.
    r := (r min:255) max:0.
    g := (g min:255) max:0.
    b := (b min:255) max:0.
    ^ (((r bitShift:8) bitOr:g) bitShift:8) bitOr:b
!

freeColor:colorIndex
    "colors are never freed"

    ^ self
!

getBlueFrom:index
    "get blue part of color in map at:index"

    ^ (index bitAnd:16rFF) * 100 / 16rFF
!

getGreenFrom:index
    "get green part of color in map at:index"

    ^ ((index bitShift:-8) bitAnd:16rFF) * 100 / 16rFF
!

getRedFrom:index
    "get red part of color in map at:index"

    ^ ((index bitShift:-16) bitAnd:16rFF) * 100 / 16rFF
!

listOfAvailableColors
    ^ super listOfAvailableColors
!

setColor:index red:redVal green:greenVal blue:blueVal
    "change color in map at:index.
     Since NeXTs are either StaticGrey or StaticColor, do nothing here."

    ^ self
! !

!NeXTWorkstation methodsFor:'cursor stuff'!

createCursorSourceFormId:sourceFormId maskFormId:maskFormId hotX:hx hotY:hy
    ^ self primitiveFailed
!

destroyCursor:aCursorId
    ^ self primitiveFailed
!

grabPointerIn:aWindowId
    ^ self primitiveFailed
!

pointerPosition
    ^ self primitiveFailed
!

ungrabPointer
    ^ self primitiveFailed
! !

!NeXTWorkstation methodsFor:'drawing'!

copyFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt"

    ^ self primitiveFailed
!

copyPlaneFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt"

    ^ self primitiveFailed
!

displayArcX:x y:y w:width h:height from:startAngle angle:angle
	       in:aDrawableId with:aGCId
    "draw an arc"

    ^ self primitiveFailed
!

displayLineFromX:x0 y:y0 toX:x1 y:y1 in:aDrawableId with:aGCId
    "draw a line"

%{
    float fx0, fy0, fx1, fy1;

    do {
	if (__isSmallInteger(x0))
	    fx0 = _intVal(x0);
	else if (_isFloat(x0))
	    fx0 = _floatVal(x0);
	else break;
	if (__isSmallInteger(y0))
	    fy0 = _intVal(y0);
	else if (_isFloat(y0))
	    fy0 = _floatVal(y0);
	else break;
	if (__isSmallInteger(x1))
	    fx1 = _intVal(x1);
	else if (_isFloat(x1))
	    fx1 = _floatVal(x1);
	else break;
	if (__isSmallInteger(y1))
	    fy1 = _intVal(y1);
	else if (_isFloat(y1))
	    fy1 = _floatVal(y1);
	else break;

	setDrawable(aDrawableId);
	PSsetlinewidth(0.0);
	PSnewpath();
	PSmoveto(fx0, fy0);
	PSlineto(fx1, fy1);
	PSstroke();
	if (_INST(buffered) == false)
	    NXPing();

	RETURN ( self );
    } while (1);
%}
.
    ^ self primitiveFailed
!

displayOpaqueString:aString from:index1 to:index2 x:x y:y in:aDrawableId with:aGCId
    "draw part of a string - draw both foreground and background"

    ^ self primitiveFailed
!

displayOpaqueString:aString x:x y:y in:aDrawableId with:aGCId
    "draw a string - draw both foreground and background"

    ^ self primitiveFailed
!

displayPointX:x y:y in:aDrawableId with:aGCId
    "draw a point"

    ^ self primitiveFailed
!

displayString:aString from:index1 to:index2 x:x y:y in:aDrawableId with:aGCId
    "draw part of a string - draw foreground only"

    ^ self primitiveFailed
!

displayString:aString x:x y:y in:aDrawableId with:aGCId
    "draw a string - draw foreground only"

%{
    float fx, fy;

    do {
	if (__isSmallInteger(x))
	    fx = (float)_intVal(x);
	else if (_isFloat(x))
	    fx = _floatVal(x);
	else break;
	if (__isSmallInteger(y))
	    fy = (float)_intVal(y);
	else if (_isFloat(y))
	    fy = _floatVal(y);
	else break;
	setDrawable(aDrawableId);
	PSmoveto(fx, fy);
	PSshow((char *)_stringVal(aString));
	if (_INST(buffered) == false)
	    NXPing();
	RETURN ( self );
    } while (1);
%}
.
    self primitiveFailed
!

drawBits:imageBits depth:imageDepth width:imageWidth height:imageHeight
		       x:srcx y:srcy
		    into:aDrawableId x:dstx y:dsty width:w height:h with:aGCId
    "draw a bitimage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     It has to be checked elsewhere, that server can do it with the given
     depth; also it is assumed, that the colormap is setup correctly"

    ^ self primitiveFailed
!

drawPolygon:aPolygon in:aDrawableId with:aGCId
    "draw a polygon"

    ^ self primitiveFailed
!

drawRectangleX:x y:y width:width height:height in:aDrawableId with:aGCId
    "draw a rectangle"

    ^ self primitiveFailed
!

fillArcX:x y:y w:width h:height from:startAngle angle:angle
	       in:aDrawableId with:aGCId
    "fill an arc"

    ^ self primitiveFailed
!

fillPolygon:aPolygon in:aDrawableId with:aGCId
    "fill a polygon"

    ^ self primitiveFailed
!

fillRectangleX:x y:y width:w height:h in:aDrawableId with:aGCId
    "fill a rectangle"

%{
    float fx, fy, fw, fh;

    do {
	if (__isSmallInteger(x))
	    fx = (float)_intVal(x);
	else if (_isFloat(x))
	    fx = _floatVal(x);
	else break;
	if (__isSmallInteger(y))
	    fy = (float)_intVal(y);
	else if (_isFloat(y))
	    fy = _floatVal(y);
	else break;

	if (__isSmallInteger(w))
	    fw = (float)_intVal(w);
	else if (_isFloat(w))
	    fw = _floatVal(w);
	else break;
	if (__isSmallInteger(h))
	    fh = (float)_intVal(h);
	else if (_isFloat(h))
	    fh = _floatVal(h);
	else break;

	setDrawable(aDrawableId);
	PSnewpath();
	PSmoveto(fx, fy);
	PSlineto(fx + fw, fy);
	PSlineto(fx + fx, fy + fh);
	PSlineto(fx, fy + fh);
	PSlineto(fx, fy);
	PSclosepath();
	PSfill();
	if (_INST(buffered) == false)
	    NXPing();
	RETURN ( self );
    } while (1);
%}
! !

!NeXTWorkstation methodsFor:'events'!

eventMaskFor:anEventSymbol
    ^ self primitiveFailed
!

eventPending
    "return true, if any event is pending"

    ^ false
!

eventPending:anEventSymbol for:aWindowId
    "return true, if a specific event is pending"

    ^ self primitiveFailed
!

eventPendingWithoutSync
    "return true, if any event is pending"

    ^ false
!

eventsPending:anEventMask for:aWindowId
    "return true, if any of the masked events is pending"

    ^ self primitiveFailed
!

exposeEventsFor:aViewId do:aBlock
!

setEventMask:aMask in:aWindowId
    ^ self primitiveFailed
! !

!NeXTWorkstation methodsFor:'font stuff'!

ascentOf:aFontId
    ^ self primitiveFailed
!

createFontFor:aFontName
    ^ self primitiveFailed
!

descentOf:aFontId
    self badFont
!

listOfAvailableFonts
    "return a list with all available font names on this display"
%{
	char **names;
	char **cp;
	int count, i;
	static struct inlineCache dummy1 = _DUMMYILC1;
	OBJ arr;

	names = (char **) _objc_availableFonts(_FontManager_new());
	/* count them */
	for (cp = names; *cp; cp++) ;;
	count = cp - names;
	arr = _SEND1(@global(Array), @symbol(new:), nil, &dummy1, _MKSMALLINT(count));
	for (i=0; i<count;i++)
	    _ArrayInstPtr(arr)->a_element[i] = __MKSTRING(names[i]);
	free(names);
	RETURN (arr);
%}
!

maxWidthOfFont:aFontId
    self badFont
!

minWidthOfFont:aFontId
    self badFont
!

releaseFont:aFontId
    ^ self primitiveFailed
!

widthOf:aString from:index1 to:index2 inFont:aFontId
    ^ self primitiveFailed
!

widthOf:aString inFont:aFontId
    ^ self primitiveFailed
! !

!NeXTWorkstation methodsFor:'graphic context stuff'!

noClipIn:aDrawableId gc:aGCId
    "disable clipping rectangle"

    ^ self primitiveFailed
!

setBackground:bgColorIndex in:aGCId
    "set background color to be drawn with"

    ^ self primitiveFailed
!

setBitmapMask:aBitmapId in:aGCId
    "set or clear the drawing mask - a bitmap mask using current fg/bg"

    ^ self primitiveFailed
!

setClipByChildren:aBool in:aGCId
    "enable/disable drawing into child views"

    ^ self primitiveFailed
!

setClipX:clipX y:clipY width:clipWidth height:clipHeight in:drawableId gc:aGCId
    "clip to a rectangle"

    ^ self primitiveFailed
!

setFont:aFontId in:aGCId
    "set font to be drawn in"

    ^ self primitiveFailed
!

setForeground:fgColorIndex background:bgColorIndex in:aGCId
    "set foreground and background colors to be drawn with"

    ^ self primitiveFailed
!

setForeground:fgColor background:bgColor mask:aBitmapId in:aGCId
    "set foreground and background colors to be drawn with using mask or
     solid (if aBitmapId is nil)"

    ^ self primitiveFailed
!

setForeground:fgColor background:bgColor mask:aBitmapId lineWidth:lw in:aGCId
    "set foreground and background colors to be drawn with using mask or
     solid (if aBitmapId is nil); also set lineWidth"

    ^ self primitiveFailed
!

setForeground:fgColorIndex in:aGCId
    "set foreground color to be drawn with"

    ^ self primitiveFailed
!

setFunction:aFunctionSymbol in:aGCId
    "set alu function to be drawn with"

    "{ Symbol: and  } "
    "{ Symbol: or   } "
    "{ Symbol: xor  } "
    "{ Symbol: copy } "
    "{ Symbol: copyInverted } "
    "{ Symbol: andInverted } "
    "{ Symbol: andReverse } "
    "{ Symbol: orInverted } "
    "{ Symbol: orReverse } "

    ^ self primitiveFailed
!

setGraphicsExposures:aBoolean in:aGCId
    "set or clear the graphics exposures flag"

    ^ self primitiveFailed
!

setLineWidth:aNumber in:aGCId
    "set linewidth to be drawn with"

    ^ self primitiveFailed
!

setMaskOriginX:orgX y:orgY in:aGCid
    "set the mask origin"

    ^ self primitiveFailed
!

setPixmapMask:aPixmapId in:aGCId
    "set or clear the drawing mask - a pixmap mask providing full color"

    ^ self primitiveFailed
! !

!NeXTWorkstation methodsFor:'initialize / release'!

close
%{
    _NX_close();
%}
!

initialize
    "{ Symbol: color      }"
    "{ Symbol: monochrome }"
%{
    int depth, width, height;
    char *visual;

    /* do NXApp stuff, get screen infos */
    _NX_init(&visual, &depth, &width, &height);

    _INST(visualType) = _MKSYMBOL(visual, (OBJ *)0);
    _INST(depth) = _MKSMALLINT(depth);
    _INST(width) = _MKSMALLINT(width);
    _INST(height) = _MKSMALLINT(height);

    _INST(widthMM) = _MKSMALLINT(300);
    _INST(heightMM) = _MKSMALLINT(222);

    if (strcmp(visual, "StaticGray") == 0) {
	_INST(hasColors) = false;
	_INST(hasGreyscales) = true;
	_INST(bitsPerRGB) = _MKSMALLINT(2);
	if (depth == 2)
	    _INST(ncells) = _MKSMALLINT(4);
	_INST(monitorType) = _monochrome;
    } else if (strcmp(visual, "TrueColor") == 0) {
	_INST(hasColors) = true;
	_INST(hasGreyscales) = true;
	/*
	 * does this exist ?"
	 *
	if (depth == 8) {
	    _INST(ncells) = _MKSMALLINT(256);
	}
	 *
	 */
	/* should work for colorStation */
	if (depth == 12) {
	    _INST(ncells) = _MKSMALLINT(4096);
	    _INST(bitsPerRGB) = _MKSMALLINT(4);
	}
	/* should work for nextDimension */
	if (depth == 24) {
	    _INST(ncells) = _MKSMALLINT(4096 * 4096);
	    _INST(bitsPerRGB) = _MKSMALLINT(8);
	}
	_INST(monitorType) = _color;
    }
%}
.
    dispatching := false.
    shiftDown := false.
    ctrlDown := false.
    metaDown := false.
    altDown := false.
    motionEventCompression := true.
    buffered := true.
    self initializeKeyboardMap
! !

!NeXTWorkstation methodsFor:'misc'!

buffered
    "buffer drawing - do not send it immediately to the display"

    buffered := true
!

lastError
    "return the last X-error string - when buffering is on, this may be
     an error for a long-ago operation"

    ^ nil
!

synchronizeOutput
    "send all buffered drawing to the display"
%{
    NXPing();
%}
!

unBuffered
    "make all drawing be sent immediately to the display"

    buffered := false
! !

!NeXTWorkstation methodsFor:'misc stuff'!

setInputFocusTo:aWindowId
    ^ self primitiveFailed
! !

!NeXTWorkstation methodsFor:'private'!

addKnownView:aView winId:aNumber withId:aDrawableNumber
    "add the View aView with Id:aNumber to the list of known views/id's"

    knownViews isNil ifTrue:[
	knownViews := OrderedCollection new:100.
	knownIds := OrderedCollection new:100.
	knownDrawableIds := OrderedCollection new:100
    ].
    knownViews add:aView.
    knownIds add:aNumber.
    knownDrawableIds add:aDrawableNumber
! !

!NeXTWorkstation methodsFor:'retrieving pixels'!

getPixelX:x y:y from:aDrawableId
    "return the pixel value at x/y"

    ^ self primitiveFailed
! !

!NeXTWorkstation methodsFor:'window stuff'!

clearRectangleX:x y:y width:width height:height in:aWindowId
    ^ self primitiveFailed
!

clearWindow:aWindowId
    ^ self primitiveFailed
!

mapWindow:aWindowId
    ^ self primitiveFailed
!

moveResizeWindow:aWindowId x:x y:y width:w height:h
    ^ self primitiveFailed
!

moveWindow:aWindowId x:x y:y
    ^ self primitiveFailed
!

raiseWindow:aWindowId
    ^ self primitiveFailed
!

resizeWindow:aWindowId width:w height:h
    ^ self primitiveFailed
!

setBackingStore:how in:aWindowId
    "turn on/off backing-store for a window"

    ^ self
!

setCursor:aCursorId in:aWindowId
    ^ self primitiveFailed
!

setSaveUnder:yesOrNo in:aWindowId
    "turn on/off save-under for a window"

    ^ self
!

setWindowBackground:aColorId in:aWindowId
%{
#ifdef NOTDEF
    int id, ir, ig, ib;
    float r, g, b;
    NXColor clr;

    if (__isSmallInteger(aColorId)) {
	id = _intVal(aColorId);
	ir = (id >> 16) & 0xFF;
	ig = (id >> 8) & 0xFF;
	ib = id & 0xFF;
	/* scale from 0 .. 255 to 0.0 .. 1.0 */
	r = (float)ir / 255.0;
	g = (float)ig / 255.0;
	b = (float)ib / 255.0;
	clr = NXConvertRGBToColor(r, g, b);
    }
#endif
%}
.
    ^ self primitiveFailed
!

setWindowBackgroundPixmap:aPixmapId in:aWindowId
    ^ self primitiveFailed
!

setWindowBorderColor:aColorId in:aWindowId
    ^ self primitiveFailed
!

setWindowBorderPixmap:aPixmapId in:aWindowId
    ^ self primitiveFailed
!

setWindowBorderShape:aPixmapId in:aWindowId
    ^ self
!

setWindowBorderWidth:aNumber in:aWindowId
    ^ self primitiveFailed
!

setWindowIcon:aForm in:aWindowId
    ^ self primitiveFailed
!

setWindowIcon:aForm mask:aMaskForm in:aWindowId
    ^ self primitiveFailed
!

setWindowIconWindow:aView in:aWindowId
    ^ self primitiveFailed
!

setWindowName:aString in:aWindowId
    ^ self primitiveFailed
!

setWindowShape:aPixmapId in:aWindowId
    ^ self
!

unmapWindow:aWindowId
    ^ self primitiveFailed
! !


NeXTWorkstation initialize!
