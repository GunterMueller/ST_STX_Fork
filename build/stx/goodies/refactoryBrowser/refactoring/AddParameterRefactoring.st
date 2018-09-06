"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

ChangeMethodNameRefactoring subclass:#AddParameterRefactoring
	instanceVariableNames:'initializer senders'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AddParameterRefactoring class methodsFor:'instance creation'!

addParameterToMethod: aSelector in: aClass newSelector: newSelector initializer: init 
	^self new addParameterToMethod: aSelector
		in: aClass
		newSelector: newSelector
		initializer: init
!

model: aRBSmalltalk addParameterToMethod: aSelector in: aClass newSelector: newSelector initializer: init 
	^(self new)
		model: aRBSmalltalk;
		addParameterToMethod: aSelector
			in: aClass
			newSelector: newSelector
			initializer: init;
		yourself
! !

!AddParameterRefactoring methodsFor:'initialize-release'!

addParameterToMethod: aSelector in: aClass newSelector: newSel initializer: init 
	self 
		renameMethod: aSelector
		in: aClass
		to: newSel
		permuation: (1 to: newSel numArgs).
	initializer := init
! !

!AddParameterRefactoring methodsFor:'preconditions'!

checkSendersAccessTo: name 
	| violatorClass |
	(#('self' 'super') includes: name) ifTrue: [^self].
	violatorClass := self senders 
				detect: [:each | (self canReferenceVariable: name in: each) not]
				ifNone: [nil].
	violatorClass notNil 
		ifTrue: 
			[self refactoringError: ('<1s> doesn''t appear to be defined in <2p>' 
						expandMacrosWith: name
						with: violatorClass)]
!

checkVariableReferencesIn: aParseTree 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`var'
		do: 
			[:aNode :answer | 
			| name |
			name := aNode name.
			(aNode whoDefines: name) isNil ifTrue: [self checkSendersAccessTo: name]].
	searcher executeTree: aParseTree
!

myConditions
	^RBCondition withBlock: 
			[oldSelector numArgs + 1 = newSelector numArgs 
				ifFalse: 
					[self refactoringError: newSelector printString 
								, ' doesn''t have the proper number of arguments.'].
			self verifyInitializationExpression.
			true]
!

verifyInitializationExpression
	| tree |
	tree := RBParser parseExpression: initializer
				onError: 
					[:msg :index | 
					self refactoringError: 'Illegal initialization code because:.' , msg].
	tree isValue 
		ifFalse: 
			[self 
				refactoringError: 'The initialization code cannot be a return node or a list of statements'].
	self checkVariableReferencesIn: tree
! !

!AddParameterRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addParameterToMethod: #';
		nextPutAll: oldSelector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' newSelector: #';
		nextPutAll: newSelector;
		nextPutAll: ' initializer: ''';
		nextPutAll: initializer;
		nextPutAll: ''')'
! !

!AddParameterRefactoring methodsFor:'private'!

allTemporaryVariables
	| imps |
	imps := self allImplementorsOf: oldSelector.
	^imps inject: Set new
		into: 
			[:set :each | 
			| parseTree |
			parseTree := each parseTreeFor: oldSelector.
			parseTree notNil ifTrue: [set addAll: parseTree allDefinedVariables].
			set]
!

modifyImplementorParseTree: parseTree in: aClass 
	| name newArg allTempVars |
	allTempVars := parseTree allDefinedVariables.
	name := self safeVariableNameFor: aClass temporaries: allTempVars.
	newArg := RBVariableNode named: name.
	parseTree arguments: parseTree arguments , (Array with: newArg).
	super modifyImplementorParseTree: parseTree in: aClass
!

newSelectorString
        | stream keywords numParts|
        stream := WriteStream on:''.
        keywords := newSelector keywords.
        numParts := keywords size.
        1 to: numParts
                do: 
                        [:i | 
                        stream nextPutAll: (keywords at: i).
                        i == numParts 
                                ifTrue: 
                                        [stream
                                                nextPut: $(;
                                                nextPutAll: initializer;
                                                nextPut: $)]
                                ifFalse: 
                                        [stream
                                                nextPutAll: ' ``@arg';
                                                nextPutAll: i printString].
                        stream nextPut: $ ].
        ^stream contents
!

parseTreeRewriter
	| rewriteRule oldString newString |
	rewriteRule := ParseTreeRewriter new.
	oldString := self buildSelectorString: oldSelector.
	newString := self newSelectorString.
	rewriteRule replace: '``@object ' , oldString
		with: '``@object ' , newString.
	^rewriteRule
!

safeVariableNameBasedOn: aString 
	"Creates an unused variable name containing aString"

	| baseString newString i imps allTempVars |
	allTempVars := self allTemporaryVariables.
	baseString := aString copy.
	baseString at: 1 put: baseString first asLowercase.
	newString := baseString.
	imps := self allImplementorsOf: oldSelector.
	i := 0.
	
	[(allTempVars includes: newString) or: 
			[(imps detect: [:each | (self whichClass: each defines: newString) notNil]
				ifNone: [nil]) notNil]] 
			whileTrue: 
				[i := i + 1.
				newString := baseString , i printString].
	^newString
!

safeVariableNameFor: aClass temporaries: allTempVars 
	| baseString i newString |
	newString := baseString := 'anObject'.
	i := 0.
	
	[(allTempVars includes: newString) 
		or: [aClass definesInstanceVariable: newString]] 
			whileTrue: 
				[i := i + 1.
				newString := baseString , i printString].
	^newString
!

senders
	senders isNil 
		ifTrue: 
			[senders := Set new.
			self model allReferencesTo: oldSelector
				do: [:each | senders add: each modelClass]].
	^senders
! !

!AddParameterRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

