"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Object subclass:#RBAbstractCondition
	instanceVariableNames:'errorMacro mayProceed'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Conditions'
!

RBAbstractCondition comment:'AbstractCondition is an abstract class. It represents a precondition that is used whenever a Refactoring is performed. All preconditions must evaluate successfully in order for the Refactoring to be performed.

Instance Variables:
	errorMacro	<String>	the error string that is used when the condition fails'
!


!RBAbstractCondition methodsFor:'accessing'!

errorBlock
	^self errorBlockFor: false
!

errorString
	^self errorStringFor: false
!

mayProceed
    ^ mayProceed ? false
!

mayProceed:something
    mayProceed := something.
! !

!RBAbstractCondition methodsFor:'checking'!

check
	self subclassResponsibility
!

check:errAction
        self subclassResponsibility
! !

!RBAbstractCondition methodsFor:'logical operations'!

& aCondition 
	^RBConjunctiveCondition new left: self right: aCondition
!

not
        ^RBNegationCondition on: self
!

| aCondition 
    ^ RBAlternativeCondition new left:self right:aCondition

"/        "(A | B) = (A not & B not) not"
"/
"/        ^(self not & aCondition not) not
! !

!RBAbstractCondition methodsFor:'private'!

errorBlockFor: aBoolean 
	^nil
!

errorMacro
	^errorMacro isNil
		ifTrue: ['unknown']
		ifFalse: [errorMacro]
!

errorMacro: aString 
	errorMacro := aString
!

errorStringFor: aBoolean
	^self errorMacro expandMacrosWith: aBoolean
! !

!RBAbstractCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AbstractCondition.st,v 1.12 2003-09-26 11:54:05 cg Exp $'
! !
