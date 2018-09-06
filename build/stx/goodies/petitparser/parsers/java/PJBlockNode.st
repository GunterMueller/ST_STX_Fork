"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJBlockNode
	instanceVariableNames:'statements'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJBlockNode comment:'A node representing a block of java code.
!

!PJBlockNode methodsFor:'accessing'!

acceptVisitor: aVisitor

	^ aVisitor visitStatementBlockNode: self
!

addStatement: aStatement
	statements add: aStatement
!

statements
	^ statements
!

statements: aCollection
	statements := OrderedCollection withAll: aCollection
! !

!PJBlockNode methodsFor:'initialize-release'!

initialize
	statements := OrderedCollection new
! !
