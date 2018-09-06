"
 COPYRIGHT (c) 2016 Jan Vrany
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

ExternalAddress subclass:#FcPattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'FcConstants'
	category:'Graphics-Support-FontConfig'
!

!FcPattern primitiveDefinitions!
%{
#ifdef HAVE_FONTCONFIG
/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */
#undef FcPattern
#undef True
#undef False
#undef Time

#include <stdlib.h>
#include <fontconfig/fontconfig.h>

#define FC_PATTERN_VAL(x) ((FcPattern*)__externalAddressVal(x))
#endif
%}
! !

!FcPattern class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 Jan Vrany
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
    See https://www.freedesktop.org/software/fontconfig/fontconfig-devel/x19.html

    FONT PROPERTIES

    While font patterns may contain essentially any properties, there are some 
    well known properties with associated types. Fontconfig uses some of these 
    properties for font matching and font completion. Others are provided as a 
    convenience for the application's rendering mechanism.

    Property       C Preprocessor Symbol  Type    Description
    ----------------------------------------------------
    family         FC_FAMILY              String  Font family names
    familylang     FC_FAMILYLANG          String  Language corresponding to
                                                  each family name
    style          FC_STYLE               String  Font style. Overrides weight
                                                  and slant
    stylelang      FC_STYLELANG           String  Language corresponding to
                                                  each style name
    fullname       FC_FULLNAME            String  Font face full name where
                                                  different from family and
                                                  family + style
    fullnamelang   FC_FULLNAMELANG        String  Language corresponding to
                                                  each fullname
    slant          FC_SLANT               Int     Italic, oblique or roman
    weight         FC_WEIGHT              Int     Light, medium, demibold,
                                                  bold or black
    size           FC_SIZE                Double  Point size
    width          FC_WIDTH               Int     Condensed, normal or expanded
    aspect         FC_ASPECT              Double  Stretches glyphs horizontally
                                                  before hinting
    pixelsize      FC_PIXEL_SIZE          Double  Pixel size
    spacing        FC_SPACING             Int     Proportional, dual-width,
                                                  monospace or charcell
    foundry        FC_FOUNDRY             String  Font foundry name
    antialias      FC_ANTIALIAS           Bool    Whether glyphs can be
                                                  antialiased
    hinting        FC_HINTING             Bool    Whether the rasterizer should
                                                  use hinting
    hintstyle      FC_HINT_STYLE          Int     Automatic hinting style
    verticallayout FC_VERTICAL_LAYOUT     Bool    Use vertical layout
    autohint       FC_AUTOHINT            Bool    Use autohinter instead of
                                                  normal hinter
    globaladvance  FC_GLOBAL_ADVANCE      Bool    Use font global advance data (deprecated)
    file           FC_FILE                String  The filename holding the font
    index          FC_INDEX               Int     The index of the font within
                                                  the file
    ftface         FC_FT_FACE             FT_Face Use the specified FreeType
                                                  face object
    rasterizer     FC_RASTERIZER          String  Which rasterizer is in use (deprecated)
    outline        FC_OUTLINE             Bool    Whether the glyphs are outlines
    scalable       FC_SCALABLE            Bool    Whether glyphs can be scaled
    scale          FC_SCALE               Double  Scale factor for point->pixel
                                                  conversions (deprecated)
    symbol         FC_SYMBOL              Bool    Whether font uses MS symbol-font encoding
    color          FC_COLOR               Bool    Whether any glyphs have color
    dpi            FC_DPI                 Double  Target dots per inch
    rgba           FC_RGBA                Int     unknown, rgb, bgr, vrgb,
                                                  vbgr, none - subpixel geometry
    lcdfilter      FC_LCD_FILTER          Int     Type of LCD filter
    minspace       FC_MINSPACE            Bool    Eliminate leading from line
                                                  spacing
    charset        FC_CHARSET             CharSet Unicode chars encoded by
                                                  the font
    lang           FC_LANG                LangSet Set of RFC-3066-style
                                                  languages this font supports
    fontversion    FC_FONTVERSION         Int     Version number of the font
    capability     FC_CAPABILITY          String  List of layout capabilities in
                                                  the font
    fontformat     FC_FONTFORMAT          String  String name of the font format
    embolden       FC_EMBOLDEN            Bool    Rasterizer should
                                                  synthetically embolden the font
    embeddedbitmap FC_EMBEDDED_BITMAP     Bool    Use the embedded bitmap instead
                                                  of the outline
    decorative     FC_DECORATIVE          Bool    Whether the style is a decorative
                                                  variant
    fontfeatures   FC_FONT_FEATURES       String  List of extra feature tags in
                                                  OpenType to be enabled
    namelang       FC_NAMELANG            String  Language name to be used for the
                                                  default value of familylang,
                                                  stylelang and fullnamelang
    prgname        FC_PRGNAME             String  Name of the running program
    hash           FC_HASH                String  SHA256 hash value of the font data
                                                  with 'sha256:' prefix (deprecated)
    postscriptname FC_POSTSCRIPT_NAME     String  Font name in PostScript

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!FcPattern class methodsFor:'initialization'!

