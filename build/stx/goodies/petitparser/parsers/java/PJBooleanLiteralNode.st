"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJBooleanLiteralNode
	instanceVariableNames:'booleanValue'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJBooleanLiteralNode comment:'Node representing a boolean literal'
!

!PJBooleanLiteralNode class methodsFor:'instance creation'!

booleanValue: aBoolean

	^(self new) booleanValue: aBoolean
! !

!PJBooleanLiteralNode methodsFor:'accessing'!

booleanValue
	^ booleanValue
!

booleanValue: anObject
	booleanValue := anObject
! !

!PJBooleanLiteralNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitBooleanLiteralNode: self
! !

