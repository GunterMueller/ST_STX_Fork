"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

MethodRefactoring subclass:#ExtractMethodRefactoring
	instanceVariableNames:'selector extractionInterval extractedParseTree modifiedParseTree
		parameters needsReturn'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ExtractMethodRefactoring class methodsFor:'instance creation'!

extract: anInterval from: aSelector in: aClass 
	^self new
		extract: anInterval
		from: aSelector
		in: aClass
!

model: aRBSmalltalk extract: anInterval from: aSelector in: aClass 
	^(self new)
		model: aRBSmalltalk;
		extract: anInterval
			from: aSelector
			in: aClass;
		yourself
! !

!ExtractMethodRefactoring methodsFor:'accessing'!

selectorOfExtractedMethod
    ^ extractedParseTree selector
!

selectorOfOriginalMethod
    ^ selector
! !

!ExtractMethodRefactoring methodsFor:'initialize-release'!

extract: anInterval from: aSelector in: aClass 
	class := self classObjectFor: aClass.
	selector := aSelector.
	extractionInterval := anInterval
! !

!ExtractMethodRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition definesSelector: selector in: class) 
                & (RBCondition withBlock: 
                                        [self extractMethod.
                                        self checkSpecialExtractions.
                                        self checkReturn.
                                        needsReturn ifTrue: [extractedParseTree addReturn].
                                        self checkTemporaries.
                                        true])
! !

!ExtractMethodRefactoring methodsFor:'printing'!

changeString
    ^ 'Extract %1 from %2' 
        bindWith:self selectorOfExtractedMethod 
        with:self selectorOfOriginalMethod.
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' extract: '.
	extractionInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!ExtractMethodRefactoring methodsFor:'transforming'!

checkAssignments: variableNames 
        | node outsideVars removeAssigned readBeforeWritten errMsg|
        removeAssigned := variableNames copy.
        node := self placeholderNode.
        outsideVars := variableNames 
                                select: [:each | (node whoDefines: each) references: each].
        outsideVars size == 1 
                ifTrue: [self checkSingleAssignment: outsideVars asArray first].
        outsideVars size > 1 
                ifTrue: 
                        [self refactoringError: 'Cannot extract assignment without all references (multiple assignments to outside vars).'].
        removeAssigned removeAll: outsideVars.

        RBReadBeforeWrittenTester isNil ifTrue:[
            (Dialog confirm:'Cannot check for ReadBeforeWritten variables (RBReadBeforeWrittenTester missing).\\Continue anyway ?' withCRs)
            ifFalse:[
                self refactoringError:'Cannot extract assignment because RBReadBeforeWrittenTester-class is missing'
            ].
        ] ifFalse:[
            readBeforeWritten := RBReadBeforeWrittenTester readBeforeWritten: removeAssigned in: extractedParseTree.
            readBeforeWritten isEmpty ifFalse:[
                readBeforeWritten size == 1 ifTrue:[
                    errMsg := 'Cannot extract assignment because variable "<1s>" is/could be read before written.' expandMacrosWith:(readBeforeWritten first allBold).
                ] ifFalse:[
                    readBeforeWritten size == 2 ifTrue:[
                        errMsg := 'Cannot extract assignment because variables "<1s>" and "<2s>" are/could be read before written.' 
                                    expandMacrosWith:(readBeforeWritten first) with:(readBeforeWritten second).
                    ] ifFalse:[
                        errMsg := 'Cannot extract assignment because <1p> variables are/could be read before written.' 
                                    expandMacrosWith:(readBeforeWritten size).
                    ]
                ].
                Smalltalk isSmalltalkX ifFalse:[
                    self refactoringError:errMsg
                ].
                (Dialog confirm: (errMsg , '\\Extract anyway (Please check the result) ? ' withCRs) default:false)
                ifFalse:[
                    AbortSignal raise.
                ].
            ].
        ].
        removeAssigned 
                do: [:each | (node whoDefines: each) removeTemporaryNamed: each].
        self createTemporariesInExtractedMethodFor: variableNames
!

checkReturn
	needsReturn := self placeholderNode isUsed.
	extractedParseTree containsReturn ifFalse: [^self].
	extractedParseTree lastIsReturn ifTrue: [^self].
	(modifiedParseTree isLast: self placeholderNode) 
		ifFalse: 
			[self refactoringError: 'Couldn''t extract code since it contains a return.'].
	self checkSelfReturns
!

checkSelfReturns
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher
		matches: '^self' do: [:aNode :answer | answer];
		matches: '^`@anything' do: [:aNode :answer | true].
	(searcher executeTree: extractedParseTree initialAnswer: false) 
		ifTrue: [self placeholderNode asReturn]
!

