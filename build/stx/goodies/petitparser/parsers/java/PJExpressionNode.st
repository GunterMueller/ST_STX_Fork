"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJExpressionNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJExpressionNode comment:'Common superclass for all expression nodes e.i. nodes that have some kind of valuse: variables, literals, method invocations, etc.'
!

!PJExpressionNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitExpressionNode: self
! !

