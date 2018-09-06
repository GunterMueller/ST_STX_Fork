"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#FillRule
	instanceVariableNames:''
	classVariableNames:'CAIRO_FILL_RULE_WINDING CAIRO_FILL_RULE_EVEN_ODD'
	poolDictionaries:''
	category:'Cairo-Constants'
!


!FillRule class methodsFor:'initialization'!

initialize

    CAIRO_FILL_RULE_WINDING := 0.
    CAIRO_FILL_RULE_EVEN_ODD := 1.
! !

!FillRule class methodsFor:'constants'!

CAIRO_FILL_RULE_EVEN_ODD

    ^CAIRO_FILL_RULE_EVEN_ODD
!

CAIRO_FILL_RULE_WINDING

    ^CAIRO_FILL_RULE_WINDING
! !

!FillRule class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


FillRule initialize!
