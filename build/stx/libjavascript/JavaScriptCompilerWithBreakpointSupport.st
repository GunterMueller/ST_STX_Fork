"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

JavaScriptCompiler subclass:#JavaScriptCompilerWithBreakpointSupport
	instanceVariableNames:'breakpoints'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptCompilerWithBreakpointSupport class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by eXept Software AG
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
    I'm an experimental compiler class that supports breakpoints. 
    Once tested, the code might be merged to JavaScriptCompiler.

    [author:]
        code stolen from BytecodeCompilerWithBreakpointSupport

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaScriptCompilerWithBreakpointSupport methodsFor:'adding breakpoint'!

possiblyWrapABreakPointAround:aBlock
    "refactored Jan's original code; changed to not wrap an already wrapped expression"

    | expr bpnt tokenPositionBefore tokenLineNrBefore |

    breakpoints isEmptyOrNil ifTrue:[ ^ aBlock value].

    tokenPositionBefore := tokenPosition ? source position.
    tokenLineNrBefore := tokenLineNr.

    "/ find the very first breakpoint, which is right after the
    "/ current line start, and remove it from the breakpoints collection,
    "/ incl. all before. This removes breakpoints on empty lines or inside strings etc.
    [
        breakpoints notEmpty
        and:[breakpoints first position < tokenPositionBefore]
    ] whileTrue:[
        bpnt := breakpoints removeFirst
    ].

    expr := aBlock value.

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
!

possiblyWrapABreakPointBefore:aBlock
    "refactored Jan's original code; changed to not wrap an already wrapped expression"

    | stat bpnt tokenPositionBefore tokenLineNrBefore |

    breakpoints isEmptyOrNil ifTrue:[ ^ aBlock value].

    tokenPositionBefore := tokenPosition ? source position.
    tokenLineNrBefore := tokenLineNr.

    "/ find the very first breakpoint, which is right after the
    "/ current line start, and remove it from the breakpoints collection,
    "/ incl. all before. This removes breakpoints on empty lines or inside strings etc.
    [
        breakpoints notEmpty
        and:[breakpoints first position < tokenPositionBefore]
    ] whileTrue:[
        bpnt := breakpoints removeFirst
    ].

    stat := aBlock value.
    bpnt isNil ifTrue:[^stat].
    stat isNil ifTrue:[^stat].

    ((stat isKindOf:JavaScriptParser::StatementBlockNode)
        and:[stat statements first isBreakPointNode]) ifTrue:[^stat].

    tokenPositionBefore = tokenPosition ifTrue:[
        "/ nothing scanned - happens with unaryExpression which does not find anything,
        "/ but returns due to a ')' or ']' token.
        ^stat
    ].

    bpnt isReached:true.

    "/ Transcript show:'adding breakpoint '; show:bpnt; show:' before: '; showCR:expr.

    ^ JavaScriptParser::StatementBlockNode new
        statements:{
                BreakpointNode new
                    breakpoint: bpnt;
                    expression: nil;
                    lineNumber:(bpnt line ? tokenLineNrBefore);
                    yourself
                .
                stat
        }

    "Created: / 22-07-2013 / 15:42:08 / cg"
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

!JavaScriptCompilerWithBreakpointSupport methodsFor:'parsing-expressions'!

addExpression
    breakpoints isEmptyOrNil ifTrue:[ ^ super addExpression].
    ^ self possiblyWrapABreakPointAround:[super addExpression]

    "Created: / 22-07-2013 / 15:36:03 / cg"
!

block
    |blockNode|

    self removeMissedBreakpointsBefore:source position.
    blockNode := super block.
    self removeMissedBreakpointsBefore:blockNode endPosition+2.
    ^ blockNode

    "Created: / 05-07-2011 / 22:56:19 / cg"
!

expression
    breakpoints isEmptyOrNil ifTrue:[ ^ super expression].
    ^ self possiblyWrapABreakPointAround:[super expression]

    "Created: / 16-06-2011 / 14:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 21:11:38 / cg"
!

primaryExpression
    breakpoints isEmptyOrNil ifTrue:[ ^ super primaryExpression].
    ^ self possiblyWrapABreakPointAround:[super primaryExpression]

    "Created: / 22-07-2013 / 15:37:04 / cg"
!

unaryExpression
    breakpoints isEmptyOrNil ifTrue:[ ^ super unaryExpression].
    ^ self possiblyWrapABreakPointAround:[super unaryExpression]

    "Created: / 05-07-2011 / 23:08:54 / cg"
! !

!JavaScriptCompilerWithBreakpointSupport methodsFor:'parsing-statements'!

statement
    ^ self possiblyWrapABreakPointBefore:[super statement]

    "Created: / 22-07-2013 / 15:42:53 / cg"
! !

!JavaScriptCompilerWithBreakpointSupport methodsFor:'private'!

breakpoints:aCollection
    breakpoints := aCollection copy sort:[:a :b|a position < b position].

    "Created: / 16-06-2011 / 14:35:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 05-07-2011 / 21:37:28 / cg"
!

methodClass
    ^ methodClass ? JavaScriptFunctionWithBreakpoints

    "Created: / 22-07-2013 / 15:53:54 / cg"
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

!JavaScriptCompilerWithBreakpointSupport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompilerWithBreakpointSupport.st,v 1.2 2014-05-13 14:44:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptCompilerWithBreakpointSupport.st,v 1.2 2014-05-13 14:44:01 cg Exp $'
! !

