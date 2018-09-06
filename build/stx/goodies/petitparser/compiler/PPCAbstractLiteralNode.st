"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCAbstractLiteralNode
	instanceVariableNames:'literal'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCAbstractLiteralNode methodsFor:'accessing'!

defaultName
    ^ #lit
!

literal
    
    ^ literal
!

literal: anObject
    
    literal := anObject
! !

!PPCAbstractLiteralNode methodsFor:'analysis'!

acceptsEpsilon
    ^ literal size = 0
!

firstCharSet
    | letter |
    letter := literal first.
    ^ PPCharSetPredicate on: [:e | e = letter ]
! !

!PPCAbstractLiteralNode methodsFor:'comparison'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ literal = anotherNode literal.
!

hash
    ^ super hash bitXor: literal hash
! !

!PPCAbstractLiteralNode methodsFor:'compiling'!

encodeQuotes: string
    | x s |
    s := WriteStream on: ''.
    1 to: string size do: [ :i|
        s nextPut: (x := string at: i).
        x = $' ifTrue: [ s nextPut: x ].
    ].
    ^ s contents
! !

