"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJNameNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJNameNode methodsFor:'accessing'!

fullyQualifiedName
	^ self subclassResponsibility 
! !

!PJNameNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitNameNode: self
! !

