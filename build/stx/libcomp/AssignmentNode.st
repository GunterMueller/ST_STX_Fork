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

ParseNode subclass:#AssignmentNode
	instanceVariableNames:'variable expression lineNr endLineNr endCharPosition'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!AssignmentNode class methodsFor:'documentation'!

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
    node for parse-trees, representing assignments.
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger

"
! !

!AssignmentNode class methodsFor:'instance creation'!

variable:v expression:e
    ^ (self basicNew) variable:v expression:e
! !

!AssignmentNode methodsFor:'accessing'!

endCharPosition
    ^ endCharPosition
!

endCharPosition:something
    endCharPosition := something.
!

endLineNr
    ^ endLineNr
!

endLineNr:something
    endLineNr := something.
!

expression
    ^ expression
!

expression:something

    expression notNil ifTrue:[expression parent: nil].
    expression := something.
    expression notNil ifTrue:[expression parent: self].

    endPosition := expression endPosition.

    "Modified: / 27-07-2011 / 13:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNr
    ^ lineNr
!

lineNr:something
    lineNr := something.
!

lineNumber
    "return lineNr"

    ^ lineNr

    "Created: / 14.5.1998 / 19:30:49 / cg"
!

lineNumber:something
    "set lineNr"

    lineNr := something.

    "Created: / 14.5.1998 / 19:30:54 / cg"
!

variable
    ^ variable

    "Created: 19.6.1997 / 17:08:58 / cg"
!

variable:something

    variable notNil ifTrue:[variable parent: nil].
    variable := something.
    variable notNil ifTrue:[variable parent: self].

    startPosition := variable startPosition.

    "Modified: / 27-07-2011 / 13:50:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variable:v expression:e
    variable notNil ifTrue:[variable parent: nil].
    variable := v.
    variable notNil ifTrue:[variable parent: self].

    e == #Error ifTrue:[
        ^ self
    ].

    expression notNil ifTrue:[expression parent: nil].
    expression := e.
    expression notNil ifTrue:[
        expression parent: self.
        endPosition := expression endPosition.
    ].

    startPosition := variable startPosition.

    "/ any block, which gets assigned to something
    "/ cannot be inlined.
    (e notNil and:[e realNode isBlockNode]) ifTrue:[
        e realNode possiblyInlined:false
    ]

    "Modified: / 22-02-2011 / 12:52:56 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 27-07-2011 / 13:50:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AssignmentNode methodsFor:'code generation'!

