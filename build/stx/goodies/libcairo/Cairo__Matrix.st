"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CStructure variableByteSubclass:#Matrix
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!Matrix class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    fields := #(
        xx
        yx
        xy
        yy
        x0
        y0
    )

    "/ please change as required (and remove this comment)

    "Modified: / 18-02-2016 / 09:08:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Matrix class methodsFor:'instance creation'!

identity
    | m |

    m := self new.
    CPrimitives cairo_matrix_init_identity: m.
    ^ m

    "Created: / 17-02-2016 / 20:14:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scale: aNumberOrPoint
    | sx sy m |
    aNumberOrPoint isPoint ifTrue:[ 
        sx := aNumberOrPoint x asFloat.
        sy := aNumberOrPoint y asFloat.
    ] ifFalse:[ 
        sx := sy := aNumberOrPoint asFloat.
    ].
    m := self new.
    CPrimitives cairo_matrix_init_scale: m _: sx _: sy.    
    ^ m.

    "Created: / 18-02-2016 / 00:17:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

translate: aNumberOrPoint
    | tx ty m |
    aNumberOrPoint isPoint ifTrue:[ 
        tx := aNumberOrPoint x asFloat.
        ty := aNumberOrPoint y asFloat.
    ] ifFalse:[ 
        tx := ty := aNumberOrPoint asFloat.
    ].
    m := self new.
    CPrimitives cairo_matrix_init_translate: m _: tx _: ty.    
    ^ m.

    "Created: / 08-03-2016 / 21:36:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Matrix class methodsFor:'accessing'!

sizeof
    "Returns size of undelaying structure in bytes"

    ^48
! !

!Matrix methodsFor:'accessing'!

x0
    "Returns double"

    ^self doubleAt:1 + 32
!

x0: value

    self doubleAt:1 + 32 put:value
!

xx
    "Returns double"

    ^self doubleAt:1 + 0
!

xx: value

    self doubleAt:1 + 0 put:value
!

xy
    "Returns double"

    ^self doubleAt:1 + 16
!

xy: value

    self doubleAt:1 + 16 put:value
!

y0
    "Returns double"

    ^self doubleAt:1 + 40
!

y0: value

    self doubleAt:1 + 40 put:value
!

yx
    "Returns double"

    ^self doubleAt:1 + 8
!

yx: value

    self doubleAt:1 + 8 put:value
!

yy
    "Returns double"

    ^self doubleAt:1 + 24
!

yy: value

    self doubleAt:1 + 24 put:value
! !

!Matrix class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !


Matrix initialize!
