"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#AbstractVariablesRefactoring
	instanceVariableNames:'tree fromClass instVarReaders instVarWriters classVarReaders
		classVarWriters pools toClasses ignore'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AbstractVariablesRefactoring class methodsFor:'instance creation'!

abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection 
	^self 
		abstractVariablesIn: aBRProgramNode
		from: fromBehavior
		toAll: behaviorCollection
		ignoring: nil
!

abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName 
	^self new 
		abstractVariablesIn: aBRProgramNode
		from: fromBehavior
		toAll: behaviorCollection
		ignoring: aVariableName
!

model: aRBSmalltalk abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection 
	^self 
		model: aRBSmalltalk
		abstractVariablesIn: aBRProgramNode
		from: fromBehavior
		toAll: behaviorCollection
		ignoring: nil
!

model: aRBSmalltalk abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName 
	^(self new)
		model: aRBSmalltalk;
		abstractVariablesIn: aBRProgramNode
			from: fromBehavior
			toAll: behaviorCollection
			ignoring: aVariableName;
		yourself
! !

!AbstractVariablesRefactoring methodsFor:'accessing'!

parseTree
	^tree
! !

!AbstractVariablesRefactoring methodsFor:'initialize-release'!

abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName 
	| poolRefactoring |
	tree := aBRProgramNode.
	fromClass := self classObjectFor: fromBehavior.
	toClasses := behaviorCollection 
				collect: [:each | self classObjectFor: each].
	ignore := aVariableName.
	poolRefactoring := ExpandReferencedPoolsRefactoring 
				model: self model
				forMethod: tree
				fromClass: fromClass
				toClasses: toClasses.
	self performComponentRefactoring: poolRefactoring.
	self computeVariablesToAbstract
! !

!AbstractVariablesRefactoring methodsFor:'performing'!

computePoolsToMove
	| poolVariables searcher |
	poolVariables := self poolVariableNamesFor: fromClass.
	pools := Set new.
	searcher := ParseTreeSearcher new.
	searcher matches: '`var'
		do: 
			[:aNode :answer | 
			| varName pool |
			varName := aNode name.
			(aNode whoDefines: varName) isNil 
				ifTrue: 
					[(poolVariables includes: varName) 
						ifTrue: 
							[pool := self whichPoolDefines: varName.
							pool notNil ifTrue: [pools add: pool]]]].
	searcher executeTree: tree
!

doesClass: aClass includePool: aPoolDictionary 
	^aClass sharedPools includes: aPoolDictionary
!

movePool: aPoolDictionary toClass: aClass 
	| nonMetaClass |
	nonMetaClass := aClass isMeta 
				ifTrue: [aClass soleInstance]
				ifFalse: [aClass].
	(self doesClass: nonMetaClass includePool: aPoolDictionary) 
		ifFalse: [nonMetaClass addSharedPool: aPoolDictionary]
!

movePoolVariables
	pools 
		do: [:poolDict | toClasses do: [:each | self movePool: poolDict toClass: each]]
!

poolVariableNamesIn: aPoolDictionary 
	^aPoolDictionary keys collect: [:name | name asString]
!

whichPoolDefines: varName 
	| currentClass |
	ignore = varName ifTrue: [^nil].
	currentClass := fromClass.
	[currentClass isNil] whileFalse: 
			[currentClass sharedPools 
				do: [:each | ((self poolVariableNamesIn: each) includes: varName) ifTrue: [^each]].
			currentClass := currentClass superclass].
	^nil
! !

!AbstractVariablesRefactoring methodsFor:'preconditions'!

preconditions
        ^RBCondition empty
! !

!AbstractVariablesRefactoring methodsFor:'testing'!

hasPoolsToMove
	^pools isEmpty not
!

hasVariablesToAbstract
	^(instVarReaders isEmpty 
		& instVarWriters isEmpty 
		& classVarReaders isEmpty 
		& classVarWriters isEmpty) 
		not
! !

!AbstractVariablesRefactoring methodsFor:'transforming'!

