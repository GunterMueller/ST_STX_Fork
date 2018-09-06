"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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

PrimaryNode subclass:#VariableNode
	instanceVariableNames:'name token index block'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!VariableNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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
    node for parse-trees, representing variables
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!VariableNode class methodsFor:'instance creation'!

blockArgumentNamed:n
    ^ (self basicNew) type:#BlockArg name:n asSymbol

    "Created: / 22-10-2006 / 11:59:10 / cg"
!

globalNamed:n                                   
    "because this is called even for invalid (partial) names,
     and we do not want to create zillions of unused symbols,
     no asSymbol is done here. So the name kept is actually a string.
     A symbol will be created when code is actually created for it"

    ^ (self basicNew) type:#GlobalVariable name:n "asSymbol"

    "Modified (comment): / 29-08-2013 / 01:10:02 / cg"
!

methodArgumentNamed:n
    ^ (self basicNew) type:#MethodArg name:n asSymbol

    "Created: / 06-08-2006 / 01:12:55 / cg"
!

methodLocalNamed:n
    ^ (self basicNew) type:#MethodVariable name:n asSymbol

    "Created: / 06-08-2006 / 13:43:41 / cg"
!

type:t class:class name:n
    ^ (self basicNew) type:t class:class name:n
!

type:t context:aContext
    ^ (self basicNew) type:t context:aContext

    "Created: / 17.1.1998 / 04:00:35 / cg"
!

type:t holder:holder name:n
    ^ (self basicNew) type:t holder:holder name:n
!

type:t name:n
    ^ (self basicNew) type:t name:n
!

type:t name:n context:aContext index:i
    ^ (self basicNew) type:t name:n context:aContext index:i

    "Created: / 17.1.1998 / 02:40:32 / cg"
!

type:t name:n index:i selfClass:s
    ^ (self basicNew) type:t name:n index:i selfClass:s
!

type:t name:n index:i selfValue:s
    ^ (self basicNew) type:t name:n index:i selfValue:s
!

type:t name:n token:tok index:i
    ^ (self basicNew) type:t name:n token:tok index:i
!

type:t name:n token:tok index:i block:b from:codeBlock
    ^ (self basicNew) type:t name:n token:tok index:i block:b from:codeBlock

    "Modified: 2.7.1997 / 10:55:48 / cg"
! !

!VariableNode methodsFor:'accessing'!

block
    ^ block

    "Created: 2.7.1997 / 18:53:38 / cg"
!

block:something
    block := something.
!

index
    ^ index
!

index:anIntegerIndex
"/    self assert:(anIntegerIndex isNil or:[anIntegerIndex ~~ 0]).
    index := anIntegerIndex.

    "Modified: / 15-11-2011 / 19:10:08 / cg"
!

name
    type == #ThisContext ifTrue:[ ^ 'thisContext' ].
    ^ name

    "Modified: / 23-09-2014 / 14:08:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:something
    name := something.

    "Modified: / 28-06-2011 / 22:14:40 / cg"
!

startPosition:start endPosition: end

    "/self assert: (end - start + 1) = name size.

    ^super startPosition:start endPosition: end

    "Created: / 25-08-2011 / 11:46:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

token
    ^ token

    "Created: 2.7.1997 / 18:53:38 / cg"
!

token:something
    token := something.
!

type
    ^ type
!

type:t class:class name:n
    "/ type == #PoolVariable ifTrue:[self breakPoint:#cg].
    type := t.
    name := n.
    value := class

    "Modified: / 17.1.1998 / 04:03:55 / cg"
!

type:t context:aContext
    type := t.
    value := aContext.

    "Modified: / 17.1.1998 / 04:01:55 / cg"
!

type:t holder:holder name:n
    type := t.
    token := holder.
    name := n
!

type:t name:n
    type := t.
    value := nil.
    name := n
!

type:t name:n context:aContext index:anIntegerIndex
    type := t.
"/    self assert:(anIntegerIndex isNil or:[anIntegerIndex ~~ 0]).
    index := anIntegerIndex.
    value := aContext.
    name := n

    "Created: / 17-01-1998 / 02:40:55 / cg"
    "Modified: / 15-11-2011 / 19:10:18 / cg"
!

type:t name:n index:anIntegerIndex selfClass:s
    type := t.
