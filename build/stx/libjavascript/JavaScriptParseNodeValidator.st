"{ Package: 'stx:libjavascript' }"

JavaScriptParseNodeVisitor subclass:#JavaScriptParseNodeValidator
	instanceVariableNames:'stack source'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!


!JavaScriptParseNodeValidator class methodsFor:'validation'!

validate: aParseNode source: source

    ^self basicNew validate: aParseNode source: source

    "Created: / 27-07-2011 / 13:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParseNodeValidator methodsFor:'validation'!

validate: tree source: src

    tree isNil ifTrue:[^self].

    source := src.
    stack := Stack with: nil.

    ^self visit: tree

    "Created: / 27-07-2011 / 13:43:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateNode:node 

    self assert: node startPosition isInteger.
    self assert: node endPosition isInteger.
    node startPosition == -1 ifTrue:[
        self assert: node endPosition == -1.
    ] ifFalse:[
        node endPosition == -1 ifTrue:[
            self assert: node startPosition == -1.
        ].
    ].
    self assert: node parent == stack top

    "Modified: / 23-09-2013 / 11:31:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParseNodeValidator methodsFor:'visiting'!

visit:anObject 
    |accept stmt|

    accept := 
            [:node | 
            stack push:node.
            node acceptVisitor:self.
            stack pop.
            self validateNode:node. ].
    ^ anObject isStatementNode 
        ifTrue:
            [ stmt := anObject.
            [ stmt isNil ] whileFalse:
                    [ accept value:stmt.
                    stmt := stmt nextStatement. ] ]
        ifFalse:[ accept value:anObject. ]

    "Created: / 25-07-2011 / 23:14:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBreakStatementNode: anObject
    self assert: (source copyFrom: anObject startPosition to: anObject startPosition + 'break' size - 1) = 'break'.
    super visitBreakStatementNode: anObject

    "Created: / 23-09-2013 / 11:30:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitContinueStatementNode: anObject
    self assert: (source copyFrom: anObject startPosition to: anObject startPosition + 'continue' size - 1) = 'continue'.
    super visitContinueStatementNode: anObject.

    "Created: / 23-09-2013 / 11:29:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitForStatementNode: anObject 
    self assert: (source copyFrom: anObject startPosition to: anObject startPosition + 2) = 'for'.
    super visitForStatementNode: anObject

    "Created: / 23-09-2013 / 11:28:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitIfStatementNode: anObject 
    self assert: (source copyFrom: anObject startPosition to: anObject startPosition + 1) = 'if'.
    super visitIfStatementNode: anObject

    "Created: / 23-09-2013 / 11:28:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitVariableNode:anObject

    | s e |
    s := anObject startPosition.
    e := anObject endPosition.

    (s notNil and:[e notNil and:[s ~~ -1 and:[e ~~ -1 and:[                       
        #(MethodVariable InstanceVariable) includes: anObject type]]]]) ifTrue:[
            self assert: anObject name = 
                (source copyFrom: anObject startPosition to: anObject endPosition).
    ].

    super visitVariableNode: anObject.

    "Created: / 20-08-2011 / 23:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 13:51:55 / cg"
    "Modified: / 20-09-2013 / 14:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptParseNodeValidator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptParseNodeValidator.st,v 1.3 2013-09-23 11:42:08 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptParseNodeValidator.st,v 1.3 2013-09-23 11:42:08 vrany Exp $'
! !

