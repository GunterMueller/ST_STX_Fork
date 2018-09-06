"{ Package: 'stx:goodies/petitparser/gui' }"

Object subclass:#PPRefactoringUtils
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Core'
!


!PPRefactoringUtils methodsFor:'private refactoring'!

handleError: anException
	anException actionBlock isNil
		ifTrue: [ UIManager default inform: anException messageText ]
		ifFalse: [ 
			(UIManager default confirm: anException messageText) 
				ifTrue: [ anException actionBlock value ] ].
	anException return
!

handleWarning: anException 
	| message |
	message := (anException messageText endsWith: '?')
		ifTrue: [ anException messageText ]
		ifFalse: [ anException messageText , String cr , 'Do you want to proceed?' ].
	(UIManager default confirm: message)
		ifTrue: [ anException resume ]
		ifFalse: [ anException return ]
!

performRefactoring: aRefactoring
	[ [ aRefactoring execute ]
		on: RBRefactoringWarning
		do: [ :exception | self handleWarning: exception ] ]
		on: RBRefactoringError
		do: [ :exception | self handleError: exception ]
!

performRenameProduction: oldName from: class
	| refactoring newName |
	newName := UIManager default request: 'Production name:' initialAnswer: oldName.
	refactoring := PPRenameProdcutionRefactoring onClass: class rename: oldName to: newName.
	self performRefactoring: refactoring.
	^ refactoring
! !

!PPRefactoringUtils class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRefactoringUtils.st,v 1.1 2014-03-04 21:14:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPRefactoringUtils.st,v 1.1 2014-03-04 21:14:51 cg Exp $'
! !