"/    self assert:(anIntegerIndex isNil or:[anIntegerIndex ~~ 0]).
    index := anIntegerIndex.
    value := s.
    name := n

    "Modified: / 15-11-2011 / 19:10:21 / cg"
!

type:t name:n index:anIntegerIndex selfValue:s
    type := t.
"/    self assert:(anIntegerIndex isNil or:[anIntegerIndex ~~ 0]).
    index := anIntegerIndex.
    value := s.
    name := n

    "Modified: / 15-11-2011 / 19:10:24 / cg"
!

type:t name:n token:tok index:anIntegerIndex
    type := t.
"/    self assert:(anIntegerIndex isNil or:[anIntegerIndex ~~ 0]).
    index := anIntegerIndex.
    token := tok.
    name := n

    "Modified: / 15-11-2011 / 19:10:30 / cg"
!

type:t name:n token:tok index:anIntegerIndex block:variableBlock from:codeBlock
    type := t.
"/    self assert:(anIntegerIndex isNil or:[anIntegerIndex ~~ 0]).
    index := anIntegerIndex.
    block := variableBlock.
    token := tok.
    name := n.
    (type == #BlockArg) ifTrue:[
        variableBlock blockArgAccessed:true.
    ].

    codeBlock ~~ variableBlock ifTrue:[
        codeBlock rememberOuterBlockVarAccess:self
    ]

    "Created: / 02-07-1997 / 10:54:50 / cg"
    "Modified: / 15-11-2011 / 19:10:35 / cg"
!

type:t token:tok index:anIntegerIndex block:b
    type := t.
"/    self assert:(anIntegerIndex isNil or:[anIntegerIndex ~~ 0]).
    index := anIntegerIndex.
    block := b.
    token := tok.

    (type == #BlockArg) ifTrue:[
        b blockArgAccessed:true.
    ].

    "Modified: / 15-11-2011 / 19:10:04 / cg"
! !

!VariableNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "no code at all"

    aCompiler 
        warning:'Useless variable reference'
        position:startPosition to:endPosition.    

    ^ self
!

codeForSimpleReturnOn:aStream inBlock:b lineNumber:lineNrOrNil for:aCompiler
    |code idx|

    lineNrOrNil notNil ifTrue:[
        self codeLineNumber:lineNrOrNil on:aStream for:aCompiler
    ].

    (type == #InstanceVariable) ifTrue:[
        (index <= 8) ifTrue:[
            code := #( retInstVar1
                       retInstVar2
                       retInstVar3
                       retInstVar4
                       retInstVar5
                       retInstVar6
                       retInstVar7
                       retInstVar8) at:index.

            aStream nextPut:code.
            ^ self
        ].
    ].

    (type == #MethodVariable) ifTrue:[
        idx := index.
        idx isNil ifTrue:[ idx := self indexIn: aCompiler ].
        (idx <= 6) ifTrue:[
            code := #( retMethodVar1
                       retMethodVar2
                       retMethodVar3
                       retMethodVar4
                       retMethodVar5
                       retMethodVar6) at:idx.

            aStream nextPut:code.
            ^ self
        ].
    ].

    (type == #MethodArg) ifTrue:[
        idx := index.
        idx isNil ifTrue:[ idx := self indexIn: aCompiler ].
        (idx <= 2) ifTrue:[
            code := #(retMethodArg1
                      retMethodArg2) at:idx.

            aStream nextPut:code.
            ^ self
        ]
    ].

    "/ anything else must be pushed, then top returned

    self codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut:#retTop

    "Modified: / 06-08-2006 / 22:59:28 / cg"
    "Modified (comment): / 25-01-2018 / 19:26:46 / mawalch"
!

