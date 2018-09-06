"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#Filter
	instanceVariableNames:''
	classVariableNames:'CAIRO_FILTER_FAST CAIRO_FILTER_GOOD CAIRO_FILTER_BEST
		CAIRO_FILTER_NEAREST CAIRO_FILTER_BILINEAR CAIRO_FILTER_GAUSSIAN'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!Filter class methodsFor:'documentation'!

documentation
"
    Cairo::Filter is used to indicate what filtering should be 
    applied when reading pixel values from patterns. 
    See Cairo::Pattern>>filter: for indicating the desired 
    filter to be used with a particular pattern.

    Members

    CAIRO_FILTER_FAST   A high-performance filter, with quality 
                        similar to CAIRO_FILTER_NEAREST (Since 1.0)

    CAIRO_FILTER_GOOD   A reasonable-performance filter, with quality 
                        similar to CAIRO_FILTER_BILINEAR (Since 1.0)

    CAIRO_FILTER_BEST   The highest-quality available, performance may not 
                        be suitable for interactive use. (Since 1.0)

    CAIRO_FILTER_NEAREST Nearest-neighbor filtering (Since 1.0)

    CAIRO_FILTER_BILINEAR Linear interpolation in two dimensions 
                        (Since 1.0)

    CAIRO_FILTER_GAUSSIAN This filter value is currently unimplemented, and 
                        should not be used in current code. (Since 1.0)

    Since 1.0

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Filter class methodsFor:'initialization'!

initialize

    CAIRO_FILTER_FAST := 0.
    CAIRO_FILTER_GOOD := 1.
    CAIRO_FILTER_BEST := 2.
    CAIRO_FILTER_NEAREST := 3.
    CAIRO_FILTER_BILINEAR := 4.
    CAIRO_FILTER_GAUSSIAN := 5.
! !

!Filter class methodsFor:'constants'!

CAIRO_FILTER_BEST

    ^CAIRO_FILTER_BEST
!

CAIRO_FILTER_BILINEAR

    ^CAIRO_FILTER_BILINEAR
!

CAIRO_FILTER_FAST

    ^CAIRO_FILTER_FAST
!

CAIRO_FILTER_GAUSSIAN

    ^CAIRO_FILTER_GAUSSIAN
!

CAIRO_FILTER_GOOD

    ^CAIRO_FILTER_GOOD
!

CAIRO_FILTER_NEAREST

    ^CAIRO_FILTER_NEAREST
! !

!Filter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Filter initialize!
