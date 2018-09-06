"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

BasicLintRule subclass:#ParseTreeLintRule
	instanceVariableNames:'matcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!


!ParseTreeLintRule class methodsFor:'instance creation'!

createParseTreeRule: codeStrings method: aBoolean name: aName 
	^(self new)
		name: aName;
		matcher: (self createMatcherFor: codeStrings method: aBoolean);
		yourself
!

createParseTreeRule: codeStrings name: aName 
	^self 
		createParseTreeRule: codeStrings
		method: false
		name: aName
! !

!ParseTreeLintRule class methodsFor:'bugs'!

booleanPrecedence
        ^self createParseTreeRule: 
                        #('`@object1 | `@object2 = `@object3'
                        '`@object1 | `@object2 == `@object3'
                        '`@object1 & `@object2 = `@object3'
                        '`@object1 & `@object2 == `@object3'
                        '`@object1 | `@object2 ~= `@object3'
                        '`@object1 | `@object2 ~~ `@object3'
                        '`@object1 & `@object2 ~= `@object3'
                        '`@object1 & `@object2 ~~ `@object3')
                name: 'Uses "A | B = C" instead of "A | (B = C)"'
!

sendsUnknownMessageToGlobal
	| detector matcher |
	detector := self new.
	detector name: 'Sends unknown message to global'.
	matcher := ParseTreeSearcher new.
	matcher 
		matches: '`{:node :context | node isVariable and: [ Smalltalk includesKey: node name asSymbol ] } `@message: `@args'
		do: 
			[:aNode :answer | 
			answer isNil 
				ifTrue: 
					[| what |
					what := Smalltalk at: aNode receiver name asSymbol.
					(what notNil 
						and: [what ~~ Preferences and: [(what respondsTo: aNode selector) not]]) 
							ifTrue: [aNode]
							ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector
! !

!ParseTreeLintRule class methodsFor:'intention revealing'!

assignmentInIfTrue
        ^self createParseTreeRule: 
                        #('`@boolean 
                                        ifTrue: [| `@temps1 | `@.Statements1. `var := `@object1] 
                                        ifFalse: [| `@temps2 | `@.Statements2. `var := `@object2]' 
                        '`@boolean 
                                        ifFalse: [| `@temps1 | `@.Statements1. `var := `@object1] 
                                        ifTrue: [| `@temps2 | `@.Statements2. `var := `@object2]') 
                name: 'Assignment to same variable and end of ifTrue:ifFalse: blocks'
!

atIfAbsent
        ^self createParseTreeRule: 
                                #('`@object 
                                                at: `@atArg 
                                                ifAbsent: [| `@temps | `@.Statements. `@object at: `@atArg put: `@putArg]' 
                                '`@object 
                                                at: `@atArg 
                                                ifAbsent: [| `@temps | 
                                                                `@.Statements. 
                                                                `@object at: `@atArg put: `@putArg. 
                                                                `@.xStatements1. 
                                                                `@putArg]') 
                name: 'Uses at:ifAbsent: instead of at:ifAbsentPut:'
!

collectSelectNotUsed
        ^self 
                createParseTreeRule: #('`{:node | node isMessage and: [(#(#select: #collect: #reject:) includes: node selector) and: [node isUsed not]]}')
                name: 'Doesn''t use the result of a collect:/select:'
!

