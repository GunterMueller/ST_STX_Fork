"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJTypeNode
	instanceVariableNames:'type'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJTypeNode class methodsFor:'instance creation'!

type: aString

	^(self new) type: aString; yourself
! !

!PJTypeNode methodsFor:'accessing'!

type
	^ type
!

type: anObject
	type := anObject
! !

