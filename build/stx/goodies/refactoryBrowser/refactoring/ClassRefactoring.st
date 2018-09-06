"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#ClassRefactoring
	instanceVariableNames:'className'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ClassRefactoring class methodsFor:'instance creation'!

className: aName
	^self new className: aName
!

model: aRBSmalltalk className: aName 
	^(self new)
		model: aRBSmalltalk;
		className: aName;
		yourself
! !

!ClassRefactoring methodsFor:'initialize-release'!

className: aName
	className := aName
! !

!ClassRefactoring methodsFor:'performing'!

lookupClass
	^Smalltalk at: className asSymbol
		ifAbsent: 
			[self refactoringError: 'Could not find class in Smalltalk dictionary']
! !

!ClassRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ClassRefactoring.st,v 1.7 2003-09-23 10:40:40 cg Exp $'
! !
