"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJBodyDeclarationNode
	instanceVariableNames:'modifiers'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJBodyDeclarationNode comment:'General body declaration of a class or method'
!

!PJBodyDeclarationNode methodsFor:'accessing'!

modifiers
	^ modifiers
!

modifiers: anObject
	modifiers := anObject
! !

!PJBodyDeclarationNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitBodyDeclarationNode: self
! !

