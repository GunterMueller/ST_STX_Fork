"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPassVisitor subclass:#PPCCodeGenerator
	instanceVariableNames:'codeGen'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors-CodeGenerators'
!

!PPCCodeGenerator class methodsFor:'as yet unclassified'!

new
    ^ self basicNew
        initialize;
        yourself 
!

on: aPPCCompiler
    ^ self new 
        compiler: aPPCCompiler;
        yourself
! !

!PPCCodeGenerator methodsFor:'accessing'!

codeGen
    ^ codeGen
!

codeGen: anObject
    codeGen := anObject
!

guards
    ^ context options guards

    "Modified: / 26-08-2015 / 22:17:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGenerator methodsFor:'code generation'!

generateChoiceChildOf: choiceNode atIndex: choiceChildNodeIndex useGuards: useGuards storeResultInto: resultVar

    | children |

    children := choiceNode children.
    useGuards ifTrue:[
        self addGuard: (children at: choiceChildNodeIndex) ifTrue: [ 
                    codeGen codeClearError.
                    codeGen 
                          codeEvaluateAndAssign:[ self visit:(children at: choiceChildNodeIndex) ]
                          to: resultVar.
                    codeGen codeIf: 'error' then: nil else: [ 
                        codeGen codeReturn: resultVar.  
                    ].
                ] ifFalse:[ 
                    codeGen code: 'error := true.'.
                ].
                codeGen codeIf: 'error' then: [ 
                    choiceChildNodeIndex < children size ifTrue:[ 
                        self generateChoiceChildOf: choiceNode atIndex: choiceChildNodeIndex + 1 useGuards: useGuards storeResultInto: resultVar.
                    ] ifFalse:[ 
                        codeGen codeError: 'no choice suitable'.
                    ].
                ].
    
    ] ifFalse:[ 
                choiceChildNodeIndex <= children size ifTrue:[ 
                    codeGen codeClearError.
                    codeGen 
                          codeEvaluateAndAssignParsedValueOf:[ self visit:(children at: choiceChildNodeIndex) ]
                          to: resultVar.
                    codeGen codeIf: 'error' then: nil else: [ 
                        codeGen codeReturn: resultVar.  
                    ].
                    self generateChoiceChildOf: choiceNode atIndex: choiceChildNodeIndex + 1 useGuards: useGuards storeResultInto: resultVar.
                ] ifFalse:[ 
                    codeGen codeError: 'no choice suitable'.
                ].
    ].

    
!

generateSequenceChildOf: sequenceNode atIndex: sequenceNodeChildIndex useMememntoVar: mementoVar storeResultInto: elementVars
        | child childValueVar |

        child := sequenceNode children at: sequenceNodeChildIndex.
        childValueVar := elementVars at: sequenceNodeChildIndex.
        codeGen codeEvaluateAndAssign: [ self visit:child ] 
                                      to: childValueVar.
        child acceptsEpsilon ifFalse: [   
            codeGen codeIfErrorThen: [
                "Handle error in the first element in a special way,
                 because one does not need to do backtracking  if the first element fails."
                (sequenceNodeChildIndex == 1) ifTrue: [                         
                    codeGen codeReturn: 'failure'
                ] ifFalse: [
                    codeGen restore: sequenceNode from: mementoVar.
                    codeGen codeReturn: 'failure.'.
                ]
            ] else:[ 
                sequenceNode returnParsedObjectsAsCollection ifTrue:[
                    codeGen code: self retvalVar , ' at: ', sequenceNodeChildIndex asString, ' put: ', childValueVar, '.'.
                ].
                (sequenceNodeChildIndex < sequenceNode children size) ifTrue:[ 
                    self generateSequenceChildOf: sequenceNode atIndex: sequenceNodeChildIndex + 1 useMememntoVar: mementoVar storeResultInto: elementVars.
                ].
            ]

        ] ifTrue:[
            sequenceNode returnParsedObjectsAsCollection ifTrue:[
                codeGen code: self retvalVar , ' at: ', sequenceNodeChildIndex asString, ' put: ', childValueVar, '.'.
            ].
            (sequenceNodeChildIndex < sequenceNode children size) ifTrue:[ 
                    self generateSequenceChildOf: sequenceNode atIndex: sequenceNodeChildIndex + 1 useMememntoVar: mementoVar storeResultInto: elementVars.

            ].
        ]
