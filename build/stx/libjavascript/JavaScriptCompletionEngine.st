"{ Encoding: utf8 }"

"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaScriptCompletionEngine
	instanceVariableNames:'method class context codeView parser node requestor'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!


!JavaScriptCompletionEngine methodsFor:'accessing'!

klass
    context notNil ifTrue:[
         ^ context receiver class
    ].
    method notNil ifTrue:[
         ^ method mclass
    ].
    class notNil ifTrue:[
         ^ class
    ].
    ^ nil

    "Created: / 23-09-2013 / 14:49:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionEngine methodsFor:'completion'!

completeForMethod:methodOrNil class:classOrNil context:contextOrNil codeView:codeViewArg into:actionBlock
    | cursorPosition |

    method := methodOrNil.
    class := classOrNil.
    context := contextOrNil.
    codeView := codeViewArg.
    requestor := actionBlock. 

    cursorPosition := codeView characterPositionOfCursor - 1.
    parser := JavaScriptCompletionParser new.
    parser setClassToCompileFor: self klass. 
    parser nodeRewriteHook: [:n | 
        (node isNil and:[cursorPosition between: n startPosition and: n endPosition]) ifTrue:[
             node := n.
        ].
        n
    ].
    ParseError handle:[:ex |
        "/ Transcript showCR:'JS completion: error while parsing ignored'.
    ] do:[
        parser parseMethod: codeView contents in: self klass ignoreErrors:true ignoreWarnings:true.
    ].
    "
    SmallSense::ParseNodeInspector openOnNode: parser tree source: codeView contents.
    "

    node notNil ifTrue:[
        node isVariableNode ifTrue:[
             self completeVariable.
             ^ self
        ].
        node isMessage ifTrue:[
             self completeMessage.
             ^ self
        ].
    ].

    self breakPoint: #jv.

    "Created: / 23-09-2013 / 13:49:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-09-2013 / 15:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionEngine methodsFor:'private-completion'!

completeGlobalVariables
    | variables editor klass namespace |

    klass := self klass.
    variables := OrderedCollection new.
    "/ First, globals starting with typed prefix
    namespace := klass nameSpace.
    [ namespace isNameSpace ] whileFalse:[ namespace := namespace nameSpace ]. "/#nameSpace may return private class, sigh
    namespace keysDo:[:name|
        (name startsWith: node name) ifTrue:[
            variables add: name.                    
        ].
    ].
    Smalltalk keysDo:[:name|
        (name startsWith: node name) ifTrue:[
            variables add: name.                    
        ].
    ].
    "/ Ignore class variables, pools and private classes, probably
    "/ useless. We will see.

    editor := [:index |
        |answer start stop oldVar oldLen newLen |

        answer := variables at:index.

        start := node startPosition.
        stop := node endPosition.
        oldVar := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.

        oldLen := stop - start + 1.
        newLen := answer size.

        codeView
            undoableDo:[ 
                codeView replaceFromCharacterPosition:start to:stop with:(answer).

                (answer startsWith:oldVar) ifTrue:[
                    codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                ] ifFalse:[
                    codeView selectFromCharacterPosition:start to:start+newLen-1.
                ].
                codeView dontReplaceSelectionOnInput
            ]
            info:'Completion'.
    ].

    requestor value: variables value: editor value: 'Variable'

    "Created: / 25-09-2013 / 10:48:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeLocalVariables
    | klass instvars variables variables1 variables2 editor |

    klass := self klass.
    klass notNil ifTrue:[
        instvars := klass allInstVarNames
    ] ifFalse:[
        instvars := #()
    ].
    variables := parser methodArgs , parser methodVars , instvars , #('this').
    "/ Make those starting with typed prefix first in the list.
    variables1 := (variables select:[:name | name startsWith: node name ]) sort.
    variables2 := (variables reject:[:name | name startsWith: node name ]) sort.
    variables := variables1 , variables2.


    editor := [:index |
        |answer start stop oldVar oldLen newLen |

        answer := variables at:index.

        start := node startPosition.
        stop := node endPosition.
        oldVar := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.

        oldLen := stop - start + 1.
        newLen := answer size.

        codeView
            undoableDo:[ 
                codeView replaceFromCharacterPosition:start to:stop with:(answer).

                (answer startsWith:oldVar) ifTrue:[
                    codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                ] ifFalse:[
                    codeView selectFromCharacterPosition:start to:start+newLen-1.
                ].
                codeView dontReplaceSelectionOnInput
            ]
            info:'Completion'.
    ].

    requestor value: variables value: editor value: 'Variable'

    "Created: / 25-09-2013 / 10:48:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2013 / 22:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeMessage
    | suggestions selector receiver receiverClass editor |

    selector := node selector.
    receiver := node receiver.
    receiverClass := self classOfNode: receiver.
    suggestions  := Parser findBest:15 selectorsFor:selector in: receiverClass forCompletion:true.

    "/ Now, have to translate selectors from Smalltalk to JavaScript form
    suggestions := suggestions collect:[:each | self selectorToFunctionName: each ].

    editor := [:index |
        |answer selPos start stop oldText oldLen newLen |

        answer := suggestions at:index.

        selPos := node selectorPosition.
        selPos notNil ifTrue:[ 
            start := selPos first.
            stop := selPos last.
        ] ifFalse:[ 
            start := node endPosition - selector size + 1.
            stop := node endPosition.
        ].
        oldText := (codeView textFromCharacterPosition:start to:stop) asString string withoutSeparators.

        oldLen := stop - start + 1.
        newLen := answer size.

        codeView
            undoableDo:[ 
                codeView replaceFromCharacterPosition:start to:stop with:(answer).

                (answer startsWith:oldText) ifTrue:[
                    codeView selectFromCharacterPosition:start+oldLen to:start+newLen-1.
                ] ifFalse:[
                    codeView selectFromCharacterPosition:start to:start+newLen-1.
                ].
                codeView dontReplaceSelectionOnInput
            ]
            info:'Completion'.
        ].

    requestor value: suggestions value: editor value: 'Function/Method'

    "Created: / 25-09-2013 / 11:36:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2014 / 13:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeVariable

    node name first isUppercase ifTrue:[
         self completeGlobalVariables
    ] ifFalse:[
         self completeLocalVariables
    ].

    "Created: / 23-09-2013 / 21:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-09-2013 / 10:48:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionEngine methodsFor:'private-helpers'!

