"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJASTNode subclass:#PJModifierNode
	instanceVariableNames:'keyword'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJModifierNode class methodsFor:'instance creation'!

keyword: aString

	^(self new) keyword: aString; yourself
! !

!PJModifierNode methodsFor:'accessing'!

keyword
	^ keyword
!

keyword: anObject
	keyword := anObject
! !

!PJModifierNode methodsFor:'testing'!

isAnnotation

	^false
!

isModifier

	^true
! !

