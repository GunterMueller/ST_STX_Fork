"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCStarNode subclass:#PPCStarMessagePredicateNode
	instanceVariableNames:'message'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCStarMessagePredicateNode methodsFor:'accessing'!

defaultName
    ^ #starPredicate
!

firstCharSet
    ^ PPCharSetPredicate on: [:char | char perform: message ] 	
!

message
    
    ^ message
!

message: anObject
    
    message := anObject
! !

!PPCStarMessagePredicateNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ message = anotherNode message.
!

hash
    ^ super hash bitXor: message hash
! !

!PPCStarMessagePredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitStarMessagePredicateNode: self
! !

!PPCStarMessagePredicateNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

