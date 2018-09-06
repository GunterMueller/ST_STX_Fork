"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJStringLiteralNode
	instanceVariableNames:'literalValue'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJStringLiteralNode comment:'A node of a string literal.'
!

!PJStringLiteralNode class methodsFor:'instance creation'!

literalValue: aString

 ^(self new) literalValue: aString
! !

!PJStringLiteralNode methodsFor:'accessing'!

literalValue
	^ literalValue
!

literalValue: anObject
	literalValue := anObject
! !

!PJStringLiteralNode methodsFor:'visiting'!

acceptVisitor: aVisitor
	^ aVisitor visitStringLiteralNode: self
! !

