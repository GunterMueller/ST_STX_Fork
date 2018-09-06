"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#Extend
	instanceVariableNames:''
	classVariableNames:'CAIRO_EXTEND_NONE CAIRO_EXTEND_REPEAT CAIRO_EXTEND_REFLECT
		CAIRO_EXTEND_PAD'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!Extend class methodsFor:'documentation'!

documentation
"
    Cairo::Extend is used to describe how pattern color/alpha will be determined for 
    areas 'outside' the pattern's natural area, (for example, outside the surface bounds 
    or outside the gradient geometry).

    Mesh patterns are not affected by the extend mode.

    The default extend mode is CAIRO_EXTEND_NONE for surface patterns and CAIRO_EXTEND_PAD 
    for gradient patterns.

    New entries may be added in future versions.

    Members

    CAIRO_EXTEND_NONE       pixels outside of the source pattern 
                            are fully transparent (Since 1.0)

    CAIRO_EXTEND_REPEAT     the pattern is tiled by repeating 
                            (Since 1.0)

    CAIRO_EXTEND_REFLECT    the pattern is tiled by reflecting at the 
                            edges (Since 1.0; but only implemented for 
                            surface patterns since 1.6)

    CAIRO_EXTEND_PAD        pixels outside of the pattern copy the closest 
                            pixel from the source (Since 1.2; but only 
                            implemented for surface patterns since 1.6)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Extend class methodsFor:'initialization'!

initialize

    CAIRO_EXTEND_NONE := 0.
    CAIRO_EXTEND_REPEAT := 1.
    CAIRO_EXTEND_REFLECT := 2.
    CAIRO_EXTEND_PAD := 3.
! !

!Extend class methodsFor:'constants'!

CAIRO_EXTEND_NONE

    ^CAIRO_EXTEND_NONE
!

CAIRO_EXTEND_PAD

    ^CAIRO_EXTEND_PAD
!

CAIRO_EXTEND_REFLECT

    ^CAIRO_EXTEND_REFLECT
!

CAIRO_EXTEND_REPEAT

    ^CAIRO_EXTEND_REPEAT
! !


Extend initialize!
