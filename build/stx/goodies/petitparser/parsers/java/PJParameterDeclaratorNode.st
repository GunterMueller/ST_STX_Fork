"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJParameterDeclaratorNode
	instanceVariableNames:'modifiers type identifier arrayLevel'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJParameterDeclaratorNode methodsFor:'accessing'!

arrayLevel
	^ arrayLevel
!

arrayLevel: anObject
	arrayLevel := anObject
!

identifier
	^ identifier
!

identifier: anObject
	identifier := anObject
!

modifiers
	^ modifiers
!

modifiers: anObject
	modifiers := anObject
!

type
	^ type
!

type: anObject
	type := anObject
! !

!PJParameterDeclaratorNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	^ aVisitor visitParameterDeclaratorNode: self
! !

