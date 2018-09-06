"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CObject subclass:#Pattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'Cairo::PatternType'
	category:'Cairo-Objects'
!


!Pattern class methodsFor:'instance creation'!

R: r G: g B: b
    "Creates a new pattern (as PatternSolid) corresponding to an opaque color. The color components are 
     floating point numbers in the range 0 to 1. If the values passed in are outside that range, 
     they will be clamped."
    ^ CPrimitives cairo_pattern_create_rgb: r asFloat _: g asFloat _: b asFloat

    "Created: / 04-03-2016 / 09:45:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

R: r G: g B: b A: a
    "Creates a new pattern (as PatternSolid) corresponding to a translucent color. The color components 
     are floating point numbers in the range 0 to 1. If the values passed in are outside that range, 
     they will be clamped."
    ^ CPrimitives cairo_pattern_create_rgba: r asFloat _: g asFloat _: b asFloat _: a asFloat.

    "Created: / 04-03-2016 / 09:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

color: aColor
    "Creates a new pattern (as PatternSolid) corresponding to given color"

    ^ self R: (aColor red / 100)  
           G: (aColor green / 100)  
           B: (aColor blue / 100)  
           A: aColor alpha.

    "Created: / 05-03-2016 / 22:14:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linearFromX:x0 y: y0 toX: x1 y: y1
    "Create a new linear gradient pattern along the line defined by (x0, y0) and 
     (x1, y1). Before using the gradient pattern, a number of color stops 
     should be defined using addColor:stopAt:.    

     Note: The coordinates here are in pattern space. For a new pattern, 
     pattern space is identical to user space, but the relationship 
     between the spaces can be changed with CairoPattern>>#matrix:."

    ^ CPrimitives cairo_pattern_create_linear: x0 asFloat _: y0 asFloat _: x1 asFloat _: y1 asFloat

    "Created: / 15-03-2016 / 20:48:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

radialFromX:cx0 y: cy0 radius: radius0 toX: cx1 y: cy1 radius: radius1
    "Creates a new radial gradient pattern between the two circles defined by 
     (cx0, cy0, radius0) and (cx1, cy1, radius1). Before using the gradient 
     pattern, a number of color stops should be defined using addColor:stopAt:.    

     Note: The coordinates here are in pattern space. For a new pattern, 
     pattern space is identical to user space, but the relationship 
     between the spaces can be changed with CairoPattern>>#matrix:."

    ^ CPrimitives cairo_pattern_create_radial: cx0 asFloat _: cy0 asFloat _: radius0 asFloat _: cx1 asFloat _: cy1 asFloat _: radius1 asFloat

    "Created: / 15-03-2016 / 20:51:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2016 / 22:24:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

surface: surface
    "Creates a new pattern (as PatternSurface) for given surface."

    ^ CPrimitives cairo_pattern_create_for_surface: surface

    "Created: / 05-03-2016 / 22:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Pattern methodsFor:'accessing'!

