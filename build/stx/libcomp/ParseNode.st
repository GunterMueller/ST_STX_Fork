"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2018 Claus Gittinger
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

Object subclass:#ParseNode
	instanceVariableNames:'parent type comments parenthized startPosition endPosition
		attributes'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ParseNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2018 Claus Gittinger
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
    node for parse-trees; abstract class
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!ParseNode class methodsFor:'instance creation'!

type:t
    ^ (self basicNew) type:t
! !

!ParseNode methodsFor:'accessing'!

enclosingBlock
    "Return closest enclosing block node or nil"

    | block |
    block := parent.
    [ block notNil and:[block realNode isBlockNode not] ] whileTrue:[
        block := block realNode parent.
    ].
    ^block.

    "Created: / 16-02-2012 / 22:46:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endPosition
    "the node's last character position in the original source"

    ^ endPosition
!

endPosition:aCharacterPosition

    endPosition := aCharacterPosition

    "Modified: / 28-07-2011 / 10:03:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

line

    "Compatibility"

    ^self lineNumber

    "Created: / 09-07-2011 / 22:30:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumber

    ^nil

    "Created: / 09-07-2011 / 22:30:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumber:dummy
    "set linenumber - ignored here"

    ^ self
!

parent

    ^parent

    "Created: / 11-07-2011 / 17:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent: aParseNode

    parent := aParseNode

    "Created: / 11-07-2011 / 17:36:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parenthesized
    ^ parenthized ? false
!

parenthesized:aBoolean
    parenthized := aBoolean
!

parenthized
    "obsolete - typo in message name - use parenthesized"

    ^ parenthized ? false
!

parenthized:aBoolean
    "obsolete - typo in message name - use parenthesized:"

    parenthized := aBoolean
!

realNode
    ^ self
!

selectorPartPositions:selectorPartPositions
    "/ ignored here, but implemented because sent without checking 
    "/ when parsing keyword messages to an optimized messageNode
    "/ (which become optimized to a constantNode by the folder)

    "Created: / 28-08-2013 / 21:17:22 / cg"
!

selectorPosition:aCharacterPosition
    "ignored here"

    "Created: 5.8.1997 / 16:32:17 / cg"
!

startPosition
    "the node's character position in the original source"

    ^ startPosition
!

startPosition:start

    startPosition := start

    "Modified: / 08-04-2011 / 22:03:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startPosition:start endPosition: end

    startPosition := start.
    endPosition := end.
    ^self

    "Created: / 11-07-2011 / 17:44:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    "return the nodes type"

    ^ type
! !

!ParseNode methodsFor:'attributes access'!

objectAttributes

    ^attributes

    "Created: / 09-07-2011 / 12:17:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

objectAttributes: anObject

    attributes := anObject

    "Created: / 09-07-2011 / 12:18:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'checks'!

plausibilityCheckIn:aParser
    ^ nil
! !

!ParseNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "generate code for this statement - value not needed"

    self codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut:#drop
!

codeForSimpleReturnOn:aStream inBlock:b lineNumber:lineNrOrNil for:aCompiler
    "generate code to return myself as a simple method return"

    self codeOn:aStream inBlock:b for:aCompiler.
    lineNrOrNil notNil ifTrue:[
        self codeLineNumber:lineNrOrNil on:aStream for:aCompiler
    ].
    aStream nextPut:#retTop.


!

codeInlineOn:aStream inBlock:b valueNeeded:valueNeeded for:aCompiler
    "generate code for this statement - value is needed"

    self codeOn:aStream inBlock:b for:aCompiler.
!

codeLineNumber:nr on:codeStream for:aCompiler
    "generate lineNumber information"

    aCompiler codeLineNumber:nr on:codeStream
!

codeOn:aStream inBlock:codeBlock for:aCompiler
    ^ self subclassResponsibility
!

