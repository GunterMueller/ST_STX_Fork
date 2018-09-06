"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBParser
	instanceVariableNames:'scanner currentToken nextToken emptyStatements negatedNumbers
		errorBlock source pragmas proceedAfterError nodesSoFar
		currentMethodNode nodeGenerationCallback currentScope'
	classVariableNames:'ParserType RecentlyParsedMethods CacheRecentlyParsedMethods'
	poolDictionaries:''
	category:'Refactory-Parser'
!


!RBParser class methodsFor:'accessing'!

cacheRecentlyParsedMethods
    ^ CacheRecentlyParsedMethods ? true

    "Created: / 19-02-2015 / 16:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cacheRecentlyParsedMethods: aBoolean
    CacheRecentlyParsedMethods := aBoolean.
    CacheRecentlyParsedMethods ifFalse:[ 
        RecentlyParsedMethods := nil. "/ flush cache
    ].

    "
     self cacheRecentlyParsedMethods:true
     self cacheRecentlyParsedMethods:false
    "
    "Created: / 19-02-2015 / 16:48:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBParser class methodsFor:'class initialization'!

initialize
        "Try to determine which image we're running in"

        " cg: added for ST/X "
        (Smalltalk isSmalltalkX) ifTrue:[
            ParserType := #SmalltalkX.
            (Behavior includesSelector:#parseTreeFor:) ifFalse:[
                Smalltalk fileIn:'extensions.st' inPackage:self package.
            ].
        ] ifFalse:[
            ParserType := (Smalltalk includesKey: #VisualComponent)
                                    ifTrue: [#VisualWorks]
                                    ifFalse: [#IBM].
        ].

        "
         self initialize
        "

    "Modified: / 16.10.2001 / 12:16:43 / bg"
!

parserType
    ^ ParserType
!

parserType:aSymbol
    ParserType := aSymbol
! !

!RBParser class methodsFor:'formatting'!

format: textOrStream in: aClass notifying: aRequestor contentsSymbol: aSymbol
	"Compile a parse tree from the argument, textOrStream. Answer a string containing the original code, formatted nicely.  If aBoolean is true, then decorate the resulting text with color and hypertext actions"

	aSymbol == #altSyntax  "Alan's current explorations for alternate syntax - 2000/2001"
		ifTrue:
			[^ Compiler format: textOrStream in: aClass notifying: aRequestor contentsSymbol: aSymbol ].

	^self format: textOrStream asString in: aClass notifying: aRequestor decorated: (aSymbol == #colorPrint)
!

format: aString in: anIgnoredClass notifying: aRequester decorated: decorated 
        | parser squeakString node errorBlock |
        squeakString := aString asString withBlanksTrimmed.
        squeakString isEmpty ifTrue: [ ^squeakString ].
        Smalltalk isSmalltalkX ifTrue:[
            errorBlock := [:message :position | self error: ('%1 at position %2' bindWith:message with:position) ].
        ] ifFalse:[
            errorBlock := [:message :position | self error: ('{1} at position {2}' format: (Array with:message with:position)) ].
        ].
        parser := self new.
        parser errorBlock: errorBlock.
        parser initializeParserWith: squeakString type: #on:errorBlock:.
        node := parser parseMethod: squeakString.
        ^decorated 
                ifTrue: [node colorizedFormattedCode]
                ifFalse: [node formattedCode]
! !

!RBParser class methodsFor:'parsing'!

flushCachedTree: aTree
    RecentlyParsedMethods isNil ifTrue:[^ self].
    RecentlyParsedMethods removeValue:aTree ifAbsent:[nil].

    "
     RecentlyParsedMethods := nil
    "
!

flushCachedTreeFor: aString 
    RecentlyParsedMethods isNil ifTrue:[^ self].
    RecentlyParsedMethods removeKey:aString ifAbsent:[nil].
!

parseDoItMethodBody: aString onError: aBlock 
        | parser |
        parser := self new.
        parser errorBlock: aBlock.
        parser initializeParserWith: aString type: #on:errorBlock:.
        Compiler parseErrorSignal handle:[:ex |
            ^ aBlock value:(ex errorMessage) value:(ex startPosition)
        ] do:[        
            ^parser parseDoItMethodBody: aString
        ]
!

parseExpression: aString 
	^self parseExpression: aString onError: nil
!

parseExpression: aString onError: aBlock 
        | parser |

        parser := self new.
        parser errorBlock: aBlock.
        Compiler parseErrorSignal handle:[:ex |
            ^ aBlock value:(ex errorMessage) value:(ex startPosition)
        ] do:[
            |node stats|

            parser initializeParserWith: aString type: #on:errorBlock:.
            node := parser parseExpression.
            stats := node statements.
            ^ (stats size == 1 and: [node temporaries isEmpty])
                    ifTrue: [stats first]
                    ifFalse: [node]
        ]

    "Modified: / 17-08-2011 / 10:10:06 / cg"
!

parseExpression: aString onError: aBlock rememberNodes:rememberNodes nodeGenerationCallback:nodeGenerationCallbackOrNil
        "a more general entry which calls a hook on node generation and
         remembers them optionally. Use to get the nodes before erroneous code
         even if a real parse tree cannot be constructed (due to syntax errors).
         Needed for the code-completion and explainers to get 'up-to-the-point' where
         the cursor is, even if there is nothing valid after it"

        ^ self 
            parseExpression: aString 
            setup:[:p | 
                p rememberNodes:rememberNodes.
                p nodeGenerationCallback:nodeGenerationCallbackOrNil
            ]
            onError: aBlock

    "Created: / 06-07-2011 / 12:44:58 / cg"
!

parseExpression: aString setup:setupBlock onError: aBlock 
        "a more general entry which calls a hook on node generation and
         remembers them optionally. Use to get the nodes before erroneous code
         even if a real parse tree cannot be constructed (due to syntax errors).
         Needed for the code-completion and explainers to get 'up-to-the-point' where
         the cursor is, even if there is nothing valid after it"

        | parser |
        parser := self new.
        parser errorBlock: aBlock.
        Compiler parseErrorSignal handle:[:ex |
            ^ aBlock value:(ex errorMessage) value:(ex startPosition) optionalArgument:(parser nodesSoFar)
        ] do:[
            parser initializeParserWith: aString type: #on:errorBlock:.
            setupBlock notNil ifTrue:[setupBlock value:parser].
            ^ parser parseExpression
        ]

    "Created: / 06-07-2011 / 12:45:19 / cg"
!

parseMethod: aString 
	^self parseMethod: aString onError: nil
!

parseMethod: aString onError: aBlock 
    ^ self parseMethod: aString tryCache: CacheRecentlyParsedMethods ? true onError: aBlock

    "Modified: / 19-02-2015 / 16:49:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethod: aString onError: aBlock proceedAfterError:proceedAfterError
        ^ self 
            parseMethod: aString 
            setup:[:p | p proceedAfterError:proceedAfterError]
            onError: aBlock
!

parseMethod: aString onError: aBlock proceedAfterError:proceedAfterError rememberNodes:rememberNodes 
        ^ self 
            parseMethod: aString 
            setup:[:p | p rememberNodes:rememberNodes.
                        p proceedAfterError:proceedAfterError]
            onError: aBlock
!

parseMethod: aString onError: aBlock rememberNodes:rememberNodes
        "a more general entry which calls a hook on node generation and
         remembers them optionally. Use to get the nodes before erroneous code
         even if a real parse tree cannot be constructed (due to syntax errors).
         Needed for the code-completion and explainers to get 'up-to-the-point' where
         the cursor is, even if there is nothing valid after it"

        ^ self 
            parseMethod: aString 
            setup:[:p | p rememberNodes:rememberNodes]
            onError: aBlock

    "Modified (comment): / 06-07-2011 / 12:47:29 / cg"
!

parseMethod: aString onError: aBlock rememberNodes:rememberNodes nodeGenerationCallback:nodeGenerationCallbackOrNil
        "a more general entry which calls a hook on node generation and
         remembers them optionally. Use to get the nodes before erroneous code
         even if a real parse tree cannot be constructed (due to syntax errors).
         Needed for the code-completion and explainers to get 'up-to-the-point' where
         the cursor is, even if there is nothing valid after it"

        ^ self 
            parseMethod: aString 
            setup:[:p | 
                p rememberNodes:rememberNodes.
                p nodeGenerationCallback:nodeGenerationCallbackOrNil
            ]
            onError: aBlock

    "Modified (comment): / 06-07-2011 / 12:47:32 / cg"
!

parseMethod: aString setup:setupBlock onError: aBlock 
        "a more general entry which calls a hook on node generation and
         remembers them optionally. Use to get the nodes before erroneous code
         even if a real parse tree cannot be constructed (due to syntax errors).
         Needed for the code-completion and explainers to get 'up-to-the-point' where
         the cursor is, even if there is nothing valid after it"

        | parser |

        parser := self new.
        parser errorBlock: aBlock.
        Compiler parseErrorSignal 
            handle:[:ex |
                ^ aBlock value:(ex errorMessage) value:(ex startPosition) optionalArgument:(parser nodesSoFar)
            ] do:[
                parser initializeParserWith: aString type: #on:errorBlock:.
                setupBlock notNil ifTrue:[setupBlock value:parser].
                ^ parser parseMethod: aString
            ]

    "Modified: / 08-07-2011 / 19:22:50 / cg"
!

parseMethod: aString tryCache:tryCacheBoolean onError: aBlock 
    | parser tree|

    tryCacheBoolean ifTrue:[
        RecentlyParsedMethods isNil ifTrue:[
            RecentlyParsedMethods := CacheDictionary new:150.
        ].
        tree := RecentlyParsedMethods at:aString ifAbsent:nil.
        tree notNil ifTrue:[
            "/ Transcript showCR:'hit'. 
            ^ tree
        ].
    ].

    "/ Transcript showCR:'miss'.

    parser := self new.
    parser errorBlock: aBlock.
    Error handle:[:ex |
        aBlock isNil ifTrue:[ ^ nil].
        ^ aBlock value:(ex description) value:1
    ] do:[
        parser initializeParserWith: aString type: #on:errorBlock:.
        Compiler parseErrorSignal handle:[:ex |
            aBlock isNil ifTrue:[ ^ nil].
            ^ aBlock value:(ex errorMessage) value:(ex startPosition)
        ] do:[
            tree := parser parseMethod: aString
        ]
    ].
    tryCacheBoolean ifTrue:[
        RecentlyParsedMethods at:aString put:tree.
    ].
    ^ tree.

    "Modified: / 21-08-2006 / 15:37:14 / cg"
!

parseMethodPattern: aString 
        | parser |
        parser := self new.
        parser errorBlock: [:error :position | ^nil].
        parser initializeParserWith: aString type: #searchOn:errorBlock:.
        ^parser parseMessagePattern selector

        "
         BRParser parseMethodPattern:'foo:foo1 bar:bar1 baz:baz1'
        "
!

parseMethodWithNoComments: aString 
	^ self parseMethodWithNoComments: aString onError: nil
!

parseMethodWithNoComments: aString onError: aBlock 
	| parser |
	parser _ self new.
	parser errorBlock: aBlock.
	parser initializeParserWith: aString type: #on:errorBlock:.
	^ parser parseMethodWithNoComments: aString
!

parseRewriteExpression: aString 
        ^self parseRewriteExpression: aString onError:[:msg :pos | self error:msg ].
!

parseRewriteExpression: aString keepComments:keepComments
        ^self parseRewriteExpression: aString keepComments:keepComments onError:[:msg :pos | self error:msg ].
!

parseRewriteExpression: aString keepComments:keepComments onError: aBlock 
        | node parser |
        parser := self new.
        parser errorBlock: aBlock.
        Compiler parseErrorSignal handle:[:ex |
            ^ aBlock value:(ex errorMessage) value:(ex startPosition)
        ] do:[
            parser initializeParserWith: aString type: #rewriteOn:errorBlock:.
            keepComments ifTrue:[
                parser saveComments:true
            ].
            node := parser parseExpression.
            ^(node statements size == 1 and: [node temporaries isEmpty])
                    ifTrue: [node statements first]
                    ifFalse: [node]
        ]
!

parseRewriteExpression: aString onError: aBlock 
        | node parser |
        parser := self new.
        parser errorBlock: aBlock.
        Compiler parseErrorSignal handle:[:ex |
            ^ aBlock value:(ex errorMessage) value:(ex startPosition)
        ] do:[
            parser initializeParserWith: aString type: #rewriteOn:errorBlock:.
            node := parser parseExpression.
            ^(node statements size == 1 and: [node temporaries isEmpty])
                    ifTrue: [node statements first]
                    ifFalse: [node]
        ]
!

parseRewriteMethod: aString 
        ^self parseRewriteMethod: aString onError:[:str :pos | nil]
!

parseRewriteMethod: aString onError: aBlock 
        | parser |
        parser := self new.
        parser errorBlock: aBlock.
        Compiler parseErrorSignal handle:[:ex |
            ^ aBlock value:(ex errorMessage) value:(ex startPosition)
        ] do:[
            parser initializeParserWith: aString type: #rewriteOn:errorBlock:.
            ^parser parseMethod: aString
        ]
!

parseSearchMethod: aString onError: aBlock 
        | parser |
        parser := self new.
        parser errorBlock: aBlock.
        Compiler parseErrorSignal handle:[:ex |
            ^ aBlock value:(ex errorMessage) value:(ex startPosition)
        ] do:[
            parser initializeParserWith: aString type: #searchOn:errorBlock:.
            ^parser parseMethod: aString
        ]
!

parseVariableNames:aString 
        | parser |
        parser := self new.
        parser errorBlock: [:error :position | ^nil].
        parser initializeParserWith: aString type: #searchOn:errorBlock:.
        ^parser parseArgs

        "
         RBParser parseVariableNames:'foo bar ',Character doubleQuote,'comment',Character doubleQuote,' baz'
        "
! !

!RBParser class methodsFor:'testing'!

isIBM
	ParserType isNil ifTrue:[
	    self initialize.
	].
	^ParserType == #IBM
!

isSmalltalkX
    ParserType isNil ifTrue:[
        self initialize.
    ].
    ^ ParserType == #SmalltalkX

    "
     self isSmalltalkX
    "

    "Created: / 18.6.1998 / 17:25:32 / cg"
    "Modified: / 1.8.1998 / 16:17:59 / cg"
!

isSqueak
	ParserType isNil ifTrue:[
	    self initialize.
	].
	^ParserType == #Squeak
!

isVisualWorks
	ParserType isNil ifTrue:[
	    self initialize.
	].
	" ST/X is visualworks alike enough to allow for this ... "
	^ParserType == #SmalltalkX or:[ParserType == #VisualWorks]

    "Modified: / 1.8.1998 / 16:16:16 / cg"
! !

!RBParser methodsFor:'accessing'!

currentMethodNode
    "only valid while within a method-parse (nil otherwise).
     Useful to see what has been parsed so far,
     in case of an error 
     (codecompletion uses this to look for
      args and locals, even if the source is not syntactically correct)"

    ^ currentMethodNode
!

currentScope
    "only valid while within a method-parse (nil otherwise).
     Useful to see what has been parsed so far, in case of an error 
     (codecompletion uses this to look for variables in scope, 
     even if the source is not syntactically correct)"

    ^ currentScope
!

errorBlock: aBlock 
	errorBlock := aBlock.
	scanner notNil ifTrue: [scanner errorBlock: aBlock]
!

initializeParserWith: aString type: aSymbol 
        |stream|

"/        Smalltalk dialectName = 'SmalltalkX' ifTrue:[
"/            stream := LineNumberReadStream on: aString
"/        ] ifFalse:[
            stream := ReadStream on: aString.
"/        ].

        source := aString.
        self scanner: (RBScanner 
                                perform: aSymbol
                                with: stream
                                with: self errorBlock)
!

nodesSoFar
    "In case of an error, this allows for the nodes which have been collected
     so far to be fetched. Useful for code completion of incomplete (erroneous) code."

    ^ nodesSoFar

    "Created: / 06-07-2011 / 17:52:58 / cg"
!

parseDoItMethodBody: aString 
        | node |
        node := self parseDoItMethodBody.
        self atEnd ifFalse: [self parserError: 'Unknown input at end'].
        node source: aString.
        ^node
!

parseExpression
	| node |
	node := self parseStatements: false.
	self atEnd ifFalse: [self parserError: 'Unknown input at end'].
	^node
!

parseMethod: aString 
        | node |

        node := self parseMethod.
        self atEnd ifFalse: [self parserError: 'Unknown input at end'].
        node source: aString.
        ^node
!

parseMethodWithNoComments: aString 
	| node |
	node _ self parseMethodWithNoComments.
	self atEnd ifFalse: [self parserError: 'Unknown input at end'].
	node source: aString.
	^ node
!

proceedAfterError:aBoolean 
    proceedAfterError := aBoolean
!

rememberedTokens
    ^ scanner rememberedTokens
! !

!RBParser methodsFor:'error handling'!

errorBlock
	^errorBlock isNil
		ifTrue: [[:message :position | ]]
		ifFalse: [errorBlock]
!

errorPosition
	^currentToken start
!

parserError: aString 
        "Evaluate the errorBlock. If it returns raise an error"

        |errorBlock errorPosition|

        errorPosition := self errorPosition.
        errorBlock := self errorBlock.
        errorBlock notNil ifTrue:[
            errorBlock 
                valueWithOptionalArgument:aString
                and:errorPosition 
                and:nodesSoFar 
                and:self.
            proceedAfterError == true ifTrue:[^ self].
        ].

        Compiler parseErrorSignal new
            errorMessage:aString startPosition:errorPosition;
            raiseRequest

"/        self error: aString

    "Modified: / 07-09-2006 / 12:01:35 / cg"
!

parserError:msg lastNode:aNode
    self rememberLastNode:aNode.
    ^ self parserError:msg
!

rememberLastNode:aNode
    nodesSoFar notNil ifTrue:[
        (nodesSoFar includes:aNode) ifTrue:[^ self].
        nodesSoFar add:aNode.
    ].
    nodeGenerationCallback notNil ifTrue:[
        nodeGenerationCallback value:aNode.
    ].
!

scannerError: aString 
        "Evaluate the block. If it returns raise an error"

        self parserError:aString

    "Created: / 07-09-2006 / 12:01:18 / cg"
! !

!RBParser methodsFor:'initialization & release'!

initializeForIBM
        emptyStatements := true.
        negatedNumbers := false.
        scanner notNil ifTrue: [scanner initializeForIBM]
!

initializeForSmalltalkX
        emptyStatements := false.
        negatedNumbers := true.
        scanner notNil ifTrue: [scanner initializeForSmalltalkX]

    "Created: / 1.8.1998 / 16:13:48 / cg"
!

initializeForSqueak
        emptyStatements := true.
        negatedNumbers := true.
        scanner notNil ifTrue: [scanner initializeForSqueak]
!

initializeForVisualWorks
        emptyStatements := false.
        negatedNumbers := false.
        scanner notNil ifTrue: [scanner initializeForVisualWorks]
!

nodeGenerationCallback:nodeGenerationCallbackOrNil
    nodeGenerationCallback := nodeGenerationCallbackOrNil.
!

rememberNodes
    <resource: #obsolete>
    self obsoleteMethodWarning.
    self rememberNodes:true
!

rememberNodes:aBoolean
    aBoolean ifTrue:[
        nodesSoFar := IdentitySet new.
    ].
!

rememberTokens:aBoolean
    scanner rememberTokens:aBoolean
!

saveComments:aBoolean
    scanner saveComments: aBoolean
!

scanner: aScanner 
        scanner := aScanner.
        pragmas := nil.
        self class isIBM 
                ifTrue: [self initializeForIBM]
                ifFalse: [
                    self class isSqueak 
                            ifTrue: [self initializeForSqueak]
                            ifFalse: [
                        self class isSmalltalkX
                            ifTrue:[self initializeForSmalltalkX]
                            ifFalse:[self initializeForVisualWorks]]].
        self step

    "Modified: / 01-08-1998 / 16:14:38 / cg"
    "Modified: / 21-09-2015 / 12:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBParser methodsFor:'private'!

addComments:comments afterNode: aNode
    comments notEmptyOrNil ifTrue:[
        aNode commentsAfter: comments
    ]
!

addComments:comments beforeNode: aNode
    comments notNil ifTrue:[
        aNode commentsBefore: comments
    ]
!

addPragma: aPragma
    pragmas isNil ifTrue:[ pragmas := OrderedCollection new ].
    pragmas addLast: aPragma

    "Created: / 21-09-2015 / 06:29:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextToken
        nextToken isNil
                ifTrue: [nextToken := scanner next. ].

        ^ nextToken
!

patchLiteralMessage
        |currentTokenValue|

        (currentTokenValue := currentToken value) == true 
                ifTrue: 
                        [^currentToken := RBIdentifierToken value: 'true' start: currentToken start lineNumber:currentToken lineNumber].
        currentTokenValue == false 
                ifTrue: 
                        [^currentToken := RBIdentifierToken value: 'false' start: currentToken start lineNumber:currentToken lineNumber].
        currentTokenValue == nil 
                ifTrue: 
                        [^currentToken := RBIdentifierToken value: 'nil' start: currentToken start lineNumber:currentToken lineNumber]
!

patchNegativeLiteral
        "Handle the special negative number case for binary message sends."

        |currentTokenValue|

        (currentTokenValue := currentToken value) isNumber ifFalse: [^self].
        currentTokenValue <= 0 ifFalse: [^self].
        currentTokenValue = 0 
                ifTrue: 
                        [(source notNil and: 
                                        [source isEmpty not 
                                                and: [(source at: (currentToken start min: source size)) == $-]]) 
                                ifFalse: [^self]].
        nextToken := currentToken.
        currentToken := RBBinarySelectorToken value: #- start: nextToken start.
        nextToken value: nextToken value negated.
        nextToken start: nextToken start + 1
!

step
        nextToken notNil ifTrue: 
                        [currentToken := nextToken.
                        nextToken := nil.
                        ^currentToken].
        currentToken := scanner next.
! !

!RBParser methodsFor:'private-parsing'!

parseArgOrLocal
    "Parse either method/block argument or a local (inside | | )"

    ^ self parseVariableNode

    "Modified (comment): / 20-08-2015 / 16:22:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseArgs
    | args  node |

    args := OrderedCollection new.
    [
        currentToken isIdentifier
    ] whileTrue:[
        args add:(node := self parseArgOrLocal).
         
"/            currentToken isIdentifier ifTrue:[
"/                self addComments:(scanner getCommentsAfterToken) afterNode:node
"/            ]
    ].
    ^ args
!

parseArray
        "parse Squeak's {} construct"
        | leftBrace node rightBrace |

        leftBrace := currentToken start.
        self step.

        node := RBArrayNode new.
        node lineNumber:currentToken lineNumber.
        self parseStatementList: false  into: node.

        (currentToken isSpecial and: [currentToken value == $}]) ifFalse: [
                self parserError: 'expected }' 
        ].

        rightBrace := currentToken start.
        self step.

        node leftBrace: leftBrace.
        node rightBrace: rightBrace.
        ^node
!

parseAssignment
        "Need one token lookahead to see if we have a ':='. This method could 
        make it possible to assign the literals true, false and nil."

        | commentsBefore commentsAfterVar commentsAfterAss commentsAfter node aNode position assignmentToken|

        commentsBefore := scanner getCommentsBeforeToken.
        currentToken isIdentifier 
            ifFalse: [
                node := self parseCascadeMessage.
            ]
            ifTrue:[
                commentsAfterVar := scanner getCommentsAfterTokenIfInLine:currentToken lineNumber.
                (self nextToken isAssignment) 
                    ifFalse: [
"/                scanner addToCommentsBeforeToken:commentsAfterVar.
                        node := self parseCascadeMessage.
                        self addComments:commentsAfterVar afterNode:node leftMostReceiver.
                    ]
                    ifTrue:[
                        commentsAfterAss := scanner getCommentsAfterToken.
                        node := self parseVariableNode.
                        self addComments:commentsAfterVar afterNode:node.
                        "/ currentToken value
                        assignmentToken := currentToken.
                        position := assignmentToken start.
                        self step.

                        aNode := self parseAssignment.
                        self addComments:commentsAfterAss beforeNode:aNode.
                        node := RBAssignmentNode 
                                variable: node
                                value: aNode
                                position: position.
                        node assignmentToken:assignmentToken
                    ]
            ].
        node notNil ifTrue:[
            self addComments:commentsBefore beforeNode:node.
            commentsAfter := scanner getCommentsAfterTokenIfInLine:(node lastLineNumber).
            self addComments:commentsAfter afterNode:node.
        ].
        ^ node
!

parseBinaryMessage
        | node commentsAfterSelector comments|

        node := self parseUnaryMessage.
        
        [currentToken isLiteral ifTrue: [self patchNegativeLiteral].
        currentToken isBinary] 
            whileTrue: [
                commentsAfterSelector := scanner getCommentsAfterToken.
                node := self parseBinaryMessageWith: node.
                self rememberLastNode:node.
                self addComments:commentsAfterSelector beforeNode:(node arguments first) leftMostReceiver.
            ].
        node notNil ifTrue:[
            comments := scanner getCommentsAfterTokenIfInLine:(node lastLineNumber).
            comments notEmptyOrNil ifTrue:[self breakPoint:#cg].
            self addComments:comments afterNode:node.
        ].
        ^node
!

parseBinaryMessageWith: leftNode 
        | binaryToken binaryNode|
        
        binaryToken := currentToken.
        self step.
        
        "/ create first, so we have the node in case of an error.
        binaryNode := RBMessageNode
                        receiver: leftNode
                        selectorParts: (Array with: binaryToken)
                        arguments: {}.
        self rememberLastNode:binaryNode.
        binaryNode arguments: (Array with: self parseUnaryMessage).
        ^binaryNode
!

parseBinaryPattern
        | binaryToken |
        currentToken isBinary 
                ifFalse: [self parserError: 'Message pattern expected'].
        binaryToken := currentToken.
        self step.
        ^RBMethodNode selectorParts: (Array with: binaryToken)
                arguments: (Array with: self parseArgOrLocal)

    "Modified: / 21-08-2015 / 22:55:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseBinaryPragma
    | binaryToken |
    currentToken isBinary ifFalse: [ ^ self parserError: 'Message pattern expected' ].
    binaryToken := currentToken.
    self step.
    ^ RBPragmaNode
            selectorParts: (Array with: binaryToken)
            arguments: (Array with: self parsePragmaLiteral)

    "Created: / 21-09-2015 / 09:55:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseBlock
        | position blockNode firstLine prevScope|

        position := currentToken start.
        firstLine := currentToken lineNumber.
        self step.
        blockNode := self parseBlockArgsInto: RBBlockNode new.
"/        node arguments do:[:eachArg | eachArg parent:self].
        blockNode left: position.
        blockNode firstLineNumber:firstLine.
        prevScope := currentScope.
        currentScope := blockNode.
        self rememberLastNode:blockNode.
        blockNode body: (self parseStatements: false).
        RBParser isSmalltalkX ifTrue:[
            self addComments:(scanner getCommentsBeforeToken) afterNode:blockNode body.
        ].
        "/ ensure that right is set, even if parse aborted due to an error
        blockNode right: currentToken start-1.

        (currentToken isSpecial and: [currentToken value == $]]) 
                ifFalse: [self parserError: ''']'' expected'].
        "/ fix right
        blockNode right: currentToken start.
        blockNode lastLineNumber:currentToken lineNumber.

        self step.
        self addComments:(scanner getCommentsBeforeToken) afterNode:blockNode.
        currentScope := prevScope.
        ^ blockNode
!

parseBlockArgsInto: blockNode 
        | verticalBar args colons arg|
        args := OrderedCollection newLikelyToRemainEmpty.
        colons := OrderedCollection newLikelyToRemainEmpty.
        blockNode arguments: args; colons: colons. "/ set early, in case of an error (so arguments are already present in block)

        verticalBar := false.
        [currentToken isSpecial and: [currentToken value == $:]] whileTrue: [
            colons add: currentToken start.
            self step.      ":"
            verticalBar := true.
            args add: (arg := self parseArgOrLocal).
            arg parent:blockNode.
        ].
        verticalBar 
                ifTrue: 
                        [currentToken isBinary 
                                ifTrue: 
                                        [blockNode bar: currentToken start.
                                        currentToken value == #| 
                                                ifTrue: [self step]
                                                ifFalse: 
                                                        [currentToken value == #'||' 
                                                                ifTrue: 
                                                                        ["Hack the current token to be the start 
                                                                        of temps bar"

                                                                        currentToken
                                                                                value: #|;
                                                                                start: currentToken start + 1]
                                                                ifFalse: [self parserError: '''|'' expected']]]
                                ifFalse: 
                                        [(currentToken isSpecial and: [currentToken value == $]]) 
                                                ifFalse: [self parserError: '''|'' expected']]].
        blockNode
            arguments: args;
            colons: colons.
        ^blockNode

    "Modified (format): / 20-08-2015 / 16:23:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-05-2016 / 16:32:52 / cg"
!

parseCascadeMessage
        | node receiver messages semicolons m|
        node := self parseKeywordMessage.
        (currentToken isSpecial 
                and: [currentToken value == $; and: [node isMessage]]) ifFalse: [^node].
        receiver := node receiver.
        messages := OrderedCollection new: 2.
        semicolons := OrderedCollection new: 2.
        messages add: node.
        [currentToken isSpecial and: [currentToken value == $;]] whileTrue: 
                        [semicolons add: currentToken start.
                        self step.
                        currentToken isIdentifier 
                                                ifTrue: [m := self parseUnaryMessageWith: receiver]
                                                ifFalse: 
                                                        [currentToken isKeyword 
                                                                ifTrue: [m := self parseKeywordMessageWith: receiver]
                                                                ifFalse: 
                                                                        [| temp |
                                                                        currentToken isLiteral ifTrue: [self patchNegativeLiteral].
                                                                        currentToken isBinary ifFalse: [self parserError: 'Message expected'].
                                                                        temp := self parseBinaryMessageWith: receiver.
                                                                        temp == receiver ifTrue: [self parserError: 'Message expected'].
                                                                        m := temp]].
                        messages add:m
                        ].
        ^RBCascadeNode messages: messages semicolons: semicolons
!

parseDoItMethodBody
        | methodNode |
        methodNode := RBMethodNode new selector: #doIt; arguments: #().
        self parsePragmas.
        self addComments:(scanner getComments) beforeNode:methodNode.
        methodNode body: (self parseStatements: true).
        pragmas notNil ifTrue:[ methodNode pragmas: pragmas ].
        ^methodNode

    "Modified: / 21-09-2015 / 12:00:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseKeywordMessage
    |node comments|

    node := self parseKeywordMessageWith: self parseBinaryMessage.
    node notNil ifTrue:[
        comments := scanner getCommentsAfterTokenIfInLine:(node lastLineNumber).
        "/ comments notEmptyOrNil ifTrue:[self halt].
        self addComments:comments afterNode:node.
    ].
    ^ node.
!

parseKeywordMessageWith: node 
        | args isKeyword keywords kwNode commentsBeforeSelectorPart arg commentsAfterSelectorPart|

        args := OrderedCollection new: 3.
        keywords := OrderedCollection new: 3.
        isKeyword := false.

        self rememberLastNode:node.

        [currentToken isKeyword] 
            whileTrue:[
                commentsBeforeSelectorPart := scanner getCommentsBeforeToken.
                self addComments:commentsBeforeSelectorPart afterNode:node.

                keywords add: currentToken.
                kwNode isNil ifTrue:[
                    kwNode := RBMessageNode 
                       receiver: node
                       selectorParts: keywords
                       arguments: args.
                    self rememberLastNode:kwNode.
                ].
                self step.
                commentsAfterSelectorPart := scanner getCommentsBeforeToken.

                self atEnd ifTrue:[ self parserError:'argument expected' ].
                arg := self parseBinaryMessage.
                self addComments:commentsAfterSelectorPart beforeNode:arg.
                args add: arg.
                args last parent:kwNode.
                isKeyword := true
            ].
        ^isKeyword 
                ifTrue: [kwNode]
                ifFalse: [node]
!

parseKeywordPattern
        | keywords args|
        keywords := OrderedCollection new: 2.
        args := OrderedCollection new: 2.
        [currentToken isKeyword] whileTrue:[ 
                        keywords add: currentToken.
                        self step.
                        "/ CG: lifted /duplicated the error check to allow for the keyword-node to
                        "/ be created for what we have so-far (for code-completion of a keyword selector)
                        currentToken isIdentifier ifFalse: [
                            self rememberLastNode:((RBMethodNode selectorParts: keywords arguments: args) source:source).
                            "/ error will be reported in #parseVariableNode
                            "/ (but codeCompletion needs the node to work on the stuff we already have...)
                        ].
                        args add: self parseArgOrLocal.
        ].
        ^RBMethodNode selectorParts: keywords arguments: args

    "Modified: / 20-08-2015 / 16:21:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseKeywordPragma
    | selectorParts arguments |

    selectorParts := OrderedCollection new: 2.
    arguments := OrderedCollection new: 2.
    [ currentToken isKeyword ] whileTrue: [
        "/ Hack to support St/X FFI callout specs, for instance:
        "/ 
        "/     <cdecl: LLVMValue "LLVMAddAlias" ( LLVMModule LLVMType LLVMValue charPointer ) >
        "/ 
        "/ Parse the spec as one single string up to closing >
        selectorParts add: currentToken.
        (#('c:' 'api:' 'ole:' 'apicall:' 'cdecl:' 'stdcall:') includes: currentToken value) ifTrue:[ 
            | line start stop spec |

            "/ scanner stream peek
            start := scanner stream position.
            line := scanner tokenLineNumber.
            spec := String streamContents:[ :buf |
                | input |

                input := scanner stream.
                buf nextPut: scanner currentCharacter.
                [ input atEnd not and:[input peek ~~ $> ] ] whileTrue:[ 
                    buf nextPut: input next.
                ].
                stop := input position.
                input peek == $> ifTrue:[ 
                    input next.
                    currentToken := RBBinarySelectorToken value: #> start: stop - 1.
                    input skipSeparators.
                    scanner step.
                ].
            ].

            arguments add: (RBLiteralNode literalToken: (RBLiteralToken value: spec start: start stop: stop lineNumber: line)).
            ^ RBPragmaNode
                selectorParts: selectorParts
                arguments: arguments.
        ] ifFalse:[
            self step.
            arguments addLast: self parsePragmaLiteral.
            "/ Hack to support St/X resource tags with array values, for instance
            "/ 
            "/    <resource: #foo (#one #two)>
            "/
            (currentToken isSpecial 
                and:[ currentToken value = $(
                and:[ selectorParts size == 1 
                and:[ selectorParts first value = 'resource:' ] ] ]) ifTrue:[
                    | values |
                    self step.
                    values := OrderedCollection new.
                    [ currentToken isLiteral ] whileTrue:[ 
                        currentToken value isSymbol ifFalse:[
                            self parserError: 'Values in Smalltalk/X resource tags may be only symbols!!'    
                        ].
                        values add: currentToken.
                        self step.
                    ].
                    (currentToken isSpecial and:[ currentToken value = $) ]) ifTrue:[ 
                        self step.
                    ] ifFalse:[ 
                        self parserError: 'Expected a symbol or closing )'
                    ].
                    "/ Make a literal array token...
                    values := RBLiteralToken 
                                value: values asArray
                                start: values first start
                                stop:  values last stop
                                lineNumber: values first lineNumber.
                    "/ Make a literal array node...  
                    values := RBLiteralNode literalToken: values.

                    "/ Add it to the pragma...
                    selectorParts add: (RBKeywordToken value: #values: start: -1).
                    arguments add: values.
            ]
        ].
    ].
    ^ RBPragmaNode
        selectorParts: selectorParts
        arguments: arguments.

    "Created: / 21-09-2015 / 09:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-09-2015 / 10:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMessagePattern
	^currentToken isIdentifier
		ifTrue: [self parseUnaryPattern]
		ifFalse: 
			[currentToken isKeyword
				ifTrue: [self parseKeywordPattern]
				ifFalse: [self parseBinaryPattern]]
!

parseMethod
    |commentsBefore methodNode bodyNode args commentsAfterArgs prevScope|

    commentsBefore := scanner getCommentsBeforeToken.
    currentMethodNode := methodNode := self parseMessagePattern.
    prevScope := currentScope.
    currentScope := methodNode.

    "comments after last argument are treated like a body comment" 
    args := methodNode arguments.
    args size > 0 ifTrue:[ 
        commentsAfterArgs := args last commentsAfter.
        args last removeCommentsAfter.
        scanner addToCommentsBeforeToken:commentsAfterArgs
    ].
    self addComments:commentsBefore beforeNode:methodNode.
    self parsePragmas.
    commentsBefore := scanner getCommentsBeforeToken.
    self rememberLastNode:methodNode.
    bodyNode := self parseStatements:true.
    self addComments:commentsBefore beforeNode:bodyNode.
    self addComments:(scanner getComments) afterNode:methodNode.
    methodNode body:bodyNode.
    pragmas notNil ifTrue: [ methodNode pragmas: pragmas ].
    currentMethodNode := nil.
    currentScope := prevScope.

    ^ methodNode

    "Modified: / 21-09-2015 / 12:00:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethodWithNoComments
    | methodNode |
    methodNode := self parseMessagePattern.
    self parsePragmas.
    "self addCommentsTo: methodNode."
    methodNode body: (self parseStatements: true).
    pragmas notNil ifTrue: [ methodNode pragmas: pragmas ].
    ^ methodNode

    "Modified: / 21-09-2015 / 12:01:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseNegatedNumber
        | token lineNo|

        (self nextToken isLiteral not or: [ self nextToken realValue isNumber not ])
                ifTrue: [ self parserError: 'only numbers may be negated' ].

        lineNo := scanner tokenLineNumber.        
        "create a new token out of the $- and the number"
        token := RBLiteralToken value: (self nextToken realValue negated) start: currentToken start stop: nextToken stop.
        token lineNumber:lineNo.
        self step.
        self step.


        ^RBLiteralNode literalToken: token
!

parseOptimizedExpression
	| position node |
	position := currentToken start.
	self step.
	node := RBOptimizedNode 
				left: position
				body: (self parseStatements: false)
				right: currentToken start.
	(currentToken isSpecial and: [currentToken value == $)]) 
		ifFalse: [self parserError: ''')'' expected'].
	self step.
	^node
!

parseParenthesizedExpression
        | commentsBefore leftParen node|

        leftParen := currentToken start.
        commentsBefore := scanner getCommentsBeforeToken.
        self step.
        node := self parseAssignment.
        (currentToken isSpecial and: [currentToken value == $)])
            ifFalse:[
                ^ self parserError: ''')'' expected' lastNode:node
            ].

        node addParenthesis: (leftParen to: currentToken start).
        self addComments:commentsBefore beforeNode:node.
        self addComments:scanner getCommentsAfterToken afterNode:node.
        self step.
        ^ node.
!

parsePatternBlock
        | position node |
        position := currentToken start.
        self step.
        node := self parseBlockArgsInto: RBPatternBlockNode new.
        node left: position.
        node body: (self parseStatements: false).
        "/ ensure that right is set, even if parse aborted due to an error
        node right: currentToken start-1.
        (currentToken isSpecial and: [currentToken value == $}]) 
                ifFalse: [self parserError: '''}'' expected'].
        node right: currentToken start.
        self step.
        ^node
!

parsePragma
    | start pragma |
    start := currentToken start.
    self step.
    currentToken isIdentifier ifTrue: [ 
        pragma := self parseUnaryPragma 
    ] ifFalse: [
        currentToken isKeyword ifTrue: [ 
            pragma := self parseKeywordPragma 
        ] ifFalse: [ 
            pragma := self parseBinaryPragma 
        ] 
    ].
    (currentToken isBinary and: [ currentToken value == #> ]) 
            ifFalse: [ ^ self parserError: '''>'' expected' ].
    pragma left: start; right: currentToken start.
    self addPragma: pragma.

    "Created: / 21-09-2015 / 06:23:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePragmaLiteral
    currentToken isIdentifier ifTrue:[ 
        "To support <foo: a> and parse `a` as Symbol, simply 
         nake currentToken a literal token..."
        currentToken := RBLiteralToken value: currentToken value start: currentToken start stop: currentToken stop.
    ].
    currentToken isLiteral ifFalse:[
        ^ self parserError: 'Literal expected'.
    ].
    ^ self parsePrimitiveLiteral.

    "Created: / 21-09-2015 / 09:57:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-09-2015 / 11:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePragmas
        [ currentToken isBinary and: [ currentToken value = #< ] ] whileTrue: [
                self parsePragma.
                self step ]

    "Created: / 21-09-2015 / 11:10:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePrimitiveIdentifier
        |node commentsAfter|

        node := RBVariableNode identifierToken:currentToken.
        node lineNumber:currentToken lineNumber.
        self addComments:(scanner getCommentsBeforeToken) beforeNode:node.

        self rememberLastNode:node.

        nextToken notNil ifTrue:[
            "scanner has already advanced - comments do not belong to node"
        ] ifFalse:[
            commentsAfter := scanner getCommentsAfterTokenIfInLine:(node lastLineNumber).
            self addComments:commentsAfter afterNode:node.
        ].
        self step.
        ^node
!

parsePrimitiveLiteral
        | token node |
        token := currentToken.
        node := RBLiteralNode literalToken: token.
        node lineNumber:(currentToken lineNumber ? scanner tokenLineNumber).
        self step.
        ^ node.
!

parsePrimitiveObject
        ^ self parsePrimitiveObjectIfFail:[ self parserError: 'Expression expected'.]
!

parsePrimitiveObjectIfFail:failBlock
        |tokenValue|
        
        currentToken isIdentifier ifTrue: [^self parsePrimitiveIdentifier].
        currentToken isLiteral ifTrue: [^self parsePrimitiveLiteral].
        currentToken isSpecial ifTrue:[
            tokenValue := currentToken value.
            tokenValue == $[ ifTrue: [^self parseBlock].
            tokenValue == $( ifTrue: [^self parseParenthesizedExpression].
            tokenValue == ${ ifTrue: [^self parseArray]
        ].
        currentToken isOptimized ifTrue: [^self parseOptimizedExpression].
        (negatedNumbers  
            and: [ currentToken isBinary 
            and: [ currentToken value == #- ] ]
        ) ifTrue:[ 
            ^self parseNegatedNumber 
        ].
        currentToken isPatternBlock ifTrue: [^self parsePatternBlock].
        RBParser isSmalltalkX ifTrue:[
            " primitive c-code expressions "
            currentToken isSTXPrimitiveCode ifTrue:[^ self parseSTXPrimitiveCCodeExpression].
        ].
        "/ self halt.
        failBlock value.
        ^ nil
!

parseSTXPrimitiveCCodeExpression
	| cExpr |
	cExpr := currentToken.
	self step.
	^RBSTXPrimitiveValueCCodeNode new codeToken:cExpr
!

parseStatementList: allowPragmas into: sequenceNode 
        | statements return periods returnPosition returnLineNumber node valueNode 
          commentsBeforeToken commentsBeforeStatement|
        
        return := false.
        statements := OrderedCollection new.
        periods := OrderedCollection new.
        self addComments:(scanner getCommentsBeforeToken) beforeNode:sequenceNode.
        allowPragmas ifTrue: [self parsePragmas].
        
        [
         "skip empty statements"
         emptyStatements ifTrue: 
                 [[currentToken isSpecial and: [currentToken value == $.]] whileTrue: 
                                 [periods add: currentToken start.
                                 self step]].

         self atEnd or: 
                        [currentToken isSpecial
                                and: ['])}' includes: currentToken value  ]
                                " and: [currentToken value == $] or: [currentToken value == $)]] "
                        ]
        ] whileFalse:[
            commentsBeforeToken := scanner getCommentsBeforeToken.
            commentsBeforeToken notNil ifTrue:[
                node isNil ifTrue:[
                    commentsBeforeStatement := commentsBeforeToken
                ] ifFalse:[    
                    self addComments:commentsBeforeToken beforeNode:node "value".
                ].
            ].
            return ifTrue: [
                self class isSmalltalkX 
                    ifTrue:
                        ["could output a warning"]
                    ifFalse:
                        [self 
                            parserError: 'End of statement list encounted (statements after return)'
                            lastNode:node]].

            (currentToken isSTXPrimitiveCode) 
                ifTrue:[
                    " primPosition := currentToken start. "
                    node := RBSTXPrimitiveCCodeNode new codeToken: currentToken.
                    self addComments:(scanner getCommentsBeforeToken) afterNode:node.
                    statements add: node.
                    self step.
                ] ifFalse:[
                    (currentToken isSpecial and: [currentToken value == $^])
                        ifTrue: 
                                [
                                returnPosition := currentToken start.
                                returnLineNumber := currentToken lineNumber.
                                self step.

                                valueNode := self parseAssignment.
                                node := RBReturnNode return: returnPosition value: valueNode.
                                node lineNumber:returnLineNumber.
                                scanner atEnd ifFalse:[
                                    self addComments:(scanner getCommentsBeforeToken) afterNode:node value.
                                ].

                                statements add: node.
                                return := true]
                        ifFalse: 
                                [
                                node := self parseAssignment.
                                node notNil ifTrue:[
                                    self addComments:(scanner getCommentsAfterTokenIfInLine:node lastLineNumber) afterNode:node.
                                    scanner atEnd ifFalse:[
                                        self addComments:(scanner getCommentsAfterToken) afterNode:node.
                                        self addComments:(scanner getCommentsBeforeToken) afterNode:node.
                                    ].

                                    statements add: node
                                ]].
                ].

            (currentToken isSpecial and: [currentToken value == $.])
                ifTrue: 
                    [periods add: currentToken start.
                    self step]
                ifFalse: 
                    [return := true].
            emptyStatements 
                ifTrue: 
                    [[currentToken isSpecial and: [currentToken value == $.]] whileTrue: 
                                    [periods add: currentToken start.
                                    self step]]].

        commentsBeforeStatement notNil ifTrue:[                            
            self addComments:commentsBeforeStatement beforeNode:(statements first).
        ].    
        sequenceNode 
            statements: statements;
            periods: periods.

        self addComments:(scanner getCommentsBeforeToken) afterNode:node "value".
        ^sequenceNode

    "Modified: / 17-05-2012 / 12:47:49 / cg"
    "Modified: / 21-09-2015 / 11:59:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseStatements: allowPragmas 
        | lineNr locals leftBar rightBar seqNode commentsBeforeStatements prevScope|

        locals := #().
        leftBar := rightBar := nil.
        lineNr := scanner tokenLineNumber.
        currentToken isBinary 
                ifTrue: 
                        [currentToken value == #| 
                                ifTrue: 
                                        [leftBar := currentToken start.
                                        self step.
                                        locals := self parseArgs.
                                        (currentToken isBinary and: [currentToken value = #|]) 
                                                ifFalse: [self parserError: '''|'' expected'].
                                        commentsBeforeStatements := scanner getCommentsBeforeToken.
"/                                        locals size > 0 ifTrue:[  self halt.
"/                                            self addComments:commentsBeforeStatements afterNode:locals last.
"/                                        ] ifFalse:[
"/                                            "mhmh - let comments flow to first statement"
"/                                        ].
                                        rightBar := currentToken start.
                                        self step]
                                ifFalse: 
                                        [currentToken value == #'||' 
                                                ifTrue: 
                                                        [rightBar := (leftBar := currentToken start) + 1.
                                                        self step]]].

        seqNode := RBSequenceNode 
                                leftBar: leftBar
                                temporaries: locals
                                rightBar: rightBar.
        seqNode lineNumber:lineNr.
        self rememberLastNode:seqNode.

        "/ Support for parsing pragmas AFTER local declarations - this
        "/ is supported by Smalltalk/X.
        "/ Note, that tagBoolean is true if parsing statements for method body, false
        "/ otherwise.
        allowPragmas ifTrue:[ 
            self parsePragmas
        ].

        prevScope := currentScope.
        currentScope := seqNode.
        seqNode commentsAfterRightBar:((commentsBeforeStatements ? #()) , (scanner getCommentsBeforeToken ? #())).
        currentMethodNode notNil ifTrue:[
            currentMethodNode body:seqNode.
        ].
        self parseStatementList: allowPragmas into: seqNode.
        currentScope := prevScope.
        ^ seqNode

    "Modified: / 06-03-2012 / 11:23:07 / cg"
    "Modified: / 06-05-2015 / 00:29:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseUnaryMessage
        | node commentsAfterSelector comments|

        node := self parsePrimitiveObjectIfFail:[ 
                        self parserError:'primitive expression expected (got: ',currentToken asString,')'
                ].
        self rememberLastNode:node.

        [currentToken isLiteral ifTrue: [self patchLiteralMessage].
        currentToken isIdentifier] 
            whileTrue: [ 
                commentsAfterSelector := scanner getCommentsAfterTokenIfInLine:(currentToken lineNumber).
                node := self parseUnaryMessageWith: node.
                self addComments:commentsAfterSelector afterNode:node.
                self rememberLastNode:node.
            ].
        node notNil ifTrue:[
            comments := scanner getCommentsAfterTokenIfInLine:(node lastLineNumber).
            self addComments:comments afterNode:node.
        ].
        ^node
!

parseUnaryMessageWith: aNode 
        | selector |
        selector := currentToken.
        self step.
        ^RBMessageNode 
                receiver: aNode
                selectorParts: (Array with: selector)
                arguments: #()
!

parseUnaryPattern
	| selector |
	selector := currentToken.
	self step.
	^RBMethodNode selectorParts: (Array with: selector) arguments: #()
!

parseUnaryPragma
    | pragma |

    pragma := RBPragmaNode selectorParts: (Array with: currentToken) arguments: #().
    self step.
    ^ pragma

    "Created: / 21-09-2015 / 09:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-09-2015 / 11:24:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseVariableNode
	currentToken isIdentifier 
		ifFalse: [self parserError: 'Variable name expected'].
	^self parsePrimitiveIdentifier
! !

!RBParser methodsFor:'testing'!

atEnd
        ^currentToken isEOF "/ class == RBToken

    "Modified: / 06-03-2012 / 11:20:11 / cg"
! !

!RBParser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


RBParser initialize!
