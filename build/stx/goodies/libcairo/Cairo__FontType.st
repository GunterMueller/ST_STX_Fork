"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#FontType
	instanceVariableNames:''
	classVariableNames:'CAIRO_FONT_TYPE_TOY CAIRO_FONT_TYPE_FT CAIRO_FONT_TYPE_WIN32
		CAIRO_FONT_TYPE_QUARTZ CAIRO_FONT_TYPE_USER'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!FontType class methodsFor:'initialization'!

initialize

    CAIRO_FONT_TYPE_TOY := 0.
    CAIRO_FONT_TYPE_FT := 1.
    CAIRO_FONT_TYPE_WIN32 := 2.
    CAIRO_FONT_TYPE_QUARTZ := 3.
    CAIRO_FONT_TYPE_USER := 4.
! !

!FontType class methodsFor:'constants'!

CAIRO_FONT_TYPE_FT

    ^CAIRO_FONT_TYPE_FT
!

CAIRO_FONT_TYPE_QUARTZ

    ^CAIRO_FONT_TYPE_QUARTZ
!

CAIRO_FONT_TYPE_TOY

    ^CAIRO_FONT_TYPE_TOY
!

CAIRO_FONT_TYPE_USER

    ^CAIRO_FONT_TYPE_USER
!

CAIRO_FONT_TYPE_WIN32

    ^CAIRO_FONT_TYPE_WIN32
! !

!FontType class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


FontType initialize!
