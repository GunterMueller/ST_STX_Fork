"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: CodingExamples_GUI }"

AnimatedGLXYGraph3DDemo subclass:#AnimatedGLXYGraph3DDemo2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-3D'
!


!AnimatedGLXYGraph3DDemo2 methodsFor:'animation'!

animate
    |rotHolder|

    rotHolder := self yRot.
    rotHolder value:(rotHolder value + 5 \\ 360)

    "Created: / 6.6.1998 / 21:22:07 / cg"
    "Modified: / 6.6.1998 / 23:38:04 / cg"
! !

!AnimatedGLXYGraph3DDemo2 methodsFor:'aspects'!

showBox
    ^ super showBox value:false; yourself

    "Created: / 6.6.1998 / 23:37:41 / cg"
!

showNormals
    ^ super showNormals value:false; yourself

    "Created: / 6.6.1998 / 23:36:47 / cg"
! !

!AnimatedGLXYGraph3DDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/AnimatedGLXYGraph3DDemo2.st,v 1.2 2016-01-21 18:05:14 cg Exp $'
! !

