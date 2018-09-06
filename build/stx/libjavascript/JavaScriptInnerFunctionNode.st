"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

JavaScriptFunctionNode subclass:#JavaScriptInnerFunctionNode
	instanceVariableNames:'indexOfFirstTemp'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptInnerFunctionNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptInnerFunctionNode methodsFor:'accessing'!

blockArgAccessed:aBoolean
!

home:anEnvironment
    environment := anEnvironment
!

indexOfFirstTemp
    indexOfFirstTemp isNil ifTrue:[ ^ self numVars ].
    ^ indexOfFirstTemp
!

indexOfFirstTemp:index
    indexOfFirstTemp := index
! !

!JavaScriptInnerFunctionNode methodsFor:'code generation'!

codeOn:aStream inBlock:b for:aCompiler
    "this generates a block for the inner function;
     Difference from block:
        return is a local return;
        if return is missing, retval is nil"

    |pos thisStatement nextStatement lastStatement code
     maxNumTemp|

    maxNumTemp := 10.

    pos := aStream position + 1.

    aStream nextPut:#makeBlock.                                 "+0"
    aStream nextPut:0.                                          "+1"
    aStream nextPut:(self numVars + maxNumTemp).                 "+2"
    aStream nextPut:(arguments size).                           "+3"

    self codeVariableSetupOn:aStream for:self.

    statements isEmptyOrNil ifTrue:[
        aStream nextPut:#retNil.
    ] ifFalse:[
        lastStatement := nil.                                                                "+4"
        thisStatement := statements.
        [thisStatement notNil] whileTrue:[
            nextStatement := thisStatement nextStatement.
            thisStatement codeForSideEffectOn:aStream inBlock:self for:aCompiler.
            lastStatement := thisStatement.     
            thisStatement := nextStatement
        ].

        lastStatement isReturnNode ifFalse:[
            aStream nextPut:#retNil.
        ].
"/
"/        lastStatement 
"/                codeForSimpleReturnOn:aStream
"/                inBlock:self 
"/                lineNumber:lastStatement lineNumber 
"/                for:aCompiler.
    ].

    code := (aStream contents).
    "/ sigh - during coding, inlined subBlocks may have added more
    "/ tempVars; patch the nvar byte ...

    code at:pos+2 put:(self numVars + maxNumTemp).

    "set the end of the block's code"
    code at:pos+1 put:(aStream position + 1)
!

rememberOuterBlockVarAccess:aVariableNode
"/    accessedOuterBlockVars isNil ifTrue:[
"/        accessedOuterBlockVars := OrderedCollection new.
"/    ].
"/    accessedOuterBlockVars add:aVariableNode
! !

!JavaScriptInnerFunctionNode methodsFor:'evaluation'!

_theReceiver
    ^ nil
!

evaluateIn:anEnvironment
    ^ self
!

exitWith:something
    "return via return-statement"

    |con|

    "/ here, I am in the tree interpreter;
    "/ so just walk along the sender chain to find the evaluateAllIn:
    con := thisContext sender.
    [ con notNil ] whileTrue:[
        ((con selector == #value:) and:[ con receiver == self ]) ifTrue:[
            con return:something.
        ].
        con := con sender.
    ].

    "/ self halt.
"/    home notNil ifTrue:[
"/        home exitWith:something
"/    ].
    ^ something

    "Modified: / 14-07-2018 / 09:35:10 / Claus Gittinger"
! !

!JavaScriptInnerFunctionNode methodsFor:'queries'!

home
    ^ environment
! !

!JavaScriptInnerFunctionNode methodsFor:'testing'!

isInlineBlock
    ^ false
!

isInnerFunction
    ^ true
!

isJavaScriptBlock
    ^ true
! !

!JavaScriptInnerFunctionNode methodsFor:'visiting'!

acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ visitor visitJavaScriptInnerFunctionNode:self 
! !

!JavaScriptInnerFunctionNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptInnerFunctionNode.st,v 1.12 2018-07-16 07:54:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptInnerFunctionNode.st,v 1.12 2018-07-16 07:54:24 cg Exp $'
! !