checkIncDecOn:aStream
    "check if we can use incMvar / decMvar instruction.
     If so, code it and return true.
     Otherwise, return false."

    |sel erec arg code|

    (variable type == #MethodVariable) ifTrue:[
        expression isBinaryMessage ifTrue:[
            sel := expression selector.
            erec := expression receiver.

            ((sel == #+) or:[sel == #-]) ifTrue:[
                (erec type == #MethodVariable) ifTrue:[
                    (erec index == variable index) ifTrue:[
                        arg := expression arg1.
                        arg isConstant ifTrue:[
                            (arg value == 1) ifTrue:[
                                (sel == #+) ifTrue:[
                                    code := #incMethodVar
                                ] ifFalse:[
                                    code := #decMethodVar
                                ].
                                aStream nextPut:code; nextPut:(expression lineNumber); nextPut:(variable index).
                                ^ true
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].
    ^ false

    "Modified: 1.3.1996 / 00:08:02 / cg"
!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    (self checkIncDecOn:aStream) ifTrue:[^ self].

    self codeNormalOn:aStream valueNeeded:false inBlock:b for:aCompiler

    "Modified: 4.9.1995 / 14:38:10 / claus"
    "Modified: 1.3.1996 / 00:42:10 / cg"
!

codeNormalOn:aStream valueNeeded:forValue inBlock:b for:aCompiler
    |isSend litIdx selLitIdx|

    isSend := expression isMessage.
    (lineNr notNil 
     and:[isSend not]) ifTrue:[
        self codeLineNumber:lineNr on:aStream for:aCompiler
    ].

    "/ must do workspace variables here, because these
    "/ need the receiver (the valueHolder) to be pushed first,
    "/ then the value which is to be stored.
    "/ finally, a #value: message is generated.

    (variable type == #WorkspaceVariable) ifTrue:[
        "/ this is done by keeping the valueHolder in the literalArray,
        "/ and coding a #value: message here.

        litIdx := aCompiler addLiteral:variable token.
        self emitPushLiteralIndex:litIdx on:aStream for:aCompiler.

        expression codeOn:aStream inBlock:b for:aCompiler.

        selLitIdx := aCompiler addLiteral:#value:.
        self emitSendLiteralIndex:selLitIdx numArgs:1 line:(lineNr ? 1) on:aStream for:aCompiler.
        aStream nextPut:#drop.

        forValue ifTrue:[
            (expression isConstant or:[expression isVariable]) ifTrue:[
                expression codeOn:aStream inBlock:b for:aCompiler.
            ] ifFalse:[
                "/ fetch value from the holder - sigh
                self emitPushLiteralIndex:litIdx on:aStream for:aCompiler.

                selLitIdx := aCompiler addLiteral:#value.
                self emitSendLiteralIndex:selLitIdx numArgs:0 line:(lineNr ? 1) on:aStream for:aCompiler.
            ]
        ].
        ^ self
    ].

    expression codeOn:aStream inBlock:b for:aCompiler.
    expression isBlock ifTrue:[
        variable isLocal ifTrue:[
            aStream nextPut:#blockRef
        ]
    ].

    (lineNr notNil
     and:[isSend]) ifTrue:[
        self codeLineNumber:lineNr on:aStream for:aCompiler
    ].
    variable codeStoreOn:aStream inBlock:b valueNeeded:forValue for:aCompiler

    "Modified: 4.9.1995 / 14:38:10 / claus"
    "Created: 1.3.1996 / 00:41:43 / cg"
    "Modified: 21.10.1996 / 16:26:33 / cg"
!

codeOn:aStream inBlock:b for:aCompiler
    (self checkIncDecOn:aStream) ifTrue:[
        expression receiver codeOn:aStream inBlock:b for:aCompiler.
        ^ self
    ].

    self codeNormalOn:aStream valueNeeded:true inBlock:b for:aCompiler

    "Modified: 1.3.1996 / 00:42:21 / cg"
! !

!AssignmentNode methodsFor:'enumerating'!

allSubNodesDo:aBlock
    aBlock value:variable.
    expression allNodesDo:aBlock
!

messagesDo:aBlock
    "evaluate aBlock for each message-node here and in subnodes"

    expression messagesDo:aBlock.
!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doAssignment:self variable:variable value:expression

    "Modified: 19.6.1997 / 16:37:50 / cg"
! !

!AssignmentNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    |value|

    value := expression evaluateIn:anEnvironment.
    variable store:value.
    ^ value
! !

!AssignmentNode methodsFor:'printing & storing'!

printOn:aStream indent:i
    variable printOn:aStream.
    self printOperatorOn:aStream.
    expression printOn:aStream
!

printOperatorOn:aStream
    aStream nextPutAll:' := '.
! !

!AssignmentNode methodsFor:'queries'!

collectBlocksInto:aCollection
    expression collectBlocksInto:aCollection.

    "Created: 11.1.1997 / 20:54:30 / cg"
!

evaluatesToConstant
    "return true, if this is a node for an assignment"

    ^ expression evaluatesToConstant
!

precedence
    ^ 0

    "Created: / 20-04-2005 / 14:11:09 / cg"
!

withConstantValueDo:aBlock
    "return true, if this evaluates to a constant value
     and evaluate aBlock with it"

    ^ expression withConstantValueDo:aBlock
! !

!AssignmentNode methodsFor:'testing'!

isAssignment
    "return true, if this is a node for an assignment"

    ^ true
! !

!AssignmentNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAssignmentNode:self
! !

!AssignmentNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

