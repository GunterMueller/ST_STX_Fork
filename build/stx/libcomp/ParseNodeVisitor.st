"
 COPYRIGHT (c) 2006 by eXept Software AG
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

Object subclass:#ParseNodeVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ParseNodeVisitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    a whitebox expandable abstract parsenode visitor.
    Subclasses should redefine those acceptXXX methods, in which they are interested.
"    
! !

!ParseNodeVisitor methodsFor:'visiting'!

visit:anObject 

    | stmt |

    ^anObject isStatementNode 
        ifTrue:[
            stmt := anObject.
            [ stmt isNil ] whileFalse:[
                stmt acceptVisitor:self.
                stmt := stmt nextStatement.
            ]
        ] 
        ifFalse:[
            anObject acceptVisitor: self.
        ]

    "Modified: / 25-07-2011 / 22:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitAssignmentNode:anObject 

    self visit: anObject variable.
    self visit: anObject expression.

    "Modified: / 25-07-2011 / 22:30:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBinaryNode:anObject 

    ^self visitMessageNode: anObject

    "Modified: / 25-07-2011 / 22:30:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBlockNode:anObject 

    anObject statements ifNotNil:[
        self visit: anObject statements
    ].

    "Modified: / 25-07-2011 / 22:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitCascadeNode:anObject 

    self visitMessageNode: anObject.

    "Modified: / 25-07-2011 / 22:37:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitConstantNode:anObject

    "Modified: / 25-07-2011 / 22:41:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitECompletionConstantNode:anObject 
    "dispatched back from the visited eCompletionConstantNode-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitMessageNode:anObject 

    self visit: anObject receiver.
    anObject arguments do:[:arg|
        self visit: arg.
    ]

    "Modified: / 25-07-2011 / 22:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitObject:anObject 
    "dispatched back from the visited objects (visitor pattern)"

    "general fallBack - please change as required"

    self halt:'not yet implemented'
!

visitParseErrorNode:anObject

    "Modified: / 25-07-2011 / 22:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPrimitiveNode:anObject

    "Modified: / 25-07-2011 / 22:38:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitReturnNode:anObject 
    self visit: anObject expression.
!

visitSelfNode:anObject 
    "/ to be redefined in subclasses
!

visitStatementNode:anObject 
    |expr|

    (expr := anObject expression) notNil ifTrue:[
        self visit: expr.
    ]
!

visitSuperNode:anObject 
    "/ to be redefined in subclasses
!

visitUnaryNode:anObject 
    ^self visitMessageNode: anObject
!

visitVariableNode:anObject 
    "/ to be redefined in subclasses
! !

!ParseNodeVisitor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

