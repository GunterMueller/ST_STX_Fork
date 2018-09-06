"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

SyntaxHighlighter subclass:#SmalltalkSyntaxHighlighter
	instanceVariableNames:'elements lastVariableElements lastSelectorElement
		ignoreBadIdentifier'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk'
!

!SmalltalkSyntaxHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
! !

!SmalltalkSyntaxHighlighter class methodsFor:'highlighting'!

format:aString parsingWith:aBlock in:aClass elementsInto:elements
    "common code for formatStatementList, formatExpression, ...
     format (recolor) whatever is parsed in aBlock (within the context of a given class).
     Return the text containing font changes and color information.
     As a side effect, put syntax elements into the passed in elements container
     (for element-highlighting in codeView2)"

    |parser tree text endPos|

    aString isNil ifTrue:[^ nil].

    parser := self for:(ReadStream on:aString string) in:aClass.
    parser elements: elements.
    parser ignoreErrors:true.
    parser ignoreWarnings:true.
    parser sourceText:(text := aString string asText).
    "/ use an array here - this can be changed much faster using #at:put:
    text emphasisCollection:(Array new:aString size).

    parser nextToken.
    tree := aBlock value:parser.
    "/ now, convert the emphasis-array to a runArray
    text emphasisCollection:(text emphasis asRunArray).

    tree == #Error ifTrue:[
        "/ mhmh - which is better ...
        "/ alternative1: color rest after error in red
"/        text 
"/            emphasizeFrom:(parser sourceStream position) 
"/            to:text size 
"/            with:(#color->Color red).


        "/ alternative2: take original emphasis for rest

        endPos := parser sourceStream position + 1.
        endPos >= text size ifTrue:[
            ^ text
        ].
        ^ ((text copyTo:endPos) , (aString copyFrom:(endPos+1))).

        "/ alternative3: no emphasis for rest.

"/        ^ text "/ aString
    ].
    ^ text

    "
     self
        formatStatementList:'(1 + 2) max:5. 1 + 2' 
        in:UndefinedObject
        elementsInto:(OrderedCollection new).
    "
!

formatClassDefinition:aString in:aClass elementsInto: elements
    "format (recolor) a class definition expression in a given class.
     Return the text containing font changes and color information."

    ^ self formatExpression:aString in:aClass elementsInto: elements

    "Created: / 10-04-2011 / 18:18:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:aString in:aClass elementsInto: elements
    "format (recolor) an expression in a given class.
     Return the text containing font changes and color information."

    |parser tree text endPos|

    aString isNil ifTrue:[^ nil].

    parser := self for:(ReadStream on:aString string) in:aClass.
    parser elements: elements.
    parser ignoreErrors:true.
    parser ignoreWarnings:true.
    parser sourceText:(text := aString string asText).
    "/ use an array here - this can be changed much faster using #at:put:
    text emphasisCollection:(Array new:aString size).

    parser nextToken.
    tree := parser "expression"statementList.
    "/ now, convert the emphasis-array to a runArray
    text emphasisCollection:(text emphasis asRunArray).

    tree == #Error ifTrue:[
	"/ mhmh - which is better ...
	"/ alternative1: color rest after error in red
"/        text
"/            emphasizeFrom:(parser sourceStream position)
"/            to:text size
"/            with:(#color->Color red).


	"/ alternative2: take original emphasis for rest

	endPos := parser sourceStream position1Based.
	endPos >= text size ifTrue:[
	    ^ text
	].
	^ ((text copyTo:endPos) , (aString copyFrom:(endPos+1))).

	"/ alternative3: no emphasis for rest.

"/        ^ text "/ aString
    ].
    ^ text

    "
     self
	formatExpression:'(1 + 2) max:5'
	in:UndefinedObject
    "

    "Created: / 25-07-2010 / 08:56:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-07-2010 / 10:57:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:aString in:aClass using:preferencesOrNil elementsInto: elements
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    "/ obsolete interface
    ^ self
	formatMethod:nil
	source:aString
	in:aClass
	using:preferencesOrNil elementsInto:elements

    "Created: / 25-07-2010 / 08:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 05-07-2011 / 11:07:50 / cg"
!

