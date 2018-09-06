"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJTypeNode subclass:#PJArrayTypeNode
	instanceVariableNames:'dimensions elementType'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJArrayTypeNode class methodsFor:'instance creation'!

elementType: aTypeNode dimensions: aNumber

	^(self new) elementType: aTypeNode; dimensions: aNumber; yourself
! !

!PJArrayTypeNode methodsFor:'accessing'!

dimensions
	^ dimensions
!

dimensions: anObject
	dimensions := anObject
!

elementType
	^ elementType
!

elementType: anObject
	elementType := anObject
!

type 

	^type ifNil: [type := 
			((1 to: dimensions) 
				inject: elementType type 
				into: [:current :parenthesis |
					(current , '[]')]) ]
! !

