"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#ExpandReferencedPoolsRefactoring
	instanceVariableNames:'pools fromClass parseTree toClasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!

ExpandReferencedPoolsRefactoring comment:'ExpandReferencedPoolsRefactoring is a refactoring that expands a PoolDictionary''s scope for a method that is being moved from one class to another. This refactoring is primarily used to support other, more complicated refactorings such as MoveMethod.

Instance Variables:
	fromClass	<RBClass>			The class that the method is being moved from.
	parseTree	<BRProgramNode>	The method whose pool references need to be expanded.
	pools	<Collection of: Symbol>	The collection of Pool References in parseTree.
	toClasses	<Collection of: RBClass>	The classes into which the pools must be expanded.

'
!


!ExpandReferencedPoolsRefactoring class methodsFor:'instance creation'!

forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	^(self new)
		forMethod: aParseTree
			fromClass: aClass
			toClasses: classCollection;
		yourself
!

model: aRBNamespace forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	^(self new)
		model: aRBNamespace;
		forMethod: aParseTree
			fromClass: aClass
			toClasses: classCollection;
		yourself
! !

!ExpandReferencedPoolsRefactoring methodsFor:'initialize-release'!

forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	fromClass := self model classFor: aClass.
	parseTree := aParseTree.
	toClasses := classCollection collect: [:each | self model classFor: each]
! !

!ExpandReferencedPoolsRefactoring methodsFor:'preconditions'!

preconditions
	^RBCondition empty
! !

!ExpandReferencedPoolsRefactoring methodsFor:'testing'!

hasPoolsToMove
	^pools isEmpty not
! !

!ExpandReferencedPoolsRefactoring methodsFor:'transforming'!

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
	searcher executeTree: parseTree
!

movePool: aSymbol toClass: aClass 
	| nonMetaClass |
	nonMetaClass := aClass nonMetaclass.
	(nonMetaClass definesPoolDictionary: aSymbol) 
		ifFalse: [nonMetaClass addPoolDictionary: aSymbol]
!

movePoolVariables
	pools 
		do: [:poolDict | toClasses do: [:each | self movePool: poolDict toClass: each]]
!

poolVariableNamesIn: poolName 
	^(Smalltalk at: poolName ifAbsent: [Dictionary new]) keys 
		collect: [:name | name asString]
!

transform
	self computePoolsToMove.
	self hasPoolsToMove 
		ifTrue: 
			[self 
				refactoringWarning: 'This method contains references to pools<n>which may need to be moved.' 
						expandMacros].
	self movePoolVariables
!

whichPoolDefines: varName 
	| currentClass |
	currentClass := fromClass.
	[currentClass isNil] whileFalse: 
			[currentClass allPoolDictionaryNames 
				do: [:each | ((self poolVariableNamesIn: each) includes: varName) ifTrue: [^each]].
			currentClass := currentClass superclass].
	^nil
! !

!ExpandReferencedPoolsRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ExpandReferencedPoolsRefactoring.st,v 1.4 2003-09-23 10:40:56 cg Exp $'
! !
