"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#LineCap
	instanceVariableNames:''
	classVariableNames:'CAIRO_LINE_CAP_BUTT CAIRO_LINE_CAP_ROUND CAIRO_LINE_CAP_SQUARE'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!LineCap class methodsFor:'initialization'!

initialize

    CAIRO_LINE_CAP_BUTT := 0.
    CAIRO_LINE_CAP_ROUND := 1.
    CAIRO_LINE_CAP_SQUARE := 2.
! !

!LineCap class methodsFor:'constants'!

CAIRO_LINE_CAP_BUTT

    ^CAIRO_LINE_CAP_BUTT
!

CAIRO_LINE_CAP_ROUND

    ^CAIRO_LINE_CAP_ROUND
!

CAIRO_LINE_CAP_SQUARE

    ^CAIRO_LINE_CAP_SQUARE
! !

!LineCap class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


LineCap initialize!
