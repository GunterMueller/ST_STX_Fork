"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractPredicateNode subclass:#PPCPredicateNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCPredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitPredicateNode: self
! !

!PPCPredicateNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

