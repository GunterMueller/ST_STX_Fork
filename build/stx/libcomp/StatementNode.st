"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

ParseNode subclass:#StatementNode
	instanceVariableNames:'expression nextStatement lineNr'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!StatementNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    node for parse-trees, representing statements
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!StatementNode class methodsFor:'instance creation'!

expression:e
    ^ (self basicNew) expression:e
! !

!StatementNode methodsFor:'accessing'!

expression
    ^ expression
!

expression:something

    expression notNil ifTrue:[expression parent: nil].
    expression := something.
    expression notNil ifTrue:[
        expression parent: self.
        startPosition := expression startPosition.
        endPosition := expression endPosition.
    ].

    "Modified: / 27-07-2011 / 13:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 20:00:56 / cg"
!

isStatement
^true.

    "Created: / 22-02-2011 / 15:04:36 / Jakub <zelenja7@fel.cvut.cz>"
!

last
    "return the last statement in a list"

    |last this|

    "this could be done more elegant - but with lots of recursion"
    last := self.
    this := self.
    [this notNil] whileTrue:[
	last := this.
	this := this nextStatement
    ].
    ^ last
!

lineNumber
    "return lineNr"

    lineNr notNil ifTrue:[^ lineNr].
    expression notNil ifTrue:[ ^ expression lineNumber ].
    nextStatement notNil ifTrue:[^ nextStatement lineNumber].
    ^ nil

    "Created: / 14.5.1998 / 19:31:06 / cg"
!

lineNumber:something
    "set lineNr"

    lineNr := something.

    "Created: / 14.5.1998 / 19:31:11 / cg"
!

lineNumberOfFirstMessage
    |lno|

    lno := self lineNumber.
    self messagesDo:[:m | lno := lno min:(m lineNumber)].
    ^ lno
!

nextStatement
    ^ nextStatement
!

nextStatement:s

    nextStatement notNil ifTrue:[nextStatement parent: nil].
    nextStatement := s.
    nextStatement notNil ifTrue:[nextStatement parent: parent].

    "Modified: / 20-07-2011 / 21:42:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent: aParseNode

    super parent: aParseNode.
    nextStatement notNil ifTrue:[nextStatement parent: aParseNode].

    "Created: / 20-07-2011 / 19:52:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StatementNode methodsFor:'code generation'!

codeAllForSideEffectOn:aStream inBlock:b for:aCompiler
    |thisStatement|

    thisStatement := self.
    [thisStatement notNil] whileTrue:[
        thisStatement codeForSideEffectOn:aStream inBlock:b for:aCompiler.
        thisStatement := thisStatement nextStatement
    ].
!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "generate code for this statement - value not needed"

    expression notNil ifTrue:[
        expression codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ]
!

codeOn:aStream inBlock:b for:aCompiler
    "generate code for this statement"

    expression notNil ifTrue:[
        expression codeOn:aStream inBlock:b for:aCompiler
    ]
! !

!StatementNode methodsFor:'converting'!

asCollectionOfStatements
    "returns a orderedCollection of statements,
     representing the list of which the receiver is the head"

    |coll stat|

    coll := OrderedCollection new.
    stat := self.
    [stat notNil] whileTrue:[
        stat expression isNil ifTrue:[
        ] ifFalse:[
            coll add:stat.
        ].
        stat := stat nextStatement.
    ].
    ^ coll

    "Modified: / 12-09-2011 / 10:02:47 / cg"
! !

!StatementNode methodsFor:'enumerating'!

allNodesDo:aBlock
    "evaluate aBlock for each node in this node and subnodes"

    |s|

    s := self.
    [s notNil] whileTrue:[
        aBlock value:s.
        s allSubNodesDo:aBlock.
        s := s nextStatement
    ].
!

allSubNodesDo:aBlock
    "evaluate aBlock for each subnodes"

    |e|

    e := self expression.
    e notNil ifTrue:[e allNodesDo:aBlock].
!

do:aBlock
    "in st/x, statements is a linked list (not an ordered collection),
     this provides some dialect compatibility (for st2js)"

    | this |

    "/ too stupid: ST/X statements are linked as a list ...

    this := self.
    [this notNil] whileTrue:[
        aBlock value:this.
        this := this nextStatement
    ].
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector sent by this node and subnodes"

    |s e|

    s := self.
    [s notNil] whileTrue:[
        e := s expression.
        e notNil ifTrue:[e messageSelectorsDo:aBlock].
        s := s nextStatement
    ].
