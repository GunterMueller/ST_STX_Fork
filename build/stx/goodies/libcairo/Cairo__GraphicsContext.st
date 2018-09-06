"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CObject subclass:#GraphicsContext
	instanceVariableNames:'surface'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!GraphicsContext class methodsFor:'instance creation'!

onSurface: surface
    | instance |

    self
        assert: (surface isKindOf: Cairo::Surface)
        message: 'surface is not valid Cairo surface'.

    instance := CPrimitives cairo_create: surface.
    ^ instance initializeWithSurface: surface

    "Created: / 28-12-2014 / 23:45:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 16:07:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContext methodsFor:'accessing'!

referenceCount
    "Return value or reference counter"

    ^ CPrimitives cairo_get_reference_count: self.

    "Modified: / 13-02-2016 / 16:13:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    ^ CPrimitives cairo_status: self

    "Created: / 18-02-2016 / 20:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

surface
    ^ surface
! !

!GraphicsContext methodsFor:'cairo api - drawing'!

fill
    CPrimitives cairo_fill:self.
    self statusCheck.

    "Created: / 10-07-2008 / 09:42:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 22:01:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:26 / jv"
!

fillAndPreserve
    CPrimitives cairo_fill_preserve:self.
    self statusCheck.

    "Created: / 17-06-2012 / 21:52:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:01:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:30 / jv"
!

mask: pattern
    "A drawing operator that paints the current source using the alpha channel of `pattern` as a mask. 
     (Opaque areas of pattern are painted with the source, transparent areas are not painted.)"

    CPrimitives cairo_mask:self _: pattern.
    self statusCheck.

    "Created: / 07-03-2016 / 22:15:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maskSurface: surf x: x y: y
    "A drawing operator that paints the current source using the alpha channel of `surface` as a mask. 
     (Opaque areas of surface are painted with the source, transparent areas are not painted.)"

    CPrimitives cairo_mask_surface:self _: surf _: x asFloat _: y asFloat.
    self statusCheck.

    "Created: / 07-03-2016 / 22:17:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

paint
    "A drawing operator that paints the current source everywhere within 
     the current clip region."

    CPrimitives cairo_paint:self.
    self statusCheck.

    "Created: / 13-02-2016 / 16:59:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:34 / jv"
!

showPage
    "Makes sense only for PDF surfaces"
    
    CPrimitives cairo_show_page:self.
    self statusCheck.

    "Created: / 17-06-2012 / 08:44:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:02:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:39 / jv"
!

stroke
    CPrimitives cairo_stroke:self.
    self statusCheck.

    "Created: / 10-07-2008 / 09:42:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 22:02:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:44 / jv"
!

strokeAndPreserve
    CPrimitives cairo_stroke_preserve:self.
    self statusCheck.

    "Created: / 17-06-2012 / 21:52:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:15:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:48 / jv"
! !

!GraphicsContext methodsFor:'cairo api - paths'!

antialias
    "Gets the current shape antialiasing mode, as set Cairo::GraphicsContext>#antialias"

    ^ CPrimitives cairo_get_antialias: self

    "Created: / 24-02-2016 / 00:03:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

antialias: antialias
    "Set the antialiasing mode of the rasterizer used for drawing shapes. This 
     value is a hint, and a particular backend may or may not support a particular 
     value. At the current time, no backend supports CAIRO_ANTIALIAS_SUBPIXEL when 
     drawing shapes.

     Note that this option does not affect text rendering, instead 
     see Cairo::FontOptions>>#antialias."


    CPrimitives cairo_set_antialias: self _:antialias.
    self statusCheck.

    "Created: / 24-02-2016 / 00:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

arcNegativeX:x y:y radius:r from:startAngle to:stopAngle 
    CPrimitives 
        cairo_arc_negative:self
        _:x asDouble
        _:y asDouble
        _:r asDouble
        _:startAngle asDouble
        _:stopAngle asDouble.
    self statusCheck.

    "Created: / 07-01-2015 / 02:35:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:17:14 / jv"
!

arcX:x y:y radius:r from:startAngle to:stopAngle 
    CPrimitives 
        cairo_arc:self
        _:x asDouble
        _:y asDouble
        _:r asDouble
        _:startAngle asDouble
        _:stopAngle asDouble.
    self statusCheck.

    "Created: / 17-06-2012 / 21:50:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:00:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:17:24 / jv"