checkSingleAssignment: varName 
        ((RBReadBeforeWrittenTester isVariable: varName
                readBeforeWrittenIn: extractedParseTree) 
                        or: [extractedParseTree containsReturn]) 
                        ifTrue: 
                                [(self shouldExtractEvenWithOtherAssignmentsTo: varName) ifFalse:[AbortSignal raise].
                                 ^ self.
                                " 
                                self refactoringError: 'Cannot extract assignments to temporaries without all references (' , varName ,')'
                                "
                                ].
        extractedParseTree 
                addNode: (RBReturnNode value: (RBVariableNode named: varName)).
        modifiedParseTree := ParseTreeRewriter 
                                replace: self methodDelimiter
                                with: varName , ' := ' , self methodDelimiter
                                in: modifiedParseTree
!

checkSpecialExtractions
	| node |
	node := self placeholderNode parent.
	node isNil ifTrue: [^self].
	(node isAssignment and: [node variable = self placeholderNode]) ifTrue: 
			[self refactoringError: 'Cannot extract left hand side of an assignment'].
	node isCascade ifTrue: 
			[self refactoringError: 'Cannot extract first message of a cascaded message']
!

checkTemporaries
	| temps accesses assigned |
	temps := self remainingTemporaries.
	accesses := temps select: [:each | extractedParseTree references: each].
	assigned := accesses select: [:each | extractedParseTree assigns: each].
	assigned isEmpty ifFalse: [self checkAssignments: assigned].
	^parameters := (accesses asOrderedCollection)
				removeAll: assigned;
				yourself
!

createTemporariesInExtractedMethodFor: assigned 
	assigned do: [:each | extractedParseTree body addTemporaryNamed: each]
!

existingSelector
	"Try to find an existing method instead of creating a new one"

	^class allSelectors detect: [:each | self isMethodEquivalentTo: each]
		ifNone: [nil]
!