!

messagesDo:aBlock
    "evaluate aBlock for each message-node sent by this node and subnodes"

    |s e|

    s := self.
    [s notNil] whileTrue:[
        e := s expression.
        e notNil ifTrue:[e messagesDo:aBlock].
        s := s nextStatement
    ].
!

nodeDo:anEnumerator
    "helper for parse tree walking"

    |stats this expr|

    "/ too stupid: ST/X statements are linked as a list ...

    stats := OrderedCollection new.
    this := self.
    [this notNil] whileTrue:[
        this isReturnNode ifTrue:[
            stats add:this
        ] ifFalse:[
            expr := this expression.
            stats add:(expr ? this).
        ].
        this := this nextStatement
    ].
    ^ anEnumerator doSequence:self temporaries:#() statements:stats

    "Created: 19.6.1997 / 16:45:34 / cg"
    "Modified: 19.6.1997 / 17:06:47 / cg"
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node in this node and subnodes"

    |s e|

    s := self.
    [s notNil] whileTrue:[
        e := s expression.
        e notNil ifTrue:[e variableNodesDo:aBlock].
        s := s nextStatement
    ].
! !

!StatementNode methodsFor:'evaluation'!

evaluateAllIn:anEnvironment
    |lastValue thisStatement|

    "this could be done more elegant - but with lots of recursion"
    thisStatement := self.
    [thisStatement notNil] whileTrue:[
        lastValue := thisStatement evaluateExpressionIn:anEnvironment.
        thisStatement := thisStatement nextStatement
    ].
    ^ lastValue
!

evaluateExpressionIn:anEnvironment
    ^ expression evaluateIn:anEnvironment
!

evaluateIn:anEnvironment
    ^ self evaluateAllIn:anEnvironment.
! !

!StatementNode methodsFor:'printing & storing'!

printAllOn:aStream 
    self printAllOn:aStream indent:4
!

printAllOn:aStream indent:i
    |thisStatement|

    thisStatement := self.
    [thisStatement notNil] whileTrue:[
        aStream spaces:i.
        thisStatement printOn:aStream indent:i.
        thisStatement nextStatement notNil ifTrue:[
            aStream nextPut:$..
            aStream cr.
        ].
        thisStatement := thisStatement nextStatement
    ]
!

printOn:aStream indent:i
    expression notNil ifTrue:[ expression printOn:aStream indent:i ].
! !

!StatementNode methodsFor:'queries'!

collectBlocksInto:aCollection
    |this ex|

    this := self.
    [this notNil] whileTrue:[
        ex := this expression.
        ex notNil ifTrue:[
            ex collectBlocksInto:aCollection.
        ].
        this := this nextStatement
    ].

    "Created: 23.10.1996 / 15:44:13 / cg"
    "Modified: 20.4.1997 / 12:10:18 / cg"
!

containsReturn
    |expr|
    
    ^ (expr := self expression) notNil and:[expr containsReturn]

    "Modified: / 04-07-2017 / 17:02:52 / cg"
!

containsReturnInAnyStatement
    |s|

    s := self.
    [s notNil] whileTrue:[
        s isReturnNode ifTrue:[^ true].
        s containsReturn ifTrue:[^ true].
        s := s nextStatement.
    ].
    ^ false
!

isSimpleConstant
    nextStatement notNil ifTrue:[^ false].
    ^ expression isConstant
!

isSimpleExpression
    nextStatement notNil ifTrue:[^ false].
    ^ expression notNil
!

isSimpleVariable
    nextStatement notNil ifTrue:[^ false].
    ^ expression isVariable
!

listEndsWithReturn
    |thisStatement lastStatement|

    thisStatement := self.
    [thisStatement notNil] whileTrue:[
        lastStatement := thisStatement.
        thisStatement := thisStatement nextStatement
    ].

    ^ lastStatement isReturnNode

    "Created: 19.8.1996 / 14:32:47 / cg"
! !

!StatementNode methodsFor:'testing'!

isStatementNode

    ^ true

    "Created: / 13-06-2011 / 11:26:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2011 / 14:05:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StatementNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitStatementNode:self
! !

!StatementNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

