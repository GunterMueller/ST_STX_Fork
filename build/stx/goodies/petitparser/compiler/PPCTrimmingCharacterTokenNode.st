"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCTrimmingTokenNode subclass:#PPCTrimmingCharacterTokenNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTrimmingCharacterTokenNode methodsFor:'as yet unclassified'!

accept: visitor
    ^ visitor visitTrimmingTokenCharacterNode: self
! !