!

closePath
    CPrimitives cairo_close_path:self.
    self statusCheck.

    "Created: / 01-01-2015 / 22:42:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:17:34 / jv"
!

lineCap: lc

    CPrimitives cairo_set_line_cap: self _: lc.
    self statusCheck.

    "Created: / 17-06-2012 / 22:09:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 16:42:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:17:42 / jv"
!

lineToX:x y:y 
    CPrimitives 
        cairo_line_to:self
        _:x asDouble
        _:y asDouble.
    self statusCheck.

    "Created: / 17-06-2012 / 22:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:17:53 / jv"
!

lineWidth
    ^ CPrimitives cairo_get_line_width: self

    "Created: / 28-02-2016 / 16:50:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineWidth: aNumber
    CPrimitives cairo_set_line_width: self _:aNumber asFloat.
    self statusCheck.

    "Created: / 13-02-2016 / 16:45:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:18:04 / jv"
!

moveToX:x y:y 
    CPrimitives 
        cairo_move_to:self
        _:x asDouble
        _:y asDouble.
    self statusCheck.

    "Created: / 23-04-2009 / 17:21:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 22:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:18:12 / jv"
!

rectangleX:x y:y width:w height:h 
    | rx  ry  rw  rh |

    rx := x.
    ry := y.
    rw := w.
    rh := h.
    rw < 0 ifTrue:[
        rx := rx + rw.
        rw := rw abs.
    ].
    rh < 0 ifTrue:[
        ry := ry + rh.
        rh := rh abs.
    ].
    CPrimitives 
        cairo_rectangle:self
        _:rx asDouble
        _:ry asDouble
        _:rw asDouble
        _:rh asDouble.
    self statusCheck.

    "Created: / 10-07-2008 / 09:41:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-01-2015 / 01:21:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:18:25 / jv"
! !

!GraphicsContext methodsFor:'cairo api - save & restore'!

restore
    CPrimitives cairo_restore:self.
    self statusCheck.

    "Created: / 17-06-2012 / 21:51:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 16:14:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:16:13 / jv"
!

save
    CPrimitives cairo_save:self.
    self statusCheck.

    "Created: / 17-06-2012 / 21:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 16:15:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:16:19 / jv"
! !

!GraphicsContext methodsFor:'cairo api - source'!

