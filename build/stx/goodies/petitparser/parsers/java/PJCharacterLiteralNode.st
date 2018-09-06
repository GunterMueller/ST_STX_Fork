"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJCharacterLiteralNode
	instanceVariableNames:'literalValue'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJCharacterLiteralNode class methodsFor:'as yet unclassified'!

literalValue: aString
 ^(self new) literalValue: aString
! !

!PJCharacterLiteralNode methodsFor:'as yet unclassified'!

acceptVisitor: aVisitor
	^ aVisitor visitCharacterLiteralNode: self
!

literalValue
	^ literalValue
!

literalValue: anObject
	literalValue := anObject
! !

