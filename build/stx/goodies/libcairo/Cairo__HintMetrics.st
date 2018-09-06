"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#HintMetrics
	instanceVariableNames:''
	classVariableNames:'CAIRO_HINT_METRICS_DEFAULT CAIRO_HINT_METRICS_OFF
		CAIRO_HINT_METRICS_ON'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!HintMetrics class methodsFor:'initialization'!

initialize

    CAIRO_HINT_METRICS_DEFAULT := 0.
    CAIRO_HINT_METRICS_OFF := 1.
    CAIRO_HINT_METRICS_ON := 2.
! !

!HintMetrics class methodsFor:'constants'!

CAIRO_HINT_METRICS_DEFAULT

    ^CAIRO_HINT_METRICS_DEFAULT
!

CAIRO_HINT_METRICS_OFF

    ^CAIRO_HINT_METRICS_OFF
!

CAIRO_HINT_METRICS_ON

    ^CAIRO_HINT_METRICS_ON
! !


HintMetrics initialize!
