"{ Package: 'stx:goodies/petitparser/gui' }"

Refactoring subclass:#PPRemoveProdcutionRefactoring
	instanceVariableNames:'production class'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Refactoring'
!


!PPRemoveProdcutionRefactoring class methodsFor:'instance creation'!

onClass: aClass production: aSelector
	^ self new
		setClass: aClass;
		setProduction: aSelector;
		yourself
! !

!PPRemoveProdcutionRefactoring methodsFor:'initialization'!

setClass: aClass
	class := self classObjectFor: aClass
!

setProduction: aSymbol
	production := aSymbol
! !

!PPRemoveProdcutionRefactoring methodsFor:'preconditions'!

preconditions
	^ (self checkCompositeParser: class)
		& (RBCondition definesSelector: production asSymbol in: class)
		& (RBCondition definesInstanceVariable: production asString in: class)
! !

!PPRemoveProdcutionRefactoring methodsFor:'transforming'!

transform
	class removeMethod: production asSymbol.
	class removeInstanceVariable: production asString
! !

!PPRemoveProdcutionRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRemoveProdcutionRefactoring.st,v 1.2 2014-03-04 23:33:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRemoveProdcutionRefactoring.st,v 1.2 2014-03-04 23:33:59 cg Exp $'
! !