source
    "Gets the current source pattern for the receiver."

    "/ JV: Should it return Color (TranslucentColor) if the source
    "/ is solid pattern to match with source: which allows a color
    "/ to be passed?

    | p |

    p := CPrimitives cairo_get_source: self.
    p unregisterForFinalization.
    p := p reference.
    ^ p

    "Created: / 05-03-2016 / 10:04:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2016 / 16:22:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source: aCairoPatternOrColor
    "Sets the source pattern (Cairo::Patterm) within receiver to source. This 
     pattern will then be used for any subsequent drawing operation until a 
     new source pattern is set.
     As a courtesy to a Smalltalk programmer, one may pass also a color
     (Color or TranslucentColor) which saves one's work by not having to creare
     a Pattern first.

     Note: The pattern's transformation matrix will be locked to the user space 
     in effect at the time of Cairo::GraphicsContext>>source:. This means that 
     further modifications of the current transformation matrix will not affect 
     the source pattern. See Cairo::Pattern>>matrix:.

     The default source pattern is a solid pattern that is opaque black, (that 
     is, it is equivalent to 

         cr sourceR: 0 G: 0 B: 0.
    "    
    aCairoPatternOrColor isColor ifTrue:[ 
        self  sourceR: (aCairoPatternOrColor red / 100)  
                    G: (aCairoPatternOrColor green / 100)  
                    B: (aCairoPatternOrColor blue / 100)  
                    A: aCairoPatternOrColor alpha.
        ^ self.
    ].
    CPrimitives cairo_set_source: self _: aCairoPatternOrColor.
    self statusCheck

    "Created: / 13-02-2016 / 16:52:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2016 / 08:41:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceR:r G:g B:b
    CPrimitives cairo_set_source_rgb: self 
                                   _: r asDouble
                                   _: g asDouble
                                   _: b asDouble.
    self statusCheck.

    "Created: / 13-02-2016 / 16:55:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:16:01 / jv"
!

sourceR:r G:g B:b A:a
    CPrimitives cairo_set_source_rgba: self 
                                    _: r asDouble
                                    _: g asDouble
                                    _: b asDouble
                                    _: a asDouble.
    self statusCheck.

    "Created: / 13-02-2016 / 16:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:16:05 / jv"
!

sourceSurface: source x: x y: y
    "This is a convenience method for creating a pattern from surface
     and setting it as the source in receiver with Cairo::GraphicsContext>>#source:.

     The x and y parameters give the user-space coordinate at which the surface 
     origin should appear. (The surface origin is its upper-left corner before 
     any transformation has been applied.) The x and y parameters are negated and 
     then set as translation values in the pattern matrix.

     Other than the initial translation pattern matrix, as described above, all other 
     pattern attributes, (such as its extend mode), are set to the default values as 
     in Cairo::Pattern>>surface:. The resulting pattern can be queried with 
     cairo_get_source() so that these attributes can be modified if desired, (eg. to 
     create a repeating pattern with Cairo::Pattern>>extend)."

    CPrimitives cairo_set_source_surface: self _: source _: x asFloat _: y asFloat.
    self statusCheck

    "Created: / 27-02-2016 / 17:01:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2016 / 22:23:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContext methodsFor:'cairo api - text'!

font
    ^ CPrimitives cairo_get_scaled_font: self

    "Created: / 17-02-2016 / 21:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

font: scaledFont
    CPrimitives cairo_set_scaled_font: self _: scaledFont.
    self statusCheck.

    "Created: / 17-02-2016 / 21:01:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:08:25 / jv"
!

font:family slant:slant weight:weight 
    CPrimitives cairo_select_font_face:self _:family asString _:slant asInteger _:weight asInteger.
    self statusCheck.

    "Created: / 29-12-2014 / 01:08:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:13:15 / jv"
!

fontMatrix
    | matrix |

    matrix := Matrix new.
    CPrimitives cairo_get_font_matrix: self _: matrix.
    ^ matrix

    "Created: / 18-02-2016 / 10:09:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fontMatrix: matrix
    "Sets the current font matrix to matrix . The font matrix gives a transformation from 
     the design space of the font (in this space, the em-square is 1 unit by 1 unit) 
     to user space. Normally, a simple scale is used (see #fontSize:), but a more complex 
     font matrix can be used to shear the font or stretch it unequally along the two axes"

    CPrimitives cairo_set_font_matrix: self _: matrix.
    self statusCheck.

    "Created: / 18-02-2016 / 10:11:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:14:09 / jv"
!

fontSize:sz 
    CPrimitives cairo_set_font_size:self _:sz asFloat.
    self statusCheck

    "Created: / 23-04-2009 / 17:24:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-01-2015 / 01:39:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:13:30 / jv"
!

showText:aString 
    CPrimitives cairo_show_text:self _:aString utf8Encoded.
    self statusCheck.

    "Created: / 23-04-2009 / 17:25:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 22:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:13:46 / jv"
!

textExtents:aString
    | extents |

    extents := TextExtents new.
    CPrimitives cairo_text_extents:self _:aString utf8Encoded _: extents.
    self statusCheck.
    ^ extents.

    "Created: / 18-02-2016 / 08:55:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:13:58 / jv"
!

textToPath: aString
    "
    Adds closed paths for text to the current path. The generated path if 
    filled, achieves an effect similar to that of #showText:.

    Text conversion and positioning is done similar to #showText:.

    Like #showText:, after this call the current point is moved to 
    the origin of where the next glyph would be placed in this 
    same progression. That is, the current point will be at the 
    origin of the final glyph offset by its advance values. This 
    allows for chaining multiple calls to to #textToPath: without 
    having to set current point in between.

    Note: The #textToPath:: function call is part of what the cairo 
    designers call the 'toy' text API. It is convenient for short demos 
    and simple programs, but it is not expected to be adequate for 
    serious text-using applications. See #glyphPath: for the 'real' 
    text path API in cairo.
   "
    ^ CPrimitives cairo_text_path: self _: aString utf8Encoded

    "Created: / 22-03-2016 / 16:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContext methodsFor:'cairo api - transformations & clipping'!

clip
    CPrimitives cairo_clip:self.
    self statusCheck.

    "Created: / 17-06-2012 / 21:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:02:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:18 / jv"
!

clipBounds
    "
    Computes a bounding box in user coordinates covering the area inside the current clip.
    "
    | x1 y1 x2 y2 bounds |
    x1 := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    y1 := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    x2 := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    y2 := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.      
    [
        CPrimitives cairo_clip_extents:self _: x1 _: y1 _: x2 _: y2.
        bounds := (x1 doubleAt: 1) @ (y1 doubleAt:1) corner:(x2 doubleAt: 1) @ (y2 doubleAt:1)
    ] ensure:[ 
        x1 free.
        y1 free.
        x2 free.
        y2 free.
    ].
    ^ bounds

    "Created: / 24-03-2016 / 19:39:53 / jv"
!

clipReset
    "
    Reset the current clip region to its original, unrestricted state. That is, 
    set the clip region to an infinitely large shape containing the target surface. 
    Equivalently, if infinity is too hard to grasp, one can imagine the clip region being 
    reset to the exact bounds of the target surface.

    Note that code meant to be reusable should not call cairo_reset_clip() as it 
    will cause results unexpected by higher-level code which calls cairo_clip(). Consider 
    using cairo_save() and cairo_restore() around cairo_clip() as a more robust means of 
    temporarily restricting the clip region."
    CPrimitives cairo_reset_clip: self.

    "Created: / 24-03-2016 / 19:42:44 / jv"
!

matrix
    "Return the context's current transformation matrix (CTM)"
    | matrix |

    matrix := Matrix new.
    CPrimitives cairo_get_matrix: self _: matrix.
    ^ matrix

    "Created: / 04-03-2016 / 17:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matrix: matrix
    "Modifies the current transformation matrix (CTM) by setting it equal to `matrix`"

    CPrimitives cairo_set_matrix: self _: matrix.
    self statusCheck

    "Created: / 13-02-2016 / 19:51:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2016 / 08:37:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matrixReset
    "Resets the current transformation matrix (CTM) by setting it equal to the 
     identity matrix. That is, the user-space and device-space axes will be 
     aligned and one user-space unit will transform to one device-space unit."
    CPrimitives cairo_identity_matrix: self.
    self statusCheck.

    "Created: / 13-02-2016 / 19:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:09 / jv"
!

rotate: aNumber
    "Modifies the current transformation matrix (CTM) by rotating the 
     user-space axes by angle radians. The rotation of the axes takes 
     places after any existing transformation of user space. The 
     rotation direction for positive angles is from the positive X 
     axis toward the positive Y axis."

    CPrimitives cairo_rotate: self _: aNumber asFloat.
    self statusCheck.

    "Created: / 22-03-2016 / 17:07:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scale: aNumberOrPoint
    | sx sy |
    aNumberOrPoint isPoint ifTrue:[ 
        sx := aNumberOrPoint x asFloat.
        sy := aNumberOrPoint y asFloat.
    ] ifFalse:[ 
        sx := sy := aNumberOrPoint asFloat.
    ].
    CPrimitives cairo_scale: self _: sx _: sy.
    self statusCheck.

    "Created: / 13-02-2016 / 16:40:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:05 / jv"
!

translate: aNumberOrPoint
    | tx ty |
    aNumberOrPoint isPoint ifTrue:[ 
        tx := aNumberOrPoint x asFloat.
        ty := aNumberOrPoint y asFloat.
    ] ifFalse:[ 
        tx := ty := aNumberOrPoint asFloat.
    ].
    CPrimitives cairo_translate: self _: tx _: ty.
    self statusCheck.

    "Created: / 13-02-2016 / 16:40:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:15:00 / jv"
! !

!GraphicsContext methodsFor:'initialization & release'!

initializeWithSurface: aSurface
    surface := aSurface.

    "Created: / 13-02-2016 / 16:08:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:30:05 / jv"
    "Modified: / 23-02-2016 / 10:54:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContext methodsFor:'private'!

destroy
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy,
     this instance should be treated as invalid."

    surface := nil.
    CPrimitives cairo_destroy: self.
    self setAddress: nil.

    "Modified: / 13-02-2016 / 16:13:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    "Increases the reference count on the receiver by one. This prevents the
     receiver from being destroyed until a matching call to #destroy is made.
     
     This method must be called whenever Cairo documentation says so,
     check comment on return value for methods returning a Cairo object"

    CPrimitives cairo_reference: self

    "Modified: / 05-03-2016 / 10:32:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

