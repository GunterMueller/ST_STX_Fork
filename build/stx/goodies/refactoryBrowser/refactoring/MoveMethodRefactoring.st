"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#MoveMethodRefactoring
	instanceVariableNames:'selector variable moveToClasses parseTree hasOnlySelfReturns
		selfVariableName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!MoveMethodRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk selector: aSymbol class: aClass variable: aVariableName 
	^(self new)
		model: aRBSmalltalk;
		selector: aSymbol
			class: aClass
			variable: aVariableName;
		yourself
!

selector: aSymbol class: aClass variable: aVariableName 
	^(self new)
		selector: aSymbol
			class: aClass
			variable: aVariableName;
		yourself
! !

!MoveMethodRefactoring methodsFor:'initialize-release'!

selector: aSymbol class: aClass variable: aVariableName 
	selector := aSymbol.
	class := self classObjectFor: aClass.
	variable := aVariableName
! !

!MoveMethodRefactoring methodsFor:'preconditions'!

checkAssignmentsToVariable
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: variable , ' := `@object' do: [:aNode :answer | true].
	(searcher executeTree: parseTree initialAnswer: false) 
		ifTrue: 
			[self refactoringError: ('Cannot move the method into <1s> since it is assigned' 
						expandMacrosWith: variable)]
!

checkForPrimitiveMethod
	parseTree isPrimitive 
		ifTrue: [self refactoringError: 'Cannot move primitive methods']
!

checkForSuperReferences
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: 'super `@message: `@args' do: [:aNode :answer | true].
	(searcher executeTree: parseTree initialAnswer: false) 
		ifTrue: 
			[self refactoringError: 'Cannot move the method since it has a super message send.']
!

checkTemporaryVariableNames
	| varNames |
	varNames := parseTree allDefinedVariables.
	selfVariableName notNil ifTrue: [varNames add: selfVariableName].
	varNames do: 
			[:name | 
			moveToClasses do: 
					[:each | 
					(self canReferenceVariable: name in: each) 
						ifTrue: 
							[self refactoringError: ('<1p> already defines a variable called <2s>' 
										expandMacrosWith: each
										with: name)]]]
!

preconditions
        ^(RBCondition definesSelector: selector in: class) 
                & (RBCondition withBlock: 
                                        [self buildParseTree.
                                        self checkForPrimitiveMethod.
                                        self checkForSuperReferences.
                                        self checkAssignmentsToVariable.
                                        self getClassesToMoveTo.
                                        self getArgumentNameForSelf.
                                        self checkTemporaryVariableNames.
                                        self getNewMethodName.
                                        true])
! !

!MoveMethodRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: selector;
		nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' variable: ''';
		nextPutAll: variable;
		nextPutAll: ''')'
! !

!MoveMethodRefactoring methodsFor:'private'!

buildParseTree
	parseTree := (class parseTreeFor: selector) copy.
	parseTree isNil ifTrue: [self refactoringError: 'Could not parse method']
! !

!MoveMethodRefactoring methodsFor:'private-accessing'!

getClassForGlobalOrClassVariable
	| definingClass type |
	definingClass := class whoDefinesClassVariable: variable.
	definingClass isNil 
		ifTrue: 
			[type := self model classNamed: variable.
			type isNil ifTrue: [type := self model classNamed: #Object]]
		ifFalse: [type := definingClass typeOfClassVariable: variable].
	moveToClasses := self selectVariableTypesFrom: (Array with: type)
				selected: (Array with: type).
	moveToClasses isNil ifTrue: [self refactoringError: 'Method not moved']
!

getClassesForInstanceVariable
	| definingClass typer types |
	definingClass := class whoDefinesInstanceVariable: variable.
	typer := RefactoryTyper newFor: self model.
	typer runOn: definingClass.
	types := typer typesFor: variable.
	types isEmpty 
		ifTrue: [types := OrderedCollection with: (self model classNamed: #Object)].
	moveToClasses := self selectVariableTypesFrom: types
				selected: (typer guessTypesFor: variable).
	moveToClasses isNil ifTrue: [self refactoringError: 'Method not moved']
!

getClassesForTemporaryVariable
	| types |
	types := RefactoryTyper 
				typesFor: variable
				in: parseTree
				model: self model.
	types isEmpty 
		ifTrue: [types := OrderedCollection with: (self model classNamed: #Object)].
	moveToClasses := self selectVariableTypesFrom: types selected: types.
	moveToClasses isNil ifTrue: [self refactoringError: 'Method not moved']
!

getClassesToMoveTo
	self isMovingToArgument 
		ifTrue: [self getClassesForTemporaryVariable]
		ifFalse: 
			[self isMovingToInstVar 
				ifTrue: [self getClassesForInstanceVariable]
				ifFalse: [self getClassForGlobalOrClassVariable]].
	moveToClasses isEmpty 
		ifTrue: [self refactoringError: 'No classes selected, method not moved.']
! !

!MoveMethodRefactoring methodsFor:'testing'!

hasSelfReferences
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: 'self' do: [:aNode :answer | true].
	self hasOnlySelfReturns 
		ifTrue: [searcher matches: '^self' do: [:aNode :answer | answer]].
	^searcher executeTree: parseTree initialAnswer: false
!

isMovingToArgument
	^(parseTree arguments collect: [:each | each name]) includes: variable
!

isMovingToInstVar
	^self isMovingToArgument not 
		and: [(class whoDefinesInstanceVariable: variable) notNil]
!

needsToReplaceSelfReferences
	^self hasSelfReferences 
		or: [self abstractVariablesRefactoring hasVariablesToAbstract]
! !

!MoveMethodRefactoring methodsFor:'transforming'!

abstractVariables
	self performComponentRefactoring: self abstractVariablesRefactoring.
	parseTree := self abstractVariablesRefactoring parseTree
!

abstractVariablesRefactoring
	^AbstractVariablesRefactoring 
		model: self model
		abstractVariablesIn: parseTree
		from: class
		toAll: moveToClasses
		ignoring: variable
!

addSelfReturn
	self hasOnlySelfReturns ifTrue: [^self].
	parseTree addSelfReturn
!

compileDelagatorMethod
	| statementNode delegatorNode tree |
	delegatorNode := RBMessageNode 
				receiver: (RBVariableNode named: variable)
				selectorParts: parseTree selectorParts
				arguments: (parseTree argumentNames collect: 
							[:each | 
							RBVariableNode 
								named: (each = selfVariableName ifTrue: ['self'] ifFalse: [each])]).
	self hasOnlySelfReturns 
		ifFalse: [delegatorNode := RBReturnNode value: delegatorNode].
	statementNode := RBSequenceNode temporaries: #()
				statements: (Array with: delegatorNode).
	(tree := class parseTreeFor: selector) body: statementNode.
	class compileTree: tree
!

compileNewMethods
	moveToClasses 
		do: [:each | each compileTree: parseTree classified: (class protocolsFor: selector)]
!

getArgumentNameForSelf
	self needsToReplaceSelfReferences ifFalse: [^self].
	
	[selfVariableName := self requestSelfArgumentName.
	(self checkInstanceVariableName: selfVariableName in: class) 
		ifTrue: 
			[self verifyTemporaryVariableDoesNotOverride 
				ifFalse: 
					[self 
						refactoringWarning: 'The variable is already defined in one of the classes you''re moving the method to.<n>Try another?' 
								expandMacros.
					selfVariableName := nil]]
		ifFalse: 
			[self 
				refactoringWarning: 'The variable name is not a valid Smalltalk temporary variable name<n>Try again?' 
						expandMacros.
			selfVariableName := nil].
	selfVariableName isNil] 
			whileTrue: []
!

getNewMethodName
	| newSelector parameters alreadyDefined methodName newMethodName |
	parameters := parseTree argumentNames asOrderedCollection.
	parameters remove: variable ifAbsent: [].
	self needsToReplaceSelfReferences 
		ifTrue: [parameters add: selfVariableName].
	methodName := RBMethodName selector: selector arguments: parameters.
	
	[newMethodName := self requestMethodNameFor: methodName.
	newMethodName isNil ifTrue: [self refactoringError: 'Did not move method'].
	newMethodName isValid 
		ifTrue: [newSelector := newMethodName selector]
		ifFalse: [self refactoringWarning: 'Invalid method name'].
	parameters := newMethodName arguments.
	(self checkMethodName: newSelector in: class) 
		ifFalse: 
			[self refactoringWarning: newSelector , ' is not a valid selector name.'.
			newSelector := nil].
	alreadyDefined := moveToClasses 
				detect: [:each | each hierarchyDefinesMethod: newSelector]
				ifNone: [nil].
	alreadyDefined notNil 
		ifTrue: 
			[self 
				refactoringWarning: ('<1s> is already defined by <2p> or a super/subclass<n>Try another?' 
						expandMacrosWith: newSelector
						with: alreadyDefined).
			newSelector := nil].
	newSelector isNil] 
			whileTrue: [].
	parseTree
		arguments: (parameters collect: [:each | RBVariableNode named: each]) 
					asArray;
		selector: newSelector
!

hasOnlySelfReturns
	^hasOnlySelfReturns isNil 
		ifTrue: 
			[| searcher |
			searcher := ParseTreeSearcher new.
			searcher
				matches: '^self' do: [:aNode :answer | answer];
				matches: '^`@object' do: [:aNode :answer | false].
			hasOnlySelfReturns := searcher executeTree: parseTree initialAnswer: true]
		ifFalse: [hasOnlySelfReturns]
!

replaceSelfReferences
	| replacer |
	replacer := ParseTreeRewriter new.
	replacer replace: 'self' with: selfVariableName.
	self hasOnlySelfReturns ifTrue: [replacer replace: '^self' with: '^self'].
	replacer executeTree: parseTree.
	parseTree := replacer tree
!

replaceVariableReferences
	| replacer |
	replacer := ParseTreeRewriter new.
	replacer replace: variable with: 'self'.
	replacer executeTree: parseTree.
	parseTree := replacer tree
!

transform
	self
		abstractVariables;
		addSelfReturn;
		replaceSelfReferences;
		replaceVariableReferences;
		compileNewMethods;
		compileDelagatorMethod
!

verifyTemporaryVariableDoesNotOverride
	(parseTree allDefinedVariables includes: selfVariableName) 
		ifTrue: [^false].
	moveToClasses 
		do: [:each | (each definesVariable: selfVariableName) ifTrue: [^false]].
	^true
! !

!MoveMethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/MoveMethodRefactoring.st,v 1.11 2004-06-18 08:14:47 ca Exp $'
! !
