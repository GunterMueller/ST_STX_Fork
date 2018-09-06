"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJFloatLiteralNode
	instanceVariableNames:'literalValue isLong isFloat'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJFloatLiteralNode class methodsFor:'as yet unclassified'!

newFrom: literalString
	| instanse |
	
	instanse := super new.
	instanse isFloat: literalString last asUppercase = $F.
	instanse literalValue: (instanse isFloat ifTrue: [ literalString allButLast ] ifFalse: [ literalString ]).
	^ instanse 
! !

!PJFloatLiteralNode methodsFor:'as yet unclassified'!

acceptVisitor: aVisitor
	^ aVisitor visitFloatLiteralNode: self
!

isFloat
	^ isFloat
!

isFloat: anObject
	isFloat := anObject
!

literalValue
	^ literalValue
!

literalValue: anObject
	literalValue := anObject
! !

