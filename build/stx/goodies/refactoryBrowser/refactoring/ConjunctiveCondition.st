"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

RBAbstractCondition subclass:#RBConjunctiveCondition
	instanceVariableNames:'left right failed'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Conditions'
!

RBConjunctiveCondition comment:'ConjunctiveCondition represents and-ing two AbstractConditions together.

Instance Variables:
	failed	<Symbol>	which condition failed (#leftFailed, #rightFailed, or #unknownFailed)
	left	<AbstractCondition>	the condition on the left side of the and
	right	<AbstractCondition>	the condition on the right side of the and'
!


!RBConjunctiveCondition methodsFor:'checking'!

check
	left check
		ifFalse: 
			[failed := #leftFailed.
			^false].
	right check
		ifFalse: 
			[failed := #rightFailed.
			^false].
	^true
!

check:errAction
        (left check:errAction)
                ifFalse: 
                        [failed := #leftFailed.
                        ^false].
        (right check:errAction)
                ifFalse: 
                        [failed := #rightFailed.
                        ^false].
        ^true
! !

!RBConjunctiveCondition methodsFor:'initialize-release'!

left: aCondition right: aCondition2 
	left := aCondition.
	right := aCondition2.
	failed := #unknownFailed
! !

!RBConjunctiveCondition methodsFor:'printing'!

printOn: aStream 
	aStream print: left;
		nextPutAll: ' & ';
		print: right
! !

!RBConjunctiveCondition methodsFor:'private'!

errorBlockFor: aBoolean 
	^aBoolean
		ifTrue: [nil]
		ifFalse: 
			[failed == #leftFailed ifTrue: [left errorBlock] ifFalse: [right errorBlock]]
!

errorMacro
	^errorMacro isNil
		ifTrue: [self longMacro]
		ifFalse: [super errorMacro]
!

errorStringFor: aBoolean 
	^aBoolean
		ifTrue: [self neitherFailed]
		ifFalse: [self perform: failed]
!

leftFailed
	^left errorStringFor: false
!

longMacro
	^'(' , left errorMacro , ') <1?AND:OR> (' , right errorMacro , ')'
!

neitherFailed
	^(left errorStringFor: true) , ' AND ' , (right errorStringFor: true)
!

rightFailed
	^right errorStringFor: false
!

unknownFailed
	^(left errorStringFor: false) , ' OR ' , (right errorStringFor: false)
! !

!RBConjunctiveCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ConjunctiveCondition.st,v 1.9 2003-09-26 11:53:56 cg Exp $'
! !
