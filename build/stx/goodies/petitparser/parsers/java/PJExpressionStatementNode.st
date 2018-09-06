"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJStatementNode subclass:#PJExpressionStatementNode
	instanceVariableNames:'expression'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJExpressionStatementNode comment:'A statement which has nothing but expression in it.
!


!PJExpressionStatementNode methodsFor:'accessing'!

expression
	^ expression
!

expression: anExpression
	expression := anExpression
! !

!PJExpressionStatementNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitExpressionStatementNode: self
! !

!PJExpressionStatementNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !
