"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBProgramNodeVisitor subclass:#ParseTreeSearcher
	instanceVariableNames:'searches answer moreAnswers argumentSearches context messages
		currentSearchContext'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

ParseTreeSearcher comment:'ParseTreeSearcher walks over a normal source code parse tree using the visitor pattern, and then matches these nodes against the meta-nodes using the match:inContext: methods defined for the meta-nodes.

Instance Variables:
	answer  <Object>        the "answer" that is propagated between matches
	argumentSearches        <Collection of: (Association key: BRProgramNode value: BlockClosure)>   argument searches (search for the BRProgramNode and perform the BlockClosure when its found)
	context <BRSmallDictionary>     a dictionary that contains what each meta-node matches against. This could be a normal Dictionary that is created for each search, but is created once and reused (efficiency).
	searches        <Collection of: (Association key: BRProgramNode value: BlockClosure)>   non-argument searches (search for the BRProgramNode and perform the BlockClosure when its found)
	currentSearchContext    the current search context (from checkMethod:) so that match rules can determine where they are (see RBToDoFillRule)'
!


!ParseTreeSearcher class methodsFor:'instance creation'!

allMessageSends
    "return a searcher which searches all messageSends
     (collects messageSend nodes)"

    ^ self allMessageSendsForWhich:[:aNode | true].

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m self foo. self bar. self baz:(self foe)'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allMessageSends.
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
!

allMessageSendsForWhich:aFilter
    "return a searcher which searches all messageSends
     (collects messageSend nodes)"

    ^ (self new)
	matches: '``@rec `@msg: ``@args'
	do:[:aNode :ans |
		(aFilter value:aNode) ifTrue:[
		    ans add:aNode.
		].
		ans.
	   ];
	yourself

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m self foo. self bar. self baz:(self foe)'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allMessageSendsForWhich:[:aNode | aNode selector numArgs == 0].
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "Modified: / 11-05-2010 / 15:51:19 / cg"
!

allMessageSendsMatching:pattern ignoreCase:doIgnoreCase
    "return a searcher which searches all messageSends which match a given pattern
     (collects messageSend nodes)"

    |filter|

    pattern includesMatchCharacters ifFalse:[
	^ self allMessageSendsTo:pattern ignoreCase:doIgnoreCase
    ].

    filter := [:aNode |
		    |sel|

		    sel := aNode selector.
		    (pattern match:sel caseSensitive:doIgnoreCase not)
	      ].

    ^ self allMessageSendsForWhich:filter

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m self foo. self barFoe. self baz:(self foe)'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allMessageSendsMatching:'*fo*' ignoreCase:false.
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m self foo. self barFoe. self baz:(self foe)'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allMessageSendsMatching:'*fo*' ignoreCase:true.
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
!

allMessageSendsMatchingAny:patternCollection ignoreCase:doIgnoreCase
    "return a searcher which searches all messageSends which match any pattern of a given set of patterns
     (collects messageSend nodes)"

    |filter|

    (patternCollection contains:[:pattern | pattern includesMatchCharacters]) ifFalse:[
	^ self allMessageSendsToAny:patternCollection ignoreCase:doIgnoreCase
    ].

    filter := [:aNode |
		    |sel|

		    sel := aNode selector.
		    patternCollection contains:[:pattern |
			(pattern match:sel)
			or:[ doIgnoreCase and:[ pattern asLowercase match:sel asLowercase] ]]
	      ].

    ^ self allMessageSendsForWhich:filter

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m self foo. self barFoe. self xFoe.  self baz:(self foe)'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allMessageSendsMatchingAny:#('fo*' 'b*Fo*') ignoreCase:false.
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
!

allMessageSendsTo:searchSelector ignoreCase:doIgnoreCase
    "return a searcher which searches all messageSends with a particular selector
     (collects messageSend nodes)"

    |filter|

    doIgnoreCase ifTrue:[
	filter := [:aNode |
			|sel|

			sel := aNode selector.
			(searchSelector sameAs:sel).
		  ].
    ] ifFalse:[
	filter := [:aNode |
			|sel|

			sel := aNode selector.
			(searchSelector = sel).
		  ].
    ].

    ^ self allMessageSendsForWhich:filter

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m self foo. self barFoe. self xFoe.  self baz:(self foe)'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allMessageSendsTo:#'xfoe' ignoreCase:true.
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
!

allMessageSendsToAny:selectorCollection ignoreCase:doIgnoreCase
    "return a searcher which searches all messageSends with a selector from a given set of selectors
     (collects messageSend nodes)"

    |filter|

    filter := [:aNode |
		    |sel|

		    sel := aNode selector.
		    selectorCollection contains:[:pattern |
			(pattern = sel)
			or:[ doIgnoreCase and:[ pattern asLowercase = sel asLowercase] ]]
	      ].

    ^ self allMessageSendsForWhich:filter

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m self foo. self barFoe. self xFoe.  self baz:(self foe)'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allMessageSendsToAny:#('foe' 'xfoe') ignoreCase:true.
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
!

