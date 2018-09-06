"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCAnyNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCAnyNode methodsFor:'accessing'!

defaultName
    ^ #any
! !

!PPCAnyNode methodsFor:'analysis'!

acceptsEpsilon
    ^ false
!

firstCharSet
    self flag: 'JK: hack alert, 3 is EOF'.
    ^ PPCharSetPredicate on: [:e | (e == 3) not  ] 
! !

!PPCAnyNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitAnyNode: self
! !

!PPCAnyNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

