"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#InlineTemporaryRefactoring
	instanceVariableNames:'sourceInterval selector sourceTree assignmentNode definingNode'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!InlineTemporaryRefactoring class methodsFor:'instance creation'!

inline: anInterval from: aSelector in: aClass 
	^self new 
		inline: anInterval
		from: aSelector
		in: aClass
!

model: aRBSmalltalk inline: anInterval from: aSelector in: aClass 
	^(self new)
		model: aRBSmalltalk;
		inline: anInterval
			from: aSelector
			in: aClass;
		yourself
! !

!InlineTemporaryRefactoring methodsFor:'initialize-release'!

inline: anInterval from: aSelector in: aClass 
	class := self classObjectFor: aClass.
	selector := aSelector.
	sourceInterval := anInterval
! !

!InlineTemporaryRefactoring methodsFor:'performing'!

isWrittenBeforeRead
        ^(RBReadBeforeWrittenTester 
                readBeforeWritten: (Array with: assignmentNode variable name)
                in: definingNode) isEmpty
! !

!InlineTemporaryRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition definesSelector: selector in: class) 
                & (RBCondition withBlock: 
                                        [self verifySelectedInterval.
                                        true])
!

verifySelectedInterval
        sourceTree := class parseTreeFor: selector.
        sourceTree isNil ifTrue: [self refactoringError: 'Could not parse source'].
        assignmentNode := sourceTree whichNodeIsContainedBy: sourceInterval.
        assignmentNode isAssignment 
                ifFalse: 
                        [self refactoringError: 'The selected node is not an assignment statement'].
        definingNode := assignmentNode whoDefines: assignmentNode variable name.
        self hasOnlyOneAssignment 
                ifFalse: 
                        [self refactoringError: 'There are multiple assignments to the variable'].
        (RBReadBeforeWrittenTester isVariable: assignmentNode variable name
                writtenBeforeReadIn: definingNode) 
                        ifFalse: 
                                [self 
                                        refactoringError: 'The variable is possible read before it is assigned']
! !

!InlineTemporaryRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' inline: '.
	sourceInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!InlineTemporaryRefactoring methodsFor:'testing'!

hasOnlyOneAssignment
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: assignmentNode variable name , ' := ``@object'
		do: [:aNode :answer | answer + 1].
	^(searcher executeTree: definingNode initialAnswer: 0) == 1
! !

!InlineTemporaryRefactoring methodsFor:'transforming'!

compileMethod
	class compileTree: sourceTree
!

replaceAssignment
	assignmentNode parent isSequence 
		ifTrue: [assignmentNode parent removeNode: assignmentNode]
		ifFalse: [assignmentNode replaceWith: assignmentNode value]
!

replaceReferences
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replaceTree: assignmentNode variable
		withTree: assignmentNode value.
	definingNode removeTemporaryNamed: assignmentNode variable name.
	rewriter executeTree: definingNode
!

transform
	self
		replaceAssignment;
		replaceReferences;
		compileMethod
! !

!InlineTemporaryRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/InlineTemporaryRefactoring.st,v 1.11 2004-06-18 08:15:02 ca Exp $'
! !
