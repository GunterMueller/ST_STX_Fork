"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractPredicateNode subclass:#PPCNotCharSetPredicateNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCNotCharSetPredicateNode methodsFor:'analysis'!

firstCharSet
    ^ PPCharSetPredicate on: [:e | (predicate value:e)  not ] 
    
! !

!PPCNotCharSetPredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitNotCharSetPredicateNode: self
! !

!PPCNotCharSetPredicateNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

