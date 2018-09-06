"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#PatternType
	instanceVariableNames:''
	classVariableNames:'CAIRO_PATTERN_TYPE_SOLID CAIRO_PATTERN_TYPE_SURFACE
		CAIRO_PATTERN_TYPE_LINEAR CAIRO_PATTERN_TYPE_RADIAL
		CAIRO_PATTERN_TYPE_MESH CAIRO_PATTERN_TYPE_RASTER_SOURCE'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!PatternType class methodsFor:'initialization'!

initialize

    CAIRO_PATTERN_TYPE_SOLID := 0.
    CAIRO_PATTERN_TYPE_SURFACE := 1.
    CAIRO_PATTERN_TYPE_LINEAR := 2.
    CAIRO_PATTERN_TYPE_RADIAL := 3.
    CAIRO_PATTERN_TYPE_MESH := 4.
    CAIRO_PATTERN_TYPE_RASTER_SOURCE := 5.
! !

!PatternType class methodsFor:'constants'!

CAIRO_PATTERN_TYPE_LINEAR

    ^CAIRO_PATTERN_TYPE_LINEAR
!

CAIRO_PATTERN_TYPE_MESH

    ^CAIRO_PATTERN_TYPE_MESH
!

CAIRO_PATTERN_TYPE_RADIAL

    ^CAIRO_PATTERN_TYPE_RADIAL
!

CAIRO_PATTERN_TYPE_RASTER_SOURCE

    ^CAIRO_PATTERN_TYPE_RASTER_SOURCE
!

CAIRO_PATTERN_TYPE_SOLID

    ^CAIRO_PATTERN_TYPE_SOLID
!

CAIRO_PATTERN_TYPE_SURFACE

    ^CAIRO_PATTERN_TYPE_SURFACE
! !

!PatternType class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


PatternType initialize!
