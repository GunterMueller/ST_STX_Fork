"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

ParseNode subclass:#BlockNode
	instanceVariableNames:'blockArgs statements home inlineBlock exitBlock blockVars
		needsHome lineNr endLineNr blockArgAccessedInBlock numTemp
		maxNumTemp indexOfFirstTemp subBlocks accessedOuterBlockVars
		possiblyInlined invocationSelector charStartIndex charEndIndex
		index inlined endPointIndex modifiedBlockVars'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!BlockNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
    node for parse-trees, representing blocks
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!BlockNode class methodsFor:'instance creation'!

arguments:argList home:homeBlock 
    |newBlock|

    newBlock := (self basicNew) setArguments:argList home:homeBlock.
    homeBlock notNil ifTrue:[
        homeBlock rememberSubBlock:newBlock
    ].
    ^ newBlock

    "Modified: 28.6.1997 / 15:14:45 / cg"
!

arguments:argList home:homeBlock variables:vars
    |newBlock|

    newBlock := self arguments:argList home:homeBlock.
    newBlock variables:vars.
    ^ newBlock
!

home:homeBlock 
    |newBlock|

    newBlock := (self basicNew) setHome:homeBlock.
    homeBlock notNil ifTrue:[
        homeBlock rememberSubBlock:newBlock
    ].
    ^ newBlock

    "Modified: 28.6.1997 / 15:14:45 / cg"
!

