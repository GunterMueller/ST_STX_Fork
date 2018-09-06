"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJExpressionNode subclass:#PJSeparatorNode
	instanceVariableNames:'separatorValue'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJSeparatorNode class methodsFor:'as yet unclassified'!

separatorValue: aString

 ^(self new) separatorValue: aString
! !

!PJSeparatorNode methodsFor:'as yet unclassified'!

acceptVisitor: aVisitor
	^ aVisitor visitSeparatorNode: self
!

separatorValue
	^ separatorValue.
!

separatorValue: anObject
	separatorValue := anObject
! !