collectionMessagesToExternalObject
        | detector matcher |
        detector := self new.
        detector name: 'Sends add:/remove: to external collection'.
        matcher := ParseTreeSearcher new.
        matcher 
                matchesAnyOf: (#(#add: #remove: #addAll: #removeAll:) collect: 
                                        [:each | 
                                        ('(`@Object `@message: `@args) <1s> `@Arg' expandMacrosWith: each) 
                                                asString])
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [((aNode receiver selector copyFrom: 1
                                                to: (aNode receiver selector size min: 2)) ~= 'as' 
                                                and: 
                                                        [| receiver |
                                                        receiver := aNode receiver receiver.
                                                        receiver isVariable not or: 
                                                                        [((#('self' 'super') includes: receiver name) 
                                                                                or: [Smalltalk includesKey: receiver name asSymbol]) not]]) 
                                                        ifTrue: [aNode]
                                                        ifFalse: [nil]]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

collectionProtocol
        ^self createParseTreeRule: 
                        #('`@collection do: [:`each | | `@temps | `@.Statements1. `@object add: `@arg. `@.Statements2]' 
                        '`@collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifTrue: [| `@blockTemps | 
                                                        `@.BlockStatements1. 
                                                        `@object add: `each. 
                                                        `@.BlockStatements2]. 
                                        `@.Statements2]' 
                        '`@collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifFalse: [| `@blockTemps | 
                                                        `@.BlockStatements1. 
                                                        `@object add: `each. 
                                                        `@.BlockStatements2]. 
                                        `@.Statements2]') 
                name: 'Uses do: instead of collect: or select:''s'
!

consistencyCheck
        ^self createParseTreeRule: 
                                #('`@object size == 0' 
                                '`@object size = 0' 
                                '`@object size > 0' 
                                '`@object size >= 1' 
                                '`@object == nil' 
                                '`@object = nil'
                                '`@collection at: 1'
                                '`@collection at: `@collection size') 
                name: 'Uses "size = 0", "= nil",  or "at: 1" instead of "isEmpty",  "isNil", or "first"'
!

contains
        ^self createParseTreeRule: 
                        #('(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) isNil' 
                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) notNil' 
                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) = nil' 
                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) == nil' 
                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) ~= nil' 
                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) ~~ nil' 
                        '`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [| `@temps1 | `@.Statements2. ^`@anything]') 
                name: 'Uses detect:ifNone: instead of contains:'
!