codeSourcePosition:nr on:codeStream for:aCompiler
    "generate source position information"

    aCompiler codeSourcePosition:nr on:codeStream

    "Created: / 31-05-2015 / 03:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'code generation helpers'!

emitPushGlobalWithLiteralIndex:litIndex on:aTokenCodeStream for:aCompiler
    litIndex <= 255 ifTrue:[
        aTokenCodeStream nextPut:#pushGlobalS; nextPut:litIndex
    ] ifFalse:[
        litIndex <= 16rFFFF ifTrue:[
            aTokenCodeStream nextPut:#pushGlobalL; nextPut:litIndex; nextPut:0
        ] ifFalse:[
            aTokenCodeStream nextPut:#pushGlobalVL; nextPut:0; nextPut:litIndex; nextPut:0; nextPut:0; nextPut:0
        ].
    ].
!

emitPushLiteral:value on:aTokenCodeStream for:aCompiler
    |index|

    index := aCompiler addLiteral:value.
    self emitPushLiteralIndex:index on:aTokenCodeStream for:aCompiler
!

emitPushLiteralIndex:index on:aTokenCodeStream for:aCompiler
    index <= 8 ifTrue:[
        aTokenCodeStream 
            nextPut:(#(pushLit1 pushLit2 pushLit3 pushLit4
                       pushLit5 pushLit6 pushLit7 pushLit8) at:index).
    ] ifFalse:[
        index <= 255 ifTrue:[
            aTokenCodeStream nextPut:#pushLitS; nextPut:index
        ] ifFalse:[
            index <= 16rFFFF ifTrue:[
                aTokenCodeStream nextPut:#pushLitL; nextPut:index; nextPut:0
            ] ifFalse:[
                aTokenCodeStream nextPut:#pushLitVL; nextPut:0; nextPut:index; nextPut:0; nextPut:0; nextPut:0
            ]
        ].
    ].
!

