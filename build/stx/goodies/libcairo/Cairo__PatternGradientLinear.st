"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

PatternGradient subclass:#PatternGradientLinear
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!

!PatternGradientLinear methodsFor:'accessing'!

points
    "Gets the gradient endpoints."

    | x0CellPtr y0CellPtr x1CellPtr y1CellPtr points |

    x0CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    y0CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    x1CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    y1CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    [ 
        CPrimitives cairo_pattern_get_linear_points: self _: x0CellPtr _: y0CellPtr _: x1CellPtr _: y1CellPtr.
        points := Array with: (x0CellPtr doubleAt:1) @ (y0CellPtr doubleAt:1) 
                        with: (x1CellPtr doubleAt:1) @ (y1CellPtr doubleAt:1) 
    ] ensure:[ 
        x0CellPtr free.
        y0CellPtr free.
        x1CellPtr free.
        y1CellPtr free.
    ].
    ^ points

    "Created: / 15-03-2016 / 21:35:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