abstractClassVariable: aString 
	| refactoring rewriter nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	refactoring := CreateAccessorsForVariableRefactoring 
				model: self model
				variable: aString
				class: nonMetaClass
				classVariable: true.
	self performComponentRefactoring: refactoring.
	rewriter := ParseTreeRewriter new.
	fromClass isMeta 
		ifTrue: 
			[rewriter
				replace: aString , ' := ``@object'
					with: ('self <1s> ``@object' expandMacrosWith: refactoring setterMethod);
				replace: aString with: 'self ' , refactoring getterMethod]
		ifFalse: 
			[rewriter
				replace: aString , ' := ``@object'
					with: ('self class <1s> ``@object' 
							expandMacrosWith: refactoring setterMethod);
				replace: aString with: 'self class ' , refactoring getterMethod].
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]
!

abstractClassVariables
	| variables |
	classVarReaders isEmpty & classVarWriters isEmpty ifTrue: [^self].
	variables := Set new.
	variables
		addAll: classVarReaders;
		addAll: classVarWriters.
	variables do: [:each | self abstractClassVariable: each]
!

abstractInstanceVariable: aString 
	| refactoring rewriter |
	refactoring := CreateAccessorsForVariableRefactoring 
				model: self model
				variable: aString
				class: fromClass
				classVariable: false.
	self performComponentRefactoring: refactoring.
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: aString , ' := ``@object'
			with: ('self <1s> ``@object' expandMacrosWith: refactoring setterMethod);
		replace: aString with: 'self ' , refactoring getterMethod.
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]
!

abstractInstanceVariables
	| variables |
	instVarReaders isEmpty & instVarWriters isEmpty ifTrue: [^self].
	variables := Set new.
	variables
		addAll: instVarReaders;
		addAll: instVarWriters.
	variables do: [:each | self abstractInstanceVariable: each]
!

classVariableNames
	| nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	^(nonMetaClass allClassVariableNames collect: [:each | each asString]) asSet
!

computeVariablesToAbstract
	| searcher |
	instVarReaders := Set new.
	instVarWriters := Set new.
	classVarReaders := Set new.
	classVarWriters := Set new.
	searcher := ParseTreeSearcher new.
	searcher
		matches: '`var := ``@anything'
			do: [:aNode :answer | self processAssignmentNode: aNode];
		matches: '`var' do: [:aNode :answer | self processReferenceNode: aNode].
	searcher executeTree: tree.
	self removeDefinedClassVariables
!

instanceVariableNames
	^fromClass allInstanceVariableNames asSet
!

processAssignmentNode: aNode 
	| varName |
	varName := aNode variable name.
	ignore = varName ifTrue: [^self].
	(aNode whoDefines: varName) notNil ifTrue: [^self].
	(self instanceVariableNames includes: varName) 
		ifTrue: [instVarWriters add: varName].
	(self classVariableNames includes: varName) 
		ifTrue: [classVarWriters add: varName]
!

processReferenceNode: aNode 
	| varName |
	varName := aNode name.
	ignore = varName ifTrue: [^self].
	(aNode whoDefines: varName) notNil ifTrue: [^self].
	(self instanceVariableNames includes: varName) 
		ifTrue: [instVarReaders add: varName].
	(self classVariableNames includes: varName) 
		ifTrue: [classVarReaders add: varName]
!

removeDefinedClassVariables
	| selectionBlock nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	selectionBlock := 
			[:varName | 
			(toClasses detect: 
					[:each | 
					((each nonMetaclass) 
						includesClass: (nonMetaClass whoDefinesClassVariable: varName)) not]
				ifNone: [nil]) notNil].
	classVarReaders := classVarReaders select: selectionBlock.
	classVarWriters := classVarWriters select: selectionBlock
!

transform
	self hasVariablesToAbstract 
		ifTrue: 
			[self 
				refactoringWarning: 'This method has direct variable references which<n>will need to be converted to getter/setters.' 
						expandMacros].
	self abstractInstanceVariables.
	self abstractClassVariables
! !

!AbstractVariablesRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AbstractVariablesRefactoring.st,v 1.10 2004-06-28 07:23:15 ca Exp $'
! !
