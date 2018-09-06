"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#RegionOverlap
	instanceVariableNames:''
	classVariableNames:'CAIRO_REGION_OVERLAP_IN CAIRO_REGION_OVERLAP_OUT
		CAIRO_REGION_OVERLAP_PART'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!RegionOverlap class methodsFor:'initialization'!

initialize

    CAIRO_REGION_OVERLAP_IN := 0.
    CAIRO_REGION_OVERLAP_OUT := 1.
    CAIRO_REGION_OVERLAP_PART := 2.
! !

!RegionOverlap class methodsFor:'constants'!

CAIRO_REGION_OVERLAP_IN

    ^CAIRO_REGION_OVERLAP_IN
!

CAIRO_REGION_OVERLAP_OUT

    ^CAIRO_REGION_OVERLAP_OUT
!

CAIRO_REGION_OVERLAP_PART

    ^CAIRO_REGION_OVERLAP_PART
! !

!RegionOverlap class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


RegionOverlap initialize!
