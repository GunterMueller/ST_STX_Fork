"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJNullLiteralNode
	instanceVariableNames:'literalValue'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJNullLiteralNode class methodsFor:'as yet unclassified'!

literalValue: aLiteral

 ^(self new) literalValue: aLiteral
! !

!PJNullLiteralNode methodsFor:'as yet unclassified'!

acceptVisitor: aVisitor
	^ aVisitor visitNullLiteralNode: self
!

literalValue
	^ literalValue
!

literalValue: anObject
	literalValue := anObject
! !

