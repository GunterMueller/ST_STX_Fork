"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#HintStyle
	instanceVariableNames:''
	classVariableNames:'CAIRO_HINT_STYLE_DEFAULT CAIRO_HINT_STYLE_NONE
		CAIRO_HINT_STYLE_SLIGHT CAIRO_HINT_STYLE_MEDIUM
		CAIRO_HINT_STYLE_FULL'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!HintStyle class methodsFor:'initialization'!

initialize

    CAIRO_HINT_STYLE_DEFAULT := 0.
    CAIRO_HINT_STYLE_NONE := 1.
    CAIRO_HINT_STYLE_SLIGHT := 2.
    CAIRO_HINT_STYLE_MEDIUM := 3.
    CAIRO_HINT_STYLE_FULL := 4.
! !

!HintStyle class methodsFor:'constants'!

CAIRO_HINT_STYLE_DEFAULT

    ^CAIRO_HINT_STYLE_DEFAULT
!

CAIRO_HINT_STYLE_FULL

    ^CAIRO_HINT_STYLE_FULL
!

CAIRO_HINT_STYLE_MEDIUM

    ^CAIRO_HINT_STYLE_MEDIUM
!

CAIRO_HINT_STYLE_NONE

    ^CAIRO_HINT_STYLE_NONE
!

CAIRO_HINT_STYLE_SLIGHT

    ^CAIRO_HINT_STYLE_SLIGHT
! !


HintStyle initialize!
