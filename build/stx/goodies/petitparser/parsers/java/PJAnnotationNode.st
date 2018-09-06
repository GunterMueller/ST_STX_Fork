"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJAnnotationNode
	instanceVariableNames:'typeName'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJAnnotationNode class methodsFor:'instance creation'!

typeName: aPJNameNode

	^(self new) typeName: aPJNameNode ; yourself
! !

!PJAnnotationNode methodsFor:'accessing'!

typeName
	^ typeName
!

typeName: anObject
	typeName := anObject
! !

!PJAnnotationNode methodsFor:'testing'!

isAnnotation

	^true
!

isModifier 

	^ false
! !

