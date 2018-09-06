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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

SyntaxHighlighter subclass:#SyntaxHighlighter2
	instanceVariableNames:'elements lastVariableElements lastSelectorElement
		ignoreBadIdentifier'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView-Syntax'
!

!SyntaxHighlighter2 class methodsFor:'documentation'!

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
!

documentation
"
    A slightly improved syntax highlighter.

    In addition to the inherited colorization, this one also remembers
    so called 'syntax elements' (variable tokens and selectors) and remembers
    them in a list.
    This can be later used by the codeView to highlight uses of a clicked-on
    variable or a clicked-on selector.
    Also this list could (but is not, at the moment) be used to forward/backward
    search for the next use of some variable.

    [caveat:]
        This code has a smell: there is a lot of code duplication,
        and most can be moved to the superclass. Actually, there is propably no
        reason to have both classes around, so why not integrate all into the superclass.
"
! !

!SyntaxHighlighter2 class methodsFor:'highlighting'!

format:aString parsingWith:aBlock in:aClass elementsInto:elements
    "common code for formatStatementList, formatExpression, ...
     format (recolor) whatever is parsed in aBlock (within the context of a given class).
     Return the text containing font changes and color information.
     As a side effect, put syntax elements into the passed in elements container
     (for element-highlighting in codeView2)"

    "/ cg: I smell a wumpus: I don't think, all of this must be redefined - most is already there in the superclass.

    |parser tree text|

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
        ^ self colorize:text forErrorAtPosition:parser sourceStream position withOriginal:aString
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

    "/ cg: I smell a wumpus: I don't think, all of this must be redefined - most is already there in the superclass.

    |parser tree text|

    aString isNil ifTrue:[^ nil].

    parser := self for:(ReadStream on:aString string) in:aClass.
    parser elements: elements.
    parser ignoreErrors:true.
    parser ignoreWarnings:true.
    parser sourceText:(text := aString string asText).
    "/ use an array here - this can be changed much faster using #at:put:
    text emphasisCollection:(Array new:aString size).

    parser nextToken.
    [
        tree := parser "expression"statementList.
    ] on:ParseError do:[
        tree := #Error
    ].
    "/ now, convert the emphasis-array to a runArray
    text emphasisCollection:(text emphasis asRunArray).

    tree == #Error ifTrue:[
        ^ self colorize:text forErrorAtPosition:parser sourceStream position withOriginal:aString
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

    "/ cg: I smell a wumpus: I don't think, all of this must be redefined - most is already there in the superclass.

    |highlighter tree newText|

    aString isNil ifTrue:[^ nil].

    Error handle:[:ex |
        "/ Transcript showCR:ex description.
        (self parseErrorSignal handles:ex) ifFalse:[
            ex creator isHandled ifTrue:[
                "/ Transcript showCR:'handled'.
                ex reject.
            ].
            "Parse error may happen when re-formatting incomplete code while editing"
            ('SyntaxHighlighter [info]: error during highlight: ' , ex description) infoPrintCR.
            "/ ex suspendedContext fullPrintAll.
        ].
        highlighter notNil ifTrue:[
            ^ self colorize:(newText ? aString) forErrorAtPosition:highlighter sourceStream position withOriginal:aString
        ].
        ^ aString
    ] do:[
        |sourceString|

        sourceString := aString string.
        newText := sourceString asUnicode16String asText.
        "/ use an array here (instead of the RunArray) - this can be changed much faster using #at:put:
        newText emphasisCollection:(Array new:sourceString size).

        highlighter := self for:(ReadStream on:sourceString) in:aClass.
        highlighter elements: elements.
        preferencesOrNil notNil ifTrue:[highlighter preferences:preferencesOrNil].
        "/ highlighter ignoreErrors:true.
        highlighter ignoreWarnings:true.
        highlighter sourceText:newText.

        tree := highlighter parseMethod.
        newText := highlighter sourceText.  "/ might have changed identity
        "/ now, convert the emphasis-array to a runArray
        newText emphasisCollection:(newText emphasis asRunArray).

        tree == #Error ifTrue:[
            ^ self colorize:newText forErrorAtPosition:highlighter sourceStream position withOriginal:aString
        ].
        ^ newText
    ]

    "
     self formatMethod:'foo
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
        format:aString parsingWith:[:parser | parser parseMethodBody]
        in:aClass elementsInto:elements

    "
     self
        formatStatements:'(1 + 2) max:5. 1 + 2' 
        in:UndefinedObject
        elementsInto:(OrderedCollection new).
    "

    "Created: / 22-02-2016 / 21:09:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyntaxHighlighter2 methodsFor:'accessing'!

