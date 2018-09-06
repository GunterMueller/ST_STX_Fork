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

Parser variableSubclass:#BreakpointAnalyzer
	instanceVariableNames:'messageSendMap'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Debugging'
!

!BreakpointAnalyzer class methodsFor:'documentation'!

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
! !

!BreakpointAnalyzer methodsFor:'accessing'!

messageSendMap
    ^ messageSendMap
! !

!BreakpointAnalyzer methodsFor:'code generation hooks'!

messageNodeRewriteHookFor:aMessageNode
    "invoked whenever a message send node has been generated;
     gives subclasses a chance to rewrite (instrument) it"

    (messageSendMap at: aMessageNode line ifAbsentPut:[Bag new])
        add: aMessageNode selector.

    ^ aMessageNode

    "Created: / 15-04-2013 / 15:32:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-04-2013 / 23:07:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointAnalyzer methodsFor:'initialization'!

initialize
    super initialize.
    messageSendMap := Dictionary new.

    "Created: / 15-04-2013 / 15:29:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointAnalyzer methodsFor:'private'!

genMakeArrayWith:elementExpressions
    "return a node to generate an array at runtime.
     Will generate:
        Array with:el1 ... with:elN                             (if N <= 5)
     or:
        (Array new at:1 put:el1; ... at:N put:elN; yourself)    (otherwise)
    "

    |numEl arrRec sel expr|

    arrRec := VariableNode globalNamed:#Array.
    arrRec startPosition: -1 endPosition: -1. "/ -1 means artifitial node

    numEl := elementExpressions size.

    (numEl between:1 and:8) ifTrue:[
        sel := #(
                  #'with:'
                  #'with:with:'
                  #'with:with:with:'
                  #'with:with:with:with:'
                  #'with:with:with:with:with:'
                  #'with:with:with:with:with:with:'
                  #'with:with:with:with:with:with:with:'
                  #'with:with:with:with:with:with:with:with:'
                ) at:numEl.

        ^ self messageNodeRewriteHookFor:(MessageNode
                    receiver:arrRec
                    selector:sel
                    args:elementExpressions).
    ].

    "/ array creation expression ...
    expr := MessageNode
                receiver:arrRec
                selector:#new:
                arg:(ConstantNode type:#Integer value:numEl from: -1 to: -1). "/ -1 means artifitial node
    expr := self messageNodeRewriteHookFor:expr.

    numEl == 0 ifTrue:[
        ^ expr.
    ].
    "/ followed by a bunch of #at:put: messages...
    elementExpressions keysAndValuesDo:[:idx :e |
        expr := (idx == 1 ifTrue:[MessageNode] ifFalse:[CascadeNode])
                    receiver:expr
                    selector:#at:put:
                    arg1:(ConstantNode type:#Integer value:idx from: -1 to:-1)"/ -1 means artifitial node
                    arg2:e
                    fold:false.
        expr := self messageNodeRewriteHookFor:expr.
    ].
    "/ followed by a #yourself: message...
    expr := CascadeNode
                receiver:expr
                selector:#yourself.
    expr := self messageNodeRewriteHookFor:expr.
    ^ expr

    "Modified: / 24-04-2013 / 21:09:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointAnalyzer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/BreakpointAnalyzer.st,v 1.3 2013-04-24 20:26:44 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/BreakpointAnalyzer.st,v 1.3 2013-04-24 20:26:44 vrany Exp $'
! !

