"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

ParseTreeSearcher subclass:#ParseTreeRewriter
	instanceVariableNames:'tree'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

ParseTreeRewriter comment:'ParseTreeRewriter walks over and transforms its BRProgramNode (tree). If the tree is modified, then answer is set to true, and the modified tree can be retrieved by the #tree method.

Instance Variables:
	tree    <BRProgramNode> the parse tree we''re transforming'
!


!ParseTreeRewriter class methodsFor:'instance creation'!

classVariable: aVarName getter: getMethod setter: setMethod 
	^self 
		variable: aVarName
		getter: getMethod
		setter: setMethod
		receiver: 'self class'
!

new
    "A small hack to use ParseTreeSourceRewriter if all refactorings. should not harm..."

    Smalltalk isSmalltalkX ifTrue:[
        self == ParseTreeRewriter ifTrue:[
            (UserPreferences current at: #useParseTreeSourceRewriterForAllRewrites ifAbsent:[false]) ifTrue:[
                ^ ParseTreeSourceRewriter basicNew initialize.
            ]
        ]
    ].
    ^self basicNew initialize.

    "
        ParseTreeRewriter new.
        UserPreferences current at: #useParseTreeSourceRewriterForAllRewrites put: false.
        UserPreferences current at: #useParseTreeSourceRewriterForAllRewrites put: true
    "

    "Created: / 04-04-2012 / 13:46:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeTemporaryNamed: aName 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule replace: '| `@temps1 ' , aName , ' `@temps2 | ``@.Statements'
		with: '| `@temps1  `@temps2 | ``@.Statements'.
	^rewriteRule
!

rename: varName to: newVarName 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: varName with: newVarName;
		replaceArgument: varName with: newVarName.
	^rewriteRule
!

rename: varName to: newVarName handler: aBlock 
	"Rename varName to newVarName, evaluating aBlock if there is a 
	temporary variable with the same name as newVarName. This 
	does not change temporary variables with varName."

	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: varName with: newVarName;
		replaceArgument: newVarName
			withValueFrom: 
				[:aNode | 
				aBlock value.
				aNode].
	^rewriteRule
!

replace: code with: newCode method: aBoolean 
	| rewriteRule |
	rewriteRule := self new.
	aBoolean 
		ifTrue: [rewriteRule replaceMethod: code with: newCode]
		ifFalse: [rewriteRule replace: code with: newCode].
	^rewriteRule
!

replaceLiteral: literal with: newLiteral 
        | rewriteRule |
        rewriteRule := self new.
        rewriteRule replaceLiteral: literal with: newLiteral.
"/ duplicate code.
"/        rewriteRule 
"/                replace: '`#literal'
"/                withValueFrom: [:aNode | aNode]
"/                when:[:aNode | 
"/                        self 
"/                                replaceLiteral: literal
"/                                with: newLiteral
"/                                inToken: aNode token].
        ^rewriteRule
!

valueHolderForVariable: aVarName holderMethod: aSelector 
	| rewriteRule valueHolderString |
	rewriteRule := self new.
	valueHolderString := 'self ' , aSelector , ' value'.
	rewriteRule
		replace: aVarName , ' := ``@object' with: valueHolderString , ': ``@object';
		replace: aVarName with: valueHolderString.
	^rewriteRule
!

variable: aVarName getter: getMethod setter: setMethod 
	^self 
		variable: aVarName
		getter: getMethod
		setter: setMethod
		receiver: 'self'
!

variable: aVarName getter: getMethod setter: setMethod receiver: aString 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: aVarName , ' := ``@object'
			with: aString , ' ' , setMethod , ' ``@object';
		replace: aVarName with: aString , ' ' , getMethod.
	^rewriteRule
! !

!ParseTreeRewriter class methodsFor:'accessing'!

replace: code with: newCode in: aParseTree 
	^(self 
		replace: code
		with: newCode
		method: false)
		executeTree: aParseTree;
		tree
!