allModificationsOfAnyVariableIn:aCollectionOfVariableNames
    "return a searcher which searches all modifications of any variable in aCollectionOfVariableNames
     (collects assignment nodes)"

    |filter|

    (aCollectionOfVariableNames contains:[:aVar | aVar includesMatchCharacters])
    ifTrue:[
	filter := [:anAssignmentNode |
		    |varName|

		    varName := anAssignmentNode variable name.
		    aCollectionOfVariableNames contains:[:aNamePattern | aNamePattern match:varName]
	      ].
    ] ifFalse:[
	filter := [:anAssignmentNode |
		    aCollectionOfVariableNames includes:anAssignmentNode variable name
	      ].
    ].

    ^ self allModificationsOfVariablesMatching:filter

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz faz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := faz := 5.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allModificationsOfAnyVariableIn:#('foo' 'baz').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz faz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := faz := 5.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allModificationsOfAnyVariableIn:#('f*' '*z').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "Modified (comment): / 14-01-2012 / 15:07:28 / cg"
!

allModificationsOfGlobalVariablesMatching:aFilter
    "return a searcher which searches all variable modifications
     (collects assignement nodes)"

    ^ (self new)
	matches: '`Var := ``@expr'
	do:[:aNode :ans |
		(aFilter value:aNode) ifTrue:[
		    ans add:aNode.
		].
		ans.
	   ];
	yourself

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| Array := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allModificationsOfGlobalVariablesMatching:[:aNode | true].
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "Created: / 14-01-2012 / 16:02:01 / cg"
!

allModificationsOfVariablesMatching:aFilter
    "return a searcher which searches all variable modifications
     (collects assignement nodes)"

    ^ (self new)
	matches: '`var := ``@expr'
	do:[:aNode :ans |
		(aFilter value:aNode) ifTrue:[
		    ans add:aNode.
		].
		ans.
	   ];
	yourself

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allModificationsOfVariablesMatching:[:aNode | true].
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "Modified: / 14-01-2012 / 16:01:26 / cg"
!

allReadsOfAnyVariableIn:aCollectionOfVariableNames
    "return a searcher which searches all reads of any variable in aCollectionOfVariableNames
     (collects variable nodes)"

    |filter|

    (aCollectionOfVariableNames contains:[:aVar | aVar includesMatchCharacters])
    ifTrue:[
	filter := [:aVariableNode |
			aCollectionOfVariableNames contains:[:aNamePattern | aNamePattern match:aVariableNode name]
		  ].
    ] ifFalse:[
	filter := [:aVariableNode |
			aCollectionOfVariableNames includes:aVariableNode name
		  ].
    ].

    ^ self allReadsOfVariablesMatching:filter

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReadsOfAnyVariableIn:#('foo').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5. self bar. self bar:baz'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReadsOfAnyVariableIn:#('foo' 'bar').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5. self bar. self bar:baz'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReadsOfAnyVariableIn:#('b*').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
!

allReadsOfVariablesMatching:aFilter
    "return a searcher which searches all variable reads
     (collects variable nodes)"

    |searcher|

    searcher := self new.
    searcher
	matches: '`var'
	do:[:aNode :ans |
		|parent|

		((parent := aNode parent) isAssignment not
		or:[parent variable ~~ aNode
		or:[parent value == aNode]]) ifTrue:[
		    (aFilter value:aNode) ifTrue:[
			ans add:aNode.
		    ]
		].
		ans.
	   ].

    ^ searcher

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReadsOfVariablesMatching:[:aNode | true].
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := foo. foo := foo.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReadsOfVariablesMatching:[:aNode | true].
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "Modified: / 14-01-2012 / 16:02:28 / cg"
!

allReferencesToAnyVariableIn:aCollectionOfVariableNames
    "return a searcher which searches all references to any variable in aCollectionOfVariableNames
     (collects variable nodes)"

    |filter|

    (aCollectionOfVariableNames contains:[:aVar | aVar includesMatchCharacters])
    ifTrue:[
	filter := [:aVariableNode |
			aCollectionOfVariableNames contains:[:aNamePattern | aNamePattern match:aVariableNode name]
		  ].
    ] ifFalse:[
	filter := [:aVariableNode |
			aCollectionOfVariableNames includes:aVariableNode name
		  ].
    ].

    ^ self allReferencesToVariablesMatching:filter

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReferencesToAnyVariableIn:#('foo').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5. self bar. self bar:baz'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReferencesToAnyVariableIn:#('foo' 'bar').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5. self bar. self bar:baz'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReferencesToAnyVariableIn:#('b*').
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "
!

allReferencesToVariablesMatching:aFilter
    "return a searcher which searches all variable references
     (collects variable nodes)"

    ^ (self new)
	matches: '`var'
	    do:[:aNode :ans |
		(aFilter value:aNode) ifTrue:[
		    ans add:aNode.
		].
		ans.
	    ];
	yourself.

    "
     |tree searcher nodes|

     tree := RBParser
		     parseSearchMethod:'m |foo bar baz| foo := 1. bar := 2. foo := 3. bar := foo := 4. foo := bar := 5.'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher allReferencesToVariablesMatching:[:aNode | true].
     searcher executeTree:tree initialAnswer:(nodes := OrderedCollection new).
     nodes.
    "

    "Modified: / 14-01-2012 / 16:02:40 / cg"
!

getterMethod: aVarName
    "return a searcher which matches a getter method.
     Returns nil if no match, the selector if it does."

    ^(self new)
	    matchesMethod: '`method ^' , aVarName do: [:aNode :ans | aNode selector];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ foo'
		     onError: [:str :pos | nil].

     searcher := self getterMethod:'foo'.
     searcher executeTree:tree.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ bar'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher getterMethod:'foo'.
     searcher executeTree:tree.
    "

    "Modified: / 11-05-2010 / 15:49:48 / cg"
!

handlesException
    "return a searcher which matches a method which handles an exception.
     Returns false if no match, true otherwise."

    |codePatterns|

    codePatterns := OrderedCollection new:11.
    codePatterns add: '`@Ex handle: `@Handler do: `@Block'.
    codePatterns add: '`@Ex handle: `@Handler from: `@Originator do: `@Block'.
    codePatterns add: '`@Ex answer: `@Handler do: `@Block'.
    codePatterns add: '`@Ex evaluate: `@Block ifRaised: `H@andler'.
    codePatterns add: '`@Ex catch: `@Block'.
    codePatterns add: '`@Ex deferAfter: `@Block'.
    codePatterns add: '`@Ex ignoreIn: `@Block'.
    codePatterns add: '`@Block valueWithExceptionHandler: `@Handler'.
    codePatterns add: '`@Block on: `@Ex do: `@Handler'.
    codePatterns add: '`@Block on: `@Ex do: `@Handler ensure: `@Cleanup'.
    codePatterns add: '`@Block on: `@Ex1 do: `@Handler1 on: `@Ex2 do: `@Handler2'.

    ^ (self new)
	    answer:false;
	    matchesAnyOf: codePatterns do: [:aNode :ans | true ];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg [ foo := arg ] on:Error do:[]'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher handlesException.
     searcher executeTree:tree.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg foo := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher handlesException.
     searcher executeTree:tree.
    "

    "Created: / 11-05-2010 / 16:00:06 / cg"
!

hasGuardingIf
	^(self new)
		answer:false;
		matchesAnyMethodOf:
				#(
				    '`@method: `@args `@expr ifTrue:[ `@.stats ]'
				    '`@method: `@args `@expr ifFalse:[ `@.stats ]'
				)
			do: [:aNode :ans | true];
		yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg arg ifTrue:[ arg fooBar ]'
		     onError: [:str :pos | nil].

     searcher := self hasGuardingIf.
     searcher executeTree:tree initialAnswer:false.

     tree := RBParser
		     parseSearchMethod:'foo:arg arg fooBar'
		     onError: [:str :pos | nil].

     searcher := self hasGuardingIf.
     searcher executeTree:tree initialAnswer:false.
    "

    "Modified: / 11-05-2010 / 15:48:44 / cg"
!

isGetterMethod
    "return a searcher which matches any getter method.
     Returns false if no match, true if it does."

    ^ (self new)
	    answer:false;
	    matchesMethod: '`method ^ `method'
		do: [:aNode :ans | true];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ foo'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isGetterMethod.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ bar'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isGetterMethod.
     searcher executeTree:tree initialAnswer:false.
    "

    "Modified: / 11-05-2010 / 15:48:36 / cg"
!

isGetterOrSetterMethod
    "return a searcher which matches a getter or setter method.
     Returns false if no match, true if it does."

    ^ (self new)
	    answer:false;
	    matchesAnyMethodOf: (Array
				    with: '`method ^ `method'
				    with: '`method: `arg `method := `arg'
				    with: '`method: `arg ^ `method := `arg')
		    do: [:aNode :ans | true];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg foo := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isGetterOrSetterMethod.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ foo'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isGetterOrSetterMethod.
     searcher executeTree:tree initialAnswer:false.
    "

    "Modified: / 11-05-2010 / 15:48:19 / cg"
!

isGetterOrSetterMethod:aVarName
    "return a searcher which matches a getter or setter method for aVarName.
     Returns false if no match, true if it does."

    ^ (self new)
	    answer:false;
	    matchesAnyMethodOf: (Array
				    with: '`method ^ ', aVarName
				    with: '`method: `arg ',aVarName,' := `arg'
				    with: '`method: `arg ^ ',aVarName,' := `arg')
		    do: [:aNode :ans | true];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg foo := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isGetterOrSetterMethod:'foo'.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ foo'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isGetterOrSetterMethod'foo'.
     searcher executeTree:tree initialAnswer:false.
    "

    "Modified: / 11-05-2010 / 15:48:15 / cg"
!

