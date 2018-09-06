"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJStatementNode subclass:#PJReturnStatementNode
	instanceVariableNames:'expression'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJReturnStatementNode comment:'Return statement node.Ex:return 5;return 5+a.foo();return a;'
!

!PJReturnStatementNode methodsFor:'accessing'!

expression
	^ expression
!

expression: anExpression
	expression := anExpression
! !

!PJReturnStatementNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitReturnStatementNode: self
! !