initialize
    
    "Created: / 17-02-2016 / 17:18:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern class methodsFor:'instance creation'!

fromFontDescription: aFontDescription
    | family size psize weight slant pattern |

    family := aFontDescription family.
    size := aFontDescription size.
    psize := aFontDescription pixelSize.
    weight := (StXFace2FCWeightMap at: (aFontDescription face ? 'regular')).
    slant := (StXStyle2FCSlantMap at: (aFontDescription style ? 'roman') ifAbsent:[StXStyle2FCSlantMap at: (aFontDescription style ? 'roman') asLowercase]).
    pattern := self new.
    pattern at: FC_FAMILY  put: family.
    psize notNil ifTrue:[
       pattern at: FC_PIXEL_SIZE put: psize.
   ] ifFalse:[
       pattern at: FC_SIZE put: size.
   ].
   pattern at: FC_WEIGHT put: weight.
   pattern at: FC_SLANT put: slant.
 
    ^ pattern

    "
    FcPattern fromFontDescription: SimpleView defaultFont
    FcPattern fromFontDescription: CodeView defaultFont

    "

    "Created: / 17-02-2016 / 17:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromString: aString
    ^self basicNew initializeFromString: aString

!

new
    ^self basicNew initialize

! !

!FcPattern methodsFor:'accessing'!

at: attribute
    "Return  a value of the specified pattern element. If there are multiple values,
     return them as an OrderedCollection. Throw an error if `attribute` does not exist"

    ^ self at: attribute ifAbsent:[ self errorKeyNotFound: attribute ]

    "Created: / 17-02-2016 / 14:33:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: attribute add: value
    "Add a value to the specified pattern element. Value is added after existing values"

    ^ self at: attribute add: value append: true

    "Created: / 17-02-2016 / 14:23:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: attribute add: value append: append
    "Add a value to the specified pattern element.  If 'append' is true, the value
     is added after existing values, otherwise it is added before them."

    | error |

%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    FcValue v;
    FcBool b;

    if ( ! __externalAddressVal ( self ) ) {
	error = @symbol(Released);
	goto err;
    }
    if ( ! __isStringLike ( attribute ) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    if ( append != true && append != false ) {
	error = @symbol(BadArg3);
	goto err;
    }
    if ( __isStringLike ( value ) ) {
	v.type = FcTypeString;
	/* Passing pointer inside Smalltalk should be safe,
	 * FontConfig library seem to allocate and store
	 * a __copy__ of the string (if I understood the code correctly)
	 */
	v.u.s = __stringVal( value);
    } else if ( __isSmallInteger( value ) ) {
	v.type = FcTypeInteger;
	v.u.i = (int)__intVal( value );
    } else if ( value == true || value == false ) {
	v.type = FcTypeBool;
	v.u.b = value == true ? FcTrue : FcFalse;
    } else if ( __isFloat ( value ) ) {
	v.type = FcTypeDouble;
	v.u.d = __floatVal( value );
    } else if ( value == nil ) {
	v.type = FcTypeVoid;
	v.u.f = NULL;
    } else {
	error = @symbol(BadArg2);
	goto err;
    }
    b = FcPatternAdd( FC_PATTERN_VAL(self), __stringVal(attribute), v, append == true ? FcTrue : FcFalse );
    RETURN ( b == FcTrue ? true : false );

    err:;
#endif
%}.
    self primitiveFailed: error

    "Created: / 20-12-2013 / 21:50:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: attribute ifAbsent: block
    "Return  a value of the specified pattern element. If there are multiple values,
     return them as an OrderedCollection. If attribute does not exist, evaluate `block`"

    | value values |

    value := self at: attribute index: 1.
    value isNil ifTrue:[ ^ block value ].
    values := value.
    value := self at: attribute index: 2.
    value notNil ifTrue:[ 
        | i |    

        values := Array with: values with: value.
        i := 3.
        [ (value := self at: attribute index: i) notNil ] whileTrue:[ 
            values := values copyWith: value.
            i := i + 1.
        ].
    ].
    ^ values

    "Created: / 17-02-2016 / 14:32:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: attribute index: index
    "Return a value from the specified element -- multiple values can be indexed
     with 'index' starting at one."

    | error |

%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    FcValue v;
    FcResult r;

    if ( ! __externalAddressVal ( self ) ) {
	error = @symbol(Released);
	goto err;
    }
    if ( ! __isStringLike ( attribute ) ) {
	error = @symbol(BadArg2);
	goto err;
    }
    if ( ! __isSmallInteger( index ) ) {
	error = @symbol(BadArg3);
	goto err;
    }
    r = FcPatternGet(FC_PATTERN_VAL(self), __stringVal( attribute ), __intVal( index ) - 1, &v);
    if ( r != FcResultMatch) {
	RETURN ( nil );
    }
    if ( v.type == FcTypeString) {
	RETURN ( __MKSTRING(v.u.s) );
    } else if ( v.type == FcTypeInteger ) {
	RETURN ( __MKINT (v.u.i) );
    } else if ( v.type == FcTypeBool ) {
	RETURN ( v.u.b == FcTrue ? true : false );
    } else if ( v.type == FcTypeDouble ) {
	RETURN ( __MKFLOAT (v.u.d) );
    } else if ( v.type == FcTypeVoid ) {
	RETURN ( nil );
    } else {
	error = @symbol(UnssuportedTypeValue);
	goto err;
    }
    err:;