detectContains
        ^self createParseTreeRule: 
                        #('`@collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^`each]. 
                                        `@.Statements2]' 
                        '`@collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^`each]. 
                                        `@.Statements2]' 
                        '`@collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^true]. 
                                        `@.Statements2]' 
                        '`@Collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^true]. 
                                        `@.Statements2]' 
                        '`@collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^false]. 
                                        `@.Statements2]' 
                        '`@collection do: [:`each | | `@temps | 
                                        `@.Statements1. 
                                        `@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^false]. 
                                        `@.Statements2]') 
                name: 'Uses do: instead of contains: or detect:''s'
!

guardingClause
        | detector matcher |
        detector := self new.
        detector name: 'Guarding clauses'.
        matcher := ParseTreeSearcher new.
        matcher 
                matchesAnyMethodOf:     
                        #('`@MethodName: `@args 
                                        | `@temps | 
                                        `@.Statements. 
                                        `@condition ifTrue: [| `@BlockTemps | `.Statement1. `.Statement2. `@.BStatements]' 
                        '`@MethodName: `@args 
                                        | `@temps | 
                                        `@.Statements. 
                                        `@condition ifFalse: [| `@BlockTemps | `.Statement1. `.Statement2. `@.BStatements]')
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [aNode body statements last]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

ifTrueReturns
        | detector matcher |
        detector := self new.
        detector name: 'ifTrue:/ifFalse: returns instead of and:/or:''s'.
        matcher := ParseTreeSearcher new.
        matcher 
                matchesAnyOf: 
                        #('| `@temps | ``@.Statements. ``@object ifTrue: [^``@value1]. ^``@value2' 
                        '| `@temps | ``@.Statements. ``@object ifFalse: [^``@value1]. ^``@value2')
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [| node |
                                        node := (aNode statements at: aNode statements size - 1) arguments first 
                                                                body statements 
                                                                last value.     "``@value1"
                                        ((node isLiteral and: [#(true false) includes: node value]) or: 
                                                        [node := aNode statements last value.
                                                        node isLiteral and: [#(true false) includes: node value]]) 
                                                ifTrue: [aNode]
                                                ifFalse: [nil]]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

literalArrayCharacters
        | detector matcher |
        detector := self new.
        detector name: 'Literal array contains only characters'.
        matcher := ParseTreeSearcher new.
        matcher matches: '`#literal'
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [(aNode value class == Array and: [self isArrayOfCharacters: aNode value]) 
                                                ifTrue: [aNode]
                                                ifFalse: [nil]]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

minMax
        | detector matcher |
        detector := self new.
        detector name: 'Uses ifTrue:/ifFalse: instead of min: or max:'.
        matcher := ParseTreeSearcher new.
        matcher 
                matchesAnyOf: #('(`x `message: `@y) `ifTrue: [`x := `@y]' 
                                '(`@x `message: `@y) `ifTrue: [`@x] `ifFalse: [`@y]' 
                                '(`@x `message: `@y) `ifTrue: [`v := `@x] `ifFalse: [`v := `@y]')
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [((#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:) 
                                                includes: aNode selector) 
                                                        and: [#(#< #<= #> #>=) includes: aNode receiver selector]) 
                                                        ifTrue: [aNode]
                                                        ifFalse: [nil]]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

searchingLiteral
        | detector matcher |
        detector := self new.
        detector name: 'Uses or''s instead of a searching literal'.
        matcher := ParseTreeSearcher new.
        matcher 
                matchesAnyOf: #('``@object = `#literal or: [``@expression]' 
                                                '``@object == `#literal or: [``@expression]' 
                                                '`#literal = ``@object or: [``@expression]' 
                                                '`#literal == ``@object or: [``@expression]' 
                                                '``@expression | (``@object = `#literal)' 
                                                '``@expression | (``@object == `#literal)' 
                                                '``@expression | (`#literal = ``@object)' 
                                                '``@expression | (`#literal == ``@object)')
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [(self isSearchingLiteralExpression: aNode) ifTrue: [aNode] ifFalse: [nil]]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

sizeCheck
        ^self createParseTreeRule: (#(#do: #collect: #reject: #select:) collect: 
                                        [:each | 
                                        '`@object size > 0 ifTrue: [`@object ' , each
                                                , ' [:`each | | `@temps | `@.Statements1]. `@.Statements2]'])
                                , (#(#do: #collect: #reject: #select:) collect: 
                                                        [:each | 
                                                        '`@object isEmpty ifFalse: [`@object ' , each
                                                                , ' [:`each | | `@temps | `@.Statements1]. `@.Statements2]'])
                name: 'Unnecessary size check'
!

toDo
        | detector matcher |
        detector := self new.
        detector name: 'Uses to:do: instead of do:, with:do: or timesRepeat:'.
        matcher := ParseTreeSearcher new.
        matcher 
                matches: '1 to: ``@object size do: [:`each | | `@temps | `@.Statements]'
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [| varName variableMatcher |
                                        varName := aNode arguments last arguments first.        "`each"
                                        variableMatcher := ParseTreeSearcher new.
                                        variableMatcher matchesTree: varName
                                                do: [:node :ans | ans and: [node parent isMessage and: [node parent selector == #at:]]].
                                        (variableMatcher executeTree: aNode arguments last body initialAnswer: true) 
                                                ifTrue: [aNode]
                                                ifFalse: [nil]]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

toDoCollect
        ^self 
                createParseTreeRule: #(
                        '| `@temps1 |
                        `@.Stmts1.
                        `collection := Array new: `@size.
                        `@.Stmts2.
                        1 to: `@size do: 
                                        [:`i | 
                                        | `@Btemps2 | 
                                        `@.BStmts1. 
                                        `collection at: `i put: `@obj.
                                        `@.BStmt2].
                        `@.Stmts3'
                                        "-------------"
                         '| `@temps1 |
                        `@.Stmts1.
                        `collection := Array new: `@size.
                        `@.Stmts2.
                        1 to: `collection size do: 
                                        [:`i | 
                                        | `@Btemps2 | 
                                        `@.BStmts1. 
                                        `collection at: `i put: `@obj.
                                        `@.BStmt2].
                        `@.Stmts3')
                name: 'to:do: doesn''t use collect:'
!

toDoWithIncrement
        ^self 
                createParseTreeRule: #(
                                '`@i to: `@j do: [:`e | | `@temps | `@.Stmts. `x := `x + 1. `@.Stmts2]' 
                                '`@i to: `@j by: `@k do: [:`e | | `@temps | `@.Stmts. `x := `x + `@k. `@.Stmts2]')
                name: 'to:do: loop also increments a counter'
!

whileTrue
        ^self createParseTreeRule: 
                        #('| `@temps | 
                                `@.Statements1. 
                                [`index <= `@stop] 
                                        whileTrue: 
                                                [| `@blockTemps | 
                                                `@.BlockStmts1. 
                                                `index := `index + 1].
                                `@.Statements2' 
                        '| `@temps | 
                                `@.Statements1. 
                                [`index < `@stop] 
                                        whileTrue: 
                                                [| `@blockTemps | 
                                                `@.BlockStmts1. 
                                                `index := `index + 1].
                                `@.Statements2'
                        '| `@temps | 
                                `@.Statements1. 
                                [`index >= `@stop] 
                                        whileTrue: 
                                                [| `@blockTemps | 
                                                `@.BlockStmts1. 
                                                `index := `index - 1].
                                `@.Statements2' 
                        '| `@temps | 
                                `@.Statements1. 
                                [`index > `@stop] 
                                        whileTrue: 
                                                [| `@blockTemps | 
                                                `@.BlockStmts1. 
                                                `index := `index - 1].
                                `@.Statements2') 
                name: 'Uses whileTrue: instead of to:do:'
! !

!ParseTreeLintRule class methodsFor:'miscellaneous'!

asOrderedCollectionNotNeeded
        ^self 
                createParseTreeRule: #('`@node addAll: `{:node | node isMessage and: [#(asOrderedCollection asArray) includes: node selector]}')
                name: '#asOrderedCollection/#asArray not needed'
!

assignmentInBlock
        ^self createParseTreeRule: #(
                        '`@cursor showWhile: [| `@temps | `@.Statements1. `var := `@object]' 
                        '`@cursor showWhile: [| `@temps | `@.Statements1. ^`@object]' 
                        '[| `@temps | `@.Statements. `var := `@object] valueNowOrOnUnwindDo: `@block' 
                        '[| `@temps | `@.Statements. ^`@object] valueNowOrOnUnwindDo: `@block' 
                        '[| `@temps | `@.Statements. `var := `@object] valueOnUnwindDo: `@block' 
                        '[| `@temps | `@.Statements. ^`@object] valueOnUnwindDo: `@block' 
                        '[| `@temps | `@.Statements. `var := `@object] ensure: `@block' 
                        '[| `@temps | `@.Statements. ^`@object] ensure: `@block' 
                        '[| `@temps | `@.Statements. `var := `@object] ifCurtailed: `@block' 
                        '[| `@temps | `@.Statements. ^`@object] ifCurtailed: `@block' ) 
                name: 'Unnecessary assignment or return in block'
!

codeCruftLeftInMethods
        ^(self createParseTreeRule: #(
                                '`@whatever doOnlyOnce: `@stuff'
                                'Transcript `@msg: `@args'
                                '`@any halt'
                                'true ifTrue: `@stuff'
                                '`@any flag: `#lit'
                                '`@any needsWork'
                        )
                name: 'Debugging code left in methods')
                rationale: 'Halts, Transcript writes, doOnlyOnce:, etc. should not be left in production code.';
                yourself
!

ifTrueBlocks
        ^self 
                createParseTreeRule: #(
                                '`@condition ifTrue: `{:node | node isBlock not} ifFalse: `@block' 
                                '`@condition ifTrue: `@block ifFalse: `{:node | node isBlock not}' 
                                '`@condition ifFalse: `{:node | node isBlock not} ifTrue: `@block' 
                                '`@condition ifFalse: `@block ifTrue: `{:node | node isBlock not}' 
                                '`@condition ifTrue: `{:node | node isBlock not}' 
                                '`@condition ifFalse: `{:node | node isBlock not}')
                name: 'Non-blocks in ifTrue:/ifFalse: messages'
!

precedence
        ^self 
                createParseTreeRule: #('`{:node | node isMessage and: [node hasParentheses not and: [#(#+ #-) includes: node selector]]} * `@C')
                name: 'Inspect instances of "A + B * C" might be "A + (B * C)"'
!

sendsDeprecatedMethodToGlobal
        | nav patterns pattern wellKnownGlobals |
        RBParser isSmalltalkX ifTrue:[
            nav := SystemBrowser.
        ] ifFalse:[
            nav := SystemNavigation default.
        ].
        patterns := OrderedCollection new.
        wellKnownGlobals := IdentityDictionary new.
        Smalltalk
                keysAndValuesDo: [:k :v | v isBehavior
                                ifFalse: [(wellKnownGlobals
                                                at: v class
                                                ifAbsentPut: [Set new])
                                                add: k]].
        #(#'deprecated:' #'deprecated:explanation:' #'deprecated:block:'
          #'obsoleteMethodWarning' #'obsoleteMethodWarning:' #'obsoleteMethodWarning:from:')
                do: [:sym | (nav allCallsOn: sym)
                                do: [:mr | mr classIsMeta
                                                ifTrue: [mr actualClass
                                                                withAllSubclassesDo: [:cls | patterns
                                                                                add: (String
                                                                                                streamContents: [:s | s nextPutAll: cls theNonMetaClass name;
                                                                                                                
                                                                                                                nextPutAll: (self genericPatternForSelector: mr methodSymbol)])]]
                                                ifFalse: [wellKnownGlobals
                                                                keysAndValuesDo: [:gcls :gnames | (gcls includesBehavior: mr actualClass)
                                                                                ifTrue: [gnames
                                                                                                do: [:gname | pattern := String
                                                                                                                                streamContents: [:s | 
                                                                                                                                        s nextPutAll: gname.
                                                                                                                                        s
                                                                                                                                                nextPutAll: (self genericPatternForSelector: mr methodSymbol)]].
                                                                                        patterns add: pattern]]]]].
        patterns add: 'self beep: `@object1';
                 add: 'self beep'.

        ^ self createParseTreeRule: patterns name: 'Sends a deprecated message to a known global'
!

stringConcatenation
        | detector matcher concatenationMatcher |
        detector := self new.
        detector name: 'String concatenation instead of streams'.
        matcher := ParseTreeSearcher new.
        concatenationMatcher := ParseTreeSearcher new.
        concatenationMatcher matches: '`@receiver , `@argument'
                do: [:aNode :answer | true].
        matcher 
                matchesAnyOf: 
                        #('``@collection do: [:`each | | `@temps | ``@.Statements]' 
                        '``@collection do: [:`each | | `@temps | ``@.Statements] separatedBy: [| `@temps1 | ``@.Statements1]' 
                        '``@number to: ``@endNumber do: [:`i | | `@temps | ``@.Statements]' 
                        '``@collection detect: [:`each | | `@temps | ``@.Statements]' 
                        '``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [| `@temps1 | ``@.Statements1]' 
                        '``@collection select: [:`each | | `@temps | ``@.Statements]' 
                        '``@collection inject: ``@value into: [:`each | | `@temps | ``@.Statements]')
                do: 
                        [:aNode :answer | 
                        answer isNil 
                                ifTrue: 
                                        [(aNode arguments detect: 
                                                        [:each | 
                                                        each isBlock 
                                                                and: [concatenationMatcher executeTree: each initialAnswer: false]]
                                                ifNone: [nil]) notNil 
                                                ifTrue: [aNode]
                                                ifFalse: [nil]]
                                ifFalse: [answer]].
        detector matcher: matcher.
        ^detector
!

unoptimizedAndOr
        ^self 
                createParseTreeRule: #('(`@a and: `@b) and: `@c' '(`@a or: `@b) or: `@c')
                name: 'Uses "(a and: [b]) and: [c]" instead of "a and: [b and: [c]]"'
!

unoptimizedToDo
        ^self createParseTreeRule: #('(`@a to: `@b) do: `@c')
                name: 'Uses (to:)do: instead of to:do:'
!

yourselfNotUsed
        ^self createParseTreeRule: #('`{:node | node parent isUsed not} yourself')
                name: 'Doesn''t use the result of a yourself message'
! !

!ParseTreeLintRule class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!ParseTreeLintRule class methodsFor:'possible bugs'!

equalNotUsed
        ^self 
                createParseTreeRule: #('`{:node | node isMessage and: [node isUsed not and: [#(#= #== #~= #~~ #< #> #<= #>=) includes: node selector]]}')
                name: 'Doesn''t use the result of a =, ~=, etc.'
!

fileBlocks
        ^self createParseTreeRule: 
                                #('[| `@temps | 
                                        `var := `@object.  
                                        `@.statements] 
                                                        valueNowOrOnUnwindDo: 
                                                                [`var `@messages: `@args]' 
                                '[| `@temps | 
                                        `var := `@object.  
                                        `@.statements] 
                                                        valueOnUnwindDo: 
                                                                [`var `@messages: `@args]'
                                '[| `@temps | 
                                        `var := `@object.  
                                        `@.statements] 
                                                        ensure: 
                                                                [`var `@messages: `@args]' 
                                '[| `@temps | 
                                        `var := `@object.  
                                        `@.statements] 
                                                        ifCurtailed: 
                                                                [`var `@messages: `@args]') 
                name: 'Assignment inside unwind blocks should be outside.'
