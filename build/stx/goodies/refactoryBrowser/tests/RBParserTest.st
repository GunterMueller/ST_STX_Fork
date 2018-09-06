"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

"{ NameSpace: Smalltalk }"

RefactoringBrowserTest subclass:#RBParserTest
	instanceVariableNames:'currentSelector classSearches rewrites'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RBParserTest methodsFor:'accessing'!

buildArgumentSearch
        BasicLintRuleTest autoload.

        self 
                createArgumentSearchWith: 'aSmalllintContext'
                selectors: #(#checkMethod: #checkClass:)
                inClass: BasicLintRuleTest
!

buildMessageSearch
        TransformationRuleTest autoload.

        self 
                createSearchWith: '``@receiver -> ``@arg'
                selectors: #(superSends superSends)
                inClass: TransformationRuleTest
!

buildMethodArgumentSearch
        "Two argument methods"

        BasicLintRuleTest autoload.

        self 
                createMethodSearchWith: '`arg1: `arg1 `arg2: `arg2 | `@temps | `@.Stmts'
                selectors: #(#subclassOf:overrides: #createMatcherFor:method: #createParseTreeRule:name:)
                inClass: BasicLintRuleTest class
!

buildMethodSearch
        "Simple forwarders"

        TransformationRuleTest autoload.

        self 
                createMethodSearchWith: '`@methodName: `@args ^`@object `@methodName: `@args'
                selectors: #(#problemCount isEmpty)
                inClass: TransformationRuleTest
!

buildMethodTitleSearch
        BasicLintRuleTest autoload.

        self 
                createMethodSearchWith: 'initialize | `@temps | `@.Stmts'
                selectors: #(#initialize)
                inClass: BasicLintRuleTest
!

buildSimpleLiteralSearch
        | search |

        BasicLintRuleTest autoload.

        search := ParseTreeSearcher new.
        search 
                matchesAnyTreeOf: (Array with: (RBParser 
                                                parseExpression: '#(''bugs'' ''possible bugs'' ''unnecessary code'' ''intention revealing'' ''miscellaneous'')'))
                do: 
                        [:aNode :answer | 
                        answer
                                remove: self currentSelector ifAbsent: [self error: 'failed'];
                                yourself].
        search answer: #(#protocols) asBag.
        (classSearches at: BasicLintRuleTest class ifAbsentPut: [Set new]) 
                add: search
!

buildSimpleVariableSearch
        BasicLintRuleTest autoload.

        self 
                createSearchWith: 'result'
                selectors: #(#checkClass: #checkMethod: #isEmpty #problemCount #resetResult #resetResult #resetResult #result #result: #resultClass: #viewResults)
                inClass: BasicLintRuleTest
!

buildStatementSearch
        "Two or more statements"

        TransformationRuleTest autoload.

        self 
                createSearchWith: '| `@temps | ``@.Stmts1. ``.Stmt1. ``@.Stmts2. ``.Stmt2. ``@.Stmts3'
                selectors: #(#checkMethod: #rewriteUsing: #viewResults #superSends)
                inClass: TransformationRuleTest
!

compare: anObject to: anotherObject 
	self assert: anObject hash = anotherObject hash.
	self assert: anObject = anotherObject
!

