"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#SurfaceObserverMode
	instanceVariableNames:''
	classVariableNames:'CAIRO_SURFACE_OBSERVER_NORMAL
		CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!SurfaceObserverMode class methodsFor:'initialization'!

initialize

    CAIRO_SURFACE_OBSERVER_NORMAL := 0.
    CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS := 1.
! !

!SurfaceObserverMode class methodsFor:'constants'!

CAIRO_SURFACE_OBSERVER_NORMAL

    ^CAIRO_SURFACE_OBSERVER_NORMAL
!

CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS

    ^CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS
! !


SurfaceObserverMode initialize!
