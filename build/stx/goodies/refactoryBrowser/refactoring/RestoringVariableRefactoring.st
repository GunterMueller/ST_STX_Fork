"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#RestoringVariableRefactoring
	instanceVariableNames:'instances values'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RestoringVariableRefactoring methodsFor:'initialize-release'!

initialize
	super initialize.
	instances := OrderedCollection new.
	values := OrderedCollection new
! !

!RestoringVariableRefactoring methodsFor:'performing'!

addInstancesAndValuesFor: aClass 
        | index newInstances |
        index := aClass allInstVarNames indexOf: variableName ifAbsent: [^self].
        newInstances := aClass allInstances.
        instances addAll: newInstances.
        newInstances do: [:each | values add: (each instVarAt: index)].
        aClass subclasses do: [:each | self addInstancesAndValuesFor: each]
!

newVariableName
        ^variableName
!

resetValues
	1 to: instances size
		do: 
			[:i | 
			| index each |
			each := instances at: i.
			index := each class allInstVarNames indexOf: self newVariableName ifAbsent: [0].
			index == 0 ifFalse: [each instVarAt: index put: (values at: i)]]
! !

!RestoringVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RestoringVariableRefactoring.st,v 1.6 2003-09-23 10:40:44 cg Exp $'
! !