extend
    "Gets the current extend mode for a pattern. See Cairo::Extend_t for details
     on the semantics of each extend strategy."

    ^ CPrimitives cairo_pattern_get_extend: self

    "Created: / 04-03-2016 / 16:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extend: extend
    "Sets the mode to be used for drawing outside the area of a pattern. 
     See Cairo::Extend for details on the semantics of each extend strategy.

     The default extend mode is CAIRO_EXTEND_NONE for surface patterns and 
     CAIRO_EXTEND_PAD for gradient patterns."

    CPrimitives cairo_pattern_set_extend: self _: extend.

    "Created: / 04-03-2016 / 16:56:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filter
    "Gets the current filter for a pattern. See Cairo::Filter for details on each filter."

    ^ CPrimitives cairo_pattern_get_filter: self

    "Created: / 04-03-2016 / 17:07:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filter: filter
    "Sets the filter to be used for resizing when using this pattern. See 
     Cairo::Filter for details on each filter.

     Note that you might want to control filtering even when you do 
     not have an explicit Cairo::Pattern object, (for example when using 
     Cairo::GraphicsContext>>sourceSurface:). In these cases, it is convenient 
     to use Cairo::GraphicsContext>>source to get access to the pattern that 
     cairo creates implicitly. For example:

         cr sourceSurface: image x: x y: y.
         cr source filter: CAIRO_FILTER_NEAREST.
    "
    CPrimitives cairo_pattern_set_filter: self _: filter

    "Created: / 04-03-2016 / 17:06:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matrix
    "Return the pattern's transformation matrix"
    | matrix |

    matrix := Matrix new.
    CPrimitives cairo_pattern_get_matrix: self _: matrix.
    ^ matrix

    "Created: / 04-03-2016 / 17:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matrix: matrix
    "Sets the pattern's transformation matrix to matrix . This matrix 
     is a transformation from user space to pattern space.

     When a pattern is first created it always has the identity matrix 
     for its transformation matrix, which means that pattern space is 
     initially identical to user space.

     Important: Please note that the direction of this transformation 
     matrix is from user space to pattern space. This means that if you 
     imagine the flow from a pattern to user space (and on to device space), 
     then coordinates in that flow will be transformed by the inverse of 
     the pattern matrix.

     For example, if you want to make a pattern appear twice as large as it 
     does by default the correct code to use is:

         matrix := Cairo::Matrix scale: 0.5 @ 0.5
         pattern matrix: matrix.

     Meanwhile, using values of 2.0 rather than 0.5 in the code above would 
     cause the pattern to appear at half of its default size.

     Also, please note the discussion of the user-space locking semantics 
     of Cairo::GraphicsContext>>source:
    "
    CPrimitives cairo_pattern_set_matrix: self _: matrix.
    self statusCheck

    "Created: / 05-03-2016 / 08:32:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

referenceCount
    "Return value of reference counter"

    ^ CPrimitives cairo_pattern_get_reference_count: self

    "Modified (comment): / 23-02-2016 / 10:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    "Checks whether an error has previously occurred for this object.
     See Cairo::Status pool for possible values."

    ^ CPrimitives cairo_pattern_status: self

    "Modified: / 23-02-2016 / 10:48:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ CPrimitives cairo_pattern_get_type: self.

    "Created: / 04-03-2016 / 00:45:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Pattern methodsFor:'initialization'!

initialize
    super initialize.
    self class == Cairo::Pattern ifTrue:[ 
        | type |

        type := self type.
        type == CAIRO_PATTERN_TYPE_SOLID ifTrue:[ 
            self changeClassTo: PatternSolid.
            ^ self.
        ].
        type == CAIRO_PATTERN_TYPE_SURFACE ifTrue:[ 
            self changeClassTo: PatternSurface.
            ^ self.
        ]. 
        type == CAIRO_PATTERN_TYPE_LINEAR ifTrue:[ 
            self changeClassTo: PatternGradientLinear.
            ^ self.
        ].
        type == CAIRO_PATTERN_TYPE_RADIAL ifTrue:[ 
            self changeClassTo: PatternGradientRadial.
            ^ self.
        ].
    ].

    "Created: / 04-03-2016 / 00:45:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-03-2016 / 08:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Pattern methodsFor:'private'!

destroy
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy,
     this instance should be treated as invalid."

    CPrimitives cairo_pattern_destroy: self

    "Modified: / 04-03-2016 / 00:44:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    "Increases the reference count on the receiver by one. This prevents the
     receiver from being destroyed until a matching call to #destroy is made.
     
     This method must be called whenever Cairo documentation says so,
     check comment on return value for methods returning a Cairo object"

    CPrimitives cairo_pattern_reference: self

    "Modified: / 05-03-2016 / 10:32:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Pattern methodsFor:'testing'!

isSolid
    "return false here; to be redefined in subclass(es)"

    ^ false
! !

!Pattern class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

