"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

Pattern subclass:#PatternSolid
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!PatternSolid methodsFor:'accessing'!

color
    | rb gb bb ab a color |

    rb := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    gb := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    bb := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    ab := ExternalBytes basicNew allocateBytes: ExternalBytes sizeofDouble.
    [ 
        CPrimitives cairo_pattern_get_rgba: self _: rb _: gb _: bb _: ab.
        a := ab doubleAt: 1.
        a = 1.0 ifTrue:[ 
            color := Color 
                           scaledRed: ((rb doubleAt: 1) * 16rFFFF) rounded
                         scaledGreen: ((gb doubleAt: 1) * 16rFFFF) rounded 
                          scaledBlue: ((bb doubleAt: 1) * 16rFFFF) rounded
        ] ifFalse:[ 
            color := TranslucentColor 
                           scaledRed: ((rb doubleAt: 1) * 16rFFFF) rounded
                         scaledGreen: ((gb doubleAt: 1) * 16rFFFF) rounded 
                          scaledBlue: ((bb doubleAt: 1) * 16rFFFF) rounded.
            color alpha: a
        ].

    ] ensure:[ 
        rb free.
        gb free.
        bb free.
        ab free.
    ].
    ^ color

    "Created: / 04-03-2016 / 07:06:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2016 / 16:13:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PatternSolid methodsFor:'testing'!

isSolid
    ^ true

    "Created: / 04-03-2016 / 09:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PatternSolid class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

