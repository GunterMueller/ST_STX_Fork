"
 COPYRIGHT (c) 2004 by eXept Software AG
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

Object subclass:#ProgramNodeEnumerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!ProgramNodeEnumerator class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    This is a pure mimicri class.
    It is not used by ST/X, but provided to support limited
    compatibility for applications which walk codetrees,
    knowing internals of ST-80's compiler class hierarchy.
    This classes protocol is not (not meant to be) fully covering
    the corresponding ST-80's classes protocol. It maps ST-80 messages
    to corresponding ST/X messages (as far as possible).

    This class was added to allow for the PD goody CodeReview to be filed
    into ST/X.

    NO WARRANTY and GUARANTEE; this class may be removed without notice.
"

! !

!ProgramNodeEnumerator class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: 19.6.1997 / 16:52:06 / cg"
! !

!ProgramNodeEnumerator methodsFor:'enumeration callbacks'!

doAssignment:aNode variable:var value:val
    self doNode:val.
!

doBlock:aNode arguments:args body:seq
    seq notNil ifTrue:[
        self doNode:seq.
    ]
!

doCascade:aNode receiver:rcvr messages:msgs
    msgs do:[:eachMessage | 
        self doNode:eachMessage
    ].
!

doLiteral:aNode value:lit
!

doMessage:aNode receiver:rcvr selector:sel arguments:args
    self doNode:rcvr.
    args do:[:eachArg |
        self doNode:eachArg
    ].
!

doMethod:aNode selector:sel primitive:prim block:block
    ^ self subclassResponsibility

    "Created: 19.6.1997 / 16:50:45 / cg"
    "Modified: 19.6.1997 / 16:52:54 / cg"
!

doParameter:aNode variable:var type:type
    ^ self subclassResponsibility

    "Created: 19.6.1997 / 16:50:50 / cg"
    "Modified: 19.6.1997 / 16:53:01 / cg"
!

doPrimitive:aNode code:code primitiveIndex:primNumber
!

doReturn:aNode value:value
    self doNode:value
!

doSequence:aNode temporaries:temps statements:stats
    stats do:[:each | self doNode:each ].
!

doVariable:aNode name:nameString
! !

!ProgramNodeEnumerator methodsFor:'private'!

collectNodes:nodeList
    ^ nodeList collect:[:node | self doNode:node]

    "Created: 19.6.1997 / 16:51:31 / cg"
    "Modified: 19.6.1997 / 16:53:32 / cg"
!

doNode:aNode
    ^ aNode nodeDo:self

    "Modified: 19.6.1997 / 16:53:47 / cg"
!

doNodeList:firstNode
    |node|

    node := firstNode.
    [ node notNil ] whileTrue:[
        self doNode:node.
        node := node nextStatement.
    ]
!

doNodes:nodeList
    ^ nodeList do:[:node | self doNode:node]

    "Created: 19.6.1997 / 16:51:41 / cg"
    "Modified: 19.6.1997 / 16:53:55 / cg"
!

doType:aType
    ^ aType

    "Modified: 19.6.1997 / 16:54:05 / cg"
! !

!ProgramNodeEnumerator class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

