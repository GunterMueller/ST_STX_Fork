"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractPredicateNode subclass:#PPCCharSetPredicateNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCCharSetPredicateNode methodsFor:'as yet unclassified'!

start: compiler id: id
    compiler startMethod: id
!

stop: compiler
    ^ compiler stopMethod
! !

!PPCCharSetPredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitCharSetPredicateNode: self
! !