formatMethod:aMethodOrNil source:aString in:aClass using:preferencesOrNil elementsInto: elements
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    |highlighter tree text endPos eColor|

    aString isNil ifTrue:[^ nil].

    Error handle:[:ex |
        ex creator isHandled ifTrue:[
            ex reject.
        ].
        (self parseErrorSignal handles:ex) ifFalse:[
            "Parse error may happen when re-formatting incomplete code while editing"
            ('SyntaxHighlighter [info]: error during highlight: ' , ex description) infoPrintCR.
            "/ ex suspendedContext fullPrintAll.
        ].
        ^ aString
    ] do:[
        highlighter := self for:(ReadStream on:aString string) in:aClass.
        highlighter elements: elements.
        preferencesOrNil notNil ifTrue:[highlighter preferences:preferencesOrNil].
        "/ highlighter ignoreErrors:true.
        highlighter ignoreWarnings:true.
        highlighter sourceText:(text := aString string asText).
        "/ use an array here - this can be changed much faster using #at:put:
        text emphasisCollection:(Array new:aString size).

        tree := highlighter parseMethod.
        "/ now, convert the emphasis-array to a runArray
        text emphasisCollection:(text emphasis asRunArray).

        tree == #Error ifTrue:[
            eColor := UserPreferences current errorColor.
            eColor notNil ifTrue:[
                "/ mhmh - which is better ...
                "/ alternative1: color rest after error in red
                text
                    emphasizeFrom:(highlighter sourceStream position + 1) 
                    to:text size
                    with:(#color->eColor).
            ] ifFalse:[
                "/ alternative2: take original emphasis for rest

                endPos := highlighter sourceStream position + 1.
                endPos >= text size ifTrue:[
                    ^ Array with: text with: highlighter elements
                ].
                ^ ((text copyTo:endPos) , (aString copyFrom:(endPos+1)))
            ].
            "/ alternative3: no emphasis for rest.
        ].
        ^text
    ]
    "
     self
        formatMethod:'foo
    ^ self bar:''hello''.

    ' , (Character doubleQuote asString) , 'some comment' , (Character doubleQuote asString) , '
'
        in:UndefinedObject
    "

    "Modified: / 22-08-2006 / 13:32:04 / cg"
    "Created: / 05-07-2011 / 10:39:21 / cg"
    "Modified: / 28-05-2013 / 22:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatStatements:aString in:aClass elementsInto: elements
    "format (recolor) a statement list in a given class.
     Return the text containing font changes and color information."

    ^ self 
        format:aString parsingWith:[:parser | parser parseMethodBody ]
        in:aClass elementsInto:elements

    "
     self
        formatStatements:'(1 + 2) max:5. 1 + 2' 
        in:UndefinedObject
        elementsInto:(OrderedCollection new).
    "

    "Created: / 22-02-2016 / 21:10:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkSyntaxHighlighter methodsFor:'accessing'!

elements
    ^ elements
!

elements:aParseTreeIndex
    "the element collection, to collect variables, selectors etc. into"

    elements := aParseTreeIndex.

    "Modified (comment): / 21-08-2011 / 09:13:31 / cg"
!

tree: aParseNode
    super tree: aParseNode.
    elements tree: aParseNode

    "Created: / 16-02-2012 / 09:56:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkSyntaxHighlighter methodsFor:'initialization'!

initialize

    super initialize.
    elements := ParseTreeIndex new.
    lastVariableElements := Dictionary new.

    "Created: / 14-02-2010 / 13:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 09:37:35 / cg"
    "Modified: / 16-02-2012 / 09:59:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkSyntaxHighlighter methodsFor:'parsing-expressions'!

