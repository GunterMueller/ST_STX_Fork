"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCNode
	instanceVariableNames:'transitions action id'
	classVariableNames:'NextId'
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCNode comment:'SmaCCNode is a node in a directed graph.

Instance Variables:
	action	<SequenceableCollection>	a collection of integers or a symbol. This contains the action to be performed when we match and can''t find a longer match.
	id	<Integer>	a unique number that allows us to sort the nodes
	transitions	<Collection of: SmaCCEdge>	our transitions

'
!


!SmaCCNode class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
! !

!SmaCCNode class methodsFor:'class initialization'!

initialize
	NextId := 0
! !

!SmaCCNode methodsFor:'compiling'!

asStatement: methodMap usingSelectorMap: aDictionary forClass: aClass 
	| stream |
	stream := WriteStream on: (String new: 128).
	self hasSimpleLoop ifTrue: [stream nextPut: $[].
	self writeMatchingCodeOn: stream usingSelectorMap: aDictionary.
	(self sortedTransitionsFor: aClass) do: 
			[:each | 
			each to == self 
				ifTrue: 
					[stream
						nextPutAll: each expression;
						nextPut: $];
						nextPutAll: ' whileTrue.';
						cr]
				ifFalse: 
					[stream
						nextPutAll: each expression;
						nextPutAll: ' ifTrue: ['.
					stream
						nextPutAll: (methodMap at: each to
									ifAbsentPut: 
										[each to 
											asStatement: methodMap
											usingSelectorMap: aDictionary
											forClass: aClass]);
						nextPutAll: '].';
						cr]].
	(transitions notEmpty or: [action isNil]) 
		ifTrue: 
			[stream
				nextPutAll: '^self reportLastMatch';
				cr].
	^stream contents
!

