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

PrimaryNode subclass:#ConstantNode
	instanceVariableNames:''
	classVariableNames:'TrueNode FalseNode NilNode Const0Node Const1Node Float0Node'
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ConstantNode class methodsFor:'documentation'!

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
    node for parse-trees, representing literal constants
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!ConstantNode class methodsFor:'instance creation'!

type:t value:val

    "/JV@2011-07-19: Changed not to share the nodes

    ^ (self basicNew) type:t value:val

"/    Old code    
"/    "some constant nodes are used so often, its worth caching them"
"/
"/    (t == #True) ifTrue:[
"/        TrueNode isNil ifTrue:[
"/            TrueNode := (self basicNew) type:t value:val
"/        ].
"/        ^ TrueNode
"/    ].
"/    (t == #False) ifTrue:[
"/        FalseNode isNil ifTrue:[
"/            FalseNode := (self basicNew) type:t value:val
"/        ].
"/        ^ FalseNode
"/    ].
"/    (t == #Nil) ifTrue:[
"/        NilNode isNil ifTrue:[
"/            NilNode := (self basicNew) type:t value:val
"/        ].
"/        ^ NilNode
"/    ].
"/    (t == #Integer) ifTrue:[
"/        (val == 0) ifTrue:[
"/            Const0Node isNil ifTrue:[
"/                Const0Node := (self basicNew) type:t value:val
"/            ].
"/            ^ Const0Node
"/        ].
"/        (val == 1) ifTrue:[
"/            Const1Node isNil ifTrue:[
"/                Const1Node := (self basicNew) type:t value:val
"/            ].
"/            ^ Const1Node
"/        ]
"/    ].
"/    (t == #Float) ifTrue:[
"/        (val = 0.0) ifTrue:[
"/            "/ care for negative0 (which compares = to 0.0)
"/            val isNegativeZero ifFalse:[
"/                Float0Node isNil ifTrue:[
"/                    Float0Node := (self basicNew) type:t value:val
"/                ].
"/                ^ Float0Node
"/            ]
"/        ]
"/    ].
"/    ^ (self basicNew) type:t value:val

    "Modified: / 19-07-2011 / 17:24:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type:t value:val from: startPos to: endPos

    ^(self basicNew)
        type: t value: val;
        startPosition: startPos
        endPosition: endPos;
        yourself

    "Created: / 19-07-2011 / 17:50:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value:val
    ^ self type:(self typeOfConstant:val) value:val 
! !

!ConstantNode class methodsFor:'queries'!

typeOfConstant:anObject
    "return the constantNode type for an object"

    "the most common case first ..."

    (anObject isMemberOf:SmallInteger) ifTrue:[
        ^ #Integer
    ].

    anObject isNil ifTrue:[
        ^ #Nil
    ].

    anObject isNumber ifTrue:[
        "the most common case first ..."
        (anObject isMemberOf:Float) ifTrue:[
            ^ #Float
        ].
        anObject isInteger ifTrue:[
            ^ #Integer
        ].
    ].
    (anObject == true) ifTrue:[
        ^ #True
    ].
    (anObject == false) ifTrue:[
        ^ #False
    ].
    ^ #Literal
! !

!ConstantNode methodsFor:'accessing'!

lineNumber:ignoredLineNumber

    "Created: / 14.5.1998 / 19:31:48 / cg"
! !

!ConstantNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "no code at all"

    "/ but remember symbolic literals (such as #TODO)
    value isSymbol ifTrue:[
        aCompiler addLiteral:value.
    ].
    ^ self

    "Modified: / 04-03-2007 / 15:29:54 / cg"
!

codeForSimpleReturnOn:aStream inBlock:b lineNumber:lineNrOrNil for:aCompiler
    lineNrOrNil notNil ifTrue:[
        self codeLineNumber:lineNrOrNil on:aStream for:aCompiler
    ].

    (type == #Nil) ifTrue:[
        aStream nextPut:#retNil.
        ^self
    ].
    (type == #True) ifTrue:[
        aStream nextPut:#retTrue.
        ^self
    ].
    (type == #False) ifTrue:[
        aStream nextPut:#retFalse.
        ^self
    ].

    (type == #Integer) ifTrue:[
        (value between: -128 and:127) ifTrue:[
            (value == 0) ifTrue:[
                aStream nextPut:#ret0.
                ^ self.
            ].
            aStream nextPut:#retNum; nextPut:value.
            ^ self
        ].
    ].

    "/ anything else must be pushed, then top returned

    self codeOn:aStream inBlock:b for:aCompiler.
    aStream nextPut:#retTop
