"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

RBAbstractCondition subclass:#RBNegationCondition
	instanceVariableNames:'condition'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Conditions'
!

RBNegationCondition comment:'NegationCondition represents negating another condition.

Instance Variables:
	condition	<AbstractCondition>	the condition that is to be negated'
!


!RBNegationCondition class methodsFor:'instance creation'!

on: aCondition
	^self new condition: aCondition
! !

!RBNegationCondition methodsFor:'checking'!

check
	^condition check not
!

check:errAction
    ( condition check:[:err | ] ) ifFalse:[^ true].
    errAction value:self.
    ^ false
! !

!RBNegationCondition methodsFor:'initialize-release'!

condition: aCondition 
	condition := aCondition.
	self errorMacro: condition errorMacro
! !

!RBNegationCondition methodsFor:'printing'!

printOn: aStream 
	aStream nextPutAll: 'NOT ';
		print: condition
! !

!RBNegationCondition methodsFor:'private'!

errorBlockFor: aBoolean 
	^condition errorBlockFor: aBoolean not
!

errorStringFor: aBoolean 
	^condition errorStringFor: aBoolean not
! !

!RBNegationCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/NegationCondition.st,v 1.9 2003-09-26 11:54:00 cg Exp $'
! !