replace: code with: newCode in: aParseTree onInterval: anInterval 
	| rewriteRule |
	rewriteRule := self new.
	^rewriteRule
		replace: code
			with: newCode
			when: [:aNode | aNode intersectsInterval: anInterval];
		executeTree: aParseTree;
		tree
!

replaceStatements: code with: newCode in: aParseTree onInterval: anInterval 
	| tree searchStmt replaceStmt optionalPeriod|
	tree := self buildTree: code method: false.
	optionalPeriod := tree lastHasPeriod ifTrue:[''] ifFalse:['.'].

	tree lastIsReturn
		ifTrue: 
			[searchStmt := '| `@temps | `@.Statements. ' , code.
			replaceStmt := '| `@temps | `@.Statements. ^' , newCode]
		ifFalse: 
			[searchStmt := '| `@temps | `@.Statements1. ' , code , optionalPeriod , ' `@.Statements2'.
			replaceStmt := '| `@temps | `@.Statements1. ' , newCode , '.  `@.Statements2'].
	^self
		replace: searchStmt
		with: replaceStmt
		in: aParseTree
		onInterval: anInterval
! !

!ParseTreeRewriter class methodsFor:'private'!

replaceLiteral: literal with: newLiteral inToken: literalToken 
        | value |
        
        value := literalToken realValue.
        (value class = literal class and: [value = literal]) ifTrue: [
            literalToken value: newLiteral start: nil stop: nil.
            ^true
        ].
        ^value class == Array 
            and:[
                literalToken value 
                    inject: false
                    into:[:bool :each |
                        "/ avaluating or here - all should be replaced
                        bool | (self replaceLiteral: literal with: newLiteral inToken: each)
                    ]
            ]
! !

!ParseTreeRewriter methodsFor:'accessing'!

executeTree: aParseTree 
        | oldContext |

        RBParser flushCachedTree:aParseTree.

        oldContext := context.
        context := (RBSmallDictionary ? Dictionary) new.
        answer := false.
        tree := self visitNode: aParseTree.
        context := oldContext.
        ^answer
!

forgetReplacements
    "Nothing to do here, to be polymorph with ParseTreeSourceRewriter"

    "Created: / 01-03-2013 / 10:53:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

replacements
    "Nothing returned here, to be polymorph with ParseTreeSourceRewriter"

    ^ nil
!

tree
	^tree
! !

!ParseTreeRewriter methodsFor:'converting'!

asSearcher
    | searcher wrapperBlock|

    searcher := ParseTreeSearcher new.
    searches do:[:rule|
        wrapperBlock := [:node :answer | rule verificationBlock value:node. node].

        rule searchTree isMethod ifTrue:[
            searcher matchesMethod: rule searchString do: wrapperBlock
        ] ifFalse:[
            searcher matches: rule searchString do:wrapperBlock.
        ].
    ].
    ^searcher

    "Created: / 31-01-2012 / 14:33:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2012 / 17:35:37 / cg"
! !

!ParseTreeRewriter methodsFor:'obsolete'!

buildMethodParseTreeRuleFor: aReplaceCondition 
        | search when replace |
        search := aReplaceCondition key.
        when := nil.
        replace := aReplaceCondition value.
        (replace isAssociation) 
                ifTrue: 
                        [when := replace key.
                        replace := replace value].
        when isNil 
                ifTrue: 
                        [(search isKindOf: RBProgramNode) 
                                ifTrue: 
                                        [^((replace isKindOf: RBProgramNode) 
                                                ifTrue: [RBStringReplaceRule]
                                                ifFalse: [RBBlockReplaceRule]) searchForTree: search replaceWith: replace].
                        ^(replace isString 
                                ifTrue: [RBStringReplaceRule]
                                ifFalse: [RBBlockReplaceRule]) searchForMethod: search replaceWith: replace].
        (search isKindOf: RBProgramNode) 
                ifTrue: 
                        [^((replace isKindOf: RBProgramNode) 
                                ifTrue: [RBStringReplaceRule]
                                ifFalse: [RBBlockReplaceRule]) 
                                        searchForTree: search
                                        replaceWith: replace
                                        when: when].
        ^(replace isString 
                ifTrue: [RBStringReplaceRule]
                ifFalse: [RBBlockReplaceRule]) 
                        searchForMethod: search
                        replaceWith: replace
                        when: when
