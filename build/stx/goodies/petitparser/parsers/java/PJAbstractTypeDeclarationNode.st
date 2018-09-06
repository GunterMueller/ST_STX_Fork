"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJBodyDeclarationNode subclass:#PJAbstractTypeDeclarationNode
	instanceVariableNames:'simpleName'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJAbstractTypeDeclarationNode methodsFor:'accessing'!

simpleName
	^ simpleName
!

simpleName: anObject
	simpleName := anObject
! !

!PJAbstractTypeDeclarationNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitAbstractTypeDeclarationNode: self
! !