isJustReturningLiteralString:aLiteralString
    "return a searcher which matches a simple ^ literal.
     Returns false if no match, true if it does."

    ^ (self new)
	    answer:false;
	    matchesMethod: '`method ^ ',aLiteralString
		       do: [:aNode :ans | true];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^true'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningLiteralString:'0'.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ 0'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningLiteralString:'0'.
     searcher executeTree:tree initialAnswer:false.
    "

    "Created: / 23-07-2011 / 14:11:58 / cg"
!

isJustReturningSomething
    "return a searcher which matches a simple ^ something.
     That method definitely has no side effects.
     Returns false if no match, true if it does."

    ^ (self new)
	    answer:false;
	    matchesAnyMethodOf: #(
				   '`method ^ `#n'
				   '`method ^ `var'
				 )
		    do: [:aNode :ans | true];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^true'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningSomething.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^123'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningSomething.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ bar'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningSomething.
     searcher executeTree:tree initialAnswer:false.
    "


    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ 123 bla'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningSomething.
     searcher executeTree:tree initialAnswer:false.
    "
!

isJustReturningTrueOrFalse
    "return a searcher which matches a simple ^true or ^false method (i.e. a tester).
     Returns false if no match, true if it does."

    ^ (self new)
	    answer:false;
	    matchesAnyMethodOf: (Array
				    with: '`method ^ true'
				    with: '`method ^ false')
		    do: [:aNode :ans | true];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^true'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningTrueOrFalse.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^123'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isJustReturningTrueOrFalse.
     searcher executeTree:tree initialAnswer:false.
    "

    "Created: / 22-12-2010 / 11:44:47 / cg"
!

isSetterMethod
    "return a searcher which matches a setter method.
     Returns false if no match, true if it does."

    ^ (self new)
	    answer:false;
	    matchesAnyMethodOf: (Array
				    with: '`method: `arg `method := `arg'
				    with: '`method: `arg ^ `method := `arg')
		    do: [:aNode :ans | true];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg foo := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isSetterMethod.
     searcher executeTree:tree initialAnswer:false.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg bar := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher isSetterMethod.
     searcher executeTree:tree initialAnswer:false.
    "

    "Modified: / 11-05-2010 / 15:48:10 / cg"
!

justDelegates
    "return a searcher which matches a delegating method.
     Returns false if no match, true if it does."

	^(self new)
		answer:false;
		matchesAnyMethodOf:
				#('`@method: `@args ^ `var `@method: `@args'
				)
			do: [:aNode :ans | true];
		yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ instvar foo'
		     onError: [:str :pos | nil].

     searcher := self justDelegates.
     searcher executeTree:tree.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo ^ self foo + 1'
		     onError: [:str :pos | nil].

     searcher := self justDelegates.
     searcher executeTree:tree
    "

    "Created: / 11-05-2010 / 14:26:34 / cg"
!

justSendsSuper
	"return a searcher which matches a super-sending method.
	 Returns false if no match, true if it does."

	^(self new)
		answer:false;
		matchesAnyMethodOf:
				#('`@method: `@args ^super `@method: `@args'
				'`@method: `@args super `@method: `@args')
			do: [:aNode :ans | true];
		yourself

    "Modified: / 11-05-2010 / 14:35:03 / cg"
!

raisesException
    "return a searcher which matches a method which raises an exception.
     Returns false if no match, true otherwise."

    |codePatterns|

    codePatterns := OrderedCollection new:23.
    codePatterns add: '`@Ex raise'.
    codePatterns add: '`@Ex raiseErrorString: `@Message '.
    codePatterns add: '`@Ex raiseErrorString: `@Message in: `@Con'.
    codePatterns add: '`@Ex raiseFrom: `@Originator'.
    codePatterns add: '`@Ex raiseRequest'.
    codePatterns add: '`@Ex raiseRequestErrorString: `@Message '.
    codePatterns add: '`@Ex raiseRequestFrom: `@Originator'.
    codePatterns add: '`@Ex raiseRequestWith: `@Param '.
    codePatterns add: '`@Ex raiseRequestWith: `@Param errorString: `@Message '.
    codePatterns add: '`@Ex raiseRequestWith: `@Param errorString: `@Message in: `@Con'.
    codePatterns add: '`@Ex raiseRequestWith: `@Param in: `@Con'.

    codePatterns add: '`@Ex raiseSignal'.
    codePatterns add: '`@Ex raiseSignal: `@Message'.
    codePatterns add: '`@Ex raiseSignal: `@Message with: `@Param'.
    codePatterns add: '`@Ex raiseSignalErrorString: `@Message'.

    codePatterns add: '`@Ex raiseSignalWith: `@Param '.
    codePatterns add: '`@Ex raiseSignalWith: `@Param errorString: `@Message '.
    codePatterns add: '`@Ex raiseWith: `@Param'.
    codePatterns add: '`@Ex raiseWith: `@Param errorString: `@Message'.
    codePatterns add: '`@Ex raiseWith: `@Param in: `@Con'.

    codePatterns add: '`@Ex query'.
    codePatterns add: '`@Ex queryWith: `@Param'.

    codePatterns add: '`@Ex notify: `@Message'.

    ^ (self new)
	    answer:false;
	    matchesAnyOf: codePatterns do: [:aNode :ans | true ];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg [ foo := arg ] on:Error do:[ Error raiseRequest ]'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher raisesException.
     searcher executeTree:tree.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg foo := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher raisesException.
     searcher executeTree:tree.
    "

    "Created: / 11-05-2010 / 16:07:16 / cg"
