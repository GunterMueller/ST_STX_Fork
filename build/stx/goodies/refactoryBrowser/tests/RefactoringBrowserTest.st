"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

TestCase subclass:#RefactoringBrowserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RefactoringBrowserTest methodsFor:'private'!

convertInterval: anInterval for: aString 
	"Convert the interval to ignore differences in end of line conventions."

	^anInterval
!

executeRefactoring: aRefactoring 
	aRefactoring primitiveExecute.
	RBParser parseExpression: aRefactoring storeString
!

objectClassVariable
	^Object classPool keys detect: [:each | true]
!

proceedThroughWarning: aBlock 
	aBlock on: RefactoringWarning do: [:ex | ex proceed]
! !

!RefactoringBrowserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RefactoringBrowserTest.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