!

buildParseTreeRuleFor: aReplaceCondition 
        | search when replace |
        search := aReplaceCondition key.
        when := nil.
        replace := aReplaceCondition value.
        (replace isAssociation) 
                ifTrue: 
                        [when := replace key.
                        replace := replace value].
        when isNil 
                ifTrue: 
                        [(search isKindOf: RBProgramNode) 
                                ifTrue: 
                                        [^((replace isKindOf: RBProgramNode) 
                                                ifTrue: [RBStringReplaceRule]
                                                ifFalse: [RBBlockReplaceRule]) searchForTree: search replaceWith: replace].
                        ^(replace isString 
                                ifTrue: [RBStringReplaceRule]
                                ifFalse: [RBBlockReplaceRule]) searchFor: search replaceWith: replace].
        (search isKindOf: RBProgramNode) 
                ifTrue: 
                        [^((replace isKindOf: RBProgramNode) 
                                ifTrue: [RBStringReplaceRule]
                                ifFalse: [RBBlockReplaceRule]) 
                                        searchForTree: search
                                        replaceWith: replace
                                        when: when].
        ^(replace isString 
                ifTrue: [RBStringReplaceRule]
                ifFalse: [RBBlockReplaceRule]) 
                        searchFor: search
                        replaceWith: replace
                        when: when
! !

!ParseTreeRewriter methodsFor:'private'!

foundMatch
	answer := true
!

lookForMoreMatchesInContext: oldContext 
	oldContext keysAndValuesDo: 
			[:key :value | 
			(key isString not and: [key recurseInto]) 
				ifTrue: 
					[oldContext at: key put: (value collect: [:each | self visitNode: each])]]
! !

!ParseTreeRewriter methodsFor:'queries'!

isRewritingOriginalSource
    ^ false.
! !

!ParseTreeRewriter methodsFor:'replacing'!

replace: searchString with: replaceString 
        self addRule: (RBStringReplaceRule 
                                searchFor: searchString
                                replaceWith: replaceString)
!

replace: searchString with: replaceString keepComments:keepComments
    "if keepComments is true, comments in the replaceString will be handled"

    self addRule: (RBStringReplaceRule 
                            searchFor: searchString
                            replaceWith: replaceString
                            keepComments:keepComments)
!

replace: searchString with: replaceString thenDo:actionOnReplacedNode
        self addRule: (RBStringReplaceRule 
                                searchFor: searchString
                                replaceWith: replaceString
                                thenDo:actionOnReplacedNode)
!

replace: searchString with: replaceString when: aBlock 
	self addRule: (RBStringReplaceRule 
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)
!

replace: searchString withValueFrom: replaceBlock 
	self addRule: (RBBlockReplaceRule searchFor: searchString
				replaceWith: replaceBlock)
!

replace: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addRule: (RBBlockReplaceRule 
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)
!

replaceArgument: searchString with: replaceString 
	self addArgumentRule: (RBStringReplaceRule searchFor: searchString
				replaceWith: replaceString)
!

replaceArgument: searchString with: replaceString when: aBlock 
	self addArgumentRule: (RBStringReplaceRule 
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)
!

replaceArgument: searchString withValueFrom: replaceBlock 
	self addArgumentRule: (RBBlockReplaceRule searchFor: searchString
				replaceWith: replaceBlock)
!

replaceArgument: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addArgumentRule: (RBBlockReplaceRule 
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)
!

replaceLiteral: literal with: newLiteral 
        self
                replace: '`#literal'
                withValueFrom: [:aNode | aNode]
                when:[:aNode | 
                        self class
                                replaceLiteral: literal
                                with: newLiteral
                                inToken: aNode token].
!

replaceMethod: searchString with: replaceString 
        self addRule: (RBStringReplaceRule 
                                searchForMethod: searchString
                                replaceWith: replaceString)
