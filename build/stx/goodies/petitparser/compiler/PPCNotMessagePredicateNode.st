"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractPredicateNode subclass:#PPCNotMessagePredicateNode
	instanceVariableNames:'message'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCNotMessagePredicateNode methodsFor:'accessing'!

message
    
    ^ message
!

message: anObject
    
    message := anObject
! !

!PPCNotMessagePredicateNode methodsFor:'analysis'!

firstCharSet
    ^ PPCharSetPredicate on: [:e | (predicate value:e)  not ]

    "Modified: / 23-04-2015 / 22:11:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCNotMessagePredicateNode methodsFor:'comparison'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ message = anotherNode message.
!

hash
    ^ super hash bitXor: message hash
! !

!PPCNotMessagePredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitNotMessagePredicateNode: self
! !