!

missingYourself
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [node parent isCascade and: [node isDirectlyUsed and: [node selector ~~ #yourself]]]}')
		name: 'Possible missing "; yourself"'
!

modifiesCollection
        | detector matcher |
        detector := self new.
        detector name: 'Modifies collection while iterating over it'.
        matcher := (ParseTreeSearcher new)
                                matchesAnyOf: 
                                                #('`@object do: [:`each | | `@temps | ``@.Statements]' 
                                                '`@object keysAndValuesDo: [:`eachKey :`each | | `@temps | ``@.Statements]' 
                                                '`@object doWithIndex: [:`eachKey :`each | | `@temps | ``@.Statements]' 
                                                '`@object collect: [:`each | | `@temps | ``@.Statements]' 
                                                '`@object select: [:`each | | `@temps | ``@.Statements]' 
                                                '`@object reject: [:`each | | `@temps | ``@.Statements]' 
                                                '`@object inject: `@value into: [:`sum :`each | | `@temps | ``@.Statements]')
                                        do: 
                                                [:aNode :answer | 
                                                answer isNil 
                                                        ifTrue: 
                                                                [(self modifiesTree: aNode receiver in: aNode arguments last) 
                                                                        ifTrue: [aNode]
                                                                        ifFalse: [nil]]
                                                        ifFalse: [answer]];
                                yourself.
        detector matcher: matcher.
        ^detector

    "Modified: / 04-08-2011 / 21:18:39 / cg"
!

returnInEnsure
	| detector matcher returnMatcher |
	detector := self new.
	detector name: 'Contains a return in an ensure: block'.
	returnMatcher := ParseTreeSearcher new.
	returnMatcher matches: '^`@object' do: [:aNode :answer | true].
	matcher := ParseTreeSearcher new.
	matcher 
		matchesAnyOf: #('``@rcv ensure: [| `@temps | ``@.Stmts]' 
						'``@rcv valueNowOrOnUnwindDo: [| `@temps | ``@.Stmts]' 
						'``@rcv ifCurtailed: [| `@temps | ``@.Stmts]' 
						'``@rcv valueOnUnwindDo: [| `@temps | ``@.Stmts]')
		do: 
			[:aNode :answer | 
			answer isNil 
				ifTrue: 
					[(returnMatcher executeTree: aNode arguments first initialAnswer: false) 
						ifTrue: [aNode]
						ifFalse: [nil]]
				ifFalse: [answer]].
	detector matcher: matcher.
	^detector
!

returnsIfTrue
	^self createParseTreeRule: 
				#('^`@condition ifTrue: [| `@temps | `@.statements]' 
				'^`@condition ifFalse: [| `@temps | `@.statements]') 
		name: 'Returns value of ifTrue:/ifFalse: without ifFalse:/ifTrue: block'
