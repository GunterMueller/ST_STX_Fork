"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

RemoveParameterRefactoring subclass:#InlineParameterRefactoring
	instanceVariableNames:'expressions'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!InlineParameterRefactoring class methodsFor:'instance creation'!

inlineParameter: aString in: aClass selector: aSelector 
	^self new 
		inlineParameter: aString
		in: aClass
		selector: aSelector
!

model: aRBSmalltalk inlineParameter: aString in: aClass selector: aSelector 
	^(self new)
		model: aRBSmalltalk;
		inlineParameter: aString
			in: aClass
			selector: aSelector;
		yourself
! !

!InlineParameterRefactoring methodsFor:'initialize-release'!

inlineParameter: aString in: aClass selector: aSelector
        oldSelector := aSelector.
        argument := aString.
        class := self classObjectFor: aClass.
! !

!InlineParameterRefactoring methodsFor:'preconditions'!

myConditions
	self getNewSelector.
	expressions := self allExpressionsToInline.
	^(RBCondition definesSelector: oldSelector in: class) 
		& ((RBCondition withBlock: [expressions isEmpty not]) 
				errorMacro: 'No callers. Use Remove Method instead.') 
			& ((RBCondition withBlock: [expressions size = 1]) 
					errorMacro: 'All values passed as this argument must be identical.') 
			& ((RBCondition withBlock: [expressions first isLiteral]) 
					errorMacro: 'All values passed must be literal.')
! !

!InlineParameterRefactoring methodsFor:'printing'!

printOn: aStream 
        aStream
                nextPutAll: 'Inline Parameter: ''';
                nextPutAll: argument;
                nextPutAll: ''' in: '.
        class printOn: aStream.
        aStream
                nextPutAll: ' » ';
                nextPutAll: oldSelector
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' inlineParameter: ''';
		nextPutAll: argument;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: oldSelector;
		nextPut: $)
! !

!InlineParameterRefactoring methodsFor:'private'!

allExpressionsToInline
	| coll |
	coll := Set new.
	self model allReferencesTo: oldSelector
		do: 
			[:each | 
			| tree |
			tree := each parseTree.
			tree notNil ifTrue: [coll addAll: (self expressionsToInlineFrom: tree)]].
	^coll asOrderedCollection
!

expressionsToInlineFrom: aTree 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@obj ' , (self buildSelectorString: oldSelector)
		do: 
			[:aNode :answer | 
			answer
				add: (aNode arguments at: parameterIndex);
				yourself].
	^searcher executeTree: aTree initialAnswer: OrderedCollection new
! !

!InlineParameterRefactoring methodsFor:'transforming'!

modifyImplementorParseTree: parseTree in: aClass 
	| node assignment |
	node := (parseTree arguments at: parameterIndex) copy.
	parseTree body addTemporaryNamed: node name.
	assignment := RBAssignmentNode variable: node copy value: expressions first.
	parseTree body addNodeFirst: assignment.
	super modifyImplementorParseTree: parseTree in: aClass
! !

!InlineParameterRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

