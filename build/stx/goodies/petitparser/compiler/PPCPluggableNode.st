"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCPluggableNode
	instanceVariableNames:'block'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCPluggableNode methodsFor:'accessing'!

block
    
    ^ block
!

block: anObject
    
    block := anObject
!

defaultName
    ^ #plug
! !

!PPCPluggableNode methodsFor:'analysis'!

acceptsEpsilon
    ^ true
!

acceptsEpsilonOpenSet: set
    ^ true
!

firstCharSet
    ^ PPCharSetPredicate on: [:char | (block asParser parse: char asString) isPetitFailure not ]
! !

!PPCPluggableNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ block = anotherNode block.
!

hash
    ^ super hash bitXor: block hash
! !

!PPCPluggableNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitPluggableNode: self
! !

!PPCPluggableNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

