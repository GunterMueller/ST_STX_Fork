"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#FontWeight
	instanceVariableNames:''
	classVariableNames:'CAIRO_FONT_WEIGHT_NORMAL CAIRO_FONT_WEIGHT_BOLD
		SymbolicFontFaceToCairoFontWeightMap'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!FontWeight class methodsFor:'initialization'!

initialize

    CAIRO_FONT_WEIGHT_NORMAL := 0.
    CAIRO_FONT_WEIGHT_BOLD := 1.

    SymbolicFontFaceToCairoFontWeightMap := Dictionary new.
    SymbolicFontFaceToCairoFontWeightMap at: 'normal' put: CAIRO_FONT_WEIGHT_NORMAL.
    SymbolicFontFaceToCairoFontWeightMap at: 'regular' put: CAIRO_FONT_WEIGHT_NORMAL.
    SymbolicFontFaceToCairoFontWeightMap at: 'medium' put: CAIRO_FONT_WEIGHT_NORMAL.
    SymbolicFontFaceToCairoFontWeightMap at: 'bolf' put: CAIRO_FONT_WEIGHT_BOLD

    "Modified: / 09-01-2015 / 15:23:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontWeight class methodsFor:'constants'!

CAIRO_FONT_WEIGHT_BOLD

    ^CAIRO_FONT_WEIGHT_BOLD
!

CAIRO_FONT_WEIGHT_NORMAL

    ^CAIRO_FONT_WEIGHT_NORMAL
! !


FontWeight initialize!
