"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJBodyDeclarationNode subclass:#PJBehaviouralNode
	instanceVariableNames:'simpleName returnType parameters'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

PJBehaviouralNode comment:'Behavioural node is some entity which has a behavior in it. This reffers to methods in general, but can also reffer to a constructor'
!

!PJBehaviouralNode class methodsFor:'instance creation'!

named: aString 

	^(self new) simpleName: aString ; yourself 
! !

!PJBehaviouralNode methodsFor:'accessing'!

parameters
	^ parameters
!

parameters: anObject
	parameters := anObject
!

returnType
	^ returnType
!

returnType: anObject
	returnType := anObject
!

simpleName
	^ simpleName
!

simpleName: anObject
	simpleName := anObject
! !

