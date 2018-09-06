"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJNameNode subclass:#PJSimpleNameNode
	instanceVariableNames:'isDeclaration identifier'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJSimpleNameNode class methodsFor:'instance creation'!

identifier: aString 
	
	^(self new) identifier: aString; yourself
! !

!PJSimpleNameNode methodsFor:'accessing'!

fullyQualifiedName
	^ self identifier value
!

identifier
	^ identifier
!

identifier: anObject
	identifier := anObject
!

isDeclaration
	^ isDeclaration
!

isDeclaration: anObject
	isDeclaration := anObject
! !

