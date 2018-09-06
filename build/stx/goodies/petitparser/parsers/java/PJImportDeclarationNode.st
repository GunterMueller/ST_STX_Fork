"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJImportDeclarationNode
	instanceVariableNames:'nameNode isStatic isOnDemand'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJImportDeclarationNode methodsFor:'accessing'!

isOnDemand
	^ isOnDemand
!

isOnDemand: anObject
	isOnDemand := anObject
!

isStatic
	^ isStatic
!

isStatic: anObject
	isStatic := anObject
!

nameNode
	^ nameNode
!

nameNode: anObject
	nameNode := anObject
! !

!PJImportDeclarationNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitImportDeclarationNode: self
! !

