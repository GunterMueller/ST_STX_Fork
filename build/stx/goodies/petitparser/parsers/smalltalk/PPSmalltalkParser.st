"{ Package: 'stx:goodies/petitparser/parsers/smalltalk' }"

PPSmalltalkGrammar subclass:#PPSmalltalkParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitSmalltalk-Core'
!

PPSmalltalkParser comment:'Enhances the Smalltalk grammar with production actions to build parse-tree nodes of the refactoring browser.'
!


!PPSmalltalkParser methodsFor:'accessing'!

startExpression
	"Make the sequence node has a method node as its parent and that the source is set."

	^ ([ :stream | stream collection ] asParser and , super startExpression) map: [ :source :node | 
		(RBMethodNode selector: #doIt body: node)
			source: source.
		(node statements size = 1 and: [ node temporaries isEmpty ])
			ifTrue: [ node statements first ]
			ifFalse: [ node ] ]
!

startMethod
	"Make sure the method node has the source code properly set."
	
	^ ([ :stream | stream collection ] asParser and , super startMethod)
		map: [ :source :node | node source: source ]
! !

!PPSmalltalkParser methodsFor:'grammar'!

array
	^ super array map: [ :openNode :statementNodes :closeNode |
		(self buildArray: statementNodes)
			left: openNode start;
			right: closeNode start;
			yourself ]
!

expression
	^ super expression map: [ :variableNodes :expressionNodes | self build: expressionNodes assignment: variableNodes ]
!

method
	^ super method map: [ :methodNode :bodyNode | 
		methodNode pragmas: bodyNode first.
		methodNode body: bodyNode second.
		self buildMethod: methodNode ]
!

methodDeclaration
	^ super methodDeclaration ==> [ :nodes |
		RBMethodNode 
			selectorParts: nodes first
			arguments: nodes second ]
!

methodSequence
	^ super methodSequence map: [ :periodNodes1 :pragmaNodes1 :periodNodes2 :tempNodes :periodNodes3 :pragmaNodes2 :periodNodes4 :statementNodes |
		Array
			with: pragmaNodes1 , pragmaNodes2
			with: (self build: tempNodes sequence: periodNodes1 , periodNodes2 , periodNodes3 , periodNodes4 , statementNodes) ]
!

parens
	^ super parens map: [ :openToken :expressionNode :closeToken | expressionNode addParenthesis: (openToken start to: closeToken start) ]
!

pragma
	^ super pragma ==> [ :nodes | 
		(RBPragmaNode selectorParts: nodes second first arguments: nodes second second)
			addComments: nodes first comments;
			addComments: nodes last comments;
			left: nodes first start;
			right: nodes last start;
			yourself ]
!

return
	^ super return map: [ :token :expressionNode | RBReturnNode return: token start value: expressionNode ]
!

sequence
	^ super sequence map: [ :tempNodes :periodNodes :statementNodes | self build: tempNodes sequence: periodNodes , statementNodes ]
!

variable
	^ super variable ==> [ :token | RBVariableNode identifierToken: token ]
! !

!PPSmalltalkParser methodsFor:'grammar-blocks'!

block
	^ super block map: [ :leftToken :blockNode :rightToken | blockNode left: leftToken start; right: rightToken start ]
!

blockArgument
	^ super blockArgument ==> #second
!

blockBody
	^ super blockBody
		==> [ :nodes | 
			| result |
			result := RBBlockNode arguments: nodes first first body: nodes last.
			nodes first last ifNotNil: [ result bar: nodes first last start ].
			result ]
! !

!PPSmalltalkParser methodsFor:'grammar-literals'!

arrayLiteral
	^ super arrayLiteral ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: false ]
!

arrayLiteralArray
	^ super arrayLiteralArray ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: false ]
!

byteLiteral
	^ super byteLiteral ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: true ]
!

byteLiteralArray
	^ super byteLiteralArray ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: true ]
!

charLiteral
	^ super charLiteral ==> [ :token | RBLiteralValueNode literalToken: ((RBLiteralToken value: token inputValue second start: token start stop: token stop) comments: token comments; yourself) ]
!

falseLiteral
	^ super falseLiteral ==> [ :token | RBLiteralValueNode literalToken: ((RBLiteralToken value: false start: token start stop: token stop) comments: token comments; yourself) ]
!

nilLiteral
	^ super nilLiteral ==> [ :token | RBLiteralValueNode literalToken: ((RBLiteralToken value: nil start: token start stop: token stop) comments: token comments; yourself) ]
!

