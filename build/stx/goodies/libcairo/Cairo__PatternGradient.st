"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

Pattern subclass:#PatternGradient
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'Cairo::Status'
	category:'Cairo-Objects'
!

!PatternGradient methodsFor:'accessing'!

colorStopAtIndex: index
    "Gets the color and offset information at the given index for a gradient pattern. Values 
     of index range from 1 to n where n is the number returned by #colorStopCount."

    | offsetCellPtr rCellPtr gCellPtr  bCellPtr aCellPtr status offset r g b a color |

    offsetCellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    rCellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    gCellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    bCellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    aCellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.         
    [
        status := CPrimitives cairo_pattern_get_color_stop_rgba: self _: index - 1 _: offsetCellPtr _: rCellPtr _: gCellPtr _: bCellPtr _: aCellPtr.
        offset := offsetCellPtr doubleAt: 1.
        r := rCellPtr doubleAt: 1.
        g := gCellPtr doubleAt: 1.
        b := bCellPtr doubleAt: 1.
        a := aCellPtr doubleAt: 1.
    ] ensure:[ 
        offsetCellPtr free.
    ].
    status == CAIRO_STATUS_INVALID_INDEX ifTrue:[ 
        self indexNotIntegerOrOutOfBounds: index
    ] ifFalse:[
        self statusCheck.
    ].
    a = 1.0 ifTrue:[ 
            color := Color  scaledRed: (r * 16rFFFF) rounded scaledGreen: (g * 16rFFFF) rounded scaledBlue: (b * 16rFFFF) rounded
        ] ifFalse:[ 
            color := TranslucentColor scaledRed: (r * 16rFFFF) rounded scaledGreen: (g * 16rFFFF) rounded scaledBlue: (b * 16rFFFF) rounded.
            color alpha: a
        ].  
    ^ offset -> color

    "Created: / 09-03-2016 / 09:04:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2016 / 21:30:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorStopCount
    "Gets the number of color stops specified in the given gradient pattern."

    | countCellPtr count |

    countCellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofInt.
    [
        CPrimitives cairo_pattern_get_color_stop_count: self _: countCellPtr.
        count := countCellPtr longAt: 1.
    ] ensure:[ 
        countCellPtr free.
    ].
    ^ count

    "Created: / 09-03-2016 / 09:02:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PatternGradient methodsFor:'adding'!

addColor: color stopAt: offset 
    "Adds a `color` (as Color or TranslucentColor) stop to a gradient pattern.  The `offset` specifies 
     the location along the gradient's control vector. For example, a linear gradient's 
     control vector is from (x0,y0) to (x1,y1) while a radial gradient's control 
     vector is from any point on the start circle to the corresponding point on the 
     end circle.

     The color is specified in the same way as in Cairo::GraphicsContext>>source: if passed
     argument is a Color (or TranslucentColor)

     If two (or more) stops are specified with identical offset values, they will be sorted 
     according to the order in which the stops are added, (stops added earlier will compare 
     less than stops added later). This can be useful for reliably making sharp color 
     transitions instead of the typical blend."

    self addColorR: (color red / 100) G: (color green / 100) B: (color blue / 100) A: color alpha  stopAt: offset

    "Created: / 09-03-2016 / 08:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addColorR: r G: g B: b A: a stopAt: offset 
    "Adds a translucent color stop to a gradient pattern. The `offset` specifies 
     the location along the gradient's control vector. For example, a linear gradient's 
     control vector is from (x0,y0) to (x1,y1) while a radial gradient's control 
     vector is from any point on the start circle to the corresponding point on the 
     end circle.

     The color is specified in the same way as in Cairo::GraphicsContext>>sourceR:G:B:A:.

     If two (or more) stops are specified with identical offset values, they will be sorted 
     according to the order in which the stops are added, (stops added earlier will compare 
     less than stops added later). This can be useful for reliably making sharp color 
     transitions instead of the typical blend."

    CPrimitives cairo_pattern_add_color_stop_rgba: self 
                                                _: offset asFloat 
                                                _: r asFloat _: g asFloat _: b asFloat _: a asFloat.
    self statusCheck.

    "Created: / 09-03-2016 / 08:56:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addColorR: r G: g B: b stopAt: offset
    "Adds an opaque color stop to a gradient pattern. The `offset` specifies 
     the location along the gradient's control vector. For example, a linear gradient's 
     control vector is from (x0,y0) to (x1,y1) while a radial gradient's control 
     vector is from any point on the start circle to the corresponding point on the 
     end circle.

     The color is specified in the same way as in Cairo::GraphicsContext>>sourceR:G:B:.

     If two (or more) stops are specified with identical offset values, they will be sorted 
     according to the order in which the stops are added, (stops added earlier will compare 
     less than stops added later). This can be useful for reliably making sharp color 
     transitions instead of the typical blend."

    CPrimitives cairo_pattern_add_color_stop_rgb: self 
                                               _: offset asFloat 
                                               _: r asFloat _: g asFloat _: b asFloat.
    self statusCheck.

    "Created: / 09-03-2016 / 08:56:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