! !

!PPCCodeGenerator methodsFor:'hooks'!

afterAccept: node retval: retval
    "return the method from compiler"
    ^ self stopMethodForNode: node.
!

beforeAccept: node
    self startMethodForNode: node
!

closedDetected: node
    ^ node isMarkedForInline ifFalse: [ 
        self error: 'Should not happen!!'
    ]
!

openDetected: node
    ^ codeGen cachedMethod: (codeGen idFor: node)
! !

!PPCCodeGenerator methodsFor:'private'!

checkBlockIsInlinable: block
    "Check whether the given block could be inlined. If not, 
     throw an error. If yes, this method is noop.

     A block is inlineable if and only if it's a purely functional
     (see PPCASTUtilities>>checkBlockIsPurelyFunctional:inClass: for 
     details)

     As a side-effect, copy all self-sent methods from the block
     to the target class.          
    "
    | blockNode |

    blockNode := block sourceNode.
    "In Smalltalk implementation which use cheap-block optimization (Smalltalk/X) it may
     happen that home context of the block is nil (in case of cheap blocks)"
    block home notNil ifTrue:[ 
        | blockClass |

        blockClass := block home receiver class.
        PPCASTUtilities new checkNodeIsFunctional: blockNode inClass: blockClass.
        "The above code should raise an error when block is not functional (i.e., when not
         inlineable, so if the control flow reach this point, block is OK and we can safely 
         copy self-sent methods."
        self copySelfSentMethodsOf: blockNode inClass: blockClass
    ].

    "Created: / 27-07-2015 / 14:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2015 / 15:52:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copySelfSentMethodsOf: anRBProgramNode inClass: aClass
    PPCASTUtilities new withAllMessageNodesOf: anRBProgramNode sentToSelfDo: [ :node|
        | method source |

        method := aClass lookupSelector: node selector.
        method isNil ifTrue:[
            PPCCompilationError new signalWith: 'oops, no method found (internal error)!!'.        
        ].
        source := method sourceCode.
        source isNil ifTrue:[ 
            PPCCompilationError new signalWith: 'unavailable source for method ', method printString ,'!!'.        
        ].
        "Following actually copies the method to the target class,
         though the APU is not nice. This has to be cleaned up"
        (codeGen cachedMethod: node selector) isNil ifTrue:[ 
            codeGen cacheMethod: (PPCMethod new id: node selector; source: source; yourself) as: node selector.
            "Now compile self-sends of the just copied method"
            self copySelfSentMethodsOf: method parseTree inClass: aClass
        ].
    ]

    "Created: / 27-07-2015 / 14:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGenerator methodsFor:'running'!

run: ir
    "Actually run the pass on given IR (tree of PPCNode) and return
     (possibly transformed or completely new) another IR."

    | entry |

    context isNil ifTrue:[ 
        PPCCompilationError new signal: 'oops, no context set, use #context: before running a pass!!'.
    ].
    context options generate ifTrue:[
        codeGen options: context options.
        codeGen clazz: context parserClass.  
        entry := self visit: ir.
        context parserClass propertyAt:#rootMethod put:entry. 
    ].
    ^ ir

    "Created: / 26-08-2015 / 22:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2015 / 10:18:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGenerator methodsFor:'support'!

compileTokenWhitespace: node
    codeGen codeIf: 'context atWs' then: nil else: [ 
        codeGen 
              codeEvaluateAndAssign:[ self visit:node whitespace ]
              to:#whatever.
        codeGen code: 'context setWs.'.
    ]
!

