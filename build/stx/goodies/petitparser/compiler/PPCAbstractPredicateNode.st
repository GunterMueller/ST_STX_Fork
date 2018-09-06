"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCAbstractPredicateNode
	instanceVariableNames:'predicate'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCAbstractPredicateNode methodsFor:'accessing'!

defaultName
    ^ #predicate
!

predicate
    
    ^ predicate
!

predicate: anObject
    
    predicate := anObject
! !

!PPCAbstractPredicateNode methodsFor:'analysis'!

acceptsEpsilon
    ^ false
!

firstCharSet
    ^ PPCharSetPredicate on: predicate
! !

!PPCAbstractPredicateNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ predicate = anotherNode predicate.
!

hash
    ^ super hash bitXor: predicate hash
!

recognizedSentencesPrim
    | retval |

    retval := OrderedCollection new.
    "TODO JK: Works only for ASCII :("
    1 to: 255 do: [ :i |
        (predicate value: (Character codePoint: i)) ifTrue: [ 
            retval add: (Character codePoint: i) asString 
        ]
    ].
    ^ retval
! !

!PPCAbstractPredicateNode methodsFor:'compiling'!

extendClassification: classification
    ^ (classification asOrderedCollection addLast: false; yourself) asArray
! !

!PPCAbstractPredicateNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

