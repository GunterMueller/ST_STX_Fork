"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Object subclass:#ProgramNodeBuilder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler ST-80-compatibility'
!

!ProgramNodeBuilder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    compatibility for applications which build up codetrees,
    knowing internals of ST-80's compiler class hierarchy.
    This classes protocol is not (not meant to be) fully covering
    the corresponding ST-80's classes protocol. It maps ST-80 messages
    to corresponding ST/X messages (as far as possible).

    NO WARRANTY and GUARANTEE; this class may be removed without notice.
"
! !

!ProgramNodeBuilder class methodsFor:'tree building'!

newMessageReceiver: receiverNode selector: selector arguments: arguments
    selector isUnarySelector ifTrue:[
        self assert:(arguments isEmptyOrNil).
        ^ UnaryNode receiver:receiverNode selector: selector args: arguments
    ].
    selector isBinarySelector ifTrue:[
        self assert:(arguments size == 1).
        ^ BinaryNode receiver:receiverNode selector: selector args: arguments
    ].
    self assert:(arguments notEmptyOrNil).
    ^ MessageNode receiver:receiverNode selector: selector args: arguments

    "Created: / 06-08-2006 / 03:02:33 / cg"
    "Modified: / 06-08-2006 / 14:00:47 / cg"
! !

!ProgramNodeBuilder methodsFor:'tree building'!

newBlockBody:statements
    ^ (BlockNode arguments:#() home:nil variables:#()) statements:statements

    "Created: / 06-08-2006 / 23:25:36 / cg"
!

newGlobal:name
    "return a treeNode for a global variable"

    ^ VariableNode globalNamed:name

    "Created: / 06-08-2006 / 01:37:56 / cg"
!

newLiteralValue:aConstantValue
    "return a treeNode for a literal constant"

    aConstantValue isAssociation ifTrue:[
        "/ happens when I am used by ST/80 or VW code, which assumes that a
        "/ global is stored as association (which it is not in ST/X)
        "/ check the caller and rewrite there.
        self halt:'incompatibility warning'
    ].

    ^ ConstantNode value:aConstantValue

    "Modified: / 06-08-2006 / 15:16:04 / cg"
!

newMessageReceiver: receiverNode selector: selector
    ^ self newMessageReceiver: receiverNode selector: selector arguments: #()

    "Created: / 06-08-2006 / 02:59:55 / cg"
    "Modified: / 06-08-2006 / 13:29:33 / cg"
!

newMessageReceiver:arg1 selector:arg2 arguments:arg3
    ^ self class newMessageReceiver:arg1 selector:arg2 arguments:arg3
!

newMethodArgument:name
    "return a treeNode for a method arg"

    ^ VariableNode methodArgumentNamed:name

    "Created: / 06-08-2006 / 01:15:33 / cg"
    "Modified: / 06-08-2006 / 13:29:42 / cg"
!

newMethodLocal:name
    "return a treeNode for a method local"

    ^ VariableNode methodLocalNamed:name

    "Created: / 06-08-2006 / 02:10:52 / cg"
    "Modified: / 06-08-2006 / 13:29:46 / cg"
!

newMethodSelector:sel
    ^ MethodNode new selector:sel

    "Created: / 06-08-2006 / 01:17:16 / cg"
    "Modified: / 06-08-2006 / 13:29:56 / cg"
!

newMethodSelector:sel arguments:argVars temporaries:localVars statements:statementNodes
    ^ MethodNode new
        selector:sel 
        arguments:argVars
        locals:localVars 
        statements:statementNodes.

    "Modified: / 06-08-2006 / 13:30:01 / cg"
!

newParameterVariable:aNode
    ^ Variable name:(aNode name)

    "Created: / 06-08-2006 / 14:23:25 / cg"
!

newReturnValue:anExpressionNode
    "return a treeNode for a method-return"

    ^ ReturnNode expression:anExpressionNode
!

newSelf
    ^ SelfNode new

    "Created: / 06-08-2006 / 13:51:17 / cg"
! !

!ProgramNodeBuilder class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