!

threeElementPoint
	| detector matcher |
	detector := self new.
	detector name: 'Possible three element point (e.g., x @ y + q @ r)'.
	matcher := (ParseTreeSearcher new)
				matches: '``@x @ ``@y'
					do: 
						[:aNode :answer | 
						answer isNil 
							ifTrue: 
								[| current |
								current := aNode parent.
								
								[current isNil or: 
										[current isMessage 
											and: [current selector == #@ or: [current selector isInfix not]]]] 
										whileFalse: [current := current parent].
								(current isNil or: [current isMessage and: [current selector isInfix not]]) 
									ifTrue: [nil]
									ifFalse: [aNode]]
							ifFalse: [answer]];
				yourself.
	detector matcher: matcher.
	^detector
!

usesAdd
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [(node selector == #add: or: [node selector == #addAll:]) and: [node isDirectlyUsed]]}')
		name: 'Uses the result of an add: message'
! !

!ParseTreeLintRule class methodsFor:'private'!

createMatcherFor: codeStrings method: aBoolean 
	| matcher |
	matcher := ParseTreeSearcher new.
	aBoolean 
		ifTrue: [matcher matchesAnyMethodOf: codeStrings do: [:aNode :answer | aNode]]
		ifFalse: [matcher matchesAnyOf: codeStrings do: [:aNode :answer | aNode]].
	^matcher
!

genericPatternForSelector: sel
	"
	ParseTreeLintRule genericPatternForSelector: #a
	ParseTreeLintRule genericPatternForSelector: #a:b:c:
	"
	^String streamContents: [ :s |
		sel keywords withIndexDo: [ :k :i | s space; nextPutAll: k.
			(k last = $:) ifTrue: [ s space; nextPutAll: '`@object'; print: i  ]]]
!

isArrayOfCharacters: anArray 
	anArray isEmpty ifTrue: [^false].
	1 to: anArray size
		do: [:each | (anArray at: each) class == Character ifFalse: [^false]].
	^true
!

isSearchingLiteralExpression: aMessageNode 
	| equalNode expressionNode |
	equalNode := aMessageNode selector = #| 
				ifTrue: [aMessageNode arguments first]
				ifFalse: [aMessageNode receiver].
	expressionNode := equalNode receiver isLiteral 
				ifTrue: [equalNode arguments first]
				ifFalse: [equalNode receiver].
	^self isSearchingLiteralExpression: aMessageNode for: expressionNode
!

isSearchingLiteralExpression: aSearchingNode for: anObjectNode 
	| argument arguments |
	aSearchingNode isMessage ifFalse: [^false].
	arguments := aSearchingNode arguments.
	arguments size = 1 ifFalse: [^false].
	argument := arguments first.
	(#(#= #==) includes: aSearchingNode selector) 
		ifTrue: 
			[^(aSearchingNode receiver = anObjectNode 
				and: [aSearchingNode arguments first isLiteral]) or: 
						[aSearchingNode arguments first = anObjectNode 
							and: [aSearchingNode receiver isLiteral]]].
	aSearchingNode selector = #| 
		ifTrue: 
			[^(self isSearchingLiteralExpression: aSearchingNode receiver
				for: anObjectNode) 
					and: [self isSearchingLiteralExpression: argument for: anObjectNode]].
	aSearchingNode selector = #or: ifFalse: [^false].
	argument isBlock ifFalse: [^false].
	argument body statements size = 1 ifFalse: [^false].
	^(self isSearchingLiteralExpression: aSearchingNode receiver
		for: anObjectNode) and: 
				[self isSearchingLiteralExpression: argument body statements first
					for: anObjectNode]
!

modifiesTree: aCollectionTree in: aParseTree 
	| notifier args |
	notifier := ParseTreeSearcher new.
	args := Array with: (RBVariableNode named: '`@object').
	notifier 
		matchesAnyTreeOf: (#(#add: #addAll: #remove: #removeAll:) collect: 
					[:each | 
					RBMessageNode 
						receiver: aCollectionTree
						selector: each
						arguments: args])
		do: [:aNode :answer | true].
	^notifier executeTree: aParseTree initialAnswer: false
! !

!ParseTreeLintRule class methodsFor:'unnecessary code'!

endTrueFalse
	| detector matcher |
	detector := self new.
	detector 
		name: 'Check for same statements at end of ifTrue:ifFalse: blocks'.
	matcher := (ParseTreeSearcher new)
				matchesAnyOf: 	
					#('`@object 
								ifTrue: [| `@temps1 | `@.Statements1. `.Statement] 
								ifFalse: [| `@temps2 | `@.Statements2. `.Statement]' 
						'`@object 
								ifTrue: [| `@temps1 | `.Statement. `@.Statements1] 
								ifFalse: [| `@temps2 | `.Statement. `@.Statements2]' 
						'`@object 
								ifFalse: [| `@temps1 | `@.Statements1. `.Statement] 
								ifTrue: [| `@temps2 | `@.Statements2. `.Statement]' 
						'`@object 
								ifFalse: [| `@temps1 | `.Statement. `@.Statements1] 
								ifTrue: [| `@temps2 | `.Statement. `@.Statement2]') 
					do: 
						[:aNode :answer | 
						answer isNil 
							ifTrue: 
								[| node |
								node := aNode arguments first body statements last.
								(node isVariable and: [node = aNode arguments last body statements last]) 
									ifTrue: [nil]
									ifFalse: [aNode]]
							ifFalse: [answer]];
				yourself.
	detector matcher: matcher.
	^detector
!

equalsTrue
	| detector matcher |
	detector := self new.
	detector name: 'Unnecessary "= true"'.
	matcher := (ParseTreeSearcher new)
				matchesAnyOf: #('true' 'false')
					do: 
						[:aNode :answer | 
						answer isNil 
							ifTrue: 
								[(aNode parent isMessage 
									and: [#(#= #== #~= #~~) includes: aNode parent selector]) 
										ifTrue: [aNode]
										ifFalse: [nil]]
							ifFalse: [answer]];
				yourself.
	detector matcher: matcher.
	^detector
!

extraBlock
	^self 
		createParseTreeRule: #('`{:node | node isMessage and: [node receiver isBlock and: [node parent isCascade not and: [#(#value #value: #value:value: #value:value:value: #valueWithArguments) includes: node selector]]]}')
		name: 'Block immediately evaluated'
!

unnecessaryAssignment
	^self 
		createParseTreeRule: #('^`{:aNode | aNode isAssignment and: [(aNode whoDefines: aNode variable name) notNil]}')
		name: 'Unnecessary assignment to a temporary variable'
! !

!ParseTreeLintRule methodsFor:'accessing'!

checkMethod: aSmalllintContext 
	(matcher canMatchMethod: aSmalllintContext compiledMethod) 
		ifFalse: [^self].
	(matcher executeTree: aSmalllintContext parseTree initialAnswer: nil) 
		notNil 
			ifTrue: 
				[result addClass: aSmalllintContext selectedClass
					selector: aSmalllintContext selector]
! !

!ParseTreeLintRule methodsFor:'initialize-release'!

matcher: aParseTreeMatcher
	matcher := aParseTreeMatcher
!

resetResult
	result := ParseTreeEnvironment new.
	result
		label: self name;
		matcher: matcher
! !

!ParseTreeLintRule methodsFor:'private'!

defaultResultClass
	^ParseTreeEnvironment
! !

!ParseTreeLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