compileInto: aClass usingSelectorMap: aDictionary 
	| methodNodes methodMap index |
	methodNodes := self statesToMakeIntoMethods.
	methodMap := self methodNameMapFor: methodNodes.
	index := 0.
	methodNodes do: 
			[:each | 
			| stream |
			stream := WriteStream on: (String new: 1000).
			stream
				nextPutAll: (each == self 
							ifTrue: ['scanForToken']
							ifFalse: ['scan' , (index := index + 1) printString]);
				cr.
			stream nextPutAll: (each 
						asStatement: methodMap
						usingSelectorMap: aDictionary
						forClass: aClass).
			aClass 
				compile: (self optimizedParseTreeFor: stream contents) formattedCode
				classified: #'generated-scanner']
!

methodNameMapFor: methodNodes 
	| index methodMap |
	methodMap := IdentityDictionary new.
	index := 0.
	methodNodes do: 
			[:value | 
			methodMap at: value
				put: (value == self 
						ifTrue: ['^self scanForToken']
						ifFalse: ['^self scan' , (index := index + 1) printString])].
	^methodMap
!

needsSeparateMethod
	^self allStates size > 20
!

optimizationRewriter
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: 'Core.Character' with: 'Character';
		replace: '`@.Stmts1.
				[`@.Stmts2.
				currentCharacter ~~ `#l] whileTrue.
				currentCharacter == `#l ifTrue: [`@.Stmts3].
				`@.Stmts4'
			with: '`@.Stmts1.
				[`@.Stmts2.
				currentCharacter ~~ `#l] whileTrue.
				`@.Stmts3';
		replaceMethod: '`name
							`@.Stmts1.
							`@a ifTrue: [`@.Stmts2.
									^self `name].
							`@.Stmts3'
			with: '`name
				[`@.Stmts1.
				`@a] whileTrue: [`@.Stmts2].
				`@.Stmts3';
		replace: '`@.Stmts1.
				currentCharacter isLiteral ifTrue: [`@.Stmts2].
				`@.Stmts3'
			with: '`@.Stmts1.
				`@.Stmts2';
"		replace: '``@.Stmts1.
				(`@a ifTrue: [``@.Stmts2]) `{:node :dictionary | | index myStatements |
						index := node parent statements indexOf: node.
						myStatements := node parent statements.
						dictionary at: #size put: ``@.Stmts2 size - (myStatements size - index).
						index ~~  myStatements size and: [``@.Stmts2 size >= (myStatements size - index) and: [
							(index + 1 to: myStatements size) allSatisfy: [:each | 
								(myStatements at: each) = (``@.Stmts2 at: ``@.Stmts2 size - (myStatements size - each))]]]
						}.
				``@.Stmts3'
			with: '``@.Stmts1.
				`{:dictionary | RBMessageNode receiver: `@a selector: #ifTrue: arguments: (Array with: (RBBlockNode body: (RBSequenceNode statements: (``@.Stmts2 copyFrom: 1 to: (dictionary at: #size)))))}.
				``@.Stmts3';"
		replace: '`@.Stmts1.
				`.Stmt.
				`@.Stmts.
				`@a ifTrue: [self step. `.Stmt. `@.Stmts].
				`@.Stmts2'
			with: '`@.Stmts1.
				`@a ifTrue: [self step].
				`.Stmt.
				`@.Stmts.
				`@.Stmts2'.
	^rewriter
!

optimizedParseTreeFor: aString 
	| tree rewriter |
	tree := RBParser parseMethod: aString.
	rewriter := self optimizationRewriter.
	[rewriter executeTree: tree] whileTrue: [tree := rewriter tree].
	^tree
!

sortedTransitionsFor: aClass
	| frequencies |
	frequencies := (aClass realClass ifNil: [SmaCCScanner]) frequencyTable.
	^transitions asSortedCollection: 
			[:a :b | 
			| aFrequency bFrequency |
			aFrequency := a characters inject: 0
						into: [:sum :each | sum + (frequencies at: each asInteger \\ frequencies size + 1)].
			bFrequency := b characters inject: 0
						into: [:sum :each | sum + (frequencies at: each asInteger \\ frequencies size + 1)].
			aFrequency > bFrequency 
				or: [aFrequency = bFrequency and: [a characters first < b characters first]]]
!

statesToMakeIntoMethods
	| allStates incoming |
	allStates := self allStates.
	incoming := Dictionary new.
	allStates do: 
			[:each | 
			each transitions do: 
					[:edge | 
					each ~~ edge to 
						ifTrue: [(incoming at: edge to ifAbsentPut: [Set new]) add: each]]].
	^(allStates asOrderedCollection select: 
			[:each | 
			self == each or: 
					[each isTerminalNode not and: 
							[(incoming at: each ifAbsent: [#()]) size > 1 
								or: [each needsSeparateMethod]]]]) 
		asSortedCollection: [:a :b | a id < b id]
!

writeMatchingCodeOn: aStream usingSelectorMap: aDictionary 
	| matchedItem |
	action size > 0 
		ifTrue: 
			[matchedItem := aDictionary at: action first ifAbsent: [action asArray].
			aStream nextPutAll: (transitions isEmpty 
						ifTrue: ['^self recordAndReportMatch:']
						ifFalse: ['self recordMatch: ']).
			matchedItem isSymbol 
				ifTrue: [aStream nextPutAll: matchedItem storeString]
				ifFalse: 
					[aStream nextPutAll: '#('.
					matchedItem do: [:each | aStream nextPutAll: each storeString]
						separatedBy: [aStream nextPut: $ ].
					aStream nextPut: $)].
			aStream
				nextPut: $.;
				cr].
	transitions notEmpty 
		ifTrue: 
			[aStream
				nextPutAll: 'self step.';
				cr]
! !

!SmaCCNode methodsFor:'converting'!

asDFA
	self asDFA: IdentitySet new merged: Dictionary new.
	self removeDuplicateNodes.
	^self
! !

!SmaCCNode methodsFor:'edges'!

addEdgeTo: endNode 
	transitions add: (SmaCCEdge to: endNode on: nil)
!

addEdgeTo: endNode on: characterCollection 
	transitions add: (SmaCCEdge to: endNode on: characterCollection)
! !

!SmaCCNode methodsFor:'initialize-release'!

action: anObject 
	anObject isNil ifTrue: [^self].
	action := anObject isSymbol 
				ifTrue: [anObject]
				ifFalse: [SortedCollection with: anObject]
!

initialize
	id := NextId := NextId + 1.
	transitions := SortedCollection new
! !

!SmaCCNode methodsFor:'printing'!

printOn: aStream 
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: id printString;
		nextPut: $)
! !

!SmaCCNode methodsFor:'private'!

action
	^action
!

addActions: aCollection 
	aCollection isNil ifTrue: [^self].
	action isNil 
		ifTrue: 
			[action := aCollection copy.
			^self].
	action isSymbol ifTrue: [^self].
	aCollection isSymbol ifTrue: [^action := aCollection].
	aCollection 
		do: [:each | (action includes: each) ifFalse: [action add: each]]
!

allCharacterTransitions: aSet into: aNode 
	| index each |
	(aSet includes: self) ifTrue: [^#()].
	aSet add: self.
	aNode addActions: action.
	index := 1.
	[index <= transitions size] whileTrue: 
			[each := transitions at: index.
			index := index + 1.
			each isEpsilonTransition 
				ifTrue: [each to allCharacterTransitions: aSet into: aNode]
				ifFalse: 
					[(aNode transitions includes: each) ifFalse: [aNode transitions add: each]]]
!

allCharacterTransitionsAndActionsInto: aNode 
	| seen |
	seen := IdentitySet new.
	self allCharacterTransitions: seen into: aNode
!

allStates
	| nodes |
	nodes := Set new.
	self allStatesInto: nodes.
	^nodes
!

allStatesInto: aSet 
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	transitions do: [:each | each to allStatesInto: aSet]
!

asDFA: aSet merged: aDictionary 
	| newTransitions |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	newTransitions := OrderedCollection new: transitions size.
	transitions do: 
			[:each | 
			| existingEdges new |
			new := each copy.
			existingEdges := newTransitions select: [:edge | edge conflictsWith: each].
			existingEdges do: 
					[:existing | 
					| node newChars existingChars chars |
					node := aDictionary 
								at: (SortedCollection with: existing to id with: new to id) asArray
								ifAbsentPut: 
									[node := self class new.
									node transitions: ((Set 
												withAll: (existing to transitions collect: [:edge | edge copy]))
												addAll: (new to transitions collect: [:edge | edge copy]);
												yourself).
									node mergeCharacterTransitions.
									node addActions: existing to action.
									node addActions: new to action.
									node].
					newChars := new characters.
					chars := newChars select: [:char | existing includesCharacter: char].
					chars notEmpty 
						ifTrue: [newTransitions addFirst: (SmaCCEdge to: node on: chars)].
					existingChars := existing characters.
					existing removeCharacters: newChars.
					new removeCharacters: existingChars.
					existing isEmpty ifTrue: [newTransitions remove: existing]].
			new isEmpty ifFalse: [newTransitions add: new]].
	transitions := newTransitions.
	transitions do: [:each | each to asDFA: aSet merged: aDictionary]
!

asNFAWithoutEpsilonTransitions
	| seen node |
	node := self class new.
	self allCharacterTransitionsAndActionsInto: node.
	seen := IdentitySet new.
	node asNFAWithoutEpsilonTransitions: seen.
	seen := IdentitySet new.
	node removeEpsilonTransitions: seen.
	node cleanUp.
	^node
!

asNFAWithoutEpsilonTransitions: aSet 
	| index each |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	index := 1.
	[index <= transitions size] whileTrue: 
			[each := transitions at: index.
			index := index + 1.
			each isEpsilonTransition 
				ifTrue: [each to allCharacterTransitionsAndActionsInto: self]
				ifFalse: [each to asNFAWithoutEpsilonTransitions: aSet]]
!

cleanUp
	self removeDuplicateNodes.
	self mergeAllTransitions
!

id
	^id
!

mergeAllTransitions
	| nodes |
	nodes := self allStates.
	nodes do: [:each | each mergeCharacterTransitions]
!

mergeCharacterTransitions
	| toMap |
	toMap := IdentityDictionary new.
	transitions copy do: 
			[:each | 
			(toMap includesKey: each to) 
				ifTrue: 
					[(toMap at: each to) mergeWith: each.
					transitions removeIdentical: (transitions detect:[:e|e = each])
					]
				ifFalse: [toMap at: each to put: each]]
!

removeDuplicateEdges
	transitions := transitions asSet asSortedCollection
!

removeDuplicateNodes
	| nodes |
	
	[nodes := self allStates.
	nodes do: 
			[:each | 
			each
				mergeCharacterTransitions;
				removeDuplicateEdges].
	self removeDuplicateNodes: nodes] 
			whileTrue
!

removeDuplicateNodes: aCollection 
	| merged nodePartition |
	merged := false.
	nodePartition := Dictionary new.
	aCollection do: 
			[:each | 
			(nodePartition at: (Array with: each transitions size with: each action)
				ifAbsentPut: [OrderedCollection new]) add: each].
	nodePartition do: 
			[:each | 
			| seen |
			seen := OrderedCollection new.
			each do: 
					[:node | 
					| existingNode |
					existingNode := seen 
								detect: [:otherNode | otherNode transitionsMatch: node]
								ifNone: [nil].
					existingNode isNil 
						ifTrue: [seen add: node]
						ifFalse: 
							[merged := true.
							node oneWayBecome: existingNode]]].
	^merged
!

removeEpsilonTransitions: aSet 
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	transitions copy 
		do: [:each | each isEpsilonTransition ifTrue: [transitions remove: each]].
	transitions do: [:each | each to removeEpsilonTransitions: aSet]
!

transitions
	^transitions
!

transitions: aCollection 
	transitions := aCollection asSortedCollection
!

transitionsMatch: aNode 
	^aNode transitions allSatisfy: 
			[:each | 
			(transitions includes: each) or: 
					[each to = aNode and: 
							[each characters 
								= (transitions detect: [:edge | edge to = self] ifNone: [^false]) 
										characters]]]
! !

!SmaCCNode methodsFor:'public'!

hasSimpleLoop
	^transitions anySatisfy: [:each | each to == self]
!

isTerminalNode
	^transitions isEmpty or: [transitions size = 1 and: [self hasSimpleLoop]]
!

simulate: aStream 
	| char |
	aStream atEnd ifTrue: [^action].
	char := aStream next.
	transitions 
		do: [:each | (each characters includes: char) ifTrue: [^each to simulate: aStream]].
	^action
! !

!SmaCCNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCNode.st,v 1.1 2006-02-09 21:17:46 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

SmaCCNode initialize!