withExpression:exprNode in:home
    "a utility function for code generators"

    ^ (self arguments:#() home:home variables:#())
        statements:(StatementNode new expression:exprNode)

    "Created: / 25-10-2011 / 17:44:05 / cg"
! !

!BlockNode methodsFor:'accessing'!

accessedOuterBlockVars
    "return a collection of outer blockVars/args which are accessed
     in this block"

    ^ accessedOuterBlockVars ? #()

    "Modified: 18.6.1997 / 12:06:31 / cg"
    "Created: 2.7.1997 / 17:29:56 / cg"
!

arguments
    ^ blockArgs
!

arguments:argList
    blockArgs := argList
!

blockArgAccessed
    "return true if any block argument is accessed in the block"

    ^ blockArgAccessedInBlock ? false

    "Modified: 18.6.1997 / 12:06:31 / cg"
!

blockArgAccessed:aBoolen
    "set/clear the flag stating if any block argument is accessed in the block"

    blockArgAccessedInBlock := aBoolen

    "Created: 18.6.1997 / 11:35:00 / cg"
    "Modified: 18.6.1997 / 12:06:43 / cg"
!

charEndIndex
    ^ charEndIndex
!

charEndIndex:something
    charEndIndex := something.
!

charStartIndex
    ^ charStartIndex
!

charStartIndex:something
    charStartIndex := something.
!

endLineNumber
    ^ endLineNr

    "Created: 23.10.1996 / 15:51:32 / cg"
!

endLineNumber:aNumber
    endLineNr := aNumber

    "Created: 21.10.1996 / 14:17:57 / cg"
!

endPointIndex
    ^ endPointIndex
!

endPointIndex:something
    endPointIndex := something.
!

firstStatement
    statements isNil ifTrue:[^ nil].
    ^ statements "sigh - its a linked list"
!

home
    ^ home
!

home:aBlock
    home := aBlock
!

indexOfFirstTemp:index
    indexOfFirstTemp := index

    "Created: 25.6.1997 / 17:24:27 / cg"
!

inlineBlock:aBoolean
    inlineBlock := aBoolean
!

invocationSelector
    "the selector, by which this block is invoked"

    ^ invocationSelector

    "Created: / 27-04-2010 / 11:56:22 / cg"
!

invokationSelector
    <resource: #obsolete>
    ^ invocationSelector

    "Created: / 02-04-1998 / 15:00:06 / cg"
    "Modified: / 27-04-2010 / 11:56:44 / cg"
!

isInlineBlock
    ^ (inlineBlock == true)

    "Created: / 25-06-1997 / 14:11:33 / cg"
!

lastStatement
    statements isNil ifTrue:[^ nil].
    ^ statements last "sigh - its a linked list"
!

lineNumber
    ^ lineNr

    "Created: 23.10.1996 / 15:51:50 / cg"
!

lineNumber:aNumber
    lineNr := aNumber
!

lineNumberOfFirstMessage
    ^ statements lineNumberOfFirstMessage

    "Created: 23.10.1996 / 15:51:50 / cg"
!

needsHome
    ^ needsHome
!

needsHome:aBoolean
    needsHome := aBoolean
!

nestingLevel    
    ^ home isNil ifTrue:[ 0 ] ifFalse:[ home nestingLevel + 1]

    "Created: / 15-01-2008 / 11:54:57 / cg"
!

possiblyInlined:aBoolean
    possiblyInlined := aBoolean

    "Created: 2.7.1997 / 11:32:00 / cg"
!

possiblyInlined:aBoolean withSelector:selector
    possiblyInlined := aBoolean.
    invocationSelector := selector.

    "Created: / 02-04-1998 / 19:07:53 / cg"
    "Modified: / 27-04-2010 / 11:56:51 / cg"
!

statements
    ^ statements
!

statements:s

    statements notNil ifTrue:[statements parent: nil].
    statements := s.
    statements notNil ifTrue:[statements parent: self].

    "Modified: / 20-07-2011 / 19:49:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variables
    ^ blockVars
!

variables:varList
    blockVars := varList
!

variablesIncludingInlined: forStcCompiledCode
    "Returns all my local variables including those of block inlined into
     the receiver. If `forStcCompiledCode` is true then assume
     the code is compiled by stc, otherwise assume the code is
     compiled by bytecode compiler"

    | myBlocks myInlinedBlocks |

    myBlocks := OrderedCollection new.
    self collectBlocksInto: myBlocks.
    myInlinedBlocks := myBlocks select:[:block | block isInlinedInto: self assumeStcCompiled: forStcCompiledCode. ].
    ^ myInlinedBlocks notEmpty ifTrue:[
        OrderedCollection streamContents:[:s|
            s nextPutAll: blockVars ? #().
            myInlinedBlocks do:[:block | 
                s nextPutAll: block arguments ? #().   
                s nextPutAll: block variables ? #() 
            ].
        ]
    ] ifFalse:[
        blockVars
    ].

    "Created: / 19-08-2013 / 11:37:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-12-2015 / 12:51:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BlockNode methodsFor:'block messages'!

doesNotUnderstand:aMessage
    |numArgs kludgeBlock|

    (Block includesSelector:(aMessage selector)) ifTrue:[
        "/ mhmh - a message which I don't understand, but Block implements
        "/  send it to a kludgeblock, which will evaluate me again ..."

        numArgs := blockArgs size.
        numArgs == 0 ifTrue:[
            kludgeBlock := [self value]
        ] ifFalse:[
            numArgs == 1 ifTrue:[
                kludgeBlock := [:a1 | self value:a1].
            ] ifFalse:[
                numArgs == 2 ifTrue:[
                    kludgeBlock := [:a1 :a2 | self value:a1 value:a2].
                ] ifFalse:[
                    numArgs == 3 ifTrue:[
                        kludgeBlock := [:a1 :a2 :a3| self value:a1 value:a2 value:a3].
                    ] ifFalse:[
                        numArgs == 4 ifTrue:[
                            kludgeBlock := [:a1 :a2 :a3 :a4| self value:a1 value:a2 value:a3 value:a4].
                        ] ifFalse:[
                            ^ self error:'only support blocks with up-to 4 args'
                        ]
                    ]
                ]
            ]
        ].
        ^ aMessage sendTo:kludgeBlock.
    ].
    ^ super doesNotUnderstand:aMessage
! !

!BlockNode methodsFor:'code generation'!

checkForSimpleBlockCodeOn:aStream for:aCompiler
    "simple things can be made cheap blocks right now -
     resulting in a simple pushLit instruction ...
     Return:
        true         -- bytecodes are on aStream
        aParseNode   -- Parsenode creating the cheap block
        nil          -- cheap block not possible
    "

    <ignore: RBReturnsBooleanAndOtherRule rationale: 'done by purpose' author: 'cg'>
    
    |cheapy val isConstRet singleInsn code stackSize|

    isConstRet := false.
        
    statements isNil ifTrue:[
        self argumentCount == 0 ifTrue:[
            "a []-block"
            aStream nextPut:#mkNilBlock.
            ^ true.
        ].
        val := nil.
        isConstRet := true.
    ] ifFalse:[
        statements isConstant ifTrue:[
            val := statements expression value.
            self numArgs == 0 ifTrue:[
                val == 0 ifTrue:[
                    aStream nextPut:#mk0Block.
                    ^ true.
                ].
                val isNil ifTrue:[
                    aStream nextPut:#mkNilBlock.
                    ^ true.
                ].
            ].    
            isConstRet := true.
        ]
    ].

    isConstRet ifTrue:[
        stackSize := 0.

        (val isInteger and:[val between:-128 and:127]) ifTrue:[
            "a [-128..127]-block"
            val < 0 ifTrue:[val := val + 256].
            code := ByteArray with:(ByteCodeCompiler byteCodeFor:#retNum)
                              with:val.
        ] ifFalse:[val == true ifTrue:[
            "a [true]-block"
            singleInsn := #retTrue
        ] ifFalse:[val == false ifTrue:[
            "a [false]-block"
            singleInsn := #retFalse
        ] ifFalse:[val isNil ifTrue:[
            "a [nil]-block"
            singleInsn := #retNil
        ]]]].
        singleInsn notNil ifTrue:[
            code := ByteArray with:(ByteCodeCompiler byteCodeFor:singleInsn).
        ].
    ].

    code notNil ifTrue:[
        cheapy := CheapBlock
                    byteCode:code
                    numArgs:(blockArgs size)
                    numVars:0
                    numStack:stackSize
                    sourcePosition:startPosition
                    initialPC:nil 
                    literals:nil.
        ^ ConstantNode type:#Block value:cheapy.
    ].

    ^ nil

    "Modified: / 16-07-2017 / 13:30:41 / cg"
!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "generate code for this statement - value not needed.
     For blocks, no code is generated at all."

    aCompiler 
        warning:(statements isNil 
                    ifTrue:[ 'useless empty block.' ]
                    ifFalse:[ 'useless block - the statement(s) inside will not be evaluated.' ])
        position:startPosition to:endPosition.
    ^ self
!

codeInlineOn:aStream inBlock:b for:aCompiler
    self codeInlineOn:aStream inBlock:b valueNeeded:true for:aCompiler
!

codeInlineOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    |thisStatement nextStatement tmpIndex firstTempIndex codeBlock subAccess|

    blockVars notNil ifTrue:[
        "/ have to move blockvars into surrounding context

        "/ find the first non-inlined block
        codeBlock := b.
        [codeBlock notNil and:[codeBlock isInlineBlock]] whileTrue:[
            codeBlock := codeBlock home.
        ].

        blockVars do:[:aBlockVar |
            codeBlock isNil ifTrue:[
                "/ in method - add more temps to the method
                tmpIndex := aCompiler addTempVar.
            ] ifFalse:[
                "/ in another block - add more temps to the block
                tmpIndex := codeBlock addTempVar
            ].

            firstTempIndex isNil ifTrue:[
                firstTempIndex := tmpIndex.
                indexOfFirstTemp isNil ifTrue:[
                    indexOfFirstTemp := tmpIndex
                ].
            ].

            "/ block vars must be nilled 
            "/ (in case the previous block left some value there).
            "/ This nilling should be optimized away, if
            "/ the variable gets a value assigned before the first send.

            aStream nextPut:#pushNil.
            codeBlock isNil ifTrue:[
                "/ in method
                (tmpIndex <= 6) ifTrue:[
                    aStream nextPut:(#(storeMethodVar1 storeMethodVar2
                                       storeMethodVar3 storeMethodVar4
                                       storeMethodVar5 storeMethodVar6) at:tmpIndex).
                ] ifFalse:[
                    aStream nextPut:#storeMethodVar; nextPut:tmpIndex.
                ]
            ] ifFalse:[
                "/ in another block
                aStream nextPut:#storeBlockVar; nextPut:tmpIndex.
            ]
        ].
    ].

    inlineBlock := true.

    statements isNil ifTrue:[
        valueNeeded ifTrue:[
            aStream nextPut:#pushNil
        ]
    ] ifFalse:[
        thisStatement := statements.
        [thisStatement notNil] whileTrue:[
            nextStatement := thisStatement nextStatement.
            (nextStatement notNil or:[valueNeeded not]) ifTrue:[
                thisStatement codeForSideEffectOn:aStream inBlock:b for:aCompiler
            ] ifFalse:[
                thisStatement codeOn:aStream inBlock:b for:aCompiler
            ].
            thisStatement := nextStatement
        ]
    ].

"/    endLineNr notNil ifTrue:[
"/        ParseNode codeLineNumber:endLineNr on:aStream for:aCompiler
"/    ].

    "/ pop off temps (blockVars).
    "/ also, they are nilled to prevent any temp stuff
    "/ from NOT being garbage collected.
    "/ could optimize here, temps are reused soon.

    blockVars notNil ifTrue:[
        "/ if any subblock refers to locals or args,
        "/ do not nil out ...
        subAccess := false.
        self allSubBlocksDo:[:aSubBlockNode | 
            aSubBlockNode accessedOuterBlockVars do:[:aVarNode |
                |b|

                aVarNode block == self ifTrue:[
                    subAccess := true
                ]
            ]
        ].
        subAccess ifFalse:[
            tmpIndex := firstTempIndex.

            blockVars do:[:dummy |
                aStream nextPut:#pushNil.
                codeBlock isNil ifTrue:[
                    aStream nextPut:#storeMethodVar; nextPut:tmpIndex.
                    aCompiler removeTempVar.
                ] ifFalse:[
                    aStream nextPut:#storeBlockVar; nextPut:tmpIndex.
                    codeBlock removeTempVar.
                ].
                tmpIndex := tmpIndex + 1.
            ].    
        ].    
    ].

    "Modified: 30.7.1997 / 12:21:07 / cg"
!

codeOn:aStream inBlock:b for:aCompiler
    |thisStatement nextStatement lastStatement pos code cheapy|

    cheapy := self checkForSimpleBlockCodeOn:aStream for:aCompiler.
    cheapy notNil ifTrue:[
        "if result == true - code is already on aStream"
        cheapy ~~ true ifTrue:[
            cheapy codeOn:aStream inBlock:b for:aCompiler.
        ].
        ^ self
    ].

    "cheap block detection filters out blocks with no statements"

    "/ Do not encode source position if not available.
    "/ Note, that JavaScriptCompiler has no sourceposX pseudo instruction
    "/ support, so in this case, do not emit it.
    (startPosition notNil and:[ (aCompiler isKindOf: (Smalltalk at:#JavaScriptCompiler)) not]) ifTrue:[ 
        self codeSourcePosition: startPosition on: aStream for: aCompiler.
    ].

    pos := aStream position.

    aStream nextPut:#makeBlock.                                 "+0"
    aStream nextPut:0."/block's bytecode end index,patched later"+1"
    aStream nextPut:(blockVars size + (maxNumTemp?0)).          "+2"
    aStream nextPut:(blockArgs size).                           "+3"
                                                                "+4"
    thisStatement := statements.
    [thisStatement notNil] whileTrue:[
        nextStatement := thisStatement nextStatement.
        nextStatement notNil ifTrue:[
            thisStatement codeForSideEffectOn:aStream inBlock:self for:aCompiler
        ] ifFalse:[
            lastStatement := thisStatement
        ].
        thisStatement := nextStatement
    ].

    lastStatement 
            codeForSimpleReturnOn:aStream
            inBlock:self 
            lineNumber:endLineNr 
            for:aCompiler.

    code := aStream contents.

    "/ sigh - during coding, inlined subBlocks may have added more
    "/ tempVars; patch the nvar byte ...

    code at:pos+3 put:(blockVars size + (maxNumTemp?0)).

    "set the end of the block's code"
    code at:pos+2 put:(aStream position + 1)

    "Modified: / 26-06-1997 / 10:48:56 / cg"
    "Modified: / 05-05-2016 / 00:13:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BlockNode methodsFor:'code generation helpers'!

addTempVar
    "add a temporary variable; return its position (1-based).
     Used when a block with args/locals is inlined."

    (inlineBlock == true) ifTrue:[
        self error:'addTempVar to inlineBlock - should not happen'
    ].

    numTemp isNil ifTrue:[numTemp := maxNumTemp := 0].
    numTemp := numTemp + 1.
    maxNumTemp := maxNumTemp max:numTemp.
    ^ numTemp + self numVars

    "Modified: / 25-10-2011 / 16:49:50 / cg"
!

removeTempVar
    "remove a temporary variable"

    numTemp := numTemp - 1.

    "Created: 25.6.1997 / 14:04:20 / cg"
    "Modified: 25.6.1997 / 15:07:07 / cg"
! !

!BlockNode methodsFor:'enumerating'!

allSubBlocksDo:aBlock
    "recursively enumerate all of my subblocks"

    subBlocks notNil ifTrue:[
        subBlocks do:[:aSubBlockNode |
            aBlock value:aSubBlockNode.
            aSubBlockNode allSubBlocksDo:aBlock.
        ]
    ]

    "Created: 2.7.1997 / 10:51:59 / cg"
!

nodeDo:anEnumerator
    "helper for parse tree walking"

    |args|

    args := blockArgs ? #().
    args := args collect:[:var |
        |p|

        p := Variable name:var.
"/        p := ParameterNode new.
"/        p variable:var
    ].
    ^ anEnumerator doBlock:self arguments:args body:statements

    "Created: / 19-06-1997 / 16:38:30 / cg"
    "Modified: / 22-10-2006 / 12:03:27 / cg"
! !


!BlockNode methodsFor:'evaluation'!

evaluateIn:anEnvironment
    ^ self
!

exitWith:something
    "return via return-statement"

    home notNil ifTrue:[
	home exitWith:something
    ].
    exitBlock value:something.
    ^ something
!

value
    (blockArgs size ~~ 0) ifTrue:[
        ^ self wrongNumberOfArguments:0
    ].
    statements isNil ifTrue:[^ nil].
    exitBlock := [:val | ^ val].
    ^ statements evaluate
!

value:anArg
    |oldValue val|

    (blockArgs size ~~ 1) ifTrue:[
        ^ self wrongNumberOfArguments:1
    ].
    statements isNil ifTrue:[^ nil].

    oldValue := (blockArgs at:1) value.
    (blockArgs at:1) value:anArg.

    exitBlock := [:v | 
        (blockArgs at:1) value:oldValue.
        ^ v
    ].

    val := statements evaluate.

    (blockArgs at:1) value:oldValue.
    ^ val
!

value:arg1 value:arg2
    |oldValue1 oldValue2 val|

    (blockArgs size ~~ 2) ifTrue:[
        ^ self wrongNumberOfArguments:2
    ].
    statements isNil ifTrue:[^ nil].

    oldValue1 := (blockArgs at:1) value.
    oldValue2 := (blockArgs at:2) value.
    (blockArgs at:1) value:arg1.
    (blockArgs at:2) value:arg2.

    exitBlock := [:v | 
        (blockArgs at:1) value:oldValue1.
        (blockArgs at:2) value:oldValue2.
        ^ v
    ].

    val := statements evaluate.

    (blockArgs at:1) value:oldValue1.
    (blockArgs at:2) value:oldValue2.
    ^ val
!

value:arg1 value:arg2 value:arg3
    |oldValue1 oldValue2 oldValue3 val|

    (blockArgs size ~~ 3) ifTrue:[
        ^ self wrongNumberOfArguments:3
    ].
    statements isNil ifTrue:[^ nil].

    oldValue1 := (blockArgs at:1) value.
    oldValue2 := (blockArgs at:2) value.
    oldValue3 := (blockArgs at:3) value.
    (blockArgs at:1) value:arg1.
    (blockArgs at:2) value:arg2.
    (blockArgs at:3) value:arg3.

    exitBlock := [:v | 
        (blockArgs at:1) value:oldValue1.
        (blockArgs at:2) value:oldValue2.
        (blockArgs at:3) value:oldValue3.
        ^ v
    ].

    val := statements evaluate.

    (blockArgs at:1) value:oldValue1.
    (blockArgs at:2) value:oldValue2.
    (blockArgs at:3) value:oldValue3.
    ^ val
!

value:arg1 value:arg2 value:arg3 value:arg4
    |oldValue1 oldValue2 oldValue3 oldValue4 val|

    (blockArgs size ~~ 4) ifTrue:[
        ^ self wrongNumberOfArguments:4
    ].
    statements isNil ifTrue:[^ nil].

    oldValue1 := (blockArgs at:1) value.
    oldValue2 := (blockArgs at:2) value.
    oldValue3 := (blockArgs at:3) value.
    oldValue4 := (blockArgs at:4) value.
    (blockArgs at:1) value:arg1.
    (blockArgs at:2) value:arg2.
    (blockArgs at:3) value:arg3.
    (blockArgs at:4) value:arg4.

    exitBlock := [:v | 
        (blockArgs at:1) value:oldValue1.
        (blockArgs at:2) value:oldValue2.
        (blockArgs at:3) value:oldValue3.
        (blockArgs at:4) value:oldValue4.
        ^ v
    ].

    val := statements evaluate.

    (blockArgs at:1) value:oldValue1.
    (blockArgs at:2) value:oldValue2.
    (blockArgs at:3) value:oldValue3.
    (blockArgs at:4) value:oldValue4.
    ^ val
!

valueWithArguments:argArray
    |oldValues val|

    (blockArgs size ~~ argArray size) ifTrue:[
        ^ self wrongNumberOfArguments:argArray size
    ].
    statements isNil ifTrue:[^ nil].

    oldValues := Array new:(argArray size).
    1 to:argArray size do:[:i |
        oldValues at:i put:(blockArgs at:i) value.
        (blockArgs at:i) value:(argArray at:i).
    ].
    exitBlock := [:v | 
        1 to:argArray size do:[:i |
           ( blockArgs at:i) value:(oldValues at:i)
        ].
        ^ v
    ].

    val := statements evaluate.

    1 to:argArray size do:[:i |
        (blockArgs at:i) value:(oldValues at:i)
    ].
    ^ val
!

wrongNumberOfArguments:numArgsGiven
    "report that the number of arguments given does not match the number expected"

    WrongNumberOfArgumentsError
        raiseRequestWith:self
        errorString:('block got %1 arg(s) where %2 expected' 
                        bindWith:numArgsGiven
                        with:blockArgs size)

    "Modified: 8.7.1997 / 01:04:27 / stefan"
! !

!BlockNode methodsFor:'looping'!

whileFalse:aBlock
    self value ifTrue:[^ nil].
    aBlock value.
    thisContext restart
!

whileTrue:aBlock
    "evaluate the argument, aBlock while the receiver evaluates to true."

    self value ifFalse:[^ nil].
    aBlock value.
    thisContext restart

    "Modified: / 22-08-2006 / 14:40:48 / cg"
! !

!BlockNode methodsFor:'misc'!

rememberOuterBlockVarAccess:aVariableNode
    accessedOuterBlockVars isNil ifTrue:[
        accessedOuterBlockVars := OrderedCollection new.
    ].
    accessedOuterBlockVars add:aVariableNode

    "Modified: 2.7.1997 / 18:52:49 / cg"
!

rememberSubBlock:aBlockNode
    subBlocks isNil ifTrue:[
        subBlocks := OrderedCollection new.
    ].
    subBlocks add:aBlockNode

    "Created: 28.6.1997 / 15:13:20 / cg"
    "Modified: 2.7.1997 / 11:11:26 / cg"
! !

!BlockNode methodsFor:'printing & storing'!

printOn:aStream indent:i
    |n "{Class: SmallInteger }"|

    aStream nextPut:$[.
    (n := blockArgs size) > 0 ifTrue:[
        1 to:n do:[:index |
            aStream nextPut:$:.
            aStream nextPutAll:(blockArgs at:index) name.
            aStream space.
        ].
        aStream nextPutAll:'| '.
    ].
    (n := blockVars size) > 0 ifTrue:[
        aStream nextPut:$|.
        1 to:n do:[:index |
            aStream nextPutAll:(blockVars at:index) name.
            aStream space.
        ].
        aStream nextPut:$|.
    ].
    statements notNil ifTrue:[
        aStream cr.
        statements printAllOn:aStream indent:i + 4.
        aStream cr. 
        aStream spaces:i.
    ].
    aStream nextPut:$]
! !

!BlockNode methodsFor:'private-accessing'!

setArguments:argList home:h
    inlineBlock := false.
    needsHome := false.
    blockArgs := argList.
    home := h.
    numTemp := maxNumTemp := 0.
!

setArguments:argList home:h variables:vars
    inlineBlock := false.
    needsHome := false.
    blockArgs := argList.
    home := h.
    blockVars := vars.
    numTemp := maxNumTemp := 0.

    "Modified: 25.6.1997 / 15:07:52 / cg"
!

setHome:h
    inlineBlock := false.
    needsHome := false.
    home := h.
    numTemp := maxNumTemp := 0.
! !

!BlockNode methodsFor:'queries'!

argumentCount
    "ANSI alias for numArgs: return the number of arguments the block represented by myself
     expects for evaluation"

    ^ blockArgs size
!

collectBlocksInto:aCollection
     aCollection add:self.
     statements notNil ifTrue:[statements collectBlocksInto:aCollection]

    "Created: 23.10.1996 / 15:45:16 / cg"
    "Modified: 23.10.1996 / 16:02:57 / cg"
!

containsReturn
    statements isNil ifTrue:[
        ^ false
    ].
    ^ statements containsReturnInAnyStatement
!

endsWithReturn
    statements isNil ifTrue:[
        ^ false
    ].
    ^ statements listEndsWithReturn

    "Created: 19.8.1996 / 14:36:32 / cg"
!

indexOfFirstTemp
    indexOfFirstTemp isNil ifTrue:[ ^ self numVars ].
    ^ indexOfFirstTemp

    "Created: 25.6.1997 / 15:39:11 / cg"
!

isInlinable
    "return true, if the receiver is inlinable.
     For now, do NOT inline a block, if it has args/vars
     which are accessed by subblocks, which are themself
     not inlinable.
     This limitation is needed for the following piece of code to work:
        1 to:10 do:[:i |
            .... [ something with i ]
        ]
     If this block was inlined, each subblock would get the same i
     (which is the old ST/V behavior)"

    possiblyInlined == true ifFalse:[
        ^ false
    ].
    inlined == true ifTrue:[
        ^ true
    ].

    (self argumentCount ~~ 0 or:[self numVars ~~ 0]) ifTrue:[
        "/ any subblock, which accesses a var/arg of myself ?
        self allSubBlocksDo:[:aSubBlockNode | 
            aSubBlockNode accessedOuterBlockVars do:[:aVarNode |
                |b|

                aVarNode block == self ifTrue:[
                    "/ all-inbetween inlinable ?
                    b := aSubBlockNode.
                    [b ~~ self] whileTrue:[
                        b isInlinable ifFalse:[
"/ 'not inlined due to access: ' print. aVarNode displayString printCR.
                            ^ false
                        ].
                        b := b home
                    ]
                ]
            ]
        ]
    ].
    inlined := true.
    ^ true

    "Created: 2.7.1997 / 10:43:37 / cg"
    "Modified: 2.7.1997 / 18:55:36 / cg"
!

numArgs
    "return the number of arguments the block represented by myself
     expects for evaluation.
     Please use argumentCount, which is ANSI"

"/    <resource: #obsolete>

    ^ blockArgs size

    "Created: 23.10.1996 / 15:57:04 / cg"
    "Modified: 7.5.1997 / 15:34:35 / cg"
!

numVars
    "return the number of block local variables."
    
    ^ blockVars size

    "Created: 23.10.1996 / 16:17:07 / cg"
!

numVarsIncludingInlined: forStcCompiledCode
    "Returns number of local variables including those of blocks inlined into
     the receiver. If `forStcCompiledCode` is true then assume
     the code is compiled by stc, otherwise assume the code is
     compiled by bytecode compiler"

    ^ (self variablesIncludingInlined: forStcCompiledCode) size.

    "Created: / 22-12-2015 / 12:38:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

simpleSendBlockExpression
    blockVars notNil ifTrue:[^ nil].
    statements isNil ifTrue:[^ nil].
    statements nextStatement notNil ifTrue:[^ nil].
    ^ statements expression

    "Created: 13.12.1995 / 20:06:09 / cg"
! !

!BlockNode methodsFor:'statistics'!

modifiedLocalVars
    ^ modifiedBlockVars
!

rememberLocalModified:name
    modifiedBlockVars isNil ifTrue:[
        modifiedBlockVars := Set new.
    ].
    modifiedBlockVars add:name.
! !

!BlockNode methodsFor:'testing'!

isBlock
    "a kludge, to have blocknodes mimic blocks"

    ^ true
!

isBlockNode
    ^ true
!

isBlockWithArgumentCount:numArgsExpected
    "a kludge, to have blocknodes mimic blocks"

    ^ self numArgs == numArgsExpected

    "Created: / 11-07-2017 / 18:28:59 / cg"
!

isEmptyBlock
    ^ statements isNil
!

isInlinedInto: blockNode assumeStcCompiled: assumeStc
    "Returns true, if the receiver is inlined into given `blockNode`.
     If `assumeStc` is true. then assume the code is compiled by stc,
     otherwise assume that the code is compiled by the bytecode compiler"

    | enclosingBlock selector |

    self == blockNode ifTrue:[ ^ false ].
    enclosingBlock := self enclosingBlock.
    (enclosingBlock ~~ blockNode 
        and:[ (enclosingBlock isInlinedInto: blockNode assumeStcCompiled: assumeStc) not ])
        ifTrue:[ ^ false ].

    self parent isMessage ifFalse:[ ^ false ].
    selector := self parent selector.
    "/ Following control-flow selectors are inlined by both, 
    "/ stc and bytecode/jit compiler...
    (#(
            ifTrue:
            ifTrue:ifFalse:
            ifFalse:
            whileTrue
            whileTrue:
            whileFalse
            whileFalse:
            to:do:   
            "/ Add more here...
    ) includes: selector) ifTrue:[ ^ true ].
    ^ assumeStc ifTrue:[
        #(
            "/ Add more selectors inlined only by STC here...
        ) includes: selector
    ] ifFalse:[
        #(
            "/ Add more selector inline only by bytecode compiler here...
        ) includes: selector
    ]

    "Created: / 19-08-2013 / 12:00:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-12-2015 / 12:56:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaScriptBlock
    ^ false
!

isSingleExpressionBlock
    ^ statements notNil
    and:[ statements nextStatement isNil
    and:[ statements isSimpleExpression ]]
! !

!BlockNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitBlockNode:self
! !

!BlockNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id $'
! !

