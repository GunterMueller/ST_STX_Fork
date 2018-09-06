"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBLiteralNode
	instanceVariableNames:'token'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBLiteralNode comment:'BRLiteralNode is an AST node that represents literals (e.g., #foo, #(1 2 3), true, etc.).

Instance Variables:
        token   <BRLiteralToken>        the token that contains the literal value as well as its source positions

'
!


!RBLiteralNode class methodsFor:'instance creation'!

literalToken: aLiteralToken 
        ^self new literalToken: aLiteralToken
!

value: aValue 
        ^self literalToken: (RBLiteralToken value: aValue)
! !

!RBLiteralNode methodsFor:'accessing'!

generatedCode
    ^ token realValue storeString
!

precedence
        ^0
!

startWithoutParentheses
        ^token start
!

stopWithoutParentheses
        ^token stop
!

token
        ^token
!

value
        ^token realValue
! !

!RBLiteralNode methodsFor:'comparing'!

= anObject 
        |myValue otherValue|

        self == anObject ifTrue: [^true].
        self class == anObject class ifFalse: [^false].
        myValue := self value.
        otherValue := anObject value.
        myValue class == otherValue class ifFalse: [
            (myValue isArray and:[otherValue isArray]) ifFalse:[
                ^false
            ].
        ].

        myValue isArray ifTrue:[
            myValue size == otherValue size ifFalse: [^false].
            myValue with:otherValue do:[:elHere :elThere |
                (elHere isLimitedPrecisionReal and:[elThere isLimitedPrecisionReal]) ifTrue:[
                    " avoid precision bug with floats "
                    (elHere printString = elThere printString) ifFalse:[^ false]
                ] ifFalse:[
                    (elHere = elThere) ifFalse:[^ false]
                ].
            ].
            ^ true.
        ].
        (myValue isLimitedPrecisionReal and:[otherValue isLimitedPrecisionReal]) ifTrue:[
            " avoid precision bug with floats "
            ^ (myValue printString = otherValue printString) 
        ].
        ^myValue = otherValue
!

hash
        ^self value hash
! !

!RBLiteralNode methodsFor:'enumeration'!

allLiteralNodesDo:aBlock
    aBlock value:self.
! !

!RBLiteralNode methodsFor:'initialization & release'!

literalToken: aLiteralToken 
        token := aLiteralToken
! !

!RBLiteralNode methodsFor:'matching'!

copyInContext: aDictionary
        ^self class literalToken: token removePositions
!

match: aNode inContext: aDictionary
        |nodesValue myValue|

        "/ ST/X: patternStringLiteral 
        token isPatternLiteral ifTrue:[
            (super match: aNode inContext: aDictionary) ifTrue:[^ true].

            aNode isLiteral ifTrue:[
                ('foo' respondsTo:#matchesRegex:) ifFalse:[
                    "/ mhm - the regex package seems to be not loaded...
                    Smalltalk loadPackage:'stx:goodies/regex'.
                    ('foo' respondsTo:#matchesRegex:) ifFalse:[
                        self error:'the regex package is missing' mayProceed:true.
                    ].
                ].

                nodesValue := aNode value.
                myValue := self value.
                (nodesValue isString and:[nodesValue isSymbol not]) ifTrue:[
                    ^ nodesValue matchesRegex: myValue 
                ].
                token recurse ifTrue:[
                    (nodesValue isArray) ifTrue:[
                        nodesValue traverse:[:eachElement |
                            (eachElement isString and:[eachElement isSymbol not]) ifTrue:[
                                (eachElement matchesRegex: myValue) ifTrue:[^ true].
                            ].
                        ].
                        ^ false.
                    ].
                ].
            ].
            ^ false.
        ].
        ^ super match: aNode inContext: aDictionary

    "Modified: / 09-08-2012 / 10:40:56 / cg"
! !

!RBLiteralNode methodsFor:'special queries'!

addUsedLiteralsTo:aCollection
    "adds the value of the literal to aCollection"
    
    token isPatternLiteral ifFalse:[
        aCollection add:token value
    ]

    "Created: / 12-10-2006 / 21:26:02 / cg"
!

addUsedSymbolsTo:aCollection
    |value|

    (value := token value) isSymbol ifTrue:[
        aCollection add:value
    ].
! !

!RBLiteralNode methodsFor:'testing'!

isImmediate
        ^true
!

isLiteral
        ^true
!

isLiteralArray
        ^ token isLiteralArray
!

isLiteralByteArray
        ^ token isLiteralByteArray
!

isLiteralCharacter
        ^ token isLiteralCharacter
!

isLiteralFloat
        ^ token isLiteralFloat
!

isLiteralInteger
        ^ token isLiteralInteger
!

isLiteralNode
        ^true
!

isLiteralNumber
        ^ token isLiteralNumber
!

isLiteralString
        ^ token isLiteralString

    "Created: / 28-12-2011 / 16:05:08 / cg"
!

isLiteralSymbol
        ^ token isLiteralSymbol
! !

!RBLiteralNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
        ^aProgramNodeVisitor acceptLiteralNode: self
! !

!RBLiteralNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

