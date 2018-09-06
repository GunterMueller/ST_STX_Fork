"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJBehaviouralNode subclass:#PJConstructorDeclarationNode
	instanceVariableNames:'constructorInvocation statements'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJConstructorDeclarationNode comment:'constructor-specific behavioural entity.more in superclass comment'
!

!PJConstructorDeclarationNode methodsFor:'accessing'!

acceptVisitor: aVisitor

	aVisitor visitConstructorDeclarationNode: self
!

constructorInvocation
	^ constructorInvocation
!

constructorInvocation: aConstructorInvocation
	constructorInvocation := aConstructorInvocation
!

statements
	^ statements
!

statements: aCollection 
	statements := aCollection 
! !

