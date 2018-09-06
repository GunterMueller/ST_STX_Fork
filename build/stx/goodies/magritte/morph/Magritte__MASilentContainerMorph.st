"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAContainerMorph subclass:#MASilentContainerMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!

MASilentContainerMorph comment:'The only difference to the superclass is that on answer it does not delete the morph. This is useful when we want the morph to be embedded.'
!


!MASilentContainerMorph methodsFor:'as yet unclassified'!

answer: anObject
	answer ifNotNil: [ answer value: anObject ].
! !

!MASilentContainerMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MASilentContainerMorph.st,v 1.1 2009-07-29 17:56:51 cg Exp $'
! !
