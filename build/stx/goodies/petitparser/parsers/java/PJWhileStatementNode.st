"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJStatementNode subclass:#PJWhileStatementNode
	instanceVariableNames:'expression statement'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJWhileStatementNode comment:'Node representing a while loop'
!

!PJWhileStatementNode methodsFor:'accessing'!

expression
	^ expression
!

expression: anObject
	expression := anObject
!

statement
	^ statement
!

statement: anObject
	statement := anObject
! !

!PJWhileStatementNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitWhileStatementNode: self
! !