binaryExpressionFor:receiverArg
    "parse a binary-expression; return a node-tree, nil or #Error"

    |receiver expr arg sel pos1 pos2 lno|

    receiver := receiverArg.
    (receiver == #Error) ifTrue:[^ #Error].

    "special kludge: since Scanner cannot know if -digit is a binary
     expression or a negative constant, handle cases here"

    [(tokenType == #BinaryOperator) 
     or:[(tokenType == $|)
     or:[(tokenType == $^ and:[parserFlags allowCaretAsBinop])
         or:[((tokenType == #Integer) or:[tokenType == #Float])
             and:[tokenValue < 0]]]]
    ] whileTrue:[
        "/ kludge alarm: in a function-call argList, #, is not a binarySelector
        inFunctionCallArgument == true ifTrue:[
            ((tokenType == #BinaryOperator) and:[tokenName = ',']) ifTrue:[
                ^ receiver
            ].
        ].

        pos1 := tokenPosition.
        lno := tokenLineNr.

        "/ kludge alarm: bar, caret and minus are not scanned as binop
        (tokenType == $|) ifTrue:[
            sel := '|'.
            sel := self selectorCheck:sel for:receiver position:tokenPosition to:tokenPosition.
            self nextToken.
        ] ifFalse:[
            (tokenType == $^) ifTrue:[
                sel := '^'.
                sel := self selectorCheck:sel for:receiver position:tokenPosition to:tokenPosition.
                self nextToken.
            ] ifFalse:[
                (tokenType == #BinaryOperator) ifTrue:[
                    sel := tokenName.
                    sel := self selectorCheck:sel for:receiver position:tokenPosition to:(tokenPosition + tokenName size - 1).
                    self nextToken
                ] ifFalse:[
                    sel := '-'.
                    token := tokenValue := tokenValue negated.
                    tokenPosition := tokenPosition + 1. "/ to skip the sign
                ]
            ].
        ].

        pos2 := pos1 + sel size - 1.
        self markSelector:sel from:pos1 to:pos2 receiverNode:receiver.
        lastSelectorElement := nil.

        arg := self unaryExpression.
        (arg == #Error) ifTrue:[^ #Error].

        expr := BinaryNode receiver:receiver selector:sel arg:arg fold:foldConstants.
        expr isErrorNode ifTrue:[
            self parseError:(expr errorString) position:pos1 to:tokenPosition.
            errorFlag := false. "ok, user wants it - so he'll get it"
            expr := BinaryNode receiver:receiver selector:sel arg:arg fold:nil.
        ].
        expr lineNumber:lno.
        expr selectorPosition:pos1.

        self checkPlausibilityOf:expr from:pos1 to:pos2.
        receiver := expr.   "/ for next message
    ].
    ^ receiver

    "Modified: / 09-01-1998 / 19:05:18 / stefan"
    "Modified: / 14-02-2010 / 17:54:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2012 / 10:46:49 / cg"
!

expression
    | node savedLastSelectorElement |

    savedLastSelectorElement := lastSelectorElement.
    lastSelectorElement := nil.
    node := super expression.
    ((node ~~ #Error) and:[node isMessage]) ifTrue:[
        [ lastSelectorElement notNil ] whileTrue:[
            lastSelectorElement node parent: node.
            lastSelectorElement := lastSelectorElement prev.
        ].
    ].
    lastSelectorElement := savedLastSelectorElement.
    ^node

    "Modified: / 19-01-2000 / 16:22:16 / cg"
    "Modified: / 16-02-2012 / 23:39:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primary_identifier
    | node |

    ignoreBadIdentifier := classToCompileFor isNil.
    node := super primary_identifier.
    ignoreBadIdentifier := false.
    (node ~~ #Error and:[node isVariable]) ifTrue:[
        | el prevEl |

        el := elements newElementFor: node.
        prevEl := lastVariableElements at:node name ifAbsent:[nil].
        prevEl notNil ifTrue:[prevEl next:el].
        lastVariableElements at:node name put:el.
        elements add: el.
    ].
    ^node

    "Created: / 24-09-2013 / 00:42:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-10-2013 / 14:43:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unaryExpressionFor:receiverArg
    "parse a unary-expression; return a node-tree, nil or #Error"

    |receiver expr sel pos pos2 lNr arguments savedLastSelectorElement|

    savedLastSelectorElement := lastSelectorElement.
    receiver := receiverArg.
    (receiver == #Error) ifTrue:[^ #Error].

    [ self isValidUnarySelector:tokenType ] whileTrue:[
	pos := tokenPosition.
	pos2 := pos + tokenName size - 1.
	lNr := tokenLineNr.
	sel := tokenName.

	lastSelectorElement := nil.
	self markSelector:sel from:pos to:pos2 receiverNode:receiver.

	self nextToken.
	tokenType == $( ifTrue:[
	    parserFlags allowSqueakExtensions == true ifTrue:[
		"/ croquet/squeak extension - c/java-style arguments
		arguments := self functionCallArgList.
		"/ synthetic selector: foo[:[with:[with:[...]]]]
		arguments notEmpty ifTrue:[
		    sel := sel , ':'.
		    arguments size - 1 timesRepeat:[ sel := sel , 'with:' ].
		].
		sel := self selectorCheck:sel for:receiver position:pos to:pos2.
		expr := MessageNode receiver:receiver selector:sel args:arguments fold:foldConstants.
		expr isErrorNode ifTrue:[
		    self parseError:(expr errorString) position:pos to:pos2.
		    errorFlag := false. "ok, user wants it - so he'll get it"
		    expr := MessageNode receiver:receiver selector:sel args:arguments fold:nil.
		].
		lastSelectorElement node parent: expr.
		expr lineNumber:lNr.
		self checkPlausibilityOf:expr from:pos to:pos2.
		parseForCode ifFalse:[
		    self rememberSelectorUsed:sel receiver:receiver
		].
		^ expr.
	    ].
	].

	sel := self selectorCheck:sel for:receiver position:pos to:pos2.
	expr := UnaryNode receiver:receiver selector:sel fold:foldConstants.
	expr isErrorNode ifTrue:[
	    self warning:(expr errorString , '.\\If you proceed, that error will happen at runtime.') withCRs position:pos to:pos2.
	    errorFlag := false. "ok, user wants it - so he'll get it"
	    expr := UnaryNode receiver:receiver selector:sel fold:nil.
	].
	expr lineNumber:lNr.
	lastSelectorElement node parent: expr.

	self checkPlausibilityOf:expr from:pos to:pos2.
	parseForCode ifFalse:[
	    self rememberSelectorUsed:sel receiver:receiver
	].

	receiver := expr.   "/ for next message
    ].
    lastSelectorElement := savedLastSelectorElement.
    ^ receiver

    "Modified: / 19-01-2012 / 10:47:37 / cg"
    "Created: / 16-02-2012 / 23:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkSyntaxHighlighter methodsFor:'syntax detection'!

markLocalVariableDeclaration: name from:pos1 to:pos2
    | type node |

    super markLocalVariableDeclaration: name from:pos1 to:pos2.

    type := currentBlock notNil ifTrue:[#BlockVariable] ifFalse:[#MethodVariable].
    node := VariableNode type: type name: name.
    node startPosition: pos1 endPosition: pos2.
    self rememberVariableElementFor: node from: pos1 to: pos2 assigned: false.

    "Created: / 25-02-2014 / 20:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markMethodArgumentIdentifierFrom:pos1 to:pos2
    | node |

    super markMethodArgumentIdentifierFrom:pos1 to:pos2.

    node := VariableNode methodArgumentNamed:(sourceText string copyFrom: pos1 to: pos2).
    node startPosition: pos1 endPosition: pos2.    
    self rememberVariableElementFor: node from:pos1 to:pos2 assigned:false

    "Created: / 24-07-2010 / 09:25:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 09:27:26 / cg"
    "Modified: / 25-02-2014 / 12:15:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSelector:selectorString from:pos1 to:pos2 receiverNode:aReceiverNode

    | element selectorSymbol |

    "Special hack for Java class references - I would like to have them
     marked specially (and not as an error when the class is not yet loaded -
     the code is correct as JavaClassAccessor loads it lazily"
    (aReceiverNode isJavaPackageReference) ifTrue:[
	self
	    markFrom:pos1 to:pos2
	    withEmphasis:preferences globalClassIdentifierEmphasis
	    color: preferences globalClassIdentifierColor
    ] ifFalse:[
	super markSelector:selectorString from:pos1 to:pos2 receiverNode:aReceiverNode.
    ].

    "don't create symbols for partial typed selectors"
    selectorSymbol := selectorString asSymbolIfInterned.

    element := elements newElementFor: (SelectorNode value: selectorString from: pos1 to: pos2).

    (lastSelectorElement notNil "and:[lastSelectorElement value = selectorString]") ifTrue:[
	lastSelectorElement next: element.
    ].
    elements add: element.
    lastSelectorElement := "(self isValidUnarySelector:tokenType)"false
				ifTrue:[nil]
				ifFalse:[element].

    "Created: / 14-02-2010 / 17:40:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-02-2010 / 19:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-08-2011 / 09:18:21 / cg"
    "Modified: / 19-04-2012 / 09:53:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSelfFrom:pos1 to:pos2
    | node |

    super markSelfFrom:pos1 to:pos2.

    node := SelfNode new.
    node startPosition: pos1 endPosition: pos2.  
    node type: #Self.
    self rememberVariableElementFor: node from:pos1 to:pos2 assigned:false

    "Created: / 21-08-2011 / 09:15:45 / cg"
    "Modified: / 25-02-2014 / 21:56:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSuperFrom:pos1 to:pos2
    | node |

    super markSuperFrom:pos1 to:pos2.

    node := SuperNode new.
    node startPosition: pos1 endPosition: pos2.  
    node type: #Super.
    self rememberVariableElementFor: node from:pos1 to:pos2 assigned:false

    "Created: / 25-02-2014 / 21:57:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markUnknownIdentifierFrom:pos1 to:pos2

    ignoreBadIdentifier == true ifTrue:[ ^ self ].

    super markUnknownIdentifierFrom:pos1 to:pos2

    "Created: / 31.3.1998 / 19:09:26 / cg"
    "Modified: / 31.3.1998 / 19:10:30 / cg"
!

markVariable:v from:pos1 to:pos2 assigned:assigned
    self rememberVariableElementFor:v from:pos1 to:pos2 assigned:assigned.
    super markVariable:v from:pos1 to:pos2 assigned:assigned.

    "Created: / 25-06-2010 / 13:03:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 09:26:30 / cg"
    "Modified: / 25-02-2014 / 14:07:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberVariableElementFor:node from:pos1 to:pos2 assigned:assigned
    |name typeSymbol element prev|

    name := node name.
    typeSymbol := node type.
    prev := (lastVariableElements at:typeSymbol ifAbsentPut:[Dictionary new]) at:name ifAbsent:[nil].
    (prev notNil and:[prev start == pos1]) ifTrue:[
"/        prev assigned:assigned.
        ^ self
    ].

    element := elements newElementFor: node.

    prev notNil ifTrue:[prev next:element].
    (lastVariableElements at:typeSymbol) at:name put:element.

    elements add: element.

    "Created: / 25-02-2014 / 12:13:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkSyntaxHighlighter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

