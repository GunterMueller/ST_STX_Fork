"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCStarNode subclass:#PPCStarCharSetPredicateNode
	instanceVariableNames:'predicate'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCStarCharSetPredicateNode methodsFor:'accessing'!

extendClassification: classification
    ^ (classification asOrderedCollection addLast: false; yourself) asArray
!

firstCharSet
    ^ PPCharSetPredicate on: predicate 	
!

predicate
    
    ^ predicate
!

predicate: anObject
    
    predicate := anObject
! !

!PPCStarCharSetPredicateNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ predicate = anotherNode predicate.
!

hash
    ^ super hash bitXor: predicate hash
! !

!PPCStarCharSetPredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitStarCharSetPredicateNode: self
! !

!PPCStarCharSetPredicateNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

