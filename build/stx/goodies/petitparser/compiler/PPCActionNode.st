"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractActionNode subclass:#PPCActionNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCActionNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitActionNode: self
! !