!

codeOn:aStream inBlock:b for:aCompiler
    "generate code for the constant"

    |code index|

    (type == #Integer) ifTrue:[
        (value between: -128 and:127) ifTrue:[
            (value == 0) ifTrue:[
                code := #push0
            ].
            (value == 1) ifTrue:[
                code := #push1.
            ].
            (value == 2) ifTrue:[
                code := #push2.
            ].
            (value == -1) ifTrue:[
                code := #pushMinus1.
            ].
            code notNil ifTrue:[
                aStream nextPut:code. ^ self
            ].

            aStream nextPut:#pushNum; nextPut:value.
            ^ self
        ].
        (value between:16r-8000 and:16r7FFF) ifTrue:[
            aStream nextPut:#pushNum16; nextPut:value; nextPut:0. 
            ^ self
        ]
    ].
    (type == #Nil) ifTrue:[
        code := #pushNil.
    ].
    (type == #True) ifTrue:[
        code := #pushTrue.
    ].
    (type == #False) ifTrue:[
        code := #pushFalse.
    ].
    code notNil ifTrue:[
        aStream nextPut:code. ^ self
    ].

    "/ kludge for backward compatibility
    aCompiler isNil ifTrue:[
        self halt:'strange literal constant'.
        aStream nextPut:#pushLit; nextPut:value.
        ^ self.
    ].

    self emitPushLiteral:value on:aStream for:aCompiler
!

codeStoreOn:aStream inBlock:codeBlock valueNeeded:valueNeeded for:aCompiler
    "not sent - parser checks for this"

    ^ self error:'assignment to literals not allowed'
! !

!ConstantNode methodsFor:'enumerating'!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doLiteral:self value:value

    "Modified: 19.6.1997 / 16:40:59 / cg"
! !

!ConstantNode methodsFor:'evaluation'!

evaluate
    "exists for performance only"
    ^ value
!

evaluateIn:anEnvironment
    ^ value
!

store:aValue
    "not reached - parser checks for this"

    self error:'store not allowed'.
    ^ aValue
!

value
    "for compatibility with RB-AST"
    ^ value
! !

!ConstantNode methodsFor:'printing & storing'!

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

    value displayOn:aGCOrStream.

    "Modified (comment): / 22-02-2017 / 16:50:02 / cg"
!

printOn:aStream indent:i
    value storeOn:aStream
! !

!ConstantNode methodsFor:'queries'!

canReuseAsArg:anotherNode
    |otherValue|

    anotherNode isConstant ifTrue:[
        anotherNode type ~~ type ifTrue:[^ false].

        otherValue := anotherNode evaluate.
        (value isMemberOf:SmallInteger) ifTrue:[
            (value == 0) ifTrue:[^ false].
            (value == 1) ifTrue:[^ false].
            (value == 2) ifTrue:[^ false].
            (value == -1) ifTrue:[^ false].
            ^ otherValue == value
        ].
        (value isMemberOf:Float) ifTrue:[
            ^ (otherValue isMemberOf:Float)
              and:[otherValue = value]
        ].
        (value isMemberOf:Symbol) ifTrue:[
            ^ otherValue == value
        ].
        (value isSingleByteString) ifTrue:[
            ^ (otherValue isSingleByteString)
              and:[otherValue = value]
        ].
    ].
    ^ false

    "Created: 14.4.1996 / 00:43:14 / cg"
    "Modified: 14.4.1996 / 01:00:29 / cg"
!

withConstantValueDo:aBlock
    "return true, if this evaluates to a constant value
     and evaluate aBlock with it"

    aBlock value:value.
    ^ true
! !

!ConstantNode methodsFor:'testing'!

isConstant
    ^ true
! !

!ConstantNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitConstantNode:self
! !

!ConstantNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id $'
! !

