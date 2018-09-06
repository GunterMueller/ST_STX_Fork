"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJAbstractTypeDeclarationNode subclass:#PJTypeDeclarationNode
	instanceVariableNames:'isInterface superclassType superInterfaceTypes fieldDeclarations
		methodDeclarations'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJTypeDeclarationNode methodsFor:'accessing'!

fieldDeclarations
	^ fieldDeclarations
!

fieldDeclarations: anObject
	fieldDeclarations := anObject
!

isInterface
	^ isInterface
!

isInterface: anObject
	isInterface := anObject
!

methodDeclarations
	^ methodDeclarations
!

methodDeclarations: anObject
	methodDeclarations := anObject
!

superInterfaceTypes
	^ superInterfaceTypes
!

superInterfaceTypes: anObject
	superInterfaceTypes := anObject
!

superclassType
	^ superclassType
!

superclassType: anObject
	superclassType := anObject
! !

!PJTypeDeclarationNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitTypeDeclarationNode: self
! !

