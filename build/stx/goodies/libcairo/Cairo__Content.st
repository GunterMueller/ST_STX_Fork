"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#Content
	instanceVariableNames:''
	classVariableNames:'CAIRO_CONTENT_COLOR CAIRO_CONTENT_ALPHA CAIRO_CONTENT_COLOR_ALPHA'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!Content class methodsFor:'initialization'!

initialize

    CAIRO_CONTENT_COLOR := 4096.
    CAIRO_CONTENT_ALPHA := 8192.
    CAIRO_CONTENT_COLOR_ALPHA := 12288.
! !

!Content class methodsFor:'constants'!

CAIRO_CONTENT_ALPHA

    ^CAIRO_CONTENT_ALPHA
!

CAIRO_CONTENT_COLOR

    ^CAIRO_CONTENT_COLOR
!

CAIRO_CONTENT_COLOR_ALPHA

    ^CAIRO_CONTENT_COLOR_ALPHA
! !

!Content class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Content initialize!
