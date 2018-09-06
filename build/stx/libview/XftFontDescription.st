"
 COPYRIGHT (c) 2013 by Jan Vrany
 COPYRIGHT (c) 2013 by eXept Software AG
 COPYRIGHT (c) 2015-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

FontDescription subclass:#XftFontDescription
	instanceVariableNames:'device fontId closestFont minCode maxCode ascent descent height
		fixedWidth'
	classVariableNames:'CachedFontList RecentlyUsedFonts Lobby'
	poolDictionaries:'FcConstants'
	category:'Graphics-Support'
!

Object subclass:#FCFontListParser
	instanceVariableNames:'pipeStream lineStream currentDescription'
	classVariableNames:''
	poolDictionaries:''
	privateIn:XftFontDescription
!

ExternalAddress subclass:#XftDrawHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XftFontDescription
!

ExternalAddress subclass:#XftFontHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:XftFontDescription
!

!XftFontDescription primitiveDefinitions!
%{
/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#undef True
#undef False
#undef Time
#define Time XTime

#ifdef XFT
#  ifndef HAVE_FONTCONFIG
#    error "XFT defined but not HAVE_FONTCONFIG. Xft fonts cannot be used without FontConfig support"
#  endif

extern OBJ __GLOBAL_GET_BY_NAME(char *);

# define __HANDLE_VAL(type, externalAddress) \
        ((type)__externalAddressVal(externalAddress))

# define __HANDLE_NEW(ptr, __cls)                    \
        ({                                           \
            OBJ handle = __MKEXTERNALADDRESS(ptr);   \
            OBJ clsObj = __GLOBAL_GET_BY_NAME(__cls);\
            __InstPtr(handle)->o_class = clsObj;     \
            __STORE(handle, clsObj);                 \
            handle;                                  \
        })



# define DISPLAY(x)    __HANDLE_VAL(Display*, x)
# define SCREEN(x)     ((int)(__intVal(x)))
# define DRAWABLE(x)   __HANDLE_VAL(Drawable, x)
# define GC(x)         __HANDLE_VAL(GC, x)
# define VISUAL(x)     __HANDLE_VAL(Visual*, x)
# define COLORMAP(x)   __HANDLE_VAL(Colormap, x)

/* FontConfig objects */
# define FC_PATTERN(x)                  __HANDLE_VAL(XftPattern*, x)
# define FC_PATTERN_HANDLE_NEW(x)       __HANDLE_NEW(x, "FcPattern")

/* Xft Objects */

# define XFT_FONT(x)            __HANDLE_VAL(XftFont*, x)
# define XFT_FONT_HANDLE_NEW(x) __HANDLE_NEW(x, "XftFontDescription::XftFontHandle")

# define XFT_DRAW(x)            __HANDLE_VAL(XftDraw*, x)
# define XFT_DRAW_HANDLE_NEW(x) __HANDLE_NEW(x, "XftFontDescription::XftDrawHandle")


# include <X11/Xft/Xft.h>
# include <X11/Xft/XftCompat.h>

#endif

%}
! !

!XftFontDescription class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by Jan Vrany
 COPYRIGHT (c) 2013 by eXept Software AG
 COPYRIGHT (c) 2015-2017 Jan Vrany
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
    WARNING: Unfinished.

    Experimental implementation of custom font rendered using
    Xft library (UNIX / X Window only), To actually use it,
    add following definitions to the end of stx/configurations/myConf
    (works on Ubuntu 12.10)

    --- snip ---
    XDEFS+=-DXFT
    XINCLUDE+=$(shell pkg-config --cflags xft)
    LIB_XFT=-l:libXft.so.2 -l:libfontconfig.so.1
    --- snip --

    NOTE: This class should be named XftFont, however then
    there would be a name clash with XftFont structure
    defined in Xft.h - therefore the class is named
    XftFontDescription to avoid that name clash.


    [author:]
	Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!XftFontDescription class methodsFor:'initialization'!

flushListOfAvailableFonts
    CachedFontList := nil.

    "
     XftFontDescription flushListOfAvailableFonts
    "
!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    Lobby isNil ifTrue:[
        Lobby := Registry new.
    ].

    "Modified: / 30-12-2013 / 19:48:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription class methodsFor:'instance creation'!

family:familyString face:faceString style:styleString size:size sizeUnit:sizeUnit encoding:encoding
    "returns a font for given family, face, style, size and the specified encoding.
     The returned font is not associated to a specific device"

    |proto|

    RecentlyUsedFonts notNil ifTrue:[
        proto := RecentlyUsedFonts
                detect:[:fn |
                    fn sameFamily: familyString 
                             face: faceString
                            style: styleString 
                             size: size 
                             unit: sizeUnit 
                        pixelSize: nil
                         encoding: encoding]
                ifNone:[ nil ].
        proto notNil ifTrue:[
            ^ proto
        ].
    ].

    CachedFontList notNil ifTrue:[
        proto := CachedFontList
                detect:[:fn |
                    fn sameFamily: familyString 
                             face: faceString
                            style: styleString 
                             size: size 
                             unit: sizeUnit 
                        pixelSize: nil
                         encoding: encoding]
                ifNone:[ nil ].
        proto notNil ifTrue:[
            ^ (proto shallowCopy)
                setDevice: nil patternId: nil fontId: nil;
                family:familyString face:faceString style:styleString size:size sizeUnit:sizeUnit encoding:encoding
        ].
    ].
    ^ super
        family:familyString face:faceString style:styleString size:size sizeUnit:sizeUnit encoding:encoding

    "Modified: / 29-02-2016 / 08:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

for:aFontOrFontDescription
    ^ self
        family:aFontOrFontDescription family
        face:aFontOrFontDescription face 
        style:aFontOrFontDescription style 
        size:aFontOrFontDescription size 
        sizeUnit:#pt 
        encoding:aFontOrFontDescription encoding
!

named: aString
    ^ self new setName: aString

    "Created: / 05-03-2015 / 05:20:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!XftFontDescription class methodsFor:'* uncategorized *'!

aboutToDestroyViewWithDevice:aGLXWorkstation id:anExternalAddress

    "Created: / 11-10-2015 / 11:32:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription class methodsFor:'examples'!

