"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCStarMessagePredicateNode subclass:#PPCTokenStarMessagePredicateNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTokenStarMessagePredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitTokenStarMessagePredicateNode: self
! !