!

returnSetterMethod: aVarName
	"return a searcher which matches a returning setter method.
	 Returns nil if no match, the selector if it does."

	^(self new)
		matchesMethod: '`method: `arg ^' , aVarName , ' := `arg'
			do: [:aNode :ans | aNode selector];
		yourself

    "Modified: / 11-05-2010 / 14:34:25 / cg"
    "Modified: / 09-04-2014 / 13:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setterMethod: aVarName
    "return a searcher which matches a setter method.
     Returns nil if no match, the selector if it does."

    ^ (self new)
	    matchesAnyMethodOf: (Array
				    with: '`method: `arg ' , aVarName , ' := `arg'
				    with: '`method: `arg ^' , aVarName , ' := `arg')
		    do: [:aNode :ans | aNode selector];
	    yourself

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg foo := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher setterMethod:'foo'.
     searcher executeTree:tree.
    "

    "
     |tree searcher|

     tree := RBParser
		     parseSearchMethod:'foo:arg bar := arg'
		     onError: [:str :pos | nil].

     searcher := ParseTreeSearcher setterMethod:'foo'.
     searcher executeTree:tree.
    "

    "Modified: / 11-05-2010 / 14:34:03 / cg"
! !

!ParseTreeSearcher class methodsFor:'accessing'!

treeMatching: aString in: aParseTree
	(self new)
		matches: aString do: [:aNode :answer | ^aNode];
		executeTree: aParseTree.
	^nil
!

treeMatchingStatements: aString in: aParseTree
	| notifier tree lastIsReturn formattedCode optionalPeriod|
	notifier := self new.
	tree := RBParser parseExpression: aString.
	lastIsReturn := tree lastIsReturn.

	formattedCode := tree formattedCode.
	optionalPeriod := tree lastHasPeriod ifTrue:[''] ifFalse:['.'].

	notifier matches: (lastIsReturn
				ifTrue: ['| `@temps | `@.S1. ' , formattedCode]
				ifFalse: ['| `@temps | `@.S1. ' , formattedCode , optionalPeriod , ' `@.S2'])
		do: [:aNode :answer | ^tree].
	notifier executeTree: aParseTree.
	^nil
! !

!ParseTreeSearcher class methodsFor:'private'!

buildSelectorString: aSelector
        | stream keywords |
        aSelector numArgs = 0 ifTrue: [^aSelector].
        stream := WriteStream on:''.
        keywords := aSelector keywords.
        1 to: keywords size
                do:
                        [:i |
                        stream nextPutAll: (keywords at: i);
                                nextPutAll: ' ``@arg';
                                nextPutAll: i printString;
                                nextPut: $ ].
        ^stream contents
!

buildSelectorTree: aSelector
	aSelector isEmpty ifTrue: [^nil].
	^RBParser parseRewriteExpression: '``@receiver '
				, (self buildSelectorString: aSelector)
		onError: [:err :pos | ^nil]
!

buildTree: aString method: aBoolean
	^aBoolean
		ifTrue: [RBParser parseRewriteMethod: aString]
		ifFalse: [RBParser parseRewriteExpression: aString]
! !

!ParseTreeSearcher class methodsFor:'utilities'!

isDefinitelyGetterMethod:aMethod
    "checks a method for being a true getter (name equals variable returned)"

    "/ OBSOLETE - renamed
    ^ self methodIsGetterMethod:aMethod
!

matchMethod:aMethod with:aMatcher
    "common helper for common matches"

    |mClass selector parseTree|

    (mClass := aMethod mclass) isNil ifTrue:[^ false].
    selector := aMethod selector.
    parseTree := mClass parseTreeFor:selector.
    parseTree isNil ifTrue:[^ false]. "/ mhmh - parse error
    ^ (aMatcher executeTree: parseTree initialAnswer:false)
!

methodIsGetterMethod:aMethod
    "checks a method for being a true getter (name equals variable returned)"

    |mClass selector parseTree matcher|

    (mClass := aMethod mclass) isNil ifTrue:[^ false].
    selector := aMethod selector.
    parseTree := mClass parseTreeFor:selector.
    parseTree isNil ifTrue:[^ false]. "/ mhmh - parse error

    matcher := self getterMethod:selector.
    ^ (matcher executeTree: parseTree initialAnswer:nil) == selector

    "Created: / 28-08-2013 / 17:06:15 / cg"
!

methodIsJustReturningSomething:aMethod
    "checks a method for being a simple return something method
     (i.e. definitely no side effects)"

    ^ self matchMethod:aMethod with:(self isJustReturningSomething)

    "Created: / 28-08-2013 / 17:06:15 / cg"