example1
    "
    XftFontDescription example1
    "
    |top textView|

    top := StandardSystemView new.
    top extent:300@200.

    textView := EditTextView new.
    textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    textView basicFont: (XftFontDescription family: 'DejaVu Sans' size: 16).

    top addSubView:textView.

    textView contents:('/etc/hosts' asFilename contentsOfEntireFile asText).

    top open.

    "Created: / 20-12-2013 / 00:04:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2013 / 19:11:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example2
    "
    XftFontDescription example2
    "
    |top textView|

    top := StandardSystemView new.
    top extent:300@200.

    textView := EditTextView new.
    textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    textView basicFont: (XftFontDescription family: 'DejaVu Sans' size: 30) asItalic.

    top addSubView:textView.

    textView contents:('/etc/hosts' asFilename contentsOfEntireFile).

    top open.

    "Created: / 30-12-2013 / 19:49:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example3
    "
    XftFontDescription example2
    "
    |top textView|

    top := StandardSystemView new.
    top extent:300@200.

    textView := EditTextView new.
    textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    textView basicFont: (XftFontDescription family: 'Indie Flower' size: 30).

    top addSubView:textView.

    textView contents:('/etc/hosts' asFilename contentsOfEntireFile).

    top open.

    "Created: / 30-12-2013 / 19:49:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription class methodsFor:'primitives'!

xftAvailable
    <resource: #obsolete>

    ^ ConfigurableFeatures hasXFT

    "Created: / 20-12-2013 / 21:10:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 22-02-2016 / 08:15:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

xftDrawDestroy: xftDrawId
%{
#ifdef XFT
    XftDraw *xftDraw;
    if (__isExternalAddressLike(xftDrawId) && (xftDraw = XFT_DRAW(xftDrawId)) != NULL) {
        __externalAddressVal(xftDrawId) = NULL;             
        XftDrawDestroy(xftDraw);
    }
    RETURN (self);
#endif
%}.
    self primitiveFailed.

! !

!XftFontDescription class methodsFor:'queries'!

listOfAvailableFonts
    "uses fc-list to get a list of available fontDescriptions"

    CachedFontList isNil ifTrue:[
	CachedFontList := FCFontListParser new listOfAvailableFonts
    ].
    ^ CachedFontList

    "
     XftFontDescription flushListOfAvailableFonts.
     XftFontDescription listOfAvailableFonts
    "
! !

!XftFontDescription methodsFor:'accessing'!

encoding
    ^ encoding ? 'iso10646-1'
!

fullName
    ^ name ? (self userFriendlyName)
!

graphicsDevice
    ^ device

    "Created: / 02-01-2014 / 23:22:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maxCode
    ^ maxCode ? 16rFFFF
!

maxCode:something
    maxCode := something.
!

minCode
    ^ minCode ? 0
!

minCode:something
    minCode := something.
!

size
    ^ size ? 0
!