numberLiteral
    ((Smalltalk respondsTo: #isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[ 
        ^ super numberLiteral ==> [ :token | RBLiteralValueNode literalToken: ((RBNumberLiteralToken value: (Number readSmalltalkSyntaxFrom: token inputValue) start: token start stop: token stop source: token inputValue) comments: token comments; yourself) ]
    ] ifFalse:[ 
        ^ super numberLiteral ==> [ :token | RBLiteralValueNode literalToken: ((RBNumberLiteralToken value: (Number readFrom: token inputValue) start: token start stop: token stop source: token inputValue) comments: token comments; yourself) ]
    ]

    "Modified: / 07-10-2014 / 23:01:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringLiteral
	^ super stringLiteral ==> [ :token | RBLiteralValueNode literalToken: ((RBLiteralToken value: (self buildString: token inputValue) start: token start stop: token stop) comments: token comments; yourself) ]
!

symbolLiteral
	^ super symbolLiteral ==> [ :tokens | RBLiteralValueNode literalToken: ((RBLiteralToken value: (self buildString: tokens last inputValue) asSymbol start: tokens first start stop: tokens last stop) comments: tokens last comments; yourself) ]
!

symbolLiteralArray
	^ super symbolLiteralArray ==> [ :token | RBLiteralValueNode literalToken: ((RBLiteralToken value: (self buildString: token inputValue) asSymbol start: token start stop: token stop) comments: token comments; yourself) ]
!

trueLiteral
	^ super trueLiteral ==> [ :token | RBLiteralValueNode literalToken: ((RBLiteralToken value: true start: token start stop: token stop) comments: token comments; yourself) ]
! !

!PPSmalltalkParser methodsFor:'grammar-messages'!

binaryExpression
	^ super binaryExpression map: [ :receiverNode :messageNodes | self build: receiverNode messages: messageNodes ]
!

cascadeExpression
	^ super cascadeExpression map: [ :receiverNode :messageNodes | self build: receiverNode cascade: messageNodes ]
!

keywordExpression
	^ super keywordExpression map: [ :receiveNode :messageNode | self build: receiveNode messages: (Array with: messageNode) ]
!

unaryExpression
	^ super unaryExpression map: [ :receiverNode :messageNodes | self build: receiverNode messages: messageNodes ]
! !

!PPSmalltalkParser methodsFor:'private'!

addStatements: aCollection into: aNode
	aCollection isNil 
		ifTrue: [ ^ aNode ].
	aCollection do: [ :each |
		each class == PPSmalltalkToken
			ifFalse: [ aNode addNode:  each ]
			ifTrue: [
				aNode statements isEmpty
					ifTrue: [ aNode addComments: each comments ]
					ifFalse: [ aNode statements last addComments: each comments ].
				aNode periods: (aNode periods asOrderedCollection
					addLast: each start;
					yourself) ] ].
	^ aNode
!

build: aNode assignment: anArray
	^ anArray isEmpty
		ifTrue: [ aNode ]
		ifFalse: [
			anArray reverse 
				inject: aNode
				into: [ :result :each |
					RBAssignmentNode 
						variable: each first
						value: result
						position: each second start ] ]
!

build: aNode cascade: anArray 
	| messages semicolons |
	^ (anArray isNil or: [ anArray isEmpty ]) 
		ifTrue: [ aNode ]
		ifFalse: [
			messages := OrderedCollection new: anArray size + 1.
			messages addLast: aNode.
			semicolons := OrderedCollection new.
			anArray do: [ :each | 
				messages addLast: (self 
					build: aNode receiver
					messages: (Array with: each second)).
				semicolons addLast: each first start ].
			RBCascadeNode messages: messages semicolons: semicolons ]
!

build: aNode messages: anArray 
	^ (anArray isNil or: [ anArray isEmpty ]) 
		ifTrue: [ aNode ]
		ifFalse: [
			anArray 
				inject: aNode
				into: [ :rec :msg | 
					msg isNil 
						ifTrue: [ rec ]
						ifFalse: [
							RBMessageNode 
								receiver: rec
								selectorParts: msg first
								arguments: msg second ] ] ]
!

build: aTempCollection sequence: aStatementCollection
	| result |
	result := self
		addStatements: aStatementCollection
		into: RBSequenceNode new.
	aTempCollection isEmpty ifFalse: [
		result
			leftBar: aTempCollection first start
			temporaries: aTempCollection second
			rightBar: aTempCollection last start ].
	^ result
!

buildArray: aStatementCollection
	^ self addStatements: aStatementCollection into: RBArrayNode new
!

buildMethod: aMethodNode
	aMethodNode selectorParts 
		do: [ :each | aMethodNode addComments: each comments ].
	aMethodNode arguments
		do: [ :each | aMethodNode addComments: each token comments ].
	aMethodNode pragmas do: [ :pragma |
		aMethodNode addComments: pragma comments.
		pragma selectorParts 
			do: [ :each | aMethodNode addComments: each comments ].
		pragma arguments do: [ :each | 
			each isLiteralArray
				ifFalse: [ aMethodNode addComments: each token comments ] ].
		pragma comments: nil ].
	^ aMethodNode
!

buildString: aString 
	(aString isEmpty or: [ aString first ~= $' or: [ aString last ~= $' ] ])
		ifTrue: [ ^ aString ].
	^ (aString 
		copyFrom: 2
		to: aString size - 1) 
		copyReplaceAll: ''''''
		with: ''''
! !

!PPSmalltalkParser methodsFor:'token'!

binaryToken
	^ super binaryToken ==> [ :token | (RBBinarySelectorToken value: token inputValue start: token start) comments: token comments; yourself ]
!

identifierToken
	^ super identifierToken ==> [ :token | (RBIdentifierToken value: token inputValue start: token start) comments: token comments; yourself ]
!

keywordToken
	^ super keywordToken ==> [ :token | (RBKeywordToken value: token inputValue start: token start) comments: token comments; yourself ]
!

unaryToken
	^ super unaryToken ==> [ :token | (RBIdentifierToken value: token inputValue start: token start) comments: token comments; yourself ]
! !

!PPSmalltalkParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

