"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJCompilationUnitNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJCompilationUnitNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitCompilationUnitNode: self
! !