weight:aNumber
    "set the weight"

    self assert:(self fontId isNil). "/ cannot change an instantiated font

    weight := aNumber.

    aNumber == FC_WEIGHT_THIN ifTrue:[ face := #thin. ^ self].
    aNumber == FC_WEIGHT_EXTRALIGHT ifTrue:[ face := #extralight. ^ self].
    aNumber == FC_WEIGHT_LIGHT ifTrue:[ face := #light. ^ self].
    aNumber == FC_WEIGHT_BOOK ifTrue:[ face := #book. ^ self].
    aNumber == FC_WEIGHT_REGULAR ifTrue:[ face := #regular. ^ self].
    aNumber == FC_WEIGHT_MEDIUM ifTrue:[ face := #medium. ^ self].
    aNumber == FC_WEIGHT_DEMIBOLD ifTrue:[ face := #demibold. ^ self].
    aNumber == FC_WEIGHT_BOLD ifTrue:[ face := #bold. ^ self].
    aNumber == FC_WEIGHT_EXTRABOLD ifTrue:[ face := #extrabold. ^ self].
    aNumber == FC_WEIGHT_BLACK ifTrue:[ face := #black. ^ self].
    aNumber == FC_WEIGHT_EXTRABLACK ifTrue:[ face := #extrablack. ^ self].

    aNumber <= (FC_WEIGHT_EXTRALIGHT + FC_WEIGHT_LIGHT // 2) ifTrue:[
	face := #extralight.
	^ self.
    ].
    aNumber <= (FC_WEIGHT_LIGHT + FC_WEIGHT_BOOK // 2) ifTrue:[
	face := #light.
	^ self.
    ].
    aNumber <= (FC_WEIGHT_MEDIUM + FC_WEIGHT_DEMIBOLD // 2) ifTrue:[
	face := #medium.
	^ self.
    ].
    aNumber <= (FC_WEIGHT_DEMIBOLD + FC_WEIGHT_BOLD // 2) ifTrue:[
	face := #demibold.
	^ self.
    ].
    aNumber <= (FC_WEIGHT_BOLD + FC_WEIGHT_BLACK // 2) ifTrue:[
	face := #bold.
	^ self.
    ].
    face := #extrabold.
    ^ self

"/    FC_WEIGHT_THIN          := 0.
"/    FC_WEIGHT_EXTRALIGHT    := 40.
"/    FC_WEIGHT_ULTRALIGHT    := FC_WEIGHT_EXTRALIGHT.
"/    FC_WEIGHT_LIGHT         := 50.
"/    FC_WEIGHT_BOOK          := 75.
"/    FC_WEIGHT_REGULAR       := 80.
"/    FC_WEIGHT_NORMAL        := FC_WEIGHT_REGULAR.
"/    FC_WEIGHT_MEDIUM        := 100.
"/    FC_WEIGHT_DEMIBOLD      := 180.
"/    FC_WEIGHT_SEMIBOLD      := FC_WEIGHT_DEMIBOLD.
"/    FC_WEIGHT_BOLD          := 200.
"/    FC_WEIGHT_EXTRABOLD     := 205.
"/    FC_WEIGHT_ULTRABOLD     := FC_WEIGHT_EXTRABOLD.
"/    FC_WEIGHT_BLACK         := 210.
"/    FC_WEIGHT_HEAVY         := FC_WEIGHT_BLACK.
"/    FC_WEIGHT_EXTRABLACK    := 215.
"/    FC_WEIGHT_ULTRABLACK    := FC_WEIGHT_EXTRABLACK.
! !

!XftFontDescription methodsFor:'accessing-private'!

getFontId
    ^ fontId

    "Created: / 02-01-2014 / 23:29:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription methodsFor:'converting'!

asNonXftFont
    |newFont|

    newFont := Font
                    family:family
                    face:face
                    style:style
                    size:(sizeUnit == #px ifTrue:[pixelSize] ifFalse:[size])
                    sizeUnit:sizeUnit
                    encoding:encoding.

    ^ newFont
! !

!XftFontDescription methodsFor:'displaying'!

displayString:aString from:index1 to:index2Arg x:xArg y:yArg in:aGC opaque:opaque
    "display a partial string at some position in aGC."
    
    |index2 bytesPerCharacter transformation
     clipOrg clipCorn clipRect clipX clipY clipW clipH clipPnt
     fg fgR fgG fgB fgA fgPixel bg bgR bgG bgB bgA bgPixel
     drawX drawY drawPnt displayId screen drawableId error stringLen drawId drawIdIsShared
     newXftDrawId newDrawableAssociation |

    aGC isPixmap ifTrue:[        
        aGC depth ifTrue:[
            "/ Using XFT font to draw in bitmap is not allowed. In theory it could
            "/ work if XFT would just turn gray into either black or white. But XFT
            "/ doesn't do it and simply draw nothing without failing in any way. 
            "/ 
            "/ To prevent this silent failures, forbid drawing XFT onto bitmaps
            "/ (depth-1 pixmaps). After all, the while point of XFT is to use
            "/ anti-aliased fonts.
            self error: 'XFT font cannot be used with bitmaps'.
            ^self
        ].
    ].

                                             
    "limit the string len, otherwise bad output is generated"
    stringLen := index2Arg - index1 + 1.
    stringLen > 1000 "8000" ifTrue:[
	index2 := index1 + 1000 "8000" - 1.
    ]  ifFalse:[
        stringLen <= 0 ifTrue:[^ self].
        index2 := index2Arg.
    ].
    bytesPerCharacter := aString bitsPerCharacter // 8.

    clipRect := aGC deviceClippingBoundsOrNil.
    clipRect notNil ifTrue:[
        clipX := clipRect left.
        clipY := clipRect top.
        clipW := clipRect width.
        clipH := clipRect height.
    ].

    transformation := aGC transformation.
    transformation isNil ifTrue:[
        drawX := xArg.
        drawY := yArg.
    ] ifFalse:[
        drawPnt := transformation transformPoint:(xArg @ yArg).
        drawX := drawPnt x ceiling.
        drawY := drawPnt y ceiling.
    ].

    fg  := aGC paint.
    fgR := fg scaledRed.
    fgG := fg scaledGreen.
    fgB := fg scaledBlue.
    fgA := fg scaledAlpha.

    fgR isNil ifTrue:[
        "/ when drawing into a pixmap...
        fgPixel := fg colorId.
        fgPixel == 0 ifTrue:[
            fgR := fgG := fgB := 0.
        ] ifFalse:[
            fgR := fgG := fgB := 16rFFFF.
        ]
    ].

    opaque ifTrue:[
        bg := aGC backgroundPaint.
        bg isColor ifTrue:[
            bgR := bg scaledRed.
            bgG := bg scaledGreen.
            bgB := bg scaledBlue.
            bgA := bg scaledAlpha.
        ] ifFalse:[
            "images are not yet implemented"
            "/ #todo: fill background rectangle
            bgR := bgG := bgB := bgA := 16rFFFF.
        ].
        bgR isNil ifTrue:[
            "/ when drawing into a pixmap...
            bgPixel := bg colorId.
            bgPixel == 0 ifTrue:[
                bgR := bgG := bgB := 0.
            ] ifFalse:[
                bgR := bgG := bgB := 16rFFFF.
            ]
        ].
    ].
    displayId := device displayIdOrErrorIfBroken.
    displayId isNil ifTrue:[
        ^ self.
    ].
    screen := device screen.
    drawableId := aGC drawableId.
    
    ((aGC class == XGraphicsContext) or:[aGC isKindOf: XGraphicsContext]) ifTrue:[
        "/ TODO: Following should be done atomically together with drawing...
        drawId := aGC xftDrawId.
        drawIdIsShared := false.
        drawId isNil ifTrue:[
%{  /* STACK: 64000 */
            drawId = XFT_DRAW_HANDLE_NEW ( XftDrawCreate ( DISPLAY( displayId ) ,
                                           DRAWABLE( drawableId ) ,
                                           DefaultVisual( DISPLAY( displayId), SCREEN (screen) ) ,
                                           DefaultColormap( DISPLAY( displayId), SCREEN (screen) ) ) ); 
%}.
            aGC xftDrawId: drawId.
        ].
    ] ifFalse:[
        self error: 'GC passed to XftGraphicsContext is not an XGraphicsContext!!'.
        ^self
    ].

%{  /* STACK: 64000 */
#ifdef XFT
    XftColor color;
    XGlyphInfo extents;
    XRectangle clipRX;
    char *string;
    int len;
    int __bytesPerCharacter;
    XftDraw *__sharedDrawId;
    XftFont *__xftFont = XFT_FONT(__INST(fontId));

    if (!(__bothSmallInteger(drawX, drawY)
          && __bothSmallInteger(index1, index2)
          && __isSmallInteger(bytesPerCharacter)
          && (__isSmallInteger(fgPixel) || (__bothSmallInteger(fgR, fgG) && __bothSmallInteger(fgB, fgA)))
          && (opaque == false || __isSmallInteger(bgPixel) || (__bothSmallInteger(bgR, bgG) && __bothSmallInteger(bgB, bgA)))
          && __isNonNilObject(aString)
    )) {
        goto err;
    }

    __bytesPerCharacter = __intVal(bytesPerCharacter);
    __sharedDrawId = XFT_DRAW ( drawId );
    
    string = __stringVal(aString) + ((__intVal(index1) - 1 ) * __bytesPerCharacter);
    len = __intVal(index2) - __intVal(index1) + 1;

    if (clipRect != nil) {
        clipRX.x = __intVal(clipX);
        clipRX.y = __intVal(clipY);
        clipRX.width = __intVal(clipW);
        clipRX.height = __intVal(clipH);
        XftDrawSetClipRectangles(__sharedDrawId, 0, 0, &clipRX, 1);
    } else {
        XftDrawSetClip(__sharedDrawId, 0);
    }

    if (opaque == true) {
        if (bgPixel != nil) {
            color.pixel = (unsigned long)__intVal(bgPixel);
        }
        color.color.red = __intVal(bgR);
        color.color.green = __intVal(bgG);
        color.color.blue = __intVal(bgB);
        color.color.alpha = __intVal(bgA);

        switch (__bytesPerCharacter) {
        case 1:
            XftTextExtents8(DISPLAY(displayId), __xftFont, (FcChar8*)string, len, &extents);
            break;
        case 2:
            XftTextExtents16(DISPLAY(displayId), __xftFont, (FcChar16*)string, len, &extents);
            break;
        case 4:
            XftTextExtents32(DISPLAY(displayId), __xftFont, (FcChar32*)string, len, &extents);
            break;
        }
        XftDrawRect(__sharedDrawId, &color, __intVal(drawX) - extents.x, __intVal(drawY) - __xftFont->ascent, extents.width, __xftFont->height);
    }
    if (fgPixel != nil) {
        color.pixel = (unsigned long)__intVal(fgPixel);
    }
    color.color.red = __intVal(fgR);
    color.color.green = __intVal(fgG);
    color.color.blue = __intVal(fgB);
    color.color.alpha = __intVal(fgA);

    switch (__bytesPerCharacter) {
    case 1:
        XftDrawString8(__sharedDrawId, &color,__xftFont,
                        __intVal(drawX),
                        __intVal(drawY),
                        (FcChar8*)string,
                        len);
        break;

    case 2:
        XftDrawString16(__sharedDrawId, &color, __xftFont,
                        __intVal(drawX),
                        __intVal(drawY),
                        (FcChar16*)string,
                        len);
        break;

    case 4:
        XftDrawString32(__sharedDrawId, &color, __xftFont,
                        __intVal(drawX),
                        __intVal(drawY),
                        (FcChar32*)string,
                        len);
        break;

    default:
        goto err;
    }

    RETURN(self);

#endif
    err:;
%}.
    self primitiveFailed: error.

    "Created: / 21-12-2013 / 21:11:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-06-2014 / 22:06:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription methodsFor:'error reporting'!

primitiveFailed
    <resource: #skipInDebuggersWalkBack>

    ConfigurableFeatures hasXFT ifFalse:[
        super primitiveFailed:'Xft support is not configured'.
    ].
    super primitiveFailed
!

primitiveFailed:errorString
    <resource: #skipInDebuggersWalkBack>

    ConfigurableFeatures hasXFT ifFalse:[
        super primitiveFailed:'Xft support is not configured'.
    ].
    super primitiveFailed:errorString
! !

!XftFontDescription methodsFor:'finalization'!

finalizationLobby
    ^ Lobby
!

finalize
    self xftDrawDestroy
! !

!XftFontDescription methodsFor:'getting a device font'!

onDevice:aGraphicsDevice
    "Create a new XftFont representing the closes font as
     myself on aDevice; if one already exists, return the one."

    ^ self onDevice: aGraphicsDevice ifAbsent: nil

    "Modified: / 14-04-1997 / 18:22:31 / cg"
    "Modified: / 29-02-2016 / 07:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onDevice:aGraphicsDevice ifAbsent: aBlock
    "Create a new XftFont representing the closes font as
     myself on aDevice; if one already exists, return the one."

    | myPatternId closestPatternId1 closestPatternId2 newFontId |

    (device == aGraphicsDevice) ifTrue:[
        "I am already assigned to that device ..."
        ^ self
    ].
    aGraphicsDevice isNil ifTrue:[
        ^ self
    ].
    aGraphicsDevice supportsXftFonts ifFalse:[
        ^ super onDevice:aGraphicsDevice ifAbsent:aBlock.
    ].

    RecentlyUsedFonts isNil ifTrue:[
        RecentlyUsedFonts := OrderedCollection new:20.
    ].

    RecentlyUsedFonts keysAndValuesDo:[:index :aFont |
        ((aFont class == self class) and:[(self sameDeviceFontAs:aFont)]) ifTrue:[
            "/ Transcript showCR:'hit'.
            RecentlyUsedFonts
                removeIndex:index;
                addFirst:aFont.
            ^ aFont
        ]
    ].

    RecentlyUsedFonts size >= 20 ifTrue:[
        RecentlyUsedFonts removeLast.
    ].

    aGraphicsDevice deviceFonts do:[:aFont |
        ((aFont class == self class) and:[self sameDeviceFontAs:aFont]) ifTrue:[
            RecentlyUsedFonts addFirst:aFont.
            ^ aFont
        ].
    ]. 

    "/ Transcript show: 'XFT font not found in cache:'; showCR: self printString.
    [
        myPatternId := FcPattern fromFontDescription: self. 
        newFontId := self xftFontOpenPattern: aGraphicsDevice displayId pattern: myPatternId.
        newFontId notNil ifTrue:[
            "/ Good, this font exists!!
            myPatternId := nil.
        ] ifFalse:[
            closestPatternId1 := self xftFontMatch: aGraphicsDevice displayId screen: aGraphicsDevice screen pattern: myPatternId.
            closestPatternId1 isNil ifTrue:[
                self error: 'No font matches'.
            ].
            closestPatternId2 := closestPatternId1 copy.
            newFontId := self xftFontOpenPattern: aGraphicsDevice displayId pattern: closestPatternId1.
            "/ !!!!!!!! closestPatternId is no longer valid !!!!!!!!
            closestPatternId1 :=  nil.
            newFontId isNil ifTrue:[
                ^ aBlock value
            ].
        ].
        fontId := newFontId.
        device := aGraphicsDevice.
        aGraphicsDevice registerFont:self.
        RecentlyUsedFonts addFirst:self.
        myPatternId notNil ifTrue:[myPatternId release].
        closestPatternId1 notNil ifTrue:[closestPatternId1 release].
        closestPatternId2 notNil ifTrue:[closestPatternId2 release].
        ^ self. 
    ] ensure:[
        myPatternId notNil ifTrue:[myPatternId release].
        closestPatternId1 notNil ifTrue:[closestPatternId1 release].
        closestPatternId2 notNil ifTrue:[closestPatternId2 release].
    ].

    "
     (XftFontDescription family:'monospace' size:16) onDevice:Screen current
    "

    "Modified: / 29-02-2016 / 08:36:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription methodsFor:'initialization'!

initialize
    super initialize.
    flags := AntialiasedFlag

    "Modified: / 26-11-2016 / 21:25:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setDevice: deviceArg patternId: patternIdArg fontId: fontIdArg
    device := deviceArg.
    fontId := fontIdArg.
    patternIdArg notNil ifTrue:[
        family  := patternIdArg at: FC_FAMILY index: 1.
        size    := patternIdArg at: FC_SIZE index: 1.
        face    := patternIdArg at: FC_WEIGHT index: 1.
        face    := StXFace2FCWeightMap keyAtValue: face.
        face isEmptyOrNil ifTrue:[ face := nil ].
        style   := patternIdArg at: FC_SLANT index: 1.
        style   := StXStyle2FCSlantMap keyAtValue: style.
        style isEmptyOrNil ifTrue:[ style := nil ].
        name    := patternIdArg at: FC_FULLNAME index: 1.

        encoding:= patternIdArg at: 'encoding' index: 1.
    ].

    "Created: / 21-12-2013 / 00:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-02-2016 / 07:43:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setName: aString
    "Initializes font description from a string like 'times-12' or 'times,charter-12:bold'"

    | pattern |

    pattern := FcPattern fromString: aString.  
    pattern notNil ifTrue:[
        family  := pattern at: FC_FAMILY index: 1.
        size    := pattern at: FC_SIZE index: 1.
        face    := pattern at: FC_WEIGHT index: 1.
        face    := StXFace2FCWeightMap keyAtValue: face.
        style   := pattern at: FC_SLANT index: 1.
        style   := StXStyle2FCSlantMap keyAtValue: style.
        name    := pattern at: FC_FULLNAME index: 1.
        encoding:= pattern at: 'encoding' index: 1.
        encoding notNil ifTrue:[encoding := encoding asSymbol].
        pattern release.
    ].

    "
    XftFontDescription named: 'times-12'
    XftFontDescription named: 'times,charter-12:bold'
    XftFontDescription named: 'Sans-10'
    "

    "Created: / 05-03-2015 / 05:19:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription methodsFor:'primitives'!

xftDrawChange:xftDrawId drawable:drawableId
    | error |

%{
#ifdef XFT
    if ( ! __isExternalAddressLike(xftDrawId) ) {
        error = @symbol(BadArg1);
        goto err;
    }
    if (drawableId == nil) {
        XftDrawChange(XFT_DRAW(xftDrawId), None);
        RETURN (self);
    }
    if ( ! __isExternalAddressLike(drawableId) ) {
        error = @symbol(BadArg2);
        goto err;
    }
    if (XftDrawDrawable( XFT_DRAW(xftDrawId) ) != DRAWABLE( drawableId ) ) {
        XftDrawChange( XFT_DRAW(xftDrawId) , DRAWABLE( drawableId ) );
    }
    RETURN (self);
err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 26-12-2013 / 12:17:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftDrawCreate: displayId screen: screen drawable: drawableId
    | error |

%{
#ifdef XFT
    if ( ! __isExternalAddressLike(displayId) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    if ( ! __isSmallInteger(screen) ) {
	error = @symbol(BadArg2);
	goto err;
    }
    if ( ! __isExternalAddressLike(drawableId) ) {
	error = @symbol(BadArg3);
	goto err;
    }
    RETURN ( XFT_DRAW_HANDLE_NEW (  XftDrawCreate ( DISPLAY( displayId ) ,
						   DRAWABLE( drawableId ) ,
						   DefaultVisual( DISPLAY( displayId), SCREEN (screen) ) ,
						   DefaultColormap( DISPLAY( displayId), SCREEN (screen) ) ) ) );
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 21-12-2013 / 21:12:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftDrawRect: drawIdArg color: aColor x: x y: y width: w height: h
    | error r g b a pix |

    aColor isColor ifFalse:[^self primitiveFailed: #BadArg2].

    r := aColor scaledRed.
    g := aColor scaledGreen.
    b := aColor scaledBlue.
    a := aColor alpha * 65535.
    r isNil ifTrue:[
	"/ when drawing into a pixmap...
	aColor colorId == 0 ifTrue:[
	    r := g := b := 0.
	] ifFalse:[
	    r := g := b := 16rFFFF.
	]
    ].
    pix := aColor colorId.
%{  /* STACK: 64000 */
#ifdef XFT
    XftColor clr;
    if ( ! __isExternalAddressLike(drawIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    if ( ! __isSmallInteger(pix) ) {
	error = @symbol(BadColorId);
	goto err;
    }
    if ( ! __isSmallInteger(x) ) {
	error = @symbol(BadArg3);
	goto err;
    }
    if ( ! __isSmallInteger(y) ) {
	error = @symbol(BadArg4);
	goto err;
    }
    if ( ! __isSmallInteger(w) ) {
	error = @symbol(BadArg5);
	goto err;
    }
    if ( ! __isSmallInteger(h) ) {
	error = @symbol(BadArg6);
	goto err;
    }
    clr.pixel = (unsigned long)__intVal(pix);
    clr.color.red = __intVal(r);
    clr.color.green = __intVal(g);
    clr.color.blue = __intVal(b);
    clr.color.alpha = __intVal(a);

    XftDrawRect(XFT_DRAW(drawIdArg), &clr,
			__intVal(x), __intVal(y), __intVal(w) ,__intVal(h));

    RETURN ( self );
    err:;
#endif
%}.
    self primitiveFailed: error.

    "Created: / 28-12-2013 / 23:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-12-2013 / 00:37:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftDrawSetClip: drawIdArg rectangle: rect
    | error xObj yObj wObj hObj  |

    rect notNil ifTrue:[
	xObj := rect left.
	yObj := rect top.
	wObj := rect width.
	hObj := rect height.
    ].
%{  /* STACK: 64000 */
#ifdef XFT
    XRectangle r;
    if ( ! __isExternalAddressLike(drawIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    if (rect != nil) {
	r.x = __intVal(xObj);
	r.y = __intVal(yObj);
	r.width = __intVal(wObj);
	r.height = __intVal(hObj);
	XftDrawSetClipRectangles( XFT_DRAW(drawIdArg) , 0, 0, &r, 1);
    } else {
	XftDrawSetClipRectangles( XFT_DRAW(drawIdArg) , 0, 0, (XRectangle*)NULL, 0);
    }
    RETURN ( self );
    err:;
#endif
%}.
    self primitiveFailed: error.

    "Created: / 31-12-2013 / 01:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftDrawString: drawIdArg color: aColor font: fontIdArg x: x y: y string: text from: start to: stop
    | error r g b a pix |

    aColor isColor ifFalse:[^self primitiveFailed: #BadArg2].

    r := aColor scaledRed.
    g := aColor scaledGreen.
    b := aColor scaledBlue.
    a := aColor alpha * 65535.
    r isNil ifTrue:[
	"/ when drawing into a pixmap...
	aColor colorId == 0 ifTrue:[
	    r := g := b := 0.
	] ifFalse:[
	    r := g := b := 16rFFFF.
	]
    ].
    pix := aColor colorId.
%{  /* STACK: 64000 */
#ifdef XFT
    int _start, _stop;
    int __x, __y;
    XftColor clr;
    if ( ! __isExternalAddressLike(drawIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    if ( ! __isSmallInteger(pix) ) {
	error = @symbol(BadColorId);
	goto err;
    }
    if ( ! __isSmallInteger(x) ) {
	error = @symbol(BadArg4);
	goto err;
    }
    __x = __intVal(x);
    if ( ! __isSmallInteger(y) ) {
	error = @symbol(BadArg5);
	goto err;
    }
    __y = __intVal(y);


    if ( ! __isSmallInteger(start) ) {
	error = @symbol(BadArg6);
	goto err;
    }
    _start = __intVal(start);
    if ( ! __isSmallInteger(stop) ) {
	error = @symbol(BadArg7);
	goto err;
    }
    _stop = __intVal(stop);

    clr.pixel = (unsigned long)__intVal(pix);
    clr.color.red = __intVal(r);
    clr.color.green = __intVal(g);
    clr.color.blue = __intVal(b);
    clr.color.alpha = __intVal(a);

    if ( __isStringLike(text) ) {
	XftDrawString8(XFT_DRAW(drawIdArg), &clr, XFT_FONT(fontIdArg),
			__x, __y,
			__stringVal(text) + (_start - 1), _stop - _start + 1);
	RETURN ( self );
    } else {
	error = @symbol(BadArg5);
	goto err;
    }
    err:;
#endif
%}.
    self primitiveFailed: error.

    "Created: / 28-12-2013 / 12:32:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2013 / 20:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftFontGetAscent: fontIdArg
    | error |

%{
#ifdef XFT
    int v;
    if ( ! __isExternalAddressLike(fontIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    v = XFT_FONT(fontIdArg)->ascent;
    RETURN ( __MKINT( v ) );
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 21-12-2013 / 00:56:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftFontGetDescent:fontIdArg
    | error |

%{
#ifdef XFT
    int v;
    if ( ! __isExternalAddressLike(fontIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    v = XFT_FONT(fontIdArg)->descent;
    RETURN ( __MKINT( v ) );
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 21-12-2013 / 00:56:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftFontGetHeight: fontIdArg
    | error |

%{
#ifdef XFT
    int v;
    if ( ! __isExternalAddressLike(fontIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    v = XFT_FONT(fontIdArg)->height;
    RETURN ( __MKINT( v ) );
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 21-12-2013 / 00:56:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftFontGetMaxAdvanceWidth: fontIdArg
    | error |

%{
#ifdef XFT
    int v;
    if ( ! __isExternalAddressLike(fontIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    v = XFT_FONT(fontIdArg)->max_advance_width;
    RETURN ( __MKINT( v ) );
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 30-12-2013 / 20:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftFontGetPattern: fontIdArg
    | error |

%{
#ifdef XFT
    XftPattern* p;
    if ( ! __isExternalAddressLike(fontIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    p = XFT_FONT(fontIdArg)->pattern;
    if (p == NULL) {
	RETURN ( nil );
    } else {
	RETURN ( FC_PATTERN_HANDLE_NEW ( p ) );
    }
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 21-12-2013 / 00:55:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftFontMatch: displayId screen: screen pattern: patternId
    | error |

%{ /* STACK: 64000 */
#ifdef XFT
    XftPattern* p;
    XftResult r;

    if ( ! __isExternalAddressLike(displayId) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    if ( ! __isSmallInteger( screen ) ) {
	error = @symbol(BadArg2);
	goto err;
    }
    if ( ! __isExternalAddressLike(patternId) ) {
	error = @symbol(BadArg3);
	goto err;
    }

    XftConfigSubstitute(FC_PATTERN( patternId ));
    XftDefaultSubstitute(DISPLAY(displayId) , SCREEN( screen ), FC_PATTERN( patternId ));
    p = XftFontMatch( DISPLAY(displayId) , SCREEN( screen ), FC_PATTERN( patternId ), &r );
    if (p) {
	RETURN ( FC_PATTERN_HANDLE_NEW ( p ) );
    } else {
	error = @symbol(XftFontMatchReturnedNull);
    }
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 21-12-2013 / 00:08:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftFontOpenPattern: displayId pattern: patternId
    "Note: the pattern is destroyed when the font is closed"

    | error |

%{  /* STACK: 64000 */
#ifdef XFT
    XftFont* f;
    if ( ! __isExternalAddressLike(displayId) ) {
        error = @symbol(BadArg1);
        goto err;
    }
    if ( ! __isExternalAddressLike(patternId) ) {
        error = @symbol(BadArg2);
        goto err;
    }

    f = XftFontOpenPattern( DISPLAY(displayId) , FC_PATTERN( patternId ) );
    if (f == NULL) {
        RETURN ( nil );
    } else {
        RETURN ( XFT_FONT_HANDLE_NEW ( f ) );
    }
    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 20-12-2013 / 23:53:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xftTextExtents: displayIdArg font: fontIdArg string: text from: start to: stop
    | error extents bitsPerCharacter |

    extents :=  Array new: 6.
    bitsPerCharacter := text bitsPerCharacter.
%{  /* STACK: 64000 */
#ifdef XFT
    XGlyphInfo info;
    int bytesPerCharacter;
    char *string;
    int len;

    bytesPerCharacter = __intVal(bitsPerCharacter) / 8;

    if ( ! __isExternalAddressLike(displayIdArg) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    if ( ! __isExternalAddressLike(fontIdArg) ) {
	error = @symbol(BadArg2);
	goto err;
    }
    if ( ! __isSmallInteger(start) ) {
	error = @symbol(BadArg4);
	goto err;
    }
    if ( ! __isSmallInteger(stop) ) {
	error = @symbol(BadArg5);
	goto err;
    }

    string = __stringVal( text ) + (( __intVal(start) - 1 ) * bytesPerCharacter);
    len = __intVal(stop) - __intVal(start) + 1;


    switch (bytesPerCharacter) {
    case 1:
	XftTextExtents8(DISPLAY(displayIdArg), XFT_FONT(fontIdArg), (FcChar8*)string, len, &info);
	break;
    case 2:
	XftTextExtents16(DISPLAY(displayIdArg), XFT_FONT(fontIdArg), (FcChar16*)string, len, &info);
	break;
    case 4:
	XftTextExtents32(DISPLAY(displayIdArg), XFT_FONT(fontIdArg), (FcChar32*)string, len, &info);
	break;
    }
    __ArrayInstPtr(extents)->a_element[0] = __MKSMALLINT(info.width);
    __ArrayInstPtr(extents)->a_element[1] = __MKSMALLINT(info.height);
    __ArrayInstPtr(extents)->a_element[2] = __MKSMALLINT(info.x);
    __ArrayInstPtr(extents)->a_element[3] = __MKSMALLINT(info.y);
    __ArrayInstPtr(extents)->a_element[4] = __MKSMALLINT(info.xOff);
    __ArrayInstPtr(extents)->a_element[5] = __MKSMALLINT(info.yOff);
    error = nil;
    err:;
#endif
%}.
    error notNil ifTrue:[
	self primitiveFailed: error.
	^ nil.
    ].
    ^ extents

    "Created: / 21-12-2013 / 10:42:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2013 / 20:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription methodsFor:'printing & storing'!

storeOn:aStream
    "append a character sequence to the argument, aStream from which the
     receiver can be reconstructed using readFrom:."

    aStream nextPutAll:'(XftFontDescription family:'. family storeOn:aStream.
    aStream nextPutAll:' face:'.        face storeOn:aStream.
    aStream nextPutAll:' style:'.       style storeOn:aStream.
    aStream nextPutAll:' size:'.        size storeOn:aStream.
    aStream nextPutAll:' encoding:'.    encoding storeOn:aStream.
    aStream nextPut:$)

    "
     (XftFontDescription family: 'DejaVu Sans' size: 8) storeString
    "
! !

!XftFontDescription methodsFor:'queries-dimensions'!

ascent
    "return the ascent - the number of pixels above the baseLine."
    ascent isNil ifTrue:[
	ascent := self xftFontGetAscent: fontId
    ].
    ^ ascent

    "Created: / 21-12-2013 / 01:19:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

descent
    "return the descent - the number of pixels below the baseLine."

    descent isNil ifTrue:[
	 descent := self xftFontGetDescent: fontId
    ].
    ^ descent

    "Created: / 21-12-2013 / 01:20:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getFontMetrics
    |info|

    info := DeviceWorkstation::DeviceFontMetrics new.
    info
      ascent:self ascent
      descent:self descent
      maxAscent:self maxAscent
      maxDescent:self maxDescent
      minWidth:self maxWidth
      maxWidth:self maxWidth
      avgWidth:self maxWidth
      minCode:self minCode
      maxCode:self maxCode
      direction:#LeftToRight.
    ^ info
!

getFontResolution
    device isNil ifTrue:[ ^ 72 @ 72 ].
    ^ device resolution
!

height
    "return the height - the number of pixels above plus below the baseLine."

    height isNil ifTrue:[
	height := self xftFontGetHeight: fontId
    ].
    ^ height

    "Created: / 21-12-2013 / 01:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFixedWidth
    "return true, if this is a fixed pitch font (i.e. all characters
     are of the same width)"

    fixedWidth isNil ifTrue:[
	(device notNil and:[fontId notNil]) ifTrue:[
	    |w|

	    "/ take some obvously different chars
	    w := self widthOf:'.'.
	    ((self widthOf:'i') == w
		and:[ (self widthOf:'W') == w
		and:[ (self widthOf:' ') == w ]]
	    ) ifTrue:[
		fixedWidth := w.
	    ] ifFalse:[
		fixedWidth := false
	    ]
	]
    ].
    ^ fixedWidth notNil and:[fixedWidth isInteger]

    "Created: / 21-12-2013 / 10:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maxAscent
    "return the font's maximum-ascent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) above the baseline."

    ^ self ascent

    "Created: / 30-12-2013 / 20:01:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maxDescent
    "return the font's maximum-descent (i.e. the maximum of all characters);
     That is the number of units (usually pixels) below the baseline."

    ^ self descent

    "Created: / 30-12-2013 / 20:01:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maxWidth
    "return the font's maximum-width character (i.e. the maximum of all characters);
     That is a number of units (usually pixels)."

    (fixedWidth class == SmallInteger) ifTrue:[
        ^ fixedWidth
    ].    
    ^ self xftFontGetMaxAdvanceWidth: fontId

    "Created: / 30-12-2013 / 20:02:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

width
    "return the font's characters width;
     That is a number of units (usually pixels).
     For variable pitch fonts, the width of the space character is returned.
     For fixed fonts, this is the same as minWidth or maxWidth (or any character).
     The receiver must be associated to a device, for this query to be legal."

    fixedWidth class == SmallInteger ifTrue:[
        ^ fixedWidth
    ].    
    ^ self widthOf:' '

    "Modified: 30.4.1996 / 16:43:45 / cg"
!

widthOf:aString from:start to:stop
    "return the width of a sub string"

    |extents maxWidthOfSingleGlyph|

    (stop < start) ifTrue:[^ 0].
    maxWidthOfSingleGlyph := self maxWidth.
    "xOff from XFTTextExtents is a signed short.
     Work arond for long strings"
    (stop - start + 1) * maxWidthOfSingleGlyph > 32767 ifTrue:[
	|total chunkSize|

	chunkSize := (32767 // maxWidthOfSingleGlyph) - 1.
	total := 0.
	start to:stop by:chunkSize do:[:eachChunkStart|
	    extents := self xftTextExtents:device displayId font:fontId string:aString
			    from:eachChunkStart to:((eachChunkStart+chunkSize-1) min:stop).
	    "/ extents --> #(width height x y xOff yOff)
	    total := total + extents fifth.
	].
	^ total.
    ].
    extents := self xftTextExtents: device displayId font:fontId string:aString from:start to:stop.
    "/ extents --> #(width height x y xOff yOff)
    "/ cg: shouln't this be first ?!!
    ^ extents fifth.

    "Created: / 21-12-2013 / 10:42:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-12-2013 / 21:16:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription methodsFor:'release'!

releaseFromDevice
    "I am no longer available on the device"

    Lobby unregister:self.
    "/ cg: no, xftDrawDestroy should not be done.
    "/ (releaseFromDevice is called when either the display connection
    "/ is lost, or a snapshot image is restarted)
    "/ self xftDrawDestroy.

    RecentlyUsedFonts := nil.
    device := nil.
    fontId := nil.
    closestFont := nil.

    "Modified: / 25-11-2016 / 00:12:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XftFontDescription methodsFor:'testing'!

isScaledFont
    "Xft fonts are always scaled"

    ^ true
!

isXftFont
    ^ true
! !

!XftFontDescription::FCFontListParser class methodsFor:'documentation'!

documentation
"
    parses fc-list output to get a list of XftFontDescriptions

    [author:]
	cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!XftFontDescription::FCFontListParser methodsFor:'api'!

listOfAvailableFonts
    |readEntry list l fcListProg|

    list := OrderedCollection new.

    readEntry :=
	[
	    |key|

	    [l startsWith:'Pattern has'] whileFalse:[
	      l := pipeStream nextLine. Transcript showCR:l.
	    ].

	    currentDescription := XftFontDescription new.
	    [ l := pipeStream nextLine. l notEmptyOrNil ] whileTrue:[
		"/ Transcript showCR:l.
		lineStream := l readStream. lineStream skipSeparators.
		key := lineStream upToSeparator.
		(
		    #('family:' 'style:' 'slant:' 'weight:' 'width:'
		      'pixelsize:' 'spacing:' 'foundry:' 'antialias:'
		      'file:' 'outline' 'scalable:' 'charset:' 'lang:'
		      'fontversion:' 'fontformat:' 'decorative:' 'index:'
		      'outline:' 'familylang:' 'stylelang:' 'fullname:'
		      'fullnamelang:' 'capability:' 'hash:' 'postscriptname:'
		    ) includes:key
		) ifTrue:[
		    self perform:('fc_',(key allButLast)) asSymbol
		] ifFalse:[
		    Transcript show:'Xft ignored line: '; showCR:l.
		    self breakPoint:#cg.
		].
	    ].
	    list add:currentDescription
	].

    fcListProg := #('/usr/bin/fc-list' '/usr/X11/bin/fc-list') detect:[:eachProg|
			eachProg asFilename isExecutableProgram
		    ] ifNone:[
			'XftFontDescription [warning]: fc-list program not found - no XFT fonts' errorPrintCR.
			^ list.
		    ].

    pipeStream := PipeStream readingFrom:fcListProg, ' -v'.
    [
	[pipeStream atEnd] whileFalse:[
	    l := pipeStream nextLine.
	    readEntry value.
	]
    ] ensure:[
	pipeStream close
    ].
    ^ list

    "
     FCFontListParser new listOfAvailableFonts
    "
! !

!XftFontDescription::FCFontListParser methodsFor:'font list keywords'!

fc_antialias
    "helper for font listing"

    currentDescription isAntialiasedFont:(self getBoolean).
!

fc_capability
    "helper for font listing"

    "currentDescription capability:" (self getString).
!

fc_charset
    "helper for font listing"

    |page bits l min max minCode maxCode|

    [ l := pipeStream nextLine. l notEmpty ] whileTrue:[
	"/ Transcript show:'->'; showCR:l.
	(l startsWith:Character tab) ifFalse:[
	    (l startsWith:'(') ifFalse:[self halt].
	    currentDescription minCode:minCode.
	    currentDescription maxCode:maxCode.
	    ^ self.
	].

	lineStream := l readStream.
	lineStream skipSeparators.
	page := Integer readFrom:(lineStream upTo:$:) radix:16.
	lineStream next.
	bits := 0 to:7 collect:[:i|
	    lineStream skipSeparators.
	    Integer readFrom:(lineStream upToSeparator) radix:16.
	].
	min := (page * 256 + 0).
	max := (page * 256 + 255).
	minCode isNil ifTrue:[
	    minCode := min.
	    maxCode := max.
	] ifFalse:[
	    minCode := minCode min:min.
	    maxCode := maxCode max:max.
	].
    ].
    "/ currentDescription characterSet:(self getString).
    currentDescription minCode:minCode.
    currentDescription maxCode:maxCode.
!

fc_decorative
    "helper for font listing"

    currentDescription isDecorativeFont:(self getBoolean).
!

fc_family
    "helper for font listing"

    currentDescription family:(self getString).
!

fc_familylang
    "helper for font listing"

    "currentDescription familylang:" (self getString).
!

fc_file
    "helper for font listing"

    currentDescription file:(self getString).
!

fc_fontformat
    "helper for font listing"

    currentDescription fontFormat:(self getString).
!

fc_fontversion
    "helper for font listing"

    currentDescription fontVersion:(self getInteger).
!

fc_foundry
    "helper for font listing"

    currentDescription foundry:(self getString).
!

fc_fullname
    "helper for font listing"

    "currentDescription fullname:" (self getString).
!

fc_fullnamelang
    "helper for font listing"

    "currentDescription fullnamelang:" (self getString).
!

fc_hash
    "helper for font listing"

    "currentDescription hash:" self getString.
!

fc_index
    "helper for font listing"

    "currentDescription index:" (self getInteger).
!

fc_lang
    "helper for font listing"

    "/ currentDescription characterSet:(self getString).
!

fc_outline
    "helper for font listing"

    currentDescription isOutlineFont:(self getBoolean).
!

fc_pixelsize
    "helper for font listing"

    currentDescription setPixelSize:(self getInteger).
    currentDescription setSizeUnit:#px.
    "/ currentDescription setSize:(self getInteger).
    "/ currentDescription setSizeUnit:#pt.
!

fc_postscriptname
    "helper for font listing"

    "currentDescription postscriptname:" self getString.
!

fc_scalable
    "helper for font listing"

    currentDescription isScalableFont:(self getBoolean).
!

fc_slant
    "helper for font listing"

    currentDescription slant:(self getInteger).
!

fc_spacing
    "helper for font listing"

    currentDescription spacing:(self getInteger).
!

fc_style
    "helper for font listing"

    |xftStyle|

    xftStyle := self getString.
"/    ((xftStyle includesString:'Bold') or:[xftStyle includesString:'Fett']) ifTrue:[
"/        currentDescription face:'bold'.
"/        currentDescription style:'roman'.
"/        ^ self.
"/    ].
    ((xftStyle includesString:'Italic') or:[xftStyle includesString:'Oblique']) ifTrue:[
"/        currentDescription face:'medium'.
	currentDescription style:'italic'.
	^ self.
    ].
"/    (xftStyle includesString:'Regular') ifTrue:[
"/        currentDescription face:'regular'.
"/        currentDescription style:'roman'.
"/        ^ self.
"/    ].
"/ self halt.
"/    currentDescription face:'medium'.
    currentDescription style:'roman'.
!

fc_stylelang
    "helper for font listing"

    "currentDescription stylelang:" (self getString).
!

fc_weight
    "helper for font listing"

    currentDescription weight:(self getInteger).
!

fc_width
    "helper for font listing"

    currentDescription width:(self getInteger).
! !

!XftFontDescription::FCFontListParser methodsFor:'helpers'!

getBoolean
    "helper for font listing"

    |s|

    lineStream skipSeparators.
    s := lineStream nextAlphaNumericWord.
    ^ s = 'FcTrue'.
!

getInteger
    "helper for font listing"

    lineStream skipSeparators.
    ^ Integer readFrom:lineStream.
!

getString
    "helper for font listing"

    lineStream skipSeparators.
    lineStream peekFor:$".
    ^ (lineStream upTo:$").
! !

!XftFontDescription class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


XftFontDescription initialize!
