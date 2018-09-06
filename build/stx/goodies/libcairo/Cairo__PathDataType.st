"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#PathDataType
	instanceVariableNames:''
	classVariableNames:'CAIRO_PATH_MOVE_TO CAIRO_PATH_LINE_TO CAIRO_PATH_CURVE_TO
		CAIRO_PATH_CLOSE_PATH'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!PathDataType class methodsFor:'initialization'!

initialize

    CAIRO_PATH_MOVE_TO := 0.
    CAIRO_PATH_LINE_TO := 1.
    CAIRO_PATH_CURVE_TO := 2.
    CAIRO_PATH_CLOSE_PATH := 3.
! !

!PathDataType class methodsFor:'constants'!

CAIRO_PATH_CLOSE_PATH

    ^CAIRO_PATH_CLOSE_PATH
!

CAIRO_PATH_CURVE_TO

    ^CAIRO_PATH_CURVE_TO
!

CAIRO_PATH_LINE_TO

    ^CAIRO_PATH_LINE_TO
!

CAIRO_PATH_MOVE_TO

    ^CAIRO_PATH_MOVE_TO
! !

!PathDataType class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


PathDataType initialize!