emitSendLiteralIndex:litIndex numArgs:nargs line:lineNr on:aStream for:aCompiler
    lineNr >= 255 ifTrue:[
        self codeLineNumber: lineNr on: aStream for:aCompiler.  
    ].
    (litIndex <= 255) ifTrue:[
        nargs <= 3 ifTrue:[
            aStream 
                nextPut:(#(send0 send1 send2 send3) at:(nargs+1)); nextPut:lineNr; 
                nextPut:litIndex.
            ^ self.
        ].
        aStream 
            nextPut:#send; nextPut:lineNr; 
            nextPut:litIndex; 
            nextPut:nargs.
        ^ self.
    ].

    (litIndex <= 16rFFFF) ifTrue:[
        aStream 
            nextPut:#sendL; nextPut:lineNr; 
            nextPut:litIndex; nextPut:0; 
            nextPut:nargs.
        ^ self.
    ].

    aStream 
        nextPut:#sendVL; nextPut:0; nextPut:lineNr; 
        nextPut:litIndex; nextPut:0; nextPut:0; nextPut:0; 
        nextPut:nargs.

    "Modified: / 13-04-2013 / 11:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

emitStoreGlobalWithLiteralIndex:litIndex on:aTokenCodeStream for:aCompiler
    litIndex <= 255 ifTrue:[
        aTokenCodeStream nextPut:#storeGlobalS; nextPut:litIndex
    ] ifFalse:[
        litIndex <= 16rFFFF ifTrue:[
            aTokenCodeStream nextPut:#storeGlobalL; nextPut:litIndex; nextPut:0
        ] ifFalse:[
            aTokenCodeStream nextPut:#storeGlobalVL; nextPut:0; nextPut:litIndex; nextPut:0; nextPut:0; nextPut:0; nextPut:0
        ].
    ].
!

emitSuperSendLiteralIndex:litIndex classLiteralIndex:clsLitIndex numArgs:nargs line:lineNr on:aStream for:aCompiler
    lineNr >= 255 ifTrue:[
        self codeLineNumber: lineNr on: aStream for:aCompiler.  
    ].
    (litIndex <= 255 and:[clsLitIndex <= 255]) ifTrue:[
        aStream 
            nextPut:#superSend; nextPut:lineNr; 
            nextPut:litIndex; 
            nextPut:nargs; 
            nextPut:clsLitIndex.
    ] ifFalse:[
        (litIndex <= 16rFFFF and:[clsLitIndex <= 16rFFFF]) ifTrue:[
            aStream 
                nextPut:#superSendL; nextPut:lineNr; 
                nextPut:litIndex; nextPut:0; 
                nextPut:nargs; 
                nextPut:clsLitIndex; nextPut:0.
        ] ifFalse:[
            aStream 
                nextPut:#superSendVL; nextPut:0; nextPut:lineNr; 
                nextPut:litIndex; nextPut:0; nextPut:0; nextPut:0;
                nextPut:nargs; 
                nextPut:clsLitIndex; nextPut:0; nextPut:0; nextPut:0.
        ].
    ].

    "Modified: / 13-04-2013 / 11:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'enumeration'!

allNodesDo:aBlock
    "evaluate aBlock for each variable-node here and in subnodes"

    aBlock value:self.
    self allSubNodesDo:aBlock.
!

allSubNodesDo:aBlock
    "/ self subclassResponsibility.
!

messageNodesDo:aBlock
    "evaluate aBlock for each message-node here and in subnodes"

    self messagesDo:aBlock
!

messageSelectors
    "return a collection of message selectors"

    |setOfSymbols|

    setOfSymbols := Set new.
    self messageSelectorsDo:[:each | setOfSymbols add:each ].
    ^ setOfSymbols
!

messageSelectorsDo:aBlock
    "evaluate aBlock for each message-selector here and in subnodes"

    ^ self
!

messages
    "return a collection of messageNodes"

    |setOfMessages|

    setOfMessages := Set new.
    self messagesDo:[:each | setOfMessages add:each ].
    ^ setOfMessages
!

messagesDo:aBlock
    "evaluate aBlock for each message-node here and in subnodes"

    ^ self
!

variableNodesDo:aBlock
    "evaluate aBlock for each variable-node here and in subnodes"

    ^ self
! !

!ParseNode methodsFor:'evaluation'!

evaluate
    ^ self evaluateIn:nil
!

evaluateForCascade
    ^ self evaluateForCascadeIn:nil
!

evaluateForCascadeIn:anEnvironment
    ^ self evaluateIn:anEnvironment
!

evaluateIn:anEnvironment
    self subclassResponsibility
!

isStatement
^false.

    "Created: / 22-02-2011 / 16:29:50 / Jakub <zelenja7@fel.cvut.cz>"
! !

!ParseNode methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    self printOn:aStream indent:0
!

printOn:aStream indent:indent
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    self subclassResponsibility

    "Created: / 20-04-2005 / 14:21:46 / cg"
!

printOn:aStream indent:indent parenthized:parenthized
    parenthized ifTrue:[
        aStream nextPutAll:'('
    ].
    self printOn:aStream indent:indent.
    parenthized ifTrue:[
        aStream nextPutAll:')'
    ].

    "Created: / 20-04-2005 / 14:21:28 / cg"
! !

!ParseNode methodsFor:'private'!

type:t
    "set the nodes type"

    type := t
! !

!ParseNode methodsFor:'queries'!

canReuseAsArg:anotherNode
    ^ false

    "Created: 14.4.1996 / 00:43:08 / cg"
!

collectBlocksInto:aCollection
    ^ self

    "Created: 23.10.1996 / 15:45:00 / cg"
!

containsReturn
    ^ false
!

positionToInsertPeriodForStatementSeparation
    ^ self endPosition + (parenthized == true ifTrue:1 ifFalse:0)

    "Created: 14.4.1996 / 00:43:08 / cg"
!

precedence
    ^ 9999
!

withConstantValueDo:aBlock
    "return true, if this evaluates to a constant value
     and evaluate aBlock with it"

    ^ false
! !

!ParseNode methodsFor:'testing'!

isAssignment
    "return true, if this is a node for an assignment"

    ^ false
!

isBinaryMessage
    "return true, if this is a node for a binary send"

    ^ false
!

isBlockNode
    "return true, if this is a node for a block"

    ^ false
!

isBreakPointNode
    ^ false

    "Created: / 05-07-2011 / 21:14:01 / cg"
!

isCascade
    ^ false

    "Created: / 16.7.1998 / 20:11:33 / cg"
!

isCascadeToSuper
    ^ false

    "Created: / 16.7.1998 / 19:51:07 / cg"
!

isConstant
    "return true, if this is a node for a constant"

    ^ false
!

isErrorNode
    ^ false
!

isGlobal
    "return true, if this is a node for a global variable"

    ^ false
!

isGlobalNamed:globalName
    "return true, if this is a node for a particular global variable"

    ^ false

    "Created: / 05-03-2007 / 15:13:23 / cg"
!

isGlobalVariable
    ^ false
!

isImmutable
    "not used with ST/X - 
     for JavaScript nodes return true here."

    ^ true
!

isImplicitJavaScriptMessage
    "return true, if this is a node for an implicit getter/setter send"

    ^ false

    "Created: / 05-07-2010 / 14:11:41 / cg"
!

isInnerFunction
    ^ false
!

isInnerJavaScriptBlock
    ^ false
!

isJAVA
    "Return true, if receiver is global variable node JAVA.
     Used to highlight Java class references."

    ^false

    "Created: / 19-04-2012 / 09:36:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaPackageReference
    "Return true, given node is JAVA package reference in form:
        JAVA package1 package2 
    "

    ^false

    "Created: / 19-04-2012 / 09:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaScriptAndExpression
    ^ false
!

isJavaScriptArrayAccess
    "return true, if this is a node for a javascript array reference i.e. expr[]"

    ^ false

    "Created: / 05-07-2010 / 14:04:27 / cg"
!

isJavaScriptBlock
    "return true, if this is a node for a javascript block"

    ^ false

    "Created: / 09-06-2010 / 01:53:19 / cg"
!

isJavaScriptClassNode
    ^ false
!

isJavaScriptConditionalExpression
    "return true, if this is a node for a ?: expression"

    ^ false

    "Created: / 09-06-2010 / 01:55:15 / cg"
!

isJavaScriptOrExpression
    ^ false
!

isLiteral
    "for compatibility with RB-AST"

    ^ self isConstant
!

isLocalVariable
    ^ false
!

isMessage
    "return true, if this is a node for a message expression"

    ^ false
!

isMethodNode
    ^ false
!

isMethodVariable
    ^ false
!

isNew
    "return true, if this is a new XXXX node"

    ^ false
!

isPostIncDec
    "for JavaScript"

    ^ false
!

isPreIncDec
    "for JavaScript"

    ^ false
!

isPrimary
    "return true, if this is a node for a primary (i.e. non-send)"

    ^ false
!

isReturnNode
    "return true, if this is a node for a return expression"

    ^ false
!

isSelector
    "return true, if this is a selector-node"

    ^ false
!

isSelf
    "return true, if this is a self-node"

    ^ false
!

isStatementNode
    "return true, if this is a statement node"
    
    ^ false

    "Created: / 13-06-2011 / 11:26:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSuper
    "return true, if this is a super-node"

    ^ false
!

isThis
    "for JavaScript"

    ^ false
!

isUnaryMessage
    "return true, if this is a node for a unary send"

    ^ false
!

isVariable
    "return true, if this is a node for a variable"

    ^ false

    "Created: 14.4.1996 / 00:46:44 / cg"
!

isVariableNode
    "return true, if this is a node for a variable"

    ^ self isVariable

    "Created: / 12-09-2011 / 09:32:17 / cg"
! !

!ParseNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

