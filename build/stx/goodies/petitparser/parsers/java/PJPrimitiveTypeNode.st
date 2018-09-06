"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJTypeNode subclass:#PJPrimitiveTypeNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJPrimitiveTypeNode methodsFor:'as yet unclassified'!

acceptVisitor: aVisitor
	^ aVisitor visitPrimitiveTypeNode: self
! !