extractMethod
        | parseTree isSequence extractCode subtree newCode subtree2 doExtractMultiple doExtractAll methodSource errMessage|

        extractCode := self getExtractedSource.
        extractedParseTree := RBParser parseExpression: extractCode
                                onError: [:string :pos | self refactoringError: 'Invalid source to extract'].
        extractedParseTree isNil 
                ifTrue: [self refactoringError: 'Invalid source to extract'].
        (extractedParseTree isSequence 
                and: [extractedParseTree statements isEmpty]) 
                        ifTrue: [self refactoringError: 'Select some (non-empty) code to extract'].
        isSequence := extractedParseTree isSequence 
                                or: [extractedParseTree isReturn].
        extractedParseTree := RBMethodNode 
                                selector: #value
                                arguments: #()
                                body: (extractedParseTree isSequence 
                                                ifTrue: [extractedParseTree]
                                                ifFalse: 
                                                        [RBSequenceNode temporaries: #()
                                                                statements: (OrderedCollection with: extractedParseTree)]).
        extractedParseTree body temporaries notEmpty 
                ifTrue: [extractedParseTree body temporaries: #()].
        extractedParseTree source: extractCode.

        "old: parseTree := class parseTreeFor: selector."
        "new: want the error message"

"/        method := class compiledMethodAt: selector.
"/        methodSource := method source.

        methodSource := class sourceCodeFor: selector.

        parseTree :=  RBParser 
                parseMethod: methodSource 
                onError: [:str :pos | errMessage := str. Transcript showCR:str. Transcript showCR:pos. nil].

        parseTree isNil 
                ifTrue: [self refactoringError: 'Could not parse ' , selector printString , ' (' , (errMessage ? '???') , ')'].
        subtree := isSequence 
                                ifTrue: 
                                        [ParseTreeSearcher 
                                                treeMatchingStatements: extractedParseTree body formattedCode
                                                in: parseTree]
                                ifFalse: [ParseTreeSearcher treeMatching: extractCode in: parseTree].
        subtree isNil 
                ifTrue: [self refactoringError: 'Could not extract code from method'].

        newCode := self methodDelimiter.
        isSequence 
                ifTrue: 
                        [| stmts |
                        stmts := extractedParseTree body statements.
                        stmts isEmpty 
                                ifFalse: 
                                        [stmts last isAssignment 
                                                ifTrue: 
                                                        [| name |
                                                        name := stmts last variable name.
                                                        (self shouldExtractAssignmentTo: name) 
                                                                ifFalse: 
                                                                        [newCode := '<1s> := <2s>' expandMacrosWith: name with: newCode.
                                                                        stmts at: stmts size put: stmts last value]]]].
        modifiedParseTree := isSequence 
                                ifTrue: 
                                        [ParseTreeRewriter 
                                                replaceStatements: subtree formattedCode
                                                with: newCode
                                                in: parseTree
                                                onInterval: extractionInterval]
                                ifFalse: 
                                        [ParseTreeRewriter 
                                                replace: subtree formattedCode
                                                with: newCode
                                                in: parseTree
                                                onInterval: extractionInterval].

        "more occurrences of this pattern in this method?"
        subtree2 := isSequence 
                                ifTrue: 
                                        [ParseTreeSearcher 
                                                treeMatchingStatements: extractedParseTree body formattedCode
                                                in: modifiedParseTree]
                                ifFalse: [ParseTreeSearcher treeMatching: extractCode in: modifiedParseTree].
        subtree2 notNil ifTrue:[
            "ask"
            doExtractMultiple := self requestExtractMultiple.
            doExtractMultiple ifTrue:[
               "replace all of them in this method"
                modifiedParseTree := isSequence 
                                        ifTrue: 
                                                [ParseTreeRewriter 
                                                        replaceStatements: subtree formattedCode
                                                        with: newCode
                                                        in: modifiedParseTree
                                                        onInterval: (1 to:modifiedParseTree stop) ]
                                        ifFalse: 
                                                [ParseTreeRewriter 
                                                        replace: subtree formattedCode
                                                        with: newCode
                                                        in: modifiedParseTree
                                                        onInterval: (1 to:modifiedParseTree stop) ].
            ]
        ].

false ifTrue:[
        "more occurrences of this pattern in other method(s) ?"
        class selectors do:[:otherSelector |
            |parseTree subtree modifiedParseTree|

            parseTree := class parseTreeFor:otherSelector.
            parseTree notNil ifTrue: [
                subtree := isSequence 
                                        ifTrue: 
                                                [ParseTreeSearcher 
                                                        treeMatchingStatements: extractedParseTree body formattedCode
                                                        in: parseTree]
                                        ifFalse: [ParseTreeSearcher treeMatching: extractCode in: parseTree].
        
                subtree notNil ifTrue:[
                    "ask"
                    doExtractAll isNil ifTrue:[
                        doExtractAll := self requestExtractAll.
                    ].
                    doExtractAll ifTrue:[
                       "replace there as well"
                        modifiedParseTree := isSequence 
                                                ifTrue: 
                                                        [ParseTreeRewriter 
                                                                replaceStatements: subtree formattedCode
                                                                with: newCode
                                                                in: parseTree
                                                                onInterval: (1 to:parseTree stop) ]
                                                ifFalse: 
                                                        [ParseTreeRewriter 
                                                                replace: subtree formattedCode
                                                                with: newCode
                                                                in: parseTree
                                                                onInterval: (1 to:parseTree stop) ].
                    ]
                ]
            ]
        ].
].
!

getExtractedSource
    | src |

    src := source notNil ifTrue:[ source] ifFalse: [class sourceCodeFor: selector ].
    ((extractionInterval first between: 1 and: src size) 
            "and: [extractionInterval last between: 1 and: source size]" ) 
                    ifFalse: [self refactoringError: 'Invalid interval'].
    ^src copyFrom: extractionInterval first to: (extractionInterval last min:src size)

    "Modified: / 26-04-2014 / 11:32:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getNewMethodName
        | newSelector methodName newMethodName |
        methodName := RBMethodName new.
        methodName arguments: parameters.
        
        [newMethodName := self requestMethodNameFor: methodName.
        newMethodName isNil 
                ifTrue: [AbortSignal raise. self refactoringError: 'Did not extract code' ].
        newSelector := newMethodName selector.
        (self checkMethodName: newSelector in: class) 
                ifFalse: 
                        [self refactoringWarning: newSelector , ' is not a valid selector name.'.
                        newSelector := nil].
        (class hierarchyDefinesMethod: newSelector asSymbol) 
                ifTrue: 
                        [(self shouldOverride: newSelector in: class) ifFalse: [newSelector := nil]].
        newSelector isNil] 
                        whileTrue: [].
        parameters := newMethodName arguments asOrderedCollection.
        ^newSelector asSymbol
!

isMethodEquivalentTo: aSelector 
	selector == aSelector ifTrue: [^false].
	aSelector numArgs ~~ parameters size ifTrue: [^false].
	(self isParseTreeEquivalentTo: aSelector) ifFalse: [^false].
	self reorderParametersToMatch: aSelector.
	^true
!

isParseTreeEquivalentTo: aSelector 
	| tree definingClass |
	definingClass := class whoDefinesMethod: aSelector.
	tree := definingClass parseTreeFor: aSelector.
	tree isNil ifTrue: [^false].
	tree isPrimitive ifTrue: [^false].
	(tree body equalTo: extractedParseTree body
		exceptForVariables: (tree arguments collect: [:each | each name])) 
			ifFalse: [^false].
	(definingClass = class or: 
			[(tree superMessages detect: 
					[:each | 
					(class superclass whichClassIncludesSelector: aSelector) 
						~= (definingClass superclass whichClassIncludesSelector: each)]
				ifNone: [nil]) isNil]) 
		ifFalse: [^false].
	^self shouldUseExistingMethod: aSelector
!

methodDelimiter
	^'#''place.holder.for.method'''
!

nameNewMethod: aSymbol 
        | args newSend |
        args := parameters collect: [:parm | RBVariableNode named: parm].
        aSymbol numArgs == args size ifFalse:[
            self refactoringError: 'Attempting to assign selector with wrong number of arguments.'
        ].

        extractedParseTree arguments: args asArray.
        extractedParseTree selector: aSymbol.
        aSymbol numArgs = 0 
                ifTrue: 
                        [modifiedParseTree := ParseTreeRewriter 
                                                replace: self methodDelimiter
                                                with: 'self ' , aSymbol asString
                                                in: modifiedParseTree.
                        ^self].
        newSend := WriteStream on: ''.
        aSymbol keywords with: parameters
                do: 
                        [:key :arg | 
                        newSend
                                nextPutAll: key asString;
                                nextPut: $ ;
                                nextPutAll: arg asString;
                                nextPut: $ ].
        modifiedParseTree := ParseTreeRewriter 
                                replace: self methodDelimiter
                                with: 'self ' , newSend contents
                                in: modifiedParseTree
!

placeholderNode
	| node |
	node := ParseTreeSearcher treeMatching: self methodDelimiter
				in: modifiedParseTree.
	node isNil ifTrue: [self refactoringError: 'Cannot extract code'].
	^node
!

remainingTemporaries
	| temps |
	temps := modifiedParseTree allDefinedVariables asSet.
	extractedParseTree allDefinedVariables 
		do: [:each | temps remove: each ifAbsent: []].
	^temps
!

reorderParametersToMatch: aSelector 
        | tree dictionary |
        tree := class parseTreeFor: aSelector.
        dictionary := Dictionary new.
        tree body equalTo: extractedParseTree body withMapping: dictionary.
        parameters := tree arguments collect: 
                                        [:each | 
                                        dictionary at: each name
                                                ifAbsent: 
                                                        [self 
                                                                refactoringError: 'An internal error occurred, please report this error.']]
!

transform
        | existingSelector |
        existingSelector := self existingSelector.

        RefactoringError handle:[:ex |
            (Dialog confirmOKCancel:ex errorString) ifFalse:[AbortSignal raise].
            ex restart
        ] do:[
            self nameNewMethod: (existingSelector isNil 
                                ifTrue: [self getNewMethodName]
                                ifFalse: [existingSelector]).
        ].

        existingSelector isNil 
                ifTrue: 
                        [class compileTree: extractedParseTree
                                classified: (class protocolsFor: selector)].
        class compileTree: modifiedParseTree.

        " does not work yet ... "
"
        self transformOtherSelectors.
"
!

transformOtherSelectors
        | existingSelector isSequence doExtractAll newCode|

self halt:'please check'.
        newCode := self methodDelimiter.

        isSequence := extractedParseTree isSequence 
                      or: [extractedParseTree isReturn]. 

        "more occurrences of this pattern in other method(s) ?"
        class selectors do:[:otherSelector |
            |parseTree subtree modifiedParseTree|

            otherSelector ~~ extractedParseTree selector ifTrue:[   " skip new method (of course) "
self halt:'please check'.
                parseTree := class parseTreeFor:otherSelector.
                parseTree notNil ifTrue: [
                    subtree := isSequence 
                                    ifTrue: 
                                            [ParseTreeSearcher 
                                                    treeMatchingStatements: extractedParseTree body formattedCode
                                                    in: parseTree]
                                    ifFalse: [ParseTreeSearcher treeMatching: extractedParseTree body formattedCode in: parseTree].

                    subtree notNil ifTrue:[
                        "ask"
                        doExtractAll isNil ifTrue:[
                            doExtractAll := self requestExtractAll.
                        ].
                        doExtractAll ifTrue:[
                           "replace there as well"
                            modifiedParseTree := isSequence 
                                                    ifTrue: 
                                                            [ParseTreeRewriter 
                                                                    replaceStatements: subtree formattedCode
                                                                    with: newCode
                                                                    in: parseTree
                                                                    onInterval: (1 to:parseTree stop) ]
                                                    ifFalse: 
                                                            [ParseTreeRewriter 
                                                                    replace: subtree formattedCode
                                                                    with: newCode
                                                                    in: parseTree
                                                                    onInterval: (1 to:parseTree stop) ].
                            class compileTree: modifiedParseTree.
                        ]
                    ]
                ]
            ]
        ].
! !

!ExtractMethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