#endif
%}.
    self primitiveFailed: error

!

at: attribute put: value
    "Add a value to the specified pattern element. All existing values are removed. 
     If `value` is a collection, all elements of that collection are added"

    self removeKey: attribute.
    (value isCollection and:[ value isString not ]) ifTrue:[ 
        value do:[:each | 
            self at: attribute add: value append: true.
        ].
    ] ifFalse:[ 
        self at: attribute add: value append: true.
    ].
    ^ value

    "Created: / 17-02-2016 / 14:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeKey: attribute
    | error |
%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    if ( ! __externalAddressVal ( self ) ) {
	error = @symbol(Released);
	goto err;
    }
    if ( ! __isStringLike ( attribute ) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    FcPatternDel( FC_PATTERN_VAL(self), __stringVal ( attribute ) );
    RETURN ( self );
    err:;
#endif
%}.
    self primitiveFailed: error

! !

!FcPattern methodsFor:'comparing'!

= another
    self class == another class ifFalse:[ ^ false ].
%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    FcPattern* pa = FC_PATTERN_VAL(self);
    FcPattern* pb = FC_PATTERN_VAL(another);
    if (pa != NULL && pb != NULL) {
    	RETURN ( FcPatternEqual(pa, pb) == FcTrue ? true : false );
    }
#endif
%}.
    ^ false

    "Created: / 17-02-2016 / 11:01:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    unsigned int h = 0;
    if (__externalAddressVal(self) != NULL) {
        h = FcPatternHash(FC_PATTERN_VAL(self));
        h &= 0x7FFFFFFFU;
    }
    RETURN ( __MKSMALLINT( h ) );	
#endif
%}.    
    ^self primitiveFailed

    "Created: / 17-02-2016 / 10:59:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern methodsFor:'conversion'!

asString
%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    char *_s;
    OBJ s;
    if (__externalAddressVal(self) != NULL) {
    	_s = (char*)FcNameUnparse(FC_PATTERN_VAL(self));
    	s = __MKSTRING(_s);
    	free(_s);
    	RETURN ( s );
    }   
#endif
%}.
    self primitiveFailed

    "Created: / 17-02-2016 / 10:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern methodsFor:'copying'!

postCopy
%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    __externalAddressVal(self) = (void*)FcPatternDuplicate(FC_PATTERN_VAL(self));	
#endif
%}.
    self registerForFinalization

    "Created: / 17-02-2016 / 10:58:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern methodsFor:'error handling'!

primitiveFailed
    <resource: #skipInDebuggersWalkBack>

    (ConfigurableFeatures hasFontConfig) ifFalse:[ 
        super primitiveFailed: 'FontConfig support not compiled in. Recompile with -DHAVE_FONTCONFIG'.        
    ].
    ^ super primitiveFailed

    "Created: / 22-02-2016 / 08:12:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primitiveFailed: message
    <resource: #skipInDebuggersWalkBack>

    (ConfigurableFeatures hasFontConfig) ifFalse:[ 
        super primitiveFailed: 'FontConfig support not compiled in. Recompile with -DHAVE_FONTCONFIG'.        
    ].
    ^ super primitiveFailed: message

    "Created: / 22-02-2016 / 08:13:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern methodsFor:'finalization'!

destroy
    %{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    FcPatternDestroy((FcPattern*)__externalAddressVal(self));
    __externalAddressVal(self) = NULL;
    RETURN ( self );
    #endif
%}.
    self primitiveFailed.
!

finalize
    self destroy

    "Created: / 16-02-2016 / 19:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern methodsFor:'initialization & release'!

initialize    
%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    __externalAddressVal(self) = (void*)FcPatternCreate();
    __SSEND0(self, @symbol(registerForFinalization), 4);
    RETURN ( self );
    err:;

#endif
%}.
    self primitiveFailed.

    "Created: / 16-02-2016 / 19:04:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

initializeFromString: aString
    | error |
%{ /* STACK: 64000 */
#ifdef HAVE_FONTCONFIG
    if ( ! __isStringLike ( aString ) ) {
	error = @symbol(BadArg1);
	goto err;
    }
    __externalAddressVal(self) = (void*)FcNameParse(__stringVal(aString));
    __SSEND0(self, @symbol(registerForFinalization), 4);
    RETURN ( self );
    err:;
#endif
%}.
    self primitiveFailed.

!

release
    self unregisterForFinalization.
    self destroy

    "Created: / 16-02-2016 / 19:04:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern methodsFor:'printing & storing'!

printOn:aStream
    | string |
    super printOn: aStream.
    string := self asString.
    string notEmptyOrNil ifTrue:[
        aStream nextPutAll: ' - '.
        aStream nextPutAll: self asString  
    ]

    "Modified: / 17-02-2016 / 17:29:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPattern class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


FcPattern initialize!