!

methodIsSetterMethod:aMethod
    "checks a method for being a true setter (name equals variable returned)"

    |mClass selector parseTree matcher|

    (mClass := aMethod mclass) isNil ifTrue:[^ false].
    selector := aMethod selector.
    selector isKeyword ifFalse:[^ false].
    selector argumentCount == 1 ifFalse:[^ false].

    parseTree := mClass parseTreeFor:selector asSymbol.
    parseTree isNil ifTrue:[^ false]. "/ mhmh - parse error

    matcher := self setterMethod:(selector copyButLast:1) asSymbol.
    ^ (matcher executeTree: parseTree initialAnswer:nil) == selector

    "Created: / 28-08-2013 / 17:06:15 / cg"
! !

!ParseTreeSearcher methodsFor:'accessing'!

addArgumentRule: aParseTreeRule
	argumentSearches add: aParseTreeRule.
	aParseTreeRule owner: self
!

addArgumentRules: ruleCollection
	ruleCollection do: [:each | self addArgumentRule: each]
!

addArgumentSearches: aSearchCondition
	aSearchCondition key do: [:each | self addArgumentSearch: each -> aSearchCondition value]
!

addMethodSearches: aSearchCondition
	aSearchCondition key do: [:each | self addMethodSearch: each -> aSearchCondition value]
!

addRule: aParseTreeRule
	searches add: aParseTreeRule.
	aParseTreeRule owner: self
!

addRules: ruleCollection
	ruleCollection do: [:each | self addRule: each]
!

addSearches: aSearchCondition
	aSearchCondition key do: [:each | self addSearch: each -> aSearchCondition value]
!

answer
	^answer
!

computeQuickSearchStrings
    "Compute a collection of OR-strings to search for.
     Each is a string or collection of AND-strings.
     This is collected from the individual searches,
     of which each may return a collection of AND-strings.
     OR means: if any of the elements is present, do a full match;
               otherwise reject.
     AND means: all of the elements must be present for a full match,
               otherwise reject"

    searches do:[:eachSearch |
        eachSearch computeQuickSearchStrings.
    ].
!

context
	^context
!

currentSearchContext
    ^ currentSearchContext
!

currentSearchContext:aSearchContext
    currentSearchContext := aSearchContext
!

executeMethod: aParseTree
	searches detect: [:each | (each performOn: aParseTree) notNil] ifNone: [].
	^answer
!

executeMethod: aParseTree initialAnswer: anObject
	answer := anObject.
	^ self executeMethod: aParseTree
!

executeTree: aParseTree
        "Save our current context, in case someone is performing another search inside a match."

        | oldContext |
        
        oldContext := context.
        Smalltalk isSmalltalkX ifTrue:[
            context := Dictionary new.
        ] ifFalse:[
            context := RBSmallDictionary new.
        ].
        self visitNode: aParseTree.
        context := oldContext.
        ^answer
!

executeTree: aParseTree initialAnswer: aValue
	answer := aValue.
	^self executeTree: aParseTree
!

