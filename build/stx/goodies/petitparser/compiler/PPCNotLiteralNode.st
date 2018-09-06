"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractLiteralNode subclass:#PPCNotLiteralNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCNotLiteralNode methodsFor:'accessing'!

defaultName
    ^ #notLit
!

firstCharSet
    ^ PPCharSetPredicate on: [:e | true ]
! !

!PPCNotLiteralNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitNotLiteralNode: self
! !

