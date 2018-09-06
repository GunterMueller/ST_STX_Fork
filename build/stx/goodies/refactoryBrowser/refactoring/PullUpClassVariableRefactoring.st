"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#PullUpClassVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!PullUpClassVariableRefactoring methodsFor:'preconditions'!

preconditions
	^(RBCondition isMetaclass: class) not
! !

!PullUpClassVariableRefactoring methodsFor:'private-accessing'!

subclassDefiningVariable
	| subclasses |
	subclasses := class allSubclasses 
				select: [:each | each directlyDefinesClassVariable: variableName].
	subclasses isEmpty 
		ifTrue: 
			[self refactoringError: 'Could not find a class defining ' , variableName].
	subclasses size > 1 
		ifTrue: [self refactoringError: 'Multiple subclasses define ' , variableName].
	^subclasses asArray first
! !

!PullUpClassVariableRefactoring methodsFor:'transforming'!

transform
	| subclass |
	subclass := self subclassDefiningVariable.
	subclass removeClassVariable: variableName.
	class addClassVariable: variableName
! !

!PullUpClassVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/PullUpClassVariableRefactoring.st,v 1.10 2003-09-23 10:39:55 cg Exp $'
! !
