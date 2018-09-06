"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueToken subclass:#RBLiteralToken
	instanceVariableNames:'stopPosition'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBLiteralToken class methodsFor:'instance creation'!

value: anObject 
        | literal |
        literal := anObject isArray 
                                ifTrue: [anObject collect: [:each | self value: each]]
                                ifFalse: [anObject].
        ^self 
                value: literal
                start: nil
                stop: nil
!

value: aString start: startInteger stop: stopInteger 
        ^self new
                value: aString
                start: startInteger
                stop: stopInteger
!

value: aString start: anInteger stop: stopInteger lineNumber:lineNumber
        ^self new
                value: aString
                start: anInteger
                stop: stopInteger
                lineNumber:lineNumber
! !

!RBLiteralToken methodsFor:'accessing'!

radix
    ^ nil
!

realValue
        ^value isArray
                ifTrue: [value collect: [:each | each realValue]]
                ifFalse: [value]
!

stop: stopInteger 
        self assert:stopInteger notNil.
        stopPosition := stopInteger
! !

!RBLiteralToken methodsFor:'initialization & release'!

start: startInteger stop: stopInteger 
        "/ self assert:startInteger notNil.
        "/ self assert:stopInteger notNil.

        sourcePointer := startInteger.
        stopPosition := stopInteger
!

value: aString start: startInteger stop: stopInteger 
        "/ self assert:startInteger notNil.
        "/ self assert:stopInteger notNil.

        value := aString.
        sourcePointer := startInteger.
        stopPosition := stopInteger.
!

value: aString start: startInteger stop: stopInteger lineNumber:lineNumberInteger
        "/ self assert:startInteger notNil.
        "/ self assert:stopInteger notNil.

        value := aString.
        sourcePointer := startInteger.
        stopPosition := stopInteger.
        lineNumber := lineNumberInteger.
        "/ self assert:(lineNumber notNil).
! !

!RBLiteralToken methodsFor:'private'!

length
        ^stopPosition - (self start ? 1) + 1
! !

!RBLiteralToken methodsFor:'testing'!

isLiteral
	^true
!

isLiteralArray
        ^ value isArray
!

isLiteralByteArray
        ^ value class == ByteArray
!

isLiteralCharacter
        ^ value class == Character
!

isLiteralFloat
        ^ value isFloat
!

isLiteralInteger
        ^ value isInteger
!

isLiteralString
        ^ value isKindOf: String

    "Created: / 28-12-2011 / 16:07:12 / cg"
!

isLiteralSymbol
        ^ value isSymbol

    "Created: / 28-12-2011 / 16:07:12 / cg"
!

isPatternLiteral
        ^false
! !

!RBLiteralToken class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

