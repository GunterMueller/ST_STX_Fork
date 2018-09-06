"{ Package: 'stx:goodies/petitparser/compiler/benchmarks' }"

"{ NameSpace: Smalltalk }"

PPSmalltalkGrammar subclass:#PPCSmalltalkNoopParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Benchmarks-Parsers'
!


!PPCSmalltalkNoopParser methodsFor:'accessing'!

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

!PPCSmalltalkNoopParser methodsFor:'grammar'!

array
        ^ super array map: [ :openNode :statementNodes :closeNode | ]

    "Modified: / 15-05-2015 / 08:54:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expression
        ^ super expression map: [ :variableNodes :expressionNodes |  ]

    "Modified: / 15-05-2015 / 08:55:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method
        ^ super method map: [ :methodNode :bodyNode | ]

    "Modified (format): / 15-05-2015 / 08:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodDeclaration
        ^ super methodDeclaration ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:55:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodSequence
        ^ super methodSequence map: [ :periodNodes1 :pragmaNodes1 :periodNodes2 :tempNodes :periodNodes3 :pragmaNodes2 :periodNodes4 :statementNodes | ]

    "Modified: / 15-05-2015 / 08:55:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parens
        ^ super parens map: [ :openToken :expressionNode :closeToken |  ]

    "Modified: / 15-05-2015 / 08:55:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pragma
        ^ super pragma ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

return
        ^ super return map: [ :token :expressionNode |  ]

    "Modified: / 15-05-2015 / 08:55:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sequence
        ^ super sequence map: [ :tempNodes :periodNodes :statementNodes |  ]

    "Modified: / 15-05-2015 / 08:56:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variable
        ^ super variable ==> [ :token |  ]

    "Modified: / 15-05-2015 / 08:56:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSmalltalkNoopParser methodsFor:'grammar-blocks'!

block
        ^ super block map: [ :leftToken :blockNode :rightToken | ]

    "Modified: / 15-05-2015 / 08:56:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

blockArgument
	^ super blockArgument ==> #second
!

blockBody
        ^ super blockBody
                ==> [ :nodes |  ]

    "Modified: / 15-05-2015 / 08:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSmalltalkNoopParser methodsFor:'grammar-literals'!

arrayLiteral
        ^ super arrayLiteral ==> [ :nodes | nodes ]

    "Modified (format): / 15-05-2015 / 08:56:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

arrayLiteralArray
        ^ super arrayLiteralArray ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:56:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

byteLiteral
        ^ super byteLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

byteLiteralArray
        ^ super byteLiteralArray ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

charLiteral
        ^ super charLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

falseLiteral
        ^ super falseLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nilLiteral
        ^ super nilLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numberLiteral
    ^ super numberLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringLiteral
        ^ super stringLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

symbolLiteral
        ^ super symbolLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

symbolLiteralArray
        ^ super symbolLiteralArray ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trueLiteral
        ^ super trueLiteral ==> [ :nodes | nodes ]

    "Modified: / 15-05-2015 / 08:57:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSmalltalkNoopParser methodsFor:'grammar-messages'!

binaryExpression
        ^ super binaryExpression map: [ :receiverNode :messageNodes |  ]

    "Modified: / 15-05-2015 / 08:57:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cascadeExpression
        ^ super cascadeExpression map: [ :receiverNode :messageNodes | ]

    "Modified: / 15-05-2015 / 08:57:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keywordExpression
        ^ super keywordExpression map: [ :receiveNode :messageNode | ]

    "Modified: / 15-05-2015 / 08:58:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unaryExpression
        ^ super unaryExpression map: [ :receiverNode :messageNodes | ]

    "Modified: / 15-05-2015 / 08:58:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSmalltalkNoopParser methodsFor:'private'!

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

!PPCSmalltalkNoopParser methodsFor:'token'!

binaryToken
        ^ super binaryToken ==> [ :token | token ]

    "Modified: / 15-05-2015 / 08:54:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

identifierToken
        ^ super identifierToken ==> [ :token | token ]

    "Modified: / 15-05-2015 / 08:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keywordToken
        ^ super keywordToken ==> [ :token | token ]

    "Modified: / 15-05-2015 / 08:54:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unaryToken
        ^ super unaryToken ==> [ :token | token ]

    "Modified: / 15-05-2015 / 08:54:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSmalltalkNoopParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

