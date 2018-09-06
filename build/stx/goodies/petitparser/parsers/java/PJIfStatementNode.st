"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJStatementNode subclass:#PJIfStatementNode
	instanceVariableNames:'condition thenPart elsePart'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJIfStatementNode comment:'Node representing an if statement. If with and without else are both covere by this node'
!

!PJIfStatementNode methodsFor:'accessing'!

condition
	^ condition
!

condition: anObject
	condition := anObject
!

elsePart
	^ elsePart
!

elsePart: anObject
	elsePart := anObject
!

thenPart
	^ thenPart
!

thenPart: anObject
	thenPart := anObject
! !

!PJIfStatementNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitIfStatementNode: self
! !

