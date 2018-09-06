"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

SyntaxHighlighter subclass:#SmalltalkParser
	instanceVariableNames:'errorRecovery error commentPositions commentIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk'
!

!SmalltalkParser class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!SmalltalkParser methodsFor:'accessing'!

commentPositions
    ^ commentPositions
! !

!SmalltalkParser methodsFor:'error handling'!

parseError:message position:startPos to:endPos

    error := ParseErrorNode new 
                errorString: message;
                errorToken:  (token notNil ifTrue:[token asString] ifFalse:[nil]);
                startPosition: startPos endPosition: endPos.
    ^error

    "Created: / 27-11-2011 / 09:35:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-08-2013 / 12:21:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxError:message position:startPos to:endPos

    ^self parseError:message position:startPos to:endPos

    "Created: / 27-11-2011 / 09:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser methodsFor:'initialization'!

initialize
    super initialize.
    errorRecovery := true.
    commentPositions := Array new: 16.
    commentIndex := -1.
    saveComments := true.

    "Created: / 19-09-2013 / 11:25:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-01-2014 / 10:38:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser methodsFor:'parsing'!

blockStatementList
    "parse a blocks statementlist; return a node-tree, nil or #Error"

    |thisStatement prevStatement firstStatement eMsg blockStart lastErrorPosition |

    blockStart := tokenPosition.

    (tokenType == $] ) ifTrue:[^ nil].

    thisStatement := self statement.
    (thisStatement == #Error) ifTrue:[^ #Error].
    firstStatement := thisStatement.
    [tokenType == $] ] whileFalse:[
        (tokenType == $.) ifFalse:[
            (tokenType == #EOF) ifTrue:[
                | errnode |
                errnode := self syntaxError:'missing '']'' in block' position:blockStart to:(source position + 1).
                errnode children: (Array with: firstStatement).
                ^errnode
            ].

            (tokenType == $) ) ifTrue:[
                eMsg := 'missing '']'' or bad '')'' in block'
            ] ifFalse:[
                eMsg := 'missing ''.'' between statements (i.e. ''' , tokenType printString , '''-token unexpected)'
            ].

            lastErrorPosition == tokenPosition ifTrue:[
                "/ Failed to recover, still on the same token, give up.
                ^ error
            ].
            lastErrorPosition := tokenPosition.

            "/ Report error...
            self syntaxError:eMsg position:thisStatement startPosition to:tokenPosition.
            "/ ...an try to recover...

            " Situation 1: ================== 
                number isEven ifTrue:[
                    inst
                    number := number + 1.
                ]
            In this case, the `number` token is already consumed, leaving 
            UnaryNode with selector #number as an expression of last statement. 
            The current token is #:=. Try to recover by setting stream position
            just past of `inst` token"
            (token == #':=' 
                and:[thisStatement expression isMessage 
                    and:[thisStatement expression numArgs == 0
                        and:[thisStatement expression receiver endPosition notNil]]]) ifTrue:[
                            source position: thisStatement expression receiver endPosition.
                            thisStatement expression: thisStatement expression receiver.
                            self nextToken.
                        ]
        ] ifTrue:[
            self nextToken.
        ].

        prevStatement := thisStatement.

        tokenType == $] ifTrue:[
            "
            *** I had a warning here (since it was not defined
            *** in the blue-book; but PD-code contains a lot of
            *** code with periods at the end so that the warnings
            *** became annoying

            self warning:'period after last statement in block'.
            "
            self markBracketAt:tokenPosition.
            ^ self statementListRewriteHookFor:firstStatement
        ].
        thisStatement := self statement.
        (thisStatement == #Error) ifTrue:[^ #Error].
        prevStatement nextStatement:thisStatement
    ].
    self markBracketAt:tokenPosition.
    ^ self statementListRewriteHookFor:firstStatement

    "Created: / 15-08-2013 / 12:16:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-08-2013 / 11:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseExpressionWithSelf:anObject notifying:someOne ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings inNameSpace:aNameSpaceOrNil

    |tree token|

    aNameSpaceOrNil notNil ifTrue:[
        self currentNameSpace:aNameSpaceOrNil
    ].
    self setSelf:anObject.
    self notifying:someOne.
    self ignoreErrors:ignoreErrors.
    self ignoreWarnings:ignoreWarnings.
    token := self nextToken.
    (token == $^) ifTrue:[
        self nextToken.
    ].
    (token == #EOF) ifTrue:[
        ^ nil
    ].
    "/tree := self expression.
    tree := self statementList.    
    (self errorFlag or:[tree == #Error]) ifTrue:[^ #Error].
    ^ tree

    "Created: / 14-12-1999 / 15:11:37 / cg"
    "Created: / 09-07-2011 / 22:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMethod:aString in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings
    "parse a method in a given class.
     Return a parser (if ok), nil (empty) or #Error (syntax).
     The parser can be queried for selector, receiver, args, locals,
     used selectors, modified instvars, referenced classvars etc.
     The noErrors and noWarnings arguments specify if error and warning
     messages should be sent to the Transcript or suppressed."

    self sourceText: aString copy asText.
    ^ super parseMethod:aString in:aClass ignoreErrors:ignoreErrors ignoreWarnings:ignoreWarnings

    "Created: / 03-02-2014 / 16:15:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statement
    "parse a statement; return a node-tree or #Error.

     statement ::= '^' expression
                   | PRIMITIVECODE
                   | expression
    "

    |expr node lnr code pos|

    pos := tokenPosition.

    (tokenType == $^) ifTrue:[
        ^ self returnStatement
    ].

    (tokenType == #Primitive) ifTrue:[
        code := tokenValue.
        node := PrimitiveNode code:code.
        node startPosition: tokenPosition endPosition: source position + 1.
        self nextToken.
        node isOptional ifFalse:[
            hasNonOptionalPrimitiveCode := true
        ].
        hasPrimitiveCode := true.
        ^ node
    ].

    (tokenType == #EOF) ifTrue:[
        currentBlock notNil ifTrue:[
            self syntaxError:'missing '']'' at end of block'.
            errorRecovery ifTrue:[
                tokenType := $].
                ^ error.
            ].
        ] ifFalse:[
            self syntaxError:'period after last statement'.
            errorRecovery ifTrue:[
                tokenType := $..
                ^ error.
            ].  
        ].
        ^ #Error
    ].

    (tokenType == $.) ifTrue:[
        (parserFlags allowEmptyStatements
        or:[parserFlags allowSqueakExtensions == true]) ifTrue:[
            "/ allow empty statement
            self warnAboutEmptyStatement.
            node := StatementNode expression:nil.
            node startPosition:pos.
            ^ node
        ].
    ].

    lnr := tokenLineNr.

    expr := self expression.
    (expr == #Error) ifTrue:[^ #Error].

"/    classToCompileFor notNil ifTrue:[
"/        currentBlock isNil ifTrue:[
"/            expr isPrimary ifTrue:[
"/                self warning:'useless computation - missing ^ ?'
"/            ]
"/        ]
"/    ].

    node := StatementNode expression:expr.
    parserFlags fullLineNumberInfo ifTrue:[node lineNumber:lnr].
    node startPosition:pos.
    ^ node

    "Created: / 19-09-2013 / 11:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser methodsFor:'parsing-expressions'!

keywordExpression
    "parse a keyword-expression; return a node-tree, nil or #Error.

     keywordExpression ::= binaryexpression
                           | { KEYWORD-PART binaryExpression }
    "

    |receiver expr|

    receiver := self binaryExpression.
    (receiver == #Error) ifTrue:[^ #Error].
    (tokenType == #EOF) ifTrue:[^ receiver].
    tokenType == $] ifTrue:[^ receiver].
    tokenType == $) ifTrue:[^ receiver].
    expr := self keywordExpressionFor:receiver.

    "/ expr could be an assignment as well, here
    (ignoreWarnings or:[ignoreErrors]) ifFalse:[
        "/ for a better error message, in case of a missing period in the previous message,
        "/    <expr> <missing period> foo := ...
        "/ would be parsed as unary message foo; detect this here, instead of high up in the calling hierarchy,
        "/ where it is difficult to provide a reasonable error message
        tokenType == #':=' ifTrue:[
            | positionOfPeriod exprLast exprLastParent |

            "/ Find the very last unary send node, Consider:
            "/    x := 2
            "/    y := false
            "/ 
            "/    x := 2 between: 0 and: 10
            "/    y := false  
            "/ 
            "/    x := 2 between: 0 and: self max
            "/    y := false  

            exprLastParent := nil.
            exprLast := expr.
            [ exprLast isMessage and: [ exprLast isUnaryMessage not ] ] whileTrue:[
                exprLastParent := exprLast.
                exprLast := exprLast args last.
            ].
            (exprLast isMessage and: [ exprLast isUnaryMessage ] ) ifTrue:[
                positionOfPeriod := exprLast receiver positionToInsertPeriodForStatementSeparation
            ].
            positionOfPeriod notNil ifTrue:[
                "/Try to recover
                "/ Strip the last unary message whose selector is actually a variable name..."
                exprLastParent notNil ifTrue:[
                    exprLastParent args at: exprLastParent args size put: exprLast receiver.
                ] ifFalse:[
                    "/ no nesting, the expr itself is errorneouts...    
                     expr := expr receiver.
                ].
                expr := ParseErrorNode new
                        startPosition:expr startPosition endPosition: positionOfPeriod - 1;
                        errorString: ('":=" unexpected. Probably missing "." in previous expression.');
                        children: (Array with: expr);
                        yourself.        
                source position: positionOfPeriod.
                tokenType := $.
            ]
        ].
    ].

    ^ expr

    "Created: / 16-09-2013 / 17:23:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2013 / 11:47:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primary
    | nodeOrError |

    nodeOrError := super primary.
    ^ (nodeOrError == #Error and:[error notNil]) ifTrue:[
        error
    ] ifFalse:[
        nodeOrError 
    ]

    "Created: / 19-08-2013 / 14:07:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primary_expression
    "parse a parentized expression primary; return a node-tree, or raise an Error."

    |pos val eMsg|

    pos := tokenPosition.

    self nextToken.
    val := self expression.
    (val == #Error) ifTrue:[^ #Error].
    (tokenType == $) ) ifFalse:[
        | errnode |
        tokenType isCharacter ifTrue:[
            eMsg := 'missing '')'' (i.e. ''' , tokenType asString , ''' unexpected)'.
        ] ifFalse:[
            eMsg := 'missing '')'''.
        ].
        errnode := self syntaxError:eMsg withCRs position:pos to:tokenPosition.
        errnode children: (Array with: val).
        ^ errnode
    ].
    self markParenthesisAt:tokenPosition.
    parenthesisLevel := parenthesisLevel - 1.
    self nextToken.
    (self noAssignmentAllowed:'Invalid assignment to an expression' at:pos) ifFalse:[
        ^ #Error
    ].
    val parenthesized:true.
    ^ val

    "Created: / 15-08-2013 / 15:23:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser methodsFor:'parsing-tweaks'!