notCharSetPredicateBody: node
    | classificationId  classification |
    self error: 'deprecated.'.
    classification := node extendClassification: node predicate classification.
    classificationId := (codeGen idFor: classification defaultName: #classification).
    codeGen  addConstant: classification as: classificationId.
    
    codeGen addOnLine: '(', classificationId, ' at: context peek asInteger)'.
    codeGen indent.
    codeGen add: ' ifTrue: [ self error: '' predicate not expected'' ]'.
    codeGen add: ' ifFalse: [ nil ].'.
    codeGen dedent.
!

notMessagePredicateBody: node
    self error: 'deprecated'.
    codeGen addOnLine: '(context peek ', node message, ')'.
    codeGen indent.
    codeGen add: ' ifTrue: [ self error: '' predicate not expected'' ]'.
    codeGen add: ' ifFalse: [ nil ].'.
    codeGen dedent.
!

predicateBody: node
    | tmpId |
    self error:'deprecated'.
    tmpId := (codeGen idFor: node predicate prefixed: #predicate).
    codeGen addConstant: node predicate as: tmpId.

    codeGen addOnLine: '(context atEnd not and: [ ', tmpId , ' value: context uncheckedPeek])'.
    codeGen indent.
    codeGen add: 'ifFalse: [ self error: ''predicate not found'' ]'.
    codeGen add: 'ifTrue: [ context next ].'.
    codeGen dedent.	
!

retvalVar
    ^ codeGen currentReturnVariable

    "Modified: / 15-06-2015 / 18:20:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startMethodForNode:node
    node isMarkedForInline ifTrue:[ 
        codeGen startInline: (codeGen idFor: node).
        codeGen codeComment: 'BEGIN inlined code of ' , node printString.
        codeGen indent.
    ] ifFalse:[ 
        codeGen startMethod: (codeGen idFor: node).
        codeGen codeComment: 'GENERATED by ' , node printString.
        codeGen allocateReturnVariable.
    ].

    "Created: / 23-04-2015 / 15:51:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2015 / 19:13:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-06-2015 / 18:03:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopMethodForNode:aPPCNode
    ^ codeGen currentMethod isInline ifTrue:[ 
                codeGen dedent.
                codeGen code: '"END inlined code of ' , aPPCNode printString , '"'.
                codeGen stopInline.
    ] ifFalse:[ 
                codeGen stopMethod
    ].

    "Created: / 23-04-2015 / 15:51:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2015 / 18:35:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCodeGenerator methodsFor:'traversing - caching'!

cache: node value: retval
    "this is compiler thing, not mine"
!

cachedDetected: node
    ^ codeGen clazz cachedMethod: (codeGen idFor: node)
!

isCached: node
    ^ (codeGen cachedMethod: (codeGen idFor: node)) isNil not
! !

!PPCCodeGenerator methodsFor:'visiting'!

visitActionNode: node
    | blockNode blockBody blockNodesVar blockNeedsCollection blockMatches childValueVars |

    self checkBlockIsInlinable: node block.
    blockNode := node block sourceNode copy.
    self assert: blockNode arguments size == 1.
    blockNodesVar := blockNode arguments first .
    blockBody := blockNode body.

    "Now, analyze block body, search for all references to
     block arg <barg> and check if in all cases it's used 
     in one of the following patterns:

        * <barg> first , <barg> second, ... , <barg> sixth
        * <barg> at: <integer constant>

     If so, then the block code can be inlined and the intermediate
     result collection need not to be created. Keep this information
     in temporary `blockNeedsCollection`. 
     During the analysis, remember all nodes that matches the pattern
     in a dictionary `blockMatches` mapping the node to actual temporary
     variable where the node is used. This will be later used for block's node
     rewriting"
    blockNeedsCollection := true.
    node child isSequenceNode ifTrue:[
        blockNeedsCollection := false.
        blockMatches := IdentityDictionary new."Must use IDENTITY dict as nodes have overwritten their #=!!!!!!"
        childValueVars := node child preferredChildrenVariableNames.
        PPCASTUtilities new withAllVariableNodesOf: blockBody do:[:variableNode| 
            variableNode name = blockNodesVar name ifTrue:[ 
                "Check if variable node matches..."
                variableNode parent isMessage ifTrue:[ 
                    | parent |

                    parent := variableNode parent.
                    "Check for <barg> at: <number>"
                    ((parent selector == #at:) and:[ parent arguments first isLiteralNumber ]) ifTrue:[ 
                        blockMatches at: parent put: (childValueVars at: parent arguments first value).
                    ] ifFalse:[ 
                        "Check for <barg> first / second / ..."
                        | i |

                        i := #(first second third fourth fifth sixth) indexOf: parent selector.
                        i ~~ 0 ifTrue:[ 
                            blockMatches at: parent put: (childValueVars at: i).
                        ] ifFalse:[ 
                            blockNeedsCollection := true.
                        ].
                    ].
                ] ifFalse:[ 
                    blockNeedsCollection := true.
                ].
            ].
        ].
    ].

    blockNeedsCollection ifTrue:[
        "Bad, we have to use the collection.
         Replace all references to blockNodeVar to retvalVar..."
        PPCASTUtilities new withAllVariableNodesOf: blockBody do:[:variableNode| 
            variableNode name = blockNodesVar name ifTrue:[ 
                variableNode name: self retvalVar.
            ].
        ].
    ] ifFalse:[ 
        "Good, can avoid intermediate collection.
         Replace references to collection with corresponding temporary variable"
        blockMatches keysAndValuesDo:[:matchingNode :childValueVar |
            matchingNode parent replaceNode: matchingNode withNode: (RBVariableNode named: childValueVar).
        ].
        node child returnParsedObjectsAsCollection: false. 
    ].

    "Block return value is return value of last statement.
     So if the method is not inline, make last statement a return.
        if the method is inline, make it assignment to retvalVar."
    blockBody statements notEmpty ifTrue:["Care for empty blocks - [:t | ] !!"
        codeGen currentMethod isInline ifTrue:[ 
            |  assignment |

            assignment := RBAssignmentNode variable: (RBVariableNode named: self retvalVar) value:  blockBody statements last.
            blockBody replaceNode: blockBody statements last withNode: assignment.
        ] ifFalse:[  
            | return |

            return := RBReturnNode value: blockBody statements last.
            blockBody replaceNode: blockBody statements last withNode: return.
        ].
    ].

    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:self retvalVar.
    codeGen codeIfErrorThen: [ 
        codeGen codeReturn: 'failure'. 
    ] else: [
        codeGen code: blockBody.    
    ]

    "Modified: / 07-09-2015 / 13:00:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitAndNode: node
    | mementoVar |
    
    mementoVar := codeGen allocateTemporaryVariableNamed: 'memento'.
    codeGen remember: node child to: mementoVar.

    codeGen 
          codeEvaluateAndAssign:[ self visit:node child ]
          to:self retvalVar.
    codeGen restore: node child from: mementoVar.

    codeGen codeReturn.

    "Modified: / 23-04-2015 / 15:59:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitAnyNode: node

    codeGen codeReturn: 'context next ifNil: [ error := true. ].'.

    "Modified: / 23-04-2015 / 20:52:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitCharSetPredicateNode: node

    | classification classificationId |
    classification := node extendClassification: node predicate classification.
    classificationId := codeGen idFor: classification defaultName: #classification.
    codeGen addConstant: classification as: classificationId.
    
    codeGen codeIf: '(', classificationId, ' at: context peek asInteger)' then: [ 
        codeGen codeReturn: 'context next'.
    ] else: [ 
        codeGen codeError: 'predicate not found'.
    ]
!

visitCharacterNode: node
    | chid |
    node character ppcPrintable ifTrue: [ 
        chid := node character storeString 
    ] ifFalse: [ 
        chid := codeGen idFor: node character defaultName: #char.
        codeGen addConstant: (Character value: node character asInteger) as: chid .
    ].
    
    codeGen codeIf: '(context peek == ', chid, ')' then: [  
        codeGen codeReturn: 'context next'.
    ] else: [ 
        codeGen codeError: node character asInteger asString, ' expected'.
    ].
!

visitChild: child of: node
    |  |

    (self isOpen: child) ifTrue: [ 
        "already processing..."
        ^ nil
    ].

    ^ self visit: child.
!

visitChoiceNode: node
    |  whitespaceConsumed useGuards resultVar  |

    resultVar := codeGen allocateTemporaryVariableNamed: 'element'.
    whitespaceConsumed := self addGuardTrimming: node.
    useGuards := whitespaceConsumed.
    self generateChoiceChildOf: node atIndex: 1 useGuards: useGuards storeResultInto: resultVar
    

    "Modified: / 29-05-2015 / 07:17:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitEndOfFileNode: node
    codeGen codeReturn: 'context atEnd ifTrue: [ #EOF ] ifFalse: [ self error: ''EOF expected!!'' ].'.
!

visitEndOfInputNode: node

    codeGen 
          codeEvaluateAndAssign:[ self visit:node child ]
          to:self retvalVar.
    codeGen codeIf: 'context atEnd' 
                then: [ codeGen codeReturn ]
                else: [ codeGen codeError: 'End of input expected' ].
        
    "Modified: / 26-05-2015 / 19:03:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitForwardNode: node

    codeGen 
          codeEvaluateAndAssign:[ self visit:node child ]
          to:self retvalVar.
    codeGen codeReturn.
!

visitLiteralNode: node
    | positionVar encodedLiteral |
    encodedLiteral := node encodeQuotes: node literal.
    positionVar := codeGen allocateTemporaryVariableNamed: 'position'.

    codeGen codeAssign: 'context position.' to: positionVar.
    codeGen codeIf: '((context next: ', node literal size asString, ') = #''', encodedLiteral, ''')' then: [
        codeGen codeReturn: '#''', encodedLiteral, ''' '.
    ] else: [  
        codeGen code: 'context position: ', positionVar, '.'.
        codeGen codeError: encodedLiteral,  ' expected' at: positionVar.
    ].
!

visitMappedActionNode: node
    | child blockNode blockBody |

    self checkBlockIsInlinable: node block. 
    child := node child.
    blockNode := node block sourceNode copy.
    blockBody := blockNode body.

    "Block return value is return value of last statement.
     So if the method is not inline, make last statement a return.
        if the method is inline, make it assignment to retvalVar."
    codeGen currentMethod isInline ifTrue:[ 
        |  assignment |

        assignment := RBAssignmentNode variable: (RBVariableNode named: self retvalVar) value:  blockBody statements last.
        blockBody replaceNode: blockBody statements last withNode: assignment.
    ] ifFalse:[  
        | return |

        return := RBReturnNode value: blockBody statements last.
        blockBody replaceNode: blockBody statements last withNode: return.
    ].

    child isSequenceNode ifTrue:[  
        child isMarkedForInline ifTrue:[ 
            child preferredChildrenVariableNames: blockNode argumentNames.
            child returnParsedObjectsAsCollection: false.
        ].
    ] ifFalse:[ 
        "Child is not a sequence so it 'returns' only one object.
         Therefore the block takes only one argument and it's value
         is value of child's retval.
         In the block, replace all references to block argument to
         my retvalVar. "
        | blockArg |

        blockArg := blockNode arguments first.
        PPCASTUtilities new withAllVariableNodesOf: blockBody do:[:variableNode| 
            variableNode name = blockArg name ifTrue:[ 
                variableNode name: self retvalVar.
            ].
        ]. 
    ].

    codeGen codeEvaluateAndAssign: [ self visit: child ] to: self retvalVar.
    codeGen codeIf: 'error' then: [ 
        codeGen codeReturn: 'failure'. 
    ] else: [
        "If the child is sequence and not inlined, extract
         nodes from returned collection into used-to-be block variables"
        (child isSequenceNode and:[ child returnParsedObjectsAsCollection ]) ifTrue:[
            blockNode arguments withIndexDo:[ :arg :idx |
                node child isMarkedForInline ifFalse:[ 
                    codeGen allocateTemporaryVariableNamed: arg name.
                    codeGen codeAssign: (self retvalVar , ' at: ', idx printString) to: arg name.
                ].
                codeGen codeOnLine: '.'; codeNl.
            ].
        ].
        codeGen code: blockBody.    
    ]

    "Created: / 02-06-2015 / 17:28:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2015 / 15:49:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitMessagePredicateNode: node
    codeGen codeIf: '(context peek ', node message, ')' then: [
        codeGen codeReturn: ' context next'.
    ] else: [ 
        codeGen codeError: 'predicate not found'.
    ]
    "Modified: / 23-04-2015 / 18:39:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitNilNode: node

    codeGen codeReturn: 'nil.'.
!

visitNotCharSetPredicateNode: node
    | classificationId  classification |
    classification := node extendClassification: node predicate classification.
    classificationId := (codeGen idFor: classification defaultName: #classification).
    codeGen  addConstant: classification as: classificationId.
    
    codeGen codeIf: '(', classificationId, ' at: context peek asInteger)'  then: [ 
        codeGen codeError: 'predicate not expected'.
    ] else: [ 
        codeGen codeReturn: 'nil'.
    ]
!

visitNotCharacterNode: node
    | chid |
    node character ppcPrintable ifTrue: [ 
        chid := node character storeString 
    ] ifFalse: [ 
        chid := codeGen idFor: node character defaultName: #char.
        codeGen addConstant: (Character value: node character asInteger) as: chid .
    ].
    
    codeGen codeIf: '(context peek == ', chid, ')' then: [ 
        codeGen codeError: node character asInteger asString, ' not expected'.
    ] else: [ 
        codeGen codeReturn: 'nil.'.
    ].
!

visitNotLiteralNode: node
    | encodedLiteral size |
    encodedLiteral := node encodeQuotes: node literal.
    size := node literal size asString.
    
    codeGen codeIf: '((context peek: ', size, ') =#''', encodedLiteral, ''')' then: [ 
        codeGen codeError: encodedLiteral, ' not expected'.
    ] else: [ 
        codeGen codeReturn: 'nil' .
    ]
!

visitNotMessagePredicateNode: node
    codeGen codeIf: '(context peek ', node message, ')' then: [ 
        codeGen codeError: 'predicate not expected'.
    ] else: [ 
        codeGen codeReturn: 'nil'.
    ]
!

visitNotNode: node
    | mementoVar |

    mementoVar := codeGen allocateTemporaryVariableNamed: 'memento'.
    codeGen remember: node child to: mementoVar.
    
    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:#whatever.
    codeGen restore: node child from: mementoVar.

    codeGen code: '^ error ifFalse: [ self error ] ifTrue: [ self clearError. nil ]'.

    "Modified: / 05-05-2015 / 14:29:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitOptionalNode: node
    codeGen 
          codeEvaluateAndAssign:[ self visit:node child ]
          to:self retvalVar.
    codeGen codeIf: 'error' then: [ 
        codeGen codeClearError.
        codeGen codeAssign: 'nil.' to: self retvalVar.
    ].
    codeGen codeReturn.
!

visitPluggableNode: node
    | blockId |
    blockId := codeGen idFor: node block defaultName: #pluggableBlock.
    
    codeGen addConstant: node block as: blockId.
    codeGen codeReturn: blockId, ' value: context.'.
!

visitPlusNode: node
    | elementVar  |
                
    elementVar := codeGen allocateTemporaryVariableNamed:  'element'.
     
"       self tokenGuards ifTrue: [ 
        compiler codeTokenGuard: node ifFalse: [ compiler codeError: 'at least one occurence expected' ].   
    ].
"        
    codeGen codeAssign: 'OrderedCollection new.' to: self retvalVar.
    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:elementVar.

    codeGen codeIf: 'error' then: [
        codeGen codeError: 'at least one occurence expected'.
    ] else: [ 
        (self retvalVar ~~ #whatever) ifTrue:[
            codeGen code: self retvalVar , ' add: ',elementVar , '.'.
        ].            
        codeGen codeEvaluateAndAssignParsedValueOf:[ self visit:node child ] to:elementVar.
        codeGen code: '[ error ] whileFalse: ['.
        codeGen indent.
        (self retvalVar ~~ #whatever) ifTrue:[
            codeGen code: self retvalVar , ' add: ',elementVar , '.'.
        ].
        codeGen codeEvaluateAndAssign:[ self visit:node child ] to:elementVar.
        codeGen dedent.
        codeGen code: '].'.
        codeGen code: 'self clearError.'.

        (self retvalVar ~~ #whatever) ifTrue:[ 
            codeGen codeReturn: self retvalVar , ' asArray.'.         
        ].
    ].
    "Modified: / 26-05-2015 / 19:04:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPredicateNode: node
    | pid |
    pid := (codeGen idFor: node predicate defaultName: #predicate).

    codeGen addConstant: node predicate as: pid.

    codeGen codeIf: '(context atEnd not and: [ ', pid , ' value: context uncheckedPeek])' then: [ 
        codeGen code: self retvalVar ,' := context next.'.
    ] else: [ 
        codeGen codeError: 'predicate not found'.
    ].
    codeGen codeReturn.

    "Modified: / 23-04-2015 / 21:48:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitRecognizingSequenceNode: node
    | mementoVar canBacktrack |

    canBacktrack := (node children allButFirst allSatisfy: [:e | e acceptsEpsilon ]) not.

    canBacktrack ifTrue: [ 
        mementoVar := codeGen allocateTemporaryVariableNamed: 'memento'.			
        codeGen remember: node to: mementoVar.
    ].

    codeGen 
          codeEvaluateAndAssign:[ self visit:(node children at:1) ]
          to:#whatever.
    codeGen code: 'error ifTrue: [ ^ failure ].'.

    2 to: (node children size) do: [ :idx  | |child|
        child := node children at: idx.
        codeGen codeEvaluateAndAssignParsedValueOf:[ self visit:child ] to:#whatever.
        
        child acceptsEpsilon ifFalse: [   
            codeGen codeIf: 'error' then: [ 
                codeGen restore: node from: mementoVar.
                codeGen code: ' ^ failure .'.
            ]
        ].
    ].
!

visitSequenceNode: node

    | elementVars mementoVar canBacktrack  |

    elementVars := node preferredChildrenVariableNames.
    elementVars do:[:e | 
        codeGen allocateTemporaryVariableNamed: e.  
    ].

    canBacktrack := (node children allButFirst allSatisfy: [:e | e acceptsEpsilon ]) not.

"       self addGuardTrimming: node.
    self addGuard: node ifTrue: nil ifFalse: [ compiler addOnLine: ' ^ self error' ].
"
    canBacktrack ifTrue: [ 
        mementoVar := codeGen allocateTemporaryVariableNamed: 'memento'.
        codeGen remember: node to: mementoVar.
    ].

    node returnParsedObjectsAsCollection ifTrue:[
        codeGen codeAssign: 'Array new: ', node children size asString, '.' to: self retvalVar.
    ].
    self generateSequenceChildOf: node atIndex: 1 useMememntoVar: mementoVar storeResultInto: elementVars.
    codeGen codeReturn

    "Modified (comment): / 16-06-2015 / 06:38:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitStarAnyNode: node
    | retvalVar sizeVar |

    retvalVar := self retvalVar.
    sizeVar := codeGen allocateTemporaryVariableNamed: 'size'.  
    codeGen code: sizeVar , ' := context size - context position.'.
    codeGen code: retvalVar,' := Array new: ',sizeVar,'.'.
    codeGen code: '(1 to: ',sizeVar,') do: [ :e | ',retvalVar,' at: e put: context next ].'.
    codeGen codeReturn.

    "Modified: / 15-06-2015 / 18:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitStarCharSetPredicateNode: node
    | classification classificationId |
    

    classification := node extendClassification: node predicate classification.
    classificationId := codeGen idFor: classification defaultName: #classification.
    codeGen addConstant: classification as: classificationId.
    
    codeGen codeAssign: 'OrderedCollection new.' to: self retvalVar.	
    codeGen code: '[ ', classificationId, ' at: context peek asInteger ] whileTrue: ['.
    codeGen indent.
    codeGen codeEvaluate: 'add:' argument: 'context next.' on: self retvalVar.
    codeGen dedent.
    codeGen code: '].'.
    codeGen codeAssign: self retvalVar, ' asArray.' to: self retvalVar.
   codeGen codeReturn.
!

visitStarMessagePredicateNode: node

    codeGen codeAssign: 'OrderedCollection new.' to: self retvalVar.	
    codeGen code: '[ context peek ', node message, ' ] whileTrue: ['.
    codeGen indent.
    codeGen codeEvaluate: 'add:' argument: 'context next.' on: self retvalVar.
    codeGen dedent.
    codeGen code: '].'.
    codeGen codeAssign: self retvalVar, ' asArray.' to: self retvalVar.
   codeGen codeReturn.
!

visitStarNode: node
    | elementVar |
    
    elementVar := codeGen allocateTemporaryVariableNamed: 'element'.
    codeGen codeAssign: 'OrderedCollection new.' to: self retvalVar.

    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:elementVar.
    codeGen codeIf: 'error' then: [ 
        codeGen codeClearError.
        codeGen codeReturn: self retvalVar, ' asArray.'.
    ].

    codeGen code: '[ error ] whileFalse: ['.
    codeGen indent.
    codeGen code: self retvalVar, ' add: ', elementVar, '.'.
    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:elementVar.
    codeGen dedent.
    codeGen code: '].'.
    codeGen codeClearError.
    codeGen codeReturn: self retvalVar, ' asArray.'.
!

visitSymbolActionNode: node
    | elementVar |
    
    elementVar := codeGen allocateTemporaryVariableNamed: 'element'.	
    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:elementVar.
    codeGen codeIf: 'error' then: [ 
        codeGen codeReturn: 'failure'
    ] else: [
        codeGen codeReturn: elementVar, ' ', node block asString, '.'.
    ]
!

visitTokenActionNode: node
    "
        Actually, do nothing, we are in Token mode and the 
        child does not return any result and token takes only
        the input value.
    "	

    codeGen add: '^ '.
    codeGen callOnLine: (node child compileWith: codeGen).
!

visitTokenNode: node
    | startVar endVar |
    startVar := codeGen allocateTemporaryVariableNamed: 'start'.
    endVar := codeGen allocateTemporaryVariableNamed: 'end'.
    
    codeGen profileTokenRead: (codeGen idFor: node).
    
    codeGen codeAssign: 'context position + 1.' to: startVar.
    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:#whatever.
    codeGen codeIf: 'error' then: nil else: [
        codeGen codeAssign: 'context position.' to: endVar.
        codeGen codeReturn: node tokenClass asString, ' on: (context collection) 
                                                                    start: ', startVar, '  
                                                                    stop: ', endVar, '
                                                                    value: nil.'.
    ]
!

visitTokenStarMessagePredicateNode: node

    codeGen code: '[ context peek ', node message,' ] whileTrue: ['.
    codeGen indent.
    codeGen code: 'context next'.
    codeGen indent.
    codeGen dedent.
    codeGen code: '].'.
!

visitTokenStarSeparatorNode: node

    codeGen code: 'context skipSeparators.'.
!

visitTokenWhitespaceNode: node
    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:#whatever.
    codeGen codeReturn.
!

visitTrimNode: node
    | mementoVar |
    "TODO: This ignores the TrimmingParser trimmer object!!"

    mementoVar := codeGen allocateTemporaryVariableNamed:  'memento'.

    codeGen remember: node child to: mementoVar.
    codeGen code: 'context skipSeparators.'.

    codeGen 
          codeEvaluateAndAssign:[ self visit:node child ]
          to:self retvalVar.
    
    codeGen codeIf: 'error' then: [ 
        codeGen restore: node child from: mementoVar.
        codeGen codeReturn.
    ] else: [ 
        codeGen code: 'context skipSeparators.'.
        codeGen codeReturn.
    ]
!

visitTrimmingTokenCharacterNode: node
    ^ self visitTrimmingTokenNode: node
!

visitTrimmingTokenNode: node
    |  id guard startVar endVar |

    startVar := codeGen allocateTemporaryVariableNamed: 'start'.
    endVar := codeGen allocateTemporaryVariableNamed:  'end'.
    
    id := codeGen idFor: node.
    codeGen profileTokenRead: id.
    
    self compileTokenWhitespace: node.

    (context options guards and: [(guard := PPCGuard on: node) makesSense]) ifTrue: [ 
        guard id: id, '_guard'.
        codeGen code: 'context atEnd ifTrue: [ self error ].'.
        guard compileGuard: codeGen.
        codeGen codeOnLine: 'ifFalse: [ self error ].'.
        codeGen code: 'error ifFalse: ['.
        codeGen indent.
    ].

    codeGen codeAssign: 'context position + 1.' to: startVar.
    codeGen codeEvaluateAndAssign:[ self visit:node child ] to:#whatever.

    (context options guards and: [(guard := PPCGuard on: node) makesSense]) ifTrue: [ 
        codeGen dedent.
        codeGen code: '].'.
    ].

    codeGen codeIf: 'error' then: nil else: [
        codeGen codeAssign: 'context position.' to: endVar.
        "       self compileSecondWhitespace: compiler."
        self compileTokenWhitespace: node.

        codeGen codeReturn: node tokenClass asString, ' on: (context collection) 
                                                                    start: ', startVar, ' 
                                                                    stop: ', endVar, '
                                                                    value: nil'.
    ]

    "Modified: / 26-08-2015 / 22:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitUnknownNode: node
    | compiledChild compiledParser id |

    id := codeGen idFor: node.
    
    compiledParser := node parser copy.
    "Compile all the children and call compiled version of them instead of the original one"
    compiledParser children do: [ :child | 
        compiledChild := self visit: child.
        compiledParser replace: child with: compiledChild bridge.
    ].
    
    codeGen addConstant: compiledParser as: id. 
    
    codeGen codeClearError.
    codeGen codeIf: '(', self retvalVar, ' := ', id, ' parseOn: context) isPetitFailure' then: [ 
        codeGen codeError: 'self error: ', self retvalVar at: self retvalVar, ' position .'.
    ].
    codeGen code: 'error := ', self retvalVar, ' isPetitFailure.'.
    codeGen codeReturn.

    "Modified: / 15-06-2015 / 17:59:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

