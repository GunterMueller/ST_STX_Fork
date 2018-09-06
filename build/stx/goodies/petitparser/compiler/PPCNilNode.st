"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCNilNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCNilNode methodsFor:'accessing'!

defaultName
    ^ #nil
! !

!PPCNilNode methodsFor:'analysis'!

acceptsEpsilon
    ^ true
!

firstCharSet
    ^ PPCharSetPredicate on: [:e | false ] 
!

isNullable
    ^ true
! !

!PPCNilNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitNilNode: self
! !

!PPCNilNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