messages
        messages notNil ifTrue: [^messages].
        argumentSearches notEmpty ifTrue: [^messages := #()].

        messages := Set new.
        searches do: [:each |
            | searchMessages |

            searchMessages := each sentMessages.
            "/ in ST/X, optimized messages are also in the literal array..
            Smalltalk isSmalltalkX ifFalse:[
                RBProgramNode optimizedSelectors
                    do: [:sel | searchMessages remove: sel ifAbsent: []].
            ].
            searchMessages isEmpty ifTrue: [^messages := #()].
            messages addAll: searchMessages
        ].
        ^messages := messages asArray

    "Modified: / 08-07-2013 / 11:30:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-11-2016 / 12:44:05 / cg"
!

moreAnswers
    <resource: #obsolete>
    "if the rule found multiple places, this returns the other answers"

    self obsoleteFeatureWarning:'moreAnswers are no longer collected'.
    ^moreAnswers

    "Created: / 07-03-2012 / 21:57:51 / cg"
!

searches
    ^ searches 
!

setMessages:aCollection
    messages := aCollection

    "Created: / 31-07-2013 / 13:26:31 / cg"
! !

!ParseTreeSearcher methodsFor:'converting'!

asSearcher
    ^self

    "Created: / 31-01-2012 / 14:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeSearcher methodsFor:'enumerating'!

matchingNodesForSource: aString tree: anRBProgramNode do: aBlock
    "Evaluate block for each node in source and its corresponding tree that matches"

    | enumerator |

    enumerator := ParseTreeSearcher new.
    searches do:[:rule|
        enumerator addRule: (rule copyMatchDo: aBlock)
    ].
    "/ cg: FIX: enumerator did not know the current search context!!
    enumerator currentSearchContext:currentSearchContext.
    
    "JV@2012-02-04: Certainly a HACK, but sometimes rule
     verification/answer block accesses instvars, namespace etc. - sigh.
     We need to be more clever"
    [
        enumerator executeTree: anRBProgramNode initialAnswer: nil.
    ] on: Error do:[:ex|
        Transcript showCR:'[ParseTreeSearcher] error: ',ex description.
        Transcript show:'[ParseTreeSearcher] caught by matchingNodesForSource:tree:do: in: '.
        Transcript showCR:(DebugView interestingContextFrom: ex suspendedContext).
        self breakPoint:#jv.
    ]

    "Created: / 02-02-2012 / 23:24:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionIntervalsForSource: aString tree: anRBProgramNode do: aBlock
    "Evaluate block for each node's sourceInterval (for highlighting)"

    ^self 
        selectionIntervalsForSource: aString 
        tree: anRBProgramNode rule: nil in: nil 
        do: aBlock

    "Created: / 02-02-2012 / 21:16:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionIntervalsForSource: aString tree: anRBProgramNode in: aClass do: aBlock
    "Evaluate block for each node's sourceInterval (for highlighting)"

    ^ self
        selectionIntervalsForSource: aString 
        tree: anRBProgramNode rule: nil in: aClass 
        do: aBlock
!

selectionIntervalsForSource: aString tree: anRBProgramNode rule:aRuleOrNil in: aClass do: aBlock
    "Evaluate block for each node's sourceInterval (for highlighting).
     If aRuleOrNil is not nil, it is given a chance to provide a better interval
     for highlighting the seletor of the node only"

    currentSearchContext := SmalllintContext new selectedClass:aClass.
    currentSearchContext explicitSourceCode:aString.
    
    ^self 
        matchingNodesForSource: aString 
        tree: anRBProgramNode
        do: [:node|
            |interval|
            
            interval := aRuleOrNil isNil
                            ifTrue:[
                                node sourceInterval]
                            ifFalse:[  
                                aRuleOrNil sourceIntervalForNode:node inTree:anRBProgramNode source:aString].    
            aBlock value: interval 
        ]

    "Created: / 02-12-2014 / 11:17:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeSearcher methodsFor:'initialize-release'!

answer: anObject
        "probably am only interested in the very first answer"

        anObject isNil ifTrue:[^ self].

"/ disabled because noone uses this,
"/ and it possibly collects huge amounts of data - for nothing!!
false ifTrue:[
        "/ cg: used to be 'answer notNil ifTrue' here;
        "/ that does fail for search rules, which initialize the
        "/ answer to false, and test for true at the end.

        (answer notNil and:[answer ~~ false]) ifTrue:[
            moreAnswers isNil ifTrue:[
                moreAnswers := OrderedCollection new.
            ].
            moreAnswers add:anObject.
            "/ ^ self
        ].
].
        answer := anObject

    "Modified: / 07-03-2012 / 21:59:19 / cg"
!

initialize
	super initialize.
	Smalltalk isSmalltalkX ifTrue:[
	    context := Dictionary new.
	] ifFalse:[
	    context := RBSmallDictionary new.
	].
	searches := OrderedCollection new.
	argumentSearches := OrderedCollection new: 0.
	answer := nil
! !

!ParseTreeSearcher methodsFor:'obsolete'!

addArgumentSearch: aSearchCondition
	self addArgumentRule: (self buildParseTreeRuleFor: aSearchCondition)
!

addMethodSearch: aSearchCondition
	self addRule: (self buildMethodParseTreeRuleFor: aSearchCondition)
!

addSearch: aSearchCondition
	self addRule: (self buildParseTreeRuleFor: aSearchCondition)
!

buildMethodParseTreeRuleFor: aSearchCondition
	^(aSearchCondition key isKindOf: RBProgramNode)
		ifTrue:
			[RBSearchRule searchForTree: aSearchCondition key
				thenDo: aSearchCondition value]
		ifFalse:
			[RBSearchRule searchForMethod: aSearchCondition key
				thenDo: aSearchCondition value]
!

buildParseTreeRuleFor: aSearchCondition
	^(aSearchCondition key isKindOf: RBProgramNode)
		ifTrue:
			[RBSearchRule searchForTree: aSearchCondition key
				thenDo: aSearchCondition value]
		ifFalse:
			[RBSearchRule searchFor: aSearchCondition key thenDo: aSearchCondition value]
! !

!ParseTreeSearcher methodsFor:'private'!

foundMatch
!

lookForMoreMatchesInContext: oldContext
	oldContext keysAndValuesDo:
			[:key :value |
			(key isString not and: [key recurseInto])
				ifTrue: [value do: [:each | self visitNode: each]]]
!

performSearches: aSearchCollection on: aNode
        | nodeIn nodeOut |

        nodeIn := aNode.
        aSearchCollection do:[:eachSearch |
            nodeOut := eachSearch performOn: nodeIn.
            nodeOut notNil ifTrue:[
                self foundMatch.

                "please read the comment in alwaysPerformAllSearches"
                self alwaysPerformAllSearches ifTrue:[
                    "/ new behavior
                    nodeIn := nodeOut
                ] ifFalse:[
                    ^ nodeOut
                ].
            ]
        ].
        ^ nodeOut
!

recusivelySearchInContext
	"We need to save the matched context since the other searches might overwrite it."

	| oldContext |
	oldContext := context.
	Smalltalk isSmalltalkX ifTrue:[
	    context := Dictionary new.
	] ifFalse:[
	    context := RBSmallDictionary new.
	].
	self lookForMoreMatchesInContext: oldContext.
	context := oldContext
!

visitNode: aNode matching: aSearchCollection
	| value |
	1 to: aSearchCollection size
		do:
			[:i |
			value := (aSearchCollection at: i) performOn: aNode.
			value notNil
				ifTrue:
					[self foundMatch.
					^value]].
	aNode acceptVisitor: self.
	^aNode
! !

!ParseTreeSearcher methodsFor:'searching'!

matches: aString do: aBlock
	self addRule: (RBSearchRule searchFor: aString thenDo: aBlock)
!

matchesAnyArgumentOf: stringCollection do: aBlock
	stringCollection do: [:each | self matchesArgument: each do: aBlock]
!

matchesAnyMethodOf: aStringCollection do: aBlock
	aStringCollection do: [:each | self matchesMethod: each do: aBlock]
!

matchesAnyOf: aStringCollection do: aBlock
	aStringCollection do: [:each | self matches: each do: aBlock]
!

matchesAnyTreeOf: treeCollection do: aBlock
	treeCollection do: [:each | self matchesTree: each do: aBlock]
!

matchesArgument: aString do: aBlock
	self addArgumentRule: (RBSearchRule searchFor: aString thenDo: aBlock)
!

matchesArgumentTree: aBRProgramNode do: aBlock
	self
		addArgumentRule: (RBSearchRule searchForTree: aBRProgramNode thenDo: aBlock)
!

matchesMethod: aString do: aBlock
	self addRule: (RBSearchRule searchForMethod: aString thenDo: aBlock)
!

matchesTree: aBRProgramNode do: aBlock
    self addRule: (RBSearchRule searchForTree: aBRProgramNode thenDo: aBlock)
! !

!ParseTreeSearcher methodsFor:'testing'!

alwaysPerformAllSearches
    "a flag, to fix a bug? in the performSearches,
     which stops after the first matching searchRule, even if there are more rules to be
     considered.
     This bug affects the literal replacements, inside literal arrays,
     in case multiple such replaces have been defined
     eg. a rewriter like:
        replacer := ParseTreeSourceRewriter new.
        replacer replaceLiteral: #lit1 with: #newLit1.
        replacer replaceLiteral: #lit2 with: #newLit2.

     The original searcher would only replace one literal and stop performing other replaces,
     after the first hit. However, if there is a single literal array with both lit1 and lit2 inside,
     all other replaces must also be performed.

     As I have no idea on what other effects an unconditional change in performSearches might have,
     this new behavior is made conditional on the return value of this method
     (and it is redefined in ParseTreeSourceRewriter"

     ^ false
!

canMatchMethod: aCompiledMethod
        "this does a quickReject based on the set of sent messages
         (in the searches vs. messages in the method)"
         
        |msgs source|

        msgs := self messages.
        msgs isEmpty ifTrue:[
            (searches notEmpty and:[searches first hasQuickSearchStrings not]) ifTrue:[
                "/ there is more that we can use - see quickReject
                self computeQuickSearchStrings.
            ].
            source := aCompiledMethod source.
            source isNil ifTrue:[
                ('no source for method: ',aCompiledMethod whoString) infoPrintCR.
                ^ false
            ].
            (self canQuicklyReject:source) ifTrue:[
                ^ false
            ].    
            ^ true
        ].
        
        "/ speedup: only enumerate literals once:
        aCompiledMethod isMethod ifTrue:[
            aCompiledMethod literalsDo:[:lit |
                (msgs includes:lit) ifTrue:[^ true]
            ].
            ^ false.
        ].
        "/ old code:
        ^ msgs contains: [:each | aCompiledMethod sendsSelector: each]

    "Modified (comment): / 19-11-2016 / 13:25:30 / cg"
!

canQuicklyReject:sourceCode
    "if I have quickSearchStrings, try a quick reject based on them.
     This may generate false negatives (i.e. lets source pass, even though
     it should not), but still reduces the amount of parser work in the order
     of 90%, thus making code searches 10 times faster."

    "/ any of the searh rules?

    searches isEmptyOrNil ifTrue:[^ false].
    ^ searches conform:[:eachSearch | eachSearch canQuicklyReject:sourceCode]
! !

!ParseTreeSearcher methodsFor:'visiting'!

visitArgument: aNode
	| value |
	value := self performSearches: argumentSearches on: aNode.
	^value isNil
		ifTrue:
			[aNode acceptVisitor: self.
			aNode]
		ifFalse: [value]
!

visitNode: aNode
	| value |
	value := self performSearches: searches on: aNode.
	^ value isNil
	    ifTrue:[ aNode acceptVisitor: self. aNode ]
	    ifFalse:[ value ]
! !

!ParseTreeSearcher class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

