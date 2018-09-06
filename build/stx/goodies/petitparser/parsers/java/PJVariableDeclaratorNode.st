"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJVariableDeclaratorNode
	instanceVariableNames:'variable arrayLevel initializer'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJVariableDeclaratorNode comment:'A part of local variable declaration statement.
!

!PJVariableDeclaratorNode methodsFor:'accessing'!

acceptVisitor: aVisitor

	^ aVisitor visitVariableDeclaratorNode: self
!

arrayLevel
	^ arrayLevel
!

arrayLevel: anObject
	arrayLevel := anObject
!

initializer
	^ initializer
!

initializer: anObject
	initializer := anObject
!

variable
	^ variable
!

variable: anObject
	variable := anObject
! !
