"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

PatternGradient subclass:#PatternGradientRadial
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!

!PatternGradientRadial methodsFor:'accessing'!

circles
    "Gets the gradient circles."

    | cx0CellPtr cy0CellPtr radius0CellPtr cx1CellPtr cy1CellPtr radius1CellPtr circles |

    cx0CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    cy0CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    radius0CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    cx1CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    cy1CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    radius1CellPtr := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    [ 
        CPrimitives cairo_pattern_get_radial_circles: self _: cx0CellPtr _: cy0CellPtr _: radius0CellPtr _: cx1CellPtr _: cy1CellPtr _: radius1CellPtr.
        circles := Array with: (cx0CellPtr doubleAt:1) @ (cy0CellPtr doubleAt:1) 
                         with: (radius0CellPtr doubleAt:1)
                         with: (cx1CellPtr doubleAt:1) @ (cy1CellPtr doubleAt:1) 
                         with: (radius1CellPtr doubleAt:1)
    ] ensure:[ 
        cx0CellPtr free.
        cy0CellPtr free.
        radius0CellPtr free.
        cx1CellPtr free.
        cy1CellPtr free.
        radius1CellPtr free.
    ].
    ^ circles

    "Created: / 15-03-2016 / 21:37:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

