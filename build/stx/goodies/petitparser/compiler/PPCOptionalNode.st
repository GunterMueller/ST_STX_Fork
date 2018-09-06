"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCOptionalNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCOptionalNode methodsFor:'accessing'!

defaultName
    ^ #opt
! !

!PPCOptionalNode methodsFor:'analysis'!

acceptsEpsilon
    ^ true
!

acceptsEpsilonOpenSet: set
    ^ true
!

isNullable
    ^ true
! !

!PPCOptionalNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitOptionalNode: self
! !

