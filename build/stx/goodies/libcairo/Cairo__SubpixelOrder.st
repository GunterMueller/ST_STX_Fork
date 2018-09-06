"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#SubpixelOrder
	instanceVariableNames:''
	classVariableNames:'CAIRO_SUBPIXEL_ORDER_DEFAULT CAIRO_SUBPIXEL_ORDER_RGB
		CAIRO_SUBPIXEL_ORDER_BGR CAIRO_SUBPIXEL_ORDER_VRGB
		CAIRO_SUBPIXEL_ORDER_VBGR'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!SubpixelOrder class methodsFor:'initialization'!

initialize

    CAIRO_SUBPIXEL_ORDER_DEFAULT := 0.
    CAIRO_SUBPIXEL_ORDER_RGB := 1.
    CAIRO_SUBPIXEL_ORDER_BGR := 2.
    CAIRO_SUBPIXEL_ORDER_VRGB := 3.
    CAIRO_SUBPIXEL_ORDER_VBGR := 4.
! !

!SubpixelOrder class methodsFor:'constants'!

CAIRO_SUBPIXEL_ORDER_BGR

    ^CAIRO_SUBPIXEL_ORDER_BGR
!

CAIRO_SUBPIXEL_ORDER_DEFAULT

    ^CAIRO_SUBPIXEL_ORDER_DEFAULT
!

CAIRO_SUBPIXEL_ORDER_RGB

    ^CAIRO_SUBPIXEL_ORDER_RGB
!

CAIRO_SUBPIXEL_ORDER_VBGR

    ^CAIRO_SUBPIXEL_ORDER_VBGR
!

CAIRO_SUBPIXEL_ORDER_VRGB

    ^CAIRO_SUBPIXEL_ORDER_VRGB
! !


SubpixelOrder initialize!
