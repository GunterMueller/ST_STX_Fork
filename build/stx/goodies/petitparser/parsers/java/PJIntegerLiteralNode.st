"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJIntegerLiteralNode
	instanceVariableNames:'literalValue isLong'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJIntegerLiteralNode comment:'A literal node of an integer valuse'
!

!PJIntegerLiteralNode class methodsFor:'as yet unclassified'!

newFrom: literalString
	| instanse |
	instanse := super new.
	instanse isLong: literalString last asUppercase = $L.
	instanse literalValue: (
		Integer readFromJavaString: (
			instanse isLong ifTrue: [ literalString allButLast ] ifFalse: [ literalString ])).
	^ instanse
! !

!PJIntegerLiteralNode methodsFor:'accessing'!

isLong
	^ isLong
!

isLong: anObject
	isLong := anObject
!

literalValue
	^ literalValue
!

literalValue: aBoolean
	literalValue := aBoolean
! !

!PJIntegerLiteralNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitIntegerLiteralNode: self
! !

