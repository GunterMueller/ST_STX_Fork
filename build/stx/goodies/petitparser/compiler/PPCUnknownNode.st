"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCUnknownNode
	instanceVariableNames:'parser'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCUnknownNode class methodsFor:'as yet unclassified'!

new
    ^ self basicNew initialize
! !

!PPCUnknownNode methodsFor:'accessing'!

acceptsEpsilon
    ^ parser acceptsEpsilon
!

acceptsEpsilonOpenSet: aSet
    ^ parser acceptsEpsilonOpenSet: aSet
!

children
    ^ parser children
!

defaultName
    ^ #parser
!

isContextFreePrim
    ^ parser isContextFreePrim
!

isNullable
    ^ parser isNullable
!

parser
    
    ^ parser
!

parser: anObject
    
    parser := anObject
! !

!PPCUnknownNode methodsFor:'analysis'!

firstCharSet
    ^ parser firstCharSet
! !

!PPCUnknownNode methodsFor:'comparison'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ parser = anotherNode parser.
!

hash
    ^ super hash bitXor: parser hash
! !

!PPCUnknownNode methodsFor:'copying'!

postCopy
    super postCopy.
    parser := parser copy.
! !

!PPCUnknownNode methodsFor:'transformation'!

replace: node with: anotherNode
    parser replace: node with: anotherNode
! !

!PPCUnknownNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitUnknownNode: self
! !

!PPCUnknownNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

