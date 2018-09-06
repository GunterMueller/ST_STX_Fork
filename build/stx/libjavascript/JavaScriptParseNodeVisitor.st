"{ Package: 'stx:libjavascript' }"

ParseNodeVisitor subclass:#JavaScriptParseNodeVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!


!JavaScriptParseNodeVisitor methodsFor:'visiting'!

visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    ^ anObject acceptVisitor:self
!

visitAll: aCollection
    aCollection do:[:each | self visit: each ].

    "Created: / 20-09-2013 / 12:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitAndExpressionNode: anObject 
    self visit: anObject expression1.
    self visit: anObject expression2.

    "Modified: / 19-09-2013 / 18:49:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitArrayAccessNode: anObject 
    self visit: anObject arrayExpression.
    self visitAll: anObject indexExpressions.

    "Modified: / 20-09-2013 / 12:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBreakStatementNode: anObject

    "Modified: / 19-09-2013 / 18:52:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitCommaExpression: anObject 
    self visit: anObject expression1.
    self visit: anObject expression2.

    "Modified: / 19-09-2013 / 18:53:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitConditionalNode: anObject 
    self visit: anObject condition.
    self visit: anObject ifExpression.
    self visit: anObject elseExpression.

    "Modified (format): / 19-09-2013 / 19:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitContinueStatementNode: anObject

    "Modified: / 19-09-2013 / 19:02:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitDoWhileStatementNode: anObject 
    self visit: anObject condition.
    self visit: anObject loopStatements.

    "Modified: / 19-09-2013 / 19:03:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitForStatementNode: anObject 
    anObject initExpression notNil ifTrue:[
        self visit: anObject initExpression.
    ].
    anObject condition notNil ifTrue:[
        self visit: anObject condition.
    ].
    anObject incrExpression notNil ifTrue:[
        self visit: anObject incrExpression.
    ].
    self visit: anObject loopStatements.

    "Modified: / 20-09-2013 / 20:21:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitFunctionCallNode: anObject 
    ^ self visitMessageNode: anObject
!

visitIfStatementNode: anObject 
    self visit: anObject condition.
    anObject ifStatements notNil ifTrue:[
        self visit: anObject ifStatements.
    ].
    anObject elseStatements notNil ifTrue:[
        self visit: anObject elseStatements.
    ]

    "Modified: / 20-09-2013 / 17:06:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitImplicitFunctionCallNode: anObject 
    ^ self visitFunctionCallNode: anObject
!

visitIncDecNode: anObject 
    ^ self visit: anObject lValue

    "Modified: / 20-09-2013 / 01:40:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitInnerJavaBlockNode: anObject 
    ^ self visitBlockNode: anObject
!

visitJavaScriptAssignmentNode: anObject 
    ^ self visitAssignmentNode: anObject
!

visitJavaScriptBinaryNode: anObject 
    ^ self visitBinaryNode: anObject
!

visitJavaScriptClassNode: anObject 
    ^ self visitParseNode: anObject
!

visitJavaScriptFunctionNode: anObject 
    anObject statements notNil ifTrue:[
        self visit: anObject statements
    ].

    "Modified: / 23-09-2013 / 10:24:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitJavaScriptInnerFunctionNode: anObject 
    ^ self visitJavaScriptFunctionNode: anObject
!

visitJavaScriptReturnNode: anObject 
    anObject expression notNil ifTrue:[
        self visit: anObject expression.
    ].

    "Modified: / 20-09-2013 / 20:22:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitJavaScriptStatementNode: anObject 
    ^ self visitStatementNode: anObject
!

visitJavaScriptVariableNode: anObject 
    ^ self visitVariableNode: anObject
!

visitNewNode: anObject 
    ^ self visit: anObject classOrFunc

    "Modified: / 20-09-2013 / 01:41:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitOrExpressionNode: anObject 
    self visit: anObject expression1.
    self visit: anObject expression2.

    "Modified: / 20-09-2013 / 01:42:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPostIncDecNode: anObject 
    ^ self visitIncDecNode: anObject
!

visitPreIncDecNode: anObject 
    ^ self visitIncDecNode: anObject
!

visitStatementBlockNode: anObject 
    ^ self visitAll: anObject statements

    "Modified: / 20-09-2013 / 14:29:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitSwitchStatementNode: anObject 
    self visit: anObject switchExpression.
    anObject statementBlocks do:[:valueAndStats |
        valueAndStats key notNil ifTrue:[
            self visit: valueAndStats key.
        ].
        valueAndStats value isCollection ifTrue:[
            self visitAll: valueAndStats value
        ] ifFalse:[
            self visit: valueAndStats value
        ]   
    ]

    "Modified: / 23-09-2013 / 11:08:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitThisNode: anObject 
    ^ self visitSelfNode: anObject
!

visitThrowStatementNode: anObject 
    ^ self visitJavaScriptStatementNode: anObject
!

visitTryCatchStatementNode: anObject 
    self visit: anObject tryBlock.
    anObject errorExpression notNil ifTrue:[
        self visit: anObject errorExpression.
        self visit: anObject catchBlock.
    ].
    anObject finallyBlock notNil ifTrue:[
        self visit: anObject finallyBlock.
    ]

    "Modified: / 23-09-2013 / 10:54:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitTypeOfNode: anObject 
    ^ self visit: anObject expression

    "Modified: / 20-09-2013 / 01:45:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitWhileStatementNode: anObject 
    self visit: anObject condition.
    anObject loopStatements notNil ifTrue:[ 
        self visit: anObject loopStatements
    ].

    "Modified: / 17-09-2014 / 15:00:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParseNodeVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptParseNodeVisitor.st,v 1.4 2014-09-17 14:05:32 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptParseNodeVisitor.st,v 1.4 2014-09-17 14:05:32 vrany Exp $'
! !

