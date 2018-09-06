"{ Package: 'stx:goodies/petitparser/gui' }"

RemoveClassRefactoring subclass:#PPRemoveParserRefactoring
	instanceVariableNames:'class'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Refactoring'
!


!PPRemoveParserRefactoring class methodsFor:'instance creation'!

onClass: aClass
	^ self new
		setClass: aClass;
		yourself
! !

!PPRemoveParserRefactoring methodsFor:'initialization'!

setClass: aClass
	class := self classObjectFor: aClass
! !

!PPRemoveParserRefactoring methodsFor:'preconditions'!

preconditions
	^ (self checkCompositeParser: class) & (RBCondition hasSubclasses: class) not
! !

!PPRemoveParserRefactoring methodsFor:'transforming'!

transform
	model removeClass: class
! !

!PPRemoveParserRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRemoveParserRefactoring.st,v 1.2 2014-03-04 21:18:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRemoveParserRefactoring.st,v 1.2 2014-03-04 21:18:39 cg Exp $'
! !

