"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#TextClusterFlags
	instanceVariableNames:''
	classVariableNames:'CAIRO_TEXT_CLUSTER_FLAG_BACKWARD'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!TextClusterFlags class methodsFor:'initialization'!

initialize

    CAIRO_TEXT_CLUSTER_FLAG_BACKWARD := 1.
! !

!TextClusterFlags class methodsFor:'constants'!

CAIRO_TEXT_CLUSTER_FLAG_BACKWARD

    ^CAIRO_TEXT_CLUSTER_FLAG_BACKWARD
! !

!TextClusterFlags class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


TextClusterFlags initialize!
