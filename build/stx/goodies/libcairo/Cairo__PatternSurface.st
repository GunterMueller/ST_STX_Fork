"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

Pattern subclass:#PatternSurface
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!

!PatternSurface methodsFor:'accessing'!

surface
    | surfacePtrCell surface |

    surfacePtrCell := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofPointer clear: false.
    [ 
        CPrimitives cairo_pattern_get_surface: self _: surfacePtrCell.
        surface := Surface basicNew.
        surface setAddressFromBytes: surfacePtrCell asByteArray.
        surface := surface reference.
        surface initialize.
    ] ensure:[ 
        surfacePtrCell free.
    ].
    ^ surface.

    "Created: / 05-03-2016 / 23:05:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