classOfNode:aNode
    "when showing possible completions for a message, it is a good idea to know what the reveiver
     is."

    | nm nodeVal receiverClass nodeSelector nodeReceiver klass |

    klass := self klass.

    aNode isLiteral ifTrue:[
        ^ aNode value class
    ].

    aNode isThis ifTrue:[
        ^ klass ? UndefinedObject
    ].

    aNode isVariable ifTrue:[
        nm := aNode name.
        nm = 'super' ifTrue:[
            klass isNil ifTrue:[^ Object].
            ^ klass superclass
        ].
        nm isUppercaseFirst ifTrue:[
            | namespace global nmAsSymbol |

            nmAsSymbol := nm asSymbolIfInterned.
            nmAsSymbol notNil ifTrue:[
                klass notNil ifTrue:[
                    namespace := klass nameSpace.
                ] ifFalse:[
                    namespace := Smalltalk
                ].    
                [ namespace isNameSpace ] whileFalse:[ namespace := namespace nameSpace ]. "/#nameSpace may return private class, sigh
                global := namespace at: nmAsSymbol.
                global notNil ifTrue:[ ^ global class ].
                global := Smalltalk at: nmAsSymbol.
                global notNil ifTrue:[ ^ global class ].
            ].

            (klass notNil and:[klass theNonMetaclass classVarNames includes:aNode name]) ifTrue:[
                nodeVal := klass theNonMetaclass classVarAt:aNode name.
                ^ nodeVal class.
            ].
        ] ifFalse:[
            context notNil ifTrue:[
                "/ a local in the context?
                (context argAndVarNames includes:nm) ifTrue:[
                    nodeVal := context argsAndVars at:(context argAndVarNames indexOf:nm).
                    nodeVal notNil ifTrue:[
                        ^ nodeVal class
                    ].
                ]
            ].

            klass notNil ifTrue:[
                (klass allInstVarNames includes:nm) ifTrue:[
                    | idx |

                    idx := klass instVarIndexFor: nm.
                    [
                        ^ (klass anyInstance instVarAt: idx) class
                    ] on: Error do:[:ex|

                    ].
                ].
            ]
        ].
    ].

    aNode isMessage ifTrue:[
        nodeSelector := aNode selector.
        nodeReceiver := aNode receiver.

        "/ some hardwired knowledge here
        ( #( #'new' #'basicNew' #'new:' #'basicNew:' #'with:' #'with:with:') includes: nodeSelector ) ifTrue:[
            receiverClass := self classOfNode:nodeReceiver.
            receiverClass notNil ifTrue:[
                receiverClass isBehavior ifTrue:[
                    receiverClass isMeta ifTrue:[
                        ^ receiverClass theNonMetaclass
                    ]
                ]
            ].
        ].
        klass notNil ifTrue:[
            (nodeReceiver isSelf and:[nodeSelector = #'class']) ifTrue:[
                ^ klass class
            ].
        ].

        (nodeSelector = #'asFilename') ifTrue:[
            ^ Filename
        ].
        (nodeSelector = #'size') ifTrue:[
            ^ SmallInteger
        ].

        "/ some wellknown boolean returners (need better type inference here)
        (#( isNil notNil not isEmptyOrNil notEmptyOrNil notEmpty isEmpty 
            isBehavior isMeta
            = ~= == ~~ > >= < <= 
            includes: contains:
            and: or:
            exists atEnd
        ) includes:nodeSelector ) ifTrue:[
            ^ True "/ Boolean - not boolean; it does not contain the full protocol (would not find ifTrue:)
        ].

        ( #( + - * / // \\ ) includes:nodeSelector) ifTrue:[
            "/ assume numeric
            ^ Number
        ].

        ( #( class theMetaclass theNonMetaclass ) includes:nodeSelector) ifTrue:[
            "/ assume behavior
            ^ Behavior
        ].
    ].
    ^ Object

    "Created: / 25-09-2013 / 14:17:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2017 / 17:09:49 / cg"
!

selectorToFunctionName: selector
    | numArgs |

    numArgs := selector numArgs.
    numArgs == 0 ifTrue:[
         ^ selector 
    ].
    numArgs == 1 ifTrue:[
        selector isBinarySelector ifTrue:[
             ^ selector 
             "/ self error: 'Invalid JavaScript function/method name'.
        ].
        ^ selector copyButLast: 1. 
    ].
    ^ (selector copyButLast:1) replaceAll: $: with: $_.

    "Created: / 25-09-2013 / 13:45:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionEngine class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompletionEngine.st,v 1.13 2018-04-26 13:28:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompletionEngine.st,v 1.13 2018-04-26 13:28:41 cg Exp $'
! !

