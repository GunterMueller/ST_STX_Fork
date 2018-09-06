"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCTokenStarMessagePredicateNode subclass:#PPCTokenStarSeparatorNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTokenStarSeparatorNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitTokenStarSeparatorNode: self
! !