elements
    ^ elements
!

elements:aParseTreeIndexCollection
    "the element collection, to collect variables, selectors etc. into"

    elements := aParseTreeIndexCollection.

    "Modified (comment): / 21-08-2011 / 09:13:31 / cg"
!

tree: aParseNode
    super tree: aParseNode.
    elements tree: aParseNode

    "Created: / 16-02-2012 / 09:56:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyntaxHighlighter2 methodsFor:'initialization'!

initialize

    super initialize.
    elements := ParseTreeIndex new.
    lastVariableElements := Dictionary new.

    "Created: / 14-02-2010 / 13:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 09:37:35 / cg"
    "Modified: / 16-02-2012 / 09:59:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyntaxHighlighter2 methodsFor:'parsing-expressions'!

_binaryExpressionFor:receiverArg
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
            self clearErrorFlag. "ok, user wants it - so he'll get it"
            expr := BinaryNode receiver:receiver selector:sel arg:arg fold:nil.
        ].
        expr lineNumber:lno.
        expr selectorPosition:pos1.

        self checkPlausibilityOf:expr from:pos1 to:pos2.
        parseForCode ifFalse:[
            self rememberSelectorUsed:sel receiver:receiver
        ].
        receiver := expr.   "/ for next message
    ].
    ^ receiver

    "Modified: / 09-01-1998 / 19:05:18 / stefan"
    "Modified: / 14-02-2010 / 17:54:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2012 / 10:46:49 / cg"
    "Created: / 16-02-2012 / 21:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_keywordExpressionFor:receiverArg
    "parse a keyword-expression; return a node-tree, nil or #Error.

     keywordExpression ::= binaryexpression
                           | { KEYWORD-PART binaryExpression }
    "

    |expr receiver sel arg args posR1 posR2 pos1 pos2 lno positions constVal|

    receiver := receiverArg.
    posR1 := tokenPosition.
    (tokenType == #Keyword) ifFalse:[^ receiver].

    pos1 := posR2 := tokenPosition.
    pos2 := tokenPosition + tokenName size - 1.
    positions := OrderedCollection with:(pos1 to:pos2).
    sel := tokenName.
    lno := tokenLineNr.
    self nextToken.
    arg := self binaryExpression.
    (arg == #Error) ifTrue:[^ #Error].
    args := Array with:arg.
    [tokenType == #Keyword] whileTrue:[
        sel := sel , tokenName.
        pos2 := tokenPosition + tokenName size - 1.
        positions add:(tokenPosition to:pos2).
        self nextToken.
        arg := self binaryExpression.
        (arg == #Error) ifTrue:[^ #Error].
        args := args copyWith:arg.
    ].

    positions do:[:p |
        self markSelector:sel from:p start to:p stop receiverNode:receiver.
    ].
    lastSelectorElement := nil.
    sel := self selectorCheck:sel for:receiver positions:positions.

    ignoreWarnings ifFalse:[
        (Class definitionSelectors includes:sel) ifTrue:[
            (receiver isVariable and:[receiver isUndeclared]) ifTrue:[
                "this is not an error - the undefined class may be loaded after this code!!"
                self warning:('as yet undefined superclass: ' , receiver name) position:pos1 to:pos2.
            ].
        ].
    ].

    expr := MessageNode receiver:receiver selector:sel args:args fold:foldConstants.
    expr isErrorNode ifTrue:[
        self parseError:(expr errorString) position:pos1 to:pos2.
        self clearErrorFlag. "ok, user wants it - so he'll get it"
        expr := MessageNode receiver:receiver selector:sel args:args fold:nil.
    ].
    expr lineNumber:lno.
    self checkPlausibilityOf:expr from:pos1 to:pos2.
    parseForCode ifFalse:[
        self rememberSelectorUsed:sel receiver:receiver
    ].

"/        (contextToEvaluateIn isNil and:[selfValue isNil]) ifTrue:[    "/ do not check this for doits
"/            receiver isSuper ifTrue:[
"/                sel ~= selector ifTrue:[
"/                    self warnCommonMistake:'possible bad super message (selector should be same as in current method) ?'
"/                                  position:posR1 to:posR2-1
"/                ].
"/            ].
"/        ].
"/

    (sel = #ifTrue: or:[sel = #ifFalse: or:[sel = #ifTrue:ifFalse: or:[sel = #ifFalse:ifTrue:]]]) ifTrue:[
        (expr receiver withConstantValueDo:[:val | constVal := val]) ifTrue:[
            |indexOfArgNotExecuted|

            "/ receiver evaluates to a constant
            constVal == true ifTrue:[
                (sel startsWith: #ifFalse:) ifTrue:[
                    indexOfArgNotExecuted := 1.
                ] ifFalse:[
                    indexOfArgNotExecuted := 2.
                ]
            ].
            constVal == false ifTrue:[
                (sel startsWith: #ifTrue:) ifTrue:[
                    indexOfArgNotExecuted := 1.
                ] ifFalse:[
                    indexOfArgNotExecuted := 2.
                ]
            ].
            indexOfArgNotExecuted == 2 ifTrue:[
                args size == 1 ifTrue:[ indexOfArgNotExecuted := nil]
            ].

            indexOfArgNotExecuted notNil ifTrue:[
                |argIsNotExecuted|

                "/ self warning:'receiver is constant; arg',indexOfArgNotExecuted printString,' is never executed' position:pos1 to:tokenPosition.
                argIsNotExecuted := expr args at:indexOfArgNotExecuted.
                argIsNotExecuted realNode isBlockNode ifTrue:[
                    self markCommentFrom:argIsNotExecuted startPosition to:argIsNotExecuted endPosition.
                ].
            ].
        ].
    ].

    (ignoreErrors or:[ignoreWarnings]) ifFalse:[
        (sel = #and: or:[sel = #or:]) ifTrue:[
            expr arg1 isBlock ifFalse:[
                (expr arg1 isVariable
                and:[ (expr arg1 name asLowercase includesString:'block')]) ifFalse:[
                    self warnCommonMistake:'(possible common mistake) missing block brackets ?'
                              position:pos2+1 to:tokenPosition-1
                ]
            ].
            ^ expr.
        ].

        (sel = #whileTrue: or:[sel = #whileFalse:]) ifTrue:[
            expr receiver isBlock ifFalse:[
                (expr receiver isVariable
                and:[ (expr receiver name asLowercase includesString:'block')]) ifFalse:[
                    self warnCommonMistake:'(possible common mistake) missing block brackets ?'
                              position:pos1 to:pos2
                ]
            ].
            ^ expr.
        ].

        (sel = #ifTrue: or:[sel = #ifFalse:]) ifTrue:[
            expr receiver isMessage ifTrue:[
                (expr receiver selector = #whileTrue or:[expr receiver selector = #whileFalse]) ifTrue:[
                    self warnCommonMistake:'strange receiver expression'
                              position:pos1 to:pos2
                ].
            ].
            ^ expr
        ].
    ].

    ^ expr.

    "Modified: / 14-02-2010 / 17:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2012 / 10:47:01 / cg"
    "Created: / 16-02-2012 / 21:54:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_unaryExpressionFor:receiverArg
    "parse a unary-expression; return a node-tree, nil or #Error"

    |receiver expr sel pos pos2 lNr arguments|

    receiver := receiverArg.
    (receiver == #Error) ifTrue:[^ #Error].

    [ self isValidUnarySelector:tokenType ] whileTrue:[
        pos := tokenPosition.
        pos2 := pos + tokenName size - 1.
        lNr := tokenLineNr.
        sel := tokenName.

        self markSelector:sel from:pos to:pos2 receiverNode:receiver.
        lastSelectorElement := nil.

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
                    self clearErrorFlag. "ok, user wants it - so he'll get it"
                    expr := MessageNode receiver:receiver selector:sel args:arguments fold:nil.
                ].
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
            self clearErrorFlag. "ok, user wants it - so he'll get it"
            expr := UnaryNode receiver:receiver selector:sel fold:nil.
        ].
        expr lineNumber:lNr.

        self checkPlausibilityOf:expr from:pos to:pos2.
        parseForCode ifFalse:[
            self rememberSelectorUsed:sel receiver:receiver
        ].

        receiver := expr.   "/ for next message
    ].
    ^ receiver

    "Modified: / 14-02-2010 / 17:56:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2012 / 10:47:37 / cg"
    "Created: / 16-02-2012 / 21:54:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

binaryExpression
    | node savedLastSelectorElement |

    savedLastSelectorElement := lastSelectorElement.
    lastSelectorElement := nil.
    node := super binaryExpression.
    (lastSelectorElement notNil and:[node ~~ #Error and:[node isMessage]]) ifTrue:[
	lastSelectorElement node parent: node.
    ].
    lastSelectorElement := savedLastSelectorElement.
    ^node

    "Modified: / 19-01-2000 / 16:22:16 / cg"
    "Created: / 16-02-2012 / 21:56:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

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
            self clearErrorFlag. "ok, user wants it - so he'll get it"
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
            lastSelectorElement := lastSelectorElement previousElement.
        ].
    ].
    lastSelectorElement := savedLastSelectorElement.
    ^node

    "Modified: / 19-01-2000 / 16:22:16 / cg"
    "Modified: / 16-02-2012 / 23:39:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keywordExpressionFor:receiverArg
    "parse a keyword-expression; return a node-tree, nil or #Error.

     keywordExpression ::= binaryexpression
                           | { KEYWORD-PART binaryExpression }
    "

    |expr receiver sel arg args posR1 posR2 pos1 pos2 lno positions constVal|

    receiver := receiverArg.
    posR1 := tokenPosition.
    (tokenType == #Keyword) ifFalse:[^ receiver].

    pos1 := posR2 := tokenPosition.
    pos2 := tokenPosition + tokenName size - 1.
    positions := OrderedCollection with:(pos1 to:pos2).
    sel := tokenName.
    lno := tokenLineNr.
    self nextToken.
    arg := self binaryExpression.
    (arg == #Error) ifTrue:[^ #Error].
    args := Array with:arg.
    [tokenType == #Keyword] whileTrue:[
        sel := sel , tokenName.
        pos2 := tokenPosition + tokenName size - 1.
        positions add:(tokenPosition to:pos2).
        self nextToken.
        arg := self binaryExpression.
        (arg == #Error) ifTrue:[^ #Error].
        args := args copyWith:arg.
    ].

    positions do:[:p |
        self markSelector:sel from:p start to:p stop receiverNode:receiver.
    ].
    lastSelectorElement := nil.
    sel := self selectorCheck:sel for:receiver positions:positions.

    ignoreWarnings ifFalse:[
        (Class definitionSelectors includes:sel) ifTrue:[
            (receiver isVariable and:[receiver isUndeclared]) ifTrue:[
                "this is not an error - the undefined class may be loaded after this code!!"
                self warning:('as yet undefined superclass: ' , receiver name) position:pos1 to:pos2.
            ].
        ].
    ].

    expr := MessageNode receiver:receiver selector:sel args:args fold:foldConstants.
    expr isErrorNode ifTrue:[
        self parseError:(expr errorString) position:pos1 to:pos2.
        self clearErrorFlag. "ok, user wants it - so he'll get it"
        expr := MessageNode receiver:receiver selector:sel args:args fold:nil.
    ].
    expr lineNumber:lno.
    self checkPlausibilityOf:expr from:pos1 to:pos2.

"/        (contextToEvaluateIn isNil and:[selfValue isNil]) ifTrue:[    "/ do not check this for doits
"/            receiver isSuper ifTrue:[
"/                sel ~= selector ifTrue:[
"/                    self warnCommonMistake:'possible bad super message (selector should be same as in current method) ?'
"/                                  position:posR1 to:posR2-1
"/                ].
"/            ].
"/        ].
"/

    (sel = #ifTrue: or:[sel = #ifFalse: or:[sel = #ifTrue:ifFalse: or:[sel = #ifFalse:ifTrue:]]]) ifTrue:[
        (expr receiver withConstantValueDo:[:val | constVal := val]) ifTrue:[
            |indexOfArgNotExecuted|

            "/ receiver evaluates to a constant
            constVal == true ifTrue:[
                (sel startsWith: #ifFalse:) ifTrue:[
                    indexOfArgNotExecuted := 1.
                ] ifFalse:[
                    indexOfArgNotExecuted := 2.
                ]
            ].
            constVal == false ifTrue:[
                (sel startsWith: #ifTrue:) ifTrue:[
                    indexOfArgNotExecuted := 1.
                ] ifFalse:[
                    indexOfArgNotExecuted := 2.
                ]
            ].
            indexOfArgNotExecuted == 2 ifTrue:[
                args size == 1 ifTrue:[ indexOfArgNotExecuted := nil]
            ].

            indexOfArgNotExecuted notNil ifTrue:[
                |argIsNotExecuted|

                "/ self warning:'receiver is constant; arg',indexOfArgNotExecuted printString,' is never executed' position:pos1 to:tokenPosition.
                argIsNotExecuted := expr args at:indexOfArgNotExecuted.
                argIsNotExecuted realNode isBlockNode ifTrue:[
                    self markCommentFrom:argIsNotExecuted startPosition to:argIsNotExecuted endPosition.
                ].
            ].
        ].
    ].

    (ignoreErrors or:[ignoreWarnings]) ifFalse:[
        (sel = #and: or:[sel = #or:]) ifTrue:[
            expr arg1 isBlock ifFalse:[
                (expr arg1 isVariable
                and:[ (expr arg1 name asLowercase includesString:'block')]) ifFalse:[
                    self warnCommonMistake:'(possible common mistake) missing block brackets ?'
                              position:pos2+1 to:tokenPosition-1
                ]
            ].
            ^ expr.
        ].

        (sel = #whileTrue: or:[sel = #whileFalse:]) ifTrue:[
            expr receiver isBlock ifFalse:[
                (expr receiver isVariable
                and:[ (expr receiver name asLowercase includesString:'block')]) ifFalse:[
                    self warnCommonMistake:'(possible common mistake) missing block brackets ?'
                              position:pos1 to:pos2
                ]
            ].
            ^ expr.
        ].

        (sel = #ifTrue: or:[sel = #ifFalse:]) ifTrue:[
            expr receiver isMessage ifTrue:[
                (expr receiver selector = #whileTrue or:[expr receiver selector = #whileFalse]) ifTrue:[
                    self warnCommonMistake:'strange receiver expression'
                              position:pos1 to:pos2
                ].
            ].
            ^ expr
        ].
    ].

    ^ expr.

    "Modified: / 14-02-2010 / 17:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2012 / 10:47:01 / cg"
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
                    self clearErrorFlag. "ok, user wants it - so he'll get it"
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
            self clearErrorFlag. "ok, user wants it - so he'll get it"
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

!SyntaxHighlighter2 methodsFor:'syntax detection'!

markBlockArgumentIdentifierFrom:pos1 to:pos2
    "in addition to marking, remember the variable reference"

    | node |

    super markBlockArgumentIdentifierFrom:pos1 to:pos2.

    node := VariableNode blockArgumentNamed:(sourceText string copyFrom: pos1 to: pos2).
    node block:currentBlock.
    self rememberVariableElementFor: node from:pos1 to:pos2 assigned:false
!

markLocalVariableDeclaration: name from:pos1 to:pos2
    "in addition to marking, remember the variable reference"

    | type node |

    super markLocalVariableDeclaration: name from:pos1 to:pos2.

    type := currentBlock notNil ifTrue:[#BlockVariable] ifFalse:[#MethodVariable].
    node := VariableNode type: type name: name.
    node block:currentBlock. "/ which is nil for method locals
    self rememberVariableElementFor: node from: pos1 to: pos2 assigned: false.

    "Created: / 25-02-2014 / 20:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markMethodArgumentIdentifierFrom:pos1 to:pos2
    "in addition to marking, remember the variable reference"

    | node |

    super markMethodArgumentIdentifierFrom:pos1 to:pos2.

    node := VariableNode methodArgumentNamed:(sourceText string copyFrom: pos1 to: pos2).
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

    element := elements newElementFor: (SelectorNode value: selectorSymbol ? selectorString from: pos1 to: pos2).

    (lastSelectorElement notNil "and:[lastSelectorElement value = selectorString]") ifTrue:[
        lastSelectorElement nextElement: element.
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
    "in addition to marking, remember the variable reference"

    | node |

    super markSelfFrom:pos1 to:pos2.

    node := SelfNode new.
    node type: #Self.
    self rememberVariableElementFor: node from:pos1 to:pos2 assigned:false

    "Created: / 21-08-2011 / 09:15:45 / cg"
    "Modified: / 25-02-2014 / 21:56:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSuperFrom:pos1 to:pos2
    "in addition to marking, remember the variable reference"

    | node |

    super markSuperFrom:pos1 to:pos2.

    node := SuperNode new.
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
    |name typeSymbol key element prev dict|

    node startPosition: pos1 endPosition: pos2.    

    name := node name.
    typeSymbol := key := node type.

    (typeSymbol == #BlockArg or:[typeSymbol == #BlockVariable]) ifTrue:[
        key := (typeSymbol -> currentBlock "node block")
    ].

    dict := lastVariableElements at:key ifAbsentPut:[Dictionary new].
    prev := dict at:name ifAbsent:[nil].
    (prev notNil and:[prev start == pos1]) ifTrue:[
        "/ prev assigned:assigned.
        ^ self
    ].

    element := elements newElementFor: node.

    prev notNil ifTrue:[prev nextElement:element].
    dict at:name put:element.

    elements add: element.

    "Created: / 25-02-2014 / 12:13:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyntaxHighlighter2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

