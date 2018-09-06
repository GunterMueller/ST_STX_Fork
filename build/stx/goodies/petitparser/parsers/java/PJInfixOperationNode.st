"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJInfixOperationNode
	instanceVariableNames:'left operator right'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJInfixOperationNode comment:'This node is a STUB!!!!!!!!It''s being used for each node that consists of 2 expressions and some operation in between e.g.: +, -, =, +=, ==...'
!

!PJInfixOperationNode methodsFor:'accessing'!

left
	^ left
!

left: anObject
	left := anObject
!

operator
	^ operator
!

operator: anObject
	operator := anObject
!

right
	^ right
!

right: anObject
	right := anObject
! !

!PJInfixOperationNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitInfixOperationNode: self
! !