_blockStatementList
    "parse a blocks statementlist; return a node-tree, nil or #Error"
    
    |thisStatement prevStatement firstStatement eMsg blockStart|

    blockStart := tokenPosition.
    (tokenType == $]) ifTrue:[
        ^ nil
    ].          
    thisStatement := self statement.
    (thisStatement == #Error) ifTrue:[
        ^ #Error
    ].
    firstStatement := thisStatement.
    [
        tokenType == $] or:[ tokenType == #EOF ]
    ] whileFalse:[
        (tokenType == $.) ifFalse:[   
            (tokenType == #EOF) ifTrue:[
                "    self syntaxError:'missing '']'' in block' position:blockStart to:(source position1Based).
                    ^ #Error."
            ].
            (tokenType == $)) ifTrue:[
                eMsg := 'missing '']'' or bad '')'' in block'
            ] ifFalse:[
                eMsg := 'missing ''.'' between statements (i.e. ''' 
                            , tokenType printString , '''-token unexpected)'
            ].          
             "self syntaxError:eMsg position:blockStart to:tokenPosition.
             ^ #Error"
        ].

        prevStatement := thisStatement.    
        (eMsg isNil ) ifTrue:[              
            self nextToken.
        ].
        tokenType == $] ifTrue:[
            "
             *** I had a warning here (since it was not defined
             *** in the blue-book; but PD-code contains a lot of
             *** code with periods at the end so that the warnings
             *** became annoying

             self warning:'period after last statement in block'."
            self markBracketAt:tokenPosition.
            ^ firstStatement
        ].
        thisStatement := self statement.
        (thisStatement == #Error) ifTrue:[
            ^ #Error
        ].
        prevStatement nextStatement:thisStatement.
        (eMsg notNil) ifTrue:[
            self nextToken.
        ].
        eMsg := nil.
    ].
    self markBracketAt:tokenPosition.
    ^ self statementListRewriteHookFor:firstStatement

    "Created: / 05-08-2013 / 14:56:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_primary
    "parse a primary-expression; return a node-tree, nil or #Error.
     This also cares for namespace-access-pathes."
    
    | node |
    node := super primary.
    "/If an error occured, return the error node"
    node == #Error ifTrue:[
        self assert: error notNil description: 'Parse error occured but no error node.'.
        node := error. error := nil.
    ].
    ^node

    "Created: / 05-08-2013 / 14:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_statementList
    "parse a statementlist; return a node-tree, nil or #Error.
     Statements must be separated by periods.

     statementList ::= <statement>
                       | <statementList> . <statement>"
    
    |thisStatement prevStatement firstStatement periodPos prevExpr|

    thisStatement := self statement.
    (thisStatement == #Error) ifTrue:[
        self breakPoint: #jv.            
        ^ #Error
    ].
    firstStatement := thisStatement.
    [ tokenType == #EOF ] whileFalse:[
        prevExpr := thisStatement expression.
        (prevExpr notNil 
            and:[ prevExpr isMessage and:[ thisStatement isReturnNode not ] ]) 
                ifTrue:[
                    (#( #'=' #'==' ) includes:prevExpr selector) ifTrue:[
                        self 
                            warning:'useless computation - mistyped assignment (i.e. did you mean '':='') ?'
                            position:prevExpr selectorPosition
                    ].
                ].
        periodPos := tokenPosition.

        (tokenType == $. or:[ firstStatement = thisStatement and:[firstStatement expression isErrorNode] ]) ifTrue:[    
            self nextToken.
        ].
        tokenType == $. ifTrue:[
            self emptyStatement.
        ].
        (tokenType == $]) ifTrue:[
            currentBlock isNil ifTrue:[
                
            ] ifFalse:[
                ^ self statementListRewriteHookFor:firstStatement
            ].
        ].
        (tokenType == #EOF) ifTrue:[
            currentBlock notNil ifTrue:[
                "self parseError:''']'' expected (block nesting error)'."
            ] ifFalse:[
                ^ self statementListRewriteHookFor:firstStatement
            ].
        ].
        prevStatement := thisStatement.
        prevStatement isReturnNode ifTrue:[
            self warning:'statements after return' position:tokenPosition
        ].
        thisStatement := self statement.
        (thisStatement == #Error) ifTrue:[
            self breakPoint: #jv.           
            ^ #Error
        ].
        (thisStatement expression isNil or:[thisStatement expression isErrorNode]) ifTrue:[
            self nextToken.
        ].

        prevStatement nextStatement:thisStatement
    ].
    ^ self statementListRewriteHookFor:firstStatement

    "Created: / 05-08-2013 / 14:56:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser methodsFor:'private'!

