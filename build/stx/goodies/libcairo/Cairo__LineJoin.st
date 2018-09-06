"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#LineJoin
	instanceVariableNames:''
	classVariableNames:'CAIRO_LINE_JOIN_MITER CAIRO_LINE_JOIN_ROUND CAIRO_LINE_JOIN_BEVEL'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!LineJoin class methodsFor:'initialization'!

initialize

    CAIRO_LINE_JOIN_MITER := 0.
    CAIRO_LINE_JOIN_ROUND := 1.
    CAIRO_LINE_JOIN_BEVEL := 2.
! !

!LineJoin class methodsFor:'constants'!

CAIRO_LINE_JOIN_BEVEL

    ^CAIRO_LINE_JOIN_BEVEL
!

CAIRO_LINE_JOIN_MITER

    ^CAIRO_LINE_JOIN_MITER
!

CAIRO_LINE_JOIN_ROUND

    ^CAIRO_LINE_JOIN_ROUND
! !

!LineJoin class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


LineJoin initialize!
