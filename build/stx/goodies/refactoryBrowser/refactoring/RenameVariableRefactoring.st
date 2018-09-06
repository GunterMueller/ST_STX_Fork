"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#RenameVariableRefactoring
	instanceVariableNames:'newName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RenameVariableRefactoring class methodsFor:'instance creation'!

rename: aVarName to: aName in: aClass
	^self new
		rename: aVarName
		to: aName
		in: aClass
! !

!RenameVariableRefactoring methodsFor:'initialize-release'!

rename: aVarName to: aName in: aClass
	self variable: aVarName class: aClass.
	newName := aName
! !

!RenameVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RenameVariableRefactoring.st,v 1.4 2003-09-23 10:40:11 cg Exp $'
! !
