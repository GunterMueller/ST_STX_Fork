"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJBehaviouralNode subclass:#PJMethodDeclarationNode
	instanceVariableNames:'body'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJMethodDeclarationNode class instanceVariableNames:'aVisitor'

"
 No other class instance variables are inherited by this class.
"
!

!PJMethodDeclarationNode methodsFor:'accessing'!

body
	^ body
!

body: anObject
	body := anObject
! !

!PJMethodDeclarationNode methodsFor:'visiting'!

acceptVisitor: aVisitor

	aVisitor visitMethodDeclarationNode: self
! !

