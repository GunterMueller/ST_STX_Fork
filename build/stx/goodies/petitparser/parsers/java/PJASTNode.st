"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PJASTNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJASTNode comment:'General node defining for Java AST'
!

!PJASTNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^self subclassResponsibility
! !

