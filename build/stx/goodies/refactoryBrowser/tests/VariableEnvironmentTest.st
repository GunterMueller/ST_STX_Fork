"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

BrowserEnvironmentTest subclass:#VariableEnvironmentTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!VariableEnvironmentTest methodsFor:'tests'!

testAddRemove
	| refs |
	refs := VariableEnvironment new.
	refs addClass: RefactoringManager instanceVariable: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses = 1.
	refs removeClass: RefactoringManager instanceVariable: 'refactorings'.
	self assert: refs numberSelectors = 0.
	self assert: refs numberClasses = 0.
	refs addClass: RefactoringManager instanceVariableReader: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses = 1.
	refs removeClass: RefactoringManager instanceVariableReader: 'refactorings'.
	self assert: refs numberSelectors = 0.
	self assert: refs numberClasses = 0.
	refs addClass: RefactoringManager instanceVariableWriter: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses = 1.
	refs removeClass: RefactoringManager instanceVariableWriter: 'refactorings'.
	self assert: refs numberSelectors = 0.
	self assert: refs numberClasses = 0
!

testInstVars
	| refs writers readers |
	refs := VariableEnvironment referencesToInstanceVariable: 'refactorings'
				in: RefactoringManager.
	writers := VariableEnvironment writersOfInstanceVariable: 'refactorings'
				in: RefactoringManager.
	readers := VariableEnvironment readersOfInstanceVariable: 'refactorings'
				in: RefactoringManager.
	self universalTestFor: refs.
	self universalTestFor: writers.
	self universalTestFor: readers.
	self assert: refs numberSelectors = (writers | readers) numberSelectors
! !

!VariableEnvironmentTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/VariableEnvironmentTest.st,v 1.3 2003-10-06 14:39:34 cg Exp $'
! !
