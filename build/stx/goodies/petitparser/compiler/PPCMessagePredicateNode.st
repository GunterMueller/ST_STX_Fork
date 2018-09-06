"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractPredicateNode subclass:#PPCMessagePredicateNode
	instanceVariableNames:'message'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCMessagePredicateNode methodsFor:'accessing'!

message
    
    ^ message
!

message: anObject
    
    message := anObject
! !

!PPCMessagePredicateNode methodsFor:'analysis'!

firstCharSet
    ^ PPCharSetPredicate on: [:e | e perform: message ]

    "Modified: / 23-04-2015 / 22:13:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMessagePredicateNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ message = anotherNode message.
!

hash
    ^ super hash bitXor: message hash
! !

!PPCMessagePredicateNode methodsFor:'printing'!

printNameOn: aStream
    super printNameOn: aStream.
    aStream nextPutAll: ', '; print: message
! !

!PPCMessagePredicateNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitMessagePredicateNode: self
! !

