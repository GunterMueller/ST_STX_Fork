"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJPackageDeclarationNode
	instanceVariableNames:'nameNode'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!


!PJPackageDeclarationNode methodsFor:'accessing'!

nameNode
	^ nameNode
!

nameNode: anObject
	nameNode := anObject
! !

!PJPackageDeclarationNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitPackageDeclarationNode: self
! !

!PJPackageDeclarationNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

