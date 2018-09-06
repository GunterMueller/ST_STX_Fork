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

ByteCodeCompiler subclass:#ByteCodeCompilerWithBreakpointSupport
	instanceVariableNames:'breakpoints'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Debugging'
!

!ByteCodeCompilerWithBreakpointSupport class methodsFor:'documentation'!

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
    I'm an experimental compiler class that supports
    breakpoints. Once tested, the code will be merged
    to ByteCodeCompiler.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ByteCodeCompilerWithBreakpointSupport methodsFor:'adding breakpoint'!

possiblyWrapABreakPointAround:aBlock
    "refactored Jan's original code; changed to not wrap an already wrapped expression"

    | expr bpnt tokenPositionBefore tokenLineNrBefore |

    tokenPositionBefore := tokenPosition ? source position.
    tokenLineNrBefore := tokenLineNr.

    "/ find the very first breakpoint, which is right after the
    "/ current line start, and remove it from the breakpoints collection,
    "/ incl. all before. This removes breakpoints on empty lines or inside strings etc.
    [
        breakpoints notEmpty
        and:[(breakpoints first position ? 0) <= tokenPositionBefore]
    ] whileTrue:[
        bpnt := breakpoints removeFirst
    ].

    expr := aBlock value.
    expr == #Error ifTrue:[^expr].
    bpnt isNil ifTrue:[^expr].
    expr isBreakPointNode ifTrue:[^expr].
    tokenPositionBefore = tokenPosition ifTrue:[
        "/ nothing scanned - happens with unaryExpression which does not find anything,
        "/ but returns due to a ')' or ']' token.
        ^expr
    ].

    bpnt isReached:true.

    "/ Transcript show:'adding breakpoint '; show:bpnt; show:' before: '; showCR:expr.

    ^ BreakpointNode new
        breakpoint: bpnt;
        expression: expr;
        lineNumber:(bpnt line ? tokenLineNrBefore);
        yourself

    "Created: / 05-07-2011 / 21:11:19 / cg"
    "Modified: / 25-07-2017 / 12:37:24 / stefan"
!

removeMissedBreakpointsBefore:aPosition
    [
        breakpoints notEmpty
        and:[breakpoints first position < aPosition]
    ] whileTrue:[
        breakpoints removeFirst
    ].

    "Created: / 05-07-2011 / 23:13:25 / cg"
! !

!ByteCodeCompilerWithBreakpointSupport methodsFor:'parsing-expressions'!

binaryExpression
    ^ self possiblyWrapABreakPointAround:[super binaryExpression]

    "Created: / 05-07-2011 / 23:08:43 / cg"
!

binaryExpressionFor:aReceiver
    ^ self possiblyWrapABreakPointAround:[super binaryExpressionFor:aReceiver]

    "Created: / 05-07-2011 / 21:10:53 / cg"
!

block
    |blockNode|

    self removeMissedBreakpointsBefore:source position.
    blockNode := super block.
    blockNode ~~ #Error ifTrue:[
        self removeMissedBreakpointsBefore:blockNode endPosition+2.
    ].
    ^ blockNode

    "Created: / 05-07-2011 / 22:56:19 / cg"
!

expression
    ^ self possiblyWrapABreakPointAround:[super expression]

    "Created: / 16-06-2011 / 14:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 21:11:38 / cg"
!

primary
    ^ self possiblyWrapABreakPointAround:[super primary]

    "Created: / 16-06-2011 / 14:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 21:11:38 / cg"
    "Created: / 05-07-2011 / 23:05:23 / cg"
!

unaryExpression
    ^ self possiblyWrapABreakPointAround:[super unaryExpression]

    "Created: / 05-07-2011 / 23:08:54 / cg"
!

unaryExpressionFor:aReceiver
    ^ self possiblyWrapABreakPointAround:[super unaryExpressionFor:aReceiver]

    "Created: / 05-07-2011 / 21:15:30 / cg"
! !

!ByteCodeCompilerWithBreakpointSupport methodsFor:'private'!

breakpoints:aCollection
    breakpoints := aCollection copy sort:[:a :b|a position < b position].

    "Created: / 16-06-2011 / 14:35:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 05-07-2011 / 21:37:28 / cg"
!

methodClass
    ^ methodClass ? MethodWithBreakpoints

    "Created: / 22-07-2013 / 15:54:19 / cg"
!

notifying: anObject
    super notifying: anObject.
    anObject notNil ifTrue:[
        breakpoints isNil ifTrue:[
            self breakpoints:(anObject perform: #breakpoints ifNotUnderstood:#()).
        ]
    ]

    "Created: / 16-06-2011 / 14:35:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 21:48:37 / cg"
! !

!ByteCodeCompilerWithBreakpointSupport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

