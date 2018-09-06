"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJIdentifierNode
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJIdentifierNode comment:'An identifier node. Variable name is identifier'
!

!PJIdentifierNode class methodsFor:'instance-creation'!

newWithName: aString
	^ super new name: aString; yourself
! !

!PJIdentifierNode methodsFor:'accessing'!

acceptVisitor: aVisitor

	^ aVisitor visitIdentifierNode: self
!

name
	^ name
!

name: aString
	name := aString
! !

