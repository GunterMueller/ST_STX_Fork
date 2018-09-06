"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Object subclass:#RefactoringManager
	instanceVariableNames:'refactorings'
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RefactoringManager class methodsFor:'instance creation'!

instance
	Instance isNil
		ifTrue:
			[Instance := self basicNew.
			Instance initialize].
	^Instance
!

new
	^self shouldNotImplement
! !

!RefactoringManager class methodsFor:'class initialization'!

initialize
	Instance := nil
! !

!RefactoringManager class methodsFor:'parcel load/unload/save'!

preUnloadActionFor: aParcel
	^RefactoringManager nuke
! !

!RefactoringManager class methodsFor:'public access'!

nuke
	Instance notNil ifTrue: [Instance release].
	Instance := nil
! !

!RefactoringManager methodsFor:'initialize-release'!

initialize
	refactorings := Bag new
! !

!RefactoringManager methodsFor:'printing'!

printOn: aStream 
	aStream nextPutAll: '#		Refactoring';
		cr;
		nextPutAll: '---		-----------------------------------------------';
		cr.
	refactorings asSet asSortedCollection do: 
			[:name | 
			aStream nextPutAll: (refactorings occurrencesOf: name) printString;
				nextPutAll: '		';
				nextPutAll: name;
				cr]
! !

!RefactoringManager methodsFor:'public access'!

addRefactoring: aRefactoring 
	RefactoryChangeManager instance performChange: aRefactoring changes.
	refactorings add: aRefactoring class name
!

addRefactoring: aRefactoring performChanges: doPerformChanges
    "Helper for Tools::NewSystemBrowser>>performRefactoring:.
     See original addRefactoring"

    doPerformChanges ifTrue:[    
        RefactoryChangeManager instance performChange: aRefactoring changes.
    ].
    refactorings add: aRefactoring class name

    "Created: / 10-05-2012 / 12:56:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RefactoringManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RefactoringManager.st,v 1.10 2012-05-10 11:57:08 vrany Exp $'
! !

RefactoringManager initialize!