!

replaceMethod: searchString with: replaceString when: aBlock 
	self addRule: (RBStringReplaceRule 
				searchForMethod: searchString
				replaceWith: replaceString
				when: aBlock)
!

replaceMethod: searchString withValueFrom: replaceBlock 
	self addRule: (RBBlockReplaceRule searchForMethod: searchString
				replaceWith: replaceBlock)
!

replaceMethod: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addRule: (RBBlockReplaceRule 
				searchForMethod: searchString
				replaceWith: replaceBlock
				when: conditionBlock)
!

replaceTree: searchTree withTree: replaceTree 
	self addRule: (RBStringReplaceRule searchForTree: searchTree
				replaceWith: replaceTree)
!

replaceTree: searchTree withTree: replaceTree when: aBlock 
	self addRule: (RBStringReplaceRule 
				searchForTree: searchTree
				replaceWith: replaceTree
				when: aBlock)
!

replaceVariable: variable with: newVariable 
        self
                replace: '`variable'
                withValueFrom: [:aNode |
                    |newNode|

                    newNode := aNode copy.
                    newNode identifierToken:(aNode token copy value:newVariable). 
                    "/ Transcript showCR:'replacing variable ',variable,' by ',newVariable.
                    newNode
                ]
                when: [:aNode | 
                        (aNode name = variable) 
                ].
! !

!ParseTreeRewriter methodsFor:'visiting'!

visitArguments: aNodeCollection 
	^aNodeCollection collect: [:each | self visitArgument: each]
! !

!ParseTreeRewriter methodsFor:'visitor-double dispatching'!

acceptAssignmentNode: anAssignmentNode 
	anAssignmentNode variable: (self visitNode: anAssignmentNode variable).
	anAssignmentNode value: (self visitNode: anAssignmentNode value)
!

acceptBlockNode: aBlockNode 
	aBlockNode arguments: (self visitArguments: aBlockNode arguments).
	aBlockNode body: (self visitNode: aBlockNode body)
!

acceptCascadeNode: aCascadeNode 
    | newMessages notFound |

    newMessages := OrderedCollection new: aCascadeNode messages size.
    notFound := OrderedCollection new: aCascadeNode messages size.
    aCascadeNode messages do:[:each | 
        | newNode |
        newNode := self performSearches: searches on: each.
        newNode isNil ifTrue:[ 
            newNode := each.
            notFound add: newNode
        ].
        newNode isMessage ifTrue: [
            newMessages add: newNode
        ] ifFalse: [
            newNode isCascade ifTrue: [
                newMessages addAll: newNode messages
            ] ifFalse:[
                Transcript showCR: 'Cannot replace message node inside of cascaded node with non-message node.'.
                newMessages add: each
            ]
        ]
    ].
    notFound size == aCascadeNode messages size ifTrue: [
        | receiver |
        receiver := self visitNode: aCascadeNode messages first receiver.
        newMessages do: [:each | each receiver: receiver]
    ].
    notFound do: [:each | each arguments: (each arguments collect: [:arg | self visitNode: arg])].
    aCascadeNode messages: newMessages
!

acceptMessageNode: aMessageNode 
	aMessageNode receiver: (self visitNode: aMessageNode receiver).
	aMessageNode 
		arguments: (aMessageNode arguments collect: [:each | self visitNode: each])
!

acceptMethodNode: aMethodNode 
	aMethodNode arguments: (self visitArguments: aMethodNode arguments).
	aMethodNode body: (self visitNode: aMethodNode body)
!

acceptOptimizedNode: anOptimizedNode 
	anOptimizedNode body: (self visitNode: anOptimizedNode body)
!

acceptReturnNode: aReturnNode 
	aReturnNode value: (self visitNode: aReturnNode value)
!

acceptSequenceNode: aSequenceNode 
	aSequenceNode temporaries: (self visitArguments: aSequenceNode temporaries).
	aSequenceNode statements: (aSequenceNode statements collect: [:each | self visitNode: each])
! !

!ParseTreeRewriter class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