createArgumentSearchWith: aCodeString selectors: selectorCollection inClass: aClass 
	| search |
	search := ParseTreeSearcher new.
	search matchesAnyArgumentOf: (Array with: aCodeString)
		do: 
			[:aNode :answer | 
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: selectorCollection asBag.
	(classSearches at: aClass ifAbsentPut: [Set new]) add: search
!

createMethodSearchWith: aCodeString selectors: selectorCollection inClass: aClass 
	| search |
	search := ParseTreeSearcher new.
	search matchesAnyMethodOf: (Array with: aCodeString)
		do: 
			[:aNode :answer | 
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: selectorCollection asBag.
	(classSearches at: aClass ifAbsentPut: [Set new]) add: search
!

createSearchWith: aCodeString selectors: selectorCollection inClass: aClass 
	| search |
	search := ParseTreeSearcher new.
	search matches: aCodeString
		do: 
			[:aNode :answer | 
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: selectorCollection asBag.
	(classSearches at: aClass ifAbsentPut: [Set new]) add: search
!

currentSelector
	^currentSelector
!

setUp
	super setUp.
	classSearches := Dictionary new.
	self
		buildMethodSearch;
		buildSimpleVariableSearch;
		buildSimpleLiteralSearch;
		buildMessageSearch;
		buildStatementSearch;
		buildArgumentSearch;
		buildMethodTitleSearch;
		buildMethodArgumentSearch
! !

!RBParserTest methodsFor:'long running'!

verifyParser
        "self new verifyParser"

        Smalltalk allBehaviorsDo: 
                        [:each | 
                        each compilerClass = Compiler 
                                ifTrue: [each selectors do: [:sel | self verifySelector: sel inClass: each]]]
!

verifyParser2
        "verifies that all methods in the system are parsable"

        "self new verifyParser2"

        Smalltalk allBehaviorsDo:[:eachClass | 
                Transcript showCR:eachClass name.
                eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                    "/ Transcript showCR:'   >> ',sel.
                    RBParser parseMethod: mthd source
                ]
        ]
! !

!RBParserTest methodsFor:'private'!

parseError: each 
	RBParser parseExpression: each first
		onError: [:string :pos | ^self assert: pos = each last].
	self error: 'Parser didn''t fail'
!

setupAsIBMWhile: aBlock 
	RBParser parserType: #IBM.
	aBlock ensure: [RBParser initialize]
!

setupAsSqueakWhile: aBlock 
	RBParser parserType: #Squeak.
	aBlock ensure: [RBParser initialize]
!

treeWithEverything
        ^RBParser 
                parseMethod: 'method: arg1 <pragma: 1> | temps | temps := #(10). { 1 + 1 }. temps foo; foo. ^(temps collect: [:e | ])'

    "Modified: / 18-06-2015 / 20:39:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

verifySelector: aSelector inClass: aClass 
	| myTree otherTree source |
	source := aClass sourceCodeAt: aSelector.
	source isNil ifTrue: [^self].
	myTree := aClass parseTreeFor: aSelector.
	otherTree := Parser new 
				parse: (ReadStream on: source)
				class: aClass
				noPattern: false
				context: nil
				notifying: "SilentCompilerErrorHandler new" nil
				ifFail: [^self].
	self assert: (myTree notNil or: [otherTree isNil]).
	"self should: 
			["
	((Compiler new 
		compile: myTree formattedCode
		in: aClass
		notifying: nil
		ifFail: [self assert: false]) generate 
		isEqualTo: (Compiler new 
				compile: otherTree formattedCode
				in: aClass
				notifying: nil
				ifFail: [self assert: false]) generate) 
			ifFalse: [self halt]
	"]"
! !

!RBParserTest methodsFor:'tests'!

testAllSearches
	|classTested selectorTested|

	classSearches keysAndValuesDo: 
			[:class :searches | 
			class selectors do: 
					[:sel | 
					currentSelector := sel.
					searches 
						do: [:each |
							classTested := class.
							selectorTested := sel.
							each executeTree: (class parseTreeFor: sel) initialAnswer: each answer]]].
	classSearches 
		do: [:searches | searches do: [:each | self assert: each answer isEmpty]]
!

testBestNodeFor
	| tree |
	tree := self treeWithEverything.
	tree nodesDo: 
			[:each | 
			each sourceInterval isEmpty 
				ifFalse: 
					[self assert: ((tree bestNodeFor: each sourceInterval) = each 
								or: [each parent isCascade and: [each parent messages last = each]])]]
!

testBlockRewrites
	| rewriter tree |
	tree := RBParser 
				parseMethod: 'method: asdf
	<primitive: 1>
	<primitive: 2>
	^asdf + self foo + asdf'.
	rewriter := ParseTreeRewriter new.
	rewriter 
		replace: 'asdf'
		with: 'fdsa'
		when: [:aNode | aNode parent parent isReturn].
	rewriter replace: 'self foo'
		withValueFrom: [:aNode | RBVariableNode named: aNode selector asString].
	rewriter 
		replaceArgument: 'asdf'
		withValueFrom: [:aNode | RBVariableNode named: 'xxx']
		when: [:aNode | false].
	rewriter executeTree: tree.
	self compare: tree
		to: (RBParser 
				parseMethod: 'method: asdf
	<primitive: 1>
	<primitive: 2>
	^asdf +  foo + fdsa')
!

testCascadeReplacement
	| cascade |
	cascade := RBParser parseExpression: 'self foo; bar; baz'.
	(cascade messages at: 2) 
		replaceWith: (RBParser parseExpression: 'self bar: 2').
	self compare: cascade
		to: (RBParser parseExpression: 'self foo; bar: 2; baz')
!

testComparingTrees
	| class |
	class := BasicLintRuleTest class.
	class selectors 
		do: [:each | self compare: (class parseTreeFor: each) to: (class parseTreeFor: each)]
!

testCopy
	| tree |
	tree := self treeWithEverything.
	self compare: tree to: tree copy
!

testCopyParent
    | tree checker |

    tree := self treeWithEverything copy.
    checker := [ :node | 
        node children do:[:each | 
            self assert: each parent == node.
            checker value: each.
        ].
    ].
    checker value: tree

    "Created: / 18-06-2015 / 20:31:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCreationProtocol
	| messageNode |
	self compare: (RBMessageNode 
				receiver: (RBVariableNode named: 'self')
				selector: #+
				arguments: (Array with: (RBLiteralNode value: 0)))
		to: (RBParser parseExpression: 'self + 0').
	messageNode := RBMessageNode receiver: (RBVariableNode named: 'self')
				selector: #foo.
	self compare: (RBMethodNode selector: #bar
				body: (RBSequenceNode statements: (Array 
								with: (RBCascadeNode messages: (Array with: messageNode with: messageNode)))))
		to: (RBParser parseMethod: 'bar self foo; foo')
!

testEquality
	self setupAsIBMWhile: 
			[| strings |
			strings := #('test test1; test2; test3: arg1' 'test test1; test2; test3: arg2' '[:arg1 | stmt1. stmt2. stmt3]' '[:arg2 | stmt1. stmt2. stmt3]' '[:arg1 | stmt1. stmt2. stmt3. stmt4]' 'a' 'b' '#literal' '''literal''' '##(Array new)' '##(Array new: 0)' '#(1 2 3)' '#[1 2 3]' '$a' '#''literal string''').
			1 to: strings size
				do: 
					[:i | 
					1 to: strings size
						do: 
							[:j | 
							self 
								deny: ((RBParser parseExpression: (strings at: i)) 
										= (RBParser parseExpression: (strings at: j)) xor: i = j)]]]
!

testEquivalentExceptRenaming
	#(('a 3-4' 'a 4-3' false ) ('a #[3 4]' 'a #(3 4)' false ) ('a variable1 ~~ "comment" variable2' 'a variable1 ~~ variable2' true ) ('a variable1' 'a variable2' false ) ('a [:a :b | a + b]' 'a [:b :a | a + b]' false ) ('a | a b | a + b' 'a | b a | a + b' true ) ('a | a | a msg1; msg2' 'a | b | b msg2; msg2' false ) ('a c' 'a d' true ) ('a | a b | a := b. ^b msg1' 'a | a b | b := a. ^a msg1' true ) ('a | a b | a := b. ^b msg1: a' 'a | a b | b := a. ^b msg1: a' false ) ('a: b b + 4' 'a: e e + 4' true ) ('a: b b + 4' 'b: b b + 4' false ) ('a: b b: c b + c' 'a: c b: b c + b' true ) ('a: a b: b a + b' 'a: b b: a a + b' false ) ) do: [:each | self assert: ((RBParser parseMethod: each first)
				equalTo: (RBParser parseMethod: (each at: 2))
				exceptForVariables: #('c' ))
				== each last asBoolean]
!

testFormatter
	| class |
	class := BasicLintRuleTest class.
	class selectors do: 
			[:each | 
			self compare: (class parseTreeFor: each)
				to: (RBParser parseMethod: (class parseTreeFor: each) printString)]
!

testIBM
	self setupAsIBMWhile: 
			[| tree searcher |
			tree := RBParser 
						parseMethod: 'test ##(Array with: 1 with: 2 with: #literal) at: ##esatom'.
			searcher := ParseTreeRewriter new.
			searcher 
				replace: '##(`@object with: `#literal1 with: `#literal2 with: `#literal3)'
				with: '##(`@object with: `#literal3 with: `#literal2 with: `#literal1)'.
			searcher executeTree: tree.
			tree := searcher tree.
			searcher := ParseTreeRewriter new.
			searcher replace: '2' with: '2.5'.
			searcher executeTree: tree.
			self 
				assert: (RBParser parseMethod: searcher tree formattedCode) = (RBParser 
								parseMethod: 'test ##(Array with: #literal with: 2.5 with: 1) at: ##esatom')]
!

testIntervals
	| tree |
	tree := self treeWithEverything.
	tree nodesDo: 
			[:each | 
			(each parent isNil or: [each parent isCascade not]) 
				ifTrue: 
					[| newNode source |
					source := tree source copyFrom: each start to: each stop.
					newNode := each isMethod 
								ifTrue: [RBParser parseMethod: source]
								ifFalse: [RBParser parseExpression: source].
					self compare: each to: newNode]]
!

testIsA
	| nodes types |
	nodes := Bag new.
	types := Set new.
	#(#(#isAssignment 1) #(#isBlock 1) #(#isCascade 1) #(#isLiteral 1) #(#isMessage 3) #(#isMethod 1) #(#isReturn 1) #(#isSequence 2) #(#isValue 14) #(#isVariable 7) #(#isUsed 9) #(#isDirectlyUsed 8) #(#hasParentheses 1) #(#isBinary 0) #(#isPrimitive 0) #(#isImmediate 9)) 
		do: 
			[:each | 
			each last timesRepeat: [nodes add: each first].
			types add: each first].
	self treeWithEverything nodesDo: 
			[:each | 
			types do: 
					[:sel | 
					((each respondsTo: sel) and: [each perform: sel]) 
						ifTrue: [nodes remove: sel]]].
	self assert: nodes isEmpty
!

testLiteralIntevals
	| tree |
	tree := RBParser parseExpression: '#(#a b #( c ))'.
	self assert: tree token value first start = 3.
	self assert: tree token value first stop = 4.
	self assert: tree token value last value first start = 11
!

testLiterals
        |formattedCode|

        formattedCode := (RBLiteralNode value: #(1 2 #(#asdf))) formattedCode. 
        self assert: ((formattedCode = '#(1 2 #(#asdf))')
                     or:[ (formattedCode = '#(1 2 #(asdf))') ])
!

testMethodPatterns
	#(#('+ a ^self + a' #+) #('foo ^self foo' #foo) #('foo: a bar: b ^a + b' #foo:bar:)) 
		do: [:each | self assert: (RBParser parseMethodPattern: each first) == each last]
!

testModifying
	| tree |
	tree := RBParser 
				parseMethod: 'foo: a bar: b | c | self first. self second. a + b + c'.
	self deny: tree lastIsReturn.
	self deny: (tree body statements at: 2) isUsed.
	self assert: tree body statements last arguments first isUsed.
	self assert: (tree isLast: tree body statements last).
	self deny: (tree isLast: tree body statements first).
	self assert: (tree defines: 'a').
	self deny: (tree defines: 'c').
	self assert: (tree body defines: 'c').
	self deny: (tree body defines: 'a').
	tree
		addReturn;
		selector: #bar:foo:.
	(tree body)
		addTemporaryNamed: 'd';
		removeTemporaryNamed: 'c'.
	self compare: tree
		to: (RBParser 
				parseMethod: 'bar: a foo: b | d | self first. self second. ^a + b + c').
	self 
		assert: ((tree argumentNames asSet)
				removeAll: #('a' 'b');
				yourself) isEmpty.
	self 
		assert: ((tree allDefinedVariables asSet)
				removeAll: #('a' 'b' 'd');
				yourself) isEmpty.
	tree := RBParser parseExpression: 'self foo: 0'.
	tree selector: #+.
	self compare: tree to: (RBParser parseExpression: 'self + 0').
	self should: [tree selector: #foo] raise: self errorSignal
!

testMultimatch
	| rewriter count |
	count := 0.
	rewriter := ParseTreeRewriter new.
	rewriter 
		replace: '``@object at: ``@foo'
		with: '``@object foo: ``@foo'
		when: [:aNode | (count := count + 1) == 2].
	self compare: (rewriter
				executeTree: (RBParser parseExpression: 'self at: (bar at: 3)');
				tree)
		to: (RBParser parseExpression: 'self at: (bar foo: 3)')
!

testNodesDo
	| size |
	size := 0.
	self treeWithEverything nodesDo: [:e | size := size + 1].
	self assert: size = 18
!

testNumberParsing
	2 to: 32
		do: 
			[:radix | 
			0 to: 72
				do: 
					[:i | 
					self 
						assert: (RBParser 
								parseExpression: radix printString , 'r' , (i printStringRadix: radix)) 
									value = i]]
!

testParserErrors
	#(#('self foo. + 3' 11) #('#(' 2) #('self 0' 6) #('self asdf;;asfd' 11)) 
		do: [:each | self parseError: each]
!

testParsingLiteralMessages
	self assert: (RBParser parseExpression: 'self nil') isMessage.
	self assert: (RBParser parseExpression: 'self true') isMessage.
	self assert: (RBParser parseExpression: 'self false') isMessage.
	self assert: (RBParser parseExpression: 'self -1') isMessage
!

testPatternCascade
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replace: 'self `;messages; foo: 4; `;messages1'
		with: 'self `;messages1; bar: 4; `;messages'.
	self compare: (rewriter
				executeTree: (RBParser 
							parseExpression: 'self foo; printString; foo: 4; bar. self foo: 4');
				tree)
		to: (RBParser 
				parseExpression: 'self bar; bar: 4; foo; printString. self foo:4')
!

testPositions
	| blockNode |
	blockNode := RBParser parseExpression: '[:a :b | ]'.
	self assert: blockNode left = 1.
	self assert: blockNode right = 10.
	self assert: blockNode bar = 8.
	self assert: blockNode sourceInterval = (1 to: 10).
	self assert: blockNode size = 1.        "test dummy collection protocol"
	blockNode printString.  "coverage"
	self deny: (blockNode isLast: (RBVariableNode named: 'b')).
	self compare: blockNode
		to: (RBBlockNode 
				arguments: (OrderedCollection with: (RBVariableNode named: 'a')
						with: (RBVariableNode named: 'b'))
				body: (RBSequenceNode statements: #())).
	self setupAsIBMWhile: 
			[| optimized |
			optimized := RBParser parseExpression: '(##(| a | a := 5. a * a))'.
			self assert: optimized startWithoutParentheses = 2.
			self assert: optimized stopWithoutParentheses = 24.
			self assert: (optimized 
						equalTo: (RBParser parseExpression: '##(| b | b := 5. b * b)')
						exceptForVariables: #()).
			self assert: optimized isImmediate.
			RBProgramNodeVisitor new visitNode: optimized.  "coverage"
			optimized body 
				replaceWith: (RBParser parseExpression: '| c | c := 5. c * 45').
			self compare: optimized
				to: (RBParser parseExpression: '##(| c | c := 5. c * 45)')]
!

testPositions2
	| msgNode |
	msgNode := RBParser parseExpression: '1 + 2'.
	self assert: msgNode sourceInterval = (1 to: 5).

    "
     self basicNew testPositions2
    "
!

testPositions3
	| msgNode |
	msgNode := RBParser parseExpression: '1'.
	self assert: msgNode sourceInterval = (1 to: 1).

    "
     self basicNew testPositions3
    "
!

testPrimitives
	self assert: (Object parseTreeFor: #basicAt:) isPrimitive.
	#(('foo ^true' false ) ('foo <some tag> ^true' false ) (' foo <some tag> <primitive: 123> ^true' true ) ) do: [:each | self assert: (RBParser parseMethod: each first) isPrimitive = each last asBoolean]
!

testQuerying
	| tree aNode arg1Node bNode |
	((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
	    tree := RBParser 
				    parseMethod: ('test: a` | b |` b := (self foo: a; bar) baz.` b := super test: b.` ^[:arg1 | self foa1 + (super foo: arg1 foo: a foo: b)]' 
						    copyReplaceAll: $`
						    with: (Character value: 13)).
	] ifFalse:[
	    tree := RBParser 
				    parseMethod: ('test: a` | b |`  b := (self foo: a; bar) baz.`   b := super test: b.`    ^[:arg1 | self foa1 + (super foo: arg1 foo: a foo: b)]' 
						    copyReplaceAll: '`'
						    with: (String with: (Character value: 13))).
	].
	self 
		assert: tree selfMessages asSortedCollection asArray = #(#bar #foa1 #foo:).
	self assert: tree superMessages asSortedCollection asArray 
				= #(#foo:foo:foo: #test:).
	aNode := tree whichNodeIsContainedBy: (112 to: 112).
	self assert: aNode name = 'a'.
	bNode := tree whichNodeIsContainedBy: (119 to: 119).
	self assert: bNode name = 'b'.
	arg1Node := tree whichNodeIsContainedBy: (102 to: 105).
	self assert: arg1Node name = 'arg1'.
	self assert: (arg1Node statementNode isMessage 
				and: [arg1Node statementNode selector = #+]).
	self assert: (arg1Node whoDefines: 'arg1') isBlock.
	self assert: (aNode whoDefines: 'a') isMethod.
	self assert: (aNode whoDefines: 'b') isSequence.
	self assert: (tree whichNodeIsContainedBy: (91 to: 119)) selector 
				= #foo:foo:foo:.
	self assert: (tree whichNodeIsContainedBy: (69 to: 121)) isBlock.
	self assert: (tree whichNodeIsContainedBy: (69 to: 118)) isNil.
	self assert: aNode blockVariables asSortedCollection asArray = #('arg1').
	self assert: aNode temporaryVariables asSortedCollection asArray = #('b').
	self assert: tree allDefinedVariables asSortedCollection asArray 
				= #('a' 'arg1' 'b').
	self assert: tree allArgumentVariables asSortedCollection asArray 
				= #('a' 'arg1').
	self 
		assert: tree allTemporaryVariables asSortedCollection asArray = #('b')
!

testReadBeforeWritten
	#(('a ifTrue: [^self]' true ) ('self foo. a := b' false ) ('condition ifTrue: [a := b] ifFalse: [self foo: a]' true ) ('condition ifTrue: [a := b] ifFalse: [self foo]. a isNil' true ) ('condition ifTrue: [a := b]. a := c' false ) ('[a := b] whileFalse: [a isNil]' false ) ('self foo: b' false ) ) do: 
		[:each | 
		self assert: ((RBReadBeforeWrittenTester readBeforeWritten: #('a' ) in: (RBParser parseExpression: each first))
				includes: 'a')
				== each last asBoolean.
		self assert: (RBReadBeforeWrittenTester isVariable: 'a' readBeforeWrittenIn: (RBParser parseExpression: each first))
				= each last asBoolean].
	#('| temp read written written1 |
			read ifTrue: [^self].
			written1 := self foo ifFalse: [written := true] ifTrue: [written := false].
			[temp := true] whileTrue: [temp notNil & written].
			^temp' '| read written |
			self foo ifTrue: [written := true] ifFalse: [written := false].
			self foo ifTrue: [read := true].
			^read' '| read written |
			self foo do: [:i | i].
			[| i | i := 1. i == 1] whileFalse: [read notNil]' '| written |
			[written := 2] whileFalse.
			self do: [:each | | read | each & read]' '| read |
			self do: [:each | read := each].
			self do: [:each | each & read]' ) do: 
		[:each | 
		| read | 
		read _ RBReadBeforeWrittenTester variablesReadBeforeWrittenIn: (RBParser parseExpression: each).
		self assert: (read size = 1 and: [read includes: 'read'])]
!

testReadBeforeWritten1
	self 
		assert: (RBReadBeforeWrittenTester variablesReadBeforeWrittenIn: (RBParser 
						parseMethod: 'addAll: aCollection 
	"Answer aCollection, having added all elements
	 of aCollection to the receiver.

	 Fail if aCollection is not a kind of
	 Collection."

	| newSize elementsSize growSize |
	(newSize := aCollection size * 2) > elements size ifTrue: [self rehash: newSize].
	elementsSize := elements size.
	growSize := elementsSize // 2.
	aCollection do: 
			[:newObject | 
			| hashIndex element |
			newObject == nil ifFalse: 
					[hashIndex := self hashIndexFor: newObject.
                                        
					[(element := elements at: hashIndex) == nil
						ifTrue: 
							[elements at: hashIndex put: newObject.
							(elementCount := elementCount + 1) > growSize ifTrue: 
									[self expand.
									elementsSize := elements size.
									growSize := elementsSize // 2].
							true]
						ifFalse: [element == newObject]]
							whileFalse: 
								[(hashIndex := hashIndex + 1) > elementsSize ifTrue: [hashIndex := 1]]]].
	^aCollection')) 
				isEmpty
!

testReplacingNodes
	| tree search block |
	tree := RBParser 
				parseMethod: '+ a | a b | self ifTrue: [a] ifFalse: [b := c]. a := b. [:b :c :a | a foo: a; foo1: a; foo2: a foo: b]. ^a'.
	search := ParseTreeSearcher new.
	block := [:aNode :answer | aNode replaceWith: (RBVariableNode named: 'q')].
	search
		matches: 'a' do: block;
		matchesArgument: 'a' do: block.
	search executeTree: tree.
	self 
		assert: tree = (RBParser 
						parseMethod: '+ q | q b | self ifTrue: [q] ifFalse: [b := c]. q := b. [:b :c :q | q foo: q; foo1: q; foo2: q foo: b]. ^q').
	self 
		assert: tree removeDeadCode = (RBParser 
						parseMethod: '+ q | q b | self ifTrue: [] ifFalse: [b := c]. q := b. ^q')
!

testRewriteMethods
	#(#('arg1: a arg2: b | temp1 temp2 | self stmt1 ifTrue: [^a]. self arg1: a arg2: b' 'arg2: a arg1: b | temp1 temp2 | self stmt1 ifTrue: [^a]. self arg2: b arg2: a' '`arg1: `var1 `arg2: `var2 | `@temps | ``@.stmts. self `arg1: `var1 `arg2: `var2. `@.stmts1' '`arg2: `var1 `arg1: `var2 | `@temps | ``@.stmts. self `arg2: `var2 `arg2: `var1. `@.stmts1') #('arg1: a arg2: b | temp1 temp2 | self stmt1. self arg1: a arg2: b' 'arg1: a arg2: b | temp1 temp2 | [self stmt1] repeat' '`@args: `@vars | `@temps | `@.stmts. self `@args: `@vars' '`@args: `@vars | `@temps | [`@.stmts] repeat') #('+ a | temps | ^self primitiveValue' '- a | temps | ^self primitiveValue' '+ `temp | `@tmps | `@.stmts' '- `temp | `@tmps | `@.stmts') #('a self stmt1. self stmt2' 'a self stmt1. self stmt2' 'b | `@temps | `@.stmts' 'c | `@temps | `@.stmts')) 
		do: 
			[:each | 
			| rewrite |
			rewrite := ParseTreeRewriter new.
			rewrite replaceMethod: (each at: 3) with: each last.
			self compare: (RBParser 
						parseMethod: (rewrite
								executeTree: (RBParser parseMethod: each first);
								tree) formattedCode)
				to: (RBParser parseMethod: (each at: 2)).
			rewrite := ParseTreeRewriter new.
			rewrite replaceTree: (RBParser parseRewriteMethod: (each at: 3))
				withTree: (RBParser parseRewriteMethod: each last).
			self compare: (RBParser 
						parseMethod: (rewrite
								executeTree: (RBParser parseMethod: each first);
								tree) formattedCode)
				to: (RBParser parseMethod: (each at: 2))]
!

testRewrites
	#(('[:c | |a| a foo1; foo2]' '[:c | |a| b foo1; foo2]' 'a' 'b' ) ('self foo: 1. bar foo1 foo: 2. (self foo: a) foo: (b foo: c)' 'self bar: 1. bar foo1 bar: 2. (self bar: a) bar: (b bar: c)' '``@rcvr foo: ``@arg1' '``@rcvr bar: ``@arg1' ) ('3 + 4' '4 + 4' '3' '4' ) ('a := self a' 'b := self a' 'a' 'b' ) ('^self at: 1 put: 2' '^self put: 1 put: 2' '^`@rcvr `at: `@arg1 put: `@arg2' '^`@rcvr put: `@arg1 put: `@arg2' ) ('1 + 2 + 3' '0 + 0 + 0' '`#literal' '0' ) ('1 + 2 + 3. 3 foo: 4' '3 + (2 + 1). 4 foo: 3' '``@rcvr `msg: ``@arg' '``@arg `msg: ``@rcvr' ) ('self foo: a bar: b. 1 foo: a bar: b' '2 foo: a bar: b. 1 foo: a bar: b' 'self `@msg: `@args' '2 `@msg: `@args' ) ('a := b. a := c + d' 'b := a. a := c + d' '`var1 := `var2' '`var2 := `var1' ) ('^self foo value: 1' 'self return: (self foo value: 1)' '^`@anything' 'self return: `@anything' ) ('self first; second. self first; second. self a. self b' '2 timesRepeat: [self first; second]. self a. self b' '`.Stmt1. `.Stmt1. `@.stmts' '2 timesRepeat: [`.Stmt1]. `@.stmts' ) ('[:a | self a: 1 c: 2; b]' '[:a | self d: 2 e: 1; f. self halt]' '`@rcvr `msg1: `@arg1 `msg2: `@arg2; `msg' '`@rcvr d: `@arg2 e: `@arg1; f. self halt' )  ) do: 
		[:each | 
		| rewrite | 
		rewrite _ ParseTreeRewriter new.
		rewrite replace: (each at: 3)
			with: each last.
		self compare: (RBParser parseExpression: (rewrite executeTree: (RBParser parseExpression: each first);
				 tree) formattedCode)
			to: (RBParser parseExpression: (each at: 2))]
!

testSearching
        | searcher |
        searcher := ParseTreeSearcher new.
        searcher matches: '``@rcv at: ``@arg `sel: ``@arg1'
                do: [:aNode :answer | self halt. answer + 1].
        self 
                assert: (searcher executeTree: (RBParser 
                                                parseExpression: 'self at: 1 put: 2; at: 2 ifAbsent: []; ifAbsent: 2 at: 1; at: 4; foo')
                                initialAnswer: 0) = 2.
        searcher := ParseTreeSearcher new.
        searcher matches: '``@rcv `at: ``@arg1 `at: ``@arg2'
                do: [:aNode :answer | answer + 1].
        self 
                assert: (searcher executeTree: (RBParser 
                                                parseExpression: 'self at: 1 at: 3; at: 1 put: 32; at: 2; foo; at: 1 at: 1 at: 2')
                                initialAnswer: 0) = 1.
        searcher := ParseTreeSearcher new.
        searcher matchesMethod: 'at: `object `put: `o1 ``@rcv `put: 1'
                do: [:aNode :answer | true].
        self assert: (searcher 
                                executeTree: (RBParser parseMethod: 'at: a put: b self foo put: 1')
                                initialAnswer: false)
!

testSmallDictionary
	| dictionary total |
	dictionary := RBSmallDictionary new: 100.
	dictionary
		add: 1 -> 3;
		at: 2 put: 4;
		at: 1 put: 4.
	self assert: dictionary size = 2.
	self assert: (dictionary inject: 0 into: [:sum :each | sum + each]) = 8.
	self assert: (dictionary includesKey: 1).
	self deny: (dictionary includesKey: 3).
	total := 0.
	dictionary keysDo: [:each | total := total + each].
	self assert: total = 3.
	dictionary removeKey: 2.
	dictionary copy associationsDo: [:each | dictionary remove: each].
	self assert: dictionary size = 0
!

testSqueak
	self setupAsSqueakWhile: 
			[| tree searcher |
			tree := RBParser 
				    parseMethod: 'test |a| a_123.'.

			searcher := ParseTreeRewriter new.
			searcher 
				replace: '`a := 123'
				with: '`a := 234'.

			searcher executeTree: tree.

			tree := searcher tree.
			searcher := ParseTreeRewriter new.
			searcher replace: '234' with: '12345'.
			searcher executeTree: tree.
			self 
				assert: (RBParser parseMethod: searcher tree formattedCode) 
					 = (RBParser parseMethod: 'test |a| a := 12345').
			Transcript showCR:'Rewritten as: '; showCR:searcher tree formattedCode]

	"
	 self basicNew testSqueak
	"
!

testTokens
	self setupAsIBMWhile: 
			[| tokens |
			tokens := (RBScanner 
						on: '#foo foo: bar := [ ##( + foo::bar::baz' readStream) contents.
			tokens printString.     "coverage"
			tokens with: #(4 4 3 2 1 3 1 13)
				do: [:token :length | self assert: token length = length]]
! !

!RBParserTest methodsFor:'tests - parsing'!

testPragmas
        | tree node | 

        #(('foo <foo>'                          #foo ()) 
        ('foo <foo: 1>'                                 #foo: (1)) 
        ('foo <foo: 1.2>'                       #foo: (1.2)) 
        ('foo <foo: -3>'                        #foo: (-3)) 
        ('foo <foo: a>'                                 #foo: (a)) 
        ('foo <foo: #a>'                        #foo: (a)) 
        ('foo <foo: #< >'                       #foo: (<)) 
        ('foo <foo: #> >'                       #foo: (>)) 
        ('foo <foo: $a>'                        #foo: ($a)) 
        ('foo <foo: ''bar''>'           #foo: ('bar')) 
        ('foo <foo: true>'                      #foo: (true)) 
        ('foo <foo: false>'                     #foo: (false)) 
        ('foo <foo: nil>'                       #foo: (nil)) 
        ('foo <foo: #(1 2)>'            #foo: ((1 2)))
        ('foo <foo: 1 bar: 2>'          #foo:bar: (1 2))
        ('foo |t| <foo: 1.2>'           #foo: (1.2))
        "('foo self. <foo: $a>'          #foo: ($a)) "
        ('foo |t| <foo: 1 bar: 2>' #foo:bar: (1 2))
        ) do: [ :each |
                tree := RBParser parseMethod: each first.
                self assert: (tree pragmas size = 1).
                node := tree pragmas first.
                self assert: node selector = each second.
                1 to: node arguments size do: [ :i |
                        self assert: (node arguments at: i) value = (each last at: i) ].
                self assert: (each first at: node start) equals: $<.
                self assert: (each first at: node stop) equals: $> ].
        
        self assert: (RBParser parseMethod: 'selector <a>') isMethod.
        self assert: (RBParser parseMethod: '
        selector 
                "comment1" 
                |temp| 
                "comment2" 
                <a> 
                #<.
                ^1') isMethod.
        self assert: (RBParser parseMethod: '
        selector 
                "comment1" 
                |temp| 
                "comment2" 
                <a> 
                <.
                ^1') isNil

    "Created: / 21-09-2015 / 10:51:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-09-2015 / 11:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPragmasSTX1
    | tree | 

    tree := RBParser parseMethod: 'foo <resource: #foo (#one #two)>'.
    self assert: tree pragmas size == 1.
    self assert: tree pragmas anElement selector = 'resource:values:'.
    self assert: tree pragmas anElement arguments size == 2.
    self assert: tree pragmas anElement arguments first isLiteral.
    self assert: tree pragmas anElement arguments second isLiteral.
    self assert: tree pragmas anElement arguments second value = #(#one #two)

    "Created: / 28-09-2015 / 06:06:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPragmasSTX2
    | tree | 

    tree := RBParser parseMethod: 'foo <cdecl: LLVMValue "LLVMAddAlias" ( LLVMModule LLVMType LLVMValue charPointer ) > ^ 1' onError:[ :err :pos | self assert: false ].
    self assert: tree pragmas size == 1.
    self assert: tree pragmas anElement selector = 'cdecl:'.
    self assert: tree pragmas anElement arguments size == 1.
    self assert: tree pragmas anElement arguments first isLiteral.
    self assert: tree pragmas anElement arguments first value = 'LLVMValue "LLVMAddAlias" ( LLVMModule LLVMType LLVMValue charPointer ) '.

    self assert: tree body statements size == 1.
    self assert: tree body statements first isReturn.

    "Created: / 28-09-2015 / 06:59:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-09-2015 / 10:05:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSymbolSTX
    | tree | 

    tree := RBParser parseMethod: 'foo ^ #Some::Symbol' onError:[ :err :pos | self assert: false ].
    self assert: tree body statements size == 1.
    self assert: tree body statements first isReturn.
    self assert: tree body statements first value isLiteral.
    self assert: tree body statements first value value = 'Some::Symbol'.

    tree := RBParser parseMethod: 'foo ^ #Tools::TestRunner2' onError:[ :err :pos | self assert: false ].
    self assert: tree body statements size == 1.
    self assert: tree body statements first isReturn.
    self assert: tree body statements first value isLiteral.
    self assert: tree body statements first value value = 'Tools::TestRunner2'

    "Created: / 24-05-2016 / 00:08:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBParserTest methodsFor:'tests - smoke'!

smokeParseAllMethods
    Smalltalk allClassesDo:[:cls |
        Transcript showCR:cls.
        cls instAndClassMethodsDo:[:mthd |
            RBParser parseMethod:mthd source onError:[ :err :pos | self assert: false ]
        ]
    ].
    "
    RBParserTest run: #smokeParseAllMethods.
    RBParserTest debug: #smokeParseAllMethods.
    "

    "Created: / 29-09-2015 / 08:19:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 24-05-2016 / 00:10:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBParserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RBParserTest.st,v 1.7 2015-01-02 13:22:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RBParserTest.st,v 1.7 2015-01-02 13:22:07 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

