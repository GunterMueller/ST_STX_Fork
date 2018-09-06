"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RefactoryChangeManager
	instanceVariableNames:'undo redo isPerformingRefactoring'
	classVariableNames:'Instance UndoSize'
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RefactoryChangeManager class methodsFor:'instance creation'!

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

!RefactoryChangeManager class methodsFor:'class initialization'!

initialize
        self nuke.
        UndoSize := 50
!

undoSize
	^UndoSize
!

undoSize: anInteger 
	UndoSize := anInteger max: 0
! !

!RefactoryChangeManager class methodsFor:'public access'!

nuke
	Instance notNil ifTrue: [Instance release].
	Instance := nil
!

performChange:changes
    ^ self instance performChange: changes
! !

!RefactoryChangeManager methodsFor:'initialization & release'!

connectToChanges
	ChangeSet addDependent: self
!

disconnectFromChanges
	ChangeSet removeDependent: self
!

initialize
	undo := OrderedCollection new.
	redo := OrderedCollection new.
	isPerformingRefactoring := false.
	self connectToChanges
!

release
	super release.
	self disconnectFromChanges
! !

!RefactoryChangeManager methodsFor:'private'!

clearUndoRedoList
	undo := OrderedCollection new.
	redo := OrderedCollection new
! !

!RefactoryChangeManager methodsFor:'public access'!

addUndo: aRefactoringChange 
	undo addLast: aRefactoringChange.
	undo size > UndoSize ifTrue: [undo removeFirst].
	redo := OrderedCollection new
!

ignoreChangesWhile: aBlock 
	isPerformingRefactoring ifTrue: [^aBlock value].
	isPerformingRefactoring := true.
	aBlock ensure: [isPerformingRefactoring := false]
!

performChange: aRefactoringChange 
	self ignoreChangesWhile: [self addUndo: aRefactoringChange execute]
!

performChange: aRefactoringChange withMessage: aString 
        self ignoreChangesWhile: [ self addUndo: (aRefactoringChange executeWithMessage: aString) ]

    "Modified (format): / 30-04-2016 / 20:20:26 / cg"
!

redoChange
	^redo last
!

redoOperation
	redo isEmpty ifTrue: [^self].
	self ignoreChangesWhile: 
			[| change |
			change := redo removeLast.
			undo add: change execute]
!

undoChange
	^undo last
!

undoOperation
	undo isEmpty ifTrue: [^self].
	self ignoreChangesWhile: 
			[| change |
			change := undo removeLast.
			redo add: change execute]
!

undoableOperations
        ^ undo 
! !

!RefactoryChangeManager methodsFor:'testing'!

hasRedoableOperations
	^redo isEmpty not
!

hasUndoableOperations
	^undo isEmpty not
! !

!RefactoryChangeManager methodsFor:'updating'!

update: anAspectSymbol with: aParameter from: aSender 
	| changeType |
	(aSender == ChangeSet and: [isPerformingRefactoring not]) ifFalse: [^self].
	anAspectSymbol == #reorganizeClass: ifTrue: [^self].
	changeType := (anAspectSymbol isString 
				ifTrue: [anAspectSymbol asString]
				ifFalse: ['class']) asLowercase.
	(changeType indexOfSubCollection: 'class' startingAt: 1) 
		+ (changeType indexOfSubCollection: 'selector' startingAt: 1) > 0 
		ifTrue: [self clearUndoRedoList]
! !

!RefactoryChangeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


RefactoryChangeManager initialize!
