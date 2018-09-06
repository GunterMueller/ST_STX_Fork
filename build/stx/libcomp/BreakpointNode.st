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

ParseNode subclass:#BreakpointNode
	instanceVariableNames:'breakpoint expression lineNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Debugging'
!

!BreakpointNode class methodsFor:'documentation'!

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
    compiler support for statement breakpoints.
"
! !

!BreakpointNode methodsFor:'accessing'!

breakpoint
    ^ breakpoint
!

breakpoint:something
    breakpoint := something.
!

expression
    ^ expression
!

expression:something
    expression := something.
!

lineNumber
    ^ lineNumber
!

lineNumber:lineNumberArg
    self assert:(lineNumberArg >= 0).
    lineNumber := lineNumberArg.
!

realNode
    ^ expression
!

selectorPosition
    ^ expression selectorPosition
! !

!BreakpointNode methodsFor:'code generation'!

codeForCascadeOn:aStream inBlock:b for:aCompiler
    |node|

    node := UnaryNode
                receiver: (ConstantNode value: breakpoint)
                selector: #break.
    node lineNumber:lineNumber.
    node codeForSideEffectOn:aStream inBlock:b for:aCompiler.
    expression notNil ifTrue:[
        expression codeForCascadeOn:aStream inBlock:b for:aCompiler
    ].

    "Modified: / 26-03-2018 / 15:39:38 / stefan"
!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    |node|

    node := UnaryNode
                receiver: (ConstantNode value: breakpoint)
                selector: #break.
    node lineNumber:lineNumber.
    node codeForSideEffectOn:aStream inBlock:b for:aCompiler.
    expression notNil ifTrue:[
        expression codeForSideEffectOn:aStream inBlock:b for:aCompiler
    ].

    "Modified: / 26-03-2018 / 15:39:33 / stefan"
!

codeOn:aStream inBlock:codeBlock for:aCompiler
    |node|

    node := UnaryNode
                receiver: (ConstantNode value: breakpoint)
                selector: #break.
    node lineNumber:lineNumber.
    node codeForSideEffectOn:aStream inBlock:codeBlock for:aCompiler.
    expression notNil ifTrue:[
        expression codeOn:aStream inBlock:codeBlock for:aCompiler
    ].

    "Created: / 16-06-2011 / 15:17:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2013 / 16:08:34 / cg"
    "Modified: / 26-03-2018 / 15:38:22 / stefan"
! !

!BreakpointNode methodsFor:'node protocol forwarding'!

arg1
    "must forward - otherwise cascades won't work"

    ^ expression arg1
!

args
    "must forward - otherwise keywordExpression won't work"

    ^ expression args
!

argumentCount
    "must forward - otherwise checkCondition won't work"

    ^ expression argumentCount
!

arguments
    "must forward - otherwise cascades won't work"

    ^ expression arguments
!

isMessage
    "must forward - otherwise cascades won't work"

    ^ expression isMessage
!

numArgs
    "must forward - otherwise checkCondition won't work.
     Please use argumentCount, which is ANSI"

    ^ expression numArgs
!

plausibilityCheckIn:aParser
    ^ expression plausibilityCheckIn:aParser

    "Created: / 20-11-2016 / 19:17:54 / cg"
!

receiver
    "must forward - otherwise cascades won't work"

    ^ expression receiver
!

selector
    "must forward - otherwise cascades won't work"

    ^ expression selector
! !

!BreakpointNode methodsFor:'printing'!

printOn:aStream indent:indent
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    expression printOn:aStream indent:indent

    "Created: / 06-07-2011 / 14:31:10 / cg"
! !

!BreakpointNode methodsFor:'testing'!

isBreakPointNode
    ^ true

    "Created: / 05-07-2011 / 21:13:52 / cg"
! !

!BreakpointNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