codeLoadOn:aStream type:type index:index inBlock:codeBlock for:aCompiler
    |theCode b deltaLevel litIndex specialGlobalIndex
     bvIdx bvTyp blocksCode selLitIdx |

    (type == #MethodArg) ifTrue:[
        (index <= 4) ifTrue:[
            aStream nextPut:(#(pushMethodArg1
                               pushMethodArg2
                               pushMethodArg3 
                               pushMethodArg4) at:index).
            ^ self
        ].
        aStream nextPut:#pushMethodArg; nextPut:index.
        ^ self
    ].

    (type == #MethodVariable) ifTrue:[
        (index <= 6) ifTrue:[
            aStream nextPut:(#(pushMethodVar1
                               pushMethodVar2
                               pushMethodVar3
                               pushMethodVar4
                               pushMethodVar5
                               pushMethodVar6) at:index).
            ^ self
        ].
        aStream nextPut:#pushMethodVar; nextPut:index.
        ^ self
    ].

    (type == #InstanceVariable) ifTrue:[
        (index <= 10) ifTrue:[
            theCode := #(pushInstVar1 pushInstVar2 pushInstVar3
                         pushInstVar4 pushInstVar5 pushInstVar6
                         pushInstVar7 pushInstVar8 pushInstVar9
                         pushInstVar10) at:index.
            aStream nextPut:theCode.
            ^ self
        ].
        aStream nextPut:#pushInstVar; nextPut:index.
        ^ self
    ].

    ((type == #BlockArg) 
    or:[type == #BlockVariable]) ifTrue:[
        "/ compiling for codeBlock; accessing variable in block.

        bvIdx := index.
        bvTyp := type.

        "/ find the context where that variable is contained physically
        blocksCode := block.
        [blocksCode notNil and:[blocksCode isInlineBlock]] whileTrue:[
            blocksCode := blocksCode home
        ].

        "/ find deltaLevel from code-context to the containing block
        b := codeBlock.
        deltaLevel := 0.
        [b notNil and:[b ~~ blocksCode]] whileTrue:[
            b isInlineBlock ifFalse:[
                deltaLevel := deltaLevel + 1
            ].
            b := b home
        ].

        b isNil ifTrue:[
            codeBlock isNil ifTrue:[
                "/ a var of a block which is inlined in the method. 
                "/ Generate a pushMVAR

                bvIdx := block indexOfFirstTemp + index - 1.
                type == #BlockVariable ifTrue:[
                    bvIdx := bvIdx + block numArgs
                ].
                ^ self 
                    codeLoadOn:aStream
                    type:#MethodVariable
                    index:bvIdx
                    inBlock:codeBlock
                    for:aCompiler
            ].

            "/ a var of a block which is inlined in the outer block.
            "/ Generate a pushBVAR

            bvIdx := block indexOfFirstTemp + index - 1.
            type == #BlockVariable ifTrue:[
                bvIdx := bvIdx + block numArgs
            ].
            bvTyp := #BlockVariable.
        ] ifFalse:[
            block isInlineBlock ifTrue:[
                "/ a var of a block which is inlined in another block.
                "/ Generate a pushBVAR / pushOuterBVAR
                bvIdx := block indexOfFirstTemp + index - 1.
                type == #BlockVariable ifTrue:[
                    bvIdx := bvIdx + block numArgs
                ].
                bvTyp := #BlockVariable.
            ]
        ].

        (bvTyp == #BlockVariable) ifTrue:[
            (deltaLevel == 0) ifTrue:[
                bvIdx <= 3 ifTrue:[
                    aStream nextPut:(#(pushBlockVar1 pushBlockVar2 pushBlockVar3) at:bvIdx).
                    ^ self
                ].
                aStream nextPut:#pushBlockVar.
            ] ifFalse:[
                aStream nextPut:#pushOuterBlockVar; nextPut:deltaLevel.
            ].
        ] ifFalse:[
            (deltaLevel == 0) ifTrue:[
                (bvIdx <= 4) ifTrue:[
                    aStream nextPut:(#(pushBlockArg1 pushBlockArg2 pushBlockArg3
                                       pushBlockArg4) at:bvIdx).
                    ^ self
                ].
                aStream nextPut:#pushBlockArg.
            ] ifFalse:[
                (deltaLevel == 1) ifTrue:[
                    aStream nextPut:#pushOuter1BlockArg
                ] ifFalse:[
                    (deltaLevel == 2) ifTrue:[
                        aStream nextPut:#pushOuter2BlockArg
                    ] ifFalse:[
                        aStream nextPut:#pushOuterBlockArg; nextPut:deltaLevel
                    ]
                ].
            ].
        ].
        aStream nextPut:bvIdx.
        ^ self
    ].

    (type == #GlobalVariable) ifTrue:[
        "for browsing, we put it into the literal-array; even if it's a specal global"
        litIndex := aCompiler addLiteral:name asSymbol.
        specialGlobalIndex := aCompiler specialGlobalCodeFor:name.
        specialGlobalIndex notNil ifTrue:[
            aStream nextPut:#pushSpecialGlobal; nextPut:specialGlobalIndex.
            ^ self
        ].
        self emitPushGlobalWithLiteralIndex:litIndex on:aStream for:aCompiler.
        ^ self
    ].

    ((type == #ClassVariable) or:[ type == #PoolVariable ]) ifTrue:[
        litIndex := aCompiler addLiteral:(value globalKeyForClassVar:name).
        litIndex <= 255 ifTrue:[
            aStream nextPut:#pushClassVarS; nextPut:litIndex
        ] ifFalse:[
            litIndex <= 16rFFFF ifTrue:[
                aStream nextPut:#pushClassVarL; nextPut:litIndex; nextPut:0
            ] ifFalse:[
                aStream nextPut:#pushClassVarVL; nextPut:0; nextPut:litIndex; nextPut:0; nextPut:0; nextPut:0
            ].
        ].
        ^ self
    ].

    (type == #PrivateClass) ifTrue:[
        litIndex := aCompiler addLiteral:(value name , '::' , name) asSymbol.
        self emitPushGlobalWithLiteralIndex:litIndex on:aStream for:aCompiler.
        ^ self
    ].

    (type == #ClassInstanceVariable) ifTrue:[
        "theoretically, this allows for an instance method to access a classInstVar;
         However, the parser blocks this and we never arrive here."

        aStream nextPut:#pushClassInstVar; nextPut:index.
        ^ self
    ].

    (type == #ThisContext) ifTrue:[
        aStream nextPut:#pushThisContext. 
        ^ self
    ].

    (type == #WorkspaceVariable
    or:[type == #DoItTemporary]) ifTrue:[
        "/ this is done by keeping the valueHolder in the literalArray,
        "/ and coding a #value message here.

        litIndex := aCompiler addLiteral:token.
        self emitPushLiteralIndex:litIndex on:aStream for:aCompiler.

        selLitIdx := aCompiler addLiteral:#value.
        self emitSendLiteralIndex:selLitIdx numArgs:0 line:("lineNr ?" 1) on:aStream for:aCompiler.
        ^ self
    ].
    (type == #ThreadLocal) ifTrue:[
        litIndex := aCompiler addLiteral:#Processor.
        self emitPushGlobalWithLiteralIndex:litIndex on:aStream for:aCompiler.
        selLitIdx := aCompiler addLiteral:#activeProcess.
        self emitSendLiteralIndex:selLitIdx numArgs:0 line:("lineNr ?" 1) on:aStream for:aCompiler.
        litIndex := aCompiler addLiteral:name asSymbol.
        self emitPushLiteralIndex:litIndex on:aStream for:aCompiler.
        selLitIdx := aCompiler addLiteral:#environmentAt:.
        self emitSendLiteralIndex:selLitIdx numArgs:1 line:("lineNr ?" 1) on:aStream for:aCompiler.
        ^ self
    ].

    "not reached"
    self error:'bad type'.

    "Created: / 25-06-1997 / 16:14:17 / cg"
    "Modified: / 17-01-1998 / 04:04:17 / cg"
    "Modified (format): / 13-02-2017 / 20:34:16 / cg"
!

codeOn:aStream inBlock:codeBlock for:aCompiler
    |idx|

    idx := (index isNil) 
            ifTrue:[ self indexIn: aCompiler ]
            ifFalse:[ index ].

    self
        codeLoadOn:aStream type:type index:idx inBlock:codeBlock for:aCompiler

    "Modified: / 06-08-2006 / 16:04:54 / cg"
!

codeStoreOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    |idx|

    idx := (index isNil) 
            ifTrue:[ self indexIn: aCompiler ]
            ifFalse:[ index ].
    idx == 0 ifTrue:[
        self error
    ].
    self
        codeStoreOn:aStream type:type index:idx
        inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler

    "Modified: / 12-08-2006 / 15:54:52 / cg"
!

codeStoreOn:aStream type:type index:index inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    |theCode b deltaLevel litIndex bvIdx blocksCode selLitIdx|

    "/ value to be stored is on TOP of stack.
    valueNeeded ifTrue:[
        aStream nextPut:#dup
    ].

    (type == #MethodVariable) ifTrue:[
        (index <= 6) ifTrue:[
            theCode := #(storeMethodVar1 storeMethodVar2
                         storeMethodVar3 storeMethodVar4
                         storeMethodVar5 storeMethodVar6) at:index.
            aStream nextPut:theCode.
            ^ self
        ].
        aStream nextPut:#storeMethodVar; nextPut:index.
        ^ self
    ].

    (type == #InstanceVariable) ifTrue:[
        (index <= 10) ifTrue:[
            theCode := #(storeInstVar1 storeInstVar2
                         storeInstVar3 storeInstVar4
                         storeInstVar5 storeInstVar6
                         storeInstVar7 storeInstVar8
                         storeInstVar9 storeInstVar10) at:index.
            aStream nextPut:theCode.
            ^ self
        ].
        aStream nextPut:#storeInstVar; nextPut:index.
        ^ self
    ].

    ((type == #BlockVariable)
    "/ Normally one cannot assign to a block argument in smalltalk.
    "/ However, this is supported in Smalltalk/X if ParserFlags allowAssignmentToBlockArgument:
    "/ is set to true or when compiling other languages (JavaScript in particular).
    or:[(type == #BlockArg)]) ifTrue:[
        bvIdx := index.
        
        "/ find the context where that variable is contained physically
        blocksCode := block.
        [blocksCode notNil and:[blocksCode isInlineBlock]] whileTrue:[
            blocksCode := blocksCode home
        ].

        "find deltaLevel to block, where variable was defined"
        b := codeBlock.
        deltaLevel := 0.
        [b notNil and:[b ~~ blocksCode]] whileTrue:[
            b isInlineBlock ifFalse:[
                deltaLevel := deltaLevel + 1
            ].
            b := b home
        ].

        b isNil ifTrue:[
            codeBlock isNil ifTrue:[
                "/ a block which is inlined in the method. 
                "/ Generate a storeMVAR

                bvIdx := block indexOfFirstTemp + index - 1.
                type == #BlockVariable ifTrue:[
                    bvIdx := bvIdx + block numArgs.
                ].
                ^ self
                    codeStoreOn:aStream 
                    type:#MethodVariable index:bvIdx 
                    inBlock:codeBlock 
                    valueNeeded:false       "/ already dupped if value is needed
                    for:aCompiler
            ].
            "/ a var of a block which is inlined in the outer block.
            "/ Generate a pushBVAR

            bvIdx := block indexOfFirstTemp + index - 1.
            type == #BlockVariable ifTrue:[      
                bvIdx := bvIdx + block numArgs.
            ].
        ] ifFalse:[
            block isInlineBlock ifTrue:[
                "/ a var of a block which is inlined in another block.
                "/ Generate a pushBVAR / pushOuterBVAR
                bvIdx := block indexOfFirstTemp + index - 1.
                type == #BlockVariable ifTrue:[      
                    bvIdx := bvIdx + block numArgs.
                ].
            ]
        ].

        (type == #BlockArg) ifTrue:[
            (deltaLevel == 0) ifTrue:[
                aStream nextPut:#storeBlockLocal
            ] ifFalse:[
                aStream nextPut:#storeOuterBlockLocal; nextPut:deltaLevel
            ].
            aStream nextPut:bvIdx-1.
            ^ self
        ].

        (deltaLevel == 0) ifTrue:[
            bvIdx <= 3 ifTrue:[
                aStream nextPut:(#(storeBlockVar1 storeBlockVar2 storeBlockVar3) at:bvIdx).
                ^ self
            ].
            aStream nextPut:#storeBlockVar
        ] ifFalse:[
            aStream nextPut:#storeOuterBlockVar; nextPut:deltaLevel
        ].
        aStream nextPut:bvIdx.
        ^ self
    ].

    (type == #GlobalVariable) ifTrue:[
        litIndex := aCompiler addLiteral:name asSymbol.
        self emitStoreGlobalWithLiteralIndex:litIndex on:aStream for:aCompiler.
        ^ self
    ].

    ((type == #ClassVariable) or:[type == #PoolVariable]) ifTrue:[
        value isNil ifTrue:[
            "/ class not set in node - use the compiler's class.
            "/ this happens, when a JavaScript class definition is read,
            "/ where the class has not yet been created when the classVars are specified.
            litIndex := aCompiler addLiteral:(aCompiler targetClass globalKeyForClassVar:name).
        ] ifFalse:[
            litIndex := aCompiler addLiteral:(value globalKeyForClassVar:name).
        ].
        litIndex < 256 ifTrue:[
            aStream nextPut:#storeClassVarS; nextPut:litIndex
        ] ifFalse:[
            aStream nextPut:#storeClassVarL; nextPut:litIndex; nextPut:0
        ].
        ^ self
    ].

    (type == #ClassInstanceVariable) ifTrue:[
        aStream nextPut:#storeClassInstVar; nextPut:index.
        ^ self
    ].

    (type == #WorkspaceVariable
    or:[type == #DoItTemporary]) ifTrue:[
        "/ this is done by keeping the valueHolder in the literalArray,
        "/ and coding a #value: message here.

        litIndex := aCompiler addLiteral:token.
        self emitPushLiteralIndex:litIndex on:aStream for:aCompiler.

        "/ need to exchange top 2 items (sigh - there is no exch instruction)
        "/ now, we have:
        "/   TOS:  holder
        "/   NOS:  value
        "/
        "/ for the send, I need them as:
        "/   TOS:  value
        "/   NOS:  holder
        aStream nextPut:#over.
        "/ now, we have:
        "/   TOS:  value
        "/   NOS:  holder
        "/         value
        selLitIdx := aCompiler addLiteral:#'value:'.
        self emitSendLiteralIndex:selLitIdx numArgs:1 line:("lineNr ?" 1) on:aStream for:aCompiler.
        "/ now, we have:
        "/   TOS:  retVal from value:
        "/   NOS:  value
        aStream nextPut:#drop.
        aStream nextPut:#drop.
        ^ self
    ].

    (type == #ThreadLocal) ifTrue:[
        aStream nextPut:#dup.
        litIndex := aCompiler addLiteral:#Processor.
        self emitPushGlobalWithLiteralIndex:litIndex on:aStream for:aCompiler.
        selLitIdx := aCompiler addLiteral:#activeProcess.
        self emitSendLiteralIndex:selLitIdx numArgs:0 line:("lineNr ?" 1) on:aStream for:aCompiler.
        "/ now, we have:
        "/   TOS:  process
        "/   NOS:  value
        "/         value
        aStream nextPut:#swap.
        "/ now, we have:
        "/   TOS:  value
        "/   NOS:  process
        "/         value
        litIndex := aCompiler addLiteral:name asSymbol.
        self emitPushLiteralIndex:litIndex on:aStream for:aCompiler.
        "/ now, we have:
        "/   TOS:  key
        "/   NOS:  value
        "/         process
        "/         value
        aStream nextPut:#swap.
        "/ now, we have:
        "/   TOS:  value
        "/   NOS:  key
        "/         process
        "/         value
        selLitIdx := aCompiler addLiteral:#environmentAt:put:.
        self emitSendLiteralIndex:selLitIdx numArgs:1 line:("lineNr ?" 1) on:aStream for:aCompiler.
        aStream nextPut:#drop.
        "/ leave value on top
        ^ self
    ].

    "/ the following cannot be encountered with Smalltalk code;
    "/ however, the VM supports it for other languages (JavaScript, in particular)
    (type == #MethodArg) ifTrue:[
        aStream nextPut:#storeMethodLocal; nextPut:index-1.
        ^ self
    ].

    "not reached"
    self error:'bad assignment'

    "Created: / 25-06-1997 / 16:14:40 / cg"
    "Modified: / 25-10-2011 / 23:41:59 / cg"
    "Modified: / 18-04-2018 / 23:34:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 20-04-2018 / 06:21:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableNode methodsFor:'enumerating'!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doVariable:self name:name

    "Created: 19.6.1997 / 16:41:35 / cg"
!

variableNodesDo:aBlock
    "helper for parse tree walking"

    aBlock value:self 
! !

!VariableNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    |nameSym|

    (type == #ContextVariable) ifTrue:[
"/        value method isWrapped ifTrue:[^ nil].
        index > value size ifTrue:[
            "/ this can happen ,if a wrapped method is not yet entered
            ^ nil
        ].
        ^ value at:index
    ].
    (type == #MethodVariable
    or:[type == #MethodArg
    or:[type == #BlockArg
    or:[type == #BlockVariable]]]) ifTrue:[
        ^ token variableValue
    ].
    (type == #InstanceVariable) ifTrue:[
        ^ value instVarAt:index
    ].
    (type == #JavaVariable) ifTrue:[
        nameSym := name asSymbolIfInterned.
        nameSym notNil ifTrue:[
            ^ JAVA at:name
        ].
"/        ^ nil.
        ^ Parser undefinedVariableError raiseRequestWith:name errorString:('undefined: ',name).
    ].
    (type == #GlobalVariable) ifTrue:[
        nameSym := name asSymbolIfInterned.
        nameSym notNil ifTrue:[
            (Smalltalk includesKey:nameSym) ifTrue:[
                ^ Smalltalk at:nameSym
            ]
        ].
"/        ^ nil.
        ^ Parser undefinedVariableError raiseRequestWith:name errorString:('undefined: ',name).
    ].
    (type == #ClassVariable) ifTrue:[
        ^ value classVarAt:name asSymbol
    ].
    (type == #ClassInstanceVariable) ifTrue:[
        ^ value instVarAt:index
    ].
    (type == #ThisContext) ifTrue:[
        value notNil ifTrue:[
            ^ value
        ].
        ^ thisContext
    ].
    (type == #PrivateClass) ifTrue:[
        ^ value privateClassesAt:name asSymbol
    ].
    (type == #PoolVariable) ifTrue:[
        ^ value classVarAt:name asSymbol
    ].

    "/ synthetic; for evaluation only
    (type == #EvaluationContextLocal
    or:[type == #EvaluationContextVar
    or:[type == #EvaluationContextArg]]) ifTrue:[
        (token isKindOf:Variable) ifFalse:[^ token ].    
        ^ token variableValue
    ].

    "/ synthetic; for evaluation only
    ((type == #WorkspaceVariable) or:[type == #DoItTemporary]) ifTrue:[
        ^ token value
    ].
    "/ synthetic; for evaluation only
    (type == #ThreadLocal) ifTrue:[
        ^ Processor activeProcess environmentAt:name asSymbol
    ].

    "not reached"
    self error:'internal error - bad variable type:' , type mayProceed:true.
    ^ value

    "Modified: / 11-09-2006 / 14:22:38 / User"
    "Modified: / 29-08-2013 / 01:19:53 / cg"
!

store:aValue
    (type == #ContextVariable) ifTrue:[
"/        value method isWrapped ifTrue:[
"/            self warn:'The method has not yet been entered (in breakpoint stub)\Please perform a singleStep first' withCRs.
"/            ^ aValue
"/        ].
        value at:index put:aValue. ^ aValue
    ].
    (type == #MethodVariable
    or:[type == #BlockVariable]) ifTrue:[
        token value:aValue. ^ aValue
    ].
    (type == #InstanceVariable) ifTrue:[
        ^ value instVarAt:index put:aValue
    ].
    (type == #GlobalVariable) ifTrue:[
        ^ Smalltalk at:name put:aValue
    ].
    (type == #ClassVariable) ifTrue:[
        ^ value classVarAt:name asSymbol put:aValue
    ].
    (type == #ClassInstanceVariable) ifTrue:[
        ^ value instVarAt:index put:aValue
    ].

    "/ synthetic; for evaluation only
    (type == #EvaluationContextLocal) ifTrue:[
        token value:aValue. ^ aValue
    ].
    ((type == #WorkspaceVariable) or:[type == #DoItTemporary]) ifTrue:[
        token value:aValue. ^ aValue
    ].
    (type == #ThreadLocal) ifTrue:[
        ^ Processor activeProcess environmentAt:name asSymbol put:aValue. ^ aValue
    ].

    "not reached"
    self error:'bad variable node type' mayProceed:true.
    ^ aValue

    "Modified: / 05-12-2011 / 18:43:56 / cg"
! !


!VariableNode methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPut:$(.
    self printOn:aGCOrStream. 
    aGCOrStream nextPut:$)

    "Modified (comment): / 22-02-2017 / 16:49:57 / cg"
!

printOn:aStream indent:i

    "/ actually only a debug-check
    (
    type == #ContextVariable              
    or:[type == #MethodArg            
    or:[type == #MethodVariable
    or:[type == #InstanceVariable
    or:[type == #BlockArg
    or:[type == #GlobalVariable
    or:[type == #JavaVariable
    or:[type == #ClassVariable
    or:[type == #PoolVariable
    or:[type == #BlockVariable
    or:[type == #PrivateClass
    or:[type == #WorkspaceVariable
    or:[type == #EvaluationContextArg
    or:[type == #EvaluationContextLocal
    or:[type == #ClassInstanceVariable]]]]]]]]]]]]]]) ifTrue:[
        aStream nextPutAll:name. ^ self
    ].
    (type == #ThisContext) ifTrue:[
        aStream nextPutAll:'thisContext'. ^ self
    ].
    "not reached"
    self error:'bad variable node type' mayProceed:true.

    "Modified: / 17.5.1998 / 00:17:12 / cg"
! !

!VariableNode methodsFor:'queries'!

canReuseAsArg:anotherNode
    anotherNode isVariable ifTrue:[
        anotherNode type ~~ type ifTrue:[^ false].

        (type == #ThisContext) ifTrue:[^ true].

        index notNil ifTrue:[
            anotherNode index ~~ index ifTrue:[^ false].
        ].
        (type == #MethodArg) ifTrue:[^ true].
        (type == #MethodVariable) ifTrue:[^ true].
        (type == #InstanceVariable) ifTrue:[^ true].

        name notNil ifTrue:[
            anotherNode name ~~ name ifTrue:[^ false].
        ].
        (type == #GlobalVariable) ifTrue:[^ true].
        (type == #ClassVariable) ifTrue:[^ true].
    ].
    ^ false

    "Created: 14.4.1996 / 00:46:18 / cg"
    "Modified: 14.4.1996 / 00:55:25 / cg"
!

indexIn: aCompiler
    (type == #MethodVariable) ifTrue:[
        ^ aCompiler methodVars indexOf:name.
    ].
    (type == #MethodArg) ifTrue:[
        ^ aCompiler methodArgs indexOf:name.
    ].
    ^ index

    "Created: / 06-08-2006 / 16:03:56 / cg"
! !

!VariableNode methodsFor:'testing'!

isArgument
    "return true, if this is a node for an argument (block or method)"

    ^ (type == #MethodArg) or:[type == #BlockArg]

    "Created: 27.6.1997 / 13:07:05 / cg"
    "Modified: 27.6.1997 / 13:07:19 / cg"
!

isBlockArg
    ^ type == #BlockArg
!

isBlockVariable
    ^ type == #BlockVariable
!

isClassVariable
    ^ type == #ClassVariable
!

isGlobal
    "return true, if this is a node for an existing!! global variable"

    ^ (type == #GlobalVariable) 
      and:[name isSymbol
      and:[Smalltalk includesKey:name]]

    "Modified: / 19.10.1998 / 19:43:04 / cg"
!

isGlobalNamed:nameWanted
    "return true, if this is a node for a particular global variable"

    ^ (type == #GlobalVariable) 
      and:[name = nameWanted
      and:[name isSymbol
      and:[Smalltalk includesKey:name]]]

    "Created: / 05-03-2007 / 13:35:07 / cg"
!

isGlobalVariable
    "return true, if this is a node for global variable"

    ^ type == #GlobalVariable
!

isInstance
    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ self isInstanceVariable
!

isInstanceVariable
    ^ type == #InstanceVariable
!

isInstanceVariableNamed:aString
    ^ (type == #InstanceVariable) and:[ name = aString ]
!

isJAVA
    "Return true, if receiver is global variable node JAVA.
     Used to highlight Java class references."

    ^ (type == #GlobalVariable) and:[name = 'JAVA']

    "Created: / 19-04-2012 / 09:38:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaPackageReference
    "Return true, given node is JAVA package reference in form:
        JAVA package1 package2 
    "

    ^self isJAVA

    "Created: / 19-04-2012 / 09:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isLocal
    "return true, if this is a node for a local (block or method) variable"

    ^ self isLocalVariable
!

isLocalVariable
    "return true, if this is a node for a local (block or method) variable"

    ^ (type == #MethodVariable) or:[type == #BlockVariable]
!

isMethodArg
    ^ type == #MethodArg
!

isMethodVariable
    ^ type == #MethodVariable
!

isPoolVariable
    ^ type == #PoolVariable
!

isUndeclared
    |sym|

    type == #PrivateClass ifTrue:[
        sym := (value name , '::' , name) asSymbolIfInterned.
        ^ sym isNil or:[(Smalltalk includesKey:sym) not].
    ].
    type == #GlobalVariable ifTrue:[
        sym := name asSymbolIfInterned.
        ^ sym isNil or:[(Smalltalk includesKey:sym) not]
    ].
    ^ false

    "Modified: / 05-09-2013 / 02:35:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVariable
    "return true, if this is a node for a variable"

    ^ true

    "Created: 14.4.1996 / 00:46:32 / cg"
! !

!VariableNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitVariableNode:self
! !

!VariableNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

