"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#FontSlant
	instanceVariableNames:''
	classVariableNames:'CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_SLANT_ITALIC
		CAIRO_FONT_SLANT_OBLIQUE SymbolicFontSlantToCairoFontSlantMap'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!FontSlant class methodsFor:'initialization'!

initialize

    CAIRO_FONT_SLANT_NORMAL := 0.
    CAIRO_FONT_SLANT_ITALIC := 1.
    CAIRO_FONT_SLANT_OBLIQUE := 2.

    SymbolicFontSlantToCairoFontSlantMap := Dictionary new.
    SymbolicFontSlantToCairoFontSlantMap at: 'roman' put: CAIRO_FONT_SLANT_NORMAL.
    SymbolicFontSlantToCairoFontSlantMap at: 'normal' put: CAIRO_FONT_SLANT_NORMAL.
    SymbolicFontSlantToCairoFontSlantMap at: 'italic' put: CAIRO_FONT_SLANT_ITALIC.
    SymbolicFontSlantToCairoFontSlantMap at: 'obligue' put: CAIRO_FONT_SLANT_OBLIQUE.

    "Modified: / 09-01-2015 / 15:12:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontSlant class methodsFor:'constants'!

CAIRO_FONT_SLANT_ITALIC

    ^CAIRO_FONT_SLANT_ITALIC
!

CAIRO_FONT_SLANT_NORMAL

    ^CAIRO_FONT_SLANT_NORMAL
!

CAIRO_FONT_SLANT_OBLIQUE

    ^CAIRO_FONT_SLANT_OBLIQUE
! !

!FontSlant class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


FontSlant initialize!