findNameSpaceWith:varName
    | ns |

    "The super #findNameSpaceWith: checks whether the the global named 'varName' exists,
     if not, returns the current namespace which is then prepended to 'varName'.

     Here we have to deal with uncomplete global names, so trick the caller by returning
     nil if the partially typed global name starts with current namespace prefix."

    classToCompileFor notNil ifTrue:[
        ns := classToCompileFor topNameSpace.
        (varName = ns name) ifTrue:[
            ^ nil
        ]
    ].

    ^ super findNameSpaceWith:varName

    "Created: / 28-07-2013 / 13:49:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-01-2014 / 10:04:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser methodsFor:'syntax coloring'!

markBracketAt:pos

    pos > sourceText size ifTrue:[^self].
    super markBracketAt:pos

    "Created: / 03-04-2011 / 22:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2014 / 23:06:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markFrom:pos1 to:pos2 withEmphasis:fontEmp color:clrIn

    sourceText isNil ifTrue:[^self].
    super markFrom:pos1 to:pos2 withEmphasis:fontEmp color:clrIn

    "Created: / 03-04-2011 / 22:24:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markFrom:pos1 to:pos2 withEmphasis:fontEmp color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr

    sourceText isNil ifTrue:[^self].
    super markFrom:pos1 to:pos2 withEmphasis:fontEmp color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr

    "Created: / 14-02-2012 / 11:08:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser methodsFor:'syntax detection'!

markCommentFrom:pos1 to:pos2
    commentIndex := commentIndex + 2.
    (commentPositions size) < (commentIndex + 1) ifTrue:[ 
        | newPositions |

        newPositions := Array new: commentPositions size + 16.
        newPositions replaceFrom: 1 with: commentPositions.
        commentPositions := newPositions.
    ].
    commentPositions at: commentIndex put: pos1.               
    commentPositions at: commentIndex + 1 put: pos2.

    "Created: / 31-03-2014 / 22:28:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

