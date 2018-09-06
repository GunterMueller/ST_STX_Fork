"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

MethodRefactoring subclass:#ExtractToTemporaryRefactoring
	instanceVariableNames:'sourceInterval selector newVariableName parseTree'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ExtractToTemporaryRefactoring class methodsFor:'instance creation'!

extract: anInterval to: aString from: aSelector in: aClass 
	^self new 
		extract: anInterval
		to: aString
		from: aSelector
		in: aClass
!

model: aRBSmalltalk extract: anInterval to: aString from: aSelector in: aClass 
	^(self new)
		model: aRBSmalltalk;
		extract: anInterval
			to: aString
			from: aSelector
			in: aClass;
		yourself
! !

!ExtractToTemporaryRefactoring methodsFor:'initialize-release'!

extract: anInterval to: aString from: aSelector in: aClass 
	class := self classObjectFor: aClass.
	selector := aSelector.
	sourceInterval := anInterval.
	newVariableName := aString
! !

!ExtractToTemporaryRefactoring methodsFor:'performing'!

compileNewMethod:source 
    |builder|

    self halt:('obsolete ?' , '1234').
    builder := RefactoryBuilder new.
    builder compile:source in:class.
    builder doIt
!

getMethodParseTree
        | parsedSource sourceTree |

        parsedSource := source notNil ifTrue:[source] ifFalse:[ class sourceCodeAt: selector ].

        sourceTree := RBParser parseMethod: parsedSource
                               onError: [:aString :pos | nil].

        " sourceTree := class parseTreeFor: selector. "
        sourceTree isNil ifTrue: [self refactoringError: 'Could not parse method'].
        ^sourceTree

    "Modified: / 18-07-2011 / 09:41:13 / cg"
!

insertTemporaryIn: sourceTree 
	| node statementNode |
	node := sourceTree whichNodeIsContainedBy: sourceInterval.
	(node isNil) 
		ifTrue: [self refactoringError: 'Could not find messages node']
	ifFalse:[
	    node isValue
		ifFalse: [self refactoringError: 'Cannot assign to non-value nodes']
	].
	statementNode := node statementNode.
	node replaceWith: (RBVariableNode named: newVariableName).
	(statementNode parent)
		addNode: (self constructAssignmentFrom: node)
			before: (node == statementNode 
					ifTrue: [RBVariableNode named: newVariableName]
					ifFalse: [statementNode]);
		addTemporaryNamed: newVariableName
! !

!ExtractToTemporaryRefactoring methodsFor:'preconditions'!

checkVariableName
	(class whoDefinesInstanceVariable: newVariableName) notNil 
		ifTrue: 
			[self refactoringError: ('<1p> defines an instance variable named <2s>' 
						expandMacrosWith: class
						with: newVariableName)].
	(class whoDefinesClassVariable: newVariableName) notNil 
		ifTrue: 
			[self refactoringError: ('<1p> defines a class variabled named <2s>' 
						expandMacrosWith: class
						with: newVariableName)].
	(self parseTree allDefinedVariables includes: newVariableName) 
		ifTrue: 
			[self refactoringError: ('<1s> is already a temporary variable name' 
						expandMacrosWith: newVariableName)]
!

preconditions
        self assert:selector notNil.
        self assert:class notNil.

        ^(RBCondition definesSelector: selector in: class) 
                & (RBCondition isValidInstanceVariableName: newVariableName for: class) 
                        & (RBCondition withBlock: 
                                                [self verifySelectedInterval.
                                                self checkVariableName.
                                                true])
!

verifySelectedInterval
	| selectedParseTree selectedSources |
	selectedSources := self selectedSource.
	selectedParseTree := RBParser parseExpression: selectedSources
				onError: [:message :position | self refactoringError: 'Invalid selection'].
	selectedParseTree isSequence 
		ifTrue: [self refactoringError: 'Cannot assign temp to multiple statements']
! !

!ExtractToTemporaryRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' extract: '.
	sourceInterval storeOn: aStream.
	aStream
		nextPutAll: ' to: ''';
		nextPutAll: newVariableName;
		nextPutAll: ''' from: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!ExtractToTemporaryRefactoring methodsFor:'private-accessing'!

parseTree
        |sourceUsed|

        parseTree isNil 
                ifTrue: 
                        [
                        sourceUsed := source notNil 
                                        ifTrue:[source]
                                        ifFalse:[class sourceCodeFor: selector].
                        parseTree := RBParser 
                            parseMethod: sourceUsed
                            onError: [:aString :pos | nil].

                        "/ parseTree := class parseTreeFor: selector.
                        parseTree isNil ifTrue: [self refactoringError: 'Could not parse method']].
        ^parseTree
!

selectedSource
        | sourceUsed |

        sourceUsed := source notNil 
                        ifTrue:[source]
                        ifFalse:[class sourceCodeFor: selector].

        source isNil ifTrue: [self refactoringError: 'Couldn''t find sources'].
        ((sourceInterval first between: 1 and: source size) 
                and: [sourceInterval last between: 1 and: source size]) 
                        ifFalse: [self refactoringError: 'Invalid interval'].
        ^source copyFrom: sourceInterval first to: sourceInterval last
! !

!ExtractToTemporaryRefactoring methodsFor:'transforming'!

compileNewMethod
	class compileTree: self parseTree
!

constructAssignmentFrom: aNode 
	| valueNode |
	valueNode := RBVariableNode named: newVariableName.
	^RBAssignmentNode variable: valueNode value: aNode
!

insertTemporary
	| node statementNode |
	node := self parseTree whichNodeIsContainedBy: sourceInterval.
	(node notNil and: [node isValue]) 
		ifFalse: [self refactoringError: 'Cannot assign to non-value nodes'].
	statementNode := node statementNode.
	node replaceWith: (RBVariableNode named: newVariableName).
	(statementNode parent)
		addNode: (self constructAssignmentFrom: node)
			before: (node == statementNode 
					ifTrue: [RBVariableNode named: newVariableName]
					ifFalse: [statementNode]);
		addTemporaryNamed: newVariableName
!

transform
	self
		insertTemporary;
		compileNewMethod
! !

!ExtractToTemporaryRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

